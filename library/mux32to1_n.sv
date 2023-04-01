module mux32to1_n
  #(parameter DATA_WIDTH = 32)
  (input logic [DATA_WIDTH-1:0] data_in [31:0],
   input logic [4:0] sel,
   output logic [DATA_WIDTH-1:0] data_out);

  always_comb begin
    case (sel)
      5'b00000: data_out = data_in[0];
      5'b00001: data_out = data_in[1];
      5'b00010: data_out = data_in[2];
      5'b00011: data_out = data_in[3];
      5'b00100: data_out = data_in[4];
      5'b00101: data_out = data_in[5];
      5'b00110: data_out = data_in[6];
      5'b00111: data_out = data_in[7];
      5'b01000: data_out = data_in[8];
      5'b01001: data_out = data_in[9];
      5'b01010: data_out = data_in[10];
      5'b01011: data_out = data_in[11];
      5'b01100: data_out = data_in[12];
      5'b01101: data_out = data_in[13];
      5'b01110: data_out = data_in[14];
      5'b01111: data_out = data_in[15];
      5'b10000: data_out = data_in[16];
      5'b10001: data_out = data_in[17];
      5'b10010: data_out = data_in[18];
      5'b10011: data_out = data_in[19];
      5'b10100: data_out = data_in[20];
      5'b10101: data_out = data_in[21];
      5'b10110: data_out = data_in[22];
      5'b10111: data_out = data_in[23];
      5'b11000: data_out = data_in[24];
      5'b11001: data_out = data_in[25];
      5'b11010: data_out = data_in[26];
      5'b11011: data_out = data_in[27];
      5'b11100: data_out = data_in[28];
      5'b11101: data_out = data_in[29];
      5'b11110: data_out = data_in[30];
      5'b11111: data_out = data_in[31];
      default: data_out = 'bx; //unknown output
    endcase
  end
endmodule
