interface fifo_r_if #(parameter DATASIZE = 8) (input rclk);

logic rrst_n;
logic [DATASIZE-1:0] rdata;
logic ren;
logic rempty;

endinterface
