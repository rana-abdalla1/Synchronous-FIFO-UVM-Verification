package FIFO_transaction_pkg;
  class FIFO_transaction_class;
    rand logic [15:0] data_in;
    rand logic rst_n, wr_en, rd_en;
    logic [15:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;
    int RD_EN_ON_DIST, WR_EN_ON_DIST;
    // Constructor
    function new(int RD_EN_ON_dist = 30, int WR_EN_ON_dist = 70);
      RD_EN_ON_DIST = RD_EN_ON_dist;
      WR_EN_ON_DIST = WR_EN_ON_dist;
    endfunction
    // Constraints
    
  endclass
endpackage
 