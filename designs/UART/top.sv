module top#(parameter n=8,address=4,m=16)(Rx_i,ena_wr_i,wr_i,clk_wr_i,clk_rd_i,clk_i,Tx_o,rd_o,round,fl_full_b,clk_Sync);
input logic Rx_i,ena_wr_i,clk_i,clk_rd_i,clk_wr_i;
input logic[n-1:0] wr_i;
output logic Tx_o,clk_Sync;
output logic [n-1:0] rd_o[0:m-1];
output logic fl_full_b;
output logic  round;
uart#(n,address,m) dut(Rx_i,ena_wr_i,wr_i,clk_wr_i,clk_rd_i,clk_i,Tx_o,rd_o,round,fl_full_b,clk_Sync);
 endmodule:top
/*/


module top#(parameter n=8,address=3,m=8) (wr_i,ena_wr,clk_wr,ena_rd,clk_rd,rst_i,clk_i,data_o,fl_end,fl_full,clk_Sync);
input logic[n-1:0] wr_i;
input logic rst_i,clk_i,ena_wr,ena_rd;
input logic clk_wr,clk_rd;
output logic fl_end,fl_full;
output logic[n-1:0]  data_o[0:m-1];
output	logic clk_Sync;
 AsynFIFO_n_m#(n,address,m) dut(wr_i,ena_wr,clk_wr,ena_rd,clk_rd,rst_i,clk_i,data_o,fl_end,fl_full,clk_Sync);
endmodule:top
//*/
