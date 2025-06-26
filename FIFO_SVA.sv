module SVA(fifo_if.DUT fifoif);
	parameter FIFO_DEPTH = 8;
	// Assertions for Combinational Outputs
	always_comb begin
		if (FIFO.count == 0) begin
			EMPTY_assertion : assert (fifoif.empty && !fifoif.full && !fifoif.almostempty && !fifoif.almostfull) else $display("EMPTY_assertion fail");
			EMPTY_cover     : cover  (fifoif.empty && !fifoif.full && !fifoif.almostempty && !fifoif.almostfull)     ;
		end
		if (FIFO.count == 1) begin
			ALMOSTEMPTY_assertion : assert (!fifoif.empty && !fifoif.full && fifoif.almostempty && !fifoif.almostfull) else $display("ALMOSTFULL_assertion fail");
			ALMOSTEMPTY_cover     : cover  (!fifoif.empty && !fifoif.full && fifoif.almostempty && !fifoif.almostfull) ;     
		end
		if (FIFO.count == FIFO_DEPTH-1) begin
			ALMOSTFULL_assertion : assert (!fifoif.empty && !fifoif.full && !fifoif.almostempty && fifoif.almostfull) else $display("ALMOSTFULL_assertion fail");
			ALMOSTFULL_cover     : cover  (!fifoif.empty && !fifoif.full && !fifoif.almostempty && fifoif.almostfull)   ;   
		end
		if (FIFO.count == FIFO_DEPTH) begin
			FULL_assertion : assert (!fifoif.empty && fifoif.full && !fifoif.almostempty && !fifoif.almostfull) else $display("FULL_assertion fail");
			FULL_cover     : cover  (!fifoif.empty && fifoif.full && !fifoif.almostempty && !fifoif.almostfull);
		end 
	end

	// Assertions for Overflow and Underflow
	property OVERFLOW_FIFO;
		@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (fifoif.full & fifoif.wr_en) |=> (fifoif.overflow);
	endproperty

	property UNDERFLOW_FIFO;
		@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (fifoif.empty && fifoif.rd_en) |=> (fifoif.underflow);
	endproperty

	// Assertions for fifoif.wr_ack
	property WR_ACK_HIGH;
		@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (fifoif.wr_en && (FIFO.count < FIFO_DEPTH) && !fifoif.full) |=> (fifoif.wr_ack);
	endproperty

	property WR_ACK_LOW;
		@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (fifoif.wr_en && fifoif.full) |=> (!fifoif.wr_ack);
	endproperty

	// Assertions for The Counter
	property COUNT_0;
		@(posedge fifoif.clk) (!fifoif.rst_n) |=> (FIFO.count == 0);
	endproperty

	property COUNT_INC_10;
		@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (({fifoif.wr_en, fifoif.rd_en} == 2'b10) && !fifoif.full) |=> (FIFO.count == $past(FIFO.count) + 1);
	endproperty

	property COUNT_INC_01;
		@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (({fifoif.wr_en, fifoif.rd_en} == 2'b01) && !fifoif.empty) |=> (FIFO.count == $past(FIFO.count) - 1);
	endproperty

	property COUNT_INC_11_WR;
		@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.empty) |=> (FIFO.count == $past(FIFO.count) + 1);
	endproperty

	property COUNT_INC_11_RD;
		@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.full) |=> (FIFO.count == $past(FIFO.count) - 1);
	endproperty

	property COUNT_LAT;
		@(posedge fifoif.clk) disable iff (!fifoif.rst_n) ((({fifoif.wr_en, fifoif.rd_en} == 2'b01) && fifoif.empty) || (({fifoif.wr_en, fifoif.rd_en} == 2'b10) && fifoif.full)) |=> (FIFO.count == $past(FIFO.count));
	endproperty

	// Assertions for Pointers
	property PTR_RST;
		@(posedge fifoif.clk) (!fifoif.rst_n) |=> (~FIFO.rd_ptr && ~FIFO.wr_ptr);
	endproperty

	property RD_PTR;
		@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (fifoif.rd_en && (FIFO.count != 0)) |=> (FIFO.rd_ptr == ($past(FIFO.rd_ptr) + 1) % FIFO_DEPTH);
	endproperty

	property WR_PTR;
		@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (fifoif.wr_en && (FIFO.count < FIFO_DEPTH)) |=> (FIFO.wr_ptr == ($past(FIFO.wr_ptr) + 1) % FIFO_DEPTH);
	endproperty

	// Assert Properties
	OVERFLOW_assertion          : assert property (OVERFLOW_FIFO)    else $display("OVERFLOW_assertion");
	UNDERFLOW_assertion         : assert property (UNDERFLOW_FIFO)   else $display("UNDERFLOW_assertion");
	WR_ACK_HIGH_assertion       : assert property (WR_ACK_HIGH)      else $display("WR_ACK_HIGH_assertion");
	WR_ACK_LOW_assertion        : assert property (WR_ACK_LOW)       else $display("WR_ACK_LOW_assertion");
	COUNTER_0_assertion         : assert property (COUNT_0)          else $display("COUNTER_0_assertion");
	COUNTER_INC_10_assertion    : assert property (COUNT_INC_10)     else $display("COUNTER_INC_WR_assertion fail");
	COUNTER_INC_01_assertion    : assert property (COUNT_INC_01)     else $display("COUNTER_INC_WR_assertion fail");
	COUNTER_INC_11_WR_assertion : assert property (COUNT_INC_11_WR)  else $display("COUNTER_INC_WR_assertion fail");
	COUNTER_INC_11_RD_assertion : assert property (COUNT_INC_11_RD)  else $display("COUNTER_INC_WR_assertion fail");
	COUNTER_LAT_assertion       : assert property (COUNT_LAT)        else $display("COUNTER_LAT_assertion fail");
	PTR_RST_assertion           : assert property (PTR_RST)          else $display("PTR_RST_asssertion fail");
	RD_PTR_assertion            : assert property (RD_PTR)           else $display("RD_PTR_asssertion fail");
	WR_PTR_assertion            : assert property (WR_PTR)           else $display("WR_PTR_asssertion fail");

	// Cover Properties
	OVERFLOW_cover          : cover property (OVERFLOW_FIFO);
	UNDERFLOW_cover         : cover property (UNDERFLOW_FIFO);
	WR_ACK_HIGH_cover       : cover property (WR_ACK_HIGH);
	WR_ACK_LOW_cover        : cover property (WR_ACK_LOW);
	COUNTER_0_cover         : cover property (COUNT_0);
	COUNTER_INC_10_cover    : cover property (COUNT_INC_10);
	COUNTER_INC_01_cover    : cover property (COUNT_INC_01);
	COUNTER_INC_11_WR_cover : cover property (COUNT_INC_11_WR);
	COUNTER_INC_11_RD_cover : cover property (COUNT_INC_11_RD);
	COUNTER_LAT_cover       : cover property (COUNT_LAT);
	PTR_RST_cover           : cover property (PTR_RST);
	RD_PTR_cover            : cover property (RD_PTR);
	WR_PTR_cover            : cover property (WR_PTR);

endmodule