`include "src/library/dff_n_m_data.sv"
`include "src/library/dff_n.sv"
`include "src/library/DffSync_n_data.sv"
`include "src/library/mux2to1_n.sv"
module AsynFIFO_n_m#(parameter n=32,address=4,m=16) (wr_i,ena_wr,clk_wr,ena_rd,clk_rd,rst_i,clk_i,data_o,fl_end,fl_full,clk_Sync);
input logic[n-1:0] wr_i;
input logic rst_i,clk_i,ena_wr,ena_rd;
input logic clk_wr,clk_rd;
output logic fl_end;
output logic[n-1:0]  data_o[0:m-1];
output	logic clk_Sync;
output logic fl_full;

logic th0,th1,th2;
		assign th0=(~ena_wr_o&~fl_full)?1:0;
		assign th1=(~ena_wr_o&fl_full)?1:0;
		assign th2=(ena_wr_o&~fl_full)?1:0;
//		assign th3=(ena_wr_o&fl_full_o)?1:0;

//fl_end=0 ket thuc 
		dff_n_data#(1,1) Fl_end(~fl_end,rst_i,~fl_full,fl_end);
//dong bo ngo vao
        logic ena_wr_o,ena_wr_od,ena_rd_o;
        //ena wr
		dff_n_data#(1,0) Ena_wr(ena_wr&~round,rst_i,clk_i,ena_wr_o);
		dff_n#(1) Ena_w_d(ena_wr_o,clk_i,ena_wr_od);
		//ena rd
		dff_n_data#(1,0) Ena_rd(ena_rd,rst_i,clk_i,ena_rd_o);
		//flag full
	  	logic fl_full_o,fl_full_ow,fl_full_or;
		dff_n_data#(1,0) Fl_full(~fl_full_o,rst_i,cond|th2&ena_rd,fl_full_o); 
    	dff_n#(1) Fl_full_or(fl_full_o,clk_rd,fl_full_or);//delay 1 clk_rd
		dff_n#(1) Fl_full_ow(fl_full_o,clk_Sync,fl_full_ow);//delay 1 clk_wr
		assign fl_full=fl_full_or|fl_full_ow;

//buffer
	logic[n-1:0] data_i[0:m-1];
	assign data_i[m-1]=(ena_wr_o==0)?0:wr_i,data_i[0:m-2]=data_o[1:m-1];
	dff_n_m_data#(n,m,0) Data_o(data_i,rst_i,clk_Sync,data_o);
//i:bo dem ghi
	//tao xung reset bo dem i
	logic rst_I;
	assign rst_I=(ena_wr_o|~ena_wr_od|~fl_full_o)|round_d;
	//dieu kien cua i	
	logic[address-1:0] i,i_o;

	 logic cond;
	assign i_o=(th2&~ena_rd_o|th1&ena_rd_o)?(i+1):i;
	assign	cond=(i=='1)?1:0;
//	dff_n#(1) Cond_d(cond,clk_Sync,cond_d);
	DffSync_n_data#(address,0) I(i_o,i,cond,rst_i&rst_I,clk_Sync&fl_end,i);
//r:round=0 ghi,round=1 doc
	logic round,round_d;
	DffSync_n_data#(1,0) Round(~round,round,round,rst_i,~rst_I,round);
	dff_n#(1) Round_d(round,clk_i,round_d);
// clock mix
	assign clk_Sync=((th0|th1&~ena_rd_o)?0:(th2&ena_rd_o)?clk_i:(th1&ena_rd_o)?clk_rd:clk_wr)&fl_end;
endmodule:AsynFIFO_n_m
	
	
