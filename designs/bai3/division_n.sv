`include "src/library/DffSync_n_data.sv"
module division_n_digit#(parameter n=32,digit=16)(data0_i,data1_i,digit_i,rst_i,clk_i,rst_o,fl_o,y_int,y_dec);
input logic [n-1:0] data0_i,data1_i;
input logic [digit-1:0] digit_i ;
input logic rst_i,clk_i;
output logic rst_o,clk_o;
output logic [n-1:0] y_int,y_dec;
logic fl_in,rst,rst_in,rst_d,rst_do,fl_d;
logic [n+digit+1:0] A,B,D,B_i,A_i,D_in,y_o;
assign A[n-1+digit:digit]=data0_i;A[digit-1:0]='0,A[n]=0;
assign B[n-1+digit:digit]=data1_i;b[digit-1:0]=digit_i,B[n]=0;
//dong bo xung clock
	mux2to1_n#(1) Clk_o(0,clk_i,rst_i,clk_o);
//flag out
    assign fl_main=(i==0)?1:0;
	dff_n_data#(1,0) Fl_end(fl_main,rst_i,clk_i,fl_end);
//dong bo ngo vao T0
	assign fl_in=(A_i>=B_i)?0:1;
    DffSync_n#(n+digit+1) Data0_o(B,B_i<<1,rst_i,clk_o&~fl_in,B_i);
    DffSync_n#(n+digit+1) Data1_o(A,A_i,rst_i,clk_o,A_i);
    //rst_in
   	dff_n#(1) Rst(fl_in,clk_o,rst);assign rst_in=rst|~fl_in;
   	dff_n#(n+digit+1) Du(A-B_i,clk_o&~fl_in,D_in); 
   	dff_n_data#(n+digit+1,1) Y_int(y_o<<1,fl_in,clk_o&~fl_in,y_o);
//tim so du 
     assign fl_d=(D>=B)?0:1;
     dff_n#(1) Rst_d(fl_d,clk_o&fl_in,rst_d);assign rst_do=rst_d|~fl_d;
	 DffSync_n#(n+digit+1) d(D_in,D-B,rst_in,clk_o&fl_in,D);
	 DffSync_n#(n+digit+1) d(y_o,y_int,rst_in,clk_o&fl_in,y_int);

	



 



