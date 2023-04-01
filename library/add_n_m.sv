`include "src/library/add_n.sv"
`include "src/library/DffSync_n_m.sv"
`include "src/library/DffSync_n_data.sv"
`include "src/library/dff_n_m_data.sv"
module add_n_m#(parameter n=32,m=4)(data_i,rst_i,clk_i,sum_o,c_o,fl_end);
input logic[n-1:0] data_i[0:m-1];
input logic rst_i,clk_i;
output logic[n-1:0] sum_o;
output logic c_o,fl_end;
//fl_end 
	logic fl_main;
	assign fl_main=(empty_o[m-1]==0)?1:0; //fl_main
	DffSync_n_data#(1,0) Fl_o(0,fl_main,rst_i,rst_i,clk_i,fl_end);
//dong bo ngo vao
	logic [n-1:0] data_o[0:m-1],data_shift[0:m-1];
	assign data_shift[0]=0,data_shift[1:m-1]=data_o[0:m-2];
	DffSync_n_m#(n,m) Data_o(data_i,data_shift,rst_i,clk_i,data_o);
//bao empty
	logic empty[0:m-1],empty_o[0:m-1];
	assign empty[0]=0,empty[1:m-1]=empty_o[0:m-2];
	dff_n_m_data#(1,m,1) Fl_main(empty,rst_i,clk_i,empty_o);
//tinh tong
	logic[n-1:0] sum;
	add_n#(n) Sum(data_o[m-1],sum_o,clk_i,sum,c_o);
	dff_n_data#(n,0) Sum_o(sum,rst_i,clk_i,sum_o);
endmodule:add_n_m
