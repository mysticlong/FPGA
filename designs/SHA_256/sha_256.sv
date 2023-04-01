`include "src/designs/SHA_256/computation.sv"
`include "src/designs/SHA_256/extend_m.sv"
`include "src/designs/SHA_256/K.sv"
`include "src/library/add_n_m.sv"
`include "src/library/mux2to1_n.sv"
//`include "src/library/dff_n.sv"
module sha_256#(parameter n=32,m=16,mode=0)(m_i,h_i,rst_i,clk_i,fl_end,hash_out);
input logic [n-1:0] m_i[0:m-1];
input logic rst_i,clk_i;
input logic [255:0] h_i;
output logic[255:0] hash_out;
output logic fl_end;

//khoi tao hash value
	logic [n-1:0] h[0:7],hash_i_arr[0:7];
	assign  h[0]=32'h6a09e667;
	assign	h[1]=32'hbb67ae85;
	assign	h[2]=32'h3c6ef372;
	assign	h[3]=32'ha54ff53a;
	assign	h[4]=32'h510e527f;
	assign	h[5]=32'h9b05688c;
	assign	h[6]=32'h1f83d9ab;
	assign	h[7]=32'h5be0cd19; 
//tao arr h_i
		always_comb begin:proc
		notuse=0;
		for(int i=0;i<8;i++) begin
			notuse|=c_o0[i];
		end
			 hash_i_arr[7]=h_i[31:0];
		 	 hash_i_arr[6]=h_i[63:32];
		 	 hash_i_arr[5]=h_i[95:64];
			 hash_i_arr[4]=h_i[127:96];
			 hash_i_arr[3]=h_i[159:128];
			 hash_i_arr[2]=h_i[191:160];
			 hash_i_arr[1]=h_i[223:192];
			 hash_i_arr[0]=h_i[255:224];
		end
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
	logic[n-1:0] k_i;
	K#(n,64) K(rst_i,~ena_shift,k_i);
//tinh ham hash
	logic[n-1:0] data_o[0:7],data_i[0:7];
	assign data_i=(mode==1)?hash_i_arr:h;
	computation#(n,8) Data_o(data_i,w_i[0],k_i,rst_i,~ena_shift,data_o);
//gia tri hash
	logic[n-1:0] hash_second[0:7];
	logic c_o0[0:7];
	genvar i;
 	generate //8 bo cong
 	for (i=0;i<8;i++) begin
	add_n#(32) Hash((mode==1)?hash_i_arr[i]:h[i],data_o[i],clk_i,hash_second[i],c_o0[i]); 
	end
	endgenerate
//not use
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
		logic[255:0] hash_o;
		dff_n#(256) Hash(hash_o,fl_main_o,hash_out);
	//	assign hash_m={hash_main[7],hash_main[6],hash_main[5],hash_main[4],hash_main[3],hash_main[2],hash_main[1],hash_main[0]};
		assign hash_o={hash_second[0],hash_second[1],hash_second[2],hash_second[3],hash_second[4],hash_second[5],hash_second[6],hash_second[7]};
endmodule:sha_256
	
