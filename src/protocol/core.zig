const Version = @import("protocol.zig").common.Version;
const Atom = @import("../atom.zig").Atom;
const Event = @import("../event.zig").Event;
const Window = @import("../window.zig").Window;
const Visual = @import("../root.zig").Visual;
const GContext = @import("../root.zig").GContext;
const Colormap = @import("../root.zig").Colormap;
const Drawable = @import("../root.zig").Drawable;
const Format = @import("../root.zig").Format;

pub const RequestHeader = extern struct {
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

    opcode: Opcode,
    detail: u8 = 0,
    length: u16,
};

pub const ReplyHeader = extern struct {
    response_type: ResponseType,
    pad0: u8 = undefined,
    sequence: u16,
    length: u32,

    pub const ResponseType = enum(u8) {
        err = 0,
        reply = 1,
        auth = 2,
        _, // events
    };
};

pub const setup = struct {
    pub const Request = extern struct {
        byte_order: u8, // 'l' or 'B'
        pad0: u8 = undefined,
        protocol_version: Version,
        auth_name_len: u16,
        auth_data_len: u16,
        pad1: u16 = undefined,
        // auth_name padded to 4 bytes
        // auth_data padded to 4 bytes
    };

    pub const Reply = extern struct {
        status: ReplyHeader.ResponseType,
        pad0: u8,
        protocol_version: Version,
        length: u16,
        release_number: u32,
        resource_id_base: u32,
        resource_id_mask: u32,
        motion_buffer_size: u32,
        vendor_len: u16,
        maximum_request_length: u16,
        screen_count: u8, // 'root_len'
        pixmap_format_count: u8,
        image_byte_order: u8, // endian
        bitmap_format_bit_order: u8,
        bitmap_format_scanline_unit: u8,
        bitmap_format_scanline_pad: u8,
        min_keycode: u8,
        max_keycode: u8,
        pad1: u32,
    };

    pub const Failed = struct {
        status: u8,
        reason_len: u8,
        protocol_major_version: u16,
        protocol_minor_version: u16,
        length: u16,
    };

    pub const PixmapFormat = extern struct {
        depth: u8,
        bits_per_pixel: u8,
        scanline_pad: u8,
        pad: [5]u8,
    };
};

pub const atom = struct {
    pub const intern = extern struct {
        pub const Request = extern struct {
            header: RequestHeader, // detail is only_if_exists: bool
            name_len: u16,
            pad0: u16 = undefined,
            // name
        };

        pub const Reply = extern struct {
            header: ReplyHeader,
            atom: Atom,
            pad0: [20]u8,
        };
    };
};

pub const window = struct {
    pub const Create = extern struct {
        header: RequestHeader = .{
            .opcode = .create_window,
            .length = 0, // EXAMPLE: .length = 8 + flag_count;
        },
        window: Window,
        parent: Window, // root window or parent
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        border_width: u16,
        class: Class = .input_output,
        visual_id: Visual.Id, // usually copied from parent
        value_mask: Window.Attributes.Mask,

        pub const Class = enum(u16) {
            copy_from_parent = 0,
            input_output = 1,
            input_only = 2,
        };
    };

    pub const Destroy = extern struct {
        header: RequestHeader = .{
            .opcode = .destroy_window,
            .length = @sizeOf(@This()) / 4,
        },
        window: Window,
    };

    pub const Map = extern struct {
        header: RequestHeader = .{
            .opcode = .map_window,
            .length = @sizeOf(@This()) / 4,
        },
        window: Window,
    };

    pub const CreateGC = extern struct {
        header: RequestHeader,
        cid: GContext,
        drawable: Drawable,
        mask: u32,
    };

    pub const Kill = extern struct {
        header: RequestHeader = .{
            .opcode = .kill_client,
            .length = @sizeOf(@This()) / 4,
        },
        window: Window,
    };

    pub const ChangeAttributes = extern struct {
        header: RequestHeader = .{
            .opcode = .change_window_attributes,
            .length = 0,
        },
        window: Window,
        value_mask: Window.Attributes.Mask,
    };

    pub const ChangeProperty = extern struct {
        // .detail = ChangeMode,
        header: RequestHeader,
        window: Window,
        property: Atom,
        type: Atom,
        format: Format,
        pad0: [3]u8 = undefined,

        pub const ChangeMode = enum(u8) {
            replace = 0,
            prepend = 1,
            append = 2,
        };
    };

    pub const ClearArea = extern struct {
        header: RequestHeader = .{
            .opcode = .clear_area,
            .length = 4,
        },
        window: Window,
        exposures: bool,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
    };
};

pub const colormap = struct {
    pub const Create = extern struct {
        /// .detail =  AllocNone = 0, AllocAll = 1
        header: RequestHeader,
        colormap: Colormap,
        window: Window,
        visual_id: Visual.Id,
    };
    pub const Free = extern struct {
        header: RequestHeader = .{
            .opcode = .free_colormap,
            .length = 2,
        },
        colormap: Colormap,
    };

    pub const CopyAndFree = extern struct {
        header: RequestHeader = .{
            .opcode = .copy_colormap_and_free,
            .length = 3,
        },

        dest: Colormap,
        src: Colormap,
    };

    pub const Install = extern struct {
        header: RequestHeader = .{
            .opcode = .free_colormap,
            .length = 2,
        },
        colormap: Colormap,
    };

    pub const Uninstall = extern struct {
        header: RequestHeader = .{
            .opcode = .uninstall_colormap,
            .detail = 2,
        },
        colormap: Colormap,
    };

    pub const list_installed = struct {
        pub const Request = extern struct {
            header: RequestHeader = .{
                .opcode = .list_installed_colormaps,
                .length = 2,
            },
            window: Window,
        };

        pub const Reply = extern struct {
            header: ReplyHeader,
            colormap_count: u16,
            pad0: [22]u8,
        };
    };
};

pub const event = struct {
    pub const Send = extern struct {
        // .detail = propagate
        header: RequestHeader,
        destination: Window,
        event_mask: Event.Mask,
    };
};

pub const extension = struct {
    pub const query = struct {
        pub const Request = extern struct {
            header: RequestHeader,
            name_len: u16,
            pad0: u16 = undefined,
        };

        pub const Reply = extern struct {
            header: ReplyHeader,
            present: bool,
            major_opcode: u8,
            first_event: u8,
            first_error: u8,
            pad0: [20]u8,
        };
    };
};
