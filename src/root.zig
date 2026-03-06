pub const protocol = @import("protocol.zig");

pub const Display = @import("Display.zig");
pub const Atom = @import("atom.zig").Atom;
pub const Window = @import("window.zig").Window;
pub const Event = @import("Event.zig");

pub const PixmapFormat = struct {
    depth: u8,
    bits_per_pixel: u8,
    scanline_pad: u8,
    pad0: [5]u8 = undefined,
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
            static_gray = 0,
            gray_scale = 1,
            static_color = 2,
            pseudo_color = 3,
            true_color = 4,
            direct_color = 5,
            _,
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

pub const Depth = extern struct {
    depth: u8,
    pad0: u8 = 0,
    visuals_count: u16,
    pad1: u32 = 0,
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
};

pub const GContext = enum(u32) {
    _,
};

pub const Colormap = enum(u32) {
    _,

    // pub fn create(self: @This(), connection: *Connection, screen: Screen, visual_id: Visual.Id, alloc: bool) !void {
    //     const request_value: protocol.core.colormap.Create = .{
    //         .colormap = self,
    //         .window = screen.window,
    //         .visual_id = visual_id,
    //     };
    //     try connection.writer.flush();
    //     _ = try connection.sendRequest(.{ .core = .{ .major = .colormap_create, .detail = @intFromBool(alloc) } }, request_value);
    // }

    // pub fn free(self: @This(), connection: *Connection) void {
    //     const request_value: protocol.core.colormap.Free = .{ .colormap = self };
    //     _ = try connection.sendRequest(.{ .core = .{ .major = .colormap_free } }, request_value);
    // }

    // pub fn copyAndFree(self: @This(), connection: *Connection, dest: @This()) !void {
    //     const request_value: protocol.core.colormap.CopyAndFree = .{
    //         .src = self,
    //         .dest = dest,
    //     };
    //     _ = try connection.sendRequest(.{ .core = .{ .major = .colormap_copy_and_free } }, request_value);
    // }

    // pub fn install(self: @This(), connection: *Connection) !void {
    //     const request_value: protocol.core.colormap.Install = .{ .colormap = self };
    //     _ = try connection.sendRequest(.{ .core = .{ .major = .colormap_install } }, request_value);
    // }

    // pub fn uninstall(self: @This(), connection: *Connection) !void {
    //     const request_value: protocol.core.colormap.Uninstall = .{ .colormap = self };
    //     _ = try connection.sendRequest(.{ .core = .{ .major = .colormap_uninstall } }, request_value);
    // }
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
    DRI3,

    /// Returns null if extension is not present
    pub fn query(display: *Display, extension: @This()) !Display.Cookie(protocol.core.extension.query.Reply) {
        return queryWithSlice(display, @tagName(extension));
    }

    /// Returns null if extension is not present
    pub fn queryWithSlice(display: *Display, extension: []const u8) !Display.Cookie(protocol.core.extension.query.Reply) {
        const request_value: protocol.core.extension.query.Request = .{
            .name_len = @intCast(extension.len),
            .name = extension,
        };
        return try display.sendRequestWithReply(.{ .major_opcode = .core(.extension_query) }, request_value, protocol.core.extension.query.Reply);
    }
};
