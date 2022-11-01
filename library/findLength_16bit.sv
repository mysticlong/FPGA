`include "src/mux2to1_nbit.sv"
`include "src/dff_nbit.sv"
`include "src/dff_nbit_m.sv"
module findLength_16bit(data_i,rst_i,clk_i,i_o,data_o,fl,fl_o);
	input logic  data_i[0:15];
	input logic rst_i,clk_i;
	output logic[3:0] i_o;
     output  logic data_o[0:15];
	output logic fl,fl_o;
	logic clk_o;
	logic [3:0] i_ii,i_io;
	assign fl=(data_o[i_io])?1:0;
		//dong bo xung clock
   	   mux2to1_nbit#(1) Clk_o(0,clk_i,rst_i,clk_o);
   	   //dong bo ngo vao
	   dff_nbit_m#(1,15) Data_o(data_i,rst_i,rst_i,data_o);
	     // dong bo ngo ra
	 //   dff_nbit#(1,'0) Fl_o(fl,rst_i,rst_i,fl_o);
	   mux2to1_nbit#(1) Fl_o(0,fl,rst_i,fl_o);
		//tim i
	   mux2to1_nbit#(4) I_ii(i_io-1,i_io,fl_o,i_ii);
	   dff_nbit#(4,'0) 	I_io(i_ii,rst_i,~fl_o&clk_o,i_io);
	   //xuat  i
	   dff_nbit#(4,0) I_o(i_io,fl_o,fl_o,i_o);
endmodule: findLength_16bit 
