//`include "src/library/dff_n_data.sv"
module DffSync_n_data#(parameter n=4,val='0)(data0_i,data1_i,condition_i,rst_i,clk_i,y_o);
input logic [n-1:0] data0_i,data1_i;
input logic rst_i,clk_i,condition_i;
output logic [n-1:0]y_o;
 logic [n-1:0]y;
   	mux2to1_n#(n) Y_o(data0_i,data1_i,condition_i,y);
    dff_n_data#(n,val) B_o(y,rst_i,clk_i,y_o); 
endmodule:DffSync_n_data
