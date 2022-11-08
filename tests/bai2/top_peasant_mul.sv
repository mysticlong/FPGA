module top(data0_i,data1_i,rst_i,clk_i,fl_o,y_o);
input logic data0_i[0:15],data1_i[0:15];
input logic rst_i,clk_i;
output logic y_o[0:31],fl_o;
    peasant_multi_16x16bit dut(data0_i,data1_i,rst_i,clk_i,fl_o,y_o);
endmodule:top
