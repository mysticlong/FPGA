#define MAX_SIM 1000000


void set_random(Vtop *dut, vluint64_t sim_unit) {
        			for(int i=0;i<16;i++){
        			if(i==0) dut->m_i[i]=1937768448; 
        			else if(i==15) dut->m_i[i]=8;
        			else dut->m_i[i]=0;	
        				}
        	            dut->rst_i=(sim_unit>4&&rand()%1000!=0);
}
