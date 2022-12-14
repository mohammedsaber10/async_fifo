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
else begin
exp_data.push_back(wr_tr); //inserting the incoming data into the expected data queue
`uvm_info("SB_WR_PORT", wr_tr.convert2string(), UVM_MEDIUM)
end
endfunction

function void write_rd_port(fifo_r_trans rd_tr);
if(rd_tr == null)
   `uvm_error("SB_RD_PORT", "No data is received at the read port")

else begin
act_data.push_back(rd_tr);
`uvm_info("SB_RD_PORT", rd_tr.convert2string(), UVM_MEDIUM)
end
endfunction
virtual function void extract_phase(uvm_phase phase);
//phase.raise_objection(this);
//fork
for(int i = 0; i < exp_data.size(); i++)
`uvm_info(get_type_name(), $sformatf("exp_data[%0d] = 0x%0h",i , exp_data[i].wdata), UVM_LOW)
for(int i = 0; i < act_data.size(); i++)
`uvm_info(get_type_name(), $sformatf("act_data[%0d] = 0x%0h",i,  act_data[i].rdata), UVM_LOW)
//join
//phase.drop_objection(this);
endfunction
//check phase
virtual function void check_phase(uvm_phase phase);
//super.check_phase(phase);
fifo_w_trans exp_tr;
fifo_r_trans act_tr;
 //storing the initial size of the queue to use it for looping
//as the queue size will change after each pop from it
int min_data_size_q = exp_data.size(); 
//
if(exp_data.size() < act_data.size()) begin
`uvm_error("SB_CHECK_PHASE", "No matching in data queues sizes!!..min queue size will be applied, and the other transactions will be dropped")
min_data_size_q = exp_data.size();
end
else if(exp_data.size() > act_data.size()) begin
`uvm_error("SB_CHECK_PHASE", "No matching in data queues sizes!!..min queue size will be applied, and the other transactions will be dropped")
min_data_size_q = act_data.size();
end
else min_data_size_q = exp_data.size();

if(exp_data.size() == 0 || act_data.size() == 0)
`uvm_error("SB_CHECK_PHASE", "No data found in the data queues")
repeat(min_data_size_q) begin
exp_tr = exp_data.pop_front();

`uvm_info(get_type_name(), $sformatf("Expected data = 0x%0h", exp_tr.wdata), UVM_LOW)
act_tr = act_data.pop_front();
`uvm_info(get_type_name(), $sformatf("Actual data = 0x%0h", act_tr.rdata), UVM_LOW)
//if(exp_tr.compare(act_tr)) 
if(exp_tr.wdata == act_tr.rdata)
   `uvm_info(get_type_name(), "Expected transaction matches the actual transaction!!", UVM_MEDIUM)
else
   `uvm_info(get_type_name(), "Expected transaction mismatches the actual transaction!!", UVM_MEDIUM) 
end
endfunction


endclass
