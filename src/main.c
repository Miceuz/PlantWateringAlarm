#include <inttypes.h>
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>
#include <avr/sleep.h>

void inline initBuzzer() {
//    PRR &= ~_BV(PRTIM1);
    TCCR1A = 0; //reset timer1 configuration
    TCCR1B = 0;

    TCCR1A |= _BV(COM1A1);  //set OC1A to low on compare match
    TCCR1A |= _BV(WGM10);   //PWM, Phase Correct, 8-bit 
    TCCR1B |= _BV(CS11);    //start timer, prescaling clkio/8
//    PRR |= _BV(PRTIM1);
}

void beep() {
    initBuzzer();
    OCR1A = 128;
    _delay_ms(20);
    TCCR1B = 0;    //stop timer
}

void  chirp(uint8_t times) {
    while (times-- > 0) {
        beep();
        _delay_ms(20);
    }
}

void inline initComparator() {
    PRR &= ~_BV(PRADC);                 //start ADC
    ACSR |= _BV(ACIS0) | _BV(ACIS1);    //Comparator Interrupt on Rising Output Edge.
    ACSR &= ~_BV(ACIE);                 //disable comparator interrupt
    ACSR &= ~_BV(ACD);                  //enable comparator
    ACSR |= _BV(ACIE);                  //enable comparator interrupt
}

volatile uint16_t chargeTime = 0;
volatile uint8_t resultReady = 0;

ISR(ANA_COMP_vect) {
    chargeTime = TCNT1;
    ACSR &= ~_BV(ACIE); //disable comparator interrupt as comparator goes crazy when we discharge capacitor
    resultReady = 1;
}

void measureCapacitance() {
    chargeTime = 0;
    
    PORTA &= ~_BV(PA0);     //discharge capacitor
    _delay_ms(10);           //one milisecond should be enough?
    
//    PRR &= ~_BV(PRTIM1);
    TCCR1B = 0;
    TCNT1 = 0;              //set timer to 0
    TCCR1A = 0;             //reset timer1 configuration

    TCCR1B = _BV(CS10);    //start timer, no prescaling
    PORTA |= _BV(PA0);      //start charging capacitor

    initComparator();
        
    resultReady = 0;
    while(!resultReady) {
        //NOTHING 
    }
    ACSR |= _BV(ACD);       //disable comparator
    PORTA &= ~_BV(PA0);     //discharge capacitor
    TCCR1B = 0;             //stop timer
//    PRR |= _BV(PRTIM1);
    PRR |= _BV(PRADC);      //shutdown ADC
}

void inline spiTransfer16(uint16_t data) {
//    PRR &= ~_BV(PRUSI);
    USIDR = data >> 8;
    uint8_t counter = 8;
    PORTA &= ~ _BV(PA3);
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
    PORTA |= _BV(PA3);
//    PRR |= _BV(PRUSI);
}

ISR(WATCHDOG_vect ) {
   // nothing, just wake up
}

uint16_t referenceChargeTime = 65535;


ISR(INT0_vect) {
    GIMSK &=~ _BV(INT0);
    uint8_t t = 10;
    sei();
    measureCapacitance();
    referenceChargeTime = chargeTime;
        
    beep();
    while(0 == PINB & _BV(PB0)) {
        //nothing, wait
    }
    _delay_ms(10);
    GIMSK |= _BV(INT0);
}

void inline initWatchdog() {
    WDTCSR |= _BV(WDCE); 
    WDTCSR &= ~_BV(WDE); //interrupt on watchdog overflow
    WDTCSR |= _BV(WDIE); //enable interrupt
//    WDTCSR |= _BV(WDP3) | _BV(WDP0); //every 8 sec
    WDTCSR |= _BV(WDP1) | _BV(WDP2); //every 1 sec
}

void inline setupGPIO() {
    PORTA |= _BV(PA0);  //V_CHARGE
    PORTA &= ~_BV(PA0);                     
    DDRA |= _BV(PA3) | _BV(PA4) | _BV(PA5); //USI interface
    PORTA |= _BV(PA3);  //set USI CS to high
    DDRA |= _BV(PA6);   //piezo buzzer
    PORTA &= ~_BV(PA6);
    DDRA |= _BV(PA7);   //nothing 
    PORTA &= ~_BV(PA7);
    
    DDRB |= _BV(PB0);   //nothing
    PORTB &= ~_BV(PB0);
    DDRB |= _BV(PB1);   //nothing
    PORTB &= ~_BV(PB1);
    
    PORTB |= _BV(PB2);  //pullup on INT0 pin
    MCUCR |= _BV(ISC01);    
    GIMSK |= _BV(INT0); //enable int0 interrupt
}

void inline setupPowerSaving() {
    DIDR0 |= _BV(ADC1D) | _BV(ADC2D);   //disable digital input buffer on AIN0 and AIN1
    ADCSRA &= ~_BV(ADEN);               //disable ADC
    PRR |= _BV(PRTIM0);                 //disable timer0
}

void inline sleep() {
    set_sleep_mode(SLEEP_MODE_PWR_DOWN);
    sleep_enable();
    MCUCR |= _BV(BODS) | _BV(BODSE);    //disable brownout detection during sleep
    MCUCR &=~ _BV(BODSE);
    sleep_cpu();
    sleep_disable();
}

uint16_t getCapacitanceRounded() {
    uint8_t c = 32;
    uint32_t sum = 0;
    while(c-- > 0) {
        measureCapacitance();
        sum += chargeTime;
    }
    return (uint16_t) (sum >> 5);
}

int main (void) {
    setupPowerSaving();
    setupGPIO();
    sei();
    
    _delay_ms(1000);
    
    referenceChargeTime = getCapacitanceRounded();

    chirp(2);
    spiTransfer16(0);
    spiTransfer16(0);
    spiTransfer16(referenceChargeTime);
    initWatchdog();

    while(1){
        uint16_t ct = getCapacitanceRounded();
        if(ct < 70){//referenceChargeTime) {
            chirp(3);
        }
        //spiTransfer16(referenceChargeTime);
        spiTransfer16(ct);
        sleep();
    }
}
