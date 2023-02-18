module computation#(parameter n=32,m=8) (data_i,w_i,k_i,rst_i,clk_i,data_o);
input logic [n-1:0] data_i[0:m-1],w_i,k_i;
input logic clk_i,rst_i;
output logic [n-1:0] data_o[0:m-1];
//set up 
		logic [n-1:0] ch,sigma_1,sigma_0,ma;
		logic [n-1:0] E6,E11,E25,A2,A13,A22;
		assign E6=data_o[4]<<(n-6)|data_o[4]>>6, E11=data_o[4]<<(n-11)|data_o[4]>>11, E25=data_o[4]<<(n-25)|data_o[4]>>25;
		assign A2=data_o[0]<<(n-2)|data_o[0]>>2, A13=data_o[0]<<(n-13)|data_o[0]>>13, A22=data_o[0]<<(n-22)|data_o[0]>>22;
    	assign ch=(data_o[4]&data_o[5])^(~data_o[4]&data_o[6]);
        assign ma=(data_o[0]&data_o[1])^(data_o[0]&data_o[2])^(data_o[1]&data_o[2]);
        assign sigma_1=E6^E11^E25;
        assign sigma_0=A2^A13^A22;
// dong bo ngo vao
	logic [n-1:0] din[0:m-1];
	assign din[0]=sum_o[6],din[1:3]=data_o[0:2],din[4]=sum_o[4],din[5:7]=data_o[4:6];
	DffSync_n_m#(n,m) Din_o(data_i,din,rst_i,clk_i,data_o);
//addition modulo
 	genvar i;
 	generate //7 bo cong
 	for (i=0;i<7;i++) begin
	add_n#(32) S_o(A[i],B[i],clk_i,sum_o[i],c_o[i]); 
	end
	endgenerate
	logic[n-1:0] A[0:6],B[0:6],sum_o[0:6];
	assign A[0]=w_i,B[0]=k_i;
	assign A[1]=sum_o[0],B[1]=data_o[7];
	assign A[2]=sum_o[1],B[2]=ch;
	assign A[3]=sum_o[2],B[3]=sigma_1;
	assign A[4]=sum_o[3],B[4]=data_o[3];
	assign A[5]=sum_o[3],B[5]=ma;
	assign A[6]=sum_o[5],B[6]=sigma_0;
//signal not use
	logic notused_o,notused,c_o[0:6];
	assign notused=c_o[0]|c_o[1]|c_o[2]|c_o[3]|c_o[4]|c_o[5]|c_o[6];
	DffSync_n#(1) Notuse(notused,notused_o,rst_i,clk_i,notused_o);
endmodule:computation
