pub const Pixmap = enum(u32) {
    none = 0,
    _,

    pub const Format = extern struct {
        depth: u8,
        bits_per_pixel: u8,
        scanline_pad: u8,
        pad0: u8,
    };
};
