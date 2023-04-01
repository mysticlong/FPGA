`include "src/library/dff_n_data.sv"
`include "src/library/DffSync_n_m.sv"
`include "src/library/DffSync_n_data.sv"
module FindMinIndex1_n#(parameter n=4,m=10)(data_i,rst_i,clk_i,fl_end,min1_o,min2_o,index_o,i,data_in);
input logic[n-1:0] data_i[0:9];
input logic rst_i,clk_i;
output logic fl_end;
output logic[n-1:0] min1_o,min2_o;
output logic [3:0] index_o,data_in;
//so sanh data_in voi min2,tiep tuc so sanh min2 voi min1
//fl_end 
	logic fl_main;
	assign fl_main=(i==(m-1))?1:0;
	dff_n_data#(1,0) Fl_end(fl_main,rst_i,clk_i,fl_end);
//index
output logic[3:0] i;
	dff_n_data#(4,0) I(i+1,rst_i,clk_i&~fl_end,i);
//dong bo ngo vao
	logic[n-1:0] data_o[0:m-1],data_shift[0:m-1]; assign data_in=data_o[0];
	assign data_shift[0:m-2]=data_o[1:m-1],data_shift[m-1]=data_o[0];
	DffSync_n_m#(n,m) Data_o(data_i,data_shift,rst_i,clk_i&~fl_end,data_o);
//executive
	logic fl1,fl2; 
	assign fl1=(data_o[0]<min2_o)?1:0;
	assign fl2=(min2_o<min1_o)?1:0;
	//min2_o
	logic [n-1:0] m2_o;
	mux2to1_n#(n) M2_o(min2_o,min1_o,fl2,m2_o);
	DffSync_n_data#(n,15) M2(m2_o,data_o[0],fl1,rst_i,clk_i,min2_o);
	//min1_o		  
	DffSync_n_data#(n,15) M1(min1_o,min2_o,fl2,rst_i,clk_i,min1_o);	
	//index	  
	logic [3:0] index1;
	DffSync_n_data#(4,15) Index1(index1,i,fl1,rst_i,clk_i,index1);
	DffSync_n_data#(4,15) Index_o(index_o,index1,fl2,rst_i,clk_i,index_o);

endmodule: FindMinIndex1_n
	
	
