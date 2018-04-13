#################################################################################
#-- File:        setup_dare.tcl
#-- Author:      Chinmay Deshpande 
#-- Description: Library setup for TSMC 180
#################################################################################

#################################################################################
# Library setup
#################################################################################

# e.g. TSMC180_HOME=/home/chinmay/lib/tsmc180
if {[catch {getenv "TSMC180_HOME"} msg]} {
 echo "ERROR: Enviroment variable TSMC180_HOME should point at a tsmc180 lib installation "
 exit
}

set tech 180nm
set grtechlibdir [getenv {TSMC180_HOME}]
set cell_path "${grtechlibdir}/tsmc/cl018g/sc9_base_rvt/2008q3v01/"
set cell_lib_path "$cell_path/db/"
set io_path "${grtechlibdir}/gpio/TPZ018NV/TS02IG502/fb_tpz018nv_280a_r6p0-02eac0/" 
set io_lib_path "$io_path/timing_power_noise/NLDM/tpz018nv_280a/"
set memory_path "/home/bilgiday/sram_new" 
set memory_lib_path "$memory_path/db/" 
set grtechlibpath ". $cell_lib_path $io_lib_path $memory_lib_path"
set grtechlibpath ". $cell_lib_path $io_lib_path $memory_path"

# Target library - worst case condition - 1.62V 125C
set grtechtargetlib "sage-x_tsmc_cl018g_rvt_ss_1p62v_125c.db"

# IO libary - worst case (wc)
set iolib "tpz018nvwc.db"

# Memory Library - worst case (slow)
set memlib "/home/bilgiday/sram_new/db/sram12x8_slow_syn.db /home/bilgiday/sram_new/db/sram6x26_slow_syn.db /home/bilgiday/sram_new/db/sram8x25_slow_syn.db /home/bilgiday/sram_new/db/sram9x32_slow_syn.db /home/bilgiday/sram_new/db/sram6x32_slow_syn.db /home/bilgiday/sram_new/db/sram8x32_slow_syn.db /home/bilgiday/sram_new/db/sram2p8x32_slow_syn.db /home/bilgiday/sram_new/db/sram13x8_slow_syn.db"

# Link library - worst case condition - wc
set grtechlinklib "$grtechtargetlib $iolib $memlib"

set search_path    $grtechlibpath
set target_library $grtechtargetlib
set link_library   $grtechlinklib

# Technology File
set technology_file_path "$cell_path/milkyway/"
set technology_file "$technology_file_path/tech_sage-x_tsmc_cl018g_6lm.tf"

# Milkyway Reference Library
set std_cell_mw_ref_lib_path $technology_file_path
set std_cell_mw_ref_lib "$std_cell_mw_ref_lib_path/sage-x_tsmc_cl018g_rvt"
set io_mw_ref_lib_path "$io_path/milkyway/"
set io_mw_ref_lib "$io_mw_ref_lib_path/tpz018nv_280a/mt_2/6lm/cell_frame/tpz018nv"
set io_bonding_ref_lib "/opt/libs/tsmc180/extracted/gpio/TPB018NV/TS02IG504/fb_TSMCHOME_tpb018v_140a/digital/Back_End/milkyway/tpb018v_140a/cup/6lm/cell_frame/tpb018v"
set mem_mw_ref_lib_path "$memory_path"
set mem_mw_ref_lib "$memory_path/memories8"


# Milkyway Design
set mw_design_library leon3mp_mw_lib

create_mw_lib -technology $technology_file -mw_reference_library "$std_cell_mw_ref_lib $io_mw_ref_lib $mem_mw_ref_lib $io_bonding_ref_lib" -open $mw_design_library/

### Library rules...

# Library attributes
# e.g. set hdlin_latch_synch_set_reset "false" 

# Don't use list
# e.g set_dont_use lib/TIEH 
#     set_dont_uselib/TIEL
