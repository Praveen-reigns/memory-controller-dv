## compilation
#vlog -cover bcst list.svh \
#+incdir+C:/questasim64_10.7c/verilog_src/uvm-1.2/src
#
## optimization
#vopt top +cover=fcbest -o mem_one_wr_one_rd_test
## simulation
#vsim -coverage top -suppress 12110 \
#-sv_lib C:/questasim64_10.7c/uvm-1.2/win64/uvm_dpi +UVM_TESTNAME=mem_one_wr_one_rd_test
#
## coverage
#coverage save -onexit mem_one_wr_one_rd_test.ucdb
##do exclusion.do
#
## waves
#add wave -r sim:/top/pif/*

## compilation
#vlog -cover bcst list.svh \
#+incdir+C:/questasim64_10.7c/verilog_src/uvm-1.2/src
#
## optimization
#vopt top +cover=fcbest -o default
## simulation
#vsim -coverage top -suppress 12110 \
#-sv_lib C:/questasim64_10.7c/uvm-1.2/win64/uvm_dpi \
#+UVM_TESTNAME=default
#
## coverage
#coverage save -onexit default.ucdb
##do exclusion.do
#
## waves
#add wave -r sim:/top/pif/*

vlog -sv -cover bcst list.svh \
+incdir+C:/questasim64_10.7c/verilog_src/uvm-1.2/src \
C:/questasim64_10.7c/verilog_src/uvm-1.2/src/uvm_pkg.sv

# (Optional but recommended)
#vlog -sv $QUESTA_HOME/verilog_src/questa_uvm_pkg.sv

# 2. Optimize
vopt top +cover=bcst -o opt_top

# 3. Simulate
vsim -coverage opt_top \
-sv_lib C:/questasim64_10.7c/uvm-1.2/win64/uvm_dpi \
+UVM_TESTNAME=mem_one_wr_one_rd_test \
-uvmcontrol=all

# 4. Coverage save
coverage save -onexit mem.ucdb

# 5. Waves
add wave -r sim:/top/*
run -all
