ROOT_DIR 	:= /home/vini/riscv-async-tcc
TB_NAME  	:= tb_wchb_cell
SRC_DIR  	:= $(ROOT_DIR)/rtl/src
TB_DIR		:= $(ROOT_DIR)/rtl/tb
SRC_FILE 	:= $(shell find $(SRC_DIR) -name '*.sv') $(shell find $(TB_DIR) -name '*.sv')
CPP_WRAPPER	:= --main #$(ROOT_DIR)/scripts/verilator/sim_main.cpp
WAVE_FILE	:= wave_trave.vcd
COMP_FLAGS 	:= --cc -Wall -Wno-fatal -Wno-TIMESCALEMOD --assert --exe --trace --trace-structs --build --timing

.PHONY: all run clean

all: compile run clean

compile:
	verilator $(COMP_FLAGS) $(CPP_WRAPPER) $(SRC_FILE) -I$(SRC_DIR) --top $(TB_NAME)  -j `nproc`

run: compile
	./obj_dir/V$(TB_NAME)

debug:
	gtkwave wave_trave.vcd

clean:
	rm -rf obj_dir
