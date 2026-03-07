# ----------------------------------------
# I/O constraints
# ----------------------------------------

# Set I/O delay
# Considering max input and output delay of 20% of clock period

set OUT_IO_MAX_DELAY [expr 0.25*${MEM_IO_DELAY}]
set SYNC_IO_DELAY    [expr 0.2*${PERIOD_SYNC_CLK}]

if { ${SYNC_VERSION} == 0 } {
    set_input_delay  -max ${MEM_IO_DELAY} -clock [get_clocks {ACLK_PC_0}] [get_ports {i_inst}]
    set_input_delay  -min 0.001           -clock [get_clocks {ACLK_PC_0}] [get_ports {i_inst}]

    set_output_delay -max ${OUT_IO_MAX_DELAY} -clock [get_clocks {ACLK_PC_0}] [get_ports {o_pc}]
    set_output_delay -min 0.001          -clock [get_clocks {ACLK_PC_0}] [get_ports {o_pc}]

    set_input_delay  -max ${MEM_IO_DELAY} -clock [get_clocks {ACLK_EM_3}] [get_ports {i_readData}]
    set_input_delay  -min 0.001           -clock [get_clocks {ACLK_EM_3}] [get_ports {i_readData}]
    set_output_delay -max ${OUT_IO_MAX_DELAY} -clock [get_clocks {ACLK_EM_3}] [get_ports {o_mem_clk o_writeData o_writeAddr o_memWrite o_writeWidth}]
    set_output_delay -min 0.001           -clock [get_clocks {ACLK_EM_3}] [get_ports {o_mem_clk o_writeData o_writeAddr o_memWrite o_writeWidth}]

} else {
    set_input_delay  -max ${SYNC_IO_DELAY}  -clock [get_clocks {clk}] [get_ports {i_inst}]
    set_input_delay  -min 0.001             -clock [get_clocks {clk}] [get_ports {i_inst}]
    set_output_delay -max ${SYNC_IO_DELAY}  -clock [get_clocks {clk}] [get_ports {o_pc}]
    set_output_delay -min 0.001             -clock [get_clocks {clk}] [get_ports {o_pc}]

    set_input_delay  -max ${SYNC_IO_DELAY}  -clock [get_clocks {clk}] [get_ports {i_readData}]
    set_input_delay  -min 0.001             -clock [get_clocks {clk}] [get_ports {i_readData}]
    set_output_delay -max ${SYNC_IO_DELAY}  -clock [get_clocks {clk}] [get_ports {o_mem_clk o_writeData o_writeAddr o_memWrite o_writeWidth}]
    set_output_delay -min 0.001             -clock [get_clocks {clk}] [get_ports {o_mem_clk o_writeData o_writeAddr o_memWrite o_writeWidth}]
}
