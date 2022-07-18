class fifo_w_seq extends uvm_sequence #(fifo_w_trans);
`uvm_object_utils(fifo_w_seq)

function new(string name = "");
super.new(name);
endfunction

virtual task pre_body();
if(!starting_phase != null)
starting_phase.raise_objection(this);
endtask

virtual task body();
fifo_w_trans w_tr;
repeat(2) begin
w_tr = fifo_w_trans::type_id::create("w_tr");
start_item(w_tr);
assert(w_tr.randomize()) else `uvm_error(get_type_name(), "Write transaction cannot be randomized")
finish_item(w_tr);
end
endtask

virtual task post_body();
if(!starting_phase != null)
starting_phase.drop_objection(this);
endtask

endclass
