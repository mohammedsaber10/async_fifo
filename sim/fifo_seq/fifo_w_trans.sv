
class fifo_w_trans extends uvm_sequence_item;
rand bit [7:0] wdata;
rand bit wen;
`uvm_object_utils_begin(fifo_w_trans)
	`uvm_field_int(wdata, UVM_ALL_ON)
        `uvm_field_int(wen, UVM_ALL_ON | UVM_NOCOMPARE) 
`uvm_object_utils_end

function new(string name = "");
super.new(name);
endfunction

endclass
