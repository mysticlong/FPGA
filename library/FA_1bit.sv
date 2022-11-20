module FA_1bit(D0_i,D1_i,carry_i,sum_o,carry_o);
	input logic D0_i,D1_i,carry_i;
	output logic sum_o,carry_o;
	always_comb begin:proc_FA_1bit		
			sum_o = (D0_i^D1_i)^carry_i;
			carry_o = ((D0_i^D1_i)&carry_i)|(D0_i&D1_i);
			end
	endmodule: FA_1bit
