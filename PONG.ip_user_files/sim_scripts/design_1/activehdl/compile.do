vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vcom -work xil_defaultlib -93 \
"../../../bd/design_1/ip/design_1_X_Y_0_2/sim/design_1_X_Y_0_2.vhd" \
"../../../bd/design_1/ip/design_1_VGA_PONG_0_1/sim/design_1_VGA_PONG_0_1.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../PONG.srcs/sources_1/bd/design_1/ipshared/b65a" "+incdir+../../../../PONG.srcs/sources_1/bd/design_1/ipshared/b65a" \
"../../../bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0_clk_wiz.v" \
"../../../bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0.v" \

vcom -work xil_defaultlib -93 \
"../../../bd/design_1/sim/design_1.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

