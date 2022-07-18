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
r_vif.rrst_n <= 1'b1;
@(posedge r_vif.rclk);
r_vif.rrst_n <= 1'b0;
@(posedge r_vif.rclk);
r_vif.rrst_n <= 1'b1;


endtask

virtual task main_phase(uvm_phase phase);
super.main_phase(phase);

forever begin
seq_item_port.get_next_item(req);
drive_read_enable(req);
seq_item_port.item_done();
end
endtask

task drive_read_enable(fifo_r_trans tr);
@(posedge r_vif.rclk);
r_vif.ren <= tr.ren;
endtask

endclass
