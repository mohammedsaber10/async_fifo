class r_driver extends uvm_driver #(fifo_r_trans);
`uvm_component_utils(r_driver)

virtual fifo_r_if r_vif;

function new(string name, uvm_component parent);
super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(virtual fifo_r_if)::get(this, "", "r_vif", r_vif))
`uvm_fatal(get_type_name(), "Cannot get a valid value for the read virtual interface")
endfunction


virtual task reset_phase(uvm_phase phase);
super.reset_phase(phase);
phase.raise_objection(this);
r_vif.rrst_n = 1'b1;
#3;
r_vif.rrst_n = 1'b0;
r_vif.ren    = 1'b0;
#3;
r_vif.rrst_n = 1'b1;

phase.drop_objection(this);
endtask

virtual task main_phase(uvm_phase phase);
super.main_phase(phase);

forever begin
// beginning the drive task @ positive edge of rclk only
// the read driver then will not read the incoming data even if the read enable is high-->> empty signal must be low first to start reading
 // get the the transaction from the read sequencer
seq_item_port.get_next_item(req);
// Drive the transaction only if the fifo is not empty
if (!r_vif.rempty) begin   
drive_read_enable(req);
end
seq_item_port.item_done();
end
endtask

task drive_read_enable(fifo_r_trans tr);
@(posedge r_vif.rclk);
r_vif.ren <= tr.ren;
`uvm_info(get_type_name(), "Read enable is drived successfully to the read interface", UVM_MEDIUM)
`uvm_info(get_type_name(), $sformatf("Data in read driver = 0x%0h, and read enable = 0x%0b", r_vif.rdata, r_vif.ren), UVM_MEDIUM)
endtask

endclass
