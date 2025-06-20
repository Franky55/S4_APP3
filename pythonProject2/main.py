import sys

# Register mapping
registers = {
    '$zero': 0, '$at': 1,
    '$v0': 2, '$v1': 3,
    '$a0': 4, '$a1': 5, '$a2': 6, '$a3': 7,
    '$t0': 8, '$t1': 9, '$t2': 10, '$t3': 11,
    '$z0': 12, '$z1': 13, '$z2': 14, '$t7': 15,
    '$s0': 16, '$s1': 17, '$s2': 18, '$s3': 19,
    '$s4': 20, '$s5': 21, '$s6': 22, '$s7': 23,
    '$t8': 24, '$t9': 25,
    '$k0': 26, '$k1': 27,
    '$gp': 28, '$sp': 29, '$fp': 30, '$ra': 31
}

def to_bin(value, bits):
    return format(int(value) & ((1 << bits) - 1), f'0{bits}b')

def parse_register(reg):
    reg = reg.strip().lower()
    if reg not in registers:
        raise ValueError(f"Unknown register: {reg}")
    return registers[reg]

def assemble_instruction(line):
    tokens = line.replace(',', '').split()
    if not tokens:
        return []

    instr = tokens[0].lower()
    hex_instrs = []

    # add $t0, $t1, $t2
    if instr == 'add':
        rd = parse_register(tokens[1])
        rs = parse_register(tokens[2])
        rt = parse_register(tokens[3])
        bin_str = '000000' + to_bin(rs, 5) + to_bin(rt, 5) + to_bin(rd, 5) + '00000' + '100000'
        hex_instrs.append(format(int(bin_str, 2), '08x'))

    # addv $z0, $z1, $z2
    elif instr == 'addv':
        rd = parse_register(tokens[1])
        rs = parse_register(tokens[2])
        rt = parse_register(tokens[3])
        bin_str = '010110' + to_bin(rs, 5) + to_bin(rt, 5) + to_bin(rd, 5) + '00000' + '100000'
        hex_instrs.append(format(int(bin_str, 2), '08x'))

    # minv $z0, $z1, $z1
    elif instr == 'minv':
        rd = parse_register(tokens[1])
        rs = parse_register(tokens[2])
        rt = parse_register(tokens[3])
        bin_str = '010111' + to_bin(rs, 5) + to_bin(rt, 5) + to_bin(rd, 5) + '00000' + '100000'
        hex_instrs.append(format(int(bin_str, 2), '08x'))

    # sw $t0, 0($sp)
    elif instr == 'sw':
        rt = parse_register(tokens[1])
        offset, base = tokens[2].split('(')
        base = parse_register(base.strip(')'))
        imm = int(offset, 0)
        bin_str = '101011' + to_bin(base, 5) + to_bin(rt, 5) + to_bin(imm, 16)
        hex_instrs.append(format(int(bin_str, 2), '08x'))

    # swv $z0, 0($sp)
    elif instr == 'swv':
        rt = parse_register(tokens[1])
        offset, base = tokens[2].split('(')
        base = parse_register(base.strip(')'))
        imm = int(offset, 0)
        bin_str = '010101' + to_bin(base, 5) + to_bin(rt, 5) + to_bin(imm, 16)
        hex_instrs.append(format(int(bin_str, 2), '08x'))

    # lw $t0, 0($sp)
    elif instr == 'lw':
        rt = parse_register(tokens[1])
        offset, base = tokens[2].split('(')
        base = parse_register(base.strip(')'))
        imm = int(offset, 0)
        bin_str = '100011' + to_bin(base, 5) + to_bin(rt, 5) + to_bin(imm, 16)
        hex_instrs.append(format(int(bin_str, 2), '08x'))

    # lwv $z0, 0($sp)
    elif instr == 'lwv':
        rt = parse_register(tokens[1])
        offset, base = tokens[2].split('(')
        base = parse_register(base.strip(')'))
        imm = int(offset, 0)
        bin_str = '010100' + to_bin(base, 5) + to_bin(rt, 5) + to_bin(imm, 16)
        hex_instrs.append(format(int(bin_str, 2), '08x'))

    # addi $t0, $t1, 10
    elif instr == 'addi':
        rt = parse_register(tokens[1])
        rs = parse_register(tokens[2])
        imm = int(tokens[3], 0)
        bin_str = '001000' + to_bin(rs, 5) + to_bin(rt, 5) + to_bin(imm, 16)
        hex_instrs.append(format(int(bin_str, 2), '08x'))

    # li $t0, 0x12345678
    elif instr == 'li':
        rt = parse_register(tokens[1])
        imm = int(tokens[2], 0)
        if -32768 <= imm <= 65535:
            # Can use addi or ori depending on sign
            bin_str = '001001' + to_bin(0, 5) + to_bin(rt, 5) + to_bin(imm, 16)
            hex_instrs.append(format(int(bin_str, 2), '08x'))
        else:
            upper = (imm >> 16) & 0xFFFF
            lower = imm & 0xFFFF
            bin1 = '001111' + to_bin(0, 5) + to_bin(rt, 5) + to_bin(upper, 16)  # lui
            bin2 = '001101' + to_bin(rt, 5) + to_bin(rt, 5) + to_bin(lower, 16)  # ori
            hex_instrs.append(format(int(bin1, 2), '08x'))
            hex_instrs.append(format(int(bin2, 2), '08x'))

    else:
        raise ValueError(f"Unsupported instruction: {instr}")

    return hex_instrs

def assemble_file(input_file, output_file):
    with open(input_file, 'r') as f:
        lines = f.readlines()

    hex_lines = []
    for line in lines:
        line = line.strip()
        if line == '' or line.startswith('#'):
            continue
        try:
            hex_instrs = assemble_instruction(line)
            hex_lines.extend(hex_instrs)
        except Exception as e:
            print(f"Error in line: '{line}' -> {e}")

    # Add the exit syscall instruction at the end
    hex_lines.append('0000000c')

    with open(output_file, 'w') as f:
        for hex_line in hex_lines:
            f.write(f'X"{hex_line}",\n')

if __name__ == '__main__':
    assemble_file('mips1.asm', 'program.hex')