module top(M_i,rst_i,clk_i,fl_end,hash_o,A_o,B_o,C_o,D_o,i,r,s0,F0,F1,F2,F3,F_o,F0_o,F1_o,F2_o,F3_o,M0,rst_exe,K_io);
input logic [31:0] M_i[0:14]; //test 32 bit
input logic rst_i,clk_i;
output logic fl_end,rst_exe;
output logic [127:0] hash_o;
 output	logic [31:0] A_o,B_o,C_o,D_o;
//output	logic[31:0] M_io[0:15]; 
output logic[3:0] i;
output	logic[1:0] r;
	output	logic [31:0] F0_o,F1_o,F2_o,F3_o;
	output	logic [34:0] F0,F1,F2,F3;
	output	logic [33:0] F_o;
	output logic[4:0] s0;
	output logic [31:0] M0[0:15],K_io[0:15];
 md5  dut(M_i,rst_i,clk_i,fl_end,hash_o,A_o,B_o,C_o,D_o,i,r,s0,F0,F1,F2,F3,F_o,F0_o,F1_o,F2_o,F3_o,M0,rst_exe,K_io);
endmodule:top
