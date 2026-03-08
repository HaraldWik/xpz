const Drawable = @import("../root.zig").Drawable;

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

pub const Alarm = enum(u32) {
    _,

    pub const State = enum(u32) {
        active = 0,
        inactive = 1,
        destroyed = 2,
    };

    pub const Info = struct {
        bad_alarm: Alarm,
        minor_opcode: u16,
        major_opcode: u8,
    };

    pub const ChangeMask = packed struct(u32) {
        counter: bool = false,
        value_type: bool = false,
        value: bool = false,
        test_type: bool = false,
        delta: bool = false,
        events: bool = false,
        pad0: u26 = 0,
    };
};
pub const Fence = enum(u32) {
    _,

    pub const Invalid = struct {
        fence: Fence,
        minor_opcode: u16,
        major_opcode: u8,
    };
};
pub const Counter = enum(u32) {
    _,

    pub const Invalid = struct {
        counter: Counter,
        minor_opcode: u16,
        major_opcode: u8,
    };

    pub const System = struct {
        counter: Counter,
        resolution: i64,
        name_len: u16,
        name: []const u8,
    };
};
pub const Resource = extern union {
    alarm: Alarm,
    counter: Counter,
};
pub const TestType = enum(u32) {
    positive_transition = 0,
    negative_transition = 1,
    positive_comparison = 2,
    negative_comparison = 3,
};
pub const ValueType = enum(u32) {
    absolute = 0,
    relative = 1,
};
pub const Trigger = struct {
    counter: Counter,
    wait_type: u32,
    wait_value: i64,
    test_type: u32,

    pub const WaitCondition = struct {
        trigger: Trigger,
        event_threshold: i64,
    };
};

pub const initialize = struct {
    pub const Request = struct {
        desired_major_version: u8,
        desired_minor_version: u8,
    };
    pub const Reply = struct {
        major_version: u8,
        minor_version: u8,
    };
};
pub const list_system_counters = struct {
    pub const Request = struct {};
    pub const Reply = struct {
        counters_len: u32,
        counters: []const Counter.System,
    };
};
pub const create_counter = struct {
    pub const Request = struct {
        id: Counter,
        initial_value: i64,
    };
};
pub const destroy_counter = struct {
    pub const Request = struct {
        counter: Counter,
    };
};
pub const query_counter = struct {
    pub const Request = struct {
        counter: Counter,
    };
    pub const Reply = struct {
        counter_value: i64,
    };
};
pub const await = struct {
    pub const Request = struct {
        wait_list: []const Trigger.WaitCondition,
    };
};
pub const change_counter = struct {
    pub const Request = struct {
        counter: Counter,
        amount: i64,
    };
};
pub const set_counter = struct {
    pub const Request = struct {
        counter: Counter,
        value: i64,
    };
};
pub const create_alarm = struct {
    pub const Request = struct {
        alarm: Alarm,
        value_mask: Alarm.ChangeMask,
        counter: Counter,
        valueType: u32,
        value: i64,
        testType: u32,
        delta: i64,
        events: u32,
    };
};
pub const change_alarm = struct {
    pub const Request = struct {
        alarm: Alarm,
        value_mask: Alarm.ChangeMask,
        counter: Counter,
        value_type: u32,
        value: i64,
        testType: u32,
        delta: i64,
        events: u32,
    };
};
pub const destroy_alarm = struct {
    pub const Request = struct {
        alarm: Alarm,
    };
};
pub const query_alarm = struct {
    pub const Request = struct {
        alarm: Alarm,
    };
    pub const Reply = struct {
        trigger: Trigger,
        delta: i64,
        events: bool,
        state: u8,
    };
};
pub const set_priority = struct {
    pub const Request = struct {
        id: Resource,
        priority: i32,
    };
};
pub const get_priority = struct {
    pub const Request = struct {
        id: Resource,
    };
    pub const Reply = struct {
        priority: i32,
    };
};
pub const create_fence = struct {
    pub const Request = struct {
        drawable: Drawable,
        fence: Fence,
        initially_triggered: bool,
    };
};
pub const trigger_fence = struct {
    pub const Request = struct {
        fence: Fence,
    };
};
pub const reset_fence = struct {
    pub const Request = struct {
        fence: Fence,
    };
};
pub const destroy_fence = struct {
    pub const Request = struct {
        fence: Fence,
    };
};
pub const query_fence = struct {
    pub const Request = struct {
        fence: Fence,
    };
    pub const Reply = struct {
        triggered: bool,
    };
};
pub const await_fence = struct {
    pub const Request = struct {
        fence_list: []const Fence,
    };
};

pub const event = struct {
    pub const CounterNotify = struct {
        kind: u8,
        counter: Counter,
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
};
