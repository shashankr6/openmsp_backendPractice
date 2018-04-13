##############################################################################
#                                                                            #
#                            SPECIFY LIBRARIES                               #
#                                                                            #
##############################################################################

set TSMC_HOME /opt/libs/tsmc180/extracted

# Define worst case library
set LIB_WC_FILE   "sage-x_tsmc_cl018g_rvt_ss_1p62v_125c.db"
set LIB_WC_NAME   "sage-x_tsmc_cl018g_rvt_ss_1p62v_125c.db:sage-x_tsmc_cl018g_rvt_ss_1p62v_125c"

# Define best case library
set LIB_BC_FILE   "sage-x_tsmc_cl018g_rvt_ff_1p98v_m40c.db"
set LIB_BC_NAME   "sage-x_tsmc_cl018g_rvt_ff_1p98v_m40c.db:sage-x_tsmc_cl018g_rvt_ff_1p98v_m40c"

# Define operating conditions
set LIB_WC_OPCON  "ss_1p62v_125c"
set LIB_BC_OPCON  "ff_1p98v_m40c"

# IO libraries
set io_path "${TSMC_HOME}/gpio/TPZ018NV/TS02IG502/fb_tpz018nv_280a_r6p0-02eac0/"
set io_lib_path "$io_path/timing_power_noise/NLDM/tpz018nv_280a/"
set iolib "tpz018nvwc.db"


# Define wire-load model
set LIB_WIRE_LOAD "tsmc18_wl10"

# Define nand2 gate name for aera size calculation
set NAND2_NAME    "NAND2X1"


# Shashank
# Set TSMC home and search path

set_app_var search_path "$TSMC_HOME/tsmc/cl018g/sc9_base_rvt/2008q3v01/db ../rtl $io_lib_path $search_path"

# Set library
set target_library $LIB_WC_FILE
set link_library   "$LIB_WC_FILE $iolib"
set_min_library    $LIB_WC_FILE  -min_version $LIB_BC_FILE



# Milkyway libraries
source ./techscripts/setup_dare.tcl

