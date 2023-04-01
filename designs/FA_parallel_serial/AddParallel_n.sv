`include "src/library/DffSync_n.sv"
`include "src/library/FA_1bit.sv"
`include "src/library/dff_n_data.sv"
module AddParallel_n#(parameter n=8)(data0_i,data1_i,rst_i,clk_i,fl_o,sum_o,A,B);
input logic [n-1:0] data0_i,data1_i;
input logic rst_i,clk_i;
output logic fl_o;
output logic [n:0] sum_o;
output logic [n:0] A,B;
logic [n:0] c_o,c_in;
logic fl_main;
//fl_o
 	assign fl_main=(c_o==0)?1:0;
 	dff_n_data#(1,0) Fl_o(fl_main,rst_i,clk_i,fl_o);
//dong bo ngo vao
	DffSync_n#(n+1) Sum_o({1'b0,data0_i},sum_o,rst_i,clk_i,A);
	DffSync_n#(n+1) Data1({1'b0,data1_i},c_o<<1,rst_i,clk_i,B);
// tinh tong
	assign c_in=0;
 	genvar i;
 	generate //9 bo cong
 	for (i=0;i<n+1;i++) begin
	FA_1bit S_o(A[i],B[i],c_in[i],sum_o[i],c_o[i]); 
	end
	endgenerate
endmodule :AddParallel_n
