pub const core = @import("protocol/core.zig");
pub const composite = @import("protocol/composite.zig");
pub const damage = @import("protocol/damage.zig");
pub const dri3 = @import("protocol/dri3.zig");
pub const glx = @import("protocol/glx.zig");
pub const randr = @import("protocol/randr.zig");
/// Very unstable, not recommended for use
pub const xinput = @import("protocol/xinput.zig");

/// Quite unstable, not recommended for use.
/// This is auto generated and fixed manualy.
/// Beware that all enums are u32's in auto gen which is not the case.
/// Bweware some structures might need specific alignment which auto gen does not handle.
pub const auto_gen = @import("protocol/auto_gen.zig");
