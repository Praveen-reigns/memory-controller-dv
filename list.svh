`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "common.sv"

`include "memory.v"

`include "mem_intrf.sv"
`include "mem_tx.sv"

`include "mem_cov.sv"
`include "mem_drv.sv"
`include "mem_mon.sv"
`include "mem_sqr.sv"
`include "mem_sbd.sv"

`include "mem_agent.sv"

`include "mem_env.sv"

//`include "mem_one_wr_one_rd_seq.sv"
//`include "mem_full_wr_rd_seq.sv"
//`include "mem_5_wr_rd_seq.sv "
`include "seq_lib.sv"

`include "test_lib.sv"
//`include "mem_one_wr_one_rd_test.sv"
//`include "mem_full_wr_rd_test.sv"

`include "top.sv"

