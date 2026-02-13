const std = @import("std");
const protocol = @import("protocol.zig");
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
    pub const wm_protocols = "WM_PROTOCOLS";
    pub const wm_delete_window = "wm_delete_window";

    /// EWMH
    pub const net_wm = struct {
        pub const name = "_NET_WM_NAME";
        pub const state = "_NET_WM_STATE";
        pub const window_type = "_NET_WM_WINDOW_TYPE";
        pub const ive_window = "_NET_ACTIVE_WINDOW";
        pub const desktop = "_NET_WM_DESKTOP";
        pub const icon = "_NET_WM_ICON";
    };

    pub fn intern(client: Client, only_if_exists: bool, name: []const u8) !@This() {
        const padded_name_len = (name.len + 3) & ~@as(usize, 3);

        const request: protocol.atom.intern.Request = .{
            .header = .{
                .opcode = .intern_atom,
                .detail = @intFromBool(only_if_exists),
                .length = @intCast((@sizeOf(protocol.atom.intern.Request) + padded_name_len) / 4),
            },
            .name_len = @intCast(name.len),
        };

        try client.writer.writeStruct(request, client.endian);
        try client.writer.writeAll(name);
        _ = try client.writer.splatByte(0, (4 - (name.len % 4)) % 4); // Padding

        try client.writer.flush();

        const reply = try client.reader.takeStruct(protocol.atom.intern.Reply, client.endian);
        if (reply.header.response_type != .reply) return error.InvalidResponseType;

        return reply.atom;
    }
};
