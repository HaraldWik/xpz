const std = @import("std");
const xpz = @import("xpz");

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const io = init.io;

    var display: xpz.Display = try .connect(allocator, io, null, .{ .detect = init.minimal });
    defer display.disconnect();

    var utf8_string_cookie = try xpz.Atom.intern(&display, false, xpz.Atom.utf8_string);
    var net_wm_name_cookie = try xpz.Atom.intern(&display, false, xpz.Atom.net_wm.name);

    var glx_cookie = try xpz.Extension.query(&display, .GLX);
    var dri3_cookie = try xpz.Extension.query(&display, .DRI3);
    var randr_cookie = try xpz.Extension.query(&display, .RANDR);
    var xfixes_cookie = try xpz.Extension.query(&display, .XFIXES);
    var composite_cookie = try xpz.Extension.query(&display, .Composite);

    const utf8_string = try utf8_string_cookie.getReply();
    const net_wm_name = try net_wm_name_cookie.getReply();

    const glx = try glx_cookie.getReply();
    const dri3 = try dri3_cookie.getReply();
    const randr = try randr_cookie.getReply();
    const xfixes = try xfixes_cookie.getReply();
    const composite = try composite_cookie.getReply();

    std.log.info("{s} = {d}", .{ xpz.Atom.utf8_string, @intFromEnum(utf8_string) });
    std.log.info("{s} = {d}", .{ xpz.Atom.net_wm.name, @intFromEnum(net_wm_name) });

    std.log.info("GLX = {any}", .{glx});
    std.log.info("DRI3 = {any}", .{dri3});
    std.log.info("RANDR = {any}", .{randr});
    std.log.info("XFIXES = {any}", .{xfixes});
    std.log.info("Composite = {any}", .{composite});
}

// const std = @import("std");
// const xpz = @import("xpz");

// const title: []const u8 = "Hello, X 🔥!";

// const colors: []const u32 = &.{
//     0x00c2185b,
//     0x00ff185b,
//     0x00c2bb5b,
//     0x00cc785b,
// };

//     std.log.info("net_wm_name: {d}", .{@intFromEnum(net_wm_name)});
//     std.log.info("utf8_string: {d}", .{@intFromEnum(utf8_string)});

//     const randr = try xpz.Extension.query(&connection, .RANDR) orelse return error.RandrUnsupported;
//     const glx = try xpz.Extension.query(&connection, .GLX) orelse return error.RandrUnsupported;
//     std.debug.print("randr: {any}\n", .{randr});
//     std.debug.print("glx: {any}\n", .{glx});

//     // try xpz.randr.getMonitors(&connection, randr, root_screen, true);

//     const window: xpz.Window = @enumFromInt(connection.resource_id.next());
//     try window.create(&connection, .{
//         .depth = root_screen.root_depth,
//         .parent = root_screen.window,
//         .width = 600,
//         .height = 300,
//         .border_width = 1,
//         .visual_id = root_screen.visual_id,
//         .attributes = .{
//             .background_pixel = 0x00c2185b, // ARGB color
//             // .events = .all,
//             .events = .{
//                 .exposure = true,
//                 .key_press = true,
//                 .key_release = true,
//                 .keymap_state = true,
//                 .focus_change = true,
//                 .button_press = true,
//                 .button_release = true,
//             },
//         },
//     });
//     defer window.destroy(&connection);

//     try window.changeProperty(&connection, .replace, .wm_name, .string, .@"8", title); // This is for setting on older systems, does not support unicode (emojis)
//     try window.changeProperty(&connection, .replace, net_wm_name, utf8_string, .@"8", title); // Modern way, supports unicode

//     try window.map(&connection);
//     try connection.flush();

//     try connection.reader.interface.fillMore();
//     std.log.info("read: {any}", .{connection.reader.interface.buffer});

//     main_loop: while (true) {
//         while (try xpz.Event.next(&connection)) |event| switch (event) {
//             .close => {
//                 std.log.info("close", .{});
//                 break :main_loop;
//             },
//             .expose => |expose| std.log.info("resize: {d}x{d}", .{ expose.width, expose.height }),
//             .key_press, .key_release => |key| {
//                 const keycode = key.header.detail; // This is the hardware key, so its diffrent on diffrent platforms
//                 std.log.info("pressed key: ({c}) {d}", .{ if (std.ascii.isPrint(keycode)) keycode else '?', keycode });
//             },
//             .button_press, .button_release => |button| {
//                 std.log.info("{t}: {t}", .{ event, button.button() });
//                 if (button.button() == .right) {
//                     try window.changeProperty(&connection, .replace, .wm_name, .string, .@"8", "Wow!"); // This is for setting on older systems, does not support unicode (emojis)
//                     try window.changeProperty(&connection, .replace, net_wm_name, utf8_string, .@"8", "Wow!"); // Modern way, supports unicode
//                     try connection.flush();
//                 }
//             },
//             .keymap_notify => |map| {
//                 std.log.info("keymap_notify: {d} {any}", .{ map.detail, map.keys });
//             },
//             else => |event_type| std.log.info("{t}", .{event_type}),
//         };
//     }
// }
