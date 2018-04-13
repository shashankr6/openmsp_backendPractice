##############################################################################
#                                                                            #
#                               READ DESING RTL                              #
#                                                                            #
##############################################################################

set DESIGN_NAME      "openMSP430_TOP"
set RTL_SOURCE_FILES {../../rtl/verilog/openMSP430_defines.v
                      ../../rtl/verilog/openMSP430_TOP.v
                      ../../rtl/verilog/openMSP430.v
                      ../../rtl/verilog/omsp_frontend.v
                      ../../rtl/verilog/omsp_execution_unit.v
                      ../../rtl/verilog/omsp_register_file.v
                      ../../rtl/verilog/omsp_alu.v
                      ../../rtl/verilog/omsp_sfr.v
                      ../../rtl/verilog/omsp_clock_module.v
                      ../../rtl/verilog/omsp_mem_backbone.v
                      ../../rtl/verilog/omsp_watchdog.v
                      ../../rtl/verilog/omsp_dbg.v
                      ../../rtl/verilog/omsp_dbg_uart.v
                      ../../rtl/verilog/omsp_dbg_i2c.v
                      ../../rtl/verilog/omsp_dbg_hwbrk.v
                      ../../rtl/verilog/omsp_multiplier.v
                      ../../rtl/verilog/omsp_sync_reset.v
                      ../../rtl/verilog/omsp_sync_cell.v
                      ../../rtl/verilog/omsp_scan_mux.v
                      ../../rtl/verilog/omsp_and_gate.v
                      ../../rtl/verilog/omsp_wakeup_cell.v
                      ../../rtl/verilog/omsp_clock_gate.v
                      ../../rtl/verilog/omsp_clock_mux.v
}

# Shashank - analyze techmap components
set TECHFILES { ../../rtl/tech/tpz018nv.v
}

set PADFILES { ../../rtl/pads/pads.v
               ../../rtl/pads/pads_tsmc180.v
}

define_design_lib techmap -path ./techmap

#analyze -format verilog -work WORK $TECHFILES

set_svf ./results/$DESIGN_NAME.svf
define_design_lib WORK -path ./WORK
analyze -format verilog $RTL_SOURCE_FILES

analyze -format verilog $PADFILES

elaborate $DESIGN_NAME
link


# Check design structure after reading verilog
current_design $DESIGN_NAME
redirect ./results/report.check {check_design}
