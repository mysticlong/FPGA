`include "src/library/dff_m_shift_Rl.sv"
//`include "src/library/dff_n_val.sv"
`include "src/library/dff_n_data.sv"
`include "src/library/FA_1bit_m.sv"

module FAfull_1_m#(parameter m=16)(data0_i,data1_i,rst_i,clk_i,sum,fl_o);
input logic data0_i[0:m-1],data1_i[0:m-1],rst_i,clk_i;
output logic fl_o;
output logic [3:0]sum;
logic c[0:m],c_o[0:m],c1_o[0:m],a_i[0:m],b_i[0:m],fl_main,c_i[0:m],s_o[0:m],clk_o,d0_i[0:m],d1_i[0:m],sum_o[0:m];
assign fl_main=(c==c_i)?1:0;
assign d0_i[0:m-1]=data0_i,d0_i[m]=0;
assign d1_i[0:m-1]=data1_i,d1_i[m]=0;
always_comb begin:ok
	 for(int i=0;i<=m;i++) begin
	 	 c_i[i]=0;
	 	 sum[i]=sum_o[i];
	 end
	 end
 //dong bo xung clock
	  mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
//flag out
	dff_n_data#(1,0) Fl_o(fl_main,rst_i,clk_i,fl_o);
//dong bo ngo vao
	mux2to1_n_m#(1,m) A_i(d0_i,sum_o,rst_i,a_i);
	mux2to1_n_m#(1,m) B_i(d1_i,c_o,rst_i,b_i);
	 //<<1
	dff_n_m_data#(1,m,0) C1_o(c,rst_i,clk_o,c1_o); 
	dff_m_shift_Rl#(m,0,0) C_o(c1_o,clk_i,clk_i,c_o);//nege nap c1_o,pose xuat c1_o <<1
	 //tinh tong
	 FA_1bit_m#(m)  S(a_i,b_i,c_i,s_o,c);
	dff_n_m#(1,m) Sum_o(s_o,rst_i,clk_o&~fl_o,sum_o);
endmodule: FAfull_1_m
