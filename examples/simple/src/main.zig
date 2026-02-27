const std = @import("std");
const xpz = @import("xpz");

const title: []const u8 = "Hello, X 🔥!";

const colors: []const u32 = &.{
    0x00c2185b,
    0x00ff185b,
    0x00c2bb5b,
    0x00cc785b,
};

pub const setup_listener = struct {
    pub fn vendor(user_data: ?*anyopaque, name: []const u8) !void {
        _ = user_data;
        std.log.info("vendor: {s}", .{name});
    }

    pub fn currentScreen(user_data: ?*anyopaque, screen: xpz.Screen) !void {
        _ = user_data;
        std.log.info("screen: {d}, size: {d}x{d}, physical size: {d}x{d}mm, visual_id: {d}", .{
            @intFromEnum(screen.window),
            screen.width,
            screen.height,
            screen.width_mm,
            screen.height_mm,
            @intFromEnum(screen.visual_id),
        });
    }
};

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const io = init.io;

    var client: xpz.Client = .{
        .allocator = allocator,
        .io = io,
    };
    var connection = try client.connectUnix(xpz.Client.Connection.default_address);
    defer connection.destroy();
    const root_screen = try connection.setupOptions(init.minimal, .{
        .setup_listener = .{
            .vendor = setup_listener.vendor,
            .screen = setup_listener.currentScreen,
        },
    });

    const net_wm_name: xpz.Atom = try .intern(&connection, false, xpz.Atom.net_wm.name);
    const utf8_string: xpz.Atom = try .intern(&connection, false, xpz.Atom.utf8_string);

    std.log.info("net_wm_name: {d}", .{@intFromEnum(net_wm_name)});
    std.log.info("utf8_string: {d}", .{@intFromEnum(utf8_string)});

    // const randr = try xpz.Extension.query(client, .RANDR) orelse return error.RandrUnsupported;
    // try xpz.randr.getMonitors(client, randr, true);

    const window: xpz.Window = @enumFromInt(connection.resource_id.next());
    try window.create(&connection, .{
        .depth = root_screen.root_depth,
        .parent = root_screen.window,
        .width = 600,
        .height = 300,
        .border_width = 1,
        .visual_id = root_screen.visual_id,
        .attributes = .{
            .background_pixel = 0x00c2185b, // ARGB color
            // .events = .all,
            .events = .{
                .exposure = true,
                .key_press = true,
                .key_release = true,
                .keymap_state = true,
                .focus_change = true,
                .button_press = true,
                .button_release = true,
            },
        },
    });
    defer window.destroy(&connection);

    try window.changeProperty(&connection, .replace, .wm_name, .string, .@"8", title); // This is for setting on older systems, does not support unicode (emojis)
    try window.changeProperty(&connection, .replace, net_wm_name, utf8_string, .@"8", title); // Modern way, supports unicode

    try window.map(&connection);
    try connection.flush();

    try connection.reader.interface.fillMore();
    std.log.info("read: {any}", .{connection.reader.interface.buffer});

    main_loop: while (true) {
        while (try xpz.Event.next(&connection)) |event| switch (event) {
            .close => {
                std.log.info("close", .{});
                break :main_loop;
            },
            .expose => |expose| std.log.info("resize: {d}x{d}", .{ expose.width, expose.height }),
            .key_press, .key_release => |key| {
                const keycode = key.header.detail; // This is the hardware key, so its diffrent on diffrent platforms
                std.log.info("pressed key: ({c}) {d}", .{ if (std.ascii.isPrint(keycode)) keycode else '?', keycode });
            },
            .button_press, .button_release => |button| {
                std.log.info("{t}: {t}", .{ event, button.button() });
            },
            .keymap_notify => |map| {
                std.log.info("keymap_notify: {d} {any}", .{ map.detail, map.keys });
            },
            else => |event_type| std.log.info("{t}", .{event_type}),
        };
    }
}
