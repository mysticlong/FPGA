`include "src/library/peasant_multi_nxn.sv"
`include "src/library/division_n_digit.sv"
module sqrt_16bit#(parameter n=16) (data0_i,data1_i,rst_i,clk_i,fl_o,yint_o,ydec_o);
input logic[n-1:0] data0_i,data1_i;
input logic rst_i,clk_i;
output logic [2*n:0] yint_o;
output logic [n-1:0] ydec_o;
output logic fl_o;
logic [2*n:0] x;
logic [3*n+1:0] x_o,y_d;
logic [2*n-1:0] y_mul0,y_mul1;
logic fl_mul0,fl_mul1,fl_mul,fl_main,rst_mul0,rst_mul1,rst_mul,rst_d;
//fl_main
	assign fl_main=(y_d[2*n+1:16]==x_o[2*n+1:16])?1:0;
	dff_n_data#(1,0) Fl_o(fl_main,rst_i,clk_i,fl_o);	//flag out
//x^2+y^2=x
	peasant_multi_nxn#(n) Y_mul0(data0_i,data0_i,rst_i,clk_i,rst_mul0,fl_mul0,y_mul0);
	peasant_multi_nxn#(n) Y_mul1(data1_i,data1_i,rst_i,clk_i,rst_mul1,fl_mul1,y_mul1);
	assign fl_mul=fl_mul0&fl_mul1;
    //x
	DffSync_n_data#(2*n+1,0) X({0,y_mul0}+{0,y_mul1},x,fl_mul,rst_i,clk_i,x);//33 bit 
//sqrt
	division_n_digit#(2*n+1,n) Y_d(x,x_o,rst_i,clk_i,rst_d,fl_d,y_d);//y_d 49bit
	DffSync_n_data#(3*n+1,10) X_o(x_o,(x_o+y_d)>>1,fl_mul,rst_i,rst_d,x_o);//x_o 49bit
	//yint_o ydec_o
	assign yint_o=x_o[2*n:16],ydec_o=x_o[15:0];
endmodule :sqrt_16bit
