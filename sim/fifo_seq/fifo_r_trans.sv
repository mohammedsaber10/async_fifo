
class fifo_r_trans extends uvm_sequence_item;
bit [7:0] rdata;
rand bit ren;
//`uvm_object_utils_begin(fifo_w_trans)
`uvm_object_utils_begin(fifo_r_trans)
   `uvm_field_int(ren, UVM_ALL_ON | UVM_NOCOMPARE)
   `uvm_field_int(rdata, UVM_ALL_ON)
`uvm_object_utils_end

function new(string name = "");
super.new(name);
endfunction

endclass
