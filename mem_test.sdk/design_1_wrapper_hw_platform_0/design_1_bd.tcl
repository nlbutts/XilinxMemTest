
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: crack1
proc create_hier_cell_crack1 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_crack1() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S00_AXIS

  # Create pins
  create_bd_pin -dir I -type clk m_axis_aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst m_axis_aresetn

  # Create instance: axis_switch_0, and set properties
  set axis_switch_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_0 ]
  set_property -dict [ list \
CONFIG.DECODER_REG {1} \
CONFIG.NUM_MI {16} \
CONFIG.NUM_SI {1} \
 ] $axis_switch_0

  # Create instance: axis_switch_1, and set properties
  set axis_switch_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_1 ]
  set_property -dict [ list \
CONFIG.ARB_ON_MAX_XFERS {5} \
CONFIG.DECODER_REG {0} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {16} \
 ] $axis_switch_1

  # Create instance: sha1_0, and set properties
  set sha1_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_0 ]

  # Create instance: sha1_1, and set properties
  set sha1_1 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_1 ]

  # Create instance: sha1_2, and set properties
  set sha1_2 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_2 ]

  # Create instance: sha1_3, and set properties
  set sha1_3 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_3 ]

  # Create instance: sha1_4, and set properties
  set sha1_4 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_4 ]

  # Create instance: sha1_5, and set properties
  set sha1_5 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_5 ]

  # Create instance: sha1_6, and set properties
  set sha1_6 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_6 ]

  # Create instance: sha1_7, and set properties
  set sha1_7 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_7 ]

  # Create instance: sha1_8, and set properties
  set sha1_8 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_8 ]

  # Create instance: sha1_9, and set properties
  set sha1_9 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_9 ]

  # Create instance: sha1_10, and set properties
  set sha1_10 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_10 ]

  # Create instance: sha1_11, and set properties
  set sha1_11 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_11 ]

  # Create instance: sha1_12, and set properties
  set sha1_12 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_12 ]

  # Create instance: sha1_13, and set properties
  set sha1_13 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_13 ]

  # Create instance: sha1_14, and set properties
  set sha1_14 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_14 ]

  # Create instance: sha1_15, and set properties
  set sha1_15 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_15 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_fifo_mm_s_0_AXI_STR_TXD [get_bd_intf_pins S00_AXIS] [get_bd_intf_pins axis_switch_0/S00_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M00_AXIS [get_bd_intf_pins axis_switch_0/M00_AXIS] [get_bd_intf_pins sha1_0/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M01_AXIS [get_bd_intf_pins axis_switch_0/M01_AXIS] [get_bd_intf_pins sha1_1/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M02_AXIS [get_bd_intf_pins axis_switch_0/M02_AXIS] [get_bd_intf_pins sha1_2/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M03_AXIS [get_bd_intf_pins axis_switch_0/M03_AXIS] [get_bd_intf_pins sha1_3/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M04_AXIS [get_bd_intf_pins axis_switch_0/M04_AXIS] [get_bd_intf_pins sha1_4/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M05_AXIS [get_bd_intf_pins axis_switch_0/M05_AXIS] [get_bd_intf_pins sha1_5/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M06_AXIS [get_bd_intf_pins axis_switch_0/M06_AXIS] [get_bd_intf_pins sha1_6/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M07_AXIS [get_bd_intf_pins axis_switch_0/M07_AXIS] [get_bd_intf_pins sha1_7/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M08_AXIS [get_bd_intf_pins axis_switch_0/M08_AXIS] [get_bd_intf_pins sha1_8/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M09_AXIS [get_bd_intf_pins axis_switch_0/M09_AXIS] [get_bd_intf_pins sha1_9/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M10_AXIS [get_bd_intf_pins axis_switch_0/M10_AXIS] [get_bd_intf_pins sha1_10/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M11_AXIS [get_bd_intf_pins axis_switch_0/M11_AXIS] [get_bd_intf_pins sha1_11/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M12_AXIS [get_bd_intf_pins axis_switch_0/M12_AXIS] [get_bd_intf_pins sha1_12/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M13_AXIS [get_bd_intf_pins axis_switch_0/M13_AXIS] [get_bd_intf_pins sha1_13/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M14_AXIS [get_bd_intf_pins axis_switch_0/M14_AXIS] [get_bd_intf_pins sha1_14/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M15_AXIS [get_bd_intf_pins axis_switch_0/M15_AXIS] [get_bd_intf_pins sha1_15/datain]
  connect_bd_intf_net -intf_net axis_switch_1_M00_AXIS [get_bd_intf_pins M00_AXIS] [get_bd_intf_pins axis_switch_1/M00_AXIS]
  connect_bd_intf_net -intf_net sha1_0_dataout [get_bd_intf_pins axis_switch_1/S00_AXIS] [get_bd_intf_pins sha1_0/dataout]
  connect_bd_intf_net -intf_net sha1_10_dataout [get_bd_intf_pins axis_switch_1/S10_AXIS] [get_bd_intf_pins sha1_10/dataout]
  connect_bd_intf_net -intf_net sha1_11_dataout [get_bd_intf_pins axis_switch_1/S11_AXIS] [get_bd_intf_pins sha1_11/dataout]
  connect_bd_intf_net -intf_net sha1_12_dataout [get_bd_intf_pins axis_switch_1/S12_AXIS] [get_bd_intf_pins sha1_12/dataout]
  connect_bd_intf_net -intf_net sha1_13_dataout [get_bd_intf_pins axis_switch_1/S13_AXIS] [get_bd_intf_pins sha1_13/dataout]
  connect_bd_intf_net -intf_net sha1_14_dataout [get_bd_intf_pins axis_switch_1/S14_AXIS] [get_bd_intf_pins sha1_14/dataout]
  connect_bd_intf_net -intf_net sha1_15_dataout [get_bd_intf_pins axis_switch_1/S15_AXIS] [get_bd_intf_pins sha1_15/dataout]
  connect_bd_intf_net -intf_net sha1_1_dataout [get_bd_intf_pins axis_switch_1/S01_AXIS] [get_bd_intf_pins sha1_1/dataout]
  connect_bd_intf_net -intf_net sha1_2_dataout [get_bd_intf_pins axis_switch_1/S02_AXIS] [get_bd_intf_pins sha1_2/dataout]
  connect_bd_intf_net -intf_net sha1_3_dataout [get_bd_intf_pins axis_switch_1/S03_AXIS] [get_bd_intf_pins sha1_3/dataout]
  connect_bd_intf_net -intf_net sha1_4_dataout [get_bd_intf_pins axis_switch_1/S04_AXIS] [get_bd_intf_pins sha1_4/dataout]
  connect_bd_intf_net -intf_net sha1_5_dataout [get_bd_intf_pins axis_switch_1/S05_AXIS] [get_bd_intf_pins sha1_5/dataout]
  connect_bd_intf_net -intf_net sha1_6_dataout [get_bd_intf_pins axis_switch_1/S06_AXIS] [get_bd_intf_pins sha1_6/dataout]
  connect_bd_intf_net -intf_net sha1_7_dataout [get_bd_intf_pins axis_switch_1/S07_AXIS] [get_bd_intf_pins sha1_7/dataout]
  connect_bd_intf_net -intf_net sha1_8_dataout [get_bd_intf_pins axis_switch_1/S08_AXIS] [get_bd_intf_pins sha1_8/dataout]
  connect_bd_intf_net -intf_net sha1_9_dataout [get_bd_intf_pins axis_switch_1/S09_AXIS] [get_bd_intf_pins sha1_9/dataout]

  # Create port connections
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins m_axis_aclk] [get_bd_pins axis_switch_0/aclk] [get_bd_pins axis_switch_1/aclk] [get_bd_pins sha1_0/clk_i] [get_bd_pins sha1_1/clk_i] [get_bd_pins sha1_10/clk_i] [get_bd_pins sha1_11/clk_i] [get_bd_pins sha1_12/clk_i] [get_bd_pins sha1_13/clk_i] [get_bd_pins sha1_14/clk_i] [get_bd_pins sha1_15/clk_i] [get_bd_pins sha1_2/clk_i] [get_bd_pins sha1_3/clk_i] [get_bd_pins sha1_4/clk_i] [get_bd_pins sha1_5/clk_i] [get_bd_pins sha1_6/clk_i] [get_bd_pins sha1_7/clk_i] [get_bd_pins sha1_8/clk_i] [get_bd_pins sha1_9/clk_i]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins m_axis_aresetn] [get_bd_pins axis_switch_0/aresetn] [get_bd_pins axis_switch_1/aresetn] [get_bd_pins sha1_0/rstn_i] [get_bd_pins sha1_1/rstn_i] [get_bd_pins sha1_10/rstn_i] [get_bd_pins sha1_11/rstn_i] [get_bd_pins sha1_12/rstn_i] [get_bd_pins sha1_13/rstn_i] [get_bd_pins sha1_14/rstn_i] [get_bd_pins sha1_15/rstn_i] [get_bd_pins sha1_2/rstn_i] [get_bd_pins sha1_3/rstn_i] [get_bd_pins sha1_4/rstn_i] [get_bd_pins sha1_5/rstn_i] [get_bd_pins sha1_6/rstn_i] [get_bd_pins sha1_7/rstn_i] [get_bd_pins sha1_8/rstn_i] [get_bd_pins sha1_9/rstn_i]

  # Perform GUI Layout
  regenerate_bd_layout -hierarchy [get_bd_cells /crack1] -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port S00_AXIS -pg 1 -y 870 -defaultsOSRD
preplace port M00_AXIS -pg 1 -y 1270 -defaultsOSRD
preplace port m_axis_aclk -pg 1 -y 900 -defaultsOSRD
preplace portBus m_axis_aresetn -pg 1 -y 920 -defaultsOSRD
preplace inst sha1_6 -pg 1 -lvl 2 -y 780 -defaultsOSRD
preplace inst sha1_7 -pg 1 -lvl 2 -y 1140 -defaultsOSRD
preplace inst axis_switch_0 -pg 1 -lvl 1 -y 890 -defaultsOSRD
preplace inst sha1_8 -pg 1 -lvl 2 -y 1260 -defaultsOSRD
preplace inst axis_switch_1 -pg 1 -lvl 3 -y 1280 -defaultsOSRD
preplace inst sha1_9 -pg 1 -lvl 2 -y 1020 -defaultsOSRD
preplace inst sha1_10 -pg 1 -lvl 2 -y 1380 -defaultsOSRD
preplace inst sha1_0 -pg 1 -lvl 2 -y 60 -defaultsOSRD
preplace inst sha1_11 -pg 1 -lvl 2 -y 1530 -defaultsOSRD
preplace inst sha1_1 -pg 1 -lvl 2 -y 180 -defaultsOSRD
preplace inst sha1_12 -pg 1 -lvl 2 -y 1650 -defaultsOSRD
preplace inst sha1_2 -pg 1 -lvl 2 -y 300 -defaultsOSRD
preplace inst sha1_13 -pg 1 -lvl 2 -y 1770 -defaultsOSRD
preplace inst sha1_3 -pg 1 -lvl 2 -y 420 -defaultsOSRD
preplace inst sha1_14 -pg 1 -lvl 2 -y 1890 -defaultsOSRD
preplace inst sha1_4 -pg 1 -lvl 2 -y 540 -defaultsOSRD
preplace inst sha1_15 -pg 1 -lvl 2 -y 900 -defaultsOSRD
preplace inst sha1_5 -pg 1 -lvl 2 -y 660 -defaultsOSRD
preplace netloc axis_switch_0_M09_AXIS 1 1 1 510
preplace netloc sha1_7_dataout 1 2 1 710
preplace netloc axis_switch_0_M01_AXIS 1 1 1 440
preplace netloc axis_switch_0_M00_AXIS 1 1 1 430
preplace netloc axis_switch_0_M10_AXIS 1 1 1 470
preplace netloc axis_switch_0_M06_AXIS 1 1 1 530
preplace netloc axis_switch_0_M05_AXIS 1 1 1 520
preplace netloc sha1_1_dataout 1 2 1 790
preplace netloc sha1_14_dataout 1 2 1 800
preplace netloc sha1_11_dataout 1 2 1 750
preplace netloc axis_switch_0_M13_AXIS 1 1 1 440
preplace netloc sha1_8_dataout 1 2 1 N
preplace netloc axis_switch_0_M03_AXIS 1 1 1 460
preplace netloc sha1_13_dataout 1 2 1 780
preplace netloc axis_switch_0_M11_AXIS 1 1 1 460
preplace netloc axis_switch_1_M00_AXIS 1 3 1 N
preplace netloc axi_fifo_mm_s_0_AXI_STR_TXD 1 0 1 N
preplace netloc sha1_12_dataout 1 2 1 760
preplace netloc axis_switch_0_M12_AXIS 1 1 1 450
preplace netloc sha1_9_dataout 1 2 1 720
preplace netloc sha1_2_dataout 1 2 1 780
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 0 3 190 680 490 1460 790
preplace netloc axis_switch_0_M15_AXIS 1 1 1 530
preplace netloc axis_switch_0_M08_AXIS 1 1 1 500
preplace netloc sha1_10_dataout 1 2 1 740
preplace netloc sha1_4_dataout 1 2 1 760
preplace netloc sha1_15_dataout 1 2 1 730
preplace netloc sha1_3_dataout 1 2 1 770
preplace netloc sha1_0_dataout 1 2 1 800
preplace netloc sha1_6_dataout 1 2 1 740
preplace netloc axis_switch_0_M04_AXIS 1 1 1 510
preplace netloc axis_switch_0_M02_AXIS 1 1 1 450
preplace netloc processing_system7_0_FCLK_CLK0 1 0 3 180 670 480 1450 770
preplace netloc axis_switch_0_M14_AXIS 1 1 1 430
preplace netloc sha1_5_dataout 1 2 1 750
preplace netloc axis_switch_0_M07_AXIS 1 1 1 520
levelinfo -pg 1 160 310 620 950 1130 -top 0 -bot 1960
",
}

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: crack0
proc create_hier_cell_crack0 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_crack0() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S00_AXIS

  # Create pins
  create_bd_pin -dir I -type clk m_axis_aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst m_axis_aresetn

  # Create instance: axis_switch_0, and set properties
  set axis_switch_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_0 ]
  set_property -dict [ list \
CONFIG.DECODER_REG {1} \
CONFIG.NUM_MI {16} \
CONFIG.NUM_SI {1} \
 ] $axis_switch_0

  # Create instance: axis_switch_1, and set properties
  set axis_switch_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_1 ]
  set_property -dict [ list \
CONFIG.ARB_ON_MAX_XFERS {5} \
CONFIG.DECODER_REG {0} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {16} \
 ] $axis_switch_1

  # Create instance: sha1_0, and set properties
  set sha1_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_0 ]

  # Create instance: sha1_1, and set properties
  set sha1_1 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_1 ]

  # Create instance: sha1_2, and set properties
  set sha1_2 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_2 ]

  # Create instance: sha1_3, and set properties
  set sha1_3 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_3 ]

  # Create instance: sha1_4, and set properties
  set sha1_4 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_4 ]

  # Create instance: sha1_5, and set properties
  set sha1_5 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_5 ]

  # Create instance: sha1_6, and set properties
  set sha1_6 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_6 ]

  # Create instance: sha1_7, and set properties
  set sha1_7 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_7 ]

  # Create instance: sha1_8, and set properties
  set sha1_8 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_8 ]

  # Create instance: sha1_9, and set properties
  set sha1_9 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_9 ]

  # Create instance: sha1_10, and set properties
  set sha1_10 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_10 ]

  # Create instance: sha1_11, and set properties
  set sha1_11 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_11 ]

  # Create instance: sha1_12, and set properties
  set sha1_12 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_12 ]

  # Create instance: sha1_13, and set properties
  set sha1_13 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_13 ]

  # Create instance: sha1_14, and set properties
  set sha1_14 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_14 ]

  # Create instance: sha1_15, and set properties
  set sha1_15 [ create_bd_cell -type ip -vlnv xilinx.com:user:sha1:1.0 sha1_15 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_fifo_mm_s_0_AXI_STR_TXD [get_bd_intf_pins S00_AXIS] [get_bd_intf_pins axis_switch_0/S00_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M00_AXIS [get_bd_intf_pins axis_switch_0/M00_AXIS] [get_bd_intf_pins sha1_0/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M01_AXIS [get_bd_intf_pins axis_switch_0/M01_AXIS] [get_bd_intf_pins sha1_1/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M02_AXIS [get_bd_intf_pins axis_switch_0/M02_AXIS] [get_bd_intf_pins sha1_2/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M03_AXIS [get_bd_intf_pins axis_switch_0/M03_AXIS] [get_bd_intf_pins sha1_3/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M04_AXIS [get_bd_intf_pins axis_switch_0/M04_AXIS] [get_bd_intf_pins sha1_4/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M05_AXIS [get_bd_intf_pins axis_switch_0/M05_AXIS] [get_bd_intf_pins sha1_5/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M06_AXIS [get_bd_intf_pins axis_switch_0/M06_AXIS] [get_bd_intf_pins sha1_6/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M07_AXIS [get_bd_intf_pins axis_switch_0/M07_AXIS] [get_bd_intf_pins sha1_7/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M08_AXIS [get_bd_intf_pins axis_switch_0/M08_AXIS] [get_bd_intf_pins sha1_8/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M09_AXIS [get_bd_intf_pins axis_switch_0/M09_AXIS] [get_bd_intf_pins sha1_9/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M10_AXIS [get_bd_intf_pins axis_switch_0/M10_AXIS] [get_bd_intf_pins sha1_10/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M11_AXIS [get_bd_intf_pins axis_switch_0/M11_AXIS] [get_bd_intf_pins sha1_11/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M12_AXIS [get_bd_intf_pins axis_switch_0/M12_AXIS] [get_bd_intf_pins sha1_12/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M13_AXIS [get_bd_intf_pins axis_switch_0/M13_AXIS] [get_bd_intf_pins sha1_13/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M14_AXIS [get_bd_intf_pins axis_switch_0/M14_AXIS] [get_bd_intf_pins sha1_14/datain]
  connect_bd_intf_net -intf_net axis_switch_0_M15_AXIS [get_bd_intf_pins axis_switch_0/M15_AXIS] [get_bd_intf_pins sha1_15/datain]
  connect_bd_intf_net -intf_net axis_switch_1_M00_AXIS [get_bd_intf_pins M00_AXIS] [get_bd_intf_pins axis_switch_1/M00_AXIS]
  connect_bd_intf_net -intf_net sha1_0_dataout [get_bd_intf_pins axis_switch_1/S00_AXIS] [get_bd_intf_pins sha1_0/dataout]
  connect_bd_intf_net -intf_net sha1_10_dataout [get_bd_intf_pins axis_switch_1/S10_AXIS] [get_bd_intf_pins sha1_10/dataout]
  connect_bd_intf_net -intf_net sha1_11_dataout [get_bd_intf_pins axis_switch_1/S11_AXIS] [get_bd_intf_pins sha1_11/dataout]
  connect_bd_intf_net -intf_net sha1_12_dataout [get_bd_intf_pins axis_switch_1/S12_AXIS] [get_bd_intf_pins sha1_12/dataout]
  connect_bd_intf_net -intf_net sha1_13_dataout [get_bd_intf_pins axis_switch_1/S13_AXIS] [get_bd_intf_pins sha1_13/dataout]
  connect_bd_intf_net -intf_net sha1_14_dataout [get_bd_intf_pins axis_switch_1/S14_AXIS] [get_bd_intf_pins sha1_14/dataout]
  connect_bd_intf_net -intf_net sha1_15_dataout [get_bd_intf_pins axis_switch_1/S15_AXIS] [get_bd_intf_pins sha1_15/dataout]
  connect_bd_intf_net -intf_net sha1_1_dataout [get_bd_intf_pins axis_switch_1/S01_AXIS] [get_bd_intf_pins sha1_1/dataout]
  connect_bd_intf_net -intf_net sha1_2_dataout [get_bd_intf_pins axis_switch_1/S02_AXIS] [get_bd_intf_pins sha1_2/dataout]
  connect_bd_intf_net -intf_net sha1_3_dataout [get_bd_intf_pins axis_switch_1/S03_AXIS] [get_bd_intf_pins sha1_3/dataout]
  connect_bd_intf_net -intf_net sha1_4_dataout [get_bd_intf_pins axis_switch_1/S04_AXIS] [get_bd_intf_pins sha1_4/dataout]
  connect_bd_intf_net -intf_net sha1_5_dataout [get_bd_intf_pins axis_switch_1/S05_AXIS] [get_bd_intf_pins sha1_5/dataout]
  connect_bd_intf_net -intf_net sha1_6_dataout [get_bd_intf_pins axis_switch_1/S06_AXIS] [get_bd_intf_pins sha1_6/dataout]
  connect_bd_intf_net -intf_net sha1_7_dataout [get_bd_intf_pins axis_switch_1/S07_AXIS] [get_bd_intf_pins sha1_7/dataout]
  connect_bd_intf_net -intf_net sha1_8_dataout [get_bd_intf_pins axis_switch_1/S08_AXIS] [get_bd_intf_pins sha1_8/dataout]
  connect_bd_intf_net -intf_net sha1_9_dataout [get_bd_intf_pins axis_switch_1/S09_AXIS] [get_bd_intf_pins sha1_9/dataout]

  # Create port connections
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins m_axis_aclk] [get_bd_pins axis_switch_0/aclk] [get_bd_pins axis_switch_1/aclk] [get_bd_pins sha1_0/clk_i] [get_bd_pins sha1_1/clk_i] [get_bd_pins sha1_10/clk_i] [get_bd_pins sha1_11/clk_i] [get_bd_pins sha1_12/clk_i] [get_bd_pins sha1_13/clk_i] [get_bd_pins sha1_14/clk_i] [get_bd_pins sha1_15/clk_i] [get_bd_pins sha1_2/clk_i] [get_bd_pins sha1_3/clk_i] [get_bd_pins sha1_4/clk_i] [get_bd_pins sha1_5/clk_i] [get_bd_pins sha1_6/clk_i] [get_bd_pins sha1_7/clk_i] [get_bd_pins sha1_8/clk_i] [get_bd_pins sha1_9/clk_i]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins m_axis_aresetn] [get_bd_pins axis_switch_0/aresetn] [get_bd_pins axis_switch_1/aresetn] [get_bd_pins sha1_0/rstn_i] [get_bd_pins sha1_1/rstn_i] [get_bd_pins sha1_10/rstn_i] [get_bd_pins sha1_11/rstn_i] [get_bd_pins sha1_12/rstn_i] [get_bd_pins sha1_13/rstn_i] [get_bd_pins sha1_14/rstn_i] [get_bd_pins sha1_15/rstn_i] [get_bd_pins sha1_2/rstn_i] [get_bd_pins sha1_3/rstn_i] [get_bd_pins sha1_4/rstn_i] [get_bd_pins sha1_5/rstn_i] [get_bd_pins sha1_6/rstn_i] [get_bd_pins sha1_7/rstn_i] [get_bd_pins sha1_8/rstn_i] [get_bd_pins sha1_9/rstn_i]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set fifo_int [ create_bd_port -dir O -from 1 -to 0 fifo_int ]

  # Create instance: axi_fifo_mm_s_0, and set properties
  set axi_fifo_mm_s_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_fifo_mm_s:4.1 axi_fifo_mm_s_0 ]
  set_property -dict [ list \
CONFIG.C_HAS_AXIS_TDEST {true} \
CONFIG.C_USE_RX_CUT_THROUGH {true} \
CONFIG.C_USE_TX_CTRL {0} \
 ] $axi_fifo_mm_s_0

  # Create instance: axi_fifo_mm_s_1, and set properties
  set axi_fifo_mm_s_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_fifo_mm_s:4.1 axi_fifo_mm_s_1 ]
  set_property -dict [ list \
CONFIG.C_HAS_AXIS_TDEST {true} \
CONFIG.C_USE_RX_CUT_THROUGH {true} \
CONFIG.C_USE_TX_CTRL {0} \
 ] $axi_fifo_mm_s_1

  # Create instance: crack0
  create_hier_cell_crack0 [current_bd_instance .] crack0

  # Create instance: crack1
  create_hier_cell_crack1 [current_bd_instance .] crack1

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_EN_CLK1_PORT {0} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {125} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} \
CONFIG.PCW_SPI1_GRP_SS1_IO {<Select>} \
CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SPI1_SPI1_IO {MIO 10 .. 15} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {2} \
CONFIG.STRATEGY {1} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_fifo_mm_s_0_AXI_STR_TXD [get_bd_intf_pins axi_fifo_mm_s_0/AXI_STR_TXD] [get_bd_intf_pins crack0/S00_AXIS]
  connect_bd_intf_net -intf_net axi_fifo_mm_s_1_AXI_STR_TXD [get_bd_intf_pins axi_fifo_mm_s_1/AXI_STR_TXD] [get_bd_intf_pins crack1/S00_AXIS]
  connect_bd_intf_net -intf_net axis_switch_1_M00_AXIS [get_bd_intf_pins axi_fifo_mm_s_0/AXI_STR_RXD] [get_bd_intf_pins crack0/M00_AXIS]
  connect_bd_intf_net -intf_net crack1_M00_AXIS [get_bd_intf_pins axi_fifo_mm_s_1/AXI_STR_RXD] [get_bd_intf_pins crack1/M00_AXIS]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_fifo_mm_s_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_fifo_mm_s_1/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]

  # Create port connections
  connect_bd_net -net axi_fifo_mm_s_0_interrupt [get_bd_pins axi_fifo_mm_s_0/interrupt] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_fifo_mm_s_1_interrupt [get_bd_pins axi_fifo_mm_s_1/interrupt] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_fifo_mm_s_0/s_axi_aclk] [get_bd_pins axi_fifo_mm_s_1/s_axi_aclk] [get_bd_pins crack0/m_axis_aclk] [get_bd_pins crack1/m_axis_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_fifo_mm_s_0/s_axi_aresetn] [get_bd_pins axi_fifo_mm_s_1/s_axi_aresetn] [get_bd_pins crack0/m_axis_aresetn] [get_bd_pins crack1/m_axis_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_ports fifo_int] [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_fifo_mm_s_0/S_AXI/Mem0] SEG_axi_fifo_mm_s_0_Mem0
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_fifo_mm_s_1/S_AXI/Mem0] SEG_axi_fifo_mm_s_1_Mem0

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 470 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 490 -defaultsOSRD
preplace portBus fifo_int -pg 1 -y 620 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 1 -y 290 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 3 -y 600 -defaultsOSRD
preplace inst crack0 -pg 1 -lvl 4 -y 240 -defaultsOSRD
preplace inst crack1 -pg 1 -lvl 4 -y 90 -defaultsOSRD
preplace inst axi_fifo_mm_s_0 -pg 1 -lvl 3 -y 390 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 2 -y 310 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 1 -y 540 -defaultsOSRD
preplace inst axi_fifo_mm_s_1 -pg 1 -lvl 3 -y 100 -defaultsOSRD
preplace netloc processing_system7_0_DDR 1 1 4 N 470 NJ 480 NJ 480 NJ
preplace netloc axi_fifo_mm_s_1_AXI_STR_TXD 1 3 1 N
preplace netloc axi_fifo_mm_s_1_interrupt 1 2 2 800 20 1110
preplace netloc crack1_M00_AXIS 1 2 3 810 10 NJ 10 1400
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 2 1 770
preplace netloc processing_system7_0_M_AXI_GP0 1 1 1 450
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 2 30 200 410
preplace netloc axis_switch_1_M00_AXIS 1 2 3 810 470 NJ 470 1400
preplace netloc axi_fifo_mm_s_0_AXI_STR_TXD 1 3 1 1110
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 1 3 430 170 790 190 1130
preplace netloc xlconcat_0_dout 1 0 5 30 680 NJ 680 NJ 680 1120 620 NJ
preplace netloc processing_system7_0_FIXED_IO 1 1 4 N 490 NJ 490 NJ 490 NJ
preplace netloc axi_fifo_mm_s_0_interrupt 1 2 2 810 500 1120
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 1 1 420
preplace netloc processing_system7_0_FCLK_CLK0 1 0 4 20 180 440 160 780 180 1120
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 2 1 760
levelinfo -pg 1 0 220 610 960 1270 1430 -top 0 -bot 690
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


