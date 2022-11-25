module top(data0_i,rst_i,clk_i,fl_end,Ynguyen_o,Ythapphan_o,y_check,data_in,index,rst_mul);
input logic [15:0]data0_i;
input logic rst_i,clk_i;
output logic fl_end,rst_mul;
output logic [3:0]Ynguyen_o,index;
output logic [15:0] data_in;
output logic [15:0]Ythapphan_o;
output logic[31:0] y_check;
 log_base2_16bit  dut(data0_i,rst_i,clk_i,fl_end,Ynguyen_o,Ythapphan_o,y_check,data_o,index,rst_mul);
endmodule:top
