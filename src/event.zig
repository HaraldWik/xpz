const std = @import("std");
const protocol = @import("protocol/protocol.zig");
const Client = @import("Client.zig");
const Atom = @import("atom.zig").Atom;
const Window = @import("window.zig").Window;
const Format = @import("root.zig").Format;

pub const Event = union(Tag) {
    close: void,
    key_press: Key,
    key_release: Key,
    button_press: Button,
    button_release: Button,
    motion_notify: MotionNotify,
    enter_notify: EnterLeaveNotify,
    leave_notify: EnterLeaveNotify,
    focus_in: FocusInOut,
    focus_out: FocusInOut,
    keymap_notify: KeymapNotify,
    expose: Expose,
    graphics_expose: GraphicsExpose,
    no_expose: NoExpose,
    visibility_notify: VisibilityNotify,
    create_notify: CreateNotify,
    destroy_notify: DestroyNotify,
    unmap_notify: UnmapNotify,
    map_notify: MapNotify,
    map_request: MapRequest,
    reparent_notify: ReparentNotify,
    configure_notify: ConfigureNotify,
    configure_request: ConfigureRequest,
    gravity_notify: GravityNotify,
    resize_request: ResizeRequest,
    circulate_notify: CirculateNotify,
    circulate_request: CirculateRequest,
    property_notify: PropertyNotify,
    selection_clear: SelectionClear,
    selection_request: SelectionRequest,
    selection_notify: SelectionNotify,
    colormap_notify: ColormapNotify,
    client_message: ClientMessage,
    mapping_notify: MappingNotify,
    non_standard: NonStandard,

    pub const Tag = enum(u8) {
        close = 1,
        key_press = 2,
        key_release = 3,
        button_press = 4,
        button_release = 5,
        motion_notify = 6,
        enter_notify = 7,
        leave_notify = 8,
        focus_in = 9,
        focus_out = 10,
        keymap_notify = 11,
        expose = 12,
        graphics_expose = 13,
        no_expose = 14,
        visibility_notify = 15,
        create_notify = 16,
        destroy_notify = 17,
        unmap_notify = 18,
        map_notify = 19,
        map_request = 20,
        reparent_notify = 21,
        configure_notify = 22,
        configure_request = 23,
        gravity_notify = 24,
        resize_request = 25,
        circulate_notify = 26,
        circulate_request = 27,
        property_notify = 28,
        selection_clear = 29,
        selection_request = 30,
        selection_notify = 31,
        colormap_notify = 32,
        client_message = 33,
        mapping_notify = 34,
        non_standard,
        // 35–127 are unused/reserved
        _,
    };

    pub const Header = extern struct {
        response_type: protocol.core.ReplyHeader.ResponseType,
        detail: u8,
        sequence: u16,
    };

    pub const ModifierState = packed struct(u16) {
        shift: bool = false, // ShiftMask
        lock: bool = false, // LockMask (Caps)
        control: bool = false, // ControlMask
        mod1: bool = false, // Alt
        mod2: bool = false, // Num Lock (usually)
        mod3: bool = false,
        mod4: bool = false, // Super / Meta
        mod5: bool = false,
        button1: bool = false,
        button2: bool = false,
        button3: bool = false,
        button4: bool = false,
        button5: bool = false,
        pad0: u3 = 0,
    };

    /// The keycode is in the header.detail field
    pub const Key = extern struct {
        header: Header,
        time_ms: u32,
        root: Window,
        event: Window,
        child: Window,
        root_x: i16,
        root_y: i16,
        event_x: i16,
        event_y: i16,
        state: ModifierState,
        pad0: u8, // originaly keycode
        is_same_screen: bool,

        pub fn code(self: @This()) u8 {
            return @enumFromInt(self.header.detail);
        }
    };

    pub const Button = extern struct {
        header: Header,
        window: Window,
        root: Window,
        child: Window,
        time_ms: u32,
        root_x: i16,
        root_y: i16,
        x: i16,
        y: i16,
        state: ModifierState,
        pad0: u8, // originaly button
        is_same_screen: u8,

        pub const Type = enum(u8) {
            left = 1,
            middle = 2,
            right = 3,
            scroll_up = 4,
            scroll_down = 5,
            scroll_left = 6, // (rare)
            scroll_right = 7, // (rare)
            forward = 8, // forward / extra button 1
            backward = 9, // backward / extra button 2
        };

        pub fn button(self: @This()) Type {
            return @enumFromInt(self.header.detail);
        }
    };

    pub const MotionNotify = extern struct {
        header: Header,
        window: Window,
        root: Window,
        child: Window,
        time_ms: u32,
        x: i16,
        y: i16,
        x_root: i16,
        y_root: i16,
        state: ModifierState,
        is_same_screen: bool,
        pad0: u8,
    };

    pub const NotifyMode = enum(u8) {
        normal = 0,
        grab = 1,
        ungrab = 2,
        while_grabbed = 3,
    };

    pub const NotifyDetail = enum(u8) {
        ancestor = 0,
        virtual_ancestor = 1,
        inferiors = 2,
        nonlinear = 3,
        nonlinear_virtual = 4,
        pointer = 5,
        pointer_root = 6,
        none = 7,
    };

    pub const EnterLeaveNotify = extern struct {
        header: Header,
        window: Window,
        root: Window,
        child: Window,
        time_ms: u32,
        x: i16,
        y: i16,
        x_root: i16,
        y_root: i16,
        state: ModifierState,
        mode: NotifyMode,
        detail: NotifyDetail,
        is_same_screen: bool,
        focus: u8,
    };

    pub const FocusInOut = extern struct {
        header: Header,
        detail: NotifyDetail,
        pad0: [3]u8 = undefined,
        window: Window,
        mode: NotifyMode,
        pad1: [3]u8 = undefined,
    };

    pub const KeymapNotify = extern struct {
        response_type: protocol.core.ReplyHeader.ResponseType,
        detail: u8,
        keys: [30]u8,
    };

    pub const Expose = extern struct {
        header: Header,
        window: Window,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        count: u16,
        pad0: u16,
    };

    pub const GraphicsExpose = extern struct {
        header: Header,
        drawable: u32,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        count: u16,
        major_code: u16,
        minor_code: u16,
    };

    pub const NoExpose = extern struct {
        header: Header,
        drawable: u32,
        major_code: u16,
        minor_code: u16,
    };

    pub const VisibilityNotify = extern struct {
        header: Header,
        window: Window,
        state: State,

        pub const State = enum(u8) {
            unobscured = 0,
            partially_obscured = 1,
            fully_obscured = 2,
        };
    };

    pub const CreateNotify = extern struct {
        header: Header,
        parent: Window,
        window: Window,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        border_width: u16,
        override_redirect: bool,
    };

    pub const DestroyNotify = extern struct {
        header: Header,
        event: Window,
        window: Window,
    };

    pub const UnmapNotify = extern struct {
        header: Header,
        event: Window,
        window: Window,
        from_configure: bool,
    };

    pub const MapNotify = extern struct {
        header: Header,
        event: Window,
        window: Window,
        override_redirect: bool,
    };

    pub const MapRequest = extern struct {
        header: Header,
        parent: Window,
        window: Window,
    };

    pub const ReparentNotify = extern struct {
        header: Header,
        event: Window,
        window: Window,
        parent: Window,
        x: i16,
        y: i16,
        override_redirect: bool,
    };

    pub const ConfigureNotify = extern struct {
        header: Header,
        event: Window,
        window: Window,
        above_sibling: Window,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        border_width: u16,
        override_redirect: bool,
    };

    pub const ConfigureRequest = extern struct {
        header: Header,
        parent: Window,
        window: Window,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        border_width: u16,
        above_sibling: Window,
        detail: StackMode,
        value_mask: CWValues,

        pub const StackMode = enum(u8) {
            above = 0,
            below = 1,
            top_if = 2,
            bottom_if = 3,
            opposite = 4,
        };

        pub const CWValues = packed struct(u16) {
            x: bool = false,
            y: bool = false,
            width: bool = false,
            height: bool = false,
            border_width: bool = false,
            sibling: bool = false,
            stack_mode: bool = false,
            pad0: u9,
        };
    };

    pub const GravityNotify = extern struct {
        header: Header,
        event: Window,
        window: Window,
        x: i16,
        y: i16,
    };

    pub const ResizeRequest = extern struct {
        header: Header,
        window: Window,
        width: u16,
        height: u16,
    };

    pub const Place = enum(u8) {
        on_top = 0,
        on_bottom = 1,
    };

    pub const CirculateNotify = extern struct {
        header: Header,
        event: Window,
        window: Window,
        place: Place,
    };

    pub const CirculateRequest = extern struct {
        header: Header,
        parent: Window,
        window: Window,
        place: Place,
    };

    pub const PropertyNotify = extern struct {
        header: Header,
        window: Window,
        atom: Atom,
        time_ms: u32,
        state: State,

        pub const State = enum(u8) {
            new_value = 0,
            deleted = 1,
        };
    };

    pub const SelectionClear = extern struct {
        header: Header,
        time_ms: u32,
        owner: Window,
        selection: Atom,
    };

    pub const SelectionRequest = extern struct {
        header: Header,
        owner: Window,
        requestor: Window,
        selection: Atom,
        target: Atom,
        property: Atom,
        time_ms: u32,
    };

    pub const SelectionNotify = extern struct {
        header: Header,
        requestor: Window,
        selection: Atom,
        target: Atom,
        property: Atom,
        time_ms: u32,
    };

    pub const ColormapNotify = extern struct {
        header: Header,
        window: Window,
        colormap: u32,
        new: New,
        state: State,

        pub const State = enum(u8) {
            uninstalled = 0,
            installed = 1,
        };

        pub const New = enum(u8) {
            no = 0,
            yes = 1,
        };
    };

    pub const ClientMessage = extern struct {
        response_type: Tag,
        format: Format = .@"32", // usually 32
        sequence: u16 = 0, // ignored for SendEvent
        window: Window,
        type: Atom,
        data: [20]u8, // raw client data
    };

    pub const MappingNotify = extern struct {
        header: Header,
        request: u8, // Mapping modifier
        first_keycode: u8,
        count: u8,
    };

    pub const NonStandard = extern struct {
        header: Header,
        data: [28]u8, // arbitrary non-standard event payload
    };

    pub const Mask = packed struct(u32) {
        key_press: bool = false,
        key_release: bool = false,
        button_press: bool = false,
        button_release: bool = false,
        enter_window: bool = false,
        leave_window: bool = false,
        pointer_motion: bool = false,
        pointer_motion_hint: bool = false,
        button_1_motion: bool = false,
        button_2_motion: bool = false,
        button_3_motion: bool = false,
        button_4_motion: bool = false,
        button_5_motion: bool = false,
        button_motion: bool = false,
        keymap_state: bool = false,
        exposure: bool = false,
        visibility_change: bool = false,
        structure_notify: bool = false,
        resize_redirect: bool = false,
        substructure_notify: bool = false,
        substructure_redirect: bool = false,
        focus_change: bool = false,
        property_change: bool = false,
        colormap_change: bool = false,
        owner_grab_button: bool = false,
        pad0: u7 = 0,

        pub const all: @This() = .{
            .key_press = true,
            .key_release = true,
            .button_press = true,
            .button_release = true,
            .enter_window = true,
            .leave_window = true,
            .pointer_motion = true,
            .pointer_motion_hint = true,
            .button_1_motion = true,
            .button_2_motion = true,
            .button_3_motion = true,
            .button_4_motion = true,
            .button_5_motion = true,
            .button_motion = true,
            .keymap_state = true,
            .exposure = true,
            .visibility_change = true,
            .structure_notify = true,
            .resize_redirect = true,
            .substructure_notify = true,
            .substructure_redirect = true,
            .focus_change = true,
            .property_change = true,
            .colormap_change = true,
            .owner_grab_button = true,
        };
    };

    pub fn next(client: Client) !?@This() {
        const stream_reader: *std.Io.net.Stream.Reader = @fieldParentPtr("interface", client.reader);
        var poll_fds = [_]std.posix.pollfd{.{
            .fd = stream_reader.stream.socket.handle,
            .events = std.posix.POLL.IN,
            .revents = 0,
        }};
        const poll_fd = poll_fds[0];

        const n = try std.posix.poll(&poll_fds, 1);
        if (n == 0) return null;

        if ((poll_fd.revents & std.posix.POLL.IN) == 0)
            if ((poll_fd.revents & std.posix.POLL.ERR) != 0) return .close;

        if ((poll_fd.revents & std.posix.POLL.HUP) != 0) return .close;

        client.reader.tossBuffered();
        _ = client.reader.fill(32) catch |err| return switch (err) {
            error.EndOfStream => .close,
            else => err,
        };
        const response_type = try checkError(client);
        if (response_type == .reply) return null;

        return switch (@as(Tag, @enumFromInt(@intFromEnum(response_type)))) {
            .key_press => .{ .key_press = try client.reader.takeStruct(Key, client.endian) },
            .key_release => .{ .key_release = try client.reader.takeStruct(Key, client.endian) },
            .button_press => .{ .button_press = try client.reader.takeStruct(Button, client.endian) },
            .button_release => .{ .button_release = try client.reader.takeStruct(Button, client.endian) },
            .motion_notify => .{ .motion_notify = try client.reader.takeStruct(MotionNotify, client.endian) },
            .enter_notify => .{ .enter_notify = try client.reader.takeStruct(EnterLeaveNotify, client.endian) },
            .leave_notify => .{ .leave_notify = try client.reader.takeStruct(EnterLeaveNotify, client.endian) },
            .focus_in => .{ .focus_in = try client.reader.takeStruct(FocusInOut, client.endian) },
            .focus_out => .{ .focus_out = try client.reader.takeStruct(FocusInOut, client.endian) },
            .keymap_notify => .{ .keymap_notify = try client.reader.takeStruct(KeymapNotify, client.endian) },
            .expose => .{ .expose = try client.reader.takeStruct(Expose, client.endian) },
            .graphics_expose => .{ .graphics_expose = try client.reader.takeStruct(GraphicsExpose, client.endian) },
            .no_expose => .{ .no_expose = try client.reader.takeStruct(NoExpose, client.endian) },
            .visibility_notify => .{ .visibility_notify = try client.reader.takeStruct(VisibilityNotify, client.endian) },
            .create_notify => .{ .create_notify = try client.reader.takeStruct(CreateNotify, client.endian) },
            .destroy_notify => .{ .destroy_notify = try client.reader.takeStruct(DestroyNotify, client.endian) },
            .unmap_notify => .{ .unmap_notify = try client.reader.takeStruct(UnmapNotify, client.endian) },
            .map_notify => .{ .map_notify = try client.reader.takeStruct(MapNotify, client.endian) },
            .map_request => .{ .map_request = try client.reader.takeStruct(MapRequest, client.endian) },
            .reparent_notify => .{ .reparent_notify = try client.reader.takeStruct(ReparentNotify, client.endian) },
            .configure_notify => .{ .configure_notify = try client.reader.takeStruct(ConfigureNotify, client.endian) },
            .configure_request => .{ .configure_request = try client.reader.takeStruct(ConfigureRequest, client.endian) },
            .gravity_notify => .{ .gravity_notify = try client.reader.takeStruct(GravityNotify, client.endian) },
            .resize_request => .{ .resize_request = try client.reader.takeStruct(ResizeRequest, client.endian) },
            .circulate_notify => .{ .circulate_notify = try client.reader.takeStruct(CirculateNotify, client.endian) },
            .circulate_request => .{ .circulate_request = try client.reader.takeStruct(CirculateRequest, client.endian) },
            .property_notify => .{ .property_notify = try client.reader.takeStruct(PropertyNotify, client.endian) },
            .selection_clear => .{ .selection_clear = try client.reader.takeStruct(SelectionClear, client.endian) },
            .selection_request => .{ .selection_request = try client.reader.takeStruct(SelectionRequest, client.endian) },
            .selection_notify => .{ .selection_notify = try client.reader.takeStruct(SelectionNotify, client.endian) },
            .colormap_notify => .{ .colormap_notify = try client.reader.takeStruct(ColormapNotify, client.endian) },
            .client_message => .{ .client_message = try client.reader.takeStruct(ClientMessage, client.endian) },
            .mapping_notify => .{ .mapping_notify = try client.reader.takeStruct(MappingNotify, client.endian) },

            _, .non_standard => .{ .non_standard = try client.reader.takeStruct(NonStandard, client.endian) },
            .close => .close,
        };
    }

    pub fn send(client: Client, window: Window, propogate: bool, event: @This()) !void {
        const request: protocol.core.event.Send = .{
            .header = .{
                .opcode = .send_event,
                .detail = @intFromBool(propogate),
                .length = 11,
            },
            .destination = window,
            .event_mask = .all,
        };
        const atom: Atom = try .intern(Client, false, Atom.wm.protocols);
        try client.writer.writeStruct(request, client.endian);
        switch (event) {
            inline else => |inner| {
                const payload: ClientMessage = ClientMessage{
                    .response_type = std.meta.activeTag(event),
                    .format = .@"32",
                    .window = window,
                    .type = atom,
                    .data = std.mem.toBytes(inner),
                };

                try client.writer.writeStruct(payload, client.endian);
            },
        }
        try client.writer.flush();
    }
};

fn checkError(client: Client) !protocol.core.ReplyHeader.ResponseType {
    const response_type: protocol.core.ReplyHeader.ResponseType = @enumFromInt(try client.reader.peekInt(u8, client.endian));

    if (response_type == .err) return switch (try client.reader.peekInt(u8, client.endian)) {
        0 => return response_type,
        1 => error.Request,
        2 => error.Value,
        3 => error.Window,
        4 => error.Pixmap,
        5 => error.Atom,
        6 => error.Cursor,
        7 => error.Font,
        8 => error.Match,
        9 => error.Drawable,
        10 => error.Access,
        11 => error.Alloc,
        12 => error.Colormap,
        13 => error.GC,
        14 => error.IDChoice,
        15 => error.Name,
        16 => error.Length,
        17 => error.Implementation,
        else => |code| {
            std.log.err("unknown error code: {d}", .{code});
            return error.Unknown;
        },
    };
    return response_type;
}
