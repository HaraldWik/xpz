const std = @import("std");
const protocol = @import("protocol/protocol.zig");
const Client = @import("Client.zig");

pub const Atom = enum(u32) {
    none = 0,
    primary = 1,
    secondary = 2,
    arc = 3,
    atom = 4,
    bitmap = 5,
    cardinal = 6,
    colormap = 7,
    cursor = 8,
    cut_buffer0 = 9,
    cut_buffer1 = 10,
    cut_buffer2 = 11,
    cut_buffer3 = 12,
    cut_buffer4 = 13,
    cut_buffer5 = 14,
    cut_buffer6 = 15,
    cut_buffer7 = 16,
    drawable = 17,
    font = 18,
    integer = 19,
    pixmap = 20,
    point = 21,
    rectangle = 22,
    resource_manager = 23,
    rgb_color_map = 24,
    rgb_best_map = 25,
    rgb_blue_map = 26,
    rgb_default_map = 27,
    rgb_gray_map = 28,
    rgb_green_map = 29,
    rgb_red_map = 30,
    string = 31,
    visualid = 32,
    window = 33,
    wm_command = 34,
    wm_hints = 35,
    wm_client_machine = 36,
    wm_icon_name = 37,
    wm_icon_size = 38,
    wm_name = 39,
    wm_normal_hints = 40,
    wm_size_hints = 41,
    wm_zoom_hints = 42,
    min_space = 43,
    norm_space = 44,
    max_space = 45,
    end_space = 46,
    superscript_x = 47,
    superscript_y = 48,
    subscript_x = 49,
    subscript_y = 50,
    underline_position = 51,
    underline_thickness = 52,
    strikeout_ascent = 53,
    strikeout_descent = 54,
    italic_angle = 55,
    x_height = 56,
    quad_width = 57,
    weight = 58,
    point_size = 59,
    resolution = 60,
    copyright = 61,
    notice = 62,
    font_name = 63,
    family_name = 64,
    full_name = 65,
    cap_height = 66,
    wm_class = 67,
    wm_transient_for = 68,
    _,

    pub const clipboard = "CLIPBOARD";
    pub const targets = "TARGETS";
    pub const utf8_string = "UTF8_STRING";

    /// Core ICCCM (legacy) properties
    pub const wm = struct {
        pub const protocols = "WM_PROTOCOLS";
        pub const delete_window = "WM_DELETE_WINDOW";
        pub const take_focus = "WM_TAKE_FOCUS";
    };

    /// EWMH (Extended Window Manager Hints) properties
    pub const net_wm = struct {
        /// UTF-8 title of the window
        pub const name = "_NET_WM_NAME";
        /// UTF8_STRING / 8 Icon title
        pub const icon_name = "_NET_WM_ICON_NAME";
        /// Index of the desktop/workspace the window is on
        pub const desktop = "_NET_WM_DESKTOP";

        pub const state = struct {
            /// List of states like fullscreen, maximized, above, or below
            pub const property = "_NET_WM_STATE";
            /// Make window fullscreen
            pub const fullscreen = "_NET_WM_STATE_FULLSCREEN";
            /// Maximize vertically
            pub const maximized_vert = "_NET_WM_STATE_MAXIMIZED_VERT";
            /// Maximize horizontally
            pub const maximized_horz = "_NET_WM_STATE_MAXIMIZED_HORZ";
            /// Keep window above others
            pub const above = "_NET_WM_STATE_ABOVE";
            /// Keep window below others
            pub const below = "_NET_WM_STATE_BELOW";
            /// Show on all desktops
            pub const sticky = "_NET_WM_STATE_STICKY";
        };
        /// Type of window (normal, dialog, splash, dock, etc.)
        pub const window_type = "_NET_WM_WINDOW_TYPE";
        /// Process ID of the client
        pub const pid = "_NET_WM_PID";
        /// Transparency (0–0xFFFFFFFF)
        pub const opacity = "_NET_WM_OPACITY";
        /// Icon data (width, height, ARGB pixels)
        pub const icon = "_NET_WM_ICON";
        /// Reserved edges (panels/docks)
        pub const strut = "_NET_WM_STRUT";
        /// Reserved edges (panels/docks)
        pub const strut_partial = "_NET_WM_STRUT_PARTIAL";
        /// Tells compositor whether to bypass effects
        pub const bypass_compositor = "_NET_WM_BYPASS_COMPOSITOR";
        // ClientMessage request to move/resize window
        pub const moveresize = "_NET_WM_MOVERESIZE";
        /// Geometry info for iconified windows
        pub const icon_geometry = "_NET_WM_ICON_GEOMETRY";
        /// What actions WM can do (move, resize, close)
        pub const allowed_actions = "_NET_WM_ALLOWED_ACTIONS";
        /// Which monitors a fullscreen window covers
        pub const fullscreen_monitors = "_NET_WM_FULLSCREEN_MONITORS";
    };

    /// Workspace / Window Management Properties
    pub const net = struct {
        /// Set by WM; client can request focus via ClientMessage
        pub const active_window = "_NET_ACTIVE_WINDOW";
        /// Set by WM; list of managed windows
        pub const client_list = "_NET_CLIENT_LIST";
        /// Set by WM; stacking order
        pub const client_list_stacking = "_NET_CLIENT_LIST_STACKING";
        /// Current workspace index
        pub const current_desktop = "_NET_CURRENT_DESKTOP";
        // Total number of workspaces
        pub const number_of_desktops = "_NET_NUMBER_OF_DESKTOPS";
        /// UTF8_STRINGs
        pub const desktop_names = "_NET_DESKTOP_NAMES";
        /// ClientMessage request to close a window
        pub const close_windoww = "_NET_CLOSE_WINDOW";
    };

    pub fn intern(client: Client, only_if_exists: bool, name: []const u8) !@This() {
        const padded_name_len = (name.len + 3) & ~@as(usize, 3);

        const request: protocol.core.atom.intern.Request = .{
            .header = .{
                .opcode = .intern_atom,
                .detail = @intFromBool(only_if_exists),
                .length = .fromBytes(@sizeOf(protocol.core.atom.intern.Request) + padded_name_len),
            },
            .name_len = @intCast(name.len),
        };

        try client.writer.writeStruct(request, client.endian);
        try client.writer.writeAll(name);
        _ = try client.writer.splatByte(0, (4 - (name.len % 4)) % 4); // Padding

        try client.writer.flush();

        const reply = try client.reader.takeStruct(protocol.core.atom.intern.Reply, client.endian);
        if (reply.header.response_type != .reply) return error.InvalidResponseType;

        return reply.atom;
    }

    /// The returned slice points into the reader buffer and is not guaranteed to be valid after more calls,
    /// recommended to use allocator.dupe or store it into a buffer
    pub fn getName(self: @This(), client: Client) ![]const u8 {
        const request: protocol.core.atom.get_name.Request = .{
            .atom = self,
        };
        try client.writer.writeStruct(request, client.endian);
        try client.writer.flush();

        try client.reader.fillMore();
        const reply = try client.reader.takeStruct(protocol.core.atom.get_name.Reply, client.endian);
        const name = std.mem.trimEnd(u8, try client.reader.take(reply.name_len), &.{0});
        std.debug.print("atom name: {s}\n", .{name});
        return name;
    }
};
