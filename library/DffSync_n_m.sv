`include "src/library/DffSync_n.sv"
module DffSync_n_m#(parameter n=4,m=10)(data0_i,data1_i,rst_i,clk_i,y_o);
input logic [n-1:0] data0_i[0:m-1],data1_i[0:m-1];
input logic rst_i,clk_i;
output logic [n-1:0]y_o[0:m-1];
 	genvar i;
 	generate
 	  for (i=0;i<m;i++) begin
 	    DffSync_n#(n) mul(data0_i[i],data1_i[i],rst_i,clk_i,y_o[i]);
 	    end
 	endgenerate
endmodule:DffSync_n_m
