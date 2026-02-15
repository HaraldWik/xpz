const std = @import("std");
const xpz = @import("xpz");
const glx = @import("xpz").Extension.glx;

const title: []const u8 = "OpenGL (GLX)";

pub fn chooseVisual(user_data: ?*anyopaque, screen: xpz.Screen, depth: xpz.Screen.Depth, visual: xpz.Visual) !void {
    _ = screen;
    if (depth.depth != 24) return;
    if (visual.class != .true_color) return;

    const chosen_visual: *xpz.Visual = @ptrCast(@alignCast(user_data.?));
    chosen_visual.* = visual;
}

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

    var visual: xpz.Visual = std.mem.zeroes(xpz.Visual);
    const client: xpz.Client = try .init(io, reader, writer, xpz.Client.Options{
        .auth = .{ .mit_magic_cookie_1 = .{ .xauthority = init.minimal.environ.getPosix(xpz.Client.Auth.@"MIT-MAGIC-COOKIE-1".XAUTHORITY).? } },
        .setup_listener = .{
            .user_data = &visual,
            .screenDepthVisual = chooseVisual,
        },
    });

    // Atoms must be aquired before window mapping
    const net_wm_name: xpz.Atom = try .intern(client, false, xpz.Atom.net_wm.name);
    const utf8_string: xpz.Atom = try .intern(client, false, xpz.Atom.utf8_string);

    const glx_info = try xpz.Extension.query(client, .GLX) orelse return error.UnsupportedExtension;

    const version = try glx.queryVersion(client, glx_info);
    std.log.info("glx version {any}", .{version});

    // const attribute_list: []const glx.Attribute = &.{
    //     .rgba,
    //     .double_buffer,
    //     .depth_size,
    //     @enumFromInt(24),
    //     .stencil_size,
    //     @enumFromInt(8),
    //     .none,
    // };
    // // const visual = x11.glXChooseVisual(display, screen, &attribute_list) orelse return error.ChooseVisual;
    // const visual = try glx.chooseVisual(client, glx_info, client.root_screen, attribute_list);
    // _ = visual;

    const colormap: xpz.Colormap = client.generateId(xpz.Colormap, 0);
    try colormap.create(client, client.root_screen, visual.id, false);

    const window: xpz.Window = client.generateId(xpz.Window, 1);
    try window.create(client, .{
        .parent = client.root_screen.window,
        .width = 600,
        .height = 300,
        .border_width = 1,
        .visual_id = visual.id,
        .attributes = .{
            .colormap = colormap,
            .events = .{
                .exposure = true,
                .key_press = true,
                .key_release = true,
                .keymap_state = true,
                .focus_change = true,
            },
        },
    });

    try window.changeProperty(client, .replace, .wm_name, .string, .@"8", title); // This is for setting on older systems, does not support unicode (emojis)
    try window.changeProperty(client, .replace, net_wm_name, utf8_string, .@"8", title); // Modern way, supports unicode

    defer window.destroy(client);
    try window.map(client);
    try client.writer.flush();

    const glx_context: glx.Context = client.generateId(glx.Context, 2);
    try glx_context.create(client, glx_info, visual.id, client.root_screen);
    const glx_context_tag = try glx_context.makeCurrent(client, glx_info, .{ .window = window }, client.root_screen);

    main_loop: while (true) {
        while (try xpz.Event.next(client)) |event| switch (event) {
            .close => break :main_loop,
            .expose => |expose| std.log.info("resize: {d}x{d}", .{ expose.width, expose.height }),
            .key_press, .key_release => |key| {
                const keycode = key.header.detail; // This is the hardware key, so its diffrent on diffrent platforms
                std.log.info("pressed key: ({c}) {d}", .{ if (std.ascii.isPrint(keycode)) keycode else '?', keycode });
            },
            else => {},
        };

        try glx.swapBuffers(client, glx_info, .{ .window = window }, glx_context_tag);
    }
}
