class mem_drv extends uvm_driver#(mem_tx);
//1.factory registartion
`uvm_component_utils(mem_drv)

//2.constructor
function new(string name="",uvm_component parent);
	super.new(name,parent);
endfunction

//3.virtual interface instantiation
virtual mem_intrf vif;

//uvm_common phases
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(uvm_config_db#(virtual mem_intrf)::get(this,"","MEM_PIF",vif)==0)begin
			`uvm_error("mem_drv","FAILED TO RETRIVE THE VALUE FROM CFGDB")
		end
	endfunction
		task run_phase(uvm_phase phase);
			wait(vif.rst_i==0);//driver should drive the tx to DUT after applying rst to dut
			forever begin
				//send the req sqr for items
				seq_item_port.get_next_item(req);
				//drive the items to the dut using interface
				drive_tx(req);
				//sending the acknowledgement to the sqr
				seq_item_port.item_done();
			end
		endtask

		task drive_tx(mem_tx tx);
			@(vif.drv_cb);
			vif.drv_cb.wr_rd_i <= tx.wr_rd;
			vif.drv_cb.addr_i <= tx.addr;
			if(tx.wr_rd==1)
				vif.drv_cb.wdata_i <= tx.wdata;
			vif.drv_cb.valid_i <= 1;
			wait(vif.drv_cb.ready_o == 1);
			if(tx.wr_rd==0)
				tx.rdata <= vif.drv_cb.rdata_o;
				//print
				`uvm_info("DRV_drive tx",$sformatf("CMD=%s ADDR=%h DATA=%h",
										tx.wr_rd? "WR":"RD",tx.addr,tx.wr_rd? tx.wdata:tx.rdata),UVM_NONE)
			vif.drv_cb.wr_rd_i <= 0;
			vif.drv_cb.addr_i <= 0;
			vif.drv_cb.wdata_i <= 0;
			vif.drv_cb.valid_i <= 0;
		endtask

endclass
