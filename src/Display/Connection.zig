const std = @import("std");
const protocol = @import("../protocol.zig");
const Auth = @import("Auth.zig");
const root = @import("../root.zig");

endian: std.builtin.Endian,
reader: std.Io.net.Stream.Reader,
writer: std.Io.net.Stream.Writer,
sequence: u16 = 0,
resource_id: ResourceId = .{},
setup_reply: protocol.core.setup.Reply = undefined,
root_screen: root.Screen = undefined,

pub const ResourceId = struct {
    base: u32 = 0,
    mask: u32 = 0,
    index: u32 = 0,

    pub fn next(self: *@This()) u32 {
        return self.base | (self.index & self.mask);
    }
};

pub const Request = struct {
    sequence: u16,

    pub const Header = extern struct {
        major_opcode: Opcode,
        minor_opcode: Opcode = .fromInt(0),
        length: Length = .fromWords(0),

        pub const Opcode = enum(u8) {
            _,

            pub fn fromInt(int: u8) @This() {
                return @enumFromInt(int);
            }
            pub fn toInt(self: @This()) u8 {
                return @intFromEnum(self);
            }
            pub fn core(opcode: protocol.core.Opcode) @This() {
                return @enumFromInt(@intFromEnum(opcode));
            }
            pub fn glx(opcode: protocol.glx.Opcode) @This() {
                return @enumFromInt(@intFromEnum(opcode));
            }
            pub fn randr(opcode: protocol.randr.Opcode) @This() {
                return @enumFromInt(@intFromEnum(opcode));
            }
        };

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
    };
};

pub const Reply = struct {
    header: Header,
    payload: std.Io.Reader,
    sequence: u16,

    pub const Header = extern struct {
        response_type: ResponseType,
        pad0: u8 = undefined,
        sequence: u16,
        length: u32,

        pub const ResponseType = enum(u8) {
            err = 0,
            reply = 1,
        };
    };
};

pub const Setup = struct {
    protocol_version_major: u16 = 11,
    protocol_version_minor: u16 = 0,
    auth: Auth,
    setup_listener: ?SetupListener = null,

    /// Provides setup information about the server, including vendor, screens, their depths, and pixel formats.
    /// The data received through these callbacks is only valid within the callback scope.
    /// Accessing it outside of these callbacks may result in undefined behavior.
    pub const SetupListener = struct {
        user_data: ?*anyopaque = null,
        /// Called once
        vendor: ?*const fn (user_data: ?*anyopaque, name: []const u8) anyerror!void = null,
        /// Called once for each pixmap format of a screen depth.
        pixmapFormat: ?*const fn (user_data: ?*anyopaque, format: root.PixmapFormat) anyerror!void = null,
        /// Called once for each screen.
        screen: ?*const fn (user_data: ?*anyopaque, screen: root.Screen) anyerror!void = null,
        /// Called once for each depth of a screen.
        screenDepth: ?*const fn (user_data: ?*anyopaque, screen: root.Screen, depth: root.Depth) anyerror!void = null,
        /// Called once for each visual in the depth of a screen.
        screenDepthVisual: ?*const fn (user_data: ?*anyopaque, screen: root.Screen, depth: root.Depth, visual: root.Visual) anyerror!void = null,
    };
};

pub const OpenOptions = struct {
    read_buffer_size: usize = 2048,
    write_buffer_size: usize = 1024,
    endian: std.builtin.Endian = .little,
};

pub fn open(io: std.Io, allocator: std.mem.Allocator, address: std.Io.net.UnixAddress, options: OpenOptions) !@This() {
    const stream = try address.connect(io);

    const reader_buffer = try allocator.alloc(u8, options.read_buffer_size);
    const reader = stream.reader(io, reader_buffer);
    const writer_buffer = try allocator.alloc(u8, options.write_buffer_size);
    const writer = stream.writer(io, writer_buffer);

    return .{
        .endian = options.endian,
        .reader = reader,
        .writer = writer,
    };
}

pub fn close(self: *@This(), allocator: std.mem.Allocator) void {
    allocator.free(self.reader.interface.buffer);
    allocator.free(self.writer.interface.buffer);
    self.reader.stream.close(self.reader.io);
    self.* = undefined;
}

pub fn flush(self: *@This()) (std.Io.net.Stream.Writer.WriteFileError || std.Io.Writer.Error)!void {
    std.log.info("flush: bytes = {any}", .{self.writer.interface.buffered()});
    self.writer.interface.flush() catch |err| return self.writer.write_file_err orelse err;
}

pub fn setup(self: *@This(), options: Setup) !void {
    const reader = &self.*.reader.interface;
    const writer = &self.*.writer.interface;

    const request_value: protocol.core.setup.Request = .{
        .byte_order = switch (self.endian) {
            .big => 'B',
            .little => 'l',
        },
        .protocol_version_major = options.protocol_version_major,
        .protocol_version_minor = options.protocol_version_minor,
        .auth_name_len = @intCast(options.auth.name.len),
        .auth_data_len = @intCast(options.auth.data.len),
        .auth = options.auth,
    };

    try marshal(writer, request_value, self.endian);
    try self.flush();

    try reader.fillMore();

    const status: Reply.Header.ResponseType = @enumFromInt(try reader.peekInt(u8, self.endian));
    if (status != .reply) {
        std.log.err("{s}", .{reader.buffered()[4..]});
        return error.SetupReply;
    }

    const reply = try unmarshal(reader, protocol.core.setup.Reply, self.endian);
    std.debug.assert(options.protocol_version_major <= reply.protocol_version_major);
    std.debug.assert(options.protocol_version_minor <= reply.protocol_version_minor);

    const vendor = std.mem.trimEnd(u8, try reader.take(reply.vendor_len), &.{0});
    if (options.setup_listener) |setup_listener| if (setup_listener.vendor) |f| try f(setup_listener.user_data, vendor);

    for (0..reply.pixmap_format_count) |_| {
        const pixmap_format = try unmarshal(reader, root.PixmapFormat, self.endian);
        if (options.setup_listener) |setup_listener| if (setup_listener.pixmapFormat) |f| try f(setup_listener.user_data, pixmap_format);
    }

    var root_screen: root.Screen = undefined;
    for (0..reply.screen_count) |i| {
        const screen = try unmarshal(reader, root.Screen, self.endian);
        if (i == 0) root_screen = screen;

        if (options.setup_listener) |setup_listener| if (setup_listener.screen) |f| try f(setup_listener.user_data, screen);

        for (0..screen.depths_count) |_| {
            const depth = try unmarshal(reader, root.Depth, self.endian);

            if (options.setup_listener) |setup_listener| if (setup_listener.screenDepth) |f| try f(setup_listener.user_data, screen, depth);

            for (0..depth.visuals_count) |_| {
                const visual = try unmarshal(reader, root.Visual, self.endian);
                if (options.setup_listener) |setup_listener| if (setup_listener.screenDepthVisual) |f| try f(setup_listener.user_data, screen, depth, visual);
            }
        }
    }

    reader.tossBuffered();

    self.resource_id = .{
        .base = reply.resource_id_base,
        .mask = reply.resource_id_mask,
    };
    self.setup_reply = reply;
}

pub fn writeRequest(self: *@This(), header: Request.Header, value: anytype) !Request {
    const writer = &self.*.writer.interface;
    var header_writer = writer.*;
    _ = try writer.splatByte(0, @sizeOf(Request.Header));
    try marshal(writer, value, self.endian);

    const length: Request.Header.Length = if (header.length.toWords() == 0) .fromBytes(writer.end - header_writer.end) else header.length;
    try header_writer.writeInt(u8, header.major_opcode.toInt(), self.endian);
    try header_writer.writeInt(u8, header.minor_opcode.toInt(), self.endian);
    try header_writer.writeInt(u16, length.toWords(), self.endian);

    self.sequence += 1;

    std.log.info("request\n\tsequence = {d}\n\tlen = {d} ({d} bytes)\n\theader: {any}\n\tbytes = {any}", .{ self.sequence, length.toWords(), length.toBytes(), header, writer.buffer[header_writer.end - @sizeOf(Request.Header) .. writer.end] });

    return .{ .sequence = self.sequence };
}

pub fn readReply(self: *@This()) !Reply {
    const reader = &self.*.reader.interface;

    const header = try unmarshal(reader, Reply.Header, self.endian);
    std.debug.assert(header.response_type == .reply);

    const payload = try reader.take(24 + header.length * 4);
    const payload_reader: std.Io.Reader = .fixed(payload);

    while (reader.bufferedLen() >= 4 and try reader.peekInt(u32, self.endian) == 0)
        reader.toss(4);

    std.log.info("reply\n\theader: {any}\n\tpayload: {any}\n\tleft over: {any}", .{ header, payload, reader.buffered() });

    return .{ .header = header, .payload = payload_reader, .sequence = header.sequence };
}

pub fn marshal(writer: *std.Io.Writer, value: anytype, endian: std.builtin.Endian) !void {
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
                .auto => try marshal(writer, field_val, endian),
                .@"extern" => @compileError("ill-defined memory layout"),
                .@"packed" => try writer.writeStruct(field_val, endian),
            },
            else => @compileError("can not write type of " ++ @typeName(field.type) ++ " aka " ++ @tagName(@typeInfo(field.type))),
        }
    }
}

// TODO: clean this up
pub fn unmarshal(reader: *std.Io.Reader, T: type, endian: std.builtin.Endian) !T {
    return switch (@typeInfo(T)) {
        .int => try reader.takeInt(T, endian),
        .@"enum" => try reader.takeEnum(T, endian),
        .@"struct" => {
            var value: T = std.mem.zeroes(T);

            inline for (@typeInfo(T).@"struct".fields) |field| @field(value, field.name) = switch (@typeInfo(field.type)) {
                .array => |arr| if (arr.child == u8) {
                    const read = try reader.take(arr.len);
                    @memcpy(@field(value, field.name)[0..arr.len], read);
                    continue;
                } else @compileError("can not read non u8 array"),
                .int => try reader.takeInt(field.type, endian),
                .bool => (try reader.takeInt(u8, endian)) == 1,
                .@"enum" => try reader.takeEnum(field.type, endian),
                .@"struct" => |s| switch (s.layout) {
                    .auto, .@"extern" => try unmarshal(reader, field.type, endian),
                    .@"packed" => try reader.takeStruct(field.type, endian),
                },
                else => @compileError("can not read type of " ++ @typeName(field.type) ++ " aka " ++ @tagName(@typeInfo(field.type))),
            };
            return value;
        },
        else => unreachable,
    };
}
