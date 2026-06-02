//1.declaring  the clk and rst
//2.clk and rst generation
//3.interface instantiation
//4.dut instantiation
//5.assertion instantiation
//6.pass the intrf handle to the drv and mon we use config db
//7.call the run test method.
module top;
//1.declaring  the clk and rst
bit clk,rst;

//2.clk and rst generation
always #5 clk=~clk;//100mhz

//3.interface instantiation
mem_intrf pif(clk,rst);

//apply reset 
	initial begin
		rst=1;
		//reset the dut inputs
		pif.addr_i=0;
		pif.wdata_i=0;
		pif.wr_rd_i=0;
		pif.valid_i=0;
		repeat(2)@(posedge clk);
		rst=0;
	end
//4.dut instantiation
	 memory mem_dut(.clk_i(pif.clk_i), 
	 				.rst_i(pif.rst_i), 
					.wr_rd_i(pif.wr_rd_i), 
					.addr_i(pif.addr_i), 
					.wdata_i(pif.wdata_i), 
					.valid_i(pif.valid_i), 
					.rdata_o(pif.rdata_o), 
					.ready_o(pif.ready_o));
//6.pass the intrf handle to the drv and mon we use config db
	initial begin
		uvm_config_db#(virtual mem_intrf)::set(null,"*.mem_agent_h.*","MEM_PIF",pif);
	end
//7.call the run test method.
	initial begin
		run_test("mem_one_wr_one_rd_test");//uvm_tb execution starts
	end
	//VCS
//	initial begin
//		//waveform dumps
//		$fsdbDumpfile("mem.fsdb");
//		$fsdbDumpvars(0,top);
//		$fsdbDumpMDA(0.top.mem_dut);
//	end
endmodule
