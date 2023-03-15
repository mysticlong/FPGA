/*`include "src/library/DffSync_n_data.sv"
`include "src/library/dff_n_m_data.sv"
`include "src/library/mux2to1_n.sv"
`include "src/library/dff_n.sv"*/
module register_rx#(parameter n=9) (DataRegRx_i,rst_i,clk_rx,clk_i,clk_save,end_rx_o,data_o);
input logic DataRegRx_i,clk_i,rst_i,clk_rx;
output logic[7:0] data_o;
output logic clk_save,end_rx_o;
//flag bao ket thuc qua trinh nhan
	dff_n_data#(1,1) Ena_rx(~end_rx_o,rst_i,(x=='1)?1:0,end_rx_o);
//thanh ghi luu 8bit RX
	logic data[0:n-1],data0[0:n-1],rst_reg;
	assign data[0:n-2]=data0[1:n-1],data[n-1]=DataRegRx_i;
	assign rst_reg=rst_I&~clk_save_d;
	dff_n_m_data#(1,n,1) Reg(data,rst_reg,clk_shift&end_rx_o,data0);
//tao reset bo dem
	logic	rst_I,DataRegRx_id;
	dff_n#(1) Rst_reg(DataRegRx_i,clk_i,DataRegRx_id);
	assign rst_I=DataRegRx_i|~DataRegRx_id|~r_d;
	dff_n_data#(4,8) I(i+1,rst_i&rst_I,clk_rx,i);
//clk shift	
	logic[3:0] i;
	logic clk_shift;
	assign clk_shift=(i==0)?1:0;	
//flag full
	assign clk_save=(data0[0]==0)?1:0;
//tao reset_shift
	logic clk_save_d;
	dff_n#(1) Rst_shift(clk_save,clk_rx,clk_save_d);
//round
	logic	r,r_d;
	dff_n_data#(1,0) Round(r+1,rst_i&rst_I,clk_save_d,r);
	dff_n#(1) R_d(r,clk_i,r_d);
//bo dem ket thuc qua trinh nhan
	logic[1:0] x;
	logic y;
	assign y=data0[0]&data0[1]&data0[2]&data0[3]&data0[4]&data0[5]&data0[6]&data0[7]&data0[8];
	DffSync_n_data#(2,0) X(0,(x=='1)?x:(x+1),y,rst_i,clk_shift,x);
//data out
	assign data_o={data0[8],data0[7],data0[6],data0[5],data0[4],data0[3],data0[2],data0[1]};
endmodule:register_rx