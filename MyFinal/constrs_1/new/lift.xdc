#CLK input
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports clk];     #CLK½Ó²å¿×

#RST input
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports rst];     #IO0½Ó²å¿×

#Ctrl input
set_property -dict {PACKAGE_PIN Y22 IOSTANDARD LVCMOS33} [get_ports Ctrl[2]];     #IO13½Ó²å¿×
set_property -dict {PACKAGE_PIN Y21 IOSTANDARD LVCMOS33} [get_ports Ctrl[1]];     #IO14½Ó²å¿×
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports Ctrl[0]];     #IO15½Ó²å¿×

#button input
#set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports button];     #IO20½Ó²å¿×

# h
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports h[3]];     #IO1½Ó²å¿×
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports h[2]];     #IO2½Ó²å¿×
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports h[1]];     #IO3½Ó²å¿×
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports h[0]];     #IO4½Ó²å¿×

# m
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS33} [get_ports m[3]];     #IO5½Ó²å¿×
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports m[2]];     #IO6½Ó²å¿×
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports m[1]];     #IO7½Ó²å¿×
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33} [get_ports m[0]];     #IO8½Ó²å¿×

# l
set_property -dict {PACKAGE_PIN R22 IOSTANDARD LVCMOS33} [get_ports l[3]];     #IO9½Ó²å¿×
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports l[2]];     #IO10½Ó²å¿×
set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports l[1]];     #IO11½Ó²å¿×
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports l[0]];     #IO12½Ó²å¿×

# required if touch button used as manual clock source
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CLK_IBUF]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]