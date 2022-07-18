class r_monitor extends uvm_monitor;
`uvm_component_utils(r_monitor)

virtual fifo_r_if r_vif;
uvm_analysis_port#(fifo_r_trans) mon_r_ap;
function new(string name, uvm_component parent);
super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(virtual fifo_r_if)::get(this, "", "r_vif", r_vif))
`uvm_fatal(get_type_name(), "Cannot find a valid read virtual interface")
endfunction

virtual task main_phase(uvm_phase phase);
fifo_r_trans tr;

forever begin
//constructing new read transaction
tr = new("tr");
//collecting data from read interface for comparison
collect_output_data(tr);
//broadcasting data out of monitor for further analysis
mon_r_ap.write(tr);
end
endtask

task collect_output_data(fifo_r_trans tr);
@(posedge r_vif.rclk);
tr.rdata <= r_vif.rdata;
endtask
endclass



