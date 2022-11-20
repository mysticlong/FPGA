module FA_1bit_m#(m=16)(D0_i,D1_i,carry_i,sum_o,carry_o);
	input logic D0_i[0:m-1],D1_i[0:m-1],carry_i[0:m-1];
	output logic sum_o[0:m-1],carry_o[0:m-1];
initial begin
	    	for(int i=0;i<16;i++) begin
			sum_o[i] =((D0_i[i]^D1_i[i])^carry_i[i]);
			carry_o[i] =((D0_i[i]^D1_i[i])&carry_i[i])|(D0_i[i]&D1_i[i]);
		end
	end
	endmodule: FA_1bit_m
