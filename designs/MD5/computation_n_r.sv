`include "src/library/DffSync_n.sv"
`include "src/library/dff_n_data.sv"
module computation_n_r#(parameter n=32) (round_i,A_i,B_i,C_i,D_i,M_i,K_i,rst_i,clk_i,rst_o,fl_o,A_o,B_o,C_o,D_o,s0,F0,F1,F2,F3,F_o,F0_o,F1_o,F2_o,F3_o,M0,K_io);
input logic [n-1:0] A_i,B_i,C_i,D_i;
input logic rst_i,clk_i;
input logic[1:0] round_i;
input logic [n-1:0] K_i[0:63],M_i[0:15];
output logic [n-1:0] A_o,B_o,C_o,D_o;
output logic rst_o,fl_o;
logic[3:0] i;
logic fl_main,rst,clk_o;
logic [4:0] s0_i,s1_i,s2_i,s3_i;
assign clk_o=clk_i&~fl_o;
//set up 
output	logic [n-1:0] F0_o,F1_o,F2_o,F3_o,M0[0:15];
output	logic [n+1:0] F0,F1,F2,F3,F_o;
	//select s0
		logic [4:0] s1,s2,s3;
output		logic [4:0] s0;
		DffSync_n#(5) S1(s0_i,s1,rst_i,clk_i&~fl_o,s0);
		DffSync_n#(5) S2(s1_i,s2,rst_i,clk_i&~fl_o,s1);
		DffSync_n#(5) S3(s2_i,s3,rst_i,clk_i&~fl_o,s2);
		DffSync_n#(5) S0(s3_i,s0,rst_i,clk_i&~fl_o,s3);
	//Fi=A+K+M+F(B,C,B)
	//Fi_o=(Fi)<<<s0
		assign F0=({2'b0,A_o}+{2'b0,K_io[i]}+{2'b0,M_i[i]}+{2'b0,((B_o&C_o)|(~B_o&D_o))}), F0_o=(F0[n-1:0]<<s0)+(F0[n-1:0]>>(n-s0));
		assign F1=({2'b0,A_o}+{2'b0,K_io[i]}+{2'b0,M0[i]}+{2'b0,((B_o&D_o)|(C_o&~D_o))}),  F1_o=(F1[n-1:0]<<s0)+(F1[n-1:0]>>(n-s0));
		assign F2=({2'b0,A_o}+{2'b0,K_io[i]}+{2'b0,M0[i]}+{2'b0,(B_o^C_o^D_o)}), 		  F2_o=(F2[n-1:0]<<s0)+(F2[n-1:0]>>(n-s0));
		assign F3=({2'b0,A_o}+{2'b0,K_io[i]}+{2'b0,M0[i]}+{2'b0,(C_o^(B_o|~D_o))}),	      F3_o=(F3[n-1:0]<<s0)+(F3[n-1:0]>>(n-s0));
	//F_o=Fi_o+B.
	//B_next=F_o
		logic[3:0] x;//index cua M_i
output		logic [31:0] K_io[0:15];
		always_comb begin:setup
			case(round_i)
			  0: 	    begin F_o = {2'b0,F0_o}+{2'b0,B_o};
			  				  s0_i=7;s1_i=12;s2_i=17;s3_i=22;//khoi tao S
			  				  K_io=K_i[0:15];
			  				  M0=M_i;
			  				   end
			  2'b01:		begin F_o = {2'b0,F1_o}+{2'b0,B_o};
			  			      s0_i=5;s1_i=9;s2_i=14;s3_i=20;
			  			      K_io=K_i[16:31];
			  			      x=1;
			  			      for(int y=0;y<16;y++) begin
			  			      		M0[y]=M_i[x];
			  			      		x+=5;end
			  			       end
			  2'b10:		begin F_o = {2'b0,F2_o}+{2'b0,B_o};
			  				  s0_i=4;s1_i=11;s2_i=16;s3_i=23;
			  			      K_io=K_i[32:47];			  				  
			  				   x=5;
			  			      for(int y=0;y<16;y++) begin
			  			      		M0[y]=M_i[x];
			  			      		x+=3;end
			  				   end
			  2'b11:		begin F_o = {2'b0,F3_o}+{2'b0,B_o};
			  				  s0_i=6;s1_i=10;s2_i=15;s3_i=21;
			  			      K_io=K_i[48:63];			  				   
			  				  x=0;
			  			      for(int y=0;y<16;y++) begin
			  			      		M0[y]=M_i[x];
			  			      		x+=7;end
			  				  end
		     endcase
		end	;
    //signal is not used
    logic [9:0] Fd,Fd_o;
	assign Fd={F0[n+1:n],F1[n+1:n],F2[n+1:n],F3[n+1:n],F_o[n+1:n]};
	DffSync_n#(10) fd(Fd,Fd_o,rst_i,clk_i&~fl_o,Fd_o);
//flag out
	logic fl1;
	assign fl_main=(i==15)?1:0; //fl_main
	dff_n_data#(1,0) Fl1(fl_main,rst_i,clk_i,fl1);
	dff_n#(1) Fl_o(fl1,clk_i,fl_o);//delay 1 clk de xuat F_o thu 15
//rst out
	dff_n#(1) Rst(fl_o,clk_i,rst);assign rst_o=rst|~fl_o;
//vong lap 
	dff_n_data#(4,0) I(i+1,rst_i,clk_i&~fl1,i);
//output
	DffSync_n#(n) a_o(A_i,D_o,rst_i,clk_o,A_o);		  
	DffSync_n#(n) b_o(B_i,F_o[n-1:0],rst_i,clk_o,B_o);//B_next=F_o
	DffSync_n#(n) c_o(C_i,B_o,rst_i,clk_o,C_o);		  
	DffSync_n#(n) d_o(D_i,C_o,rst_i,clk_o,D_o);	
endmodule:computation_n_r
