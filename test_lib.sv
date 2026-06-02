//test lib
//1.base classs
class mem_base_test extends uvm_test;
	`uvm_component_utils(mem_base_test)

	//intantiate the env
	mem_env mem_env_h;

	//constructor
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction

	//uvm_common phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mem_env_h=mem_env::type_id::create("mem_env_h",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction
endclass
//2.functional test classess
//we have devoloped 2 test classes mem_one_wr_one_rd_test,mem_full_wr_rd_test 

class mem_one_wr_one_rd_test extends mem_base_test;
	//1.factory registartion
`uvm_component_utils(mem_one_wr_one_rd_test)

//2.constructor
function new(string name="",uvm_component parent);
	super.new(name,parent);
endfunction
//4.uvm_common phases
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		//1.instantiation and create the seq
		mem_one_wr_one_rd_seq seq_h = mem_one_wr_one_rd_seq::type_id::create("seq_h");
		//2.raise the objection
		phase.raise_objection(this);
		//3.map the seq to sqr
		seq_h.start(mem_env_h.mem_agent_h.mem_sqr_h);
		//4.set drain time
		phase.phase_done.set_drain_time(this,100);
		//5.drop the objection
		phase.drop_objection(this);
	endtask
	function void extract_phase(uvm_phase phase);	
		`uvm_info("mem_full_wr_rd_test","extract_phase",UVM_NONE)
			match_count=mem_env_h.mem_sbd_h.match_count;
			miss_match_count=mem_env_h.mem_sbd_h.miss_match_count;
	endfunction
	function void check_phase(uvm_phase phase);
		`uvm_info("mem_full_wr_rd_test","check_phase",UVM_NONE)
			if(`DEPTH == match_count && miss_match_count == 0)begin
				tst_sts=1;
			end
			else begin
				tst_sts=0;
			end
	endfunction
	function void report_phase(uvm_phase phase);
		`uvm_info("mem_full_wr_rd_test","report_phase",UVM_NONE)
			if(tst_sts==1)begin
				`uvm_info("mem_full_wr_rd_test","########## TEST PASSED ########",UVM_NONE)
			end
			else begin
				`uvm_error("mem_full_wr_rd_test",$sformatf("match_count=%h miss_match_count=%h",match_count,miss_match_count))
				`uvm_fatal("mem_full_wr_rd_test","########## TEST FAILED ########")
			end
	endfunction

endclass

class mem_full_wr_rd_test extends mem_base_test;
//1.factory registartion
`uvm_component_utils(mem_full_wr_rd_test)
int match_count;
int miss_match_count;
int tst_sts;

//2.constructor
function new(string name="",uvm_component parent);
	super.new(name,parent);
endfunction
//3.sub class instatiation if present and if neded any property declare it
//4.uvm_common phases
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction


	task run_phase(uvm_phase phase);
		//1.instantiation and create the seq
		mem_full_wr_rd_seq seq_h =mem_full_wr_rd_seq::type_id::create("seq_h");
		//2.raise the objection
		phase.raise_objection(this);
		//3.map the seq to sqr
		seq_h.start(mem_env_h.mem_agent_h.mem_sqr_h);
		//4.set drain time
		phase.phase_done.set_drain_time(this,100);
		//5.drop the objection
		phase.drop_objection(this);
	endtask
	function void extract_phase(uvm_phase phase);	
		`uvm_info("mem_full_wr_rd_test","extract_phase",UVM_NONE)
			match_count=mem_env_h.mem_sbd_h.match_count;
			miss_match_count=mem_env_h.mem_sbd_h.miss_match_count;
	endfunction
	function void check_phase(uvm_phase phase);
		`uvm_info("mem_full_wr_rd_test","check_phase",UVM_NONE)
			if(`DEPTH == match_count && miss_match_count == 0)begin
				tst_sts=1;
			end
			else begin
				tst_sts=0;
			end
	endfunction
	function void report_phase(uvm_phase phase);
		`uvm_info("mem_full_wr_rd_test","report_phase",UVM_NONE)
			if(tst_sts==1)begin
				`uvm_info("mem_full_wr_rd_test","########## TEST PASSED ########",UVM_NONE)
			end
			else begin
				`uvm_error("mem_full_wr_rd_test",$sformatf("match_count=%h miss_match_count=%h",match_count,miss_match_count))
				`uvm_fatal("mem_full_wr_rd_test","########## TEST FAILED ########")
			end
	endfunction
endclass

//in mem_5_wr_rd_test we make use of mem_5_wr_rd_seq
//in this mem_5_wr_rd_seq, we will use the existing seq to devolop this seq
class mem_5_wr_rd_test extends mem_base_test;

//1.factory registartion
`uvm_component_utils(mem_5_wr_rd_test)

//2.constructor
function new(string name="mem_5_wr_rd_test",uvm_component parent);
	super.new(name,parent);
endfunction
//map the seq to sqr
//syntax to map the seq to sqr in buildphase
//	function void build_phase(uvm_phase);
//		super.build_phase(phase);
//		uvm_config_db#(uvm_object_wrapper)::set(this,//cntxt
//												"mem_env_h.mem_agent_h.mem_sqr_h",//instance_name
//												"default_sequence",//field_name
//												mem_5_wr_rd_seq::get_type());//value

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(uvm_object_wrapper)::set(this,
												"mem_env_h.mem_agent_h.mem_sqr_h.run_phase",
												"default_sequence",
												mem_5_wr_rd_seq::get_type());
			//mem_5_wr_rd_seq is set to default seq
			//this mem_5_wr_rd_seq should run in the run_phase of mem_sqr
	endfunction
endclass

