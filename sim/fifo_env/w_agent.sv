class w_agent extends uvm_agent;
`uvm_component_utils(w_agent)

w_driver w_drv;
w_monitor w_mon;
w_sequencer w_seqr;

uvm_analysis_port#(fifo_w_trans) agt_w_ap;  

function new(string name, uvm_component parent);
super.new(name, parent);
endfunction 

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
w_drv  = w_driver::type_id::create("w_drv", this);
w_mon  = w_monitor::type_id::create("w_mon", this);
w_seqr = w_sequencer::type_id::create("w_seqr", this);
endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
//connecting driver port to sequencer's export (implementation port)
w_drv.seq_item_port.connect(w_seqr.seq_item_export);
//assigning monitor analysis port object to the new handle of the agent analysis port so that we can use the port of the agent to represent the monitor's port
agt_w_ap = w_mon.mon_w_ap;
endfunction


endclass
