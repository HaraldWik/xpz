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

    const client: xpz.Client = try .init(io, reader, writer, xpz.Client.Options{
        .auth = .{ .mit_magic_cookie_1 = .{ .xauthority = init.minimal.environ.getPosix("XAUTHORITY").? } },
    });

    const window: xpz.Window = client.generateId(xpz.Window, 0);
    try window.create(client, .{
        .parent = client.root_screen.window,
        .width = 600,
        .height = 300,
        .border_width = 1,
        .visual_id = client.root_screen.visual_id,
    });
    defer window.destroy(client);
    try window.map(client);
    try client.writer.flush();

    const glx = try xpz.Extension.query(client, .GLX);
    std.debug.print("glx: {any}\n", .{glx});

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
            },
            .key_release => {},
            else => |event_type| std.log.info("{t}", .{event_type}),
        };
    }
}
