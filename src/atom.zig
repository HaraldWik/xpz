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

    pub fn intern(client: Client, only_if_exists: bool, name: []const u8) !@This() {
        const request: protocol.atom.Intern = .{
            .header = .{
                .opcode = .intern_atom,
                .detail = @intFromBool(only_if_exists),
                .length = @intCast((@sizeOf(protocol.atom.Intern) - 8 + ((name.len + 3) & ~@as(usize, 3))) / 4),
            },
            .name_len = @intCast(name.len),
        };
        try client.writer.writeStruct(request, client.endian);
        try client.writer.flush();

        client.reader.tossBuffered();
        try client.reader.fillMore();
        const reply = try client.reader.takeStruct(protocol.atom.Intern.Reply, client.endian);
        std.debug.print("intern atom reply: {any}\n", .{reply});
        // if (reply.header.response_type != .reply) return error.InvalidResponseType;

        std.debug.print("endian : {t}\n", .{client.endian});

        return @as(Atom, reply.atom);
    }
};
