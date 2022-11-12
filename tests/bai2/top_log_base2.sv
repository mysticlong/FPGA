module top(data0_i,rst_i,clk_i,fl_end,Ynguyen_o,Ythapphan_o,y_check,y_scale,data_o,i,Ythapphan);
input logic [15:0]data0_i;
input logic rst_i,clk_i;
output logic fl_end,Ythapphan;
output logic [3:0]Ynguyen_o,i;
output logic [15:0] data_o,Ythapphan_o;
output logic [31:0] y_check,y_scale ;
  log_base2_16bit  dut(data0_i,rst_i,clk_i,fl_end,Ynguyen_o,Ythapphan_o,y_check,y_scale,data_o,i,Ythapphan);
endmodule:top
