`include "src/library/peasant_multi_nxn.sv"
module log_base2_16bit#(parameter i=6)(data_i,rst_i,clk_i,fl_o,Ynguyen_o,Ythapphan_o);
input logic [15:0]data_i;
input logic rst_i,clk_i,fl_o;
output logic[15:0] Ynguyen_o,Ythapphan_o;
parameter n=16;
logic[15:0] data_io;
logic[31:0] y_o;
logic fl_main,clk_o,fl_index,fl_mul,fl_mul_o,fl_total,fl,fl_check,fl_check_o,fl_shift,fl_shift_o;
assign fl_main=(i==0)?1:0;
//assign fl_index=(a0==0)?1:0;
//dong bo xung clock
	mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
//fl_total
	dff_n_data#(1,0) Fl_total(fl,rst_i,clk_o,fl_total);
	dff_n_data#(1,0) Fl_mul_o(fl_mul,rst_i,clk_o,fl_mul_o); 
	dff_n_data#(1,0) Fl(fl_check_o|fl_shift_o,fl_mul_o,clk_o,fl);
	dff_n_data#(1,1) Fl_check_o(fl_check,fl_mul_o,clk_o,fl_check_o);assign fl_check=(i==0)?0:1;
//flag out
	dff_n_data#(1,0) Fl_o(fl_main,rst_i,clk_i,fl_o);
//rst_mul
	dff_n_data#(1,0) Fl_mul(rst_mul,rst_i,clk_i,fl_mul_o);
//dong bo ngo vao
	mux2to1_n#(n) A0(a,a1>>1,rst_i,a0);
	dff_n#(n) A_o(a0,rst_i,clk_o,a1);
//tim Ynguyen
	dff_n_val#(4,0) Yng(Ynguyen_o+1,rst_i,clk_o&(a0==0)?0:1,Ynguyen_o);
//x^2
	mux2to1_n#(n) A0(a,y_oL,rst_i,a0);
	peasant_multi_nxn#(16) Y_o(a0,a0,rst_mul,clk_o,fl_mul,y_o) ;
// tim index
	dff_n_val#(4,0) Index(index+1,rst_i,clk_o&~fl_mul,index);
	assign fl_shift=((2*index+1)>15)?1:0;
	dff_n_data#(4,1) Fl_shift_o(fl_shift,fl_mul_o,clk_o&fl_mul,fl_shift_o);
	
	
endmodule: log2_x_16bit

