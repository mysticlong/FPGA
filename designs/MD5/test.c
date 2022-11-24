#include <stdio.h>
typedef long int uint64_t;
int main() {
 uint64_t a,b,c,d;
a=2040337234;//799d1352
b=741662626;//2C34DFA2	  
c=3726013374;//DE1673BE 	
d=1268212354;//4B976282
uint64_t arrb[33],arrc[33],arrd[33],arra[33],arrd_b[33],i; 
void binary(uint64_t n,uint64_t arr[33]){
    for(i=0;i<33;i++)  
    {  
     arr[i]=n%2;  
     n=n/2;  
    }
}
void binary_bu(uint64_t b,uint64_t arr[33]){
    for(i=0;b>0;i++)  
    {  
     arr[i]=b%2^1;  
     b=b/2;  
    }
}
 binary(a,arra);
 binary(b,arrb);
 binary(c,arrc);
 binary(d,arrd);
 binary_bu(d,arrd_b);
printf("\n ham f ");  
for(i=i-1;i>=0;i--)  
{  
printf("%d",arrc[i]&arrd_b[i]|arrd[i]&arrb[i]); 
//printf("%d",i); 
}}
