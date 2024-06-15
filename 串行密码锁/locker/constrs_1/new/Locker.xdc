#CLK input
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports CLK];     #CLK½Ó²å¿×

#RST input
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports RST];     #IO0½Ó²å¿×

# Code input
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports Code[3]];     #IO1½Ó²å¿×
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports Code[2]];     #IO2½Ó²å¿×
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports Code[1]];     #IO3½Ó²å¿×
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports Code[0]];     #IO4½Ó²å¿×

# Mode input
set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports Mode];     #IO11½Ó²å¿×

# Unlock output
set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS33} [get_ports Unlock];     #IO16½Ó²å¿×

# Err output
set_property -dict {PACKAGE_PIN AB18 IOSTANDARD LVCMOS33} [get_ports Err];     #IO17½Ó²å¿×

# alert output
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS33} [get_ports alert];     #IO18½Ó²å¿×

# digits output
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports digits[6]];     #IO6½Ó²å¿×
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports digits[5]];     #IO7½Ó²å¿×
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33} [get_ports digits[4]];     #IO8½Ó²å¿×
set_property -dict {PACKAGE_PIN R22 IOSTANDARD LVCMOS33} [get_ports digits[3]];     #IO9½Ó²å¿×
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports digits[2]];     #IO10½Ó²å¿×
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports digits[1]];     #IO12½Ó²å¿×
set_property -dict {PACKAGE_PIN Y22 IOSTANDARD LVCMOS33} [get_ports digits[0]];     #IO13½Ó²å¿×

# required if touch button used as manual clock source
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CLK_IBUF]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]