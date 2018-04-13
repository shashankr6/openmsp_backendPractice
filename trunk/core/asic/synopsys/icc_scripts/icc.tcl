#################################################################################
#-- File:        icc.tcl
#-- Description: Top level icc script 
#################################################################################

# leon3mp top
set top openMSP430_TOP
set work work

# timestamp info || get runtime
# format -- mmdd_hhmmss
set timestamp [clock format [clock seconds] -format {%m%d_%H%M%S}]
puts $timestamp

# setup library 
source -echo icc_scripts/setup_ic.tcl

# setup library 
source -echo open_cel.tcl

# floorplan
source -echo floorplan.tcl
save_mw_cel -as ${top}_floorplan_$timestamp
 
# power network 
source -echo power_network.tcl
save_mw_cel -as ${top}_pn_$timestamp
 
# placement 
source -echo placement.tcl 
save_mw_cel -as ${top}_placement_$timestamp

# clock tree synthesis 
set report_run ${top}_cts 
#set report_run ${timestamp}_${report_name} 
source -echo cts.tcl
source report_icc.tcl
save_mw_cel -as ${top}_cts_$timestamp

# routing
set report_run ${top}_route
#set report_run ${timestamp}_${report_name} 
source -echo route.tcl
source report_icc.tcl
save_mw_cel -as ${top}_route_$timestamp

# verify
source -echo checks.tcl

# antenna_fix 
set report_run ${top}_postfix
#set report_run ${timestamp}_${report_name} 
source -echo antenna_fix.tcl
source report_icc.tcl
save_mw_cel -as ${top}_postfix_$timestamp

# verify
source -echo checks.tcl

# chip finish 
set report_run ${top}_finish 
#set report_run ${timestamp}_${report_name} 
source -echo chip_finish.tcl
source report_icc.tcl

# verify
source -echo checks.tcl

