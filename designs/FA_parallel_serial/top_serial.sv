module top#(parameter n=8)(data0_i,data1_i,rst_i,clk_i,fl_o,sum_o);
input logic [n-1:0] data0_i,data1_i;
input logic rst_i,clk_i;
output logic fl_o;
output logic [n:0] sum_o;
AddSerial_n#(n) dut(data0_i,data1_i,rst_i,clk_i,fl_o,sum_o);
  endmodule:top
