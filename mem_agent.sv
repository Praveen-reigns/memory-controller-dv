class mem_agent extends uvm_agent;
//1.factory registartion
`uvm_component_utils(mem_agent)

//2.constructor
function new(string name="",uvm_component parent);
	super.new(name,parent);
endfunction
//3.sub class instatiation if present and if neded any property declare it
mem_mon mem_mon_h;
mem_drv mem_drv_h;
mem_sqr mem_sqr_h;
mem_cov mem_cov_h;
//4.uvm_common phases
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mem_mon_h=mem_mon::type_id::create("mem_mon_h",this);
		mem_drv_h=mem_drv::type_id::create("mem_drv_h",this);
		mem_sqr_h=mem_sqr::type_id::create("mem_sqr_h",this);
		mem_cov_h=mem_cov::type_id::create("mem_cov_h",this);
	endfunction
	function void connect_phase(uvm_phase phase);
		//TODO - sqr connect to drv using tlm1.0
			mem_drv_h.seq_item_port.connect(mem_sqr_h.seq_item_export);
		//TODO -agent.monitor connect cov using tlm1.0
			mem_mon_h.mon_ap_h.connect(mem_cov_h.analysis_export);
	endfunction
endclass
