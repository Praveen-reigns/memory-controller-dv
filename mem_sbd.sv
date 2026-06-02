//uvm_subscriber already have export defined
//i.e uvm_analysis_imp #(T, this_type) analysis export
//and also have a pure virtual method 
//i.e function: write 
//a pure virtual method that must be defined each sub class. Access to this method by outside components should be done by the analysis_expoert
//pure virual function void write (T t) 
class mem_sbd extends uvm_subscriber#(mem_tx);
//factory registration
`uvm_component_utils(mem_sbd)

mem_tx tx;
bit [`DATA_WIDTH-1:0] sbd_mem[*];
int match_count;
int miss_match_count;
//2.constructor
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void write(mem_tx t);
		$cast(tx,t);
		//sbd logic
		//wr store the data into the sbd AA 
		//rd compare the actual data with expected data 
		if(tx.wr_rd==1)begin
			sbd_mem[tx.addr]=tx.wdata;
			$display("wdata=%0d",tx.wdata);
		end
		else begin
			if(tx.rdata==sbd_mem[tx.addr]) begin
			$display("rdata=%0d",tx.rdata);
				match_count++;
				`uvm_error("mem_sbd",$sformatf("ADDR=%h Actual data=%h MATCHING WITH EXPECTED DATA=%h ",tx.addr,tx.rdata,sbd_mem[tx.addr]))
			end
			else begin
				miss_match_count++;
				`uvm_error("mem_sbd",$sformatf("ADDR=%h Actual data=%h NOT MATCHING WITH EXPECTED DATA=%h ",tx.addr,tx.rdata,sbd_mem[tx.addr]))
			end
		end

	endfunction

endclass
