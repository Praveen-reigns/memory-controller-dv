//uvm_subscriber already have export defined
//i.e uvm_analysis_imp #(T, this_type) analysis export
//and also have a pure virtual method 
//i.e function: write 
//a pure virtual method that must be defined each sub class. Access to this method by outside components should be done by the analysis_expoert
//pure virual function void write (T t) 
class mem_cov extends uvm_subscriber#(mem_tx);
//1.factory registartion
`uvm_component_utils(mem_cov)

mem_tx tx;
	covergroup mem_cg;
		//WR_RD
		WR_RD_CP:coverpoint tx.wr_rd;//2
		//ADDR
		ADDR_CP:coverpoint tx.addr;//16
		//WR_RD_CP X ADDR_CP cross cp
		WR_RD_X_ADDR:cross WR_RD_CP,ADDR_CP;//32
	endgroup
//2.constructor
	function new(string name="",uvm_component parent);
		super.new(name,parent);
		mem_cg=new();	
	endfunction

	virtual function void write(mem_tx t);
		$cast(tx,t);
		mem_cg.sample();
	endfunction

endclass
