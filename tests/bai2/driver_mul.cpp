#define MAX_SIM 5000

void set_random(Vtop *dut, vluint64_t sim_unit) {
 int i=0;
  int   arr[16]={0,0,1,0,0,1,1,1,0,0,0,1,0,0,0,0};
  for(i=0;i<16;i++){
   	 dut->data0_i[i]=rand()%2;
   	 dut->data1_i[i]=arr[15-i];}
    dut->rst_i=(sim_unit>4&&rand()%48!=0);
}
