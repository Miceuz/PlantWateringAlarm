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


//------------ peripherals ----------------

void inline initBuzzer() {
    TCCR0A = 0; //reset timer1 configuration
    TCCR0B = 0;

    TCCR0A |= _BV(COM0B1);  //Clear OC0B on Compare Match when up-counting. Set OC0B on Compare Match when down-counting.
    TCCR0A |= _BV(WGM00);   //PWM, Phase Correct, 8-bit 
    TCCR0B |= _BV(CS00);    //start timer
}

void inline static beep() {
    initBuzzer();
    OCR0B = 48;
    _delay_ms(42);
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

void static chirp(uint8_t times) {
    PRR &= ~_BV(PRTIM0);
    while (times-- > 0) {
        beep();
        _delay_ms(40);
    }
    PRR |= _BV(PRTIM0);
}

//------------------- initialization/setup-------------------

void inline setupGPIO() {
    PORTA |= _BV(PA0);  //nothing
    PORTA &= ~_BV(PA0);                     
    PORTA |= _BV(PA2);  //nothing
    PORTA &= ~_BV(PA2);                     
    PORTA |= _BV(PA3);  //nothing
    PORTA &= ~_BV(PA3);                     
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

//--------------- sleep / wakeup routines --------------

void inline initWatchdog() {
    WDTCSR |= _BV(WDCE);
    WDTCSR &= ~_BV(WDE); //interrupt on watchdog overflow
    WDTCSR |= _BV(WDIE); //enable interrupt
    WDTCSR |= _BV(WDP1) | _BV(WDP2); //every 1 sec
}

ISR(WATCHDOG_vect ) {
   // nothing, just wake up
}

void inline sleep() {
    set_sleep_mode(SLEEP_MODE_PWR_DOWN);
    cli();
    sleep_enable();
    sleep_bod_disable();
    sei();
    sleep_cpu();
    sleep_disable();
}

void inline sleepWhileADC() {
    set_sleep_mode(SLEEP_MODE_ADC);
    sleep_mode();
}

ISR(ADC_vect) { 
	//nothing, just wake up
}

// ------------------ capacitance measurement ------------------

void startExcitationSignal() {
	OCR0A = 0;
	TCCR0A = _BV(COM0A0) |  //Toggle OC0A on Compare Match
			_BV(WGM01);
    TCNT0 = 254;
	TCCR0B = _BV(CS00);
}

void stopExcitationSignal() {
	TCCR0B = 0;
	TCCR0A = 0;
    PORTB &= ~_BV(PB2);
}

uint16_t getADC1() {
    ADCSRA = _BV(ADEN) | _BV(ADPS2); //adc clock speed = sysclk/16
    ADCSRA |= _BV(ADIE);
    ADMUX = _BV(MUX0); //select ADC1 as input
    
    ADCSRA |= _BV(ADSC); //start conversion
    
    // sleepWhileADC();
    loop_until_bit_is_clear(ADCSRA, ADSC);

    uint16_t result = ADC;
    
    return 1023 - result;
}

void adcOn() {
    PRR &= ~_BV(PRADC);  //enable ADC in power reduction
    ADCSRA |= _BV(ADEN);
}

void adcOff() {
    ADCSRA &=~ _BV(ADEN);
    PRR |= _BV(PRADC);
}

uint16_t getRefVoltage() {
    ADCSRA |= _BV(ADPS2); //adc clock speed = sysclk/16
    ADCSRA |= _BV(ADIE);
    ADMUX = 0b00100001; //select 1,1V reference as input
    
    ADCSRA |= _BV(ADSC); //start conversion
    
    sleepWhileADC();
    // loop_until_bit_is_clear(ADCSRA, ADSC);
    
    uint16_t result = ADC;

    return result;//reference * 1023 / result;
}

uint16_t getCapacitance(uint8_t withStabilizeDelay) {    
    PRR &= ~_BV(PRTIM0);
	startExcitationSignal();

    getADC1();
    if(withStabilizeDelay) {
        _delay_ms(1000);
    }
    uint16_t result = getADC1();
    
    stopExcitationSignal();
    PORTB &= ~_BV(PB2);
    PRR |= _BV(PRTIM0);

    return result;
}

//--------------------- light measurement --------------------

volatile uint16_t lightCounter = 0;
volatile uint8_t lightCycleOver = 0;

ISR(PCINT1_vect) {
    GIMSK &= ~_BV(PCIE1);//disable pin change interrupts
    TCCR1B = 0;			 //stop timer
    lightCounter = TCNT1;
    lightCycleOver = 1;
}

ISR(TIM1_OVF_vect) {
    lightCounter = 65535;
    lightCycleOver = 1;
}

uint16_t getLight() {
    PRR &= ~_BV(PRTIM1);
    TIMSK1 |= _BV(TOIE1); 				//enable timer overflow interrupt
    
    DDRB |= _BV(LED_A) | _BV(LED_K); 	//forward bias the LED
    PORTB &= ~_BV(LED_K);            	//flash it to discharge the PN junction capacitance
    PORTB |= _BV(LED_A);

    PORTB |= _BV(LED_K);            	//reverse bias LED to charge capacitance in it
    PORTB &= ~_BV(LED_A);
    
    DDRB &= ~_BV(LED_K);                //make Cathode input
    PORTB &= ~(_BV(LED_A) | _BV(LED_K));//disable pullups
    
    TCNT1 = 0;
    TCCR1A = 0;
    TCCR1B = _BV(CS12);					//start timer1 with prescaler clk/256
    
    PCMSK1 |= _BV(PCINT8); 				//enable pin change interrupt on LED_K
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

// ----------------- sensor mode loop hack ---------------------

static inline void loopSensorMode() {
    PRR &= ~_BV(PRADC);  //enable ADC in power reduction
    ADCSRA = _BV(ADEN) | _BV(ADPS2);
    ADMUX |= _BV(MUX0); //select ADC1 as input
    PRR &= ~_BV(PRTIM0);

	startExcitationSignal();
	_delay_ms(500);
	uint16_t currCapacitance = 0;
	uint16_t light = 0;

	while(1) {
	    if(usiTwiDataInReceiveBuffer()) {
			uint8_t usiRx = usiTwiReceiveByte();
			if(0 == usiRx) {
				ledOn();
				currCapacitance = getCapacitance(false);
			    usiTwiTransmitByte(currCapacitance >> 8);
				usiTwiTransmitByte(currCapacitance &0x00FF);
				ledOff();
			} else if(0x01 == usiRx) {
				uint8_t newAddress = usiTwiReceiveByte();
				if(newAddress > 0 && newAddress < 255) {
					eeprom_write_byte((uint8_t*)0x01, newAddress);
				}
			} else if(0x02 == usiRx) {
				uint8_t newAddress = eeprom_read_byte((uint8_t*) 0x01);
				usiTwiTransmitByte(newAddress);
			} else if(0x03 == usiRx) {
				light = getLight();
			} else if(0x04 == usiRx) {
				usiTwiTransmitByte(light >> 8);
				usiTwiTransmitByte(light & 0x00FF);
			} else {
//				while(usiTwiDataInReceiveBuffer()) {
//					usiTwiReceiveByte();//clean up the receive buffer
//				}
			}
		}
	}
}

// --------------- chirp FSM states and utilities-----------------
#define STATE_INITIAL 0
#define STATE_HIBERNATE 1
#define STATE_ALERT 2
#define STATE_VERY_ALERT 3
#define STATE_PANIC 4
#define STATE_MEASURE 5

#define SLEEP_TIMES_HIBERNATE 450
#define SLEEP_TIMES_ALERT 37
#define SLEEP_TIMES_VERY_ALERT 2
#define SLEEP_TIMES_PANIC 1

#define MODE_SENSOR 0
#define MODE_CHIRP 1

uint8_t mode;
uint8_t sleepSeconds = 0;
uint32_t secondsAfterWatering = 0;
uint16_t maxSleepTimes = 0;

/**
 * Sets wake up interval to 8s
 **/
static inline void wakeUpInterval8s() {
    WDTCSR &= ~_BV(WDP1);
    WDTCSR &= ~_BV(WDP2);
    WDTCSR |= _BV(WDP3) | _BV(WDP0); //every 8 sec
    sleepSeconds = 8;
}

/**
 * Sets wake up interval to 1s
 **/
static inline void wakeUpInterval1s() {
    WDTCSR &= ~_BV(WDP3);
    WDTCSR &= ~_BV(WDP0);
    WDTCSR |= _BV(WDP1) | _BV(WDP2); //every 1 sec
    sleepSeconds = 1;
}

uint16_t lightThreshold = 65530;

inline static void chirpIfLight() {
    getLight();
    if(lightCounter < lightThreshold) {
        chirp(3);
    } else {
        ledOn();
        _delay_ms(10);
        ledOff();
    }
}

static inline uint8_t isLightNotCalibrated() {
    return 65535 == lightThreshold;
}

//-----------------------------------------------------------------

#include "dbg_putchar.h"

uint16_t battFullLSB = 0;
uint16_t refVoltageLSB = 0;

static inline uint8_t isBatteryEmpty(){
    return refVoltageLSB > battFullLSB && (refVoltageLSB - battFullLSB) > 61;
}

static inline uint8_t isBatteryLow(){
    return refVoltageLSB > battFullLSB && (refVoltageLSB - battFullLSB) > 5;
}

static inline void blinkToSelfdestruct(){
    wakeUpInterval1s();
    initWatchdog();
    maxSleepTimes = 1;
    while(1) {
        ledOn();
        sleep();
        ledOff();
        sleep();
    }
}

static inline void calibrateRefVoltage() {
    _delay_ms(1000); //allow battery voltage to stabilize
    battFullLSB = getRefVoltage();//discard the first reading
    _delay_ms(1000);
    battFullLSB = getRefVoltage();
    ledOff();
    cli();
    eeprom_write_word((uint16_t*)0x04, battFullLSB);
    sei();
}

static inline void calibrateLight() {
    lightThreshold = lightCounter - lightCounter / 10;
    eeprom_write_word((uint16_t*)0x02, lightThreshold);
    chirp(1);
    _delay_ms(300);
}

static inline void sleepTimes(uint16_t times) {
    uint8_t wakeUpCount = 0;
    while (wakeUpCount < times) {
        sleep();
        wakeUpCount++;
    }
}

static inline void playHappy() {
    chirp(9);
    _delay_ms(350);
    chirp(1);
    _delay_ms(50);
    chirp(1);
}

uint8_t playedHappy = 0;
uint8_t state = STATE_INITIAL;
int16_t capacitanceDiff = 0;
uint16_t currCapacitance = 0;
uint16_t lastCapacitance = 0;


static inline void enterHibernate() {
    wakeUpInterval8s();
    maxSleepTimes = SLEEP_TIMES_HIBERNATE;
    state = STATE_HIBERNATE;
}

int main (void) {
	setupGPIO();

    cli();
	uint8_t address = eeprom_read_byte((uint8_t*)0x01);
    lightThreshold = eeprom_read_word((uint16_t*)0x02);
    battFullLSB = eeprom_read_word((uint16_t*) 0x04);  

    if(0 == address || 255 == address) {
    	address = 0x20;
    }

    usiTwiSlaveInit(address);

    sei();

    CLKPR = _BV(CLKPCE);
    CLKPR = _BV(CLKPS1); //clock speed = clk/4 = 2Mhz

    ledOn();

    adcOn();
    if(65535 == battFullLSB) {
        calibrateRefVoltage();
    } else {
        getRefVoltage(); //allow battery voltage to stabilize
        _delay_ms(1000);
    }
   
    refVoltageLSB = getRefVoltage();
    adcOff();

    if(isBatteryEmpty()) {
        blinkToSelfdestruct();
    }

    chirp(2);    
    ledOff();
    _delay_ms(500);

    getLight();
    if(isLightNotCalibrated()) {
        calibrateLight();
    }
    chirp(2);

    if(usiTwiDataInReceiveBuffer()){
		loopSensorMode();
	}

    USICR = 0;

    setupPowerSaving();
    initWatchdog();

    dbg_tx_init();

    uint16_t referenceCapacitance = 0;

    dbg_putchar(referenceCapacitance >> 8);
    dbg_putchar(referenceCapacitance & 0x00FF);

    while(1) {

        sleepTimes(maxSleepTimes);

    	lastCapacitance = currCapacitance;

    	adcOn();
    	refVoltageLSB = getRefVoltage();
    	currCapacitance = getCapacitance(isBatteryLow());
    	adcOff();

    	if(0 == referenceCapacitance) {
        	referenceCapacitance = currCapacitance;
    	}
    
    	capacitanceDiff = (int16_t)currCapacitance - (int16_t)referenceCapacitance;

    	dbg_putchar(referenceCapacitance >> 8);
    	dbg_putchar(referenceCapacitance & 0x00FF);

    	dbg_putchar(currCapacitance >> 8);
    	dbg_putchar(currCapacitance & 0x00FF);

    	dbg_putchar(refVoltageLSB >> 8);
    	dbg_putchar(refVoltageLSB & 0x00FF);

        dbg_putchar(state);

        switch(state) {
            case STATE_INITIAL:
                wakeUpInterval1s();
                state = STATE_PANIC;
                maxSleepTimes = SLEEP_TIMES_PANIC;
            break;
            case STATE_PANIC:
                if (capacitanceDiff > 10) {
                    playHappy();
                    enterHibernate();
                } else if(capacitanceDiff > 2) {
                    wakeUpInterval8s();
                    state = STATE_VERY_ALERT;
                    maxSleepTimes = SLEEP_TIMES_VERY_ALERT;
                }
            break;
            case STATE_VERY_ALERT:
                if (capacitanceDiff > 10) {
                    playHappy();
                    enterHibernate();
                } else if(capacitanceDiff <= 2) {
                    wakeUpInterval1s();
                    state = STATE_PANIC;
                    maxSleepTimes = SLEEP_TIMES_PANIC;
                } else if(capacitanceDiff > 5) {
                    wakeUpInterval8s();
                    maxSleepTimes = SLEEP_TIMES_ALERT;
                    state = STATE_ALERT;
                }
            break;
            case STATE_ALERT:
                if(capacitanceDiff > 20) {
                    playHappy();
                }

                if(capacitanceDiff <=5) {
                    wakeUpInterval8s();
                    state = STATE_VERY_ALERT;
                    maxSleepTimes = SLEEP_TIMES_VERY_ALERT;
                } else if(capacitanceDiff > 10) {
                    enterHibernate();
                }
            break;
            case STATE_HIBERNATE:
                if(capacitanceDiff <= 10) {
                    wakeUpInterval8s();
                    maxSleepTimes = SLEEP_TIMES_ALERT;
                    state = STATE_ALERT;
                }
            break;
        }

        if(state != STATE_HIBERNATE) {
            chirpIfLight();
        }

    		          
    	// if(capacitanceDiff > 10) {
    	// 	if (!playedHappy) {
     //            playHappy();
     //            playedHappy = 1;
    	// 	}
    	// 	if(STATE_HIBERNATE != state) {
    	// 	    wakeUpInterval8s();
     //            maxSleepTimes = SLEEP_TIMES_HIBERNATE;
     //            state = STATE_HIBERNATE;
    	// 	}
    	// } else {
    	// 	if(capacitanceDiff <= 10) {
    	// 	    chirpIfLight();
    	// 	    playedHappy = 0;
    	// 	}


    	// 	if(capacitanceDiff >=5  && capacitanceDiff < 10) {
    	// 	    if(STATE_ALERT != state) {
     //    			wakeUpInterval8s();
     //                maxSleepTimes = SLEEP_TIMES_ALERT;
     //                state = STATE_ALERT;
    	// 	    }
    	// 	} else if(capacitanceDiff > 2 && capacitanceDiff < 5) {
    	// 	    if(STATE_VERY_ALERT != state) {
     //                wakeUpInterval8s();
     //                state = STATE_VERY_ALERT;
     //                maxSleepTimes = SLEEP_TIMES_VERY_ALERT;
    	// 	    }
    	// 	} else if(capacitanceDiff <= 2) {
    	// 	    if(STATE_PANIC != state) {
     //                wakeUpInterval1s();
     //                state = STATE_PANIC;
     //                maxSleepTimes = SLEEP_TIMES_PANIC;
    	// 	    }
    	// 	}
    	// }
    }
}
