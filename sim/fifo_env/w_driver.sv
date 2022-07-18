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
    w_vif.wrst_n = 1'b1;
    @(posedge w_vif.wclk);
    w_vif.wrst_n = 1'b0;
    @(posedge w_vif.wclk);
    w_vif.wrst_n = 1'b1;

endtask

virtual task main_phase(uvm_phase phase);
super.main_phase(phase);

forever begin
//getting the next item from sequencer export
seq_item_port.get_next_item(req);
drive(req);  //driving the data every clock cycle
//sending back an acknowledge to the sequencer so that it can know that the driver has finished driving the current item.
seq_item_port.item_done();
end

endtask

task drive(fifo_w_trans tr);
@(posedge w_vif.wclk);
w_vif.wdata <= tr.wdata;
w_vif.wen  <= tr.wen;
endtask

endclass
