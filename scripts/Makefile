ROOT_DIR    := $(shell pwd)/..
TB_NAME     := tb_ariscv_soc_top
SRC_DIR     := $(ROOT_DIR)/rtl/src
MODEL_DIR   := $(ROOT_DIR)/model
TB_DIR      := $(ROOT_DIR)/rtl/tb
SRC_FILE    := $(shell find $(SRC_DIR) -name '*.sv') $(shell find $(MODEL_DIR) -name '*.sv') $(TB_DIR)/$(TB_NAME).sv
CPP_WRAPPER := --main #$(ROOT_DIR)/scripts/verilator/sim_main.cpp 
WAVE_FILE   := wave_trace.vcd
NO_WARNINGS := -Wno-fatal -Wno-TIMESCALEMOD -Wno-UNOPTFLAT -Wno-IMPORTSTAR -Wno-VARHIDDEN -Wno-UNUSEDSIGNAL -Wno-UNUSEDPARAM
DEFINES_RTL := -DSYNC_RISCV
COMP_FLAGS  := --cc -Wall $(NO_WARNINGS) --assert --no-stop-fail --exe --trace --trace-structs --build --timing $(DEFINES_RTL)
DEFINES_COREMARK := -DBENCHMARK_TEST -DCOREMARK
DEFINES_DHRYSTONE := -DBENCHMARK_TEST -DDHRYSTONE
DEFINES_ISA_TEST := -DISA_TEST
GTKWFILE    := wave_view.gtkw

.PHONY: basic compile_basic run clean coremark

basic: compile_basic run

coremark: compile_coremark run

dhrystone: compile_dhrystone run

isa_test: compile_isa run

compile_basic:
	verilator $(COMP_FLAGS) $(CPP_WRAPPER) $(SRC_FILE) -I$(SRC_DIR) --top $(TB_NAME) -j `nproc`

compile_coremark:
	verilator $(COMP_FLAGS) $(CPP_WRAPPER) $(DEFINES_COREMARK) $(SRC_FILE) -I$(SRC_DIR) --top $(TB_NAME) -j `nproc`

compile_dhrystone:
	verilator $(COMP_FLAGS) $(CPP_WRAPPER) $(DEFINES_DHRYSTONE) $(SRC_FILE) -I$(SRC_DIR) --top $(TB_NAME) -j `nproc`

compile_isa:
	verilator $(COMP_FLAGS) $(CPP_WRAPPER) $(DEFINES_ISA_TEST) $(SRC_FILE) -I$(SRC_DIR) --top $(TB_NAME) -j `nproc`

run:
	./obj_dir/V$(TB_NAME)

debug:
	gtkwave $(WAVE_FILE) -a $(GTKWFILE)

synth:
	rm -rf ../logs/genus/genus.log
	genus -f ../scripts/genus/synth.tcl -log ../logs/genus/genus.log

lec:
	lec -dofile ../scripts/lec/rtl_to_fv_map.tcl -xl -nogui
	lec -dofile ../scripts/lec/fv_map_final.tcl -xl -nogui

clean:
	rm -rf obj_dir *.vcd *.log *.cmd $(WAVE_FILE)
