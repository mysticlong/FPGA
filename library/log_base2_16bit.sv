`include "src/library/peasant_multi_nxn.sv"
`include "src/library/check.sv"
`include "src/library/scale_32to16b.sv"
`include "src/library/dff_n_val.sv"
module log_base2_16bit(data0_i,rst_i,clk_i,fl_start_o,Ynguyen_o,Ythapphan_o,y_check,y_scale,data_o,i);
input logic [15:0]data0_i;
input logic rst_i,clk_i;
output logic fl_start_o;
output logic [3:0]Ynguyen_o,i;
output logic [15:0] data_o;
output logic Ythapphan_o[15:0];
logic[15:0] y_mul;
output logic[31:0] y_check,y_scale;
logic[3:0] index;
logic fl_main,clk_o,fl_mul,fl_end;
logic en_scale,en_mul,en_check,rst_mul;
//dong bo xung clock
	mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
//flag out
    assign fl_main=(i==0)?1:0;
	dff_n_data#(1,0) Fl_end(fl_main,rst_i,clk_i,fl_end);
// rst_mul
	assign fl_start_o=(i==15)?0:1;
	mux2to1_n#(1)  Rst_mul(rst_i,en_mul,fl_start_o,rst_mul);
//dong bo ngo vao
    DffSync_n#(16) Data_o(data0_i,y_mul,fl_start_o,~rst_mul,data_o);
//lay 6 bit thap phan
    dff_n_data#(4,15) I(i-1,rst_i,~en_mul,i);
//x^2
	peasant_multi_nxn#(16) Y_o(data_o,data_o,rst_mul,clk_o,en_scale,fl_mul,y_scale) ;
    //tim index
	dff_n_val#(4,0) Index(index+1,rst_mul,clk_o&~fl_mul,index);	
//scale y_mul
	scale_32to16b Y_scale(y_scale,en_scale,clk_o,en_check,y_check); 
//check
	check   En_mul(y_check,index,en_check,clk_o&~fl_end,en_mul,y_mul,Ythapphan_o[i]);
//Y nguyen
	dff_n#(4) Yng(index,fl_start_o,Ynguyen_o);
endmodule: log_base2_16bit

