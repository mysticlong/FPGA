module dff_n_m_data#(parameter n=4,m=16,value=0)(In_i,rst_i,clk_i,In_o);
	input logic [n-1:0] In_i[0:m];
	input logic	rst_i,clk_i;
	output logic [n-1:0] In_o[0:m];
	 logic[n-1:0] Val[0:m];
	 int i=0;
	 always_comb begin:ok
	 for(i=0;i<=m;i++)  Val[i]=value;
	 end
	always_ff@(posedge clk_i or negedge rst_i) begin
	if(!rst_i) 
		In_o <= Val;
	else
		In_o <= In_i;
	end
endmodule:dff_n_m_data
