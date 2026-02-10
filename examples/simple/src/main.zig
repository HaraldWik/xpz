const std = @import("std");
const xpz = @import("xpz");

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

    var screens: [1]xpz.Screen = undefined;
    const client: xpz.Client = try .init(io, reader, writer, xpz.Client.Options{
        .auth = .{ .mit_magic_cookie_1 = .{ .xauthority = init.minimal.environ.getPosix(xpz.Client.Auth.@"MIT-MAGIC-COOKIE-1".XAUTHORITY).? } },
        .screens = &screens,
    });

    var color_index: usize = 0;
    const colors: []const u32 = &.{
        0x00c2185b,
        0x00ff185b,
        0x00c2bb5b,
        0x00cc785b,
    };

    const window: xpz.Window = client.generateId(xpz.Window, 0);
    try window.create(client, .{
        .parent = client.root_screen.window,
        .width = 600,
        .height = 300,
        .border_width = 1,
        .visual_id = client.root_screen.visual_id,
        .attributes = .{
            .background_pixel = colors[0], // ARGB color
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
    defer window.destroy(client);
    try window.map(client);
    try client.writer.flush();

    try reader.fillMore();

    std.debug.print("{s}\n", .{reader.buffered()});
    reader.tossBuffered();

    // const utf8_string: xpz.Atom = try .intern(client, false, xpz.Atom.utf8_string);
    // const net_wm_name: xpz.Atom = try .intern(client, false, xpz.Atom.net_wm_name);

    // try window.changeProperty(client, .replace, net_wm_name, utf8_string, .@"8", "Title");

    // const glx = try xpz.Extension.query(client, .GLX);
    // std.debug.print("glx: {any}\n", .{glx});
    // const randr = try xpz.Extension.query(client, .RANDR);
    // std.debug.print("glx: {any}\n", .{randr});

    main_loop: while (true) {
        while (try xpz.Event.next(client)) |event| switch (event) {
            .close => {
                std.log.info("close", .{});
                break :main_loop;
            },
            .expose => |expose| std.log.info("resize: {d}x{d}", .{ expose.width, expose.height }),
            .key_press => |key| {
                const keycode = key.header.detail; // This is the hardware key, so its diffrent on diffrent platforms
                std.log.info("pressed key: ({c}) {d}", .{ if (std.ascii.isAlphanumeric(keycode)) keycode else '?', keycode });

                // Escape
                if (keycode == 9) {
                    color_index = (color_index + 1) % colors.len;
                    try window.changeAttributes(client, .{ .background_pixel = colors[color_index] });
                    try window.clearArea(client, .{});
                }
            },
            .key_release => {},
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
