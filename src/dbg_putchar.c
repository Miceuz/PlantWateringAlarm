/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42, by Joerg Wunsch):
 * <dinuxbg .at. gmail.com> wrote this file.  As long as you retain this notice
 * you can do whatever you want with this stuff. If we meet some day, and you 
 * think this stuff is worth it, you can buy me a beer in return.
 *                                                             Dimitar Dimitrov
 * ----------------------------------------------------------------------------
 */

#include <stdint.h>
#include <avr/io.h>
#include <avr/interrupt.h>

#include "dbg_putchar.h"

#if DBG_UART_ENABLE

void dbg_puts(char *s) {
	while(s && *s) {
		dbg_putchar(*s++);
	}
}
void dbg_putint(uint16_t i) {
	if( i < 10) {
		dbg_putchar('0' + i);
	} else {
		dbg_putint(i/10);
		dbg_putchar('0' + i % 10);
	}
	// do {
	// 	dbg_putchar('0' + i % 10);
	// 	i = i / 10;
	// } while(i != 0);
}

void dbg_putchar(uint8_t c)
{
#define DBG_UART_TX_NUM_DELAY_CYCLES	((F_CPU/DBG_UART_BAUDRATE-16)/4+1)
#define DBG_UART_TX_NUM_ADD_NOP		((F_CPU/DBG_UART_BAUDRATE-16)%4)
	uint8_t sreg;
	uint16_t tmp;
	uint8_t numiter = 10;

	sreg = SREG;
	cli();

	asm volatile (
		/* put the START bit */
		"in %A0, %3"		"\n\t"	/* 1 */
		"cbr %A0, %4"		"\n\t"	/* 1 */
		"out %3, %A0"		"\n\t"	/* 1 */
		/* compensate for the delay induced by the loop for the
		 * other bits */
		"nop"			"\n\t"	/* 1 */
		"nop"			"\n\t"	/* 1 */
		"nop"			"\n\t"	/* 1 */
		"nop"			"\n\t"	/* 1 */
		"nop"			"\n\t"	/* 1 */

		/* delay */
	   "1:" "ldi %A0, lo8(%5)"	"\n\t"	/* 1 */
		"ldi %B0, hi8(%5)"	"\n\t"	/* 1 */
	   "2:" "sbiw %A0, 1"		"\n\t"	/* 2 */
		"brne 2b"		"\n\t"	/* 1 if EQ, 2 if NEQ */
#if DBG_UART_TX_NUM_ADD_NOP > 0
		"nop"			"\n\t"	/* 1 */
  #if DBG_UART_TX_NUM_ADD_NOP > 1
		"nop"			"\n\t"	/* 1 */
    #if DBG_UART_TX_NUM_ADD_NOP > 2
		"nop"			"\n\t"	/* 1 */
    #endif
  #endif
#endif
		/* put data or stop bit */
		"in %A0, %3"		"\n\t"	/* 1 */
		"sbrc %1, 0"		"\n\t"	/* 1 if false,2 otherwise */
		"sbr %A0, %4"		"\n\t"	/* 1 */
		"sbrs %1, 0"		"\n\t"	/* 1 if false,2 otherwise */
		"cbr %A0, %4"		"\n\t"	/* 1 */
		"out %3, %A0"		"\n\t"	/* 1 */

		/* shift data, putting a stop bit at the empty location */
		"sec"			"\n\t"	/* 1 */
		"ror %1"		"\n\t"	/* 1 */

		/* loop 10 times */
		"dec %2"		"\n\t"	/* 1 */
		"brne 1b"		"\n\t"	/* 1 if EQ, 2 if NEQ */
		: "=&w" (tmp),			/* scratch register */
		  "=r" (c),			/* we modify the data byte */
		  "=r" (numiter)		/* we modify number of iter.*/
		: "I" (_SFR_IO_ADDR(DBG_UART_TX_PORT)),
		  "M" (1<<DBG_UART_TX_PIN),
		  "i" (DBG_UART_TX_NUM_DELAY_CYCLES),
		  "1" (c),			/* data */
		  "2" (numiter)
	);
	SREG = sreg;
}
#undef DBG_UART_TX_NUM_DELAY_CYCLES
#undef DBG_UART_TX_NUM_ADD_NOP

#endif

