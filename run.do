vlib work
vlog -f final_src1.txt
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave -position insertpoint  \
sim:/top/fifoif/almostempty \
sim:/top/fifoif/almostfull \
sim:/top/fifoif/clk \
sim:/top/fifoif/data_in \
sim:/top/fifoif/data_out \
sim:/top/fifoif/empty \
sim:/top/fifoif/fifo_count \
sim:/top/fifoif/FIFO_WIDTH \
sim:/top/fifoif/full \
sim:/top/fifoif/overflow \
sim:/top/fifoif/rd_en \
sim:/top/fifoif/rst_n \
sim:/top/fifoif/underflow \
sim:/top/fifoif/wr_ack \
sim:/top/fifoif/wr_en
add wave /uvm_pkg::uvm_reg_map::do_write/#ublk#215181159#1731/immed__1735 /uvm_pkg::uvm_reg_map::do_read/#ublk#215181159#1771/immed__1775 /sequence_fifo_pkg::write_only_sequence::body/#ublk#67443815#35/immed__41 /sequence_fifo_pkg::read_only_sequence::body/#ublk#67443815#55/immed__61 /sequence_fifo_pkg::read_write_sequence::body/#ublk#67443815#75/immed__81 /top/DUTf/sva1/EMPTY_assertion /top/DUTf/sva1/ALMOSTEMPTY_assertion /top/DUTf/sva1/ALMOSTFULL_assertion /top/DUTf/sva1/FULL_assertion /top/DUTf/sva1/OVERFLOW_assertion /top/DUTf/sva1/UNDERFLOW_assertion /top/DUTf/sva1/WR_ACK_HIGH_assertion /top/DUTf/sva1/WR_ACK_LOW_assertion /top/DUTf/sva1/COUNTER_0_assertion /top/DUTf/sva1/COUNTER_INC_10_assertion /top/DUTf/sva1/COUNTER_INC_01_assertion /top/DUTf/sva1/COUNTER_INC_11_WR_assertion /top/DUTf/sva1/COUNTER_INC_11_RD_assertion /top/DUTf/sva1/COUNTER_LAT_assertion /top/DUTf/sva1/PTR_RST_assertion /top/DUTf/sva1/RD_PTR_assertion /top/DUTf/sva1/WR_PTR_assertion
run -all 