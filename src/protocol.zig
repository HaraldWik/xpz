pub const Setup = struct {
    status: u8,
    pad0: u8,
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
    min_keycode: u8,
    max_keycode: u8,
    pad1: u32,

    pub const Request = extern struct {
        byte_order: u8, // 'l' or 'B'
        pad0: u8 = undefined,
        protocol_major: u16,
        protocol_minor: u16,
        auth_name_len: u16,
        auth_data_len: u16,
        pad1: u16 = undefined,
        // auth_name padded to 4 bytes
        // auth_data padded to 4 bytes
    };

    pub const Failed = struct {
        status: u8,
        reason_len: u8,
        protocol_major_version: u16,
        protocol_minor_version: u16,
        length: u16,
    };
};

pub const setup = struct {
    pub const Request = extern struct {
        byte_order: u8, // 'l' or 'B'
        pad0: u8 = undefined,
        protocol_major: u16,
        protocol_minor: u16,
        auth_name_len: u16,
        auth_data_len: u16,
        pad1: u16 = undefined,
        // auth_name padded to 4 bytes
        // auth_data padded to 4 bytes
    };

    pub const ServerInfo = extern struct {
        release_number: u32,
        resource_id_base: u32,
        resource_id_mask: u32,
        motion_buffer_size: u32,
        vendor_len: u16,
        maximum_request_length: u16,
    };

    pub const PixmapFormat = extern struct {
        depth: u8,
        bits_per_pixel: u8,
        scanline_pad: u8,
        pad: [5]u8,
    };

    pub const Capabilities = extern struct {
        roots_length: u8,
        pixmap_format_count: u8,

        image_byte_order: u8,
        bitmap_format_bit_order: u8,
        bitmap_scanline_unit: u8,
        bitmap_scanline_pad: u8,

        min_keycode: u8,
        max_keycode: u8,

        pad0: u32,
    };
};
