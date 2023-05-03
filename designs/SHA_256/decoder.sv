/*
`include "src/library/dff_n_data.sv"
`include "src/library/dff_n.sv"*/
module decoder#(parameter m=8)(rst_i,clk_i,data_o);
input logic rst_i,clk_i;
output logic[m-1:0] data_o[0:1];
logic[m-1:0] data[0:1];
dff_n_data#(m,1) Data_shift((~data_o[1])<<1,rst_i,clk_i,data_o[0]);
dff_n#(m) D0(.d_i(data_o[0]),
			 .clk_i(clk_i),
			 .q_o(data[0]));
//(data_o[0],clk_i,data[0]);
dff_n#(m) D2(.d_i(data[0]),
			 .clk_i(clk_i),
			 .q_o(data[1]));
//(data[0],clk_i,data[1]);
dff_n#(m) D3(.d_i(~data[1]),
			 .clk_i(clk_i),
			 .q_o(data_o[1]));
//(~data[1],clk_i,data_o[1]);
endmodule:decoder
