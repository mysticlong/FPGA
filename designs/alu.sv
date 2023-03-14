module alu(                //dont use <,>,-
	input logic clk_i,
	input logic [4:0]openrand_a_i,
	input logic [4:0]openrand_b_i,
	input logic [3:0]alu_op_i,
	output logic [4:0]alu_data_o,
	output logic carry_o	
);
logic [4:0]temp;
logic [1:0]abc;
assign temp = ~openrand_b_i +1;
always @(posedge clk_i) begin
  abc <= {openrand_a_i[4],openrand_b_i[4]};
  carry_o <= 0;
  case (alu_op_i)
    4'b0001: {carry_o, alu_data_o} <= openrand_b_i + openrand_a_i;  		//add
    4'b0010: {carry_o, alu_data_o} <= openrand_a_i + temp  ; 			   //sub
    4'b0011: begin case(abc)															//stl
							  2'b00: begin {carry_o, alu_data_o} <= openrand_a_i + temp ;  	//a,b positive
											alu_data_o <= {4'b0,~carry_o};      						//if carry = 0 => a<b => output = 1 = carry'
									end 
						     2'b11: begin {carry_o, alu_data_o} <= openrand_a_i + temp ;  	//a,b negative
											alu_data_o <= {4'b0,~carry_o};      						//if carry = 0 => a>b => output = 0 = carry
									end 
							  default: begin carry_o <= (openrand_a_i[4] & ~openrand_b_i[4]); //carry = 1 when a=1(negative),b=0(positive)
						                    alu_data_o <= {4'b0, carry_o};
										  end
						 endcase
				 end
	 4'b0100: begin {carry_o, alu_data_o} <= openrand_a_i + temp;  	//sltu
                   alu_data_o <= {4'b0,~carry_o};      					//if carry = 0 => a<b => output = 1 = carry'
             end 
    4'b0101: alu_data_o <= openrand_a_i ^ openrand_b_i;					//xor
    4'b0110: alu_data_o <= openrand_a_i | openrand_b_i;					//or
    4'b0111: alu_data_o <= openrand_a_i & openrand_b_i;					//and
    4'b1000: alu_data_o <= openrand_a_i << openrand_b_i[1:0];			//dich trai
    4'b1001: alu_data_o <= openrand_a_i >> openrand_b_i[1:0];			//dich phai ko dau
    4'b1010: alu_data_o <= openrand_a_i >>> openrand_b_i[1:0];			//dich phai co dau
    default: alu_data_o <= 0;
endcase
end
endmodule
    
