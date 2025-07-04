const std = @import("std");
const net = std.net;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // On Clever Cloud, the PORT environment variable is set to 8080
    const port_env = std.process.getEnvVarOwned(allocator, "PORT") catch null;
    defer if (port_env) |p| allocator.free(p);
    const port_str = port_env orelse "8080";
    const port = try std.fmt.parseInt(u16, port_str, 10);

    const address = try net.Address.parseIp4("0.0.0.0", port);

    var server = try address.listen(.{
        .reuse_address = true,
    });
    defer server.deinit();

    std.debug.print("Server started on http://0.0.0.0:{d}\n", .{port});

    while (true) {
        const connection = try server.accept();

        handleClient(connection) catch |err| {
            std.debug.print("Error handling request: {}\n", .{err});
        };
    }
}

fn handleClient(connection: net.Server.Connection) !void {
    defer connection.stream.close();

    var buf: [1024]u8 = undefined;

    // Read request (ignored in this simple example)
    _ = try connection.stream.read(&buf);

    const response_body = "Hello, from a Zig web server on Clever Cloud!";
    const response = std.fmt.comptimePrint("HTTP/1.1 200 OK\r\n" ++
        "Content-Type: text/plain; charset=utf-8\r\n" ++
        "Content-Length: {d}\r\n" ++
        "Connection: close\r\n" ++
        "\r\n" ++
        "{s}", .{ response_body.len, response_body });

    _ = try connection.stream.write(response);
}
