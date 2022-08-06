`include "./fifo_if/fifo_w_if.sv"
`include "./fifo_if/fifo_r_if.sv"
`include "fifo_env_pkg.sv"

module tb_top;
import uvm_pkg::*;
import fifo_env_pkg::*;

bit wclk;
bit rclk;

initial begin
wclk = 0; 
forever begin
`uvm_info("WCLK", $sformatf("wclk = %0b", wclk), UVM_MEDIUM)
#5 wclk =~ wclk;
end
end

initial begin
rclk = 0;
forever begin
`uvm_info("RCLK", $sformatf("rclk = %0b", rclk), UVM_MEDIUM)
#5 rclk =~ rclk;
end
end
/*
task reset();
w_if.wrst_n = 1;
r_if.wrst_n = 1;
#3;
w_if.wrst_n = 0;
r_if.wrst_n = 0;
#3;
w_if.wrst_n = 1;
r_if.wrst_n = 1;
#80;

endtask
*/
fifo_w_if w_if (wclk);
fifo_r_if r_if (rclk);

bind fifo fifo_sva fifo_sva_U (.*);

fifo dut 
(
//write interface
.wclk(wclk),
.wrst_n(w_if.wrst_n),
.wenable(w_if.wen),
.DataIn(w_if.wdata),
.full(w_if.wfull),
//read interface
.rclk(rclk),
.rrst_n(r_if.rrst_n),
.renable(r_if.ren),
.DataOut(r_if.rdata),
.empty(r_if.rempty)
);

initial begin 
uvm_config_db#(virtual fifo_w_if)::set(null, "uvm_test_top.*", "w_vif", w_if);
uvm_config_db#(virtual fifo_r_if)::set(null, "uvm_test_top.*", "r_vif", r_if);
run_test("fifo_base_test");
end

initial begin
$fsdbDumpfile("tb_top.fsdb");
$fsdbDumpvars(0, tb_top);
end
endmodule
