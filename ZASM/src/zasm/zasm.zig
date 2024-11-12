const parser = @import("parser.zig");
const codegen = @import("codegen.zig");
const resolver = @import("resolver.zig");
const std = @import("std");

pub fn assemble(src: [][]const u8) !std.ArrayList(u8) {
    var buffer = std.ArrayList(u8).init(std.heap.page_allocator);
    var jump_addresses = std.StringHashMap(usize).init(std.heap.page_allocator);
    defer jump_addresses.deinit();

    var label_addresses = std.StringHashMap(usize).init(std.heap.page_allocator);
    defer label_addresses.deinit();

    var line: usize = 0;
    while (line < src.len) : (line += 1) {
        if (std.mem.eql(u8, src[line], "\x0d")) {
            continue;
        }
        if (std.mem.eql(u8, src[line][0..1], "#")) {
            continue;
        }

        var src_line = src[line];

        if (line == src.len - 1) {
            src_line = src[line][0 .. src[line].len - 1];
        }

        const instruction = try parser.parseInstruction(src_line);
        try codegen.generate_inst(instruction, &buffer, &jump_addresses, &label_addresses);
        try resolver.resolve(&buffer, &jump_addresses, &label_addresses);
    }

    return buffer;
}
