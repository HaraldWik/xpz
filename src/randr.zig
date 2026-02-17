const std = @import("std");
const protocol = @import("protocol/protocol.zig");
const Client = @import("Client.zig");
const Extension = @import("root.zig").Extension;
const Atom = @import("atom.zig").Atom;

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

pub fn getMonitors(client: Client, info: Extension.Info, get_active: bool) !void {
    const request: protocol.randr.get_monitors.Request = .{
        .header = .{
            .major_opcode = info.major_opcode,
            .minor_opcode = .get_monitors,
            .length = .fromBytes(@sizeOf(protocol.randr.get_monitors.Request)),
        },
        .window = client.root_screen.window,
        .get_active = get_active,
    };
    try client.writer.writeStruct(request, client.endian);
    try client.writer.flush();

    client.reader.tossBuffered();
    try client.reader.fillMore();
    const reply = try client.reader.takeStruct(protocol.randr.get_monitors.Reply, client.endian);
    for (0..reply.monitor_count) |i| {
        _ = i;
        std.debug.print("monitor: \n", .{});
        const monitor_info = try client.reader.takeStruct(MonitorInfo, client.endian);
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

        const name = try monitor_info.name.getName(client);
        std.debug.print("monitor name: {s}\n", .{name});

        for (0..monitor_info.output_count) |j| {
            _ = j;
            const output = try client.reader.takeEnum(Output, client.endian);
            std.debug.print("\toutput: {d}\n", .{@intFromEnum(output)});
        }
    }
}
