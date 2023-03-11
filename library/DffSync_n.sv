module DffSync_n#(parameter n=4)(data0_i,data1_i,rst_i,clk_i,data_o);
input logic [n-1:0] data0_i,data1_i;
input logic rst_i,clk_i;
output logic [n-1:0]data_o;
 	always_ff@(posedge clk_i or negedge rst_i) begin
		if(!rst_i) data_o<=data0_i;
		else data_o<=data1_i;
	end
endmodule:DffSync_n
