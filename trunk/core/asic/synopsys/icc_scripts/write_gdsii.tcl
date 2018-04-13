#################################################################################
#-- File:        write_gdsii.tcl
#-- Description: script for writing gds
#################################################################################
 
save_mw_cel -as crc14
set stream_name crc14
write_stream -format gds -lib_name ./leon3mp_mw_lib -cells {crc14} crc14.gdsii

#Calibre::execCalibreI DRC
