class r_agent extends uvm_agent;
`uvm_component_utils(r_agent)
r_sequencer r_seqr;
r_driver    r_drv;
r_monitor   r_mon;

uvm_analysis_port#(fifo_r_trans) agt_r_ap;
function new(string name, uvm_component parent);
super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
r_seqr = r_sequencer::type_id::create("r_seqr", this);
r_drv  = r_driver::type_id::create("r_drv", this);
r_mon  = r_monitor::type_id::create("r_mon", this);
endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
r_drv.seq_item_port.connect(r_seqr.seq_item_export);
agt_r_ap = r_mon.mon_r_ap;
endfunction


endclass
