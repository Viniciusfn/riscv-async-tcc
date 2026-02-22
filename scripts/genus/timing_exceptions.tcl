# ----------------------------------------
# Timing Exception
# ----------------------------------------

set_false_path -from [get_ports rst_async_n]

if { ${SYNC_VERSION} == 0 } {
    # Setting hold false path to/from capture clocks 
    set_false_path       -from  [get_clocks CAPTURE*]
    set_false_path -hold -to    [get_clocks CAPTURE*]
    # Setting setup false path to/from launch clocks
    set_false_path -setup -from [get_clocks LAUNCH*]
    set_false_path        -to   [get_clocks LAUNCH*]

    # Settting 0-cycle path from all clocks to all clocks
    set_multicycle_path 0  -setup -from [all_clocks] -to [all_clocks]
    set_multicycle_path -1 -hold  -from [all_clocks] -to [all_clocks]

    # Max delays between pipeline stages
    set_max_delay -from [get_clocks ACLK_PC_0] -to [get_clocks CAPTURE_PC_FD] $DELAY_PC_FD
    set_max_delay -from [get_clocks ACLK_FD_1] -to [get_clocks CAPTURE_FD_DE] $DELAY_FD_DE
    set_max_delay -from [get_clocks ACLK_DE_2] -to [get_clocks CAPTURE_DE_EM] $DELAY_DE_EM
    set_max_delay -from [get_clocks ACLK_DE_2] -to [get_clocks CAPTURE_DE_PC] $DELAY_DE_PC
    set_max_delay -from [get_clocks ACLK_EM_3] -to [get_clocks CAPTURE_EM_MW] $DELAY_EM_MW
    set_max_delay -from [get_clocks ACLK_MW_4] -to [get_clocks CAPTURE_MW_REG] $DELAY_MW_REG
    set_max_delay -from [get_clocks ACLK_REG_5] -to [get_clocks CAPTURE_REG_DE] $DELAY_REG_DE

    # Hold constraints
    set_min_delay -from [get_clocks LAUNCH*] 0.100

    #Disabling timing in muller gates to avoid combinational loop breaking
    # set_disable_timing [get_pins -hierarchical *uu_c_element*/a] [get_pins -hierarchical *uu_c_element*/s]
    # set_disable_timing [get_pins -hierarchical *uu_c_element*/b] [get_pins -hierarchical *uu_c_element*/s]
}
