//`include "src/library/mux2to1_n.sv"
`include "src/library/dff_n_val.sv"
`include "src/library/dff_n_m.sv"
module findLength_16bit(data_i,rst_i,clk_i,i_o,fl_o);
	input logic  data_i[0:15];
	input logic rst_i,clk_i;
	output logic[3:0] i_o;
  	output logic fl_o;
  	logic data_o[0:15];
	logic clk_o,fl;
	logic [3:0] i_io;
	assign fl=(data_o[i_io])?1:0;
		//dong bo xung clock
   	   mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
   	   //dong bo ngo vao
	   dff_n_m#(1,16) Data_o(data_i,rst_i,rst_i,data_o);
	     // dong bo ngo ra
	   mux2to1_n#(1) Fl_o(0,fl,rst_i,fl_o);
		//tim i
	   dff_n_val#(4,'1) I_io(i_io-1,rst_i,~fl_o&clk_o,i_io);
	   //xuat  i
	   dff_n_val#(4,0) I_o(i_io,fl_o,fl_o,i_o);
endmodule: findLength_16bit 
