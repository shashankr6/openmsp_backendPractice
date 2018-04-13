#################################################################################
#-- File:        power_network.tcl
#-- Description: Synthesize power network 
#################################################################################

#Creating power/ground rings and starps
set_fp_rail_constraints -add_layer  -layer METAL5 -direction horizontal -max_strap 128 -min_strap 16 -max_width 12 -min_width 8 -spacing minimum
set_fp_rail_constraints -add_layer  -layer METAL6 -direction vertical -max_strap 128 -min_strap 16 -max_width 12 -min_width 8 -spacing minimum
set_fp_rail_constraints  -set_ring -nets  {VDD VSS}  -horizontal_ring_layer { METAL5 } -vertical_ring_layer { METAL6 } -ring_max_width 20 -ring_min_width 15 -extend_strap core_ring 

set_fp_rail_constraints -set_global   -no_routing_over_hard_macros

# Create P/G rings around macros:
#set_fp_block_ring_constraints -add -horizontal_layer METAL5 -horizontal_width 8 -horizontal_offset 0.600 -vertical_layer METAL6 -vertical_width 6 -vertical_offset 0.600 -block_type instance -block {core0_leon3core0_ahbram0_aram_x0_0_x0_id1 core0_leon3core0_ahbram0_aram_x0_0_x0_id0 core0_leon3core0_ahbram0_aram_x0_3_x0_id1 core0_leon3core0_ahbram0_aram_x0_3_x0_id0 core0_leon3core0_ahbram0_aram_x0_2_x0_id1 core0_leon3core0_ahbram0_aram_x0_2_x0_id0 core0_leon3core0_ahbram0_aram_x0_1_x0_id1 core0_leon3core0_ahbram0_aram_x0_1_x0_id0 core0_leon3core0_leon3s0_leon3x0_cmem0_itags0_0_x0_id0 core0_leon3core0_leon3s0_leon3x0_cmem0_dtags0_0_x0_id0 core0_leon3core0_leon3s0_leon3x0_cmem0_idata0_0_x0_id0 core0_leon3core0_leon3s0_leon3x0_cmem0_ddata0_0_x0_id0 core0_leon3core0_leon3s0_leon3x0_rf0_rhu_x0_x0_id0 core0_leon3core0_leon3s0_leon3x0_rf0_rhu_x1_x0_id0 core0_leon3core0_leon3s0_leon3x0_tbmem0_ram0_0_x0_x0_id0 core0_leon3core0_leon3s0_leon3x0_tbmem0_ram0_1_x1_x0_id0 core0_leon3core0_leon3s0_leon3x0_tbmem0_ram0_1_x0_x0_id0 core0_leon3core0_leon3s0_leon3x0_tbmem0_ram0_0_x1_x0_id0} -net {VDD VSS}

# synthesizes power networks or power switch arrays based on user-specified constraints
synthesize_fp_rail -power_budget {1000} -voltage_supply {1.8} -target_voltage_drop {100} -output_directory {./wor/pna_output} -nets {VDD VSS} -create_virtual_rails {METAL1} -synthesize_power_plan -synthesize_power_pads -pad_masters {  VDD:PVDD1DGZ.FRAM VSS:PVSS1DGZ.FRAM }

#Build the power network:
commit_fp_rail
