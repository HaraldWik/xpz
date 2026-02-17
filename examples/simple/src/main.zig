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
    const io = init.io;

    const address: std.Io.net.UnixAddress = try .init(xpz.Client.default_display_path);
    const stream = try address.connect(io);
    defer stream.close(io);

    var stream_reader_buffer: [1028]u8 = undefined;
    var stream_reader = stream.reader(io, &stream_reader_buffer);
    const reader = &stream_reader.interface;

    var stream_writer_buffer: [1028]u8 = undefined;
    var stream_writer = stream.writer(io, &stream_writer_buffer);
    const writer = &stream_writer.interface;

    const client: xpz.Client = try .init(io, reader, writer, xpz.Client.Options{
        .auth = .{ .mit_magic_cookie_1 = .{ .xauthority = init.minimal.environ.getPosix(xpz.Client.Auth.@"MIT-MAGIC-COOKIE-1".XAUTHORITY).? } },
        .setup_listener = .{
            .vendor = setup_listener.vendor,
            .screen = setup_listener.currentScreen,
        },
    });

    // Atoms must be aquired before window mapping
    const net_wm_name: xpz.Atom = try .intern(client, false, xpz.Atom.net_wm.name);
    const utf8_string: xpz.Atom = try .intern(client, false, xpz.Atom.utf8_string);

    const randr = try xpz.Extension.query(client, .RANDR) orelse return error.RandrUnsupported;
    try xpz.randr.getMonitors(client, randr, true);

    const window: xpz.Window = client.generateId(xpz.Window, 0);
    try window.create(client, .{
        .parent = client.root_screen.window,
        .width = 600,
        .height = 300,
        .border_width = 1,
        .visual_id = client.root_screen.visual_id,
        .attributes = .{
            .background_pixel = colors[2], // ARGB color
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

    try window.changeProperty(client, .replace, .wm_name, .string, .@"8", title); // This is for setting on older systems, does not support unicode (emojis)
    try window.changeProperty(client, .replace, net_wm_name, utf8_string, .@"8", title); // Modern way, supports unicode

    defer window.destroy(client);
    try window.map(client);
    try client.writer.flush();

    main_loop: while (true) {
        while (try xpz.Event.next(client)) |event| switch (event) {
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
                std.log.info("{t}: {t}", .{ event, @as(xpz.Event.Button.Type, @enumFromInt(button.header.detail)) });
            },
            .keymap_notify => |map| {
                std.log.info("keymap_notify: {d} {any}", .{ map.detail, map.keys });
            },
            else => |event_type| std.log.info("{t}", .{event_type}),
        };
    }
}
