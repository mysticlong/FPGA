module top#(parameter n=16,digit=32) (data0_i,data1_i,rst_i,clk_i,fl_o,yint_o,ydec_o,x,y_d,x_o,rst_sqrt);
input logic[n-1:0] data0_i,data1_i;
input logic rst_i,clk_i;
output logic [2*n:0] yint_o;
output logic [2*n:0] x;
output logic [digit-1:0] ydec_o;
output logic fl_o,rst_sqrt;
output logic [2*n+digit:0] x_o,y_d;
 sqrt_16bit#(n,digit)  dut(data0_i,data1_i,rst_i,clk_i,fl_o,yint_o,ydec_o,x,y_d,x_o,rst_sqrt);
endmodule:top
