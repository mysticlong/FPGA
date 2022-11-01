module log2_x_16bit(data_i,rst_i,clk_i,Ynguyen_o,Ythapphan_o);
input logic data_i[0:15];
input logic rst_i,clk_i;
output logic[15:0] Ynguyen_o,Ythapphan_o;
//logic  [15:0]data_io;
//assign data_io={data_i[15],data_i[14],data_i[13],data_i[12],data_i[11],data_i[10],data_i[9],data_i[8],data_i[7],data_i[6],data_i[5],data_i[4],data_i[3],data_i[2],data_i[1],data_i[0]};
logic data_io[0:15];
endmodule: log2_x_16bit

