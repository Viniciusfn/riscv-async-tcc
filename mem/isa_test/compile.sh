#!/bin/bash

rm -rf rv32i_selftest.elf  rv32i_selftest.o  rv32i_tests.bin

riscv32-unknown-elf-as -march=rv32i -mabi=ilp32 rv32i_selftest.S -o rv32i_selftest.o
riscv32-unknown-elf-ld -Ttext=0x00000000 rv32i_selftest.o -o rv32i_selftest.elf
riscv32-unknown-elf-objcopy -O binary rv32i_selftest.elf rv32i_tests.bin