class mem_mon extends uvm_monitor;
//1.factory registartion
`uvm_component_utils(mem_mon)

//2.constructor
function new(string name="",uvm_component parent);
	super.new(name,parent);
endfunction

//3.virtual interface instantiation
virtual mem_intrf vif;

//declare the analysis port
uvm_analysis_port#(mem_tx) mon_ap_h;
 
mem_tx tx;

//uvm_common phases
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon_ap_h=new("mon_ap_h",this);
		tx=mem_tx::type_id::create("tx",this);
		if(uvm_config_db#(virtual mem_intrf)::get(this,"","MEM_PIF",vif)==0)begin
			`uvm_error("mem_drv","FAILED TO RETRIVE THE VALUE FROM CFGDB")
		end
	endfunction
		task run_phase(uvm_phase phase);
			//check for the valid tx for every posedge of the clk
			//when tx is valid collect it and send it to cov and sbd
			forever begin
				@(vif.mon_cb);
				if(vif.mon_cb.valid_i==1 && vif.mon_cb.ready_o==1)begin
					tx.wr_rd <= vif.mon_cb.wr_rd_i;
					tx.addr <= vif.mon_cb.addr_i;
					if(tx.wr_rd==1) begin
						tx.wdata <=vif.mon_cb.wdata_i;
						tx.rdata =0;
					end
					else begin
						tx.wdata=0;
						@(vif.mon_cb);
						tx.rdata <= vif.mon_cb.rdata_o;
				//	if(tx.wr_rd==0) tx.rdata <=vif.mon_cb.rdata_o;
						`uvm_info("DRV_drive tx",$sformatf("CMD=%s ADDR=%h DATA=%h",
										tx.wr_rd? "WR":"RD",tx.addr,tx.wr_rd? tx.wdata:tx.rdata),UVM_NONE)
						end
					//send this tx to the sbd and cov
					mon_ap_h.write(tx);
				end
			end
		endtask

	
endclass
