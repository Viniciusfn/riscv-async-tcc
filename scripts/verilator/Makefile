ROOT_DIR 	:= /home/vini/riscv-async-tcc
TB_NAME  	:= tb_ariscv
SRC_DIR  	:= $(ROOT_DIR)/rtl/src
TB_DIR		:= $(ROOT_DIR)/rtl/tb
SRC_FILE 	:= $(shell find $(SRC_DIR) -name '*.sv') '$(TB_DIR)/$(TB_NAME).sv'
CPP_WRAPPER	:= --main #$(ROOT_DIR)/scripts/verilator/sim_main.cpp 
WAVE_FILE	:= wave_trace.vcd
NO_WARNINGS := -Wno-fatal -Wno-TIMESCALEMOD -Wno-UNOPTFLAT -Wno-IMPORTSTAR -Wno-VARHIDDEN
COMP_FLAGS 	:= --cc -Wall $(NO_WARNINGS) --assert --no-stop-fail --exe --trace --trace-structs --build --timing
GTKWFILE 	:= wave_view.gtkw

.PHONY: all compile run clean

all: compile run

compile:
	verilator $(COMP_FLAGS) $(CPP_WRAPPER) $(SRC_FILE) -I$(SRC_DIR) --top $(TB_NAME) -j `nproc`

run: compile
	./obj_dir/V$(TB_NAME)

debug:
	gtkwave $(WAVE_FILE) -a $(GTKWFILE)

clean:
	rm -rf obj_dir $(WAVE_FILE)
