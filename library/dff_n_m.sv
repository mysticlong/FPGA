module dff_n_m#(parameter b=4,m=16)(data_i,rst_i,clk_i,data_o);
	input logic [b-1:0] data_i[0:m-1];
	input logic	rst_i,clk_i;
	output logic[b-1:0]	data_o[0:m-1];
	always_ff@(posedge clk_i or negedge rst_i) begin
	if(!rst_i) 
		data_o<=data_o;
	else
		data_o<=data_i;
	end
endmodule:dff_n_m
