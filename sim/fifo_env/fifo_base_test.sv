class fifo_base_test extends uvm_test;
`uvm_component_utils(fifo_base_test)

fifo_env m_env;
fifo_w_seq w_seq;
fifo_r_seq r_seq;
function new(string name, uvm_component parent);
super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);

m_env = fifo_env::type_id::create("m_env", this);
endfunction

virtual task main_phase(uvm_phase phase);
super.main_phase(phase);
fork
w_seq.start(m_env.w_agt.w_seqr);
r_seq.start(m_env.r_agt.r_seqr);
join
endtask

endclass
