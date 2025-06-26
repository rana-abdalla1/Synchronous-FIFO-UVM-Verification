package sequencer_fifo_pkg;
import uvm_pkg::*;
import FIFO_seq_item_pkg::*;
`include "uvm_macros.svh"
class fifo_sequencer extends uvm_sequencer #(FIFO_seq_item);
`uvm_component_utils(fifo_sequencer)
  function new(string name = "fifo_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  endclass
endpackage
 