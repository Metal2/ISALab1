#include <stdio.h>
#include <stdlib.h>
#include "fir.h"

// coefficients of the FIR filter
const int bi[NC]={-1,-2,-4,8,35,50,35,8,-4,-2,-1};

// 8bit IN, 8 bit OUT filter
int fir(int x)
{
    	static int dbuffer[NC]; // internal shift register, there are 10 registers  
  	static int reset_buffer=0;   // register reset
	int i; //  index
	int y; // output sample
	
	int tmp;
	int tmp2;


	// inizializing the buffer
	if(reset_buffer==0)
	{
		reset_buffer=1;
		for(i=0;i<NC;i++)
		{
			dbuffer[i]=0;
		}
	}

	// insert new samples and process them
	// shift the previous samples
	for(i=NC-1;i>0;i--)
	{
		dbuffer[i]=dbuffer[i-1];
	}

	// store the new sample
	dbuffer[0]=x;
	y=0;
	
	tmp2 = 0;
	for(i=0;i<NC;i++)
	{
		tmp = dbuffer[i]*bi[i];	
		tmp = tmp >> (NB - 1); //16 bit to 9 bit
		tmp2+= tmp;	
	}
	y = tmp2 >> 1; //9 bit to 8 bit
return y;
}

