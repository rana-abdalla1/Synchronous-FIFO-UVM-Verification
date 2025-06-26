package FIFO_seq_item_pkg;
import uvm_pkg::*;
import shared_pkg::*;   
`include "uvm_macros.svh"

class FIFO_seq_item extends uvm_sequence_item;
`uvm_object_utils(FIFO_seq_item)
bit clk;
parameter FIFO_WIDTH = 16;
rand bit [FIFO_WIDTH-1:0] data_in;
rand bit rst_n, wr_en, rd_en; 
bit [FIFO_WIDTH-1:0] data_out;
bit wr_ack, overflow;
bit full, empty, almostfull, almostempty, underflow;


function new (string name = "FIFO_seq_item");
super.new(name);
endfunction

function string convert2string();
return $sformatf("FIFO_seq_item: %s data_in=%0h, rst_n=%0d, wr_en=%0d, rd_en=%0d, data_out=%0h, wr_ack=%0d, overflow=%0d, full=%0d, empty=%0d, almostfull=%0d, almostempty=%0d, underflow=%0d", super.convert2string(),data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
endfunction

function string convert2string_stimulus();
return $sformatf("FIFO_seq_item: data_in=%0h, rst_n=%0d, wr_en=%0d, rd_en=%0d", data_in, rst_n, wr_en, rd_en);
endfunction

    constraint reset_signal { rst_n dist {0:=10, 1:=90}; }
    constraint wr_signal    { wr_en dist {1:=70, 0:=30}; }
    constraint rd_signal    { rd_en dist {1:=30, 0:=70}; }

    // constraint wr_only{ wr_en == 1; rst_n==1; rd_en == 0; }
    // constraint rd_only{ rd_en == 1; rst_n==1; wr_en == 0; }
endclass
endpackage


