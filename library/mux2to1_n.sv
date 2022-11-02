module mux2to1_n #(parameter n=4)(w0_i,w1_i,sel_i,y_o);
	input logic[n-1:0] w0_i,w1_i;
	input logic sel_i;
	output logic[n-1:0] y_o;
	always_comb begin:proc_mux2_4bit
		y_o=(sel_i)?w1_i:w0_i;
	end
endmodule: mux2to1_n
