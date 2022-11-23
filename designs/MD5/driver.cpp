#define MAX_SIM 1000000

void set_random(Vtop *dut, vluint64_t sim_unit) { 
		 	 dut->M_i=1416127865;  
             dut->rst_i=(sim_unit>4&&rand()%1000!=0);
    
}
