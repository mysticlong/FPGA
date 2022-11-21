module dff_n_data#(parameter b=4,[b-1:0]val='0)(data_i,rst_i,clk_i,data_o);
	input logic [b-1:0]data_i;
	input logic	rst_i,clk_i;
	output logic[b-1:0]	data_o;
	always_ff@(posedge clk_i or negedge rst_i) begin
		if(!rst_i) data_o<=val;
		else data_o<=data_i;
	end
endmodule:dff_n_data
