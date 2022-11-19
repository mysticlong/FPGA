`include "src/library/peasant_multi_nxn.sv"
`include "src/library/division_n_digit.sv"
module sqrt_16bit#(parameter n=16) (data0_i,data1_i,rst_i,clk_i,fl_o,yint_o,ydec_o,x,y_d,x_o,rst_sqrt);
input logic[n-1:0] data0_i,data1_i;
input logic rst_i,clk_i;
output logic [2*n:0] yint_o,x;
output logic [n-1:0] ydec_o;
output logic fl_o,rst_sqrt;
//logic [2*n:0] x;
output logic [3*n:0] x_o,y_d;
logic [2*n-1:0] y_mul0,y_mul1;
logic fl_mul0,fl_mul1,fl_mul,fl_main,fl_d;
logic rst_mul0,rst_mul1,rst_mul,rst_d;
//fl_main
	assign fl_main=(y_d[2*n+1:16]==x_o[2*n+1:16])?1:0;
	dff_n_data#(1,0) Fl_o(fl_main,rst_i,clk_i,fl_o);	//flag out

//x^2+y^2=x
	peasant_multi_nxn#(n) Y_mul0(data0_i,data0_i,rst_i,clk_i,rst_mul0,fl_mul0,y_mul0);
	peasant_multi_nxn#(n) Y_mul1(data1_i,data1_i,rst_i,clk_i,rst_mul1,fl_mul1,y_mul1);
	//fl_mul
	assign fl_mul=fl_mul0&fl_mul1;
	//rst_mul
	mux2to1_n#(1) Rst_mul(1,rst_mul1&rst_mul0,fl_mul,rst_mul);
	//x
	DffSync_n_data#(2*n+1,0) X(({1'b0,y_mul0}+{1'b0,y_mul1}),x,fl_mul,rst_i,clk_i,x);//33 bit 
//sqrt
	//rst_divison
	 DffSync_n#(1) Rst_sqrt(rst_mul,rst_d,fl_d,clk_i,rst_sqrt);
	//division
	division_n_digit#(2*n+1,n) Y_d(x,x_o,rst_sqrt,clk_i,rst_d,fl_d,y_d);//y_d 49bit
	//add
	DffSync_n_data#(3*n+1,100000) X_o(x_o,(x_o+y_d)>>1,fl_mul,rst_i,rst_d,x_o);//x_o 49bit
	//yint_o ydec_o
	assign yint_o=x_o[3*n:16],ydec_o=x_o[15:0];
endmodule :sqrt_16bit
