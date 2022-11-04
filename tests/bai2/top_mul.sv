module top(data0_i,data1_i,rst_i,clk_i,Y_o,fl_o,X,A_io,a_io,i);
	input logic data0_i[0:15],data1_i[0:15],clk_i,rst_i;
	output logic Y_o[0:15],fl_o;
    output logic A_io[0:15],X[0:15],a_io[0:15];
    output logic[3:0] i;
    multi_16to16 dut(data0_i,data1_i,rst_i,clk_i,Y_o,fl_o,X,A_io,a_io,i);
endmodule:top
