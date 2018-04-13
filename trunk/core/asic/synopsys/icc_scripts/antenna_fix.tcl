#################################################################################
#-- File:        antenna_fix.tcl
#-- Description: fix antenna violation script 
#################################################################################

# antenna fix
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
