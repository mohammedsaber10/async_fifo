package fifo_env_pkg;
import uvm_pkg::*;

`include "./fifo_seq/fifo_w_trans.sv"
`include "./fifo_seq/fifo_w_seq.sv"
`include "./fifo_seq/fifo_r_trans.sv"
`include "./fifo_seq/fifo_r_seq.sv"
`include "./fifo_env/w_sequencer.sv"
`include "./fifo_env/w_driver.sv"
`include "./fifo_env/w_monitor.sv"
`include "./fifo_env/w_agent.sv"
`include "./fifo_env/r_sequencer.sv"
`include "./fifo_env/r_driver.sv"
`include "./fifo_env/r_monitor.sv"
`include "./fifo_env/r_agent.sv"
`include "./fifo_env/fifo_scoreboard.sv"
`include "./fifo_env/fifo_env.sv"
`include "./fifo_base_test.sv"

endpackage
