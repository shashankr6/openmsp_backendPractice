#################################################################################
#-- File:        cts.tcl
#-- Description: clock tree synthesis script
#################################################################################

#CTS 
set_clock_tree_options -target_skew 0.1
set_clock_uncertainty 0.1 [all_clocks]

#verifiys that spacing values are specified correctly
#report_routing_rule clock_double_spacing 

#Direct CTS to use clock_double_spacing rule on all clock route segments except for the first level sinks which should use default routing rules.
set_clock_tree_options -routing_rule clock_double_spacing -layer_list {METAL3 METAL6} -use_default_routing_for_sinks 1 

#clock tree refs 
set_clock_tree_references -references {CLKBUFX1 CLKBUFX2 CLKBUFX3 CLKBUFX4 CLKBUFX8 CLKBUFX12 CLKBUFX16 CLKBUFX20 CLKBUFXL CLKINVX1 CLKINVX2 CLKINVX3 CLKINVX4 CLKINVX8 CLKINVX12 CLKINVX16 CLKINVX20 CLKINVXL}

# verify that layer available for clock routing and buffers available for CTS have been correctly defined 
#report_clock_tree -settings
#check_physical_design -stage pre_clock_opt -display
check_physical_design -stage pre_clock_opt -output work/cpd/
# set the clock delay calculator to arnoldi(more accurate delay model) 
set_delay_calculation_options -arnoldi_effort medium 
check_clock_tree  

#performs clock tree synthesizing with out any timing optimization or routing
clock_opt -only_cts -no_clock_route 

#report_clock_tree -summary 
#report_timing 

#enable hold time fixing
set_fix_hold [all_clocks] 
set_max_area 0

#Ensure that current RC extraction data is available to capture the more accurate “integrated clock global router” (ICGR) data for clock nets
extract_rc

#Perform post-CTS timing, area and scan chain optimization, without clock routing
clock_opt -only_psyn -area_recovery -optimize_dft -no_clock_route

#This will perform global routing, track assign and detail routing on all the clock nets in the design. =====>>>> NO DRC after routing the clk
route_zrt_group -all_clock_nets -reuse_existing_global_route true
