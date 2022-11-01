#define MAX_SIM 5000

void set_random(Vtop *dut, vluint64_t sim_unit) {
 int i=0;
  for(i=0;i<16;i++){
   	 dut->data_i[i]=rand()%2;}
    dut->rst_i=(sim_unit>4&&rand()%48!=0);
}
