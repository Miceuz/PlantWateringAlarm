#!/usr/bin/python
import sys

f = open(sys.argv[1])
lines = f.readlines()
wordCount = 0;
print 'PROGMEM const unsigned int firmware[] = {'
for line in lines:
    line = line[9:-4]
    while line != '':
        print '0x' + line[2:4] + line[0:2] + ',',
        line = line[4:]
        wordCount += 1
    print ''
print '};'
print '#define FIRMWARE_WORD_COUNT ', wordCount
