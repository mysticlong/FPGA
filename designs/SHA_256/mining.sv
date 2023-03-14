`include "src/designs/SHA_256/sha_256.sv"
`include "src/designs/UART/uart.sv"
`include "src/library/dff_n.sv"

module mining(Rx_i,rst_i,clk_i,Tx_o);
input	logic Rx_i,rst_i,clk_i;
output	logic Tx_o;
parameter n=8;
//module uart
	logic EnaWrU,clkWrU,clkRdU,round,FlFullU,rstSyncU,clkSyncU;
	logic[n-1:0] WrU,RdU;
 	uart#(n,5,32) UART(
 		Rx_i,
 		EnaWrU,
 		WrU,
 		clkWrU,
 		clkRdU,
 		clk_i,
 		Tx_o,
 		RdU,
 		round,
 		FlFullU,
 		rstSyncU,   //rst bat dau
 		clkSyncU);
 	assign clkRdU=clk_i;
 	assign EnaWrU=~fl_main&empty;
 	assign clkWrU=clk_i;
 	assign WrU[7:0]=hash_o_shift[7:0];
 
//buffer mo rong 128byte
	logic[n-1:0] DataBL[0:127] ;
	logic fl_endBL,fl_fullBL,clk_SyncBL;
	AsynFIFO_n_m#(8,7,128) BlockHeader(
		RdU,
		FlFullU&~round,
		clkSyncU,
		~fl_main,//cho phep doc khi tim ra nonce
		clk_i,
		rstSyncU,
		clk_i,
		DataBL,
		fl_endBL,
		fl_fullBL,
		clk_SyncBL);
//sha-256 main
	logic[31:0]	w0[0:31]; 
	always_comb begin:proc
		for(int i=0;i<32;i++) begin
			w0[i]={DataBL[i*4+3],DataBL[i*4+2],DataBL[i*4+1],DataBL[i*4+0]};
			end
	 hash_main_arr[0]=hash_o_main[31:0];
 	 hash_main_arr[1]=hash_o_main[63:32];
 	 hash_main_arr[2]=hash_o_main[95:64];
	 hash_main_arr[3]=hash_o_main[127:96];
	 hash_main_arr[4]=hash_o_main[159:128];
	 hash_main_arr[5]=hash_o_main[191:160];
	 hash_main_arr[6]=hash_o_main[223:192];
	 hash_main_arr[7]=hash_o_main[255:224];
	end	
	//tao reset sha-256
	logic round_d,rst_main,fl_end_main;
	dff_n#(1)	Round_d(round,clk_i,round_d);
	assign rst_main=~round|round_d;		
	logic[255:0] hash_o_main;	
	sha_256#(32,16,0) main(w0[16:31],hash_main_arr,rst_main,clk_i,fl_end_main,hash_o_main);
	logic[31:0] hash_main_arr[0:7];

//sha-256 second
	//rst_second
	logic rst_second,fl_end_main_d;
	dff_n#(1)	Rst_second(fl_end_main,clk_i,fl_end_main_d);
	assign rst_second=fl_end_main|~fl_end_main_d;
	// nonce
	logic[31:0] nonce;
	DffSync_n#(32) Nonce(w0[12]&0,nonce+1,rst_second,clk_nonce&fl_end_main|~fl_main,nonce);
	//tao clk_nonce
	logic clk_nonce;
	assign clk_nonce=clk_nonce0|clk_nonce1|clk_nonce2|clk_nonce3|clk_nonce4|clk_nonce5|clk_nonce6|clk_nonce7;
	logic clk_nonce0,clk_nonce1,clk_nonce2,clk_nonce3,clk_nonce4,clk_nonce5,clk_nonce6,clk_nonce7;
	logic	fl_end_second0,fl_end_second1,fl_end_second2,fl_end_second3,fl_end_second4,fl_end_second5,fl_end_second6,fl_end_second7,fl_end_second_d0;
	dff_n#(1) Clk_nonce0(fl_end_second0,clk_i,fl_end_second_d0);//tao xung clk nonce dau tien
	assign clk_nonce0=fl_end_second0&~fl_end_second_d0;
	
	dff_n#(1) Clk_nonce1(~rst_second0,clk_i,clk_nonce1);
	dff_n#(1) Clk_nonce2(~rst_second1,clk_i,clk_nonce2);
	dff_n#(1) Clk_nonce3(~rst_second2,clk_i,clk_nonce3);
	dff_n#(1) Clk_nonce4(~rst_second3,clk_i,clk_nonce4);
	dff_n#(1) Clk_nonce5(~rst_second4,clk_i,clk_nonce5);
	dff_n#(1) Clk_nonce6(~rst_second5,clk_i,clk_nonce6);
	dff_n#(1) Clk_nonce7(~rst_second6,clk_i,clk_nonce7);
	//tao rst_second
	logic rst_second0,rst_second1,rst_second2,rst_second3,rst_second4,rst_second5,rst_second6,rst_second7;
	dff_n#(1) Rst_nonce0(~clk_nonce0,clk_i,rst_second0);
	dff_n#(1) Rst_nonce1(~clk_nonce1,clk_i,rst_second1);
	dff_n#(1) Rst_nonce2(~clk_nonce2,clk_i,rst_second2);
	dff_n#(1) Rst_nonce3(~clk_nonce3,clk_i,rst_second3);
	dff_n#(1) Rst_nonce4(~clk_nonce4,clk_i,rst_second4);
	dff_n#(1) Rst_nonce5(~clk_nonce5,clk_i,rst_second5);
	dff_n#(1) Rst_nonce6(~clk_nonce6,clk_i,rst_second6);
	dff_n#(1) Rst_nonce7(~clk_nonce7,clk_i,rst_second7);
	//w1
	logic[31:0] w_second[0:15];
	assign w_second[0]=w0[0]&0|32'h00000280;//mac dinh 640 bit
	assign w_second[1:11]=w0[1:11];
	assign w_second[13:15]=w0[13:15];
	assign w_second[12]=nonce;
	logic[255:0] hash_o_second0,hash_o_second1,hash_o_second2,hash_o_second3,hash_o_second4,hash_o_second5,hash_o_second6,hash_o_second7;
	sha_256#(32,16,1) Second0(w_second,hash_main_arr,rst_second&rst_second0,clk_i|~fl_main,fl_end_second0,hash_o_second0);
	sha_256#(32,16,1) Second1(w_second,hash_main_arr,rst_second1,clk_i|~fl_main,fl_end_second1,hash_o_second1);
	sha_256#(32,16,1) Second2(w_second,hash_main_arr,rst_second2,clk_i|~fl_main,fl_end_second2,hash_o_second2);
	sha_256#(32,16,1) Second3(w_second,hash_main_arr,rst_second3,clk_i|~fl_main,fl_end_second3,hash_o_second3);
	sha_256#(32,16,1) Second4(w_second,hash_main_arr,rst_second4,clk_i|~fl_main,fl_end_second4,hash_o_second4);
	sha_256#(32,16,1) Second5(w_second,hash_main_arr,rst_second5,clk_i|~fl_main,fl_end_second5,hash_o_second5);
	sha_256#(32,16,1) Second6(w_second,hash_main_arr,rst_second6,clk_i|~fl_main,fl_end_second6,hash_o_second6);
	sha_256#(32,16,1) Second7(w_second,hash_main_arr,rst_second7,clk_i|~fl_main,fl_end_second7,hash_o_second7);
//flag end
	logic fl_main;
	logic[255:0] hash_o;
	logic[255:0] difficult,difficult_shift;
	assign difficult[255:224]=w0[13]<<8,difficult[223:0]=0;
	assign difficult_shift=difficult>>w0[13][28:24];
	assign fl_main=(hash_o_second0<difficult_shift|hash_o_second1<difficult_shift|hash_o_second2<difficult_shift|hash_o_second3<difficult_shift|hash_o_second4<difficult_shift|hash_o_second5<difficult_shift|hash_o_second6<difficult_shift|hash_o_second7<difficult_shift)?0:1;
	always_comb begin:ok
	if(!fl_main) begin
		if(hash_o_second0<difficult_shift)      hash_o=hash_o_second0;
		else if(hash_o_second1<difficult_shift) hash_o=hash_o_second1;
		else if(hash_o_second2<difficult_shift) hash_o=hash_o_second2;
		else if(hash_o_second3<difficult_shift) hash_o=hash_o_second3;
		else if(hash_o_second4<difficult_shift) hash_o=hash_o_second4;
		else if(hash_o_second5<difficult_shift) hash_o=hash_o_second5;
		else if(hash_o_second6<difficult_shift) hash_o=hash_o_second6;
		else   hash_o=hash_o_second7;
	end
	else hash_o='1; 
	end
//truyen du lieu
	//tao rst_shift
	logic fl_main_d;
	DffSync_n_data#(1,1) Rst_shift(fl_main_d,fl_main,fl_main_d,rst_main,clk_i,fl_main_d);
	logic[255:0] hash_o_shift;
	DffSync_n#(256) H_oS(hash_o,hash_o_shift>>8,fl_main|~fl_main_d,clkSyncU,hash_o_shift);
	logic empty;
	assign empty=(hash_o_shift==0)?0:1;
//not use
	logic notuse,notuse_o;
	assign notuse=fl_endBL|fl_fullBL|clk_SyncBL|fl_end_second1|fl_end_second2|fl_end_second3|fl_end_second4|fl_end_second5|fl_end_second6|fl_end_second7;
	DffSync_n#(1) NotUse(notuse,notuse_o,rst_i,clk_i,notuse_o);

endmodule:mining
	
