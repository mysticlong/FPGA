#define MAX_SIM 1000000
                     int x=2;


void set_random(Vtop *dut, vluint64_t sim_unit) {
                     int *ptr=&x;
        		    *ptr= (sim_unit%16)?*ptr:rand();	
        		        dut->wr_i=x;
        	            dut->rst_i=(!(sim_unit%500))?0:1;
        	            dut->clk_wr=(sim_unit%8)?0:1;     	            
}
