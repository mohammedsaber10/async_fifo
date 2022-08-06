class w_monitor extends uvm_monitor;
`uvm_component_utils(w_monitor)
virtual fifo_w_if w_vif;
uvm_analysis_port#(fifo_w_trans) mon_w_ap;
fifo_w_trans m_tr;
function new(string name, uvm_component parent);
super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(virtual fifo_w_if)::get(this, "", "w_vif", w_vif))
`uvm_fatal(get_type_name(), "Cannot find a valid value for write virtual interface")
mon_w_ap = new("mon_w_ap", this);
endfunction


virtual task main_phase(uvm_phase phase);
super.main_phase(phase);
`uvm_info(get_type_name(), "Starting monitoring data job...", UVM_MEDIUM)
//sampling the data at the next clock edge
forever begin
m_tr = fifo_w_trans::type_id::create("m_tr");
`uvm_info(get_type_name(), "Collecting write transaction data from the interface", UVM_MEDIUM)
// Waiting another clock cycle to sample the data on the next edge (drive on an edge, and sample on the next edge)
// Monitoring and sending the data only if the write enable is active
@(posedge w_vif.wclk iff (w_vif.wen && !w_vif.wfull)); 
begin
collect_data(m_tr);
// Write the collected data to the analysis port for further analysis
mon_w_ap.write(m_tr);
end
end
endtask


task collect_data(fifo_w_trans tr);
tr.wdata = w_vif.wdata;
tr.wen   = w_vif.wen;
`uvm_info(get_type_name(), tr.convert2string(), UVM_MEDIUM)
`uvm_info(get_type_name(),"The data is collected successfully", UVM_MEDIUM)
endtask


endclass
