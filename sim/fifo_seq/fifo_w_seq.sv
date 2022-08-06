class fifo_w_seq extends uvm_sequence #(fifo_w_trans);
`uvm_object_utils(fifo_w_seq)

function new(string name = "");
super.new(name);
endfunction

/*
virtual task pre_body();
if(!starting_phase != null)
starting_phase.raise_objection(this);
endtask
*/
virtual task body();
fifo_w_trans w_tr;
repeat(50) begin
w_tr = fifo_w_trans::type_id::create("w_tr");
start_item(w_tr);
assert(w_tr.randomize())
else `uvm_error(get_type_name(), "Write transaction cannot be randomized")
`uvm_info(get_type_name(), w_tr.convert2string(), UVM_MEDIUM)
finish_item(w_tr);
end
//Sending end of sequence
`uvm_info(get_type_name(), "Sending end of write sequence...", UVM_LOW)
w_tr = fifo_w_trans::type_id::create("w_tr");
start_item(w_tr);
assert(w_tr.randomize() with {wen == 0;})
else `uvm_error(get_type_name(), "Write transaction cannot be randomized")
`uvm_info(get_type_name(), w_tr.convert2string(), UVM_MEDIUM)
finish_item(w_tr);
//`uvm_do_with(w_tr, {wen == 0;})
endtask

/*
virtual task post_body();
if(!starting_phase != null)
starting_phase.drop_objection(this);
endtask
*/

endclass
