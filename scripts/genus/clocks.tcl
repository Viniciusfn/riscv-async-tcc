# ----------------------------------------
# Clock constraints
# ----------------------------------------

# Create clocks
set PERIOD_SYNC_CLK 10.000
set PERIOD_PC_0 50.000
set PERIOD_FD_1 50.000
set PERIOD_DE_2 50.000
set PERIOD_EM_3 50.000
set PERIOD_MW_4 50.000
set PERIOD_REG_5 50.000

# Create clocks
if { ${SYNC_VERSION} == 1 } {
    create_clock -name "clk"         -period ${PERIOD_SYNC_CLK} [get_ports {clk}]
} else {
    create_clock -name "ACLK_PC_0"   -period ${PERIOD_PC_0}   [get_ports {uu_ariscv_ctrlpath/o_aclk[0]}]
    create_clock -name "ACLK_FD_1"   -period ${PERIOD_FD_1}   [get_ports {uu_ariscv_ctrlpath/o_aclk[1]}]
    create_clock -name "ACLK_DE_2"   -period ${PERIOD_DE_2}   [get_ports {uu_ariscv_ctrlpath/o_aclk[2]}]
    create_clock -name "ACLK_EM_3"   -period ${PERIOD_EM_3}   [get_ports {uu_ariscv_ctrlpath/o_aclk[3]}]
    create_clock -name "ACLK_MW_4"   -period ${PERIOD_MW_4}   [get_ports {uu_ariscv_ctrlpath/o_aclk[4]}]
    create_clock -name "ACLK_REG_5"  -period ${PERIOD_REG_5}  [get_ports {uu_ariscv_ctrlpath/o_aclk[5]}]
}

# Set clock groups
if { ${SYNC_VERSION} == 0 } {
    set_clock_groups -asynchronous -group {ACLK_PC_0 ACLK_FD_1 ACLK_DE_2 ACLK_EM_3 ACLK_MW_4 ACLK_REG_5}
}

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
