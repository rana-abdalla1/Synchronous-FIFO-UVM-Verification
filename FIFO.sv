module FIFO(fifo_if.DUT fifoif);

parameter FIFO_DEPTH = 8;
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [fifoif.FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count; 

 always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
        if (!fifoif.rst_n) begin    //resetting all values to 0
            wr_ptr <= 0;
            fifoif.wr_ack <= 0;
            fifoif.overflow <= 0;
        end else if (fifoif.wr_en && count < FIFO_DEPTH) begin   //modified the condition to check if the FIFO is fifoif.full or not
            mem[wr_ptr] <= fifoif.data_in;
            fifoif.wr_ack <= 1;
            wr_ptr <= wr_ptr + 1;
        end else if (fifoif.wr_en && count == FIFO_DEPTH) begin
            fifoif.wr_ack <= 0;    // Acknowledge that write wasn't successful
            fifoif.overflow <= 1; // Set fifoif.overflow if trying to write when fifoif.full
        end else begin
            fifoif.wr_ack <= 0;
            fifoif.overflow <= 0;
        end
    end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		rd_ptr <= 0;
        fifoif.underflow <= 0;
	end
	else if (fifoif.rd_en && count != 0) begin  
		fifoif.data_out <= mem[rd_ptr]; 
		rd_ptr <= rd_ptr + 1;
	end
    else if (fifoif.rd_en && count == 0) begin
        fifoif.underflow <= 1; // Set fifoif.underflow if trying to read when fifoif.empty
    end
end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifoif.wr_en, fifoif.rd_en} == 2'b10) && count < FIFO_DEPTH) 
			count <= count + 1;
		else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b01) && count != 0)
			count <= count - 1;
            else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && count == FIFO_DEPTH)  //read only
            count <= count - 1;
            else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && count == 0)  //write only
            count <= count + 1;


	end
end

assign fifoif.full = (count == FIFO_DEPTH)? 1 : 0; 
assign fifoif.empty = (count == 0)? 1 : 0;
// assign fifoif.underflow = (fifoif.empty && fifoif.rd_en)? 1 : 0; //Sequential 
assign fifoif.almostfull = (count == FIFO_DEPTH-1)? 1 : 0;  // Trigger when one slot is left
assign fifoif.almostempty = (count == 1)? 1 : 0;
endmodule