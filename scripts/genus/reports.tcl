
report power -verbose	    > ${REPORTS_PATH}${DESIGN}_power.rpt
report timing -lint   	    > ${REPORTS_PATH}${DESIGN}_time.rpt
report timing         	    > ${REPORTS_PATH}${DESIGN}_slack.rpt
report area           	    > ${REPORTS_PATH}${DESIGN}_area.rpt
report gates          	    > ${REPORTS_PATH}${DESIGN}_gates.rpt
report qor            	    > ${REPORTS_PATH}${DESIGN}_qor.rpt
report messages       	    > ${REPORTS_PATH}${DESIGN}_messages.rpt
report summary        	    > ${REPORTS_PATH}${DESIGN}_summary.rpt
report_multibit_inferencing > ${REPORTS_PATH}${DESIGN}_multibit.rpt

if { ${SYNC_VERSION} == 0 } {
    report_timing -from [get_clocks ACLK_PC_0] -to [get_clocks CAPTURE_PC_FD]   -path_type full_clock > ${REPORTS_PATH}dtpath_time_PC_to_FD.rpt
    report_timing -from [get_clocks ACLK_FD_1] -to [get_clocks CAPTURE_FD_DE]   -path_type full_clock > ${REPORTS_PATH}dtpath_time_FD_to_DE.rpt
    report_timing -from [get_clocks ACLK_DE_2] -to [get_clocks CAPTURE_DE_EM]   -path_type full_clock > ${REPORTS_PATH}dtpath_time_DE_to_EM.rpt
    report_timing -from [get_clocks ACLK_DE_2] -to [get_clocks CAPTURE_DE_PC]   -path_type full_clock > ${REPORTS_PATH}dtpath_time_DE_to_PC.rpt
    report_timing -from [get_clocks ACLK_EM_3] -to [get_clocks CAPTURE_EM_MW]   -path_type full_clock > ${REPORTS_PATH}dtpath_time_EM_to_MW.rpt
    report_timing -from [get_clocks ACLK_MW_4] -to [get_clocks CAPTURE_MW_REG]  -path_type full_clock > ${REPORTS_PATH}dtpath_time_MW_to_REG.rpt
    report_timing -from [get_clocks ACLK_REG_5] -to [get_clocks CAPTURE_REG_DE] -path_type full_clock > ${REPORTS_PATH}dtpath_time_REG_to_DE.rpt
    report_timing -from [get_clocks LAUNCH*] -path_type full_clock > ${REPORTS_PATH}hold.rpt
}
