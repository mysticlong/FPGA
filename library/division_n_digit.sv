`include "src/library/DffSync_n.sv"
`include "src/library/DffSync_n_val.sv"
`include "src/library/dff_n_data.sv"
module division_n_digit#(parameter n=32,digit=16)(data0_i,data1_i,digit_i,rst_i,clk_i,rst_o,fl_end,y_into,D,i,fl_in,b_io);
input logic [n-1:0] data0_i,data1_i;
input logic [digit-1:0] digit_i ;
input logic rst_i,clk_i;
output logic rst_o,fl_end,fl_in;
output logic [n-1:0] y_into;
output logic [n+2*digit-1:0] D,b_io;
output logic [4:0] i;
logic clk_o,fl_main,rst;
logic [n+2*digit-1:0] a,a_i,data_o,b,b_i;
assign a[n-1+digit:digit]=data0_i,a[digit-1:0]='0,a[n+2*digit-1:n+digit]=0;
assign b[n-1+digit:digit]=data1_i,b[digit-1:0]=digit_i,b[n+2*digit-1:n+digit]=0;
//dong bo xung clock
	mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
//flag out
    assign fl_main=(i==0)?1:0;
	dff_n_data#(1,0) Fl_end(fl_main,rst_i,clk_i,fl_end);
	//rst out
	dff_n#(1) Rst(fl_end,clk_i,rst);assign rst_o=rst|~fl_end;
//i
	DffSync_n_val#(5,31) I(i,i-1,~fl_main,rst_i,clk_o,i);
//dong bo ngo vao 
	//b_i
	dff_n#(2*digit+n) B_i(b,rst_i,b_i);
	assign 	fl_in=(data_o>=(b_i<<i))?1:0; assign b_io=b_i<<i;
	//a_i
	mux2to1_n#(2*digit+n) A_i(data_o,data_o-(b_i<<i),fl_in,a_i);
    DffSync_n#(2*digit+n) Data_o(a,a_i,rst_i,clk_i&~fl_end,data_o);
    //y_int
     mux2to1_n#(1) Y_int(0,1,fl_in,y_into[i]);
    //y_dec
    assign D=a_i;
endmodule :division_n_digit

	



 



