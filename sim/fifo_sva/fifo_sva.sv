module fifo_sva 
(
input wclk,
input rclk,
input wrst_n,
input rrst_n,
input wenable,
input renable,
input full,
input empty);


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
/************          FIFO full properties          ******************/
int w_ctr_full, r_ctr_full;

initial begin
w_ctr_full = 0;
r_ctr_full = 0;
end
//counts no. of writes in the fifo in case of fifo is not full
always @(posedge wclk) begin
if(full) // if fifo is full regardless to the write enable, reset the write counter, so that we can make a new check on full condition
w_ctr_full = 0;
else if(wenable && !full) w_ctr_full++;
// else the counter remains the same
end

//count no. of reads in case of fifo is not empty
always @(posedge rclk) begin
if ($fell(full)) r_ctr_full = 0;
if(renable && !empty) r_ctr_full++; // count up in case of enable is on, and not empty
end

property fifo_full;
@(posedge wclk) disable iff (!wrst_n)
(w_ctr_full >= r_ctr_full + 8) |-> $rose(full); //the fifo is full if no. of writes is greater than or equal to the no. of reads 
endproperty

property fifo_not_full;
@(posedge wclk) disable iff(!wrst_n)
($past(!full) && (w_ctr_full < r_ctr_full + 8)) |-> (!full); //the fifo is not full if no. of writes is less than no. of reads 
endproperty

//full condition will hold if the write enable is on, and read enable is off with the past value of full is 1

property fifo_stable_full;
@(posedge wclk) disable iff (!wrst_n)
($past(full) && !renable) |-> (full);
endproperty

/************          FIFO empty properties          ******************/
int w_ctr_empty, r_ctr_empty;

always@(posedge wclk, negedge wrst_n) begin
if(!wrst_n) w_ctr_empty = 0;    //if the fifo is full and the write enable is off, don't incr. the write counter
else if (wenable && !full) w_ctr_empty++;
end

always@(posedge rclk, negedge rrst_n) begin
if(!rrst_n) r_ctr_empty = 0;
else if (renable && !empty) r_ctr_empty++;
end
// fifo is empty if the write counter just equals the read counter in all cases

property fifo_empty;
@(posedge rclk) disable iff (!rrst_n)
(w_ctr_empty == r_ctr_empty) |-> (empty);
endproperty

property fifo_not_empty;
@(posedge rclk) disable iff (!rrst_n)
(w_ctr_empty != r_ctr_empty) |-> (!empty);
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
a_fifo_stable_full  :assert property (fifo_stable_full); 
a_fifo_not_full     :assert property (fifo_not_full);
a_fifo_empty        :assert property (fifo_empty);
a_fifo_not_empty    :assert property (fifo_not_empty);
a_write_nfull_nempty:assert property (write_nfull_nempty);
a_read_nfull_nempty :assert property (read_nfull_nempty);

//cover properties
c_wrst_nfull        :cover property (wrst_nfull);
c_rrst_empty        :cover property (rrst_empty);
c_fifo_full         :cover property (fifo_full);
c_fifo_stable_full  :cover property (fifo_stable_full); 
c_fifo_empty        :cover property (fifo_empty);
c_fifo_not_empty    :cover property (fifo_not_empty);
c_fifo_not_full     :cover property (fifo_not_full);
c_write_nfull_nempty:cover property (write_nfull_nempty);
c_read_nfull_nempty :cover property (read_nfull_nempty);

endmodule
