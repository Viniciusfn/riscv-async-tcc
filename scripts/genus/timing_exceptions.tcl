# ----------------------------------------
# Timing Exception
# ----------------------------------------

set_false_path -from [get_ports rst_async_n]

if { ${SYNC_VERSION} == 0 } {
    # Max delays between pipeline stages
    set_max_delay -from [get_clocks ACLK_PC_0] -to [get_clocks ACLK_FD_1] $DELAY_PC_FD
    set_max_delay -from [get_clocks ACLK_FD_1] -to [get_clocks ACLK_DE_2] $DELAY_FD_DE
    set_max_delay -from [get_clocks ACLK_DE_2] -to [get_clocks ACLK_EM_3] $DELAY_DE_EM
    set_max_delay -from [get_clocks ACLK_DE_2] -to [get_clocks ACLK_PC_0] $DELAY_DE_PC
    set_max_delay -from [get_clocks ACLK_EM_3] -to [get_clocks ACLK_MW_4] $DELAY_EM_MW
    set_max_delay -from [get_clocks ACLK_MW_4] -to [get_clocks ACLK_REG_5] $DELAY_MW_REG
    set_max_delay -from [get_clocks ACLK_REG_5] -to [get_clocks ACLK_DE_2] $DELAY_REG_DE

    #Disabling timing in muller gates to avoid combinational loop breaking
    set_disable_timing [get_pins -hierarchical *uu_c_element*/a] [get_pins -hierarchical *uu_c_element*/s]
    set_disable_timing [get_pins -hierarchical *uu_c_element*/b] [get_pins -hierarchical *uu_c_element*/s]
}
