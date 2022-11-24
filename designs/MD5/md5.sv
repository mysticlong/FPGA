`include "src/designs/MD5/computation_n_r.sv"
module md5(M_i,rst_i,clk_i,fl_end,hash_o,A_o,B_o,C_o,D_o,i,r,s0,F0,F1,F2,F3,F_o,F0_o,F1_o,F2_o,F3_o,M0,rst_exe,K_io);
input logic [31:0] M_i[0:14]; 
input logic rst_i,clk_i;
output logic fl_end;
output logic [127:0] hash_o;

//setup
	//K_i
	logic[31:0] K_i[0:63];//test
	assign K_i[0]=32'hD76AA478,K_i[1]=32'hE8C7B756,K_i[2]=32'h242070DB,K_i[3]=32'hC1BDCEEE,K_i[4]=32'hF57C0FA,K_i[5]=32'h4787C62A,K_i[6]=32'hA8304613,K_i[7]=32'hFD469501;
	assign K_i[8]=32'h698098D8,K_i[9]=32'h8B44F7AF,K_i[10]=32'hFFFF5BB1,K_i[11]=32'h895CD7BE,K_i[12]=32'h6B901122,K_i[13]=32'hFD987193,K_i[14]=32'hA679438E,K_i[15]=32'h49B40821;
	assign K_i[16]=32'hF61E2562,K_i[17]=32'hC040B340,K_i[18]=32'h265E5A51,K_i[19]=32'hE9B6C7AA,K_i[20]=32'hD62F105D,K_i[21]=32'h02441453,K_i[22]=32'hD8A1E681,K_i[23]=32'hE7D3FBC8;
	assign K_i[24]=32'h21E1CDE6,K_i[25]=32'hC33707D6,K_i[26]=32'hF4D50D87,K_i[27]=32'h455A14ED,K_i[28]=32'hA9E3E905,K_i[29]=32'hFCEFA3F8,K_i[30]=32'h676F02D9,K_i[31]=32'h8D2A4C8A;
	assign K_i[32]=32'hFFFA3942,K_i[33]=32'h8771F681,K_i[34]=32'h699D6122,K_i[35]=32'hFDE5380C,K_i[36]=32'hA4BEEA44,K_i[37]=32'h4BDECFA9,K_i[38]=32'hF6BB4B60,K_i[39]=32'hF6BB4B60;
	assign K_i[40]=32'h289B7EC6,K_i[41]=32'hEAA127FA,K_i[42]=32'hD4EF3085,K_i[43]=32'h04881D05,K_i[44]=32'hD9D4D039,K_i[45]=32'hE6DB99E5,K_i[46]=32'h1FA27CF8,K_i[47]=32'hC4AC5665;
	assign K_i[48]=32'hF4292244,K_i[49]=32'h432AFF97,K_i[50]=32'hAB9423A7,K_i[51]=32'hFC93A039,K_i[52]=32'h655B59C3,K_i[53]=32'h8F0CCC92,K_i[54]=32'hFFEFF47D,K_i[55]=32'h85845DD1;
	assign K_i[56]=32'h6FA87E4F,K_i[57]=32'hFE2CE6E0,K_i[58]=32'hA3014314,K_i[59]=32'h4E0811A1,K_i[60]=32'hF7537E82,K_i[61]=32'hBD3AF235,K_i[62]=32'h2AD7D2BB,K_i[63]=32'hEB86D391;
/*	//M_i
	logic [511:0] M_i1;
output	logic[31:0] M_io[0:15]; 
	assign M_i1[511:480]=M_i[31:0],M_i1[479:0]=480'hB0;//gan M_i voi 512 bit
	genvar m;
	generate
	  	 for(m=0;m<16;m++) begin
	  		assign	M_io[15-m]=M_i1[m*32+31:m*32];		  			
	  		end
	endgenerate*/
	//M_i
	logic [31:0]M_io[0:15];
	assign M_io[0:14]=M_i,M_io[15]=32'hB0;
	//initial A B C D 			      		
	logic[31:0] A,B,C,D;
 //	assign A=32'h01234567,B=32'h89abcdef,C=32'hfedcba98,D=32'h76543210;//test rounf 0
 	assign A=32'h799d1352,B=32'h2c34dfa2,C=32'hde1673be,D=32'h4b976282;//test round 1
 //	assign A=32'h01234567,B=32'h89abcdef,C=32'hfedcba98,D=32'h76543210;//test round 2
 //	assign A=32'h01234567,B=32'h89abcdef,C=32'hfedcba98,D=32'h76543210;//test round 3
 //	assign A=32'h67452301,B=32'hEFCDAB89,C=32'h98BADCFE,D=32'h10325476;
//flag out
	logic fl_main,fl1,fl_o;
	assign fl_main=(r==3)?1:0;
	assign fl_end=(fl_com|fl1)&fl_o;
	dff_n_data#(1,0) Fl1(fl_main,rst_i,clk_i,fl1);
	dff_n#(1) Fl_o(fl1,~rst_com,fl_o);//delay 1 clk de xuat F_o thu 15
//executive
 output	logic [31:0] A_o,B_o,C_o,D_o;
 	 logic [31:0] A1,B1,C1,D1;
	 logic rst_com,fl_com;
	computation_n_r#(32) exe(2'b01,A1,B1,C1,D1,M_io,K_i,rst_exe,clk_i,rst_com,fl_com,A_o,B_o,C_o,D_o,s0,F0,F1,F2,F3,F_o,F0_o,F1_o,F2_o,F3_o,M0,K_io);
	mux2to1_n#(32) a_o(A,A_o,rst_i,A1);
	mux2to1_n#(32) b_o(B,B_o,rst_i,B1);
    mux2to1_n#(32) c_o(C,C_o,rst_i,C1);
	mux2to1_n#(32) d_o(D,D_o,rst_i,D1);
output	logic [31:0] F0_o,F1_o,F2_o,F3_o,M0[0:15],K_io[0:15];
output	logic [33:0] F0,F1,F2,F3,F_o;
output  logic[4:0] s0;
	//round
output	logic[1:0] r;
	dff_n_data#(2,0) R(r+1,rst_i,fl_com|fl1,r);
	//rst_exe
output logic rst_exe;
	mux2to1_n#(1) Rst_exe(rst_i,rst_com,rst_i&~fl_o,rst_exe);
//hash
	logic [7:0] notuse,notuse_o;
	logic[33:0] Ahash,Bhash,Chash,Dhash;
	assign Ahash={2'b0,A_o}+{2'b0,A};
	assign Bhash={2'b0,B_o}+{2'b0,B};
	assign Chash={2'b0,C_o}+{2'b0,C};
	assign Dhash={2'b0,D_o}+{2'b0,D};
	assign hash_o={Ahash[31:0],Bhash[31:0],Chash[31:0],Dhash[31:0]};
	//signal is not used
	assign notuse={Ahash[33:32],Bhash[33:32],Chash[33:32],Dhash[33:32]};	
    DffSync_n#(8) Notuse(notuse,notuse_o,rst_i,clk_i&~fl_o,notuse_o);
//i
output logic[3:0] i;
	dff_n_data#(4,0) I(i+1,rst_exe,clk_i&~fl_end,i);
endmodule:md5



