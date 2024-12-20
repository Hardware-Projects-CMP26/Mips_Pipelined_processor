transcript on

vlib work

vcom -93 -work work {./rtl/memory/data_memory.vhd}
vcom -93 -work work {./sim/testbench/data_memory_tb.vhd}

vsim -t 1ns work.data_memory_tb

add wave -position insertpoint \
sim:/data_memory_tb/clk \
sim:/data_memory_tb/reset \
sim:/data_memory_tb/address \
sim:/data_memory_tb/write_data \
sim:/data_memory_tb/read_data \
sim:/data_memory_tb/write_enable \
sim:/data_memory_tb/read_enable

add wave -position insertpoint \
sim:/data_memory_tb/DUT/mem(0) \
sim:/data_memory_tb/DUT/mem(1) \
sim:/data_memory_tb/DUT/mem(2) \
sim:/data_memory_tb/DUT/mem(3) \
sim:/data_memory_tb/DUT/mem(4) \
sim:/data_memory_tb/DUT/mem(5) \
sim:/data_memory_tb/DUT/mem(6) \
sim:/data_memory_tb/DUT/mem(7) \
sim:/data_memory_tb/DUT/mem(8) \
sim:/data_memory_tb/DUT/mem(9) \
sim:/data_memory_tb/DUT/mem(10) \
sim:/data_memory_tb/DUT/mem(11) \
sim:/data_memory_tb/DUT/mem(12) \
sim:/data_memory_tb/DUT/mem(13) \
sim:/data_memory_tb/DUT/mem(14) \
sim:/data_memory_tb/DUT/mem(15)

configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

run 200 ns

wave zoom full
