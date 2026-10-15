const std = @import("std");
const Io = std.Io;
const net = Io.net;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    // On Clever Cloud, the PORT environment variable is set to 8080
    const port_str = init.environ_map.get("PORT") orelse "8080";
    const port = try std.fmt.parseInt(u16, port_str, 10);

    const address = try net.IpAddress.parseIp4("0.0.0.0", port);

    var server = try address.listen(io, .{
        .reuse_address = true,
    });
    defer server.deinit(io);

    std.debug.print("Server started on http://0.0.0.0:{d}\n", .{port});

    while (true) {
        const stream = try server.accept(io);

        handleClient(io, stream) catch |err| {
            std.debug.print("Error handling request: {}\n", .{err});
        };
    }
}

fn handleClient(io: Io, stream: net.Stream) !void {
    defer stream.close(io);

    var buf: [1024]u8 = undefined;

    // Read request (ignored in this simple example)
    var stream_reader = stream.reader(io, &buf);
    try stream_reader.interface.fillMore();

    const response_body = "Hello, from a Zig web server on Clever Cloud!";
    const response = std.fmt.comptimePrint("HTTP/1.1 200 OK\r\n" ++
        "Content-Type: text/plain; charset=utf-8\r\n" ++
        "Content-Length: {d}\r\n" ++
        "Connection: close\r\n" ++
        "\r\n" ++
        "{s}", .{ response_body.len, response_body });

    var stream_writer = stream.writer(io, &.{});
    try stream_writer.interface.writeAll(response);
    try stream_writer.interface.flush();
}
