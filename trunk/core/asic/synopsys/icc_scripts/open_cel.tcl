#################################################################################
#-- File:        open_cel.tcl
#-- Description: Read the cel depending from where you want to load the design
#				 If want to load from start - open leon3mp_dct
#				 Otherwise just open the correct cel and comment sdc and def
#################################################################################

# open milkyway cel 
set icc_input_cel ${top}_mapped
set mw_design_library openmsp430_mw_lib
open_mw_cel $icc_input_cel -library ./$mw_design_library

# read sdc script
read_sdc -echo results/${top}.sdc

# read def / placement fixed
# read_def fixed_placement.def

# read scan def outputted by dc
read_def results/openMSP430_TOP.def -verbose

check_scan_chain
report_scan_chain
