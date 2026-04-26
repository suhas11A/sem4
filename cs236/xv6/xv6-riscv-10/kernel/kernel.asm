
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00008117          	auipc	sp,0x8
    80000004:	88010113          	addi	sp,sp,-1920 # 80007880 <stack0>
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
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd877>
    80000076:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000078:	6705                	lui	a4,0x1
    8000007a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000080:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000084:	00001797          	auipc	a5,0x1
    80000088:	dce78793          	addi	a5,a5,-562 # 80000e52 <main>
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
    8000011a:	22c020ef          	jal	80002346 <either_copyin>
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
    80000192:	0000f517          	auipc	a0,0xf
    80000196:	6ee50513          	addi	a0,a0,1774 # 8000f880 <cons>
    8000019a:	233000ef          	jal	80000bcc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	0000f497          	auipc	s1,0xf
    800001a2:	6e248493          	addi	s1,s1,1762 # 8000f880 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	0000f917          	auipc	s2,0xf
    800001aa:	77290913          	addi	s2,s2,1906 # 8000f918 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	700010ef          	jal	800018be <myproc>
    800001c2:	006020ef          	jal	800021c8 <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	55d010ef          	jal	80001f28 <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	0000f717          	auipc	a4,0xf
    800001e2:	6a270713          	addi	a4,a4,1698 # 8000f880 <cons>
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
    80000210:	0ec020ef          	jal	800022fc <either_copyout>
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
    80000228:	0000f517          	auipc	a0,0xf
    8000022c:	65850513          	addi	a0,a0,1624 # 8000f880 <cons>
    80000230:	231000ef          	jal	80000c60 <release>
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
    8000024e:	0000f717          	auipc	a4,0xf
    80000252:	6cf72523          	sw	a5,1738(a4) # 8000f918 <cons+0x98>
    80000256:	6be2                	ld	s7,24(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	ec5e                	sd	s7,24(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	6be2                	ld	s7,24(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000264:	0000f517          	auipc	a0,0xf
    80000268:	61c50513          	addi	a0,a0,1564 # 8000f880 <cons>
    8000026c:	1f5000ef          	jal	80000c60 <release>
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
    800002b8:	0000f517          	auipc	a0,0xf
    800002bc:	5c850513          	addi	a0,a0,1480 # 8000f880 <cons>
    800002c0:	10d000ef          	jal	80000bcc <acquire>

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
    800002da:	0b6020ef          	jal	80002390 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002de:	0000f517          	auipc	a0,0xf
    800002e2:	5a250513          	addi	a0,a0,1442 # 8000f880 <cons>
    800002e6:	17b000ef          	jal	80000c60 <release>
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
    800002fc:	0000f717          	auipc	a4,0xf
    80000300:	58470713          	addi	a4,a4,1412 # 8000f880 <cons>
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
    80000322:	0000f797          	auipc	a5,0xf
    80000326:	55e78793          	addi	a5,a5,1374 # 8000f880 <cons>
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
    8000034e:	0000f797          	auipc	a5,0xf
    80000352:	5ca7a783          	lw	a5,1482(a5) # 8000f918 <cons+0x98>
    80000356:	9f1d                	subw	a4,a4,a5
    80000358:	08000793          	li	a5,128
    8000035c:	f8f711e3          	bne	a4,a5,800002de <consoleintr+0x32>
    80000360:	a85d                	j	80000416 <consoleintr+0x16a>
    80000362:	e84a                	sd	s2,16(sp)
    80000364:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80000366:	0000f717          	auipc	a4,0xf
    8000036a:	51a70713          	addi	a4,a4,1306 # 8000f880 <cons>
    8000036e:	0a072783          	lw	a5,160(a4)
    80000372:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000376:	0000f497          	auipc	s1,0xf
    8000037a:	50a48493          	addi	s1,s1,1290 # 8000f880 <cons>
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
    800003c0:	0000f717          	auipc	a4,0xf
    800003c4:	4c070713          	addi	a4,a4,1216 # 8000f880 <cons>
    800003c8:	0a072783          	lw	a5,160(a4)
    800003cc:	09c72703          	lw	a4,156(a4)
    800003d0:	f0f707e3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003d4:	37fd                	addiw	a5,a5,-1
    800003d6:	0000f717          	auipc	a4,0xf
    800003da:	54f72523          	sw	a5,1354(a4) # 8000f920 <cons+0xa0>
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
    800003f4:	0000f797          	auipc	a5,0xf
    800003f8:	48c78793          	addi	a5,a5,1164 # 8000f880 <cons>
    800003fc:	0a07a703          	lw	a4,160(a5)
    80000400:	0017069b          	addiw	a3,a4,1
    80000404:	8636                	mv	a2,a3
    80000406:	0ad7a023          	sw	a3,160(a5)
    8000040a:	07f77713          	andi	a4,a4,127
    8000040e:	97ba                	add	a5,a5,a4
    80000410:	4729                	li	a4,10
    80000412:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000416:	0000f797          	auipc	a5,0xf
    8000041a:	50c7a323          	sw	a2,1286(a5) # 8000f91c <cons+0x9c>
        wakeup(&cons.r);
    8000041e:	0000f517          	auipc	a0,0xf
    80000422:	4fa50513          	addi	a0,a0,1274 # 8000f918 <cons+0x98>
    80000426:	34f010ef          	jal	80001f74 <wakeup>
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
    80000434:	00007597          	auipc	a1,0x7
    80000438:	bcc58593          	addi	a1,a1,-1076 # 80007000 <etext>
    8000043c:	0000f517          	auipc	a0,0xf
    80000440:	44450513          	addi	a0,a0,1092 # 8000f880 <cons>
    80000444:	704000ef          	jal	80000b48 <initlock>

  uartinit();
    80000448:	3f6000ef          	jal	8000083e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000044c:	00020797          	auipc	a5,0x20
    80000450:	9a478793          	addi	a5,a5,-1628 # 8001fdf0 <devsw>
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
    8000048c:	00007817          	auipc	a6,0x7
    80000490:	28480813          	addi	a6,a6,644 # 80007710 <digits>
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
    80000518:	00007797          	auipc	a5,0x7
    8000051c:	33c7a783          	lw	a5,828(a5) # 80007854 <panicking>
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
    80000560:	0000f517          	auipc	a0,0xf
    80000564:	3c850513          	addi	a0,a0,968 # 8000f928 <pr>
    80000568:	664000ef          	jal	80000bcc <acquire>
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
    80000726:	00007b97          	auipc	s7,0x7
    8000072a:	feab8b93          	addi	s7,s7,-22 # 80007710 <digits>
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
    80000786:	00007917          	auipc	s2,0x7
    8000078a:	88290913          	addi	s2,s2,-1918 # 80007008 <etext+0x8>
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
    800007ba:	00007797          	auipc	a5,0x7
    800007be:	09a7a783          	lw	a5,154(a5) # 80007854 <panicking>
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
    800007d0:	0000f517          	auipc	a0,0xf
    800007d4:	15850513          	addi	a0,a0,344 # 8000f928 <pr>
    800007d8:	488000ef          	jal	80000c60 <release>
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
    800007ee:	00007797          	auipc	a5,0x7
    800007f2:	0727a323          	sw	s2,102(a5) # 80007854 <panicking>
  printf("panic: ");
    800007f6:	00007517          	auipc	a0,0x7
    800007fa:	82250513          	addi	a0,a0,-2014 # 80007018 <etext+0x18>
    800007fe:	cfdff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000802:	85a6                	mv	a1,s1
    80000804:	00007517          	auipc	a0,0x7
    80000808:	81c50513          	addi	a0,a0,-2020 # 80007020 <etext+0x20>
    8000080c:	cefff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000810:	00007797          	auipc	a5,0x7
    80000814:	0527a023          	sw	s2,64(a5) # 80007850 <panicked>
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
    80000822:	00007597          	auipc	a1,0x7
    80000826:	80658593          	addi	a1,a1,-2042 # 80007028 <etext+0x28>
    8000082a:	0000f517          	auipc	a0,0xf
    8000082e:	0fe50513          	addi	a0,a0,254 # 8000f928 <pr>
    80000832:	316000ef          	jal	80000b48 <initlock>
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
    80000878:	00006597          	auipc	a1,0x6
    8000087c:	7b858593          	addi	a1,a1,1976 # 80007030 <etext+0x30>
    80000880:	0000f517          	auipc	a0,0xf
    80000884:	0c050513          	addi	a0,a0,192 # 8000f940 <tx_lock>
    80000888:	2c0000ef          	jal	80000b48 <initlock>
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
    800008a4:	0000f517          	auipc	a0,0xf
    800008a8:	09c50513          	addi	a0,a0,156 # 8000f940 <tx_lock>
    800008ac:	320000ef          	jal	80000bcc <acquire>

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
    800008c2:	00007497          	auipc	s1,0x7
    800008c6:	f9a48493          	addi	s1,s1,-102 # 8000785c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    800008ca:	0000f997          	auipc	s3,0xf
    800008ce:	07698993          	addi	s3,s3,118 # 8000f940 <tx_lock>
    800008d2:	00007917          	auipc	s2,0x7
    800008d6:	f8690913          	addi	s2,s2,-122 # 80007858 <tx_chan>
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
    800008e6:	642010ef          	jal	80001f28 <sleep>
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
    80000910:	0000f517          	auipc	a0,0xf
    80000914:	03050513          	addi	a0,a0,48 # 8000f940 <tx_lock>
    80000918:	348000ef          	jal	80000c60 <release>
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
    80000934:	00007797          	auipc	a5,0x7
    80000938:	f207a783          	lw	a5,-224(a5) # 80007854 <panicking>
    8000093c:	cf95                	beqz	a5,80000978 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    8000093e:	00007797          	auipc	a5,0x7
    80000942:	f127a783          	lw	a5,-238(a5) # 80007850 <panicked>
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
    80000964:	00007797          	auipc	a5,0x7
    80000968:	ef07a783          	lw	a5,-272(a5) # 80007854 <panicking>
    8000096c:	cb91                	beqz	a5,80000980 <uartputc_sync+0x58>
    pop_off();
}
    8000096e:	60e2                	ld	ra,24(sp)
    80000970:	6442                	ld	s0,16(sp)
    80000972:	64a2                	ld	s1,8(sp)
    80000974:	6105                	addi	sp,sp,32
    80000976:	8082                	ret
    push_off();
    80000978:	214000ef          	jal	80000b8c <push_off>
    8000097c:	b7c9                	j	8000093e <uartputc_sync+0x16>
    for(;;)
    8000097e:	a001                	j	8000097e <uartputc_sync+0x56>
    pop_off();
    80000980:	290000ef          	jal	80000c10 <pop_off>
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
    800009ae:	1101                	addi	sp,sp,-32
    800009b0:	ec06                	sd	ra,24(sp)
    800009b2:	e822                	sd	s0,16(sp)
    800009b4:	e426                	sd	s1,8(sp)
    800009b6:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009b8:	100007b7          	lui	a5,0x10000
    800009bc:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    800009c0:	0000f517          	auipc	a0,0xf
    800009c4:	f8050513          	addi	a0,a0,-128 # 8000f940 <tx_lock>
    800009c8:	204000ef          	jal	80000bcc <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    800009cc:	100007b7          	lui	a5,0x10000
    800009d0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009d4:	0207f793          	andi	a5,a5,32
    800009d8:	ef99                	bnez	a5,800009f6 <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    800009da:	0000f517          	auipc	a0,0xf
    800009de:	f6650513          	addi	a0,a0,-154 # 8000f940 <tx_lock>
    800009e2:	27e000ef          	jal	80000c60 <release>

  // read and process incoming characters, if any.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009e6:	54fd                	li	s1,-1
    int c = uartgetc();
    800009e8:	f9fff0ef          	jal	80000986 <uartgetc>
    if(c == -1)
    800009ec:	02950063          	beq	a0,s1,80000a0c <uartintr+0x5e>
      break;
    consoleintr(c);
    800009f0:	8bdff0ef          	jal	800002ac <consoleintr>
  while(1){
    800009f4:	bfd5                	j	800009e8 <uartintr+0x3a>
    tx_busy = 0;
    800009f6:	00007797          	auipc	a5,0x7
    800009fa:	e607a323          	sw	zero,-410(a5) # 8000785c <tx_busy>
    wakeup(&tx_chan);
    800009fe:	00007517          	auipc	a0,0x7
    80000a02:	e5a50513          	addi	a0,a0,-422 # 80007858 <tx_chan>
    80000a06:	56e010ef          	jal	80001f74 <wakeup>
    80000a0a:	bfc1                	j	800009da <uartintr+0x2c>
  }
}
    80000a0c:	60e2                	ld	ra,24(sp)
    80000a0e:	6442                	ld	s0,16(sp)
    80000a10:	64a2                	ld	s1,8(sp)
    80000a12:	6105                	addi	sp,sp,32
    80000a14:	8082                	ret

0000000080000a16 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a16:	1101                	addi	sp,sp,-32
    80000a18:	ec06                	sd	ra,24(sp)
    80000a1a:	e822                	sd	s0,16(sp)
    80000a1c:	e426                	sd	s1,8(sp)
    80000a1e:	e04a                	sd	s2,0(sp)
    80000a20:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a22:	03451793          	slli	a5,a0,0x34
    80000a26:	e7a9                	bnez	a5,80000a70 <kfree+0x5a>
    80000a28:	84aa                	mv	s1,a0
    80000a2a:	00020797          	auipc	a5,0x20
    80000a2e:	55e78793          	addi	a5,a5,1374 # 80020f88 <end>
    80000a32:	02f56f63          	bltu	a0,a5,80000a70 <kfree+0x5a>
    80000a36:	47c5                	li	a5,17
    80000a38:	07ee                	slli	a5,a5,0x1b
    80000a3a:	02f57b63          	bgeu	a0,a5,80000a70 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a3e:	6605                	lui	a2,0x1
    80000a40:	4585                	li	a1,1
    80000a42:	25a000ef          	jal	80000c9c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a46:	0000f917          	auipc	s2,0xf
    80000a4a:	f1290913          	addi	s2,s2,-238 # 8000f958 <kmem>
    80000a4e:	854a                	mv	a0,s2
    80000a50:	17c000ef          	jal	80000bcc <acquire>
  r->next = kmem.freelist;
    80000a54:	01893783          	ld	a5,24(s2)
    80000a58:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a5a:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a5e:	854a                	mv	a0,s2
    80000a60:	200000ef          	jal	80000c60 <release>
}
    80000a64:	60e2                	ld	ra,24(sp)
    80000a66:	6442                	ld	s0,16(sp)
    80000a68:	64a2                	ld	s1,8(sp)
    80000a6a:	6902                	ld	s2,0(sp)
    80000a6c:	6105                	addi	sp,sp,32
    80000a6e:	8082                	ret
    panic("kfree");
    80000a70:	00006517          	auipc	a0,0x6
    80000a74:	5c850513          	addi	a0,a0,1480 # 80007038 <etext+0x38>
    80000a78:	d67ff0ef          	jal	800007de <panic>

0000000080000a7c <freerange>:
{
    80000a7c:	7179                	addi	sp,sp,-48
    80000a7e:	f406                	sd	ra,40(sp)
    80000a80:	f022                	sd	s0,32(sp)
    80000a82:	ec26                	sd	s1,24(sp)
    80000a84:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a86:	6785                	lui	a5,0x1
    80000a88:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a8c:	00e504b3          	add	s1,a0,a4
    80000a90:	777d                	lui	a4,0xfffff
    80000a92:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a94:	94be                	add	s1,s1,a5
    80000a96:	0295e263          	bltu	a1,s1,80000aba <freerange+0x3e>
    80000a9a:	e84a                	sd	s2,16(sp)
    80000a9c:	e44e                	sd	s3,8(sp)
    80000a9e:	e052                	sd	s4,0(sp)
    80000aa0:	892e                	mv	s2,a1
    kfree(p);
    80000aa2:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aa4:	89be                	mv	s3,a5
    kfree(p);
    80000aa6:	01448533          	add	a0,s1,s4
    80000aaa:	f6dff0ef          	jal	80000a16 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aae:	94ce                	add	s1,s1,s3
    80000ab0:	fe997be3          	bgeu	s2,s1,80000aa6 <freerange+0x2a>
    80000ab4:	6942                	ld	s2,16(sp)
    80000ab6:	69a2                	ld	s3,8(sp)
    80000ab8:	6a02                	ld	s4,0(sp)
}
    80000aba:	70a2                	ld	ra,40(sp)
    80000abc:	7402                	ld	s0,32(sp)
    80000abe:	64e2                	ld	s1,24(sp)
    80000ac0:	6145                	addi	sp,sp,48
    80000ac2:	8082                	ret

0000000080000ac4 <kinit>:
{
    80000ac4:	1141                	addi	sp,sp,-16
    80000ac6:	e406                	sd	ra,8(sp)
    80000ac8:	e022                	sd	s0,0(sp)
    80000aca:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000acc:	00006597          	auipc	a1,0x6
    80000ad0:	57458593          	addi	a1,a1,1396 # 80007040 <etext+0x40>
    80000ad4:	0000f517          	auipc	a0,0xf
    80000ad8:	e8450513          	addi	a0,a0,-380 # 8000f958 <kmem>
    80000adc:	06c000ef          	jal	80000b48 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ae0:	45c5                	li	a1,17
    80000ae2:	05ee                	slli	a1,a1,0x1b
    80000ae4:	00020517          	auipc	a0,0x20
    80000ae8:	4a450513          	addi	a0,a0,1188 # 80020f88 <end>
    80000aec:	f91ff0ef          	jal	80000a7c <freerange>
}
    80000af0:	60a2                	ld	ra,8(sp)
    80000af2:	6402                	ld	s0,0(sp)
    80000af4:	0141                	addi	sp,sp,16
    80000af6:	8082                	ret

0000000080000af8 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000af8:	1101                	addi	sp,sp,-32
    80000afa:	ec06                	sd	ra,24(sp)
    80000afc:	e822                	sd	s0,16(sp)
    80000afe:	e426                	sd	s1,8(sp)
    80000b00:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b02:	0000f497          	auipc	s1,0xf
    80000b06:	e5648493          	addi	s1,s1,-426 # 8000f958 <kmem>
    80000b0a:	8526                	mv	a0,s1
    80000b0c:	0c0000ef          	jal	80000bcc <acquire>
  r = kmem.freelist;
    80000b10:	6c84                	ld	s1,24(s1)
  if(r)
    80000b12:	c485                	beqz	s1,80000b3a <kalloc+0x42>
    kmem.freelist = r->next;
    80000b14:	609c                	ld	a5,0(s1)
    80000b16:	0000f517          	auipc	a0,0xf
    80000b1a:	e4250513          	addi	a0,a0,-446 # 8000f958 <kmem>
    80000b1e:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b20:	140000ef          	jal	80000c60 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b24:	6605                	lui	a2,0x1
    80000b26:	4595                	li	a1,5
    80000b28:	8526                	mv	a0,s1
    80000b2a:	172000ef          	jal	80000c9c <memset>
  return (void*)r;
}
    80000b2e:	8526                	mv	a0,s1
    80000b30:	60e2                	ld	ra,24(sp)
    80000b32:	6442                	ld	s0,16(sp)
    80000b34:	64a2                	ld	s1,8(sp)
    80000b36:	6105                	addi	sp,sp,32
    80000b38:	8082                	ret
  release(&kmem.lock);
    80000b3a:	0000f517          	auipc	a0,0xf
    80000b3e:	e1e50513          	addi	a0,a0,-482 # 8000f958 <kmem>
    80000b42:	11e000ef          	jal	80000c60 <release>
  if(r)
    80000b46:	b7e5                	j	80000b2e <kalloc+0x36>

0000000080000b48 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b48:	1141                	addi	sp,sp,-16
    80000b4a:	e406                	sd	ra,8(sp)
    80000b4c:	e022                	sd	s0,0(sp)
    80000b4e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b50:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b52:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b56:	00053823          	sd	zero,16(a0)
}
    80000b5a:	60a2                	ld	ra,8(sp)
    80000b5c:	6402                	ld	s0,0(sp)
    80000b5e:	0141                	addi	sp,sp,16
    80000b60:	8082                	ret

0000000080000b62 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b62:	411c                	lw	a5,0(a0)
    80000b64:	e399                	bnez	a5,80000b6a <holding+0x8>
    80000b66:	4501                	li	a0,0
  return r;
}
    80000b68:	8082                	ret
{
    80000b6a:	1101                	addi	sp,sp,-32
    80000b6c:	ec06                	sd	ra,24(sp)
    80000b6e:	e822                	sd	s0,16(sp)
    80000b70:	e426                	sd	s1,8(sp)
    80000b72:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b74:	6904                	ld	s1,16(a0)
    80000b76:	529000ef          	jal	8000189e <mycpu>
    80000b7a:	40a48533          	sub	a0,s1,a0
    80000b7e:	00153513          	seqz	a0,a0
}
    80000b82:	60e2                	ld	ra,24(sp)
    80000b84:	6442                	ld	s0,16(sp)
    80000b86:	64a2                	ld	s1,8(sp)
    80000b88:	6105                	addi	sp,sp,32
    80000b8a:	8082                	ret

0000000080000b8c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b8c:	1101                	addi	sp,sp,-32
    80000b8e:	ec06                	sd	ra,24(sp)
    80000b90:	e822                	sd	s0,16(sp)
    80000b92:	e426                	sd	s1,8(sp)
    80000b94:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b96:	100024f3          	csrr	s1,sstatus
    80000b9a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b9e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000ba0:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000ba4:	4fb000ef          	jal	8000189e <mycpu>
    80000ba8:	5d3c                	lw	a5,120(a0)
    80000baa:	cb99                	beqz	a5,80000bc0 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bac:	4f3000ef          	jal	8000189e <mycpu>
    80000bb0:	5d3c                	lw	a5,120(a0)
    80000bb2:	2785                	addiw	a5,a5,1
    80000bb4:	dd3c                	sw	a5,120(a0)
}
    80000bb6:	60e2                	ld	ra,24(sp)
    80000bb8:	6442                	ld	s0,16(sp)
    80000bba:	64a2                	ld	s1,8(sp)
    80000bbc:	6105                	addi	sp,sp,32
    80000bbe:	8082                	ret
    mycpu()->intena = old;
    80000bc0:	4df000ef          	jal	8000189e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bc4:	8085                	srli	s1,s1,0x1
    80000bc6:	8885                	andi	s1,s1,1
    80000bc8:	dd64                	sw	s1,124(a0)
    80000bca:	b7cd                	j	80000bac <push_off+0x20>

0000000080000bcc <acquire>:
{
    80000bcc:	1101                	addi	sp,sp,-32
    80000bce:	ec06                	sd	ra,24(sp)
    80000bd0:	e822                	sd	s0,16(sp)
    80000bd2:	e426                	sd	s1,8(sp)
    80000bd4:	1000                	addi	s0,sp,32
    80000bd6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bd8:	fb5ff0ef          	jal	80000b8c <push_off>
  if(holding(lk))
    80000bdc:	8526                	mv	a0,s1
    80000bde:	f85ff0ef          	jal	80000b62 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be2:	4705                	li	a4,1
  if(holding(lk))
    80000be4:	e105                	bnez	a0,80000c04 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be6:	87ba                	mv	a5,a4
    80000be8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bec:	2781                	sext.w	a5,a5
    80000bee:	ffe5                	bnez	a5,80000be6 <acquire+0x1a>
  __sync_synchronize();
    80000bf0:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000bf4:	4ab000ef          	jal	8000189e <mycpu>
    80000bf8:	e888                	sd	a0,16(s1)
}
    80000bfa:	60e2                	ld	ra,24(sp)
    80000bfc:	6442                	ld	s0,16(sp)
    80000bfe:	64a2                	ld	s1,8(sp)
    80000c00:	6105                	addi	sp,sp,32
    80000c02:	8082                	ret
    panic("acquire");
    80000c04:	00006517          	auipc	a0,0x6
    80000c08:	44450513          	addi	a0,a0,1092 # 80007048 <etext+0x48>
    80000c0c:	bd3ff0ef          	jal	800007de <panic>

0000000080000c10 <pop_off>:

void
pop_off(void)
{
    80000c10:	1141                	addi	sp,sp,-16
    80000c12:	e406                	sd	ra,8(sp)
    80000c14:	e022                	sd	s0,0(sp)
    80000c16:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c18:	487000ef          	jal	8000189e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c1c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c20:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c22:	e39d                	bnez	a5,80000c48 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c24:	5d3c                	lw	a5,120(a0)
    80000c26:	02f05763          	blez	a5,80000c54 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80000c2a:	37fd                	addiw	a5,a5,-1
    80000c2c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c2e:	eb89                	bnez	a5,80000c40 <pop_off+0x30>
    80000c30:	5d7c                	lw	a5,124(a0)
    80000c32:	c799                	beqz	a5,80000c40 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c34:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c38:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c3c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c40:	60a2                	ld	ra,8(sp)
    80000c42:	6402                	ld	s0,0(sp)
    80000c44:	0141                	addi	sp,sp,16
    80000c46:	8082                	ret
    panic("pop_off - interruptible");
    80000c48:	00006517          	auipc	a0,0x6
    80000c4c:	40850513          	addi	a0,a0,1032 # 80007050 <etext+0x50>
    80000c50:	b8fff0ef          	jal	800007de <panic>
    panic("pop_off");
    80000c54:	00006517          	auipc	a0,0x6
    80000c58:	41450513          	addi	a0,a0,1044 # 80007068 <etext+0x68>
    80000c5c:	b83ff0ef          	jal	800007de <panic>

0000000080000c60 <release>:
{
    80000c60:	1101                	addi	sp,sp,-32
    80000c62:	ec06                	sd	ra,24(sp)
    80000c64:	e822                	sd	s0,16(sp)
    80000c66:	e426                	sd	s1,8(sp)
    80000c68:	1000                	addi	s0,sp,32
    80000c6a:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c6c:	ef7ff0ef          	jal	80000b62 <holding>
    80000c70:	c105                	beqz	a0,80000c90 <release+0x30>
  lk->cpu = 0;
    80000c72:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c76:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000c7a:	0310000f          	fence	rw,w
    80000c7e:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000c82:	f8fff0ef          	jal	80000c10 <pop_off>
}
    80000c86:	60e2                	ld	ra,24(sp)
    80000c88:	6442                	ld	s0,16(sp)
    80000c8a:	64a2                	ld	s1,8(sp)
    80000c8c:	6105                	addi	sp,sp,32
    80000c8e:	8082                	ret
    panic("release");
    80000c90:	00006517          	auipc	a0,0x6
    80000c94:	3e050513          	addi	a0,a0,992 # 80007070 <etext+0x70>
    80000c98:	b47ff0ef          	jal	800007de <panic>

0000000080000c9c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000c9c:	1141                	addi	sp,sp,-16
    80000c9e:	e406                	sd	ra,8(sp)
    80000ca0:	e022                	sd	s0,0(sp)
    80000ca2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000ca4:	ca19                	beqz	a2,80000cba <memset+0x1e>
    80000ca6:	87aa                	mv	a5,a0
    80000ca8:	1602                	slli	a2,a2,0x20
    80000caa:	9201                	srli	a2,a2,0x20
    80000cac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cb0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cb4:	0785                	addi	a5,a5,1
    80000cb6:	fee79de3          	bne	a5,a4,80000cb0 <memset+0x14>
  }
  return dst;
}
    80000cba:	60a2                	ld	ra,8(sp)
    80000cbc:	6402                	ld	s0,0(sp)
    80000cbe:	0141                	addi	sp,sp,16
    80000cc0:	8082                	ret

0000000080000cc2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cc2:	1141                	addi	sp,sp,-16
    80000cc4:	e406                	sd	ra,8(sp)
    80000cc6:	e022                	sd	s0,0(sp)
    80000cc8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cca:	ca0d                	beqz	a2,80000cfc <memcmp+0x3a>
    80000ccc:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cd0:	1682                	slli	a3,a3,0x20
    80000cd2:	9281                	srli	a3,a3,0x20
    80000cd4:	0685                	addi	a3,a3,1
    80000cd6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cd8:	00054783          	lbu	a5,0(a0)
    80000cdc:	0005c703          	lbu	a4,0(a1)
    80000ce0:	00e79863          	bne	a5,a4,80000cf0 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000ce4:	0505                	addi	a0,a0,1
    80000ce6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000ce8:	fed518e3          	bne	a0,a3,80000cd8 <memcmp+0x16>
  }

  return 0;
    80000cec:	4501                	li	a0,0
    80000cee:	a019                	j	80000cf4 <memcmp+0x32>
      return *s1 - *s2;
    80000cf0:	40e7853b          	subw	a0,a5,a4
}
    80000cf4:	60a2                	ld	ra,8(sp)
    80000cf6:	6402                	ld	s0,0(sp)
    80000cf8:	0141                	addi	sp,sp,16
    80000cfa:	8082                	ret
  return 0;
    80000cfc:	4501                	li	a0,0
    80000cfe:	bfdd                	j	80000cf4 <memcmp+0x32>

0000000080000d00 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d00:	1141                	addi	sp,sp,-16
    80000d02:	e406                	sd	ra,8(sp)
    80000d04:	e022                	sd	s0,0(sp)
    80000d06:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d08:	c205                	beqz	a2,80000d28 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d0a:	02a5e363          	bltu	a1,a0,80000d30 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d0e:	1602                	slli	a2,a2,0x20
    80000d10:	9201                	srli	a2,a2,0x20
    80000d12:	00c587b3          	add	a5,a1,a2
{
    80000d16:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d18:	0585                	addi	a1,a1,1
    80000d1a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffde079>
    80000d1c:	fff5c683          	lbu	a3,-1(a1)
    80000d20:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d24:	feb79ae3          	bne	a5,a1,80000d18 <memmove+0x18>

  return dst;
}
    80000d28:	60a2                	ld	ra,8(sp)
    80000d2a:	6402                	ld	s0,0(sp)
    80000d2c:	0141                	addi	sp,sp,16
    80000d2e:	8082                	ret
  if(s < d && s + n > d){
    80000d30:	02061693          	slli	a3,a2,0x20
    80000d34:	9281                	srli	a3,a3,0x20
    80000d36:	00d58733          	add	a4,a1,a3
    80000d3a:	fce57ae3          	bgeu	a0,a4,80000d0e <memmove+0xe>
    d += n;
    80000d3e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d40:	fff6079b          	addiw	a5,a2,-1
    80000d44:	1782                	slli	a5,a5,0x20
    80000d46:	9381                	srli	a5,a5,0x20
    80000d48:	fff7c793          	not	a5,a5
    80000d4c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d4e:	177d                	addi	a4,a4,-1
    80000d50:	16fd                	addi	a3,a3,-1
    80000d52:	00074603          	lbu	a2,0(a4)
    80000d56:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d5a:	fee79ae3          	bne	a5,a4,80000d4e <memmove+0x4e>
    80000d5e:	b7e9                	j	80000d28 <memmove+0x28>

0000000080000d60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d60:	1141                	addi	sp,sp,-16
    80000d62:	e406                	sd	ra,8(sp)
    80000d64:	e022                	sd	s0,0(sp)
    80000d66:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d68:	f99ff0ef          	jal	80000d00 <memmove>
}
    80000d6c:	60a2                	ld	ra,8(sp)
    80000d6e:	6402                	ld	s0,0(sp)
    80000d70:	0141                	addi	sp,sp,16
    80000d72:	8082                	ret

0000000080000d74 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d74:	1141                	addi	sp,sp,-16
    80000d76:	e406                	sd	ra,8(sp)
    80000d78:	e022                	sd	s0,0(sp)
    80000d7a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d7c:	ce11                	beqz	a2,80000d98 <strncmp+0x24>
    80000d7e:	00054783          	lbu	a5,0(a0)
    80000d82:	cf89                	beqz	a5,80000d9c <strncmp+0x28>
    80000d84:	0005c703          	lbu	a4,0(a1)
    80000d88:	00f71a63          	bne	a4,a5,80000d9c <strncmp+0x28>
    n--, p++, q++;
    80000d8c:	367d                	addiw	a2,a2,-1
    80000d8e:	0505                	addi	a0,a0,1
    80000d90:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000d92:	f675                	bnez	a2,80000d7e <strncmp+0xa>
  if(n == 0)
    return 0;
    80000d94:	4501                	li	a0,0
    80000d96:	a801                	j	80000da6 <strncmp+0x32>
    80000d98:	4501                	li	a0,0
    80000d9a:	a031                	j	80000da6 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000d9c:	00054503          	lbu	a0,0(a0)
    80000da0:	0005c783          	lbu	a5,0(a1)
    80000da4:	9d1d                	subw	a0,a0,a5
}
    80000da6:	60a2                	ld	ra,8(sp)
    80000da8:	6402                	ld	s0,0(sp)
    80000daa:	0141                	addi	sp,sp,16
    80000dac:	8082                	ret

0000000080000dae <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dae:	1141                	addi	sp,sp,-16
    80000db0:	e406                	sd	ra,8(sp)
    80000db2:	e022                	sd	s0,0(sp)
    80000db4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000db6:	87aa                	mv	a5,a0
    80000db8:	86b2                	mv	a3,a2
    80000dba:	367d                	addiw	a2,a2,-1
    80000dbc:	02d05563          	blez	a3,80000de6 <strncpy+0x38>
    80000dc0:	0785                	addi	a5,a5,1
    80000dc2:	0005c703          	lbu	a4,0(a1)
    80000dc6:	fee78fa3          	sb	a4,-1(a5)
    80000dca:	0585                	addi	a1,a1,1
    80000dcc:	f775                	bnez	a4,80000db8 <strncpy+0xa>
    ;
  while(n-- > 0)
    80000dce:	873e                	mv	a4,a5
    80000dd0:	00c05b63          	blez	a2,80000de6 <strncpy+0x38>
    80000dd4:	9fb5                	addw	a5,a5,a3
    80000dd6:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000dd8:	0705                	addi	a4,a4,1
    80000dda:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000dde:	40e786bb          	subw	a3,a5,a4
    80000de2:	fed04be3          	bgtz	a3,80000dd8 <strncpy+0x2a>
  return os;
}
    80000de6:	60a2                	ld	ra,8(sp)
    80000de8:	6402                	ld	s0,0(sp)
    80000dea:	0141                	addi	sp,sp,16
    80000dec:	8082                	ret

0000000080000dee <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000dee:	1141                	addi	sp,sp,-16
    80000df0:	e406                	sd	ra,8(sp)
    80000df2:	e022                	sd	s0,0(sp)
    80000df4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000df6:	02c05363          	blez	a2,80000e1c <safestrcpy+0x2e>
    80000dfa:	fff6069b          	addiw	a3,a2,-1
    80000dfe:	1682                	slli	a3,a3,0x20
    80000e00:	9281                	srli	a3,a3,0x20
    80000e02:	96ae                	add	a3,a3,a1
    80000e04:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e06:	00d58963          	beq	a1,a3,80000e18 <safestrcpy+0x2a>
    80000e0a:	0585                	addi	a1,a1,1
    80000e0c:	0785                	addi	a5,a5,1
    80000e0e:	fff5c703          	lbu	a4,-1(a1)
    80000e12:	fee78fa3          	sb	a4,-1(a5)
    80000e16:	fb65                	bnez	a4,80000e06 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e18:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e1c:	60a2                	ld	ra,8(sp)
    80000e1e:	6402                	ld	s0,0(sp)
    80000e20:	0141                	addi	sp,sp,16
    80000e22:	8082                	ret

0000000080000e24 <strlen>:

int
strlen(const char *s)
{
    80000e24:	1141                	addi	sp,sp,-16
    80000e26:	e406                	sd	ra,8(sp)
    80000e28:	e022                	sd	s0,0(sp)
    80000e2a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e2c:	00054783          	lbu	a5,0(a0)
    80000e30:	cf99                	beqz	a5,80000e4e <strlen+0x2a>
    80000e32:	0505                	addi	a0,a0,1
    80000e34:	87aa                	mv	a5,a0
    80000e36:	86be                	mv	a3,a5
    80000e38:	0785                	addi	a5,a5,1
    80000e3a:	fff7c703          	lbu	a4,-1(a5)
    80000e3e:	ff65                	bnez	a4,80000e36 <strlen+0x12>
    80000e40:	40a6853b          	subw	a0,a3,a0
    80000e44:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e46:	60a2                	ld	ra,8(sp)
    80000e48:	6402                	ld	s0,0(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e4e:	4501                	li	a0,0
    80000e50:	bfdd                	j	80000e46 <strlen+0x22>

0000000080000e52 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e52:	1141                	addi	sp,sp,-16
    80000e54:	e406                	sd	ra,8(sp)
    80000e56:	e022                	sd	s0,0(sp)
    80000e58:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e5a:	231000ef          	jal	8000188a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e5e:	00007717          	auipc	a4,0x7
    80000e62:	a0270713          	addi	a4,a4,-1534 # 80007860 <started>
  if(cpuid() == 0){
    80000e66:	c51d                	beqz	a0,80000e94 <main+0x42>
    while(started == 0)
    80000e68:	431c                	lw	a5,0(a4)
    80000e6a:	2781                	sext.w	a5,a5
    80000e6c:	dff5                	beqz	a5,80000e68 <main+0x16>
      ;
    __sync_synchronize();
    80000e6e:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000e72:	219000ef          	jal	8000188a <cpuid>
    80000e76:	85aa                	mv	a1,a0
    80000e78:	00006517          	auipc	a0,0x6
    80000e7c:	22050513          	addi	a0,a0,544 # 80007098 <etext+0x98>
    80000e80:	e7aff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000e84:	080000ef          	jal	80000f04 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e88:	143010ef          	jal	800027ca <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e8c:	33d040ef          	jal	800059c8 <plicinithart>
  }

  scheduler();        
    80000e90:	701000ef          	jal	80001d90 <scheduler>
    consoleinit();
    80000e94:	d98ff0ef          	jal	8000042c <consoleinit>
    printfinit();
    80000e98:	983ff0ef          	jal	8000081a <printfinit>
    printf("\n");
    80000e9c:	00006517          	auipc	a0,0x6
    80000ea0:	1dc50513          	addi	a0,a0,476 # 80007078 <etext+0x78>
    80000ea4:	e56ff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000ea8:	00006517          	auipc	a0,0x6
    80000eac:	1d850513          	addi	a0,a0,472 # 80007080 <etext+0x80>
    80000eb0:	e4aff0ef          	jal	800004fa <printf>
    printf("\n");
    80000eb4:	00006517          	auipc	a0,0x6
    80000eb8:	1c450513          	addi	a0,a0,452 # 80007078 <etext+0x78>
    80000ebc:	e3eff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000ec0:	c05ff0ef          	jal	80000ac4 <kinit>
    kvminit();       // create kernel page table
    80000ec4:	2ce000ef          	jal	80001192 <kvminit>
    kvminithart();   // turn on paging
    80000ec8:	03c000ef          	jal	80000f04 <kvminithart>
    procinit();      // process table
    80000ecc:	10f000ef          	jal	800017da <procinit>
    trapinit();      // trap vectors
    80000ed0:	0d7010ef          	jal	800027a6 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ed4:	0f7010ef          	jal	800027ca <trapinithart>
    plicinit();      // set up interrupt controller
    80000ed8:	2d7040ef          	jal	800059ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000edc:	2ed040ef          	jal	800059c8 <plicinithart>
    binit();         // buffer cache
    80000ee0:	0da020ef          	jal	80002fba <binit>
    iinit();         // inode table
    80000ee4:	63a020ef          	jal	8000351e <iinit>
    fileinit();      // file table
    80000ee8:	54c030ef          	jal	80004434 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000eec:	3cd040ef          	jal	80005ab8 <virtio_disk_init>
    userinit();      // first user process
    80000ef0:	545000ef          	jal	80001c34 <userinit>
    __sync_synchronize();
    80000ef4:	0330000f          	fence	rw,rw
    started = 1;
    80000ef8:	4785                	li	a5,1
    80000efa:	00007717          	auipc	a4,0x7
    80000efe:	96f72323          	sw	a5,-1690(a4) # 80007860 <started>
    80000f02:	b779                	j	80000e90 <main+0x3e>

0000000080000f04 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f04:	1141                	addi	sp,sp,-16
    80000f06:	e406                	sd	ra,8(sp)
    80000f08:	e022                	sd	s0,0(sp)
    80000f0a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f0c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f10:	00007797          	auipc	a5,0x7
    80000f14:	9587b783          	ld	a5,-1704(a5) # 80007868 <kernel_pagetable>
    80000f18:	83b1                	srli	a5,a5,0xc
    80000f1a:	577d                	li	a4,-1
    80000f1c:	177e                	slli	a4,a4,0x3f
    80000f1e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f20:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f24:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f28:	60a2                	ld	ra,8(sp)
    80000f2a:	6402                	ld	s0,0(sp)
    80000f2c:	0141                	addi	sp,sp,16
    80000f2e:	8082                	ret

0000000080000f30 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f30:	7139                	addi	sp,sp,-64
    80000f32:	fc06                	sd	ra,56(sp)
    80000f34:	f822                	sd	s0,48(sp)
    80000f36:	f426                	sd	s1,40(sp)
    80000f38:	f04a                	sd	s2,32(sp)
    80000f3a:	ec4e                	sd	s3,24(sp)
    80000f3c:	e852                	sd	s4,16(sp)
    80000f3e:	e456                	sd	s5,8(sp)
    80000f40:	e05a                	sd	s6,0(sp)
    80000f42:	0080                	addi	s0,sp,64
    80000f44:	84aa                	mv	s1,a0
    80000f46:	89ae                	mv	s3,a1
    80000f48:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f4a:	57fd                	li	a5,-1
    80000f4c:	83e9                	srli	a5,a5,0x1a
    80000f4e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f50:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f52:	04b7e263          	bltu	a5,a1,80000f96 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f56:	0149d933          	srl	s2,s3,s4
    80000f5a:	1ff97913          	andi	s2,s2,511
    80000f5e:	090e                	slli	s2,s2,0x3
    80000f60:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f62:	00093483          	ld	s1,0(s2)
    80000f66:	0014f793          	andi	a5,s1,1
    80000f6a:	cf85                	beqz	a5,80000fa2 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f6c:	80a9                	srli	s1,s1,0xa
    80000f6e:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000f70:	3a5d                	addiw	s4,s4,-9
    80000f72:	ff6a12e3          	bne	s4,s6,80000f56 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000f76:	00c9d513          	srli	a0,s3,0xc
    80000f7a:	1ff57513          	andi	a0,a0,511
    80000f7e:	050e                	slli	a0,a0,0x3
    80000f80:	9526                	add	a0,a0,s1
}
    80000f82:	70e2                	ld	ra,56(sp)
    80000f84:	7442                	ld	s0,48(sp)
    80000f86:	74a2                	ld	s1,40(sp)
    80000f88:	7902                	ld	s2,32(sp)
    80000f8a:	69e2                	ld	s3,24(sp)
    80000f8c:	6a42                	ld	s4,16(sp)
    80000f8e:	6aa2                	ld	s5,8(sp)
    80000f90:	6b02                	ld	s6,0(sp)
    80000f92:	6121                	addi	sp,sp,64
    80000f94:	8082                	ret
    panic("walk");
    80000f96:	00006517          	auipc	a0,0x6
    80000f9a:	11a50513          	addi	a0,a0,282 # 800070b0 <etext+0xb0>
    80000f9e:	841ff0ef          	jal	800007de <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fa2:	020a8263          	beqz	s5,80000fc6 <walk+0x96>
    80000fa6:	b53ff0ef          	jal	80000af8 <kalloc>
    80000faa:	84aa                	mv	s1,a0
    80000fac:	d979                	beqz	a0,80000f82 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000fae:	6605                	lui	a2,0x1
    80000fb0:	4581                	li	a1,0
    80000fb2:	cebff0ef          	jal	80000c9c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fb6:	00c4d793          	srli	a5,s1,0xc
    80000fba:	07aa                	slli	a5,a5,0xa
    80000fbc:	0017e793          	ori	a5,a5,1
    80000fc0:	00f93023          	sd	a5,0(s2)
    80000fc4:	b775                	j	80000f70 <walk+0x40>
        return 0;
    80000fc6:	4501                	li	a0,0
    80000fc8:	bf6d                	j	80000f82 <walk+0x52>

0000000080000fca <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fca:	57fd                	li	a5,-1
    80000fcc:	83e9                	srli	a5,a5,0x1a
    80000fce:	00b7f463          	bgeu	a5,a1,80000fd6 <walkaddr+0xc>
    return 0;
    80000fd2:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fd4:	8082                	ret
{
    80000fd6:	1141                	addi	sp,sp,-16
    80000fd8:	e406                	sd	ra,8(sp)
    80000fda:	e022                	sd	s0,0(sp)
    80000fdc:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fde:	4601                	li	a2,0
    80000fe0:	f51ff0ef          	jal	80000f30 <walk>
  if(pte == 0)
    80000fe4:	c105                	beqz	a0,80001004 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000fe6:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000fe8:	0117f693          	andi	a3,a5,17
    80000fec:	4745                	li	a4,17
    return 0;
    80000fee:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000ff0:	00e68663          	beq	a3,a4,80000ffc <walkaddr+0x32>
}
    80000ff4:	60a2                	ld	ra,8(sp)
    80000ff6:	6402                	ld	s0,0(sp)
    80000ff8:	0141                	addi	sp,sp,16
    80000ffa:	8082                	ret
  pa = PTE2PA(*pte);
    80000ffc:	83a9                	srli	a5,a5,0xa
    80000ffe:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001002:	bfcd                	j	80000ff4 <walkaddr+0x2a>
    return 0;
    80001004:	4501                	li	a0,0
    80001006:	b7fd                	j	80000ff4 <walkaddr+0x2a>

0000000080001008 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001008:	715d                	addi	sp,sp,-80
    8000100a:	e486                	sd	ra,72(sp)
    8000100c:	e0a2                	sd	s0,64(sp)
    8000100e:	fc26                	sd	s1,56(sp)
    80001010:	f84a                	sd	s2,48(sp)
    80001012:	f44e                	sd	s3,40(sp)
    80001014:	f052                	sd	s4,32(sp)
    80001016:	ec56                	sd	s5,24(sp)
    80001018:	e85a                	sd	s6,16(sp)
    8000101a:	e45e                	sd	s7,8(sp)
    8000101c:	e062                	sd	s8,0(sp)
    8000101e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001020:	03459793          	slli	a5,a1,0x34
    80001024:	e7b1                	bnez	a5,80001070 <mappages+0x68>
    80001026:	8aaa                	mv	s5,a0
    80001028:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000102a:	03461793          	slli	a5,a2,0x34
    8000102e:	e7b9                	bnez	a5,8000107c <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    80001030:	ce21                	beqz	a2,80001088 <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001032:	77fd                	lui	a5,0xfffff
    80001034:	963e                	add	a2,a2,a5
    80001036:	00b609b3          	add	s3,a2,a1
  a = va;
    8000103a:	892e                	mv	s2,a1
    8000103c:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001040:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001042:	6c05                	lui	s8,0x1
    80001044:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001048:	865e                	mv	a2,s7
    8000104a:	85ca                	mv	a1,s2
    8000104c:	8556                	mv	a0,s5
    8000104e:	ee3ff0ef          	jal	80000f30 <walk>
    80001052:	c539                	beqz	a0,800010a0 <mappages+0x98>
    if(*pte & PTE_V)
    80001054:	611c                	ld	a5,0(a0)
    80001056:	8b85                	andi	a5,a5,1
    80001058:	ef95                	bnez	a5,80001094 <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000105a:	80b1                	srli	s1,s1,0xc
    8000105c:	04aa                	slli	s1,s1,0xa
    8000105e:	0164e4b3          	or	s1,s1,s6
    80001062:	0014e493          	ori	s1,s1,1
    80001066:	e104                	sd	s1,0(a0)
    if(a == last)
    80001068:	05390963          	beq	s2,s3,800010ba <mappages+0xb2>
    a += PGSIZE;
    8000106c:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    8000106e:	bfd9                	j	80001044 <mappages+0x3c>
    panic("mappages: va not aligned");
    80001070:	00006517          	auipc	a0,0x6
    80001074:	04850513          	addi	a0,a0,72 # 800070b8 <etext+0xb8>
    80001078:	f66ff0ef          	jal	800007de <panic>
    panic("mappages: size not aligned");
    8000107c:	00006517          	auipc	a0,0x6
    80001080:	05c50513          	addi	a0,a0,92 # 800070d8 <etext+0xd8>
    80001084:	f5aff0ef          	jal	800007de <panic>
    panic("mappages: size");
    80001088:	00006517          	auipc	a0,0x6
    8000108c:	07050513          	addi	a0,a0,112 # 800070f8 <etext+0xf8>
    80001090:	f4eff0ef          	jal	800007de <panic>
      panic("mappages: remap");
    80001094:	00006517          	auipc	a0,0x6
    80001098:	07450513          	addi	a0,a0,116 # 80007108 <etext+0x108>
    8000109c:	f42ff0ef          	jal	800007de <panic>
      return -1;
    800010a0:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010a2:	60a6                	ld	ra,72(sp)
    800010a4:	6406                	ld	s0,64(sp)
    800010a6:	74e2                	ld	s1,56(sp)
    800010a8:	7942                	ld	s2,48(sp)
    800010aa:	79a2                	ld	s3,40(sp)
    800010ac:	7a02                	ld	s4,32(sp)
    800010ae:	6ae2                	ld	s5,24(sp)
    800010b0:	6b42                	ld	s6,16(sp)
    800010b2:	6ba2                	ld	s7,8(sp)
    800010b4:	6c02                	ld	s8,0(sp)
    800010b6:	6161                	addi	sp,sp,80
    800010b8:	8082                	ret
  return 0;
    800010ba:	4501                	li	a0,0
    800010bc:	b7dd                	j	800010a2 <mappages+0x9a>

00000000800010be <kvmmap>:
{
    800010be:	1141                	addi	sp,sp,-16
    800010c0:	e406                	sd	ra,8(sp)
    800010c2:	e022                	sd	s0,0(sp)
    800010c4:	0800                	addi	s0,sp,16
    800010c6:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010c8:	86b2                	mv	a3,a2
    800010ca:	863e                	mv	a2,a5
    800010cc:	f3dff0ef          	jal	80001008 <mappages>
    800010d0:	e509                	bnez	a0,800010da <kvmmap+0x1c>
}
    800010d2:	60a2                	ld	ra,8(sp)
    800010d4:	6402                	ld	s0,0(sp)
    800010d6:	0141                	addi	sp,sp,16
    800010d8:	8082                	ret
    panic("kvmmap");
    800010da:	00006517          	auipc	a0,0x6
    800010de:	03e50513          	addi	a0,a0,62 # 80007118 <etext+0x118>
    800010e2:	efcff0ef          	jal	800007de <panic>

00000000800010e6 <kvmmake>:
{
    800010e6:	1101                	addi	sp,sp,-32
    800010e8:	ec06                	sd	ra,24(sp)
    800010ea:	e822                	sd	s0,16(sp)
    800010ec:	e426                	sd	s1,8(sp)
    800010ee:	e04a                	sd	s2,0(sp)
    800010f0:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010f2:	a07ff0ef          	jal	80000af8 <kalloc>
    800010f6:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010f8:	6605                	lui	a2,0x1
    800010fa:	4581                	li	a1,0
    800010fc:	ba1ff0ef          	jal	80000c9c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001100:	4719                	li	a4,6
    80001102:	6685                	lui	a3,0x1
    80001104:	10000637          	lui	a2,0x10000
    80001108:	85b2                	mv	a1,a2
    8000110a:	8526                	mv	a0,s1
    8000110c:	fb3ff0ef          	jal	800010be <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001110:	4719                	li	a4,6
    80001112:	6685                	lui	a3,0x1
    80001114:	10001637          	lui	a2,0x10001
    80001118:	85b2                	mv	a1,a2
    8000111a:	8526                	mv	a0,s1
    8000111c:	fa3ff0ef          	jal	800010be <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001120:	4719                	li	a4,6
    80001122:	040006b7          	lui	a3,0x4000
    80001126:	0c000637          	lui	a2,0xc000
    8000112a:	85b2                	mv	a1,a2
    8000112c:	8526                	mv	a0,s1
    8000112e:	f91ff0ef          	jal	800010be <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001132:	00006917          	auipc	s2,0x6
    80001136:	ece90913          	addi	s2,s2,-306 # 80007000 <etext>
    8000113a:	4729                	li	a4,10
    8000113c:	80006697          	auipc	a3,0x80006
    80001140:	ec468693          	addi	a3,a3,-316 # 7000 <_entry-0x7fff9000>
    80001144:	4605                	li	a2,1
    80001146:	067e                	slli	a2,a2,0x1f
    80001148:	85b2                	mv	a1,a2
    8000114a:	8526                	mv	a0,s1
    8000114c:	f73ff0ef          	jal	800010be <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001150:	4719                	li	a4,6
    80001152:	46c5                	li	a3,17
    80001154:	06ee                	slli	a3,a3,0x1b
    80001156:	412686b3          	sub	a3,a3,s2
    8000115a:	864a                	mv	a2,s2
    8000115c:	85ca                	mv	a1,s2
    8000115e:	8526                	mv	a0,s1
    80001160:	f5fff0ef          	jal	800010be <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001164:	4729                	li	a4,10
    80001166:	6685                	lui	a3,0x1
    80001168:	00005617          	auipc	a2,0x5
    8000116c:	e9860613          	addi	a2,a2,-360 # 80006000 <_trampoline>
    80001170:	040005b7          	lui	a1,0x4000
    80001174:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001176:	05b2                	slli	a1,a1,0xc
    80001178:	8526                	mv	a0,s1
    8000117a:	f45ff0ef          	jal	800010be <kvmmap>
  proc_mapstacks(kpgtbl);
    8000117e:	8526                	mv	a0,s1
    80001180:	5bc000ef          	jal	8000173c <proc_mapstacks>
}
    80001184:	8526                	mv	a0,s1
    80001186:	60e2                	ld	ra,24(sp)
    80001188:	6442                	ld	s0,16(sp)
    8000118a:	64a2                	ld	s1,8(sp)
    8000118c:	6902                	ld	s2,0(sp)
    8000118e:	6105                	addi	sp,sp,32
    80001190:	8082                	ret

0000000080001192 <kvminit>:
{
    80001192:	1141                	addi	sp,sp,-16
    80001194:	e406                	sd	ra,8(sp)
    80001196:	e022                	sd	s0,0(sp)
    80001198:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000119a:	f4dff0ef          	jal	800010e6 <kvmmake>
    8000119e:	00006797          	auipc	a5,0x6
    800011a2:	6ca7b523          	sd	a0,1738(a5) # 80007868 <kernel_pagetable>
}
    800011a6:	60a2                	ld	ra,8(sp)
    800011a8:	6402                	ld	s0,0(sp)
    800011aa:	0141                	addi	sp,sp,16
    800011ac:	8082                	ret

00000000800011ae <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011ae:	1101                	addi	sp,sp,-32
    800011b0:	ec06                	sd	ra,24(sp)
    800011b2:	e822                	sd	s0,16(sp)
    800011b4:	e426                	sd	s1,8(sp)
    800011b6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800011b8:	941ff0ef          	jal	80000af8 <kalloc>
    800011bc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800011be:	c509                	beqz	a0,800011c8 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011c0:	6605                	lui	a2,0x1
    800011c2:	4581                	li	a1,0
    800011c4:	ad9ff0ef          	jal	80000c9c <memset>
  return pagetable;
}
    800011c8:	8526                	mv	a0,s1
    800011ca:	60e2                	ld	ra,24(sp)
    800011cc:	6442                	ld	s0,16(sp)
    800011ce:	64a2                	ld	s1,8(sp)
    800011d0:	6105                	addi	sp,sp,32
    800011d2:	8082                	ret

00000000800011d4 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011d4:	7139                	addi	sp,sp,-64
    800011d6:	fc06                	sd	ra,56(sp)
    800011d8:	f822                	sd	s0,48(sp)
    800011da:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011dc:	03459793          	slli	a5,a1,0x34
    800011e0:	e38d                	bnez	a5,80001202 <uvmunmap+0x2e>
    800011e2:	f04a                	sd	s2,32(sp)
    800011e4:	ec4e                	sd	s3,24(sp)
    800011e6:	e852                	sd	s4,16(sp)
    800011e8:	e456                	sd	s5,8(sp)
    800011ea:	e05a                	sd	s6,0(sp)
    800011ec:	8a2a                	mv	s4,a0
    800011ee:	892e                	mv	s2,a1
    800011f0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011f2:	0632                	slli	a2,a2,0xc
    800011f4:	00b609b3          	add	s3,a2,a1
    800011f8:	6b05                	lui	s6,0x1
    800011fa:	0535f963          	bgeu	a1,s3,8000124c <uvmunmap+0x78>
    800011fe:	f426                	sd	s1,40(sp)
    80001200:	a015                	j	80001224 <uvmunmap+0x50>
    80001202:	f426                	sd	s1,40(sp)
    80001204:	f04a                	sd	s2,32(sp)
    80001206:	ec4e                	sd	s3,24(sp)
    80001208:	e852                	sd	s4,16(sp)
    8000120a:	e456                	sd	s5,8(sp)
    8000120c:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    8000120e:	00006517          	auipc	a0,0x6
    80001212:	f1250513          	addi	a0,a0,-238 # 80007120 <etext+0x120>
    80001216:	dc8ff0ef          	jal	800007de <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000121a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000121e:	995a                	add	s2,s2,s6
    80001220:	03397563          	bgeu	s2,s3,8000124a <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001224:	4601                	li	a2,0
    80001226:	85ca                	mv	a1,s2
    80001228:	8552                	mv	a0,s4
    8000122a:	d07ff0ef          	jal	80000f30 <walk>
    8000122e:	84aa                	mv	s1,a0
    80001230:	d57d                	beqz	a0,8000121e <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    80001232:	611c                	ld	a5,0(a0)
    80001234:	0017f713          	andi	a4,a5,1
    80001238:	d37d                	beqz	a4,8000121e <uvmunmap+0x4a>
    if(do_free){
    8000123a:	fe0a80e3          	beqz	s5,8000121a <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    8000123e:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80001240:	00c79513          	slli	a0,a5,0xc
    80001244:	fd2ff0ef          	jal	80000a16 <kfree>
    80001248:	bfc9                	j	8000121a <uvmunmap+0x46>
    8000124a:	74a2                	ld	s1,40(sp)
    8000124c:	7902                	ld	s2,32(sp)
    8000124e:	69e2                	ld	s3,24(sp)
    80001250:	6a42                	ld	s4,16(sp)
    80001252:	6aa2                	ld	s5,8(sp)
    80001254:	6b02                	ld	s6,0(sp)
  }
}
    80001256:	70e2                	ld	ra,56(sp)
    80001258:	7442                	ld	s0,48(sp)
    8000125a:	6121                	addi	sp,sp,64
    8000125c:	8082                	ret

000000008000125e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000125e:	1101                	addi	sp,sp,-32
    80001260:	ec06                	sd	ra,24(sp)
    80001262:	e822                	sd	s0,16(sp)
    80001264:	e426                	sd	s1,8(sp)
    80001266:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001268:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000126a:	00b67d63          	bgeu	a2,a1,80001284 <uvmdealloc+0x26>
    8000126e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001270:	6785                	lui	a5,0x1
    80001272:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001274:	00f60733          	add	a4,a2,a5
    80001278:	76fd                	lui	a3,0xfffff
    8000127a:	8f75                	and	a4,a4,a3
    8000127c:	97ae                	add	a5,a5,a1
    8000127e:	8ff5                	and	a5,a5,a3
    80001280:	00f76863          	bltu	a4,a5,80001290 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001284:	8526                	mv	a0,s1
    80001286:	60e2                	ld	ra,24(sp)
    80001288:	6442                	ld	s0,16(sp)
    8000128a:	64a2                	ld	s1,8(sp)
    8000128c:	6105                	addi	sp,sp,32
    8000128e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001290:	8f99                	sub	a5,a5,a4
    80001292:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001294:	4685                	li	a3,1
    80001296:	0007861b          	sext.w	a2,a5
    8000129a:	85ba                	mv	a1,a4
    8000129c:	f39ff0ef          	jal	800011d4 <uvmunmap>
    800012a0:	b7d5                	j	80001284 <uvmdealloc+0x26>

00000000800012a2 <uvmalloc>:
  if(newsz < oldsz)
    800012a2:	0ab66363          	bltu	a2,a1,80001348 <uvmalloc+0xa6>
{
    800012a6:	715d                	addi	sp,sp,-80
    800012a8:	e486                	sd	ra,72(sp)
    800012aa:	e0a2                	sd	s0,64(sp)
    800012ac:	f052                	sd	s4,32(sp)
    800012ae:	ec56                	sd	s5,24(sp)
    800012b0:	e85a                	sd	s6,16(sp)
    800012b2:	0880                	addi	s0,sp,80
    800012b4:	8b2a                	mv	s6,a0
    800012b6:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    800012b8:	6785                	lui	a5,0x1
    800012ba:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012bc:	95be                	add	a1,a1,a5
    800012be:	77fd                	lui	a5,0xfffff
    800012c0:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800012c4:	08ca7463          	bgeu	s4,a2,8000134c <uvmalloc+0xaa>
    800012c8:	fc26                	sd	s1,56(sp)
    800012ca:	f84a                	sd	s2,48(sp)
    800012cc:	f44e                	sd	s3,40(sp)
    800012ce:	e45e                	sd	s7,8(sp)
    800012d0:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    800012d2:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800012d4:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    800012d8:	821ff0ef          	jal	80000af8 <kalloc>
    800012dc:	84aa                	mv	s1,a0
    if(mem == 0){
    800012de:	c515                	beqz	a0,8000130a <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800012e0:	864e                	mv	a2,s3
    800012e2:	4581                	li	a1,0
    800012e4:	9b9ff0ef          	jal	80000c9c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800012e8:	875e                	mv	a4,s7
    800012ea:	86a6                	mv	a3,s1
    800012ec:	864e                	mv	a2,s3
    800012ee:	85ca                	mv	a1,s2
    800012f0:	855a                	mv	a0,s6
    800012f2:	d17ff0ef          	jal	80001008 <mappages>
    800012f6:	e91d                	bnez	a0,8000132c <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800012f8:	994e                	add	s2,s2,s3
    800012fa:	fd596fe3          	bltu	s2,s5,800012d8 <uvmalloc+0x36>
  return newsz;
    800012fe:	8556                	mv	a0,s5
    80001300:	74e2                	ld	s1,56(sp)
    80001302:	7942                	ld	s2,48(sp)
    80001304:	79a2                	ld	s3,40(sp)
    80001306:	6ba2                	ld	s7,8(sp)
    80001308:	a819                	j	8000131e <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000130a:	8652                	mv	a2,s4
    8000130c:	85ca                	mv	a1,s2
    8000130e:	855a                	mv	a0,s6
    80001310:	f4fff0ef          	jal	8000125e <uvmdealloc>
      return 0;
    80001314:	4501                	li	a0,0
    80001316:	74e2                	ld	s1,56(sp)
    80001318:	7942                	ld	s2,48(sp)
    8000131a:	79a2                	ld	s3,40(sp)
    8000131c:	6ba2                	ld	s7,8(sp)
}
    8000131e:	60a6                	ld	ra,72(sp)
    80001320:	6406                	ld	s0,64(sp)
    80001322:	7a02                	ld	s4,32(sp)
    80001324:	6ae2                	ld	s5,24(sp)
    80001326:	6b42                	ld	s6,16(sp)
    80001328:	6161                	addi	sp,sp,80
    8000132a:	8082                	ret
      kfree(mem);
    8000132c:	8526                	mv	a0,s1
    8000132e:	ee8ff0ef          	jal	80000a16 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001332:	8652                	mv	a2,s4
    80001334:	85ca                	mv	a1,s2
    80001336:	855a                	mv	a0,s6
    80001338:	f27ff0ef          	jal	8000125e <uvmdealloc>
      return 0;
    8000133c:	4501                	li	a0,0
    8000133e:	74e2                	ld	s1,56(sp)
    80001340:	7942                	ld	s2,48(sp)
    80001342:	79a2                	ld	s3,40(sp)
    80001344:	6ba2                	ld	s7,8(sp)
    80001346:	bfe1                	j	8000131e <uvmalloc+0x7c>
    return oldsz;
    80001348:	852e                	mv	a0,a1
}
    8000134a:	8082                	ret
  return newsz;
    8000134c:	8532                	mv	a0,a2
    8000134e:	bfc1                	j	8000131e <uvmalloc+0x7c>

0000000080001350 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001350:	7179                	addi	sp,sp,-48
    80001352:	f406                	sd	ra,40(sp)
    80001354:	f022                	sd	s0,32(sp)
    80001356:	ec26                	sd	s1,24(sp)
    80001358:	e84a                	sd	s2,16(sp)
    8000135a:	e44e                	sd	s3,8(sp)
    8000135c:	e052                	sd	s4,0(sp)
    8000135e:	1800                	addi	s0,sp,48
    80001360:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001362:	84aa                	mv	s1,a0
    80001364:	6905                	lui	s2,0x1
    80001366:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001368:	4985                	li	s3,1
    8000136a:	a819                	j	80001380 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000136c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000136e:	00c79513          	slli	a0,a5,0xc
    80001372:	fdfff0ef          	jal	80001350 <freewalk>
      pagetable[i] = 0;
    80001376:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000137a:	04a1                	addi	s1,s1,8
    8000137c:	01248f63          	beq	s1,s2,8000139a <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001380:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001382:	00f7f713          	andi	a4,a5,15
    80001386:	ff3703e3          	beq	a4,s3,8000136c <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000138a:	8b85                	andi	a5,a5,1
    8000138c:	d7fd                	beqz	a5,8000137a <freewalk+0x2a>
      panic("freewalk: leaf");
    8000138e:	00006517          	auipc	a0,0x6
    80001392:	daa50513          	addi	a0,a0,-598 # 80007138 <etext+0x138>
    80001396:	c48ff0ef          	jal	800007de <panic>
    }
  }
  kfree((void*)pagetable);
    8000139a:	8552                	mv	a0,s4
    8000139c:	e7aff0ef          	jal	80000a16 <kfree>
}
    800013a0:	70a2                	ld	ra,40(sp)
    800013a2:	7402                	ld	s0,32(sp)
    800013a4:	64e2                	ld	s1,24(sp)
    800013a6:	6942                	ld	s2,16(sp)
    800013a8:	69a2                	ld	s3,8(sp)
    800013aa:	6a02                	ld	s4,0(sp)
    800013ac:	6145                	addi	sp,sp,48
    800013ae:	8082                	ret

00000000800013b0 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013b0:	1101                	addi	sp,sp,-32
    800013b2:	ec06                	sd	ra,24(sp)
    800013b4:	e822                	sd	s0,16(sp)
    800013b6:	e426                	sd	s1,8(sp)
    800013b8:	1000                	addi	s0,sp,32
    800013ba:	84aa                	mv	s1,a0
  if(sz > 0)
    800013bc:	e989                	bnez	a1,800013ce <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800013be:	8526                	mv	a0,s1
    800013c0:	f91ff0ef          	jal	80001350 <freewalk>
}
    800013c4:	60e2                	ld	ra,24(sp)
    800013c6:	6442                	ld	s0,16(sp)
    800013c8:	64a2                	ld	s1,8(sp)
    800013ca:	6105                	addi	sp,sp,32
    800013cc:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800013ce:	6785                	lui	a5,0x1
    800013d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013d2:	95be                	add	a1,a1,a5
    800013d4:	4685                	li	a3,1
    800013d6:	00c5d613          	srli	a2,a1,0xc
    800013da:	4581                	li	a1,0
    800013dc:	df9ff0ef          	jal	800011d4 <uvmunmap>
    800013e0:	bff9                	j	800013be <uvmfree+0xe>

00000000800013e2 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800013e2:	ce59                	beqz	a2,80001480 <uvmcopy+0x9e>
{
    800013e4:	715d                	addi	sp,sp,-80
    800013e6:	e486                	sd	ra,72(sp)
    800013e8:	e0a2                	sd	s0,64(sp)
    800013ea:	fc26                	sd	s1,56(sp)
    800013ec:	f84a                	sd	s2,48(sp)
    800013ee:	f44e                	sd	s3,40(sp)
    800013f0:	f052                	sd	s4,32(sp)
    800013f2:	ec56                	sd	s5,24(sp)
    800013f4:	e85a                	sd	s6,16(sp)
    800013f6:	e45e                	sd	s7,8(sp)
    800013f8:	e062                	sd	s8,0(sp)
    800013fa:	0880                	addi	s0,sp,80
    800013fc:	8b2a                	mv	s6,a0
    800013fe:	8bae                	mv	s7,a1
    80001400:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001402:	4481                	li	s1,0
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001404:	6a05                	lui	s4,0x1
    80001406:	a021                	j	8000140e <uvmcopy+0x2c>
  for(i = 0; i < sz; i += PGSIZE){
    80001408:	94d2                	add	s1,s1,s4
    8000140a:	0554fe63          	bgeu	s1,s5,80001466 <uvmcopy+0x84>
    if((pte = walk(old, i, 0)) == 0)
    8000140e:	4601                	li	a2,0
    80001410:	85a6                	mv	a1,s1
    80001412:	855a                	mv	a0,s6
    80001414:	b1dff0ef          	jal	80000f30 <walk>
    80001418:	d965                	beqz	a0,80001408 <uvmcopy+0x26>
    if((*pte & PTE_V) == 0)
    8000141a:	6118                	ld	a4,0(a0)
    8000141c:	00177793          	andi	a5,a4,1
    80001420:	d7e5                	beqz	a5,80001408 <uvmcopy+0x26>
    pa = PTE2PA(*pte);
    80001422:	00a75593          	srli	a1,a4,0xa
    80001426:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000142a:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    8000142e:	ecaff0ef          	jal	80000af8 <kalloc>
    80001432:	89aa                	mv	s3,a0
    80001434:	c105                	beqz	a0,80001454 <uvmcopy+0x72>
    memmove(mem, (char*)pa, PGSIZE);
    80001436:	8652                	mv	a2,s4
    80001438:	85e2                	mv	a1,s8
    8000143a:	8c7ff0ef          	jal	80000d00 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000143e:	874a                	mv	a4,s2
    80001440:	86ce                	mv	a3,s3
    80001442:	8652                	mv	a2,s4
    80001444:	85a6                	mv	a1,s1
    80001446:	855e                	mv	a0,s7
    80001448:	bc1ff0ef          	jal	80001008 <mappages>
    8000144c:	dd55                	beqz	a0,80001408 <uvmcopy+0x26>
      kfree(mem);
    8000144e:	854e                	mv	a0,s3
    80001450:	dc6ff0ef          	jal	80000a16 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001454:	4685                	li	a3,1
    80001456:	00c4d613          	srli	a2,s1,0xc
    8000145a:	4581                	li	a1,0
    8000145c:	855e                	mv	a0,s7
    8000145e:	d77ff0ef          	jal	800011d4 <uvmunmap>
  return -1;
    80001462:	557d                	li	a0,-1
    80001464:	a011                	j	80001468 <uvmcopy+0x86>
  return 0;
    80001466:	4501                	li	a0,0
}
    80001468:	60a6                	ld	ra,72(sp)
    8000146a:	6406                	ld	s0,64(sp)
    8000146c:	74e2                	ld	s1,56(sp)
    8000146e:	7942                	ld	s2,48(sp)
    80001470:	79a2                	ld	s3,40(sp)
    80001472:	7a02                	ld	s4,32(sp)
    80001474:	6ae2                	ld	s5,24(sp)
    80001476:	6b42                	ld	s6,16(sp)
    80001478:	6ba2                	ld	s7,8(sp)
    8000147a:	6c02                	ld	s8,0(sp)
    8000147c:	6161                	addi	sp,sp,80
    8000147e:	8082                	ret
  return 0;
    80001480:	4501                	li	a0,0
}
    80001482:	8082                	ret

0000000080001484 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001484:	1141                	addi	sp,sp,-16
    80001486:	e406                	sd	ra,8(sp)
    80001488:	e022                	sd	s0,0(sp)
    8000148a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000148c:	4601                	li	a2,0
    8000148e:	aa3ff0ef          	jal	80000f30 <walk>
  if(pte == 0)
    80001492:	c901                	beqz	a0,800014a2 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001494:	611c                	ld	a5,0(a0)
    80001496:	9bbd                	andi	a5,a5,-17
    80001498:	e11c                	sd	a5,0(a0)
}
    8000149a:	60a2                	ld	ra,8(sp)
    8000149c:	6402                	ld	s0,0(sp)
    8000149e:	0141                	addi	sp,sp,16
    800014a0:	8082                	ret
    panic("uvmclear");
    800014a2:	00006517          	auipc	a0,0x6
    800014a6:	ca650513          	addi	a0,a0,-858 # 80007148 <etext+0x148>
    800014aa:	b34ff0ef          	jal	800007de <panic>

00000000800014ae <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    800014ae:	715d                	addi	sp,sp,-80
    800014b0:	e486                	sd	ra,72(sp)
    800014b2:	e0a2                	sd	s0,64(sp)
    800014b4:	fc26                	sd	s1,56(sp)
    800014b6:	f84a                	sd	s2,48(sp)
    800014b8:	f44e                	sd	s3,40(sp)
    800014ba:	f052                	sd	s4,32(sp)
    800014bc:	ec56                	sd	s5,24(sp)
    800014be:	e85a                	sd	s6,16(sp)
    800014c0:	e45e                	sd	s7,8(sp)
    800014c2:	0880                	addi	s0,sp,80
    800014c4:	8aaa                	mv	s5,a0
    800014c6:	89ae                	mv	s3,a1
    800014c8:	8bb2                	mv	s7,a2
    800014ca:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    800014cc:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800014ce:	6a05                	lui	s4,0x1
    800014d0:	a02d                	j	800014fa <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800014d2:	00078023          	sb	zero,0(a5)
    800014d6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800014d8:	0017c793          	xori	a5,a5,1
    800014dc:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800014e0:	60a6                	ld	ra,72(sp)
    800014e2:	6406                	ld	s0,64(sp)
    800014e4:	74e2                	ld	s1,56(sp)
    800014e6:	7942                	ld	s2,48(sp)
    800014e8:	79a2                	ld	s3,40(sp)
    800014ea:	7a02                	ld	s4,32(sp)
    800014ec:	6ae2                	ld	s5,24(sp)
    800014ee:	6b42                	ld	s6,16(sp)
    800014f0:	6ba2                	ld	s7,8(sp)
    800014f2:	6161                	addi	sp,sp,80
    800014f4:	8082                	ret
    srcva = va0 + PGSIZE;
    800014f6:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    800014fa:	c4b1                	beqz	s1,80001546 <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    800014fc:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001500:	85ca                	mv	a1,s2
    80001502:	8556                	mv	a0,s5
    80001504:	ac7ff0ef          	jal	80000fca <walkaddr>
    if(pa0 == 0)
    80001508:	c129                	beqz	a0,8000154a <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    8000150a:	41790633          	sub	a2,s2,s7
    8000150e:	9652                	add	a2,a2,s4
    if(n > max)
    80001510:	00c4f363          	bgeu	s1,a2,80001516 <copyinstr+0x68>
    80001514:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001516:	412b8bb3          	sub	s7,s7,s2
    8000151a:	9baa                	add	s7,s7,a0
    while(n > 0){
    8000151c:	de69                	beqz	a2,800014f6 <copyinstr+0x48>
    8000151e:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80001520:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80001524:	964e                	add	a2,a2,s3
    80001526:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001528:	00f68733          	add	a4,a3,a5
    8000152c:	00074703          	lbu	a4,0(a4)
    80001530:	d34d                	beqz	a4,800014d2 <copyinstr+0x24>
        *dst = *p;
    80001532:	00e78023          	sb	a4,0(a5)
      dst++;
    80001536:	0785                	addi	a5,a5,1
    while(n > 0){
    80001538:	fec797e3          	bne	a5,a2,80001526 <copyinstr+0x78>
    8000153c:	14fd                	addi	s1,s1,-1
    8000153e:	94ce                	add	s1,s1,s3
      --max;
    80001540:	8c8d                	sub	s1,s1,a1
    80001542:	89be                	mv	s3,a5
    80001544:	bf4d                	j	800014f6 <copyinstr+0x48>
    80001546:	4781                	li	a5,0
    80001548:	bf41                	j	800014d8 <copyinstr+0x2a>
      return -1;
    8000154a:	557d                	li	a0,-1
    8000154c:	bf51                	j	800014e0 <copyinstr+0x32>

000000008000154e <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    8000154e:	1141                	addi	sp,sp,-16
    80001550:	e406                	sd	ra,8(sp)
    80001552:	e022                	sd	s0,0(sp)
    80001554:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80001556:	4601                	li	a2,0
    80001558:	9d9ff0ef          	jal	80000f30 <walk>
  if (pte == 0) {
    8000155c:	c519                	beqz	a0,8000156a <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    8000155e:	6108                	ld	a0,0(a0)
    80001560:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80001562:	60a2                	ld	ra,8(sp)
    80001564:	6402                	ld	s0,0(sp)
    80001566:	0141                	addi	sp,sp,16
    80001568:	8082                	ret
    return 0;
    8000156a:	4501                	li	a0,0
    8000156c:	bfdd                	j	80001562 <ismapped+0x14>

000000008000156e <vmfault>:
{
    8000156e:	7179                	addi	sp,sp,-48
    80001570:	f406                	sd	ra,40(sp)
    80001572:	f022                	sd	s0,32(sp)
    80001574:	ec26                	sd	s1,24(sp)
    80001576:	e44e                	sd	s3,8(sp)
    80001578:	1800                	addi	s0,sp,48
    8000157a:	89aa                	mv	s3,a0
    8000157c:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    8000157e:	340000ef          	jal	800018be <myproc>
  if (va >= p->sz)
    80001582:	693c                	ld	a5,80(a0)
    80001584:	00f4ea63          	bltu	s1,a5,80001598 <vmfault+0x2a>
    return 0;
    80001588:	4981                	li	s3,0
}
    8000158a:	854e                	mv	a0,s3
    8000158c:	70a2                	ld	ra,40(sp)
    8000158e:	7402                	ld	s0,32(sp)
    80001590:	64e2                	ld	s1,24(sp)
    80001592:	69a2                	ld	s3,8(sp)
    80001594:	6145                	addi	sp,sp,48
    80001596:	8082                	ret
    80001598:	e84a                	sd	s2,16(sp)
    8000159a:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    8000159c:	77fd                	lui	a5,0xfffff
    8000159e:	8cfd                	and	s1,s1,a5
  if(ismapped(pagetable, va)) {
    800015a0:	85a6                	mv	a1,s1
    800015a2:	854e                	mv	a0,s3
    800015a4:	fabff0ef          	jal	8000154e <ismapped>
    return 0;
    800015a8:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    800015aa:	c119                	beqz	a0,800015b0 <vmfault+0x42>
    800015ac:	6942                	ld	s2,16(sp)
    800015ae:	bff1                	j	8000158a <vmfault+0x1c>
    800015b0:	e052                	sd	s4,0(sp)
  mem = (uint64) kalloc();
    800015b2:	d46ff0ef          	jal	80000af8 <kalloc>
    800015b6:	8a2a                	mv	s4,a0
  if(mem == 0)
    800015b8:	c90d                	beqz	a0,800015ea <vmfault+0x7c>
  mem = (uint64) kalloc();
    800015ba:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    800015bc:	6605                	lui	a2,0x1
    800015be:	4581                	li	a1,0
    800015c0:	edcff0ef          	jal	80000c9c <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    800015c4:	4759                	li	a4,22
    800015c6:	86d2                	mv	a3,s4
    800015c8:	6605                	lui	a2,0x1
    800015ca:	85a6                	mv	a1,s1
    800015cc:	05893503          	ld	a0,88(s2) # 1058 <_entry-0x7fffefa8>
    800015d0:	a39ff0ef          	jal	80001008 <mappages>
    800015d4:	e501                	bnez	a0,800015dc <vmfault+0x6e>
    800015d6:	6942                	ld	s2,16(sp)
    800015d8:	6a02                	ld	s4,0(sp)
    800015da:	bf45                	j	8000158a <vmfault+0x1c>
    kfree((void *)mem);
    800015dc:	8552                	mv	a0,s4
    800015de:	c38ff0ef          	jal	80000a16 <kfree>
    return 0;
    800015e2:	4981                	li	s3,0
    800015e4:	6942                	ld	s2,16(sp)
    800015e6:	6a02                	ld	s4,0(sp)
    800015e8:	b74d                	j	8000158a <vmfault+0x1c>
    800015ea:	6942                	ld	s2,16(sp)
    800015ec:	6a02                	ld	s4,0(sp)
    800015ee:	bf71                	j	8000158a <vmfault+0x1c>

00000000800015f0 <copyout>:
  while(len > 0){
    800015f0:	cad1                	beqz	a3,80001684 <copyout+0x94>
{
    800015f2:	711d                	addi	sp,sp,-96
    800015f4:	ec86                	sd	ra,88(sp)
    800015f6:	e8a2                	sd	s0,80(sp)
    800015f8:	e4a6                	sd	s1,72(sp)
    800015fa:	e0ca                	sd	s2,64(sp)
    800015fc:	fc4e                	sd	s3,56(sp)
    800015fe:	f852                	sd	s4,48(sp)
    80001600:	f456                	sd	s5,40(sp)
    80001602:	f05a                	sd	s6,32(sp)
    80001604:	ec5e                	sd	s7,24(sp)
    80001606:	e862                	sd	s8,16(sp)
    80001608:	e466                	sd	s9,8(sp)
    8000160a:	e06a                	sd	s10,0(sp)
    8000160c:	1080                	addi	s0,sp,96
    8000160e:	8baa                	mv	s7,a0
    80001610:	8a2e                	mv	s4,a1
    80001612:	8b32                	mv	s6,a2
    80001614:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80001616:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    80001618:	5cfd                	li	s9,-1
    8000161a:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    8000161e:	6c05                	lui	s8,0x1
    80001620:	a005                	j	80001640 <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001622:	409a0533          	sub	a0,s4,s1
    80001626:	0009061b          	sext.w	a2,s2
    8000162a:	85da                	mv	a1,s6
    8000162c:	954e                	add	a0,a0,s3
    8000162e:	ed2ff0ef          	jal	80000d00 <memmove>
    len -= n;
    80001632:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80001636:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80001638:	01848a33          	add	s4,s1,s8
  while(len > 0){
    8000163c:	040a8263          	beqz	s5,80001680 <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    80001640:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    80001644:	049ce263          	bltu	s9,s1,80001688 <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    80001648:	85a6                	mv	a1,s1
    8000164a:	855e                	mv	a0,s7
    8000164c:	97fff0ef          	jal	80000fca <walkaddr>
    80001650:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    80001652:	e901                	bnez	a0,80001662 <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001654:	4601                	li	a2,0
    80001656:	85a6                	mv	a1,s1
    80001658:	855e                	mv	a0,s7
    8000165a:	f15ff0ef          	jal	8000156e <vmfault>
    8000165e:	89aa                	mv	s3,a0
    80001660:	c139                	beqz	a0,800016a6 <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    80001662:	4601                	li	a2,0
    80001664:	85a6                	mv	a1,s1
    80001666:	855e                	mv	a0,s7
    80001668:	8c9ff0ef          	jal	80000f30 <walk>
    if((*pte & PTE_W) == 0)
    8000166c:	611c                	ld	a5,0(a0)
    8000166e:	8b91                	andi	a5,a5,4
    80001670:	cf8d                	beqz	a5,800016aa <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    80001672:	41448933          	sub	s2,s1,s4
    80001676:	9962                	add	s2,s2,s8
    if(n > len)
    80001678:	fb2af5e3          	bgeu	s5,s2,80001622 <copyout+0x32>
    8000167c:	8956                	mv	s2,s5
    8000167e:	b755                	j	80001622 <copyout+0x32>
  return 0;
    80001680:	4501                	li	a0,0
    80001682:	a021                	j	8000168a <copyout+0x9a>
    80001684:	4501                	li	a0,0
}
    80001686:	8082                	ret
      return -1;
    80001688:	557d                	li	a0,-1
}
    8000168a:	60e6                	ld	ra,88(sp)
    8000168c:	6446                	ld	s0,80(sp)
    8000168e:	64a6                	ld	s1,72(sp)
    80001690:	6906                	ld	s2,64(sp)
    80001692:	79e2                	ld	s3,56(sp)
    80001694:	7a42                	ld	s4,48(sp)
    80001696:	7aa2                	ld	s5,40(sp)
    80001698:	7b02                	ld	s6,32(sp)
    8000169a:	6be2                	ld	s7,24(sp)
    8000169c:	6c42                	ld	s8,16(sp)
    8000169e:	6ca2                	ld	s9,8(sp)
    800016a0:	6d02                	ld	s10,0(sp)
    800016a2:	6125                	addi	sp,sp,96
    800016a4:	8082                	ret
        return -1;
    800016a6:	557d                	li	a0,-1
    800016a8:	b7cd                	j	8000168a <copyout+0x9a>
      return -1;
    800016aa:	557d                	li	a0,-1
    800016ac:	bff9                	j	8000168a <copyout+0x9a>

00000000800016ae <copyin>:
  while(len > 0){
    800016ae:	c6c9                	beqz	a3,80001738 <copyin+0x8a>
{
    800016b0:	715d                	addi	sp,sp,-80
    800016b2:	e486                	sd	ra,72(sp)
    800016b4:	e0a2                	sd	s0,64(sp)
    800016b6:	fc26                	sd	s1,56(sp)
    800016b8:	f84a                	sd	s2,48(sp)
    800016ba:	f44e                	sd	s3,40(sp)
    800016bc:	f052                	sd	s4,32(sp)
    800016be:	ec56                	sd	s5,24(sp)
    800016c0:	e85a                	sd	s6,16(sp)
    800016c2:	e45e                	sd	s7,8(sp)
    800016c4:	e062                	sd	s8,0(sp)
    800016c6:	0880                	addi	s0,sp,80
    800016c8:	8baa                	mv	s7,a0
    800016ca:	8aae                	mv	s5,a1
    800016cc:	8932                	mv	s2,a2
    800016ce:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    800016d0:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    800016d2:	6b05                	lui	s6,0x1
    800016d4:	a035                	j	80001700 <copyin+0x52>
    800016d6:	412984b3          	sub	s1,s3,s2
    800016da:	94da                	add	s1,s1,s6
    if(n > len)
    800016dc:	009a7363          	bgeu	s4,s1,800016e2 <copyin+0x34>
    800016e0:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800016e2:	413905b3          	sub	a1,s2,s3
    800016e6:	0004861b          	sext.w	a2,s1
    800016ea:	95aa                	add	a1,a1,a0
    800016ec:	8556                	mv	a0,s5
    800016ee:	e12ff0ef          	jal	80000d00 <memmove>
    len -= n;
    800016f2:	409a0a33          	sub	s4,s4,s1
    dst += n;
    800016f6:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    800016f8:	01698933          	add	s2,s3,s6
  while(len > 0){
    800016fc:	020a0163          	beqz	s4,8000171e <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001700:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80001704:	85ce                	mv	a1,s3
    80001706:	855e                	mv	a0,s7
    80001708:	8c3ff0ef          	jal	80000fca <walkaddr>
    if(pa0 == 0) {
    8000170c:	f569                	bnez	a0,800016d6 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    8000170e:	4601                	li	a2,0
    80001710:	85ce                	mv	a1,s3
    80001712:	855e                	mv	a0,s7
    80001714:	e5bff0ef          	jal	8000156e <vmfault>
    80001718:	fd5d                	bnez	a0,800016d6 <copyin+0x28>
        return -1;
    8000171a:	557d                	li	a0,-1
    8000171c:	a011                	j	80001720 <copyin+0x72>
  return 0;
    8000171e:	4501                	li	a0,0
}
    80001720:	60a6                	ld	ra,72(sp)
    80001722:	6406                	ld	s0,64(sp)
    80001724:	74e2                	ld	s1,56(sp)
    80001726:	7942                	ld	s2,48(sp)
    80001728:	79a2                	ld	s3,40(sp)
    8000172a:	7a02                	ld	s4,32(sp)
    8000172c:	6ae2                	ld	s5,24(sp)
    8000172e:	6b42                	ld	s6,16(sp)
    80001730:	6ba2                	ld	s7,8(sp)
    80001732:	6c02                	ld	s8,0(sp)
    80001734:	6161                	addi	sp,sp,80
    80001736:	8082                	ret
  return 0;
    80001738:	4501                	li	a0,0
}
    8000173a:	8082                	ret

000000008000173c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    8000173c:	715d                	addi	sp,sp,-80
    8000173e:	e486                	sd	ra,72(sp)
    80001740:	e0a2                	sd	s0,64(sp)
    80001742:	fc26                	sd	s1,56(sp)
    80001744:	f84a                	sd	s2,48(sp)
    80001746:	f44e                	sd	s3,40(sp)
    80001748:	f052                	sd	s4,32(sp)
    8000174a:	ec56                	sd	s5,24(sp)
    8000174c:	e85a                	sd	s6,16(sp)
    8000174e:	e45e                	sd	s7,8(sp)
    80001750:	e062                	sd	s8,0(sp)
    80001752:	0880                	addi	s0,sp,80
    80001754:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    80001756:	0000e497          	auipc	s1,0xe
    8000175a:	65248493          	addi	s1,s1,1618 # 8000fda8 <proc>
        char *pa = kalloc();
        if (pa == 0)
            panic("kalloc");
        uint64 va = KSTACK((int)(p - proc));
    8000175e:	8c26                	mv	s8,s1
    80001760:	677d47b7          	lui	a5,0x677d4
    80001764:	6cf78793          	addi	a5,a5,1743 # 677d46cf <_entry-0x1882b931>
    80001768:	51b3c937          	lui	s2,0x51b3c
    8000176c:	ea390913          	addi	s2,s2,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80001770:	1902                	slli	s2,s2,0x20
    80001772:	993e                	add	s2,s2,a5
    80001774:	040009b7          	lui	s3,0x4000
    80001778:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000177a:	09b2                	slli	s3,s3,0xc
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000177c:	4b99                	li	s7,6
    8000177e:	6b05                	lui	s6,0x1
    for (p = proc; p < &proc[NPROC]; p++) {
    80001780:	00014a97          	auipc	s5,0x14
    80001784:	428a8a93          	addi	s5,s5,1064 # 80015ba8 <tickslock>
        char *pa = kalloc();
    80001788:	b70ff0ef          	jal	80000af8 <kalloc>
    8000178c:	862a                	mv	a2,a0
        if (pa == 0)
    8000178e:	c121                	beqz	a0,800017ce <proc_mapstacks+0x92>
        uint64 va = KSTACK((int)(p - proc));
    80001790:	418485b3          	sub	a1,s1,s8
    80001794:	858d                	srai	a1,a1,0x3
    80001796:	032585b3          	mul	a1,a1,s2
    8000179a:	2585                	addiw	a1,a1,1
    8000179c:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017a0:	875e                	mv	a4,s7
    800017a2:	86da                	mv	a3,s6
    800017a4:	40b985b3          	sub	a1,s3,a1
    800017a8:	8552                	mv	a0,s4
    800017aa:	915ff0ef          	jal	800010be <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++) {
    800017ae:	17848493          	addi	s1,s1,376
    800017b2:	fd549be3          	bne	s1,s5,80001788 <proc_mapstacks+0x4c>
    }
}
    800017b6:	60a6                	ld	ra,72(sp)
    800017b8:	6406                	ld	s0,64(sp)
    800017ba:	74e2                	ld	s1,56(sp)
    800017bc:	7942                	ld	s2,48(sp)
    800017be:	79a2                	ld	s3,40(sp)
    800017c0:	7a02                	ld	s4,32(sp)
    800017c2:	6ae2                	ld	s5,24(sp)
    800017c4:	6b42                	ld	s6,16(sp)
    800017c6:	6ba2                	ld	s7,8(sp)
    800017c8:	6c02                	ld	s8,0(sp)
    800017ca:	6161                	addi	sp,sp,80
    800017cc:	8082                	ret
            panic("kalloc");
    800017ce:	00006517          	auipc	a0,0x6
    800017d2:	98a50513          	addi	a0,a0,-1654 # 80007158 <etext+0x158>
    800017d6:	808ff0ef          	jal	800007de <panic>

00000000800017da <procinit>:

// initialize the proc table.
void procinit(void)
{
    800017da:	7139                	addi	sp,sp,-64
    800017dc:	fc06                	sd	ra,56(sp)
    800017de:	f822                	sd	s0,48(sp)
    800017e0:	f426                	sd	s1,40(sp)
    800017e2:	f04a                	sd	s2,32(sp)
    800017e4:	ec4e                	sd	s3,24(sp)
    800017e6:	e852                	sd	s4,16(sp)
    800017e8:	e456                	sd	s5,8(sp)
    800017ea:	e05a                	sd	s6,0(sp)
    800017ec:	0080                	addi	s0,sp,64
    struct proc *p;

    initlock(&pid_lock, "nextpid");
    800017ee:	00006597          	auipc	a1,0x6
    800017f2:	97258593          	addi	a1,a1,-1678 # 80007160 <etext+0x160>
    800017f6:	0000e517          	auipc	a0,0xe
    800017fa:	18250513          	addi	a0,a0,386 # 8000f978 <pid_lock>
    800017fe:	b4aff0ef          	jal	80000b48 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001802:	00006597          	auipc	a1,0x6
    80001806:	96658593          	addi	a1,a1,-1690 # 80007168 <etext+0x168>
    8000180a:	0000e517          	auipc	a0,0xe
    8000180e:	18650513          	addi	a0,a0,390 # 8000f990 <wait_lock>
    80001812:	b36ff0ef          	jal	80000b48 <initlock>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001816:	0000e497          	auipc	s1,0xe
    8000181a:	59248493          	addi	s1,s1,1426 # 8000fda8 <proc>
        initlock(&p->lock, "proc");
    8000181e:	00006b17          	auipc	s6,0x6
    80001822:	95ab0b13          	addi	s6,s6,-1702 # 80007178 <etext+0x178>
        p->state = UNUSED;
        p->kstack = KSTACK((int)(p - proc));
    80001826:	8aa6                	mv	s5,s1
    80001828:	677d47b7          	lui	a5,0x677d4
    8000182c:	6cf78793          	addi	a5,a5,1743 # 677d46cf <_entry-0x1882b931>
    80001830:	51b3c937          	lui	s2,0x51b3c
    80001834:	ea390913          	addi	s2,s2,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80001838:	1902                	slli	s2,s2,0x20
    8000183a:	993e                	add	s2,s2,a5
    8000183c:	040009b7          	lui	s3,0x4000
    80001840:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001842:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++) {
    80001844:	00014a17          	auipc	s4,0x14
    80001848:	364a0a13          	addi	s4,s4,868 # 80015ba8 <tickslock>
        initlock(&p->lock, "proc");
    8000184c:	85da                	mv	a1,s6
    8000184e:	8526                	mv	a0,s1
    80001850:	af8ff0ef          	jal	80000b48 <initlock>
        p->state = UNUSED;
    80001854:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001858:	415487b3          	sub	a5,s1,s5
    8000185c:	878d                	srai	a5,a5,0x3
    8000185e:	032787b3          	mul	a5,a5,s2
    80001862:	2785                	addiw	a5,a5,1
    80001864:	00d7979b          	slliw	a5,a5,0xd
    80001868:	40f987b3          	sub	a5,s3,a5
    8000186c:	e4bc                	sd	a5,72(s1)
    for (p = proc; p < &proc[NPROC]; p++) {
    8000186e:	17848493          	addi	s1,s1,376
    80001872:	fd449de3          	bne	s1,s4,8000184c <procinit+0x72>
    }
}
    80001876:	70e2                	ld	ra,56(sp)
    80001878:	7442                	ld	s0,48(sp)
    8000187a:	74a2                	ld	s1,40(sp)
    8000187c:	7902                	ld	s2,32(sp)
    8000187e:	69e2                	ld	s3,24(sp)
    80001880:	6a42                	ld	s4,16(sp)
    80001882:	6aa2                	ld	s5,8(sp)
    80001884:	6b02                	ld	s6,0(sp)
    80001886:	6121                	addi	sp,sp,64
    80001888:	8082                	ret

000000008000188a <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    8000188a:	1141                	addi	sp,sp,-16
    8000188c:	e406                	sd	ra,8(sp)
    8000188e:	e022                	sd	s0,0(sp)
    80001890:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001892:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    80001894:	2501                	sext.w	a0,a0
    80001896:	60a2                	ld	ra,8(sp)
    80001898:	6402                	ld	s0,0(sp)
    8000189a:	0141                	addi	sp,sp,16
    8000189c:	8082                	ret

000000008000189e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void)
{
    8000189e:	1141                	addi	sp,sp,-16
    800018a0:	e406                	sd	ra,8(sp)
    800018a2:	e022                	sd	s0,0(sp)
    800018a4:	0800                	addi	s0,sp,16
    800018a6:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu *c = &cpus[id];
    800018a8:	2781                	sext.w	a5,a5
    800018aa:	079e                	slli	a5,a5,0x7
    return c;
}
    800018ac:	0000e517          	auipc	a0,0xe
    800018b0:	0fc50513          	addi	a0,a0,252 # 8000f9a8 <cpus>
    800018b4:	953e                	add	a0,a0,a5
    800018b6:	60a2                	ld	ra,8(sp)
    800018b8:	6402                	ld	s0,0(sp)
    800018ba:	0141                	addi	sp,sp,16
    800018bc:	8082                	ret

00000000800018be <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void)
{
    800018be:	1101                	addi	sp,sp,-32
    800018c0:	ec06                	sd	ra,24(sp)
    800018c2:	e822                	sd	s0,16(sp)
    800018c4:	e426                	sd	s1,8(sp)
    800018c6:	1000                	addi	s0,sp,32
    push_off();
    800018c8:	ac4ff0ef          	jal	80000b8c <push_off>
    800018cc:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    800018ce:	2781                	sext.w	a5,a5
    800018d0:	079e                	slli	a5,a5,0x7
    800018d2:	0000e717          	auipc	a4,0xe
    800018d6:	0a670713          	addi	a4,a4,166 # 8000f978 <pid_lock>
    800018da:	97ba                	add	a5,a5,a4
    800018dc:	7b84                	ld	s1,48(a5)
    pop_off();
    800018de:	b32ff0ef          	jal	80000c10 <pop_off>
    return p;
}
    800018e2:	8526                	mv	a0,s1
    800018e4:	60e2                	ld	ra,24(sp)
    800018e6:	6442                	ld	s0,16(sp)
    800018e8:	64a2                	ld	s1,8(sp)
    800018ea:	6105                	addi	sp,sp,32
    800018ec:	8082                	ret

00000000800018ee <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    800018ee:	7179                	addi	sp,sp,-48
    800018f0:	f406                	sd	ra,40(sp)
    800018f2:	f022                	sd	s0,32(sp)
    800018f4:	ec26                	sd	s1,24(sp)
    800018f6:	1800                	addi	s0,sp,48
    extern char userret[];
    static int first = 1;
    struct proc *p = myproc();
    800018f8:	fc7ff0ef          	jal	800018be <myproc>
    800018fc:	84aa                	mv	s1,a0

    // Still holding p->lock from scheduler.
    release(&p->lock);
    800018fe:	b62ff0ef          	jal	80000c60 <release>

    if (first) {
    80001902:	00006797          	auipc	a5,0x6
    80001906:	f3e7a783          	lw	a5,-194(a5) # 80007840 <first.1>
    8000190a:	cf8d                	beqz	a5,80001944 <forkret+0x56>
        // File system initialization must be run in the context of a
        // regular process (e.g., because it calls sleep), and thus cannot
        // be run from main().
        fsinit(ROOTDEV);
    8000190c:	4505                	li	a0,1
    8000190e:	0ca020ef          	jal	800039d8 <fsinit>

        first = 0;
    80001912:	00006797          	auipc	a5,0x6
    80001916:	f207a723          	sw	zero,-210(a5) # 80007840 <first.1>
        // ensure other cores see first=0.
        __sync_synchronize();
    8000191a:	0330000f          	fence	rw,rw

        // We can invoke kexec() now that file system is initialized.
        // Put the return value (argc) of kexec into a0.
        p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    8000191e:	00006517          	auipc	a0,0x6
    80001922:	86250513          	addi	a0,a0,-1950 # 80007180 <etext+0x180>
    80001926:	fca43823          	sd	a0,-48(s0)
    8000192a:	fc043c23          	sd	zero,-40(s0)
    8000192e:	fd040593          	addi	a1,s0,-48
    80001932:	206030ef          	jal	80004b38 <kexec>
    80001936:	70bc                	ld	a5,96(s1)
    80001938:	fba8                	sd	a0,112(a5)
        if (p->trapframe->a0 == -1) {
    8000193a:	70bc                	ld	a5,96(s1)
    8000193c:	7bb8                	ld	a4,112(a5)
    8000193e:	57fd                	li	a5,-1
    80001940:	02f70d63          	beq	a4,a5,8000197a <forkret+0x8c>
            panic("exec");
        }
    }

    // return to user space, mimicing usertrap()'s return.
    prepare_return();
    80001944:	6a3000ef          	jal	800027e6 <prepare_return>
    uint64 satp = MAKE_SATP(p->pagetable);
    80001948:	6ca8                	ld	a0,88(s1)
    8000194a:	8131                	srli	a0,a0,0xc
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000194c:	04000737          	lui	a4,0x4000
    80001950:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001952:	0732                	slli	a4,a4,0xc
    80001954:	00004797          	auipc	a5,0x4
    80001958:	74078793          	addi	a5,a5,1856 # 80006094 <userret>
    8000195c:	00004697          	auipc	a3,0x4
    80001960:	6a468693          	addi	a3,a3,1700 # 80006000 <_trampoline>
    80001964:	8f95                	sub	a5,a5,a3
    80001966:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)((uint64)satp);
    80001968:	577d                	li	a4,-1
    8000196a:	177e                	slli	a4,a4,0x3f
    8000196c:	8d59                	or	a0,a0,a4
    8000196e:	9782                	jalr	a5
}
    80001970:	70a2                	ld	ra,40(sp)
    80001972:	7402                	ld	s0,32(sp)
    80001974:	64e2                	ld	s1,24(sp)
    80001976:	6145                	addi	sp,sp,48
    80001978:	8082                	ret
            panic("exec");
    8000197a:	00006517          	auipc	a0,0x6
    8000197e:	80e50513          	addi	a0,a0,-2034 # 80007188 <etext+0x188>
    80001982:	e5dfe0ef          	jal	800007de <panic>

0000000080001986 <allocpid>:
{
    80001986:	1101                	addi	sp,sp,-32
    80001988:	ec06                	sd	ra,24(sp)
    8000198a:	e822                	sd	s0,16(sp)
    8000198c:	e426                	sd	s1,8(sp)
    8000198e:	e04a                	sd	s2,0(sp)
    80001990:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001992:	0000e917          	auipc	s2,0xe
    80001996:	fe690913          	addi	s2,s2,-26 # 8000f978 <pid_lock>
    8000199a:	854a                	mv	a0,s2
    8000199c:	a30ff0ef          	jal	80000bcc <acquire>
    pid = nextpid;
    800019a0:	00006797          	auipc	a5,0x6
    800019a4:	ea478793          	addi	a5,a5,-348 # 80007844 <nextpid>
    800019a8:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    800019aa:	0014871b          	addiw	a4,s1,1
    800019ae:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    800019b0:	854a                	mv	a0,s2
    800019b2:	aaeff0ef          	jal	80000c60 <release>
}
    800019b6:	8526                	mv	a0,s1
    800019b8:	60e2                	ld	ra,24(sp)
    800019ba:	6442                	ld	s0,16(sp)
    800019bc:	64a2                	ld	s1,8(sp)
    800019be:	6902                	ld	s2,0(sp)
    800019c0:	6105                	addi	sp,sp,32
    800019c2:	8082                	ret

00000000800019c4 <proc_pagetable>:
{
    800019c4:	1101                	addi	sp,sp,-32
    800019c6:	ec06                	sd	ra,24(sp)
    800019c8:	e822                	sd	s0,16(sp)
    800019ca:	e426                	sd	s1,8(sp)
    800019cc:	e04a                	sd	s2,0(sp)
    800019ce:	1000                	addi	s0,sp,32
    800019d0:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    800019d2:	fdcff0ef          	jal	800011ae <uvmcreate>
    800019d6:	84aa                	mv	s1,a0
    if (pagetable == 0)
    800019d8:	c13d                	beqz	a0,80001a3e <proc_pagetable+0x7a>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    800019da:	4729                	li	a4,10
    800019dc:	00004697          	auipc	a3,0x4
    800019e0:	62468693          	addi	a3,a3,1572 # 80006000 <_trampoline>
    800019e4:	6605                	lui	a2,0x1
    800019e6:	040005b7          	lui	a1,0x4000
    800019ea:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019ec:	05b2                	slli	a1,a1,0xc
    800019ee:	e1aff0ef          	jal	80001008 <mappages>
    800019f2:	04054d63          	bltz	a0,80001a4c <proc_pagetable+0x88>
    if (mappages(pagetable, TRAPFRAME((int)(p - proc)), PGSIZE,
    800019f6:	0000e797          	auipc	a5,0xe
    800019fa:	3b278793          	addi	a5,a5,946 # 8000fda8 <proc>
    800019fe:	40f907b3          	sub	a5,s2,a5
    80001a02:	878d                	srai	a5,a5,0x3
    80001a04:	677d46b7          	lui	a3,0x677d4
    80001a08:	6cf68693          	addi	a3,a3,1743 # 677d46cf <_entry-0x1882b931>
    80001a0c:	51b3c737          	lui	a4,0x51b3c
    80001a10:	ea370713          	addi	a4,a4,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80001a14:	1702                	slli	a4,a4,0x20
    80001a16:	9736                	add	a4,a4,a3
    80001a18:	02e787b3          	mul	a5,a5,a4
    80001a1c:	2785                	addiw	a5,a5,1
    80001a1e:	00c7979b          	slliw	a5,a5,0xc
    80001a22:	040005b7          	lui	a1,0x4000
    80001a26:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a28:	05b2                	slli	a1,a1,0xc
    80001a2a:	4719                	li	a4,6
    80001a2c:	06093683          	ld	a3,96(s2)
    80001a30:	6605                	lui	a2,0x1
    80001a32:	8d9d                	sub	a1,a1,a5
    80001a34:	8526                	mv	a0,s1
    80001a36:	dd2ff0ef          	jal	80001008 <mappages>
    80001a3a:	00054f63          	bltz	a0,80001a58 <proc_pagetable+0x94>
}
    80001a3e:	8526                	mv	a0,s1
    80001a40:	60e2                	ld	ra,24(sp)
    80001a42:	6442                	ld	s0,16(sp)
    80001a44:	64a2                	ld	s1,8(sp)
    80001a46:	6902                	ld	s2,0(sp)
    80001a48:	6105                	addi	sp,sp,32
    80001a4a:	8082                	ret
        uvmfree(pagetable, 0);
    80001a4c:	4581                	li	a1,0
    80001a4e:	8526                	mv	a0,s1
    80001a50:	961ff0ef          	jal	800013b0 <uvmfree>
        return 0;
    80001a54:	4481                	li	s1,0
    80001a56:	b7e5                	j	80001a3e <proc_pagetable+0x7a>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a58:	4681                	li	a3,0
    80001a5a:	4605                	li	a2,1
    80001a5c:	040005b7          	lui	a1,0x4000
    80001a60:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a62:	05b2                	slli	a1,a1,0xc
    80001a64:	8526                	mv	a0,s1
    80001a66:	f6eff0ef          	jal	800011d4 <uvmunmap>
        uvmfree(pagetable, 0);
    80001a6a:	4581                	li	a1,0
    80001a6c:	8526                	mv	a0,s1
    80001a6e:	943ff0ef          	jal	800013b0 <uvmfree>
        return 0;
    80001a72:	4481                	li	s1,0
    80001a74:	b7e9                	j	80001a3e <proc_pagetable+0x7a>

0000000080001a76 <proc_freepagetable>:
{
    80001a76:	7179                	addi	sp,sp,-48
    80001a78:	f406                	sd	ra,40(sp)
    80001a7a:	f022                	sd	s0,32(sp)
    80001a7c:	ec26                	sd	s1,24(sp)
    80001a7e:	e84a                	sd	s2,16(sp)
    80001a80:	e44e                	sd	s3,8(sp)
    80001a82:	1800                	addi	s0,sp,48
    80001a84:	892a                	mv	s2,a0
    80001a86:	89ae                	mv	s3,a1
    80001a88:	84b2                	mv	s1,a2
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a8a:	4681                	li	a3,0
    80001a8c:	4605                	li	a2,1
    80001a8e:	040005b7          	lui	a1,0x4000
    80001a92:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a94:	05b2                	slli	a1,a1,0xc
    80001a96:	f3eff0ef          	jal	800011d4 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME(idx), 1, 0);
    80001a9a:	2485                	addiw	s1,s1,1
    80001a9c:	00c4949b          	slliw	s1,s1,0xc
    80001aa0:	040007b7          	lui	a5,0x4000
    80001aa4:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001aa6:	07b2                	slli	a5,a5,0xc
    80001aa8:	4681                	li	a3,0
    80001aaa:	4605                	li	a2,1
    80001aac:	409785b3          	sub	a1,a5,s1
    80001ab0:	854a                	mv	a0,s2
    80001ab2:	f22ff0ef          	jal	800011d4 <uvmunmap>
    uvmfree(pagetable, sz);
    80001ab6:	85ce                	mv	a1,s3
    80001ab8:	854a                	mv	a0,s2
    80001aba:	8f7ff0ef          	jal	800013b0 <uvmfree>
}
    80001abe:	70a2                	ld	ra,40(sp)
    80001ac0:	7402                	ld	s0,32(sp)
    80001ac2:	64e2                	ld	s1,24(sp)
    80001ac4:	6942                	ld	s2,16(sp)
    80001ac6:	69a2                	ld	s3,8(sp)
    80001ac8:	6145                	addi	sp,sp,48
    80001aca:	8082                	ret

0000000080001acc <freeproc>:
{
    80001acc:	1101                	addi	sp,sp,-32
    80001ace:	ec06                	sd	ra,24(sp)
    80001ad0:	e822                	sd	s0,16(sp)
    80001ad2:	e426                	sd	s1,8(sp)
    80001ad4:	1000                	addi	s0,sp,32
    80001ad6:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001ad8:	7128                	ld	a0,96(a0)
    80001ada:	c119                	beqz	a0,80001ae0 <freeproc+0x14>
        kfree((void *)p->trapframe);
    80001adc:	f3bfe0ef          	jal	80000a16 <kfree>
    p->trapframe = 0;
    80001ae0:	0604b023          	sd	zero,96(s1)
    if (p->pagetable) {
    80001ae4:	6ca8                	ld	a0,88(s1)
    80001ae6:	c521                	beqz	a0,80001b2e <freeproc+0x62>
        if (p->pid == p->tgid) {
    80001ae8:	5898                	lw	a4,48(s1)
    80001aea:	58dc                	lw	a5,52(s1)
    80001aec:	06f70863          	beq	a4,a5,80001b5c <freeproc+0x90>
            uvmunmap(p->pagetable, TRAPFRAME((int)(p - proc)), 1, 0);
    80001af0:	0000e797          	auipc	a5,0xe
    80001af4:	2b878793          	addi	a5,a5,696 # 8000fda8 <proc>
    80001af8:	40f487b3          	sub	a5,s1,a5
    80001afc:	878d                	srai	a5,a5,0x3
    80001afe:	677d46b7          	lui	a3,0x677d4
    80001b02:	6cf68693          	addi	a3,a3,1743 # 677d46cf <_entry-0x1882b931>
    80001b06:	51b3c737          	lui	a4,0x51b3c
    80001b0a:	ea370713          	addi	a4,a4,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80001b0e:	1702                	slli	a4,a4,0x20
    80001b10:	9736                	add	a4,a4,a3
    80001b12:	02e787b3          	mul	a5,a5,a4
    80001b16:	2785                	addiw	a5,a5,1
    80001b18:	00c7979b          	slliw	a5,a5,0xc
    80001b1c:	040005b7          	lui	a1,0x4000
    80001b20:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b22:	05b2                	slli	a1,a1,0xc
    80001b24:	4681                	li	a3,0
    80001b26:	4605                	li	a2,1
    80001b28:	8d9d                	sub	a1,a1,a5
    80001b2a:	eaaff0ef          	jal	800011d4 <uvmunmap>
    p->pagetable = 0;
    80001b2e:	0404bc23          	sd	zero,88(s1)
    p->sz = 0;
    80001b32:	0404b823          	sd	zero,80(s1)
    p->pid = 0;
    80001b36:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001b3a:	0404b023          	sd	zero,64(s1)
    p->name[0] = 0;
    80001b3e:	16048023          	sb	zero,352(s1)
    p->chan = 0;
    80001b42:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001b46:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001b4a:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001b4e:	0004ac23          	sw	zero,24(s1)
}
    80001b52:	60e2                	ld	ra,24(sp)
    80001b54:	6442                	ld	s0,16(sp)
    80001b56:	64a2                	ld	s1,8(sp)
    80001b58:	6105                	addi	sp,sp,32
    80001b5a:	8082                	ret
            proc_freepagetable(p->pagetable, p->sz, (int)(p - proc));
    80001b5c:	0000e617          	auipc	a2,0xe
    80001b60:	24c60613          	addi	a2,a2,588 # 8000fda8 <proc>
    80001b64:	40c48633          	sub	a2,s1,a2
    80001b68:	860d                	srai	a2,a2,0x3
    80001b6a:	677d4737          	lui	a4,0x677d4
    80001b6e:	6cf70713          	addi	a4,a4,1743 # 677d46cf <_entry-0x1882b931>
    80001b72:	51b3c7b7          	lui	a5,0x51b3c
    80001b76:	ea378793          	addi	a5,a5,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80001b7a:	1782                	slli	a5,a5,0x20
    80001b7c:	97ba                	add	a5,a5,a4
    80001b7e:	02f6063b          	mulw	a2,a2,a5
    80001b82:	68ac                	ld	a1,80(s1)
    80001b84:	ef3ff0ef          	jal	80001a76 <proc_freepagetable>
    80001b88:	b75d                	j	80001b2e <freeproc+0x62>

0000000080001b8a <allocproc>:
{
    80001b8a:	1101                	addi	sp,sp,-32
    80001b8c:	ec06                	sd	ra,24(sp)
    80001b8e:	e822                	sd	s0,16(sp)
    80001b90:	e426                	sd	s1,8(sp)
    80001b92:	e04a                	sd	s2,0(sp)
    80001b94:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++) {
    80001b96:	0000e497          	auipc	s1,0xe
    80001b9a:	21248493          	addi	s1,s1,530 # 8000fda8 <proc>
    80001b9e:	00014917          	auipc	s2,0x14
    80001ba2:	00a90913          	addi	s2,s2,10 # 80015ba8 <tickslock>
        acquire(&p->lock);
    80001ba6:	8526                	mv	a0,s1
    80001ba8:	824ff0ef          	jal	80000bcc <acquire>
        if (p->state == UNUSED) {
    80001bac:	4c9c                	lw	a5,24(s1)
    80001bae:	cb91                	beqz	a5,80001bc2 <allocproc+0x38>
            release(&p->lock);
    80001bb0:	8526                	mv	a0,s1
    80001bb2:	8aeff0ef          	jal	80000c60 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001bb6:	17848493          	addi	s1,s1,376
    80001bba:	ff2496e3          	bne	s1,s2,80001ba6 <allocproc+0x1c>
    return 0;
    80001bbe:	4481                	li	s1,0
    80001bc0:	a099                	j	80001c06 <allocproc+0x7c>
    p->pid = allocpid();
    80001bc2:	dc5ff0ef          	jal	80001986 <allocpid>
    80001bc6:	d888                	sw	a0,48(s1)
    p->tgid = p->pid;
    80001bc8:	d8c8                	sw	a0,52(s1)
    p->state = USED;
    80001bca:	4785                	li	a5,1
    80001bcc:	cc9c                	sw	a5,24(s1)
    p->thread_count = 1;
    80001bce:	dc9c                	sw	a5,56(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001bd0:	f29fe0ef          	jal	80000af8 <kalloc>
    80001bd4:	892a                	mv	s2,a0
    80001bd6:	f0a8                	sd	a0,96(s1)
    80001bd8:	cd15                	beqz	a0,80001c14 <allocproc+0x8a>
    p->pagetable = proc_pagetable(p);
    80001bda:	8526                	mv	a0,s1
    80001bdc:	de9ff0ef          	jal	800019c4 <proc_pagetable>
    80001be0:	892a                	mv	s2,a0
    80001be2:	eca8                	sd	a0,88(s1)
    if (p->pagetable == 0) {
    80001be4:	c121                	beqz	a0,80001c24 <allocproc+0x9a>
    memset(&p->context, 0, sizeof(p->context));
    80001be6:	07000613          	li	a2,112
    80001bea:	4581                	li	a1,0
    80001bec:	06848513          	addi	a0,s1,104
    80001bf0:	8acff0ef          	jal	80000c9c <memset>
    p->context.ra = (uint64)forkret;
    80001bf4:	00000797          	auipc	a5,0x0
    80001bf8:	cfa78793          	addi	a5,a5,-774 # 800018ee <forkret>
    80001bfc:	f4bc                	sd	a5,104(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001bfe:	64bc                	ld	a5,72(s1)
    80001c00:	6705                	lui	a4,0x1
    80001c02:	97ba                	add	a5,a5,a4
    80001c04:	f8bc                	sd	a5,112(s1)
}
    80001c06:	8526                	mv	a0,s1
    80001c08:	60e2                	ld	ra,24(sp)
    80001c0a:	6442                	ld	s0,16(sp)
    80001c0c:	64a2                	ld	s1,8(sp)
    80001c0e:	6902                	ld	s2,0(sp)
    80001c10:	6105                	addi	sp,sp,32
    80001c12:	8082                	ret
        freeproc(p);
    80001c14:	8526                	mv	a0,s1
    80001c16:	eb7ff0ef          	jal	80001acc <freeproc>
        release(&p->lock);
    80001c1a:	8526                	mv	a0,s1
    80001c1c:	844ff0ef          	jal	80000c60 <release>
        return 0;
    80001c20:	84ca                	mv	s1,s2
    80001c22:	b7d5                	j	80001c06 <allocproc+0x7c>
        freeproc(p);
    80001c24:	8526                	mv	a0,s1
    80001c26:	ea7ff0ef          	jal	80001acc <freeproc>
        release(&p->lock);
    80001c2a:	8526                	mv	a0,s1
    80001c2c:	834ff0ef          	jal	80000c60 <release>
        return 0;
    80001c30:	84ca                	mv	s1,s2
    80001c32:	bfd1                	j	80001c06 <allocproc+0x7c>

0000000080001c34 <userinit>:
{
    80001c34:	1101                	addi	sp,sp,-32
    80001c36:	ec06                	sd	ra,24(sp)
    80001c38:	e822                	sd	s0,16(sp)
    80001c3a:	e426                	sd	s1,8(sp)
    80001c3c:	1000                	addi	s0,sp,32
    p = allocproc();
    80001c3e:	f4dff0ef          	jal	80001b8a <allocproc>
    80001c42:	84aa                	mv	s1,a0
    initproc = p;
    80001c44:	00006797          	auipc	a5,0x6
    80001c48:	c2a7b623          	sd	a0,-980(a5) # 80007870 <initproc>
    p->cwd = namei("/");
    80001c4c:	00005517          	auipc	a0,0x5
    80001c50:	54450513          	addi	a0,a0,1348 # 80007190 <etext+0x190>
    80001c54:	2bc020ef          	jal	80003f10 <namei>
    80001c58:	14a4bc23          	sd	a0,344(s1)
    p->state = RUNNABLE;
    80001c5c:	478d                	li	a5,3
    80001c5e:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001c60:	8526                	mv	a0,s1
    80001c62:	ffffe0ef          	jal	80000c60 <release>
}
    80001c66:	60e2                	ld	ra,24(sp)
    80001c68:	6442                	ld	s0,16(sp)
    80001c6a:	64a2                	ld	s1,8(sp)
    80001c6c:	6105                	addi	sp,sp,32
    80001c6e:	8082                	ret

0000000080001c70 <kfork>:
{
    80001c70:	7139                	addi	sp,sp,-64
    80001c72:	fc06                	sd	ra,56(sp)
    80001c74:	f822                	sd	s0,48(sp)
    80001c76:	f04a                	sd	s2,32(sp)
    80001c78:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80001c7a:	c45ff0ef          	jal	800018be <myproc>
    if (p->pid != p->tgid)
    80001c7e:	5918                	lw	a4,48(a0)
    80001c80:	595c                	lw	a5,52(a0)
    80001c82:	10f71163          	bne	a4,a5,80001d84 <kfork+0x114>
    80001c86:	e852                	sd	s4,16(sp)
    80001c88:	e456                	sd	s5,8(sp)
    80001c8a:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0) {
    80001c8c:	effff0ef          	jal	80001b8a <allocproc>
    80001c90:	8a2a                	mv	s4,a0
    80001c92:	0e050b63          	beqz	a0,80001d88 <kfork+0x118>
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001c96:	050ab603          	ld	a2,80(s5)
    80001c9a:	6d2c                	ld	a1,88(a0)
    80001c9c:	058ab503          	ld	a0,88(s5)
    80001ca0:	f42ff0ef          	jal	800013e2 <uvmcopy>
    80001ca4:	04054a63          	bltz	a0,80001cf8 <kfork+0x88>
    80001ca8:	f426                	sd	s1,40(sp)
    80001caa:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    80001cac:	050ab783          	ld	a5,80(s5)
    80001cb0:	04fa3823          	sd	a5,80(s4)
    *(np->trapframe) = *(p->trapframe);
    80001cb4:	060ab683          	ld	a3,96(s5)
    80001cb8:	87b6                	mv	a5,a3
    80001cba:	060a3703          	ld	a4,96(s4)
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
    80001cde:	fed792e3          	bne	a5,a3,80001cc2 <kfork+0x52>
    np->trapframe->a0 = 0;
    80001ce2:	060a3783          	ld	a5,96(s4)
    80001ce6:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    80001cea:	0d8a8493          	addi	s1,s5,216
    80001cee:	0d8a0913          	addi	s2,s4,216
    80001cf2:	158a8993          	addi	s3,s5,344
    80001cf6:	a839                	j	80001d14 <kfork+0xa4>
        freeproc(np);
    80001cf8:	8552                	mv	a0,s4
    80001cfa:	dd3ff0ef          	jal	80001acc <freeproc>
        release(&np->lock);
    80001cfe:	8552                	mv	a0,s4
    80001d00:	f61fe0ef          	jal	80000c60 <release>
        return -1;
    80001d04:	597d                	li	s2,-1
    80001d06:	6a42                	ld	s4,16(sp)
    80001d08:	6aa2                	ld	s5,8(sp)
    80001d0a:	a0bd                	j	80001d78 <kfork+0x108>
    for (i = 0; i < NOFILE; i++)
    80001d0c:	04a1                	addi	s1,s1,8
    80001d0e:	0921                	addi	s2,s2,8
    80001d10:	01348963          	beq	s1,s3,80001d22 <kfork+0xb2>
        if (p->ofile[i])
    80001d14:	6088                	ld	a0,0(s1)
    80001d16:	d97d                	beqz	a0,80001d0c <kfork+0x9c>
            np->ofile[i] = filedup(p->ofile[i]);
    80001d18:	79e020ef          	jal	800044b6 <filedup>
    80001d1c:	00a93023          	sd	a0,0(s2)
    80001d20:	b7f5                	j	80001d0c <kfork+0x9c>
    np->cwd = idup(p->cwd);
    80001d22:	158ab503          	ld	a0,344(s5)
    80001d26:	18b010ef          	jal	800036b0 <idup>
    80001d2a:	14aa3c23          	sd	a0,344(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80001d2e:	4641                	li	a2,16
    80001d30:	160a8593          	addi	a1,s5,352
    80001d34:	160a0513          	addi	a0,s4,352
    80001d38:	8b6ff0ef          	jal	80000dee <safestrcpy>
    pid = np->pid;
    80001d3c:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    80001d40:	8552                	mv	a0,s4
    80001d42:	f1ffe0ef          	jal	80000c60 <release>
    acquire(&wait_lock);
    80001d46:	0000e497          	auipc	s1,0xe
    80001d4a:	c4a48493          	addi	s1,s1,-950 # 8000f990 <wait_lock>
    80001d4e:	8526                	mv	a0,s1
    80001d50:	e7dfe0ef          	jal	80000bcc <acquire>
    np->parent = p;
    80001d54:	055a3023          	sd	s5,64(s4)
    release(&wait_lock);
    80001d58:	8526                	mv	a0,s1
    80001d5a:	f07fe0ef          	jal	80000c60 <release>
    acquire(&np->lock);
    80001d5e:	8552                	mv	a0,s4
    80001d60:	e6dfe0ef          	jal	80000bcc <acquire>
    np->state = RUNNABLE;
    80001d64:	478d                	li	a5,3
    80001d66:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    80001d6a:	8552                	mv	a0,s4
    80001d6c:	ef5fe0ef          	jal	80000c60 <release>
    return pid;
    80001d70:	74a2                	ld	s1,40(sp)
    80001d72:	69e2                	ld	s3,24(sp)
    80001d74:	6a42                	ld	s4,16(sp)
    80001d76:	6aa2                	ld	s5,8(sp)
}
    80001d78:	854a                	mv	a0,s2
    80001d7a:	70e2                	ld	ra,56(sp)
    80001d7c:	7442                	ld	s0,48(sp)
    80001d7e:	7902                	ld	s2,32(sp)
    80001d80:	6121                	addi	sp,sp,64
    80001d82:	8082                	ret
        return -1;
    80001d84:	597d                	li	s2,-1
    80001d86:	bfcd                	j	80001d78 <kfork+0x108>
        return -1;
    80001d88:	597d                	li	s2,-1
    80001d8a:	6a42                	ld	s4,16(sp)
    80001d8c:	6aa2                	ld	s5,8(sp)
    80001d8e:	b7ed                	j	80001d78 <kfork+0x108>

0000000080001d90 <scheduler>:
{
    80001d90:	715d                	addi	sp,sp,-80
    80001d92:	e486                	sd	ra,72(sp)
    80001d94:	e0a2                	sd	s0,64(sp)
    80001d96:	fc26                	sd	s1,56(sp)
    80001d98:	f84a                	sd	s2,48(sp)
    80001d9a:	f44e                	sd	s3,40(sp)
    80001d9c:	f052                	sd	s4,32(sp)
    80001d9e:	ec56                	sd	s5,24(sp)
    80001da0:	e85a                	sd	s6,16(sp)
    80001da2:	e45e                	sd	s7,8(sp)
    80001da4:	e062                	sd	s8,0(sp)
    80001da6:	0880                	addi	s0,sp,80
    80001da8:	8792                	mv	a5,tp
    int id = r_tp();
    80001daa:	2781                	sext.w	a5,a5
    c->proc = 0;
    80001dac:	00779b13          	slli	s6,a5,0x7
    80001db0:	0000e717          	auipc	a4,0xe
    80001db4:	bc870713          	addi	a4,a4,-1080 # 8000f978 <pid_lock>
    80001db8:	975a                	add	a4,a4,s6
    80001dba:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    80001dbe:	0000e717          	auipc	a4,0xe
    80001dc2:	bf270713          	addi	a4,a4,-1038 # 8000f9b0 <cpus+0x8>
    80001dc6:	9b3a                	add	s6,s6,a4
                p->state = RUNNING;
    80001dc8:	4c11                	li	s8,4
                c->proc = p;
    80001dca:	079e                	slli	a5,a5,0x7
    80001dcc:	0000ea17          	auipc	s4,0xe
    80001dd0:	baca0a13          	addi	s4,s4,-1108 # 8000f978 <pid_lock>
    80001dd4:	9a3e                	add	s4,s4,a5
                found = 1;
    80001dd6:	4b85                	li	s7,1
    80001dd8:	a83d                	j	80001e16 <scheduler+0x86>
            release(&p->lock);
    80001dda:	8526                	mv	a0,s1
    80001ddc:	e85fe0ef          	jal	80000c60 <release>
        for (p = proc; p < &proc[NPROC]; p++) {
    80001de0:	17848493          	addi	s1,s1,376
    80001de4:	03248563          	beq	s1,s2,80001e0e <scheduler+0x7e>
            acquire(&p->lock);
    80001de8:	8526                	mv	a0,s1
    80001dea:	de3fe0ef          	jal	80000bcc <acquire>
            if (p->state == RUNNABLE) {
    80001dee:	4c9c                	lw	a5,24(s1)
    80001df0:	ff3795e3          	bne	a5,s3,80001dda <scheduler+0x4a>
                p->state = RUNNING;
    80001df4:	0184ac23          	sw	s8,24(s1)
                c->proc = p;
    80001df8:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    80001dfc:	06848593          	addi	a1,s1,104
    80001e00:	855a                	mv	a0,s6
    80001e02:	13b000ef          	jal	8000273c <swtch>
                c->proc = 0;
    80001e06:	020a3823          	sd	zero,48(s4)
                found = 1;
    80001e0a:	8ade                	mv	s5,s7
    80001e0c:	b7f9                	j	80001dda <scheduler+0x4a>
        if (found == 0) {
    80001e0e:	000a9463          	bnez	s5,80001e16 <scheduler+0x86>
            asm volatile("wfi");
    80001e12:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e16:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e1a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e1e:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001e26:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e28:	10079073          	csrw	sstatus,a5
        int found = 0;
    80001e2c:	4a81                	li	s5,0
        for (p = proc; p < &proc[NPROC]; p++) {
    80001e2e:	0000e497          	auipc	s1,0xe
    80001e32:	f7a48493          	addi	s1,s1,-134 # 8000fda8 <proc>
            if (p->state == RUNNABLE) {
    80001e36:	498d                	li	s3,3
        for (p = proc; p < &proc[NPROC]; p++) {
    80001e38:	00014917          	auipc	s2,0x14
    80001e3c:	d7090913          	addi	s2,s2,-656 # 80015ba8 <tickslock>
    80001e40:	b765                	j	80001de8 <scheduler+0x58>

0000000080001e42 <sched>:
{
    80001e42:	7179                	addi	sp,sp,-48
    80001e44:	f406                	sd	ra,40(sp)
    80001e46:	f022                	sd	s0,32(sp)
    80001e48:	ec26                	sd	s1,24(sp)
    80001e4a:	e84a                	sd	s2,16(sp)
    80001e4c:	e44e                	sd	s3,8(sp)
    80001e4e:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80001e50:	a6fff0ef          	jal	800018be <myproc>
    80001e54:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    80001e56:	d0dfe0ef          	jal	80000b62 <holding>
    80001e5a:	c92d                	beqz	a0,80001ecc <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e5c:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80001e5e:	2781                	sext.w	a5,a5
    80001e60:	079e                	slli	a5,a5,0x7
    80001e62:	0000e717          	auipc	a4,0xe
    80001e66:	b1670713          	addi	a4,a4,-1258 # 8000f978 <pid_lock>
    80001e6a:	97ba                	add	a5,a5,a4
    80001e6c:	0a87a703          	lw	a4,168(a5)
    80001e70:	4785                	li	a5,1
    80001e72:	06f71363          	bne	a4,a5,80001ed8 <sched+0x96>
    if (p->state == RUNNING)
    80001e76:	4c98                	lw	a4,24(s1)
    80001e78:	4791                	li	a5,4
    80001e7a:	06f70563          	beq	a4,a5,80001ee4 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e7e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e82:	8b89                	andi	a5,a5,2
    if (intr_get())
    80001e84:	e7b5                	bnez	a5,80001ef0 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e86:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80001e88:	0000e917          	auipc	s2,0xe
    80001e8c:	af090913          	addi	s2,s2,-1296 # 8000f978 <pid_lock>
    80001e90:	2781                	sext.w	a5,a5
    80001e92:	079e                	slli	a5,a5,0x7
    80001e94:	97ca                	add	a5,a5,s2
    80001e96:	0ac7a983          	lw	s3,172(a5)
    80001e9a:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    80001e9c:	2781                	sext.w	a5,a5
    80001e9e:	079e                	slli	a5,a5,0x7
    80001ea0:	0000e597          	auipc	a1,0xe
    80001ea4:	b1058593          	addi	a1,a1,-1264 # 8000f9b0 <cpus+0x8>
    80001ea8:	95be                	add	a1,a1,a5
    80001eaa:	06848513          	addi	a0,s1,104
    80001eae:	08f000ef          	jal	8000273c <swtch>
    80001eb2:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80001eb4:	2781                	sext.w	a5,a5
    80001eb6:	079e                	slli	a5,a5,0x7
    80001eb8:	993e                	add	s2,s2,a5
    80001eba:	0b392623          	sw	s3,172(s2)
}
    80001ebe:	70a2                	ld	ra,40(sp)
    80001ec0:	7402                	ld	s0,32(sp)
    80001ec2:	64e2                	ld	s1,24(sp)
    80001ec4:	6942                	ld	s2,16(sp)
    80001ec6:	69a2                	ld	s3,8(sp)
    80001ec8:	6145                	addi	sp,sp,48
    80001eca:	8082                	ret
        panic("sched p->lock");
    80001ecc:	00005517          	auipc	a0,0x5
    80001ed0:	2cc50513          	addi	a0,a0,716 # 80007198 <etext+0x198>
    80001ed4:	90bfe0ef          	jal	800007de <panic>
        panic("sched locks");
    80001ed8:	00005517          	auipc	a0,0x5
    80001edc:	2d050513          	addi	a0,a0,720 # 800071a8 <etext+0x1a8>
    80001ee0:	8fffe0ef          	jal	800007de <panic>
        panic("sched RUNNING");
    80001ee4:	00005517          	auipc	a0,0x5
    80001ee8:	2d450513          	addi	a0,a0,724 # 800071b8 <etext+0x1b8>
    80001eec:	8f3fe0ef          	jal	800007de <panic>
        panic("sched interruptible");
    80001ef0:	00005517          	auipc	a0,0x5
    80001ef4:	2d850513          	addi	a0,a0,728 # 800071c8 <etext+0x1c8>
    80001ef8:	8e7fe0ef          	jal	800007de <panic>

0000000080001efc <yield>:
{
    80001efc:	1101                	addi	sp,sp,-32
    80001efe:	ec06                	sd	ra,24(sp)
    80001f00:	e822                	sd	s0,16(sp)
    80001f02:	e426                	sd	s1,8(sp)
    80001f04:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80001f06:	9b9ff0ef          	jal	800018be <myproc>
    80001f0a:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80001f0c:	cc1fe0ef          	jal	80000bcc <acquire>
    p->state = RUNNABLE;
    80001f10:	478d                	li	a5,3
    80001f12:	cc9c                	sw	a5,24(s1)
    sched();
    80001f14:	f2fff0ef          	jal	80001e42 <sched>
    release(&p->lock);
    80001f18:	8526                	mv	a0,s1
    80001f1a:	d47fe0ef          	jal	80000c60 <release>
}
    80001f1e:	60e2                	ld	ra,24(sp)
    80001f20:	6442                	ld	s0,16(sp)
    80001f22:	64a2                	ld	s1,8(sp)
    80001f24:	6105                	addi	sp,sp,32
    80001f26:	8082                	ret

0000000080001f28 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80001f28:	7179                	addi	sp,sp,-48
    80001f2a:	f406                	sd	ra,40(sp)
    80001f2c:	f022                	sd	s0,32(sp)
    80001f2e:	ec26                	sd	s1,24(sp)
    80001f30:	e84a                	sd	s2,16(sp)
    80001f32:	e44e                	sd	s3,8(sp)
    80001f34:	1800                	addi	s0,sp,48
    80001f36:	89aa                	mv	s3,a0
    80001f38:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001f3a:	985ff0ef          	jal	800018be <myproc>
    80001f3e:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80001f40:	c8dfe0ef          	jal	80000bcc <acquire>
    release(lk);
    80001f44:	854a                	mv	a0,s2
    80001f46:	d1bfe0ef          	jal	80000c60 <release>

    // Go to sleep.
    p->chan = chan;
    80001f4a:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    80001f4e:	4789                	li	a5,2
    80001f50:	cc9c                	sw	a5,24(s1)

    sched();
    80001f52:	ef1ff0ef          	jal	80001e42 <sched>

    // Tidy up.
    p->chan = 0;
    80001f56:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    80001f5a:	8526                	mv	a0,s1
    80001f5c:	d05fe0ef          	jal	80000c60 <release>
    acquire(lk);
    80001f60:	854a                	mv	a0,s2
    80001f62:	c6bfe0ef          	jal	80000bcc <acquire>
}
    80001f66:	70a2                	ld	ra,40(sp)
    80001f68:	7402                	ld	s0,32(sp)
    80001f6a:	64e2                	ld	s1,24(sp)
    80001f6c:	6942                	ld	s2,16(sp)
    80001f6e:	69a2                	ld	s3,8(sp)
    80001f70:	6145                	addi	sp,sp,48
    80001f72:	8082                	ret

0000000080001f74 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void wakeup(void *chan)
{
    80001f74:	7139                	addi	sp,sp,-64
    80001f76:	fc06                	sd	ra,56(sp)
    80001f78:	f822                	sd	s0,48(sp)
    80001f7a:	f426                	sd	s1,40(sp)
    80001f7c:	f04a                	sd	s2,32(sp)
    80001f7e:	ec4e                	sd	s3,24(sp)
    80001f80:	e852                	sd	s4,16(sp)
    80001f82:	e456                	sd	s5,8(sp)
    80001f84:	0080                	addi	s0,sp,64
    80001f86:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    80001f88:	0000e497          	auipc	s1,0xe
    80001f8c:	e2048493          	addi	s1,s1,-480 # 8000fda8 <proc>
        if (p != myproc()) {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan) {
    80001f90:	4989                	li	s3,2
                p->state = RUNNABLE;
    80001f92:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80001f94:	00014917          	auipc	s2,0x14
    80001f98:	c1490913          	addi	s2,s2,-1004 # 80015ba8 <tickslock>
    80001f9c:	a801                	j	80001fac <wakeup+0x38>
            }
            release(&p->lock);
    80001f9e:	8526                	mv	a0,s1
    80001fa0:	cc1fe0ef          	jal	80000c60 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001fa4:	17848493          	addi	s1,s1,376
    80001fa8:	03248263          	beq	s1,s2,80001fcc <wakeup+0x58>
        if (p != myproc()) {
    80001fac:	913ff0ef          	jal	800018be <myproc>
    80001fb0:	fea48ae3          	beq	s1,a0,80001fa4 <wakeup+0x30>
            acquire(&p->lock);
    80001fb4:	8526                	mv	a0,s1
    80001fb6:	c17fe0ef          	jal	80000bcc <acquire>
            if (p->state == SLEEPING && p->chan == chan) {
    80001fba:	4c9c                	lw	a5,24(s1)
    80001fbc:	ff3791e3          	bne	a5,s3,80001f9e <wakeup+0x2a>
    80001fc0:	709c                	ld	a5,32(s1)
    80001fc2:	fd479ee3          	bne	a5,s4,80001f9e <wakeup+0x2a>
                p->state = RUNNABLE;
    80001fc6:	0154ac23          	sw	s5,24(s1)
    80001fca:	bfd1                	j	80001f9e <wakeup+0x2a>
        }
    }
}
    80001fcc:	70e2                	ld	ra,56(sp)
    80001fce:	7442                	ld	s0,48(sp)
    80001fd0:	74a2                	ld	s1,40(sp)
    80001fd2:	7902                	ld	s2,32(sp)
    80001fd4:	69e2                	ld	s3,24(sp)
    80001fd6:	6a42                	ld	s4,16(sp)
    80001fd8:	6aa2                	ld	s5,8(sp)
    80001fda:	6121                	addi	sp,sp,64
    80001fdc:	8082                	ret

0000000080001fde <reparent>:
{
    80001fde:	7139                	addi	sp,sp,-64
    80001fe0:	fc06                	sd	ra,56(sp)
    80001fe2:	f822                	sd	s0,48(sp)
    80001fe4:	f426                	sd	s1,40(sp)
    80001fe6:	f04a                	sd	s2,32(sp)
    80001fe8:	ec4e                	sd	s3,24(sp)
    80001fea:	e852                	sd	s4,16(sp)
    80001fec:	e456                	sd	s5,8(sp)
    80001fee:	e05a                	sd	s6,0(sp)
    80001ff0:	0080                	addi	s0,sp,64
    80001ff2:	89aa                	mv	s3,a0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001ff4:	0000e497          	auipc	s1,0xe
    80001ff8:	db448493          	addi	s1,s1,-588 # 8000fda8 <proc>
            pp->parent = initproc;
    80001ffc:	00006b17          	auipc	s6,0x6
    80002000:	874b0b13          	addi	s6,s6,-1932 # 80007870 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002004:	00014a17          	auipc	s4,0x14
    80002008:	ba4a0a13          	addi	s4,s4,-1116 # 80015ba8 <tickslock>
    8000200c:	a085                	j	8000206c <reparent+0x8e>
                acquire(&pp->lock);
    8000200e:	8526                	mv	a0,s1
    80002010:	bbdfe0ef          	jal	80000bcc <acquire>
                for (int fd = 0; fd < NOFILE; fd++) {
    80002014:	0d848913          	addi	s2,s1,216
    80002018:	15848a93          	addi	s5,s1,344
    8000201c:	a801                	j	8000202c <reparent+0x4e>
                        fileclose(f);
    8000201e:	4de020ef          	jal	800044fc <fileclose>
                        pp->ofile[fd] = 0;
    80002022:	00093023          	sd	zero,0(s2)
                for (int fd = 0; fd < NOFILE; fd++) {
    80002026:	0921                	addi	s2,s2,8
    80002028:	01590663          	beq	s2,s5,80002034 <reparent+0x56>
                    if (pp->ofile[fd]) {
    8000202c:	00093503          	ld	a0,0(s2)
    80002030:	f57d                	bnez	a0,8000201e <reparent+0x40>
    80002032:	bfd5                	j	80002026 <reparent+0x48>
                if (pp->cwd) {
    80002034:	1584b783          	ld	a5,344(s1)
    80002038:	cb99                	beqz	a5,8000204e <reparent+0x70>
                    begin_op();
    8000203a:	0b0020ef          	jal	800040ea <begin_op>
                    iput(pp->cwd);
    8000203e:	1584b503          	ld	a0,344(s1)
    80002042:	027010ef          	jal	80003868 <iput>
                    end_op();
    80002046:	10e020ef          	jal	80004154 <end_op>
                    pp->cwd = 0;
    8000204a:	1404bc23          	sd	zero,344(s1)
                freeproc(pp);
    8000204e:	8526                	mv	a0,s1
    80002050:	a7dff0ef          	jal	80001acc <freeproc>
                release(&pp->lock);
    80002054:	8526                	mv	a0,s1
    80002056:	c0bfe0ef          	jal	80000c60 <release>
                p->thread_count--;
    8000205a:	0389a783          	lw	a5,56(s3)
    8000205e:	37fd                	addiw	a5,a5,-1
    80002060:	02f9ac23          	sw	a5,56(s3)
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002064:	17848493          	addi	s1,s1,376
    80002068:	03448063          	beq	s1,s4,80002088 <reparent+0xaa>
        if (pp->parent == p) {
    8000206c:	60bc                	ld	a5,64(s1)
    8000206e:	ff379be3          	bne	a5,s3,80002064 <reparent+0x86>
            pp->parent = initproc;
    80002072:	000b3503          	ld	a0,0(s6)
    80002076:	e0a8                	sd	a0,64(s1)
            if (pp->tgid == p->pid) {
    80002078:	58d8                	lw	a4,52(s1)
    8000207a:	0309a783          	lw	a5,48(s3)
    8000207e:	f8f708e3          	beq	a4,a5,8000200e <reparent+0x30>
                wakeup(initproc);
    80002082:	ef3ff0ef          	jal	80001f74 <wakeup>
    80002086:	bff9                	j	80002064 <reparent+0x86>
}
    80002088:	70e2                	ld	ra,56(sp)
    8000208a:	7442                	ld	s0,48(sp)
    8000208c:	74a2                	ld	s1,40(sp)
    8000208e:	7902                	ld	s2,32(sp)
    80002090:	69e2                	ld	s3,24(sp)
    80002092:	6a42                	ld	s4,16(sp)
    80002094:	6aa2                	ld	s5,8(sp)
    80002096:	6b02                	ld	s6,0(sp)
    80002098:	6121                	addi	sp,sp,64
    8000209a:	8082                	ret

000000008000209c <kexit>:
{
    8000209c:	7179                	addi	sp,sp,-48
    8000209e:	f406                	sd	ra,40(sp)
    800020a0:	f022                	sd	s0,32(sp)
    800020a2:	ec26                	sd	s1,24(sp)
    800020a4:	e84a                	sd	s2,16(sp)
    800020a6:	e44e                	sd	s3,8(sp)
    800020a8:	e052                	sd	s4,0(sp)
    800020aa:	1800                	addi	s0,sp,48
    800020ac:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    800020ae:	811ff0ef          	jal	800018be <myproc>
    800020b2:	89aa                	mv	s3,a0
    if (p == initproc)
    800020b4:	00005797          	auipc	a5,0x5
    800020b8:	7bc7b783          	ld	a5,1980(a5) # 80007870 <initproc>
    800020bc:	0d850493          	addi	s1,a0,216
    800020c0:	15850913          	addi	s2,a0,344
    800020c4:	00a79b63          	bne	a5,a0,800020da <kexit+0x3e>
        panic("init exiting");
    800020c8:	00005517          	auipc	a0,0x5
    800020cc:	11850513          	addi	a0,a0,280 # 800071e0 <etext+0x1e0>
    800020d0:	f0efe0ef          	jal	800007de <panic>
    for (int fd = 0; fd < NOFILE; fd++) {
    800020d4:	04a1                	addi	s1,s1,8
    800020d6:	01248963          	beq	s1,s2,800020e8 <kexit+0x4c>
        if (p->ofile[fd]) {
    800020da:	6088                	ld	a0,0(s1)
    800020dc:	dd65                	beqz	a0,800020d4 <kexit+0x38>
            fileclose(f);
    800020de:	41e020ef          	jal	800044fc <fileclose>
            p->ofile[fd] = 0;
    800020e2:	0004b023          	sd	zero,0(s1)
    800020e6:	b7fd                	j	800020d4 <kexit+0x38>
    begin_op();
    800020e8:	002020ef          	jal	800040ea <begin_op>
    iput(p->cwd);
    800020ec:	1589b503          	ld	a0,344(s3)
    800020f0:	778010ef          	jal	80003868 <iput>
    end_op();
    800020f4:	060020ef          	jal	80004154 <end_op>
    p->cwd = 0;
    800020f8:	1409bc23          	sd	zero,344(s3)
    acquire(&wait_lock);
    800020fc:	0000e497          	auipc	s1,0xe
    80002100:	89448493          	addi	s1,s1,-1900 # 8000f990 <wait_lock>
    80002104:	8526                	mv	a0,s1
    80002106:	ac7fe0ef          	jal	80000bcc <acquire>
    reparent(p);
    8000210a:	854e                	mv	a0,s3
    8000210c:	ed3ff0ef          	jal	80001fde <reparent>
    wakeup(p->parent);
    80002110:	0409b503          	ld	a0,64(s3)
    80002114:	e61ff0ef          	jal	80001f74 <wakeup>
    acquire(&p->lock);
    80002118:	854e                	mv	a0,s3
    8000211a:	ab3fe0ef          	jal	80000bcc <acquire>
    p->xstate = status;
    8000211e:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    80002122:	4795                	li	a5,5
    80002124:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    80002128:	8526                	mv	a0,s1
    8000212a:	b37fe0ef          	jal	80000c60 <release>
    sched();
    8000212e:	d15ff0ef          	jal	80001e42 <sched>
    panic("zombie exit");
    80002132:	00005517          	auipc	a0,0x5
    80002136:	0be50513          	addi	a0,a0,190 # 800071f0 <etext+0x1f0>
    8000213a:	ea4fe0ef          	jal	800007de <panic>

000000008000213e <kkill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kkill(int pid)
{
    8000213e:	7179                	addi	sp,sp,-48
    80002140:	f406                	sd	ra,40(sp)
    80002142:	f022                	sd	s0,32(sp)
    80002144:	ec26                	sd	s1,24(sp)
    80002146:	e84a                	sd	s2,16(sp)
    80002148:	e44e                	sd	s3,8(sp)
    8000214a:	1800                	addi	s0,sp,48
    8000214c:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    8000214e:	0000e497          	auipc	s1,0xe
    80002152:	c5a48493          	addi	s1,s1,-934 # 8000fda8 <proc>
    80002156:	00014997          	auipc	s3,0x14
    8000215a:	a5298993          	addi	s3,s3,-1454 # 80015ba8 <tickslock>
        acquire(&p->lock);
    8000215e:	8526                	mv	a0,s1
    80002160:	a6dfe0ef          	jal	80000bcc <acquire>
        if (p->pid == pid) {
    80002164:	589c                	lw	a5,48(s1)
    80002166:	01278b63          	beq	a5,s2,8000217c <kkill+0x3e>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    8000216a:	8526                	mv	a0,s1
    8000216c:	af5fe0ef          	jal	80000c60 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80002170:	17848493          	addi	s1,s1,376
    80002174:	ff3495e3          	bne	s1,s3,8000215e <kkill+0x20>
    }
    return -1;
    80002178:	557d                	li	a0,-1
    8000217a:	a819                	j	80002190 <kkill+0x52>
            p->killed = 1;
    8000217c:	4785                	li	a5,1
    8000217e:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING) {
    80002180:	4c98                	lw	a4,24(s1)
    80002182:	4789                	li	a5,2
    80002184:	00f70d63          	beq	a4,a5,8000219e <kkill+0x60>
            release(&p->lock);
    80002188:	8526                	mv	a0,s1
    8000218a:	ad7fe0ef          	jal	80000c60 <release>
            return 0;
    8000218e:	4501                	li	a0,0
}
    80002190:	70a2                	ld	ra,40(sp)
    80002192:	7402                	ld	s0,32(sp)
    80002194:	64e2                	ld	s1,24(sp)
    80002196:	6942                	ld	s2,16(sp)
    80002198:	69a2                	ld	s3,8(sp)
    8000219a:	6145                	addi	sp,sp,48
    8000219c:	8082                	ret
                p->state = RUNNABLE;
    8000219e:	478d                	li	a5,3
    800021a0:	cc9c                	sw	a5,24(s1)
    800021a2:	b7dd                	j	80002188 <kkill+0x4a>

00000000800021a4 <setkilled>:

void setkilled(struct proc *p)
{
    800021a4:	1101                	addi	sp,sp,-32
    800021a6:	ec06                	sd	ra,24(sp)
    800021a8:	e822                	sd	s0,16(sp)
    800021aa:	e426                	sd	s1,8(sp)
    800021ac:	1000                	addi	s0,sp,32
    800021ae:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800021b0:	a1dfe0ef          	jal	80000bcc <acquire>
    p->killed = 1;
    800021b4:	4785                	li	a5,1
    800021b6:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800021b8:	8526                	mv	a0,s1
    800021ba:	aa7fe0ef          	jal	80000c60 <release>
}
    800021be:	60e2                	ld	ra,24(sp)
    800021c0:	6442                	ld	s0,16(sp)
    800021c2:	64a2                	ld	s1,8(sp)
    800021c4:	6105                	addi	sp,sp,32
    800021c6:	8082                	ret

00000000800021c8 <killed>:

int killed(struct proc *p)
{
    800021c8:	1101                	addi	sp,sp,-32
    800021ca:	ec06                	sd	ra,24(sp)
    800021cc:	e822                	sd	s0,16(sp)
    800021ce:	e426                	sd	s1,8(sp)
    800021d0:	e04a                	sd	s2,0(sp)
    800021d2:	1000                	addi	s0,sp,32
    800021d4:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    800021d6:	9f7fe0ef          	jal	80000bcc <acquire>
    k = p->killed;
    800021da:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800021de:	8526                	mv	a0,s1
    800021e0:	a81fe0ef          	jal	80000c60 <release>
    return k;
}
    800021e4:	854a                	mv	a0,s2
    800021e6:	60e2                	ld	ra,24(sp)
    800021e8:	6442                	ld	s0,16(sp)
    800021ea:	64a2                	ld	s1,8(sp)
    800021ec:	6902                	ld	s2,0(sp)
    800021ee:	6105                	addi	sp,sp,32
    800021f0:	8082                	ret

00000000800021f2 <kwait>:
{
    800021f2:	715d                	addi	sp,sp,-80
    800021f4:	e486                	sd	ra,72(sp)
    800021f6:	e0a2                	sd	s0,64(sp)
    800021f8:	fc26                	sd	s1,56(sp)
    800021fa:	f84a                	sd	s2,48(sp)
    800021fc:	f44e                	sd	s3,40(sp)
    800021fe:	f052                	sd	s4,32(sp)
    80002200:	ec56                	sd	s5,24(sp)
    80002202:	e85a                	sd	s6,16(sp)
    80002204:	e45e                	sd	s7,8(sp)
    80002206:	e062                	sd	s8,0(sp)
    80002208:	0880                	addi	s0,sp,80
    8000220a:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    8000220c:	eb2ff0ef          	jal	800018be <myproc>
    80002210:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80002212:	0000d517          	auipc	a0,0xd
    80002216:	77e50513          	addi	a0,a0,1918 # 8000f990 <wait_lock>
    8000221a:	9b3fe0ef          	jal	80000bcc <acquire>
                if (pp->state == ZOMBIE) {
    8000221e:	4a15                	li	s4,5
                havekids = 1;
    80002220:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002222:	00014997          	auipc	s3,0x14
    80002226:	98698993          	addi	s3,s3,-1658 # 80015ba8 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    8000222a:	0000db97          	auipc	s7,0xd
    8000222e:	766b8b93          	addi	s7,s7,1894 # 8000f990 <wait_lock>
    80002232:	a07d                	j	800022e0 <kwait+0xee>
                    release(&pp->lock);
    80002234:	8526                	mv	a0,s1
    80002236:	a2bfe0ef          	jal	80000c60 <release>
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000223a:	17848493          	addi	s1,s1,376
    8000223e:	09348763          	beq	s1,s3,800022cc <kwait+0xda>
            if (pp->parent == p) {
    80002242:	60bc                	ld	a5,64(s1)
    80002244:	ff279be3          	bne	a5,s2,8000223a <kwait+0x48>
                acquire(&pp->lock);
    80002248:	8526                	mv	a0,s1
    8000224a:	983fe0ef          	jal	80000bcc <acquire>
                if (pp->tgid == p->pid) {
    8000224e:	58d8                	lw	a4,52(s1)
    80002250:	03092783          	lw	a5,48(s2)
    80002254:	fef700e3          	beq	a4,a5,80002234 <kwait+0x42>
                if (pp->state == ZOMBIE) {
    80002258:	4c9c                	lw	a5,24(s1)
    8000225a:	01478763          	beq	a5,s4,80002268 <kwait+0x76>
                release(&pp->lock);
    8000225e:	8526                	mv	a0,s1
    80002260:	a01fe0ef          	jal	80000c60 <release>
                havekids = 1;
    80002264:	8c56                	mv	s8,s5
    80002266:	bfd1                	j	8000223a <kwait+0x48>
                    pid = pp->pid;
    80002268:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 &&
    8000226c:	000b0c63          	beqz	s6,80002284 <kwait+0x92>
                        copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002270:	4691                	li	a3,4
    80002272:	02c48613          	addi	a2,s1,44
    80002276:	85da                	mv	a1,s6
    80002278:	05893503          	ld	a0,88(s2)
    8000227c:	b74ff0ef          	jal	800015f0 <copyout>
                    if (addr != 0 &&
    80002280:	02054b63          	bltz	a0,800022b6 <kwait+0xc4>
                    freeproc(pp);
    80002284:	8526                	mv	a0,s1
    80002286:	847ff0ef          	jal	80001acc <freeproc>
                    release(&pp->lock);
    8000228a:	8526                	mv	a0,s1
    8000228c:	9d5fe0ef          	jal	80000c60 <release>
                    release(&wait_lock);
    80002290:	0000d517          	auipc	a0,0xd
    80002294:	70050513          	addi	a0,a0,1792 # 8000f990 <wait_lock>
    80002298:	9c9fe0ef          	jal	80000c60 <release>
}
    8000229c:	854e                	mv	a0,s3
    8000229e:	60a6                	ld	ra,72(sp)
    800022a0:	6406                	ld	s0,64(sp)
    800022a2:	74e2                	ld	s1,56(sp)
    800022a4:	7942                	ld	s2,48(sp)
    800022a6:	79a2                	ld	s3,40(sp)
    800022a8:	7a02                	ld	s4,32(sp)
    800022aa:	6ae2                	ld	s5,24(sp)
    800022ac:	6b42                	ld	s6,16(sp)
    800022ae:	6ba2                	ld	s7,8(sp)
    800022b0:	6c02                	ld	s8,0(sp)
    800022b2:	6161                	addi	sp,sp,80
    800022b4:	8082                	ret
                        release(&pp->lock);
    800022b6:	8526                	mv	a0,s1
    800022b8:	9a9fe0ef          	jal	80000c60 <release>
                        release(&wait_lock);
    800022bc:	0000d517          	auipc	a0,0xd
    800022c0:	6d450513          	addi	a0,a0,1748 # 8000f990 <wait_lock>
    800022c4:	99dfe0ef          	jal	80000c60 <release>
                        return -1;
    800022c8:	59fd                	li	s3,-1
    800022ca:	bfc9                	j	8000229c <kwait+0xaa>
        if (!havekids || killed(p)) {
    800022cc:	020c0063          	beqz	s8,800022ec <kwait+0xfa>
    800022d0:	854a                	mv	a0,s2
    800022d2:	ef7ff0ef          	jal	800021c8 <killed>
    800022d6:	e919                	bnez	a0,800022ec <kwait+0xfa>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800022d8:	85de                	mv	a1,s7
    800022da:	854a                	mv	a0,s2
    800022dc:	c4dff0ef          	jal	80001f28 <sleep>
        havekids = 0;
    800022e0:	4c01                	li	s8,0
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    800022e2:	0000e497          	auipc	s1,0xe
    800022e6:	ac648493          	addi	s1,s1,-1338 # 8000fda8 <proc>
    800022ea:	bfa1                	j	80002242 <kwait+0x50>
            release(&wait_lock);
    800022ec:	0000d517          	auipc	a0,0xd
    800022f0:	6a450513          	addi	a0,a0,1700 # 8000f990 <wait_lock>
    800022f4:	96dfe0ef          	jal	80000c60 <release>
            return -1;
    800022f8:	59fd                	li	s3,-1
    800022fa:	b74d                	j	8000229c <kwait+0xaa>

00000000800022fc <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800022fc:	7179                	addi	sp,sp,-48
    800022fe:	f406                	sd	ra,40(sp)
    80002300:	f022                	sd	s0,32(sp)
    80002302:	ec26                	sd	s1,24(sp)
    80002304:	e84a                	sd	s2,16(sp)
    80002306:	e44e                	sd	s3,8(sp)
    80002308:	e052                	sd	s4,0(sp)
    8000230a:	1800                	addi	s0,sp,48
    8000230c:	84aa                	mv	s1,a0
    8000230e:	892e                	mv	s2,a1
    80002310:	89b2                	mv	s3,a2
    80002312:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002314:	daaff0ef          	jal	800018be <myproc>
    if (user_dst) {
    80002318:	cc99                	beqz	s1,80002336 <either_copyout+0x3a>
        return copyout(p->pagetable, dst, src, len);
    8000231a:	86d2                	mv	a3,s4
    8000231c:	864e                	mv	a2,s3
    8000231e:	85ca                	mv	a1,s2
    80002320:	6d28                	ld	a0,88(a0)
    80002322:	aceff0ef          	jal	800015f0 <copyout>
    } else {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002326:	70a2                	ld	ra,40(sp)
    80002328:	7402                	ld	s0,32(sp)
    8000232a:	64e2                	ld	s1,24(sp)
    8000232c:	6942                	ld	s2,16(sp)
    8000232e:	69a2                	ld	s3,8(sp)
    80002330:	6a02                	ld	s4,0(sp)
    80002332:	6145                	addi	sp,sp,48
    80002334:	8082                	ret
        memmove((char *)dst, src, len);
    80002336:	000a061b          	sext.w	a2,s4
    8000233a:	85ce                	mv	a1,s3
    8000233c:	854a                	mv	a0,s2
    8000233e:	9c3fe0ef          	jal	80000d00 <memmove>
        return 0;
    80002342:	8526                	mv	a0,s1
    80002344:	b7cd                	j	80002326 <either_copyout+0x2a>

0000000080002346 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002346:	7179                	addi	sp,sp,-48
    80002348:	f406                	sd	ra,40(sp)
    8000234a:	f022                	sd	s0,32(sp)
    8000234c:	ec26                	sd	s1,24(sp)
    8000234e:	e84a                	sd	s2,16(sp)
    80002350:	e44e                	sd	s3,8(sp)
    80002352:	e052                	sd	s4,0(sp)
    80002354:	1800                	addi	s0,sp,48
    80002356:	892a                	mv	s2,a0
    80002358:	84ae                	mv	s1,a1
    8000235a:	89b2                	mv	s3,a2
    8000235c:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000235e:	d60ff0ef          	jal	800018be <myproc>
    if (user_src) {
    80002362:	cc99                	beqz	s1,80002380 <either_copyin+0x3a>
        return copyin(p->pagetable, dst, src, len);
    80002364:	86d2                	mv	a3,s4
    80002366:	864e                	mv	a2,s3
    80002368:	85ca                	mv	a1,s2
    8000236a:	6d28                	ld	a0,88(a0)
    8000236c:	b42ff0ef          	jal	800016ae <copyin>
    } else {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80002370:	70a2                	ld	ra,40(sp)
    80002372:	7402                	ld	s0,32(sp)
    80002374:	64e2                	ld	s1,24(sp)
    80002376:	6942                	ld	s2,16(sp)
    80002378:	69a2                	ld	s3,8(sp)
    8000237a:	6a02                	ld	s4,0(sp)
    8000237c:	6145                	addi	sp,sp,48
    8000237e:	8082                	ret
        memmove(dst, (char *)src, len);
    80002380:	000a061b          	sext.w	a2,s4
    80002384:	85ce                	mv	a1,s3
    80002386:	854a                	mv	a0,s2
    80002388:	979fe0ef          	jal	80000d00 <memmove>
        return 0;
    8000238c:	8526                	mv	a0,s1
    8000238e:	b7cd                	j	80002370 <either_copyin+0x2a>

0000000080002390 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002390:	715d                	addi	sp,sp,-80
    80002392:	e486                	sd	ra,72(sp)
    80002394:	e0a2                	sd	s0,64(sp)
    80002396:	fc26                	sd	s1,56(sp)
    80002398:	f84a                	sd	s2,48(sp)
    8000239a:	f44e                	sd	s3,40(sp)
    8000239c:	f052                	sd	s4,32(sp)
    8000239e:	ec56                	sd	s5,24(sp)
    800023a0:	e85a                	sd	s6,16(sp)
    800023a2:	e45e                	sd	s7,8(sp)
    800023a4:	0880                	addi	s0,sp,80
        [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE] "zombie"
    };
    struct proc *p;
    char *state;

    printf("\n");
    800023a6:	00005517          	auipc	a0,0x5
    800023aa:	cd250513          	addi	a0,a0,-814 # 80007078 <etext+0x78>
    800023ae:	94cfe0ef          	jal	800004fa <printf>
    for (p = proc; p < &proc[NPROC]; p++) {
    800023b2:	0000e497          	auipc	s1,0xe
    800023b6:	b5648493          	addi	s1,s1,-1194 # 8000ff08 <proc+0x160>
    800023ba:	00014917          	auipc	s2,0x14
    800023be:	94e90913          	addi	s2,s2,-1714 # 80015d08 <bcache+0x148>
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023c2:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    800023c4:	00005997          	auipc	s3,0x5
    800023c8:	e3c98993          	addi	s3,s3,-452 # 80007200 <etext+0x200>
        printf("%d %s %s", p->pid, state, p->name);
    800023cc:	00005a97          	auipc	s5,0x5
    800023d0:	e3ca8a93          	addi	s5,s5,-452 # 80007208 <etext+0x208>
        printf("\n");
    800023d4:	00005a17          	auipc	s4,0x5
    800023d8:	ca4a0a13          	addi	s4,s4,-860 # 80007078 <etext+0x78>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023dc:	00005b97          	auipc	s7,0x5
    800023e0:	34cb8b93          	addi	s7,s7,844 # 80007728 <states.0>
    800023e4:	a829                	j	800023fe <procdump+0x6e>
        printf("%d %s %s", p->pid, state, p->name);
    800023e6:	ed06a583          	lw	a1,-304(a3)
    800023ea:	8556                	mv	a0,s5
    800023ec:	90efe0ef          	jal	800004fa <printf>
        printf("\n");
    800023f0:	8552                	mv	a0,s4
    800023f2:	908fe0ef          	jal	800004fa <printf>
    for (p = proc; p < &proc[NPROC]; p++) {
    800023f6:	17848493          	addi	s1,s1,376
    800023fa:	03248263          	beq	s1,s2,8000241e <procdump+0x8e>
        if (p->state == UNUSED)
    800023fe:	86a6                	mv	a3,s1
    80002400:	eb84a783          	lw	a5,-328(s1)
    80002404:	dbed                	beqz	a5,800023f6 <procdump+0x66>
            state = "???";
    80002406:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002408:	fcfb6fe3          	bltu	s6,a5,800023e6 <procdump+0x56>
    8000240c:	02079713          	slli	a4,a5,0x20
    80002410:	01d75793          	srli	a5,a4,0x1d
    80002414:	97de                	add	a5,a5,s7
    80002416:	6390                	ld	a2,0(a5)
    80002418:	f679                	bnez	a2,800023e6 <procdump+0x56>
            state = "???";
    8000241a:	864e                	mv	a2,s3
    8000241c:	b7e9                	j	800023e6 <procdump+0x56>
    }
}
    8000241e:	60a6                	ld	ra,72(sp)
    80002420:	6406                	ld	s0,64(sp)
    80002422:	74e2                	ld	s1,56(sp)
    80002424:	7942                	ld	s2,48(sp)
    80002426:	79a2                	ld	s3,40(sp)
    80002428:	7a02                	ld	s4,32(sp)
    8000242a:	6ae2                	ld	s5,24(sp)
    8000242c:	6b42                	ld	s6,16(sp)
    8000242e:	6ba2                	ld	s7,8(sp)
    80002430:	6161                	addi	sp,sp,80
    80002432:	8082                	ret

0000000080002434 <update_sz>:

void update_sz(int tgid, uint64 sz)
{
    80002434:	7179                	addi	sp,sp,-48
    80002436:	f406                	sd	ra,40(sp)
    80002438:	f022                	sd	s0,32(sp)
    8000243a:	ec26                	sd	s1,24(sp)
    8000243c:	e84a                	sd	s2,16(sp)
    8000243e:	e44e                	sd	s3,8(sp)
    80002440:	e052                	sd	s4,0(sp)
    80002442:	1800                	addi	s0,sp,48
    80002444:	892a                	mv	s2,a0
    80002446:	8a2e                	mv	s4,a1
    struct proc *p;
    for (p = proc; p < &proc[NPROC]; p++) {
    80002448:	0000e497          	auipc	s1,0xe
    8000244c:	96048493          	addi	s1,s1,-1696 # 8000fda8 <proc>
    80002450:	00013997          	auipc	s3,0x13
    80002454:	75898993          	addi	s3,s3,1880 # 80015ba8 <tickslock>
    80002458:	a801                	j	80002468 <update_sz+0x34>
        acquire(&p->lock);
        if (p->tgid == tgid) {
            p->sz = sz;
        }
        release(&p->lock);
    8000245a:	8526                	mv	a0,s1
    8000245c:	805fe0ef          	jal	80000c60 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80002460:	17848493          	addi	s1,s1,376
    80002464:	01348b63          	beq	s1,s3,8000247a <update_sz+0x46>
        acquire(&p->lock);
    80002468:	8526                	mv	a0,s1
    8000246a:	f62fe0ef          	jal	80000bcc <acquire>
        if (p->tgid == tgid) {
    8000246e:	58dc                	lw	a5,52(s1)
    80002470:	ff2795e3          	bne	a5,s2,8000245a <update_sz+0x26>
            p->sz = sz;
    80002474:	0544b823          	sd	s4,80(s1)
    80002478:	b7cd                	j	8000245a <update_sz+0x26>
    }
}
    8000247a:	70a2                	ld	ra,40(sp)
    8000247c:	7402                	ld	s0,32(sp)
    8000247e:	64e2                	ld	s1,24(sp)
    80002480:	6942                	ld	s2,16(sp)
    80002482:	69a2                	ld	s3,8(sp)
    80002484:	6a02                	ld	s4,0(sp)
    80002486:	6145                	addi	sp,sp,48
    80002488:	8082                	ret

000000008000248a <growproc>:
{
    8000248a:	1101                	addi	sp,sp,-32
    8000248c:	ec06                	sd	ra,24(sp)
    8000248e:	e822                	sd	s0,16(sp)
    80002490:	e426                	sd	s1,8(sp)
    80002492:	e04a                	sd	s2,0(sp)
    80002494:	1000                	addi	s0,sp,32
    80002496:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80002498:	c26ff0ef          	jal	800018be <myproc>
    8000249c:	892a                	mv	s2,a0
    sz = p->sz;
    8000249e:	692c                	ld	a1,80(a0)
    if (n > 0) {
    800024a0:	02905c63          	blez	s1,800024d8 <growproc+0x4e>
        if (sz + n > TRAPFRAME(NPROC)) {
    800024a4:	00b48633          	add	a2,s1,a1
    800024a8:	020007b7          	lui	a5,0x2000
    800024ac:	fdf78793          	addi	a5,a5,-33 # 1ffffdf <_entry-0x7e000021>
    800024b0:	07b6                	slli	a5,a5,0xd
    800024b2:	02c7ec63          	bltu	a5,a2,800024ea <growproc+0x60>
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800024b6:	4691                	li	a3,4
    800024b8:	6d28                	ld	a0,88(a0)
    800024ba:	de9fe0ef          	jal	800012a2 <uvmalloc>
    800024be:	85aa                	mv	a1,a0
    800024c0:	c51d                	beqz	a0,800024ee <growproc+0x64>
    update_sz(p->tgid, sz);
    800024c2:	03492503          	lw	a0,52(s2)
    800024c6:	f6fff0ef          	jal	80002434 <update_sz>
    return 0;
    800024ca:	4501                	li	a0,0
}
    800024cc:	60e2                	ld	ra,24(sp)
    800024ce:	6442                	ld	s0,16(sp)
    800024d0:	64a2                	ld	s1,8(sp)
    800024d2:	6902                	ld	s2,0(sp)
    800024d4:	6105                	addi	sp,sp,32
    800024d6:	8082                	ret
    } else if (n < 0) {
    800024d8:	fe04d5e3          	bgez	s1,800024c2 <growproc+0x38>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    800024dc:	00b48633          	add	a2,s1,a1
    800024e0:	6d28                	ld	a0,88(a0)
    800024e2:	d7dfe0ef          	jal	8000125e <uvmdealloc>
    800024e6:	85aa                	mv	a1,a0
    800024e8:	bfe9                	j	800024c2 <growproc+0x38>
            return -1;
    800024ea:	557d                	li	a0,-1
    800024ec:	b7c5                	j	800024cc <growproc+0x42>
            return -1;
    800024ee:	557d                	li	a0,-1
    800024f0:	bff1                	j	800024cc <growproc+0x42>

00000000800024f2 <clone>:

int clone(uint64 fn, uint64 arg, uint64 stack)
{
    800024f2:	7139                	addi	sp,sp,-64
    800024f4:	fc06                	sd	ra,56(sp)
    800024f6:	f822                	sd	s0,48(sp)
    800024f8:	f426                	sd	s1,40(sp)
    800024fa:	f04a                	sd	s2,32(sp)
    800024fc:	e852                	sd	s4,16(sp)
    800024fe:	0080                	addi	s0,sp,64
    80002500:	84aa                	mv	s1,a0
    80002502:	892e                	mv	s2,a1
    80002504:	8a32                	mv	s4,a2
    int i, pid;
    struct proc *np;
    struct proc *p = myproc();
    80002506:	bb8ff0ef          	jal	800018be <myproc>

    // Check if main thread.
    if (p->pid != p->tgid) {
    8000250a:	5918                	lw	a4,48(a0)
    8000250c:	595c                	lw	a5,52(a0)
    8000250e:	14f71163          	bne	a4,a5,80002650 <clone+0x15e>
    80002512:	ec4e                	sd	s3,24(sp)
    80002514:	e456                	sd	s5,8(sp)
    80002516:	8aaa                	mv	s5,a0
        return -1;
    }

    // Allocate process.
    if ((np = allocproc()) == 0) {
    80002518:	e72ff0ef          	jal	80001b8a <allocproc>
    8000251c:	89aa                	mv	s3,a0
    8000251e:	12050b63          	beqz	a0,80002654 <clone+0x162>
        return -1;
    }

    // Copy user memory from parent to child.
    np->pagetable = p->pagetable;
    80002522:	058ab503          	ld	a0,88(s5)
    80002526:	04a9bc23          	sd	a0,88(s3)
    np->sz = p->sz;
    8000252a:	050ab783          	ld	a5,80(s5)
    8000252e:	04f9b823          	sd	a5,80(s3)
    mappages(np->pagetable, TRAPFRAME((int)(np - proc)), PGSIZE,
    80002532:	0000e797          	auipc	a5,0xe
    80002536:	87678793          	addi	a5,a5,-1930 # 8000fda8 <proc>
    8000253a:	40f987b3          	sub	a5,s3,a5
    8000253e:	878d                	srai	a5,a5,0x3
    80002540:	677d46b7          	lui	a3,0x677d4
    80002544:	6cf68693          	addi	a3,a3,1743 # 677d46cf <_entry-0x1882b931>
    80002548:	51b3c737          	lui	a4,0x51b3c
    8000254c:	ea370713          	addi	a4,a4,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80002550:	1702                	slli	a4,a4,0x20
    80002552:	9736                	add	a4,a4,a3
    80002554:	02e787b3          	mul	a5,a5,a4
    80002558:	2785                	addiw	a5,a5,1
    8000255a:	00c7979b          	slliw	a5,a5,0xc
    8000255e:	040005b7          	lui	a1,0x4000
    80002562:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002564:	05b2                	slli	a1,a1,0xc
    80002566:	4719                	li	a4,6
    80002568:	0609b683          	ld	a3,96(s3)
    8000256c:	6605                	lui	a2,0x1
    8000256e:	8d9d                	sub	a1,a1,a5
    80002570:	a99fe0ef          	jal	80001008 <mappages>
             (uint64)(np->trapframe), PTE_R | PTE_W);

    // copy saved user registers.
    *(np->trapframe) = *(p->trapframe);
    80002574:	060ab683          	ld	a3,96(s5)
    80002578:	87b6                	mv	a5,a3
    8000257a:	0609b703          	ld	a4,96(s3)
    8000257e:	12068693          	addi	a3,a3,288
    80002582:	0007b803          	ld	a6,0(a5)
    80002586:	6788                	ld	a0,8(a5)
    80002588:	6b8c                	ld	a1,16(a5)
    8000258a:	6f90                	ld	a2,24(a5)
    8000258c:	01073023          	sd	a6,0(a4)
    80002590:	e708                	sd	a0,8(a4)
    80002592:	eb0c                	sd	a1,16(a4)
    80002594:	ef10                	sd	a2,24(a4)
    80002596:	02078793          	addi	a5,a5,32
    8000259a:	02070713          	addi	a4,a4,32
    8000259e:	fed792e3          	bne	a5,a3,80002582 <clone+0x90>

    np->trapframe->sp = stack;
    800025a2:	0609b783          	ld	a5,96(s3)
    800025a6:	0347b823          	sd	s4,48(a5)
    np->trapframe->a0 = arg;
    800025aa:	0609b783          	ld	a5,96(s3)
    800025ae:	0727b823          	sd	s2,112(a5)
    np->trapframe->epc = fn;
    800025b2:	0609b783          	ld	a5,96(s3)
    800025b6:	ef84                	sd	s1,24(a5)

    // increment reference counts on open file descriptors.
    for (i = 0; i < NOFILE; i++)
    800025b8:	0d8a8493          	addi	s1,s5,216
    800025bc:	0d898913          	addi	s2,s3,216
    800025c0:	158a8a13          	addi	s4,s5,344
    800025c4:	a029                	j	800025ce <clone+0xdc>
    800025c6:	04a1                	addi	s1,s1,8
    800025c8:	0921                	addi	s2,s2,8
    800025ca:	01448963          	beq	s1,s4,800025dc <clone+0xea>
        if (p->ofile[i])
    800025ce:	6088                	ld	a0,0(s1)
    800025d0:	d97d                	beqz	a0,800025c6 <clone+0xd4>
            np->ofile[i] = filedup(p->ofile[i]);
    800025d2:	6e5010ef          	jal	800044b6 <filedup>
    800025d6:	00a93023          	sd	a0,0(s2)
    800025da:	b7f5                	j	800025c6 <clone+0xd4>
    np->cwd = idup(p->cwd);
    800025dc:	158ab503          	ld	a0,344(s5)
    800025e0:	0d0010ef          	jal	800036b0 <idup>
    800025e4:	14a9bc23          	sd	a0,344(s3)

    safestrcpy(np->name, p->name, sizeof(p->name));
    800025e8:	4641                	li	a2,16
    800025ea:	160a8593          	addi	a1,s5,352
    800025ee:	16098513          	addi	a0,s3,352
    800025f2:	ffcfe0ef          	jal	80000dee <safestrcpy>

    pid = np->pid;
    800025f6:	0309a903          	lw	s2,48(s3)

    release(&np->lock);
    800025fa:	854e                	mv	a0,s3
    800025fc:	e64fe0ef          	jal	80000c60 <release>

    acquire(&wait_lock);
    80002600:	0000d497          	auipc	s1,0xd
    80002604:	39048493          	addi	s1,s1,912 # 8000f990 <wait_lock>
    80002608:	8526                	mv	a0,s1
    8000260a:	dc2fe0ef          	jal	80000bcc <acquire>
    np->parent = p;
    8000260e:	0559b023          	sd	s5,64(s3)
    release(&wait_lock);
    80002612:	8526                	mv	a0,s1
    80002614:	e4cfe0ef          	jal	80000c60 <release>

    acquire(&np->lock);
    80002618:	854e                	mv	a0,s3
    8000261a:	db2fe0ef          	jal	80000bcc <acquire>
    np->state = RUNNABLE;
    8000261e:	478d                	li	a5,3
    80002620:	00f9ac23          	sw	a5,24(s3)
    release(&np->lock);
    80002624:	854e                	mv	a0,s3
    80002626:	e3afe0ef          	jal	80000c60 <release>

    p->thread_count += 1;
    8000262a:	038aa783          	lw	a5,56(s5)
    8000262e:	2785                	addiw	a5,a5,1
    80002630:	02faac23          	sw	a5,56(s5)
    np->tgid = p->tgid;
    80002634:	034aa783          	lw	a5,52(s5)
    80002638:	02f9aa23          	sw	a5,52(s3)

    return pid;
    8000263c:	69e2                	ld	s3,24(sp)
    8000263e:	6aa2                	ld	s5,8(sp)
}
    80002640:	854a                	mv	a0,s2
    80002642:	70e2                	ld	ra,56(sp)
    80002644:	7442                	ld	s0,48(sp)
    80002646:	74a2                	ld	s1,40(sp)
    80002648:	7902                	ld	s2,32(sp)
    8000264a:	6a42                	ld	s4,16(sp)
    8000264c:	6121                	addi	sp,sp,64
    8000264e:	8082                	ret
        return -1;
    80002650:	597d                	li	s2,-1
    80002652:	b7fd                	j	80002640 <clone+0x14e>
        return -1;
    80002654:	597d                	li	s2,-1
    80002656:	69e2                	ld	s3,24(sp)
    80002658:	6aa2                	ld	s5,8(sp)
    8000265a:	b7dd                	j	80002640 <clone+0x14e>

000000008000265c <join>:

int join(void)
{
    8000265c:	715d                	addi	sp,sp,-80
    8000265e:	e486                	sd	ra,72(sp)
    80002660:	e0a2                	sd	s0,64(sp)
    80002662:	fc26                	sd	s1,56(sp)
    80002664:	f84a                	sd	s2,48(sp)
    80002666:	f44e                	sd	s3,40(sp)
    80002668:	f052                	sd	s4,32(sp)
    8000266a:	ec56                	sd	s5,24(sp)
    8000266c:	e85a                	sd	s6,16(sp)
    8000266e:	e45e                	sd	s7,8(sp)
    80002670:	0880                	addi	s0,sp,80
    struct proc *pp;
    int havekids, pid;
    struct proc *p = myproc();
    80002672:	a4cff0ef          	jal	800018be <myproc>
    80002676:	892a                	mv	s2,a0

    acquire(&wait_lock);
    80002678:	0000d517          	auipc	a0,0xd
    8000267c:	31850513          	addi	a0,a0,792 # 8000f990 <wait_lock>
    80002680:	d4cfe0ef          	jal	80000bcc <acquire>
                    release(&pp->lock);
                    continue;
                }

                havekids = 1;
                if (pp->state == ZOMBIE) {
    80002684:	4a95                	li	s5,5
                havekids = 1;
    80002686:	4b05                	li	s6,1
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002688:	00013997          	auipc	s3,0x13
    8000268c:	52098993          	addi	s3,s3,1312 # 80015ba8 <tickslock>
            release(&wait_lock);
            return -1;
        }

        // Wait for a child to exit.
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002690:	0000db97          	auipc	s7,0xd
    80002694:	300b8b93          	addi	s7,s7,768 # 8000f990 <wait_lock>
    80002698:	a061                	j	80002720 <join+0xc4>
                    release(&pp->lock);
    8000269a:	8526                	mv	a0,s1
    8000269c:	dc4fe0ef          	jal	80000c60 <release>
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    800026a0:	17848493          	addi	s1,s1,376
    800026a4:	07348463          	beq	s1,s3,8000270c <join+0xb0>
            if (pp->parent == p) {
    800026a8:	60bc                	ld	a5,64(s1)
    800026aa:	ff279be3          	bne	a5,s2,800026a0 <join+0x44>
                acquire(&pp->lock);
    800026ae:	8526                	mv	a0,s1
    800026b0:	d1cfe0ef          	jal	80000bcc <acquire>
                if (pp->tgid != p->pid) {
    800026b4:	58d8                	lw	a4,52(s1)
    800026b6:	03092783          	lw	a5,48(s2)
    800026ba:	fef710e3          	bne	a4,a5,8000269a <join+0x3e>
                if (pp->state == ZOMBIE) {
    800026be:	4c9c                	lw	a5,24(s1)
    800026c0:	01578763          	beq	a5,s5,800026ce <join+0x72>
                release(&pp->lock);
    800026c4:	8526                	mv	a0,s1
    800026c6:	d9afe0ef          	jal	80000c60 <release>
                havekids = 1;
    800026ca:	8a5a                	mv	s4,s6
    800026cc:	bfd1                	j	800026a0 <join+0x44>
                    pid = pp->pid;
    800026ce:	0304a983          	lw	s3,48(s1)
                    freeproc(pp);
    800026d2:	8526                	mv	a0,s1
    800026d4:	bf8ff0ef          	jal	80001acc <freeproc>
                    release(&pp->lock);
    800026d8:	8526                	mv	a0,s1
    800026da:	d86fe0ef          	jal	80000c60 <release>
                    release(&wait_lock);
    800026de:	0000d517          	auipc	a0,0xd
    800026e2:	2b250513          	addi	a0,a0,690 # 8000f990 <wait_lock>
    800026e6:	d7afe0ef          	jal	80000c60 <release>
                    p->thread_count--;
    800026ea:	03892783          	lw	a5,56(s2)
    800026ee:	37fd                	addiw	a5,a5,-1
    800026f0:	02f92c23          	sw	a5,56(s2)
    }
}
    800026f4:	854e                	mv	a0,s3
    800026f6:	60a6                	ld	ra,72(sp)
    800026f8:	6406                	ld	s0,64(sp)
    800026fa:	74e2                	ld	s1,56(sp)
    800026fc:	7942                	ld	s2,48(sp)
    800026fe:	79a2                	ld	s3,40(sp)
    80002700:	7a02                	ld	s4,32(sp)
    80002702:	6ae2                	ld	s5,24(sp)
    80002704:	6b42                	ld	s6,16(sp)
    80002706:	6ba2                	ld	s7,8(sp)
    80002708:	6161                	addi	sp,sp,80
    8000270a:	8082                	ret
        if (!havekids || killed(p)) {
    8000270c:	020a0063          	beqz	s4,8000272c <join+0xd0>
    80002710:	854a                	mv	a0,s2
    80002712:	ab7ff0ef          	jal	800021c8 <killed>
    80002716:	e919                	bnez	a0,8000272c <join+0xd0>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002718:	85de                	mv	a1,s7
    8000271a:	854a                	mv	a0,s2
    8000271c:	80dff0ef          	jal	80001f28 <sleep>
        havekids = 0;
    80002720:	4a01                	li	s4,0
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002722:	0000d497          	auipc	s1,0xd
    80002726:	68648493          	addi	s1,s1,1670 # 8000fda8 <proc>
    8000272a:	bfbd                	j	800026a8 <join+0x4c>
            release(&wait_lock);
    8000272c:	0000d517          	auipc	a0,0xd
    80002730:	26450513          	addi	a0,a0,612 # 8000f990 <wait_lock>
    80002734:	d2cfe0ef          	jal	80000c60 <release>
            return -1;
    80002738:	59fd                	li	s3,-1
    8000273a:	bf6d                	j	800026f4 <join+0x98>

000000008000273c <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    8000273c:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80002740:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80002744:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80002746:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80002748:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8000274c:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80002750:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002754:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002758:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8000275c:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002760:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002764:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002768:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8000276c:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002770:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002774:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002778:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000277a:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000277c:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002780:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002784:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002788:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000278c:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002790:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002794:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002798:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000279c:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800027a0:	0685bd83          	ld	s11,104(a1)
        
        ret
    800027a4:	8082                	ret

00000000800027a6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800027a6:	1141                	addi	sp,sp,-16
    800027a8:	e406                	sd	ra,8(sp)
    800027aa:	e022                	sd	s0,0(sp)
    800027ac:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800027ae:	00005597          	auipc	a1,0x5
    800027b2:	a9a58593          	addi	a1,a1,-1382 # 80007248 <etext+0x248>
    800027b6:	00013517          	auipc	a0,0x13
    800027ba:	3f250513          	addi	a0,a0,1010 # 80015ba8 <tickslock>
    800027be:	b8afe0ef          	jal	80000b48 <initlock>
}
    800027c2:	60a2                	ld	ra,8(sp)
    800027c4:	6402                	ld	s0,0(sp)
    800027c6:	0141                	addi	sp,sp,16
    800027c8:	8082                	ret

00000000800027ca <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800027ca:	1141                	addi	sp,sp,-16
    800027cc:	e406                	sd	ra,8(sp)
    800027ce:	e022                	sd	s0,0(sp)
    800027d0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027d2:	00003797          	auipc	a5,0x3
    800027d6:	17e78793          	addi	a5,a5,382 # 80005950 <kernelvec>
    800027da:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800027de:	60a2                	ld	ra,8(sp)
    800027e0:	6402                	ld	s0,0(sp)
    800027e2:	0141                	addi	sp,sp,16
    800027e4:	8082                	ret

00000000800027e6 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800027e6:	1141                	addi	sp,sp,-16
    800027e8:	e406                	sd	ra,8(sp)
    800027ea:	e022                	sd	s0,0(sp)
    800027ec:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800027ee:	8d0ff0ef          	jal	800018be <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800027f6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027f8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800027fc:	04000737          	lui	a4,0x4000
    80002800:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002802:	0732                	slli	a4,a4,0xc
    80002804:	00003797          	auipc	a5,0x3
    80002808:	7fc78793          	addi	a5,a5,2044 # 80006000 <_trampoline>
    8000280c:	00003697          	auipc	a3,0x3
    80002810:	7f468693          	addi	a3,a3,2036 # 80006000 <_trampoline>
    80002814:	8f95                	sub	a5,a5,a3
    80002816:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002818:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000281c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000281e:	180026f3          	csrr	a3,satp
    80002822:	e394                	sd	a3,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002824:	7134                	ld	a3,96(a0)
    80002826:	653c                	ld	a5,72(a0)
    80002828:	6605                	lui	a2,0x1
    8000282a:	97b2                	add	a5,a5,a2
    8000282c:	e69c                	sd	a5,8(a3)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000282e:	713c                	ld	a5,96(a0)
    80002830:	00000697          	auipc	a3,0x0
    80002834:	12a68693          	addi	a3,a3,298 # 8000295a <usertrap>
    80002838:	eb94                	sd	a3,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000283a:	713c                	ld	a5,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000283c:	8692                	mv	a3,tp
    8000283e:	f394                	sd	a3,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002840:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002844:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002848:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000284c:	10079073          	csrw	sstatus,a5
  w_sstatus(x);
  w_sscratch(TRAPFRAME((int) (p-proc)));
    80002850:	0000d797          	auipc	a5,0xd
    80002854:	55878793          	addi	a5,a5,1368 # 8000fda8 <proc>
    80002858:	40f507b3          	sub	a5,a0,a5
    8000285c:	878d                	srai	a5,a5,0x3
    8000285e:	677d4637          	lui	a2,0x677d4
    80002862:	6cf60613          	addi	a2,a2,1743 # 677d46cf <_entry-0x1882b931>
    80002866:	51b3c6b7          	lui	a3,0x51b3c
    8000286a:	ea368693          	addi	a3,a3,-349 # 51b3bea3 <_entry-0x2e4c415d>
    8000286e:	1682                	slli	a3,a3,0x20
    80002870:	96b2                	add	a3,a3,a2
    80002872:	02d787b3          	mul	a5,a5,a3
    80002876:	2785                	addiw	a5,a5,1
    80002878:	00c7979b          	slliw	a5,a5,0xc
    8000287c:	8f1d                	sub	a4,a4,a5
  asm volatile("csrw sscratch, %0" : : "r" (x));
    8000287e:	14071073          	csrw	sscratch,a4

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002882:	713c                	ld	a5,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002884:	6f9c                	ld	a5,24(a5)
    80002886:	14179073          	csrw	sepc,a5
}
    8000288a:	60a2                	ld	ra,8(sp)
    8000288c:	6402                	ld	s0,0(sp)
    8000288e:	0141                	addi	sp,sp,16
    80002890:	8082                	ret

0000000080002892 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002892:	1101                	addi	sp,sp,-32
    80002894:	ec06                	sd	ra,24(sp)
    80002896:	e822                	sd	s0,16(sp)
    80002898:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000289a:	ff1fe0ef          	jal	8000188a <cpuid>
    8000289e:	cd11                	beqz	a0,800028ba <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800028a0:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800028a4:	000f4737          	lui	a4,0xf4
    800028a8:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800028ac:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800028ae:	14d79073          	csrw	stimecmp,a5
}
    800028b2:	60e2                	ld	ra,24(sp)
    800028b4:	6442                	ld	s0,16(sp)
    800028b6:	6105                	addi	sp,sp,32
    800028b8:	8082                	ret
    800028ba:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800028bc:	00013497          	auipc	s1,0x13
    800028c0:	2ec48493          	addi	s1,s1,748 # 80015ba8 <tickslock>
    800028c4:	8526                	mv	a0,s1
    800028c6:	b06fe0ef          	jal	80000bcc <acquire>
    ticks++;
    800028ca:	00005517          	auipc	a0,0x5
    800028ce:	fae50513          	addi	a0,a0,-82 # 80007878 <ticks>
    800028d2:	411c                	lw	a5,0(a0)
    800028d4:	2785                	addiw	a5,a5,1
    800028d6:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800028d8:	e9cff0ef          	jal	80001f74 <wakeup>
    release(&tickslock);
    800028dc:	8526                	mv	a0,s1
    800028de:	b82fe0ef          	jal	80000c60 <release>
    800028e2:	64a2                	ld	s1,8(sp)
    800028e4:	bf75                	j	800028a0 <clockintr+0xe>

00000000800028e6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800028e6:	1101                	addi	sp,sp,-32
    800028e8:	ec06                	sd	ra,24(sp)
    800028ea:	e822                	sd	s0,16(sp)
    800028ec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028ee:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800028f2:	57fd                	li	a5,-1
    800028f4:	17fe                	slli	a5,a5,0x3f
    800028f6:	07a5                	addi	a5,a5,9
    800028f8:	00f70c63          	beq	a4,a5,80002910 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800028fc:	57fd                	li	a5,-1
    800028fe:	17fe                	slli	a5,a5,0x3f
    80002900:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002902:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002904:	04f70763          	beq	a4,a5,80002952 <devintr+0x6c>
  }
}
    80002908:	60e2                	ld	ra,24(sp)
    8000290a:	6442                	ld	s0,16(sp)
    8000290c:	6105                	addi	sp,sp,32
    8000290e:	8082                	ret
    80002910:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002912:	0ea030ef          	jal	800059fc <plic_claim>
    80002916:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002918:	47a9                	li	a5,10
    8000291a:	00f50963          	beq	a0,a5,8000292c <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    8000291e:	4785                	li	a5,1
    80002920:	00f50963          	beq	a0,a5,80002932 <devintr+0x4c>
    return 1;
    80002924:	4505                	li	a0,1
    } else if(irq){
    80002926:	e889                	bnez	s1,80002938 <devintr+0x52>
    80002928:	64a2                	ld	s1,8(sp)
    8000292a:	bff9                	j	80002908 <devintr+0x22>
      uartintr();
    8000292c:	882fe0ef          	jal	800009ae <uartintr>
    if(irq)
    80002930:	a819                	j	80002946 <devintr+0x60>
      virtio_disk_intr();
    80002932:	55a030ef          	jal	80005e8c <virtio_disk_intr>
    if(irq)
    80002936:	a801                	j	80002946 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002938:	85a6                	mv	a1,s1
    8000293a:	00005517          	auipc	a0,0x5
    8000293e:	91650513          	addi	a0,a0,-1770 # 80007250 <etext+0x250>
    80002942:	bb9fd0ef          	jal	800004fa <printf>
      plic_complete(irq);
    80002946:	8526                	mv	a0,s1
    80002948:	0d4030ef          	jal	80005a1c <plic_complete>
    return 1;
    8000294c:	4505                	li	a0,1
    8000294e:	64a2                	ld	s1,8(sp)
    80002950:	bf65                	j	80002908 <devintr+0x22>
    clockintr();
    80002952:	f41ff0ef          	jal	80002892 <clockintr>
    return 2;
    80002956:	4509                	li	a0,2
    80002958:	bf45                	j	80002908 <devintr+0x22>

000000008000295a <usertrap>:
{
    8000295a:	1101                	addi	sp,sp,-32
    8000295c:	ec06                	sd	ra,24(sp)
    8000295e:	e822                	sd	s0,16(sp)
    80002960:	e426                	sd	s1,8(sp)
    80002962:	e04a                	sd	s2,0(sp)
    80002964:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002966:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000296a:	1007f793          	andi	a5,a5,256
    8000296e:	eba5                	bnez	a5,800029de <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002970:	00003797          	auipc	a5,0x3
    80002974:	fe078793          	addi	a5,a5,-32 # 80005950 <kernelvec>
    80002978:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000297c:	f43fe0ef          	jal	800018be <myproc>
    80002980:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002982:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002984:	14102773          	csrr	a4,sepc
    80002988:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000298a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000298e:	47a1                	li	a5,8
    80002990:	04f70d63          	beq	a4,a5,800029ea <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80002994:	f53ff0ef          	jal	800028e6 <devintr>
    80002998:	892a                	mv	s2,a0
    8000299a:	e945                	bnez	a0,80002a4a <usertrap+0xf0>
    8000299c:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    800029a0:	47bd                	li	a5,15
    800029a2:	08f70863          	beq	a4,a5,80002a32 <usertrap+0xd8>
    800029a6:	14202773          	csrr	a4,scause
    800029aa:	47b5                	li	a5,13
    800029ac:	08f70363          	beq	a4,a5,80002a32 <usertrap+0xd8>
    800029b0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800029b4:	5890                	lw	a2,48(s1)
    800029b6:	00005517          	auipc	a0,0x5
    800029ba:	8da50513          	addi	a0,a0,-1830 # 80007290 <etext+0x290>
    800029be:	b3dfd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029c2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029c6:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800029ca:	00005517          	auipc	a0,0x5
    800029ce:	8f650513          	addi	a0,a0,-1802 # 800072c0 <etext+0x2c0>
    800029d2:	b29fd0ef          	jal	800004fa <printf>
    setkilled(p);
    800029d6:	8526                	mv	a0,s1
    800029d8:	fccff0ef          	jal	800021a4 <setkilled>
    800029dc:	a035                	j	80002a08 <usertrap+0xae>
    panic("usertrap: not from user mode");
    800029de:	00005517          	auipc	a0,0x5
    800029e2:	89250513          	addi	a0,a0,-1902 # 80007270 <etext+0x270>
    800029e6:	df9fd0ef          	jal	800007de <panic>
    if(killed(p))
    800029ea:	fdeff0ef          	jal	800021c8 <killed>
    800029ee:	ed15                	bnez	a0,80002a2a <usertrap+0xd0>
    p->trapframe->epc += 4;
    800029f0:	70b8                	ld	a4,96(s1)
    800029f2:	6f1c                	ld	a5,24(a4)
    800029f4:	0791                	addi	a5,a5,4
    800029f6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029f8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800029fc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a00:	10079073          	csrw	sstatus,a5
    syscall();
    80002a04:	23e000ef          	jal	80002c42 <syscall>
  if(killed(p))
    80002a08:	8526                	mv	a0,s1
    80002a0a:	fbeff0ef          	jal	800021c8 <killed>
    80002a0e:	e139                	bnez	a0,80002a54 <usertrap+0xfa>
  prepare_return();
    80002a10:	dd7ff0ef          	jal	800027e6 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002a14:	6ca8                	ld	a0,88(s1)
    80002a16:	8131                	srli	a0,a0,0xc
    80002a18:	57fd                	li	a5,-1
    80002a1a:	17fe                	slli	a5,a5,0x3f
    80002a1c:	8d5d                	or	a0,a0,a5
}
    80002a1e:	60e2                	ld	ra,24(sp)
    80002a20:	6442                	ld	s0,16(sp)
    80002a22:	64a2                	ld	s1,8(sp)
    80002a24:	6902                	ld	s2,0(sp)
    80002a26:	6105                	addi	sp,sp,32
    80002a28:	8082                	ret
      kexit(-1);
    80002a2a:	557d                	li	a0,-1
    80002a2c:	e70ff0ef          	jal	8000209c <kexit>
    80002a30:	b7c1                	j	800029f0 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a32:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a36:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80002a3a:	164d                	addi	a2,a2,-13
    80002a3c:	00163613          	seqz	a2,a2
    80002a40:	6ca8                	ld	a0,88(s1)
    80002a42:	b2dfe0ef          	jal	8000156e <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002a46:	f169                	bnez	a0,80002a08 <usertrap+0xae>
    80002a48:	b7a5                	j	800029b0 <usertrap+0x56>
  if(killed(p))
    80002a4a:	8526                	mv	a0,s1
    80002a4c:	f7cff0ef          	jal	800021c8 <killed>
    80002a50:	c511                	beqz	a0,80002a5c <usertrap+0x102>
    80002a52:	a011                	j	80002a56 <usertrap+0xfc>
    80002a54:	4901                	li	s2,0
    kexit(-1);
    80002a56:	557d                	li	a0,-1
    80002a58:	e44ff0ef          	jal	8000209c <kexit>
  if(which_dev == 2)
    80002a5c:	4789                	li	a5,2
    80002a5e:	faf919e3          	bne	s2,a5,80002a10 <usertrap+0xb6>
    yield();
    80002a62:	c9aff0ef          	jal	80001efc <yield>
    80002a66:	b76d                	j	80002a10 <usertrap+0xb6>

0000000080002a68 <kerneltrap>:
{
    80002a68:	7179                	addi	sp,sp,-48
    80002a6a:	f406                	sd	ra,40(sp)
    80002a6c:	f022                	sd	s0,32(sp)
    80002a6e:	ec26                	sd	s1,24(sp)
    80002a70:	e84a                	sd	s2,16(sp)
    80002a72:	e44e                	sd	s3,8(sp)
    80002a74:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a76:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a7a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a7e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a82:	1004f793          	andi	a5,s1,256
    80002a86:	c795                	beqz	a5,80002ab2 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a88:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a8c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002a8e:	eb85                	bnez	a5,80002abe <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002a90:	e57ff0ef          	jal	800028e6 <devintr>
    80002a94:	c91d                	beqz	a0,80002aca <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002a96:	4789                	li	a5,2
    80002a98:	04f50a63          	beq	a0,a5,80002aec <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a9c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002aa0:	10049073          	csrw	sstatus,s1
}
    80002aa4:	70a2                	ld	ra,40(sp)
    80002aa6:	7402                	ld	s0,32(sp)
    80002aa8:	64e2                	ld	s1,24(sp)
    80002aaa:	6942                	ld	s2,16(sp)
    80002aac:	69a2                	ld	s3,8(sp)
    80002aae:	6145                	addi	sp,sp,48
    80002ab0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002ab2:	00005517          	auipc	a0,0x5
    80002ab6:	83650513          	addi	a0,a0,-1994 # 800072e8 <etext+0x2e8>
    80002aba:	d25fd0ef          	jal	800007de <panic>
    panic("kerneltrap: interrupts enabled");
    80002abe:	00005517          	auipc	a0,0x5
    80002ac2:	85250513          	addi	a0,a0,-1966 # 80007310 <etext+0x310>
    80002ac6:	d19fd0ef          	jal	800007de <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002aca:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ace:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002ad2:	85ce                	mv	a1,s3
    80002ad4:	00005517          	auipc	a0,0x5
    80002ad8:	85c50513          	addi	a0,a0,-1956 # 80007330 <etext+0x330>
    80002adc:	a1ffd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    80002ae0:	00005517          	auipc	a0,0x5
    80002ae4:	87850513          	addi	a0,a0,-1928 # 80007358 <etext+0x358>
    80002ae8:	cf7fd0ef          	jal	800007de <panic>
  if(which_dev == 2 && myproc() != 0)
    80002aec:	dd3fe0ef          	jal	800018be <myproc>
    80002af0:	d555                	beqz	a0,80002a9c <kerneltrap+0x34>
    yield();
    80002af2:	c0aff0ef          	jal	80001efc <yield>
    80002af6:	b75d                	j	80002a9c <kerneltrap+0x34>

0000000080002af8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002af8:	1101                	addi	sp,sp,-32
    80002afa:	ec06                	sd	ra,24(sp)
    80002afc:	e822                	sd	s0,16(sp)
    80002afe:	e426                	sd	s1,8(sp)
    80002b00:	1000                	addi	s0,sp,32
    80002b02:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b04:	dbbfe0ef          	jal	800018be <myproc>
  switch (n) {
    80002b08:	4795                	li	a5,5
    80002b0a:	0497e163          	bltu	a5,s1,80002b4c <argraw+0x54>
    80002b0e:	048a                	slli	s1,s1,0x2
    80002b10:	00005717          	auipc	a4,0x5
    80002b14:	c4870713          	addi	a4,a4,-952 # 80007758 <states.0+0x30>
    80002b18:	94ba                	add	s1,s1,a4
    80002b1a:	409c                	lw	a5,0(s1)
    80002b1c:	97ba                	add	a5,a5,a4
    80002b1e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002b20:	713c                	ld	a5,96(a0)
    80002b22:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002b24:	60e2                	ld	ra,24(sp)
    80002b26:	6442                	ld	s0,16(sp)
    80002b28:	64a2                	ld	s1,8(sp)
    80002b2a:	6105                	addi	sp,sp,32
    80002b2c:	8082                	ret
    return p->trapframe->a1;
    80002b2e:	713c                	ld	a5,96(a0)
    80002b30:	7fa8                	ld	a0,120(a5)
    80002b32:	bfcd                	j	80002b24 <argraw+0x2c>
    return p->trapframe->a2;
    80002b34:	713c                	ld	a5,96(a0)
    80002b36:	63c8                	ld	a0,128(a5)
    80002b38:	b7f5                	j	80002b24 <argraw+0x2c>
    return p->trapframe->a3;
    80002b3a:	713c                	ld	a5,96(a0)
    80002b3c:	67c8                	ld	a0,136(a5)
    80002b3e:	b7dd                	j	80002b24 <argraw+0x2c>
    return p->trapframe->a4;
    80002b40:	713c                	ld	a5,96(a0)
    80002b42:	6bc8                	ld	a0,144(a5)
    80002b44:	b7c5                	j	80002b24 <argraw+0x2c>
    return p->trapframe->a5;
    80002b46:	713c                	ld	a5,96(a0)
    80002b48:	6fc8                	ld	a0,152(a5)
    80002b4a:	bfe9                	j	80002b24 <argraw+0x2c>
  panic("argraw");
    80002b4c:	00005517          	auipc	a0,0x5
    80002b50:	81c50513          	addi	a0,a0,-2020 # 80007368 <etext+0x368>
    80002b54:	c8bfd0ef          	jal	800007de <panic>

0000000080002b58 <fetchaddr>:
{
    80002b58:	1101                	addi	sp,sp,-32
    80002b5a:	ec06                	sd	ra,24(sp)
    80002b5c:	e822                	sd	s0,16(sp)
    80002b5e:	e426                	sd	s1,8(sp)
    80002b60:	e04a                	sd	s2,0(sp)
    80002b62:	1000                	addi	s0,sp,32
    80002b64:	84aa                	mv	s1,a0
    80002b66:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b68:	d57fe0ef          	jal	800018be <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002b6c:	693c                	ld	a5,80(a0)
    80002b6e:	02f4f663          	bgeu	s1,a5,80002b9a <fetchaddr+0x42>
    80002b72:	00848713          	addi	a4,s1,8
    80002b76:	02e7e463          	bltu	a5,a4,80002b9e <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b7a:	46a1                	li	a3,8
    80002b7c:	8626                	mv	a2,s1
    80002b7e:	85ca                	mv	a1,s2
    80002b80:	6d28                	ld	a0,88(a0)
    80002b82:	b2dfe0ef          	jal	800016ae <copyin>
    80002b86:	00a03533          	snez	a0,a0
    80002b8a:	40a0053b          	negw	a0,a0
}
    80002b8e:	60e2                	ld	ra,24(sp)
    80002b90:	6442                	ld	s0,16(sp)
    80002b92:	64a2                	ld	s1,8(sp)
    80002b94:	6902                	ld	s2,0(sp)
    80002b96:	6105                	addi	sp,sp,32
    80002b98:	8082                	ret
    return -1;
    80002b9a:	557d                	li	a0,-1
    80002b9c:	bfcd                	j	80002b8e <fetchaddr+0x36>
    80002b9e:	557d                	li	a0,-1
    80002ba0:	b7fd                	j	80002b8e <fetchaddr+0x36>

0000000080002ba2 <fetchstr>:
{
    80002ba2:	7179                	addi	sp,sp,-48
    80002ba4:	f406                	sd	ra,40(sp)
    80002ba6:	f022                	sd	s0,32(sp)
    80002ba8:	ec26                	sd	s1,24(sp)
    80002baa:	e84a                	sd	s2,16(sp)
    80002bac:	e44e                	sd	s3,8(sp)
    80002bae:	1800                	addi	s0,sp,48
    80002bb0:	892a                	mv	s2,a0
    80002bb2:	84ae                	mv	s1,a1
    80002bb4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002bb6:	d09fe0ef          	jal	800018be <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002bba:	86ce                	mv	a3,s3
    80002bbc:	864a                	mv	a2,s2
    80002bbe:	85a6                	mv	a1,s1
    80002bc0:	6d28                	ld	a0,88(a0)
    80002bc2:	8edfe0ef          	jal	800014ae <copyinstr>
    80002bc6:	00054c63          	bltz	a0,80002bde <fetchstr+0x3c>
  return strlen(buf);
    80002bca:	8526                	mv	a0,s1
    80002bcc:	a58fe0ef          	jal	80000e24 <strlen>
}
    80002bd0:	70a2                	ld	ra,40(sp)
    80002bd2:	7402                	ld	s0,32(sp)
    80002bd4:	64e2                	ld	s1,24(sp)
    80002bd6:	6942                	ld	s2,16(sp)
    80002bd8:	69a2                	ld	s3,8(sp)
    80002bda:	6145                	addi	sp,sp,48
    80002bdc:	8082                	ret
    return -1;
    80002bde:	557d                	li	a0,-1
    80002be0:	bfc5                	j	80002bd0 <fetchstr+0x2e>

0000000080002be2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002be2:	1101                	addi	sp,sp,-32
    80002be4:	ec06                	sd	ra,24(sp)
    80002be6:	e822                	sd	s0,16(sp)
    80002be8:	e426                	sd	s1,8(sp)
    80002bea:	1000                	addi	s0,sp,32
    80002bec:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bee:	f0bff0ef          	jal	80002af8 <argraw>
    80002bf2:	c088                	sw	a0,0(s1)
}
    80002bf4:	60e2                	ld	ra,24(sp)
    80002bf6:	6442                	ld	s0,16(sp)
    80002bf8:	64a2                	ld	s1,8(sp)
    80002bfa:	6105                	addi	sp,sp,32
    80002bfc:	8082                	ret

0000000080002bfe <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002bfe:	1101                	addi	sp,sp,-32
    80002c00:	ec06                	sd	ra,24(sp)
    80002c02:	e822                	sd	s0,16(sp)
    80002c04:	e426                	sd	s1,8(sp)
    80002c06:	1000                	addi	s0,sp,32
    80002c08:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c0a:	eefff0ef          	jal	80002af8 <argraw>
    80002c0e:	e088                	sd	a0,0(s1)
}
    80002c10:	60e2                	ld	ra,24(sp)
    80002c12:	6442                	ld	s0,16(sp)
    80002c14:	64a2                	ld	s1,8(sp)
    80002c16:	6105                	addi	sp,sp,32
    80002c18:	8082                	ret

0000000080002c1a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002c1a:	1101                	addi	sp,sp,-32
    80002c1c:	ec06                	sd	ra,24(sp)
    80002c1e:	e822                	sd	s0,16(sp)
    80002c20:	e426                	sd	s1,8(sp)
    80002c22:	e04a                	sd	s2,0(sp)
    80002c24:	1000                	addi	s0,sp,32
    80002c26:	84ae                	mv	s1,a1
    80002c28:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002c2a:	ecfff0ef          	jal	80002af8 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002c2e:	864a                	mv	a2,s2
    80002c30:	85a6                	mv	a1,s1
    80002c32:	f71ff0ef          	jal	80002ba2 <fetchstr>
}
    80002c36:	60e2                	ld	ra,24(sp)
    80002c38:	6442                	ld	s0,16(sp)
    80002c3a:	64a2                	ld	s1,8(sp)
    80002c3c:	6902                	ld	s2,0(sp)
    80002c3e:	6105                	addi	sp,sp,32
    80002c40:	8082                	ret

0000000080002c42 <syscall>:
[SYS_futex_wake]    sys_futex_wake,
};

void
syscall(void)
{
    80002c42:	1101                	addi	sp,sp,-32
    80002c44:	ec06                	sd	ra,24(sp)
    80002c46:	e822                	sd	s0,16(sp)
    80002c48:	e426                	sd	s1,8(sp)
    80002c4a:	e04a                	sd	s2,0(sp)
    80002c4c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002c4e:	c71fe0ef          	jal	800018be <myproc>
    80002c52:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002c54:	06053903          	ld	s2,96(a0)
    80002c58:	0a893783          	ld	a5,168(s2)
    80002c5c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c60:	37fd                	addiw	a5,a5,-1
    80002c62:	4761                	li	a4,24
    80002c64:	00f76f63          	bltu	a4,a5,80002c82 <syscall+0x40>
    80002c68:	00369713          	slli	a4,a3,0x3
    80002c6c:	00005797          	auipc	a5,0x5
    80002c70:	b0478793          	addi	a5,a5,-1276 # 80007770 <syscalls>
    80002c74:	97ba                	add	a5,a5,a4
    80002c76:	639c                	ld	a5,0(a5)
    80002c78:	c789                	beqz	a5,80002c82 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002c7a:	9782                	jalr	a5
    80002c7c:	06a93823          	sd	a0,112(s2)
    80002c80:	a829                	j	80002c9a <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c82:	16048613          	addi	a2,s1,352
    80002c86:	588c                	lw	a1,48(s1)
    80002c88:	00004517          	auipc	a0,0x4
    80002c8c:	6e850513          	addi	a0,a0,1768 # 80007370 <etext+0x370>
    80002c90:	86bfd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c94:	70bc                	ld	a5,96(s1)
    80002c96:	577d                	li	a4,-1
    80002c98:	fbb8                	sd	a4,112(a5)
  }
}
    80002c9a:	60e2                	ld	ra,24(sp)
    80002c9c:	6442                	ld	s0,16(sp)
    80002c9e:	64a2                	ld	s1,8(sp)
    80002ca0:	6902                	ld	s2,0(sp)
    80002ca2:	6105                	addi	sp,sp,32
    80002ca4:	8082                	ret

0000000080002ca6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"
#include "vm.h"

uint64 sys_exit(void)
{
    80002ca6:	1101                	addi	sp,sp,-32
    80002ca8:	ec06                	sd	ra,24(sp)
    80002caa:	e822                	sd	s0,16(sp)
    80002cac:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    80002cae:	fec40593          	addi	a1,s0,-20
    80002cb2:	4501                	li	a0,0
    80002cb4:	f2fff0ef          	jal	80002be2 <argint>
    kexit(n);
    80002cb8:	fec42503          	lw	a0,-20(s0)
    80002cbc:	be0ff0ef          	jal	8000209c <kexit>
    return 0; // not reached
}
    80002cc0:	4501                	li	a0,0
    80002cc2:	60e2                	ld	ra,24(sp)
    80002cc4:	6442                	ld	s0,16(sp)
    80002cc6:	6105                	addi	sp,sp,32
    80002cc8:	8082                	ret

0000000080002cca <sys_getpid>:

uint64 sys_getpid(void)
{
    80002cca:	1141                	addi	sp,sp,-16
    80002ccc:	e406                	sd	ra,8(sp)
    80002cce:	e022                	sd	s0,0(sp)
    80002cd0:	0800                	addi	s0,sp,16
    return myproc()->pid;
    80002cd2:	bedfe0ef          	jal	800018be <myproc>
}
    80002cd6:	5908                	lw	a0,48(a0)
    80002cd8:	60a2                	ld	ra,8(sp)
    80002cda:	6402                	ld	s0,0(sp)
    80002cdc:	0141                	addi	sp,sp,16
    80002cde:	8082                	ret

0000000080002ce0 <sys_fork>:

uint64 sys_fork(void)
{
    80002ce0:	1141                	addi	sp,sp,-16
    80002ce2:	e406                	sd	ra,8(sp)
    80002ce4:	e022                	sd	s0,0(sp)
    80002ce6:	0800                	addi	s0,sp,16
    return kfork();
    80002ce8:	f89fe0ef          	jal	80001c70 <kfork>
}
    80002cec:	60a2                	ld	ra,8(sp)
    80002cee:	6402                	ld	s0,0(sp)
    80002cf0:	0141                	addi	sp,sp,16
    80002cf2:	8082                	ret

0000000080002cf4 <sys_wait>:

uint64 sys_wait(void)
{
    80002cf4:	1101                	addi	sp,sp,-32
    80002cf6:	ec06                	sd	ra,24(sp)
    80002cf8:	e822                	sd	s0,16(sp)
    80002cfa:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    80002cfc:	fe840593          	addi	a1,s0,-24
    80002d00:	4501                	li	a0,0
    80002d02:	efdff0ef          	jal	80002bfe <argaddr>
    return kwait(p);
    80002d06:	fe843503          	ld	a0,-24(s0)
    80002d0a:	ce8ff0ef          	jal	800021f2 <kwait>
}
    80002d0e:	60e2                	ld	ra,24(sp)
    80002d10:	6442                	ld	s0,16(sp)
    80002d12:	6105                	addi	sp,sp,32
    80002d14:	8082                	ret

0000000080002d16 <sys_sbrk>:

uint64 sys_sbrk(void)
{
    80002d16:	7179                	addi	sp,sp,-48
    80002d18:	f406                	sd	ra,40(sp)
    80002d1a:	f022                	sd	s0,32(sp)
    80002d1c:	ec26                	sd	s1,24(sp)
    80002d1e:	1800                	addi	s0,sp,48
    uint64 addr;
    int t;
    int n;

    argint(0, &n);
    80002d20:	fd840593          	addi	a1,s0,-40
    80002d24:	4501                	li	a0,0
    80002d26:	ebdff0ef          	jal	80002be2 <argint>
    argint(1, &t);
    80002d2a:	fdc40593          	addi	a1,s0,-36
    80002d2e:	4505                	li	a0,1
    80002d30:	eb3ff0ef          	jal	80002be2 <argint>
    addr = myproc()->sz;
    80002d34:	b8bfe0ef          	jal	800018be <myproc>
    80002d38:	6924                	ld	s1,80(a0)

    if (t == SBRK_EAGER || n < 0) {
    80002d3a:	fdc42703          	lw	a4,-36(s0)
    80002d3e:	4785                	li	a5,1
    80002d40:	04f70463          	beq	a4,a5,80002d88 <sys_sbrk+0x72>
    80002d44:	fd842783          	lw	a5,-40(s0)
    80002d48:	0407c063          	bltz	a5,80002d88 <sys_sbrk+0x72>
        }
    } else {
        // Lazily allocate memory for this process: increase its memory
        // size but don't allocate memory. If the processes uses the
        // memory, vmfault() will allocate it.
        if (addr + n < addr)
    80002d4c:	97a6                	add	a5,a5,s1
    80002d4e:	0497eb63          	bltu	a5,s1,80002da4 <sys_sbrk+0x8e>
            return -1;
        if (addr + n > TRAPFRAME(NPROC))
    80002d52:	02000737          	lui	a4,0x2000
    80002d56:	fdf70713          	addi	a4,a4,-33 # 1ffffdf <_entry-0x7e000021>
    80002d5a:	0736                	slli	a4,a4,0xd
    80002d5c:	04f76663          	bltu	a4,a5,80002da8 <sys_sbrk+0x92>
    80002d60:	e84a                	sd	s2,16(sp)
            return -1;
        myproc()->sz += n;
    80002d62:	b5dfe0ef          	jal	800018be <myproc>
    80002d66:	fd842703          	lw	a4,-40(s0)
    80002d6a:	693c                	ld	a5,80(a0)
    80002d6c:	97ba                	add	a5,a5,a4
    80002d6e:	e93c                	sd	a5,80(a0)
        update_sz(myproc()->tgid, myproc()->sz);
    80002d70:	b4ffe0ef          	jal	800018be <myproc>
    80002d74:	03452903          	lw	s2,52(a0)
    80002d78:	b47fe0ef          	jal	800018be <myproc>
    80002d7c:	692c                	ld	a1,80(a0)
    80002d7e:	854a                	mv	a0,s2
    80002d80:	eb4ff0ef          	jal	80002434 <update_sz>
    80002d84:	6942                	ld	s2,16(sp)
    80002d86:	a039                	j	80002d94 <sys_sbrk+0x7e>
        if (growproc(n) < 0) {
    80002d88:	fd842503          	lw	a0,-40(s0)
    80002d8c:	efeff0ef          	jal	8000248a <growproc>
    80002d90:	00054863          	bltz	a0,80002da0 <sys_sbrk+0x8a>
    }
    return addr;
}
    80002d94:	8526                	mv	a0,s1
    80002d96:	70a2                	ld	ra,40(sp)
    80002d98:	7402                	ld	s0,32(sp)
    80002d9a:	64e2                	ld	s1,24(sp)
    80002d9c:	6145                	addi	sp,sp,48
    80002d9e:	8082                	ret
            return -1;
    80002da0:	54fd                	li	s1,-1
    80002da2:	bfcd                	j	80002d94 <sys_sbrk+0x7e>
            return -1;
    80002da4:	54fd                	li	s1,-1
    80002da6:	b7fd                	j	80002d94 <sys_sbrk+0x7e>
            return -1;
    80002da8:	54fd                	li	s1,-1
    80002daa:	b7ed                	j	80002d94 <sys_sbrk+0x7e>

0000000080002dac <sys_pause>:

uint64 sys_pause(void)
{
    80002dac:	7139                	addi	sp,sp,-64
    80002dae:	fc06                	sd	ra,56(sp)
    80002db0:	f822                	sd	s0,48(sp)
    80002db2:	f04a                	sd	s2,32(sp)
    80002db4:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    80002db6:	fcc40593          	addi	a1,s0,-52
    80002dba:	4501                	li	a0,0
    80002dbc:	e27ff0ef          	jal	80002be2 <argint>
    if (n < 0)
    80002dc0:	fcc42783          	lw	a5,-52(s0)
    80002dc4:	0607c763          	bltz	a5,80002e32 <sys_pause+0x86>
        n = 0;
    acquire(&tickslock);
    80002dc8:	00013517          	auipc	a0,0x13
    80002dcc:	de050513          	addi	a0,a0,-544 # 80015ba8 <tickslock>
    80002dd0:	dfdfd0ef          	jal	80000bcc <acquire>
    ticks0 = ticks;
    80002dd4:	00005917          	auipc	s2,0x5
    80002dd8:	aa492903          	lw	s2,-1372(s2) # 80007878 <ticks>
    while (ticks - ticks0 < n) {
    80002ddc:	fcc42783          	lw	a5,-52(s0)
    80002de0:	cf8d                	beqz	a5,80002e1a <sys_pause+0x6e>
    80002de2:	f426                	sd	s1,40(sp)
    80002de4:	ec4e                	sd	s3,24(sp)
        if (killed(myproc())) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    80002de6:	00013997          	auipc	s3,0x13
    80002dea:	dc298993          	addi	s3,s3,-574 # 80015ba8 <tickslock>
    80002dee:	00005497          	auipc	s1,0x5
    80002df2:	a8a48493          	addi	s1,s1,-1398 # 80007878 <ticks>
        if (killed(myproc())) {
    80002df6:	ac9fe0ef          	jal	800018be <myproc>
    80002dfa:	bceff0ef          	jal	800021c8 <killed>
    80002dfe:	ed0d                	bnez	a0,80002e38 <sys_pause+0x8c>
        sleep(&ticks, &tickslock);
    80002e00:	85ce                	mv	a1,s3
    80002e02:	8526                	mv	a0,s1
    80002e04:	924ff0ef          	jal	80001f28 <sleep>
    while (ticks - ticks0 < n) {
    80002e08:	409c                	lw	a5,0(s1)
    80002e0a:	412787bb          	subw	a5,a5,s2
    80002e0e:	fcc42703          	lw	a4,-52(s0)
    80002e12:	fee7e2e3          	bltu	a5,a4,80002df6 <sys_pause+0x4a>
    80002e16:	74a2                	ld	s1,40(sp)
    80002e18:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    80002e1a:	00013517          	auipc	a0,0x13
    80002e1e:	d8e50513          	addi	a0,a0,-626 # 80015ba8 <tickslock>
    80002e22:	e3ffd0ef          	jal	80000c60 <release>
    return 0;
    80002e26:	4501                	li	a0,0
}
    80002e28:	70e2                	ld	ra,56(sp)
    80002e2a:	7442                	ld	s0,48(sp)
    80002e2c:	7902                	ld	s2,32(sp)
    80002e2e:	6121                	addi	sp,sp,64
    80002e30:	8082                	ret
        n = 0;
    80002e32:	fc042623          	sw	zero,-52(s0)
    80002e36:	bf49                	j	80002dc8 <sys_pause+0x1c>
            release(&tickslock);
    80002e38:	00013517          	auipc	a0,0x13
    80002e3c:	d7050513          	addi	a0,a0,-656 # 80015ba8 <tickslock>
    80002e40:	e21fd0ef          	jal	80000c60 <release>
            return -1;
    80002e44:	557d                	li	a0,-1
    80002e46:	74a2                	ld	s1,40(sp)
    80002e48:	69e2                	ld	s3,24(sp)
    80002e4a:	bff9                	j	80002e28 <sys_pause+0x7c>

0000000080002e4c <sys_kill>:

uint64 sys_kill(void)
{
    80002e4c:	1101                	addi	sp,sp,-32
    80002e4e:	ec06                	sd	ra,24(sp)
    80002e50:	e822                	sd	s0,16(sp)
    80002e52:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    80002e54:	fec40593          	addi	a1,s0,-20
    80002e58:	4501                	li	a0,0
    80002e5a:	d89ff0ef          	jal	80002be2 <argint>
    return kkill(pid);
    80002e5e:	fec42503          	lw	a0,-20(s0)
    80002e62:	adcff0ef          	jal	8000213e <kkill>
}
    80002e66:	60e2                	ld	ra,24(sp)
    80002e68:	6442                	ld	s0,16(sp)
    80002e6a:	6105                	addi	sp,sp,32
    80002e6c:	8082                	ret

0000000080002e6e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void)
{
    80002e6e:	1101                	addi	sp,sp,-32
    80002e70:	ec06                	sd	ra,24(sp)
    80002e72:	e822                	sd	s0,16(sp)
    80002e74:	e426                	sd	s1,8(sp)
    80002e76:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    80002e78:	00013517          	auipc	a0,0x13
    80002e7c:	d3050513          	addi	a0,a0,-720 # 80015ba8 <tickslock>
    80002e80:	d4dfd0ef          	jal	80000bcc <acquire>
    xticks = ticks;
    80002e84:	00005497          	auipc	s1,0x5
    80002e88:	9f44a483          	lw	s1,-1548(s1) # 80007878 <ticks>
    release(&tickslock);
    80002e8c:	00013517          	auipc	a0,0x13
    80002e90:	d1c50513          	addi	a0,a0,-740 # 80015ba8 <tickslock>
    80002e94:	dcdfd0ef          	jal	80000c60 <release>
    return xticks;
}
    80002e98:	02049513          	slli	a0,s1,0x20
    80002e9c:	9101                	srli	a0,a0,0x20
    80002e9e:	60e2                	ld	ra,24(sp)
    80002ea0:	6442                	ld	s0,16(sp)
    80002ea2:	64a2                	ld	s1,8(sp)
    80002ea4:	6105                	addi	sp,sp,32
    80002ea6:	8082                	ret

0000000080002ea8 <sys_clone>:

uint64 sys_clone(void)
{
    80002ea8:	7179                	addi	sp,sp,-48
    80002eaa:	f406                	sd	ra,40(sp)
    80002eac:	f022                	sd	s0,32(sp)
    80002eae:	1800                	addi	s0,sp,48
    uint64 fn;
    uint64 arg;
    uint64 stack;

    argaddr(0, &fn);
    80002eb0:	fe840593          	addi	a1,s0,-24
    80002eb4:	4501                	li	a0,0
    80002eb6:	d49ff0ef          	jal	80002bfe <argaddr>
    argaddr(1, &arg);
    80002eba:	fe040593          	addi	a1,s0,-32
    80002ebe:	4505                	li	a0,1
    80002ec0:	d3fff0ef          	jal	80002bfe <argaddr>
    argaddr(2, &stack);
    80002ec4:	fd840593          	addi	a1,s0,-40
    80002ec8:	4509                	li	a0,2
    80002eca:	d35ff0ef          	jal	80002bfe <argaddr>

    return clone(fn, arg, stack);
    80002ece:	fd843603          	ld	a2,-40(s0)
    80002ed2:	fe043583          	ld	a1,-32(s0)
    80002ed6:	fe843503          	ld	a0,-24(s0)
    80002eda:	e18ff0ef          	jal	800024f2 <clone>
}
    80002ede:	70a2                	ld	ra,40(sp)
    80002ee0:	7402                	ld	s0,32(sp)
    80002ee2:	6145                	addi	sp,sp,48
    80002ee4:	8082                	ret

0000000080002ee6 <sys_join>:

uint64 sys_join(void)
{
    80002ee6:	1141                	addi	sp,sp,-16
    80002ee8:	e406                	sd	ra,8(sp)
    80002eea:	e022                	sd	s0,0(sp)
    80002eec:	0800                	addi	s0,sp,16
    return join();
    80002eee:	f6eff0ef          	jal	8000265c <join>
}
    80002ef2:	60a2                	ld	ra,8(sp)
    80002ef4:	6402                	ld	s0,0(sp)
    80002ef6:	0141                	addi	sp,sp,16
    80002ef8:	8082                	ret

0000000080002efa <sys_futex_wait>:

uint64 sys_futex_wait(void) {
    80002efa:	7179                	addi	sp,sp,-48
    80002efc:	f406                	sd	ra,40(sp)
    80002efe:	f022                	sd	s0,32(sp)
    80002f00:	ec26                	sd	s1,24(sp)
    80002f02:	1800                	addi	s0,sp,48
    uint64 uaddr; int val;
    argaddr(0, &uaddr);
    80002f04:	fd840593          	addi	a1,s0,-40
    80002f08:	4501                	li	a0,0
    80002f0a:	cf5ff0ef          	jal	80002bfe <argaddr>
    argint(1, &val);
    80002f0e:	fd440593          	addi	a1,s0,-44
    80002f12:	4505                	li	a0,1
    80002f14:	ccfff0ef          	jal	80002be2 <argint>
    struct proc *p = myproc();
    80002f18:	9a7fe0ef          	jal	800018be <myproc>
    80002f1c:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002f1e:	caffd0ef          	jal	80000bcc <acquire>
    p->chan = (int*) uaddr;
    80002f22:	fd843783          	ld	a5,-40(s0)
    80002f26:	f09c                	sd	a5,32(s1)
    p->state = SLEEPING;
    80002f28:	4789                	li	a5,2
    80002f2a:	cc9c                	sw	a5,24(s1)
    sched();
    80002f2c:	f17fe0ef          	jal	80001e42 <sched>
    p->chan = 0;
    80002f30:	0204b023          	sd	zero,32(s1)
    release(&p->lock);
    80002f34:	8526                	mv	a0,s1
    80002f36:	d2bfd0ef          	jal	80000c60 <release>
    return 0;
}
    80002f3a:	4501                	li	a0,0
    80002f3c:	70a2                	ld	ra,40(sp)
    80002f3e:	7402                	ld	s0,32(sp)
    80002f40:	64e2                	ld	s1,24(sp)
    80002f42:	6145                	addi	sp,sp,48
    80002f44:	8082                	ret

0000000080002f46 <sys_futex_wake>:

uint64 sys_futex_wake(void) {
    80002f46:	7139                	addi	sp,sp,-64
    80002f48:	fc06                	sd	ra,56(sp)
    80002f4a:	f822                	sd	s0,48(sp)
    80002f4c:	f426                	sd	s1,40(sp)
    80002f4e:	f04a                	sd	s2,32(sp)
    80002f50:	ec4e                	sd	s3,24(sp)
    80002f52:	e852                	sd	s4,16(sp)
    80002f54:	0080                	addi	s0,sp,64
    uint64 uaddr;
    argaddr(0, &uaddr);
    80002f56:	fc840593          	addi	a1,s0,-56
    80002f5a:	4501                	li	a0,0
    80002f5c:	ca3ff0ef          	jal	80002bfe <argaddr>
    struct proc *p;
    extern struct proc proc[NPROC];
    for (p = proc; p < &proc[NPROC]; p++) {
    80002f60:	0000d497          	auipc	s1,0xd
    80002f64:	e4848493          	addi	s1,s1,-440 # 8000fda8 <proc>
        if (p != myproc()) {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == (int*)uaddr) {
    80002f68:	4989                	li	s3,2
                p->state = RUNNABLE;
    80002f6a:	4a0d                	li	s4,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80002f6c:	00013917          	auipc	s2,0x13
    80002f70:	c3c90913          	addi	s2,s2,-964 # 80015ba8 <tickslock>
    80002f74:	a801                	j	80002f84 <sys_futex_wake+0x3e>
            }
            release(&p->lock);
    80002f76:	8526                	mv	a0,s1
    80002f78:	ce9fd0ef          	jal	80000c60 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80002f7c:	17848493          	addi	s1,s1,376
    80002f80:	03248463          	beq	s1,s2,80002fa8 <sys_futex_wake+0x62>
        if (p != myproc()) {
    80002f84:	93bfe0ef          	jal	800018be <myproc>
    80002f88:	fea48ae3          	beq	s1,a0,80002f7c <sys_futex_wake+0x36>
            acquire(&p->lock);
    80002f8c:	8526                	mv	a0,s1
    80002f8e:	c3ffd0ef          	jal	80000bcc <acquire>
            if (p->state == SLEEPING && p->chan == (int*)uaddr) {
    80002f92:	4c9c                	lw	a5,24(s1)
    80002f94:	ff3791e3          	bne	a5,s3,80002f76 <sys_futex_wake+0x30>
    80002f98:	7098                	ld	a4,32(s1)
    80002f9a:	fc843783          	ld	a5,-56(s0)
    80002f9e:	fcf71ce3          	bne	a4,a5,80002f76 <sys_futex_wake+0x30>
                p->state = RUNNABLE;
    80002fa2:	0144ac23          	sw	s4,24(s1)
    80002fa6:	bfc1                	j	80002f76 <sys_futex_wake+0x30>
        }
    }
    return 0;
}
    80002fa8:	4501                	li	a0,0
    80002faa:	70e2                	ld	ra,56(sp)
    80002fac:	7442                	ld	s0,48(sp)
    80002fae:	74a2                	ld	s1,40(sp)
    80002fb0:	7902                	ld	s2,32(sp)
    80002fb2:	69e2                	ld	s3,24(sp)
    80002fb4:	6a42                	ld	s4,16(sp)
    80002fb6:	6121                	addi	sp,sp,64
    80002fb8:	8082                	ret

0000000080002fba <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002fba:	7179                	addi	sp,sp,-48
    80002fbc:	f406                	sd	ra,40(sp)
    80002fbe:	f022                	sd	s0,32(sp)
    80002fc0:	ec26                	sd	s1,24(sp)
    80002fc2:	e84a                	sd	s2,16(sp)
    80002fc4:	e44e                	sd	s3,8(sp)
    80002fc6:	e052                	sd	s4,0(sp)
    80002fc8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002fca:	00004597          	auipc	a1,0x4
    80002fce:	3c658593          	addi	a1,a1,966 # 80007390 <etext+0x390>
    80002fd2:	00013517          	auipc	a0,0x13
    80002fd6:	bee50513          	addi	a0,a0,-1042 # 80015bc0 <bcache>
    80002fda:	b6ffd0ef          	jal	80000b48 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002fde:	0001b797          	auipc	a5,0x1b
    80002fe2:	be278793          	addi	a5,a5,-1054 # 8001dbc0 <bcache+0x8000>
    80002fe6:	0001b717          	auipc	a4,0x1b
    80002fea:	e4270713          	addi	a4,a4,-446 # 8001de28 <bcache+0x8268>
    80002fee:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002ff2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ff6:	00013497          	auipc	s1,0x13
    80002ffa:	be248493          	addi	s1,s1,-1054 # 80015bd8 <bcache+0x18>
    b->next = bcache.head.next;
    80002ffe:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003000:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003002:	00004a17          	auipc	s4,0x4
    80003006:	396a0a13          	addi	s4,s4,918 # 80007398 <etext+0x398>
    b->next = bcache.head.next;
    8000300a:	2b893783          	ld	a5,696(s2)
    8000300e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003010:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003014:	85d2                	mv	a1,s4
    80003016:	01048513          	addi	a0,s1,16
    8000301a:	31c010ef          	jal	80004336 <initsleeplock>
    bcache.head.next->prev = b;
    8000301e:	2b893783          	ld	a5,696(s2)
    80003022:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003024:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003028:	45848493          	addi	s1,s1,1112
    8000302c:	fd349fe3          	bne	s1,s3,8000300a <binit+0x50>
  }
}
    80003030:	70a2                	ld	ra,40(sp)
    80003032:	7402                	ld	s0,32(sp)
    80003034:	64e2                	ld	s1,24(sp)
    80003036:	6942                	ld	s2,16(sp)
    80003038:	69a2                	ld	s3,8(sp)
    8000303a:	6a02                	ld	s4,0(sp)
    8000303c:	6145                	addi	sp,sp,48
    8000303e:	8082                	ret

0000000080003040 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003040:	7179                	addi	sp,sp,-48
    80003042:	f406                	sd	ra,40(sp)
    80003044:	f022                	sd	s0,32(sp)
    80003046:	ec26                	sd	s1,24(sp)
    80003048:	e84a                	sd	s2,16(sp)
    8000304a:	e44e                	sd	s3,8(sp)
    8000304c:	1800                	addi	s0,sp,48
    8000304e:	892a                	mv	s2,a0
    80003050:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003052:	00013517          	auipc	a0,0x13
    80003056:	b6e50513          	addi	a0,a0,-1170 # 80015bc0 <bcache>
    8000305a:	b73fd0ef          	jal	80000bcc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000305e:	0001b497          	auipc	s1,0x1b
    80003062:	e1a4b483          	ld	s1,-486(s1) # 8001de78 <bcache+0x82b8>
    80003066:	0001b797          	auipc	a5,0x1b
    8000306a:	dc278793          	addi	a5,a5,-574 # 8001de28 <bcache+0x8268>
    8000306e:	02f48b63          	beq	s1,a5,800030a4 <bread+0x64>
    80003072:	873e                	mv	a4,a5
    80003074:	a021                	j	8000307c <bread+0x3c>
    80003076:	68a4                	ld	s1,80(s1)
    80003078:	02e48663          	beq	s1,a4,800030a4 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000307c:	449c                	lw	a5,8(s1)
    8000307e:	ff279ce3          	bne	a5,s2,80003076 <bread+0x36>
    80003082:	44dc                	lw	a5,12(s1)
    80003084:	ff3799e3          	bne	a5,s3,80003076 <bread+0x36>
      b->refcnt++;
    80003088:	40bc                	lw	a5,64(s1)
    8000308a:	2785                	addiw	a5,a5,1
    8000308c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000308e:	00013517          	auipc	a0,0x13
    80003092:	b3250513          	addi	a0,a0,-1230 # 80015bc0 <bcache>
    80003096:	bcbfd0ef          	jal	80000c60 <release>
      acquiresleep(&b->lock);
    8000309a:	01048513          	addi	a0,s1,16
    8000309e:	2ce010ef          	jal	8000436c <acquiresleep>
      return b;
    800030a2:	a889                	j	800030f4 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800030a4:	0001b497          	auipc	s1,0x1b
    800030a8:	dcc4b483          	ld	s1,-564(s1) # 8001de70 <bcache+0x82b0>
    800030ac:	0001b797          	auipc	a5,0x1b
    800030b0:	d7c78793          	addi	a5,a5,-644 # 8001de28 <bcache+0x8268>
    800030b4:	00f48863          	beq	s1,a5,800030c4 <bread+0x84>
    800030b8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800030ba:	40bc                	lw	a5,64(s1)
    800030bc:	cb91                	beqz	a5,800030d0 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800030be:	64a4                	ld	s1,72(s1)
    800030c0:	fee49de3          	bne	s1,a4,800030ba <bread+0x7a>
  panic("bget: no buffers");
    800030c4:	00004517          	auipc	a0,0x4
    800030c8:	2dc50513          	addi	a0,a0,732 # 800073a0 <etext+0x3a0>
    800030cc:	f12fd0ef          	jal	800007de <panic>
      b->dev = dev;
    800030d0:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800030d4:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800030d8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800030dc:	4785                	li	a5,1
    800030de:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800030e0:	00013517          	auipc	a0,0x13
    800030e4:	ae050513          	addi	a0,a0,-1312 # 80015bc0 <bcache>
    800030e8:	b79fd0ef          	jal	80000c60 <release>
      acquiresleep(&b->lock);
    800030ec:	01048513          	addi	a0,s1,16
    800030f0:	27c010ef          	jal	8000436c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800030f4:	409c                	lw	a5,0(s1)
    800030f6:	cb89                	beqz	a5,80003108 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800030f8:	8526                	mv	a0,s1
    800030fa:	70a2                	ld	ra,40(sp)
    800030fc:	7402                	ld	s0,32(sp)
    800030fe:	64e2                	ld	s1,24(sp)
    80003100:	6942                	ld	s2,16(sp)
    80003102:	69a2                	ld	s3,8(sp)
    80003104:	6145                	addi	sp,sp,48
    80003106:	8082                	ret
    virtio_disk_rw(b, 0);
    80003108:	4581                	li	a1,0
    8000310a:	8526                	mv	a0,s1
    8000310c:	375020ef          	jal	80005c80 <virtio_disk_rw>
    b->valid = 1;
    80003110:	4785                	li	a5,1
    80003112:	c09c                	sw	a5,0(s1)
  return b;
    80003114:	b7d5                	j	800030f8 <bread+0xb8>

0000000080003116 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003116:	1101                	addi	sp,sp,-32
    80003118:	ec06                	sd	ra,24(sp)
    8000311a:	e822                	sd	s0,16(sp)
    8000311c:	e426                	sd	s1,8(sp)
    8000311e:	1000                	addi	s0,sp,32
    80003120:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003122:	0541                	addi	a0,a0,16
    80003124:	2c6010ef          	jal	800043ea <holdingsleep>
    80003128:	c911                	beqz	a0,8000313c <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000312a:	4585                	li	a1,1
    8000312c:	8526                	mv	a0,s1
    8000312e:	353020ef          	jal	80005c80 <virtio_disk_rw>
}
    80003132:	60e2                	ld	ra,24(sp)
    80003134:	6442                	ld	s0,16(sp)
    80003136:	64a2                	ld	s1,8(sp)
    80003138:	6105                	addi	sp,sp,32
    8000313a:	8082                	ret
    panic("bwrite");
    8000313c:	00004517          	auipc	a0,0x4
    80003140:	27c50513          	addi	a0,a0,636 # 800073b8 <etext+0x3b8>
    80003144:	e9afd0ef          	jal	800007de <panic>

0000000080003148 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003148:	1101                	addi	sp,sp,-32
    8000314a:	ec06                	sd	ra,24(sp)
    8000314c:	e822                	sd	s0,16(sp)
    8000314e:	e426                	sd	s1,8(sp)
    80003150:	e04a                	sd	s2,0(sp)
    80003152:	1000                	addi	s0,sp,32
    80003154:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003156:	01050913          	addi	s2,a0,16
    8000315a:	854a                	mv	a0,s2
    8000315c:	28e010ef          	jal	800043ea <holdingsleep>
    80003160:	c125                	beqz	a0,800031c0 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80003162:	854a                	mv	a0,s2
    80003164:	24e010ef          	jal	800043b2 <releasesleep>

  acquire(&bcache.lock);
    80003168:	00013517          	auipc	a0,0x13
    8000316c:	a5850513          	addi	a0,a0,-1448 # 80015bc0 <bcache>
    80003170:	a5dfd0ef          	jal	80000bcc <acquire>
  b->refcnt--;
    80003174:	40bc                	lw	a5,64(s1)
    80003176:	37fd                	addiw	a5,a5,-1
    80003178:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000317a:	e79d                	bnez	a5,800031a8 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000317c:	68b8                	ld	a4,80(s1)
    8000317e:	64bc                	ld	a5,72(s1)
    80003180:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003182:	68b8                	ld	a4,80(s1)
    80003184:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003186:	0001b797          	auipc	a5,0x1b
    8000318a:	a3a78793          	addi	a5,a5,-1478 # 8001dbc0 <bcache+0x8000>
    8000318e:	2b87b703          	ld	a4,696(a5)
    80003192:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003194:	0001b717          	auipc	a4,0x1b
    80003198:	c9470713          	addi	a4,a4,-876 # 8001de28 <bcache+0x8268>
    8000319c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000319e:	2b87b703          	ld	a4,696(a5)
    800031a2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800031a4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800031a8:	00013517          	auipc	a0,0x13
    800031ac:	a1850513          	addi	a0,a0,-1512 # 80015bc0 <bcache>
    800031b0:	ab1fd0ef          	jal	80000c60 <release>
}
    800031b4:	60e2                	ld	ra,24(sp)
    800031b6:	6442                	ld	s0,16(sp)
    800031b8:	64a2                	ld	s1,8(sp)
    800031ba:	6902                	ld	s2,0(sp)
    800031bc:	6105                	addi	sp,sp,32
    800031be:	8082                	ret
    panic("brelse");
    800031c0:	00004517          	auipc	a0,0x4
    800031c4:	20050513          	addi	a0,a0,512 # 800073c0 <etext+0x3c0>
    800031c8:	e16fd0ef          	jal	800007de <panic>

00000000800031cc <bpin>:

void
bpin(struct buf *b) {
    800031cc:	1101                	addi	sp,sp,-32
    800031ce:	ec06                	sd	ra,24(sp)
    800031d0:	e822                	sd	s0,16(sp)
    800031d2:	e426                	sd	s1,8(sp)
    800031d4:	1000                	addi	s0,sp,32
    800031d6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800031d8:	00013517          	auipc	a0,0x13
    800031dc:	9e850513          	addi	a0,a0,-1560 # 80015bc0 <bcache>
    800031e0:	9edfd0ef          	jal	80000bcc <acquire>
  b->refcnt++;
    800031e4:	40bc                	lw	a5,64(s1)
    800031e6:	2785                	addiw	a5,a5,1
    800031e8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800031ea:	00013517          	auipc	a0,0x13
    800031ee:	9d650513          	addi	a0,a0,-1578 # 80015bc0 <bcache>
    800031f2:	a6ffd0ef          	jal	80000c60 <release>
}
    800031f6:	60e2                	ld	ra,24(sp)
    800031f8:	6442                	ld	s0,16(sp)
    800031fa:	64a2                	ld	s1,8(sp)
    800031fc:	6105                	addi	sp,sp,32
    800031fe:	8082                	ret

0000000080003200 <bunpin>:

void
bunpin(struct buf *b) {
    80003200:	1101                	addi	sp,sp,-32
    80003202:	ec06                	sd	ra,24(sp)
    80003204:	e822                	sd	s0,16(sp)
    80003206:	e426                	sd	s1,8(sp)
    80003208:	1000                	addi	s0,sp,32
    8000320a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000320c:	00013517          	auipc	a0,0x13
    80003210:	9b450513          	addi	a0,a0,-1612 # 80015bc0 <bcache>
    80003214:	9b9fd0ef          	jal	80000bcc <acquire>
  b->refcnt--;
    80003218:	40bc                	lw	a5,64(s1)
    8000321a:	37fd                	addiw	a5,a5,-1
    8000321c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000321e:	00013517          	auipc	a0,0x13
    80003222:	9a250513          	addi	a0,a0,-1630 # 80015bc0 <bcache>
    80003226:	a3bfd0ef          	jal	80000c60 <release>
}
    8000322a:	60e2                	ld	ra,24(sp)
    8000322c:	6442                	ld	s0,16(sp)
    8000322e:	64a2                	ld	s1,8(sp)
    80003230:	6105                	addi	sp,sp,32
    80003232:	8082                	ret

0000000080003234 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003234:	1101                	addi	sp,sp,-32
    80003236:	ec06                	sd	ra,24(sp)
    80003238:	e822                	sd	s0,16(sp)
    8000323a:	e426                	sd	s1,8(sp)
    8000323c:	e04a                	sd	s2,0(sp)
    8000323e:	1000                	addi	s0,sp,32
    80003240:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003242:	00d5d79b          	srliw	a5,a1,0xd
    80003246:	0001b597          	auipc	a1,0x1b
    8000324a:	0565a583          	lw	a1,86(a1) # 8001e29c <sb+0x1c>
    8000324e:	9dbd                	addw	a1,a1,a5
    80003250:	df1ff0ef          	jal	80003040 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003254:	0074f713          	andi	a4,s1,7
    80003258:	4785                	li	a5,1
    8000325a:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000325e:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003260:	90d9                	srli	s1,s1,0x36
    80003262:	00950733          	add	a4,a0,s1
    80003266:	05874703          	lbu	a4,88(a4)
    8000326a:	00e7f6b3          	and	a3,a5,a4
    8000326e:	c29d                	beqz	a3,80003294 <bfree+0x60>
    80003270:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003272:	94aa                	add	s1,s1,a0
    80003274:	fff7c793          	not	a5,a5
    80003278:	8f7d                	and	a4,a4,a5
    8000327a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000327e:	7f7000ef          	jal	80004274 <log_write>
  brelse(bp);
    80003282:	854a                	mv	a0,s2
    80003284:	ec5ff0ef          	jal	80003148 <brelse>
}
    80003288:	60e2                	ld	ra,24(sp)
    8000328a:	6442                	ld	s0,16(sp)
    8000328c:	64a2                	ld	s1,8(sp)
    8000328e:	6902                	ld	s2,0(sp)
    80003290:	6105                	addi	sp,sp,32
    80003292:	8082                	ret
    panic("freeing free block");
    80003294:	00004517          	auipc	a0,0x4
    80003298:	13450513          	addi	a0,a0,308 # 800073c8 <etext+0x3c8>
    8000329c:	d42fd0ef          	jal	800007de <panic>

00000000800032a0 <balloc>:
{
    800032a0:	715d                	addi	sp,sp,-80
    800032a2:	e486                	sd	ra,72(sp)
    800032a4:	e0a2                	sd	s0,64(sp)
    800032a6:	fc26                	sd	s1,56(sp)
    800032a8:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800032aa:	0001b797          	auipc	a5,0x1b
    800032ae:	fda7a783          	lw	a5,-38(a5) # 8001e284 <sb+0x4>
    800032b2:	0e078863          	beqz	a5,800033a2 <balloc+0x102>
    800032b6:	f84a                	sd	s2,48(sp)
    800032b8:	f44e                	sd	s3,40(sp)
    800032ba:	f052                	sd	s4,32(sp)
    800032bc:	ec56                	sd	s5,24(sp)
    800032be:	e85a                	sd	s6,16(sp)
    800032c0:	e45e                	sd	s7,8(sp)
    800032c2:	e062                	sd	s8,0(sp)
    800032c4:	8baa                	mv	s7,a0
    800032c6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800032c8:	0001bb17          	auipc	s6,0x1b
    800032cc:	fb8b0b13          	addi	s6,s6,-72 # 8001e280 <sb>
      m = 1 << (bi % 8);
    800032d0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032d2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800032d4:	6c09                	lui	s8,0x2
    800032d6:	a09d                	j	8000333c <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    800032d8:	97ca                	add	a5,a5,s2
    800032da:	8e55                	or	a2,a2,a3
    800032dc:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800032e0:	854a                	mv	a0,s2
    800032e2:	793000ef          	jal	80004274 <log_write>
        brelse(bp);
    800032e6:	854a                	mv	a0,s2
    800032e8:	e61ff0ef          	jal	80003148 <brelse>
  bp = bread(dev, bno);
    800032ec:	85a6                	mv	a1,s1
    800032ee:	855e                	mv	a0,s7
    800032f0:	d51ff0ef          	jal	80003040 <bread>
    800032f4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800032f6:	40000613          	li	a2,1024
    800032fa:	4581                	li	a1,0
    800032fc:	05850513          	addi	a0,a0,88
    80003300:	99dfd0ef          	jal	80000c9c <memset>
  log_write(bp);
    80003304:	854a                	mv	a0,s2
    80003306:	76f000ef          	jal	80004274 <log_write>
  brelse(bp);
    8000330a:	854a                	mv	a0,s2
    8000330c:	e3dff0ef          	jal	80003148 <brelse>
}
    80003310:	7942                	ld	s2,48(sp)
    80003312:	79a2                	ld	s3,40(sp)
    80003314:	7a02                	ld	s4,32(sp)
    80003316:	6ae2                	ld	s5,24(sp)
    80003318:	6b42                	ld	s6,16(sp)
    8000331a:	6ba2                	ld	s7,8(sp)
    8000331c:	6c02                	ld	s8,0(sp)
}
    8000331e:	8526                	mv	a0,s1
    80003320:	60a6                	ld	ra,72(sp)
    80003322:	6406                	ld	s0,64(sp)
    80003324:	74e2                	ld	s1,56(sp)
    80003326:	6161                	addi	sp,sp,80
    80003328:	8082                	ret
    brelse(bp);
    8000332a:	854a                	mv	a0,s2
    8000332c:	e1dff0ef          	jal	80003148 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003330:	015c0abb          	addw	s5,s8,s5
    80003334:	004b2783          	lw	a5,4(s6)
    80003338:	04fafe63          	bgeu	s5,a5,80003394 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    8000333c:	41fad79b          	sraiw	a5,s5,0x1f
    80003340:	0137d79b          	srliw	a5,a5,0x13
    80003344:	015787bb          	addw	a5,a5,s5
    80003348:	40d7d79b          	sraiw	a5,a5,0xd
    8000334c:	01cb2583          	lw	a1,28(s6)
    80003350:	9dbd                	addw	a1,a1,a5
    80003352:	855e                	mv	a0,s7
    80003354:	cedff0ef          	jal	80003040 <bread>
    80003358:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000335a:	004b2503          	lw	a0,4(s6)
    8000335e:	84d6                	mv	s1,s5
    80003360:	4701                	li	a4,0
    80003362:	fca4f4e3          	bgeu	s1,a0,8000332a <balloc+0x8a>
      m = 1 << (bi % 8);
    80003366:	00777693          	andi	a3,a4,7
    8000336a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000336e:	41f7579b          	sraiw	a5,a4,0x1f
    80003372:	01d7d79b          	srliw	a5,a5,0x1d
    80003376:	9fb9                	addw	a5,a5,a4
    80003378:	4037d79b          	sraiw	a5,a5,0x3
    8000337c:	00f90633          	add	a2,s2,a5
    80003380:	05864603          	lbu	a2,88(a2)
    80003384:	00c6f5b3          	and	a1,a3,a2
    80003388:	d9a1                	beqz	a1,800032d8 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000338a:	2705                	addiw	a4,a4,1
    8000338c:	2485                	addiw	s1,s1,1
    8000338e:	fd471ae3          	bne	a4,s4,80003362 <balloc+0xc2>
    80003392:	bf61                	j	8000332a <balloc+0x8a>
    80003394:	7942                	ld	s2,48(sp)
    80003396:	79a2                	ld	s3,40(sp)
    80003398:	7a02                	ld	s4,32(sp)
    8000339a:	6ae2                	ld	s5,24(sp)
    8000339c:	6b42                	ld	s6,16(sp)
    8000339e:	6ba2                	ld	s7,8(sp)
    800033a0:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800033a2:	00004517          	auipc	a0,0x4
    800033a6:	03e50513          	addi	a0,a0,62 # 800073e0 <etext+0x3e0>
    800033aa:	950fd0ef          	jal	800004fa <printf>
  return 0;
    800033ae:	4481                	li	s1,0
    800033b0:	b7bd                	j	8000331e <balloc+0x7e>

00000000800033b2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800033b2:	7179                	addi	sp,sp,-48
    800033b4:	f406                	sd	ra,40(sp)
    800033b6:	f022                	sd	s0,32(sp)
    800033b8:	ec26                	sd	s1,24(sp)
    800033ba:	e84a                	sd	s2,16(sp)
    800033bc:	e44e                	sd	s3,8(sp)
    800033be:	1800                	addi	s0,sp,48
    800033c0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800033c2:	47ad                	li	a5,11
    800033c4:	02b7e363          	bltu	a5,a1,800033ea <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    800033c8:	02059793          	slli	a5,a1,0x20
    800033cc:	01e7d593          	srli	a1,a5,0x1e
    800033d0:	00b504b3          	add	s1,a0,a1
    800033d4:	0504a903          	lw	s2,80(s1)
    800033d8:	06091363          	bnez	s2,8000343e <bmap+0x8c>
      addr = balloc(ip->dev);
    800033dc:	4108                	lw	a0,0(a0)
    800033de:	ec3ff0ef          	jal	800032a0 <balloc>
    800033e2:	892a                	mv	s2,a0
      if(addr == 0)
    800033e4:	cd29                	beqz	a0,8000343e <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    800033e6:	c8a8                	sw	a0,80(s1)
    800033e8:	a899                	j	8000343e <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    800033ea:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800033ee:	0ff00793          	li	a5,255
    800033f2:	0697e963          	bltu	a5,s1,80003464 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800033f6:	08052903          	lw	s2,128(a0)
    800033fa:	00091b63          	bnez	s2,80003410 <bmap+0x5e>
      addr = balloc(ip->dev);
    800033fe:	4108                	lw	a0,0(a0)
    80003400:	ea1ff0ef          	jal	800032a0 <balloc>
    80003404:	892a                	mv	s2,a0
      if(addr == 0)
    80003406:	cd05                	beqz	a0,8000343e <bmap+0x8c>
    80003408:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000340a:	08a9a023          	sw	a0,128(s3)
    8000340e:	a011                	j	80003412 <bmap+0x60>
    80003410:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003412:	85ca                	mv	a1,s2
    80003414:	0009a503          	lw	a0,0(s3)
    80003418:	c29ff0ef          	jal	80003040 <bread>
    8000341c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000341e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003422:	02049713          	slli	a4,s1,0x20
    80003426:	01e75593          	srli	a1,a4,0x1e
    8000342a:	00b784b3          	add	s1,a5,a1
    8000342e:	0004a903          	lw	s2,0(s1)
    80003432:	00090e63          	beqz	s2,8000344e <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003436:	8552                	mv	a0,s4
    80003438:	d11ff0ef          	jal	80003148 <brelse>
    return addr;
    8000343c:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000343e:	854a                	mv	a0,s2
    80003440:	70a2                	ld	ra,40(sp)
    80003442:	7402                	ld	s0,32(sp)
    80003444:	64e2                	ld	s1,24(sp)
    80003446:	6942                	ld	s2,16(sp)
    80003448:	69a2                	ld	s3,8(sp)
    8000344a:	6145                	addi	sp,sp,48
    8000344c:	8082                	ret
      addr = balloc(ip->dev);
    8000344e:	0009a503          	lw	a0,0(s3)
    80003452:	e4fff0ef          	jal	800032a0 <balloc>
    80003456:	892a                	mv	s2,a0
      if(addr){
    80003458:	dd79                	beqz	a0,80003436 <bmap+0x84>
        a[bn] = addr;
    8000345a:	c088                	sw	a0,0(s1)
        log_write(bp);
    8000345c:	8552                	mv	a0,s4
    8000345e:	617000ef          	jal	80004274 <log_write>
    80003462:	bfd1                	j	80003436 <bmap+0x84>
    80003464:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003466:	00004517          	auipc	a0,0x4
    8000346a:	f9250513          	addi	a0,a0,-110 # 800073f8 <etext+0x3f8>
    8000346e:	b70fd0ef          	jal	800007de <panic>

0000000080003472 <iget>:
{
    80003472:	7179                	addi	sp,sp,-48
    80003474:	f406                	sd	ra,40(sp)
    80003476:	f022                	sd	s0,32(sp)
    80003478:	ec26                	sd	s1,24(sp)
    8000347a:	e84a                	sd	s2,16(sp)
    8000347c:	e44e                	sd	s3,8(sp)
    8000347e:	e052                	sd	s4,0(sp)
    80003480:	1800                	addi	s0,sp,48
    80003482:	89aa                	mv	s3,a0
    80003484:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003486:	0001b517          	auipc	a0,0x1b
    8000348a:	e1a50513          	addi	a0,a0,-486 # 8001e2a0 <itable>
    8000348e:	f3efd0ef          	jal	80000bcc <acquire>
  empty = 0;
    80003492:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003494:	0001b497          	auipc	s1,0x1b
    80003498:	e2448493          	addi	s1,s1,-476 # 8001e2b8 <itable+0x18>
    8000349c:	0001d697          	auipc	a3,0x1d
    800034a0:	8ac68693          	addi	a3,a3,-1876 # 8001fd48 <log>
    800034a4:	a039                	j	800034b2 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034a6:	02090963          	beqz	s2,800034d8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800034aa:	08848493          	addi	s1,s1,136
    800034ae:	02d48863          	beq	s1,a3,800034de <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800034b2:	449c                	lw	a5,8(s1)
    800034b4:	fef059e3          	blez	a5,800034a6 <iget+0x34>
    800034b8:	4098                	lw	a4,0(s1)
    800034ba:	ff3716e3          	bne	a4,s3,800034a6 <iget+0x34>
    800034be:	40d8                	lw	a4,4(s1)
    800034c0:	ff4713e3          	bne	a4,s4,800034a6 <iget+0x34>
      ip->ref++;
    800034c4:	2785                	addiw	a5,a5,1
    800034c6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800034c8:	0001b517          	auipc	a0,0x1b
    800034cc:	dd850513          	addi	a0,a0,-552 # 8001e2a0 <itable>
    800034d0:	f90fd0ef          	jal	80000c60 <release>
      return ip;
    800034d4:	8926                	mv	s2,s1
    800034d6:	a02d                	j	80003500 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034d8:	fbe9                	bnez	a5,800034aa <iget+0x38>
      empty = ip;
    800034da:	8926                	mv	s2,s1
    800034dc:	b7f9                	j	800034aa <iget+0x38>
  if(empty == 0)
    800034de:	02090a63          	beqz	s2,80003512 <iget+0xa0>
  ip->dev = dev;
    800034e2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800034e6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800034ea:	4785                	li	a5,1
    800034ec:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800034f0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800034f4:	0001b517          	auipc	a0,0x1b
    800034f8:	dac50513          	addi	a0,a0,-596 # 8001e2a0 <itable>
    800034fc:	f64fd0ef          	jal	80000c60 <release>
}
    80003500:	854a                	mv	a0,s2
    80003502:	70a2                	ld	ra,40(sp)
    80003504:	7402                	ld	s0,32(sp)
    80003506:	64e2                	ld	s1,24(sp)
    80003508:	6942                	ld	s2,16(sp)
    8000350a:	69a2                	ld	s3,8(sp)
    8000350c:	6a02                	ld	s4,0(sp)
    8000350e:	6145                	addi	sp,sp,48
    80003510:	8082                	ret
    panic("iget: no inodes");
    80003512:	00004517          	auipc	a0,0x4
    80003516:	efe50513          	addi	a0,a0,-258 # 80007410 <etext+0x410>
    8000351a:	ac4fd0ef          	jal	800007de <panic>

000000008000351e <iinit>:
{
    8000351e:	7179                	addi	sp,sp,-48
    80003520:	f406                	sd	ra,40(sp)
    80003522:	f022                	sd	s0,32(sp)
    80003524:	ec26                	sd	s1,24(sp)
    80003526:	e84a                	sd	s2,16(sp)
    80003528:	e44e                	sd	s3,8(sp)
    8000352a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000352c:	00004597          	auipc	a1,0x4
    80003530:	ef458593          	addi	a1,a1,-268 # 80007420 <etext+0x420>
    80003534:	0001b517          	auipc	a0,0x1b
    80003538:	d6c50513          	addi	a0,a0,-660 # 8001e2a0 <itable>
    8000353c:	e0cfd0ef          	jal	80000b48 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003540:	0001b497          	auipc	s1,0x1b
    80003544:	d8848493          	addi	s1,s1,-632 # 8001e2c8 <itable+0x28>
    80003548:	0001d997          	auipc	s3,0x1d
    8000354c:	81098993          	addi	s3,s3,-2032 # 8001fd58 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003550:	00004917          	auipc	s2,0x4
    80003554:	ed890913          	addi	s2,s2,-296 # 80007428 <etext+0x428>
    80003558:	85ca                	mv	a1,s2
    8000355a:	8526                	mv	a0,s1
    8000355c:	5db000ef          	jal	80004336 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003560:	08848493          	addi	s1,s1,136
    80003564:	ff349ae3          	bne	s1,s3,80003558 <iinit+0x3a>
}
    80003568:	70a2                	ld	ra,40(sp)
    8000356a:	7402                	ld	s0,32(sp)
    8000356c:	64e2                	ld	s1,24(sp)
    8000356e:	6942                	ld	s2,16(sp)
    80003570:	69a2                	ld	s3,8(sp)
    80003572:	6145                	addi	sp,sp,48
    80003574:	8082                	ret

0000000080003576 <ialloc>:
{
    80003576:	7139                	addi	sp,sp,-64
    80003578:	fc06                	sd	ra,56(sp)
    8000357a:	f822                	sd	s0,48(sp)
    8000357c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000357e:	0001b717          	auipc	a4,0x1b
    80003582:	d0e72703          	lw	a4,-754(a4) # 8001e28c <sb+0xc>
    80003586:	4785                	li	a5,1
    80003588:	06e7f063          	bgeu	a5,a4,800035e8 <ialloc+0x72>
    8000358c:	f426                	sd	s1,40(sp)
    8000358e:	f04a                	sd	s2,32(sp)
    80003590:	ec4e                	sd	s3,24(sp)
    80003592:	e852                	sd	s4,16(sp)
    80003594:	e456                	sd	s5,8(sp)
    80003596:	e05a                	sd	s6,0(sp)
    80003598:	8aaa                	mv	s5,a0
    8000359a:	8b2e                	mv	s6,a1
    8000359c:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    8000359e:	0001ba17          	auipc	s4,0x1b
    800035a2:	ce2a0a13          	addi	s4,s4,-798 # 8001e280 <sb>
    800035a6:	00495593          	srli	a1,s2,0x4
    800035aa:	018a2783          	lw	a5,24(s4)
    800035ae:	9dbd                	addw	a1,a1,a5
    800035b0:	8556                	mv	a0,s5
    800035b2:	a8fff0ef          	jal	80003040 <bread>
    800035b6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800035b8:	05850993          	addi	s3,a0,88
    800035bc:	00f97793          	andi	a5,s2,15
    800035c0:	079a                	slli	a5,a5,0x6
    800035c2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800035c4:	00099783          	lh	a5,0(s3)
    800035c8:	cb9d                	beqz	a5,800035fe <ialloc+0x88>
    brelse(bp);
    800035ca:	b7fff0ef          	jal	80003148 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800035ce:	0905                	addi	s2,s2,1
    800035d0:	00ca2703          	lw	a4,12(s4)
    800035d4:	0009079b          	sext.w	a5,s2
    800035d8:	fce7e7e3          	bltu	a5,a4,800035a6 <ialloc+0x30>
    800035dc:	74a2                	ld	s1,40(sp)
    800035de:	7902                	ld	s2,32(sp)
    800035e0:	69e2                	ld	s3,24(sp)
    800035e2:	6a42                	ld	s4,16(sp)
    800035e4:	6aa2                	ld	s5,8(sp)
    800035e6:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800035e8:	00004517          	auipc	a0,0x4
    800035ec:	e4850513          	addi	a0,a0,-440 # 80007430 <etext+0x430>
    800035f0:	f0bfc0ef          	jal	800004fa <printf>
  return 0;
    800035f4:	4501                	li	a0,0
}
    800035f6:	70e2                	ld	ra,56(sp)
    800035f8:	7442                	ld	s0,48(sp)
    800035fa:	6121                	addi	sp,sp,64
    800035fc:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800035fe:	04000613          	li	a2,64
    80003602:	4581                	li	a1,0
    80003604:	854e                	mv	a0,s3
    80003606:	e96fd0ef          	jal	80000c9c <memset>
      dip->type = type;
    8000360a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000360e:	8526                	mv	a0,s1
    80003610:	465000ef          	jal	80004274 <log_write>
      brelse(bp);
    80003614:	8526                	mv	a0,s1
    80003616:	b33ff0ef          	jal	80003148 <brelse>
      return iget(dev, inum);
    8000361a:	0009059b          	sext.w	a1,s2
    8000361e:	8556                	mv	a0,s5
    80003620:	e53ff0ef          	jal	80003472 <iget>
    80003624:	74a2                	ld	s1,40(sp)
    80003626:	7902                	ld	s2,32(sp)
    80003628:	69e2                	ld	s3,24(sp)
    8000362a:	6a42                	ld	s4,16(sp)
    8000362c:	6aa2                	ld	s5,8(sp)
    8000362e:	6b02                	ld	s6,0(sp)
    80003630:	b7d9                	j	800035f6 <ialloc+0x80>

0000000080003632 <iupdate>:
{
    80003632:	1101                	addi	sp,sp,-32
    80003634:	ec06                	sd	ra,24(sp)
    80003636:	e822                	sd	s0,16(sp)
    80003638:	e426                	sd	s1,8(sp)
    8000363a:	e04a                	sd	s2,0(sp)
    8000363c:	1000                	addi	s0,sp,32
    8000363e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003640:	415c                	lw	a5,4(a0)
    80003642:	0047d79b          	srliw	a5,a5,0x4
    80003646:	0001b597          	auipc	a1,0x1b
    8000364a:	c525a583          	lw	a1,-942(a1) # 8001e298 <sb+0x18>
    8000364e:	9dbd                	addw	a1,a1,a5
    80003650:	4108                	lw	a0,0(a0)
    80003652:	9efff0ef          	jal	80003040 <bread>
    80003656:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003658:	05850793          	addi	a5,a0,88
    8000365c:	40d8                	lw	a4,4(s1)
    8000365e:	8b3d                	andi	a4,a4,15
    80003660:	071a                	slli	a4,a4,0x6
    80003662:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003664:	04449703          	lh	a4,68(s1)
    80003668:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000366c:	04649703          	lh	a4,70(s1)
    80003670:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003674:	04849703          	lh	a4,72(s1)
    80003678:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000367c:	04a49703          	lh	a4,74(s1)
    80003680:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003684:	44f8                	lw	a4,76(s1)
    80003686:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003688:	03400613          	li	a2,52
    8000368c:	05048593          	addi	a1,s1,80
    80003690:	00c78513          	addi	a0,a5,12
    80003694:	e6cfd0ef          	jal	80000d00 <memmove>
  log_write(bp);
    80003698:	854a                	mv	a0,s2
    8000369a:	3db000ef          	jal	80004274 <log_write>
  brelse(bp);
    8000369e:	854a                	mv	a0,s2
    800036a0:	aa9ff0ef          	jal	80003148 <brelse>
}
    800036a4:	60e2                	ld	ra,24(sp)
    800036a6:	6442                	ld	s0,16(sp)
    800036a8:	64a2                	ld	s1,8(sp)
    800036aa:	6902                	ld	s2,0(sp)
    800036ac:	6105                	addi	sp,sp,32
    800036ae:	8082                	ret

00000000800036b0 <idup>:
{
    800036b0:	1101                	addi	sp,sp,-32
    800036b2:	ec06                	sd	ra,24(sp)
    800036b4:	e822                	sd	s0,16(sp)
    800036b6:	e426                	sd	s1,8(sp)
    800036b8:	1000                	addi	s0,sp,32
    800036ba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800036bc:	0001b517          	auipc	a0,0x1b
    800036c0:	be450513          	addi	a0,a0,-1052 # 8001e2a0 <itable>
    800036c4:	d08fd0ef          	jal	80000bcc <acquire>
  ip->ref++;
    800036c8:	449c                	lw	a5,8(s1)
    800036ca:	2785                	addiw	a5,a5,1
    800036cc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800036ce:	0001b517          	auipc	a0,0x1b
    800036d2:	bd250513          	addi	a0,a0,-1070 # 8001e2a0 <itable>
    800036d6:	d8afd0ef          	jal	80000c60 <release>
}
    800036da:	8526                	mv	a0,s1
    800036dc:	60e2                	ld	ra,24(sp)
    800036de:	6442                	ld	s0,16(sp)
    800036e0:	64a2                	ld	s1,8(sp)
    800036e2:	6105                	addi	sp,sp,32
    800036e4:	8082                	ret

00000000800036e6 <ilock>:
{
    800036e6:	1101                	addi	sp,sp,-32
    800036e8:	ec06                	sd	ra,24(sp)
    800036ea:	e822                	sd	s0,16(sp)
    800036ec:	e426                	sd	s1,8(sp)
    800036ee:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800036f0:	cd19                	beqz	a0,8000370e <ilock+0x28>
    800036f2:	84aa                	mv	s1,a0
    800036f4:	451c                	lw	a5,8(a0)
    800036f6:	00f05c63          	blez	a5,8000370e <ilock+0x28>
  acquiresleep(&ip->lock);
    800036fa:	0541                	addi	a0,a0,16
    800036fc:	471000ef          	jal	8000436c <acquiresleep>
  if(ip->valid == 0){
    80003700:	40bc                	lw	a5,64(s1)
    80003702:	cf89                	beqz	a5,8000371c <ilock+0x36>
}
    80003704:	60e2                	ld	ra,24(sp)
    80003706:	6442                	ld	s0,16(sp)
    80003708:	64a2                	ld	s1,8(sp)
    8000370a:	6105                	addi	sp,sp,32
    8000370c:	8082                	ret
    8000370e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003710:	00004517          	auipc	a0,0x4
    80003714:	d3850513          	addi	a0,a0,-712 # 80007448 <etext+0x448>
    80003718:	8c6fd0ef          	jal	800007de <panic>
    8000371c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000371e:	40dc                	lw	a5,4(s1)
    80003720:	0047d79b          	srliw	a5,a5,0x4
    80003724:	0001b597          	auipc	a1,0x1b
    80003728:	b745a583          	lw	a1,-1164(a1) # 8001e298 <sb+0x18>
    8000372c:	9dbd                	addw	a1,a1,a5
    8000372e:	4088                	lw	a0,0(s1)
    80003730:	911ff0ef          	jal	80003040 <bread>
    80003734:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003736:	05850593          	addi	a1,a0,88
    8000373a:	40dc                	lw	a5,4(s1)
    8000373c:	8bbd                	andi	a5,a5,15
    8000373e:	079a                	slli	a5,a5,0x6
    80003740:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003742:	00059783          	lh	a5,0(a1)
    80003746:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000374a:	00259783          	lh	a5,2(a1)
    8000374e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003752:	00459783          	lh	a5,4(a1)
    80003756:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000375a:	00659783          	lh	a5,6(a1)
    8000375e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003762:	459c                	lw	a5,8(a1)
    80003764:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003766:	03400613          	li	a2,52
    8000376a:	05b1                	addi	a1,a1,12
    8000376c:	05048513          	addi	a0,s1,80
    80003770:	d90fd0ef          	jal	80000d00 <memmove>
    brelse(bp);
    80003774:	854a                	mv	a0,s2
    80003776:	9d3ff0ef          	jal	80003148 <brelse>
    ip->valid = 1;
    8000377a:	4785                	li	a5,1
    8000377c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000377e:	04449783          	lh	a5,68(s1)
    80003782:	c399                	beqz	a5,80003788 <ilock+0xa2>
    80003784:	6902                	ld	s2,0(sp)
    80003786:	bfbd                	j	80003704 <ilock+0x1e>
      panic("ilock: no type");
    80003788:	00004517          	auipc	a0,0x4
    8000378c:	cc850513          	addi	a0,a0,-824 # 80007450 <etext+0x450>
    80003790:	84efd0ef          	jal	800007de <panic>

0000000080003794 <iunlock>:
{
    80003794:	1101                	addi	sp,sp,-32
    80003796:	ec06                	sd	ra,24(sp)
    80003798:	e822                	sd	s0,16(sp)
    8000379a:	e426                	sd	s1,8(sp)
    8000379c:	e04a                	sd	s2,0(sp)
    8000379e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800037a0:	c505                	beqz	a0,800037c8 <iunlock+0x34>
    800037a2:	84aa                	mv	s1,a0
    800037a4:	01050913          	addi	s2,a0,16
    800037a8:	854a                	mv	a0,s2
    800037aa:	441000ef          	jal	800043ea <holdingsleep>
    800037ae:	cd09                	beqz	a0,800037c8 <iunlock+0x34>
    800037b0:	449c                	lw	a5,8(s1)
    800037b2:	00f05b63          	blez	a5,800037c8 <iunlock+0x34>
  releasesleep(&ip->lock);
    800037b6:	854a                	mv	a0,s2
    800037b8:	3fb000ef          	jal	800043b2 <releasesleep>
}
    800037bc:	60e2                	ld	ra,24(sp)
    800037be:	6442                	ld	s0,16(sp)
    800037c0:	64a2                	ld	s1,8(sp)
    800037c2:	6902                	ld	s2,0(sp)
    800037c4:	6105                	addi	sp,sp,32
    800037c6:	8082                	ret
    panic("iunlock");
    800037c8:	00004517          	auipc	a0,0x4
    800037cc:	c9850513          	addi	a0,a0,-872 # 80007460 <etext+0x460>
    800037d0:	80efd0ef          	jal	800007de <panic>

00000000800037d4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800037d4:	7179                	addi	sp,sp,-48
    800037d6:	f406                	sd	ra,40(sp)
    800037d8:	f022                	sd	s0,32(sp)
    800037da:	ec26                	sd	s1,24(sp)
    800037dc:	e84a                	sd	s2,16(sp)
    800037de:	e44e                	sd	s3,8(sp)
    800037e0:	1800                	addi	s0,sp,48
    800037e2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800037e4:	05050493          	addi	s1,a0,80
    800037e8:	08050913          	addi	s2,a0,128
    800037ec:	a021                	j	800037f4 <itrunc+0x20>
    800037ee:	0491                	addi	s1,s1,4
    800037f0:	01248b63          	beq	s1,s2,80003806 <itrunc+0x32>
    if(ip->addrs[i]){
    800037f4:	408c                	lw	a1,0(s1)
    800037f6:	dde5                	beqz	a1,800037ee <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800037f8:	0009a503          	lw	a0,0(s3)
    800037fc:	a39ff0ef          	jal	80003234 <bfree>
      ip->addrs[i] = 0;
    80003800:	0004a023          	sw	zero,0(s1)
    80003804:	b7ed                	j	800037ee <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003806:	0809a583          	lw	a1,128(s3)
    8000380a:	ed89                	bnez	a1,80003824 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000380c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003810:	854e                	mv	a0,s3
    80003812:	e21ff0ef          	jal	80003632 <iupdate>
}
    80003816:	70a2                	ld	ra,40(sp)
    80003818:	7402                	ld	s0,32(sp)
    8000381a:	64e2                	ld	s1,24(sp)
    8000381c:	6942                	ld	s2,16(sp)
    8000381e:	69a2                	ld	s3,8(sp)
    80003820:	6145                	addi	sp,sp,48
    80003822:	8082                	ret
    80003824:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003826:	0009a503          	lw	a0,0(s3)
    8000382a:	817ff0ef          	jal	80003040 <bread>
    8000382e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003830:	05850493          	addi	s1,a0,88
    80003834:	45850913          	addi	s2,a0,1112
    80003838:	a021                	j	80003840 <itrunc+0x6c>
    8000383a:	0491                	addi	s1,s1,4
    8000383c:	01248963          	beq	s1,s2,8000384e <itrunc+0x7a>
      if(a[j])
    80003840:	408c                	lw	a1,0(s1)
    80003842:	dde5                	beqz	a1,8000383a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003844:	0009a503          	lw	a0,0(s3)
    80003848:	9edff0ef          	jal	80003234 <bfree>
    8000384c:	b7fd                	j	8000383a <itrunc+0x66>
    brelse(bp);
    8000384e:	8552                	mv	a0,s4
    80003850:	8f9ff0ef          	jal	80003148 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003854:	0809a583          	lw	a1,128(s3)
    80003858:	0009a503          	lw	a0,0(s3)
    8000385c:	9d9ff0ef          	jal	80003234 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003860:	0809a023          	sw	zero,128(s3)
    80003864:	6a02                	ld	s4,0(sp)
    80003866:	b75d                	j	8000380c <itrunc+0x38>

0000000080003868 <iput>:
{
    80003868:	1101                	addi	sp,sp,-32
    8000386a:	ec06                	sd	ra,24(sp)
    8000386c:	e822                	sd	s0,16(sp)
    8000386e:	e426                	sd	s1,8(sp)
    80003870:	1000                	addi	s0,sp,32
    80003872:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003874:	0001b517          	auipc	a0,0x1b
    80003878:	a2c50513          	addi	a0,a0,-1492 # 8001e2a0 <itable>
    8000387c:	b50fd0ef          	jal	80000bcc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003880:	4498                	lw	a4,8(s1)
    80003882:	4785                	li	a5,1
    80003884:	02f70063          	beq	a4,a5,800038a4 <iput+0x3c>
  ip->ref--;
    80003888:	449c                	lw	a5,8(s1)
    8000388a:	37fd                	addiw	a5,a5,-1
    8000388c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000388e:	0001b517          	auipc	a0,0x1b
    80003892:	a1250513          	addi	a0,a0,-1518 # 8001e2a0 <itable>
    80003896:	bcafd0ef          	jal	80000c60 <release>
}
    8000389a:	60e2                	ld	ra,24(sp)
    8000389c:	6442                	ld	s0,16(sp)
    8000389e:	64a2                	ld	s1,8(sp)
    800038a0:	6105                	addi	sp,sp,32
    800038a2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800038a4:	40bc                	lw	a5,64(s1)
    800038a6:	d3ed                	beqz	a5,80003888 <iput+0x20>
    800038a8:	04a49783          	lh	a5,74(s1)
    800038ac:	fff1                	bnez	a5,80003888 <iput+0x20>
    800038ae:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800038b0:	01048913          	addi	s2,s1,16
    800038b4:	854a                	mv	a0,s2
    800038b6:	2b7000ef          	jal	8000436c <acquiresleep>
    release(&itable.lock);
    800038ba:	0001b517          	auipc	a0,0x1b
    800038be:	9e650513          	addi	a0,a0,-1562 # 8001e2a0 <itable>
    800038c2:	b9efd0ef          	jal	80000c60 <release>
    itrunc(ip);
    800038c6:	8526                	mv	a0,s1
    800038c8:	f0dff0ef          	jal	800037d4 <itrunc>
    ip->type = 0;
    800038cc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800038d0:	8526                	mv	a0,s1
    800038d2:	d61ff0ef          	jal	80003632 <iupdate>
    ip->valid = 0;
    800038d6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800038da:	854a                	mv	a0,s2
    800038dc:	2d7000ef          	jal	800043b2 <releasesleep>
    acquire(&itable.lock);
    800038e0:	0001b517          	auipc	a0,0x1b
    800038e4:	9c050513          	addi	a0,a0,-1600 # 8001e2a0 <itable>
    800038e8:	ae4fd0ef          	jal	80000bcc <acquire>
    800038ec:	6902                	ld	s2,0(sp)
    800038ee:	bf69                	j	80003888 <iput+0x20>

00000000800038f0 <iunlockput>:
{
    800038f0:	1101                	addi	sp,sp,-32
    800038f2:	ec06                	sd	ra,24(sp)
    800038f4:	e822                	sd	s0,16(sp)
    800038f6:	e426                	sd	s1,8(sp)
    800038f8:	1000                	addi	s0,sp,32
    800038fa:	84aa                	mv	s1,a0
  iunlock(ip);
    800038fc:	e99ff0ef          	jal	80003794 <iunlock>
  iput(ip);
    80003900:	8526                	mv	a0,s1
    80003902:	f67ff0ef          	jal	80003868 <iput>
}
    80003906:	60e2                	ld	ra,24(sp)
    80003908:	6442                	ld	s0,16(sp)
    8000390a:	64a2                	ld	s1,8(sp)
    8000390c:	6105                	addi	sp,sp,32
    8000390e:	8082                	ret

0000000080003910 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003910:	0001b717          	auipc	a4,0x1b
    80003914:	97c72703          	lw	a4,-1668(a4) # 8001e28c <sb+0xc>
    80003918:	4785                	li	a5,1
    8000391a:	0ae7fe63          	bgeu	a5,a4,800039d6 <ireclaim+0xc6>
{
    8000391e:	7139                	addi	sp,sp,-64
    80003920:	fc06                	sd	ra,56(sp)
    80003922:	f822                	sd	s0,48(sp)
    80003924:	f426                	sd	s1,40(sp)
    80003926:	f04a                	sd	s2,32(sp)
    80003928:	ec4e                	sd	s3,24(sp)
    8000392a:	e852                	sd	s4,16(sp)
    8000392c:	e456                	sd	s5,8(sp)
    8000392e:	e05a                	sd	s6,0(sp)
    80003930:	0080                	addi	s0,sp,64
    80003932:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003934:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003936:	0001ba17          	auipc	s4,0x1b
    8000393a:	94aa0a13          	addi	s4,s4,-1718 # 8001e280 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    8000393e:	00004b17          	auipc	s6,0x4
    80003942:	b2ab0b13          	addi	s6,s6,-1238 # 80007468 <etext+0x468>
    80003946:	a099                	j	8000398c <ireclaim+0x7c>
    80003948:	85ce                	mv	a1,s3
    8000394a:	855a                	mv	a0,s6
    8000394c:	baffc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    80003950:	85ce                	mv	a1,s3
    80003952:	8556                	mv	a0,s5
    80003954:	b1fff0ef          	jal	80003472 <iget>
    80003958:	89aa                	mv	s3,a0
    brelse(bp);
    8000395a:	854a                	mv	a0,s2
    8000395c:	fecff0ef          	jal	80003148 <brelse>
    if (ip) {
    80003960:	00098f63          	beqz	s3,8000397e <ireclaim+0x6e>
      begin_op();
    80003964:	786000ef          	jal	800040ea <begin_op>
      ilock(ip);
    80003968:	854e                	mv	a0,s3
    8000396a:	d7dff0ef          	jal	800036e6 <ilock>
      iunlock(ip);
    8000396e:	854e                	mv	a0,s3
    80003970:	e25ff0ef          	jal	80003794 <iunlock>
      iput(ip);
    80003974:	854e                	mv	a0,s3
    80003976:	ef3ff0ef          	jal	80003868 <iput>
      end_op();
    8000397a:	7da000ef          	jal	80004154 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000397e:	0485                	addi	s1,s1,1
    80003980:	00ca2703          	lw	a4,12(s4)
    80003984:	0004879b          	sext.w	a5,s1
    80003988:	02e7fd63          	bgeu	a5,a4,800039c2 <ireclaim+0xb2>
    8000398c:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003990:	0044d593          	srli	a1,s1,0x4
    80003994:	018a2783          	lw	a5,24(s4)
    80003998:	9dbd                	addw	a1,a1,a5
    8000399a:	8556                	mv	a0,s5
    8000399c:	ea4ff0ef          	jal	80003040 <bread>
    800039a0:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800039a2:	05850793          	addi	a5,a0,88
    800039a6:	00f9f713          	andi	a4,s3,15
    800039aa:	071a                	slli	a4,a4,0x6
    800039ac:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800039ae:	00079703          	lh	a4,0(a5)
    800039b2:	c701                	beqz	a4,800039ba <ireclaim+0xaa>
    800039b4:	00679783          	lh	a5,6(a5)
    800039b8:	dbc1                	beqz	a5,80003948 <ireclaim+0x38>
    brelse(bp);
    800039ba:	854a                	mv	a0,s2
    800039bc:	f8cff0ef          	jal	80003148 <brelse>
    if (ip) {
    800039c0:	bf7d                	j	8000397e <ireclaim+0x6e>
}
    800039c2:	70e2                	ld	ra,56(sp)
    800039c4:	7442                	ld	s0,48(sp)
    800039c6:	74a2                	ld	s1,40(sp)
    800039c8:	7902                	ld	s2,32(sp)
    800039ca:	69e2                	ld	s3,24(sp)
    800039cc:	6a42                	ld	s4,16(sp)
    800039ce:	6aa2                	ld	s5,8(sp)
    800039d0:	6b02                	ld	s6,0(sp)
    800039d2:	6121                	addi	sp,sp,64
    800039d4:	8082                	ret
    800039d6:	8082                	ret

00000000800039d8 <fsinit>:
fsinit(int dev) {
    800039d8:	7179                	addi	sp,sp,-48
    800039da:	f406                	sd	ra,40(sp)
    800039dc:	f022                	sd	s0,32(sp)
    800039de:	ec26                	sd	s1,24(sp)
    800039e0:	e84a                	sd	s2,16(sp)
    800039e2:	e44e                	sd	s3,8(sp)
    800039e4:	1800                	addi	s0,sp,48
    800039e6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800039e8:	4585                	li	a1,1
    800039ea:	e56ff0ef          	jal	80003040 <bread>
    800039ee:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800039f0:	0001b997          	auipc	s3,0x1b
    800039f4:	89098993          	addi	s3,s3,-1904 # 8001e280 <sb>
    800039f8:	02000613          	li	a2,32
    800039fc:	05850593          	addi	a1,a0,88
    80003a00:	854e                	mv	a0,s3
    80003a02:	afefd0ef          	jal	80000d00 <memmove>
  brelse(bp);
    80003a06:	8526                	mv	a0,s1
    80003a08:	f40ff0ef          	jal	80003148 <brelse>
  if(sb.magic != FSMAGIC)
    80003a0c:	0009a703          	lw	a4,0(s3)
    80003a10:	102037b7          	lui	a5,0x10203
    80003a14:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003a18:	02f71363          	bne	a4,a5,80003a3e <fsinit+0x66>
  initlog(dev, &sb);
    80003a1c:	0001b597          	auipc	a1,0x1b
    80003a20:	86458593          	addi	a1,a1,-1948 # 8001e280 <sb>
    80003a24:	854a                	mv	a0,s2
    80003a26:	646000ef          	jal	8000406c <initlog>
  ireclaim(dev);
    80003a2a:	854a                	mv	a0,s2
    80003a2c:	ee5ff0ef          	jal	80003910 <ireclaim>
}
    80003a30:	70a2                	ld	ra,40(sp)
    80003a32:	7402                	ld	s0,32(sp)
    80003a34:	64e2                	ld	s1,24(sp)
    80003a36:	6942                	ld	s2,16(sp)
    80003a38:	69a2                	ld	s3,8(sp)
    80003a3a:	6145                	addi	sp,sp,48
    80003a3c:	8082                	ret
    panic("invalid file system");
    80003a3e:	00004517          	auipc	a0,0x4
    80003a42:	a4a50513          	addi	a0,a0,-1462 # 80007488 <etext+0x488>
    80003a46:	d99fc0ef          	jal	800007de <panic>

0000000080003a4a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003a4a:	1141                	addi	sp,sp,-16
    80003a4c:	e406                	sd	ra,8(sp)
    80003a4e:	e022                	sd	s0,0(sp)
    80003a50:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003a52:	411c                	lw	a5,0(a0)
    80003a54:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a56:	415c                	lw	a5,4(a0)
    80003a58:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a5a:	04451783          	lh	a5,68(a0)
    80003a5e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a62:	04a51783          	lh	a5,74(a0)
    80003a66:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a6a:	04c56783          	lwu	a5,76(a0)
    80003a6e:	e99c                	sd	a5,16(a1)
}
    80003a70:	60a2                	ld	ra,8(sp)
    80003a72:	6402                	ld	s0,0(sp)
    80003a74:	0141                	addi	sp,sp,16
    80003a76:	8082                	ret

0000000080003a78 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a78:	457c                	lw	a5,76(a0)
    80003a7a:	0ed7e663          	bltu	a5,a3,80003b66 <readi+0xee>
{
    80003a7e:	7159                	addi	sp,sp,-112
    80003a80:	f486                	sd	ra,104(sp)
    80003a82:	f0a2                	sd	s0,96(sp)
    80003a84:	eca6                	sd	s1,88(sp)
    80003a86:	e0d2                	sd	s4,64(sp)
    80003a88:	fc56                	sd	s5,56(sp)
    80003a8a:	f85a                	sd	s6,48(sp)
    80003a8c:	f45e                	sd	s7,40(sp)
    80003a8e:	1880                	addi	s0,sp,112
    80003a90:	8b2a                	mv	s6,a0
    80003a92:	8bae                	mv	s7,a1
    80003a94:	8a32                	mv	s4,a2
    80003a96:	84b6                	mv	s1,a3
    80003a98:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003a9a:	9f35                	addw	a4,a4,a3
    return 0;
    80003a9c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a9e:	0ad76b63          	bltu	a4,a3,80003b54 <readi+0xdc>
    80003aa2:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003aa4:	00e7f463          	bgeu	a5,a4,80003aac <readi+0x34>
    n = ip->size - off;
    80003aa8:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003aac:	080a8b63          	beqz	s5,80003b42 <readi+0xca>
    80003ab0:	e8ca                	sd	s2,80(sp)
    80003ab2:	f062                	sd	s8,32(sp)
    80003ab4:	ec66                	sd	s9,24(sp)
    80003ab6:	e86a                	sd	s10,16(sp)
    80003ab8:	e46e                	sd	s11,8(sp)
    80003aba:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003abc:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003ac0:	5c7d                	li	s8,-1
    80003ac2:	a80d                	j	80003af4 <readi+0x7c>
    80003ac4:	020d1d93          	slli	s11,s10,0x20
    80003ac8:	020ddd93          	srli	s11,s11,0x20
    80003acc:	05890613          	addi	a2,s2,88
    80003ad0:	86ee                	mv	a3,s11
    80003ad2:	963e                	add	a2,a2,a5
    80003ad4:	85d2                	mv	a1,s4
    80003ad6:	855e                	mv	a0,s7
    80003ad8:	825fe0ef          	jal	800022fc <either_copyout>
    80003adc:	05850363          	beq	a0,s8,80003b22 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ae0:	854a                	mv	a0,s2
    80003ae2:	e66ff0ef          	jal	80003148 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ae6:	013d09bb          	addw	s3,s10,s3
    80003aea:	009d04bb          	addw	s1,s10,s1
    80003aee:	9a6e                	add	s4,s4,s11
    80003af0:	0559f363          	bgeu	s3,s5,80003b36 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003af4:	00a4d59b          	srliw	a1,s1,0xa
    80003af8:	855a                	mv	a0,s6
    80003afa:	8b9ff0ef          	jal	800033b2 <bmap>
    80003afe:	85aa                	mv	a1,a0
    if(addr == 0)
    80003b00:	c139                	beqz	a0,80003b46 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003b02:	000b2503          	lw	a0,0(s6)
    80003b06:	d3aff0ef          	jal	80003040 <bread>
    80003b0a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b0c:	3ff4f793          	andi	a5,s1,1023
    80003b10:	40fc873b          	subw	a4,s9,a5
    80003b14:	413a86bb          	subw	a3,s5,s3
    80003b18:	8d3a                	mv	s10,a4
    80003b1a:	fae6f5e3          	bgeu	a3,a4,80003ac4 <readi+0x4c>
    80003b1e:	8d36                	mv	s10,a3
    80003b20:	b755                	j	80003ac4 <readi+0x4c>
      brelse(bp);
    80003b22:	854a                	mv	a0,s2
    80003b24:	e24ff0ef          	jal	80003148 <brelse>
      tot = -1;
    80003b28:	59fd                	li	s3,-1
      break;
    80003b2a:	6946                	ld	s2,80(sp)
    80003b2c:	7c02                	ld	s8,32(sp)
    80003b2e:	6ce2                	ld	s9,24(sp)
    80003b30:	6d42                	ld	s10,16(sp)
    80003b32:	6da2                	ld	s11,8(sp)
    80003b34:	a831                	j	80003b50 <readi+0xd8>
    80003b36:	6946                	ld	s2,80(sp)
    80003b38:	7c02                	ld	s8,32(sp)
    80003b3a:	6ce2                	ld	s9,24(sp)
    80003b3c:	6d42                	ld	s10,16(sp)
    80003b3e:	6da2                	ld	s11,8(sp)
    80003b40:	a801                	j	80003b50 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b42:	89d6                	mv	s3,s5
    80003b44:	a031                	j	80003b50 <readi+0xd8>
    80003b46:	6946                	ld	s2,80(sp)
    80003b48:	7c02                	ld	s8,32(sp)
    80003b4a:	6ce2                	ld	s9,24(sp)
    80003b4c:	6d42                	ld	s10,16(sp)
    80003b4e:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003b50:	854e                	mv	a0,s3
    80003b52:	69a6                	ld	s3,72(sp)
}
    80003b54:	70a6                	ld	ra,104(sp)
    80003b56:	7406                	ld	s0,96(sp)
    80003b58:	64e6                	ld	s1,88(sp)
    80003b5a:	6a06                	ld	s4,64(sp)
    80003b5c:	7ae2                	ld	s5,56(sp)
    80003b5e:	7b42                	ld	s6,48(sp)
    80003b60:	7ba2                	ld	s7,40(sp)
    80003b62:	6165                	addi	sp,sp,112
    80003b64:	8082                	ret
    return 0;
    80003b66:	4501                	li	a0,0
}
    80003b68:	8082                	ret

0000000080003b6a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b6a:	457c                	lw	a5,76(a0)
    80003b6c:	0ed7eb63          	bltu	a5,a3,80003c62 <writei+0xf8>
{
    80003b70:	7159                	addi	sp,sp,-112
    80003b72:	f486                	sd	ra,104(sp)
    80003b74:	f0a2                	sd	s0,96(sp)
    80003b76:	e8ca                	sd	s2,80(sp)
    80003b78:	e0d2                	sd	s4,64(sp)
    80003b7a:	fc56                	sd	s5,56(sp)
    80003b7c:	f85a                	sd	s6,48(sp)
    80003b7e:	f45e                	sd	s7,40(sp)
    80003b80:	1880                	addi	s0,sp,112
    80003b82:	8aaa                	mv	s5,a0
    80003b84:	8bae                	mv	s7,a1
    80003b86:	8a32                	mv	s4,a2
    80003b88:	8936                	mv	s2,a3
    80003b8a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b8c:	00e687bb          	addw	a5,a3,a4
    80003b90:	0cd7eb63          	bltu	a5,a3,80003c66 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b94:	00043737          	lui	a4,0x43
    80003b98:	0cf76963          	bltu	a4,a5,80003c6a <writei+0x100>
    80003b9c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b9e:	0a0b0a63          	beqz	s6,80003c52 <writei+0xe8>
    80003ba2:	eca6                	sd	s1,88(sp)
    80003ba4:	f062                	sd	s8,32(sp)
    80003ba6:	ec66                	sd	s9,24(sp)
    80003ba8:	e86a                	sd	s10,16(sp)
    80003baa:	e46e                	sd	s11,8(sp)
    80003bac:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bae:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003bb2:	5c7d                	li	s8,-1
    80003bb4:	a825                	j	80003bec <writei+0x82>
    80003bb6:	020d1d93          	slli	s11,s10,0x20
    80003bba:	020ddd93          	srli	s11,s11,0x20
    80003bbe:	05848513          	addi	a0,s1,88
    80003bc2:	86ee                	mv	a3,s11
    80003bc4:	8652                	mv	a2,s4
    80003bc6:	85de                	mv	a1,s7
    80003bc8:	953e                	add	a0,a0,a5
    80003bca:	f7cfe0ef          	jal	80002346 <either_copyin>
    80003bce:	05850663          	beq	a0,s8,80003c1a <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003bd2:	8526                	mv	a0,s1
    80003bd4:	6a0000ef          	jal	80004274 <log_write>
    brelse(bp);
    80003bd8:	8526                	mv	a0,s1
    80003bda:	d6eff0ef          	jal	80003148 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bde:	013d09bb          	addw	s3,s10,s3
    80003be2:	012d093b          	addw	s2,s10,s2
    80003be6:	9a6e                	add	s4,s4,s11
    80003be8:	0369fc63          	bgeu	s3,s6,80003c20 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80003bec:	00a9559b          	srliw	a1,s2,0xa
    80003bf0:	8556                	mv	a0,s5
    80003bf2:	fc0ff0ef          	jal	800033b2 <bmap>
    80003bf6:	85aa                	mv	a1,a0
    if(addr == 0)
    80003bf8:	c505                	beqz	a0,80003c20 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80003bfa:	000aa503          	lw	a0,0(s5)
    80003bfe:	c42ff0ef          	jal	80003040 <bread>
    80003c02:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c04:	3ff97793          	andi	a5,s2,1023
    80003c08:	40fc873b          	subw	a4,s9,a5
    80003c0c:	413b06bb          	subw	a3,s6,s3
    80003c10:	8d3a                	mv	s10,a4
    80003c12:	fae6f2e3          	bgeu	a3,a4,80003bb6 <writei+0x4c>
    80003c16:	8d36                	mv	s10,a3
    80003c18:	bf79                	j	80003bb6 <writei+0x4c>
      brelse(bp);
    80003c1a:	8526                	mv	a0,s1
    80003c1c:	d2cff0ef          	jal	80003148 <brelse>
  }

  if(off > ip->size)
    80003c20:	04caa783          	lw	a5,76(s5)
    80003c24:	0327f963          	bgeu	a5,s2,80003c56 <writei+0xec>
    ip->size = off;
    80003c28:	052aa623          	sw	s2,76(s5)
    80003c2c:	64e6                	ld	s1,88(sp)
    80003c2e:	7c02                	ld	s8,32(sp)
    80003c30:	6ce2                	ld	s9,24(sp)
    80003c32:	6d42                	ld	s10,16(sp)
    80003c34:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003c36:	8556                	mv	a0,s5
    80003c38:	9fbff0ef          	jal	80003632 <iupdate>

  return tot;
    80003c3c:	854e                	mv	a0,s3
    80003c3e:	69a6                	ld	s3,72(sp)
}
    80003c40:	70a6                	ld	ra,104(sp)
    80003c42:	7406                	ld	s0,96(sp)
    80003c44:	6946                	ld	s2,80(sp)
    80003c46:	6a06                	ld	s4,64(sp)
    80003c48:	7ae2                	ld	s5,56(sp)
    80003c4a:	7b42                	ld	s6,48(sp)
    80003c4c:	7ba2                	ld	s7,40(sp)
    80003c4e:	6165                	addi	sp,sp,112
    80003c50:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c52:	89da                	mv	s3,s6
    80003c54:	b7cd                	j	80003c36 <writei+0xcc>
    80003c56:	64e6                	ld	s1,88(sp)
    80003c58:	7c02                	ld	s8,32(sp)
    80003c5a:	6ce2                	ld	s9,24(sp)
    80003c5c:	6d42                	ld	s10,16(sp)
    80003c5e:	6da2                	ld	s11,8(sp)
    80003c60:	bfd9                	j	80003c36 <writei+0xcc>
    return -1;
    80003c62:	557d                	li	a0,-1
}
    80003c64:	8082                	ret
    return -1;
    80003c66:	557d                	li	a0,-1
    80003c68:	bfe1                	j	80003c40 <writei+0xd6>
    return -1;
    80003c6a:	557d                	li	a0,-1
    80003c6c:	bfd1                	j	80003c40 <writei+0xd6>

0000000080003c6e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c6e:	1141                	addi	sp,sp,-16
    80003c70:	e406                	sd	ra,8(sp)
    80003c72:	e022                	sd	s0,0(sp)
    80003c74:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c76:	4639                	li	a2,14
    80003c78:	8fcfd0ef          	jal	80000d74 <strncmp>
}
    80003c7c:	60a2                	ld	ra,8(sp)
    80003c7e:	6402                	ld	s0,0(sp)
    80003c80:	0141                	addi	sp,sp,16
    80003c82:	8082                	ret

0000000080003c84 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c84:	711d                	addi	sp,sp,-96
    80003c86:	ec86                	sd	ra,88(sp)
    80003c88:	e8a2                	sd	s0,80(sp)
    80003c8a:	e4a6                	sd	s1,72(sp)
    80003c8c:	e0ca                	sd	s2,64(sp)
    80003c8e:	fc4e                	sd	s3,56(sp)
    80003c90:	f852                	sd	s4,48(sp)
    80003c92:	f456                	sd	s5,40(sp)
    80003c94:	f05a                	sd	s6,32(sp)
    80003c96:	ec5e                	sd	s7,24(sp)
    80003c98:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c9a:	04451703          	lh	a4,68(a0)
    80003c9e:	4785                	li	a5,1
    80003ca0:	00f71f63          	bne	a4,a5,80003cbe <dirlookup+0x3a>
    80003ca4:	892a                	mv	s2,a0
    80003ca6:	8aae                	mv	s5,a1
    80003ca8:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003caa:	457c                	lw	a5,76(a0)
    80003cac:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cae:	fa040a13          	addi	s4,s0,-96
    80003cb2:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80003cb4:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003cb8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cba:	e39d                	bnez	a5,80003ce0 <dirlookup+0x5c>
    80003cbc:	a8b9                	j	80003d1a <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003cbe:	00003517          	auipc	a0,0x3
    80003cc2:	7e250513          	addi	a0,a0,2018 # 800074a0 <etext+0x4a0>
    80003cc6:	b19fc0ef          	jal	800007de <panic>
      panic("dirlookup read");
    80003cca:	00003517          	auipc	a0,0x3
    80003cce:	7ee50513          	addi	a0,a0,2030 # 800074b8 <etext+0x4b8>
    80003cd2:	b0dfc0ef          	jal	800007de <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cd6:	24c1                	addiw	s1,s1,16
    80003cd8:	04c92783          	lw	a5,76(s2)
    80003cdc:	02f4fe63          	bgeu	s1,a5,80003d18 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ce0:	874e                	mv	a4,s3
    80003ce2:	86a6                	mv	a3,s1
    80003ce4:	8652                	mv	a2,s4
    80003ce6:	4581                	li	a1,0
    80003ce8:	854a                	mv	a0,s2
    80003cea:	d8fff0ef          	jal	80003a78 <readi>
    80003cee:	fd351ee3          	bne	a0,s3,80003cca <dirlookup+0x46>
    if(de.inum == 0)
    80003cf2:	fa045783          	lhu	a5,-96(s0)
    80003cf6:	d3e5                	beqz	a5,80003cd6 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80003cf8:	85da                	mv	a1,s6
    80003cfa:	8556                	mv	a0,s5
    80003cfc:	f73ff0ef          	jal	80003c6e <namecmp>
    80003d00:	f979                	bnez	a0,80003cd6 <dirlookup+0x52>
      if(poff)
    80003d02:	000b8463          	beqz	s7,80003d0a <dirlookup+0x86>
        *poff = off;
    80003d06:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003d0a:	fa045583          	lhu	a1,-96(s0)
    80003d0e:	00092503          	lw	a0,0(s2)
    80003d12:	f60ff0ef          	jal	80003472 <iget>
    80003d16:	a011                	j	80003d1a <dirlookup+0x96>
  return 0;
    80003d18:	4501                	li	a0,0
}
    80003d1a:	60e6                	ld	ra,88(sp)
    80003d1c:	6446                	ld	s0,80(sp)
    80003d1e:	64a6                	ld	s1,72(sp)
    80003d20:	6906                	ld	s2,64(sp)
    80003d22:	79e2                	ld	s3,56(sp)
    80003d24:	7a42                	ld	s4,48(sp)
    80003d26:	7aa2                	ld	s5,40(sp)
    80003d28:	7b02                	ld	s6,32(sp)
    80003d2a:	6be2                	ld	s7,24(sp)
    80003d2c:	6125                	addi	sp,sp,96
    80003d2e:	8082                	ret

0000000080003d30 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d30:	711d                	addi	sp,sp,-96
    80003d32:	ec86                	sd	ra,88(sp)
    80003d34:	e8a2                	sd	s0,80(sp)
    80003d36:	e4a6                	sd	s1,72(sp)
    80003d38:	e0ca                	sd	s2,64(sp)
    80003d3a:	fc4e                	sd	s3,56(sp)
    80003d3c:	f852                	sd	s4,48(sp)
    80003d3e:	f456                	sd	s5,40(sp)
    80003d40:	f05a                	sd	s6,32(sp)
    80003d42:	ec5e                	sd	s7,24(sp)
    80003d44:	e862                	sd	s8,16(sp)
    80003d46:	e466                	sd	s9,8(sp)
    80003d48:	e06a                	sd	s10,0(sp)
    80003d4a:	1080                	addi	s0,sp,96
    80003d4c:	84aa                	mv	s1,a0
    80003d4e:	8b2e                	mv	s6,a1
    80003d50:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d52:	00054703          	lbu	a4,0(a0)
    80003d56:	02f00793          	li	a5,47
    80003d5a:	00f70f63          	beq	a4,a5,80003d78 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d5e:	b61fd0ef          	jal	800018be <myproc>
    80003d62:	15853503          	ld	a0,344(a0)
    80003d66:	94bff0ef          	jal	800036b0 <idup>
    80003d6a:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d6c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d70:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003d72:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d74:	4b85                	li	s7,1
    80003d76:	a879                	j	80003e14 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003d78:	4585                	li	a1,1
    80003d7a:	852e                	mv	a0,a1
    80003d7c:	ef6ff0ef          	jal	80003472 <iget>
    80003d80:	8a2a                	mv	s4,a0
    80003d82:	b7ed                	j	80003d6c <namex+0x3c>
      iunlockput(ip);
    80003d84:	8552                	mv	a0,s4
    80003d86:	b6bff0ef          	jal	800038f0 <iunlockput>
      return 0;
    80003d8a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d8c:	8552                	mv	a0,s4
    80003d8e:	60e6                	ld	ra,88(sp)
    80003d90:	6446                	ld	s0,80(sp)
    80003d92:	64a6                	ld	s1,72(sp)
    80003d94:	6906                	ld	s2,64(sp)
    80003d96:	79e2                	ld	s3,56(sp)
    80003d98:	7a42                	ld	s4,48(sp)
    80003d9a:	7aa2                	ld	s5,40(sp)
    80003d9c:	7b02                	ld	s6,32(sp)
    80003d9e:	6be2                	ld	s7,24(sp)
    80003da0:	6c42                	ld	s8,16(sp)
    80003da2:	6ca2                	ld	s9,8(sp)
    80003da4:	6d02                	ld	s10,0(sp)
    80003da6:	6125                	addi	sp,sp,96
    80003da8:	8082                	ret
      iunlock(ip);
    80003daa:	8552                	mv	a0,s4
    80003dac:	9e9ff0ef          	jal	80003794 <iunlock>
      return ip;
    80003db0:	bff1                	j	80003d8c <namex+0x5c>
      iunlockput(ip);
    80003db2:	8552                	mv	a0,s4
    80003db4:	b3dff0ef          	jal	800038f0 <iunlockput>
      return 0;
    80003db8:	8a4e                	mv	s4,s3
    80003dba:	bfc9                	j	80003d8c <namex+0x5c>
  len = path - s;
    80003dbc:	40998633          	sub	a2,s3,s1
    80003dc0:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003dc4:	09ac5063          	bge	s8,s10,80003e44 <namex+0x114>
    memmove(name, s, DIRSIZ);
    80003dc8:	8666                	mv	a2,s9
    80003dca:	85a6                	mv	a1,s1
    80003dcc:	8556                	mv	a0,s5
    80003dce:	f33fc0ef          	jal	80000d00 <memmove>
    80003dd2:	84ce                	mv	s1,s3
  while(*path == '/')
    80003dd4:	0004c783          	lbu	a5,0(s1)
    80003dd8:	01279763          	bne	a5,s2,80003de6 <namex+0xb6>
    path++;
    80003ddc:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003dde:	0004c783          	lbu	a5,0(s1)
    80003de2:	ff278de3          	beq	a5,s2,80003ddc <namex+0xac>
    ilock(ip);
    80003de6:	8552                	mv	a0,s4
    80003de8:	8ffff0ef          	jal	800036e6 <ilock>
    if(ip->type != T_DIR){
    80003dec:	044a1783          	lh	a5,68(s4)
    80003df0:	f9779ae3          	bne	a5,s7,80003d84 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003df4:	000b0563          	beqz	s6,80003dfe <namex+0xce>
    80003df8:	0004c783          	lbu	a5,0(s1)
    80003dfc:	d7dd                	beqz	a5,80003daa <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003dfe:	4601                	li	a2,0
    80003e00:	85d6                	mv	a1,s5
    80003e02:	8552                	mv	a0,s4
    80003e04:	e81ff0ef          	jal	80003c84 <dirlookup>
    80003e08:	89aa                	mv	s3,a0
    80003e0a:	d545                	beqz	a0,80003db2 <namex+0x82>
    iunlockput(ip);
    80003e0c:	8552                	mv	a0,s4
    80003e0e:	ae3ff0ef          	jal	800038f0 <iunlockput>
    ip = next;
    80003e12:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003e14:	0004c783          	lbu	a5,0(s1)
    80003e18:	01279763          	bne	a5,s2,80003e26 <namex+0xf6>
    path++;
    80003e1c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e1e:	0004c783          	lbu	a5,0(s1)
    80003e22:	ff278de3          	beq	a5,s2,80003e1c <namex+0xec>
  if(*path == 0)
    80003e26:	cb8d                	beqz	a5,80003e58 <namex+0x128>
  while(*path != '/' && *path != 0)
    80003e28:	0004c783          	lbu	a5,0(s1)
    80003e2c:	89a6                	mv	s3,s1
  len = path - s;
    80003e2e:	4d01                	li	s10,0
    80003e30:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003e32:	01278963          	beq	a5,s2,80003e44 <namex+0x114>
    80003e36:	d3d9                	beqz	a5,80003dbc <namex+0x8c>
    path++;
    80003e38:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e3a:	0009c783          	lbu	a5,0(s3)
    80003e3e:	ff279ce3          	bne	a5,s2,80003e36 <namex+0x106>
    80003e42:	bfad                	j	80003dbc <namex+0x8c>
    memmove(name, s, len);
    80003e44:	2601                	sext.w	a2,a2
    80003e46:	85a6                	mv	a1,s1
    80003e48:	8556                	mv	a0,s5
    80003e4a:	eb7fc0ef          	jal	80000d00 <memmove>
    name[len] = 0;
    80003e4e:	9d56                	add	s10,s10,s5
    80003e50:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffde078>
    80003e54:	84ce                	mv	s1,s3
    80003e56:	bfbd                	j	80003dd4 <namex+0xa4>
  if(nameiparent){
    80003e58:	f20b0ae3          	beqz	s6,80003d8c <namex+0x5c>
    iput(ip);
    80003e5c:	8552                	mv	a0,s4
    80003e5e:	a0bff0ef          	jal	80003868 <iput>
    return 0;
    80003e62:	4a01                	li	s4,0
    80003e64:	b725                	j	80003d8c <namex+0x5c>

0000000080003e66 <dirlink>:
{
    80003e66:	715d                	addi	sp,sp,-80
    80003e68:	e486                	sd	ra,72(sp)
    80003e6a:	e0a2                	sd	s0,64(sp)
    80003e6c:	f84a                	sd	s2,48(sp)
    80003e6e:	ec56                	sd	s5,24(sp)
    80003e70:	e85a                	sd	s6,16(sp)
    80003e72:	0880                	addi	s0,sp,80
    80003e74:	892a                	mv	s2,a0
    80003e76:	8aae                	mv	s5,a1
    80003e78:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e7a:	4601                	li	a2,0
    80003e7c:	e09ff0ef          	jal	80003c84 <dirlookup>
    80003e80:	ed1d                	bnez	a0,80003ebe <dirlink+0x58>
    80003e82:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e84:	04c92483          	lw	s1,76(s2)
    80003e88:	c4b9                	beqz	s1,80003ed6 <dirlink+0x70>
    80003e8a:	f44e                	sd	s3,40(sp)
    80003e8c:	f052                	sd	s4,32(sp)
    80003e8e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e90:	fb040a13          	addi	s4,s0,-80
    80003e94:	49c1                	li	s3,16
    80003e96:	874e                	mv	a4,s3
    80003e98:	86a6                	mv	a3,s1
    80003e9a:	8652                	mv	a2,s4
    80003e9c:	4581                	li	a1,0
    80003e9e:	854a                	mv	a0,s2
    80003ea0:	bd9ff0ef          	jal	80003a78 <readi>
    80003ea4:	03351163          	bne	a0,s3,80003ec6 <dirlink+0x60>
    if(de.inum == 0)
    80003ea8:	fb045783          	lhu	a5,-80(s0)
    80003eac:	c39d                	beqz	a5,80003ed2 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003eae:	24c1                	addiw	s1,s1,16
    80003eb0:	04c92783          	lw	a5,76(s2)
    80003eb4:	fef4e1e3          	bltu	s1,a5,80003e96 <dirlink+0x30>
    80003eb8:	79a2                	ld	s3,40(sp)
    80003eba:	7a02                	ld	s4,32(sp)
    80003ebc:	a829                	j	80003ed6 <dirlink+0x70>
    iput(ip);
    80003ebe:	9abff0ef          	jal	80003868 <iput>
    return -1;
    80003ec2:	557d                	li	a0,-1
    80003ec4:	a83d                	j	80003f02 <dirlink+0x9c>
      panic("dirlink read");
    80003ec6:	00003517          	auipc	a0,0x3
    80003eca:	60250513          	addi	a0,a0,1538 # 800074c8 <etext+0x4c8>
    80003ece:	911fc0ef          	jal	800007de <panic>
    80003ed2:	79a2                	ld	s3,40(sp)
    80003ed4:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003ed6:	4639                	li	a2,14
    80003ed8:	85d6                	mv	a1,s5
    80003eda:	fb240513          	addi	a0,s0,-78
    80003ede:	ed1fc0ef          	jal	80000dae <strncpy>
  de.inum = inum;
    80003ee2:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ee6:	4741                	li	a4,16
    80003ee8:	86a6                	mv	a3,s1
    80003eea:	fb040613          	addi	a2,s0,-80
    80003eee:	4581                	li	a1,0
    80003ef0:	854a                	mv	a0,s2
    80003ef2:	c79ff0ef          	jal	80003b6a <writei>
    80003ef6:	1541                	addi	a0,a0,-16
    80003ef8:	00a03533          	snez	a0,a0
    80003efc:	40a0053b          	negw	a0,a0
    80003f00:	74e2                	ld	s1,56(sp)
}
    80003f02:	60a6                	ld	ra,72(sp)
    80003f04:	6406                	ld	s0,64(sp)
    80003f06:	7942                	ld	s2,48(sp)
    80003f08:	6ae2                	ld	s5,24(sp)
    80003f0a:	6b42                	ld	s6,16(sp)
    80003f0c:	6161                	addi	sp,sp,80
    80003f0e:	8082                	ret

0000000080003f10 <namei>:

struct inode*
namei(char *path)
{
    80003f10:	1101                	addi	sp,sp,-32
    80003f12:	ec06                	sd	ra,24(sp)
    80003f14:	e822                	sd	s0,16(sp)
    80003f16:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f18:	fe040613          	addi	a2,s0,-32
    80003f1c:	4581                	li	a1,0
    80003f1e:	e13ff0ef          	jal	80003d30 <namex>
}
    80003f22:	60e2                	ld	ra,24(sp)
    80003f24:	6442                	ld	s0,16(sp)
    80003f26:	6105                	addi	sp,sp,32
    80003f28:	8082                	ret

0000000080003f2a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f2a:	1141                	addi	sp,sp,-16
    80003f2c:	e406                	sd	ra,8(sp)
    80003f2e:	e022                	sd	s0,0(sp)
    80003f30:	0800                	addi	s0,sp,16
    80003f32:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f34:	4585                	li	a1,1
    80003f36:	dfbff0ef          	jal	80003d30 <namex>
}
    80003f3a:	60a2                	ld	ra,8(sp)
    80003f3c:	6402                	ld	s0,0(sp)
    80003f3e:	0141                	addi	sp,sp,16
    80003f40:	8082                	ret

0000000080003f42 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f42:	1101                	addi	sp,sp,-32
    80003f44:	ec06                	sd	ra,24(sp)
    80003f46:	e822                	sd	s0,16(sp)
    80003f48:	e426                	sd	s1,8(sp)
    80003f4a:	e04a                	sd	s2,0(sp)
    80003f4c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f4e:	0001c917          	auipc	s2,0x1c
    80003f52:	dfa90913          	addi	s2,s2,-518 # 8001fd48 <log>
    80003f56:	01892583          	lw	a1,24(s2)
    80003f5a:	02492503          	lw	a0,36(s2)
    80003f5e:	8e2ff0ef          	jal	80003040 <bread>
    80003f62:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f64:	02892603          	lw	a2,40(s2)
    80003f68:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f6a:	00c05f63          	blez	a2,80003f88 <write_head+0x46>
    80003f6e:	0001c717          	auipc	a4,0x1c
    80003f72:	e0670713          	addi	a4,a4,-506 # 8001fd74 <log+0x2c>
    80003f76:	87aa                	mv	a5,a0
    80003f78:	060a                	slli	a2,a2,0x2
    80003f7a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003f7c:	4314                	lw	a3,0(a4)
    80003f7e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003f80:	0711                	addi	a4,a4,4
    80003f82:	0791                	addi	a5,a5,4
    80003f84:	fec79ce3          	bne	a5,a2,80003f7c <write_head+0x3a>
  }
  bwrite(buf);
    80003f88:	8526                	mv	a0,s1
    80003f8a:	98cff0ef          	jal	80003116 <bwrite>
  brelse(buf);
    80003f8e:	8526                	mv	a0,s1
    80003f90:	9b8ff0ef          	jal	80003148 <brelse>
}
    80003f94:	60e2                	ld	ra,24(sp)
    80003f96:	6442                	ld	s0,16(sp)
    80003f98:	64a2                	ld	s1,8(sp)
    80003f9a:	6902                	ld	s2,0(sp)
    80003f9c:	6105                	addi	sp,sp,32
    80003f9e:	8082                	ret

0000000080003fa0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fa0:	0001c797          	auipc	a5,0x1c
    80003fa4:	dd07a783          	lw	a5,-560(a5) # 8001fd70 <log+0x28>
    80003fa8:	0cf05163          	blez	a5,8000406a <install_trans+0xca>
{
    80003fac:	715d                	addi	sp,sp,-80
    80003fae:	e486                	sd	ra,72(sp)
    80003fb0:	e0a2                	sd	s0,64(sp)
    80003fb2:	fc26                	sd	s1,56(sp)
    80003fb4:	f84a                	sd	s2,48(sp)
    80003fb6:	f44e                	sd	s3,40(sp)
    80003fb8:	f052                	sd	s4,32(sp)
    80003fba:	ec56                	sd	s5,24(sp)
    80003fbc:	e85a                	sd	s6,16(sp)
    80003fbe:	e45e                	sd	s7,8(sp)
    80003fc0:	e062                	sd	s8,0(sp)
    80003fc2:	0880                	addi	s0,sp,80
    80003fc4:	8b2a                	mv	s6,a0
    80003fc6:	0001ca97          	auipc	s5,0x1c
    80003fca:	daea8a93          	addi	s5,s5,-594 # 8001fd74 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fce:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003fd0:	00003c17          	auipc	s8,0x3
    80003fd4:	508c0c13          	addi	s8,s8,1288 # 800074d8 <etext+0x4d8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fd8:	0001ca17          	auipc	s4,0x1c
    80003fdc:	d70a0a13          	addi	s4,s4,-656 # 8001fd48 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003fe0:	40000b93          	li	s7,1024
    80003fe4:	a025                	j	8000400c <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003fe6:	000aa603          	lw	a2,0(s5)
    80003fea:	85ce                	mv	a1,s3
    80003fec:	8562                	mv	a0,s8
    80003fee:	d0cfc0ef          	jal	800004fa <printf>
    80003ff2:	a839                	j	80004010 <install_trans+0x70>
    brelse(lbuf);
    80003ff4:	854a                	mv	a0,s2
    80003ff6:	952ff0ef          	jal	80003148 <brelse>
    brelse(dbuf);
    80003ffa:	8526                	mv	a0,s1
    80003ffc:	94cff0ef          	jal	80003148 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004000:	2985                	addiw	s3,s3,1
    80004002:	0a91                	addi	s5,s5,4
    80004004:	028a2783          	lw	a5,40(s4)
    80004008:	04f9d563          	bge	s3,a5,80004052 <install_trans+0xb2>
    if(recovering) {
    8000400c:	fc0b1de3          	bnez	s6,80003fe6 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004010:	018a2583          	lw	a1,24(s4)
    80004014:	013585bb          	addw	a1,a1,s3
    80004018:	2585                	addiw	a1,a1,1
    8000401a:	024a2503          	lw	a0,36(s4)
    8000401e:	822ff0ef          	jal	80003040 <bread>
    80004022:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004024:	000aa583          	lw	a1,0(s5)
    80004028:	024a2503          	lw	a0,36(s4)
    8000402c:	814ff0ef          	jal	80003040 <bread>
    80004030:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004032:	865e                	mv	a2,s7
    80004034:	05890593          	addi	a1,s2,88
    80004038:	05850513          	addi	a0,a0,88
    8000403c:	cc5fc0ef          	jal	80000d00 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004040:	8526                	mv	a0,s1
    80004042:	8d4ff0ef          	jal	80003116 <bwrite>
    if(recovering == 0)
    80004046:	fa0b17e3          	bnez	s6,80003ff4 <install_trans+0x54>
      bunpin(dbuf);
    8000404a:	8526                	mv	a0,s1
    8000404c:	9b4ff0ef          	jal	80003200 <bunpin>
    80004050:	b755                	j	80003ff4 <install_trans+0x54>
}
    80004052:	60a6                	ld	ra,72(sp)
    80004054:	6406                	ld	s0,64(sp)
    80004056:	74e2                	ld	s1,56(sp)
    80004058:	7942                	ld	s2,48(sp)
    8000405a:	79a2                	ld	s3,40(sp)
    8000405c:	7a02                	ld	s4,32(sp)
    8000405e:	6ae2                	ld	s5,24(sp)
    80004060:	6b42                	ld	s6,16(sp)
    80004062:	6ba2                	ld	s7,8(sp)
    80004064:	6c02                	ld	s8,0(sp)
    80004066:	6161                	addi	sp,sp,80
    80004068:	8082                	ret
    8000406a:	8082                	ret

000000008000406c <initlog>:
{
    8000406c:	7179                	addi	sp,sp,-48
    8000406e:	f406                	sd	ra,40(sp)
    80004070:	f022                	sd	s0,32(sp)
    80004072:	ec26                	sd	s1,24(sp)
    80004074:	e84a                	sd	s2,16(sp)
    80004076:	e44e                	sd	s3,8(sp)
    80004078:	1800                	addi	s0,sp,48
    8000407a:	892a                	mv	s2,a0
    8000407c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000407e:	0001c497          	auipc	s1,0x1c
    80004082:	cca48493          	addi	s1,s1,-822 # 8001fd48 <log>
    80004086:	00003597          	auipc	a1,0x3
    8000408a:	47258593          	addi	a1,a1,1138 # 800074f8 <etext+0x4f8>
    8000408e:	8526                	mv	a0,s1
    80004090:	ab9fc0ef          	jal	80000b48 <initlock>
  log.start = sb->logstart;
    80004094:	0149a583          	lw	a1,20(s3)
    80004098:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    8000409a:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000409e:	854a                	mv	a0,s2
    800040a0:	fa1fe0ef          	jal	80003040 <bread>
  log.lh.n = lh->n;
    800040a4:	4d30                	lw	a2,88(a0)
    800040a6:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    800040a8:	00c05f63          	blez	a2,800040c6 <initlog+0x5a>
    800040ac:	87aa                	mv	a5,a0
    800040ae:	0001c717          	auipc	a4,0x1c
    800040b2:	cc670713          	addi	a4,a4,-826 # 8001fd74 <log+0x2c>
    800040b6:	060a                	slli	a2,a2,0x2
    800040b8:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800040ba:	4ff4                	lw	a3,92(a5)
    800040bc:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800040be:	0791                	addi	a5,a5,4
    800040c0:	0711                	addi	a4,a4,4
    800040c2:	fec79ce3          	bne	a5,a2,800040ba <initlog+0x4e>
  brelse(buf);
    800040c6:	882ff0ef          	jal	80003148 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800040ca:	4505                	li	a0,1
    800040cc:	ed5ff0ef          	jal	80003fa0 <install_trans>
  log.lh.n = 0;
    800040d0:	0001c797          	auipc	a5,0x1c
    800040d4:	ca07a023          	sw	zero,-864(a5) # 8001fd70 <log+0x28>
  write_head(); // clear the log
    800040d8:	e6bff0ef          	jal	80003f42 <write_head>
}
    800040dc:	70a2                	ld	ra,40(sp)
    800040de:	7402                	ld	s0,32(sp)
    800040e0:	64e2                	ld	s1,24(sp)
    800040e2:	6942                	ld	s2,16(sp)
    800040e4:	69a2                	ld	s3,8(sp)
    800040e6:	6145                	addi	sp,sp,48
    800040e8:	8082                	ret

00000000800040ea <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800040ea:	1101                	addi	sp,sp,-32
    800040ec:	ec06                	sd	ra,24(sp)
    800040ee:	e822                	sd	s0,16(sp)
    800040f0:	e426                	sd	s1,8(sp)
    800040f2:	e04a                	sd	s2,0(sp)
    800040f4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800040f6:	0001c517          	auipc	a0,0x1c
    800040fa:	c5250513          	addi	a0,a0,-942 # 8001fd48 <log>
    800040fe:	acffc0ef          	jal	80000bcc <acquire>
  while(1){
    if(log.committing){
    80004102:	0001c497          	auipc	s1,0x1c
    80004106:	c4648493          	addi	s1,s1,-954 # 8001fd48 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    8000410a:	4979                	li	s2,30
    8000410c:	a029                	j	80004116 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000410e:	85a6                	mv	a1,s1
    80004110:	8526                	mv	a0,s1
    80004112:	e17fd0ef          	jal	80001f28 <sleep>
    if(log.committing){
    80004116:	509c                	lw	a5,32(s1)
    80004118:	fbfd                	bnez	a5,8000410e <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    8000411a:	4cd8                	lw	a4,28(s1)
    8000411c:	2705                	addiw	a4,a4,1
    8000411e:	0027179b          	slliw	a5,a4,0x2
    80004122:	9fb9                	addw	a5,a5,a4
    80004124:	0017979b          	slliw	a5,a5,0x1
    80004128:	5494                	lw	a3,40(s1)
    8000412a:	9fb5                	addw	a5,a5,a3
    8000412c:	00f95763          	bge	s2,a5,8000413a <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004130:	85a6                	mv	a1,s1
    80004132:	8526                	mv	a0,s1
    80004134:	df5fd0ef          	jal	80001f28 <sleep>
    80004138:	bff9                	j	80004116 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000413a:	0001c517          	auipc	a0,0x1c
    8000413e:	c0e50513          	addi	a0,a0,-1010 # 8001fd48 <log>
    80004142:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    80004144:	b1dfc0ef          	jal	80000c60 <release>
      break;
    }
  }
}
    80004148:	60e2                	ld	ra,24(sp)
    8000414a:	6442                	ld	s0,16(sp)
    8000414c:	64a2                	ld	s1,8(sp)
    8000414e:	6902                	ld	s2,0(sp)
    80004150:	6105                	addi	sp,sp,32
    80004152:	8082                	ret

0000000080004154 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004154:	7139                	addi	sp,sp,-64
    80004156:	fc06                	sd	ra,56(sp)
    80004158:	f822                	sd	s0,48(sp)
    8000415a:	f426                	sd	s1,40(sp)
    8000415c:	f04a                	sd	s2,32(sp)
    8000415e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004160:	0001c497          	auipc	s1,0x1c
    80004164:	be848493          	addi	s1,s1,-1048 # 8001fd48 <log>
    80004168:	8526                	mv	a0,s1
    8000416a:	a63fc0ef          	jal	80000bcc <acquire>
  log.outstanding -= 1;
    8000416e:	4cdc                	lw	a5,28(s1)
    80004170:	37fd                	addiw	a5,a5,-1
    80004172:	893e                	mv	s2,a5
    80004174:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80004176:	509c                	lw	a5,32(s1)
    80004178:	ef9d                	bnez	a5,800041b6 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    8000417a:	04091863          	bnez	s2,800041ca <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000417e:	0001c497          	auipc	s1,0x1c
    80004182:	bca48493          	addi	s1,s1,-1078 # 8001fd48 <log>
    80004186:	4785                	li	a5,1
    80004188:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000418a:	8526                	mv	a0,s1
    8000418c:	ad5fc0ef          	jal	80000c60 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004190:	549c                	lw	a5,40(s1)
    80004192:	04f04c63          	bgtz	a5,800041ea <end_op+0x96>
    acquire(&log.lock);
    80004196:	0001c497          	auipc	s1,0x1c
    8000419a:	bb248493          	addi	s1,s1,-1102 # 8001fd48 <log>
    8000419e:	8526                	mv	a0,s1
    800041a0:	a2dfc0ef          	jal	80000bcc <acquire>
    log.committing = 0;
    800041a4:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    800041a8:	8526                	mv	a0,s1
    800041aa:	dcbfd0ef          	jal	80001f74 <wakeup>
    release(&log.lock);
    800041ae:	8526                	mv	a0,s1
    800041b0:	ab1fc0ef          	jal	80000c60 <release>
}
    800041b4:	a02d                	j	800041de <end_op+0x8a>
    800041b6:	ec4e                	sd	s3,24(sp)
    800041b8:	e852                	sd	s4,16(sp)
    800041ba:	e456                	sd	s5,8(sp)
    800041bc:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800041be:	00003517          	auipc	a0,0x3
    800041c2:	34250513          	addi	a0,a0,834 # 80007500 <etext+0x500>
    800041c6:	e18fc0ef          	jal	800007de <panic>
    wakeup(&log);
    800041ca:	0001c497          	auipc	s1,0x1c
    800041ce:	b7e48493          	addi	s1,s1,-1154 # 8001fd48 <log>
    800041d2:	8526                	mv	a0,s1
    800041d4:	da1fd0ef          	jal	80001f74 <wakeup>
  release(&log.lock);
    800041d8:	8526                	mv	a0,s1
    800041da:	a87fc0ef          	jal	80000c60 <release>
}
    800041de:	70e2                	ld	ra,56(sp)
    800041e0:	7442                	ld	s0,48(sp)
    800041e2:	74a2                	ld	s1,40(sp)
    800041e4:	7902                	ld	s2,32(sp)
    800041e6:	6121                	addi	sp,sp,64
    800041e8:	8082                	ret
    800041ea:	ec4e                	sd	s3,24(sp)
    800041ec:	e852                	sd	s4,16(sp)
    800041ee:	e456                	sd	s5,8(sp)
    800041f0:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800041f2:	0001ca97          	auipc	s5,0x1c
    800041f6:	b82a8a93          	addi	s5,s5,-1150 # 8001fd74 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800041fa:	0001ca17          	auipc	s4,0x1c
    800041fe:	b4ea0a13          	addi	s4,s4,-1202 # 8001fd48 <log>
    memmove(to->data, from->data, BSIZE);
    80004202:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004206:	018a2583          	lw	a1,24(s4)
    8000420a:	012585bb          	addw	a1,a1,s2
    8000420e:	2585                	addiw	a1,a1,1
    80004210:	024a2503          	lw	a0,36(s4)
    80004214:	e2dfe0ef          	jal	80003040 <bread>
    80004218:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000421a:	000aa583          	lw	a1,0(s5)
    8000421e:	024a2503          	lw	a0,36(s4)
    80004222:	e1ffe0ef          	jal	80003040 <bread>
    80004226:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004228:	865a                	mv	a2,s6
    8000422a:	05850593          	addi	a1,a0,88
    8000422e:	05848513          	addi	a0,s1,88
    80004232:	acffc0ef          	jal	80000d00 <memmove>
    bwrite(to);  // write the log
    80004236:	8526                	mv	a0,s1
    80004238:	edffe0ef          	jal	80003116 <bwrite>
    brelse(from);
    8000423c:	854e                	mv	a0,s3
    8000423e:	f0bfe0ef          	jal	80003148 <brelse>
    brelse(to);
    80004242:	8526                	mv	a0,s1
    80004244:	f05fe0ef          	jal	80003148 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004248:	2905                	addiw	s2,s2,1
    8000424a:	0a91                	addi	s5,s5,4
    8000424c:	028a2783          	lw	a5,40(s4)
    80004250:	faf94be3          	blt	s2,a5,80004206 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004254:	cefff0ef          	jal	80003f42 <write_head>
    install_trans(0); // Now install writes to home locations
    80004258:	4501                	li	a0,0
    8000425a:	d47ff0ef          	jal	80003fa0 <install_trans>
    log.lh.n = 0;
    8000425e:	0001c797          	auipc	a5,0x1c
    80004262:	b007a923          	sw	zero,-1262(a5) # 8001fd70 <log+0x28>
    write_head();    // Erase the transaction from the log
    80004266:	cddff0ef          	jal	80003f42 <write_head>
    8000426a:	69e2                	ld	s3,24(sp)
    8000426c:	6a42                	ld	s4,16(sp)
    8000426e:	6aa2                	ld	s5,8(sp)
    80004270:	6b02                	ld	s6,0(sp)
    80004272:	b715                	j	80004196 <end_op+0x42>

0000000080004274 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004274:	1101                	addi	sp,sp,-32
    80004276:	ec06                	sd	ra,24(sp)
    80004278:	e822                	sd	s0,16(sp)
    8000427a:	e426                	sd	s1,8(sp)
    8000427c:	e04a                	sd	s2,0(sp)
    8000427e:	1000                	addi	s0,sp,32
    80004280:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004282:	0001c917          	auipc	s2,0x1c
    80004286:	ac690913          	addi	s2,s2,-1338 # 8001fd48 <log>
    8000428a:	854a                	mv	a0,s2
    8000428c:	941fc0ef          	jal	80000bcc <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80004290:	02892603          	lw	a2,40(s2)
    80004294:	47f5                	li	a5,29
    80004296:	04c7cc63          	blt	a5,a2,800042ee <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000429a:	0001c797          	auipc	a5,0x1c
    8000429e:	aca7a783          	lw	a5,-1334(a5) # 8001fd64 <log+0x1c>
    800042a2:	04f05c63          	blez	a5,800042fa <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800042a6:	4781                	li	a5,0
    800042a8:	04c05f63          	blez	a2,80004306 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800042ac:	44cc                	lw	a1,12(s1)
    800042ae:	0001c717          	auipc	a4,0x1c
    800042b2:	ac670713          	addi	a4,a4,-1338 # 8001fd74 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    800042b6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800042b8:	4314                	lw	a3,0(a4)
    800042ba:	04b68663          	beq	a3,a1,80004306 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    800042be:	2785                	addiw	a5,a5,1
    800042c0:	0711                	addi	a4,a4,4
    800042c2:	fef61be3          	bne	a2,a5,800042b8 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800042c6:	0621                	addi	a2,a2,8
    800042c8:	060a                	slli	a2,a2,0x2
    800042ca:	0001c797          	auipc	a5,0x1c
    800042ce:	a7e78793          	addi	a5,a5,-1410 # 8001fd48 <log>
    800042d2:	97b2                	add	a5,a5,a2
    800042d4:	44d8                	lw	a4,12(s1)
    800042d6:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800042d8:	8526                	mv	a0,s1
    800042da:	ef3fe0ef          	jal	800031cc <bpin>
    log.lh.n++;
    800042de:	0001c717          	auipc	a4,0x1c
    800042e2:	a6a70713          	addi	a4,a4,-1430 # 8001fd48 <log>
    800042e6:	571c                	lw	a5,40(a4)
    800042e8:	2785                	addiw	a5,a5,1
    800042ea:	d71c                	sw	a5,40(a4)
    800042ec:	a80d                	j	8000431e <log_write+0xaa>
    panic("too big a transaction");
    800042ee:	00003517          	auipc	a0,0x3
    800042f2:	22250513          	addi	a0,a0,546 # 80007510 <etext+0x510>
    800042f6:	ce8fc0ef          	jal	800007de <panic>
    panic("log_write outside of trans");
    800042fa:	00003517          	auipc	a0,0x3
    800042fe:	22e50513          	addi	a0,a0,558 # 80007528 <etext+0x528>
    80004302:	cdcfc0ef          	jal	800007de <panic>
  log.lh.block[i] = b->blockno;
    80004306:	00878693          	addi	a3,a5,8
    8000430a:	068a                	slli	a3,a3,0x2
    8000430c:	0001c717          	auipc	a4,0x1c
    80004310:	a3c70713          	addi	a4,a4,-1476 # 8001fd48 <log>
    80004314:	9736                	add	a4,a4,a3
    80004316:	44d4                	lw	a3,12(s1)
    80004318:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000431a:	faf60fe3          	beq	a2,a5,800042d8 <log_write+0x64>
  }
  release(&log.lock);
    8000431e:	0001c517          	auipc	a0,0x1c
    80004322:	a2a50513          	addi	a0,a0,-1494 # 8001fd48 <log>
    80004326:	93bfc0ef          	jal	80000c60 <release>
}
    8000432a:	60e2                	ld	ra,24(sp)
    8000432c:	6442                	ld	s0,16(sp)
    8000432e:	64a2                	ld	s1,8(sp)
    80004330:	6902                	ld	s2,0(sp)
    80004332:	6105                	addi	sp,sp,32
    80004334:	8082                	ret

0000000080004336 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004336:	1101                	addi	sp,sp,-32
    80004338:	ec06                	sd	ra,24(sp)
    8000433a:	e822                	sd	s0,16(sp)
    8000433c:	e426                	sd	s1,8(sp)
    8000433e:	e04a                	sd	s2,0(sp)
    80004340:	1000                	addi	s0,sp,32
    80004342:	84aa                	mv	s1,a0
    80004344:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004346:	00003597          	auipc	a1,0x3
    8000434a:	20258593          	addi	a1,a1,514 # 80007548 <etext+0x548>
    8000434e:	0521                	addi	a0,a0,8
    80004350:	ff8fc0ef          	jal	80000b48 <initlock>
  lk->name = name;
    80004354:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004358:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000435c:	0204a423          	sw	zero,40(s1)
}
    80004360:	60e2                	ld	ra,24(sp)
    80004362:	6442                	ld	s0,16(sp)
    80004364:	64a2                	ld	s1,8(sp)
    80004366:	6902                	ld	s2,0(sp)
    80004368:	6105                	addi	sp,sp,32
    8000436a:	8082                	ret

000000008000436c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000436c:	1101                	addi	sp,sp,-32
    8000436e:	ec06                	sd	ra,24(sp)
    80004370:	e822                	sd	s0,16(sp)
    80004372:	e426                	sd	s1,8(sp)
    80004374:	e04a                	sd	s2,0(sp)
    80004376:	1000                	addi	s0,sp,32
    80004378:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000437a:	00850913          	addi	s2,a0,8
    8000437e:	854a                	mv	a0,s2
    80004380:	84dfc0ef          	jal	80000bcc <acquire>
  while (lk->locked) {
    80004384:	409c                	lw	a5,0(s1)
    80004386:	c799                	beqz	a5,80004394 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004388:	85ca                	mv	a1,s2
    8000438a:	8526                	mv	a0,s1
    8000438c:	b9dfd0ef          	jal	80001f28 <sleep>
  while (lk->locked) {
    80004390:	409c                	lw	a5,0(s1)
    80004392:	fbfd                	bnez	a5,80004388 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004394:	4785                	li	a5,1
    80004396:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004398:	d26fd0ef          	jal	800018be <myproc>
    8000439c:	591c                	lw	a5,48(a0)
    8000439e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800043a0:	854a                	mv	a0,s2
    800043a2:	8bffc0ef          	jal	80000c60 <release>
}
    800043a6:	60e2                	ld	ra,24(sp)
    800043a8:	6442                	ld	s0,16(sp)
    800043aa:	64a2                	ld	s1,8(sp)
    800043ac:	6902                	ld	s2,0(sp)
    800043ae:	6105                	addi	sp,sp,32
    800043b0:	8082                	ret

00000000800043b2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800043b2:	1101                	addi	sp,sp,-32
    800043b4:	ec06                	sd	ra,24(sp)
    800043b6:	e822                	sd	s0,16(sp)
    800043b8:	e426                	sd	s1,8(sp)
    800043ba:	e04a                	sd	s2,0(sp)
    800043bc:	1000                	addi	s0,sp,32
    800043be:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043c0:	00850913          	addi	s2,a0,8
    800043c4:	854a                	mv	a0,s2
    800043c6:	807fc0ef          	jal	80000bcc <acquire>
  lk->locked = 0;
    800043ca:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043ce:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800043d2:	8526                	mv	a0,s1
    800043d4:	ba1fd0ef          	jal	80001f74 <wakeup>
  release(&lk->lk);
    800043d8:	854a                	mv	a0,s2
    800043da:	887fc0ef          	jal	80000c60 <release>
}
    800043de:	60e2                	ld	ra,24(sp)
    800043e0:	6442                	ld	s0,16(sp)
    800043e2:	64a2                	ld	s1,8(sp)
    800043e4:	6902                	ld	s2,0(sp)
    800043e6:	6105                	addi	sp,sp,32
    800043e8:	8082                	ret

00000000800043ea <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800043ea:	7179                	addi	sp,sp,-48
    800043ec:	f406                	sd	ra,40(sp)
    800043ee:	f022                	sd	s0,32(sp)
    800043f0:	ec26                	sd	s1,24(sp)
    800043f2:	e84a                	sd	s2,16(sp)
    800043f4:	1800                	addi	s0,sp,48
    800043f6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800043f8:	00850913          	addi	s2,a0,8
    800043fc:	854a                	mv	a0,s2
    800043fe:	fcefc0ef          	jal	80000bcc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004402:	409c                	lw	a5,0(s1)
    80004404:	ef81                	bnez	a5,8000441c <holdingsleep+0x32>
    80004406:	4481                	li	s1,0
  release(&lk->lk);
    80004408:	854a                	mv	a0,s2
    8000440a:	857fc0ef          	jal	80000c60 <release>
  return r;
}
    8000440e:	8526                	mv	a0,s1
    80004410:	70a2                	ld	ra,40(sp)
    80004412:	7402                	ld	s0,32(sp)
    80004414:	64e2                	ld	s1,24(sp)
    80004416:	6942                	ld	s2,16(sp)
    80004418:	6145                	addi	sp,sp,48
    8000441a:	8082                	ret
    8000441c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000441e:	0284a983          	lw	s3,40(s1)
    80004422:	c9cfd0ef          	jal	800018be <myproc>
    80004426:	5904                	lw	s1,48(a0)
    80004428:	413484b3          	sub	s1,s1,s3
    8000442c:	0014b493          	seqz	s1,s1
    80004430:	69a2                	ld	s3,8(sp)
    80004432:	bfd9                	j	80004408 <holdingsleep+0x1e>

0000000080004434 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004434:	1141                	addi	sp,sp,-16
    80004436:	e406                	sd	ra,8(sp)
    80004438:	e022                	sd	s0,0(sp)
    8000443a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000443c:	00003597          	auipc	a1,0x3
    80004440:	11c58593          	addi	a1,a1,284 # 80007558 <etext+0x558>
    80004444:	0001c517          	auipc	a0,0x1c
    80004448:	a4c50513          	addi	a0,a0,-1460 # 8001fe90 <ftable>
    8000444c:	efcfc0ef          	jal	80000b48 <initlock>
}
    80004450:	60a2                	ld	ra,8(sp)
    80004452:	6402                	ld	s0,0(sp)
    80004454:	0141                	addi	sp,sp,16
    80004456:	8082                	ret

0000000080004458 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004458:	1101                	addi	sp,sp,-32
    8000445a:	ec06                	sd	ra,24(sp)
    8000445c:	e822                	sd	s0,16(sp)
    8000445e:	e426                	sd	s1,8(sp)
    80004460:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004462:	0001c517          	auipc	a0,0x1c
    80004466:	a2e50513          	addi	a0,a0,-1490 # 8001fe90 <ftable>
    8000446a:	f62fc0ef          	jal	80000bcc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000446e:	0001c497          	auipc	s1,0x1c
    80004472:	a3a48493          	addi	s1,s1,-1478 # 8001fea8 <ftable+0x18>
    80004476:	0001d717          	auipc	a4,0x1d
    8000447a:	9d270713          	addi	a4,a4,-1582 # 80020e48 <disk>
    if(f->ref == 0){
    8000447e:	40dc                	lw	a5,4(s1)
    80004480:	cf89                	beqz	a5,8000449a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004482:	02848493          	addi	s1,s1,40
    80004486:	fee49ce3          	bne	s1,a4,8000447e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000448a:	0001c517          	auipc	a0,0x1c
    8000448e:	a0650513          	addi	a0,a0,-1530 # 8001fe90 <ftable>
    80004492:	fcefc0ef          	jal	80000c60 <release>
  return 0;
    80004496:	4481                	li	s1,0
    80004498:	a809                	j	800044aa <filealloc+0x52>
      f->ref = 1;
    8000449a:	4785                	li	a5,1
    8000449c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000449e:	0001c517          	auipc	a0,0x1c
    800044a2:	9f250513          	addi	a0,a0,-1550 # 8001fe90 <ftable>
    800044a6:	fbafc0ef          	jal	80000c60 <release>
}
    800044aa:	8526                	mv	a0,s1
    800044ac:	60e2                	ld	ra,24(sp)
    800044ae:	6442                	ld	s0,16(sp)
    800044b0:	64a2                	ld	s1,8(sp)
    800044b2:	6105                	addi	sp,sp,32
    800044b4:	8082                	ret

00000000800044b6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800044b6:	1101                	addi	sp,sp,-32
    800044b8:	ec06                	sd	ra,24(sp)
    800044ba:	e822                	sd	s0,16(sp)
    800044bc:	e426                	sd	s1,8(sp)
    800044be:	1000                	addi	s0,sp,32
    800044c0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800044c2:	0001c517          	auipc	a0,0x1c
    800044c6:	9ce50513          	addi	a0,a0,-1586 # 8001fe90 <ftable>
    800044ca:	f02fc0ef          	jal	80000bcc <acquire>
  if(f->ref < 1)
    800044ce:	40dc                	lw	a5,4(s1)
    800044d0:	02f05063          	blez	a5,800044f0 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800044d4:	2785                	addiw	a5,a5,1
    800044d6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800044d8:	0001c517          	auipc	a0,0x1c
    800044dc:	9b850513          	addi	a0,a0,-1608 # 8001fe90 <ftable>
    800044e0:	f80fc0ef          	jal	80000c60 <release>
  return f;
}
    800044e4:	8526                	mv	a0,s1
    800044e6:	60e2                	ld	ra,24(sp)
    800044e8:	6442                	ld	s0,16(sp)
    800044ea:	64a2                	ld	s1,8(sp)
    800044ec:	6105                	addi	sp,sp,32
    800044ee:	8082                	ret
    panic("filedup");
    800044f0:	00003517          	auipc	a0,0x3
    800044f4:	07050513          	addi	a0,a0,112 # 80007560 <etext+0x560>
    800044f8:	ae6fc0ef          	jal	800007de <panic>

00000000800044fc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800044fc:	7139                	addi	sp,sp,-64
    800044fe:	fc06                	sd	ra,56(sp)
    80004500:	f822                	sd	s0,48(sp)
    80004502:	f426                	sd	s1,40(sp)
    80004504:	0080                	addi	s0,sp,64
    80004506:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004508:	0001c517          	auipc	a0,0x1c
    8000450c:	98850513          	addi	a0,a0,-1656 # 8001fe90 <ftable>
    80004510:	ebcfc0ef          	jal	80000bcc <acquire>
  if(f->ref < 1)
    80004514:	40dc                	lw	a5,4(s1)
    80004516:	04f05863          	blez	a5,80004566 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    8000451a:	37fd                	addiw	a5,a5,-1
    8000451c:	c0dc                	sw	a5,4(s1)
    8000451e:	04f04e63          	bgtz	a5,8000457a <fileclose+0x7e>
    80004522:	f04a                	sd	s2,32(sp)
    80004524:	ec4e                	sd	s3,24(sp)
    80004526:	e852                	sd	s4,16(sp)
    80004528:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000452a:	0004a903          	lw	s2,0(s1)
    8000452e:	0094ca83          	lbu	s5,9(s1)
    80004532:	0104ba03          	ld	s4,16(s1)
    80004536:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000453a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000453e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004542:	0001c517          	auipc	a0,0x1c
    80004546:	94e50513          	addi	a0,a0,-1714 # 8001fe90 <ftable>
    8000454a:	f16fc0ef          	jal	80000c60 <release>

  if(ff.type == FD_PIPE){
    8000454e:	4785                	li	a5,1
    80004550:	04f90063          	beq	s2,a5,80004590 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004554:	3979                	addiw	s2,s2,-2
    80004556:	4785                	li	a5,1
    80004558:	0527f563          	bgeu	a5,s2,800045a2 <fileclose+0xa6>
    8000455c:	7902                	ld	s2,32(sp)
    8000455e:	69e2                	ld	s3,24(sp)
    80004560:	6a42                	ld	s4,16(sp)
    80004562:	6aa2                	ld	s5,8(sp)
    80004564:	a00d                	j	80004586 <fileclose+0x8a>
    80004566:	f04a                	sd	s2,32(sp)
    80004568:	ec4e                	sd	s3,24(sp)
    8000456a:	e852                	sd	s4,16(sp)
    8000456c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000456e:	00003517          	auipc	a0,0x3
    80004572:	ffa50513          	addi	a0,a0,-6 # 80007568 <etext+0x568>
    80004576:	a68fc0ef          	jal	800007de <panic>
    release(&ftable.lock);
    8000457a:	0001c517          	auipc	a0,0x1c
    8000457e:	91650513          	addi	a0,a0,-1770 # 8001fe90 <ftable>
    80004582:	edefc0ef          	jal	80000c60 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004586:	70e2                	ld	ra,56(sp)
    80004588:	7442                	ld	s0,48(sp)
    8000458a:	74a2                	ld	s1,40(sp)
    8000458c:	6121                	addi	sp,sp,64
    8000458e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004590:	85d6                	mv	a1,s5
    80004592:	8552                	mv	a0,s4
    80004594:	340000ef          	jal	800048d4 <pipeclose>
    80004598:	7902                	ld	s2,32(sp)
    8000459a:	69e2                	ld	s3,24(sp)
    8000459c:	6a42                	ld	s4,16(sp)
    8000459e:	6aa2                	ld	s5,8(sp)
    800045a0:	b7dd                	j	80004586 <fileclose+0x8a>
    begin_op();
    800045a2:	b49ff0ef          	jal	800040ea <begin_op>
    iput(ff.ip);
    800045a6:	854e                	mv	a0,s3
    800045a8:	ac0ff0ef          	jal	80003868 <iput>
    end_op();
    800045ac:	ba9ff0ef          	jal	80004154 <end_op>
    800045b0:	7902                	ld	s2,32(sp)
    800045b2:	69e2                	ld	s3,24(sp)
    800045b4:	6a42                	ld	s4,16(sp)
    800045b6:	6aa2                	ld	s5,8(sp)
    800045b8:	b7f9                	j	80004586 <fileclose+0x8a>

00000000800045ba <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800045ba:	715d                	addi	sp,sp,-80
    800045bc:	e486                	sd	ra,72(sp)
    800045be:	e0a2                	sd	s0,64(sp)
    800045c0:	fc26                	sd	s1,56(sp)
    800045c2:	f44e                	sd	s3,40(sp)
    800045c4:	0880                	addi	s0,sp,80
    800045c6:	84aa                	mv	s1,a0
    800045c8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800045ca:	af4fd0ef          	jal	800018be <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800045ce:	409c                	lw	a5,0(s1)
    800045d0:	37f9                	addiw	a5,a5,-2
    800045d2:	4705                	li	a4,1
    800045d4:	04f76263          	bltu	a4,a5,80004618 <filestat+0x5e>
    800045d8:	f84a                	sd	s2,48(sp)
    800045da:	f052                	sd	s4,32(sp)
    800045dc:	892a                	mv	s2,a0
    ilock(f->ip);
    800045de:	6c88                	ld	a0,24(s1)
    800045e0:	906ff0ef          	jal	800036e6 <ilock>
    stati(f->ip, &st);
    800045e4:	fb840a13          	addi	s4,s0,-72
    800045e8:	85d2                	mv	a1,s4
    800045ea:	6c88                	ld	a0,24(s1)
    800045ec:	c5eff0ef          	jal	80003a4a <stati>
    iunlock(f->ip);
    800045f0:	6c88                	ld	a0,24(s1)
    800045f2:	9a2ff0ef          	jal	80003794 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800045f6:	46e1                	li	a3,24
    800045f8:	8652                	mv	a2,s4
    800045fa:	85ce                	mv	a1,s3
    800045fc:	05893503          	ld	a0,88(s2)
    80004600:	ff1fc0ef          	jal	800015f0 <copyout>
    80004604:	41f5551b          	sraiw	a0,a0,0x1f
    80004608:	7942                	ld	s2,48(sp)
    8000460a:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000460c:	60a6                	ld	ra,72(sp)
    8000460e:	6406                	ld	s0,64(sp)
    80004610:	74e2                	ld	s1,56(sp)
    80004612:	79a2                	ld	s3,40(sp)
    80004614:	6161                	addi	sp,sp,80
    80004616:	8082                	ret
  return -1;
    80004618:	557d                	li	a0,-1
    8000461a:	bfcd                	j	8000460c <filestat+0x52>

000000008000461c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000461c:	7179                	addi	sp,sp,-48
    8000461e:	f406                	sd	ra,40(sp)
    80004620:	f022                	sd	s0,32(sp)
    80004622:	e84a                	sd	s2,16(sp)
    80004624:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004626:	00854783          	lbu	a5,8(a0)
    8000462a:	cfd1                	beqz	a5,800046c6 <fileread+0xaa>
    8000462c:	ec26                	sd	s1,24(sp)
    8000462e:	e44e                	sd	s3,8(sp)
    80004630:	84aa                	mv	s1,a0
    80004632:	89ae                	mv	s3,a1
    80004634:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004636:	411c                	lw	a5,0(a0)
    80004638:	4705                	li	a4,1
    8000463a:	04e78363          	beq	a5,a4,80004680 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000463e:	470d                	li	a4,3
    80004640:	04e78763          	beq	a5,a4,8000468e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004644:	4709                	li	a4,2
    80004646:	06e79a63          	bne	a5,a4,800046ba <fileread+0x9e>
    ilock(f->ip);
    8000464a:	6d08                	ld	a0,24(a0)
    8000464c:	89aff0ef          	jal	800036e6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004650:	874a                	mv	a4,s2
    80004652:	5094                	lw	a3,32(s1)
    80004654:	864e                	mv	a2,s3
    80004656:	4585                	li	a1,1
    80004658:	6c88                	ld	a0,24(s1)
    8000465a:	c1eff0ef          	jal	80003a78 <readi>
    8000465e:	892a                	mv	s2,a0
    80004660:	00a05563          	blez	a0,8000466a <fileread+0x4e>
      f->off += r;
    80004664:	509c                	lw	a5,32(s1)
    80004666:	9fa9                	addw	a5,a5,a0
    80004668:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000466a:	6c88                	ld	a0,24(s1)
    8000466c:	928ff0ef          	jal	80003794 <iunlock>
    80004670:	64e2                	ld	s1,24(sp)
    80004672:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004674:	854a                	mv	a0,s2
    80004676:	70a2                	ld	ra,40(sp)
    80004678:	7402                	ld	s0,32(sp)
    8000467a:	6942                	ld	s2,16(sp)
    8000467c:	6145                	addi	sp,sp,48
    8000467e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004680:	6908                	ld	a0,16(a0)
    80004682:	3a2000ef          	jal	80004a24 <piperead>
    80004686:	892a                	mv	s2,a0
    80004688:	64e2                	ld	s1,24(sp)
    8000468a:	69a2                	ld	s3,8(sp)
    8000468c:	b7e5                	j	80004674 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000468e:	02451783          	lh	a5,36(a0)
    80004692:	03079693          	slli	a3,a5,0x30
    80004696:	92c1                	srli	a3,a3,0x30
    80004698:	4725                	li	a4,9
    8000469a:	02d76863          	bltu	a4,a3,800046ca <fileread+0xae>
    8000469e:	0792                	slli	a5,a5,0x4
    800046a0:	0001b717          	auipc	a4,0x1b
    800046a4:	75070713          	addi	a4,a4,1872 # 8001fdf0 <devsw>
    800046a8:	97ba                	add	a5,a5,a4
    800046aa:	639c                	ld	a5,0(a5)
    800046ac:	c39d                	beqz	a5,800046d2 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800046ae:	4505                	li	a0,1
    800046b0:	9782                	jalr	a5
    800046b2:	892a                	mv	s2,a0
    800046b4:	64e2                	ld	s1,24(sp)
    800046b6:	69a2                	ld	s3,8(sp)
    800046b8:	bf75                	j	80004674 <fileread+0x58>
    panic("fileread");
    800046ba:	00003517          	auipc	a0,0x3
    800046be:	ebe50513          	addi	a0,a0,-322 # 80007578 <etext+0x578>
    800046c2:	91cfc0ef          	jal	800007de <panic>
    return -1;
    800046c6:	597d                	li	s2,-1
    800046c8:	b775                	j	80004674 <fileread+0x58>
      return -1;
    800046ca:	597d                	li	s2,-1
    800046cc:	64e2                	ld	s1,24(sp)
    800046ce:	69a2                	ld	s3,8(sp)
    800046d0:	b755                	j	80004674 <fileread+0x58>
    800046d2:	597d                	li	s2,-1
    800046d4:	64e2                	ld	s1,24(sp)
    800046d6:	69a2                	ld	s3,8(sp)
    800046d8:	bf71                	j	80004674 <fileread+0x58>

00000000800046da <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800046da:	00954783          	lbu	a5,9(a0)
    800046de:	10078e63          	beqz	a5,800047fa <filewrite+0x120>
{
    800046e2:	711d                	addi	sp,sp,-96
    800046e4:	ec86                	sd	ra,88(sp)
    800046e6:	e8a2                	sd	s0,80(sp)
    800046e8:	e0ca                	sd	s2,64(sp)
    800046ea:	f456                	sd	s5,40(sp)
    800046ec:	f05a                	sd	s6,32(sp)
    800046ee:	1080                	addi	s0,sp,96
    800046f0:	892a                	mv	s2,a0
    800046f2:	8b2e                	mv	s6,a1
    800046f4:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800046f6:	411c                	lw	a5,0(a0)
    800046f8:	4705                	li	a4,1
    800046fa:	02e78963          	beq	a5,a4,8000472c <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046fe:	470d                	li	a4,3
    80004700:	02e78a63          	beq	a5,a4,80004734 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004704:	4709                	li	a4,2
    80004706:	0ce79e63          	bne	a5,a4,800047e2 <filewrite+0x108>
    8000470a:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000470c:	0ac05963          	blez	a2,800047be <filewrite+0xe4>
    80004710:	e4a6                	sd	s1,72(sp)
    80004712:	fc4e                	sd	s3,56(sp)
    80004714:	ec5e                	sd	s7,24(sp)
    80004716:	e862                	sd	s8,16(sp)
    80004718:	e466                	sd	s9,8(sp)
    int i = 0;
    8000471a:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    8000471c:	6b85                	lui	s7,0x1
    8000471e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004722:	6c85                	lui	s9,0x1
    80004724:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004728:	4c05                	li	s8,1
    8000472a:	a8ad                	j	800047a4 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    8000472c:	6908                	ld	a0,16(a0)
    8000472e:	1fe000ef          	jal	8000492c <pipewrite>
    80004732:	a04d                	j	800047d4 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004734:	02451783          	lh	a5,36(a0)
    80004738:	03079693          	slli	a3,a5,0x30
    8000473c:	92c1                	srli	a3,a3,0x30
    8000473e:	4725                	li	a4,9
    80004740:	0ad76f63          	bltu	a4,a3,800047fe <filewrite+0x124>
    80004744:	0792                	slli	a5,a5,0x4
    80004746:	0001b717          	auipc	a4,0x1b
    8000474a:	6aa70713          	addi	a4,a4,1706 # 8001fdf0 <devsw>
    8000474e:	97ba                	add	a5,a5,a4
    80004750:	679c                	ld	a5,8(a5)
    80004752:	cbc5                	beqz	a5,80004802 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80004754:	4505                	li	a0,1
    80004756:	9782                	jalr	a5
    80004758:	a8b5                	j	800047d4 <filewrite+0xfa>
      if(n1 > max)
    8000475a:	2981                	sext.w	s3,s3
      begin_op();
    8000475c:	98fff0ef          	jal	800040ea <begin_op>
      ilock(f->ip);
    80004760:	01893503          	ld	a0,24(s2)
    80004764:	f83fe0ef          	jal	800036e6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004768:	874e                	mv	a4,s3
    8000476a:	02092683          	lw	a3,32(s2)
    8000476e:	016a0633          	add	a2,s4,s6
    80004772:	85e2                	mv	a1,s8
    80004774:	01893503          	ld	a0,24(s2)
    80004778:	bf2ff0ef          	jal	80003b6a <writei>
    8000477c:	84aa                	mv	s1,a0
    8000477e:	00a05763          	blez	a0,8000478c <filewrite+0xb2>
        f->off += r;
    80004782:	02092783          	lw	a5,32(s2)
    80004786:	9fa9                	addw	a5,a5,a0
    80004788:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000478c:	01893503          	ld	a0,24(s2)
    80004790:	804ff0ef          	jal	80003794 <iunlock>
      end_op();
    80004794:	9c1ff0ef          	jal	80004154 <end_op>

      if(r != n1){
    80004798:	02999563          	bne	s3,s1,800047c2 <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    8000479c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800047a0:	015a5963          	bge	s4,s5,800047b2 <filewrite+0xd8>
      int n1 = n - i;
    800047a4:	414a87bb          	subw	a5,s5,s4
    800047a8:	89be                	mv	s3,a5
      if(n1 > max)
    800047aa:	fafbd8e3          	bge	s7,a5,8000475a <filewrite+0x80>
    800047ae:	89e6                	mv	s3,s9
    800047b0:	b76d                	j	8000475a <filewrite+0x80>
    800047b2:	64a6                	ld	s1,72(sp)
    800047b4:	79e2                	ld	s3,56(sp)
    800047b6:	6be2                	ld	s7,24(sp)
    800047b8:	6c42                	ld	s8,16(sp)
    800047ba:	6ca2                	ld	s9,8(sp)
    800047bc:	a801                	j	800047cc <filewrite+0xf2>
    int i = 0;
    800047be:	4a01                	li	s4,0
    800047c0:	a031                	j	800047cc <filewrite+0xf2>
    800047c2:	64a6                	ld	s1,72(sp)
    800047c4:	79e2                	ld	s3,56(sp)
    800047c6:	6be2                	ld	s7,24(sp)
    800047c8:	6c42                	ld	s8,16(sp)
    800047ca:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800047cc:	034a9d63          	bne	s5,s4,80004806 <filewrite+0x12c>
    800047d0:	8556                	mv	a0,s5
    800047d2:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800047d4:	60e6                	ld	ra,88(sp)
    800047d6:	6446                	ld	s0,80(sp)
    800047d8:	6906                	ld	s2,64(sp)
    800047da:	7aa2                	ld	s5,40(sp)
    800047dc:	7b02                	ld	s6,32(sp)
    800047de:	6125                	addi	sp,sp,96
    800047e0:	8082                	ret
    800047e2:	e4a6                	sd	s1,72(sp)
    800047e4:	fc4e                	sd	s3,56(sp)
    800047e6:	f852                	sd	s4,48(sp)
    800047e8:	ec5e                	sd	s7,24(sp)
    800047ea:	e862                	sd	s8,16(sp)
    800047ec:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800047ee:	00003517          	auipc	a0,0x3
    800047f2:	d9a50513          	addi	a0,a0,-614 # 80007588 <etext+0x588>
    800047f6:	fe9fb0ef          	jal	800007de <panic>
    return -1;
    800047fa:	557d                	li	a0,-1
}
    800047fc:	8082                	ret
      return -1;
    800047fe:	557d                	li	a0,-1
    80004800:	bfd1                	j	800047d4 <filewrite+0xfa>
    80004802:	557d                	li	a0,-1
    80004804:	bfc1                	j	800047d4 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    80004806:	557d                	li	a0,-1
    80004808:	7a42                	ld	s4,48(sp)
    8000480a:	b7e9                	j	800047d4 <filewrite+0xfa>

000000008000480c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000480c:	7179                	addi	sp,sp,-48
    8000480e:	f406                	sd	ra,40(sp)
    80004810:	f022                	sd	s0,32(sp)
    80004812:	ec26                	sd	s1,24(sp)
    80004814:	e052                	sd	s4,0(sp)
    80004816:	1800                	addi	s0,sp,48
    80004818:	84aa                	mv	s1,a0
    8000481a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000481c:	0005b023          	sd	zero,0(a1)
    80004820:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004824:	c35ff0ef          	jal	80004458 <filealloc>
    80004828:	e088                	sd	a0,0(s1)
    8000482a:	c549                	beqz	a0,800048b4 <pipealloc+0xa8>
    8000482c:	c2dff0ef          	jal	80004458 <filealloc>
    80004830:	00aa3023          	sd	a0,0(s4)
    80004834:	cd25                	beqz	a0,800048ac <pipealloc+0xa0>
    80004836:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004838:	ac0fc0ef          	jal	80000af8 <kalloc>
    8000483c:	892a                	mv	s2,a0
    8000483e:	c12d                	beqz	a0,800048a0 <pipealloc+0x94>
    80004840:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004842:	4985                	li	s3,1
    80004844:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004848:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000484c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004850:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004854:	00003597          	auipc	a1,0x3
    80004858:	d4458593          	addi	a1,a1,-700 # 80007598 <etext+0x598>
    8000485c:	aecfc0ef          	jal	80000b48 <initlock>
  (*f0)->type = FD_PIPE;
    80004860:	609c                	ld	a5,0(s1)
    80004862:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004866:	609c                	ld	a5,0(s1)
    80004868:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000486c:	609c                	ld	a5,0(s1)
    8000486e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004872:	609c                	ld	a5,0(s1)
    80004874:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004878:	000a3783          	ld	a5,0(s4)
    8000487c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004880:	000a3783          	ld	a5,0(s4)
    80004884:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004888:	000a3783          	ld	a5,0(s4)
    8000488c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004890:	000a3783          	ld	a5,0(s4)
    80004894:	0127b823          	sd	s2,16(a5)
  return 0;
    80004898:	4501                	li	a0,0
    8000489a:	6942                	ld	s2,16(sp)
    8000489c:	69a2                	ld	s3,8(sp)
    8000489e:	a01d                	j	800048c4 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800048a0:	6088                	ld	a0,0(s1)
    800048a2:	c119                	beqz	a0,800048a8 <pipealloc+0x9c>
    800048a4:	6942                	ld	s2,16(sp)
    800048a6:	a029                	j	800048b0 <pipealloc+0xa4>
    800048a8:	6942                	ld	s2,16(sp)
    800048aa:	a029                	j	800048b4 <pipealloc+0xa8>
    800048ac:	6088                	ld	a0,0(s1)
    800048ae:	c10d                	beqz	a0,800048d0 <pipealloc+0xc4>
    fileclose(*f0);
    800048b0:	c4dff0ef          	jal	800044fc <fileclose>
  if(*f1)
    800048b4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800048b8:	557d                	li	a0,-1
  if(*f1)
    800048ba:	c789                	beqz	a5,800048c4 <pipealloc+0xb8>
    fileclose(*f1);
    800048bc:	853e                	mv	a0,a5
    800048be:	c3fff0ef          	jal	800044fc <fileclose>
  return -1;
    800048c2:	557d                	li	a0,-1
}
    800048c4:	70a2                	ld	ra,40(sp)
    800048c6:	7402                	ld	s0,32(sp)
    800048c8:	64e2                	ld	s1,24(sp)
    800048ca:	6a02                	ld	s4,0(sp)
    800048cc:	6145                	addi	sp,sp,48
    800048ce:	8082                	ret
  return -1;
    800048d0:	557d                	li	a0,-1
    800048d2:	bfcd                	j	800048c4 <pipealloc+0xb8>

00000000800048d4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800048d4:	1101                	addi	sp,sp,-32
    800048d6:	ec06                	sd	ra,24(sp)
    800048d8:	e822                	sd	s0,16(sp)
    800048da:	e426                	sd	s1,8(sp)
    800048dc:	e04a                	sd	s2,0(sp)
    800048de:	1000                	addi	s0,sp,32
    800048e0:	84aa                	mv	s1,a0
    800048e2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800048e4:	ae8fc0ef          	jal	80000bcc <acquire>
  if(writable){
    800048e8:	02090763          	beqz	s2,80004916 <pipeclose+0x42>
    pi->writeopen = 0;
    800048ec:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800048f0:	21848513          	addi	a0,s1,536
    800048f4:	e80fd0ef          	jal	80001f74 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048f8:	2204b783          	ld	a5,544(s1)
    800048fc:	e785                	bnez	a5,80004924 <pipeclose+0x50>
    release(&pi->lock);
    800048fe:	8526                	mv	a0,s1
    80004900:	b60fc0ef          	jal	80000c60 <release>
    kfree((char*)pi);
    80004904:	8526                	mv	a0,s1
    80004906:	910fc0ef          	jal	80000a16 <kfree>
  } else
    release(&pi->lock);
}
    8000490a:	60e2                	ld	ra,24(sp)
    8000490c:	6442                	ld	s0,16(sp)
    8000490e:	64a2                	ld	s1,8(sp)
    80004910:	6902                	ld	s2,0(sp)
    80004912:	6105                	addi	sp,sp,32
    80004914:	8082                	ret
    pi->readopen = 0;
    80004916:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000491a:	21c48513          	addi	a0,s1,540
    8000491e:	e56fd0ef          	jal	80001f74 <wakeup>
    80004922:	bfd9                	j	800048f8 <pipeclose+0x24>
    release(&pi->lock);
    80004924:	8526                	mv	a0,s1
    80004926:	b3afc0ef          	jal	80000c60 <release>
}
    8000492a:	b7c5                	j	8000490a <pipeclose+0x36>

000000008000492c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000492c:	7159                	addi	sp,sp,-112
    8000492e:	f486                	sd	ra,104(sp)
    80004930:	f0a2                	sd	s0,96(sp)
    80004932:	eca6                	sd	s1,88(sp)
    80004934:	e8ca                	sd	s2,80(sp)
    80004936:	e4ce                	sd	s3,72(sp)
    80004938:	e0d2                	sd	s4,64(sp)
    8000493a:	fc56                	sd	s5,56(sp)
    8000493c:	1880                	addi	s0,sp,112
    8000493e:	84aa                	mv	s1,a0
    80004940:	8aae                	mv	s5,a1
    80004942:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004944:	f7bfc0ef          	jal	800018be <myproc>
    80004948:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000494a:	8526                	mv	a0,s1
    8000494c:	a80fc0ef          	jal	80000bcc <acquire>
  while(i < n){
    80004950:	0d405263          	blez	s4,80004a14 <pipewrite+0xe8>
    80004954:	f85a                	sd	s6,48(sp)
    80004956:	f45e                	sd	s7,40(sp)
    80004958:	f062                	sd	s8,32(sp)
    8000495a:	ec66                	sd	s9,24(sp)
    8000495c:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000495e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004960:	f9f40c13          	addi	s8,s0,-97
    80004964:	4b85                	li	s7,1
    80004966:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004968:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000496c:	21c48c93          	addi	s9,s1,540
    80004970:	a82d                	j	800049aa <pipewrite+0x7e>
      release(&pi->lock);
    80004972:	8526                	mv	a0,s1
    80004974:	aecfc0ef          	jal	80000c60 <release>
      return -1;
    80004978:	597d                	li	s2,-1
    8000497a:	7b42                	ld	s6,48(sp)
    8000497c:	7ba2                	ld	s7,40(sp)
    8000497e:	7c02                	ld	s8,32(sp)
    80004980:	6ce2                	ld	s9,24(sp)
    80004982:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004984:	854a                	mv	a0,s2
    80004986:	70a6                	ld	ra,104(sp)
    80004988:	7406                	ld	s0,96(sp)
    8000498a:	64e6                	ld	s1,88(sp)
    8000498c:	6946                	ld	s2,80(sp)
    8000498e:	69a6                	ld	s3,72(sp)
    80004990:	6a06                	ld	s4,64(sp)
    80004992:	7ae2                	ld	s5,56(sp)
    80004994:	6165                	addi	sp,sp,112
    80004996:	8082                	ret
      wakeup(&pi->nread);
    80004998:	856a                	mv	a0,s10
    8000499a:	ddafd0ef          	jal	80001f74 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000499e:	85a6                	mv	a1,s1
    800049a0:	8566                	mv	a0,s9
    800049a2:	d86fd0ef          	jal	80001f28 <sleep>
  while(i < n){
    800049a6:	05495a63          	bge	s2,s4,800049fa <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800049aa:	2204a783          	lw	a5,544(s1)
    800049ae:	d3f1                	beqz	a5,80004972 <pipewrite+0x46>
    800049b0:	854e                	mv	a0,s3
    800049b2:	817fd0ef          	jal	800021c8 <killed>
    800049b6:	fd55                	bnez	a0,80004972 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800049b8:	2184a783          	lw	a5,536(s1)
    800049bc:	21c4a703          	lw	a4,540(s1)
    800049c0:	2007879b          	addiw	a5,a5,512
    800049c4:	fcf70ae3          	beq	a4,a5,80004998 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800049c8:	86de                	mv	a3,s7
    800049ca:	01590633          	add	a2,s2,s5
    800049ce:	85e2                	mv	a1,s8
    800049d0:	0589b503          	ld	a0,88(s3)
    800049d4:	cdbfc0ef          	jal	800016ae <copyin>
    800049d8:	05650063          	beq	a0,s6,80004a18 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800049dc:	21c4a783          	lw	a5,540(s1)
    800049e0:	0017871b          	addiw	a4,a5,1
    800049e4:	20e4ae23          	sw	a4,540(s1)
    800049e8:	1ff7f793          	andi	a5,a5,511
    800049ec:	97a6                	add	a5,a5,s1
    800049ee:	f9f44703          	lbu	a4,-97(s0)
    800049f2:	00e78c23          	sb	a4,24(a5)
      i++;
    800049f6:	2905                	addiw	s2,s2,1
    800049f8:	b77d                	j	800049a6 <pipewrite+0x7a>
    800049fa:	7b42                	ld	s6,48(sp)
    800049fc:	7ba2                	ld	s7,40(sp)
    800049fe:	7c02                	ld	s8,32(sp)
    80004a00:	6ce2                	ld	s9,24(sp)
    80004a02:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004a04:	21848513          	addi	a0,s1,536
    80004a08:	d6cfd0ef          	jal	80001f74 <wakeup>
  release(&pi->lock);
    80004a0c:	8526                	mv	a0,s1
    80004a0e:	a52fc0ef          	jal	80000c60 <release>
  return i;
    80004a12:	bf8d                	j	80004984 <pipewrite+0x58>
  int i = 0;
    80004a14:	4901                	li	s2,0
    80004a16:	b7fd                	j	80004a04 <pipewrite+0xd8>
    80004a18:	7b42                	ld	s6,48(sp)
    80004a1a:	7ba2                	ld	s7,40(sp)
    80004a1c:	7c02                	ld	s8,32(sp)
    80004a1e:	6ce2                	ld	s9,24(sp)
    80004a20:	6d42                	ld	s10,16(sp)
    80004a22:	b7cd                	j	80004a04 <pipewrite+0xd8>

0000000080004a24 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004a24:	711d                	addi	sp,sp,-96
    80004a26:	ec86                	sd	ra,88(sp)
    80004a28:	e8a2                	sd	s0,80(sp)
    80004a2a:	e4a6                	sd	s1,72(sp)
    80004a2c:	e0ca                	sd	s2,64(sp)
    80004a2e:	fc4e                	sd	s3,56(sp)
    80004a30:	f852                	sd	s4,48(sp)
    80004a32:	f456                	sd	s5,40(sp)
    80004a34:	1080                	addi	s0,sp,96
    80004a36:	84aa                	mv	s1,a0
    80004a38:	892e                	mv	s2,a1
    80004a3a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004a3c:	e83fc0ef          	jal	800018be <myproc>
    80004a40:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004a42:	8526                	mv	a0,s1
    80004a44:	988fc0ef          	jal	80000bcc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a48:	2184a703          	lw	a4,536(s1)
    80004a4c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a50:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a54:	02f71763          	bne	a4,a5,80004a82 <piperead+0x5e>
    80004a58:	2244a783          	lw	a5,548(s1)
    80004a5c:	cf85                	beqz	a5,80004a94 <piperead+0x70>
    if(killed(pr)){
    80004a5e:	8552                	mv	a0,s4
    80004a60:	f68fd0ef          	jal	800021c8 <killed>
    80004a64:	e11d                	bnez	a0,80004a8a <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a66:	85a6                	mv	a1,s1
    80004a68:	854e                	mv	a0,s3
    80004a6a:	cbefd0ef          	jal	80001f28 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a6e:	2184a703          	lw	a4,536(s1)
    80004a72:	21c4a783          	lw	a5,540(s1)
    80004a76:	fef701e3          	beq	a4,a5,80004a58 <piperead+0x34>
    80004a7a:	f05a                	sd	s6,32(sp)
    80004a7c:	ec5e                	sd	s7,24(sp)
    80004a7e:	e862                	sd	s8,16(sp)
    80004a80:	a829                	j	80004a9a <piperead+0x76>
    80004a82:	f05a                	sd	s6,32(sp)
    80004a84:	ec5e                	sd	s7,24(sp)
    80004a86:	e862                	sd	s8,16(sp)
    80004a88:	a809                	j	80004a9a <piperead+0x76>
      release(&pi->lock);
    80004a8a:	8526                	mv	a0,s1
    80004a8c:	9d4fc0ef          	jal	80000c60 <release>
      return -1;
    80004a90:	59fd                	li	s3,-1
    80004a92:	a0ad                	j	80004afc <piperead+0xd8>
    80004a94:	f05a                	sd	s6,32(sp)
    80004a96:	ec5e                	sd	s7,24(sp)
    80004a98:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a9a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004a9c:	faf40c13          	addi	s8,s0,-81
    80004aa0:	4b85                	li	s7,1
    80004aa2:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004aa4:	05505263          	blez	s5,80004ae8 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004aa8:	2184a783          	lw	a5,536(s1)
    80004aac:	21c4a703          	lw	a4,540(s1)
    80004ab0:	02f70c63          	beq	a4,a5,80004ae8 <piperead+0xc4>
    ch = pi->data[pi->nread % PIPESIZE];
    80004ab4:	1ff7f793          	andi	a5,a5,511
    80004ab8:	97a6                	add	a5,a5,s1
    80004aba:	0187c783          	lbu	a5,24(a5)
    80004abe:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004ac2:	86de                	mv	a3,s7
    80004ac4:	8662                	mv	a2,s8
    80004ac6:	85ca                	mv	a1,s2
    80004ac8:	058a3503          	ld	a0,88(s4)
    80004acc:	b25fc0ef          	jal	800015f0 <copyout>
    80004ad0:	05650063          	beq	a0,s6,80004b10 <piperead+0xec>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80004ad4:	2184a783          	lw	a5,536(s1)
    80004ad8:	2785                	addiw	a5,a5,1
    80004ada:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ade:	2985                	addiw	s3,s3,1
    80004ae0:	0905                	addi	s2,s2,1
    80004ae2:	fd3a93e3          	bne	s5,s3,80004aa8 <piperead+0x84>
    80004ae6:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004ae8:	21c48513          	addi	a0,s1,540
    80004aec:	c88fd0ef          	jal	80001f74 <wakeup>
  release(&pi->lock);
    80004af0:	8526                	mv	a0,s1
    80004af2:	96efc0ef          	jal	80000c60 <release>
    80004af6:	7b02                	ld	s6,32(sp)
    80004af8:	6be2                	ld	s7,24(sp)
    80004afa:	6c42                	ld	s8,16(sp)
  return i;
}
    80004afc:	854e                	mv	a0,s3
    80004afe:	60e6                	ld	ra,88(sp)
    80004b00:	6446                	ld	s0,80(sp)
    80004b02:	64a6                	ld	s1,72(sp)
    80004b04:	6906                	ld	s2,64(sp)
    80004b06:	79e2                	ld	s3,56(sp)
    80004b08:	7a42                	ld	s4,48(sp)
    80004b0a:	7aa2                	ld	s5,40(sp)
    80004b0c:	6125                	addi	sp,sp,96
    80004b0e:	8082                	ret
      if(i == 0)
    80004b10:	fc099ce3          	bnez	s3,80004ae8 <piperead+0xc4>
        i = -1;
    80004b14:	89aa                	mv	s3,a0
    80004b16:	bfc9                	j	80004ae8 <piperead+0xc4>

0000000080004b18 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004b18:	1141                	addi	sp,sp,-16
    80004b1a:	e406                	sd	ra,8(sp)
    80004b1c:	e022                	sd	s0,0(sp)
    80004b1e:	0800                	addi	s0,sp,16
    80004b20:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004b22:	0035151b          	slliw	a0,a0,0x3
    80004b26:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80004b28:	8b89                	andi	a5,a5,2
    80004b2a:	c399                	beqz	a5,80004b30 <flags2perm+0x18>
      perm |= PTE_W;
    80004b2c:	00456513          	ori	a0,a0,4
    return perm;
}
    80004b30:	60a2                	ld	ra,8(sp)
    80004b32:	6402                	ld	s0,0(sp)
    80004b34:	0141                	addi	sp,sp,16
    80004b36:	8082                	ret

0000000080004b38 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004b38:	de010113          	addi	sp,sp,-544
    80004b3c:	20113c23          	sd	ra,536(sp)
    80004b40:	20813823          	sd	s0,528(sp)
    80004b44:	20913423          	sd	s1,520(sp)
    80004b48:	1400                	addi	s0,sp,544
    80004b4a:	84aa                	mv	s1,a0
    80004b4c:	dea43823          	sd	a0,-528(s0)
    80004b50:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004b54:	d6bfc0ef          	jal	800018be <myproc>

  // If threads being used, cannot do exec()
  if (p->pid != p->tgid || p->thread_count > 1)
    80004b58:	5918                	lw	a4,48(a0)
    80004b5a:	595c                	lw	a5,52(a0)
    80004b5c:	34f71e63          	bne	a4,a5,80004eb8 <kexec+0x380>
    80004b60:	e3ea                	sd	s10,448(sp)
    80004b62:	8d2a                	mv	s10,a0
    80004b64:	5d18                	lw	a4,56(a0)
    80004b66:	4785                	li	a5,1
    80004b68:	34e7ca63          	blt	a5,a4,80004ebc <kexec+0x384>
    80004b6c:	fbd2                	sd	s4,496(sp)
    return -1;

  begin_op();
    80004b6e:	d7cff0ef          	jal	800040ea <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80004b72:	8526                	mv	a0,s1
    80004b74:	b9cff0ef          	jal	80003f10 <namei>
    80004b78:	8a2a                	mv	s4,a0
    80004b7a:	c929                	beqz	a0,80004bcc <kexec+0x94>
    end_op();
    return -1;
  }
  ilock(ip);
    80004b7c:	b6bfe0ef          	jal	800036e6 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004b80:	04000713          	li	a4,64
    80004b84:	4681                	li	a3,0
    80004b86:	e5040613          	addi	a2,s0,-432
    80004b8a:	4581                	li	a1,0
    80004b8c:	8552                	mv	a0,s4
    80004b8e:	eebfe0ef          	jal	80003a78 <readi>
    80004b92:	04000793          	li	a5,64
    80004b96:	00f51a63          	bne	a0,a5,80004baa <kexec+0x72>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80004b9a:	e5042703          	lw	a4,-432(s0)
    80004b9e:	464c47b7          	lui	a5,0x464c4
    80004ba2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004ba6:	02f70963          	beq	a4,a5,80004bd8 <kexec+0xa0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz, (int) (p - proc));
  if(ip){
    iunlockput(ip);
    80004baa:	8552                	mv	a0,s4
    80004bac:	d45fe0ef          	jal	800038f0 <iunlockput>
    end_op();
    80004bb0:	da4ff0ef          	jal	80004154 <end_op>
  }
  return -1;
    80004bb4:	557d                	li	a0,-1
    80004bb6:	7a5e                	ld	s4,496(sp)
    80004bb8:	6d1e                	ld	s10,448(sp)
}
    80004bba:	21813083          	ld	ra,536(sp)
    80004bbe:	21013403          	ld	s0,528(sp)
    80004bc2:	20813483          	ld	s1,520(sp)
    80004bc6:	22010113          	addi	sp,sp,544
    80004bca:	8082                	ret
    end_op();
    80004bcc:	d88ff0ef          	jal	80004154 <end_op>
    return -1;
    80004bd0:	557d                	li	a0,-1
    80004bd2:	7a5e                	ld	s4,496(sp)
    80004bd4:	6d1e                	ld	s10,448(sp)
    80004bd6:	b7d5                	j	80004bba <kexec+0x82>
    80004bd8:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004bda:	856a                	mv	a0,s10
    80004bdc:	de9fc0ef          	jal	800019c4 <proc_pagetable>
    80004be0:	8b2a                	mv	s6,a0
    80004be2:	2c050963          	beqz	a0,80004eb4 <kexec+0x37c>
    80004be6:	21213023          	sd	s2,512(sp)
    80004bea:	ffce                	sd	s3,504(sp)
    80004bec:	f7d6                	sd	s5,488(sp)
    80004bee:	efde                	sd	s7,472(sp)
    80004bf0:	ebe2                	sd	s8,464(sp)
    80004bf2:	e7e6                	sd	s9,456(sp)
    80004bf4:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bf6:	e7042683          	lw	a3,-400(s0)
    80004bfa:	e8845783          	lhu	a5,-376(s0)
    80004bfe:	0e078863          	beqz	a5,80004cee <kexec+0x1b6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004c02:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c04:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004c06:	6c85                	lui	s9,0x1
    80004c08:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004c0c:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004c10:	6a85                	lui	s5,0x1
    80004c12:	a085                	j	80004c72 <kexec+0x13a>
      panic("loadseg: address should exist");
    80004c14:	00003517          	auipc	a0,0x3
    80004c18:	98c50513          	addi	a0,a0,-1652 # 800075a0 <etext+0x5a0>
    80004c1c:	bc3fb0ef          	jal	800007de <panic>
    if(sz - i < PGSIZE)
    80004c20:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004c22:	874a                	mv	a4,s2
    80004c24:	009c06bb          	addw	a3,s8,s1
    80004c28:	4581                	li	a1,0
    80004c2a:	8552                	mv	a0,s4
    80004c2c:	e4dfe0ef          	jal	80003a78 <readi>
    80004c30:	28a91b63          	bne	s2,a0,80004ec6 <kexec+0x38e>
  for(i = 0; i < sz; i += PGSIZE){
    80004c34:	009a84bb          	addw	s1,s5,s1
    80004c38:	0334f263          	bgeu	s1,s3,80004c5c <kexec+0x124>
    pa = walkaddr(pagetable, va + i);
    80004c3c:	02049593          	slli	a1,s1,0x20
    80004c40:	9181                	srli	a1,a1,0x20
    80004c42:	95de                	add	a1,a1,s7
    80004c44:	855a                	mv	a0,s6
    80004c46:	b84fc0ef          	jal	80000fca <walkaddr>
    80004c4a:	862a                	mv	a2,a0
    if(pa == 0)
    80004c4c:	d561                	beqz	a0,80004c14 <kexec+0xdc>
    if(sz - i < PGSIZE)
    80004c4e:	409987bb          	subw	a5,s3,s1
    80004c52:	893e                	mv	s2,a5
    80004c54:	fcfcf6e3          	bgeu	s9,a5,80004c20 <kexec+0xe8>
    80004c58:	8956                	mv	s2,s5
    80004c5a:	b7d9                	j	80004c20 <kexec+0xe8>
    sz = sz1;
    80004c5c:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c60:	2d85                	addiw	s11,s11,1
    80004c62:	e0843783          	ld	a5,-504(s0)
    80004c66:	0387869b          	addiw	a3,a5,56
    80004c6a:	e8845783          	lhu	a5,-376(s0)
    80004c6e:	08fdd163          	bge	s11,a5,80004cf0 <kexec+0x1b8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004c72:	e0d43423          	sd	a3,-504(s0)
    80004c76:	03800713          	li	a4,56
    80004c7a:	e1840613          	addi	a2,s0,-488
    80004c7e:	4581                	li	a1,0
    80004c80:	8552                	mv	a0,s4
    80004c82:	df7fe0ef          	jal	80003a78 <readi>
    80004c86:	03800793          	li	a5,56
    80004c8a:	22f51c63          	bne	a0,a5,80004ec2 <kexec+0x38a>
    if(ph.type != ELF_PROG_LOAD)
    80004c8e:	e1842783          	lw	a5,-488(s0)
    80004c92:	4705                	li	a4,1
    80004c94:	fce796e3          	bne	a5,a4,80004c60 <kexec+0x128>
    if(ph.memsz < ph.filesz)
    80004c98:	e4043483          	ld	s1,-448(s0)
    80004c9c:	e3843783          	ld	a5,-456(s0)
    80004ca0:	26f4e563          	bltu	s1,a5,80004f0a <kexec+0x3d2>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004ca4:	e2843783          	ld	a5,-472(s0)
    80004ca8:	94be                	add	s1,s1,a5
    80004caa:	26f4e363          	bltu	s1,a5,80004f10 <kexec+0x3d8>
    if(ph.vaddr % PGSIZE != 0)
    80004cae:	de843703          	ld	a4,-536(s0)
    80004cb2:	8ff9                	and	a5,a5,a4
    80004cb4:	26079163          	bnez	a5,80004f16 <kexec+0x3de>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004cb8:	e1c42503          	lw	a0,-484(s0)
    80004cbc:	e5dff0ef          	jal	80004b18 <flags2perm>
    80004cc0:	86aa                	mv	a3,a0
    80004cc2:	8626                	mv	a2,s1
    80004cc4:	85ca                	mv	a1,s2
    80004cc6:	855a                	mv	a0,s6
    80004cc8:	ddafc0ef          	jal	800012a2 <uvmalloc>
    80004ccc:	dea43c23          	sd	a0,-520(s0)
    80004cd0:	24050663          	beqz	a0,80004f1c <kexec+0x3e4>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004cd4:	e2843b83          	ld	s7,-472(s0)
    80004cd8:	e2042c03          	lw	s8,-480(s0)
    80004cdc:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004ce0:	00098463          	beqz	s3,80004ce8 <kexec+0x1b0>
    80004ce4:	4481                	li	s1,0
    80004ce6:	bf99                	j	80004c3c <kexec+0x104>
    sz = sz1;
    80004ce8:	df843903          	ld	s2,-520(s0)
    80004cec:	bf95                	j	80004c60 <kexec+0x128>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004cee:	4901                	li	s2,0
  iunlockput(ip);
    80004cf0:	8552                	mv	a0,s4
    80004cf2:	bfffe0ef          	jal	800038f0 <iunlockput>
  end_op();
    80004cf6:	c5eff0ef          	jal	80004154 <end_op>
  p = myproc();
    80004cfa:	bc5fc0ef          	jal	800018be <myproc>
    80004cfe:	8a2a                	mv	s4,a0
  uint64 oldsz = p->sz;
    80004d00:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80004d04:	6985                	lui	s3,0x1
    80004d06:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004d08:	99ca                	add	s3,s3,s2
    80004d0a:	77fd                	lui	a5,0xfffff
    80004d0c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004d10:	4691                	li	a3,4
    80004d12:	6609                	lui	a2,0x2
    80004d14:	964e                	add	a2,a2,s3
    80004d16:	85ce                	mv	a1,s3
    80004d18:	855a                	mv	a0,s6
    80004d1a:	d88fc0ef          	jal	800012a2 <uvmalloc>
    80004d1e:	8aaa                	mv	s5,a0
    80004d20:	e529                	bnez	a0,80004d6a <kexec+0x232>
    proc_freepagetable(pagetable, sz, (int) (p - proc));
    80004d22:	0000b797          	auipc	a5,0xb
    80004d26:	08678793          	addi	a5,a5,134 # 8000fda8 <proc>
    80004d2a:	40fa07b3          	sub	a5,s4,a5
    80004d2e:	878d                	srai	a5,a5,0x3
    80004d30:	677d4737          	lui	a4,0x677d4
    80004d34:	6cf70713          	addi	a4,a4,1743 # 677d46cf <_entry-0x1882b931>
    80004d38:	51b3c637          	lui	a2,0x51b3c
    80004d3c:	ea360613          	addi	a2,a2,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80004d40:	1602                	slli	a2,a2,0x20
    80004d42:	963a                	add	a2,a2,a4
    80004d44:	02c7863b          	mulw	a2,a5,a2
    80004d48:	85ce                	mv	a1,s3
    80004d4a:	855a                	mv	a0,s6
    80004d4c:	d2bfc0ef          	jal	80001a76 <proc_freepagetable>
  return -1;
    80004d50:	557d                	li	a0,-1
    80004d52:	20013903          	ld	s2,512(sp)
    80004d56:	79fe                	ld	s3,504(sp)
    80004d58:	7a5e                	ld	s4,496(sp)
    80004d5a:	7abe                	ld	s5,488(sp)
    80004d5c:	7b1e                	ld	s6,480(sp)
    80004d5e:	6bfe                	ld	s7,472(sp)
    80004d60:	6c5e                	ld	s8,464(sp)
    80004d62:	6cbe                	ld	s9,456(sp)
    80004d64:	6d1e                	ld	s10,448(sp)
    80004d66:	7dfa                	ld	s11,440(sp)
    80004d68:	bd89                	j	80004bba <kexec+0x82>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004d6a:	75f9                	lui	a1,0xffffe
    80004d6c:	95aa                	add	a1,a1,a0
    80004d6e:	855a                	mv	a0,s6
    80004d70:	f14fc0ef          	jal	80001484 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004d74:	7bfd                	lui	s7,0xfffff
    80004d76:	9bd6                	add	s7,s7,s5
  for(argc = 0; argv[argc]; argc++) {
    80004d78:	e0043783          	ld	a5,-512(s0)
    80004d7c:	6388                	ld	a0,0(a5)
  sp = sz;
    80004d7e:	8956                	mv	s2,s5
  for(argc = 0; argv[argc]; argc++) {
    80004d80:	4481                	li	s1,0
    ustack[argc] = sp;
    80004d82:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80004d86:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80004d8a:	cd21                	beqz	a0,80004de2 <kexec+0x2aa>
    sp -= strlen(argv[argc]) + 1;
    80004d8c:	898fc0ef          	jal	80000e24 <strlen>
    80004d90:	0015079b          	addiw	a5,a0,1
    80004d94:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004d98:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004d9c:	19796363          	bltu	s2,s7,80004f22 <kexec+0x3ea>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004da0:	e0043d83          	ld	s11,-512(s0)
    80004da4:	000db983          	ld	s3,0(s11)
    80004da8:	854e                	mv	a0,s3
    80004daa:	87afc0ef          	jal	80000e24 <strlen>
    80004dae:	0015069b          	addiw	a3,a0,1
    80004db2:	864e                	mv	a2,s3
    80004db4:	85ca                	mv	a1,s2
    80004db6:	855a                	mv	a0,s6
    80004db8:	839fc0ef          	jal	800015f0 <copyout>
    80004dbc:	16054563          	bltz	a0,80004f26 <kexec+0x3ee>
    ustack[argc] = sp;
    80004dc0:	00349793          	slli	a5,s1,0x3
    80004dc4:	97e6                	add	a5,a5,s9
    80004dc6:	0127b023          	sd	s2,0(a5)
  for(argc = 0; argv[argc]; argc++) {
    80004dca:	0485                	addi	s1,s1,1
    80004dcc:	008d8793          	addi	a5,s11,8
    80004dd0:	e0f43023          	sd	a5,-512(s0)
    80004dd4:	008db503          	ld	a0,8(s11)
    80004dd8:	c509                	beqz	a0,80004de2 <kexec+0x2aa>
    if(argc >= MAXARG)
    80004dda:	fb8499e3          	bne	s1,s8,80004d8c <kexec+0x254>
  sz = sz1;
    80004dde:	89d6                	mv	s3,s5
    80004de0:	b789                	j	80004d22 <kexec+0x1ea>
  ustack[argc] = 0;
    80004de2:	00349793          	slli	a5,s1,0x3
    80004de6:	f9078793          	addi	a5,a5,-112
    80004dea:	97a2                	add	a5,a5,s0
    80004dec:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004df0:	00148693          	addi	a3,s1,1
    80004df4:	068e                	slli	a3,a3,0x3
    80004df6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004dfa:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004dfe:	89d6                	mv	s3,s5
  if(sp < stackbase)
    80004e00:	f37961e3          	bltu	s2,s7,80004d22 <kexec+0x1ea>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004e04:	e9040613          	addi	a2,s0,-368
    80004e08:	85ca                	mv	a1,s2
    80004e0a:	855a                	mv	a0,s6
    80004e0c:	fe4fc0ef          	jal	800015f0 <copyout>
    80004e10:	f00549e3          	bltz	a0,80004d22 <kexec+0x1ea>
  p->trapframe->a1 = sp;
    80004e14:	060a3783          	ld	a5,96(s4)
    80004e18:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004e1c:	df043783          	ld	a5,-528(s0)
    80004e20:	0007c703          	lbu	a4,0(a5)
    80004e24:	cf11                	beqz	a4,80004e40 <kexec+0x308>
    80004e26:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004e28:	02f00693          	li	a3,47
    80004e2c:	a029                	j	80004e36 <kexec+0x2fe>
  for(last=s=path; *s; s++)
    80004e2e:	0785                	addi	a5,a5,1
    80004e30:	fff7c703          	lbu	a4,-1(a5)
    80004e34:	c711                	beqz	a4,80004e40 <kexec+0x308>
    if(*s == '/')
    80004e36:	fed71ce3          	bne	a4,a3,80004e2e <kexec+0x2f6>
      last = s+1;
    80004e3a:	def43823          	sd	a5,-528(s0)
    80004e3e:	bfc5                	j	80004e2e <kexec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004e40:	4641                	li	a2,16
    80004e42:	df043583          	ld	a1,-528(s0)
    80004e46:	160a0513          	addi	a0,s4,352
    80004e4a:	fa5fb0ef          	jal	80000dee <safestrcpy>
  oldpagetable = p->pagetable;
    80004e4e:	058a3503          	ld	a0,88(s4)
  p->pagetable = pagetable;
    80004e52:	056a3c23          	sd	s6,88(s4)
  p->sz = sz;
    80004e56:	055a3823          	sd	s5,80(s4)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80004e5a:	060a3783          	ld	a5,96(s4)
    80004e5e:	e6843703          	ld	a4,-408(s0)
    80004e62:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004e64:	060a3783          	ld	a5,96(s4)
    80004e68:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz, (int) (p - proc));
    80004e6c:	0000b617          	auipc	a2,0xb
    80004e70:	f3c60613          	addi	a2,a2,-196 # 8000fda8 <proc>
    80004e74:	40ca0633          	sub	a2,s4,a2
    80004e78:	860d                	srai	a2,a2,0x3
    80004e7a:	677d4737          	lui	a4,0x677d4
    80004e7e:	6cf70713          	addi	a4,a4,1743 # 677d46cf <_entry-0x1882b931>
    80004e82:	51b3c7b7          	lui	a5,0x51b3c
    80004e86:	ea378793          	addi	a5,a5,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80004e8a:	1782                	slli	a5,a5,0x20
    80004e8c:	97ba                	add	a5,a5,a4
    80004e8e:	02f6063b          	mulw	a2,a2,a5
    80004e92:	85ea                	mv	a1,s10
    80004e94:	be3fc0ef          	jal	80001a76 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004e98:	0004851b          	sext.w	a0,s1
    80004e9c:	20013903          	ld	s2,512(sp)
    80004ea0:	79fe                	ld	s3,504(sp)
    80004ea2:	7a5e                	ld	s4,496(sp)
    80004ea4:	7abe                	ld	s5,488(sp)
    80004ea6:	7b1e                	ld	s6,480(sp)
    80004ea8:	6bfe                	ld	s7,472(sp)
    80004eaa:	6c5e                	ld	s8,464(sp)
    80004eac:	6cbe                	ld	s9,456(sp)
    80004eae:	6d1e                	ld	s10,448(sp)
    80004eb0:	7dfa                	ld	s11,440(sp)
    80004eb2:	b321                	j	80004bba <kexec+0x82>
    80004eb4:	7b1e                	ld	s6,480(sp)
    80004eb6:	b9d5                	j	80004baa <kexec+0x72>
    return -1;
    80004eb8:	557d                	li	a0,-1
    80004eba:	b301                	j	80004bba <kexec+0x82>
    80004ebc:	557d                	li	a0,-1
    80004ebe:	6d1e                	ld	s10,448(sp)
    80004ec0:	b9ed                	j	80004bba <kexec+0x82>
    80004ec2:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz, (int) (p - proc));
    80004ec6:	0000b797          	auipc	a5,0xb
    80004eca:	ee278793          	addi	a5,a5,-286 # 8000fda8 <proc>
    80004ece:	40fd07b3          	sub	a5,s10,a5
    80004ed2:	878d                	srai	a5,a5,0x3
    80004ed4:	677d4737          	lui	a4,0x677d4
    80004ed8:	6cf70713          	addi	a4,a4,1743 # 677d46cf <_entry-0x1882b931>
    80004edc:	51b3c637          	lui	a2,0x51b3c
    80004ee0:	ea360613          	addi	a2,a2,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80004ee4:	1602                	slli	a2,a2,0x20
    80004ee6:	963a                	add	a2,a2,a4
    80004ee8:	02c7863b          	mulw	a2,a5,a2
    80004eec:	df843583          	ld	a1,-520(s0)
    80004ef0:	855a                	mv	a0,s6
    80004ef2:	b85fc0ef          	jal	80001a76 <proc_freepagetable>
  if(ip){
    80004ef6:	20013903          	ld	s2,512(sp)
    80004efa:	79fe                	ld	s3,504(sp)
    80004efc:	7abe                	ld	s5,488(sp)
    80004efe:	7b1e                	ld	s6,480(sp)
    80004f00:	6bfe                	ld	s7,472(sp)
    80004f02:	6c5e                	ld	s8,464(sp)
    80004f04:	6cbe                	ld	s9,456(sp)
    80004f06:	7dfa                	ld	s11,440(sp)
    80004f08:	b14d                	j	80004baa <kexec+0x72>
    80004f0a:	df243c23          	sd	s2,-520(s0)
    80004f0e:	bf65                	j	80004ec6 <kexec+0x38e>
    80004f10:	df243c23          	sd	s2,-520(s0)
    80004f14:	bf4d                	j	80004ec6 <kexec+0x38e>
    80004f16:	df243c23          	sd	s2,-520(s0)
    80004f1a:	b775                	j	80004ec6 <kexec+0x38e>
    80004f1c:	df243c23          	sd	s2,-520(s0)
    80004f20:	b75d                	j	80004ec6 <kexec+0x38e>
  sz = sz1;
    80004f22:	89d6                	mv	s3,s5
    80004f24:	bbfd                	j	80004d22 <kexec+0x1ea>
    80004f26:	89d6                	mv	s3,s5
    80004f28:	bbed                	j	80004d22 <kexec+0x1ea>

0000000080004f2a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004f2a:	7179                	addi	sp,sp,-48
    80004f2c:	f406                	sd	ra,40(sp)
    80004f2e:	f022                	sd	s0,32(sp)
    80004f30:	ec26                	sd	s1,24(sp)
    80004f32:	e84a                	sd	s2,16(sp)
    80004f34:	1800                	addi	s0,sp,48
    80004f36:	892e                	mv	s2,a1
    80004f38:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004f3a:	fdc40593          	addi	a1,s0,-36
    80004f3e:	ca5fd0ef          	jal	80002be2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004f42:	fdc42703          	lw	a4,-36(s0)
    80004f46:	47bd                	li	a5,15
    80004f48:	02e7e963          	bltu	a5,a4,80004f7a <argfd+0x50>
    80004f4c:	973fc0ef          	jal	800018be <myproc>
    80004f50:	fdc42703          	lw	a4,-36(s0)
    80004f54:	01a70793          	addi	a5,a4,26
    80004f58:	078e                	slli	a5,a5,0x3
    80004f5a:	953e                	add	a0,a0,a5
    80004f5c:	651c                	ld	a5,8(a0)
    80004f5e:	c385                	beqz	a5,80004f7e <argfd+0x54>
    return -1;
  if(pfd)
    80004f60:	00090463          	beqz	s2,80004f68 <argfd+0x3e>
    *pfd = fd;
    80004f64:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004f68:	4501                	li	a0,0
  if(pf)
    80004f6a:	c091                	beqz	s1,80004f6e <argfd+0x44>
    *pf = f;
    80004f6c:	e09c                	sd	a5,0(s1)
}
    80004f6e:	70a2                	ld	ra,40(sp)
    80004f70:	7402                	ld	s0,32(sp)
    80004f72:	64e2                	ld	s1,24(sp)
    80004f74:	6942                	ld	s2,16(sp)
    80004f76:	6145                	addi	sp,sp,48
    80004f78:	8082                	ret
    return -1;
    80004f7a:	557d                	li	a0,-1
    80004f7c:	bfcd                	j	80004f6e <argfd+0x44>
    80004f7e:	557d                	li	a0,-1
    80004f80:	b7fd                	j	80004f6e <argfd+0x44>

0000000080004f82 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004f82:	1101                	addi	sp,sp,-32
    80004f84:	ec06                	sd	ra,24(sp)
    80004f86:	e822                	sd	s0,16(sp)
    80004f88:	e426                	sd	s1,8(sp)
    80004f8a:	1000                	addi	s0,sp,32
    80004f8c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004f8e:	931fc0ef          	jal	800018be <myproc>
    80004f92:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004f94:	0d850793          	addi	a5,a0,216
    80004f98:	4501                	li	a0,0
    80004f9a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004f9c:	6398                	ld	a4,0(a5)
    80004f9e:	cb19                	beqz	a4,80004fb4 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004fa0:	2505                	addiw	a0,a0,1
    80004fa2:	07a1                	addi	a5,a5,8
    80004fa4:	fed51ce3          	bne	a0,a3,80004f9c <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004fa8:	557d                	li	a0,-1
}
    80004faa:	60e2                	ld	ra,24(sp)
    80004fac:	6442                	ld	s0,16(sp)
    80004fae:	64a2                	ld	s1,8(sp)
    80004fb0:	6105                	addi	sp,sp,32
    80004fb2:	8082                	ret
      p->ofile[fd] = f;
    80004fb4:	01a50793          	addi	a5,a0,26
    80004fb8:	078e                	slli	a5,a5,0x3
    80004fba:	963e                	add	a2,a2,a5
    80004fbc:	e604                	sd	s1,8(a2)
      return fd;
    80004fbe:	b7f5                	j	80004faa <fdalloc+0x28>

0000000080004fc0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004fc0:	715d                	addi	sp,sp,-80
    80004fc2:	e486                	sd	ra,72(sp)
    80004fc4:	e0a2                	sd	s0,64(sp)
    80004fc6:	fc26                	sd	s1,56(sp)
    80004fc8:	f84a                	sd	s2,48(sp)
    80004fca:	f44e                	sd	s3,40(sp)
    80004fcc:	ec56                	sd	s5,24(sp)
    80004fce:	e85a                	sd	s6,16(sp)
    80004fd0:	0880                	addi	s0,sp,80
    80004fd2:	8b2e                	mv	s6,a1
    80004fd4:	89b2                	mv	s3,a2
    80004fd6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004fd8:	fb040593          	addi	a1,s0,-80
    80004fdc:	f4ffe0ef          	jal	80003f2a <nameiparent>
    80004fe0:	84aa                	mv	s1,a0
    80004fe2:	10050a63          	beqz	a0,800050f6 <create+0x136>
    return 0;

  ilock(dp);
    80004fe6:	f00fe0ef          	jal	800036e6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004fea:	4601                	li	a2,0
    80004fec:	fb040593          	addi	a1,s0,-80
    80004ff0:	8526                	mv	a0,s1
    80004ff2:	c93fe0ef          	jal	80003c84 <dirlookup>
    80004ff6:	8aaa                	mv	s5,a0
    80004ff8:	c129                	beqz	a0,8000503a <create+0x7a>
    iunlockput(dp);
    80004ffa:	8526                	mv	a0,s1
    80004ffc:	8f5fe0ef          	jal	800038f0 <iunlockput>
    ilock(ip);
    80005000:	8556                	mv	a0,s5
    80005002:	ee4fe0ef          	jal	800036e6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005006:	4789                	li	a5,2
    80005008:	02fb1463          	bne	s6,a5,80005030 <create+0x70>
    8000500c:	044ad783          	lhu	a5,68(s5) # 1044 <_entry-0x7fffefbc>
    80005010:	37f9                	addiw	a5,a5,-2
    80005012:	17c2                	slli	a5,a5,0x30
    80005014:	93c1                	srli	a5,a5,0x30
    80005016:	4705                	li	a4,1
    80005018:	00f76c63          	bltu	a4,a5,80005030 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000501c:	8556                	mv	a0,s5
    8000501e:	60a6                	ld	ra,72(sp)
    80005020:	6406                	ld	s0,64(sp)
    80005022:	74e2                	ld	s1,56(sp)
    80005024:	7942                	ld	s2,48(sp)
    80005026:	79a2                	ld	s3,40(sp)
    80005028:	6ae2                	ld	s5,24(sp)
    8000502a:	6b42                	ld	s6,16(sp)
    8000502c:	6161                	addi	sp,sp,80
    8000502e:	8082                	ret
    iunlockput(ip);
    80005030:	8556                	mv	a0,s5
    80005032:	8bffe0ef          	jal	800038f0 <iunlockput>
    return 0;
    80005036:	4a81                	li	s5,0
    80005038:	b7d5                	j	8000501c <create+0x5c>
    8000503a:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000503c:	85da                	mv	a1,s6
    8000503e:	4088                	lw	a0,0(s1)
    80005040:	d36fe0ef          	jal	80003576 <ialloc>
    80005044:	8a2a                	mv	s4,a0
    80005046:	cd15                	beqz	a0,80005082 <create+0xc2>
  ilock(ip);
    80005048:	e9efe0ef          	jal	800036e6 <ilock>
  ip->major = major;
    8000504c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005050:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005054:	4905                	li	s2,1
    80005056:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000505a:	8552                	mv	a0,s4
    8000505c:	dd6fe0ef          	jal	80003632 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005060:	032b0763          	beq	s6,s2,8000508e <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80005064:	004a2603          	lw	a2,4(s4)
    80005068:	fb040593          	addi	a1,s0,-80
    8000506c:	8526                	mv	a0,s1
    8000506e:	df9fe0ef          	jal	80003e66 <dirlink>
    80005072:	06054563          	bltz	a0,800050dc <create+0x11c>
  iunlockput(dp);
    80005076:	8526                	mv	a0,s1
    80005078:	879fe0ef          	jal	800038f0 <iunlockput>
  return ip;
    8000507c:	8ad2                	mv	s5,s4
    8000507e:	7a02                	ld	s4,32(sp)
    80005080:	bf71                	j	8000501c <create+0x5c>
    iunlockput(dp);
    80005082:	8526                	mv	a0,s1
    80005084:	86dfe0ef          	jal	800038f0 <iunlockput>
    return 0;
    80005088:	8ad2                	mv	s5,s4
    8000508a:	7a02                	ld	s4,32(sp)
    8000508c:	bf41                	j	8000501c <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000508e:	004a2603          	lw	a2,4(s4)
    80005092:	00002597          	auipc	a1,0x2
    80005096:	52e58593          	addi	a1,a1,1326 # 800075c0 <etext+0x5c0>
    8000509a:	8552                	mv	a0,s4
    8000509c:	dcbfe0ef          	jal	80003e66 <dirlink>
    800050a0:	02054e63          	bltz	a0,800050dc <create+0x11c>
    800050a4:	40d0                	lw	a2,4(s1)
    800050a6:	00002597          	auipc	a1,0x2
    800050aa:	52258593          	addi	a1,a1,1314 # 800075c8 <etext+0x5c8>
    800050ae:	8552                	mv	a0,s4
    800050b0:	db7fe0ef          	jal	80003e66 <dirlink>
    800050b4:	02054463          	bltz	a0,800050dc <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800050b8:	004a2603          	lw	a2,4(s4)
    800050bc:	fb040593          	addi	a1,s0,-80
    800050c0:	8526                	mv	a0,s1
    800050c2:	da5fe0ef          	jal	80003e66 <dirlink>
    800050c6:	00054b63          	bltz	a0,800050dc <create+0x11c>
    dp->nlink++;  // for ".."
    800050ca:	04a4d783          	lhu	a5,74(s1)
    800050ce:	2785                	addiw	a5,a5,1
    800050d0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800050d4:	8526                	mv	a0,s1
    800050d6:	d5cfe0ef          	jal	80003632 <iupdate>
    800050da:	bf71                	j	80005076 <create+0xb6>
  ip->nlink = 0;
    800050dc:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800050e0:	8552                	mv	a0,s4
    800050e2:	d50fe0ef          	jal	80003632 <iupdate>
  iunlockput(ip);
    800050e6:	8552                	mv	a0,s4
    800050e8:	809fe0ef          	jal	800038f0 <iunlockput>
  iunlockput(dp);
    800050ec:	8526                	mv	a0,s1
    800050ee:	803fe0ef          	jal	800038f0 <iunlockput>
  return 0;
    800050f2:	7a02                	ld	s4,32(sp)
    800050f4:	b725                	j	8000501c <create+0x5c>
    return 0;
    800050f6:	8aaa                	mv	s5,a0
    800050f8:	b715                	j	8000501c <create+0x5c>

00000000800050fa <sys_dup>:
{
    800050fa:	7179                	addi	sp,sp,-48
    800050fc:	f406                	sd	ra,40(sp)
    800050fe:	f022                	sd	s0,32(sp)
    80005100:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005102:	fd840613          	addi	a2,s0,-40
    80005106:	4581                	li	a1,0
    80005108:	4501                	li	a0,0
    8000510a:	e21ff0ef          	jal	80004f2a <argfd>
    return -1;
    8000510e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005110:	02054363          	bltz	a0,80005136 <sys_dup+0x3c>
    80005114:	ec26                	sd	s1,24(sp)
    80005116:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005118:	fd843903          	ld	s2,-40(s0)
    8000511c:	854a                	mv	a0,s2
    8000511e:	e65ff0ef          	jal	80004f82 <fdalloc>
    80005122:	84aa                	mv	s1,a0
    return -1;
    80005124:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005126:	00054d63          	bltz	a0,80005140 <sys_dup+0x46>
  filedup(f);
    8000512a:	854a                	mv	a0,s2
    8000512c:	b8aff0ef          	jal	800044b6 <filedup>
  return fd;
    80005130:	87a6                	mv	a5,s1
    80005132:	64e2                	ld	s1,24(sp)
    80005134:	6942                	ld	s2,16(sp)
}
    80005136:	853e                	mv	a0,a5
    80005138:	70a2                	ld	ra,40(sp)
    8000513a:	7402                	ld	s0,32(sp)
    8000513c:	6145                	addi	sp,sp,48
    8000513e:	8082                	ret
    80005140:	64e2                	ld	s1,24(sp)
    80005142:	6942                	ld	s2,16(sp)
    80005144:	bfcd                	j	80005136 <sys_dup+0x3c>

0000000080005146 <sys_read>:
{
    80005146:	7179                	addi	sp,sp,-48
    80005148:	f406                	sd	ra,40(sp)
    8000514a:	f022                	sd	s0,32(sp)
    8000514c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000514e:	fd840593          	addi	a1,s0,-40
    80005152:	4505                	li	a0,1
    80005154:	aabfd0ef          	jal	80002bfe <argaddr>
  argint(2, &n);
    80005158:	fe440593          	addi	a1,s0,-28
    8000515c:	4509                	li	a0,2
    8000515e:	a85fd0ef          	jal	80002be2 <argint>
  if(argfd(0, 0, &f) < 0)
    80005162:	fe840613          	addi	a2,s0,-24
    80005166:	4581                	li	a1,0
    80005168:	4501                	li	a0,0
    8000516a:	dc1ff0ef          	jal	80004f2a <argfd>
    8000516e:	87aa                	mv	a5,a0
    return -1;
    80005170:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005172:	0007ca63          	bltz	a5,80005186 <sys_read+0x40>
  return fileread(f, p, n);
    80005176:	fe442603          	lw	a2,-28(s0)
    8000517a:	fd843583          	ld	a1,-40(s0)
    8000517e:	fe843503          	ld	a0,-24(s0)
    80005182:	c9aff0ef          	jal	8000461c <fileread>
}
    80005186:	70a2                	ld	ra,40(sp)
    80005188:	7402                	ld	s0,32(sp)
    8000518a:	6145                	addi	sp,sp,48
    8000518c:	8082                	ret

000000008000518e <sys_write>:
{
    8000518e:	7179                	addi	sp,sp,-48
    80005190:	f406                	sd	ra,40(sp)
    80005192:	f022                	sd	s0,32(sp)
    80005194:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005196:	fd840593          	addi	a1,s0,-40
    8000519a:	4505                	li	a0,1
    8000519c:	a63fd0ef          	jal	80002bfe <argaddr>
  argint(2, &n);
    800051a0:	fe440593          	addi	a1,s0,-28
    800051a4:	4509                	li	a0,2
    800051a6:	a3dfd0ef          	jal	80002be2 <argint>
  if(argfd(0, 0, &f) < 0)
    800051aa:	fe840613          	addi	a2,s0,-24
    800051ae:	4581                	li	a1,0
    800051b0:	4501                	li	a0,0
    800051b2:	d79ff0ef          	jal	80004f2a <argfd>
    800051b6:	87aa                	mv	a5,a0
    return -1;
    800051b8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800051ba:	0007ca63          	bltz	a5,800051ce <sys_write+0x40>
  return filewrite(f, p, n);
    800051be:	fe442603          	lw	a2,-28(s0)
    800051c2:	fd843583          	ld	a1,-40(s0)
    800051c6:	fe843503          	ld	a0,-24(s0)
    800051ca:	d10ff0ef          	jal	800046da <filewrite>
}
    800051ce:	70a2                	ld	ra,40(sp)
    800051d0:	7402                	ld	s0,32(sp)
    800051d2:	6145                	addi	sp,sp,48
    800051d4:	8082                	ret

00000000800051d6 <sys_close>:
{
    800051d6:	1101                	addi	sp,sp,-32
    800051d8:	ec06                	sd	ra,24(sp)
    800051da:	e822                	sd	s0,16(sp)
    800051dc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800051de:	fe040613          	addi	a2,s0,-32
    800051e2:	fec40593          	addi	a1,s0,-20
    800051e6:	4501                	li	a0,0
    800051e8:	d43ff0ef          	jal	80004f2a <argfd>
    return -1;
    800051ec:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800051ee:	02054063          	bltz	a0,8000520e <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800051f2:	eccfc0ef          	jal	800018be <myproc>
    800051f6:	fec42783          	lw	a5,-20(s0)
    800051fa:	07e9                	addi	a5,a5,26
    800051fc:	078e                	slli	a5,a5,0x3
    800051fe:	953e                	add	a0,a0,a5
    80005200:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80005204:	fe043503          	ld	a0,-32(s0)
    80005208:	af4ff0ef          	jal	800044fc <fileclose>
  return 0;
    8000520c:	4781                	li	a5,0
}
    8000520e:	853e                	mv	a0,a5
    80005210:	60e2                	ld	ra,24(sp)
    80005212:	6442                	ld	s0,16(sp)
    80005214:	6105                	addi	sp,sp,32
    80005216:	8082                	ret

0000000080005218 <sys_fstat>:
{
    80005218:	1101                	addi	sp,sp,-32
    8000521a:	ec06                	sd	ra,24(sp)
    8000521c:	e822                	sd	s0,16(sp)
    8000521e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005220:	fe040593          	addi	a1,s0,-32
    80005224:	4505                	li	a0,1
    80005226:	9d9fd0ef          	jal	80002bfe <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000522a:	fe840613          	addi	a2,s0,-24
    8000522e:	4581                	li	a1,0
    80005230:	4501                	li	a0,0
    80005232:	cf9ff0ef          	jal	80004f2a <argfd>
    80005236:	87aa                	mv	a5,a0
    return -1;
    80005238:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000523a:	0007c863          	bltz	a5,8000524a <sys_fstat+0x32>
  return filestat(f, st);
    8000523e:	fe043583          	ld	a1,-32(s0)
    80005242:	fe843503          	ld	a0,-24(s0)
    80005246:	b74ff0ef          	jal	800045ba <filestat>
}
    8000524a:	60e2                	ld	ra,24(sp)
    8000524c:	6442                	ld	s0,16(sp)
    8000524e:	6105                	addi	sp,sp,32
    80005250:	8082                	ret

0000000080005252 <sys_link>:
{
    80005252:	7169                	addi	sp,sp,-304
    80005254:	f606                	sd	ra,296(sp)
    80005256:	f222                	sd	s0,288(sp)
    80005258:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000525a:	08000613          	li	a2,128
    8000525e:	ed040593          	addi	a1,s0,-304
    80005262:	4501                	li	a0,0
    80005264:	9b7fd0ef          	jal	80002c1a <argstr>
    return -1;
    80005268:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000526a:	0c054e63          	bltz	a0,80005346 <sys_link+0xf4>
    8000526e:	08000613          	li	a2,128
    80005272:	f5040593          	addi	a1,s0,-176
    80005276:	4505                	li	a0,1
    80005278:	9a3fd0ef          	jal	80002c1a <argstr>
    return -1;
    8000527c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000527e:	0c054463          	bltz	a0,80005346 <sys_link+0xf4>
    80005282:	ee26                	sd	s1,280(sp)
  begin_op();
    80005284:	e67fe0ef          	jal	800040ea <begin_op>
  if((ip = namei(old)) == 0){
    80005288:	ed040513          	addi	a0,s0,-304
    8000528c:	c85fe0ef          	jal	80003f10 <namei>
    80005290:	84aa                	mv	s1,a0
    80005292:	c53d                	beqz	a0,80005300 <sys_link+0xae>
  ilock(ip);
    80005294:	c52fe0ef          	jal	800036e6 <ilock>
  if(ip->type == T_DIR){
    80005298:	04449703          	lh	a4,68(s1)
    8000529c:	4785                	li	a5,1
    8000529e:	06f70663          	beq	a4,a5,8000530a <sys_link+0xb8>
    800052a2:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800052a4:	04a4d783          	lhu	a5,74(s1)
    800052a8:	2785                	addiw	a5,a5,1
    800052aa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800052ae:	8526                	mv	a0,s1
    800052b0:	b82fe0ef          	jal	80003632 <iupdate>
  iunlock(ip);
    800052b4:	8526                	mv	a0,s1
    800052b6:	cdefe0ef          	jal	80003794 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800052ba:	fd040593          	addi	a1,s0,-48
    800052be:	f5040513          	addi	a0,s0,-176
    800052c2:	c69fe0ef          	jal	80003f2a <nameiparent>
    800052c6:	892a                	mv	s2,a0
    800052c8:	cd21                	beqz	a0,80005320 <sys_link+0xce>
  ilock(dp);
    800052ca:	c1cfe0ef          	jal	800036e6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800052ce:	00092703          	lw	a4,0(s2)
    800052d2:	409c                	lw	a5,0(s1)
    800052d4:	04f71363          	bne	a4,a5,8000531a <sys_link+0xc8>
    800052d8:	40d0                	lw	a2,4(s1)
    800052da:	fd040593          	addi	a1,s0,-48
    800052de:	854a                	mv	a0,s2
    800052e0:	b87fe0ef          	jal	80003e66 <dirlink>
    800052e4:	02054b63          	bltz	a0,8000531a <sys_link+0xc8>
  iunlockput(dp);
    800052e8:	854a                	mv	a0,s2
    800052ea:	e06fe0ef          	jal	800038f0 <iunlockput>
  iput(ip);
    800052ee:	8526                	mv	a0,s1
    800052f0:	d78fe0ef          	jal	80003868 <iput>
  end_op();
    800052f4:	e61fe0ef          	jal	80004154 <end_op>
  return 0;
    800052f8:	4781                	li	a5,0
    800052fa:	64f2                	ld	s1,280(sp)
    800052fc:	6952                	ld	s2,272(sp)
    800052fe:	a0a1                	j	80005346 <sys_link+0xf4>
    end_op();
    80005300:	e55fe0ef          	jal	80004154 <end_op>
    return -1;
    80005304:	57fd                	li	a5,-1
    80005306:	64f2                	ld	s1,280(sp)
    80005308:	a83d                	j	80005346 <sys_link+0xf4>
    iunlockput(ip);
    8000530a:	8526                	mv	a0,s1
    8000530c:	de4fe0ef          	jal	800038f0 <iunlockput>
    end_op();
    80005310:	e45fe0ef          	jal	80004154 <end_op>
    return -1;
    80005314:	57fd                	li	a5,-1
    80005316:	64f2                	ld	s1,280(sp)
    80005318:	a03d                	j	80005346 <sys_link+0xf4>
    iunlockput(dp);
    8000531a:	854a                	mv	a0,s2
    8000531c:	dd4fe0ef          	jal	800038f0 <iunlockput>
  ilock(ip);
    80005320:	8526                	mv	a0,s1
    80005322:	bc4fe0ef          	jal	800036e6 <ilock>
  ip->nlink--;
    80005326:	04a4d783          	lhu	a5,74(s1)
    8000532a:	37fd                	addiw	a5,a5,-1
    8000532c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005330:	8526                	mv	a0,s1
    80005332:	b00fe0ef          	jal	80003632 <iupdate>
  iunlockput(ip);
    80005336:	8526                	mv	a0,s1
    80005338:	db8fe0ef          	jal	800038f0 <iunlockput>
  end_op();
    8000533c:	e19fe0ef          	jal	80004154 <end_op>
  return -1;
    80005340:	57fd                	li	a5,-1
    80005342:	64f2                	ld	s1,280(sp)
    80005344:	6952                	ld	s2,272(sp)
}
    80005346:	853e                	mv	a0,a5
    80005348:	70b2                	ld	ra,296(sp)
    8000534a:	7412                	ld	s0,288(sp)
    8000534c:	6155                	addi	sp,sp,304
    8000534e:	8082                	ret

0000000080005350 <sys_unlink>:
{
    80005350:	7111                	addi	sp,sp,-256
    80005352:	fd86                	sd	ra,248(sp)
    80005354:	f9a2                	sd	s0,240(sp)
    80005356:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80005358:	08000613          	li	a2,128
    8000535c:	f2040593          	addi	a1,s0,-224
    80005360:	4501                	li	a0,0
    80005362:	8b9fd0ef          	jal	80002c1a <argstr>
    80005366:	16054663          	bltz	a0,800054d2 <sys_unlink+0x182>
    8000536a:	f5a6                	sd	s1,232(sp)
  begin_op();
    8000536c:	d7ffe0ef          	jal	800040ea <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005370:	fa040593          	addi	a1,s0,-96
    80005374:	f2040513          	addi	a0,s0,-224
    80005378:	bb3fe0ef          	jal	80003f2a <nameiparent>
    8000537c:	84aa                	mv	s1,a0
    8000537e:	c955                	beqz	a0,80005432 <sys_unlink+0xe2>
  ilock(dp);
    80005380:	b66fe0ef          	jal	800036e6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005384:	00002597          	auipc	a1,0x2
    80005388:	23c58593          	addi	a1,a1,572 # 800075c0 <etext+0x5c0>
    8000538c:	fa040513          	addi	a0,s0,-96
    80005390:	8dffe0ef          	jal	80003c6e <namecmp>
    80005394:	12050463          	beqz	a0,800054bc <sys_unlink+0x16c>
    80005398:	00002597          	auipc	a1,0x2
    8000539c:	23058593          	addi	a1,a1,560 # 800075c8 <etext+0x5c8>
    800053a0:	fa040513          	addi	a0,s0,-96
    800053a4:	8cbfe0ef          	jal	80003c6e <namecmp>
    800053a8:	10050a63          	beqz	a0,800054bc <sys_unlink+0x16c>
    800053ac:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800053ae:	f1c40613          	addi	a2,s0,-228
    800053b2:	fa040593          	addi	a1,s0,-96
    800053b6:	8526                	mv	a0,s1
    800053b8:	8cdfe0ef          	jal	80003c84 <dirlookup>
    800053bc:	892a                	mv	s2,a0
    800053be:	0e050e63          	beqz	a0,800054ba <sys_unlink+0x16a>
    800053c2:	edce                	sd	s3,216(sp)
  ilock(ip);
    800053c4:	b22fe0ef          	jal	800036e6 <ilock>
  if(ip->nlink < 1)
    800053c8:	04a91783          	lh	a5,74(s2)
    800053cc:	06f05863          	blez	a5,8000543c <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800053d0:	04491703          	lh	a4,68(s2)
    800053d4:	4785                	li	a5,1
    800053d6:	06f70b63          	beq	a4,a5,8000544c <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    800053da:	fb040993          	addi	s3,s0,-80
    800053de:	4641                	li	a2,16
    800053e0:	4581                	li	a1,0
    800053e2:	854e                	mv	a0,s3
    800053e4:	8b9fb0ef          	jal	80000c9c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800053e8:	4741                	li	a4,16
    800053ea:	f1c42683          	lw	a3,-228(s0)
    800053ee:	864e                	mv	a2,s3
    800053f0:	4581                	li	a1,0
    800053f2:	8526                	mv	a0,s1
    800053f4:	f76fe0ef          	jal	80003b6a <writei>
    800053f8:	47c1                	li	a5,16
    800053fa:	08f51f63          	bne	a0,a5,80005498 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    800053fe:	04491703          	lh	a4,68(s2)
    80005402:	4785                	li	a5,1
    80005404:	0af70263          	beq	a4,a5,800054a8 <sys_unlink+0x158>
  iunlockput(dp);
    80005408:	8526                	mv	a0,s1
    8000540a:	ce6fe0ef          	jal	800038f0 <iunlockput>
  ip->nlink--;
    8000540e:	04a95783          	lhu	a5,74(s2)
    80005412:	37fd                	addiw	a5,a5,-1
    80005414:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005418:	854a                	mv	a0,s2
    8000541a:	a18fe0ef          	jal	80003632 <iupdate>
  iunlockput(ip);
    8000541e:	854a                	mv	a0,s2
    80005420:	cd0fe0ef          	jal	800038f0 <iunlockput>
  end_op();
    80005424:	d31fe0ef          	jal	80004154 <end_op>
  return 0;
    80005428:	4501                	li	a0,0
    8000542a:	74ae                	ld	s1,232(sp)
    8000542c:	790e                	ld	s2,224(sp)
    8000542e:	69ee                	ld	s3,216(sp)
    80005430:	a869                	j	800054ca <sys_unlink+0x17a>
    end_op();
    80005432:	d23fe0ef          	jal	80004154 <end_op>
    return -1;
    80005436:	557d                	li	a0,-1
    80005438:	74ae                	ld	s1,232(sp)
    8000543a:	a841                	j	800054ca <sys_unlink+0x17a>
    8000543c:	e9d2                	sd	s4,208(sp)
    8000543e:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80005440:	00002517          	auipc	a0,0x2
    80005444:	19050513          	addi	a0,a0,400 # 800075d0 <etext+0x5d0>
    80005448:	b96fb0ef          	jal	800007de <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000544c:	04c92703          	lw	a4,76(s2)
    80005450:	02000793          	li	a5,32
    80005454:	f8e7f3e3          	bgeu	a5,a4,800053da <sys_unlink+0x8a>
    80005458:	e9d2                	sd	s4,208(sp)
    8000545a:	e5d6                	sd	s5,200(sp)
    8000545c:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000545e:	f0840a93          	addi	s5,s0,-248
    80005462:	4a41                	li	s4,16
    80005464:	8752                	mv	a4,s4
    80005466:	86ce                	mv	a3,s3
    80005468:	8656                	mv	a2,s5
    8000546a:	4581                	li	a1,0
    8000546c:	854a                	mv	a0,s2
    8000546e:	e0afe0ef          	jal	80003a78 <readi>
    80005472:	01451d63          	bne	a0,s4,8000548c <sys_unlink+0x13c>
    if(de.inum != 0)
    80005476:	f0845783          	lhu	a5,-248(s0)
    8000547a:	efb1                	bnez	a5,800054d6 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000547c:	29c1                	addiw	s3,s3,16
    8000547e:	04c92783          	lw	a5,76(s2)
    80005482:	fef9e1e3          	bltu	s3,a5,80005464 <sys_unlink+0x114>
    80005486:	6a4e                	ld	s4,208(sp)
    80005488:	6aae                	ld	s5,200(sp)
    8000548a:	bf81                	j	800053da <sys_unlink+0x8a>
      panic("isdirempty: readi");
    8000548c:	00002517          	auipc	a0,0x2
    80005490:	15c50513          	addi	a0,a0,348 # 800075e8 <etext+0x5e8>
    80005494:	b4afb0ef          	jal	800007de <panic>
    80005498:	e9d2                	sd	s4,208(sp)
    8000549a:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    8000549c:	00002517          	auipc	a0,0x2
    800054a0:	16450513          	addi	a0,a0,356 # 80007600 <etext+0x600>
    800054a4:	b3afb0ef          	jal	800007de <panic>
    dp->nlink--;
    800054a8:	04a4d783          	lhu	a5,74(s1)
    800054ac:	37fd                	addiw	a5,a5,-1
    800054ae:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800054b2:	8526                	mv	a0,s1
    800054b4:	97efe0ef          	jal	80003632 <iupdate>
    800054b8:	bf81                	j	80005408 <sys_unlink+0xb8>
    800054ba:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    800054bc:	8526                	mv	a0,s1
    800054be:	c32fe0ef          	jal	800038f0 <iunlockput>
  end_op();
    800054c2:	c93fe0ef          	jal	80004154 <end_op>
  return -1;
    800054c6:	557d                	li	a0,-1
    800054c8:	74ae                	ld	s1,232(sp)
}
    800054ca:	70ee                	ld	ra,248(sp)
    800054cc:	744e                	ld	s0,240(sp)
    800054ce:	6111                	addi	sp,sp,256
    800054d0:	8082                	ret
    return -1;
    800054d2:	557d                	li	a0,-1
    800054d4:	bfdd                	j	800054ca <sys_unlink+0x17a>
    iunlockput(ip);
    800054d6:	854a                	mv	a0,s2
    800054d8:	c18fe0ef          	jal	800038f0 <iunlockput>
    goto bad;
    800054dc:	790e                	ld	s2,224(sp)
    800054de:	69ee                	ld	s3,216(sp)
    800054e0:	6a4e                	ld	s4,208(sp)
    800054e2:	6aae                	ld	s5,200(sp)
    800054e4:	bfe1                	j	800054bc <sys_unlink+0x16c>

00000000800054e6 <sys_open>:

uint64
sys_open(void)
{
    800054e6:	7131                	addi	sp,sp,-192
    800054e8:	fd06                	sd	ra,184(sp)
    800054ea:	f922                	sd	s0,176(sp)
    800054ec:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800054ee:	f4c40593          	addi	a1,s0,-180
    800054f2:	4505                	li	a0,1
    800054f4:	eeefd0ef          	jal	80002be2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800054f8:	08000613          	li	a2,128
    800054fc:	f5040593          	addi	a1,s0,-176
    80005500:	4501                	li	a0,0
    80005502:	f18fd0ef          	jal	80002c1a <argstr>
    80005506:	87aa                	mv	a5,a0
    return -1;
    80005508:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000550a:	0a07c363          	bltz	a5,800055b0 <sys_open+0xca>
    8000550e:	f526                	sd	s1,168(sp)

  begin_op();
    80005510:	bdbfe0ef          	jal	800040ea <begin_op>

  if(omode & O_CREATE){
    80005514:	f4c42783          	lw	a5,-180(s0)
    80005518:	2007f793          	andi	a5,a5,512
    8000551c:	c3dd                	beqz	a5,800055c2 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000551e:	4681                	li	a3,0
    80005520:	4601                	li	a2,0
    80005522:	4589                	li	a1,2
    80005524:	f5040513          	addi	a0,s0,-176
    80005528:	a99ff0ef          	jal	80004fc0 <create>
    8000552c:	84aa                	mv	s1,a0
    if(ip == 0){
    8000552e:	c549                	beqz	a0,800055b8 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005530:	04449703          	lh	a4,68(s1)
    80005534:	478d                	li	a5,3
    80005536:	00f71763          	bne	a4,a5,80005544 <sys_open+0x5e>
    8000553a:	0464d703          	lhu	a4,70(s1)
    8000553e:	47a5                	li	a5,9
    80005540:	0ae7ee63          	bltu	a5,a4,800055fc <sys_open+0x116>
    80005544:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005546:	f13fe0ef          	jal	80004458 <filealloc>
    8000554a:	892a                	mv	s2,a0
    8000554c:	c561                	beqz	a0,80005614 <sys_open+0x12e>
    8000554e:	ed4e                	sd	s3,152(sp)
    80005550:	a33ff0ef          	jal	80004f82 <fdalloc>
    80005554:	89aa                	mv	s3,a0
    80005556:	0a054b63          	bltz	a0,8000560c <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000555a:	04449703          	lh	a4,68(s1)
    8000555e:	478d                	li	a5,3
    80005560:	0cf70363          	beq	a4,a5,80005626 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005564:	4789                	li	a5,2
    80005566:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000556a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000556e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005572:	f4c42783          	lw	a5,-180(s0)
    80005576:	0017f713          	andi	a4,a5,1
    8000557a:	00174713          	xori	a4,a4,1
    8000557e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005582:	0037f713          	andi	a4,a5,3
    80005586:	00e03733          	snez	a4,a4
    8000558a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000558e:	4007f793          	andi	a5,a5,1024
    80005592:	c791                	beqz	a5,8000559e <sys_open+0xb8>
    80005594:	04449703          	lh	a4,68(s1)
    80005598:	4789                	li	a5,2
    8000559a:	08f70d63          	beq	a4,a5,80005634 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    8000559e:	8526                	mv	a0,s1
    800055a0:	9f4fe0ef          	jal	80003794 <iunlock>
  end_op();
    800055a4:	bb1fe0ef          	jal	80004154 <end_op>

  return fd;
    800055a8:	854e                	mv	a0,s3
    800055aa:	74aa                	ld	s1,168(sp)
    800055ac:	790a                	ld	s2,160(sp)
    800055ae:	69ea                	ld	s3,152(sp)
}
    800055b0:	70ea                	ld	ra,184(sp)
    800055b2:	744a                	ld	s0,176(sp)
    800055b4:	6129                	addi	sp,sp,192
    800055b6:	8082                	ret
      end_op();
    800055b8:	b9dfe0ef          	jal	80004154 <end_op>
      return -1;
    800055bc:	557d                	li	a0,-1
    800055be:	74aa                	ld	s1,168(sp)
    800055c0:	bfc5                	j	800055b0 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800055c2:	f5040513          	addi	a0,s0,-176
    800055c6:	94bfe0ef          	jal	80003f10 <namei>
    800055ca:	84aa                	mv	s1,a0
    800055cc:	c11d                	beqz	a0,800055f2 <sys_open+0x10c>
    ilock(ip);
    800055ce:	918fe0ef          	jal	800036e6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800055d2:	04449703          	lh	a4,68(s1)
    800055d6:	4785                	li	a5,1
    800055d8:	f4f71ce3          	bne	a4,a5,80005530 <sys_open+0x4a>
    800055dc:	f4c42783          	lw	a5,-180(s0)
    800055e0:	d3b5                	beqz	a5,80005544 <sys_open+0x5e>
      iunlockput(ip);
    800055e2:	8526                	mv	a0,s1
    800055e4:	b0cfe0ef          	jal	800038f0 <iunlockput>
      end_op();
    800055e8:	b6dfe0ef          	jal	80004154 <end_op>
      return -1;
    800055ec:	557d                	li	a0,-1
    800055ee:	74aa                	ld	s1,168(sp)
    800055f0:	b7c1                	j	800055b0 <sys_open+0xca>
      end_op();
    800055f2:	b63fe0ef          	jal	80004154 <end_op>
      return -1;
    800055f6:	557d                	li	a0,-1
    800055f8:	74aa                	ld	s1,168(sp)
    800055fa:	bf5d                	j	800055b0 <sys_open+0xca>
    iunlockput(ip);
    800055fc:	8526                	mv	a0,s1
    800055fe:	af2fe0ef          	jal	800038f0 <iunlockput>
    end_op();
    80005602:	b53fe0ef          	jal	80004154 <end_op>
    return -1;
    80005606:	557d                	li	a0,-1
    80005608:	74aa                	ld	s1,168(sp)
    8000560a:	b75d                	j	800055b0 <sys_open+0xca>
      fileclose(f);
    8000560c:	854a                	mv	a0,s2
    8000560e:	eeffe0ef          	jal	800044fc <fileclose>
    80005612:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005614:	8526                	mv	a0,s1
    80005616:	adafe0ef          	jal	800038f0 <iunlockput>
    end_op();
    8000561a:	b3bfe0ef          	jal	80004154 <end_op>
    return -1;
    8000561e:	557d                	li	a0,-1
    80005620:	74aa                	ld	s1,168(sp)
    80005622:	790a                	ld	s2,160(sp)
    80005624:	b771                	j	800055b0 <sys_open+0xca>
    f->type = FD_DEVICE;
    80005626:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000562a:	04649783          	lh	a5,70(s1)
    8000562e:	02f91223          	sh	a5,36(s2)
    80005632:	bf35                	j	8000556e <sys_open+0x88>
    itrunc(ip);
    80005634:	8526                	mv	a0,s1
    80005636:	99efe0ef          	jal	800037d4 <itrunc>
    8000563a:	b795                	j	8000559e <sys_open+0xb8>

000000008000563c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000563c:	7175                	addi	sp,sp,-144
    8000563e:	e506                	sd	ra,136(sp)
    80005640:	e122                	sd	s0,128(sp)
    80005642:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005644:	aa7fe0ef          	jal	800040ea <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005648:	08000613          	li	a2,128
    8000564c:	f7040593          	addi	a1,s0,-144
    80005650:	4501                	li	a0,0
    80005652:	dc8fd0ef          	jal	80002c1a <argstr>
    80005656:	02054363          	bltz	a0,8000567c <sys_mkdir+0x40>
    8000565a:	4681                	li	a3,0
    8000565c:	4601                	li	a2,0
    8000565e:	4585                	li	a1,1
    80005660:	f7040513          	addi	a0,s0,-144
    80005664:	95dff0ef          	jal	80004fc0 <create>
    80005668:	c911                	beqz	a0,8000567c <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000566a:	a86fe0ef          	jal	800038f0 <iunlockput>
  end_op();
    8000566e:	ae7fe0ef          	jal	80004154 <end_op>
  return 0;
    80005672:	4501                	li	a0,0
}
    80005674:	60aa                	ld	ra,136(sp)
    80005676:	640a                	ld	s0,128(sp)
    80005678:	6149                	addi	sp,sp,144
    8000567a:	8082                	ret
    end_op();
    8000567c:	ad9fe0ef          	jal	80004154 <end_op>
    return -1;
    80005680:	557d                	li	a0,-1
    80005682:	bfcd                	j	80005674 <sys_mkdir+0x38>

0000000080005684 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005684:	7135                	addi	sp,sp,-160
    80005686:	ed06                	sd	ra,152(sp)
    80005688:	e922                	sd	s0,144(sp)
    8000568a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000568c:	a5ffe0ef          	jal	800040ea <begin_op>
  argint(1, &major);
    80005690:	f6c40593          	addi	a1,s0,-148
    80005694:	4505                	li	a0,1
    80005696:	d4cfd0ef          	jal	80002be2 <argint>
  argint(2, &minor);
    8000569a:	f6840593          	addi	a1,s0,-152
    8000569e:	4509                	li	a0,2
    800056a0:	d42fd0ef          	jal	80002be2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800056a4:	08000613          	li	a2,128
    800056a8:	f7040593          	addi	a1,s0,-144
    800056ac:	4501                	li	a0,0
    800056ae:	d6cfd0ef          	jal	80002c1a <argstr>
    800056b2:	02054563          	bltz	a0,800056dc <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800056b6:	f6841683          	lh	a3,-152(s0)
    800056ba:	f6c41603          	lh	a2,-148(s0)
    800056be:	458d                	li	a1,3
    800056c0:	f7040513          	addi	a0,s0,-144
    800056c4:	8fdff0ef          	jal	80004fc0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800056c8:	c911                	beqz	a0,800056dc <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800056ca:	a26fe0ef          	jal	800038f0 <iunlockput>
  end_op();
    800056ce:	a87fe0ef          	jal	80004154 <end_op>
  return 0;
    800056d2:	4501                	li	a0,0
}
    800056d4:	60ea                	ld	ra,152(sp)
    800056d6:	644a                	ld	s0,144(sp)
    800056d8:	610d                	addi	sp,sp,160
    800056da:	8082                	ret
    end_op();
    800056dc:	a79fe0ef          	jal	80004154 <end_op>
    return -1;
    800056e0:	557d                	li	a0,-1
    800056e2:	bfcd                	j	800056d4 <sys_mknod+0x50>

00000000800056e4 <sys_chdir>:

uint64
sys_chdir(void)
{
    800056e4:	7135                	addi	sp,sp,-160
    800056e6:	ed06                	sd	ra,152(sp)
    800056e8:	e922                	sd	s0,144(sp)
    800056ea:	e14a                	sd	s2,128(sp)
    800056ec:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800056ee:	9d0fc0ef          	jal	800018be <myproc>
    800056f2:	892a                	mv	s2,a0
  
  begin_op();
    800056f4:	9f7fe0ef          	jal	800040ea <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800056f8:	08000613          	li	a2,128
    800056fc:	f6040593          	addi	a1,s0,-160
    80005700:	4501                	li	a0,0
    80005702:	d18fd0ef          	jal	80002c1a <argstr>
    80005706:	04054363          	bltz	a0,8000574c <sys_chdir+0x68>
    8000570a:	e526                	sd	s1,136(sp)
    8000570c:	f6040513          	addi	a0,s0,-160
    80005710:	801fe0ef          	jal	80003f10 <namei>
    80005714:	84aa                	mv	s1,a0
    80005716:	c915                	beqz	a0,8000574a <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005718:	fcffd0ef          	jal	800036e6 <ilock>
  if(ip->type != T_DIR){
    8000571c:	04449703          	lh	a4,68(s1)
    80005720:	4785                	li	a5,1
    80005722:	02f71963          	bne	a4,a5,80005754 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005726:	8526                	mv	a0,s1
    80005728:	86cfe0ef          	jal	80003794 <iunlock>
  iput(p->cwd);
    8000572c:	15893503          	ld	a0,344(s2)
    80005730:	938fe0ef          	jal	80003868 <iput>
  end_op();
    80005734:	a21fe0ef          	jal	80004154 <end_op>
  p->cwd = ip;
    80005738:	14993c23          	sd	s1,344(s2)
  return 0;
    8000573c:	4501                	li	a0,0
    8000573e:	64aa                	ld	s1,136(sp)
}
    80005740:	60ea                	ld	ra,152(sp)
    80005742:	644a                	ld	s0,144(sp)
    80005744:	690a                	ld	s2,128(sp)
    80005746:	610d                	addi	sp,sp,160
    80005748:	8082                	ret
    8000574a:	64aa                	ld	s1,136(sp)
    end_op();
    8000574c:	a09fe0ef          	jal	80004154 <end_op>
    return -1;
    80005750:	557d                	li	a0,-1
    80005752:	b7fd                	j	80005740 <sys_chdir+0x5c>
    iunlockput(ip);
    80005754:	8526                	mv	a0,s1
    80005756:	99afe0ef          	jal	800038f0 <iunlockput>
    end_op();
    8000575a:	9fbfe0ef          	jal	80004154 <end_op>
    return -1;
    8000575e:	557d                	li	a0,-1
    80005760:	64aa                	ld	s1,136(sp)
    80005762:	bff9                	j	80005740 <sys_chdir+0x5c>

0000000080005764 <sys_exec>:

uint64
sys_exec(void)
{
    80005764:	7105                	addi	sp,sp,-480
    80005766:	ef86                	sd	ra,472(sp)
    80005768:	eba2                	sd	s0,464(sp)
    8000576a:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000576c:	e2840593          	addi	a1,s0,-472
    80005770:	4505                	li	a0,1
    80005772:	c8cfd0ef          	jal	80002bfe <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005776:	08000613          	li	a2,128
    8000577a:	f3040593          	addi	a1,s0,-208
    8000577e:	4501                	li	a0,0
    80005780:	c9afd0ef          	jal	80002c1a <argstr>
    80005784:	87aa                	mv	a5,a0
    return -1;
    80005786:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005788:	0e07c063          	bltz	a5,80005868 <sys_exec+0x104>
    8000578c:	e7a6                	sd	s1,456(sp)
    8000578e:	e3ca                	sd	s2,448(sp)
    80005790:	ff4e                	sd	s3,440(sp)
    80005792:	fb52                	sd	s4,432(sp)
    80005794:	f756                	sd	s5,424(sp)
    80005796:	f35a                	sd	s6,416(sp)
    80005798:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000579a:	e3040a13          	addi	s4,s0,-464
    8000579e:	10000613          	li	a2,256
    800057a2:	4581                	li	a1,0
    800057a4:	8552                	mv	a0,s4
    800057a6:	cf6fb0ef          	jal	80000c9c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800057aa:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800057ac:	89d2                	mv	s3,s4
    800057ae:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800057b0:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800057b4:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800057b6:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800057ba:	00391513          	slli	a0,s2,0x3
    800057be:	85d6                	mv	a1,s5
    800057c0:	e2843783          	ld	a5,-472(s0)
    800057c4:	953e                	add	a0,a0,a5
    800057c6:	b92fd0ef          	jal	80002b58 <fetchaddr>
    800057ca:	02054663          	bltz	a0,800057f6 <sys_exec+0x92>
    if(uarg == 0){
    800057ce:	e2043783          	ld	a5,-480(s0)
    800057d2:	c7a1                	beqz	a5,8000581a <sys_exec+0xb6>
    argv[i] = kalloc();
    800057d4:	b24fb0ef          	jal	80000af8 <kalloc>
    800057d8:	85aa                	mv	a1,a0
    800057da:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800057de:	cd01                	beqz	a0,800057f6 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800057e0:	865a                	mv	a2,s6
    800057e2:	e2043503          	ld	a0,-480(s0)
    800057e6:	bbcfd0ef          	jal	80002ba2 <fetchstr>
    800057ea:	00054663          	bltz	a0,800057f6 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800057ee:	0905                	addi	s2,s2,1
    800057f0:	09a1                	addi	s3,s3,8
    800057f2:	fd7914e3          	bne	s2,s7,800057ba <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800057f6:	100a0a13          	addi	s4,s4,256
    800057fa:	6088                	ld	a0,0(s1)
    800057fc:	cd31                	beqz	a0,80005858 <sys_exec+0xf4>
    kfree(argv[i]);
    800057fe:	a18fb0ef          	jal	80000a16 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005802:	04a1                	addi	s1,s1,8
    80005804:	ff449be3          	bne	s1,s4,800057fa <sys_exec+0x96>
  return -1;
    80005808:	557d                	li	a0,-1
    8000580a:	64be                	ld	s1,456(sp)
    8000580c:	691e                	ld	s2,448(sp)
    8000580e:	79fa                	ld	s3,440(sp)
    80005810:	7a5a                	ld	s4,432(sp)
    80005812:	7aba                	ld	s5,424(sp)
    80005814:	7b1a                	ld	s6,416(sp)
    80005816:	6bfa                	ld	s7,408(sp)
    80005818:	a881                	j	80005868 <sys_exec+0x104>
      argv[i] = 0;
    8000581a:	0009079b          	sext.w	a5,s2
    8000581e:	e3040593          	addi	a1,s0,-464
    80005822:	078e                	slli	a5,a5,0x3
    80005824:	97ae                	add	a5,a5,a1
    80005826:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    8000582a:	f3040513          	addi	a0,s0,-208
    8000582e:	b0aff0ef          	jal	80004b38 <kexec>
    80005832:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005834:	100a0a13          	addi	s4,s4,256
    80005838:	6088                	ld	a0,0(s1)
    8000583a:	c511                	beqz	a0,80005846 <sys_exec+0xe2>
    kfree(argv[i]);
    8000583c:	9dafb0ef          	jal	80000a16 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005840:	04a1                	addi	s1,s1,8
    80005842:	ff449be3          	bne	s1,s4,80005838 <sys_exec+0xd4>
  return ret;
    80005846:	854a                	mv	a0,s2
    80005848:	64be                	ld	s1,456(sp)
    8000584a:	691e                	ld	s2,448(sp)
    8000584c:	79fa                	ld	s3,440(sp)
    8000584e:	7a5a                	ld	s4,432(sp)
    80005850:	7aba                	ld	s5,424(sp)
    80005852:	7b1a                	ld	s6,416(sp)
    80005854:	6bfa                	ld	s7,408(sp)
    80005856:	a809                	j	80005868 <sys_exec+0x104>
  return -1;
    80005858:	557d                	li	a0,-1
    8000585a:	64be                	ld	s1,456(sp)
    8000585c:	691e                	ld	s2,448(sp)
    8000585e:	79fa                	ld	s3,440(sp)
    80005860:	7a5a                	ld	s4,432(sp)
    80005862:	7aba                	ld	s5,424(sp)
    80005864:	7b1a                	ld	s6,416(sp)
    80005866:	6bfa                	ld	s7,408(sp)
}
    80005868:	60fe                	ld	ra,472(sp)
    8000586a:	645e                	ld	s0,464(sp)
    8000586c:	613d                	addi	sp,sp,480
    8000586e:	8082                	ret

0000000080005870 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005870:	7139                	addi	sp,sp,-64
    80005872:	fc06                	sd	ra,56(sp)
    80005874:	f822                	sd	s0,48(sp)
    80005876:	f426                	sd	s1,40(sp)
    80005878:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000587a:	844fc0ef          	jal	800018be <myproc>
    8000587e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005880:	fd840593          	addi	a1,s0,-40
    80005884:	4501                	li	a0,0
    80005886:	b78fd0ef          	jal	80002bfe <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000588a:	fc840593          	addi	a1,s0,-56
    8000588e:	fd040513          	addi	a0,s0,-48
    80005892:	f7bfe0ef          	jal	8000480c <pipealloc>
    return -1;
    80005896:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005898:	0a054463          	bltz	a0,80005940 <sys_pipe+0xd0>
  fd0 = -1;
    8000589c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800058a0:	fd043503          	ld	a0,-48(s0)
    800058a4:	edeff0ef          	jal	80004f82 <fdalloc>
    800058a8:	fca42223          	sw	a0,-60(s0)
    800058ac:	08054163          	bltz	a0,8000592e <sys_pipe+0xbe>
    800058b0:	fc843503          	ld	a0,-56(s0)
    800058b4:	eceff0ef          	jal	80004f82 <fdalloc>
    800058b8:	fca42023          	sw	a0,-64(s0)
    800058bc:	06054063          	bltz	a0,8000591c <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800058c0:	4691                	li	a3,4
    800058c2:	fc440613          	addi	a2,s0,-60
    800058c6:	fd843583          	ld	a1,-40(s0)
    800058ca:	6ca8                	ld	a0,88(s1)
    800058cc:	d25fb0ef          	jal	800015f0 <copyout>
    800058d0:	00054e63          	bltz	a0,800058ec <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800058d4:	4691                	li	a3,4
    800058d6:	fc040613          	addi	a2,s0,-64
    800058da:	fd843583          	ld	a1,-40(s0)
    800058de:	95b6                	add	a1,a1,a3
    800058e0:	6ca8                	ld	a0,88(s1)
    800058e2:	d0ffb0ef          	jal	800015f0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800058e6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800058e8:	04055c63          	bgez	a0,80005940 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800058ec:	fc442783          	lw	a5,-60(s0)
    800058f0:	07e9                	addi	a5,a5,26
    800058f2:	078e                	slli	a5,a5,0x3
    800058f4:	97a6                	add	a5,a5,s1
    800058f6:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800058fa:	fc042783          	lw	a5,-64(s0)
    800058fe:	07e9                	addi	a5,a5,26
    80005900:	078e                	slli	a5,a5,0x3
    80005902:	94be                	add	s1,s1,a5
    80005904:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005908:	fd043503          	ld	a0,-48(s0)
    8000590c:	bf1fe0ef          	jal	800044fc <fileclose>
    fileclose(wf);
    80005910:	fc843503          	ld	a0,-56(s0)
    80005914:	be9fe0ef          	jal	800044fc <fileclose>
    return -1;
    80005918:	57fd                	li	a5,-1
    8000591a:	a01d                	j	80005940 <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000591c:	fc442783          	lw	a5,-60(s0)
    80005920:	0007c763          	bltz	a5,8000592e <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005924:	07e9                	addi	a5,a5,26
    80005926:	078e                	slli	a5,a5,0x3
    80005928:	97a6                	add	a5,a5,s1
    8000592a:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000592e:	fd043503          	ld	a0,-48(s0)
    80005932:	bcbfe0ef          	jal	800044fc <fileclose>
    fileclose(wf);
    80005936:	fc843503          	ld	a0,-56(s0)
    8000593a:	bc3fe0ef          	jal	800044fc <fileclose>
    return -1;
    8000593e:	57fd                	li	a5,-1
}
    80005940:	853e                	mv	a0,a5
    80005942:	70e2                	ld	ra,56(sp)
    80005944:	7442                	ld	s0,48(sp)
    80005946:	74a2                	ld	s1,40(sp)
    80005948:	6121                	addi	sp,sp,64
    8000594a:	8082                	ret
    8000594c:	0000                	unimp
	...

0000000080005950 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005950:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005952:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005954:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005956:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005958:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000595a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000595c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000595e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005960:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005962:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005964:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005966:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005968:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000596a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000596c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000596e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005970:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005972:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005974:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005976:	8f2fd0ef          	jal	80002a68 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000597a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000597c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000597e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005980:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005982:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005984:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005986:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005988:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000598a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000598c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000598e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005990:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005992:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005994:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005996:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005998:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000599a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000599c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000599e:	10200073          	sret
	...

00000000800059ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800059ae:	1141                	addi	sp,sp,-16
    800059b0:	e406                	sd	ra,8(sp)
    800059b2:	e022                	sd	s0,0(sp)
    800059b4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800059b6:	0c000737          	lui	a4,0xc000
    800059ba:	4785                	li	a5,1
    800059bc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800059be:	c35c                	sw	a5,4(a4)
}
    800059c0:	60a2                	ld	ra,8(sp)
    800059c2:	6402                	ld	s0,0(sp)
    800059c4:	0141                	addi	sp,sp,16
    800059c6:	8082                	ret

00000000800059c8 <plicinithart>:

void
plicinithart(void)
{
    800059c8:	1141                	addi	sp,sp,-16
    800059ca:	e406                	sd	ra,8(sp)
    800059cc:	e022                	sd	s0,0(sp)
    800059ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800059d0:	ebbfb0ef          	jal	8000188a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800059d4:	0085171b          	slliw	a4,a0,0x8
    800059d8:	0c0027b7          	lui	a5,0xc002
    800059dc:	97ba                	add	a5,a5,a4
    800059de:	40200713          	li	a4,1026
    800059e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800059e6:	00d5151b          	slliw	a0,a0,0xd
    800059ea:	0c2017b7          	lui	a5,0xc201
    800059ee:	97aa                	add	a5,a5,a0
    800059f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800059f4:	60a2                	ld	ra,8(sp)
    800059f6:	6402                	ld	s0,0(sp)
    800059f8:	0141                	addi	sp,sp,16
    800059fa:	8082                	ret

00000000800059fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800059fc:	1141                	addi	sp,sp,-16
    800059fe:	e406                	sd	ra,8(sp)
    80005a00:	e022                	sd	s0,0(sp)
    80005a02:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005a04:	e87fb0ef          	jal	8000188a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005a08:	00d5151b          	slliw	a0,a0,0xd
    80005a0c:	0c2017b7          	lui	a5,0xc201
    80005a10:	97aa                	add	a5,a5,a0
  return irq;
}
    80005a12:	43c8                	lw	a0,4(a5)
    80005a14:	60a2                	ld	ra,8(sp)
    80005a16:	6402                	ld	s0,0(sp)
    80005a18:	0141                	addi	sp,sp,16
    80005a1a:	8082                	ret

0000000080005a1c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005a1c:	1101                	addi	sp,sp,-32
    80005a1e:	ec06                	sd	ra,24(sp)
    80005a20:	e822                	sd	s0,16(sp)
    80005a22:	e426                	sd	s1,8(sp)
    80005a24:	1000                	addi	s0,sp,32
    80005a26:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005a28:	e63fb0ef          	jal	8000188a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005a2c:	00d5179b          	slliw	a5,a0,0xd
    80005a30:	0c201737          	lui	a4,0xc201
    80005a34:	97ba                	add	a5,a5,a4
    80005a36:	c3c4                	sw	s1,4(a5)
}
    80005a38:	60e2                	ld	ra,24(sp)
    80005a3a:	6442                	ld	s0,16(sp)
    80005a3c:	64a2                	ld	s1,8(sp)
    80005a3e:	6105                	addi	sp,sp,32
    80005a40:	8082                	ret

0000000080005a42 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005a42:	1141                	addi	sp,sp,-16
    80005a44:	e406                	sd	ra,8(sp)
    80005a46:	e022                	sd	s0,0(sp)
    80005a48:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005a4a:	479d                	li	a5,7
    80005a4c:	04a7ca63          	blt	a5,a0,80005aa0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005a50:	0001b797          	auipc	a5,0x1b
    80005a54:	3f878793          	addi	a5,a5,1016 # 80020e48 <disk>
    80005a58:	97aa                	add	a5,a5,a0
    80005a5a:	0187c783          	lbu	a5,24(a5)
    80005a5e:	e7b9                	bnez	a5,80005aac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005a60:	00451693          	slli	a3,a0,0x4
    80005a64:	0001b797          	auipc	a5,0x1b
    80005a68:	3e478793          	addi	a5,a5,996 # 80020e48 <disk>
    80005a6c:	6398                	ld	a4,0(a5)
    80005a6e:	9736                	add	a4,a4,a3
    80005a70:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005a74:	6398                	ld	a4,0(a5)
    80005a76:	9736                	add	a4,a4,a3
    80005a78:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005a7c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005a80:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005a84:	97aa                	add	a5,a5,a0
    80005a86:	4705                	li	a4,1
    80005a88:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005a8c:	0001b517          	auipc	a0,0x1b
    80005a90:	3d450513          	addi	a0,a0,980 # 80020e60 <disk+0x18>
    80005a94:	ce0fc0ef          	jal	80001f74 <wakeup>
}
    80005a98:	60a2                	ld	ra,8(sp)
    80005a9a:	6402                	ld	s0,0(sp)
    80005a9c:	0141                	addi	sp,sp,16
    80005a9e:	8082                	ret
    panic("free_desc 1");
    80005aa0:	00002517          	auipc	a0,0x2
    80005aa4:	b7050513          	addi	a0,a0,-1168 # 80007610 <etext+0x610>
    80005aa8:	d37fa0ef          	jal	800007de <panic>
    panic("free_desc 2");
    80005aac:	00002517          	auipc	a0,0x2
    80005ab0:	b7450513          	addi	a0,a0,-1164 # 80007620 <etext+0x620>
    80005ab4:	d2bfa0ef          	jal	800007de <panic>

0000000080005ab8 <virtio_disk_init>:
{
    80005ab8:	1101                	addi	sp,sp,-32
    80005aba:	ec06                	sd	ra,24(sp)
    80005abc:	e822                	sd	s0,16(sp)
    80005abe:	e426                	sd	s1,8(sp)
    80005ac0:	e04a                	sd	s2,0(sp)
    80005ac2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005ac4:	00002597          	auipc	a1,0x2
    80005ac8:	b6c58593          	addi	a1,a1,-1172 # 80007630 <etext+0x630>
    80005acc:	0001b517          	auipc	a0,0x1b
    80005ad0:	4a450513          	addi	a0,a0,1188 # 80020f70 <disk+0x128>
    80005ad4:	874fb0ef          	jal	80000b48 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ad8:	100017b7          	lui	a5,0x10001
    80005adc:	4398                	lw	a4,0(a5)
    80005ade:	2701                	sext.w	a4,a4
    80005ae0:	747277b7          	lui	a5,0x74727
    80005ae4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005ae8:	14f71863          	bne	a4,a5,80005c38 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005aec:	100017b7          	lui	a5,0x10001
    80005af0:	43dc                	lw	a5,4(a5)
    80005af2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005af4:	4709                	li	a4,2
    80005af6:	14e79163          	bne	a5,a4,80005c38 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005afa:	100017b7          	lui	a5,0x10001
    80005afe:	479c                	lw	a5,8(a5)
    80005b00:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005b02:	12e79b63          	bne	a5,a4,80005c38 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005b06:	100017b7          	lui	a5,0x10001
    80005b0a:	47d8                	lw	a4,12(a5)
    80005b0c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005b0e:	554d47b7          	lui	a5,0x554d4
    80005b12:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005b16:	12f71163          	bne	a4,a5,80005c38 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b1a:	100017b7          	lui	a5,0x10001
    80005b1e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b22:	4705                	li	a4,1
    80005b24:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b26:	470d                	li	a4,3
    80005b28:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005b2a:	10001737          	lui	a4,0x10001
    80005b2e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005b30:	c7ffe6b7          	lui	a3,0xc7ffe
    80005b34:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd7d7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005b38:	8f75                	and	a4,a4,a3
    80005b3a:	100016b7          	lui	a3,0x10001
    80005b3e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b40:	472d                	li	a4,11
    80005b42:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b44:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005b48:	439c                	lw	a5,0(a5)
    80005b4a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005b4e:	8ba1                	andi	a5,a5,8
    80005b50:	0e078a63          	beqz	a5,80005c44 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005b54:	100017b7          	lui	a5,0x10001
    80005b58:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005b5c:	43fc                	lw	a5,68(a5)
    80005b5e:	2781                	sext.w	a5,a5
    80005b60:	0e079863          	bnez	a5,80005c50 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005b64:	100017b7          	lui	a5,0x10001
    80005b68:	5bdc                	lw	a5,52(a5)
    80005b6a:	2781                	sext.w	a5,a5
  if(max == 0)
    80005b6c:	0e078863          	beqz	a5,80005c5c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005b70:	471d                	li	a4,7
    80005b72:	0ef77b63          	bgeu	a4,a5,80005c68 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005b76:	f83fa0ef          	jal	80000af8 <kalloc>
    80005b7a:	0001b497          	auipc	s1,0x1b
    80005b7e:	2ce48493          	addi	s1,s1,718 # 80020e48 <disk>
    80005b82:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005b84:	f75fa0ef          	jal	80000af8 <kalloc>
    80005b88:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005b8a:	f6ffa0ef          	jal	80000af8 <kalloc>
    80005b8e:	87aa                	mv	a5,a0
    80005b90:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005b92:	6088                	ld	a0,0(s1)
    80005b94:	0e050063          	beqz	a0,80005c74 <virtio_disk_init+0x1bc>
    80005b98:	0001b717          	auipc	a4,0x1b
    80005b9c:	2b873703          	ld	a4,696(a4) # 80020e50 <disk+0x8>
    80005ba0:	cb71                	beqz	a4,80005c74 <virtio_disk_init+0x1bc>
    80005ba2:	cbe9                	beqz	a5,80005c74 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005ba4:	6605                	lui	a2,0x1
    80005ba6:	4581                	li	a1,0
    80005ba8:	8f4fb0ef          	jal	80000c9c <memset>
  memset(disk.avail, 0, PGSIZE);
    80005bac:	0001b497          	auipc	s1,0x1b
    80005bb0:	29c48493          	addi	s1,s1,668 # 80020e48 <disk>
    80005bb4:	6605                	lui	a2,0x1
    80005bb6:	4581                	li	a1,0
    80005bb8:	6488                	ld	a0,8(s1)
    80005bba:	8e2fb0ef          	jal	80000c9c <memset>
  memset(disk.used, 0, PGSIZE);
    80005bbe:	6605                	lui	a2,0x1
    80005bc0:	4581                	li	a1,0
    80005bc2:	6888                	ld	a0,16(s1)
    80005bc4:	8d8fb0ef          	jal	80000c9c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005bc8:	100017b7          	lui	a5,0x10001
    80005bcc:	4721                	li	a4,8
    80005bce:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005bd0:	4098                	lw	a4,0(s1)
    80005bd2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005bd6:	40d8                	lw	a4,4(s1)
    80005bd8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005bdc:	649c                	ld	a5,8(s1)
    80005bde:	0007869b          	sext.w	a3,a5
    80005be2:	10001737          	lui	a4,0x10001
    80005be6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005bea:	9781                	srai	a5,a5,0x20
    80005bec:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005bf0:	689c                	ld	a5,16(s1)
    80005bf2:	0007869b          	sext.w	a3,a5
    80005bf6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005bfa:	9781                	srai	a5,a5,0x20
    80005bfc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005c00:	4785                	li	a5,1
    80005c02:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005c04:	00f48c23          	sb	a5,24(s1)
    80005c08:	00f48ca3          	sb	a5,25(s1)
    80005c0c:	00f48d23          	sb	a5,26(s1)
    80005c10:	00f48da3          	sb	a5,27(s1)
    80005c14:	00f48e23          	sb	a5,28(s1)
    80005c18:	00f48ea3          	sb	a5,29(s1)
    80005c1c:	00f48f23          	sb	a5,30(s1)
    80005c20:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005c24:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005c28:	07272823          	sw	s2,112(a4)
}
    80005c2c:	60e2                	ld	ra,24(sp)
    80005c2e:	6442                	ld	s0,16(sp)
    80005c30:	64a2                	ld	s1,8(sp)
    80005c32:	6902                	ld	s2,0(sp)
    80005c34:	6105                	addi	sp,sp,32
    80005c36:	8082                	ret
    panic("could not find virtio disk");
    80005c38:	00002517          	auipc	a0,0x2
    80005c3c:	a0850513          	addi	a0,a0,-1528 # 80007640 <etext+0x640>
    80005c40:	b9ffa0ef          	jal	800007de <panic>
    panic("virtio disk FEATURES_OK unset");
    80005c44:	00002517          	auipc	a0,0x2
    80005c48:	a1c50513          	addi	a0,a0,-1508 # 80007660 <etext+0x660>
    80005c4c:	b93fa0ef          	jal	800007de <panic>
    panic("virtio disk should not be ready");
    80005c50:	00002517          	auipc	a0,0x2
    80005c54:	a3050513          	addi	a0,a0,-1488 # 80007680 <etext+0x680>
    80005c58:	b87fa0ef          	jal	800007de <panic>
    panic("virtio disk has no queue 0");
    80005c5c:	00002517          	auipc	a0,0x2
    80005c60:	a4450513          	addi	a0,a0,-1468 # 800076a0 <etext+0x6a0>
    80005c64:	b7bfa0ef          	jal	800007de <panic>
    panic("virtio disk max queue too short");
    80005c68:	00002517          	auipc	a0,0x2
    80005c6c:	a5850513          	addi	a0,a0,-1448 # 800076c0 <etext+0x6c0>
    80005c70:	b6ffa0ef          	jal	800007de <panic>
    panic("virtio disk kalloc");
    80005c74:	00002517          	auipc	a0,0x2
    80005c78:	a6c50513          	addi	a0,a0,-1428 # 800076e0 <etext+0x6e0>
    80005c7c:	b63fa0ef          	jal	800007de <panic>

0000000080005c80 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005c80:	711d                	addi	sp,sp,-96
    80005c82:	ec86                	sd	ra,88(sp)
    80005c84:	e8a2                	sd	s0,80(sp)
    80005c86:	e4a6                	sd	s1,72(sp)
    80005c88:	e0ca                	sd	s2,64(sp)
    80005c8a:	fc4e                	sd	s3,56(sp)
    80005c8c:	f852                	sd	s4,48(sp)
    80005c8e:	f456                	sd	s5,40(sp)
    80005c90:	f05a                	sd	s6,32(sp)
    80005c92:	ec5e                	sd	s7,24(sp)
    80005c94:	e862                	sd	s8,16(sp)
    80005c96:	1080                	addi	s0,sp,96
    80005c98:	89aa                	mv	s3,a0
    80005c9a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005c9c:	00c52b83          	lw	s7,12(a0)
    80005ca0:	001b9b9b          	slliw	s7,s7,0x1
    80005ca4:	1b82                	slli	s7,s7,0x20
    80005ca6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005caa:	0001b517          	auipc	a0,0x1b
    80005cae:	2c650513          	addi	a0,a0,710 # 80020f70 <disk+0x128>
    80005cb2:	f1bfa0ef          	jal	80000bcc <acquire>
  for(int i = 0; i < NUM; i++){
    80005cb6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005cb8:	0001ba97          	auipc	s5,0x1b
    80005cbc:	190a8a93          	addi	s5,s5,400 # 80020e48 <disk>
  for(int i = 0; i < 3; i++){
    80005cc0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005cc2:	5c7d                	li	s8,-1
    80005cc4:	a095                	j	80005d28 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005cc6:	00fa8733          	add	a4,s5,a5
    80005cca:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005cce:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005cd0:	0207c563          	bltz	a5,80005cfa <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80005cd4:	2905                	addiw	s2,s2,1
    80005cd6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005cd8:	05490c63          	beq	s2,s4,80005d30 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80005cdc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005cde:	0001b717          	auipc	a4,0x1b
    80005ce2:	16a70713          	addi	a4,a4,362 # 80020e48 <disk>
    80005ce6:	4781                	li	a5,0
    if(disk.free[i]){
    80005ce8:	01874683          	lbu	a3,24(a4)
    80005cec:	fee9                	bnez	a3,80005cc6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80005cee:	2785                	addiw	a5,a5,1
    80005cf0:	0705                	addi	a4,a4,1
    80005cf2:	fe979be3          	bne	a5,s1,80005ce8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005cf6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80005cfa:	01205d63          	blez	s2,80005d14 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005cfe:	fa042503          	lw	a0,-96(s0)
    80005d02:	d41ff0ef          	jal	80005a42 <free_desc>
      for(int j = 0; j < i; j++)
    80005d06:	4785                	li	a5,1
    80005d08:	0127d663          	bge	a5,s2,80005d14 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005d0c:	fa442503          	lw	a0,-92(s0)
    80005d10:	d33ff0ef          	jal	80005a42 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005d14:	0001b597          	auipc	a1,0x1b
    80005d18:	25c58593          	addi	a1,a1,604 # 80020f70 <disk+0x128>
    80005d1c:	0001b517          	auipc	a0,0x1b
    80005d20:	14450513          	addi	a0,a0,324 # 80020e60 <disk+0x18>
    80005d24:	a04fc0ef          	jal	80001f28 <sleep>
  for(int i = 0; i < 3; i++){
    80005d28:	fa040613          	addi	a2,s0,-96
    80005d2c:	4901                	li	s2,0
    80005d2e:	b77d                	j	80005cdc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005d30:	fa042503          	lw	a0,-96(s0)
    80005d34:	00451693          	slli	a3,a0,0x4

  if(write)
    80005d38:	0001b797          	auipc	a5,0x1b
    80005d3c:	11078793          	addi	a5,a5,272 # 80020e48 <disk>
    80005d40:	00a50713          	addi	a4,a0,10
    80005d44:	0712                	slli	a4,a4,0x4
    80005d46:	973e                	add	a4,a4,a5
    80005d48:	01603633          	snez	a2,s6
    80005d4c:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005d4e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005d52:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005d56:	6398                	ld	a4,0(a5)
    80005d58:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005d5a:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005d5e:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005d60:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005d62:	6390                	ld	a2,0(a5)
    80005d64:	00d605b3          	add	a1,a2,a3
    80005d68:	4741                	li	a4,16
    80005d6a:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005d6c:	4805                	li	a6,1
    80005d6e:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005d72:	fa442703          	lw	a4,-92(s0)
    80005d76:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005d7a:	0712                	slli	a4,a4,0x4
    80005d7c:	963a                	add	a2,a2,a4
    80005d7e:	05898593          	addi	a1,s3,88
    80005d82:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005d84:	0007b883          	ld	a7,0(a5)
    80005d88:	9746                	add	a4,a4,a7
    80005d8a:	40000613          	li	a2,1024
    80005d8e:	c710                	sw	a2,8(a4)
  if(write)
    80005d90:	001b3613          	seqz	a2,s6
    80005d94:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005d98:	01066633          	or	a2,a2,a6
    80005d9c:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005da0:	fa842583          	lw	a1,-88(s0)
    80005da4:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005da8:	00250613          	addi	a2,a0,2
    80005dac:	0612                	slli	a2,a2,0x4
    80005dae:	963e                	add	a2,a2,a5
    80005db0:	577d                	li	a4,-1
    80005db2:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005db6:	0592                	slli	a1,a1,0x4
    80005db8:	98ae                	add	a7,a7,a1
    80005dba:	03068713          	addi	a4,a3,48
    80005dbe:	973e                	add	a4,a4,a5
    80005dc0:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005dc4:	6398                	ld	a4,0(a5)
    80005dc6:	972e                	add	a4,a4,a1
    80005dc8:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005dcc:	4689                	li	a3,2
    80005dce:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005dd2:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005dd6:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80005dda:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005dde:	6794                	ld	a3,8(a5)
    80005de0:	0026d703          	lhu	a4,2(a3)
    80005de4:	8b1d                	andi	a4,a4,7
    80005de6:	0706                	slli	a4,a4,0x1
    80005de8:	96ba                	add	a3,a3,a4
    80005dea:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005dee:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005df2:	6798                	ld	a4,8(a5)
    80005df4:	00275783          	lhu	a5,2(a4)
    80005df8:	2785                	addiw	a5,a5,1
    80005dfa:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005dfe:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005e02:	100017b7          	lui	a5,0x10001
    80005e06:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005e0a:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005e0e:	0001b917          	auipc	s2,0x1b
    80005e12:	16290913          	addi	s2,s2,354 # 80020f70 <disk+0x128>
  while(b->disk == 1) {
    80005e16:	84c2                	mv	s1,a6
    80005e18:	01079a63          	bne	a5,a6,80005e2c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80005e1c:	85ca                	mv	a1,s2
    80005e1e:	854e                	mv	a0,s3
    80005e20:	908fc0ef          	jal	80001f28 <sleep>
  while(b->disk == 1) {
    80005e24:	0049a783          	lw	a5,4(s3)
    80005e28:	fe978ae3          	beq	a5,s1,80005e1c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80005e2c:	fa042903          	lw	s2,-96(s0)
    80005e30:	00290713          	addi	a4,s2,2
    80005e34:	0712                	slli	a4,a4,0x4
    80005e36:	0001b797          	auipc	a5,0x1b
    80005e3a:	01278793          	addi	a5,a5,18 # 80020e48 <disk>
    80005e3e:	97ba                	add	a5,a5,a4
    80005e40:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005e44:	0001b997          	auipc	s3,0x1b
    80005e48:	00498993          	addi	s3,s3,4 # 80020e48 <disk>
    80005e4c:	00491713          	slli	a4,s2,0x4
    80005e50:	0009b783          	ld	a5,0(s3)
    80005e54:	97ba                	add	a5,a5,a4
    80005e56:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005e5a:	854a                	mv	a0,s2
    80005e5c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005e60:	be3ff0ef          	jal	80005a42 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005e64:	8885                	andi	s1,s1,1
    80005e66:	f0fd                	bnez	s1,80005e4c <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005e68:	0001b517          	auipc	a0,0x1b
    80005e6c:	10850513          	addi	a0,a0,264 # 80020f70 <disk+0x128>
    80005e70:	df1fa0ef          	jal	80000c60 <release>
}
    80005e74:	60e6                	ld	ra,88(sp)
    80005e76:	6446                	ld	s0,80(sp)
    80005e78:	64a6                	ld	s1,72(sp)
    80005e7a:	6906                	ld	s2,64(sp)
    80005e7c:	79e2                	ld	s3,56(sp)
    80005e7e:	7a42                	ld	s4,48(sp)
    80005e80:	7aa2                	ld	s5,40(sp)
    80005e82:	7b02                	ld	s6,32(sp)
    80005e84:	6be2                	ld	s7,24(sp)
    80005e86:	6c42                	ld	s8,16(sp)
    80005e88:	6125                	addi	sp,sp,96
    80005e8a:	8082                	ret

0000000080005e8c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005e8c:	1101                	addi	sp,sp,-32
    80005e8e:	ec06                	sd	ra,24(sp)
    80005e90:	e822                	sd	s0,16(sp)
    80005e92:	e426                	sd	s1,8(sp)
    80005e94:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005e96:	0001b497          	auipc	s1,0x1b
    80005e9a:	fb248493          	addi	s1,s1,-78 # 80020e48 <disk>
    80005e9e:	0001b517          	auipc	a0,0x1b
    80005ea2:	0d250513          	addi	a0,a0,210 # 80020f70 <disk+0x128>
    80005ea6:	d27fa0ef          	jal	80000bcc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005eaa:	100017b7          	lui	a5,0x10001
    80005eae:	53bc                	lw	a5,96(a5)
    80005eb0:	8b8d                	andi	a5,a5,3
    80005eb2:	10001737          	lui	a4,0x10001
    80005eb6:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005eb8:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005ebc:	689c                	ld	a5,16(s1)
    80005ebe:	0204d703          	lhu	a4,32(s1)
    80005ec2:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005ec6:	04f70663          	beq	a4,a5,80005f12 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005eca:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005ece:	6898                	ld	a4,16(s1)
    80005ed0:	0204d783          	lhu	a5,32(s1)
    80005ed4:	8b9d                	andi	a5,a5,7
    80005ed6:	078e                	slli	a5,a5,0x3
    80005ed8:	97ba                	add	a5,a5,a4
    80005eda:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005edc:	00278713          	addi	a4,a5,2
    80005ee0:	0712                	slli	a4,a4,0x4
    80005ee2:	9726                	add	a4,a4,s1
    80005ee4:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005ee8:	e321                	bnez	a4,80005f28 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005eea:	0789                	addi	a5,a5,2
    80005eec:	0792                	slli	a5,a5,0x4
    80005eee:	97a6                	add	a5,a5,s1
    80005ef0:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005ef2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005ef6:	87efc0ef          	jal	80001f74 <wakeup>

    disk.used_idx += 1;
    80005efa:	0204d783          	lhu	a5,32(s1)
    80005efe:	2785                	addiw	a5,a5,1
    80005f00:	17c2                	slli	a5,a5,0x30
    80005f02:	93c1                	srli	a5,a5,0x30
    80005f04:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005f08:	6898                	ld	a4,16(s1)
    80005f0a:	00275703          	lhu	a4,2(a4)
    80005f0e:	faf71ee3          	bne	a4,a5,80005eca <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005f12:	0001b517          	auipc	a0,0x1b
    80005f16:	05e50513          	addi	a0,a0,94 # 80020f70 <disk+0x128>
    80005f1a:	d47fa0ef          	jal	80000c60 <release>
}
    80005f1e:	60e2                	ld	ra,24(sp)
    80005f20:	6442                	ld	s0,16(sp)
    80005f22:	64a2                	ld	s1,8(sp)
    80005f24:	6105                	addi	sp,sp,32
    80005f26:	8082                	ret
      panic("virtio_disk_intr status");
    80005f28:	00001517          	auipc	a0,0x1
    80005f2c:	7d050513          	addi	a0,a0,2000 # 800076f8 <etext+0x6f8>
    80005f30:	8affa0ef          	jal	800007de <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051573          	csrrw	a0,sscratch,a0
    80006004:	02153423          	sd	ra,40(a0)
    80006008:	02253823          	sd	sp,48(a0)
    8000600c:	02353c23          	sd	gp,56(a0)
    80006010:	04453023          	sd	tp,64(a0)
    80006014:	04553423          	sd	t0,72(a0)
    80006018:	04653823          	sd	t1,80(a0)
    8000601c:	04753c23          	sd	t2,88(a0)
    80006020:	f120                	sd	s0,96(a0)
    80006022:	f524                	sd	s1,104(a0)
    80006024:	fd2c                	sd	a1,120(a0)
    80006026:	e150                	sd	a2,128(a0)
    80006028:	e554                	sd	a3,136(a0)
    8000602a:	e958                	sd	a4,144(a0)
    8000602c:	ed5c                	sd	a5,152(a0)
    8000602e:	0b053023          	sd	a6,160(a0)
    80006032:	0b153423          	sd	a7,168(a0)
    80006036:	0b253823          	sd	s2,176(a0)
    8000603a:	0b353c23          	sd	s3,184(a0)
    8000603e:	0d453023          	sd	s4,192(a0)
    80006042:	0d553423          	sd	s5,200(a0)
    80006046:	0d653823          	sd	s6,208(a0)
    8000604a:	0d753c23          	sd	s7,216(a0)
    8000604e:	0f853023          	sd	s8,224(a0)
    80006052:	0f953423          	sd	s9,232(a0)
    80006056:	0fa53823          	sd	s10,240(a0)
    8000605a:	0fb53c23          	sd	s11,248(a0)
    8000605e:	11c53023          	sd	t3,256(a0)
    80006062:	11d53423          	sd	t4,264(a0)
    80006066:	11e53823          	sd	t5,272(a0)
    8000606a:	11f53c23          	sd	t6,280(a0)
    8000606e:	140022f3          	csrr	t0,sscratch
    80006072:	06553823          	sd	t0,112(a0)
    80006076:	00853103          	ld	sp,8(a0)
    8000607a:	02053203          	ld	tp,32(a0)
    8000607e:	01053283          	ld	t0,16(a0)
    80006082:	00053303          	ld	t1,0(a0)
    80006086:	12000073          	sfence.vma
    8000608a:	18031073          	csrw	satp,t1
    8000608e:	12000073          	sfence.vma
    80006092:	9282                	jalr	t0

0000000080006094 <userret>:
    80006094:	12000073          	sfence.vma
    80006098:	18051073          	csrw	satp,a0
    8000609c:	12000073          	sfence.vma
    800060a0:	14002573          	csrr	a0,sscratch
    800060a4:	02853083          	ld	ra,40(a0)
    800060a8:	03053103          	ld	sp,48(a0)
    800060ac:	03853183          	ld	gp,56(a0)
    800060b0:	04053203          	ld	tp,64(a0)
    800060b4:	04853283          	ld	t0,72(a0)
    800060b8:	05053303          	ld	t1,80(a0)
    800060bc:	05853383          	ld	t2,88(a0)
    800060c0:	7120                	ld	s0,96(a0)
    800060c2:	7524                	ld	s1,104(a0)
    800060c4:	7d2c                	ld	a1,120(a0)
    800060c6:	6150                	ld	a2,128(a0)
    800060c8:	6554                	ld	a3,136(a0)
    800060ca:	6958                	ld	a4,144(a0)
    800060cc:	6d5c                	ld	a5,152(a0)
    800060ce:	0a053803          	ld	a6,160(a0)
    800060d2:	0a853883          	ld	a7,168(a0)
    800060d6:	0b053903          	ld	s2,176(a0)
    800060da:	0b853983          	ld	s3,184(a0)
    800060de:	0c053a03          	ld	s4,192(a0)
    800060e2:	0c853a83          	ld	s5,200(a0)
    800060e6:	0d053b03          	ld	s6,208(a0)
    800060ea:	0d853b83          	ld	s7,216(a0)
    800060ee:	0e053c03          	ld	s8,224(a0)
    800060f2:	0e853c83          	ld	s9,232(a0)
    800060f6:	0f053d03          	ld	s10,240(a0)
    800060fa:	0f853d83          	ld	s11,248(a0)
    800060fe:	10053e03          	ld	t3,256(a0)
    80006102:	10853e83          	ld	t4,264(a0)
    80006106:	11053f03          	ld	t5,272(a0)
    8000610a:	11853f83          	ld	t6,280(a0)
    8000610e:	7928                	ld	a0,112(a0)
    80006110:	10200073          	sret
	...
