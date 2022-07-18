class r_sequencer extends uvm_sequencer #(fifo_r_trans);
`uvm_component_utils(r_sequencer)

function new(string name, uvm_component parent);
super.new(name, parent);
endfunction
endclass
