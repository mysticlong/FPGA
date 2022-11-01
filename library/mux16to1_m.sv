module mux16to1_m(I_i,sel_i,y_o);
	input logic I_i[0:15];
	input logic[3:0] sel_i;
	output logic y_o;
	always_comb begin:proc_mux16to1
		y_o=I_i[sel_i];
		end
endmodule:mux16to1_m
