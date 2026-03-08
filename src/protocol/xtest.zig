const core = @import("../client/core.zig");

pub const Opcode = enum(u8) {
    get_version = 0,
    compare_cursor = 1,
    fake_input = 2,
    grab_control = 3,
};

pub const Cursor = enum(u32) {
    none = 0,
    current = 1,
};

pub const get_version = struct {
    pub const Request = struct {
        major_version: u8,
        minor_version: u16,
    };
    pub const Reply = struct {
        major_version: u8,
        minor_version: u16,
    };
};
pub const compare_cursor = struct {
    pub const Request = struct {
        window: core.Window,
        cursor: Cursor,
    };
    pub const Reply = struct {
        same: bool,
    };
};
pub const fake_input = struct {
    pub const Request = struct {
        type: u8,
        detail: u8,
        time: u32,
        root: core.Window,
        root_x: i16,
        root_y: i16,
        deviceid: u8,
    };
};
pub const grab_control = struct {
    pub const Request = struct {
        impervious: bool,
    };
};
