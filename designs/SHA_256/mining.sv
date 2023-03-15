`include "src/designs/SHA_256/sha_256.sv"
`include "src/designs/SHA_256/decoder.sv"
`include "src/designs/UART/uart.sv"
`include "src/library/dff_n.sv"

module mining(Rx_i,rst_i,clk_i,Tx_o,fl_end);
input	logic Rx_i,rst_i,clk_i;
output	logic Tx_o,fl_end;
parameter n=8,extend=2;
//module uart
	logic EnaWrU,clkWrU,clkRdU,FlFullU,rstSyncU,clkSyncU;
    logic round;
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
 	logic	FlFullU_d;
 	dff_n#(1) FlFullUd(FlFullU,clkSyncU,FlFullU_d);
//buffer mo rong 128byte
	logic[n-1:0] DataBL[0:127] ;
	logic fl_endBL,fl_fullBL,clk_SyncBL;
	AsynFIFO_n_m#(8,7,128) BlockHeader(
		RdU,			//data write
		FlFullU&~round&FlFullU_d, //enable write
		clkSyncU,		//clk_write
		~fl_main,		//enable read ,cho phep doc khi tim ra nonce,khong doc data du nguyen
		clk_i,			//clk_read
		rstSyncU,		//reset fifo
		clk_i,			//clk he thong
		DataBL,			//data read
		fl_endBL,		//co bao doc xong
		fl_fullBL,		//co bao full
		clk_SyncBL);	//clk dong bo
//sha-256 main
	logic[31:0] hash_main_arr[0:7];
	logic[31:0]	w0[0:31]; 
	always_comb begin:proc
		for(int i=0;i<32;i++)
		 begin
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
	logic	clk_nonce;
	logic [extend-1:0] rst_second_o;
	assign rst_second_o=~data_dec[0];
	DffSync_n#(32) Nonce(w0[12]&0,nonce+1,rst_main,clk_nonce&fl_end_main&fl_main_d,nonce);
	//w1
	logic[31:0] w_second[0:15];
	assign w_second[0]=w0[0]&0|32'h00000280;//mac dinh 640 bit
	assign w_second[1:10]=w0[1:10];
	assign w_second[11]=32'h10000000;//gia tri mac dinh khi khong co chuoi ki tu
	assign w_second[12]=nonce;
	assign w_second[13:15]=w0[13:15];
	logic[255:0] hash_o_second[0:extend-1];
	//mo rong bo sha-256
	sha_256#(32,16,1) Second0(w_second,hash_main_arr,rst_second&rst_second_o[0],clk_i|~fl_main,fl_end_second[0],hash_o_second[0]);
		genvar s;
		generate
		  for (s =1; s < extend; s++) begin : SHA_INST
		    sha_256#(32,16,1) sha_inst (w_second,hash_main_arr,rst_second_o[s],clk_i | ~fl_main,fl_end_second[s],hash_o_second[s]);
		  end
		endgenerate
//flag end
	logic fl_main;
	logic[255:0] hash_o;
	logic[255:0] difficult,difficult_shift;
	assign difficult[255:224]=w0[13]<<8,difficult[223:0]=0;
	assign difficult_shift=difficult>>w0[13][28:24];
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
	logic empty;
	assign empty=(hash_o_shift==0)?0:1;
//not use
	logic notuse,notuse_o;
	assign notuse=fl_endBL|fl_fullBL|clk_SyncBL;//|fl_end_second[1]|fl_end_second[2]|fl_end_second[3]|fl_end_second[4]|fl_end_second[5]|fl_end_second[6]|fl_end_second[7];
	DffSync_n#(1) NotUse(notuse,notuse_o,rst_i,clk_i,notuse_o);
//fl_end
	assign fl_end=round|fl_main;
endmodule:mining
	
