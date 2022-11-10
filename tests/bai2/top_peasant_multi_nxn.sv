module top#(parameter n=16) (data0_i,data1_i,rst_i,clk_i,fl_o,y_o);
input logic [n-1:0] data0_i,data1_i;
input logic rst_i,clk_i;
output logic [2*n-1:0]y_o;
output logic fl_o;
    peasant_multi_nxn#(n) dut(data0_i,data1_i,rst_i,clk_i,fl_o,y_o);
endmodule:top
