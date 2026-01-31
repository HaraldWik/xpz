const std = @import("std");
const protocol = @import("protocol.zig");
const Screen = @import("root.zig").Screen;

pub const default_display_path = "/tmp/.X11-unix/X0";

reader: *std.Io.Reader,
writer: *std.Io.Writer,

endianness: std.builtin.Endian,

// setup reply
server_info: protocol.setup.ServerInfo,
capabilities: protocol.setup.Capabilities,

root_screen: Screen,

pub const Options = struct {
    endianness: std.builtin.Endian = .native,
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
        .byte_order = switch (options.endianness) {
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
    try reader.fill(8);
    const status = try reader.takeInt(u8, options.endianness);
    if (status != 1) {
        const reason_len = try reader.takeInt(u8, options.endianness);
        const reason = try reader.take(reason_len);
        std.log.err(" {s}", .{reason[1..]});
        return error.SetupReply;
    }
    _ = try reader.takeByte(); // Ignore reason_len
    const major_version = try reader.takeInt(u16, options.endianness);
    const minor_version = try reader.takeInt(u16, options.endianness);
    const len = try reader.takeInt(u16, options.endianness);
    _ = len;
    if (major_version < connect.protocol_major or minor_version < connect.protocol_minor) return error.ServerUnsupportedProtocolVersion;

    try reader.fillMore();

    const server_info = try reader.takeStruct(protocol.setup.ServerInfo, options.endianness);
    const capabilities = try reader.takeStruct(protocol.setup.Capabilities, options.endianness);
    const vendor = try reader.take(server_info.vendor_len + 3);
    std.debug.print("vendor: {s}\n", .{vendor});
    reader.end += (4 - (reader.end % 4)) % 4; // Padding

    const formats_len = 8 * capabilities.pixmap_format_count;
    const screens_offset = server_info.vendor_len + formats_len;
    // reader.toss(screens_offset);
    // reader.seek += screens_offset;
    _ = screens_offset;
    const root_screen = try reader.takeStruct(Screen, options.endianness);

    std.debug.print("client init success\n", .{});

    return .{
        .reader = reader,
        .writer = writer,
        .endianness = options.endianness,
        .server_info = server_info,
        .capabilities = capabilities,
        .root_screen = root_screen,
    };
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

                std.debug.print(
                    \\family: {d}
                    \\  address: {s}
                    \\  display: {any}
                    \\  name:    {s}
                    \\  data:    {any}
                    \\
                , .{ family, address, display, name, data });

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
