#include <cstdlib> // for rand() function
#define MAX_SIM 1000000

int w = 0, r = 1;
int* ptr_w = &w;
int* ptr_r = &r;
void set_random(Vtop* dut, vluint64_t sim_unit) {
 if((sim_unit%40000)<10000){
 	*ptr_w =0;
    *ptr_r =1;
 	
 }
    else if((sim_unit % 434 == 0) && (sim_unit > 436)){
     
        if (*ptr_w == 0) {
            *ptr_r = 0;
        } else if (*ptr_w == 9) {
            *ptr_r = 1;
        } else {
            *ptr_r = rand() % 2;
        }
        *ptr_w = (*ptr_w + 1) % 10;
    }
	dut->clk_rd_i=sim_unit%2;
	dut->clk_wr_i=sim_unit%2;
    dut->Rx_i = r;
    dut->ena_wr_i = (!(sim_unit%20000)) ? rand()%2 : dut->ena_wr_i;
    dut->wr_i = rand() % 256;
 //   dut->rst_i = (sim_unit % 1000 == 0) ? 0 : 1;
}
/*/
//Async_FIFO
#define MAX_SIM 10000
int w = 0, r = 1;
int *ptr_w = &w;
int *ptr_r = &r;

void set_random(Vtop *dut, vluint64_t sim_unit) {
    if (!(sim_unit%150)) {
        *ptr_r =!r;
    } else {
        *ptr_r = *ptr_r;
    }
	*ptr_r=(!(sim_unit%15))?rand()%2:*ptr_r;
//	*ptr_w=(!(sim_unit%15))?rand()%2:*ptr_w;
    dut->ena_wr = r;
    dut->ena_rd = !r;
    dut->clk_wr =sim_unit%2;
    dut->clk_rd = !(sim_unit % 8) ? 1 : 0;
    dut->wr_i = rand() % 256;
    dut->rst_i = !((sim_unit - 4) % 500) ? 0 : 1;
}
//*/
