const std = @import("std");

pub const TextInstruction = struct {
    opcode: []const u8,
    operands: [2][]const u8,
};

pub const Registers = struct {
    r0: u32 = 0,
    r1: u32 = 0,
};

pub fn parseInstruction(line: []const u8) !TextInstruction {
    const trimmed_line = std.mem.trim(u8, line, "\x0D");

    var it = std.mem.tokenizeAny(u8, trimmed_line, " ,");
    const opcode = it.next() orelse return error.InvalidInstruction;
    const operand1 = it.next() orelse "";
    const operand2 = it.next() orelse "";

    return TextInstruction{
        .opcode = opcode,
        .operands = [_][]const u8{ operand1, operand2 },
    };
}
