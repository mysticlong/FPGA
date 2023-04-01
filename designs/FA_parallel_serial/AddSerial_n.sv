`include "src/library/DffSync_n_val.sv"
`include "src/library/DffSync_n.sv"
`include "src/library/FA_1bit.sv"
`include "src/library/dff_n_data.sv"
module AddSerial_n#(parameter n=8)(data0_i,data1_i,rst_i,clk_i,fl_o,sum_o);
input logic [n-1:0] data0_i,data1_i;
input logic rst_i,clk_i;
output logic fl_o;
output logic [n:0] sum_o;
logic [n:0] D0,D1,Q1;
logic s_o,c_o,c_in,fl_main;
logic [3:0]i;
//fl_o
 	assign fl_main=(i>=n+1)?1:0;
 	dff_n_data#(1,0) Fl_o(fl_main,rst_i,clk_i,fl_o);
//minimum clk
	DffSync_n_val#(4,0) I(i,i+1,rst_i,rst_i,clk_i&~fl_o,i);
//dong bo ngo vao
	DffSync_n#(n+1) Sum_o({1'b0,data0_i},D0,rst_i,clk_i&~fl_o,sum_o);
	DffSync_n#(n+1) Data1({1'b0,data1_i},D1,rst_i,clk_i&~fl_o,Q1);
// tinh tong
	assign D0[n-1:0]=sum_o[n:1],D0[n]=s_o;
	assign D1[n-1:0]=Q1[n:1],D1[n]=0;
	FA_1bit S_o(sum_o[0],Q1[0],c_in,s_o,c_o);
	DffSync_n_data#(1,0) C_in(0,c_o,rst_i,rst_i,clk_i,c_in); 
endmodule :AddSerial_n
