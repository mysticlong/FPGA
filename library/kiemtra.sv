`include "src/library/mux2to1_n.sv"
`include "src/library/dff_n_val.sv"

module kiemtra(fl_ref,fl_check_i,rst_i,clk_i,f_check_o);
input logic fl_ref,rst_i,clk_i,fl_check_i;
output logic f_check_o;
logic clk_o,f_oi;
//dong bo xung clock
mux2to1_n#(1) Clk_o(0,clk_i,fl_check_i,clk_o);
//kiem tra
mux2to1_n#(1) F_oi(0,1,fl_ref,f_oi);
dff_n_val#(1,0) F_o(f_oi,rst_i,clk_o,f_check_o);
endmodule:kiemtra


