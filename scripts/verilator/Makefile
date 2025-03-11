ROOT_DIR 	:= /home/vini/riscv-async-tcc
TB_NAME  	:= tb_ariscv_ctrlpath
SRC_DIR  	:= $(ROOT_DIR)/rtl/src
TB_DIR		:= $(ROOT_DIR)/rtl/tb
SRC_FILE 	:= $(shell find $(SRC_DIR) -name '*.sv') '$(TB_DIR)/$(TB_NAME).sv'
CPP_WRAPPER	:= --main #$(ROOT_DIR)/scripts/verilator/sim_main.cpp 
WAVE_FILE	:= wave_trace.vcd
COMP_FLAGS 	:= --cc -Wall -Wno-fatal -Wno-TIMESCALEMOD --assert --exe --trace --trace-structs --build --timing

.PHONY: all compile run clean

all: compile run

compile:
	verilator $(COMP_FLAGS) $(CPP_WRAPPER) $(SRC_FILE) -I$(SRC_DIR) --top $(TB_NAME) -j `nproc`

run: compile
	./obj_dir/V$(TB_NAME)

debug:
	gtkwave $(WAVE_FILE)

clean:
	rm -rf obj_dir $(WAVE_FILE)
