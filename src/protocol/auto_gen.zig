const std = @import("std");
pub const Atom = @import("../atom.zig").Atom;
pub const Window = @import("../window.zig").Window;
pub const Drawable = @import("../root.zig").Drawable;
pub const Pixmap = enum(u32) {
    none = 0,
};
pub const KEYSYM = u32;
pub const Visual = @import("../root.zig").Visual;
pub const GraphicsContext = u32;
pub const COUNTER = u32;
pub const ClientSpec = u32;
pub const Pcontext = u32;
pub const KEYCODE = u32;

pub const Point = struct {
    x: i16,
    y: i16,
};

pub const xtest = struct {
    // unknown start xcb
    // unknown start import
    // unknown end import
    pub const GetVersion = struct { // opcode 0
        major_version: u8,
        minor_version: u16,
        pub const Reply = struct {
            major_version: u8,
            minor_version: u16,
        };
    };
    pub const Cursor = enum(u32) {
        none = 0,
        current = 1,
    };
    pub const CompareCursor = struct { // opcode 1
        window: Window,
        cursor: Cursor,
        pub const Reply = struct {
            same: bool,
        };
    };
    pub const FakeInput = struct { // opcode 2
        type: u8,
        detail: u8,
        time: u32,
        root: Window,
        rootX: i16,
        rootY: i16,
        deviceid: u8,
    };
    pub const GrabControl = struct { // opcode 3
        impervious: bool,
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        get_version = 0,
        compare_cursor = 1,
        fake_input = 2,
        grab_control = 3,
    };
};
pub const sync = struct {
    // unknown start xcb
    // unknown start import

    pub const Alarm = u32;
    pub const FENCE = u32;

    pub const ALARMSTATE = enum(u32) {
        active = 0,
        inactive = 1,
        destroyed = 2,
    };
    pub const TESTTYPE = enum(u32) {
        positive_transition = 0,
        negative_transition = 1,
        positive_comparison = 2,
        negative_comparison = 3,
    };
    pub const VALUETYPE = enum(u32) {
        absolute = 0,
        relative = 1,
    };
    pub const CA = packed struct(u32) {
        counter: bool = false,
        value_type: bool = false,
        value: bool = false,
        test_type: bool = false,
        delta: bool = false,
        events: bool = false,
        pad0: u26 = 0,
    };
    pub const SYSTEMCOUNTER = struct {
        counter: COUNTER,
        resolution: i64,
        name_len: u16,
        name: []const u8,
    };
    pub const TRIGGER = struct {
        counter: COUNTER,
        wait_type: u32,
        wait_value: i64,
        test_type: u32,
    };
    pub const WAITCONDITION = struct {
        trigger: TRIGGER,
        event_threshold: i64,
    };
    pub const Counter = struct {
        bad_counter: u32,
        minor_opcode: u16,
        major_opcode: u8,
    };
    pub const AlarmInfo = struct {
        bad_alarm: u32,
        minor_opcode: u16,
        major_opcode: u8,
    };
    pub const Fence = struct {
        bad_fence: u32,
        minor_opcode: u16,
        major_opcode: u8,
    };
    pub const Initialize = struct { // opcode 0
        desired_major_version: u8,
        desired_minor_version: u8,
        pub const Reply = struct {
            major_version: u8,
            minor_version: u8,
        };
    };
    pub const ListSystemCounters = struct { // opcode 1
        pub const Reply = struct {
            counters_len: u32,
            counters: []const SYSTEMCOUNTER,
        };
    };
    pub const CreateCounter = struct { // opcode 2
        id: COUNTER,
        initial_value: i64,
    };
    pub const DestroyCounter = struct { // opcode 6
        counter: COUNTER,
    };
    pub const QueryCounter = struct { // opcode 5
        counter: COUNTER,
        pub const Reply = struct {
            counter_value: i64,
        };
    };
    pub const Await = struct { // opcode 7
        wait_list: []const WAITCONDITION,
    };
    pub const ChangeCounter = struct { // opcode 4
        counter: COUNTER,
        amount: i64,
    };
    pub const SetCounter = struct { // opcode 3
        counter: COUNTER,
        value: i64,
    };
    pub const CreateAlarm = struct { // opcode 8
        id: Alarm,
        value_mask: u32,
        // unknown start switch
        // unknown start bitcase
        // unknown start enumref
        // unknown end enumref
        counter: COUNTER,
        // unknown end bitcase
        // unknown start bitcase
        // unknown start enumref
        // unknown end enumref
        valueType: u32,
        // unknown end bitcase
        // unknown start bitcase
        // unknown start enumref
        // unknown end enumref
        value: i64,
        // unknown end bitcase
        // unknown start bitcase
        // unknown start enumref
        // unknown end enumref
        testType: u32,
        // unknown end bitcase
        // unknown start bitcase
        // unknown start enumref
        // unknown end enumref
        delta: i64,
        // unknown end bitcase
        // unknown start bitcase
        // unknown start enumref
        // unknown end enumref
        events: u32,
        // unknown end bitcase
        // unknown end switch
    };
    pub const ChangeAlarm = struct { // opcode 9
        id: Alarm,
        value_mask: u32,
        // unknown start switch
        // unknown start bitcase
        // unknown start enumref
        // unknown end enumref
        counter: COUNTER,
        // unknown end bitcase
        // unknown start bitcase
        // unknown start enumref
        // unknown end enumref
        valueType: u32,
        // unknown end bitcase
        // unknown start bitcase
        // unknown start enumref
        // unknown end enumref
        value: i64,
        // unknown end bitcase
        // unknown start bitcase
        // unknown start enumref
        // unknown end enumref
        testType: u32,
        // unknown end bitcase
        // unknown start bitcase
        // unknown start enumref
        // unknown end enumref
        delta: i64,
        // unknown end bitcase
        // unknown start bitcase
        // unknown start enumref
        // unknown end enumref
        events: u32,
        // unknown end bitcase
        // unknown end switch
    };
    pub const DestroyAlarm = struct { // opcode 11
        alarm: Alarm,
    };
    pub const QueryAlarm = struct { // opcode 10
        alarm: Alarm,
        pub const Reply = struct {
            trigger: TRIGGER,
            delta: i64,
            events: bool,
            state: u8,
        };
    };
    pub const SetPriority = struct { // opcode 12
        id: u32,
        priority: i32,
    };
    pub const GetPriority = struct { // opcode 13
        id: u32,
        pub const Reply = struct {
            priority: i32,
        };
    };
    pub const CreateFence = struct { // opcode 14
        drawable: Drawable,
        fence: FENCE,
        initially_triggered: bool,
    };
    pub const TriggerFence = struct { // opcode 15
        fence: FENCE,
    };
    pub const ResetFence = struct { // opcode 16
        fence: FENCE,
    };
    pub const DestroyFence = struct { // opcode 17
        fence: FENCE,
    };
    pub const QueryFence = struct { // opcode 18
        fence: FENCE,
        pub const Reply = struct {
            triggered: bool,
        };
    };
    pub const AwaitFence = struct { // opcode 19
        fence_list: []const FENCE,
    };
    pub const CounterNotify = struct {
        kind: u8,
        counter: COUNTER,
        wait_value: i64,
        counter_value: i64,
        u32_ms: u32,
        count: u16,
        destroyed: bool,
    };
    pub const AlarmNotify = struct {
        kind: u8,
        alarm: Alarm,
        counter_value: i64,
        alarm_value: i64,
        u32_ms: u32,
        state: u8,
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        initialize = 0,
        list_system_counters = 1,
        create_counter = 2,
        destroy_counter = 6,
        query_counter = 5,
        await = 7,
        change_counter = 4,
        set_counter = 3,
        create_alarm = 8,
        change_alarm = 9,
        destroy_alarm = 11,
        query_alarm = 10,
        set_priority = 12,
        get_priority = 13,
        create_fence = 14,
        trigger_fence = 15,
        reset_fence = 16,
        destroy_fence = 17,
        query_fence = 18,
        await_fence = 19,
    };
};
pub const bigreq = struct {
    // unknown start xcb
    pub const Enable = struct { // opcode 0
        pub const Reply = struct {
            maximum_request_length: u32,
        };
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        enable = 0,
    };
};
pub const dri2 = struct {
    // unknown start xcb
    // unknown start import
    // unknown end import
    pub const Attachment = enum(u32) {
        buffer_front_left = 0,
        buffer_back_left = 1,
        buffer_front_right = 2,
        buffer_back_right = 3,
        buffer_depth = 4,
        buffer_stencil = 5,
        buffer_accum = 6,
        buffer_fake_front_left = 7,
        buffer_fake_front_right = 8,
        buffer_depth_stencil = 9,
        buffer_hiz = 10,
    };
    pub const DriverType = enum(u32) {
        d_r_i = 0,
        v_d_p_a_u = 1,
    };
    pub const EventType = enum(u32) {
        exchange_complete = 1,
        blit_complete = 2,
        flip_complete = 3,
    };
    pub const DRI2Buffer = struct {
        attachment: u32,
        name: u32,
        pitch: u32,
        cpp: u32,
        flags: u32,
    };
    pub const AttachFormat = struct {
        attachment: u32,
        format: u32,
    };
    pub const QueryVersion = struct { // opcode 0
        major_version: u32,
        minor_version: u32,
        pub const Reply = struct {
            major_version: u32,
            minor_version: u32,
        };
    };
    pub const Connect = struct { // opcode 1
        window: Window,
        driver_type: u32,
        pub const Reply = struct {
            driver_name_length: u32,
            device_name_length: u32,
            driver_name: []const u8,
            alignment_pad: []const void,
            device_name: []const u8,
        };
    };
    pub const Authenticate = struct { // opcode 2
        window: Window,
        magic: u32,
        pub const Reply = struct {
            authenticated: u32,
        };
    };
    pub const CreateDrawable = struct { // opcode 3
        drawable: Drawable,
    };
    pub const DestroyDrawable = struct { // opcode 4
        drawable: Drawable,
    };
    pub const GetBuffers = struct { // opcode 5
        drawable: Drawable,
        count: u32,
        attachments: []const u32,
        pub const Reply = struct {
            width: u32,
            height: u32,
            count: u32,
            buffers: []const DRI2Buffer,
        };
    };
    pub const CopyRegion = struct { // opcode 6
        drawable: Drawable,
        region: u32,
        dest: u32,
        src: u32,
        pub const Reply = struct {};
    };
    pub const GetBuffersWithFormat = struct { // opcode 7
        drawable: Drawable,
        count: u32,
        attachments: []const AttachFormat,
        pub const Reply = struct {
            width: u32,
            height: u32,
            count: u32,
            buffers: []const DRI2Buffer,
        };
    };
    pub const SwapBuffers = struct { // opcode 8
        drawable: Drawable,
        target_msc_hi: u32,
        target_msc_lo: u32,
        divisor_hi: u32,
        divisor_lo: u32,
        remainder_hi: u32,
        remainder_lo: u32,
        pub const Reply = struct {
            swap_hi: u32,
            swap_lo: u32,
        };
    };
    pub const GetMSC = struct { // opcode 9
        drawable: Drawable,
        pub const Reply = struct {
            ust_hi: u32,
            ust_lo: u32,
            msc_hi: u32,
            msc_lo: u32,
            sbc_hi: u32,
            sbc_lo: u32,
        };
    };
    pub const WaitMSC = struct { // opcode 10
        drawable: Drawable,
        target_msc_hi: u32,
        target_msc_lo: u32,
        divisor_hi: u32,
        divisor_lo: u32,
        remainder_hi: u32,
        remainder_lo: u32,
        pub const Reply = struct {
            ust_hi: u32,
            ust_lo: u32,
            msc_hi: u32,
            msc_lo: u32,
            sbc_hi: u32,
            sbc_lo: u32,
        };
    };
    pub const WaitSBC = struct { // opcode 11
        drawable: Drawable,
        target_sbc_hi: u32,
        target_sbc_lo: u32,
        pub const Reply = struct {
            ust_hi: u32,
            ust_lo: u32,
            msc_hi: u32,
            msc_lo: u32,
            sbc_hi: u32,
            sbc_lo: u32,
        };
    };
    pub const SwapInterval = struct { // opcode 12
        drawable: Drawable,
        interval: u32,
    };
    pub const GetParam = struct { // opcode 13
        drawable: Drawable,
        param: u32,
        pub const Reply = struct {
            is_param_recognized: bool,
            value_hi: u32,
            value_lo: u32,
        };
    };
    pub const BufferSwapComplete = struct {
        event_type: u16,
        drawable: Drawable,
        ust_hi: u32,
        ust_lo: u32,
        msc_hi: u32,
        msc_lo: u32,
        sbc: u32,
    };
    pub const InvalidateBuffers = struct {
        drawable: Drawable,
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        connect = 1,
        authenticate = 2,
        create_drawable = 3,
        destroy_drawable = 4,
        get_buffers = 5,
        copy_region = 6,
        get_buffers_with_format = 7,
        swap_buffers = 8,
        get_m_s_c = 9,
        wait_m_s_c = 10,
        wait_s_b_c = 11,
        swap_interval = 12,
        get_param = 13,
    };
};
pub const record = struct {
    pub const ElementHeader = packed struct {
        length: u16,
        type: u16,
    };

    pub const Range8 = struct {
        first: u8,
        last: u8,
    };
    pub const Range16 = struct {
        first: u16,
        last: u16,
    };
    pub const ExtRange = struct {
        major: Range8,
        minor: Range16,
    };
    pub const Range = struct {
        core_requests: Range8,
        core_replies: Range8,
        ext_requests: ExtRange,
        ext_replies: ExtRange,
        delivered_events: Range8,
        device_events: Range8,
        errors: Range8,
        client_started: bool,
        client_died: bool,
    };
    // unknown start typedef
    // unknown end typedef
    pub const HType = packed struct(u32) {
        from_server_time: bool = false,
        from_client_time: bool = false,
        from_client_sequence: bool = false,
        pad0: u29 = 0,
    };
    // unknown start typedef
    // unknown end typedef
    pub const CS = enum(u32) {
        current_clients = 1,
        future_clients = 2,
        all_clients = 3,
    };
    pub const ClientInfo = struct {
        client_resource: ClientSpec,
        num_ranges: u32,
        ranges: []const Range,
    };
    pub const BadContext = struct {
        invalid_record: u32,
    };
    pub const QueryVersion = struct { // opcode 0
        major_version: u16,
        minor_version: u16,
        pub const Reply = struct {
            major_version: u16,
            minor_version: u16,
        };
    };
    pub const CreateContext = struct { // opcode 1
        context: record.Context,
        element_header: ElementHeader,
        num_client_specs: u32,
        num_ranges: u32,
        client_specs: []const ClientSpec,
        ranges: []const Range,
    };
    pub const RegisterClients = struct { // opcode 2
        context: record.Context,
        element_header: ElementHeader,
        num_client_specs: u32,
        num_ranges: u32,
        client_specs: []const ClientSpec,
        ranges: []const Range,
    };
    pub const UnregisterClients = struct { // opcode 3
        context: record.Context,
        num_client_specs: u32,
        client_specs: []const ClientSpec,
    };
    pub const GetContext = struct { // opcode 4
        context: record.Context,
        pub const Reply = struct {
            enabled: bool,
            element_header: ElementHeader,
            num_intercepted_clients: u32,
            intercepted_clients: []const ClientInfo,
        };
    };
    pub const EnableContext = struct { // opcode 5
        context: record.Context,
        pub const Reply = struct {
            category: u8,
            element_header: ElementHeader,
            client_swapped: bool,
            xid_base: u32,
            server_time: u32,
            rec_sequence_num: u32,
            data: []const u8,
        };
    };
    pub const DisableContext = struct { // opcode 6
        context: record.Context,
    };
    pub const FreeContext = struct { // opcode 7
        context: record.Context,
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        create_context = 1,
        register_clients = 2,
        unregister_clients = 3,
        get_context = 4,
        enable_context = 5,
        disable_context = 6,
        free_context = 7,
    };
};
pub const xf86vidmode = struct {
    pub const DOTCLOCK = u32;
    pub const SYNCRANGE = u32;

    // unknown start xcb
    // unknown start typedef
    // unknown end typedef
    // unknown start typedef
    // unknown end typedef
    pub const ModeFlag = packed struct(u32) {
        positive_h_sync: bool = false,
        negative_h_sync: bool = false,
        positive_v_sync: bool = false,
        negative_v_sync: bool = false,
        interlace: bool = false,
        composite_sync: bool = false,
        positive_c_sync: bool = false,
        negative_c_sync: bool = false,
        h_skew: bool = false,
        broadcast: bool = false,
        pixmux: bool = false,
        double_clock: bool = false,
        half_clock: bool = false,
        pad0: u19 = 0,
    };
    pub const ClockFlag = packed struct(u32) {
        programable: bool = false,
        pad0: u31 = 0,
    };
    pub const Permission = packed struct(u32) {
        read: bool = false,
        write: bool = false,
        pad0: u30 = 0,
    };
    pub const ModeInfo = struct {
        dotclock: DOTCLOCK,
        hdisplay: u16,
        hsyncstart: u16,
        hsyncend: u16,
        htotal: u16,
        hskew: u32,
        vdisplay: u16,
        vsyncstart: u16,
        vsyncend: u16,
        vtotal: u16,
        flags: u32,
        privsize: u32,
    };
    pub const QueryVersion = struct { // opcode 0
        pub const Reply = struct {
            major_version: u16,
            minor_version: u16,
        };
    };
    pub const GetModeLine = struct { // opcode 1
        screen: u16,
        pub const Reply = struct {
            dotclock: DOTCLOCK,
            hdisplay: u16,
            hsyncstart: u16,
            hsyncend: u16,
            htotal: u16,
            hskew: u16,
            vdisplay: u16,
            vsyncstart: u16,
            vsyncend: u16,
            vtotal: u16,
            flags: u32,
            privsize: u32,
            private: []const u8,
        };
    };
    pub const ModModeLine = struct { // opcode 2
        screen: u32,
        hdisplay: u16,
        hsyncstart: u16,
        hsyncend: u16,
        htotal: u16,
        hskew: u16,
        vdisplay: u16,
        vsyncstart: u16,
        vsyncend: u16,
        vtotal: u16,
        flags: u32,
        privsize: u32,
        private: []const u8,
    };
    pub const SwitchMode = struct { // opcode 3
        screen: u16,
        zoom: u16,
    };
    pub const GetMonitor = struct { // opcode 4
        screen: u16,
        pub const Reply = struct {
            vendor_length: u8,
            model_length: u8,
            num_hsync: u8,
            num_vsync: u8,
            hsync: []const SYNCRANGE,
            vsync: []const SYNCRANGE,
            vendor: []const u8,
            alignment_pad: []const void,
            model: []const u8,
        };
    };
    pub const LockModeSwitch = struct { // opcode 5
        screen: u16,
        lock: u16,
    };
    pub const GetAllModeLines = struct { // opcode 6
        screen: u16,
        pub const Reply = struct {
            modecount: u32,
            modeinfo: []const ModeInfo,
        };
    };
    pub const AddModeLine = struct { // opcode 7
        screen: u32,
        dotclock: DOTCLOCK,
        hdisplay: u16,
        hsyncstart: u16,
        hsyncend: u16,
        htotal: u16,
        hskew: u16,
        vdisplay: u16,
        vsyncstart: u16,
        vsyncend: u16,
        vtotal: u16,
        flags: u32,
        privsize: u32,
        after_dotclock: DOTCLOCK,
        after_hdisplay: u16,
        after_hsyncstart: u16,
        after_hsyncend: u16,
        after_htotal: u16,
        after_hskew: u16,
        after_vdisplay: u16,
        after_vsyncstart: u16,
        after_vsyncend: u16,
        after_vtotal: u16,
        after_flags: u32,
        private: []const u8,
    };
    pub const DeleteModeLine = struct { // opcode 8
        screen: u32,
        dotclock: DOTCLOCK,
        hdisplay: u16,
        hsyncstart: u16,
        hsyncend: u16,
        htotal: u16,
        hskew: u16,
        vdisplay: u16,
        vsyncstart: u16,
        vsyncend: u16,
        vtotal: u16,
        flags: u32,
        privsize: u32,
        private: []const u8,
    };
    pub const ValidateModeLine = struct { // opcode 9
        screen: u32,
        dotclock: DOTCLOCK,
        hdisplay: u16,
        hsyncstart: u16,
        hsyncend: u16,
        htotal: u16,
        hskew: u16,
        vdisplay: u16,
        vsyncstart: u16,
        vsyncend: u16,
        vtotal: u16,
        flags: u32,
        privsize: u32,
        private: []const u8,
        pub const Reply = struct {
            status: u32,
        };
    };
    pub const SwitchToMode = struct { // opcode 10
        screen: u32,
        dotclock: DOTCLOCK,
        hdisplay: u16,
        hsyncstart: u16,
        hsyncend: u16,
        htotal: u16,
        hskew: u16,
        vdisplay: u16,
        vsyncstart: u16,
        vsyncend: u16,
        vtotal: u16,
        flags: u32,
        privsize: u32,
        private: []const u8,
    };
    pub const GetViewPort = struct { // opcode 11
        screen: u16,
        pub const Reply = struct {
            x: u32,
            y: u32,
        };
    };
    pub const SetViewPort = struct { // opcode 12
        screen: u16,
        x: u32,
        y: u32,
    };
    pub const GetDotClocks = struct { // opcode 13
        screen: u16,
        pub const Reply = struct {
            flags: u32,
            clocks: u32,
            maxclocks: u32,
            clock: []const u32,
        };
    };
    pub const SetClientVersion = struct { // opcode 14
        major: u16,
        minor: u16,
    };
    pub const SetGamma = struct { // opcode 15
        screen: u16,
        red: u32,
        green: u32,
        blue: u32,
    };
    pub const GetGamma = struct { // opcode 16
        screen: u16,
        pub const Reply = struct {
            red: u32,
            green: u32,
            blue: u32,
        };
    };
    pub const GetGammaRamp = struct { // opcode 17
        screen: u16,
        size: u16,
        pub const Reply = struct {
            size: u16,
            red: []const u16,
            green: []const u16,
            blue: []const u16,
        };
    };
    pub const SetGammaRamp = struct { // opcode 18
        screen: u16,
        size: u16,
        red: []const u16,
        green: []const u16,
        blue: []const u16,
    };
    pub const GetGammaRampSize = struct { // opcode 19
        screen: u16,
        pub const Reply = struct {
            size: u16,
        };
    };
    pub const GetPermissions = struct { // opcode 20
        screen: u16,
        pub const Reply = struct {
            permissions: u32,
        };
    };
    pub const BadClock = struct {};
    pub const BadHTimings = struct {};
    pub const BadVTimings = struct {};
    pub const ModeUnsuitable = struct {};
    pub const ExtensionDisabled = struct {};
    pub const ClientNotLocal = struct {};
    pub const ZoomLocked = struct {};
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        get_mode_line = 1,
        mod_mode_line = 2,
        switch_mode = 3,
        get_monitor = 4,
        lock_mode_switch = 5,
        get_all_mode_lines = 6,
        add_mode_line = 7,
        delete_mode_line = 8,
        validate_mode_line = 9,
        switch_to_mode = 10,
        get_view_port = 11,
        set_view_port = 12,
        get_dot_clocks = 13,
        set_client_version = 14,
        set_gamma = 15,
        get_gamma = 16,
        get_gamma_ramp = 17,
        set_gamma_ramp = 18,
        get_gamma_ramp_size = 19,
        get_permissions = 20,
    };
};
pub const randr = struct {
    pub const OUTPUT = u32;
    pub const CRTC = u32;
    pub const MODE = u32;
    pub const TRANSFORM = u32;
    pub const FixedF32 = u32; // Fixed floating point
    pub const PROVIDER = u32;
    pub const LEASE = u32;

    pub const BadOutput = struct {};
    pub const BadCrtc = struct {};
    pub const BadMode = struct {};
    pub const BadProvider = struct {};
    pub const Rotation = packed struct(u32) {
        rotate_0: bool = false,
        rotate_90: bool = false,
        rotate_180: bool = false,
        rotate_270: bool = false,
        reflect_x: bool = false,
        reflect_y: bool = false,
        pad0: u26 = 0,
    };
    pub const ScreenSize = struct {
        width: u16,
        height: u16,
        mwidth: u16,
        mheight: u16,
    };
    pub const RefreshRates = struct {
        nRates: u16,
        rates: []const u16,
    };
    pub const QueryVersion = struct { // opcode 0
        major_version: u32,
        minor_version: u32,
        pub const Reply = struct {
            major_version: u32,
            minor_version: u32,
        };
    };
    pub const SetConfig = enum(u32) {
        success = 0,
        invalid_config_time = 1,
        invalid_time = 2,
        failed = 3,
    };
    pub const SetScreenConfig = struct { // opcode 2
        window: Window,
        u32_ms: u32,
        config_timestamp: u32,
        sizeID: u16,
        rotation: u16,
        rate: u16,
        pub const Reply = struct {
            status: u8,
            new_timestamp: u32,
            config_timestamp: u32,
            root: Window,
            subpixel_order: u16,
        };
    };
    pub const NotifyMask = packed struct(u32) {
        screen_change: bool = false,
        crtc_change: bool = false,
        output_change: bool = false,
        output_property: bool = false,
        provider_change: bool = false,
        provider_property: bool = false,
        resource_change: bool = false,
        lease: bool = false,
    };
    pub const SelectInput = struct { // opcode 4
        window: Window,
        enable: u16,
    };
    pub const GetScreenInfo = struct { // opcode 5
        window: Window,
        pub const Reply = struct {
            rotations: u8,
            root: Window,
            u32_ms: u32,
            config_timestamp: u32,
            nSizes: u16,
            sizeID: u16,
            rotation: u16,
            rate: u16,
            nInfo: u16,
            sizes: []const ScreenSize,
            rates: []const RefreshRates,
        };
    };
    pub const GetScreenSizeRange = struct { // opcode 6
        window: Window,
        pub const Reply = struct {
            min_width: u16,
            min_height: u16,
            max_width: u16,
            max_height: u16,
        };
    };
    pub const SetScreenSize = struct { // opcode 7
        window: Window,
        width: u16,
        height: u16,
        mm_width: u32,
        mm_height: u32,
    };
    pub const ModeFlag = packed struct(u32) {
        hsync_positive: bool = false,
        hsync_negative: bool = false,
        vsync_positive: bool = false,
        vsync_negative: bool = false,
        interlace: bool = false,
        double_scan: bool = false,
        csync: bool = false,
        csync_positive: bool = false,
        csync_negative: bool = false,
        hskew_present: bool = false,
        bcast: bool = false,
        pixel_multiplex: bool = false,
        double_clock: bool = false,
        halve_clock: bool = false,
        pad0: u18 = 0,
    };
    pub const ModeInfo = struct {
        id: u32,
        width: u16,
        height: u16,
        dot_clock: u32,
        hsync_start: u16,
        hsync_end: u16,
        htotal: u16,
        hskew: u16,
        vsync_start: u16,
        vsync_end: u16,
        vtotal: u16,
        name_len: u16,
        mode_flags: u32,
    };
    pub const GetScreenResources = struct { // opcode 8
        window: Window,
        pub const Reply = struct {
            u32_ms: u32,
            config_timestamp: u32,
            num_crtcs: u16,
            num_outputs: u16,
            num_modes: u16,
            names_len: u16,
            crtcs: []const CRTC,
            outputs: []const OUTPUT,
            modes: []const ModeInfo,
            names: []const u8,
        };
    };
    pub const Connection = enum(u32) {
        connected = 0,
        disconnected = 1,
        unknown = 2,
    };
    pub const GetOutputInfo = struct { // opcode 9
        output: OUTPUT,
        config_timestamp: u32,
        pub const Reply = struct {
            status: u8,
            u32_ms: u32,
            crtc: CRTC,
            mm_width: u32,
            mm_height: u32,
            connection: u8,
            subpixel_order: u8,
            num_crtcs: u16,
            num_modes: u16,
            num_preferred: u16,
            num_clones: u16,
            name_len: u16,
            crtcs: []const CRTC,
            modes: []const MODE,
            clones: []const OUTPUT,
            name: []const u8,
        };
    };
    pub const ListOutputProperties = struct { // opcode 10
        output: OUTPUT,
        pub const Reply = struct {
            num_atoms: u16,
            atoms: []const Atom,
        };
    };
    pub const QueryOutputProperty = struct { // opcode 11
        output: OUTPUT,
        property: Atom,
        pub const Reply = struct {
            pending: bool,
            range: bool,
            immutable: bool,
            validValues: []const i32,
        };
    };
    pub const ConfigureOutputProperty = struct { // opcode 12
        output: OUTPUT,
        property: Atom,
        pending: bool,
        range: bool,
        values: []const i32,
    };
    pub const ChangeOutputProperty = struct { // opcode 13
        output: OUTPUT,
        property: Atom,
        type: Atom,
        format: u8,
        mode: u8,
        num_units: u32,
        data: []const void,
    };
    pub const DeleteOutputProperty = struct { // opcode 14
        output: OUTPUT,
        property: Atom,
    };
    pub const GetOutputProperty = struct { // opcode 15
        output: OUTPUT,
        property: Atom,
        type: Atom,
        long_offset: u32,
        long_length: u32,
        delete: bool,
        pending: bool,
        pub const Reply = struct {
            format: u8,
            type: Atom,
            bytes_after: u32,
            num_items: u32,
            data: []const u8,
        };
    };
    pub const CreateMode = struct { // opcode 16
        window: Window,
        mode_info: ModeInfo,
        name: []const u8,
        pub const Reply = struct {
            mode: MODE,
        };
    };
    pub const DestroyMode = struct { // opcode 17
        mode: MODE,
    };
    pub const AddOutputMode = struct { // opcode 18
        output: OUTPUT,
        mode: MODE,
    };
    pub const DeleteOutputMode = struct { // opcode 19
        output: OUTPUT,
        mode: MODE,
    };
    pub const GetCrtcInfo = struct { // opcode 20
        crtc: CRTC,
        config_timestamp: u32,
        pub const Reply = struct {
            status: u8,
            u32_ms: u32,
            x: i16,
            y: i16,
            width: u16,
            height: u16,
            mode: MODE,
            rotation: u16,
            rotations: u16,
            num_outputs: u16,
            num_possible_outputs: u16,
            outputs: []const OUTPUT,
            possible: []const OUTPUT,
        };
    };
    pub const SetCrtcConfig = struct { // opcode 21
        crtc: CRTC,
        u32_ms: u32,
        config_timestamp: u32,
        x: i16,
        y: i16,
        mode: MODE,
        rotation: u16,
        outputs: []const OUTPUT,
        pub const Reply = struct {
            status: u8,
            u32_ms: u32,
        };
    };
    pub const GetCrtcGammaSize = struct { // opcode 22
        crtc: CRTC,
        pub const Reply = struct {
            size: u16,
        };
    };
    pub const GetCrtcGamma = struct { // opcode 23
        crtc: CRTC,
        pub const Reply = struct {
            size: u16,
            red: []const u16,
            green: []const u16,
            blue: []const u16,
        };
    };
    pub const SetCrtcGamma = struct { // opcode 24
        crtc: CRTC,
        size: u16,
        red: []const u16,
        green: []const u16,
        blue: []const u16,
    };
    pub const GetScreenResourcesCurrent = struct { // opcode 25
        window: Window,
        pub const Reply = struct {
            u32_ms: u32,
            config_timestamp: u32,
            num_crtcs: u16,
            num_outputs: u16,
            num_modes: u16,
            names_len: u16,
            crtcs: []const CRTC,
            outputs: []const OUTPUT,
            modes: []const ModeInfo,
            names: []const u8,
        };
    };
    pub const Transform = packed struct(u32) {
        unit: bool = false,
        scale_up: bool = false,
        scale_down: bool = false,
        projective: bool = false,
        pad0: u28 = 0,
    };
    pub const SetCrtcTransform = struct { // opcode 26
        crtc: CRTC,
        transform: TRANSFORM,
        filter_len: u16,
        filter_name: []const u8,
        filter_params: []const FixedF32,
    };
    pub const GetCrtcTransform = struct { // opcode 27
        crtc: CRTC,
        pub const Reply = struct {
            pending_transform: TRANSFORM,
            has_transforms: bool,
            current_transform: TRANSFORM,
            pending_len: u16,
            pending_nparams: u16,
            current_len: u16,
            current_nparams: u16,
            pending_filter_name: []const u8,
            pending_params: []const FixedF32,
            current_filter_name: []const u8,
            current_params: []const FixedF32,
        };
    };
    pub const GetPanning = struct { // opcode 28
        crtc: CRTC,
        pub const Reply = struct {
            status: u8,
            u32_ms: u32,
            left: u16,
            top: u16,
            width: u16,
            height: u16,
            track_left: u16,
            track_top: u16,
            track_width: u16,
            track_height: u16,
            border_left: i16,
            border_top: i16,
            border_right: i16,
            border_bottom: i16,
        };
    };
    pub const SetPanning = struct { // opcode 29
        crtc: CRTC,
        u32_ms: u32,
        left: u16,
        top: u16,
        width: u16,
        height: u16,
        track_left: u16,
        track_top: u16,
        track_width: u16,
        track_height: u16,
        border_left: i16,
        border_top: i16,
        border_right: i16,
        border_bottom: i16,
        pub const Reply = struct {
            status: u8,
            u32_ms: u32,
        };
    };
    pub const SetOutputPrimary = struct { // opcode 30
        window: Window,
        output: OUTPUT,
    };
    pub const GetOutputPrimary = struct { // opcode 31
        window: Window,
        pub const Reply = struct {
            output: OUTPUT,
        };
    };
    pub const GetProviders = struct { // opcode 32
        window: Window,
        pub const Reply = struct {
            u32_ms: u32,
            num_providers: u16,
            providers: []const PROVIDER,
        };
    };
    pub const ProviderCapability = packed struct(u32) {
        source_output: bool = false,
        sink_output: bool = false,
        source_offload: bool = false,
        sink_offload: bool = false,
        pad0: u28 = 0,
    };
    pub const GetProviderInfo = struct { // opcode 33
        provider: PROVIDER,
        config_timestamp: u32,
        pub const Reply = struct {
            status: u8,
            u32_ms: u32,
            capabilities: u32,
            num_crtcs: u16,
            num_outputs: u16,
            num_associated_providers: u16,
            name_len: u16,
            crtcs: []const CRTC,
            outputs: []const OUTPUT,
            associated_providers: []const PROVIDER,
            associated_capability: []const u32,
            name: []const u8,
        };
    };
    pub const SetProviderOffloadSink = struct { // opcode 34
        provider: PROVIDER,
        sink_provider: PROVIDER,
        config_timestamp: u32,
    };
    pub const SetProviderOutputSource = struct { // opcode 35
        provider: PROVIDER,
        source_provider: PROVIDER,
        config_timestamp: u32,
    };
    pub const ListProviderProperties = struct { // opcode 36
        provider: PROVIDER,
        pub const Reply = struct {
            num_atoms: u16,
            atoms: []const Atom,
        };
    };
    pub const QueryProviderProperty = struct { // opcode 37
        provider: PROVIDER,
        property: Atom,
        pub const Reply = struct {
            pending: bool,
            range: bool,
            immutable: bool,
            valid_values: []const i32,
        };
    };
    pub const ConfigureProviderProperty = struct { // opcode 38
        provider: PROVIDER,
        property: Atom,
        pending: bool,
        range: bool,
        values: []const i32,
    };
    pub const ChangeProviderProperty = struct { // opcode 39
        provider: PROVIDER,
        property: Atom,
        type: Atom,
        format: u8,
        mode: u8,
        num_items: u32,
        data: []const void,
    };
    pub const DeleteProviderProperty = struct { // opcode 40
        provider: PROVIDER,
        property: Atom,
    };
    pub const GetProviderProperty = struct { // opcode 41
        provider: PROVIDER,
        property: Atom,
        type: Atom,
        long_offset: u32,
        long_length: u32,
        delete: bool,
        pending: bool,
        pub const Reply = struct {
            format: u8,
            type: Atom,
            bytes_after: u32,
            num_items: u32,
            data: []const void,
        };
    };
    pub const ScreenChangeNotify = struct {
        rotation: u8,
        u32_ms: u32,
        config_timestamp: u32,
        root: Window,
        request_window: Window,
        sizeID: u16,
        subpixel_order: u16,
        width: u16,
        height: u16,
        mwidth: u16,
        mheight: u16,
    };
    pub const Notify2 = enum(u32) {
        crtc_change = 0,
        output_change = 1,
        output_property = 2,
        provider_change = 3,
        provider_property = 4,
        resource_change = 5,
        lease = 6,
    };
    pub const CrtcChange = struct {
        u32_ms: u32,
        window: Window,
        crtc: CRTC,
        mode: MODE,
        rotation: u16,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
    };
    pub const OutputChange = struct {
        u32_ms: u32,
        config_timestamp: u32,
        window: Window,
        output: OUTPUT,
        crtc: CRTC,
        mode: MODE,
        rotation: u16,
        connection: u8,
        subpixel_order: u8,
    };
    pub const OutputProperty = struct {
        window: Window,
        output: OUTPUT,
        atom: Atom,
        u32_ms: u32,
        status: u8,
    };
    pub const ProviderChange = struct {
        u32_ms: u32,
        window: Window,
        provider: PROVIDER,
    };
    pub const ProviderProperty = struct {
        window: Window,
        provider: PROVIDER,
        atom: Atom,
        u32_ms: u32,
        state: u8,
    };
    pub const ResourceChange = struct {
        u32_ms: u32,
        window: Window,
    };
    pub const MonitorInfo = struct {
        name: Atom,
        primary: bool,
        automatic: bool,
        nOutput: u16,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        width_in_millimeters: u32,
        height_in_millimeters: u32,
        outputs: []const OUTPUT,
    };
    pub const GetMonitors = struct { // opcode 42
        window: Window,
        get_active: bool,
        pub const Reply = struct {
            u32_ms: u32,
            nMonitors: u32,
            nOutputs: u32,
            monitors: []const MonitorInfo,
        };
    };
    pub const SetMonitor = struct { // opcode 43
        window: Window,
        monitorinfo: MonitorInfo,
    };
    pub const DeleteMonitor = struct { // opcode 44
        window: Window,
        name: Atom,
    };
    pub const CreateLease = struct { // opcode 45
        window: Window,
        lid: LEASE,
        num_crtcs: u16,
        num_outputs: u16,
        crtcs: []const CRTC,
        outputs: []const OUTPUT,
        pub const Reply = struct {
            nfd: u8,
            // unknown start fd
            // unknown end fd
        };
    };
    pub const FreeLease = struct { // opcode 46
        lid: LEASE,
        terminate: u8,
    };
    pub const LeaseNotify = struct {
        u32_ms: u32,
        window: Window,
        lease: LEASE,
        created: u8,
    };
    pub const NotifyData = extern union {
        cc: CrtcChange,
        oc: OutputChange,
        op: OutputProperty,
        pc: ProviderChange,
        pp: ProviderProperty,
        rc: ResourceChange,
        lc: LeaseNotify,
    };
    pub const Notify = struct {
        subCode: u8,
        u: NotifyData,
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        set_screen_config = 2,
        select_input = 4,
        get_screen_info = 5,
        get_screen_size_range = 6,
        set_screen_size = 7,
        get_screen_resources = 8,
        get_output_info = 9,
        list_output_properties = 10,
        query_output_property = 11,
        configure_output_property = 12,
        change_output_property = 13,
        delete_output_property = 14,
        get_output_property = 15,
        create_mode = 16,
        destroy_mode = 17,
        add_output_mode = 18,
        delete_output_mode = 19,
        get_crtc_info = 20,
        set_crtc_config = 21,
        get_crtc_gamma_size = 22,
        get_crtc_gamma = 23,
        set_crtc_gamma = 24,
        get_screen_resources_current = 25,
        set_crtc_transform = 26,
        get_crtc_transform = 27,
        get_panning = 28,
        set_panning = 29,
        set_output_primary = 30,
        get_output_primary = 31,
        get_providers = 32,
        get_provider_info = 33,
        set_provider_offload_sink = 34,
        set_provider_output_source = 35,
        list_provider_properties = 36,
        query_provider_property = 37,
        configure_provider_property = 38,
        change_provider_property = 39,
        delete_provider_property = 40,
        get_provider_property = 41,
        get_monitors = 42,
        set_monitor = 43,
        delete_monitor = 44,
        create_lease = 45,
        free_lease = 46,
    };
};

pub const PORT = u32;

pub const xv = struct {
    pub const ENCODING = u32;
    pub const Seg = u32;

    pub const Type = packed struct(u32) {
        input_mask: bool = false,
        output_mask: bool = false,
        video_mask: bool = false,
        still_mask: bool = false,
        image_mask: bool = false,
        pad0: u27 = 0,
    };
    pub const ImageFormatInfoType = enum(u32) {
        r_g_b = 0,
        y_u_v = 1,
    };
    pub const ImageFormatInfoFormat = enum(u32) {
        @"packed" = 0,
        planar = 1,
    };
    pub const AttributeFlag = packed struct(u32) {
        gettable: bool = false,
        settable: bool = false,
        pad0: u30 = 0,
    };
    pub const VideoNotifyReason = enum(u32) {
        started = 0,
        stopped = 1,
        busy = 2,
        preempted = 3,
        hard_error = 4,
    };
    pub const ScanlineOrder = enum(u32) {
        top_to_bottom = 0,
        bottom_to_top = 1,
    };
    pub const GrabPortStatus = enum(u32) {
        success = 0,
        bad_extension = 1,
        already_grabbed = 2,
        invalid_time = 3,
        bad_reply = 4,
        bad_alloc = 5,
    };
    pub const Rational = struct {
        numerator: i32,
        denominator: i32,
    };
    pub const Format = struct {
        visual: Visual.Id,
        depth: u8,
    };
    pub const AdaptorInfo = struct {
        base_id: PORT,
        name_size: u16,
        num_ports: u16,
        num_formats: u16,
        type: u8,
        name: []const u8,
        formats: []const Format,
    };
    pub const EncodingInfo = struct {
        encoding: ENCODING,
        name_size: u16,
        width: u16,
        height: u16,
        rate: Rational,
        name: []const u8,
    };
    pub const Image = struct {
        id: u32,
        width: u16,
        height: u16,
        data_size: u32,
        num_planes: u32,
        pitches: []const u32,
        offsets: []const u32,
        data: []const u8,
    };
    pub const AttributeInfo = struct {
        flags: u32,
        min: i32,
        max: i32,
        size: u32,
        name: []const u8,
    };
    pub const ImageFormatInfo = struct {
        id: u32,
        type: u8,
        byte_order: u8,
        guid: []const u8,
        bpp: u8,
        num_planes: u8,
        depth: u8,
        red_mask: u32,
        green_mask: u32,
        blue_mask: u32,
        format: u8,
        y_sample_bits: u32,
        u_sample_bits: u32,
        v_sample_bits: u32,
        vhorz_y_period: u32,
        vhorz_u_period: u32,
        vhorz_v_period: u32,
        vvert_y_period: u32,
        vvert_u_period: u32,
        vvert_v_period: u32,
        vcomp_order: []const u8,
        vscanline_order: u8,
    };
    pub const BadPort = struct {};
    pub const BadEncoding = struct {};
    pub const BadControl = struct {};
    pub const VideoNotify = struct {
        reason: u8,
        time: u32,
        drawable: Drawable,
        port: PORT,
    };
    pub const PortNotify = struct {
        time: u32,
        port: PORT,
        attribute: Atom,
        value: i32,
    };
    pub const QueryExtension = struct { // opcode 0
        pub const Reply = struct {
            major: u16,
            minor: u16,
        };
    };
    pub const QueryAdaptors = struct { // opcode 1
        window: Window,
        pub const Reply = struct {
            num_adaptors: u16,
            info: []const AdaptorInfo,
        };
    };
    pub const QueryEncodings = struct { // opcode 2
        port: PORT,
        pub const Reply = struct {
            num_encodings: u16,
            info: []const EncodingInfo,
        };
    };
    pub const GrabPort = struct { // opcode 3
        port: PORT,
        time: u32,
        pub const Reply = struct {
            result: u8,
        };
    };
    pub const UngrabPort = struct { // opcode 4
        port: PORT,
        time: u32,
    };
    pub const PutVideo = struct { // opcode 5
        port: PORT,
        drawable: Drawable,
        graphics_context: GraphicsContext,
        vid_x: i16,
        vid_y: i16,
        vid_w: u16,
        vid_h: u16,
        drw_x: i16,
        drw_y: i16,
        drw_w: u16,
        drw_h: u16,
    };
    pub const PutStill = struct { // opcode 6
        port: PORT,
        drawable: Drawable,
        graphics_context: GraphicsContext,
        vid_x: i16,
        vid_y: i16,
        vid_w: u16,
        vid_h: u16,
        drw_x: i16,
        drw_y: i16,
        drw_w: u16,
        drw_h: u16,
    };
    pub const GetVideo = struct { // opcode 7
        port: PORT,
        drawable: Drawable,
        graphics_context: GraphicsContext,
        vid_x: i16,
        vid_y: i16,
        vid_w: u16,
        vid_h: u16,
        drw_x: i16,
        drw_y: i16,
        drw_w: u16,
        drw_h: u16,
    };
    pub const GetStill = struct { // opcode 8
        port: PORT,
        drawable: Drawable,
        graphics_context: GraphicsContext,
        vid_x: i16,
        vid_y: i16,
        vid_w: u16,
        vid_h: u16,
        drw_x: i16,
        drw_y: i16,
        drw_w: u16,
        drw_h: u16,
    };
    pub const StopVideo = struct { // opcode 9
        port: PORT,
        drawable: Drawable,
    };
    pub const SelectVideoNotify = struct { // opcode 10
        drawable: Drawable,
        onoff: bool,
    };
    pub const SelectPortNotify = struct { // opcode 11
        port: PORT,
        onoff: bool,
    };
    pub const QueryBestSize = struct { // opcode 12
        port: PORT,
        vid_w: u16,
        vid_h: u16,
        drw_w: u16,
        drw_h: u16,
        motion: bool,
        pub const Reply = struct {
            actual_width: u16,
            actual_height: u16,
        };
    };
    pub const SetPortAttribute = struct { // opcode 13
        port: PORT,
        attribute: Atom,
        value: i32,
    };
    pub const GetPortAttribute = struct { // opcode 14
        port: PORT,
        attribute: Atom,
        pub const Reply = struct {
            value: i32,
        };
    };
    pub const QueryPortAttributes = struct { // opcode 15
        port: PORT,
        pub const Reply = struct {
            num_attributes: u32,
            text_size: u32,
            attributes: []const AttributeInfo,
        };
    };
    pub const ListImageFormats = struct { // opcode 16
        port: PORT,
        pub const Reply = struct {
            num_formats: u32,
            format: []const ImageFormatInfo,
        };
    };
    pub const QueryImageAttributes = struct { // opcode 17
        port: PORT,
        id: u32,
        width: u16,
        height: u16,
        pub const Reply = struct {
            num_planes: u32,
            data_size: u32,
            width: u16,
            height: u16,
            pitches: []const u32,
            offsets: []const u32,
        };
    };
    pub const PutImage = struct { // opcode 18
        port: PORT,
        drawable: Drawable,
        graphics_context: GraphicsContext,
        id: u32,
        src_x: i16,
        src_y: i16,
        src_w: u16,
        src_h: u16,
        drw_x: i16,
        drw_y: i16,
        drw_w: u16,
        drw_h: u16,
        width: u16,
        height: u16,
        data: []const u8,
    };
    pub const ShmPutImage = struct { // opcode 19
        port: PORT,
        drawable: Drawable,
        graphics_context: GraphicsContext,
        shmseg: Seg,
        id: u32,
        offset: u32,
        src_x: i16,
        src_y: i16,
        src_w: u16,
        src_h: u16,
        drw_x: i16,
        drw_y: i16,
        drw_w: u16,
        drw_h: u16,
        width: u16,
        height: u16,
        send_event: u8,
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_extension = 0,
        query_adaptors = 1,
        query_encodings = 2,
        grab_port = 3,
        ungrab_port = 4,
        put_video = 5,
        put_still = 6,
        get_video = 7,
        get_still = 8,
        stop_video = 9,
        select_video_notify = 10,
        select_port_notify = 11,
        query_best_size = 12,
        set_port_attribute = 13,
        get_port_attribute = 14,
        query_port_attributes = 15,
        list_image_formats = 16,
        query_image_attributes = 17,
        put_image = 18,
        shm_put_image = 19,
    };
};
pub const xvmc = struct {
    pub const SURFACE = u32;
    pub const Context = u32;
    pub const SUBPICTURE = u32;

    pub const SurfaceInfo = struct {
        id: SURFACE,
        chroma_format: u16,
        pad0: u16,
        max_width: u16,
        max_height: u16,
        subpicture_max_width: u16,
        subpicture_max_height: u16,
        mc_type: u32,
        flags: u32,
    };
    pub const QueryVersion = struct { // opcode 0
        pub const Reply = struct {
            major: u32,
            minor: u32,
        };
    };
    pub const ListSurfaceTypes = struct { // opcode 1
        port_id: PORT,
        pub const Reply = struct {
            num: u32,
            surfaces: []const SurfaceInfo,
        };
    };
    pub const CreateContext = struct { // opcode 2
        context_id: Context,
        port_id: PORT,
        surface_id: SURFACE,
        width: u16,
        height: u16,
        flags: u32,
        pub const Reply = struct {
            width_actual: u16,
            height_actual: u16,
            flags_return: u32,
            priv_data: []const u32,
        };
    };
    pub const DestroyContext = struct { // opcode 3
        context_id: Context,
    };
    pub const CreateSurface = struct { // opcode 4
        surface_id: SURFACE,
        context_id: Context,
        pub const Reply = struct {
            priv_data: []const u32,
        };
    };
    pub const DestroySurface = struct { // opcode 5
        surface_id: SURFACE,
    };
    pub const CreateSubpicture = struct { // opcode 6
        subpicture_id: SUBPICTURE,
        context: Context,
        xvimage_id: u32,
        width: u16,
        height: u16,
        pub const Reply = struct {
            width_actual: u16,
            height_actual: u16,
            num_palette_entries: u16,
            entry_bytes: u16,
            component_order: []const u8,
            priv_data: []const u32,
        };
    };
    pub const DestroySubpicture = struct { // opcode 7
        subpicture_id: SUBPICTURE,
    };
    pub const ListSubpictureTypes = struct { // opcode 8
        port_id: PORT,
        surface_id: SURFACE,
        pub const Reply = struct {
            num: u32,
            types: []const ImageFormatInfo,

            pub const ImageFormatInfo = @compileError("not implemented");
        };
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        list_surface_types = 1,
        create_context = 2,
        destroy_context = 3,
        create_surface = 4,
        destroy_surface = 5,
        create_subpicture = 6,
        destroy_subpicture = 7,
        list_subpicture_types = 8,
    };
};
pub const xkb = struct {
    pub const DeviceSpec = u8;

    pub const Const = enum(u32) {
        max_legal_key_code = 255,
        per_key_bit_array_size = 32,
        key_name_length = 4,
    };
    pub const EventType = packed struct(u32) {
        new_keyboard_notify: bool = false,
        map_notify: bool = false,
        state_notify: bool = false,
        controls_notify: bool = false,
        indicator_state_notify: bool = false,
        indicator_map_notify: bool = false,
        names_notify: bool = false,
        compat_map_notify: bool = false,
        bell_notify: bool = false,
        action_message: bool = false,
        access_x_notify: bool = false,
        extension_device_notify: bool = false,
        pad0: u20 = 0,
    };
    pub const NKNDetail = packed struct(u32) {
        keycodes: bool = false,
        geometry: bool = false,
        device_i_d: bool = false,
        pad0: u29 = 0,
    };
    pub const AXNDetail = packed struct(u32) {
        s_k_press: bool = false,
        s_k_accept: bool = false,
        s_k_reject: bool = false,
        s_k_release: bool = false,
        b_k_accept: bool = false,
        b_k_reject: bool = false,
        a_x_k_warning: bool = false,
        pad0: u25 = 0,
    };
    pub const MapPart = packed struct(u32) {
        key_types: bool = false,
        key_syms: bool = false,
        modifier_map: bool = false,
        explicit_components: bool = false,
        key_actions: bool = false,
        key_behaviors: bool = false,
        virtual_mods: bool = false,
        virtual_mod_map: bool = false,
        pad: u26 = 0,
    };
    pub const SetMapFlags = packed struct(u32) {
        resize_types: bool = false,
        recompute_actions: bool = false,
        pad0: u30 = 0,
    };
    pub const StatePart = packed struct(u32) {
        modifier_state: bool = false,
        modifier_base: bool = false,
        modifier_latch: bool = false,
        modifier_lock: bool = false,
        group_state: bool = false,
        group_base: bool = false,
        group_latch: bool = false,
        group_lock: bool = false,
        compat_state: bool = false,
        grab_mods: bool = false,
        compat_grab_mods: bool = false,
        lookup_mods: bool = false,
        compat_lookup_mods: bool = false,
        pointer_buttons: bool = false,
        pad0: u18 = 0,
    };
    pub const boolCtrl = packed struct(u32) {
        repeat_keys: bool = false,
        slow_keys: bool = false,
        bounce_keys: bool = false,
        sticky_keys: bool = false,
        mouse_keys: bool = false,
        mouse_keys_accel: bool = false,
        access_x_keys: bool = false,
        access_x_timeout_mask: bool = false,
        access_x_feedback_mask: bool = false,
        audible_bell_mask: bool = false,
        overlay1_mask: bool = false,
        overlay2_mask: bool = false,
        ignore_group_lock_mask: bool = false,
        pad0: u21 = 0,
    };
    pub const Control = packed struct(u32) {
        groups_wrap: bool = false,
        internal_mods: bool = false,
        ignore_lock_mods: bool = false,
        per_key_repeat: bool = false,
        controls_enabled: bool = false,
        pad0: u27 = 0,
    };
    pub const AXOption = packed struct(u32) {
        s_k_press_f_b: bool = false,
        s_k_accept_f_b: bool = false,
        feature_f_b: bool = false,
        slow_warn_f_b: bool = false,
        indicator_f_b: bool = false,
        sticky_keys_f_b: bool = false,
        two_keys: bool = false,
        latch_to_lock: bool = false,
        s_k_release_f_b: bool = false,
        s_k_reject_f_b: bool = false,
        b_k_reject_f_b: bool = false,
        dumb_bell: bool = false,
        pad0: u20 = 0,
    };
    pub const LedClassResult = enum(u32) {
        kbd_feedback_class = 0,
        led_feedback_class = 4,
    };
    pub const LedClass = enum(u16) {
        kbd_feedback_class = 0,
        led_feedback_class = 4,
        dflt_x_i_class = 768,
        all_x_i_classes = 1280,
    };
    pub const BellClassResult = enum(u32) {
        kbd_feedback_class = 0,
        bell_feedback_class = 5,
    };
    pub const BellClass = enum(u32) {
        kbd_feedback_class = 0,
        bell_feedback_class = 5,
        dflt_x_i_class = 768,
    };
    pub const ID = enum(u32) {
        use_core_kbd = 256,
        use_core_ptr = 512,
        dflt_x_i_class = 768,
        dflt_x_i_id = 1024,
        all_x_i_class = 1280,
        all_x_i_id = 1536,
        x_i_none = 65280,
    };
    pub const Group = enum(u32) {
        @"1" = 0,
        @"2" = 1,
        @"3" = 2,
        @"4" = 3,
    };
    pub const Groups = enum(u32) {
        any = 254,
        all = 255,
    };
    pub const SetOfGroup = packed struct(u32) {
        group1: bool = false,
        group2: bool = false,
        group3: bool = false,
        group4: bool = false,
        pad0: u28 = 0,
    };
    pub const SetOfGroups = packed struct(u32) {
        any: bool = false,
        pad0: u31 = 0,
    };
    pub const GroupsWrap = packed struct(u32) {
        pub const wrap_into_range: @This() = .{};
        clamp_into_range: bool = false,
        redirect_into_range: bool = false,
        pad0: u30 = 0,
    };
    pub const VModsHigh = packed struct(u32) {
        @"15": bool = false,
        @"14": bool = false,
        @"13": bool = false,
        @"12": bool = false,
        @"11": bool = false,
        @"10": bool = false,
        @"9": bool = false,
        @"8": bool = false,
    };
    pub const VModsLow = packed struct(u32) {
        @"7": bool = false,
        @"6": bool = false,
        @"5": bool = false,
        @"4": bool = false,
        @"3": bool = false,
        @"2": bool = false,
        @"1": bool = false,
        @"0": bool = false,
        pad0: u24 = 0,
    };
    pub const VMod = packed struct(u32) {
        @"15": bool = false,
        @"14": bool = false,
        @"13": bool = false,
        @"12": bool = false,
        @"11": bool = false,
        @"10": bool = false,
        @"9": bool = false,
        @"8": bool = false,
        @"7": bool = false,
        @"6": bool = false,
        @"5": bool = false,
        @"4": bool = false,
        @"3": bool = false,
        @"2": bool = false,
        @"1": bool = false,
        @"0": bool = false,
        pad0: u17 = 0,
    };
    pub const Explicit = packed struct(u32) {
        v_mod_map: bool = false,
        behavior: bool = false,
        auto_repeat: bool = false,
        interpret: bool = false,
        key_type4: bool = false,
        key_type3: bool = false,
        key_type2: bool = false,
        key_type1: bool = false,
        pad0: u26 = 0,
    };
    pub const SymInterpretMatch = enum(u32) {
        none_of = 0,
        any_of_or_none = 1,
        any_of = 2,
        all_of = 3,
        exactly = 4,
    };
    pub const SymInterpMatch = packed struct(u32) {
        level_one_only: bool = false,
        pad0: u31 = 0,
        pub const op_mask: @This() = @bitCast(127);
    };
    pub const IMFlag = packed struct(u32) {
        no_explicit: bool = false,
        no_automatic: bool = false,
        led_drives_kb: bool = false,
        pad0: u29 = 0,
    };
    pub const IMModsWhich = packed struct(u32) {
        use_compat: bool = false,
        use_effective: bool = false,
        use_locked: bool = false,
        use_latched: bool = false,
        use_base: bool = false,
        pad0: u27 = 0,
    };
    pub const IMGroupsWhich = packed struct(u32) {
        use_compat: bool = false,
        use_effective: bool = false,
        use_locked: bool = false,
        use_latched: bool = false,
        use_base: bool = false,
        pad0: u27 = 0,
    };
    pub const IndicatorMap = struct {
        flags: u8,
        which_groups: u8,
        groups: u8,
        which_mods: u8,
        mods: u8,
        real_mods: u8,
        vmods: u16,
        ctrls: u16,
    };
    pub const CMDetail = packed struct(u32) {
        sym_interp: bool = false,
        group_compat: bool = false,
        pad0: u30 = 0,
    };
    pub const NameDetail = packed struct(u32) {
        keycodes: bool = false,
        geometry: bool = false,
        symbols: bool = false,
        phys_symbols: bool = false,
        types: bool = false,
        compat: bool = false,
        key_type_names: bool = false,
        kt_level_names: bool = false,
        indicator_names: bool = false,
        key_names: bool = false,
        key_aliases: bool = false,
        virtual_mod_names: bool = false,
        group_names: bool = false,
        rg_names: bool = false,
        pad0: u18 = 0,
    };
    pub const GBNDetail = packed struct(u32) {
        types: bool = false,
        compat_map: bool = false,
        client_symbols: bool = false,
        server_symbols: bool = false,
        indicator_maps: bool = false,
        key_names: bool = false,
        geometry: bool = false,
        other_names: bool = false,
        pad0: u26 = 0,
    };
    pub const XIFeature = packed struct(u32) {
        keyboards: bool = false,
        button_actions: bool = false,
        indicator_names: bool = false,
        indicator_maps: bool = false,
        indicator_state: bool = false,
        pad0: u27 = 0,
    };
    pub const PerClientFlag = packed struct(u32) {
        detectable_auto_repeat: bool = false,
        grabs_use_x_k_b_state: bool = false,
        auto_reset_controls: bool = false,
        lookup_state_when_grabbed: bool = false,
        send_event_uses_x_k_b_state: bool = false,
        pad0: u27 = 0,
    };
    pub const ModDef = struct {
        mask: u8,
        real_mods: u8,
        vmods: u16,
    };
    pub const KeyName = struct {
        name: []const u8,
    };
    pub const KeyAlias = struct {
        real: []const u8,
        alias: []const u8,
    };
    pub const CountedString16 = struct {
        length: u16,
        string: []const u8,
    };
    pub const KTMapEntry = struct {
        active: bool,
        mods_mask: u8,
        level: u8,
        mods_mods: u8,
        mods_vmods: u16,
    };
    pub const KeyType = struct {
        mods_mask: u8,
        mods_mods: u8,
        mods_vmods: u16,
        num_levels: u8,
        n_map_entries: u8,
        has_preserve: bool,
        map: []const KTMapEntry,
        preserve: []const ModDef,
    };
    pub const KeySymMap = struct {
        kt_index: []const u8,
        groupInfo: u8,
        width: u8,
        n_syms: u16,
        syms: []const KEYSYM,
    };

    pub const RadioGroupBehavior = struct {
        type: u8,
        group: u8,
    };
    pub const OverlayBehavior = struct {
        type: u8,
        key: KEYCODE,
    };
    pub const Behavior = extern union {
        common: Common,
        default: Default,
        lock: Lock,
        radio_group: RadioGroupBehavior,
        overlay1: OverlayBehavior,
        overlay2: OverlayBehavior,
        // permament_lock: PermamentLockBehavior,
        // permament_radio_group: PermamentRadioGroupBehavior,
        // permament_overlay1: PermamentOverlayBehavior,
        // permament_overlay2: PermamentOverlayBehavior,
        type: Type,

        pub const Type = enum(u8) {
            default = 0,
            lock = 1,
            radio_group = 2,
            overlay1 = 3,
            overlay2 = 4,
            permament_lock = 129,
            permament_radio_group = 130,
            permament_overlay1 = 131,
            permament_overlay2 = 132,
        };

        pub const Common = struct {
            type: u8,
            data: u8,
        };
        pub const Default = struct {
            type: u8,
        };
        pub const Lock = enum(u8) {
            never,
            always,
            latch,
            lock,
            toggle,
        };
    };
    pub const SetBehavior = struct {
        keycode: KEYCODE,
        behavior: Behavior,
    };
    pub const SetExplicit = struct {
        keycode: KEYCODE,
        explicit: u8,
    };
    pub const KeyModMap = struct {
        keycode: KEYCODE,
        mods: u8,
    };
    pub const KeyVModMap = struct {
        keycode: KEYCODE,
        vmods: u16,
    };
    pub const KTSetMapEntry = struct {
        level: u8,
        real_mods: u8,
        virtual_mods: u16,
    };
    pub const SetKeyType = struct {
        mask: u8,
        real_mods: u8,
        virtual_mods: u16,
        num_levels: u8,
        n_map_entries: u8,
        preserve: bool,
        entries: []const KTSetMapEntry,
        preserve_entries: []const KTSetMapEntry,
    };
    pub const Outline = struct {
        n_points: u8,
        corner_radius: u8,
        points: []const Point,
    };
    pub const Shape = struct {
        name: Atom,
        n_outlines: u8,
        primary_ndx: u8,
        approx_ndx: u8,
        outlines: []const Outline,
    };
    pub const Key = struct {
        name: []const u8,
        gap: i16,
        shape_ndx: u8,
        color_ndx: u8,
    };
    pub const OverlayKey = struct {
        over: []const u8,
        under: []const u8,
    };
    pub const OverlayRow = struct {
        row_under: u8,
        n_keys: u8,
        keys: []const OverlayKey,
    };
    pub const Overlay = struct {
        name: Atom,
        n_rows: u8,
        rows: []const OverlayRow,
    };
    pub const Row = struct {
        top: i16,
        left: i16,
        n_keys: u8,
        vertical: bool,
        keys: []const Key,
    };
    pub const DoodadType = enum(u32) {
        outline = 1,
        solid = 2,
        text = 3,
        indicator = 4,
        logo = 5,
    };
    pub const Listing = struct {
        flags: u16,
        length: u16,
        string: []const u8,
    };
    pub const LedClassSpec = struct {
        deviceSpec: DeviceSpec,
        ledClass: LedClass,
        ledID: u8,
    };
    pub const DeviceLedInfo = struct {
        led_class: LedClassSpec,
        led_id: u8,
        names_present: u32,
        maps_present: u32,
        phys_indicators: u32,
        state: u32,
        names: []const Atom,
        maps: []const IndicatorMap,
    };
    pub const Error = enum(u32) {
        bad_device = 255,
        bad_class = 254,
        bad_id = 253,
    };
    pub const Keyboard = struct {
        value: u32,
        minor_opcode: u16,
        major_opcode: u8,
    };
    pub const SA = packed struct(u32) {
        clear_locks: bool = false,
        latch_to_lock: bool = false,
        use_mod_map_mods: bool = false,
        group_absolute: bool = false,
        pad0: u28 = 0,

        pub const Type = enum(u32) {
            no_action = 0,
            set_mods = 1,
            latch_mods = 2,
            lock_mods = 3,
            set_group = 4,
            latch_group = 5,
            lock_group = 6,
            move_ptr = 7,
            ptr_btn = 8,
            lock_ptr_btn = 9,
            set_ptr_dflt = 10,
            i_s_o_lock = 11,
            terminate = 12,
            switch_screen = 13,
            set_controls = 14,
            lock_controls = 15,
            action_message = 16,
            redirect_key = 17,
            device_btn = 18,
            lock_device_btn = 19,
            device_valuator = 20,
        };
        pub const NoAction = struct {
            u8: type,
        };
        pub const SetMods = struct {
            type: u8,
            flags: u8,
            mask: u8,
            real_mods: u8,
            vmods_high: u8,
            vmods_low: u8,
        };
        pub const SetGroup = struct {
            type: u8,
            flags: u8,
            group: i8,
        };
        pub const MovePtrFlag = packed struct(u32) {
            no_acceleration: bool = false,
            move_absolute_x: bool = false,
            move_absolute_y: bool = false,
            pad0: u29 = 0,
        };
        pub const MovePtr = struct {
            type: u8,
            flags: u8,
            x_high: i8,
            x_low: u8,
            y_high: i8,
            y_low: u8,
        };
        pub const PtrBtn = struct {
            type: u8,
            flags: u8,
            count: u8,
            button: u8,
        };
        pub const LockPtrBtn = struct {
            type: u8,
            flags: u8,
            button: u8,
        };
        pub const SetPtrDfltFlag = packed struct(u32) {
            dflt_btn_absolute: bool = false,
            affect_dflt_button: bool = false,
            pad0: u32 = 0,
        };
        pub const SetPtrDflt = struct {
            type: u8,
            flags: u8,
            affect: u8,
            value: i8,
        };
        pub const IsoLockFlag = packed struct(u32) {
            no_lock: bool = false,
            no_unlock: bool = false,
            use_mod_map_mods: bool = false,
            group_absolute: bool = false,
            iso_dflt_is_group: bool = false,
            pad0: u27 = 0,
        };
        pub const IsoLockNoAffect = packed struct(u32) {
            ctrls: bool = false,
            ptr: bool = false,
            group: bool = false,
            mods: bool = false,
            pad0: u28 = 0,
        };
        pub const IsoLock = struct {
            type: u8,
            flags: u8,
            mask: u8,
            real_mods: u8,
            group: u8,
            affect: u8,
            vmods_high: u8,
            vmods_low: u8,
        };
        pub const Terminate = struct {
            type: u8,
        };
        pub const SwitchScreenFlag = packed struct(u32) {
            application: bool = false,
            absolute: bool = false,
            pad0: u32 = 0,
        };
        pub const SwitchScreen = struct {
            type: u8,
            flags: u8,
            new_screen: i8,
        };
        pub const SetControls = struct {
            type: u8,
            boolCtrlsHigh: u8,
            boolCtrlsLow: u8,
        };

        pub const ActionMessage = struct {
            type: u8,
            flags: u8,
            message: []const u8,
        };
        pub const RedirectKey = struct {
            type: u8,
            newkey: KEYCODE,
            mask: u8,
            real_modifiers: u8,
            vmods_mask_high: u8,
            vmods_mask_low: u8,
            vmods_high: u8,
            vmods_low: u8,
        };
        pub const DeviceBtn = struct {
            type: u8,
            flags: u8,
            count: u8,
            button: u8,
            device: u8,
        };
        pub const LockDeviceBtn = struct {
            type: u8,
            flags: u8,
            button: u8,
            device: u8,
        };
        pub const ValWhat = enum(u32) {
            ignore_val = 0,
            set_val_min = 1,
            set_val_center = 2,
            set_val_max = 3,
            set_val_relative = 4,
            set_val_absolute = 5,
        };
        pub const DeviceValuator = struct {
            type: u8,
            device: u8,
            val1what: u8,
            val1index: u8,
            val1value: u8,
            val2what: u8,
            val2index: u8,
            val2value: u8,
        };
    };

    pub const BoolCtrlsHigh = packed struct(u32) {
        access_x_feedback: bool = false,
        audible_bell: bool = false,
        overlay1: bool = false,
        overlay2: bool = false,
        ignore_group_lock: bool = false,
        pad0: u27 = 0,
    };
    pub const BoolCtrlsLow = packed struct(u32) {
        repeat_keys: bool = false,
        slow_keys: bool = false,
        bounce_keys: bool = false,
        sticky_keys: bool = false,
        mouse_keys: bool = false,
        mouse_keys_accel: bool = false,
        access_x_keys: bool = false,
        access_x_timeout: bool = false,
        pad0: u26 = 0,
    };
    // unknown start typedef
    // unknown end typedef
    pub const ActionMessageFlag = packed struct(u32) {
        on_press: bool = false,
        on_release: bool = false,
        gen_key_event: bool = false,
        pad0: u29 = 0,
    };
    pub const LockDeviceFlags = packed struct(u32) {
        no_lock: bool = false,
        no_unlock: bool = false,
        pad0: u30 = 0,
    };

    pub const SIAction = struct {
        type: u8,
        data: []const u8,
    };
    pub const SymInterpret = struct {
        sym: KEYSYM,
        mods: u8,
        match: u8,
        virtual_mod: u8,
        flags: u8,
        action: SIAction,
    };
    pub const Action = extern union {
        noaction: SA.NoAction,
        setmods: SA.SetMods,
        latchmods: SA.LatchMods,
        lockmods: SA.LockMods,
        setgroup: SA.SetGroup,
        latchgroup: SA.LatchGroup,
        lockgroup: SA.LockGroup,
        moveptr: SA.MovePtr,
        ptrbtn: SA.PtrBtn,
        lockptrbtn: SA.LockPtrBtn,
        setptrdflt: SA.SetPtrDflt,
        isolock: SA.IsoLock,
        terminate: SA.Terminate,
        switchscreen: SA.SwitchScreen,
        setcontrols: SA.SetControls,
        lockcontrols: SA.LockControls,
        message: SA.ActionMessage,
        redirect: SA.RedirectKey,
        devbtn: SA.DeviceBtn,
        lockdevbtn: SA.LockDeviceBtn,
        devval: SA.DeviceValuator,
        type: u8,
    };
    pub const UseExtension = struct { // opcode 0
        wanted_major: u16,
        wanted_minor: u16,
        pub const Reply = struct {
            supported: bool,
            server_major: u16,
            server_minor: u16,
        };
    };
    pub const SelectEvents = struct { // opcode 1
        device_spec: DeviceSpec,
        affect_which: u16,
        clear: u16,
        select_all: u16,
        affect_map: u16,
        map: u16,
        affect_new_keyboard: u16,
        new_keyboard_details: u16,
        affect_state: u16,
        state_details: u16,
        affect_ctrls: u32,
        ctrl_details: u32,
        affect_indicator_state: u32,
        indicator_state_details: u32,
        affect_indicator_map: u32,
        indicator_map_details: u32,
        affect_names: u16,
        names_details: u16,
        affect_compat: u8,
        compat_details: u8,
        affect_bell: u8,
        bell_details: u8,
        affect_msg_details: u8,
        msg_details: u8,
        affect_access_x: u16,
        access_x_details: u16,
        affect_ext_dev: u16,
        extdev_details: u16,
    };
    pub const Bell = struct { // opcode 3
        device_spec: DeviceSpec,
        bell_class: Class,
        bell_id: u8,
        percent: i8,
        force_sound: bool,
        event_only: bool,
        pitch: i16,
        duration: i16,
        name: Atom,
        window: Window,

        pub const ClassSpec = struct {
            device_spec: DeviceSpec,
            bell_class: Class,
            bell_id: u8,
        };

        pub const Class = enum(u8) {
            kbd_feedback_class = 0,
            ptr_feedback_class = 1,
            string_feedback_class = 2,
            integer_feedback_class = 3,
            led_feedback_class = 4,
        };
    };
    pub const GetState = struct { // opcode 4
        device_spec: DeviceSpec,
        pub const Reply = struct {
            device_id: u8,
            mods: u8,
            base_mods: u8,
            latched_mods: u8,
            locked_mods: u8,
            group: u8,
            locked_group: u8,
            base_group: i16,
            latched_group: i16,
            compat_state: u8,
            grab_mods: u8,
            compat_grab_mods: u8,
            lookup_mods: u8,
            compat_lookup_mods: u8,
            ptr_btn_state: u16,
        };
    };
    pub const LatchLockState = struct { // opcode 5
        device_spec: DeviceSpec,
        affect_mod_locks: u8,
        mod_locks: u8,
        lock_group: bool,
        group_lock: u8,
        affect_mod_latches: u8,
        latch_group: bool,
        group_latch: u16,
    };
    pub const GetControls = struct { // opcode 6
        device_spec: DeviceSpec,
        pub const Reply = struct {
            device_id: u8,
            mouse_keys_dflt_btn: u8,
            num_groups: u8,
            groups_wrap: u8,
            internal_mods_mask: u8,
            ignore_lock_mods_mask: u8,
            internal_mods_real_mods: u8,
            ignore_lock_mods_real_mods: u8,
            internal_mods_vmods: u16,
            ignore_lock_mods_vmods: u16,
            repeat_delay: u16,
            repeat_interval: u16,
            slow_keys_delay: u16,
            debounce_delay: u16,
            mouse_keys_delay: u16,
            mouse_keys_interval: u16,
            mouse_keys_time_to_max: u16,
            mouse_keys_max_speed: u16,
            mouse_keys_curve: i16,
            access_x_option: u16,
            access_x_timeout: u16,
            access_x_timeout_options_mask: u16,
            access_x_timeout_options_values: u16,
            access_x_timeout_mask: u32,
            access_x_timeout_values: u32,
            enabled_controls: u32,
            per_key_repeat: []const u8,
        };
    };
    pub const SetControls = struct { // opcode 7
        device_spec: DeviceSpec,
        affect_internal_real_mods: u8,
        internal_real_mods: u8,
        affect_ignore_lock_real_mods: u8,
        ignore_lock_real_mods: u8,
        affect_internal_virtual_mods: u16,
        internal_virtual_mods: u16,
        affect_ignore_lock_virtual_mods: u16,
        ignore_lock_virtual_mods: u16,
        mouse_keys_dflt_btn: u8,
        groups_wrap: u8,
        access_x_options: u16,
        affect_enabled_controls: u32,
        enabled_controls: u32,
        change_controls: u32,
        repeat_delay: u16,
        repeat_interval: u16,
        slow_keys_delay: u16,
        debounce_delay: u16,
        mouse_keys_delay: u16,
        mouse_keys_interval: u16,
        mouse_keys_time_to_max: u16,
        mouse_keys_max_speed: u16,
        mouse_keys_curve: i16,
        access_x_timeout: u16,
        access_x_timeout_mask: u32,
        access_x_timeout_values: u32,
        access_x_timeout_options_mask: u16,
        access_x_timeout_options_values: u16,
        per_key_repeat: []const u8,
    };
    pub const GetMap = struct { // opcode 8
        device_spec: DeviceSpec,
        full: u16,
        partial: u16,
        first_type: u8,
        n_types: u8,
        first_key_sym: KEYCODE,
        n_key_syms: u8,
        first_key_action: KEYCODE,
        n_key_actions: u8,
        first_key_behavior: KEYCODE,
        n_key_behaviors: u8,
        virtual_mods: u16,
        first_key_explicit: KEYCODE,
        n_key_explicit: u8,
        first_mod_map_key: KEYCODE,
        n_mod_map_keys: u8,
        first_v_mod_map_key: KEYCODE,
        n_v_mod_map_keys: u8,
        pub const Reply = struct {
            device_id: u8,
            min_key_code: KEYCODE,
            max_key_code: KEYCODE,
            present: u16,
            first_type: u8,
            n_types: u8,
            total_types: u8,
            first_key_sym: KEYCODE,
            total_syms: u16,
            n_key_syms: u8,
            first_key_action: KEYCODE,
            total_actions: u16,
            n_key_actions: u8,
            first_key_behavior: KEYCODE,
            n_key_behaviors: u8,
            total_key_behaviors: u8,
            first_key_explicit: KEYCODE,
            n_key_explicit: u8,
            total_key_explicit: u8,
            first_mod_map_key: KEYCODE,
            n_mod_map_keys: u8,
            total_mod_map_keys: u8,
            first_v_mod_map_key: KEYCODE,
            n_v_mod_map_keys: u8,
            total_v_mod_map_keys: u8,
            virtual_mods: u16,
            types_rtrn: []const KeyType,
            syms_rtrn: []const KeySymMap,
            acts_rtrn_count: []const u8,
            acts_rtrn_acts: []const Action,
            behaviors_rtrn: []const SetBehavior,
            vmods_rtrn: []const u8,
            explicit_rtrn: []const SetExplicit,
            modmap_rtrn: []const KeyModMap,
            vmodmap_rtrn: []const KeyVModMap,
        };
    };
    pub const SetMap = struct { // opcode 9
        device_spec: DeviceSpec,
        present: u16,
        flags: u16,
        min_key_code: KEYCODE,
        max_key_code: KEYCODE,
        first_type: u8,
        n_types: u8,
        first_key_sym: KEYCODE,
        n_key_syms: u8,
        total_syms: u16,
        first_key_action: KEYCODE,
        n_key_actions: u8,
        total_actions: u16,
        first_key_behavior: KEYCODE,
        n_key_behaviors: u8,
        total_key_behaviors: u8,
        first_key_explicit: KEYCODE,
        n_key_explicit: u8,
        total_key_explicit: u8,
        first_mod_map_key: KEYCODE,
        n_mod_map_keys: u8,
        total_mod_map_keys: u8,
        first_v_mod_map_key: KEYCODE,
        n_v_mod_map_keys: u8,
        total_v_mod_map_keys: u8,
        virtual_mods: u16,
        types: []const SetKeyType,
        syms: []const KeySymMap,
        actions_count: []const u8,
        actions: []const Action,
        behaviors: []const SetBehavior,
        vmods: []const u8,
        explicit: []const SetExplicit,
        modmap: []const KeyModMap,
        vmodmap: []const KeyVModMap,
    };
    pub const GetCompatMap = struct { // opcode 10
        device_spec: DeviceSpec,
        groups: u8,
        get_all_si: bool,
        first_si: u16,
        n_si: u16,
        pub const Reply = struct {
            device_id: u8,
            groups_rtrn: u8,
            first_si_rtrn: u16,
            n_si_rtrn: u16,
            n_total_si: u16,
            si_rtrn: []const SymInterpret,
            group_rtrn: []const ModDef,
            // unknown start popcount
            // unknown end popcount
        };
    };
    pub const SetCompatMap = struct { // opcode 11
        device_spec: DeviceSpec,
        recompute_actions: bool,
        truncate_si: bool,
        groups: u8,
        first_si: u16,
        n_si: u16,
        si: []const SymInterpret,
        group_maps: []const ModDef,
    };
    pub const GetIndicatorState = struct { // opcode 12
        device_spec: DeviceSpec,
        pub const Reply = struct {
            device_id: u8,
            state: u32,
        };
    };
    pub const GetIndicatorMap = struct { // opcode 13
        device_spec: DeviceSpec,
        which: u32,
        pub const Reply = struct {
            device_id: u8,
            which: u32,
            real_indicators: u32,
            n_indicators: u8,
            maps: []const IndicatorMap,
            // unknown start popcount
            // unknown end popcount
        };
    };
    pub const SetIndicatorMap = struct { // opcode 14
        device_spec: DeviceSpec,
        which: u32,
        maps: []const IndicatorMap,
        // unknown start popcount
        // unknown end popcount
    };
    pub const GetNamedIndicator = struct { // opcode 15
        device_spec: DeviceSpec,
        led_class: LedClassSpec,
        led_id: u8,
        indicator: Atom,
        pub const Reply = struct {
            device_id: u8,
            indicator: Atom,
            found: bool,
            on: bool,
            real_indicator: bool,
            ndx: u8,
            map_flags: u8,
            map_which_groups: u8,
            map_groups: u8,
            map_which_mods: u8,
            map_mods: u8,
            map_real_mods: u8,
            map_vmod: u16,
            map_ctrls: u32,
            supported: bool,
        };
    };
    pub const SetNamedIndicator = struct { // opcode 16
        device_spec: DeviceSpec,
        led_class: LedClassSpec,
        led_id: u8,
        indicator: Atom,
        set_state: bool,
        on: bool,
        set_map: bool,
        create_map: bool,
        map_flags: u8,
        map_which_groups: u8,
        map_groups: u8,
        map_which_mods: u8,
        map_real_mods: u8,
        map_vmods: u16,
        map_ctrls: u32,
    };
    pub const GetNames = struct { // opcode 17
        device_spec: DeviceSpec,
        which: u32,
        pub const Reply = struct {
            device_id: u8,
            which: u32,
            min_key_code: KEYCODE,
            max_key_code: KEYCODE,
            n_types: u8,
            group_names: u8,
            virtual_mods: u16,
            first_key: KEYCODE,
            n_keys: u8,
            indicators: u32,
            n_radio_groups: u8,
            n_key_aliases: u8,
            n_kt_levels: u16,
            keycodes_name: Atom,
            geometry_name: Atom,
            symbols_name: Atom,
            phys_symbols_name: Atom,
            types_name: Atom,
            compat_name: Atom,
            type_names: []const Atom,
            n_levels_per_type: []const u8,
            kt_level_names: []const Atom,
            indicator_names: []const Atom,
            virtual_mod_names: []const Atom,
            groups: []const Atom,
            key_names: []const KeyName,
            key_aliases: []const KeyAlias,
            radio_group_names: []const Atom,
        };
    };
    pub const SetNames = struct { // opcode 18
        device_spec: DeviceSpec,
        virtual_mods: u16,
        which: u32,
        first_type: u8,
        n_types: u8,
        first_kt_levelt: u8,
        n_kt_levels: u8,
        indicators: u32,
        group_names: u8,
        n_radio_groups: u8,
        first_key: KEYCODE,
        n_keys: u8,
        n_key_aliases: u8,
        total_kt_level_names: u16,
        keycodes_name: Atom,
        geometry_name: Atom,
        symbols_name: Atom,
        phys_symbols_name: Atom,
        types_name: Atom,
        compat_name: Atom,
        type_names: []const Atom,
        n_levels_per_type: []const u8,
        kt_level_names: []const Atom,
        indicator_names: []const Atom,
        virtual_mod_names: []const Atom,
        groups: []const Atom,
        key_names: []const KeyName,
        key_aliases: []const KeyAlias,
        radio_group_names: []const Atom,
    };
    pub const PerClientFlags = struct { // opcode 21
        device_spec: DeviceSpec,
        change: u32,
        value: u32,
        ctrls_to_change: u32,
        auto_ctrls: u32,
        auto_ctrls_values: u32,
        pub const Reply = struct {
            device_id: u8,
            supported: u32,
            value: u32,
            auto_ctrls: u32,
            auto_ctrls_values: u32,
        };
    };
    pub const ListComponents = struct { // opcode 22
        device_spec: DeviceSpec,
        max_names: u16,
        pub const Reply = struct {
            device_id: u8,
            n_keymaps: u16,
            n_keycodes: u16,
            n_types: u16,
            n_compat_maps: u16,
            n_symbols: u16,
            n_geometries: u16,
            extra: u16,
            keymaps: []const Listing,
            keycodes: []const Listing,
            types: []const Listing,
            compatMaps: []const Listing,
            symbols: []const Listing,
            geometries: []const Listing,
        };
    };
    pub const GetKbdByName = struct { // opcode 23
        device_spec: DeviceSpec,
        need: u16,
        want: u16,
        load: bool,
        pub const Reply = struct {
            device_id: u8,
            min_key_code: KEYCODE,
            max_key_code: KEYCODE,
            loaded: bool,
            new_keyboard: bool,
            found: u16,
            reported: u16,
            getmap_type: u8,
            type_device_id: u8,
            getmap_sequence: u16,
            getmap_length: u32,
            type_min_key_code: KEYCODE,
            type_max_key_code: KEYCODE,
            present: u16,
            first_type: u8,
            n_types: u8,
            total_types: u8,
            first_key_sym: KEYCODE,
            total_syms: u16,
            n_key_syms: u8,
            first_key_action: KEYCODE,
            total_actions: u16,
            n_key_actions: u8,
            first_key_behavior: KEYCODE,
            n_key_behaviors: u8,
            total_key_behaviors: u8,
            first_key_explicit: KEYCODE,
            n_key_explicit: u8,
            total_key_explicit: u8,
            first_mod_map_key: KEYCODE,
            n_mod_map_keys: u8,
            total_mod_map_keys: u8,
            first_v_mod_map_key: KEYCODE,
            n_v_mod_map_keys: u8,
            total_v_mod_map_keys: u8,
            virtual_mods2: u16,
            types_rtrn: []const KeyType,
            syms_rtrn: []const KeySymMap,
            acts_rtrn_count: []const u8,
            acts_rtrn_acts: []const Action,
            behaviors_rtrn: []const SetBehavior,
            vmods_rtrn: []const u8,
            explicit_rtrn: []const SetExplicit,
            modmap_rtrn: []const KeyModMap,
            vmodmap_rtrn: []const KeyVModMap,
            compatmap_type: u8,
            compat_device_id: u8,
            compatmap_sequence: u16,
            compatmap_length: u32,
            groups_rtrn: u8,
            first_si_rtrn: u16,
            n_si_rtrn: u16,
            n_total_si: u16,
            si_rtrn: []const SymInterpret,
            group_rtrn: []const ModDef,
            indicatormap_type: u8,
            indicatorDeviceID: u8,
            indicatormap_sequence: u16,
            indicatormap_length: u32,
            which2: u32,
            realIndicators: u32,
            nIndicators: u8,
            maps: []const IndicatorMap,
            keyname_type: u8,
            keyDeviceID: u8,
            keyname_sequence: u16,
            keyname_length: u32,
            which: u32,
            keyMinKeyCode: KEYCODE,
            keyMaxKeyCode: KEYCODE,
            nTypes: u8,
            group_names: u8,
            virtual_mods: u16,
            first_key: KEYCODE,
            n_keys: u8,
            indicators: u32,
            n_radio_groups: u8,
            n_key_aliases2: u8,
            n_kt_levels: u16,
            keycodes_name: Atom,
            geometry_name: Atom,
            symbols_name: Atom,
            phys_symbols_name: Atom,
            types_name: Atom,
            compat_name: Atom,
            type_names: []const Atom,
            n_levels_per_type: []const u8,
            kt_level_names: []const Atom,
            indicator_names: []const Atom,
            virtual_mod_names: []const Atom,
            groups: []const Atom,
            key_names: []const KeyName,
            key_aliases: []const KeyAlias,
            radio_group_names: []const Atom,
            geometry_type: u8,
            geometry_device_id: u8,
            geometry_sequence: u16,
            geometry_length: u32,
            name: Atom,
            geometry_found: bool,
            width_mm: u16,
            height_mm: u16,
            n_properties: u16,
            n_colors: u16,
            n_shapes: u16,
            n_sections: u16,
            n_doodads: u16,
            n_key_aliases: u16,
            base_color_ndx: u8,
            label_color_ndx: u8,
            label_font: CountedString16,
        };
    };
    pub const GetDeviceInfo = struct { // opcode 24
        device_spec: DeviceSpec,
        wanted: u16,
        all_buttons: bool,
        first_button: u8,
        n_buttons: u8,
        led_class: LedClassSpec,
        led_id: u8,
        pub const Reply = struct {
            device_id: u8,
            present: u16,
            supported: u16,
            unsupported: u16,
            n_device_led_f_bs: u16,
            first_btn_wanted: u8,
            n_btns_wanted: u8,
            first_btn_rtrn: u8,
            n_btns_rtrn: u8,
            total_btns: u8,
            has_own_state: bool,
            dflt_kbd_fb: u16,
            dflt_led_fb: u16,
            dev_type: Atom,
            name_len: u16,
            name: []const u8,
            btnActions: []const Action,
            leds: []const DeviceLedInfo,
        };
    };
    pub const SetDeviceInfo = struct { // opcode 25
        device_spec: DeviceSpec,
        first_btn: u8,
        n_btns: u8,
        change: u16,
        n_device_led_f_bs: u16,
        btn_actions: []const Action,
        leds: []const DeviceLedInfo,
    };
    pub const SetDebuggingFlags = struct { // opcode 101
        msg_length: u16,
        affect_flags: u32,
        flags: u32,
        affect_ctrls: u32,
        ctrls: u32,
        message: []const u8,
        pub const Reply = struct {
            current_flags: u32,
            current_ctrls: u32,
            supported_flags: u32,
            supported_ctrls: u32,
        };
    };
    pub const NewKeyboardNotify = struct {
        xkb_type: u8,
        time: u32,
        device_id: u8,
        old_device_id: u8,
        min_key_code: KEYCODE,
        max_key_code: KEYCODE,
        old_min_key_code: KEYCODE,
        old_max_key_code: KEYCODE,
        request_major: u8,
        request_minor: u8,
        changed: u16,
    };
    pub const MapNotify = struct {
        xkb_type: u8,
        time: u32,
        device_id: u8,
        ptr_btn_actions: u8,
        changed: u16,
        min_key_code: KEYCODE,
        max_key_code: KEYCODE,
        first_type: u8,
        n_types: u8,
        first_key_sym: KEYCODE,
        n_key_syms: u8,
        first_key_act: KEYCODE,
        n_key_acts: u8,
        first_key_behavior: KEYCODE,
        n_key_behavior: u8,
        first_key_explicit: KEYCODE,
        n_key_explicit: u8,
        first_mod_map_key: KEYCODE,
        n_mod_map_keys: u8,
        first_v_mod_map_key: KEYCODE,
        n_v_mod_map_keys: u8,
        virtual_mods: u16,
    };
    pub const StateNotify = struct {
        xkb_type: u8,
        time: u32,
        device_id: u8,
        mods: u8,
        base_mods: u8,
        latched_mods: u8,
        locked_mods: u8,
        group: u8,
        base_group: i16,
        latched_group: i16,
        locked_group: u8,
        compat_state: u8,
        grab_mods: u8,
        compat_grab_mods: u8,
        lookup_mods: u8,
        compat_loockup_mods: u8,
        ptr_btn_state: u16,
        changed: u16,
        keycode: KEYCODE,
        event_type: u8,
        request_major: u8,
        request_minor: u8,
    };
    pub const ControlsNotify = struct {
        xkb_type: u8,
        time: u32,
        device_id: u8,
        num_groups: u8,
        changed_controls: u32,
        enabled_controls: u32,
        enabled_control_changes: u32,
        keycode: KEYCODE,
        event_type: u8,
        request_major: u8,
        request_minor: u8,
    };
    pub const IndicatorStateNotify = struct {
        xkb_type: u8,
        time: u32,
        device_id: u8,
        state: u32,
        state_changed: u32,
    };
    pub const IndicatorMapNotify = struct {
        xkbType: u8,
        time: u32,
        deviceID: u8,
        state: u32,
        mapChanged: u32,
    };
    pub const NamesNotify = struct {
        xkb_type: u8,
        time: u32,
        device_id: u8,
        changed: u16,
        first_type: u8,
        n_types: u8,
        first_level_name: u8,
        n_level_names: u8,
        n_radio_groups: u8,
        n_key_aliases: u8,
        changed_group_names: u8,
        changed_virtual_mods: u16,
        first_key: KEYCODE,
        n_keys: u8,
        changed_indicators: u32,
    };
    pub const CompatMapNotify = struct {
        xkb_type: u8,
        time: u32,
        device_id: u8,
        changed_groups: u8,
        first_si: u16,
        n_si: u16,
        n_total_si: u16,
    };
    pub const BellNotify = struct {
        xkb_type: u8,
        time: u32,
        device_id: u8,
        bell_class: u8,
        bell_id: u8,
        percent: u8,
        pitch: u16,
        duration: u16,
        name: Atom,
        window: Window,
        event_only: bool,
    };
    pub const ActionMessage = struct {
        xkb_type: u8,
        time: u32,
        device_id: u8,
        keycode: KEYCODE,
        press: bool,
        key_event_follows: bool,
        mods: u8,
        group: u8,
        message: []const u8,
    };
    pub const AccessXNotify = struct {
        xkb_type: u8,
        time: u32,
        device_id: u8,
        keycode: KEYCODE,
        detailt: u16,
        slow_keys_delay: u16,
        debounce_delay: u16,
    };
    pub const ExtensionDeviceNotify = struct {
        xkb_type: u8,
        time: u32,
        device_id: u8,
        reason: u16,
        led_class: u16,
        led_id: u16,
        leds_defined: u32,
        led_state: u32,
        first_button: u8,
        n_buttons: u8,
        supported: u16,
        unsupported: u16,
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        use_extension = 0,
        select_events = 1,
        bell = 3,
        get_state = 4,
        latch_lock_state = 5,
        get_controls = 6,
        set_controls = 7,
        get_map = 8,
        set_map = 9,
        get_compat_map = 10,
        set_compat_map = 11,
        get_indicator_state = 12,
        get_indicator_map = 13,
        set_indicator_map = 14,
        get_named_indicator = 15,
        set_named_indicator = 16,
        get_names = 17,
        set_names = 18,
        per_client_flags = 21,
        list_components = 22,
        get_kbd_by_name = 23,
        get_device_info = 24,
        set_device_info = 25,
        set_debugging_flags = 101,
    };
};
pub const ge = struct {
    // unknown start xcb
    pub const QueryVersion = struct { // opcode 0
        client_major_version: u16,
        client_minor_version: u16,
        pub const Reply = struct {
            major_version: u16,
            minor_version: u16,
        };
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
    };
};
pub const xevie = struct {
    // unknown start xcb
    pub const QueryVersion = struct { // opcode 0
        client_major_version: u16,
        client_minor_version: u16,
        pub const Reply = struct {
            server_major_version: u16,
            server_minor_version: u16,
        };
    };
    pub const Start = struct { // opcode 1
        screen: u32,
        pub const Reply = struct {};
    };
    pub const End = struct { // opcode 2
        cmap: u32,
        pub const Reply = struct {};
    };
    pub const Datatype = enum(u32) {
        unmodified = 0,
        modified = 1,
    };
    pub const Event = struct {};
    pub const Send = struct { // opcode 3
        event: Event,
        data_type: u32,
        pub const Reply = struct {};
    };
    pub const SelectInput = struct { // opcode 4
        event_mask: u32,
        pub const Reply = struct {};
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        start = 1,
        end = 2,
        send = 3,
        select_input = 4,
    };
};

pub const xproto = struct {
    // unknown start xcb
    pub const CHAR2B = struct {
        byte1: u8,
        byte2: u8,
    };

    pub const POINT = struct {
        x: i16,
        y: i16,
    };
    pub const RECTANGLE = struct {
        x: i16,
        y: i16,
        width: u16,
        height: u16,
    };
    pub const ARC = struct {
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        angle1: i16,
        angle2: i16,
    };
    pub const FORMAT = struct {
        depth: u8,
        bits_per_pixel: u8,
        scanline_pad: u8,
    };
    pub const VisualClass = enum(u32) {
        static_gray = 0,
        gray_scale = 1,
        static_color = 2,
        pseudo_color = 3,
        true_color = 4,
        direct_color = 5,
    };
    pub const VISUALTYPE = struct {
        visual_id: Visual.Id,
        class: u8,
        bits_per_rgb_value: u8,
        colormap_entries: u16,
        red_mask: u32,
        green_mask: u32,
        blue_mask: u32,
    };
    pub const DEPTH = struct {
        depth: u8,
        visuals_len: u16,
        visuals: []const VISUALTYPE,
    };
    pub const EventMask = packed struct(u32) {
        key_press: bool = false,
        key_release: bool = false,
        button_press: bool = false,
        button_release: bool = false,
        enter_window: bool = false,
        leave_window: bool = false,
        pointer_motion: bool = false,
        pointer_motion_hint: bool = false,
        button1_motion: bool = false,
        button2_motion: bool = false,
        button3_motion: bool = false,
        button4_motion: bool = false,
        button5_motion: bool = false,
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
        color_map_change: bool = false,
        owner_grab_button: bool = false,
    };
    pub const BackingStore = enum(u32) {
        not_useful = 0,
        when_mapped = 1,
        always = 2,
    };
    pub const SCREEN = struct {
        root: Window,
        default_colormap: Colormap,
        white_pixel: u32,
        black_pixel: u32,
        current_input_masks: u32,
        width_in_pixels: u16,
        height_in_pixels: u16,
        width_in_millimeters: u16,
        height_in_millimeters: u16,
        min_installed_maps: u16,
        max_installed_maps: u16,
        root_visual: Visual.Id,
        backing_stores: u8,
        save_unders: bool,
        root_depth: u8,
        allowed_depths_len: u8,
        allowed_depths: []const DEPTH,
    };
    pub const SetupRequest = struct {
        byte_order: u8,
        protocol_major_version: u16,
        protocol_minor_version: u16,
        authorization_protocol_name_len: u16,
        authorization_protocol_data_len: u16,
        authorization_protocol_name: []const u8,
        authorization_protocol_data: []const u8,
    };
    pub const SetupFailed = struct {
        status: u8,
        reason_len: u8,
        protocol_major_version: u16,
        protocol_minor_version: u16,
        length: u16,
        reason: []const u8,
    };
    pub const SetupAuthenticate = struct {
        status: u8,
        length: u16,
        reason: []const u8,
    };
    pub const ImageOrder = enum(u32) {
        l_s_b_first = 0,
        m_s_b_first = 1,
    };
    pub const Setup = struct {
        status: u8,
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
        min_keycode: KEYCODE,
        max_keycode: KEYCODE,
        vendor: []const u8,
        pixmap_formats: []const FORMAT,
        roots: []const SCREEN,
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
        detail: KEYCODE,
        time: u32,
        root: Window,
        event: Window,
        child: Window,
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
        root: Window,
        event: Window,
        child: Window,
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
        root: Window,
        event: Window,
        child: Window,
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
        root: Window,
        event: Window,
        child: Window,
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
        event: Window,
        mode: u8,
    };
    // unknown start eventcopy
    // unknown end eventcopy
    pub const KeymapNotify = struct {
        keys: []const u8,
    };
    pub const Expose = struct {
        window: Window,
        x: u16,
        y: u16,
        width: u16,
        height: u16,
        count: u16,
    };
    pub const GraphicsExposure = struct {
        drawable: Drawable,
        x: u16,
        y: u16,
        width: u16,
        height: u16,
        minor_opcode: u16,
        count: u16,
        major_opcode: u8,
    };
    pub const NoExposure = struct {
        drawable: Drawable,
        minor_opcode: u16,
        major_opcode: u8,
    };
    pub const Visibility = enum(u32) {
        unobscured = 0,
        partially_obscured = 1,
        fully_obscured = 2,
    };
    pub const VisibilityNotify = struct {
        window: Window,
        state: u8,
    };
    pub const CreateNotify = struct {
        parent: Window,
        window: Window,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        border_width: u16,
        override_redirect: bool,
    };
    pub const DestroyNotify = struct {
        event: Window,
        window: Window,
        // unknown start see
        // unknown end see
    };
    pub const UnmapNotify = struct {
        event: Window,
        window: Window,
        from_configure: bool,
        // unknown start see
        // unknown end see
    };
    pub const MapNotify = struct {
        event: Window,
        window: Window,
        override_redirect: bool,
        // unknown start see
        // unknown end see
    };
    pub const MapRequest = struct {
        parent: Window,
        window: Window,
        // unknown start see
        // unknown end see
    };
    pub const ReparentNotify = struct {
        event: Window,
        window: Window,
        parent: Window,
        x: i16,
        y: i16,
        override_redirect: bool,
    };
    pub const ConfigureNotify = struct {
        event: Window,
        window: Window,
        above_sibling: Window,
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
        parent: Window,
        window: Window,
        sibling: Window,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        border_width: u16,
        value_mask: u16,
    };
    pub const GravityNotify = struct {
        event: Window,
        window: Window,
        x: i16,
        y: i16,
    };
    pub const ResizeRequest = struct {
        window: Window,
        width: u16,
        height: u16,
    };
    pub const Place = enum(u32) {
        on_top = 0,
        on_bottom = 1,
    };
    pub const CirculateNotify = struct {
        event: Window,
        window: Window,
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
        window: Window,
        atom: Atom,
        time: u32,
        state: u8,
        // unknown start see
        // unknown end see
    };
    pub const SelectionClear = struct {
        time: u32,
        owner: Window,
        selection: Atom,
    };
    pub const Time = enum(u32) {
        current_time = 0,
    };
    pub const SelectionRequest = struct {
        time: u32,
        owner: Window,
        requestor: Window,
        selection: Atom,
        target: Atom,
        property: Atom,
    };
    pub const SelectionNotify = struct {
        time: u32,
        requestor: Window,
        selection: Atom,
        target: Atom,
        property: Atom,
    };
    pub const ColormapState = enum(u32) {
        uninstalled = 0,
        installed = 1,
    };
    pub const Colormap = enum(u32) {
        none = 0,
    };
    pub const ColormapNotify = struct {
        window: Window,
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
        window: Window,
        type: Atom,
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
        first_keycode: KEYCODE,
        count: u8,
    };
    pub const GeGeneric = struct {};
    pub const Request = struct {
        bad_value: u32,
        minor_opcode: u16,
        major_opcode: u8,
    };
    pub const Value = struct {
        bad_value: u32,
        minor_opcode: u16,
        major_opcode: u8,
    };
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
    // unknown start errorcopy
    // unknown end errorcopy
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
    pub const CreateWindow = struct { // opcode 1
        depth: u8,
        wid: Window,
        parent: Window,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        border_width: u16,
        class: u16,
        visual: Visual.Id,
        value_mask: u32,
        background_pixmap: Pixmap,
        background_pixel: u32,
        border_pixmap: Pixmap,
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
        cursor: Cursor,
    };
    pub const ChangeWindowAttributes = struct { // opcode 2
        window: Window,
        value_mask: u32,
        background_pixmap: Pixmap,
        background_pixel: u32,
        border_pixmap: Pixmap,
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
        cursor: Cursor,
    };
    pub const MapState = enum(u32) {
        unmapped = 0,
        unviewable = 1,
        viewable = 2,
    };
    pub const GetWindowAttributes = struct { // opcode 3
        window: Window,
        pub const Reply = struct {
            backing_store: u8,
            visual: Visual.Id,
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
    pub const DestroyWindow = struct { // opcode 4
        window: Window,
    };
    pub const DestroySubwindows = struct { // opcode 5
        window: Window,
    };
    pub const SetMode = enum(u32) {
        insert = 0,
        delete = 1,
    };
    pub const ChangeSaveSet = struct { // opcode 6
        mode: u8,
        window: Window,
    };
    pub const ReparentWindow = struct { // opcode 7
        window: Window,
        parent: Window,
        x: i16,
        y: i16,
    };
    pub const MapWindow = struct { // opcode 8
        window: Window,
    };
    pub const MapSubwindows = struct { // opcode 9
        window: Window,
    };
    pub const UnmapWindow = struct { // opcode 10
        window: Window,
        // unknown start see
        // unknown end see
        // unknown start see
        // unknown end see
        // unknown start see
        // unknown end see
    };
    pub const UnmapSubwindows = struct { // opcode 11
        window: Window,
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
    pub const StackMode = enum(u32) {
        above = 0,
        below = 1,
        top_if = 2,
        bottom_if = 3,
        opposite = 4,
    };
    pub const ConfigureWindow = struct { // opcode 12
        window: Window,
        value_mask: u16,
        x: i32,
        y: i32,
        width: u32,
        height: u32,
        border_width: u32,
        sibling: Window,
        stack_mode: u32,
    };
    pub const Circulate = enum(u32) {
        raise_lowest = 0,
        lower_highest = 1,
    };
    pub const CirculateWindow = struct { // opcode 13
        direction: u8,
        window: Window,
    };
    pub const GetGeometry = struct { // opcode 14
        drawable: Drawable,
        pub const Reply = struct {
            depth: u8,
            root: Window,
            x: i16,
            y: i16,
            width: u16,
            height: u16,
            border_width: u16,
        };
    };
    pub const QueryTree = struct { // opcode 15
        window: Window,
        pub const Reply = struct {
            root: Window,
            parent: Window,
            children_len: u16,
            children: []const Window,
        };
    };
    pub const InternAtom = struct { // opcode 16
        only_if_exists: bool,
        name_len: u16,
        name: []const u8,
        pub const Reply = struct {
            atom: Atom,
        };
    };
    pub const GetAtomName = struct { // opcode 17
        atom: Atom,
        pub const Reply = struct {
            name_len: u16,
            name: []const u8,
        };
    };
    pub const PropMode = enum(u32) {
        replace = 0,
        prepend = 1,
        append = 2,
    };
    pub const ChangeProperty = struct { // opcode 18
        mode: u8,
        window: Window,
        property: Atom,
        type: Atom,
        format: u8,
        data_len: u32,
        data: []const void,
    };
    pub const DeleteProperty = struct { // opcode 19
        window: Window,
        property: Atom,
    };
    pub const GetPropertyType = enum(u32) {
        any = 0,
    };
    pub const GetProperty = struct { // opcode 20
        delete: bool,
        window: Window,
        property: Atom,
        type: Atom,
        long_offset: u32,
        long_length: u32,
        pub const Reply = struct {
            format: u8,
            type: Atom,
            bytes_after: u32,
            value_len: u32,
            value: []const void,
        };
    };
    pub const ListProperties = struct { // opcode 21
        window: Window,
        pub const Reply = struct {
            atoms_len: u16,
            atoms: []const Atom,
        };
    };
    pub const SetSelectionOwner = struct { // opcode 22
        owner: Window,
        selection: Atom,
        time: u32,
    };
    pub const GetSelectionOwner = struct { // opcode 23
        selection: Atom,
        pub const Reply = struct {
            owner: Window,
        };
    };
    pub const ConvertSelection = struct { // opcode 24
        requestor: Window,
        selection: Atom,
        target: Atom,
        property: Atom,
        time: u32,
    };
    pub const SendEventDest = enum(u32) {
        pointer_window = 0,
        item_focus = 1,
    };
    pub const SendEvent = struct { // opcode 25
        propagate: bool,
        destination: Window,
        event_mask: u32,
        event: []const u8,
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
    pub const Cursor = enum(u32) {
        none = 0,
    };
    pub const GrabPointer = struct { // opcode 26
        owner_events: bool,
        grab_window: Window,
        event_mask: u16,
        pointer_mode: u8,
        keyboard_mode: u8,
        confine_to: Window,
        cursor: Cursor,
        time: u32,
        pub const Reply = struct {
            status: u8,
        };
    };
    pub const UngrabPointer = struct { // opcode 27
        time: u32,
    };
    pub const ButtonIndex = enum(u32) {
        any = 0,
        @"1" = 1,
        @"2" = 2,
        @"3" = 3,
        @"4" = 4,
        @"5" = 5,
    };
    pub const GrabButton = struct { // opcode 28
        owner_events: bool,
        grab_window: Window,
        event_mask: u16,
        pointer_mode: u8,
        keyboard_mode: u8,
        confine_to: Window,
        cursor: Cursor,
        button: u8,
        modifiers: u16,
    };
    pub const UngrabButton = struct { // opcode 29
        button: u8,
        grab_window: Window,
        modifiers: u16,
    };
    pub const ChangeActivePointerGrab = struct { // opcode 30
        cursor: Cursor,
        time: u32,
        event_mask: u16,
    };
    pub const GrabKeyboard = struct { // opcode 31
        owner_events: bool,
        grab_window: Window,
        time: u32,
        pointer_mode: u8,
        keyboard_mode: u8,
        pub const Reply = struct {
            status: u8,
        };
    };
    pub const UngrabKeyboard = struct { // opcode 32
        time: u32,
    };
    pub const Grab = enum(u32) {
        any = 0,
    };
    pub const GrabKey = struct { // opcode 33
        owner_events: bool,
        grab_window: Window,
        modifiers: u16,
        key: KEYCODE,
        pointer_mode: u8,
        keyboard_mode: u8,
    };
    pub const UngrabKey = struct { // opcode 34
        key: KEYCODE,
        grab_window: Window,
        modifiers: u16,
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
    pub const AllowEvents = struct { // opcode 35
        mode: u8,
        time: u32,
        pub const Value = struct {};
    };
    pub const GrabServer = struct { // opcode 36
    };
    pub const UngrabServer = struct { // opcode 37
    };
    pub const QueryPointer = struct { // opcode 38
        window: Window,
        pub const Reply = struct {
            same_screen: bool,
            root: Window,
            child: Window,
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
    pub const GetMotionEvents = struct { // opcode 39
        window: Window,
        start: u32,
        stop: u32,
        pub const Reply = struct {
            events_len: u32,
            events: []const TIMECOORD,
        };
    };
    pub const TranslateCoordinates = struct { // opcode 40
        src_window: Window,
        dst_window: Window,
        src_x: i16,
        src_y: i16,
        pub const Reply = struct {
            same_screen: bool,
            child: Window,
            dst_x: i16,
            dst_y: i16,
        };
    };
    pub const WarpPointer = struct { // opcode 41
        src_window: Window,
        dst_window: Window,
        src_x: i16,
        src_y: i16,
        src_width: u16,
        src_height: u16,
        dst_x: i16,
        dst_y: i16,
    };
    pub const InputFocus = enum(u32) {
        none = 0,
        pointer_root = 1,
        parent = 2,
        follow_keyboard = 3,
    };
    pub const SetInputFocus = struct { // opcode 42
        revert_to: u8,
        focus: Window,
        time: u32,
    };
    pub const GetInputFocus = struct { // opcode 43
        pub const Reply = struct {
            revert_to: u8,
            focus: Window,
        };
    };
    pub const QueryKeymap = struct { // opcode 44
        pub const Reply = struct {
            keys: []const u8,
        };
    };
    pub const OpenFont = struct { // opcode 45
        fid: Font,
        name_len: u16,
        name: []const u8,
    };
    pub const CloseFont = struct { // opcode 46
        font: Font,
    };
    pub const FontDraw = enum(u32) {
        left_to_right = 0,
        right_to_left = 1,
    };
    pub const FONTPROP = struct {
        name: Atom,
        value: u32,
    };
    pub const CHARINFO = struct {
        left_side_bearing: i16,
        right_side_bearing: i16,
        character_width: i16,
        ascent: i16,
        descent: i16,
        attributes: u16,
    };
    pub const QueryFont = struct { // opcode 47
        font: Font.Fontable,
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
    pub const QueryTextExtents = struct { // opcode 48
        font: Font.Fontable,
        string: []const CHAR2B,
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
    pub const STR = struct {
        name_len: u8,
        name: []const u8,
    };
    pub const ListFonts = struct { // opcode 49
        max_names: u16,
        pattern_len: u16,
        pattern: []const u8,
        pub const Reply = struct {
            names_len: u16,
            names: []const STR,
        };
    };
    pub const ListFontsWithInfo = struct { // opcode 50
        max_names: u16,
        pattern_len: u16,
        pattern: []const u8,
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
    pub const SetFontPath = struct { // opcode 51
        font_qty: u16,
        font: []const STR,
    };
    pub const GetFontPath = struct { // opcode 52
        pub const Reply = struct {
            path_len: u16,
            path: []const STR,
        };
    };
    pub const CreatePixmap = struct { // opcode 53
        depth: u8,
        pid: Pixmap,
        drawable: Drawable,
        width: u16,
        height: u16,
    };
    pub const FreePixmap = struct { // opcode 54
        pixmap: Pixmap,
    };
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
    pub const CreateGC = struct { // opcode 55
        cid: GraphicsContext,
        drawable: Drawable,
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
        tile: Pixmap,
        stipple: Pixmap,
        tile_stipple_x_origin: i32,
        tile_stipple_y_origin: i32,
        font: Font,
        subwindow_mode: SubwindowMode,
        graphics_exposures: u32, // bool
        clip_x_origin: i32,
        clip_y_origin: i32,
        clip_mask: Pixmap,
        dash_offset: u32,
        dashes: u32,
        arc_mode: ArcMode,
    };
    pub const ChangeGC = struct { // opcode 56
        graphics_context: GraphicsContext,
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
        tile: Pixmap,
        stipple: Pixmap,
        tile_stipple_x_origin: i32,
        tile_stipple_y_origin: i32,
        font: Font,
        subwindow_mode: u32,
        graphics_exposures: u32, // bool
        clip_x_origin: i32,
        clip_y_origin: i32,
        clip_mask: Pixmap,
        dash_offset: u32,
        dashes: u32,
        arc_mode: u32,
    };
    pub const CopyGC = struct { // opcode 57
        src_gc: GraphicsContext,
        dst_gc: GraphicsContext,
        value_mask: u32,
    };
    pub const SetDashes = struct { // opcode 58
        graphics_context: GraphicsContext,
        dash_offset: u16,
        dashes_len: u16,
        dashes: []const u8,
    };
    pub const ClipOrdering = enum(u32) {
        unsorted = 0,
        y_sorted = 1,
        y_x_sorted = 2,
        y_x_banded = 3,
    };
    pub const SetClipRectangles = struct { // opcode 59
        ordering: u8,
        graphics_context: GraphicsContext,
        clip_x_origin: i16,
        clip_y_origin: i16,
        rectangles: []const RECTANGLE,
    };
    pub const FreeGC = struct { // opcode 60
        graphics_context: GraphicsContext,
        pub const GContext = struct {};
    };
    pub const ClearArea = struct { // opcode 61
        exposures: bool,
        window: Window,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
    };
    pub const CopyArea = struct { // opcode 62
        src_drawable: Drawable,
        dst_drawable: Drawable,
        graphics_context: GraphicsContext,
        src_x: i16,
        src_y: i16,
        dst_x: i16,
        dst_y: i16,
        width: u16,
        height: u16,
    };
    pub const CopyPlane = struct { // opcode 63
        src_drawable: Drawable,
        dst_drawable: Drawable,
        graphics_context: GraphicsContext,
        src_x: i16,
        src_y: i16,
        dst_x: i16,
        dst_y: i16,
        width: u16,
        height: u16,
        bit_plane: u32,
    };
    pub const CoordMode = enum(u32) {
        origin = 0,
        previous = 1,
    };
    pub const PolyPoint = struct { // opcode 64
        coordinate_mode: u8,
        drawable: Drawable,
        graphics_context: GraphicsContext,
        points: []const POINT,
    };
    pub const PolyLine = struct { // opcode 65
        coordinate_mode: u8,
        drawable: Drawable,
        graphics_context: GraphicsContext,
        points: []const POINT,
    };
    pub const SEGMENT = struct {
        x1: i16,
        y1: i16,
        x2: i16,
        y2: i16,
    };
    pub const PolySegment = struct { // opcode 66
        drawable: Drawable,
        graphics_context: GraphicsContext,
        segments: []const SEGMENT,
    };
    pub const PolyRectangle = struct { // opcode 67
        drawable: Drawable,
        graphics_context: GraphicsContext,
        rectangles: []const RECTANGLE,
    };
    pub const PolyArc = struct { // opcode 68
        drawable: Drawable,
        graphics_context: GraphicsContext,
        arcs: []const ARC,
    };
    pub const PolyShape = enum(u32) {
        complex = 0,
        nonconvex = 1,
        convex = 2,
    };
    pub const FillPoly = struct { // opcode 69
        drawable: Drawable,
        graphics_context: GraphicsContext,
        shape: u8,
        coordinate_mode: u8,
        points: []const POINT,
    };
    pub const PolyFillRectangle = struct { // opcode 70
        drawable: Drawable,
        graphics_context: GraphicsContext,
        rectangles: []const RECTANGLE,
    };
    pub const PolyFillArc = struct { // opcode 71
        drawable: Drawable,
        graphics_context: GraphicsContext,
        arcs: []const ARC,
    };
    pub const ImageFormat = enum(u32) {
        x_y_bitmap = 0,
        x_y_pixmap = 1,
        z_pixmap = 2,
    };
    pub const PutImage = struct { // opcode 72
        format: u8,
        drawable: Drawable,
        graphics_context: GraphicsContext,
        width: u16,
        height: u16,
        dst_x: i16,
        dst_y: i16,
        left_pad: u8,
        depth: u8,
        data: []const u8,
    };
    pub const GetImage = struct { // opcode 73
        format: u8,
        drawable: Drawable,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        plane_mask: u32,
        pub const Reply = struct {
            depth: u8,
            visual: Visual.Id,
            data: []const u8,
        };
    };
    pub const PolyText8 = struct { // opcode 74
        drawable: Drawable,
        graphics_context: GraphicsContext,
        x: i16,
        y: i16,
        items: []const u8,
    };
    pub const PolyText16 = struct { // opcode 75
        drawable: Drawable,
        graphics_context: GraphicsContext,
        x: i16,
        y: i16,
        items: []const u8,
    };
    pub const ImageText8 = struct { // opcode 76
        string_len: u8,
        drawable: Drawable,
        graphics_context: GraphicsContext,
        x: i16,
        y: i16,
        string: []const u8,
    };
    pub const ImageText16 = struct { // opcode 77
        string_len: u8,
        drawable: Drawable,
        graphics_context: GraphicsContext,
        x: i16,
        y: i16,
        string: []const CHAR2B,
    };
    pub const ColormapAlloc = enum(u32) {
        none = 0,
        all = 1,
    };
    pub const CreateColormap = struct { // opcode 78
        alloc: u8,
        mid: Colormap,
        window: Window,
        visual: Visual.Id,
    };
    pub const FreeColormap = struct { // opcode 79
        cmap: Colormap,
    };
    pub const CopyColormapAndFree = struct { // opcode 80
        mid: Colormap,
        src_cmap: Colormap,
    };
    pub const InstallColormap = struct { // opcode 81
        cmap: Colormap,
    };
    pub const UninstallColormap = struct { // opcode 82
        cmap: Colormap,
    };
    pub const ListInstalledColormaps = struct { // opcode 83
        window: Window,
        pub const Reply = struct {
            cmaps_len: u16,
            cmaps: []const Colormap,
        };
    };
    pub const AllocColor = struct { // opcode 84
        cmap: Colormap,
        red: u16,
        green: u16,
        blue: u16,
        pub const Reply = struct {
            red: u16,
            green: u16,
            blue: u16,
            pixel: u32,
        };
    };
    pub const AllocNamedColor = struct { // opcode 85
        cmap: Colormap,
        name_len: u16,
        name: []const u8,
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
    pub const AllocColorCells = struct { // opcode 86
        contiguous: bool,
        cmap: Colormap,
        colors: u16,
        planes: u16,
        pub const Reply = struct {
            pixels_len: u16,
            masks_len: u16,
            pixels: []const u32,
            masks: []const u32,
        };
    };
    pub const AllocColorPlanes = struct { // opcode 87
        contiguous: bool,
        cmap: Colormap,
        colors: u16,
        reds: u16,
        greens: u16,
        blues: u16,
        pub const Reply = struct {
            pixels_len: u16,
            red_mask: u32,
            green_mask: u32,
            blue_mask: u32,
            pixels: []const u32,
        };
    };
    pub const FreeColors = struct { // opcode 88
        cmap: Colormap,
        plane_mask: u32,
        pixels: []const u32,
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
    pub const StoreColors = struct { // opcode 89
        cmap: Colormap,
        items: []const COLORITEM,
    };
    pub const StoreNamedColor = struct { // opcode 90
        flags: u8,
        cmap: Colormap,
        pixel: u32,
        name_len: u16,
        name: []const u8,
    };
    pub const RGB = struct {
        red: u16,
        green: u16,
        blue: u16,
    };
    pub const QueryColors = struct { // opcode 91
        cmap: Colormap,
        pixels: []const u32,
        pub const Reply = struct {
            colors_len: u16,
            colors: []const RGB,
        };
    };
    pub const LookupColor = struct { // opcode 92
        cmap: Colormap,
        name_len: u16,
        name: []const u8,
        pub const Reply = struct {
            exact_red: u16,
            exact_green: u16,
            exact_blue: u16,
            visual_red: u16,
            visual_green: u16,
            visual_blue: u16,
        };
    };
    pub const CreateCursor = struct { // opcode 93
        cid: Cursor,
        source: Pixmap,
        mask: Pixmap,
        fore_red: u16,
        fore_green: u16,
        fore_blue: u16,
        back_red: u16,
        back_green: u16,
        back_blue: u16,
        x: u16,
        y: u16,
    };
    pub const Font = enum(u32) {
        none = 0,
        pub const Fontable = u32;
    };
    pub const CreateGlyphCursor = struct { // opcode 94
        cid: Cursor,
        source_font: Font,
        mask_font: Font,
        source_char: u16,
        mask_char: u16,
        fore_red: u16,
        fore_green: u16,
        fore_blue: u16,
        back_red: u16,
        back_green: u16,
        back_blue: u16,
    };
    pub const FreeCursor = struct { // opcode 95
        cursor: Cursor,
    };
    pub const RecolorCursor = struct { // opcode 96
        cursor: Cursor,
        fore_red: u16,
        fore_green: u16,
        fore_blue: u16,
        back_red: u16,
        back_green: u16,
        back_blue: u16,
    };
    pub const QueryShapeOf = enum(u32) {
        largest_cursor = 0,
        fastest_tile = 1,
        fastest_stipple = 2,
    };
    pub const QueryBestSize = struct { // opcode 97
        class: u8,
        drawable: Drawable,
        width: u16,
        height: u16,
        pub const Reply = struct {
            width: u16,
            height: u16,
        };
    };
    pub const QueryExtension = struct { // opcode 98
        name_len: u16,
        name: []const u8,
        pub const Reply = struct {
            present: bool,
            major_opcode: u8,
            first_event: u8,
            first_error: u8,
        };
        // unknown start see
        // unknown end see
        // unknown start see
        // unknown end see
    };
    pub const ListExtensions = struct { // opcode 99
        pub const Reply = struct {
            names_len: u8,
            names: []const STR,
        };
    };
    pub const ChangeKeyboardMapping = struct { // opcode 100
        keycode_count: u8,
        first_keycode: KEYCODE,
        keysyms_per_keycode: u8,
        keysyms: []const KEYSYM,
    };
    pub const GetKeyboardMapping = struct { // opcode 101
        first_keycode: KEYCODE,
        count: u8,
        pub const Reply = struct {
            keysyms_per_keycode: u8,
            keysyms: []const KEYSYM,
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
    pub const ChangeKeyboardControl = struct { // opcode 102
        value_mask: u32,
        key_click_percent: i32,
        bell_percent: i32,
        bell_pitch: i32,
        bell_duration: i32,
        led: u32,
        led_mode: u32,
        key: KEYCODE, // 32
        auto_repeat_mode: u32,
    };
    pub const GetKeyboardControl = struct { // opcode 103
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
    pub const Bell = struct { // opcode 104
        percent: i8,
    };
    pub const ChangePointerControl = struct { // opcode 105
        acceleration_numerator: i16,
        acceleration_denominator: i16,
        threshold: i16,
        do_acceleration: bool,
        do_threshold: bool,
    };
    pub const GetPointerControl = struct { // opcode 106
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
    pub const SetScreenSaver = struct { // opcode 107
        timeout: i16,
        interval: i16,
        prefer_blanking: u8,
        allow_exposures: u8,
    };
    pub const GetScreenSaver = struct { // opcode 108
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
    pub const ChangeHosts = struct { // opcode 109
        mode: u8,
        family: u8,
        address_len: u16,
        address: []const u8,
    };
    pub const HOST = struct {
        family: u8,
        address_len: u16,
        address: []const u8,
    };
    pub const ListHosts = struct { // opcode 110
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
    pub const SetAccessControl = struct { // opcode 111
        mode: u8,
    };
    pub const CloseDown = enum(u32) {
        destroy_all = 0,
        retain_permanent = 1,
        retain_temporary = 2,
    };
    pub const SetCloseDownMode = struct { // opcode 112
        mode: u8,
    };
    pub const Kill = enum(u32) {
        all_temporary = 0,
    };
    pub const KillClient = struct { // opcode 113
        resource: u32,
        pub const Value = struct {};
        // unknown start see
        // unknown end see
    };
    pub const RotateProperties = struct { // opcode 114
        window: Window,
        atoms_len: u16,
        delta: i16,
        atoms: []const Atom,
    };
    pub const ScreenSaver = enum(u32) {
        reset = 0,
        active = 1,
    };
    pub const ForceScreenSaver = struct { // opcode 115
        mode: u8,
    };
    pub const MappingStatus = enum(u32) {
        success = 0,
        busy = 1,
        failure = 2,
    };
    pub const SetPointerMapping = struct { // opcode 116
        map_len: u8,
        map: []const u8,
        pub const Reply = struct {
            status: u8,
        };
    };
    pub const GetPointerMapping = struct { // opcode 117
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
    pub const SetModifierMapping = struct { // opcode 118
        keycodes_per_modifier: u8,
        keycodes: []const KEYCODE,
        pub const Reply = struct {
            status: u8,
        };
    };
    pub const GetModifierMapping = struct { // opcode 119
        pub const Reply = struct {
            keycodes_per_modifier: u8,
            keycodes: []const KEYCODE,
        };
    };
    pub const NoOperation = struct { // opcode 127
    };
    // unknown end xcb
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
};
pub const xf86dri = struct {
    // unknown start xcb
    pub const DrmClipRect = struct {
        x1: i16,
        y1: i16,
        x2: i16,
        x3: i16,
    };
    pub const QueryVersion = struct { // opcode 0
        pub const Reply = struct {
            dri_major_version: u16,
            dri_minor_version: u16,
            dri_minor_patch: u32,
        };
    };
    pub const QueryDirectRenderingCapable = struct { // opcode 1
        screen: u32,
        pub const Reply = struct {
            is_capable: bool,
        };
    };
    pub const OpenConnection = struct { // opcode 2
        screen: u32,
        pub const Reply = struct {
            sarea_handle_low: u32,
            sarea_handle_high: u32,
            bus_id_len: u32,
            bus_id: []const u8,
        };
    };
    pub const CloseConnection = struct { // opcode 3
        screen: u32,
    };
    pub const GetClientDriverName = struct { // opcode 4
        screen: u32,
        pub const Reply = struct {
            client_driver_major_version: u32,
            client_driver_minor_version: u32,
            client_driver_patch_version: u32,
            client_driver_name_len: u32,
            client_driver_name: []const u8,
        };
    };
    pub const CreateContext = struct { // opcode 5
        screen: u32,
        visual: u32,
        context: u32,
        pub const Reply = struct {
            hw_context: u32,
        };
    };
    pub const DestroyContext = struct { // opcode 6
        screen: u32,
        context: u32,
    };
    pub const CreateDrawable = struct { // opcode 7
        screen: u32,
        drawable: u32,
        pub const Reply = struct {
            hw_drawable_handle: u32,
        };
    };
    pub const DestroyDrawable = struct { // opcode 8
        screen: u32,
        drawable: u32,
    };
    pub const GetDrawableInfo = struct { // opcode 9
        screen: u32,
        drawable: u32,
        pub const Reply = struct {
            drawable_table_index: u32,
            drawable_table_stamp: u32,
            drawable_origin_X: i16,
            drawable_origin_Y: i16,
            drawable_size_W: i16,
            drawable_size_H: i16,
            num_clip_rects: u32,
            back_x: i16,
            back_y: i16,
            num_back_clip_rects: u32,
            clip_rects: []const DrmClipRect,
            back_clip_rects: []const DrmClipRect,
        };
    };
    pub const GetDeviceInfo = struct { // opcode 10
        screen: u32,
        pub const Reply = struct {
            framebuffer_handle_low: u32,
            framebuffer_handle_high: u32,
            framebuffer_origin_offset: u32,
            framebuffer_size: u32,
            framebuffer_stride: u32,
            device_private_size: u32,
            device_private: []const u32,
        };
    };
    pub const AuthConnection = struct { // opcode 11
        screen: u32,
        magic: u32,
        pub const Reply = struct {
            authenticated: u32,
        };
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        query_direct_rendering_capable = 1,
        open_connection = 2,
        close_connection = 3,
        get_client_driver_name = 4,
        create_context = 5,
        destroy_context = 6,
        create_drawable = 7,
        destroy_drawable = 8,
        get_drawable_info = 9,
        get_device_info = 10,
        auth_connection = 11,
    };
};
pub const render = struct {
    pub const Picture = enum(u32) {
        none = 0,

        pub const Type = enum(u32) {
            indexed = 0,
            direct = 1,
        };

        pub const Format = u32;

        pub const Operation = enum(u32) {
            clear = 0,
            src = 1,
            dst = 2,
            over = 3,
            over_reverse = 4,
            in = 5,
            in_reverse = 6,
            out = 7,
            out_reverse = 8,
            atop = 9,
            atop_reverse = 10,
            xor = 11,
            add = 12,
            saturate = 13,
            disjoint_clear = 16,
            disjoint_src = 17,
            disjoint_dst = 18,
            disjoint_over = 19,
            disjoint_over_reverse = 20,
            disjoint_in = 21,
            disjoint_in_reverse = 22,
            disjoint_out = 23,
            disjoint_out_reverse = 24,
            disjoint_atop = 25,
            disjoint_atop_reverse = 26,
            disjoint_xor = 27,
            conjoint_clear = 32,
            conjoint_src = 33,
            conjoint_dst = 34,
            conjoint_over = 35,
            conjoint_over_reverse = 36,
            conjoint_in = 37,
            conjoint_in_reverse = 38,
            conjoint_out = 39,
            conjoint_out_reverse = 40,
            conjoint_atop = 41,
            conjoint_atop_reverse = 42,
            conjoint_xor = 43,
            multiply = 48,
            screen = 49,
            overlay = 50,
            darken = 51,
            lighten = 52,
            color_dodge = 53,
            color_burn = 54,
            hard_light = 55,
            soft_light = 56,
            difference = 57,
            exclusion = 58,
            h_s_l_hue = 59,
            h_s_l_saturation = 60,
            h_s_l_color = 61,
            h_s_l_luminosity = 62,
        };
    };
    pub const Glyph = enum(u32) {
        _,
        pub const Set = enum(u32) {
            _,
        };
    };
    pub const poly = struct {
        pub const Edge = enum(u32) {
            sharp = 0,
            smooth = 1,
        };
        pub const Mode = enum(u32) {
            precise = 0,
            imprecise = 1,
        };
    };
    pub const CP = packed struct(u32) {
        repeat: bool = false,
        alpha_map: bool = false,
        alpha_x_origin: bool = false,
        alpha_y_origin: bool = false,
        clip_x_origin: bool = false,
        clip_y_origin: bool = false,
        clip_mask: bool = false,
        graphics_exposure: bool = false,
        subwindow_mode: bool = false,
        poly_edge: bool = false,
        poly_mode: bool = false,
        dither: bool = false,
        component_alpha: bool = false,
        pad0: u19 = 0,
    };
    pub const SubPixel = enum(u32) {
        unknown = 0,
        horizontal_rgb = 1,
        horizontal_bgr = 2,
        vertical_rgb = 3,
        vertical_bgr = 4,
        none = 5,
    };
    pub const Repeat = enum(u32) {
        none = 0,
        normal = 1,
        pad = 2,
        reflect = 3,
    };
    pub const DIRECTFORMAT = struct {
        red_shift: u16,
        red_mask: u16,
        green_shift: u16,
        green_mask: u16,
        blue_shift: u16,
        blue_mask: u16,
        alpha_shift: u16,
        alpha_mask: u16,
    };
    pub const PICTFORMINFO = struct {
        id: Picture.Format,
        type: u8,
        depth: u8,
        direct: DIRECTFORMAT,
        colormap: xproto.Colormap,
    };
    pub const PICTVISUAL = struct {
        visual: Visual.Id,
        format: Picture.Format,
    };
    pub const PICTDEPTH = struct {
        depth: u8,
        num_visuals: u16,
        visuals: []const PICTVISUAL,
    };
    pub const PICTSCREEN = struct {
        num_depths: u32,
        fallback: Picture.Format,
        depths: []const PICTDEPTH,
    };
    pub const INDEXVALUE = struct {
        pixel: u32,
        red: u16,
        green: u16,
        blue: u16,
        alpha: u16,
    };
    pub const COLOR = struct {
        red: u16,
        green: u16,
        blue: u16,
        alpha: u16,
    };
    pub const POINTFIX = struct {
        x: randr.FixedF32,
        y: randr.FixedF32,
    };
    pub const LINEFIX = struct {
        p1: POINTFIX,
        p2: POINTFIX,
    };
    pub const TRIANGLE = struct {
        p1: POINTFIX,
        p2: POINTFIX,
        p3: POINTFIX,
    };
    pub const TRAPEZOID = struct {
        top: randr.FixedF32,
        bottom: randr.FixedF32,
        left: LINEFIX,
        right: LINEFIX,
    };
    pub const GLYPHINFO = struct {
        width: u16,
        height: u16,
        x: i16,
        y: i16,
        x_off: i16,
        y_off: i16,
    };
    pub const QueryVersion = struct { // opcode 0
        client_major_version: u32,
        client_minor_version: u32,
        pub const Reply = struct {
            major_version: u32,
            minor_version: u32,
        };
    };
    pub const QueryPictFormats = struct { // opcode 1
        pub const Reply = struct {
            num_formats: u32,
            num_screens: u32,
            num_depths: u32,
            num_visuals: u32,
            num_subpixel: u32,
            formats: []const PICTFORMINFO,
            screens: []const PICTSCREEN,
            subpixels: []const u32,
        };
    };
    pub const QueryPictIndexValues = struct { // opcode 2
        format: Picture.Format,
        pub const Reply = struct {
            num_values: u32,
            values: []const INDEXVALUE,
        };
    };
    pub const CreatePicture = struct { // opcode 4
        pid: Picture,
        drawable: Drawable,
        format: Picture.Format,
        value_mask: u32,
        repeat: Repeat,
        alphamap: Picture,
        alphaxorigin: i32,
        alphayorigin: i32,
        clipxorigin: i32,
        clipyorigin: i32,
        clipmask: Pixmap,
        graphicsexposure: u32,
        subwindowmode: u32,
        polyedge: u32,
        polymode: u32,
        dither: Atom,
        componentalpha: u32,
    };
    pub const ChangePicture = struct { // opcode 5
        picture: Picture,
        value_mask: u32,
        repeat: Repeat,
        alphamap: Picture,
        alphaxorigin: i32,
        alphayorigin: i32,
        clipxorigin: i32,
        clipyorigin: i32,
        clipmask: Pixmap,
        graphicsexposure: u32,
        subwindowmode: u32,
        polyedge: u32,
        polymode: u32,
        dither: Atom,
        componentalpha: u32,
    };
    pub const SetPictureClipRectangles = struct { // opcode 6
        picture: Picture,
        clip_x_origin: i16,
        clip_y_origin: i16,
        rectangles: []const xproto.RECTANGLE,
    };
    pub const FreePicture = struct { // opcode 7
        picture: Picture,
    };
    pub const Composite = struct { // opcode 8
        op: u8,
        src: Picture,
        mask: Picture,
        dst: Picture,
        src_x: i16,
        src_y: i16,
        mask_x: i16,
        mask_y: i16,
        dst_x: i16,
        dst_y: i16,
        width: u16,
        height: u16,
    };
    pub const Trapezoids = struct { // opcode 10
        op: u8,
        src: Picture,
        dst: Picture,
        mask_format: Picture.Format,
        src_x: i16,
        src_y: i16,
        traps: []const TRAPEZOID,
    };
    pub const Triangles = struct { // opcode 11
        op: u8,
        src: Picture,
        dst: Picture,
        mask_format: Picture.Format,
        src_x: i16,
        src_y: i16,
        triangles: []const TRIANGLE,
    };
    pub const TriStrip = struct { // opcode 12
        op: u8,
        src: Picture,
        dst: Picture,
        mask_format: Picture.Format,
        src_x: i16,
        src_y: i16,
        points: []const POINTFIX,
    };
    pub const TriFan = struct { // opcode 13
        op: u8,
        src: Picture,
        dst: Picture,
        mask_format: Picture.Format,
        src_x: i16,
        src_y: i16,
        points: []const POINTFIX,
    };
    pub const CreateGlyphSet = struct { // opcode 17
        gsid: Glyph.Set,
        format: Picture.Format,
    };
    pub const ReferenceGlyphSet = struct { // opcode 18
        gsid: Glyph.Set,
        existing: Glyph.Set,
    };
    pub const FreeGlyphSet = struct { // opcode 19
        glyphset: Glyph.Set,
    };
    pub const AddGlyphs = struct { // opcode 20
        glyphset: Glyph.Set,
        glyphs_len: u32,
        glyphids: []const u32,
        glyphs: []const GLYPHINFO,
        data: []const u8,
    };
    pub const FreeGlyphs = struct { // opcode 22
        glyphset: Glyph.Set,
        glyphs: []const Glyph,
    };
    pub const CompositeGlyphs8 = struct { // opcode 23
        op: u8,
        src: Picture,
        dst: Picture,
        mask_format: Picture.Format,
        glyphset: Glyph.Set,
        src_x: i16,
        src_y: i16,
        glyphcmds: []const u8,
    };
    pub const CompositeGlyphs16 = struct { // opcode 24
        op: u8,
        src: Picture,
        dst: Picture,
        mask_format: Picture.Format,
        glyphset: Glyph.Set,
        src_x: i16,
        src_y: i16,
        glyphcmds: []const u8,
    };
    pub const CompositeGlyphs32 = struct { // opcode 25
        op: u8,
        src: Picture,
        dst: Picture,
        mask_format: Picture.Format,
        glyphset: Glyph.Set,
        src_x: i16,
        src_y: i16,
        glyphcmds: []const u8,
    };
    pub const FillRectangles = struct { // opcode 26
        op: u8,
        dst: Picture,
        color: COLOR,
        rects: []const xproto.RECTANGLE,
    };
    pub const CreateCursor = struct { // opcode 27
        cid: xproto.Cursor,
        source: Picture,
        x: u16,
        y: u16,
    };
    pub const TRANSFORM = struct {
        matrix11: randr.FixedF32,
        matrix12: randr.FixedF32,
        matrix13: randr.FixedF32,
        matrix21: randr.FixedF32,
        matrix22: randr.FixedF32,
        matrix23: randr.FixedF32,
        matrix31: randr.FixedF32,
        matrix32: randr.FixedF32,
        matrix33: randr.FixedF32,
    };
    pub const SetPictureTransform = struct { // opcode 28
        picture: Picture,
        transform: TRANSFORM,
    };
    pub const QueryFilters = struct { // opcode 29
        drawable: Drawable,
        pub const Reply = struct {
            num_aliases: u32,
            num_filters: u32,
            aliases: []const u16,
            filters: []const u8,
        };
    };
    pub const SetPictureFilter = struct { // opcode 30
        picture: Picture,
        filter_len: u16,
        filter: []const u8,
        values: []const randr.FixedF32,
    };
    pub const ANIMCURSORELT = struct {
        cursor: xproto.Cursor,
        delay: u32,
    };
    pub const CreateAnimCursor = struct { // opcode 31
        cid: xproto.Cursor,
        cursors: []const ANIMCURSORELT,
    };
    pub const SPANFIX = struct {
        l: randr.FixedF32,
        r: randr.FixedF32,
        y: randr.FixedF32,
    };
    pub const TRAP = struct {
        top: SPANFIX,
        bot: SPANFIX,
    };
    pub const AddTraps = struct { // opcode 32
        picture: Picture,
        x_off: i16,
        y_off: i16,
        traps: []const TRAP,
    };
    pub const CreateSolidFill = struct { // opcode 33
        picture: Picture,
        color: COLOR,
    };
    pub const CreateLinearGradient = struct { // opcode 34
        picture: Picture,
        p1: POINTFIX,
        p2: POINTFIX,
        num_stops: u32,
        stops: []const randr.FixedF32,
        colors: []const COLOR,
    };
    pub const CreateRadialGradient = struct { // opcode 35
        picture: Picture,
        inner: POINTFIX,
        outer: POINTFIX,
        inner_radius: randr.FixedF32,
        outer_radius: randr.FixedF32,
        num_stops: u32,
        stops: []const randr.FixedF32,
        colors: []const COLOR,
    };
    pub const CreateConicalGradient = struct { // opcode 36
        picture: Picture,
        center: POINTFIX,
        angle: randr.FixedF32,
        num_stops: u32,
        stops: []const randr.FixedF32,
        colors: []const COLOR,
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        query_pict_formats = 1,
        query_pict_index_values = 2,
        create_picture = 4,
        change_picture = 5,
        set_picture_clip_rectangles = 6,
        free_picture = 7,
        composite = 8,
        trapezoids = 10,
        triangles = 11,
        tri_strip = 12,
        tri_fan = 13,
        create_glyph_set = 17,
        reference_glyph_set = 18,
        free_glyph_set = 19,
        add_glyphs = 20,
        free_glyphs = 22,
        composite_glyphs8 = 23,
        composite_glyphs16 = 24,
        composite_glyphs32 = 25,
        fill_rectangles = 26,
        create_cursor = 27,
        set_picture_transform = 28,
        query_filters = 29,
        set_picture_filter = 30,
        create_anim_cursor = 31,
        add_traps = 32,
        create_solid_fill = 33,
        create_linear_gradient = 34,
        create_radial_gradient = 35,
        create_conical_gradient = 36,
    };
};
pub const xfixes = struct {
    pub const QueryVersion = struct { // opcode 0
        client_major_version: u32,
        client_minor_version: u32,
        pub const Reply = struct {
            major_version: u32,
            minor_version: u32,
        };
    };
    pub const SaveSetMode = enum(u32) {
        insert = 0,
        delete = 1,
    };
    pub const SaveSetTarget = enum(u32) {
        nearest = 0,
        root = 1,
    };
    pub const SaveSetMapping = enum(u32) {
        map = 0,
        unmap = 1,
    };
    pub const ChangeSaveSet = struct { // opcode 1
        mode: u8,
        target: u8,
        map: u8,
        window: Window,
    };
    pub const SelectionEvent = enum(u32) {
        set_selection_owner = 0,
        selection_window_destroy = 1,
        selection_client_close = 2,
    };
    pub const SelectionEventMask = packed struct(u32) {
        set_selection_owner: bool = false,
        selection_window_destroy: bool = false,
        selection_client_close: bool = false,
    };
    pub const SelectionNotify = struct {
        subtype: u8,
        window: Window,
        owner: Window,
        selection: Atom,
        u32_ms: u32,
        selection_timestamp: u32,
    };
    pub const SelectSelectionInput = struct { // opcode 2
        window: Window,
        selection: Atom,
        event_mask: u32,
    };

    pub const CursorNotifyMask = packed struct(u32) {
        display_cursor: bool = false,
    };
    pub const CursorNotify = struct {
        subtype: u8,
        window: Window,
        cursor_serial: u32,
        u32_ms: u32,
        name: Atom,

        pub const State = enum(u32) {
            display_cursor = 0,
        };
    };
    pub const SelectCursorInput = struct { // opcode 3
        window: Window,
        event_mask: u32,
    };
    pub const GetCursorImage = struct { // opcode 4
        pub const Reply = struct {
            x: i16,
            y: i16,
            width: u16,
            height: u16,
            xhot: u16,
            yhot: u16,
            cursor_serial: u32,
            cursor_image: []const u32,
        };
    };
    // unknown start xidtype
    // unknown end xidtype
    pub const BadRegion = struct {};
    pub const Region = enum(u32) {
        none = 0,
    };
    pub const CreateRegion = struct { // opcode 5
        region: Region,
        rectangles: []const xproto.RECTANGLE,
    };
    pub const CreateRegionFromBitmap = struct { // opcode 6
        region: Region,
        bitmap: Pixmap,
    };
    pub const CreateRegionFromWindow = struct { // opcode 7
        region: Region,
        window: Window,
        kind: shape.Kind,
    };
    pub const CreateRegionFromGC = struct { // opcode 8
        region: Region,
        graphics_context: GraphicsContext,
    };
    pub const CreateRegionFromPicture = struct { // opcode 9
        region: Region,
        picture: render.Picture,
    };
    pub const DestroyRegion = struct { // opcode 10
        region: Region,
    };
    pub const SetRegion = struct { // opcode 11
        region: Region,
        rectangles: []const xproto.RECTANGLE,
    };
    pub const CopyRegion = struct { // opcode 12
        source: Region,
        destination: Region,
    };
    pub const UnionRegion = struct { // opcode 13
        source1: Region,
        source2: Region,
        destination: Region,
    };
    pub const IntersectRegion = struct { // opcode 14
        source1: Region,
        source2: Region,
        destination: Region,
    };
    pub const SubtractRegion = struct { // opcode 15
        source1: Region,
        source2: Region,
        destination: Region,
    };
    pub const InvertRegion = struct { // opcode 16
        source: Region,
        bounds: xproto.RECTANGLE,
        destination: Region,
    };
    pub const TranslateRegion = struct { // opcode 17
        region: Region,
        dx: i16,
        dy: i16,
    };
    pub const RegionExtents = struct { // opcode 18
        source: Region,
        destination: Region,
    };
    pub const FetchRegion = struct { // opcode 19
        region: Region,
        pub const Reply = struct {
            extents: xproto.RECTANGLE,
            rectangles: []const xproto.RECTANGLE,
        };
    };
    pub const SetGCClipRegion = struct { // opcode 20
        graphics_context: GraphicsContext,
        region: Region,
        x_origin: i16,
        y_origin: i16,
    };
    pub const SetWindowShapeRegion = struct { // opcode 21
        dest: Window,
        dest_kind: shape.Kind,
        x_offset: i16,
        y_offset: i16,
        region: Region,
    };
    pub const SetPictureClipRegion = struct { // opcode 22
        picture: render.Picture,
        region: Region,
        x_origin: i16,
        y_origin: i16,
    };
    pub const SetCursorName = struct { // opcode 23
        cursor: xproto.Cursor,
        nbytes: u16,
        name: []const u8,
    };
    pub const GetCursorName = struct { // opcode 24
        cursor: xproto.Cursor,
        pub const Reply = struct {
            atom: Atom,
            nbytes: u16,
            name: []const u8,
        };
    };
    pub const GetCursorImageAndName = struct { // opcode 25
        pub const Reply = struct {
            x: i16,
            y: i16,
            width: u16,
            height: u16,
            xhot: u16,
            yhot: u16,
            cursor_serial: u32,
            cursor_atom: Atom,
            nbytes: u16,
            cursor_image: []const u32,
            name: []const u8,
        };
    };
    pub const ChangeCursor = struct { // opcode 26
        source: xproto.Cursor,
        destination: xproto.Cursor,
    };
    pub const ChangeCursorByName = struct { // opcode 27
        src: xproto.Cursor,
        nbytes: u16,
        name: []const u8,
    };
    pub const ExpandRegion = struct { // opcode 28
        source: Region,
        destination: Region,
        left: u16,
        right: u16,
        top: u16,
        bottom: u16,
    };
    pub const HideCursor = struct { // opcode 29
        window: Window,
    };
    pub const ShowCursor = struct { // opcode 30
        window: Window,
    };
    pub const Barrier = enum(u32) {
        _,
        pub const Directions = packed struct(u32) {
            positive_x: bool = false,
            positive_y: bool = false,
            negative_x: bool = false,
            negative_y: bool = false,
        };
    };
    pub const CreatePointerBarrier = struct { // opcode 31
        barrier: Barrier, // HARALD
        window: Window,
        x1: u16,
        y1: u16,
        x2: u16,
        y2: u16,
        directions: u32,
        num_devices: u16,
        devices: []const u16,
    };
    pub const DeletePointerBarrier = struct { // opcode 32
        barrier: Barrier,
    };
    pub const ClientDisconnectFlags = packed struct(u32) {
        terminate: bool = false,
        pad0: u31 = 0,
        pub const default: @This() = .{};
    };
    pub const SetClientDisconnectMode = struct { // opcode 33
        disconnect_mode: u32,
    };
    pub const GetClientDisconnectMode = struct { // opcode 34
        pub const Reply = struct {
            disconnect_mode: u32,
        };
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        change_save_set = 1,
        select_selection_input = 2,
        select_cursor_input = 3,
        get_cursor_image = 4,
        create_region = 5,
        create_region_from_bitmap = 6,
        create_region_from_window = 7,
        create_region_from_g_c = 8,
        create_region_from_picture = 9,
        destroy_region = 10,
        set_region = 11,
        copy_region = 12,
        union_region = 13,
        intersect_region = 14,
        subtract_region = 15,
        invert_region = 16,
        translate_region = 17,
        region_extents = 18,
        fetch_region = 19,
        set_g_c_clip_region = 20,
        set_window_shape_region = 21,
        set_picture_clip_region = 22,
        set_cursor_name = 23,
        get_cursor_name = 24,
        get_cursor_image_and_name = 25,
        change_cursor = 26,
        change_cursor_by_name = 27,
        expand_region = 28,
        hide_cursor = 29,
        show_cursor = 30,
        create_pointer_barrier = 31,
        delete_pointer_barrier = 32,
        set_client_disconnect_mode = 33,
        get_client_disconnect_mode = 34,
    };
};
pub const xc_misc = struct {
    pub const Opcode = enum(u8) {
        get_version = 0,
        get_xid_range = 1,
        get_xid_list = 2,
    };
    pub const GetVersion = struct { // opcode 0
        client_major_version: u16,
        client_minor_version: u16,
        pub const Reply = struct {
            server_major_version: u16,
            server_minor_version: u16,
        };
    };
    pub const get_xid = struct {
        pub const range = struct {
            pub const Request = struct {};

            pub const Reply = struct {
                start_id: u32,
                count: u32,
            };
        };

        pub const list = struct {
            pub const Request = struct {
                count: u32,
            };

            pub const Reply = struct {
                ids_len: u32,
                ids: []const u32,
            };
        };
    };
};
pub const xinerama = struct {
    // unknown start xcb
    // unknown start import
    // unknown end import
    pub const ScreenInfo = struct {
        x_org: i16,
        y_org: i16,
        width: u16,
        height: u16,
    };
    pub const QueryVersion = struct { // opcode 0
        major: u8,
        minor: u8,
        pub const Reply = struct {
            major: u16,
            minor: u16,
        };
    };
    pub const GetState = struct { // opcode 1
        window: Window,
        pub const Reply = struct {
            state: u8,
            window: Window,
        };
    };
    pub const GetScreenCount = struct { // opcode 2
        window: Window,
        pub const Reply = struct {
            screen_count: u8,
            window: Window,
        };
    };
    pub const GetScreenSize = struct { // opcode 3
        window: Window,
        screen: u32,
        pub const Reply = struct {
            width: u32,
            height: u32,
            window: Window,
            screen: u32,
        };
    };
    pub const IsActive = struct { // opcode 4
        pub const Reply = struct {
            state: u32,
        };
    };
    pub const QueryScreens = struct { // opcode 5
        pub const Reply = struct {
            number: u32,
            screen_info: []const ScreenInfo,
        };
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        get_state = 1,
        get_screen_count = 2,
        get_screen_size = 3,
        is_active = 4,
        query_screens = 5,
    };
};
pub const shape = struct {
    pub const Opcode = enum(u8) {
        query_version = 0,
        rectangles = 1,
        mask = 2,
        combine = 3,
        offset = 4,
        query_extents = 5,
        select_input = 6,
        input_selected = 7,
        get_rectangles = 8,
    };

    pub const Kind = enum(u8) {
        bounding = 0,
        clip = 1,
        input = 2,
        _,
    };

    pub const Operation = enum(u8) {
        set,
        @"union",
        intersect,
        subtract,
        invert,
        _,
    };

    pub const Notify = struct {
        shape_kind: Kind,
        affected_window: Window,
        extents_x: i16,
        extents_y: i16,
        extents_width: u16,
        extents_height: u16,
        server_time: u32,
        shaped: bool,
    };
    pub const query_version = struct {
        pub const Reply = struct {
            major_version: u16,
            minor_version: u16,
        };
    };
    pub const rectangles = struct {
        pub const Request = struct {
            operation: Operation,
            destination_kind: Kind,
            ordering: u8,
            destination_window: Window,
            x_offset: i16,
            y_offset: i16,
            rectangles: []const xproto.RECTANGLE,
        };
    };
    pub const mask = struct {
        pub const Request = struct {
            operation: Operation,
            destination_kind: Kind,
            destination_window: Window,
            x_offset: i16,
            y_offset: i16,
            source_bitmap: Pixmap,
        };
    };
    pub const combine = struct {
        pub const Request = struct {
            operation: Operation,
            destination_kind: Kind,
            source_kind: Kind,
            destination_window: Window,
            x_offset: i16,
            y_offset: i16,
            source_window: Window,
        };
    };
    pub const offset = struct {
        pub const Request = struct {
            destination_kind: Kind,
            destination_window: Window,
            x_offset: i16,
            y_offset: i16,
        };
    };
    pub const query_extents = struct {
        pub const Request = struct {
            destination_window: Window,
        };
        pub const Reply = struct {
            bounding_shaped: bool,
            clip_shaped: bool,
            bounding_shape_extents_x: i16,
            bounding_shape_extents_y: i16,
            bounding_shape_extents_width: u16,
            bounding_shape_extents_height: u16,
            clip_shape_extents_x: i16,
            clip_shape_extents_y: i16,
            clip_shape_extents_width: u16,
            clip_shape_extents_height: u16,
        };
    };
    pub const select_input = struct {
        pub const Request = struct {
            destination_window: Window,
            enable: bool,
        };
    };
    pub const input_selected = struct {
        pub const Request = struct {
            destination_window: Window,
        };
        pub const Reply = struct {
            enabled: bool,
        };
    };
    pub const get_rectangles = struct {
        pub const Request = struct {
            window: Window,
            source_kind: Kind,
        };
        pub const Reply = struct {
            ordering: u8,
            rectangles_len: u32,
            rectangles: []const xproto.RECTANGLE,
        };
    };
};
pub const present = struct {
    const composite = @import("composite.zig");

    pub const Event = enum(u32) {
        configure_notify = 0,
        complete_notify = 1,
        idle_notify = 2,
        redirect_notify = 3,
    };
    pub const EventMask = packed struct(u32) {
        configure_notify: bool = false,
        complete_notify: bool = false,
        idle_notify: bool = false,
        redirect_notify: bool = false,
    };
    pub const Option = packed struct(u32) {
        async: bool = false,
        copy: bool = false,
        ust: bool = false,
        suboptimal: bool = false,
        async_may_tear: bool = false,
        pad0: u27 = 0,

        pub const none: @This() = .{};
    };
    pub const Capability = packed struct(u32) {
        async: bool = false,
        fence: bool = false,
        ust: bool = false,
        async_may_tear: bool = false,
        syncobj: bool = false,
        pad0: u27 = 0,

        pub const none: @This() = .{};
    };
    pub const CompleteKind = enum(u32) {
        pixmap = 0,
        notify_m_s_c = 1,
    };
    pub const CompleteMode = enum(u32) {
        copy = 0,
        flip = 1,
        skip = 2,
        suboptimal_copy = 3,
    };
    pub const Notify = struct {
        window: Window,
        serial: u32,
    };
    pub const QueryVersion = struct { // opcode 0
        major_version: u32,
        minor_version: u32,
        pub const Reply = struct {
            major_version: u32,
            minor_version: u32,
        };
    };
    pub const pixmap = struct {
        pub const Request = struct { // opcode 1
            window: Window,
            pixmap: Pixmap,
            serial: u32,
            valid: randr.Region,
            update: randr.Region,
            x_off: i16,
            y_off: i16,
            target_crtc: randr.CRTC,
            wait_fence: sync.FENCE,
            idle_fence: sync.FENCE,
            options: u32,
            target_msc: u64,
            divisor: u64,
            remainder: u64,
            notifies: []const Notify,
        };
    };
    pub const NotifyMSC = struct { // opcode 2
        window: Window,
        serial: u32,
        target_msc: u64,
        divisor: u64,
        remainder: u64,
    };
    pub const SelectInput = struct { // opcode 3
        eid: u32,
        window: Window,
        event_mask: u32,
    };
    pub const QueryCapabilities = struct { // opcode 4
        target: u32,
        pub const Reply = struct {
            capabilities: u32,
        };
    };
    pub const PixmapSynced = struct { // opcode 5
        // unknown start required_start_align
        // unknown end required_start_align
        window: Window,
        pixmap: Pixmap,
        serial: u32,
        valid: composite.Region,
        update: composite.Region,
        x_off: i16,
        y_off: i16,
        target_crtc: randr.CRTC,
        acquire_syncobj: dri3.SYNCOBJ,
        release_syncobj: dri3.SYNCOBJ,
        acquire_point: u64,
        release_point: u64,
        options: u32,
        target_msc: u64,
        divisor: u64,
        remainder: u64,
        notifies: []const Notify,
    };
    pub const Generic = struct {
        extension: u8,
        length: u32,
        evtype: u16,
        event: u32,
    };
    pub const ConfigureNotify = struct {
        event: u32,
        window: Window,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        off_x: i16,
        off_y: i16,
        pixmap_width: u16,
        pixmap_height: u16,
        pixmap_flags: u32,
    };
    pub const CompleteNotify = struct {
        // unknown start required_start_align
        // unknown end required_start_align
        kind: u8,
        mode: u8,
        event: u32,
        window: Window,
        serial: u32,
        ust: u64,
        msc: u64,
    };
    pub const IdleNotify = struct {
        event: u32,
        window: Window,
        serial: u32,
        pixmap: Pixmap,
        idle_fence: sync.FENCE,
    };
    pub const RedirectNotify = struct {
        // unknown start required_start_align
        // unknown end required_start_align
        update_window: bool,
        event: u32,
        event_window: Window,
        window: Window,
        pixmap: Pixmap,
        serial: u32,
        valid_region: composite.Region,
        update_region: composite.Region,
        valid_rect: xproto.RECTANGLE,
        update_rect: xproto.RECTANGLE,
        x_off: i16,
        y_off: i16,
        target_crtc: randr.CRTC,
        wait_fence: sync.FENCE,
        idle_fence: sync.FENCE,
        options: u32,
        target_msc: u64,
        divisor: u64,
        remainder: u64,
        notifies: []const Notify,
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        pixmap = 1,
        notify_m_s_c = 2,
        select_input = 3,
        query_capabilities = 4,
        pixmap_synced = 5,
    };
};
pub const shm = struct {
    pub const Opcode = enum(u8) {
        query_version = 0,
        attach = 1,
        detach = 2,
        put_image = 3,
        get_image = 4,
        create_pixmap = 5,
        attach_fd = 6,
        create_segment = 7,
    };

    pub const Completion = struct {
        drawable: Drawable,
        minor_event: u16,
        major_event: u8,
        shmseg: xv.Seg,
        offset: u32,
    };
    pub const query_version = struct {
        pub const Request = struct {};
        pub const Reply = struct {
            shared_pixmaps: bool,
            major_version: u16,
            minor_version: u16,
            uid: u16,
            gid: u16,
            pixmap_format: u8,
        };
    };
    pub const attach = struct {
        pub const Request = struct {
            shmseg: xv.Seg,
            shmid: u32,
            read_only: bool,
        };
    };
    pub const detach = struct {
        pub const Request = struct {
            shmseg: xv.Seg,
        };
    };
    pub const put_image = struct {
        pub const Requeest = struct {
            drawable: Drawable,
            graphics_context: GraphicsContext,
            total_width: u16,
            total_height: u16,
            src_x: u16,
            src_y: u16,
            src_width: u16,
            src_height: u16,
            dst_x: i16,
            dst_y: i16,
            depth: u8,
            format: u8,
            send_event: bool,
            shmseg: xv.Seg,
            offset: u32,
        };
    };
    pub const get_image = struct {
        pub const Request = struct {
            drawable: Drawable,
            x: i16,
            y: i16,
            width: u16,
            height: u16,
            plane_mask: u32,
            format: u8,
            shmseg: xv.Seg,
            offset: u32,
        };
        pub const Reply = struct {
            depth: u8,
            visual: Visual.Id,
            size: u32,
        };
    };
    pub const CreatePixmap = struct {
        pub const request = struct {
            pid: Pixmap,
            drawable: Drawable,
            width: u16,
            height: u16,
            depth: u8,
            shmseg: xv.Seg,
            offset: u32,
        };
    };
    pub const attach_fd = struct {
        pub const Request = struct {
            shmseg: xv.Seg,
            fd: std.posix.fd_t,
            read_only: bool,
        };
    };
    pub const create_segment = struct {
        pub const Request = struct {
            shmseg: xv.Seg,
            size: u32,
            read_only: bool,
        };
        pub const Reply = struct {
            nfd: u8,
            fd: []const std.posix.fd_t,
        };
    };
};
pub const res = struct {
    pub const Client = struct {
        resource_base: u32,
        resource_mask: u32,

        pub const id = struct {
            pub const Mask = packed struct(u32) {
                client_x_i_d: bool = false,
                local_client_p_i_d: bool = false,
            };
            pub const Spec = struct {
                client: u32,
                mask: u32,
            };

            pub const Value = struct {
                spec: Spec,
                length: u32,
                value: []const u32,
            };
        };
    };
    pub const Type = struct {
        resource_type: Atom,
        count: u32,
    };

    pub const ResourceIdSpec = struct {
        resource: u32,
        type: u32,
    };
    pub const ResourceSizeSpec = struct {
        spec: ResourceIdSpec,
        bytes: u32,
        ref_count: u32,
        use_count: u32,
    };
    pub const ResourceSizeValue = struct {
        size: ResourceSizeSpec,
        num_cross_references: u32,
        cross_references: []const ResourceSizeSpec,
    };
    pub const QueryVersion = struct { // opcode 0
        client_major: u8,
        client_minor: u8,
        pub const Reply = struct {
            server_major: u16,
            server_minor: u16,
        };
    };
    pub const QueryClients = struct { // opcode 1
        pub const Reply = struct {
            num_clients: u32,
            clients: []const Client,
        };
    };
    pub const QueryClientResources = struct { // opcode 2
        xid: u32,
        pub const Reply = struct {
            num_types: u32,
            types: []const Type,
        };
    };
    pub const QueryClientPixmapBytes = struct { // opcode 3
        xid: u32,
        pub const Reply = struct {
            bytes: u32,
            bytes_overflow: u32,
        };
    };
    pub const QueryClientIds = struct { // opcode 4
        num_specs: u32,
        specs: []const Client.id.Spec,
        pub const Reply = struct {
            num_ids: u32,
            ids: []const Client.id.Value,
        };
    };
    pub const QueryResourceBytes = struct { // opcode 5
        client: u32,
        num_specs: u32,
        specs: []const ResourceIdSpec,
        pub const Reply = struct {
            num_sizes: u32,
            sizes: []const ResourceSizeValue,
        };
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        query_clients = 1,
        query_client_resources = 2,
        query_client_pixmap_bytes = 3,
        query_client_ids = 4,
        query_resource_bytes = 5,
    };
};
pub const glx = struct {
    pub const FbConfig = enum(u32) {
        _,
    };

    pub const Pbuffer = enum(u32) {
        _,
    };

    pub const Generic = struct {
        bad_value: u32,
        minor_opcode: u16,
        major_opcode: u8,
    };
    pub const PbufferClobber = struct {
        event_type: u16,
        draw_type: u16,
        drawable: glx.Drawable,
        b_mask: u32,
        aux_buffer: u16,
        x: u16,
        y: u16,
        width: u16,
        height: u16,
        count: u16,
    };
    pub const BufferSwapComplete = struct {
        event_type: u16,
        drawable: glx.Drawable,
        ust_hi: u32,
        ust_lo: u32,
        msc_hi: u32,
        msc_lo: u32,
        sbc: u32,
    };
    pub const PBCET = enum(u32) {
        damaged = 32791,
        saved = 32792,
    };
    pub const PBCDT = enum(u32) {
        window = 32793,
        pbuffer = 32794,
    };
    pub const Render = struct { // opcode 1
        context_tag: u32,
        data: []const u8,
    };
    pub const RenderLarge = struct { // opcode 2
        context_tag: u32,
        request_num: u16,
        request_total: u16,
        data_len: u32,
        data: []const u8,
    };
    pub const CreateContext = struct { // opcode 3
        context: glx.Context,
        visual: Visual.Id,
        screen: u32,
        share_list: glx.Context,
        is_direct: bool,
    };
    pub const DestroyContext = struct { // opcode 4
        context: glx.Context,
    };
    pub const MakeCurrent = struct { // opcode 5
        drawable: glx.Drawable,
        context: glx.Context,
        old_context_tag: u32,
        pub const Reply = struct {
            context_tag: u32,
        };
    };
    pub const IsDirect = struct { // opcode 6
        context: glx.Context,
        pub const Reply = struct {
            is_direct: bool,
        };
    };
    pub const QueryVersion = struct { // opcode 7
        major_version: u32,
        minor_version: u32,
        pub const Reply = struct {
            major_version: u32,
            minor_version: u32,
        };
    };
    pub const WaitGL = struct { // opcode 8
        context_tag: u32,
    };
    pub const WaitX = struct { // opcode 9
        context_tag: u32,
    };
    pub const CopyContext = struct { // opcode 10
        src: glx.Context,
        dest: glx.Context,
        mask: u32,
        src_context_tag: u32,
    };
    pub const GC = packed struct(u32) {
        current_bit: bool = false,
        point_bit: bool = false,
        linebit: bool = false,
        polygon_bit: bool = false,
        polygon_stipple_bit: bool = false,
        pixel_mode_bit: bool = false,
        lighting_bit: bool = false,
        fog_bit: bool = false,
        depth_buffer_bit: bool = false,
        accum_buffer_bit: bool = false,
        stencil_buffer_bit: bool = false,
        viewport_bit: bool = false,
        transform_bit: bool = false,
        enable_bit: bool = false,
        color_buffer_bit: bool = false,
        hint_bit: bool = false,
        eval_bit: bool = false,
        list_bit: bool = false,
        texture_bit: bool = false,
        scissor_bit: bool = false,
        pad0: u12 = 0,

        pub const all_attrib_bits: @This() = @bitCast(16777215);
    };
    pub const SwapBuffers = struct { // opcode 11
        context_tag: u32,
        drawable: glx.Drawable,
    };
    pub const UseXFont = struct { // opcode 12
        context_tag: u32,
        font: xproto.Font,
        first: u32,
        count: u32,
        list_base: u32,
    };
    pub const CreateGLXPixmap = struct { // opcode 13
        screen: u32,
        visual: Visual.Id,
        pixmap: xproto.Pixmap,
        glx_pixmap: glx.Pixmap,
    };
    pub const GetVisualConfigs = struct { // opcode 14
        screen: u32,
        pub const Reply = struct {
            num_visuals: u32,
            num_properties: u32,
            property_list: []const u32,
        };
    };
    pub const DestroyGLXPixmap = struct { // opcode 15
        glx_pixmap: glx.Pixmap,
    };
    pub const VendorPrivate = struct { // opcode 16
        vendor_code: u32,
        context_tag: u32,
        data: []const u8,
    };
    pub const VendorPrivateWithReply = struct { // opcode 17
        vendor_code: u32,
        context_tag: u32,
        data: []const u8,
        pub const Reply = struct {
            retval: u32,
            data1: []const u8,
            data2: []const u8,
        };
    };
    pub const QueryExtensionsString = struct { // opcode 18
        screen: u32,
        pub const Reply = struct {
            n: u32,
        };
    };
    pub const QueryServerString = struct { // opcode 19
        screen: u32,
        name: u32,
        pub const Reply = struct {
            str_len: u32,
            string: []const u8,
        };
    };
    pub const ClientInfo = struct { // opcode 20
        major_version: u32,
        minor_version: u32,
        str_len: u32,
        string: []const u8,
    };
    pub const GetFBConfigs = struct { // opcode 21
        screen: u32,
        pub const Reply = struct {
            num_FB_configs: u32,
            num_properties: u32,
            property_list: []const u32,
        };
    };
    pub const CreatePixmap = struct { // opcode 22
        screen: u32,
        fbconfig: FbConfig,
        pixmap: xproto.Pixmap,
        glx_pixmap: glx.Pixmap,
        num_attribs: u32,
        attribs: []const u32,
    };
    pub const DestroyPixmap = struct { // opcode 23
        glx_pixmap: glx.Pixmap,
    };
    pub const CreateNewContext = struct { // opcode 24
        context: glx.Context,
        fbconfig: FbConfig,
        screen: u32,
        render_type: u32,
        share_list: glx.Context,
        is_direct: bool,
    };
    pub const QueryContext = struct { // opcode 25
        context: glx.Context,
        pub const Reply = struct {
            num_attribs: u32,
            attribs: []const u32,
        };
    };
    pub const MakeContextCurrent = struct { // opcode 26
        old_context_tag: u32,
        drawable: glx.Drawable,
        read_drawable: glx.Drawable,
        context: glx.Context,
        pub const Reply = struct {
            context_tag: u32,
        };
    };
    pub const CreatePbuffer = struct { // opcode 27
        screen: u32,
        fbconfig: FbConfig,
        pbuffer: Pbuffer,
        num_attribs: u32,
        attribs: []const u32,
    };
    pub const DestroyPbuffer = struct { // opcode 28
        pbuffer: Pbuffer,
    };
    pub const GetDrawableAttributes = struct { // opcode 29
        drawable: glx.Drawable,
        pub const Reply = struct {
            num_attribs: u32,
            attribs: []const u32,
        };
    };
    pub const ChangeDrawableAttributes = struct { // opcode 30
        drawable: glx.Drawable,
        num_attribs: u32,
        attribs: []const u32,
    };
    pub const CreateWindow = struct { // opcode 31
        screen: u32,
        fbconfig: FbConfig,
        window: xproto.Window,
        glx_window: glx.Window,
        num_attribs: u32,
        attribs: []const u32,
    };
    pub const DeleteWindow = struct { // opcode 32
        glxwindow: glx.Window,
    };
    pub const SetClientInfoARB = struct { // opcode 33
        major_version: u32,
        minor_version: u32,
        num_versions: u32,
        gl_str_len: u32,
        glx_str_len: u32,
        gl_versions: []const u32,
        gl_extension_string: []const u8,
        glx_extension_string: []const u8,
    };
    pub const CreateContextAttribsARB = struct { // opcode 34
        context: glx.Context,
        fbconfig: FbConfig,
        screen: u32,
        share_list: glx.Context,
        is_direct: bool,
        num_attribs: u32,
        attribs: []const u32,
    };
    pub const SetClientInfo2ARB = struct { // opcode 35
        major_version: u32,
        minor_version: u32,
        num_versions: u32,
        gl_str_len: u32,
        glx_str_len: u32,
        gl_versions: []const u32,
        gl_extension_string: []const u8,
        glx_extension_string: []const u8,
    };
    pub const NewList = struct { // opcode 101
        context_tag: u32,
        list: u32,
        mode: u32,
    };
    pub const EndList = struct { // opcode 102
        context_tag: u32,
    };
    pub const DeleteLists = struct { // opcode 103
        context_tag: u32,
        list: u32,
        range: i32,
    };
    pub const GenLists = struct { // opcode 104
        context_tag: u32,
        range: i32,
        pub const Reply = struct {
            ret_val: u32,
        };
    };
    pub const FeedbackBuffer = struct { // opcode 105
        context_tag: u32,
        size: i32,
        type: i32,
    };
    pub const SelectBuffer = struct { // opcode 106
        context_tag: u32,
        size: i32,
    };
    pub const RenderMode = struct { // opcode 107
        context_tag: u32,
        mode: u32,
        pub const Reply = struct {
            ret_val: u32,
            n: u32,
            new_mode: u32,
            data: []const u32,
        };
    };
    pub const RM = enum(u32) {
        g_l__r_e_n_d_e_r = 7168,
        g_l__f_e_e_d_b_a_c_k = 7169,
        g_l__s_e_l_e_c_t = 7170,
    };
    pub const Finish = struct { // opcode 108
        context_tag: u32,
        pub const Reply = struct {};
    };
    pub const PixelStoref = struct { // opcode 109
        context_tag: u32,
        pname: u32,
        datum: f32,
    };
    pub const PixelStorei = struct { // opcode 110
        context_tag: u32,
        pname: u32,
        datum: i32,
    };
    pub const ReadPixels = struct { // opcode 111
        context_tag: u32,
        x: i32,
        y: i32,
        width: i32,
        height: i32,
        format: u32,
        type: u32,
        swap_bytes: bool,
        lsb_first: bool,
        pub const Reply = struct {
            data: []const u8,
        };
    };
    pub const Getbooleanv = struct { // opcode 112
        context_tag: u32,
        pname: i32,
        pub const Reply = struct {
            n: u32,
            datum: bool,
            data: []const bool,
        };
    };
    pub const GetClipPlane = struct { // opcode 113
        context_tag: u32,
        plane: i32,
        pub const Reply = struct {
            // unknown start required_start_align
            // unknown end required_start_align
            data: []const f64,
        };
    };
    pub const GetDoublev = struct { // opcode 114
        context_tag: u32,
        pname: u32,
        pub const Reply = struct {
            // unknown start required_start_align
            // unknown end required_start_align
            n: u32,
            datum: f64,
            data: []const f64,
        };
    };
    pub const GetError = struct { // opcode 115
        context_tag: u32,
        pub const Reply = struct {
            @"error": i32,
        };
    };
    pub const GetFloatv = struct { // opcode 116
        context_tag: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: f32,
            data: []const f32,
        };
    };
    pub const GetIntegerv = struct { // opcode 117
        context_tag: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const GetLightfv = struct { // opcode 118
        context_tag: u32,
        light: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: f32,
            data: []const f32,
        };
    };
    pub const GetLightiv = struct { // opcode 119
        context_tag: u32,
        light: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const GetMapdv = struct { // opcode 120
        context_tag: u32,
        target: u32,
        query: u32,
        pub const Reply = struct {
            // unknown start required_start_align
            // unknown end required_start_align
            n: u32,
            datum: f64,
            data: []const f64,
        };
    };
    pub const GetMapfv = struct { // opcode 121
        context_tag: u32,
        target: u32,
        query: u32,
        pub const Reply = struct {
            n: u32,
            datum: f32,
            data: []const f32,
        };
    };
    pub const GetMapiv = struct { // opcode 122
        context_tag: u32,
        target: u32,
        query: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const GetMaterialfv = struct { // opcode 123
        context_tag: u32,
        face: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: f32,
            data: []const f32,
        };
    };
    pub const GetMaterialiv = struct { // opcode 124
        context_tag: u32,
        face: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const GetPixelMapfv = struct { // opcode 125
        context_tag: u32,
        map: u32,
        pub const Reply = struct {
            n: u32,
            datum: f32,
            data: []const f32,
        };
    };
    pub const GetPixelMapuiv = struct { // opcode 126
        context_tag: u32,
        map: u32,
        pub const Reply = struct {
            n: u32,
            datum: u32,
            data: []const u32,
        };
    };
    pub const GetPixelMapusv = struct { // opcode 127
        context_tag: u32,
        map: u32,
        pub const Reply = struct {
            n: u32,
            datum: u16,
            data: []const u16,
        };
    };
    pub const GetPolygonStipple = struct { // opcode 128
        context_tag: u32,
        lsb_first: bool,
        pub const Reply = struct {
            data: []const u8,
        };
    };
    pub const GetString = struct { // opcode 129
        context_tag: u32,
        name: u32,
        pub const Reply = struct {
            n: u32,
            string: []const u8,
        };
    };
    pub const GetTexEnvfv = struct { // opcode 130
        context_tag: u32,
        target: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: f32,
            data: []const f32,
        };
    };
    pub const GetTexEnviv = struct { // opcode 131
        context_tag: u32,
        target: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const GetTexGendv = struct { // opcode 132
        context_tag: u32,
        coord: u32,
        pname: u32,
        pub const Reply = struct {
            // unknown start required_start_align
            // unknown end required_start_align
            n: u32,
            datum: f64,
            data: []const f64,
        };
    };
    pub const GetTexGenfv = struct { // opcode 133
        context_tag: u32,
        coord: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: f32,
            data: []const f32,
        };
    };
    pub const GetTexGeniv = struct { // opcode 134
        context_tag: u32,
        coord: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const GetTexImage = struct { // opcode 135
        context_tag: u32,
        target: u32,
        level: i32,
        format: u32,
        type: u32,
        swap_bytes: bool,
        pub const Reply = struct {
            width: i32,
            height: i32,
            depth: i32,
            data: []const u8,
        };
    };
    pub const GetTexParameterfv = struct { // opcode 136
        context_tag: u32,
        target: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: f32,
            data: []const f32,
        };
    };
    pub const GetTexParameteriv = struct { // opcode 137
        context_tag: u32,
        target: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const GetTexLevelParameterfv = struct { // opcode 138
        context_tag: u32,
        target: u32,
        level: i32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: f32,
            data: []const f32,
        };
    };
    pub const GetTexLevelParameteriv = struct { // opcode 139
        context_tag: u32,
        target: u32,
        level: i32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const IsEnabled = struct { // opcode 140
        context_tag: u32,
        capability: u32,
        pub const Reply = struct {
            ret_val: u32, // bool
        };
    };
    pub const IsList = struct { // opcode 141
        context_tag: u32,
        list: u32,
        pub const Reply = struct {
            ret_val: u32, // bool
        };
    };
    pub const Flush = struct { // opcode 142
        context_tag: u32,
    };
    pub const AreTexturesResident = struct { // opcode 143
        context_tag: u32,
        n: i32,
        textures: []const u32,
        pub const Reply = struct {
            ret_val: u32, // bool
            data: []const bool,
        };
    };
    pub const DeleteTextures = struct { // opcode 144
        context_tag: u32,
        n: i32,
        textures: []const u32,
    };
    pub const GenTextures = struct { // opcode 145
        context_tag: u32,
        n: i32,
        pub const Reply = struct {
            data: []const u32,
        };
    };
    pub const IsTexture = struct { // opcode 146
        context_tag: u32,
        texture: u32,
        pub const Reply = struct {
            ret_val: u32, // bool
        };
    };
    pub const GetColorTable = struct { // opcode 147
        context_tag: u32,
        target: u32,
        format: u32,
        type: u32,
        swap_bytes: bool,
        pub const Reply = struct {
            width: i32,
            data: []const u8,
        };
    };
    pub const GetColorTableParameterfv = struct { // opcode 148
        context_tag: u32,
        target: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: f32,
            data: []const f32,
        };
    };
    pub const GetColorTableParameteriv = struct { // opcode 149
        context_tag: u32,
        target: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const GetConvolutionFilter = struct { // opcode 150
        context_tag: u32,
        target: u32,
        format: u32,
        type: u32,
        swap_bytes: bool,
        pub const Reply = struct {
            width: i32,
            height: i32,
            data: []const u8,
        };
    };
    pub const GetConvolutionParameterfv = struct { // opcode 151
        context_tag: u32,
        target: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: f32,
            data: []const f32,
        };
    };
    pub const GetConvolutionParameteriv = struct { // opcode 152
        context_tag: u32,
        target: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const GetSeparableFilter = struct { // opcode 153
        context_tag: u32,
        target: u32,
        format: u32,
        type: u32,
        swap_bytes: bool,
        pub const Reply = struct {
            row_w: i32,
            col_h: i32,
            rows_and_cols: []const u8,
        };
    };
    pub const GetHistogram = struct { // opcode 154
        context_tag: u32,
        target: u32,
        format: u32,
        type: u32,
        swap_bytes: bool,
        reset: bool,
        pub const Reply = struct {
            width: i32,
            data: []const u8,
        };
    };
    pub const GetHistogramParameterfv = struct { // opcode 155
        context_tag: u32,
        target: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: f32,
            data: []const f32,
        };
    };
    pub const GetHistogramParameteriv = struct { // opcode 156
        context_tag: u32,
        target: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const GetMinmax = struct { // opcode 157
        context_tag: u32,
        target: u32,
        format: u32,
        type: u32,
        swap_bytes: bool,
        reset: bool,
        pub const Reply = struct {
            data: []const u8,
        };
    };
    pub const GetMinmaxParameterfv = struct { // opcode 158
        context_tag: u32,
        target: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: f32,
            data: []const f32,
        };
    };
    pub const GetMinmaxParameteriv = struct { // opcode 159
        context_tag: u32,
        target: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const GetCompressedTexImageARB = struct { // opcode 160
        context_tag: u32,
        target: u32,
        level: i32,
        pub const Reply = struct {
            size: i32,
            data: []const u8,
        };
    };
    pub const DeleteQueriesARB = struct { // opcode 161
        context_tag: u32,
        n: i32,
        ids: []const u32,
    };
    pub const GenQueriesARB = struct { // opcode 162
        context_tag: u32,
        n: i32,
        pub const Reply = struct {
            data: []const u32,
        };
    };
    pub const IsQueryARB = struct { // opcode 163
        context_tag: u32,
        id: u32,
        pub const Reply = struct {
            ret_val: u32, // bool
        };
    };
    pub const GetQueryivARB = struct { // opcode 164
        context_tag: u32,
        target: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const GetQueryObjectivARB = struct { // opcode 165
        context_tag: u32,
        id: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: i32,
            data: []const i32,
        };
    };
    pub const GetQueryObjectuivARB = struct { // opcode 166
        context_tag: u32,
        id: u32,
        pname: u32,
        pub const Reply = struct {
            n: u32,
            datum: u32,
            data: []const u32,
        };
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        render = 1,
        render_large = 2,
        create_context = 3,
        destroy_context = 4,
        make_current = 5,
        is_direct = 6,
        query_version = 7,
        wait_g_l = 8,
        wait_x = 9,
        copy_context = 10,
        swap_buffers = 11,
        use_x_font = 12,
        create_g_l_x_pixmap = 13,
        get_visual_configs = 14,
        destroy_g_l_x_pixmap = 15,
        vendor_private = 16,
        vendor_private_with_reply = 17,
        query_extensions_string = 18,
        query_server_string = 19,
        client_info = 20,
        get_f_b_configs = 21,
        create_pixmap = 22,
        destroy_pixmap = 23,
        create_new_context = 24,
        query_context = 25,
        make_context_current = 26,
        create_pbuffer = 27,
        destroy_pbuffer = 28,
        get_drawable_attributes = 29,
        change_drawable_attributes = 30,
        create_window = 31,
        delete_window = 32,
        set_client_info_a_r_b = 33,
        create_context_attribs_a_r_b = 34,
        set_client_info2_a_r_b = 35,
        new_list = 101,
        end_list = 102,
        delete_lists = 103,
        gen_lists = 104,
        feedback_buffer = 105,
        select_buffer = 106,
        render_mode = 107,
        finish = 108,
        pixel_storef = 109,
        pixel_storei = 110,
        read_pixels = 111,
        get_booleanv = 112,
        get_clip_plane = 113,
        get_doublev = 114,
        get_error = 115,
        get_floatv = 116,
        get_integerv = 117,
        get_lightfv = 118,
        get_lightiv = 119,
        get_mapdv = 120,
        get_mapfv = 121,
        get_mapiv = 122,
        get_materialfv = 123,
        get_materialiv = 124,
        get_pixel_mapfv = 125,
        get_pixel_mapuiv = 126,
        get_pixel_mapusv = 127,
        get_polygon_stipple = 128,
        get_string = 129,
        get_tex_envfv = 130,
        get_tex_enviv = 131,
        get_tex_gendv = 132,
        get_tex_genfv = 133,
        get_tex_geniv = 134,
        get_tex_image = 135,
        get_tex_parameterfv = 136,
        get_tex_parameteriv = 137,
        get_tex_level_parameterfv = 138,
        get_tex_level_parameteriv = 139,
        is_enabled = 140,
        is_list = 141,
        flush = 142,
        are_textures_resident = 143,
        delete_textures = 144,
        gen_textures = 145,
        is_texture = 146,
        get_color_table = 147,
        get_color_table_parameterfv = 148,
        get_color_table_parameteriv = 149,
        get_convolution_filter = 150,
        get_convolution_parameterfv = 151,
        get_convolution_parameteriv = 152,
        get_separable_filter = 153,
        get_histogram = 154,
        get_histogram_parameterfv = 155,
        get_histogram_parameteriv = 156,
        get_minmax = 157,
        get_minmax_parameterfv = 158,
        get_minmax_parameteriv = 159,
        get_compressed_tex_image_a_r_b = 160,
        delete_queries_a_r_b = 161,
        gen_queries_a_r_b = 162,
        is_query_a_r_b = 163,
        get_queryiv_a_r_b = 164,
        get_query_objectiv_a_r_b = 165,
        get_query_objectuiv_a_r_b = 166,
    };
};
pub const dbe = struct {
    pub const BackBuffer = enum(u32) {
        _,
    };

    pub const SwapAction = enum(u32) {
        undefined = 0,
        background = 1,
        untouched = 2,
        copied = 3,
    };
    pub const SwapInfo = struct {
        window: Window,
        swap_action: u8,
    };
    pub const BufferAttributes = struct {
        window: Window,
    };
    pub const VisualInfo = struct {
        visual_id: Visual.Id,
        depth: u8,
        perf_level: u8,
    };
    pub const VisualInfos = struct {
        n_infos: u32,
        infos: []const VisualInfo,
    };
    pub const BadBuffer = struct {
        bad_buffer: BackBuffer,
    };
    pub const QueryVersion = struct { // opcode 0
        major_version: u8,
        minor_version: u8,
        pub const Reply = struct {
            major_version: u8,
            minor_version: u8,
        };
    };
    pub const AllocateBackBuffer = struct { // opcode 1
        window: Window,
        buffer: BackBuffer,
        swap_action: u8,
    };
    pub const DeallocateBackBuffer = struct { // opcode 2
        buffer: BackBuffer,
    };
    pub const SwapBuffers = struct { // opcode 3
        n_actions: u32,
        actions: []const SwapInfo,
    };
    pub const BeginIdiom = struct { // opcode 4
    };
    pub const EndIdiom = struct { // opcode 5
    };
    pub const GetVisualInfo = struct { // opcode 6
        n_drawables: u32,
        drawables: []const Drawable,
        pub const Reply = struct {
            n_supported_visuals: u32,
            supported_visuals: []const VisualInfos,
        };
    };
    pub const GetBackBufferAttributes = struct { // opcode 7
        buffer: BackBuffer,
        pub const Reply = struct {
            attributes: BufferAttributes,
        };
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        allocate_back_buffer = 1,
        deallocate_back_buffer = 2,
        swap_buffers = 3,
        begin_idiom = 4,
        end_idiom = 5,
        get_visual_info = 6,
        get_back_buffer_attributes = 7,
    };
};
pub const screensaver = struct {
    pub const Opcode = enum(u8) {
        query_version = 0,
        query_info = 1,
        select_input = 2,
        set_attributes = 3,
        unset_attributes = 4,
        @"suspend" = 5,
    };

    pub const Kind = enum(u32) {
        blanked = 0,
        internal = 1,
        external = 2,
    };
    pub const Event = packed struct(u32) {
        notify_mask: bool = false,
        cycle_mask: bool = false,
        pad0: u30 = 0,
    };
    pub const State = enum(u32) {
        off = 0,
        on = 1,
        cycle = 2,
        disabled = 3,
    };
    pub const QueryVersion = struct { // opcode 0
        client_major_version: u8,
        client_minor_version: u8,
        pub const Reply = struct {
            server_major_version: u16,
            server_minor_version: u16,
        };
    };
    pub const QueryInfo = struct { // opcode 1
        drawable: Drawable,
        pub const Reply = struct {
            state: u8,
            saver_window: Window,
            ms_until_server: u32,
            ms_since_user_input: u32,
            event_mask: u32,
            kind: u8,
        };
    };
    pub const SelectInput = struct { // opcode 2
        drawable: Drawable,
        event_mask: u32,
    };
    pub const SetAttributes = struct { // opcode 3
        drawable: Drawable,
        x: i16,
        y: i16,
        width: u16,
        height: u16,
        border_width: u16,
        class: u8,
        depth: u8,
        visual: Visual.Id,
        value_mask: u32,
        background_pixmap: Pixmap,
        background_pixel: u32,
        border_pixmap: Pixmap,
        border_pixel: u32,
        bit_gravity: u32,
        win_gravity: u32,
        backing_store: u32,
        backing_planes: u32,
        backing_pixel: u32,
        event_mask: u32,
        do_not_propogate_mask: u32,
        colormap: xproto.Colormap,
        cursor: xproto.Cursor,
    };
    pub const unset_attributes = struct {
        pub const Request = struct {
            drawable: Drawable,
        };
    };
    pub const @"suspend" = struct {
        pub const Request = struct {
            @"suspend": u32,
        };
    };
    pub const Notify = struct {
        state: u8,
        time: u32,
        root: Window,
        window: Window,
        kind: u8,
        forced: bool,
    };
};
pub const dpms = struct {
    pub const Opcode = enum(u8) {
        get_version = 0,
        capable = 1,
        get_timeouts = 2,
        set_timeouts = 3,
        enable = 4,
        disable = 5,
        force_level = 6,
        info = 7,
        select_input = 8,
    };

    pub const get_version = struct {
        pub const Request = struct {
            client_major_version: u16,
            client_minor_version: u16,
        };
        pub const Reply = struct {
            server_major_version: u16,
            server_minor_version: u16,
        };
    };
    pub const capable = struct {
        pub const Request = struct {};
        pub const Reply = struct {
            capable: bool,
        };
    };
    pub const get_timeouts = struct {
        pub const Request = struct {};
        pub const Reply = struct {
            standby_timeout: u16,
            suspend_timeout: u16,
            off_timeout: u16,
        };
    };
    pub const set_timeouts = struct {
        pub const Request = struct {
            standby_timeout: u16,
            suspend_timeout: u16,
            off_timeout: u16,
        };
    };
    pub const enable = struct {
        pub const Request = struct {};
    };
    pub const disable = struct {
        pub const Request = struct {};
    };
    pub const DPMSMode = enum(u32) {
        on = 0,
        standby = 1,
        @"suspend" = 2,
        off = 3,
    };
    pub const force_level = struct {
        pub const Request = struct {
            power_level: u16,
        };
    };
    pub const info = struct {
        pub const Request = struct {};
        pub const Reply = struct {
            power_level: u16,
            state: bool,
        };
    };
    pub const EventMask = packed struct(u32) {
        info_notify: bool = false,
    };
    pub const select_input = struct {
        pub const Request = struct {
            event_mask: u32,
        };
    };
    pub const InfoNotify = struct {
        u32_ms: u32,
        power_level: u16,
        state: bool,
    };
};
pub const xselinux = struct {
    // unknown start xcb
    // unknown start import
    // unknown end import
    pub const QueryVersion = struct { // opcode 0
        client_major: u8,
        client_minor: u8,
        pub const Reply = struct {
            server_major: u16,
            server_minor: u16,
        };
    };
    pub const SetDeviceCreateContext = struct { // opcode 1
        context_len: u32,
        context: []const u8,
    };
    pub const GetDeviceCreateContext = struct { // opcode 2
        pub const Reply = struct {
            context_len: u32,
            context: []const u8,
        };
    };
    pub const SetDeviceContext = struct { // opcode 3
        device: u32,
        context_len: u32,
        context: []const u8,
    };
    pub const GetDeviceContext = struct { // opcode 4
        device: u32,
        pub const Reply = struct {
            context_len: u32,
            context: []const u8,
        };
    };
    pub const SetWindowCreateContext = struct { // opcode 5
        context_len: u32,
        context: []const u8,
    };
    pub const GetWindowCreateContext = struct { // opcode 6
        pub const Reply = struct {
            context_len: u32,
            context: []const u8,
        };
    };
    pub const GetWindowContext = struct { // opcode 7
        window: Window,
        pub const Reply = struct {
            context_len: u32,
            context: []const u8,
        };
    };
    pub const ListItem = struct {
        name: Atom,
        object_context_len: u32,
        data_context_len: u32,
        object_context: []const u8,
        data_context: []const u8,
    };
    pub const SetPropertyCreateContext = struct { // opcode 8
        context_len: u32,
        context: []const u8,
    };
    pub const GetPropertyCreateContext = struct { // opcode 9
        pub const Reply = struct {
            context_len: u32,
            context: []const u8,
        };
    };
    pub const SetPropertyUseContext = struct { // opcode 10
        context_len: u32,
        context: []const u8,
    };
    pub const GetPropertyUseContext = struct { // opcode 11
        pub const Reply = struct {
            context_len: u32,
            context: []const u8,
        };
    };
    pub const GetPropertyContext = struct { // opcode 12
        window: Window,
        property: Atom,
        pub const Reply = struct {
            context_len: u32,
            context: []const u8,
        };
    };
    pub const GetPropertyDataContext = struct { // opcode 13
        window: Window,
        property: Atom,
        pub const Reply = struct {
            context_len: u32,
            context: []const u8,
        };
    };
    pub const ListProperties = struct { // opcode 14
        window: Window,
        pub const Reply = struct {
            properties_len: u32,
            properties: []const ListItem,
        };
    };
    pub const SetSelectionCreateContext = struct { // opcode 15
        context_len: u32,
        context: []const u8,
    };
    pub const GetSelectionCreateContext = struct { // opcode 16
        pub const Reply = struct {
            context_len: u32,
            context: []const u8,
        };
    };
    pub const SetSelectionUseContext = struct { // opcode 17
        context_len: u32,
        context: []const u8,
    };
    pub const GetSelectionUseContext = struct { // opcode 18
        pub const Reply = struct {
            context_len: u32,
            context: []const u8,
        };
    };
    pub const GetSelectionContext = struct { // opcode 19
        selection: Atom,
        pub const Reply = struct {
            context_len: u32,
            context: []const u8,
        };
    };
    pub const GetSelectionDataContext = struct { // opcode 20
        selection: Atom,
        pub const Reply = struct {
            context_len: u32,
            context: []const u8,
        };
    };
    pub const ListSelections = struct { // opcode 21
        pub const Reply = struct {
            selections_len: u32,
            selections: []const ListItem,
        };
    };
    pub const GetClientContext = struct { // opcode 22
        resource: u32,
        pub const Reply = struct {
            context_len: u32,
            context: []const u8,
        };
    };
    // unknown end xcb
    pub const Opcode = enum(u8) {
        query_version = 0,
        set_device_create_context = 1,
        get_device_create_context = 2,
        set_device_context = 3,
        get_device_context = 4,
        set_window_create_context = 5,
        get_window_create_context = 6,
        get_window_context = 7,
        set_property_create_context = 8,
        get_property_create_context = 9,
        set_property_use_context = 10,
        get_property_use_context = 11,
        get_property_context = 12,
        get_property_data_context = 13,
        list_properties = 14,
        set_selection_create_context = 15,
        get_selection_create_context = 16,
        set_selection_use_context = 17,
        get_selection_use_context = 18,
        get_selection_context = 19,
        get_selection_data_context = 20,
        list_selections = 21,
        get_client_context = 22,
    };
};

pub const xprint = struct {
    // unknown start xcb
    // unknown start import
    // unknown end import
    // unknown start typedef
    // unknown end typedef
    pub const PRINTER = struct {
        nameLen: u32,
        name: []const u8,
        descLen: u32,
        description: []const u8,
    };
    // unknown start xidtype
    // unknown end xidtype
    pub const GetDoc = enum(u32) {
        finished = 0,
        second_consumer = 1,
    };
    pub const EvMask = packed struct(u32) {
        print_mask: bool = false,
        attribute_mask: bool = false,
    };
    pub const Detail = enum(u32) {
        start_job_notify = 1,
        end_job_notify = 2,
        start_doc_notify = 3,
        end_doc_notify = 4,
        start_page_notify = 5,
        end_page_notify = 6,
    };
    pub const Attr = enum(u32) {
        job_attr = 1,
        doc_attr = 2,
        page_attr = 3,
        printer_attr = 4,
        server_attr = 5,
        medium_attr = 6,
        spooler_attr = 7,
    };
    pub const PrintQueryVersion = struct { // opcode 0
        pub const Reply = struct {
            major_version: u16,
            minor_version: u16,
        };
    };
    pub const PrintGetPrinterList = struct { // opcode 1
        printerNameLen: u32,
        localeLen: u32,
        printer_name: []const u8,
        locale: []const u8,
        pub const Reply = struct {
            listCount: u32,
            printers: []const PRINTER,
        };
    };
    pub const PrintRehashPrinterList = struct { // opcode 20
    };
    pub const CreateContext = struct { // opcode 2
        context_id: u32,
        printerNameLen: u32,
        localeLen: u32,
        printerName: []const u8,
        locale: []const u8,
    };
    pub const PrintSetContext = struct { // opcode 3
        context: u32,
    };
    pub const PrintGetContext = struct { // opcode 4
        pub const Reply = struct {
            context: u32,
        };
    };
    pub const PrintDestroyContext = struct { // opcode 5
        context: u32,
    };
    pub const PrintGetScreenOfContext = struct { // opcode 6
        pub const Reply = struct {
            root: Window,
        };
    };
    pub const PrintStartJob = struct { // opcode 7
        output_mode: u8,
    };
    pub const PrintEndJob = struct { // opcode 8
        cancel: bool,
    };
    pub const PrintStartDoc = struct { // opcode 9
        driver_mode: u8,
    };
    pub const PrintEndDoc = struct { // opcode 10
        cancel: bool,
    };
    pub const PrintPutDocumentData = struct { // opcode 11
        drawable: Drawable,
        len_data: u32,
        len_fmt: u16,
        len_options: u16,
        data: []const u8,
        doc_format: []const u8,
        options: []const u8,
    };
    pub const PrintGetDocumentData = struct { // opcode 12
        context: Pcontext,
        max_bytes: u32,
        pub const Reply = struct {
            status_code: u32,
            finished_flag: u32,
            dataLen: u32,
            data: []const u8,
        };
    };
    pub const PrintStartPage = struct { // opcode 13
        window: Window,
    };
    pub const PrintEndPage = struct { // opcode 14
        cancel: bool,
    };
    pub const PrintSelectInput = struct { // opcode 15
        context: Pcontext,
        event_mask: u32,
    };
    pub const PrintInputSelected = struct { // opcode 16
        context: Pcontext,
        pub const Reply = struct {
            event_mask: u32,
            all_events_mask: u32,
        };
    };
    pub const PrintGetAttributes = struct { // opcode 17
        context: Pcontext,
        pool: u8,
        pub const Reply = struct {
            stringLen: u32,
            attributes: []const u8,
        };
    };
    pub const PrintGetOneAttributes = struct { // opcode 19
        context: Pcontext,
        nameLen: u32,
        pool: u8,
        name: []const u8,
        pub const Reply = struct {
            valueLen: u32,
            value: []const u8,
        };
    };
    pub const PrintSetAttributes = struct { // opcode 18
        context: Pcontext,
        stringLen: u32,
        pool: u8,
        rule: u8,
        attributes: []const u8,
    };
    pub const PrintGetPageDimensions = struct { // opcode 21
        context: Pcontext,
        pub const Reply = struct {
            width: u16,
            height: u16,
            offset_x: u16,
            offset_y: u16,
            reproducible_width: u16,
            reproducible_height: u16,
        };
    };
    pub const PrintQueryScreens = struct { // opcode 22
        pub const Reply = struct {
            listCount: u32,
            roots: []const Window,
        };
    };
    pub const PrintSetImageResolution = struct { // opcode 23
        context: Pcontext,
        image_resolution: u16,
        pub const Reply = struct {
            status: bool,
            previous_resolutions: u16,
        };
    };
    pub const PrintGetImageResolution = struct { // opcode 24
        context: Pcontext,
        pub const Reply = struct {
            image_resolution: u16,
        };
    };
    pub const Notify = struct {
        detail: u8,
        context: Pcontext,
        cancel: bool,
    };
    pub const AttributNotify = struct {
        detail: u8,
        context: Pcontext,
    };
    pub const BadContext = struct {};
    pub const BadSequence = struct {};
    // unknown end xcb
    pub const Opcode = enum(u8) {
        print_query_version = 0,
        print_get_printer_list = 1,
        print_rehash_printer_list = 20,
        create_context = 2,
        print_set_context = 3,
        print_get_context = 4,
        print_destroy_context = 5,
        print_get_screen_of_context = 6,
        print_start_job = 7,
        print_end_job = 8,
        print_start_doc = 9,
        print_end_doc = 10,
        print_put_document_data = 11,
        print_get_document_data = 12,
        print_start_page = 13,
        print_end_page = 14,
        print_select_input = 15,
        print_input_selected = 16,
        print_get_attributes = 17,
        print_get_one_attributes = 19,
        print_set_attributes = 18,
        print_get_page_dimensions = 21,
        print_query_screens = 22,
        print_set_image_resolution = 23,
        print_get_image_resolution = 24,
    };
};
