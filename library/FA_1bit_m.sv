module FA_1bit_m#(parameter m=16)(data0_i,data1_i,carry_i,sum_o,carry_o);
	input logic data0_i[0:m-1],data1_i[0:m-1],carry_i[0:m-1];
	output logic sum_o[0:m-1],carry_o[0:m-1];
	int val=m,i=0;
	always_comb begin:ok
	for(i=0;i<val;i++)	begin
			sum_o[i]=((data0_i[i]^data1_i[i])^carry_i[i]);
			carry_o[i] =((data0_i[i]^data1_i[i])&carry_i[i])|(data0_i[i]&data1_i[i]);
   end
 end
	endmodule: FA_1bit_m
