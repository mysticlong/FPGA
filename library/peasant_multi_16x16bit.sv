`include "src/library/FA_1bit_m.sv"
`include "src/library/dff_n_m.sv"
`include "src/library/dff_n_val.sv"
`include "src/library/dff_n_m_val.sv"
module peasant_multi_16x16bit (data0_i,data1_i,rst_i,clk_i,fl_o,y_o);
input logic data0_i[0:15],data1_i[0:15];
input logic rst_i,clk_i;
output logic y_o[0:31],fl_o;
parameter m=32;
logic clk_o;
logic a_io[0:15],b_io[0:31],a_ii[0:15],b_ii[0:31],a[0:15],A[0:31],x[0:31],b[0:31],c_o[0:31],c_i[0:31];
logic B_i[0:31],y_i[0:31];
logic fl_main=(a_io>=1)?0:1;
assign B_i[0:15]=data1_i[0:15];
initial begin
	 for(int i=0;i<m;i++) A[i]=0;
	 for(int i=16;i<32;i++) B_i[i]=0;
	 end
//dong bo xung clock
 mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
 //dong bo ngo vao
 	//chon a_i
    mux2to1_n_m#(1,16) A_ii(data0_i,a,rst_i,a_ii); assign a[0:14]=a_io[1:15],a[15]=0;//>>1
    dff_n_m#(1,16) A_io(a_ii,rst_i,clk_o,a_io);
    //chon b_i,lay b_i xuat y_o
    mux2to1_n_m#(1,m) B_ii(B_i,b,rst_i,b_ii); assign b[1:31]=b_io[0:30],b[0]=0;//<<1
    dff_n_m#(1,m) B_io(b_ii,rst_i,clk_o,b_io);
    //X=ai_o[0]&b_io
  	mux2to1_n_m#(1,m) X_o(A,b_io,a_io[0],x);//X bang 0 hoac B
//ngo ra
    assign c_i[0]=0;
    FA_1bit_m#(m)  S(x,y_o,c_i,y_i,c_o); 
    dff_n_m_val#(1,31,0) C_i(c_o[0:30],rst_i,clk_o,c_i[1:31]);
    dff_n_m#(1,m) y_oi(y_i,rst_i,clk_o&~fl_o,y_o);
//flag out
	dff_n_val#(1,0) Fl_o(fl_main,rst_i,clk_i,fl_o);
endmodule :peasant_multi_16x16bit
