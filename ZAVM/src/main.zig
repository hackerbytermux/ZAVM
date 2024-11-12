const std = @import("std");
const fileutils = @import("filetools.zig");

const VmMod = @import("vm/vm.zig");
const instruct = @import("vm/instruct.zig");

const Vm = VmMod.Vm;

pub fn main() !void {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    if (args.len < 2) {
        std.debug.print("Usage: {s} <filename>\n", .{args[0]});
        return;
    }

    const filename = args[1];

    const program = try fileutils.read_file(filename);

    var vm = Vm.new();
    vm.load_program(program);
    try vm.execute();
}
