const std = @import("std");
const protocol = @import("protocol.zig");
const PixmapFormat = @import("root.zig").PixmapFormat;
const Screen = @import("root.zig").Screen;
const Visual = @import("root.zig").Visual;

pub const default_display_path = "/tmp/.X11-unix/X0";

reader: *std.Io.Reader,
writer: *std.Io.Writer,

endian: std.builtin.Endian,

// setup reply
setup: protocol.setup.Reply,

root_screen: Screen,

pub const Options = struct {
    endian: std.builtin.Endian = .native,
    protocol_major: u16 = 11,
    protocol_minor: u16 = 0,
    auth: Auth,
    screens: []Screen,
};

pub fn init(io: std.Io, reader: *std.Io.Reader, writer: *std.Io.Writer, options: Options) !@This() {
    var auth_buffer: [128]u8 = undefined;
    const auth_name = options.auth.getName();
    const auth_data: []const u8 = switch (options.auth) {
        .mit_magic_cookie_1 => |auth| auth.init(io, &auth_buffer) catch |err| switch (err) {
            error.FileNotFound => "",
            else => return err,
        },
        .xdm_authorization_1 => @panic("currently unsupported auth protocol"),
        .custom => |auth| auth.data,
        .none => "",
    };

    const request: protocol.setup.Request = .{
        .byte_order = switch (options.endian) {
            .big => 'B',
            .little => 'l',
        },
        .protocol_major = options.protocol_major,
        .protocol_minor = options.protocol_minor,
        .auth_name_len = @intCast(auth_name.len),
        .auth_data_len = @intCast(auth_data.len),
    };

    try writer.writeStruct(request, .little);
    if (try writer.write(auth_name) != auth_name.len) return error.BufferTooSmall;
    writer.end += (4 - (writer.end % 4)) % 4; // Padding
    if (try writer.write(auth_data) != auth_data.len) return error.BufferTooSmall;
    writer.end += (4 - (writer.end % 4)) % 4; // Padding
    try writer.flush();

    // Read setup
    try reader.fillMore();

    const status: protocol.ReplyHeader.ResponseType = @enumFromInt(try reader.peekInt(u8, options.endian));
    switch (status) {
        .reply => {}, // Success
        .err => {
            const reason_len = try reader.takeInt(u8, options.endian);
            const reason = try reader.take(reason_len);
            if (reason.len != 0) std.log.err("{s}", .{reason[1..]});
            return error.SetupReply;
        },
        .auth => {
            const reason_len = try reader.takeInt(u8, options.endian);
            const reason = try reader.take(reason_len);
            if (reason.len != 0) std.log.err("{s}", .{reason[1..]});
            return error.AuthenticateRequired;
        },
        _ => {},
    }

    const reply = try reader.takeStruct(protocol.setup.Reply, options.endian);

    const vendor = std.mem.trimEnd(u8, try reader.take(reply.vendor_len), &.{0});
    std.debug.print("vendor: {s}\n", .{vendor});

    for (0..reply.pixmap_format_count) |i| {
        const pixmap_format = try reader.takeStruct(PixmapFormat, options.endian);
        std.log.info("pixmap_format: {d} {any}", .{ i, pixmap_format });
    }

    var root_screen: Screen = undefined;
    for (0..reply.screen_count) |i| {
        const screen = try reader.takeStruct(Screen, options.endian);
        if (i == 0) root_screen = screen;

        std.log.info(
            "screen {d}: {d}x{d} {d}x{d}mm",
            .{ i, screen.width, screen.height, screen.width_mm, screen.height_mm },
        );

        for (0..screen.depths_count) |_| {
            const depth = try reader.takeStruct(Screen.Depth, options.endian);
            std.log.info("\tdepth: {any}", .{depth});

            for (0..depth.visuals_count) |_| {
                const visual_type = try reader.takeStruct(Visual, options.endian);
                std.log.info("\t\tvisual: {any}", .{visual_type});
            }
        }
    }

    reader.tossBuffered();

    return .{
        .reader = reader,
        .writer = writer,
        .endian = options.endian,
        .setup = reply,
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

pub fn checkError(self: @This()) !protocol.ReplyHeader.ResponseType {
    const response_type: protocol.ReplyHeader.ResponseType = @enumFromInt(try self.reader.peekInt(u8, self.endian));

    if (response_type == .err) return switch (try self.reader.peekInt(u8, self.endian)) {
        0 => return response_type,
        1 => error.Request,
        2 => error.Value,
        3 => error.Window,
        4 => error.Pixmap,
        5 => error.Atom,
        6 => error.Cursor,
        7 => error.Font,
        8 => error.Match,
        9 => error.Drawable,
        10 => error.Access,
        11 => error.Alloc,
        12 => error.Colormap,
        13 => error.GC,
        14 => error.IDChoice,
        15 => error.Name,
        16 => error.Length,
        17 => error.Implementation,
        else => |code| {
            std.log.err("unknown error code: {d}", .{code});
            return error.Unknown;
        },
    };
    return response_type;
}

/// "xhost +local:" removes the need to authenticate
/// "xhost -local:" adds the need to authenticate
/// https://x.org/releases/X11R7.5/doc/man/man7/Xsecurity.7.html
pub const Auth = union(enum) {
    mit_magic_cookie_1: @"MIT-MAGIC-COOKIE-1",
    xdm_authorization_1: @"XDM-AUTHORIZATION-1",
    custom: Custom,
    none: None,

    pub const @"MIT-MAGIC-COOKIE-1" = struct {
        /// Can be found in enviorment variable $XAUTHORITY
        xauthority: []const u8,

        pub const XAUTHORITY = "XAUTHORITY";

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
            } else {
                @branchHint(.unlikely);
                return error.NoAuthDataFound;
            }
        }
    };

    pub const @"XDM-AUTHORIZATION-1" = struct {
        pub const protocol_name = "XDM-AUTHORIZATION-1";
    };

    pub const Custom = struct {
        protocol_name: []const u8,
        data: []const u8,
    };

    pub const None = struct {
        pub const protocol_name = "";
    };

    pub fn getName(self: @This()) []const u8 {
        return switch (self) {
            .custom => self.custom.protocol_name,
            inline else => |p| @TypeOf(p).protocol_name,
        };
    }
};
