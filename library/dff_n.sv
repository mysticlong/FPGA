module dff_n#(parameter b=4)(d_i,clk_i,q_o);
	input logic [b-1:0]d_i;
	input logic	clk_i;
	output logic[b-1:0]	q_o;
	always_ff@(posedge clk_i ) begin
		 	q_o<=d_i;
	end
endmodule:dff_n
