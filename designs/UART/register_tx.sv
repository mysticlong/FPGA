/*`include "src/library/DffSync_n_m.sv"
`include "src/library/DffSync_n_data.sv"
`include "src/library/dff_n_data.sv"
`include "src/library/dff_n.sv"
`include "src/library/mux2to1_n.sv"*/
module register_tx#(parameter n=10)(data_i,ena_tx,rst_i,clk_baud,clk_i,clk_reg,data_o,fl_end);
input logic[7:0] data_i;
input logic rst_i,clk_i,clk_baud,ena_tx;
output logic data_o,clk_reg;
logic data_io[0:n-1];
	always_comb begin:proc
		if(ena_tx) begin
			data_io[0]=0;
			for(int a=1;a<n-1;a++) begin
				data_io[a]=data_i[a-1];
			end
			data_io[n-1]=1;
		end
		else begin
				for(int x=0;x<n-1;x++) begin
				data_io[x]=1;
			end
		end
	end
//fl_end
output	logic fl_end;
	assign fl_end=ena_tx_d|ena_tx_o;
//ena_Tx
	logic ena_tx_o,rst_I,ena_tx_d;
	dff_n_data#(1,0) Ena_Tx(ena_tx,rst_i|fl_end,clk_reg,ena_tx_o);
	dff_n#(1) Ena_Txd(ena_tx,clk_i,ena_tx_d);
	assign rst_I=~ena_tx|ena_tx_d;
//truyen noi tiep 10 bit	
	logic d_i[0:n-1];
	logic d_o[0:n-1];
	logic [3:0] i;
	DffSync_n_data#(4,0) I(i+1,0,clk_reg,rst_I&rst_reg,clk_baud,i);
//Reg Tx
	logic rst_reg;
	assign clk_reg=(i==n)?1:0;
	//reset
	dff_n#(1) Rst_reg(~clk_reg,clk_i,rst_reg);
	//Register
	assign	d_i[0:n-2]=d_o[1:n-1],d_i[n-1]=1,data_o=d_o[0];
	DffSync_n_m#(1,n) register(data_io,d_i,rst_reg&rst_I,clk_baud|~fl_end,d_o); 
endmodule:register_tx
