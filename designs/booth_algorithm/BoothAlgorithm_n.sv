`include "src/library/DffSync_n.sv"
`include "src/library/DffSync_n_data.sv"
<<<<<<< HEAD
`include "src/library/dff_n_data.sv"
=======
//`include "src/library/dff_n_data.sv"
>>>>>>> 994d8d4 (sha_256 50%)
module BoothAlgorithm_n#(parameter n=8) (data0_i,data1_i,rst_i,clk_i,fl_o,y_o);
input logic [n:0] data0_i,data1_i;
input logic rst_i,clk_i;
output logic [2*n+1:0]y_o;
output logic fl_o;
logic fl_modify,fl_shift;
logic [n:0] b_1,b;
logic [3:0] i;
logic fl_main;
logic [2*n+2:0] m,m2,m_o,b0,b1,m1_o,m1;
assign b1[2*n+2:n+2]=b_1,b1[n+1:0]=0;
assign b0[2*n+2:n+2]=b,b0[n+1:0]=0;
assign m[n+1:1]=data0_i,m[0]=0,m[2*n+2:n+2]=0;
//flag out
	assign fl_main=(i==n+1)?1:0; //fl_main
	dff_n_data#(1,0) Fl_o(fl_main,rst_i,clk_i,fl_o);
//i
	DffSync_n_data#(4,0) I(i,i+1,~fl_main,rst_i,clk_i,i);
//dong bo ngo vao
//data0_i
	assign  fl_modify=(m_o[1:0]==2'b10)?1:0;
			mux2to1_n#(2*n+3) M2(m_o+b0,m_o+b1,fl_modify,m2);
	assign  fl_shift=(m_o[1:0]==2'b00|m_o[1:0]==2'b11)?1:0;
			mux2to1_n#(2*n+3) M1(m2,m_o,fl_shift,m1);
	//m1>>>1
	assign m1_o[2*n+1:0]=m1[2*n+2:1],m1_o[2*n+2]=m1[2*n+2];
	//tong
	DffSync_n#(2*n+3) M_o(m,m1_o,rst_i,clk_i&~fl_o,m_o);	
	//y_o
	assign y_o=m_o[2*n+2:1];
//data1_i
	DffSync_n#(n+1) B(data1_i,b,rst_i,clk_i&~fl_o,b);	

//	dff_n#(n+1) B(data1_i,rst_i,b);
	assign b_1=~b+1;
endmodule:BoothAlgorithm_n
