#define MAX_SIM 1000000


void set_random(Vtop *dut, vluint64_t sim_unit) {
        			for(int i=0;i<16;i++){
        			if(i==0) dut->m_i[i]=rand(); 
        			else if(i==1) dut->m_i[i]=128;
        			else dut->m_i[i]=0;	
        				}
        	            dut->rst_i=(sim_unit>4&&rand()%1000!=0);
}
