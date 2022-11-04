module mux2to1_n_m#(parameter b=4,m=10)(data0_i,data1_i,sel_i,data_o);
 input logic [b-1:0] data0_i[0:m-1],data1_i[0:m-1];
 input logic sel_i;
 output logic [b-1:0] data_o[0:m-1];
 	 assign	data_o=(sel_i)?data1_i:data0_i;
endmodule:mux2to1_n_m
