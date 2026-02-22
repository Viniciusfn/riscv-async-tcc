# ----------------------------------------
# Clock constraints
# ----------------------------------------

# Create clocks
set PERIOD_SYNC_CLK 4.000

set DELAY_PC_FD 1.300
set DELAY_FD_DE 2.500
set DELAY_DE_EM 3.200
set DELAY_DE_PC 4.500
set DELAY_EM_MW 0.600
set DELAY_MW_REG 1.600
set DELAY_REG_DE 1.500

set PERIOD_PC_0  0 ;#[expr 2*${DELAY_DE_PC}]
set PERIOD_FD_1  0 ;#[expr 2*${DELAY_PC_FD}]
set PERIOD_DE_2  0 ;#[expr 2*${DELAY_FD_DE}]
set PERIOD_EM_3  0 ;#[expr 2*${DELAY_DE_EM}]
set PERIOD_MW_4  0 ;#[expr 2*${DELAY_EM_MW}]
set PERIOD_REG_5 0 ;#[expr 2*${DELAY_MW_REG}]
set DUMMY_PERIOD 0

set_global timing_enable_genclk_edge_based_source_latency false

# Create clocks
if { ${SYNC_VERSION} == 1 } {
    create_clock -name "clk"         -period ${PERIOD_SYNC_CLK} [get_ports {clk}]
} else {
    ## Local Clock Set (LCS) Strategy ##
    # Points-of-Divergence (PoD): register controllers
    create_clock -name "ACLK_PC_0"   -period ${PERIOD_PC_0}   [get_pins uu_ctrlpath/uu_cell_PC/uu_c_element/s]
    create_clock -name "ACLK_FD_1"   -period ${PERIOD_FD_1}   [get_pins uu_ctrlpath/uu_cell_FD/uu_c_element/s]
    create_clock -name "ACLK_DE_2"   -period ${PERIOD_DE_2}   [get_pins uu_ctrlpath/uu_cell_DE/uu_c_element/s]
    create_clock -name "ACLK_EM_3"   -period ${PERIOD_EM_3}   [get_pins uu_ctrlpath/uu_cell_EM/uu_c_element/s]
    create_clock -name "ACLK_MW_4"   -period ${PERIOD_MW_4}   [get_pins uu_ctrlpath/uu_cell_MW/uu_c_element/s]
    create_clock -name "ACLK_REG_5"  -period ${PERIOD_REG_5}  [get_pins uu_ctrlpath/uu_cell_REG/uu_c_element/s]

    # Dummy clocks
    create_clock -name "DUMMY_LOOP1"   -period ${DUMMY_PERIOD} [get_pins uu_ctrlpath/uu_cell_LOOP1/uu_c_element/s]
    create_clock -name "DUMMY_LOOP2"   -period ${DUMMY_PERIOD} [get_pins uu_ctrlpath/uu_cell_LOOP2/uu_c_element/s]

    # Event Propagation Clocks (EPC)
    create_generated_clock -name "EPC_LOOP1_req" -source [get_pins uu_ctrlpath/uu_cell_LOOP1/uu_c_element/a]   -add -master_clock [get_clocks ACLK_PC_0] -combinational [get_pins uu_ctrlpath/uu_cell_LOOP1/uu_c_element/s]
    create_generated_clock -name "EPC_LOOP1_ack" -source [get_pins uu_ctrlpath/uu_cell_LOOP1/uu_c_element/b]   -add -master_clock [get_clocks ACLK_PC_0] -combinational [get_pins uu_ctrlpath/uu_cell_LOOP1/uu_c_element/s]
    create_generated_clock -name "EPC_LOOP2_req" -source [get_pins uu_ctrlpath/uu_cell_LOOP2/uu_c_element/a]   -add -master_clock [get_clocks ACLK_PC_0] -combinational [get_pins uu_ctrlpath/uu_cell_LOOP2/uu_c_element/s]
    create_generated_clock -name "EPC_LOOP2_ack" -source [get_pins uu_ctrlpath/uu_cell_LOOP2/uu_c_element/b]   -add -master_clock [get_clocks ACLK_PC_0] -combinational [get_pins uu_ctrlpath/uu_cell_LOOP2/uu_c_element/s]
    create_generated_clock -name "EPC_F1_ack0"   -source [get_pins uu_ctrlpath/uu_fork_F1/uu_c_element_fork/a] -add -master_clock [get_clocks ACLK_FD_1] -combinational [get_pins uu_ctrlpath/uu_fork_F1/uu_c_element_fork/s]
    create_generated_clock -name "EPC_F1_ack1"   -source [get_pins uu_ctrlpath/uu_fork_F1/uu_c_element_fork/b] -add -master_clock [get_clocks ACLK_PC_0] -combinational [get_pins uu_ctrlpath/uu_fork_F1/uu_c_element_fork/s]
    create_generated_clock -name "EPC_F2_ack0"   -source [get_pins uu_ctrlpath/uu_fork_F2/uu_c_element_fork/a] -add -master_clock [get_clocks ACLK_PC_0] -combinational [get_pins uu_ctrlpath/uu_fork_F2/uu_c_element_fork/s]
    create_generated_clock -name "EPC_F2_ack1"   -source [get_pins uu_ctrlpath/uu_fork_F2/uu_c_element_fork/b] -add -master_clock [get_clocks ACLK_EM_3] -combinational [get_pins uu_ctrlpath/uu_fork_F2/uu_c_element_fork/s]
    create_generated_clock -name "EPC_J1_req0"   -source [get_pins uu_ctrlpath/uu_join_J1/uu_c_element_join/a] -add -master_clock [get_clocks ACLK_DE_2] -combinational [get_pins uu_ctrlpath/uu_join_J1/uu_c_element_join/s]
    create_generated_clock -name "EPC_J1_req1"   -source [get_pins uu_ctrlpath/uu_join_J1/uu_c_element_join/b] -add -master_clock [get_clocks ACLK_PC_0] -combinational [get_pins uu_ctrlpath/uu_join_J1/uu_c_element_join/s]
    create_generated_clock -name "EPC_J2_req0"   -source [get_pins uu_ctrlpath/uu_join_J2/uu_c_element_join/a] -add -master_clock [get_clocks ACLK_FD_1] -combinational [get_pins uu_ctrlpath/uu_join_J2/uu_c_element_join/s]
    create_generated_clock -name "EPC_J2_req1"   -source [get_pins uu_ctrlpath/uu_join_J2/uu_c_element_join/b] -add -master_clock [get_clocks ACLK_REG_5] -combinational [get_pins uu_ctrlpath/uu_join_J2/uu_c_element_join/s]

    # Launch/Capture Clocks (EPC)
    create_generated_clock -name "CAPTURE_DE_PC" -source [get_pins uu_ctrlpath/uu_cell_PC/uu_c_element/a]  -add -master_clock [get_clocks {ACLK_DE_2}] -combinational [get_pins uu_ctrlpath/uu_cell_PC/uu_c_element/s]
    create_generated_clock -name "LAUNCH_FD_PC"  -source [get_pins uu_ctrlpath/uu_cell_PC/uu_c_element/b]  -add -master_clock [get_clocks {ACLK_FD_1}] -combinational [get_pins uu_ctrlpath/uu_cell_PC/uu_c_element/s]
    create_generated_clock -name "CAPTURE_PC_FD" -source [get_pins uu_ctrlpath/uu_cell_FD/uu_c_element/a]  -add -master_clock [get_clocks {ACLK_PC_0}] -combinational [get_pins uu_ctrlpath/uu_cell_FD/uu_c_element/s]
    create_generated_clock -name "LAUNCH_DE_FD"  -source [get_pins uu_ctrlpath/uu_cell_FD/uu_c_element/b]  -add -master_clock [get_clocks {ACLK_DE_2}] -combinational [get_pins uu_ctrlpath/uu_cell_FD/uu_c_element/s]
    create_generated_clock -name "CAPTURE_FD_DE" -source [get_pins uu_ctrlpath/uu_cell_DE/uu_c_element/a]  -add -master_clock [get_clocks {ACLK_FD_1}] -combinational [get_pins uu_ctrlpath/uu_cell_DE/uu_c_element/s]
    create_generated_clock -name "CAPTURE_REG_DE" -source [get_pins uu_ctrlpath/uu_cell_DE/uu_c_element/a] -add -master_clock [get_clocks {ACLK_REG_5}] -combinational [get_pins uu_ctrlpath/uu_cell_DE/uu_c_element/s]
    create_generated_clock -name "LAUNCH_PC_DE"  -source [get_pins uu_ctrlpath/uu_cell_DE/uu_c_element/b]  -add -master_clock [get_clocks {ACLK_PC_0}] -combinational [get_pins uu_ctrlpath/uu_cell_DE/uu_c_element/s]
    create_generated_clock -name "LAUNCH_EM_DE"  -source [get_pins uu_ctrlpath/uu_cell_DE/uu_c_element/b]  -add -master_clock [get_clocks {ACLK_EM_3}] -combinational [get_pins uu_ctrlpath/uu_cell_DE/uu_c_element/s]
    create_generated_clock -name "CAPTURE_DE_EM" -source [get_pins uu_ctrlpath/uu_cell_EM/uu_c_element/a]  -add -master_clock [get_clocks {ACLK_DE_2}] -combinational [get_pins uu_ctrlpath/uu_cell_EM/uu_c_element/s]
    create_generated_clock -name "LAUNCH_MW_EM"  -source [get_pins uu_ctrlpath/uu_cell_EM/uu_c_element/b]  -add -master_clock [get_clocks {ACLK_MW_4}] -combinational [get_pins uu_ctrlpath/uu_cell_EM/uu_c_element/s]
    create_generated_clock -name "CAPTURE_EM_MW" -source [get_pins uu_ctrlpath/uu_cell_MW/uu_c_element/a]  -add -master_clock [get_clocks {ACLK_EM_3}] -combinational [get_pins uu_ctrlpath/uu_cell_MW/uu_c_element/s]
    create_generated_clock -name "LAUNCH_REG_MW" -source [get_pins uu_ctrlpath/uu_cell_MW/uu_c_element/b]  -add -master_clock [get_clocks {ACLK_REG_5}] -combinational [get_pins uu_ctrlpath/uu_cell_MW/uu_c_element/s]
    create_generated_clock -name "CAPTURE_MW_REG" -source [get_pins uu_ctrlpath/uu_cell_REG/uu_c_element/a] -add -master_clock [get_clocks {ACLK_MW_4}] -combinational [get_pins uu_ctrlpath/uu_cell_REG/uu_c_element/s]
    create_generated_clock -name "LAUNCH_DE_REG" -source [get_pins uu_ctrlpath/uu_cell_REG/uu_c_element/b]  -add -master_clock [get_clocks {ACLK_DE_2}] -combinational [get_pins uu_ctrlpath/uu_cell_REG/uu_c_element/s]
}

# Set clock groups (synchronous by default)
if { ${SYNC_VERSION} == 0 } {
   # Local Clock Sets
   set_clock_groups -asynchronous \
        -group {ACLK_PC_0 CAPTURE_PC* LAUNCH_PC* EPC_LOOP* EPC_F1_ack1 EPC_F2_ack0 EPC_J1_req1} \
        -group {ACLK_FD_1 CAPTURE_FD* LAUNCH_FD* EPC_F1_ack0 EPC_J2_req0} \
        -group {ACLK_DE_2 CAPTURE_DE* LAUNCH_DE* EPC_J1_req0} \
        -group {ACLK_EM_3 CAPTURE_EM* LAUNCH_EM* EPC_F2_ack1} \
        -group {ACLK_MW_4 CAPTURE_MW* LAUNCH_MW*} \
        -group {ACLK_REG_5 CAPTURE_REG* LAUNCH_REG* EPC_J2_req1}
}

if { ${SYNC_VERSION} == 0 } {
    # Set clock uncertainty
    # Setup set at 10% of clock cycle and hold to 2% of clock cycle, up to a maximum of 230ps (200ps for setup and 30ps for hold)
    set_clock_uncertainty -setup 0.10 [get_clocks {*}]
    set_clock_uncertainty -hold  0.01 [get_clocks {*}]

    # Set clock transition
    # Maximum of 10% of clock period
    set_clock_transition -max 0.050 [get_clocks {*}]
    set_clock_transition -min 0.005 [get_clocks {*}]

} else {
    # Set clock uncertainty
    # Setup set at 10% of clock cycle and hold to 2% of clock cycle, up to a maximum of 230ps (200ps for setup and 30ps for hold)
    set_clock_uncertainty -setup 0.10 [get_clocks {clk}]
    set_clock_uncertainty -hold  0.01 [get_clocks {clk}]

    # Set clock transition
    # Maximum of 10% of clock period
    set_clock_transition -max 0.050 [get_clocks {clk}]
    set_clock_transition -min 0.005 [get_clocks {clk}]
}
