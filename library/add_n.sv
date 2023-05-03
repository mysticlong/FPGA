/*`include "src/library/FA_1bit.sv"
//`include "src/library/dff_n.sv"*/
module add_n#(parameter n=8)(data0_i,data1_i,clk_i,sum_o,over_o);
input logic [n-1:0] data0_i,data1_i;
input logic clk_i;
output logic over_o;
output logic [n-1:0] sum_o;
logic [n-1:0] c_o,c_in;
	assign	c_in[n-1:1]=c_o[n-2:0];
	assign  over_o=c_o[n-1];
	dff_n#(1) C_in(1'b0,clk_i,c_in[0]);
	// tinh tong
 	genvar i;
 	generate //8 bo cong
 	for (i=0;i<n;i++) begin: ADD
	FA_1bit S_o(data0_i[i],data1_i[i],c_in[i],sum_o[i],c_o[i]); 
	end
	endgenerate
endmodule :add_n
