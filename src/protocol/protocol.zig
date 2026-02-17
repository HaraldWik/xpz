pub const core = @import("core.zig");
pub const big_requests = @compileError("big_requests currently unsupported");
pub const composite = @compileError("composite currently unsupported");
pub const damage = @compileError("damage currently unsupported");
pub const dpms = @compileError("dpms currently unsupported");
pub const draws = @compileError("draws currently unsupported");
pub const glx = @import("glx.zig");
pub const mit_shm = @compileError("mit_shm currently unsupported");
pub const present = @compileError("present currently unsupported");
pub const randr = @import("randr.zig");
pub const record = @compileError("record currently unsupported");
pub const render = @compileError("render currently unsupported");
pub const security = @compileError("security currently unsupported");
pub const shape = @compileError("shape currently unsupported");
pub const sync = @compileError("sync currently unsupported");
pub const x_resource = @compileError("x_resource currently unsupported");
pub const xfixes = @compileError("xfixes currently unsupported");
pub const free86_dga = @compileError("free86_dga currently unsupported");
pub const free86_vid_mode = @compileError("free86_vid_mode currently unsupported");
pub const x_input_extension = @compileError("x_input_extension currently unsupported");
pub const xtest = @compileError("xtest currently unsupported");
pub const xc_misc = @compileError("xc_misc currently unsupported");
pub const xcmisc = @compileError("xcmisc currently unsupported");
pub const xevie = @compileError("xevie currently unsupported");

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

    pub const Length = enum(u16) {
        _,

        pub fn toBytes(self: @This()) usize {
            return @as(usize, @intCast(@intFromEnum(self))) * 4;
        }

        pub fn fromBytes(bytes: usize) @This() {
            return .fromWords(@intCast((bytes) / 4));
        }

        pub fn toWords(self: @This()) u16 {
            return @intFromEnum(self);
        }

        pub fn fromWords(count: u16) @This() {
            return @enumFromInt(count);
        }
    };
};
