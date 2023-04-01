`include "src/library/DffSync_n_data.sv"
module DffSync_n_val#(parameter n=5,[n-1:0]val=31)(data0_i,data1_i,condition_i,rst_i,clk_i,y_o);
input logic [n-1:0] data0_i,data1_i;
input logic condition_i,rst_i,clk_i;
output logic [n-1:0] y_o;
logic [n-1:0] data_o;
	mux2to1_n#(n) I_o(data0_i,data1_i,condition_i,data_o);
	DffSync_n_data#(n,val) I(y_o,data_o,rst_i,rst_i,clk_i,y_o);

endmodule :DffSync_n_val
