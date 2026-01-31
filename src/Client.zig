const std = @import("std");
const protocol = @import("protocol.zig");
const Screen = @import("root.zig").Screen;

pub const default_display_path = "/tmp/.X11-unix/X0";

reader: *std.Io.Reader,
writer: *std.Io.Writer,

endian: std.builtin.Endian,

// setup reply
setup: protocol.Setup,

root_screen: Screen,

pub const Options = struct {
    endian: std.builtin.Endian = .native,
    protocol_major: u16 = 11,
    protocol_minor: u16 = 0,
    auth: Auth,
};

pub fn init(io: std.Io, reader: *std.Io.Reader, writer: *std.Io.Writer, options: Options) !@This() {
    var auth_buffer: [128]u8 = undefined;
    const auth_name = options.auth.getName();
    const auth_data: []const u8 = switch (options.auth) {
        .mit_magic_cookie_1 => |auth| try auth.init(io, &auth_buffer),
        .xdm_authorization_1 => @panic("currently unsupported auth protocol"),
        .none => "",
    };

    const connect: protocol.Setup.Request = .{
        .byte_order = switch (options.endian) {
            .big => 'B',
            .little => 'l',
        },
        .protocol_major = options.protocol_major,
        .protocol_minor = options.protocol_minor,
        .auth_name_len = @intCast(auth_name.len),
        .auth_data_len = @intCast(auth_data.len),
    };

    try writer.writeStruct(connect, .little);
    if (try writer.write(auth_name) != auth_name.len) return error.BufferTooSmall;
    writer.end += (4 - (writer.end % 4)) % 4; // Padding
    if (try writer.write(auth_data) != auth_data.len) return error.BufferTooSmall;
    writer.end += (4 - (writer.end % 4)) % 4; // Padding
    try writer.flush();

    // Read setup
    try reader.fillMore();

    const status = try reader.peekInt(u8, options.endian);
    if (status != 1) {
        const reason_len = try reader.takeInt(u8, options.endian);
        const reason = try reader.take(reason_len);
        std.log.err(" {s}", .{reason[1..]});
        return error.SetupReply;
    }

    const setup = try reader.takeStruct(protocol.Setup, options.endian);
    // const vendor = try reader.peek(setup.vendor_len + 3);
    // std.debug.print("vendor: {s}\n", .{vendor});

    const vendor_pad = (4 - (setup.vendor_len % 4)) % 4;
    const formats_len = 8 * setup.pixmap_formats_len;
    const screens_offset = setup.vendor_len + vendor_pad + formats_len;
    reader.toss(screens_offset);
    const root_screen = try reader.takeStruct(Screen, options.endian);

    return .{
        .reader = reader,
        .writer = writer,
        .endian = options.endian,
        .setup = setup,
        .root_screen = root_screen,
    };
}

pub fn generateId(self: @This(), comptime T: type, resource_index: u32) T {
    const id = self.setup.resource_id_base | (resource_index & self.setup.resource_id_mask);
    switch (@typeInfo(T)) {
        .@"enum" => |e| {
            if (e.tag_type != u32) @compileError("expected enum with tag type of u32 found '" ++ @typeName(e.tag_type) ++ "'");
            return @enumFromInt(id);
        },
        .int => |i| {
            if (i.signedness == .signed or i.bits != 32) @compileError("expected u32 found '" ++ @typeName(T) ++ "'");
            return id;
        },
        else => @compileError("invalid type given to nextId"),
    }
}

/// "xhost +local:" removes the need to authenticate
/// "xhost -local:" adds the need to authenticate
/// https://x.org/releases/X11R7.5/doc/man/man7/Xsecurity.7.html
pub const Auth = union(enum) {
    mit_magic_cookie_1: @"MIT-MAGIC-COOKIE-1",
    xdm_authorization_1: @"XDM-AUTHORIZATION-1",
    none: None,

    pub const @"MIT-MAGIC-COOKIE-1" = struct {
        /// Can be found in enviorment variable $XAUTHORITY
        xauthority: []const u8,

        pub const protocol_name = "MIT-MAGIC-COOKIE-1";

        pub fn init(self: @This(), io: std.Io, buffer: []u8) ![]const u8 {
            const file = try std.Io.Dir.openFileAbsolute(io, self.xauthority, .{});
            defer file.close(io);

            var file_reader = file.reader(io, buffer);
            const reader = &file_reader.interface;

            while (true) {
                try reader.fill(4);
                const family = try reader.takeInt(u16, .big);

                const address_len = try reader.takeInt(u16, .big);
                const address = try reader.take(address_len);

                const display_len = try reader.takeInt(u16, .big);
                const display = try reader.take(display_len);

                const name_len = try reader.takeInt(u16, .big);
                const name = try reader.take(name_len);

                const data_len = try reader.takeInt(u16, .big);
                const data = try reader.take(data_len);

                // std.debug.print(
                //     \\family: {d}
                //     \\  address: {s}
                //     \\  display: {any}
                //     \\  name:    {s}
                //     \\  data:    {any}
                //     \\
                // , .{ family, address, display, name, data });
                _ = family;
                _ = address;
                _ = display;

                if (std.mem.eql(u8, name, protocol_name)) return data;

                reader.tossBuffered();
            }
        }
    };

    pub const @"XDM-AUTHORIZATION-1" = struct {
        pub const protocol_name = "XDM-AUTHORIZATION-1";
    };

    pub const None = struct {
        pub const protocol_name = "";
    };

    pub fn getName(self: @This()) []const u8 {
        return switch (self) {
            inline else => |p| @TypeOf(p).protocol_name,
        };
    }
};
