#################################################################################
#-- File:        floorplan.tcl
#-- Description: script for creating floorplan 
#################################################################################

# temp
create_cell {vdd1 vdd2 vdd3 vdd4} PVDD1DGZ
create_cell {vddp1 vddp2 vddp3 vddp4} PVDD2DGZ
create_cell {vss1 vss2 vss3 vss4} PVSS1DGZ
create_cell {vssp1 vssp2 vssp3 vssp4} PVSS2DGZ

create_cell {cornerll cornerlr cornerul cornerur} PCORNER
set_pad_physical_constraints -pad_name "cornerul" -side 1
set_pad_physical_constraints -pad_name "cornerur" -side 2
set_pad_physical_constraints -pad_name "cornerlr" -side 3
set_pad_physical_constraints -pad_name "cornerll" -side 4


#read_def my_final_def.def

# creating floorplan with a chip boundary, core, rows, and wire tracks.
create_floorplan -core_utilization 0.8 -control_type width_and_height -core_width 4618 -core_height 4618 -left_io2core 50 -right_io2core 50 -top_io2core 50 -bottom_io2core 50 -flip_first_row -start_first_row 
#
# Insert the pad fillers to fill the gaps between the pad
insert_pad_filler -cell {PFILLER20 PFILLER10 PFILLER5 PFILLER1 PFILLER05 PFILLER0005 }

# Make the “logical” connection (no physical routing) between power/ground signals and
# all power/ground I/O pads, macros and standard cells
derive_pg_connection -power_net {VDD} -ground_net {VSS} -power_pin {VDD} -ground_pin {VSS}
derive_pg_connection -power_net VDD -ground_net VSS -tie

# there should be no “unconnected” power or ground pins, check with this command:
check_mv_design -power_nets 

#Build the PAD area power supply rings:
#create_pad_rings

#Before performing virtual flat placement set a constraint to prevent standard cells from being placed in narrow channels between macros(<10um):
set_fp_placement_strategy -sliver_size 10
set_fp_placement_strategy -auto_grouping high -macros_on_edge on -sliver_size 10 -virtual_IPO on -min_distance_between_macros 20

#Creates a keepout margin of the specified type for the specified cell or library cell.
set_keepout_margin -type hard -all_macros -outer {20 20 20 20}

# Perform a timing driven non-hierarchical VF placement:
create_fp_placement -timing_driven -no_hierarchy_gravity

# lock down all macros
set_dont_touch_placement [all_macro_cells]
