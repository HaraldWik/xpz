const std = @import("std");
const protocol = @import("protocol.zig");
const PixmapFormat = @import("root.zig").PixmapFormat;
const Screen = @import("root.zig").Screen;
const Visual = @import("root.zig").Visual;

const Client = @This();

allocator: std.mem.Allocator,
io: std.Io,

read_buffer_size: usize = 256,
/// Each `Connection` allocates this amount for the writer buffer.
write_buffer_size: usize = 256,

endian: std.builtin.Endian = .little,

auth: ?Auth = null,

/// Provides setup information about the server, including vendor, screens, their depths, and pixel formats.
/// The data received through these callbacks is only valid within the callback scope.
/// Accessing it outside of these callbacks may result in undefined behavior.
pub const SetupListener = struct {
    user_data: ?*anyopaque = null,
    /// Called once
    vendor: ?*const fn (user_data: ?*anyopaque, name: []const u8) anyerror!void = null,
    /// Called once for each pixmap format of a screen depth.
    pixmapFormat: ?*const fn (user_data: ?*anyopaque, format: PixmapFormat) anyerror!void = null,
    /// Called once for each screen.
    screen: ?*const fn (user_data: ?*anyopaque, screen: Screen) anyerror!void = null,
    /// Called once for each depth of a screen.
    screenDepth: ?*const fn (user_data: ?*anyopaque, screen: Screen, depth: Screen.Depth) anyerror!void = null,
    /// Called once for each visual in the depth of a screen.
    screenDepthVisual: ?*const fn (user_data: ?*anyopaque, screen: Screen, depth: Screen.Depth, visual: Visual) anyerror!void = null,
};

pub const Request = struct {
    connection: *Connection,
    opcode: Header,
    start: usize,
    end: usize,
    sequence: u16,

    pub const Length = enum(u16) {
        _,

        pub inline fn toBytes(self: @This()) usize {
            return @as(usize, @intCast(@intFromEnum(self))) * 4;
        }

        pub inline fn fromBytes(bytes: usize) @This() {
            return .fromWords(@intCast(@divExact(bytes, 4)));
        }

        pub inline fn toWords(self: @This()) u16 {
            return @intFromEnum(self);
        }

        pub inline fn fromWords(count: u16) @This() {
            return @enumFromInt(count);
        }
    };

    pub const Header = union(enum) {
        core: struct { major: protocol.core.Opcode, detail: u8 = 0 },
        glx: struct { major: u8, minor: protocol.glx.Opcode },
        randr: struct { major: u8, minor: protocol.randr.Opcode },

        pub fn major(self: @This()) u8 {
            return switch (self) {
                .core => |core| @intFromEnum(core.major),
                inline else => |ext| @field(ext, "major"),
            };
        }

        /// Returns detail when used on core
        pub fn minor(self: @This()) u8 {
            return switch (self) {
                .core => |core| core.detail,
                inline else => |ext| @intFromEnum(@field(ext, "minor")),
            };
        }
    };

    pub fn send(connection: *Connection, header: Request.Header, value: anytype) !Request {
        const writer = &connection.*.writer.interface;
        const request = try sendUnflushed(connection, header, value);
        try writer.flush();
        return request;
    }

    pub fn sendUnflushed(connection: *Connection, header: Request.Header, value: anytype) !Request {
        const io = connection.client.io;
        connection.mutex.lockUncancelable(io);
        defer connection.mutex.unlock(io);

        const endian = connection.client.endian;
        const writer = &connection.*.writer.interface;

        const start = writer.end;

        try writer.writeInt(u8, header.major(), endian);
        try writer.writeInt(u8, header.minor(), endian);
        try writer.writeInt(u16, 0, endian); // 0 for now

        try writeValue(writer, endian, value);

        const end = writer.end;

        connection.sequence += 1;

        std.log.info("header: {any}, request bytes: {any}", .{ header, writer.buffered()[start..end] });

        var request: @This() = .{ .connection = connection, .opcode = header, .start = start, .end = end, .sequence = connection.sequence };
        try request.setLength(.fromBytes(end - start));
        return request;
    }

    pub fn receiveReply(self: @This(), T: type) !Reply(T) {
        const connection = self.connection;
        const io = connection.client.io;
        connection.mutex.lockUncancelable(io);
        defer connection.mutex.unlock(io);

        const endian = connection.client.endian;
        const reader = &connection.*.reader.interface;
        if (reader.bufferedLen() < @sizeOf(Reply(T))) try reader.fillMore();
        const header = try readValue(reader, ReplyHeader, endian);
        const value = try readValue(reader, T, endian);
        if (header.sequence != self.sequence) return error.WrongSequence;
        if (header.response_type != .reply) return error.BadResponseType;

        return .{
            .header = header,
            .value = value,
        };
    }

    pub fn setLength(self: *@This(), length: Length) !void {
        const endian = self.connection.client.endian;
        const writer = &self.connection.*.writer.interface;
        var length_buffer: [@divExact(@typeInfo(@typeInfo(Request.Length).@"enum".tag_type).int.bits, 8)]u8 = undefined;
        std.mem.writeInt(u16, &length_buffer, length.toWords(), endian);
        writer.buffer[self.start + 2] = length_buffer[0];
        writer.buffer[self.start + 3] = length_buffer[1];
        self.end = self.start + length.toBytes();
    }

    fn readValue(reader: *std.Io.Reader, T: type, endian: std.builtin.Endian) !T {
        var value: T = std.mem.zeroes(T);
        inline for (@typeInfo(T).@"struct".fields) |field| @field(value, field.name) = switch (@typeInfo(field.type)) {
            .array => |arr| if (arr.child == u8) {
                const read = try reader.take(arr.len);
                @memcpy(@field(value, field.name)[0..arr.len], read);
                continue;
            } else @compileError("can not read non u8 array"),
            .int => try reader.takeInt(field.type, endian),
            .bool => (try reader.takeInt(field.type, endian)) == 1,
            .@"enum" => try reader.takeEnum(field.type, endian),
            .@"struct" => try readValue(reader, endian, T),
            else => @compileError("can not read type of " ++ @typeName(field.type) ++ " aka " ++ @tagName(@typeInfo(field.type))),
        };
        return value;
    }

    fn writeValue(writer: *std.Io.Writer, endian: std.builtin.Endian, value: anytype) !void {
        inline for (@typeInfo(@TypeOf(value)).@"struct".fields) |field| {
            const field_val = @field(value, field.name);
            switch (@typeInfo(field.type)) {
                .pointer => |ptr| {
                    if (ptr.child == u8)
                        try writer.writeAll(field_val)
                    else
                        try writer.writeSliceEndian(ptr.child, field_val, endian);
                    _ = try writer.splatByte(0, (4 - (writer.end % 4)) % 4); // Padding
                },
                .array => |arr| if (arr.child == u8)
                    try writer.writeAll(&field_val)
                else
                    try writer.writeSliceEndian(arr.child, field_val, endian),
                .int => try writer.writeInt(field.type, field_val, endian),
                .bool => try writer.writeInt(u8, @intFromBool(field_val), endian),
                .@"enum" => |e| try writer.writeInt(e.tag_type, @intFromEnum(field_val), endian),
                .@"struct" => |s| switch (s.layout) {
                    .auto, .@"extern" => try writeValue(writer, endian, field_val),
                    .@"packed" => try writer.writeStruct(field_val, endian),
                },
                else => @compileError("can not write type of " ++ @typeName(field.type) ++ " aka " ++ @tagName(@typeInfo(field.type))),
            }
        }
    }
};

pub fn Reply(T: type) type {
    return struct {
        header: ReplyHeader,
        value: T,
    };
}

pub const ReplyHeader = struct {
    response_type: ResponseType,
    pad0: u8 = undefined,
    sequence: u16,
    length: u32,

    pub const ResponseType = enum(u8) {
        err = 0,
        reply = 1,
    };
};

pub const Connection = struct {
    client: *Client,
    reader: std.Io.net.Stream.Reader,
    writer: std.Io.net.Stream.Writer,
    sequence: u16 = 0,
    resource_id: ResourceId = .{},
    mutex: std.Io.Mutex = .init,

    pub const default_address: std.Io.net.UnixAddress = .{ .path = "/tmp/.X11-unix/X0" };

    pub const SetupOptions = struct {
        protocol_version_major: u16 = 11,
        protocol_version_minor: u16 = 0,
        setup_listener: ?SetupListener = null,
    };

    pub const ResourceId = struct {
        base: u32 = 0,
        mask: u32 = 0,
        index: u32 = 0,

        pub fn next(self: *@This()) u32 {
            return self.base | (self.index & self.mask);
        }
    };

    pub fn setup(self: *@This(), minimal: std.process.Init.Minimal) !Screen {
        return self.setupOptions(minimal, .{});
    }

    /// Returns the root screen
    pub fn setupOptions(self: *@This(), minimal: std.process.Init.Minimal, options: SetupOptions) !Screen {
        const io = self.client.io;
        const endian = self.client.endian;
        const reader = &self.reader.interface;
        const writer = &self.writer.interface;

        self.mutex.lockUncancelable(io);
        defer self.mutex.unlock(io);

        var auth_buffer: [128]u8 = undefined;
        const auth: Auth = self.client.auth orelse
            if (minimal.environ.getPosix(Auth.@"MIT-MAGIC-COOKIE-1".XAUTHORITY)) |xauthority| try Auth.@"MIT-MAGIC-COOKIE-1".get(io, &auth_buffer, xauthority) else .none;

        const request_value: protocol.core.setup.Request = .{
            .byte_order = switch (endian) {
                .big => 'B',
                .little => 'l',
            },
            .protocol_version_major = options.protocol_version_major,
            .protocol_version_minor = options.protocol_version_minor,
            .auth_name_len = @intCast(auth.name.len),
            .auth_data_len = @intCast(auth.data.len),
            .auth = auth,
        };
        try Request.writeValue(writer, endian, request_value);
        try writer.flush();

        // Read setup
        try reader.fillMore();

        const status: ReplyHeader.ResponseType = @enumFromInt(try reader.peekInt(u8, endian));
        if (status != .reply) {
            std.log.err("{s}", .{reader.buffered()[4..]});
            return error.SetupReply;
        }

        const reply = try reader.takeStruct(protocol.core.setup.Reply, endian);
        std.debug.assert(options.protocol_version_major <= reply.protocol_version_major);
        std.debug.assert(options.protocol_version_minor <= reply.protocol_version_minor);

        const vendor = std.mem.trimEnd(u8, try reader.take(reply.vendor_len), &.{0});
        if (options.setup_listener) |setup_listener| if (setup_listener.vendor) |f| try f(setup_listener.user_data, vendor);

        for (0..reply.pixmap_format_count) |_| {
            const pixmap_format = try reader.takeStruct(PixmapFormat, endian);
            if (options.setup_listener) |setup_listener| if (setup_listener.pixmapFormat) |f| try f(setup_listener.user_data, pixmap_format);
        }

        var root_screen: Screen = undefined;
        for (0..reply.screen_count) |i| {
            const screen = try reader.takeStruct(Screen, endian);
            if (i == 0) root_screen = screen;

            if (options.setup_listener) |setup_listener| if (setup_listener.screen) |f| try f(setup_listener.user_data, screen);

            for (0..screen.depths_count) |_| {
                const depth = try reader.takeStruct(Screen.Depth, endian);

                if (options.setup_listener) |setup_listener| if (setup_listener.screenDepth) |f| try f(setup_listener.user_data, screen, depth);

                for (0..depth.visuals_count) |_| {
                    const visual = try reader.takeStruct(Visual, endian);
                    if (options.setup_listener) |setup_listener| if (setup_listener.screenDepthVisual) |f| try f(setup_listener.user_data, screen, depth, visual);
                }
            }
        }

        reader.tossBuffered();

        self.resource_id = .{
            .base = reply.resource_id_base,
            .mask = reply.resource_id_mask,
        };
        return root_screen;
    }

    pub fn destroy(self: *@This()) void {
        const allocator = self.client.allocator;
        allocator.free(self.reader.interface.buffer);
        allocator.free(self.writer.interface.buffer);
        self.reader.stream.close(self.client.io);
        self.* = undefined;
    }

    pub fn flush(self: *@This()) std.Io.Writer.Error!void {
        try self.writer.interface.flush();
    }

    pub fn sendRequest(self: *@This(), header: Request.Header, value: anytype) !Request {
        return .send(self, header, value);
    }

    pub fn sendRequestUnflushed(self: *@This(), header: Request.Header, value: anytype) !Request {
        return .sendUnflushed(self, header, value);
    }
};

pub fn connectUnix(client: *@This(), address: std.Io.net.UnixAddress) !Connection {
    const allocator = client.allocator;
    const io = client.io;
    const stream = try address.connect(io);

    const read_buffer = try allocator.alloc(u8, client.read_buffer_size);
    const reader = stream.reader(io, read_buffer);
    const write_buffer = try allocator.alloc(u8, client.write_buffer_size);
    const writer = stream.writer(io, write_buffer);

    return .{
        .client = client,
        .reader = reader,
        .writer = writer,
    };
}

/// "xhost +local:" removes the need to authenticate
/// "xhost -local:" adds the need to authenticate
/// https://x.org/releases/X11R7.5/doc/man/man7/Xsecurity.7.html
pub const Auth = struct {
    name: []const u8,
    data: []const u8,

    pub const none: @This() = .{ .name = "", .data = "" };

    /// The most common auth protocol
    pub const @"MIT-MAGIC-COOKIE-1" = struct {
        pub const XAUTHORITY = "XAUTHORITY";

        pub const protocol_name = "MIT-MAGIC-COOKIE-1";

        /// xauthority can be found in enviorment variable $XAUTHORITY
        pub fn get(io: std.Io, buffer: []u8, xauthority: []const u8) !Auth {
            const file = try std.Io.Dir.openFileAbsolute(io, xauthority, .{});
            defer file.close(io);

            var file_reader = file.reader(io, buffer);
            const reader = &file_reader.interface;

            const data: []const u8 = while (true) {
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

                if (std.mem.eql(u8, name, protocol_name)) break data;

                reader.tossBuffered();
            } else {
                @branchHint(.unlikely);
                return error.NoAuthDataFound;
            };

            return .{
                .name = protocol_name,
                .data = data,
            };
        }
    };

    pub const @"XDM-AUTHORIZATION-1" = struct {
        pub const protocol_name = "XDM-AUTHORIZATION-1";
    };
};
