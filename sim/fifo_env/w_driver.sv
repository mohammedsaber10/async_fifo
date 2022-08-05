class w_driver extends uvm_driver #(fifo_w_trans);
`uvm_component_utils(w_driver)
virtual fifo_w_if w_vif;

function new (string name, uvm_component parent);
super.new(name, parent);
endfunction

virtual function void build_phase (uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(virtual fifo_w_if)::get(this,"", "w_vif", w_vif))
`uvm_fatal(get_type_name(),"Cannot get a correct value for the virtual interface")
endfunction

virtual task reset_phase(uvm_phase phase);
super.reset_phase(phase);
phase.raise_objection(this);
    w_vif.wrst_n = 1'b1;
#3;
    w_vif.wrst_n = 1'b0;
    w_vif.wen    = 1'b0;
#3; 
    w_vif.wrst_n = 1'b1;
phase.drop_objection(this);
endtask


virtual task main_phase(uvm_phase phase);
super.main_phase(phase);
forever begin
//get the data from sequencer only if the fifo is not full
seq_item_port.get_next_item(req); // getting the transaction from the sequencer is a must. NO condition on it
if(!w_vif.wfull) begin // check if fifo is not full, drive the transaction to the interface, else drop it.
drive(req);  
end
else
`uvm_info(get_type_name(), "Transaction is dropped as the fifo is full", UVM_MEDIUM)
seq_item_port.item_done();
end
endtask


task drive(fifo_w_trans tr);
@(posedge w_vif.wclk);
w_vif.wdata <= tr.wdata;
w_vif.wen   <= tr.wen;
`uvm_info(get_type_name(),"Data is drived successfully to the interface @ the positive edge of the wclk", UVM_MEDIUM)
`uvm_info(get_type_name(),$sformatf("Write Data = 0x%0h, and Write enable = %0b, that drived on the interface", w_vif.wdata, w_vif.wen), UVM_MEDIUM)
endtask


endclass
