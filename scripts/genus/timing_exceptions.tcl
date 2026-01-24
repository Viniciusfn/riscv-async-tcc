# ----------------------------------------
# Timing Exception
# ----------------------------------------

set DELAY_PC_FD 16.000
set DELAY_FD_DE 28.000
set DELAY_DE_EM 38.000
set DELAY_DE_PC 38.000
set DELAY_EM_MW 28.000
set DELAY_MW_REG 38.000
set DELAY_REG_DE 28.000

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
    set_disable_timing -from [get_pins -hierarchical -filter {NAME =~ "*uu_c_element/a*"}] -to [get_pins -hierarchical -filter {NAME =~ "*uu_c_element/s*"}]
    set_disable_timing -from [get_pins -hierarchical -filter {NAME =~ "*uu_c_element/b*"}] -to [get_pins -hierarchical -filter {NAME =~ "*uu_c_element/s*"}]
}
