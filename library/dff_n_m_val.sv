//`include "src/library/mux2to1_n_m.sv"
module dff_n_m_val#(parameter n=4,m=15,value=0)(In_i,rst_i,clk_i,In_o);
	input logic [n-1:0] In_i[0:m];
	input logic	rst_i,clk_i;
	output logic [n-1:0] In_o[0:m];
	 logic[n-1:0] In_io[0:m],Val[0:m];
	 int i=0;
	 initial begin
	 for(i=0;i<=m;i++)  Val[i]=value;
	 end
	always_ff@(posedge clk_i or negedge rst_i) begin
	if(!rst_i) 
		In_o <= Val;
	else
		In_o <= In_io;
	end
	mux2to1_n_m#(n,m) in_o(In_o,In_i,rst_i,In_io);
endmodule:dff_n_m_val
