pub const FP3232 = struct {
    integral: i32,
    frac: u32,
};
pub const GetExtensionVersion = struct { // opcode 1
    name_len: u16,
    name: []const u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        server_major: u16,
        server_minor: u16,
        present: bool,
    };
};
pub const DeviceUse = enum(u32) {
    is_x_pointer = 0,
    is_x_keyboard = 1,
    is_x_extension_device = 2,
    is_x_extension_keyboard = 3,
    is_x_extension_pointer = 4,
};
pub const InputClass = enum(u32) {
    key = 0,
    button = 1,
    valuator = 2,
    feedback = 3,
    proximity = 4,
    focus = 5,
    other = 6,
};
pub const ValuatorMode = enum(u32) {
    relative = 0,
    absolute = 1,
};
pub const DeviceInfo = struct {
    device_type: Atom,
    device_id: u8,
    num_class_info: u8,
    device_use: u8,
};
pub const KeyInfo = struct {
    class_id: u8,
    len: u8,
    min_keycode: KeyCode,
    max_keycode: KeyCode,
    num_keys: u16,
};
pub const ButtonInfo = struct {
    class_id: u8,
    len: u8,
    num_buttons: u16,
};
pub const AxisInfo = struct {
    resolution: u32,
    minimum: i32,
    maximum: i32,
};
pub const ValuatorInfo = struct {
    class_id: u8,
    len: u8,
    axes_len: u8,
    mode: u8,
    motion_size: u32,
    axes: []const AxisInfo,
};
pub const InputInfo = struct {
    class_id: u8,
    len: u8,
    min_keycode: KeyCode,
    max_keycode: KeyCode,
    num_keys: u16,
    num_buttons: u16,
    // unknown start required_start_align
    // unknown end required_start_align
    axes_len: u8,
    mode: u8,
    motion_size: u32,
    axes: []const AxisInfo,
};
pub const DeviceName = struct {
    len: u8,
    string: [*]const u8,
};
pub const ListInputDevices = struct { // opcode 2
    pub const Reply = struct {
        xi_reply_type: u8,
        devices_len: u8,
        devices: []const DeviceInfo,
        infos: []const InputInfo,
        // unknown start sumof
        // unknown end sumof
        names: []const STR,
    };
};
// unknown start typedef
// unknown end typedef
pub const InputClassInfo = struct {
    class_id: u8,
    event_type_base: EventTypeBase,
};
pub const OpenDevice = struct { // opcode 3
    device_id: u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        num_classes: u8,
        class_info: []const InputClassInfo,
    };
};
pub const CloseDevice = struct { // opcode 4
    device_id: u8,
};
pub const SetDeviceMode = struct { // opcode 5
    device_id: u8,
    mode: u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        status: u8,
    };
};
pub const SelectExtensionEvent = struct { // opcode 6
    window: Window,
    num_classes: u16,
    classes: []const EventClass,
};
pub const GetSelectedExtensionEvents = struct { // opcode 7
    window: Window,
    pub const Reply = struct {
        xi_reply_type: u8,
        num_this_classes: u16,
        num_all_classes: u16,
        this_classes: []const EventClass,
        all_classes: []const EventClass,
    };
};
pub const PropagateMode = enum(u32) {
    add_to_list = 0,
    delete_from_list = 1,
};
pub const ChangeDeviceDontPropagateList = struct { // opcode 8
    window: Window,
    num_classes: u16,
    mode: u8,
    classes: []const EventClass,
};
pub const GetDeviceDontPropagateList = struct { // opcode 9
    window: Window,
    pub const Reply = struct {
        xi_reply_type: u8,
        num_classes: u16,
        classes: []const EventClass,
    };
};
pub const DeviceTimeCoord = struct {
    time: u32,
    axisvalues: []const i32,
    // unknown start paramref
    // unknown end paramref
};
pub const GetDeviceMotionEvents = struct { // opcode 10
    start: u32,
    stop: u32,
    device_id: u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        num_events: u32,
        num_axes: u8,
        device_mode: u8,
        events: []const DeviceTimeCoord,
    };
};
pub const ChangeKeyboardDevice = struct { // opcode 11
    device_id: u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        status: u8,
    };
};
pub const ChangePointerDevice = struct { // opcode 12
    x_axis: u8,
    y_axis: u8,
    device_id: u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        status: u8,
    };
};
pub const GrabDevice = struct { // opcode 13
    grab_window: Window,
    time: u32,
    num_classes: u16,
    this_device_mode: u8,
    other_device_mode: u8,
    owner_events: bool,
    device_id: u8,
    classes: []const EventClass,
    pub const Reply = struct {
        xi_reply_type: u8,
        status: u8,
    };
};
pub const UngrabDevice = struct { // opcode 14
    time: u32,
    device_id: u8,
};
pub const ModifierDevice = enum(u32) {
    use_x_keyboard = 255,
};
pub const GrabDeviceKey = struct { // opcode 15
    grab_window: Window,
    num_classes: u16,
    modifiers: u16,
    modifier_device: u8,
    grabbed_device: u8,
    key: u8,
    this_device_mode: u8,
    other_device_mode: u8,
    owner_events: bool,
    classes: []const EventClass,
};
pub const UngrabDeviceKey = struct { // opcode 16
    grabWindow: Window,
    modifiers: u16,
    modifier_device: u8,
    key: u8,
    grabbed_device: u8,
};
pub const GrabDeviceButton = struct { // opcode 17
    grab_window: Window,
    grabbed_device: u8,
    modifier_device: u8,
    num_classes: u16,
    modifiers: u16,
    this_device_mode: u8,
    other_device_mode: u8,
    button: u8,
    owner_events: bool,
    classes: []const EventClass,
};
pub const UngrabDeviceButton = struct { // opcode 18
    grab_window: Window,
    modifiers: u16,
    modifier_device: u8,
    button: u8,
    grabbed_device: u8,
};
pub const DeviceInputMode = enum(u32) {
    async_this_device = 0,
    sync_this_device = 1,
    replay_this_device = 2,
    async_other_devices = 3,
    async_all = 4,
    sync_all = 5,
};
pub const AllowDeviceEvents = struct { // opcode 19
    time: u32,
    mode: u8,
    device_id: u8,
};
pub const GetDeviceFocus = struct { // opcode 20
    device_id: u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        focus: Window,
        time: u32,
        revert_to: u8,
    };
};
pub const SetDeviceFocus = struct { // opcode 21
    focus: Window,
    time: u32,
    revert_to: u8,
    device_id: u8,
};
pub const FeedbackClass = enum(u32) {
    keyboard = 0,
    pointer = 1,
    string = 2,
    integer = 3,
    led = 4,
    bell = 5,
};
pub const KbdFeedbackState = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    pitch: u16,
    duration: u16,
    led_mask: u32,
    led_values: u32,
    global_auto_repeat: bool,
    click: u8,
    percent: u8,
    auto_repeats: []const u8,
};
pub const PtrFeedbackState = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    accel_num: u16,
    accel_denom: u16,
    threshold: u16,
};
pub const IntegerFeedbackState = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    resolution: u32,
    min_value: i32,
    max_value: i32,
};
pub const StringFeedbackState = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    max_symbols: u16,
    num_keysyms: u16,
    keysyms: []const KEYSYM,
};
pub const BellFeedbackState = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    percent: u8,
    pitch: u16,
    duration: u16,
};
pub const LedFeedbackState = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    led_mask: u32,
    led_values: u32,
};
pub const FeedbackState = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    // unknown start switch
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    pitch: u16,
    duration: u16,
    led_mask: u32,
    led_values: u32,
    global_auto_repeat: bool,
    click: u8,
    percent: u8,
    auto_repeats: []const u8,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    accel_num: u16,
    accel_denom: u16,
    threshold: u16,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    max_symbols: u16,
    num_keysyms: u16,
    keysyms: []const KEYSYM,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    resolution: u32,
    min_value: i32,
    max_value: i32,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    led_mask: u32,
    led_values: u32,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    percent: u8,
    pitch: u16,
    duration: u16,
    // unknown end case
    // unknown end switch
};
pub const GetFeedbackControl = struct { // opcode 22
    device_id: u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        num_feedbacks: u16,
        feedbacks: []const FeedbackState,
    };
};
pub const KbdFeedbackCtl = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    key: KeyCode,
    auto_repeat_mode: u8,
    key_click_percent: i8,
    bell_percent: i8,
    bell_pitch: i16,
    bell_duration: i16,
    led_mask: u32,
    led_values: u32,
};
pub const PtrFeedbackCtl = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    num: i16,
    denom: i16,
    threshold: i16,
};
pub const IntegerFeedbackCtl = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    int_to_display: i32,
};
pub const StringFeedbackCtl = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    num_keysyms: u16,
    keysyms: []const KEYSYM,
};
pub const BellFeedbackCtl = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    percent: i8,
    pitch: i16,
    duration: i16,
};
pub const LedFeedbackCtl = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    led_mask: u32,
    led_values: u32,
};
pub const FeedbackCtl = struct {
    class_id: u8,
    feedback_id: u8,
    len: u16,
    // unknown start switch
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    key: KeyCode,
    auto_repeat_mode: u8,
    key_click_percent: i8,
    bell_percent: i8,
    bell_pitch: i16,
    bell_duration: i16,
    led_mask: u32,
    led_values: u32,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    num: i16,
    denom: i16,
    threshold: i16,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    num_keysyms: u16,
    keysyms: []const KEYSYM,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    int_to_display: i32,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    led_mask: u32,
    led_values: u32,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    percent: i8,
    pitch: i16,
    duration: i16,
    // unknown end case
    // unknown end switch
};
pub const ChangeFeedbackControlMask = packed struct(u32) {
    key_click_percent: bool = false,
    percent: bool = false,
    pitch: bool = false,
    duration: bool = false,
    led: bool = false,
    led_mode: bool = false,
    key: bool = false,
    auto_repeat_mode: bool = false,
    string: bool = false,
    integer: bool = false,
    accel_num: bool = false,
    accel_denom: bool = false,
    threshold: bool = false,
};
pub const ChangeFeedbackControl = struct { // opcode 23
    mask: u32,
    device_id: u8,
    feedback_id: u8,
    feedback: FeedbackCtl,
};
pub const GetDeviceKeyMapping = struct { // opcode 24
    device_id: u8,
    first_keycode: KeyCode,
    count: u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        keysyms_per_keycode: u8,
        keysyms: []const KEYSYM,
    };
};
pub const ChangeDeviceKeyMapping = struct { // opcode 25
    device_id: u8,
    first_keycode: KeyCode,
    keysyms_per_keycode: u8,
    keycode_count: u8,
    keysyms: []const KEYSYM,
};
pub const GetDeviceModifierMapping = struct { // opcode 26
    device_id: u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        keycodes_per_modifier: u8,
        keymaps: []const u8,
    };
};
pub const SetDeviceModifierMapping = struct { // opcode 27
    device_id: u8,
    keycodes_per_modifier: u8,
    keymaps: []const u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        status: u8,
    };
};
pub const GetDeviceButtonMapping = struct { // opcode 28
    device_id: u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        map_size: u8,
        map: []const u8,
    };
};
pub const SetDeviceButtonMapping = struct { // opcode 29
    device_id: u8,
    map_size: u8,
    map: []const u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        status: u8,
    };
};
pub const KeyState = struct {
    class_id: u8,
    len: u8,
    num_keys: u8,
    keys: []const u8,
};
pub const ButtonState = struct {
    class_id: u8,
    len: u8,
    num_buttons: u8,
    buttons: []const u8,
};
pub const ValuatorStateModeMask = packed struct(u32) {
    device_mode_absolute: bool = false,
    out_of_proximity: bool = false,
};
pub const ValuatorState = struct {
    class_id: u8,
    len: u8,
    num_valuators: u8,
    mode: u8,
    valuators: []const i32,
};
pub const InputState = struct {
    class_id: u8,
    len: u8,
    // unknown start switch
    // unknown start required_start_align
    // unknown end required_start_align
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    // unknown start required_start_align
    // unknown end required_start_align
    num_keys: u8,
    keys: []const u8,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    num_buttons: u8,
    buttons: []const u8,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    // unknown start required_start_align
    // unknown end required_start_align
    num_valuators: u8,
    mode: u8,
    valuators: []const i32,
    // unknown end case
    // unknown end switch
};
pub const QueryDeviceState = struct { // opcode 30
    device_id: u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        num_classes: u8,
        classes: []const InputState,
    };
};
pub const DeviceBell = struct { // opcode 32
    device_id: u8,
    feedback_id: u8,
    feedback_class: u8,
    percent: i8,
};
pub const SetDeviceValuators = struct { // opcode 33
    device_id: u8,
    first_valuator: u8,
    num_valuators: u8,
    valuators: []const i32,
    pub const Reply = struct {
        xi_reply_type: u8,
        status: u8,
    };
};
pub const DeviceControl = enum(u32) {
    resolution = 1,
    abs_calib = 2,
    core = 3,
    enable = 4,
    abs_area = 5,
};
pub const DeviceResolutionState = struct {
    control_id: u16,
    len: u16,
    num_valuators: u32,
    resolution_values: []const u32,
    resolution_min: []const u32,
    resolution_max: []const u32,
};
pub const DeviceAbsCalibState = struct {
    control_id: u16,
    len: u16,
    min_x: i32,
    max_x: i32,
    min_y: i32,
    max_y: i32,
    flip_x: u32,
    flip_y: u32,
    rotation: u32,
    button_threshold: u32,
};
pub const DeviceAbsAreaState = struct {
    control_id: u16,
    len: u16,
    offset_x: u32,
    offset_y: u32,
    width: u32,
    height: u32,
    screen: u32,
    following: u32,
};
pub const DeviceCoreState = struct {
    control_id: u16,
    len: u16,
    status: u8,
    iscore: u8,
};
pub const DeviceEnableState = struct {
    control_id: u16,
    len: u16,
    enable: u8,
};
pub const DeviceState = struct {
    control_id: u16,
    len: u16,
    // unknown start switch
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    num_valuators: u32,
    resolution_values: []const u32,
    resolution_min: []const u32,
    resolution_max: []const u32,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    min_x: i32,
    max_x: i32,
    min_y: i32,
    max_y: i32,
    flip_x: u32,
    flip_y: u32,
    rotation: u32,
    button_threshold: u32,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    status: u8,
    iscore: u8,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    enable: u8,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    offset_x: u32,
    offset_y: u32,
    width: u32,
    height: u32,
    screen: u32,
    following: u32,
    // unknown end case
    // unknown end switch
};
pub const GetDeviceControl = struct { // opcode 34
    control_id: u16,
    device_id: u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        status: u8,
        control: DeviceState,
    };
};
pub const DeviceResolutionCtl = struct {
    control_id: u16,
    len: u16,
    first_valuator: u8,
    num_valuators: u8,
    resolution_values: []const u32,
};
pub const DeviceAbsCalibCtl = struct {
    control_id: u16,
    len: u16,
    min_x: i32,
    max_x: i32,
    min_y: i32,
    max_y: i32,
    flip_x: u32,
    flip_y: u32,
    rotation: u32,
    button_threshold: u32,
};
pub const DeviceAbsAreaCtrl = struct {
    control_id: u16,
    len: u16,
    offset_x: u32,
    offset_y: u32,
    width: i32,
    height: i32,
    screen: i32,
    following: u32,
};
pub const DeviceCoreCtrl = struct {
    control_id: u16,
    len: u16,
    status: u8,
};
pub const DeviceEnableCtrl = struct {
    control_id: u16,
    len: u16,
    enable: u8,
};
pub const DeviceCtl = struct {
    control_id: u16,
    len: u16,
    // unknown start switch
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    first_valuator: u8,
    num_valuators: u8,
    resolution_values: []const u32,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    min_x: i32,
    max_x: i32,
    min_y: i32,
    max_y: i32,
    flip_x: u32,
    flip_y: u32,
    rotation: u32,
    button_threshold: u32,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    status: u8,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    enable: u8,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    offset_x: u32,
    offset_y: u32,
    width: i32,
    height: i32,
    screen: i32,
    following: u32,
    // unknown end case
    // unknown end switch
};
pub const ChangeDeviceControl = struct { // opcode 35
    control_id: u16,
    device_id: u8,
    control: DeviceCtl,
    pub const Reply = struct {
        xi_reply_type: u8,
        status: u8,
    };
};
pub const ListDeviceProperties = struct { // opcode 36
    device_id: u8,
    pub const Reply = struct {
        xi_reply_type: u8,
        num_atoms: u16,
        atoms: []const Atom,
    };
};
pub const PropertyFormat = enum(u32) {
    @"8_bits" = 8,
    @"16_bits" = 16,
    @"32_bits" = 32,
};
pub const ChangeDeviceProperty = struct { // opcode 37
    property: Atom,
    type: Atom,
    device_id: u8,
    format: u8,
    mode: u8,
    num_items: u32,
    // unknown start switch
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    data8: []const u8,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    data16: []const u16,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    data32: []const u32,
    // unknown end case
    // unknown end switch
};
pub const DeleteDeviceProperty = struct { // opcode 38
    property: Atom,
    device_id: u8,
};
pub const GetDeviceProperty = struct { // opcode 39
    property: Atom,
    type: Atom,
    offset: u32,
    len: u32,
    device_id: u8,
    delete: bool,
    pub const Reply = struct {
        xi_reply_type: u8,
        type: Atom,
        bytes_after: u32,
        num_items: u32,
        format: u8,
        device_id: u8,
        // unknown start switch
        // unknown start case
        // unknown start enumref
        // unknown end enumref
        data8: []const u8,
        // unknown end case
        // unknown start case
        // unknown start enumref
        // unknown end enumref
        data16: []const u16,
        // unknown end case
        // unknown start case
        // unknown start enumref
        // unknown end enumref
        data32: []const u32,
        // unknown end case
        // unknown end switch
    };
};
pub const Devices = enum(u32) {
    all = 0,
    all_master = 1,
};
pub const GroupInfo = struct {
    base: u8,
    latched: u8,
    locked: u8,
    effective: u8,
};
pub const ModifierInfo = struct {
    base: u32,
    latched: u32,
    locked: u32,
    effective: u32,
};
pub const XIQueryPointer = struct { // opcode 40
    window: Window,
    deviceid: DeviceId,
    pub const Reply = struct {
        root: Window,
        child: Window,
        root_x: FP1616,
        root_y: FP1616,
        win_x: FP1616,
        win_y: FP1616,
        same_screen: bool,
        buttons_len: u16,
        mods: ModifierInfo,
        group: GroupInfo,
        buttons: []const u32,
    };
};
pub const XIWarpPointer = struct { // opcode 41
    src_win: Window,
    dst_win: Window,
    src_x: FP1616,
    src_y: FP1616,
    src_width: u16,
    src_height: u16,
    dst_x: FP1616,
    dst_y: FP1616,
    deviceid: DeviceId,
};
pub const XIChangeCursor = struct { // opcode 42
    window: Window,
    cursor: Cursor,
    deviceid: DeviceId,
};
pub const HierarchyChangeType = enum(u32) {
    add_master = 1,
    remove_master = 2,
    attach_slave = 3,
    detach_slave = 4,
};
pub const ChangeMode = enum(u32) {
    attach = 1,
    float = 2,
};
pub const AddMaster = struct {
    type: u16,
    len: u16,
    name_len: u16,
    send_core: bool,
    enable: bool,
    name: []const u8,
};
pub const RemoveMaster = struct {
    type: u16,
    len: u16,
    deviceid: DeviceId,
    return_mode: u8,
    return_pointer: DeviceId,
    return_keyboard: DeviceId,
};
pub const AttachSlave = struct {
    type: u16,
    len: u16,
    deviceid: DeviceId,
    master: DeviceId,
};
pub const DetachSlave = struct {
    type: u16,
    len: u16,
    deviceid: DeviceId,
};
pub const HierarchyChange = struct {
    type: u16,
    len: u16,
    // unknown start switch
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    name_len: u16,
    send_core: bool,
    enable: bool,
    name: []const u8,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    deviceid: DeviceId,
    return_mode: u8,
    return_pointer: DeviceId,
    return_keyboard: DeviceId,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    deviceid: DeviceId,
    master: DeviceId,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    deviceid: DeviceId,
    // unknown end case
    // unknown end switch
};
pub const XIChangeHierarchy = struct { // opcode 43
    num_changes: u8,
    changes: []const HierarchyChange,
};
pub const XISetClientPointer = struct { // opcode 44
    window: Window,
    deviceid: DeviceId,
};
pub const XIGetClientPointer = struct { // opcode 45
    window: Window,
    pub const Reply = struct {
        set: bool,
        deviceid: DeviceId,
    };
};
pub const XIEventMask = packed struct(u32) {
    device_changed: bool = false,
    key_press: bool = false,
    key_release: bool = false,
    button_press: bool = false,
    button_release: bool = false,
    motion: bool = false,
    enter: bool = false,
    leave: bool = false,
    focus_in: bool = false,
    focus_out: bool = false,
    hierarchy: bool = false,
    property: bool = false,
    raw_key_press: bool = false,
    raw_key_release: bool = false,
    raw_button_press: bool = false,
    raw_button_release: bool = false,
    raw_motion: bool = false,
    touch_begin: bool = false,
    touch_update: bool = false,
    touch_end: bool = false,
    touch_ownership: bool = false,
    raw_touch_begin: bool = false,
    raw_touch_update: bool = false,
    raw_touch_end: bool = false,
    barrier_hit: bool = false,
    barrier_leave: bool = false,
};
pub const EventMask = struct {
    deviceid: DeviceId,
    mask_len: u16,
    mask: []const u32,
};
pub const XISelectEvents = struct { // opcode 46
    window: Window,
    num_mask: u16,
    masks: []const EventMask,
};
pub const XIQueryVersion = struct { // opcode 47
    major_version: u16,
    minor_version: u16,
    pub const Reply = struct {
        major_version: u16,
        minor_version: u16,
    };
};
pub const DeviceClassType = enum(u32) {
    key = 0,
    button = 1,
    valuator = 2,
    scroll = 3,
    touch = 8,
    gesture = 9,
};
pub const DeviceType = enum(u32) {
    master_pointer = 1,
    master_keyboard = 2,
    slave_pointer = 3,
    slave_keyboard = 4,
    floating_slave = 5,
};
pub const ScrollFlags = enum(u32) {
    no_emulation: bool = false,
    preferred: bool = false,
};
pub const ScrollType = enum(u32) {
    vertical = 1,
    horizontal = 2,
};
pub const TouchMode = enum(u32) {
    direct = 1,
    dependent = 2,
};
pub const ButtonClass = struct {
    type: u16,
    len: u16,
    sourceid: DeviceId,
    num_buttons: u16,
    state: []const u32,
    labels: []const Atom,
};
pub const KeyClass = struct {
    type: u16,
    len: u16,
    sourceid: DeviceId,
    num_keys: u16,
    keys: []const u32,
};
pub const ScrollClass = struct {
    type: u16,
    len: u16,
    sourceid: DeviceId,
    number: u16,
    scroll_type: u16,
    flags: u32,
    increment: FP3232,
};
pub const TouchClass = struct {
    type: u16,
    len: u16,
    sourceid: DeviceId,
    mode: u8,
    num_touches: u8,
};
pub const GestureClass = struct {
    type: u16,
    len: u16,
    sourceid: DeviceId,
    num_touches: u8,
};
pub const ValuatorClass = struct {
    type: u16,
    len: u16,
    sourceid: DeviceId,
    number: u16,
    label: Atom,
    min: FP3232,
    max: FP3232,
    value: FP3232,
    resolution: u32,
    mode: u8,
};
pub const DeviceClass = struct {
    // unknown start length
    // unknown end length
    type: u16,
    len: u16,
    sourceid: DeviceId,
    // unknown start switch
    // unknown start required_start_align
    // unknown end required_start_align
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    // unknown start required_start_align
    // unknown end required_start_align
    num_keys: u16,
    keys: []const u32,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    // unknown start required_start_align
    // unknown end required_start_align
    num_buttons: u16,
    state: []const u32,
    labels: []const Atom,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    // unknown start required_start_align
    // unknown end required_start_align
    number: u16,
    label: Atom,
    min: FP3232,
    max: FP3232,
    value: FP3232,
    resolution: u32,
    mode: u8,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    // unknown start required_start_align
    // unknown end required_start_align
    number: u16,
    scroll_type: u16,
    flags: u32,
    increment: FP3232,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    mode: u8,
    num_touches: u8,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    num_touches: u8,
    // unknown end case
    // unknown end switch
};
pub const XIDeviceInfo = struct {
    deviceid: DeviceId,
    type: u16,
    attachment: DeviceId,
    num_classes: u16,
    name_len: u16,
    enabled: bool,
    name: []const u8,
    classes: []const DeviceClass,
};
pub const XIQueryDevice = struct { // opcode 48
    deviceid: DeviceId,
    pub const Reply = struct {
        num_infos: u16,
        infos: []const XIDeviceInfo,
    };
};
pub const XISetFocus = struct { // opcode 49
    window: Window,
    time: u32,
    deviceid: DeviceId,
};
pub const XIGetFocus = struct { // opcode 50
    deviceid: DeviceId,
    pub const Reply = struct {
        focus: Window,
    };
};
pub const GrabOwner = enum(u32) {
    no_owner = 0,
    owner = 1,
};
pub const XIGrabDevice = struct { // opcode 51
    window: Window,
    time: u32,
    cursor: Cursor,
    deviceid: DeviceId,
    mode: u8,
    paired_device_mode: u8,
    owner_events: bool,
    mask_len: u16,
    mask: []const u32,
    pub const Reply = struct {
        status: u8,
    };
};
pub const XIUngrabDevice = struct { // opcode 52
    time: u32,
    deviceid: DeviceId,
};
pub const EventMode = enum(u32) {
    async_device = 0,
    sync_device = 1,
    replay_device = 2,
    async_paired_device = 3,
    async_pair = 4,
    sync_pair = 5,
    accept_touch = 6,
    reject_touch = 7,
};
pub const XIAllowEvents = struct { // opcode 53
    time: u32,
    deviceid: DeviceId,
    event_mode: u8,
    touchid: u32,
    grab_window: Window,
};
pub const GrabMode22 = enum(u32) {
    sync = 0,
    async = 1,
    touch = 2,
};
pub const GrabType = enum(u32) {
    button = 0,
    keycode = 1,
    enter = 2,
    focus_in = 3,
    touch_begin = 4,
    gesture_pinch_begin = 5,
    gesture_swipe_begin = 6,
};
pub const ModifierMask = packed struct(u32) {
    any: bool = false,
};
pub const GrabModifierInfo = struct {
    modifiers: u32,
    status: u8,
};
pub const XIPassiveGrabDevice = struct { // opcode 54
    time: u32,
    grab_window: Window,
    cursor: Cursor,
    detail: u32,
    deviceid: DeviceId,
    num_modifiers: u16,
    mask_len: u16,
    grab_type: u8,
    grab_mode: u8,
    paired_device_mode: u8,
    owner_events: bool,
    mask: []const u32,
    modifiers: []const u32,
    pub const Reply = struct {
        num_modifiers: u16,
        modifiers: []const GrabModifierInfo,
    };
};
pub const XIPassiveUngrabDevice = struct { // opcode 55
    grab_window: Window,
    detail: u32,
    deviceid: DeviceId,
    num_modifiers: u16,
    grab_type: u8,
    modifiers: []const u32,
};
pub const XIListProperties = struct { // opcode 56
    deviceid: DeviceId,
    pub const Reply = struct {
        num_properties: u16,
        properties: []const Atom,
    };
};
pub const XIChangeProperty = struct { // opcode 57
    deviceid: DeviceId,
    mode: u8,
    format: u8,
    property: Atom,
    type: Atom,
    num_items: u32,
    // unknown start switch
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    data8: []const u8,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    data16: []const u16,
    // unknown end case
    // unknown start case
    // unknown start enumref
    // unknown end enumref
    data32: []const u32,
    // unknown end case
    // unknown end switch
};
pub const XIDeleteProperty = struct { // opcode 58
    deviceid: DeviceId,
    property: Atom,
};
pub const XIGetProperty = struct { // opcode 59
    deviceid: DeviceId,
    delete: bool,
    property: Atom,
    type: Atom,
    offset: u32,
    len: u32,
    pub const Reply = struct {
        type: Atom,
        bytes_after: u32,
        num_items: u32,
        format: u8,
        // unknown start switch
        // unknown start case
        // unknown start enumref
        // unknown end enumref
        data8: []const u8,
        // unknown end case
        // unknown start case
        // unknown start enumref
        // unknown end enumref
        data16: []const u16,
        // unknown end case
        // unknown start case
        // unknown start enumref
        // unknown end enumref
        data32: []const u32,
        // unknown end case
        // unknown end switch
    };
};
pub const XIGetSelectedEvents = struct { // opcode 60
    window: Window,
    pub const Reply = struct {
        num_masks: u16,
        masks: []const EventMask,
    };
};
pub const BarrierReleasePointerInfo = struct {
    deviceid: DeviceId,
    barrier: Barrier,
    eventid: u32,
};
pub const XIBarrierReleasePointer = struct { // opcode 61
    num_barriers: u32,
    barriers: []const BarrierReleasePointerInfo,
};
pub const DeviceValuator = struct {
    device_id: u8,
    device_state: u16,
    num_valuators: u8,
    first_valuator: u8,
    valuators: []const i32,
};
pub const MoreEventsMask = packed struct(u32) {
    more_events: bool = false,
};
pub const DeviceKeyPress = struct {
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
    device_id: u8,
};
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventcopy
// unknown end eventcopy
pub const DeviceFocusIn = struct {
    detail: u8,
    time: u32,
    window: Window,
    mode: u8,
    device_id: u8,
};
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventcopy
// unknown end eventcopy
pub const ClassesReportedMask = packed struct(u32) {
    out_of_proximity: bool = false,
    device_mode_absolute: bool = false,
    reporting_valuators: bool = false,
    reporting_buttons: bool = false,
    reporting_keys: bool = false,
};
pub const DeviceStateNotify = struct {
    device_id: u8,
    time: u32,
    num_keys: u8,
    num_buttons: u8,
    num_valuators: u8,
    classes_reported: u8,
    buttons: []const u8,
    keys: []const u8,
    valuators: []const u32,
};
pub const DeviceMappingNotify = struct {
    device_id: u8,
    request: u8,
    first_keycode: KeyCode,
    count: u8,
    time: u32,
};
pub const ChangeDevice = enum(u32) {
    new_pointer = 0,
    new_keyboard = 1,
};
pub const ChangeDeviceNotify = struct {
    device_id: u8,
    time: u32,
    request: u8,
};
pub const DeviceKeyStateNotify = struct {
    device_id: u8,
    keys: []const u8,
};
pub const DeviceButtonStateNotify = struct {
    device_id: u8,
    buttons: []const u8,
};
pub const DeviceChange = enum(u32) {
    added = 0,
    removed = 1,
    enabled = 2,
    disabled = 3,
    unrecoverable = 4,
    control_changed = 5,
};
pub const DevicePresenceNotify = struct {
    time: u32,
    devchange: u8,
    device_id: u8,
    control: u16,
};
pub const DevicePropertyNotify = struct {
    state: u8,
    time: u32,
    property: Atom,
    device_id: u8,
};
pub const ChangeReason = enum(u32) {
    slave_switch = 1,
    device_change = 2,
};
pub const DeviceChanged = struct {
    deviceid: DeviceId,
    time: u32,
    num_classes: u16,
    sourceid: DeviceId,
    reason: u8,
    classes: []const DeviceClass,
};
pub const KeyEventFlags = enum(u32) {
    key_repeat: bool = false,
};
pub const KeyPress = struct {
    deviceid: DeviceId,
    time: u32,
    detail: u32,
    root: Window,
    event: Window,
    child: Window,
    root_x: FP1616,
    root_y: FP1616,
    event_x: FP1616,
    event_y: FP1616,
    buttons_len: u16,
    valuators_len: u16,
    sourceid: DeviceId,
    flags: u32,
    mods: ModifierInfo,
    group: GroupInfo,
    button_mask: []const u32,
    valuator_mask: []const u32,
    axisvalues: []const FP3232,
    // unknown start sumof
    // unknown start popcount
    // unknown start listelement-ref
    // unknown end listelement-ref
    // unknown end popcount
    // unknown end sumof
};
// unknown start eventcopy
// unknown end eventcopy
pub const PointerEventFlags = enum(u32) {
    pointer_emulated: bool = false,
};
pub const ButtonPress = struct {
    deviceid: DeviceId,
    time: u32,
    detail: u32,
    root: Window,
    event: Window,
    child: Window,
    root_x: FP1616,
    root_y: FP1616,
    event_x: FP1616,
    event_y: FP1616,
    buttons_len: u16,
    valuators_len: u16,
    sourceid: DeviceId,
    flags: u32,
    mods: ModifierInfo,
    group: GroupInfo,
    button_mask: []const u32,
    valuator_mask: []const u32,
    axisvalues: []const FP3232,
    // unknown start sumof
    // unknown start popcount
    // unknown start listelement-ref
    // unknown end listelement-ref
    // unknown end popcount
    // unknown end sumof
};
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventcopy
// unknown end eventcopy
pub const NotifyMode = enum(u32) {
    normal = 0,
    grab = 1,
    ungrab = 2,
    while_grabbed = 3,
    passive_grab = 4,
    passive_ungrab = 5,
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
pub const Enter = struct {
    deviceid: DeviceId,
    time: u32,
    sourceid: DeviceId,
    mode: u8,
    detail: u8,
    root: Window,
    event: Window,
    child: Window,
    root_x: FP1616,
    root_y: FP1616,
    event_x: FP1616,
    event_y: FP1616,
    same_screen: bool,
    focus: bool,
    buttons_len: u16,
    mods: ModifierInfo,
    group: GroupInfo,
    buttons: []const u32,
};
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventcopy
// unknown end eventcopy
pub const HierarchyMask = packed struct(u32) {
    master_added: bool = false,
    master_removed: bool = false,
    slave_added: bool = false,
    slave_removed: bool = false,
    slave_attached: bool = false,
    slave_detached: bool = false,
    device_enabled: bool = false,
    device_disabled: bool = false,
};
pub const HierarchyInfo = struct {
    deviceid: DeviceId,
    attachment: DeviceId,
    type: u8,
    enabled: bool,
    flags: u32,
};
pub const Hierarchy = struct {
    deviceid: DeviceId,
    time: u32,
    flags: u32,
    num_infos: u16,
    infos: []const HierarchyInfo,
};
pub const PropertyFlag = enum(u32) {
    deleted = 0,
    created = 1,
    modified = 2,
};
pub const Property = struct {
    deviceid: DeviceId,
    time: u32,
    property: Atom,
    what: u8,
};
pub const RawKeyPress = struct {
    deviceid: DeviceId,
    time: u32,
    detail: u32,
    sourceid: DeviceId,
    valuators_len: u16,
    flags: u32,
    valuator_mask: []const u32,
    axisvalues: []const FP3232,
    // unknown start sumof
    // unknown start popcount
    // unknown start listelement-ref
    // unknown end listelement-ref
    // unknown end popcount
    // unknown end sumof
    axisvalues_raw: []const FP3232,
    // unknown start sumof
    // unknown start popcount
    // unknown start listelement-ref
    // unknown end listelement-ref
    // unknown end popcount
    // unknown end sumof
};
// unknown start eventcopy
// unknown end eventcopy
pub const RawButtonPress = struct {
    deviceid: DeviceId,
    time: u32,
    detail: u32,
    sourceid: DeviceId,
    valuators_len: u16,
    flags: u32,
    valuator_mask: []const u32,
    axisvalues: []const FP3232,
    // unknown start sumof
    // unknown start popcount
    // unknown start listelement-ref
    // unknown end listelement-ref
    // unknown end popcount
    // unknown end sumof
    axisvalues_raw: []const FP3232,
    // unknown start sumof
    // unknown start popcount
    // unknown start listelement-ref
    // unknown end listelement-ref
    // unknown end popcount
    // unknown end sumof
};
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventcopy
// unknown end eventcopy
pub const TouchEventFlags = enum(u32) {
    touch_pending_end: bool = false,
    touch_emulating_pointer: bool = false,
};
pub const TouchBegin = struct {
    deviceid: DeviceId,
    time: u32,
    detail: u32,
    root: Window,
    event: Window,
    child: Window,
    root_x: FP1616,
    root_y: FP1616,
    event_x: FP1616,
    event_y: FP1616,
    buttons_len: u16,
    valuators_len: u16,
    sourceid: DeviceId,
    flags: u32,
    mods: ModifierInfo,
    group: GroupInfo,
    button_mask: []const u32,
    valuator_mask: []const u32,
    axisvalues: []const FP3232,
    // unknown start sumof
    // unknown start popcount
    // unknown start listelement-ref
    // unknown end listelement-ref
    // unknown end popcount
    // unknown end sumof
};
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventcopy
// unknown end eventcopy
pub const TouchOwnershipFlags = enum(u32) {
    none = 0,
};
pub const TouchOwnership = struct {
    deviceid: DeviceId,
    time: u32,
    touchid: u32,
    root: Window,
    event: Window,
    child: Window,
    sourceid: DeviceId,
    flags: u32,
};
pub const RawTouchBegin = struct {
    deviceid: DeviceId,
    time: u32,
    detail: u32,
    sourceid: DeviceId,
    valuators_len: u16,
    flags: u32,
    valuator_mask: []const u32,
    axisvalues: []const FP3232,
    // unknown start sumof
    // unknown start popcount
    // unknown start listelement-ref
    // unknown end listelement-ref
    // unknown end popcount
    // unknown end sumof
    axisvalues_raw: []const FP3232,
    // unknown start sumof
    // unknown start popcount
    // unknown start listelement-ref
    // unknown end listelement-ref
    // unknown end popcount
    // unknown end sumof
};
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventcopy
// unknown end eventcopy
pub const BarrierFlags = enum(u32) {
    pointer_released: bool = false,
    device_is_grabbed: bool = false,
};
pub const BarrierHit = struct {
    deviceid: DeviceId,
    time: u32,
    eventid: u32,
    root: Window,
    event: Window,
    barrier: Barrier,
    dtime: u32,
    flags: u32,
    sourceid: DeviceId,
    root_x: FP1616,
    root_y: FP1616,
    dx: FP3232,
    dy: FP3232,
};
// unknown start eventcopy
// unknown end eventcopy
pub const GesturePinchEventFlags = enum(u32) {
    gesture_pinch_cancelled: bool = false,
};
pub const GesturePinchBegin = struct {
    deviceid: DeviceId,
    time: u32,
    detail: u32,
    root: Window,
    event: Window,
    child: Window,
    root_x: FP1616,
    root_y: FP1616,
    event_x: FP1616,
    event_y: FP1616,
    delta_x: FP1616,
    delta_y: FP1616,
    delta_unaccel_x: FP1616,
    delta_unaccel_y: FP1616,
    scale: FP1616,
    delta_angle: FP1616,
    sourceid: DeviceId,
    mods: ModifierInfo,
    group: GroupInfo,
    flags: u32,
};
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventcopy
// unknown end eventcopy
pub const GestureSwipeEventFlags = enum(u32) {
    gesture_swipe_cancelled: bool = false,
};
pub const GestureSwipeBegin = struct {
    deviceid: DeviceId,
    time: u32,
    detail: u32,
    root: Window,
    event: Window,
    child: Window,
    root_x: FP1616,
    root_y: FP1616,
    event_x: FP1616,
    event_y: FP1616,
    delta_x: FP1616,
    delta_y: FP1616,
    delta_unaccel_x: FP1616,
    delta_unaccel_y: FP1616,
    sourceid: DeviceId,
    mods: ModifierInfo,
    group: GroupInfo,
    flags: u32,
};
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventcopy
// unknown end eventcopy
// unknown start eventstruct
// unknown start allowed
// unknown end allowed
// unknown end eventstruct
pub const SendExtensionEvent = struct { // opcode 31
    destination: Window,
    device_id: u8,
    propagate: bool,
    num_classes: u16,
    num_events: u8,
    events: []const EventForSend,
    classes: []const EventClass,
};
pub const Device = struct {};
pub const Event = struct {};
pub const Mode = struct {};
pub const DeviceBusy = struct {};
pub const Class = struct {};
// unknown end xcb
pub const Opcode = enum(u8) {
    get_extension_version = 1,
    list_input_devices = 2,
    open_device = 3,
    close_device = 4,
    set_device_mode = 5,
    select_extension_event = 6,
    get_selected_extension_events = 7,
    change_device_dont_propagate_list = 8,
    get_device_dont_propagate_list = 9,
    get_device_motion_events = 10,
    change_keyboard_device = 11,
    change_pointer_device = 12,
    grab_device = 13,
    ungrab_device = 14,
    grab_device_key = 15,
    ungrab_device_key = 16,
    grab_device_button = 17,
    ungrab_device_button = 18,
    allow_device_events = 19,
    get_device_focus = 20,
    set_device_focus = 21,
    get_feedback_control = 22,
    change_feedback_control = 23,
    get_device_key_mapping = 24,
    change_device_key_mapping = 25,
    get_device_modifier_mapping = 26,
    set_device_modifier_mapping = 27,
    get_device_button_mapping = 28,
    set_device_button_mapping = 29,
    query_device_state = 30,
    device_bell = 32,
    set_device_valuators = 33,
    get_device_control = 34,
    change_device_control = 35,
    list_device_properties = 36,
    change_device_property = 37,
    delete_device_property = 38,
    get_device_property = 39,
    x_i_query_pointer = 40,
    x_i_warp_pointer = 41,
    x_i_change_cursor = 42,
    x_i_change_hierarchy = 43,
    x_i_set_client_pointer = 44,
    x_i_get_client_pointer = 45,
    x_i_select_events = 46,
    x_i_query_version = 47,
    x_i_query_device = 48,
    x_i_set_focus = 49,
    x_i_get_focus = 50,
    x_i_grab_device = 51,
    x_i_ungrab_device = 52,
    x_i_allow_events = 53,
    x_i_passive_grab_device = 54,
    x_i_passive_ungrab_device = 55,
    x_i_list_properties = 56,
    x_i_change_property = 57,
    x_i_delete_property = 58,
    x_i_get_property = 59,
    x_i_get_selected_events = 60,
    x_i_barrier_release_pointer = 61,
    send_extension_event = 31,
};
