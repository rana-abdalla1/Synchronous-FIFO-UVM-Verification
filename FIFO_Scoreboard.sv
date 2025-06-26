package FIFO_Scoreboard_pkg;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_Scoreboard extends uvm_scoreboard;
`uvm_component_utils(FIFO_Scoreboard)
uvm_analysis_export #(FIFO_seq_item) sb_export;
uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;

    FIFO_seq_item seq_item_sb; 

    bit [15:0] mem_queue [$];
    bit [15:0] data_out_ref;
    bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref,wr_ack_ref,overflow_ref;
    
    int error_count = 0;
    int correct_count = 0;

    function new(string name = "FIFO_Scoreboard", uvm_component parent = null);
        super.new(name, parent);
        endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export", this);
        sb_fifo = new("sb_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
      
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(seq_item_sb);
            reference_model(seq_item_sb);   

            if(seq_item_sb.data_out != data_out_ref) begin
                `uvm_error("run_phase", $sformatf("Comparison Fail: DUT: %s while  Data_out_ref: %0d", seq_item_sb.convert2string(), data_out_ref));
                error_count++;
            end
            else begin
                `uvm_info("run_phase", $sformatf("Comparison Pass: DUT: %s ", seq_item_sb.convert2string()), UVM_HIGH);
                correct_count++;
            end
        end
    endtask

    task reference_model(FIFO_seq_item F_txn);
        if (F_txn.rst_n == 0) begin
            // data_out_ref = 16'b0;
            full_ref = 0;
            empty_ref = 1;
            almostfull_ref = 0;
            almostempty_ref = 0;
            underflow_ref = 0;
            wr_ack_ref = 0;
            overflow_ref = 0;
            mem_queue.delete();
        end
        else begin
            // *****************Write and Read*****************************
            if ({F_txn.rd_en , F_txn.wr_en} == 2'b11)begin
                if ($size(mem_queue) == 0)begin //empty
                    mem_queue.push_back(F_txn.data_in);
                    wr_ack_ref = 1 ;
                    overflow_ref = 0;
                    underflow_ref = 1;
                end
                else if ($size(mem_queue) == 8) begin //full
                    data_out_ref = mem_queue.pop_front();
                    underflow_ref = 0;
                    overflow_ref = 1;
                    wr_ack_ref = 0 ;
                end
                else begin
                    mem_queue.push_back(F_txn.data_in);
                    data_out_ref = mem_queue.pop_front();
                    wr_ack_ref = 1 ;
                    overflow_ref = 0;
                    underflow_ref = 0;
                end
            end
            else begin
                {overflow_ref , wr_ack_ref , underflow_ref } = 3'b0 ;
                 if (F_txn.wr_en) begin
            // *****************Write only*****************************
                    if ($size(mem_queue) < 8) begin
                        mem_queue.push_back(F_txn.data_in);
                        wr_ack_ref = 1 ;
                        overflow_ref = 0;
                    end
                    else begin
                        wr_ack_ref = 0 ;
                        overflow_ref = 1;
                    end
                end
            // *****************Read only*****************************
                else if (F_txn.rd_en)begin
                    if ($size(mem_queue) > 0) begin
                        data_out_ref = mem_queue.pop_front();
                        underflow_ref = 0;
                    end
                    else begin
                        underflow_ref = 1;
                    end
                end

            end
                 
        end

        full_ref = ($size(mem_queue) == 8)? 1 : 0 ;
        empty_ref = ($size(mem_queue) == 0)? 1 : 0 ;
        almostfull_ref = ($size(mem_queue) == 7)? 1 : 0 ;
        almostempty_ref = ($size(mem_queue) == 1)? 1 : 0 ;

    endtask
    // function void print();
    //     $display("data_out_ref =%0d ,wr_ack_ref =%0d , overflow_ref  =%0d , full_ref =%0d , empty_ref =%0d , almostfull_Ref =%0d , almostempty_ref =%0d , underflow_ref =%0d  ",data_out_ref ,wr_ack_ref , overflow_ref ,full_ref  ,empty_ref , almostfull_ref ,almostempty_ref , underflow_ref);
    // endfunction 

    function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase", $sformatf("Total correct:%0d ",correct_count),UVM_MEDIUM);
    `uvm_info("report_phase", $sformatf("Total error:%0d ",error_count),UVM_MEDIUM);
    endfunction

endclass
endpackage

