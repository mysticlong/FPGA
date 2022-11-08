module dff_n#(parameter b=4)(d_i,rst_i,clk_i,q_o);
	input logic [b-1:0]d_i;
	input logic	clk_i,rst_i;
	output logic[b-1:0]	q_o;
	always_ff@(posedge clk_i or negedge rst_i) begin
		 if(!rst_i)
		 	q_o<=q_o;
		 else 
		 	q_o<=d_i;
	end
endmodule:dff_n
