const std = @import("std");
const xpz = @import("xpz");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    const address: std.Io.net.UnixAddress = try .init(xpz.Client.default_display_path);
    const stream = try address.connect(io);
    defer stream.close(io);

    var stream_reader_buffer: [256]u8 = undefined;
    var stream_reader = stream.reader(io, &stream_reader_buffer);
    const reader = &stream_reader.interface;

    var stream_writer_buffer: [128]u8 = undefined;
    var stream_writer = stream.writer(io, &stream_writer_buffer);
    const writer = &stream_writer.interface;

    const client: xpz.Client = try .init(io, reader, writer, xpz.Client.Options{
        .auth = .{ .mit_magic_cookie_1 = .{ .xauthority = init.minimal.environ.getPosix("XAUTHORITY").? } },
    });
    _ = client;
}
