module mux2to1_n_m#(parameter b=4,m=10)(d0_i,d1_i,sel_i,y_o);
 input logic [b-1:0] d0_i[0:m-1],d1_i[0:m-1];
 input logic sel_i;
 output logic [b-1:0] y_o[0:m-1];
 	 assign	y_o=(sel_i)?d1_i:d0_i;
endmodule:mux2to1_n_m
