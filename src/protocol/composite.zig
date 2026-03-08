const core = @import("../client/core.zig");

pub const composite = struct {
    pub const Opcode = enum(u8) {
        query_version = 0,
        redirect_window = 1,
        redirect_subwindows = 2,
        unredirect_window = 3,
        unredirect_subwindows = 4,
        create_region_from_border_clip = 5,
        name_window_pixmap = 6,
        get_overlay_window = 7,
        release_overlay_window = 8,
    };

    pub const Region = enum(u32) {
        _,
    };

    pub const Redirect = enum(u32) {
        automatic = 0,
        manual = 1,
    };
    pub const query_version = struct {
        pub const Request = struct {
            client_major_version: u32,
            client_minor_version: u32,
        };
        pub const Reply = struct {
            major_version: u32,
            minor_version: u32,
        };
    };
    pub const redirect = struct {
        pub const window = struct {
            pub const Request = struct {
                window: core.Window,
                update: u8,
            };
        };
        pub const subwindows = struct {
            pub const Request = struct {
                window: core.Window,
                update: u8,
            };
        };
    };
    pub const unredirect = struct {
        pub const window = struct {
            pub const Request = struct {
                window: core.Window,
                update: u8,
            };
        };
        pub const subwindows = struct {
            pub const Request = struct {
                window: core.Window,
                update: u8,
            };
        };
    };
    pub const create_region_from_border_clip = struct {
        pub const Request = struct {
            region: Region,
            window: core.Window,
        };
    };
    pub const name_window_pixmap = struct {
        pub const Request = struct {
            window: core.Window,
            pixmap: core.Pixmap,
        };
    };
    pub const get_overlay_window = struct {
        pub const Request = struct {
            window: core.Window,
        };
        pub const Reply = struct {
            overlay_win: core.Window,
        };
    };
    pub const release_overlay_window = struct {
        pub const Request = struct {
            window: core.Window,
        };
    };
};
