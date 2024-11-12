const std = @import("std");
const parser = @import("parser.zig");
const instruct = @import("instruct.zig");

const CodeGenError = error{
    UnknownInstruction,
};

pub fn generate_inst(inst: parser.TextInstruction, buffer: *std.ArrayList(u8), jump_addresses: *std.StringHashMap(usize), label_addresses: *std.StringHashMap(usize)) !void {
    if (std.mem.eql(u8, inst.opcode, "mov")) {
        //parse r0 to register number (ignore r)
        const r0 = try std.fmt.parseInt(u8, inst.operands[0][1..], 10);
        //parse value
        const value = try std.fmt.parseInt(u8, inst.operands[1], 10);

        const instruction = instruct.Instruction{ .opcode = 0b0001, .r0 = r0, .r1 = 0 };
        try buffer.append(instruct.encode_inst(instruction));
        try buffer.append(value);
    }

    if (std.mem.eql(u8, inst.opcode, "add")) {
        //parse r0 to register number (ignore r)
        const r0 = try std.fmt.parseInt(u8, inst.operands[0][1..], 10);
        //parse r1
        const r1 = try std.fmt.parseInt(u8, inst.operands[1][1..], 10);

        const instruction = instruct.Instruction{ .opcode = 0b0010, .r0 = r0, .r1 = r1 };
        try buffer.append(instruct.encode_inst(instruction));
    }

    if (std.mem.eql(u8, inst.opcode, "sub")) {
        //parse r0 to register number (ignore r)
        const r0 = try std.fmt.parseInt(u8, inst.operands[0][1..], 10);
        //parse r1
        const r1 = try std.fmt.parseInt(u8, inst.operands[1][1..], 10);

        const instruction = instruct.Instruction{ .opcode = 0b0011, .r0 = r0, .r1 = r1 };
        try buffer.append(instruct.encode_inst(instruction));
    }

    if (std.mem.eql(u8, inst.opcode, "mult")) {
        //parse r0 to register number (ignore r)
        const r0 = try std.fmt.parseInt(u8, inst.operands[0][1..], 10);
        //parse r1
        const r1 = try std.fmt.parseInt(u8, inst.operands[1][1..], 10);

        const instruction = instruct.Instruction{ .opcode = 0b0100, .r0 = r0, .r1 = r1 };
        try buffer.append(instruct.encode_inst(instruction));
    }

    if (std.mem.eql(u8, inst.opcode, "div")) {
        //parse r0 to register number (ignore r)
        const r0 = try std.fmt.parseInt(u8, inst.operands[0][1..], 10);
        //parse r1
        const r1 = try std.fmt.parseInt(u8, inst.operands[1][1..], 10);

        const instruction = instruct.Instruction{ .opcode = 0b0101, .r0 = r0, .r1 = r1 };
        try buffer.append(instruct.encode_inst(instruction));
    }

    if (std.mem.eql(u8, inst.opcode, "xor")) {
        //parse r0 to register number (ignore r)
        const r0 = try std.fmt.parseInt(u8, inst.operands[0][1..], 10);
        //parse r1
        const r1 = try std.fmt.parseInt(u8, inst.operands[1][1..], 10);

        const instruction = instruct.Instruction{ .opcode = 0b0111, .r0 = r0, .r1 = r1 };
        try buffer.append(instruct.encode_inst(instruction));
    }

    if (std.mem.eql(u8, inst.opcode, "cmp")) {
        //parse r0 to register number (ignore r)
        const r0 = try std.fmt.parseInt(u8, inst.operands[0][1..], 10);
        //parse r1
        const r1 = try std.fmt.parseInt(u8, inst.operands[1][1..], 10);

        const instruction = instruct.Instruction{ .opcode = 0b1000, .r0 = r0, .r1 = r1 };
        try buffer.append(instruct.encode_inst(instruction));
    }

    if (std.mem.eql(u8, inst.opcode, "label")) {
        //parse r0 to register number (ignore r)
        const label = inst.operands[0];

        try label_addresses.put(label, buffer.items.len);
    }

    if (std.mem.eql(u8, inst.opcode, "jmp")) {
        //parse r0 to register number (ignore r)
        const label = inst.operands[0];

        const mov_inst = instruct.Instruction{ .opcode = 0b0001, .r0 = 3, .r1 = 0 };
        try buffer.append(instruct.encode_inst(mov_inst));

        try jump_addresses.put(label, buffer.items.len);
        try buffer.append(0x00);

        const jump_inst = instruct.Instruction{ .opcode = 0b1001, .r0 = 3, .r1 = 0 };
        try buffer.append(instruct.encode_inst(jump_inst));
    }

    if (std.mem.eql(u8, inst.opcode, "je")) {
        //parse r0 to register number (ignore r)
        const label = inst.operands[0];

        const mov_inst = instruct.Instruction{ .opcode = 0b0001, .r0 = 3, .r1 = 0 };
        try buffer.append(instruct.encode_inst(mov_inst));

        try jump_addresses.put(label, buffer.items.len);
        try buffer.append(0x00);

        const jump_inst = instruct.Instruction{ .opcode = 0b1010, .r0 = 3, .r1 = 0 };
        try buffer.append(instruct.encode_inst(jump_inst));
    }

    if (std.mem.eql(u8, inst.opcode, "jne")) {
        //parse r0 to register number (ignore r)
        const label = inst.operands[0];

        const mov_inst = instruct.Instruction{ .opcode = 0b0001, .r0 = 3, .r1 = 0 };
        try buffer.append(instruct.encode_inst(mov_inst));

        try jump_addresses.put(label, buffer.items.len);
        try buffer.append(0x00);

        const jump_inst = instruct.Instruction{ .opcode = 0b1100, .r0 = 3, .r1 = 0 };
        try buffer.append(instruct.encode_inst(jump_inst));
    }

    if (std.mem.eql(u8, inst.opcode, "out")) {
        //parse r0 to register number (ignore r)
        const r0 = try std.fmt.parseInt(u8, inst.operands[0][1..], 10);

        const instruction = instruct.Instruction{ .opcode = 0b1101, .r0 = r0, .r1 = 0 };
        try buffer.append(instruct.encode_inst(instruction));
    }

    if (std.mem.eql(u8, inst.opcode, "in")) {
        //parse r0 to register number (ignore r)
        const r0 = try std.fmt.parseInt(u8, inst.operands[0][1..], 10);

        const instruction = instruct.Instruction{ .opcode = 0b1110, .r0 = r0, .r1 = 0 };
        try buffer.append(instruct.encode_inst(instruction));
    }

    if (std.mem.eql(u8, inst.opcode, "hlt")) {
        try buffer.append(0xff);
    }
}
