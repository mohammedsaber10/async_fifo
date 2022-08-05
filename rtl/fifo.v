module fifo
#(
parameter DATAWIDTH = 8,
	  ADDRWIDTH = 3
)
(
///////WRITE DOMAIN////////
input wclk,
input wrst_n,
input wenable,
input [DATAWIDTH-1:0] DataIn,
output full,

///////READ DOMAIN////////
input rclk,
input rrst_n,
input renable,
output [DATAWIDTH-1:0] DataOut,
output empty
);
///////SYNCING RAED AND WRITE DOMAINS///////////
wire [ADDRWIDTH-1:0] waddr, raddr;
wire [ADDRWIDTH:0] r2wptr_sync, w2rptr_sync, wptr, rptr;
wire wenable_m;

dual_port_ram ram (
.data_in (DataIn),
.waddr   (waddr),
.wclk    (wclk),
.wen	 (wenable_m),
.data_out(DataOut),
.raddr   (raddr)
);

wptr_wfull wptr_full (
.wclk	 (wclk),
.wrst_n  (wrst_n),
.winc	 (wenable),
.rptr	 (r2wptr_sync),
.waddr   (waddr),
.wptr    (wptr),
.wfull   (full),
.wen     (wenable_m)
);

rptr_rempty rptr_empty (
.rclk    (rclk),
.rrst_n  (rrst_n),
.rinc    (renable),
.wptr    (w2rptr_sync),
.raddr   (raddr),
.rptr    (rptr),
.rempty  (empty)
);

sync r2w_sync (
.d       (rptr),
.clk     (wclk),
.rst_n   (wrst_n),
.q       (r2wptr_sync)
);

sync w2r_sync (
.d       (wptr),
.clk     (rclk),
.rst_n   (rrst_n),
.q       (w2rptr_sync)
);



endmodule
