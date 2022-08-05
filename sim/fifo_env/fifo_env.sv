class fifo_env extends uvm_env;
`uvm_component_utils(fifo_env)

w_agent w_agt;
r_agent r_agt;
fifo_scoreboard m_sb;
function new(string name, uvm_component parent);
super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
w_agt = w_agent::type_id::create("w_agt", this);
r_agt = r_agent::type_id::create("r_agt", this);
m_sb  = fifo_scoreboard::type_id::create("m_sb", this);
endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
w_agt.agt_w_ap.connect(m_sb.wr_export);
r_agt.agt_r_ap.connect(m_sb.rd_export);
endfunction
endclass
