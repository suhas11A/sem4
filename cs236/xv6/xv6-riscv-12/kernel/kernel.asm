
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9a010113          	addi	sp,sp,-1632 # 800089a0 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	04e000ef          	jal	80000064 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000024:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000028:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002c:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80000030:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000034:	577d                	li	a4,-1
    80000036:	177e                	slli	a4,a4,0x3f
    80000038:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000003a:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003e:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000042:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000046:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    8000004a:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004e:	000f4737          	lui	a4,0xf4
    80000052:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000056:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000058:	14d79073          	csrw	stimecmp,a5
}
    8000005c:	60a2                	ld	ra,8(sp)
    8000005e:	6402                	ld	s0,0(sp)
    80000060:	0141                	addi	sp,sp,16
    80000062:	8082                	ret

0000000080000064 <start>:
{
    80000064:	1141                	addi	sp,sp,-16
    80000066:	e406                	sd	ra,8(sp)
    80000068:	e022                	sd	s0,0(sp)
    8000006a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000070:	7779                	lui	a4,0xffffe
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdbe97>
    80000076:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000078:	6705                	lui	a4,0x1
    8000007a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000080:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000084:	00001797          	auipc	a5,0x1
    80000088:	df878793          	addi	a5,a5,-520 # 80000e7c <main>
    8000008c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80000090:	4781                	li	a5,0
    80000092:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000096:	67c1                	lui	a5,0x10
    80000098:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000009a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000a2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800000a6:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800000aa:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000ae:	57fd                	li	a5,-1
    800000b0:	83a9                	srli	a5,a5,0xa
    800000b2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b6:	47bd                	li	a5,15
    800000b8:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000bc:	f61ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000c0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c8:	30200073          	mret
}
    800000cc:	60a2                	ld	ra,8(sp)
    800000ce:	6402                	ld	s0,0(sp)
    800000d0:	0141                	addi	sp,sp,16
    800000d2:	8082                	ret

00000000800000d4 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d4:	7119                	addi	sp,sp,-128
    800000d6:	fc86                	sd	ra,120(sp)
    800000d8:	f8a2                	sd	s0,112(sp)
    800000da:	f4a6                	sd	s1,104(sp)
    800000dc:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while(i < n){
    800000de:	06c05b63          	blez	a2,80000154 <consolewrite+0x80>
    800000e2:	f0ca                	sd	s2,96(sp)
    800000e4:	ecce                	sd	s3,88(sp)
    800000e6:	e8d2                	sd	s4,80(sp)
    800000e8:	e4d6                	sd	s5,72(sp)
    800000ea:	e0da                	sd	s6,64(sp)
    800000ec:	fc5e                	sd	s7,56(sp)
    800000ee:	f862                	sd	s8,48(sp)
    800000f0:	f466                	sd	s9,40(sp)
    800000f2:	f06a                	sd	s10,32(sp)
    800000f4:	8b2a                	mv	s6,a0
    800000f6:	8bae                	mv	s7,a1
    800000f8:	8a32                	mv	s4,a2
  int i = 0;
    800000fa:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800000fc:	02000c93          	li	s9,32
    80000100:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000104:	f8040a93          	addi	s5,s0,-128
    80000108:	5c7d                	li	s8,-1
    8000010a:	a025                	j	80000132 <consolewrite+0x5e>
    if(nn > n - i)
    8000010c:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000110:	86ce                	mv	a3,s3
    80000112:	01748633          	add	a2,s1,s7
    80000116:	85da                	mv	a1,s6
    80000118:	8556                	mv	a0,s5
    8000011a:	1a4020ef          	jal	800022be <either_copyin>
    8000011e:	03850d63          	beq	a0,s8,80000158 <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000122:	85ce                	mv	a1,s3
    80000124:	8556                	mv	a0,s5
    80000126:	76e000ef          	jal	80000894 <uartwrite>
    i += nn;
    8000012a:	009904bb          	addw	s1,s2,s1
  while(i < n){
    8000012e:	0144d963          	bge	s1,s4,80000140 <consolewrite+0x6c>
    if(nn > n - i)
    80000132:	409a07bb          	subw	a5,s4,s1
    80000136:	893e                	mv	s2,a5
    80000138:	fcfcdae3          	bge	s9,a5,8000010c <consolewrite+0x38>
    8000013c:	896a                	mv	s2,s10
    8000013e:	b7f9                	j	8000010c <consolewrite+0x38>
    80000140:	7906                	ld	s2,96(sp)
    80000142:	69e6                	ld	s3,88(sp)
    80000144:	6a46                	ld	s4,80(sp)
    80000146:	6aa6                	ld	s5,72(sp)
    80000148:	6b06                	ld	s6,64(sp)
    8000014a:	7be2                	ld	s7,56(sp)
    8000014c:	7c42                	ld	s8,48(sp)
    8000014e:	7ca2                	ld	s9,40(sp)
    80000150:	7d02                	ld	s10,32(sp)
    80000152:	a821                	j	8000016a <consolewrite+0x96>
  int i = 0;
    80000154:	4481                	li	s1,0
    80000156:	a811                	j	8000016a <consolewrite+0x96>
    80000158:	7906                	ld	s2,96(sp)
    8000015a:	69e6                	ld	s3,88(sp)
    8000015c:	6a46                	ld	s4,80(sp)
    8000015e:	6aa6                	ld	s5,72(sp)
    80000160:	6b06                	ld	s6,64(sp)
    80000162:	7be2                	ld	s7,56(sp)
    80000164:	7c42                	ld	s8,48(sp)
    80000166:	7ca2                	ld	s9,40(sp)
    80000168:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016a:	8526                	mv	a0,s1
    8000016c:	70e6                	ld	ra,120(sp)
    8000016e:	7446                	ld	s0,112(sp)
    80000170:	74a6                	ld	s1,104(sp)
    80000172:	6109                	addi	sp,sp,128
    80000174:	8082                	ret

0000000080000176 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000176:	711d                	addi	sp,sp,-96
    80000178:	ec86                	sd	ra,88(sp)
    8000017a:	e8a2                	sd	s0,80(sp)
    8000017c:	e4a6                	sd	s1,72(sp)
    8000017e:	e0ca                	sd	s2,64(sp)
    80000180:	fc4e                	sd	s3,56(sp)
    80000182:	f852                	sd	s4,48(sp)
    80000184:	f456                	sd	s5,40(sp)
    80000186:	f05a                	sd	s6,32(sp)
    80000188:	1080                	addi	s0,sp,96
    8000018a:	8aaa                	mv	s5,a0
    8000018c:	8a2e                	mv	s4,a1
    8000018e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000190:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80000192:	00011517          	auipc	a0,0x11
    80000196:	80e50513          	addi	a0,a0,-2034 # 800109a0 <cons>
    8000019a:	25d000ef          	jal	80000bf6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	00011497          	auipc	s1,0x11
    800001a2:	80248493          	addi	s1,s1,-2046 # 800109a0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	00011917          	auipc	s2,0x11
    800001aa:	89290913          	addi	s2,s2,-1902 # 80010a38 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	756010ef          	jal	80001914 <myproc>
    800001c2:	795010ef          	jal	80002156 <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	553010ef          	jal	80001f1e <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00010717          	auipc	a4,0x10
    800001e2:	7c270713          	addi	a4,a4,1986 # 800109a0 <cons>
    800001e6:	0017869b          	addiw	a3,a5,1
    800001ea:	08d72c23          	sw	a3,152(a4)
    800001ee:	07f7f693          	andi	a3,a5,127
    800001f2:	9736                	add	a4,a4,a3
    800001f4:	01874703          	lbu	a4,24(a4)
    800001f8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001fc:	4691                	li	a3,4
    800001fe:	04db8663          	beq	s7,a3,8000024a <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000202:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000206:	4685                	li	a3,1
    80000208:	faf40613          	addi	a2,s0,-81
    8000020c:	85d2                	mv	a1,s4
    8000020e:	8556                	mv	a0,s5
    80000210:	064020ef          	jal	80002274 <either_copyout>
    80000214:	57fd                	li	a5,-1
    80000216:	04f50663          	beq	a0,a5,80000262 <consoleread+0xec>
      break;

    dst++;
    8000021a:	0a05                	addi	s4,s4,1
    --n;
    8000021c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000021e:	47a9                	li	a5,10
    80000220:	04fb8b63          	beq	s7,a5,80000276 <consoleread+0x100>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	b761                	j	800001ae <consoleread+0x38>
        release(&cons.lock);
    80000228:	00010517          	auipc	a0,0x10
    8000022c:	77850513          	addi	a0,a0,1912 # 800109a0 <cons>
    80000230:	25b000ef          	jal	80000c8a <release>
        return -1;
    80000234:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000236:	60e6                	ld	ra,88(sp)
    80000238:	6446                	ld	s0,80(sp)
    8000023a:	64a6                	ld	s1,72(sp)
    8000023c:	6906                	ld	s2,64(sp)
    8000023e:	79e2                	ld	s3,56(sp)
    80000240:	7a42                	ld	s4,48(sp)
    80000242:	7aa2                	ld	s5,40(sp)
    80000244:	7b02                	ld	s6,32(sp)
    80000246:	6125                	addi	sp,sp,96
    80000248:	8082                	ret
      if(n < target){
    8000024a:	0169fa63          	bgeu	s3,s6,8000025e <consoleread+0xe8>
        cons.r--;
    8000024e:	00010717          	auipc	a4,0x10
    80000252:	7ef72523          	sw	a5,2026(a4) # 80010a38 <cons+0x98>
    80000256:	6be2                	ld	s7,24(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	ec5e                	sd	s7,24(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	6be2                	ld	s7,24(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000264:	00010517          	auipc	a0,0x10
    80000268:	73c50513          	addi	a0,a0,1852 # 800109a0 <cons>
    8000026c:	21f000ef          	jal	80000c8a <release>
  return target - n;
    80000270:	413b053b          	subw	a0,s6,s3
    80000274:	b7c9                	j	80000236 <consoleread+0xc0>
    80000276:	6be2                	ld	s7,24(sp)
    80000278:	b7f5                	j	80000264 <consoleread+0xee>

000000008000027a <consputc>:
{
    8000027a:	1141                	addi	sp,sp,-16
    8000027c:	e406                	sd	ra,8(sp)
    8000027e:	e022                	sd	s0,0(sp)
    80000280:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000282:	10000793          	li	a5,256
    80000286:	00f50863          	beq	a0,a5,80000296 <consputc+0x1c>
    uartputc_sync(c);
    8000028a:	69e000ef          	jal	80000928 <uartputc_sync>
}
    8000028e:	60a2                	ld	ra,8(sp)
    80000290:	6402                	ld	s0,0(sp)
    80000292:	0141                	addi	sp,sp,16
    80000294:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000296:	4521                	li	a0,8
    80000298:	690000ef          	jal	80000928 <uartputc_sync>
    8000029c:	02000513          	li	a0,32
    800002a0:	688000ef          	jal	80000928 <uartputc_sync>
    800002a4:	4521                	li	a0,8
    800002a6:	682000ef          	jal	80000928 <uartputc_sync>
    800002aa:	b7d5                	j	8000028e <consputc+0x14>

00000000800002ac <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ac:	7179                	addi	sp,sp,-48
    800002ae:	f406                	sd	ra,40(sp)
    800002b0:	f022                	sd	s0,32(sp)
    800002b2:	ec26                	sd	s1,24(sp)
    800002b4:	1800                	addi	s0,sp,48
    800002b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b8:	00010517          	auipc	a0,0x10
    800002bc:	6e850513          	addi	a0,a0,1768 # 800109a0 <cons>
    800002c0:	137000ef          	jal	80000bf6 <acquire>

  switch(c){
    800002c4:	47d5                	li	a5,21
    800002c6:	08f48e63          	beq	s1,a5,80000362 <consoleintr+0xb6>
    800002ca:	0297c563          	blt	a5,s1,800002f4 <consoleintr+0x48>
    800002ce:	47a1                	li	a5,8
    800002d0:	0ef48863          	beq	s1,a5,800003c0 <consoleintr+0x114>
    800002d4:	47c1                	li	a5,16
    800002d6:	10f49963          	bne	s1,a5,800003e8 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    800002da:	02e020ef          	jal	80002308 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002de:	00010517          	auipc	a0,0x10
    800002e2:	6c250513          	addi	a0,a0,1730 # 800109a0 <cons>
    800002e6:	1a5000ef          	jal	80000c8a <release>
}
    800002ea:	70a2                	ld	ra,40(sp)
    800002ec:	7402                	ld	s0,32(sp)
    800002ee:	64e2                	ld	s1,24(sp)
    800002f0:	6145                	addi	sp,sp,48
    800002f2:	8082                	ret
  switch(c){
    800002f4:	07f00793          	li	a5,127
    800002f8:	0cf48463          	beq	s1,a5,800003c0 <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002fc:	00010717          	auipc	a4,0x10
    80000300:	6a470713          	addi	a4,a4,1700 # 800109a0 <cons>
    80000304:	0a072783          	lw	a5,160(a4)
    80000308:	09872703          	lw	a4,152(a4)
    8000030c:	9f99                	subw	a5,a5,a4
    8000030e:	07f00713          	li	a4,127
    80000312:	fcf766e3          	bltu	a4,a5,800002de <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000316:	47b5                	li	a5,13
    80000318:	0cf48b63          	beq	s1,a5,800003ee <consoleintr+0x142>
      consputc(c);
    8000031c:	8526                	mv	a0,s1
    8000031e:	f5dff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000322:	00010797          	auipc	a5,0x10
    80000326:	67e78793          	addi	a5,a5,1662 # 800109a0 <cons>
    8000032a:	0a07a683          	lw	a3,160(a5)
    8000032e:	0016871b          	addiw	a4,a3,1
    80000332:	863a                	mv	a2,a4
    80000334:	0ae7a023          	sw	a4,160(a5)
    80000338:	07f6f693          	andi	a3,a3,127
    8000033c:	97b6                	add	a5,a5,a3
    8000033e:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000342:	47a9                	li	a5,10
    80000344:	0cf48963          	beq	s1,a5,80000416 <consoleintr+0x16a>
    80000348:	4791                	li	a5,4
    8000034a:	0cf48663          	beq	s1,a5,80000416 <consoleintr+0x16a>
    8000034e:	00010797          	auipc	a5,0x10
    80000352:	6ea7a783          	lw	a5,1770(a5) # 80010a38 <cons+0x98>
    80000356:	9f1d                	subw	a4,a4,a5
    80000358:	08000793          	li	a5,128
    8000035c:	f8f711e3          	bne	a4,a5,800002de <consoleintr+0x32>
    80000360:	a85d                	j	80000416 <consoleintr+0x16a>
    80000362:	e84a                	sd	s2,16(sp)
    80000364:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80000366:	00010717          	auipc	a4,0x10
    8000036a:	63a70713          	addi	a4,a4,1594 # 800109a0 <cons>
    8000036e:	0a072783          	lw	a5,160(a4)
    80000372:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000376:	00010497          	auipc	s1,0x10
    8000037a:	62a48493          	addi	s1,s1,1578 # 800109a0 <cons>
    while(cons.e != cons.w &&
    8000037e:	4929                	li	s2,10
      consputc(BACKSPACE);
    80000380:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80000384:	02f70863          	beq	a4,a5,800003b4 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000388:	37fd                	addiw	a5,a5,-1
    8000038a:	07f7f713          	andi	a4,a5,127
    8000038e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000390:	01874703          	lbu	a4,24(a4)
    80000394:	03270363          	beq	a4,s2,800003ba <consoleintr+0x10e>
      cons.e--;
    80000398:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000039c:	854e                	mv	a0,s3
    8000039e:	eddff0ef          	jal	8000027a <consputc>
    while(cons.e != cons.w &&
    800003a2:	0a04a783          	lw	a5,160(s1)
    800003a6:	09c4a703          	lw	a4,156(s1)
    800003aa:	fcf71fe3          	bne	a4,a5,80000388 <consoleintr+0xdc>
    800003ae:	6942                	ld	s2,16(sp)
    800003b0:	69a2                	ld	s3,8(sp)
    800003b2:	b735                	j	800002de <consoleintr+0x32>
    800003b4:	6942                	ld	s2,16(sp)
    800003b6:	69a2                	ld	s3,8(sp)
    800003b8:	b71d                	j	800002de <consoleintr+0x32>
    800003ba:	6942                	ld	s2,16(sp)
    800003bc:	69a2                	ld	s3,8(sp)
    800003be:	b705                	j	800002de <consoleintr+0x32>
    if(cons.e != cons.w){
    800003c0:	00010717          	auipc	a4,0x10
    800003c4:	5e070713          	addi	a4,a4,1504 # 800109a0 <cons>
    800003c8:	0a072783          	lw	a5,160(a4)
    800003cc:	09c72703          	lw	a4,156(a4)
    800003d0:	f0f707e3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003d4:	37fd                	addiw	a5,a5,-1
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	66f72523          	sw	a5,1642(a4) # 80010a40 <cons+0xa0>
      consputc(BACKSPACE);
    800003de:	10000513          	li	a0,256
    800003e2:	e99ff0ef          	jal	8000027a <consputc>
    800003e6:	bde5                	j	800002de <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003e8:	ee048be3          	beqz	s1,800002de <consoleintr+0x32>
    800003ec:	bf01                	j	800002fc <consoleintr+0x50>
      consputc(c);
    800003ee:	4529                	li	a0,10
    800003f0:	e8bff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003f4:	00010797          	auipc	a5,0x10
    800003f8:	5ac78793          	addi	a5,a5,1452 # 800109a0 <cons>
    800003fc:	0a07a703          	lw	a4,160(a5)
    80000400:	0017069b          	addiw	a3,a4,1
    80000404:	8636                	mv	a2,a3
    80000406:	0ad7a023          	sw	a3,160(a5)
    8000040a:	07f77713          	andi	a4,a4,127
    8000040e:	97ba                	add	a5,a5,a4
    80000410:	4729                	li	a4,10
    80000412:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000416:	00010797          	auipc	a5,0x10
    8000041a:	62c7a323          	sw	a2,1574(a5) # 80010a3c <cons+0x9c>
        wakeup(&cons.r);
    8000041e:	00010517          	auipc	a0,0x10
    80000422:	61a50513          	addi	a0,a0,1562 # 80010a38 <cons+0x98>
    80000426:	345010ef          	jal	80001f6a <wakeup>
    8000042a:	bd55                	j	800002de <consoleintr+0x32>

000000008000042c <consoleinit>:

void
consoleinit(void)
{
    8000042c:	1141                	addi	sp,sp,-16
    8000042e:	e406                	sd	ra,8(sp)
    80000430:	e022                	sd	s0,0(sp)
    80000432:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000434:	00008597          	auipc	a1,0x8
    80000438:	bcc58593          	addi	a1,a1,-1076 # 80008000 <etext>
    8000043c:	00010517          	auipc	a0,0x10
    80000440:	56450513          	addi	a0,a0,1380 # 800109a0 <cons>
    80000444:	72e000ef          	jal	80000b72 <initlock>

  uartinit();
    80000448:	3f6000ef          	jal	8000083e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000044c:	00020797          	auipc	a5,0x20
    80000450:	6c478793          	addi	a5,a5,1732 # 80020b10 <devsw>
    80000454:	00000717          	auipc	a4,0x0
    80000458:	d2270713          	addi	a4,a4,-734 # 80000176 <consoleread>
    8000045c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000045e:	00000717          	auipc	a4,0x0
    80000462:	c7670713          	addi	a4,a4,-906 # 800000d4 <consolewrite>
    80000466:	ef98                	sd	a4,24(a5)
}
    80000468:	60a2                	ld	ra,8(sp)
    8000046a:	6402                	ld	s0,0(sp)
    8000046c:	0141                	addi	sp,sp,16
    8000046e:	8082                	ret

0000000080000470 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000470:	7139                	addi	sp,sp,-64
    80000472:	fc06                	sd	ra,56(sp)
    80000474:	f822                	sd	s0,48(sp)
    80000476:	f426                	sd	s1,40(sp)
    80000478:	f04a                	sd	s2,32(sp)
    8000047a:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000047c:	c219                	beqz	a2,80000482 <printint+0x12>
    8000047e:	06054a63          	bltz	a0,800004f2 <printint+0x82>
    x = -xx;
  else
    x = xx;
    80000482:	4e01                	li	t3,0

  i = 0;
    80000484:	fc840313          	addi	t1,s0,-56
    x = xx;
    80000488:	869a                	mv	a3,t1
  i = 0;
    8000048a:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    8000048c:	00008817          	auipc	a6,0x8
    80000490:	34c80813          	addi	a6,a6,844 # 800087d8 <digits>
    80000494:	88be                	mv	a7,a5
    80000496:	0017861b          	addiw	a2,a5,1
    8000049a:	87b2                	mv	a5,a2
    8000049c:	02b57733          	remu	a4,a0,a1
    800004a0:	9742                	add	a4,a4,a6
    800004a2:	00074703          	lbu	a4,0(a4)
    800004a6:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800004aa:	872a                	mv	a4,a0
    800004ac:	02b55533          	divu	a0,a0,a1
    800004b0:	0685                	addi	a3,a3,1
    800004b2:	feb771e3          	bgeu	a4,a1,80000494 <printint+0x24>

  if(sign)
    800004b6:	000e0c63          	beqz	t3,800004ce <printint+0x5e>
    buf[i++] = '-';
    800004ba:	fe060793          	addi	a5,a2,-32
    800004be:	00878633          	add	a2,a5,s0
    800004c2:	02d00793          	li	a5,45
    800004c6:	fef60423          	sb	a5,-24(a2)
    800004ca:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    800004ce:	fff7891b          	addiw	s2,a5,-1
    800004d2:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    800004d6:	fff4c503          	lbu	a0,-1(s1)
    800004da:	da1ff0ef          	jal	8000027a <consputc>
  while(--i >= 0)
    800004de:	397d                	addiw	s2,s2,-1
    800004e0:	14fd                	addi	s1,s1,-1
    800004e2:	fe095ae3          	bgez	s2,800004d6 <printint+0x66>
}
    800004e6:	70e2                	ld	ra,56(sp)
    800004e8:	7442                	ld	s0,48(sp)
    800004ea:	74a2                	ld	s1,40(sp)
    800004ec:	7902                	ld	s2,32(sp)
    800004ee:	6121                	addi	sp,sp,64
    800004f0:	8082                	ret
    x = -xx;
    800004f2:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004f6:	4e05                	li	t3,1
    x = -xx;
    800004f8:	b771                	j	80000484 <printint+0x14>

00000000800004fa <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004fa:	7131                	addi	sp,sp,-192
    800004fc:	fc86                	sd	ra,120(sp)
    800004fe:	f8a2                	sd	s0,112(sp)
    80000500:	e8d2                	sd	s4,80(sp)
    80000502:	0100                	addi	s0,sp,128
    80000504:	8a2a                	mv	s4,a0
    80000506:	e40c                	sd	a1,8(s0)
    80000508:	e810                	sd	a2,16(s0)
    8000050a:	ec14                	sd	a3,24(s0)
    8000050c:	f018                	sd	a4,32(s0)
    8000050e:	f41c                	sd	a5,40(s0)
    80000510:	03043823          	sd	a6,48(s0)
    80000514:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80000518:	00008797          	auipc	a5,0x8
    8000051c:	44c7a783          	lw	a5,1100(a5) # 80008964 <panicking>
    80000520:	c3a1                	beqz	a5,80000560 <printf+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	000a4503          	lbu	a0,0(s4)
    8000052e:	28050663          	beqz	a0,800007ba <printf+0x2c0>
    80000532:	f4a6                	sd	s1,104(sp)
    80000534:	f0ca                	sd	s2,96(sp)
    80000536:	ecce                	sd	s3,88(sp)
    80000538:	e4d6                	sd	s5,72(sp)
    8000053a:	e0da                	sd	s6,64(sp)
    8000053c:	f862                	sd	s8,48(sp)
    8000053e:	f466                	sd	s9,40(sp)
    80000540:	f06a                	sd	s10,32(sp)
    80000542:	ec6e                	sd	s11,24(sp)
    80000544:	4901                	li	s2,0
    if(cx != '%'){
    80000546:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000054a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000054e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000552:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000556:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000055a:	07000d93          	li	s11,112
    8000055e:	a015                	j	80000582 <printf+0x88>
    acquire(&pr.lock);
    80000560:	00010517          	auipc	a0,0x10
    80000564:	4e850513          	addi	a0,a0,1256 # 80010a48 <pr>
    80000568:	68e000ef          	jal	80000bf6 <acquire>
    8000056c:	bf5d                	j	80000522 <printf+0x28>
      consputc(cx);
    8000056e:	d0dff0ef          	jal	8000027a <consputc>
      continue;
    80000572:	84ca                	mv	s1,s2
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000574:	2485                	addiw	s1,s1,1
    80000576:	8926                	mv	s2,s1
    80000578:	94d2                	add	s1,s1,s4
    8000057a:	0004c503          	lbu	a0,0(s1)
    8000057e:	20050b63          	beqz	a0,80000794 <printf+0x29a>
    if(cx != '%'){
    80000582:	ff5516e3          	bne	a0,s5,8000056e <printf+0x74>
    i++;
    80000586:	0019079b          	addiw	a5,s2,1
    8000058a:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000058c:	00fa0733          	add	a4,s4,a5
    80000590:	00074983          	lbu	s3,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000594:	20098a63          	beqz	s3,800007a8 <printf+0x2ae>
    80000598:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    8000059c:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    8000059e:	c701                	beqz	a4,800005a6 <printf+0xac>
    800005a0:	97d2                	add	a5,a5,s4
    800005a2:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    800005a6:	03698963          	beq	s3,s6,800005d8 <printf+0xde>
    } else if(c0 == 'l' && c1 == 'd'){
    800005aa:	05898363          	beq	s3,s8,800005f0 <printf+0xf6>
    } else if(c0 == 'u'){
    800005ae:	0d998663          	beq	s3,s9,8000067a <printf+0x180>
    } else if(c0 == 'x'){
    800005b2:	11a98d63          	beq	s3,s10,800006cc <printf+0x1d2>
    } else if(c0 == 'p'){
    800005b6:	15b98663          	beq	s3,s11,80000702 <printf+0x208>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    800005ba:	06300793          	li	a5,99
    800005be:	18f98563          	beq	s3,a5,80000748 <printf+0x24e>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    800005c2:	07300793          	li	a5,115
    800005c6:	18f98b63          	beq	s3,a5,8000075c <printf+0x262>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005ca:	03599b63          	bne	s3,s5,80000600 <printf+0x106>
      consputc('%');
    800005ce:	02500513          	li	a0,37
    800005d2:	ca9ff0ef          	jal	8000027a <consputc>
    800005d6:	bf79                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, int), 10, 1);
    800005d8:	f8843783          	ld	a5,-120(s0)
    800005dc:	00878713          	addi	a4,a5,8
    800005e0:	f8e43423          	sd	a4,-120(s0)
    800005e4:	4605                	li	a2,1
    800005e6:	45a9                	li	a1,10
    800005e8:	4388                	lw	a0,0(a5)
    800005ea:	e87ff0ef          	jal	80000470 <printint>
    800005ee:	b759                	j	80000574 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'd'){
    800005f0:	01670f63          	beq	a4,s6,8000060e <printf+0x114>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005f4:	03870b63          	beq	a4,s8,8000062a <printf+0x130>
    } else if(c0 == 'l' && c1 == 'u'){
    800005f8:	09970e63          	beq	a4,s9,80000694 <printf+0x19a>
    } else if(c0 == 'l' && c1 == 'x'){
    800005fc:	0fa70563          	beq	a4,s10,800006e6 <printf+0x1ec>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80000600:	8556                	mv	a0,s5
    80000602:	c79ff0ef          	jal	8000027a <consputc>
      consputc(c0);
    80000606:	854e                	mv	a0,s3
    80000608:	c73ff0ef          	jal	8000027a <consputc>
    8000060c:	b7a5                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000060e:	f8843783          	ld	a5,-120(s0)
    80000612:	00878713          	addi	a4,a5,8
    80000616:	f8e43423          	sd	a4,-120(s0)
    8000061a:	4605                	li	a2,1
    8000061c:	45a9                	li	a1,10
    8000061e:	6388                	ld	a0,0(a5)
    80000620:	e51ff0ef          	jal	80000470 <printint>
      i += 1;
    80000624:	0029049b          	addiw	s1,s2,2
    80000628:	b7b1                	j	80000574 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000062a:	06400793          	li	a5,100
    8000062e:	02f68863          	beq	a3,a5,8000065e <printf+0x164>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000632:	07500793          	li	a5,117
    80000636:	06f68d63          	beq	a3,a5,800006b0 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000063a:	07800793          	li	a5,120
    8000063e:	fcf691e3          	bne	a3,a5,80000600 <printf+0x106>
      printint(va_arg(ap, uint64), 16, 0);
    80000642:	f8843783          	ld	a5,-120(s0)
    80000646:	00878713          	addi	a4,a5,8
    8000064a:	f8e43423          	sd	a4,-120(s0)
    8000064e:	4601                	li	a2,0
    80000650:	45c1                	li	a1,16
    80000652:	6388                	ld	a0,0(a5)
    80000654:	e1dff0ef          	jal	80000470 <printint>
      i += 2;
    80000658:	0039049b          	addiw	s1,s2,3
    8000065c:	bf21                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000065e:	f8843783          	ld	a5,-120(s0)
    80000662:	00878713          	addi	a4,a5,8
    80000666:	f8e43423          	sd	a4,-120(s0)
    8000066a:	4605                	li	a2,1
    8000066c:	45a9                	li	a1,10
    8000066e:	6388                	ld	a0,0(a5)
    80000670:	e01ff0ef          	jal	80000470 <printint>
      i += 2;
    80000674:	0039049b          	addiw	s1,s2,3
    80000678:	bdf5                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    8000067a:	f8843783          	ld	a5,-120(s0)
    8000067e:	00878713          	addi	a4,a5,8
    80000682:	f8e43423          	sd	a4,-120(s0)
    80000686:	4601                	li	a2,0
    80000688:	45a9                	li	a1,10
    8000068a:	0007e503          	lwu	a0,0(a5)
    8000068e:	de3ff0ef          	jal	80000470 <printint>
    80000692:	b5cd                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80000694:	f8843783          	ld	a5,-120(s0)
    80000698:	00878713          	addi	a4,a5,8
    8000069c:	f8e43423          	sd	a4,-120(s0)
    800006a0:	4601                	li	a2,0
    800006a2:	45a9                	li	a1,10
    800006a4:	6388                	ld	a0,0(a5)
    800006a6:	dcbff0ef          	jal	80000470 <printint>
      i += 1;
    800006aa:	0029049b          	addiw	s1,s2,2
    800006ae:	b5d9                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	4601                	li	a2,0
    800006be:	45a9                	li	a1,10
    800006c0:	6388                	ld	a0,0(a5)
    800006c2:	dafff0ef          	jal	80000470 <printint>
      i += 2;
    800006c6:	0039049b          	addiw	s1,s2,3
    800006ca:	b56d                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    800006cc:	f8843783          	ld	a5,-120(s0)
    800006d0:	00878713          	addi	a4,a5,8
    800006d4:	f8e43423          	sd	a4,-120(s0)
    800006d8:	4601                	li	a2,0
    800006da:	45c1                	li	a1,16
    800006dc:	0007e503          	lwu	a0,0(a5)
    800006e0:	d91ff0ef          	jal	80000470 <printint>
    800006e4:	bd41                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    800006e6:	f8843783          	ld	a5,-120(s0)
    800006ea:	00878713          	addi	a4,a5,8
    800006ee:	f8e43423          	sd	a4,-120(s0)
    800006f2:	4601                	li	a2,0
    800006f4:	45c1                	li	a1,16
    800006f6:	6388                	ld	a0,0(a5)
    800006f8:	d79ff0ef          	jal	80000470 <printint>
      i += 1;
    800006fc:	0029049b          	addiw	s1,s2,2
    80000700:	bd95                	j	80000574 <printf+0x7a>
    80000702:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80000704:	f8843783          	ld	a5,-120(s0)
    80000708:	00878713          	addi	a4,a5,8
    8000070c:	f8e43423          	sd	a4,-120(s0)
    80000710:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80000714:	03000513          	li	a0,48
    80000718:	b63ff0ef          	jal	8000027a <consputc>
  consputc('x');
    8000071c:	07800513          	li	a0,120
    80000720:	b5bff0ef          	jal	8000027a <consputc>
    80000724:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000726:	00008b97          	auipc	s7,0x8
    8000072a:	0b2b8b93          	addi	s7,s7,178 # 800087d8 <digits>
    8000072e:	03c9d793          	srli	a5,s3,0x3c
    80000732:	97de                	add	a5,a5,s7
    80000734:	0007c503          	lbu	a0,0(a5)
    80000738:	b43ff0ef          	jal	8000027a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000073c:	0992                	slli	s3,s3,0x4
    8000073e:	397d                	addiw	s2,s2,-1
    80000740:	fe0917e3          	bnez	s2,8000072e <printf+0x234>
    80000744:	7be2                	ld	s7,56(sp)
    80000746:	b53d                	j	80000574 <printf+0x7a>
      consputc(va_arg(ap, uint));
    80000748:	f8843783          	ld	a5,-120(s0)
    8000074c:	00878713          	addi	a4,a5,8
    80000750:	f8e43423          	sd	a4,-120(s0)
    80000754:	4388                	lw	a0,0(a5)
    80000756:	b25ff0ef          	jal	8000027a <consputc>
    8000075a:	bd29                	j	80000574 <printf+0x7a>
      if((s = va_arg(ap, char*)) == 0)
    8000075c:	f8843783          	ld	a5,-120(s0)
    80000760:	00878713          	addi	a4,a5,8
    80000764:	f8e43423          	sd	a4,-120(s0)
    80000768:	0007b903          	ld	s2,0(a5)
    8000076c:	00090d63          	beqz	s2,80000786 <printf+0x28c>
      for(; *s; s++)
    80000770:	00094503          	lbu	a0,0(s2)
    80000774:	e00500e3          	beqz	a0,80000574 <printf+0x7a>
        consputc(*s);
    80000778:	b03ff0ef          	jal	8000027a <consputc>
      for(; *s; s++)
    8000077c:	0905                	addi	s2,s2,1
    8000077e:	00094503          	lbu	a0,0(s2)
    80000782:	f97d                	bnez	a0,80000778 <printf+0x27e>
    80000784:	bbc5                	j	80000574 <printf+0x7a>
        s = "(null)";
    80000786:	00008917          	auipc	s2,0x8
    8000078a:	88290913          	addi	s2,s2,-1918 # 80008008 <etext+0x8>
      for(; *s; s++)
    8000078e:	02800513          	li	a0,40
    80000792:	b7dd                	j	80000778 <printf+0x27e>
    80000794:	74a6                	ld	s1,104(sp)
    80000796:	7906                	ld	s2,96(sp)
    80000798:	69e6                	ld	s3,88(sp)
    8000079a:	6aa6                	ld	s5,72(sp)
    8000079c:	6b06                	ld	s6,64(sp)
    8000079e:	7c42                	ld	s8,48(sp)
    800007a0:	7ca2                	ld	s9,40(sp)
    800007a2:	7d02                	ld	s10,32(sp)
    800007a4:	6de2                	ld	s11,24(sp)
    800007a6:	a811                	j	800007ba <printf+0x2c0>
    800007a8:	74a6                	ld	s1,104(sp)
    800007aa:	7906                	ld	s2,96(sp)
    800007ac:	69e6                	ld	s3,88(sp)
    800007ae:	6aa6                	ld	s5,72(sp)
    800007b0:	6b06                	ld	s6,64(sp)
    800007b2:	7c42                	ld	s8,48(sp)
    800007b4:	7ca2                	ld	s9,40(sp)
    800007b6:	7d02                	ld	s10,32(sp)
    800007b8:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    800007ba:	00008797          	auipc	a5,0x8
    800007be:	1aa7a783          	lw	a5,426(a5) # 80008964 <panicking>
    800007c2:	c799                	beqz	a5,800007d0 <printf+0x2d6>
    release(&pr.lock);

  return 0;
}
    800007c4:	4501                	li	a0,0
    800007c6:	70e6                	ld	ra,120(sp)
    800007c8:	7446                	ld	s0,112(sp)
    800007ca:	6a46                	ld	s4,80(sp)
    800007cc:	6129                	addi	sp,sp,192
    800007ce:	8082                	ret
    release(&pr.lock);
    800007d0:	00010517          	auipc	a0,0x10
    800007d4:	27850513          	addi	a0,a0,632 # 80010a48 <pr>
    800007d8:	4b2000ef          	jal	80000c8a <release>
  return 0;
    800007dc:	b7e5                	j	800007c4 <printf+0x2ca>

00000000800007de <panic>:

void
panic(char *s)
{
    800007de:	1101                	addi	sp,sp,-32
    800007e0:	ec06                	sd	ra,24(sp)
    800007e2:	e822                	sd	s0,16(sp)
    800007e4:	e426                	sd	s1,8(sp)
    800007e6:	e04a                	sd	s2,0(sp)
    800007e8:	1000                	addi	s0,sp,32
    800007ea:	84aa                	mv	s1,a0
  panicking = 1;
    800007ec:	4905                	li	s2,1
    800007ee:	00008797          	auipc	a5,0x8
    800007f2:	1727ab23          	sw	s2,374(a5) # 80008964 <panicking>
  printf("panic: ");
    800007f6:	00008517          	auipc	a0,0x8
    800007fa:	82250513          	addi	a0,a0,-2014 # 80008018 <etext+0x18>
    800007fe:	cfdff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000802:	85a6                	mv	a1,s1
    80000804:	00008517          	auipc	a0,0x8
    80000808:	81c50513          	addi	a0,a0,-2020 # 80008020 <etext+0x20>
    8000080c:	cefff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000810:	00008797          	auipc	a5,0x8
    80000814:	1527a823          	sw	s2,336(a5) # 80008960 <panicked>
  for(;;)
    80000818:	a001                	j	80000818 <panic+0x3a>

000000008000081a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000081a:	1141                	addi	sp,sp,-16
    8000081c:	e406                	sd	ra,8(sp)
    8000081e:	e022                	sd	s0,0(sp)
    80000820:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000822:	00008597          	auipc	a1,0x8
    80000826:	80658593          	addi	a1,a1,-2042 # 80008028 <etext+0x28>
    8000082a:	00010517          	auipc	a0,0x10
    8000082e:	21e50513          	addi	a0,a0,542 # 80010a48 <pr>
    80000832:	340000ef          	jal	80000b72 <initlock>
}
    80000836:	60a2                	ld	ra,8(sp)
    80000838:	6402                	ld	s0,0(sp)
    8000083a:	0141                	addi	sp,sp,16
    8000083c:	8082                	ret

000000008000083e <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    8000083e:	1141                	addi	sp,sp,-16
    80000840:	e406                	sd	ra,8(sp)
    80000842:	e022                	sd	s0,0(sp)
    80000844:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000846:	100007b7          	lui	a5,0x10000
    8000084a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000084e:	10000737          	lui	a4,0x10000
    80000852:	f8000693          	li	a3,-128
    80000856:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000085a:	468d                	li	a3,3
    8000085c:	10000637          	lui	a2,0x10000
    80000860:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000864:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000868:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000086c:	8732                	mv	a4,a2
    8000086e:	461d                	li	a2,7
    80000870:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000874:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80000878:	00007597          	auipc	a1,0x7
    8000087c:	7b858593          	addi	a1,a1,1976 # 80008030 <etext+0x30>
    80000880:	00010517          	auipc	a0,0x10
    80000884:	1e050513          	addi	a0,a0,480 # 80010a60 <tx_lock>
    80000888:	2ea000ef          	jal	80000b72 <initlock>
}
    8000088c:	60a2                	ld	ra,8(sp)
    8000088e:	6402                	ld	s0,0(sp)
    80000890:	0141                	addi	sp,sp,16
    80000892:	8082                	ret

0000000080000894 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80000894:	715d                	addi	sp,sp,-80
    80000896:	e486                	sd	ra,72(sp)
    80000898:	e0a2                	sd	s0,64(sp)
    8000089a:	fc26                	sd	s1,56(sp)
    8000089c:	ec56                	sd	s5,24(sp)
    8000089e:	0880                	addi	s0,sp,80
    800008a0:	8aaa                	mv	s5,a0
    800008a2:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800008a4:	00010517          	auipc	a0,0x10
    800008a8:	1bc50513          	addi	a0,a0,444 # 80010a60 <tx_lock>
    800008ac:	34a000ef          	jal	80000bf6 <acquire>

  int i = 0;
  while(i < n){ 
    800008b0:	06905063          	blez	s1,80000910 <uartwrite+0x7c>
    800008b4:	f84a                	sd	s2,48(sp)
    800008b6:	f44e                	sd	s3,40(sp)
    800008b8:	f052                	sd	s4,32(sp)
    800008ba:	e85a                	sd	s6,16(sp)
    800008bc:	e45e                	sd	s7,8(sp)
    800008be:	8a56                	mv	s4,s5
    800008c0:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    800008c2:	00008497          	auipc	s1,0x8
    800008c6:	0aa48493          	addi	s1,s1,170 # 8000896c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    800008ca:	00010997          	auipc	s3,0x10
    800008ce:	19698993          	addi	s3,s3,406 # 80010a60 <tx_lock>
    800008d2:	00008917          	auipc	s2,0x8
    800008d6:	09690913          	addi	s2,s2,150 # 80008968 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    800008da:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    800008de:	4b05                	li	s6,1
    800008e0:	a005                	j	80000900 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    800008e2:	85ce                	mv	a1,s3
    800008e4:	854a                	mv	a0,s2
    800008e6:	638010ef          	jal	80001f1e <sleep>
    while(tx_busy != 0){
    800008ea:	409c                	lw	a5,0(s1)
    800008ec:	fbfd                	bnez	a5,800008e2 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    800008ee:	000a4783          	lbu	a5,0(s4)
    800008f2:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    800008f6:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    800008fa:	0a05                	addi	s4,s4,1
    800008fc:	015a0563          	beq	s4,s5,80000906 <uartwrite+0x72>
    while(tx_busy != 0){
    80000900:	409c                	lw	a5,0(s1)
    80000902:	f3e5                	bnez	a5,800008e2 <uartwrite+0x4e>
    80000904:	b7ed                	j	800008ee <uartwrite+0x5a>
    80000906:	7942                	ld	s2,48(sp)
    80000908:	79a2                	ld	s3,40(sp)
    8000090a:	7a02                	ld	s4,32(sp)
    8000090c:	6b42                	ld	s6,16(sp)
    8000090e:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80000910:	00010517          	auipc	a0,0x10
    80000914:	15050513          	addi	a0,a0,336 # 80010a60 <tx_lock>
    80000918:	372000ef          	jal	80000c8a <release>
}
    8000091c:	60a6                	ld	ra,72(sp)
    8000091e:	6406                	ld	s0,64(sp)
    80000920:	74e2                	ld	s1,56(sp)
    80000922:	6ae2                	ld	s5,24(sp)
    80000924:	6161                	addi	sp,sp,80
    80000926:	8082                	ret

0000000080000928 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000928:	1101                	addi	sp,sp,-32
    8000092a:	ec06                	sd	ra,24(sp)
    8000092c:	e822                	sd	s0,16(sp)
    8000092e:	e426                	sd	s1,8(sp)
    80000930:	1000                	addi	s0,sp,32
    80000932:	84aa                	mv	s1,a0
  if(panicking == 0)
    80000934:	00008797          	auipc	a5,0x8
    80000938:	0307a783          	lw	a5,48(a5) # 80008964 <panicking>
    8000093c:	cf95                	beqz	a5,80000978 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    8000093e:	00008797          	auipc	a5,0x8
    80000942:	0227a783          	lw	a5,34(a5) # 80008960 <panicked>
    80000946:	ef85                	bnez	a5,8000097e <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000948:	10000737          	lui	a4,0x10000
    8000094c:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000094e:	00074783          	lbu	a5,0(a4)
    80000952:	0207f793          	andi	a5,a5,32
    80000956:	dfe5                	beqz	a5,8000094e <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80000958:	0ff4f513          	zext.b	a0,s1
    8000095c:	100007b7          	lui	a5,0x10000
    80000960:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80000964:	00008797          	auipc	a5,0x8
    80000968:	0007a783          	lw	a5,0(a5) # 80008964 <panicking>
    8000096c:	cb91                	beqz	a5,80000980 <uartputc_sync+0x58>
    pop_off();
}
    8000096e:	60e2                	ld	ra,24(sp)
    80000970:	6442                	ld	s0,16(sp)
    80000972:	64a2                	ld	s1,8(sp)
    80000974:	6105                	addi	sp,sp,32
    80000976:	8082                	ret
    push_off();
    80000978:	23e000ef          	jal	80000bb6 <push_off>
    8000097c:	b7c9                	j	8000093e <uartputc_sync+0x16>
    for(;;)
    8000097e:	a001                	j	8000097e <uartputc_sync+0x56>
    pop_off();
    80000980:	2ba000ef          	jal	80000c3a <pop_off>
}
    80000984:	b7ed                	j	8000096e <uartputc_sync+0x46>

0000000080000986 <uartgetc>:

// try to read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000986:	1141                	addi	sp,sp,-16
    80000988:	e406                	sd	ra,8(sp)
    8000098a:	e022                	sd	s0,0(sp)
    8000098c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    8000098e:	100007b7          	lui	a5,0x10000
    80000992:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000996:	8b85                	andi	a5,a5,1
    80000998:	cb89                	beqz	a5,800009aa <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000099a:	100007b7          	lui	a5,0x10000
    8000099e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009a2:	60a2                	ld	ra,8(sp)
    800009a4:	6402                	ld	s0,0(sp)
    800009a6:	0141                	addi	sp,sp,16
    800009a8:	8082                	ret
    return -1;
    800009aa:	557d                	li	a0,-1
    800009ac:	bfdd                	j	800009a2 <uartgetc+0x1c>

00000000800009ae <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009ae:	7179                	addi	sp,sp,-48
    800009b0:	f406                	sd	ra,40(sp)
    800009b2:	f022                	sd	s0,32(sp)
    800009b4:	ec26                	sd	s1,24(sp)
    800009b6:	e84a                	sd	s2,16(sp)
    800009b8:	e44e                	sd	s3,8(sp)
    800009ba:	e052                	sd	s4,0(sp)
    800009bc:	1800                	addi	s0,sp,48
  ReadReg(ISR); // acknowledge the interrupt
    800009be:	100007b7          	lui	a5,0x10000
    800009c2:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    800009c6:	00010517          	auipc	a0,0x10
    800009ca:	09a50513          	addi	a0,a0,154 # 80010a60 <tx_lock>
    800009ce:	228000ef          	jal	80000bf6 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    800009d2:	100007b7          	lui	a5,0x10000
    800009d6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009da:	0207f793          	andi	a5,a5,32
    800009de:	ef99                	bnez	a5,800009fc <uartintr+0x4e>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    800009e0:	00010517          	auipc	a0,0x10
    800009e4:	08050513          	addi	a0,a0,128 # 80010a60 <tx_lock>
    800009e8:	2a2000ef          	jal	80000c8a <release>
    // Your code here.
    //
    // intercept "!" and send "echo Hello World " to the console
    // instead of the "!" character.
    //
    if (c=='!') {
    800009ec:	02100493          	li	s1,33
      continue;
    }
    


    if(c == -1)
    800009f0:	597d                	li	s2,-1
      consoleintr('1');
    800009f2:	03100a13          	li	s4,49
      consoleintr('2');
    800009f6:	03200993          	li	s3,50
    800009fa:	a015                	j	80000a1e <uartintr+0x70>
    tx_busy = 0;
    800009fc:	00008797          	auipc	a5,0x8
    80000a00:	f607a823          	sw	zero,-144(a5) # 8000896c <tx_busy>
    wakeup(&tx_chan);
    80000a04:	00008517          	auipc	a0,0x8
    80000a08:	f6450513          	addi	a0,a0,-156 # 80008968 <tx_chan>
    80000a0c:	55e010ef          	jal	80001f6a <wakeup>
    80000a10:	bfc1                	j	800009e0 <uartintr+0x32>
      consoleintr('1');
    80000a12:	8552                	mv	a0,s4
    80000a14:	899ff0ef          	jal	800002ac <consoleintr>
      consoleintr('2');
    80000a18:	854e                	mv	a0,s3
    80000a1a:	893ff0ef          	jal	800002ac <consoleintr>
    int c = uartgetc();
    80000a1e:	f69ff0ef          	jal	80000986 <uartgetc>
    if (c=='!') {
    80000a22:	fe9508e3          	beq	a0,s1,80000a12 <uartintr+0x64>
    if(c == -1)
    80000a26:	01250563          	beq	a0,s2,80000a30 <uartintr+0x82>
      break;
    consoleintr(c);
    80000a2a:	883ff0ef          	jal	800002ac <consoleintr>
    80000a2e:	bfc5                	j	80000a1e <uartintr+0x70>
  }
}
    80000a30:	70a2                	ld	ra,40(sp)
    80000a32:	7402                	ld	s0,32(sp)
    80000a34:	64e2                	ld	s1,24(sp)
    80000a36:	6942                	ld	s2,16(sp)
    80000a38:	69a2                	ld	s3,8(sp)
    80000a3a:	6a02                	ld	s4,0(sp)
    80000a3c:	6145                	addi	sp,sp,48
    80000a3e:	8082                	ret

0000000080000a40 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a40:	1101                	addi	sp,sp,-32
    80000a42:	ec06                	sd	ra,24(sp)
    80000a44:	e822                	sd	s0,16(sp)
    80000a46:	e426                	sd	s1,8(sp)
    80000a48:	e04a                	sd	s2,0(sp)
    80000a4a:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a4c:	03451793          	slli	a5,a0,0x34
    80000a50:	e7a9                	bnez	a5,80000a9a <kfree+0x5a>
    80000a52:	84aa                	mv	s1,a0
    80000a54:	00022797          	auipc	a5,0x22
    80000a58:	f1478793          	addi	a5,a5,-236 # 80022968 <end>
    80000a5c:	02f56f63          	bltu	a0,a5,80000a9a <kfree+0x5a>
    80000a60:	47c5                	li	a5,17
    80000a62:	07ee                	slli	a5,a5,0x1b
    80000a64:	02f57b63          	bgeu	a0,a5,80000a9a <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a68:	6605                	lui	a2,0x1
    80000a6a:	4585                	li	a1,1
    80000a6c:	25a000ef          	jal	80000cc6 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a70:	00010917          	auipc	s2,0x10
    80000a74:	00890913          	addi	s2,s2,8 # 80010a78 <kmem>
    80000a78:	854a                	mv	a0,s2
    80000a7a:	17c000ef          	jal	80000bf6 <acquire>
  r->next = kmem.freelist;
    80000a7e:	01893783          	ld	a5,24(s2)
    80000a82:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a84:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a88:	854a                	mv	a0,s2
    80000a8a:	200000ef          	jal	80000c8a <release>
}
    80000a8e:	60e2                	ld	ra,24(sp)
    80000a90:	6442                	ld	s0,16(sp)
    80000a92:	64a2                	ld	s1,8(sp)
    80000a94:	6902                	ld	s2,0(sp)
    80000a96:	6105                	addi	sp,sp,32
    80000a98:	8082                	ret
    panic("kfree");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	59e50513          	addi	a0,a0,1438 # 80008038 <etext+0x38>
    80000aa2:	d3dff0ef          	jal	800007de <panic>

0000000080000aa6 <freerange>:
{
    80000aa6:	7179                	addi	sp,sp,-48
    80000aa8:	f406                	sd	ra,40(sp)
    80000aaa:	f022                	sd	s0,32(sp)
    80000aac:	ec26                	sd	s1,24(sp)
    80000aae:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab0:	6785                	lui	a5,0x1
    80000ab2:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab6:	00e504b3          	add	s1,a0,a4
    80000aba:	777d                	lui	a4,0xfffff
    80000abc:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000abe:	94be                	add	s1,s1,a5
    80000ac0:	0295e263          	bltu	a1,s1,80000ae4 <freerange+0x3e>
    80000ac4:	e84a                	sd	s2,16(sp)
    80000ac6:	e44e                	sd	s3,8(sp)
    80000ac8:	e052                	sd	s4,0(sp)
    80000aca:	892e                	mv	s2,a1
    kfree(p);
    80000acc:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ace:	89be                	mv	s3,a5
    kfree(p);
    80000ad0:	01448533          	add	a0,s1,s4
    80000ad4:	f6dff0ef          	jal	80000a40 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad8:	94ce                	add	s1,s1,s3
    80000ada:	fe997be3          	bgeu	s2,s1,80000ad0 <freerange+0x2a>
    80000ade:	6942                	ld	s2,16(sp)
    80000ae0:	69a2                	ld	s3,8(sp)
    80000ae2:	6a02                	ld	s4,0(sp)
}
    80000ae4:	70a2                	ld	ra,40(sp)
    80000ae6:	7402                	ld	s0,32(sp)
    80000ae8:	64e2                	ld	s1,24(sp)
    80000aea:	6145                	addi	sp,sp,48
    80000aec:	8082                	ret

0000000080000aee <kinit>:
{
    80000aee:	1141                	addi	sp,sp,-16
    80000af0:	e406                	sd	ra,8(sp)
    80000af2:	e022                	sd	s0,0(sp)
    80000af4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af6:	00007597          	auipc	a1,0x7
    80000afa:	54a58593          	addi	a1,a1,1354 # 80008040 <etext+0x40>
    80000afe:	00010517          	auipc	a0,0x10
    80000b02:	f7a50513          	addi	a0,a0,-134 # 80010a78 <kmem>
    80000b06:	06c000ef          	jal	80000b72 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0a:	45c5                	li	a1,17
    80000b0c:	05ee                	slli	a1,a1,0x1b
    80000b0e:	00022517          	auipc	a0,0x22
    80000b12:	e5a50513          	addi	a0,a0,-422 # 80022968 <end>
    80000b16:	f91ff0ef          	jal	80000aa6 <freerange>
}
    80000b1a:	60a2                	ld	ra,8(sp)
    80000b1c:	6402                	ld	s0,0(sp)
    80000b1e:	0141                	addi	sp,sp,16
    80000b20:	8082                	ret

0000000080000b22 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b22:	1101                	addi	sp,sp,-32
    80000b24:	ec06                	sd	ra,24(sp)
    80000b26:	e822                	sd	s0,16(sp)
    80000b28:	e426                	sd	s1,8(sp)
    80000b2a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2c:	00010497          	auipc	s1,0x10
    80000b30:	f4c48493          	addi	s1,s1,-180 # 80010a78 <kmem>
    80000b34:	8526                	mv	a0,s1
    80000b36:	0c0000ef          	jal	80000bf6 <acquire>
  r = kmem.freelist;
    80000b3a:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3c:	c485                	beqz	s1,80000b64 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b3e:	609c                	ld	a5,0(s1)
    80000b40:	00010517          	auipc	a0,0x10
    80000b44:	f3850513          	addi	a0,a0,-200 # 80010a78 <kmem>
    80000b48:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4a:	140000ef          	jal	80000c8a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b4e:	6605                	lui	a2,0x1
    80000b50:	4595                	li	a1,5
    80000b52:	8526                	mv	a0,s1
    80000b54:	172000ef          	jal	80000cc6 <memset>
  return (void*)r;
}
    80000b58:	8526                	mv	a0,s1
    80000b5a:	60e2                	ld	ra,24(sp)
    80000b5c:	6442                	ld	s0,16(sp)
    80000b5e:	64a2                	ld	s1,8(sp)
    80000b60:	6105                	addi	sp,sp,32
    80000b62:	8082                	ret
  release(&kmem.lock);
    80000b64:	00010517          	auipc	a0,0x10
    80000b68:	f1450513          	addi	a0,a0,-236 # 80010a78 <kmem>
    80000b6c:	11e000ef          	jal	80000c8a <release>
  if(r)
    80000b70:	b7e5                	j	80000b58 <kalloc+0x36>

0000000080000b72 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b72:	1141                	addi	sp,sp,-16
    80000b74:	e406                	sd	ra,8(sp)
    80000b76:	e022                	sd	s0,0(sp)
    80000b78:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b80:	00053823          	sd	zero,16(a0)
}
    80000b84:	60a2                	ld	ra,8(sp)
    80000b86:	6402                	ld	s0,0(sp)
    80000b88:	0141                	addi	sp,sp,16
    80000b8a:	8082                	ret

0000000080000b8c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8c:	411c                	lw	a5,0(a0)
    80000b8e:	e399                	bnez	a5,80000b94 <holding+0x8>
    80000b90:	4501                	li	a0,0
  return r;
}
    80000b92:	8082                	ret
{
    80000b94:	1101                	addi	sp,sp,-32
    80000b96:	ec06                	sd	ra,24(sp)
    80000b98:	e822                	sd	s0,16(sp)
    80000b9a:	e426                	sd	s1,8(sp)
    80000b9c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9e:	6904                	ld	s1,16(a0)
    80000ba0:	555000ef          	jal	800018f4 <mycpu>
    80000ba4:	40a48533          	sub	a0,s1,a0
    80000ba8:	00153513          	seqz	a0,a0
}
    80000bac:	60e2                	ld	ra,24(sp)
    80000bae:	6442                	ld	s0,16(sp)
    80000bb0:	64a2                	ld	s1,8(sp)
    80000bb2:	6105                	addi	sp,sp,32
    80000bb4:	8082                	ret

0000000080000bb6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb6:	1101                	addi	sp,sp,-32
    80000bb8:	ec06                	sd	ra,24(sp)
    80000bba:	e822                	sd	s0,16(sp)
    80000bbc:	e426                	sd	s1,8(sp)
    80000bbe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bc0:	100024f3          	csrr	s1,sstatus
    80000bc4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bca:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000bce:	527000ef          	jal	800018f4 <mycpu>
    80000bd2:	5d3c                	lw	a5,120(a0)
    80000bd4:	cb99                	beqz	a5,80000bea <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd6:	51f000ef          	jal	800018f4 <mycpu>
    80000bda:	5d3c                	lw	a5,120(a0)
    80000bdc:	2785                	addiw	a5,a5,1
    80000bde:	dd3c                	sw	a5,120(a0)
}
    80000be0:	60e2                	ld	ra,24(sp)
    80000be2:	6442                	ld	s0,16(sp)
    80000be4:	64a2                	ld	s1,8(sp)
    80000be6:	6105                	addi	sp,sp,32
    80000be8:	8082                	ret
    mycpu()->intena = old;
    80000bea:	50b000ef          	jal	800018f4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bee:	8085                	srli	s1,s1,0x1
    80000bf0:	8885                	andi	s1,s1,1
    80000bf2:	dd64                	sw	s1,124(a0)
    80000bf4:	b7cd                	j	80000bd6 <push_off+0x20>

0000000080000bf6 <acquire>:
{
    80000bf6:	1101                	addi	sp,sp,-32
    80000bf8:	ec06                	sd	ra,24(sp)
    80000bfa:	e822                	sd	s0,16(sp)
    80000bfc:	e426                	sd	s1,8(sp)
    80000bfe:	1000                	addi	s0,sp,32
    80000c00:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c02:	fb5ff0ef          	jal	80000bb6 <push_off>
  if(holding(lk))
    80000c06:	8526                	mv	a0,s1
    80000c08:	f85ff0ef          	jal	80000b8c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0c:	4705                	li	a4,1
  if(holding(lk))
    80000c0e:	e105                	bnez	a0,80000c2e <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c10:	87ba                	mv	a5,a4
    80000c12:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c16:	2781                	sext.w	a5,a5
    80000c18:	ffe5                	bnez	a5,80000c10 <acquire+0x1a>
  __sync_synchronize();
    80000c1a:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c1e:	4d7000ef          	jal	800018f4 <mycpu>
    80000c22:	e888                	sd	a0,16(s1)
}
    80000c24:	60e2                	ld	ra,24(sp)
    80000c26:	6442                	ld	s0,16(sp)
    80000c28:	64a2                	ld	s1,8(sp)
    80000c2a:	6105                	addi	sp,sp,32
    80000c2c:	8082                	ret
    panic("acquire");
    80000c2e:	00007517          	auipc	a0,0x7
    80000c32:	41a50513          	addi	a0,a0,1050 # 80008048 <etext+0x48>
    80000c36:	ba9ff0ef          	jal	800007de <panic>

0000000080000c3a <pop_off>:

void
pop_off(void)
{
    80000c3a:	1141                	addi	sp,sp,-16
    80000c3c:	e406                	sd	ra,8(sp)
    80000c3e:	e022                	sd	s0,0(sp)
    80000c40:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c42:	4b3000ef          	jal	800018f4 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c46:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c4a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c4c:	e39d                	bnez	a5,80000c72 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4e:	5d3c                	lw	a5,120(a0)
    80000c50:	02f05763          	blez	a5,80000c7e <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80000c54:	37fd                	addiw	a5,a5,-1
    80000c56:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c58:	eb89                	bnez	a5,80000c6a <pop_off+0x30>
    80000c5a:	5d7c                	lw	a5,124(a0)
    80000c5c:	c799                	beqz	a5,80000c6a <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c5e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c62:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c66:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6a:	60a2                	ld	ra,8(sp)
    80000c6c:	6402                	ld	s0,0(sp)
    80000c6e:	0141                	addi	sp,sp,16
    80000c70:	8082                	ret
    panic("pop_off - interruptible");
    80000c72:	00007517          	auipc	a0,0x7
    80000c76:	3de50513          	addi	a0,a0,990 # 80008050 <etext+0x50>
    80000c7a:	b65ff0ef          	jal	800007de <panic>
    panic("pop_off");
    80000c7e:	00007517          	auipc	a0,0x7
    80000c82:	3ea50513          	addi	a0,a0,1002 # 80008068 <etext+0x68>
    80000c86:	b59ff0ef          	jal	800007de <panic>

0000000080000c8a <release>:
{
    80000c8a:	1101                	addi	sp,sp,-32
    80000c8c:	ec06                	sd	ra,24(sp)
    80000c8e:	e822                	sd	s0,16(sp)
    80000c90:	e426                	sd	s1,8(sp)
    80000c92:	1000                	addi	s0,sp,32
    80000c94:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c96:	ef7ff0ef          	jal	80000b8c <holding>
    80000c9a:	c105                	beqz	a0,80000cba <release+0x30>
  lk->cpu = 0;
    80000c9c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca0:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000ca4:	0310000f          	fence	rw,w
    80000ca8:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cac:	f8fff0ef          	jal	80000c3a <pop_off>
}
    80000cb0:	60e2                	ld	ra,24(sp)
    80000cb2:	6442                	ld	s0,16(sp)
    80000cb4:	64a2                	ld	s1,8(sp)
    80000cb6:	6105                	addi	sp,sp,32
    80000cb8:	8082                	ret
    panic("release");
    80000cba:	00007517          	auipc	a0,0x7
    80000cbe:	3b650513          	addi	a0,a0,950 # 80008070 <etext+0x70>
    80000cc2:	b1dff0ef          	jal	800007de <panic>

0000000080000cc6 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cc6:	1141                	addi	sp,sp,-16
    80000cc8:	e406                	sd	ra,8(sp)
    80000cca:	e022                	sd	s0,0(sp)
    80000ccc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cce:	ca19                	beqz	a2,80000ce4 <memset+0x1e>
    80000cd0:	87aa                	mv	a5,a0
    80000cd2:	1602                	slli	a2,a2,0x20
    80000cd4:	9201                	srli	a2,a2,0x20
    80000cd6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cde:	0785                	addi	a5,a5,1
    80000ce0:	fee79de3          	bne	a5,a4,80000cda <memset+0x14>
  }
  return dst;
}
    80000ce4:	60a2                	ld	ra,8(sp)
    80000ce6:	6402                	ld	s0,0(sp)
    80000ce8:	0141                	addi	sp,sp,16
    80000cea:	8082                	ret

0000000080000cec <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cec:	1141                	addi	sp,sp,-16
    80000cee:	e406                	sd	ra,8(sp)
    80000cf0:	e022                	sd	s0,0(sp)
    80000cf2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf4:	ca0d                	beqz	a2,80000d26 <memcmp+0x3a>
    80000cf6:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cfa:	1682                	slli	a3,a3,0x20
    80000cfc:	9281                	srli	a3,a3,0x20
    80000cfe:	0685                	addi	a3,a3,1
    80000d00:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d02:	00054783          	lbu	a5,0(a0)
    80000d06:	0005c703          	lbu	a4,0(a1)
    80000d0a:	00e79863          	bne	a5,a4,80000d1a <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000d0e:	0505                	addi	a0,a0,1
    80000d10:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d12:	fed518e3          	bne	a0,a3,80000d02 <memcmp+0x16>
  }

  return 0;
    80000d16:	4501                	li	a0,0
    80000d18:	a019                	j	80000d1e <memcmp+0x32>
      return *s1 - *s2;
    80000d1a:	40e7853b          	subw	a0,a5,a4
}
    80000d1e:	60a2                	ld	ra,8(sp)
    80000d20:	6402                	ld	s0,0(sp)
    80000d22:	0141                	addi	sp,sp,16
    80000d24:	8082                	ret
  return 0;
    80000d26:	4501                	li	a0,0
    80000d28:	bfdd                	j	80000d1e <memcmp+0x32>

0000000080000d2a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d2a:	1141                	addi	sp,sp,-16
    80000d2c:	e406                	sd	ra,8(sp)
    80000d2e:	e022                	sd	s0,0(sp)
    80000d30:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d32:	c205                	beqz	a2,80000d52 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d34:	02a5e363          	bltu	a1,a0,80000d5a <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d38:	1602                	slli	a2,a2,0x20
    80000d3a:	9201                	srli	a2,a2,0x20
    80000d3c:	00c587b3          	add	a5,a1,a2
{
    80000d40:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d42:	0585                	addi	a1,a1,1
    80000d44:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdc699>
    80000d46:	fff5c683          	lbu	a3,-1(a1)
    80000d4a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d4e:	feb79ae3          	bne	a5,a1,80000d42 <memmove+0x18>

  return dst;
}
    80000d52:	60a2                	ld	ra,8(sp)
    80000d54:	6402                	ld	s0,0(sp)
    80000d56:	0141                	addi	sp,sp,16
    80000d58:	8082                	ret
  if(s < d && s + n > d){
    80000d5a:	02061693          	slli	a3,a2,0x20
    80000d5e:	9281                	srli	a3,a3,0x20
    80000d60:	00d58733          	add	a4,a1,a3
    80000d64:	fce57ae3          	bgeu	a0,a4,80000d38 <memmove+0xe>
    d += n;
    80000d68:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d6a:	fff6079b          	addiw	a5,a2,-1
    80000d6e:	1782                	slli	a5,a5,0x20
    80000d70:	9381                	srli	a5,a5,0x20
    80000d72:	fff7c793          	not	a5,a5
    80000d76:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d78:	177d                	addi	a4,a4,-1
    80000d7a:	16fd                	addi	a3,a3,-1
    80000d7c:	00074603          	lbu	a2,0(a4)
    80000d80:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d84:	fee79ae3          	bne	a5,a4,80000d78 <memmove+0x4e>
    80000d88:	b7e9                	j	80000d52 <memmove+0x28>

0000000080000d8a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d8a:	1141                	addi	sp,sp,-16
    80000d8c:	e406                	sd	ra,8(sp)
    80000d8e:	e022                	sd	s0,0(sp)
    80000d90:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d92:	f99ff0ef          	jal	80000d2a <memmove>
}
    80000d96:	60a2                	ld	ra,8(sp)
    80000d98:	6402                	ld	s0,0(sp)
    80000d9a:	0141                	addi	sp,sp,16
    80000d9c:	8082                	ret

0000000080000d9e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d9e:	1141                	addi	sp,sp,-16
    80000da0:	e406                	sd	ra,8(sp)
    80000da2:	e022                	sd	s0,0(sp)
    80000da4:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da6:	ce11                	beqz	a2,80000dc2 <strncmp+0x24>
    80000da8:	00054783          	lbu	a5,0(a0)
    80000dac:	cf89                	beqz	a5,80000dc6 <strncmp+0x28>
    80000dae:	0005c703          	lbu	a4,0(a1)
    80000db2:	00f71a63          	bne	a4,a5,80000dc6 <strncmp+0x28>
    n--, p++, q++;
    80000db6:	367d                	addiw	a2,a2,-1
    80000db8:	0505                	addi	a0,a0,1
    80000dba:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dbc:	f675                	bnez	a2,80000da8 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000dbe:	4501                	li	a0,0
    80000dc0:	a801                	j	80000dd0 <strncmp+0x32>
    80000dc2:	4501                	li	a0,0
    80000dc4:	a031                	j	80000dd0 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000dc6:	00054503          	lbu	a0,0(a0)
    80000dca:	0005c783          	lbu	a5,0(a1)
    80000dce:	9d1d                	subw	a0,a0,a5
}
    80000dd0:	60a2                	ld	ra,8(sp)
    80000dd2:	6402                	ld	s0,0(sp)
    80000dd4:	0141                	addi	sp,sp,16
    80000dd6:	8082                	ret

0000000080000dd8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dd8:	1141                	addi	sp,sp,-16
    80000dda:	e406                	sd	ra,8(sp)
    80000ddc:	e022                	sd	s0,0(sp)
    80000dde:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de0:	87aa                	mv	a5,a0
    80000de2:	86b2                	mv	a3,a2
    80000de4:	367d                	addiw	a2,a2,-1
    80000de6:	02d05563          	blez	a3,80000e10 <strncpy+0x38>
    80000dea:	0785                	addi	a5,a5,1
    80000dec:	0005c703          	lbu	a4,0(a1)
    80000df0:	fee78fa3          	sb	a4,-1(a5)
    80000df4:	0585                	addi	a1,a1,1
    80000df6:	f775                	bnez	a4,80000de2 <strncpy+0xa>
    ;
  while(n-- > 0)
    80000df8:	873e                	mv	a4,a5
    80000dfa:	00c05b63          	blez	a2,80000e10 <strncpy+0x38>
    80000dfe:	9fb5                	addw	a5,a5,a3
    80000e00:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e02:	0705                	addi	a4,a4,1
    80000e04:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e08:	40e786bb          	subw	a3,a5,a4
    80000e0c:	fed04be3          	bgtz	a3,80000e02 <strncpy+0x2a>
  return os;
}
    80000e10:	60a2                	ld	ra,8(sp)
    80000e12:	6402                	ld	s0,0(sp)
    80000e14:	0141                	addi	sp,sp,16
    80000e16:	8082                	ret

0000000080000e18 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e18:	1141                	addi	sp,sp,-16
    80000e1a:	e406                	sd	ra,8(sp)
    80000e1c:	e022                	sd	s0,0(sp)
    80000e1e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e20:	02c05363          	blez	a2,80000e46 <safestrcpy+0x2e>
    80000e24:	fff6069b          	addiw	a3,a2,-1
    80000e28:	1682                	slli	a3,a3,0x20
    80000e2a:	9281                	srli	a3,a3,0x20
    80000e2c:	96ae                	add	a3,a3,a1
    80000e2e:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e30:	00d58963          	beq	a1,a3,80000e42 <safestrcpy+0x2a>
    80000e34:	0585                	addi	a1,a1,1
    80000e36:	0785                	addi	a5,a5,1
    80000e38:	fff5c703          	lbu	a4,-1(a1)
    80000e3c:	fee78fa3          	sb	a4,-1(a5)
    80000e40:	fb65                	bnez	a4,80000e30 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e42:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e46:	60a2                	ld	ra,8(sp)
    80000e48:	6402                	ld	s0,0(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <strlen>:

int
strlen(const char *s)
{
    80000e4e:	1141                	addi	sp,sp,-16
    80000e50:	e406                	sd	ra,8(sp)
    80000e52:	e022                	sd	s0,0(sp)
    80000e54:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e56:	00054783          	lbu	a5,0(a0)
    80000e5a:	cf99                	beqz	a5,80000e78 <strlen+0x2a>
    80000e5c:	0505                	addi	a0,a0,1
    80000e5e:	87aa                	mv	a5,a0
    80000e60:	86be                	mv	a3,a5
    80000e62:	0785                	addi	a5,a5,1
    80000e64:	fff7c703          	lbu	a4,-1(a5)
    80000e68:	ff65                	bnez	a4,80000e60 <strlen+0x12>
    80000e6a:	40a6853b          	subw	a0,a3,a0
    80000e6e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e70:	60a2                	ld	ra,8(sp)
    80000e72:	6402                	ld	s0,0(sp)
    80000e74:	0141                	addi	sp,sp,16
    80000e76:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e78:	4501                	li	a0,0
    80000e7a:	bfdd                	j	80000e70 <strlen+0x22>

0000000080000e7c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e7c:	1141                	addi	sp,sp,-16
    80000e7e:	e406                	sd	ra,8(sp)
    80000e80:	e022                	sd	s0,0(sp)
    80000e82:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e84:	25d000ef          	jal	800018e0 <cpuid>
    netinit();       // initialize network
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e88:	00008717          	auipc	a4,0x8
    80000e8c:	ae870713          	addi	a4,a4,-1304 # 80008970 <started>
  if(cpuid() == 0){
    80000e90:	c51d                	beqz	a0,80000ebe <main+0x42>
    while(started == 0)
    80000e92:	431c                	lw	a5,0(a4)
    80000e94:	2781                	sext.w	a5,a5
    80000e96:	dff5                	beqz	a5,80000e92 <main+0x16>
      ;
    __sync_synchronize();
    80000e98:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000e9c:	245000ef          	jal	800018e0 <cpuid>
    80000ea0:	85aa                	mv	a1,a0
    80000ea2:	00007517          	auipc	a0,0x7
    80000ea6:	1f650513          	addi	a0,a0,502 # 80008098 <etext+0x98>
    80000eaa:	e50ff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000eae:	088000ef          	jal	80000f36 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eb2:	588010ef          	jal	8000243a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eb6:	5f6040ef          	jal	800054ac <plicinithart>
  }

  scheduler();        
    80000eba:	6cd000ef          	jal	80001d86 <scheduler>
    consoleinit();
    80000ebe:	d6eff0ef          	jal	8000042c <consoleinit>
    printfinit();
    80000ec2:	959ff0ef          	jal	8000081a <printfinit>
    printf("\n");
    80000ec6:	00007517          	auipc	a0,0x7
    80000eca:	1b250513          	addi	a0,a0,434 # 80008078 <etext+0x78>
    80000ece:	e2cff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000ed2:	00007517          	auipc	a0,0x7
    80000ed6:	1ae50513          	addi	a0,a0,430 # 80008080 <etext+0x80>
    80000eda:	e20ff0ef          	jal	800004fa <printf>
    printf("\n");
    80000ede:	00007517          	auipc	a0,0x7
    80000ee2:	19a50513          	addi	a0,a0,410 # 80008078 <etext+0x78>
    80000ee6:	e14ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000eea:	c05ff0ef          	jal	80000aee <kinit>
    kvminit();       // create kernel page table
    80000eee:	2fa000ef          	jal	800011e8 <kvminit>
    kvminithart();   // turn on paging
    80000ef2:	044000ef          	jal	80000f36 <kvminithart>
    procinit();      // process table
    80000ef6:	13b000ef          	jal	80001830 <procinit>
    trapinit();      // trap vectors
    80000efa:	51c010ef          	jal	80002416 <trapinit>
    trapinithart();  // install kernel trap vector
    80000efe:	53c010ef          	jal	8000243a <trapinithart>
    plicinit();      // set up interrupt controller
    80000f02:	57c040ef          	jal	8000547e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f06:	5a6040ef          	jal	800054ac <plicinithart>
    binit();         // buffer cache
    80000f0a:	419010ef          	jal	80002b22 <binit>
    iinit();         // inode table
    80000f0e:	178020ef          	jal	80003086 <iinit>
    fileinit();      // file table
    80000f12:	08a030ef          	jal	80003f9c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f16:	694040ef          	jal	800055aa <virtio_disk_init>
    pci_init();      // initialize PCI devices (e1000 network card)
    80000f1a:	570050ef          	jal	8000648a <pci_init>
    netinit();       // initialize network
    80000f1e:	4dd040ef          	jal	80005bfa <netinit>
    userinit();      // first user process
    80000f22:	4b9000ef          	jal	80001bda <userinit>
    __sync_synchronize();
    80000f26:	0330000f          	fence	rw,rw
    started = 1;
    80000f2a:	4785                	li	a5,1
    80000f2c:	00008717          	auipc	a4,0x8
    80000f30:	a4f72223          	sw	a5,-1468(a4) # 80008970 <started>
    80000f34:	b759                	j	80000eba <main+0x3e>

0000000080000f36 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f36:	1141                	addi	sp,sp,-16
    80000f38:	e406                	sd	ra,8(sp)
    80000f3a:	e022                	sd	s0,0(sp)
    80000f3c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f3e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f42:	00008797          	auipc	a5,0x8
    80000f46:	a367b783          	ld	a5,-1482(a5) # 80008978 <kernel_pagetable>
    80000f4a:	83b1                	srli	a5,a5,0xc
    80000f4c:	577d                	li	a4,-1
    80000f4e:	177e                	slli	a4,a4,0x3f
    80000f50:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f52:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f56:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f5a:	60a2                	ld	ra,8(sp)
    80000f5c:	6402                	ld	s0,0(sp)
    80000f5e:	0141                	addi	sp,sp,16
    80000f60:	8082                	ret

0000000080000f62 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f62:	7139                	addi	sp,sp,-64
    80000f64:	fc06                	sd	ra,56(sp)
    80000f66:	f822                	sd	s0,48(sp)
    80000f68:	f426                	sd	s1,40(sp)
    80000f6a:	f04a                	sd	s2,32(sp)
    80000f6c:	ec4e                	sd	s3,24(sp)
    80000f6e:	e852                	sd	s4,16(sp)
    80000f70:	e456                	sd	s5,8(sp)
    80000f72:	e05a                	sd	s6,0(sp)
    80000f74:	0080                	addi	s0,sp,64
    80000f76:	84aa                	mv	s1,a0
    80000f78:	89ae                	mv	s3,a1
    80000f7a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f7c:	57fd                	li	a5,-1
    80000f7e:	83e9                	srli	a5,a5,0x1a
    80000f80:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f82:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f84:	04b7e263          	bltu	a5,a1,80000fc8 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f88:	0149d933          	srl	s2,s3,s4
    80000f8c:	1ff97913          	andi	s2,s2,511
    80000f90:	090e                	slli	s2,s2,0x3
    80000f92:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f94:	00093483          	ld	s1,0(s2)
    80000f98:	0014f793          	andi	a5,s1,1
    80000f9c:	cf85                	beqz	a5,80000fd4 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f9e:	80a9                	srli	s1,s1,0xa
    80000fa0:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000fa2:	3a5d                	addiw	s4,s4,-9
    80000fa4:	ff6a12e3          	bne	s4,s6,80000f88 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000fa8:	00c9d513          	srli	a0,s3,0xc
    80000fac:	1ff57513          	andi	a0,a0,511
    80000fb0:	050e                	slli	a0,a0,0x3
    80000fb2:	9526                	add	a0,a0,s1
}
    80000fb4:	70e2                	ld	ra,56(sp)
    80000fb6:	7442                	ld	s0,48(sp)
    80000fb8:	74a2                	ld	s1,40(sp)
    80000fba:	7902                	ld	s2,32(sp)
    80000fbc:	69e2                	ld	s3,24(sp)
    80000fbe:	6a42                	ld	s4,16(sp)
    80000fc0:	6aa2                	ld	s5,8(sp)
    80000fc2:	6b02                	ld	s6,0(sp)
    80000fc4:	6121                	addi	sp,sp,64
    80000fc6:	8082                	ret
    panic("walk");
    80000fc8:	00007517          	auipc	a0,0x7
    80000fcc:	0e850513          	addi	a0,a0,232 # 800080b0 <etext+0xb0>
    80000fd0:	80fff0ef          	jal	800007de <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fd4:	020a8263          	beqz	s5,80000ff8 <walk+0x96>
    80000fd8:	b4bff0ef          	jal	80000b22 <kalloc>
    80000fdc:	84aa                	mv	s1,a0
    80000fde:	d979                	beqz	a0,80000fb4 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000fe0:	6605                	lui	a2,0x1
    80000fe2:	4581                	li	a1,0
    80000fe4:	ce3ff0ef          	jal	80000cc6 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fe8:	00c4d793          	srli	a5,s1,0xc
    80000fec:	07aa                	slli	a5,a5,0xa
    80000fee:	0017e793          	ori	a5,a5,1
    80000ff2:	00f93023          	sd	a5,0(s2)
    80000ff6:	b775                	j	80000fa2 <walk+0x40>
        return 0;
    80000ff8:	4501                	li	a0,0
    80000ffa:	bf6d                	j	80000fb4 <walk+0x52>

0000000080000ffc <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000ffc:	57fd                	li	a5,-1
    80000ffe:	83e9                	srli	a5,a5,0x1a
    80001000:	00b7f463          	bgeu	a5,a1,80001008 <walkaddr+0xc>
    return 0;
    80001004:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001006:	8082                	ret
{
    80001008:	1141                	addi	sp,sp,-16
    8000100a:	e406                	sd	ra,8(sp)
    8000100c:	e022                	sd	s0,0(sp)
    8000100e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001010:	4601                	li	a2,0
    80001012:	f51ff0ef          	jal	80000f62 <walk>
  if(pte == 0)
    80001016:	c105                	beqz	a0,80001036 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80001018:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000101a:	0117f693          	andi	a3,a5,17
    8000101e:	4745                	li	a4,17
    return 0;
    80001020:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001022:	00e68663          	beq	a3,a4,8000102e <walkaddr+0x32>
}
    80001026:	60a2                	ld	ra,8(sp)
    80001028:	6402                	ld	s0,0(sp)
    8000102a:	0141                	addi	sp,sp,16
    8000102c:	8082                	ret
  pa = PTE2PA(*pte);
    8000102e:	83a9                	srli	a5,a5,0xa
    80001030:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001034:	bfcd                	j	80001026 <walkaddr+0x2a>
    return 0;
    80001036:	4501                	li	a0,0
    80001038:	b7fd                	j	80001026 <walkaddr+0x2a>

000000008000103a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000103a:	715d                	addi	sp,sp,-80
    8000103c:	e486                	sd	ra,72(sp)
    8000103e:	e0a2                	sd	s0,64(sp)
    80001040:	fc26                	sd	s1,56(sp)
    80001042:	f84a                	sd	s2,48(sp)
    80001044:	f44e                	sd	s3,40(sp)
    80001046:	f052                	sd	s4,32(sp)
    80001048:	ec56                	sd	s5,24(sp)
    8000104a:	e85a                	sd	s6,16(sp)
    8000104c:	e45e                	sd	s7,8(sp)
    8000104e:	e062                	sd	s8,0(sp)
    80001050:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001052:	03459793          	slli	a5,a1,0x34
    80001056:	e7b1                	bnez	a5,800010a2 <mappages+0x68>
    80001058:	8aaa                	mv	s5,a0
    8000105a:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000105c:	03461793          	slli	a5,a2,0x34
    80001060:	e7b9                	bnez	a5,800010ae <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    80001062:	ce21                	beqz	a2,800010ba <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001064:	77fd                	lui	a5,0xfffff
    80001066:	963e                	add	a2,a2,a5
    80001068:	00b609b3          	add	s3,a2,a1
  a = va;
    8000106c:	892e                	mv	s2,a1
    8000106e:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001072:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001074:	6c05                	lui	s8,0x1
    80001076:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000107a:	865e                	mv	a2,s7
    8000107c:	85ca                	mv	a1,s2
    8000107e:	8556                	mv	a0,s5
    80001080:	ee3ff0ef          	jal	80000f62 <walk>
    80001084:	c539                	beqz	a0,800010d2 <mappages+0x98>
    if(*pte & PTE_V)
    80001086:	611c                	ld	a5,0(a0)
    80001088:	8b85                	andi	a5,a5,1
    8000108a:	ef95                	bnez	a5,800010c6 <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000108c:	80b1                	srli	s1,s1,0xc
    8000108e:	04aa                	slli	s1,s1,0xa
    80001090:	0164e4b3          	or	s1,s1,s6
    80001094:	0014e493          	ori	s1,s1,1
    80001098:	e104                	sd	s1,0(a0)
    if(a == last)
    8000109a:	05390963          	beq	s2,s3,800010ec <mappages+0xb2>
    a += PGSIZE;
    8000109e:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    800010a0:	bfd9                	j	80001076 <mappages+0x3c>
    panic("mappages: va not aligned");
    800010a2:	00007517          	auipc	a0,0x7
    800010a6:	01650513          	addi	a0,a0,22 # 800080b8 <etext+0xb8>
    800010aa:	f34ff0ef          	jal	800007de <panic>
    panic("mappages: size not aligned");
    800010ae:	00007517          	auipc	a0,0x7
    800010b2:	02a50513          	addi	a0,a0,42 # 800080d8 <etext+0xd8>
    800010b6:	f28ff0ef          	jal	800007de <panic>
    panic("mappages: size");
    800010ba:	00007517          	auipc	a0,0x7
    800010be:	03e50513          	addi	a0,a0,62 # 800080f8 <etext+0xf8>
    800010c2:	f1cff0ef          	jal	800007de <panic>
      panic("mappages: remap");
    800010c6:	00007517          	auipc	a0,0x7
    800010ca:	04250513          	addi	a0,a0,66 # 80008108 <etext+0x108>
    800010ce:	f10ff0ef          	jal	800007de <panic>
      return -1;
    800010d2:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010d4:	60a6                	ld	ra,72(sp)
    800010d6:	6406                	ld	s0,64(sp)
    800010d8:	74e2                	ld	s1,56(sp)
    800010da:	7942                	ld	s2,48(sp)
    800010dc:	79a2                	ld	s3,40(sp)
    800010de:	7a02                	ld	s4,32(sp)
    800010e0:	6ae2                	ld	s5,24(sp)
    800010e2:	6b42                	ld	s6,16(sp)
    800010e4:	6ba2                	ld	s7,8(sp)
    800010e6:	6c02                	ld	s8,0(sp)
    800010e8:	6161                	addi	sp,sp,80
    800010ea:	8082                	ret
  return 0;
    800010ec:	4501                	li	a0,0
    800010ee:	b7dd                	j	800010d4 <mappages+0x9a>

00000000800010f0 <kvmmap>:
{
    800010f0:	1141                	addi	sp,sp,-16
    800010f2:	e406                	sd	ra,8(sp)
    800010f4:	e022                	sd	s0,0(sp)
    800010f6:	0800                	addi	s0,sp,16
    800010f8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010fa:	86b2                	mv	a3,a2
    800010fc:	863e                	mv	a2,a5
    800010fe:	f3dff0ef          	jal	8000103a <mappages>
    80001102:	e509                	bnez	a0,8000110c <kvmmap+0x1c>
}
    80001104:	60a2                	ld	ra,8(sp)
    80001106:	6402                	ld	s0,0(sp)
    80001108:	0141                	addi	sp,sp,16
    8000110a:	8082                	ret
    panic("kvmmap");
    8000110c:	00007517          	auipc	a0,0x7
    80001110:	00c50513          	addi	a0,a0,12 # 80008118 <etext+0x118>
    80001114:	ecaff0ef          	jal	800007de <panic>

0000000080001118 <kvmmake>:
{
    80001118:	1101                	addi	sp,sp,-32
    8000111a:	ec06                	sd	ra,24(sp)
    8000111c:	e822                	sd	s0,16(sp)
    8000111e:	e426                	sd	s1,8(sp)
    80001120:	e04a                	sd	s2,0(sp)
    80001122:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001124:	9ffff0ef          	jal	80000b22 <kalloc>
    80001128:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000112a:	6605                	lui	a2,0x1
    8000112c:	4581                	li	a1,0
    8000112e:	b99ff0ef          	jal	80000cc6 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001132:	4719                	li	a4,6
    80001134:	6685                	lui	a3,0x1
    80001136:	10000637          	lui	a2,0x10000
    8000113a:	85b2                	mv	a1,a2
    8000113c:	8526                	mv	a0,s1
    8000113e:	fb3ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001142:	4719                	li	a4,6
    80001144:	6685                	lui	a3,0x1
    80001146:	10001637          	lui	a2,0x10001
    8000114a:	85b2                	mv	a1,a2
    8000114c:	8526                	mv	a0,s1
    8000114e:	fa3ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    80001152:	4719                	li	a4,6
    80001154:	100006b7          	lui	a3,0x10000
    80001158:	30000637          	lui	a2,0x30000
    8000115c:	85b2                	mv	a1,a2
    8000115e:	8526                	mv	a0,s1
    80001160:	f91ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    80001164:	4719                	li	a4,6
    80001166:	000206b7          	lui	a3,0x20
    8000116a:	40000637          	lui	a2,0x40000
    8000116e:	85b2                	mv	a1,a2
    80001170:	8526                	mv	a0,s1
    80001172:	f7fff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001176:	4719                	li	a4,6
    80001178:	040006b7          	lui	a3,0x4000
    8000117c:	0c000637          	lui	a2,0xc000
    80001180:	85b2                	mv	a1,a2
    80001182:	8526                	mv	a0,s1
    80001184:	f6dff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001188:	00007917          	auipc	s2,0x7
    8000118c:	e7890913          	addi	s2,s2,-392 # 80008000 <etext>
    80001190:	4729                	li	a4,10
    80001192:	80007697          	auipc	a3,0x80007
    80001196:	e6e68693          	addi	a3,a3,-402 # 8000 <_entry-0x7fff8000>
    8000119a:	4605                	li	a2,1
    8000119c:	067e                	slli	a2,a2,0x1f
    8000119e:	85b2                	mv	a1,a2
    800011a0:	8526                	mv	a0,s1
    800011a2:	f4fff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011a6:	4719                	li	a4,6
    800011a8:	46c5                	li	a3,17
    800011aa:	06ee                	slli	a3,a3,0x1b
    800011ac:	412686b3          	sub	a3,a3,s2
    800011b0:	864a                	mv	a2,s2
    800011b2:	85ca                	mv	a1,s2
    800011b4:	8526                	mv	a0,s1
    800011b6:	f3bff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011ba:	4729                	li	a4,10
    800011bc:	6685                	lui	a3,0x1
    800011be:	00006617          	auipc	a2,0x6
    800011c2:	e4260613          	addi	a2,a2,-446 # 80007000 <_trampoline>
    800011c6:	040005b7          	lui	a1,0x4000
    800011ca:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011cc:	05b2                	slli	a1,a1,0xc
    800011ce:	8526                	mv	a0,s1
    800011d0:	f21ff0ef          	jal	800010f0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011d4:	8526                	mv	a0,s1
    800011d6:	5bc000ef          	jal	80001792 <proc_mapstacks>
}
    800011da:	8526                	mv	a0,s1
    800011dc:	60e2                	ld	ra,24(sp)
    800011de:	6442                	ld	s0,16(sp)
    800011e0:	64a2                	ld	s1,8(sp)
    800011e2:	6902                	ld	s2,0(sp)
    800011e4:	6105                	addi	sp,sp,32
    800011e6:	8082                	ret

00000000800011e8 <kvminit>:
{
    800011e8:	1141                	addi	sp,sp,-16
    800011ea:	e406                	sd	ra,8(sp)
    800011ec:	e022                	sd	s0,0(sp)
    800011ee:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011f0:	f29ff0ef          	jal	80001118 <kvmmake>
    800011f4:	00007797          	auipc	a5,0x7
    800011f8:	78a7b223          	sd	a0,1924(a5) # 80008978 <kernel_pagetable>
}
    800011fc:	60a2                	ld	ra,8(sp)
    800011fe:	6402                	ld	s0,0(sp)
    80001200:	0141                	addi	sp,sp,16
    80001202:	8082                	ret

0000000080001204 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001204:	1101                	addi	sp,sp,-32
    80001206:	ec06                	sd	ra,24(sp)
    80001208:	e822                	sd	s0,16(sp)
    8000120a:	e426                	sd	s1,8(sp)
    8000120c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000120e:	915ff0ef          	jal	80000b22 <kalloc>
    80001212:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001214:	c509                	beqz	a0,8000121e <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001216:	6605                	lui	a2,0x1
    80001218:	4581                	li	a1,0
    8000121a:	aadff0ef          	jal	80000cc6 <memset>
  return pagetable;
}
    8000121e:	8526                	mv	a0,s1
    80001220:	60e2                	ld	ra,24(sp)
    80001222:	6442                	ld	s0,16(sp)
    80001224:	64a2                	ld	s1,8(sp)
    80001226:	6105                	addi	sp,sp,32
    80001228:	8082                	ret

000000008000122a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000122a:	7139                	addi	sp,sp,-64
    8000122c:	fc06                	sd	ra,56(sp)
    8000122e:	f822                	sd	s0,48(sp)
    80001230:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001232:	03459793          	slli	a5,a1,0x34
    80001236:	e38d                	bnez	a5,80001258 <uvmunmap+0x2e>
    80001238:	f04a                	sd	s2,32(sp)
    8000123a:	ec4e                	sd	s3,24(sp)
    8000123c:	e852                	sd	s4,16(sp)
    8000123e:	e456                	sd	s5,8(sp)
    80001240:	e05a                	sd	s6,0(sp)
    80001242:	8a2a                	mv	s4,a0
    80001244:	892e                	mv	s2,a1
    80001246:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001248:	0632                	slli	a2,a2,0xc
    8000124a:	00b609b3          	add	s3,a2,a1
    8000124e:	6b05                	lui	s6,0x1
    80001250:	0535f963          	bgeu	a1,s3,800012a2 <uvmunmap+0x78>
    80001254:	f426                	sd	s1,40(sp)
    80001256:	a015                	j	8000127a <uvmunmap+0x50>
    80001258:	f426                	sd	s1,40(sp)
    8000125a:	f04a                	sd	s2,32(sp)
    8000125c:	ec4e                	sd	s3,24(sp)
    8000125e:	e852                	sd	s4,16(sp)
    80001260:	e456                	sd	s5,8(sp)
    80001262:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80001264:	00007517          	auipc	a0,0x7
    80001268:	ebc50513          	addi	a0,a0,-324 # 80008120 <etext+0x120>
    8000126c:	d72ff0ef          	jal	800007de <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001270:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001274:	995a                	add	s2,s2,s6
    80001276:	03397563          	bgeu	s2,s3,800012a0 <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    8000127a:	4601                	li	a2,0
    8000127c:	85ca                	mv	a1,s2
    8000127e:	8552                	mv	a0,s4
    80001280:	ce3ff0ef          	jal	80000f62 <walk>
    80001284:	84aa                	mv	s1,a0
    80001286:	d57d                	beqz	a0,80001274 <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    80001288:	611c                	ld	a5,0(a0)
    8000128a:	0017f713          	andi	a4,a5,1
    8000128e:	d37d                	beqz	a4,80001274 <uvmunmap+0x4a>
    if(do_free){
    80001290:	fe0a80e3          	beqz	s5,80001270 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001294:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80001296:	00c79513          	slli	a0,a5,0xc
    8000129a:	fa6ff0ef          	jal	80000a40 <kfree>
    8000129e:	bfc9                	j	80001270 <uvmunmap+0x46>
    800012a0:	74a2                	ld	s1,40(sp)
    800012a2:	7902                	ld	s2,32(sp)
    800012a4:	69e2                	ld	s3,24(sp)
    800012a6:	6a42                	ld	s4,16(sp)
    800012a8:	6aa2                	ld	s5,8(sp)
    800012aa:	6b02                	ld	s6,0(sp)
  }
}
    800012ac:	70e2                	ld	ra,56(sp)
    800012ae:	7442                	ld	s0,48(sp)
    800012b0:	6121                	addi	sp,sp,64
    800012b2:	8082                	ret

00000000800012b4 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012b4:	1101                	addi	sp,sp,-32
    800012b6:	ec06                	sd	ra,24(sp)
    800012b8:	e822                	sd	s0,16(sp)
    800012ba:	e426                	sd	s1,8(sp)
    800012bc:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800012be:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800012c0:	00b67d63          	bgeu	a2,a1,800012da <uvmdealloc+0x26>
    800012c4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800012c6:	6785                	lui	a5,0x1
    800012c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012ca:	00f60733          	add	a4,a2,a5
    800012ce:	76fd                	lui	a3,0xfffff
    800012d0:	8f75                	and	a4,a4,a3
    800012d2:	97ae                	add	a5,a5,a1
    800012d4:	8ff5                	and	a5,a5,a3
    800012d6:	00f76863          	bltu	a4,a5,800012e6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800012da:	8526                	mv	a0,s1
    800012dc:	60e2                	ld	ra,24(sp)
    800012de:	6442                	ld	s0,16(sp)
    800012e0:	64a2                	ld	s1,8(sp)
    800012e2:	6105                	addi	sp,sp,32
    800012e4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012e6:	8f99                	sub	a5,a5,a4
    800012e8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012ea:	4685                	li	a3,1
    800012ec:	0007861b          	sext.w	a2,a5
    800012f0:	85ba                	mv	a1,a4
    800012f2:	f39ff0ef          	jal	8000122a <uvmunmap>
    800012f6:	b7d5                	j	800012da <uvmdealloc+0x26>

00000000800012f8 <uvmalloc>:
  if(newsz < oldsz)
    800012f8:	0ab66363          	bltu	a2,a1,8000139e <uvmalloc+0xa6>
{
    800012fc:	715d                	addi	sp,sp,-80
    800012fe:	e486                	sd	ra,72(sp)
    80001300:	e0a2                	sd	s0,64(sp)
    80001302:	f052                	sd	s4,32(sp)
    80001304:	ec56                	sd	s5,24(sp)
    80001306:	e85a                	sd	s6,16(sp)
    80001308:	0880                	addi	s0,sp,80
    8000130a:	8b2a                	mv	s6,a0
    8000130c:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    8000130e:	6785                	lui	a5,0x1
    80001310:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001312:	95be                	add	a1,a1,a5
    80001314:	77fd                	lui	a5,0xfffff
    80001316:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000131a:	08ca7463          	bgeu	s4,a2,800013a2 <uvmalloc+0xaa>
    8000131e:	fc26                	sd	s1,56(sp)
    80001320:	f84a                	sd	s2,48(sp)
    80001322:	f44e                	sd	s3,40(sp)
    80001324:	e45e                	sd	s7,8(sp)
    80001326:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    80001328:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000132a:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    8000132e:	ff4ff0ef          	jal	80000b22 <kalloc>
    80001332:	84aa                	mv	s1,a0
    if(mem == 0){
    80001334:	c515                	beqz	a0,80001360 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80001336:	864e                	mv	a2,s3
    80001338:	4581                	li	a1,0
    8000133a:	98dff0ef          	jal	80000cc6 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000133e:	875e                	mv	a4,s7
    80001340:	86a6                	mv	a3,s1
    80001342:	864e                	mv	a2,s3
    80001344:	85ca                	mv	a1,s2
    80001346:	855a                	mv	a0,s6
    80001348:	cf3ff0ef          	jal	8000103a <mappages>
    8000134c:	e91d                	bnez	a0,80001382 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000134e:	994e                	add	s2,s2,s3
    80001350:	fd596fe3          	bltu	s2,s5,8000132e <uvmalloc+0x36>
  return newsz;
    80001354:	8556                	mv	a0,s5
    80001356:	74e2                	ld	s1,56(sp)
    80001358:	7942                	ld	s2,48(sp)
    8000135a:	79a2                	ld	s3,40(sp)
    8000135c:	6ba2                	ld	s7,8(sp)
    8000135e:	a819                	j	80001374 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80001360:	8652                	mv	a2,s4
    80001362:	85ca                	mv	a1,s2
    80001364:	855a                	mv	a0,s6
    80001366:	f4fff0ef          	jal	800012b4 <uvmdealloc>
      return 0;
    8000136a:	4501                	li	a0,0
    8000136c:	74e2                	ld	s1,56(sp)
    8000136e:	7942                	ld	s2,48(sp)
    80001370:	79a2                	ld	s3,40(sp)
    80001372:	6ba2                	ld	s7,8(sp)
}
    80001374:	60a6                	ld	ra,72(sp)
    80001376:	6406                	ld	s0,64(sp)
    80001378:	7a02                	ld	s4,32(sp)
    8000137a:	6ae2                	ld	s5,24(sp)
    8000137c:	6b42                	ld	s6,16(sp)
    8000137e:	6161                	addi	sp,sp,80
    80001380:	8082                	ret
      kfree(mem);
    80001382:	8526                	mv	a0,s1
    80001384:	ebcff0ef          	jal	80000a40 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001388:	8652                	mv	a2,s4
    8000138a:	85ca                	mv	a1,s2
    8000138c:	855a                	mv	a0,s6
    8000138e:	f27ff0ef          	jal	800012b4 <uvmdealloc>
      return 0;
    80001392:	4501                	li	a0,0
    80001394:	74e2                	ld	s1,56(sp)
    80001396:	7942                	ld	s2,48(sp)
    80001398:	79a2                	ld	s3,40(sp)
    8000139a:	6ba2                	ld	s7,8(sp)
    8000139c:	bfe1                	j	80001374 <uvmalloc+0x7c>
    return oldsz;
    8000139e:	852e                	mv	a0,a1
}
    800013a0:	8082                	ret
  return newsz;
    800013a2:	8532                	mv	a0,a2
    800013a4:	bfc1                	j	80001374 <uvmalloc+0x7c>

00000000800013a6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013a6:	7179                	addi	sp,sp,-48
    800013a8:	f406                	sd	ra,40(sp)
    800013aa:	f022                	sd	s0,32(sp)
    800013ac:	ec26                	sd	s1,24(sp)
    800013ae:	e84a                	sd	s2,16(sp)
    800013b0:	e44e                	sd	s3,8(sp)
    800013b2:	e052                	sd	s4,0(sp)
    800013b4:	1800                	addi	s0,sp,48
    800013b6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013b8:	84aa                	mv	s1,a0
    800013ba:	6905                	lui	s2,0x1
    800013bc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013be:	4985                	li	s3,1
    800013c0:	a819                	j	800013d6 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800013c2:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800013c4:	00c79513          	slli	a0,a5,0xc
    800013c8:	fdfff0ef          	jal	800013a6 <freewalk>
      pagetable[i] = 0;
    800013cc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800013d0:	04a1                	addi	s1,s1,8
    800013d2:	01248f63          	beq	s1,s2,800013f0 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800013d6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013d8:	00f7f713          	andi	a4,a5,15
    800013dc:	ff3703e3          	beq	a4,s3,800013c2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800013e0:	8b85                	andi	a5,a5,1
    800013e2:	d7fd                	beqz	a5,800013d0 <freewalk+0x2a>
      panic("freewalk: leaf");
    800013e4:	00007517          	auipc	a0,0x7
    800013e8:	d5450513          	addi	a0,a0,-684 # 80008138 <etext+0x138>
    800013ec:	bf2ff0ef          	jal	800007de <panic>
    }
  }
  kfree((void*)pagetable);
    800013f0:	8552                	mv	a0,s4
    800013f2:	e4eff0ef          	jal	80000a40 <kfree>
}
    800013f6:	70a2                	ld	ra,40(sp)
    800013f8:	7402                	ld	s0,32(sp)
    800013fa:	64e2                	ld	s1,24(sp)
    800013fc:	6942                	ld	s2,16(sp)
    800013fe:	69a2                	ld	s3,8(sp)
    80001400:	6a02                	ld	s4,0(sp)
    80001402:	6145                	addi	sp,sp,48
    80001404:	8082                	ret

0000000080001406 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001406:	1101                	addi	sp,sp,-32
    80001408:	ec06                	sd	ra,24(sp)
    8000140a:	e822                	sd	s0,16(sp)
    8000140c:	e426                	sd	s1,8(sp)
    8000140e:	1000                	addi	s0,sp,32
    80001410:	84aa                	mv	s1,a0
  if(sz > 0)
    80001412:	e989                	bnez	a1,80001424 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001414:	8526                	mv	a0,s1
    80001416:	f91ff0ef          	jal	800013a6 <freewalk>
}
    8000141a:	60e2                	ld	ra,24(sp)
    8000141c:	6442                	ld	s0,16(sp)
    8000141e:	64a2                	ld	s1,8(sp)
    80001420:	6105                	addi	sp,sp,32
    80001422:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001424:	6785                	lui	a5,0x1
    80001426:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001428:	95be                	add	a1,a1,a5
    8000142a:	4685                	li	a3,1
    8000142c:	00c5d613          	srli	a2,a1,0xc
    80001430:	4581                	li	a1,0
    80001432:	df9ff0ef          	jal	8000122a <uvmunmap>
    80001436:	bff9                	j	80001414 <uvmfree+0xe>

0000000080001438 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001438:	ce59                	beqz	a2,800014d6 <uvmcopy+0x9e>
{
    8000143a:	715d                	addi	sp,sp,-80
    8000143c:	e486                	sd	ra,72(sp)
    8000143e:	e0a2                	sd	s0,64(sp)
    80001440:	fc26                	sd	s1,56(sp)
    80001442:	f84a                	sd	s2,48(sp)
    80001444:	f44e                	sd	s3,40(sp)
    80001446:	f052                	sd	s4,32(sp)
    80001448:	ec56                	sd	s5,24(sp)
    8000144a:	e85a                	sd	s6,16(sp)
    8000144c:	e45e                	sd	s7,8(sp)
    8000144e:	e062                	sd	s8,0(sp)
    80001450:	0880                	addi	s0,sp,80
    80001452:	8b2a                	mv	s6,a0
    80001454:	8bae                	mv	s7,a1
    80001456:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001458:	4481                	li	s1,0
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000145a:	6a05                	lui	s4,0x1
    8000145c:	a021                	j	80001464 <uvmcopy+0x2c>
  for(i = 0; i < sz; i += PGSIZE){
    8000145e:	94d2                	add	s1,s1,s4
    80001460:	0554fe63          	bgeu	s1,s5,800014bc <uvmcopy+0x84>
    if((pte = walk(old, i, 0)) == 0)
    80001464:	4601                	li	a2,0
    80001466:	85a6                	mv	a1,s1
    80001468:	855a                	mv	a0,s6
    8000146a:	af9ff0ef          	jal	80000f62 <walk>
    8000146e:	d965                	beqz	a0,8000145e <uvmcopy+0x26>
    if((*pte & PTE_V) == 0)
    80001470:	6118                	ld	a4,0(a0)
    80001472:	00177793          	andi	a5,a4,1
    80001476:	d7e5                	beqz	a5,8000145e <uvmcopy+0x26>
    pa = PTE2PA(*pte);
    80001478:	00a75593          	srli	a1,a4,0xa
    8000147c:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001480:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80001484:	e9eff0ef          	jal	80000b22 <kalloc>
    80001488:	89aa                	mv	s3,a0
    8000148a:	c105                	beqz	a0,800014aa <uvmcopy+0x72>
    memmove(mem, (char*)pa, PGSIZE);
    8000148c:	8652                	mv	a2,s4
    8000148e:	85e2                	mv	a1,s8
    80001490:	89bff0ef          	jal	80000d2a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001494:	874a                	mv	a4,s2
    80001496:	86ce                	mv	a3,s3
    80001498:	8652                	mv	a2,s4
    8000149a:	85a6                	mv	a1,s1
    8000149c:	855e                	mv	a0,s7
    8000149e:	b9dff0ef          	jal	8000103a <mappages>
    800014a2:	dd55                	beqz	a0,8000145e <uvmcopy+0x26>
      kfree(mem);
    800014a4:	854e                	mv	a0,s3
    800014a6:	d9aff0ef          	jal	80000a40 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014aa:	4685                	li	a3,1
    800014ac:	00c4d613          	srli	a2,s1,0xc
    800014b0:	4581                	li	a1,0
    800014b2:	855e                	mv	a0,s7
    800014b4:	d77ff0ef          	jal	8000122a <uvmunmap>
  return -1;
    800014b8:	557d                	li	a0,-1
    800014ba:	a011                	j	800014be <uvmcopy+0x86>
  return 0;
    800014bc:	4501                	li	a0,0
}
    800014be:	60a6                	ld	ra,72(sp)
    800014c0:	6406                	ld	s0,64(sp)
    800014c2:	74e2                	ld	s1,56(sp)
    800014c4:	7942                	ld	s2,48(sp)
    800014c6:	79a2                	ld	s3,40(sp)
    800014c8:	7a02                	ld	s4,32(sp)
    800014ca:	6ae2                	ld	s5,24(sp)
    800014cc:	6b42                	ld	s6,16(sp)
    800014ce:	6ba2                	ld	s7,8(sp)
    800014d0:	6c02                	ld	s8,0(sp)
    800014d2:	6161                	addi	sp,sp,80
    800014d4:	8082                	ret
  return 0;
    800014d6:	4501                	li	a0,0
}
    800014d8:	8082                	ret

00000000800014da <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014da:	1141                	addi	sp,sp,-16
    800014dc:	e406                	sd	ra,8(sp)
    800014de:	e022                	sd	s0,0(sp)
    800014e0:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800014e2:	4601                	li	a2,0
    800014e4:	a7fff0ef          	jal	80000f62 <walk>
  if(pte == 0)
    800014e8:	c901                	beqz	a0,800014f8 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014ea:	611c                	ld	a5,0(a0)
    800014ec:	9bbd                	andi	a5,a5,-17
    800014ee:	e11c                	sd	a5,0(a0)
}
    800014f0:	60a2                	ld	ra,8(sp)
    800014f2:	6402                	ld	s0,0(sp)
    800014f4:	0141                	addi	sp,sp,16
    800014f6:	8082                	ret
    panic("uvmclear");
    800014f8:	00007517          	auipc	a0,0x7
    800014fc:	c5050513          	addi	a0,a0,-944 # 80008148 <etext+0x148>
    80001500:	adeff0ef          	jal	800007de <panic>

0000000080001504 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80001504:	715d                	addi	sp,sp,-80
    80001506:	e486                	sd	ra,72(sp)
    80001508:	e0a2                	sd	s0,64(sp)
    8000150a:	fc26                	sd	s1,56(sp)
    8000150c:	f84a                	sd	s2,48(sp)
    8000150e:	f44e                	sd	s3,40(sp)
    80001510:	f052                	sd	s4,32(sp)
    80001512:	ec56                	sd	s5,24(sp)
    80001514:	e85a                	sd	s6,16(sp)
    80001516:	e45e                	sd	s7,8(sp)
    80001518:	0880                	addi	s0,sp,80
    8000151a:	8aaa                	mv	s5,a0
    8000151c:	89ae                	mv	s3,a1
    8000151e:	8bb2                	mv	s7,a2
    80001520:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80001522:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001524:	6a05                	lui	s4,0x1
    80001526:	a02d                	j	80001550 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001528:	00078023          	sb	zero,0(a5)
    8000152c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000152e:	0017c793          	xori	a5,a5,1
    80001532:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001536:	60a6                	ld	ra,72(sp)
    80001538:	6406                	ld	s0,64(sp)
    8000153a:	74e2                	ld	s1,56(sp)
    8000153c:	7942                	ld	s2,48(sp)
    8000153e:	79a2                	ld	s3,40(sp)
    80001540:	7a02                	ld	s4,32(sp)
    80001542:	6ae2                	ld	s5,24(sp)
    80001544:	6b42                	ld	s6,16(sp)
    80001546:	6ba2                	ld	s7,8(sp)
    80001548:	6161                	addi	sp,sp,80
    8000154a:	8082                	ret
    srcva = va0 + PGSIZE;
    8000154c:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001550:	c4b1                	beqz	s1,8000159c <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80001552:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001556:	85ca                	mv	a1,s2
    80001558:	8556                	mv	a0,s5
    8000155a:	aa3ff0ef          	jal	80000ffc <walkaddr>
    if(pa0 == 0)
    8000155e:	c129                	beqz	a0,800015a0 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    80001560:	41790633          	sub	a2,s2,s7
    80001564:	9652                	add	a2,a2,s4
    if(n > max)
    80001566:	00c4f363          	bgeu	s1,a2,8000156c <copyinstr+0x68>
    8000156a:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000156c:	412b8bb3          	sub	s7,s7,s2
    80001570:	9baa                	add	s7,s7,a0
    while(n > 0){
    80001572:	de69                	beqz	a2,8000154c <copyinstr+0x48>
    80001574:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80001576:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    8000157a:	964e                	add	a2,a2,s3
    8000157c:	85be                	mv	a1,a5
      if(*p == '\0'){
    8000157e:	00f68733          	add	a4,a3,a5
    80001582:	00074703          	lbu	a4,0(a4)
    80001586:	d34d                	beqz	a4,80001528 <copyinstr+0x24>
        *dst = *p;
    80001588:	00e78023          	sb	a4,0(a5)
      dst++;
    8000158c:	0785                	addi	a5,a5,1
    while(n > 0){
    8000158e:	fec797e3          	bne	a5,a2,8000157c <copyinstr+0x78>
    80001592:	14fd                	addi	s1,s1,-1
    80001594:	94ce                	add	s1,s1,s3
      --max;
    80001596:	8c8d                	sub	s1,s1,a1
    80001598:	89be                	mv	s3,a5
    8000159a:	bf4d                	j	8000154c <copyinstr+0x48>
    8000159c:	4781                	li	a5,0
    8000159e:	bf41                	j	8000152e <copyinstr+0x2a>
      return -1;
    800015a0:	557d                	li	a0,-1
    800015a2:	bf51                	j	80001536 <copyinstr+0x32>

00000000800015a4 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800015a4:	1141                	addi	sp,sp,-16
    800015a6:	e406                	sd	ra,8(sp)
    800015a8:	e022                	sd	s0,0(sp)
    800015aa:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800015ac:	4601                	li	a2,0
    800015ae:	9b5ff0ef          	jal	80000f62 <walk>
  if (pte == 0) {
    800015b2:	c519                	beqz	a0,800015c0 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    800015b4:	6108                	ld	a0,0(a0)
    800015b6:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800015b8:	60a2                	ld	ra,8(sp)
    800015ba:	6402                	ld	s0,0(sp)
    800015bc:	0141                	addi	sp,sp,16
    800015be:	8082                	ret
    return 0;
    800015c0:	4501                	li	a0,0
    800015c2:	bfdd                	j	800015b8 <ismapped+0x14>

00000000800015c4 <vmfault>:
{
    800015c4:	7179                	addi	sp,sp,-48
    800015c6:	f406                	sd	ra,40(sp)
    800015c8:	f022                	sd	s0,32(sp)
    800015ca:	ec26                	sd	s1,24(sp)
    800015cc:	e44e                	sd	s3,8(sp)
    800015ce:	1800                	addi	s0,sp,48
    800015d0:	89aa                	mv	s3,a0
    800015d2:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    800015d4:	340000ef          	jal	80001914 <myproc>
  if (va >= p->sz)
    800015d8:	653c                	ld	a5,72(a0)
    800015da:	00f4ea63          	bltu	s1,a5,800015ee <vmfault+0x2a>
    return 0;
    800015de:	4981                	li	s3,0
}
    800015e0:	854e                	mv	a0,s3
    800015e2:	70a2                	ld	ra,40(sp)
    800015e4:	7402                	ld	s0,32(sp)
    800015e6:	64e2                	ld	s1,24(sp)
    800015e8:	69a2                	ld	s3,8(sp)
    800015ea:	6145                	addi	sp,sp,48
    800015ec:	8082                	ret
    800015ee:	e84a                	sd	s2,16(sp)
    800015f0:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    800015f2:	77fd                	lui	a5,0xfffff
    800015f4:	8cfd                	and	s1,s1,a5
  if(ismapped(pagetable, va)) {
    800015f6:	85a6                	mv	a1,s1
    800015f8:	854e                	mv	a0,s3
    800015fa:	fabff0ef          	jal	800015a4 <ismapped>
    return 0;
    800015fe:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80001600:	c119                	beqz	a0,80001606 <vmfault+0x42>
    80001602:	6942                	ld	s2,16(sp)
    80001604:	bff1                	j	800015e0 <vmfault+0x1c>
    80001606:	e052                	sd	s4,0(sp)
  mem = (uint64) kalloc();
    80001608:	d1aff0ef          	jal	80000b22 <kalloc>
    8000160c:	8a2a                	mv	s4,a0
  if(mem == 0)
    8000160e:	c90d                	beqz	a0,80001640 <vmfault+0x7c>
  mem = (uint64) kalloc();
    80001610:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80001612:	6605                	lui	a2,0x1
    80001614:	4581                	li	a1,0
    80001616:	eb0ff0ef          	jal	80000cc6 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    8000161a:	4759                	li	a4,22
    8000161c:	86d2                	mv	a3,s4
    8000161e:	6605                	lui	a2,0x1
    80001620:	85a6                	mv	a1,s1
    80001622:	05093503          	ld	a0,80(s2) # 1050 <_entry-0x7fffefb0>
    80001626:	a15ff0ef          	jal	8000103a <mappages>
    8000162a:	e501                	bnez	a0,80001632 <vmfault+0x6e>
    8000162c:	6942                	ld	s2,16(sp)
    8000162e:	6a02                	ld	s4,0(sp)
    80001630:	bf45                	j	800015e0 <vmfault+0x1c>
    kfree((void *)mem);
    80001632:	8552                	mv	a0,s4
    80001634:	c0cff0ef          	jal	80000a40 <kfree>
    return 0;
    80001638:	4981                	li	s3,0
    8000163a:	6942                	ld	s2,16(sp)
    8000163c:	6a02                	ld	s4,0(sp)
    8000163e:	b74d                	j	800015e0 <vmfault+0x1c>
    80001640:	6942                	ld	s2,16(sp)
    80001642:	6a02                	ld	s4,0(sp)
    80001644:	bf71                	j	800015e0 <vmfault+0x1c>

0000000080001646 <copyout>:
  while(len > 0){
    80001646:	cad1                	beqz	a3,800016da <copyout+0x94>
{
    80001648:	711d                	addi	sp,sp,-96
    8000164a:	ec86                	sd	ra,88(sp)
    8000164c:	e8a2                	sd	s0,80(sp)
    8000164e:	e4a6                	sd	s1,72(sp)
    80001650:	e0ca                	sd	s2,64(sp)
    80001652:	fc4e                	sd	s3,56(sp)
    80001654:	f852                	sd	s4,48(sp)
    80001656:	f456                	sd	s5,40(sp)
    80001658:	f05a                	sd	s6,32(sp)
    8000165a:	ec5e                	sd	s7,24(sp)
    8000165c:	e862                	sd	s8,16(sp)
    8000165e:	e466                	sd	s9,8(sp)
    80001660:	e06a                	sd	s10,0(sp)
    80001662:	1080                	addi	s0,sp,96
    80001664:	8baa                	mv	s7,a0
    80001666:	8a2e                	mv	s4,a1
    80001668:	8b32                	mv	s6,a2
    8000166a:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    8000166c:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    8000166e:	5cfd                	li	s9,-1
    80001670:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80001674:	6c05                	lui	s8,0x1
    80001676:	a005                	j	80001696 <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001678:	409a0533          	sub	a0,s4,s1
    8000167c:	0009061b          	sext.w	a2,s2
    80001680:	85da                	mv	a1,s6
    80001682:	954e                	add	a0,a0,s3
    80001684:	ea6ff0ef          	jal	80000d2a <memmove>
    len -= n;
    80001688:	412a8ab3          	sub	s5,s5,s2
    src += n;
    8000168c:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    8000168e:	01848a33          	add	s4,s1,s8
  while(len > 0){
    80001692:	040a8263          	beqz	s5,800016d6 <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    80001696:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    8000169a:	049ce263          	bltu	s9,s1,800016de <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    8000169e:	85a6                	mv	a1,s1
    800016a0:	855e                	mv	a0,s7
    800016a2:	95bff0ef          	jal	80000ffc <walkaddr>
    800016a6:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    800016a8:	e901                	bnez	a0,800016b8 <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    800016aa:	4601                	li	a2,0
    800016ac:	85a6                	mv	a1,s1
    800016ae:	855e                	mv	a0,s7
    800016b0:	f15ff0ef          	jal	800015c4 <vmfault>
    800016b4:	89aa                	mv	s3,a0
    800016b6:	c139                	beqz	a0,800016fc <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    800016b8:	4601                	li	a2,0
    800016ba:	85a6                	mv	a1,s1
    800016bc:	855e                	mv	a0,s7
    800016be:	8a5ff0ef          	jal	80000f62 <walk>
    if((*pte & PTE_W) == 0)
    800016c2:	611c                	ld	a5,0(a0)
    800016c4:	8b91                	andi	a5,a5,4
    800016c6:	cf8d                	beqz	a5,80001700 <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    800016c8:	41448933          	sub	s2,s1,s4
    800016cc:	9962                	add	s2,s2,s8
    if(n > len)
    800016ce:	fb2af5e3          	bgeu	s5,s2,80001678 <copyout+0x32>
    800016d2:	8956                	mv	s2,s5
    800016d4:	b755                	j	80001678 <copyout+0x32>
  return 0;
    800016d6:	4501                	li	a0,0
    800016d8:	a021                	j	800016e0 <copyout+0x9a>
    800016da:	4501                	li	a0,0
}
    800016dc:	8082                	ret
      return -1;
    800016de:	557d                	li	a0,-1
}
    800016e0:	60e6                	ld	ra,88(sp)
    800016e2:	6446                	ld	s0,80(sp)
    800016e4:	64a6                	ld	s1,72(sp)
    800016e6:	6906                	ld	s2,64(sp)
    800016e8:	79e2                	ld	s3,56(sp)
    800016ea:	7a42                	ld	s4,48(sp)
    800016ec:	7aa2                	ld	s5,40(sp)
    800016ee:	7b02                	ld	s6,32(sp)
    800016f0:	6be2                	ld	s7,24(sp)
    800016f2:	6c42                	ld	s8,16(sp)
    800016f4:	6ca2                	ld	s9,8(sp)
    800016f6:	6d02                	ld	s10,0(sp)
    800016f8:	6125                	addi	sp,sp,96
    800016fa:	8082                	ret
        return -1;
    800016fc:	557d                	li	a0,-1
    800016fe:	b7cd                	j	800016e0 <copyout+0x9a>
      return -1;
    80001700:	557d                	li	a0,-1
    80001702:	bff9                	j	800016e0 <copyout+0x9a>

0000000080001704 <copyin>:
  while(len > 0){
    80001704:	c6c9                	beqz	a3,8000178e <copyin+0x8a>
{
    80001706:	715d                	addi	sp,sp,-80
    80001708:	e486                	sd	ra,72(sp)
    8000170a:	e0a2                	sd	s0,64(sp)
    8000170c:	fc26                	sd	s1,56(sp)
    8000170e:	f84a                	sd	s2,48(sp)
    80001710:	f44e                	sd	s3,40(sp)
    80001712:	f052                	sd	s4,32(sp)
    80001714:	ec56                	sd	s5,24(sp)
    80001716:	e85a                	sd	s6,16(sp)
    80001718:	e45e                	sd	s7,8(sp)
    8000171a:	e062                	sd	s8,0(sp)
    8000171c:	0880                	addi	s0,sp,80
    8000171e:	8baa                	mv	s7,a0
    80001720:	8aae                	mv	s5,a1
    80001722:	8932                	mv	s2,a2
    80001724:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80001726:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80001728:	6b05                	lui	s6,0x1
    8000172a:	a035                	j	80001756 <copyin+0x52>
    8000172c:	412984b3          	sub	s1,s3,s2
    80001730:	94da                	add	s1,s1,s6
    if(n > len)
    80001732:	009a7363          	bgeu	s4,s1,80001738 <copyin+0x34>
    80001736:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001738:	413905b3          	sub	a1,s2,s3
    8000173c:	0004861b          	sext.w	a2,s1
    80001740:	95aa                	add	a1,a1,a0
    80001742:	8556                	mv	a0,s5
    80001744:	de6ff0ef          	jal	80000d2a <memmove>
    len -= n;
    80001748:	409a0a33          	sub	s4,s4,s1
    dst += n;
    8000174c:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    8000174e:	01698933          	add	s2,s3,s6
  while(len > 0){
    80001752:	020a0163          	beqz	s4,80001774 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001756:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    8000175a:	85ce                	mv	a1,s3
    8000175c:	855e                	mv	a0,s7
    8000175e:	89fff0ef          	jal	80000ffc <walkaddr>
    if(pa0 == 0) {
    80001762:	f569                	bnez	a0,8000172c <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001764:	4601                	li	a2,0
    80001766:	85ce                	mv	a1,s3
    80001768:	855e                	mv	a0,s7
    8000176a:	e5bff0ef          	jal	800015c4 <vmfault>
    8000176e:	fd5d                	bnez	a0,8000172c <copyin+0x28>
        return -1;
    80001770:	557d                	li	a0,-1
    80001772:	a011                	j	80001776 <copyin+0x72>
  return 0;
    80001774:	4501                	li	a0,0
}
    80001776:	60a6                	ld	ra,72(sp)
    80001778:	6406                	ld	s0,64(sp)
    8000177a:	74e2                	ld	s1,56(sp)
    8000177c:	7942                	ld	s2,48(sp)
    8000177e:	79a2                	ld	s3,40(sp)
    80001780:	7a02                	ld	s4,32(sp)
    80001782:	6ae2                	ld	s5,24(sp)
    80001784:	6b42                	ld	s6,16(sp)
    80001786:	6ba2                	ld	s7,8(sp)
    80001788:	6c02                	ld	s8,0(sp)
    8000178a:	6161                	addi	sp,sp,80
    8000178c:	8082                	ret
  return 0;
    8000178e:	4501                	li	a0,0
}
    80001790:	8082                	ret

0000000080001792 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001792:	715d                	addi	sp,sp,-80
    80001794:	e486                	sd	ra,72(sp)
    80001796:	e0a2                	sd	s0,64(sp)
    80001798:	fc26                	sd	s1,56(sp)
    8000179a:	f84a                	sd	s2,48(sp)
    8000179c:	f44e                	sd	s3,40(sp)
    8000179e:	f052                	sd	s4,32(sp)
    800017a0:	ec56                	sd	s5,24(sp)
    800017a2:	e85a                	sd	s6,16(sp)
    800017a4:	e45e                	sd	s7,8(sp)
    800017a6:	e062                	sd	s8,0(sp)
    800017a8:	0880                	addi	s0,sp,80
    800017aa:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ac:	0000f497          	auipc	s1,0xf
    800017b0:	71c48493          	addi	s1,s1,1820 # 80010ec8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017b4:	8c26                	mv	s8,s1
    800017b6:	a4fa57b7          	lui	a5,0xa4fa5
    800017ba:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f8263d>
    800017be:	4fa50937          	lui	s2,0x4fa50
    800017c2:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    800017c6:	1902                	slli	s2,s2,0x20
    800017c8:	993e                	add	s2,s2,a5
    800017ca:	040009b7          	lui	s3,0x4000
    800017ce:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017d0:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017d2:	4b99                	li	s7,6
    800017d4:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d6:	00015a97          	auipc	s5,0x15
    800017da:	0f2a8a93          	addi	s5,s5,242 # 800168c8 <tickslock>
    char *pa = kalloc();
    800017de:	b44ff0ef          	jal	80000b22 <kalloc>
    800017e2:	862a                	mv	a2,a0
    if(pa == 0)
    800017e4:	c121                	beqz	a0,80001824 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    800017e6:	418485b3          	sub	a1,s1,s8
    800017ea:	858d                	srai	a1,a1,0x3
    800017ec:	032585b3          	mul	a1,a1,s2
    800017f0:	2585                	addiw	a1,a1,1
    800017f2:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017f6:	875e                	mv	a4,s7
    800017f8:	86da                	mv	a3,s6
    800017fa:	40b985b3          	sub	a1,s3,a1
    800017fe:	8552                	mv	a0,s4
    80001800:	8f1ff0ef          	jal	800010f0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001804:	16848493          	addi	s1,s1,360
    80001808:	fd549be3          	bne	s1,s5,800017de <proc_mapstacks+0x4c>
  }
}
    8000180c:	60a6                	ld	ra,72(sp)
    8000180e:	6406                	ld	s0,64(sp)
    80001810:	74e2                	ld	s1,56(sp)
    80001812:	7942                	ld	s2,48(sp)
    80001814:	79a2                	ld	s3,40(sp)
    80001816:	7a02                	ld	s4,32(sp)
    80001818:	6ae2                	ld	s5,24(sp)
    8000181a:	6b42                	ld	s6,16(sp)
    8000181c:	6ba2                	ld	s7,8(sp)
    8000181e:	6c02                	ld	s8,0(sp)
    80001820:	6161                	addi	sp,sp,80
    80001822:	8082                	ret
      panic("kalloc");
    80001824:	00007517          	auipc	a0,0x7
    80001828:	93450513          	addi	a0,a0,-1740 # 80008158 <etext+0x158>
    8000182c:	fb3fe0ef          	jal	800007de <panic>

0000000080001830 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001830:	7139                	addi	sp,sp,-64
    80001832:	fc06                	sd	ra,56(sp)
    80001834:	f822                	sd	s0,48(sp)
    80001836:	f426                	sd	s1,40(sp)
    80001838:	f04a                	sd	s2,32(sp)
    8000183a:	ec4e                	sd	s3,24(sp)
    8000183c:	e852                	sd	s4,16(sp)
    8000183e:	e456                	sd	s5,8(sp)
    80001840:	e05a                	sd	s6,0(sp)
    80001842:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001844:	00007597          	auipc	a1,0x7
    80001848:	91c58593          	addi	a1,a1,-1764 # 80008160 <etext+0x160>
    8000184c:	0000f517          	auipc	a0,0xf
    80001850:	24c50513          	addi	a0,a0,588 # 80010a98 <pid_lock>
    80001854:	b1eff0ef          	jal	80000b72 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001858:	00007597          	auipc	a1,0x7
    8000185c:	91058593          	addi	a1,a1,-1776 # 80008168 <etext+0x168>
    80001860:	0000f517          	auipc	a0,0xf
    80001864:	25050513          	addi	a0,a0,592 # 80010ab0 <wait_lock>
    80001868:	b0aff0ef          	jal	80000b72 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186c:	0000f497          	auipc	s1,0xf
    80001870:	65c48493          	addi	s1,s1,1628 # 80010ec8 <proc>
      initlock(&p->lock, "proc");
    80001874:	00007b17          	auipc	s6,0x7
    80001878:	904b0b13          	addi	s6,s6,-1788 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000187c:	8aa6                	mv	s5,s1
    8000187e:	a4fa57b7          	lui	a5,0xa4fa5
    80001882:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f8263d>
    80001886:	4fa50937          	lui	s2,0x4fa50
    8000188a:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    8000188e:	1902                	slli	s2,s2,0x20
    80001890:	993e                	add	s2,s2,a5
    80001892:	040009b7          	lui	s3,0x4000
    80001896:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001898:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000189a:	00015a17          	auipc	s4,0x15
    8000189e:	02ea0a13          	addi	s4,s4,46 # 800168c8 <tickslock>
      initlock(&p->lock, "proc");
    800018a2:	85da                	mv	a1,s6
    800018a4:	8526                	mv	a0,s1
    800018a6:	accff0ef          	jal	80000b72 <initlock>
      p->state = UNUSED;
    800018aa:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018ae:	415487b3          	sub	a5,s1,s5
    800018b2:	878d                	srai	a5,a5,0x3
    800018b4:	032787b3          	mul	a5,a5,s2
    800018b8:	2785                	addiw	a5,a5,1
    800018ba:	00d7979b          	slliw	a5,a5,0xd
    800018be:	40f987b3          	sub	a5,s3,a5
    800018c2:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018c4:	16848493          	addi	s1,s1,360
    800018c8:	fd449de3          	bne	s1,s4,800018a2 <procinit+0x72>
  }
}
    800018cc:	70e2                	ld	ra,56(sp)
    800018ce:	7442                	ld	s0,48(sp)
    800018d0:	74a2                	ld	s1,40(sp)
    800018d2:	7902                	ld	s2,32(sp)
    800018d4:	69e2                	ld	s3,24(sp)
    800018d6:	6a42                	ld	s4,16(sp)
    800018d8:	6aa2                	ld	s5,8(sp)
    800018da:	6b02                	ld	s6,0(sp)
    800018dc:	6121                	addi	sp,sp,64
    800018de:	8082                	ret

00000000800018e0 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018e0:	1141                	addi	sp,sp,-16
    800018e2:	e406                	sd	ra,8(sp)
    800018e4:	e022                	sd	s0,0(sp)
    800018e6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018e8:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018ea:	2501                	sext.w	a0,a0
    800018ec:	60a2                	ld	ra,8(sp)
    800018ee:	6402                	ld	s0,0(sp)
    800018f0:	0141                	addi	sp,sp,16
    800018f2:	8082                	ret

00000000800018f4 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018f4:	1141                	addi	sp,sp,-16
    800018f6:	e406                	sd	ra,8(sp)
    800018f8:	e022                	sd	s0,0(sp)
    800018fa:	0800                	addi	s0,sp,16
    800018fc:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018fe:	2781                	sext.w	a5,a5
    80001900:	079e                	slli	a5,a5,0x7
  return c;
}
    80001902:	0000f517          	auipc	a0,0xf
    80001906:	1c650513          	addi	a0,a0,454 # 80010ac8 <cpus>
    8000190a:	953e                	add	a0,a0,a5
    8000190c:	60a2                	ld	ra,8(sp)
    8000190e:	6402                	ld	s0,0(sp)
    80001910:	0141                	addi	sp,sp,16
    80001912:	8082                	ret

0000000080001914 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001914:	1101                	addi	sp,sp,-32
    80001916:	ec06                	sd	ra,24(sp)
    80001918:	e822                	sd	s0,16(sp)
    8000191a:	e426                	sd	s1,8(sp)
    8000191c:	1000                	addi	s0,sp,32
  push_off();
    8000191e:	a98ff0ef          	jal	80000bb6 <push_off>
    80001922:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001924:	2781                	sext.w	a5,a5
    80001926:	079e                	slli	a5,a5,0x7
    80001928:	0000f717          	auipc	a4,0xf
    8000192c:	17070713          	addi	a4,a4,368 # 80010a98 <pid_lock>
    80001930:	97ba                	add	a5,a5,a4
    80001932:	7b84                	ld	s1,48(a5)
  pop_off();
    80001934:	b06ff0ef          	jal	80000c3a <pop_off>
  return p;
}
    80001938:	8526                	mv	a0,s1
    8000193a:	60e2                	ld	ra,24(sp)
    8000193c:	6442                	ld	s0,16(sp)
    8000193e:	64a2                	ld	s1,8(sp)
    80001940:	6105                	addi	sp,sp,32
    80001942:	8082                	ret

0000000080001944 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001944:	7179                	addi	sp,sp,-48
    80001946:	f406                	sd	ra,40(sp)
    80001948:	f022                	sd	s0,32(sp)
    8000194a:	ec26                	sd	s1,24(sp)
    8000194c:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000194e:	fc7ff0ef          	jal	80001914 <myproc>
    80001952:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001954:	b36ff0ef          	jal	80000c8a <release>

  if (first) {
    80001958:	00007797          	auipc	a5,0x7
    8000195c:	fe87a783          	lw	a5,-24(a5) # 80008940 <first.1>
    80001960:	cf8d                	beqz	a5,8000199a <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001962:	4505                	li	a0,1
    80001964:	3dd010ef          	jal	80003540 <fsinit>

    first = 0;
    80001968:	00007797          	auipc	a5,0x7
    8000196c:	fc07ac23          	sw	zero,-40(a5) # 80008940 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80001970:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80001974:	00007517          	auipc	a0,0x7
    80001978:	80c50513          	addi	a0,a0,-2036 # 80008180 <etext+0x180>
    8000197c:	fca43823          	sd	a0,-48(s0)
    80001980:	fc043c23          	sd	zero,-40(s0)
    80001984:	fd040593          	addi	a1,s0,-48
    80001988:	519020ef          	jal	800046a0 <kexec>
    8000198c:	6cbc                	ld	a5,88(s1)
    8000198e:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80001990:	6cbc                	ld	a5,88(s1)
    80001992:	7bb8                	ld	a4,112(a5)
    80001994:	57fd                	li	a5,-1
    80001996:	02f70d63          	beq	a4,a5,800019d0 <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    8000199a:	2bd000ef          	jal	80002456 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000199e:	68a8                	ld	a0,80(s1)
    800019a0:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019a2:	04000737          	lui	a4,0x4000
    800019a6:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019a8:	0732                	slli	a4,a4,0xc
    800019aa:	00005797          	auipc	a5,0x5
    800019ae:	6f278793          	addi	a5,a5,1778 # 8000709c <userret>
    800019b2:	00005697          	auipc	a3,0x5
    800019b6:	64e68693          	addi	a3,a3,1614 # 80007000 <_trampoline>
    800019ba:	8f95                	sub	a5,a5,a3
    800019bc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019be:	577d                	li	a4,-1
    800019c0:	177e                	slli	a4,a4,0x3f
    800019c2:	8d59                	or	a0,a0,a4
    800019c4:	9782                	jalr	a5
}
    800019c6:	70a2                	ld	ra,40(sp)
    800019c8:	7402                	ld	s0,32(sp)
    800019ca:	64e2                	ld	s1,24(sp)
    800019cc:	6145                	addi	sp,sp,48
    800019ce:	8082                	ret
      panic("exec");
    800019d0:	00006517          	auipc	a0,0x6
    800019d4:	7b850513          	addi	a0,a0,1976 # 80008188 <etext+0x188>
    800019d8:	e07fe0ef          	jal	800007de <panic>

00000000800019dc <allocpid>:
{
    800019dc:	1101                	addi	sp,sp,-32
    800019de:	ec06                	sd	ra,24(sp)
    800019e0:	e822                	sd	s0,16(sp)
    800019e2:	e426                	sd	s1,8(sp)
    800019e4:	e04a                	sd	s2,0(sp)
    800019e6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019e8:	0000f917          	auipc	s2,0xf
    800019ec:	0b090913          	addi	s2,s2,176 # 80010a98 <pid_lock>
    800019f0:	854a                	mv	a0,s2
    800019f2:	a04ff0ef          	jal	80000bf6 <acquire>
  pid = nextpid;
    800019f6:	00007797          	auipc	a5,0x7
    800019fa:	f4e78793          	addi	a5,a5,-178 # 80008944 <nextpid>
    800019fe:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a00:	0014871b          	addiw	a4,s1,1
    80001a04:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a06:	854a                	mv	a0,s2
    80001a08:	a82ff0ef          	jal	80000c8a <release>
}
    80001a0c:	8526                	mv	a0,s1
    80001a0e:	60e2                	ld	ra,24(sp)
    80001a10:	6442                	ld	s0,16(sp)
    80001a12:	64a2                	ld	s1,8(sp)
    80001a14:	6902                	ld	s2,0(sp)
    80001a16:	6105                	addi	sp,sp,32
    80001a18:	8082                	ret

0000000080001a1a <proc_pagetable>:
{
    80001a1a:	1101                	addi	sp,sp,-32
    80001a1c:	ec06                	sd	ra,24(sp)
    80001a1e:	e822                	sd	s0,16(sp)
    80001a20:	e426                	sd	s1,8(sp)
    80001a22:	e04a                	sd	s2,0(sp)
    80001a24:	1000                	addi	s0,sp,32
    80001a26:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a28:	fdcff0ef          	jal	80001204 <uvmcreate>
    80001a2c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a2e:	cd05                	beqz	a0,80001a66 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a30:	4729                	li	a4,10
    80001a32:	00005697          	auipc	a3,0x5
    80001a36:	5ce68693          	addi	a3,a3,1486 # 80007000 <_trampoline>
    80001a3a:	6605                	lui	a2,0x1
    80001a3c:	040005b7          	lui	a1,0x4000
    80001a40:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a42:	05b2                	slli	a1,a1,0xc
    80001a44:	df6ff0ef          	jal	8000103a <mappages>
    80001a48:	02054663          	bltz	a0,80001a74 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a4c:	4719                	li	a4,6
    80001a4e:	05893683          	ld	a3,88(s2)
    80001a52:	6605                	lui	a2,0x1
    80001a54:	020005b7          	lui	a1,0x2000
    80001a58:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a5a:	05b6                	slli	a1,a1,0xd
    80001a5c:	8526                	mv	a0,s1
    80001a5e:	ddcff0ef          	jal	8000103a <mappages>
    80001a62:	00054f63          	bltz	a0,80001a80 <proc_pagetable+0x66>
}
    80001a66:	8526                	mv	a0,s1
    80001a68:	60e2                	ld	ra,24(sp)
    80001a6a:	6442                	ld	s0,16(sp)
    80001a6c:	64a2                	ld	s1,8(sp)
    80001a6e:	6902                	ld	s2,0(sp)
    80001a70:	6105                	addi	sp,sp,32
    80001a72:	8082                	ret
    uvmfree(pagetable, 0);
    80001a74:	4581                	li	a1,0
    80001a76:	8526                	mv	a0,s1
    80001a78:	98fff0ef          	jal	80001406 <uvmfree>
    return 0;
    80001a7c:	4481                	li	s1,0
    80001a7e:	b7e5                	j	80001a66 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a80:	4681                	li	a3,0
    80001a82:	4605                	li	a2,1
    80001a84:	040005b7          	lui	a1,0x4000
    80001a88:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a8a:	05b2                	slli	a1,a1,0xc
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	f9cff0ef          	jal	8000122a <uvmunmap>
    uvmfree(pagetable, 0);
    80001a92:	4581                	li	a1,0
    80001a94:	8526                	mv	a0,s1
    80001a96:	971ff0ef          	jal	80001406 <uvmfree>
    return 0;
    80001a9a:	4481                	li	s1,0
    80001a9c:	b7e9                	j	80001a66 <proc_pagetable+0x4c>

0000000080001a9e <proc_freepagetable>:
{
    80001a9e:	1101                	addi	sp,sp,-32
    80001aa0:	ec06                	sd	ra,24(sp)
    80001aa2:	e822                	sd	s0,16(sp)
    80001aa4:	e426                	sd	s1,8(sp)
    80001aa6:	e04a                	sd	s2,0(sp)
    80001aa8:	1000                	addi	s0,sp,32
    80001aaa:	84aa                	mv	s1,a0
    80001aac:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001aae:	4681                	li	a3,0
    80001ab0:	4605                	li	a2,1
    80001ab2:	040005b7          	lui	a1,0x4000
    80001ab6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ab8:	05b2                	slli	a1,a1,0xc
    80001aba:	f70ff0ef          	jal	8000122a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001abe:	4681                	li	a3,0
    80001ac0:	4605                	li	a2,1
    80001ac2:	020005b7          	lui	a1,0x2000
    80001ac6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ac8:	05b6                	slli	a1,a1,0xd
    80001aca:	8526                	mv	a0,s1
    80001acc:	f5eff0ef          	jal	8000122a <uvmunmap>
  uvmfree(pagetable, sz);
    80001ad0:	85ca                	mv	a1,s2
    80001ad2:	8526                	mv	a0,s1
    80001ad4:	933ff0ef          	jal	80001406 <uvmfree>
}
    80001ad8:	60e2                	ld	ra,24(sp)
    80001ada:	6442                	ld	s0,16(sp)
    80001adc:	64a2                	ld	s1,8(sp)
    80001ade:	6902                	ld	s2,0(sp)
    80001ae0:	6105                	addi	sp,sp,32
    80001ae2:	8082                	ret

0000000080001ae4 <freeproc>:
{
    80001ae4:	1101                	addi	sp,sp,-32
    80001ae6:	ec06                	sd	ra,24(sp)
    80001ae8:	e822                	sd	s0,16(sp)
    80001aea:	e426                	sd	s1,8(sp)
    80001aec:	1000                	addi	s0,sp,32
    80001aee:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001af0:	6d28                	ld	a0,88(a0)
    80001af2:	c119                	beqz	a0,80001af8 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001af4:	f4dfe0ef          	jal	80000a40 <kfree>
  p->trapframe = 0;
    80001af8:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001afc:	68a8                	ld	a0,80(s1)
    80001afe:	c501                	beqz	a0,80001b06 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001b00:	64ac                	ld	a1,72(s1)
    80001b02:	f9dff0ef          	jal	80001a9e <proc_freepagetable>
  p->pagetable = 0;
    80001b06:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b0a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b0e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b12:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b16:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b1a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b1e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b22:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b26:	0004ac23          	sw	zero,24(s1)
}
    80001b2a:	60e2                	ld	ra,24(sp)
    80001b2c:	6442                	ld	s0,16(sp)
    80001b2e:	64a2                	ld	s1,8(sp)
    80001b30:	6105                	addi	sp,sp,32
    80001b32:	8082                	ret

0000000080001b34 <allocproc>:
{
    80001b34:	1101                	addi	sp,sp,-32
    80001b36:	ec06                	sd	ra,24(sp)
    80001b38:	e822                	sd	s0,16(sp)
    80001b3a:	e426                	sd	s1,8(sp)
    80001b3c:	e04a                	sd	s2,0(sp)
    80001b3e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b40:	0000f497          	auipc	s1,0xf
    80001b44:	38848493          	addi	s1,s1,904 # 80010ec8 <proc>
    80001b48:	00015917          	auipc	s2,0x15
    80001b4c:	d8090913          	addi	s2,s2,-640 # 800168c8 <tickslock>
    acquire(&p->lock);
    80001b50:	8526                	mv	a0,s1
    80001b52:	8a4ff0ef          	jal	80000bf6 <acquire>
    if(p->state == UNUSED) {
    80001b56:	4c9c                	lw	a5,24(s1)
    80001b58:	cb91                	beqz	a5,80001b6c <allocproc+0x38>
      release(&p->lock);
    80001b5a:	8526                	mv	a0,s1
    80001b5c:	92eff0ef          	jal	80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b60:	16848493          	addi	s1,s1,360
    80001b64:	ff2496e3          	bne	s1,s2,80001b50 <allocproc+0x1c>
  return 0;
    80001b68:	4481                	li	s1,0
    80001b6a:	a089                	j	80001bac <allocproc+0x78>
  p->pid = allocpid();
    80001b6c:	e71ff0ef          	jal	800019dc <allocpid>
    80001b70:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b72:	4785                	li	a5,1
    80001b74:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001b76:	fadfe0ef          	jal	80000b22 <kalloc>
    80001b7a:	892a                	mv	s2,a0
    80001b7c:	eca8                	sd	a0,88(s1)
    80001b7e:	cd15                	beqz	a0,80001bba <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b80:	8526                	mv	a0,s1
    80001b82:	e99ff0ef          	jal	80001a1a <proc_pagetable>
    80001b86:	892a                	mv	s2,a0
    80001b88:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001b8a:	c121                	beqz	a0,80001bca <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b8c:	07000613          	li	a2,112
    80001b90:	4581                	li	a1,0
    80001b92:	06048513          	addi	a0,s1,96
    80001b96:	930ff0ef          	jal	80000cc6 <memset>
  p->context.ra = (uint64)forkret;
    80001b9a:	00000797          	auipc	a5,0x0
    80001b9e:	daa78793          	addi	a5,a5,-598 # 80001944 <forkret>
    80001ba2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001ba4:	60bc                	ld	a5,64(s1)
    80001ba6:	6705                	lui	a4,0x1
    80001ba8:	97ba                	add	a5,a5,a4
    80001baa:	f4bc                	sd	a5,104(s1)
}
    80001bac:	8526                	mv	a0,s1
    80001bae:	60e2                	ld	ra,24(sp)
    80001bb0:	6442                	ld	s0,16(sp)
    80001bb2:	64a2                	ld	s1,8(sp)
    80001bb4:	6902                	ld	s2,0(sp)
    80001bb6:	6105                	addi	sp,sp,32
    80001bb8:	8082                	ret
    freeproc(p);
    80001bba:	8526                	mv	a0,s1
    80001bbc:	f29ff0ef          	jal	80001ae4 <freeproc>
    release(&p->lock);
    80001bc0:	8526                	mv	a0,s1
    80001bc2:	8c8ff0ef          	jal	80000c8a <release>
    return 0;
    80001bc6:	84ca                	mv	s1,s2
    80001bc8:	b7d5                	j	80001bac <allocproc+0x78>
    freeproc(p);
    80001bca:	8526                	mv	a0,s1
    80001bcc:	f19ff0ef          	jal	80001ae4 <freeproc>
    release(&p->lock);
    80001bd0:	8526                	mv	a0,s1
    80001bd2:	8b8ff0ef          	jal	80000c8a <release>
    return 0;
    80001bd6:	84ca                	mv	s1,s2
    80001bd8:	bfd1                	j	80001bac <allocproc+0x78>

0000000080001bda <userinit>:
{
    80001bda:	1101                	addi	sp,sp,-32
    80001bdc:	ec06                	sd	ra,24(sp)
    80001bde:	e822                	sd	s0,16(sp)
    80001be0:	e426                	sd	s1,8(sp)
    80001be2:	1000                	addi	s0,sp,32
  p = allocproc();
    80001be4:	f51ff0ef          	jal	80001b34 <allocproc>
    80001be8:	84aa                	mv	s1,a0
  initproc = p;
    80001bea:	00007797          	auipc	a5,0x7
    80001bee:	d8a7bb23          	sd	a0,-618(a5) # 80008980 <initproc>
  p->cwd = namei("/");
    80001bf2:	00006517          	auipc	a0,0x6
    80001bf6:	59e50513          	addi	a0,a0,1438 # 80008190 <etext+0x190>
    80001bfa:	67f010ef          	jal	80003a78 <namei>
    80001bfe:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001c02:	478d                	li	a5,3
    80001c04:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c06:	8526                	mv	a0,s1
    80001c08:	882ff0ef          	jal	80000c8a <release>
}
    80001c0c:	60e2                	ld	ra,24(sp)
    80001c0e:	6442                	ld	s0,16(sp)
    80001c10:	64a2                	ld	s1,8(sp)
    80001c12:	6105                	addi	sp,sp,32
    80001c14:	8082                	ret

0000000080001c16 <growproc>:
{
    80001c16:	1101                	addi	sp,sp,-32
    80001c18:	ec06                	sd	ra,24(sp)
    80001c1a:	e822                	sd	s0,16(sp)
    80001c1c:	e426                	sd	s1,8(sp)
    80001c1e:	e04a                	sd	s2,0(sp)
    80001c20:	1000                	addi	s0,sp,32
    80001c22:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c24:	cf1ff0ef          	jal	80001914 <myproc>
    80001c28:	892a                	mv	s2,a0
  sz = p->sz;
    80001c2a:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001c2c:	02905963          	blez	s1,80001c5e <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80001c30:	00b48633          	add	a2,s1,a1
    80001c34:	020007b7          	lui	a5,0x2000
    80001c38:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c3a:	07b6                	slli	a5,a5,0xd
    80001c3c:	02c7ea63          	bltu	a5,a2,80001c70 <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c40:	4691                	li	a3,4
    80001c42:	6928                	ld	a0,80(a0)
    80001c44:	eb4ff0ef          	jal	800012f8 <uvmalloc>
    80001c48:	85aa                	mv	a1,a0
    80001c4a:	c50d                	beqz	a0,80001c74 <growproc+0x5e>
  p->sz = sz;
    80001c4c:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c50:	4501                	li	a0,0
}
    80001c52:	60e2                	ld	ra,24(sp)
    80001c54:	6442                	ld	s0,16(sp)
    80001c56:	64a2                	ld	s1,8(sp)
    80001c58:	6902                	ld	s2,0(sp)
    80001c5a:	6105                	addi	sp,sp,32
    80001c5c:	8082                	ret
  } else if(n < 0){
    80001c5e:	fe04d7e3          	bgez	s1,80001c4c <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c62:	00b48633          	add	a2,s1,a1
    80001c66:	6928                	ld	a0,80(a0)
    80001c68:	e4cff0ef          	jal	800012b4 <uvmdealloc>
    80001c6c:	85aa                	mv	a1,a0
    80001c6e:	bff9                	j	80001c4c <growproc+0x36>
      return -1;
    80001c70:	557d                	li	a0,-1
    80001c72:	b7c5                	j	80001c52 <growproc+0x3c>
      return -1;
    80001c74:	557d                	li	a0,-1
    80001c76:	bff1                	j	80001c52 <growproc+0x3c>

0000000080001c78 <kfork>:
{
    80001c78:	7139                	addi	sp,sp,-64
    80001c7a:	fc06                	sd	ra,56(sp)
    80001c7c:	f822                	sd	s0,48(sp)
    80001c7e:	f04a                	sd	s2,32(sp)
    80001c80:	e456                	sd	s5,8(sp)
    80001c82:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c84:	c91ff0ef          	jal	80001914 <myproc>
    80001c88:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c8a:	eabff0ef          	jal	80001b34 <allocproc>
    80001c8e:	0e050a63          	beqz	a0,80001d82 <kfork+0x10a>
    80001c92:	e852                	sd	s4,16(sp)
    80001c94:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c96:	048ab603          	ld	a2,72(s5)
    80001c9a:	692c                	ld	a1,80(a0)
    80001c9c:	050ab503          	ld	a0,80(s5)
    80001ca0:	f98ff0ef          	jal	80001438 <uvmcopy>
    80001ca4:	04054a63          	bltz	a0,80001cf8 <kfork+0x80>
    80001ca8:	f426                	sd	s1,40(sp)
    80001caa:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001cac:	048ab783          	ld	a5,72(s5)
    80001cb0:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001cb4:	058ab683          	ld	a3,88(s5)
    80001cb8:	87b6                	mv	a5,a3
    80001cba:	058a3703          	ld	a4,88(s4)
    80001cbe:	12068693          	addi	a3,a3,288
    80001cc2:	0007b803          	ld	a6,0(a5)
    80001cc6:	6788                	ld	a0,8(a5)
    80001cc8:	6b8c                	ld	a1,16(a5)
    80001cca:	6f90                	ld	a2,24(a5)
    80001ccc:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001cd0:	e708                	sd	a0,8(a4)
    80001cd2:	eb0c                	sd	a1,16(a4)
    80001cd4:	ef10                	sd	a2,24(a4)
    80001cd6:	02078793          	addi	a5,a5,32
    80001cda:	02070713          	addi	a4,a4,32
    80001cde:	fed792e3          	bne	a5,a3,80001cc2 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001ce2:	058a3783          	ld	a5,88(s4)
    80001ce6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001cea:	0d0a8493          	addi	s1,s5,208
    80001cee:	0d0a0913          	addi	s2,s4,208
    80001cf2:	150a8993          	addi	s3,s5,336
    80001cf6:	a831                	j	80001d12 <kfork+0x9a>
    freeproc(np);
    80001cf8:	8552                	mv	a0,s4
    80001cfa:	debff0ef          	jal	80001ae4 <freeproc>
    release(&np->lock);
    80001cfe:	8552                	mv	a0,s4
    80001d00:	f8bfe0ef          	jal	80000c8a <release>
    return -1;
    80001d04:	597d                	li	s2,-1
    80001d06:	6a42                	ld	s4,16(sp)
    80001d08:	a0b5                	j	80001d74 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001d0a:	04a1                	addi	s1,s1,8
    80001d0c:	0921                	addi	s2,s2,8
    80001d0e:	01348963          	beq	s1,s3,80001d20 <kfork+0xa8>
    if(p->ofile[i])
    80001d12:	6088                	ld	a0,0(s1)
    80001d14:	d97d                	beqz	a0,80001d0a <kfork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d16:	308020ef          	jal	8000401e <filedup>
    80001d1a:	00a93023          	sd	a0,0(s2)
    80001d1e:	b7f5                	j	80001d0a <kfork+0x92>
  np->cwd = idup(p->cwd);
    80001d20:	150ab503          	ld	a0,336(s5)
    80001d24:	4f4010ef          	jal	80003218 <idup>
    80001d28:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d2c:	4641                	li	a2,16
    80001d2e:	158a8593          	addi	a1,s5,344
    80001d32:	158a0513          	addi	a0,s4,344
    80001d36:	8e2ff0ef          	jal	80000e18 <safestrcpy>
  pid = np->pid;
    80001d3a:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001d3e:	8552                	mv	a0,s4
    80001d40:	f4bfe0ef          	jal	80000c8a <release>
  acquire(&wait_lock);
    80001d44:	0000f497          	auipc	s1,0xf
    80001d48:	d6c48493          	addi	s1,s1,-660 # 80010ab0 <wait_lock>
    80001d4c:	8526                	mv	a0,s1
    80001d4e:	ea9fe0ef          	jal	80000bf6 <acquire>
  np->parent = p;
    80001d52:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001d56:	8526                	mv	a0,s1
    80001d58:	f33fe0ef          	jal	80000c8a <release>
  acquire(&np->lock);
    80001d5c:	8552                	mv	a0,s4
    80001d5e:	e99fe0ef          	jal	80000bf6 <acquire>
  np->state = RUNNABLE;
    80001d62:	478d                	li	a5,3
    80001d64:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d68:	8552                	mv	a0,s4
    80001d6a:	f21fe0ef          	jal	80000c8a <release>
  return pid;
    80001d6e:	74a2                	ld	s1,40(sp)
    80001d70:	69e2                	ld	s3,24(sp)
    80001d72:	6a42                	ld	s4,16(sp)
}
    80001d74:	854a                	mv	a0,s2
    80001d76:	70e2                	ld	ra,56(sp)
    80001d78:	7442                	ld	s0,48(sp)
    80001d7a:	7902                	ld	s2,32(sp)
    80001d7c:	6aa2                	ld	s5,8(sp)
    80001d7e:	6121                	addi	sp,sp,64
    80001d80:	8082                	ret
    return -1;
    80001d82:	597d                	li	s2,-1
    80001d84:	bfc5                	j	80001d74 <kfork+0xfc>

0000000080001d86 <scheduler>:
{
    80001d86:	715d                	addi	sp,sp,-80
    80001d88:	e486                	sd	ra,72(sp)
    80001d8a:	e0a2                	sd	s0,64(sp)
    80001d8c:	fc26                	sd	s1,56(sp)
    80001d8e:	f84a                	sd	s2,48(sp)
    80001d90:	f44e                	sd	s3,40(sp)
    80001d92:	f052                	sd	s4,32(sp)
    80001d94:	ec56                	sd	s5,24(sp)
    80001d96:	e85a                	sd	s6,16(sp)
    80001d98:	e45e                	sd	s7,8(sp)
    80001d9a:	e062                	sd	s8,0(sp)
    80001d9c:	0880                	addi	s0,sp,80
    80001d9e:	8792                	mv	a5,tp
  int id = r_tp();
    80001da0:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001da2:	00779b13          	slli	s6,a5,0x7
    80001da6:	0000f717          	auipc	a4,0xf
    80001daa:	cf270713          	addi	a4,a4,-782 # 80010a98 <pid_lock>
    80001dae:	975a                	add	a4,a4,s6
    80001db0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001db4:	0000f717          	auipc	a4,0xf
    80001db8:	d1c70713          	addi	a4,a4,-740 # 80010ad0 <cpus+0x8>
    80001dbc:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001dbe:	4c11                	li	s8,4
        c->proc = p;
    80001dc0:	079e                	slli	a5,a5,0x7
    80001dc2:	0000fa17          	auipc	s4,0xf
    80001dc6:	cd6a0a13          	addi	s4,s4,-810 # 80010a98 <pid_lock>
    80001dca:	9a3e                	add	s4,s4,a5
        found = 1;
    80001dcc:	4b85                	li	s7,1
    80001dce:	a83d                	j	80001e0c <scheduler+0x86>
      release(&p->lock);
    80001dd0:	8526                	mv	a0,s1
    80001dd2:	eb9fe0ef          	jal	80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dd6:	16848493          	addi	s1,s1,360
    80001dda:	03248563          	beq	s1,s2,80001e04 <scheduler+0x7e>
      acquire(&p->lock);
    80001dde:	8526                	mv	a0,s1
    80001de0:	e17fe0ef          	jal	80000bf6 <acquire>
      if(p->state == RUNNABLE) {
    80001de4:	4c9c                	lw	a5,24(s1)
    80001de6:	ff3795e3          	bne	a5,s3,80001dd0 <scheduler+0x4a>
        p->state = RUNNING;
    80001dea:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001dee:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001df2:	06048593          	addi	a1,s1,96
    80001df6:	855a                	mv	a0,s6
    80001df8:	5b4000ef          	jal	800023ac <swtch>
        c->proc = 0;
    80001dfc:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001e00:	8ade                	mv	s5,s7
    80001e02:	b7f9                	j	80001dd0 <scheduler+0x4a>
    if(found == 0) {
    80001e04:	000a9463          	bnez	s5,80001e0c <scheduler+0x86>
      asm volatile("wfi");
    80001e08:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e0c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e10:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e14:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e18:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001e1c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e1e:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001e22:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e24:	0000f497          	auipc	s1,0xf
    80001e28:	0a448493          	addi	s1,s1,164 # 80010ec8 <proc>
      if(p->state == RUNNABLE) {
    80001e2c:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e2e:	00015917          	auipc	s2,0x15
    80001e32:	a9a90913          	addi	s2,s2,-1382 # 800168c8 <tickslock>
    80001e36:	b765                	j	80001dde <scheduler+0x58>

0000000080001e38 <sched>:
{
    80001e38:	7179                	addi	sp,sp,-48
    80001e3a:	f406                	sd	ra,40(sp)
    80001e3c:	f022                	sd	s0,32(sp)
    80001e3e:	ec26                	sd	s1,24(sp)
    80001e40:	e84a                	sd	s2,16(sp)
    80001e42:	e44e                	sd	s3,8(sp)
    80001e44:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e46:	acfff0ef          	jal	80001914 <myproc>
    80001e4a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e4c:	d41fe0ef          	jal	80000b8c <holding>
    80001e50:	c92d                	beqz	a0,80001ec2 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e52:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e54:	2781                	sext.w	a5,a5
    80001e56:	079e                	slli	a5,a5,0x7
    80001e58:	0000f717          	auipc	a4,0xf
    80001e5c:	c4070713          	addi	a4,a4,-960 # 80010a98 <pid_lock>
    80001e60:	97ba                	add	a5,a5,a4
    80001e62:	0a87a703          	lw	a4,168(a5)
    80001e66:	4785                	li	a5,1
    80001e68:	06f71363          	bne	a4,a5,80001ece <sched+0x96>
  if(p->state == RUNNING)
    80001e6c:	4c98                	lw	a4,24(s1)
    80001e6e:	4791                	li	a5,4
    80001e70:	06f70563          	beq	a4,a5,80001eda <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e74:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e78:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e7a:	e7b5                	bnez	a5,80001ee6 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e7c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e7e:	0000f917          	auipc	s2,0xf
    80001e82:	c1a90913          	addi	s2,s2,-998 # 80010a98 <pid_lock>
    80001e86:	2781                	sext.w	a5,a5
    80001e88:	079e                	slli	a5,a5,0x7
    80001e8a:	97ca                	add	a5,a5,s2
    80001e8c:	0ac7a983          	lw	s3,172(a5)
    80001e90:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e92:	2781                	sext.w	a5,a5
    80001e94:	079e                	slli	a5,a5,0x7
    80001e96:	0000f597          	auipc	a1,0xf
    80001e9a:	c3a58593          	addi	a1,a1,-966 # 80010ad0 <cpus+0x8>
    80001e9e:	95be                	add	a1,a1,a5
    80001ea0:	06048513          	addi	a0,s1,96
    80001ea4:	508000ef          	jal	800023ac <swtch>
    80001ea8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001eaa:	2781                	sext.w	a5,a5
    80001eac:	079e                	slli	a5,a5,0x7
    80001eae:	993e                	add	s2,s2,a5
    80001eb0:	0b392623          	sw	s3,172(s2)
}
    80001eb4:	70a2                	ld	ra,40(sp)
    80001eb6:	7402                	ld	s0,32(sp)
    80001eb8:	64e2                	ld	s1,24(sp)
    80001eba:	6942                	ld	s2,16(sp)
    80001ebc:	69a2                	ld	s3,8(sp)
    80001ebe:	6145                	addi	sp,sp,48
    80001ec0:	8082                	ret
    panic("sched p->lock");
    80001ec2:	00006517          	auipc	a0,0x6
    80001ec6:	2d650513          	addi	a0,a0,726 # 80008198 <etext+0x198>
    80001eca:	915fe0ef          	jal	800007de <panic>
    panic("sched locks");
    80001ece:	00006517          	auipc	a0,0x6
    80001ed2:	2da50513          	addi	a0,a0,730 # 800081a8 <etext+0x1a8>
    80001ed6:	909fe0ef          	jal	800007de <panic>
    panic("sched RUNNING");
    80001eda:	00006517          	auipc	a0,0x6
    80001ede:	2de50513          	addi	a0,a0,734 # 800081b8 <etext+0x1b8>
    80001ee2:	8fdfe0ef          	jal	800007de <panic>
    panic("sched interruptible");
    80001ee6:	00006517          	auipc	a0,0x6
    80001eea:	2e250513          	addi	a0,a0,738 # 800081c8 <etext+0x1c8>
    80001eee:	8f1fe0ef          	jal	800007de <panic>

0000000080001ef2 <yield>:
{
    80001ef2:	1101                	addi	sp,sp,-32
    80001ef4:	ec06                	sd	ra,24(sp)
    80001ef6:	e822                	sd	s0,16(sp)
    80001ef8:	e426                	sd	s1,8(sp)
    80001efa:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001efc:	a19ff0ef          	jal	80001914 <myproc>
    80001f00:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f02:	cf5fe0ef          	jal	80000bf6 <acquire>
  p->state = RUNNABLE;
    80001f06:	478d                	li	a5,3
    80001f08:	cc9c                	sw	a5,24(s1)
  sched();
    80001f0a:	f2fff0ef          	jal	80001e38 <sched>
  release(&p->lock);
    80001f0e:	8526                	mv	a0,s1
    80001f10:	d7bfe0ef          	jal	80000c8a <release>
}
    80001f14:	60e2                	ld	ra,24(sp)
    80001f16:	6442                	ld	s0,16(sp)
    80001f18:	64a2                	ld	s1,8(sp)
    80001f1a:	6105                	addi	sp,sp,32
    80001f1c:	8082                	ret

0000000080001f1e <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001f1e:	7179                	addi	sp,sp,-48
    80001f20:	f406                	sd	ra,40(sp)
    80001f22:	f022                	sd	s0,32(sp)
    80001f24:	ec26                	sd	s1,24(sp)
    80001f26:	e84a                	sd	s2,16(sp)
    80001f28:	e44e                	sd	s3,8(sp)
    80001f2a:	1800                	addi	s0,sp,48
    80001f2c:	89aa                	mv	s3,a0
    80001f2e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f30:	9e5ff0ef          	jal	80001914 <myproc>
    80001f34:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001f36:	cc1fe0ef          	jal	80000bf6 <acquire>
  release(lk);
    80001f3a:	854a                	mv	a0,s2
    80001f3c:	d4ffe0ef          	jal	80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    80001f40:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001f44:	4789                	li	a5,2
    80001f46:	cc9c                	sw	a5,24(s1)

  sched();
    80001f48:	ef1ff0ef          	jal	80001e38 <sched>

  // Tidy up.
  p->chan = 0;
    80001f4c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f50:	8526                	mv	a0,s1
    80001f52:	d39fe0ef          	jal	80000c8a <release>
  acquire(lk);
    80001f56:	854a                	mv	a0,s2
    80001f58:	c9ffe0ef          	jal	80000bf6 <acquire>
}
    80001f5c:	70a2                	ld	ra,40(sp)
    80001f5e:	7402                	ld	s0,32(sp)
    80001f60:	64e2                	ld	s1,24(sp)
    80001f62:	6942                	ld	s2,16(sp)
    80001f64:	69a2                	ld	s3,8(sp)
    80001f66:	6145                	addi	sp,sp,48
    80001f68:	8082                	ret

0000000080001f6a <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001f6a:	7139                	addi	sp,sp,-64
    80001f6c:	fc06                	sd	ra,56(sp)
    80001f6e:	f822                	sd	s0,48(sp)
    80001f70:	f426                	sd	s1,40(sp)
    80001f72:	f04a                	sd	s2,32(sp)
    80001f74:	ec4e                	sd	s3,24(sp)
    80001f76:	e852                	sd	s4,16(sp)
    80001f78:	e456                	sd	s5,8(sp)
    80001f7a:	0080                	addi	s0,sp,64
    80001f7c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f7e:	0000f497          	auipc	s1,0xf
    80001f82:	f4a48493          	addi	s1,s1,-182 # 80010ec8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001f86:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f88:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f8a:	00015917          	auipc	s2,0x15
    80001f8e:	93e90913          	addi	s2,s2,-1730 # 800168c8 <tickslock>
    80001f92:	a801                	j	80001fa2 <wakeup+0x38>
      }
      release(&p->lock);
    80001f94:	8526                	mv	a0,s1
    80001f96:	cf5fe0ef          	jal	80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f9a:	16848493          	addi	s1,s1,360
    80001f9e:	03248263          	beq	s1,s2,80001fc2 <wakeup+0x58>
    if(p != myproc()){
    80001fa2:	973ff0ef          	jal	80001914 <myproc>
    80001fa6:	fea48ae3          	beq	s1,a0,80001f9a <wakeup+0x30>
      acquire(&p->lock);
    80001faa:	8526                	mv	a0,s1
    80001fac:	c4bfe0ef          	jal	80000bf6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001fb0:	4c9c                	lw	a5,24(s1)
    80001fb2:	ff3791e3          	bne	a5,s3,80001f94 <wakeup+0x2a>
    80001fb6:	709c                	ld	a5,32(s1)
    80001fb8:	fd479ee3          	bne	a5,s4,80001f94 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001fbc:	0154ac23          	sw	s5,24(s1)
    80001fc0:	bfd1                	j	80001f94 <wakeup+0x2a>
    }
  }
}
    80001fc2:	70e2                	ld	ra,56(sp)
    80001fc4:	7442                	ld	s0,48(sp)
    80001fc6:	74a2                	ld	s1,40(sp)
    80001fc8:	7902                	ld	s2,32(sp)
    80001fca:	69e2                	ld	s3,24(sp)
    80001fcc:	6a42                	ld	s4,16(sp)
    80001fce:	6aa2                	ld	s5,8(sp)
    80001fd0:	6121                	addi	sp,sp,64
    80001fd2:	8082                	ret

0000000080001fd4 <reparent>:
{
    80001fd4:	7179                	addi	sp,sp,-48
    80001fd6:	f406                	sd	ra,40(sp)
    80001fd8:	f022                	sd	s0,32(sp)
    80001fda:	ec26                	sd	s1,24(sp)
    80001fdc:	e84a                	sd	s2,16(sp)
    80001fde:	e44e                	sd	s3,8(sp)
    80001fe0:	e052                	sd	s4,0(sp)
    80001fe2:	1800                	addi	s0,sp,48
    80001fe4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fe6:	0000f497          	auipc	s1,0xf
    80001fea:	ee248493          	addi	s1,s1,-286 # 80010ec8 <proc>
      pp->parent = initproc;
    80001fee:	00007a17          	auipc	s4,0x7
    80001ff2:	992a0a13          	addi	s4,s4,-1646 # 80008980 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ff6:	00015997          	auipc	s3,0x15
    80001ffa:	8d298993          	addi	s3,s3,-1838 # 800168c8 <tickslock>
    80001ffe:	a029                	j	80002008 <reparent+0x34>
    80002000:	16848493          	addi	s1,s1,360
    80002004:	01348b63          	beq	s1,s3,8000201a <reparent+0x46>
    if(pp->parent == p){
    80002008:	7c9c                	ld	a5,56(s1)
    8000200a:	ff279be3          	bne	a5,s2,80002000 <reparent+0x2c>
      pp->parent = initproc;
    8000200e:	000a3503          	ld	a0,0(s4)
    80002012:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002014:	f57ff0ef          	jal	80001f6a <wakeup>
    80002018:	b7e5                	j	80002000 <reparent+0x2c>
}
    8000201a:	70a2                	ld	ra,40(sp)
    8000201c:	7402                	ld	s0,32(sp)
    8000201e:	64e2                	ld	s1,24(sp)
    80002020:	6942                	ld	s2,16(sp)
    80002022:	69a2                	ld	s3,8(sp)
    80002024:	6a02                	ld	s4,0(sp)
    80002026:	6145                	addi	sp,sp,48
    80002028:	8082                	ret

000000008000202a <kexit>:
{
    8000202a:	7179                	addi	sp,sp,-48
    8000202c:	f406                	sd	ra,40(sp)
    8000202e:	f022                	sd	s0,32(sp)
    80002030:	ec26                	sd	s1,24(sp)
    80002032:	e84a                	sd	s2,16(sp)
    80002034:	e44e                	sd	s3,8(sp)
    80002036:	e052                	sd	s4,0(sp)
    80002038:	1800                	addi	s0,sp,48
    8000203a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000203c:	8d9ff0ef          	jal	80001914 <myproc>
    80002040:	89aa                	mv	s3,a0
  if(p == initproc)
    80002042:	00007797          	auipc	a5,0x7
    80002046:	93e7b783          	ld	a5,-1730(a5) # 80008980 <initproc>
    8000204a:	0d050493          	addi	s1,a0,208
    8000204e:	15050913          	addi	s2,a0,336
    80002052:	00a79b63          	bne	a5,a0,80002068 <kexit+0x3e>
    panic("init exiting");
    80002056:	00006517          	auipc	a0,0x6
    8000205a:	18a50513          	addi	a0,a0,394 # 800081e0 <etext+0x1e0>
    8000205e:	f80fe0ef          	jal	800007de <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002062:	04a1                	addi	s1,s1,8
    80002064:	01248963          	beq	s1,s2,80002076 <kexit+0x4c>
    if(p->ofile[fd]){
    80002068:	6088                	ld	a0,0(s1)
    8000206a:	dd65                	beqz	a0,80002062 <kexit+0x38>
      fileclose(f);
    8000206c:	7f9010ef          	jal	80004064 <fileclose>
      p->ofile[fd] = 0;
    80002070:	0004b023          	sd	zero,0(s1)
    80002074:	b7fd                	j	80002062 <kexit+0x38>
  begin_op();
    80002076:	3dd010ef          	jal	80003c52 <begin_op>
  iput(p->cwd);
    8000207a:	1509b503          	ld	a0,336(s3)
    8000207e:	352010ef          	jal	800033d0 <iput>
  end_op();
    80002082:	43b010ef          	jal	80003cbc <end_op>
  p->cwd = 0;
    80002086:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000208a:	0000f497          	auipc	s1,0xf
    8000208e:	a2648493          	addi	s1,s1,-1498 # 80010ab0 <wait_lock>
    80002092:	8526                	mv	a0,s1
    80002094:	b63fe0ef          	jal	80000bf6 <acquire>
  reparent(p);
    80002098:	854e                	mv	a0,s3
    8000209a:	f3bff0ef          	jal	80001fd4 <reparent>
  wakeup(p->parent);
    8000209e:	0389b503          	ld	a0,56(s3)
    800020a2:	ec9ff0ef          	jal	80001f6a <wakeup>
  acquire(&p->lock);
    800020a6:	854e                	mv	a0,s3
    800020a8:	b4ffe0ef          	jal	80000bf6 <acquire>
  p->xstate = status;
    800020ac:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800020b0:	4795                	li	a5,5
    800020b2:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800020b6:	8526                	mv	a0,s1
    800020b8:	bd3fe0ef          	jal	80000c8a <release>
  sched();
    800020bc:	d7dff0ef          	jal	80001e38 <sched>
  panic("zombie exit");
    800020c0:	00006517          	auipc	a0,0x6
    800020c4:	13050513          	addi	a0,a0,304 # 800081f0 <etext+0x1f0>
    800020c8:	f16fe0ef          	jal	800007de <panic>

00000000800020cc <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800020cc:	7179                	addi	sp,sp,-48
    800020ce:	f406                	sd	ra,40(sp)
    800020d0:	f022                	sd	s0,32(sp)
    800020d2:	ec26                	sd	s1,24(sp)
    800020d4:	e84a                	sd	s2,16(sp)
    800020d6:	e44e                	sd	s3,8(sp)
    800020d8:	1800                	addi	s0,sp,48
    800020da:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800020dc:	0000f497          	auipc	s1,0xf
    800020e0:	dec48493          	addi	s1,s1,-532 # 80010ec8 <proc>
    800020e4:	00014997          	auipc	s3,0x14
    800020e8:	7e498993          	addi	s3,s3,2020 # 800168c8 <tickslock>
    acquire(&p->lock);
    800020ec:	8526                	mv	a0,s1
    800020ee:	b09fe0ef          	jal	80000bf6 <acquire>
    if(p->pid == pid){
    800020f2:	589c                	lw	a5,48(s1)
    800020f4:	01278b63          	beq	a5,s2,8000210a <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800020f8:	8526                	mv	a0,s1
    800020fa:	b91fe0ef          	jal	80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800020fe:	16848493          	addi	s1,s1,360
    80002102:	ff3495e3          	bne	s1,s3,800020ec <kkill+0x20>
  }
  return -1;
    80002106:	557d                	li	a0,-1
    80002108:	a819                	j	8000211e <kkill+0x52>
      p->killed = 1;
    8000210a:	4785                	li	a5,1
    8000210c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000210e:	4c98                	lw	a4,24(s1)
    80002110:	4789                	li	a5,2
    80002112:	00f70d63          	beq	a4,a5,8000212c <kkill+0x60>
      release(&p->lock);
    80002116:	8526                	mv	a0,s1
    80002118:	b73fe0ef          	jal	80000c8a <release>
      return 0;
    8000211c:	4501                	li	a0,0
}
    8000211e:	70a2                	ld	ra,40(sp)
    80002120:	7402                	ld	s0,32(sp)
    80002122:	64e2                	ld	s1,24(sp)
    80002124:	6942                	ld	s2,16(sp)
    80002126:	69a2                	ld	s3,8(sp)
    80002128:	6145                	addi	sp,sp,48
    8000212a:	8082                	ret
        p->state = RUNNABLE;
    8000212c:	478d                	li	a5,3
    8000212e:	cc9c                	sw	a5,24(s1)
    80002130:	b7dd                	j	80002116 <kkill+0x4a>

0000000080002132 <setkilled>:

void
setkilled(struct proc *p)
{
    80002132:	1101                	addi	sp,sp,-32
    80002134:	ec06                	sd	ra,24(sp)
    80002136:	e822                	sd	s0,16(sp)
    80002138:	e426                	sd	s1,8(sp)
    8000213a:	1000                	addi	s0,sp,32
    8000213c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000213e:	ab9fe0ef          	jal	80000bf6 <acquire>
  p->killed = 1;
    80002142:	4785                	li	a5,1
    80002144:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002146:	8526                	mv	a0,s1
    80002148:	b43fe0ef          	jal	80000c8a <release>
}
    8000214c:	60e2                	ld	ra,24(sp)
    8000214e:	6442                	ld	s0,16(sp)
    80002150:	64a2                	ld	s1,8(sp)
    80002152:	6105                	addi	sp,sp,32
    80002154:	8082                	ret

0000000080002156 <killed>:

int
killed(struct proc *p)
{
    80002156:	1101                	addi	sp,sp,-32
    80002158:	ec06                	sd	ra,24(sp)
    8000215a:	e822                	sd	s0,16(sp)
    8000215c:	e426                	sd	s1,8(sp)
    8000215e:	e04a                	sd	s2,0(sp)
    80002160:	1000                	addi	s0,sp,32
    80002162:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002164:	a93fe0ef          	jal	80000bf6 <acquire>
  k = p->killed;
    80002168:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000216c:	8526                	mv	a0,s1
    8000216e:	b1dfe0ef          	jal	80000c8a <release>
  return k;
}
    80002172:	854a                	mv	a0,s2
    80002174:	60e2                	ld	ra,24(sp)
    80002176:	6442                	ld	s0,16(sp)
    80002178:	64a2                	ld	s1,8(sp)
    8000217a:	6902                	ld	s2,0(sp)
    8000217c:	6105                	addi	sp,sp,32
    8000217e:	8082                	ret

0000000080002180 <kwait>:
{
    80002180:	715d                	addi	sp,sp,-80
    80002182:	e486                	sd	ra,72(sp)
    80002184:	e0a2                	sd	s0,64(sp)
    80002186:	fc26                	sd	s1,56(sp)
    80002188:	f84a                	sd	s2,48(sp)
    8000218a:	f44e                	sd	s3,40(sp)
    8000218c:	f052                	sd	s4,32(sp)
    8000218e:	ec56                	sd	s5,24(sp)
    80002190:	e85a                	sd	s6,16(sp)
    80002192:	e45e                	sd	s7,8(sp)
    80002194:	0880                	addi	s0,sp,80
    80002196:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002198:	f7cff0ef          	jal	80001914 <myproc>
    8000219c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000219e:	0000f517          	auipc	a0,0xf
    800021a2:	91250513          	addi	a0,a0,-1774 # 80010ab0 <wait_lock>
    800021a6:	a51fe0ef          	jal	80000bf6 <acquire>
        if(pp->state == ZOMBIE){
    800021aa:	4a15                	li	s4,5
        havekids = 1;
    800021ac:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021ae:	00014997          	auipc	s3,0x14
    800021b2:	71a98993          	addi	s3,s3,1818 # 800168c8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021b6:	0000fb97          	auipc	s7,0xf
    800021ba:	8fab8b93          	addi	s7,s7,-1798 # 80010ab0 <wait_lock>
    800021be:	a869                	j	80002258 <kwait+0xd8>
          pid = pp->pid;
    800021c0:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800021c4:	000b0c63          	beqz	s6,800021dc <kwait+0x5c>
    800021c8:	4691                	li	a3,4
    800021ca:	02c48613          	addi	a2,s1,44
    800021ce:	85da                	mv	a1,s6
    800021d0:	05093503          	ld	a0,80(s2)
    800021d4:	c72ff0ef          	jal	80001646 <copyout>
    800021d8:	02054a63          	bltz	a0,8000220c <kwait+0x8c>
          freeproc(pp);
    800021dc:	8526                	mv	a0,s1
    800021de:	907ff0ef          	jal	80001ae4 <freeproc>
          release(&pp->lock);
    800021e2:	8526                	mv	a0,s1
    800021e4:	aa7fe0ef          	jal	80000c8a <release>
          release(&wait_lock);
    800021e8:	0000f517          	auipc	a0,0xf
    800021ec:	8c850513          	addi	a0,a0,-1848 # 80010ab0 <wait_lock>
    800021f0:	a9bfe0ef          	jal	80000c8a <release>
}
    800021f4:	854e                	mv	a0,s3
    800021f6:	60a6                	ld	ra,72(sp)
    800021f8:	6406                	ld	s0,64(sp)
    800021fa:	74e2                	ld	s1,56(sp)
    800021fc:	7942                	ld	s2,48(sp)
    800021fe:	79a2                	ld	s3,40(sp)
    80002200:	7a02                	ld	s4,32(sp)
    80002202:	6ae2                	ld	s5,24(sp)
    80002204:	6b42                	ld	s6,16(sp)
    80002206:	6ba2                	ld	s7,8(sp)
    80002208:	6161                	addi	sp,sp,80
    8000220a:	8082                	ret
            release(&pp->lock);
    8000220c:	8526                	mv	a0,s1
    8000220e:	a7dfe0ef          	jal	80000c8a <release>
            release(&wait_lock);
    80002212:	0000f517          	auipc	a0,0xf
    80002216:	89e50513          	addi	a0,a0,-1890 # 80010ab0 <wait_lock>
    8000221a:	a71fe0ef          	jal	80000c8a <release>
            return -1;
    8000221e:	59fd                	li	s3,-1
    80002220:	bfd1                	j	800021f4 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002222:	16848493          	addi	s1,s1,360
    80002226:	03348063          	beq	s1,s3,80002246 <kwait+0xc6>
      if(pp->parent == p){
    8000222a:	7c9c                	ld	a5,56(s1)
    8000222c:	ff279be3          	bne	a5,s2,80002222 <kwait+0xa2>
        acquire(&pp->lock);
    80002230:	8526                	mv	a0,s1
    80002232:	9c5fe0ef          	jal	80000bf6 <acquire>
        if(pp->state == ZOMBIE){
    80002236:	4c9c                	lw	a5,24(s1)
    80002238:	f94784e3          	beq	a5,s4,800021c0 <kwait+0x40>
        release(&pp->lock);
    8000223c:	8526                	mv	a0,s1
    8000223e:	a4dfe0ef          	jal	80000c8a <release>
        havekids = 1;
    80002242:	8756                	mv	a4,s5
    80002244:	bff9                	j	80002222 <kwait+0xa2>
    if(!havekids || killed(p)){
    80002246:	cf19                	beqz	a4,80002264 <kwait+0xe4>
    80002248:	854a                	mv	a0,s2
    8000224a:	f0dff0ef          	jal	80002156 <killed>
    8000224e:	e919                	bnez	a0,80002264 <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002250:	85de                	mv	a1,s7
    80002252:	854a                	mv	a0,s2
    80002254:	ccbff0ef          	jal	80001f1e <sleep>
    havekids = 0;
    80002258:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000225a:	0000f497          	auipc	s1,0xf
    8000225e:	c6e48493          	addi	s1,s1,-914 # 80010ec8 <proc>
    80002262:	b7e1                	j	8000222a <kwait+0xaa>
      release(&wait_lock);
    80002264:	0000f517          	auipc	a0,0xf
    80002268:	84c50513          	addi	a0,a0,-1972 # 80010ab0 <wait_lock>
    8000226c:	a1ffe0ef          	jal	80000c8a <release>
      return -1;
    80002270:	59fd                	li	s3,-1
    80002272:	b749                	j	800021f4 <kwait+0x74>

0000000080002274 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002274:	7179                	addi	sp,sp,-48
    80002276:	f406                	sd	ra,40(sp)
    80002278:	f022                	sd	s0,32(sp)
    8000227a:	ec26                	sd	s1,24(sp)
    8000227c:	e84a                	sd	s2,16(sp)
    8000227e:	e44e                	sd	s3,8(sp)
    80002280:	e052                	sd	s4,0(sp)
    80002282:	1800                	addi	s0,sp,48
    80002284:	84aa                	mv	s1,a0
    80002286:	892e                	mv	s2,a1
    80002288:	89b2                	mv	s3,a2
    8000228a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000228c:	e88ff0ef          	jal	80001914 <myproc>
  if(user_dst){
    80002290:	cc99                	beqz	s1,800022ae <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002292:	86d2                	mv	a3,s4
    80002294:	864e                	mv	a2,s3
    80002296:	85ca                	mv	a1,s2
    80002298:	6928                	ld	a0,80(a0)
    8000229a:	bacff0ef          	jal	80001646 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000229e:	70a2                	ld	ra,40(sp)
    800022a0:	7402                	ld	s0,32(sp)
    800022a2:	64e2                	ld	s1,24(sp)
    800022a4:	6942                	ld	s2,16(sp)
    800022a6:	69a2                	ld	s3,8(sp)
    800022a8:	6a02                	ld	s4,0(sp)
    800022aa:	6145                	addi	sp,sp,48
    800022ac:	8082                	ret
    memmove((char *)dst, src, len);
    800022ae:	000a061b          	sext.w	a2,s4
    800022b2:	85ce                	mv	a1,s3
    800022b4:	854a                	mv	a0,s2
    800022b6:	a75fe0ef          	jal	80000d2a <memmove>
    return 0;
    800022ba:	8526                	mv	a0,s1
    800022bc:	b7cd                	j	8000229e <either_copyout+0x2a>

00000000800022be <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022be:	7179                	addi	sp,sp,-48
    800022c0:	f406                	sd	ra,40(sp)
    800022c2:	f022                	sd	s0,32(sp)
    800022c4:	ec26                	sd	s1,24(sp)
    800022c6:	e84a                	sd	s2,16(sp)
    800022c8:	e44e                	sd	s3,8(sp)
    800022ca:	e052                	sd	s4,0(sp)
    800022cc:	1800                	addi	s0,sp,48
    800022ce:	892a                	mv	s2,a0
    800022d0:	84ae                	mv	s1,a1
    800022d2:	89b2                	mv	s3,a2
    800022d4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022d6:	e3eff0ef          	jal	80001914 <myproc>
  if(user_src){
    800022da:	cc99                	beqz	s1,800022f8 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800022dc:	86d2                	mv	a3,s4
    800022de:	864e                	mv	a2,s3
    800022e0:	85ca                	mv	a1,s2
    800022e2:	6928                	ld	a0,80(a0)
    800022e4:	c20ff0ef          	jal	80001704 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800022e8:	70a2                	ld	ra,40(sp)
    800022ea:	7402                	ld	s0,32(sp)
    800022ec:	64e2                	ld	s1,24(sp)
    800022ee:	6942                	ld	s2,16(sp)
    800022f0:	69a2                	ld	s3,8(sp)
    800022f2:	6a02                	ld	s4,0(sp)
    800022f4:	6145                	addi	sp,sp,48
    800022f6:	8082                	ret
    memmove(dst, (char*)src, len);
    800022f8:	000a061b          	sext.w	a2,s4
    800022fc:	85ce                	mv	a1,s3
    800022fe:	854a                	mv	a0,s2
    80002300:	a2bfe0ef          	jal	80000d2a <memmove>
    return 0;
    80002304:	8526                	mv	a0,s1
    80002306:	b7cd                	j	800022e8 <either_copyin+0x2a>

0000000080002308 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002308:	715d                	addi	sp,sp,-80
    8000230a:	e486                	sd	ra,72(sp)
    8000230c:	e0a2                	sd	s0,64(sp)
    8000230e:	fc26                	sd	s1,56(sp)
    80002310:	f84a                	sd	s2,48(sp)
    80002312:	f44e                	sd	s3,40(sp)
    80002314:	f052                	sd	s4,32(sp)
    80002316:	ec56                	sd	s5,24(sp)
    80002318:	e85a                	sd	s6,16(sp)
    8000231a:	e45e                	sd	s7,8(sp)
    8000231c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000231e:	00006517          	auipc	a0,0x6
    80002322:	d5a50513          	addi	a0,a0,-678 # 80008078 <etext+0x78>
    80002326:	9d4fe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000232a:	0000f497          	auipc	s1,0xf
    8000232e:	cf648493          	addi	s1,s1,-778 # 80011020 <proc+0x158>
    80002332:	00014917          	auipc	s2,0x14
    80002336:	6ee90913          	addi	s2,s2,1774 # 80016a20 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000233a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000233c:	00006997          	auipc	s3,0x6
    80002340:	ec498993          	addi	s3,s3,-316 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80002344:	00006a97          	auipc	s5,0x6
    80002348:	ec4a8a93          	addi	s5,s5,-316 # 80008208 <etext+0x208>
    printf("\n");
    8000234c:	00006a17          	auipc	s4,0x6
    80002350:	d2ca0a13          	addi	s4,s4,-724 # 80008078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002354:	00006b97          	auipc	s7,0x6
    80002358:	49cb8b93          	addi	s7,s7,1180 # 800087f0 <states.0>
    8000235c:	a829                	j	80002376 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000235e:	ed86a583          	lw	a1,-296(a3)
    80002362:	8556                	mv	a0,s5
    80002364:	996fe0ef          	jal	800004fa <printf>
    printf("\n");
    80002368:	8552                	mv	a0,s4
    8000236a:	990fe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000236e:	16848493          	addi	s1,s1,360
    80002372:	03248263          	beq	s1,s2,80002396 <procdump+0x8e>
    if(p->state == UNUSED)
    80002376:	86a6                	mv	a3,s1
    80002378:	ec04a783          	lw	a5,-320(s1)
    8000237c:	dbed                	beqz	a5,8000236e <procdump+0x66>
      state = "???";
    8000237e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002380:	fcfb6fe3          	bltu	s6,a5,8000235e <procdump+0x56>
    80002384:	02079713          	slli	a4,a5,0x20
    80002388:	01d75793          	srli	a5,a4,0x1d
    8000238c:	97de                	add	a5,a5,s7
    8000238e:	6390                	ld	a2,0(a5)
    80002390:	f679                	bnez	a2,8000235e <procdump+0x56>
      state = "???";
    80002392:	864e                	mv	a2,s3
    80002394:	b7e9                	j	8000235e <procdump+0x56>
  }
}
    80002396:	60a6                	ld	ra,72(sp)
    80002398:	6406                	ld	s0,64(sp)
    8000239a:	74e2                	ld	s1,56(sp)
    8000239c:	7942                	ld	s2,48(sp)
    8000239e:	79a2                	ld	s3,40(sp)
    800023a0:	7a02                	ld	s4,32(sp)
    800023a2:	6ae2                	ld	s5,24(sp)
    800023a4:	6b42                	ld	s6,16(sp)
    800023a6:	6ba2                	ld	s7,8(sp)
    800023a8:	6161                	addi	sp,sp,80
    800023aa:	8082                	ret

00000000800023ac <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800023ac:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800023b0:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800023b4:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800023b6:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800023b8:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800023bc:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800023c0:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800023c4:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800023c8:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800023cc:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800023d0:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800023d4:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800023d8:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800023dc:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800023e0:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800023e4:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800023e8:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800023ea:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800023ec:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800023f0:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    800023f4:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    800023f8:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800023fc:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002400:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002404:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002408:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000240c:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002410:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002414:	8082                	ret

0000000080002416 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002416:	1141                	addi	sp,sp,-16
    80002418:	e406                	sd	ra,8(sp)
    8000241a:	e022                	sd	s0,0(sp)
    8000241c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000241e:	00006597          	auipc	a1,0x6
    80002422:	e2a58593          	addi	a1,a1,-470 # 80008248 <etext+0x248>
    80002426:	00014517          	auipc	a0,0x14
    8000242a:	4a250513          	addi	a0,a0,1186 # 800168c8 <tickslock>
    8000242e:	f44fe0ef          	jal	80000b72 <initlock>
}
    80002432:	60a2                	ld	ra,8(sp)
    80002434:	6402                	ld	s0,0(sp)
    80002436:	0141                	addi	sp,sp,16
    80002438:	8082                	ret

000000008000243a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000243a:	1141                	addi	sp,sp,-16
    8000243c:	e406                	sd	ra,8(sp)
    8000243e:	e022                	sd	s0,0(sp)
    80002440:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002442:	00003797          	auipc	a5,0x3
    80002446:	fde78793          	addi	a5,a5,-34 # 80005420 <kernelvec>
    8000244a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000244e:	60a2                	ld	ra,8(sp)
    80002450:	6402                	ld	s0,0(sp)
    80002452:	0141                	addi	sp,sp,16
    80002454:	8082                	ret

0000000080002456 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002456:	1141                	addi	sp,sp,-16
    80002458:	e406                	sd	ra,8(sp)
    8000245a:	e022                	sd	s0,0(sp)
    8000245c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000245e:	cb6ff0ef          	jal	80001914 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002462:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002466:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002468:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000246c:	04000737          	lui	a4,0x4000
    80002470:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002472:	0732                	slli	a4,a4,0xc
    80002474:	00005797          	auipc	a5,0x5
    80002478:	b8c78793          	addi	a5,a5,-1140 # 80007000 <_trampoline>
    8000247c:	00005697          	auipc	a3,0x5
    80002480:	b8468693          	addi	a3,a3,-1148 # 80007000 <_trampoline>
    80002484:	8f95                	sub	a5,a5,a3
    80002486:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002488:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000248c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000248e:	18002773          	csrr	a4,satp
    80002492:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002494:	6d38                	ld	a4,88(a0)
    80002496:	613c                	ld	a5,64(a0)
    80002498:	6685                	lui	a3,0x1
    8000249a:	97b6                	add	a5,a5,a3
    8000249c:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000249e:	6d3c                	ld	a5,88(a0)
    800024a0:	00000717          	auipc	a4,0x0
    800024a4:	10670713          	addi	a4,a4,262 # 800025a6 <usertrap>
    800024a8:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800024aa:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800024ac:	8712                	mv	a4,tp
    800024ae:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024b0:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024b4:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024b8:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024bc:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024c0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800024c2:	6f9c                	ld	a5,24(a5)
    800024c4:	14179073          	csrw	sepc,a5
}
    800024c8:	60a2                	ld	ra,8(sp)
    800024ca:	6402                	ld	s0,0(sp)
    800024cc:	0141                	addi	sp,sp,16
    800024ce:	8082                	ret

00000000800024d0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024d0:	1101                	addi	sp,sp,-32
    800024d2:	ec06                	sd	ra,24(sp)
    800024d4:	e822                	sd	s0,16(sp)
    800024d6:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800024d8:	c08ff0ef          	jal	800018e0 <cpuid>
    800024dc:	cd11                	beqz	a0,800024f8 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800024de:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800024e2:	000f4737          	lui	a4,0xf4
    800024e6:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024ea:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800024ec:	14d79073          	csrw	stimecmp,a5
}
    800024f0:	60e2                	ld	ra,24(sp)
    800024f2:	6442                	ld	s0,16(sp)
    800024f4:	6105                	addi	sp,sp,32
    800024f6:	8082                	ret
    800024f8:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800024fa:	00014497          	auipc	s1,0x14
    800024fe:	3ce48493          	addi	s1,s1,974 # 800168c8 <tickslock>
    80002502:	8526                	mv	a0,s1
    80002504:	ef2fe0ef          	jal	80000bf6 <acquire>
    ticks++;
    80002508:	00006517          	auipc	a0,0x6
    8000250c:	48050513          	addi	a0,a0,1152 # 80008988 <ticks>
    80002510:	411c                	lw	a5,0(a0)
    80002512:	2785                	addiw	a5,a5,1
    80002514:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002516:	a55ff0ef          	jal	80001f6a <wakeup>
    release(&tickslock);
    8000251a:	8526                	mv	a0,s1
    8000251c:	f6efe0ef          	jal	80000c8a <release>
    80002520:	64a2                	ld	s1,8(sp)
    80002522:	bf75                	j	800024de <clockintr+0xe>

0000000080002524 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002524:	1101                	addi	sp,sp,-32
    80002526:	ec06                	sd	ra,24(sp)
    80002528:	e822                	sd	s0,16(sp)
    8000252a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000252c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002530:	57fd                	li	a5,-1
    80002532:	17fe                	slli	a5,a5,0x3f
    80002534:	07a5                	addi	a5,a5,9
    80002536:	00f70c63          	beq	a4,a5,8000254e <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000253a:	57fd                	li	a5,-1
    8000253c:	17fe                	slli	a5,a5,0x3f
    8000253e:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002540:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002542:	04f70e63          	beq	a4,a5,8000259e <devintr+0x7a>
  }
}
    80002546:	60e2                	ld	ra,24(sp)
    80002548:	6442                	ld	s0,16(sp)
    8000254a:	6105                	addi	sp,sp,32
    8000254c:	8082                	ret
    8000254e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002550:	79f020ef          	jal	800054ee <plic_claim>
    80002554:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002556:	47a9                	li	a5,10
    80002558:	00f50d63          	beq	a0,a5,80002572 <devintr+0x4e>
    } else if(irq == VIRTIO0_IRQ){
    8000255c:	4785                	li	a5,1
    8000255e:	02f50263          	beq	a0,a5,80002582 <devintr+0x5e>
    } else if(irq == E1000_IRQ){
    80002562:	02100793          	li	a5,33
    80002566:	02f50163          	beq	a0,a5,80002588 <devintr+0x64>
    return 1;
    8000256a:	4505                	li	a0,1
    } else if(irq){
    8000256c:	e08d                	bnez	s1,8000258e <devintr+0x6a>
    8000256e:	64a2                	ld	s1,8(sp)
    80002570:	bfd9                	j	80002546 <devintr+0x22>
      uartintr();
    80002572:	c3cfe0ef          	jal	800009ae <uartintr>
      plic_complete(irq);
    80002576:	8526                	mv	a0,s1
    80002578:	797020ef          	jal	8000550e <plic_complete>
    return 1;
    8000257c:	4505                	li	a0,1
    8000257e:	64a2                	ld	s1,8(sp)
    80002580:	b7d9                	j	80002546 <devintr+0x22>
      virtio_disk_intr();
    80002582:	3fc030ef          	jal	8000597e <virtio_disk_intr>
    if(irq)
    80002586:	bfc5                	j	80002576 <devintr+0x52>
      e1000_intr();
    80002588:	618030ef          	jal	80005ba0 <e1000_intr>
    if(irq)
    8000258c:	b7ed                	j	80002576 <devintr+0x52>
      printf("unexpected interrupt irq=%d\n", irq);
    8000258e:	85a6                	mv	a1,s1
    80002590:	00006517          	auipc	a0,0x6
    80002594:	cc050513          	addi	a0,a0,-832 # 80008250 <etext+0x250>
    80002598:	f63fd0ef          	jal	800004fa <printf>
    if(irq)
    8000259c:	bfe9                	j	80002576 <devintr+0x52>
    clockintr();
    8000259e:	f33ff0ef          	jal	800024d0 <clockintr>
    return 2;
    800025a2:	4509                	li	a0,2
    800025a4:	b74d                	j	80002546 <devintr+0x22>

00000000800025a6 <usertrap>:
{
    800025a6:	1101                	addi	sp,sp,-32
    800025a8:	ec06                	sd	ra,24(sp)
    800025aa:	e822                	sd	s0,16(sp)
    800025ac:	e426                	sd	s1,8(sp)
    800025ae:	e04a                	sd	s2,0(sp)
    800025b0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025b2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800025b6:	1007f793          	andi	a5,a5,256
    800025ba:	eba5                	bnez	a5,8000262a <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025bc:	00003797          	auipc	a5,0x3
    800025c0:	e6478793          	addi	a5,a5,-412 # 80005420 <kernelvec>
    800025c4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025c8:	b4cff0ef          	jal	80001914 <myproc>
    800025cc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800025ce:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025d0:	14102773          	csrr	a4,sepc
    800025d4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025d6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800025da:	47a1                	li	a5,8
    800025dc:	04f70d63          	beq	a4,a5,80002636 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    800025e0:	f45ff0ef          	jal	80002524 <devintr>
    800025e4:	892a                	mv	s2,a0
    800025e6:	e945                	bnez	a0,80002696 <usertrap+0xf0>
    800025e8:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    800025ec:	47bd                	li	a5,15
    800025ee:	08f70863          	beq	a4,a5,8000267e <usertrap+0xd8>
    800025f2:	14202773          	csrr	a4,scause
    800025f6:	47b5                	li	a5,13
    800025f8:	08f70363          	beq	a4,a5,8000267e <usertrap+0xd8>
    800025fc:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002600:	5890                	lw	a2,48(s1)
    80002602:	00006517          	auipc	a0,0x6
    80002606:	c8e50513          	addi	a0,a0,-882 # 80008290 <etext+0x290>
    8000260a:	ef1fd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000260e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002612:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002616:	00006517          	auipc	a0,0x6
    8000261a:	caa50513          	addi	a0,a0,-854 # 800082c0 <etext+0x2c0>
    8000261e:	eddfd0ef          	jal	800004fa <printf>
    setkilled(p);
    80002622:	8526                	mv	a0,s1
    80002624:	b0fff0ef          	jal	80002132 <setkilled>
    80002628:	a035                	j	80002654 <usertrap+0xae>
    panic("usertrap: not from user mode");
    8000262a:	00006517          	auipc	a0,0x6
    8000262e:	c4650513          	addi	a0,a0,-954 # 80008270 <etext+0x270>
    80002632:	9acfe0ef          	jal	800007de <panic>
    if(killed(p))
    80002636:	b21ff0ef          	jal	80002156 <killed>
    8000263a:	ed15                	bnez	a0,80002676 <usertrap+0xd0>
    p->trapframe->epc += 4;
    8000263c:	6cb8                	ld	a4,88(s1)
    8000263e:	6f1c                	ld	a5,24(a4)
    80002640:	0791                	addi	a5,a5,4
    80002642:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002644:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002648:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000264c:	10079073          	csrw	sstatus,a5
    syscall();
    80002650:	286000ef          	jal	800028d6 <syscall>
  if(killed(p))
    80002654:	8526                	mv	a0,s1
    80002656:	b01ff0ef          	jal	80002156 <killed>
    8000265a:	e139                	bnez	a0,800026a0 <usertrap+0xfa>
  prepare_return();
    8000265c:	dfbff0ef          	jal	80002456 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002660:	68a8                	ld	a0,80(s1)
    80002662:	8131                	srli	a0,a0,0xc
    80002664:	57fd                	li	a5,-1
    80002666:	17fe                	slli	a5,a5,0x3f
    80002668:	8d5d                	or	a0,a0,a5
}
    8000266a:	60e2                	ld	ra,24(sp)
    8000266c:	6442                	ld	s0,16(sp)
    8000266e:	64a2                	ld	s1,8(sp)
    80002670:	6902                	ld	s2,0(sp)
    80002672:	6105                	addi	sp,sp,32
    80002674:	8082                	ret
      kexit(-1);
    80002676:	557d                	li	a0,-1
    80002678:	9b3ff0ef          	jal	8000202a <kexit>
    8000267c:	b7c1                	j	8000263c <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000267e:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002682:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80002686:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80002688:	00163613          	seqz	a2,a2
    8000268c:	68a8                	ld	a0,80(s1)
    8000268e:	f37fe0ef          	jal	800015c4 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002692:	f169                	bnez	a0,80002654 <usertrap+0xae>
    80002694:	b7a5                	j	800025fc <usertrap+0x56>
  if(killed(p))
    80002696:	8526                	mv	a0,s1
    80002698:	abfff0ef          	jal	80002156 <killed>
    8000269c:	c511                	beqz	a0,800026a8 <usertrap+0x102>
    8000269e:	a011                	j	800026a2 <usertrap+0xfc>
    800026a0:	4901                	li	s2,0
    kexit(-1);
    800026a2:	557d                	li	a0,-1
    800026a4:	987ff0ef          	jal	8000202a <kexit>
  if(which_dev == 2)
    800026a8:	4789                	li	a5,2
    800026aa:	faf919e3          	bne	s2,a5,8000265c <usertrap+0xb6>
    yield();
    800026ae:	845ff0ef          	jal	80001ef2 <yield>
    800026b2:	b76d                	j	8000265c <usertrap+0xb6>

00000000800026b4 <kerneltrap>:
{
    800026b4:	7179                	addi	sp,sp,-48
    800026b6:	f406                	sd	ra,40(sp)
    800026b8:	f022                	sd	s0,32(sp)
    800026ba:	ec26                	sd	s1,24(sp)
    800026bc:	e84a                	sd	s2,16(sp)
    800026be:	e44e                	sd	s3,8(sp)
    800026c0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026c2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026c6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026ca:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800026ce:	1004f793          	andi	a5,s1,256
    800026d2:	c795                	beqz	a5,800026fe <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026d4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026d8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800026da:	eb85                	bnez	a5,8000270a <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800026dc:	e49ff0ef          	jal	80002524 <devintr>
    800026e0:	c91d                	beqz	a0,80002716 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    800026e2:	4789                	li	a5,2
    800026e4:	04f50a63          	beq	a0,a5,80002738 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026e8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026ec:	10049073          	csrw	sstatus,s1
}
    800026f0:	70a2                	ld	ra,40(sp)
    800026f2:	7402                	ld	s0,32(sp)
    800026f4:	64e2                	ld	s1,24(sp)
    800026f6:	6942                	ld	s2,16(sp)
    800026f8:	69a2                	ld	s3,8(sp)
    800026fa:	6145                	addi	sp,sp,48
    800026fc:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800026fe:	00006517          	auipc	a0,0x6
    80002702:	bea50513          	addi	a0,a0,-1046 # 800082e8 <etext+0x2e8>
    80002706:	8d8fe0ef          	jal	800007de <panic>
    panic("kerneltrap: interrupts enabled");
    8000270a:	00006517          	auipc	a0,0x6
    8000270e:	c0650513          	addi	a0,a0,-1018 # 80008310 <etext+0x310>
    80002712:	8ccfe0ef          	jal	800007de <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002716:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000271a:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    8000271e:	85ce                	mv	a1,s3
    80002720:	00006517          	auipc	a0,0x6
    80002724:	c1050513          	addi	a0,a0,-1008 # 80008330 <etext+0x330>
    80002728:	dd3fd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    8000272c:	00006517          	auipc	a0,0x6
    80002730:	c2c50513          	addi	a0,a0,-980 # 80008358 <etext+0x358>
    80002734:	8aafe0ef          	jal	800007de <panic>
  if(which_dev == 2 && myproc() != 0)
    80002738:	9dcff0ef          	jal	80001914 <myproc>
    8000273c:	d555                	beqz	a0,800026e8 <kerneltrap+0x34>
    yield();
    8000273e:	fb4ff0ef          	jal	80001ef2 <yield>
    80002742:	b75d                	j	800026e8 <kerneltrap+0x34>

0000000080002744 <trapdump>:
//
// For TASK 2
//
void
trapdump(void)
{
    80002744:	1141                	addi	sp,sp,-16
    80002746:	e406                	sd	ra,8(sp)
    80002748:	e022                	sd	s0,0(sp)
    8000274a:	0800                	addi	s0,sp,16
  printf("\n");
    8000274c:	00006517          	auipc	a0,0x6
    80002750:	92c50513          	addi	a0,a0,-1748 # 80008078 <etext+0x78>
    80002754:	da7fd0ef          	jal	800004fa <printf>
  printf("c\tu\tv\tn\n");
    80002758:	00006517          	auipc	a0,0x6
    8000275c:	c1050513          	addi	a0,a0,-1008 # 80008368 <etext+0x368>
    80002760:	d9bfd0ef          	jal	800004fa <printf>
  printf("%ld\t%ld\t%ld\t%ld", trap_stat.clock_trap, trap_stat.uart_trap, trap_stat.virtio_disk_trap, trap_stat.e1000_trap);
    80002764:	4701                	li	a4,0
    80002766:	4681                	li	a3,0
    80002768:	4601                	li	a2,0
    8000276a:	4581                	li	a1,0
    8000276c:	00006517          	auipc	a0,0x6
    80002770:	c0c50513          	addi	a0,a0,-1012 # 80008378 <etext+0x378>
    80002774:	d87fd0ef          	jal	800004fa <printf>
  printf("\n");
    80002778:	00006517          	auipc	a0,0x6
    8000277c:	90050513          	addi	a0,a0,-1792 # 80008078 <etext+0x78>
    80002780:	d7bfd0ef          	jal	800004fa <printf>
}
    80002784:	60a2                	ld	ra,8(sp)
    80002786:	6402                	ld	s0,0(sp)
    80002788:	0141                	addi	sp,sp,16
    8000278a:	8082                	ret

000000008000278c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000278c:	1101                	addi	sp,sp,-32
    8000278e:	ec06                	sd	ra,24(sp)
    80002790:	e822                	sd	s0,16(sp)
    80002792:	e426                	sd	s1,8(sp)
    80002794:	1000                	addi	s0,sp,32
    80002796:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002798:	97cff0ef          	jal	80001914 <myproc>
  switch (n) {
    8000279c:	4795                	li	a5,5
    8000279e:	0497e163          	bltu	a5,s1,800027e0 <argraw+0x54>
    800027a2:	048a                	slli	s1,s1,0x2
    800027a4:	00006717          	auipc	a4,0x6
    800027a8:	07c70713          	addi	a4,a4,124 # 80008820 <states.0+0x30>
    800027ac:	94ba                	add	s1,s1,a4
    800027ae:	409c                	lw	a5,0(s1)
    800027b0:	97ba                	add	a5,a5,a4
    800027b2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800027b4:	6d3c                	ld	a5,88(a0)
    800027b6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800027b8:	60e2                	ld	ra,24(sp)
    800027ba:	6442                	ld	s0,16(sp)
    800027bc:	64a2                	ld	s1,8(sp)
    800027be:	6105                	addi	sp,sp,32
    800027c0:	8082                	ret
    return p->trapframe->a1;
    800027c2:	6d3c                	ld	a5,88(a0)
    800027c4:	7fa8                	ld	a0,120(a5)
    800027c6:	bfcd                	j	800027b8 <argraw+0x2c>
    return p->trapframe->a2;
    800027c8:	6d3c                	ld	a5,88(a0)
    800027ca:	63c8                	ld	a0,128(a5)
    800027cc:	b7f5                	j	800027b8 <argraw+0x2c>
    return p->trapframe->a3;
    800027ce:	6d3c                	ld	a5,88(a0)
    800027d0:	67c8                	ld	a0,136(a5)
    800027d2:	b7dd                	j	800027b8 <argraw+0x2c>
    return p->trapframe->a4;
    800027d4:	6d3c                	ld	a5,88(a0)
    800027d6:	6bc8                	ld	a0,144(a5)
    800027d8:	b7c5                	j	800027b8 <argraw+0x2c>
    return p->trapframe->a5;
    800027da:	6d3c                	ld	a5,88(a0)
    800027dc:	6fc8                	ld	a0,152(a5)
    800027de:	bfe9                	j	800027b8 <argraw+0x2c>
  panic("argraw");
    800027e0:	00006517          	auipc	a0,0x6
    800027e4:	ba850513          	addi	a0,a0,-1112 # 80008388 <etext+0x388>
    800027e8:	ff7fd0ef          	jal	800007de <panic>

00000000800027ec <fetchaddr>:
{
    800027ec:	1101                	addi	sp,sp,-32
    800027ee:	ec06                	sd	ra,24(sp)
    800027f0:	e822                	sd	s0,16(sp)
    800027f2:	e426                	sd	s1,8(sp)
    800027f4:	e04a                	sd	s2,0(sp)
    800027f6:	1000                	addi	s0,sp,32
    800027f8:	84aa                	mv	s1,a0
    800027fa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027fc:	918ff0ef          	jal	80001914 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002800:	653c                	ld	a5,72(a0)
    80002802:	02f4f663          	bgeu	s1,a5,8000282e <fetchaddr+0x42>
    80002806:	00848713          	addi	a4,s1,8
    8000280a:	02e7e463          	bltu	a5,a4,80002832 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000280e:	46a1                	li	a3,8
    80002810:	8626                	mv	a2,s1
    80002812:	85ca                	mv	a1,s2
    80002814:	6928                	ld	a0,80(a0)
    80002816:	eeffe0ef          	jal	80001704 <copyin>
    8000281a:	00a03533          	snez	a0,a0
    8000281e:	40a0053b          	negw	a0,a0
}
    80002822:	60e2                	ld	ra,24(sp)
    80002824:	6442                	ld	s0,16(sp)
    80002826:	64a2                	ld	s1,8(sp)
    80002828:	6902                	ld	s2,0(sp)
    8000282a:	6105                	addi	sp,sp,32
    8000282c:	8082                	ret
    return -1;
    8000282e:	557d                	li	a0,-1
    80002830:	bfcd                	j	80002822 <fetchaddr+0x36>
    80002832:	557d                	li	a0,-1
    80002834:	b7fd                	j	80002822 <fetchaddr+0x36>

0000000080002836 <fetchstr>:
{
    80002836:	7179                	addi	sp,sp,-48
    80002838:	f406                	sd	ra,40(sp)
    8000283a:	f022                	sd	s0,32(sp)
    8000283c:	ec26                	sd	s1,24(sp)
    8000283e:	e84a                	sd	s2,16(sp)
    80002840:	e44e                	sd	s3,8(sp)
    80002842:	1800                	addi	s0,sp,48
    80002844:	892a                	mv	s2,a0
    80002846:	84ae                	mv	s1,a1
    80002848:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000284a:	8caff0ef          	jal	80001914 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000284e:	86ce                	mv	a3,s3
    80002850:	864a                	mv	a2,s2
    80002852:	85a6                	mv	a1,s1
    80002854:	6928                	ld	a0,80(a0)
    80002856:	caffe0ef          	jal	80001504 <copyinstr>
    8000285a:	00054c63          	bltz	a0,80002872 <fetchstr+0x3c>
  return strlen(buf);
    8000285e:	8526                	mv	a0,s1
    80002860:	deefe0ef          	jal	80000e4e <strlen>
}
    80002864:	70a2                	ld	ra,40(sp)
    80002866:	7402                	ld	s0,32(sp)
    80002868:	64e2                	ld	s1,24(sp)
    8000286a:	6942                	ld	s2,16(sp)
    8000286c:	69a2                	ld	s3,8(sp)
    8000286e:	6145                	addi	sp,sp,48
    80002870:	8082                	ret
    return -1;
    80002872:	557d                	li	a0,-1
    80002874:	bfc5                	j	80002864 <fetchstr+0x2e>

0000000080002876 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002876:	1101                	addi	sp,sp,-32
    80002878:	ec06                	sd	ra,24(sp)
    8000287a:	e822                	sd	s0,16(sp)
    8000287c:	e426                	sd	s1,8(sp)
    8000287e:	1000                	addi	s0,sp,32
    80002880:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002882:	f0bff0ef          	jal	8000278c <argraw>
    80002886:	c088                	sw	a0,0(s1)
}
    80002888:	60e2                	ld	ra,24(sp)
    8000288a:	6442                	ld	s0,16(sp)
    8000288c:	64a2                	ld	s1,8(sp)
    8000288e:	6105                	addi	sp,sp,32
    80002890:	8082                	ret

0000000080002892 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002892:	1101                	addi	sp,sp,-32
    80002894:	ec06                	sd	ra,24(sp)
    80002896:	e822                	sd	s0,16(sp)
    80002898:	e426                	sd	s1,8(sp)
    8000289a:	1000                	addi	s0,sp,32
    8000289c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000289e:	eefff0ef          	jal	8000278c <argraw>
    800028a2:	e088                	sd	a0,0(s1)
}
    800028a4:	60e2                	ld	ra,24(sp)
    800028a6:	6442                	ld	s0,16(sp)
    800028a8:	64a2                	ld	s1,8(sp)
    800028aa:	6105                	addi	sp,sp,32
    800028ac:	8082                	ret

00000000800028ae <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800028ae:	1101                	addi	sp,sp,-32
    800028b0:	ec06                	sd	ra,24(sp)
    800028b2:	e822                	sd	s0,16(sp)
    800028b4:	e426                	sd	s1,8(sp)
    800028b6:	e04a                	sd	s2,0(sp)
    800028b8:	1000                	addi	s0,sp,32
    800028ba:	84ae                	mv	s1,a1
    800028bc:	8932                	mv	s2,a2
  *ip = argraw(n);
    800028be:	ecfff0ef          	jal	8000278c <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800028c2:	864a                	mv	a2,s2
    800028c4:	85a6                	mv	a1,s1
    800028c6:	f71ff0ef          	jal	80002836 <fetchstr>
}
    800028ca:	60e2                	ld	ra,24(sp)
    800028cc:	6442                	ld	s0,16(sp)
    800028ce:	64a2                	ld	s1,8(sp)
    800028d0:	6902                	ld	s2,0(sp)
    800028d2:	6105                	addi	sp,sp,32
    800028d4:	8082                	ret

00000000800028d6 <syscall>:
[SYS_recv] sys_recv,
};

void
syscall(void)
{
    800028d6:	1101                	addi	sp,sp,-32
    800028d8:	ec06                	sd	ra,24(sp)
    800028da:	e822                	sd	s0,16(sp)
    800028dc:	e426                	sd	s1,8(sp)
    800028de:	e04a                	sd	s2,0(sp)
    800028e0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800028e2:	832ff0ef          	jal	80001914 <myproc>
    800028e6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800028e8:	05853903          	ld	s2,88(a0)
    800028ec:	0a893783          	ld	a5,168(s2)
    800028f0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800028f4:	37fd                	addiw	a5,a5,-1
    800028f6:	477d                	li	a4,31
    800028f8:	00f76f63          	bltu	a4,a5,80002916 <syscall+0x40>
    800028fc:	00369713          	slli	a4,a3,0x3
    80002900:	00006797          	auipc	a5,0x6
    80002904:	f3878793          	addi	a5,a5,-200 # 80008838 <syscalls>
    80002908:	97ba                	add	a5,a5,a4
    8000290a:	639c                	ld	a5,0(a5)
    8000290c:	c789                	beqz	a5,80002916 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000290e:	9782                	jalr	a5
    80002910:	06a93823          	sd	a0,112(s2)
    80002914:	a829                	j	8000292e <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002916:	15848613          	addi	a2,s1,344
    8000291a:	588c                	lw	a1,48(s1)
    8000291c:	00006517          	auipc	a0,0x6
    80002920:	a7450513          	addi	a0,a0,-1420 # 80008390 <etext+0x390>
    80002924:	bd7fd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002928:	6cbc                	ld	a5,88(s1)
    8000292a:	577d                	li	a4,-1
    8000292c:	fbb8                	sd	a4,112(a5)
  }
}
    8000292e:	60e2                	ld	ra,24(sp)
    80002930:	6442                	ld	s0,16(sp)
    80002932:	64a2                	ld	s1,8(sp)
    80002934:	6902                	ld	s2,0(sp)
    80002936:	6105                	addi	sp,sp,32
    80002938:	8082                	ret

000000008000293a <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    8000293a:	1101                	addi	sp,sp,-32
    8000293c:	ec06                	sd	ra,24(sp)
    8000293e:	e822                	sd	s0,16(sp)
    80002940:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002942:	fec40593          	addi	a1,s0,-20
    80002946:	4501                	li	a0,0
    80002948:	f2fff0ef          	jal	80002876 <argint>
  kexit(n);
    8000294c:	fec42503          	lw	a0,-20(s0)
    80002950:	edaff0ef          	jal	8000202a <kexit>
  return 0;  // not reached
}
    80002954:	4501                	li	a0,0
    80002956:	60e2                	ld	ra,24(sp)
    80002958:	6442                	ld	s0,16(sp)
    8000295a:	6105                	addi	sp,sp,32
    8000295c:	8082                	ret

000000008000295e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000295e:	1141                	addi	sp,sp,-16
    80002960:	e406                	sd	ra,8(sp)
    80002962:	e022                	sd	s0,0(sp)
    80002964:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002966:	faffe0ef          	jal	80001914 <myproc>
}
    8000296a:	5908                	lw	a0,48(a0)
    8000296c:	60a2                	ld	ra,8(sp)
    8000296e:	6402                	ld	s0,0(sp)
    80002970:	0141                	addi	sp,sp,16
    80002972:	8082                	ret

0000000080002974 <sys_fork>:

uint64
sys_fork(void)
{
    80002974:	1141                	addi	sp,sp,-16
    80002976:	e406                	sd	ra,8(sp)
    80002978:	e022                	sd	s0,0(sp)
    8000297a:	0800                	addi	s0,sp,16
  return kfork();
    8000297c:	afcff0ef          	jal	80001c78 <kfork>
}
    80002980:	60a2                	ld	ra,8(sp)
    80002982:	6402                	ld	s0,0(sp)
    80002984:	0141                	addi	sp,sp,16
    80002986:	8082                	ret

0000000080002988 <sys_wait>:

uint64
sys_wait(void)
{
    80002988:	1101                	addi	sp,sp,-32
    8000298a:	ec06                	sd	ra,24(sp)
    8000298c:	e822                	sd	s0,16(sp)
    8000298e:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002990:	fe840593          	addi	a1,s0,-24
    80002994:	4501                	li	a0,0
    80002996:	efdff0ef          	jal	80002892 <argaddr>
  return kwait(p);
    8000299a:	fe843503          	ld	a0,-24(s0)
    8000299e:	fe2ff0ef          	jal	80002180 <kwait>
}
    800029a2:	60e2                	ld	ra,24(sp)
    800029a4:	6442                	ld	s0,16(sp)
    800029a6:	6105                	addi	sp,sp,32
    800029a8:	8082                	ret

00000000800029aa <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800029aa:	7179                	addi	sp,sp,-48
    800029ac:	f406                	sd	ra,40(sp)
    800029ae:	f022                	sd	s0,32(sp)
    800029b0:	ec26                	sd	s1,24(sp)
    800029b2:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    800029b4:	fd840593          	addi	a1,s0,-40
    800029b8:	4501                	li	a0,0
    800029ba:	ebdff0ef          	jal	80002876 <argint>
  argint(1, &t);
    800029be:	fdc40593          	addi	a1,s0,-36
    800029c2:	4505                	li	a0,1
    800029c4:	eb3ff0ef          	jal	80002876 <argint>
  addr = myproc()->sz;
    800029c8:	f4dfe0ef          	jal	80001914 <myproc>
    800029cc:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    800029ce:	fdc42703          	lw	a4,-36(s0)
    800029d2:	4785                	li	a5,1
    800029d4:	02f70763          	beq	a4,a5,80002a02 <sys_sbrk+0x58>
    800029d8:	fd842783          	lw	a5,-40(s0)
    800029dc:	0207c363          	bltz	a5,80002a02 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    800029e0:	97a6                	add	a5,a5,s1
    800029e2:	0297ee63          	bltu	a5,s1,80002a1e <sys_sbrk+0x74>
      return -1;
    if(addr + n > TRAPFRAME)
    800029e6:	02000737          	lui	a4,0x2000
    800029ea:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    800029ec:	0736                	slli	a4,a4,0xd
    800029ee:	02f76a63          	bltu	a4,a5,80002a22 <sys_sbrk+0x78>
      return -1;
    myproc()->sz += n;
    800029f2:	f23fe0ef          	jal	80001914 <myproc>
    800029f6:	fd842703          	lw	a4,-40(s0)
    800029fa:	653c                	ld	a5,72(a0)
    800029fc:	97ba                	add	a5,a5,a4
    800029fe:	e53c                	sd	a5,72(a0)
    80002a00:	a039                	j	80002a0e <sys_sbrk+0x64>
    if(growproc(n) < 0) {
    80002a02:	fd842503          	lw	a0,-40(s0)
    80002a06:	a10ff0ef          	jal	80001c16 <growproc>
    80002a0a:	00054863          	bltz	a0,80002a1a <sys_sbrk+0x70>
  }
  return addr;
}
    80002a0e:	8526                	mv	a0,s1
    80002a10:	70a2                	ld	ra,40(sp)
    80002a12:	7402                	ld	s0,32(sp)
    80002a14:	64e2                	ld	s1,24(sp)
    80002a16:	6145                	addi	sp,sp,48
    80002a18:	8082                	ret
      return -1;
    80002a1a:	54fd                	li	s1,-1
    80002a1c:	bfcd                	j	80002a0e <sys_sbrk+0x64>
      return -1;
    80002a1e:	54fd                	li	s1,-1
    80002a20:	b7fd                	j	80002a0e <sys_sbrk+0x64>
      return -1;
    80002a22:	54fd                	li	s1,-1
    80002a24:	b7ed                	j	80002a0e <sys_sbrk+0x64>

0000000080002a26 <sys_pause>:

uint64
sys_pause(void)
{
    80002a26:	7139                	addi	sp,sp,-64
    80002a28:	fc06                	sd	ra,56(sp)
    80002a2a:	f822                	sd	s0,48(sp)
    80002a2c:	f04a                	sd	s2,32(sp)
    80002a2e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002a30:	fcc40593          	addi	a1,s0,-52
    80002a34:	4501                	li	a0,0
    80002a36:	e41ff0ef          	jal	80002876 <argint>
  if(n < 0)
    80002a3a:	fcc42783          	lw	a5,-52(s0)
    80002a3e:	0607c763          	bltz	a5,80002aac <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80002a42:	00014517          	auipc	a0,0x14
    80002a46:	e8650513          	addi	a0,a0,-378 # 800168c8 <tickslock>
    80002a4a:	9acfe0ef          	jal	80000bf6 <acquire>
  ticks0 = ticks;
    80002a4e:	00006917          	auipc	s2,0x6
    80002a52:	f3a92903          	lw	s2,-198(s2) # 80008988 <ticks>
  while(ticks - ticks0 < n){
    80002a56:	fcc42783          	lw	a5,-52(s0)
    80002a5a:	cf8d                	beqz	a5,80002a94 <sys_pause+0x6e>
    80002a5c:	f426                	sd	s1,40(sp)
    80002a5e:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a60:	00014997          	auipc	s3,0x14
    80002a64:	e6898993          	addi	s3,s3,-408 # 800168c8 <tickslock>
    80002a68:	00006497          	auipc	s1,0x6
    80002a6c:	f2048493          	addi	s1,s1,-224 # 80008988 <ticks>
    if(killed(myproc())){
    80002a70:	ea5fe0ef          	jal	80001914 <myproc>
    80002a74:	ee2ff0ef          	jal	80002156 <killed>
    80002a78:	ed0d                	bnez	a0,80002ab2 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002a7a:	85ce                	mv	a1,s3
    80002a7c:	8526                	mv	a0,s1
    80002a7e:	ca0ff0ef          	jal	80001f1e <sleep>
  while(ticks - ticks0 < n){
    80002a82:	409c                	lw	a5,0(s1)
    80002a84:	412787bb          	subw	a5,a5,s2
    80002a88:	fcc42703          	lw	a4,-52(s0)
    80002a8c:	fee7e2e3          	bltu	a5,a4,80002a70 <sys_pause+0x4a>
    80002a90:	74a2                	ld	s1,40(sp)
    80002a92:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a94:	00014517          	auipc	a0,0x14
    80002a98:	e3450513          	addi	a0,a0,-460 # 800168c8 <tickslock>
    80002a9c:	9eefe0ef          	jal	80000c8a <release>
  return 0;
    80002aa0:	4501                	li	a0,0
}
    80002aa2:	70e2                	ld	ra,56(sp)
    80002aa4:	7442                	ld	s0,48(sp)
    80002aa6:	7902                	ld	s2,32(sp)
    80002aa8:	6121                	addi	sp,sp,64
    80002aaa:	8082                	ret
    n = 0;
    80002aac:	fc042623          	sw	zero,-52(s0)
    80002ab0:	bf49                	j	80002a42 <sys_pause+0x1c>
      release(&tickslock);
    80002ab2:	00014517          	auipc	a0,0x14
    80002ab6:	e1650513          	addi	a0,a0,-490 # 800168c8 <tickslock>
    80002aba:	9d0fe0ef          	jal	80000c8a <release>
      return -1;
    80002abe:	557d                	li	a0,-1
    80002ac0:	74a2                	ld	s1,40(sp)
    80002ac2:	69e2                	ld	s3,24(sp)
    80002ac4:	bff9                	j	80002aa2 <sys_pause+0x7c>

0000000080002ac6 <sys_kill>:

uint64
sys_kill(void)
{
    80002ac6:	1101                	addi	sp,sp,-32
    80002ac8:	ec06                	sd	ra,24(sp)
    80002aca:	e822                	sd	s0,16(sp)
    80002acc:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002ace:	fec40593          	addi	a1,s0,-20
    80002ad2:	4501                	li	a0,0
    80002ad4:	da3ff0ef          	jal	80002876 <argint>
  return kkill(pid);
    80002ad8:	fec42503          	lw	a0,-20(s0)
    80002adc:	df0ff0ef          	jal	800020cc <kkill>
}
    80002ae0:	60e2                	ld	ra,24(sp)
    80002ae2:	6442                	ld	s0,16(sp)
    80002ae4:	6105                	addi	sp,sp,32
    80002ae6:	8082                	ret

0000000080002ae8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ae8:	1101                	addi	sp,sp,-32
    80002aea:	ec06                	sd	ra,24(sp)
    80002aec:	e822                	sd	s0,16(sp)
    80002aee:	e426                	sd	s1,8(sp)
    80002af0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002af2:	00014517          	auipc	a0,0x14
    80002af6:	dd650513          	addi	a0,a0,-554 # 800168c8 <tickslock>
    80002afa:	8fcfe0ef          	jal	80000bf6 <acquire>
  xticks = ticks;
    80002afe:	00006497          	auipc	s1,0x6
    80002b02:	e8a4a483          	lw	s1,-374(s1) # 80008988 <ticks>
  release(&tickslock);
    80002b06:	00014517          	auipc	a0,0x14
    80002b0a:	dc250513          	addi	a0,a0,-574 # 800168c8 <tickslock>
    80002b0e:	97cfe0ef          	jal	80000c8a <release>
  return xticks;
}
    80002b12:	02049513          	slli	a0,s1,0x20
    80002b16:	9101                	srli	a0,a0,0x20
    80002b18:	60e2                	ld	ra,24(sp)
    80002b1a:	6442                	ld	s0,16(sp)
    80002b1c:	64a2                	ld	s1,8(sp)
    80002b1e:	6105                	addi	sp,sp,32
    80002b20:	8082                	ret

0000000080002b22 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b22:	7179                	addi	sp,sp,-48
    80002b24:	f406                	sd	ra,40(sp)
    80002b26:	f022                	sd	s0,32(sp)
    80002b28:	ec26                	sd	s1,24(sp)
    80002b2a:	e84a                	sd	s2,16(sp)
    80002b2c:	e44e                	sd	s3,8(sp)
    80002b2e:	e052                	sd	s4,0(sp)
    80002b30:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002b32:	00006597          	auipc	a1,0x6
    80002b36:	87e58593          	addi	a1,a1,-1922 # 800083b0 <etext+0x3b0>
    80002b3a:	00014517          	auipc	a0,0x14
    80002b3e:	da650513          	addi	a0,a0,-602 # 800168e0 <bcache>
    80002b42:	830fe0ef          	jal	80000b72 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002b46:	0001c797          	auipc	a5,0x1c
    80002b4a:	d9a78793          	addi	a5,a5,-614 # 8001e8e0 <bcache+0x8000>
    80002b4e:	0001c717          	auipc	a4,0x1c
    80002b52:	ffa70713          	addi	a4,a4,-6 # 8001eb48 <bcache+0x8268>
    80002b56:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002b5a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b5e:	00014497          	auipc	s1,0x14
    80002b62:	d9a48493          	addi	s1,s1,-614 # 800168f8 <bcache+0x18>
    b->next = bcache.head.next;
    80002b66:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b68:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002b6a:	00006a17          	auipc	s4,0x6
    80002b6e:	84ea0a13          	addi	s4,s4,-1970 # 800083b8 <etext+0x3b8>
    b->next = bcache.head.next;
    80002b72:	2b893783          	ld	a5,696(s2)
    80002b76:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002b78:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002b7c:	85d2                	mv	a1,s4
    80002b7e:	01048513          	addi	a0,s1,16
    80002b82:	31c010ef          	jal	80003e9e <initsleeplock>
    bcache.head.next->prev = b;
    80002b86:	2b893783          	ld	a5,696(s2)
    80002b8a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002b8c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b90:	45848493          	addi	s1,s1,1112
    80002b94:	fd349fe3          	bne	s1,s3,80002b72 <binit+0x50>
  }
}
    80002b98:	70a2                	ld	ra,40(sp)
    80002b9a:	7402                	ld	s0,32(sp)
    80002b9c:	64e2                	ld	s1,24(sp)
    80002b9e:	6942                	ld	s2,16(sp)
    80002ba0:	69a2                	ld	s3,8(sp)
    80002ba2:	6a02                	ld	s4,0(sp)
    80002ba4:	6145                	addi	sp,sp,48
    80002ba6:	8082                	ret

0000000080002ba8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002ba8:	7179                	addi	sp,sp,-48
    80002baa:	f406                	sd	ra,40(sp)
    80002bac:	f022                	sd	s0,32(sp)
    80002bae:	ec26                	sd	s1,24(sp)
    80002bb0:	e84a                	sd	s2,16(sp)
    80002bb2:	e44e                	sd	s3,8(sp)
    80002bb4:	1800                	addi	s0,sp,48
    80002bb6:	892a                	mv	s2,a0
    80002bb8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002bba:	00014517          	auipc	a0,0x14
    80002bbe:	d2650513          	addi	a0,a0,-730 # 800168e0 <bcache>
    80002bc2:	834fe0ef          	jal	80000bf6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002bc6:	0001c497          	auipc	s1,0x1c
    80002bca:	fd24b483          	ld	s1,-46(s1) # 8001eb98 <bcache+0x82b8>
    80002bce:	0001c797          	auipc	a5,0x1c
    80002bd2:	f7a78793          	addi	a5,a5,-134 # 8001eb48 <bcache+0x8268>
    80002bd6:	02f48b63          	beq	s1,a5,80002c0c <bread+0x64>
    80002bda:	873e                	mv	a4,a5
    80002bdc:	a021                	j	80002be4 <bread+0x3c>
    80002bde:	68a4                	ld	s1,80(s1)
    80002be0:	02e48663          	beq	s1,a4,80002c0c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002be4:	449c                	lw	a5,8(s1)
    80002be6:	ff279ce3          	bne	a5,s2,80002bde <bread+0x36>
    80002bea:	44dc                	lw	a5,12(s1)
    80002bec:	ff3799e3          	bne	a5,s3,80002bde <bread+0x36>
      b->refcnt++;
    80002bf0:	40bc                	lw	a5,64(s1)
    80002bf2:	2785                	addiw	a5,a5,1
    80002bf4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002bf6:	00014517          	auipc	a0,0x14
    80002bfa:	cea50513          	addi	a0,a0,-790 # 800168e0 <bcache>
    80002bfe:	88cfe0ef          	jal	80000c8a <release>
      acquiresleep(&b->lock);
    80002c02:	01048513          	addi	a0,s1,16
    80002c06:	2ce010ef          	jal	80003ed4 <acquiresleep>
      return b;
    80002c0a:	a889                	j	80002c5c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c0c:	0001c497          	auipc	s1,0x1c
    80002c10:	f844b483          	ld	s1,-124(s1) # 8001eb90 <bcache+0x82b0>
    80002c14:	0001c797          	auipc	a5,0x1c
    80002c18:	f3478793          	addi	a5,a5,-204 # 8001eb48 <bcache+0x8268>
    80002c1c:	00f48863          	beq	s1,a5,80002c2c <bread+0x84>
    80002c20:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002c22:	40bc                	lw	a5,64(s1)
    80002c24:	cb91                	beqz	a5,80002c38 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c26:	64a4                	ld	s1,72(s1)
    80002c28:	fee49de3          	bne	s1,a4,80002c22 <bread+0x7a>
  panic("bget: no buffers");
    80002c2c:	00005517          	auipc	a0,0x5
    80002c30:	79450513          	addi	a0,a0,1940 # 800083c0 <etext+0x3c0>
    80002c34:	babfd0ef          	jal	800007de <panic>
      b->dev = dev;
    80002c38:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002c3c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002c40:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002c44:	4785                	li	a5,1
    80002c46:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c48:	00014517          	auipc	a0,0x14
    80002c4c:	c9850513          	addi	a0,a0,-872 # 800168e0 <bcache>
    80002c50:	83afe0ef          	jal	80000c8a <release>
      acquiresleep(&b->lock);
    80002c54:	01048513          	addi	a0,s1,16
    80002c58:	27c010ef          	jal	80003ed4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002c5c:	409c                	lw	a5,0(s1)
    80002c5e:	cb89                	beqz	a5,80002c70 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002c60:	8526                	mv	a0,s1
    80002c62:	70a2                	ld	ra,40(sp)
    80002c64:	7402                	ld	s0,32(sp)
    80002c66:	64e2                	ld	s1,24(sp)
    80002c68:	6942                	ld	s2,16(sp)
    80002c6a:	69a2                	ld	s3,8(sp)
    80002c6c:	6145                	addi	sp,sp,48
    80002c6e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002c70:	4581                	li	a1,0
    80002c72:	8526                	mv	a0,s1
    80002c74:	2ff020ef          	jal	80005772 <virtio_disk_rw>
    b->valid = 1;
    80002c78:	4785                	li	a5,1
    80002c7a:	c09c                	sw	a5,0(s1)
  return b;
    80002c7c:	b7d5                	j	80002c60 <bread+0xb8>

0000000080002c7e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002c7e:	1101                	addi	sp,sp,-32
    80002c80:	ec06                	sd	ra,24(sp)
    80002c82:	e822                	sd	s0,16(sp)
    80002c84:	e426                	sd	s1,8(sp)
    80002c86:	1000                	addi	s0,sp,32
    80002c88:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c8a:	0541                	addi	a0,a0,16
    80002c8c:	2c6010ef          	jal	80003f52 <holdingsleep>
    80002c90:	c911                	beqz	a0,80002ca4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002c92:	4585                	li	a1,1
    80002c94:	8526                	mv	a0,s1
    80002c96:	2dd020ef          	jal	80005772 <virtio_disk_rw>
}
    80002c9a:	60e2                	ld	ra,24(sp)
    80002c9c:	6442                	ld	s0,16(sp)
    80002c9e:	64a2                	ld	s1,8(sp)
    80002ca0:	6105                	addi	sp,sp,32
    80002ca2:	8082                	ret
    panic("bwrite");
    80002ca4:	00005517          	auipc	a0,0x5
    80002ca8:	73450513          	addi	a0,a0,1844 # 800083d8 <etext+0x3d8>
    80002cac:	b33fd0ef          	jal	800007de <panic>

0000000080002cb0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002cb0:	1101                	addi	sp,sp,-32
    80002cb2:	ec06                	sd	ra,24(sp)
    80002cb4:	e822                	sd	s0,16(sp)
    80002cb6:	e426                	sd	s1,8(sp)
    80002cb8:	e04a                	sd	s2,0(sp)
    80002cba:	1000                	addi	s0,sp,32
    80002cbc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002cbe:	01050913          	addi	s2,a0,16
    80002cc2:	854a                	mv	a0,s2
    80002cc4:	28e010ef          	jal	80003f52 <holdingsleep>
    80002cc8:	c125                	beqz	a0,80002d28 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002cca:	854a                	mv	a0,s2
    80002ccc:	24e010ef          	jal	80003f1a <releasesleep>

  acquire(&bcache.lock);
    80002cd0:	00014517          	auipc	a0,0x14
    80002cd4:	c1050513          	addi	a0,a0,-1008 # 800168e0 <bcache>
    80002cd8:	f1ffd0ef          	jal	80000bf6 <acquire>
  b->refcnt--;
    80002cdc:	40bc                	lw	a5,64(s1)
    80002cde:	37fd                	addiw	a5,a5,-1
    80002ce0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002ce2:	e79d                	bnez	a5,80002d10 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002ce4:	68b8                	ld	a4,80(s1)
    80002ce6:	64bc                	ld	a5,72(s1)
    80002ce8:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002cea:	68b8                	ld	a4,80(s1)
    80002cec:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002cee:	0001c797          	auipc	a5,0x1c
    80002cf2:	bf278793          	addi	a5,a5,-1038 # 8001e8e0 <bcache+0x8000>
    80002cf6:	2b87b703          	ld	a4,696(a5)
    80002cfa:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002cfc:	0001c717          	auipc	a4,0x1c
    80002d00:	e4c70713          	addi	a4,a4,-436 # 8001eb48 <bcache+0x8268>
    80002d04:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002d06:	2b87b703          	ld	a4,696(a5)
    80002d0a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002d0c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002d10:	00014517          	auipc	a0,0x14
    80002d14:	bd050513          	addi	a0,a0,-1072 # 800168e0 <bcache>
    80002d18:	f73fd0ef          	jal	80000c8a <release>
}
    80002d1c:	60e2                	ld	ra,24(sp)
    80002d1e:	6442                	ld	s0,16(sp)
    80002d20:	64a2                	ld	s1,8(sp)
    80002d22:	6902                	ld	s2,0(sp)
    80002d24:	6105                	addi	sp,sp,32
    80002d26:	8082                	ret
    panic("brelse");
    80002d28:	00005517          	auipc	a0,0x5
    80002d2c:	6b850513          	addi	a0,a0,1720 # 800083e0 <etext+0x3e0>
    80002d30:	aaffd0ef          	jal	800007de <panic>

0000000080002d34 <bpin>:

void
bpin(struct buf *b) {
    80002d34:	1101                	addi	sp,sp,-32
    80002d36:	ec06                	sd	ra,24(sp)
    80002d38:	e822                	sd	s0,16(sp)
    80002d3a:	e426                	sd	s1,8(sp)
    80002d3c:	1000                	addi	s0,sp,32
    80002d3e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d40:	00014517          	auipc	a0,0x14
    80002d44:	ba050513          	addi	a0,a0,-1120 # 800168e0 <bcache>
    80002d48:	eaffd0ef          	jal	80000bf6 <acquire>
  b->refcnt++;
    80002d4c:	40bc                	lw	a5,64(s1)
    80002d4e:	2785                	addiw	a5,a5,1
    80002d50:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d52:	00014517          	auipc	a0,0x14
    80002d56:	b8e50513          	addi	a0,a0,-1138 # 800168e0 <bcache>
    80002d5a:	f31fd0ef          	jal	80000c8a <release>
}
    80002d5e:	60e2                	ld	ra,24(sp)
    80002d60:	6442                	ld	s0,16(sp)
    80002d62:	64a2                	ld	s1,8(sp)
    80002d64:	6105                	addi	sp,sp,32
    80002d66:	8082                	ret

0000000080002d68 <bunpin>:

void
bunpin(struct buf *b) {
    80002d68:	1101                	addi	sp,sp,-32
    80002d6a:	ec06                	sd	ra,24(sp)
    80002d6c:	e822                	sd	s0,16(sp)
    80002d6e:	e426                	sd	s1,8(sp)
    80002d70:	1000                	addi	s0,sp,32
    80002d72:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d74:	00014517          	auipc	a0,0x14
    80002d78:	b6c50513          	addi	a0,a0,-1172 # 800168e0 <bcache>
    80002d7c:	e7bfd0ef          	jal	80000bf6 <acquire>
  b->refcnt--;
    80002d80:	40bc                	lw	a5,64(s1)
    80002d82:	37fd                	addiw	a5,a5,-1
    80002d84:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d86:	00014517          	auipc	a0,0x14
    80002d8a:	b5a50513          	addi	a0,a0,-1190 # 800168e0 <bcache>
    80002d8e:	efdfd0ef          	jal	80000c8a <release>
}
    80002d92:	60e2                	ld	ra,24(sp)
    80002d94:	6442                	ld	s0,16(sp)
    80002d96:	64a2                	ld	s1,8(sp)
    80002d98:	6105                	addi	sp,sp,32
    80002d9a:	8082                	ret

0000000080002d9c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002d9c:	1101                	addi	sp,sp,-32
    80002d9e:	ec06                	sd	ra,24(sp)
    80002da0:	e822                	sd	s0,16(sp)
    80002da2:	e426                	sd	s1,8(sp)
    80002da4:	e04a                	sd	s2,0(sp)
    80002da6:	1000                	addi	s0,sp,32
    80002da8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002daa:	00d5d79b          	srliw	a5,a1,0xd
    80002dae:	0001c597          	auipc	a1,0x1c
    80002db2:	20e5a583          	lw	a1,526(a1) # 8001efbc <sb+0x1c>
    80002db6:	9dbd                	addw	a1,a1,a5
    80002db8:	df1ff0ef          	jal	80002ba8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002dbc:	0074f713          	andi	a4,s1,7
    80002dc0:	4785                	li	a5,1
    80002dc2:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002dc6:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002dc8:	90d9                	srli	s1,s1,0x36
    80002dca:	00950733          	add	a4,a0,s1
    80002dce:	05874703          	lbu	a4,88(a4)
    80002dd2:	00e7f6b3          	and	a3,a5,a4
    80002dd6:	c29d                	beqz	a3,80002dfc <bfree+0x60>
    80002dd8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002dda:	94aa                	add	s1,s1,a0
    80002ddc:	fff7c793          	not	a5,a5
    80002de0:	8f7d                	and	a4,a4,a5
    80002de2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002de6:	7f7000ef          	jal	80003ddc <log_write>
  brelse(bp);
    80002dea:	854a                	mv	a0,s2
    80002dec:	ec5ff0ef          	jal	80002cb0 <brelse>
}
    80002df0:	60e2                	ld	ra,24(sp)
    80002df2:	6442                	ld	s0,16(sp)
    80002df4:	64a2                	ld	s1,8(sp)
    80002df6:	6902                	ld	s2,0(sp)
    80002df8:	6105                	addi	sp,sp,32
    80002dfa:	8082                	ret
    panic("freeing free block");
    80002dfc:	00005517          	auipc	a0,0x5
    80002e00:	5ec50513          	addi	a0,a0,1516 # 800083e8 <etext+0x3e8>
    80002e04:	9dbfd0ef          	jal	800007de <panic>

0000000080002e08 <balloc>:
{
    80002e08:	715d                	addi	sp,sp,-80
    80002e0a:	e486                	sd	ra,72(sp)
    80002e0c:	e0a2                	sd	s0,64(sp)
    80002e0e:	fc26                	sd	s1,56(sp)
    80002e10:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002e12:	0001c797          	auipc	a5,0x1c
    80002e16:	1927a783          	lw	a5,402(a5) # 8001efa4 <sb+0x4>
    80002e1a:	0e078863          	beqz	a5,80002f0a <balloc+0x102>
    80002e1e:	f84a                	sd	s2,48(sp)
    80002e20:	f44e                	sd	s3,40(sp)
    80002e22:	f052                	sd	s4,32(sp)
    80002e24:	ec56                	sd	s5,24(sp)
    80002e26:	e85a                	sd	s6,16(sp)
    80002e28:	e45e                	sd	s7,8(sp)
    80002e2a:	e062                	sd	s8,0(sp)
    80002e2c:	8baa                	mv	s7,a0
    80002e2e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002e30:	0001cb17          	auipc	s6,0x1c
    80002e34:	170b0b13          	addi	s6,s6,368 # 8001efa0 <sb>
      m = 1 << (bi % 8);
    80002e38:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e3a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002e3c:	6c09                	lui	s8,0x2
    80002e3e:	a09d                	j	80002ea4 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002e40:	97ca                	add	a5,a5,s2
    80002e42:	8e55                	or	a2,a2,a3
    80002e44:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002e48:	854a                	mv	a0,s2
    80002e4a:	793000ef          	jal	80003ddc <log_write>
        brelse(bp);
    80002e4e:	854a                	mv	a0,s2
    80002e50:	e61ff0ef          	jal	80002cb0 <brelse>
  bp = bread(dev, bno);
    80002e54:	85a6                	mv	a1,s1
    80002e56:	855e                	mv	a0,s7
    80002e58:	d51ff0ef          	jal	80002ba8 <bread>
    80002e5c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002e5e:	40000613          	li	a2,1024
    80002e62:	4581                	li	a1,0
    80002e64:	05850513          	addi	a0,a0,88
    80002e68:	e5ffd0ef          	jal	80000cc6 <memset>
  log_write(bp);
    80002e6c:	854a                	mv	a0,s2
    80002e6e:	76f000ef          	jal	80003ddc <log_write>
  brelse(bp);
    80002e72:	854a                	mv	a0,s2
    80002e74:	e3dff0ef          	jal	80002cb0 <brelse>
}
    80002e78:	7942                	ld	s2,48(sp)
    80002e7a:	79a2                	ld	s3,40(sp)
    80002e7c:	7a02                	ld	s4,32(sp)
    80002e7e:	6ae2                	ld	s5,24(sp)
    80002e80:	6b42                	ld	s6,16(sp)
    80002e82:	6ba2                	ld	s7,8(sp)
    80002e84:	6c02                	ld	s8,0(sp)
}
    80002e86:	8526                	mv	a0,s1
    80002e88:	60a6                	ld	ra,72(sp)
    80002e8a:	6406                	ld	s0,64(sp)
    80002e8c:	74e2                	ld	s1,56(sp)
    80002e8e:	6161                	addi	sp,sp,80
    80002e90:	8082                	ret
    brelse(bp);
    80002e92:	854a                	mv	a0,s2
    80002e94:	e1dff0ef          	jal	80002cb0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002e98:	015c0abb          	addw	s5,s8,s5
    80002e9c:	004b2783          	lw	a5,4(s6)
    80002ea0:	04fafe63          	bgeu	s5,a5,80002efc <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    80002ea4:	41fad79b          	sraiw	a5,s5,0x1f
    80002ea8:	0137d79b          	srliw	a5,a5,0x13
    80002eac:	015787bb          	addw	a5,a5,s5
    80002eb0:	40d7d79b          	sraiw	a5,a5,0xd
    80002eb4:	01cb2583          	lw	a1,28(s6)
    80002eb8:	9dbd                	addw	a1,a1,a5
    80002eba:	855e                	mv	a0,s7
    80002ebc:	cedff0ef          	jal	80002ba8 <bread>
    80002ec0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002ec2:	004b2503          	lw	a0,4(s6)
    80002ec6:	84d6                	mv	s1,s5
    80002ec8:	4701                	li	a4,0
    80002eca:	fca4f4e3          	bgeu	s1,a0,80002e92 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002ece:	00777693          	andi	a3,a4,7
    80002ed2:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002ed6:	41f7579b          	sraiw	a5,a4,0x1f
    80002eda:	01d7d79b          	srliw	a5,a5,0x1d
    80002ede:	9fb9                	addw	a5,a5,a4
    80002ee0:	4037d79b          	sraiw	a5,a5,0x3
    80002ee4:	00f90633          	add	a2,s2,a5
    80002ee8:	05864603          	lbu	a2,88(a2)
    80002eec:	00c6f5b3          	and	a1,a3,a2
    80002ef0:	d9a1                	beqz	a1,80002e40 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002ef2:	2705                	addiw	a4,a4,1
    80002ef4:	2485                	addiw	s1,s1,1
    80002ef6:	fd471ae3          	bne	a4,s4,80002eca <balloc+0xc2>
    80002efa:	bf61                	j	80002e92 <balloc+0x8a>
    80002efc:	7942                	ld	s2,48(sp)
    80002efe:	79a2                	ld	s3,40(sp)
    80002f00:	7a02                	ld	s4,32(sp)
    80002f02:	6ae2                	ld	s5,24(sp)
    80002f04:	6b42                	ld	s6,16(sp)
    80002f06:	6ba2                	ld	s7,8(sp)
    80002f08:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002f0a:	00005517          	auipc	a0,0x5
    80002f0e:	4f650513          	addi	a0,a0,1270 # 80008400 <etext+0x400>
    80002f12:	de8fd0ef          	jal	800004fa <printf>
  return 0;
    80002f16:	4481                	li	s1,0
    80002f18:	b7bd                	j	80002e86 <balloc+0x7e>

0000000080002f1a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002f1a:	7179                	addi	sp,sp,-48
    80002f1c:	f406                	sd	ra,40(sp)
    80002f1e:	f022                	sd	s0,32(sp)
    80002f20:	ec26                	sd	s1,24(sp)
    80002f22:	e84a                	sd	s2,16(sp)
    80002f24:	e44e                	sd	s3,8(sp)
    80002f26:	1800                	addi	s0,sp,48
    80002f28:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002f2a:	47ad                	li	a5,11
    80002f2c:	02b7e363          	bltu	a5,a1,80002f52 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80002f30:	02059793          	slli	a5,a1,0x20
    80002f34:	01e7d593          	srli	a1,a5,0x1e
    80002f38:	00b504b3          	add	s1,a0,a1
    80002f3c:	0504a903          	lw	s2,80(s1)
    80002f40:	06091363          	bnez	s2,80002fa6 <bmap+0x8c>
      addr = balloc(ip->dev);
    80002f44:	4108                	lw	a0,0(a0)
    80002f46:	ec3ff0ef          	jal	80002e08 <balloc>
    80002f4a:	892a                	mv	s2,a0
      if(addr == 0)
    80002f4c:	cd29                	beqz	a0,80002fa6 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    80002f4e:	c8a8                	sw	a0,80(s1)
    80002f50:	a899                	j	80002fa6 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002f52:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80002f56:	0ff00793          	li	a5,255
    80002f5a:	0697e963          	bltu	a5,s1,80002fcc <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002f5e:	08052903          	lw	s2,128(a0)
    80002f62:	00091b63          	bnez	s2,80002f78 <bmap+0x5e>
      addr = balloc(ip->dev);
    80002f66:	4108                	lw	a0,0(a0)
    80002f68:	ea1ff0ef          	jal	80002e08 <balloc>
    80002f6c:	892a                	mv	s2,a0
      if(addr == 0)
    80002f6e:	cd05                	beqz	a0,80002fa6 <bmap+0x8c>
    80002f70:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002f72:	08a9a023          	sw	a0,128(s3)
    80002f76:	a011                	j	80002f7a <bmap+0x60>
    80002f78:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002f7a:	85ca                	mv	a1,s2
    80002f7c:	0009a503          	lw	a0,0(s3)
    80002f80:	c29ff0ef          	jal	80002ba8 <bread>
    80002f84:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002f86:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002f8a:	02049713          	slli	a4,s1,0x20
    80002f8e:	01e75593          	srli	a1,a4,0x1e
    80002f92:	00b784b3          	add	s1,a5,a1
    80002f96:	0004a903          	lw	s2,0(s1)
    80002f9a:	00090e63          	beqz	s2,80002fb6 <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002f9e:	8552                	mv	a0,s4
    80002fa0:	d11ff0ef          	jal	80002cb0 <brelse>
    return addr;
    80002fa4:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002fa6:	854a                	mv	a0,s2
    80002fa8:	70a2                	ld	ra,40(sp)
    80002faa:	7402                	ld	s0,32(sp)
    80002fac:	64e2                	ld	s1,24(sp)
    80002fae:	6942                	ld	s2,16(sp)
    80002fb0:	69a2                	ld	s3,8(sp)
    80002fb2:	6145                	addi	sp,sp,48
    80002fb4:	8082                	ret
      addr = balloc(ip->dev);
    80002fb6:	0009a503          	lw	a0,0(s3)
    80002fba:	e4fff0ef          	jal	80002e08 <balloc>
    80002fbe:	892a                	mv	s2,a0
      if(addr){
    80002fc0:	dd79                	beqz	a0,80002f9e <bmap+0x84>
        a[bn] = addr;
    80002fc2:	c088                	sw	a0,0(s1)
        log_write(bp);
    80002fc4:	8552                	mv	a0,s4
    80002fc6:	617000ef          	jal	80003ddc <log_write>
    80002fca:	bfd1                	j	80002f9e <bmap+0x84>
    80002fcc:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002fce:	00005517          	auipc	a0,0x5
    80002fd2:	44a50513          	addi	a0,a0,1098 # 80008418 <etext+0x418>
    80002fd6:	809fd0ef          	jal	800007de <panic>

0000000080002fda <iget>:
{
    80002fda:	7179                	addi	sp,sp,-48
    80002fdc:	f406                	sd	ra,40(sp)
    80002fde:	f022                	sd	s0,32(sp)
    80002fe0:	ec26                	sd	s1,24(sp)
    80002fe2:	e84a                	sd	s2,16(sp)
    80002fe4:	e44e                	sd	s3,8(sp)
    80002fe6:	e052                	sd	s4,0(sp)
    80002fe8:	1800                	addi	s0,sp,48
    80002fea:	89aa                	mv	s3,a0
    80002fec:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002fee:	0001c517          	auipc	a0,0x1c
    80002ff2:	fd250513          	addi	a0,a0,-46 # 8001efc0 <itable>
    80002ff6:	c01fd0ef          	jal	80000bf6 <acquire>
  empty = 0;
    80002ffa:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ffc:	0001c497          	auipc	s1,0x1c
    80003000:	fdc48493          	addi	s1,s1,-36 # 8001efd8 <itable+0x18>
    80003004:	0001e697          	auipc	a3,0x1e
    80003008:	a6468693          	addi	a3,a3,-1436 # 80020a68 <log>
    8000300c:	a039                	j	8000301a <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000300e:	02090963          	beqz	s2,80003040 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003012:	08848493          	addi	s1,s1,136
    80003016:	02d48863          	beq	s1,a3,80003046 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000301a:	449c                	lw	a5,8(s1)
    8000301c:	fef059e3          	blez	a5,8000300e <iget+0x34>
    80003020:	4098                	lw	a4,0(s1)
    80003022:	ff3716e3          	bne	a4,s3,8000300e <iget+0x34>
    80003026:	40d8                	lw	a4,4(s1)
    80003028:	ff4713e3          	bne	a4,s4,8000300e <iget+0x34>
      ip->ref++;
    8000302c:	2785                	addiw	a5,a5,1
    8000302e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003030:	0001c517          	auipc	a0,0x1c
    80003034:	f9050513          	addi	a0,a0,-112 # 8001efc0 <itable>
    80003038:	c53fd0ef          	jal	80000c8a <release>
      return ip;
    8000303c:	8926                	mv	s2,s1
    8000303e:	a02d                	j	80003068 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003040:	fbe9                	bnez	a5,80003012 <iget+0x38>
      empty = ip;
    80003042:	8926                	mv	s2,s1
    80003044:	b7f9                	j	80003012 <iget+0x38>
  if(empty == 0)
    80003046:	02090a63          	beqz	s2,8000307a <iget+0xa0>
  ip->dev = dev;
    8000304a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000304e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003052:	4785                	li	a5,1
    80003054:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003058:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000305c:	0001c517          	auipc	a0,0x1c
    80003060:	f6450513          	addi	a0,a0,-156 # 8001efc0 <itable>
    80003064:	c27fd0ef          	jal	80000c8a <release>
}
    80003068:	854a                	mv	a0,s2
    8000306a:	70a2                	ld	ra,40(sp)
    8000306c:	7402                	ld	s0,32(sp)
    8000306e:	64e2                	ld	s1,24(sp)
    80003070:	6942                	ld	s2,16(sp)
    80003072:	69a2                	ld	s3,8(sp)
    80003074:	6a02                	ld	s4,0(sp)
    80003076:	6145                	addi	sp,sp,48
    80003078:	8082                	ret
    panic("iget: no inodes");
    8000307a:	00005517          	auipc	a0,0x5
    8000307e:	3b650513          	addi	a0,a0,950 # 80008430 <etext+0x430>
    80003082:	f5cfd0ef          	jal	800007de <panic>

0000000080003086 <iinit>:
{
    80003086:	7179                	addi	sp,sp,-48
    80003088:	f406                	sd	ra,40(sp)
    8000308a:	f022                	sd	s0,32(sp)
    8000308c:	ec26                	sd	s1,24(sp)
    8000308e:	e84a                	sd	s2,16(sp)
    80003090:	e44e                	sd	s3,8(sp)
    80003092:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003094:	00005597          	auipc	a1,0x5
    80003098:	3ac58593          	addi	a1,a1,940 # 80008440 <etext+0x440>
    8000309c:	0001c517          	auipc	a0,0x1c
    800030a0:	f2450513          	addi	a0,a0,-220 # 8001efc0 <itable>
    800030a4:	acffd0ef          	jal	80000b72 <initlock>
  for(i = 0; i < NINODE; i++) {
    800030a8:	0001c497          	auipc	s1,0x1c
    800030ac:	f4048493          	addi	s1,s1,-192 # 8001efe8 <itable+0x28>
    800030b0:	0001e997          	auipc	s3,0x1e
    800030b4:	9c898993          	addi	s3,s3,-1592 # 80020a78 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800030b8:	00005917          	auipc	s2,0x5
    800030bc:	39090913          	addi	s2,s2,912 # 80008448 <etext+0x448>
    800030c0:	85ca                	mv	a1,s2
    800030c2:	8526                	mv	a0,s1
    800030c4:	5db000ef          	jal	80003e9e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800030c8:	08848493          	addi	s1,s1,136
    800030cc:	ff349ae3          	bne	s1,s3,800030c0 <iinit+0x3a>
}
    800030d0:	70a2                	ld	ra,40(sp)
    800030d2:	7402                	ld	s0,32(sp)
    800030d4:	64e2                	ld	s1,24(sp)
    800030d6:	6942                	ld	s2,16(sp)
    800030d8:	69a2                	ld	s3,8(sp)
    800030da:	6145                	addi	sp,sp,48
    800030dc:	8082                	ret

00000000800030de <ialloc>:
{
    800030de:	7139                	addi	sp,sp,-64
    800030e0:	fc06                	sd	ra,56(sp)
    800030e2:	f822                	sd	s0,48(sp)
    800030e4:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800030e6:	0001c717          	auipc	a4,0x1c
    800030ea:	ec672703          	lw	a4,-314(a4) # 8001efac <sb+0xc>
    800030ee:	4785                	li	a5,1
    800030f0:	06e7f063          	bgeu	a5,a4,80003150 <ialloc+0x72>
    800030f4:	f426                	sd	s1,40(sp)
    800030f6:	f04a                	sd	s2,32(sp)
    800030f8:	ec4e                	sd	s3,24(sp)
    800030fa:	e852                	sd	s4,16(sp)
    800030fc:	e456                	sd	s5,8(sp)
    800030fe:	e05a                	sd	s6,0(sp)
    80003100:	8aaa                	mv	s5,a0
    80003102:	8b2e                	mv	s6,a1
    80003104:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003106:	0001ca17          	auipc	s4,0x1c
    8000310a:	e9aa0a13          	addi	s4,s4,-358 # 8001efa0 <sb>
    8000310e:	00495593          	srli	a1,s2,0x4
    80003112:	018a2783          	lw	a5,24(s4)
    80003116:	9dbd                	addw	a1,a1,a5
    80003118:	8556                	mv	a0,s5
    8000311a:	a8fff0ef          	jal	80002ba8 <bread>
    8000311e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003120:	05850993          	addi	s3,a0,88
    80003124:	00f97793          	andi	a5,s2,15
    80003128:	079a                	slli	a5,a5,0x6
    8000312a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000312c:	00099783          	lh	a5,0(s3)
    80003130:	cb9d                	beqz	a5,80003166 <ialloc+0x88>
    brelse(bp);
    80003132:	b7fff0ef          	jal	80002cb0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003136:	0905                	addi	s2,s2,1
    80003138:	00ca2703          	lw	a4,12(s4)
    8000313c:	0009079b          	sext.w	a5,s2
    80003140:	fce7e7e3          	bltu	a5,a4,8000310e <ialloc+0x30>
    80003144:	74a2                	ld	s1,40(sp)
    80003146:	7902                	ld	s2,32(sp)
    80003148:	69e2                	ld	s3,24(sp)
    8000314a:	6a42                	ld	s4,16(sp)
    8000314c:	6aa2                	ld	s5,8(sp)
    8000314e:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003150:	00005517          	auipc	a0,0x5
    80003154:	30050513          	addi	a0,a0,768 # 80008450 <etext+0x450>
    80003158:	ba2fd0ef          	jal	800004fa <printf>
  return 0;
    8000315c:	4501                	li	a0,0
}
    8000315e:	70e2                	ld	ra,56(sp)
    80003160:	7442                	ld	s0,48(sp)
    80003162:	6121                	addi	sp,sp,64
    80003164:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003166:	04000613          	li	a2,64
    8000316a:	4581                	li	a1,0
    8000316c:	854e                	mv	a0,s3
    8000316e:	b59fd0ef          	jal	80000cc6 <memset>
      dip->type = type;
    80003172:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003176:	8526                	mv	a0,s1
    80003178:	465000ef          	jal	80003ddc <log_write>
      brelse(bp);
    8000317c:	8526                	mv	a0,s1
    8000317e:	b33ff0ef          	jal	80002cb0 <brelse>
      return iget(dev, inum);
    80003182:	0009059b          	sext.w	a1,s2
    80003186:	8556                	mv	a0,s5
    80003188:	e53ff0ef          	jal	80002fda <iget>
    8000318c:	74a2                	ld	s1,40(sp)
    8000318e:	7902                	ld	s2,32(sp)
    80003190:	69e2                	ld	s3,24(sp)
    80003192:	6a42                	ld	s4,16(sp)
    80003194:	6aa2                	ld	s5,8(sp)
    80003196:	6b02                	ld	s6,0(sp)
    80003198:	b7d9                	j	8000315e <ialloc+0x80>

000000008000319a <iupdate>:
{
    8000319a:	1101                	addi	sp,sp,-32
    8000319c:	ec06                	sd	ra,24(sp)
    8000319e:	e822                	sd	s0,16(sp)
    800031a0:	e426                	sd	s1,8(sp)
    800031a2:	e04a                	sd	s2,0(sp)
    800031a4:	1000                	addi	s0,sp,32
    800031a6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800031a8:	415c                	lw	a5,4(a0)
    800031aa:	0047d79b          	srliw	a5,a5,0x4
    800031ae:	0001c597          	auipc	a1,0x1c
    800031b2:	e0a5a583          	lw	a1,-502(a1) # 8001efb8 <sb+0x18>
    800031b6:	9dbd                	addw	a1,a1,a5
    800031b8:	4108                	lw	a0,0(a0)
    800031ba:	9efff0ef          	jal	80002ba8 <bread>
    800031be:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800031c0:	05850793          	addi	a5,a0,88
    800031c4:	40d8                	lw	a4,4(s1)
    800031c6:	8b3d                	andi	a4,a4,15
    800031c8:	071a                	slli	a4,a4,0x6
    800031ca:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800031cc:	04449703          	lh	a4,68(s1)
    800031d0:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800031d4:	04649703          	lh	a4,70(s1)
    800031d8:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800031dc:	04849703          	lh	a4,72(s1)
    800031e0:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800031e4:	04a49703          	lh	a4,74(s1)
    800031e8:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800031ec:	44f8                	lw	a4,76(s1)
    800031ee:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800031f0:	03400613          	li	a2,52
    800031f4:	05048593          	addi	a1,s1,80
    800031f8:	00c78513          	addi	a0,a5,12
    800031fc:	b2ffd0ef          	jal	80000d2a <memmove>
  log_write(bp);
    80003200:	854a                	mv	a0,s2
    80003202:	3db000ef          	jal	80003ddc <log_write>
  brelse(bp);
    80003206:	854a                	mv	a0,s2
    80003208:	aa9ff0ef          	jal	80002cb0 <brelse>
}
    8000320c:	60e2                	ld	ra,24(sp)
    8000320e:	6442                	ld	s0,16(sp)
    80003210:	64a2                	ld	s1,8(sp)
    80003212:	6902                	ld	s2,0(sp)
    80003214:	6105                	addi	sp,sp,32
    80003216:	8082                	ret

0000000080003218 <idup>:
{
    80003218:	1101                	addi	sp,sp,-32
    8000321a:	ec06                	sd	ra,24(sp)
    8000321c:	e822                	sd	s0,16(sp)
    8000321e:	e426                	sd	s1,8(sp)
    80003220:	1000                	addi	s0,sp,32
    80003222:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003224:	0001c517          	auipc	a0,0x1c
    80003228:	d9c50513          	addi	a0,a0,-612 # 8001efc0 <itable>
    8000322c:	9cbfd0ef          	jal	80000bf6 <acquire>
  ip->ref++;
    80003230:	449c                	lw	a5,8(s1)
    80003232:	2785                	addiw	a5,a5,1
    80003234:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003236:	0001c517          	auipc	a0,0x1c
    8000323a:	d8a50513          	addi	a0,a0,-630 # 8001efc0 <itable>
    8000323e:	a4dfd0ef          	jal	80000c8a <release>
}
    80003242:	8526                	mv	a0,s1
    80003244:	60e2                	ld	ra,24(sp)
    80003246:	6442                	ld	s0,16(sp)
    80003248:	64a2                	ld	s1,8(sp)
    8000324a:	6105                	addi	sp,sp,32
    8000324c:	8082                	ret

000000008000324e <ilock>:
{
    8000324e:	1101                	addi	sp,sp,-32
    80003250:	ec06                	sd	ra,24(sp)
    80003252:	e822                	sd	s0,16(sp)
    80003254:	e426                	sd	s1,8(sp)
    80003256:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003258:	cd19                	beqz	a0,80003276 <ilock+0x28>
    8000325a:	84aa                	mv	s1,a0
    8000325c:	451c                	lw	a5,8(a0)
    8000325e:	00f05c63          	blez	a5,80003276 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003262:	0541                	addi	a0,a0,16
    80003264:	471000ef          	jal	80003ed4 <acquiresleep>
  if(ip->valid == 0){
    80003268:	40bc                	lw	a5,64(s1)
    8000326a:	cf89                	beqz	a5,80003284 <ilock+0x36>
}
    8000326c:	60e2                	ld	ra,24(sp)
    8000326e:	6442                	ld	s0,16(sp)
    80003270:	64a2                	ld	s1,8(sp)
    80003272:	6105                	addi	sp,sp,32
    80003274:	8082                	ret
    80003276:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003278:	00005517          	auipc	a0,0x5
    8000327c:	1f050513          	addi	a0,a0,496 # 80008468 <etext+0x468>
    80003280:	d5efd0ef          	jal	800007de <panic>
    80003284:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003286:	40dc                	lw	a5,4(s1)
    80003288:	0047d79b          	srliw	a5,a5,0x4
    8000328c:	0001c597          	auipc	a1,0x1c
    80003290:	d2c5a583          	lw	a1,-724(a1) # 8001efb8 <sb+0x18>
    80003294:	9dbd                	addw	a1,a1,a5
    80003296:	4088                	lw	a0,0(s1)
    80003298:	911ff0ef          	jal	80002ba8 <bread>
    8000329c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000329e:	05850593          	addi	a1,a0,88
    800032a2:	40dc                	lw	a5,4(s1)
    800032a4:	8bbd                	andi	a5,a5,15
    800032a6:	079a                	slli	a5,a5,0x6
    800032a8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800032aa:	00059783          	lh	a5,0(a1)
    800032ae:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800032b2:	00259783          	lh	a5,2(a1)
    800032b6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800032ba:	00459783          	lh	a5,4(a1)
    800032be:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800032c2:	00659783          	lh	a5,6(a1)
    800032c6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800032ca:	459c                	lw	a5,8(a1)
    800032cc:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800032ce:	03400613          	li	a2,52
    800032d2:	05b1                	addi	a1,a1,12
    800032d4:	05048513          	addi	a0,s1,80
    800032d8:	a53fd0ef          	jal	80000d2a <memmove>
    brelse(bp);
    800032dc:	854a                	mv	a0,s2
    800032de:	9d3ff0ef          	jal	80002cb0 <brelse>
    ip->valid = 1;
    800032e2:	4785                	li	a5,1
    800032e4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800032e6:	04449783          	lh	a5,68(s1)
    800032ea:	c399                	beqz	a5,800032f0 <ilock+0xa2>
    800032ec:	6902                	ld	s2,0(sp)
    800032ee:	bfbd                	j	8000326c <ilock+0x1e>
      panic("ilock: no type");
    800032f0:	00005517          	auipc	a0,0x5
    800032f4:	18050513          	addi	a0,a0,384 # 80008470 <etext+0x470>
    800032f8:	ce6fd0ef          	jal	800007de <panic>

00000000800032fc <iunlock>:
{
    800032fc:	1101                	addi	sp,sp,-32
    800032fe:	ec06                	sd	ra,24(sp)
    80003300:	e822                	sd	s0,16(sp)
    80003302:	e426                	sd	s1,8(sp)
    80003304:	e04a                	sd	s2,0(sp)
    80003306:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003308:	c505                	beqz	a0,80003330 <iunlock+0x34>
    8000330a:	84aa                	mv	s1,a0
    8000330c:	01050913          	addi	s2,a0,16
    80003310:	854a                	mv	a0,s2
    80003312:	441000ef          	jal	80003f52 <holdingsleep>
    80003316:	cd09                	beqz	a0,80003330 <iunlock+0x34>
    80003318:	449c                	lw	a5,8(s1)
    8000331a:	00f05b63          	blez	a5,80003330 <iunlock+0x34>
  releasesleep(&ip->lock);
    8000331e:	854a                	mv	a0,s2
    80003320:	3fb000ef          	jal	80003f1a <releasesleep>
}
    80003324:	60e2                	ld	ra,24(sp)
    80003326:	6442                	ld	s0,16(sp)
    80003328:	64a2                	ld	s1,8(sp)
    8000332a:	6902                	ld	s2,0(sp)
    8000332c:	6105                	addi	sp,sp,32
    8000332e:	8082                	ret
    panic("iunlock");
    80003330:	00005517          	auipc	a0,0x5
    80003334:	15050513          	addi	a0,a0,336 # 80008480 <etext+0x480>
    80003338:	ca6fd0ef          	jal	800007de <panic>

000000008000333c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000333c:	7179                	addi	sp,sp,-48
    8000333e:	f406                	sd	ra,40(sp)
    80003340:	f022                	sd	s0,32(sp)
    80003342:	ec26                	sd	s1,24(sp)
    80003344:	e84a                	sd	s2,16(sp)
    80003346:	e44e                	sd	s3,8(sp)
    80003348:	1800                	addi	s0,sp,48
    8000334a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000334c:	05050493          	addi	s1,a0,80
    80003350:	08050913          	addi	s2,a0,128
    80003354:	a021                	j	8000335c <itrunc+0x20>
    80003356:	0491                	addi	s1,s1,4
    80003358:	01248b63          	beq	s1,s2,8000336e <itrunc+0x32>
    if(ip->addrs[i]){
    8000335c:	408c                	lw	a1,0(s1)
    8000335e:	dde5                	beqz	a1,80003356 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003360:	0009a503          	lw	a0,0(s3)
    80003364:	a39ff0ef          	jal	80002d9c <bfree>
      ip->addrs[i] = 0;
    80003368:	0004a023          	sw	zero,0(s1)
    8000336c:	b7ed                	j	80003356 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000336e:	0809a583          	lw	a1,128(s3)
    80003372:	ed89                	bnez	a1,8000338c <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003374:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003378:	854e                	mv	a0,s3
    8000337a:	e21ff0ef          	jal	8000319a <iupdate>
}
    8000337e:	70a2                	ld	ra,40(sp)
    80003380:	7402                	ld	s0,32(sp)
    80003382:	64e2                	ld	s1,24(sp)
    80003384:	6942                	ld	s2,16(sp)
    80003386:	69a2                	ld	s3,8(sp)
    80003388:	6145                	addi	sp,sp,48
    8000338a:	8082                	ret
    8000338c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000338e:	0009a503          	lw	a0,0(s3)
    80003392:	817ff0ef          	jal	80002ba8 <bread>
    80003396:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003398:	05850493          	addi	s1,a0,88
    8000339c:	45850913          	addi	s2,a0,1112
    800033a0:	a021                	j	800033a8 <itrunc+0x6c>
    800033a2:	0491                	addi	s1,s1,4
    800033a4:	01248963          	beq	s1,s2,800033b6 <itrunc+0x7a>
      if(a[j])
    800033a8:	408c                	lw	a1,0(s1)
    800033aa:	dde5                	beqz	a1,800033a2 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800033ac:	0009a503          	lw	a0,0(s3)
    800033b0:	9edff0ef          	jal	80002d9c <bfree>
    800033b4:	b7fd                	j	800033a2 <itrunc+0x66>
    brelse(bp);
    800033b6:	8552                	mv	a0,s4
    800033b8:	8f9ff0ef          	jal	80002cb0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800033bc:	0809a583          	lw	a1,128(s3)
    800033c0:	0009a503          	lw	a0,0(s3)
    800033c4:	9d9ff0ef          	jal	80002d9c <bfree>
    ip->addrs[NDIRECT] = 0;
    800033c8:	0809a023          	sw	zero,128(s3)
    800033cc:	6a02                	ld	s4,0(sp)
    800033ce:	b75d                	j	80003374 <itrunc+0x38>

00000000800033d0 <iput>:
{
    800033d0:	1101                	addi	sp,sp,-32
    800033d2:	ec06                	sd	ra,24(sp)
    800033d4:	e822                	sd	s0,16(sp)
    800033d6:	e426                	sd	s1,8(sp)
    800033d8:	1000                	addi	s0,sp,32
    800033da:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800033dc:	0001c517          	auipc	a0,0x1c
    800033e0:	be450513          	addi	a0,a0,-1052 # 8001efc0 <itable>
    800033e4:	813fd0ef          	jal	80000bf6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800033e8:	4498                	lw	a4,8(s1)
    800033ea:	4785                	li	a5,1
    800033ec:	02f70063          	beq	a4,a5,8000340c <iput+0x3c>
  ip->ref--;
    800033f0:	449c                	lw	a5,8(s1)
    800033f2:	37fd                	addiw	a5,a5,-1
    800033f4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800033f6:	0001c517          	auipc	a0,0x1c
    800033fa:	bca50513          	addi	a0,a0,-1078 # 8001efc0 <itable>
    800033fe:	88dfd0ef          	jal	80000c8a <release>
}
    80003402:	60e2                	ld	ra,24(sp)
    80003404:	6442                	ld	s0,16(sp)
    80003406:	64a2                	ld	s1,8(sp)
    80003408:	6105                	addi	sp,sp,32
    8000340a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000340c:	40bc                	lw	a5,64(s1)
    8000340e:	d3ed                	beqz	a5,800033f0 <iput+0x20>
    80003410:	04a49783          	lh	a5,74(s1)
    80003414:	fff1                	bnez	a5,800033f0 <iput+0x20>
    80003416:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003418:	01048913          	addi	s2,s1,16
    8000341c:	854a                	mv	a0,s2
    8000341e:	2b7000ef          	jal	80003ed4 <acquiresleep>
    release(&itable.lock);
    80003422:	0001c517          	auipc	a0,0x1c
    80003426:	b9e50513          	addi	a0,a0,-1122 # 8001efc0 <itable>
    8000342a:	861fd0ef          	jal	80000c8a <release>
    itrunc(ip);
    8000342e:	8526                	mv	a0,s1
    80003430:	f0dff0ef          	jal	8000333c <itrunc>
    ip->type = 0;
    80003434:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003438:	8526                	mv	a0,s1
    8000343a:	d61ff0ef          	jal	8000319a <iupdate>
    ip->valid = 0;
    8000343e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003442:	854a                	mv	a0,s2
    80003444:	2d7000ef          	jal	80003f1a <releasesleep>
    acquire(&itable.lock);
    80003448:	0001c517          	auipc	a0,0x1c
    8000344c:	b7850513          	addi	a0,a0,-1160 # 8001efc0 <itable>
    80003450:	fa6fd0ef          	jal	80000bf6 <acquire>
    80003454:	6902                	ld	s2,0(sp)
    80003456:	bf69                	j	800033f0 <iput+0x20>

0000000080003458 <iunlockput>:
{
    80003458:	1101                	addi	sp,sp,-32
    8000345a:	ec06                	sd	ra,24(sp)
    8000345c:	e822                	sd	s0,16(sp)
    8000345e:	e426                	sd	s1,8(sp)
    80003460:	1000                	addi	s0,sp,32
    80003462:	84aa                	mv	s1,a0
  iunlock(ip);
    80003464:	e99ff0ef          	jal	800032fc <iunlock>
  iput(ip);
    80003468:	8526                	mv	a0,s1
    8000346a:	f67ff0ef          	jal	800033d0 <iput>
}
    8000346e:	60e2                	ld	ra,24(sp)
    80003470:	6442                	ld	s0,16(sp)
    80003472:	64a2                	ld	s1,8(sp)
    80003474:	6105                	addi	sp,sp,32
    80003476:	8082                	ret

0000000080003478 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003478:	0001c717          	auipc	a4,0x1c
    8000347c:	b3472703          	lw	a4,-1228(a4) # 8001efac <sb+0xc>
    80003480:	4785                	li	a5,1
    80003482:	0ae7fe63          	bgeu	a5,a4,8000353e <ireclaim+0xc6>
{
    80003486:	7139                	addi	sp,sp,-64
    80003488:	fc06                	sd	ra,56(sp)
    8000348a:	f822                	sd	s0,48(sp)
    8000348c:	f426                	sd	s1,40(sp)
    8000348e:	f04a                	sd	s2,32(sp)
    80003490:	ec4e                	sd	s3,24(sp)
    80003492:	e852                	sd	s4,16(sp)
    80003494:	e456                	sd	s5,8(sp)
    80003496:	e05a                	sd	s6,0(sp)
    80003498:	0080                	addi	s0,sp,64
    8000349a:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000349c:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8000349e:	0001ca17          	auipc	s4,0x1c
    800034a2:	b02a0a13          	addi	s4,s4,-1278 # 8001efa0 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800034a6:	00005b17          	auipc	s6,0x5
    800034aa:	fe2b0b13          	addi	s6,s6,-30 # 80008488 <etext+0x488>
    800034ae:	a099                	j	800034f4 <ireclaim+0x7c>
    800034b0:	85ce                	mv	a1,s3
    800034b2:	855a                	mv	a0,s6
    800034b4:	846fd0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    800034b8:	85ce                	mv	a1,s3
    800034ba:	8556                	mv	a0,s5
    800034bc:	b1fff0ef          	jal	80002fda <iget>
    800034c0:	89aa                	mv	s3,a0
    brelse(bp);
    800034c2:	854a                	mv	a0,s2
    800034c4:	fecff0ef          	jal	80002cb0 <brelse>
    if (ip) {
    800034c8:	00098f63          	beqz	s3,800034e6 <ireclaim+0x6e>
      begin_op();
    800034cc:	786000ef          	jal	80003c52 <begin_op>
      ilock(ip);
    800034d0:	854e                	mv	a0,s3
    800034d2:	d7dff0ef          	jal	8000324e <ilock>
      iunlock(ip);
    800034d6:	854e                	mv	a0,s3
    800034d8:	e25ff0ef          	jal	800032fc <iunlock>
      iput(ip);
    800034dc:	854e                	mv	a0,s3
    800034de:	ef3ff0ef          	jal	800033d0 <iput>
      end_op();
    800034e2:	7da000ef          	jal	80003cbc <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800034e6:	0485                	addi	s1,s1,1
    800034e8:	00ca2703          	lw	a4,12(s4)
    800034ec:	0004879b          	sext.w	a5,s1
    800034f0:	02e7fd63          	bgeu	a5,a4,8000352a <ireclaim+0xb2>
    800034f4:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800034f8:	0044d593          	srli	a1,s1,0x4
    800034fc:	018a2783          	lw	a5,24(s4)
    80003500:	9dbd                	addw	a1,a1,a5
    80003502:	8556                	mv	a0,s5
    80003504:	ea4ff0ef          	jal	80002ba8 <bread>
    80003508:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    8000350a:	05850793          	addi	a5,a0,88
    8000350e:	00f9f713          	andi	a4,s3,15
    80003512:	071a                	slli	a4,a4,0x6
    80003514:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80003516:	00079703          	lh	a4,0(a5)
    8000351a:	c701                	beqz	a4,80003522 <ireclaim+0xaa>
    8000351c:	00679783          	lh	a5,6(a5)
    80003520:	dbc1                	beqz	a5,800034b0 <ireclaim+0x38>
    brelse(bp);
    80003522:	854a                	mv	a0,s2
    80003524:	f8cff0ef          	jal	80002cb0 <brelse>
    if (ip) {
    80003528:	bf7d                	j	800034e6 <ireclaim+0x6e>
}
    8000352a:	70e2                	ld	ra,56(sp)
    8000352c:	7442                	ld	s0,48(sp)
    8000352e:	74a2                	ld	s1,40(sp)
    80003530:	7902                	ld	s2,32(sp)
    80003532:	69e2                	ld	s3,24(sp)
    80003534:	6a42                	ld	s4,16(sp)
    80003536:	6aa2                	ld	s5,8(sp)
    80003538:	6b02                	ld	s6,0(sp)
    8000353a:	6121                	addi	sp,sp,64
    8000353c:	8082                	ret
    8000353e:	8082                	ret

0000000080003540 <fsinit>:
fsinit(int dev) {
    80003540:	7179                	addi	sp,sp,-48
    80003542:	f406                	sd	ra,40(sp)
    80003544:	f022                	sd	s0,32(sp)
    80003546:	ec26                	sd	s1,24(sp)
    80003548:	e84a                	sd	s2,16(sp)
    8000354a:	e44e                	sd	s3,8(sp)
    8000354c:	1800                	addi	s0,sp,48
    8000354e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003550:	4585                	li	a1,1
    80003552:	e56ff0ef          	jal	80002ba8 <bread>
    80003556:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003558:	0001c997          	auipc	s3,0x1c
    8000355c:	a4898993          	addi	s3,s3,-1464 # 8001efa0 <sb>
    80003560:	02000613          	li	a2,32
    80003564:	05850593          	addi	a1,a0,88
    80003568:	854e                	mv	a0,s3
    8000356a:	fc0fd0ef          	jal	80000d2a <memmove>
  brelse(bp);
    8000356e:	8526                	mv	a0,s1
    80003570:	f40ff0ef          	jal	80002cb0 <brelse>
  if(sb.magic != FSMAGIC)
    80003574:	0009a703          	lw	a4,0(s3)
    80003578:	102037b7          	lui	a5,0x10203
    8000357c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003580:	02f71363          	bne	a4,a5,800035a6 <fsinit+0x66>
  initlog(dev, &sb);
    80003584:	0001c597          	auipc	a1,0x1c
    80003588:	a1c58593          	addi	a1,a1,-1508 # 8001efa0 <sb>
    8000358c:	854a                	mv	a0,s2
    8000358e:	646000ef          	jal	80003bd4 <initlog>
  ireclaim(dev);
    80003592:	854a                	mv	a0,s2
    80003594:	ee5ff0ef          	jal	80003478 <ireclaim>
}
    80003598:	70a2                	ld	ra,40(sp)
    8000359a:	7402                	ld	s0,32(sp)
    8000359c:	64e2                	ld	s1,24(sp)
    8000359e:	6942                	ld	s2,16(sp)
    800035a0:	69a2                	ld	s3,8(sp)
    800035a2:	6145                	addi	sp,sp,48
    800035a4:	8082                	ret
    panic("invalid file system");
    800035a6:	00005517          	auipc	a0,0x5
    800035aa:	f0250513          	addi	a0,a0,-254 # 800084a8 <etext+0x4a8>
    800035ae:	a30fd0ef          	jal	800007de <panic>

00000000800035b2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800035b2:	1141                	addi	sp,sp,-16
    800035b4:	e406                	sd	ra,8(sp)
    800035b6:	e022                	sd	s0,0(sp)
    800035b8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800035ba:	411c                	lw	a5,0(a0)
    800035bc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800035be:	415c                	lw	a5,4(a0)
    800035c0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800035c2:	04451783          	lh	a5,68(a0)
    800035c6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800035ca:	04a51783          	lh	a5,74(a0)
    800035ce:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800035d2:	04c56783          	lwu	a5,76(a0)
    800035d6:	e99c                	sd	a5,16(a1)
}
    800035d8:	60a2                	ld	ra,8(sp)
    800035da:	6402                	ld	s0,0(sp)
    800035dc:	0141                	addi	sp,sp,16
    800035de:	8082                	ret

00000000800035e0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800035e0:	457c                	lw	a5,76(a0)
    800035e2:	0ed7e663          	bltu	a5,a3,800036ce <readi+0xee>
{
    800035e6:	7159                	addi	sp,sp,-112
    800035e8:	f486                	sd	ra,104(sp)
    800035ea:	f0a2                	sd	s0,96(sp)
    800035ec:	eca6                	sd	s1,88(sp)
    800035ee:	e0d2                	sd	s4,64(sp)
    800035f0:	fc56                	sd	s5,56(sp)
    800035f2:	f85a                	sd	s6,48(sp)
    800035f4:	f45e                	sd	s7,40(sp)
    800035f6:	1880                	addi	s0,sp,112
    800035f8:	8b2a                	mv	s6,a0
    800035fa:	8bae                	mv	s7,a1
    800035fc:	8a32                	mv	s4,a2
    800035fe:	84b6                	mv	s1,a3
    80003600:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003602:	9f35                	addw	a4,a4,a3
    return 0;
    80003604:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003606:	0ad76b63          	bltu	a4,a3,800036bc <readi+0xdc>
    8000360a:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000360c:	00e7f463          	bgeu	a5,a4,80003614 <readi+0x34>
    n = ip->size - off;
    80003610:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003614:	080a8b63          	beqz	s5,800036aa <readi+0xca>
    80003618:	e8ca                	sd	s2,80(sp)
    8000361a:	f062                	sd	s8,32(sp)
    8000361c:	ec66                	sd	s9,24(sp)
    8000361e:	e86a                	sd	s10,16(sp)
    80003620:	e46e                	sd	s11,8(sp)
    80003622:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003624:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003628:	5c7d                	li	s8,-1
    8000362a:	a80d                	j	8000365c <readi+0x7c>
    8000362c:	020d1d93          	slli	s11,s10,0x20
    80003630:	020ddd93          	srli	s11,s11,0x20
    80003634:	05890613          	addi	a2,s2,88
    80003638:	86ee                	mv	a3,s11
    8000363a:	963e                	add	a2,a2,a5
    8000363c:	85d2                	mv	a1,s4
    8000363e:	855e                	mv	a0,s7
    80003640:	c35fe0ef          	jal	80002274 <either_copyout>
    80003644:	05850363          	beq	a0,s8,8000368a <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003648:	854a                	mv	a0,s2
    8000364a:	e66ff0ef          	jal	80002cb0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000364e:	013d09bb          	addw	s3,s10,s3
    80003652:	009d04bb          	addw	s1,s10,s1
    80003656:	9a6e                	add	s4,s4,s11
    80003658:	0559f363          	bgeu	s3,s5,8000369e <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000365c:	00a4d59b          	srliw	a1,s1,0xa
    80003660:	855a                	mv	a0,s6
    80003662:	8b9ff0ef          	jal	80002f1a <bmap>
    80003666:	85aa                	mv	a1,a0
    if(addr == 0)
    80003668:	c139                	beqz	a0,800036ae <readi+0xce>
    bp = bread(ip->dev, addr);
    8000366a:	000b2503          	lw	a0,0(s6)
    8000366e:	d3aff0ef          	jal	80002ba8 <bread>
    80003672:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003674:	3ff4f793          	andi	a5,s1,1023
    80003678:	40fc873b          	subw	a4,s9,a5
    8000367c:	413a86bb          	subw	a3,s5,s3
    80003680:	8d3a                	mv	s10,a4
    80003682:	fae6f5e3          	bgeu	a3,a4,8000362c <readi+0x4c>
    80003686:	8d36                	mv	s10,a3
    80003688:	b755                	j	8000362c <readi+0x4c>
      brelse(bp);
    8000368a:	854a                	mv	a0,s2
    8000368c:	e24ff0ef          	jal	80002cb0 <brelse>
      tot = -1;
    80003690:	59fd                	li	s3,-1
      break;
    80003692:	6946                	ld	s2,80(sp)
    80003694:	7c02                	ld	s8,32(sp)
    80003696:	6ce2                	ld	s9,24(sp)
    80003698:	6d42                	ld	s10,16(sp)
    8000369a:	6da2                	ld	s11,8(sp)
    8000369c:	a831                	j	800036b8 <readi+0xd8>
    8000369e:	6946                	ld	s2,80(sp)
    800036a0:	7c02                	ld	s8,32(sp)
    800036a2:	6ce2                	ld	s9,24(sp)
    800036a4:	6d42                	ld	s10,16(sp)
    800036a6:	6da2                	ld	s11,8(sp)
    800036a8:	a801                	j	800036b8 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036aa:	89d6                	mv	s3,s5
    800036ac:	a031                	j	800036b8 <readi+0xd8>
    800036ae:	6946                	ld	s2,80(sp)
    800036b0:	7c02                	ld	s8,32(sp)
    800036b2:	6ce2                	ld	s9,24(sp)
    800036b4:	6d42                	ld	s10,16(sp)
    800036b6:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800036b8:	854e                	mv	a0,s3
    800036ba:	69a6                	ld	s3,72(sp)
}
    800036bc:	70a6                	ld	ra,104(sp)
    800036be:	7406                	ld	s0,96(sp)
    800036c0:	64e6                	ld	s1,88(sp)
    800036c2:	6a06                	ld	s4,64(sp)
    800036c4:	7ae2                	ld	s5,56(sp)
    800036c6:	7b42                	ld	s6,48(sp)
    800036c8:	7ba2                	ld	s7,40(sp)
    800036ca:	6165                	addi	sp,sp,112
    800036cc:	8082                	ret
    return 0;
    800036ce:	4501                	li	a0,0
}
    800036d0:	8082                	ret

00000000800036d2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800036d2:	457c                	lw	a5,76(a0)
    800036d4:	0ed7eb63          	bltu	a5,a3,800037ca <writei+0xf8>
{
    800036d8:	7159                	addi	sp,sp,-112
    800036da:	f486                	sd	ra,104(sp)
    800036dc:	f0a2                	sd	s0,96(sp)
    800036de:	e8ca                	sd	s2,80(sp)
    800036e0:	e0d2                	sd	s4,64(sp)
    800036e2:	fc56                	sd	s5,56(sp)
    800036e4:	f85a                	sd	s6,48(sp)
    800036e6:	f45e                	sd	s7,40(sp)
    800036e8:	1880                	addi	s0,sp,112
    800036ea:	8aaa                	mv	s5,a0
    800036ec:	8bae                	mv	s7,a1
    800036ee:	8a32                	mv	s4,a2
    800036f0:	8936                	mv	s2,a3
    800036f2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800036f4:	00e687bb          	addw	a5,a3,a4
    800036f8:	0cd7eb63          	bltu	a5,a3,800037ce <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800036fc:	00043737          	lui	a4,0x43
    80003700:	0cf76963          	bltu	a4,a5,800037d2 <writei+0x100>
    80003704:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003706:	0a0b0a63          	beqz	s6,800037ba <writei+0xe8>
    8000370a:	eca6                	sd	s1,88(sp)
    8000370c:	f062                	sd	s8,32(sp)
    8000370e:	ec66                	sd	s9,24(sp)
    80003710:	e86a                	sd	s10,16(sp)
    80003712:	e46e                	sd	s11,8(sp)
    80003714:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003716:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000371a:	5c7d                	li	s8,-1
    8000371c:	a825                	j	80003754 <writei+0x82>
    8000371e:	020d1d93          	slli	s11,s10,0x20
    80003722:	020ddd93          	srli	s11,s11,0x20
    80003726:	05848513          	addi	a0,s1,88
    8000372a:	86ee                	mv	a3,s11
    8000372c:	8652                	mv	a2,s4
    8000372e:	85de                	mv	a1,s7
    80003730:	953e                	add	a0,a0,a5
    80003732:	b8dfe0ef          	jal	800022be <either_copyin>
    80003736:	05850663          	beq	a0,s8,80003782 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000373a:	8526                	mv	a0,s1
    8000373c:	6a0000ef          	jal	80003ddc <log_write>
    brelse(bp);
    80003740:	8526                	mv	a0,s1
    80003742:	d6eff0ef          	jal	80002cb0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003746:	013d09bb          	addw	s3,s10,s3
    8000374a:	012d093b          	addw	s2,s10,s2
    8000374e:	9a6e                	add	s4,s4,s11
    80003750:	0369fc63          	bgeu	s3,s6,80003788 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80003754:	00a9559b          	srliw	a1,s2,0xa
    80003758:	8556                	mv	a0,s5
    8000375a:	fc0ff0ef          	jal	80002f1a <bmap>
    8000375e:	85aa                	mv	a1,a0
    if(addr == 0)
    80003760:	c505                	beqz	a0,80003788 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80003762:	000aa503          	lw	a0,0(s5)
    80003766:	c42ff0ef          	jal	80002ba8 <bread>
    8000376a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000376c:	3ff97793          	andi	a5,s2,1023
    80003770:	40fc873b          	subw	a4,s9,a5
    80003774:	413b06bb          	subw	a3,s6,s3
    80003778:	8d3a                	mv	s10,a4
    8000377a:	fae6f2e3          	bgeu	a3,a4,8000371e <writei+0x4c>
    8000377e:	8d36                	mv	s10,a3
    80003780:	bf79                	j	8000371e <writei+0x4c>
      brelse(bp);
    80003782:	8526                	mv	a0,s1
    80003784:	d2cff0ef          	jal	80002cb0 <brelse>
  }

  if(off > ip->size)
    80003788:	04caa783          	lw	a5,76(s5)
    8000378c:	0327f963          	bgeu	a5,s2,800037be <writei+0xec>
    ip->size = off;
    80003790:	052aa623          	sw	s2,76(s5)
    80003794:	64e6                	ld	s1,88(sp)
    80003796:	7c02                	ld	s8,32(sp)
    80003798:	6ce2                	ld	s9,24(sp)
    8000379a:	6d42                	ld	s10,16(sp)
    8000379c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000379e:	8556                	mv	a0,s5
    800037a0:	9fbff0ef          	jal	8000319a <iupdate>

  return tot;
    800037a4:	854e                	mv	a0,s3
    800037a6:	69a6                	ld	s3,72(sp)
}
    800037a8:	70a6                	ld	ra,104(sp)
    800037aa:	7406                	ld	s0,96(sp)
    800037ac:	6946                	ld	s2,80(sp)
    800037ae:	6a06                	ld	s4,64(sp)
    800037b0:	7ae2                	ld	s5,56(sp)
    800037b2:	7b42                	ld	s6,48(sp)
    800037b4:	7ba2                	ld	s7,40(sp)
    800037b6:	6165                	addi	sp,sp,112
    800037b8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037ba:	89da                	mv	s3,s6
    800037bc:	b7cd                	j	8000379e <writei+0xcc>
    800037be:	64e6                	ld	s1,88(sp)
    800037c0:	7c02                	ld	s8,32(sp)
    800037c2:	6ce2                	ld	s9,24(sp)
    800037c4:	6d42                	ld	s10,16(sp)
    800037c6:	6da2                	ld	s11,8(sp)
    800037c8:	bfd9                	j	8000379e <writei+0xcc>
    return -1;
    800037ca:	557d                	li	a0,-1
}
    800037cc:	8082                	ret
    return -1;
    800037ce:	557d                	li	a0,-1
    800037d0:	bfe1                	j	800037a8 <writei+0xd6>
    return -1;
    800037d2:	557d                	li	a0,-1
    800037d4:	bfd1                	j	800037a8 <writei+0xd6>

00000000800037d6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800037d6:	1141                	addi	sp,sp,-16
    800037d8:	e406                	sd	ra,8(sp)
    800037da:	e022                	sd	s0,0(sp)
    800037dc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800037de:	4639                	li	a2,14
    800037e0:	dbefd0ef          	jal	80000d9e <strncmp>
}
    800037e4:	60a2                	ld	ra,8(sp)
    800037e6:	6402                	ld	s0,0(sp)
    800037e8:	0141                	addi	sp,sp,16
    800037ea:	8082                	ret

00000000800037ec <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800037ec:	711d                	addi	sp,sp,-96
    800037ee:	ec86                	sd	ra,88(sp)
    800037f0:	e8a2                	sd	s0,80(sp)
    800037f2:	e4a6                	sd	s1,72(sp)
    800037f4:	e0ca                	sd	s2,64(sp)
    800037f6:	fc4e                	sd	s3,56(sp)
    800037f8:	f852                	sd	s4,48(sp)
    800037fa:	f456                	sd	s5,40(sp)
    800037fc:	f05a                	sd	s6,32(sp)
    800037fe:	ec5e                	sd	s7,24(sp)
    80003800:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003802:	04451703          	lh	a4,68(a0)
    80003806:	4785                	li	a5,1
    80003808:	00f71f63          	bne	a4,a5,80003826 <dirlookup+0x3a>
    8000380c:	892a                	mv	s2,a0
    8000380e:	8aae                	mv	s5,a1
    80003810:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003812:	457c                	lw	a5,76(a0)
    80003814:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003816:	fa040a13          	addi	s4,s0,-96
    8000381a:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8000381c:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003820:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003822:	e39d                	bnez	a5,80003848 <dirlookup+0x5c>
    80003824:	a8b9                	j	80003882 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003826:	00005517          	auipc	a0,0x5
    8000382a:	c9a50513          	addi	a0,a0,-870 # 800084c0 <etext+0x4c0>
    8000382e:	fb1fc0ef          	jal	800007de <panic>
      panic("dirlookup read");
    80003832:	00005517          	auipc	a0,0x5
    80003836:	ca650513          	addi	a0,a0,-858 # 800084d8 <etext+0x4d8>
    8000383a:	fa5fc0ef          	jal	800007de <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000383e:	24c1                	addiw	s1,s1,16
    80003840:	04c92783          	lw	a5,76(s2)
    80003844:	02f4fe63          	bgeu	s1,a5,80003880 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003848:	874e                	mv	a4,s3
    8000384a:	86a6                	mv	a3,s1
    8000384c:	8652                	mv	a2,s4
    8000384e:	4581                	li	a1,0
    80003850:	854a                	mv	a0,s2
    80003852:	d8fff0ef          	jal	800035e0 <readi>
    80003856:	fd351ee3          	bne	a0,s3,80003832 <dirlookup+0x46>
    if(de.inum == 0)
    8000385a:	fa045783          	lhu	a5,-96(s0)
    8000385e:	d3e5                	beqz	a5,8000383e <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80003860:	85da                	mv	a1,s6
    80003862:	8556                	mv	a0,s5
    80003864:	f73ff0ef          	jal	800037d6 <namecmp>
    80003868:	f979                	bnez	a0,8000383e <dirlookup+0x52>
      if(poff)
    8000386a:	000b8463          	beqz	s7,80003872 <dirlookup+0x86>
        *poff = off;
    8000386e:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003872:	fa045583          	lhu	a1,-96(s0)
    80003876:	00092503          	lw	a0,0(s2)
    8000387a:	f60ff0ef          	jal	80002fda <iget>
    8000387e:	a011                	j	80003882 <dirlookup+0x96>
  return 0;
    80003880:	4501                	li	a0,0
}
    80003882:	60e6                	ld	ra,88(sp)
    80003884:	6446                	ld	s0,80(sp)
    80003886:	64a6                	ld	s1,72(sp)
    80003888:	6906                	ld	s2,64(sp)
    8000388a:	79e2                	ld	s3,56(sp)
    8000388c:	7a42                	ld	s4,48(sp)
    8000388e:	7aa2                	ld	s5,40(sp)
    80003890:	7b02                	ld	s6,32(sp)
    80003892:	6be2                	ld	s7,24(sp)
    80003894:	6125                	addi	sp,sp,96
    80003896:	8082                	ret

0000000080003898 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003898:	711d                	addi	sp,sp,-96
    8000389a:	ec86                	sd	ra,88(sp)
    8000389c:	e8a2                	sd	s0,80(sp)
    8000389e:	e4a6                	sd	s1,72(sp)
    800038a0:	e0ca                	sd	s2,64(sp)
    800038a2:	fc4e                	sd	s3,56(sp)
    800038a4:	f852                	sd	s4,48(sp)
    800038a6:	f456                	sd	s5,40(sp)
    800038a8:	f05a                	sd	s6,32(sp)
    800038aa:	ec5e                	sd	s7,24(sp)
    800038ac:	e862                	sd	s8,16(sp)
    800038ae:	e466                	sd	s9,8(sp)
    800038b0:	e06a                	sd	s10,0(sp)
    800038b2:	1080                	addi	s0,sp,96
    800038b4:	84aa                	mv	s1,a0
    800038b6:	8b2e                	mv	s6,a1
    800038b8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800038ba:	00054703          	lbu	a4,0(a0)
    800038be:	02f00793          	li	a5,47
    800038c2:	00f70f63          	beq	a4,a5,800038e0 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800038c6:	84efe0ef          	jal	80001914 <myproc>
    800038ca:	15053503          	ld	a0,336(a0)
    800038ce:	94bff0ef          	jal	80003218 <idup>
    800038d2:	8a2a                	mv	s4,a0
  while(*path == '/')
    800038d4:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800038d8:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800038da:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800038dc:	4b85                	li	s7,1
    800038de:	a879                	j	8000397c <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    800038e0:	4585                	li	a1,1
    800038e2:	852e                	mv	a0,a1
    800038e4:	ef6ff0ef          	jal	80002fda <iget>
    800038e8:	8a2a                	mv	s4,a0
    800038ea:	b7ed                	j	800038d4 <namex+0x3c>
      iunlockput(ip);
    800038ec:	8552                	mv	a0,s4
    800038ee:	b6bff0ef          	jal	80003458 <iunlockput>
      return 0;
    800038f2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800038f4:	8552                	mv	a0,s4
    800038f6:	60e6                	ld	ra,88(sp)
    800038f8:	6446                	ld	s0,80(sp)
    800038fa:	64a6                	ld	s1,72(sp)
    800038fc:	6906                	ld	s2,64(sp)
    800038fe:	79e2                	ld	s3,56(sp)
    80003900:	7a42                	ld	s4,48(sp)
    80003902:	7aa2                	ld	s5,40(sp)
    80003904:	7b02                	ld	s6,32(sp)
    80003906:	6be2                	ld	s7,24(sp)
    80003908:	6c42                	ld	s8,16(sp)
    8000390a:	6ca2                	ld	s9,8(sp)
    8000390c:	6d02                	ld	s10,0(sp)
    8000390e:	6125                	addi	sp,sp,96
    80003910:	8082                	ret
      iunlock(ip);
    80003912:	8552                	mv	a0,s4
    80003914:	9e9ff0ef          	jal	800032fc <iunlock>
      return ip;
    80003918:	bff1                	j	800038f4 <namex+0x5c>
      iunlockput(ip);
    8000391a:	8552                	mv	a0,s4
    8000391c:	b3dff0ef          	jal	80003458 <iunlockput>
      return 0;
    80003920:	8a4e                	mv	s4,s3
    80003922:	bfc9                	j	800038f4 <namex+0x5c>
  len = path - s;
    80003924:	40998633          	sub	a2,s3,s1
    80003928:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000392c:	09ac5063          	bge	s8,s10,800039ac <namex+0x114>
    memmove(name, s, DIRSIZ);
    80003930:	8666                	mv	a2,s9
    80003932:	85a6                	mv	a1,s1
    80003934:	8556                	mv	a0,s5
    80003936:	bf4fd0ef          	jal	80000d2a <memmove>
    8000393a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000393c:	0004c783          	lbu	a5,0(s1)
    80003940:	01279763          	bne	a5,s2,8000394e <namex+0xb6>
    path++;
    80003944:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003946:	0004c783          	lbu	a5,0(s1)
    8000394a:	ff278de3          	beq	a5,s2,80003944 <namex+0xac>
    ilock(ip);
    8000394e:	8552                	mv	a0,s4
    80003950:	8ffff0ef          	jal	8000324e <ilock>
    if(ip->type != T_DIR){
    80003954:	044a1783          	lh	a5,68(s4)
    80003958:	f9779ae3          	bne	a5,s7,800038ec <namex+0x54>
    if(nameiparent && *path == '\0'){
    8000395c:	000b0563          	beqz	s6,80003966 <namex+0xce>
    80003960:	0004c783          	lbu	a5,0(s1)
    80003964:	d7dd                	beqz	a5,80003912 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003966:	4601                	li	a2,0
    80003968:	85d6                	mv	a1,s5
    8000396a:	8552                	mv	a0,s4
    8000396c:	e81ff0ef          	jal	800037ec <dirlookup>
    80003970:	89aa                	mv	s3,a0
    80003972:	d545                	beqz	a0,8000391a <namex+0x82>
    iunlockput(ip);
    80003974:	8552                	mv	a0,s4
    80003976:	ae3ff0ef          	jal	80003458 <iunlockput>
    ip = next;
    8000397a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000397c:	0004c783          	lbu	a5,0(s1)
    80003980:	01279763          	bne	a5,s2,8000398e <namex+0xf6>
    path++;
    80003984:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003986:	0004c783          	lbu	a5,0(s1)
    8000398a:	ff278de3          	beq	a5,s2,80003984 <namex+0xec>
  if(*path == 0)
    8000398e:	cb8d                	beqz	a5,800039c0 <namex+0x128>
  while(*path != '/' && *path != 0)
    80003990:	0004c783          	lbu	a5,0(s1)
    80003994:	89a6                	mv	s3,s1
  len = path - s;
    80003996:	4d01                	li	s10,0
    80003998:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000399a:	01278963          	beq	a5,s2,800039ac <namex+0x114>
    8000399e:	d3d9                	beqz	a5,80003924 <namex+0x8c>
    path++;
    800039a0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800039a2:	0009c783          	lbu	a5,0(s3)
    800039a6:	ff279ce3          	bne	a5,s2,8000399e <namex+0x106>
    800039aa:	bfad                	j	80003924 <namex+0x8c>
    memmove(name, s, len);
    800039ac:	2601                	sext.w	a2,a2
    800039ae:	85a6                	mv	a1,s1
    800039b0:	8556                	mv	a0,s5
    800039b2:	b78fd0ef          	jal	80000d2a <memmove>
    name[len] = 0;
    800039b6:	9d56                	add	s10,s10,s5
    800039b8:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffdc698>
    800039bc:	84ce                	mv	s1,s3
    800039be:	bfbd                	j	8000393c <namex+0xa4>
  if(nameiparent){
    800039c0:	f20b0ae3          	beqz	s6,800038f4 <namex+0x5c>
    iput(ip);
    800039c4:	8552                	mv	a0,s4
    800039c6:	a0bff0ef          	jal	800033d0 <iput>
    return 0;
    800039ca:	4a01                	li	s4,0
    800039cc:	b725                	j	800038f4 <namex+0x5c>

00000000800039ce <dirlink>:
{
    800039ce:	715d                	addi	sp,sp,-80
    800039d0:	e486                	sd	ra,72(sp)
    800039d2:	e0a2                	sd	s0,64(sp)
    800039d4:	f84a                	sd	s2,48(sp)
    800039d6:	ec56                	sd	s5,24(sp)
    800039d8:	e85a                	sd	s6,16(sp)
    800039da:	0880                	addi	s0,sp,80
    800039dc:	892a                	mv	s2,a0
    800039de:	8aae                	mv	s5,a1
    800039e0:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800039e2:	4601                	li	a2,0
    800039e4:	e09ff0ef          	jal	800037ec <dirlookup>
    800039e8:	ed1d                	bnez	a0,80003a26 <dirlink+0x58>
    800039ea:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039ec:	04c92483          	lw	s1,76(s2)
    800039f0:	c4b9                	beqz	s1,80003a3e <dirlink+0x70>
    800039f2:	f44e                	sd	s3,40(sp)
    800039f4:	f052                	sd	s4,32(sp)
    800039f6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039f8:	fb040a13          	addi	s4,s0,-80
    800039fc:	49c1                	li	s3,16
    800039fe:	874e                	mv	a4,s3
    80003a00:	86a6                	mv	a3,s1
    80003a02:	8652                	mv	a2,s4
    80003a04:	4581                	li	a1,0
    80003a06:	854a                	mv	a0,s2
    80003a08:	bd9ff0ef          	jal	800035e0 <readi>
    80003a0c:	03351163          	bne	a0,s3,80003a2e <dirlink+0x60>
    if(de.inum == 0)
    80003a10:	fb045783          	lhu	a5,-80(s0)
    80003a14:	c39d                	beqz	a5,80003a3a <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a16:	24c1                	addiw	s1,s1,16
    80003a18:	04c92783          	lw	a5,76(s2)
    80003a1c:	fef4e1e3          	bltu	s1,a5,800039fe <dirlink+0x30>
    80003a20:	79a2                	ld	s3,40(sp)
    80003a22:	7a02                	ld	s4,32(sp)
    80003a24:	a829                	j	80003a3e <dirlink+0x70>
    iput(ip);
    80003a26:	9abff0ef          	jal	800033d0 <iput>
    return -1;
    80003a2a:	557d                	li	a0,-1
    80003a2c:	a83d                	j	80003a6a <dirlink+0x9c>
      panic("dirlink read");
    80003a2e:	00005517          	auipc	a0,0x5
    80003a32:	aba50513          	addi	a0,a0,-1350 # 800084e8 <etext+0x4e8>
    80003a36:	da9fc0ef          	jal	800007de <panic>
    80003a3a:	79a2                	ld	s3,40(sp)
    80003a3c:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003a3e:	4639                	li	a2,14
    80003a40:	85d6                	mv	a1,s5
    80003a42:	fb240513          	addi	a0,s0,-78
    80003a46:	b92fd0ef          	jal	80000dd8 <strncpy>
  de.inum = inum;
    80003a4a:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a4e:	4741                	li	a4,16
    80003a50:	86a6                	mv	a3,s1
    80003a52:	fb040613          	addi	a2,s0,-80
    80003a56:	4581                	li	a1,0
    80003a58:	854a                	mv	a0,s2
    80003a5a:	c79ff0ef          	jal	800036d2 <writei>
    80003a5e:	1541                	addi	a0,a0,-16
    80003a60:	00a03533          	snez	a0,a0
    80003a64:	40a0053b          	negw	a0,a0
    80003a68:	74e2                	ld	s1,56(sp)
}
    80003a6a:	60a6                	ld	ra,72(sp)
    80003a6c:	6406                	ld	s0,64(sp)
    80003a6e:	7942                	ld	s2,48(sp)
    80003a70:	6ae2                	ld	s5,24(sp)
    80003a72:	6b42                	ld	s6,16(sp)
    80003a74:	6161                	addi	sp,sp,80
    80003a76:	8082                	ret

0000000080003a78 <namei>:

struct inode*
namei(char *path)
{
    80003a78:	1101                	addi	sp,sp,-32
    80003a7a:	ec06                	sd	ra,24(sp)
    80003a7c:	e822                	sd	s0,16(sp)
    80003a7e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003a80:	fe040613          	addi	a2,s0,-32
    80003a84:	4581                	li	a1,0
    80003a86:	e13ff0ef          	jal	80003898 <namex>
}
    80003a8a:	60e2                	ld	ra,24(sp)
    80003a8c:	6442                	ld	s0,16(sp)
    80003a8e:	6105                	addi	sp,sp,32
    80003a90:	8082                	ret

0000000080003a92 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003a92:	1141                	addi	sp,sp,-16
    80003a94:	e406                	sd	ra,8(sp)
    80003a96:	e022                	sd	s0,0(sp)
    80003a98:	0800                	addi	s0,sp,16
    80003a9a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003a9c:	4585                	li	a1,1
    80003a9e:	dfbff0ef          	jal	80003898 <namex>
}
    80003aa2:	60a2                	ld	ra,8(sp)
    80003aa4:	6402                	ld	s0,0(sp)
    80003aa6:	0141                	addi	sp,sp,16
    80003aa8:	8082                	ret

0000000080003aaa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003aaa:	1101                	addi	sp,sp,-32
    80003aac:	ec06                	sd	ra,24(sp)
    80003aae:	e822                	sd	s0,16(sp)
    80003ab0:	e426                	sd	s1,8(sp)
    80003ab2:	e04a                	sd	s2,0(sp)
    80003ab4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003ab6:	0001d917          	auipc	s2,0x1d
    80003aba:	fb290913          	addi	s2,s2,-78 # 80020a68 <log>
    80003abe:	01892583          	lw	a1,24(s2)
    80003ac2:	02492503          	lw	a0,36(s2)
    80003ac6:	8e2ff0ef          	jal	80002ba8 <bread>
    80003aca:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003acc:	02892603          	lw	a2,40(s2)
    80003ad0:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003ad2:	00c05f63          	blez	a2,80003af0 <write_head+0x46>
    80003ad6:	0001d717          	auipc	a4,0x1d
    80003ada:	fbe70713          	addi	a4,a4,-66 # 80020a94 <log+0x2c>
    80003ade:	87aa                	mv	a5,a0
    80003ae0:	060a                	slli	a2,a2,0x2
    80003ae2:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003ae4:	4314                	lw	a3,0(a4)
    80003ae6:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003ae8:	0711                	addi	a4,a4,4
    80003aea:	0791                	addi	a5,a5,4
    80003aec:	fec79ce3          	bne	a5,a2,80003ae4 <write_head+0x3a>
  }
  bwrite(buf);
    80003af0:	8526                	mv	a0,s1
    80003af2:	98cff0ef          	jal	80002c7e <bwrite>
  brelse(buf);
    80003af6:	8526                	mv	a0,s1
    80003af8:	9b8ff0ef          	jal	80002cb0 <brelse>
}
    80003afc:	60e2                	ld	ra,24(sp)
    80003afe:	6442                	ld	s0,16(sp)
    80003b00:	64a2                	ld	s1,8(sp)
    80003b02:	6902                	ld	s2,0(sp)
    80003b04:	6105                	addi	sp,sp,32
    80003b06:	8082                	ret

0000000080003b08 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b08:	0001d797          	auipc	a5,0x1d
    80003b0c:	f887a783          	lw	a5,-120(a5) # 80020a90 <log+0x28>
    80003b10:	0cf05163          	blez	a5,80003bd2 <install_trans+0xca>
{
    80003b14:	715d                	addi	sp,sp,-80
    80003b16:	e486                	sd	ra,72(sp)
    80003b18:	e0a2                	sd	s0,64(sp)
    80003b1a:	fc26                	sd	s1,56(sp)
    80003b1c:	f84a                	sd	s2,48(sp)
    80003b1e:	f44e                	sd	s3,40(sp)
    80003b20:	f052                	sd	s4,32(sp)
    80003b22:	ec56                	sd	s5,24(sp)
    80003b24:	e85a                	sd	s6,16(sp)
    80003b26:	e45e                	sd	s7,8(sp)
    80003b28:	e062                	sd	s8,0(sp)
    80003b2a:	0880                	addi	s0,sp,80
    80003b2c:	8b2a                	mv	s6,a0
    80003b2e:	0001da97          	auipc	s5,0x1d
    80003b32:	f66a8a93          	addi	s5,s5,-154 # 80020a94 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b36:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003b38:	00005c17          	auipc	s8,0x5
    80003b3c:	9c0c0c13          	addi	s8,s8,-1600 # 800084f8 <etext+0x4f8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b40:	0001da17          	auipc	s4,0x1d
    80003b44:	f28a0a13          	addi	s4,s4,-216 # 80020a68 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003b48:	40000b93          	li	s7,1024
    80003b4c:	a025                	j	80003b74 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003b4e:	000aa603          	lw	a2,0(s5)
    80003b52:	85ce                	mv	a1,s3
    80003b54:	8562                	mv	a0,s8
    80003b56:	9a5fc0ef          	jal	800004fa <printf>
    80003b5a:	a839                	j	80003b78 <install_trans+0x70>
    brelse(lbuf);
    80003b5c:	854a                	mv	a0,s2
    80003b5e:	952ff0ef          	jal	80002cb0 <brelse>
    brelse(dbuf);
    80003b62:	8526                	mv	a0,s1
    80003b64:	94cff0ef          	jal	80002cb0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b68:	2985                	addiw	s3,s3,1
    80003b6a:	0a91                	addi	s5,s5,4
    80003b6c:	028a2783          	lw	a5,40(s4)
    80003b70:	04f9d563          	bge	s3,a5,80003bba <install_trans+0xb2>
    if(recovering) {
    80003b74:	fc0b1de3          	bnez	s6,80003b4e <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b78:	018a2583          	lw	a1,24(s4)
    80003b7c:	013585bb          	addw	a1,a1,s3
    80003b80:	2585                	addiw	a1,a1,1
    80003b82:	024a2503          	lw	a0,36(s4)
    80003b86:	822ff0ef          	jal	80002ba8 <bread>
    80003b8a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003b8c:	000aa583          	lw	a1,0(s5)
    80003b90:	024a2503          	lw	a0,36(s4)
    80003b94:	814ff0ef          	jal	80002ba8 <bread>
    80003b98:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003b9a:	865e                	mv	a2,s7
    80003b9c:	05890593          	addi	a1,s2,88
    80003ba0:	05850513          	addi	a0,a0,88
    80003ba4:	986fd0ef          	jal	80000d2a <memmove>
    bwrite(dbuf);  // write dst to disk
    80003ba8:	8526                	mv	a0,s1
    80003baa:	8d4ff0ef          	jal	80002c7e <bwrite>
    if(recovering == 0)
    80003bae:	fa0b17e3          	bnez	s6,80003b5c <install_trans+0x54>
      bunpin(dbuf);
    80003bb2:	8526                	mv	a0,s1
    80003bb4:	9b4ff0ef          	jal	80002d68 <bunpin>
    80003bb8:	b755                	j	80003b5c <install_trans+0x54>
}
    80003bba:	60a6                	ld	ra,72(sp)
    80003bbc:	6406                	ld	s0,64(sp)
    80003bbe:	74e2                	ld	s1,56(sp)
    80003bc0:	7942                	ld	s2,48(sp)
    80003bc2:	79a2                	ld	s3,40(sp)
    80003bc4:	7a02                	ld	s4,32(sp)
    80003bc6:	6ae2                	ld	s5,24(sp)
    80003bc8:	6b42                	ld	s6,16(sp)
    80003bca:	6ba2                	ld	s7,8(sp)
    80003bcc:	6c02                	ld	s8,0(sp)
    80003bce:	6161                	addi	sp,sp,80
    80003bd0:	8082                	ret
    80003bd2:	8082                	ret

0000000080003bd4 <initlog>:
{
    80003bd4:	7179                	addi	sp,sp,-48
    80003bd6:	f406                	sd	ra,40(sp)
    80003bd8:	f022                	sd	s0,32(sp)
    80003bda:	ec26                	sd	s1,24(sp)
    80003bdc:	e84a                	sd	s2,16(sp)
    80003bde:	e44e                	sd	s3,8(sp)
    80003be0:	1800                	addi	s0,sp,48
    80003be2:	892a                	mv	s2,a0
    80003be4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003be6:	0001d497          	auipc	s1,0x1d
    80003bea:	e8248493          	addi	s1,s1,-382 # 80020a68 <log>
    80003bee:	00005597          	auipc	a1,0x5
    80003bf2:	92a58593          	addi	a1,a1,-1750 # 80008518 <etext+0x518>
    80003bf6:	8526                	mv	a0,s1
    80003bf8:	f7bfc0ef          	jal	80000b72 <initlock>
  log.start = sb->logstart;
    80003bfc:	0149a583          	lw	a1,20(s3)
    80003c00:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003c02:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003c06:	854a                	mv	a0,s2
    80003c08:	fa1fe0ef          	jal	80002ba8 <bread>
  log.lh.n = lh->n;
    80003c0c:	4d30                	lw	a2,88(a0)
    80003c0e:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003c10:	00c05f63          	blez	a2,80003c2e <initlog+0x5a>
    80003c14:	87aa                	mv	a5,a0
    80003c16:	0001d717          	auipc	a4,0x1d
    80003c1a:	e7e70713          	addi	a4,a4,-386 # 80020a94 <log+0x2c>
    80003c1e:	060a                	slli	a2,a2,0x2
    80003c20:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003c22:	4ff4                	lw	a3,92(a5)
    80003c24:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003c26:	0791                	addi	a5,a5,4
    80003c28:	0711                	addi	a4,a4,4
    80003c2a:	fec79ce3          	bne	a5,a2,80003c22 <initlog+0x4e>
  brelse(buf);
    80003c2e:	882ff0ef          	jal	80002cb0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003c32:	4505                	li	a0,1
    80003c34:	ed5ff0ef          	jal	80003b08 <install_trans>
  log.lh.n = 0;
    80003c38:	0001d797          	auipc	a5,0x1d
    80003c3c:	e407ac23          	sw	zero,-424(a5) # 80020a90 <log+0x28>
  write_head(); // clear the log
    80003c40:	e6bff0ef          	jal	80003aaa <write_head>
}
    80003c44:	70a2                	ld	ra,40(sp)
    80003c46:	7402                	ld	s0,32(sp)
    80003c48:	64e2                	ld	s1,24(sp)
    80003c4a:	6942                	ld	s2,16(sp)
    80003c4c:	69a2                	ld	s3,8(sp)
    80003c4e:	6145                	addi	sp,sp,48
    80003c50:	8082                	ret

0000000080003c52 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003c52:	1101                	addi	sp,sp,-32
    80003c54:	ec06                	sd	ra,24(sp)
    80003c56:	e822                	sd	s0,16(sp)
    80003c58:	e426                	sd	s1,8(sp)
    80003c5a:	e04a                	sd	s2,0(sp)
    80003c5c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003c5e:	0001d517          	auipc	a0,0x1d
    80003c62:	e0a50513          	addi	a0,a0,-502 # 80020a68 <log>
    80003c66:	f91fc0ef          	jal	80000bf6 <acquire>
  while(1){
    if(log.committing){
    80003c6a:	0001d497          	auipc	s1,0x1d
    80003c6e:	dfe48493          	addi	s1,s1,-514 # 80020a68 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003c72:	4979                	li	s2,30
    80003c74:	a029                	j	80003c7e <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003c76:	85a6                	mv	a1,s1
    80003c78:	8526                	mv	a0,s1
    80003c7a:	aa4fe0ef          	jal	80001f1e <sleep>
    if(log.committing){
    80003c7e:	509c                	lw	a5,32(s1)
    80003c80:	fbfd                	bnez	a5,80003c76 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003c82:	4cd8                	lw	a4,28(s1)
    80003c84:	2705                	addiw	a4,a4,1
    80003c86:	0027179b          	slliw	a5,a4,0x2
    80003c8a:	9fb9                	addw	a5,a5,a4
    80003c8c:	0017979b          	slliw	a5,a5,0x1
    80003c90:	5494                	lw	a3,40(s1)
    80003c92:	9fb5                	addw	a5,a5,a3
    80003c94:	00f95763          	bge	s2,a5,80003ca2 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003c98:	85a6                	mv	a1,s1
    80003c9a:	8526                	mv	a0,s1
    80003c9c:	a82fe0ef          	jal	80001f1e <sleep>
    80003ca0:	bff9                	j	80003c7e <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003ca2:	0001d517          	auipc	a0,0x1d
    80003ca6:	dc650513          	addi	a0,a0,-570 # 80020a68 <log>
    80003caa:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    80003cac:	fdffc0ef          	jal	80000c8a <release>
      break;
    }
  }
}
    80003cb0:	60e2                	ld	ra,24(sp)
    80003cb2:	6442                	ld	s0,16(sp)
    80003cb4:	64a2                	ld	s1,8(sp)
    80003cb6:	6902                	ld	s2,0(sp)
    80003cb8:	6105                	addi	sp,sp,32
    80003cba:	8082                	ret

0000000080003cbc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003cbc:	7139                	addi	sp,sp,-64
    80003cbe:	fc06                	sd	ra,56(sp)
    80003cc0:	f822                	sd	s0,48(sp)
    80003cc2:	f426                	sd	s1,40(sp)
    80003cc4:	f04a                	sd	s2,32(sp)
    80003cc6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003cc8:	0001d497          	auipc	s1,0x1d
    80003ccc:	da048493          	addi	s1,s1,-608 # 80020a68 <log>
    80003cd0:	8526                	mv	a0,s1
    80003cd2:	f25fc0ef          	jal	80000bf6 <acquire>
  log.outstanding -= 1;
    80003cd6:	4cdc                	lw	a5,28(s1)
    80003cd8:	37fd                	addiw	a5,a5,-1
    80003cda:	893e                	mv	s2,a5
    80003cdc:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003cde:	509c                	lw	a5,32(s1)
    80003ce0:	ef9d                	bnez	a5,80003d1e <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80003ce2:	04091863          	bnez	s2,80003d32 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003ce6:	0001d497          	auipc	s1,0x1d
    80003cea:	d8248493          	addi	s1,s1,-638 # 80020a68 <log>
    80003cee:	4785                	li	a5,1
    80003cf0:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003cf2:	8526                	mv	a0,s1
    80003cf4:	f97fc0ef          	jal	80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003cf8:	549c                	lw	a5,40(s1)
    80003cfa:	04f04c63          	bgtz	a5,80003d52 <end_op+0x96>
    acquire(&log.lock);
    80003cfe:	0001d497          	auipc	s1,0x1d
    80003d02:	d6a48493          	addi	s1,s1,-662 # 80020a68 <log>
    80003d06:	8526                	mv	a0,s1
    80003d08:	eeffc0ef          	jal	80000bf6 <acquire>
    log.committing = 0;
    80003d0c:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003d10:	8526                	mv	a0,s1
    80003d12:	a58fe0ef          	jal	80001f6a <wakeup>
    release(&log.lock);
    80003d16:	8526                	mv	a0,s1
    80003d18:	f73fc0ef          	jal	80000c8a <release>
}
    80003d1c:	a02d                	j	80003d46 <end_op+0x8a>
    80003d1e:	ec4e                	sd	s3,24(sp)
    80003d20:	e852                	sd	s4,16(sp)
    80003d22:	e456                	sd	s5,8(sp)
    80003d24:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80003d26:	00004517          	auipc	a0,0x4
    80003d2a:	7fa50513          	addi	a0,a0,2042 # 80008520 <etext+0x520>
    80003d2e:	ab1fc0ef          	jal	800007de <panic>
    wakeup(&log);
    80003d32:	0001d497          	auipc	s1,0x1d
    80003d36:	d3648493          	addi	s1,s1,-714 # 80020a68 <log>
    80003d3a:	8526                	mv	a0,s1
    80003d3c:	a2efe0ef          	jal	80001f6a <wakeup>
  release(&log.lock);
    80003d40:	8526                	mv	a0,s1
    80003d42:	f49fc0ef          	jal	80000c8a <release>
}
    80003d46:	70e2                	ld	ra,56(sp)
    80003d48:	7442                	ld	s0,48(sp)
    80003d4a:	74a2                	ld	s1,40(sp)
    80003d4c:	7902                	ld	s2,32(sp)
    80003d4e:	6121                	addi	sp,sp,64
    80003d50:	8082                	ret
    80003d52:	ec4e                	sd	s3,24(sp)
    80003d54:	e852                	sd	s4,16(sp)
    80003d56:	e456                	sd	s5,8(sp)
    80003d58:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d5a:	0001da97          	auipc	s5,0x1d
    80003d5e:	d3aa8a93          	addi	s5,s5,-710 # 80020a94 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003d62:	0001da17          	auipc	s4,0x1d
    80003d66:	d06a0a13          	addi	s4,s4,-762 # 80020a68 <log>
    memmove(to->data, from->data, BSIZE);
    80003d6a:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003d6e:	018a2583          	lw	a1,24(s4)
    80003d72:	012585bb          	addw	a1,a1,s2
    80003d76:	2585                	addiw	a1,a1,1
    80003d78:	024a2503          	lw	a0,36(s4)
    80003d7c:	e2dfe0ef          	jal	80002ba8 <bread>
    80003d80:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003d82:	000aa583          	lw	a1,0(s5)
    80003d86:	024a2503          	lw	a0,36(s4)
    80003d8a:	e1ffe0ef          	jal	80002ba8 <bread>
    80003d8e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003d90:	865a                	mv	a2,s6
    80003d92:	05850593          	addi	a1,a0,88
    80003d96:	05848513          	addi	a0,s1,88
    80003d9a:	f91fc0ef          	jal	80000d2a <memmove>
    bwrite(to);  // write the log
    80003d9e:	8526                	mv	a0,s1
    80003da0:	edffe0ef          	jal	80002c7e <bwrite>
    brelse(from);
    80003da4:	854e                	mv	a0,s3
    80003da6:	f0bfe0ef          	jal	80002cb0 <brelse>
    brelse(to);
    80003daa:	8526                	mv	a0,s1
    80003dac:	f05fe0ef          	jal	80002cb0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003db0:	2905                	addiw	s2,s2,1
    80003db2:	0a91                	addi	s5,s5,4
    80003db4:	028a2783          	lw	a5,40(s4)
    80003db8:	faf94be3          	blt	s2,a5,80003d6e <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003dbc:	cefff0ef          	jal	80003aaa <write_head>
    install_trans(0); // Now install writes to home locations
    80003dc0:	4501                	li	a0,0
    80003dc2:	d47ff0ef          	jal	80003b08 <install_trans>
    log.lh.n = 0;
    80003dc6:	0001d797          	auipc	a5,0x1d
    80003dca:	cc07a523          	sw	zero,-822(a5) # 80020a90 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003dce:	cddff0ef          	jal	80003aaa <write_head>
    80003dd2:	69e2                	ld	s3,24(sp)
    80003dd4:	6a42                	ld	s4,16(sp)
    80003dd6:	6aa2                	ld	s5,8(sp)
    80003dd8:	6b02                	ld	s6,0(sp)
    80003dda:	b715                	j	80003cfe <end_op+0x42>

0000000080003ddc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003ddc:	1101                	addi	sp,sp,-32
    80003dde:	ec06                	sd	ra,24(sp)
    80003de0:	e822                	sd	s0,16(sp)
    80003de2:	e426                	sd	s1,8(sp)
    80003de4:	e04a                	sd	s2,0(sp)
    80003de6:	1000                	addi	s0,sp,32
    80003de8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003dea:	0001d917          	auipc	s2,0x1d
    80003dee:	c7e90913          	addi	s2,s2,-898 # 80020a68 <log>
    80003df2:	854a                	mv	a0,s2
    80003df4:	e03fc0ef          	jal	80000bf6 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003df8:	02892603          	lw	a2,40(s2)
    80003dfc:	47f5                	li	a5,29
    80003dfe:	04c7cc63          	blt	a5,a2,80003e56 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003e02:	0001d797          	auipc	a5,0x1d
    80003e06:	c827a783          	lw	a5,-894(a5) # 80020a84 <log+0x1c>
    80003e0a:	04f05c63          	blez	a5,80003e62 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003e0e:	4781                	li	a5,0
    80003e10:	04c05f63          	blez	a2,80003e6e <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003e14:	44cc                	lw	a1,12(s1)
    80003e16:	0001d717          	auipc	a4,0x1d
    80003e1a:	c7e70713          	addi	a4,a4,-898 # 80020a94 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003e1e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003e20:	4314                	lw	a3,0(a4)
    80003e22:	04b68663          	beq	a3,a1,80003e6e <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003e26:	2785                	addiw	a5,a5,1
    80003e28:	0711                	addi	a4,a4,4
    80003e2a:	fef61be3          	bne	a2,a5,80003e20 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003e2e:	0621                	addi	a2,a2,8
    80003e30:	060a                	slli	a2,a2,0x2
    80003e32:	0001d797          	auipc	a5,0x1d
    80003e36:	c3678793          	addi	a5,a5,-970 # 80020a68 <log>
    80003e3a:	97b2                	add	a5,a5,a2
    80003e3c:	44d8                	lw	a4,12(s1)
    80003e3e:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003e40:	8526                	mv	a0,s1
    80003e42:	ef3fe0ef          	jal	80002d34 <bpin>
    log.lh.n++;
    80003e46:	0001d717          	auipc	a4,0x1d
    80003e4a:	c2270713          	addi	a4,a4,-990 # 80020a68 <log>
    80003e4e:	571c                	lw	a5,40(a4)
    80003e50:	2785                	addiw	a5,a5,1
    80003e52:	d71c                	sw	a5,40(a4)
    80003e54:	a80d                	j	80003e86 <log_write+0xaa>
    panic("too big a transaction");
    80003e56:	00004517          	auipc	a0,0x4
    80003e5a:	6da50513          	addi	a0,a0,1754 # 80008530 <etext+0x530>
    80003e5e:	981fc0ef          	jal	800007de <panic>
    panic("log_write outside of trans");
    80003e62:	00004517          	auipc	a0,0x4
    80003e66:	6e650513          	addi	a0,a0,1766 # 80008548 <etext+0x548>
    80003e6a:	975fc0ef          	jal	800007de <panic>
  log.lh.block[i] = b->blockno;
    80003e6e:	00878693          	addi	a3,a5,8
    80003e72:	068a                	slli	a3,a3,0x2
    80003e74:	0001d717          	auipc	a4,0x1d
    80003e78:	bf470713          	addi	a4,a4,-1036 # 80020a68 <log>
    80003e7c:	9736                	add	a4,a4,a3
    80003e7e:	44d4                	lw	a3,12(s1)
    80003e80:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003e82:	faf60fe3          	beq	a2,a5,80003e40 <log_write+0x64>
  }
  release(&log.lock);
    80003e86:	0001d517          	auipc	a0,0x1d
    80003e8a:	be250513          	addi	a0,a0,-1054 # 80020a68 <log>
    80003e8e:	dfdfc0ef          	jal	80000c8a <release>
}
    80003e92:	60e2                	ld	ra,24(sp)
    80003e94:	6442                	ld	s0,16(sp)
    80003e96:	64a2                	ld	s1,8(sp)
    80003e98:	6902                	ld	s2,0(sp)
    80003e9a:	6105                	addi	sp,sp,32
    80003e9c:	8082                	ret

0000000080003e9e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003e9e:	1101                	addi	sp,sp,-32
    80003ea0:	ec06                	sd	ra,24(sp)
    80003ea2:	e822                	sd	s0,16(sp)
    80003ea4:	e426                	sd	s1,8(sp)
    80003ea6:	e04a                	sd	s2,0(sp)
    80003ea8:	1000                	addi	s0,sp,32
    80003eaa:	84aa                	mv	s1,a0
    80003eac:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003eae:	00004597          	auipc	a1,0x4
    80003eb2:	6ba58593          	addi	a1,a1,1722 # 80008568 <etext+0x568>
    80003eb6:	0521                	addi	a0,a0,8
    80003eb8:	cbbfc0ef          	jal	80000b72 <initlock>
  lk->name = name;
    80003ebc:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003ec0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ec4:	0204a423          	sw	zero,40(s1)
}
    80003ec8:	60e2                	ld	ra,24(sp)
    80003eca:	6442                	ld	s0,16(sp)
    80003ecc:	64a2                	ld	s1,8(sp)
    80003ece:	6902                	ld	s2,0(sp)
    80003ed0:	6105                	addi	sp,sp,32
    80003ed2:	8082                	ret

0000000080003ed4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003ed4:	1101                	addi	sp,sp,-32
    80003ed6:	ec06                	sd	ra,24(sp)
    80003ed8:	e822                	sd	s0,16(sp)
    80003eda:	e426                	sd	s1,8(sp)
    80003edc:	e04a                	sd	s2,0(sp)
    80003ede:	1000                	addi	s0,sp,32
    80003ee0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ee2:	00850913          	addi	s2,a0,8
    80003ee6:	854a                	mv	a0,s2
    80003ee8:	d0ffc0ef          	jal	80000bf6 <acquire>
  while (lk->locked) {
    80003eec:	409c                	lw	a5,0(s1)
    80003eee:	c799                	beqz	a5,80003efc <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003ef0:	85ca                	mv	a1,s2
    80003ef2:	8526                	mv	a0,s1
    80003ef4:	82afe0ef          	jal	80001f1e <sleep>
  while (lk->locked) {
    80003ef8:	409c                	lw	a5,0(s1)
    80003efa:	fbfd                	bnez	a5,80003ef0 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003efc:	4785                	li	a5,1
    80003efe:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003f00:	a15fd0ef          	jal	80001914 <myproc>
    80003f04:	591c                	lw	a5,48(a0)
    80003f06:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003f08:	854a                	mv	a0,s2
    80003f0a:	d81fc0ef          	jal	80000c8a <release>
}
    80003f0e:	60e2                	ld	ra,24(sp)
    80003f10:	6442                	ld	s0,16(sp)
    80003f12:	64a2                	ld	s1,8(sp)
    80003f14:	6902                	ld	s2,0(sp)
    80003f16:	6105                	addi	sp,sp,32
    80003f18:	8082                	ret

0000000080003f1a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003f1a:	1101                	addi	sp,sp,-32
    80003f1c:	ec06                	sd	ra,24(sp)
    80003f1e:	e822                	sd	s0,16(sp)
    80003f20:	e426                	sd	s1,8(sp)
    80003f22:	e04a                	sd	s2,0(sp)
    80003f24:	1000                	addi	s0,sp,32
    80003f26:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003f28:	00850913          	addi	s2,a0,8
    80003f2c:	854a                	mv	a0,s2
    80003f2e:	cc9fc0ef          	jal	80000bf6 <acquire>
  lk->locked = 0;
    80003f32:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f36:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003f3a:	8526                	mv	a0,s1
    80003f3c:	82efe0ef          	jal	80001f6a <wakeup>
  release(&lk->lk);
    80003f40:	854a                	mv	a0,s2
    80003f42:	d49fc0ef          	jal	80000c8a <release>
}
    80003f46:	60e2                	ld	ra,24(sp)
    80003f48:	6442                	ld	s0,16(sp)
    80003f4a:	64a2                	ld	s1,8(sp)
    80003f4c:	6902                	ld	s2,0(sp)
    80003f4e:	6105                	addi	sp,sp,32
    80003f50:	8082                	ret

0000000080003f52 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003f52:	7179                	addi	sp,sp,-48
    80003f54:	f406                	sd	ra,40(sp)
    80003f56:	f022                	sd	s0,32(sp)
    80003f58:	ec26                	sd	s1,24(sp)
    80003f5a:	e84a                	sd	s2,16(sp)
    80003f5c:	1800                	addi	s0,sp,48
    80003f5e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003f60:	00850913          	addi	s2,a0,8
    80003f64:	854a                	mv	a0,s2
    80003f66:	c91fc0ef          	jal	80000bf6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f6a:	409c                	lw	a5,0(s1)
    80003f6c:	ef81                	bnez	a5,80003f84 <holdingsleep+0x32>
    80003f6e:	4481                	li	s1,0
  release(&lk->lk);
    80003f70:	854a                	mv	a0,s2
    80003f72:	d19fc0ef          	jal	80000c8a <release>
  return r;
}
    80003f76:	8526                	mv	a0,s1
    80003f78:	70a2                	ld	ra,40(sp)
    80003f7a:	7402                	ld	s0,32(sp)
    80003f7c:	64e2                	ld	s1,24(sp)
    80003f7e:	6942                	ld	s2,16(sp)
    80003f80:	6145                	addi	sp,sp,48
    80003f82:	8082                	ret
    80003f84:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f86:	0284a983          	lw	s3,40(s1)
    80003f8a:	98bfd0ef          	jal	80001914 <myproc>
    80003f8e:	5904                	lw	s1,48(a0)
    80003f90:	413484b3          	sub	s1,s1,s3
    80003f94:	0014b493          	seqz	s1,s1
    80003f98:	69a2                	ld	s3,8(sp)
    80003f9a:	bfd9                	j	80003f70 <holdingsleep+0x1e>

0000000080003f9c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003f9c:	1141                	addi	sp,sp,-16
    80003f9e:	e406                	sd	ra,8(sp)
    80003fa0:	e022                	sd	s0,0(sp)
    80003fa2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003fa4:	00004597          	auipc	a1,0x4
    80003fa8:	5d458593          	addi	a1,a1,1492 # 80008578 <etext+0x578>
    80003fac:	0001d517          	auipc	a0,0x1d
    80003fb0:	c0450513          	addi	a0,a0,-1020 # 80020bb0 <ftable>
    80003fb4:	bbffc0ef          	jal	80000b72 <initlock>
}
    80003fb8:	60a2                	ld	ra,8(sp)
    80003fba:	6402                	ld	s0,0(sp)
    80003fbc:	0141                	addi	sp,sp,16
    80003fbe:	8082                	ret

0000000080003fc0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003fc0:	1101                	addi	sp,sp,-32
    80003fc2:	ec06                	sd	ra,24(sp)
    80003fc4:	e822                	sd	s0,16(sp)
    80003fc6:	e426                	sd	s1,8(sp)
    80003fc8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003fca:	0001d517          	auipc	a0,0x1d
    80003fce:	be650513          	addi	a0,a0,-1050 # 80020bb0 <ftable>
    80003fd2:	c25fc0ef          	jal	80000bf6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003fd6:	0001d497          	auipc	s1,0x1d
    80003fda:	bf248493          	addi	s1,s1,-1038 # 80020bc8 <ftable+0x18>
    80003fde:	0001e717          	auipc	a4,0x1e
    80003fe2:	b8a70713          	addi	a4,a4,-1142 # 80021b68 <disk>
    if(f->ref == 0){
    80003fe6:	40dc                	lw	a5,4(s1)
    80003fe8:	cf89                	beqz	a5,80004002 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003fea:	02848493          	addi	s1,s1,40
    80003fee:	fee49ce3          	bne	s1,a4,80003fe6 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003ff2:	0001d517          	auipc	a0,0x1d
    80003ff6:	bbe50513          	addi	a0,a0,-1090 # 80020bb0 <ftable>
    80003ffa:	c91fc0ef          	jal	80000c8a <release>
  return 0;
    80003ffe:	4481                	li	s1,0
    80004000:	a809                	j	80004012 <filealloc+0x52>
      f->ref = 1;
    80004002:	4785                	li	a5,1
    80004004:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004006:	0001d517          	auipc	a0,0x1d
    8000400a:	baa50513          	addi	a0,a0,-1110 # 80020bb0 <ftable>
    8000400e:	c7dfc0ef          	jal	80000c8a <release>
}
    80004012:	8526                	mv	a0,s1
    80004014:	60e2                	ld	ra,24(sp)
    80004016:	6442                	ld	s0,16(sp)
    80004018:	64a2                	ld	s1,8(sp)
    8000401a:	6105                	addi	sp,sp,32
    8000401c:	8082                	ret

000000008000401e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000401e:	1101                	addi	sp,sp,-32
    80004020:	ec06                	sd	ra,24(sp)
    80004022:	e822                	sd	s0,16(sp)
    80004024:	e426                	sd	s1,8(sp)
    80004026:	1000                	addi	s0,sp,32
    80004028:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000402a:	0001d517          	auipc	a0,0x1d
    8000402e:	b8650513          	addi	a0,a0,-1146 # 80020bb0 <ftable>
    80004032:	bc5fc0ef          	jal	80000bf6 <acquire>
  if(f->ref < 1)
    80004036:	40dc                	lw	a5,4(s1)
    80004038:	02f05063          	blez	a5,80004058 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000403c:	2785                	addiw	a5,a5,1
    8000403e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004040:	0001d517          	auipc	a0,0x1d
    80004044:	b7050513          	addi	a0,a0,-1168 # 80020bb0 <ftable>
    80004048:	c43fc0ef          	jal	80000c8a <release>
  return f;
}
    8000404c:	8526                	mv	a0,s1
    8000404e:	60e2                	ld	ra,24(sp)
    80004050:	6442                	ld	s0,16(sp)
    80004052:	64a2                	ld	s1,8(sp)
    80004054:	6105                	addi	sp,sp,32
    80004056:	8082                	ret
    panic("filedup");
    80004058:	00004517          	auipc	a0,0x4
    8000405c:	52850513          	addi	a0,a0,1320 # 80008580 <etext+0x580>
    80004060:	f7efc0ef          	jal	800007de <panic>

0000000080004064 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004064:	7139                	addi	sp,sp,-64
    80004066:	fc06                	sd	ra,56(sp)
    80004068:	f822                	sd	s0,48(sp)
    8000406a:	f426                	sd	s1,40(sp)
    8000406c:	0080                	addi	s0,sp,64
    8000406e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004070:	0001d517          	auipc	a0,0x1d
    80004074:	b4050513          	addi	a0,a0,-1216 # 80020bb0 <ftable>
    80004078:	b7ffc0ef          	jal	80000bf6 <acquire>
  if(f->ref < 1)
    8000407c:	40dc                	lw	a5,4(s1)
    8000407e:	04f05863          	blez	a5,800040ce <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    80004082:	37fd                	addiw	a5,a5,-1
    80004084:	c0dc                	sw	a5,4(s1)
    80004086:	04f04e63          	bgtz	a5,800040e2 <fileclose+0x7e>
    8000408a:	f04a                	sd	s2,32(sp)
    8000408c:	ec4e                	sd	s3,24(sp)
    8000408e:	e852                	sd	s4,16(sp)
    80004090:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004092:	0004a903          	lw	s2,0(s1)
    80004096:	0094ca83          	lbu	s5,9(s1)
    8000409a:	0104ba03          	ld	s4,16(s1)
    8000409e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800040a2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800040a6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800040aa:	0001d517          	auipc	a0,0x1d
    800040ae:	b0650513          	addi	a0,a0,-1274 # 80020bb0 <ftable>
    800040b2:	bd9fc0ef          	jal	80000c8a <release>

  if(ff.type == FD_PIPE){
    800040b6:	4785                	li	a5,1
    800040b8:	04f90063          	beq	s2,a5,800040f8 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800040bc:	3979                	addiw	s2,s2,-2
    800040be:	4785                	li	a5,1
    800040c0:	0527f563          	bgeu	a5,s2,8000410a <fileclose+0xa6>
    800040c4:	7902                	ld	s2,32(sp)
    800040c6:	69e2                	ld	s3,24(sp)
    800040c8:	6a42                	ld	s4,16(sp)
    800040ca:	6aa2                	ld	s5,8(sp)
    800040cc:	a00d                	j	800040ee <fileclose+0x8a>
    800040ce:	f04a                	sd	s2,32(sp)
    800040d0:	ec4e                	sd	s3,24(sp)
    800040d2:	e852                	sd	s4,16(sp)
    800040d4:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800040d6:	00004517          	auipc	a0,0x4
    800040da:	4b250513          	addi	a0,a0,1202 # 80008588 <etext+0x588>
    800040de:	f00fc0ef          	jal	800007de <panic>
    release(&ftable.lock);
    800040e2:	0001d517          	auipc	a0,0x1d
    800040e6:	ace50513          	addi	a0,a0,-1330 # 80020bb0 <ftable>
    800040ea:	ba1fc0ef          	jal	80000c8a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800040ee:	70e2                	ld	ra,56(sp)
    800040f0:	7442                	ld	s0,48(sp)
    800040f2:	74a2                	ld	s1,40(sp)
    800040f4:	6121                	addi	sp,sp,64
    800040f6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800040f8:	85d6                	mv	a1,s5
    800040fa:	8552                	mv	a0,s4
    800040fc:	340000ef          	jal	8000443c <pipeclose>
    80004100:	7902                	ld	s2,32(sp)
    80004102:	69e2                	ld	s3,24(sp)
    80004104:	6a42                	ld	s4,16(sp)
    80004106:	6aa2                	ld	s5,8(sp)
    80004108:	b7dd                	j	800040ee <fileclose+0x8a>
    begin_op();
    8000410a:	b49ff0ef          	jal	80003c52 <begin_op>
    iput(ff.ip);
    8000410e:	854e                	mv	a0,s3
    80004110:	ac0ff0ef          	jal	800033d0 <iput>
    end_op();
    80004114:	ba9ff0ef          	jal	80003cbc <end_op>
    80004118:	7902                	ld	s2,32(sp)
    8000411a:	69e2                	ld	s3,24(sp)
    8000411c:	6a42                	ld	s4,16(sp)
    8000411e:	6aa2                	ld	s5,8(sp)
    80004120:	b7f9                	j	800040ee <fileclose+0x8a>

0000000080004122 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004122:	715d                	addi	sp,sp,-80
    80004124:	e486                	sd	ra,72(sp)
    80004126:	e0a2                	sd	s0,64(sp)
    80004128:	fc26                	sd	s1,56(sp)
    8000412a:	f44e                	sd	s3,40(sp)
    8000412c:	0880                	addi	s0,sp,80
    8000412e:	84aa                	mv	s1,a0
    80004130:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004132:	fe2fd0ef          	jal	80001914 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004136:	409c                	lw	a5,0(s1)
    80004138:	37f9                	addiw	a5,a5,-2
    8000413a:	4705                	li	a4,1
    8000413c:	04f76263          	bltu	a4,a5,80004180 <filestat+0x5e>
    80004140:	f84a                	sd	s2,48(sp)
    80004142:	f052                	sd	s4,32(sp)
    80004144:	892a                	mv	s2,a0
    ilock(f->ip);
    80004146:	6c88                	ld	a0,24(s1)
    80004148:	906ff0ef          	jal	8000324e <ilock>
    stati(f->ip, &st);
    8000414c:	fb840a13          	addi	s4,s0,-72
    80004150:	85d2                	mv	a1,s4
    80004152:	6c88                	ld	a0,24(s1)
    80004154:	c5eff0ef          	jal	800035b2 <stati>
    iunlock(f->ip);
    80004158:	6c88                	ld	a0,24(s1)
    8000415a:	9a2ff0ef          	jal	800032fc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000415e:	46e1                	li	a3,24
    80004160:	8652                	mv	a2,s4
    80004162:	85ce                	mv	a1,s3
    80004164:	05093503          	ld	a0,80(s2)
    80004168:	cdefd0ef          	jal	80001646 <copyout>
    8000416c:	41f5551b          	sraiw	a0,a0,0x1f
    80004170:	7942                	ld	s2,48(sp)
    80004172:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004174:	60a6                	ld	ra,72(sp)
    80004176:	6406                	ld	s0,64(sp)
    80004178:	74e2                	ld	s1,56(sp)
    8000417a:	79a2                	ld	s3,40(sp)
    8000417c:	6161                	addi	sp,sp,80
    8000417e:	8082                	ret
  return -1;
    80004180:	557d                	li	a0,-1
    80004182:	bfcd                	j	80004174 <filestat+0x52>

0000000080004184 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004184:	7179                	addi	sp,sp,-48
    80004186:	f406                	sd	ra,40(sp)
    80004188:	f022                	sd	s0,32(sp)
    8000418a:	e84a                	sd	s2,16(sp)
    8000418c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000418e:	00854783          	lbu	a5,8(a0)
    80004192:	cfd1                	beqz	a5,8000422e <fileread+0xaa>
    80004194:	ec26                	sd	s1,24(sp)
    80004196:	e44e                	sd	s3,8(sp)
    80004198:	84aa                	mv	s1,a0
    8000419a:	89ae                	mv	s3,a1
    8000419c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000419e:	411c                	lw	a5,0(a0)
    800041a0:	4705                	li	a4,1
    800041a2:	04e78363          	beq	a5,a4,800041e8 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800041a6:	470d                	li	a4,3
    800041a8:	04e78763          	beq	a5,a4,800041f6 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800041ac:	4709                	li	a4,2
    800041ae:	06e79a63          	bne	a5,a4,80004222 <fileread+0x9e>
    ilock(f->ip);
    800041b2:	6d08                	ld	a0,24(a0)
    800041b4:	89aff0ef          	jal	8000324e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800041b8:	874a                	mv	a4,s2
    800041ba:	5094                	lw	a3,32(s1)
    800041bc:	864e                	mv	a2,s3
    800041be:	4585                	li	a1,1
    800041c0:	6c88                	ld	a0,24(s1)
    800041c2:	c1eff0ef          	jal	800035e0 <readi>
    800041c6:	892a                	mv	s2,a0
    800041c8:	00a05563          	blez	a0,800041d2 <fileread+0x4e>
      f->off += r;
    800041cc:	509c                	lw	a5,32(s1)
    800041ce:	9fa9                	addw	a5,a5,a0
    800041d0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800041d2:	6c88                	ld	a0,24(s1)
    800041d4:	928ff0ef          	jal	800032fc <iunlock>
    800041d8:	64e2                	ld	s1,24(sp)
    800041da:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800041dc:	854a                	mv	a0,s2
    800041de:	70a2                	ld	ra,40(sp)
    800041e0:	7402                	ld	s0,32(sp)
    800041e2:	6942                	ld	s2,16(sp)
    800041e4:	6145                	addi	sp,sp,48
    800041e6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800041e8:	6908                	ld	a0,16(a0)
    800041ea:	3a2000ef          	jal	8000458c <piperead>
    800041ee:	892a                	mv	s2,a0
    800041f0:	64e2                	ld	s1,24(sp)
    800041f2:	69a2                	ld	s3,8(sp)
    800041f4:	b7e5                	j	800041dc <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800041f6:	02451783          	lh	a5,36(a0)
    800041fa:	03079693          	slli	a3,a5,0x30
    800041fe:	92c1                	srli	a3,a3,0x30
    80004200:	4725                	li	a4,9
    80004202:	02d76863          	bltu	a4,a3,80004232 <fileread+0xae>
    80004206:	0792                	slli	a5,a5,0x4
    80004208:	0001d717          	auipc	a4,0x1d
    8000420c:	90870713          	addi	a4,a4,-1784 # 80020b10 <devsw>
    80004210:	97ba                	add	a5,a5,a4
    80004212:	639c                	ld	a5,0(a5)
    80004214:	c39d                	beqz	a5,8000423a <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004216:	4505                	li	a0,1
    80004218:	9782                	jalr	a5
    8000421a:	892a                	mv	s2,a0
    8000421c:	64e2                	ld	s1,24(sp)
    8000421e:	69a2                	ld	s3,8(sp)
    80004220:	bf75                	j	800041dc <fileread+0x58>
    panic("fileread");
    80004222:	00004517          	auipc	a0,0x4
    80004226:	37650513          	addi	a0,a0,886 # 80008598 <etext+0x598>
    8000422a:	db4fc0ef          	jal	800007de <panic>
    return -1;
    8000422e:	597d                	li	s2,-1
    80004230:	b775                	j	800041dc <fileread+0x58>
      return -1;
    80004232:	597d                	li	s2,-1
    80004234:	64e2                	ld	s1,24(sp)
    80004236:	69a2                	ld	s3,8(sp)
    80004238:	b755                	j	800041dc <fileread+0x58>
    8000423a:	597d                	li	s2,-1
    8000423c:	64e2                	ld	s1,24(sp)
    8000423e:	69a2                	ld	s3,8(sp)
    80004240:	bf71                	j	800041dc <fileread+0x58>

0000000080004242 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004242:	00954783          	lbu	a5,9(a0)
    80004246:	10078e63          	beqz	a5,80004362 <filewrite+0x120>
{
    8000424a:	711d                	addi	sp,sp,-96
    8000424c:	ec86                	sd	ra,88(sp)
    8000424e:	e8a2                	sd	s0,80(sp)
    80004250:	e0ca                	sd	s2,64(sp)
    80004252:	f456                	sd	s5,40(sp)
    80004254:	f05a                	sd	s6,32(sp)
    80004256:	1080                	addi	s0,sp,96
    80004258:	892a                	mv	s2,a0
    8000425a:	8b2e                	mv	s6,a1
    8000425c:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000425e:	411c                	lw	a5,0(a0)
    80004260:	4705                	li	a4,1
    80004262:	02e78963          	beq	a5,a4,80004294 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004266:	470d                	li	a4,3
    80004268:	02e78a63          	beq	a5,a4,8000429c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000426c:	4709                	li	a4,2
    8000426e:	0ce79e63          	bne	a5,a4,8000434a <filewrite+0x108>
    80004272:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004274:	0ac05963          	blez	a2,80004326 <filewrite+0xe4>
    80004278:	e4a6                	sd	s1,72(sp)
    8000427a:	fc4e                	sd	s3,56(sp)
    8000427c:	ec5e                	sd	s7,24(sp)
    8000427e:	e862                	sd	s8,16(sp)
    80004280:	e466                	sd	s9,8(sp)
    int i = 0;
    80004282:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004284:	6b85                	lui	s7,0x1
    80004286:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000428a:	6c85                	lui	s9,0x1
    8000428c:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004290:	4c05                	li	s8,1
    80004292:	a8ad                	j	8000430c <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    80004294:	6908                	ld	a0,16(a0)
    80004296:	1fe000ef          	jal	80004494 <pipewrite>
    8000429a:	a04d                	j	8000433c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000429c:	02451783          	lh	a5,36(a0)
    800042a0:	03079693          	slli	a3,a5,0x30
    800042a4:	92c1                	srli	a3,a3,0x30
    800042a6:	4725                	li	a4,9
    800042a8:	0ad76f63          	bltu	a4,a3,80004366 <filewrite+0x124>
    800042ac:	0792                	slli	a5,a5,0x4
    800042ae:	0001d717          	auipc	a4,0x1d
    800042b2:	86270713          	addi	a4,a4,-1950 # 80020b10 <devsw>
    800042b6:	97ba                	add	a5,a5,a4
    800042b8:	679c                	ld	a5,8(a5)
    800042ba:	cbc5                	beqz	a5,8000436a <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    800042bc:	4505                	li	a0,1
    800042be:	9782                	jalr	a5
    800042c0:	a8b5                	j	8000433c <filewrite+0xfa>
      if(n1 > max)
    800042c2:	2981                	sext.w	s3,s3
      begin_op();
    800042c4:	98fff0ef          	jal	80003c52 <begin_op>
      ilock(f->ip);
    800042c8:	01893503          	ld	a0,24(s2)
    800042cc:	f83fe0ef          	jal	8000324e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800042d0:	874e                	mv	a4,s3
    800042d2:	02092683          	lw	a3,32(s2)
    800042d6:	016a0633          	add	a2,s4,s6
    800042da:	85e2                	mv	a1,s8
    800042dc:	01893503          	ld	a0,24(s2)
    800042e0:	bf2ff0ef          	jal	800036d2 <writei>
    800042e4:	84aa                	mv	s1,a0
    800042e6:	00a05763          	blez	a0,800042f4 <filewrite+0xb2>
        f->off += r;
    800042ea:	02092783          	lw	a5,32(s2)
    800042ee:	9fa9                	addw	a5,a5,a0
    800042f0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800042f4:	01893503          	ld	a0,24(s2)
    800042f8:	804ff0ef          	jal	800032fc <iunlock>
      end_op();
    800042fc:	9c1ff0ef          	jal	80003cbc <end_op>

      if(r != n1){
    80004300:	02999563          	bne	s3,s1,8000432a <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    80004304:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004308:	015a5963          	bge	s4,s5,8000431a <filewrite+0xd8>
      int n1 = n - i;
    8000430c:	414a87bb          	subw	a5,s5,s4
    80004310:	89be                	mv	s3,a5
      if(n1 > max)
    80004312:	fafbd8e3          	bge	s7,a5,800042c2 <filewrite+0x80>
    80004316:	89e6                	mv	s3,s9
    80004318:	b76d                	j	800042c2 <filewrite+0x80>
    8000431a:	64a6                	ld	s1,72(sp)
    8000431c:	79e2                	ld	s3,56(sp)
    8000431e:	6be2                	ld	s7,24(sp)
    80004320:	6c42                	ld	s8,16(sp)
    80004322:	6ca2                	ld	s9,8(sp)
    80004324:	a801                	j	80004334 <filewrite+0xf2>
    int i = 0;
    80004326:	4a01                	li	s4,0
    80004328:	a031                	j	80004334 <filewrite+0xf2>
    8000432a:	64a6                	ld	s1,72(sp)
    8000432c:	79e2                	ld	s3,56(sp)
    8000432e:	6be2                	ld	s7,24(sp)
    80004330:	6c42                	ld	s8,16(sp)
    80004332:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004334:	034a9d63          	bne	s5,s4,8000436e <filewrite+0x12c>
    80004338:	8556                	mv	a0,s5
    8000433a:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000433c:	60e6                	ld	ra,88(sp)
    8000433e:	6446                	ld	s0,80(sp)
    80004340:	6906                	ld	s2,64(sp)
    80004342:	7aa2                	ld	s5,40(sp)
    80004344:	7b02                	ld	s6,32(sp)
    80004346:	6125                	addi	sp,sp,96
    80004348:	8082                	ret
    8000434a:	e4a6                	sd	s1,72(sp)
    8000434c:	fc4e                	sd	s3,56(sp)
    8000434e:	f852                	sd	s4,48(sp)
    80004350:	ec5e                	sd	s7,24(sp)
    80004352:	e862                	sd	s8,16(sp)
    80004354:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004356:	00004517          	auipc	a0,0x4
    8000435a:	25250513          	addi	a0,a0,594 # 800085a8 <etext+0x5a8>
    8000435e:	c80fc0ef          	jal	800007de <panic>
    return -1;
    80004362:	557d                	li	a0,-1
}
    80004364:	8082                	ret
      return -1;
    80004366:	557d                	li	a0,-1
    80004368:	bfd1                	j	8000433c <filewrite+0xfa>
    8000436a:	557d                	li	a0,-1
    8000436c:	bfc1                	j	8000433c <filewrite+0xfa>
    ret = (i == n ? n : -1);
    8000436e:	557d                	li	a0,-1
    80004370:	7a42                	ld	s4,48(sp)
    80004372:	b7e9                	j	8000433c <filewrite+0xfa>

0000000080004374 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004374:	7179                	addi	sp,sp,-48
    80004376:	f406                	sd	ra,40(sp)
    80004378:	f022                	sd	s0,32(sp)
    8000437a:	ec26                	sd	s1,24(sp)
    8000437c:	e052                	sd	s4,0(sp)
    8000437e:	1800                	addi	s0,sp,48
    80004380:	84aa                	mv	s1,a0
    80004382:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004384:	0005b023          	sd	zero,0(a1)
    80004388:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000438c:	c35ff0ef          	jal	80003fc0 <filealloc>
    80004390:	e088                	sd	a0,0(s1)
    80004392:	c549                	beqz	a0,8000441c <pipealloc+0xa8>
    80004394:	c2dff0ef          	jal	80003fc0 <filealloc>
    80004398:	00aa3023          	sd	a0,0(s4)
    8000439c:	cd25                	beqz	a0,80004414 <pipealloc+0xa0>
    8000439e:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800043a0:	f82fc0ef          	jal	80000b22 <kalloc>
    800043a4:	892a                	mv	s2,a0
    800043a6:	c12d                	beqz	a0,80004408 <pipealloc+0x94>
    800043a8:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800043aa:	4985                	li	s3,1
    800043ac:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800043b0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800043b4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800043b8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800043bc:	00004597          	auipc	a1,0x4
    800043c0:	1fc58593          	addi	a1,a1,508 # 800085b8 <etext+0x5b8>
    800043c4:	faefc0ef          	jal	80000b72 <initlock>
  (*f0)->type = FD_PIPE;
    800043c8:	609c                	ld	a5,0(s1)
    800043ca:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800043ce:	609c                	ld	a5,0(s1)
    800043d0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800043d4:	609c                	ld	a5,0(s1)
    800043d6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800043da:	609c                	ld	a5,0(s1)
    800043dc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800043e0:	000a3783          	ld	a5,0(s4)
    800043e4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800043e8:	000a3783          	ld	a5,0(s4)
    800043ec:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800043f0:	000a3783          	ld	a5,0(s4)
    800043f4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800043f8:	000a3783          	ld	a5,0(s4)
    800043fc:	0127b823          	sd	s2,16(a5)
  return 0;
    80004400:	4501                	li	a0,0
    80004402:	6942                	ld	s2,16(sp)
    80004404:	69a2                	ld	s3,8(sp)
    80004406:	a01d                	j	8000442c <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004408:	6088                	ld	a0,0(s1)
    8000440a:	c119                	beqz	a0,80004410 <pipealloc+0x9c>
    8000440c:	6942                	ld	s2,16(sp)
    8000440e:	a029                	j	80004418 <pipealloc+0xa4>
    80004410:	6942                	ld	s2,16(sp)
    80004412:	a029                	j	8000441c <pipealloc+0xa8>
    80004414:	6088                	ld	a0,0(s1)
    80004416:	c10d                	beqz	a0,80004438 <pipealloc+0xc4>
    fileclose(*f0);
    80004418:	c4dff0ef          	jal	80004064 <fileclose>
  if(*f1)
    8000441c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004420:	557d                	li	a0,-1
  if(*f1)
    80004422:	c789                	beqz	a5,8000442c <pipealloc+0xb8>
    fileclose(*f1);
    80004424:	853e                	mv	a0,a5
    80004426:	c3fff0ef          	jal	80004064 <fileclose>
  return -1;
    8000442a:	557d                	li	a0,-1
}
    8000442c:	70a2                	ld	ra,40(sp)
    8000442e:	7402                	ld	s0,32(sp)
    80004430:	64e2                	ld	s1,24(sp)
    80004432:	6a02                	ld	s4,0(sp)
    80004434:	6145                	addi	sp,sp,48
    80004436:	8082                	ret
  return -1;
    80004438:	557d                	li	a0,-1
    8000443a:	bfcd                	j	8000442c <pipealloc+0xb8>

000000008000443c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000443c:	1101                	addi	sp,sp,-32
    8000443e:	ec06                	sd	ra,24(sp)
    80004440:	e822                	sd	s0,16(sp)
    80004442:	e426                	sd	s1,8(sp)
    80004444:	e04a                	sd	s2,0(sp)
    80004446:	1000                	addi	s0,sp,32
    80004448:	84aa                	mv	s1,a0
    8000444a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000444c:	faafc0ef          	jal	80000bf6 <acquire>
  if(writable){
    80004450:	02090763          	beqz	s2,8000447e <pipeclose+0x42>
    pi->writeopen = 0;
    80004454:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004458:	21848513          	addi	a0,s1,536
    8000445c:	b0ffd0ef          	jal	80001f6a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004460:	2204b783          	ld	a5,544(s1)
    80004464:	e785                	bnez	a5,8000448c <pipeclose+0x50>
    release(&pi->lock);
    80004466:	8526                	mv	a0,s1
    80004468:	823fc0ef          	jal	80000c8a <release>
    kfree((char*)pi);
    8000446c:	8526                	mv	a0,s1
    8000446e:	dd2fc0ef          	jal	80000a40 <kfree>
  } else
    release(&pi->lock);
}
    80004472:	60e2                	ld	ra,24(sp)
    80004474:	6442                	ld	s0,16(sp)
    80004476:	64a2                	ld	s1,8(sp)
    80004478:	6902                	ld	s2,0(sp)
    8000447a:	6105                	addi	sp,sp,32
    8000447c:	8082                	ret
    pi->readopen = 0;
    8000447e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004482:	21c48513          	addi	a0,s1,540
    80004486:	ae5fd0ef          	jal	80001f6a <wakeup>
    8000448a:	bfd9                	j	80004460 <pipeclose+0x24>
    release(&pi->lock);
    8000448c:	8526                	mv	a0,s1
    8000448e:	ffcfc0ef          	jal	80000c8a <release>
}
    80004492:	b7c5                	j	80004472 <pipeclose+0x36>

0000000080004494 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004494:	7159                	addi	sp,sp,-112
    80004496:	f486                	sd	ra,104(sp)
    80004498:	f0a2                	sd	s0,96(sp)
    8000449a:	eca6                	sd	s1,88(sp)
    8000449c:	e8ca                	sd	s2,80(sp)
    8000449e:	e4ce                	sd	s3,72(sp)
    800044a0:	e0d2                	sd	s4,64(sp)
    800044a2:	fc56                	sd	s5,56(sp)
    800044a4:	1880                	addi	s0,sp,112
    800044a6:	84aa                	mv	s1,a0
    800044a8:	8aae                	mv	s5,a1
    800044aa:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800044ac:	c68fd0ef          	jal	80001914 <myproc>
    800044b0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800044b2:	8526                	mv	a0,s1
    800044b4:	f42fc0ef          	jal	80000bf6 <acquire>
  while(i < n){
    800044b8:	0d405263          	blez	s4,8000457c <pipewrite+0xe8>
    800044bc:	f85a                	sd	s6,48(sp)
    800044be:	f45e                	sd	s7,40(sp)
    800044c0:	f062                	sd	s8,32(sp)
    800044c2:	ec66                	sd	s9,24(sp)
    800044c4:	e86a                	sd	s10,16(sp)
  int i = 0;
    800044c6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800044c8:	f9f40c13          	addi	s8,s0,-97
    800044cc:	4b85                	li	s7,1
    800044ce:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800044d0:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800044d4:	21c48c93          	addi	s9,s1,540
    800044d8:	a82d                	j	80004512 <pipewrite+0x7e>
      release(&pi->lock);
    800044da:	8526                	mv	a0,s1
    800044dc:	faefc0ef          	jal	80000c8a <release>
      return -1;
    800044e0:	597d                	li	s2,-1
    800044e2:	7b42                	ld	s6,48(sp)
    800044e4:	7ba2                	ld	s7,40(sp)
    800044e6:	7c02                	ld	s8,32(sp)
    800044e8:	6ce2                	ld	s9,24(sp)
    800044ea:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800044ec:	854a                	mv	a0,s2
    800044ee:	70a6                	ld	ra,104(sp)
    800044f0:	7406                	ld	s0,96(sp)
    800044f2:	64e6                	ld	s1,88(sp)
    800044f4:	6946                	ld	s2,80(sp)
    800044f6:	69a6                	ld	s3,72(sp)
    800044f8:	6a06                	ld	s4,64(sp)
    800044fa:	7ae2                	ld	s5,56(sp)
    800044fc:	6165                	addi	sp,sp,112
    800044fe:	8082                	ret
      wakeup(&pi->nread);
    80004500:	856a                	mv	a0,s10
    80004502:	a69fd0ef          	jal	80001f6a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004506:	85a6                	mv	a1,s1
    80004508:	8566                	mv	a0,s9
    8000450a:	a15fd0ef          	jal	80001f1e <sleep>
  while(i < n){
    8000450e:	05495a63          	bge	s2,s4,80004562 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80004512:	2204a783          	lw	a5,544(s1)
    80004516:	d3f1                	beqz	a5,800044da <pipewrite+0x46>
    80004518:	854e                	mv	a0,s3
    8000451a:	c3dfd0ef          	jal	80002156 <killed>
    8000451e:	fd55                	bnez	a0,800044da <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004520:	2184a783          	lw	a5,536(s1)
    80004524:	21c4a703          	lw	a4,540(s1)
    80004528:	2007879b          	addiw	a5,a5,512
    8000452c:	fcf70ae3          	beq	a4,a5,80004500 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004530:	86de                	mv	a3,s7
    80004532:	01590633          	add	a2,s2,s5
    80004536:	85e2                	mv	a1,s8
    80004538:	0509b503          	ld	a0,80(s3)
    8000453c:	9c8fd0ef          	jal	80001704 <copyin>
    80004540:	05650063          	beq	a0,s6,80004580 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004544:	21c4a783          	lw	a5,540(s1)
    80004548:	0017871b          	addiw	a4,a5,1
    8000454c:	20e4ae23          	sw	a4,540(s1)
    80004550:	1ff7f793          	andi	a5,a5,511
    80004554:	97a6                	add	a5,a5,s1
    80004556:	f9f44703          	lbu	a4,-97(s0)
    8000455a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000455e:	2905                	addiw	s2,s2,1
    80004560:	b77d                	j	8000450e <pipewrite+0x7a>
    80004562:	7b42                	ld	s6,48(sp)
    80004564:	7ba2                	ld	s7,40(sp)
    80004566:	7c02                	ld	s8,32(sp)
    80004568:	6ce2                	ld	s9,24(sp)
    8000456a:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000456c:	21848513          	addi	a0,s1,536
    80004570:	9fbfd0ef          	jal	80001f6a <wakeup>
  release(&pi->lock);
    80004574:	8526                	mv	a0,s1
    80004576:	f14fc0ef          	jal	80000c8a <release>
  return i;
    8000457a:	bf8d                	j	800044ec <pipewrite+0x58>
  int i = 0;
    8000457c:	4901                	li	s2,0
    8000457e:	b7fd                	j	8000456c <pipewrite+0xd8>
    80004580:	7b42                	ld	s6,48(sp)
    80004582:	7ba2                	ld	s7,40(sp)
    80004584:	7c02                	ld	s8,32(sp)
    80004586:	6ce2                	ld	s9,24(sp)
    80004588:	6d42                	ld	s10,16(sp)
    8000458a:	b7cd                	j	8000456c <pipewrite+0xd8>

000000008000458c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000458c:	711d                	addi	sp,sp,-96
    8000458e:	ec86                	sd	ra,88(sp)
    80004590:	e8a2                	sd	s0,80(sp)
    80004592:	e4a6                	sd	s1,72(sp)
    80004594:	e0ca                	sd	s2,64(sp)
    80004596:	fc4e                	sd	s3,56(sp)
    80004598:	f852                	sd	s4,48(sp)
    8000459a:	f456                	sd	s5,40(sp)
    8000459c:	1080                	addi	s0,sp,96
    8000459e:	84aa                	mv	s1,a0
    800045a0:	892e                	mv	s2,a1
    800045a2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800045a4:	b70fd0ef          	jal	80001914 <myproc>
    800045a8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800045aa:	8526                	mv	a0,s1
    800045ac:	e4afc0ef          	jal	80000bf6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800045b0:	2184a703          	lw	a4,536(s1)
    800045b4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800045b8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800045bc:	02f71763          	bne	a4,a5,800045ea <piperead+0x5e>
    800045c0:	2244a783          	lw	a5,548(s1)
    800045c4:	cf85                	beqz	a5,800045fc <piperead+0x70>
    if(killed(pr)){
    800045c6:	8552                	mv	a0,s4
    800045c8:	b8ffd0ef          	jal	80002156 <killed>
    800045cc:	e11d                	bnez	a0,800045f2 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800045ce:	85a6                	mv	a1,s1
    800045d0:	854e                	mv	a0,s3
    800045d2:	94dfd0ef          	jal	80001f1e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800045d6:	2184a703          	lw	a4,536(s1)
    800045da:	21c4a783          	lw	a5,540(s1)
    800045de:	fef701e3          	beq	a4,a5,800045c0 <piperead+0x34>
    800045e2:	f05a                	sd	s6,32(sp)
    800045e4:	ec5e                	sd	s7,24(sp)
    800045e6:	e862                	sd	s8,16(sp)
    800045e8:	a829                	j	80004602 <piperead+0x76>
    800045ea:	f05a                	sd	s6,32(sp)
    800045ec:	ec5e                	sd	s7,24(sp)
    800045ee:	e862                	sd	s8,16(sp)
    800045f0:	a809                	j	80004602 <piperead+0x76>
      release(&pi->lock);
    800045f2:	8526                	mv	a0,s1
    800045f4:	e96fc0ef          	jal	80000c8a <release>
      return -1;
    800045f8:	59fd                	li	s3,-1
    800045fa:	a0ad                	j	80004664 <piperead+0xd8>
    800045fc:	f05a                	sd	s6,32(sp)
    800045fe:	ec5e                	sd	s7,24(sp)
    80004600:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004602:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004604:	faf40c13          	addi	s8,s0,-81
    80004608:	4b85                	li	s7,1
    8000460a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000460c:	05505263          	blez	s5,80004650 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004610:	2184a783          	lw	a5,536(s1)
    80004614:	21c4a703          	lw	a4,540(s1)
    80004618:	02f70c63          	beq	a4,a5,80004650 <piperead+0xc4>
    ch = pi->data[pi->nread % PIPESIZE];
    8000461c:	1ff7f793          	andi	a5,a5,511
    80004620:	97a6                	add	a5,a5,s1
    80004622:	0187c783          	lbu	a5,24(a5)
    80004626:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    8000462a:	86de                	mv	a3,s7
    8000462c:	8662                	mv	a2,s8
    8000462e:	85ca                	mv	a1,s2
    80004630:	050a3503          	ld	a0,80(s4)
    80004634:	812fd0ef          	jal	80001646 <copyout>
    80004638:	05650063          	beq	a0,s6,80004678 <piperead+0xec>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    8000463c:	2184a783          	lw	a5,536(s1)
    80004640:	2785                	addiw	a5,a5,1
    80004642:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004646:	2985                	addiw	s3,s3,1
    80004648:	0905                	addi	s2,s2,1
    8000464a:	fd3a93e3          	bne	s5,s3,80004610 <piperead+0x84>
    8000464e:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004650:	21c48513          	addi	a0,s1,540
    80004654:	917fd0ef          	jal	80001f6a <wakeup>
  release(&pi->lock);
    80004658:	8526                	mv	a0,s1
    8000465a:	e30fc0ef          	jal	80000c8a <release>
    8000465e:	7b02                	ld	s6,32(sp)
    80004660:	6be2                	ld	s7,24(sp)
    80004662:	6c42                	ld	s8,16(sp)
  return i;
}
    80004664:	854e                	mv	a0,s3
    80004666:	60e6                	ld	ra,88(sp)
    80004668:	6446                	ld	s0,80(sp)
    8000466a:	64a6                	ld	s1,72(sp)
    8000466c:	6906                	ld	s2,64(sp)
    8000466e:	79e2                	ld	s3,56(sp)
    80004670:	7a42                	ld	s4,48(sp)
    80004672:	7aa2                	ld	s5,40(sp)
    80004674:	6125                	addi	sp,sp,96
    80004676:	8082                	ret
      if(i == 0)
    80004678:	fc099ce3          	bnez	s3,80004650 <piperead+0xc4>
        i = -1;
    8000467c:	89aa                	mv	s3,a0
    8000467e:	bfc9                	j	80004650 <piperead+0xc4>

0000000080004680 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004680:	1141                	addi	sp,sp,-16
    80004682:	e406                	sd	ra,8(sp)
    80004684:	e022                	sd	s0,0(sp)
    80004686:	0800                	addi	s0,sp,16
    80004688:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000468a:	0035151b          	slliw	a0,a0,0x3
    8000468e:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80004690:	8b89                	andi	a5,a5,2
    80004692:	c399                	beqz	a5,80004698 <flags2perm+0x18>
      perm |= PTE_W;
    80004694:	00456513          	ori	a0,a0,4
    return perm;
}
    80004698:	60a2                	ld	ra,8(sp)
    8000469a:	6402                	ld	s0,0(sp)
    8000469c:	0141                	addi	sp,sp,16
    8000469e:	8082                	ret

00000000800046a0 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800046a0:	de010113          	addi	sp,sp,-544
    800046a4:	20113c23          	sd	ra,536(sp)
    800046a8:	20813823          	sd	s0,528(sp)
    800046ac:	20913423          	sd	s1,520(sp)
    800046b0:	21213023          	sd	s2,512(sp)
    800046b4:	1400                	addi	s0,sp,544
    800046b6:	892a                	mv	s2,a0
    800046b8:	dea43823          	sd	a0,-528(s0)
    800046bc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800046c0:	a54fd0ef          	jal	80001914 <myproc>
    800046c4:	84aa                	mv	s1,a0

  begin_op();
    800046c6:	d8cff0ef          	jal	80003c52 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    800046ca:	854a                	mv	a0,s2
    800046cc:	bacff0ef          	jal	80003a78 <namei>
    800046d0:	cd21                	beqz	a0,80004728 <kexec+0x88>
    800046d2:	fbd2                	sd	s4,496(sp)
    800046d4:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800046d6:	b79fe0ef          	jal	8000324e <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800046da:	04000713          	li	a4,64
    800046de:	4681                	li	a3,0
    800046e0:	e5040613          	addi	a2,s0,-432
    800046e4:	4581                	li	a1,0
    800046e6:	8552                	mv	a0,s4
    800046e8:	ef9fe0ef          	jal	800035e0 <readi>
    800046ec:	04000793          	li	a5,64
    800046f0:	00f51a63          	bne	a0,a5,80004704 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    800046f4:	e5042703          	lw	a4,-432(s0)
    800046f8:	464c47b7          	lui	a5,0x464c4
    800046fc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004700:	02f70863          	beq	a4,a5,80004730 <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004704:	8552                	mv	a0,s4
    80004706:	d53fe0ef          	jal	80003458 <iunlockput>
    end_op();
    8000470a:	db2ff0ef          	jal	80003cbc <end_op>
  }
  return -1;
    8000470e:	557d                	li	a0,-1
    80004710:	7a5e                	ld	s4,496(sp)
}
    80004712:	21813083          	ld	ra,536(sp)
    80004716:	21013403          	ld	s0,528(sp)
    8000471a:	20813483          	ld	s1,520(sp)
    8000471e:	20013903          	ld	s2,512(sp)
    80004722:	22010113          	addi	sp,sp,544
    80004726:	8082                	ret
    end_op();
    80004728:	d94ff0ef          	jal	80003cbc <end_op>
    return -1;
    8000472c:	557d                	li	a0,-1
    8000472e:	b7d5                	j	80004712 <kexec+0x72>
    80004730:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004732:	8526                	mv	a0,s1
    80004734:	ae6fd0ef          	jal	80001a1a <proc_pagetable>
    80004738:	8b2a                	mv	s6,a0
    8000473a:	26050d63          	beqz	a0,800049b4 <kexec+0x314>
    8000473e:	ffce                	sd	s3,504(sp)
    80004740:	f7d6                	sd	s5,488(sp)
    80004742:	efde                	sd	s7,472(sp)
    80004744:	ebe2                	sd	s8,464(sp)
    80004746:	e7e6                	sd	s9,456(sp)
    80004748:	e3ea                	sd	s10,448(sp)
    8000474a:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000474c:	e7042683          	lw	a3,-400(s0)
    80004750:	e8845783          	lhu	a5,-376(s0)
    80004754:	0e078763          	beqz	a5,80004842 <kexec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004758:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000475a:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000475c:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80004760:	6c85                	lui	s9,0x1
    80004762:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004766:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000476a:	6a85                	lui	s5,0x1
    8000476c:	a085                	j	800047cc <kexec+0x12c>
      panic("loadseg: address should exist");
    8000476e:	00004517          	auipc	a0,0x4
    80004772:	e5250513          	addi	a0,a0,-430 # 800085c0 <etext+0x5c0>
    80004776:	868fc0ef          	jal	800007de <panic>
    if(sz - i < PGSIZE)
    8000477a:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000477c:	874a                	mv	a4,s2
    8000477e:	009c06bb          	addw	a3,s8,s1
    80004782:	4581                	li	a1,0
    80004784:	8552                	mv	a0,s4
    80004786:	e5bfe0ef          	jal	800035e0 <readi>
    8000478a:	22a91963          	bne	s2,a0,800049bc <kexec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    8000478e:	009a84bb          	addw	s1,s5,s1
    80004792:	0334f263          	bgeu	s1,s3,800047b6 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80004796:	02049593          	slli	a1,s1,0x20
    8000479a:	9181                	srli	a1,a1,0x20
    8000479c:	95de                	add	a1,a1,s7
    8000479e:	855a                	mv	a0,s6
    800047a0:	85dfc0ef          	jal	80000ffc <walkaddr>
    800047a4:	862a                	mv	a2,a0
    if(pa == 0)
    800047a6:	d561                	beqz	a0,8000476e <kexec+0xce>
    if(sz - i < PGSIZE)
    800047a8:	409987bb          	subw	a5,s3,s1
    800047ac:	893e                	mv	s2,a5
    800047ae:	fcfcf6e3          	bgeu	s9,a5,8000477a <kexec+0xda>
    800047b2:	8956                	mv	s2,s5
    800047b4:	b7d9                	j	8000477a <kexec+0xda>
    sz = sz1;
    800047b6:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800047ba:	2d05                	addiw	s10,s10,1
    800047bc:	e0843783          	ld	a5,-504(s0)
    800047c0:	0387869b          	addiw	a3,a5,56
    800047c4:	e8845783          	lhu	a5,-376(s0)
    800047c8:	06fd5e63          	bge	s10,a5,80004844 <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800047cc:	e0d43423          	sd	a3,-504(s0)
    800047d0:	876e                	mv	a4,s11
    800047d2:	e1840613          	addi	a2,s0,-488
    800047d6:	4581                	li	a1,0
    800047d8:	8552                	mv	a0,s4
    800047da:	e07fe0ef          	jal	800035e0 <readi>
    800047de:	1db51d63          	bne	a0,s11,800049b8 <kexec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    800047e2:	e1842783          	lw	a5,-488(s0)
    800047e6:	4705                	li	a4,1
    800047e8:	fce799e3          	bne	a5,a4,800047ba <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    800047ec:	e4043483          	ld	s1,-448(s0)
    800047f0:	e3843783          	ld	a5,-456(s0)
    800047f4:	1ef4e263          	bltu	s1,a5,800049d8 <kexec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800047f8:	e2843783          	ld	a5,-472(s0)
    800047fc:	94be                	add	s1,s1,a5
    800047fe:	1ef4e063          	bltu	s1,a5,800049de <kexec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80004802:	de843703          	ld	a4,-536(s0)
    80004806:	8ff9                	and	a5,a5,a4
    80004808:	1c079e63          	bnez	a5,800049e4 <kexec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000480c:	e1c42503          	lw	a0,-484(s0)
    80004810:	e71ff0ef          	jal	80004680 <flags2perm>
    80004814:	86aa                	mv	a3,a0
    80004816:	8626                	mv	a2,s1
    80004818:	85ca                	mv	a1,s2
    8000481a:	855a                	mv	a0,s6
    8000481c:	addfc0ef          	jal	800012f8 <uvmalloc>
    80004820:	dea43c23          	sd	a0,-520(s0)
    80004824:	1c050363          	beqz	a0,800049ea <kexec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004828:	e2843b83          	ld	s7,-472(s0)
    8000482c:	e2042c03          	lw	s8,-480(s0)
    80004830:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004834:	00098463          	beqz	s3,8000483c <kexec+0x19c>
    80004838:	4481                	li	s1,0
    8000483a:	bfb1                	j	80004796 <kexec+0xf6>
    sz = sz1;
    8000483c:	df843903          	ld	s2,-520(s0)
    80004840:	bfad                	j	800047ba <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004842:	4901                	li	s2,0
  iunlockput(ip);
    80004844:	8552                	mv	a0,s4
    80004846:	c13fe0ef          	jal	80003458 <iunlockput>
  end_op();
    8000484a:	c72ff0ef          	jal	80003cbc <end_op>
  p = myproc();
    8000484e:	8c6fd0ef          	jal	80001914 <myproc>
    80004852:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004854:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004858:	6985                	lui	s3,0x1
    8000485a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000485c:	99ca                	add	s3,s3,s2
    8000485e:	77fd                	lui	a5,0xfffff
    80004860:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004864:	4691                	li	a3,4
    80004866:	6609                	lui	a2,0x2
    80004868:	964e                	add	a2,a2,s3
    8000486a:	85ce                	mv	a1,s3
    8000486c:	855a                	mv	a0,s6
    8000486e:	a8bfc0ef          	jal	800012f8 <uvmalloc>
    80004872:	8a2a                	mv	s4,a0
    80004874:	e105                	bnez	a0,80004894 <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80004876:	85ce                	mv	a1,s3
    80004878:	855a                	mv	a0,s6
    8000487a:	a24fd0ef          	jal	80001a9e <proc_freepagetable>
  return -1;
    8000487e:	557d                	li	a0,-1
    80004880:	79fe                	ld	s3,504(sp)
    80004882:	7a5e                	ld	s4,496(sp)
    80004884:	7abe                	ld	s5,488(sp)
    80004886:	7b1e                	ld	s6,480(sp)
    80004888:	6bfe                	ld	s7,472(sp)
    8000488a:	6c5e                	ld	s8,464(sp)
    8000488c:	6cbe                	ld	s9,456(sp)
    8000488e:	6d1e                	ld	s10,448(sp)
    80004890:	7dfa                	ld	s11,440(sp)
    80004892:	b541                	j	80004712 <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004894:	75f9                	lui	a1,0xffffe
    80004896:	95aa                	add	a1,a1,a0
    80004898:	855a                	mv	a0,s6
    8000489a:	c41fc0ef          	jal	800014da <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    8000489e:	7bfd                	lui	s7,0xfffff
    800048a0:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    800048a2:	e0043783          	ld	a5,-512(s0)
    800048a6:	6388                	ld	a0,0(a5)
  sp = sz;
    800048a8:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800048aa:	4481                	li	s1,0
    ustack[argc] = sp;
    800048ac:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800048b0:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800048b4:	cd21                	beqz	a0,8000490c <kexec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    800048b6:	d98fc0ef          	jal	80000e4e <strlen>
    800048ba:	0015079b          	addiw	a5,a0,1
    800048be:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800048c2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800048c6:	13796563          	bltu	s2,s7,800049f0 <kexec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800048ca:	e0043d83          	ld	s11,-512(s0)
    800048ce:	000db983          	ld	s3,0(s11)
    800048d2:	854e                	mv	a0,s3
    800048d4:	d7afc0ef          	jal	80000e4e <strlen>
    800048d8:	0015069b          	addiw	a3,a0,1
    800048dc:	864e                	mv	a2,s3
    800048de:	85ca                	mv	a1,s2
    800048e0:	855a                	mv	a0,s6
    800048e2:	d65fc0ef          	jal	80001646 <copyout>
    800048e6:	10054763          	bltz	a0,800049f4 <kexec+0x354>
    ustack[argc] = sp;
    800048ea:	00349793          	slli	a5,s1,0x3
    800048ee:	97e6                	add	a5,a5,s9
    800048f0:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdc698>
  for(argc = 0; argv[argc]; argc++) {
    800048f4:	0485                	addi	s1,s1,1
    800048f6:	008d8793          	addi	a5,s11,8
    800048fa:	e0f43023          	sd	a5,-512(s0)
    800048fe:	008db503          	ld	a0,8(s11)
    80004902:	c509                	beqz	a0,8000490c <kexec+0x26c>
    if(argc >= MAXARG)
    80004904:	fb8499e3          	bne	s1,s8,800048b6 <kexec+0x216>
  sz = sz1;
    80004908:	89d2                	mv	s3,s4
    8000490a:	b7b5                	j	80004876 <kexec+0x1d6>
  ustack[argc] = 0;
    8000490c:	00349793          	slli	a5,s1,0x3
    80004910:	f9078793          	addi	a5,a5,-112
    80004914:	97a2                	add	a5,a5,s0
    80004916:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000491a:	00148693          	addi	a3,s1,1
    8000491e:	068e                	slli	a3,a3,0x3
    80004920:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004924:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004928:	89d2                	mv	s3,s4
  if(sp < stackbase)
    8000492a:	f57966e3          	bltu	s2,s7,80004876 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000492e:	e9040613          	addi	a2,s0,-368
    80004932:	85ca                	mv	a1,s2
    80004934:	855a                	mv	a0,s6
    80004936:	d11fc0ef          	jal	80001646 <copyout>
    8000493a:	f2054ee3          	bltz	a0,80004876 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    8000493e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004942:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004946:	df043783          	ld	a5,-528(s0)
    8000494a:	0007c703          	lbu	a4,0(a5)
    8000494e:	cf11                	beqz	a4,8000496a <kexec+0x2ca>
    80004950:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004952:	02f00693          	li	a3,47
    80004956:	a029                	j	80004960 <kexec+0x2c0>
  for(last=s=path; *s; s++)
    80004958:	0785                	addi	a5,a5,1
    8000495a:	fff7c703          	lbu	a4,-1(a5)
    8000495e:	c711                	beqz	a4,8000496a <kexec+0x2ca>
    if(*s == '/')
    80004960:	fed71ce3          	bne	a4,a3,80004958 <kexec+0x2b8>
      last = s+1;
    80004964:	def43823          	sd	a5,-528(s0)
    80004968:	bfc5                	j	80004958 <kexec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    8000496a:	4641                	li	a2,16
    8000496c:	df043583          	ld	a1,-528(s0)
    80004970:	158a8513          	addi	a0,s5,344
    80004974:	ca4fc0ef          	jal	80000e18 <safestrcpy>
  oldpagetable = p->pagetable;
    80004978:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000497c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004980:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80004984:	058ab783          	ld	a5,88(s5)
    80004988:	e6843703          	ld	a4,-408(s0)
    8000498c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000498e:	058ab783          	ld	a5,88(s5)
    80004992:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004996:	85ea                	mv	a1,s10
    80004998:	906fd0ef          	jal	80001a9e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000499c:	0004851b          	sext.w	a0,s1
    800049a0:	79fe                	ld	s3,504(sp)
    800049a2:	7a5e                	ld	s4,496(sp)
    800049a4:	7abe                	ld	s5,488(sp)
    800049a6:	7b1e                	ld	s6,480(sp)
    800049a8:	6bfe                	ld	s7,472(sp)
    800049aa:	6c5e                	ld	s8,464(sp)
    800049ac:	6cbe                	ld	s9,456(sp)
    800049ae:	6d1e                	ld	s10,448(sp)
    800049b0:	7dfa                	ld	s11,440(sp)
    800049b2:	b385                	j	80004712 <kexec+0x72>
    800049b4:	7b1e                	ld	s6,480(sp)
    800049b6:	b3b9                	j	80004704 <kexec+0x64>
    800049b8:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800049bc:	df843583          	ld	a1,-520(s0)
    800049c0:	855a                	mv	a0,s6
    800049c2:	8dcfd0ef          	jal	80001a9e <proc_freepagetable>
  if(ip){
    800049c6:	79fe                	ld	s3,504(sp)
    800049c8:	7abe                	ld	s5,488(sp)
    800049ca:	7b1e                	ld	s6,480(sp)
    800049cc:	6bfe                	ld	s7,472(sp)
    800049ce:	6c5e                	ld	s8,464(sp)
    800049d0:	6cbe                	ld	s9,456(sp)
    800049d2:	6d1e                	ld	s10,448(sp)
    800049d4:	7dfa                	ld	s11,440(sp)
    800049d6:	b33d                	j	80004704 <kexec+0x64>
    800049d8:	df243c23          	sd	s2,-520(s0)
    800049dc:	b7c5                	j	800049bc <kexec+0x31c>
    800049de:	df243c23          	sd	s2,-520(s0)
    800049e2:	bfe9                	j	800049bc <kexec+0x31c>
    800049e4:	df243c23          	sd	s2,-520(s0)
    800049e8:	bfd1                	j	800049bc <kexec+0x31c>
    800049ea:	df243c23          	sd	s2,-520(s0)
    800049ee:	b7f9                	j	800049bc <kexec+0x31c>
  sz = sz1;
    800049f0:	89d2                	mv	s3,s4
    800049f2:	b551                	j	80004876 <kexec+0x1d6>
    800049f4:	89d2                	mv	s3,s4
    800049f6:	b541                	j	80004876 <kexec+0x1d6>

00000000800049f8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800049f8:	7179                	addi	sp,sp,-48
    800049fa:	f406                	sd	ra,40(sp)
    800049fc:	f022                	sd	s0,32(sp)
    800049fe:	ec26                	sd	s1,24(sp)
    80004a00:	e84a                	sd	s2,16(sp)
    80004a02:	1800                	addi	s0,sp,48
    80004a04:	892e                	mv	s2,a1
    80004a06:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004a08:	fdc40593          	addi	a1,s0,-36
    80004a0c:	e6bfd0ef          	jal	80002876 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004a10:	fdc42703          	lw	a4,-36(s0)
    80004a14:	47bd                	li	a5,15
    80004a16:	02e7e963          	bltu	a5,a4,80004a48 <argfd+0x50>
    80004a1a:	efbfc0ef          	jal	80001914 <myproc>
    80004a1e:	fdc42703          	lw	a4,-36(s0)
    80004a22:	01a70793          	addi	a5,a4,26
    80004a26:	078e                	slli	a5,a5,0x3
    80004a28:	953e                	add	a0,a0,a5
    80004a2a:	611c                	ld	a5,0(a0)
    80004a2c:	c385                	beqz	a5,80004a4c <argfd+0x54>
    return -1;
  if(pfd)
    80004a2e:	00090463          	beqz	s2,80004a36 <argfd+0x3e>
    *pfd = fd;
    80004a32:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004a36:	4501                	li	a0,0
  if(pf)
    80004a38:	c091                	beqz	s1,80004a3c <argfd+0x44>
    *pf = f;
    80004a3a:	e09c                	sd	a5,0(s1)
}
    80004a3c:	70a2                	ld	ra,40(sp)
    80004a3e:	7402                	ld	s0,32(sp)
    80004a40:	64e2                	ld	s1,24(sp)
    80004a42:	6942                	ld	s2,16(sp)
    80004a44:	6145                	addi	sp,sp,48
    80004a46:	8082                	ret
    return -1;
    80004a48:	557d                	li	a0,-1
    80004a4a:	bfcd                	j	80004a3c <argfd+0x44>
    80004a4c:	557d                	li	a0,-1
    80004a4e:	b7fd                	j	80004a3c <argfd+0x44>

0000000080004a50 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004a50:	1101                	addi	sp,sp,-32
    80004a52:	ec06                	sd	ra,24(sp)
    80004a54:	e822                	sd	s0,16(sp)
    80004a56:	e426                	sd	s1,8(sp)
    80004a58:	1000                	addi	s0,sp,32
    80004a5a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004a5c:	eb9fc0ef          	jal	80001914 <myproc>
    80004a60:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004a62:	0d050793          	addi	a5,a0,208
    80004a66:	4501                	li	a0,0
    80004a68:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004a6a:	6398                	ld	a4,0(a5)
    80004a6c:	cb19                	beqz	a4,80004a82 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004a6e:	2505                	addiw	a0,a0,1
    80004a70:	07a1                	addi	a5,a5,8
    80004a72:	fed51ce3          	bne	a0,a3,80004a6a <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004a76:	557d                	li	a0,-1
}
    80004a78:	60e2                	ld	ra,24(sp)
    80004a7a:	6442                	ld	s0,16(sp)
    80004a7c:	64a2                	ld	s1,8(sp)
    80004a7e:	6105                	addi	sp,sp,32
    80004a80:	8082                	ret
      p->ofile[fd] = f;
    80004a82:	01a50793          	addi	a5,a0,26
    80004a86:	078e                	slli	a5,a5,0x3
    80004a88:	963e                	add	a2,a2,a5
    80004a8a:	e204                	sd	s1,0(a2)
      return fd;
    80004a8c:	b7f5                	j	80004a78 <fdalloc+0x28>

0000000080004a8e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004a8e:	715d                	addi	sp,sp,-80
    80004a90:	e486                	sd	ra,72(sp)
    80004a92:	e0a2                	sd	s0,64(sp)
    80004a94:	fc26                	sd	s1,56(sp)
    80004a96:	f84a                	sd	s2,48(sp)
    80004a98:	f44e                	sd	s3,40(sp)
    80004a9a:	ec56                	sd	s5,24(sp)
    80004a9c:	e85a                	sd	s6,16(sp)
    80004a9e:	0880                	addi	s0,sp,80
    80004aa0:	8b2e                	mv	s6,a1
    80004aa2:	89b2                	mv	s3,a2
    80004aa4:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004aa6:	fb040593          	addi	a1,s0,-80
    80004aaa:	fe9fe0ef          	jal	80003a92 <nameiparent>
    80004aae:	84aa                	mv	s1,a0
    80004ab0:	10050a63          	beqz	a0,80004bc4 <create+0x136>
    return 0;

  ilock(dp);
    80004ab4:	f9afe0ef          	jal	8000324e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004ab8:	4601                	li	a2,0
    80004aba:	fb040593          	addi	a1,s0,-80
    80004abe:	8526                	mv	a0,s1
    80004ac0:	d2dfe0ef          	jal	800037ec <dirlookup>
    80004ac4:	8aaa                	mv	s5,a0
    80004ac6:	c129                	beqz	a0,80004b08 <create+0x7a>
    iunlockput(dp);
    80004ac8:	8526                	mv	a0,s1
    80004aca:	98ffe0ef          	jal	80003458 <iunlockput>
    ilock(ip);
    80004ace:	8556                	mv	a0,s5
    80004ad0:	f7efe0ef          	jal	8000324e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004ad4:	4789                	li	a5,2
    80004ad6:	02fb1463          	bne	s6,a5,80004afe <create+0x70>
    80004ada:	044ad783          	lhu	a5,68(s5)
    80004ade:	37f9                	addiw	a5,a5,-2
    80004ae0:	17c2                	slli	a5,a5,0x30
    80004ae2:	93c1                	srli	a5,a5,0x30
    80004ae4:	4705                	li	a4,1
    80004ae6:	00f76c63          	bltu	a4,a5,80004afe <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004aea:	8556                	mv	a0,s5
    80004aec:	60a6                	ld	ra,72(sp)
    80004aee:	6406                	ld	s0,64(sp)
    80004af0:	74e2                	ld	s1,56(sp)
    80004af2:	7942                	ld	s2,48(sp)
    80004af4:	79a2                	ld	s3,40(sp)
    80004af6:	6ae2                	ld	s5,24(sp)
    80004af8:	6b42                	ld	s6,16(sp)
    80004afa:	6161                	addi	sp,sp,80
    80004afc:	8082                	ret
    iunlockput(ip);
    80004afe:	8556                	mv	a0,s5
    80004b00:	959fe0ef          	jal	80003458 <iunlockput>
    return 0;
    80004b04:	4a81                	li	s5,0
    80004b06:	b7d5                	j	80004aea <create+0x5c>
    80004b08:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004b0a:	85da                	mv	a1,s6
    80004b0c:	4088                	lw	a0,0(s1)
    80004b0e:	dd0fe0ef          	jal	800030de <ialloc>
    80004b12:	8a2a                	mv	s4,a0
    80004b14:	cd15                	beqz	a0,80004b50 <create+0xc2>
  ilock(ip);
    80004b16:	f38fe0ef          	jal	8000324e <ilock>
  ip->major = major;
    80004b1a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004b1e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004b22:	4905                	li	s2,1
    80004b24:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004b28:	8552                	mv	a0,s4
    80004b2a:	e70fe0ef          	jal	8000319a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004b2e:	032b0763          	beq	s6,s2,80004b5c <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004b32:	004a2603          	lw	a2,4(s4)
    80004b36:	fb040593          	addi	a1,s0,-80
    80004b3a:	8526                	mv	a0,s1
    80004b3c:	e93fe0ef          	jal	800039ce <dirlink>
    80004b40:	06054563          	bltz	a0,80004baa <create+0x11c>
  iunlockput(dp);
    80004b44:	8526                	mv	a0,s1
    80004b46:	913fe0ef          	jal	80003458 <iunlockput>
  return ip;
    80004b4a:	8ad2                	mv	s5,s4
    80004b4c:	7a02                	ld	s4,32(sp)
    80004b4e:	bf71                	j	80004aea <create+0x5c>
    iunlockput(dp);
    80004b50:	8526                	mv	a0,s1
    80004b52:	907fe0ef          	jal	80003458 <iunlockput>
    return 0;
    80004b56:	8ad2                	mv	s5,s4
    80004b58:	7a02                	ld	s4,32(sp)
    80004b5a:	bf41                	j	80004aea <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004b5c:	004a2603          	lw	a2,4(s4)
    80004b60:	00004597          	auipc	a1,0x4
    80004b64:	a8058593          	addi	a1,a1,-1408 # 800085e0 <etext+0x5e0>
    80004b68:	8552                	mv	a0,s4
    80004b6a:	e65fe0ef          	jal	800039ce <dirlink>
    80004b6e:	02054e63          	bltz	a0,80004baa <create+0x11c>
    80004b72:	40d0                	lw	a2,4(s1)
    80004b74:	00004597          	auipc	a1,0x4
    80004b78:	a7458593          	addi	a1,a1,-1420 # 800085e8 <etext+0x5e8>
    80004b7c:	8552                	mv	a0,s4
    80004b7e:	e51fe0ef          	jal	800039ce <dirlink>
    80004b82:	02054463          	bltz	a0,80004baa <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004b86:	004a2603          	lw	a2,4(s4)
    80004b8a:	fb040593          	addi	a1,s0,-80
    80004b8e:	8526                	mv	a0,s1
    80004b90:	e3ffe0ef          	jal	800039ce <dirlink>
    80004b94:	00054b63          	bltz	a0,80004baa <create+0x11c>
    dp->nlink++;  // for ".."
    80004b98:	04a4d783          	lhu	a5,74(s1)
    80004b9c:	2785                	addiw	a5,a5,1
    80004b9e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ba2:	8526                	mv	a0,s1
    80004ba4:	df6fe0ef          	jal	8000319a <iupdate>
    80004ba8:	bf71                	j	80004b44 <create+0xb6>
  ip->nlink = 0;
    80004baa:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004bae:	8552                	mv	a0,s4
    80004bb0:	deafe0ef          	jal	8000319a <iupdate>
  iunlockput(ip);
    80004bb4:	8552                	mv	a0,s4
    80004bb6:	8a3fe0ef          	jal	80003458 <iunlockput>
  iunlockput(dp);
    80004bba:	8526                	mv	a0,s1
    80004bbc:	89dfe0ef          	jal	80003458 <iunlockput>
  return 0;
    80004bc0:	7a02                	ld	s4,32(sp)
    80004bc2:	b725                	j	80004aea <create+0x5c>
    return 0;
    80004bc4:	8aaa                	mv	s5,a0
    80004bc6:	b715                	j	80004aea <create+0x5c>

0000000080004bc8 <sys_dup>:
{
    80004bc8:	7179                	addi	sp,sp,-48
    80004bca:	f406                	sd	ra,40(sp)
    80004bcc:	f022                	sd	s0,32(sp)
    80004bce:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004bd0:	fd840613          	addi	a2,s0,-40
    80004bd4:	4581                	li	a1,0
    80004bd6:	4501                	li	a0,0
    80004bd8:	e21ff0ef          	jal	800049f8 <argfd>
    return -1;
    80004bdc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004bde:	02054363          	bltz	a0,80004c04 <sys_dup+0x3c>
    80004be2:	ec26                	sd	s1,24(sp)
    80004be4:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004be6:	fd843903          	ld	s2,-40(s0)
    80004bea:	854a                	mv	a0,s2
    80004bec:	e65ff0ef          	jal	80004a50 <fdalloc>
    80004bf0:	84aa                	mv	s1,a0
    return -1;
    80004bf2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004bf4:	00054d63          	bltz	a0,80004c0e <sys_dup+0x46>
  filedup(f);
    80004bf8:	854a                	mv	a0,s2
    80004bfa:	c24ff0ef          	jal	8000401e <filedup>
  return fd;
    80004bfe:	87a6                	mv	a5,s1
    80004c00:	64e2                	ld	s1,24(sp)
    80004c02:	6942                	ld	s2,16(sp)
}
    80004c04:	853e                	mv	a0,a5
    80004c06:	70a2                	ld	ra,40(sp)
    80004c08:	7402                	ld	s0,32(sp)
    80004c0a:	6145                	addi	sp,sp,48
    80004c0c:	8082                	ret
    80004c0e:	64e2                	ld	s1,24(sp)
    80004c10:	6942                	ld	s2,16(sp)
    80004c12:	bfcd                	j	80004c04 <sys_dup+0x3c>

0000000080004c14 <sys_read>:
{
    80004c14:	7179                	addi	sp,sp,-48
    80004c16:	f406                	sd	ra,40(sp)
    80004c18:	f022                	sd	s0,32(sp)
    80004c1a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004c1c:	fd840593          	addi	a1,s0,-40
    80004c20:	4505                	li	a0,1
    80004c22:	c71fd0ef          	jal	80002892 <argaddr>
  argint(2, &n);
    80004c26:	fe440593          	addi	a1,s0,-28
    80004c2a:	4509                	li	a0,2
    80004c2c:	c4bfd0ef          	jal	80002876 <argint>
  if(argfd(0, 0, &f) < 0)
    80004c30:	fe840613          	addi	a2,s0,-24
    80004c34:	4581                	li	a1,0
    80004c36:	4501                	li	a0,0
    80004c38:	dc1ff0ef          	jal	800049f8 <argfd>
    80004c3c:	87aa                	mv	a5,a0
    return -1;
    80004c3e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c40:	0007ca63          	bltz	a5,80004c54 <sys_read+0x40>
  return fileread(f, p, n);
    80004c44:	fe442603          	lw	a2,-28(s0)
    80004c48:	fd843583          	ld	a1,-40(s0)
    80004c4c:	fe843503          	ld	a0,-24(s0)
    80004c50:	d34ff0ef          	jal	80004184 <fileread>
}
    80004c54:	70a2                	ld	ra,40(sp)
    80004c56:	7402                	ld	s0,32(sp)
    80004c58:	6145                	addi	sp,sp,48
    80004c5a:	8082                	ret

0000000080004c5c <sys_write>:
{
    80004c5c:	7179                	addi	sp,sp,-48
    80004c5e:	f406                	sd	ra,40(sp)
    80004c60:	f022                	sd	s0,32(sp)
    80004c62:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004c64:	fd840593          	addi	a1,s0,-40
    80004c68:	4505                	li	a0,1
    80004c6a:	c29fd0ef          	jal	80002892 <argaddr>
  argint(2, &n);
    80004c6e:	fe440593          	addi	a1,s0,-28
    80004c72:	4509                	li	a0,2
    80004c74:	c03fd0ef          	jal	80002876 <argint>
  if(argfd(0, 0, &f) < 0)
    80004c78:	fe840613          	addi	a2,s0,-24
    80004c7c:	4581                	li	a1,0
    80004c7e:	4501                	li	a0,0
    80004c80:	d79ff0ef          	jal	800049f8 <argfd>
    80004c84:	87aa                	mv	a5,a0
    return -1;
    80004c86:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c88:	0007ca63          	bltz	a5,80004c9c <sys_write+0x40>
  return filewrite(f, p, n);
    80004c8c:	fe442603          	lw	a2,-28(s0)
    80004c90:	fd843583          	ld	a1,-40(s0)
    80004c94:	fe843503          	ld	a0,-24(s0)
    80004c98:	daaff0ef          	jal	80004242 <filewrite>
}
    80004c9c:	70a2                	ld	ra,40(sp)
    80004c9e:	7402                	ld	s0,32(sp)
    80004ca0:	6145                	addi	sp,sp,48
    80004ca2:	8082                	ret

0000000080004ca4 <sys_close>:
{
    80004ca4:	1101                	addi	sp,sp,-32
    80004ca6:	ec06                	sd	ra,24(sp)
    80004ca8:	e822                	sd	s0,16(sp)
    80004caa:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004cac:	fe040613          	addi	a2,s0,-32
    80004cb0:	fec40593          	addi	a1,s0,-20
    80004cb4:	4501                	li	a0,0
    80004cb6:	d43ff0ef          	jal	800049f8 <argfd>
    return -1;
    80004cba:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004cbc:	02054063          	bltz	a0,80004cdc <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004cc0:	c55fc0ef          	jal	80001914 <myproc>
    80004cc4:	fec42783          	lw	a5,-20(s0)
    80004cc8:	07e9                	addi	a5,a5,26
    80004cca:	078e                	slli	a5,a5,0x3
    80004ccc:	953e                	add	a0,a0,a5
    80004cce:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004cd2:	fe043503          	ld	a0,-32(s0)
    80004cd6:	b8eff0ef          	jal	80004064 <fileclose>
  return 0;
    80004cda:	4781                	li	a5,0
}
    80004cdc:	853e                	mv	a0,a5
    80004cde:	60e2                	ld	ra,24(sp)
    80004ce0:	6442                	ld	s0,16(sp)
    80004ce2:	6105                	addi	sp,sp,32
    80004ce4:	8082                	ret

0000000080004ce6 <sys_fstat>:
{
    80004ce6:	1101                	addi	sp,sp,-32
    80004ce8:	ec06                	sd	ra,24(sp)
    80004cea:	e822                	sd	s0,16(sp)
    80004cec:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004cee:	fe040593          	addi	a1,s0,-32
    80004cf2:	4505                	li	a0,1
    80004cf4:	b9ffd0ef          	jal	80002892 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004cf8:	fe840613          	addi	a2,s0,-24
    80004cfc:	4581                	li	a1,0
    80004cfe:	4501                	li	a0,0
    80004d00:	cf9ff0ef          	jal	800049f8 <argfd>
    80004d04:	87aa                	mv	a5,a0
    return -1;
    80004d06:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004d08:	0007c863          	bltz	a5,80004d18 <sys_fstat+0x32>
  return filestat(f, st);
    80004d0c:	fe043583          	ld	a1,-32(s0)
    80004d10:	fe843503          	ld	a0,-24(s0)
    80004d14:	c0eff0ef          	jal	80004122 <filestat>
}
    80004d18:	60e2                	ld	ra,24(sp)
    80004d1a:	6442                	ld	s0,16(sp)
    80004d1c:	6105                	addi	sp,sp,32
    80004d1e:	8082                	ret

0000000080004d20 <sys_link>:
{
    80004d20:	7169                	addi	sp,sp,-304
    80004d22:	f606                	sd	ra,296(sp)
    80004d24:	f222                	sd	s0,288(sp)
    80004d26:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004d28:	08000613          	li	a2,128
    80004d2c:	ed040593          	addi	a1,s0,-304
    80004d30:	4501                	li	a0,0
    80004d32:	b7dfd0ef          	jal	800028ae <argstr>
    return -1;
    80004d36:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004d38:	0c054e63          	bltz	a0,80004e14 <sys_link+0xf4>
    80004d3c:	08000613          	li	a2,128
    80004d40:	f5040593          	addi	a1,s0,-176
    80004d44:	4505                	li	a0,1
    80004d46:	b69fd0ef          	jal	800028ae <argstr>
    return -1;
    80004d4a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004d4c:	0c054463          	bltz	a0,80004e14 <sys_link+0xf4>
    80004d50:	ee26                	sd	s1,280(sp)
  begin_op();
    80004d52:	f01fe0ef          	jal	80003c52 <begin_op>
  if((ip = namei(old)) == 0){
    80004d56:	ed040513          	addi	a0,s0,-304
    80004d5a:	d1ffe0ef          	jal	80003a78 <namei>
    80004d5e:	84aa                	mv	s1,a0
    80004d60:	c53d                	beqz	a0,80004dce <sys_link+0xae>
  ilock(ip);
    80004d62:	cecfe0ef          	jal	8000324e <ilock>
  if(ip->type == T_DIR){
    80004d66:	04449703          	lh	a4,68(s1)
    80004d6a:	4785                	li	a5,1
    80004d6c:	06f70663          	beq	a4,a5,80004dd8 <sys_link+0xb8>
    80004d70:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004d72:	04a4d783          	lhu	a5,74(s1)
    80004d76:	2785                	addiw	a5,a5,1
    80004d78:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d7c:	8526                	mv	a0,s1
    80004d7e:	c1cfe0ef          	jal	8000319a <iupdate>
  iunlock(ip);
    80004d82:	8526                	mv	a0,s1
    80004d84:	d78fe0ef          	jal	800032fc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004d88:	fd040593          	addi	a1,s0,-48
    80004d8c:	f5040513          	addi	a0,s0,-176
    80004d90:	d03fe0ef          	jal	80003a92 <nameiparent>
    80004d94:	892a                	mv	s2,a0
    80004d96:	cd21                	beqz	a0,80004dee <sys_link+0xce>
  ilock(dp);
    80004d98:	cb6fe0ef          	jal	8000324e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004d9c:	00092703          	lw	a4,0(s2)
    80004da0:	409c                	lw	a5,0(s1)
    80004da2:	04f71363          	bne	a4,a5,80004de8 <sys_link+0xc8>
    80004da6:	40d0                	lw	a2,4(s1)
    80004da8:	fd040593          	addi	a1,s0,-48
    80004dac:	854a                	mv	a0,s2
    80004dae:	c21fe0ef          	jal	800039ce <dirlink>
    80004db2:	02054b63          	bltz	a0,80004de8 <sys_link+0xc8>
  iunlockput(dp);
    80004db6:	854a                	mv	a0,s2
    80004db8:	ea0fe0ef          	jal	80003458 <iunlockput>
  iput(ip);
    80004dbc:	8526                	mv	a0,s1
    80004dbe:	e12fe0ef          	jal	800033d0 <iput>
  end_op();
    80004dc2:	efbfe0ef          	jal	80003cbc <end_op>
  return 0;
    80004dc6:	4781                	li	a5,0
    80004dc8:	64f2                	ld	s1,280(sp)
    80004dca:	6952                	ld	s2,272(sp)
    80004dcc:	a0a1                	j	80004e14 <sys_link+0xf4>
    end_op();
    80004dce:	eeffe0ef          	jal	80003cbc <end_op>
    return -1;
    80004dd2:	57fd                	li	a5,-1
    80004dd4:	64f2                	ld	s1,280(sp)
    80004dd6:	a83d                	j	80004e14 <sys_link+0xf4>
    iunlockput(ip);
    80004dd8:	8526                	mv	a0,s1
    80004dda:	e7efe0ef          	jal	80003458 <iunlockput>
    end_op();
    80004dde:	edffe0ef          	jal	80003cbc <end_op>
    return -1;
    80004de2:	57fd                	li	a5,-1
    80004de4:	64f2                	ld	s1,280(sp)
    80004de6:	a03d                	j	80004e14 <sys_link+0xf4>
    iunlockput(dp);
    80004de8:	854a                	mv	a0,s2
    80004dea:	e6efe0ef          	jal	80003458 <iunlockput>
  ilock(ip);
    80004dee:	8526                	mv	a0,s1
    80004df0:	c5efe0ef          	jal	8000324e <ilock>
  ip->nlink--;
    80004df4:	04a4d783          	lhu	a5,74(s1)
    80004df8:	37fd                	addiw	a5,a5,-1
    80004dfa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004dfe:	8526                	mv	a0,s1
    80004e00:	b9afe0ef          	jal	8000319a <iupdate>
  iunlockput(ip);
    80004e04:	8526                	mv	a0,s1
    80004e06:	e52fe0ef          	jal	80003458 <iunlockput>
  end_op();
    80004e0a:	eb3fe0ef          	jal	80003cbc <end_op>
  return -1;
    80004e0e:	57fd                	li	a5,-1
    80004e10:	64f2                	ld	s1,280(sp)
    80004e12:	6952                	ld	s2,272(sp)
}
    80004e14:	853e                	mv	a0,a5
    80004e16:	70b2                	ld	ra,296(sp)
    80004e18:	7412                	ld	s0,288(sp)
    80004e1a:	6155                	addi	sp,sp,304
    80004e1c:	8082                	ret

0000000080004e1e <sys_unlink>:
{
    80004e1e:	7111                	addi	sp,sp,-256
    80004e20:	fd86                	sd	ra,248(sp)
    80004e22:	f9a2                	sd	s0,240(sp)
    80004e24:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80004e26:	08000613          	li	a2,128
    80004e2a:	f2040593          	addi	a1,s0,-224
    80004e2e:	4501                	li	a0,0
    80004e30:	a7ffd0ef          	jal	800028ae <argstr>
    80004e34:	16054663          	bltz	a0,80004fa0 <sys_unlink+0x182>
    80004e38:	f5a6                	sd	s1,232(sp)
  begin_op();
    80004e3a:	e19fe0ef          	jal	80003c52 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004e3e:	fa040593          	addi	a1,s0,-96
    80004e42:	f2040513          	addi	a0,s0,-224
    80004e46:	c4dfe0ef          	jal	80003a92 <nameiparent>
    80004e4a:	84aa                	mv	s1,a0
    80004e4c:	c955                	beqz	a0,80004f00 <sys_unlink+0xe2>
  ilock(dp);
    80004e4e:	c00fe0ef          	jal	8000324e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004e52:	00003597          	auipc	a1,0x3
    80004e56:	78e58593          	addi	a1,a1,1934 # 800085e0 <etext+0x5e0>
    80004e5a:	fa040513          	addi	a0,s0,-96
    80004e5e:	979fe0ef          	jal	800037d6 <namecmp>
    80004e62:	12050463          	beqz	a0,80004f8a <sys_unlink+0x16c>
    80004e66:	00003597          	auipc	a1,0x3
    80004e6a:	78258593          	addi	a1,a1,1922 # 800085e8 <etext+0x5e8>
    80004e6e:	fa040513          	addi	a0,s0,-96
    80004e72:	965fe0ef          	jal	800037d6 <namecmp>
    80004e76:	10050a63          	beqz	a0,80004f8a <sys_unlink+0x16c>
    80004e7a:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004e7c:	f1c40613          	addi	a2,s0,-228
    80004e80:	fa040593          	addi	a1,s0,-96
    80004e84:	8526                	mv	a0,s1
    80004e86:	967fe0ef          	jal	800037ec <dirlookup>
    80004e8a:	892a                	mv	s2,a0
    80004e8c:	0e050e63          	beqz	a0,80004f88 <sys_unlink+0x16a>
    80004e90:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004e92:	bbcfe0ef          	jal	8000324e <ilock>
  if(ip->nlink < 1)
    80004e96:	04a91783          	lh	a5,74(s2)
    80004e9a:	06f05863          	blez	a5,80004f0a <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004e9e:	04491703          	lh	a4,68(s2)
    80004ea2:	4785                	li	a5,1
    80004ea4:	06f70b63          	beq	a4,a5,80004f1a <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    80004ea8:	fb040993          	addi	s3,s0,-80
    80004eac:	4641                	li	a2,16
    80004eae:	4581                	li	a1,0
    80004eb0:	854e                	mv	a0,s3
    80004eb2:	e15fb0ef          	jal	80000cc6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004eb6:	4741                	li	a4,16
    80004eb8:	f1c42683          	lw	a3,-228(s0)
    80004ebc:	864e                	mv	a2,s3
    80004ebe:	4581                	li	a1,0
    80004ec0:	8526                	mv	a0,s1
    80004ec2:	811fe0ef          	jal	800036d2 <writei>
    80004ec6:	47c1                	li	a5,16
    80004ec8:	08f51f63          	bne	a0,a5,80004f66 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    80004ecc:	04491703          	lh	a4,68(s2)
    80004ed0:	4785                	li	a5,1
    80004ed2:	0af70263          	beq	a4,a5,80004f76 <sys_unlink+0x158>
  iunlockput(dp);
    80004ed6:	8526                	mv	a0,s1
    80004ed8:	d80fe0ef          	jal	80003458 <iunlockput>
  ip->nlink--;
    80004edc:	04a95783          	lhu	a5,74(s2)
    80004ee0:	37fd                	addiw	a5,a5,-1
    80004ee2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ee6:	854a                	mv	a0,s2
    80004ee8:	ab2fe0ef          	jal	8000319a <iupdate>
  iunlockput(ip);
    80004eec:	854a                	mv	a0,s2
    80004eee:	d6afe0ef          	jal	80003458 <iunlockput>
  end_op();
    80004ef2:	dcbfe0ef          	jal	80003cbc <end_op>
  return 0;
    80004ef6:	4501                	li	a0,0
    80004ef8:	74ae                	ld	s1,232(sp)
    80004efa:	790e                	ld	s2,224(sp)
    80004efc:	69ee                	ld	s3,216(sp)
    80004efe:	a869                	j	80004f98 <sys_unlink+0x17a>
    end_op();
    80004f00:	dbdfe0ef          	jal	80003cbc <end_op>
    return -1;
    80004f04:	557d                	li	a0,-1
    80004f06:	74ae                	ld	s1,232(sp)
    80004f08:	a841                	j	80004f98 <sys_unlink+0x17a>
    80004f0a:	e9d2                	sd	s4,208(sp)
    80004f0c:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004f0e:	00003517          	auipc	a0,0x3
    80004f12:	6e250513          	addi	a0,a0,1762 # 800085f0 <etext+0x5f0>
    80004f16:	8c9fb0ef          	jal	800007de <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004f1a:	04c92703          	lw	a4,76(s2)
    80004f1e:	02000793          	li	a5,32
    80004f22:	f8e7f3e3          	bgeu	a5,a4,80004ea8 <sys_unlink+0x8a>
    80004f26:	e9d2                	sd	s4,208(sp)
    80004f28:	e5d6                	sd	s5,200(sp)
    80004f2a:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f2c:	f0840a93          	addi	s5,s0,-248
    80004f30:	4a41                	li	s4,16
    80004f32:	8752                	mv	a4,s4
    80004f34:	86ce                	mv	a3,s3
    80004f36:	8656                	mv	a2,s5
    80004f38:	4581                	li	a1,0
    80004f3a:	854a                	mv	a0,s2
    80004f3c:	ea4fe0ef          	jal	800035e0 <readi>
    80004f40:	01451d63          	bne	a0,s4,80004f5a <sys_unlink+0x13c>
    if(de.inum != 0)
    80004f44:	f0845783          	lhu	a5,-248(s0)
    80004f48:	efb1                	bnez	a5,80004fa4 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004f4a:	29c1                	addiw	s3,s3,16
    80004f4c:	04c92783          	lw	a5,76(s2)
    80004f50:	fef9e1e3          	bltu	s3,a5,80004f32 <sys_unlink+0x114>
    80004f54:	6a4e                	ld	s4,208(sp)
    80004f56:	6aae                	ld	s5,200(sp)
    80004f58:	bf81                	j	80004ea8 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004f5a:	00003517          	auipc	a0,0x3
    80004f5e:	6ae50513          	addi	a0,a0,1710 # 80008608 <etext+0x608>
    80004f62:	87dfb0ef          	jal	800007de <panic>
    80004f66:	e9d2                	sd	s4,208(sp)
    80004f68:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004f6a:	00003517          	auipc	a0,0x3
    80004f6e:	6b650513          	addi	a0,a0,1718 # 80008620 <etext+0x620>
    80004f72:	86dfb0ef          	jal	800007de <panic>
    dp->nlink--;
    80004f76:	04a4d783          	lhu	a5,74(s1)
    80004f7a:	37fd                	addiw	a5,a5,-1
    80004f7c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004f80:	8526                	mv	a0,s1
    80004f82:	a18fe0ef          	jal	8000319a <iupdate>
    80004f86:	bf81                	j	80004ed6 <sys_unlink+0xb8>
    80004f88:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004f8a:	8526                	mv	a0,s1
    80004f8c:	cccfe0ef          	jal	80003458 <iunlockput>
  end_op();
    80004f90:	d2dfe0ef          	jal	80003cbc <end_op>
  return -1;
    80004f94:	557d                	li	a0,-1
    80004f96:	74ae                	ld	s1,232(sp)
}
    80004f98:	70ee                	ld	ra,248(sp)
    80004f9a:	744e                	ld	s0,240(sp)
    80004f9c:	6111                	addi	sp,sp,256
    80004f9e:	8082                	ret
    return -1;
    80004fa0:	557d                	li	a0,-1
    80004fa2:	bfdd                	j	80004f98 <sys_unlink+0x17a>
    iunlockput(ip);
    80004fa4:	854a                	mv	a0,s2
    80004fa6:	cb2fe0ef          	jal	80003458 <iunlockput>
    goto bad;
    80004faa:	790e                	ld	s2,224(sp)
    80004fac:	69ee                	ld	s3,216(sp)
    80004fae:	6a4e                	ld	s4,208(sp)
    80004fb0:	6aae                	ld	s5,200(sp)
    80004fb2:	bfe1                	j	80004f8a <sys_unlink+0x16c>

0000000080004fb4 <sys_open>:

uint64
sys_open(void)
{
    80004fb4:	7131                	addi	sp,sp,-192
    80004fb6:	fd06                	sd	ra,184(sp)
    80004fb8:	f922                	sd	s0,176(sp)
    80004fba:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004fbc:	f4c40593          	addi	a1,s0,-180
    80004fc0:	4505                	li	a0,1
    80004fc2:	8b5fd0ef          	jal	80002876 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004fc6:	08000613          	li	a2,128
    80004fca:	f5040593          	addi	a1,s0,-176
    80004fce:	4501                	li	a0,0
    80004fd0:	8dffd0ef          	jal	800028ae <argstr>
    80004fd4:	87aa                	mv	a5,a0
    return -1;
    80004fd6:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004fd8:	0a07c363          	bltz	a5,8000507e <sys_open+0xca>
    80004fdc:	f526                	sd	s1,168(sp)

  begin_op();
    80004fde:	c75fe0ef          	jal	80003c52 <begin_op>

  if(omode & O_CREATE){
    80004fe2:	f4c42783          	lw	a5,-180(s0)
    80004fe6:	2007f793          	andi	a5,a5,512
    80004fea:	c3dd                	beqz	a5,80005090 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004fec:	4681                	li	a3,0
    80004fee:	4601                	li	a2,0
    80004ff0:	4589                	li	a1,2
    80004ff2:	f5040513          	addi	a0,s0,-176
    80004ff6:	a99ff0ef          	jal	80004a8e <create>
    80004ffa:	84aa                	mv	s1,a0
    if(ip == 0){
    80004ffc:	c549                	beqz	a0,80005086 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ffe:	04449703          	lh	a4,68(s1)
    80005002:	478d                	li	a5,3
    80005004:	00f71763          	bne	a4,a5,80005012 <sys_open+0x5e>
    80005008:	0464d703          	lhu	a4,70(s1)
    8000500c:	47a5                	li	a5,9
    8000500e:	0ae7ee63          	bltu	a5,a4,800050ca <sys_open+0x116>
    80005012:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005014:	fadfe0ef          	jal	80003fc0 <filealloc>
    80005018:	892a                	mv	s2,a0
    8000501a:	c561                	beqz	a0,800050e2 <sys_open+0x12e>
    8000501c:	ed4e                	sd	s3,152(sp)
    8000501e:	a33ff0ef          	jal	80004a50 <fdalloc>
    80005022:	89aa                	mv	s3,a0
    80005024:	0a054b63          	bltz	a0,800050da <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005028:	04449703          	lh	a4,68(s1)
    8000502c:	478d                	li	a5,3
    8000502e:	0cf70363          	beq	a4,a5,800050f4 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005032:	4789                	li	a5,2
    80005034:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005038:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000503c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005040:	f4c42783          	lw	a5,-180(s0)
    80005044:	0017f713          	andi	a4,a5,1
    80005048:	00174713          	xori	a4,a4,1
    8000504c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005050:	0037f713          	andi	a4,a5,3
    80005054:	00e03733          	snez	a4,a4
    80005058:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000505c:	4007f793          	andi	a5,a5,1024
    80005060:	c791                	beqz	a5,8000506c <sys_open+0xb8>
    80005062:	04449703          	lh	a4,68(s1)
    80005066:	4789                	li	a5,2
    80005068:	08f70d63          	beq	a4,a5,80005102 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    8000506c:	8526                	mv	a0,s1
    8000506e:	a8efe0ef          	jal	800032fc <iunlock>
  end_op();
    80005072:	c4bfe0ef          	jal	80003cbc <end_op>

  return fd;
    80005076:	854e                	mv	a0,s3
    80005078:	74aa                	ld	s1,168(sp)
    8000507a:	790a                	ld	s2,160(sp)
    8000507c:	69ea                	ld	s3,152(sp)
}
    8000507e:	70ea                	ld	ra,184(sp)
    80005080:	744a                	ld	s0,176(sp)
    80005082:	6129                	addi	sp,sp,192
    80005084:	8082                	ret
      end_op();
    80005086:	c37fe0ef          	jal	80003cbc <end_op>
      return -1;
    8000508a:	557d                	li	a0,-1
    8000508c:	74aa                	ld	s1,168(sp)
    8000508e:	bfc5                	j	8000507e <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80005090:	f5040513          	addi	a0,s0,-176
    80005094:	9e5fe0ef          	jal	80003a78 <namei>
    80005098:	84aa                	mv	s1,a0
    8000509a:	c11d                	beqz	a0,800050c0 <sys_open+0x10c>
    ilock(ip);
    8000509c:	9b2fe0ef          	jal	8000324e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800050a0:	04449703          	lh	a4,68(s1)
    800050a4:	4785                	li	a5,1
    800050a6:	f4f71ce3          	bne	a4,a5,80004ffe <sys_open+0x4a>
    800050aa:	f4c42783          	lw	a5,-180(s0)
    800050ae:	d3b5                	beqz	a5,80005012 <sys_open+0x5e>
      iunlockput(ip);
    800050b0:	8526                	mv	a0,s1
    800050b2:	ba6fe0ef          	jal	80003458 <iunlockput>
      end_op();
    800050b6:	c07fe0ef          	jal	80003cbc <end_op>
      return -1;
    800050ba:	557d                	li	a0,-1
    800050bc:	74aa                	ld	s1,168(sp)
    800050be:	b7c1                	j	8000507e <sys_open+0xca>
      end_op();
    800050c0:	bfdfe0ef          	jal	80003cbc <end_op>
      return -1;
    800050c4:	557d                	li	a0,-1
    800050c6:	74aa                	ld	s1,168(sp)
    800050c8:	bf5d                	j	8000507e <sys_open+0xca>
    iunlockput(ip);
    800050ca:	8526                	mv	a0,s1
    800050cc:	b8cfe0ef          	jal	80003458 <iunlockput>
    end_op();
    800050d0:	bedfe0ef          	jal	80003cbc <end_op>
    return -1;
    800050d4:	557d                	li	a0,-1
    800050d6:	74aa                	ld	s1,168(sp)
    800050d8:	b75d                	j	8000507e <sys_open+0xca>
      fileclose(f);
    800050da:	854a                	mv	a0,s2
    800050dc:	f89fe0ef          	jal	80004064 <fileclose>
    800050e0:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800050e2:	8526                	mv	a0,s1
    800050e4:	b74fe0ef          	jal	80003458 <iunlockput>
    end_op();
    800050e8:	bd5fe0ef          	jal	80003cbc <end_op>
    return -1;
    800050ec:	557d                	li	a0,-1
    800050ee:	74aa                	ld	s1,168(sp)
    800050f0:	790a                	ld	s2,160(sp)
    800050f2:	b771                	j	8000507e <sys_open+0xca>
    f->type = FD_DEVICE;
    800050f4:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800050f8:	04649783          	lh	a5,70(s1)
    800050fc:	02f91223          	sh	a5,36(s2)
    80005100:	bf35                	j	8000503c <sys_open+0x88>
    itrunc(ip);
    80005102:	8526                	mv	a0,s1
    80005104:	a38fe0ef          	jal	8000333c <itrunc>
    80005108:	b795                	j	8000506c <sys_open+0xb8>

000000008000510a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000510a:	7175                	addi	sp,sp,-144
    8000510c:	e506                	sd	ra,136(sp)
    8000510e:	e122                	sd	s0,128(sp)
    80005110:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005112:	b41fe0ef          	jal	80003c52 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005116:	08000613          	li	a2,128
    8000511a:	f7040593          	addi	a1,s0,-144
    8000511e:	4501                	li	a0,0
    80005120:	f8efd0ef          	jal	800028ae <argstr>
    80005124:	02054363          	bltz	a0,8000514a <sys_mkdir+0x40>
    80005128:	4681                	li	a3,0
    8000512a:	4601                	li	a2,0
    8000512c:	4585                	li	a1,1
    8000512e:	f7040513          	addi	a0,s0,-144
    80005132:	95dff0ef          	jal	80004a8e <create>
    80005136:	c911                	beqz	a0,8000514a <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005138:	b20fe0ef          	jal	80003458 <iunlockput>
  end_op();
    8000513c:	b81fe0ef          	jal	80003cbc <end_op>
  return 0;
    80005140:	4501                	li	a0,0
}
    80005142:	60aa                	ld	ra,136(sp)
    80005144:	640a                	ld	s0,128(sp)
    80005146:	6149                	addi	sp,sp,144
    80005148:	8082                	ret
    end_op();
    8000514a:	b73fe0ef          	jal	80003cbc <end_op>
    return -1;
    8000514e:	557d                	li	a0,-1
    80005150:	bfcd                	j	80005142 <sys_mkdir+0x38>

0000000080005152 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005152:	7135                	addi	sp,sp,-160
    80005154:	ed06                	sd	ra,152(sp)
    80005156:	e922                	sd	s0,144(sp)
    80005158:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000515a:	af9fe0ef          	jal	80003c52 <begin_op>
  argint(1, &major);
    8000515e:	f6c40593          	addi	a1,s0,-148
    80005162:	4505                	li	a0,1
    80005164:	f12fd0ef          	jal	80002876 <argint>
  argint(2, &minor);
    80005168:	f6840593          	addi	a1,s0,-152
    8000516c:	4509                	li	a0,2
    8000516e:	f08fd0ef          	jal	80002876 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005172:	08000613          	li	a2,128
    80005176:	f7040593          	addi	a1,s0,-144
    8000517a:	4501                	li	a0,0
    8000517c:	f32fd0ef          	jal	800028ae <argstr>
    80005180:	02054563          	bltz	a0,800051aa <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005184:	f6841683          	lh	a3,-152(s0)
    80005188:	f6c41603          	lh	a2,-148(s0)
    8000518c:	458d                	li	a1,3
    8000518e:	f7040513          	addi	a0,s0,-144
    80005192:	8fdff0ef          	jal	80004a8e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005196:	c911                	beqz	a0,800051aa <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005198:	ac0fe0ef          	jal	80003458 <iunlockput>
  end_op();
    8000519c:	b21fe0ef          	jal	80003cbc <end_op>
  return 0;
    800051a0:	4501                	li	a0,0
}
    800051a2:	60ea                	ld	ra,152(sp)
    800051a4:	644a                	ld	s0,144(sp)
    800051a6:	610d                	addi	sp,sp,160
    800051a8:	8082                	ret
    end_op();
    800051aa:	b13fe0ef          	jal	80003cbc <end_op>
    return -1;
    800051ae:	557d                	li	a0,-1
    800051b0:	bfcd                	j	800051a2 <sys_mknod+0x50>

00000000800051b2 <sys_chdir>:

uint64
sys_chdir(void)
{
    800051b2:	7135                	addi	sp,sp,-160
    800051b4:	ed06                	sd	ra,152(sp)
    800051b6:	e922                	sd	s0,144(sp)
    800051b8:	e14a                	sd	s2,128(sp)
    800051ba:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800051bc:	f58fc0ef          	jal	80001914 <myproc>
    800051c0:	892a                	mv	s2,a0
  
  begin_op();
    800051c2:	a91fe0ef          	jal	80003c52 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800051c6:	08000613          	li	a2,128
    800051ca:	f6040593          	addi	a1,s0,-160
    800051ce:	4501                	li	a0,0
    800051d0:	edefd0ef          	jal	800028ae <argstr>
    800051d4:	04054363          	bltz	a0,8000521a <sys_chdir+0x68>
    800051d8:	e526                	sd	s1,136(sp)
    800051da:	f6040513          	addi	a0,s0,-160
    800051de:	89bfe0ef          	jal	80003a78 <namei>
    800051e2:	84aa                	mv	s1,a0
    800051e4:	c915                	beqz	a0,80005218 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800051e6:	868fe0ef          	jal	8000324e <ilock>
  if(ip->type != T_DIR){
    800051ea:	04449703          	lh	a4,68(s1)
    800051ee:	4785                	li	a5,1
    800051f0:	02f71963          	bne	a4,a5,80005222 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800051f4:	8526                	mv	a0,s1
    800051f6:	906fe0ef          	jal	800032fc <iunlock>
  iput(p->cwd);
    800051fa:	15093503          	ld	a0,336(s2)
    800051fe:	9d2fe0ef          	jal	800033d0 <iput>
  end_op();
    80005202:	abbfe0ef          	jal	80003cbc <end_op>
  p->cwd = ip;
    80005206:	14993823          	sd	s1,336(s2)
  return 0;
    8000520a:	4501                	li	a0,0
    8000520c:	64aa                	ld	s1,136(sp)
}
    8000520e:	60ea                	ld	ra,152(sp)
    80005210:	644a                	ld	s0,144(sp)
    80005212:	690a                	ld	s2,128(sp)
    80005214:	610d                	addi	sp,sp,160
    80005216:	8082                	ret
    80005218:	64aa                	ld	s1,136(sp)
    end_op();
    8000521a:	aa3fe0ef          	jal	80003cbc <end_op>
    return -1;
    8000521e:	557d                	li	a0,-1
    80005220:	b7fd                	j	8000520e <sys_chdir+0x5c>
    iunlockput(ip);
    80005222:	8526                	mv	a0,s1
    80005224:	a34fe0ef          	jal	80003458 <iunlockput>
    end_op();
    80005228:	a95fe0ef          	jal	80003cbc <end_op>
    return -1;
    8000522c:	557d                	li	a0,-1
    8000522e:	64aa                	ld	s1,136(sp)
    80005230:	bff9                	j	8000520e <sys_chdir+0x5c>

0000000080005232 <sys_exec>:

uint64
sys_exec(void)
{
    80005232:	7105                	addi	sp,sp,-480
    80005234:	ef86                	sd	ra,472(sp)
    80005236:	eba2                	sd	s0,464(sp)
    80005238:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000523a:	e2840593          	addi	a1,s0,-472
    8000523e:	4505                	li	a0,1
    80005240:	e52fd0ef          	jal	80002892 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005244:	08000613          	li	a2,128
    80005248:	f3040593          	addi	a1,s0,-208
    8000524c:	4501                	li	a0,0
    8000524e:	e60fd0ef          	jal	800028ae <argstr>
    80005252:	87aa                	mv	a5,a0
    return -1;
    80005254:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005256:	0e07c063          	bltz	a5,80005336 <sys_exec+0x104>
    8000525a:	e7a6                	sd	s1,456(sp)
    8000525c:	e3ca                	sd	s2,448(sp)
    8000525e:	ff4e                	sd	s3,440(sp)
    80005260:	fb52                	sd	s4,432(sp)
    80005262:	f756                	sd	s5,424(sp)
    80005264:	f35a                	sd	s6,416(sp)
    80005266:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005268:	e3040a13          	addi	s4,s0,-464
    8000526c:	10000613          	li	a2,256
    80005270:	4581                	li	a1,0
    80005272:	8552                	mv	a0,s4
    80005274:	a53fb0ef          	jal	80000cc6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005278:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    8000527a:	89d2                	mv	s3,s4
    8000527c:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000527e:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005282:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80005284:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005288:	00391513          	slli	a0,s2,0x3
    8000528c:	85d6                	mv	a1,s5
    8000528e:	e2843783          	ld	a5,-472(s0)
    80005292:	953e                	add	a0,a0,a5
    80005294:	d58fd0ef          	jal	800027ec <fetchaddr>
    80005298:	02054663          	bltz	a0,800052c4 <sys_exec+0x92>
    if(uarg == 0){
    8000529c:	e2043783          	ld	a5,-480(s0)
    800052a0:	c7a1                	beqz	a5,800052e8 <sys_exec+0xb6>
    argv[i] = kalloc();
    800052a2:	881fb0ef          	jal	80000b22 <kalloc>
    800052a6:	85aa                	mv	a1,a0
    800052a8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800052ac:	cd01                	beqz	a0,800052c4 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800052ae:	865a                	mv	a2,s6
    800052b0:	e2043503          	ld	a0,-480(s0)
    800052b4:	d82fd0ef          	jal	80002836 <fetchstr>
    800052b8:	00054663          	bltz	a0,800052c4 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800052bc:	0905                	addi	s2,s2,1
    800052be:	09a1                	addi	s3,s3,8
    800052c0:	fd7914e3          	bne	s2,s7,80005288 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052c4:	100a0a13          	addi	s4,s4,256
    800052c8:	6088                	ld	a0,0(s1)
    800052ca:	cd31                	beqz	a0,80005326 <sys_exec+0xf4>
    kfree(argv[i]);
    800052cc:	f74fb0ef          	jal	80000a40 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052d0:	04a1                	addi	s1,s1,8
    800052d2:	ff449be3          	bne	s1,s4,800052c8 <sys_exec+0x96>
  return -1;
    800052d6:	557d                	li	a0,-1
    800052d8:	64be                	ld	s1,456(sp)
    800052da:	691e                	ld	s2,448(sp)
    800052dc:	79fa                	ld	s3,440(sp)
    800052de:	7a5a                	ld	s4,432(sp)
    800052e0:	7aba                	ld	s5,424(sp)
    800052e2:	7b1a                	ld	s6,416(sp)
    800052e4:	6bfa                	ld	s7,408(sp)
    800052e6:	a881                	j	80005336 <sys_exec+0x104>
      argv[i] = 0;
    800052e8:	0009079b          	sext.w	a5,s2
    800052ec:	e3040593          	addi	a1,s0,-464
    800052f0:	078e                	slli	a5,a5,0x3
    800052f2:	97ae                	add	a5,a5,a1
    800052f4:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    800052f8:	f3040513          	addi	a0,s0,-208
    800052fc:	ba4ff0ef          	jal	800046a0 <kexec>
    80005300:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005302:	100a0a13          	addi	s4,s4,256
    80005306:	6088                	ld	a0,0(s1)
    80005308:	c511                	beqz	a0,80005314 <sys_exec+0xe2>
    kfree(argv[i]);
    8000530a:	f36fb0ef          	jal	80000a40 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000530e:	04a1                	addi	s1,s1,8
    80005310:	ff449be3          	bne	s1,s4,80005306 <sys_exec+0xd4>
  return ret;
    80005314:	854a                	mv	a0,s2
    80005316:	64be                	ld	s1,456(sp)
    80005318:	691e                	ld	s2,448(sp)
    8000531a:	79fa                	ld	s3,440(sp)
    8000531c:	7a5a                	ld	s4,432(sp)
    8000531e:	7aba                	ld	s5,424(sp)
    80005320:	7b1a                	ld	s6,416(sp)
    80005322:	6bfa                	ld	s7,408(sp)
    80005324:	a809                	j	80005336 <sys_exec+0x104>
  return -1;
    80005326:	557d                	li	a0,-1
    80005328:	64be                	ld	s1,456(sp)
    8000532a:	691e                	ld	s2,448(sp)
    8000532c:	79fa                	ld	s3,440(sp)
    8000532e:	7a5a                	ld	s4,432(sp)
    80005330:	7aba                	ld	s5,424(sp)
    80005332:	7b1a                	ld	s6,416(sp)
    80005334:	6bfa                	ld	s7,408(sp)
}
    80005336:	60fe                	ld	ra,472(sp)
    80005338:	645e                	ld	s0,464(sp)
    8000533a:	613d                	addi	sp,sp,480
    8000533c:	8082                	ret

000000008000533e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000533e:	7139                	addi	sp,sp,-64
    80005340:	fc06                	sd	ra,56(sp)
    80005342:	f822                	sd	s0,48(sp)
    80005344:	f426                	sd	s1,40(sp)
    80005346:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005348:	dccfc0ef          	jal	80001914 <myproc>
    8000534c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000534e:	fd840593          	addi	a1,s0,-40
    80005352:	4501                	li	a0,0
    80005354:	d3efd0ef          	jal	80002892 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005358:	fc840593          	addi	a1,s0,-56
    8000535c:	fd040513          	addi	a0,s0,-48
    80005360:	814ff0ef          	jal	80004374 <pipealloc>
    return -1;
    80005364:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005366:	0a054463          	bltz	a0,8000540e <sys_pipe+0xd0>
  fd0 = -1;
    8000536a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000536e:	fd043503          	ld	a0,-48(s0)
    80005372:	edeff0ef          	jal	80004a50 <fdalloc>
    80005376:	fca42223          	sw	a0,-60(s0)
    8000537a:	08054163          	bltz	a0,800053fc <sys_pipe+0xbe>
    8000537e:	fc843503          	ld	a0,-56(s0)
    80005382:	eceff0ef          	jal	80004a50 <fdalloc>
    80005386:	fca42023          	sw	a0,-64(s0)
    8000538a:	06054063          	bltz	a0,800053ea <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000538e:	4691                	li	a3,4
    80005390:	fc440613          	addi	a2,s0,-60
    80005394:	fd843583          	ld	a1,-40(s0)
    80005398:	68a8                	ld	a0,80(s1)
    8000539a:	aacfc0ef          	jal	80001646 <copyout>
    8000539e:	00054e63          	bltz	a0,800053ba <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800053a2:	4691                	li	a3,4
    800053a4:	fc040613          	addi	a2,s0,-64
    800053a8:	fd843583          	ld	a1,-40(s0)
    800053ac:	95b6                	add	a1,a1,a3
    800053ae:	68a8                	ld	a0,80(s1)
    800053b0:	a96fc0ef          	jal	80001646 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800053b4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800053b6:	04055c63          	bgez	a0,8000540e <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800053ba:	fc442783          	lw	a5,-60(s0)
    800053be:	07e9                	addi	a5,a5,26
    800053c0:	078e                	slli	a5,a5,0x3
    800053c2:	97a6                	add	a5,a5,s1
    800053c4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800053c8:	fc042783          	lw	a5,-64(s0)
    800053cc:	07e9                	addi	a5,a5,26
    800053ce:	078e                	slli	a5,a5,0x3
    800053d0:	94be                	add	s1,s1,a5
    800053d2:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800053d6:	fd043503          	ld	a0,-48(s0)
    800053da:	c8bfe0ef          	jal	80004064 <fileclose>
    fileclose(wf);
    800053de:	fc843503          	ld	a0,-56(s0)
    800053e2:	c83fe0ef          	jal	80004064 <fileclose>
    return -1;
    800053e6:	57fd                	li	a5,-1
    800053e8:	a01d                	j	8000540e <sys_pipe+0xd0>
    if(fd0 >= 0)
    800053ea:	fc442783          	lw	a5,-60(s0)
    800053ee:	0007c763          	bltz	a5,800053fc <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800053f2:	07e9                	addi	a5,a5,26
    800053f4:	078e                	slli	a5,a5,0x3
    800053f6:	97a6                	add	a5,a5,s1
    800053f8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800053fc:	fd043503          	ld	a0,-48(s0)
    80005400:	c65fe0ef          	jal	80004064 <fileclose>
    fileclose(wf);
    80005404:	fc843503          	ld	a0,-56(s0)
    80005408:	c5dfe0ef          	jal	80004064 <fileclose>
    return -1;
    8000540c:	57fd                	li	a5,-1
}
    8000540e:	853e                	mv	a0,a5
    80005410:	70e2                	ld	ra,56(sp)
    80005412:	7442                	ld	s0,48(sp)
    80005414:	74a2                	ld	s1,40(sp)
    80005416:	6121                	addi	sp,sp,64
    80005418:	8082                	ret
    8000541a:	0000                	unimp
    8000541c:	0000                	unimp
	...

0000000080005420 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005420:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005422:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005424:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005426:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005428:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000542a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000542c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000542e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005430:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005432:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005434:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005436:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005438:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000543a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000543c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000543e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005440:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005442:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005444:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005446:	a6efd0ef          	jal	800026b4 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000544a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000544c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000544e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005450:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005452:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005454:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005456:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005458:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000545a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000545c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000545e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005460:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005462:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005464:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005466:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005468:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000546a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000546c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000546e:	10200073          	sret
	...

000000008000547e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000547e:	1141                	addi	sp,sp,-16
    80005480:	e406                	sd	ra,8(sp)
    80005482:	e022                	sd	s0,0(sp)
    80005484:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005486:	0c0007b7          	lui	a5,0xc000
    8000548a:	4705                	li	a4,1
    8000548c:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000548e:	c3d8                	sw	a4,4(a5)
    80005490:	0791                	addi	a5,a5,4 # c000004 <_entry-0x73fffffc>
  // PCIE IRQs are 32 to 35
  for(int irq = 1; irq < 0x35; irq++){
    *(uint32*)(PLIC + irq*4) = 1;
    80005492:	86ba                	mv	a3,a4
  for(int irq = 1; irq < 0x35; irq++){
    80005494:	0c000737          	lui	a4,0xc000
    80005498:	0d470713          	addi	a4,a4,212 # c0000d4 <_entry-0x73ffff2c>
    *(uint32*)(PLIC + irq*4) = 1;
    8000549c:	c394                	sw	a3,0(a5)
  for(int irq = 1; irq < 0x35; irq++){
    8000549e:	0791                	addi	a5,a5,4
    800054a0:	fee79ee3          	bne	a5,a4,8000549c <plicinit+0x1e>
  }
}
    800054a4:	60a2                	ld	ra,8(sp)
    800054a6:	6402                	ld	s0,0(sp)
    800054a8:	0141                	addi	sp,sp,16
    800054aa:	8082                	ret

00000000800054ac <plicinithart>:

void
plicinithart(void)
{
    800054ac:	1141                	addi	sp,sp,-16
    800054ae:	e406                	sd	ra,8(sp)
    800054b0:	e022                	sd	s0,0(sp)
    800054b2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054b4:	c2cfc0ef          	jal	800018e0 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054b8:	0085179b          	slliw	a5,a0,0x8
    800054bc:	0c002737          	lui	a4,0xc002
    800054c0:	973e                	add	a4,a4,a5
    800054c2:	40200693          	li	a3,1026
    800054c6:	08d72023          	sw	a3,128(a4) # c002080 <_entry-0x73ffdf80>
  
  // hack to get at next 32 IRQs for e1000
  *(volatile uint32*)(PLIC_SENABLE(hart)+4) = 0xffffffff;
    800054ca:	0c002737          	lui	a4,0xc002
    800054ce:	08470713          	addi	a4,a4,132 # c002084 <_entry-0x73ffdf7c>
    800054d2:	97ba                	add	a5,a5,a4
    800054d4:	577d                	li	a4,-1
    800054d6:	c398                	sw	a4,0(a5)

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054d8:	00d5151b          	slliw	a0,a0,0xd
    800054dc:	0c2017b7          	lui	a5,0xc201
    800054e0:	97aa                	add	a5,a5,a0
    800054e2:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>

}
    800054e6:	60a2                	ld	ra,8(sp)
    800054e8:	6402                	ld	s0,0(sp)
    800054ea:	0141                	addi	sp,sp,16
    800054ec:	8082                	ret

00000000800054ee <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054ee:	1141                	addi	sp,sp,-16
    800054f0:	e406                	sd	ra,8(sp)
    800054f2:	e022                	sd	s0,0(sp)
    800054f4:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054f6:	beafc0ef          	jal	800018e0 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800054fa:	00d5151b          	slliw	a0,a0,0xd
    800054fe:	0c2017b7          	lui	a5,0xc201
    80005502:	97aa                	add	a5,a5,a0
  return irq;
}
    80005504:	43c8                	lw	a0,4(a5)
    80005506:	60a2                	ld	ra,8(sp)
    80005508:	6402                	ld	s0,0(sp)
    8000550a:	0141                	addi	sp,sp,16
    8000550c:	8082                	ret

000000008000550e <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000550e:	1101                	addi	sp,sp,-32
    80005510:	ec06                	sd	ra,24(sp)
    80005512:	e822                	sd	s0,16(sp)
    80005514:	e426                	sd	s1,8(sp)
    80005516:	1000                	addi	s0,sp,32
    80005518:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000551a:	bc6fc0ef          	jal	800018e0 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000551e:	00d5179b          	slliw	a5,a0,0xd
    80005522:	0c201737          	lui	a4,0xc201
    80005526:	97ba                	add	a5,a5,a4
    80005528:	c3c4                	sw	s1,4(a5)
}
    8000552a:	60e2                	ld	ra,24(sp)
    8000552c:	6442                	ld	s0,16(sp)
    8000552e:	64a2                	ld	s1,8(sp)
    80005530:	6105                	addi	sp,sp,32
    80005532:	8082                	ret

0000000080005534 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005534:	1141                	addi	sp,sp,-16
    80005536:	e406                	sd	ra,8(sp)
    80005538:	e022                	sd	s0,0(sp)
    8000553a:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000553c:	479d                	li	a5,7
    8000553e:	04a7ca63          	blt	a5,a0,80005592 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005542:	0001c797          	auipc	a5,0x1c
    80005546:	62678793          	addi	a5,a5,1574 # 80021b68 <disk>
    8000554a:	97aa                	add	a5,a5,a0
    8000554c:	0187c783          	lbu	a5,24(a5)
    80005550:	e7b9                	bnez	a5,8000559e <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005552:	00451693          	slli	a3,a0,0x4
    80005556:	0001c797          	auipc	a5,0x1c
    8000555a:	61278793          	addi	a5,a5,1554 # 80021b68 <disk>
    8000555e:	6398                	ld	a4,0(a5)
    80005560:	9736                	add	a4,a4,a3
    80005562:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005566:	6398                	ld	a4,0(a5)
    80005568:	9736                	add	a4,a4,a3
    8000556a:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000556e:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005572:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005576:	97aa                	add	a5,a5,a0
    80005578:	4705                	li	a4,1
    8000557a:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000557e:	0001c517          	auipc	a0,0x1c
    80005582:	60250513          	addi	a0,a0,1538 # 80021b80 <disk+0x18>
    80005586:	9e5fc0ef          	jal	80001f6a <wakeup>
}
    8000558a:	60a2                	ld	ra,8(sp)
    8000558c:	6402                	ld	s0,0(sp)
    8000558e:	0141                	addi	sp,sp,16
    80005590:	8082                	ret
    panic("free_desc 1");
    80005592:	00003517          	auipc	a0,0x3
    80005596:	09e50513          	addi	a0,a0,158 # 80008630 <etext+0x630>
    8000559a:	a44fb0ef          	jal	800007de <panic>
    panic("free_desc 2");
    8000559e:	00003517          	auipc	a0,0x3
    800055a2:	0a250513          	addi	a0,a0,162 # 80008640 <etext+0x640>
    800055a6:	a38fb0ef          	jal	800007de <panic>

00000000800055aa <virtio_disk_init>:
{
    800055aa:	1101                	addi	sp,sp,-32
    800055ac:	ec06                	sd	ra,24(sp)
    800055ae:	e822                	sd	s0,16(sp)
    800055b0:	e426                	sd	s1,8(sp)
    800055b2:	e04a                	sd	s2,0(sp)
    800055b4:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055b6:	00003597          	auipc	a1,0x3
    800055ba:	09a58593          	addi	a1,a1,154 # 80008650 <etext+0x650>
    800055be:	0001c517          	auipc	a0,0x1c
    800055c2:	6d250513          	addi	a0,a0,1746 # 80021c90 <disk+0x128>
    800055c6:	dacfb0ef          	jal	80000b72 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055ca:	100017b7          	lui	a5,0x10001
    800055ce:	4398                	lw	a4,0(a5)
    800055d0:	2701                	sext.w	a4,a4
    800055d2:	747277b7          	lui	a5,0x74727
    800055d6:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055da:	14f71863          	bne	a4,a5,8000572a <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055de:	100017b7          	lui	a5,0x10001
    800055e2:	43dc                	lw	a5,4(a5)
    800055e4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055e6:	4709                	li	a4,2
    800055e8:	14e79163          	bne	a5,a4,8000572a <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055ec:	100017b7          	lui	a5,0x10001
    800055f0:	479c                	lw	a5,8(a5)
    800055f2:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055f4:	12e79b63          	bne	a5,a4,8000572a <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800055f8:	100017b7          	lui	a5,0x10001
    800055fc:	47d8                	lw	a4,12(a5)
    800055fe:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005600:	554d47b7          	lui	a5,0x554d4
    80005604:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005608:	12f71163          	bne	a4,a5,8000572a <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000560c:	100017b7          	lui	a5,0x10001
    80005610:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005614:	4705                	li	a4,1
    80005616:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005618:	470d                	li	a4,3
    8000561a:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000561c:	10001737          	lui	a4,0x10001
    80005620:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005622:	c7ffe6b7          	lui	a3,0xc7ffe
    80005626:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdbdf7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000562a:	8f75                	and	a4,a4,a3
    8000562c:	100016b7          	lui	a3,0x10001
    80005630:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005632:	472d                	li	a4,11
    80005634:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005636:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000563a:	439c                	lw	a5,0(a5)
    8000563c:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005640:	8ba1                	andi	a5,a5,8
    80005642:	0e078a63          	beqz	a5,80005736 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005646:	100017b7          	lui	a5,0x10001
    8000564a:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000564e:	43fc                	lw	a5,68(a5)
    80005650:	2781                	sext.w	a5,a5
    80005652:	0e079863          	bnez	a5,80005742 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005656:	100017b7          	lui	a5,0x10001
    8000565a:	5bdc                	lw	a5,52(a5)
    8000565c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000565e:	0e078863          	beqz	a5,8000574e <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005662:	471d                	li	a4,7
    80005664:	0ef77b63          	bgeu	a4,a5,8000575a <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005668:	cbafb0ef          	jal	80000b22 <kalloc>
    8000566c:	0001c497          	auipc	s1,0x1c
    80005670:	4fc48493          	addi	s1,s1,1276 # 80021b68 <disk>
    80005674:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005676:	cacfb0ef          	jal	80000b22 <kalloc>
    8000567a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000567c:	ca6fb0ef          	jal	80000b22 <kalloc>
    80005680:	87aa                	mv	a5,a0
    80005682:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005684:	6088                	ld	a0,0(s1)
    80005686:	0e050063          	beqz	a0,80005766 <virtio_disk_init+0x1bc>
    8000568a:	0001c717          	auipc	a4,0x1c
    8000568e:	4e673703          	ld	a4,1254(a4) # 80021b70 <disk+0x8>
    80005692:	cb71                	beqz	a4,80005766 <virtio_disk_init+0x1bc>
    80005694:	cbe9                	beqz	a5,80005766 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005696:	6605                	lui	a2,0x1
    80005698:	4581                	li	a1,0
    8000569a:	e2cfb0ef          	jal	80000cc6 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000569e:	0001c497          	auipc	s1,0x1c
    800056a2:	4ca48493          	addi	s1,s1,1226 # 80021b68 <disk>
    800056a6:	6605                	lui	a2,0x1
    800056a8:	4581                	li	a1,0
    800056aa:	6488                	ld	a0,8(s1)
    800056ac:	e1afb0ef          	jal	80000cc6 <memset>
  memset(disk.used, 0, PGSIZE);
    800056b0:	6605                	lui	a2,0x1
    800056b2:	4581                	li	a1,0
    800056b4:	6888                	ld	a0,16(s1)
    800056b6:	e10fb0ef          	jal	80000cc6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800056ba:	100017b7          	lui	a5,0x10001
    800056be:	4721                	li	a4,8
    800056c0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800056c2:	4098                	lw	a4,0(s1)
    800056c4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800056c8:	40d8                	lw	a4,4(s1)
    800056ca:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800056ce:	649c                	ld	a5,8(s1)
    800056d0:	0007869b          	sext.w	a3,a5
    800056d4:	10001737          	lui	a4,0x10001
    800056d8:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800056dc:	9781                	srai	a5,a5,0x20
    800056de:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800056e2:	689c                	ld	a5,16(s1)
    800056e4:	0007869b          	sext.w	a3,a5
    800056e8:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800056ec:	9781                	srai	a5,a5,0x20
    800056ee:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800056f2:	4785                	li	a5,1
    800056f4:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800056f6:	00f48c23          	sb	a5,24(s1)
    800056fa:	00f48ca3          	sb	a5,25(s1)
    800056fe:	00f48d23          	sb	a5,26(s1)
    80005702:	00f48da3          	sb	a5,27(s1)
    80005706:	00f48e23          	sb	a5,28(s1)
    8000570a:	00f48ea3          	sb	a5,29(s1)
    8000570e:	00f48f23          	sb	a5,30(s1)
    80005712:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005716:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    8000571a:	07272823          	sw	s2,112(a4)
}
    8000571e:	60e2                	ld	ra,24(sp)
    80005720:	6442                	ld	s0,16(sp)
    80005722:	64a2                	ld	s1,8(sp)
    80005724:	6902                	ld	s2,0(sp)
    80005726:	6105                	addi	sp,sp,32
    80005728:	8082                	ret
    panic("could not find virtio disk");
    8000572a:	00003517          	auipc	a0,0x3
    8000572e:	f3650513          	addi	a0,a0,-202 # 80008660 <etext+0x660>
    80005732:	8acfb0ef          	jal	800007de <panic>
    panic("virtio disk FEATURES_OK unset");
    80005736:	00003517          	auipc	a0,0x3
    8000573a:	f4a50513          	addi	a0,a0,-182 # 80008680 <etext+0x680>
    8000573e:	8a0fb0ef          	jal	800007de <panic>
    panic("virtio disk should not be ready");
    80005742:	00003517          	auipc	a0,0x3
    80005746:	f5e50513          	addi	a0,a0,-162 # 800086a0 <etext+0x6a0>
    8000574a:	894fb0ef          	jal	800007de <panic>
    panic("virtio disk has no queue 0");
    8000574e:	00003517          	auipc	a0,0x3
    80005752:	f7250513          	addi	a0,a0,-142 # 800086c0 <etext+0x6c0>
    80005756:	888fb0ef          	jal	800007de <panic>
    panic("virtio disk max queue too short");
    8000575a:	00003517          	auipc	a0,0x3
    8000575e:	f8650513          	addi	a0,a0,-122 # 800086e0 <etext+0x6e0>
    80005762:	87cfb0ef          	jal	800007de <panic>
    panic("virtio disk kalloc");
    80005766:	00003517          	auipc	a0,0x3
    8000576a:	f9a50513          	addi	a0,a0,-102 # 80008700 <etext+0x700>
    8000576e:	870fb0ef          	jal	800007de <panic>

0000000080005772 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005772:	711d                	addi	sp,sp,-96
    80005774:	ec86                	sd	ra,88(sp)
    80005776:	e8a2                	sd	s0,80(sp)
    80005778:	e4a6                	sd	s1,72(sp)
    8000577a:	e0ca                	sd	s2,64(sp)
    8000577c:	fc4e                	sd	s3,56(sp)
    8000577e:	f852                	sd	s4,48(sp)
    80005780:	f456                	sd	s5,40(sp)
    80005782:	f05a                	sd	s6,32(sp)
    80005784:	ec5e                	sd	s7,24(sp)
    80005786:	e862                	sd	s8,16(sp)
    80005788:	1080                	addi	s0,sp,96
    8000578a:	89aa                	mv	s3,a0
    8000578c:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000578e:	00c52b83          	lw	s7,12(a0)
    80005792:	001b9b9b          	slliw	s7,s7,0x1
    80005796:	1b82                	slli	s7,s7,0x20
    80005798:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000579c:	0001c517          	auipc	a0,0x1c
    800057a0:	4f450513          	addi	a0,a0,1268 # 80021c90 <disk+0x128>
    800057a4:	c52fb0ef          	jal	80000bf6 <acquire>
  for(int i = 0; i < NUM; i++){
    800057a8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800057aa:	0001ca97          	auipc	s5,0x1c
    800057ae:	3bea8a93          	addi	s5,s5,958 # 80021b68 <disk>
  for(int i = 0; i < 3; i++){
    800057b2:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800057b4:	5c7d                	li	s8,-1
    800057b6:	a095                	j	8000581a <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    800057b8:	00fa8733          	add	a4,s5,a5
    800057bc:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800057c0:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800057c2:	0207c563          	bltz	a5,800057ec <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    800057c6:	2905                	addiw	s2,s2,1
    800057c8:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800057ca:	05490c63          	beq	s2,s4,80005822 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    800057ce:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800057d0:	0001c717          	auipc	a4,0x1c
    800057d4:	39870713          	addi	a4,a4,920 # 80021b68 <disk>
    800057d8:	4781                	li	a5,0
    if(disk.free[i]){
    800057da:	01874683          	lbu	a3,24(a4)
    800057de:	fee9                	bnez	a3,800057b8 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    800057e0:	2785                	addiw	a5,a5,1
    800057e2:	0705                	addi	a4,a4,1
    800057e4:	fe979be3          	bne	a5,s1,800057da <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    800057e8:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    800057ec:	01205d63          	blez	s2,80005806 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800057f0:	fa042503          	lw	a0,-96(s0)
    800057f4:	d41ff0ef          	jal	80005534 <free_desc>
      for(int j = 0; j < i; j++)
    800057f8:	4785                	li	a5,1
    800057fa:	0127d663          	bge	a5,s2,80005806 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800057fe:	fa442503          	lw	a0,-92(s0)
    80005802:	d33ff0ef          	jal	80005534 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005806:	0001c597          	auipc	a1,0x1c
    8000580a:	48a58593          	addi	a1,a1,1162 # 80021c90 <disk+0x128>
    8000580e:	0001c517          	auipc	a0,0x1c
    80005812:	37250513          	addi	a0,a0,882 # 80021b80 <disk+0x18>
    80005816:	f08fc0ef          	jal	80001f1e <sleep>
  for(int i = 0; i < 3; i++){
    8000581a:	fa040613          	addi	a2,s0,-96
    8000581e:	4901                	li	s2,0
    80005820:	b77d                	j	800057ce <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005822:	fa042503          	lw	a0,-96(s0)
    80005826:	00451693          	slli	a3,a0,0x4

  if(write)
    8000582a:	0001c797          	auipc	a5,0x1c
    8000582e:	33e78793          	addi	a5,a5,830 # 80021b68 <disk>
    80005832:	00a50713          	addi	a4,a0,10
    80005836:	0712                	slli	a4,a4,0x4
    80005838:	973e                	add	a4,a4,a5
    8000583a:	01603633          	snez	a2,s6
    8000583e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005840:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005844:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005848:	6398                	ld	a4,0(a5)
    8000584a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000584c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005850:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005852:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005854:	6390                	ld	a2,0(a5)
    80005856:	00d605b3          	add	a1,a2,a3
    8000585a:	4741                	li	a4,16
    8000585c:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000585e:	4805                	li	a6,1
    80005860:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005864:	fa442703          	lw	a4,-92(s0)
    80005868:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000586c:	0712                	slli	a4,a4,0x4
    8000586e:	963a                	add	a2,a2,a4
    80005870:	05898593          	addi	a1,s3,88
    80005874:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005876:	0007b883          	ld	a7,0(a5)
    8000587a:	9746                	add	a4,a4,a7
    8000587c:	40000613          	li	a2,1024
    80005880:	c710                	sw	a2,8(a4)
  if(write)
    80005882:	001b3613          	seqz	a2,s6
    80005886:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000588a:	01066633          	or	a2,a2,a6
    8000588e:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005892:	fa842583          	lw	a1,-88(s0)
    80005896:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000589a:	00250613          	addi	a2,a0,2
    8000589e:	0612                	slli	a2,a2,0x4
    800058a0:	963e                	add	a2,a2,a5
    800058a2:	577d                	li	a4,-1
    800058a4:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058a8:	0592                	slli	a1,a1,0x4
    800058aa:	98ae                	add	a7,a7,a1
    800058ac:	03068713          	addi	a4,a3,48
    800058b0:	973e                	add	a4,a4,a5
    800058b2:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800058b6:	6398                	ld	a4,0(a5)
    800058b8:	972e                	add	a4,a4,a1
    800058ba:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800058be:	4689                	li	a3,2
    800058c0:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800058c4:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800058c8:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    800058cc:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800058d0:	6794                	ld	a3,8(a5)
    800058d2:	0026d703          	lhu	a4,2(a3)
    800058d6:	8b1d                	andi	a4,a4,7
    800058d8:	0706                	slli	a4,a4,0x1
    800058da:	96ba                	add	a3,a3,a4
    800058dc:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800058e0:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800058e4:	6798                	ld	a4,8(a5)
    800058e6:	00275783          	lhu	a5,2(a4)
    800058ea:	2785                	addiw	a5,a5,1
    800058ec:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800058f0:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800058f4:	100017b7          	lui	a5,0x10001
    800058f8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800058fc:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005900:	0001c917          	auipc	s2,0x1c
    80005904:	39090913          	addi	s2,s2,912 # 80021c90 <disk+0x128>
  while(b->disk == 1) {
    80005908:	84c2                	mv	s1,a6
    8000590a:	01079a63          	bne	a5,a6,8000591e <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    8000590e:	85ca                	mv	a1,s2
    80005910:	854e                	mv	a0,s3
    80005912:	e0cfc0ef          	jal	80001f1e <sleep>
  while(b->disk == 1) {
    80005916:	0049a783          	lw	a5,4(s3)
    8000591a:	fe978ae3          	beq	a5,s1,8000590e <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    8000591e:	fa042903          	lw	s2,-96(s0)
    80005922:	00290713          	addi	a4,s2,2
    80005926:	0712                	slli	a4,a4,0x4
    80005928:	0001c797          	auipc	a5,0x1c
    8000592c:	24078793          	addi	a5,a5,576 # 80021b68 <disk>
    80005930:	97ba                	add	a5,a5,a4
    80005932:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005936:	0001c997          	auipc	s3,0x1c
    8000593a:	23298993          	addi	s3,s3,562 # 80021b68 <disk>
    8000593e:	00491713          	slli	a4,s2,0x4
    80005942:	0009b783          	ld	a5,0(s3)
    80005946:	97ba                	add	a5,a5,a4
    80005948:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000594c:	854a                	mv	a0,s2
    8000594e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005952:	be3ff0ef          	jal	80005534 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005956:	8885                	andi	s1,s1,1
    80005958:	f0fd                	bnez	s1,8000593e <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000595a:	0001c517          	auipc	a0,0x1c
    8000595e:	33650513          	addi	a0,a0,822 # 80021c90 <disk+0x128>
    80005962:	b28fb0ef          	jal	80000c8a <release>
}
    80005966:	60e6                	ld	ra,88(sp)
    80005968:	6446                	ld	s0,80(sp)
    8000596a:	64a6                	ld	s1,72(sp)
    8000596c:	6906                	ld	s2,64(sp)
    8000596e:	79e2                	ld	s3,56(sp)
    80005970:	7a42                	ld	s4,48(sp)
    80005972:	7aa2                	ld	s5,40(sp)
    80005974:	7b02                	ld	s6,32(sp)
    80005976:	6be2                	ld	s7,24(sp)
    80005978:	6c42                	ld	s8,16(sp)
    8000597a:	6125                	addi	sp,sp,96
    8000597c:	8082                	ret

000000008000597e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000597e:	1101                	addi	sp,sp,-32
    80005980:	ec06                	sd	ra,24(sp)
    80005982:	e822                	sd	s0,16(sp)
    80005984:	e426                	sd	s1,8(sp)
    80005986:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005988:	0001c497          	auipc	s1,0x1c
    8000598c:	1e048493          	addi	s1,s1,480 # 80021b68 <disk>
    80005990:	0001c517          	auipc	a0,0x1c
    80005994:	30050513          	addi	a0,a0,768 # 80021c90 <disk+0x128>
    80005998:	a5efb0ef          	jal	80000bf6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000599c:	100017b7          	lui	a5,0x10001
    800059a0:	53bc                	lw	a5,96(a5)
    800059a2:	8b8d                	andi	a5,a5,3
    800059a4:	10001737          	lui	a4,0x10001
    800059a8:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800059aa:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800059ae:	689c                	ld	a5,16(s1)
    800059b0:	0204d703          	lhu	a4,32(s1)
    800059b4:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800059b8:	04f70663          	beq	a4,a5,80005a04 <virtio_disk_intr+0x86>
    __sync_synchronize();
    800059bc:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059c0:	6898                	ld	a4,16(s1)
    800059c2:	0204d783          	lhu	a5,32(s1)
    800059c6:	8b9d                	andi	a5,a5,7
    800059c8:	078e                	slli	a5,a5,0x3
    800059ca:	97ba                	add	a5,a5,a4
    800059cc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800059ce:	00278713          	addi	a4,a5,2
    800059d2:	0712                	slli	a4,a4,0x4
    800059d4:	9726                	add	a4,a4,s1
    800059d6:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800059da:	e321                	bnez	a4,80005a1a <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800059dc:	0789                	addi	a5,a5,2
    800059de:	0792                	slli	a5,a5,0x4
    800059e0:	97a6                	add	a5,a5,s1
    800059e2:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800059e4:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800059e8:	d82fc0ef          	jal	80001f6a <wakeup>

    disk.used_idx += 1;
    800059ec:	0204d783          	lhu	a5,32(s1)
    800059f0:	2785                	addiw	a5,a5,1
    800059f2:	17c2                	slli	a5,a5,0x30
    800059f4:	93c1                	srli	a5,a5,0x30
    800059f6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800059fa:	6898                	ld	a4,16(s1)
    800059fc:	00275703          	lhu	a4,2(a4)
    80005a00:	faf71ee3          	bne	a4,a5,800059bc <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005a04:	0001c517          	auipc	a0,0x1c
    80005a08:	28c50513          	addi	a0,a0,652 # 80021c90 <disk+0x128>
    80005a0c:	a7efb0ef          	jal	80000c8a <release>
}
    80005a10:	60e2                	ld	ra,24(sp)
    80005a12:	6442                	ld	s0,16(sp)
    80005a14:	64a2                	ld	s1,8(sp)
    80005a16:	6105                	addi	sp,sp,32
    80005a18:	8082                	ret
      panic("virtio_disk_intr status");
    80005a1a:	00003517          	auipc	a0,0x3
    80005a1e:	cfe50513          	addi	a0,a0,-770 # 80008718 <etext+0x718>
    80005a22:	dbdfa0ef          	jal	800007de <panic>

0000000080005a26 <e1000_init>:
// e1000's registers are mapped.
// this code loosely follows the initialization directions
// in Chapter 14 of Intel's Software Developer's Manual.
void
e1000_init(uint32 *xregs)
{
    80005a26:	1101                	addi	sp,sp,-32
    80005a28:	ec06                	sd	ra,24(sp)
    80005a2a:	e822                	sd	s0,16(sp)
    80005a2c:	e426                	sd	s1,8(sp)
    80005a2e:	e04a                	sd	s2,0(sp)
    80005a30:	1000                	addi	s0,sp,32
    80005a32:	84aa                	mv	s1,a0
  int i;

  initlock(&e1000_lock, "e1000");
    80005a34:	00003597          	auipc	a1,0x3
    80005a38:	cfc58593          	addi	a1,a1,-772 # 80008730 <etext+0x730>
    80005a3c:	0001c517          	auipc	a0,0x1c
    80005a40:	27450513          	addi	a0,a0,628 # 80021cb0 <e1000_lock>
    80005a44:	92efb0ef          	jal	80000b72 <initlock>

  regs = xregs;
    80005a48:	00003797          	auipc	a5,0x3
    80005a4c:	f497b423          	sd	s1,-184(a5) # 80008990 <regs>

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
    80005a50:	0c04a823          	sw	zero,208(s1)
  regs[E1000_CTL] |= E1000_CTL_RST;
    80005a54:	409c                	lw	a5,0(s1)
    80005a56:	04000737          	lui	a4,0x4000
    80005a5a:	8fd9                	or	a5,a5,a4
    80005a5c:	c09c                	sw	a5,0(s1)
  regs[E1000_IMS] = 0; // redisable interrupts
    80005a5e:	0c04a823          	sw	zero,208(s1)
  __sync_synchronize();
    80005a62:	0330000f          	fence	rw,rw

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
    80005a66:	0001c497          	auipc	s1,0x1c
    80005a6a:	26a48493          	addi	s1,s1,618 # 80021cd0 <tx_ring>
    80005a6e:	10000613          	li	a2,256
    80005a72:	4581                	li	a1,0
    80005a74:	8526                	mv	a0,s1
    80005a76:	a50fb0ef          	jal	80000cc6 <memset>
  for (i = 0; i < TX_RING_SIZE; i++) {
    80005a7a:	8526                	mv	a0,s1
    80005a7c:	0001c717          	auipc	a4,0x1c
    80005a80:	35470713          	addi	a4,a4,852 # 80021dd0 <rx_ring>
    tx_ring[i].status = E1000_TXD_STAT_DD;
    80005a84:	4785                	li	a5,1
    80005a86:	00f50623          	sb	a5,12(a0)
    tx_ring[i].addr = 0;
    80005a8a:	00053023          	sd	zero,0(a0)
  for (i = 0; i < TX_RING_SIZE; i++) {
    80005a8e:	0541                	addi	a0,a0,16
    80005a90:	fee51be3          	bne	a0,a4,80005a86 <e1000_init+0x60>
  }
  regs[E1000_TDBAL] = (uint64) tx_ring;
    80005a94:	0001c717          	auipc	a4,0x1c
    80005a98:	23c70713          	addi	a4,a4,572 # 80021cd0 <tx_ring>
    80005a9c:	00003797          	auipc	a5,0x3
    80005aa0:	ef47b783          	ld	a5,-268(a5) # 80008990 <regs>
    80005aa4:	6691                	lui	a3,0x4
    80005aa6:	97b6                	add	a5,a5,a3
    80005aa8:	80e7a023          	sw	a4,-2048(a5)
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
    80005aac:	10000613          	li	a2,256
    80005ab0:	80c7a423          	sw	a2,-2040(a5)
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
    80005ab4:	8007ac23          	sw	zero,-2024(a5)
    80005ab8:	8007a823          	sw	zero,-2032(a5)
  
  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
    80005abc:	0001c497          	auipc	s1,0x1c
    80005ac0:	31448493          	addi	s1,s1,788 # 80021dd0 <rx_ring>
    80005ac4:	4581                	li	a1,0
    80005ac6:	8526                	mv	a0,s1
    80005ac8:	9fefb0ef          	jal	80000cc6 <memset>
  for (i = 0; i < RX_RING_SIZE; i++) {
    80005acc:	0001c917          	auipc	s2,0x1c
    80005ad0:	40490913          	addi	s2,s2,1028 # 80021ed0 <netlock>
    rx_ring[i].addr = (uint64) kalloc();
    80005ad4:	84efb0ef          	jal	80000b22 <kalloc>
    80005ad8:	e088                	sd	a0,0(s1)
    if (!rx_ring[i].addr)
    80005ada:	c545                	beqz	a0,80005b82 <e1000_init+0x15c>
  for (i = 0; i < RX_RING_SIZE; i++) {
    80005adc:	04c1                	addi	s1,s1,16
    80005ade:	ff249be3          	bne	s1,s2,80005ad4 <e1000_init+0xae>
      panic("e1000");
  }
  regs[E1000_RDBAL] = (uint64) rx_ring;
    80005ae2:	00003697          	auipc	a3,0x3
    80005ae6:	eae6b683          	ld	a3,-338(a3) # 80008990 <regs>
    80005aea:	0001c717          	auipc	a4,0x1c
    80005aee:	2e670713          	addi	a4,a4,742 # 80021dd0 <rx_ring>
    80005af2:	678d                	lui	a5,0x3
    80005af4:	97b6                	add	a5,a5,a3
    80005af6:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
    80005afa:	8007a823          	sw	zero,-2032(a5)
  regs[E1000_RDT] = RX_RING_SIZE - 1;
    80005afe:	473d                	li	a4,15
    80005b00:	80e7ac23          	sw	a4,-2024(a5)
  regs[E1000_RDLEN] = sizeof(rx_ring);
    80005b04:	10000713          	li	a4,256
    80005b08:	80e7a423          	sw	a4,-2040(a5)

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
    80005b0c:	6795                	lui	a5,0x5
    80005b0e:	97b6                	add	a5,a5,a3
    80005b10:	12005737          	lui	a4,0x12005
    80005b14:	45270713          	addi	a4,a4,1106 # 12005452 <_entry-0x6dffabae>
    80005b18:	40e7a023          	sw	a4,1024(a5) # 5400 <_entry-0x7fffac00>
  regs[E1000_RA+1] = 0x5634 | (1<<31);
    80005b1c:	80005737          	lui	a4,0x80005
    80005b20:	63470713          	addi	a4,a4,1588 # ffffffff80005634 <end+0xfffffffefffe2ccc>
    80005b24:	40e7a223          	sw	a4,1028(a5)
  // multicast table
  for (int i = 0; i < 4096/32; i++)
    80005b28:	6795                	lui	a5,0x5
    80005b2a:	20078793          	addi	a5,a5,512 # 5200 <_entry-0x7fffae00>
    80005b2e:	97b6                	add	a5,a5,a3
    80005b30:	6715                	lui	a4,0x5
    80005b32:	40070713          	addi	a4,a4,1024 # 5400 <_entry-0x7fffac00>
    80005b36:	9736                	add	a4,a4,a3
    regs[E1000_MTA + i] = 0;
    80005b38:	0007a023          	sw	zero,0(a5)
  for (int i = 0; i < 4096/32; i++)
    80005b3c:	0791                	addi	a5,a5,4
    80005b3e:	fee79de3          	bne	a5,a4,80005b38 <e1000_init+0x112>

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |  // enable
    80005b42:	000407b7          	lui	a5,0x40
    80005b46:	10a78793          	addi	a5,a5,266 # 4010a <_entry-0x7ffbfef6>
    80005b4a:	40f6a023          	sw	a5,1024(a3)
    E1000_TCTL_PSP |                  // pad short packets
    (0x10 << E1000_TCTL_CT_SHIFT) |   // collision stuff
    (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // inter-pkt gap
    80005b4e:	006027b7          	lui	a5,0x602
    80005b52:	07a9                	addi	a5,a5,10 # 60200a <_entry-0x7f9fdff6>
    80005b54:	40f6a823          	sw	a5,1040(a3)

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN | // enable receiver
    80005b58:	040087b7          	lui	a5,0x4008
    80005b5c:	0789                	addi	a5,a5,2 # 4008002 <_entry-0x7bff7ffe>
    80005b5e:	10f6a023          	sw	a5,256(a3)
    E1000_RCTL_BAM |                 // enable broadcast
    E1000_RCTL_SZ_2048 |             // 2048-byte rx buffers
    E1000_RCTL_SECRC;                // strip CRC
  
  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0; // interrupt after every received packet (no timer)
    80005b62:	678d                	lui	a5,0x3
    80005b64:	97b6                	add	a5,a5,a3
    80005b66:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
  regs[E1000_RADV] = 0; // interrupt after every packet (no timer)
    80005b6a:	8207a623          	sw	zero,-2004(a5)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
    80005b6e:	08000793          	li	a5,128
    80005b72:	0cf6a823          	sw	a5,208(a3)
}
    80005b76:	60e2                	ld	ra,24(sp)
    80005b78:	6442                	ld	s0,16(sp)
    80005b7a:	64a2                	ld	s1,8(sp)
    80005b7c:	6902                	ld	s2,0(sp)
    80005b7e:	6105                	addi	sp,sp,32
    80005b80:	8082                	ret
      panic("e1000");
    80005b82:	00003517          	auipc	a0,0x3
    80005b86:	bae50513          	addi	a0,a0,-1106 # 80008730 <etext+0x730>
    80005b8a:	c55fa0ef          	jal	800007de <panic>

0000000080005b8e <e1000_transmit>:

int
e1000_transmit(char *buf, int len)
{
    80005b8e:	1141                	addi	sp,sp,-16
    80005b90:	e406                	sd	ra,8(sp)
    80005b92:	e022                	sd	s0,0(sp)
    80005b94:	0800                	addi	s0,sp,16
  // return -1 on failure (e.g., there is no descriptor available)
  // so that the caller knows to free buf.
  //
  
  return 0;
}
    80005b96:	4501                	li	a0,0
    80005b98:	60a2                	ld	ra,8(sp)
    80005b9a:	6402                	ld	s0,0(sp)
    80005b9c:	0141                	addi	sp,sp,16
    80005b9e:	8082                	ret

0000000080005ba0 <e1000_intr>:

}

void
e1000_intr(void)
{
    80005ba0:	1141                	addi	sp,sp,-16
    80005ba2:	e406                	sd	ra,8(sp)
    80005ba4:	e022                	sd	s0,0(sp)
    80005ba6:	0800                	addi	s0,sp,16
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;
    80005ba8:	00003797          	auipc	a5,0x3
    80005bac:	de87b783          	ld	a5,-536(a5) # 80008990 <regs>
    80005bb0:	577d                	li	a4,-1
    80005bb2:	0ce7a023          	sw	a4,192(a5)
  idx = CURR_RX_IDX;
    80005bb6:	670d                	lui	a4,0x3
    80005bb8:	97ba                	add	a5,a5,a4
    80005bba:	8187a783          	lw	a5,-2024(a5)
  idx = NEXT_RX_IDX(idx, RX_RING_SIZE);
    80005bbe:	2785                	addiw	a5,a5,1
    80005bc0:	41f7d71b          	sraiw	a4,a5,0x1f
    80005bc4:	01c7571b          	srliw	a4,a4,0x1c
    80005bc8:	9fb9                	addw	a5,a5,a4
    80005bca:	8bbd                	andi	a5,a5,15
    80005bcc:	9f99                	subw	a5,a5,a4
  while (RX_AVAILABLE(rx_ring, idx)) {
    80005bce:	0792                	slli	a5,a5,0x4
    80005bd0:	0001c717          	auipc	a4,0x1c
    80005bd4:	0e070713          	addi	a4,a4,224 # 80021cb0 <e1000_lock>
    80005bd8:	97ba                	add	a5,a5,a4
    80005bda:	12c7c783          	lbu	a5,300(a5)
    80005bde:	8b85                	andi	a5,a5,1
    80005be0:	e381                	bnez	a5,80005be0 <e1000_intr+0x40>

  e1000_recv();
}
    80005be2:	60a2                	ld	ra,8(sp)
    80005be4:	6402                	ld	s0,0(sp)
    80005be6:	0141                	addi	sp,sp,16
    80005be8:	8082                	ret

0000000080005bea <e1000_status>:
//
// For TASK 3
//
void
e1000_status(void)
{
    80005bea:	1141                	addi	sp,sp,-16
    80005bec:	e406                	sd	ra,8(sp)
    80005bee:	e022                	sd	s0,0(sp)
    80005bf0:	0800                	addi	s0,sp,16
  // print syntax
  // printf("\nLink %s, Speed %dMbps, %s duplex\n", ..)



}
    80005bf2:	60a2                	ld	ra,8(sp)
    80005bf4:	6402                	ld	s0,0(sp)
    80005bf6:	0141                	addi	sp,sp,16
    80005bf8:	8082                	ret

0000000080005bfa <netinit>:
  struct buf_queue queue;
} bound_ports[16];

void
netinit(void)
{
    80005bfa:	1141                	addi	sp,sp,-16
    80005bfc:	e406                	sd	ra,8(sp)
    80005bfe:	e022                	sd	s0,0(sp)
    80005c00:	0800                	addi	s0,sp,16
  initlock(&netlock, "netlock");
    80005c02:	00003597          	auipc	a1,0x3
    80005c06:	b3658593          	addi	a1,a1,-1226 # 80008738 <etext+0x738>
    80005c0a:	0001c517          	auipc	a0,0x1c
    80005c0e:	2c650513          	addi	a0,a0,710 # 80021ed0 <netlock>
    80005c12:	f61fa0ef          	jal	80000b72 <initlock>
}
    80005c16:	60a2                	ld	ra,8(sp)
    80005c18:	6402                	ld	s0,0(sp)
    80005c1a:	0141                	addi	sp,sp,16
    80005c1c:	8082                	ret

0000000080005c1e <sys_bind>:
// prepare to receive UDP packets address to the port,
// i.e. allocate any queues &c needed.
//
uint64
sys_bind(void)
{
    80005c1e:	1101                	addi	sp,sp,-32
    80005c20:	ec06                	sd	ra,24(sp)
    80005c22:	e822                	sd	s0,16(sp)
    80005c24:	1000                	addi	s0,sp,32
  int sport;
  
  argint(0, &sport);
    80005c26:	fec40593          	addi	a1,s0,-20
    80005c2a:	4501                	li	a0,0
    80005c2c:	c4bfc0ef          	jal	80002876 <argint>
  
  if (sport < 0 || sport >= 65535)
    80005c30:	fec42703          	lw	a4,-20(s0)
    80005c34:	67c1                	lui	a5,0x10
    80005c36:	17f9                	addi	a5,a5,-2 # fffe <_entry-0x7fff0002>
    return -1;
    80005c38:	557d                	li	a0,-1
  if (sport < 0 || sport >= 65535)
    80005c3a:	06e7e263          	bltu	a5,a4,80005c9e <sys_bind+0x80>

  acquire(&netlock);
    80005c3e:	0001c517          	auipc	a0,0x1c
    80005c42:	29250513          	addi	a0,a0,658 # 80021ed0 <netlock>
    80005c46:	fb1fa0ef          	jal	80000bf6 <acquire>
  for (int i = 0; i < 16; i++) {
    if (bound_ports[i].port == sport) {
    80005c4a:	fec42603          	lw	a2,-20(s0)
    80005c4e:	0001c697          	auipc	a3,0x1c
    80005c52:	29a68693          	addi	a3,a3,666 # 80021ee8 <bound_ports>
    80005c56:	0001d597          	auipc	a1,0x1d
    80005c5a:	d1258593          	addi	a1,a1,-750 # 80022968 <end>
    80005c5e:	87b6                	mv	a5,a3
    80005c60:	4398                	lw	a4,0(a5)
    80005c62:	02c70763          	beq	a4,a2,80005c90 <sys_bind+0x72>
  for (int i = 0; i < 16; i++) {
    80005c66:	0a878793          	addi	a5,a5,168
    80005c6a:	feb79be3          	bne	a5,a1,80005c60 <sys_bind+0x42>
      release(&netlock);
      return -1;
    }
  }

  for (int i = 0; i < 16; i++) {
    80005c6e:	4781                	li	a5,0
    80005c70:	45c1                	li	a1,16
    if (bound_ports[i].port == 0) {
    80005c72:	4298                	lw	a4,0(a3)
    80005c74:	cb0d                	beqz	a4,80005ca6 <sys_bind+0x88>
  for (int i = 0; i < 16; i++) {
    80005c76:	2785                	addiw	a5,a5,1
    80005c78:	0a868693          	addi	a3,a3,168
    80005c7c:	feb79be3          	bne	a5,a1,80005c72 <sys_bind+0x54>
      release(&netlock);
      return 0;
    }
  }

  release(&netlock);
    80005c80:	0001c517          	auipc	a0,0x1c
    80005c84:	25050513          	addi	a0,a0,592 # 80021ed0 <netlock>
    80005c88:	802fb0ef          	jal	80000c8a <release>
  return -1;
    80005c8c:	557d                	li	a0,-1
    80005c8e:	a801                	j	80005c9e <sys_bind+0x80>
      release(&netlock);
    80005c90:	0001c517          	auipc	a0,0x1c
    80005c94:	24050513          	addi	a0,a0,576 # 80021ed0 <netlock>
    80005c98:	ff3fa0ef          	jal	80000c8a <release>
      return -1;
    80005c9c:	557d                	li	a0,-1
}
    80005c9e:	60e2                	ld	ra,24(sp)
    80005ca0:	6442                	ld	s0,16(sp)
    80005ca2:	6105                	addi	sp,sp,32
    80005ca4:	8082                	ret
      bound_ports[i].port = sport;
    80005ca6:	0001c517          	auipc	a0,0x1c
    80005caa:	24250513          	addi	a0,a0,578 # 80021ee8 <bound_ports>
    80005cae:	0a800713          	li	a4,168
    80005cb2:	02e787b3          	mul	a5,a5,a4
    80005cb6:	00f50733          	add	a4,a0,a5
    80005cba:	c310                	sw	a2,0(a4)
      bound_ports[i].queue.head = 0;
    80005cbc:	0a072023          	sw	zero,160(a4)
      bound_ports[i].queue.tail = 0;
    80005cc0:	0a072223          	sw	zero,164(a4)
      initlock(&bound_ports[i].queue.buf_lock, "buf_queue");
    80005cc4:	07a1                	addi	a5,a5,8
    80005cc6:	00003597          	auipc	a1,0x3
    80005cca:	a7a58593          	addi	a1,a1,-1414 # 80008740 <etext+0x740>
    80005cce:	953e                	add	a0,a0,a5
    80005cd0:	ea3fa0ef          	jal	80000b72 <initlock>
      release(&netlock);
    80005cd4:	0001c517          	auipc	a0,0x1c
    80005cd8:	1fc50513          	addi	a0,a0,508 # 80021ed0 <netlock>
    80005cdc:	faffa0ef          	jal	80000c8a <release>
      return 0;
    80005ce0:	4501                	li	a0,0
    80005ce2:	bf75                	j	80005c9e <sys_bind+0x80>

0000000080005ce4 <sys_unbind>:
// release any resources previously created by bind(port);
// from now on UDP packets addressed to port should be dropped.
//
uint64
sys_unbind(void)
{
    80005ce4:	1101                	addi	sp,sp,-32
    80005ce6:	ec06                	sd	ra,24(sp)
    80005ce8:	e822                	sd	s0,16(sp)
    80005cea:	1000                	addi	s0,sp,32
  int sport;

  argint(0, &sport);
    80005cec:	fec40593          	addi	a1,s0,-20
    80005cf0:	4501                	li	a0,0
    80005cf2:	b85fc0ef          	jal	80002876 <argint>

  acquire(&netlock);
    80005cf6:	0001c517          	auipc	a0,0x1c
    80005cfa:	1da50513          	addi	a0,a0,474 # 80021ed0 <netlock>
    80005cfe:	ef9fa0ef          	jal	80000bf6 <acquire>
  for (int i = 0; i < 16; i++) {
    if (bound_ports[i].port == sport) {
    80005d02:	fec42603          	lw	a2,-20(s0)
    80005d06:	0001c717          	auipc	a4,0x1c
    80005d0a:	1e270713          	addi	a4,a4,482 # 80021ee8 <bound_ports>
  for (int i = 0; i < 16; i++) {
    80005d0e:	4781                	li	a5,0
    80005d10:	45c1                	li	a1,16
    if (bound_ports[i].port == sport) {
    80005d12:	4314                	lw	a3,0(a4)
    80005d14:	02c68263          	beq	a3,a2,80005d38 <sys_unbind+0x54>
  for (int i = 0; i < 16; i++) {
    80005d18:	2785                	addiw	a5,a5,1
    80005d1a:	0a870713          	addi	a4,a4,168
    80005d1e:	feb79ae3          	bne	a5,a1,80005d12 <sys_unbind+0x2e>
      bound_ports[i].port = 0;
      release(&netlock);
      return 0;
    }
  }
  release(&netlock);
    80005d22:	0001c517          	auipc	a0,0x1c
    80005d26:	1ae50513          	addi	a0,a0,430 # 80021ed0 <netlock>
    80005d2a:	f61fa0ef          	jal	80000c8a <release>

  return -1;
    80005d2e:	557d                	li	a0,-1

  return 0;
}
    80005d30:	60e2                	ld	ra,24(sp)
    80005d32:	6442                	ld	s0,16(sp)
    80005d34:	6105                	addi	sp,sp,32
    80005d36:	8082                	ret
      bound_ports[i].port = 0;
    80005d38:	0a800713          	li	a4,168
    80005d3c:	02e787b3          	mul	a5,a5,a4
    80005d40:	0001c717          	auipc	a4,0x1c
    80005d44:	1a870713          	addi	a4,a4,424 # 80021ee8 <bound_ports>
    80005d48:	97ba                	add	a5,a5,a4
    80005d4a:	0007a023          	sw	zero,0(a5)
      release(&netlock);
    80005d4e:	0001c517          	auipc	a0,0x1c
    80005d52:	18250513          	addi	a0,a0,386 # 80021ed0 <netlock>
    80005d56:	f35fa0ef          	jal	80000c8a <release>
      return 0;
    80005d5a:	4501                	li	a0,0
    80005d5c:	bfd1                	j	80005d30 <sys_unbind+0x4c>

0000000080005d5e <sys_recv>:
// dport, *src, and *sport are host byte order.
// bind(dport) must previously have been called.
//
uint64
sys_recv(void)
{
    80005d5e:	7159                	addi	sp,sp,-112
    80005d60:	f486                	sd	ra,104(sp)
    80005d62:	f0a2                	sd	s0,96(sp)
    80005d64:	eca6                	sd	s1,88(sp)
    80005d66:	e8ca                	sd	s2,80(sp)
    80005d68:	1880                	addi	s0,sp,112
  struct proc *p = myproc();
    80005d6a:	babfb0ef          	jal	80001914 <myproc>
    80005d6e:	892a                	mv	s2,a0
  uint64 src_addr; 
  uint64 sport_addr;
  uint64 bufaddr;
  int maxlen;

  argint(0, &dport);
    80005d70:	fbc40593          	addi	a1,s0,-68
    80005d74:	4501                	li	a0,0
    80005d76:	b01fc0ef          	jal	80002876 <argint>
  argaddr(1, &src_addr);
    80005d7a:	fb040593          	addi	a1,s0,-80
    80005d7e:	4505                	li	a0,1
    80005d80:	b13fc0ef          	jal	80002892 <argaddr>
  argaddr(2, &sport_addr);
    80005d84:	fa840593          	addi	a1,s0,-88
    80005d88:	4509                	li	a0,2
    80005d8a:	b09fc0ef          	jal	80002892 <argaddr>
  argaddr(3, &bufaddr);
    80005d8e:	fa040593          	addi	a1,s0,-96
    80005d92:	450d                	li	a0,3
    80005d94:	afffc0ef          	jal	80002892 <argaddr>
  argint(4, &maxlen);
    80005d98:	f9c40593          	addi	a1,s0,-100
    80005d9c:	4511                	li	a0,4
    80005d9e:	ad9fc0ef          	jal	80002876 <argint>

  int total = maxlen + sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);
    80005da2:	f9c42783          	lw	a5,-100(s0)
  if(total > PGSIZE)
    80005da6:	02a7879b          	addiw	a5,a5,42
    80005daa:	6705                	lui	a4,0x1
    return -1;
    80005dac:	54fd                	li	s1,-1
  if(total > PGSIZE)
    80005dae:	02f74f63          	blt	a4,a5,80005dec <sys_recv+0x8e>

  acquire(&netlock);
    80005db2:	0001c517          	auipc	a0,0x1c
    80005db6:	11e50513          	addi	a0,a0,286 # 80021ed0 <netlock>
    80005dba:	e3dfa0ef          	jal	80000bf6 <acquire>

  for (int i = 0; i < 16; i++) {
    if (bound_ports[i].port == dport) {
    80005dbe:	fbc42683          	lw	a3,-68(s0)
    80005dc2:	0001c797          	auipc	a5,0x1c
    80005dc6:	12678793          	addi	a5,a5,294 # 80021ee8 <bound_ports>
  for (int i = 0; i < 16; i++) {
    80005dca:	4481                	li	s1,0
    80005dcc:	4641                	li	a2,16
    if (bound_ports[i].port == dport) {
    80005dce:	4398                	lw	a4,0(a5)
    80005dd0:	02d70563          	beq	a4,a3,80005dfa <sys_recv+0x9c>
  for (int i = 0; i < 16; i++) {
    80005dd4:	2485                	addiw	s1,s1,1
    80005dd6:	0a878793          	addi	a5,a5,168
    80005dda:	fec49ae3          	bne	s1,a2,80005dce <sys_recv+0x70>
      kfree(packet);
      return payload_len;
    }
  }

  release(&netlock);
    80005dde:	0001c517          	auipc	a0,0x1c
    80005de2:	0f250513          	addi	a0,a0,242 # 80021ed0 <netlock>
    80005de6:	ea5fa0ef          	jal	80000c8a <release>
  return -1;
    80005dea:	54fd                	li	s1,-1
}
    80005dec:	8526                	mv	a0,s1
    80005dee:	70a6                	ld	ra,104(sp)
    80005df0:	7406                	ld	s0,96(sp)
    80005df2:	64e6                	ld	s1,88(sp)
    80005df4:	6946                	ld	s2,80(sp)
    80005df6:	6165                	addi	sp,sp,112
    80005df8:	8082                	ret
    80005dfa:	e4ce                	sd	s3,72(sp)
    80005dfc:	e0d2                	sd	s4,64(sp)
    80005dfe:	fc56                	sd	s5,56(sp)
      release(&netlock);
    80005e00:	0001c517          	auipc	a0,0x1c
    80005e04:	0d050513          	addi	a0,a0,208 # 80021ed0 <netlock>
    80005e08:	e83fa0ef          	jal	80000c8a <release>
      acquire(&queue->buf_lock);
    80005e0c:	0a800a93          	li	s5,168
    80005e10:	03548ab3          	mul	s5,s1,s5
    80005e14:	008a8a13          	addi	s4,s5,8
    80005e18:	0001c997          	auipc	s3,0x1c
    80005e1c:	0d098993          	addi	s3,s3,208 # 80021ee8 <bound_ports>
    80005e20:	9a4e                	add	s4,s4,s3
    80005e22:	8552                	mv	a0,s4
    80005e24:	dd3fa0ef          	jal	80000bf6 <acquire>
      while (queue->head == queue->tail) {
    80005e28:	99d6                	add	s3,s3,s5
    80005e2a:	0a09a783          	lw	a5,160(s3)
    80005e2e:	0a49a703          	lw	a4,164(s3)
    80005e32:	02f71f63          	bne	a4,a5,80005e70 <sys_recv+0x112>
        sleep(&queue->head, &queue->buf_lock);
    80005e36:	0001c797          	auipc	a5,0x1c
    80005e3a:	15278793          	addi	a5,a5,338 # 80021f88 <bound_ports+0xa0>
    80005e3e:	9abe                	add	s5,s5,a5
      while (queue->head == queue->tail) {
    80005e40:	0a800793          	li	a5,168
    80005e44:	02f487b3          	mul	a5,s1,a5
    80005e48:	0001c997          	auipc	s3,0x1c
    80005e4c:	0a098993          	addi	s3,s3,160 # 80021ee8 <bound_ports>
    80005e50:	99be                	add	s3,s3,a5
        if (killed(p)) {
    80005e52:	854a                	mv	a0,s2
    80005e54:	b02fc0ef          	jal	80002156 <killed>
    80005e58:	10051663          	bnez	a0,80005f64 <sys_recv+0x206>
        sleep(&queue->head, &queue->buf_lock);
    80005e5c:	85d2                	mv	a1,s4
    80005e5e:	8556                	mv	a0,s5
    80005e60:	8befc0ef          	jal	80001f1e <sleep>
      while (queue->head == queue->tail) {
    80005e64:	0a09a783          	lw	a5,160(s3)
    80005e68:	0a49a703          	lw	a4,164(s3)
    80005e6c:	fef703e3          	beq	a4,a5,80005e52 <sys_recv+0xf4>
      char *packet = queue->bufs[queue->head];
    80005e70:	0001c697          	auipc	a3,0x1c
    80005e74:	07868693          	addi	a3,a3,120 # 80021ee8 <bound_ports>
    80005e78:	00249713          	slli	a4,s1,0x2
    80005e7c:	9726                	add	a4,a4,s1
    80005e7e:	070a                	slli	a4,a4,0x2
    80005e80:	9726                	add	a4,a4,s1
    80005e82:	973e                	add	a4,a4,a5
    80005e84:	0709                	addi	a4,a4,2 # 1002 <_entry-0x7fffeffe>
    80005e86:	070e                	slli	a4,a4,0x3
    80005e88:	9736                	add	a4,a4,a3
    80005e8a:	01073983          	ld	s3,16(a4)
      queue->head = (queue->head + 1) % RX_BUF_SIZE;
    80005e8e:	0a800713          	li	a4,168
    80005e92:	02e484b3          	mul	s1,s1,a4
    80005e96:	96a6                	add	a3,a3,s1
    80005e98:	2785                	addiw	a5,a5,1
    80005e9a:	41f7d71b          	sraiw	a4,a5,0x1f
    80005e9e:	01c7571b          	srliw	a4,a4,0x1c
    80005ea2:	9fb9                	addw	a5,a5,a4
    80005ea4:	8bbd                	andi	a5,a5,15
    80005ea6:	9f99                	subw	a5,a5,a4
    80005ea8:	0af6a023          	sw	a5,160(a3)
      release(&queue->buf_lock);
    80005eac:	8552                	mv	a0,s4
    80005eae:	dddfa0ef          	jal	80000c8a <release>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
    80005eb2:	0269d783          	lhu	a5,38(s3)
    80005eb6:	0087da13          	srli	s4,a5,0x8
    80005eba:	0087979b          	slliw	a5,a5,0x8
    80005ebe:	00fa6a33          	or	s4,s4,a5
      int payload_len = ntohs(udp->ulen) - sizeof(struct udp);
    80005ec2:	010a1a1b          	slliw	s4,s4,0x10
    80005ec6:	010a5a1b          	srliw	s4,s4,0x10
    80005eca:	3a61                	addiw	s4,s4,-8
      if (payload_len > maxlen) {
    80005ecc:	f9c42783          	lw	a5,-100(s0)
    80005ed0:	0b47c263          	blt	a5,s4,80005f74 <sys_recv+0x216>
      uint32 sip = ntohl(ip->ip_src);
    80005ed4:	01a9a783          	lw	a5,26(s3)
          ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val)
{
  return (((val & 0x000000ffUL) << 24) |
    80005ed8:	0187971b          	slliw	a4,a5,0x18
          ((val & 0x0000ff00UL) << 8) |
          ((val & 0x00ff0000UL) >> 8) |
          ((val & 0xff000000UL) >> 24));
    80005edc:	0187d69b          	srliw	a3,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005ee0:	8f55                	or	a4,a4,a3
          ((val & 0x0000ff00UL) << 8) |
    80005ee2:	0087969b          	slliw	a3,a5,0x8
    80005ee6:	00ff0637          	lui	a2,0xff0
    80005eea:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80005eec:	8f55                	or	a4,a4,a3
    80005eee:	0087d79b          	srliw	a5,a5,0x8
    80005ef2:	66c1                	lui	a3,0x10
    80005ef4:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80005ef8:	8ff5                	and	a5,a5,a3
    80005efa:	8fd9                	or	a5,a5,a4
    80005efc:	f8f42c23          	sw	a5,-104(s0)
  return (((val & 0x00ffU) << 8) |
    80005f00:	0229d783          	lhu	a5,34(s3)
    80005f04:	0087d713          	srli	a4,a5,0x8
    80005f08:	0087979b          	slliw	a5,a5,0x8
    80005f0c:	8fd9                	or	a5,a5,a4
      uint16 udp_sport = ntohs(udp->sport);
    80005f0e:	f8f41b23          	sh	a5,-106(s0)
      if (copyout(p->pagetable, src_addr, (char *)&sip, sizeof(sip)) < 0) {
    80005f12:	4691                	li	a3,4
    80005f14:	f9840613          	addi	a2,s0,-104
    80005f18:	fb043583          	ld	a1,-80(s0)
    80005f1c:	05093503          	ld	a0,80(s2)
    80005f20:	f26fb0ef          	jal	80001646 <copyout>
    80005f24:	06054063          	bltz	a0,80005f84 <sys_recv+0x226>
      if (copyout(p->pagetable, sport_addr, (char *)&udp_sport, sizeof(udp_sport)) < 0) {
    80005f28:	4689                	li	a3,2
    80005f2a:	f9640613          	addi	a2,s0,-106
    80005f2e:	fa843583          	ld	a1,-88(s0)
    80005f32:	05093503          	ld	a0,80(s2)
    80005f36:	f10fb0ef          	jal	80001646 <copyout>
    80005f3a:	04054d63          	bltz	a0,80005f94 <sys_recv+0x236>
      if (copyout(p->pagetable, bufaddr, (char *)(udp + 1), payload_len) < 0) {
    80005f3e:	84d2                	mv	s1,s4
    80005f40:	86d2                	mv	a3,s4
    80005f42:	02a98613          	addi	a2,s3,42
    80005f46:	fa043583          	ld	a1,-96(s0)
    80005f4a:	05093503          	ld	a0,80(s2)
    80005f4e:	ef8fb0ef          	jal	80001646 <copyout>
    80005f52:	04054963          	bltz	a0,80005fa4 <sys_recv+0x246>
      kfree(packet);
    80005f56:	854e                	mv	a0,s3
    80005f58:	ae9fa0ef          	jal	80000a40 <kfree>
      return payload_len;
    80005f5c:	69a6                	ld	s3,72(sp)
    80005f5e:	6a06                	ld	s4,64(sp)
    80005f60:	7ae2                	ld	s5,56(sp)
    80005f62:	b569                	j	80005dec <sys_recv+0x8e>
          release(&queue->buf_lock);
    80005f64:	8552                	mv	a0,s4
    80005f66:	d25fa0ef          	jal	80000c8a <release>
          return -1;
    80005f6a:	54fd                	li	s1,-1
    80005f6c:	69a6                	ld	s3,72(sp)
    80005f6e:	6a06                	ld	s4,64(sp)
    80005f70:	7ae2                	ld	s5,56(sp)
    80005f72:	bdad                	j	80005dec <sys_recv+0x8e>
        kfree(packet);
    80005f74:	854e                	mv	a0,s3
    80005f76:	acbfa0ef          	jal	80000a40 <kfree>
        return -1; // payload too large for user buffer
    80005f7a:	54fd                	li	s1,-1
    80005f7c:	69a6                	ld	s3,72(sp)
    80005f7e:	6a06                	ld	s4,64(sp)
    80005f80:	7ae2                	ld	s5,56(sp)
    80005f82:	b5ad                	j	80005dec <sys_recv+0x8e>
        kfree(packet);
    80005f84:	854e                	mv	a0,s3
    80005f86:	abbfa0ef          	jal	80000a40 <kfree>
        return -1;
    80005f8a:	54fd                	li	s1,-1
    80005f8c:	69a6                	ld	s3,72(sp)
    80005f8e:	6a06                	ld	s4,64(sp)
    80005f90:	7ae2                	ld	s5,56(sp)
    80005f92:	bda9                	j	80005dec <sys_recv+0x8e>
        kfree(packet);
    80005f94:	854e                	mv	a0,s3
    80005f96:	aabfa0ef          	jal	80000a40 <kfree>
        return -1;
    80005f9a:	54fd                	li	s1,-1
    80005f9c:	69a6                	ld	s3,72(sp)
    80005f9e:	6a06                	ld	s4,64(sp)
    80005fa0:	7ae2                	ld	s5,56(sp)
    80005fa2:	b5a9                	j	80005dec <sys_recv+0x8e>
        kfree(packet);
    80005fa4:	854e                	mv	a0,s3
    80005fa6:	a9bfa0ef          	jal	80000a40 <kfree>
        return -1;
    80005faa:	54fd                	li	s1,-1
    80005fac:	69a6                	ld	s3,72(sp)
    80005fae:	6a06                	ld	s4,64(sp)
    80005fb0:	7ae2                	ld	s5,56(sp)
    80005fb2:	bd2d                	j	80005dec <sys_recv+0x8e>

0000000080005fb4 <sys_send>:
//
// send(int sport, int dst, int dport, char *buf, int len)
//
uint64
sys_send(void)
{
    80005fb4:	715d                	addi	sp,sp,-80
    80005fb6:	e486                	sd	ra,72(sp)
    80005fb8:	e0a2                	sd	s0,64(sp)
    80005fba:	f84a                	sd	s2,48(sp)
    80005fbc:	f44e                	sd	s3,40(sp)
    80005fbe:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80005fc0:	955fb0ef          	jal	80001914 <myproc>
    80005fc4:	89aa                	mv	s3,a0
  int dst;
  int dport;
  uint64 bufaddr;
  int len;

  argint(0, &sport);
    80005fc6:	fcc40593          	addi	a1,s0,-52
    80005fca:	4501                	li	a0,0
    80005fcc:	8abfc0ef          	jal	80002876 <argint>
  argint(1, &dst);
    80005fd0:	fc840593          	addi	a1,s0,-56
    80005fd4:	4505                	li	a0,1
    80005fd6:	8a1fc0ef          	jal	80002876 <argint>
  argint(2, &dport);
    80005fda:	fc440593          	addi	a1,s0,-60
    80005fde:	4509                	li	a0,2
    80005fe0:	897fc0ef          	jal	80002876 <argint>
  argaddr(3, &bufaddr);
    80005fe4:	fb840593          	addi	a1,s0,-72
    80005fe8:	450d                	li	a0,3
    80005fea:	8a9fc0ef          	jal	80002892 <argaddr>
  argint(4, &len);
    80005fee:	fb440593          	addi	a1,s0,-76
    80005ff2:	4511                	li	a0,4
    80005ff4:	883fc0ef          	jal	80002876 <argint>

  int total = len + sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);
    80005ff8:	fb442903          	lw	s2,-76(s0)
    80005ffc:	02a9091b          	addiw	s2,s2,42
  if(total > PGSIZE)
    80006000:	6785                	lui	a5,0x1
    return -1;
    80006002:	557d                	li	a0,-1
  if(total > PGSIZE)
    80006004:	1727c163          	blt	a5,s2,80006166 <sys_send+0x1b2>
    80006008:	fc26                	sd	s1,56(sp)

  char *buf = kalloc();
    8000600a:	b19fa0ef          	jal	80000b22 <kalloc>
    8000600e:	84aa                	mv	s1,a0
  if(buf == 0){
    80006010:	16050163          	beqz	a0,80006172 <sys_send+0x1be>
    printf("sys_send: kalloc failed\n");
    return -1;
  }
  memset(buf, 0, PGSIZE);
    80006014:	6605                	lui	a2,0x1
    80006016:	4581                	li	a1,0
    80006018:	caffa0ef          	jal	80000cc6 <memset>

  struct eth *eth = (struct eth *) buf;
  memmove(eth->dhost, host_mac, ETHADDR_LEN);
    8000601c:	4619                	li	a2,6
    8000601e:	00003597          	auipc	a1,0x3
    80006022:	92a58593          	addi	a1,a1,-1750 # 80008948 <host_mac>
    80006026:	8526                	mv	a0,s1
    80006028:	d03fa0ef          	jal	80000d2a <memmove>
  memmove(eth->shost, local_mac, ETHADDR_LEN);
    8000602c:	4619                	li	a2,6
    8000602e:	00003597          	auipc	a1,0x3
    80006032:	92258593          	addi	a1,a1,-1758 # 80008950 <local_mac>
    80006036:	00c48533          	add	a0,s1,a2
    8000603a:	cf1fa0ef          	jal	80000d2a <memmove>
  eth->type = htons(ETHTYPE_IP);
    8000603e:	47a1                	li	a5,8
    80006040:	00f48623          	sb	a5,12(s1)
    80006044:	000486a3          	sb	zero,13(s1)

  struct ip *ip = (struct ip *)(eth + 1);
    80006048:	00e48713          	addi	a4,s1,14
  ip->ip_vhl = 0x45; // version 4, header length 4*5
    8000604c:	04500793          	li	a5,69
    80006050:	00f48723          	sb	a5,14(s1)
  ip->ip_tos = 0;
    80006054:	000487a3          	sb	zero,15(s1)
  ip->ip_len = htons(sizeof(struct ip) + sizeof(struct udp) + len);
    80006058:	fb442683          	lw	a3,-76(s0)
    8000605c:	03069593          	slli	a1,a3,0x30
    80006060:	91c1                	srli	a1,a1,0x30
    80006062:	01c5861b          	addiw	a2,a1,28
    80006066:	0106179b          	slliw	a5,a2,0x10
    8000606a:	0107d79b          	srliw	a5,a5,0x10
    8000606e:	0087d79b          	srliw	a5,a5,0x8
    80006072:	0086161b          	slliw	a2,a2,0x8
    80006076:	8fd1                	or	a5,a5,a2
    80006078:	00f49823          	sh	a5,16(s1)
  ip->ip_id = 0;
    8000607c:	00049923          	sh	zero,18(s1)
  ip->ip_off = 0;
    80006080:	00049a23          	sh	zero,20(s1)
  ip->ip_ttl = 100;
    80006084:	06400793          	li	a5,100
    80006088:	00f48b23          	sb	a5,22(s1)
  ip->ip_p = IPPROTO_UDP;
    8000608c:	47c5                	li	a5,17
    8000608e:	00f48ba3          	sb	a5,23(s1)
  ip->ip_src = htonl(local_ip);
    80006092:	0f0207b7          	lui	a5,0xf020
    80006096:	07a9                	addi	a5,a5,10 # f02000a <_entry-0x70fdfff6>
    80006098:	00f4ad23          	sw	a5,26(s1)
  ip->ip_dst = htonl(dst);
    8000609c:	fc842783          	lw	a5,-56(s0)
  return (((val & 0x000000ffUL) << 24) |
    800060a0:	0187961b          	slliw	a2,a5,0x18
          ((val & 0xff000000UL) >> 24));
    800060a4:	0187d51b          	srliw	a0,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    800060a8:	8e49                	or	a2,a2,a0
          ((val & 0x0000ff00UL) << 8) |
    800060aa:	0087951b          	slliw	a0,a5,0x8
    800060ae:	00ff0837          	lui	a6,0xff0
    800060b2:	01057533          	and	a0,a0,a6
          ((val & 0x00ff0000UL) >> 8) |
    800060b6:	8e49                	or	a2,a2,a0
    800060b8:	0087d79b          	srliw	a5,a5,0x8
    800060bc:	6541                	lui	a0,0x10
    800060be:	f0050513          	addi	a0,a0,-256 # ff00 <_entry-0x7fff0100>
    800060c2:	8fe9                	and	a5,a5,a0
    800060c4:	8fd1                	or	a5,a5,a2
    800060c6:	00f4af23          	sw	a5,30(s1)
  while (nleft > 1)  {
    800060ca:	02248813          	addi	a6,s1,34
  unsigned int sum = 0;
    800060ce:	4601                	li	a2,0
    sum += *w++;
    800060d0:	0709                	addi	a4,a4,2
    800060d2:	ffe75783          	lhu	a5,-2(a4)
    800060d6:	9fb1                	addw	a5,a5,a2
    800060d8:	863e                	mv	a2,a5
  while (nleft > 1)  {
    800060da:	ff071be3          	bne	a4,a6,800060d0 <sys_send+0x11c>
  sum = (sum & 0xffff) + (sum >> 16);
    800060de:	03079713          	slli	a4,a5,0x30
    800060e2:	9341                	srli	a4,a4,0x30
    800060e4:	0107d79b          	srliw	a5,a5,0x10
    800060e8:	9fb9                	addw	a5,a5,a4
  sum += (sum >> 16);
    800060ea:	0107d71b          	srliw	a4,a5,0x10
    800060ee:	9fb9                	addw	a5,a5,a4
  answer = ~sum; /* truncate to 16 bits */
    800060f0:	fff7c793          	not	a5,a5
  ip->ip_sum = in_cksum((unsigned char *)ip, sizeof(*ip));
    800060f4:	00f49c23          	sh	a5,24(s1)

  struct udp *udp = (struct udp *)(ip + 1);
  udp->sport = htons(sport);
    800060f8:	fcc42703          	lw	a4,-52(s0)
  return (((val & 0x00ffU) << 8) |
    800060fc:	0107179b          	slliw	a5,a4,0x10
    80006100:	0107d79b          	srliw	a5,a5,0x10
    80006104:	0087d79b          	srliw	a5,a5,0x8
    80006108:	0087171b          	slliw	a4,a4,0x8
    8000610c:	8fd9                	or	a5,a5,a4
    8000610e:	02f49123          	sh	a5,34(s1)
  udp->dport = htons(dport);
    80006112:	fc442703          	lw	a4,-60(s0)
    80006116:	0107179b          	slliw	a5,a4,0x10
    8000611a:	0107d79b          	srliw	a5,a5,0x10
    8000611e:	0087d79b          	srliw	a5,a5,0x8
    80006122:	0087171b          	slliw	a4,a4,0x8
    80006126:	8fd9                	or	a5,a5,a4
    80006128:	02f49223          	sh	a5,36(s1)
  udp->ulen = htons(len + sizeof(struct udp));
    8000612c:	0085879b          	addiw	a5,a1,8
    80006130:	0107971b          	slliw	a4,a5,0x10
    80006134:	0107571b          	srliw	a4,a4,0x10
    80006138:	0087571b          	srliw	a4,a4,0x8
    8000613c:	0087979b          	slliw	a5,a5,0x8
    80006140:	8fd9                	or	a5,a5,a4
    80006142:	02f49323          	sh	a5,38(s1)

  char *payload = (char *)(udp + 1);
  if(copyin(p->pagetable, payload, bufaddr, len) < 0){
    80006146:	fb843603          	ld	a2,-72(s0)
    8000614a:	02a48593          	addi	a1,s1,42
    8000614e:	0509b503          	ld	a0,80(s3)
    80006152:	db2fb0ef          	jal	80001704 <copyin>
    80006156:	02054763          	bltz	a0,80006184 <sys_send+0x1d0>
    kfree(buf);
    printf("send: copyin failed\n");
    return -1;
  }

  e1000_transmit(buf, total);
    8000615a:	85ca                	mv	a1,s2
    8000615c:	8526                	mv	a0,s1
    8000615e:	a31ff0ef          	jal	80005b8e <e1000_transmit>

  return 0;
    80006162:	4501                	li	a0,0
    80006164:	74e2                	ld	s1,56(sp)
}
    80006166:	60a6                	ld	ra,72(sp)
    80006168:	6406                	ld	s0,64(sp)
    8000616a:	7942                	ld	s2,48(sp)
    8000616c:	79a2                	ld	s3,40(sp)
    8000616e:	6161                	addi	sp,sp,80
    80006170:	8082                	ret
    printf("sys_send: kalloc failed\n");
    80006172:	00002517          	auipc	a0,0x2
    80006176:	5de50513          	addi	a0,a0,1502 # 80008750 <etext+0x750>
    8000617a:	b80fa0ef          	jal	800004fa <printf>
    return -1;
    8000617e:	557d                	li	a0,-1
    80006180:	74e2                	ld	s1,56(sp)
    80006182:	b7d5                	j	80006166 <sys_send+0x1b2>
    kfree(buf);
    80006184:	8526                	mv	a0,s1
    80006186:	8bbfa0ef          	jal	80000a40 <kfree>
    printf("send: copyin failed\n");
    8000618a:	00002517          	auipc	a0,0x2
    8000618e:	5e650513          	addi	a0,a0,1510 # 80008770 <etext+0x770>
    80006192:	b68fa0ef          	jal	800004fa <printf>
    return -1;
    80006196:	557d                	li	a0,-1
    80006198:	74e2                	ld	s1,56(sp)
    8000619a:	b7f1                	j	80006166 <sys_send+0x1b2>

000000008000619c <ip_rx>:

void
ip_rx(char *buf, int len)
{
    8000619c:	7139                	addi	sp,sp,-64
    8000619e:	fc06                	sd	ra,56(sp)
    800061a0:	f822                	sd	s0,48(sp)
    800061a2:	f426                	sd	s1,40(sp)
    800061a4:	0080                	addi	s0,sp,64
    800061a6:	84aa                	mv	s1,a0
  // don't delete this printf; make grade depends on it.
  static int seen_ip = 0;
  if(seen_ip == 0)
    800061a8:	00002797          	auipc	a5,0x2
    800061ac:	7f47a783          	lw	a5,2036(a5) # 8000899c <seen_ip.1>
    800061b0:	cf85                	beqz	a5,800061e8 <ip_rx+0x4c>
    printf("ip_rx: received an IP packet\n");
  seen_ip = 1;
    800061b2:	4785                	li	a5,1
    800061b4:	00002717          	auipc	a4,0x2
    800061b8:	7ef72423          	sw	a5,2024(a4) # 8000899c <seen_ip.1>

  struct eth *eth = (struct eth *) buf;

  struct ip *ip = (struct ip *)(eth + 1);
  if (ntohs(eth->type) != ETHTYPE_IP || ip->ip_p != IPPROTO_UDP) {
    800061bc:	00c4c703          	lbu	a4,12(s1)
    800061c0:	00d4c783          	lbu	a5,13(s1)
    800061c4:	07a2                	slli	a5,a5,0x8
    800061c6:	8fd9                	or	a5,a5,a4
    800061c8:	4721                	li	a4,8
    800061ca:	00e79763          	bne	a5,a4,800061d8 <ip_rx+0x3c>
    800061ce:	0174c703          	lbu	a4,23(s1)
    800061d2:	47c5                	li	a5,17
    800061d4:	02f70163          	beq	a4,a5,800061f6 <ip_rx+0x5a>
    kfree(buf);
    800061d8:	8526                	mv	a0,s1
    800061da:	867fa0ef          	jal	80000a40 <kfree>
    }
  }
  release(&netlock);
  kfree(buf);
  
}
    800061de:	70e2                	ld	ra,56(sp)
    800061e0:	7442                	ld	s0,48(sp)
    800061e2:	74a2                	ld	s1,40(sp)
    800061e4:	6121                	addi	sp,sp,64
    800061e6:	8082                	ret
    printf("ip_rx: received an IP packet\n");
    800061e8:	00002517          	auipc	a0,0x2
    800061ec:	5a050513          	addi	a0,a0,1440 # 80008788 <etext+0x788>
    800061f0:	b0afa0ef          	jal	800004fa <printf>
    800061f4:	bf7d                	j	800061b2 <ip_rx+0x16>
    800061f6:	f04a                	sd	s2,32(sp)
    800061f8:	ec4e                	sd	s3,24(sp)
    800061fa:	0244d783          	lhu	a5,36(s1)
    800061fe:	0087d993          	srli	s3,a5,0x8
    80006202:	0087979b          	slliw	a5,a5,0x8
    80006206:	00f9e9b3          	or	s3,s3,a5
  int dport = ntohs(udp->dport);
    8000620a:	19c2                	slli	s3,s3,0x30
    8000620c:	0309d993          	srli	s3,s3,0x30
  acquire(&netlock);
    80006210:	0001c517          	auipc	a0,0x1c
    80006214:	cc050513          	addi	a0,a0,-832 # 80021ed0 <netlock>
    80006218:	9dffa0ef          	jal	80000bf6 <acquire>
  for (int i = 0; i < 16; i++) {
    8000621c:	0001c797          	auipc	a5,0x1c
    80006220:	ccc78793          	addi	a5,a5,-820 # 80021ee8 <bound_ports>
    80006224:	4901                	li	s2,0
    80006226:	46c1                	li	a3,16
    if (bound_ports[i].port == dport) {
    80006228:	4398                	lw	a4,0(a5)
    8000622a:	03370363          	beq	a4,s3,80006250 <ip_rx+0xb4>
  for (int i = 0; i < 16; i++) {
    8000622e:	2905                	addiw	s2,s2,1
    80006230:	0a878793          	addi	a5,a5,168
    80006234:	fed91ae3          	bne	s2,a3,80006228 <ip_rx+0x8c>
  release(&netlock);
    80006238:	0001c517          	auipc	a0,0x1c
    8000623c:	c9850513          	addi	a0,a0,-872 # 80021ed0 <netlock>
    80006240:	a4bfa0ef          	jal	80000c8a <release>
  kfree(buf);
    80006244:	8526                	mv	a0,s1
    80006246:	ffafa0ef          	jal	80000a40 <kfree>
    8000624a:	7902                	ld	s2,32(sp)
    8000624c:	69e2                	ld	s3,24(sp)
    8000624e:	bf41                	j	800061de <ip_rx+0x42>
    80006250:	e852                	sd	s4,16(sp)
    80006252:	e456                	sd	s5,8(sp)
      acquire(&queue->buf_lock);
    80006254:	0a800993          	li	s3,168
    80006258:	033909b3          	mul	s3,s2,s3
    8000625c:	00898a13          	addi	s4,s3,8
    80006260:	0001ca97          	auipc	s5,0x1c
    80006264:	c88a8a93          	addi	s5,s5,-888 # 80021ee8 <bound_ports>
    80006268:	9a56                	add	s4,s4,s5
    8000626a:	8552                	mv	a0,s4
    8000626c:	98bfa0ef          	jal	80000bf6 <acquire>
      if ((queue->tail + 1) % RX_BUF_SIZE == queue->head) {
    80006270:	9ace                	add	s5,s5,s3
    80006272:	0a4aa603          	lw	a2,164(s5)
    80006276:	0016079b          	addiw	a5,a2,1 # 1001 <_entry-0x7fffefff>
    8000627a:	41f7d69b          	sraiw	a3,a5,0x1f
    8000627e:	01c6d69b          	srliw	a3,a3,0x1c
    80006282:	00f6873b          	addw	a4,a3,a5
    80006286:	8b3d                	andi	a4,a4,15
    80006288:	9f15                	subw	a4,a4,a3
    8000628a:	0a0aa783          	lw	a5,160(s5)
    8000628e:	04e78a63          	beq	a5,a4,800062e2 <ip_rx+0x146>
      queue->bufs[queue->tail] = buf;
    80006292:	0001c517          	auipc	a0,0x1c
    80006296:	c5650513          	addi	a0,a0,-938 # 80021ee8 <bound_ports>
    8000629a:	00291793          	slli	a5,s2,0x2
    8000629e:	97ca                	add	a5,a5,s2
    800062a0:	078a                	slli	a5,a5,0x2
    800062a2:	97ca                	add	a5,a5,s2
    800062a4:	97b2                	add	a5,a5,a2
    800062a6:	0789                	addi	a5,a5,2
    800062a8:	078e                	slli	a5,a5,0x3
    800062aa:	97aa                	add	a5,a5,a0
    800062ac:	eb84                	sd	s1,16(a5)
      queue->tail = (queue->tail + 1) % RX_BUF_SIZE;
    800062ae:	0a800793          	li	a5,168
    800062b2:	02f90933          	mul	s2,s2,a5
    800062b6:	992a                	add	s2,s2,a0
    800062b8:	0ae92223          	sw	a4,164(s2)
      wakeup(&queue->head);
    800062bc:	0a098993          	addi	s3,s3,160
    800062c0:	954e                	add	a0,a0,s3
    800062c2:	ca9fb0ef          	jal	80001f6a <wakeup>
      release(&queue->buf_lock);
    800062c6:	8552                	mv	a0,s4
    800062c8:	9c3fa0ef          	jal	80000c8a <release>
      release(&netlock);
    800062cc:	0001c517          	auipc	a0,0x1c
    800062d0:	c0450513          	addi	a0,a0,-1020 # 80021ed0 <netlock>
    800062d4:	9b7fa0ef          	jal	80000c8a <release>
      return;
    800062d8:	7902                	ld	s2,32(sp)
    800062da:	69e2                	ld	s3,24(sp)
    800062dc:	6a42                	ld	s4,16(sp)
    800062de:	6aa2                	ld	s5,8(sp)
    800062e0:	bdfd                	j	800061de <ip_rx+0x42>
        release(&queue->buf_lock);
    800062e2:	8552                	mv	a0,s4
    800062e4:	9a7fa0ef          	jal	80000c8a <release>
        release(&netlock);
    800062e8:	0001c517          	auipc	a0,0x1c
    800062ec:	be850513          	addi	a0,a0,-1048 # 80021ed0 <netlock>
    800062f0:	99bfa0ef          	jal	80000c8a <release>
        kfree(buf);
    800062f4:	8526                	mv	a0,s1
    800062f6:	f4afa0ef          	jal	80000a40 <kfree>
        return;
    800062fa:	7902                	ld	s2,32(sp)
    800062fc:	69e2                	ld	s3,24(sp)
    800062fe:	6a42                	ld	s4,16(sp)
    80006300:	6aa2                	ld	s5,8(sp)
    80006302:	bdf1                	j	800061de <ip_rx+0x42>

0000000080006304 <arp_rx>:
// qemu to send IP packets to xv6; the real ARP
// protocol is more complex.
//
void
arp_rx(char *inbuf)
{
    80006304:	7139                	addi	sp,sp,-64
    80006306:	fc06                	sd	ra,56(sp)
    80006308:	f822                	sd	s0,48(sp)
    8000630a:	f04a                	sd	s2,32(sp)
    8000630c:	0080                	addi	s0,sp,64
    8000630e:	892a                	mv	s2,a0
  static int seen_arp = 0;

  if(seen_arp){
    80006310:	00002797          	auipc	a5,0x2
    80006314:	6887a783          	lw	a5,1672(a5) # 80008998 <seen_arp.0>
    80006318:	10079463          	bnez	a5,80006420 <arp_rx+0x11c>
    8000631c:	f426                	sd	s1,40(sp)
    8000631e:	ec4e                	sd	s3,24(sp)
    80006320:	e852                	sd	s4,16(sp)
    80006322:	e456                	sd	s5,8(sp)
    kfree(inbuf);
    return;
  }
  printf("arp_rx: received an ARP packet\n");
    80006324:	00002517          	auipc	a0,0x2
    80006328:	48450513          	addi	a0,a0,1156 # 800087a8 <etext+0x7a8>
    8000632c:	9cefa0ef          	jal	800004fa <printf>
  seen_arp = 1;
    80006330:	4785                	li	a5,1
    80006332:	00002717          	auipc	a4,0x2
    80006336:	66f72323          	sw	a5,1638(a4) # 80008998 <seen_arp.0>

  struct eth *ineth = (struct eth *) inbuf;
  struct arp *inarp = (struct arp *) (ineth + 1);

  char *buf = kalloc();
    8000633a:	fe8fa0ef          	jal	80000b22 <kalloc>
    8000633e:	84aa                	mv	s1,a0
  if(buf == 0)
    80006340:	0e050363          	beqz	a0,80006426 <arp_rx+0x122>
    panic("send_arp_reply");
  
  struct eth *eth = (struct eth *) buf;
  memmove(eth->dhost, ineth->shost, ETHADDR_LEN); // ethernet destination = query source
    80006344:	00690a13          	addi	s4,s2,6
    80006348:	4619                	li	a2,6
    8000634a:	85d2                	mv	a1,s4
    8000634c:	9dffa0ef          	jal	80000d2a <memmove>
  memmove(eth->shost, local_mac, ETHADDR_LEN); // ethernet source = xv6's ethernet address
    80006350:	4619                	li	a2,6
    80006352:	00002597          	auipc	a1,0x2
    80006356:	5fe58593          	addi	a1,a1,1534 # 80008950 <local_mac>
    8000635a:	00c48533          	add	a0,s1,a2
    8000635e:	9cdfa0ef          	jal	80000d2a <memmove>
  eth->type = htons(ETHTYPE_ARP);
    80006362:	47a1                	li	a5,8
    80006364:	00f48623          	sb	a5,12(s1)
    80006368:	4719                	li	a4,6
    8000636a:	00e486a3          	sb	a4,13(s1)

  struct arp *arp = (struct arp *)(eth + 1);
  arp->hrd = htons(ARP_HRD_ETHER);
    8000636e:	00048723          	sb	zero,14(s1)
    80006372:	4705                	li	a4,1
    80006374:	00e487a3          	sb	a4,15(s1)
  arp->pro = htons(ETHTYPE_IP);
    80006378:	00f48823          	sb	a5,16(s1)
    8000637c:	000488a3          	sb	zero,17(s1)
  arp->hln = ETHADDR_LEN;
    80006380:	4999                	li	s3,6
    80006382:	01348923          	sb	s3,18(s1)
  arp->pln = sizeof(uint32);
    80006386:	4791                	li	a5,4
    80006388:	00f489a3          	sb	a5,19(s1)
  arp->op = htons(ARP_OP_REPLY);
    8000638c:	00048a23          	sb	zero,20(s1)
    80006390:	4a89                	li	s5,2
    80006392:	01548aa3          	sb	s5,21(s1)

  memmove(arp->sha, local_mac, ETHADDR_LEN);
    80006396:	864e                	mv	a2,s3
    80006398:	00002597          	auipc	a1,0x2
    8000639c:	5b858593          	addi	a1,a1,1464 # 80008950 <local_mac>
    800063a0:	01648513          	addi	a0,s1,22
    800063a4:	987fa0ef          	jal	80000d2a <memmove>
  arp->sip = htonl(local_ip);
    800063a8:	47a9                	li	a5,10
    800063aa:	00f48e23          	sb	a5,28(s1)
    800063ae:	00048ea3          	sb	zero,29(s1)
    800063b2:	01548f23          	sb	s5,30(s1)
    800063b6:	47bd                	li	a5,15
    800063b8:	00f48fa3          	sb	a5,31(s1)
  memmove(arp->tha, ineth->shost, ETHADDR_LEN);
    800063bc:	864e                	mv	a2,s3
    800063be:	85d2                	mv	a1,s4
    800063c0:	02048513          	addi	a0,s1,32
    800063c4:	967fa0ef          	jal	80000d2a <memmove>
  arp->tip = inarp->sip;
    800063c8:	01c94703          	lbu	a4,28(s2)
    800063cc:	01d94783          	lbu	a5,29(s2)
    800063d0:	07a2                	slli	a5,a5,0x8
    800063d2:	8fd9                	or	a5,a5,a4
    800063d4:	01e94703          	lbu	a4,30(s2)
    800063d8:	0742                	slli	a4,a4,0x10
    800063da:	8f5d                	or	a4,a4,a5
    800063dc:	01f94783          	lbu	a5,31(s2)
    800063e0:	07e2                	slli	a5,a5,0x18
    800063e2:	8fd9                	or	a5,a5,a4
    800063e4:	02f48323          	sb	a5,38(s1)
    800063e8:	0087d713          	srli	a4,a5,0x8
    800063ec:	02e483a3          	sb	a4,39(s1)
    800063f0:	0107d713          	srli	a4,a5,0x10
    800063f4:	02e48423          	sb	a4,40(s1)
    800063f8:	83e1                	srli	a5,a5,0x18
    800063fa:	02f484a3          	sb	a5,41(s1)

  e1000_transmit(buf, sizeof(*eth) + sizeof(*arp));
    800063fe:	02a00593          	li	a1,42
    80006402:	8526                	mv	a0,s1
    80006404:	f8aff0ef          	jal	80005b8e <e1000_transmit>

  kfree(inbuf);
    80006408:	854a                	mv	a0,s2
    8000640a:	e36fa0ef          	jal	80000a40 <kfree>
    8000640e:	74a2                	ld	s1,40(sp)
    80006410:	69e2                	ld	s3,24(sp)
    80006412:	6a42                	ld	s4,16(sp)
    80006414:	6aa2                	ld	s5,8(sp)
}
    80006416:	70e2                	ld	ra,56(sp)
    80006418:	7442                	ld	s0,48(sp)
    8000641a:	7902                	ld	s2,32(sp)
    8000641c:	6121                	addi	sp,sp,64
    8000641e:	8082                	ret
    kfree(inbuf);
    80006420:	e20fa0ef          	jal	80000a40 <kfree>
    return;
    80006424:	bfcd                	j	80006416 <arp_rx+0x112>
    panic("send_arp_reply");
    80006426:	00002517          	auipc	a0,0x2
    8000642a:	3a250513          	addi	a0,a0,930 # 800087c8 <etext+0x7c8>
    8000642e:	bb0fa0ef          	jal	800007de <panic>

0000000080006432 <net_rx>:

void
net_rx(char *buf, int len)
{
    80006432:	1141                	addi	sp,sp,-16
    80006434:	e406                	sd	ra,8(sp)
    80006436:	e022                	sd	s0,0(sp)
    80006438:	0800                	addi	s0,sp,16
  struct eth *eth = (struct eth *) buf;

  if(len >= sizeof(struct eth) + sizeof(struct arp) &&
    8000643a:	02900793          	li	a5,41
    8000643e:	02b7fe63          	bgeu	a5,a1,8000647a <net_rx+0x48>
     ntohs(eth->type) == ETHTYPE_ARP){
    80006442:	00c54703          	lbu	a4,12(a0)
    80006446:	00d54783          	lbu	a5,13(a0)
    8000644a:	07a2                	slli	a5,a5,0x8
  if(len >= sizeof(struct eth) + sizeof(struct arp) &&
    8000644c:	8fd9                	or	a5,a5,a4
    8000644e:	60800713          	li	a4,1544
    80006452:	02e78163          	beq	a5,a4,80006474 <net_rx+0x42>
    arp_rx(buf);
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
     ntohs(eth->type) == ETHTYPE_IP){
    80006456:	00c54703          	lbu	a4,12(a0)
    8000645a:	00d54783          	lbu	a5,13(a0)
    8000645e:	07a2                	slli	a5,a5,0x8
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
    80006460:	8fd9                	or	a5,a5,a4
    80006462:	4721                	li	a4,8
    80006464:	02e78063          	beq	a5,a4,80006484 <net_rx+0x52>
    ip_rx(buf, len);
  } else {
    kfree(buf);
    80006468:	dd8fa0ef          	jal	80000a40 <kfree>
  }
}
    8000646c:	60a2                	ld	ra,8(sp)
    8000646e:	6402                	ld	s0,0(sp)
    80006470:	0141                	addi	sp,sp,16
    80006472:	8082                	ret
    arp_rx(buf);
    80006474:	e91ff0ef          	jal	80006304 <arp_rx>
    80006478:	bfd5                	j	8000646c <net_rx+0x3a>
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
    8000647a:	02100793          	li	a5,33
    8000647e:	feb7f5e3          	bgeu	a5,a1,80006468 <net_rx+0x36>
    80006482:	bfd1                	j	80006456 <net_rx+0x24>
    ip_rx(buf, len);
    80006484:	d19ff0ef          	jal	8000619c <ip_rx>
    80006488:	b7d5                	j	8000646c <net_rx+0x3a>

000000008000648a <pci_init>:
#include "proc.h"
#include "defs.h"

void
pci_init()
{
    8000648a:	715d                	addi	sp,sp,-80
    8000648c:	e486                	sd	ra,72(sp)
    8000648e:	e0a2                	sd	s0,64(sp)
    80006490:	fc26                	sd	s1,56(sp)
    80006492:	f84a                	sd	s2,48(sp)
    80006494:	f44e                	sd	s3,40(sp)
    80006496:	f052                	sd	s4,32(sp)
    80006498:	ec56                	sd	s5,24(sp)
    8000649a:	e85a                	sd	s6,16(sp)
    8000649c:	e45e                	sd	s7,8(sp)
    8000649e:	0880                	addi	s0,sp,80
    800064a0:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];
    
    // 100e:8086 is an e1000
    if(id == 0x100e8086){
    800064a4:	100e8937          	lui	s2,0x100e8
    800064a8:	08690913          	addi	s2,s2,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    800064ac:	4b9d                	li	s7,7
      for(int i = 0; i < 6; i++){
        uint32 old = base[4+i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4+i] = 0xffffffff;
    800064ae:	5afd                	li	s5,-1
        base[4+i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4+0] = e1000_regs;
    800064b0:	40000b37          	lui	s6,0x40000
  for(int dev = 0; dev < 32; dev++){
    800064b4:	6a09                	lui	s4,0x2
    800064b6:	300409b7          	lui	s3,0x30040
    800064ba:	a021                	j	800064c2 <pci_init+0x38>
    800064bc:	94d2                	add	s1,s1,s4
    800064be:	03348f63          	beq	s1,s3,800064fc <pci_init+0x72>
    volatile uint32 *base = ecam + off;
    800064c2:	86a6                	mv	a3,s1
    uint32 id = base[0];
    800064c4:	409c                	lw	a5,0(s1)
    800064c6:	2781                	sext.w	a5,a5
    if(id == 0x100e8086){
    800064c8:	ff279ae3          	bne	a5,s2,800064bc <pci_init+0x32>
      base[1] = 7;
    800064cc:	0174a223          	sw	s7,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    800064d0:	0330000f          	fence	rw,rw
      for(int i = 0; i < 6; i++){
    800064d4:	01048793          	addi	a5,s1,16
    800064d8:	02848613          	addi	a2,s1,40
        uint32 old = base[4+i];
    800064dc:	4398                	lw	a4,0(a5)
    800064de:	2701                	sext.w	a4,a4
        base[4+i] = 0xffffffff;
    800064e0:	0157a023          	sw	s5,0(a5)
        __sync_synchronize();
    800064e4:	0330000f          	fence	rw,rw
        base[4+i] = old;
    800064e8:	c398                	sw	a4,0(a5)
      for(int i = 0; i < 6; i++){
    800064ea:	0791                	addi	a5,a5,4
    800064ec:	fec798e3          	bne	a5,a2,800064dc <pci_init+0x52>
      base[4+0] = e1000_regs;
    800064f0:	0166a823          	sw	s6,16(a3)

      e1000_init((uint32*)e1000_regs);
    800064f4:	855a                	mv	a0,s6
    800064f6:	d30ff0ef          	jal	80005a26 <e1000_init>
    800064fa:	b7c9                	j	800064bc <pci_init+0x32>
    }
  }
}
    800064fc:	60a6                	ld	ra,72(sp)
    800064fe:	6406                	ld	s0,64(sp)
    80006500:	74e2                	ld	s1,56(sp)
    80006502:	7942                	ld	s2,48(sp)
    80006504:	79a2                	ld	s3,40(sp)
    80006506:	7a02                	ld	s4,32(sp)
    80006508:	6ae2                	ld	s5,24(sp)
    8000650a:	6b42                	ld	s6,16(sp)
    8000650c:	6ba2                	ld	s7,8(sp)
    8000650e:	6161                	addi	sp,sp,80
    80006510:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	9282                	jalr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
