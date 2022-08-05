class fifo_base_test extends uvm_test;
`uvm_component_utils(fifo_base_test)

fifo_env m_env;
fifo_w_seq w_seq;
fifo_r_seq r_seq;

int write_items = 5;
int read_items = 5;

function new(string name, uvm_component parent);
super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
/*
if(!uvm_config_db#(virtual fifo_w_if)::get(this, "", "w_vif", w_vif))
`uvm_fatal(get_type_name(), "Write interface cannot be obtained")
if(!uvm_config_db#(virtual fifo_r_if)::get(this, "", "r_vif", r_vif))
`uvm_fatal(get_type_name(), "Read interface cannot be obtained")
*/
m_env = fifo_env::type_id::create("m_env", this);
endfunction

virtual function void end_of_elaboration_phase(uvm_phase phase);
super.end_of_elaboration_phase(phase);
uvm_top.print_topology();
endfunction

virtual function void start_of_simulation_phase(uvm_phase phase);
super.start_of_simulation_phase(phase);
w_seq = fifo_w_seq::type_id::create("w_seq");
r_seq = fifo_r_seq::type_id::create("r_seq");
endfunction
/*
virtual task reset_phase(uvm_phase phase);
super.reset_phase(phase);
w_if.wrst_n = 1;
r_if.rrst_n = 1;
#3;
w_if.wrst_n = 0;
r_if.rrst_n = 0;
#3;
w_if.wrst_n = 1;
r_if.rrst_n = 1;
#80;
endtask
*/
virtual task main_phase(uvm_phase phase);
super.main_phase(phase);
phase.raise_objection(this);

fork
begin
`uvm_info(get_type_name(), "Starting Write sequence...", UVM_MEDIUM)
w_seq.start(m_env.w_agt.w_seqr);
end
begin
`uvm_info(get_type_name(), "Starting Read Sequence...", UVM_MEDIUM)
r_seq.start(m_env.r_agt.r_seqr);
end
join
phase.drop_objection(this);

endtask

endclass
