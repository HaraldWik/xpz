const std = @import("std");
const protocol = @import("protocol.zig");
const Connection = @import("Connection.zig");
const Extension = @import("root.zig").Extension;
const Atom = @import("atom.zig").Atom;
const Screen = @import("root.zig").Screen;

pub const MonitorInfo = extern struct {
    name: Atom,
    primary: bool,
    automatic: bool,
    output_count: u16,

    x: i16,
    y: i16,
    width: u16,
    height: u16,

    width_mm: u32,
    height_mm: u32,
};

pub const Output = enum(u32) {
    _,
};

/// Screen is usualy root screen
pub fn getMonitors(connection: *Connection, info: Extension.Info, screen: Screen, get_active: bool) !void {
    const request_value: protocol.randr.get_monitors.Request = .{
        .window = screen.window,
        .get_active = get_active,
    };
    var request = try connection.sendRequest(.{ .randr = .{ .major = info.major_opcode, .minor = .get_monitors } }, request_value);
    const reply = try request.receiveReply(protocol.randr.get_monitors.Reply);

    var reader = &connection.*.reader.interface;

    for (0..reply.value.monitor_count) |i| {
        _ = i;
        std.debug.print("monitor: \n", .{});
        const monitor_info = try reader.takeStruct(MonitorInfo, connection.endian);
        std.debug.print(
            \\  primary: {s}
            \\  automatic: {s}
            \\  position: {d}x{d}
            \\  size: {d}x{d}
            \\  physical size: {d}x{d}mm
            \\
        , .{
            if (monitor_info.primary) "yes" else "no",
            if (monitor_info.automatic) "yes" else "no",
            monitor_info.x,
            monitor_info.y,
            monitor_info.width,
            monitor_info.height,
            monitor_info.width_mm,
            monitor_info.height_mm,
        });

        const name = try monitor_info.name.getName(connection);
        std.debug.print("monitor name: {s}\n", .{name});

        for (0..monitor_info.output_count) |j| {
            _ = j;
            const output = try reader.takeEnum(Output, connection.endian);
            std.debug.print("\toutput: {d}\n", .{@intFromEnum(output)});
        }
    }
}
