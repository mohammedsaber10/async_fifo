interface fifo_w_if #(parameter DATASIZE = 8) (input wclk);

wire wrst_n;
logic [DATASIZE-1:0] wdata;
logic wen;
logic wfull;

endinterface



