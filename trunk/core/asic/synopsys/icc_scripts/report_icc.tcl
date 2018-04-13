#################################################################################
# LEON3-ASIC Create reports scripts
#
# This file generates the following reports and files:
#
# 1. Timing
#      General Timing
#      SPW IO timing
#      JTAG
#      UART
#      I2C
#      SPI
#      GPIO
#      DSU
#      MCTRL
#      Clock Domain Crossings
# 2. Area
#      General Area
# 3. Power
#      Test Case power report
# 4. Clock Gating
#      Clock gating status and coverage
# 5. Constraint checks
# 6. Design DRC Violations
# 7. Case Analysis in design
#
#################################################################################

#################################################################################
# Report setup for Leon3 ASIC Ref Design
#################################################################################

### create dir
sh mkdir -p icc_reports/$timestamp/$report_run
set report_dir icc_reports/$timestamp/$report_run

#################################################################################
# Start Report timing for Leon3 ASIC Ref Design
#################################################################################

### Report Quality of Result
echo "Info: Generate QoR Reports"
report_qor -summary > $report_dir/qor_$report_run.log

### Check for Design Errors
echo "Info: Generate Design Error Reports"
check_design -summary > $report_dir/check_design_$report_run.log

### General timing report
echo "Info: Generate General Timing Reports"
report_timing -transition_time -capacitance -nosplit -delay max -max_paths 10 > $report_dir/timing_$report_run.log
report_timing -transition_time -capacitance -nosplit -delay min >> $report_dir/timing_$report_run.log

### Area
echo "Info: Check Design Area"
report_area -all       > $report_dir/area_all_$report_run.log
report_area -hierarchy > $report_dir/area_hier_$report_run.log

### Constraints
echo "Info: Check constraints"
report_constraints -all_violators > $report_dir/check_constraints_$report_run.log

### Check design
echo "Info: Check Design"
check_design > $report_dir/check_design_$report_run.log

### Report dont touch nets
report_dont_touch > $report_dir/dont_touch_$report_run.log

### Report clock tree 
report_clock_tree -summary 

### Report size only cells
report_size_only  > $report_dir/size_only_$report_run.log

### Summary report of the design and cells used etc
report_design > $report_dir/report_design_$report_run.log

### Report blocks instantiated etc.
report_reference -hierarchy > $report_dir/report_reference_$report_run.log

### Checks for possible timing problems in the current design.
check_timing -include {unconstrained_endpoints} > $report_dir/check_timing_$report_run.log

### Displays minimum pulse width check information about specified sequential device clock pins.
report_min_pulse_width -all_violators  > $report_dir/report_min_pulse_width_$report_run.log

### Case analysis
#   - Writes sdc files for case analysis in PrimeTime
#   - Only test for worst paths.
#   - SCAN test case anlysis has been moved to external script to be able to create new timing constrints for scan.

# TODO
