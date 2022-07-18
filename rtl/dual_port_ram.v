module dual_port_ram #(
parameter DWIDTH = 8,
	  AWIDTH = 3
)
(
input  [DWIDTH-1:0] data_in,
input  [AWIDTH-1:0] waddr,
input  wclk,
input  wen,
output [DWIDTH-1:0] data_out,
output [AWIDTH-1:0] raddr
);
localparam DEPTH = 1<<AWIDTH;
reg [DWIDTH-1:0] mem [0:AWIDTH-1];

always @(posedge wclk) begin
if(wen) begin
mem[waddr] <= data_in;
end
end

assign data_out = mem[raddr];

endmodule
