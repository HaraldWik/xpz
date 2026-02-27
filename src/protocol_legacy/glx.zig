const core = @import("core.zig");
const common = @import("protocol.zig").common;
const Window = @import("../window.zig").Window;
const Drawable = @import("../root.zig").Drawable;
const Visual = @import("../root.zig").Visual;
const Context = @import("../glx.zig").Context;

pub const RequestHeader = extern struct {
    pub const Opcode = enum(u8) {
        get_version = 1,
        render = 2,
        make_current = 3,
        is_direct = 6,
        query_extensions_string = 7,
        get_visual_configs = 4,
        create_context = 5,
        destroy_context = 8,
        swap_buffers = 10,
        copy_sub_buffer = 11,
        create_glx_pixmap = 12,
        destroy_glx_pixmap = 13,
        query_context = 14,
        select_event = 15,
        get_selected_event = 16,
        query_extensions = 17,
        bind_tex_image = 18,
        release_tex_image = 19,
        query_server_string = 20,
        client_info = 21,
        create_pbuffer = 22,
        destroy_pbuffer = 23,
        query_drawable = 24,
        wait_gl = 25,
        wait_x = 26,
    };

    major_opcode: u8,
    minor_opcode: Opcode,
    length: common.Length,
};

pub const query_version = struct {
    pub const Request = extern struct {
        header: RequestHeader,
        version: common.Version,
    };

    pub const Reply = extern struct {
        header: core.ReplyHeader,
        version: common.Version,
        pad: [20]u8,
    };
};

pub const get_visual_configs = struct {
    pub const Request = extern struct {
        header: RequestHeader,
        screen_index: u32,
    };

    pub const Reply = extern struct {
        header: core.ReplyHeader,
        visuals_count: u32, // number of GLXFBConfigs returned
        pad0: u32 = undefined,
        // Followed by n_visuals * GLXFBConfig structs
    };
};

pub const CreateContext = extern struct {
    header: RequestHeader,
    context: Context,
    visual_id: Visual.Id,
    screen_index: u32,
    render_type: RenderType,
    share_list: Context = @enumFromInt(0), // context ID to share with (0 if none)
    is_direct: bool, // 1 for direct rendering, 0 for indirect
    pad0: [3]u8 = undefined,

    pub const RenderType = enum(u32) {
        rgba = 0x8014,
        color_index = 0x8015,
        _,
    };
};

pub const make_current = struct {
    pub const Request = extern struct {
        header: RequestHeader,
        drawable: Drawable,
        context: Context,
        screen_index: u32,
        pad0: u32 = undefined,
    };

    pub const Reply = extern struct {
        header: core.ReplyHeader,
        context_tag: Context.Tag,
        padding: [20]u8 = undefined,
    };
};

pub const SwapBuffers = extern struct {
    header: RequestHeader,
    drawable: Drawable,
    context_tag: Context.Tag,
};
