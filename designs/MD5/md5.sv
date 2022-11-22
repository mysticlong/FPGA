`include "src/designs/MD5/computation_n_r.sv"
module md5(M_i,rst_i,clk_i,rst_o,fl_o,fl1,hash_o,A1,B1,C1,D1,A2,B2,C2,D2,A3,B3,C3,D3,A4,B4,C4,D4);
input logic [31:0] M_i[0:15];
input logic rst_i,clk_i;
output logic fl_o,rst_o,fl1;
output logic [127:0] hash_o;
//setup
	logic [31:0]K_i[0:63];
	assign K_i[0]=32'hD76AA478,K_i[1]=32'hE8C7B756,K_i[2]=32'h242070DB,K_i[3]=32'hC1BDCEEE,K_i[4]=32'hF57C0FA,K_i[5]=32'h4787C62A,K_i[6]=32'hA8304613,K_i[7]=32'hFD469501;
	assign K_i[8]=32'h698098D8,K_i[9]=32'h8B44F7AF,K_i[10]=32'hFFFF5BB1,K_i[11]=32'h895CD7BE,K_i[12]=32'h6B901122,K_i[13]=32'hFD987193,K_i[14]=32'hA679438E,K_i[15]=32'h49B40821;
	assign K_i[16]=32'hF61E2562,K_i[17]=32'hC040B340,K_i[18]=32'h265E5A51,K_i[19]=32'hE9B6C7AA,K_i[20]=32'hD62F105D,K_i[21]=32'h02441453,K_i[22]=32'hD8A1E681,K_i[23]=32'hE7D3FBC8;
	assign K_i[24]=32'h21E1CDE6,K_i[25]=32'hC33707D6,K_i[26]=32'hF4D50D87,K_i[27]=32'h455A14ED,K_i[28]=32'hA9E3E905,K_i[29]=32'hFCEFA3F8,K_i[30]=32'h676F02D9,K_i[31]=32'h8D2A4C8A;
	assign K_i[32]=32'hFFFA3942,K_i[33]=32'h8771F681,K_i[34]=32'h699D6122,K_i[35]=32'hFDE5380C,K_i[36]=32'hA4BEEA44,K_i[37]=32'h4BDECFA9,K_i[38]=32'hF6BB4B60,K_i[39]=32'hF6BB4B60;
	assign K_i[40]=32'h289B7EC6,K_i[41]=32'hEAA127FA,K_i[42]=32'hD4EF3085,K_i[43]=32'h04881D05,K_i[44]=32'hD9D4D039,K_i[45]=32'hE6DB99E5,K_i[46]=32'h1FA27CF8,K_i[47]=32'hC4AC5665;
	assign K_i[48]=32'hF4292244,K_i[49]=32'h432AFF97,K_i[50]=32'hAB9423A7,K_i[51]=32'hFC93A039,K_i[52]=32'h655B59C3,K_i[53]=32'h8F0CCC92,K_i[54]=32'hFFEFF47D,K_i[55]=32'h85845DD1;
	assign K_i[56]=32'h6FA87E4F,K_i[57]=32'hFE2CE6E0,K_i[58]=32'hA3014314,K_i[59]=32'h4E0811A1,K_i[60]=32'hF7537E82,K_i[61]=32'hBD3AF235,K_i[62]=32'h2AD7D2BB,K_i[63]=32'hEB86D391;
	logic[31:0] A,B,C,D;
output	logic[31:0] A1,B1,C1,D1,A2,B2,C2,D2,A3,B3,C3,D3,A4,B4,C4,D4;
	assign A=32'h01234567,B=32'h89abcdef,C=32'hfedcba98,D=32'h76543210;
    logic rst1,rst2,rst3;
    logic fl2,fl3,fl4;
//flag out
	DffSync_n#(1) Fl_o(0,fl4,rst_o,clk_i,fl_o);
//executive
	//round 0 
	computation_n_r#(32,0) R0(A,B,C,D,M_i,K_i[0:15],rst_i,clk_i,fl1,rst1,A1,B1,C1,D1);
	//round 1
	computation_n_r#(32,1) R1(A1,B1,C1,D1,M_i,K_i[16:31],rst1,clk_i&fl1,fl2,rst2,A2,B2,C2,D2);
	//round 2
	computation_n_r#(32,2) R2(A2,B2,C2,D2,M_i,K_i[32:47],rst2,clk_i&fl2,fl3,rst3,A3,B3,C3,D3);
	//round 3
	computation_n_r#(32,1) R3(A3,B3,C3,D3,M_i,K_i[48:63],rst3,clk_i&fl3&fl2&fl1,fl4,rst_o,A4,B4,C4,D4);
//hash
	logic [3:0] notuse,notuse_o;
	logic[32:0] Ahash,Bhash,Chash,Dhash;
	assign Ahash={1'b0,A4}+{1'b0,A};
	assign Bhash={1'b0,B4}+{1'b0,B};
	assign Chash={1'b0,C4}+{1'b0,C};
	assign Dhash={1'b0,D4}+{1'b0,D};
	assign hash_o={Ahash[31:0],Bhash[31:0],Chash[31:0],Dhash[31:0]};
	//signal is not used
	assign notuse={Ahash[32],Bhash[32],Chash[32],Dhash[32]};	
	DffSync_n#(4) Notuse(notuse,notuse_o,rst_i,clk_i&~fl_o,notuse_o);
endmodule:md5



