const std = @import("std");
const xpz = @import("xpz");

// const title: []const u8 = "Hello, X 🔥!";

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

    var platform: Platform = undefined;
    try platform.init(io, init.minimal);
    defer platform.deinit(io);

    const window: Window = try .open(platform);
    defer window.close(platform);

    try window.setTitle(platform, "Hello, X 🔥!");

    main_loop: while (true) {
        while (try xpz.Event.next(platform.client)) |event| switch (event) {
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

pub const Platform = struct {
    reader_buffer: [512]u8 = undefined,
    writer_buffer: [512]u8 = undefined,
    reader: std.Io.net.Stream.Reader,
    writer: std.Io.net.Stream.Writer,
    client: xpz.Client,
    atom_table: AtomTable,

    pub const AtomTable = struct {
        net_wm_name: xpz.Atom,
        utf8_string: xpz.Atom,
    };

    pub fn init(self: *@This(), io: std.Io, minimal: std.process.Init.Minimal) !void {
        const address: std.Io.net.UnixAddress = try .init(xpz.Client.default_display_path);
        const stream = try address.connect(io);

        self.reader = stream.reader(io, &self.reader_buffer);
        self.writer = stream.writer(io, &self.writer_buffer);

        self.client = try .init(io, &self.reader.interface, &self.writer.interface, xpz.Client.Options{
            .auth = .{ .mit_magic_cookie_1 = .{ .xauthority = minimal.environ.getPosix(xpz.Client.Auth.@"MIT-MAGIC-COOKIE-1".XAUTHORITY).? } },
            .setup_listener = .{
                .vendor = setup_listener.vendor,
                .screen = setup_listener.currentScreen,
            },
        });

        self.atom_table = .{
            .net_wm_name = try .intern(self.client, false, xpz.Atom.net_wm.name),
            .utf8_string = try .intern(self.client, false, xpz.Atom.utf8_string),
        };
    }

    pub fn deinit(self: @This(), io: std.Io) void {
        const stream = self.getStream();
        stream.close(io);
    }

    pub fn getStream(self: @This()) std.Io.net.Stream {
        const reader: *std.Io.net.Stream.Reader = @fieldParentPtr("interface", self.client.reader);
        return reader.stream;
    }
};

pub const Window = struct {
    window: xpz.Window,

    pub fn open(platform: Platform) !@This() {
        const client = platform.client;
        const window: xpz.Window = client.generateId(xpz.Window, 0);
        try window.create(client, .{
            .parent = client.root_screen.window,
            .width = 600,
            .height = 300,
            .border_width = 1,
            .visual_id = client.root_screen.visual_id,
            .attributes = .{
                .background_pixel = 0x00c2bb5b, // ARGB color
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
        try window.map(client);
        try client.writer.flush();

        return .{ .window = window };
    }

    pub fn close(self: @This(), platform: Platform) void {
        self.window.destroy(platform.client);
    }

    pub fn setTitle(self: @This(), platform: Platform, title: []const u8) !void {
        const client = platform.client;
        try self.window.changeProperty(client, .replace, .wm_name, .string, .@"8", title); // This is for setting on older systems, does not support unicode (emojis)
        try self.window.changeProperty(client, .replace, platform.atom_table.net_wm_name, platform.atom_table.utf8_string, .@"8", title); // Modern way, supports unicode
    }
};
