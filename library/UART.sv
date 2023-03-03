`include "src/library/AsynFIFO_n_m.sv"
module UART#(parameter n=9,m=16)(Rx_i,rst_i,clk_i,d_o,Rd_nWr,i,fl_main_o,Rx_o,rst_sp,data_o,clk_sp,clk_mix);
input logic Rx_i,clk_i,rst_i;
output logic Rd_nWr;
output logic[7:0] d_o[0:m-1];
//register nhan du lieu
	logic data_i[0:n-1];
output logic data_o[0:n-1];
	assign data_i[0:n-2]=data_o[1:n-1],data_i[n-1]=Rx_i;
	dff_n_m_data#(1,n,1) Data_o(data_i,rst_i|rst_8bit,clk_mix,data_o);
//fl_main: nhan xong 8 bit
	logic fl_main,rst_8bit;
output	logic fl_main_o;
	assign fl_main=(data_o[0]==0)?1:0;
	assign rst_8bit=~fl_main|fl_main_o;
	dff_n_data#(1,0) Fl_main(fl_main,rst_i,clk_i,fl_main_o);
//	dff_n#(1) Fl_main_od(fl_main_o,clk_i,fl_main_od);
	
//reset cho phep lay mau
output	logic Rx_o,rst_sp;
	dff_n#(1) Rst_sp(Rx_i,clk_i,Rx_o);
	assign rst_sp=Rx_i|~Rx_o ;
//tao 2 xung clk khac tan so
	logic sl;
output logic clk_mix;
	dff_n_data#(1,0) Select(~sl,rst_i,~rst_sp,sl);
	assign clk_mix=~sl&clk_i|sl&clk_sp;
//tao xung lay mau
output	logic[3:0] i;
output	logic clk_sp;
	assign clk_sp=(i==0)?1:0;
	dff_n_data#(4,8) I(i+1,rst_sp,sl&clk_i,i);
//buffer luu du lieu
	logic[7:0] data;
	assign data={data_o[8],data_o[7],data_o[6],data_o[5],data_o[4],data_o[3],data_o[2],data_o[1]};
    AsynFIFO_n_m#(8,m) buffer(data,fl_main,rst_i,clk_i,d_o,Rd_nWr);
endmodule:UART
