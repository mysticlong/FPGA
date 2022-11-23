module top(M_i,rst_i,clk_i,rst_o,fl_o,fl1,hash_o,A1,B1,C1,D1,A2,B2,C2,D2,A3,B3,C3,D3,A4,B4,C4,D4,M_io);
input logic [31:0] M_i;
input logic rst_i,clk_i;
output logic fl_o,rst_o,fl1;
output logic [31:0] M_io[0:15];
output logic [127:0] hash_o;
output	logic[31:0] A1,B1,C1,D1,A2,B2,C2,D2,A3,B3,C3,D3,A4,B4,C4,D4;

 md5  dut(M_i,rst_i,clk_i,rst_o,fl_o,fl1,hash_o,A1,B1,C1,D1,A2,B2,C2,D2,A3,B3,C3,D3,A4,B4,C4,D4,M_io);
endmodule:top
