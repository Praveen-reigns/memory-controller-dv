class mem_base_seq extends uvm_sequence#(mem_tx);
	`uvm_object_utils(mem_base_seq)
	//2.constructor
	function new(string name="");
		super.new(name);
	endfunction
uvm_phase phase;
	task pre_body();
		`uvm_info("mem_base_seq","PRE_BODY",UVM_NONE)
			phase = get_starting_phase();//can return a null or a phase value assigned by uvm_roo	
			//get_starting_phase returns the null when we map the seq to sqr in run_phase and it returns some phase values 				when we map seq to sqr in build_phase
			if(phase != null)begin//phase will not be null only when we map seq to sqr in build_phase
				`uvm_info("mem_base_seq","PRE_BODY : Raise_objection",UVM_NONE)
				phase.raise_objection(this);
			end

	endtask

	task post_body();
		`uvm_info("mem_base_seq","POST_BODY",UVM_NONE)
			phase = get_starting_phase();//can return a null or a phase value assigned by uvm_roo	
			//get_starting_phase returns the null when we map the seq to sqr in run_phase and it returns some phase values 				when we map seq to sqr in build_phase
			if(phase != null)begin
				`uvm_info("mem_base_seq","POST_BODY : Drop_objection",UVM_NONE)
				phase.phase_done.set_drain_time(this,50);
				phase.drop_objection(this);
			end
	endtask

endclass

class mem_one_wr_one_rd_seq extends mem_base_seq;
	//factory registration
	`uvm_object_utils(mem_one_wr_one_rd_seq)

	mem_tx tx_t;

	//2.constructor
	function new(string name="");
		super.new(name);
	endfunction
	

	task body();
		`uvm_info("seq","BODY",UVM_NONE)
		`uvm_do_with(req,{req.wr_rd==1;})//WR
			tx_t=new req;//shallow copy
		`uvm_do_with(req,{req.wr_rd==0; req.addr==tx_t.addr;})//RD
	endtask
endclass

//gen the tx and the addr for the compleate depth location of memory
//addr is to uniqe and random
class mem_full_wr_rd_seq extends mem_base_seq;
	//factory registration
	`uvm_object_utils(mem_full_wr_rd_seq)

	mem_tx tx_t;

	//declare a arry 
	rand bit [`ADDR_WIDTH-1:0] addr_DA[];
	//constraint
	constraint addr_DA_size{
		addr_DA.size==16;//16 locations
	}
	//constraint for the unique values
	constraint addr_DA_unique{
		unique {addr_DA};
	}

	//2.constructor
	function new(string name="");
		super.new(name);
	endfunction
	
	task pre_body();
		super.pre_body();
		`uvm_info("seq","PRE_BODY",UVM_NONE)
		//randomize the addr of this class
		this.randomize();
		`uvm_info("seq",$sformatf("RANDM UNIQUE ADDR =%p",this.addr_DA),UVM_NONE)
	endtask

	task body();
		`uvm_info("seq","BODY",UVM_NONE)
		//WR
		for(int i=0;i<`DEPTH;i++)begin
			`uvm_do_with(req,{req.wr_rd==1; req.addr==addr_DA[i];})
		end
		//RD
		for(int i=0;i<`DEPTH;i++)begin
			`uvm_do_with(req,{req.wr_rd==0; req.addr==addr_DA[i]; req.wdata==0;})
		end
	endtask
endclass


//mem_5_wr_rd_seq generates => greater than 5 wr_rd tx
class mem_5_wr_rd_seq extends mem_base_seq;
`uvm_object_utils(mem_5_wr_rd_seq)



uvm_phase phase;
//2.constructor
	function new(string name="");
		super.new(name);
	endfunction
	
	task body();
		for(int i=0;i<5;i++)begin
			`uvm_do(seq)
		end
	endtask


endclass
