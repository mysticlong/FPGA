`include "src/designs/bai2/peasant_multi_nxn.sv"
`include "src/designs/bai2/check.sv"
`include "src/designs/bai2/scale_32to16b.sv"
`include "src/library/DffSync_n_data.sv"
module log_base2_16bit(data0_i,rst_i,clk_i,fl_end,Ynguyen_o,Ythapphan_o,y_check,data_in,index,rst_mul);
input logic [15:0]data0_i;
input logic rst_i,clk_i;
output logic fl_end,rst_mul;
output logic [3:0]Ynguyen_o,index;
output logic [15:0] data_in;
output logic [15:0]Ythapphan_o;
output logic[31:0] y_check;
logic[31:0] y_scale;
logic[15:0] y_mul;
logic[3:0] size,i;
logic fl_main,clk_o,fl_start,fl_scale,fl_check,ytp_o;
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
    DffSync_n#(16) Data_o(data0_i,y_mul,fl_start,~rst_mul,data_in);
//lay 15 bit thap phan
    dff_n_data#(4,15) I(i-1,rst_i,~rst_receive,i);
// index
	assign index=4'b1110-i;
//x^2
	peasant_multi_nxn#(16) Y_o(data_in,data_in,rst_mul,clk_o,rst_scale,fl_scale,y_scale);//tinh xong fl_scale=1
    //tim size
	dff_n_data#(4,0) Size(size+1,rst_mul,clk_o&~fl_scale,size);	
//scale 
	scale_32to16b Y_scale(y_scale,rst_scale,clk_o&fl_scale,rst_check,fl_check,y_check); 
//check
	check   En_receive(y_check,size,rst_check,clk_o&~fl_end&fl_check,rst_receive,y_mul,ytp_o);
//Y nguyen
	dff_n#(4) Yng(size,fl_start,Ynguyen_o);
//y thap phan
	 DffSync_n_data#(16,'0) Ytp_o(Ythapphan_o<<1,(Ythapphan_o<<1)+1,ytp_o,rst_i,~rst_mul,Ythapphan_o);
endmodule: log_base2_16bit
