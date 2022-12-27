#define MAX_SIM 1000000

void set_random(Vtop *dut, vluint64_t sim_unit) {
			dut->data0_i=rand()%255;
			dut->data1_i=rand()%255;
            dut->rst_i=(sim_unit>4&&rand()%100!=0);
    
}
