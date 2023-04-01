module  top#(parameter n=32)(m_i,rst_i,clk_i,fl_end,w_o,notuse_o);
input logic[n-1:0] m_i[0:15];
input logic rst_i,clk_i;
output logic[n-1:0] w_o[0:63];
output logic [2:0] notuse_o;
output logic fl_end;
 extend_m#(n)  dut(m_i,rst_i,clk_i,fl_end,w_o,notuse_o);
 endmodule:top
