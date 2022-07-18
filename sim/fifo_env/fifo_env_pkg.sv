//`include "../fifo_if/fifo_w_if.sv"
//`include "../fifo_if/fifo_r_if.sv"

package fifo_env_pkg;
import uvm_pkg::*;
`include "../fifo_seq/fifo_w_trans.sv"
`include "../fifo_seq/fifo_r_trans.sv"
`include "../fifo_seq/fifo_w_seq.sv"
`include "../fifo_seq/fifo_r_seq.sv"
`include "w_driver.sv"
`include "w_monitor.sv"
`include "w_sequencer.sv"
`include "w_agent.sv"
`include "r_driver.sv"
`include "r_monitor.sv"
`include "r_sequencer.sv"
`include "r_agent.sv"
`include "fifo_scoreboard.sv"
`include "fifo_env.sv"
`include "fifo_base_test.sv"
endpackage
