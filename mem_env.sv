class mem_env extends uvm_env;
//1.factory registartion
`uvm_component_utils(mem_env)

//2.constructor
function new(string name="",uvm_component parent);
	super.new(name,parent);
endfunction
//3.sub class instatiation if present and if neded any property declare it
mem_agent mem_agent_h;
mem_sbd mem_sbd_h;
//4.uvm_common phases
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mem_agent_h=mem_agent::type_id::create("mem_agent_h",this);
		mem_sbd_h=mem_sbd::type_id::create("mem_sbd_h",this);
	endfunction
	function void connect_phase(uvm_phase phase);
		//TODO -agent.monitor connect sbd using tlm1.0
		mem_agent_h.mem_mon_h.mon_ap_h.connect(mem_sbd_h.analysis_export); 	
	endfunction
endclass
