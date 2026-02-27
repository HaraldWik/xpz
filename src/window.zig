const std = @import("std");
const protocol = @import("protocol.zig");
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
        pub const Planes = u32;
        pub const Pixel = u32;
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
        backing_planes: ?backing.Planes = null, // Plane mask (bitmask)
        backing_pixel: ?backing.Pixel = null, // Pixel value used with backing_planes,
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

        pub fn write(self: @This(), writer: *std.Io.Writer, endian: std.builtin.Endian) !void {
            if (self.background_pixmap) |background_pixmap| try writer.writeInt(u32, @intFromEnum(background_pixmap), endian);
            if (self.background_pixel) |background_pixel| try writer.writeInt(u32, background_pixel, endian);
            if (self.border_pixmap) |border_pixmap| try writer.writeInt(u32, @intFromEnum(border_pixmap), endian);
            if (self.border_pixel) |border_pixel| try writer.writeInt(u32, border_pixel, endian);
            if (self.bit_gravity) |bit_gravity| try writer.writeInt(i32, @intFromEnum(bit_gravity), endian);
            if (self.win_gravity) |win_gravity| try writer.writeInt(i32, @intFromEnum(win_gravity), endian);
            if (self.backing_store) |backing_store| try writer.writeInt(i32, @intFromEnum(backing_store), endian);
            if (self.backing_planes) |backing_planes| try writer.writeInt(u32, backing_planes, endian);
            if (self.backing_pixel) |backing_pixel| try writer.writeInt(u32, backing_pixel, endian);
            if (self.override_redirect) |override_redirect| try writer.writeInt(u32, @intFromBool(override_redirect), endian);
            if (self.save_under) |save_under| try writer.writeInt(u32, @intFromBool(save_under), endian);
            if (self.events) |event_mask| try writer.writeStruct(event_mask, endian);
            if (self.do_not_propagate_mask) |do_not_propagate_mask| try writer.writeStruct(do_not_propagate_mask, endian);
            if (self.colormap) |colormap| try writer.writeInt(u32, @intFromEnum(colormap), endian);
            if (self.cursor) |cursor| try writer.writeInt(u32, @intFromEnum(cursor), endian);
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
        depth: u8 = 0,
        parent: Window,
        x: i16 = 0,
        y: i16 = 0,
        width: u16,
        height: u16,
        border_width: u16,
        visual_id: Visual.Id,
        attributes: Attributes = .{},
    };

    pub fn create(self: @This(), connection: *Client.Connection, config: Config) !void {
        const request_value: protocol.core.window.Create = .{
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
        var request = try connection.sendRequestUnflushed(.{ .core = .{ .major = .create_window, .detail = config.depth } }, request_value);

        try config.attributes.write(&connection.*.writer.interface, connection.client.endian);
        const attributes_len = connection.writer.interface.end - request.end;
        try request.setLength(.fromBytes(request.end - request.start + attributes_len));
    }

    pub fn destroy(self: @This(), connection: *Client.Connection) void {
        const request_value: protocol.core.window.Destroy = .{ .window = self };
        _ = connection.sendRequestUnflushed(.{ .core = .{ .major = .destroy_window } }, request_value) catch return;
    }

    pub fn map(self: @This(), connection: *Client.Connection) !void {
        const request_value: protocol.core.window.Map = .{ .window = self };
        _ = try connection.sendRequestUnflushed(.{ .core = .{ .major = .map_window } }, request_value);
    }

    pub fn changeAttributes(self: @This(), connection: *Client.Connection, attributes: Attributes) !void {
        const request_value: protocol.core.window.ChangeAttributes = .{
            .window = self,
            .value_mask = attributes.mask(),
        };
        _ = try connection.sendRequestUnflushed(.{ .core = .{ .major = .change_window_attributes } }, request_value);
    }

    pub fn clearArea(self: Window, connection: *Client.Connection, config: struct {
        exposures: bool = false,
        x: i16 = 0,
        y: i16 = 0,
        width: u16 = 0,
        height: u16 = 0,
    }) !void {
        const request_value: protocol.core.window.ClearArea = .{
            .exposures = config.exposures,
            .window = self,
            .x = config.x,
            .y = config.y,
            .width = config.width,
            .height = config.height,
        };
        _ = try connection.sendRequestUnflushed(.{ .core = .{ .major = .clear_area } }, request_value);
    }

    pub fn changeProperty(self: @This(), connection: *Client.Connection, mode: protocol.core.window.ChangeProperty.ChangeMode, property: Atom, @"type": Atom, format: Format, data: []const u8) !void {
        if (format == .@"16" and data.len % 2 != 0)
            return error.InvalidLength;
        if (format == .@"32" and data.len % 4 != 0)
            return error.InvalidLength;

        const element_count: u32 = switch (format) {
            .@"8" => @intCast(data.len),
            .@"16" => @intCast(data.len / 2),
            .@"32" => @intCast(data.len / 4),
        };

        const request_value: protocol.core.window.ChangeProperty = .{
            .window = self,
            .property = property,
            .type = @"type",
            .format = format,
            .element_count = element_count,
            .data = data,
        };

        _ = try connection.sendRequestUnflushed(.{ .core = .{ .major = .change_property, .detail = @intFromEnum(mode) } }, request_value);
    }

    pub fn setHints(self: @This(), client: Client, hints: Hints) !void {
        try self.changeProperty(client, .append, .wm_size_hints, .atom, .@"32", &std.mem.toBytes(hints));
    }
};
