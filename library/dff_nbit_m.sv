module dff_nbit_m#(parameter b=4,m=16)(D_i,rst_i,clk_i,Q_o);
	input logic [b-1:0] D_i[0:m-1];
	input logic	rst_i,clk_i;
	output logic[b-1:0]	Q_o[0:m-1];
	always_ff@(posedge clk_i or negedge rst_i) begin
	if(!rst_i) 
		Q_o<=Q_o;
	else
		Q_o<=D_i;
	end
endmodule:dff_nbit_m
