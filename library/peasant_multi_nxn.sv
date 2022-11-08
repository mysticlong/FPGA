`include "src/library/mux2to1_n.sv"
`include "src/library/dff_n.sv"
`include "src/library/dff_n_data.sv"
module peasant_multi_nxn#(parameter n=16) (data0_i,data1_i,rst_i,clk_i,fl_o,y_o);
input logic [n-1:0] data0_i,data1_i;
input logic rst_i,clk_i;
output logic [2*n-1:0]y_o;
output logic fl_o;
logic fl_main,clk_o;
logic [2*n-1:0] a0,a1,b0,b1,x,a,b;
assign x=a0[0]?b0:0,a={16'b0,data0_i},b={16'b0,data1_i};
assign fl_main=(a0==0)?1:0;
//dong bo xung clock
	mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
//flag out
	dff_n_data#(1,0) Fl_o(fl_main,rst_i,clk_i,fl_o);
// dong bo ngo vao
	mux2to1_n#(2*n) A0(a,a1>>1,rst_i,a0);		//a_o dich trai
	dff_n#(2*n) A_o(a0,rst_i,clk_o,a1);
	mux2to1_n#(2*n) B0(b,b1<<1,rst_i,b0);		//b_o dich phai
	dff_n#(2*n) B_o(b0,rst_i,clk_o,b1);
//ngo ra
    dff_n_data#(2*n,0) Y_o(y_o+x,rst_i,clk_o&~fl_o,y_o);
endmodule :peasant_multi_nxn
