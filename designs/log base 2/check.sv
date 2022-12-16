`include "src/library/DffSync_n.sv"
module check(data0_i,index_i,rst_i,clk_i,rst_o,y_o,ytp_o);
input logic[31:0] data0_i;
input logic [3:0]index_i;
input logic rst_i,clk_i;
output logic rst_o,ytp_o;
output logic [15:0]y_o;
logic [3:0]index_o;
logic [31:0]y_i;
logic fl_main,clk_o,rst,fl_index,fl_index_o,fl_o;
assign fl_main=(y_i<16'h8000)?1:0;
assign fl_index=(index_o>4'b0111)?1:0;
//dong bo xung clock
	mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
//flag out
	dff_n_data#(1,0) Fl_o(fl_main,rst_i,clk_i,fl_o);
//fl_index out
	dff_n_data#(1,0) Fl_index_o(fl_index,rst_i,clk_i,fl_index_o);
//rst out
	dff_n#(1) Rst(fl_o,clk_i,rst);assign rst_o=rst|~fl_o;
// dong bo ngo vao 
   DffSync_n#(32) Y_i(data0_i,y_i>>1,rst_i,clk_o&~fl_o,y_i);
   dff_n#(4)  Index_o(index_i,rst_i,index_o);
//y_o
    assign y_o=y_i[15:0];
//y thap phan
    DffSync_n#(1) Ytp_o(y_o[(index_o<<1)+1],(data0_i==y_i)?0:1,fl_index_o,rst_o,ytp_o);
endmodule: check
