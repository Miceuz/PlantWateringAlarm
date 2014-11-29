/*-----------------------------------------------------*\
|  USI I2C Slave Master                                 |
|                                                       |
| This library provides a robust I2C master protocol    |
| implementation on top of Atmel's Universal Serial     |
| Interface (USI) found in many ATTiny microcontrollers.|
|                                                       |
| Adam Honse (GitHub: CalcProgrammer1) - 7/29/2012      |
|            -calcprogrammer1@gmail.com                 |
\*-----------------------------------------------------*/

#include "usi_i2c_master.h"
#include <avr/interrupt.h>
///////////////////////////////////////////////////////////////////////////////
////USI Master Macros//////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

#define USISR_TRANSFER_8_BIT 		0b11110000 | (0x00<<USICNT0)
#define USISR_TRANSFER_1_BIT 		0b11110000 | (0x0E<<USICNT0)

#define USICR_CLOCK_STROBE_MASK		0b00101011

#define USI_CLOCK_STROBE()			{ USICR = USICR_CLOCK_STROBE_MASK; }

#define USI_SET_SDA_OUTPUT()		{ DDR_USI |=  (1 << PORT_USI_SDA); }
#define USI_SET_SDA_INPUT() 		{ DDR_USI &= ~(1 << PORT_USI_SDA); }

#define USI_SET_SDA_HIGH()			{ PORT_USI |=  (1 << PORT_USI_SDA); }
#define USI_SET_SDA_LOW()			{ PORT_USI &= ~(1 << PORT_USI_SDA); }

#define USI_SET_SCL_OUTPUT()		{ DDR_USI |=  (1 << PORT_USI_SCL); }
#define USI_SET_SCL_INPUT() 		{ DDR_USI &= ~(1 << PORT_USI_SCL); }

#define USI_SET_SCL_HIGH()			{ PORT_USI |=  (1 << PORT_USI_SCL); }
#define USI_SET_SCL_LOW()			{ PORT_USI &= ~(1 << PORT_USI_SCL); }

#define USI_I2C_WAIT_HIGH()			{ _delay_us(I2C_THIGH); }
#define USI_I2C_WAIT_LOW()			{ _delay_us(I2C_TLOW);  }

extern void ledOn();
extern void ledOff();


///////////////////////////////////////////////////////////////////////////////
////USI Master State Information///////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

enum
{
	USI_MASTER_ADDRESS,
	USI_MASTER_WRITE,
	USI_MASTER_READ
} USI_I2C_Master_State;

/////////////////////////////////////////////////////////////////////
// USI_I2C_Master_Transfer                                         //
//  Transfers either 8 bits (data) or 1 bit (ACK/NACK) on the bus. //
/////////////////////////////////////////////////////////////////////

unsigned char USI_I2C_Master_Transfer(unsigned char USISR_temp)
{
	USISR = USISR_temp;								//Set USISR as requested by calling function

	// Shift Data
	do
	{
		USI_I2C_WAIT_LOW();
		USI_CLOCK_STROBE();								//SCL Positive Edge

                ledOn();
		while (!(PIN_USI&(1<<PIN_USI_SCL)));		//Wait for SCL to go high
                ledOff();

		USI_I2C_WAIT_HIGH();
		USI_CLOCK_STROBE();								//SCL Negative Edge
		//while ((PIN_USI&(1<<PIN_USI_SCL)));		//Wait for SCL to go low
	} while (!(USISR&(1<<USIOIF)));					//Do until transfer is complete

	USI_I2C_WAIT_LOW();
	return USIDR;
}

char USI_I2C_Master_Start_Transmission(unsigned char *msg, unsigned char msg_size)
{
	USI_I2C_Master_State = USI_MASTER_ADDRESS;

	/////////////////////////////////////////////////////////////////
	//  Generate Start Condition                                   //
	/////////////////////////////////////////////////////////////////

	USI_SET_SCL_HIGH(); 						//Setting input makes line pull high

	while (!(PIN_USI & (1<<PIN_USI_SCL)));		//Wait for SCL to go high
	#ifdef I2C_FAST_MODE
		USI_I2C_WAIT_HIGH();
	#else
		USI_I2C_WAIT_LOW();
	#endif
	USI_SET_SDA_OUTPUT();
	USI_SET_SCL_OUTPUT();
	USI_SET_SDA_LOW();
	USI_I2C_WAIT_HIGH();
	USI_SET_SCL_LOW();
	USI_I2C_WAIT_LOW();
	USI_SET_SDA_HIGH();
	
	/////////////////////////////////////////////////////////////////

	do
	{
		switch(USI_I2C_Master_State)
		{
			///////////////////////////////////////////////////////////////////
			// Address Operation                                             //
			//  Performs an address/RW write, checks for ACK, and proceeds to//
			//  read or write state as determined by the R/W bit.            //
			///////////////////////////////////////////////////////////////////
			case USI_MASTER_ADDRESS:

				//Check if the message is a write operation or a read operation
				if(!(*msg & 0x01))
				{
					USI_I2C_Master_State = USI_MASTER_WRITE;
				}
				else
				{
					USI_I2C_Master_State = USI_MASTER_READ;
				}
				//Fall through to WRITE to transmit the address byte

			///////////////////////////////////////////////////////////////////
			// Write Operation                                               //
			//  Writes a byte to the slave and checks for ACK                //
			//  If no ACK, then reset and exit                               //
			///////////////////////////////////////////////////////////////////
			case USI_MASTER_WRITE:

				USI_SET_SCL_LOW();

				USIDR = *(msg);				//Load data
			
				msg++;						//Increment buffer pointer

				USI_I2C_Master_Transfer(USISR_TRANSFER_8_BIT);

				USI_SET_SDA_INPUT();

				if(USI_I2C_Master_Transfer(USISR_TRANSFER_1_BIT) & 0x01)
				{
					USI_SET_SCL_HIGH();
					USI_SET_SDA_HIGH();
					return 0;
				}

				USI_SET_SDA_OUTPUT();
				break;

			///////////////////////////////////////////////////////////////////
			// Read Operation                                                //
			//  Reads a byte from the slave and sends ACK or NACK            //
			///////////////////////////////////////////////////////////////////
			case USI_MASTER_READ:

				USI_SET_SDA_INPUT();

                                (*msg) = USI_I2C_Master_Transfer(USISR_TRANSFER_8_BIT);;

				msg++;

				USI_SET_SDA_OUTPUT();
				
				if(msg_size == 1)
				{
					USIDR = 0xFF;			//Load NACK to end transmission
				}
				else
				{
					USIDR = 0x00;			//Load ACK
				}

				USI_I2C_Master_Transfer(USISR_TRANSFER_1_BIT);
				break;
		}

	}while(--msg_size);			//Do until all data is read/written

	
	/////////////////////////////////////////////////////////////////
	// Send Stop Condition                                         //
	/////////////////////////////////////////////////////////////////

	USI_SET_SDA_LOW();           				// Pull SDA low.
	USI_I2C_WAIT_LOW();
	USI_SET_SCL_INPUT();            				// Release SCL.
	while( !(PIN_USI & (1<<PIN_USI_SCL)) );  	// Wait for SCL to go high.  
	USI_I2C_WAIT_HIGH();
	USI_SET_SDA_INPUT();            				// Release SDA.
	while( !(PIN_USI & (1<<PIN_USI_SDA)) );  	// Wait for SDA to go high. 

	return 1;
}
