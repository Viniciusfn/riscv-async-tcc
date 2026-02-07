# ----------------------------------------
# Defines
# ----------------------------------------
source ../scripts/genus/defines.tcl

# ----------------------------------------
# Libraries
# ----------------------------------------
set_db init_lib_search_path $LIB_PATH
read_libs $LIB_LIST 

# set_db [get_db lib_cells */*LVT] .dont_use true

# ----------------------------------------
# Lefs
# ----------------------------------------

# Read LEFs (Techfile and libs)
read_physical -lef "$LEF_LIST"

# Set interconnect mode to PLE to use physical information from LEFs
set_db interconnect_mode ple

# QRC tech file
set_db read_qrc_tech_file_rc_corner true
set_db phys_assume_met_fill 1
#set_db qrc_tech_file /pdk/TSMC/CLN40LP/TSMCHOME/RC_Extraction/RC_QRC_cln12ffc+_1p13m_2xa1xd3xe2y2yy2r_mim_ut-alrdl_DPT_5corners_1.0p1a/rcworst/Tech/rcworst/qrcTechFile

# Use Clock Gate
#set_db lp_insert_clock_gating true

# ----------------------------------------
# RTL
# ----------------------------------------
set_db init_hdl_search_path $RTL_PATH
if { ${SYNC_VERSION} == 1 } {
    read_hdl -language sv $RTL_LIST_FILE -define SYNTHESIS -define PW_AWARE -define SYNC_RISCV
} else {
    read_hdl -language sv $RTL_LIST_FILE -define SYNTHESIS -define PW_AWARE
}

set_db hdl_enable_real_support true
set_db dp_area_mode true
set_db use_area_from_lef true
set_db optimize_net_area true
set_db map_mt_area_opt_cleanup true
elaborate $DESIGN
#suspend

# Seting blackbox in analog blocks

set_db [get_db insts *DONT_TOUCH*] .dont_touch true
set_db [get_db insts *DONT_TOUCH*] .preserve true

# To run hierarchical synthesis, uncomment the line below
set_db auto_ungroup none

# ----------------------------------------
# Constraints
# ----------------------------------------
source ../scripts/genus/clocks.tcl
source ../scripts/genus/io_delays.tcl
source ../scripts/genus/timing_exceptions.tcl

check_design -unresolved > ../reports/genus/unresolved_modules.rpt
report_clocks
report_clocks -generated
report_timing -lint -verbose > ../reports/genus/lint_check.rpt
suspend
# Set up LEC script to use the normal netlists instead of the "fv" directory.
set_db wlec_write_lec_flow true

# ----------------------------------------
# Optimizations
# ----------------------------------------
set_db dp_analytical_opt standard
set_db dp_area_mode true
#set_db dp_rewriting advanced
#set_db dp_sharing advanced
#set_db dp_speculation basic
#set_db iopt_ultra_optimization true
#set_db ultra_global_mapping true
#set_db iopt_sequential_duplication true
#set_db auto_ungroup area
#set_db auto_partition true
#set_db control_logic_optimization advanced
set_db use_multibit_cells true
set_db use_multibit_seq_and_tristate_cells true
set_db multibit_cells_from_different_busses true
set_db multibit_seqs_instance_naming_style auto
set_db multibit_unused_input_value 0
#set_db dp_perform_sharing_operations true
#set_db dp_postmap_downsize true
#set_db optimize_merge_flops true
#set_db lp_insert_operand_isolation false
#set_db optimize_merge_latches false
#set_db remove_assigns true
#set_db use_tiehilo_for_const duplicate
#set_db hdl_preserve_unused_registers true
#set_db hdl_latch_keep_feedback true
#set_db use_scan_seqs_for_non_dft false ;# Disable usage of scan seqs for non-dft paths
set_db multibit_force_logical_second_pass true
# ----------------------------------------
# CTS
# ----------------------------------------

# Delay cells
#set_dont_use [get_lib_cell DEL*]

# Buffer cells
#set_dont_use [get_lib_cell CKB*]
#set_dont_use [get_lib_cell CKN*]
#set_dont_use [get_lib_cell DCCKB*]
#set_dont_use [get_lib_cell DCCKN*]

# AND cells
#set_dont_use [get_lib_cell CKND*]
#set_dont_use [get_lib_cell CKAN*]

# MUX cells
#set_dont_use [get_lib_cell CKMUX*]

# XOR cells
#set_dont_use [get_lib_cell CKXOR*]

# Clock gate cells
#set_dont_use [get_lib_cell CKLNQ*]
#set_dont_use [get_lib_cell CKLHQ*]


# Set dont touch to ClkRstManagerCells

# ----------------------------------------
# Synthesis Execution
# ----------------------------------------
set_db syn_generic_effort ${GNR_SYN_EFFORT}
syn_generic
write_reports -directory ../reports/genus -tag generic

set_db syn_map_effort ${MAP_SYN_EFFORT}
syn_map
write_reports -directory ../reports/genus -tag mapped

# Write do LEC. RTL vs Mapped
write_do_lec -golden_design rtl -revised_design fv_map -logfile ../logs/lec/rtl_to_fv_map.log > ../scripts/lec/rtl_to_fv_map.tcl

set_db syn_opt_effort ${OPT_SYN_EFFORT}
syn_opt
write_reports -directory ../reports/genus -tag placed

# ----------------------------------------
# Reports generation
# ----------------------------------------
source ../scripts/genus/reports.tcl

write_db       ${DATABASE_PATH}${DESIGN}_db_file.db
write_netlist > ${NETLIST_PATH}${DESIGN}_netlist.v
write_sdf     > ${DESIGN}.sdf
#write_sdc     > ${SDC_PATH}${DESIGN}.sdc

# Write do LEC. Mapped vs Placed
write_do_lec -golden_design fv_map -revised_design ${NETLIST_PATH}${DESIGN}_netlist.v -logfile ../logs/lec/fv_map_to_final.log > ../scripts/lec/fv_map_final.tcl

report_sequential -deleted > ../reports/genus/deleted_flops.rpt

# ----------------------------------------
#    Display Information
# ----------------------------------------
puts "Final Runtime & Memory."
time_info FINAL

puts "----------------------------------"
puts "....... Synthesis Finished ......."
puts "----------------------------------"

#exit
