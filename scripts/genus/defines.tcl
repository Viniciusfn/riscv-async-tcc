## Set the DESIGN 
set DESIGN ariscv

set SYNC_VERSION 1

# ----------------------------------------
#    Lefs
# ----------------------------------------
set LEF_LIST {/Tools/pdks/gpdk045_v_6_0/gsclib045_all_v4_4/gsclib045_hvt/lef/gsclib045_hvt_macro.lef \
              /Tools/pdks/gpdk045_v_6_0/gsclib045_all_v4_4/gsclib045_lvt/lef/gsclib045_lvt_macro.lef \
              /Tools/pdks/gpdk045_v_6_0/gsclib045_all_v4_4/gsclib045/lef/gsclib045_macro.lef \
              /Tools/pdks/gpdk045_v_6_0/gsclib045_all_v4_4/gsclib045/lef/gsclib045_multibitsDFF.lef \
              /Tools/pdks/gpdk045_v_6_0/gsclib045_all_v4_4/gsclib045/lef/gsclib045_tech.lef }
# ----------------------------------------
#    Libraries
# ----------------------------------------
set LIB_PATH {/Tools/pdks/gpdk045_v_6_0/gsclib045_all_v4_4/ }

# set LIB_LIST { gsclib045/timing/slow_vdd1v0_basicCells.lib }
               #gsclib045_hvt/timing/slow_vdd1v0_basicCells_hvt.lib \
               #gsclib045_lvt/timing/slow_vdd1v0_basicCells_lvt.lib }
               #gsclib045/timing/slow_vdd1v0_extvdd1v2.lib \
               #gsclib045/timing/slow_vdd1v0_extvdd1v0.lib }

set LIB_LIST { gsclib045/timing/slow_vdd1v0_basicCells.lib }

#fast_vdd1v0_basicCells_hvt.lib  fast_vdd1v2_basicCells_hvt.lib  slow_vdd1v0_basicCells_hvt.lib  slow_vdd1v2_basicCells_hvt.lib
#fast_vdd1v0_basicCells_lvt.lib  fast_vdd1v2_basicCells_lvt.lib  slow_vdd1v0_basicCells_lvt.lib  slow_vdd1v2_basicCells_lvt.lib
#fast_vdd1v0_basicCells.lib      fast_vdd1v2_basicCells.lib      slow_vdd1v0_basicCells.lib      slow_vdd1v2_basicCells.lib
#fast_vdd1v0_multibitsDFF.lib    fast_vdd1v2_multibitsDFF.lib    slow_vdd1v0_multibitsDFF.lib    slow_vdd1v2_multibitsDFF.lib
#fast_vdd1v0_extvdd1v2.lib       fast_vdd1v2_extvdd1v2.lib       slow_vdd1v0_extvdd1v2.lib       slow_vdd1v2_extvdd1v2.lib
#fast_vdd1v0_extvdd1v0.lib       fast_vdd1v2_extvdd1v0.lib       slow_vdd1v0_extvdd1v0.lib       slow_vdd1v2_extvdd1v0.lib

# ----------------------------------------
#     RTL
# ----------------------------------------
# Definir GIT_ROOT_PATH usando git
set GIT_ROOT_PATH [exec git rev-parse --show-toplevel]

set RTL_PATH "../rtl/src/"
set RTL_LIST_PATH "../srclists/"
set USE_BLACKBOX_RTL 0

set RTL_LIST_FILE [open "${RTL_LIST_PATH}rtl.lst" r]
set RTL_LIST [read $RTL_LIST_FILE]
close $RTL_LIST_FILE


# Nome do arquivo que contém os caminhos
set RTL_LIST_FILE "${RTL_LIST_PATH}rtl.lst"

# Abra o arquivo e leia todo o conteúdo
set file_id [open $RTL_LIST_FILE r]
set RTL_LIST_FILE [read $file_id]
close $file_id

# Dividir o conteúdo em uma lista de linhas
set RTL_LIST_FILE [split $RTL_LIST_FILE "\n"]
set rtl_srclist {}
# Exemplo de uso direto das variáveis no ambiente
foreach path $RTL_LIST_FILE {
    if {![string is space $path]} {
        # Avaliar o caminho diretamente, expandindo ${GIT_ROOT_PATH}
        set expanded_path [eval subst $path]
        lappend rtl_srclist $expanded_path
        puts "Processing file: $expanded_path"
    }
}

set RTL_LIST_FILE ${rtl_srclist}
# ----------------------------------------
#    Synthesis Execution
# ----------------------------------------
set GNR_SYN_EFFORT high
set MAP_SYN_EFFORT high
set OPT_SYN_EFFORT high

# ----------------------------------------
#    Outputs Generation
# ----------------------------------------
set REPORTS_PATH  ../reports/genus/
set DATABASE_PATH ../db/
set NETLIST_PATH  ../structural/

# Function to check and create directory if not exists
proc ensure_directory_exists {dir} {
    if {![file isdirectory $dir]} {
        puts "Directory $dir does not exist. Creating it..."
        file mkdir $dir
    } else {
        puts "Directory $dir already exists."
    }
}

# Check and create directories
ensure_directory_exists $REPORTS_PATH
ensure_directory_exists $DATABASE_PATH
ensure_directory_exists $NETLIST_PATH

