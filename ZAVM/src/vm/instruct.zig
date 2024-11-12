pub const Instruction = struct {
    opcode: u8,
    r0: u8,
    r1: u8,
};

pub fn decode_inst(inst: u8) Instruction {
    return Instruction{
        .opcode = (inst >> 4) & 0b1111,
        .r0 = (inst >> 2) & 0b11,
        .r1 = inst & 0b11,
    };
}

pub fn encode_inst(inst: Instruction) u8 {
    return (inst.opcode << 4) | (inst.r0 << 2) | inst.r1;
}
