module top#(parameter m=16)(data0_i,data1_i,rst_i,clk_i,sum_o,fl_o);
input logic data0_i[0:m-1],data1_i[0:m-1],rst_i,clk_i;
output logic sum_o[0:m],fl_o;
    FAfull_1_m#(m) dut(data0_i,data1_i,rst_i,clk_i,sum_o,fl_o);
 endmodule:top
