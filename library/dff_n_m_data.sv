`include "src/library/dff_n_data.sv"
module dff_n_m_data#(parameter n=4,m=16,value=0)(In_i,rst_i,clk_i,In_o);
	input logic [n-1:0] In_i[0:m-1];
	input logic	rst_i,clk_i;
	output logic [n-1:0] In_o[0:m-1];
 	genvar i;
 	generate 
 	for (i=0;i<m;i++) begin
	dff_n_data#(n,value) M(In_i[i],rst_i,clk_i,In_o[i]); 
	end
	endgenerate
endmodule:dff_n_m_data
