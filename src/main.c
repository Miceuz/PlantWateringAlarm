#include <inttypes.h>
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>
#include <avr/sleep.h>

#define USI_SCK PA4
#define USI_MISO PA5
#define USI_CS PA6
#define BUZZER PA7
#define BUTTON PB2

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

void  chirp(uint8_t times) {
    PRR &= ~_BV(PRTIM0);
    while (times-- > 0) {
        beep();
        _delay_ms(20);
    }
    PRR |= _BV(PRTIM0);
}


void measureCapacitance() {
    PRR |= _BV(PRADC);      //shutdown ADC
}

void inline spiTransfer16(uint16_t data) {
//    PRR &= ~_BV(PRUSI);
    USIDR = data >> 8;
    uint8_t counter = 8;
    PORTA &= ~ _BV(USI_CS);
    while(counter-- > 0) {
        USICR = _BV(USIWM0) | _BV(USITC);
        USICR = _BV(USIWM0) | _BV(USITC) | _BV(USICLK);
    }
    USIDR = data;
    counter = 8;
    while(counter-- > 0) {
        USICR = _BV(USIWM0) | _BV(USITC);
        USICR = _BV(USIWM0) | _BV(USITC) | _BV(USICLK);
    }
    PORTA |= _BV(USI_CS);
//    PRR |= _BV(PRUSI);
}

ISR(WATCHDOG_vect ) {
   // nothing, just wake up
}

uint16_t referenceChargeTime = 65535;


void inline initWatchdog() {
    WDTCSR |= _BV(WDCE); 
    WDTCSR &= ~_BV(WDE); //interrupt on watchdog overflow
    WDTCSR |= _BV(WDIE); //enable interrupt
//    WDTCSR |= _BV(WDP3) | _BV(WDP0); //every 8 sec
    WDTCSR |= _BV(WDP1) | _BV(WDP2); //every 1 sec
}

void inline setupGPIO() {
    PORTA |= _BV(PA0);  //nothing
    PORTA &= ~_BV(PA0);                     
    PORTA |= _BV(PA2);  //nothing
    PORTA &= ~_BV(PA2);                     
    PORTA |= _BV(PA3);  //nothing
    PORTA &= ~_BV(PA3);                     
    DDRA |= _BV(USI_CS) | _BV(USI_SCK) | _BV(USI_MISO); //USI interface
    PORTA |= _BV(USI_CS);  //set USI CS to high
    DDRA |= _BV(BUZZER);   //piezo buzzer
    PORTA &= ~_BV(BUZZER);
    
    DDRB |= _BV(PB0);   //nothing
    PORTB &= ~_BV(PB0);
    DDRB |= _BV(PB1);   //nothing
    PORTB &= ~_BV(PB1);
}

void inline setupPowerSaving() {
    DIDR0 |= _BV(ADC1D);   //disable digital input buffer on AIN0 and AIN1
    //ADCSRA &= ~_BV(ADEN);               //disable ADC
    PRR |= _BV(PRTIM1);                 //disable timer1
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
    ADCSRA |= _BV(ADPS0) | _BV(ADPS1) | _BV(ADPS2); //adc clock speed = sysclk/128
    ADCSRA |= _BV(ADIE);
    ADMUX |= _BV(MUX0); //select ADC1 as input
    
    ADCSRA |= _BV(ADSC); //start conversion
    
    sleepWhileADC();
    
    uint16_t result = ADCL;
    result |= ADCH << 8;
    
    return result;
}

uint16_t getCapacitanceRounded() {
    PRR &= ~_BV(PRADC);  //enable ADC in power reduction
    ADCSRA |= _BV(ADEN);
    _delay_ms(300);

    getCapacitance();
    uint16_t result = getCapacitance();
    
    ADCSRA &=~ _BV(ADEN);
    PRR |= _BV(PRADC);
    return result;
}

#define LED_K PB0 
#define LED_A PB1

volatile uint16_t lightCounter = 0;

ISR(PCINT1_vect) {
    lightCounter = TCNT1;
}

ISR(TIM1_OVF_vect) {
    lightCounter = 65535;
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
    TCCR1B = _BV(CS11) | _BV(CS10); //start timer1 with prescaler clk/8
    
    PCMSK1 |= _BV(PCINT8); //enable pin change interrupt on LED_K
    GIMSK |= _BV(PCIE1); 

    set_sleep_mode(SLEEP_MODE_IDLE);
    sleep_mode();
    
    TCCR1B = 0;
    
    GIMSK &= ~_BV(PCIE1);
    PCMSK1 &= ~_BV(PCINT8);
    TIMSK1 &= ~_BV(TOIE1);    
    PRR |= _BV(PRTIM1);
    return lightCounter;
}

int main (void) {
    CLKPR = _BV(CLKPCE);
    CLKPR = _BV(CLKPS0) | _BV(CLKPS1);
    setupPowerSaving();
    setupGPIO();
    sei();
    
    chirp(2);
    _delay_ms(1000);
    
    referenceChargeTime = getCapacitanceRounded();

    spiTransfer16(0);
    spiTransfer16(0);
    spiTransfer16(referenceChargeTime);
    initWatchdog();

    while(1){
        uint16_t ct = getCapacitanceRounded();
        if(ct > referenceChargeTime) {
            chirp(3);
        }
        spiTransfer16(ct);
        sleep();
        //measureLight();
    }
}
