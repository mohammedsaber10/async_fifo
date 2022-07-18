class w_monitor extends uvm_monitor;
`uvm_component_utils(w_monitor)

virtual fifo_w_if w_vif;
uvm_analysis_port#(fifo_w_trans) mon_w_ap;

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
fifo_w_trans tr;
forever begin
//constructing new write transaction every cycle so as not to override the data of the transmitted objects.
tr = new("tr");
// collecting the data from the interface using the constructed object
collect_data(tr);
//write the collected data to the analysis port for further analysis
mon_w_ap.write(tr);
end
endtask
// the task for collecting the data from the interface at the active clk edge
task collect_data(fifo_w_trans tr);
@(posedge w_vif.wclk);
tr.wdata <= w_vif.wdata;
endtask
endclass
