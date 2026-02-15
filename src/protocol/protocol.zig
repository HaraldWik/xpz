pub const core = @import("core.zig");
pub const glx = @import("glx.zig");

pub const common = struct {
    pub const Error = extern struct {
        response_type: core.ReplyHeader.ResponseType, // always 0
        code: u8,
        sequence_number: u16,
        bad_value: u32,
        minor_opcode: u16,
        major_opcode: core.RequestHeader.Opcode,
        pad0: [21]u8,
    };

    pub const Version = extern struct { major: u16, minor: u16 };
};
