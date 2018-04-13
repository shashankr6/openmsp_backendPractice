#################################################################################
#-- File:        route.tcl
#-- Description: z-route script 
#################################################################################

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

# derive pg
derive_pg_connection -power_net {VDD} -ground_net {VSS} -power_pin {VDD} -ground_pin {VSS}
derive_pg_connection -power_net VDD -ground_net VSS -tie
