`include "src/mux2to1_nbit.sv"
`include "src/dff_nbit.sv"

module kiemtra(f_i,F_i,rst_i,clk_i,f_o);
input logic f_i,F_i,rst_i,clk_i;
output logic f_o;
logic clk_o,f_oi;
//dong bo xung clock
mux2to1_nbit#(1) Clk_o(clk_i,0,f_i,clk_o);
//kiem tra
mux2to1_nbit#(1) F_oi(f_i,1,F_i,f_oi);
dff_nbit#(1) F_o(f_oi,rst_i,clk_o,f_o);
endmodule:kiemtra


