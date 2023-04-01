#define MAX_SIM 1000000
int a;
void set_random(Vtop *dut, vluint64_t sim_unit) {
			dut->data0_i=rand()%255;
	    	if(rand()%2) a=-rand()%256;
			else a=rand()%256;
			dut->data1_i=a;//co the thay bang a bang 1 so nguyen am cu the vd -15,bam may tinh de test
            dut->rst_i=(sim_unit>4&&rand()%100!=0);
    
}
