const std = @import("std");
const protocol = @import("../../protocol.zig");
const Auth = @import("Auth.zig");
const core = @import("../core.zig");

endian: std.builtin.Endian,
reader: std.Io.net.Stream.Reader,
writer: std.Io.net.Stream.Writer,
sequence: u16 = 0,
resource_id: ResourceId = .{},
setup_reply: protocol.core.setup.Reply = undefined,
root_screen: core.Screen = undefined,

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
    protocol_major_version: u16 = 11,
    protocol_minor_version: u16 = 0,
    auth: Auth,
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
    // std.log.info("flush: bytes = {any}", .{self.writer.interface.buffered()});
    self.writer.interface.flush() catch |err| return self.writer.write_file_err orelse err;
}

pub fn setup(self: *@This(), allocator: std.mem.Allocator, options: Setup) !void {
    const reader = &self.*.reader.interface;
    const writer = &self.*.writer.interface;

    const request: protocol.core.setup.Request = .{
        .byte_order = switch (self.endian) {
            .big => 'B',
            .little => 'l',
        },
        .protocol_major_version = options.protocol_major_version,
        .protocol_minor_version = options.protocol_minor_version,
        .authorization_protocol_name_len = @intCast(options.auth.name.len),
        .authorization_protocol_data_len = @intCast(options.auth.data.len),
        .authorization_protocol_name = options.auth.name,
        .authorization_protocol_data = options.auth.data,
    };

    try marshal(writer, request, self.endian);
    try self.flush();

    try reader.fillMore();

    switch (try reader.peekByte()) {
        1 => {},
        2 => {
            const authenticate = try unmarshal(null, reader, protocol.core.setup.Failed.Authenticate, self.endian, true);
            std.log.err("authenticate: {s}", .{authenticate.reason});
            return error.Authenticate;
        },
        else => {
            const failed = try unmarshal(null, reader, protocol.core.setup.Failed, self.endian, true);
            std.log.err("{s}", .{failed.reason});
            return error.Setup;
        },
    }

    const status: Reply.Header.ResponseType = @enumFromInt(try reader.peekInt(u8, self.endian));
    if (status != .reply) {
        std.log.err("{s}", .{reader.buffered()[4..]});
        return error.SetupReply;
    }

    var reply: protocol.core.setup.Reply = try unmarshal(allocator, reader, protocol.core.setup.Reply, self.endian, true);
    std.debug.assert(options.protocol_major_version <= reply.protocol_major_version);
    std.debug.assert(options.protocol_minor_version <= reply.protocol_minor_version);

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

    // std.log.info("request\n\tsequence = {d}\n\tlen = {d} ({d} bytes)\n\theader: {any}\n\tbytes = {any}", .{ self.sequence, length.toWords(), length.toBytes(), header, writer.buffer[header_writer.end - @sizeOf(Request.Header) .. writer.end] });

    return .{ .sequence = self.sequence };
}

pub fn readReply(self: *@This()) !Reply {
    const reader = &self.*.reader.interface;
    const buf = reader.buffered();
    const header = try unmarshal(null, reader, Reply.Header, self.endian, true);
    std.log.debug("buf: {d} {any}", .{ buf.len, buf });
    std.log.debug("reply header: {any}", .{header});
    // std.debug.assert(header.response_type == .reply);

    const payload = try reader.take(24 +| header.length *| 4);
    const payload_reader: std.Io.Reader = .fixed(payload);

    while (reader.bufferedLen() >= 4 and try reader.peekInt(u32, self.endian) == 0)
        reader.toss(4);

    std.log.info("reply\n\theader: {any}\n\tpayload: {any}\n\tleft over: {any}", .{ header, payload, reader.buffered() });

    return .{ .header = header, .payload = payload_reader, .sequence = header.sequence };
}

pub fn marshal(writer: *std.Io.Writer, value: anytype, endian: std.builtin.Endian) !void {
    const Value: type = @TypeOf(value);
    switch (@typeInfo(Value)) {
        .bool => try writer.writeInt(u8, @intFromBool(value), endian),
        .int => try writer.writeInt(Value, value, endian),
        .float => |float| try writer.writeInt(@Int(.signed, float.bits), @bitCast(float), endian),
        .pointer => |pointer| {
            if (pointer.child == u8)
                try writer.writeAll(value)
            else
                try writer.writeSliceEndian(pointer.child, value, endian);
            _ = try writer.splatByte(0, (4 - (writer.end % 4)) % 4); // Padding
        },
        .array => |arr| if (arr.child == u8)
            try writer.writeAll(&value)
        else
            try writer.writeSliceEndian(arr.child, value, endian),
        .@"struct" => |@"struct"| switch (@"struct".layout) {
            .auto => inline for (std.meta.fields(Value)) |field| {
                const field_value = @field(value, field.name);
                try marshal(writer, field_value, endian);
            },
            .@"extern" => @compileError("preferred to not serialize structs with extern layout"),
            .@"packed" => try writer.writeStruct(value, endian),
        },
        .@"enum" => |@"enum"| try writer.writeInt(@"enum".tag_type, @intFromEnum(value), endian),
        .enum_literal => try writer.writeAll(@tagName(value)),
        else => @compileError("can not serialize type of " ++ @typeName(Value) ++ " aka " ++ @tagName(@typeInfo(Value))),
    }
}

/// Slices require an allocator
pub fn unmarshal(opt_allocator: ?std.mem.Allocator, reader: *std.Io.Reader, Out: type, endian: std.builtin.Endian, deserialize_slices: bool) !Out {
    return switch (@typeInfo(Out)) {
        .bool => try reader.takeByte() == 1,
        .int => try reader.takeInt(Out, endian),
        .float => std.mem.readInt(Out, try reader.takeArray(@sizeOf(Out)), endian),
        .@"enum" => try reader.takeEnum(Out, endian),
        .@"struct" => {
            var out: Out = std.mem.zeroes(Out);

            inline for (@typeInfo(Out).@"struct".fields) |field| @field(out, field.name) = switch (@typeInfo(field.type)) {
                .bool => try reader.takeByte() == 1,
                .int => try reader.takeInt(field.type, endian),
                .float => std.mem.readInt(field.type, try reader.takeArray(@sizeOf(Out)), endian),
                .pointer => |ptr| if (deserialize_slices) slice: {
                    const element_len_name = field.name ++ "_len";
                    std.debug.assert(@typeInfo(@FieldType(Out, element_len_name)) == .int);
                    const element_len: usize = @field(out, element_len_name);
                    if (ptr.child == u8) {
                        const slice = try reader.take(element_len);
                        reader.toss((4 - (slice.len % 4)) % 4);
                        break :slice if (opt_allocator) |allocator| try allocator.dupe(u8, slice) else slice;
                    } else {
                        // std.debug.print("20 bytes pre {any}\t", .{reader.buffer[reader.seek - 10 .. reader.seek]});
                        const total_bytes = element_len * getDeserializeSize(ptr.child);
                        // std.debug.print("total_bytes: {d} {s} = {d}, bytes: {any}\n", .{ total_bytes, element_len_name, element_len, reader.buffered()[0..total_bytes] });
                        const padding = (4 - (total_bytes % 4)) % 4;

                        if (opt_allocator) |allocator| {
                            const slice = try allocator.alloc(ptr.child, element_len);

                            for (0..element_len) |i| {
                                slice[i] = try unmarshal(allocator, reader, ptr.child, endian, true);
                            }
                            reader.toss(padding); // Padding

                            break :slice slice;
                        } else {
                            for (0..element_len) |_| {
                                _ = try unmarshal(null, reader, ptr.child, endian, true);
                            }
                            reader.toss(padding); // Padding

                            break :slice &.{};
                        }
                    }
                } else &.{},
                .array => |array| if (array.child == u8) (try reader.takeArray(array.len)).* else array: {
                    var val: field.type = std.mem.zeroes(field.type);
                    for (0..array.len) |i| {
                        val[i] = try unmarshal(reader, array.child, endian, deserialize_slices, false);
                    }
                    break :array val;
                },
                .@"enum" => e: {
                    break :e reader.takeEnum(field.type, endian) catch |err| {
                        std.log.err("{s} {s} {s}", .{ @errorName(err), @typeName(Out), field.name });
                        return err;
                    };
                },
                .@"struct" => |s| switch (s.layout) {
                    .auto, .@"extern" => try unmarshal(reader, field.type, endian),
                    .@"packed" => try reader.takeStruct(field.type, endian),
                },
                else => @compileError("can not read type of " ++ @typeName(field.type) ++ " aka " ++ @tagName(@typeInfo(field.type))),
            };
            return out;
        },
        else => unreachable,
    };
}

pub fn freeDeserialize(allocator: std.mem.Allocator, value: anytype) void {
    for (std.meta.fields(@TypeOf(value))) |field| {
        switch (@typeInfo(field.type)) {
            .pointer => allocator.free(@field(value, field.name)),
            .@"struct" => freeDeserialize(allocator, @field(value, field.name)),
            else => {},
        }
    }
}

pub fn getDeserializeSize(comptime T: type) usize {
    var size: usize = 0;
    switch (@typeInfo(T)) {
        .pointer => {},
        .array => |array| size += @sizeOf(array.child) * array.len,
        .@"struct" => |@"struct"| switch (@"struct".layout) {
            .auto, .@"extern" => inline for (std.meta.fields(T)) |field| {
                size += getDeserializeSize(field.type);
            },
            .@"packed" => size += @"struct".backing_integer.?,
        },
        else => size += @sizeOf(T),
    }
    return size;
}

fn getFieldPostPadding(comptime T: type, comptime field_name: []const u8) usize {
    const fields = @typeInfo(T).Struct.fields;

    // Find the index of the requested field
    var field_index: usize = undefined;
    for (fields, 0..) |field, i| {
        if (std.mem.eql(u8, field.name, field_name)) {
            field_index = i;
            break;
        }
    } else {
        @compileError("Field '" ++ field_name ++ "' not found in struct");
    }

    // If this is the last field, padding is to align the struct itself
    if (field_index == fields.len - 1) {
        const struct_size = @sizeOf(T);
        const struct_alignment = @alignOf(T);
        return (struct_alignment - (struct_size % struct_alignment)) % struct_alignment;
    }

    // Otherwise, padding is the difference to the next field's offset
    const current_field_offset = @offsetOf(T, field_name);
    const current_field_size = @sizeOf(fields[field_index].type);
    const next_field_offset = @offsetOf(T, fields[field_index + 1].name);

    return next_field_offset - (current_field_offset + current_field_size);
}
