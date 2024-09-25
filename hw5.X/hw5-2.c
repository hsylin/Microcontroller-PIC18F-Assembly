#include <xc.h>

extern unsigned int divide_signed(unsigned char a,unsigned char b);

void main(void) {
    
    volatile unsigned int res = divide_signed (20,4);
    volatile char quotient = res >> 8;
    volatile char remainder = res;
    while(1)
        ;
    return;
}