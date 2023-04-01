module top#(parameter n=8) (data0_i,data1_i,rst_i,clk_i,fl_o,y_o);
input logic [n:0] data0_i,data1_i;
input logic rst_i,clk_i;
output logic [2*n+1:0]y_o;
output logic fl_o;
 BoothAlgorithm_n#(n)  dut(data0_i,data1_i,rst_i,clk_i,fl_o,y_o);
 endmodule:top
