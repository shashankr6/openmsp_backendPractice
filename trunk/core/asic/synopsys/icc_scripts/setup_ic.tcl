#################################################################################
#-- File:        setup_ic.tcl
#-- Description: Library setup for ICC Compiler 
#################################################################################

set tech 180nm
set grtechlibdir "/opt/libs/tsmc180/extracted"
set cell_path "${grtechlibdir}/tsmc/cl018g/sc9_base_rvt/2008q3v01/"
set cell_lib_path "$cell_path/db/"
set io_path "${grtechlibdir}/gpio/TPZ018NV/TS02IG502/fb_tpz018nv_280a_r6p0-02eac0/" 
set io_lib_path "$io_path/timing_power_noise/NLDM/tpz018nv_280a/"
set memory_path "/home/bilgiday/sram_new/" 
set memory_lib_path "$memory_path/db/" 
set icc_script_path "./icc_scripts"
set grtechlibpath ". $cell_lib_path $io_lib_path $memory_lib_path $icc_script_path"

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

# Files used for TLUPlus extraction // Note: supported only in topographical mode
set_tlu_plus_files -max_tluplus /home/bilgiday/sram_new/typical.tluplus -min_tluplus /home/bilgiday/sram_new/typical.tluplus -tech2itf_map  /home/bilgiday/sram_new/tluplus.map

if {[info exists top]} {
	puts "INFO: top already set to $top"
} else {
	set top openMSP430_TOP
	puts "INFO: Setting top to $top"
}

if {[info exists work]} {
	puts "INFO: work already set to $work"
} else {
	set work work 
	puts "INFO: Setting work to $work"
}

if {[info exists timestamp]} {
	puts "INFO: timestamp already set to $timestamp"
} else {
	set timestamp [clock format [clock seconds] -format {%m%d_%H%M%S}]
	puts "INFO: Setting timestamp to $timestamp"
}

# create directory if needed
catch {sh mkdir work}
catch {sh mkdir icc_reports}

