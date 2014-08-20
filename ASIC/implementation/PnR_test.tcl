
set_app_var search_path [concat $search_path "/u/synopsys/saed/saed_mc/etc/techs/SAED_PDK_32/SAED_PDK_32_28/"]

# Standard cells databases
#	Use class.db for student cells
#	Use ... arm cells for production cells
set link_library "class.db"
set target_library "class.db"

#create_mw_lib -tech /opt/synopsys/saed/saed_mc/etc/techs/SAED_PDK_32/techfiles/saed32nm_1p9m_mw.tf -mw_reference_library /opt/synopsys/saed/saed_mc/etc/techs/SAED_PDK_32/techfiles/saed32nm_1p9m_mw My_lib.mw

sh rm -rf My_lib
create_mw_lib -tech /u/synopsys/saed/SAED32_EDK/tech//milkyway/saed32nm_1p9m_mw.tf -bus_naming_style {[%d]} -mw_reference_library /u/synopsys/icc/I-2013.12-SP2/libraries/syn/class.lib My_lib

#open_mw_lib /u/synopsys/saed/SAED32_EDK/lib/stdcell_hvt/milkyway/saed32nm_hvt_1p9m  

open_mw_lib My_lib

read_verilog ../synthesis/TinyORAMCore/TinyORAMCore.gate.v 
read_sdc ../synthesis/TinyORAMCore/TinyORAMCore.sdc

close_mw_lib My_lib


