`include "../fifo_if/fifo_w_if.sv"
`include "../fifo_if/fifo_r_if.sv"
`include "fifo_env_pkg.sv"

module tb_top;
import uvm_pkg::*;
import fifo_env_pkg::*;
/*
bit wclk;
bit rclk;

initial 
forever #5 wclk =~ wclk;

initial 
forever #5 rclk =~ rclk;

fifo_w_if w_if (wclk);
fifo_r_if r_if (rclk);

initial begin 
uvm_config_db#(virtual fifo_w_if)::set(null, "uvm_test_top.m_env.w_agt.*", "w_vif", w_if);
uvm_config_db#(virtual fifo_r_if)::set(null, "uvm_test_top.m_env.r_agt.*", "r_vif", r_if);
//run_test("fifo_test_base");

end
*/
endmodule

