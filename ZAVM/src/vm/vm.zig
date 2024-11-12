const instruct = @import("instruct.zig");
const std = @import("std");

const MemorySize = 256;
pub const Vm = struct {
    memory: [MemorySize]u8,
    registers: [4]u8,
    eq: bool,
    pc: u8,

    pub fn new() @This() {
        return Vm{
            .memory = undefined,
            .registers = .{ 0, 0, 0, 0 },
            .pc = 0,
            .eq = false,
        };
    }

    pub fn load_program(self: *@This(), program: []const u8) void {
        for (program, 0..) |byte, index| {
            self.memory[index] = byte;
        }
    }

    pub fn execute_inst(self: *@This()) !void {
        const instruction = instruct.decode_inst(self.memory[self.pc]);
        switch (instruction.opcode) {
            //mov
            0b0001 => {
                const value = self.memory[self.pc + 1];
                self.registers[instruction.r0] = value;
                self.pc += 1;
            },
            //add
            0b0010 => {
                self.registers[instruction.r0] += self.registers[instruction.r1];
            },
            //sub
            0b0011 => {
                self.registers[instruction.r0] -= self.registers[instruction.r1];
            },
            //mult
            0b0100 => {
                self.registers[instruction.r0] *= self.registers[instruction.r1];
            },
            //div
            0b0101 => {
                self.registers[instruction.r0] /= self.registers[instruction.r1];
            },
            //xor
            0b0111 => {
                self.registers[instruction.r0] ^= self.registers[instruction.r1];
            },
            //cmp
            0b1000 => {
                self.eq = self.registers[instruction.r0] == self.registers[instruction.r1];
            },
            //jmp
            0b1001 => {
                self.pc = self.registers[instruction.r0];
                return;
            },
            // je
            0b1010 => {
                if (self.eq) {
                    self.pc = self.registers[instruction.r0];
                    return;
                }
            },
            // jne
            0b1100 => {
                if (!self.eq) {
                    self.pc = self.registers[instruction.r0];
                    return;
                }
            },
            // out
            0b1101 => {
                std.debug.print("[out]: {d}\n", .{self.registers[instruction.r0]});
            },
            // in
            0b1110 => {
                const stdin = std.io.getStdIn().reader();
                const stdout = std.io.getStdOut().writer();

                try stdout.print("[in]: ", .{});

                var buffer: [10]u8 = undefined;
                const user_input = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
                const input = user_input.?[0 .. user_input.?.len - 1];

                const number = std.fmt.parseInt(u8, input, 10) catch |err| {
                    try stdout.print("Invalid input: {}\n", .{err});
                    return;
                };

                self.registers[instruction.r0] = number;
            },
            else => {},
        }
        self.pc += 1;
    }

    pub fn execute(self: *@This()) !void {
        while (true) {
            if (self.memory[self.pc] == 0xFF or self.pc > (MemorySize - 1)) {
                return;
            }
            try execute_inst(self);
        }
    }
};
