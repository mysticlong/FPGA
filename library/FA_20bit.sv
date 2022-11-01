`include "src/FA_1bit.sv"
module FA_20bit(a_i,c_i,clk_i,s_o,c_o)
input logic [15:0] a_i,b_i;
input logic c_i,clk_i;
output logic [19:0] s_o;
output logic c_o;
logic [19:0] w={'0,a_i};
  always_comb begin:proc_sub
  	
  	
