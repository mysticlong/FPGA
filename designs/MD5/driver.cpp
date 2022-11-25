#define MAX_SIM 1000000

void set_random(Vtop *dut, vluint64_t sim_unit) { 
int arr[15]={1416127865,543257189,543450484,1701997929,1852404596,1768128512,0,0,0,0,0,0,0,0,0};
int *ptr=arr;
		for(int i=0;i<15;i++){
			dut->M_i[i]=*ptr; 
			ptr++;
			}
            dut->rst_i=(sim_unit>4&&rand()%1000!=0);
    
}
