/*`include "src/library/AsynFIFO_n_m.sv"
`include "src/designs/UART/register_rx.sv"
`include "src/designs/UART/register_tx.sv"
/*`include "src/library/DffSync_n_m.sv"
`include "src/library/DffSync_n_data.sv"
`include "src/library/dff_n.sv"
`include "src/library/mux2to1_n.sv"
`include "src/library/dff_n_m_data.sv"*/
module uart#(parameter n=8,address=3,m=8)(Rx_i,ena_wr_i,wr_i,clk_wr_i,clk_rd_i,clk_i,Tx_o,rd_o,round,fl_full_b,rst_start,clk_Sync);
input logic Rx_i,ena_wr_i,clk_i,clk_rd_i,clk_wr_i;
input logic[n-1:0] wr_i;
output logic Tx_o,clk_Sync,rst_start;
output logic [n-1:0] rd_o;
                                  // toc do baud 115200,clk_i=50MHz
//rst_start
	assign rst_start=rst_rx;//bat dau qua trinh nhan
//Fl_end:ket thuc 1 qua trinh nhan va gui
	logic fl_end,fl_end_d;
	dff_n_data#(1,1) Fl_end(.data_i(~fl_end),
					 .rst_i(rst_rx),
					 .clk_i(~(fl_full_b&end_reg_tx)),
					 .data_o(fl_end));
//	(~fl_end,rst_rx,~(fl_full_b&end_reg_tx),fl_end);	
	dff_n#(1) Fl_end_d(.d_i(fl_end),
				 .clk_i(clk_i),
				 .q_o(fl_end_d));
//	(fl_end,clk_i,fl_end_d);
	//ena_wr
	logic ena_wr_o,s;
	DffSync_n_data#(1,0) Ena_wr(.data0_i(~s),
						 .data1_i(s),
						 .condition_i(s),
						 .rst_i(rst_rx),
						 .clk_i(fl_end_b),
						 .y_o(s));
//	(~s,s,s,rst_rx,fl_end_b,s);
	assign ena_wr_o=ena_wr_i&round;
//Register RX
	//tao xung rst_rx
	logic Rx_id,rst_rx;
	assign rst_rx=Rx_i|~Rx_id|fl_end_d;//Rst_rx
	dff_n#(1) Rst_rx(.d_i(Rx_i),
				 .clk_i(clk_i),
				 .q_o(Rx_id));
//	(Rx_i,clk_i,Rx_id);		
	//tao xung clk_rx =1.8432MHz
	logic[4:0] r;
	logic clk_rx;
	assign clk_rx=(r==27)?1'b1:1'b0;
	DffSync_n_data#(5,0) R(.data0_i(r+1),
						 .data1_i(0),
						 .condition_i(clk_rx),
						 .rst_i(rst_rx&rst_tx),
						 .clk_i(clk_i),
						 .y_o(r));
//	(r+1,0,clk_rx,rst_rx&rst_tx,clk_i,r);
	//reg_rx
	logic[n-1:0] data_o;
	logic end_reg_rx,clk_save;
	register_rx#(10) Reg_Rx(.DataRegRx_i(Rx_i),
							.rst_i(rst_rx),
							.clk_rx(clk_rx),
							.clk_i(clk_i),
							.clk_save(clk_save),
							.end_rx_o(end_reg_rx),
							.data_o(data_o));
//	(Rx_i,rst_rx,clk_rx,clk_i,clk_save,end_reg_rx,data_o);
//Register Tx
	//tao xung rst_tx
	logic ena_wr_o_d;
    logic rst_tx;
	dff_n#(1) Rst_tx(.d_i(ena_wr_o),
				 .clk_i(clk_i),
				 .q_o(ena_wr_o_d));
//	(ena_wr_o,clk_i,ena_wr_o_d);
	assign rst_tx=~ena_wr_o|ena_wr_o_d;
	//tao xung clk_tx=115200 MHz
	logic[3:0] t;
	logic clk_tx;
	assign clk_tx=(t==0)?1'b1:1'b0;
	dff_n_data#(4,0) T(.data_i(t+1),
					 .rst_i(rst_tx),
					 .clk_i(clk_rx),
					 .data_o(t));
	
//	(t+1,rst_tx,clk_rx,t);
	//reg_tx
	logic end_reg_tx,clk_sync_tx,ena_tx;
	assign ena_tx=fl_full_b&round&fl_end_b;
	register_tx#(10) Reg_tx(.data_i(data_b[0]),
							.ena_tx(ena_tx),
							.rst_i(rst_tx),
							.clk_baud(clk_tx),
							.clk_i(clk_i),
							.clk_reg(clk_sync_tx),
							.data_o(Tx_o),
							.fl_end(end_reg_tx));
//	(data_b[0],ena_tx,rst_tx,clk_tx,clk_i,clk_sync_tx,Tx_o,end_reg_tx); 
//buffer
	logic[n-1:0] wr_b,data_b[0:m-1];
	logic clk_wr_b,ena_wr_b,ena_rd_b,clk_rd_b,fl_end_b,rst_b;
output logic fl_full_b;
	assign ena_wr_b=(round==1)?ena_wr_o:end_reg_rx;
	assign ena_rd_b=(round==1)?(~ena_wr_b|fl_full_b):(~end_reg_rx|fl_full_b);
	assign rd_o=data_b[0];
	assign wr_b=(round==1)?wr_i:data_o;
	assign clk_wr_b=((round==1)?(fl_full_b)?clk_sync_tx:clk_wr_i:clk_save);
	assign clk_rd_b=((round==1)?clk_sync_tx:clk_rd_i);
	assign rst_b=rst_rx&(~round|round_d);
	AsynFIFO_n_m#(n,address,m) Buffer(.wr_i(wr_b),
									  .ena_wr(ena_wr_b),
									  .clk_wr(clk_wr_b),
									  .ena_rd(ena_rd_b),
									  .clk_rd(clk_rd_b),
									  .rst_i(rst_b),
									  .clk_i(clk_i),
									  .data_o(data_b),
									  .fl_end(fl_end_b),
									  .fl_full(fl_full_b),
									  .clk_Sync(clk_Sync));
//	(wr_b,ena_wr_b,clk_wr_b,ena_rd_b,clk_rd_b,rst_b,clk_i,data_b,fl_end_b,fl_full_b,clk_Sync);
//round0:Rx,round1:Tx
output logic  round;
   logic round_d;
	dff_n_data#(1,0) Round(.data_i(~round),
					 .rst_i(rst_rx),
					 .clk_i(~fl_end_b),
					 .data_o(round));
	
//	(~round,rst_rx,~fl_end_b,round);
	dff_n#(1) Round_d (.d_i(round),
			 .clk_i(clk_i),
			 .q_o(round_d));
//	(round,clk_i,round_d);
endmodule:uart



	
