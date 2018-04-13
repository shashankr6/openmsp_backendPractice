#################################################################################
#-- File:        placement.tcl
#-- Description: std cell placement 
#################################################################################

#Hook up power pins on all macros and standard cells:
preroute_instances
preroute_standard_cells -connect horizontal  -remove_floating_pieces  -fill_empty_rows  -port_filter_mode off -cell_master_filter_mode off -cell_instance_filter_mode off -voltage_area_filter_mode off -route_type {P/G Std. Cell Pin Conn}

##Prevent standard cell placement under PNS layer:
set_pnet_options -complete {METAL5 METAL6}
create_fp_placement -timing_driven -no_hierarchy_gravity

##Perform global routing:
route_zrt_global

##Fix any timing violations:
optimize_fp_timing -fix_design_rule

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
