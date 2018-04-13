#################################################################################
#-- File:        chip_finsh.tcl
#-- Description: script for chip finishing
#################################################################################

# std cell filler
insert_stdcell_filler  -cell_with_metal "FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1"  -connect_to_power {VDD}  -connect_to_ground {VSS} -between_std_cells_only

# insert redundant vias
#insert_zrt_redundant_vias -effort medium

# metal filler
#insert_metal_filler  -bounding_box { {175.165 168.730} {4672.595 4666.160} }  -out self  -dont_overwrite  -width {poly 0.3} -fill_poly 

################################################################
derive_pg_connection -power_net VDD -ground_net VSS -tie

#save_mw_cel -as final_chip

# set gdsii write options
set_write_stream_options -child_depth 100 -flatten_via -map_layer ./gdsOutLayer.map
