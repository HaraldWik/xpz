const std = @import("std");
const core = @import("core.zig");
const common = @import("protocol.zig").common;
const Window = @import("../window.zig").Window;

pub const RequestHeader = extern struct {
    pub const Opcode = enum(u8) {
        query_version = 1,
        set_screen_config = 2,
        select_input = 4,
        get_screen_info = 5,
        // added in RandR 1.2
        get_screen_size_range = 6,
        set_screen_size = 7,
        get_screen_resources = 8,
        get_output_info = 9,
        list_output_properties = 10,
        query_output_property = 11,
        configure_output_property = 12,
        change_output_property = 13,
        delete_output_property = 14,
        get_output_property = 15,
        create_mode = 16,
        // SetCrtcConfig is opcode 21 in the spec
        set_crtc_config = 21,
        get_crtc_gamma_size = 22,
        get_crtc_gamma = 23,
        set_crtc_gamma = 24,
        // RandR 1.3 additions
        get_screen_resources_current = 25,
        set_crtc_transform = 26,
        get_crtc_transform = 27,
        get_panning = 28,
        set_panning = 29,
        set_output_primary = 30,
        get_output_primary = 31,
        // RandR 1.4
        get_providers = 32,
        get_provider_info = 37,
        configure_provider_property = 38,
        change_provider_property = 39,
        delete_provider_property = 40,
        get_provider_property = 41,
        // RandR 1.5
        get_monitors = 42,
        set_monitor = 43,
        delete_monitor = 44,
    };

    major_opcode: u8,
    minor_opcode: Opcode,
    length: common.Length,
};

pub const get_monitors = struct {
    pub const Request = extern struct {
        header: RequestHeader,
        window: Window, // root window
        get_active: bool, // true = only active monitors, false = all
        pad0: [3]u8 = undefined,
    };

    pub const Reply = extern struct {
        header: core.ReplyHeader,

        timestamp: u32,
        monitor_count: u32,
        output_count: u32,

        pad0: [12]u8,
    };
};
