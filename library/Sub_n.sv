//`include "src/library/FA_1bit.sv"
//`include "src/library/dff_n.sv"

module Sub_n#(parameter n=8)(sign_i,data0_i,data1_i,clk_i,data_o,over_o);
input logic [n-1:0] data0_i,data1_i;
input logic clk_i,sign_i;
output logic [n-1:0] data_o;
output logic over_o;
//.........................//............................//
logic [n:0] c_o,c_in,data1_o,data0_o,data;
	assign data_o=data[n-1:0];
	assign over_o=data[n];
	assign data1_o=(!sign_i)?~{1'b0,data1_i}:~{data1_i[n-1],data1_i};
	assign data0_o=(!sign_i)? {1'b0,data0_i}:{data0_i[n-1],data0_i};
	assign	c_in[n:1]=c_o[n-1:0];
	dff_n#(1) C_in(1|c_o[n],clk_i,c_in[0]);
	// tinh tong
 	genvar i;
 	generate //8 bo cong
 	for (i=0;i<=n;i++) begin
	FA_1bit S_o(data0_o[i],data1_o[i],c_in[i],data[i],c_o[i]); 
	end
	endgenerate
endmodule :Sub_n
