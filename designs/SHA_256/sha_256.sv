`include "src/designs/SHA_256/computation.sv"
`include "src/designs/SHA_256/extend_m.sv"
`include "src/designs/SHA_256/K.sv"
`include "src/library/add_n_m.sv"
module sha_256#(parameter n=32,m=16)(m_i,rst_i,clk_i,fl_end,hash_o);
input logic [n-1:0] m_i[0:m-1];
input logic rst_i,clk_i;
output logic[255:0] hash_o;
output logic fl_end;
logic[n-1:0] k_i;
//khoi tao hash value
 	logic [n-1:0] h[0:7];
	assign  h[0]=32'h6a09e667;
	assign	h[1]=32'hbb67ae85;
	assign	h[2]=32'h3c6ef372;
	assign	h[3]=32'ha54ff53a;
	assign	h[4]=32'h510e527f;
	assign	h[5]=32'h9b05688c;
	assign	h[6]=32'h1f83d9ab;
	assign	h[7]=32'h5be0cd19;
logic clk_o;
assign clk_o=clk_i&~fl_end;
//mo rong m_i
	logic [n-1:0] w_i[0:m-1];
  	extend_m#(n,m) W_i(m_i,ena_shift,rst_i,clk_o,fl_ext,w_i);
//tao xung cho phep dich
	logic ena_shift;
	logic fl_ext,fl_ext_o;
	dff_n#(1) Fl_o(fl_ext,clk_i,fl_ext_o);
	DffSync_n#(1) Ena_data(0,~fl_ext|fl_ext_o,rst_i,clk_o,ena_shift);
//Ki
	K#(n,64) K(rst_i,~ena_shift,k_i);
//tinh ham hash
	logic[n-1:0] data_o[0:7];
	computation#(n,8) Data_o(h,w_i[0],k_i,rst_i,~ena_shift,data_o);
//gia tri hash
	logic[n-1:0] hash[0:7];
	logic c_o[0:7];
	genvar i;
 	generate //8 bo cong
 	for (i=0;i<8;i++) begin
	add_n#(32) Hash(h[i],data_o[i],clk_i,hash[i],c_o[i]); 
	end
	endgenerate
//not use
	assign notuse=c_o[0]|c_o[1]|c_o[2]|c_o[3]|c_o[4]|c_o[5]|c_o[6]|c_o[7];	
	logic notuse,notuse_o;
	DffSync_n#(1) Notused(notuse,notuse_o,rst_i,clk_i,notuse_o);
//flag end
	logic[5:0] i0;
	DffSync_n#(6) I(0,i0+1,rst_i,~ena_shift&~fl_end,i0);
 	logic	fl_main,fl_main_o;
	assign fl_main=(i0=='1)?1:0;
	dff_n#(1)	Fl_main_o(fl_main,~ena_shift,fl_main_o);
	DffSync_n#(1) Fl_end(0,fl_main_o,rst_i,clk_i,fl_end);
//hash_o
	assign hash_o={hash[0],hash[1],hash[2],hash[3],hash[4],hash[5],hash[6],hash[7]};
endmodule:sha_256
	
