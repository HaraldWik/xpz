const core = @import("core.zig");
const composite = @import("composite.zig");
const Drawable = @import("../root.zig").Drawable;

pub const Damage = enum(u32) {
    _,
};

pub const ReportLevel = enum(u32) {
    raw_rectangles = 0,
    delta_rectangles = 1,
    bounding_box = 2,
    non_empty = 3,
};
pub const BadDamage = struct {};
pub const QueryVersion = struct { // opcode 0
    client_major_version: u32,
    client_minor_version: u32,
    pub const Reply = struct {
        major_version: u32,
        minor_version: u32,
    };
};
pub const Create = struct { // opcode 1
    damage: Damage,
    drawable: Drawable,
    level: u8,
};
pub const Destroy = struct { // opcode 2
    damage: Damage,
};
pub const Subtract = struct { // opcode 3
    damage: Damage,
    repair: composite.Region,
    parts: composite.Region,
};
pub const Add = struct { // opcode 4
    drawable: Drawable,
    region: composite.Region,
};
pub const Notify = struct {
    level: u8,
    drawable: Drawable,
    damage: Damage,
    u32_ms: u32,
    area: core.RECTANGLE,
    geometry: core.RECTANGLE,
    // unknown start see
    // unknown end see
};
// unknown end xcb
pub const Opcode = enum(u8) {
    query_version = 0,
    create = 1,
    destroy = 2,
    subtract = 3,
    add = 4,
};
