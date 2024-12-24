transcript on

vlib work


vcom -2008 -work work {./rtl/core/control_unit.vhd}
vcom -2008 -work work {./sim/testbench/control_unit_tb.vhd}

vsim -t 1ns work.control_unit_tb

add wave -position insertpoint -radix binary \
    sim:/control_unit_tb/opcode
add wave -position insertpoint -divider "ALU Signals"
add wave -position insertpoint \
    sim:/control_unit_tb/alu_enable \
    sim:/control_unit_tb/alu_op \
    sim:/control_unit_tb/operand_source

add wave -position insertpoint -divider "Memory Control"
add wave -position insertpoint \
    sim:/control_unit_tb/mem_write \
    sim:/control_unit_tb/mem_read \
    sim:/control_unit_tb/mem_data_source \
    sim:/control_unit_tb/mem_address_source

add wave -position insertpoint -divider "Stack Control"
add wave -position insertpoint \
    sim:/control_unit_tb/stack_op

add wave -position insertpoint -divider "Register and PC Control"
add wave -position insertpoint \
    sim:/control_unit_tb/reg_write \
    sim:/control_unit_tb/pc_enable \
    sim:/control_unit_tb/if_jump

add wave -position insertpoint -divider "IO and CCR"
add wave -position insertpoint \
    sim:/control_unit_tb/in_enable \
    sim:/control_unit_tb/latch_out \
    sim:/control_unit_tb/write_ccr \
    sim:/control_unit_tb/flag

add wave -position insertpoint -divider "Other Control"
add wave -position insertpoint \
    sim:/control_unit_tb/hlt \
    sim:/control_unit_tb/wb_control

configure wave -namecolwidth 220
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

run 100 ns

wave zoom full
