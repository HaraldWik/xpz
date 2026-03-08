const core = @import("../client/core.zig");

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
    translate_coordinates = 40,
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
    create_g_c = 55,
    change_g_c = 56,
    copy_g_c = 57,
    set_dashes = 58,
    set_clip_rectangles = 59,
    free_g_c = 60,
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
    no_operation = 127,
};

pub const CHAR2B = struct {
    byte1: u8,
    byte2: u8,
};

pub const setup = struct {
    pub const Request = struct {
        byte_order: u8,
        pad0: u8 = 0,
        protocol_major_version: u16,
        protocol_minor_version: u16,
        authorization_protocol_name_len: u16,
        authorization_protocol_data_len: u16,
        pad1: u16 = 0,
        authorization_protocol_name: []const u8,
        authorization_protocol_data: []const u8,
    };
    pub const Failed = struct {
        status: u8,
        reason_len: u8,
        protocol_major_version: u16,
        protocol_minor_version: u16,
        length: u16,
        reason: []const u8,

        pub const Authenticate = struct {
            status: u8,
            length: u16,
            reason: []const u8,
        };
    };
    pub const Reply = struct {
        status: u8,
        pad0: u8,
        protocol_major_version: u16,
        protocol_minor_version: u16,
        length: u16,
        release_number: u32,
        resource_id_base: u32,
        resource_id_mask: u32,
        motion_buffer_size: u32,
        vendor_len: u16,
        maximum_request_length: u16,
        roots_len: u8,
        pixmap_formats_len: u8,
        image_byte_order: u8,
        bitmap_format_bit_order: u8,
        bitmap_format_scanline_unit: u8,
        bitmap_format_scanline_pad: u8,
        min_keycode: u8,
        max_keycode: u8,
        pad1: u32,
        vendor: []const u8,
        pixmap_formats: []const core.Format,
        roots: []const core.Screen,
    };
};

pub const ImageOrder = enum(u32) {
    lsb_first = 0,
    msb_first = 1,
};

pub const ModMask = packed struct(u32) {
    shift: bool = false,
    lock: bool = false,
    control: bool = false,
    @"1": bool = false,
    @"2": bool = false,
    @"3": bool = false,
    @"4": bool = false,
    @"5": bool = false,
    any: bool = false,
};
pub const KeyButMask = packed struct(u32) {
    shift: bool = false,
    lock: bool = false,
    control: bool = false,
    mod1: bool = false,
    mod2: bool = false,
    mod3: bool = false,
    mod4: bool = false,
    mod5: bool = false,
    button1: bool = false,
    button2: bool = false,
    button3: bool = false,
    button4: bool = false,
    button5: bool = false,
};
pub const KeyPress = struct {
    detail: core.key.Code,
    time: u32,
    root: core.Window,
    event: core.Window,
    child: core.Window,
    root_x: i16,
    root_y: i16,
    event_x: i16,
    event_y: i16,
    state: u16,
    same_screen: bool,
    // unknown start see
    // unknown end see
    // unknown start see
    // unknown end see
};
// unknown start eventcopy
// unknown end eventcopy
pub const ButtonMask = packed struct(u32) {
    @"1": bool = false,
    @"2": bool = false,
    @"3": bool = false,
    @"4": bool = false,
    @"5": bool = false,
    any: bool = false,
};
pub const ButtonPress = struct {
    // detail: BUTTON,
    time: u32,
    root: core.Window,
    event: core.Window,
    child: core.Window,
    root_x: i16,
    root_y: i16,
    event_x: i16,
    event_y: i16,
    state: u16,
    same_screen: bool,
};
pub const Motion = enum(u32) {
    normal = 0,
    hint = 1,
};
pub const MotionNotify = struct {
    detail: u8,
    time: u32,
    root: core.Window,
    event: core.Window,
    child: core.Window,
    root_x: i16,
    root_y: i16,
    event_x: i16,
    event_y: i16,
    state: u16,
    same_screen: bool,
};
pub const NotifyDetail = enum(u32) {
    ancestor = 0,
    virtual = 1,
    inferior = 2,
    nonlinear = 3,
    nonlinear_virtual = 4,
    pointer = 5,
    pointer_root = 6,
    none = 7,
};
pub const NotifyMode = enum(u32) {
    normal = 0,
    grab = 1,
    ungrab = 2,
    while_grabbed = 3,
};
pub const EnterNotify = struct {
    detail: u8,
    time: u32,
    root: core.Window,
    event: core.Window,
    child: core.Window,
    root_x: i16,
    root_y: i16,
    event_x: i16,
    event_y: i16,
    state: u16,
    mode: u8,
    same_screen_focus: u8,
};
// unknown start eventcopy
// unknown end eventcopy
pub const FocusIn = struct {
    detail: u8,
    event: core.Window,
    mode: u8,
};
// unknown start eventcopy
// unknown end eventcopy
pub const KeymapNotify = struct {
    keys: []const u8,
};
pub const Expose = struct {
    window: core.Window,
    x: u16,
    y: u16,
    width: u16,
    height: u16,
    count: u16,
};
pub const GraphicsExposure = struct {
    drawable: core.Drawable,
    x: u16,
    y: u16,
    width: u16,
    height: u16,
    minor_opcode: u16,
    count: u16,
    major_opcode: u8,
};
pub const NoExposure = struct {
    drawable: core.Drawable,
    minor_opcode: u16,
    major_opcode: u8,
};
pub const Visibility = enum(u32) {
    unobscured = 0,
    partially_obscured = 1,
    fully_obscured = 2,
};
pub const VisibilityNotify = struct {
    window: core.Window,
    state: u8,
};
pub const CreateNotify = struct {
    parent: core.Window,
    window: core.Window,
    x: i16,
    y: i16,
    width: u16,
    height: u16,
    border_width: u16,
    override_redirect: bool,
};
pub const DestroyNotify = struct {
    event: core.Window,
    window: core.Window,
    // unknown start see
    // unknown end see
};
pub const UnmapNotify = struct {
    event: core.Window,
    window: core.Window,
    from_configure: bool,
    // unknown start see
    // unknown end see
};
pub const MapNotify = struct {
    event: core.Window,
    window: core.Window,
    override_redirect: bool,
    // unknown start see
    // unknown end see
};
pub const MapRequest = struct {
    parent: core.Window,
    window: core.Window,
    // unknown start see
    // unknown end see
};
pub const ReparentNotify = struct {
    event: core.Window,
    window: core.Window,
    parent: core.Window,
    x: i16,
    y: i16,
    override_redirect: bool,
};
pub const ConfigureNotify = struct {
    event: core.Window,
    window: core.Window,
    above_sibling: core.Window,
    x: i16,
    y: i16,
    width: u16,
    height: u16,
    border_width: u16,
    override_redirect: bool,
    // unknown start see
    // unknown end see
};
pub const ConfigureRequest = struct {
    stack_mode: u8,
    parent: core.Window,
    window: core.Window,
    sibling: core.Window,
    x: i16,
    y: i16,
    width: u16,
    height: u16,
    border_width: u16,
    value_mask: u16,
};
pub const GravityNotify = struct {
    event: core.Window,
    window: core.Window,
    x: i16,
    y: i16,
};
pub const ResizeRequest = struct {
    window: core.Window,
    width: u16,
    height: u16,
};
pub const Place = enum(u32) {
    on_top = 0,
    on_bottom = 1,
};
pub const CirculateNotify = struct {
    event: core.Window,
    window: core.Window,
    place: u8,
    // unknown start see
    // unknown end see
};
// unknown start eventcopy
// unknown end eventcopy
pub const Property = enum(u32) {
    new_value = 0,
    delete = 1,
};
pub const PropertyNotify = struct {
    window: core.Window,
    atom: core.Atom,
    time: u32,
    state: u8,
    // unknown start see
    // unknown end see
};
pub const SelectionClear = struct {
    time: u32,
    owner: core.Window,
    selection: core.Atom,
};
pub const Time = enum(u32) {
    current_time = 0,
};
pub const SelectionRequest = struct {
    time: u32,
    owner: core.Window,
    requestor: core.Window,
    selection: core.Atom,
    target: core.Atom,
    property: core.Atom,
};
pub const SelectionNotify = struct {
    time: u32,
    requestor: core.Window,
    selection: core.Atom,
    target: core.Atom,
    property: core.Atom,
};
pub const ColormapState = enum(u32) {
    uninstalled = 0,
    installed = 1,
};
pub const Colormap = enum(u32) {
    none = 0,
};
pub const ColormapNotify = struct {
    window: core.Window,
    colormap: Colormap,
    new: bool,
    state: u8,
    // unknown start see
    // unknown end see
};
pub const ClientMessageData = extern union {
    data8: []const u8,
    data16: []const u16,
    data32: []const u32,
};
pub const ClientMessage = struct {
    format: u8,
    window: core.Window,
    type: core.Atom,
    data: ClientMessageData,
    // unknown start see
    // unknown end see
};
pub const Mapping = enum(u32) {
    modifier = 0,
    keyboard = 1,
    pointer = 2,
};
pub const MappingNotify = struct {
    request: u8,
    first_keycode: core.key.Code,
    count: u8,
};
pub const Value = struct {
    bad_value: u32,
    minor_opcode: u16,
    major_opcode: u8,
};
pub const WindowClass = enum(u32) {
    copy_from_parent = 0,
    input_output = 1,
    input_only = 2,
};
pub const CW = packed struct(u32) {
    back_pixmap: bool = false,
    back_pixel: bool = false,
    border_pixmap: bool = false,
    border_pixel: bool = false,
    bit_gravity: bool = false,
    win_gravity: bool = false,
    backing_store: bool = false,
    backing_planes: bool = false,
    backing_pixel: bool = false,
    override_redirect: bool = false,
    save_under: bool = false,
    event_mask: bool = false,
    dont_propagate: bool = false,
    colormap: bool = false,
    cursor: bool = false,
    pad0: u17 = 0,
};
pub const BackPixmap = enum(u32) {
    none = 0,
    parent_relative = 1,
};
pub const Gravity = enum(u32) {
    bit_forget = 0,
    win_unmap = 0,
    north_west = 1,
    north = 2,
    north_east = 3,
    west = 4,
    center = 5,
    east = 6,
    south_west = 7,
    south = 8,
    south_east = 9,
    static = 10,
};

pub const create_window = struct { // opcode 1
    pub const Request = struct {
        depth: u8,
        wid: core.Window,
        parent: core.Window,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        border_width: u16,
        class: u16,
        visual: core.Visual.Id,
        value_mask: u32,
        background_pixmap: core.Pixmap,
        background_pixel: u32,
        border_pixmap: core.Pixmap,
        border_pixel: u32,
        bit_gravity: u32,
        win_gravity: u32,
        backing_store: u32,
        backing_planes: u32,
        backing_pixel: u32,
        override_redirect: u32, // bool
        save_under: u32, // bool
        event_mask: u32,
        do_not_propogate_mask: u32,
        colormap: Colormap,
        cursor: core.Cursor,
    };
};
pub const change_window_attributes = struct {
    pub const Request = struct {
        window: core.Window,
        value_mask: u32,
        background_pixmap: core.Pixmap,
        background_pixel: u32,
        border_pixmap: core.Pixmap,
        border_pixel: u32,
        bit_gravity: u32,
        win_gravity: u32,
        backing_store: u32,
        backing_planes: u32,
        backing_pixel: u32,
        override_redirect: u32, // bool
        save_under: u32, // bool
        event_mask: u32,
        do_not_propogate_mask: u32,
        colormap: Colormap,
        cursor: core.Cursor,
    };
};
pub const MapState = enum(u32) {
    unmapped = 0,
    unviewable = 1,
    viewable = 2,
};
pub const get_window_attributes = struct {
    pub const Request = struct {
        window: core.Window,
    };
    pub const Reply = struct {
        backing_store: u8,
        visual: core.Visual.Id,
        class: u16,
        bit_gravity: u8,
        win_gravity: u8,
        backing_planes: u32,
        backing_pixel: u32,
        save_under: bool,
        map_is_installed: bool,
        map_state: u8,
        override_redirect: bool,
        colormap: Colormap,
        all_event_masks: u32,
        your_event_mask: u32,
        do_not_propagate_mask: u16,
    };
};
pub const destroy_window = struct {
    pub const Request = struct {
        window: core.Window,
    };
};
pub const DestroySubwindows = struct {
    pub const Request = struct {
        window: core.Window,
    };
};
pub const change_save_set = struct {
    pub const Request = struct {
        mode: u8,
        window: core.Window,

        pub const SetMode = enum(u8) {
            insert = 0,
            delete = 1,
        };
    };
};
pub const reparent_window = struct {
    pub const Request = struct {
        window: core.Window,
        parent: core.Window,
        x: i16,
        y: i16,
    };
};
pub const map_window = struct {
    pub const Request = struct {
        window: core.Window,
    };
};
pub const map_subwindows = struct {
    pub const Request = struct {
        window: core.Window,
    };
};
pub const unmap_window = struct {
    pub const Request = struct {
        window: core.Window,
    };
};
pub const unmap_subwindows = struct {
    pub const Request = struct {
        window: core.Window,
    };
};
pub const ConfigWindow = packed struct(u32) {
    x: bool = false,
    y: bool = false,
    width: bool = false,
    height: bool = false,
    border_width: bool = false,
    sibling: bool = false,
    stack_mode: bool = false,
    pad0: u25 = 0,
};

pub const configure_window = struct {
    pub const Request = struct {
        window: core.Window,
        value_mask: u16,
        x: i32,
        y: i32,
        width: u32,
        height: u32,
        border_width: u32,
        sibling: core.Window,
        stack_mode: StackMode,

        pub const StackMode = enum(u32) {
            above = 0,
            below = 1,
            top_if = 2,
            bottom_if = 3,
            opposite = 4,
        };
    };
};
pub const circulate_window = struct {
    pub const Request = struct {
        direction: enum(u8) {
            raise_lowest = 0,
            lower_highest = 1,
        },
        window: core.Window,
    };
};
pub const get_geometry = struct {
    pub const Request = struct {
        drawable: core.Drawable,
    };
    pub const Reply = struct {
        depth: u8,
        root: core.Window,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        border_width: u16,
    };
};
pub const query_tree = struct {
    pub const Request = struct {
        window: core.Window,
    };
    pub const Reply = struct {
        root: core.Window,
        parent: core.Window,
        children_len: u16,
        children: []const core.Window,
    };
};
pub const intern_atom = struct {
    pub const Request = struct {
        // detail only_if_exists: bool,
        name_len: u16,
        name: []const u8,
    };
    pub const Reply = struct {
        atom: core.Atom,
    };
};
pub const get_atom_name = struct {
    pub const Request = struct {
        atom: core.Atom,
    };
    pub const Reply = struct {
        name_len: u16,
        name: []const u8,
    };
};
pub const PropMode = enum(u32) { // TODO: Move this out
    replace = 0,
    prepend = 1,
    append = 2,
};
pub const change_property = struct {
    pub const Request = struct {
        // detail mode: PropMode,
        window: core.Window,
        property: core.Atom,
        type: core.Atom,
        format: u8,
        data_len: u32,
        data: []const void,
    };
};
pub const delete_property = struct {
    pub const Request = struct {
        window: core.Window,
        property: core.Atom,
    };
};
pub const get_property = struct { // opcode 20
    pub const Request = struct {
        delete: bool,
        window: core.Window,
        property: core.Atom,
        type: core.Atom,
        long_offset: u32,
        long_length: u32,
    };
    pub const Reply = struct {
        format: u8,
        type: core.Atom,
        bytes_after: u32,
        value_len: u32,
        value: []const void,
    };
};
pub const list_properties = struct {
    pub const Request = struct {
        window: core.Window,
    };
    pub const Reply = struct {
        atoms_len: u16,
        atoms: []const core.Atom,
    };
};
pub const set_selection_owner = struct {
    pub const Request = struct {
        owner: core.Window,
        selection: core.Atom,
        time: u32,
    };
};
pub const get_selection_owner = struct {
    pub const Request = struct {
        selection: core.Atom,
    };
    pub const Reply = struct {
        owner: core.Window,
    };
};
pub const ConvertSelection = struct {
    pub const Request = struct {
        requestor: core.Window,
        selection: core.Atom,
        target: core.Atom,
        property: core.Atom,
        time: u32,
    };
};
pub const SendEventDest = enum(u32) {
    pointer_window = 0,
    item_focus = 1,
};
pub const send_event = struct {
    pub const Request = struct {
        propagate: bool,
        destination: core.Window,
        event_mask: u32,
        event: []const u8,
    };
};
pub const GrabMode = enum(u32) {
    sync = 0,
    async = 1,
};
pub const GrabStatus = enum(u32) {
    success = 0,
    already_grabbed = 1,
    invalid_time = 2,
    not_viewable = 3,
    frozen = 4,
};

pub const grab_pointer = struct {
    pub const Request = struct {
        owner_events: bool,
        grab_window: core.Window,
        event_mask: u16,
        pointer_mode: u8,
        keyboard_mode: u8,
        confine_to: core.Window,
        cursor: core.Cursor,
        time: u32,
    };
    pub const Reply = struct {
        status: u8,
    };
};
pub const ungrab_pointer = struct {
    pub const Request = struct {
        time: u32,
    };
};
pub const ButtonIndex = enum(u32) {
    any = 0,
    @"1" = 1,
    @"2" = 2,
    @"3" = 3,
    @"4" = 4,
    @"5" = 5,
};
pub const grab_button = struct {
    pub const Request = struct {
        owner_events: bool,
        grab_window: core.Window,
        event_mask: u16,
        pointer_mode: u8,
        keyboard_mode: u8,
        confine_to: core.Window,
        cursor: core.Cursor,
        button: u8,
        modifiers: u16,
    };
};
pub const UngrabButton = struct {
    pub const Request = struct {
        button: u8,
        grab_window: core.Window,
        modifiers: u16,
    };
};
pub const change_active_pointer_grab = struct {
    pub const Request = struct {
        cursor: core.Cursor,
        time: u32,
        event_mask: u16,
    };
};
pub const grab_keyboard = struct {
    pub const Request = struct {
        owner_events: bool,
        grab_window: core.Window,
        time: u32,
        pointer_mode: u8,
        keyboard_mode: u8,
    };
    pub const Reply = struct {
        status: u8,
    };
};
pub const ungrab_keyboard = struct {
    pub const Request = struct {
        time: u32,
    };
};
pub const Grab = enum(u32) { // TODO move this out
    any = 0,
    _,
};
pub const grab_key = struct {
    pub const Request = struct {
        owner_events: bool,
        grab_window: core.Window,
        modifiers: u16,
        key: core.key.Code,
        pointer_mode: u8,
        keyboard_mode: u8,
    };
};
pub const ungrab_key = struct { // opcode 34
    pub const Request = struct {
        key: core.key.Code,
        grab_window: core.Window,
        modifiers: u16,
    };
};
pub const Allow = enum(u32) {
    async_pointer = 0,
    sync_pointer = 1,
    replay_pointer = 2,
    async_keyboard = 3,
    sync_keyboard = 4,
    replay_keyboard = 5,
    async_both = 6,
    sync_both = 7,
};
pub const allow_events = struct {
    pub const Request = struct {
        mode: u8,
        time: u32,
    };
};
pub const grab_server = struct {
    pub const Request = struct {};
};
pub const ungrab_server = struct {
    pub const Request = struct {};
};
pub const query_pointer = struct {
    pub const Request = struct {
        window: core.Window,
    };
    pub const Reply = struct {
        same_screen: bool,
        root: core.Window,
        child: core.Window,
        root_x: i16,
        root_y: i16,
        win_x: i16,
        win_y: i16,
        mask: u16,
    };
};
pub const TIMECOORD = struct {
    time: u32,
    x: i16,
    y: i16,
};
pub const get_motion_events = struct {
    pub const Request = struct {
        window: core.Window,
        start: u32,
        stop: u32,
    };
    pub const Reply = struct {
        events_len: u32,
        events: []const TIMECOORD,
    };
};
pub const translate_coordinates = struct {
    pub const Request = struct {
        src_window: core.Window,
        dst_window: core.Window,
        src_x: i16,
        src_y: i16,
    };
    pub const Reply = struct {
        same_screen: bool,
        child: core.Window,
        dst_x: i16,
        dst_y: i16,
    };
};
pub const warp_pointer = struct {
    pub const Request = struct {
        src_window: core.Window,
        dst_window: core.Window,
        src_x: i16,
        src_y: i16,
        src_width: u16,
        src_height: u16,
        dst_x: i16,
        dst_y: i16,
    };
};
pub const InputFocus = enum(u32) {
    none = 0,
    pointer_root = 1,
    parent = 2,
    follow_keyboard = 3,
};
pub const set_input_focus = struct {
    pub const Request = struct {
        revert_to: u8,
        focus: core.Window,
        time: u32,
    };
};
pub const get_input_focus = struct {
    pub const Request = struct {};
    pub const Reply = struct {
        revert_to: u8,
        focus: core.Window,
    };
};
pub const query_keymap = struct {
    pub const Request = struct {};
    pub const Reply = struct {
        keys: []const u8,
    };
};
pub const open_font = struct {
    pub const Request = struct {
        font: core.Font,
        name_len: u16,
        name: []const u8,
    };
};
pub const close_font = struct {
    pub const Request = struct {
        font: core.Font,
    };
};
pub const FontDraw = enum(u32) {
    left_to_right = 0,
    right_to_left = 1,
};
pub const FONTPROP = struct { // TODO move
    name: core.Atom,
    value: u32,
};
pub const CHARINFO = struct { // TODO move
    left_side_bearing: i16,
    right_side_bearing: i16,
    character_width: i16,
    ascent: i16,
    descent: i16,
    attributes: u16,
};
pub const query_font = struct {
    pub const Request = struct {
        font: core.Font.Fontable,
    };
    pub const Reply = struct {
        min_bounds: CHARINFO,
        max_bounds: CHARINFO,
        min_char_or_byte2: u16,
        max_char_or_byte2: u16,
        default_char: u16,
        properties_len: u16,
        draw_direction: u8,
        min_byte1: u8,
        max_byte1: u8,
        all_chars_exist: bool,
        font_ascent: i16,
        font_descent: i16,
        char_infos_len: u32,
        properties: []const FONTPROP,
        char_infos: []const CHARINFO,
    };
};
pub const query_text_extents = struct {
    pub const Request = struct {
        font: core.Font.Fontable,
        string: []const CHAR2B,
    };
    pub const Reply = struct {
        draw_direction: u8,
        font_ascent: i16,
        font_descent: i16,
        overall_ascent: i16,
        overall_descent: i16,
        overall_width: i32,
        overall_left: i32,
        overall_right: i32,
    };
};
pub const STR = struct { // TODO move to top
    name_len: u8,
    name: []const u8,
};
pub const list_fonts = struct {
    pub const Request = struct {
        max_names: u16,
        pattern_len: u16,
        pattern: []const u8,
    };
    pub const Reply = struct {
        names_len: u16,
        names: []const STR,
    };
};
pub const list_fonts_with_info = struct {
    pub const Request = struct {
        max_names: u16,
        pattern_len: u16,
        pattern: []const u8,
    };
    pub const Reply = struct {
        name_len: u8,
        min_bounds: CHARINFO,
        max_bounds: CHARINFO,
        min_char_or_byte2: u16,
        max_char_or_byte2: u16,
        default_char: u16,
        properties_len: u16,
        draw_direction: u8,
        min_byte1: u8,
        max_byte1: u8,
        all_chars_exist: bool,
        font_ascent: i16,
        font_descent: i16,
        replies_hint: u32,
        properties: []const FONTPROP,
        name: []const u8,
    };
};
pub const set_font_path = struct {
    pub const Request = struct {
        font_qty: u16,
        font: []const STR,
    };
};
pub const get_font_path = struct {
    pub const Request = struct {};
    pub const Reply = struct {
        path_len: u16,
        path: []const STR,
    };
};
pub const create_pixmap = struct {
    pub const Request = struct {
        depth: u8,
        pid: core.Pixmap,
        drawable: core.Drawable,
        width: u16,
        height: u16,
    };
};
pub const free_pixmap = struct {
    pub const Request = struct {
        pixmap: core.Pixmap,
    };
};

// TODO Move these
pub const GC = packed struct(u32) {
    function: bool = false,
    plane_mask: bool = false,
    foreground: bool = false,
    background: bool = false,
    line_width: bool = false,
    line_style: bool = false,
    cap_style: bool = false,
    join_style: bool = false,
    fill_style: bool = false,
    fill_rule: bool = false,
    tile: bool = false,
    stipple: bool = false,
    tile_stipple_origin_x: bool = false,
    tile_stipple_origin_y: bool = false,
    font: bool = false,
    subwindow_mode: bool = false,
    graphics_exposures: bool = false,
    clip_origin_x: bool = false,
    clip_origin_y: bool = false,
    clip_mask: bool = false,
    dash_offset: bool = false,
    dash_list: bool = false,
    arc_mode: bool = false,
    pad0: u9 = 0,
};
pub const GX = enum(u32) {
    clear = 0,
    @"and" = 1,
    and_reverse = 2,
    copy = 3,
    and_inverted = 4,
    noop = 5,
    xor = 6,
    @"or" = 7,
    nor = 8,
    equiv = 9,
    invert = 10,
    or_reverse = 11,
    copy_inverted = 12,
    or_inverted = 13,
    nand = 14,
    set = 15,
};
pub const LineStyle = enum(u32) {
    solid = 0,
    on_off_dash = 1,
    double_dash = 2,
};
pub const CapStyle = enum(u32) {
    not_last = 0,
    butt = 1,
    round = 2,
    projecting = 3,
};
pub const JoinStyle = enum(u32) {
    miter = 0,
    round = 1,
    bevel = 2,
};
pub const FillStyle = enum(u32) {
    solid = 0,
    tiled = 1,
    stippled = 2,
    opaque_stippled = 3,
};
pub const FillRule = enum(u32) {
    even_odd = 0,
    winding = 1,
};
pub const SubwindowMode = enum(u32) {
    clip_by_children = 0,
    include_inferiors = 1,
};
pub const ArcMode = enum(u32) {
    chord = 0,
    pie_slice = 1,
};

pub const create_gc = struct {
    pub const Request = struct {
        cid: core.GContext,
        drawable: core.Drawable,
        value_mask: u32,
        function: u32,
        plane_mask: u32,
        foreground: u32,
        background: u32,
        line_width: u32,
        line_style: u32,
        cap_style: u32,
        join_style: u32,
        fill_style: u32,
        fill_rule: u32,
        tile: core.Pixmap,
        stipple: core.Pixmap,
        tile_stipple_x_origin: i32,
        tile_stipple_y_origin: i32,
        font: core.Font,
        subwindow_mode: SubwindowMode,
        graphics_exposures: u32, // bool
        clip_x_origin: i32,
        clip_y_origin: i32,
        clip_mask: core.Pixmap,
        dash_offset: u32,
        dashes: u32,
        arc_mode: core.Arc.Mode,
    };
};
pub const change_gc = struct {
    pub const Request = struct {
        graphics_context: core.GContext,
        value_mask: u32,
        function: u32,
        plane_mask: u32,
        foreground: u32,
        background: u32,
        line_width: u32,
        line_style: u32,
        cap_style: u32,
        join_style: u32,
        fill_style: u32,
        fill_rule: u32,
        tile: core.Pixmap,
        stipple: core.Pixmap,
        tile_stipple_x_origin: i32,
        tile_stipple_y_origin: i32,
        font: core.Font,
        subwindow_mode: u32,
        graphics_exposures: u32, // bool
        clip_x_origin: i32,
        clip_y_origin: i32,
        clip_mask: core.Pixmap,
        dash_offset: u32,
        dashes: u32,
        arc_mode: u32, // core.Arc.Mode
    };
};
pub const copy_gc = struct {
    pub const Request = struct {
        src_gc: core.GContext,
        dst_gc: core.GContext,
        value_mask: u32,
    };
};
pub const set_dashes = struct {
    pub const Request = struct {
        graphics_context: core.GContext,
        dash_offset: u16,
        dashes_len: u16,
        dashes: []const u8,
    };
};
pub const ClipOrdering = enum(u32) {
    unsorted = 0,
    y_sorted = 1,
    yx_sorted = 2,
    yx_banded = 3,
};
pub const set_clip_rectangles = struct {
    pub const Request = struct {
        ordering: u8,
        graphics_context: core.GContext,
        clip_x_origin: i16,
        clip_y_origin: i16,
        rectangles: []const core.Rectangle,
    };
};
pub const free_gc = struct {
    pub const Request = struct {
        graphics_context: core.GContext,
    };
};
pub const clear_area = struct {
    pub const Request = struct {
        exposures: bool,
        window: core.Window,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
    };
};
pub const copy_area = struct {
    pub const Request = struct {
        src_drawable: core.Drawable,
        dst_drawable: core.Drawable,
        graphics_context: core.GContext,
        src_x: i16,
        src_y: i16,
        dst_x: i16,
        dst_y: i16,
        width: u16,
        height: u16,
    };
};
pub const copy_plane = struct {
    pub const Request = struct {
        src_drawable: core.Drawable,
        dst_drawable: core.Drawable,
        graphics_context: core.GContext,
        src_x: i16,
        src_y: i16,
        dst_x: i16,
        dst_y: i16,
        width: u16,
        height: u16,
        bit_plane: u32,
    };
};
pub const CoordMode = enum(u32) {
    origin = 0,
    previous = 1,
};
pub const poly_point = struct {
    pub const Request = struct {
        coordinate_mode: u8,
        drawable: core.Drawable,
        graphics_context: core.GContext,
        points: []const core.Point,
    };
};
pub const poly_line = struct {
    pub const Request = struct {
        coordinate_mode: u8,
        drawable: core.Drawable,
        graphics_context: core.GContext,
        points: []const core.Point,
    };
};
pub const SEGMENT = struct {
    x1: i16,
    y1: i16,
    x2: i16,
    y2: i16,
};
pub const poly_segment = struct { // opcode 66
    pub const Request = struct {
        drawable: core.Drawable,
        graphics_context: core.GContext,
        segments: []const SEGMENT,
    };
};
pub const poly_rectangle = struct { // opcode 67
    pub const Request = struct {
        drawable: core.Drawable,
        graphics_context: core.GContext,
        rectangles: []const core.Rectangle,
    };
};
pub const poly_arc = struct { // opcode 68
    pub const Request = struct {
        drawable: core.Drawable,
        graphics_context: core.GContext,
        arcs: []const core.Arc,
    };
};
pub const PolyShape = enum(u32) {
    complex = 0,
    nonconvex = 1,
    convex = 2,
};
pub const fill_poly = struct { // opcode 69
    pub const Request = struct {
        drawable: core.Drawable,
        graphics_context: core.GContext,
        shape: u8,
        coordinate_mode: u8,
        points: []const core.Point,
    };
};
pub const poly_fill_rectangle = struct { // opcode 70
    pub const Request = struct {
        drawable: core.Drawable,
        graphics_context: core.GContext,
        rectangles: []const core.Rectangle,
    };
};
pub const poly_fill_arc = struct { // opcode 71
    pub const Request = struct {
        drawable: core.Drawable,
        graphics_context: core.GContext,
        arcs: []const core.Arc,
    };
};
pub const ImageFormat = enum(u32) {
    x_y_bitmap = 0,
    x_y_pixmap = 1,
    z_pixmap = 2,
};
pub const put_image = struct { // opcode 72
    pub const Request = struct {
        format: u8,
        drawable: core.Drawable,
        graphics_context: core.GContext,
        width: u16,
        height: u16,
        dst_x: i16,
        dst_y: i16,
        left_pad: u8,
        depth: u8,
        data: []const u8,
    };
};
pub const get_image = struct { // opcode 73
    pub const Request = struct {
        format: u8,
        drawable: core.Drawable,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        plane_mask: u32,
        pub const Reply = struct {
            depth: u8,
            visual: core.Visual.Id,
            data: []const u8,
        };
    };
};
pub const poly_text8 = struct { // opcode 74
    pub const Request = struct {
        drawable: core.Drawable,
        graphics_context: core.GContext,
        x: i16,
        y: i16,
        items: []const u8,
    };
};
pub const poly_text16 = struct { // opcode 75
    pub const Request = struct {
        drawable: core.Drawable,
        graphics_context: core.GContext,
        x: i16,
        y: i16,
        items: []const u8,
    };
};
pub const image_text8 = struct { // opcode 76
    pub const Request = struct {
        string_len: u8,
        drawable: core.Drawable,
        graphics_context: core.GContext,
        x: i16,
        y: i16,
        string: []const u8,
    };
};
pub const image_text16 = struct { // opcode 77
    pub const Request = struct {
        string_len: u8,
        drawable: core.Drawable,
        graphics_context: core.GContext,
        x: i16,
        y: i16,
        string: []const CHAR2B,
    };
};
pub const ColormapAlloc = enum(u32) {
    none = 0,
    all = 1,
};
pub const create_colormap = struct { // opcode 78
    pub const Request = struct {
        alloc: u8,
        mid: Colormap,
        window: core.Window,
        visual: core.Visual.Id,
    };
};
pub const free_colormap = struct { // opcode 79
    pub const Request = struct {
        cmap: Colormap,
    };
};
pub const copy_colormap_and_free = struct { // opcode 80
    pub const Request = struct {
        mid: Colormap,
        src_cmap: Colormap,
    };
};
pub const install_colormap = struct { // opcode 81
    pub const Request = struct {
        cmap: Colormap,
    };
};
pub const uninstall_colormap = struct { // opcode 82
    pub const Request = struct {
        cmap: Colormap,
    };
    pub const list_installed_colormaps = struct { // opcode 83
        pub const Request = struct {
            window: core.Window,
        };
        pub const Reply = struct {
            cmaps_len: u16,
            cmaps: []const Colormap,
        };
    };
    pub const alloc_color = struct { // opcode 84
        pub const Request = struct {
            cmap: Colormap,
            red: u16,
            green: u16,
            blue: u16,
        };

        pub const Reply = struct {
            red: u16,
            green: u16,
            blue: u16,
            pixel: u32,
        };
    };
    pub const alloc_named_color = struct { // opcode 85
        pub const Request = struct {
            cmap: Colormap,
            name_len: u16,
            name: []const u8,
        };
        pub const Reply = struct {
            pixel: u32,
            exact_red: u16,
            exact_green: u16,
            exact_blue: u16,
            visual_red: u16,
            visual_green: u16,
            visual_blue: u16,
        };
    };
    pub const alloc_color_cells = struct { // opcode 86
        pub const Request = struct {
            contiguous: bool,
            cmap: Colormap,
            colors: u16,
            planes: u16,
        };
        pub const Reply = struct {
            pixels_len: u16,
            masks_len: u16,
            pixels: []const u32,
            masks: []const u32,
        };
    };
    pub const alloc_color_planes = struct { // opcode 87
        pub const Request = struct {
            contiguous: bool,
            cmap: Colormap,
            colors: u16,
            reds: u16,
            greens: u16,
            blues: u16,
        };
        pub const Reply = struct {
            pixels_len: u16,
            red_mask: u32,
            green_mask: u32,
            blue_mask: u32,
            pixels: []const u32,
        };
    };
    pub const free_colors = struct { // opcode 88
        pub const Request = struct {
            cmap: Colormap,
            plane_mask: u32,
            pixels: []const u32,
        };
    };
    pub const ColorFlag = packed struct(u32) {
        red: bool = false,
        green: bool = false,
        blue: bool = false,
        pad0: u29 = 0,
    };
    pub const COLORITEM = struct {
        pixel: u32,
        red: u16,
        green: u16,
        blue: u16,
        flags: u8,
    };
    pub const store_colors = struct { // opcode 89
        pub const Request = struct {
            cmap: Colormap,
            items: []const COLORITEM,
        };
    };
    pub const store_named_color = struct { // opcode 90
        pub const Request = struct {
            flags: u8,
            cmap: Colormap,
            pixel: u32,
            name_len: u16,
            name: []const u8,
        };
    };
    pub const RGB = struct {
        red: u16,
        green: u16,
        blue: u16,
    };
    pub const query_colors = struct { // opcode 91
        pub const Request = struct {
            cmap: Colormap,
            pixels: []const u32,
        };
        pub const Reply = struct {
            colors_len: u16,
            colors: []const RGB,
        };
    };
    pub const lookup_color = struct { // opcode 92
        pub const Request = struct {
            cmap: Colormap,
            name_len: u16,
            name: []const u8,
        };
        pub const Reply = struct {
            exact_red: u16,
            exact_green: u16,
            exact_blue: u16,
            visual_red: u16,
            visual_green: u16,
            visual_blue: u16,
        };
    };
    pub const create_cursor = struct { // opcode 93
        pub const Request = struct {
            cursor: core.Cursor,
            source: core.Pixmap,
            mask: core.Pixmap,
            fore_red: u16,
            fore_green: u16,
            fore_blue: u16,
            back_red: u16,
            back_green: u16,
            back_blue: u16,
            x: u16,
            y: u16,
        };
    };
    pub const Font = enum(u32) {
        none = 0,
        pub const Fontable = u32;
    };
    pub const create_glyph_cursor = struct { // opcode 94
        pub const Request = struct {
            cursor: core.Cursor,
            source_font: core.Font,
            mask_font: core.Font,
            source_char: u16,
            mask_char: u16,
            fore_red: u16,
            fore_green: u16,
            fore_blue: u16,
            back_red: u16,
            back_green: u16,
            back_blue: u16,
        };
    };
    pub const free_cursor = struct { // opcode 95
        pub const Request = struct {
            cursor: core.Cursor,
        };
    };
    pub const recolor_cursor = struct { // opcode 96
        pub const Request = struct {
            cursor: core.Cursor,
            fore_red: u16,
            fore_green: u16,
            fore_blue: u16,
            back_red: u16,
            back_green: u16,
            back_blue: u16,
        };
    };
    pub const QueryShapeOf = enum(u32) {
        largest_cursor = 0,
        fastest_tile = 1,
        fastest_stipple = 2,
    };
};
pub const query_best_size = struct { // opcode 97
    pub const Request = struct {
        class: u8,
        drawable: core.Drawable,
        width: u16,
        height: u16,
        pub const Reply = struct {
            width: u16,
            height: u16,
        };
    };
};
pub const query_extension = struct { // opcode 98
    pub const Request = struct {
        name_len: u16,
        name: []const u8,
    };
    pub const Reply = struct {
        present: bool,
        major_opcode: u8,
        first_event: u8,
        first_error: u8,
    };
};
pub const list_extensions = struct { // opcode 99
    pub const Request = struct {
        pub const Reply = struct {
            names_len: u8,
            names: []const STR,
        };
    };
};
pub const change_keyboard_mapping = struct { // opcode 100
    pub const Request = struct {
        keycode_count: u8,
        first_keycode: core.key.Code,
        keysyms_per_keycode: u8,
        keysyms: []const core.KEYSYM,
    };
};
pub const get_keyboard_mapping = struct { // opcode 101
    pub const Request = struct {
        first_keycode: core.key.Code,
        count: u8,
    };
    pub const Reply = struct {
        keysyms_per_keycode: u8,
        keysyms: []const core.KEYSYM,
    };
};
pub const KB = packed struct(u32) {
    key_click_percent: bool = false,
    bell_percent: bool = false,
    bell_pitch: bool = false,
    bell_duration: bool = false,
    led: bool = false,
    led_mode: bool = false,
    key: bool = false,
    auto_repeat_mode: bool = false,
    pad0: u23 = 0,
};
pub const LedMode = enum(u32) {
    off = 0,
    on = 1,
};
pub const AutoRepeatMode = enum(u32) {
    off = 0,
    on = 1,
    default = 2,
};
pub const change_keyboard_control = struct { // opcode 102
    pub const Request = struct {
        value_mask: u32,
        key_click_percent: i32,
        bell_percent: i32,
        bell_pitch: i32,
        bell_duration: i32,
        led: u32,
        led_mode: u32,
        key: u32, // 32
        auto_repeat_mode: u32,
    };
};
pub const get_keyboard_control = struct { // opcode 103
    pub const Request = struct {};
    pub const Reply = struct {
        global_auto_repeat: u8,
        led_mask: u32,
        key_click_percent: u8,
        bell_percent: u8,
        bell_pitch: u16,
        bell_duration: u16,
        auto_repeats: []const u8,
    };
};
pub const bell = struct { // opcode 104
    pub const Request = struct {
        percent: i8,
    };
};
pub const change_pointer_control = struct { // opcode 105
    pub const Request = struct {
        acceleration_numerator: i16,
        acceleration_denominator: i16,
        threshold: i16,
        do_acceleration: bool,
        do_threshold: bool,
    };
};
pub const get_pointer_control = struct { // opcode 106
    pub const Request = struct {};
    pub const Reply = struct {
        acceleration_numerator: u16,
        acceleration_denominator: u16,
        threshold: u16,
    };
};
pub const Blanking = enum(u32) {
    not_preferred = 0,
    preferred = 1,
    default = 2,
};
pub const Exposures = enum(u32) {
    not_allowed = 0,
    allowed = 1,
    default = 2,
};
pub const set_screen_saver = struct { // opcode 107
    pub const Request = struct {
        timeout: i16,
        interval: i16,
        prefer_blanking: u8,
        allow_exposures: u8,
    };
};
pub const get_screen_saver = struct { // opcode 108
    pub const Request = struct {};
    pub const Reply = struct {
        timeout: u16,
        interval: u16,
        prefer_blanking: u8,
        allow_exposures: u8,
    };
};
pub const HostMode = enum(u32) {
    insert = 0,
    delete = 1,
};
pub const Family = enum(u32) {
    internet = 0,
    d_e_cnet = 1,
    chaos = 2,
    server_interpreted = 5,
    internet6 = 6,
};
pub const change_hosts = struct { // opcode 109
    pub const Request = struct {
        mode: u8,
        family: u8,
        address_len: u16,
        address: []const u8,
    };
};
pub const HOST = struct {
    family: u8,
    address_len: u16,
    address: []const u8,
};
pub const list_hosts = struct { // opcode 110
    pub const Request = struct {};
    pub const Reply = struct {
        mode: u8,
        hosts_len: u16,
        hosts: []const HOST,
    };
};
pub const AccessControl = enum(u32) {
    disable = 0,
    enable = 1,
};
pub const set_access_control = struct { // opcode 111
    pub const Request = struct {
        mode: u8,
    };
};
pub const CloseDown = enum(u32) {
    destroy_all = 0,
    retain_permanent = 1,
    retain_temporary = 2,
};
pub const set_close_down_mode = struct { // opcode 112
    pub const Request = struct {
        mode: u8,
    };
};
pub const Kill = enum(u32) {
    all_temporary = 0,
};
pub const kill_client = struct { // opcode 113
    pub const Request = struct {
        resource: u32,
    };
    pub const Value = struct {};
    // unknown start see
    // unknown end see
};
pub const rotate_properties = struct { // opcode 114
    pub const Request = struct {
        window: core.Window,
        atoms_len: u16,
        delta: i16,
        atoms: []const core.Atom,
    };
};
pub const ScreenSaver = enum(u32) {
    reset = 0,
    active = 1,
};
pub const force_screen_saver = struct { // opcode 115
    pub const Request = struct {
        mode: u8,
    };
};
pub const MappingStatus = enum(u32) {
    success = 0,
    busy = 1,
    failure = 2,
};
pub const set_pointer_mapping = struct { // opcode 116
    pub const Request = struct {
        map_len: u8,
        map: []const u8,
    };
    pub const Reply = struct {
        status: u8,
    };
};
pub const get_pointer_mapping = struct { // opcode 117
    pub const Request = struct {};
    pub const Reply = struct {
        map_len: u8,
        map: []const u8,
    };
};
pub const MapIndex = enum(u32) {
    shift = 0,
    lock = 1,
    control = 2,
    @"1" = 3,
    @"2" = 4,
    @"3" = 5,
    @"4" = 6,
    @"5" = 7,
};
pub const set_modifier_mapping = struct { // opcode 118
    pub const Request = struct {};
    keycodes_per_modifier: u8,
    keycodes: []const core.key.Code,
    pub const Reply = struct {
        status: u8,
    };
};
pub const get_modifier_mapping = struct { // opcode 119
    pub const Request = struct {};
    pub const Reply = struct {
        keycodes_per_modifier: u8,
        keycodes: []const core.key.Code,
    };
};
pub const no_operation = struct { // opcode 127
    pub const Request = struct {};
};
