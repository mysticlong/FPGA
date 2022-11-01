module dff_n_val#(parameter b=4,[b-1:0]n='1)(d_i,rst_i,clk_i,q_o);
	input logic [b-1:0]d_i;
	input logic	rst_i,clk_i;
	output logic[b-1:0]	q_o;
	always_ff@(posedge clk_i or negedge rst_i) begin
		if(!rst_i) q_o<=n;
		else q_o<=d_i;
	end
endmodule:dff_n_val
