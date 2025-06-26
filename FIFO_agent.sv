package FIFO_agent_pkg;
import uvm_pkg::*;
import FIFO_config_pkg::*;
import sequencer_fifo_pkg::*; 
import FIFO_Monitor_pkg::*;
import FIFO_driver_pkg::*;
import FIFO_seq_item_pkg::*;
`include "uvm_macros.svh"

class FIFO_agent extends uvm_agent;
`uvm_component_utils(FIFO_agent)
  fifo_sequencer seqr;
  fifo_driver drv;
  FIFO_Monitor mon;
  fifo_config fifo_cfg;
  uvm_analysis_port #(FIFO_seq_item) agt_ap;

    function new(string name = "FIFO_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(fifo_config)::get(this, "", "fifo_cfg", fifo_cfg)) begin  //set fl test
            `uvm_fatal("build_phase", "Driver unable to get config")
            end
        seqr = fifo_sequencer::type_id::create("seqr", this);
        drv = fifo_driver::type_id::create("drv", this);
        mon = FIFO_Monitor::type_id::create("mon", this);
        agt_ap = new("agt_ap", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.fifo_vif = fifo_cfg.fifo_vif;
        mon.fifo_vif = fifo_cfg.fifo_vif;
        drv.seq_item_port.connect(seqr.seq_item_export);
        mon.mon_ap.connect(agt_ap);
    endfunction
endclass
endpackage

