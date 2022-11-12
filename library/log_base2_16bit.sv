`include "src/library/peasant_multi_nxn.sv"
`include "src/library/check.sv"
`include "src/library/scale_32to16b.sv"
`include "src/library/DffSync_n_data.sv"
module log_base2_16bit(data0_i,rst_i,clk_i,fl_start,Ynguyen_o,Ythapphan_o,y_check,data_o,i,rst_mul,ytp_o);
input logic [15:0]data0_i;
input logic rst_i,clk_i;
output logic fl_start,rst_mul,ytp_o;
output logic [3:0]Ynguyen_o,i;
output logic [15:0] data_o;
output logic [15:0]Ythapphan_o;
output logic[31:0] y_check;
logic[31:0] y_scale;
logic[15:0] y_mul;
logic[3:0] index;
logic fl_main,clk_o,fl_end,fl_scale,fl_check;
logic rst_scale,rst_check,rst_receive;
//dong bo xung clock
	mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
//flag out
    assign fl_main=(i==0)?1:0;
	dff_n_data#(1,0) Fl_end(fl_main,rst_i,clk_i,fl_end);
// rst_receive
	assign fl_start=(i==15)?0:1;
	DffSync_n#(1)  Rst_receive(rst_i,rst_receive,fl_start,clk_i,rst_mul);
//dong bo ngo vao
    DffSync_n#(16) Data_o(data0_i,y_mul,fl_start,~rst_mul,data_o);
//lay 6 bit thap phan
    dff_n_data#(4,15) I(i-1,rst_i,~rst_receive,i);
//x^2
	peasant_multi_nxn#(16) Y_o(data_o,data_o,rst_mul,clk_o,rst_scale,fl_scale,y_scale);//tinh xong fl_scale=1
    //tim index
	dff_n_data#(4,0) Index(index+1,rst_mul,clk_o&~fl_scale,index);	
//scale 
	scale_32to16b Y_scale(y_scale,rst_scale,clk_o&fl_scale,rst_check,fl_check,y_check); 
//check
	check   En_receive(y_check,index,rst_check,clk_o&~fl_end&fl_check,rst_receive,y_mul,ytp_o);
//Y nguyen
	dff_n#(4) Yng(index,fl_start,Ynguyen_o);
//rst Y_tp
	//reg ytp_o;
	 DffSync_n_data#(16,'0) Ytp_o(Ythapphan_o<<1,(Ythapphan_o<<1)+1,ytp_o,rst_i,~rst_mul,Ythapphan_o);
endmodule: log_base2_16bit

