#define MAX_SIM 1000000

void set_random(Vtop *dut, vluint64_t sim_unit) { 
		for(int i=0;i<10;i++)
		 {
		 	dut-> data_i[i]=rand()%16;
		 }
            dut->rst_i=(sim_unit>4&&rand()%1000!=0);
    
}
