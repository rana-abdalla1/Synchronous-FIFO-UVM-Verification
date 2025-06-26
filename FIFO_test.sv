package FIFO_test_pkg;
import uvm_pkg::*;
import FIFO_env_pkg::*;
import FIFO_config_pkg::*;
import sequence_fifo_pkg::*;
`include "uvm_macros.svh"

class FIFO_test extends uvm_test;
`uvm_component_utils(FIFO_test)
  FIFO_env env;
  fifo_config fifo_cfg; 
  FIFO_sequence_reset seq_reset;
    write_only_sequence wr_seq;
    read_only_sequence rd_seq;
    read_write_sequence rw_seq;

    function new(string name = "FIFO_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = FIFO_env::type_id::create("env", this);
        fifo_cfg = fifo_config::type_id::create("fifo_cfg", this);
        seq_reset = FIFO_sequence_reset::type_id::create("seq_reset");
        wr_seq = write_only_sequence::type_id::create("wr_seq");
        rd_seq = read_only_sequence::type_id::create("rd_seq");
        rw_seq = read_write_sequence::type_id::create("rw_seq");

        if(!uvm_config_db #(virtual fifo_if)::get(this, "", "FIFO_if", fifo_cfg.fifo_vif))  //set fl top
            `uvm_fatal("build_phase", "Driver unable to get virtual interface");
            uvm_config_db #(fifo_config)::set(this, "*", "fifo_cfg", fifo_cfg);
        
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);

        `uvm_info("run_phase", "Starting FIFO reset sequence", UVM_LOW);
        seq_reset.start(env.agt.seqr);
        `uvm_info("run_phase", "Ending FIFO reset sequence", UVM_LOW);
        `uvm_info("run_phase", "Starting write only sequence", UVM_LOW);
        wr_seq.start(env.agt.seqr);
        `uvm_info("run_phase", "Ending write only sequence", UVM_LOW);
        `uvm_info("run_phase", "Starting read only sequence", UVM_LOW);
        rd_seq.start(env.agt.seqr);
        `uvm_info("run_phase", "Ending read only sequence", UVM_LOW);
        `uvm_info("run_phase", "Starting read write sequence", UVM_LOW);
        rw_seq.start(env.agt.seqr);
        `uvm_info("run_phase", "Ending read write sequence", UVM_LOW);

        phase.drop_objection(this);
    endtask: run_phase
endclass
endpackage

