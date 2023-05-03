//`include "src/library/add_n_m.sv"
module extend_m#(parameter n=32,m=16)(m_i,ena_shift,rst_i,clk_i,fl_end,w_o);
input logic[n-1:0] m_i[0:m-1];
input logic rst_i,clk_i,ena_shift;
output logic[n-1:0] w_o[0:m-1];
output logic fl_end;
logic[n-1:0] s0,s1;
logic [n-1:0] d_i[0:m-1];

//dong bo ngo vao
	assign d_i[0:m-2]=w_o[1:m-1],d_i[m-1]=sum_o;
	DffSync_n_m#(n,16) M_o(.data0_i(m_i),
							.data1_i(d_i),
							.rst_i(rst_i),
							.clk_i(~ena_shift),
							.y_o(w_o));
	
	//	(m_i,d_i[0:m-1],rst_i,~ena_shift,w_o[0:m-1]);
//w_o
	assign s0=(w_o[m-15]<<(n-7)|w_o[m-15]>>7)^(w_o[m-15]<<(n-18)|w_o[m-15]>>18)^(w_o[m-15]>>3);
	assign s1=(w_o[m-2]<<(n-17)|w_o[m-2]>>17)^(w_o[m-2]<<(n-19)|w_o[m-2]>>19)^(w_o[m-2]>>10);
	logic[n-1:0] data[0:3],sum_o;
	assign data[0]=w_o[m-16];
	assign data[1]=w_o[m-7];
	assign data[2]=s1;
	assign data[3]=s0;
	//tinh tong
	add_n_m#(n,4) Sum_o(.data_i(data),
						.rst_i(ena_shift),
						.clk_i(clk_i|c0&1'b0),
						.sum_o(sum_o),
						.c_o(c0),
						.fl_end(fl_end));
//	(data,ena_shift,clk_i,sum_o,c0,fl_end);
	//not use
	logic c0;
endmodule :extend_m
	
	
	
