    # rv32i_selftest.S
    # Self-checking RV32I program. On success: writes 1 to 0x00010000 and loops.
    # On failure: writes 0xDEAD to 0x00010000 and loops.
    #
    # Assemble (GNU toolchain example):
    #   riscv32-unknown-elf-as -march=rv32i -mabi=ilp32 rv32i_selftest.S -o rv32i_selftest.o
    #   riscv32-unknown-elf-ld -Ttext=0x00000000 rv32i_selftest.o -o rv32i_selftest.elf
    #   riscv32-unknown-elf-objcopy -O binary rv32i_selftest.elf rv32i_tests.bin
    #
    # The testbench provided expects instruction memory to be initialized from rv32i_tests.bin
    # and watches 0x00010000 for the pass/fail code.

    .option norvc
    .text
    .globl _start
_start:

    # -------- R-type basic --------
    li   x1, 5
    li   x2, 3

    add  x3, x1, x2          # 5 + 3 = 8
    li   x8, 8
    bne  x3, x8, fail

    sub  x4, x1, x2          # 5 - 3 = 2
    li   x9, 2
    bne  x4, x9, fail

    li   x10, 1
    sll  x5, x2, x10         # 3 << 1 = 6
    li   x11, 6
    bne  x5, x11, fail

    slt  x12, x2, x1         # (3 < 5) -> 1
    li   x13, 1
    bne  x12, x13, fail

    li   x6, -1
    sltu x14, x1, x6         # (5 < 0xFFFF_FFFF) -> 1
    li   x15, 1
    bne  x14, x15, fail

    xor  x16, x1, x2         # 5 ^ 3 = 6
    li   x17, 6
    bne  x16, x17, fail

    add  x3, x1, x2          # x3 = 8
    li   x22, 1
    srl  x23, x3, x22        # 8 >> 1 = 4
    li   x24, 4
    bne  x23, x24, fail

    li   x25, -8
    sra  x26, x25, x22       # -8 >> 1 = -4 (arith)
    li   x27, -4
    bne  x26, x27, fail

    or   x18, x1, x2         # 5 | 3 = 7
    li   x19, 7
    bne  x18, x19, fail

    and  x20, x1, x2         # 5 & 3 = 1
    li   x21, 1
    bne  x20, x21, fail

    # -------- I-type arith/logic/shifts --------
    addi x5,  x1, 10         # 5 + 10 = 15
    li   x6,  15
    bne  x5,  x6,  fail

    slti x5,  x1, -3         # (5 < -3) -> 0
    beq  x5,  x0,  1f
    j    fail
1:
    sltiu x5, x0, 1          # (0 < 1) unsigned -> 1
    li   x6,  1
    bne  x5,  x6,  fail

    xori x5,  x1, 0xFF       # 5 ^ 0xFF = 0xFA
    li   x6,  0xFA
    bne  x5,  x6,  fail

    ori  x5,  x0, 0x100      # 0 | 0x100 = 0x100
    li   x6,  0x100
    bne  x5,  x6,  fail

    andi x5,  x19, 0x6       # 7 & 6 = 6
    li   x6,  6
    bne  x5,  x6,  fail

    slli x6,  x1, 2          # 5 << 2 = 20
    li   x7,  20
    bne  x6,  x7,  fail

    srli x6,  x7, 1          # 20 >> 1 = 10
    li   x7,  10
    bne  x6,  x7,  fail

    li   x6,  -8
    srai x6,  x6, 1          # -8 >> 1 = -4
    li   x7,  -4
    bne  x6,  x7,  fail

    # -------- Loads/Stores --------
    # Use a small data area in .bss/.data
    la   x10, data_area
    li   x11, 0x89ABCDEF
    sw   x11, 0(x10)
    lw   x12, 0(x10)
    bne  x11, x12, fail

    li   x11, 0x12345678
    sw   x11, 4(x10)
    lh   x12, 4(x10)         # signed 16
    li   x13, 0x5678
    # Sign adjust if MSB of 16-bit is set (for 0x5678 not needed), but do a simple check:
    bne  x12, x13, fail

    lb   x12, 5(x10)         # byte at 5: 0x56_78 -> 0x56 (signed)
    li   x13, 0x56
    bne  x12, x13, fail

    lhu  x12, 4(x10)         # zero-extended 16-bit
    li   x13, 0x5678
    bne  x12, x13, fail

    lbu  x12, 7(x10)         # last byte of 0x12345678 -> 0x12
    li   x13, 0x12
    bne  x12, x13, fail

    # -------- Branches --------
    li   x1, 10
    li   x2, 10
    beq  x1, x2, 2f
    j    fail
2:
    bne  x1, x2, fail

    li   x1, -1
    li   x2, 1
    blt  x1, x2, 3f          # signed: -1 < 1 taken
    j    fail
3:
    bge  x2, x1, 4f          # 1 >= -1 signed: taken
    j    fail
4:
    bltu x2, x1, fail        # unsigned: 1 < 0xFFFF_FFFF ? taken -> but this would be true; invert to not-taken
    bgeu x1, x2, 5f          # 0xFFFF_FFFF >= 1 unsigned: taken
    j    fail
5:

    # -------- Jumps (JAL / JALR) --------
    la   ra, after_call
    jal  ra, subroutine      # call
    j    fail                # should not reach here, subroutine returns to after_call

after_call:
    # ra should have return addr already; now test JALR for return
    # If we are here, JAL worked.
    # AUIPC/LUI
    auipc x5, 0              # x5 ~= current PC
    lui   x6, 0x12345        # x6 = 0x12345000
    andi  x7, x6, -1
    beq   x7, x0, 6f         # lower 12 bits must be zero
    j     fail
6:

    # -------- SUCCESS --------
pass:                        # write 1 to host
    li   x1, 1
    la   x2, 0x10000
    sw   x1, 0(x2)
    j    done

fail:                        # write 0xDEAD to host
    li   x1, 0xDEAD
    la   x2, 0x10000
    sw   x1, 0(x2)
    j    done

subroutine:
    # simple: return via JALR ra, ra, 0
    jalr x0, ra, 0

done:
    # spin forever
    j    done

    .balign 16
data_area:
    .space 16
