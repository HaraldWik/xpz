const std = @import("std");

pub const protocol = @import("protocol/protocol.zig");
pub const glx = @import("glx.zig");
pub const randr = @import("randr.zig");

pub const Client = @import("Client.zig");
pub const Atom = @import("atom.zig").Atom;
pub const Event = @import("event.zig").Event;
pub const Window = @import("window.zig").Window;

pub const PixmapFormat = extern struct {
    depth: u8,
    bits_per_pixel: u8,
    scanline_pad: u8,
    pad0: [5]u8 = undefined,
};

pub const Screen = extern struct {
    window: Window, // root
    default_colormap: u32,
    white_pixel: u32,
    black_pixel: u32,
    current_event_mask: Event.Mask,
    width: u16,
    height: u16,
    width_mm: u16,
    height_mm: u16,
    min_installed_maps: u16,
    max_installed_maps: u16,
    visual_id: Visual.Id,
    backing_stores: u8,
    save_unders: u8,
    root_depth: u8,
    depths_count: u8,

    pub const Depth = extern struct {
        depth: u8,
        pad0: u8 = undefined,
        visuals_count: u16,
        pad1: u32 = undefined,
    };
};

pub const Drawable = extern union {
    window: Window,
    pixmap: Window,
};

pub const Visual = extern struct {
    id: Id,
    class: Class(u8),
    bits_per_rgb_value: u8,
    colormap_entries: u16,
    red_mask: u32,
    green_mask: u32,
    blue_mask: u32,
    pad0: u32 = undefined,

    pub const Id = enum(u32) {
        _,
    };

    pub fn Class(T: type) type {
        return enum(T) {
            static_grey = 0,
            grey_scale = 1,
            static_color = 2,
            pseudo_color = 3,
            true_color = 4,
            direct_color = 5,
            _, // Non standard
        };
    }

    pub const Info = struct {
        visual: ?*Visual,
        visual_id: Id,
        /// which screen this visual is on
        screen_index: u32,
        /// bits per pixel (color depth)
        depth: u32,
        class: Class(u32),
        red_mask: u64,
        green_mask: u64,
        blue_mask: u64,
        colormap_size: i32,
        bits_per_rgb: i32,
    };
};

pub const GContext = enum(u32) {
    _,
};

pub const Colormap = enum(u32) {
    _,

    pub fn create(self: @This(), client: Client, screen: Screen, visual_id: Visual.Id, alloc: bool) !void {
        const request: protocol.core.colormap.Create = .{
            .header = .{
                .opcode = .create_colormap,
                .detail = @intFromBool(alloc),
                .length = @sizeOf(protocol.core.colormap.Create) + 3,
            },
            .colormap = self,
            .window = screen.window,
            .visual_id = visual_id,
        };
        try client.writer.writeStruct(request, client.endian);
        try client.writer.flush();
    }

    pub fn free(self: @This(), client: Client) void {
        const request: protocol.core.colormap.Free = .{
            .colormap = self,
        };
        client.writer.writeStruct(request, client.endian) catch {};
        client.writer.flush() catch {};
    }

    pub fn copyAndFree(self: @This(), client: Client, dest: @This()) !void {
        const request: protocol.core.colormap.CopyAndFree = .{
            .src = self,
            .dest = dest,
        };
        try client.writer.writeStruct(request, client.endian);
        try client.writer.flush();
    }

    pub fn install(self: @This(), client: Client) !void {
        const request: protocol.core.colormap.Install = .{
            .colormap = self,
        };
        try client.writer.writeStruct(request, client.endian);
        try client.writer.flush();
    }

    pub fn uninstall(self: @This(), client: Client) !void {
        const request: protocol.core.colormap.Uninstall = .{
            .colormap = self,
        };
        try client.writer.writeStruct(request, client.endian);
        try client.writer.flush();
    }
};

pub const Cursor = enum(u32) {
    _,
};

pub const Format = enum(u8) {
    @"8" = 8,
    @"16" = 16,
    @"32" = 32,
};

pub const Extension = enum(u8) {
    @"BIG-REQUESTS",
    Composite,
    DAMAGE,
    DPMS,
    DRAWS,
    GLX,
    @"MIT-SHM",
    Present,
    RANDR,
    RECORD,
    RENDER,
    SECURITY,
    SHAPE,
    SYNC,
    @"X-Resource",
    XFIXES,
    @"XFree86-DGA",
    @"XFree86-VidMode",
    XInputExtension,
    XTEST,
    @"XC-MISC",
    XCMISC,
    XEVIE,

    pub const Info = struct {
        major_opcode: u8,
        first_event: u8,
        first_error: u8,
    };

    /// Returns null if extension is not present
    pub fn query(client: Client, extension: @This()) !?Info {
        return queryWithSlice(client, @tagName(extension));
    }

    /// Returns null if extension is not present
    pub fn queryWithSlice(client: Client, extension: []const u8) !?Info {
        const request: protocol.core.extension.query.Request = .{
            .header = .{
                .opcode = .query_extension,
                .length = .fromWords(@intCast((@sizeOf(protocol.core.extension.query.Request) + ((extension.len + 3) & ~@as(usize, 3))) / 4)),
            },
            .name_len = @intCast(extension.len),
        };
        try client.writer.writeStruct(request, client.endian);
        try client.writer.writeAll(extension);
        _ = try client.writer.splatByte(0, (4 - (client.writer.end % 4)) % 4); // Padding
        try client.writer.flush();

        try client.reader.fillMore();
        const reply = try client.reader.takeStruct(protocol.core.extension.query.Reply, client.endian);

        return if (reply.present) .{
            .major_opcode = reply.major_opcode,
            .first_event = reply.first_event,
            .first_error = reply.first_error,
        } else null;
    }
};
