// import FIFO_transaction_pkg::*;
// import shared_pkg::*;

// module fifo_tb(fifo_if.TEST fifoif);
// FIFO_transaction_class fifo_trans;
//     initial begin
        
//         fifo_trans = new();
//         test_done = 0;
//         fifoif.rst_n = 0;
//        repeat(2) @(negedge fifoif.clk);
//        fifoif.rst_n = 1;
//        fifo_trans.constraint_mode(0);
//        fifo_trans.wr_only.constraint_mode(1);
       
//        repeat(1000) begin
//         assert(fifo_trans.randomize());
//         fifoif.data_in = fifo_trans.data_in;
//         fifoif.rst_n = fifo_trans.rst_n;
//         fifoif.wr_en = fifo_trans.wr_en;
//         fifoif.rd_en = fifo_trans.rd_en;
//         @(negedge fifoif.clk);
//        end
        
//        fifo_trans.constraint_mode(0);
//        fifo_trans.rd_only.constraint_mode(1);
//        fifo_trans.data_in.rand_mode(0);

//        repeat(500) begin
//         assert(fifo_trans.randomize());
//         fifoif.data_in = fifo_trans.data_in;
//         fifoif.rst_n = fifo_trans.rst_n;
//         fifoif.wr_en = fifo_trans.wr_en;
//         fifoif.rd_en = fifo_trans.rd_en;
//         @(negedge fifoif.clk);
//        end

//        fifo_trans.constraint_mode(1);
//        fifo_trans.rd_only.constraint_mode(0);
//        fifo_trans.wr_only.constraint_mode(0);
//        fifo_trans.data_in.rand_mode(1);

//        repeat(500) begin
//         assert(fifo_trans.randomize());
//         fifoif.data_in = fifo_trans.data_in;
//         fifoif.rst_n = fifo_trans.rst_n;
//         fifoif.wr_en = fifo_trans.wr_en;
//         fifoif.rd_en = fifo_trans.rd_en;
//         @(negedge fifoif.clk);
//        end
// test_done = 1;
        
//     end
//     endmodule
        
