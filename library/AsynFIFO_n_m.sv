`include "src/library/dff_n_m_data.sv"
//`include "src/library/dff_n.sv"
`include "src/library/DffSync_n_data.sv"
`include "src/library/mux2to1_n.sv"
module AsynFIFO_n_m#(parameter n=32,address=4,m=16) (wr_i,ena_wr,clk_wr,ena_rd,clk_rd,clk_i,rst_i,data_o,fl_end_o);
input logic[n-1:0] wr_i;
input logic rst_i,clk_i,clk_wr,clk_rd,ena_wr,ena_rd;
output logic fl_end_o;
output logic[n-1:0]  data_o[0:m-1];
//fl_end=0 ket thuc 
	logic fl_main;
	assign fl_main=(~ena_wr_d&ena_rd_d&fl_full_o&end_r)?0:1;
		DffSync_n_data#(1,1) Fl_main(fl_main,fl_end_o,~fl_end_o,rst_i,clk_i,fl_end_o);
//dong bo ngo vao
        logic ena_wr_d,ena_rd_d;
		dff_n_data#(1,1) Ena_wr(ena_wr,rst_i,clk_i,ena_wr_d);
		dff_n_data#(1,0) Ena_rd(ena_rd,rst_i,clk_i,ena_rd_d);
		//flag full
    	logic fl_full_o, Nfl_full;
		assign Nfl_full=(ena_wr_d&~fl_full_o&(ena_rd_d|end_w)|~ena_wr_d&fl_full_o&ena_rd_d&end_r|~ena_wr_d&~fl_full_o&ena_rd_d)?1:0;
		DffSync_n_data#(1,0) Fl_full(fl_full_o,~fl_full_o&fl_end_o,Nfl_full,rst_i,clk_i,fl_full_o);
//buffer
	logic[n-1:0] data_i[0:m-1];
	assign data_i[m-1]=(ena_wr_d==0)?0:wr_i,data_i[0:m-2]=data_o[1:m-1];
	dff_n_m_data#(n,m,0) Data_o(data_i,rst_i,clk_mix&fl_end_o,data_o);
//i:bo dem ghi
	logic cond,end_w;
	logic[address-1:0] i,i_o;
	assign end_w=(i=='1)?1:0;
	assign cond=(ena_wr_d&~fl_full_o&~ena_rd_d)?1:0;
	mux2to1_n#(address) I0(0,i+1,cond,i_o);
	DffSync_n_data#(address,0) I(i_o,i,end_w,rst_i,clk_mix,i);
//r:bo dem doc
 	logic[address-1:0] r,r_o;
	logic cond_r,end_r;
	assign end_r=(r=='1)?1:0;
	assign cond_r=(~ena_wr_d&fl_full_o&ena_rd_d)?1:0;
	mux2to1_n#(address) R0(0,r+1,cond_r,r_o);
	DffSync_n_data#(address,0) R(r_o,r,end_r,rst_i,clk_mix,r);	
// clock mix
	logic clk_mix;
	assign clk_mix=ena_wr_d&(fl_full_o|~ena_rd_d)&clk_wr|~ena_wr_d&~fl_full_o&0|~ena_wr_d&fl_full_o &ena_rd_d&clk_rd;
endmodule:AsynFIFO_n_m
	
