class fifo_r_seq extends uvm_sequence#(fifo_r_trans);
`uvm_object_utils(fifo_r_seq)

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
fifo_r_trans r_tr;
repeat(30) begin
r_tr = fifo_r_trans::type_id::create("r_tr");
start_item(r_tr);
assert(r_tr.randomize()) else `uvm_error(get_type_name(), "Read transaction cannot be randomized")
`uvm_info(get_type_name(), r_tr.convert2string(), UVM_MEDIUM)
finish_item(r_tr);
end
// sending end of sequence
`uvm_info(get_type_name(), "Sending end of read sequence...", UVM_MEDIUM)
//`uvm_do_with(r_tr, {ren == 0;})
r_tr = fifo_r_trans::type_id::create("r_tr");
start_item(r_tr);
assert(r_tr.randomize() with {ren == 0;}) else `uvm_error(get_type_name(), "Read transaction cannot be randomized")
`uvm_info(get_type_name(), r_tr.convert2string(), UVM_MEDIUM)
finish_item(r_tr);

endtask

/*
virtual task post_body();
if(!starting_phase != null)
starting_phase.drop_objection(this);
endtask
*/
endclass
