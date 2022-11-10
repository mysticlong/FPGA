module scale_32to16b(data0_i,rst_i,clk_i,rst_o,y_o);
input logic [31:0] data0_i;
input logic rst_i,clk_i;
output logic [31:0]y_o;
output logic rst_o;
logic [31:0] y;
logic fl_main,clk_o,rst,fl_o;
assign fl_main=(y_o<=16'hffff)?1:0;
//dong bo xung clock
	mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
//flag out
	dff_n_data#(1,0) Fl_o(fl_main,rst_i,clk_i,fl_o);
//rst out
	dff_n#(1) Rst(fl_o,clk_i,rst);assign rst_o=rst|~fl_o;
// dong bo ngo vao
	mux2to1_n#(32) Y_o(data0_i,y_o>>2,rst_i,y);		//a_o dich trai 2bit
    dff_n#(32) B_o(y,clk_o&~fl_o,y_o);
endmodule:scale_32to16b
