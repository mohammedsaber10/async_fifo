module sync #(
parameter SIZE = 4
)
(
input [SIZE-1:0] d,
input clk,
input rst_n,
output reg [SIZE-1:0] q
);
reg [SIZE-1:0] q_m;

always @(posedge clk, negedge rst_n) begin
if(!rst_n) begin 
q <= 0;
q_m <= 0;
end
else begin
q_m <= d;
q <= q_m;
end

end

endmodule
