#!/bin/sh

# cleanup
rm -rf obj_dir
rm -f top.vcd

#run Verilator to transform Verilog into C++, including C++ testbench
#(this operation is what is called creating a wrapper)
verilator -Wall --cc --trace top.sv --exe top_tb.cpp

#build C++ project via make automatically generated by Verilator
make -j -C obj_dir/ -f Vtop.mk Vtop

#run executable simulation file
obj_dir/Vtop