const std = @import("std");

const Display = @This();

allocator: std.mem.Allocator,
io: std.Io,
connection: Connection,
mutux: std.Io.Mutex = .init,

replies: std.Deque(Connection.Reply) = .empty,

pub const default_address: std.Io.net.UnixAddress = .{ .path = "/tmp/.X11-unix/X0" };

pub const Auth = @import("Display/Auth.zig");
pub const Connection = @import("Display/Connection.zig");

pub fn Cookie(Reply: type) type {
    return struct {
        display: *Display,
        sequence: u16,
        reply: ?Reply = null,
        reply_inner: ?Connection.Reply = null,

        pub fn getReply(self: *@This()) !Reply {
            if (self.reply) |reply| return reply;

            while (true) {
                var it = self.display.replies.iterator();
                while (it.next()) |reply| {
                    var reply_copy = reply;
                    if (reply_copy.sequence != self.sequence) continue;

                    const value = try Connection.unmarshal(&reply_copy.payload, Reply, self.display.connection.endian);
                    self.reply = value;
                    self.reply_inner = reply_copy;
                    return value;
                }
                if (try self.display.dispatch() <= 0) break;
            }
            return error.NoReplyFound;
        }
    };
}

pub fn connect(allocator: std.mem.Allocator, io: std.Io, address: ?std.Io.net.UnixAddress, auth_method: Auth.Method) !@This() {
    var auth_buffer: [128]u8 = undefined;
    const auth = switch (auth_method) {
        .detect => |minimal| try Auth.@"MIT-MAGIC-COOKIE-1".get(io, &auth_buffer, minimal.environ.getPosix(Auth.@"MIT-MAGIC-COOKIE-1".XAUTHORITY).?),
        .credentials => |auth| auth,
    };

    var connection: Connection = try .open(io, allocator, address orelse default_address, .{});
    try connection.setup(.{ .auth = auth });

    return .{
        .allocator = allocator,
        .io = io,
        .connection = connection,
    };
}

pub fn disconnect(self: *@This()) void {
    self.replies.deinit(self.allocator);
    self.connection.close(self.allocator);
    self.* = undefined;
}

/// Returns the amount of replies/events found
pub fn dispatch(self: *@This()) !usize {
    try self.mutux.lock(self.io);
    defer self.mutux.unlock(self.io);

    if (self.connection.writer.interface.buffered().len > @sizeOf(Connection.Request.Header)) try self.connection.flush();
    try self.connection.reader.interface.fillMore();

    var dispatch_count: usize = 0;

    // var pfd = [_]std.posix.pollfd{.{
    //     .fd = self.connection.reader.stream.socket.handle,
    //     .events = std.posix.POLL.IN,
    //     .revents = 0,
    // }};

    // const n = try std.posix.poll(&pfd, 0);
    // if (n <= 0 or (pfd[0].revents & std.posix.POLL.IN) == 0) {
    //     std.log.info("dispatch: nothing to read", .{});
    //     return dispatch_count;
    // }

    while (true) {
        if (self.connection.reader.interface.bufferedLen() == 0) break;
        const reply = try self.connection.readReply();
        try self.replies.pushBack(self.allocator, reply);
        dispatch_count += 1;
    }

    std.log.info("dispatch: count: {d}", .{dispatch_count});
    return dispatch_count;
}

pub fn nextId(self: *@This()) u32 {
    return self.connection.resource_id.next();
}

pub fn sendRequest(self: *@This(), header: Connection.Request.Header, value: anytype) !void {
    try self.mutux.lock(self.io);
    defer self.mutux.unlock(self.io);
    _ = try self.connection.writeRequest(header, value);
}

pub fn sendRequestWithReply(self: *@This(), header: Connection.Request.Header, value: anytype, comptime Reply: type) !Cookie(Reply) {
    try self.mutux.lock(self.io);
    defer self.mutux.unlock(self.io);
    const sequence = (try self.connection.writeRequest(header, value)).sequence;

    return .{ .display = self, .sequence = sequence };
}
