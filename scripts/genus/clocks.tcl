# ----------------------------------------
# Clock constraints
# ----------------------------------------

# Create clocks
set PERIOD_SYNC_CLK 10.000

set DELAY_PC_FD 1.900
set DELAY_FD_DE 2.500
set DELAY_DE_EM 3.200
set DELAY_DE_PC 4.500
set DELAY_EM_MW 1.000
set DELAY_MW_REG 1.700
set DELAY_REG_DE 1.500

set PERIOD_PC_0 [expr 2*${DELAY_DE_PC}]
set PERIOD_FD_1 [expr 2*${DELAY_PC_FD}]
set PERIOD_DE_2 [expr 2*${DELAY_FD_DE}]
set PERIOD_EM_3 [expr 2*${DELAY_DE_EM}]
set PERIOD_MW_4 [expr 2*${DELAY_EM_MW}]
set PERIOD_REG_5 [expr 2*${DELAY_MW_REG}]

# Create clocks
if { ${SYNC_VERSION} == 1 } {
    create_clock -name "clk"         -period ${PERIOD_SYNC_CLK} [get_ports {clk}]
} else {
    create_clock -name "ACLK_PC_0"   -period ${PERIOD_PC_0}   [get_pins uu_ctrlpath/uu_cell_PC/uu_c_element/s]
    # create_clock -name "ACLK_FD_1"   -period ${PERIOD_FD_1}   [get_pins uu_ctrlpath/uu_cell_FD/uu_c_element/s]
    # create_clock -name "ACLK_DE_2"   -period ${PERIOD_DE_2}   [get_pins uu_ctrlpath/uu_cell_DE/uu_c_element/s]
    # create_clock -name "ACLK_EM_3"   -period ${PERIOD_EM_3}   [get_pins uu_ctrlpath/uu_cell_EM/uu_c_element/s]
    # create_clock -name "ACLK_MW_4"   -period ${PERIOD_MW_4}   [get_pins uu_ctrlpath/uu_cell_MW/uu_c_element/s]
    # create_clock -name "ACLK_REG_5"  -period ${PERIOD_REG_5}  [get_pins uu_ctrlpath/uu_cell_REG/uu_c_element/s]

    create_generated_clock -name "ACLK_FD_1"  -source [get_pins uu_ctrlpath/uu_cell_FD/uu_c_element/a]  -combinational [get_pins uu_ctrlpath/uu_cell_FD/uu_c_element/s]
    create_generated_clock -name "ACLK_DE_2"  -source [get_pins uu_ctrlpath/uu_cell_DE/uu_c_element/a]  -combinational [get_pins uu_ctrlpath/uu_cell_DE/uu_c_element/s]
    create_generated_clock -name "ACLK_EM_3"  -source [get_pins uu_ctrlpath/uu_cell_EM/uu_c_element/a]  -combinational [get_pins uu_ctrlpath/uu_cell_EM/uu_c_element/s]
    create_generated_clock -name "ACLK_MW_4"  -source [get_pins uu_ctrlpath/uu_cell_MW/uu_c_element/a]  -combinational [get_pins uu_ctrlpath/uu_cell_MW/uu_c_element/s]
    create_generated_clock -name "ACLK_REG_5" -source [get_pins uu_ctrlpath/uu_cell_REG/uu_c_element/a] -combinational [get_pins uu_ctrlpath/uu_cell_REG/uu_c_element/s]
}

# Set clock groups (synchronous by default)
#if { ${SYNC_VERSION} == 0 } {
#    set_clock_groups -asynchronous -group {ACLK_PC_0 ACLK_FD_1 ACLK_DE_2 ACLK_EM_3 ACLK_MW_4 ACLK_REG_5}
#}

if { ${SYNC_VERSION} == 0 } {
    # Set clock uncertainty
    # Setup set at 10% of clock cycle and hold to 2% of clock cycle, up to a maximum of 230ps (200ps for setup and 30ps for hold)
    set_clock_uncertainty -setup 0.20 [get_clocks {ACLK_PC_0}]
    set_clock_uncertainty -hold  0.01 [get_clocks {ACLK_PC_0}]
    set_clock_uncertainty -setup 0.20 [get_clocks {ACLK_FD_1}]
    set_clock_uncertainty -hold  0.01 [get_clocks {ACLK_FD_1}]
    set_clock_uncertainty -setup 0.20 [get_clocks {ACLK_DE_2}]
    set_clock_uncertainty -hold  0.01 [get_clocks {ACLK_DE_2}]
    set_clock_uncertainty -setup 0.20 [get_clocks {ACLK_EM_3}]
    set_clock_uncertainty -hold  0.01 [get_clocks {ACLK_EM_3}]
    set_clock_uncertainty -setup 0.20 [get_clocks {ACLK_MW_4}]
    set_clock_uncertainty -hold  0.01 [get_clocks {ACLK_MW_4}]
    set_clock_uncertainty -setup 0.20 [get_clocks {ACLK_REG_5}]
    set_clock_uncertainty -hold  0.01 [get_clocks {ACLK_REG_5}]

    # Set clock transition
    # Maximum of 10% of clock period
    set_clock_transition -max 0.050 [get_clocks {ACLK_PC_0}]
    set_clock_transition -min 0.005 [get_clocks {ACLK_PC_0}]
    set_clock_transition -max 0.050 [get_clocks {ACLK_FD_1}]
    set_clock_transition -min 0.005 [get_clocks {ACLK_FD_1}]
    set_clock_transition -max 0.050 [get_clocks {ACLK_DE_2}]
    set_clock_transition -min 0.005 [get_clocks {ACLK_DE_2}]
    set_clock_transition -max 0.050 [get_clocks {ACLK_EM_3}]
    set_clock_transition -min 0.005 [get_clocks {ACLK_EM_3}]
    set_clock_transition -max 0.050 [get_clocks {ACLK_MW_4}]
    set_clock_transition -min 0.005 [get_clocks {ACLK_MW_4}]
    set_clock_transition -max 0.050 [get_clocks {ACLK_REG_5}]
    set_clock_transition -min 0.005 [get_clocks {ACLK_REG_5}]

} else {
    # Set clock uncertainty
    # Setup set at 10% of clock cycle and hold to 2% of clock cycle, up to a maximum of 230ps (200ps for setup and 30ps for hold)
    set_clock_uncertainty -setup 0.20 [get_clocks {clk}]
    set_clock_uncertainty -hold  0.01 [get_clocks {clk}]

    # Set clock transition
    # Maximum of 10% of clock period
    set_clock_transition -max 0.050 [get_clocks {clk}]
    set_clock_transition -min 0.005 [get_clocks {clk}]
}
