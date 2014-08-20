#!/usr/bin/python
import os
import sys
import re
from collections import defaultdict

asm = open(sys.argv[1], 'r')
lines = asm.readlines()

mem = defaultdict(list)

for l in lines:
    g = re.match("([0-9A-Fa-f]+):\s+([0-9A-Fa-f]+).*", l)
    if not g:
        continue
    if g.group(1)[0] == '8':
        mem[(int(g.group(1),16) & 0x7FFFFFFF) >> 5].append(int(g.group(2), 16))

tty = os.open('/dev/ttyUSB1', os.O_RDWR)
#tty = open('tmp.bin', 'w')
cmd = 0;

#TODO: make sure the 8 words end up in the correct half
for m in mem:
    print hex(m)
    while len(mem[m]) < 8:
        mem[m].append(0)
    if m % 1 == 0:
        while len(mem[m]) < 16:
            mem[m].append(0, 0)
    else:
        while len(mem[m]) < 16:
            mem[m].insert(0,0)
    mem[m].reverse()
    a = map(chr, (map(lambda x: (m >> (x*8)) & 0xFF, range(4))).reverse())
    addr = ''.join(a)
    tty.write(chr(cmd))
    tty.write(addr)
    for d in mem[m]:
        for i in range(4):
            tty.write(chr((d >> ((3-i)*8)) & 0xFF))

