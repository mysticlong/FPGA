/*`include "src/library/DffSync_n.sv"
`include "src/library/DffSync_n_val.sv"*/

input logic [n-1:0] data0_i;
input logic [n-1+digit:0] data1_i;
input logic rst_i,clk_i;
output logic rst_o,fl_end;
output logic [n-1+digit:0] y_o;
 logic [n+3*digit-1:0] b_i;
logic [index-1:0] i;
logic clk_o,fl_main,rst,fl_in;
logic [n+3*digit-1:0] a,a_i,data_o,b;
assign a[n-1+2*digit:2*digit]=data0_i,a[2*digit-1:0]='0,a[n+3*digit-1:n+2*digit]=0;
assign b[n-1+digit:0]=data1_i,b[n+3*digit-1:n+digit]=0;
//dong bo xung clock
	mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
//flag out
    assign fl_main=(i==0)?1:0;
	dff_n_data#(1,0) Fl_end(fl_main,rst_i,clk_i,fl_end);
	//rst out
	dff_n#(1) Rst(fl_end,clk_i,rst);assign rst_o=rst|~fl_end;
//i
	DffSync_n_val#(index,63) I(i,i-1,~fl_main,rst_i,clk_o,i);
//divison
	//b_i
	dff_n#(3*digit+n) B_i(b,rst_i,b_i);
	assign 	fl_in=(data_o>=(b_i<<i))?1:0;
	//tim so du
	mux2to1_n#(3*digit+n) A_i(data_o,data_o-(b_i<<i),fl_in,a_i);
    DffSync_n#(3*digit+n) Data_o(a,a_i,rst_i,clk_i&~fl_end,data_o);
    //y_o=n.digit
     mux2to1_n#(1) Y_o(0,1,fl_in,y_o[i]);
endmodule :division_n_digit

	



 



