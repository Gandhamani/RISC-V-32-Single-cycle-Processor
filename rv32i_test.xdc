# Clock Constraints
# Replace P16 with the actual pin number for your clock pin from the Pin Planner
set_property PACKAGE_PIN P16 [get_ports clk]           # Clock pin assignment
set_property IOSTANDARD LVCMOS33 [get_ports clk]        # Clock I/O standard

create_clock -period 10 [get_pins your_top_level_module/clk]  # Define clock period (adjust as needed)

# Reset pin assignment
# Replace P17 with the actual pin number for the reset signal
set_property PACKAGE_PIN P17 [get_ports reset]         # Reset pin assignment
set_property IOSTANDARD LVCMOS33 [get_ports reset]      # Reset I/O standard

# Data signal pin assignments (Example for DataAdr, WriteData, etc.)
# Replace P18, P19, etc. with the actual pin numbers
set_property PACKAGE_PIN P18 [get_ports DataAdr[0]]    # DataAdr[0] pin assignment
set_property IOSTANDARD LVCMOS33 [get_ports DataAdr[0]] # DataAdr I/O standard

set_property PACKAGE_PIN P19 [get_ports DataAdr[1]]    # DataAdr[1] pin assignment
set_property IOSTANDARD LVCMOS33 [get_ports DataAdr[1]] # DataAdr I/O standard

# Repeat for other DataAdr signals as necessary
# Example for 32-bit DataAdr signals (adjust pin names accordingly)
set_property PACKAGE_PIN P20 [get_ports DataAdr[2]]
set_property IOSTANDARD LVCMOS33 [get_ports DataAdr[2]]

# Example for 32-bit WriteData signals (adjust pin names accordingly)
set_property PACKAGE_PIN P21 [get_ports WriteData[0]]
set_property IOSTANDARD LVCMOS33 [get_ports WriteData[0]]

# Add more data signals here as needed

# Define timing constraints
# Input delays (example; adjust for your clock setup and data paths)
set_input_delay -clock [get_clocks clk] -max 3 [get_ports {reset DataAdr[*] WriteData[*]}]
set_input_delay -clock [get_clocks clk] -min 1 [get_ports {reset DataAdr[*] WriteData[*]}]

# Output delays (example; adjust for your clock setup and data paths)
set_output_delay -clock [get_clocks clk] -max 3 [get_ports {DataAdr[*] WriteData[*]}]
set_output_delay -clock [get_clocks clk] -min 1 [get_ports {DataAdr[*] WriteData[*]}]

# False path (example for reset signal)
# Ensure reset doesn't interfere with timing analysis
set_false_path -from [get_ports reset]

# Additional constraints for the module pins, you can add more based on your design
# Set drive strength (if necessary)
# set_drive 12 [get_ports {clk reset}]
# Note: `set_drive` may not be supported for all targets. Comment out if not necessary.

# Add other I/O assignments as per your design
# For example, for MemWrite or Result signals
set_property PACKAGE_PIN P22 [get_ports MemWrite]
set_property IOSTANDARD LVCMOS33 [get_ports MemWrite]

# Example for output signals like Result
set_property PACKAGE_PIN P23 [get_ports Result[0]]
set_property IOSTANDARD LVCMOS33 [get_ports Result[0]]

# Repeat for additional signals like WriteData, MemWrite, etc.
# Example: Enable power optimization for a specific module
set_property POWER_MODE LowPower [get_cells -hierarchical my_block]

# Example: Disable clock for unused modules
set_property CLOCK_GATE_ENABLE true [get_cells -hierarchical unused_block]
