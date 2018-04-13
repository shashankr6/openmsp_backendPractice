#################################################################################
#-- File:        checks.tcl
#-- Description: script for lvs, drc checks 
#################################################################################

### lvs check
verify_lvs -check_short_locator -check_open_locator

### drc check
verify_drc

### pg check
verify_pg_nets
