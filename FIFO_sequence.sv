package sequence_fifo_pkg;
import uvm_pkg::*;
import shared_pkg::*;
import FIFO_seq_item_pkg::*;
`include "uvm_macros.svh"

class FIFO_sequence_reset extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_sequence_reset)
FIFO_seq_item seq_item;
  function new(string name = "FIFO_sequence_reset");
    super.new(name);
  endfunction 

  task body();
    repeat(50) begin
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    start_item(seq_item);
    seq_item.rst_n = 0;
    seq_item.wr_en = 0;
    seq_item.rd_en = 0;
    seq_item.data_in = 16'h0;

    finish_item(seq_item);
    end
    endtask
endclass

class write_only_sequence extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(write_only_sequence)
FIFO_seq_item seq_item;
  function new(string name = "write_only_sequence");
    super.new(name);
    endfunction

    task body();
    repeat(1000) begin
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    start_item(seq_item);
    
    assert(seq_item.randomize());

    seq_item.rst_n = 1;
    seq_item.rd_en = 0;
    seq_item.wr_en = 1;

    finish_item(seq_item);
    end
    endtask
endclass

class read_only_sequence extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(read_only_sequence)
FIFO_seq_item seq_item;
  function new(string name = "read_only_sequence");
    super.new(name);
    endfunction

    task body();
    repeat(500) begin
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    start_item(seq_item);
    
    assert(seq_item.randomize());
    seq_item.rst_n = 1;
    seq_item.rd_en = 1;
    seq_item.wr_en = 0;

    finish_item(seq_item);
    end
    endtask
endclass

class read_write_sequence extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(read_write_sequence)
FIFO_seq_item seq_item;
  function new(string name = "read_write_sequence");
    super.new(name);
    endfunction

    task body();
    repeat(500) begin
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    start_item(seq_item);
    
    assert(seq_item.randomize());
    seq_item.rst_n = 1;
    seq_item.rd_en = 1;
    seq_item.wr_en = 1;

    finish_item(seq_item);
    end
    endtask
endclass

endpackage
