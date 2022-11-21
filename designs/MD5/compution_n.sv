`include "src/library/DffSync_n.sv"
`include "src/library/dff_n_data.sv"
module compution_n#(parameter n=32,round=0) (A_i,B_i,C_i,D_i,rst_i,clk_i,fl_o,rst_o,A_o,B_o,C_o,D_o,s0,Fd);
input logic [n-1:0] A_i,B_i,C_i,D_i;
input logic rst_i,clk_i;
//input logic [4:0] S_i;
output logic [n-1:0] A_o,B_o,C_o,D_o;
output logic fl_o,rst_o;
output logic[4:0] Fd;
logic[3:0] i;
logic [n-1:0] F0_o;
logic [n:0] F_o;
logic [n:0] F0,F1,F2,F3;
logic [n-1:0] K_i[0:15],M_i[0:15];
logic [n-1:0] F1_o,F2_o,F3_o;
logic fl_main,rst,clk_o;
logic [4:0] s0_i,s1_i,s2_i,s3_i;
assign clk_o=clk_i&~fl_o;

assign K_i[0]=32'hD76AA478,K_i[1]=32'hE8C7B756,K_i[2]=32'h242070DB,K_i[3]=32'hC1BDCEEE,K_i[4]=32'hF57C0FA,K_i[5]=32'h4787C62A,K_i[6]=32'hA8304613,K_i[7]=32'hFD469501;
assign K_i[8]=32'h698098D8,K_i[9]=32'h8B44F7AF,K_i[10]=32'hFFFF5BB1,K_i[11]=32'h895CD7BE,K_i[12]=32'h6B901122,K_i[13]=32'hFD987193,K_i[14]=32'hA679438E,K_i[15]=32'h49B40821;
assign M_i[0]=32'h54686579,M_i[1]=32'h20617265,M_i[2]=32'h20646574,M_i[3]=32'h65726D69,M_i[4]=32'h6E697374,M_i[5]=32'h69638000,M_i[6]=32'h00000000,M_i[7]=32'h00000000,M_i[8]=32'h00000000,M_i[9]=32'h00000000,M_i[10]=32'h00000000,M_i[11]=32'h00000000,M_i[12]=32'h00000000,M_i[13]=32'h00000000,M_i[14]=32'h000000000,M_i[15]=32'h000000B0;
//set up 
always_comb begin:setup
	case(round)
	  default: 	begin F_o = {1'b0,F0_o}+{1'b0,B_o};
	  				  s0_i=7;s1_i=12;s2_i=17;s3_i=22; end
	  1:		begin F_o = {1'b0,F1_o}+{1'b0,B_o};
	  			      s0_i=5;s1_i=9;s2_i=14;s3_i=20; end
	  2:		begin F_o = {1'b0,F2_o}+{1'b0,B_o};
	  				  s0_i=4;s1_i=11;s2_i=16;s3_i=23; end
	  3:		begin F_o = {1'b0,F3_o}+{1'b0,B_o};
	  				  s0_i=6;s1_i=10;s2_i=15;s3_i=21; end
     endcase
end
assign F0=({1'b0,A_o}+{1'b0,K_i[i]}+{1'b0,M_i[i]}+{1'b0,(B_o&C_o)|(~B_o&D_o)}), F0_o=(F0[n-1:0]<<s0)+(F0[n-1:0]>>(n-s0));
assign F1=({1'b0,A_o}+{1'b0,K_i[i]}+{1'b0,M_i[i]}+{1'b0,(B_o&D_o)|(C_o&~D_o)}), F1_o=(F1[n-1:0]<<s0)+(F1[n-1:0]>>(n-s0));
assign F2=({1'b0,A_o}+{1'b0,K_i[i]}+{1'b0,M_i[i]}+{1'b0,B_o^C_o^D_o}), 			F2_o=(F2[n-1:0]<<s0)+(F2[n-1:0]>>(n-s0));
assign F3=({1'b0,A_o}+{1'b0,K_i[i]}+{1'b0,M_i[i]}+{1'b0,C_o^(B_o|~D_o)}),		F3_o=(F3[n-1:0]<<s0)+(F3[n-1:0]>>(n-s0));
assign Fd={F0[n],F1[n],F2[n],F3[n],F_o[n]};
//S
	output logic [4:0] s0;
	logic [4:0] s1,s2,s3;
	DffSync_n#(5) S1(s0_i,s1,rst_i,clk_i&~fl_o,s0);
	DffSync_n#(5) S2(s1_i,s2,rst_i,clk_i&~fl_o,s1);
	DffSync_n#(5) S3(s2_i,s3,rst_i,clk_i&~fl_o,s2);
	DffSync_n#(5) S0(s3_i,s0,rst_i,clk_i&~fl_o,s3);
//flag out
	assign fl_main=(i==15)?1:0; //fl_main
	dff_n_data#(1,0) Fl_o(fl_main,rst_i,clk_i,fl_o);
//rst out
	dff_n#(1) Rst(fl_o,clk_i,rst);assign rst_o=rst|~fl_o;
//i
	dff_n_data#(4,0) I(i+1,rst_i,clk_i&~fl_o,i);
//dong bo ngo vao
	DffSync_n#(n) a_o(A_i,D_o,rst_i,clk_o,A_o);	
	DffSync_n#(n) b_o(B_i,F_o[n-1:0],rst_i,clk_o,B_o);	
	DffSync_n#(n) c_o(C_i,B_o,rst_i,clk_o,C_o);	
	DffSync_n#(n) d_o(D_i,C_o,rst_i,clk_o,D_o);	
endmodule:compution_n
