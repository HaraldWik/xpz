const std = @import("std");
const protocol = @import("protocol/protocol.zig");
const Client = @import("Client.zig");
const Atom = @import("atom.zig").Atom;
const Event = @import("event.zig").Event;
const Visual = @import("root.zig").Visual;
const Colormap = @import("root.zig").Colormap;
const Cursor = @import("root.zig").Cursor;
const Format = @import("root.zig").Format;

pub const Window = enum(u32) {
    _,

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

    pub const Attributes = struct {
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

        pub const Mask = packed struct(u32) {
            background_pixmap: bool = false,
            background_pixel: bool = false,
            border_pixmap: bool = false,
            border_pixel: bool = false,
            bit_gravity: bool = false,
            win_gravity: bool = false,
            backing_store: bool = false,
            backing_planes: bool = false,
            backing_pixel: bool = false,
            override_redirect: bool = false,
            save_under: bool = false,
            event_mask: bool = false,
            do_not_propagate_mask: bool = false,
            colormap: bool = false,
            cursor: bool = false,

            pad0: u17 = 0,
        };

        pub fn mask(self: @This()) Mask {
            return .{
                .background_pixmap = self.background_pixmap != null,
                .background_pixel = self.background_pixel != null,
                .border_pixmap = self.border_pixmap != null,
                .border_pixel = self.border_pixel != null,
                .bit_gravity = self.bit_gravity != null,
                .win_gravity = self.win_gravity != null,
                .backing_store = self.backing_store != null,
                .backing_planes = self.backing_planes != null,
                .backing_pixel = self.backing_pixel != null,
                .override_redirect = self.override_redirect != null,
                .save_under = self.save_under != null,
                .event_mask = self.events != null,
                .do_not_propagate_mask = self.do_not_propagate_mask != null,
                .colormap = self.colormap != null,
                .cursor = self.cursor != null,
            };
        }

        pub fn write(self: @This(), client: Client) !void {
            if (self.background_pixmap) |background_pixmap| try client.writer.writeInt(u32, @intFromEnum(background_pixmap), client.endian);
            if (self.background_pixel) |background_pixel| try client.writer.writeInt(u32, background_pixel, client.endian);
            if (self.border_pixmap) |border_pixmap| try client.writer.writeInt(u32, @intFromEnum(border_pixmap), client.endian);
            if (self.border_pixel) |border_pixel| try client.writer.writeInt(u32, border_pixel, client.endian);
            if (self.bit_gravity) |bit_gravity| try client.writer.writeInt(i32, @intFromEnum(bit_gravity), client.endian);
            if (self.win_gravity) |win_gravity| try client.writer.writeInt(i32, @intFromEnum(win_gravity), client.endian);
            if (self.backing_store) |backing_store| try client.writer.writeInt(i32, @intFromEnum(backing_store), client.endian);
            if (self.backing_planes) |backing_planes| try client.writer.writeInt(u32, backing_planes, client.endian);
            if (self.backing_pixel) |backing_pixel| try client.writer.writeInt(u32, backing_pixel, client.endian);
            if (self.override_redirect) |override_redirect| try client.writer.writeInt(u32, @intFromBool(override_redirect), client.endian);
            if (self.save_under) |save_under| try client.writer.writeInt(u32, @intFromBool(save_under), client.endian);
            if (self.events) |event_mask| try client.writer.writeStruct(event_mask, client.endian);
            if (self.do_not_propagate_mask) |do_not_propagate_mask| try client.writer.writeStruct(do_not_propagate_mask, client.endian);
            if (self.colormap) |colormap| try client.writer.writeInt(u32, @intFromEnum(colormap), client.endian);
            if (self.cursor) |cursor| try client.writer.writeInt(u32, @intFromEnum(cursor), client.endian);
        }

        pub fn count(self: @This()) usize {
            var c: usize = 0;
            inline for (std.meta.fields(@This())) |field| {
                if (@field(self, field.name) != null) c += 1;
            }
            return c;
        }
    };

    pub const Property = union(enum) {
        bytes: []const u8,
        u16s: []const u16,
        u32s: []const u32,
        atoms: []const Atom,
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
            resizable: bool = false,
            aspect: bool = false,
            base_size: bool = false,
            win_gravity: bool = false,
            pad0: u22 = 0,
        };
    };

    pub const Config = struct {
        parent: Window,
        x: i16 = 0,
        y: i16 = 0,
        width: u16,
        height: u16,
        border_width: u16,
        visual_id: Visual.Id,
        attributes: Attributes = .{},
    };

    pub fn create(self: @This(), client: Client, config: Config) !void {
        const request: protocol.core.window.Create = .{
            .header = .{
                .opcode = .create_window,
                .length = 8 + @as(u16, @intCast(config.attributes.count())),
            },
            .window = self,
            .parent = config.parent,
            .x = config.x,
            .y = config.y,
            .width = config.width,
            .height = config.height,
            .border_width = config.border_width,
            .visual_id = config.visual_id,
            .value_mask = config.attributes.mask(),
        };

        try client.writer.writeStruct(request, client.endian);
        try config.attributes.write(client);
    }

    pub fn destroy(self: @This(), client: Client) void {
        const request: protocol.core.window.Destroy = .{ .window = self };
        client.writer.writeStruct(request, client.endian) catch {};
        client.writer.flush() catch return;
    }

    pub fn map(self: @This(), client: Client) !void {
        const request: protocol.core.window.Map = .{ .window = self };
        try client.writer.writeStruct(request, client.endian);
    }

    pub fn changeAttributes(self: @This(), client: Client, attributes: Attributes) !void {
        const request: protocol.core.window.ChangeAttributes = .{
            .header = .{
                .opcode = .change_window_attributes,
                .length = @intCast(3 + attributes.count()),
            },
            .window = self,
            .value_mask = attributes.mask(),
        };
        try client.writer.writeStruct(request, client.endian);
        try client.writer.flush();
    }

    pub fn clearArea(self: Window, client: Client, config: struct {
        exposures: bool = false,
        x: i16 = 0,
        y: i16 = 0,
        width: u16 = 0,
        height: u16 = 0,
    }) !void {
        const request: protocol.core.window.ClearArea = .{
            .header = .{
                .opcode = .clear_area,
                .length = 4,
            },
            .exposures = config.exposures,
            .window = self,
            .x = config.x,
            .y = config.y,
            .width = config.width,
            .height = config.height,
        };

        try client.writer.writeStruct(request, client.endian);
        try client.writer.flush();
    }

    pub fn changeProperty(self: @This(), client: Client, mode: protocol.core.window.ChangeProperty.ChangeMode, property: Atom, @"type": Atom, format: Format, data: []const u8) !void {
        if (format == .@"16" and data.len % 2 != 0)
            return error.InvalidLength;
        if (format == .@"32" and data.len % 4 != 0)
            return error.InvalidLength;

        const element_count: u32 = switch (format) {
            .@"8" => @intCast(data.len),
            .@"16" => @intCast(data.len / 2),
            .@"32" => @intCast(data.len / 4),
        };

        const padded_len = (data.len + 3) & ~@as(usize, 3);
        const total_bytes = @sizeOf(protocol.core.window.ChangeProperty) + 4 + padded_len;

        const request: protocol.core.window.ChangeProperty = .{
            .header = .{
                .opcode = .change_property,
                .detail = @intFromEnum(mode),
                .length = @intCast(total_bytes / 4),
            },
            .window = self,
            .property = property,
            .type = @"type",
            .format = format,
        };

        try client.writer.writeStruct(request, client.endian);
        try client.writer.writeInt(u32, element_count, client.endian);
        try client.writer.writeAll(data);

        _ = try client.writer.splatByte(0, padded_len - data.len);

        try client.writer.flush();
    }

    pub fn setHints(self: @This(), client: Client, hints: Hints) !void {
        client.reader.tossBuffered();
        try self.changeProperty(client, .append, .wm_size_hints, .atom, .@"32", &std.mem.toBytes(hints));
    }
};
