# ----------------------------------------
# I/O constraints
# ----------------------------------------

# Set I/O delay
# Considering max input and output delay of 20% of clock period

set PC_IO_DELAY      [expr 0.2*${PERIOD_PC_0}]
set MEM_IO_DELAY     [expr 0.2*${PERIOD_MW_4}]

set_input_delay  -max ${PC_IO_DELAY} -clock [get_clocks {ACLK_PC_0}] [get_ports {i_inst}]
set_input_delay  -min 0.001          -clock [get_clocks {ACLK_PC_0}] [get_ports {i_inst}]
set_output_delay -max ${PC_IO_DELAY} -clock [get_clocks {ACLK_PC_0}] [get_ports {o_pc}]
set_output_delay -min 0.001          -clock [get_clocks {ACLK_PC_0}] [get_ports {o_pc}]


set_input_delay  -max ${MEM_IO_DELAY} -clock [get_clocks {ACLK_MW_4}] [get_ports {i_readData}]
set_input_delay  -min 0.001           -clock [get_clocks {ACLK_MW_4}] [get_ports {i_readData}]
set_output_delay -max ${MEM_IO_DELAY} -clock [get_clocks {ACLK_MW_4}] [get_ports {o_mem_clk o_writeData o_writeAddr o_memWrite o_writeWidth}]
set_output_delay -min 0.001           -clock [get_clocks {ACLK_MW_4}] [get_ports {o_mem_clk o_writeData o_writeAddr o_memWrite o_writeWidth}]
