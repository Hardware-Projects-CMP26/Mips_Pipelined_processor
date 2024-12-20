transcript on

vlib work

vcom -93 -work work {./rtl/core/data_memory_control.vhd}
vcom -93 -work work {./sim/testbench/data_memory_control_tb.vhd}

vsim -t 1ns work.data_memory_control_tb

add wave -position insertpoint \
sim:/data_memory_control_tb/mem_address_source \
sim:/data_memory_control_tb/mem_data_source \
sim:/data_memory_control_tb/stack_pointer \
sim:/data_memory_control_tb/address \
sim:/data_memory_control_tb/alu_result \
sim:/data_memory_control_tb/immediate \
sim:/data_memory_control_tb/register_file_data \
sim:/data_memory_control_tb/mem_address \
sim:/data_memory_control_tb/mem_data

add wave -position insertpoint \
sim:/data_memory_control_tb/DUT/mem_address \
sim:/data_memory_control_tb/DUT/mem_data

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
