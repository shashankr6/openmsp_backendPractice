set tech 180nm
set grtechlibdir "/opt/libs/tsmc180/extracted"
set cell_path "${grtechlibdir}/tsmc/cl018g/sc9_base_rvt/2008q3v01/"
set cell_lib_path "$cell_path/db/"
set io_path "${grtechlibdir}/gpio/TPZ018NV/TS02IG502/fb_tpz018nv_280a_r6p0-02eac0/" 
set io_lib_path "$io_path/timing_power_noise/NLDM/tpz018nv_280a/"
set memory_path "/home/bilgiday/sram_new/" 
set memory_lib_path "$memory_path/db/" 
set grtechlibpath ". $cell_lib_path $io_lib_path $memory_lib_path"

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

set_tlu_plus_files -max_tluplus /home/bilgiday/sram_new/typical.tluplus -min_tluplus /home/bilgiday/sram_new/typical.tluplus -tech2itf_map  /home/bilgiday/sram_new/tluplus.map

# Source paths
set icc_input_cel leon3mp_dct
set mw_design_library leon3mp_mw_lib
open_mw_cel $icc_input_cel -library ./$mw_design_library

read_sdc synopsys/leon3mp_dare.sdc
#read_def command contains both below commands as well as placing all the bonding pads
#create_floorplan -core_utilization 0.8 -control_type width_and_height -core_width 4618 -core_height 4618 -left_io2core 50 -right_io2core 50 -top_io2core 50 -bottom_io2core 50 -flip_first_row -start_first_row 
#insert_pad_filler -cell {PFILLER20 PFILLER10 PFILLER5 PFILLER1 PFILLER05 PFILLER0005 }
read_def my_final_def.def
read_def ./leon3mp_scan.def -verbose
check_scan_chain
report_scan_chain
#########################################################################################################

derive_pg_connection -power_net {VDD} -ground_net {VSS} -power_pin {VDD} -ground_pin {VSS}
derive_pg_connection -power_net VDD -ground_net VSS -tie
# there should be no “unconnected” power or ground pins, check with this command:
check_mv_design -power_nets 
#Build the PAD area power supply rings:
create_pad_rings
#Before performing virtual flat placement set a constraint to prevent standard cells from being placed in narrow channels between macros(<10um):
set_fp_placement_strategy -sliver_size 10
set_fp_placement_strategy -auto_grouping high -macros_on_edge on -sliver_size 10 -virtual_IPO on -min_distance_between_macros 20
#Creates a keepout margin of the specified type for the specified cell or library cell.
set_keepout_margin -type hard -all_macros -outer {20 20 20 20}
create_fp_placement -timing_driven -no_hierarchy_gravity
set_dont_touch_placement [all_macro_cells]

######################################################*****************************************************##############################################################################

#setting some constraints for power network synthesis
#Creating power/ground rings and starps
set_fp_rail_constraints -add_layer  -layer METAL5 -direction horizontal -max_strap 128 -min_strap 16 -max_width 12 -min_width 8 -spacing minimum
set_fp_rail_constraints -add_layer  -layer METAL6 -direction vertical -max_strap 128 -min_strap 16 -max_width 12 -min_width 8 -spacing minimum
set_fp_rail_constraints  -set_ring -nets  {VDD VSS}  -horizontal_ring_layer { METAL5 } -vertical_ring_layer { METAL6 } -ring_max_width 20 -ring_min_width 15 -extend_strap pad_ring 
set_fp_rail_constraints -set_global   -no_routing_over_hard_macros
# Create P/G rings around macros:
set_fp_block_ring_constraints -add -horizontal_layer METAL5 -horizontal_width 8 -horizontal_offset 0.600 -vertical_layer METAL6 -vertical_width 6 -vertical_offset 0.600 -block_type instance  -block  {core0_leon3core0_ahbram0_aram_x0_0_x0_id0 core0_leon3core0_leon3s0_leon3x0_rf0_rhu_x0_x0_id0 core0_leon3core0_ahbram0_aram_x0_0_x0_id0 core0_leon3core0_leon3s0_leon3x0_tbmem0_ram0_1_x0_x0_id0 core0_leon3core0_leon3s0_leon3x0_tbmem0_ram0_0_x0_x0_id0 core0_leon3core0_leon3s0_leon3x0_cmem0_dtags0_0_x0_id0 core0_leon3core0_ahbram0_aram_x0_3_x0_id0 core0_leon3core0_leon3s0_leon3x0_cmem0_idata0_0_x0_id0 core0_leon3core0_ahbram0_aram_x0_1_x0_id0 core0_leon3core0_leon3s0_leon3x0_tbmem0_ram0_1_x1_x0_id0 core0_leon3core0_leon3s0_leon3x0_tbmem0_ram0_0_x1_x0_id0 core0_leon3core0_leon3s0_leon3x0_cmem0_dtags1_0_x0_id0 core0_leon3core0_leon3s0_leon3x0_cmem0_ddata0_0_x0_id0 core0_leon3core0_leon3s0_leon3x0_rf0_rhu_x1_x0_id0 core0_leon3core0_ahbram0_aram_x0_2_x0_id0 core0_leon3core0_ahbram0_aram_x0_0_x0_id1 core0_leon3core0_ahbram0_aram_x0_1_x0_id1 core0_leon3core0_ahbram0_aram_x0_2_x0_id1 core0_leon3core0_ahbram0_aram_x0_3_x0_id1}  -net  {VDD VSS}

synthesize_fp_rail -power_budget {1000} -voltage_supply {1.8} -target_voltage_drop {100} -output_directory {./pna_output} -nets {VDD VSS} -create_virtual_rails {METAL1} -synthesize_power_plan -synthesize_power_pads -use_strap_ends_as_pads -pad_masters {  VDD:PVDD1DGZ.FRAM VSS:PVSS1DGZ.FRAM }
#Build the power network:
commit_fp_rail
#################################################*******************************************************#####################################################################################
#Hook up power pins on all macros and standard cells:
preroute_instances 
preroute_standard_cells -connect horizontal  -remove_floating_pieces  -fill_empty_rows  -port_filter_mode off -cell_master_filter_mode off -cell_instance_filter_mode off -voltage_area_filter_mode off -route_type {P/G Std. Cell Pin Conn}
#Prevent standard cell placement under PNS layer:
set_pnet_options -complete {METAL5 METAL6}
create_fp_placement -timing_driven -no_hierarchy_gravity
#Perform global routing:
route_zrt_global
#Fix any timing violations:
optimize_fp_timing -fix_design_rule
################################################*******************************************************#####################################################################################
#placement
#Apply Non-default routing rules
#use double spacing rule for clock routing
define_routing_rule clock_double_spacing -default_reference_rule  -multiplier_spacing 2 
#verifiys that spacing values are specified correctly
report_routing_rule clock_double_spacing 
#Direct CTS to use clock_double_spacing rule on all clock route segments except for the first level sinks which should use default routing rules.
set_clock_tree_options -routing_rule clock_double_spacing -layer_list {METAL3 METAL6} -use_default_routing_for_sinks 1 
#run placement
place_opt -area_recovery -effort high -congestion -optimize_dft
#Perform incremental logic optimization:
psynopt -area_recovery -power -only_design_rule 
##############################################**********************************************************###################################################################################
#CTS 
set_clock_tree_options -target_skew 0.1
set_clock_uncertainty 0.1 [all_clocks]
#use double spacing rule for clock routing to have better Signal Integrity, lesser cross talk, lesser Noise
define_routing_rule clock_double_spacing -default_reference_rule  -multiplier_spacing 2 
#verifiys that spacing values are specified correctly
report_routing_rule clock_double_spacing 
#Direct CTS to use clock_double_spacing rule on all clock route segments except for the first level sinks which should use default routing rules.
set_clock_tree_options -routing_rule clock_double_spacing -layer_list {METAL3 METAL6} -use_default_routing_for_sinks 1 
# BILGIDAY
set_clock_tree_references -references {CLKBUFX1 CLKBUFX2 CLKBUFX3 CLKBUFX4 CLKBUFX8 CLKBUFX12 CLKBUFX16 CLKBUFX20 CLKBUFXL CLKINVX1 CLKINVX2 CLKINVX3 CLKINVX4 CLKINVX8 CLKINVX12 CLKINVX16 CLKINVX20 CLKINVXL}
#verify that layer available for clock routing and buffers available for CTS have been correctly defined 
report_clock_tree -settings
check_physical_design -stage pre_clock_opt -display
#set the clock delay calculator to arnoldi(more accurate delay model) 
set_delay_calculation_options -arnoldi_effort medium 
check_clock_tree  
#performs clock tree synthesizing with out any timing optimization or routing
clock_opt -only_cts -no_clock_route 
report_clock_tree -summary 
report_timing 
#enable hold time fixing
set_fix_hold [all_clocks] 
set_max_area 0
#Ensure that current RC extraction data is available to capture the more accurate “integrated clock global router” (ICGR) data for clock nets
extract_rc
#Perform post-CTS timing, area and scan chain optimization, without clock routing
clock_opt -only_psyn -area_recovery -optimize_dft -no_clock_route
#This will perform global routing, track assign and detail routing on all the clock nets in the design. =====>>>> NO DRC after routing the clk
route_zrt_group -all_clock_nets -reuse_existing_global_route true
#####################################################****************************************************###############################################################################
#routing
set_route_mode_options -zroute true
#Specifies the effort level used to optimize wire length and  via counts.
set_route_zrt_detail_options -optimize_wire_via_effort_level medium  
#Enables  automatic  redundant  via  insertion  after each detail routing step.
set_route_zrt_common_options -post_detail_route_redundant_via_insertion medium 
#This will perform global routing, track assign and detail routing
route_zrt_auto -max_detail_route_iterations 500 -save_after_detail_route true -save_cell_prefix routed 
#The  route_zrt_eco  command performs ECO routing. It first connects the open nets and then fixes the DRC violations
route_zrt_eco 
derive_pg_connection -power_net {VDD} -ground_net {VSS} -power_pin {VDD} -ground_pin {VSS}
derive_pg_connection -power_net VDD -ground_net VSS -tie
save_mw_cel -as route_eco
########################################################################################
################################################################

#antenna rule check: 

set lib [current_mw_lib]
remove_antenna_rules $lib
define_antenna_rule $lib -mode 1 -diode_mode 4 -metal_ratio 400 -cut_ratio 20
define_antenna_layer_rule $lib -mode 1 -layer "METAL1" -ratio 400 -diode_ratio {0.203 0 400.00  2200}
define_antenna_layer_rule $lib -mode 1 -layer "METAL2" -ratio 400 -diode_ratio {0.203 0 400.00  2200}
define_antenna_layer_rule $lib -mode 1 -layer "METAL3" -ratio 400 -diode_ratio {0.203 0 400.00  2200}
define_antenna_layer_rule $lib -mode 1 -layer "METAL4" -ratio 400 -diode_ratio {0.203 0 400.00  2200}
define_antenna_layer_rule $lib -mode 1 -layer "METAL5" -ratio 400 -diode_ratio {0.203 0 400.00  2200}
define_antenna_layer_rule $lib -mode 1 -layer "METAL6" -ratio 400 -diode_ratio {0.203 0 8000.00 30000}
define_antenna_layer_rule $lib -mode 1 -layer "VIA12" -ratio 20 -diode_ratio {0.203 0 83.33 75}
define_antenna_layer_rule $lib -mode 1 -layer "VIA23" -ratio 20 -diode_ratio {0.203 0 83.33 75}
define_antenna_layer_rule $lib -mode 1 -layer "VIA34" -ratio 20 -diode_ratio {0.203 0 83.33 75}
define_antenna_layer_rule $lib -mode 1 -layer "VIA45" -ratio 20 -diode_ratio {0.203 0 83.33 75}
define_antenna_layer_rule $lib -mode 1 -layer "VIA56" -ratio 20 -diode_ratio {0.203 0 83.33 75}
verify_zrt_route
set_route_zrt_detail_options -insert_diodes_during_routing true
route_zrt_detail -incremental true
#################################################################
#chip finishing
insert_stdcell_filler  -cell_with_metal "FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1"  -connect_to_power {VDD}  -connect_to_ground {VSS} -between_std_cells_only
insert_zrt_redundant_vias -effort medium
insert_metal_filler  -bounding_box { {175.165 168.730} {4672.595 4666.160} }  -out self  -dont_overwrite  -width {poly 0.3} -fill_poly 

################################################################
derive_pg_connection -power_net {VDD} -ground_net {VSS} -power_pin {VDD} -ground_pin {VSS}
derive_pg_connection -power_net VDD -ground_net VSS -tie
save_mw_cel -as final_chip
set_write_stream_options -child_depth 100 -flatten_via -map_layer ~/gdsOutLayer.map
write_stream -format gds -lib_name /home/marjang/fame5/fame_1.3.7/designs/leon3-asic/leon3mp_mw_lib -cells {final_design} final_design.gdsii
