`include "src/library/mux2to1_n.sv"
module dff_n_val#(parameter b=4,[b-1:0]val='1)(data_i,rst_i,clk_i,data_o);
	input logic [b-1:0]data_i;
	input logic	rst_i,clk_i;
	output logic[b-1:0]	data_o;
	logic[b-1:0]	q_i;
	always_ff@(posedge clk_i or negedge rst_i) begin
		if(!rst_i) data_o<=data_o;
		else data_o<=q_i;
	end
 mux2to1_n#(b) Q_i(val,data_i,rst_i,q_i);
endmodule:dff_n_val
