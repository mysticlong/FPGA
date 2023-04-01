module top#(parameter n=32,address=4,m=16) (wr_i,clk_wr,rst_i,clk_i,rd_o,Full_nEmpty_o,data_o);
input logic[n-1:0] wr_i;
input logic rst_i,clk_i,clk_wr;
output logic Full_nEmpty_o;
output logic[n-1:0] rd_o,data_o[0:m-1];


AsynFIFO_n_m#(n,address,m) dut(wr_i,clk_wr,rst_i,clk_i,rd_o,Full_nEmpty_o,data_o);
 endmodule:top
