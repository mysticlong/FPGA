/*#define MAX_SIM 1000000
//sha-256

void set_random(Vtop *dut, vluint64_t sim_unit) {
        			for(int i=0;i<16;i++){
        			if(i==0) dut->m_i[i]=rand(); 
        			else if(i==15) dut->m_i[i]=16;
        			else dut->m_i[i]=0;	
        				}
        	            dut->rst_i=(sim_unit>4&&rand()%1000!=0);
}
/*/
/*
//UARTs
#include <cstdlib> // for rand() function
#define MAX_SIM 1000000

int w = 0, r = 1;
int* ptr_w = &w;
int* ptr_r = &r;
void set_random(Vtop* dut, vluint64_t sim_unit) {
 if((sim_unit%60000)<20000){
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
/*
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
/*/
//mining
#include <stdio.h>
#include <string.h>

#define MAX_SIM 100000000

int counter = 0;
int value = 1;
int position = 0;
//char arr[81] = {"eb94f2c7d51e989940129ab5f49ffff001d3ae24b1822515151651561516516515545465ghjh25gh"};
char hex_arr[]={"01000000c39aa0fa65b6c0f6bdae75dd5fe2b934d155235c01f0b6c1b55c664fe98ee8d33af57b65c7f5d74df2b944195d266450dc2309cc190e2dbc00000000f6eaa79f06f42942085a5d5b00000001"}; // chuỗi kí	 tự cần chuyển sang hex
char hex[3]; // biến lưu giá trị hex tạm thời

// chuyển từng bit theo chuẩn UART 10bit
void set_random(Vtop* dut, vluint64_t sim_unit) {
    if (sim_unit < 20000 || position > 79) {
        value = 1;
        if ((dut->fl_end) == 0) position = 0;
    } else if (sim_unit % 434 == 0 && sim_unit > 434 * 2) {
        if (counter == 0) {
            value = 0; // bit start UART
        } else if (counter == 9) {
            value = 1; // bit stop UART
            position++;
        } else {
            int bit_index =8-counter; // vị trí bit cần gửi
            if (position >= 80) {
                value = 1; // đã gửi hết dữ liệu
            } else {
                // chuyển kí tự thành hex và gán bit tương ứng vào value
              //  sprintf(hex, "%02x", arr[79 - position]);
      				  strncpy(hex,&hex_arr[158-position*2], 2);
                int hex_val = hex[bit_index / 4] - (hex[bit_index / 4] >= 'a' ? 'a' - 10 : '0'); // lấy giá trị hex từ kí tự hex tương ứng
                value = (hex_val >> (3-bit_index % 4)) & 1; // lấy bit tương ứng từ giá trị hex
            }
        }
        counter = (counter + 1) % 10;
    }
    dut->Rx_i = value;
    dut->rst_i = (sim_unit % 1000 == 0) ? 0 : 1;
}
/*
#define MAX_SIM 5000000

int counter = 0;
int value = 1;
int position = 0;

void set_random(Vtop* dut, vluint64_t sim_unit) {

	
	dut->rst_i = (sim_unit % 1000 == 0) ? 0 : 1;
}
*/
