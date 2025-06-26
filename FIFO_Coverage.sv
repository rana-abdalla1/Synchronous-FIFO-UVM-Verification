package FIFO_Coverage_pkg;
import uvm_pkg::*;
import FIFO_seq_item_pkg::*;
`include "uvm_macros.svh"

class FIFO_Coverage extends uvm_component;
`uvm_component_utils(FIFO_Coverage)
  uvm_analysis_export #(FIFO_seq_item) cov_export;
  uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
  FIFO_seq_item cov_seq_item; 

  covergroup covCode;
  // Cross coverage between wr_en, rd_en and all control signals
      cross cov_seq_item.wr_en, cov_seq_item.rd_en, cov_seq_item.wr_ack;
      cross cov_seq_item.wr_en, cov_seq_item.rd_en, cov_seq_item.overflow;
      cross cov_seq_item.wr_en, cov_seq_item.rd_en, cov_seq_item.full;
      cross cov_seq_item.wr_en, cov_seq_item.rd_en, cov_seq_item.empty;
      cross cov_seq_item.wr_en, cov_seq_item.rd_en, cov_seq_item.almostfull;
      cross cov_seq_item.wr_en, cov_seq_item.rd_en, cov_seq_item.almostempty;
      cross cov_seq_item.wr_en, cov_seq_item.rd_en, cov_seq_item.underflow;
      endgroup

  function new(string name = "FIFO_Coverage", uvm_component parent = null);
    super.new(name, parent);
    covCode = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export", this);
    cov_fifo = new("cov_fifo", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      cov_fifo.get(cov_seq_item);
      covCode.sample();
    end
  endtask
endclass
endpackage
