module top(data0_i,rst_i,clk_i,fl_end,Ynguyen_o,Ythapphan_o,data_in,i);
input logic [15:0]data0_i;
input logic rst_i,clk_i;
output logic fl_end;
output logic [3:0]Ynguyen_o;
output logic [15:0] data_in;
output logic [15:0]Ythapphan_o;
output logic[3:0] i;

 log_base2_16bit  dut(data0_i,rst_i,clk_i,fl_end,Ynguyen_o,Ythapphan_o,data_in,i);
endmodule:top
