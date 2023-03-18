`include "src/designs/SHA_256/sha_256.sv"
`include "src/designs/SHA_256/decoder.sv"
`include "src/designs/UART/uart.sv"
`include "src/library/dff_n.sv"
module mining(Rx_i,rst_i,clk_i,Tx_o,fl_end,nonce_o);
input	logic Rx_i,rst_i,clk_i;
output	logic Tx_o,fl_end;
output logic[31:0] nonce_o;
parameter n=8,extend=4;
//module uart
	logic EnaWrU,clkWrU,clkRdU,FlFullU,rstSyncU,clkSyncU;
    logic roundU;
	logic[n-1:0] WrU,RdU;
 	uart#(n,5,32) UART(
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
 		clkSyncU);	//clk dong bo
 	assign clkRdU=clk_i;
 	assign EnaWrU=~fl_main&(empty|empty_o);
 	assign clkWrU=clk_i;
 	assign WrU[7:0]=hash_o_shift[7:0];
//buffer mo rong 128byte
	logic[n-1:0] DataBL[0:127] ;
	logic fl_endBL,fl_fullBL,clk_SyncBL,clk_wrBL,clkSyncU_d;
	assign clk_wrBL=clkSyncU_d&clkSyncU;
	dff_n#(1) ClkSyncU_d(clkSyncU,clk_i,clkSyncU_d);
	AsynFIFO_n_m#(8,7,128) BlockHeader(
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
		clk_SyncBL);	//clk dong bo
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
	dff_n#(1)	Round_d(roundU,clk_i,roundU_d);
	assign rst_main=~roundU|roundU_d;		
	logic[255:0] hash_o_main;	
	sha_256#(32,16,0) Sha_main(w0[0:15],hash_o_main,rst_main,clk_i,fl_end_main,hash_o_main);
//sha-256 second
	//rst_second
	logic rst_second,fl_end_main_d;
	dff_n#(1)	Rst_second(fl_end_main,clk_i,fl_end_main_d);
	assign rst_second=~fl_end_main|fl_end_main_d;
    //decoder 
	logic	fl_end_second[0:extend-1],fl_end_second_d0,rst_dec;
	dff_n#(1) Clk_nonce_d(fl_end_second[0],clk_i,fl_end_second_d0);//tao xung clk nonce dau tien
	assign rst_dec=~fl_end_second[0]|fl_end_second_d0;
	logic[extend-1:0]  data_dec[0:1];
	decoder#(extend) Decoder(rst_dec&rst_second,clk_i,data_dec);
	// nonce
	logic[31:0] nonce;
	logic	clk_nonce,clk_nonce_o;
	logic [extend-1:0] rst_second_o;
	assign rst_second_o=~data_dec[0];
	assign clk_nonce_o=clk_nonce&fl_end_main&fl_main_d;
	DffSync_n#(32) Nonce(w0[2]&0,nonce+1,rst_main,clk_nonce_o,nonce);
	assign 	nonce_o=nonce+~extend+1;
	//w1
	logic[31:0] w_second[0:15];
	assign w_second[0:2]=w0[16:18];
	assign w_second[4]=32'h80000000;//gia tri mac dinh khi khong co chuoi ki tu
	assign w_second[5:14]=w0[21:30];
	assign w_second[3]=(fl_main|fl_main_d)?nonce:nonce_o;
	assign w_second[15]=w0[31]&0|32'h00000280;;
	logic[255:0] hash_o_second[0:extend-1];
	//mo rong bo sha-256
	logic clk_Sha_second=clk_i;
	sha_256#(32,16,1) Second0(w_second,hash_o_main,rst_main&rst_second&rst_second_o[0],clk_Sha_second,fl_end_second[0],hash_o_second[0]);
		genvar s;
		generate
		  for (s =1; s < extend; s++) begin : SHA_INST
		    sha_256#(32,16,1) SecondI (w_second,hash_o_main,rst_main&rst_second_o[s],clk_Sha_second,fl_end_second[s],hash_o_second[s]);
		  end
		endgenerate
//flag end
	logic fl_main;//=0 khi tim ra nonce
	logic[255:0] hash_o;
	logic[255:0] difficult,difficult_shift;
	assign difficult[255:224]=w0[18]<<8,difficult[223:0]=0;
	assign difficult_shift=difficult>>(w0[18][31:24]);
	always_comb begin:ok
		clk_nonce=0;
		for(int a=0;a<extend;a++) 
		 begin
			clk_nonce|=~data_dec[1][a];
			if(hash_o_second[a]<difficult_shift)
			 begin
				hash_o=hash_o_second[a];
				fl_main=0;
			 end
			else begin
				fl_main=1;
				 hash_o='1; 
			end
		 end
    	end
//truyen du lieu
	// rst_shift
	logic fl_main_d;
	DffSync_n_data#(1,1) Rst_shift(fl_main_d,fl_main,fl_main_d,rst_main,clk_i,fl_main_d);
	logic[255:0] hash_o_shift;
	DffSync_n#(256) H_oS(hash_o,hash_o_shift>>8,fl_main|~fl_main_d,clkSyncU,hash_o_shift);
	logic empty,empty_o;
	assign empty=(hash_o_shift==0)?0:1;
	dff_n#(1) Empty_o(empty,clkSyncU,empty_o);
//not use
	logic notuse,notuse_o;
	assign notuse=fl_endBL|fl_fullBL|clk_SyncBL;
	DffSync_n#(1) NotUse(notuse,notuse_o,rst_i,clk_i,notuse_o);
//fl_end
	dff_n_data#(1,1) Fl_end(~fl_end,rstSyncU,~roundU,fl_end);
endmodule:mining
	
