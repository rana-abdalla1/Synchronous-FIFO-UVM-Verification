package FIFO_Monitor_pkg;
import uvm_pkg::*;
import FIFO_seq_item_pkg:: *;
import shared_pkg::*;
`include "uvm_macros.svh"

class FIFO_Monitor extends uvm_monitor;
`uvm_component_utils(FIFO_Monitor) 
    virtual fifo_if fifo_vif;
    FIFO_seq_item rsp_seq_item;
    uvm_analysis_port #(FIFO_seq_item) mon_ap;

    function new(string name = "FIFO_Monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            rsp_seq_item = FIFO_seq_item::type_id::create("rsp_seq_item");
           
            @(negedge fifo_vif.clk);
            rsp_seq_item.data_in = fifo_vif.data_in;
            rsp_seq_item.rst_n = fifo_vif.rst_n;
            rsp_seq_item.wr_en = fifo_vif.wr_en;
            rsp_seq_item.rd_en = fifo_vif.rd_en;
            rsp_seq_item.data_out = fifo_vif.data_out;
            rsp_seq_item.wr_ack = fifo_vif.wr_ack;
            rsp_seq_item.overflow = fifo_vif.overflow;
            rsp_seq_item.full = fifo_vif.full;
            rsp_seq_item.empty = fifo_vif.empty;
            rsp_seq_item.almostfull = fifo_vif.almostfull;
            rsp_seq_item.almostempty = fifo_vif.almostempty;
            rsp_seq_item.underflow = fifo_vif.underflow;
            
            mon_ap.write(rsp_seq_item);
            `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH)
        end
    endtask
endclass
endpackage