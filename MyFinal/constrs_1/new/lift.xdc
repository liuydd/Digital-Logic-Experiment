#CLK input
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports clk];     #CLK�Ӳ��

#RST input
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports rst];     #IO0�Ӳ��

#Ctrl input
set_property -dict {PACKAGE_PIN Y22 IOSTANDARD LVCMOS33} [get_ports Ctrl[2]];     #IO13�Ӳ��
set_property -dict {PACKAGE_PIN Y21 IOSTANDARD LVCMOS33} [get_ports Ctrl[1]];     #IO14�Ӳ��
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports Ctrl[0]];     #IO15�Ӳ��

#button input
#set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports button];     #IO20�Ӳ��

# h
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports h[3]];     #IO1�Ӳ��
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports h[2]];     #IO2�Ӳ��
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports h[1]];     #IO3�Ӳ��
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports h[0]];     #IO4�Ӳ��

# m
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS33} [get_ports m[3]];     #IO5�Ӳ��
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports m[2]];     #IO6�Ӳ��
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports m[1]];     #IO7�Ӳ��
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33} [get_ports m[0]];     #IO8�Ӳ��

# l
set_property -dict {PACKAGE_PIN R22 IOSTANDARD LVCMOS33} [get_ports l[3]];     #IO9�Ӳ��
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports l[2]];     #IO10�Ӳ��
set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports l[1]];     #IO11�Ӳ��
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports l[0]];     #IO12�Ӳ��

# required if touch button used as manual clock source
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CLK_IBUF]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]