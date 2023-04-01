#include <stdio.h>
typedef long int uint64_t;
int main() {
 uint64_t a,b,c,d;
a=2040337234;//799d1352
b=741662626;//2C34DFA2	  
c=3726013374;//DE1673BE 	
d=1268212354;//4B976282
//b&d  
//	00101100001101001101111110100010
//	01001011100101110110001010000010
//	00001000000101000100001010000010 
//c&~d
//	11011110000101100111001110111110
//	10110100011010001001110101111101
//	10010100000000000001000100111100  

//b&d|c&~d  
//	00001000000101000100001010000010
//	10010100000000000001000100111100
//	10011100000101000101001110111110 //F(B,C,D)=9c1453be
uint64_t arrb[33],arrc[33],arrd[33],arra[33],arrd_n[33],i; 
void binary(uint64_t n,uint64_t arr[33]){
    for(i=0;i<33;i++)  
    {  
     arr[i]=n%2;  
     n=n/2;  
    }
}
void binary_not(uint64_t b,uint64_t arr[33]){
    for(i=0;i<33;i++)  
    {  
     arr[i]=b%2^1;  
     b=b/2;  
    }
}
 binary(a,arra);
 binary(b,arrb);
 binary(c,arrc);
 binary(d,arrd);
 binary_not(d,arrd_n);
printf("\n ham f ");  
for(i=31;i>=0;i--)  
{  
printf("%d",arrc[i]&arrd_n[i]|arrd[i]&arrb[i]);  
}}
