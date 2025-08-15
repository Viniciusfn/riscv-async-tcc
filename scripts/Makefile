ROOT_DIR    := $(shell pwd)/..
TB_NAME     := tb_ariscv_soc_top
SRC_DIR     := $(ROOT_DIR)/rtl/src
MODEL_DIR   := $(ROOT_DIR)/model
TB_DIR      := $(ROOT_DIR)/rtl/tb
SRC_FILE    := $(shell find $(SRC_DIR) -name '*.sv') $(shell find $(MODEL_DIR) -name '*.sv') $(TB_DIR)/$(TB_NAME).sv
CPP_WRAPPER := --main #$(ROOT_DIR)/scripts/verilator/sim_main.cpp 
WAVE_FILE   := wave_trace.vcd
NO_WARNINGS := -Wno-fatal -Wno-TIMESCALEMOD -Wno-UNOPTFLAT -Wno-IMPORTSTAR -Wno-VARHIDDEN -Wno-UNUSEDSIGNAL -Wno-UNUSEDPARAM
COMP_FLAGS  := --cc -Wall $(NO_WARNINGS) --assert --no-stop-fail --exe --trace --trace-structs --build --timing
DEFINES_COREMARK := -DCOREMARK_TEST
GTKWFILE    := wave_view.gtkw

.PHONY: all compile run clean coremark

all: compile run

coremark: compile_coremark run

compile:
	verilator $(COMP_FLAGS) $(CPP_WRAPPER) $(SRC_FILE) -I$(SRC_DIR) --top $(TB_NAME) -j `nproc`

compile_coremark:
	verilator $(COMP_FLAGS) $(CPP_WRAPPER) $(DEFINES_COREMARK) $(SRC_FILE) -I$(SRC_DIR) --top $(TB_NAME) -j `nproc`

run:
	./obj_dir/V$(TB_NAME)

debug:
	gtkwave $(WAVE_FILE) -a $(GTKWFILE)

clean:
	rm -rf obj_dir *.vcd *.log $(WAVE_FILE)