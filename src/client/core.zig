const protocol = @import("../protocol.zig");

pub const Display = @import("Display.zig");

pub const Atom = @import("core/atom.zig").Atom;
pub const Colormap = @import("core/colormap.zig").Colormap;
pub const Event = @import("core/Event.zig");
pub const Font = @import("core/Font.zig").Font;
pub const Pixmap = @import("core/pixmap.zig").Pixmap;
pub const Window = @import("core/window.zig").Window;

pub const Point = struct {
    x: i16,
    y: i16,
};
pub const Rectangle = struct {
    x: i16,
    y: i16,
    width: u16,
    height: u16,
};
pub const Arc = struct {
    x: i16,
    y: i16,
    width: u16,
    height: u16,
    angle1: i16,
    angle2: i16,

    pub const Mode = enum(u8) {
        chord = 0,
        pie_slice = 1,
    };
};
pub const Format = struct {
    depth: u8,
    bits_per_pixel: u8,
    scanline_pad: u8,
};
pub const Visual = struct {
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
        static_gray = 0,
        gray_scale = 1,
        static_color = 2,
        pseudo_color = 3,
        true_color = 4,
        direct_color = 5,
        _,
    };

    pub const Type = struct {
        visual_id: Id,
        class: Class,
        bits_per_rgb_value: u8,
        colormap_entries: u16,
        red_mask: u32,
        green_mask: u32,
        blue_mask: u32,
    };
};
pub const Depth = struct {
    depth: u8,
    visuals_len: u16,
    visuals: []const Visual.Type,
};
pub const BackingStore = enum(u8) {
    not_useful = 0,
    when_mapped = 1,
    always = 2,
};
pub const Screen = struct {
    root: Window,
    default_colormap: Colormap,
    white_pixel: u32,
    black_pixel: u32,
    current_input_masks: u32,
    width: u16,
    height: u16,
    width_millimeters: u16,
    height_millimeters: u16,
    min_installed_maps: u16,
    max_installed_maps: u16,
    // pad0: u16 = 0, // TODO: add programaticaly
    root_visual: Visual.Id,
    backing_stores: u8,
    save_unders: bool,
    root_depth: u8,
    allowed_depths_len: u8,
    // pad1: u16 = 0, // TODO: add programaticaly
    allowed_depths: []const Depth,
};
pub const Drawable = extern union {
    window: Window,
    pixmap: Window,
};
pub const GContext = enum(u32) {
    _,
};
pub const key = struct {
    pub const Code = u8;
    pub const Sym = u32;
};

pub const Cursor = enum(u32) {
    none = 0,
    _,
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
    DRI3,

    /// Returns null if extension is not present
    pub fn query(display: *Display, extension: @This()) !Display.Cookie(protocol.core.query_extension.Reply) {
        return queryWithSlice(display, @tagName(extension));
    }

    /// Returns null if extension is not present
    pub fn queryWithSlice(display: *Display, extension: []const u8) !Display.Cookie(protocol.core.query_extension.Reply) {
        const request_value: protocol.core.query_extension.Request = .{
            .name_len = @intCast(extension.len),
            .name = extension,
        };
        return try display.sendRequestWithReply(.{ .major_opcode = .core(.query_extension) }, request_value, protocol.core.query_extension.Reply);
    }
};
