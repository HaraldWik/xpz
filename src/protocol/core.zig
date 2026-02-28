const Connection = @import("../Connection.zig");
const root = @import("../root.zig");

pub const Opcode = enum(u8) {
    create_window = 1,
    change_window_attributes = 2,
    get_window_attributes = 3,
    destroy_window = 4,
    destroy_subwindows = 5,
    change_save_set = 6,
    reparent_window = 7,
    map_window = 8,
    map_subwindows = 9,
    unmap_window = 10,
    unmap_subwindows = 11,
    configure_window = 12,
    circulate_window = 13,
    get_geometry = 14,
    query_tree = 15,
    intern_atom = 16,
    get_atom_name = 17,
    change_property = 18,
    delete_property = 19,
    get_property = 20,
    list_properties = 21,
    set_selection_owner = 22,
    get_selection_owner = 23,
    convert_selection = 24,
    send_event = 25,
    grab_pointer = 26,
    ungrab_pointer = 27,
    grab_button = 28,
    ungrab_button = 29,
    change_active_pointer_grab = 30,
    grab_keyboard = 31,
    ungrab_keyboard = 32,
    grab_key = 33,
    ungrab_key = 34,
    allow_events = 35,
    grab_server = 36,
    ungrab_server = 37,
    query_pointer = 38,
    get_motion_events = 39,
    translate_coords = 40,
    warp_pointer = 41,
    set_input_focus = 42,
    get_input_focus = 43,
    query_keymap = 44,
    open_font = 45,
    close_font = 46,
    query_font = 47,
    query_text_extents = 48,
    list_fonts = 49,
    list_fonts_with_info = 50,
    set_font_path = 51,
    get_font_path = 52,
    create_pixmap = 53,
    free_pixmap = 54,
    create_gc = 55,
    change_gc = 56,
    copy_gc = 57,
    set_dashes = 58,
    set_clip_rectangles = 59,
    free_gc = 60,
    clear_area = 61,
    copy_area = 62,
    copy_plane = 63,
    poly_point = 64,
    poly_line = 65,
    poly_segment = 66,
    poly_rectangle = 67,
    poly_arc = 68,
    fill_poly = 69,
    poly_fill_rectangle = 70,
    poly_fill_arc = 71,
    put_image = 72,
    get_image = 73,
    poly_text8 = 74,
    poly_text16 = 75,
    image_text8 = 76,
    image_text16 = 77,
    create_colormap = 78,
    free_colormap = 79,
    copy_colormap_and_free = 80,
    install_colormap = 81,
    uninstall_colormap = 82,
    list_installed_colormaps = 83,
    alloc_color = 84,
    alloc_named_color = 85,
    alloc_color_cells = 86,
    alloc_color_planes = 87,
    free_colors = 88,
    store_colors = 89,
    store_named_color = 90,
    query_colors = 91,
    lookup_color = 92,
    create_cursor = 93,
    create_glyph_cursor = 94,
    free_cursor = 95,
    recolor_cursor = 96,
    query_best_size = 97,
    query_extension = 98,
    list_extensions = 99,
    change_keyboard_mapping = 100,
    get_keyboard_mapping = 101,
    change_keyboard_control = 102,
    get_keyboard_control = 103,
    bell = 104,
    change_pointer_control = 105,
    get_pointer_control = 106,
    set_screen_saver = 107,
    get_screen_saver = 108,
    change_hosts = 109,
    list_hosts = 110,
    set_access_control = 111,
    set_close_down_mode = 112,
    kill_client = 113,
    rotate_properties = 114,
    force_screen_saver = 115,
    set_pointer_mapping = 116,
    get_pointer_mapping = 117,
    set_modifier_mapping = 118,
    get_modifier_mapping = 119,
    _,
};

pub const setup = struct {
    pub const Request = struct {
        byte_order: u8, // 'l' or 'B' for little and big endian
        pad0: u8 = undefined,
        protocol_version_major: u16,
        protocol_version_minor: u16,
        auth_name_len: u16,
        auth_data_len: u16,
        pad1: u16 = undefined,
        auth: Connection.Auth,
    };

    pub const Reply = extern struct {
        status: Connection.ReplyHeader.ResponseType,
        pad0: u8,
        protocol_version_major: u16,
        protocol_version_minor: u16,
        length: u16,
        release_number: u32,
        resource_id_base: u32,
        resource_id_mask: u32,
        motion_buffer_size: u32,
        vendor_len: u16,
        maximum_request_length: u16,
        screen_count: u8, // aka 'root_len'
        pixmap_format_count: u8,
        image_byte_order: u8, // endian aka 'l' or 'B'
        bitmap_format_bit_order: u8,
        bitmap_format_scanline_unit: u8,
        bitmap_format_scanline_pad: u8,
        min_keycode: u8,
        max_keycode: u8,
        pad1: u32,
    };

    pub const PixmapFormat = extern struct {
        depth: u8,
        bits_per_pixel: u8,
        scanline_pad: u8,
        pad: [5]u8,
    };
};

pub const atom = struct {
    pub const intern = struct {
        pub const Request = struct {
            /// len in bytes
            name_len: u16,
            pad0: u16 = undefined,
            name: []const u8,
        };

        pub const Reply = struct {
            atom: root.Atom,
            pad0: [20]u8 = undefined,
        };
    };

    pub const get_name = struct {
        pub const Request = struct {
            atom: root.Atom,
        };

        pub const Reply = struct {
            name_len: u32,
            pad0: [24]u8,
        };
    };
};

pub const window = struct {
    pub const Create = extern struct {
        // .detail = depth
        window: root.Window,
        parent: root.Window, // screen root or parent
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        border_width: u16,
        class: Class = .input_output,
        visual_id: root.Visual.Id, // usually copied from parent
        value_mask: root.Window.Attributes.Mask,

        pub const Class = enum(u16) {
            copy_from_parent = 0,
            input_output = 1,
            input_only = 2,
        };
    };

    pub const Destroy = struct {
        window: root.Window,
    };

    pub const Map = struct {
        window: root.Window,
    };

    pub const CreateGC = struct {
        cid: root.GContext,
        drawable: root.Drawable,
        mask: u32,
    };

    pub const ChangeAttributes = struct {
        window: root.Window,
        value_mask: root.Window.Attributes.Mask,
    };

    pub const ChangeProperty = struct {
        // .detail = ChangeMode,
        window: root.Window,
        property: root.Atom,
        type: root.Atom,
        format: root.Format,
        pad0: [3]u8 = undefined,
        element_count: u32,
        data: []const u8,

        pub const ChangeMode = enum(u8) {
            replace = 0,
            prepend = 1,
            append = 2,
        };
    };

    pub const ClearArea = struct {
        window: root.Window,
        exposures: bool,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
    };
};

pub const event = struct {
    pub const Send = extern struct {
        // .detail = propagate (bool)
        destination: root.Window,
        event_mask: root.Event.Mask,
    };
};
