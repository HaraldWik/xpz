const std = @import("std");

pub const protocol = @import("protocol.zig");

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

pub const Drawable = union {
    window: Window,
    pixmap: Window,
};

pub const Visual = extern struct {
    id: Id,
    class: Class,
    bits_per_rgb_value: u8,
    colormap_entries: u16,
    red_mask: u32,
    green_mask: u32,
    blue_mask: u32,
    pad0: u32 = undefined,

    pub const Id = enum(u32) {
        _,
    };

    pub const Class = enum(u8) {
        static_grey = 0,
        grey_scale = 1,
        static_color = 2,
        pseudo_color = 3,
        true_color = 4,
        direct_color = 5,
        _, // Non standard
    };
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

pub const Format = enum(u8) {
    @"8" = 8,
    @"16" = 16,
    @"32" = 32,
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
        try client.writer.writeStruct(request, client.endian);
        try client.writer.writeAll(name);
        client.writer.end += (4 - (client.writer.end % 4)) % 4; // Padding
        try client.writer.flush();

        try client.reader.fillMore();
        const reply = try client.reader.takeStruct(protocol.extension.query.Reply, client.endian);

        std.debug.print("{s} = {d}\n", .{ name, reply.major_opcode });

        return reply;
    }
};
