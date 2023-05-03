/*`include "src/designs/SHA_256/sha_256.sv"
`include "src/designs/SHA_256/decoder.sv"
`include "src/designs/SHA_256/extend_m.sv"
`include "src/designs/SHA_256/computation.sv"
`include "src/designs/SHA_256/K.sv"
`include "src/designs/UART/uart.sv"
`include "src/designs/UART/register_rx.sv"
`include "src/designs/UART/register_tx.sv"
`include "src/library/dff_n.sv"
`include "src/library/AsynFIFO_n_m.sv"
`include "src/library/DffSync_n.sv"
`include "src/library/DffSync_n_m.sv"
`include "src/library/Sub_n.sv"
`include "src/library/add_n.sv"
`include "src/library/add_n_m.sv"
`include "src/library/dff_n_data.sv"
`include "src/library/mux2to1_n.sv"
`include "src/library/FA_1bit.sv"
`include "src/library/dff_n_m_data.sv"
`include "src/library/DffSync_n_data.sv"
`include "src/library/compare_n.sv"*/
module mining(Rx_i,clk_i,Tx_o,fl_end);
input	logic Rx_i,clk_i;
output	logic Tx_o,fl_end;

parameter n=8,extend=4,n_extend=2;
//module uart
	logic EnaWrU,clkWrU,clkRdU,FlFullU,rstSyncU,clkSyncU;
    logic roundU;
	logic[n-1:0] WrU,RdU;
 	uart#(n,5,32) UART(.Rx_i(Rx_i),
 					   .ena_wr_i(EnaWrU),
 					   .wr_i(WrU),
 					   .clk_wr_i(clkWrU),
 					   .clk_rd_i(clkRdU),
 					   .clk_i(clk_i),
 					   .Tx_o(Tx_o),
 					   .rd_o(RdU),
 					   .round(roundU),
 					   .fl_full_b(FlFullU),
 					   .rst_start(rstSyncU),
 					   .clk_Sync(clkSyncU));
 /*	(
 		Rx_i,		//xung Rx
 		EnaWrU,		//=1 cho phep ghi
 		WrU,		//data ghi vao buffer	
 		clkWrU,		//clk write
 		clkRdU,		//clk read	
 		clk_i,		//clk noi
 		Tx_o,		//xung TX
 		RdU,		//doc data tu buffer
 		roundU,		//=0 :trong qua trinh nhan data,=1 qua trinh gui data
 		FlFullU,	//co bao full buffer
 		rstSyncU,   //rst bat dau
 		clkSyncU);	//clk dong bo*/
 	assign clkRdU=clk_i;
 	assign EnaWrU=~fl_main&(empty|empty_o);
 	assign clkWrU=clk_i;
 	assign WrU[7:0]=hash_o_shift[7:0];
//buffer mo rong 128byte
	logic[n-1:0] DataBL[0:127] ;
	logic fl_endBL,fl_fullBL,clk_SyncBL,clk_wrBL,clkSyncU_d;
	assign clk_wrBL=clkSyncU_d&clkSyncU;
	dff_n#(1) ClkSyncU_d(.d_i(clkSyncU),
				 .clk_i(clk_i),
				 .q_o(clkSyncU_d));
//	(clkSyncU,clk_i,clkSyncU_d);
	AsynFIFO_n_m#(8,7,128) BlockHeader(.wr_i(RdU),
										  .ena_wr(FlFullU&~roundU),
										  .clk_wr(clk_wrBL),
										  .ena_rd(0),
										  .clk_rd(clk_i),
										  .rst_i(rstSyncU),
										  .clk_i(clk_i),
										  .data_o(DataBL),
										  .fl_end(fl_endBL),
										  .fl_full(fl_fullBL),
										  .clk_Sync(clk_SyncBL));
/*	(
		RdU,			//data write
		FlFullU&~roundU, //enable write
		clk_wrBL,		//clk_write
		0,		//enable read ,cho phep doc khi tim ra nonce,khong doc data du nguyen
		clk_i,			//clk_read
		rstSyncU,		//reset fifo
		clk_i,			//clk he thong
		DataBL,			//data read
		fl_endBL,		//co bao doc xong
		fl_fullBL,		//co bao full
		clk_SyncBL);	//clk dong bo*/
//sha-256 main
	logic[31:0]	w0[0:31]; 
	always_comb begin:proc
		for(int i=31;i>=0;i--)
		 begin
			w0[31-i]={DataBL[i*4+3],DataBL[i*4+2],DataBL[i*4+1],DataBL[i*4+0]};
	     end
	end	
	//tao reset sha-256
	logic roundU_d,rst_main,fl_end_main;
	dff_n#(1)	Round_d(.d_i(roundU),
				 .clk_i(clk_i),
				 .q_o(roundU_d));
	//(roundU,clk_i,roundU_d);
	assign rst_main=~roundU|roundU_d;		
	logic[255:0] hash_o_main;	
	sha_256#(32,16,0) Sha_main(.m_i(w0[0:15]),
				 .h_i(hash_o_main),
				 .rst_i(rst_main),
				 .clk_i(clk_i),
				 .fl_end(fl_end_main),
				 .hash_out(hash_o_main));				
//	(w0[0:15],hash_o_main,rst_main,clk_i,fl_end_main,hash_o_main);
//sha-256 second
	//rst_second
	logic rst_second,fl_end_main_d;
	dff_n#(1)	Rst_second(.d_i(fl_end_main),
							 .clk_i(clk_i),
							 .q_o(fl_end_main_d));
//	(fl_end_main,clk_i,fl_end_main_d);
	assign rst_second=~fl_end_main|fl_end_main_d;
    //decoder 
	logic	fl_end_second[0:extend-1],fl_end_second_d0,rst_dec;
	dff_n#(1) Clk_nonce_d(.d_i(fl_end_second[0]),
						 .clk_i(clk_i),
						 .q_o(fl_end_second_d0));
//	(fl_end_second[0],clk_i,fl_end_second_d0);//tao xung clk nonce dau tien
	assign rst_dec=~fl_end_second[0]|fl_end_second_d0;
	logic[extend-1:0]  data_dec[0:1];
	decoder#(extend) Decoder(.rst_i(rst_dec&rst_second),
							 .clk_i(clk_i),
							 .data_o(data_dec));
//	(rst_dec&rst_second,clk_i,data_dec);
	// nonce
	logic[31:0] nonce,nonce_o;
	logic	clk_nonce,clk_nonce_o,sign_sub;
	logic [extend-1:0] rst_second_o;
	assign rst_second_o=~data_dec[0];
	assign clk_nonce_o=clk_nonce&fl_end_main&fl_main_d;
	DffSync_n#(32) Nonce(.data0_i(w0[2]&0),
					 .data1_i(nonce+1),
					 .rst_i(rst_main&rstSyncU),
					 .clk_i(clk_nonce_o),
					 .data_o(nonce));
//	(w0[2]&0,nonce+1,rst_main&rstSyncU,clk_nonce_o,nonce);
	Sub_n#(32)   Nonce_o(.sign_i(0),
					 .data0_i(nonce),
					 .data1_i(extend),
					 .clk_i(clk_i),
					 .data_o(nonce_o),
					 .over_o(sign_sub));
//	(0,nonce,extend,clk_i,nonce_o,sign_sub);
	//w1
	logic[31:0] w_second[0:15];
	assign w_second[0:2]=w0[16:18];
	assign w_second[4]=32'h80000000;//gia tri mac dinh khi khong co chuoi ki tu
	assign w_second[5:14]=w0[21:30];
	assign w_second[3]=(fl_main_d)?nonce:nonce_o;
	assign w_second[15]=w0[31]&0|32'h00000280;
	logic[255:0] hash_o_second[0:extend-1];
	//mo rong bo sha-256
	logic clk_Sha_second;
	assign clk_Sha_second=clk_i;
	sha_256#(32,16,1) Second0(.m_i(w_second),
				 .h_i(hash_o_main),
				 .rst_i(rst_main&rst_second&rst_second_o[0]),
				 .clk_i(clk_Sha_second),
				 .fl_end(fl_end_second[0]),
				 .hash_out(hash_o_second[0]));	
//	(w_second,hash_o_main,rst_main&rst_second&rst_second_o[0],clk_Sha_second,fl_end_second[0],hash_o_second[0]);
		genvar s;
		generate
		  for (s =1; s < extend; s++) begin : SHA_INST
		    sha_256#(32,16,1) SecondI(.m_i(w_second),
		    				 .h_i(hash_o_main),
		    				 .rst_i(rst_main&rst_second&rst_second_o[s]),
		    				 .clk_i(clk_Sha_second),
		    				 .fl_end(fl_end_second[s]),
		    				 .hash_out(hash_o_second[s]));	
		//    (w_second,hash_o_main,rst_main&rst_second_o[s],clk_Sha_second,fl_end_second[s],hash_o_second[s]);
		  end
		endgenerate
//flag end
	logic fl_main;//=0 khi tim ra nonce
	logic[255:0] difficult,difficult_shift;
	assign difficult[255:224]=w0[18]<<8,difficult[223:0]=0;
	assign difficult_shift=difficult>>(w0[18][31:24]);
	//so sanh
	logic smaller_o,equal_o;
	logic[n_extend-1:0] index;
	dff_n_data#(n_extend,0) Index(.data_i(index+1),
					 .rst_i(rst_second_o[0]),
					 .clk_i(clk_nonce_o),
					 .data_o(index));
	//(index+1,rst_second_o[0],clk_nonce_o,index);
	compare_n#(256) Compare(.br_signed(0),
							.rs1_d_i(hash_o_second[index]),
							.rs2_d_i(difficult_shift),
							.clk_i(clk_i),
							.br_less_o(smaller_o),
							.br_equal_o(equal_o));
//	(0,hash_o_second[index],difficult_shift,clk_i,smaller_o,equal_o);
	assign fl_main=(smaller_o|equal_o)? 1'b0:1'b1;
	//hash_o
	logic[255:0] hash_o;
	assign hash_o=(fl_main)?'1:hash_o_second[index];
	always_comb begin:ok
		clk_nonce=0;
		for(int a=0;a<extend;a++) 
			clk_nonce|=~data_dec[1][a];
    	end
//truyen du lieu
	// rst_shift
	logic fl_main_d;
	DffSync_n_data#(1,1) Rst_shift(.data0_i(fl_main_d),
						 .data1_i(fl_main),
						 .condition_i(fl_main_d),
						 .rst_i(rst_main),
						 .clk_i(clk_i),
						 .y_o(fl_main_d));
//	(fl_main_d,fl_main,fl_main_d,rst_main,clk_i,fl_main_d);
	logic[255:0] hash_o_shift;
	DffSync_n#(256) H_oS(.data0_i(hash_o),
					 .data1_i(hash_o_shift>>8),
					 .rst_i(fl_main|~fl_main_d),
					 .clk_i(clkSyncU),
					 .data_o(hash_o_shift));
//	(hash_o,hash_o_shift>>8,fl_main|~fl_main_d,clkSyncU,hash_o_shift);
	logic empty,empty_o;
	assign empty=(hash_o_shift==0)?1'b0:1'b1;
	dff_n#(1) Empty_o(.d_i(empty),
				 .clk_i(clkSyncU),
				 .q_o(empty_o));
///	(empty,clkSyncU,empty_o);
//not use
	logic notuse;
	assign notuse=fl_endBL|fl_fullBL|clk_SyncBL|sign_sub;
//fl_end
	dff_n_data#(1,1) Fl_end(.data_i(~fl_end|notuse&0),
					 .rst_i(rstSyncU),
					 .clk_i(~roundU),
					 .data_o(fl_end));
//	(~fl_end|notuse&0,rstSyncU,~roundU,fl_end);
endmodule:mining
	
