const std = @import("std");
const protocol = @import("protocol/protocol.zig");
const Client = @import("Client.zig");
const Extension = @import("root.zig").Extension;
const Screen = @import("root.zig").Screen;
const Visual = @import("root.zig").Visual;
const Drawable = @import("root.zig").Drawable;

pub const supported_client_version: protocol.common.Version = .{ .major = 1, .minor = 4 };

pub const Attribute = enum(i32) {
    use_gl = 1,
    buffer_size = 2,
    level = 3,
    rgba = 4,
    double_buffer = 5,
    stereo = 6,
    aux_buffers = 7,
    red_size = 8,
    green_size = 9,
    blue_size = 10,
    alpha_size = 11,
    depth_size = 12,
    stencil_size = 13,
    accum_red_size = 14,
    accum_green_size = 15,
    accum_blue_size = 16,
    accum_alpha_size = 17,
    none = 0,
    _,
};

pub const FramebufferConfig = extern struct {
    visual_id: Visual.Id,
    screen_index: u32,
    depth: u32,
    class: Visual.Class(u32),
    red_mask: u32,
    green_mask: u32,
    blue_mask: u32,
    alpha_size: u32,
    depth_size: u32,
    stencil_size: u32,
    accum_red_size: u32,
    accum_green_size: u32,
    accum_blue_size: u32,
    accum_alpha_size: u32,
    doublebuffer: u32, // bool, 1 = true, 0 = false
    stereo: u32, // bool, 1 = true, 0 = false
    aux_buffers: u32,
};

pub const Context = enum(u32) {
    _,

    pub const Tag = enum(u32) {
        _,
    };

    pub fn create(self: @This(), client: Client, info: Extension.Info, visual_id: Visual.Id, screen: Screen) !void {
        _ = screen;
        const request: protocol.glx.CreateContext = .{
            .header = .{
                .major_opcode = info.major_opcode,
                .minor_opcode = .create_context,
                .length = .fromBytes(@sizeOf(protocol.glx.CreateContext)),
            },
            .context = self,
            .visual_id = visual_id,
            .screen_index = 0,
            .render_type = .rgba,
            .is_direct = true,
        };
        try client.writer.writeStruct(request, client.endian);
        try client.writer.flush();
    }

    pub fn makeCurrent(self: @This(), client: Client, info: Extension.Info, drawable: Drawable, screen: Screen) !Tag {
        _ = screen;
        const request: protocol.glx.make_current.Request = .{
            .header = .{
                .major_opcode = info.major_opcode,
                .minor_opcode = .make_current,
                .length = .fromBytes(@sizeOf(protocol.glx.make_current.Request)),
            },
            .context = self,
            .drawable = drawable,
            .screen_index = 0,
        };
        try client.writer.writeStruct(request, client.endian);
        try client.writer.flush();
        const reply = try client.reader.takeStruct(protocol.glx.make_current.Reply, client.endian);
        if (reply.header.response_type != .reply) return error.MakeCurrent;
        return reply.context_tag;
    }
};

/// Returns the glx version that the server supports
pub fn queryVersion(client: Client, info: Extension.Info) !protocol.common.Version {
    const request: protocol.glx.query_version.Request = .{
        .header = .{
            .major_opcode = info.major_opcode,
            .minor_opcode = .get_version,
            .length = .fromBytes(@sizeOf(protocol.glx.query_version.Request)),
        },
        .version = supported_client_version, // THe version of glx that the client supports
    };
    try client.writer.writeStruct(request, client.endian);
    try client.writer.flush();

    const reply = try client.reader.takeStruct(protocol.glx.query_version.Reply, client.endian);
    return reply.version;
}

pub fn chooseVisual(client: Client, info: Extension.Info, screen: Screen, attributes: []const Attribute) !Visual.Info {
    const request: protocol.glx.get_visual_configs.Request = .{
        .header = .{
            .major_opcode = info.major_opcode,
            .minor_opcode = .get_visual_configs,
            .length = .fromBytes(@sizeOf(protocol.glx.get_visual_configs.Request) + 3),
        },
        .screen_index = 0,
    };

    _ = screen;
    try client.writer.writeStruct(request, client.endian);
    try client.writer.flush();
    _ = attributes;

    try client.reader.fillMore();

    const response_type: protocol.core.ReplyHeader.ResponseType = @enumFromInt(try client.reader.peekInt(u8, client.endian));
    if (response_type == .err) {
        const err = try client.reader.takeStruct(protocol.common.Error, client.endian);

        std.log.err("err: code: {d}, opcode.major: {any}, opcode.minor: {t}", .{ err.code - info.first_error, err.major_opcode, @as(protocol.glx.RequestHeader.Opcode, @enumFromInt(@as(u8, @intCast(err.minor_opcode)))) });
        return error.GlxChooseVisual;
    }

    const reply = try client.reader.takeStruct(protocol.glx.get_visual_configs.Reply, client.endian);
    if (reply.header.response_type != .reply) {
        std.log.err("response_type: {d}", .{@intFromEnum(reply.header.response_type)});
        return error.InvalidResponseType;
    }

    var selected: FramebufferConfig = undefined;
    for (0..reply.visuals_count) |i| {
        const framebuffer_config = try client.reader.takeStruct(FramebufferConfig, client.endian);
        if (i == 0) selected = framebuffer_config;
        std.log.info("{d}/{d} framebuffer_config: id: {d}, class: {t}", .{ i + 1, reply.visuals_count, @intFromEnum(framebuffer_config.visual_id), framebuffer_config.class });
    }
    return .{
        .visual = null,
        .visual_id = selected.visual_id,
        .screen_index = selected.screen_index,
        .depth = selected.depth,
        .class = selected.class,
        .red_mask = selected.red_mask,
        .green_mask = selected.green_mask,
        .blue_mask = selected.blue_mask,
        .colormap_size = 256,
        .bits_per_rgb = 8,
    };
}

pub fn swapBuffers(client: Client, info: Extension.Info, drawable: Drawable, context_tag: Context.Tag) !void {
    const request: protocol.glx.SwapBuffers = .{
        .header = .{
            .major_opcode = info.major_opcode,
            .minor_opcode = .make_current,
            .length = .fromBytes(@sizeOf(protocol.glx.SwapBuffers)),
        },
        .drawable = drawable,
        .context_tag = context_tag,
    };
    try client.writer.writeStruct(request, client.endian);
    try client.writer.flush();
}
