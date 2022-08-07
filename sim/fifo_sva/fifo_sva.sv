module fifo_sva 
(
input wclk,
input rclk,
input wrst_n,
input rrst_n,
input wenable,
input renable,
input full,
input empty
);


/********** Asynchronous Write Reset ---> Not full property ************/
property wrst_nfull;
@(posedge wclk) 
(!wrst_n) |-> !full;
endproperty

/**********  Asynchronous Read Reset ---> Empty Property     ***********/
property rrst_empty;
@(posedge rclk) 
(!rrst_n) |-> empty;
endproperty

/************ Counting up no. of Reads and Writes  *******************/
int w_ctr, r_ctr;

initial begin
w_ctr = 0;
r_ctr = 0;
end

always @(posedge wclk, negedge wrst_n) begin
if(!wrst_n) 
w_ctr = 0;
else if(wenable && !full) w_ctr++;
end


always @(posedge rclk) begin
if (!rrst_n) r_ctr = 0;
if(renable && !empty) r_ctr++; 
end


/************          FIFO full properties          ******************/
//the fifo is full if no. of writes is equal to the no. of reads + 8
property fifo_full;
@(posedge wclk) disable iff (!wrst_n)
(w_ctr == r_ctr + 8) |-> (full); endproperty

// the fifo is not full if no. of writes is not equal to no. of reads + 8
// We will regard for the sync. of write domain as the the full condition may hold for 2 more cycles until the read pointer is sync'd with the write domain
property fifo_not_full;
@(posedge wclk) disable iff(!wrst_n)
(w_ctr != r_ctr + 8) |-> ##[0:3](!full);
endproperty


/************          FIFO empty properties          ******************/

// fifo is empty if the write counter just equals the read counter in all cases
// we will not consider the false empty case, at which the read pointer matches the old late write pointer due to sync. issues.
// In this case, we actually asserts that the fifo is really empty, regardless to sync. issues.

property fifo_empty;
@(posedge rclk) disable iff (!rrst_n)
(w_ctr == r_ctr) |-> (empty);
endproperty

// if the fifo previously empty, and not empty condition is satisfied, we need to account for sync. of fifo after empty condition for 2 cycles
// so that wctr can catch the rctr in its domain, and the fifo then will not be empty after these cycles...
// the fifo is also not empty in the normal case at which the w_ctr not equal the r_ctr.

property fifo_not_empty;
@(posedge rclk) disable iff (!rrst_n)
(w_ctr != r_ctr) |-> ##[0:3](!empty);
endproperty

//fifo must be not (full and empty) at the same time (forbidden case) NO implication required


property write_nfull_nempty;
@(posedge wclk) !(full && empty);
endproperty

property read_nfull_nempty;
@(posedge rclk) !(full && empty);
endproperty


//assert properties
a_wrst_nfull        :assert property (wrst_nfull);
a_rrst_empty        :assert property (rrst_empty);
a_fifo_full         :assert property (fifo_full);
a_fifo_not_full     :assert property (fifo_not_full);
a_fifo_empty        :assert property (fifo_empty);
a_fifo_not_empty    :assert property (fifo_not_empty);
a_write_nfull_nempty:assert property (write_nfull_nempty);
a_read_nfull_nempty :assert property (read_nfull_nempty);

//cover properties
c_wrst_nfull        :cover property (wrst_nfull);
c_rrst_empty        :cover property (rrst_empty);
c_fifo_full         :cover property (fifo_full);
c_fifo_empty        :cover property (fifo_empty);
c_fifo_not_empty    :cover property (fifo_not_empty);
c_fifo_not_full     :cover property (fifo_not_full);
c_write_nfull_nempty:cover property (write_nfull_nempty);
c_read_nfull_nempty :cover property (read_nfull_nempty);

endmodule
