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
    width_mm: u16,
    height_mm: u16,
    min_installed_maps: u16,
    max_installed_maps: u16,
    visual_id: VisualId,
    backing_stores: u8,
    save_unders: u8,
    root_depth: u8,
    num_depths: u8,
};

pub const Drawable = union {
    window: Window,
    pixmap: Window,
};

pub const VisualId = enum(u32) {
    _,
};

pub const GContext = enum(u32) {
    _,
};

pub const Colormap = enum(u32) {
    _,
};

pub const Cursor = enum(u32) {
    _,
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

        background_pixmap: ?enum(u32) {
            none = 0,
            parent_relative = 1,
            _, // Pixmap XID
        } = null,
        background_pixel: ?u32 = null, // ARGB example: 0x00ff0000
        border_pixmap: ?enum(u32) {
            copy_from_parent = 0,
            _, // Pixmap XID
        } = null,
        border_pixel: ?u32 = null, // bitmask, varies
        bit_gravity: ?gravity.Bit = null,
        win_gravity: ?gravity.Win = null,
        backing_store: ?backing.Store = null,
        backing_planes: ?u32 = null, // Plane mask (bitmask)
        backing_pixel: ?u32 = null, // Pixel value used with backing_planes,
        override_redirect: ?bool = null,
        save_under: ?bool = null,
        events: ?Event.Mask = null,
        do_not_propagate_mask: ?Event.Mask = null,
        colormap: ?Colormap = null, // Colormap XID
        cursor: ?Cursor = null,
    };

    pub const gravity = struct {
        pub const Bit = enum(i32) {
            forget = 0, // ForgetGravity
            north_west = 1,
            north = 2,
            north_east = 3,
            west = 4,
            center = 5,
            east = 6,
            south_west = 7,
            south = 8,
            south_east = 9,
            static = 10, // StaticGravity
        };

        pub const Win = enum(i32) {
            unmap = 0, // UnmapGravity
            north_west = 1,
            north = 2,
            north_east = 3,
            west = 4,
            center = 5,
            east = 6,
            south_west = 7,
            south = 8,
            south_east = 9,
            static = 10, // StaticGravity
        };
    };

    pub const backing = struct {
        pub const Store = enum(i32) {
            not_useful = 0, // NotUseful
            when_mapped = 1, // WhenMapped
            always = 2, // Always
        };
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
        min_aspect: Aspect = .{},
        max_aspect: Aspect = .{},
        base_width: c_int = 0,
        base_height: c_int = 0,
        win_gravity: c_int = 0,

        const Aspect = extern struct {
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
            .value_mask = .{
                .background_pixmap = config.background_pixmap != null,
                .background_pixel = config.background_pixel != null,
                .border_pixmap = config.border_pixmap != null,
                .border_pixel = config.border_pixel != null,
                .bit_gravity = config.bit_gravity != null,
                .win_gravity = config.win_gravity != null,
                .backing_store = config.backing_store != null,
                .backing_planes = config.backing_planes != null,
                .backing_pixel = config.backing_pixel != null,
                .override_redirect = config.override_redirect != null,
                .save_under = config.save_under != null,
                .event_mask = config.events != null,
                .do_not_propagate_mask = config.do_not_propagate_mask != null,
                .colormap = config.colormap != null,
                .cursor = config.cursor != null,
            },
        };

        try client.writer.writeStruct(request, client.endian);

        if (config.background_pixmap) |background_pixmap| try client.writer.writeInt(u32, @intFromEnum(background_pixmap), client.endian);
        if (config.background_pixel) |background_pixel| try client.writer.writeInt(u32, background_pixel, client.endian);
        if (config.border_pixmap) |border_pixmap| try client.writer.writeInt(u32, @intFromEnum(border_pixmap), client.endian);
        if (config.border_pixel) |border_pixel| try client.writer.writeInt(u32, border_pixel, client.endian);
        if (config.bit_gravity) |bit_gravity| try client.writer.writeInt(i32, @intFromEnum(bit_gravity), client.endian);
        if (config.win_gravity) |win_gravity| try client.writer.writeInt(i32, @intFromEnum(win_gravity), client.endian);
        if (config.backing_store) |backing_store| try client.writer.writeInt(i32, @intFromEnum(backing_store), client.endian);
        if (config.backing_planes) |backing_planes| try client.writer.writeInt(u32, backing_planes, client.endian);
        if (config.backing_pixel) |backing_pixel| try client.writer.writeInt(u32, backing_pixel, client.endian);
        if (config.override_redirect) |override_redirect| try client.writer.writeInt(u32, @intFromBool(override_redirect), client.endian);
        if (config.save_under) |save_under| try client.writer.writeInt(u32, @intFromBool(save_under), client.endian);
        if (config.events) |event_mask| try client.writer.writeStruct(event_mask, client.endian);
        if (config.do_not_propagate_mask) |do_not_propagate_mask| try client.writer.writeStruct(do_not_propagate_mask, client.endian);
        if (config.colormap) |colormap| try client.writer.writeInt(u32, @intFromEnum(colormap), client.endian);
        if (config.cursor) |cursor| try client.writer.writeInt(u32, @intFromEnum(cursor), client.endian);
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

pub const Extension = enum(u8) {
    GLX,
    RANDR,
    XInputExtension,
    Composite,
    @"MIT-SHM",
    _,

    pub const Info = struct {
        major_opcode: u8,
        first_event: u8,
        num_events: ?u8,
        first_error: u8,
    };

    pub fn query(client: Client, extension: Extension) !protocol.extension.query.Reply {
        const name: []const u8 = @tagName(extension);

        const request: protocol.extension.query.Request = .{
            .header = .{
                .opcode = .query_extension,
                .length = @intCast((@sizeOf(protocol.extension.query.Request) + ((name.len + 3) & ~@as(usize, 3))) / 4),
            },
            .name_len = @intCast(name.len),
        };
        try client.writer.writeStruct(request, .little);
        try client.writer.writeAll(name);
        client.writer.end += (4 - (client.writer.end % 4)) % 4; // Padding
        try client.writer.flush();

        try client.reader.fillMore();
        const reply = try client.reader.takeStruct(protocol.extension.query.Reply, .little);

        std.debug.print("{s} = {d}\n", .{ name, reply.major_opcode });

        return reply;
    }
};
