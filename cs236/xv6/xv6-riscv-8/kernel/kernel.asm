
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
    80000004:	87010113          	addi	sp,sp,-1936 # 80007870 <stack0>
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
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdda87>
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
    8000011a:	336020ef          	jal	80002450 <either_copyin>
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
    80000196:	6de50513          	addi	a0,a0,1758 # 8000f870 <cons>
    8000019a:	233000ef          	jal	80000bcc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	0000f497          	auipc	s1,0xf
    800001a2:	6d248493          	addi	s1,s1,1746 # 8000f870 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	0000f917          	auipc	s2,0xf
    800001aa:	76290913          	addi	s2,s2,1890 # 8000f908 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	700010ef          	jal	800018be <myproc>
    800001c2:	0ec020ef          	jal	800022ae <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	60b010ef          	jal	80001fd6 <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	0000f717          	auipc	a4,0xf
    800001e2:	69270713          	addi	a4,a4,1682 # 8000f870 <cons>
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
    80000210:	1f6020ef          	jal	80002406 <either_copyout>
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
    8000022c:	64850513          	addi	a0,a0,1608 # 8000f870 <cons>
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
    80000252:	6af72d23          	sw	a5,1722(a4) # 8000f908 <cons+0x98>
    80000256:	6be2                	ld	s7,24(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	ec5e                	sd	s7,24(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	6be2                	ld	s7,24(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000264:	0000f517          	auipc	a0,0xf
    80000268:	60c50513          	addi	a0,a0,1548 # 8000f870 <cons>
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
    800002bc:	5b850513          	addi	a0,a0,1464 # 8000f870 <cons>
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
    800002da:	1c0020ef          	jal	8000249a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002de:	0000f517          	auipc	a0,0xf
    800002e2:	59250513          	addi	a0,a0,1426 # 8000f870 <cons>
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
    80000300:	57470713          	addi	a4,a4,1396 # 8000f870 <cons>
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
    80000326:	54e78793          	addi	a5,a5,1358 # 8000f870 <cons>
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
    80000352:	5ba7a783          	lw	a5,1466(a5) # 8000f908 <cons+0x98>
    80000356:	9f1d                	subw	a4,a4,a5
    80000358:	08000793          	li	a5,128
    8000035c:	f8f711e3          	bne	a4,a5,800002de <consoleintr+0x32>
    80000360:	a85d                	j	80000416 <consoleintr+0x16a>
    80000362:	e84a                	sd	s2,16(sp)
    80000364:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80000366:	0000f717          	auipc	a4,0xf
    8000036a:	50a70713          	addi	a4,a4,1290 # 8000f870 <cons>
    8000036e:	0a072783          	lw	a5,160(a4)
    80000372:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000376:	0000f497          	auipc	s1,0xf
    8000037a:	4fa48493          	addi	s1,s1,1274 # 8000f870 <cons>
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
    800003c4:	4b070713          	addi	a4,a4,1200 # 8000f870 <cons>
    800003c8:	0a072783          	lw	a5,160(a4)
    800003cc:	09c72703          	lw	a4,156(a4)
    800003d0:	f0f707e3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003d4:	37fd                	addiw	a5,a5,-1
    800003d6:	0000f717          	auipc	a4,0xf
    800003da:	52f72d23          	sw	a5,1338(a4) # 8000f910 <cons+0xa0>
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
    800003f8:	47c78793          	addi	a5,a5,1148 # 8000f870 <cons>
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
    8000041a:	4ec7ab23          	sw	a2,1270(a5) # 8000f90c <cons+0x9c>
        wakeup(&cons.r);
    8000041e:	0000f517          	auipc	a0,0xf
    80000422:	4ea50513          	addi	a0,a0,1258 # 8000f908 <cons+0x98>
    80000426:	3fd010ef          	jal	80002022 <wakeup>
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
    80000440:	43450513          	addi	a0,a0,1076 # 8000f870 <cons>
    80000444:	704000ef          	jal	80000b48 <initlock>

  uartinit();
    80000448:	3f6000ef          	jal	8000083e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000044c:	0001f797          	auipc	a5,0x1f
    80000450:	79478793          	addi	a5,a5,1940 # 8001fbe0 <devsw>
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
    8000051c:	32c7a783          	lw	a5,812(a5) # 80007844 <panicking>
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
    80000564:	3b850513          	addi	a0,a0,952 # 8000f918 <pr>
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
    800007be:	08a7a783          	lw	a5,138(a5) # 80007844 <panicking>
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
    800007d4:	14850513          	addi	a0,a0,328 # 8000f918 <pr>
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
    800007f2:	0527ab23          	sw	s2,86(a5) # 80007844 <panicking>
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
    80000814:	0327a823          	sw	s2,48(a5) # 80007840 <panicked>
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
    8000082e:	0ee50513          	addi	a0,a0,238 # 8000f918 <pr>
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
    80000884:	0b050513          	addi	a0,a0,176 # 8000f930 <tx_lock>
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
    800008a8:	08c50513          	addi	a0,a0,140 # 8000f930 <tx_lock>
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
    800008c6:	f8a48493          	addi	s1,s1,-118 # 8000784c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    800008ca:	0000f997          	auipc	s3,0xf
    800008ce:	06698993          	addi	s3,s3,102 # 8000f930 <tx_lock>
    800008d2:	00007917          	auipc	s2,0x7
    800008d6:	f7690913          	addi	s2,s2,-138 # 80007848 <tx_chan>
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
    800008e6:	6f0010ef          	jal	80001fd6 <sleep>
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
    80000914:	02050513          	addi	a0,a0,32 # 8000f930 <tx_lock>
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
    80000938:	f107a783          	lw	a5,-240(a5) # 80007844 <panicking>
    8000093c:	cf95                	beqz	a5,80000978 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    8000093e:	00007797          	auipc	a5,0x7
    80000942:	f027a783          	lw	a5,-254(a5) # 80007840 <panicked>
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
    80000968:	ee07a783          	lw	a5,-288(a5) # 80007844 <panicking>
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
    800009c4:	f7050513          	addi	a0,a0,-144 # 8000f930 <tx_lock>
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
    800009de:	f5650513          	addi	a0,a0,-170 # 8000f930 <tx_lock>
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
    800009fa:	e407ab23          	sw	zero,-426(a5) # 8000784c <tx_busy>
    wakeup(&tx_chan);
    800009fe:	00007517          	auipc	a0,0x7
    80000a02:	e4a50513          	addi	a0,a0,-438 # 80007848 <tx_chan>
    80000a06:	61c010ef          	jal	80002022 <wakeup>
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
    80000a2e:	34e78793          	addi	a5,a5,846 # 80020d78 <end>
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
    80000a4a:	f0290913          	addi	s2,s2,-254 # 8000f948 <kmem>
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
    80000ad8:	e7450513          	addi	a0,a0,-396 # 8000f948 <kmem>
    80000adc:	06c000ef          	jal	80000b48 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ae0:	45c5                	li	a1,17
    80000ae2:	05ee                	slli	a1,a1,0x1b
    80000ae4:	00020517          	auipc	a0,0x20
    80000ae8:	29450513          	addi	a0,a0,660 # 80020d78 <end>
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
    80000b06:	e4648493          	addi	s1,s1,-442 # 8000f948 <kmem>
    80000b0a:	8526                	mv	a0,s1
    80000b0c:	0c0000ef          	jal	80000bcc <acquire>
  r = kmem.freelist;
    80000b10:	6c84                	ld	s1,24(s1)
  if(r)
    80000b12:	c485                	beqz	s1,80000b3a <kalloc+0x42>
    kmem.freelist = r->next;
    80000b14:	609c                	ld	a5,0(s1)
    80000b16:	0000f517          	auipc	a0,0xf
    80000b1a:	e3250513          	addi	a0,a0,-462 # 8000f948 <kmem>
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
    80000b3e:	e0e50513          	addi	a0,a0,-498 # 8000f948 <kmem>
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
    80000d1a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffde289>
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
    80000e62:	9f270713          	addi	a4,a4,-1550 # 80007850 <started>
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
    80000e88:	1d9010ef          	jal	80002860 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e8c:	33d040ef          	jal	800059c8 <plicinithart>
  }

  scheduler();        
    80000e90:	7af000ef          	jal	80001e3e <scheduler>
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
    80000ed0:	16d010ef          	jal	8000283c <trapinit>
    trapinithart();  // install kernel trap vector
    80000ed4:	18d010ef          	jal	80002860 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ed8:	2d7040ef          	jal	800059ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000edc:	2ed040ef          	jal	800059c8 <plicinithart>
    binit();         // buffer cache
    80000ee0:	0d8020ef          	jal	80002fb8 <binit>
    iinit();         // inode table
    80000ee4:	638020ef          	jal	8000351c <iinit>
    fileinit();      // file table
    80000ee8:	54a030ef          	jal	80004432 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000eec:	3cd040ef          	jal	80005ab8 <virtio_disk_init>
    userinit();      // first user process
    80000ef0:	54d000ef          	jal	80001c3c <userinit>
    __sync_synchronize();
    80000ef4:	0330000f          	fence	rw,rw
    started = 1;
    80000ef8:	4785                	li	a5,1
    80000efa:	00007717          	auipc	a4,0x7
    80000efe:	94f72b23          	sw	a5,-1706(a4) # 80007850 <started>
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
    80000f14:	9487b783          	ld	a5,-1720(a5) # 80007858 <kernel_pagetable>
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
    800011a2:	6aa7bd23          	sd	a0,1722(a5) # 80007858 <kernel_pagetable>
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
void
proc_mapstacks(pagetable_t kpgtbl)
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
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001756:	0000e497          	auipc	s1,0xe
    8000175a:	64248493          	addi	s1,s1,1602 # 8000fd98 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000175e:	8c26                	mv	s8,s1
    80001760:	e9bd37b7          	lui	a5,0xe9bd3
    80001764:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69bb2a2f>
    80001768:	d37a7937          	lui	s2,0xd37a7
    8000176c:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff537861d6>
    80001770:	1902                	slli	s2,s2,0x20
    80001772:	993e                	add	s2,s2,a5
    80001774:	040009b7          	lui	s3,0x4000
    80001778:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000177a:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000177c:	4b99                	li	s7,6
    8000177e:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001780:	00014a97          	auipc	s5,0x14
    80001784:	218a8a93          	addi	s5,s5,536 # 80015998 <tickslock>
    char *pa = kalloc();
    80001788:	b70ff0ef          	jal	80000af8 <kalloc>
    8000178c:	862a                	mv	a2,a0
    if(pa == 0)
    8000178e:	c121                	beqz	a0,800017ce <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80001790:	418485b3          	sub	a1,s1,s8
    80001794:	8591                	srai	a1,a1,0x4
    80001796:	032585b3          	mul	a1,a1,s2
    8000179a:	2585                	addiw	a1,a1,1
    8000179c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017a0:	875e                	mv	a4,s7
    800017a2:	86da                	mv	a3,s6
    800017a4:	40b985b3          	sub	a1,s3,a1
    800017a8:	8552                	mv	a0,s4
    800017aa:	915ff0ef          	jal	800010be <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ae:	17048493          	addi	s1,s1,368
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
void
procinit(void)
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
    800017fa:	17250513          	addi	a0,a0,370 # 8000f968 <pid_lock>
    800017fe:	b4aff0ef          	jal	80000b48 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001802:	00006597          	auipc	a1,0x6
    80001806:	96658593          	addi	a1,a1,-1690 # 80007168 <etext+0x168>
    8000180a:	0000e517          	auipc	a0,0xe
    8000180e:	17650513          	addi	a0,a0,374 # 8000f980 <wait_lock>
    80001812:	b36ff0ef          	jal	80000b48 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001816:	0000e497          	auipc	s1,0xe
    8000181a:	58248493          	addi	s1,s1,1410 # 8000fd98 <proc>
      initlock(&p->lock, "proc");
    8000181e:	00006b17          	auipc	s6,0x6
    80001822:	95ab0b13          	addi	s6,s6,-1702 # 80007178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001826:	8aa6                	mv	s5,s1
    80001828:	e9bd37b7          	lui	a5,0xe9bd3
    8000182c:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69bb2a2f>
    80001830:	d37a7937          	lui	s2,0xd37a7
    80001834:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff537861d6>
    80001838:	1902                	slli	s2,s2,0x20
    8000183a:	993e                	add	s2,s2,a5
    8000183c:	040009b7          	lui	s3,0x4000
    80001840:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001842:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001844:	00014a17          	auipc	s4,0x14
    80001848:	154a0a13          	addi	s4,s4,340 # 80015998 <tickslock>
      initlock(&p->lock, "proc");
    8000184c:	85da                	mv	a1,s6
    8000184e:	8526                	mv	a0,s1
    80001850:	af8ff0ef          	jal	80000b48 <initlock>
      p->state = UNUSED;
    80001854:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001858:	415487b3          	sub	a5,s1,s5
    8000185c:	8791                	srai	a5,a5,0x4
    8000185e:	032787b3          	mul	a5,a5,s2
    80001862:	2785                	addiw	a5,a5,1
    80001864:	00d7979b          	slliw	a5,a5,0xd
    80001868:	40f987b3          	sub	a5,s3,a5
    8000186c:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186e:	17048493          	addi	s1,s1,368
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
int
cpuid()
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
struct cpu*
mycpu(void)
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
    800018b0:	0ec50513          	addi	a0,a0,236 # 8000f998 <cpus>
    800018b4:	953e                	add	a0,a0,a5
    800018b6:	60a2                	ld	ra,8(sp)
    800018b8:	6402                	ld	s0,0(sp)
    800018ba:	0141                	addi	sp,sp,16
    800018bc:	8082                	ret

00000000800018be <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
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
    800018d6:	09670713          	addi	a4,a4,150 # 8000f968 <pid_lock>
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

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
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
    80001906:	f2e7a783          	lw	a5,-210(a5) # 80007830 <first.1>
    8000190a:	cf8d                	beqz	a5,80001944 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000190c:	4505                	li	a0,1
    8000190e:	0c8020ef          	jal	800039d6 <fsinit>

    first = 0;
    80001912:	00006797          	auipc	a5,0x6
    80001916:	f007af23          	sw	zero,-226(a5) # 80007830 <first.1>
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
    80001932:	204030ef          	jal	80004b36 <kexec>
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
    80001944:	739000ef          	jal	8000287c <prepare_return>
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
  ((void (*)(uint64))trampoline_userret)(satp);
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
    80001996:	fd690913          	addi	s2,s2,-42 # 8000f968 <pid_lock>
    8000199a:	854a                	mv	a0,s2
    8000199c:	a30ff0ef          	jal	80000bcc <acquire>
  pid = nextpid;
    800019a0:	00006797          	auipc	a5,0x6
    800019a4:	e9478793          	addi	a5,a5,-364 # 80007834 <nextpid>
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
  if(pagetable == 0)
    800019d8:	c13d                	beqz	a0,80001a3e <proc_pagetable+0x7a>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800019da:	4729                	li	a4,10
    800019dc:	00004697          	auipc	a3,0x4
    800019e0:	62468693          	addi	a3,a3,1572 # 80006000 <_trampoline>
    800019e4:	6605                	lui	a2,0x1
    800019e6:	040005b7          	lui	a1,0x4000
    800019ea:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019ec:	05b2                	slli	a1,a1,0xc
    800019ee:	e1aff0ef          	jal	80001008 <mappages>
    800019f2:	04054d63          	bltz	a0,80001a4c <proc_pagetable+0x88>
  if(mappages(pagetable, TRAPFRAME((int) (p - proc)), PGSIZE,
    800019f6:	0000e797          	auipc	a5,0xe
    800019fa:	3a278793          	addi	a5,a5,930 # 8000fd98 <proc>
    800019fe:	40f907b3          	sub	a5,s2,a5
    80001a02:	8791                	srai	a5,a5,0x4
    80001a04:	e9bd36b7          	lui	a3,0xe9bd3
    80001a08:	7a768693          	addi	a3,a3,1959 # ffffffffe9bd37a7 <end+0xffffffff69bb2a2f>
    80001a0c:	d37a7737          	lui	a4,0xd37a7
    80001a10:	f4e70713          	addi	a4,a4,-178 # ffffffffd37a6f4e <end+0xffffffff537861d6>
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
  if(p->trapframe)
    80001ad8:	7128                	ld	a0,96(a0)
    80001ada:	c119                	beqz	a0,80001ae0 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001adc:	f3bfe0ef          	jal	80000a16 <kfree>
  p->trapframe = 0;
    80001ae0:	0604b023          	sd	zero,96(s1)
  if(p->pagetable) {
    80001ae4:	6ca8                	ld	a0,88(s1)
    80001ae6:	c521                	beqz	a0,80001b2e <freeproc+0x62>
    if (p->pid == p->tgid) {
    80001ae8:	5898                	lw	a4,48(s1)
    80001aea:	58dc                	lw	a5,52(s1)
    80001aec:	06f70c63          	beq	a4,a5,80001b64 <freeproc+0x98>
      uvmunmap(p->pagetable, TRAPFRAME((int) (p - proc)), 1, 0);
    80001af0:	0000e797          	auipc	a5,0xe
    80001af4:	2a878793          	addi	a5,a5,680 # 8000fd98 <proc>
    80001af8:	40f487b3          	sub	a5,s1,a5
    80001afc:	8791                	srai	a5,a5,0x4
    80001afe:	e9bd36b7          	lui	a3,0xe9bd3
    80001b02:	7a768693          	addi	a3,a3,1959 # ffffffffe9bd37a7 <end+0xffffffff69bb2a2f>
    80001b06:	d37a7737          	lui	a4,0xd37a7
    80001b0a:	f4e70713          	addi	a4,a4,-178 # ffffffffd37a6f4e <end+0xffffffff537861d6>
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
  p->tgid = 0;
    80001b3a:	0204aa23          	sw	zero,52(s1)
  p->thread_count = 0;
    80001b3e:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001b42:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001b46:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001b4a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b4e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b52:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b56:	0004ac23          	sw	zero,24(s1)
}
    80001b5a:	60e2                	ld	ra,24(sp)
    80001b5c:	6442                	ld	s0,16(sp)
    80001b5e:	64a2                	ld	s1,8(sp)
    80001b60:	6105                	addi	sp,sp,32
    80001b62:	8082                	ret
      proc_freepagetable(p->pagetable, p->sz, (int) (p - proc));
    80001b64:	0000e617          	auipc	a2,0xe
    80001b68:	23460613          	addi	a2,a2,564 # 8000fd98 <proc>
    80001b6c:	40c48633          	sub	a2,s1,a2
    80001b70:	8611                	srai	a2,a2,0x4
    80001b72:	e9bd3737          	lui	a4,0xe9bd3
    80001b76:	7a770713          	addi	a4,a4,1959 # ffffffffe9bd37a7 <end+0xffffffff69bb2a2f>
    80001b7a:	d37a77b7          	lui	a5,0xd37a7
    80001b7e:	f4e78793          	addi	a5,a5,-178 # ffffffffd37a6f4e <end+0xffffffff537861d6>
    80001b82:	1782                	slli	a5,a5,0x20
    80001b84:	97ba                	add	a5,a5,a4
    80001b86:	02f6063b          	mulw	a2,a2,a5
    80001b8a:	68ac                	ld	a1,80(s1)
    80001b8c:	eebff0ef          	jal	80001a76 <proc_freepagetable>
    80001b90:	bf79                	j	80001b2e <freeproc+0x62>

0000000080001b92 <allocproc>:
{
    80001b92:	1101                	addi	sp,sp,-32
    80001b94:	ec06                	sd	ra,24(sp)
    80001b96:	e822                	sd	s0,16(sp)
    80001b98:	e426                	sd	s1,8(sp)
    80001b9a:	e04a                	sd	s2,0(sp)
    80001b9c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b9e:	0000e497          	auipc	s1,0xe
    80001ba2:	1fa48493          	addi	s1,s1,506 # 8000fd98 <proc>
    80001ba6:	00014917          	auipc	s2,0x14
    80001baa:	df290913          	addi	s2,s2,-526 # 80015998 <tickslock>
    acquire(&p->lock);
    80001bae:	8526                	mv	a0,s1
    80001bb0:	81cff0ef          	jal	80000bcc <acquire>
    if(p->state == UNUSED) {
    80001bb4:	4c9c                	lw	a5,24(s1)
    80001bb6:	cb91                	beqz	a5,80001bca <allocproc+0x38>
      release(&p->lock);
    80001bb8:	8526                	mv	a0,s1
    80001bba:	8a6ff0ef          	jal	80000c60 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bbe:	17048493          	addi	s1,s1,368
    80001bc2:	ff2496e3          	bne	s1,s2,80001bae <allocproc+0x1c>
  return 0;
    80001bc6:	4481                	li	s1,0
    80001bc8:	a099                	j	80001c0e <allocproc+0x7c>
  p->pid = allocpid();
    80001bca:	dbdff0ef          	jal	80001986 <allocpid>
    80001bce:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001bd0:	4785                	li	a5,1
    80001bd2:	cc9c                	sw	a5,24(s1)
  p->tgid = p->pid;
    80001bd4:	d8c8                	sw	a0,52(s1)
  p->thread_count = 1;
    80001bd6:	dc9c                	sw	a5,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001bd8:	f21fe0ef          	jal	80000af8 <kalloc>
    80001bdc:	892a                	mv	s2,a0
    80001bde:	f0a8                	sd	a0,96(s1)
    80001be0:	cd15                	beqz	a0,80001c1c <allocproc+0x8a>
  p->pagetable = proc_pagetable(p);
    80001be2:	8526                	mv	a0,s1
    80001be4:	de1ff0ef          	jal	800019c4 <proc_pagetable>
    80001be8:	892a                	mv	s2,a0
    80001bea:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001bec:	c121                	beqz	a0,80001c2c <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    80001bee:	07000613          	li	a2,112
    80001bf2:	4581                	li	a1,0
    80001bf4:	06848513          	addi	a0,s1,104
    80001bf8:	8a4ff0ef          	jal	80000c9c <memset>
  p->context.ra = (uint64)forkret;
    80001bfc:	00000797          	auipc	a5,0x0
    80001c00:	cf278793          	addi	a5,a5,-782 # 800018ee <forkret>
    80001c04:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c06:	64bc                	ld	a5,72(s1)
    80001c08:	6705                	lui	a4,0x1
    80001c0a:	97ba                	add	a5,a5,a4
    80001c0c:	f8bc                	sd	a5,112(s1)
}
    80001c0e:	8526                	mv	a0,s1
    80001c10:	60e2                	ld	ra,24(sp)
    80001c12:	6442                	ld	s0,16(sp)
    80001c14:	64a2                	ld	s1,8(sp)
    80001c16:	6902                	ld	s2,0(sp)
    80001c18:	6105                	addi	sp,sp,32
    80001c1a:	8082                	ret
    freeproc(p);
    80001c1c:	8526                	mv	a0,s1
    80001c1e:	eafff0ef          	jal	80001acc <freeproc>
    release(&p->lock);
    80001c22:	8526                	mv	a0,s1
    80001c24:	83cff0ef          	jal	80000c60 <release>
    return 0;
    80001c28:	84ca                	mv	s1,s2
    80001c2a:	b7d5                	j	80001c0e <allocproc+0x7c>
    freeproc(p);
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	e9fff0ef          	jal	80001acc <freeproc>
    release(&p->lock);
    80001c32:	8526                	mv	a0,s1
    80001c34:	82cff0ef          	jal	80000c60 <release>
    return 0;
    80001c38:	84ca                	mv	s1,s2
    80001c3a:	bfd1                	j	80001c0e <allocproc+0x7c>

0000000080001c3c <userinit>:
{
    80001c3c:	1101                	addi	sp,sp,-32
    80001c3e:	ec06                	sd	ra,24(sp)
    80001c40:	e822                	sd	s0,16(sp)
    80001c42:	e426                	sd	s1,8(sp)
    80001c44:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c46:	f4dff0ef          	jal	80001b92 <allocproc>
    80001c4a:	84aa                	mv	s1,a0
  initproc = p;
    80001c4c:	00006797          	auipc	a5,0x6
    80001c50:	c0a7ba23          	sd	a0,-1004(a5) # 80007860 <initproc>
  p->cwd = namei("/");
    80001c54:	00005517          	auipc	a0,0x5
    80001c58:	53c50513          	addi	a0,a0,1340 # 80007190 <etext+0x190>
    80001c5c:	2b2020ef          	jal	80003f0e <namei>
    80001c60:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001c64:	478d                	li	a5,3
    80001c66:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c68:	8526                	mv	a0,s1
    80001c6a:	ff7fe0ef          	jal	80000c60 <release>
}
    80001c6e:	60e2                	ld	ra,24(sp)
    80001c70:	6442                	ld	s0,16(sp)
    80001c72:	64a2                	ld	s1,8(sp)
    80001c74:	6105                	addi	sp,sp,32
    80001c76:	8082                	ret

0000000080001c78 <growproc>:
{
    80001c78:	7179                	addi	sp,sp,-48
    80001c7a:	f406                	sd	ra,40(sp)
    80001c7c:	f022                	sd	s0,32(sp)
    80001c7e:	ec26                	sd	s1,24(sp)
    80001c80:	e84a                	sd	s2,16(sp)
    80001c82:	e052                	sd	s4,0(sp)
    80001c84:	1800                	addi	s0,sp,48
    80001c86:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c88:	c37ff0ef          	jal	800018be <myproc>
    80001c8c:	892a                	mv	s2,a0
  sz = p->sz;
    80001c8e:	05053a03          	ld	s4,80(a0)
  if(n > 0){
    80001c92:	02905c63          	blez	s1,80001cca <growproc+0x52>
    if(sz + n > TRAPFRAME(NPROC)) {
    80001c96:	01448633          	add	a2,s1,s4
    80001c9a:	020007b7          	lui	a5,0x2000
    80001c9e:	fdf78793          	addi	a5,a5,-33 # 1ffffdf <_entry-0x7e000021>
    80001ca2:	07b6                	slli	a5,a5,0xd
    80001ca4:	06c7e963          	bltu	a5,a2,80001d16 <growproc+0x9e>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001ca8:	4691                	li	a3,4
    80001caa:	85d2                	mv	a1,s4
    80001cac:	6d28                	ld	a0,88(a0)
    80001cae:	df4ff0ef          	jal	800012a2 <uvmalloc>
    80001cb2:	8a2a                	mv	s4,a0
    80001cb4:	c13d                	beqz	a0,80001d1a <growproc+0xa2>
    80001cb6:	e44e                	sd	s3,8(sp)
  for (np = proc; np < &proc[NPROC]; np++) {
    80001cb8:	0000e497          	auipc	s1,0xe
    80001cbc:	0e048493          	addi	s1,s1,224 # 8000fd98 <proc>
    80001cc0:	00014997          	auipc	s3,0x14
    80001cc4:	cd898993          	addi	s3,s3,-808 # 80015998 <tickslock>
    80001cc8:	a02d                	j	80001cf2 <growproc+0x7a>
    80001cca:	e44e                	sd	s3,8(sp)
  } else if(n < 0){
    80001ccc:	fe04d6e3          	bgez	s1,80001cb8 <growproc+0x40>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001cd0:	01448633          	add	a2,s1,s4
    80001cd4:	85d2                	mv	a1,s4
    80001cd6:	6d28                	ld	a0,88(a0)
    80001cd8:	d86ff0ef          	jal	8000125e <uvmdealloc>
    80001cdc:	8a2a                	mv	s4,a0
    80001cde:	bfe9                	j	80001cb8 <growproc+0x40>
        np->sz = sz;
    80001ce0:	0544b823          	sd	s4,80(s1)
    release(&np->lock);
    80001ce4:	8526                	mv	a0,s1
    80001ce6:	f7bfe0ef          	jal	80000c60 <release>
  for (np = proc; np < &proc[NPROC]; np++) {
    80001cea:	17048493          	addi	s1,s1,368
    80001cee:	01348b63          	beq	s1,s3,80001d04 <growproc+0x8c>
    acquire(&np->lock);
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	ed9fe0ef          	jal	80000bcc <acquire>
    if (np->tgid == p->tgid) {
    80001cf8:	58d8                	lw	a4,52(s1)
    80001cfa:	03492783          	lw	a5,52(s2)
    80001cfe:	fef713e3          	bne	a4,a5,80001ce4 <growproc+0x6c>
    80001d02:	bff9                	j	80001ce0 <growproc+0x68>
  return 0;
    80001d04:	4501                	li	a0,0
    80001d06:	69a2                	ld	s3,8(sp)
}
    80001d08:	70a2                	ld	ra,40(sp)
    80001d0a:	7402                	ld	s0,32(sp)
    80001d0c:	64e2                	ld	s1,24(sp)
    80001d0e:	6942                	ld	s2,16(sp)
    80001d10:	6a02                	ld	s4,0(sp)
    80001d12:	6145                	addi	sp,sp,48
    80001d14:	8082                	ret
      return -1;
    80001d16:	557d                	li	a0,-1
    80001d18:	bfc5                	j	80001d08 <growproc+0x90>
      return -1;
    80001d1a:	557d                	li	a0,-1
    80001d1c:	b7f5                	j	80001d08 <growproc+0x90>

0000000080001d1e <kfork>:
{
    80001d1e:	7139                	addi	sp,sp,-64
    80001d20:	fc06                	sd	ra,56(sp)
    80001d22:	f822                	sd	s0,48(sp)
    80001d24:	f04a                	sd	s2,32(sp)
    80001d26:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d28:	b97ff0ef          	jal	800018be <myproc>
  if (p->pid!=p->tgid) {
    80001d2c:	5918                	lw	a4,48(a0)
    80001d2e:	595c                	lw	a5,52(a0)
    80001d30:	10f71163          	bne	a4,a5,80001e32 <kfork+0x114>
    80001d34:	e852                	sd	s4,16(sp)
    80001d36:	e456                	sd	s5,8(sp)
    80001d38:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d3a:	e59ff0ef          	jal	80001b92 <allocproc>
    80001d3e:	8a2a                	mv	s4,a0
    80001d40:	0e050b63          	beqz	a0,80001e36 <kfork+0x118>
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d44:	050ab603          	ld	a2,80(s5)
    80001d48:	6d2c                	ld	a1,88(a0)
    80001d4a:	058ab503          	ld	a0,88(s5)
    80001d4e:	e94ff0ef          	jal	800013e2 <uvmcopy>
    80001d52:	04054a63          	bltz	a0,80001da6 <kfork+0x88>
    80001d56:	f426                	sd	s1,40(sp)
    80001d58:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001d5a:	050ab783          	ld	a5,80(s5)
    80001d5e:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    80001d62:	060ab683          	ld	a3,96(s5)
    80001d66:	87b6                	mv	a5,a3
    80001d68:	060a3703          	ld	a4,96(s4)
    80001d6c:	12068693          	addi	a3,a3,288
    80001d70:	0007b803          	ld	a6,0(a5)
    80001d74:	6788                	ld	a0,8(a5)
    80001d76:	6b8c                	ld	a1,16(a5)
    80001d78:	6f90                	ld	a2,24(a5)
    80001d7a:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001d7e:	e708                	sd	a0,8(a4)
    80001d80:	eb0c                	sd	a1,16(a4)
    80001d82:	ef10                	sd	a2,24(a4)
    80001d84:	02078793          	addi	a5,a5,32
    80001d88:	02070713          	addi	a4,a4,32
    80001d8c:	fed792e3          	bne	a5,a3,80001d70 <kfork+0x52>
  np->trapframe->a0 = 0;
    80001d90:	060a3783          	ld	a5,96(s4)
    80001d94:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001d98:	0d8a8493          	addi	s1,s5,216
    80001d9c:	0d8a0913          	addi	s2,s4,216
    80001da0:	158a8993          	addi	s3,s5,344
    80001da4:	a839                	j	80001dc2 <kfork+0xa4>
    freeproc(np);
    80001da6:	8552                	mv	a0,s4
    80001da8:	d25ff0ef          	jal	80001acc <freeproc>
    release(&np->lock);
    80001dac:	8552                	mv	a0,s4
    80001dae:	eb3fe0ef          	jal	80000c60 <release>
    return -1;
    80001db2:	597d                	li	s2,-1
    80001db4:	6a42                	ld	s4,16(sp)
    80001db6:	6aa2                	ld	s5,8(sp)
    80001db8:	a0bd                	j	80001e26 <kfork+0x108>
  for(i = 0; i < NOFILE; i++)
    80001dba:	04a1                	addi	s1,s1,8
    80001dbc:	0921                	addi	s2,s2,8
    80001dbe:	01348963          	beq	s1,s3,80001dd0 <kfork+0xb2>
    if(p->ofile[i])
    80001dc2:	6088                	ld	a0,0(s1)
    80001dc4:	d97d                	beqz	a0,80001dba <kfork+0x9c>
      np->ofile[i] = filedup(p->ofile[i]);
    80001dc6:	6ee020ef          	jal	800044b4 <filedup>
    80001dca:	00a93023          	sd	a0,0(s2)
    80001dce:	b7f5                	j	80001dba <kfork+0x9c>
  np->cwd = idup(p->cwd);
    80001dd0:	158ab503          	ld	a0,344(s5)
    80001dd4:	0db010ef          	jal	800036ae <idup>
    80001dd8:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ddc:	4641                	li	a2,16
    80001dde:	160a8593          	addi	a1,s5,352
    80001de2:	160a0513          	addi	a0,s4,352
    80001de6:	808ff0ef          	jal	80000dee <safestrcpy>
  pid = np->pid;
    80001dea:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001dee:	8552                	mv	a0,s4
    80001df0:	e71fe0ef          	jal	80000c60 <release>
  acquire(&wait_lock);
    80001df4:	0000e497          	auipc	s1,0xe
    80001df8:	b8c48493          	addi	s1,s1,-1140 # 8000f980 <wait_lock>
    80001dfc:	8526                	mv	a0,s1
    80001dfe:	dcffe0ef          	jal	80000bcc <acquire>
  np->parent = p;
    80001e02:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    80001e06:	8526                	mv	a0,s1
    80001e08:	e59fe0ef          	jal	80000c60 <release>
  acquire(&np->lock);
    80001e0c:	8552                	mv	a0,s4
    80001e0e:	dbffe0ef          	jal	80000bcc <acquire>
  np->state = RUNNABLE;
    80001e12:	478d                	li	a5,3
    80001e14:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e18:	8552                	mv	a0,s4
    80001e1a:	e47fe0ef          	jal	80000c60 <release>
  return pid;
    80001e1e:	74a2                	ld	s1,40(sp)
    80001e20:	69e2                	ld	s3,24(sp)
    80001e22:	6a42                	ld	s4,16(sp)
    80001e24:	6aa2                	ld	s5,8(sp)
}
    80001e26:	854a                	mv	a0,s2
    80001e28:	70e2                	ld	ra,56(sp)
    80001e2a:	7442                	ld	s0,48(sp)
    80001e2c:	7902                	ld	s2,32(sp)
    80001e2e:	6121                	addi	sp,sp,64
    80001e30:	8082                	ret
    return -1;
    80001e32:	597d                	li	s2,-1
    80001e34:	bfcd                	j	80001e26 <kfork+0x108>
    return -1;
    80001e36:	597d                	li	s2,-1
    80001e38:	6a42                	ld	s4,16(sp)
    80001e3a:	6aa2                	ld	s5,8(sp)
    80001e3c:	b7ed                	j	80001e26 <kfork+0x108>

0000000080001e3e <scheduler>:
{
    80001e3e:	715d                	addi	sp,sp,-80
    80001e40:	e486                	sd	ra,72(sp)
    80001e42:	e0a2                	sd	s0,64(sp)
    80001e44:	fc26                	sd	s1,56(sp)
    80001e46:	f84a                	sd	s2,48(sp)
    80001e48:	f44e                	sd	s3,40(sp)
    80001e4a:	f052                	sd	s4,32(sp)
    80001e4c:	ec56                	sd	s5,24(sp)
    80001e4e:	e85a                	sd	s6,16(sp)
    80001e50:	e45e                	sd	s7,8(sp)
    80001e52:	e062                	sd	s8,0(sp)
    80001e54:	0880                	addi	s0,sp,80
    80001e56:	8792                	mv	a5,tp
  int id = r_tp();
    80001e58:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001e5a:	00779b13          	slli	s6,a5,0x7
    80001e5e:	0000e717          	auipc	a4,0xe
    80001e62:	b0a70713          	addi	a4,a4,-1270 # 8000f968 <pid_lock>
    80001e66:	975a                	add	a4,a4,s6
    80001e68:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001e6c:	0000e717          	auipc	a4,0xe
    80001e70:	b3470713          	addi	a4,a4,-1228 # 8000f9a0 <cpus+0x8>
    80001e74:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001e76:	4c11                	li	s8,4
        c->proc = p;
    80001e78:	079e                	slli	a5,a5,0x7
    80001e7a:	0000ea17          	auipc	s4,0xe
    80001e7e:	aeea0a13          	addi	s4,s4,-1298 # 8000f968 <pid_lock>
    80001e82:	9a3e                	add	s4,s4,a5
        found = 1;
    80001e84:	4b85                	li	s7,1
    80001e86:	a83d                	j	80001ec4 <scheduler+0x86>
      release(&p->lock);
    80001e88:	8526                	mv	a0,s1
    80001e8a:	dd7fe0ef          	jal	80000c60 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e8e:	17048493          	addi	s1,s1,368
    80001e92:	03248563          	beq	s1,s2,80001ebc <scheduler+0x7e>
      acquire(&p->lock);
    80001e96:	8526                	mv	a0,s1
    80001e98:	d35fe0ef          	jal	80000bcc <acquire>
      if(p->state == RUNNABLE) {
    80001e9c:	4c9c                	lw	a5,24(s1)
    80001e9e:	ff3795e3          	bne	a5,s3,80001e88 <scheduler+0x4a>
        p->state = RUNNING;
    80001ea2:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001ea6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001eaa:	06848593          	addi	a1,s1,104
    80001eae:	855a                	mv	a0,s6
    80001eb0:	123000ef          	jal	800027d2 <swtch>
        c->proc = 0;
    80001eb4:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001eb8:	8ade                	mv	s5,s7
    80001eba:	b7f9                	j	80001e88 <scheduler+0x4a>
    if(found == 0) {
    80001ebc:	000a9463          	bnez	s5,80001ec4 <scheduler+0x86>
      asm volatile("wfi");
    80001ec0:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ec4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ec8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ecc:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ed0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ed4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ed6:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001eda:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001edc:	0000e497          	auipc	s1,0xe
    80001ee0:	ebc48493          	addi	s1,s1,-324 # 8000fd98 <proc>
      if(p->state == RUNNABLE) {
    80001ee4:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ee6:	00014917          	auipc	s2,0x14
    80001eea:	ab290913          	addi	s2,s2,-1358 # 80015998 <tickslock>
    80001eee:	b765                	j	80001e96 <scheduler+0x58>

0000000080001ef0 <sched>:
{
    80001ef0:	7179                	addi	sp,sp,-48
    80001ef2:	f406                	sd	ra,40(sp)
    80001ef4:	f022                	sd	s0,32(sp)
    80001ef6:	ec26                	sd	s1,24(sp)
    80001ef8:	e84a                	sd	s2,16(sp)
    80001efa:	e44e                	sd	s3,8(sp)
    80001efc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001efe:	9c1ff0ef          	jal	800018be <myproc>
    80001f02:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f04:	c5ffe0ef          	jal	80000b62 <holding>
    80001f08:	c92d                	beqz	a0,80001f7a <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f0a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f0c:	2781                	sext.w	a5,a5
    80001f0e:	079e                	slli	a5,a5,0x7
    80001f10:	0000e717          	auipc	a4,0xe
    80001f14:	a5870713          	addi	a4,a4,-1448 # 8000f968 <pid_lock>
    80001f18:	97ba                	add	a5,a5,a4
    80001f1a:	0a87a703          	lw	a4,168(a5)
    80001f1e:	4785                	li	a5,1
    80001f20:	06f71363          	bne	a4,a5,80001f86 <sched+0x96>
  if(p->state == RUNNING)
    80001f24:	4c98                	lw	a4,24(s1)
    80001f26:	4791                	li	a5,4
    80001f28:	06f70563          	beq	a4,a5,80001f92 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f2c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f30:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001f32:	e7b5                	bnez	a5,80001f9e <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f34:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001f36:	0000e917          	auipc	s2,0xe
    80001f3a:	a3290913          	addi	s2,s2,-1486 # 8000f968 <pid_lock>
    80001f3e:	2781                	sext.w	a5,a5
    80001f40:	079e                	slli	a5,a5,0x7
    80001f42:	97ca                	add	a5,a5,s2
    80001f44:	0ac7a983          	lw	s3,172(a5)
    80001f48:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001f4a:	2781                	sext.w	a5,a5
    80001f4c:	079e                	slli	a5,a5,0x7
    80001f4e:	0000e597          	auipc	a1,0xe
    80001f52:	a5258593          	addi	a1,a1,-1454 # 8000f9a0 <cpus+0x8>
    80001f56:	95be                	add	a1,a1,a5
    80001f58:	06848513          	addi	a0,s1,104
    80001f5c:	077000ef          	jal	800027d2 <swtch>
    80001f60:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001f62:	2781                	sext.w	a5,a5
    80001f64:	079e                	slli	a5,a5,0x7
    80001f66:	993e                	add	s2,s2,a5
    80001f68:	0b392623          	sw	s3,172(s2)
}
    80001f6c:	70a2                	ld	ra,40(sp)
    80001f6e:	7402                	ld	s0,32(sp)
    80001f70:	64e2                	ld	s1,24(sp)
    80001f72:	6942                	ld	s2,16(sp)
    80001f74:	69a2                	ld	s3,8(sp)
    80001f76:	6145                	addi	sp,sp,48
    80001f78:	8082                	ret
    panic("sched p->lock");
    80001f7a:	00005517          	auipc	a0,0x5
    80001f7e:	21e50513          	addi	a0,a0,542 # 80007198 <etext+0x198>
    80001f82:	85dfe0ef          	jal	800007de <panic>
    panic("sched locks");
    80001f86:	00005517          	auipc	a0,0x5
    80001f8a:	22250513          	addi	a0,a0,546 # 800071a8 <etext+0x1a8>
    80001f8e:	851fe0ef          	jal	800007de <panic>
    panic("sched RUNNING");
    80001f92:	00005517          	auipc	a0,0x5
    80001f96:	22650513          	addi	a0,a0,550 # 800071b8 <etext+0x1b8>
    80001f9a:	845fe0ef          	jal	800007de <panic>
    panic("sched interruptible");
    80001f9e:	00005517          	auipc	a0,0x5
    80001fa2:	22a50513          	addi	a0,a0,554 # 800071c8 <etext+0x1c8>
    80001fa6:	839fe0ef          	jal	800007de <panic>

0000000080001faa <yield>:
{
    80001faa:	1101                	addi	sp,sp,-32
    80001fac:	ec06                	sd	ra,24(sp)
    80001fae:	e822                	sd	s0,16(sp)
    80001fb0:	e426                	sd	s1,8(sp)
    80001fb2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001fb4:	90bff0ef          	jal	800018be <myproc>
    80001fb8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001fba:	c13fe0ef          	jal	80000bcc <acquire>
  p->state = RUNNABLE;
    80001fbe:	478d                	li	a5,3
    80001fc0:	cc9c                	sw	a5,24(s1)
  sched();
    80001fc2:	f2fff0ef          	jal	80001ef0 <sched>
  release(&p->lock);
    80001fc6:	8526                	mv	a0,s1
    80001fc8:	c99fe0ef          	jal	80000c60 <release>
}
    80001fcc:	60e2                	ld	ra,24(sp)
    80001fce:	6442                	ld	s0,16(sp)
    80001fd0:	64a2                	ld	s1,8(sp)
    80001fd2:	6105                	addi	sp,sp,32
    80001fd4:	8082                	ret

0000000080001fd6 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001fd6:	7179                	addi	sp,sp,-48
    80001fd8:	f406                	sd	ra,40(sp)
    80001fda:	f022                	sd	s0,32(sp)
    80001fdc:	ec26                	sd	s1,24(sp)
    80001fde:	e84a                	sd	s2,16(sp)
    80001fe0:	e44e                	sd	s3,8(sp)
    80001fe2:	1800                	addi	s0,sp,48
    80001fe4:	89aa                	mv	s3,a0
    80001fe6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fe8:	8d7ff0ef          	jal	800018be <myproc>
    80001fec:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001fee:	bdffe0ef          	jal	80000bcc <acquire>
  release(lk);
    80001ff2:	854a                	mv	a0,s2
    80001ff4:	c6dfe0ef          	jal	80000c60 <release>

  // Go to sleep.
  p->chan = chan;
    80001ff8:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001ffc:	4789                	li	a5,2
    80001ffe:	cc9c                	sw	a5,24(s1)

  sched();
    80002000:	ef1ff0ef          	jal	80001ef0 <sched>

  // Tidy up.
  p->chan = 0;
    80002004:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002008:	8526                	mv	a0,s1
    8000200a:	c57fe0ef          	jal	80000c60 <release>
  acquire(lk);
    8000200e:	854a                	mv	a0,s2
    80002010:	bbdfe0ef          	jal	80000bcc <acquire>
}
    80002014:	70a2                	ld	ra,40(sp)
    80002016:	7402                	ld	s0,32(sp)
    80002018:	64e2                	ld	s1,24(sp)
    8000201a:	6942                	ld	s2,16(sp)
    8000201c:	69a2                	ld	s3,8(sp)
    8000201e:	6145                	addi	sp,sp,48
    80002020:	8082                	ret

0000000080002022 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80002022:	7139                	addi	sp,sp,-64
    80002024:	fc06                	sd	ra,56(sp)
    80002026:	f822                	sd	s0,48(sp)
    80002028:	f426                	sd	s1,40(sp)
    8000202a:	f04a                	sd	s2,32(sp)
    8000202c:	ec4e                	sd	s3,24(sp)
    8000202e:	e852                	sd	s4,16(sp)
    80002030:	e456                	sd	s5,8(sp)
    80002032:	0080                	addi	s0,sp,64
    80002034:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002036:	0000e497          	auipc	s1,0xe
    8000203a:	d6248493          	addi	s1,s1,-670 # 8000fd98 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000203e:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002040:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002042:	00014917          	auipc	s2,0x14
    80002046:	95690913          	addi	s2,s2,-1706 # 80015998 <tickslock>
    8000204a:	a801                	j	8000205a <wakeup+0x38>
      }
      release(&p->lock);
    8000204c:	8526                	mv	a0,s1
    8000204e:	c13fe0ef          	jal	80000c60 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002052:	17048493          	addi	s1,s1,368
    80002056:	03248263          	beq	s1,s2,8000207a <wakeup+0x58>
    if(p != myproc()){
    8000205a:	865ff0ef          	jal	800018be <myproc>
    8000205e:	fea48ae3          	beq	s1,a0,80002052 <wakeup+0x30>
      acquire(&p->lock);
    80002062:	8526                	mv	a0,s1
    80002064:	b69fe0ef          	jal	80000bcc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002068:	4c9c                	lw	a5,24(s1)
    8000206a:	ff3791e3          	bne	a5,s3,8000204c <wakeup+0x2a>
    8000206e:	709c                	ld	a5,32(s1)
    80002070:	fd479ee3          	bne	a5,s4,8000204c <wakeup+0x2a>
        p->state = RUNNABLE;
    80002074:	0154ac23          	sw	s5,24(s1)
    80002078:	bfd1                	j	8000204c <wakeup+0x2a>
    }
  }
}
    8000207a:	70e2                	ld	ra,56(sp)
    8000207c:	7442                	ld	s0,48(sp)
    8000207e:	74a2                	ld	s1,40(sp)
    80002080:	7902                	ld	s2,32(sp)
    80002082:	69e2                	ld	s3,24(sp)
    80002084:	6a42                	ld	s4,16(sp)
    80002086:	6aa2                	ld	s5,8(sp)
    80002088:	6121                	addi	sp,sp,64
    8000208a:	8082                	ret

000000008000208c <reparent>:
{
    8000208c:	7179                	addi	sp,sp,-48
    8000208e:	f406                	sd	ra,40(sp)
    80002090:	f022                	sd	s0,32(sp)
    80002092:	ec26                	sd	s1,24(sp)
    80002094:	e84a                	sd	s2,16(sp)
    80002096:	e44e                	sd	s3,8(sp)
    80002098:	e052                	sd	s4,0(sp)
    8000209a:	1800                	addi	s0,sp,48
    8000209c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000209e:	0000e497          	auipc	s1,0xe
    800020a2:	cfa48493          	addi	s1,s1,-774 # 8000fd98 <proc>
      pp->parent = initproc;
    800020a6:	00005a17          	auipc	s4,0x5
    800020aa:	7baa0a13          	addi	s4,s4,1978 # 80007860 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800020ae:	00014997          	auipc	s3,0x14
    800020b2:	8ea98993          	addi	s3,s3,-1814 # 80015998 <tickslock>
    800020b6:	a029                	j	800020c0 <reparent+0x34>
    800020b8:	17048493          	addi	s1,s1,368
    800020bc:	01348b63          	beq	s1,s3,800020d2 <reparent+0x46>
    if(pp->parent == p){
    800020c0:	60bc                	ld	a5,64(s1)
    800020c2:	ff279be3          	bne	a5,s2,800020b8 <reparent+0x2c>
      pp->parent = initproc;
    800020c6:	000a3503          	ld	a0,0(s4)
    800020ca:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    800020cc:	f57ff0ef          	jal	80002022 <wakeup>
    800020d0:	b7e5                	j	800020b8 <reparent+0x2c>
}
    800020d2:	70a2                	ld	ra,40(sp)
    800020d4:	7402                	ld	s0,32(sp)
    800020d6:	64e2                	ld	s1,24(sp)
    800020d8:	6942                	ld	s2,16(sp)
    800020da:	69a2                	ld	s3,8(sp)
    800020dc:	6a02                	ld	s4,0(sp)
    800020de:	6145                	addi	sp,sp,48
    800020e0:	8082                	ret

00000000800020e2 <kexit>:
{
    800020e2:	715d                	addi	sp,sp,-80
    800020e4:	e486                	sd	ra,72(sp)
    800020e6:	e0a2                	sd	s0,64(sp)
    800020e8:	fc26                	sd	s1,56(sp)
    800020ea:	f84a                	sd	s2,48(sp)
    800020ec:	f44e                	sd	s3,40(sp)
    800020ee:	e85a                	sd	s6,16(sp)
    800020f0:	0880                	addi	s0,sp,80
    800020f2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800020f4:	fcaff0ef          	jal	800018be <myproc>
    800020f8:	89aa                	mv	s3,a0
  if(p == initproc)
    800020fa:	00005797          	auipc	a5,0x5
    800020fe:	7667b783          	ld	a5,1894(a5) # 80007860 <initproc>
    80002102:	0d850493          	addi	s1,a0,216
    80002106:	15850913          	addi	s2,a0,344
    8000210a:	00a78663          	beq	a5,a0,80002116 <kexit+0x34>
    8000210e:	f052                	sd	s4,32(sp)
    80002110:	ec56                	sd	s5,24(sp)
    80002112:	e45e                	sd	s7,8(sp)
    80002114:	a829                	j	8000212e <kexit+0x4c>
    80002116:	f052                	sd	s4,32(sp)
    80002118:	ec56                	sd	s5,24(sp)
    8000211a:	e45e                	sd	s7,8(sp)
    panic("init exiting");
    8000211c:	00005517          	auipc	a0,0x5
    80002120:	0c450513          	addi	a0,a0,196 # 800071e0 <etext+0x1e0>
    80002124:	ebafe0ef          	jal	800007de <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002128:	04a1                	addi	s1,s1,8
    8000212a:	01248963          	beq	s1,s2,8000213c <kexit+0x5a>
    if(p->ofile[fd]){
    8000212e:	6088                	ld	a0,0(s1)
    80002130:	dd65                	beqz	a0,80002128 <kexit+0x46>
      fileclose(f);
    80002132:	3c8020ef          	jal	800044fa <fileclose>
      p->ofile[fd] = 0;
    80002136:	0004b023          	sd	zero,0(s1)
    8000213a:	b7fd                	j	80002128 <kexit+0x46>
  begin_op();
    8000213c:	7ad010ef          	jal	800040e8 <begin_op>
  iput(p->cwd);
    80002140:	1589b503          	ld	a0,344(s3)
    80002144:	722010ef          	jal	80003866 <iput>
  end_op();
    80002148:	00a020ef          	jal	80004152 <end_op>
  p->cwd = 0;
    8000214c:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80002150:	0000e517          	auipc	a0,0xe
    80002154:	83050513          	addi	a0,a0,-2000 # 8000f980 <wait_lock>
    80002158:	a75fe0ef          	jal	80000bcc <acquire>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000215c:	0000e497          	auipc	s1,0xe
    80002160:	c3c48493          	addi	s1,s1,-964 # 8000fd98 <proc>
        pp->parent = initproc;
    80002164:	00005b97          	auipc	s7,0x5
    80002168:	6fcb8b93          	addi	s7,s7,1788 # 80007860 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000216c:	00014a17          	auipc	s4,0x14
    80002170:	82ca0a13          	addi	s4,s4,-2004 # 80015998 <tickslock>
    80002174:	a085                	j	800021d4 <kexit+0xf2>
        acquire(&pp->lock);
    80002176:	8526                	mv	a0,s1
    80002178:	a55fe0ef          	jal	80000bcc <acquire>
        for (int fd = 0; fd < NOFILE; fd++) {
    8000217c:	0d848913          	addi	s2,s1,216
    80002180:	15848a93          	addi	s5,s1,344
    80002184:	a021                	j	8000218c <kexit+0xaa>
    80002186:	0921                	addi	s2,s2,8
    80002188:	01590a63          	beq	s2,s5,8000219c <kexit+0xba>
            if (pp->ofile[fd]) {
    8000218c:	00093503          	ld	a0,0(s2)
    80002190:	d97d                	beqz	a0,80002186 <kexit+0xa4>
                fileclose(f);
    80002192:	368020ef          	jal	800044fa <fileclose>
                pp->ofile[fd] = 0;
    80002196:	00093023          	sd	zero,0(s2)
    8000219a:	b7f5                	j	80002186 <kexit+0xa4>
        if (pp->cwd) {
    8000219c:	1584b783          	ld	a5,344(s1)
    800021a0:	cb99                	beqz	a5,800021b6 <kexit+0xd4>
            begin_op();
    800021a2:	747010ef          	jal	800040e8 <begin_op>
            iput(pp->cwd);
    800021a6:	1584b503          	ld	a0,344(s1)
    800021aa:	6bc010ef          	jal	80003866 <iput>
            end_op();
    800021ae:	7a5010ef          	jal	80004152 <end_op>
            pp->cwd = 0;
    800021b2:	1404bc23          	sd	zero,344(s1)
        freeproc(pp);
    800021b6:	8526                	mv	a0,s1
    800021b8:	915ff0ef          	jal	80001acc <freeproc>
        release(&pp->lock);
    800021bc:	8526                	mv	a0,s1
    800021be:	aa3fe0ef          	jal	80000c60 <release>
        p->thread_count--;
    800021c2:	0389a783          	lw	a5,56(s3)
    800021c6:	37fd                	addiw	a5,a5,-1
    800021c8:	02f9ac23          	sw	a5,56(s3)
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021cc:	17048493          	addi	s1,s1,368
    800021d0:	03448063          	beq	s1,s4,800021f0 <kexit+0x10e>
    if (pp->parent==p) {
    800021d4:	60bc                	ld	a5,64(s1)
    800021d6:	ff379be3          	bne	a5,s3,800021cc <kexit+0xea>
      if(pp->tgid == p->pid){
    800021da:	58d8                	lw	a4,52(s1)
    800021dc:	0309a783          	lw	a5,48(s3)
    800021e0:	f8f70be3          	beq	a4,a5,80002176 <kexit+0x94>
        pp->parent = initproc;
    800021e4:	000bb503          	ld	a0,0(s7)
    800021e8:	e0a8                	sd	a0,64(s1)
        wakeup(initproc);
    800021ea:	e39ff0ef          	jal	80002022 <wakeup>
    800021ee:	bff9                	j	800021cc <kexit+0xea>
  wakeup(p->parent);
    800021f0:	0409b503          	ld	a0,64(s3)
    800021f4:	e2fff0ef          	jal	80002022 <wakeup>
  acquire(&p->lock);
    800021f8:	854e                	mv	a0,s3
    800021fa:	9d3fe0ef          	jal	80000bcc <acquire>
  p->xstate = status;
    800021fe:	0369a623          	sw	s6,44(s3)
  p->state = ZOMBIE;
    80002202:	4795                	li	a5,5
    80002204:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002208:	0000d517          	auipc	a0,0xd
    8000220c:	77850513          	addi	a0,a0,1912 # 8000f980 <wait_lock>
    80002210:	a51fe0ef          	jal	80000c60 <release>
  sched();
    80002214:	cddff0ef          	jal	80001ef0 <sched>
  panic("zombie exit");
    80002218:	00005517          	auipc	a0,0x5
    8000221c:	fd850513          	addi	a0,a0,-40 # 800071f0 <etext+0x1f0>
    80002220:	dbefe0ef          	jal	800007de <panic>

0000000080002224 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80002224:	7179                	addi	sp,sp,-48
    80002226:	f406                	sd	ra,40(sp)
    80002228:	f022                	sd	s0,32(sp)
    8000222a:	ec26                	sd	s1,24(sp)
    8000222c:	e84a                	sd	s2,16(sp)
    8000222e:	e44e                	sd	s3,8(sp)
    80002230:	1800                	addi	s0,sp,48
    80002232:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002234:	0000e497          	auipc	s1,0xe
    80002238:	b6448493          	addi	s1,s1,-1180 # 8000fd98 <proc>
    8000223c:	00013997          	auipc	s3,0x13
    80002240:	75c98993          	addi	s3,s3,1884 # 80015998 <tickslock>
    acquire(&p->lock);
    80002244:	8526                	mv	a0,s1
    80002246:	987fe0ef          	jal	80000bcc <acquire>
    if(p->pid == pid){
    8000224a:	589c                	lw	a5,48(s1)
    8000224c:	01278b63          	beq	a5,s2,80002262 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002250:	8526                	mv	a0,s1
    80002252:	a0ffe0ef          	jal	80000c60 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002256:	17048493          	addi	s1,s1,368
    8000225a:	ff3495e3          	bne	s1,s3,80002244 <kkill+0x20>
  }
  return -1;
    8000225e:	557d                	li	a0,-1
    80002260:	a819                	j	80002276 <kkill+0x52>
      p->killed = 1;
    80002262:	4785                	li	a5,1
    80002264:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002266:	4c98                	lw	a4,24(s1)
    80002268:	4789                	li	a5,2
    8000226a:	00f70d63          	beq	a4,a5,80002284 <kkill+0x60>
      release(&p->lock);
    8000226e:	8526                	mv	a0,s1
    80002270:	9f1fe0ef          	jal	80000c60 <release>
      return 0;
    80002274:	4501                	li	a0,0
}
    80002276:	70a2                	ld	ra,40(sp)
    80002278:	7402                	ld	s0,32(sp)
    8000227a:	64e2                	ld	s1,24(sp)
    8000227c:	6942                	ld	s2,16(sp)
    8000227e:	69a2                	ld	s3,8(sp)
    80002280:	6145                	addi	sp,sp,48
    80002282:	8082                	ret
        p->state = RUNNABLE;
    80002284:	478d                	li	a5,3
    80002286:	cc9c                	sw	a5,24(s1)
    80002288:	b7dd                	j	8000226e <kkill+0x4a>

000000008000228a <setkilled>:

void
setkilled(struct proc *p)
{
    8000228a:	1101                	addi	sp,sp,-32
    8000228c:	ec06                	sd	ra,24(sp)
    8000228e:	e822                	sd	s0,16(sp)
    80002290:	e426                	sd	s1,8(sp)
    80002292:	1000                	addi	s0,sp,32
    80002294:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002296:	937fe0ef          	jal	80000bcc <acquire>
  p->killed = 1;
    8000229a:	4785                	li	a5,1
    8000229c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000229e:	8526                	mv	a0,s1
    800022a0:	9c1fe0ef          	jal	80000c60 <release>
}
    800022a4:	60e2                	ld	ra,24(sp)
    800022a6:	6442                	ld	s0,16(sp)
    800022a8:	64a2                	ld	s1,8(sp)
    800022aa:	6105                	addi	sp,sp,32
    800022ac:	8082                	ret

00000000800022ae <killed>:

int
killed(struct proc *p)
{
    800022ae:	1101                	addi	sp,sp,-32
    800022b0:	ec06                	sd	ra,24(sp)
    800022b2:	e822                	sd	s0,16(sp)
    800022b4:	e426                	sd	s1,8(sp)
    800022b6:	e04a                	sd	s2,0(sp)
    800022b8:	1000                	addi	s0,sp,32
    800022ba:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800022bc:	911fe0ef          	jal	80000bcc <acquire>
  k = p->killed;
    800022c0:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800022c4:	8526                	mv	a0,s1
    800022c6:	99bfe0ef          	jal	80000c60 <release>
  return k;
}
    800022ca:	854a                	mv	a0,s2
    800022cc:	60e2                	ld	ra,24(sp)
    800022ce:	6442                	ld	s0,16(sp)
    800022d0:	64a2                	ld	s1,8(sp)
    800022d2:	6902                	ld	s2,0(sp)
    800022d4:	6105                	addi	sp,sp,32
    800022d6:	8082                	ret

00000000800022d8 <kwait>:
{
    800022d8:	715d                	addi	sp,sp,-80
    800022da:	e486                	sd	ra,72(sp)
    800022dc:	e0a2                	sd	s0,64(sp)
    800022de:	f44e                	sd	s3,40(sp)
    800022e0:	e85a                	sd	s6,16(sp)
    800022e2:	0880                	addi	s0,sp,80
    800022e4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800022e6:	dd8ff0ef          	jal	800018be <myproc>
  if (p->tgid != p->pid) return -1;
    800022ea:	5958                	lw	a4,52(a0)
    800022ec:	591c                	lw	a5,48(a0)
    800022ee:	10f71a63          	bne	a4,a5,80002402 <kwait+0x12a>
    800022f2:	fc26                	sd	s1,56(sp)
    800022f4:	f84a                	sd	s2,48(sp)
    800022f6:	f052                	sd	s4,32(sp)
    800022f8:	ec56                	sd	s5,24(sp)
    800022fa:	e45e                	sd	s7,8(sp)
    800022fc:	e062                	sd	s8,0(sp)
    800022fe:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002300:	0000d517          	auipc	a0,0xd
    80002304:	68050513          	addi	a0,a0,1664 # 8000f980 <wait_lock>
    80002308:	8c5fe0ef          	jal	80000bcc <acquire>
        if(pp->state == ZOMBIE){
    8000230c:	4a15                	li	s4,5
        havekids = 1;
    8000230e:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002310:	00013997          	auipc	s3,0x13
    80002314:	68898993          	addi	s3,s3,1672 # 80015998 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002318:	0000db97          	auipc	s7,0xd
    8000231c:	668b8b93          	addi	s7,s7,1640 # 8000f980 <wait_lock>
    80002320:	a86d                	j	800023da <kwait+0x102>
          release(&pp->lock);
    80002322:	8526                	mv	a0,s1
    80002324:	93dfe0ef          	jal	80000c60 <release>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002328:	17048493          	addi	s1,s1,368
    8000232c:	09348d63          	beq	s1,s3,800023c6 <kwait+0xee>
      if(pp->parent == p){
    80002330:	60bc                	ld	a5,64(s1)
    80002332:	ff279be3          	bne	a5,s2,80002328 <kwait+0x50>
        acquire(&pp->lock);
    80002336:	8526                	mv	a0,s1
    80002338:	895fe0ef          	jal	80000bcc <acquire>
        if (pp->tgid == p->pid) {
    8000233c:	58d8                	lw	a4,52(s1)
    8000233e:	03092783          	lw	a5,48(s2)
    80002342:	fef700e3          	beq	a4,a5,80002322 <kwait+0x4a>
        if(pp->state == ZOMBIE){
    80002346:	4c9c                	lw	a5,24(s1)
    80002348:	01478763          	beq	a5,s4,80002356 <kwait+0x7e>
        release(&pp->lock);
    8000234c:	8526                	mv	a0,s1
    8000234e:	913fe0ef          	jal	80000c60 <release>
        havekids = 1;
    80002352:	8c56                	mv	s8,s5
    80002354:	bfd1                	j	80002328 <kwait+0x50>
          pid = pp->pid;
    80002356:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000235a:	000b0c63          	beqz	s6,80002372 <kwait+0x9a>
    8000235e:	4691                	li	a3,4
    80002360:	02c48613          	addi	a2,s1,44
    80002364:	85da                	mv	a1,s6
    80002366:	05893503          	ld	a0,88(s2)
    8000236a:	a86ff0ef          	jal	800015f0 <copyout>
    8000236e:	02054b63          	bltz	a0,800023a4 <kwait+0xcc>
          freeproc(pp);
    80002372:	8526                	mv	a0,s1
    80002374:	f58ff0ef          	jal	80001acc <freeproc>
          release(&pp->lock);
    80002378:	8526                	mv	a0,s1
    8000237a:	8e7fe0ef          	jal	80000c60 <release>
          release(&wait_lock);
    8000237e:	0000d517          	auipc	a0,0xd
    80002382:	60250513          	addi	a0,a0,1538 # 8000f980 <wait_lock>
    80002386:	8dbfe0ef          	jal	80000c60 <release>
          return pid;
    8000238a:	74e2                	ld	s1,56(sp)
    8000238c:	7942                	ld	s2,48(sp)
    8000238e:	7a02                	ld	s4,32(sp)
    80002390:	6ae2                	ld	s5,24(sp)
    80002392:	6ba2                	ld	s7,8(sp)
    80002394:	6c02                	ld	s8,0(sp)
}
    80002396:	854e                	mv	a0,s3
    80002398:	60a6                	ld	ra,72(sp)
    8000239a:	6406                	ld	s0,64(sp)
    8000239c:	79a2                	ld	s3,40(sp)
    8000239e:	6b42                	ld	s6,16(sp)
    800023a0:	6161                	addi	sp,sp,80
    800023a2:	8082                	ret
            release(&pp->lock);
    800023a4:	8526                	mv	a0,s1
    800023a6:	8bbfe0ef          	jal	80000c60 <release>
            release(&wait_lock);
    800023aa:	0000d517          	auipc	a0,0xd
    800023ae:	5d650513          	addi	a0,a0,1494 # 8000f980 <wait_lock>
    800023b2:	8affe0ef          	jal	80000c60 <release>
            return -1;
    800023b6:	59fd                	li	s3,-1
    800023b8:	74e2                	ld	s1,56(sp)
    800023ba:	7942                	ld	s2,48(sp)
    800023bc:	7a02                	ld	s4,32(sp)
    800023be:	6ae2                	ld	s5,24(sp)
    800023c0:	6ba2                	ld	s7,8(sp)
    800023c2:	6c02                	ld	s8,0(sp)
    800023c4:	bfc9                	j	80002396 <kwait+0xbe>
    if(!havekids || killed(p)){
    800023c6:	020c0063          	beqz	s8,800023e6 <kwait+0x10e>
    800023ca:	854a                	mv	a0,s2
    800023cc:	ee3ff0ef          	jal	800022ae <killed>
    800023d0:	e919                	bnez	a0,800023e6 <kwait+0x10e>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800023d2:	85de                	mv	a1,s7
    800023d4:	854a                	mv	a0,s2
    800023d6:	c01ff0ef          	jal	80001fd6 <sleep>
    havekids = 0;
    800023da:	4c01                	li	s8,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800023dc:	0000e497          	auipc	s1,0xe
    800023e0:	9bc48493          	addi	s1,s1,-1604 # 8000fd98 <proc>
    800023e4:	b7b1                	j	80002330 <kwait+0x58>
      release(&wait_lock);
    800023e6:	0000d517          	auipc	a0,0xd
    800023ea:	59a50513          	addi	a0,a0,1434 # 8000f980 <wait_lock>
    800023ee:	873fe0ef          	jal	80000c60 <release>
      return -1;
    800023f2:	59fd                	li	s3,-1
    800023f4:	74e2                	ld	s1,56(sp)
    800023f6:	7942                	ld	s2,48(sp)
    800023f8:	7a02                	ld	s4,32(sp)
    800023fa:	6ae2                	ld	s5,24(sp)
    800023fc:	6ba2                	ld	s7,8(sp)
    800023fe:	6c02                	ld	s8,0(sp)
    80002400:	bf59                	j	80002396 <kwait+0xbe>
  if (p->tgid != p->pid) return -1;
    80002402:	59fd                	li	s3,-1
    80002404:	bf49                	j	80002396 <kwait+0xbe>

0000000080002406 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002406:	7179                	addi	sp,sp,-48
    80002408:	f406                	sd	ra,40(sp)
    8000240a:	f022                	sd	s0,32(sp)
    8000240c:	ec26                	sd	s1,24(sp)
    8000240e:	e84a                	sd	s2,16(sp)
    80002410:	e44e                	sd	s3,8(sp)
    80002412:	e052                	sd	s4,0(sp)
    80002414:	1800                	addi	s0,sp,48
    80002416:	84aa                	mv	s1,a0
    80002418:	892e                	mv	s2,a1
    8000241a:	89b2                	mv	s3,a2
    8000241c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000241e:	ca0ff0ef          	jal	800018be <myproc>
  if(user_dst){
    80002422:	cc99                	beqz	s1,80002440 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002424:	86d2                	mv	a3,s4
    80002426:	864e                	mv	a2,s3
    80002428:	85ca                	mv	a1,s2
    8000242a:	6d28                	ld	a0,88(a0)
    8000242c:	9c4ff0ef          	jal	800015f0 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002430:	70a2                	ld	ra,40(sp)
    80002432:	7402                	ld	s0,32(sp)
    80002434:	64e2                	ld	s1,24(sp)
    80002436:	6942                	ld	s2,16(sp)
    80002438:	69a2                	ld	s3,8(sp)
    8000243a:	6a02                	ld	s4,0(sp)
    8000243c:	6145                	addi	sp,sp,48
    8000243e:	8082                	ret
    memmove((char *)dst, src, len);
    80002440:	000a061b          	sext.w	a2,s4
    80002444:	85ce                	mv	a1,s3
    80002446:	854a                	mv	a0,s2
    80002448:	8b9fe0ef          	jal	80000d00 <memmove>
    return 0;
    8000244c:	8526                	mv	a0,s1
    8000244e:	b7cd                	j	80002430 <either_copyout+0x2a>

0000000080002450 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002450:	7179                	addi	sp,sp,-48
    80002452:	f406                	sd	ra,40(sp)
    80002454:	f022                	sd	s0,32(sp)
    80002456:	ec26                	sd	s1,24(sp)
    80002458:	e84a                	sd	s2,16(sp)
    8000245a:	e44e                	sd	s3,8(sp)
    8000245c:	e052                	sd	s4,0(sp)
    8000245e:	1800                	addi	s0,sp,48
    80002460:	892a                	mv	s2,a0
    80002462:	84ae                	mv	s1,a1
    80002464:	89b2                	mv	s3,a2
    80002466:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002468:	c56ff0ef          	jal	800018be <myproc>
  if(user_src){
    8000246c:	cc99                	beqz	s1,8000248a <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000246e:	86d2                	mv	a3,s4
    80002470:	864e                	mv	a2,s3
    80002472:	85ca                	mv	a1,s2
    80002474:	6d28                	ld	a0,88(a0)
    80002476:	a38ff0ef          	jal	800016ae <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
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
    memmove(dst, (char*)src, len);
    8000248a:	000a061b          	sext.w	a2,s4
    8000248e:	85ce                	mv	a1,s3
    80002490:	854a                	mv	a0,s2
    80002492:	86ffe0ef          	jal	80000d00 <memmove>
    return 0;
    80002496:	8526                	mv	a0,s1
    80002498:	b7cd                	j	8000247a <either_copyin+0x2a>

000000008000249a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000249a:	715d                	addi	sp,sp,-80
    8000249c:	e486                	sd	ra,72(sp)
    8000249e:	e0a2                	sd	s0,64(sp)
    800024a0:	fc26                	sd	s1,56(sp)
    800024a2:	f84a                	sd	s2,48(sp)
    800024a4:	f44e                	sd	s3,40(sp)
    800024a6:	f052                	sd	s4,32(sp)
    800024a8:	ec56                	sd	s5,24(sp)
    800024aa:	e85a                	sd	s6,16(sp)
    800024ac:	e45e                	sd	s7,8(sp)
    800024ae:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800024b0:	00005517          	auipc	a0,0x5
    800024b4:	bc850513          	addi	a0,a0,-1080 # 80007078 <etext+0x78>
    800024b8:	842fe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800024bc:	0000e497          	auipc	s1,0xe
    800024c0:	a3c48493          	addi	s1,s1,-1476 # 8000fef8 <proc+0x160>
    800024c4:	00013917          	auipc	s2,0x13
    800024c8:	63490913          	addi	s2,s2,1588 # 80015af8 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024cc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800024ce:	00005997          	auipc	s3,0x5
    800024d2:	d3298993          	addi	s3,s3,-718 # 80007200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800024d6:	00005a97          	auipc	s5,0x5
    800024da:	d32a8a93          	addi	s5,s5,-718 # 80007208 <etext+0x208>
    printf("\n");
    800024de:	00005a17          	auipc	s4,0x5
    800024e2:	b9aa0a13          	addi	s4,s4,-1126 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024e6:	00005b97          	auipc	s7,0x5
    800024ea:	242b8b93          	addi	s7,s7,578 # 80007728 <states.0>
    800024ee:	a829                	j	80002508 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800024f0:	ed06a583          	lw	a1,-304(a3)
    800024f4:	8556                	mv	a0,s5
    800024f6:	804fe0ef          	jal	800004fa <printf>
    printf("\n");
    800024fa:	8552                	mv	a0,s4
    800024fc:	ffffd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002500:	17048493          	addi	s1,s1,368
    80002504:	03248263          	beq	s1,s2,80002528 <procdump+0x8e>
    if(p->state == UNUSED)
    80002508:	86a6                	mv	a3,s1
    8000250a:	eb84a783          	lw	a5,-328(s1)
    8000250e:	dbed                	beqz	a5,80002500 <procdump+0x66>
      state = "???";
    80002510:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002512:	fcfb6fe3          	bltu	s6,a5,800024f0 <procdump+0x56>
    80002516:	02079713          	slli	a4,a5,0x20
    8000251a:	01d75793          	srli	a5,a4,0x1d
    8000251e:	97de                	add	a5,a5,s7
    80002520:	6390                	ld	a2,0(a5)
    80002522:	f679                	bnez	a2,800024f0 <procdump+0x56>
      state = "???";
    80002524:	864e                	mv	a2,s3
    80002526:	b7e9                	j	800024f0 <procdump+0x56>
  }
}
    80002528:	60a6                	ld	ra,72(sp)
    8000252a:	6406                	ld	s0,64(sp)
    8000252c:	74e2                	ld	s1,56(sp)
    8000252e:	7942                	ld	s2,48(sp)
    80002530:	79a2                	ld	s3,40(sp)
    80002532:	7a02                	ld	s4,32(sp)
    80002534:	6ae2                	ld	s5,24(sp)
    80002536:	6b42                	ld	s6,16(sp)
    80002538:	6ba2                	ld	s7,8(sp)
    8000253a:	6161                	addi	sp,sp,80
    8000253c:	8082                	ret

000000008000253e <clone>:

int
clone(uint64 fn, uint64 arg, uint64 stack)
{
    8000253e:	7139                	addi	sp,sp,-64
    80002540:	fc06                	sd	ra,56(sp)
    80002542:	f822                	sd	s0,48(sp)
    80002544:	ec4e                	sd	s3,24(sp)
    80002546:	e852                	sd	s4,16(sp)
    80002548:	e05a                	sd	s6,0(sp)
    8000254a:	0080                	addi	s0,sp,64
    8000254c:	8b2a                	mv	s6,a0
    8000254e:	8a2e                	mv	s4,a1
    80002550:	89b2                	mv	s3,a2
  struct proc *np;
  struct proc *p = myproc();
    80002552:	b6cff0ef          	jal	800018be <myproc>
  if (p->pid!=p->tgid) return -1;
    80002556:	5918                	lw	a4,48(a0)
    80002558:	595c                	lw	a5,52(a0)
    8000255a:	1af71863          	bne	a4,a5,8000270a <clone+0x1cc>
    8000255e:	f426                	sd	s1,40(sp)
    80002560:	f04a                	sd	s2,32(sp)
    80002562:	e456                	sd	s5,8(sp)
    80002564:	8aaa                	mv	s5,a0

  // Allocate process.
  for(np = proc; np < &proc[NPROC]; np++) {
    80002566:	0000e497          	auipc	s1,0xe
    8000256a:	83248493          	addi	s1,s1,-1998 # 8000fd98 <proc>
    8000256e:	00013917          	auipc	s2,0x13
    80002572:	42a90913          	addi	s2,s2,1066 # 80015998 <tickslock>
    acquire(&np->lock);
    80002576:	8526                	mv	a0,s1
    80002578:	e54fe0ef          	jal	80000bcc <acquire>
    if(np->state == UNUSED) {
    8000257c:	4c9c                	lw	a5,24(s1)
    8000257e:	cf89                	beqz	a5,80002598 <clone+0x5a>
      goto found;
    } else {
      release(&np->lock);
    80002580:	8526                	mv	a0,s1
    80002582:	edefe0ef          	jal	80000c60 <release>
  for(np = proc; np < &proc[NPROC]; np++) {
    80002586:	17048493          	addi	s1,s1,368
    8000258a:	ff2496e3          	bne	s1,s2,80002576 <clone+0x38>
    }
  }
  return -1;
    8000258e:	557d                	li	a0,-1
    80002590:	74a2                	ld	s1,40(sp)
    80002592:	7902                	ld	s2,32(sp)
    80002594:	6aa2                	ld	s5,8(sp)
    80002596:	a29d                	j	800026fc <clone+0x1be>

found:
  np->pid = allocpid();
    80002598:	beeff0ef          	jal	80001986 <allocpid>
    8000259c:	d888                	sw	a0,48(s1)
  np->state = USED;
    8000259e:	4785                	li	a5,1
    800025a0:	cc9c                	sw	a5,24(s1)
  np->chan = 0;
    800025a2:	0204b023          	sd	zero,32(s1)
  np->killed = 0;
    800025a6:	0204a423          	sw	zero,40(s1)
  np->tgid = p->pid;
    800025aa:	030aa703          	lw	a4,48(s5)
    800025ae:	d8d8                	sw	a4,52(s1)
  np->thread_count = 1;
    800025b0:	dc9c                	sw	a5,56(s1)

  // Allocate a trapframe page.
  if((np->trapframe = (struct trapframe *)kalloc()) == 0){
    800025b2:	d46fe0ef          	jal	80000af8 <kalloc>
    800025b6:	86aa                	mv	a3,a0
    800025b8:	f0a8                	sd	a0,96(s1)
    800025ba:	c569                	beqz	a0,80002684 <clone+0x146>
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->pagetable = p->pagetable;
    800025bc:	058ab503          	ld	a0,88(s5)
    800025c0:	eca8                	sd	a0,88(s1)
  if(mappages(np->pagetable, TRAPFRAME((int) (np - proc)), PGSIZE,
    800025c2:	0000d797          	auipc	a5,0xd
    800025c6:	7d678793          	addi	a5,a5,2006 # 8000fd98 <proc>
    800025ca:	40f487b3          	sub	a5,s1,a5
    800025ce:	8791                	srai	a5,a5,0x4
    800025d0:	e9bd3637          	lui	a2,0xe9bd3
    800025d4:	7a760613          	addi	a2,a2,1959 # ffffffffe9bd37a7 <end+0xffffffff69bb2a2f>
    800025d8:	d37a7737          	lui	a4,0xd37a7
    800025dc:	f4e70713          	addi	a4,a4,-178 # ffffffffd37a6f4e <end+0xffffffff537861d6>
    800025e0:	1702                	slli	a4,a4,0x20
    800025e2:	9732                	add	a4,a4,a2
    800025e4:	02e787b3          	mul	a5,a5,a4
    800025e8:	2785                	addiw	a5,a5,1
    800025ea:	00c7979b          	slliw	a5,a5,0xc
    800025ee:	040005b7          	lui	a1,0x4000
    800025f2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800025f4:	05b2                	slli	a1,a1,0xc
    800025f6:	4719                	li	a4,6
    800025f8:	6605                	lui	a2,0x1
    800025fa:	8d9d                	sub	a1,a1,a5
    800025fc:	a0dfe0ef          	jal	80001008 <mappages>
    80002600:	08054d63          	bltz	a0,8000269a <clone+0x15c>
    return -1;
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&np->context, 0, sizeof(np->context));
    80002604:	07000613          	li	a2,112
    80002608:	4581                	li	a1,0
    8000260a:	06848513          	addi	a0,s1,104
    8000260e:	e8efe0ef          	jal	80000c9c <memset>
  np->context.ra = (uint64)forkret;
    80002612:	fffff797          	auipc	a5,0xfffff
    80002616:	2dc78793          	addi	a5,a5,732 # 800018ee <forkret>
    8000261a:	f4bc                	sd	a5,104(s1)
  np->context.sp = np->kstack + PGSIZE;  
    8000261c:	64bc                	ld	a5,72(s1)
    8000261e:	6705                	lui	a4,0x1
    80002620:	97ba                	add	a5,a5,a4
    80002622:	f8bc                	sd	a5,112(s1)
  
  p->thread_count++;
    80002624:	038aa783          	lw	a5,56(s5)
    80002628:	2785                	addiw	a5,a5,1
    8000262a:	02faac23          	sw	a5,56(s5)
  np->sz = p->sz;
    8000262e:	050ab783          	ld	a5,80(s5)
    80002632:	e8bc                	sd	a5,80(s1)
  np->parent = p;
    80002634:	0554b023          	sd	s5,64(s1)

  ////////////// copy saved user registers.
  *(np->trapframe) = *(p->trapframe);
    80002638:	060ab683          	ld	a3,96(s5)
    8000263c:	87b6                	mv	a5,a3
    8000263e:	70b8                	ld	a4,96(s1)
    80002640:	12068693          	addi	a3,a3,288
    80002644:	0007b803          	ld	a6,0(a5)
    80002648:	6788                	ld	a0,8(a5)
    8000264a:	6b8c                	ld	a1,16(a5)
    8000264c:	6f90                	ld	a2,24(a5)
    8000264e:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80002652:	e708                	sd	a0,8(a4)
    80002654:	eb0c                	sd	a1,16(a4)
    80002656:	ef10                	sd	a2,24(a4)
    80002658:	02078793          	addi	a5,a5,32
    8000265c:	02070713          	addi	a4,a4,32
    80002660:	fed792e3          	bne	a5,a3,80002644 <clone+0x106>
  np->trapframe->epc = fn;     // start executing fn in user mode
    80002664:	70bc                	ld	a5,96(s1)
    80002666:	0167bc23          	sd	s6,24(a5)
  np->trapframe->a0  = arg;    // fn(arg)
    8000266a:	70bc                	ld	a5,96(s1)
    8000266c:	0747b823          	sd	s4,112(a5)
  np->trapframe->sp  = stack;  // user stack for this thread
    80002670:	70bc                	ld	a5,96(s1)
    80002672:	0337b823          	sd	s3,48(a5)

  // increment reference counts on open file descriptors.
  for(int i = 0; i < NOFILE; i++)
    80002676:	0d8a8913          	addi	s2,s5,216
    8000267a:	0d848993          	addi	s3,s1,216
    8000267e:	158a8a13          	addi	s4,s5,344
    80002682:	a83d                	j	800026c0 <clone+0x182>
    freeproc(np);
    80002684:	8526                	mv	a0,s1
    80002686:	c46ff0ef          	jal	80001acc <freeproc>
    release(&np->lock);
    8000268a:	8526                	mv	a0,s1
    8000268c:	dd4fe0ef          	jal	80000c60 <release>
    return -1;
    80002690:	557d                	li	a0,-1
    80002692:	74a2                	ld	s1,40(sp)
    80002694:	7902                	ld	s2,32(sp)
    80002696:	6aa2                	ld	s5,8(sp)
    80002698:	a095                	j	800026fc <clone+0x1be>
    kfree((void*)np->trapframe);
    8000269a:	70a8                	ld	a0,96(s1)
    8000269c:	b7afe0ef          	jal	80000a16 <kfree>
    np->trapframe = 0;
    800026a0:	0604b023          	sd	zero,96(s1)
    np->state = UNUSED;
    800026a4:	0004ac23          	sw	zero,24(s1)
    release(&np->lock);
    800026a8:	8526                	mv	a0,s1
    800026aa:	db6fe0ef          	jal	80000c60 <release>
    return -1;
    800026ae:	557d                	li	a0,-1
    800026b0:	74a2                	ld	s1,40(sp)
    800026b2:	7902                	ld	s2,32(sp)
    800026b4:	6aa2                	ld	s5,8(sp)
    800026b6:	a099                	j	800026fc <clone+0x1be>
  for(int i = 0; i < NOFILE; i++)
    800026b8:	0921                	addi	s2,s2,8
    800026ba:	09a1                	addi	s3,s3,8
    800026bc:	01490a63          	beq	s2,s4,800026d0 <clone+0x192>
    if(p->ofile[i])
    800026c0:	00093503          	ld	a0,0(s2)
    800026c4:	d975                	beqz	a0,800026b8 <clone+0x17a>
      np->ofile[i] = filedup(p->ofile[i]);
    800026c6:	5ef010ef          	jal	800044b4 <filedup>
    800026ca:	00a9b023          	sd	a0,0(s3)
    800026ce:	b7ed                	j	800026b8 <clone+0x17a>
  np->cwd = idup(p->cwd);
    800026d0:	158ab503          	ld	a0,344(s5)
    800026d4:	7db000ef          	jal	800036ae <idup>
    800026d8:	14a4bc23          	sd	a0,344(s1)

  safestrcpy(np->name, p->name, sizeof(p->name));  
    800026dc:	4641                	li	a2,16
    800026de:	160a8593          	addi	a1,s5,352
    800026e2:	16048513          	addi	a0,s1,352
    800026e6:	f08fe0ef          	jal	80000dee <safestrcpy>
  np->state = RUNNABLE;
    800026ea:	478d                	li	a5,3
    800026ec:	cc9c                	sw	a5,24(s1)
  release(&np->lock);
    800026ee:	8526                	mv	a0,s1
    800026f0:	d70fe0ef          	jal	80000c60 <release>
  return np->pid;
    800026f4:	5888                	lw	a0,48(s1)
    800026f6:	74a2                	ld	s1,40(sp)
    800026f8:	7902                	ld	s2,32(sp)
    800026fa:	6aa2                	ld	s5,8(sp)
}
    800026fc:	70e2                	ld	ra,56(sp)
    800026fe:	7442                	ld	s0,48(sp)
    80002700:	69e2                	ld	s3,24(sp)
    80002702:	6a42                	ld	s4,16(sp)
    80002704:	6b02                	ld	s6,0(sp)
    80002706:	6121                	addi	sp,sp,64
    80002708:	8082                	ret
  if (p->pid!=p->tgid) return -1;
    8000270a:	557d                	li	a0,-1
    8000270c:	bfc5                	j	800026fc <clone+0x1be>

000000008000270e <join>:

int
join(void)
{
    8000270e:	7139                	addi	sp,sp,-64
    80002710:	fc06                	sd	ra,56(sp)
    80002712:	f822                	sd	s0,48(sp)
    80002714:	f426                	sd	s1,40(sp)
    80002716:	f04a                	sd	s2,32(sp)
    80002718:	ec4e                	sd	s3,24(sp)
    8000271a:	e852                	sd	s4,16(sp)
    8000271c:	e456                	sd	s5,8(sp)
    8000271e:	e05a                	sd	s6,0(sp)
    80002720:	0080                	addi	s0,sp,64
  struct proc *pp;
  int havethreads, tgid;
  struct proc *p = myproc();
    80002722:	99cff0ef          	jal	800018be <myproc>
    80002726:	892a                	mv	s2,a0

  acquire(&wait_lock);
    80002728:	0000d517          	auipc	a0,0xd
    8000272c:	25850513          	addi	a0,a0,600 # 8000f980 <wait_lock>
    80002730:	c9cfe0ef          	jal	80000bcc <acquire>
        acquire(&pp->lock);

        // WPTHREAD

        havethreads = 1;
        if(pp->state == ZOMBIE){
    80002734:	4a15                	li	s4,5
        havethreads = 1;
    80002736:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002738:	00013997          	auipc	s3,0x13
    8000273c:	26098993          	addi	s3,s3,608 # 80015998 <tickslock>
      release(&wait_lock);
      return -1;
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002740:	0000db17          	auipc	s6,0xd
    80002744:	240b0b13          	addi	s6,s6,576 # 8000f980 <wait_lock>
    80002748:	a0bd                	j	800027b6 <join+0xa8>
          tgid = pp->tgid;
    8000274a:	0344a903          	lw	s2,52(s1)
          freeproc(pp);
    8000274e:	8526                	mv	a0,s1
    80002750:	b7cff0ef          	jal	80001acc <freeproc>
          release(&pp->lock);
    80002754:	8526                	mv	a0,s1
    80002756:	d0afe0ef          	jal	80000c60 <release>
          release(&wait_lock);
    8000275a:	0000d517          	auipc	a0,0xd
    8000275e:	22650513          	addi	a0,a0,550 # 8000f980 <wait_lock>
    80002762:	cfefe0ef          	jal	80000c60 <release>
  }
}
    80002766:	854a                	mv	a0,s2
    80002768:	70e2                	ld	ra,56(sp)
    8000276a:	7442                	ld	s0,48(sp)
    8000276c:	74a2                	ld	s1,40(sp)
    8000276e:	7902                	ld	s2,32(sp)
    80002770:	69e2                	ld	s3,24(sp)
    80002772:	6a42                	ld	s4,16(sp)
    80002774:	6aa2                	ld	s5,8(sp)
    80002776:	6b02                	ld	s6,0(sp)
    80002778:	6121                	addi	sp,sp,64
    8000277a:	8082                	ret
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000277c:	17048493          	addi	s1,s1,368
    80002780:	03348263          	beq	s1,s3,800027a4 <join+0x96>
      if(pp->tgid == p->pid){
    80002784:	58d8                	lw	a4,52(s1)
    80002786:	03092783          	lw	a5,48(s2)
    8000278a:	fef719e3          	bne	a4,a5,8000277c <join+0x6e>
        acquire(&pp->lock);
    8000278e:	8526                	mv	a0,s1
    80002790:	c3cfe0ef          	jal	80000bcc <acquire>
        if(pp->state == ZOMBIE){
    80002794:	4c9c                	lw	a5,24(s1)
    80002796:	fb478ae3          	beq	a5,s4,8000274a <join+0x3c>
        release(&pp->lock);
    8000279a:	8526                	mv	a0,s1
    8000279c:	cc4fe0ef          	jal	80000c60 <release>
        havethreads = 1;
    800027a0:	86d6                	mv	a3,s5
    800027a2:	bfe9                	j	8000277c <join+0x6e>
    if(!havethreads || killed(p)){
    800027a4:	ce99                	beqz	a3,800027c2 <join+0xb4>
    800027a6:	854a                	mv	a0,s2
    800027a8:	b07ff0ef          	jal	800022ae <killed>
    800027ac:	e919                	bnez	a0,800027c2 <join+0xb4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800027ae:	85da                	mv	a1,s6
    800027b0:	854a                	mv	a0,s2
    800027b2:	825ff0ef          	jal	80001fd6 <sleep>
    havethreads = 0;
    800027b6:	4681                	li	a3,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800027b8:	0000d497          	auipc	s1,0xd
    800027bc:	5e048493          	addi	s1,s1,1504 # 8000fd98 <proc>
    800027c0:	b7d1                	j	80002784 <join+0x76>
      release(&wait_lock);
    800027c2:	0000d517          	auipc	a0,0xd
    800027c6:	1be50513          	addi	a0,a0,446 # 8000f980 <wait_lock>
    800027ca:	c96fe0ef          	jal	80000c60 <release>
      return -1;
    800027ce:	597d                	li	s2,-1
    800027d0:	bf59                	j	80002766 <join+0x58>

00000000800027d2 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800027d2:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800027d6:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800027da:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800027dc:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800027de:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800027e2:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800027e6:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800027ea:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800027ee:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800027f2:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800027f6:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800027fa:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800027fe:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002802:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002806:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    8000280a:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8000280e:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002810:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002812:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002816:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8000281a:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8000281e:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002822:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002826:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8000282a:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8000282e:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002832:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002836:	0685bd83          	ld	s11,104(a1)
        
        ret
    8000283a:	8082                	ret

000000008000283c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000283c:	1141                	addi	sp,sp,-16
    8000283e:	e406                	sd	ra,8(sp)
    80002840:	e022                	sd	s0,0(sp)
    80002842:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002844:	00005597          	auipc	a1,0x5
    80002848:	a0458593          	addi	a1,a1,-1532 # 80007248 <etext+0x248>
    8000284c:	00013517          	auipc	a0,0x13
    80002850:	14c50513          	addi	a0,a0,332 # 80015998 <tickslock>
    80002854:	af4fe0ef          	jal	80000b48 <initlock>
}
    80002858:	60a2                	ld	ra,8(sp)
    8000285a:	6402                	ld	s0,0(sp)
    8000285c:	0141                	addi	sp,sp,16
    8000285e:	8082                	ret

0000000080002860 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002860:	1141                	addi	sp,sp,-16
    80002862:	e406                	sd	ra,8(sp)
    80002864:	e022                	sd	s0,0(sp)
    80002866:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002868:	00003797          	auipc	a5,0x3
    8000286c:	0e878793          	addi	a5,a5,232 # 80005950 <kernelvec>
    80002870:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002874:	60a2                	ld	ra,8(sp)
    80002876:	6402                	ld	s0,0(sp)
    80002878:	0141                	addi	sp,sp,16
    8000287a:	8082                	ret

000000008000287c <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    8000287c:	1141                	addi	sp,sp,-16
    8000287e:	e406                	sd	ra,8(sp)
    80002880:	e022                	sd	s0,0(sp)
    80002882:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002884:	83aff0ef          	jal	800018be <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002888:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000288c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000288e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002892:	04000737          	lui	a4,0x4000
    80002896:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002898:	0732                	slli	a4,a4,0xc
    8000289a:	00003797          	auipc	a5,0x3
    8000289e:	76678793          	addi	a5,a5,1894 # 80006000 <_trampoline>
    800028a2:	00003697          	auipc	a3,0x3
    800028a6:	75e68693          	addi	a3,a3,1886 # 80006000 <_trampoline>
    800028aa:	8f95                	sub	a5,a5,a3
    800028ac:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028ae:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800028b2:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800028b4:	180026f3          	csrr	a3,satp
    800028b8:	e394                	sd	a3,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800028ba:	7134                	ld	a3,96(a0)
    800028bc:	653c                	ld	a5,72(a0)
    800028be:	6605                	lui	a2,0x1
    800028c0:	97b2                	add	a5,a5,a2
    800028c2:	e69c                	sd	a5,8(a3)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800028c4:	713c                	ld	a5,96(a0)
    800028c6:	00000697          	auipc	a3,0x0
    800028ca:	12a68693          	addi	a3,a3,298 # 800029f0 <usertrap>
    800028ce:	eb94                	sd	a3,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800028d0:	713c                	ld	a5,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800028d2:	8692                	mv	a3,tp
    800028d4:	f394                	sd	a3,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028d6:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800028da:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800028de:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028e2:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800028e6:	713c                	ld	a5,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028e8:	6f9c                	ld	a5,24(a5)
    800028ea:	14179073          	csrw	sepc,a5
  w_sscratch(TRAPFRAME((int) (p-proc)));
    800028ee:	0000d797          	auipc	a5,0xd
    800028f2:	4aa78793          	addi	a5,a5,1194 # 8000fd98 <proc>
    800028f6:	40f507b3          	sub	a5,a0,a5
    800028fa:	8791                	srai	a5,a5,0x4
    800028fc:	e9bd3637          	lui	a2,0xe9bd3
    80002900:	7a760613          	addi	a2,a2,1959 # ffffffffe9bd37a7 <end+0xffffffff69bb2a2f>
    80002904:	d37a76b7          	lui	a3,0xd37a7
    80002908:	f4e68693          	addi	a3,a3,-178 # ffffffffd37a6f4e <end+0xffffffff537861d6>
    8000290c:	1682                	slli	a3,a3,0x20
    8000290e:	96b2                	add	a3,a3,a2
    80002910:	02d787b3          	mul	a5,a5,a3
    80002914:	2785                	addiw	a5,a5,1
    80002916:	00c7979b          	slliw	a5,a5,0xc
    8000291a:	8f1d                	sub	a4,a4,a5
  asm volatile("csrw sscratch, %0" : : "r" (x));
    8000291c:	14071073          	csrw	sscratch,a4
}
    80002920:	60a2                	ld	ra,8(sp)
    80002922:	6402                	ld	s0,0(sp)
    80002924:	0141                	addi	sp,sp,16
    80002926:	8082                	ret

0000000080002928 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002928:	1101                	addi	sp,sp,-32
    8000292a:	ec06                	sd	ra,24(sp)
    8000292c:	e822                	sd	s0,16(sp)
    8000292e:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002930:	f5bfe0ef          	jal	8000188a <cpuid>
    80002934:	cd11                	beqz	a0,80002950 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002936:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000293a:	000f4737          	lui	a4,0xf4
    8000293e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002942:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002944:	14d79073          	csrw	stimecmp,a5
}
    80002948:	60e2                	ld	ra,24(sp)
    8000294a:	6442                	ld	s0,16(sp)
    8000294c:	6105                	addi	sp,sp,32
    8000294e:	8082                	ret
    80002950:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80002952:	00013497          	auipc	s1,0x13
    80002956:	04648493          	addi	s1,s1,70 # 80015998 <tickslock>
    8000295a:	8526                	mv	a0,s1
    8000295c:	a70fe0ef          	jal	80000bcc <acquire>
    ticks++;
    80002960:	00005517          	auipc	a0,0x5
    80002964:	f0850513          	addi	a0,a0,-248 # 80007868 <ticks>
    80002968:	411c                	lw	a5,0(a0)
    8000296a:	2785                	addiw	a5,a5,1
    8000296c:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000296e:	eb4ff0ef          	jal	80002022 <wakeup>
    release(&tickslock);
    80002972:	8526                	mv	a0,s1
    80002974:	aecfe0ef          	jal	80000c60 <release>
    80002978:	64a2                	ld	s1,8(sp)
    8000297a:	bf75                	j	80002936 <clockintr+0xe>

000000008000297c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000297c:	1101                	addi	sp,sp,-32
    8000297e:	ec06                	sd	ra,24(sp)
    80002980:	e822                	sd	s0,16(sp)
    80002982:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002984:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002988:	57fd                	li	a5,-1
    8000298a:	17fe                	slli	a5,a5,0x3f
    8000298c:	07a5                	addi	a5,a5,9
    8000298e:	00f70c63          	beq	a4,a5,800029a6 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002992:	57fd                	li	a5,-1
    80002994:	17fe                	slli	a5,a5,0x3f
    80002996:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002998:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000299a:	04f70763          	beq	a4,a5,800029e8 <devintr+0x6c>
  }
}
    8000299e:	60e2                	ld	ra,24(sp)
    800029a0:	6442                	ld	s0,16(sp)
    800029a2:	6105                	addi	sp,sp,32
    800029a4:	8082                	ret
    800029a6:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800029a8:	054030ef          	jal	800059fc <plic_claim>
    800029ac:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800029ae:	47a9                	li	a5,10
    800029b0:	00f50963          	beq	a0,a5,800029c2 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800029b4:	4785                	li	a5,1
    800029b6:	00f50963          	beq	a0,a5,800029c8 <devintr+0x4c>
    return 1;
    800029ba:	4505                	li	a0,1
    } else if(irq){
    800029bc:	e889                	bnez	s1,800029ce <devintr+0x52>
    800029be:	64a2                	ld	s1,8(sp)
    800029c0:	bff9                	j	8000299e <devintr+0x22>
      uartintr();
    800029c2:	fedfd0ef          	jal	800009ae <uartintr>
    if(irq)
    800029c6:	a819                	j	800029dc <devintr+0x60>
      virtio_disk_intr();
    800029c8:	4c4030ef          	jal	80005e8c <virtio_disk_intr>
    if(irq)
    800029cc:	a801                	j	800029dc <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800029ce:	85a6                	mv	a1,s1
    800029d0:	00005517          	auipc	a0,0x5
    800029d4:	88050513          	addi	a0,a0,-1920 # 80007250 <etext+0x250>
    800029d8:	b23fd0ef          	jal	800004fa <printf>
      plic_complete(irq);
    800029dc:	8526                	mv	a0,s1
    800029de:	03e030ef          	jal	80005a1c <plic_complete>
    return 1;
    800029e2:	4505                	li	a0,1
    800029e4:	64a2                	ld	s1,8(sp)
    800029e6:	bf65                	j	8000299e <devintr+0x22>
    clockintr();
    800029e8:	f41ff0ef          	jal	80002928 <clockintr>
    return 2;
    800029ec:	4509                	li	a0,2
    800029ee:	bf45                	j	8000299e <devintr+0x22>

00000000800029f0 <usertrap>:
{
    800029f0:	1101                	addi	sp,sp,-32
    800029f2:	ec06                	sd	ra,24(sp)
    800029f4:	e822                	sd	s0,16(sp)
    800029f6:	e426                	sd	s1,8(sp)
    800029f8:	e04a                	sd	s2,0(sp)
    800029fa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029fc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002a00:	1007f793          	andi	a5,a5,256
    80002a04:	eba5                	bnez	a5,80002a74 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a06:	00003797          	auipc	a5,0x3
    80002a0a:	f4a78793          	addi	a5,a5,-182 # 80005950 <kernelvec>
    80002a0e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002a12:	eadfe0ef          	jal	800018be <myproc>
    80002a16:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002a18:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a1a:	14102773          	csrr	a4,sepc
    80002a1e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a20:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002a24:	47a1                	li	a5,8
    80002a26:	04f70d63          	beq	a4,a5,80002a80 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80002a2a:	f53ff0ef          	jal	8000297c <devintr>
    80002a2e:	892a                	mv	s2,a0
    80002a30:	e945                	bnez	a0,80002ae0 <usertrap+0xf0>
    80002a32:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002a36:	47bd                	li	a5,15
    80002a38:	08f70863          	beq	a4,a5,80002ac8 <usertrap+0xd8>
    80002a3c:	14202773          	csrr	a4,scause
    80002a40:	47b5                	li	a5,13
    80002a42:	08f70363          	beq	a4,a5,80002ac8 <usertrap+0xd8>
    80002a46:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002a4a:	5890                	lw	a2,48(s1)
    80002a4c:	00005517          	auipc	a0,0x5
    80002a50:	84450513          	addi	a0,a0,-1980 # 80007290 <etext+0x290>
    80002a54:	aa7fd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a58:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a5c:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002a60:	00005517          	auipc	a0,0x5
    80002a64:	86050513          	addi	a0,a0,-1952 # 800072c0 <etext+0x2c0>
    80002a68:	a93fd0ef          	jal	800004fa <printf>
    setkilled(p);
    80002a6c:	8526                	mv	a0,s1
    80002a6e:	81dff0ef          	jal	8000228a <setkilled>
    80002a72:	a035                	j	80002a9e <usertrap+0xae>
    panic("usertrap: not from user mode");
    80002a74:	00004517          	auipc	a0,0x4
    80002a78:	7fc50513          	addi	a0,a0,2044 # 80007270 <etext+0x270>
    80002a7c:	d63fd0ef          	jal	800007de <panic>
    if(killed(p))
    80002a80:	82fff0ef          	jal	800022ae <killed>
    80002a84:	ed15                	bnez	a0,80002ac0 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80002a86:	70b8                	ld	a4,96(s1)
    80002a88:	6f1c                	ld	a5,24(a4)
    80002a8a:	0791                	addi	a5,a5,4
    80002a8c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a8e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002a92:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a96:	10079073          	csrw	sstatus,a5
    syscall();
    80002a9a:	23e000ef          	jal	80002cd8 <syscall>
  if(killed(p))
    80002a9e:	8526                	mv	a0,s1
    80002aa0:	80fff0ef          	jal	800022ae <killed>
    80002aa4:	e139                	bnez	a0,80002aea <usertrap+0xfa>
  prepare_return();
    80002aa6:	dd7ff0ef          	jal	8000287c <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002aaa:	6ca8                	ld	a0,88(s1)
    80002aac:	8131                	srli	a0,a0,0xc
    80002aae:	57fd                	li	a5,-1
    80002ab0:	17fe                	slli	a5,a5,0x3f
    80002ab2:	8d5d                	or	a0,a0,a5
}
    80002ab4:	60e2                	ld	ra,24(sp)
    80002ab6:	6442                	ld	s0,16(sp)
    80002ab8:	64a2                	ld	s1,8(sp)
    80002aba:	6902                	ld	s2,0(sp)
    80002abc:	6105                	addi	sp,sp,32
    80002abe:	8082                	ret
      kexit(-1);
    80002ac0:	557d                	li	a0,-1
    80002ac2:	e20ff0ef          	jal	800020e2 <kexit>
    80002ac6:	b7c1                	j	80002a86 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ac8:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002acc:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80002ad0:	164d                	addi	a2,a2,-13
    80002ad2:	00163613          	seqz	a2,a2
    80002ad6:	6ca8                	ld	a0,88(s1)
    80002ad8:	a97fe0ef          	jal	8000156e <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002adc:	f169                	bnez	a0,80002a9e <usertrap+0xae>
    80002ade:	b7a5                	j	80002a46 <usertrap+0x56>
  if(killed(p))
    80002ae0:	8526                	mv	a0,s1
    80002ae2:	fccff0ef          	jal	800022ae <killed>
    80002ae6:	c511                	beqz	a0,80002af2 <usertrap+0x102>
    80002ae8:	a011                	j	80002aec <usertrap+0xfc>
    80002aea:	4901                	li	s2,0
    kexit(-1);
    80002aec:	557d                	li	a0,-1
    80002aee:	df4ff0ef          	jal	800020e2 <kexit>
  if(which_dev == 2)
    80002af2:	4789                	li	a5,2
    80002af4:	faf919e3          	bne	s2,a5,80002aa6 <usertrap+0xb6>
    yield();
    80002af8:	cb2ff0ef          	jal	80001faa <yield>
    80002afc:	b76d                	j	80002aa6 <usertrap+0xb6>

0000000080002afe <kerneltrap>:
{
    80002afe:	7179                	addi	sp,sp,-48
    80002b00:	f406                	sd	ra,40(sp)
    80002b02:	f022                	sd	s0,32(sp)
    80002b04:	ec26                	sd	s1,24(sp)
    80002b06:	e84a                	sd	s2,16(sp)
    80002b08:	e44e                	sd	s3,8(sp)
    80002b0a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b0c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b10:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b14:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002b18:	1004f793          	andi	a5,s1,256
    80002b1c:	c795                	beqz	a5,80002b48 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b1e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002b22:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002b24:	eb85                	bnez	a5,80002b54 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002b26:	e57ff0ef          	jal	8000297c <devintr>
    80002b2a:	c91d                	beqz	a0,80002b60 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002b2c:	4789                	li	a5,2
    80002b2e:	04f50a63          	beq	a0,a5,80002b82 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002b32:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b36:	10049073          	csrw	sstatus,s1
}
    80002b3a:	70a2                	ld	ra,40(sp)
    80002b3c:	7402                	ld	s0,32(sp)
    80002b3e:	64e2                	ld	s1,24(sp)
    80002b40:	6942                	ld	s2,16(sp)
    80002b42:	69a2                	ld	s3,8(sp)
    80002b44:	6145                	addi	sp,sp,48
    80002b46:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002b48:	00004517          	auipc	a0,0x4
    80002b4c:	7a050513          	addi	a0,a0,1952 # 800072e8 <etext+0x2e8>
    80002b50:	c8ffd0ef          	jal	800007de <panic>
    panic("kerneltrap: interrupts enabled");
    80002b54:	00004517          	auipc	a0,0x4
    80002b58:	7bc50513          	addi	a0,a0,1980 # 80007310 <etext+0x310>
    80002b5c:	c83fd0ef          	jal	800007de <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b60:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002b64:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002b68:	85ce                	mv	a1,s3
    80002b6a:	00004517          	auipc	a0,0x4
    80002b6e:	7c650513          	addi	a0,a0,1990 # 80007330 <etext+0x330>
    80002b72:	989fd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    80002b76:	00004517          	auipc	a0,0x4
    80002b7a:	7e250513          	addi	a0,a0,2018 # 80007358 <etext+0x358>
    80002b7e:	c61fd0ef          	jal	800007de <panic>
  if(which_dev == 2 && myproc() != 0)
    80002b82:	d3dfe0ef          	jal	800018be <myproc>
    80002b86:	d555                	beqz	a0,80002b32 <kerneltrap+0x34>
    yield();
    80002b88:	c22ff0ef          	jal	80001faa <yield>
    80002b8c:	b75d                	j	80002b32 <kerneltrap+0x34>

0000000080002b8e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002b8e:	1101                	addi	sp,sp,-32
    80002b90:	ec06                	sd	ra,24(sp)
    80002b92:	e822                	sd	s0,16(sp)
    80002b94:	e426                	sd	s1,8(sp)
    80002b96:	1000                	addi	s0,sp,32
    80002b98:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b9a:	d25fe0ef          	jal	800018be <myproc>
  switch (n) {
    80002b9e:	4795                	li	a5,5
    80002ba0:	0497e163          	bltu	a5,s1,80002be2 <argraw+0x54>
    80002ba4:	048a                	slli	s1,s1,0x2
    80002ba6:	00005717          	auipc	a4,0x5
    80002baa:	bb270713          	addi	a4,a4,-1102 # 80007758 <states.0+0x30>
    80002bae:	94ba                	add	s1,s1,a4
    80002bb0:	409c                	lw	a5,0(s1)
    80002bb2:	97ba                	add	a5,a5,a4
    80002bb4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002bb6:	713c                	ld	a5,96(a0)
    80002bb8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002bba:	60e2                	ld	ra,24(sp)
    80002bbc:	6442                	ld	s0,16(sp)
    80002bbe:	64a2                	ld	s1,8(sp)
    80002bc0:	6105                	addi	sp,sp,32
    80002bc2:	8082                	ret
    return p->trapframe->a1;
    80002bc4:	713c                	ld	a5,96(a0)
    80002bc6:	7fa8                	ld	a0,120(a5)
    80002bc8:	bfcd                	j	80002bba <argraw+0x2c>
    return p->trapframe->a2;
    80002bca:	713c                	ld	a5,96(a0)
    80002bcc:	63c8                	ld	a0,128(a5)
    80002bce:	b7f5                	j	80002bba <argraw+0x2c>
    return p->trapframe->a3;
    80002bd0:	713c                	ld	a5,96(a0)
    80002bd2:	67c8                	ld	a0,136(a5)
    80002bd4:	b7dd                	j	80002bba <argraw+0x2c>
    return p->trapframe->a4;
    80002bd6:	713c                	ld	a5,96(a0)
    80002bd8:	6bc8                	ld	a0,144(a5)
    80002bda:	b7c5                	j	80002bba <argraw+0x2c>
    return p->trapframe->a5;
    80002bdc:	713c                	ld	a5,96(a0)
    80002bde:	6fc8                	ld	a0,152(a5)
    80002be0:	bfe9                	j	80002bba <argraw+0x2c>
  panic("argraw");
    80002be2:	00004517          	auipc	a0,0x4
    80002be6:	78650513          	addi	a0,a0,1926 # 80007368 <etext+0x368>
    80002bea:	bf5fd0ef          	jal	800007de <panic>

0000000080002bee <fetchaddr>:
{
    80002bee:	1101                	addi	sp,sp,-32
    80002bf0:	ec06                	sd	ra,24(sp)
    80002bf2:	e822                	sd	s0,16(sp)
    80002bf4:	e426                	sd	s1,8(sp)
    80002bf6:	e04a                	sd	s2,0(sp)
    80002bf8:	1000                	addi	s0,sp,32
    80002bfa:	84aa                	mv	s1,a0
    80002bfc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002bfe:	cc1fe0ef          	jal	800018be <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002c02:	693c                	ld	a5,80(a0)
    80002c04:	02f4f663          	bgeu	s1,a5,80002c30 <fetchaddr+0x42>
    80002c08:	00848713          	addi	a4,s1,8
    80002c0c:	02e7e463          	bltu	a5,a4,80002c34 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002c10:	46a1                	li	a3,8
    80002c12:	8626                	mv	a2,s1
    80002c14:	85ca                	mv	a1,s2
    80002c16:	6d28                	ld	a0,88(a0)
    80002c18:	a97fe0ef          	jal	800016ae <copyin>
    80002c1c:	00a03533          	snez	a0,a0
    80002c20:	40a0053b          	negw	a0,a0
}
    80002c24:	60e2                	ld	ra,24(sp)
    80002c26:	6442                	ld	s0,16(sp)
    80002c28:	64a2                	ld	s1,8(sp)
    80002c2a:	6902                	ld	s2,0(sp)
    80002c2c:	6105                	addi	sp,sp,32
    80002c2e:	8082                	ret
    return -1;
    80002c30:	557d                	li	a0,-1
    80002c32:	bfcd                	j	80002c24 <fetchaddr+0x36>
    80002c34:	557d                	li	a0,-1
    80002c36:	b7fd                	j	80002c24 <fetchaddr+0x36>

0000000080002c38 <fetchstr>:
{
    80002c38:	7179                	addi	sp,sp,-48
    80002c3a:	f406                	sd	ra,40(sp)
    80002c3c:	f022                	sd	s0,32(sp)
    80002c3e:	ec26                	sd	s1,24(sp)
    80002c40:	e84a                	sd	s2,16(sp)
    80002c42:	e44e                	sd	s3,8(sp)
    80002c44:	1800                	addi	s0,sp,48
    80002c46:	892a                	mv	s2,a0
    80002c48:	84ae                	mv	s1,a1
    80002c4a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002c4c:	c73fe0ef          	jal	800018be <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002c50:	86ce                	mv	a3,s3
    80002c52:	864a                	mv	a2,s2
    80002c54:	85a6                	mv	a1,s1
    80002c56:	6d28                	ld	a0,88(a0)
    80002c58:	857fe0ef          	jal	800014ae <copyinstr>
    80002c5c:	00054c63          	bltz	a0,80002c74 <fetchstr+0x3c>
  return strlen(buf);
    80002c60:	8526                	mv	a0,s1
    80002c62:	9c2fe0ef          	jal	80000e24 <strlen>
}
    80002c66:	70a2                	ld	ra,40(sp)
    80002c68:	7402                	ld	s0,32(sp)
    80002c6a:	64e2                	ld	s1,24(sp)
    80002c6c:	6942                	ld	s2,16(sp)
    80002c6e:	69a2                	ld	s3,8(sp)
    80002c70:	6145                	addi	sp,sp,48
    80002c72:	8082                	ret
    return -1;
    80002c74:	557d                	li	a0,-1
    80002c76:	bfc5                	j	80002c66 <fetchstr+0x2e>

0000000080002c78 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002c78:	1101                	addi	sp,sp,-32
    80002c7a:	ec06                	sd	ra,24(sp)
    80002c7c:	e822                	sd	s0,16(sp)
    80002c7e:	e426                	sd	s1,8(sp)
    80002c80:	1000                	addi	s0,sp,32
    80002c82:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c84:	f0bff0ef          	jal	80002b8e <argraw>
    80002c88:	c088                	sw	a0,0(s1)
}
    80002c8a:	60e2                	ld	ra,24(sp)
    80002c8c:	6442                	ld	s0,16(sp)
    80002c8e:	64a2                	ld	s1,8(sp)
    80002c90:	6105                	addi	sp,sp,32
    80002c92:	8082                	ret

0000000080002c94 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002c94:	1101                	addi	sp,sp,-32
    80002c96:	ec06                	sd	ra,24(sp)
    80002c98:	e822                	sd	s0,16(sp)
    80002c9a:	e426                	sd	s1,8(sp)
    80002c9c:	1000                	addi	s0,sp,32
    80002c9e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ca0:	eefff0ef          	jal	80002b8e <argraw>
    80002ca4:	e088                	sd	a0,0(s1)
}
    80002ca6:	60e2                	ld	ra,24(sp)
    80002ca8:	6442                	ld	s0,16(sp)
    80002caa:	64a2                	ld	s1,8(sp)
    80002cac:	6105                	addi	sp,sp,32
    80002cae:	8082                	ret

0000000080002cb0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002cb0:	1101                	addi	sp,sp,-32
    80002cb2:	ec06                	sd	ra,24(sp)
    80002cb4:	e822                	sd	s0,16(sp)
    80002cb6:	e426                	sd	s1,8(sp)
    80002cb8:	e04a                	sd	s2,0(sp)
    80002cba:	1000                	addi	s0,sp,32
    80002cbc:	84ae                	mv	s1,a1
    80002cbe:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002cc0:	ecfff0ef          	jal	80002b8e <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002cc4:	864a                	mv	a2,s2
    80002cc6:	85a6                	mv	a1,s1
    80002cc8:	f71ff0ef          	jal	80002c38 <fetchstr>
}
    80002ccc:	60e2                	ld	ra,24(sp)
    80002cce:	6442                	ld	s0,16(sp)
    80002cd0:	64a2                	ld	s1,8(sp)
    80002cd2:	6902                	ld	s2,0(sp)
    80002cd4:	6105                	addi	sp,sp,32
    80002cd6:	8082                	ret

0000000080002cd8 <syscall>:
[SYS_join]    sys_join,
};

void
syscall(void)
{
    80002cd8:	1101                	addi	sp,sp,-32
    80002cda:	ec06                	sd	ra,24(sp)
    80002cdc:	e822                	sd	s0,16(sp)
    80002cde:	e426                	sd	s1,8(sp)
    80002ce0:	e04a                	sd	s2,0(sp)
    80002ce2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002ce4:	bdbfe0ef          	jal	800018be <myproc>
    80002ce8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002cea:	06053903          	ld	s2,96(a0)
    80002cee:	0a893783          	ld	a5,168(s2)
    80002cf2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002cf6:	37fd                	addiw	a5,a5,-1
    80002cf8:	4759                	li	a4,22
    80002cfa:	00f76f63          	bltu	a4,a5,80002d18 <syscall+0x40>
    80002cfe:	00369713          	slli	a4,a3,0x3
    80002d02:	00005797          	auipc	a5,0x5
    80002d06:	a6e78793          	addi	a5,a5,-1426 # 80007770 <syscalls>
    80002d0a:	97ba                	add	a5,a5,a4
    80002d0c:	639c                	ld	a5,0(a5)
    80002d0e:	c789                	beqz	a5,80002d18 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002d10:	9782                	jalr	a5
    80002d12:	06a93823          	sd	a0,112(s2)
    80002d16:	a829                	j	80002d30 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002d18:	16048613          	addi	a2,s1,352
    80002d1c:	588c                	lw	a1,48(s1)
    80002d1e:	00004517          	auipc	a0,0x4
    80002d22:	65250513          	addi	a0,a0,1618 # 80007370 <etext+0x370>
    80002d26:	fd4fd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002d2a:	70bc                	ld	a5,96(s1)
    80002d2c:	577d                	li	a4,-1
    80002d2e:	fbb8                	sd	a4,112(a5)
  }
}
    80002d30:	60e2                	ld	ra,24(sp)
    80002d32:	6442                	ld	s0,16(sp)
    80002d34:	64a2                	ld	s1,8(sp)
    80002d36:	6902                	ld	s2,0(sp)
    80002d38:	6105                	addi	sp,sp,32
    80002d3a:	8082                	ret

0000000080002d3c <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80002d3c:	1101                	addi	sp,sp,-32
    80002d3e:	ec06                	sd	ra,24(sp)
    80002d40:	e822                	sd	s0,16(sp)
    80002d42:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002d44:	fec40593          	addi	a1,s0,-20
    80002d48:	4501                	li	a0,0
    80002d4a:	f2fff0ef          	jal	80002c78 <argint>
  kexit(n);
    80002d4e:	fec42503          	lw	a0,-20(s0)
    80002d52:	b90ff0ef          	jal	800020e2 <kexit>
  return 0;  // not reached
}
    80002d56:	4501                	li	a0,0
    80002d58:	60e2                	ld	ra,24(sp)
    80002d5a:	6442                	ld	s0,16(sp)
    80002d5c:	6105                	addi	sp,sp,32
    80002d5e:	8082                	ret

0000000080002d60 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002d60:	1141                	addi	sp,sp,-16
    80002d62:	e406                	sd	ra,8(sp)
    80002d64:	e022                	sd	s0,0(sp)
    80002d66:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002d68:	b57fe0ef          	jal	800018be <myproc>
}
    80002d6c:	5908                	lw	a0,48(a0)
    80002d6e:	60a2                	ld	ra,8(sp)
    80002d70:	6402                	ld	s0,0(sp)
    80002d72:	0141                	addi	sp,sp,16
    80002d74:	8082                	ret

0000000080002d76 <sys_fork>:

uint64
sys_fork(void)
{
    80002d76:	1141                	addi	sp,sp,-16
    80002d78:	e406                	sd	ra,8(sp)
    80002d7a:	e022                	sd	s0,0(sp)
    80002d7c:	0800                	addi	s0,sp,16
  return kfork();
    80002d7e:	fa1fe0ef          	jal	80001d1e <kfork>
}
    80002d82:	60a2                	ld	ra,8(sp)
    80002d84:	6402                	ld	s0,0(sp)
    80002d86:	0141                	addi	sp,sp,16
    80002d88:	8082                	ret

0000000080002d8a <sys_wait>:

uint64
sys_wait(void)
{
    80002d8a:	1101                	addi	sp,sp,-32
    80002d8c:	ec06                	sd	ra,24(sp)
    80002d8e:	e822                	sd	s0,16(sp)
    80002d90:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002d92:	fe840593          	addi	a1,s0,-24
    80002d96:	4501                	li	a0,0
    80002d98:	efdff0ef          	jal	80002c94 <argaddr>
  return kwait(p);
    80002d9c:	fe843503          	ld	a0,-24(s0)
    80002da0:	d38ff0ef          	jal	800022d8 <kwait>
}
    80002da4:	60e2                	ld	ra,24(sp)
    80002da6:	6442                	ld	s0,16(sp)
    80002da8:	6105                	addi	sp,sp,32
    80002daa:	8082                	ret

0000000080002dac <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002dac:	7139                	addi	sp,sp,-64
    80002dae:	fc06                	sd	ra,56(sp)
    80002db0:	f822                	sd	s0,48(sp)
    80002db2:	e852                	sd	s4,16(sp)
    80002db4:	0080                	addi	s0,sp,64
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002db6:	fc840593          	addi	a1,s0,-56
    80002dba:	4501                	li	a0,0
    80002dbc:	ebdff0ef          	jal	80002c78 <argint>
  argint(1, &t);
    80002dc0:	fcc40593          	addi	a1,s0,-52
    80002dc4:	4505                	li	a0,1
    80002dc6:	eb3ff0ef          	jal	80002c78 <argint>
  addr = myproc()->sz;
    80002dca:	af5fe0ef          	jal	800018be <myproc>
    80002dce:	05053a03          	ld	s4,80(a0)

  if(t == SBRK_EAGER || n < 0) {
    80002dd2:	fcc42703          	lw	a4,-52(s0)
    80002dd6:	4785                	li	a5,1
    80002dd8:	02f70c63          	beq	a4,a5,80002e10 <sys_sbrk+0x64>
    80002ddc:	fc842783          	lw	a5,-56(s0)
    80002de0:	0207c863          	bltz	a5,80002e10 <sys_sbrk+0x64>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80002de4:	97d2                	add	a5,a5,s4
    80002de6:	0747ee63          	bltu	a5,s4,80002e62 <sys_sbrk+0xb6>
      return -1;
    if(addr + n > TRAPFRAME(NPROC))
    80002dea:	02000737          	lui	a4,0x2000
    80002dee:	fdf70713          	addi	a4,a4,-33 # 1ffffdf <_entry-0x7e000021>
    80002df2:	0736                	slli	a4,a4,0xd
    80002df4:	06f76963          	bltu	a4,a5,80002e66 <sys_sbrk+0xba>
    80002df8:	f426                	sd	s1,40(sp)
    80002dfa:	f04a                	sd	s2,32(sp)
    80002dfc:	ec4e                	sd	s3,24(sp)
      return -1;
    extern struct proc proc[NPROC];
    struct proc *np;
    for (np = proc; np < &proc[NPROC]; np++) {
    80002dfe:	0000d497          	auipc	s1,0xd
    80002e02:	f9a48493          	addi	s1,s1,-102 # 8000fd98 <proc>
    80002e06:	00013997          	auipc	s3,0x13
    80002e0a:	b9298993          	addi	s3,s3,-1134 # 80015998 <tickslock>
    80002e0e:	a025                	j	80002e36 <sys_sbrk+0x8a>
    if(growproc(n) < 0) {
    80002e10:	fc842503          	lw	a0,-56(s0)
    80002e14:	e65fe0ef          	jal	80001c78 <growproc>
    80002e18:	04054363          	bltz	a0,80002e5e <sys_sbrk+0xb2>
      }
      release(&np->lock);
    }
  }
  return addr;
}
    80002e1c:	8552                	mv	a0,s4
    80002e1e:	70e2                	ld	ra,56(sp)
    80002e20:	7442                	ld	s0,48(sp)
    80002e22:	6a42                	ld	s4,16(sp)
    80002e24:	6121                	addi	sp,sp,64
    80002e26:	8082                	ret
      release(&np->lock);
    80002e28:	8526                	mv	a0,s1
    80002e2a:	e37fd0ef          	jal	80000c60 <release>
    for (np = proc; np < &proc[NPROC]; np++) {
    80002e2e:	17048493          	addi	s1,s1,368
    80002e32:	03348263          	beq	s1,s3,80002e56 <sys_sbrk+0xaa>
      acquire(&np->lock);
    80002e36:	8526                	mv	a0,s1
    80002e38:	d95fd0ef          	jal	80000bcc <acquire>
      if (np->tgid == myproc()->tgid) {
    80002e3c:	0344a903          	lw	s2,52(s1)
    80002e40:	a7ffe0ef          	jal	800018be <myproc>
    80002e44:	595c                	lw	a5,52(a0)
    80002e46:	ff2791e3          	bne	a5,s2,80002e28 <sys_sbrk+0x7c>
          np->sz += n;
    80002e4a:	fc842703          	lw	a4,-56(s0)
    80002e4e:	68bc                	ld	a5,80(s1)
    80002e50:	97ba                	add	a5,a5,a4
    80002e52:	e8bc                	sd	a5,80(s1)
    80002e54:	bfd1                	j	80002e28 <sys_sbrk+0x7c>
    80002e56:	74a2                	ld	s1,40(sp)
    80002e58:	7902                	ld	s2,32(sp)
    80002e5a:	69e2                	ld	s3,24(sp)
    80002e5c:	b7c1                	j	80002e1c <sys_sbrk+0x70>
      return -1;
    80002e5e:	5a7d                	li	s4,-1
    80002e60:	bf75                	j	80002e1c <sys_sbrk+0x70>
      return -1;
    80002e62:	5a7d                	li	s4,-1
    80002e64:	bf65                	j	80002e1c <sys_sbrk+0x70>
      return -1;
    80002e66:	5a7d                	li	s4,-1
    80002e68:	bf55                	j	80002e1c <sys_sbrk+0x70>

0000000080002e6a <sys_pause>:

uint64
sys_pause(void)
{
    80002e6a:	7139                	addi	sp,sp,-64
    80002e6c:	fc06                	sd	ra,56(sp)
    80002e6e:	f822                	sd	s0,48(sp)
    80002e70:	f04a                	sd	s2,32(sp)
    80002e72:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002e74:	fcc40593          	addi	a1,s0,-52
    80002e78:	4501                	li	a0,0
    80002e7a:	dffff0ef          	jal	80002c78 <argint>
  if(n < 0)
    80002e7e:	fcc42783          	lw	a5,-52(s0)
    80002e82:	0607c763          	bltz	a5,80002ef0 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80002e86:	00013517          	auipc	a0,0x13
    80002e8a:	b1250513          	addi	a0,a0,-1262 # 80015998 <tickslock>
    80002e8e:	d3ffd0ef          	jal	80000bcc <acquire>
  ticks0 = ticks;
    80002e92:	00005917          	auipc	s2,0x5
    80002e96:	9d692903          	lw	s2,-1578(s2) # 80007868 <ticks>
  while(ticks - ticks0 < n){
    80002e9a:	fcc42783          	lw	a5,-52(s0)
    80002e9e:	cf8d                	beqz	a5,80002ed8 <sys_pause+0x6e>
    80002ea0:	f426                	sd	s1,40(sp)
    80002ea2:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002ea4:	00013997          	auipc	s3,0x13
    80002ea8:	af498993          	addi	s3,s3,-1292 # 80015998 <tickslock>
    80002eac:	00005497          	auipc	s1,0x5
    80002eb0:	9bc48493          	addi	s1,s1,-1604 # 80007868 <ticks>
    if(killed(myproc())){
    80002eb4:	a0bfe0ef          	jal	800018be <myproc>
    80002eb8:	bf6ff0ef          	jal	800022ae <killed>
    80002ebc:	ed0d                	bnez	a0,80002ef6 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002ebe:	85ce                	mv	a1,s3
    80002ec0:	8526                	mv	a0,s1
    80002ec2:	914ff0ef          	jal	80001fd6 <sleep>
  while(ticks - ticks0 < n){
    80002ec6:	409c                	lw	a5,0(s1)
    80002ec8:	412787bb          	subw	a5,a5,s2
    80002ecc:	fcc42703          	lw	a4,-52(s0)
    80002ed0:	fee7e2e3          	bltu	a5,a4,80002eb4 <sys_pause+0x4a>
    80002ed4:	74a2                	ld	s1,40(sp)
    80002ed6:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002ed8:	00013517          	auipc	a0,0x13
    80002edc:	ac050513          	addi	a0,a0,-1344 # 80015998 <tickslock>
    80002ee0:	d81fd0ef          	jal	80000c60 <release>
  return 0;
    80002ee4:	4501                	li	a0,0
}
    80002ee6:	70e2                	ld	ra,56(sp)
    80002ee8:	7442                	ld	s0,48(sp)
    80002eea:	7902                	ld	s2,32(sp)
    80002eec:	6121                	addi	sp,sp,64
    80002eee:	8082                	ret
    n = 0;
    80002ef0:	fc042623          	sw	zero,-52(s0)
    80002ef4:	bf49                	j	80002e86 <sys_pause+0x1c>
      release(&tickslock);
    80002ef6:	00013517          	auipc	a0,0x13
    80002efa:	aa250513          	addi	a0,a0,-1374 # 80015998 <tickslock>
    80002efe:	d63fd0ef          	jal	80000c60 <release>
      return -1;
    80002f02:	557d                	li	a0,-1
    80002f04:	74a2                	ld	s1,40(sp)
    80002f06:	69e2                	ld	s3,24(sp)
    80002f08:	bff9                	j	80002ee6 <sys_pause+0x7c>

0000000080002f0a <sys_kill>:

uint64
sys_kill(void)
{
    80002f0a:	1101                	addi	sp,sp,-32
    80002f0c:	ec06                	sd	ra,24(sp)
    80002f0e:	e822                	sd	s0,16(sp)
    80002f10:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002f12:	fec40593          	addi	a1,s0,-20
    80002f16:	4501                	li	a0,0
    80002f18:	d61ff0ef          	jal	80002c78 <argint>
  return kkill(pid);
    80002f1c:	fec42503          	lw	a0,-20(s0)
    80002f20:	b04ff0ef          	jal	80002224 <kkill>
}
    80002f24:	60e2                	ld	ra,24(sp)
    80002f26:	6442                	ld	s0,16(sp)
    80002f28:	6105                	addi	sp,sp,32
    80002f2a:	8082                	ret

0000000080002f2c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002f2c:	1101                	addi	sp,sp,-32
    80002f2e:	ec06                	sd	ra,24(sp)
    80002f30:	e822                	sd	s0,16(sp)
    80002f32:	e426                	sd	s1,8(sp)
    80002f34:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002f36:	00013517          	auipc	a0,0x13
    80002f3a:	a6250513          	addi	a0,a0,-1438 # 80015998 <tickslock>
    80002f3e:	c8ffd0ef          	jal	80000bcc <acquire>
  xticks = ticks;
    80002f42:	00005497          	auipc	s1,0x5
    80002f46:	9264a483          	lw	s1,-1754(s1) # 80007868 <ticks>
  release(&tickslock);
    80002f4a:	00013517          	auipc	a0,0x13
    80002f4e:	a4e50513          	addi	a0,a0,-1458 # 80015998 <tickslock>
    80002f52:	d0ffd0ef          	jal	80000c60 <release>
  return xticks;
}
    80002f56:	02049513          	slli	a0,s1,0x20
    80002f5a:	9101                	srli	a0,a0,0x20
    80002f5c:	60e2                	ld	ra,24(sp)
    80002f5e:	6442                	ld	s0,16(sp)
    80002f60:	64a2                	ld	s1,8(sp)
    80002f62:	6105                	addi	sp,sp,32
    80002f64:	8082                	ret

0000000080002f66 <sys_clone>:

uint64
sys_clone(void)
{
    80002f66:	7179                	addi	sp,sp,-48
    80002f68:	f406                	sd	ra,40(sp)
    80002f6a:	f022                	sd	s0,32(sp)
    80002f6c:	1800                	addi	s0,sp,48
  uint64 fn;
  uint64 arg;
  uint64 stack;

  argaddr(0, &fn);
    80002f6e:	fe840593          	addi	a1,s0,-24
    80002f72:	4501                	li	a0,0
    80002f74:	d21ff0ef          	jal	80002c94 <argaddr>
  argaddr(1, &arg);
    80002f78:	fe040593          	addi	a1,s0,-32
    80002f7c:	4505                	li	a0,1
    80002f7e:	d17ff0ef          	jal	80002c94 <argaddr>
  argaddr(2, &stack);
    80002f82:	fd840593          	addi	a1,s0,-40
    80002f86:	4509                	li	a0,2
    80002f88:	d0dff0ef          	jal	80002c94 <argaddr>

  return clone(fn, arg, stack);
    80002f8c:	fd843603          	ld	a2,-40(s0)
    80002f90:	fe043583          	ld	a1,-32(s0)
    80002f94:	fe843503          	ld	a0,-24(s0)
    80002f98:	da6ff0ef          	jal	8000253e <clone>
}
    80002f9c:	70a2                	ld	ra,40(sp)
    80002f9e:	7402                	ld	s0,32(sp)
    80002fa0:	6145                	addi	sp,sp,48
    80002fa2:	8082                	ret

0000000080002fa4 <sys_join>:

uint64
sys_join(void)
{
    80002fa4:	1141                	addi	sp,sp,-16
    80002fa6:	e406                	sd	ra,8(sp)
    80002fa8:	e022                	sd	s0,0(sp)
    80002faa:	0800                	addi	s0,sp,16
  return join();
    80002fac:	f62ff0ef          	jal	8000270e <join>
}
    80002fb0:	60a2                	ld	ra,8(sp)
    80002fb2:	6402                	ld	s0,0(sp)
    80002fb4:	0141                	addi	sp,sp,16
    80002fb6:	8082                	ret

0000000080002fb8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002fb8:	7179                	addi	sp,sp,-48
    80002fba:	f406                	sd	ra,40(sp)
    80002fbc:	f022                	sd	s0,32(sp)
    80002fbe:	ec26                	sd	s1,24(sp)
    80002fc0:	e84a                	sd	s2,16(sp)
    80002fc2:	e44e                	sd	s3,8(sp)
    80002fc4:	e052                	sd	s4,0(sp)
    80002fc6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002fc8:	00004597          	auipc	a1,0x4
    80002fcc:	3c858593          	addi	a1,a1,968 # 80007390 <etext+0x390>
    80002fd0:	00013517          	auipc	a0,0x13
    80002fd4:	9e050513          	addi	a0,a0,-1568 # 800159b0 <bcache>
    80002fd8:	b71fd0ef          	jal	80000b48 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002fdc:	0001b797          	auipc	a5,0x1b
    80002fe0:	9d478793          	addi	a5,a5,-1580 # 8001d9b0 <bcache+0x8000>
    80002fe4:	0001b717          	auipc	a4,0x1b
    80002fe8:	c3470713          	addi	a4,a4,-972 # 8001dc18 <bcache+0x8268>
    80002fec:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002ff0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ff4:	00013497          	auipc	s1,0x13
    80002ff8:	9d448493          	addi	s1,s1,-1580 # 800159c8 <bcache+0x18>
    b->next = bcache.head.next;
    80002ffc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002ffe:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003000:	00004a17          	auipc	s4,0x4
    80003004:	398a0a13          	addi	s4,s4,920 # 80007398 <etext+0x398>
    b->next = bcache.head.next;
    80003008:	2b893783          	ld	a5,696(s2)
    8000300c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000300e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003012:	85d2                	mv	a1,s4
    80003014:	01048513          	addi	a0,s1,16
    80003018:	31c010ef          	jal	80004334 <initsleeplock>
    bcache.head.next->prev = b;
    8000301c:	2b893783          	ld	a5,696(s2)
    80003020:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003022:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003026:	45848493          	addi	s1,s1,1112
    8000302a:	fd349fe3          	bne	s1,s3,80003008 <binit+0x50>
  }
}
    8000302e:	70a2                	ld	ra,40(sp)
    80003030:	7402                	ld	s0,32(sp)
    80003032:	64e2                	ld	s1,24(sp)
    80003034:	6942                	ld	s2,16(sp)
    80003036:	69a2                	ld	s3,8(sp)
    80003038:	6a02                	ld	s4,0(sp)
    8000303a:	6145                	addi	sp,sp,48
    8000303c:	8082                	ret

000000008000303e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000303e:	7179                	addi	sp,sp,-48
    80003040:	f406                	sd	ra,40(sp)
    80003042:	f022                	sd	s0,32(sp)
    80003044:	ec26                	sd	s1,24(sp)
    80003046:	e84a                	sd	s2,16(sp)
    80003048:	e44e                	sd	s3,8(sp)
    8000304a:	1800                	addi	s0,sp,48
    8000304c:	892a                	mv	s2,a0
    8000304e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003050:	00013517          	auipc	a0,0x13
    80003054:	96050513          	addi	a0,a0,-1696 # 800159b0 <bcache>
    80003058:	b75fd0ef          	jal	80000bcc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000305c:	0001b497          	auipc	s1,0x1b
    80003060:	c0c4b483          	ld	s1,-1012(s1) # 8001dc68 <bcache+0x82b8>
    80003064:	0001b797          	auipc	a5,0x1b
    80003068:	bb478793          	addi	a5,a5,-1100 # 8001dc18 <bcache+0x8268>
    8000306c:	02f48b63          	beq	s1,a5,800030a2 <bread+0x64>
    80003070:	873e                	mv	a4,a5
    80003072:	a021                	j	8000307a <bread+0x3c>
    80003074:	68a4                	ld	s1,80(s1)
    80003076:	02e48663          	beq	s1,a4,800030a2 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000307a:	449c                	lw	a5,8(s1)
    8000307c:	ff279ce3          	bne	a5,s2,80003074 <bread+0x36>
    80003080:	44dc                	lw	a5,12(s1)
    80003082:	ff3799e3          	bne	a5,s3,80003074 <bread+0x36>
      b->refcnt++;
    80003086:	40bc                	lw	a5,64(s1)
    80003088:	2785                	addiw	a5,a5,1
    8000308a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000308c:	00013517          	auipc	a0,0x13
    80003090:	92450513          	addi	a0,a0,-1756 # 800159b0 <bcache>
    80003094:	bcdfd0ef          	jal	80000c60 <release>
      acquiresleep(&b->lock);
    80003098:	01048513          	addi	a0,s1,16
    8000309c:	2ce010ef          	jal	8000436a <acquiresleep>
      return b;
    800030a0:	a889                	j	800030f2 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800030a2:	0001b497          	auipc	s1,0x1b
    800030a6:	bbe4b483          	ld	s1,-1090(s1) # 8001dc60 <bcache+0x82b0>
    800030aa:	0001b797          	auipc	a5,0x1b
    800030ae:	b6e78793          	addi	a5,a5,-1170 # 8001dc18 <bcache+0x8268>
    800030b2:	00f48863          	beq	s1,a5,800030c2 <bread+0x84>
    800030b6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800030b8:	40bc                	lw	a5,64(s1)
    800030ba:	cb91                	beqz	a5,800030ce <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800030bc:	64a4                	ld	s1,72(s1)
    800030be:	fee49de3          	bne	s1,a4,800030b8 <bread+0x7a>
  panic("bget: no buffers");
    800030c2:	00004517          	auipc	a0,0x4
    800030c6:	2de50513          	addi	a0,a0,734 # 800073a0 <etext+0x3a0>
    800030ca:	f14fd0ef          	jal	800007de <panic>
      b->dev = dev;
    800030ce:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800030d2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800030d6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800030da:	4785                	li	a5,1
    800030dc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800030de:	00013517          	auipc	a0,0x13
    800030e2:	8d250513          	addi	a0,a0,-1838 # 800159b0 <bcache>
    800030e6:	b7bfd0ef          	jal	80000c60 <release>
      acquiresleep(&b->lock);
    800030ea:	01048513          	addi	a0,s1,16
    800030ee:	27c010ef          	jal	8000436a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800030f2:	409c                	lw	a5,0(s1)
    800030f4:	cb89                	beqz	a5,80003106 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800030f6:	8526                	mv	a0,s1
    800030f8:	70a2                	ld	ra,40(sp)
    800030fa:	7402                	ld	s0,32(sp)
    800030fc:	64e2                	ld	s1,24(sp)
    800030fe:	6942                	ld	s2,16(sp)
    80003100:	69a2                	ld	s3,8(sp)
    80003102:	6145                	addi	sp,sp,48
    80003104:	8082                	ret
    virtio_disk_rw(b, 0);
    80003106:	4581                	li	a1,0
    80003108:	8526                	mv	a0,s1
    8000310a:	377020ef          	jal	80005c80 <virtio_disk_rw>
    b->valid = 1;
    8000310e:	4785                	li	a5,1
    80003110:	c09c                	sw	a5,0(s1)
  return b;
    80003112:	b7d5                	j	800030f6 <bread+0xb8>

0000000080003114 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003114:	1101                	addi	sp,sp,-32
    80003116:	ec06                	sd	ra,24(sp)
    80003118:	e822                	sd	s0,16(sp)
    8000311a:	e426                	sd	s1,8(sp)
    8000311c:	1000                	addi	s0,sp,32
    8000311e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003120:	0541                	addi	a0,a0,16
    80003122:	2c6010ef          	jal	800043e8 <holdingsleep>
    80003126:	c911                	beqz	a0,8000313a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003128:	4585                	li	a1,1
    8000312a:	8526                	mv	a0,s1
    8000312c:	355020ef          	jal	80005c80 <virtio_disk_rw>
}
    80003130:	60e2                	ld	ra,24(sp)
    80003132:	6442                	ld	s0,16(sp)
    80003134:	64a2                	ld	s1,8(sp)
    80003136:	6105                	addi	sp,sp,32
    80003138:	8082                	ret
    panic("bwrite");
    8000313a:	00004517          	auipc	a0,0x4
    8000313e:	27e50513          	addi	a0,a0,638 # 800073b8 <etext+0x3b8>
    80003142:	e9cfd0ef          	jal	800007de <panic>

0000000080003146 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003146:	1101                	addi	sp,sp,-32
    80003148:	ec06                	sd	ra,24(sp)
    8000314a:	e822                	sd	s0,16(sp)
    8000314c:	e426                	sd	s1,8(sp)
    8000314e:	e04a                	sd	s2,0(sp)
    80003150:	1000                	addi	s0,sp,32
    80003152:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003154:	01050913          	addi	s2,a0,16
    80003158:	854a                	mv	a0,s2
    8000315a:	28e010ef          	jal	800043e8 <holdingsleep>
    8000315e:	c125                	beqz	a0,800031be <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80003160:	854a                	mv	a0,s2
    80003162:	24e010ef          	jal	800043b0 <releasesleep>

  acquire(&bcache.lock);
    80003166:	00013517          	auipc	a0,0x13
    8000316a:	84a50513          	addi	a0,a0,-1974 # 800159b0 <bcache>
    8000316e:	a5ffd0ef          	jal	80000bcc <acquire>
  b->refcnt--;
    80003172:	40bc                	lw	a5,64(s1)
    80003174:	37fd                	addiw	a5,a5,-1
    80003176:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003178:	e79d                	bnez	a5,800031a6 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000317a:	68b8                	ld	a4,80(s1)
    8000317c:	64bc                	ld	a5,72(s1)
    8000317e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003180:	68b8                	ld	a4,80(s1)
    80003182:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003184:	0001b797          	auipc	a5,0x1b
    80003188:	82c78793          	addi	a5,a5,-2004 # 8001d9b0 <bcache+0x8000>
    8000318c:	2b87b703          	ld	a4,696(a5)
    80003190:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003192:	0001b717          	auipc	a4,0x1b
    80003196:	a8670713          	addi	a4,a4,-1402 # 8001dc18 <bcache+0x8268>
    8000319a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000319c:	2b87b703          	ld	a4,696(a5)
    800031a0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800031a2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800031a6:	00013517          	auipc	a0,0x13
    800031aa:	80a50513          	addi	a0,a0,-2038 # 800159b0 <bcache>
    800031ae:	ab3fd0ef          	jal	80000c60 <release>
}
    800031b2:	60e2                	ld	ra,24(sp)
    800031b4:	6442                	ld	s0,16(sp)
    800031b6:	64a2                	ld	s1,8(sp)
    800031b8:	6902                	ld	s2,0(sp)
    800031ba:	6105                	addi	sp,sp,32
    800031bc:	8082                	ret
    panic("brelse");
    800031be:	00004517          	auipc	a0,0x4
    800031c2:	20250513          	addi	a0,a0,514 # 800073c0 <etext+0x3c0>
    800031c6:	e18fd0ef          	jal	800007de <panic>

00000000800031ca <bpin>:

void
bpin(struct buf *b) {
    800031ca:	1101                	addi	sp,sp,-32
    800031cc:	ec06                	sd	ra,24(sp)
    800031ce:	e822                	sd	s0,16(sp)
    800031d0:	e426                	sd	s1,8(sp)
    800031d2:	1000                	addi	s0,sp,32
    800031d4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800031d6:	00012517          	auipc	a0,0x12
    800031da:	7da50513          	addi	a0,a0,2010 # 800159b0 <bcache>
    800031de:	9effd0ef          	jal	80000bcc <acquire>
  b->refcnt++;
    800031e2:	40bc                	lw	a5,64(s1)
    800031e4:	2785                	addiw	a5,a5,1
    800031e6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800031e8:	00012517          	auipc	a0,0x12
    800031ec:	7c850513          	addi	a0,a0,1992 # 800159b0 <bcache>
    800031f0:	a71fd0ef          	jal	80000c60 <release>
}
    800031f4:	60e2                	ld	ra,24(sp)
    800031f6:	6442                	ld	s0,16(sp)
    800031f8:	64a2                	ld	s1,8(sp)
    800031fa:	6105                	addi	sp,sp,32
    800031fc:	8082                	ret

00000000800031fe <bunpin>:

void
bunpin(struct buf *b) {
    800031fe:	1101                	addi	sp,sp,-32
    80003200:	ec06                	sd	ra,24(sp)
    80003202:	e822                	sd	s0,16(sp)
    80003204:	e426                	sd	s1,8(sp)
    80003206:	1000                	addi	s0,sp,32
    80003208:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000320a:	00012517          	auipc	a0,0x12
    8000320e:	7a650513          	addi	a0,a0,1958 # 800159b0 <bcache>
    80003212:	9bbfd0ef          	jal	80000bcc <acquire>
  b->refcnt--;
    80003216:	40bc                	lw	a5,64(s1)
    80003218:	37fd                	addiw	a5,a5,-1
    8000321a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000321c:	00012517          	auipc	a0,0x12
    80003220:	79450513          	addi	a0,a0,1940 # 800159b0 <bcache>
    80003224:	a3dfd0ef          	jal	80000c60 <release>
}
    80003228:	60e2                	ld	ra,24(sp)
    8000322a:	6442                	ld	s0,16(sp)
    8000322c:	64a2                	ld	s1,8(sp)
    8000322e:	6105                	addi	sp,sp,32
    80003230:	8082                	ret

0000000080003232 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003232:	1101                	addi	sp,sp,-32
    80003234:	ec06                	sd	ra,24(sp)
    80003236:	e822                	sd	s0,16(sp)
    80003238:	e426                	sd	s1,8(sp)
    8000323a:	e04a                	sd	s2,0(sp)
    8000323c:	1000                	addi	s0,sp,32
    8000323e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003240:	00d5d79b          	srliw	a5,a1,0xd
    80003244:	0001b597          	auipc	a1,0x1b
    80003248:	e485a583          	lw	a1,-440(a1) # 8001e08c <sb+0x1c>
    8000324c:	9dbd                	addw	a1,a1,a5
    8000324e:	df1ff0ef          	jal	8000303e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003252:	0074f713          	andi	a4,s1,7
    80003256:	4785                	li	a5,1
    80003258:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000325c:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000325e:	90d9                	srli	s1,s1,0x36
    80003260:	00950733          	add	a4,a0,s1
    80003264:	05874703          	lbu	a4,88(a4)
    80003268:	00e7f6b3          	and	a3,a5,a4
    8000326c:	c29d                	beqz	a3,80003292 <bfree+0x60>
    8000326e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003270:	94aa                	add	s1,s1,a0
    80003272:	fff7c793          	not	a5,a5
    80003276:	8f7d                	and	a4,a4,a5
    80003278:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000327c:	7f7000ef          	jal	80004272 <log_write>
  brelse(bp);
    80003280:	854a                	mv	a0,s2
    80003282:	ec5ff0ef          	jal	80003146 <brelse>
}
    80003286:	60e2                	ld	ra,24(sp)
    80003288:	6442                	ld	s0,16(sp)
    8000328a:	64a2                	ld	s1,8(sp)
    8000328c:	6902                	ld	s2,0(sp)
    8000328e:	6105                	addi	sp,sp,32
    80003290:	8082                	ret
    panic("freeing free block");
    80003292:	00004517          	auipc	a0,0x4
    80003296:	13650513          	addi	a0,a0,310 # 800073c8 <etext+0x3c8>
    8000329a:	d44fd0ef          	jal	800007de <panic>

000000008000329e <balloc>:
{
    8000329e:	715d                	addi	sp,sp,-80
    800032a0:	e486                	sd	ra,72(sp)
    800032a2:	e0a2                	sd	s0,64(sp)
    800032a4:	fc26                	sd	s1,56(sp)
    800032a6:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800032a8:	0001b797          	auipc	a5,0x1b
    800032ac:	dcc7a783          	lw	a5,-564(a5) # 8001e074 <sb+0x4>
    800032b0:	0e078863          	beqz	a5,800033a0 <balloc+0x102>
    800032b4:	f84a                	sd	s2,48(sp)
    800032b6:	f44e                	sd	s3,40(sp)
    800032b8:	f052                	sd	s4,32(sp)
    800032ba:	ec56                	sd	s5,24(sp)
    800032bc:	e85a                	sd	s6,16(sp)
    800032be:	e45e                	sd	s7,8(sp)
    800032c0:	e062                	sd	s8,0(sp)
    800032c2:	8baa                	mv	s7,a0
    800032c4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800032c6:	0001bb17          	auipc	s6,0x1b
    800032ca:	daab0b13          	addi	s6,s6,-598 # 8001e070 <sb>
      m = 1 << (bi % 8);
    800032ce:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032d0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800032d2:	6c09                	lui	s8,0x2
    800032d4:	a09d                	j	8000333a <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    800032d6:	97ca                	add	a5,a5,s2
    800032d8:	8e55                	or	a2,a2,a3
    800032da:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800032de:	854a                	mv	a0,s2
    800032e0:	793000ef          	jal	80004272 <log_write>
        brelse(bp);
    800032e4:	854a                	mv	a0,s2
    800032e6:	e61ff0ef          	jal	80003146 <brelse>
  bp = bread(dev, bno);
    800032ea:	85a6                	mv	a1,s1
    800032ec:	855e                	mv	a0,s7
    800032ee:	d51ff0ef          	jal	8000303e <bread>
    800032f2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800032f4:	40000613          	li	a2,1024
    800032f8:	4581                	li	a1,0
    800032fa:	05850513          	addi	a0,a0,88
    800032fe:	99ffd0ef          	jal	80000c9c <memset>
  log_write(bp);
    80003302:	854a                	mv	a0,s2
    80003304:	76f000ef          	jal	80004272 <log_write>
  brelse(bp);
    80003308:	854a                	mv	a0,s2
    8000330a:	e3dff0ef          	jal	80003146 <brelse>
}
    8000330e:	7942                	ld	s2,48(sp)
    80003310:	79a2                	ld	s3,40(sp)
    80003312:	7a02                	ld	s4,32(sp)
    80003314:	6ae2                	ld	s5,24(sp)
    80003316:	6b42                	ld	s6,16(sp)
    80003318:	6ba2                	ld	s7,8(sp)
    8000331a:	6c02                	ld	s8,0(sp)
}
    8000331c:	8526                	mv	a0,s1
    8000331e:	60a6                	ld	ra,72(sp)
    80003320:	6406                	ld	s0,64(sp)
    80003322:	74e2                	ld	s1,56(sp)
    80003324:	6161                	addi	sp,sp,80
    80003326:	8082                	ret
    brelse(bp);
    80003328:	854a                	mv	a0,s2
    8000332a:	e1dff0ef          	jal	80003146 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000332e:	015c0abb          	addw	s5,s8,s5
    80003332:	004b2783          	lw	a5,4(s6)
    80003336:	04fafe63          	bgeu	s5,a5,80003392 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    8000333a:	41fad79b          	sraiw	a5,s5,0x1f
    8000333e:	0137d79b          	srliw	a5,a5,0x13
    80003342:	015787bb          	addw	a5,a5,s5
    80003346:	40d7d79b          	sraiw	a5,a5,0xd
    8000334a:	01cb2583          	lw	a1,28(s6)
    8000334e:	9dbd                	addw	a1,a1,a5
    80003350:	855e                	mv	a0,s7
    80003352:	cedff0ef          	jal	8000303e <bread>
    80003356:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003358:	004b2503          	lw	a0,4(s6)
    8000335c:	84d6                	mv	s1,s5
    8000335e:	4701                	li	a4,0
    80003360:	fca4f4e3          	bgeu	s1,a0,80003328 <balloc+0x8a>
      m = 1 << (bi % 8);
    80003364:	00777693          	andi	a3,a4,7
    80003368:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000336c:	41f7579b          	sraiw	a5,a4,0x1f
    80003370:	01d7d79b          	srliw	a5,a5,0x1d
    80003374:	9fb9                	addw	a5,a5,a4
    80003376:	4037d79b          	sraiw	a5,a5,0x3
    8000337a:	00f90633          	add	a2,s2,a5
    8000337e:	05864603          	lbu	a2,88(a2)
    80003382:	00c6f5b3          	and	a1,a3,a2
    80003386:	d9a1                	beqz	a1,800032d6 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003388:	2705                	addiw	a4,a4,1
    8000338a:	2485                	addiw	s1,s1,1
    8000338c:	fd471ae3          	bne	a4,s4,80003360 <balloc+0xc2>
    80003390:	bf61                	j	80003328 <balloc+0x8a>
    80003392:	7942                	ld	s2,48(sp)
    80003394:	79a2                	ld	s3,40(sp)
    80003396:	7a02                	ld	s4,32(sp)
    80003398:	6ae2                	ld	s5,24(sp)
    8000339a:	6b42                	ld	s6,16(sp)
    8000339c:	6ba2                	ld	s7,8(sp)
    8000339e:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800033a0:	00004517          	auipc	a0,0x4
    800033a4:	04050513          	addi	a0,a0,64 # 800073e0 <etext+0x3e0>
    800033a8:	952fd0ef          	jal	800004fa <printf>
  return 0;
    800033ac:	4481                	li	s1,0
    800033ae:	b7bd                	j	8000331c <balloc+0x7e>

00000000800033b0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800033b0:	7179                	addi	sp,sp,-48
    800033b2:	f406                	sd	ra,40(sp)
    800033b4:	f022                	sd	s0,32(sp)
    800033b6:	ec26                	sd	s1,24(sp)
    800033b8:	e84a                	sd	s2,16(sp)
    800033ba:	e44e                	sd	s3,8(sp)
    800033bc:	1800                	addi	s0,sp,48
    800033be:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800033c0:	47ad                	li	a5,11
    800033c2:	02b7e363          	bltu	a5,a1,800033e8 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    800033c6:	02059793          	slli	a5,a1,0x20
    800033ca:	01e7d593          	srli	a1,a5,0x1e
    800033ce:	00b504b3          	add	s1,a0,a1
    800033d2:	0504a903          	lw	s2,80(s1)
    800033d6:	06091363          	bnez	s2,8000343c <bmap+0x8c>
      addr = balloc(ip->dev);
    800033da:	4108                	lw	a0,0(a0)
    800033dc:	ec3ff0ef          	jal	8000329e <balloc>
    800033e0:	892a                	mv	s2,a0
      if(addr == 0)
    800033e2:	cd29                	beqz	a0,8000343c <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    800033e4:	c8a8                	sw	a0,80(s1)
    800033e6:	a899                	j	8000343c <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    800033e8:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800033ec:	0ff00793          	li	a5,255
    800033f0:	0697e963          	bltu	a5,s1,80003462 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800033f4:	08052903          	lw	s2,128(a0)
    800033f8:	00091b63          	bnez	s2,8000340e <bmap+0x5e>
      addr = balloc(ip->dev);
    800033fc:	4108                	lw	a0,0(a0)
    800033fe:	ea1ff0ef          	jal	8000329e <balloc>
    80003402:	892a                	mv	s2,a0
      if(addr == 0)
    80003404:	cd05                	beqz	a0,8000343c <bmap+0x8c>
    80003406:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003408:	08a9a023          	sw	a0,128(s3)
    8000340c:	a011                	j	80003410 <bmap+0x60>
    8000340e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003410:	85ca                	mv	a1,s2
    80003412:	0009a503          	lw	a0,0(s3)
    80003416:	c29ff0ef          	jal	8000303e <bread>
    8000341a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000341c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003420:	02049713          	slli	a4,s1,0x20
    80003424:	01e75593          	srli	a1,a4,0x1e
    80003428:	00b784b3          	add	s1,a5,a1
    8000342c:	0004a903          	lw	s2,0(s1)
    80003430:	00090e63          	beqz	s2,8000344c <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003434:	8552                	mv	a0,s4
    80003436:	d11ff0ef          	jal	80003146 <brelse>
    return addr;
    8000343a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000343c:	854a                	mv	a0,s2
    8000343e:	70a2                	ld	ra,40(sp)
    80003440:	7402                	ld	s0,32(sp)
    80003442:	64e2                	ld	s1,24(sp)
    80003444:	6942                	ld	s2,16(sp)
    80003446:	69a2                	ld	s3,8(sp)
    80003448:	6145                	addi	sp,sp,48
    8000344a:	8082                	ret
      addr = balloc(ip->dev);
    8000344c:	0009a503          	lw	a0,0(s3)
    80003450:	e4fff0ef          	jal	8000329e <balloc>
    80003454:	892a                	mv	s2,a0
      if(addr){
    80003456:	dd79                	beqz	a0,80003434 <bmap+0x84>
        a[bn] = addr;
    80003458:	c088                	sw	a0,0(s1)
        log_write(bp);
    8000345a:	8552                	mv	a0,s4
    8000345c:	617000ef          	jal	80004272 <log_write>
    80003460:	bfd1                	j	80003434 <bmap+0x84>
    80003462:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003464:	00004517          	auipc	a0,0x4
    80003468:	f9450513          	addi	a0,a0,-108 # 800073f8 <etext+0x3f8>
    8000346c:	b72fd0ef          	jal	800007de <panic>

0000000080003470 <iget>:
{
    80003470:	7179                	addi	sp,sp,-48
    80003472:	f406                	sd	ra,40(sp)
    80003474:	f022                	sd	s0,32(sp)
    80003476:	ec26                	sd	s1,24(sp)
    80003478:	e84a                	sd	s2,16(sp)
    8000347a:	e44e                	sd	s3,8(sp)
    8000347c:	e052                	sd	s4,0(sp)
    8000347e:	1800                	addi	s0,sp,48
    80003480:	89aa                	mv	s3,a0
    80003482:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003484:	0001b517          	auipc	a0,0x1b
    80003488:	c0c50513          	addi	a0,a0,-1012 # 8001e090 <itable>
    8000348c:	f40fd0ef          	jal	80000bcc <acquire>
  empty = 0;
    80003490:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003492:	0001b497          	auipc	s1,0x1b
    80003496:	c1648493          	addi	s1,s1,-1002 # 8001e0a8 <itable+0x18>
    8000349a:	0001c697          	auipc	a3,0x1c
    8000349e:	69e68693          	addi	a3,a3,1694 # 8001fb38 <log>
    800034a2:	a039                	j	800034b0 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034a4:	02090963          	beqz	s2,800034d6 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800034a8:	08848493          	addi	s1,s1,136
    800034ac:	02d48863          	beq	s1,a3,800034dc <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800034b0:	449c                	lw	a5,8(s1)
    800034b2:	fef059e3          	blez	a5,800034a4 <iget+0x34>
    800034b6:	4098                	lw	a4,0(s1)
    800034b8:	ff3716e3          	bne	a4,s3,800034a4 <iget+0x34>
    800034bc:	40d8                	lw	a4,4(s1)
    800034be:	ff4713e3          	bne	a4,s4,800034a4 <iget+0x34>
      ip->ref++;
    800034c2:	2785                	addiw	a5,a5,1
    800034c4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800034c6:	0001b517          	auipc	a0,0x1b
    800034ca:	bca50513          	addi	a0,a0,-1078 # 8001e090 <itable>
    800034ce:	f92fd0ef          	jal	80000c60 <release>
      return ip;
    800034d2:	8926                	mv	s2,s1
    800034d4:	a02d                	j	800034fe <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034d6:	fbe9                	bnez	a5,800034a8 <iget+0x38>
      empty = ip;
    800034d8:	8926                	mv	s2,s1
    800034da:	b7f9                	j	800034a8 <iget+0x38>
  if(empty == 0)
    800034dc:	02090a63          	beqz	s2,80003510 <iget+0xa0>
  ip->dev = dev;
    800034e0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800034e4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800034e8:	4785                	li	a5,1
    800034ea:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800034ee:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800034f2:	0001b517          	auipc	a0,0x1b
    800034f6:	b9e50513          	addi	a0,a0,-1122 # 8001e090 <itable>
    800034fa:	f66fd0ef          	jal	80000c60 <release>
}
    800034fe:	854a                	mv	a0,s2
    80003500:	70a2                	ld	ra,40(sp)
    80003502:	7402                	ld	s0,32(sp)
    80003504:	64e2                	ld	s1,24(sp)
    80003506:	6942                	ld	s2,16(sp)
    80003508:	69a2                	ld	s3,8(sp)
    8000350a:	6a02                	ld	s4,0(sp)
    8000350c:	6145                	addi	sp,sp,48
    8000350e:	8082                	ret
    panic("iget: no inodes");
    80003510:	00004517          	auipc	a0,0x4
    80003514:	f0050513          	addi	a0,a0,-256 # 80007410 <etext+0x410>
    80003518:	ac6fd0ef          	jal	800007de <panic>

000000008000351c <iinit>:
{
    8000351c:	7179                	addi	sp,sp,-48
    8000351e:	f406                	sd	ra,40(sp)
    80003520:	f022                	sd	s0,32(sp)
    80003522:	ec26                	sd	s1,24(sp)
    80003524:	e84a                	sd	s2,16(sp)
    80003526:	e44e                	sd	s3,8(sp)
    80003528:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000352a:	00004597          	auipc	a1,0x4
    8000352e:	ef658593          	addi	a1,a1,-266 # 80007420 <etext+0x420>
    80003532:	0001b517          	auipc	a0,0x1b
    80003536:	b5e50513          	addi	a0,a0,-1186 # 8001e090 <itable>
    8000353a:	e0efd0ef          	jal	80000b48 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000353e:	0001b497          	auipc	s1,0x1b
    80003542:	b7a48493          	addi	s1,s1,-1158 # 8001e0b8 <itable+0x28>
    80003546:	0001c997          	auipc	s3,0x1c
    8000354a:	60298993          	addi	s3,s3,1538 # 8001fb48 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000354e:	00004917          	auipc	s2,0x4
    80003552:	eda90913          	addi	s2,s2,-294 # 80007428 <etext+0x428>
    80003556:	85ca                	mv	a1,s2
    80003558:	8526                	mv	a0,s1
    8000355a:	5db000ef          	jal	80004334 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000355e:	08848493          	addi	s1,s1,136
    80003562:	ff349ae3          	bne	s1,s3,80003556 <iinit+0x3a>
}
    80003566:	70a2                	ld	ra,40(sp)
    80003568:	7402                	ld	s0,32(sp)
    8000356a:	64e2                	ld	s1,24(sp)
    8000356c:	6942                	ld	s2,16(sp)
    8000356e:	69a2                	ld	s3,8(sp)
    80003570:	6145                	addi	sp,sp,48
    80003572:	8082                	ret

0000000080003574 <ialloc>:
{
    80003574:	7139                	addi	sp,sp,-64
    80003576:	fc06                	sd	ra,56(sp)
    80003578:	f822                	sd	s0,48(sp)
    8000357a:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000357c:	0001b717          	auipc	a4,0x1b
    80003580:	b0072703          	lw	a4,-1280(a4) # 8001e07c <sb+0xc>
    80003584:	4785                	li	a5,1
    80003586:	06e7f063          	bgeu	a5,a4,800035e6 <ialloc+0x72>
    8000358a:	f426                	sd	s1,40(sp)
    8000358c:	f04a                	sd	s2,32(sp)
    8000358e:	ec4e                	sd	s3,24(sp)
    80003590:	e852                	sd	s4,16(sp)
    80003592:	e456                	sd	s5,8(sp)
    80003594:	e05a                	sd	s6,0(sp)
    80003596:	8aaa                	mv	s5,a0
    80003598:	8b2e                	mv	s6,a1
    8000359a:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    8000359c:	0001ba17          	auipc	s4,0x1b
    800035a0:	ad4a0a13          	addi	s4,s4,-1324 # 8001e070 <sb>
    800035a4:	00495593          	srli	a1,s2,0x4
    800035a8:	018a2783          	lw	a5,24(s4)
    800035ac:	9dbd                	addw	a1,a1,a5
    800035ae:	8556                	mv	a0,s5
    800035b0:	a8fff0ef          	jal	8000303e <bread>
    800035b4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800035b6:	05850993          	addi	s3,a0,88
    800035ba:	00f97793          	andi	a5,s2,15
    800035be:	079a                	slli	a5,a5,0x6
    800035c0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800035c2:	00099783          	lh	a5,0(s3)
    800035c6:	cb9d                	beqz	a5,800035fc <ialloc+0x88>
    brelse(bp);
    800035c8:	b7fff0ef          	jal	80003146 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800035cc:	0905                	addi	s2,s2,1
    800035ce:	00ca2703          	lw	a4,12(s4)
    800035d2:	0009079b          	sext.w	a5,s2
    800035d6:	fce7e7e3          	bltu	a5,a4,800035a4 <ialloc+0x30>
    800035da:	74a2                	ld	s1,40(sp)
    800035dc:	7902                	ld	s2,32(sp)
    800035de:	69e2                	ld	s3,24(sp)
    800035e0:	6a42                	ld	s4,16(sp)
    800035e2:	6aa2                	ld	s5,8(sp)
    800035e4:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800035e6:	00004517          	auipc	a0,0x4
    800035ea:	e4a50513          	addi	a0,a0,-438 # 80007430 <etext+0x430>
    800035ee:	f0dfc0ef          	jal	800004fa <printf>
  return 0;
    800035f2:	4501                	li	a0,0
}
    800035f4:	70e2                	ld	ra,56(sp)
    800035f6:	7442                	ld	s0,48(sp)
    800035f8:	6121                	addi	sp,sp,64
    800035fa:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800035fc:	04000613          	li	a2,64
    80003600:	4581                	li	a1,0
    80003602:	854e                	mv	a0,s3
    80003604:	e98fd0ef          	jal	80000c9c <memset>
      dip->type = type;
    80003608:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000360c:	8526                	mv	a0,s1
    8000360e:	465000ef          	jal	80004272 <log_write>
      brelse(bp);
    80003612:	8526                	mv	a0,s1
    80003614:	b33ff0ef          	jal	80003146 <brelse>
      return iget(dev, inum);
    80003618:	0009059b          	sext.w	a1,s2
    8000361c:	8556                	mv	a0,s5
    8000361e:	e53ff0ef          	jal	80003470 <iget>
    80003622:	74a2                	ld	s1,40(sp)
    80003624:	7902                	ld	s2,32(sp)
    80003626:	69e2                	ld	s3,24(sp)
    80003628:	6a42                	ld	s4,16(sp)
    8000362a:	6aa2                	ld	s5,8(sp)
    8000362c:	6b02                	ld	s6,0(sp)
    8000362e:	b7d9                	j	800035f4 <ialloc+0x80>

0000000080003630 <iupdate>:
{
    80003630:	1101                	addi	sp,sp,-32
    80003632:	ec06                	sd	ra,24(sp)
    80003634:	e822                	sd	s0,16(sp)
    80003636:	e426                	sd	s1,8(sp)
    80003638:	e04a                	sd	s2,0(sp)
    8000363a:	1000                	addi	s0,sp,32
    8000363c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000363e:	415c                	lw	a5,4(a0)
    80003640:	0047d79b          	srliw	a5,a5,0x4
    80003644:	0001b597          	auipc	a1,0x1b
    80003648:	a445a583          	lw	a1,-1468(a1) # 8001e088 <sb+0x18>
    8000364c:	9dbd                	addw	a1,a1,a5
    8000364e:	4108                	lw	a0,0(a0)
    80003650:	9efff0ef          	jal	8000303e <bread>
    80003654:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003656:	05850793          	addi	a5,a0,88
    8000365a:	40d8                	lw	a4,4(s1)
    8000365c:	8b3d                	andi	a4,a4,15
    8000365e:	071a                	slli	a4,a4,0x6
    80003660:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003662:	04449703          	lh	a4,68(s1)
    80003666:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000366a:	04649703          	lh	a4,70(s1)
    8000366e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003672:	04849703          	lh	a4,72(s1)
    80003676:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000367a:	04a49703          	lh	a4,74(s1)
    8000367e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003682:	44f8                	lw	a4,76(s1)
    80003684:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003686:	03400613          	li	a2,52
    8000368a:	05048593          	addi	a1,s1,80
    8000368e:	00c78513          	addi	a0,a5,12
    80003692:	e6efd0ef          	jal	80000d00 <memmove>
  log_write(bp);
    80003696:	854a                	mv	a0,s2
    80003698:	3db000ef          	jal	80004272 <log_write>
  brelse(bp);
    8000369c:	854a                	mv	a0,s2
    8000369e:	aa9ff0ef          	jal	80003146 <brelse>
}
    800036a2:	60e2                	ld	ra,24(sp)
    800036a4:	6442                	ld	s0,16(sp)
    800036a6:	64a2                	ld	s1,8(sp)
    800036a8:	6902                	ld	s2,0(sp)
    800036aa:	6105                	addi	sp,sp,32
    800036ac:	8082                	ret

00000000800036ae <idup>:
{
    800036ae:	1101                	addi	sp,sp,-32
    800036b0:	ec06                	sd	ra,24(sp)
    800036b2:	e822                	sd	s0,16(sp)
    800036b4:	e426                	sd	s1,8(sp)
    800036b6:	1000                	addi	s0,sp,32
    800036b8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800036ba:	0001b517          	auipc	a0,0x1b
    800036be:	9d650513          	addi	a0,a0,-1578 # 8001e090 <itable>
    800036c2:	d0afd0ef          	jal	80000bcc <acquire>
  ip->ref++;
    800036c6:	449c                	lw	a5,8(s1)
    800036c8:	2785                	addiw	a5,a5,1
    800036ca:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800036cc:	0001b517          	auipc	a0,0x1b
    800036d0:	9c450513          	addi	a0,a0,-1596 # 8001e090 <itable>
    800036d4:	d8cfd0ef          	jal	80000c60 <release>
}
    800036d8:	8526                	mv	a0,s1
    800036da:	60e2                	ld	ra,24(sp)
    800036dc:	6442                	ld	s0,16(sp)
    800036de:	64a2                	ld	s1,8(sp)
    800036e0:	6105                	addi	sp,sp,32
    800036e2:	8082                	ret

00000000800036e4 <ilock>:
{
    800036e4:	1101                	addi	sp,sp,-32
    800036e6:	ec06                	sd	ra,24(sp)
    800036e8:	e822                	sd	s0,16(sp)
    800036ea:	e426                	sd	s1,8(sp)
    800036ec:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800036ee:	cd19                	beqz	a0,8000370c <ilock+0x28>
    800036f0:	84aa                	mv	s1,a0
    800036f2:	451c                	lw	a5,8(a0)
    800036f4:	00f05c63          	blez	a5,8000370c <ilock+0x28>
  acquiresleep(&ip->lock);
    800036f8:	0541                	addi	a0,a0,16
    800036fa:	471000ef          	jal	8000436a <acquiresleep>
  if(ip->valid == 0){
    800036fe:	40bc                	lw	a5,64(s1)
    80003700:	cf89                	beqz	a5,8000371a <ilock+0x36>
}
    80003702:	60e2                	ld	ra,24(sp)
    80003704:	6442                	ld	s0,16(sp)
    80003706:	64a2                	ld	s1,8(sp)
    80003708:	6105                	addi	sp,sp,32
    8000370a:	8082                	ret
    8000370c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000370e:	00004517          	auipc	a0,0x4
    80003712:	d3a50513          	addi	a0,a0,-710 # 80007448 <etext+0x448>
    80003716:	8c8fd0ef          	jal	800007de <panic>
    8000371a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000371c:	40dc                	lw	a5,4(s1)
    8000371e:	0047d79b          	srliw	a5,a5,0x4
    80003722:	0001b597          	auipc	a1,0x1b
    80003726:	9665a583          	lw	a1,-1690(a1) # 8001e088 <sb+0x18>
    8000372a:	9dbd                	addw	a1,a1,a5
    8000372c:	4088                	lw	a0,0(s1)
    8000372e:	911ff0ef          	jal	8000303e <bread>
    80003732:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003734:	05850593          	addi	a1,a0,88
    80003738:	40dc                	lw	a5,4(s1)
    8000373a:	8bbd                	andi	a5,a5,15
    8000373c:	079a                	slli	a5,a5,0x6
    8000373e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003740:	00059783          	lh	a5,0(a1)
    80003744:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003748:	00259783          	lh	a5,2(a1)
    8000374c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003750:	00459783          	lh	a5,4(a1)
    80003754:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003758:	00659783          	lh	a5,6(a1)
    8000375c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003760:	459c                	lw	a5,8(a1)
    80003762:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003764:	03400613          	li	a2,52
    80003768:	05b1                	addi	a1,a1,12
    8000376a:	05048513          	addi	a0,s1,80
    8000376e:	d92fd0ef          	jal	80000d00 <memmove>
    brelse(bp);
    80003772:	854a                	mv	a0,s2
    80003774:	9d3ff0ef          	jal	80003146 <brelse>
    ip->valid = 1;
    80003778:	4785                	li	a5,1
    8000377a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000377c:	04449783          	lh	a5,68(s1)
    80003780:	c399                	beqz	a5,80003786 <ilock+0xa2>
    80003782:	6902                	ld	s2,0(sp)
    80003784:	bfbd                	j	80003702 <ilock+0x1e>
      panic("ilock: no type");
    80003786:	00004517          	auipc	a0,0x4
    8000378a:	cca50513          	addi	a0,a0,-822 # 80007450 <etext+0x450>
    8000378e:	850fd0ef          	jal	800007de <panic>

0000000080003792 <iunlock>:
{
    80003792:	1101                	addi	sp,sp,-32
    80003794:	ec06                	sd	ra,24(sp)
    80003796:	e822                	sd	s0,16(sp)
    80003798:	e426                	sd	s1,8(sp)
    8000379a:	e04a                	sd	s2,0(sp)
    8000379c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000379e:	c505                	beqz	a0,800037c6 <iunlock+0x34>
    800037a0:	84aa                	mv	s1,a0
    800037a2:	01050913          	addi	s2,a0,16
    800037a6:	854a                	mv	a0,s2
    800037a8:	441000ef          	jal	800043e8 <holdingsleep>
    800037ac:	cd09                	beqz	a0,800037c6 <iunlock+0x34>
    800037ae:	449c                	lw	a5,8(s1)
    800037b0:	00f05b63          	blez	a5,800037c6 <iunlock+0x34>
  releasesleep(&ip->lock);
    800037b4:	854a                	mv	a0,s2
    800037b6:	3fb000ef          	jal	800043b0 <releasesleep>
}
    800037ba:	60e2                	ld	ra,24(sp)
    800037bc:	6442                	ld	s0,16(sp)
    800037be:	64a2                	ld	s1,8(sp)
    800037c0:	6902                	ld	s2,0(sp)
    800037c2:	6105                	addi	sp,sp,32
    800037c4:	8082                	ret
    panic("iunlock");
    800037c6:	00004517          	auipc	a0,0x4
    800037ca:	c9a50513          	addi	a0,a0,-870 # 80007460 <etext+0x460>
    800037ce:	810fd0ef          	jal	800007de <panic>

00000000800037d2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800037d2:	7179                	addi	sp,sp,-48
    800037d4:	f406                	sd	ra,40(sp)
    800037d6:	f022                	sd	s0,32(sp)
    800037d8:	ec26                	sd	s1,24(sp)
    800037da:	e84a                	sd	s2,16(sp)
    800037dc:	e44e                	sd	s3,8(sp)
    800037de:	1800                	addi	s0,sp,48
    800037e0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800037e2:	05050493          	addi	s1,a0,80
    800037e6:	08050913          	addi	s2,a0,128
    800037ea:	a021                	j	800037f2 <itrunc+0x20>
    800037ec:	0491                	addi	s1,s1,4
    800037ee:	01248b63          	beq	s1,s2,80003804 <itrunc+0x32>
    if(ip->addrs[i]){
    800037f2:	408c                	lw	a1,0(s1)
    800037f4:	dde5                	beqz	a1,800037ec <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800037f6:	0009a503          	lw	a0,0(s3)
    800037fa:	a39ff0ef          	jal	80003232 <bfree>
      ip->addrs[i] = 0;
    800037fe:	0004a023          	sw	zero,0(s1)
    80003802:	b7ed                	j	800037ec <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003804:	0809a583          	lw	a1,128(s3)
    80003808:	ed89                	bnez	a1,80003822 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000380a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000380e:	854e                	mv	a0,s3
    80003810:	e21ff0ef          	jal	80003630 <iupdate>
}
    80003814:	70a2                	ld	ra,40(sp)
    80003816:	7402                	ld	s0,32(sp)
    80003818:	64e2                	ld	s1,24(sp)
    8000381a:	6942                	ld	s2,16(sp)
    8000381c:	69a2                	ld	s3,8(sp)
    8000381e:	6145                	addi	sp,sp,48
    80003820:	8082                	ret
    80003822:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003824:	0009a503          	lw	a0,0(s3)
    80003828:	817ff0ef          	jal	8000303e <bread>
    8000382c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000382e:	05850493          	addi	s1,a0,88
    80003832:	45850913          	addi	s2,a0,1112
    80003836:	a021                	j	8000383e <itrunc+0x6c>
    80003838:	0491                	addi	s1,s1,4
    8000383a:	01248963          	beq	s1,s2,8000384c <itrunc+0x7a>
      if(a[j])
    8000383e:	408c                	lw	a1,0(s1)
    80003840:	dde5                	beqz	a1,80003838 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003842:	0009a503          	lw	a0,0(s3)
    80003846:	9edff0ef          	jal	80003232 <bfree>
    8000384a:	b7fd                	j	80003838 <itrunc+0x66>
    brelse(bp);
    8000384c:	8552                	mv	a0,s4
    8000384e:	8f9ff0ef          	jal	80003146 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003852:	0809a583          	lw	a1,128(s3)
    80003856:	0009a503          	lw	a0,0(s3)
    8000385a:	9d9ff0ef          	jal	80003232 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000385e:	0809a023          	sw	zero,128(s3)
    80003862:	6a02                	ld	s4,0(sp)
    80003864:	b75d                	j	8000380a <itrunc+0x38>

0000000080003866 <iput>:
{
    80003866:	1101                	addi	sp,sp,-32
    80003868:	ec06                	sd	ra,24(sp)
    8000386a:	e822                	sd	s0,16(sp)
    8000386c:	e426                	sd	s1,8(sp)
    8000386e:	1000                	addi	s0,sp,32
    80003870:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003872:	0001b517          	auipc	a0,0x1b
    80003876:	81e50513          	addi	a0,a0,-2018 # 8001e090 <itable>
    8000387a:	b52fd0ef          	jal	80000bcc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000387e:	4498                	lw	a4,8(s1)
    80003880:	4785                	li	a5,1
    80003882:	02f70063          	beq	a4,a5,800038a2 <iput+0x3c>
  ip->ref--;
    80003886:	449c                	lw	a5,8(s1)
    80003888:	37fd                	addiw	a5,a5,-1
    8000388a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000388c:	0001b517          	auipc	a0,0x1b
    80003890:	80450513          	addi	a0,a0,-2044 # 8001e090 <itable>
    80003894:	bccfd0ef          	jal	80000c60 <release>
}
    80003898:	60e2                	ld	ra,24(sp)
    8000389a:	6442                	ld	s0,16(sp)
    8000389c:	64a2                	ld	s1,8(sp)
    8000389e:	6105                	addi	sp,sp,32
    800038a0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800038a2:	40bc                	lw	a5,64(s1)
    800038a4:	d3ed                	beqz	a5,80003886 <iput+0x20>
    800038a6:	04a49783          	lh	a5,74(s1)
    800038aa:	fff1                	bnez	a5,80003886 <iput+0x20>
    800038ac:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800038ae:	01048913          	addi	s2,s1,16
    800038b2:	854a                	mv	a0,s2
    800038b4:	2b7000ef          	jal	8000436a <acquiresleep>
    release(&itable.lock);
    800038b8:	0001a517          	auipc	a0,0x1a
    800038bc:	7d850513          	addi	a0,a0,2008 # 8001e090 <itable>
    800038c0:	ba0fd0ef          	jal	80000c60 <release>
    itrunc(ip);
    800038c4:	8526                	mv	a0,s1
    800038c6:	f0dff0ef          	jal	800037d2 <itrunc>
    ip->type = 0;
    800038ca:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800038ce:	8526                	mv	a0,s1
    800038d0:	d61ff0ef          	jal	80003630 <iupdate>
    ip->valid = 0;
    800038d4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800038d8:	854a                	mv	a0,s2
    800038da:	2d7000ef          	jal	800043b0 <releasesleep>
    acquire(&itable.lock);
    800038de:	0001a517          	auipc	a0,0x1a
    800038e2:	7b250513          	addi	a0,a0,1970 # 8001e090 <itable>
    800038e6:	ae6fd0ef          	jal	80000bcc <acquire>
    800038ea:	6902                	ld	s2,0(sp)
    800038ec:	bf69                	j	80003886 <iput+0x20>

00000000800038ee <iunlockput>:
{
    800038ee:	1101                	addi	sp,sp,-32
    800038f0:	ec06                	sd	ra,24(sp)
    800038f2:	e822                	sd	s0,16(sp)
    800038f4:	e426                	sd	s1,8(sp)
    800038f6:	1000                	addi	s0,sp,32
    800038f8:	84aa                	mv	s1,a0
  iunlock(ip);
    800038fa:	e99ff0ef          	jal	80003792 <iunlock>
  iput(ip);
    800038fe:	8526                	mv	a0,s1
    80003900:	f67ff0ef          	jal	80003866 <iput>
}
    80003904:	60e2                	ld	ra,24(sp)
    80003906:	6442                	ld	s0,16(sp)
    80003908:	64a2                	ld	s1,8(sp)
    8000390a:	6105                	addi	sp,sp,32
    8000390c:	8082                	ret

000000008000390e <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000390e:	0001a717          	auipc	a4,0x1a
    80003912:	76e72703          	lw	a4,1902(a4) # 8001e07c <sb+0xc>
    80003916:	4785                	li	a5,1
    80003918:	0ae7fe63          	bgeu	a5,a4,800039d4 <ireclaim+0xc6>
{
    8000391c:	7139                	addi	sp,sp,-64
    8000391e:	fc06                	sd	ra,56(sp)
    80003920:	f822                	sd	s0,48(sp)
    80003922:	f426                	sd	s1,40(sp)
    80003924:	f04a                	sd	s2,32(sp)
    80003926:	ec4e                	sd	s3,24(sp)
    80003928:	e852                	sd	s4,16(sp)
    8000392a:	e456                	sd	s5,8(sp)
    8000392c:	e05a                	sd	s6,0(sp)
    8000392e:	0080                	addi	s0,sp,64
    80003930:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003932:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003934:	0001aa17          	auipc	s4,0x1a
    80003938:	73ca0a13          	addi	s4,s4,1852 # 8001e070 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    8000393c:	00004b17          	auipc	s6,0x4
    80003940:	b2cb0b13          	addi	s6,s6,-1236 # 80007468 <etext+0x468>
    80003944:	a099                	j	8000398a <ireclaim+0x7c>
    80003946:	85ce                	mv	a1,s3
    80003948:	855a                	mv	a0,s6
    8000394a:	bb1fc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    8000394e:	85ce                	mv	a1,s3
    80003950:	8556                	mv	a0,s5
    80003952:	b1fff0ef          	jal	80003470 <iget>
    80003956:	89aa                	mv	s3,a0
    brelse(bp);
    80003958:	854a                	mv	a0,s2
    8000395a:	fecff0ef          	jal	80003146 <brelse>
    if (ip) {
    8000395e:	00098f63          	beqz	s3,8000397c <ireclaim+0x6e>
      begin_op();
    80003962:	786000ef          	jal	800040e8 <begin_op>
      ilock(ip);
    80003966:	854e                	mv	a0,s3
    80003968:	d7dff0ef          	jal	800036e4 <ilock>
      iunlock(ip);
    8000396c:	854e                	mv	a0,s3
    8000396e:	e25ff0ef          	jal	80003792 <iunlock>
      iput(ip);
    80003972:	854e                	mv	a0,s3
    80003974:	ef3ff0ef          	jal	80003866 <iput>
      end_op();
    80003978:	7da000ef          	jal	80004152 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000397c:	0485                	addi	s1,s1,1
    8000397e:	00ca2703          	lw	a4,12(s4)
    80003982:	0004879b          	sext.w	a5,s1
    80003986:	02e7fd63          	bgeu	a5,a4,800039c0 <ireclaim+0xb2>
    8000398a:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8000398e:	0044d593          	srli	a1,s1,0x4
    80003992:	018a2783          	lw	a5,24(s4)
    80003996:	9dbd                	addw	a1,a1,a5
    80003998:	8556                	mv	a0,s5
    8000399a:	ea4ff0ef          	jal	8000303e <bread>
    8000399e:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800039a0:	05850793          	addi	a5,a0,88
    800039a4:	00f9f713          	andi	a4,s3,15
    800039a8:	071a                	slli	a4,a4,0x6
    800039aa:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800039ac:	00079703          	lh	a4,0(a5)
    800039b0:	c701                	beqz	a4,800039b8 <ireclaim+0xaa>
    800039b2:	00679783          	lh	a5,6(a5)
    800039b6:	dbc1                	beqz	a5,80003946 <ireclaim+0x38>
    brelse(bp);
    800039b8:	854a                	mv	a0,s2
    800039ba:	f8cff0ef          	jal	80003146 <brelse>
    if (ip) {
    800039be:	bf7d                	j	8000397c <ireclaim+0x6e>
}
    800039c0:	70e2                	ld	ra,56(sp)
    800039c2:	7442                	ld	s0,48(sp)
    800039c4:	74a2                	ld	s1,40(sp)
    800039c6:	7902                	ld	s2,32(sp)
    800039c8:	69e2                	ld	s3,24(sp)
    800039ca:	6a42                	ld	s4,16(sp)
    800039cc:	6aa2                	ld	s5,8(sp)
    800039ce:	6b02                	ld	s6,0(sp)
    800039d0:	6121                	addi	sp,sp,64
    800039d2:	8082                	ret
    800039d4:	8082                	ret

00000000800039d6 <fsinit>:
fsinit(int dev) {
    800039d6:	7179                	addi	sp,sp,-48
    800039d8:	f406                	sd	ra,40(sp)
    800039da:	f022                	sd	s0,32(sp)
    800039dc:	ec26                	sd	s1,24(sp)
    800039de:	e84a                	sd	s2,16(sp)
    800039e0:	e44e                	sd	s3,8(sp)
    800039e2:	1800                	addi	s0,sp,48
    800039e4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800039e6:	4585                	li	a1,1
    800039e8:	e56ff0ef          	jal	8000303e <bread>
    800039ec:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800039ee:	0001a997          	auipc	s3,0x1a
    800039f2:	68298993          	addi	s3,s3,1666 # 8001e070 <sb>
    800039f6:	02000613          	li	a2,32
    800039fa:	05850593          	addi	a1,a0,88
    800039fe:	854e                	mv	a0,s3
    80003a00:	b00fd0ef          	jal	80000d00 <memmove>
  brelse(bp);
    80003a04:	8526                	mv	a0,s1
    80003a06:	f40ff0ef          	jal	80003146 <brelse>
  if(sb.magic != FSMAGIC)
    80003a0a:	0009a703          	lw	a4,0(s3)
    80003a0e:	102037b7          	lui	a5,0x10203
    80003a12:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003a16:	02f71363          	bne	a4,a5,80003a3c <fsinit+0x66>
  initlog(dev, &sb);
    80003a1a:	0001a597          	auipc	a1,0x1a
    80003a1e:	65658593          	addi	a1,a1,1622 # 8001e070 <sb>
    80003a22:	854a                	mv	a0,s2
    80003a24:	646000ef          	jal	8000406a <initlog>
  ireclaim(dev);
    80003a28:	854a                	mv	a0,s2
    80003a2a:	ee5ff0ef          	jal	8000390e <ireclaim>
}
    80003a2e:	70a2                	ld	ra,40(sp)
    80003a30:	7402                	ld	s0,32(sp)
    80003a32:	64e2                	ld	s1,24(sp)
    80003a34:	6942                	ld	s2,16(sp)
    80003a36:	69a2                	ld	s3,8(sp)
    80003a38:	6145                	addi	sp,sp,48
    80003a3a:	8082                	ret
    panic("invalid file system");
    80003a3c:	00004517          	auipc	a0,0x4
    80003a40:	a4c50513          	addi	a0,a0,-1460 # 80007488 <etext+0x488>
    80003a44:	d9bfc0ef          	jal	800007de <panic>

0000000080003a48 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003a48:	1141                	addi	sp,sp,-16
    80003a4a:	e406                	sd	ra,8(sp)
    80003a4c:	e022                	sd	s0,0(sp)
    80003a4e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003a50:	411c                	lw	a5,0(a0)
    80003a52:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a54:	415c                	lw	a5,4(a0)
    80003a56:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a58:	04451783          	lh	a5,68(a0)
    80003a5c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a60:	04a51783          	lh	a5,74(a0)
    80003a64:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a68:	04c56783          	lwu	a5,76(a0)
    80003a6c:	e99c                	sd	a5,16(a1)
}
    80003a6e:	60a2                	ld	ra,8(sp)
    80003a70:	6402                	ld	s0,0(sp)
    80003a72:	0141                	addi	sp,sp,16
    80003a74:	8082                	ret

0000000080003a76 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a76:	457c                	lw	a5,76(a0)
    80003a78:	0ed7e663          	bltu	a5,a3,80003b64 <readi+0xee>
{
    80003a7c:	7159                	addi	sp,sp,-112
    80003a7e:	f486                	sd	ra,104(sp)
    80003a80:	f0a2                	sd	s0,96(sp)
    80003a82:	eca6                	sd	s1,88(sp)
    80003a84:	e0d2                	sd	s4,64(sp)
    80003a86:	fc56                	sd	s5,56(sp)
    80003a88:	f85a                	sd	s6,48(sp)
    80003a8a:	f45e                	sd	s7,40(sp)
    80003a8c:	1880                	addi	s0,sp,112
    80003a8e:	8b2a                	mv	s6,a0
    80003a90:	8bae                	mv	s7,a1
    80003a92:	8a32                	mv	s4,a2
    80003a94:	84b6                	mv	s1,a3
    80003a96:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003a98:	9f35                	addw	a4,a4,a3
    return 0;
    80003a9a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a9c:	0ad76b63          	bltu	a4,a3,80003b52 <readi+0xdc>
    80003aa0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003aa2:	00e7f463          	bgeu	a5,a4,80003aaa <readi+0x34>
    n = ip->size - off;
    80003aa6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003aaa:	080a8b63          	beqz	s5,80003b40 <readi+0xca>
    80003aae:	e8ca                	sd	s2,80(sp)
    80003ab0:	f062                	sd	s8,32(sp)
    80003ab2:	ec66                	sd	s9,24(sp)
    80003ab4:	e86a                	sd	s10,16(sp)
    80003ab6:	e46e                	sd	s11,8(sp)
    80003ab8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003aba:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003abe:	5c7d                	li	s8,-1
    80003ac0:	a80d                	j	80003af2 <readi+0x7c>
    80003ac2:	020d1d93          	slli	s11,s10,0x20
    80003ac6:	020ddd93          	srli	s11,s11,0x20
    80003aca:	05890613          	addi	a2,s2,88
    80003ace:	86ee                	mv	a3,s11
    80003ad0:	963e                	add	a2,a2,a5
    80003ad2:	85d2                	mv	a1,s4
    80003ad4:	855e                	mv	a0,s7
    80003ad6:	931fe0ef          	jal	80002406 <either_copyout>
    80003ada:	05850363          	beq	a0,s8,80003b20 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ade:	854a                	mv	a0,s2
    80003ae0:	e66ff0ef          	jal	80003146 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ae4:	013d09bb          	addw	s3,s10,s3
    80003ae8:	009d04bb          	addw	s1,s10,s1
    80003aec:	9a6e                	add	s4,s4,s11
    80003aee:	0559f363          	bgeu	s3,s5,80003b34 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003af2:	00a4d59b          	srliw	a1,s1,0xa
    80003af6:	855a                	mv	a0,s6
    80003af8:	8b9ff0ef          	jal	800033b0 <bmap>
    80003afc:	85aa                	mv	a1,a0
    if(addr == 0)
    80003afe:	c139                	beqz	a0,80003b44 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003b00:	000b2503          	lw	a0,0(s6)
    80003b04:	d3aff0ef          	jal	8000303e <bread>
    80003b08:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b0a:	3ff4f793          	andi	a5,s1,1023
    80003b0e:	40fc873b          	subw	a4,s9,a5
    80003b12:	413a86bb          	subw	a3,s5,s3
    80003b16:	8d3a                	mv	s10,a4
    80003b18:	fae6f5e3          	bgeu	a3,a4,80003ac2 <readi+0x4c>
    80003b1c:	8d36                	mv	s10,a3
    80003b1e:	b755                	j	80003ac2 <readi+0x4c>
      brelse(bp);
    80003b20:	854a                	mv	a0,s2
    80003b22:	e24ff0ef          	jal	80003146 <brelse>
      tot = -1;
    80003b26:	59fd                	li	s3,-1
      break;
    80003b28:	6946                	ld	s2,80(sp)
    80003b2a:	7c02                	ld	s8,32(sp)
    80003b2c:	6ce2                	ld	s9,24(sp)
    80003b2e:	6d42                	ld	s10,16(sp)
    80003b30:	6da2                	ld	s11,8(sp)
    80003b32:	a831                	j	80003b4e <readi+0xd8>
    80003b34:	6946                	ld	s2,80(sp)
    80003b36:	7c02                	ld	s8,32(sp)
    80003b38:	6ce2                	ld	s9,24(sp)
    80003b3a:	6d42                	ld	s10,16(sp)
    80003b3c:	6da2                	ld	s11,8(sp)
    80003b3e:	a801                	j	80003b4e <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b40:	89d6                	mv	s3,s5
    80003b42:	a031                	j	80003b4e <readi+0xd8>
    80003b44:	6946                	ld	s2,80(sp)
    80003b46:	7c02                	ld	s8,32(sp)
    80003b48:	6ce2                	ld	s9,24(sp)
    80003b4a:	6d42                	ld	s10,16(sp)
    80003b4c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003b4e:	854e                	mv	a0,s3
    80003b50:	69a6                	ld	s3,72(sp)
}
    80003b52:	70a6                	ld	ra,104(sp)
    80003b54:	7406                	ld	s0,96(sp)
    80003b56:	64e6                	ld	s1,88(sp)
    80003b58:	6a06                	ld	s4,64(sp)
    80003b5a:	7ae2                	ld	s5,56(sp)
    80003b5c:	7b42                	ld	s6,48(sp)
    80003b5e:	7ba2                	ld	s7,40(sp)
    80003b60:	6165                	addi	sp,sp,112
    80003b62:	8082                	ret
    return 0;
    80003b64:	4501                	li	a0,0
}
    80003b66:	8082                	ret

0000000080003b68 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b68:	457c                	lw	a5,76(a0)
    80003b6a:	0ed7eb63          	bltu	a5,a3,80003c60 <writei+0xf8>
{
    80003b6e:	7159                	addi	sp,sp,-112
    80003b70:	f486                	sd	ra,104(sp)
    80003b72:	f0a2                	sd	s0,96(sp)
    80003b74:	e8ca                	sd	s2,80(sp)
    80003b76:	e0d2                	sd	s4,64(sp)
    80003b78:	fc56                	sd	s5,56(sp)
    80003b7a:	f85a                	sd	s6,48(sp)
    80003b7c:	f45e                	sd	s7,40(sp)
    80003b7e:	1880                	addi	s0,sp,112
    80003b80:	8aaa                	mv	s5,a0
    80003b82:	8bae                	mv	s7,a1
    80003b84:	8a32                	mv	s4,a2
    80003b86:	8936                	mv	s2,a3
    80003b88:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b8a:	00e687bb          	addw	a5,a3,a4
    80003b8e:	0cd7eb63          	bltu	a5,a3,80003c64 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b92:	00043737          	lui	a4,0x43
    80003b96:	0cf76963          	bltu	a4,a5,80003c68 <writei+0x100>
    80003b9a:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b9c:	0a0b0a63          	beqz	s6,80003c50 <writei+0xe8>
    80003ba0:	eca6                	sd	s1,88(sp)
    80003ba2:	f062                	sd	s8,32(sp)
    80003ba4:	ec66                	sd	s9,24(sp)
    80003ba6:	e86a                	sd	s10,16(sp)
    80003ba8:	e46e                	sd	s11,8(sp)
    80003baa:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bac:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003bb0:	5c7d                	li	s8,-1
    80003bb2:	a825                	j	80003bea <writei+0x82>
    80003bb4:	020d1d93          	slli	s11,s10,0x20
    80003bb8:	020ddd93          	srli	s11,s11,0x20
    80003bbc:	05848513          	addi	a0,s1,88
    80003bc0:	86ee                	mv	a3,s11
    80003bc2:	8652                	mv	a2,s4
    80003bc4:	85de                	mv	a1,s7
    80003bc6:	953e                	add	a0,a0,a5
    80003bc8:	889fe0ef          	jal	80002450 <either_copyin>
    80003bcc:	05850663          	beq	a0,s8,80003c18 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003bd0:	8526                	mv	a0,s1
    80003bd2:	6a0000ef          	jal	80004272 <log_write>
    brelse(bp);
    80003bd6:	8526                	mv	a0,s1
    80003bd8:	d6eff0ef          	jal	80003146 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bdc:	013d09bb          	addw	s3,s10,s3
    80003be0:	012d093b          	addw	s2,s10,s2
    80003be4:	9a6e                	add	s4,s4,s11
    80003be6:	0369fc63          	bgeu	s3,s6,80003c1e <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80003bea:	00a9559b          	srliw	a1,s2,0xa
    80003bee:	8556                	mv	a0,s5
    80003bf0:	fc0ff0ef          	jal	800033b0 <bmap>
    80003bf4:	85aa                	mv	a1,a0
    if(addr == 0)
    80003bf6:	c505                	beqz	a0,80003c1e <writei+0xb6>
    bp = bread(ip->dev, addr);
    80003bf8:	000aa503          	lw	a0,0(s5)
    80003bfc:	c42ff0ef          	jal	8000303e <bread>
    80003c00:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c02:	3ff97793          	andi	a5,s2,1023
    80003c06:	40fc873b          	subw	a4,s9,a5
    80003c0a:	413b06bb          	subw	a3,s6,s3
    80003c0e:	8d3a                	mv	s10,a4
    80003c10:	fae6f2e3          	bgeu	a3,a4,80003bb4 <writei+0x4c>
    80003c14:	8d36                	mv	s10,a3
    80003c16:	bf79                	j	80003bb4 <writei+0x4c>
      brelse(bp);
    80003c18:	8526                	mv	a0,s1
    80003c1a:	d2cff0ef          	jal	80003146 <brelse>
  }

  if(off > ip->size)
    80003c1e:	04caa783          	lw	a5,76(s5)
    80003c22:	0327f963          	bgeu	a5,s2,80003c54 <writei+0xec>
    ip->size = off;
    80003c26:	052aa623          	sw	s2,76(s5)
    80003c2a:	64e6                	ld	s1,88(sp)
    80003c2c:	7c02                	ld	s8,32(sp)
    80003c2e:	6ce2                	ld	s9,24(sp)
    80003c30:	6d42                	ld	s10,16(sp)
    80003c32:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003c34:	8556                	mv	a0,s5
    80003c36:	9fbff0ef          	jal	80003630 <iupdate>

  return tot;
    80003c3a:	854e                	mv	a0,s3
    80003c3c:	69a6                	ld	s3,72(sp)
}
    80003c3e:	70a6                	ld	ra,104(sp)
    80003c40:	7406                	ld	s0,96(sp)
    80003c42:	6946                	ld	s2,80(sp)
    80003c44:	6a06                	ld	s4,64(sp)
    80003c46:	7ae2                	ld	s5,56(sp)
    80003c48:	7b42                	ld	s6,48(sp)
    80003c4a:	7ba2                	ld	s7,40(sp)
    80003c4c:	6165                	addi	sp,sp,112
    80003c4e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c50:	89da                	mv	s3,s6
    80003c52:	b7cd                	j	80003c34 <writei+0xcc>
    80003c54:	64e6                	ld	s1,88(sp)
    80003c56:	7c02                	ld	s8,32(sp)
    80003c58:	6ce2                	ld	s9,24(sp)
    80003c5a:	6d42                	ld	s10,16(sp)
    80003c5c:	6da2                	ld	s11,8(sp)
    80003c5e:	bfd9                	j	80003c34 <writei+0xcc>
    return -1;
    80003c60:	557d                	li	a0,-1
}
    80003c62:	8082                	ret
    return -1;
    80003c64:	557d                	li	a0,-1
    80003c66:	bfe1                	j	80003c3e <writei+0xd6>
    return -1;
    80003c68:	557d                	li	a0,-1
    80003c6a:	bfd1                	j	80003c3e <writei+0xd6>

0000000080003c6c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c6c:	1141                	addi	sp,sp,-16
    80003c6e:	e406                	sd	ra,8(sp)
    80003c70:	e022                	sd	s0,0(sp)
    80003c72:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c74:	4639                	li	a2,14
    80003c76:	8fefd0ef          	jal	80000d74 <strncmp>
}
    80003c7a:	60a2                	ld	ra,8(sp)
    80003c7c:	6402                	ld	s0,0(sp)
    80003c7e:	0141                	addi	sp,sp,16
    80003c80:	8082                	ret

0000000080003c82 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c82:	711d                	addi	sp,sp,-96
    80003c84:	ec86                	sd	ra,88(sp)
    80003c86:	e8a2                	sd	s0,80(sp)
    80003c88:	e4a6                	sd	s1,72(sp)
    80003c8a:	e0ca                	sd	s2,64(sp)
    80003c8c:	fc4e                	sd	s3,56(sp)
    80003c8e:	f852                	sd	s4,48(sp)
    80003c90:	f456                	sd	s5,40(sp)
    80003c92:	f05a                	sd	s6,32(sp)
    80003c94:	ec5e                	sd	s7,24(sp)
    80003c96:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c98:	04451703          	lh	a4,68(a0)
    80003c9c:	4785                	li	a5,1
    80003c9e:	00f71f63          	bne	a4,a5,80003cbc <dirlookup+0x3a>
    80003ca2:	892a                	mv	s2,a0
    80003ca4:	8aae                	mv	s5,a1
    80003ca6:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ca8:	457c                	lw	a5,76(a0)
    80003caa:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cac:	fa040a13          	addi	s4,s0,-96
    80003cb0:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80003cb2:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003cb6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cb8:	e39d                	bnez	a5,80003cde <dirlookup+0x5c>
    80003cba:	a8b9                	j	80003d18 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003cbc:	00003517          	auipc	a0,0x3
    80003cc0:	7e450513          	addi	a0,a0,2020 # 800074a0 <etext+0x4a0>
    80003cc4:	b1bfc0ef          	jal	800007de <panic>
      panic("dirlookup read");
    80003cc8:	00003517          	auipc	a0,0x3
    80003ccc:	7f050513          	addi	a0,a0,2032 # 800074b8 <etext+0x4b8>
    80003cd0:	b0ffc0ef          	jal	800007de <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cd4:	24c1                	addiw	s1,s1,16
    80003cd6:	04c92783          	lw	a5,76(s2)
    80003cda:	02f4fe63          	bgeu	s1,a5,80003d16 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cde:	874e                	mv	a4,s3
    80003ce0:	86a6                	mv	a3,s1
    80003ce2:	8652                	mv	a2,s4
    80003ce4:	4581                	li	a1,0
    80003ce6:	854a                	mv	a0,s2
    80003ce8:	d8fff0ef          	jal	80003a76 <readi>
    80003cec:	fd351ee3          	bne	a0,s3,80003cc8 <dirlookup+0x46>
    if(de.inum == 0)
    80003cf0:	fa045783          	lhu	a5,-96(s0)
    80003cf4:	d3e5                	beqz	a5,80003cd4 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80003cf6:	85da                	mv	a1,s6
    80003cf8:	8556                	mv	a0,s5
    80003cfa:	f73ff0ef          	jal	80003c6c <namecmp>
    80003cfe:	f979                	bnez	a0,80003cd4 <dirlookup+0x52>
      if(poff)
    80003d00:	000b8463          	beqz	s7,80003d08 <dirlookup+0x86>
        *poff = off;
    80003d04:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003d08:	fa045583          	lhu	a1,-96(s0)
    80003d0c:	00092503          	lw	a0,0(s2)
    80003d10:	f60ff0ef          	jal	80003470 <iget>
    80003d14:	a011                	j	80003d18 <dirlookup+0x96>
  return 0;
    80003d16:	4501                	li	a0,0
}
    80003d18:	60e6                	ld	ra,88(sp)
    80003d1a:	6446                	ld	s0,80(sp)
    80003d1c:	64a6                	ld	s1,72(sp)
    80003d1e:	6906                	ld	s2,64(sp)
    80003d20:	79e2                	ld	s3,56(sp)
    80003d22:	7a42                	ld	s4,48(sp)
    80003d24:	7aa2                	ld	s5,40(sp)
    80003d26:	7b02                	ld	s6,32(sp)
    80003d28:	6be2                	ld	s7,24(sp)
    80003d2a:	6125                	addi	sp,sp,96
    80003d2c:	8082                	ret

0000000080003d2e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d2e:	711d                	addi	sp,sp,-96
    80003d30:	ec86                	sd	ra,88(sp)
    80003d32:	e8a2                	sd	s0,80(sp)
    80003d34:	e4a6                	sd	s1,72(sp)
    80003d36:	e0ca                	sd	s2,64(sp)
    80003d38:	fc4e                	sd	s3,56(sp)
    80003d3a:	f852                	sd	s4,48(sp)
    80003d3c:	f456                	sd	s5,40(sp)
    80003d3e:	f05a                	sd	s6,32(sp)
    80003d40:	ec5e                	sd	s7,24(sp)
    80003d42:	e862                	sd	s8,16(sp)
    80003d44:	e466                	sd	s9,8(sp)
    80003d46:	e06a                	sd	s10,0(sp)
    80003d48:	1080                	addi	s0,sp,96
    80003d4a:	84aa                	mv	s1,a0
    80003d4c:	8b2e                	mv	s6,a1
    80003d4e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d50:	00054703          	lbu	a4,0(a0)
    80003d54:	02f00793          	li	a5,47
    80003d58:	00f70f63          	beq	a4,a5,80003d76 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d5c:	b63fd0ef          	jal	800018be <myproc>
    80003d60:	15853503          	ld	a0,344(a0)
    80003d64:	94bff0ef          	jal	800036ae <idup>
    80003d68:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d6a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d6e:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003d70:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d72:	4b85                	li	s7,1
    80003d74:	a879                	j	80003e12 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003d76:	4585                	li	a1,1
    80003d78:	852e                	mv	a0,a1
    80003d7a:	ef6ff0ef          	jal	80003470 <iget>
    80003d7e:	8a2a                	mv	s4,a0
    80003d80:	b7ed                	j	80003d6a <namex+0x3c>
      iunlockput(ip);
    80003d82:	8552                	mv	a0,s4
    80003d84:	b6bff0ef          	jal	800038ee <iunlockput>
      return 0;
    80003d88:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d8a:	8552                	mv	a0,s4
    80003d8c:	60e6                	ld	ra,88(sp)
    80003d8e:	6446                	ld	s0,80(sp)
    80003d90:	64a6                	ld	s1,72(sp)
    80003d92:	6906                	ld	s2,64(sp)
    80003d94:	79e2                	ld	s3,56(sp)
    80003d96:	7a42                	ld	s4,48(sp)
    80003d98:	7aa2                	ld	s5,40(sp)
    80003d9a:	7b02                	ld	s6,32(sp)
    80003d9c:	6be2                	ld	s7,24(sp)
    80003d9e:	6c42                	ld	s8,16(sp)
    80003da0:	6ca2                	ld	s9,8(sp)
    80003da2:	6d02                	ld	s10,0(sp)
    80003da4:	6125                	addi	sp,sp,96
    80003da6:	8082                	ret
      iunlock(ip);
    80003da8:	8552                	mv	a0,s4
    80003daa:	9e9ff0ef          	jal	80003792 <iunlock>
      return ip;
    80003dae:	bff1                	j	80003d8a <namex+0x5c>
      iunlockput(ip);
    80003db0:	8552                	mv	a0,s4
    80003db2:	b3dff0ef          	jal	800038ee <iunlockput>
      return 0;
    80003db6:	8a4e                	mv	s4,s3
    80003db8:	bfc9                	j	80003d8a <namex+0x5c>
  len = path - s;
    80003dba:	40998633          	sub	a2,s3,s1
    80003dbe:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003dc2:	09ac5063          	bge	s8,s10,80003e42 <namex+0x114>
    memmove(name, s, DIRSIZ);
    80003dc6:	8666                	mv	a2,s9
    80003dc8:	85a6                	mv	a1,s1
    80003dca:	8556                	mv	a0,s5
    80003dcc:	f35fc0ef          	jal	80000d00 <memmove>
    80003dd0:	84ce                	mv	s1,s3
  while(*path == '/')
    80003dd2:	0004c783          	lbu	a5,0(s1)
    80003dd6:	01279763          	bne	a5,s2,80003de4 <namex+0xb6>
    path++;
    80003dda:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003ddc:	0004c783          	lbu	a5,0(s1)
    80003de0:	ff278de3          	beq	a5,s2,80003dda <namex+0xac>
    ilock(ip);
    80003de4:	8552                	mv	a0,s4
    80003de6:	8ffff0ef          	jal	800036e4 <ilock>
    if(ip->type != T_DIR){
    80003dea:	044a1783          	lh	a5,68(s4)
    80003dee:	f9779ae3          	bne	a5,s7,80003d82 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003df2:	000b0563          	beqz	s6,80003dfc <namex+0xce>
    80003df6:	0004c783          	lbu	a5,0(s1)
    80003dfa:	d7dd                	beqz	a5,80003da8 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003dfc:	4601                	li	a2,0
    80003dfe:	85d6                	mv	a1,s5
    80003e00:	8552                	mv	a0,s4
    80003e02:	e81ff0ef          	jal	80003c82 <dirlookup>
    80003e06:	89aa                	mv	s3,a0
    80003e08:	d545                	beqz	a0,80003db0 <namex+0x82>
    iunlockput(ip);
    80003e0a:	8552                	mv	a0,s4
    80003e0c:	ae3ff0ef          	jal	800038ee <iunlockput>
    ip = next;
    80003e10:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003e12:	0004c783          	lbu	a5,0(s1)
    80003e16:	01279763          	bne	a5,s2,80003e24 <namex+0xf6>
    path++;
    80003e1a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e1c:	0004c783          	lbu	a5,0(s1)
    80003e20:	ff278de3          	beq	a5,s2,80003e1a <namex+0xec>
  if(*path == 0)
    80003e24:	cb8d                	beqz	a5,80003e56 <namex+0x128>
  while(*path != '/' && *path != 0)
    80003e26:	0004c783          	lbu	a5,0(s1)
    80003e2a:	89a6                	mv	s3,s1
  len = path - s;
    80003e2c:	4d01                	li	s10,0
    80003e2e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003e30:	01278963          	beq	a5,s2,80003e42 <namex+0x114>
    80003e34:	d3d9                	beqz	a5,80003dba <namex+0x8c>
    path++;
    80003e36:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e38:	0009c783          	lbu	a5,0(s3)
    80003e3c:	ff279ce3          	bne	a5,s2,80003e34 <namex+0x106>
    80003e40:	bfad                	j	80003dba <namex+0x8c>
    memmove(name, s, len);
    80003e42:	2601                	sext.w	a2,a2
    80003e44:	85a6                	mv	a1,s1
    80003e46:	8556                	mv	a0,s5
    80003e48:	eb9fc0ef          	jal	80000d00 <memmove>
    name[len] = 0;
    80003e4c:	9d56                	add	s10,s10,s5
    80003e4e:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffde288>
    80003e52:	84ce                	mv	s1,s3
    80003e54:	bfbd                	j	80003dd2 <namex+0xa4>
  if(nameiparent){
    80003e56:	f20b0ae3          	beqz	s6,80003d8a <namex+0x5c>
    iput(ip);
    80003e5a:	8552                	mv	a0,s4
    80003e5c:	a0bff0ef          	jal	80003866 <iput>
    return 0;
    80003e60:	4a01                	li	s4,0
    80003e62:	b725                	j	80003d8a <namex+0x5c>

0000000080003e64 <dirlink>:
{
    80003e64:	715d                	addi	sp,sp,-80
    80003e66:	e486                	sd	ra,72(sp)
    80003e68:	e0a2                	sd	s0,64(sp)
    80003e6a:	f84a                	sd	s2,48(sp)
    80003e6c:	ec56                	sd	s5,24(sp)
    80003e6e:	e85a                	sd	s6,16(sp)
    80003e70:	0880                	addi	s0,sp,80
    80003e72:	892a                	mv	s2,a0
    80003e74:	8aae                	mv	s5,a1
    80003e76:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e78:	4601                	li	a2,0
    80003e7a:	e09ff0ef          	jal	80003c82 <dirlookup>
    80003e7e:	ed1d                	bnez	a0,80003ebc <dirlink+0x58>
    80003e80:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e82:	04c92483          	lw	s1,76(s2)
    80003e86:	c4b9                	beqz	s1,80003ed4 <dirlink+0x70>
    80003e88:	f44e                	sd	s3,40(sp)
    80003e8a:	f052                	sd	s4,32(sp)
    80003e8c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e8e:	fb040a13          	addi	s4,s0,-80
    80003e92:	49c1                	li	s3,16
    80003e94:	874e                	mv	a4,s3
    80003e96:	86a6                	mv	a3,s1
    80003e98:	8652                	mv	a2,s4
    80003e9a:	4581                	li	a1,0
    80003e9c:	854a                	mv	a0,s2
    80003e9e:	bd9ff0ef          	jal	80003a76 <readi>
    80003ea2:	03351163          	bne	a0,s3,80003ec4 <dirlink+0x60>
    if(de.inum == 0)
    80003ea6:	fb045783          	lhu	a5,-80(s0)
    80003eaa:	c39d                	beqz	a5,80003ed0 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003eac:	24c1                	addiw	s1,s1,16
    80003eae:	04c92783          	lw	a5,76(s2)
    80003eb2:	fef4e1e3          	bltu	s1,a5,80003e94 <dirlink+0x30>
    80003eb6:	79a2                	ld	s3,40(sp)
    80003eb8:	7a02                	ld	s4,32(sp)
    80003eba:	a829                	j	80003ed4 <dirlink+0x70>
    iput(ip);
    80003ebc:	9abff0ef          	jal	80003866 <iput>
    return -1;
    80003ec0:	557d                	li	a0,-1
    80003ec2:	a83d                	j	80003f00 <dirlink+0x9c>
      panic("dirlink read");
    80003ec4:	00003517          	auipc	a0,0x3
    80003ec8:	60450513          	addi	a0,a0,1540 # 800074c8 <etext+0x4c8>
    80003ecc:	913fc0ef          	jal	800007de <panic>
    80003ed0:	79a2                	ld	s3,40(sp)
    80003ed2:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003ed4:	4639                	li	a2,14
    80003ed6:	85d6                	mv	a1,s5
    80003ed8:	fb240513          	addi	a0,s0,-78
    80003edc:	ed3fc0ef          	jal	80000dae <strncpy>
  de.inum = inum;
    80003ee0:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ee4:	4741                	li	a4,16
    80003ee6:	86a6                	mv	a3,s1
    80003ee8:	fb040613          	addi	a2,s0,-80
    80003eec:	4581                	li	a1,0
    80003eee:	854a                	mv	a0,s2
    80003ef0:	c79ff0ef          	jal	80003b68 <writei>
    80003ef4:	1541                	addi	a0,a0,-16
    80003ef6:	00a03533          	snez	a0,a0
    80003efa:	40a0053b          	negw	a0,a0
    80003efe:	74e2                	ld	s1,56(sp)
}
    80003f00:	60a6                	ld	ra,72(sp)
    80003f02:	6406                	ld	s0,64(sp)
    80003f04:	7942                	ld	s2,48(sp)
    80003f06:	6ae2                	ld	s5,24(sp)
    80003f08:	6b42                	ld	s6,16(sp)
    80003f0a:	6161                	addi	sp,sp,80
    80003f0c:	8082                	ret

0000000080003f0e <namei>:

struct inode*
namei(char *path)
{
    80003f0e:	1101                	addi	sp,sp,-32
    80003f10:	ec06                	sd	ra,24(sp)
    80003f12:	e822                	sd	s0,16(sp)
    80003f14:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f16:	fe040613          	addi	a2,s0,-32
    80003f1a:	4581                	li	a1,0
    80003f1c:	e13ff0ef          	jal	80003d2e <namex>
}
    80003f20:	60e2                	ld	ra,24(sp)
    80003f22:	6442                	ld	s0,16(sp)
    80003f24:	6105                	addi	sp,sp,32
    80003f26:	8082                	ret

0000000080003f28 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f28:	1141                	addi	sp,sp,-16
    80003f2a:	e406                	sd	ra,8(sp)
    80003f2c:	e022                	sd	s0,0(sp)
    80003f2e:	0800                	addi	s0,sp,16
    80003f30:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f32:	4585                	li	a1,1
    80003f34:	dfbff0ef          	jal	80003d2e <namex>
}
    80003f38:	60a2                	ld	ra,8(sp)
    80003f3a:	6402                	ld	s0,0(sp)
    80003f3c:	0141                	addi	sp,sp,16
    80003f3e:	8082                	ret

0000000080003f40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f40:	1101                	addi	sp,sp,-32
    80003f42:	ec06                	sd	ra,24(sp)
    80003f44:	e822                	sd	s0,16(sp)
    80003f46:	e426                	sd	s1,8(sp)
    80003f48:	e04a                	sd	s2,0(sp)
    80003f4a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f4c:	0001c917          	auipc	s2,0x1c
    80003f50:	bec90913          	addi	s2,s2,-1044 # 8001fb38 <log>
    80003f54:	01892583          	lw	a1,24(s2)
    80003f58:	02492503          	lw	a0,36(s2)
    80003f5c:	8e2ff0ef          	jal	8000303e <bread>
    80003f60:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f62:	02892603          	lw	a2,40(s2)
    80003f66:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f68:	00c05f63          	blez	a2,80003f86 <write_head+0x46>
    80003f6c:	0001c717          	auipc	a4,0x1c
    80003f70:	bf870713          	addi	a4,a4,-1032 # 8001fb64 <log+0x2c>
    80003f74:	87aa                	mv	a5,a0
    80003f76:	060a                	slli	a2,a2,0x2
    80003f78:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003f7a:	4314                	lw	a3,0(a4)
    80003f7c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003f7e:	0711                	addi	a4,a4,4
    80003f80:	0791                	addi	a5,a5,4
    80003f82:	fec79ce3          	bne	a5,a2,80003f7a <write_head+0x3a>
  }
  bwrite(buf);
    80003f86:	8526                	mv	a0,s1
    80003f88:	98cff0ef          	jal	80003114 <bwrite>
  brelse(buf);
    80003f8c:	8526                	mv	a0,s1
    80003f8e:	9b8ff0ef          	jal	80003146 <brelse>
}
    80003f92:	60e2                	ld	ra,24(sp)
    80003f94:	6442                	ld	s0,16(sp)
    80003f96:	64a2                	ld	s1,8(sp)
    80003f98:	6902                	ld	s2,0(sp)
    80003f9a:	6105                	addi	sp,sp,32
    80003f9c:	8082                	ret

0000000080003f9e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f9e:	0001c797          	auipc	a5,0x1c
    80003fa2:	bc27a783          	lw	a5,-1086(a5) # 8001fb60 <log+0x28>
    80003fa6:	0cf05163          	blez	a5,80004068 <install_trans+0xca>
{
    80003faa:	715d                	addi	sp,sp,-80
    80003fac:	e486                	sd	ra,72(sp)
    80003fae:	e0a2                	sd	s0,64(sp)
    80003fb0:	fc26                	sd	s1,56(sp)
    80003fb2:	f84a                	sd	s2,48(sp)
    80003fb4:	f44e                	sd	s3,40(sp)
    80003fb6:	f052                	sd	s4,32(sp)
    80003fb8:	ec56                	sd	s5,24(sp)
    80003fba:	e85a                	sd	s6,16(sp)
    80003fbc:	e45e                	sd	s7,8(sp)
    80003fbe:	e062                	sd	s8,0(sp)
    80003fc0:	0880                	addi	s0,sp,80
    80003fc2:	8b2a                	mv	s6,a0
    80003fc4:	0001ca97          	auipc	s5,0x1c
    80003fc8:	ba0a8a93          	addi	s5,s5,-1120 # 8001fb64 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fcc:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003fce:	00003c17          	auipc	s8,0x3
    80003fd2:	50ac0c13          	addi	s8,s8,1290 # 800074d8 <etext+0x4d8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fd6:	0001ca17          	auipc	s4,0x1c
    80003fda:	b62a0a13          	addi	s4,s4,-1182 # 8001fb38 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003fde:	40000b93          	li	s7,1024
    80003fe2:	a025                	j	8000400a <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003fe4:	000aa603          	lw	a2,0(s5)
    80003fe8:	85ce                	mv	a1,s3
    80003fea:	8562                	mv	a0,s8
    80003fec:	d0efc0ef          	jal	800004fa <printf>
    80003ff0:	a839                	j	8000400e <install_trans+0x70>
    brelse(lbuf);
    80003ff2:	854a                	mv	a0,s2
    80003ff4:	952ff0ef          	jal	80003146 <brelse>
    brelse(dbuf);
    80003ff8:	8526                	mv	a0,s1
    80003ffa:	94cff0ef          	jal	80003146 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ffe:	2985                	addiw	s3,s3,1
    80004000:	0a91                	addi	s5,s5,4
    80004002:	028a2783          	lw	a5,40(s4)
    80004006:	04f9d563          	bge	s3,a5,80004050 <install_trans+0xb2>
    if(recovering) {
    8000400a:	fc0b1de3          	bnez	s6,80003fe4 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000400e:	018a2583          	lw	a1,24(s4)
    80004012:	013585bb          	addw	a1,a1,s3
    80004016:	2585                	addiw	a1,a1,1
    80004018:	024a2503          	lw	a0,36(s4)
    8000401c:	822ff0ef          	jal	8000303e <bread>
    80004020:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004022:	000aa583          	lw	a1,0(s5)
    80004026:	024a2503          	lw	a0,36(s4)
    8000402a:	814ff0ef          	jal	8000303e <bread>
    8000402e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004030:	865e                	mv	a2,s7
    80004032:	05890593          	addi	a1,s2,88
    80004036:	05850513          	addi	a0,a0,88
    8000403a:	cc7fc0ef          	jal	80000d00 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000403e:	8526                	mv	a0,s1
    80004040:	8d4ff0ef          	jal	80003114 <bwrite>
    if(recovering == 0)
    80004044:	fa0b17e3          	bnez	s6,80003ff2 <install_trans+0x54>
      bunpin(dbuf);
    80004048:	8526                	mv	a0,s1
    8000404a:	9b4ff0ef          	jal	800031fe <bunpin>
    8000404e:	b755                	j	80003ff2 <install_trans+0x54>
}
    80004050:	60a6                	ld	ra,72(sp)
    80004052:	6406                	ld	s0,64(sp)
    80004054:	74e2                	ld	s1,56(sp)
    80004056:	7942                	ld	s2,48(sp)
    80004058:	79a2                	ld	s3,40(sp)
    8000405a:	7a02                	ld	s4,32(sp)
    8000405c:	6ae2                	ld	s5,24(sp)
    8000405e:	6b42                	ld	s6,16(sp)
    80004060:	6ba2                	ld	s7,8(sp)
    80004062:	6c02                	ld	s8,0(sp)
    80004064:	6161                	addi	sp,sp,80
    80004066:	8082                	ret
    80004068:	8082                	ret

000000008000406a <initlog>:
{
    8000406a:	7179                	addi	sp,sp,-48
    8000406c:	f406                	sd	ra,40(sp)
    8000406e:	f022                	sd	s0,32(sp)
    80004070:	ec26                	sd	s1,24(sp)
    80004072:	e84a                	sd	s2,16(sp)
    80004074:	e44e                	sd	s3,8(sp)
    80004076:	1800                	addi	s0,sp,48
    80004078:	892a                	mv	s2,a0
    8000407a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000407c:	0001c497          	auipc	s1,0x1c
    80004080:	abc48493          	addi	s1,s1,-1348 # 8001fb38 <log>
    80004084:	00003597          	auipc	a1,0x3
    80004088:	47458593          	addi	a1,a1,1140 # 800074f8 <etext+0x4f8>
    8000408c:	8526                	mv	a0,s1
    8000408e:	abbfc0ef          	jal	80000b48 <initlock>
  log.start = sb->logstart;
    80004092:	0149a583          	lw	a1,20(s3)
    80004096:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80004098:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000409c:	854a                	mv	a0,s2
    8000409e:	fa1fe0ef          	jal	8000303e <bread>
  log.lh.n = lh->n;
    800040a2:	4d30                	lw	a2,88(a0)
    800040a4:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    800040a6:	00c05f63          	blez	a2,800040c4 <initlog+0x5a>
    800040aa:	87aa                	mv	a5,a0
    800040ac:	0001c717          	auipc	a4,0x1c
    800040b0:	ab870713          	addi	a4,a4,-1352 # 8001fb64 <log+0x2c>
    800040b4:	060a                	slli	a2,a2,0x2
    800040b6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800040b8:	4ff4                	lw	a3,92(a5)
    800040ba:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800040bc:	0791                	addi	a5,a5,4
    800040be:	0711                	addi	a4,a4,4
    800040c0:	fec79ce3          	bne	a5,a2,800040b8 <initlog+0x4e>
  brelse(buf);
    800040c4:	882ff0ef          	jal	80003146 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800040c8:	4505                	li	a0,1
    800040ca:	ed5ff0ef          	jal	80003f9e <install_trans>
  log.lh.n = 0;
    800040ce:	0001c797          	auipc	a5,0x1c
    800040d2:	a807a923          	sw	zero,-1390(a5) # 8001fb60 <log+0x28>
  write_head(); // clear the log
    800040d6:	e6bff0ef          	jal	80003f40 <write_head>
}
    800040da:	70a2                	ld	ra,40(sp)
    800040dc:	7402                	ld	s0,32(sp)
    800040de:	64e2                	ld	s1,24(sp)
    800040e0:	6942                	ld	s2,16(sp)
    800040e2:	69a2                	ld	s3,8(sp)
    800040e4:	6145                	addi	sp,sp,48
    800040e6:	8082                	ret

00000000800040e8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800040e8:	1101                	addi	sp,sp,-32
    800040ea:	ec06                	sd	ra,24(sp)
    800040ec:	e822                	sd	s0,16(sp)
    800040ee:	e426                	sd	s1,8(sp)
    800040f0:	e04a                	sd	s2,0(sp)
    800040f2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800040f4:	0001c517          	auipc	a0,0x1c
    800040f8:	a4450513          	addi	a0,a0,-1468 # 8001fb38 <log>
    800040fc:	ad1fc0ef          	jal	80000bcc <acquire>
  while(1){
    if(log.committing){
    80004100:	0001c497          	auipc	s1,0x1c
    80004104:	a3848493          	addi	s1,s1,-1480 # 8001fb38 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80004108:	4979                	li	s2,30
    8000410a:	a029                	j	80004114 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000410c:	85a6                	mv	a1,s1
    8000410e:	8526                	mv	a0,s1
    80004110:	ec7fd0ef          	jal	80001fd6 <sleep>
    if(log.committing){
    80004114:	509c                	lw	a5,32(s1)
    80004116:	fbfd                	bnez	a5,8000410c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80004118:	4cd8                	lw	a4,28(s1)
    8000411a:	2705                	addiw	a4,a4,1
    8000411c:	0027179b          	slliw	a5,a4,0x2
    80004120:	9fb9                	addw	a5,a5,a4
    80004122:	0017979b          	slliw	a5,a5,0x1
    80004126:	5494                	lw	a3,40(s1)
    80004128:	9fb5                	addw	a5,a5,a3
    8000412a:	00f95763          	bge	s2,a5,80004138 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000412e:	85a6                	mv	a1,s1
    80004130:	8526                	mv	a0,s1
    80004132:	ea5fd0ef          	jal	80001fd6 <sleep>
    80004136:	bff9                	j	80004114 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80004138:	0001c517          	auipc	a0,0x1c
    8000413c:	a0050513          	addi	a0,a0,-1536 # 8001fb38 <log>
    80004140:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    80004142:	b1ffc0ef          	jal	80000c60 <release>
      break;
    }
  }
}
    80004146:	60e2                	ld	ra,24(sp)
    80004148:	6442                	ld	s0,16(sp)
    8000414a:	64a2                	ld	s1,8(sp)
    8000414c:	6902                	ld	s2,0(sp)
    8000414e:	6105                	addi	sp,sp,32
    80004150:	8082                	ret

0000000080004152 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004152:	7139                	addi	sp,sp,-64
    80004154:	fc06                	sd	ra,56(sp)
    80004156:	f822                	sd	s0,48(sp)
    80004158:	f426                	sd	s1,40(sp)
    8000415a:	f04a                	sd	s2,32(sp)
    8000415c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000415e:	0001c497          	auipc	s1,0x1c
    80004162:	9da48493          	addi	s1,s1,-1574 # 8001fb38 <log>
    80004166:	8526                	mv	a0,s1
    80004168:	a65fc0ef          	jal	80000bcc <acquire>
  log.outstanding -= 1;
    8000416c:	4cdc                	lw	a5,28(s1)
    8000416e:	37fd                	addiw	a5,a5,-1
    80004170:	893e                	mv	s2,a5
    80004172:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80004174:	509c                	lw	a5,32(s1)
    80004176:	ef9d                	bnez	a5,800041b4 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80004178:	04091863          	bnez	s2,800041c8 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000417c:	0001c497          	auipc	s1,0x1c
    80004180:	9bc48493          	addi	s1,s1,-1604 # 8001fb38 <log>
    80004184:	4785                	li	a5,1
    80004186:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004188:	8526                	mv	a0,s1
    8000418a:	ad7fc0ef          	jal	80000c60 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000418e:	549c                	lw	a5,40(s1)
    80004190:	04f04c63          	bgtz	a5,800041e8 <end_op+0x96>
    acquire(&log.lock);
    80004194:	0001c497          	auipc	s1,0x1c
    80004198:	9a448493          	addi	s1,s1,-1628 # 8001fb38 <log>
    8000419c:	8526                	mv	a0,s1
    8000419e:	a2ffc0ef          	jal	80000bcc <acquire>
    log.committing = 0;
    800041a2:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    800041a6:	8526                	mv	a0,s1
    800041a8:	e7bfd0ef          	jal	80002022 <wakeup>
    release(&log.lock);
    800041ac:	8526                	mv	a0,s1
    800041ae:	ab3fc0ef          	jal	80000c60 <release>
}
    800041b2:	a02d                	j	800041dc <end_op+0x8a>
    800041b4:	ec4e                	sd	s3,24(sp)
    800041b6:	e852                	sd	s4,16(sp)
    800041b8:	e456                	sd	s5,8(sp)
    800041ba:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800041bc:	00003517          	auipc	a0,0x3
    800041c0:	34450513          	addi	a0,a0,836 # 80007500 <etext+0x500>
    800041c4:	e1afc0ef          	jal	800007de <panic>
    wakeup(&log);
    800041c8:	0001c497          	auipc	s1,0x1c
    800041cc:	97048493          	addi	s1,s1,-1680 # 8001fb38 <log>
    800041d0:	8526                	mv	a0,s1
    800041d2:	e51fd0ef          	jal	80002022 <wakeup>
  release(&log.lock);
    800041d6:	8526                	mv	a0,s1
    800041d8:	a89fc0ef          	jal	80000c60 <release>
}
    800041dc:	70e2                	ld	ra,56(sp)
    800041de:	7442                	ld	s0,48(sp)
    800041e0:	74a2                	ld	s1,40(sp)
    800041e2:	7902                	ld	s2,32(sp)
    800041e4:	6121                	addi	sp,sp,64
    800041e6:	8082                	ret
    800041e8:	ec4e                	sd	s3,24(sp)
    800041ea:	e852                	sd	s4,16(sp)
    800041ec:	e456                	sd	s5,8(sp)
    800041ee:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800041f0:	0001ca97          	auipc	s5,0x1c
    800041f4:	974a8a93          	addi	s5,s5,-1676 # 8001fb64 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800041f8:	0001ca17          	auipc	s4,0x1c
    800041fc:	940a0a13          	addi	s4,s4,-1728 # 8001fb38 <log>
    memmove(to->data, from->data, BSIZE);
    80004200:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004204:	018a2583          	lw	a1,24(s4)
    80004208:	012585bb          	addw	a1,a1,s2
    8000420c:	2585                	addiw	a1,a1,1
    8000420e:	024a2503          	lw	a0,36(s4)
    80004212:	e2dfe0ef          	jal	8000303e <bread>
    80004216:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004218:	000aa583          	lw	a1,0(s5)
    8000421c:	024a2503          	lw	a0,36(s4)
    80004220:	e1ffe0ef          	jal	8000303e <bread>
    80004224:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004226:	865a                	mv	a2,s6
    80004228:	05850593          	addi	a1,a0,88
    8000422c:	05848513          	addi	a0,s1,88
    80004230:	ad1fc0ef          	jal	80000d00 <memmove>
    bwrite(to);  // write the log
    80004234:	8526                	mv	a0,s1
    80004236:	edffe0ef          	jal	80003114 <bwrite>
    brelse(from);
    8000423a:	854e                	mv	a0,s3
    8000423c:	f0bfe0ef          	jal	80003146 <brelse>
    brelse(to);
    80004240:	8526                	mv	a0,s1
    80004242:	f05fe0ef          	jal	80003146 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004246:	2905                	addiw	s2,s2,1
    80004248:	0a91                	addi	s5,s5,4
    8000424a:	028a2783          	lw	a5,40(s4)
    8000424e:	faf94be3          	blt	s2,a5,80004204 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004252:	cefff0ef          	jal	80003f40 <write_head>
    install_trans(0); // Now install writes to home locations
    80004256:	4501                	li	a0,0
    80004258:	d47ff0ef          	jal	80003f9e <install_trans>
    log.lh.n = 0;
    8000425c:	0001c797          	auipc	a5,0x1c
    80004260:	9007a223          	sw	zero,-1788(a5) # 8001fb60 <log+0x28>
    write_head();    // Erase the transaction from the log
    80004264:	cddff0ef          	jal	80003f40 <write_head>
    80004268:	69e2                	ld	s3,24(sp)
    8000426a:	6a42                	ld	s4,16(sp)
    8000426c:	6aa2                	ld	s5,8(sp)
    8000426e:	6b02                	ld	s6,0(sp)
    80004270:	b715                	j	80004194 <end_op+0x42>

0000000080004272 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004272:	1101                	addi	sp,sp,-32
    80004274:	ec06                	sd	ra,24(sp)
    80004276:	e822                	sd	s0,16(sp)
    80004278:	e426                	sd	s1,8(sp)
    8000427a:	e04a                	sd	s2,0(sp)
    8000427c:	1000                	addi	s0,sp,32
    8000427e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004280:	0001c917          	auipc	s2,0x1c
    80004284:	8b890913          	addi	s2,s2,-1864 # 8001fb38 <log>
    80004288:	854a                	mv	a0,s2
    8000428a:	943fc0ef          	jal	80000bcc <acquire>
  if (log.lh.n >= LOGBLOCKS)
    8000428e:	02892603          	lw	a2,40(s2)
    80004292:	47f5                	li	a5,29
    80004294:	04c7cc63          	blt	a5,a2,800042ec <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004298:	0001c797          	auipc	a5,0x1c
    8000429c:	8bc7a783          	lw	a5,-1860(a5) # 8001fb54 <log+0x1c>
    800042a0:	04f05c63          	blez	a5,800042f8 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800042a4:	4781                	li	a5,0
    800042a6:	04c05f63          	blez	a2,80004304 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800042aa:	44cc                	lw	a1,12(s1)
    800042ac:	0001c717          	auipc	a4,0x1c
    800042b0:	8b870713          	addi	a4,a4,-1864 # 8001fb64 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    800042b4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800042b6:	4314                	lw	a3,0(a4)
    800042b8:	04b68663          	beq	a3,a1,80004304 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    800042bc:	2785                	addiw	a5,a5,1
    800042be:	0711                	addi	a4,a4,4
    800042c0:	fef61be3          	bne	a2,a5,800042b6 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800042c4:	0621                	addi	a2,a2,8
    800042c6:	060a                	slli	a2,a2,0x2
    800042c8:	0001c797          	auipc	a5,0x1c
    800042cc:	87078793          	addi	a5,a5,-1936 # 8001fb38 <log>
    800042d0:	97b2                	add	a5,a5,a2
    800042d2:	44d8                	lw	a4,12(s1)
    800042d4:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800042d6:	8526                	mv	a0,s1
    800042d8:	ef3fe0ef          	jal	800031ca <bpin>
    log.lh.n++;
    800042dc:	0001c717          	auipc	a4,0x1c
    800042e0:	85c70713          	addi	a4,a4,-1956 # 8001fb38 <log>
    800042e4:	571c                	lw	a5,40(a4)
    800042e6:	2785                	addiw	a5,a5,1
    800042e8:	d71c                	sw	a5,40(a4)
    800042ea:	a80d                	j	8000431c <log_write+0xaa>
    panic("too big a transaction");
    800042ec:	00003517          	auipc	a0,0x3
    800042f0:	22450513          	addi	a0,a0,548 # 80007510 <etext+0x510>
    800042f4:	ceafc0ef          	jal	800007de <panic>
    panic("log_write outside of trans");
    800042f8:	00003517          	auipc	a0,0x3
    800042fc:	23050513          	addi	a0,a0,560 # 80007528 <etext+0x528>
    80004300:	cdefc0ef          	jal	800007de <panic>
  log.lh.block[i] = b->blockno;
    80004304:	00878693          	addi	a3,a5,8
    80004308:	068a                	slli	a3,a3,0x2
    8000430a:	0001c717          	auipc	a4,0x1c
    8000430e:	82e70713          	addi	a4,a4,-2002 # 8001fb38 <log>
    80004312:	9736                	add	a4,a4,a3
    80004314:	44d4                	lw	a3,12(s1)
    80004316:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004318:	faf60fe3          	beq	a2,a5,800042d6 <log_write+0x64>
  }
  release(&log.lock);
    8000431c:	0001c517          	auipc	a0,0x1c
    80004320:	81c50513          	addi	a0,a0,-2020 # 8001fb38 <log>
    80004324:	93dfc0ef          	jal	80000c60 <release>
}
    80004328:	60e2                	ld	ra,24(sp)
    8000432a:	6442                	ld	s0,16(sp)
    8000432c:	64a2                	ld	s1,8(sp)
    8000432e:	6902                	ld	s2,0(sp)
    80004330:	6105                	addi	sp,sp,32
    80004332:	8082                	ret

0000000080004334 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004334:	1101                	addi	sp,sp,-32
    80004336:	ec06                	sd	ra,24(sp)
    80004338:	e822                	sd	s0,16(sp)
    8000433a:	e426                	sd	s1,8(sp)
    8000433c:	e04a                	sd	s2,0(sp)
    8000433e:	1000                	addi	s0,sp,32
    80004340:	84aa                	mv	s1,a0
    80004342:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004344:	00003597          	auipc	a1,0x3
    80004348:	20458593          	addi	a1,a1,516 # 80007548 <etext+0x548>
    8000434c:	0521                	addi	a0,a0,8
    8000434e:	ffafc0ef          	jal	80000b48 <initlock>
  lk->name = name;
    80004352:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004356:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000435a:	0204a423          	sw	zero,40(s1)
}
    8000435e:	60e2                	ld	ra,24(sp)
    80004360:	6442                	ld	s0,16(sp)
    80004362:	64a2                	ld	s1,8(sp)
    80004364:	6902                	ld	s2,0(sp)
    80004366:	6105                	addi	sp,sp,32
    80004368:	8082                	ret

000000008000436a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000436a:	1101                	addi	sp,sp,-32
    8000436c:	ec06                	sd	ra,24(sp)
    8000436e:	e822                	sd	s0,16(sp)
    80004370:	e426                	sd	s1,8(sp)
    80004372:	e04a                	sd	s2,0(sp)
    80004374:	1000                	addi	s0,sp,32
    80004376:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004378:	00850913          	addi	s2,a0,8
    8000437c:	854a                	mv	a0,s2
    8000437e:	84ffc0ef          	jal	80000bcc <acquire>
  while (lk->locked) {
    80004382:	409c                	lw	a5,0(s1)
    80004384:	c799                	beqz	a5,80004392 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004386:	85ca                	mv	a1,s2
    80004388:	8526                	mv	a0,s1
    8000438a:	c4dfd0ef          	jal	80001fd6 <sleep>
  while (lk->locked) {
    8000438e:	409c                	lw	a5,0(s1)
    80004390:	fbfd                	bnez	a5,80004386 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004392:	4785                	li	a5,1
    80004394:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004396:	d28fd0ef          	jal	800018be <myproc>
    8000439a:	591c                	lw	a5,48(a0)
    8000439c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000439e:	854a                	mv	a0,s2
    800043a0:	8c1fc0ef          	jal	80000c60 <release>
}
    800043a4:	60e2                	ld	ra,24(sp)
    800043a6:	6442                	ld	s0,16(sp)
    800043a8:	64a2                	ld	s1,8(sp)
    800043aa:	6902                	ld	s2,0(sp)
    800043ac:	6105                	addi	sp,sp,32
    800043ae:	8082                	ret

00000000800043b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800043b0:	1101                	addi	sp,sp,-32
    800043b2:	ec06                	sd	ra,24(sp)
    800043b4:	e822                	sd	s0,16(sp)
    800043b6:	e426                	sd	s1,8(sp)
    800043b8:	e04a                	sd	s2,0(sp)
    800043ba:	1000                	addi	s0,sp,32
    800043bc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043be:	00850913          	addi	s2,a0,8
    800043c2:	854a                	mv	a0,s2
    800043c4:	809fc0ef          	jal	80000bcc <acquire>
  lk->locked = 0;
    800043c8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043cc:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800043d0:	8526                	mv	a0,s1
    800043d2:	c51fd0ef          	jal	80002022 <wakeup>
  release(&lk->lk);
    800043d6:	854a                	mv	a0,s2
    800043d8:	889fc0ef          	jal	80000c60 <release>
}
    800043dc:	60e2                	ld	ra,24(sp)
    800043de:	6442                	ld	s0,16(sp)
    800043e0:	64a2                	ld	s1,8(sp)
    800043e2:	6902                	ld	s2,0(sp)
    800043e4:	6105                	addi	sp,sp,32
    800043e6:	8082                	ret

00000000800043e8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800043e8:	7179                	addi	sp,sp,-48
    800043ea:	f406                	sd	ra,40(sp)
    800043ec:	f022                	sd	s0,32(sp)
    800043ee:	ec26                	sd	s1,24(sp)
    800043f0:	e84a                	sd	s2,16(sp)
    800043f2:	1800                	addi	s0,sp,48
    800043f4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800043f6:	00850913          	addi	s2,a0,8
    800043fa:	854a                	mv	a0,s2
    800043fc:	fd0fc0ef          	jal	80000bcc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004400:	409c                	lw	a5,0(s1)
    80004402:	ef81                	bnez	a5,8000441a <holdingsleep+0x32>
    80004404:	4481                	li	s1,0
  release(&lk->lk);
    80004406:	854a                	mv	a0,s2
    80004408:	859fc0ef          	jal	80000c60 <release>
  return r;
}
    8000440c:	8526                	mv	a0,s1
    8000440e:	70a2                	ld	ra,40(sp)
    80004410:	7402                	ld	s0,32(sp)
    80004412:	64e2                	ld	s1,24(sp)
    80004414:	6942                	ld	s2,16(sp)
    80004416:	6145                	addi	sp,sp,48
    80004418:	8082                	ret
    8000441a:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000441c:	0284a983          	lw	s3,40(s1)
    80004420:	c9efd0ef          	jal	800018be <myproc>
    80004424:	5904                	lw	s1,48(a0)
    80004426:	413484b3          	sub	s1,s1,s3
    8000442a:	0014b493          	seqz	s1,s1
    8000442e:	69a2                	ld	s3,8(sp)
    80004430:	bfd9                	j	80004406 <holdingsleep+0x1e>

0000000080004432 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004432:	1141                	addi	sp,sp,-16
    80004434:	e406                	sd	ra,8(sp)
    80004436:	e022                	sd	s0,0(sp)
    80004438:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000443a:	00003597          	auipc	a1,0x3
    8000443e:	11e58593          	addi	a1,a1,286 # 80007558 <etext+0x558>
    80004442:	0001c517          	auipc	a0,0x1c
    80004446:	83e50513          	addi	a0,a0,-1986 # 8001fc80 <ftable>
    8000444a:	efefc0ef          	jal	80000b48 <initlock>
}
    8000444e:	60a2                	ld	ra,8(sp)
    80004450:	6402                	ld	s0,0(sp)
    80004452:	0141                	addi	sp,sp,16
    80004454:	8082                	ret

0000000080004456 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004456:	1101                	addi	sp,sp,-32
    80004458:	ec06                	sd	ra,24(sp)
    8000445a:	e822                	sd	s0,16(sp)
    8000445c:	e426                	sd	s1,8(sp)
    8000445e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004460:	0001c517          	auipc	a0,0x1c
    80004464:	82050513          	addi	a0,a0,-2016 # 8001fc80 <ftable>
    80004468:	f64fc0ef          	jal	80000bcc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000446c:	0001c497          	auipc	s1,0x1c
    80004470:	82c48493          	addi	s1,s1,-2004 # 8001fc98 <ftable+0x18>
    80004474:	0001c717          	auipc	a4,0x1c
    80004478:	7c470713          	addi	a4,a4,1988 # 80020c38 <disk>
    if(f->ref == 0){
    8000447c:	40dc                	lw	a5,4(s1)
    8000447e:	cf89                	beqz	a5,80004498 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004480:	02848493          	addi	s1,s1,40
    80004484:	fee49ce3          	bne	s1,a4,8000447c <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004488:	0001b517          	auipc	a0,0x1b
    8000448c:	7f850513          	addi	a0,a0,2040 # 8001fc80 <ftable>
    80004490:	fd0fc0ef          	jal	80000c60 <release>
  return 0;
    80004494:	4481                	li	s1,0
    80004496:	a809                	j	800044a8 <filealloc+0x52>
      f->ref = 1;
    80004498:	4785                	li	a5,1
    8000449a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000449c:	0001b517          	auipc	a0,0x1b
    800044a0:	7e450513          	addi	a0,a0,2020 # 8001fc80 <ftable>
    800044a4:	fbcfc0ef          	jal	80000c60 <release>
}
    800044a8:	8526                	mv	a0,s1
    800044aa:	60e2                	ld	ra,24(sp)
    800044ac:	6442                	ld	s0,16(sp)
    800044ae:	64a2                	ld	s1,8(sp)
    800044b0:	6105                	addi	sp,sp,32
    800044b2:	8082                	ret

00000000800044b4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800044b4:	1101                	addi	sp,sp,-32
    800044b6:	ec06                	sd	ra,24(sp)
    800044b8:	e822                	sd	s0,16(sp)
    800044ba:	e426                	sd	s1,8(sp)
    800044bc:	1000                	addi	s0,sp,32
    800044be:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800044c0:	0001b517          	auipc	a0,0x1b
    800044c4:	7c050513          	addi	a0,a0,1984 # 8001fc80 <ftable>
    800044c8:	f04fc0ef          	jal	80000bcc <acquire>
  if(f->ref < 1)
    800044cc:	40dc                	lw	a5,4(s1)
    800044ce:	02f05063          	blez	a5,800044ee <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800044d2:	2785                	addiw	a5,a5,1
    800044d4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800044d6:	0001b517          	auipc	a0,0x1b
    800044da:	7aa50513          	addi	a0,a0,1962 # 8001fc80 <ftable>
    800044de:	f82fc0ef          	jal	80000c60 <release>
  return f;
}
    800044e2:	8526                	mv	a0,s1
    800044e4:	60e2                	ld	ra,24(sp)
    800044e6:	6442                	ld	s0,16(sp)
    800044e8:	64a2                	ld	s1,8(sp)
    800044ea:	6105                	addi	sp,sp,32
    800044ec:	8082                	ret
    panic("filedup");
    800044ee:	00003517          	auipc	a0,0x3
    800044f2:	07250513          	addi	a0,a0,114 # 80007560 <etext+0x560>
    800044f6:	ae8fc0ef          	jal	800007de <panic>

00000000800044fa <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800044fa:	7139                	addi	sp,sp,-64
    800044fc:	fc06                	sd	ra,56(sp)
    800044fe:	f822                	sd	s0,48(sp)
    80004500:	f426                	sd	s1,40(sp)
    80004502:	0080                	addi	s0,sp,64
    80004504:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004506:	0001b517          	auipc	a0,0x1b
    8000450a:	77a50513          	addi	a0,a0,1914 # 8001fc80 <ftable>
    8000450e:	ebefc0ef          	jal	80000bcc <acquire>
  if(f->ref < 1)
    80004512:	40dc                	lw	a5,4(s1)
    80004514:	04f05863          	blez	a5,80004564 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    80004518:	37fd                	addiw	a5,a5,-1
    8000451a:	c0dc                	sw	a5,4(s1)
    8000451c:	04f04e63          	bgtz	a5,80004578 <fileclose+0x7e>
    80004520:	f04a                	sd	s2,32(sp)
    80004522:	ec4e                	sd	s3,24(sp)
    80004524:	e852                	sd	s4,16(sp)
    80004526:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004528:	0004a903          	lw	s2,0(s1)
    8000452c:	0094ca83          	lbu	s5,9(s1)
    80004530:	0104ba03          	ld	s4,16(s1)
    80004534:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004538:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000453c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004540:	0001b517          	auipc	a0,0x1b
    80004544:	74050513          	addi	a0,a0,1856 # 8001fc80 <ftable>
    80004548:	f18fc0ef          	jal	80000c60 <release>

  if(ff.type == FD_PIPE){
    8000454c:	4785                	li	a5,1
    8000454e:	04f90063          	beq	s2,a5,8000458e <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004552:	3979                	addiw	s2,s2,-2
    80004554:	4785                	li	a5,1
    80004556:	0527f563          	bgeu	a5,s2,800045a0 <fileclose+0xa6>
    8000455a:	7902                	ld	s2,32(sp)
    8000455c:	69e2                	ld	s3,24(sp)
    8000455e:	6a42                	ld	s4,16(sp)
    80004560:	6aa2                	ld	s5,8(sp)
    80004562:	a00d                	j	80004584 <fileclose+0x8a>
    80004564:	f04a                	sd	s2,32(sp)
    80004566:	ec4e                	sd	s3,24(sp)
    80004568:	e852                	sd	s4,16(sp)
    8000456a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000456c:	00003517          	auipc	a0,0x3
    80004570:	ffc50513          	addi	a0,a0,-4 # 80007568 <etext+0x568>
    80004574:	a6afc0ef          	jal	800007de <panic>
    release(&ftable.lock);
    80004578:	0001b517          	auipc	a0,0x1b
    8000457c:	70850513          	addi	a0,a0,1800 # 8001fc80 <ftable>
    80004580:	ee0fc0ef          	jal	80000c60 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004584:	70e2                	ld	ra,56(sp)
    80004586:	7442                	ld	s0,48(sp)
    80004588:	74a2                	ld	s1,40(sp)
    8000458a:	6121                	addi	sp,sp,64
    8000458c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000458e:	85d6                	mv	a1,s5
    80004590:	8552                	mv	a0,s4
    80004592:	340000ef          	jal	800048d2 <pipeclose>
    80004596:	7902                	ld	s2,32(sp)
    80004598:	69e2                	ld	s3,24(sp)
    8000459a:	6a42                	ld	s4,16(sp)
    8000459c:	6aa2                	ld	s5,8(sp)
    8000459e:	b7dd                	j	80004584 <fileclose+0x8a>
    begin_op();
    800045a0:	b49ff0ef          	jal	800040e8 <begin_op>
    iput(ff.ip);
    800045a4:	854e                	mv	a0,s3
    800045a6:	ac0ff0ef          	jal	80003866 <iput>
    end_op();
    800045aa:	ba9ff0ef          	jal	80004152 <end_op>
    800045ae:	7902                	ld	s2,32(sp)
    800045b0:	69e2                	ld	s3,24(sp)
    800045b2:	6a42                	ld	s4,16(sp)
    800045b4:	6aa2                	ld	s5,8(sp)
    800045b6:	b7f9                	j	80004584 <fileclose+0x8a>

00000000800045b8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800045b8:	715d                	addi	sp,sp,-80
    800045ba:	e486                	sd	ra,72(sp)
    800045bc:	e0a2                	sd	s0,64(sp)
    800045be:	fc26                	sd	s1,56(sp)
    800045c0:	f44e                	sd	s3,40(sp)
    800045c2:	0880                	addi	s0,sp,80
    800045c4:	84aa                	mv	s1,a0
    800045c6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800045c8:	af6fd0ef          	jal	800018be <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800045cc:	409c                	lw	a5,0(s1)
    800045ce:	37f9                	addiw	a5,a5,-2
    800045d0:	4705                	li	a4,1
    800045d2:	04f76263          	bltu	a4,a5,80004616 <filestat+0x5e>
    800045d6:	f84a                	sd	s2,48(sp)
    800045d8:	f052                	sd	s4,32(sp)
    800045da:	892a                	mv	s2,a0
    ilock(f->ip);
    800045dc:	6c88                	ld	a0,24(s1)
    800045de:	906ff0ef          	jal	800036e4 <ilock>
    stati(f->ip, &st);
    800045e2:	fb840a13          	addi	s4,s0,-72
    800045e6:	85d2                	mv	a1,s4
    800045e8:	6c88                	ld	a0,24(s1)
    800045ea:	c5eff0ef          	jal	80003a48 <stati>
    iunlock(f->ip);
    800045ee:	6c88                	ld	a0,24(s1)
    800045f0:	9a2ff0ef          	jal	80003792 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800045f4:	46e1                	li	a3,24
    800045f6:	8652                	mv	a2,s4
    800045f8:	85ce                	mv	a1,s3
    800045fa:	05893503          	ld	a0,88(s2)
    800045fe:	ff3fc0ef          	jal	800015f0 <copyout>
    80004602:	41f5551b          	sraiw	a0,a0,0x1f
    80004606:	7942                	ld	s2,48(sp)
    80004608:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000460a:	60a6                	ld	ra,72(sp)
    8000460c:	6406                	ld	s0,64(sp)
    8000460e:	74e2                	ld	s1,56(sp)
    80004610:	79a2                	ld	s3,40(sp)
    80004612:	6161                	addi	sp,sp,80
    80004614:	8082                	ret
  return -1;
    80004616:	557d                	li	a0,-1
    80004618:	bfcd                	j	8000460a <filestat+0x52>

000000008000461a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000461a:	7179                	addi	sp,sp,-48
    8000461c:	f406                	sd	ra,40(sp)
    8000461e:	f022                	sd	s0,32(sp)
    80004620:	e84a                	sd	s2,16(sp)
    80004622:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004624:	00854783          	lbu	a5,8(a0)
    80004628:	cfd1                	beqz	a5,800046c4 <fileread+0xaa>
    8000462a:	ec26                	sd	s1,24(sp)
    8000462c:	e44e                	sd	s3,8(sp)
    8000462e:	84aa                	mv	s1,a0
    80004630:	89ae                	mv	s3,a1
    80004632:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004634:	411c                	lw	a5,0(a0)
    80004636:	4705                	li	a4,1
    80004638:	04e78363          	beq	a5,a4,8000467e <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000463c:	470d                	li	a4,3
    8000463e:	04e78763          	beq	a5,a4,8000468c <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004642:	4709                	li	a4,2
    80004644:	06e79a63          	bne	a5,a4,800046b8 <fileread+0x9e>
    ilock(f->ip);
    80004648:	6d08                	ld	a0,24(a0)
    8000464a:	89aff0ef          	jal	800036e4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000464e:	874a                	mv	a4,s2
    80004650:	5094                	lw	a3,32(s1)
    80004652:	864e                	mv	a2,s3
    80004654:	4585                	li	a1,1
    80004656:	6c88                	ld	a0,24(s1)
    80004658:	c1eff0ef          	jal	80003a76 <readi>
    8000465c:	892a                	mv	s2,a0
    8000465e:	00a05563          	blez	a0,80004668 <fileread+0x4e>
      f->off += r;
    80004662:	509c                	lw	a5,32(s1)
    80004664:	9fa9                	addw	a5,a5,a0
    80004666:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004668:	6c88                	ld	a0,24(s1)
    8000466a:	928ff0ef          	jal	80003792 <iunlock>
    8000466e:	64e2                	ld	s1,24(sp)
    80004670:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004672:	854a                	mv	a0,s2
    80004674:	70a2                	ld	ra,40(sp)
    80004676:	7402                	ld	s0,32(sp)
    80004678:	6942                	ld	s2,16(sp)
    8000467a:	6145                	addi	sp,sp,48
    8000467c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000467e:	6908                	ld	a0,16(a0)
    80004680:	3a2000ef          	jal	80004a22 <piperead>
    80004684:	892a                	mv	s2,a0
    80004686:	64e2                	ld	s1,24(sp)
    80004688:	69a2                	ld	s3,8(sp)
    8000468a:	b7e5                	j	80004672 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000468c:	02451783          	lh	a5,36(a0)
    80004690:	03079693          	slli	a3,a5,0x30
    80004694:	92c1                	srli	a3,a3,0x30
    80004696:	4725                	li	a4,9
    80004698:	02d76863          	bltu	a4,a3,800046c8 <fileread+0xae>
    8000469c:	0792                	slli	a5,a5,0x4
    8000469e:	0001b717          	auipc	a4,0x1b
    800046a2:	54270713          	addi	a4,a4,1346 # 8001fbe0 <devsw>
    800046a6:	97ba                	add	a5,a5,a4
    800046a8:	639c                	ld	a5,0(a5)
    800046aa:	c39d                	beqz	a5,800046d0 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800046ac:	4505                	li	a0,1
    800046ae:	9782                	jalr	a5
    800046b0:	892a                	mv	s2,a0
    800046b2:	64e2                	ld	s1,24(sp)
    800046b4:	69a2                	ld	s3,8(sp)
    800046b6:	bf75                	j	80004672 <fileread+0x58>
    panic("fileread");
    800046b8:	00003517          	auipc	a0,0x3
    800046bc:	ec050513          	addi	a0,a0,-320 # 80007578 <etext+0x578>
    800046c0:	91efc0ef          	jal	800007de <panic>
    return -1;
    800046c4:	597d                	li	s2,-1
    800046c6:	b775                	j	80004672 <fileread+0x58>
      return -1;
    800046c8:	597d                	li	s2,-1
    800046ca:	64e2                	ld	s1,24(sp)
    800046cc:	69a2                	ld	s3,8(sp)
    800046ce:	b755                	j	80004672 <fileread+0x58>
    800046d0:	597d                	li	s2,-1
    800046d2:	64e2                	ld	s1,24(sp)
    800046d4:	69a2                	ld	s3,8(sp)
    800046d6:	bf71                	j	80004672 <fileread+0x58>

00000000800046d8 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800046d8:	00954783          	lbu	a5,9(a0)
    800046dc:	10078e63          	beqz	a5,800047f8 <filewrite+0x120>
{
    800046e0:	711d                	addi	sp,sp,-96
    800046e2:	ec86                	sd	ra,88(sp)
    800046e4:	e8a2                	sd	s0,80(sp)
    800046e6:	e0ca                	sd	s2,64(sp)
    800046e8:	f456                	sd	s5,40(sp)
    800046ea:	f05a                	sd	s6,32(sp)
    800046ec:	1080                	addi	s0,sp,96
    800046ee:	892a                	mv	s2,a0
    800046f0:	8b2e                	mv	s6,a1
    800046f2:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800046f4:	411c                	lw	a5,0(a0)
    800046f6:	4705                	li	a4,1
    800046f8:	02e78963          	beq	a5,a4,8000472a <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046fc:	470d                	li	a4,3
    800046fe:	02e78a63          	beq	a5,a4,80004732 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004702:	4709                	li	a4,2
    80004704:	0ce79e63          	bne	a5,a4,800047e0 <filewrite+0x108>
    80004708:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000470a:	0ac05963          	blez	a2,800047bc <filewrite+0xe4>
    8000470e:	e4a6                	sd	s1,72(sp)
    80004710:	fc4e                	sd	s3,56(sp)
    80004712:	ec5e                	sd	s7,24(sp)
    80004714:	e862                	sd	s8,16(sp)
    80004716:	e466                	sd	s9,8(sp)
    int i = 0;
    80004718:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    8000471a:	6b85                	lui	s7,0x1
    8000471c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004720:	6c85                	lui	s9,0x1
    80004722:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004726:	4c05                	li	s8,1
    80004728:	a8ad                	j	800047a2 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    8000472a:	6908                	ld	a0,16(a0)
    8000472c:	1fe000ef          	jal	8000492a <pipewrite>
    80004730:	a04d                	j	800047d2 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004732:	02451783          	lh	a5,36(a0)
    80004736:	03079693          	slli	a3,a5,0x30
    8000473a:	92c1                	srli	a3,a3,0x30
    8000473c:	4725                	li	a4,9
    8000473e:	0ad76f63          	bltu	a4,a3,800047fc <filewrite+0x124>
    80004742:	0792                	slli	a5,a5,0x4
    80004744:	0001b717          	auipc	a4,0x1b
    80004748:	49c70713          	addi	a4,a4,1180 # 8001fbe0 <devsw>
    8000474c:	97ba                	add	a5,a5,a4
    8000474e:	679c                	ld	a5,8(a5)
    80004750:	cbc5                	beqz	a5,80004800 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80004752:	4505                	li	a0,1
    80004754:	9782                	jalr	a5
    80004756:	a8b5                	j	800047d2 <filewrite+0xfa>
      if(n1 > max)
    80004758:	2981                	sext.w	s3,s3
      begin_op();
    8000475a:	98fff0ef          	jal	800040e8 <begin_op>
      ilock(f->ip);
    8000475e:	01893503          	ld	a0,24(s2)
    80004762:	f83fe0ef          	jal	800036e4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004766:	874e                	mv	a4,s3
    80004768:	02092683          	lw	a3,32(s2)
    8000476c:	016a0633          	add	a2,s4,s6
    80004770:	85e2                	mv	a1,s8
    80004772:	01893503          	ld	a0,24(s2)
    80004776:	bf2ff0ef          	jal	80003b68 <writei>
    8000477a:	84aa                	mv	s1,a0
    8000477c:	00a05763          	blez	a0,8000478a <filewrite+0xb2>
        f->off += r;
    80004780:	02092783          	lw	a5,32(s2)
    80004784:	9fa9                	addw	a5,a5,a0
    80004786:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000478a:	01893503          	ld	a0,24(s2)
    8000478e:	804ff0ef          	jal	80003792 <iunlock>
      end_op();
    80004792:	9c1ff0ef          	jal	80004152 <end_op>

      if(r != n1){
    80004796:	02999563          	bne	s3,s1,800047c0 <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    8000479a:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    8000479e:	015a5963          	bge	s4,s5,800047b0 <filewrite+0xd8>
      int n1 = n - i;
    800047a2:	414a87bb          	subw	a5,s5,s4
    800047a6:	89be                	mv	s3,a5
      if(n1 > max)
    800047a8:	fafbd8e3          	bge	s7,a5,80004758 <filewrite+0x80>
    800047ac:	89e6                	mv	s3,s9
    800047ae:	b76d                	j	80004758 <filewrite+0x80>
    800047b0:	64a6                	ld	s1,72(sp)
    800047b2:	79e2                	ld	s3,56(sp)
    800047b4:	6be2                	ld	s7,24(sp)
    800047b6:	6c42                	ld	s8,16(sp)
    800047b8:	6ca2                	ld	s9,8(sp)
    800047ba:	a801                	j	800047ca <filewrite+0xf2>
    int i = 0;
    800047bc:	4a01                	li	s4,0
    800047be:	a031                	j	800047ca <filewrite+0xf2>
    800047c0:	64a6                	ld	s1,72(sp)
    800047c2:	79e2                	ld	s3,56(sp)
    800047c4:	6be2                	ld	s7,24(sp)
    800047c6:	6c42                	ld	s8,16(sp)
    800047c8:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800047ca:	034a9d63          	bne	s5,s4,80004804 <filewrite+0x12c>
    800047ce:	8556                	mv	a0,s5
    800047d0:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800047d2:	60e6                	ld	ra,88(sp)
    800047d4:	6446                	ld	s0,80(sp)
    800047d6:	6906                	ld	s2,64(sp)
    800047d8:	7aa2                	ld	s5,40(sp)
    800047da:	7b02                	ld	s6,32(sp)
    800047dc:	6125                	addi	sp,sp,96
    800047de:	8082                	ret
    800047e0:	e4a6                	sd	s1,72(sp)
    800047e2:	fc4e                	sd	s3,56(sp)
    800047e4:	f852                	sd	s4,48(sp)
    800047e6:	ec5e                	sd	s7,24(sp)
    800047e8:	e862                	sd	s8,16(sp)
    800047ea:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800047ec:	00003517          	auipc	a0,0x3
    800047f0:	d9c50513          	addi	a0,a0,-612 # 80007588 <etext+0x588>
    800047f4:	febfb0ef          	jal	800007de <panic>
    return -1;
    800047f8:	557d                	li	a0,-1
}
    800047fa:	8082                	ret
      return -1;
    800047fc:	557d                	li	a0,-1
    800047fe:	bfd1                	j	800047d2 <filewrite+0xfa>
    80004800:	557d                	li	a0,-1
    80004802:	bfc1                	j	800047d2 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    80004804:	557d                	li	a0,-1
    80004806:	7a42                	ld	s4,48(sp)
    80004808:	b7e9                	j	800047d2 <filewrite+0xfa>

000000008000480a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000480a:	7179                	addi	sp,sp,-48
    8000480c:	f406                	sd	ra,40(sp)
    8000480e:	f022                	sd	s0,32(sp)
    80004810:	ec26                	sd	s1,24(sp)
    80004812:	e052                	sd	s4,0(sp)
    80004814:	1800                	addi	s0,sp,48
    80004816:	84aa                	mv	s1,a0
    80004818:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000481a:	0005b023          	sd	zero,0(a1)
    8000481e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004822:	c35ff0ef          	jal	80004456 <filealloc>
    80004826:	e088                	sd	a0,0(s1)
    80004828:	c549                	beqz	a0,800048b2 <pipealloc+0xa8>
    8000482a:	c2dff0ef          	jal	80004456 <filealloc>
    8000482e:	00aa3023          	sd	a0,0(s4)
    80004832:	cd25                	beqz	a0,800048aa <pipealloc+0xa0>
    80004834:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004836:	ac2fc0ef          	jal	80000af8 <kalloc>
    8000483a:	892a                	mv	s2,a0
    8000483c:	c12d                	beqz	a0,8000489e <pipealloc+0x94>
    8000483e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004840:	4985                	li	s3,1
    80004842:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004846:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000484a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000484e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004852:	00003597          	auipc	a1,0x3
    80004856:	d4658593          	addi	a1,a1,-698 # 80007598 <etext+0x598>
    8000485a:	aeefc0ef          	jal	80000b48 <initlock>
  (*f0)->type = FD_PIPE;
    8000485e:	609c                	ld	a5,0(s1)
    80004860:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004864:	609c                	ld	a5,0(s1)
    80004866:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000486a:	609c                	ld	a5,0(s1)
    8000486c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004870:	609c                	ld	a5,0(s1)
    80004872:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004876:	000a3783          	ld	a5,0(s4)
    8000487a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000487e:	000a3783          	ld	a5,0(s4)
    80004882:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004886:	000a3783          	ld	a5,0(s4)
    8000488a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000488e:	000a3783          	ld	a5,0(s4)
    80004892:	0127b823          	sd	s2,16(a5)
  return 0;
    80004896:	4501                	li	a0,0
    80004898:	6942                	ld	s2,16(sp)
    8000489a:	69a2                	ld	s3,8(sp)
    8000489c:	a01d                	j	800048c2 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000489e:	6088                	ld	a0,0(s1)
    800048a0:	c119                	beqz	a0,800048a6 <pipealloc+0x9c>
    800048a2:	6942                	ld	s2,16(sp)
    800048a4:	a029                	j	800048ae <pipealloc+0xa4>
    800048a6:	6942                	ld	s2,16(sp)
    800048a8:	a029                	j	800048b2 <pipealloc+0xa8>
    800048aa:	6088                	ld	a0,0(s1)
    800048ac:	c10d                	beqz	a0,800048ce <pipealloc+0xc4>
    fileclose(*f0);
    800048ae:	c4dff0ef          	jal	800044fa <fileclose>
  if(*f1)
    800048b2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800048b6:	557d                	li	a0,-1
  if(*f1)
    800048b8:	c789                	beqz	a5,800048c2 <pipealloc+0xb8>
    fileclose(*f1);
    800048ba:	853e                	mv	a0,a5
    800048bc:	c3fff0ef          	jal	800044fa <fileclose>
  return -1;
    800048c0:	557d                	li	a0,-1
}
    800048c2:	70a2                	ld	ra,40(sp)
    800048c4:	7402                	ld	s0,32(sp)
    800048c6:	64e2                	ld	s1,24(sp)
    800048c8:	6a02                	ld	s4,0(sp)
    800048ca:	6145                	addi	sp,sp,48
    800048cc:	8082                	ret
  return -1;
    800048ce:	557d                	li	a0,-1
    800048d0:	bfcd                	j	800048c2 <pipealloc+0xb8>

00000000800048d2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800048d2:	1101                	addi	sp,sp,-32
    800048d4:	ec06                	sd	ra,24(sp)
    800048d6:	e822                	sd	s0,16(sp)
    800048d8:	e426                	sd	s1,8(sp)
    800048da:	e04a                	sd	s2,0(sp)
    800048dc:	1000                	addi	s0,sp,32
    800048de:	84aa                	mv	s1,a0
    800048e0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800048e2:	aeafc0ef          	jal	80000bcc <acquire>
  if(writable){
    800048e6:	02090763          	beqz	s2,80004914 <pipeclose+0x42>
    pi->writeopen = 0;
    800048ea:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800048ee:	21848513          	addi	a0,s1,536
    800048f2:	f30fd0ef          	jal	80002022 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048f6:	2204b783          	ld	a5,544(s1)
    800048fa:	e785                	bnez	a5,80004922 <pipeclose+0x50>
    release(&pi->lock);
    800048fc:	8526                	mv	a0,s1
    800048fe:	b62fc0ef          	jal	80000c60 <release>
    kfree((char*)pi);
    80004902:	8526                	mv	a0,s1
    80004904:	912fc0ef          	jal	80000a16 <kfree>
  } else
    release(&pi->lock);
}
    80004908:	60e2                	ld	ra,24(sp)
    8000490a:	6442                	ld	s0,16(sp)
    8000490c:	64a2                	ld	s1,8(sp)
    8000490e:	6902                	ld	s2,0(sp)
    80004910:	6105                	addi	sp,sp,32
    80004912:	8082                	ret
    pi->readopen = 0;
    80004914:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004918:	21c48513          	addi	a0,s1,540
    8000491c:	f06fd0ef          	jal	80002022 <wakeup>
    80004920:	bfd9                	j	800048f6 <pipeclose+0x24>
    release(&pi->lock);
    80004922:	8526                	mv	a0,s1
    80004924:	b3cfc0ef          	jal	80000c60 <release>
}
    80004928:	b7c5                	j	80004908 <pipeclose+0x36>

000000008000492a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000492a:	7159                	addi	sp,sp,-112
    8000492c:	f486                	sd	ra,104(sp)
    8000492e:	f0a2                	sd	s0,96(sp)
    80004930:	eca6                	sd	s1,88(sp)
    80004932:	e8ca                	sd	s2,80(sp)
    80004934:	e4ce                	sd	s3,72(sp)
    80004936:	e0d2                	sd	s4,64(sp)
    80004938:	fc56                	sd	s5,56(sp)
    8000493a:	1880                	addi	s0,sp,112
    8000493c:	84aa                	mv	s1,a0
    8000493e:	8aae                	mv	s5,a1
    80004940:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004942:	f7dfc0ef          	jal	800018be <myproc>
    80004946:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004948:	8526                	mv	a0,s1
    8000494a:	a82fc0ef          	jal	80000bcc <acquire>
  while(i < n){
    8000494e:	0d405263          	blez	s4,80004a12 <pipewrite+0xe8>
    80004952:	f85a                	sd	s6,48(sp)
    80004954:	f45e                	sd	s7,40(sp)
    80004956:	f062                	sd	s8,32(sp)
    80004958:	ec66                	sd	s9,24(sp)
    8000495a:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000495c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000495e:	f9f40c13          	addi	s8,s0,-97
    80004962:	4b85                	li	s7,1
    80004964:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004966:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000496a:	21c48c93          	addi	s9,s1,540
    8000496e:	a82d                	j	800049a8 <pipewrite+0x7e>
      release(&pi->lock);
    80004970:	8526                	mv	a0,s1
    80004972:	aeefc0ef          	jal	80000c60 <release>
      return -1;
    80004976:	597d                	li	s2,-1
    80004978:	7b42                	ld	s6,48(sp)
    8000497a:	7ba2                	ld	s7,40(sp)
    8000497c:	7c02                	ld	s8,32(sp)
    8000497e:	6ce2                	ld	s9,24(sp)
    80004980:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004982:	854a                	mv	a0,s2
    80004984:	70a6                	ld	ra,104(sp)
    80004986:	7406                	ld	s0,96(sp)
    80004988:	64e6                	ld	s1,88(sp)
    8000498a:	6946                	ld	s2,80(sp)
    8000498c:	69a6                	ld	s3,72(sp)
    8000498e:	6a06                	ld	s4,64(sp)
    80004990:	7ae2                	ld	s5,56(sp)
    80004992:	6165                	addi	sp,sp,112
    80004994:	8082                	ret
      wakeup(&pi->nread);
    80004996:	856a                	mv	a0,s10
    80004998:	e8afd0ef          	jal	80002022 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000499c:	85a6                	mv	a1,s1
    8000499e:	8566                	mv	a0,s9
    800049a0:	e36fd0ef          	jal	80001fd6 <sleep>
  while(i < n){
    800049a4:	05495a63          	bge	s2,s4,800049f8 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800049a8:	2204a783          	lw	a5,544(s1)
    800049ac:	d3f1                	beqz	a5,80004970 <pipewrite+0x46>
    800049ae:	854e                	mv	a0,s3
    800049b0:	8fffd0ef          	jal	800022ae <killed>
    800049b4:	fd55                	bnez	a0,80004970 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800049b6:	2184a783          	lw	a5,536(s1)
    800049ba:	21c4a703          	lw	a4,540(s1)
    800049be:	2007879b          	addiw	a5,a5,512
    800049c2:	fcf70ae3          	beq	a4,a5,80004996 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800049c6:	86de                	mv	a3,s7
    800049c8:	01590633          	add	a2,s2,s5
    800049cc:	85e2                	mv	a1,s8
    800049ce:	0589b503          	ld	a0,88(s3)
    800049d2:	cddfc0ef          	jal	800016ae <copyin>
    800049d6:	05650063          	beq	a0,s6,80004a16 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800049da:	21c4a783          	lw	a5,540(s1)
    800049de:	0017871b          	addiw	a4,a5,1
    800049e2:	20e4ae23          	sw	a4,540(s1)
    800049e6:	1ff7f793          	andi	a5,a5,511
    800049ea:	97a6                	add	a5,a5,s1
    800049ec:	f9f44703          	lbu	a4,-97(s0)
    800049f0:	00e78c23          	sb	a4,24(a5)
      i++;
    800049f4:	2905                	addiw	s2,s2,1
    800049f6:	b77d                	j	800049a4 <pipewrite+0x7a>
    800049f8:	7b42                	ld	s6,48(sp)
    800049fa:	7ba2                	ld	s7,40(sp)
    800049fc:	7c02                	ld	s8,32(sp)
    800049fe:	6ce2                	ld	s9,24(sp)
    80004a00:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004a02:	21848513          	addi	a0,s1,536
    80004a06:	e1cfd0ef          	jal	80002022 <wakeup>
  release(&pi->lock);
    80004a0a:	8526                	mv	a0,s1
    80004a0c:	a54fc0ef          	jal	80000c60 <release>
  return i;
    80004a10:	bf8d                	j	80004982 <pipewrite+0x58>
  int i = 0;
    80004a12:	4901                	li	s2,0
    80004a14:	b7fd                	j	80004a02 <pipewrite+0xd8>
    80004a16:	7b42                	ld	s6,48(sp)
    80004a18:	7ba2                	ld	s7,40(sp)
    80004a1a:	7c02                	ld	s8,32(sp)
    80004a1c:	6ce2                	ld	s9,24(sp)
    80004a1e:	6d42                	ld	s10,16(sp)
    80004a20:	b7cd                	j	80004a02 <pipewrite+0xd8>

0000000080004a22 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004a22:	711d                	addi	sp,sp,-96
    80004a24:	ec86                	sd	ra,88(sp)
    80004a26:	e8a2                	sd	s0,80(sp)
    80004a28:	e4a6                	sd	s1,72(sp)
    80004a2a:	e0ca                	sd	s2,64(sp)
    80004a2c:	fc4e                	sd	s3,56(sp)
    80004a2e:	f852                	sd	s4,48(sp)
    80004a30:	f456                	sd	s5,40(sp)
    80004a32:	1080                	addi	s0,sp,96
    80004a34:	84aa                	mv	s1,a0
    80004a36:	892e                	mv	s2,a1
    80004a38:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004a3a:	e85fc0ef          	jal	800018be <myproc>
    80004a3e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004a40:	8526                	mv	a0,s1
    80004a42:	98afc0ef          	jal	80000bcc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a46:	2184a703          	lw	a4,536(s1)
    80004a4a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a4e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a52:	02f71763          	bne	a4,a5,80004a80 <piperead+0x5e>
    80004a56:	2244a783          	lw	a5,548(s1)
    80004a5a:	cf85                	beqz	a5,80004a92 <piperead+0x70>
    if(killed(pr)){
    80004a5c:	8552                	mv	a0,s4
    80004a5e:	851fd0ef          	jal	800022ae <killed>
    80004a62:	e11d                	bnez	a0,80004a88 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a64:	85a6                	mv	a1,s1
    80004a66:	854e                	mv	a0,s3
    80004a68:	d6efd0ef          	jal	80001fd6 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a6c:	2184a703          	lw	a4,536(s1)
    80004a70:	21c4a783          	lw	a5,540(s1)
    80004a74:	fef701e3          	beq	a4,a5,80004a56 <piperead+0x34>
    80004a78:	f05a                	sd	s6,32(sp)
    80004a7a:	ec5e                	sd	s7,24(sp)
    80004a7c:	e862                	sd	s8,16(sp)
    80004a7e:	a829                	j	80004a98 <piperead+0x76>
    80004a80:	f05a                	sd	s6,32(sp)
    80004a82:	ec5e                	sd	s7,24(sp)
    80004a84:	e862                	sd	s8,16(sp)
    80004a86:	a809                	j	80004a98 <piperead+0x76>
      release(&pi->lock);
    80004a88:	8526                	mv	a0,s1
    80004a8a:	9d6fc0ef          	jal	80000c60 <release>
      return -1;
    80004a8e:	59fd                	li	s3,-1
    80004a90:	a0ad                	j	80004afa <piperead+0xd8>
    80004a92:	f05a                	sd	s6,32(sp)
    80004a94:	ec5e                	sd	s7,24(sp)
    80004a96:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a98:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004a9a:	faf40c13          	addi	s8,s0,-81
    80004a9e:	4b85                	li	s7,1
    80004aa0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004aa2:	05505263          	blez	s5,80004ae6 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004aa6:	2184a783          	lw	a5,536(s1)
    80004aaa:	21c4a703          	lw	a4,540(s1)
    80004aae:	02f70c63          	beq	a4,a5,80004ae6 <piperead+0xc4>
    ch = pi->data[pi->nread % PIPESIZE];
    80004ab2:	1ff7f793          	andi	a5,a5,511
    80004ab6:	97a6                	add	a5,a5,s1
    80004ab8:	0187c783          	lbu	a5,24(a5)
    80004abc:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004ac0:	86de                	mv	a3,s7
    80004ac2:	8662                	mv	a2,s8
    80004ac4:	85ca                	mv	a1,s2
    80004ac6:	058a3503          	ld	a0,88(s4)
    80004aca:	b27fc0ef          	jal	800015f0 <copyout>
    80004ace:	05650063          	beq	a0,s6,80004b0e <piperead+0xec>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80004ad2:	2184a783          	lw	a5,536(s1)
    80004ad6:	2785                	addiw	a5,a5,1
    80004ad8:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004adc:	2985                	addiw	s3,s3,1
    80004ade:	0905                	addi	s2,s2,1
    80004ae0:	fd3a93e3          	bne	s5,s3,80004aa6 <piperead+0x84>
    80004ae4:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004ae6:	21c48513          	addi	a0,s1,540
    80004aea:	d38fd0ef          	jal	80002022 <wakeup>
  release(&pi->lock);
    80004aee:	8526                	mv	a0,s1
    80004af0:	970fc0ef          	jal	80000c60 <release>
    80004af4:	7b02                	ld	s6,32(sp)
    80004af6:	6be2                	ld	s7,24(sp)
    80004af8:	6c42                	ld	s8,16(sp)
  return i;
}
    80004afa:	854e                	mv	a0,s3
    80004afc:	60e6                	ld	ra,88(sp)
    80004afe:	6446                	ld	s0,80(sp)
    80004b00:	64a6                	ld	s1,72(sp)
    80004b02:	6906                	ld	s2,64(sp)
    80004b04:	79e2                	ld	s3,56(sp)
    80004b06:	7a42                	ld	s4,48(sp)
    80004b08:	7aa2                	ld	s5,40(sp)
    80004b0a:	6125                	addi	sp,sp,96
    80004b0c:	8082                	ret
      if(i == 0)
    80004b0e:	fc099ce3          	bnez	s3,80004ae6 <piperead+0xc4>
        i = -1;
    80004b12:	89aa                	mv	s3,a0
    80004b14:	bfc9                	j	80004ae6 <piperead+0xc4>

0000000080004b16 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004b16:	1141                	addi	sp,sp,-16
    80004b18:	e406                	sd	ra,8(sp)
    80004b1a:	e022                	sd	s0,0(sp)
    80004b1c:	0800                	addi	s0,sp,16
    80004b1e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004b20:	0035151b          	slliw	a0,a0,0x3
    80004b24:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80004b26:	8b89                	andi	a5,a5,2
    80004b28:	c399                	beqz	a5,80004b2e <flags2perm+0x18>
      perm |= PTE_W;
    80004b2a:	00456513          	ori	a0,a0,4
    return perm;
}
    80004b2e:	60a2                	ld	ra,8(sp)
    80004b30:	6402                	ld	s0,0(sp)
    80004b32:	0141                	addi	sp,sp,16
    80004b34:	8082                	ret

0000000080004b36 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004b36:	de010113          	addi	sp,sp,-544
    80004b3a:	20113c23          	sd	ra,536(sp)
    80004b3e:	20813823          	sd	s0,528(sp)
    80004b42:	20913423          	sd	s1,520(sp)
    80004b46:	1400                	addi	s0,sp,544
    80004b48:	84aa                	mv	s1,a0
    80004b4a:	dea43823          	sd	a0,-528(s0)
    80004b4e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004b52:	d6dfc0ef          	jal	800018be <myproc>

  // If threads being used, cannot do exec()
  if (p->pid != p->tgid || p->thread_count > 1)
    80004b56:	5918                	lw	a4,48(a0)
    80004b58:	595c                	lw	a5,52(a0)
    80004b5a:	34f71e63          	bne	a4,a5,80004eb6 <kexec+0x380>
    80004b5e:	e3ea                	sd	s10,448(sp)
    80004b60:	8d2a                	mv	s10,a0
    80004b62:	5d18                	lw	a4,56(a0)
    80004b64:	4785                	li	a5,1
    80004b66:	34e7ca63          	blt	a5,a4,80004eba <kexec+0x384>
    80004b6a:	fbd2                	sd	s4,496(sp)
    return -1;

  begin_op();
    80004b6c:	d7cff0ef          	jal	800040e8 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80004b70:	8526                	mv	a0,s1
    80004b72:	b9cff0ef          	jal	80003f0e <namei>
    80004b76:	8a2a                	mv	s4,a0
    80004b78:	c929                	beqz	a0,80004bca <kexec+0x94>
    end_op();
    return -1;
  }
  ilock(ip);
    80004b7a:	b6bfe0ef          	jal	800036e4 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004b7e:	04000713          	li	a4,64
    80004b82:	4681                	li	a3,0
    80004b84:	e5040613          	addi	a2,s0,-432
    80004b88:	4581                	li	a1,0
    80004b8a:	8552                	mv	a0,s4
    80004b8c:	eebfe0ef          	jal	80003a76 <readi>
    80004b90:	04000793          	li	a5,64
    80004b94:	00f51a63          	bne	a0,a5,80004ba8 <kexec+0x72>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80004b98:	e5042703          	lw	a4,-432(s0)
    80004b9c:	464c47b7          	lui	a5,0x464c4
    80004ba0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004ba4:	02f70963          	beq	a4,a5,80004bd6 <kexec+0xa0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz, (int) (p - proc));
  if(ip){
    iunlockput(ip);
    80004ba8:	8552                	mv	a0,s4
    80004baa:	d45fe0ef          	jal	800038ee <iunlockput>
    end_op();
    80004bae:	da4ff0ef          	jal	80004152 <end_op>
  }
  return -1;
    80004bb2:	557d                	li	a0,-1
    80004bb4:	7a5e                	ld	s4,496(sp)
    80004bb6:	6d1e                	ld	s10,448(sp)
}
    80004bb8:	21813083          	ld	ra,536(sp)
    80004bbc:	21013403          	ld	s0,528(sp)
    80004bc0:	20813483          	ld	s1,520(sp)
    80004bc4:	22010113          	addi	sp,sp,544
    80004bc8:	8082                	ret
    end_op();
    80004bca:	d88ff0ef          	jal	80004152 <end_op>
    return -1;
    80004bce:	557d                	li	a0,-1
    80004bd0:	7a5e                	ld	s4,496(sp)
    80004bd2:	6d1e                	ld	s10,448(sp)
    80004bd4:	b7d5                	j	80004bb8 <kexec+0x82>
    80004bd6:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004bd8:	856a                	mv	a0,s10
    80004bda:	debfc0ef          	jal	800019c4 <proc_pagetable>
    80004bde:	8b2a                	mv	s6,a0
    80004be0:	2c050963          	beqz	a0,80004eb2 <kexec+0x37c>
    80004be4:	21213023          	sd	s2,512(sp)
    80004be8:	ffce                	sd	s3,504(sp)
    80004bea:	f7d6                	sd	s5,488(sp)
    80004bec:	efde                	sd	s7,472(sp)
    80004bee:	ebe2                	sd	s8,464(sp)
    80004bf0:	e7e6                	sd	s9,456(sp)
    80004bf2:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bf4:	e7042683          	lw	a3,-400(s0)
    80004bf8:	e8845783          	lhu	a5,-376(s0)
    80004bfc:	0e078863          	beqz	a5,80004cec <kexec+0x1b6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004c00:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c02:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004c04:	6c85                	lui	s9,0x1
    80004c06:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004c0a:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004c0e:	6a85                	lui	s5,0x1
    80004c10:	a085                	j	80004c70 <kexec+0x13a>
      panic("loadseg: address should exist");
    80004c12:	00003517          	auipc	a0,0x3
    80004c16:	98e50513          	addi	a0,a0,-1650 # 800075a0 <etext+0x5a0>
    80004c1a:	bc5fb0ef          	jal	800007de <panic>
    if(sz - i < PGSIZE)
    80004c1e:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004c20:	874a                	mv	a4,s2
    80004c22:	009c06bb          	addw	a3,s8,s1
    80004c26:	4581                	li	a1,0
    80004c28:	8552                	mv	a0,s4
    80004c2a:	e4dfe0ef          	jal	80003a76 <readi>
    80004c2e:	28a91b63          	bne	s2,a0,80004ec4 <kexec+0x38e>
  for(i = 0; i < sz; i += PGSIZE){
    80004c32:	009a84bb          	addw	s1,s5,s1
    80004c36:	0334f263          	bgeu	s1,s3,80004c5a <kexec+0x124>
    pa = walkaddr(pagetable, va + i);
    80004c3a:	02049593          	slli	a1,s1,0x20
    80004c3e:	9181                	srli	a1,a1,0x20
    80004c40:	95de                	add	a1,a1,s7
    80004c42:	855a                	mv	a0,s6
    80004c44:	b86fc0ef          	jal	80000fca <walkaddr>
    80004c48:	862a                	mv	a2,a0
    if(pa == 0)
    80004c4a:	d561                	beqz	a0,80004c12 <kexec+0xdc>
    if(sz - i < PGSIZE)
    80004c4c:	409987bb          	subw	a5,s3,s1
    80004c50:	893e                	mv	s2,a5
    80004c52:	fcfcf6e3          	bgeu	s9,a5,80004c1e <kexec+0xe8>
    80004c56:	8956                	mv	s2,s5
    80004c58:	b7d9                	j	80004c1e <kexec+0xe8>
    sz = sz1;
    80004c5a:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c5e:	2d85                	addiw	s11,s11,1
    80004c60:	e0843783          	ld	a5,-504(s0)
    80004c64:	0387869b          	addiw	a3,a5,56
    80004c68:	e8845783          	lhu	a5,-376(s0)
    80004c6c:	08fdd163          	bge	s11,a5,80004cee <kexec+0x1b8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004c70:	e0d43423          	sd	a3,-504(s0)
    80004c74:	03800713          	li	a4,56
    80004c78:	e1840613          	addi	a2,s0,-488
    80004c7c:	4581                	li	a1,0
    80004c7e:	8552                	mv	a0,s4
    80004c80:	df7fe0ef          	jal	80003a76 <readi>
    80004c84:	03800793          	li	a5,56
    80004c88:	22f51c63          	bne	a0,a5,80004ec0 <kexec+0x38a>
    if(ph.type != ELF_PROG_LOAD)
    80004c8c:	e1842783          	lw	a5,-488(s0)
    80004c90:	4705                	li	a4,1
    80004c92:	fce796e3          	bne	a5,a4,80004c5e <kexec+0x128>
    if(ph.memsz < ph.filesz)
    80004c96:	e4043483          	ld	s1,-448(s0)
    80004c9a:	e3843783          	ld	a5,-456(s0)
    80004c9e:	26f4e563          	bltu	s1,a5,80004f08 <kexec+0x3d2>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004ca2:	e2843783          	ld	a5,-472(s0)
    80004ca6:	94be                	add	s1,s1,a5
    80004ca8:	26f4e363          	bltu	s1,a5,80004f0e <kexec+0x3d8>
    if(ph.vaddr % PGSIZE != 0)
    80004cac:	de843703          	ld	a4,-536(s0)
    80004cb0:	8ff9                	and	a5,a5,a4
    80004cb2:	26079163          	bnez	a5,80004f14 <kexec+0x3de>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004cb6:	e1c42503          	lw	a0,-484(s0)
    80004cba:	e5dff0ef          	jal	80004b16 <flags2perm>
    80004cbe:	86aa                	mv	a3,a0
    80004cc0:	8626                	mv	a2,s1
    80004cc2:	85ca                	mv	a1,s2
    80004cc4:	855a                	mv	a0,s6
    80004cc6:	ddcfc0ef          	jal	800012a2 <uvmalloc>
    80004cca:	dea43c23          	sd	a0,-520(s0)
    80004cce:	24050663          	beqz	a0,80004f1a <kexec+0x3e4>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004cd2:	e2843b83          	ld	s7,-472(s0)
    80004cd6:	e2042c03          	lw	s8,-480(s0)
    80004cda:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004cde:	00098463          	beqz	s3,80004ce6 <kexec+0x1b0>
    80004ce2:	4481                	li	s1,0
    80004ce4:	bf99                	j	80004c3a <kexec+0x104>
    sz = sz1;
    80004ce6:	df843903          	ld	s2,-520(s0)
    80004cea:	bf95                	j	80004c5e <kexec+0x128>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004cec:	4901                	li	s2,0
  iunlockput(ip);
    80004cee:	8552                	mv	a0,s4
    80004cf0:	bfffe0ef          	jal	800038ee <iunlockput>
  end_op();
    80004cf4:	c5eff0ef          	jal	80004152 <end_op>
  p = myproc();
    80004cf8:	bc7fc0ef          	jal	800018be <myproc>
    80004cfc:	8a2a                	mv	s4,a0
  uint64 oldsz = p->sz;
    80004cfe:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80004d02:	6985                	lui	s3,0x1
    80004d04:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004d06:	99ca                	add	s3,s3,s2
    80004d08:	77fd                	lui	a5,0xfffff
    80004d0a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004d0e:	4691                	li	a3,4
    80004d10:	6609                	lui	a2,0x2
    80004d12:	964e                	add	a2,a2,s3
    80004d14:	85ce                	mv	a1,s3
    80004d16:	855a                	mv	a0,s6
    80004d18:	d8afc0ef          	jal	800012a2 <uvmalloc>
    80004d1c:	8aaa                	mv	s5,a0
    80004d1e:	e529                	bnez	a0,80004d68 <kexec+0x232>
    proc_freepagetable(pagetable, sz, (int) (p - proc));
    80004d20:	0000b797          	auipc	a5,0xb
    80004d24:	07878793          	addi	a5,a5,120 # 8000fd98 <proc>
    80004d28:	40fa07b3          	sub	a5,s4,a5
    80004d2c:	8791                	srai	a5,a5,0x4
    80004d2e:	e9bd3737          	lui	a4,0xe9bd3
    80004d32:	7a770713          	addi	a4,a4,1959 # ffffffffe9bd37a7 <end+0xffffffff69bb2a2f>
    80004d36:	d37a7637          	lui	a2,0xd37a7
    80004d3a:	f4e60613          	addi	a2,a2,-178 # ffffffffd37a6f4e <end+0xffffffff537861d6>
    80004d3e:	1602                	slli	a2,a2,0x20
    80004d40:	963a                	add	a2,a2,a4
    80004d42:	02c7863b          	mulw	a2,a5,a2
    80004d46:	85ce                	mv	a1,s3
    80004d48:	855a                	mv	a0,s6
    80004d4a:	d2dfc0ef          	jal	80001a76 <proc_freepagetable>
  return -1;
    80004d4e:	557d                	li	a0,-1
    80004d50:	20013903          	ld	s2,512(sp)
    80004d54:	79fe                	ld	s3,504(sp)
    80004d56:	7a5e                	ld	s4,496(sp)
    80004d58:	7abe                	ld	s5,488(sp)
    80004d5a:	7b1e                	ld	s6,480(sp)
    80004d5c:	6bfe                	ld	s7,472(sp)
    80004d5e:	6c5e                	ld	s8,464(sp)
    80004d60:	6cbe                	ld	s9,456(sp)
    80004d62:	6d1e                	ld	s10,448(sp)
    80004d64:	7dfa                	ld	s11,440(sp)
    80004d66:	bd89                	j	80004bb8 <kexec+0x82>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004d68:	75f9                	lui	a1,0xffffe
    80004d6a:	95aa                	add	a1,a1,a0
    80004d6c:	855a                	mv	a0,s6
    80004d6e:	f16fc0ef          	jal	80001484 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004d72:	7bfd                	lui	s7,0xfffff
    80004d74:	9bd6                	add	s7,s7,s5
  for(argc = 0; argv[argc]; argc++) {
    80004d76:	e0043783          	ld	a5,-512(s0)
    80004d7a:	6388                	ld	a0,0(a5)
  sp = sz;
    80004d7c:	8956                	mv	s2,s5
  for(argc = 0; argv[argc]; argc++) {
    80004d7e:	4481                	li	s1,0
    ustack[argc] = sp;
    80004d80:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80004d84:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80004d88:	cd21                	beqz	a0,80004de0 <kexec+0x2aa>
    sp -= strlen(argv[argc]) + 1;
    80004d8a:	89afc0ef          	jal	80000e24 <strlen>
    80004d8e:	0015079b          	addiw	a5,a0,1
    80004d92:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004d96:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004d9a:	19796363          	bltu	s2,s7,80004f20 <kexec+0x3ea>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004d9e:	e0043d83          	ld	s11,-512(s0)
    80004da2:	000db983          	ld	s3,0(s11)
    80004da6:	854e                	mv	a0,s3
    80004da8:	87cfc0ef          	jal	80000e24 <strlen>
    80004dac:	0015069b          	addiw	a3,a0,1
    80004db0:	864e                	mv	a2,s3
    80004db2:	85ca                	mv	a1,s2
    80004db4:	855a                	mv	a0,s6
    80004db6:	83bfc0ef          	jal	800015f0 <copyout>
    80004dba:	16054563          	bltz	a0,80004f24 <kexec+0x3ee>
    ustack[argc] = sp;
    80004dbe:	00349793          	slli	a5,s1,0x3
    80004dc2:	97e6                	add	a5,a5,s9
    80004dc4:	0127b023          	sd	s2,0(a5)
  for(argc = 0; argv[argc]; argc++) {
    80004dc8:	0485                	addi	s1,s1,1
    80004dca:	008d8793          	addi	a5,s11,8
    80004dce:	e0f43023          	sd	a5,-512(s0)
    80004dd2:	008db503          	ld	a0,8(s11)
    80004dd6:	c509                	beqz	a0,80004de0 <kexec+0x2aa>
    if(argc >= MAXARG)
    80004dd8:	fb8499e3          	bne	s1,s8,80004d8a <kexec+0x254>
  sz = sz1;
    80004ddc:	89d6                	mv	s3,s5
    80004dde:	b789                	j	80004d20 <kexec+0x1ea>
  ustack[argc] = 0;
    80004de0:	00349793          	slli	a5,s1,0x3
    80004de4:	f9078793          	addi	a5,a5,-112
    80004de8:	97a2                	add	a5,a5,s0
    80004dea:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004dee:	00148693          	addi	a3,s1,1
    80004df2:	068e                	slli	a3,a3,0x3
    80004df4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004df8:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004dfc:	89d6                	mv	s3,s5
  if(sp < stackbase)
    80004dfe:	f37961e3          	bltu	s2,s7,80004d20 <kexec+0x1ea>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004e02:	e9040613          	addi	a2,s0,-368
    80004e06:	85ca                	mv	a1,s2
    80004e08:	855a                	mv	a0,s6
    80004e0a:	fe6fc0ef          	jal	800015f0 <copyout>
    80004e0e:	f00549e3          	bltz	a0,80004d20 <kexec+0x1ea>
  p->trapframe->a1 = sp;
    80004e12:	060a3783          	ld	a5,96(s4)
    80004e16:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004e1a:	df043783          	ld	a5,-528(s0)
    80004e1e:	0007c703          	lbu	a4,0(a5)
    80004e22:	cf11                	beqz	a4,80004e3e <kexec+0x308>
    80004e24:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004e26:	02f00693          	li	a3,47
    80004e2a:	a029                	j	80004e34 <kexec+0x2fe>
  for(last=s=path; *s; s++)
    80004e2c:	0785                	addi	a5,a5,1
    80004e2e:	fff7c703          	lbu	a4,-1(a5)
    80004e32:	c711                	beqz	a4,80004e3e <kexec+0x308>
    if(*s == '/')
    80004e34:	fed71ce3          	bne	a4,a3,80004e2c <kexec+0x2f6>
      last = s+1;
    80004e38:	def43823          	sd	a5,-528(s0)
    80004e3c:	bfc5                	j	80004e2c <kexec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004e3e:	4641                	li	a2,16
    80004e40:	df043583          	ld	a1,-528(s0)
    80004e44:	160a0513          	addi	a0,s4,352
    80004e48:	fa7fb0ef          	jal	80000dee <safestrcpy>
  oldpagetable = p->pagetable;
    80004e4c:	058a3503          	ld	a0,88(s4)
  p->pagetable = pagetable;
    80004e50:	056a3c23          	sd	s6,88(s4)
  p->sz = sz;
    80004e54:	055a3823          	sd	s5,80(s4)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80004e58:	060a3783          	ld	a5,96(s4)
    80004e5c:	e6843703          	ld	a4,-408(s0)
    80004e60:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004e62:	060a3783          	ld	a5,96(s4)
    80004e66:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz, (int) (p - proc));
    80004e6a:	0000b617          	auipc	a2,0xb
    80004e6e:	f2e60613          	addi	a2,a2,-210 # 8000fd98 <proc>
    80004e72:	40ca0633          	sub	a2,s4,a2
    80004e76:	8611                	srai	a2,a2,0x4
    80004e78:	e9bd3737          	lui	a4,0xe9bd3
    80004e7c:	7a770713          	addi	a4,a4,1959 # ffffffffe9bd37a7 <end+0xffffffff69bb2a2f>
    80004e80:	d37a77b7          	lui	a5,0xd37a7
    80004e84:	f4e78793          	addi	a5,a5,-178 # ffffffffd37a6f4e <end+0xffffffff537861d6>
    80004e88:	1782                	slli	a5,a5,0x20
    80004e8a:	97ba                	add	a5,a5,a4
    80004e8c:	02f6063b          	mulw	a2,a2,a5
    80004e90:	85ea                	mv	a1,s10
    80004e92:	be5fc0ef          	jal	80001a76 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004e96:	0004851b          	sext.w	a0,s1
    80004e9a:	20013903          	ld	s2,512(sp)
    80004e9e:	79fe                	ld	s3,504(sp)
    80004ea0:	7a5e                	ld	s4,496(sp)
    80004ea2:	7abe                	ld	s5,488(sp)
    80004ea4:	7b1e                	ld	s6,480(sp)
    80004ea6:	6bfe                	ld	s7,472(sp)
    80004ea8:	6c5e                	ld	s8,464(sp)
    80004eaa:	6cbe                	ld	s9,456(sp)
    80004eac:	6d1e                	ld	s10,448(sp)
    80004eae:	7dfa                	ld	s11,440(sp)
    80004eb0:	b321                	j	80004bb8 <kexec+0x82>
    80004eb2:	7b1e                	ld	s6,480(sp)
    80004eb4:	b9d5                	j	80004ba8 <kexec+0x72>
    return -1;
    80004eb6:	557d                	li	a0,-1
    80004eb8:	b301                	j	80004bb8 <kexec+0x82>
    80004eba:	557d                	li	a0,-1
    80004ebc:	6d1e                	ld	s10,448(sp)
    80004ebe:	b9ed                	j	80004bb8 <kexec+0x82>
    80004ec0:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz, (int) (p - proc));
    80004ec4:	0000b797          	auipc	a5,0xb
    80004ec8:	ed478793          	addi	a5,a5,-300 # 8000fd98 <proc>
    80004ecc:	40fd07b3          	sub	a5,s10,a5
    80004ed0:	8791                	srai	a5,a5,0x4
    80004ed2:	e9bd3737          	lui	a4,0xe9bd3
    80004ed6:	7a770713          	addi	a4,a4,1959 # ffffffffe9bd37a7 <end+0xffffffff69bb2a2f>
    80004eda:	d37a7637          	lui	a2,0xd37a7
    80004ede:	f4e60613          	addi	a2,a2,-178 # ffffffffd37a6f4e <end+0xffffffff537861d6>
    80004ee2:	1602                	slli	a2,a2,0x20
    80004ee4:	963a                	add	a2,a2,a4
    80004ee6:	02c7863b          	mulw	a2,a5,a2
    80004eea:	df843583          	ld	a1,-520(s0)
    80004eee:	855a                	mv	a0,s6
    80004ef0:	b87fc0ef          	jal	80001a76 <proc_freepagetable>
  if(ip){
    80004ef4:	20013903          	ld	s2,512(sp)
    80004ef8:	79fe                	ld	s3,504(sp)
    80004efa:	7abe                	ld	s5,488(sp)
    80004efc:	7b1e                	ld	s6,480(sp)
    80004efe:	6bfe                	ld	s7,472(sp)
    80004f00:	6c5e                	ld	s8,464(sp)
    80004f02:	6cbe                	ld	s9,456(sp)
    80004f04:	7dfa                	ld	s11,440(sp)
    80004f06:	b14d                	j	80004ba8 <kexec+0x72>
    80004f08:	df243c23          	sd	s2,-520(s0)
    80004f0c:	bf65                	j	80004ec4 <kexec+0x38e>
    80004f0e:	df243c23          	sd	s2,-520(s0)
    80004f12:	bf4d                	j	80004ec4 <kexec+0x38e>
    80004f14:	df243c23          	sd	s2,-520(s0)
    80004f18:	b775                	j	80004ec4 <kexec+0x38e>
    80004f1a:	df243c23          	sd	s2,-520(s0)
    80004f1e:	b75d                	j	80004ec4 <kexec+0x38e>
  sz = sz1;
    80004f20:	89d6                	mv	s3,s5
    80004f22:	bbfd                	j	80004d20 <kexec+0x1ea>
    80004f24:	89d6                	mv	s3,s5
    80004f26:	bbed                	j	80004d20 <kexec+0x1ea>

0000000080004f28 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004f28:	7179                	addi	sp,sp,-48
    80004f2a:	f406                	sd	ra,40(sp)
    80004f2c:	f022                	sd	s0,32(sp)
    80004f2e:	ec26                	sd	s1,24(sp)
    80004f30:	e84a                	sd	s2,16(sp)
    80004f32:	1800                	addi	s0,sp,48
    80004f34:	892e                	mv	s2,a1
    80004f36:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004f38:	fdc40593          	addi	a1,s0,-36
    80004f3c:	d3dfd0ef          	jal	80002c78 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004f40:	fdc42703          	lw	a4,-36(s0)
    80004f44:	47bd                	li	a5,15
    80004f46:	02e7e963          	bltu	a5,a4,80004f78 <argfd+0x50>
    80004f4a:	975fc0ef          	jal	800018be <myproc>
    80004f4e:	fdc42703          	lw	a4,-36(s0)
    80004f52:	01a70793          	addi	a5,a4,26
    80004f56:	078e                	slli	a5,a5,0x3
    80004f58:	953e                	add	a0,a0,a5
    80004f5a:	651c                	ld	a5,8(a0)
    80004f5c:	c385                	beqz	a5,80004f7c <argfd+0x54>
    return -1;
  if(pfd)
    80004f5e:	00090463          	beqz	s2,80004f66 <argfd+0x3e>
    *pfd = fd;
    80004f62:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004f66:	4501                	li	a0,0
  if(pf)
    80004f68:	c091                	beqz	s1,80004f6c <argfd+0x44>
    *pf = f;
    80004f6a:	e09c                	sd	a5,0(s1)
}
    80004f6c:	70a2                	ld	ra,40(sp)
    80004f6e:	7402                	ld	s0,32(sp)
    80004f70:	64e2                	ld	s1,24(sp)
    80004f72:	6942                	ld	s2,16(sp)
    80004f74:	6145                	addi	sp,sp,48
    80004f76:	8082                	ret
    return -1;
    80004f78:	557d                	li	a0,-1
    80004f7a:	bfcd                	j	80004f6c <argfd+0x44>
    80004f7c:	557d                	li	a0,-1
    80004f7e:	b7fd                	j	80004f6c <argfd+0x44>

0000000080004f80 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004f80:	1101                	addi	sp,sp,-32
    80004f82:	ec06                	sd	ra,24(sp)
    80004f84:	e822                	sd	s0,16(sp)
    80004f86:	e426                	sd	s1,8(sp)
    80004f88:	1000                	addi	s0,sp,32
    80004f8a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004f8c:	933fc0ef          	jal	800018be <myproc>
    80004f90:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004f92:	0d850793          	addi	a5,a0,216
    80004f96:	4501                	li	a0,0
    80004f98:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004f9a:	6398                	ld	a4,0(a5)
    80004f9c:	cb19                	beqz	a4,80004fb2 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004f9e:	2505                	addiw	a0,a0,1
    80004fa0:	07a1                	addi	a5,a5,8
    80004fa2:	fed51ce3          	bne	a0,a3,80004f9a <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004fa6:	557d                	li	a0,-1
}
    80004fa8:	60e2                	ld	ra,24(sp)
    80004faa:	6442                	ld	s0,16(sp)
    80004fac:	64a2                	ld	s1,8(sp)
    80004fae:	6105                	addi	sp,sp,32
    80004fb0:	8082                	ret
      p->ofile[fd] = f;
    80004fb2:	01a50793          	addi	a5,a0,26
    80004fb6:	078e                	slli	a5,a5,0x3
    80004fb8:	963e                	add	a2,a2,a5
    80004fba:	e604                	sd	s1,8(a2)
      return fd;
    80004fbc:	b7f5                	j	80004fa8 <fdalloc+0x28>

0000000080004fbe <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004fbe:	715d                	addi	sp,sp,-80
    80004fc0:	e486                	sd	ra,72(sp)
    80004fc2:	e0a2                	sd	s0,64(sp)
    80004fc4:	fc26                	sd	s1,56(sp)
    80004fc6:	f84a                	sd	s2,48(sp)
    80004fc8:	f44e                	sd	s3,40(sp)
    80004fca:	ec56                	sd	s5,24(sp)
    80004fcc:	e85a                	sd	s6,16(sp)
    80004fce:	0880                	addi	s0,sp,80
    80004fd0:	8b2e                	mv	s6,a1
    80004fd2:	89b2                	mv	s3,a2
    80004fd4:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004fd6:	fb040593          	addi	a1,s0,-80
    80004fda:	f4ffe0ef          	jal	80003f28 <nameiparent>
    80004fde:	84aa                	mv	s1,a0
    80004fe0:	10050a63          	beqz	a0,800050f4 <create+0x136>
    return 0;

  ilock(dp);
    80004fe4:	f00fe0ef          	jal	800036e4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004fe8:	4601                	li	a2,0
    80004fea:	fb040593          	addi	a1,s0,-80
    80004fee:	8526                	mv	a0,s1
    80004ff0:	c93fe0ef          	jal	80003c82 <dirlookup>
    80004ff4:	8aaa                	mv	s5,a0
    80004ff6:	c129                	beqz	a0,80005038 <create+0x7a>
    iunlockput(dp);
    80004ff8:	8526                	mv	a0,s1
    80004ffa:	8f5fe0ef          	jal	800038ee <iunlockput>
    ilock(ip);
    80004ffe:	8556                	mv	a0,s5
    80005000:	ee4fe0ef          	jal	800036e4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005004:	4789                	li	a5,2
    80005006:	02fb1463          	bne	s6,a5,8000502e <create+0x70>
    8000500a:	044ad783          	lhu	a5,68(s5) # 1044 <_entry-0x7fffefbc>
    8000500e:	37f9                	addiw	a5,a5,-2
    80005010:	17c2                	slli	a5,a5,0x30
    80005012:	93c1                	srli	a5,a5,0x30
    80005014:	4705                	li	a4,1
    80005016:	00f76c63          	bltu	a4,a5,8000502e <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000501a:	8556                	mv	a0,s5
    8000501c:	60a6                	ld	ra,72(sp)
    8000501e:	6406                	ld	s0,64(sp)
    80005020:	74e2                	ld	s1,56(sp)
    80005022:	7942                	ld	s2,48(sp)
    80005024:	79a2                	ld	s3,40(sp)
    80005026:	6ae2                	ld	s5,24(sp)
    80005028:	6b42                	ld	s6,16(sp)
    8000502a:	6161                	addi	sp,sp,80
    8000502c:	8082                	ret
    iunlockput(ip);
    8000502e:	8556                	mv	a0,s5
    80005030:	8bffe0ef          	jal	800038ee <iunlockput>
    return 0;
    80005034:	4a81                	li	s5,0
    80005036:	b7d5                	j	8000501a <create+0x5c>
    80005038:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000503a:	85da                	mv	a1,s6
    8000503c:	4088                	lw	a0,0(s1)
    8000503e:	d36fe0ef          	jal	80003574 <ialloc>
    80005042:	8a2a                	mv	s4,a0
    80005044:	cd15                	beqz	a0,80005080 <create+0xc2>
  ilock(ip);
    80005046:	e9efe0ef          	jal	800036e4 <ilock>
  ip->major = major;
    8000504a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000504e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005052:	4905                	li	s2,1
    80005054:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005058:	8552                	mv	a0,s4
    8000505a:	dd6fe0ef          	jal	80003630 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000505e:	032b0763          	beq	s6,s2,8000508c <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80005062:	004a2603          	lw	a2,4(s4)
    80005066:	fb040593          	addi	a1,s0,-80
    8000506a:	8526                	mv	a0,s1
    8000506c:	df9fe0ef          	jal	80003e64 <dirlink>
    80005070:	06054563          	bltz	a0,800050da <create+0x11c>
  iunlockput(dp);
    80005074:	8526                	mv	a0,s1
    80005076:	879fe0ef          	jal	800038ee <iunlockput>
  return ip;
    8000507a:	8ad2                	mv	s5,s4
    8000507c:	7a02                	ld	s4,32(sp)
    8000507e:	bf71                	j	8000501a <create+0x5c>
    iunlockput(dp);
    80005080:	8526                	mv	a0,s1
    80005082:	86dfe0ef          	jal	800038ee <iunlockput>
    return 0;
    80005086:	8ad2                	mv	s5,s4
    80005088:	7a02                	ld	s4,32(sp)
    8000508a:	bf41                	j	8000501a <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000508c:	004a2603          	lw	a2,4(s4)
    80005090:	00002597          	auipc	a1,0x2
    80005094:	53058593          	addi	a1,a1,1328 # 800075c0 <etext+0x5c0>
    80005098:	8552                	mv	a0,s4
    8000509a:	dcbfe0ef          	jal	80003e64 <dirlink>
    8000509e:	02054e63          	bltz	a0,800050da <create+0x11c>
    800050a2:	40d0                	lw	a2,4(s1)
    800050a4:	00002597          	auipc	a1,0x2
    800050a8:	52458593          	addi	a1,a1,1316 # 800075c8 <etext+0x5c8>
    800050ac:	8552                	mv	a0,s4
    800050ae:	db7fe0ef          	jal	80003e64 <dirlink>
    800050b2:	02054463          	bltz	a0,800050da <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800050b6:	004a2603          	lw	a2,4(s4)
    800050ba:	fb040593          	addi	a1,s0,-80
    800050be:	8526                	mv	a0,s1
    800050c0:	da5fe0ef          	jal	80003e64 <dirlink>
    800050c4:	00054b63          	bltz	a0,800050da <create+0x11c>
    dp->nlink++;  // for ".."
    800050c8:	04a4d783          	lhu	a5,74(s1)
    800050cc:	2785                	addiw	a5,a5,1
    800050ce:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800050d2:	8526                	mv	a0,s1
    800050d4:	d5cfe0ef          	jal	80003630 <iupdate>
    800050d8:	bf71                	j	80005074 <create+0xb6>
  ip->nlink = 0;
    800050da:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800050de:	8552                	mv	a0,s4
    800050e0:	d50fe0ef          	jal	80003630 <iupdate>
  iunlockput(ip);
    800050e4:	8552                	mv	a0,s4
    800050e6:	809fe0ef          	jal	800038ee <iunlockput>
  iunlockput(dp);
    800050ea:	8526                	mv	a0,s1
    800050ec:	803fe0ef          	jal	800038ee <iunlockput>
  return 0;
    800050f0:	7a02                	ld	s4,32(sp)
    800050f2:	b725                	j	8000501a <create+0x5c>
    return 0;
    800050f4:	8aaa                	mv	s5,a0
    800050f6:	b715                	j	8000501a <create+0x5c>

00000000800050f8 <sys_dup>:
{
    800050f8:	7179                	addi	sp,sp,-48
    800050fa:	f406                	sd	ra,40(sp)
    800050fc:	f022                	sd	s0,32(sp)
    800050fe:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005100:	fd840613          	addi	a2,s0,-40
    80005104:	4581                	li	a1,0
    80005106:	4501                	li	a0,0
    80005108:	e21ff0ef          	jal	80004f28 <argfd>
    return -1;
    8000510c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000510e:	02054363          	bltz	a0,80005134 <sys_dup+0x3c>
    80005112:	ec26                	sd	s1,24(sp)
    80005114:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005116:	fd843903          	ld	s2,-40(s0)
    8000511a:	854a                	mv	a0,s2
    8000511c:	e65ff0ef          	jal	80004f80 <fdalloc>
    80005120:	84aa                	mv	s1,a0
    return -1;
    80005122:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005124:	00054d63          	bltz	a0,8000513e <sys_dup+0x46>
  filedup(f);
    80005128:	854a                	mv	a0,s2
    8000512a:	b8aff0ef          	jal	800044b4 <filedup>
  return fd;
    8000512e:	87a6                	mv	a5,s1
    80005130:	64e2                	ld	s1,24(sp)
    80005132:	6942                	ld	s2,16(sp)
}
    80005134:	853e                	mv	a0,a5
    80005136:	70a2                	ld	ra,40(sp)
    80005138:	7402                	ld	s0,32(sp)
    8000513a:	6145                	addi	sp,sp,48
    8000513c:	8082                	ret
    8000513e:	64e2                	ld	s1,24(sp)
    80005140:	6942                	ld	s2,16(sp)
    80005142:	bfcd                	j	80005134 <sys_dup+0x3c>

0000000080005144 <sys_read>:
{
    80005144:	7179                	addi	sp,sp,-48
    80005146:	f406                	sd	ra,40(sp)
    80005148:	f022                	sd	s0,32(sp)
    8000514a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000514c:	fd840593          	addi	a1,s0,-40
    80005150:	4505                	li	a0,1
    80005152:	b43fd0ef          	jal	80002c94 <argaddr>
  argint(2, &n);
    80005156:	fe440593          	addi	a1,s0,-28
    8000515a:	4509                	li	a0,2
    8000515c:	b1dfd0ef          	jal	80002c78 <argint>
  if(argfd(0, 0, &f) < 0)
    80005160:	fe840613          	addi	a2,s0,-24
    80005164:	4581                	li	a1,0
    80005166:	4501                	li	a0,0
    80005168:	dc1ff0ef          	jal	80004f28 <argfd>
    8000516c:	87aa                	mv	a5,a0
    return -1;
    8000516e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005170:	0007ca63          	bltz	a5,80005184 <sys_read+0x40>
  return fileread(f, p, n);
    80005174:	fe442603          	lw	a2,-28(s0)
    80005178:	fd843583          	ld	a1,-40(s0)
    8000517c:	fe843503          	ld	a0,-24(s0)
    80005180:	c9aff0ef          	jal	8000461a <fileread>
}
    80005184:	70a2                	ld	ra,40(sp)
    80005186:	7402                	ld	s0,32(sp)
    80005188:	6145                	addi	sp,sp,48
    8000518a:	8082                	ret

000000008000518c <sys_write>:
{
    8000518c:	7179                	addi	sp,sp,-48
    8000518e:	f406                	sd	ra,40(sp)
    80005190:	f022                	sd	s0,32(sp)
    80005192:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005194:	fd840593          	addi	a1,s0,-40
    80005198:	4505                	li	a0,1
    8000519a:	afbfd0ef          	jal	80002c94 <argaddr>
  argint(2, &n);
    8000519e:	fe440593          	addi	a1,s0,-28
    800051a2:	4509                	li	a0,2
    800051a4:	ad5fd0ef          	jal	80002c78 <argint>
  if(argfd(0, 0, &f) < 0)
    800051a8:	fe840613          	addi	a2,s0,-24
    800051ac:	4581                	li	a1,0
    800051ae:	4501                	li	a0,0
    800051b0:	d79ff0ef          	jal	80004f28 <argfd>
    800051b4:	87aa                	mv	a5,a0
    return -1;
    800051b6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800051b8:	0007ca63          	bltz	a5,800051cc <sys_write+0x40>
  return filewrite(f, p, n);
    800051bc:	fe442603          	lw	a2,-28(s0)
    800051c0:	fd843583          	ld	a1,-40(s0)
    800051c4:	fe843503          	ld	a0,-24(s0)
    800051c8:	d10ff0ef          	jal	800046d8 <filewrite>
}
    800051cc:	70a2                	ld	ra,40(sp)
    800051ce:	7402                	ld	s0,32(sp)
    800051d0:	6145                	addi	sp,sp,48
    800051d2:	8082                	ret

00000000800051d4 <sys_close>:
{
    800051d4:	1101                	addi	sp,sp,-32
    800051d6:	ec06                	sd	ra,24(sp)
    800051d8:	e822                	sd	s0,16(sp)
    800051da:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800051dc:	fe040613          	addi	a2,s0,-32
    800051e0:	fec40593          	addi	a1,s0,-20
    800051e4:	4501                	li	a0,0
    800051e6:	d43ff0ef          	jal	80004f28 <argfd>
    return -1;
    800051ea:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800051ec:	02054063          	bltz	a0,8000520c <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800051f0:	ecefc0ef          	jal	800018be <myproc>
    800051f4:	fec42783          	lw	a5,-20(s0)
    800051f8:	07e9                	addi	a5,a5,26
    800051fa:	078e                	slli	a5,a5,0x3
    800051fc:	953e                	add	a0,a0,a5
    800051fe:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80005202:	fe043503          	ld	a0,-32(s0)
    80005206:	af4ff0ef          	jal	800044fa <fileclose>
  return 0;
    8000520a:	4781                	li	a5,0
}
    8000520c:	853e                	mv	a0,a5
    8000520e:	60e2                	ld	ra,24(sp)
    80005210:	6442                	ld	s0,16(sp)
    80005212:	6105                	addi	sp,sp,32
    80005214:	8082                	ret

0000000080005216 <sys_fstat>:
{
    80005216:	1101                	addi	sp,sp,-32
    80005218:	ec06                	sd	ra,24(sp)
    8000521a:	e822                	sd	s0,16(sp)
    8000521c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000521e:	fe040593          	addi	a1,s0,-32
    80005222:	4505                	li	a0,1
    80005224:	a71fd0ef          	jal	80002c94 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005228:	fe840613          	addi	a2,s0,-24
    8000522c:	4581                	li	a1,0
    8000522e:	4501                	li	a0,0
    80005230:	cf9ff0ef          	jal	80004f28 <argfd>
    80005234:	87aa                	mv	a5,a0
    return -1;
    80005236:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005238:	0007c863          	bltz	a5,80005248 <sys_fstat+0x32>
  return filestat(f, st);
    8000523c:	fe043583          	ld	a1,-32(s0)
    80005240:	fe843503          	ld	a0,-24(s0)
    80005244:	b74ff0ef          	jal	800045b8 <filestat>
}
    80005248:	60e2                	ld	ra,24(sp)
    8000524a:	6442                	ld	s0,16(sp)
    8000524c:	6105                	addi	sp,sp,32
    8000524e:	8082                	ret

0000000080005250 <sys_link>:
{
    80005250:	7169                	addi	sp,sp,-304
    80005252:	f606                	sd	ra,296(sp)
    80005254:	f222                	sd	s0,288(sp)
    80005256:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005258:	08000613          	li	a2,128
    8000525c:	ed040593          	addi	a1,s0,-304
    80005260:	4501                	li	a0,0
    80005262:	a4ffd0ef          	jal	80002cb0 <argstr>
    return -1;
    80005266:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005268:	0c054e63          	bltz	a0,80005344 <sys_link+0xf4>
    8000526c:	08000613          	li	a2,128
    80005270:	f5040593          	addi	a1,s0,-176
    80005274:	4505                	li	a0,1
    80005276:	a3bfd0ef          	jal	80002cb0 <argstr>
    return -1;
    8000527a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000527c:	0c054463          	bltz	a0,80005344 <sys_link+0xf4>
    80005280:	ee26                	sd	s1,280(sp)
  begin_op();
    80005282:	e67fe0ef          	jal	800040e8 <begin_op>
  if((ip = namei(old)) == 0){
    80005286:	ed040513          	addi	a0,s0,-304
    8000528a:	c85fe0ef          	jal	80003f0e <namei>
    8000528e:	84aa                	mv	s1,a0
    80005290:	c53d                	beqz	a0,800052fe <sys_link+0xae>
  ilock(ip);
    80005292:	c52fe0ef          	jal	800036e4 <ilock>
  if(ip->type == T_DIR){
    80005296:	04449703          	lh	a4,68(s1)
    8000529a:	4785                	li	a5,1
    8000529c:	06f70663          	beq	a4,a5,80005308 <sys_link+0xb8>
    800052a0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800052a2:	04a4d783          	lhu	a5,74(s1)
    800052a6:	2785                	addiw	a5,a5,1
    800052a8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800052ac:	8526                	mv	a0,s1
    800052ae:	b82fe0ef          	jal	80003630 <iupdate>
  iunlock(ip);
    800052b2:	8526                	mv	a0,s1
    800052b4:	cdefe0ef          	jal	80003792 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800052b8:	fd040593          	addi	a1,s0,-48
    800052bc:	f5040513          	addi	a0,s0,-176
    800052c0:	c69fe0ef          	jal	80003f28 <nameiparent>
    800052c4:	892a                	mv	s2,a0
    800052c6:	cd21                	beqz	a0,8000531e <sys_link+0xce>
  ilock(dp);
    800052c8:	c1cfe0ef          	jal	800036e4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800052cc:	00092703          	lw	a4,0(s2)
    800052d0:	409c                	lw	a5,0(s1)
    800052d2:	04f71363          	bne	a4,a5,80005318 <sys_link+0xc8>
    800052d6:	40d0                	lw	a2,4(s1)
    800052d8:	fd040593          	addi	a1,s0,-48
    800052dc:	854a                	mv	a0,s2
    800052de:	b87fe0ef          	jal	80003e64 <dirlink>
    800052e2:	02054b63          	bltz	a0,80005318 <sys_link+0xc8>
  iunlockput(dp);
    800052e6:	854a                	mv	a0,s2
    800052e8:	e06fe0ef          	jal	800038ee <iunlockput>
  iput(ip);
    800052ec:	8526                	mv	a0,s1
    800052ee:	d78fe0ef          	jal	80003866 <iput>
  end_op();
    800052f2:	e61fe0ef          	jal	80004152 <end_op>
  return 0;
    800052f6:	4781                	li	a5,0
    800052f8:	64f2                	ld	s1,280(sp)
    800052fa:	6952                	ld	s2,272(sp)
    800052fc:	a0a1                	j	80005344 <sys_link+0xf4>
    end_op();
    800052fe:	e55fe0ef          	jal	80004152 <end_op>
    return -1;
    80005302:	57fd                	li	a5,-1
    80005304:	64f2                	ld	s1,280(sp)
    80005306:	a83d                	j	80005344 <sys_link+0xf4>
    iunlockput(ip);
    80005308:	8526                	mv	a0,s1
    8000530a:	de4fe0ef          	jal	800038ee <iunlockput>
    end_op();
    8000530e:	e45fe0ef          	jal	80004152 <end_op>
    return -1;
    80005312:	57fd                	li	a5,-1
    80005314:	64f2                	ld	s1,280(sp)
    80005316:	a03d                	j	80005344 <sys_link+0xf4>
    iunlockput(dp);
    80005318:	854a                	mv	a0,s2
    8000531a:	dd4fe0ef          	jal	800038ee <iunlockput>
  ilock(ip);
    8000531e:	8526                	mv	a0,s1
    80005320:	bc4fe0ef          	jal	800036e4 <ilock>
  ip->nlink--;
    80005324:	04a4d783          	lhu	a5,74(s1)
    80005328:	37fd                	addiw	a5,a5,-1
    8000532a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000532e:	8526                	mv	a0,s1
    80005330:	b00fe0ef          	jal	80003630 <iupdate>
  iunlockput(ip);
    80005334:	8526                	mv	a0,s1
    80005336:	db8fe0ef          	jal	800038ee <iunlockput>
  end_op();
    8000533a:	e19fe0ef          	jal	80004152 <end_op>
  return -1;
    8000533e:	57fd                	li	a5,-1
    80005340:	64f2                	ld	s1,280(sp)
    80005342:	6952                	ld	s2,272(sp)
}
    80005344:	853e                	mv	a0,a5
    80005346:	70b2                	ld	ra,296(sp)
    80005348:	7412                	ld	s0,288(sp)
    8000534a:	6155                	addi	sp,sp,304
    8000534c:	8082                	ret

000000008000534e <sys_unlink>:
{
    8000534e:	7111                	addi	sp,sp,-256
    80005350:	fd86                	sd	ra,248(sp)
    80005352:	f9a2                	sd	s0,240(sp)
    80005354:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80005356:	08000613          	li	a2,128
    8000535a:	f2040593          	addi	a1,s0,-224
    8000535e:	4501                	li	a0,0
    80005360:	951fd0ef          	jal	80002cb0 <argstr>
    80005364:	16054663          	bltz	a0,800054d0 <sys_unlink+0x182>
    80005368:	f5a6                	sd	s1,232(sp)
  begin_op();
    8000536a:	d7ffe0ef          	jal	800040e8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000536e:	fa040593          	addi	a1,s0,-96
    80005372:	f2040513          	addi	a0,s0,-224
    80005376:	bb3fe0ef          	jal	80003f28 <nameiparent>
    8000537a:	84aa                	mv	s1,a0
    8000537c:	c955                	beqz	a0,80005430 <sys_unlink+0xe2>
  ilock(dp);
    8000537e:	b66fe0ef          	jal	800036e4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005382:	00002597          	auipc	a1,0x2
    80005386:	23e58593          	addi	a1,a1,574 # 800075c0 <etext+0x5c0>
    8000538a:	fa040513          	addi	a0,s0,-96
    8000538e:	8dffe0ef          	jal	80003c6c <namecmp>
    80005392:	12050463          	beqz	a0,800054ba <sys_unlink+0x16c>
    80005396:	00002597          	auipc	a1,0x2
    8000539a:	23258593          	addi	a1,a1,562 # 800075c8 <etext+0x5c8>
    8000539e:	fa040513          	addi	a0,s0,-96
    800053a2:	8cbfe0ef          	jal	80003c6c <namecmp>
    800053a6:	10050a63          	beqz	a0,800054ba <sys_unlink+0x16c>
    800053aa:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800053ac:	f1c40613          	addi	a2,s0,-228
    800053b0:	fa040593          	addi	a1,s0,-96
    800053b4:	8526                	mv	a0,s1
    800053b6:	8cdfe0ef          	jal	80003c82 <dirlookup>
    800053ba:	892a                	mv	s2,a0
    800053bc:	0e050e63          	beqz	a0,800054b8 <sys_unlink+0x16a>
    800053c0:	edce                	sd	s3,216(sp)
  ilock(ip);
    800053c2:	b22fe0ef          	jal	800036e4 <ilock>
  if(ip->nlink < 1)
    800053c6:	04a91783          	lh	a5,74(s2)
    800053ca:	06f05863          	blez	a5,8000543a <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800053ce:	04491703          	lh	a4,68(s2)
    800053d2:	4785                	li	a5,1
    800053d4:	06f70b63          	beq	a4,a5,8000544a <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    800053d8:	fb040993          	addi	s3,s0,-80
    800053dc:	4641                	li	a2,16
    800053de:	4581                	li	a1,0
    800053e0:	854e                	mv	a0,s3
    800053e2:	8bbfb0ef          	jal	80000c9c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800053e6:	4741                	li	a4,16
    800053e8:	f1c42683          	lw	a3,-228(s0)
    800053ec:	864e                	mv	a2,s3
    800053ee:	4581                	li	a1,0
    800053f0:	8526                	mv	a0,s1
    800053f2:	f76fe0ef          	jal	80003b68 <writei>
    800053f6:	47c1                	li	a5,16
    800053f8:	08f51f63          	bne	a0,a5,80005496 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    800053fc:	04491703          	lh	a4,68(s2)
    80005400:	4785                	li	a5,1
    80005402:	0af70263          	beq	a4,a5,800054a6 <sys_unlink+0x158>
  iunlockput(dp);
    80005406:	8526                	mv	a0,s1
    80005408:	ce6fe0ef          	jal	800038ee <iunlockput>
  ip->nlink--;
    8000540c:	04a95783          	lhu	a5,74(s2)
    80005410:	37fd                	addiw	a5,a5,-1
    80005412:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005416:	854a                	mv	a0,s2
    80005418:	a18fe0ef          	jal	80003630 <iupdate>
  iunlockput(ip);
    8000541c:	854a                	mv	a0,s2
    8000541e:	cd0fe0ef          	jal	800038ee <iunlockput>
  end_op();
    80005422:	d31fe0ef          	jal	80004152 <end_op>
  return 0;
    80005426:	4501                	li	a0,0
    80005428:	74ae                	ld	s1,232(sp)
    8000542a:	790e                	ld	s2,224(sp)
    8000542c:	69ee                	ld	s3,216(sp)
    8000542e:	a869                	j	800054c8 <sys_unlink+0x17a>
    end_op();
    80005430:	d23fe0ef          	jal	80004152 <end_op>
    return -1;
    80005434:	557d                	li	a0,-1
    80005436:	74ae                	ld	s1,232(sp)
    80005438:	a841                	j	800054c8 <sys_unlink+0x17a>
    8000543a:	e9d2                	sd	s4,208(sp)
    8000543c:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    8000543e:	00002517          	auipc	a0,0x2
    80005442:	19250513          	addi	a0,a0,402 # 800075d0 <etext+0x5d0>
    80005446:	b98fb0ef          	jal	800007de <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000544a:	04c92703          	lw	a4,76(s2)
    8000544e:	02000793          	li	a5,32
    80005452:	f8e7f3e3          	bgeu	a5,a4,800053d8 <sys_unlink+0x8a>
    80005456:	e9d2                	sd	s4,208(sp)
    80005458:	e5d6                	sd	s5,200(sp)
    8000545a:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000545c:	f0840a93          	addi	s5,s0,-248
    80005460:	4a41                	li	s4,16
    80005462:	8752                	mv	a4,s4
    80005464:	86ce                	mv	a3,s3
    80005466:	8656                	mv	a2,s5
    80005468:	4581                	li	a1,0
    8000546a:	854a                	mv	a0,s2
    8000546c:	e0afe0ef          	jal	80003a76 <readi>
    80005470:	01451d63          	bne	a0,s4,8000548a <sys_unlink+0x13c>
    if(de.inum != 0)
    80005474:	f0845783          	lhu	a5,-248(s0)
    80005478:	efb1                	bnez	a5,800054d4 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000547a:	29c1                	addiw	s3,s3,16
    8000547c:	04c92783          	lw	a5,76(s2)
    80005480:	fef9e1e3          	bltu	s3,a5,80005462 <sys_unlink+0x114>
    80005484:	6a4e                	ld	s4,208(sp)
    80005486:	6aae                	ld	s5,200(sp)
    80005488:	bf81                	j	800053d8 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    8000548a:	00002517          	auipc	a0,0x2
    8000548e:	15e50513          	addi	a0,a0,350 # 800075e8 <etext+0x5e8>
    80005492:	b4cfb0ef          	jal	800007de <panic>
    80005496:	e9d2                	sd	s4,208(sp)
    80005498:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    8000549a:	00002517          	auipc	a0,0x2
    8000549e:	16650513          	addi	a0,a0,358 # 80007600 <etext+0x600>
    800054a2:	b3cfb0ef          	jal	800007de <panic>
    dp->nlink--;
    800054a6:	04a4d783          	lhu	a5,74(s1)
    800054aa:	37fd                	addiw	a5,a5,-1
    800054ac:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800054b0:	8526                	mv	a0,s1
    800054b2:	97efe0ef          	jal	80003630 <iupdate>
    800054b6:	bf81                	j	80005406 <sys_unlink+0xb8>
    800054b8:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    800054ba:	8526                	mv	a0,s1
    800054bc:	c32fe0ef          	jal	800038ee <iunlockput>
  end_op();
    800054c0:	c93fe0ef          	jal	80004152 <end_op>
  return -1;
    800054c4:	557d                	li	a0,-1
    800054c6:	74ae                	ld	s1,232(sp)
}
    800054c8:	70ee                	ld	ra,248(sp)
    800054ca:	744e                	ld	s0,240(sp)
    800054cc:	6111                	addi	sp,sp,256
    800054ce:	8082                	ret
    return -1;
    800054d0:	557d                	li	a0,-1
    800054d2:	bfdd                	j	800054c8 <sys_unlink+0x17a>
    iunlockput(ip);
    800054d4:	854a                	mv	a0,s2
    800054d6:	c18fe0ef          	jal	800038ee <iunlockput>
    goto bad;
    800054da:	790e                	ld	s2,224(sp)
    800054dc:	69ee                	ld	s3,216(sp)
    800054de:	6a4e                	ld	s4,208(sp)
    800054e0:	6aae                	ld	s5,200(sp)
    800054e2:	bfe1                	j	800054ba <sys_unlink+0x16c>

00000000800054e4 <sys_open>:

uint64
sys_open(void)
{
    800054e4:	7131                	addi	sp,sp,-192
    800054e6:	fd06                	sd	ra,184(sp)
    800054e8:	f922                	sd	s0,176(sp)
    800054ea:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800054ec:	f4c40593          	addi	a1,s0,-180
    800054f0:	4505                	li	a0,1
    800054f2:	f86fd0ef          	jal	80002c78 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800054f6:	08000613          	li	a2,128
    800054fa:	f5040593          	addi	a1,s0,-176
    800054fe:	4501                	li	a0,0
    80005500:	fb0fd0ef          	jal	80002cb0 <argstr>
    80005504:	87aa                	mv	a5,a0
    return -1;
    80005506:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005508:	0a07c363          	bltz	a5,800055ae <sys_open+0xca>
    8000550c:	f526                	sd	s1,168(sp)

  begin_op();
    8000550e:	bdbfe0ef          	jal	800040e8 <begin_op>

  if(omode & O_CREATE){
    80005512:	f4c42783          	lw	a5,-180(s0)
    80005516:	2007f793          	andi	a5,a5,512
    8000551a:	c3dd                	beqz	a5,800055c0 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000551c:	4681                	li	a3,0
    8000551e:	4601                	li	a2,0
    80005520:	4589                	li	a1,2
    80005522:	f5040513          	addi	a0,s0,-176
    80005526:	a99ff0ef          	jal	80004fbe <create>
    8000552a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000552c:	c549                	beqz	a0,800055b6 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000552e:	04449703          	lh	a4,68(s1)
    80005532:	478d                	li	a5,3
    80005534:	00f71763          	bne	a4,a5,80005542 <sys_open+0x5e>
    80005538:	0464d703          	lhu	a4,70(s1)
    8000553c:	47a5                	li	a5,9
    8000553e:	0ae7ee63          	bltu	a5,a4,800055fa <sys_open+0x116>
    80005542:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005544:	f13fe0ef          	jal	80004456 <filealloc>
    80005548:	892a                	mv	s2,a0
    8000554a:	c561                	beqz	a0,80005612 <sys_open+0x12e>
    8000554c:	ed4e                	sd	s3,152(sp)
    8000554e:	a33ff0ef          	jal	80004f80 <fdalloc>
    80005552:	89aa                	mv	s3,a0
    80005554:	0a054b63          	bltz	a0,8000560a <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005558:	04449703          	lh	a4,68(s1)
    8000555c:	478d                	li	a5,3
    8000555e:	0cf70363          	beq	a4,a5,80005624 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005562:	4789                	li	a5,2
    80005564:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005568:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000556c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005570:	f4c42783          	lw	a5,-180(s0)
    80005574:	0017f713          	andi	a4,a5,1
    80005578:	00174713          	xori	a4,a4,1
    8000557c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005580:	0037f713          	andi	a4,a5,3
    80005584:	00e03733          	snez	a4,a4
    80005588:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000558c:	4007f793          	andi	a5,a5,1024
    80005590:	c791                	beqz	a5,8000559c <sys_open+0xb8>
    80005592:	04449703          	lh	a4,68(s1)
    80005596:	4789                	li	a5,2
    80005598:	08f70d63          	beq	a4,a5,80005632 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    8000559c:	8526                	mv	a0,s1
    8000559e:	9f4fe0ef          	jal	80003792 <iunlock>
  end_op();
    800055a2:	bb1fe0ef          	jal	80004152 <end_op>

  return fd;
    800055a6:	854e                	mv	a0,s3
    800055a8:	74aa                	ld	s1,168(sp)
    800055aa:	790a                	ld	s2,160(sp)
    800055ac:	69ea                	ld	s3,152(sp)
}
    800055ae:	70ea                	ld	ra,184(sp)
    800055b0:	744a                	ld	s0,176(sp)
    800055b2:	6129                	addi	sp,sp,192
    800055b4:	8082                	ret
      end_op();
    800055b6:	b9dfe0ef          	jal	80004152 <end_op>
      return -1;
    800055ba:	557d                	li	a0,-1
    800055bc:	74aa                	ld	s1,168(sp)
    800055be:	bfc5                	j	800055ae <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800055c0:	f5040513          	addi	a0,s0,-176
    800055c4:	94bfe0ef          	jal	80003f0e <namei>
    800055c8:	84aa                	mv	s1,a0
    800055ca:	c11d                	beqz	a0,800055f0 <sys_open+0x10c>
    ilock(ip);
    800055cc:	918fe0ef          	jal	800036e4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800055d0:	04449703          	lh	a4,68(s1)
    800055d4:	4785                	li	a5,1
    800055d6:	f4f71ce3          	bne	a4,a5,8000552e <sys_open+0x4a>
    800055da:	f4c42783          	lw	a5,-180(s0)
    800055de:	d3b5                	beqz	a5,80005542 <sys_open+0x5e>
      iunlockput(ip);
    800055e0:	8526                	mv	a0,s1
    800055e2:	b0cfe0ef          	jal	800038ee <iunlockput>
      end_op();
    800055e6:	b6dfe0ef          	jal	80004152 <end_op>
      return -1;
    800055ea:	557d                	li	a0,-1
    800055ec:	74aa                	ld	s1,168(sp)
    800055ee:	b7c1                	j	800055ae <sys_open+0xca>
      end_op();
    800055f0:	b63fe0ef          	jal	80004152 <end_op>
      return -1;
    800055f4:	557d                	li	a0,-1
    800055f6:	74aa                	ld	s1,168(sp)
    800055f8:	bf5d                	j	800055ae <sys_open+0xca>
    iunlockput(ip);
    800055fa:	8526                	mv	a0,s1
    800055fc:	af2fe0ef          	jal	800038ee <iunlockput>
    end_op();
    80005600:	b53fe0ef          	jal	80004152 <end_op>
    return -1;
    80005604:	557d                	li	a0,-1
    80005606:	74aa                	ld	s1,168(sp)
    80005608:	b75d                	j	800055ae <sys_open+0xca>
      fileclose(f);
    8000560a:	854a                	mv	a0,s2
    8000560c:	eeffe0ef          	jal	800044fa <fileclose>
    80005610:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005612:	8526                	mv	a0,s1
    80005614:	adafe0ef          	jal	800038ee <iunlockput>
    end_op();
    80005618:	b3bfe0ef          	jal	80004152 <end_op>
    return -1;
    8000561c:	557d                	li	a0,-1
    8000561e:	74aa                	ld	s1,168(sp)
    80005620:	790a                	ld	s2,160(sp)
    80005622:	b771                	j	800055ae <sys_open+0xca>
    f->type = FD_DEVICE;
    80005624:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005628:	04649783          	lh	a5,70(s1)
    8000562c:	02f91223          	sh	a5,36(s2)
    80005630:	bf35                	j	8000556c <sys_open+0x88>
    itrunc(ip);
    80005632:	8526                	mv	a0,s1
    80005634:	99efe0ef          	jal	800037d2 <itrunc>
    80005638:	b795                	j	8000559c <sys_open+0xb8>

000000008000563a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000563a:	7175                	addi	sp,sp,-144
    8000563c:	e506                	sd	ra,136(sp)
    8000563e:	e122                	sd	s0,128(sp)
    80005640:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005642:	aa7fe0ef          	jal	800040e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005646:	08000613          	li	a2,128
    8000564a:	f7040593          	addi	a1,s0,-144
    8000564e:	4501                	li	a0,0
    80005650:	e60fd0ef          	jal	80002cb0 <argstr>
    80005654:	02054363          	bltz	a0,8000567a <sys_mkdir+0x40>
    80005658:	4681                	li	a3,0
    8000565a:	4601                	li	a2,0
    8000565c:	4585                	li	a1,1
    8000565e:	f7040513          	addi	a0,s0,-144
    80005662:	95dff0ef          	jal	80004fbe <create>
    80005666:	c911                	beqz	a0,8000567a <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005668:	a86fe0ef          	jal	800038ee <iunlockput>
  end_op();
    8000566c:	ae7fe0ef          	jal	80004152 <end_op>
  return 0;
    80005670:	4501                	li	a0,0
}
    80005672:	60aa                	ld	ra,136(sp)
    80005674:	640a                	ld	s0,128(sp)
    80005676:	6149                	addi	sp,sp,144
    80005678:	8082                	ret
    end_op();
    8000567a:	ad9fe0ef          	jal	80004152 <end_op>
    return -1;
    8000567e:	557d                	li	a0,-1
    80005680:	bfcd                	j	80005672 <sys_mkdir+0x38>

0000000080005682 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005682:	7135                	addi	sp,sp,-160
    80005684:	ed06                	sd	ra,152(sp)
    80005686:	e922                	sd	s0,144(sp)
    80005688:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000568a:	a5ffe0ef          	jal	800040e8 <begin_op>
  argint(1, &major);
    8000568e:	f6c40593          	addi	a1,s0,-148
    80005692:	4505                	li	a0,1
    80005694:	de4fd0ef          	jal	80002c78 <argint>
  argint(2, &minor);
    80005698:	f6840593          	addi	a1,s0,-152
    8000569c:	4509                	li	a0,2
    8000569e:	ddafd0ef          	jal	80002c78 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800056a2:	08000613          	li	a2,128
    800056a6:	f7040593          	addi	a1,s0,-144
    800056aa:	4501                	li	a0,0
    800056ac:	e04fd0ef          	jal	80002cb0 <argstr>
    800056b0:	02054563          	bltz	a0,800056da <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800056b4:	f6841683          	lh	a3,-152(s0)
    800056b8:	f6c41603          	lh	a2,-148(s0)
    800056bc:	458d                	li	a1,3
    800056be:	f7040513          	addi	a0,s0,-144
    800056c2:	8fdff0ef          	jal	80004fbe <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800056c6:	c911                	beqz	a0,800056da <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800056c8:	a26fe0ef          	jal	800038ee <iunlockput>
  end_op();
    800056cc:	a87fe0ef          	jal	80004152 <end_op>
  return 0;
    800056d0:	4501                	li	a0,0
}
    800056d2:	60ea                	ld	ra,152(sp)
    800056d4:	644a                	ld	s0,144(sp)
    800056d6:	610d                	addi	sp,sp,160
    800056d8:	8082                	ret
    end_op();
    800056da:	a79fe0ef          	jal	80004152 <end_op>
    return -1;
    800056de:	557d                	li	a0,-1
    800056e0:	bfcd                	j	800056d2 <sys_mknod+0x50>

00000000800056e2 <sys_chdir>:

uint64
sys_chdir(void)
{
    800056e2:	7135                	addi	sp,sp,-160
    800056e4:	ed06                	sd	ra,152(sp)
    800056e6:	e922                	sd	s0,144(sp)
    800056e8:	e14a                	sd	s2,128(sp)
    800056ea:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800056ec:	9d2fc0ef          	jal	800018be <myproc>
    800056f0:	892a                	mv	s2,a0
  
  begin_op();
    800056f2:	9f7fe0ef          	jal	800040e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800056f6:	08000613          	li	a2,128
    800056fa:	f6040593          	addi	a1,s0,-160
    800056fe:	4501                	li	a0,0
    80005700:	db0fd0ef          	jal	80002cb0 <argstr>
    80005704:	04054363          	bltz	a0,8000574a <sys_chdir+0x68>
    80005708:	e526                	sd	s1,136(sp)
    8000570a:	f6040513          	addi	a0,s0,-160
    8000570e:	801fe0ef          	jal	80003f0e <namei>
    80005712:	84aa                	mv	s1,a0
    80005714:	c915                	beqz	a0,80005748 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005716:	fcffd0ef          	jal	800036e4 <ilock>
  if(ip->type != T_DIR){
    8000571a:	04449703          	lh	a4,68(s1)
    8000571e:	4785                	li	a5,1
    80005720:	02f71963          	bne	a4,a5,80005752 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005724:	8526                	mv	a0,s1
    80005726:	86cfe0ef          	jal	80003792 <iunlock>
  iput(p->cwd);
    8000572a:	15893503          	ld	a0,344(s2)
    8000572e:	938fe0ef          	jal	80003866 <iput>
  end_op();
    80005732:	a21fe0ef          	jal	80004152 <end_op>
  p->cwd = ip;
    80005736:	14993c23          	sd	s1,344(s2)
  return 0;
    8000573a:	4501                	li	a0,0
    8000573c:	64aa                	ld	s1,136(sp)
}
    8000573e:	60ea                	ld	ra,152(sp)
    80005740:	644a                	ld	s0,144(sp)
    80005742:	690a                	ld	s2,128(sp)
    80005744:	610d                	addi	sp,sp,160
    80005746:	8082                	ret
    80005748:	64aa                	ld	s1,136(sp)
    end_op();
    8000574a:	a09fe0ef          	jal	80004152 <end_op>
    return -1;
    8000574e:	557d                	li	a0,-1
    80005750:	b7fd                	j	8000573e <sys_chdir+0x5c>
    iunlockput(ip);
    80005752:	8526                	mv	a0,s1
    80005754:	99afe0ef          	jal	800038ee <iunlockput>
    end_op();
    80005758:	9fbfe0ef          	jal	80004152 <end_op>
    return -1;
    8000575c:	557d                	li	a0,-1
    8000575e:	64aa                	ld	s1,136(sp)
    80005760:	bff9                	j	8000573e <sys_chdir+0x5c>

0000000080005762 <sys_exec>:

uint64
sys_exec(void)
{
    80005762:	7105                	addi	sp,sp,-480
    80005764:	ef86                	sd	ra,472(sp)
    80005766:	eba2                	sd	s0,464(sp)
    80005768:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000576a:	e2840593          	addi	a1,s0,-472
    8000576e:	4505                	li	a0,1
    80005770:	d24fd0ef          	jal	80002c94 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005774:	08000613          	li	a2,128
    80005778:	f3040593          	addi	a1,s0,-208
    8000577c:	4501                	li	a0,0
    8000577e:	d32fd0ef          	jal	80002cb0 <argstr>
    80005782:	87aa                	mv	a5,a0
    return -1;
    80005784:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005786:	0e07c063          	bltz	a5,80005866 <sys_exec+0x104>
    8000578a:	e7a6                	sd	s1,456(sp)
    8000578c:	e3ca                	sd	s2,448(sp)
    8000578e:	ff4e                	sd	s3,440(sp)
    80005790:	fb52                	sd	s4,432(sp)
    80005792:	f756                	sd	s5,424(sp)
    80005794:	f35a                	sd	s6,416(sp)
    80005796:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005798:	e3040a13          	addi	s4,s0,-464
    8000579c:	10000613          	li	a2,256
    800057a0:	4581                	li	a1,0
    800057a2:	8552                	mv	a0,s4
    800057a4:	cf8fb0ef          	jal	80000c9c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800057a8:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800057aa:	89d2                	mv	s3,s4
    800057ac:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800057ae:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800057b2:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800057b4:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800057b8:	00391513          	slli	a0,s2,0x3
    800057bc:	85d6                	mv	a1,s5
    800057be:	e2843783          	ld	a5,-472(s0)
    800057c2:	953e                	add	a0,a0,a5
    800057c4:	c2afd0ef          	jal	80002bee <fetchaddr>
    800057c8:	02054663          	bltz	a0,800057f4 <sys_exec+0x92>
    if(uarg == 0){
    800057cc:	e2043783          	ld	a5,-480(s0)
    800057d0:	c7a1                	beqz	a5,80005818 <sys_exec+0xb6>
    argv[i] = kalloc();
    800057d2:	b26fb0ef          	jal	80000af8 <kalloc>
    800057d6:	85aa                	mv	a1,a0
    800057d8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800057dc:	cd01                	beqz	a0,800057f4 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800057de:	865a                	mv	a2,s6
    800057e0:	e2043503          	ld	a0,-480(s0)
    800057e4:	c54fd0ef          	jal	80002c38 <fetchstr>
    800057e8:	00054663          	bltz	a0,800057f4 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800057ec:	0905                	addi	s2,s2,1
    800057ee:	09a1                	addi	s3,s3,8
    800057f0:	fd7914e3          	bne	s2,s7,800057b8 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800057f4:	100a0a13          	addi	s4,s4,256
    800057f8:	6088                	ld	a0,0(s1)
    800057fa:	cd31                	beqz	a0,80005856 <sys_exec+0xf4>
    kfree(argv[i]);
    800057fc:	a1afb0ef          	jal	80000a16 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005800:	04a1                	addi	s1,s1,8
    80005802:	ff449be3          	bne	s1,s4,800057f8 <sys_exec+0x96>
  return -1;
    80005806:	557d                	li	a0,-1
    80005808:	64be                	ld	s1,456(sp)
    8000580a:	691e                	ld	s2,448(sp)
    8000580c:	79fa                	ld	s3,440(sp)
    8000580e:	7a5a                	ld	s4,432(sp)
    80005810:	7aba                	ld	s5,424(sp)
    80005812:	7b1a                	ld	s6,416(sp)
    80005814:	6bfa                	ld	s7,408(sp)
    80005816:	a881                	j	80005866 <sys_exec+0x104>
      argv[i] = 0;
    80005818:	0009079b          	sext.w	a5,s2
    8000581c:	e3040593          	addi	a1,s0,-464
    80005820:	078e                	slli	a5,a5,0x3
    80005822:	97ae                	add	a5,a5,a1
    80005824:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80005828:	f3040513          	addi	a0,s0,-208
    8000582c:	b0aff0ef          	jal	80004b36 <kexec>
    80005830:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005832:	100a0a13          	addi	s4,s4,256
    80005836:	6088                	ld	a0,0(s1)
    80005838:	c511                	beqz	a0,80005844 <sys_exec+0xe2>
    kfree(argv[i]);
    8000583a:	9dcfb0ef          	jal	80000a16 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000583e:	04a1                	addi	s1,s1,8
    80005840:	ff449be3          	bne	s1,s4,80005836 <sys_exec+0xd4>
  return ret;
    80005844:	854a                	mv	a0,s2
    80005846:	64be                	ld	s1,456(sp)
    80005848:	691e                	ld	s2,448(sp)
    8000584a:	79fa                	ld	s3,440(sp)
    8000584c:	7a5a                	ld	s4,432(sp)
    8000584e:	7aba                	ld	s5,424(sp)
    80005850:	7b1a                	ld	s6,416(sp)
    80005852:	6bfa                	ld	s7,408(sp)
    80005854:	a809                	j	80005866 <sys_exec+0x104>
  return -1;
    80005856:	557d                	li	a0,-1
    80005858:	64be                	ld	s1,456(sp)
    8000585a:	691e                	ld	s2,448(sp)
    8000585c:	79fa                	ld	s3,440(sp)
    8000585e:	7a5a                	ld	s4,432(sp)
    80005860:	7aba                	ld	s5,424(sp)
    80005862:	7b1a                	ld	s6,416(sp)
    80005864:	6bfa                	ld	s7,408(sp)
}
    80005866:	60fe                	ld	ra,472(sp)
    80005868:	645e                	ld	s0,464(sp)
    8000586a:	613d                	addi	sp,sp,480
    8000586c:	8082                	ret

000000008000586e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000586e:	7139                	addi	sp,sp,-64
    80005870:	fc06                	sd	ra,56(sp)
    80005872:	f822                	sd	s0,48(sp)
    80005874:	f426                	sd	s1,40(sp)
    80005876:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005878:	846fc0ef          	jal	800018be <myproc>
    8000587c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000587e:	fd840593          	addi	a1,s0,-40
    80005882:	4501                	li	a0,0
    80005884:	c10fd0ef          	jal	80002c94 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005888:	fc840593          	addi	a1,s0,-56
    8000588c:	fd040513          	addi	a0,s0,-48
    80005890:	f7bfe0ef          	jal	8000480a <pipealloc>
    return -1;
    80005894:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005896:	0a054463          	bltz	a0,8000593e <sys_pipe+0xd0>
  fd0 = -1;
    8000589a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000589e:	fd043503          	ld	a0,-48(s0)
    800058a2:	edeff0ef          	jal	80004f80 <fdalloc>
    800058a6:	fca42223          	sw	a0,-60(s0)
    800058aa:	08054163          	bltz	a0,8000592c <sys_pipe+0xbe>
    800058ae:	fc843503          	ld	a0,-56(s0)
    800058b2:	eceff0ef          	jal	80004f80 <fdalloc>
    800058b6:	fca42023          	sw	a0,-64(s0)
    800058ba:	06054063          	bltz	a0,8000591a <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800058be:	4691                	li	a3,4
    800058c0:	fc440613          	addi	a2,s0,-60
    800058c4:	fd843583          	ld	a1,-40(s0)
    800058c8:	6ca8                	ld	a0,88(s1)
    800058ca:	d27fb0ef          	jal	800015f0 <copyout>
    800058ce:	00054e63          	bltz	a0,800058ea <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800058d2:	4691                	li	a3,4
    800058d4:	fc040613          	addi	a2,s0,-64
    800058d8:	fd843583          	ld	a1,-40(s0)
    800058dc:	95b6                	add	a1,a1,a3
    800058de:	6ca8                	ld	a0,88(s1)
    800058e0:	d11fb0ef          	jal	800015f0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800058e4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800058e6:	04055c63          	bgez	a0,8000593e <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800058ea:	fc442783          	lw	a5,-60(s0)
    800058ee:	07e9                	addi	a5,a5,26
    800058f0:	078e                	slli	a5,a5,0x3
    800058f2:	97a6                	add	a5,a5,s1
    800058f4:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800058f8:	fc042783          	lw	a5,-64(s0)
    800058fc:	07e9                	addi	a5,a5,26
    800058fe:	078e                	slli	a5,a5,0x3
    80005900:	94be                	add	s1,s1,a5
    80005902:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005906:	fd043503          	ld	a0,-48(s0)
    8000590a:	bf1fe0ef          	jal	800044fa <fileclose>
    fileclose(wf);
    8000590e:	fc843503          	ld	a0,-56(s0)
    80005912:	be9fe0ef          	jal	800044fa <fileclose>
    return -1;
    80005916:	57fd                	li	a5,-1
    80005918:	a01d                	j	8000593e <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000591a:	fc442783          	lw	a5,-60(s0)
    8000591e:	0007c763          	bltz	a5,8000592c <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005922:	07e9                	addi	a5,a5,26
    80005924:	078e                	slli	a5,a5,0x3
    80005926:	97a6                	add	a5,a5,s1
    80005928:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000592c:	fd043503          	ld	a0,-48(s0)
    80005930:	bcbfe0ef          	jal	800044fa <fileclose>
    fileclose(wf);
    80005934:	fc843503          	ld	a0,-56(s0)
    80005938:	bc3fe0ef          	jal	800044fa <fileclose>
    return -1;
    8000593c:	57fd                	li	a5,-1
}
    8000593e:	853e                	mv	a0,a5
    80005940:	70e2                	ld	ra,56(sp)
    80005942:	7442                	ld	s0,48(sp)
    80005944:	74a2                	ld	s1,40(sp)
    80005946:	6121                	addi	sp,sp,64
    80005948:	8082                	ret
    8000594a:	0000                	unimp
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
    80005976:	988fd0ef          	jal	80002afe <kerneltrap>

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
    80005a54:	1e878793          	addi	a5,a5,488 # 80020c38 <disk>
    80005a58:	97aa                	add	a5,a5,a0
    80005a5a:	0187c783          	lbu	a5,24(a5)
    80005a5e:	e7b9                	bnez	a5,80005aac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005a60:	00451693          	slli	a3,a0,0x4
    80005a64:	0001b797          	auipc	a5,0x1b
    80005a68:	1d478793          	addi	a5,a5,468 # 80020c38 <disk>
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
    80005a90:	1c450513          	addi	a0,a0,452 # 80020c50 <disk+0x18>
    80005a94:	d8efc0ef          	jal	80002022 <wakeup>
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
    80005ad0:	29450513          	addi	a0,a0,660 # 80020d60 <disk+0x128>
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
    80005b34:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd9e7>
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
    80005b7e:	0be48493          	addi	s1,s1,190 # 80020c38 <disk>
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
    80005b9c:	0a873703          	ld	a4,168(a4) # 80020c40 <disk+0x8>
    80005ba0:	cb71                	beqz	a4,80005c74 <virtio_disk_init+0x1bc>
    80005ba2:	cbe9                	beqz	a5,80005c74 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005ba4:	6605                	lui	a2,0x1
    80005ba6:	4581                	li	a1,0
    80005ba8:	8f4fb0ef          	jal	80000c9c <memset>
  memset(disk.avail, 0, PGSIZE);
    80005bac:	0001b497          	auipc	s1,0x1b
    80005bb0:	08c48493          	addi	s1,s1,140 # 80020c38 <disk>
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
    80005cae:	0b650513          	addi	a0,a0,182 # 80020d60 <disk+0x128>
    80005cb2:	f1bfa0ef          	jal	80000bcc <acquire>
  for(int i = 0; i < NUM; i++){
    80005cb6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005cb8:	0001ba97          	auipc	s5,0x1b
    80005cbc:	f80a8a93          	addi	s5,s5,-128 # 80020c38 <disk>
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
    80005ce2:	f5a70713          	addi	a4,a4,-166 # 80020c38 <disk>
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
    80005d18:	04c58593          	addi	a1,a1,76 # 80020d60 <disk+0x128>
    80005d1c:	0001b517          	auipc	a0,0x1b
    80005d20:	f3450513          	addi	a0,a0,-204 # 80020c50 <disk+0x18>
    80005d24:	ab2fc0ef          	jal	80001fd6 <sleep>
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
    80005d3c:	f0078793          	addi	a5,a5,-256 # 80020c38 <disk>
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
    80005e12:	f5290913          	addi	s2,s2,-174 # 80020d60 <disk+0x128>
  while(b->disk == 1) {
    80005e16:	84c2                	mv	s1,a6
    80005e18:	01079a63          	bne	a5,a6,80005e2c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80005e1c:	85ca                	mv	a1,s2
    80005e1e:	854e                	mv	a0,s3
    80005e20:	9b6fc0ef          	jal	80001fd6 <sleep>
  while(b->disk == 1) {
    80005e24:	0049a783          	lw	a5,4(s3)
    80005e28:	fe978ae3          	beq	a5,s1,80005e1c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80005e2c:	fa042903          	lw	s2,-96(s0)
    80005e30:	00290713          	addi	a4,s2,2
    80005e34:	0712                	slli	a4,a4,0x4
    80005e36:	0001b797          	auipc	a5,0x1b
    80005e3a:	e0278793          	addi	a5,a5,-510 # 80020c38 <disk>
    80005e3e:	97ba                	add	a5,a5,a4
    80005e40:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005e44:	0001b997          	auipc	s3,0x1b
    80005e48:	df498993          	addi	s3,s3,-524 # 80020c38 <disk>
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
    80005e6c:	ef850513          	addi	a0,a0,-264 # 80020d60 <disk+0x128>
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
    80005e9a:	da248493          	addi	s1,s1,-606 # 80020c38 <disk>
    80005e9e:	0001b517          	auipc	a0,0x1b
    80005ea2:	ec250513          	addi	a0,a0,-318 # 80020d60 <disk+0x128>
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
    80005ef6:	92cfc0ef          	jal	80002022 <wakeup>

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
    80005f16:	e4e50513          	addi	a0,a0,-434 # 80020d60 <disk+0x128>
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
