#!/usr/bin/python
import sys

fn = sys.argv[1]
f = open(fn, 'r')

chunk_size = 8
bytes_per_ram = 1

mem_l = []
for i in range(512/chunk_size):
    mem_l.append(open('new_code' + str(i) + '.mem', 'w'))

all_zeros = []
for i in range(32):
    all_zeros.append('00')

lines = f.readlines()
i = 0

while i < len(lines):
    l1 = lines[i]
    if l1.startswith('@'):
        new_l = l1[1:]
        for mem in mem_l:
            mem.write('@' + new_l)
            #mem.write('@' + hex(int(new_l, 16)/64) + '\n')
        i += 1
        continue
    if (l1.startswith('//') or len(l1) < 2):
        i += 1
        continue
    bs1 = l1.strip().rstrip().split(' ')
    if (len(bs1) < 32):
        while (len(bs1) < 32):
            bs1.append('00')
    l2 = lines[i+1]
    if (l2.startswith('//') or l2.startswith('@') or len(l2) < 2):
        bs2 = all_zeros
    else:
        bs2 = l2.strip().rstrip().split(' ')

    if (len(bs2) < 32):
        while (len(bs2) < 32):
            bs2.append('00')
    bs1.extend(bs2)
    for j in range(0, len(bs1), bytes_per_ram):
        new_bs = bs1[j:j+bytes_per_ram]
        new_bs.reverse()
        mem_l[j/bytes_per_ram].write(' '.join(new_bs) + '\n')
    i += 2

f.close()

f = open('append_to_tb.vh', 'w')
for i in range(512/chunk_size):
    f.write('$readmemh("new_code' + str(i) + '.mem", ' +
            'mb_wrapper_tb.mb_wrapper.mb_i.axi_oram_0.inst.fake_mig.synth_dram.RAM_BLOCK[' + str(i) + '].RAM.Mem);\n')
f.close()
