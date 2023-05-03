/*`include "src/library/dff_n_m_data.sv"
`include "src/library/dff_n.sv"
`include "src/library/DffSync_n_data.sv"
`include "src/library/mux2to1_n.sv"*/
module AsynFIFO_n_m#(parameter n=32,address=4,m=16) (wr_i,ena_wr,clk_wr,ena_rd,clk_rd,rst_i,clk_i,data_o,fl_end,fl_full,clk_Sync);
input logic[n-1:0] wr_i;
input logic rst_i,clk_i,ena_wr,ena_rd;
input logic clk_wr,clk_rd;
output logic fl_end;
output logic[n-1:0]  data_o[0:m-1];
output	logic clk_Sync;
output logic fl_full;

logic th0,th1,th2;
		assign th0=(~ena_wr_o&~fl_full)?1'b1:1'b0;
		assign th1=(~ena_wr_o&fl_full)?1'b1:1'b0;
		assign th2=(ena_wr_o&~fl_full)?1'b1:1'b0;
//		assign th3=(ena_wr_o&fl_full_o)?1:0;

//fl_end=0 ket thuc 
		dff_n_data#(1,1) Fl_end(.data_i(~fl_end),
						 .rst_i(rst_i),
						 .clk_i(~fl_full),
						 .data_o(fl_end));
	//	(~fl_end,rst_i,~fl_full,fl_end);
//dong bo ngo vao
        logic ena_wr_o,ena_wr_od,ena_rd_o;
        //ena wr
		dff_n_data#(1,0) Ena_wr(.data_i(ena_wr&~round),
						 .rst_i(rst_i),
						 .clk_i(clk_i),
						 .data_o(ena_wr_o));
	//	(ena_wr&~round,rst_i,clk_i,ena_wr_o);
		dff_n#(1) Ena_w_d(.d_i(ena_wr_o),
					 .clk_i(clk_i),
					 .q_o(ena_wr_od));
	//	(ena_wr_o,clk_i,ena_wr_od);
		//ena rd
		dff_n_data#(1,0) Ena_rd(.data_i(ena_rd),
						 .rst_i(rst_i),
						 .clk_i(clk_i),
						 .data_o(ena_rd_o));
	//	(ena_rd,rst_i,clk_i,ena_rd_o);
		//flag full
	  	logic fl_full_o[0:1],fl_full_ow,fl_full_or,clk_Nfl_full_o[0:1];
	  	assign clk_Nfl_full_o[0]=cond_io&~cond|(th2&ena_rd&~ena_rd_o)|(ena_rd&end_wr&~fl_full);
	  	assign clk_Nfl_full_o[1]=cond&~cond_d|th2&ena_rd&~ena_rd_o|ena_rd&end_wr;
		dff_n_data#(1,0) Fl_full0(.data_i(~fl_full_o[0]),
						 .rst_i(rst_i),
						 .clk_i(clk_Nfl_full_o[0]),
						 .data_o(fl_full_o[0]));
	//	(~fl_full_o[0],rst_i,clk_Nfl_full_o[0],fl_full_o[0]); 
		dff_n_data#(1,0) Fl_full1(.data_i(~fl_full_o[1]),
								 .rst_i(rst_i),
								 .clk_i(clk_Nfl_full_o[1]),
								 .data_o(fl_full_o[1]));
	//	(~fl_full_o[1],rst_i,clk_Nfl_full_o[1],fl_full_o[1]); 
    	dff_n#(1) Fl_full_or(.d_i(fl_full_o[0]),
    				 .clk_i(clk_rd),
    				 .q_o(fl_full_or));
    //	(fl_full_o[0],clk_rd,fl_full_or);//delay 1 clk_rd
		dff_n#(1) Fl_full_ow(.d_i(fl_full_o[0]),
		    				 .clk_i(clk_wr),
		    				 .q_o(fl_full_ow));
	//	(fl_full_o[0],clk_wr,fl_full_ow);//delay 1 clk_wr
		assign fl_full=(fl_full_or|fl_full_ow)&fl_full_o[0]&fl_full_ow&fl_full_o[1];
//tao tin hieu ngung ghi lan 1
	logic end_wr;
	DffSync_n_data#(1,0) EndWr(.data0_i(~end_wr),
						 .data1_i(end_wr),
						 .condition_i(end_wr),
						 .rst_i(rst_i),
						 .clk_i(~end_wr&ena_wr_o),
						 .y_o(end_wr));
//	(~end_wr,end_wr,end_wr,rst_i,~end_wr&ena_wr_o,end_wr);
//buffer
	logic[n-1:0] data_i[0:m-1];
	assign data_i[m-1]=(ena_wr_o==1'b0)?0:wr_i,data_i[0:m-2]=data_o[1:m-1];
	dff_n_m_data#(n,m,0) Data_o(.In_i(data_i),
				 .rst_i(rst_i),
				 .clk_i(clk_Sync),
				 .In_o(data_o));
//	(data_i,rst_i,clk_Sync,data_o);
//i:bo dem ghi
	//tao xung reset bo dem i
	logic rst_I;
	assign rst_I=(ena_wr_o|~ena_wr_od|~fl_full_o[0])|round_d;
	//dieu kien cua i	
	logic[address-1:0] i,i_o;
	 logic cond,cond_io,cond_d;
	assign i_o=(th2&~ena_rd_o&~cond|th1&ena_rd_o)?(i+1):i;
	assign	cond=(i=='1)?1'b1:1'b0;
	assign cond_io=(i_o=='1)?1'b1:1'b0;
	dff_n#(1) Cond_d(.d_i(cond),
				 .clk_i(clk_wr),
				 .q_o(cond_d));
//	(cond,clk_wr,cond_d);
//	assign cond_I=cond&cond_d;
	DffSync_n_data#(address,0) I(.data0_i(i_o),
						 .data1_i(i),
						 .condition_i(cond),
						 .rst_i(rst_i&rst_I),
						 .clk_i(clk_Sync&fl_end),
						 .y_o(i));
//	(i_o,i,cond,rst_i&rst_I,clk_Sync&fl_end,i);
//r:round=0 ghi,round=1 doc
	logic round,round_d;
	DffSync_n_data#(1,0) Round(.data0_i(~round),
						 .data1_i(round),
						 .condition_i(round),
						 .rst_i(rst_i),
						 .clk_i(~rst_I),
						 .y_o(round));
//	(~round,round,round,rst_i,~rst_I,round);
	dff_n#(1) Round_d(.d_i(round),
				 .clk_i(clk_i),
				 .q_o(round_d));
//	(round,clk_i,round_d);
// clock mix
	assign clk_Sync=((th0|th1&~ena_rd_o)?1'b0:(th2&ena_rd_o)?clk_i:(th1&ena_rd_o)?clk_rd:clk_wr)&fl_end;
endmodule:AsynFIFO_n_m
	
