/*`include "src/library/DffSync_n_data.sv"
`include "src/library/dff_n_m_data.sv"
`include "src/library/mux2to1_n.sv"
`include "src/library/dff_n.sv"*/
module register_rx#(parameter n=9) (data_i,rst_i,clk_rx,clk_i,clk_save,end_rx_o,data_o);
input logic data_i,rst_i,clk_i,clk_rx;
output logic[7:0] data_o;
output logic clk_save,end_rx_o;
//flag bao ket thuc qua trinh nhan
	dff_n_data#(1,1) Ena_rx(~end_rx_o,rst_i,(x=='1)?1:0,end_rx_o);
//thanh ghi luu 8bit RX
	logic data[0:n-1],data0[0:n-1];
	assign data[0:n-2]=data0[1:n-1],data[n-1]=data_i;
	dff_n_m_data#(1,n,1) Reg(data,rst_i&rst_shift,clk_shift&end_rx_o,data0);
//tao reset bo dem
	logic	data_io,rst_shift;
	dff_n#(1) Data_id(data_i,clk_i,data_io);
	assign rst_shift=data_i|~data_io|~clk_save;
//clk shift	
	logic[3:0] i;
	logic clk_shift;
	assign clk_shift=(i==0)?1:0;	
	dff_n_data#(4,8) I(i+1,rst_i&rst_shift,clk_rx,i);
//flag full
	logic [3:0] r;
	assign clk_save=(r==9)?1:0;
	DffSync_n_data#(4,0) Clk_save(r+1,r,clk_save,rst_i&rst_shift,clk_shift,r);
//bo dem ket thuc qua trinh nhan
	logic[2:0] x;
	logic y;
	assign y=data0[0]&data0[1]&data0[2]&data0[3]&data0[4]&data0[5]&data0[6]&data0[7]&data0[8];
	DffSync_n_data#(3,0) X(0,(x=='1)?x:(x+1),y,rst_i,clk_shift,x);
//data out
	assign data_o={data[8],data[7],data[6],data[5],data[4],data[3],data[2],data[1]};
endmodule:register_rx
