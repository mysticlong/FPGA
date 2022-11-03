`include "src/library/FA_1bit_m.sv"
`include "src/library/mux16to1_m.sv"
`include "src/library/dff_n_val.sv"
`include "src/library/dff_n_m.sv"
`include "src/library/dff_n_m_val.sv"
`include "src/library/mux2to1_n.sv"
module multi_16to16(data0_i,data1_i,rst_i,clk_i,Y_o,fl_o);
	input logic data0_i[0:15],data1_i[0:15],clk_i,rst_i;
	output logic Y_o[0:15],fl_o;
	logic[3:0] i;	
	logic c_i[0:15],c_o[0:15],b[0:15],s[0:15],X[0:15],a_io[0:15],b_io[0:15];
    logic A_io[0:15],D[0:15],Q[0:15];
 	logic clk_o,fl_mul_o,a_o;
	logic  A[0:15]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    assign D[0]=0,Q[0:14]=D[1:15];
	assign b[15]=0,b[0:14]=Y_o[1:15];
    assign a_io[i] =Q[i]&A_io[i];
	assign fl_mul_o=(c_o==a_io)?0:1; 	//nhân xong
	// đồng bộ ngõ vào
	   dff_n_m#(1,16) A_io_arr(data0_i,rst_i,rst_i,A_io); //data0
	   dff_n_m#(1,16) B_io_arr(data1_i,rst_i,rst_i,b_io); //data1 
	//flag out
	mux2to1_n#(1) Fl_o(0,1,fl_mul_o,fl_o);
	// dong bo xung clock
	mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
   //a_io=0 khi gán xong
	  dff_n_m_val#(1,16,1) Q_o(D,rst_i,clk_o,Q); //dich bit
	   //gán lần lượt a_io
 	dff_n_val#(4,'1) I(i+1,rst_i,clk_o,i);
	mux16to1_m A_o(a_io,i,a_o);
	//X=a_o&B_i
   	mux2to1_n_m#(1,16) X_o(A,b_io,a_o,X);
    //xuất ngõ ra
    dff_n_m#(1,16) C_i(c_o,rst_i,clk_o,c_i); //16 delay 1bit
    FA_1bit_m#(16) S(X,b,c_i,s,c_o);  //16 bộ cộng 1 bit
    dff_n_m#(1,16) y_o(s,rst_i,clk_o,Y_o);//16 delay 1bit
endmodule:multi_16to16
