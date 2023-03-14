`include "src/library/AsynFIFO_n_m.sv"
//`include "src/library/DffSync_n_m.sv"
//`include "src/library/dff_n.sv"
`include "src/designs/UART/register_rx.sv"
`include "src/designs/UART/register_tx.sv"
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
	dff_n_data#(1,1) Fl_end(~fl_end,rst_rx,~(fl_full_b&end_reg_tx),fl_end);	
	dff_n#(1) Fl_end_d(fl_end,clk_i,fl_end_d);
	//ena_wr
	logic ena_wr_o,s;
	DffSync_n_data#(1,0) Ena_wr(~s,s,s,rst_rx,fl_end_b,s);
	assign ena_wr_o=ena_wr_i&round;
//Register RX
	//tao xung rst_rx
	logic Rx_id,rst_rx;
	assign rst_rx=Rx_i|~Rx_id|fl_end_d;//Rst_rx
	dff_n#(1) Rst_rx(Rx_i,clk_i,Rx_id);		
	//tao xung clk_rx =1.8432MHz
	logic[4:0] r;
	logic clk_rx;
	assign clk_rx=(r==27)?1:0;
	DffSync_n_data#(5,0) R(r+1,0,clk_rx,rst_rx&rst_tx,clk_i,r);
	//reg_rx
	logic[n-1:0] data_o;
	logic end_reg_rx,clk_save;
	register_rx#(10) Reg_Rx(Rx_i,rst_rx,clk_rx,clk_i,clk_save,end_reg_rx,data_o);
//Register Tx
	//tao xung rst_tx
	logic ena_wr_o_d;
    logic rst_tx;
	dff_n#(1) Rst_tx(ena_wr_o,clk_i,ena_wr_o_d);
	assign rst_tx=~ena_wr_o|ena_wr_o_d;
	//tao xung clk_tx=115200 MHz
	logic[3:0] t;
	logic clk_tx;
	assign clk_tx=(t==0)?1:0;
	dff_n_data#(4,0) T(t+1,rst_tx,clk_rx,t);
	//reg_tx
	logic end_reg_tx,clk_sync_tx,ena_tx;
	assign ena_tx=fl_full_b&round&fl_end_b;
	register_tx#(10) Reg_tx(data_b[0],ena_tx,rst_tx,clk_tx,clk_i,clk_sync_tx,Tx_o,end_reg_tx); 
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
	AsynFIFO_n_m#(n,address,m) Buffer(wr_b,ena_wr_b,clk_wr_b,ena_rd_b,clk_rd_b,rst_b,clk_i,data_b,fl_end_b,fl_full_b,clk_Sync);
//round0:Rx,round1:Tx
output logic  round;
   logic round_d;
	dff_n_data#(1,0) Round(~round,rst_rx,~fl_end_b,round);
	dff_n#(1) Round_d(round,clk_i,round_d);
endmodule:uart



	
