`include "src/library/mux2to1_nbit_m.sv"
module dff_n_m_val#(parameter n=4,m=16,[n-1:0]val='0)(In_i,rst_i,clk_i,In_o);
	input logic [n-1:0] In_i[0:m-1];
	input logic	rst_i,clk_i;
	output logic [n-1:0] In_o[0:m-1];
	 logic[n-1:0] In_io[0:m-1],Val[0:m-1];
	 initial begin
	 for(int i=0;i<m;i++)  Val[i]=val;
	 end
	always_ff@(posedge clk_i or negedge rst_i) begin
	if(!rst_i) 
		In_io <= In_io;
	else
		In_io <= In_i;
	end
	mux2to1_nbit_m#(n,m) in_o(Val,In_io,rst_i,In_o);
endmodule:dff_n_m_val
