module top#(parameter n=4,m=10)(data_i,rst_i,clk_i,fl_end,min1_o,min2_o,index_o,i,data_in);
input logic[n-1:0] data_i[0:9];
input logic rst_i,clk_i;
output logic fl_end;
output logic[n-1:0] min1_o,min2_o,data_in;
output logic [3:0] index_o,i; 
FindMinIndex2_n#(n,m)  dut(data_i,rst_i,clk_i,fl_end,min1_o,min2_o,index_o,i,data_in);
endmodule:top
