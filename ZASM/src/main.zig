//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.

const std = @import("std");
const zasm = @import("zasm/zasm.zig");
const filetools = @import("filetools.zig");

pub fn main() !void {
    // Get the command-line arguments
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    if (args.len < 2) {
        std.debug.print("Usage: {s} <filename>\n", .{args[0]});
        return;
    }

    const filename = args[1];

    var instructions = std.ArrayList([]const u8).init(std.heap.page_allocator);
    defer instructions.deinit();

    const src = try filetools.read_file(filename);
    var lines = std.mem.splitAny(u8, src, "\n");

    while (lines.next()) |line| {
        try instructions.append(line);
    }

    const program = try zasm.assemble(instructions.items);
    try filetools.write_file("out.bin", program.items);
}
