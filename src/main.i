# 1 "main.c"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "main.c"
# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/inttypes.h" 1 3
# 37 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/inttypes.h" 3
# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/stdint.h" 1 3
# 121 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/stdint.h" 3
typedef int int8_t __attribute__((__mode__(__QI__)));
typedef unsigned int uint8_t __attribute__((__mode__(__QI__)));
typedef int int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int uint16_t __attribute__ ((__mode__ (__HI__)));
typedef int int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int uint32_t __attribute__ ((__mode__ (__SI__)));

typedef int int64_t __attribute__((__mode__(__DI__)));
typedef unsigned int uint64_t __attribute__((__mode__(__DI__)));
# 142 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/stdint.h" 3
typedef int16_t intptr_t;




typedef uint16_t uintptr_t;
# 159 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/stdint.h" 3
typedef int8_t int_least8_t;




typedef uint8_t uint_least8_t;




typedef int16_t int_least16_t;




typedef uint16_t uint_least16_t;




typedef int32_t int_least32_t;




typedef uint32_t uint_least32_t;







typedef int64_t int_least64_t;






typedef uint64_t uint_least64_t;
# 213 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/stdint.h" 3
typedef int8_t int_fast8_t;




typedef uint8_t uint_fast8_t;




typedef int16_t int_fast16_t;




typedef uint16_t uint_fast16_t;




typedef int32_t int_fast32_t;




typedef uint32_t uint_fast32_t;







typedef int64_t int_fast64_t;






typedef uint64_t uint_fast64_t;
# 273 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/stdint.h" 3
typedef int64_t intmax_t;




typedef uint64_t uintmax_t;
# 38 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/inttypes.h" 2 3
# 77 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/inttypes.h" 3
typedef int32_t int_farptr_t;



typedef uint32_t uint_farptr_t;
# 2 "main.c" 2
# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/io.h" 1 3
# 99 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/io.h" 3
# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/sfr_defs.h" 1 3
# 100 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/io.h" 2 3
# 330 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/io.h" 3
# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/iotn44.h" 1 3
# 38 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/iotn44.h" 3
# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/iotnx4.h" 1 3
# 39 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/iotn44.h" 2 3
# 331 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/io.h" 2 3
# 408 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/io.h" 3
# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/portpins.h" 1 3
# 409 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/io.h" 2 3

# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/common.h" 1 3
# 411 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/io.h" 2 3

# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/version.h" 1 3
# 413 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/io.h" 2 3


# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/fuse.h" 1 3
# 239 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/fuse.h" 3
typedef struct
{
    unsigned char low;
    unsigned char high;
    unsigned char extended;
} __fuse_t;
# 416 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/io.h" 2 3


# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/lock.h" 1 3
# 419 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/io.h" 2 3
# 3 "main.c" 2
# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/util/delay.h" 1 3
# 39 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/util/delay.h" 3
# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/util/delay_basic.h" 1 3
# 65 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/util/delay_basic.h" 3
static inline void _delay_loop_1(uint8_t __count) __attribute__((always_inline));
static inline void _delay_loop_2(uint16_t __count) __attribute__((always_inline));
# 80 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/util/delay_basic.h" 3
void
_delay_loop_1(uint8_t __count)
{
 __asm__ volatile (
  "1: dec %0" "\n\t"
  "brne 1b"
  : "=r" (__count)
  : "0" (__count)
 );
}
# 102 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/util/delay_basic.h" 3
void
_delay_loop_2(uint16_t __count)
{
 __asm__ volatile (
  "1: sbiw %0,1" "\n\t"
  "brne 1b"
  : "=w" (__count)
  : "0" (__count)
 );
}
# 40 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/util/delay.h" 2 3
# 79 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/util/delay.h" 3
static inline void _delay_us(double __us) __attribute__((always_inline));
static inline void _delay_ms(double __ms) __attribute__((always_inline));
# 109 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/util/delay.h" 3
void
_delay_ms(double __ms)
{
 uint16_t __ticks;
 double __tmp = ((1000000) / 4e3) * __ms;
 if (__tmp < 1.0)
  __ticks = 1;
 else if (__tmp > 65535)
 {

  __ticks = (uint16_t) (__ms * 10.0);
  while(__ticks)
  {

   _delay_loop_2(((1000000) / 4e3) / 10);
   __ticks --;
  }
  return;
 }
 else
  __ticks = (uint16_t)__tmp;
 _delay_loop_2(__ticks);
}
# 147 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/util/delay.h" 3
void
_delay_us(double __us)
{
 uint8_t __ticks;
 double __tmp = ((1000000) / 3e6) * __us;
 if (__tmp < 1.0)
  __ticks = 1;
 else if (__tmp > 255)
 {
  _delay_ms(__us / 1000.0);
  return;
 }
 else
  __ticks = (uint8_t)__tmp;
 _delay_loop_1(__ticks);
}
# 4 "main.c" 2
# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/interrupt.h" 1 3
# 5 "main.c" 2
# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/wdt.h" 1 3
# 6 "main.c" 2
# 1 "/usr/local/CrossPack-AVR-20100115/lib/gcc/avr/3.4.6/../../../../avr/include/avr/sleep.h" 1 3
# 7 "main.c" 2
# 17 "main.c"
void inline initBuzzer() {
    (*(volatile uint8_t *)((0x30) + 0x20)) = 0;
    (*(volatile uint8_t *)((0x33) + 0x20)) = 0;

    (*(volatile uint8_t *)((0x30) + 0x20)) |= (1 << (5));
    (*(volatile uint8_t *)((0x30) + 0x20)) |= (1 << (0));
    (*(volatile uint8_t *)((0x33) + 0x20)) |= (1 << (0));
}

void inline beep() {
    initBuzzer();
    (*(volatile uint8_t *)((0x3C) + 0x20)) = 8;
    _delay_ms(17);
    (*(volatile uint8_t *)((0x33) + 0x20)) = 0;
    (*(volatile uint8_t *)((0x1B) + 0x20)) &= ~(1 << (7));
}

void inline ledOn() {
  (*(volatile uint8_t *)((0x17) + 0x20)) |= (1 << (1)) | (1 << (0));
  (*(volatile uint8_t *)((0x18) + 0x20)) &= ~(1 << (0));
  (*(volatile uint8_t *)((0x18) + 0x20)) |= (1 << (1));
}

void inline ledOff() {
  (*(volatile uint8_t *)((0x17) + 0x20)) &= ~((1 << (1)) | (1 << (0)));
  (*(volatile uint8_t *)((0x18) + 0x20)) &= ~((1 << (1)) | (1 << (0)));
}

void chirp(uint8_t times) {
    (*(volatile uint8_t *)((0x00) + 0x20)) &= ~(1 << (2));
    while (times-- > 0) {
        beep();
        _delay_ms(20);
    }
    (*(volatile uint8_t *)((0x00) + 0x20)) |= (1 << (2));
}

void inline spiTransfer16(uint16_t data) {
    (*(volatile uint8_t *)((0x00) + 0x20)) &= ~(1 << (1));

    (*(volatile uint8_t *)((0x0F) + 0x20)) = data >> 8;
    uint8_t counter = 8;
    (*(volatile uint8_t *)((0x1B) + 0x20)) &= ~ (1 << (6));
    while(counter-- > 0) {
        (*(volatile uint8_t *)((0x0D) + 0x20)) = (1 << (4)) | (1 << (0));
        (*(volatile uint8_t *)((0x0D) + 0x20)) = (1 << (4)) | (1 << (0)) | (1 << (1));
    }

    (*(volatile uint8_t *)((0x0F) + 0x20)) = data;
    counter = 8;
    while(counter-- > 0) {
        (*(volatile uint8_t *)((0x0D) + 0x20)) = (1 << (4)) | (1 << (0));
        (*(volatile uint8_t *)((0x0D) + 0x20)) = (1 << (4)) | (1 << (0)) | (1 << (1));
    }
    (*(volatile uint8_t *)((0x1B) + 0x20)) |= (1 << (6));
    (*(volatile uint8_t *)((0x00) + 0x20)) |= (1 << (1));
}

void __vector_4 (void) __attribute__ ((signal,used)) ; void __vector_4 (void) {

}

uint16_t referenceCapacitance = 65535;


void inline initWatchdog() {
    (*(volatile uint8_t *)((0x21) + 0x20)) |= (1 << (4));
    (*(volatile uint8_t *)((0x21) + 0x20)) &= ~(1 << (3));
    (*(volatile uint8_t *)((0x21) + 0x20)) |= (1 << (6));
    (*(volatile uint8_t *)((0x21) + 0x20)) |= (1 << (1)) | (1 << (2));
}

void inline setupGPIO() {
    (*(volatile uint8_t *)((0x1B) + 0x20)) |= (1 << (0));
    (*(volatile uint8_t *)((0x1B) + 0x20)) &= ~(1 << (0));
    (*(volatile uint8_t *)((0x1B) + 0x20)) |= (1 << (2));
    (*(volatile uint8_t *)((0x1B) + 0x20)) &= ~(1 << (2));
    (*(volatile uint8_t *)((0x1B) + 0x20)) |= (1 << (3));
    (*(volatile uint8_t *)((0x1B) + 0x20)) &= ~(1 << (3));
    (*(volatile uint8_t *)((0x1A) + 0x20)) |= (1 << (6)) | (1 << (4)) | (1 << (5));
    (*(volatile uint8_t *)((0x1B) + 0x20)) |= (1 << (6));
    (*(volatile uint8_t *)((0x1A) + 0x20)) |= (1 << (7));
    (*(volatile uint8_t *)((0x1B) + 0x20)) &= ~(1 << (7));

    (*(volatile uint8_t *)((0x17) + 0x20)) |= (1 << (0));
    (*(volatile uint8_t *)((0x18) + 0x20)) &= ~(1 << (0));
    (*(volatile uint8_t *)((0x17) + 0x20)) |= (1 << (1));
    (*(volatile uint8_t *)((0x18) + 0x20)) &= ~(1 << (1));
    (*(volatile uint8_t *)((0x17) + 0x20)) |= (1 << (2));
    (*(volatile uint8_t *)((0x18) + 0x20)) &= ~(1 << (2));
}

void inline setupPowerSaving() {
    (*(volatile uint8_t *)((0x01) + 0x20)) |= (1 << (1));
    (*(volatile uint8_t *)((0x00) + 0x20)) |= (1 << (3));
    (*(volatile uint8_t *)((0x00) + 0x20)) |= (1 << (2));
    (*(volatile uint8_t *)((0x06) + 0x20)) &=~ (1 << (7));
    (*(volatile uint8_t *)((0x00) + 0x20)) |= (1 << (0));
    (*(volatile uint8_t *)((0x00) + 0x20)) |= (1 << (1));
}

void inline sleep() {
    do { (*(volatile uint8_t *)((0x35) + 0x20)) = (((*(volatile uint8_t *)((0x35) + 0x20)) & ~((1 << (3)) | (1 << (4)))) | ((1 << (4)))); } while(0);
    do { (*(volatile uint8_t *)((0x35) + 0x20)) |= (uint8_t)(1 << (5)); } while(0);
    (*(volatile uint8_t *)((0x35) + 0x20)) |= (1 << (7)) | (1 << (2));
    (*(volatile uint8_t *)((0x35) + 0x20)) &=~ (1 << (2));
    do { __asm__ __volatile__ ( "sleep" "\n\t" :: ); } while(0);
    do { (*(volatile uint8_t *)((0x35) + 0x20)) &= (uint8_t)(~(1 << (5))); } while(0);
}

void inline sleepWhileADC() {
    do { (*(volatile uint8_t *)((0x35) + 0x20)) = (((*(volatile uint8_t *)((0x35) + 0x20)) & ~((1 << (3)) | (1 << (4)))) | ((1 << (3)))); } while(0);
    do { do { (*(volatile uint8_t *)((0x35) + 0x20)) |= (uint8_t)(1 << (5)); } while(0); do { __asm__ __volatile__ ( "sleep" "\n\t" :: ); } while(0); do { (*(volatile uint8_t *)((0x35) + 0x20)) &= (uint8_t)(~(1 << (5))); } while(0); } while (0);
}

void __vector_13 (void) __attribute__ ((signal,used)) ; void __vector_13 (void) {
}

uint16_t getCapacitance() {
    (*(volatile uint8_t *)((0x06) + 0x20)) |= (1 << (2));
    (*(volatile uint8_t *)((0x06) + 0x20)) |= (1 << (3));
    (*(volatile uint8_t *)((0x07) + 0x20)) |= (1 << (0));

    (*(volatile uint8_t *)((0x06) + 0x20)) |= (1 << (6));

    sleepWhileADC();

    uint16_t result = (*(volatile uint8_t *)((0x04) + 0x20));
    result |= (*(volatile uint8_t *)((0x05) + 0x20)) << 8;

    return 1023 - result;
}

uint16_t getCapacitanceRounded() {
    (*(volatile uint8_t *)((0x26) + 0x20)) = (1 << (7));
    (*(volatile uint8_t *)((0x26) + 0x20)) = (1 << (1));

    (*(volatile uint8_t *)((0x00) + 0x20)) &= ~(1 << (0));
    (*(volatile uint8_t *)((0x06) + 0x20)) |= (1 << (7));

    (*(volatile uint8_t *)((0x00) + 0x20)) &= ~(1 << (2));
    (*(volatile uint8_t *)((0x36) + 0x20)) = 0;
    (*(volatile uint8_t *)((0x30) + 0x20)) = (1 << (6)) |
             (1 << (1));
    (*(volatile uint8_t *)((0x33) + 0x20)) = (1 << (0));


    _delay_ms(1);
    getCapacitance();
    _delay_ms(1000);
    uint16_t result = getCapacitance();

    (*(volatile uint8_t *)((0x33) + 0x20)) = 0;
    (*(volatile uint8_t *)((0x30) + 0x20)) = 0;

    (*(volatile uint8_t *)((0x18) + 0x20)) &= ~(1 << (2));
    (*(volatile uint8_t *)((0x00) + 0x20)) |= (1 << (2));

    (*(volatile uint8_t *)((0x06) + 0x20)) &=~ (1 << (7));
    (*(volatile uint8_t *)((0x00) + 0x20)) |= (1 << (0));

    (*(volatile uint8_t *)((0x26) + 0x20)) = (1 << (7));
    (*(volatile uint8_t *)((0x26) + 0x20)) = (1 << (1)) | (1 << (0));
    return result;
}

volatile uint16_t lightCounter = 0;
volatile uint8_t lightCycleOver = 0;

void __vector_3 (void) __attribute__ ((signal,used)) ; void __vector_3 (void) {
    (*(volatile uint8_t *)((0x2E) + 0x20)) = 0;
    lightCounter = (*(volatile uint16_t *)((0x2C) + 0x20));
    lightCycleOver = 1;
}

void __vector_8 (void) __attribute__ ((signal,used)) ; void __vector_8 (void) {
    lightCounter = 65535;
    lightCycleOver = 1;
}

uint16_t getLight() {
    (*(volatile uint8_t *)((0x00) + 0x20)) &= ~(1 << (3));
    (*(volatile uint8_t *)((0x0C) + 0x20)) |= (1 << (0));

    (*(volatile uint8_t *)((0x17) + 0x20)) |= (1 << (1)) | (1 << (0));
    (*(volatile uint8_t *)((0x18) + 0x20)) &= ~(1 << (0));
    (*(volatile uint8_t *)((0x18) + 0x20)) |= (1 << (1));

    (*(volatile uint8_t *)((0x18) + 0x20)) |= (1 << (0));
    (*(volatile uint8_t *)((0x18) + 0x20)) &= ~(1 << (1));

    (*(volatile uint8_t *)((0x17) + 0x20)) &= ~((1 << (1)) | (1 << (0)));
    (*(volatile uint8_t *)((0x18) + 0x20)) &= ~((1 << (1)) | (1 << (0)));

    (*(volatile uint16_t *)((0x2C) + 0x20)) = 0;
    (*(volatile uint8_t *)((0x2F) + 0x20)) = 0;
    (*(volatile uint8_t *)((0x2E) + 0x20)) = (1 << (0)) | (1 << (1));

    (*(volatile uint8_t *)((0x20) + 0x20)) |= (1 << (0));
    (*(volatile uint8_t *)((0x3B) + 0x20)) |= (1 << (5));
    lightCycleOver = 0;
    while(!lightCycleOver) {
      do { (*(volatile uint8_t *)((0x35) + 0x20)) = (((*(volatile uint8_t *)((0x35) + 0x20)) & ~((1 << (3)) | (1 << (4)))) | (0)); } while(0);
      do { do { (*(volatile uint8_t *)((0x35) + 0x20)) |= (uint8_t)(1 << (5)); } while(0); do { __asm__ __volatile__ ( "sleep" "\n\t" :: ); } while(0); do { (*(volatile uint8_t *)((0x35) + 0x20)) &= (uint8_t)(~(1 << (5))); } while(0); } while (0);
    }

    (*(volatile uint8_t *)((0x2E) + 0x20)) = 0;

    (*(volatile uint8_t *)((0x3B) + 0x20)) &= ~(1 << (5));
    (*(volatile uint8_t *)((0x20) + 0x20)) &= ~(1 << (0));
    (*(volatile uint8_t *)((0x0C) + 0x20)) &= ~(1 << (0));
    (*(volatile uint8_t *)((0x00) + 0x20)) |= (1 << (3));
    return lightCounter;
}




void inline wakeUpInterval8s() {
    (*(volatile uint8_t *)((0x21) + 0x20)) &= ~(1 << (1));
    (*(volatile uint8_t *)((0x21) + 0x20)) &= ~(1 << (2));
    (*(volatile uint8_t *)((0x21) + 0x20)) |= (1 << (5)) | (1 << (0));
}




void inline wakeUpInterval1s() {
    (*(volatile uint8_t *)((0x21) + 0x20)) &= ~(1 << (5));
    (*(volatile uint8_t *)((0x21) + 0x20)) &= ~(1 << (0));
    (*(volatile uint8_t *)((0x21) + 0x20)) |= (1 << (1)) | (1 << (2));
}

void inline chirpIfLight() {
    getLight();
    if(lightCounter < 65530) {
        chirp(3);
    }
}
# 270 "main.c"
int main (void) {
    setupGPIO();
    setupPowerSaving();
    (*(volatile uint8_t *)((0x26) + 0x20)) = (1 << (7));
    (*(volatile uint8_t *)((0x26) + 0x20)) = (1 << (1)) | (1 << (0));
    __asm__ __volatile__ ("sei" ::);

    chirp(2);
    ledOn();
    _delay_ms(10);
    ledOff();
    _delay_ms(100);

    referenceCapacitance = getCapacitanceRounded();
    getLight();
    chirp(2);

    spiTransfer16(0);
    spiTransfer16(0);
    spiTransfer16(referenceCapacitance);
    initWatchdog();

    uint8_t wakeUpCount = 0;
    uint8_t playedHappy = 0;

    uint8_t state = 4;
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

            if (capacitanceDiff < -50 && !playedHappy) {
                chirp(9);
                _delay_ms(350);
                chirp(1);
                _delay_ms(50);
                chirp(1);
                playedHappy = 1;
            }

            if(capacitanceDiff < -20) {
                if(1 != state) {
                    wakeUpInterval8s();
                }
                maxSleepTimes = 20;
                state = 1;
            } else {
                if(capacitanceDiff > -10) {
                    chirpIfLight();
                    playedHappy = 0;
                }
                if(capacitanceDiff < -5 && capacitanceDiff > -10) {
                    if(2 != state) {
                        wakeUpInterval8s();
                    }
                    maxSleepTimes = 10;
                    state = 2;
                } else if(capacitanceDiff < 0 && capacitanceDiff > -5) {
                    if(3 != state) {
                        wakeUpInterval8s();
                    }
                    state = 3;
                    maxSleepTimes = 1;
                } else if(capacitanceDiff >= 0) {
                    if(4 != state) {
                        wakeUpInterval1s();
                    }
                    state = 4;
                    maxSleepTimes = 1;
                }
            }
        }
    }
}
