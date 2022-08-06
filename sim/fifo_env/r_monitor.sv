class r_monitor extends uvm_monitor;
`uvm_component_utils(r_monitor)

virtual fifo_r_if r_vif;
uvm_analysis_port#(fifo_r_trans) mon_r_ap;
fifo_r_trans m_tr;


function new(string name, uvm_component parent);
super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(virtual fifo_r_if)::get(this, "", "r_vif", r_vif))
`uvm_fatal(get_type_name(), "Cannot find a valid read virtual interface")
mon_r_ap = new("mon_r_ap", this);
endfunction

virtual task main_phase(uvm_phase phase);
super.main_phase(phase);
forever begin
//constructing new read transaction
m_tr = fifo_r_trans::type_id::create("m_tr");
//collecting data from read interface for comparison
@(posedge r_vif.rclk iff (r_vif.ren && !r_vif.rempty));
begin// collecting the data only if the read enable is active, otherwise the monitor will collect unexpected data values
// The data will be dropped out if the read enable is off
collect_output_data(m_tr);
//broadcasting data out of monitor for further analysis
mon_r_ap.write(m_tr);
end
end
endtask

task collect_output_data(fifo_r_trans tr);
tr.rdata = r_vif.rdata;
tr.ren   = r_vif.ren;
`uvm_info(get_type_name(), "Data is collected successfully from the interface", UVM_MEDIUM)
`uvm_info(get_type_name(), $sformatf("Data = 0x%0h, and read enable = 0x%0b on the read interface",r_vif.rdata, r_vif.ren), UVM_MEDIUM)
`uvm_info(get_type_name(), tr.convert2string(), UVM_MEDIUM)
endtask
endclass



