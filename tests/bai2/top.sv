module top(data_i,rst_i,clk_i,i_o,data_o,fl,fl_o);
input logic  data_i[0:15];
	input logic rst_i,clk_i;
	output logic [3:0] i_o;
   output  logic data_o[0:15];
	output logic fl,fl_o;
findLength_16bit dut(data_i,rst_i,clk_i,i_o,data_o,fl,fl_o);
endmodule:top
