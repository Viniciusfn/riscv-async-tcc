## Set the DESIGN 
set DESIGN ariscv 

# ----------------------------------------
#    Lefs
# ----------------------------------------
set LEF_TECH ""
set LEF_TECH {/pdk/TSMC/CLN28HPC+/arp_tech_file/tn28clpr002e1_1_9_1a/PRTF_EDI_28nm_Cad_V19_1a/PRTF_EDI_28nm_Cad_V19_1a/PR_tech/Cadence/LefHeader/HVH/tsmcn28_7lm4X1YZ1ZRDL.tlef}

set LEF_LIST {/pdk/TSMC/CLN28HPC+/TSMCHOME/digital/Back_End/lef/tcbn28hpcplusbwp7t30p140mbuhvt_150a/lef/tcbn28hpcplusbwp7t30p140mbuhvt.lef \
              /pdk/TSMC/CLN28HPC+/TSMCHOME/digital/Back_End/lef/tcbn28hpcplusbwp7t30p140uhvt_140b/lef/tcbn28hpcplusbwp7t30p140uhvt.lef     \
              /pdk/TSMC/CLN28HPC+/TSMCHOME/digital/Back_End/lef/tcbn28hpcplusbwp7t40p140ehvt_110a/lef/tcbn28hpcplusbwp7t40p140ehvt.lef }
# ----------------------------------------
#    Libraries
# ----------------------------------------
set LIB_PATH {/pdk/TSMC/CLN28HPC+/TSMCHOME/digital/Front_End/timing_power_noise/CCS/ }

set LIB_LIST { tcbn28hpcplusbwp7t30p140mbuhvt_170a/tcbn28hpcplusbwp7t30p140mbuhvtssg0p81v0c_ccs.lib \
               tcbn28hpcplusbwp7t30p140uhvt_180b/tcbn28hpcplusbwp7t30p140uhvtssg0p81v0c_ccs.lib     \
               tcbn28hpcplusbwp7t40p140ehvt_170a/tcbn28hpcplusbwp7t40p140ehvtssg0p81v0c_ccs.lib }

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

