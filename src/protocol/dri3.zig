const std = @import("std");
const Window = @import("../window.zig").Window;
const Drawable = @import("../root.zig").Drawable;
const Pixmap = @import("../root.zig").Pixmap;

pub const Opcode = enum(u8) {
    query_version = 0,
    open = 1,
    pixmap_from_buffer = 2,
    buffer_from_pixmap = 3,
    fence_from_f_d = 4,
    f_d_from_fence = 5,
    get_supported_modifiers = 6,
    pixmap_from_buffers = 7,
    buffers_from_pixmap = 8,
    set_d_r_m_device_in_use = 9,
    import_syncobj = 10,
    free_syncobj = 11,
};

pub const SyncObject = enum(u32) {
    _,
};

pub const query_version = struct {
    pub const Request = struct {
        major_version: u32,
        minor_version: u32,
    };
    pub const Reply = struct {
        major_version: u32,
        minor_version: u32,
    };
};
pub const open = struct {
    pub const Request = struct {
        drawable: Drawable,
        provider: u32,
    };
    pub const Reply = struct {
        nfd: u8,
        fds: []const std.posix.fd_t,
    };
};
pub const pixmap_from_buffer = struct {
    pub const Request = struct {
        pixmap: Pixmap,
        drawable: Drawable,
        size: u32,
        width: u16,
        height: u16,
        stride: u16,
        depth: u8,
        bpp: u8,
        fd: std.posix.fd_t,
    };
};
pub const buffer_from_pixmap = struct {
    pub const Request = struct {
        pixmap: Pixmap,
    };
    pub const Reply = struct {
        nfd: u8,
        size: u32,
        width: u16,
        height: u16,
        stride: u16,
        depth: u8,
        bpp: u8,
        fds: []const std.posix.fd_t,
    };
};
pub const fence_from_fd = struct {
    pub const Request = struct {
        drawable: Drawable,
        fence: u32,
        initially_triggered: bool,
        fd: std.posix.fd_t,
    };
};
pub const fd_from_fence = struct {
    pub const Request = struct {
        drawable: Drawable,
        fence: u32,
    };
    pub const Reply = struct {
        nfd: u8,
        fds: []const std.posix.fd_t,
    };
};
pub const get_supported_modifiers = struct {
    pub const Request = struct {
        window: u32,
        depth: u8,
        bpp: u8,
    };
    pub const Reply = struct {
        // unknown start required_start_align
        // unknown end required_start_align
        num_window_modifiers: u32,
        num_screen_modifiers: u32,
        window_modifiers: []const u64,
        screen_modifiers: []const u64,
    };
};
pub const pixmap_from_buffers = struct {
    pub const Request = struct {
        // unknown start required_start_align
        // unknown end required_start_align
        pixmap: Pixmap,
        window: Window,
        num_buffers: u8,
        width: u16,
        height: u16,
        stride0: u32,
        offset0: u32,
        stride1: u32,
        offset1: u32,
        stride2: u32,
        offset2: u32,
        stride3: u32,
        offset3: u32,
        depth: u8,
        bpp: u8,
        modifier: u64,
        buffers: []const std.posix.fd_t,
    };
};
pub const buffers_from_pixmap = struct {
    pub const Request = struct {
        pixmap: Pixmap,
    };
    pub const Reply = struct {
        // unknown start required_start_align
        // unknown end required_start_align
        nfd: u8,
        width: u16,
        height: u16,
        modifier: u64,
        depth: u8,
        bpp: u8,
        strides: []const u32,
        offsets: []const u32,
        buffers: []const std.posix.fd_t,
    };
};
pub const set_drm_device_in_use = struct {
    pub const Request = struct {
        window: Window,
        drmMajor: u32,
        drmMinor: u32,
    };
};
pub const import_syncobj = struct {
    pub const Request = struct {
        syncobj: SyncObject,
        drawable: Drawable,
        fd: std.posix.fd_t,
    };
};
pub const free_syncobj = struct {
    pub const Request = struct {
        syncobj: SyncObject,
    };
};
