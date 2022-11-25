#define MAX_SIM 1000000

void set_random(Vtop *dut, vluint64_t sim_unit) {
   	 dut->data0_i=rand()%65535;
  //q	 dut->index_i=14;
  	// dut->data1_i=rand()%65535;  
    dut->rst_i=(sim_unit>4&&rand()%120!=0);
}
