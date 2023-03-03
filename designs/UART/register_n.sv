`include "src/library/AsynFIFO_n_m.sv"
`include "src/library/DffSync_n_data.sv"
`include "src/library/mux2to1_n.sv"
module register_n#(parameter n=9,baud=4,start=8) (data_i,rst_i,clk_i,fl_end,clk_full,data_o,clk_shift,data_buff,Rd_nWr);
input logic data_i,rst_i,clk_i;
output logic[7:0] data_o;
output logic clk_full,fl_end;
//thanh ghi luu 8bit RX
	logic data[0:n-1],data0[0:n-1];
	assign data[0:n-2]=data0[1:n-1],data[n-1]=data_i;
	dff_n_m_data#(1,n,1) Reg(data,rst_i&~clk_full,clk_shift,data0);
//clk shift	
	logic[baud-1:0] i;
output	logic clk_shift;
	assign clk_shift=(i==0)?1:0;	
	dff_n_data#(baud,start) I(i+1,rst_i&~clk_full,clk_i,i);
//flag full
	assign clk_full=(data0[0]==0)?1:0;
//flag end
	logic[1:0] x;
	logic y;
	dff_n_data#(2,0) X(x+1,rst_i&~clk_full,clk_shift,x);
	assign y=data0[0]&data0[1]&data0[2]&data0[3]&data0[4]&data0[5]&data0[6]&data0[7]&data0[8];
    DffSync_n_data#(1,0) Fl_end(fl_end|Rd_nWr,y|Rd_nWr,(x==3)?1:0,rst_i,clk_i,fl_end);
//data out
	assign data_o={data0[8],data0[7],data0[6],data0[5],data0[4],data0[3],data0[2],data0[1]};
//buffer
output	logic[7:0] data_buff[0:7];
output	logic Rd_nWr;
	AsynFIFO_n_m#(8,3,8) Buff(data_o,clk_full,rst_i,clk_i,data_buff,Rd_nWr);
endmodule:register_n
