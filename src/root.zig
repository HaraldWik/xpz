const std = @import("std");

pub const protocol = @import("protocol.zig");

pub const Client = @import("Client.zig");
pub const Event = @import("event.zig").Event;
pub const Atom = @import("atom.zig").Atom;

pub const Screen = extern struct {
    window: Window, // root
    default_colormap: u32,
    white_pixel: u32,
    black_pixel: u32,
    current_input_masks: u32,
    width: u16,
    height: u16,
    mm_width: u16,
    mm_height: u16,
    min_installed_maps: u16,
    max_installed_maps: u16,
    visual_id: VisualId,
    backing_stores: u8,
    save_unders: u8,
    root_depth: u8,
    num_depths: u8,
};

pub const VisualId = enum(u32) {
    _,
};

pub const Drawable = union {
    window: Window,
    pixmap: Window,
};

pub const Window = enum(u32) {
    _,

    pub const Config = struct {
        parent: Window,
        x: i16 = 0,
        y: i16 = 0,
        width: u16,
        height: u16,
        border_width: u16,
        visual_id: VisualId,
    };

    /// Same as XSizeHints
    pub const Hints = extern struct {
        flags: Flags,
        x: c_int = 0,
        y: c_int = 0,
        width: c_int = 0,
        height: c_int = 0,
        min_width: c_int = 0,
        min_height: c_int = 0,
        max_width: c_int = 0,
        max_height: c_int = 0,
        width_inc: c_int = 0,
        height_inc: c_int = 0,
        min_aspect: struct_unnamed_8 = .{},
        max_aspect: struct_unnamed_8 = .{},
        base_width: c_int = 0,
        base_height: c_int = 0,
        win_gravity: c_int = 0,

        const struct_unnamed_8 = extern struct {
            x: c_int = 0,
            y: c_int = 0,
        };

        pub const Flags = packed struct(u32) {
            sposition: bool = false,
            ssize: bool = false,
            position: bool = false,
            size: bool = false,
            min_size: bool = false,
            max_size: bool = false,
            resize_inc: bool = false,
            aspect: bool = false,
            base_size: bool = false,
            win_gravity: bool = false,
            pad0: u22 = 0,
        };
    };

    pub fn create(self: @This(), client: Client, config: Config) !void {
        const flag_count = 2;

        const request: protocol.window.Create = .{
            .header = .{
                .opcode = .create_window,
                .length = 8 + flag_count,
            },
            .window = self,
            .parent = config.parent,
            .x = config.x,
            .y = config.y,
            .width = config.width,
            .height = config.height,
            .border_width = config.border_width,
            .visual_id = config.visual_id,
            .value_mask = .{ .event_mask = true, .background_pixel = true },
        };

        try client.writer.writeStruct(request, client.endian);
        try client.writer.writeInt(u32, 0x00ff0000, client.endian);
        try client.writer.writeStruct(Event.Mask{ .exposure = true, .key_press = true, .key_release = true, .focus_change = true, .button_press = true, .button_release = true }, client.endian);
    }

    pub fn destroy(self: @This(), client: Client) void {
        const request: protocol.window.Destroy = .{ .window = self };
        client.writer.writeStruct(request, client.endian) catch {};
        client.writer.flush() catch return;
    }

    pub fn map(self: @This(), client: Client) !void {
        const request: protocol.window.Map = .{ .window = self };
        try client.writer.writeStruct(request, client.endian);
    }

    // pub fn changeProperty(self: @This(), c: Client, mode: Property.ChangeMode, property: Atom, @"type": Atom, format: Format, data: []const u8) !void {
    // try Property.change(c, mode, self, property, @"type", format, data);
    // }

    // pub fn setHints(self: @This(), client: Client, hints: Hints) !void {
    //     client.reader.tossBuffered();
    //     try self.changeProperty(client, .append, .wm_size_hints, .atom, .@"32", &std.mem.toBytes(hints));
    //     try client.reader.fillMore();
    //     defer client.reader.tossBuffered();

    //     const reply = try client.reader.takeEnum(protocol.ReplyHeader, client.endian);
    //     if (reply != .reply) return error.InvalidReply;
    // }
};
