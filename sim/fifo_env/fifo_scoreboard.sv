class fifo_scoreboard extends uvm_scoreboard;
`uvm_component_utils(fifo_scoreboard)

`uvm_analysis_imp_decl(_wr_port)
`uvm_analysis_imp_decl(_rd_port)

uvm_analysis_imp_wr_port#(fifo_w_trans, fifo_scoreboard) wr_export;
uvm_analysis_imp_rd_port#(fifo_r_trans, fifo_scoreboard) rd_export;

fifo_w_trans exp_data[$]; //input data
fifo_r_trans act_data[$]; //output data
int unsigned num_success = 0;
function new(string name, uvm_component parent);
super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
wr_export = new("wr_export", this);
rd_export = new("rd_export", this);
endfunction

function void write_wr_port(fifo_w_trans wr_tr);
if(wr_tr == null)
   `uvm_error("SB_WR_PORT", "No data is received at the write port")
else exp_data.push_back(wr_tr); //inserting the incoming data into the expected data queue

endfunction

function void write_rd_port(fifo_r_trans rd_tr);
if(rd_tr == null)
   `uvm_error("SB_RD_PORT", "No data is received at the read port")
else act_data.push_back(rd_tr);
endfunction

//check phase
virtual function void check_phase(uvm_phase phase);
//super.check_phase(phase);
fifo_w_trans exp_tr;
fifo_r_trans act_tr;
 //storing the initial size of the queue to use it for looping
//as the queue size will change after each pop from it
int exp_data_size = exp_data.size(); 
//
if(exp_data.size() != act_data.size())
`uvm_error("SB_CHECK_PHASE", "unexpected data queues sizes")
if(exp_data.size() == 0 || act_data.size() == 0)
`uvm_error("SB_CHECK_PHASE", "No data found in the data queues")
repeat(exp_data_size) begin
exp_tr = exp_data.pop_front();
act_tr = act_data.pop_front();
if(exp_tr.compare(act_tr)) 
   `uvm_info(get_type_name(), "Expected transaction matches the actual transaction!!", UVM_MEDIUM)
else
   `uvm_info(get_type_name(), "Expected transaction mismatches the actual transaction!!", UVM_MEDIUM) 
end
endfunction




endclass
