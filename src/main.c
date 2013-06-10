#include <inttypes.h>
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>
#include <avr/sleep.h>
#include <avr/eeprom.h>
#include "usiTwiSlave.h"

#define USI_SCK PA4
#define USI_MISO PA5
#define USI_CS PA6
#define BUZZER PA7
#define BUTTON PB2
#define LED_K PB0 
#define LED_A PB1


void inline initBuzzer() {
    TCCR0A = 0; //reset timer1 configuration
    TCCR0B = 0;

    TCCR0A |= _BV(COM0B1);  //Clear OC0B on Compare Match when up-counting. Set OC0B on Compare Match when down-counting.
    TCCR0A |= _BV(WGM00);   //PWM, Phase Correct, 8-bit 
    TCCR0B |= _BV(CS00);    //start timer
}

void inline beep() {
    initBuzzer();
    OCR0B = 8;
    _delay_ms(17);
    TCCR0B = 0;    //stop timer
    PORTA &= ~_BV(BUZZER);
}

void inline ledOn() {
  DDRB |= _BV(LED_A) | _BV(LED_K); //forward bias the LED
  PORTB &= ~_BV(LED_K);            //flash it to discharge the PN junction capacitance
  PORTB |= _BV(LED_A);  
}

void inline ledOff() {
  DDRB &= ~(_BV(LED_A) | _BV(LED_K)); //make pins inputs
  PORTB &= ~(_BV(LED_A) | _BV(LED_K));//disable pullups
}

void  chirp(uint8_t times) {
    PRR &= ~_BV(PRTIM0);
    while (times-- > 0) {
        beep();
        _delay_ms(20);
    }
    PRR |= _BV(PRTIM0);
}

ISR(WATCHDOG_vect ) {
   // nothing, just wake up
}

uint16_t referenceCapacitance = 65535;


void inline initWatchdog() {
    WDTCSR |= _BV(WDCE); 
    WDTCSR &= ~_BV(WDE); //interrupt on watchdog overflow
    WDTCSR |= _BV(WDIE); //enable interrupt
    WDTCSR |= _BV(WDP1) | _BV(WDP2); //every 1 sec
}

void inline setupGPIO() {
    PORTA |= _BV(PA0);  //nothing
    PORTA &= ~_BV(PA0);                     
    PORTA |= _BV(PA2);  //nothing
    PORTA &= ~_BV(PA2);                     
    PORTA |= _BV(PA3);  //nothing
    PORTA &= ~_BV(PA3);                     
    //DDRA |= _BV(USI_CS) | _BV(USI_SCK) | _BV(USI_MISO); //USI interface
    //PORTA |= _BV(USI_CS);  //set USI CS to high
    DDRA |= _BV(BUZZER);   //piezo buzzer
    PORTA &= ~_BV(BUZZER);
    
    DDRB |= _BV(PB0);   //nothing
    PORTB &= ~_BV(PB0);
    DDRB |= _BV(PB1);   //nothing
    PORTB &= ~_BV(PB1);
    DDRB |= _BV(PB2);   //sqare wave output
    PORTB &= ~_BV(PB2);
}

void inline setupPowerSaving() {
    DIDR0 |= _BV(ADC1D);   //disable digital input buffer on AIN0 and AIN1
    PRR |= _BV(PRTIM1);                 //disable timer1
    PRR |= _BV(PRTIM0);                 //disable timer0
    ADCSRA &=~ _BV(ADEN);
    PRR |= _BV(PRADC);
    PRR |= _BV(PRUSI);
}

void inline sleep() {
    set_sleep_mode(SLEEP_MODE_PWR_DOWN);
    sleep_enable();
    MCUCR |= _BV(BODS) | _BV(BODSE);    //disable brownout detection during sleep
    MCUCR &=~ _BV(BODSE);
    sleep_cpu();
    sleep_disable();
}

void inline sleepWhileADC() {
    set_sleep_mode(SLEEP_MODE_ADC);
    sleep_mode();
}

ISR(ADC_vect) { 
}

uint16_t getCapacitance() {
    ADCSRA |= _BV(ADPS2); //adc clock speed = sysclk/16
    ADCSRA |= _BV(ADIE);
    ADMUX |= _BV(MUX0); //select ADC1 as input
    
    ADCSRA |= _BV(ADSC); //start conversion
    
    sleepWhileADC();
    
    uint16_t result = ADCL;
    result |= ADCH << 8;
    
    return 1023 - result;
}

void startExcitationSignal() {
	OCR0A = 0;
	TCCR0A = _BV(COM0A0) |  //Toggle OC0A on Compare Match
			_BV(WGM01);
	TCCR0B = _BV(CS00);
}

void stopExcitationSignal() {
	TCCR0B = 0;
	TCCR0A = 0;
}

uint16_t getCapacitanceRounded() {
    CLKPR = _BV(CLKPCE);
    CLKPR = _BV(CLKPS1); //clock speed = clk/4 = 2Mhz

    PRR &= ~_BV(PRADC);  //enable ADC in power reduction
    ADCSRA |= _BV(ADEN);
    
    PRR &= ~_BV(PRTIM0);
	startExcitationSignal();
//    DDRB |= _BV(PB2);

    _delay_ms(1);
    getCapacitance();
    _delay_ms(1000);
    uint16_t result = getCapacitance();
    
    stopExcitationSignal();
    PORTB &= ~_BV(PB2);
    PRR |= _BV(PRTIM0);
    
    ADCSRA &=~ _BV(ADEN);
    PRR |= _BV(PRADC);

    CLKPR = _BV(CLKPCE);
    CLKPR = _BV(CLKPS1) | _BV(CLKPS0);
    return result;
}

volatile uint16_t lightCounter = 0;
volatile uint8_t lightCycleOver = 0;

ISR(PCINT1_vect) {
    TCCR1B = 0;
    lightCounter = TCNT1;
    lightCycleOver = 1;
}

ISR(TIM1_OVF_vect) {
    lightCounter = 65535;
    lightCycleOver = 1;
}

uint16_t getLight() {
    PRR &= ~_BV(PRTIM1);
    TIMSK1 |= _BV(TOIE1); //enable timer overflow interrupt
    
    DDRB |= _BV(LED_A) | _BV(LED_K); //forward bias the LED
    PORTB &= ~_BV(LED_K);            //flash it to discharge the PN junction capacitance
    PORTB |= _BV(LED_A);
    
    PORTB |= _BV(LED_K);            //reverse bias LED to charge capacitance in it
    PORTB &= ~_BV(LED_A);
    
    DDRB &= ~(_BV(LED_A) | _BV(LED_K)); //make pins inputs
    PORTB &= ~(_BV(LED_A) | _BV(LED_K));//disable pullups
    
    TCNT1 = 0;
    TCCR1A = 0;
    TCCR1B = _BV(CS10) | _BV(CS11); //start timer1 with prescaler clk/8
    
    PCMSK1 |= _BV(PCINT8); //enable pin change interrupt on LED_K
    GIMSK |= _BV(PCIE1); 
    lightCycleOver = 0;
    while(!lightCycleOver) {
      set_sleep_mode(SLEEP_MODE_IDLE);
      sleep_mode();
    }
    
    TCCR1B = 0;
    
    GIMSK &= ~_BV(PCIE1);
    PCMSK1 &= ~_BV(PCINT8);
    TIMSK1 &= ~_BV(TOIE1);    
    PRR |= _BV(PRTIM1);
    return lightCounter;
}

/**
 * Sets wake up interval to 8s
 **/
void inline wakeUpInterval8s() {
    WDTCSR &= ~_BV(WDP1);
    WDTCSR &= ~_BV(WDP2);
    WDTCSR |= _BV(WDP3) | _BV(WDP0); //every 8 sec
}

/**
 * Sets wake up interval to 1s
 **/
void inline wakeUpInterval1s() {
    WDTCSR &= ~_BV(WDP3);
    WDTCSR &= ~_BV(WDP0);
    WDTCSR |= _BV(WDP1) | _BV(WDP2); //every 1 sec
}

void inline chirpIfLight() {
    getLight();
    if(lightCounter < 65530) {
        chirp(3);
    }
}

#define STATE_INITIAL 0
#define STATE_HIBERNATE 1
#define STATE_ALERT 2
#define STATE_VERY_ALERT 3
#define STATE_PANIC 4
#define STATE_MEASURE 5

#define SLEEP_TIMES_HIBERNATE 225
#define SLEEP_TIMES_ALERT 37
#define SLEEP_TIMES_VERY_ALERT 1
#define SLEEP_TIMES_PANIC 1

#define MODE_SENSOR 0
#define MODE_CHIRP 1

uint8_t mode;

inline void loopSensorMode() {
    PRR &= ~_BV(PRADC);  //enable ADC in power reduction
    ADCSRA |= _BV(ADEN);
    PRR &= ~_BV(PRTIM0);

    CLKPR = _BV(CLKPCE);
	CLKPR = _BV(CLKPS1); //clock speed = clk/4 = 2Mhz
	startExcitationSignal();
	_delay_ms(500);

	while(1) {
		if(usiTwiDataInReceiveBuffer()) {
			ledOn();
			uint8_t usiRx = usiTwiReceiveByte();
			while(usiTwiDataInReceiveBuffer()) {
				usiTwiReceiveByte();//clean up the receive buffer
			}
			if(0 == usiRx) {
				uint16_t currCapacitance = getCapacitance();
				usiTwiTransmitByte(currCapacitance >> 8);
				usiTwiTransmitByte(currCapacitance &0x00FF);
			}
			ledOff();
		}
	}
}

int main (void) {
    setupGPIO();
    sei();
	usiTwiSlaveInit(0x20);
    CLKPR = _BV(CLKPCE);
    CLKPR = _BV(CLKPS1) | _BV(CLKPS0); //clock speed = clk/8 = 1Mhz
    sei();
    
    chirp(2);
    ledOn();
    _delay_ms(10);
    ledOff();
    _delay_ms(100);

    referenceCapacitance = getCapacitanceRounded();
    getLight();
    chirp(2);

    if(usiTwiDataInReceiveBuffer()){
		loopSensorMode();
	}

    setupPowerSaving();

    initWatchdog();

    uint8_t wakeUpCount = 0;
    uint8_t playedHappy = 0;
    
    uint8_t state = STATE_PANIC;
    int16_t capacitanceDiff = 0;
    uint8_t maxSleepTimes = 0;

    while(1) {
        if(wakeUpCount < maxSleepTimes) {
            sleep();
            wakeUpCount++;
        } else {
            wakeUpCount = 0;
            
            uint16_t currCapacitance = getCapacitanceRounded();
            capacitanceDiff = referenceCapacitance - currCapacitance;
            spiTransfer16(currCapacitance);
            
            if (capacitanceDiff < -20 && !playedHappy) {
                chirp(9);
                _delay_ms(350);
                chirp(1);
                _delay_ms(50);
                chirp(1);
                playedHappy = 1;
            }
                        
            if(capacitanceDiff <= -50) {
                if(STATE_HIBERNATE != state) {
                    wakeUpInterval8s();
                }
                maxSleepTimes = SLEEP_TIMES_HIBERNATE;
                state = STATE_HIBERNATE;
            } else {
                if(capacitanceDiff > -50) {
                    chirpIfLight();
                    playedHappy = 0;
                }
                if(capacitanceDiff < -20 && capacitanceDiff > -50) {
                    if(STATE_ALERT != state) {
                        wakeUpInterval8s();
                    }
                    maxSleepTimes = SLEEP_TIMES_ALERT;
                    state = STATE_ALERT;
                } else if(capacitanceDiff < -5 && capacitanceDiff > -20) {
                    if(STATE_VERY_ALERT != state) {
                        wakeUpInterval8s();
                    }
                    state = STATE_VERY_ALERT;
                    maxSleepTimes = SLEEP_TIMES_VERY_ALERT;
                } else if(capacitanceDiff >= -5) {
                    if(STATE_PANIC != state) {
                        wakeUpInterval1s();
                    }
                    state = STATE_PANIC;
                    maxSleepTimes = SLEEP_TIMES_PANIC;
                }
            }
        }
    }
}
