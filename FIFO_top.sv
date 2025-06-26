import uvm_pkg::*;
import FIFO_env_pkg::*;
import FIFO_test_pkg::*;
`include "uvm_macros.svh"

module top();
bit clk;
//clock generation
  initial begin
    clk = 0;
    forever 
      #1 clk = ~clk;
  end

fifo_if fifoif(clk);
FIFO DUTf(fifoif);
bind FIFO SVA sva1(fifoif);

initial begin
    uvm_config_db #(virtual fifo_if)::set(null,"uvm_test_top","FIFO_if",fifoif);
    run_test("FIFO_test");
end



endmodule
