
/home/kwonal/hello_simple.elf:     file format elf32-microblazeel


Disassembly of section .vectors.reset:

00000000 <_start>:
* None.
*
****************************************************************************/
void microblaze_register_handler(XInterruptHandler Handler, void *DataPtr)
{
   MB_InterruptVectorTable.Handler = Handler;
   0:	b0008000 	imm	-32768
   4:	b8080000 	brai	0

Disassembly of section .vectors.sw_exception:

00000008 <_vector_sw_exception>:
   8:	b0008000 	imm	-32768
   MB_InterruptVectorTable.CallBackRef = DataPtr;
}
   c:	b8080250 	brai	592

Disassembly of section .vectors.interrupt:

00000010 <_vector_interrupt>:
  10:	b0008000 	imm	-32768
u8 XUartLite_RecvByte(u32 BaseAddress)
{
	while (XUartLite_IsReceiveEmpty(BaseAddress));

	return (u8)XUartLite_ReadReg(BaseAddress, XUL_RX_FIFO_OFFSET);
}
  14:	b808068c 	brai	1676

Disassembly of section .vectors.hw_exception:

00000020 <_vector_hw_exception>:
		    				(CurrentIER | Mask));
		}
	}
	else {

		CurrentIER = XIntc_In32(BaseAddress + XIN_IER_OFFSET);
  20:	b0008000 	imm	-32768

		/* Convert from integer id to bit mask */
		Mask = XIntc_BitPosMask[Id];
  24:	b8080264 	brai	612

Disassembly of section .text:

80000000 <_start1>:
80000000:	b0008000 	imm	-32768
80000004:	31a00a38 	addik	r13, r0, 2616
80000008:	b0008000 	imm	-32768
8000000c:	30400908 	addik	r2, r0, 2312
80000010:	b0008000 	imm	-32768
80000014:	30201248 	addik	r1, r0, 4680
80000018:	b0000000 	imm	0
8000001c:	b9f40130 	brlid	r15, 304
80000020:	80000000 	or	r0, r0, r0
80000024:	b0000000 	imm	0
80000028:	b9f40270 	brlid	r15, 624
8000002c:	30a30000 	addik	r5, r3, 0

80000030 <_exit>:
80000030:	b8000000 	bri	0		// 80000030

80000034 <__do_global_dtors_aux>:
80000034:	b0008000 	imm	-32768
80000038:	e0600a38 	lbui	r3, r0, 2616
8000003c:	3021ffe0 	addik	r1, r1, -32
80000040:	f9e10000 	swi	r15, r1, 0
80000044:	be230094 	bneid	r3, 148		// 800000d8
80000048:	fa61001c 	swi	r19, r1, 28
8000004c:	b0008000 	imm	-32768
80000050:	308008e4 	addik	r4, r0, 2276
80000054:	b0008000 	imm	-32768
80000058:	326008e8 	addik	r19, r0, 2280
8000005c:	b0008000 	imm	-32768
80000060:	e8600a3c 	lwi	r3, r0, 2620
80000064:	16649800 	rsubk	r19, r4, r19
80000068:	66730202 	bsrai	r19, r19, 2
8000006c:	3273ffff 	addik	r19, r19, -1
80000070:	16531803 	cmpu	r18, r19, r3
80000074:	beb2003c 	bgeid	r18, 60		// 800000b0
80000078:	30630001 	addik	r3, r3, 1
8000007c:	64830402 	bslli	r4, r3, 2
80000080:	b0008000 	imm	-32768
80000084:	308408e4 	addik	r4, r4, 2276
80000088:	e8840000 	lwi	r4, r4, 0
8000008c:	b0008000 	imm	-32768
80000090:	f8600a3c 	swi	r3, r0, 2620
80000094:	99fc2000 	brald	r15, r4
80000098:	80000000 	or	r0, r0, r0
8000009c:	b0008000 	imm	-32768
800000a0:	e8600a3c 	lwi	r3, r0, 2620
800000a4:	16531803 	cmpu	r18, r19, r3
800000a8:	be52ffd4 	bltid	r18, -44		// 8000007c
800000ac:	30630001 	addik	r3, r3, 1
800000b0:	b0000000 	imm	0
800000b4:	30600000 	addik	r3, r0, 0
800000b8:	bc030014 	beqi	r3, 20		// 800000cc
800000bc:	b0008000 	imm	-32768
800000c0:	30a00a34 	addik	r5, r0, 2612
800000c4:	99fc1800 	brald	r15, r3
800000c8:	80000000 	or	r0, r0, r0
800000cc:	30600001 	addik	r3, r0, 1
800000d0:	b0008000 	imm	-32768
800000d4:	f0600a38 	sbi	r3, r0, 2616
800000d8:	e9e10000 	lwi	r15, r1, 0
800000dc:	ea61001c 	lwi	r19, r1, 28
800000e0:	b60f0008 	rtsd	r15, 8
800000e4:	30210020 	addik	r1, r1, 32

800000e8 <frame_dummy>:
800000e8:	b0000000 	imm	0
800000ec:	30600000 	addik	r3, r0, 0
800000f0:	3021ffe4 	addik	r1, r1, -28
800000f4:	be030020 	beqid	r3, 32		// 80000114
800000f8:	f9e10000 	swi	r15, r1, 0
800000fc:	b0008000 	imm	-32768
80000100:	30a00a34 	addik	r5, r0, 2612
80000104:	b0008000 	imm	-32768
80000108:	30c00a40 	addik	r6, r0, 2624
8000010c:	99fc1800 	brald	r15, r3
80000110:	80000000 	or	r0, r0, r0
80000114:	b0008000 	imm	-32768
80000118:	e8600a34 	lwi	r3, r0, 2612
8000011c:	be030028 	beqid	r3, 40		// 80000144
80000120:	e9e10000 	lwi	r15, r1, 0
80000124:	b0000000 	imm	0
80000128:	30600000 	addik	r3, r0, 0
8000012c:	bc030018 	beqi	r3, 24		// 80000144
80000130:	b0008000 	imm	-32768
80000134:	30a00a34 	addik	r5, r0, 2612
80000138:	99fc1800 	brald	r15, r3
8000013c:	80000000 	or	r0, r0, r0
80000140:	e9e10000 	lwi	r15, r1, 0
80000144:	b60f0008 	rtsd	r15, 8
80000148:	3021001c 	addik	r1, r1, 28

8000014c <_crtinit>:
8000014c:	2021ffec 	addi	r1, r1, -20
80000150:	f9e10000 	swi	r15, r1, 0
80000154:	b0008000 	imm	-32768
80000158:	20c00a38 	addi	r6, r0, 2616
8000015c:	b0008000 	imm	-32768
80000160:	20e00a38 	addi	r7, r0, 2616
80000164:	06463800 	rsub	r18, r6, r7
80000168:	bc720014 	blei	r18, 20		// 8000017c
8000016c:	f8060000 	swi	r0, r6, 0
80000170:	20c60004 	addi	r6, r6, 4
80000174:	06463800 	rsub	r18, r6, r7
80000178:	bc92fff4 	bgti	r18, -12		// 8000016c
8000017c:	b0008000 	imm	-32768
80000180:	20c00a38 	addi	r6, r0, 2616
80000184:	b0008000 	imm	-32768
80000188:	20e00a58 	addi	r7, r0, 2648
8000018c:	06463800 	rsub	r18, r6, r7
80000190:	bc720014 	blei	r18, 20		// 800001a4
80000194:	f8060000 	swi	r0, r6, 0
80000198:	20c60004 	addi	r6, r6, 4
8000019c:	06463800 	rsub	r18, r6, r7
800001a0:	bc92fff4 	bgti	r18, -12		// 80000194
800001a4:	b0000000 	imm	0
800001a8:	b9f400b4 	brlid	r15, 180
800001ac:	80000000 	or	r0, r0, r0
800001b0:	b0000000 	imm	0
800001b4:	b9f406cc 	brlid	r15, 1740
800001b8:	80000000 	or	r0, r0, r0
800001bc:	20c00000 	addi	r6, r0, 0
800001c0:	20e00000 	addi	r7, r0, 0
800001c4:	b0000000 	imm	0
800001c8:	b9f40440 	brlid	r15, 1088
800001cc:	20a00000 	addi	r5, r0, 0
800001d0:	32630000 	addik	r19, r3, 0
800001d4:	b0000000 	imm	0
800001d8:	b9f406e4 	brlid	r15, 1764
800001dc:	80000000 	or	r0, r0, r0
800001e0:	b0000000 	imm	0
800001e4:	b9f40070 	brlid	r15, 112
800001e8:	80000000 	or	r0, r0, r0
800001ec:	c9e10000 	lw	r15, r1, r0
800001f0:	30730000 	addik	r3, r19, 0
800001f4:	b60f0008 	rtsd	r15, 8
800001f8:	20210014 	addi	r1, r1, 20

800001fc <print>:
800001fc:	3021ffdc 	addik	r1, r1, -36
80000200:	fa61001c 	swi	r19, r1, 28
80000204:	f9e10000 	swi	r15, r1, 0
80000208:	fac10020 	swi	r22, r1, 32
8000020c:	12650000 	addk	r19, r5, r0
80000210:	e0a50000 	lbui	r5, r5, 0
80000214:	90a50060 	sext8	r5, r5
80000218:	be050028 	beqid	r5, 40		// 80000240
8000021c:	e9e10000 	lwi	r15, r1, 0
80000220:	b0000000 	imm	0
80000224:	b9f4050c 	brlid	r15, 1292
80000228:	32d30001 	addik	r22, r19, 1
8000022c:	e0b30001 	lbui	r5, r19, 1
80000230:	90a50060 	sext8	r5, r5
80000234:	be25ffec 	bneid	r5, -20		// 80000220
80000238:	12760000 	addk	r19, r22, r0
8000023c:	e9e10000 	lwi	r15, r1, 0
80000240:	ea61001c 	lwi	r19, r1, 28
80000244:	eac10020 	lwi	r22, r1, 32
80000248:	b60f0008 	rtsd	r15, 8
8000024c:	30210024 	addik	r1, r1, 36

80000250 <_exception_handler>:
80000250:	98085800 	bra	r11

80000254 <_program_clean>:
80000254:	b60f0008 	rtsd	r15, 8
80000258:	80000000 	or	r0, r0, r0

8000025c <_program_init>:
8000025c:	b60f0008 	rtsd	r15, 8
80000260:	80000000 	or	r0, r0, r0

80000264 <_hw_exception_handler>:
.global _hw_exception_handler                               
.section .text                                          
.align 2
.ent _hw_exception_handler
_hw_exception_handler:
        bri     0; 
80000264:	b8000000 	bri	0		// 80000264

80000268 <microblaze_enable_dcache>:
	.globl	microblaze_enable_dcache
	.ent	microblaze_enable_dcache
	.align	2
microblaze_enable_dcache:	
	#Make space on stack for a temporary
	addi	r1, r1, -4
80000268:	2021fffc 	addi	r1, r1, -4
	#Read the MSR register
	mfs	r8, rmsr
8000026c:	95008001 	mfs	r8, rmsr
	#Set the interrupt enable bit
	ori	r8, r8, 128
80000270:	a1080080 	ori	r8, r8, 128
	#Save the MSR register
	mts	rmsr, r8
80000274:	9408c001 	mts	rmsr, r8
	#Return
	rtsd	r15, 8
80000278:	b60f0008 	rtsd	r15, 8
	#Update stack in the delay slot
	addi	r1, r1, 4
8000027c:	20210004 	addi	r1, r1, 4

80000280 <microblaze_enable_icache>:
	.globl	microblaze_enable_icache
	.ent	microblaze_enable_icache
	.align	2
microblaze_enable_icache:	
	#Make space on stack for a temporary
	addi	r1, r1, -4
80000280:	2021fffc 	addi	r1, r1, -4
	#Read the MSR register
	mfs	r8, rmsr
80000284:	95008001 	mfs	r8, rmsr
	#Set the interrupt enable bit
	ori	r8, r8, 32
80000288:	a1080020 	ori	r8, r8, 32
	#Save the MSR register
	mts	rmsr, r8
8000028c:	9408c001 	mts	rmsr, r8
	#Return
	rtsd	r15, 8
80000290:	b60f0008 	rtsd	r15, 8
	#Update stack in the delay slot
	addi	r1, r1, 4
80000294:	20210004 	addi	r1, r1, 4

80000298 <exit>:
80000298:	3021ffe0 	addik	r1, r1, -32
8000029c:	10c00000 	addk	r6, r0, r0
800002a0:	fa61001c 	swi	r19, r1, 28
800002a4:	f9e10000 	swi	r15, r1, 0
800002a8:	b0000000 	imm	0
800002ac:	b9f4002c 	brlid	r15, 44
800002b0:	12650000 	addk	r19, r5, r0
800002b4:	b0008000 	imm	-32768
800002b8:	e88008fc 	lwi	r4, r0, 2300
800002bc:	e8640028 	lwi	r3, r4, 40
800002c0:	bc03000c 	beqi	r3, 12		// 800002cc
800002c4:	99fc1800 	brald	r15, r3
800002c8:	10a40000 	addk	r5, r4, r0
800002cc:	b000ffff 	imm	-1
800002d0:	b9f4fd60 	brlid	r15, -672
800002d4:	10b30000 	addk	r5, r19, r0

800002d8 <__call_exitprocs>:
800002d8:	3021ffb8 	addik	r1, r1, -72
800002dc:	fb810038 	swi	r28, r1, 56
800002e0:	b0008000 	imm	-32768
800002e4:	eb8008fc 	lwi	r28, r0, 2300
800002e8:	fb21002c 	swi	r25, r1, 44
800002ec:	fbc10040 	swi	r30, r1, 64
800002f0:	fbe10044 	swi	r31, r1, 68
800002f4:	13c50000 	addk	r30, r5, r0
800002f8:	13260000 	addk	r25, r6, r0
800002fc:	b0000000 	imm	0
80000300:	33e00000 	addik	r31, r0, 0
80000304:	fb610034 	swi	r27, r1, 52
80000308:	fba1003c 	swi	r29, r1, 60
8000030c:	f9e10000 	swi	r15, r1, 0
80000310:	fa61001c 	swi	r19, r1, 28
80000314:	fac10020 	swi	r22, r1, 32
80000318:	fae10024 	swi	r23, r1, 36
8000031c:	fb010028 	swi	r24, r1, 40
80000320:	fb410030 	swi	r26, r1, 48
80000324:	33bc0048 	addik	r29, r28, 72
80000328:	33600001 	addik	r27, r0, 1
8000032c:	eadc0048 	lwi	r22, r28, 72
80000330:	be1600b4 	beqid	r22, 180		// 800003e4
80000334:	135d0000 	addk	r26, r29, r0
80000338:	e8760004 	lwi	r3, r22, 4
8000033c:	3263ffff 	addik	r19, r3, -1
80000340:	be5300a0 	bltid	r19, 160		// 800003e0
80000344:	eaf60088 	lwi	r23, r22, 136
80000348:	bc190104 	beqi	r25, 260		// 8000044c
8000034c:	bc370010 	bnei	r23, 16		// 8000035c
80000350:	b8000090 	bri	144		// 800003e0
80000354:	3273ffff 	addik	r19, r19, -1
80000358:	bc530088 	blti	r19, 136		// 800003e0
8000035c:	30730020 	addik	r3, r19, 32
80000360:	64630402 	bslli	r3, r3, 2
80000364:	c863b800 	lw	r3, r3, r23
80000368:	8863c800 	xor	r3, r3, r25
8000036c:	be23ffe8 	bneid	r3, -24		// 80000354
80000370:	30f30002 	addik	r7, r19, 2
80000374:	eb160004 	lwi	r24, r22, 4
80000378:	64e70402 	bslli	r7, r7, 2
8000037c:	30d8ffff 	addik	r6, r24, -1
80000380:	89069800 	xor	r8, r6, r19
80000384:	be0800a8 	beqid	r8, 168		// 8000042c
80000388:	c887b000 	lw	r4, r7, r22
8000038c:	d867b000 	sw	r3, r7, r22
80000390:	be04ffc4 	beqid	r4, -60		// 80000354
80000394:	447b9c00 	bsll	r3, r27, r19
80000398:	e8d70100 	lwi	r6, r23, 256
8000039c:	84c33000 	and	r6, r3, r6
800003a0:	bc06007c 	beqi	r6, 124		// 8000041c
800003a4:	e8b70104 	lwi	r5, r23, 260
800003a8:	84632800 	and	r3, r3, r5
800003ac:	be03008c 	beqid	r3, 140		// 80000438
800003b0:	64730402 	bslli	r3, r19, 2
800003b4:	99fc2000 	brald	r15, r4
800003b8:	c8a3b800 	lw	r5, r3, r23
800003bc:	e8760004 	lwi	r3, r22, 4
800003c0:	8b03c000 	xor	r24, r3, r24
800003c4:	bc38ff68 	bnei	r24, -152		// 8000032c
800003c8:	e87a0000 	lwi	r3, r26, 0
800003cc:	8863b000 	xor	r3, r3, r22
800003d0:	be23ff5c 	bneid	r3, -164		// 8000032c
800003d4:	3273ffff 	addik	r19, r19, -1
800003d8:	beb3ff88 	bgeid	r19, -120		// 80000360
800003dc:	30730020 	addik	r3, r19, 32
800003e0:	bc3f0188 	bnei	r31, 392		// 80000568
800003e4:	e9e10000 	lwi	r15, r1, 0
800003e8:	ea61001c 	lwi	r19, r1, 28
800003ec:	eac10020 	lwi	r22, r1, 32
800003f0:	eae10024 	lwi	r23, r1, 36
800003f4:	eb010028 	lwi	r24, r1, 40
800003f8:	eb21002c 	lwi	r25, r1, 44
800003fc:	eb410030 	lwi	r26, r1, 48
80000400:	eb610034 	lwi	r27, r1, 52
80000404:	eb810038 	lwi	r28, r1, 56
80000408:	eba1003c 	lwi	r29, r1, 60
8000040c:	ebc10040 	lwi	r30, r1, 64
80000410:	ebe10044 	lwi	r31, r1, 68
80000414:	b60f0008 	rtsd	r15, 8
80000418:	30210048 	addik	r1, r1, 72
8000041c:	99fc2000 	brald	r15, r4
80000420:	80000000 	or	r0, r0, r0
80000424:	b810ff9c 	brid	-100		// 800003c0
80000428:	e8760004 	lwi	r3, r22, 4
8000042c:	f8d60004 	swi	r6, r22, 4
80000430:	b810ff60 	brid	-160		// 80000390
80000434:	13060000 	addk	r24, r6, r0
80000438:	10be0000 	addk	r5, r30, r0
8000043c:	99fc2000 	brald	r15, r4
80000440:	c8c3b800 	lw	r6, r3, r23
80000444:	b810ff7c 	brid	-132		// 800003c0
80000448:	e8760004 	lwi	r3, r22, 4
8000044c:	be1700d8 	beqid	r23, 216		// 80000524
80000450:	30d30002 	addik	r6, r19, 2
80000454:	13030000 	addk	r24, r3, r0
80000458:	64c60402 	bslli	r6, r6, 2
8000045c:	3063ffff 	addik	r3, r3, -1
80000460:	88e39800 	xor	r7, r3, r19
80000464:	be07007c 	beqid	r7, 124		// 800004e0
80000468:	c886b000 	lw	r4, r6, r22
8000046c:	d806b000 	sw	r0, r6, r22
80000470:	be040048 	beqid	r4, 72		// 800004b8
80000474:	447b9c00 	bsll	r3, r27, r19
80000478:	e8b70100 	lwi	r5, r23, 256
8000047c:	84a32800 	and	r5, r3, r5
80000480:	bc0500c8 	beqi	r5, 200		// 80000548
80000484:	e8b70104 	lwi	r5, r23, 260
80000488:	84632800 	and	r3, r3, r5
8000048c:	be2300cc 	bneid	r3, 204		// 80000558
80000490:	64730402 	bslli	r3, r19, 2
80000494:	10be0000 	addk	r5, r30, r0
80000498:	99fc2000 	brald	r15, r4
8000049c:	c8c3b800 	lw	r6, r3, r23
800004a0:	e8760004 	lwi	r3, r22, 4
800004a4:	8863c000 	xor	r3, r3, r24
800004a8:	bc23fe84 	bnei	r3, -380		// 8000032c
800004ac:	e87a0000 	lwi	r3, r26, 0
800004b0:	8863b000 	xor	r3, r3, r22
800004b4:	bc23fe78 	bnei	r3, -392		// 8000032c
800004b8:	3273ffff 	addik	r19, r19, -1
800004bc:	be53ff24 	bltid	r19, -220		// 800003e0
800004c0:	30d30002 	addik	r6, r19, 2
800004c4:	e8760004 	lwi	r3, r22, 4
800004c8:	64c60402 	bslli	r6, r6, 2
800004cc:	13030000 	addk	r24, r3, r0
800004d0:	3063ffff 	addik	r3, r3, -1
800004d4:	88e39800 	xor	r7, r3, r19
800004d8:	be27ff94 	bneid	r7, -108		// 8000046c
800004dc:	c886b000 	lw	r4, r6, r22
800004e0:	f8760004 	swi	r3, r22, 4
800004e4:	b810ff8c 	brid	-116		// 80000470
800004e8:	13030000 	addk	r24, r3, r0
800004ec:	13030000 	addk	r24, r3, r0
800004f0:	f8760004 	swi	r3, r22, 4
800004f4:	bc060024 	beqi	r6, 36		// 80000518
800004f8:	99fc3000 	brald	r15, r6
800004fc:	80000000 	or	r0, r0, r0
80000500:	e8760004 	lwi	r3, r22, 4
80000504:	8863c000 	xor	r3, r3, r24
80000508:	bc23fe24 	bnei	r3, -476		// 8000032c
8000050c:	e87a0000 	lwi	r3, r26, 0
80000510:	8863b000 	xor	r3, r3, r22
80000514:	bc23fe18 	bnei	r3, -488		// 8000032c
80000518:	3273ffff 	addik	r19, r19, -1
8000051c:	bc53fec4 	blti	r19, -316		// 800003e0
80000520:	e8760004 	lwi	r3, r22, 4
80000524:	30930002 	addik	r4, r19, 2
80000528:	13030000 	addk	r24, r3, r0
8000052c:	64840402 	bslli	r4, r4, 2
80000530:	3063ffff 	addik	r3, r3, -1
80000534:	88a39800 	xor	r5, r3, r19
80000538:	be05ffb4 	beqid	r5, -76		// 800004ec
8000053c:	c8c4b000 	lw	r6, r4, r22
80000540:	b810ffb4 	brid	-76		// 800004f4
80000544:	d804b000 	sw	r0, r4, r22
80000548:	99fc2000 	brald	r15, r4
8000054c:	80000000 	or	r0, r0, r0
80000550:	b810ff54 	brid	-172		// 800004a4
80000554:	e8760004 	lwi	r3, r22, 4
80000558:	99fc2000 	brald	r15, r4
8000055c:	c8a3b800 	lw	r5, r3, r23
80000560:	b810ff44 	brid	-188		// 800004a4
80000564:	e8760004 	lwi	r3, r22, 4
80000568:	e8760004 	lwi	r3, r22, 4
8000056c:	bc230040 	bnei	r3, 64		// 800005ac
80000570:	e8760000 	lwi	r3, r22, 0
80000574:	bc03003c 	beqi	r3, 60		// 800005b0
80000578:	be170014 	beqid	r23, 20		// 8000058c
8000057c:	f87a0000 	swi	r3, r26, 0
80000580:	b0007fff 	imm	32767
80000584:	b9f4fa7c 	brlid	r15, -1412	// 0 <_start>
80000588:	10b70000 	addk	r5, r23, r0
8000058c:	b0007fff 	imm	32767
80000590:	b9f4fa70 	brlid	r15, -1424	// 0 <_start>
80000594:	10b60000 	addk	r5, r22, r0
80000598:	eada0000 	lwi	r22, r26, 0
8000059c:	be36fd9c 	bneid	r22, -612		// 80000338
800005a0:	e9e10000 	lwi	r15, r1, 0
800005a4:	b810fe48 	brid	-440		// 800003ec
800005a8:	ea61001c 	lwi	r19, r1, 28
800005ac:	e8760000 	lwi	r3, r22, 0
800005b0:	13560000 	addk	r26, r22, r0
800005b4:	b810ffe8 	brid	-24		// 8000059c
800005b8:	12c30000 	addk	r22, r3, r0

800005bc <__do_global_ctors_aux>:
800005bc:	b0008000 	imm	-32768
800005c0:	e86008dc 	lwi	r3, r0, 2268
800005c4:	3021ffe0 	addik	r1, r1, -32
800005c8:	f9e10000 	swi	r15, r1, 0
800005cc:	a883ffff 	xori	r4, r3, -1
800005d0:	be040028 	beqid	r4, 40		// 800005f8
800005d4:	fa61001c 	swi	r19, r1, 28
800005d8:	b0008000 	imm	-32768
800005dc:	326008dc 	addik	r19, r0, 2268
800005e0:	99fc1800 	brald	r15, r3
800005e4:	80000000 	or	r0, r0, r0
800005e8:	e873fffc 	lwi	r3, r19, -4
800005ec:	a883ffff 	xori	r4, r3, -1
800005f0:	be24fff0 	bneid	r4, -16		// 800005e0
800005f4:	3273fffc 	addik	r19, r19, -4
800005f8:	e9e10000 	lwi	r15, r1, 0
800005fc:	ea61001c 	lwi	r19, r1, 28
80000600:	b60f0008 	rtsd	r15, 8
80000604:	30210020 	addik	r1, r1, 32

80000608 <main>:
80000608:	3021ffe4 	addik	r1, r1, -28
8000060c:	f9e10000 	swi	r15, r1, 0
80000610:	b0000000 	imm	0
80000614:	b9f40058 	brlid	r15, 88
80000618:	80000000 	or	r0, r0, r0
8000061c:	b0008000 	imm	-32768
80000620:	30a008ec 	addik	r5, r0, 2284
80000624:	b000ffff 	imm	-1
80000628:	b9f4fbd4 	brlid	r15, -1068
8000062c:	80000000 	or	r0, r0, r0
80000630:	e9e10000 	lwi	r15, r1, 0
80000634:	10600000 	addk	r3, r0, r0
80000638:	b60f0008 	rtsd	r15, 8
8000063c:	3021001c 	addik	r1, r1, 28

80000640 <enable_caches>:
80000640:	3021ffe4 	addik	r1, r1, -28
80000644:	f9e10000 	swi	r15, r1, 0
80000648:	b000ffff 	imm	-1
8000064c:	b9f4fc34 	brlid	r15, -972
80000650:	80000000 	or	r0, r0, r0
80000654:	b000ffff 	imm	-1
80000658:	b9f4fc10 	brlid	r15, -1008
8000065c:	80000000 	or	r0, r0, r0
80000660:	e9e10000 	lwi	r15, r1, 0
80000664:	b60f0008 	rtsd	r15, 8
80000668:	3021001c 	addik	r1, r1, 28

8000066c <init_platform>:
8000066c:	3021ffe4 	addik	r1, r1, -28
80000670:	f9e10000 	swi	r15, r1, 0
80000674:	b000ffff 	imm	-1
80000678:	b9f4ffc8 	brlid	r15, -56
8000067c:	80000000 	or	r0, r0, r0
80000680:	e9e10000 	lwi	r15, r1, 0
80000684:	b60f0008 	rtsd	r15, 8
80000688:	3021001c 	addik	r1, r1, 28

8000068c <__interrupt_handler>:
*
* None.
*
******************************************************************************/
void __interrupt_handler(void)
{
8000068c:	3021ffac 	addik	r1, r1, -84
80000690:	f9e10000 	swi	r15, r1, 0
80000694:	f8210020 	swi	r1, r1, 32
80000698:	f8610024 	swi	r3, r1, 36
8000069c:	f8810028 	swi	r4, r1, 40
800006a0:	f8a1002c 	swi	r5, r1, 44
800006a4:	f8c10030 	swi	r6, r1, 48
800006a8:	f8e10034 	swi	r7, r1, 52
800006ac:	f9010038 	swi	r8, r1, 56
800006b0:	f921003c 	swi	r9, r1, 60
800006b4:	f9410040 	swi	r10, r1, 64
	/* The compiler saves all volatiles and the MSR */
	MB_InterruptVectorTable.Handler(MB_InterruptVectorTable.CallBackRef);
800006b8:	b0008000 	imm	-32768
800006bc:	306009fc 	addik	r3, r0, 2556
*
* None.
*
******************************************************************************/
void __interrupt_handler(void)
{
800006c0:	f9610044 	swi	r11, r1, 68
800006c4:	f9810048 	swi	r12, r1, 72
800006c8:	fa21004c 	swi	r17, r1, 76
800006cc:	95608001 	mfs	r11, rmsr
	/* The compiler saves all volatiles and the MSR */
	MB_InterruptVectorTable.Handler(MB_InterruptVectorTable.CallBackRef);
800006d0:	e8830000 	lwi	r4, r3, 0
800006d4:	e8a30004 	lwi	r5, r3, 4
*
* None.
*
******************************************************************************/
void __interrupt_handler(void)
{
800006d8:	fa410050 	swi	r18, r1, 80
800006dc:	f961001c 	swi	r11, r1, 28
	/* The compiler saves all volatiles and the MSR */
	MB_InterruptVectorTable.Handler(MB_InterruptVectorTable.CallBackRef);
800006e0:	99fc2000 	brald	r15, r4
800006e4:	80000000 	or	r0, r0, r0
	/* The compiler restores all volatiles and MSR, and returns from interrupt */
}
800006e8:	e9e10000 	lwi	r15, r1, 0
800006ec:	e961001c 	lwi	r11, r1, 28
800006f0:	e8210020 	lwi	r1, r1, 32
800006f4:	940bc001 	mts	rmsr, r11
800006f8:	e8610024 	lwi	r3, r1, 36
800006fc:	e8810028 	lwi	r4, r1, 40
80000700:	e8a1002c 	lwi	r5, r1, 44
80000704:	e8c10030 	lwi	r6, r1, 48
80000708:	e8e10034 	lwi	r7, r1, 52
8000070c:	e9010038 	lwi	r8, r1, 56
80000710:	e921003c 	lwi	r9, r1, 60
80000714:	e9410040 	lwi	r10, r1, 64
80000718:	e9610044 	lwi	r11, r1, 68
8000071c:	e9810048 	lwi	r12, r1, 72
80000720:	ea21004c 	lwi	r17, r1, 76
80000724:	ea410050 	lwi	r18, r1, 80
80000728:	b62e0000 	rtid	r14, 0
8000072c:	30210054 	addik	r1, r1, 84

80000730 <outbyte>:
#ifdef __cplusplus
}
#endif 

void outbyte(char c) {
	 XUartLite_SendByte(STDOUT_BASEADDRESS, c);
80000730:	a4c500ff 	andi	r6, r5, 255
80000734:	b0004060 	imm	16480
80000738:	30a00000 	addik	r5, r0, 0

#ifdef __cplusplus
}
#endif 

void outbyte(char c) {
8000073c:	3021ffe4 	addik	r1, r1, -28
80000740:	f9e10000 	swi	r15, r1, 0
	 XUartLite_SendByte(STDOUT_BASEADDRESS, c);
80000744:	b0000000 	imm	0
80000748:	b9f40014 	brlid	r15, 20
8000074c:	80000000 	or	r0, r0, r0
}
80000750:	e9e10000 	lwi	r15, r1, 0
80000754:	b60f0008 	rtsd	r15, 8
80000758:	3021001c 	addik	r1, r1, 28

8000075c <XUartLite_SendByte>:
*
* @note		None.
*
******************************************************************************/
void XUartLite_SendByte(u32 BaseAddress, u8 Data)
{
8000075c:	30850008 	addik	r4, r5, 8
	while (XUartLite_IsTransmitFull(BaseAddress));
80000760:	e8640000 	lwi	r3, r4, 0
80000764:	a4630008 	andi	r3, r3, 8
80000768:	bc23fff8 	bnei	r3, -8		// 80000760

	XUartLite_WriteReg(BaseAddress, XUL_TX_FIFO_OFFSET, Data);
8000076c:	f8c50004 	swi	r6, r5, 4
}
80000770:	b60f0008 	rtsd	r15, 8
80000774:	80000000 	or	r0, r0, r0

80000778 <XIntc_DeviceInterruptHandler>:
	int IntrNumber;
	XIntc_Config *CfgPtr;
	u32 Imr;

	/* Get the configuration data using the device ID */
	CfgPtr = &XIntc_ConfigTable[(u32)DeviceId];
80000778:	60a50030 	muli	r5, r5, 48
*		recommended to increase STACK_SIZE in linker script for nested
*		interrupts.
*
******************************************************************************/
void XIntc_DeviceInterruptHandler(void *DeviceId)
{
8000077c:	3021ffd4 	addik	r1, r1, -44
80000780:	fa61001c 	swi	r19, r1, 28
80000784:	f9e10000 	swi	r15, r1, 0
80000788:	fac10020 	swi	r22, r1, 32
8000078c:	fae10024 	swi	r23, r1, 36
80000790:	fb010028 	swi	r24, r1, 40
	int IntrNumber;
	XIntc_Config *CfgPtr;
	u32 Imr;

	/* Get the configuration data using the device ID */
	CfgPtr = &XIntc_ConfigTable[(u32)DeviceId];
80000794:	b0008000 	imm	-32768
80000798:	32650a04 	addik	r19, r5, 2564
		volatile u32 ILR_reg;
		/* Save ILR register */
		ILR_reg = Xil_In32(CfgPtr->BaseAddress + XIN_ILR_OFFSET);
#endif
		/* Get the interrupts that are waiting to be serviced */
		IntrStatus = XIntc_GetIntrStatus(CfgPtr->BaseAddress);
8000079c:	e8730004 	lwi	r3, r19, 4

		/* Mask the Fast Interrupts */
		if (CfgPtr->FastIntr == TRUE) {
800007a0:	e893000c 	lwi	r4, r19, 12
		volatile u32 ILR_reg;
		/* Save ILR register */
		ILR_reg = Xil_In32(CfgPtr->BaseAddress + XIN_ILR_OFFSET);
#endif
		/* Get the interrupts that are waiting to be serviced */
		IntrStatus = XIntc_GetIntrStatus(CfgPtr->BaseAddress);
800007a4:	e8a30000 	lwi	r5, r3, 0
800007a8:	eac30008 	lwi	r22, r3, 8

		/* Mask the Fast Interrupts */
		if (CfgPtr->FastIntr == TRUE) {
800007ac:	a8840001 	xori	r4, r4, 1
800007b0:	be0400b8 	beqid	r4, 184		// 80000868
800007b4:	86d62800 	and	r22, r22, r5

		/* Service each interrupt that is active and enabled by
		 * checking each bit in the register from LSB to MSB which
		 * corresponds to an interrupt input signal
		 */
		for (IntrNumber = 0; IntrNumber < CfgPtr->NumberofIntrs;
800007b8:	e8930014 	lwi	r4, r19, 20
800007bc:	be640090 	bleid	r4, 144		// 8000084c
800007c0:	12e00000 	addk	r23, r0, r0
800007c4:	b8100018 	brid	24		// 800007dc
800007c8:	33000001 	addik	r24, r0, 1
800007cc:	e8930014 	lwi	r4, r19, 20
800007d0:	1644b801 	cmp	r18, r4, r23
800007d4:	beb2007c 	bgeid	r18, 124		// 80000850
800007d8:	e9e10000 	lwi	r15, r1, 0

				/* The interrupt is active and enabled, call
				 * the interrupt handler that was setup with
				 * the specified parameter
				 */
				TablePtr = &(CfgPtr->HandlerTable[IntrNumber]);
800007dc:	30970004 	addik	r4, r23, 4
800007e0:	64840403 	bslli	r4, r4, 3
		 * checking each bit in the register from LSB to MSB which
		 * corresponds to an interrupt input signal
		 */
		for (IntrNumber = 0; IntrNumber < CfgPtr->NumberofIntrs;
								IntrNumber++) {
			if (IntrStatus & 1) {
800007e4:	a4b60001 	andi	r5, r22, 1

				/* The interrupt is active and enabled, call
				 * the interrupt handler that was setup with
				 * the specified parameter
				 */
				TablePtr = &(CfgPtr->HandlerTable[IntrNumber]);
800007e8:	10d32000 	addk	r6, r19, r4
				}
			}

			/* Move	 to the next interrupt to check */
			IntrMask <<= 1;
			IntrStatus >>= 1;
800007ec:	92d60041 	srl	r22, r22
		 * checking each bit in the register from LSB to MSB which
		 * corresponds to an interrupt input signal
		 */
		for (IntrNumber = 0; IntrNumber < CfgPtr->NumberofIntrs;
								IntrNumber++) {
			if (IntrStatus & 1) {
800007f0:	be050054 	beqid	r5, 84		// 80000844
800007f4:	32f70001 	addik	r23, r23, 1
				Xil_ExceptionEnable();
#endif
				/* If the interrupt has been setup to
				 * acknowledge it before servicing the
				 * interrupt, then ack it */
				if (CfgPtr->AckBeforeService & IntrMask) {
800007f8:	e8b30008 	lwi	r5, r19, 8
800007fc:	84b82800 	and	r5, r24, r5
80000800:	bc050008 	beqi	r5, 8		// 80000808
					XIntc_AckIntr(CfgPtr->BaseAddress,
80000804:	fb03000c 	swi	r24, r3, 12
				/* The interrupt is active and enabled, call
				 * the interrupt handler that was setup with
				 * the specified parameter
				 */
				TablePtr = &(CfgPtr->HandlerTable[IntrNumber]);
				TablePtr->Handler(TablePtr->CallBackRef);
80000808:	c8649800 	lw	r3, r4, r19
8000080c:	99fc1800 	brald	r15, r3
80000810:	e8a60004 	lwi	r5, r6, 4

				/* If the interrupt has been setup to
				 * acknowledge it after it has been serviced
				 * then ack it
				 */
				if ((CfgPtr->AckBeforeService &
80000814:	e8730008 	lwi	r3, r19, 8
80000818:	84781800 	and	r3, r24, r3
8000081c:	bc23000c 	bnei	r3, 12		// 80000828
							IntrMask) == 0) {
					XIntc_AckIntr(CfgPtr->BaseAddress,
80000820:	e8730004 	lwi	r3, r19, 4
80000824:	fb03000c 	swi	r24, r3, 12
#endif
				/*
				 * Read the ISR again to handle architectures
				 * with posted write bus access issues.
				 */
				 XIntc_GetIntrStatus(CfgPtr->BaseAddress);
80000828:	e8730004 	lwi	r3, r19, 4
				 * If only the highest priority interrupt is to
				 * be serviced, exit loop and return after
				 * servicing
				 * the interrupt
				 */
				if (CfgPtr->Options == XIN_SVC_SGL_ISR_OPTION) {
8000082c:	e8930018 	lwi	r4, r19, 24
#endif
				/*
				 * Read the ISR again to handle architectures
				 * with posted write bus access issues.
				 */
				 XIntc_GetIntrStatus(CfgPtr->BaseAddress);
80000830:	e8a30000 	lwi	r5, r3, 0
80000834:	e8a30008 	lwi	r5, r3, 8
				 * If only the highest priority interrupt is to
				 * be serviced, exit loop and return after
				 * servicing
				 * the interrupt
				 */
				if (CfgPtr->Options == XIN_SVC_SGL_ISR_OPTION) {
80000838:	a8840001 	xori	r4, r4, 1
8000083c:	be040014 	beqid	r4, 20		// 80000850
80000840:	e9e10000 	lwi	r15, r1, 0
			IntrStatus >>= 1;

			/* If there are no other bits set indicating that all
			 * interrupts have been serviced, then exit the loop
			 */
			if (IntrStatus == 0) {
80000844:	be36ff88 	bneid	r22, -120		// 800007cc
80000848:	1318c000 	addk	r24, r24, r24
		/* Restore r14 */
		mtgpr(r14, R14_register);
#endif
#endif	
	}
}
8000084c:	e9e10000 	lwi	r15, r1, 0
80000850:	ea61001c 	lwi	r19, r1, 28
80000854:	eac10020 	lwi	r22, r1, 32
80000858:	eae10024 	lwi	r23, r1, 36
8000085c:	eb010028 	lwi	r24, r1, 40
80000860:	b60f0008 	rtsd	r15, 8
80000864:	3021002c 	addik	r1, r1, 44
		/* Get the interrupts that are waiting to be serviced */
		IntrStatus = XIntc_GetIntrStatus(CfgPtr->BaseAddress);

		/* Mask the Fast Interrupts */
		if (CfgPtr->FastIntr == TRUE) {
			Imr = XIntc_In32(CfgPtr->BaseAddress + XIN_IMR_OFFSET);
80000868:	e8830020 	lwi	r4, r3, 32
			IntrStatus &=  ~Imr;
8000086c:	a884ffff 	xori	r4, r4, -1
80000870:	b810ff48 	brid	-184		// 800007b8
80000874:	86d62000 	and	r22, r22, r4

80000878 <XNullHandler>:
*
******************************************************************************/
void XNullHandler(void *NullParameter)
{
 (void) NullParameter;
}
80000878:	b60f0008 	rtsd	r15, 8
8000087c:	80000000 	or	r0, r0, r0

Disassembly of section .init:

80000880 <__init>:
80000880:	3021fff8 	addik	r1, r1, -8
80000884:	d9e00800 	sw	r15, r0, r1
80000888:	3160ffff 	addik	r11, r0, -1
8000088c:	940bc802 	mts	rshr, r11
80000890:	31600000 	addik	r11, r0, 0
80000894:	940bc800 	mts	rslr, r11
80000898:	b000ffff 	imm	-1
8000089c:	b9f4f84c 	brlid	r15, -1972
800008a0:	80000000 	or	r0, r0, r0
800008a4:	b000ffff 	imm	-1
800008a8:	b9f4fd14 	brlid	r15, -748
800008ac:	80000000 	or	r0, r0, r0
800008b0:	c9e00800 	lw	r15, r0, r1
800008b4:	b60f0008 	rtsd	r15, 8
800008b8:	30210008 	addik	r1, r1, 8

Disassembly of section .fini:

800008bc <__fini>:
800008bc:	3021fff8 	addik	r1, r1, -8
800008c0:	d9e00800 	sw	r15, r0, r1
800008c4:	b000ffff 	imm	-1
800008c8:	b9f4f76c 	brlid	r15, -2196
800008cc:	80000000 	or	r0, r0, r0
800008d0:	c9e00800 	lw	r15, r0, r1
800008d4:	b60f0008 	rtsd	r15, 8
800008d8:	30210008 	addik	r1, r1, 8
