const std = @import("std");

pub fn read_file(filename: []u8) ![]u8 {
    // Open the file
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    // Read the file content into a buffer
    const file_size = try file.getEndPos();
    var buffer = try std.heap.page_allocator.alloc(u8, file_size);
    defer std.heap.page_allocator.free(buffer);

    const bytes_read = try file.readAll(buffer);

    const output_bytes = try std.heap.page_allocator.alloc(u8, bytes_read + 1);
    std.mem.copyBackwards(u8, output_bytes, buffer[0..bytes_read]);
    return output_bytes;
}

pub fn write_file(filename: []const u8, data: []u8) !void {
    const file = try std.fs.cwd().createFile(filename, .{ .read = false, .truncate = true });
    defer file.close();

    try file.writeAll(data);
}
