module wptr_wfull
#(
parameter AWIDTH = 3
)
(
input wclk, wrst_n, winc,
input [AWIDTH:0] rptr,
output [AWIDTH-1:0] waddr,
output reg [AWIDTH:0]   wptr, //address width + 1
output reg wfull,
output wen
);
// all signals that have a width of (address + 1) are used in comparison
wire [AWIDTH:0] bnext; //address width + 1
wire wenable;
reg [AWIDTH:0] bin;    //address width + 1
reg [AWIDTH:0] gnext;  //address width + 1
reg full_val;

assign wenable = winc & ~wfull;
assign bnext = bin + wenable;
always@(posedge wclk, negedge wrst_n)
if(!wrst_n) bin <= 0;
else bin <= bnext;

assign waddr = bin[AWIDTH-1:0];

//////////Handling full condition/////////////////
//1. binary to gray logic
always @* 
begin : gray2bin
integer i;
for (i = 0; i < AWIDTH; i =  i + 1) //loop from i=0 to 2 in our case 
    gnext[i] = bnext[i] ^ bnext[i+1]; 

gnext[AWIDTH-1] = bnext[AWIDTH-1];
end

///////////////////////////////////////////////
//2. Synchronizing the gray code pointer to be transferred in the other domain
always @(posedge wclk, negedge wrst_n) begin
if(!wrst_n) wptr <= 0;
else wptr <= gnext;
end

///////////////////////////////////////////////////
//3. Generation of full condition
always@* begin

if((gnext[AWIDTH-1] != rptr[AWIDTH-1]) &&
   (gnext[AWIDTH-2] != rptr[AWIDTH-2]) &&
   (gnext[AWIDTH-3:0] == rptr[AWIDTH-3:0]))
full_val = 1;

else full_val = 0;
end

//4. Registering full value to be synchronized with the clock
always @(posedge wclk, negedge wrst_n) begin
if(!wrst_n) wfull <= 0;
else wfull <= full_val;
end

assign wen = wenable;
endmodule
