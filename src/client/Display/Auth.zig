const std = @import("std");

const Auth = @This();

name: []const u8,
data: []const u8,

pub const none: @This() = .{ .name = "", .data = "" };

pub const Method = union(enum) {
    /// Best choice
    detect: std.process.Init.Minimal,
    credentials: Auth,
};

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
