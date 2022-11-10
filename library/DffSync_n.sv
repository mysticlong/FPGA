`include "src/library/dff_n.sv"
`include "src/library/mux2to1_n.sv"
module DffSync_n#(parameter n=4)(data0_i,data1_i,rst_i,clk_i,y_o);
input logic [n-1:0] data0_i,data1_i;
input logic rst_i,clk_i;
output logic [n-1:0]y_o;
 logic [n-1:0]y;
   	mux2to1_n#(n) Y_o(data0_i,data1_i,rst_i,y);//setup
    dff_n#(n) B_o(y,clk_i,y_o); 
endmodule:DffSync_n
