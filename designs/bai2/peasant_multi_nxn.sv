`include "src/library/dff_n_data.sv"
module peasant_multi_nxn#(parameter n=16) (data0_i,data1_i,rst_i,clk_i,rst_o,fl_o,y_o);
input logic [n-1:0] data0_i,data1_i;
input logic rst_i,clk_i;
output logic [2*n-1:0]y_o;
output logic fl_o,rst_o;
logic fl_main,clk_o,rst;
logic [2*n-1:0] b0,b1,x,b;	
logic [n-1:0] a0,a1;
assign x=a0[0]?b0:0,b[n-1:0]=data1_i,b[2*n-1:n]=0; 
assign fl_main=(a0==0)?1:0;
//dong bo xung clock
	mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
//flag out
	dff_n_data#(1,0) Fl_o(fl_main,rst_i,clk_i,fl_o);
//rst out
	dff_n#(1) Rst(fl_o,clk_i,rst);assign rst_o=rst|~fl_o;
// dong bo ngo vao
	mux2to1_n#(n) A0(data0_i,a1>>1,rst_i,a0);		//a_o dich trai
	dff_n#(n) A_o(a0,clk_o,a1);
	mux2to1_n#(2*n) B0(b,b1<<1,rst_i,b0);		//b_o dich phai
	dff_n#(2*n) B_o(b0,clk_o,b1);
//ngo ra
    dff_n_data#(2*n,0) Y_o(y_o+x,rst_i,clk_o&~fl_o,y_o);
endmodule :peasant_multi_nxn
