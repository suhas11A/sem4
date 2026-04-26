
user/_p4:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <t0>:

sem_t s0, s1, s2;
int N;

void t0(int *arg)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
    for (int i = 0; i < N; i++) {
  12:	00001797          	auipc	a5,0x1
  16:	fee7a783          	lw	a5,-18(a5) # 1000 <N>
  1a:	04f05163          	blez	a5,5c <t0+0x5c>
  1e:	4481                	li	s1,0
        sem_down(&s0);
  20:	00001a97          	auipc	s5,0x1
  24:	ff8a8a93          	addi	s5,s5,-8 # 1018 <s0>
        printf("T-0: hello\n");
  28:	00001a17          	auipc	s4,0x1
  2c:	bd8a0a13          	addi	s4,s4,-1064 # c00 <malloc+0xfc>
        sem_up(&s1);
  30:	00001997          	auipc	s3,0x1
  34:	fe098993          	addi	s3,s3,-32 # 1010 <s1>
    for (int i = 0; i < N; i++) {
  38:	00001917          	auipc	s2,0x1
  3c:	fc890913          	addi	s2,s2,-56 # 1000 <N>
        sem_down(&s0);
  40:	8556                	mv	a0,s5
  42:	520000ef          	jal	562 <sem_down>
        printf("T-0: hello\n");
  46:	8552                	mv	a0,s4
  48:	205000ef          	jal	a4c <printf>
        sem_up(&s1);
  4c:	854e                	mv	a0,s3
  4e:	57e000ef          	jal	5cc <sem_up>
    for (int i = 0; i < N; i++) {
  52:	2485                	addiw	s1,s1,1
  54:	00092783          	lw	a5,0(s2)
  58:	fef4c4e3          	blt	s1,a5,40 <t0+0x40>
    }
    exit(0);
  5c:	4501                	li	a0,0
  5e:	5b4000ef          	jal	612 <exit>

0000000000000062 <t1>:
}

void t1(int *arg)
{
  62:	7139                	addi	sp,sp,-64
  64:	fc06                	sd	ra,56(sp)
  66:	f822                	sd	s0,48(sp)
  68:	f426                	sd	s1,40(sp)
  6a:	f04a                	sd	s2,32(sp)
  6c:	ec4e                	sd	s3,24(sp)
  6e:	e852                	sd	s4,16(sp)
  70:	e456                	sd	s5,8(sp)
  72:	0080                	addi	s0,sp,64
    for (int i = 0; i < N; i++) {
  74:	00001797          	auipc	a5,0x1
  78:	f8c7a783          	lw	a5,-116(a5) # 1000 <N>
  7c:	04f05163          	blez	a5,be <t1+0x5c>
  80:	4481                	li	s1,0
        sem_down(&s1);
  82:	00001a97          	auipc	s5,0x1
  86:	f8ea8a93          	addi	s5,s5,-114 # 1010 <s1>
        printf("T-1: hello\n");
  8a:	00001a17          	auipc	s4,0x1
  8e:	b86a0a13          	addi	s4,s4,-1146 # c10 <malloc+0x10c>
        sem_up(&s2);
  92:	00001997          	auipc	s3,0x1
  96:	f7698993          	addi	s3,s3,-138 # 1008 <s2>
    for (int i = 0; i < N; i++) {
  9a:	00001917          	auipc	s2,0x1
  9e:	f6690913          	addi	s2,s2,-154 # 1000 <N>
        sem_down(&s1);
  a2:	8556                	mv	a0,s5
  a4:	4be000ef          	jal	562 <sem_down>
        printf("T-1: hello\n");
  a8:	8552                	mv	a0,s4
  aa:	1a3000ef          	jal	a4c <printf>
        sem_up(&s2);
  ae:	854e                	mv	a0,s3
  b0:	51c000ef          	jal	5cc <sem_up>
    for (int i = 0; i < N; i++) {
  b4:	2485                	addiw	s1,s1,1
  b6:	00092783          	lw	a5,0(s2)
  ba:	fef4c4e3          	blt	s1,a5,a2 <t1+0x40>
    }
    exit(0);
  be:	4501                	li	a0,0
  c0:	552000ef          	jal	612 <exit>

00000000000000c4 <t2>:
}

void t2(int *arg)
{
  c4:	7139                	addi	sp,sp,-64
  c6:	fc06                	sd	ra,56(sp)
  c8:	f822                	sd	s0,48(sp)
  ca:	f426                	sd	s1,40(sp)
  cc:	f04a                	sd	s2,32(sp)
  ce:	ec4e                	sd	s3,24(sp)
  d0:	e852                	sd	s4,16(sp)
  d2:	e456                	sd	s5,8(sp)
  d4:	0080                	addi	s0,sp,64
    for (int i = 0; i < N; i++) {
  d6:	00001797          	auipc	a5,0x1
  da:	f2a7a783          	lw	a5,-214(a5) # 1000 <N>
  de:	04f05163          	blez	a5,120 <t2+0x5c>
  e2:	4481                	li	s1,0
        sem_down(&s2);
  e4:	00001a97          	auipc	s5,0x1
  e8:	f24a8a93          	addi	s5,s5,-220 # 1008 <s2>
        printf("T-2: hello\n");
  ec:	00001a17          	auipc	s4,0x1
  f0:	b34a0a13          	addi	s4,s4,-1228 # c20 <malloc+0x11c>
        sem_up(&s0);
  f4:	00001997          	auipc	s3,0x1
  f8:	f2498993          	addi	s3,s3,-220 # 1018 <s0>
    for (int i = 0; i < N; i++) {
  fc:	00001917          	auipc	s2,0x1
 100:	f0490913          	addi	s2,s2,-252 # 1000 <N>
        sem_down(&s2);
 104:	8556                	mv	a0,s5
 106:	45c000ef          	jal	562 <sem_down>
        printf("T-2: hello\n");
 10a:	8552                	mv	a0,s4
 10c:	141000ef          	jal	a4c <printf>
        sem_up(&s0);
 110:	854e                	mv	a0,s3
 112:	4ba000ef          	jal	5cc <sem_up>
    for (int i = 0; i < N; i++) {
 116:	2485                	addiw	s1,s1,1
 118:	00092783          	lw	a5,0(s2)
 11c:	fef4c4e3          	blt	s1,a5,104 <t2+0x40>
    }
    exit(0);
 120:	4501                	li	a0,0
 122:	4f0000ef          	jal	612 <exit>

0000000000000126 <main>:
}

int main(int argc, char *argv[])
{
 126:	1101                	addi	sp,sp,-32
 128:	ec06                	sd	ra,24(sp)
 12a:	e822                	sd	s0,16(sp)
 12c:	1000                	addi	s0,sp,32
    if (argc < 2) {
 12e:	4785                	li	a5,1
 130:	08a7d663          	bge	a5,a0,1bc <main+0x96>
 134:	e426                	sd	s1,8(sp)
 136:	e04a                	sd	s2,0(sp)
        printf("Usage: p4 N\n");
        exit(0);
    }

    N = atoi(argv[1]);
 138:	6588                	ld	a0,8(a1)
 13a:	232000ef          	jal	36c <atoi>
 13e:	00001797          	auipc	a5,0x1
 142:	eca7a123          	sw	a0,-318(a5) # 1000 <N>

    // initialize semaphores
    s0.lock = s1.lock = s2.lock = 0;
 146:	00001497          	auipc	s1,0x1
 14a:	ec248493          	addi	s1,s1,-318 # 1008 <s2>
 14e:	0004a223          	sw	zero,4(s1)
 152:	00001917          	auipc	s2,0x1
 156:	ebe90913          	addi	s2,s2,-322 # 1010 <s1>
 15a:	00092223          	sw	zero,4(s2)
 15e:	00001517          	auipc	a0,0x1
 162:	eba50513          	addi	a0,a0,-326 # 1018 <s0>
 166:	00052223          	sw	zero,4(a0)
    sem_init(&s0, 1);  // T0 starts first
 16a:	4585                	li	a1,1
 16c:	3ba000ef          	jal	526 <sem_init>
    sem_init(&s1, 0);
 170:	4581                	li	a1,0
 172:	854a                	mv	a0,s2
 174:	3b2000ef          	jal	526 <sem_init>
    sem_init(&s2, 0);
 178:	4581                	li	a1,0
 17a:	8526                	mv	a0,s1
 17c:	3aa000ef          	jal	526 <sem_init>

    create_thread(t0, 0);
 180:	4581                	li	a1,0
 182:	00000517          	auipc	a0,0x0
 186:	e7e50513          	addi	a0,a0,-386 # 0 <t0>
 18a:	308000ef          	jal	492 <create_thread>
    create_thread(t1, 0);
 18e:	4581                	li	a1,0
 190:	00000517          	auipc	a0,0x0
 194:	ed250513          	addi	a0,a0,-302 # 62 <t1>
 198:	2fa000ef          	jal	492 <create_thread>
    create_thread(t2, 0);
 19c:	4581                	li	a1,0
 19e:	00000517          	auipc	a0,0x0
 1a2:	f2650513          	addi	a0,a0,-218 # c4 <t2>
 1a6:	2ec000ef          	jal	492 <create_thread>

    join();
 1aa:	510000ef          	jal	6ba <join>
    join();
 1ae:	50c000ef          	jal	6ba <join>
    join();
 1b2:	508000ef          	jal	6ba <join>

    exit(0);
 1b6:	4501                	li	a0,0
 1b8:	45a000ef          	jal	612 <exit>
 1bc:	e426                	sd	s1,8(sp)
 1be:	e04a                	sd	s2,0(sp)
        printf("Usage: p4 N\n");
 1c0:	00001517          	auipc	a0,0x1
 1c4:	a7050513          	addi	a0,a0,-1424 # c30 <malloc+0x12c>
 1c8:	085000ef          	jal	a4c <printf>
        exit(0);
 1cc:	4501                	li	a0,0
 1ce:	444000ef          	jal	612 <exit>

00000000000001d2 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e406                	sd	ra,8(sp)
 1d6:	e022                	sd	s0,0(sp)
 1d8:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 1da:	f4dff0ef          	jal	126 <main>
  exit(r);
 1de:	434000ef          	jal	612 <exit>

00000000000001e2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e406                	sd	ra,8(sp)
 1e6:	e022                	sd	s0,0(sp)
 1e8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ea:	87aa                	mv	a5,a0
 1ec:	0585                	addi	a1,a1,1
 1ee:	0785                	addi	a5,a5,1
 1f0:	fff5c703          	lbu	a4,-1(a1)
 1f4:	fee78fa3          	sb	a4,-1(a5)
 1f8:	fb75                	bnez	a4,1ec <strcpy+0xa>
    ;
  return os;
}
 1fa:	60a2                	ld	ra,8(sp)
 1fc:	6402                	ld	s0,0(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret

0000000000000202 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 202:	1141                	addi	sp,sp,-16
 204:	e406                	sd	ra,8(sp)
 206:	e022                	sd	s0,0(sp)
 208:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 20a:	00054783          	lbu	a5,0(a0)
 20e:	cb91                	beqz	a5,222 <strcmp+0x20>
 210:	0005c703          	lbu	a4,0(a1)
 214:	00f71763          	bne	a4,a5,222 <strcmp+0x20>
    p++, q++;
 218:	0505                	addi	a0,a0,1
 21a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 21c:	00054783          	lbu	a5,0(a0)
 220:	fbe5                	bnez	a5,210 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 222:	0005c503          	lbu	a0,0(a1)
}
 226:	40a7853b          	subw	a0,a5,a0
 22a:	60a2                	ld	ra,8(sp)
 22c:	6402                	ld	s0,0(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret

0000000000000232 <strlen>:

uint
strlen(const char *s)
{
 232:	1141                	addi	sp,sp,-16
 234:	e406                	sd	ra,8(sp)
 236:	e022                	sd	s0,0(sp)
 238:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 23a:	00054783          	lbu	a5,0(a0)
 23e:	cf99                	beqz	a5,25c <strlen+0x2a>
 240:	0505                	addi	a0,a0,1
 242:	87aa                	mv	a5,a0
 244:	86be                	mv	a3,a5
 246:	0785                	addi	a5,a5,1
 248:	fff7c703          	lbu	a4,-1(a5)
 24c:	ff65                	bnez	a4,244 <strlen+0x12>
 24e:	40a6853b          	subw	a0,a3,a0
 252:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 254:	60a2                	ld	ra,8(sp)
 256:	6402                	ld	s0,0(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
  for(n = 0; s[n]; n++)
 25c:	4501                	li	a0,0
 25e:	bfdd                	j	254 <strlen+0x22>

0000000000000260 <memset>:

void*
memset(void *dst, int c, uint n)
{
 260:	1141                	addi	sp,sp,-16
 262:	e406                	sd	ra,8(sp)
 264:	e022                	sd	s0,0(sp)
 266:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 268:	ca19                	beqz	a2,27e <memset+0x1e>
 26a:	87aa                	mv	a5,a0
 26c:	1602                	slli	a2,a2,0x20
 26e:	9201                	srli	a2,a2,0x20
 270:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 274:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 278:	0785                	addi	a5,a5,1
 27a:	fee79de3          	bne	a5,a4,274 <memset+0x14>
  }
  return dst;
}
 27e:	60a2                	ld	ra,8(sp)
 280:	6402                	ld	s0,0(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret

0000000000000286 <strchr>:

char*
strchr(const char *s, char c)
{
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 28e:	00054783          	lbu	a5,0(a0)
 292:	cf81                	beqz	a5,2aa <strchr+0x24>
    if(*s == c)
 294:	00f58763          	beq	a1,a5,2a2 <strchr+0x1c>
  for(; *s; s++)
 298:	0505                	addi	a0,a0,1
 29a:	00054783          	lbu	a5,0(a0)
 29e:	fbfd                	bnez	a5,294 <strchr+0xe>
      return (char*)s;
  return 0;
 2a0:	4501                	li	a0,0
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
  return 0;
 2aa:	4501                	li	a0,0
 2ac:	bfdd                	j	2a2 <strchr+0x1c>

00000000000002ae <gets>:

char*
gets(char *buf, int max)
{
 2ae:	7159                	addi	sp,sp,-112
 2b0:	f486                	sd	ra,104(sp)
 2b2:	f0a2                	sd	s0,96(sp)
 2b4:	eca6                	sd	s1,88(sp)
 2b6:	e8ca                	sd	s2,80(sp)
 2b8:	e4ce                	sd	s3,72(sp)
 2ba:	e0d2                	sd	s4,64(sp)
 2bc:	fc56                	sd	s5,56(sp)
 2be:	f85a                	sd	s6,48(sp)
 2c0:	f45e                	sd	s7,40(sp)
 2c2:	f062                	sd	s8,32(sp)
 2c4:	ec66                	sd	s9,24(sp)
 2c6:	e86a                	sd	s10,16(sp)
 2c8:	1880                	addi	s0,sp,112
 2ca:	8caa                	mv	s9,a0
 2cc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ce:	892a                	mv	s2,a0
 2d0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2d2:	f9f40b13          	addi	s6,s0,-97
 2d6:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d8:	4ba9                	li	s7,10
 2da:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 2dc:	8d26                	mv	s10,s1
 2de:	0014899b          	addiw	s3,s1,1
 2e2:	84ce                	mv	s1,s3
 2e4:	0349d563          	bge	s3,s4,30e <gets+0x60>
    cc = read(0, &c, 1);
 2e8:	8656                	mv	a2,s5
 2ea:	85da                	mv	a1,s6
 2ec:	4501                	li	a0,0
 2ee:	33c000ef          	jal	62a <read>
    if(cc < 1)
 2f2:	00a05e63          	blez	a0,30e <gets+0x60>
    buf[i++] = c;
 2f6:	f9f44783          	lbu	a5,-97(s0)
 2fa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2fe:	01778763          	beq	a5,s7,30c <gets+0x5e>
 302:	0905                	addi	s2,s2,1
 304:	fd879ce3          	bne	a5,s8,2dc <gets+0x2e>
    buf[i++] = c;
 308:	8d4e                	mv	s10,s3
 30a:	a011                	j	30e <gets+0x60>
 30c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 30e:	9d66                	add	s10,s10,s9
 310:	000d0023          	sb	zero,0(s10)
  return buf;
}
 314:	8566                	mv	a0,s9
 316:	70a6                	ld	ra,104(sp)
 318:	7406                	ld	s0,96(sp)
 31a:	64e6                	ld	s1,88(sp)
 31c:	6946                	ld	s2,80(sp)
 31e:	69a6                	ld	s3,72(sp)
 320:	6a06                	ld	s4,64(sp)
 322:	7ae2                	ld	s5,56(sp)
 324:	7b42                	ld	s6,48(sp)
 326:	7ba2                	ld	s7,40(sp)
 328:	7c02                	ld	s8,32(sp)
 32a:	6ce2                	ld	s9,24(sp)
 32c:	6d42                	ld	s10,16(sp)
 32e:	6165                	addi	sp,sp,112
 330:	8082                	ret

0000000000000332 <stat>:

int
stat(const char *n, struct stat *st)
{
 332:	1101                	addi	sp,sp,-32
 334:	ec06                	sd	ra,24(sp)
 336:	e822                	sd	s0,16(sp)
 338:	e04a                	sd	s2,0(sp)
 33a:	1000                	addi	s0,sp,32
 33c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33e:	4581                	li	a1,0
 340:	312000ef          	jal	652 <open>
  if(fd < 0)
 344:	02054263          	bltz	a0,368 <stat+0x36>
 348:	e426                	sd	s1,8(sp)
 34a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 34c:	85ca                	mv	a1,s2
 34e:	31c000ef          	jal	66a <fstat>
 352:	892a                	mv	s2,a0
  close(fd);
 354:	8526                	mv	a0,s1
 356:	2e4000ef          	jal	63a <close>
  return r;
 35a:	64a2                	ld	s1,8(sp)
}
 35c:	854a                	mv	a0,s2
 35e:	60e2                	ld	ra,24(sp)
 360:	6442                	ld	s0,16(sp)
 362:	6902                	ld	s2,0(sp)
 364:	6105                	addi	sp,sp,32
 366:	8082                	ret
    return -1;
 368:	597d                	li	s2,-1
 36a:	bfcd                	j	35c <stat+0x2a>

000000000000036c <atoi>:

int
atoi(const char *s)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e406                	sd	ra,8(sp)
 370:	e022                	sd	s0,0(sp)
 372:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 374:	00054683          	lbu	a3,0(a0)
 378:	fd06879b          	addiw	a5,a3,-48
 37c:	0ff7f793          	zext.b	a5,a5
 380:	4625                	li	a2,9
 382:	02f66963          	bltu	a2,a5,3b4 <atoi+0x48>
 386:	872a                	mv	a4,a0
  n = 0;
 388:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 38a:	0705                	addi	a4,a4,1
 38c:	0025179b          	slliw	a5,a0,0x2
 390:	9fa9                	addw	a5,a5,a0
 392:	0017979b          	slliw	a5,a5,0x1
 396:	9fb5                	addw	a5,a5,a3
 398:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 39c:	00074683          	lbu	a3,0(a4)
 3a0:	fd06879b          	addiw	a5,a3,-48
 3a4:	0ff7f793          	zext.b	a5,a5
 3a8:	fef671e3          	bgeu	a2,a5,38a <atoi+0x1e>
  return n;
}
 3ac:	60a2                	ld	ra,8(sp)
 3ae:	6402                	ld	s0,0(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
  n = 0;
 3b4:	4501                	li	a0,0
 3b6:	bfdd                	j	3ac <atoi+0x40>

00000000000003b8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e406                	sd	ra,8(sp)
 3bc:	e022                	sd	s0,0(sp)
 3be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c0:	02b57563          	bgeu	a0,a1,3ea <memmove+0x32>
    while(n-- > 0)
 3c4:	00c05f63          	blez	a2,3e2 <memmove+0x2a>
 3c8:	1602                	slli	a2,a2,0x20
 3ca:	9201                	srli	a2,a2,0x20
 3cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d0:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d2:	0585                	addi	a1,a1,1
 3d4:	0705                	addi	a4,a4,1
 3d6:	fff5c683          	lbu	a3,-1(a1)
 3da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3de:	fee79ae3          	bne	a5,a4,3d2 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e2:	60a2                	ld	ra,8(sp)
 3e4:	6402                	ld	s0,0(sp)
 3e6:	0141                	addi	sp,sp,16
 3e8:	8082                	ret
    dst += n;
 3ea:	00c50733          	add	a4,a0,a2
    src += n;
 3ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3f0:	fec059e3          	blez	a2,3e2 <memmove+0x2a>
 3f4:	fff6079b          	addiw	a5,a2,-1
 3f8:	1782                	slli	a5,a5,0x20
 3fa:	9381                	srli	a5,a5,0x20
 3fc:	fff7c793          	not	a5,a5
 400:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 402:	15fd                	addi	a1,a1,-1
 404:	177d                	addi	a4,a4,-1
 406:	0005c683          	lbu	a3,0(a1)
 40a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 40e:	fef71ae3          	bne	a4,a5,402 <memmove+0x4a>
 412:	bfc1                	j	3e2 <memmove+0x2a>

0000000000000414 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 414:	1141                	addi	sp,sp,-16
 416:	e406                	sd	ra,8(sp)
 418:	e022                	sd	s0,0(sp)
 41a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 41c:	ca0d                	beqz	a2,44e <memcmp+0x3a>
 41e:	fff6069b          	addiw	a3,a2,-1
 422:	1682                	slli	a3,a3,0x20
 424:	9281                	srli	a3,a3,0x20
 426:	0685                	addi	a3,a3,1
 428:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 42a:	00054783          	lbu	a5,0(a0)
 42e:	0005c703          	lbu	a4,0(a1)
 432:	00e79863          	bne	a5,a4,442 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 436:	0505                	addi	a0,a0,1
    p2++;
 438:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 43a:	fed518e3          	bne	a0,a3,42a <memcmp+0x16>
  }
  return 0;
 43e:	4501                	li	a0,0
 440:	a019                	j	446 <memcmp+0x32>
      return *p1 - *p2;
 442:	40e7853b          	subw	a0,a5,a4
}
 446:	60a2                	ld	ra,8(sp)
 448:	6402                	ld	s0,0(sp)
 44a:	0141                	addi	sp,sp,16
 44c:	8082                	ret
  return 0;
 44e:	4501                	li	a0,0
 450:	bfdd                	j	446 <memcmp+0x32>

0000000000000452 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 452:	1141                	addi	sp,sp,-16
 454:	e406                	sd	ra,8(sp)
 456:	e022                	sd	s0,0(sp)
 458:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 45a:	f5fff0ef          	jal	3b8 <memmove>
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret

0000000000000466 <sbrk>:

char *
sbrk(int n) {
 466:	1141                	addi	sp,sp,-16
 468:	e406                	sd	ra,8(sp)
 46a:	e022                	sd	s0,0(sp)
 46c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 46e:	4585                	li	a1,1
 470:	22a000ef          	jal	69a <sys_sbrk>
}
 474:	60a2                	ld	ra,8(sp)
 476:	6402                	ld	s0,0(sp)
 478:	0141                	addi	sp,sp,16
 47a:	8082                	ret

000000000000047c <sbrklazy>:

char *
sbrklazy(int n) {
 47c:	1141                	addi	sp,sp,-16
 47e:	e406                	sd	ra,8(sp)
 480:	e022                	sd	s0,0(sp)
 482:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 484:	4589                	li	a1,2
 486:	214000ef          	jal	69a <sys_sbrk>
}
 48a:	60a2                	ld	ra,8(sp)
 48c:	6402                	ld	s0,0(sp)
 48e:	0141                	addi	sp,sp,16
 490:	8082                	ret

0000000000000492 <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 492:	1101                	addi	sp,sp,-32
 494:	ec06                	sd	ra,24(sp)
 496:	e822                	sd	s0,16(sp)
 498:	e426                	sd	s1,8(sp)
 49a:	e04a                	sd	s2,0(sp)
 49c:	1000                	addi	s0,sp,32
 49e:	84aa                	mv	s1,a0
 4a0:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 4a2:	6505                	lui	a0,0x1
 4a4:	fc3ff0ef          	jal	466 <sbrk>
 4a8:	6785                	lui	a5,0x1
 4aa:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 4ae:	9a41                	andi	a2,a2,-16
 4b0:	85ca                	mv	a1,s2
 4b2:	8526                	mv	a0,s1
 4b4:	1fe000ef          	jal	6b2 <clone>
}
 4b8:	60e2                	ld	ra,24(sp)
 4ba:	6442                	ld	s0,16(sp)
 4bc:	64a2                	ld	s1,8(sp)
 4be:	6902                	ld	s2,0(sp)
 4c0:	6105                	addi	sp,sp,32
 4c2:	8082                	ret

00000000000004c4 <futex>:

void futex(int *uaddr, int ops, int val) {
 4c4:	7179                	addi	sp,sp,-48
 4c6:	f406                	sd	ra,40(sp)
 4c8:	f022                	sd	s0,32(sp)
 4ca:	ec26                	sd	s1,24(sp)
 4cc:	1800                	addi	s0,sp,48
 4ce:	84aa                	mv	s1,a0
  if (ops==0) {
 4d0:	ed95                	bnez	a1,50c <futex+0x48>
    if (val==0) {
 4d2:	c611                	beqz	a2,4de <futex+0x1a>
 4d4:	e84a                	sd	s2,16(sp)
 4d6:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 4d8:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 4da:	4985                	li	s3,1
 4dc:	a005                	j	4fc <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 4de:	4705                	li	a4,1
 4e0:	87ba                	mv	a5,a4
 4e2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 4e6:	2781                	sext.w	a5,a5
 4e8:	ffe5                	bnez	a5,4e0 <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 4ea:	70a2                	ld	ra,40(sp)
 4ec:	7402                	ld	s0,32(sp)
 4ee:	64e2                	ld	s1,24(sp)
 4f0:	6145                	addi	sp,sp,48
 4f2:	8082                	ret
        futex_wait(uaddr, 1);
 4f4:	85ce                	mv	a1,s3
 4f6:	8526                	mv	a0,s1
 4f8:	1ca000ef          	jal	6c2 <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 4fc:	87ca                	mv	a5,s2
 4fe:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 502:	2781                	sext.w	a5,a5
 504:	fbe5                	bnez	a5,4f4 <futex+0x30>
 506:	6942                	ld	s2,16(sp)
 508:	69a2                	ld	s3,8(sp)
 50a:	b7c5                	j	4ea <futex+0x26>
    if (val==0) {
 50c:	e611                	bnez	a2,518 <futex+0x54>
      __sync_lock_release(uaddr);
 50e:	0310000f          	fence	rw,w
 512:	00052023          	sw	zero,0(a0) # 1000 <N>
 516:	bfd1                	j	4ea <futex+0x26>
      __sync_lock_release(uaddr);
 518:	0310000f          	fence	rw,w
 51c:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 520:	1aa000ef          	jal	6ca <futex_wake>
  return;
 524:	b7d9                	j	4ea <futex+0x26>

0000000000000526 <sem_init>:

void sem_init(sem_t* s, int val) {
 526:	7179                	addi	sp,sp,-48
 528:	f406                	sd	ra,40(sp)
 52a:	f022                	sd	s0,32(sp)
 52c:	ec26                	sd	s1,24(sp)
 52e:	e84a                	sd	s2,16(sp)
 530:	e44e                	sd	s3,8(sp)
 532:	1800                	addi	s0,sp,48
 534:	84aa                	mv	s1,a0
 536:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 538:	00450993          	addi	s3,a0,4
 53c:	4605                	li	a2,1
 53e:	4581                	li	a1,0
 540:	854e                	mv	a0,s3
 542:	f83ff0ef          	jal	4c4 <futex>
  s->value = val;
 546:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 54a:	4605                	li	a2,1
 54c:	85b2                	mv	a1,a2
 54e:	854e                	mv	a0,s3
 550:	f75ff0ef          	jal	4c4 <futex>
  return;
}
 554:	70a2                	ld	ra,40(sp)
 556:	7402                	ld	s0,32(sp)
 558:	64e2                	ld	s1,24(sp)
 55a:	6942                	ld	s2,16(sp)
 55c:	69a2                	ld	s3,8(sp)
 55e:	6145                	addi	sp,sp,48
 560:	8082                	ret

0000000000000562 <sem_down>:

void sem_down(sem_t* s) {
 562:	7179                	addi	sp,sp,-48
 564:	f406                	sd	ra,40(sp)
 566:	f022                	sd	s0,32(sp)
 568:	ec26                	sd	s1,24(sp)
 56a:	e84a                	sd	s2,16(sp)
 56c:	e44e                	sd	s3,8(sp)
 56e:	1800                	addi	s0,sp,48
 570:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 572:	00450993          	addi	s3,a0,4
 576:	4605                	li	a2,1
 578:	4581                	li	a1,0
 57a:	854e                	mv	a0,s3
 57c:	f49ff0ef          	jal	4c4 <futex>
  while(1) {
    if (s->value>0) {
 580:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 584:	4485                	li	s1,1
    if (s->value>0) {
 586:	02f04463          	bgtz	a5,5ae <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 58a:	8626                	mv	a2,s1
 58c:	85a6                	mv	a1,s1
 58e:	854e                	mv	a0,s3
 590:	f35ff0ef          	jal	4c4 <futex>
      futex_wait(&s->value,1);
 594:	85a6                	mv	a1,s1
 596:	854a                	mv	a0,s2
 598:	12a000ef          	jal	6c2 <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 59c:	8626                	mv	a2,s1
 59e:	4581                	li	a1,0
 5a0:	854e                	mv	a0,s3
 5a2:	f23ff0ef          	jal	4c4 <futex>
    if (s->value>0) {
 5a6:	00092783          	lw	a5,0(s2)
 5aa:	fef050e3          	blez	a5,58a <sem_down+0x28>
      s->value--;
 5ae:	37fd                	addiw	a5,a5,-1 # fff <digits+0x3b7>
 5b0:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 5b4:	4605                	li	a2,1
 5b6:	85b2                	mv	a1,a2
 5b8:	854e                	mv	a0,s3
 5ba:	f0bff0ef          	jal	4c4 <futex>
  return;
}
 5be:	70a2                	ld	ra,40(sp)
 5c0:	7402                	ld	s0,32(sp)
 5c2:	64e2                	ld	s1,24(sp)
 5c4:	6942                	ld	s2,16(sp)
 5c6:	69a2                	ld	s3,8(sp)
 5c8:	6145                	addi	sp,sp,48
 5ca:	8082                	ret

00000000000005cc <sem_up>:

void sem_up(sem_t* s) {
 5cc:	1101                	addi	sp,sp,-32
 5ce:	ec06                	sd	ra,24(sp)
 5d0:	e822                	sd	s0,16(sp)
 5d2:	e426                	sd	s1,8(sp)
 5d4:	e04a                	sd	s2,0(sp)
 5d6:	1000                	addi	s0,sp,32
 5d8:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 5da:	00450913          	addi	s2,a0,4
 5de:	4605                	li	a2,1
 5e0:	4581                	li	a1,0
 5e2:	854a                	mv	a0,s2
 5e4:	ee1ff0ef          	jal	4c4 <futex>
  s->value++;
 5e8:	409c                	lw	a5,0(s1)
 5ea:	2785                	addiw	a5,a5,1
 5ec:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 5ee:	8526                	mv	a0,s1
 5f0:	0da000ef          	jal	6ca <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 5f4:	4605                	li	a2,1
 5f6:	85b2                	mv	a1,a2
 5f8:	854a                	mv	a0,s2
 5fa:	ecbff0ef          	jal	4c4 <futex>
  return;
 5fe:	60e2                	ld	ra,24(sp)
 600:	6442                	ld	s0,16(sp)
 602:	64a2                	ld	s1,8(sp)
 604:	6902                	ld	s2,0(sp)
 606:	6105                	addi	sp,sp,32
 608:	8082                	ret

000000000000060a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 60a:	4885                	li	a7,1
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <exit>:
.global exit
exit:
 li a7, SYS_exit
 612:	4889                	li	a7,2
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <wait>:
.global wait
wait:
 li a7, SYS_wait
 61a:	488d                	li	a7,3
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 622:	4891                	li	a7,4
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <read>:
.global read
read:
 li a7, SYS_read
 62a:	4895                	li	a7,5
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <write>:
.global write
write:
 li a7, SYS_write
 632:	48c1                	li	a7,16
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <close>:
.global close
close:
 li a7, SYS_close
 63a:	48d5                	li	a7,21
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <kill>:
.global kill
kill:
 li a7, SYS_kill
 642:	4899                	li	a7,6
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <exec>:
.global exec
exec:
 li a7, SYS_exec
 64a:	489d                	li	a7,7
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <open>:
.global open
open:
 li a7, SYS_open
 652:	48bd                	li	a7,15
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 65a:	48c5                	li	a7,17
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 662:	48c9                	li	a7,18
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 66a:	48a1                	li	a7,8
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <link>:
.global link
link:
 li a7, SYS_link
 672:	48cd                	li	a7,19
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 67a:	48d1                	li	a7,20
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 682:	48a5                	li	a7,9
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <dup>:
.global dup
dup:
 li a7, SYS_dup
 68a:	48a9                	li	a7,10
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 692:	48ad                	li	a7,11
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 69a:	48b1                	li	a7,12
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 6a2:	48b5                	li	a7,13
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6aa:	48b9                	li	a7,14
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <clone>:
.global clone
clone:
 li a7, SYS_clone
 6b2:	48d9                	li	a7,22
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <join>:
.global join
join:
 li a7, SYS_join
 6ba:	48dd                	li	a7,23
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 6c2:	48e1                	li	a7,24
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 6ca:	48e5                	li	a7,25
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6d2:	1101                	addi	sp,sp,-32
 6d4:	ec06                	sd	ra,24(sp)
 6d6:	e822                	sd	s0,16(sp)
 6d8:	1000                	addi	s0,sp,32
 6da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6de:	4605                	li	a2,1
 6e0:	fef40593          	addi	a1,s0,-17
 6e4:	f4fff0ef          	jal	632 <write>
}
 6e8:	60e2                	ld	ra,24(sp)
 6ea:	6442                	ld	s0,16(sp)
 6ec:	6105                	addi	sp,sp,32
 6ee:	8082                	ret

00000000000006f0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 6f0:	715d                	addi	sp,sp,-80
 6f2:	e486                	sd	ra,72(sp)
 6f4:	e0a2                	sd	s0,64(sp)
 6f6:	fc26                	sd	s1,56(sp)
 6f8:	f84a                	sd	s2,48(sp)
 6fa:	f44e                	sd	s3,40(sp)
 6fc:	0880                	addi	s0,sp,80
 6fe:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 700:	c299                	beqz	a3,706 <printint+0x16>
 702:	0605cc63          	bltz	a1,77a <printint+0x8a>
  neg = 0;
 706:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 708:	fb840313          	addi	t1,s0,-72
  neg = 0;
 70c:	869a                	mv	a3,t1
  i = 0;
 70e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 710:	00000817          	auipc	a6,0x0
 714:	53880813          	addi	a6,a6,1336 # c48 <digits>
 718:	88be                	mv	a7,a5
 71a:	0017851b          	addiw	a0,a5,1
 71e:	87aa                	mv	a5,a0
 720:	02c5f733          	remu	a4,a1,a2
 724:	9742                	add	a4,a4,a6
 726:	00074703          	lbu	a4,0(a4)
 72a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 72e:	872e                	mv	a4,a1
 730:	02c5d5b3          	divu	a1,a1,a2
 734:	0685                	addi	a3,a3,1
 736:	fec771e3          	bgeu	a4,a2,718 <printint+0x28>
  if(neg)
 73a:	000e0c63          	beqz	t3,752 <printint+0x62>
    buf[i++] = '-';
 73e:	fd050793          	addi	a5,a0,-48
 742:	00878533          	add	a0,a5,s0
 746:	02d00793          	li	a5,45
 74a:	fef50423          	sb	a5,-24(a0)
 74e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 752:	fff7899b          	addiw	s3,a5,-1
 756:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 75a:	fff4c583          	lbu	a1,-1(s1)
 75e:	854a                	mv	a0,s2
 760:	f73ff0ef          	jal	6d2 <putc>
  while(--i >= 0)
 764:	39fd                	addiw	s3,s3,-1
 766:	14fd                	addi	s1,s1,-1
 768:	fe09d9e3          	bgez	s3,75a <printint+0x6a>
}
 76c:	60a6                	ld	ra,72(sp)
 76e:	6406                	ld	s0,64(sp)
 770:	74e2                	ld	s1,56(sp)
 772:	7942                	ld	s2,48(sp)
 774:	79a2                	ld	s3,40(sp)
 776:	6161                	addi	sp,sp,80
 778:	8082                	ret
    x = -xx;
 77a:	40b005b3          	neg	a1,a1
    neg = 1;
 77e:	4e05                	li	t3,1
    x = -xx;
 780:	b761                	j	708 <printint+0x18>

0000000000000782 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 782:	711d                	addi	sp,sp,-96
 784:	ec86                	sd	ra,88(sp)
 786:	e8a2                	sd	s0,80(sp)
 788:	e4a6                	sd	s1,72(sp)
 78a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 78c:	0005c483          	lbu	s1,0(a1)
 790:	28048463          	beqz	s1,a18 <vprintf+0x296>
 794:	e0ca                	sd	s2,64(sp)
 796:	fc4e                	sd	s3,56(sp)
 798:	f852                	sd	s4,48(sp)
 79a:	f456                	sd	s5,40(sp)
 79c:	f05a                	sd	s6,32(sp)
 79e:	ec5e                	sd	s7,24(sp)
 7a0:	e862                	sd	s8,16(sp)
 7a2:	e466                	sd	s9,8(sp)
 7a4:	8b2a                	mv	s6,a0
 7a6:	8a2e                	mv	s4,a1
 7a8:	8bb2                	mv	s7,a2
  state = 0;
 7aa:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7ac:	4901                	li	s2,0
 7ae:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7b0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7b4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 7b8:	06c00c93          	li	s9,108
 7bc:	a00d                	j	7de <vprintf+0x5c>
        putc(fd, c0);
 7be:	85a6                	mv	a1,s1
 7c0:	855a                	mv	a0,s6
 7c2:	f11ff0ef          	jal	6d2 <putc>
 7c6:	a019                	j	7cc <vprintf+0x4a>
    } else if(state == '%'){
 7c8:	03598363          	beq	s3,s5,7ee <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 7cc:	0019079b          	addiw	a5,s2,1
 7d0:	893e                	mv	s2,a5
 7d2:	873e                	mv	a4,a5
 7d4:	97d2                	add	a5,a5,s4
 7d6:	0007c483          	lbu	s1,0(a5)
 7da:	22048763          	beqz	s1,a08 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 7de:	0004879b          	sext.w	a5,s1
    if(state == 0){
 7e2:	fe0993e3          	bnez	s3,7c8 <vprintf+0x46>
      if(c0 == '%'){
 7e6:	fd579ce3          	bne	a5,s5,7be <vprintf+0x3c>
        state = '%';
 7ea:	89be                	mv	s3,a5
 7ec:	b7c5                	j	7cc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 7ee:	00ea06b3          	add	a3,s4,a4
 7f2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 7f6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 7f8:	c681                	beqz	a3,800 <vprintf+0x7e>
 7fa:	9752                	add	a4,a4,s4
 7fc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 800:	05878263          	beq	a5,s8,844 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 804:	05978c63          	beq	a5,s9,85c <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 808:	07500713          	li	a4,117
 80c:	0ee78663          	beq	a5,a4,8f8 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 810:	07800713          	li	a4,120
 814:	12e78863          	beq	a5,a4,944 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 818:	07000713          	li	a4,112
 81c:	14e78d63          	beq	a5,a4,976 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 820:	06300713          	li	a4,99
 824:	18e78c63          	beq	a5,a4,9bc <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 828:	07300713          	li	a4,115
 82c:	1ae78263          	beq	a5,a4,9d0 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 830:	02500713          	li	a4,37
 834:	04e79463          	bne	a5,a4,87c <vprintf+0xfa>
        putc(fd, '%');
 838:	85ba                	mv	a1,a4
 83a:	855a                	mv	a0,s6
 83c:	e97ff0ef          	jal	6d2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 840:	4981                	li	s3,0
 842:	b769                	j	7cc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 844:	008b8493          	addi	s1,s7,8
 848:	4685                	li	a3,1
 84a:	4629                	li	a2,10
 84c:	000ba583          	lw	a1,0(s7)
 850:	855a                	mv	a0,s6
 852:	e9fff0ef          	jal	6f0 <printint>
 856:	8ba6                	mv	s7,s1
      state = 0;
 858:	4981                	li	s3,0
 85a:	bf8d                	j	7cc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 85c:	06400793          	li	a5,100
 860:	02f68963          	beq	a3,a5,892 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 864:	06c00793          	li	a5,108
 868:	04f68263          	beq	a3,a5,8ac <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 86c:	07500793          	li	a5,117
 870:	0af68063          	beq	a3,a5,910 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 874:	07800793          	li	a5,120
 878:	0ef68263          	beq	a3,a5,95c <vprintf+0x1da>
        putc(fd, '%');
 87c:	02500593          	li	a1,37
 880:	855a                	mv	a0,s6
 882:	e51ff0ef          	jal	6d2 <putc>
        putc(fd, c0);
 886:	85a6                	mv	a1,s1
 888:	855a                	mv	a0,s6
 88a:	e49ff0ef          	jal	6d2 <putc>
      state = 0;
 88e:	4981                	li	s3,0
 890:	bf35                	j	7cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 892:	008b8493          	addi	s1,s7,8
 896:	4685                	li	a3,1
 898:	4629                	li	a2,10
 89a:	000bb583          	ld	a1,0(s7)
 89e:	855a                	mv	a0,s6
 8a0:	e51ff0ef          	jal	6f0 <printint>
        i += 1;
 8a4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8a6:	8ba6                	mv	s7,s1
      state = 0;
 8a8:	4981                	li	s3,0
        i += 1;
 8aa:	b70d                	j	7cc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8ac:	06400793          	li	a5,100
 8b0:	02f60763          	beq	a2,a5,8de <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8b4:	07500793          	li	a5,117
 8b8:	06f60963          	beq	a2,a5,92a <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8bc:	07800793          	li	a5,120
 8c0:	faf61ee3          	bne	a2,a5,87c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8c4:	008b8493          	addi	s1,s7,8
 8c8:	4681                	li	a3,0
 8ca:	4641                	li	a2,16
 8cc:	000bb583          	ld	a1,0(s7)
 8d0:	855a                	mv	a0,s6
 8d2:	e1fff0ef          	jal	6f0 <printint>
        i += 2;
 8d6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 8d8:	8ba6                	mv	s7,s1
      state = 0;
 8da:	4981                	li	s3,0
        i += 2;
 8dc:	bdc5                	j	7cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8de:	008b8493          	addi	s1,s7,8
 8e2:	4685                	li	a3,1
 8e4:	4629                	li	a2,10
 8e6:	000bb583          	ld	a1,0(s7)
 8ea:	855a                	mv	a0,s6
 8ec:	e05ff0ef          	jal	6f0 <printint>
        i += 2;
 8f0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8f2:	8ba6                	mv	s7,s1
      state = 0;
 8f4:	4981                	li	s3,0
        i += 2;
 8f6:	bdd9                	j	7cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 8f8:	008b8493          	addi	s1,s7,8
 8fc:	4681                	li	a3,0
 8fe:	4629                	li	a2,10
 900:	000be583          	lwu	a1,0(s7)
 904:	855a                	mv	a0,s6
 906:	debff0ef          	jal	6f0 <printint>
 90a:	8ba6                	mv	s7,s1
      state = 0;
 90c:	4981                	li	s3,0
 90e:	bd7d                	j	7cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 910:	008b8493          	addi	s1,s7,8
 914:	4681                	li	a3,0
 916:	4629                	li	a2,10
 918:	000bb583          	ld	a1,0(s7)
 91c:	855a                	mv	a0,s6
 91e:	dd3ff0ef          	jal	6f0 <printint>
        i += 1;
 922:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 924:	8ba6                	mv	s7,s1
      state = 0;
 926:	4981                	li	s3,0
        i += 1;
 928:	b555                	j	7cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 92a:	008b8493          	addi	s1,s7,8
 92e:	4681                	li	a3,0
 930:	4629                	li	a2,10
 932:	000bb583          	ld	a1,0(s7)
 936:	855a                	mv	a0,s6
 938:	db9ff0ef          	jal	6f0 <printint>
        i += 2;
 93c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 93e:	8ba6                	mv	s7,s1
      state = 0;
 940:	4981                	li	s3,0
        i += 2;
 942:	b569                	j	7cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 944:	008b8493          	addi	s1,s7,8
 948:	4681                	li	a3,0
 94a:	4641                	li	a2,16
 94c:	000be583          	lwu	a1,0(s7)
 950:	855a                	mv	a0,s6
 952:	d9fff0ef          	jal	6f0 <printint>
 956:	8ba6                	mv	s7,s1
      state = 0;
 958:	4981                	li	s3,0
 95a:	bd8d                	j	7cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 95c:	008b8493          	addi	s1,s7,8
 960:	4681                	li	a3,0
 962:	4641                	li	a2,16
 964:	000bb583          	ld	a1,0(s7)
 968:	855a                	mv	a0,s6
 96a:	d87ff0ef          	jal	6f0 <printint>
        i += 1;
 96e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 970:	8ba6                	mv	s7,s1
      state = 0;
 972:	4981                	li	s3,0
        i += 1;
 974:	bda1                	j	7cc <vprintf+0x4a>
 976:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 978:	008b8d13          	addi	s10,s7,8
 97c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 980:	03000593          	li	a1,48
 984:	855a                	mv	a0,s6
 986:	d4dff0ef          	jal	6d2 <putc>
  putc(fd, 'x');
 98a:	07800593          	li	a1,120
 98e:	855a                	mv	a0,s6
 990:	d43ff0ef          	jal	6d2 <putc>
 994:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 996:	00000b97          	auipc	s7,0x0
 99a:	2b2b8b93          	addi	s7,s7,690 # c48 <digits>
 99e:	03c9d793          	srli	a5,s3,0x3c
 9a2:	97de                	add	a5,a5,s7
 9a4:	0007c583          	lbu	a1,0(a5)
 9a8:	855a                	mv	a0,s6
 9aa:	d29ff0ef          	jal	6d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9ae:	0992                	slli	s3,s3,0x4
 9b0:	34fd                	addiw	s1,s1,-1
 9b2:	f4f5                	bnez	s1,99e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 9b4:	8bea                	mv	s7,s10
      state = 0;
 9b6:	4981                	li	s3,0
 9b8:	6d02                	ld	s10,0(sp)
 9ba:	bd09                	j	7cc <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 9bc:	008b8493          	addi	s1,s7,8
 9c0:	000bc583          	lbu	a1,0(s7)
 9c4:	855a                	mv	a0,s6
 9c6:	d0dff0ef          	jal	6d2 <putc>
 9ca:	8ba6                	mv	s7,s1
      state = 0;
 9cc:	4981                	li	s3,0
 9ce:	bbfd                	j	7cc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 9d0:	008b8993          	addi	s3,s7,8
 9d4:	000bb483          	ld	s1,0(s7)
 9d8:	cc91                	beqz	s1,9f4 <vprintf+0x272>
        for(; *s; s++)
 9da:	0004c583          	lbu	a1,0(s1)
 9de:	c195                	beqz	a1,a02 <vprintf+0x280>
          putc(fd, *s);
 9e0:	855a                	mv	a0,s6
 9e2:	cf1ff0ef          	jal	6d2 <putc>
        for(; *s; s++)
 9e6:	0485                	addi	s1,s1,1
 9e8:	0004c583          	lbu	a1,0(s1)
 9ec:	f9f5                	bnez	a1,9e0 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 9ee:	8bce                	mv	s7,s3
      state = 0;
 9f0:	4981                	li	s3,0
 9f2:	bbe9                	j	7cc <vprintf+0x4a>
          s = "(null)";
 9f4:	00000497          	auipc	s1,0x0
 9f8:	24c48493          	addi	s1,s1,588 # c40 <malloc+0x13c>
        for(; *s; s++)
 9fc:	02800593          	li	a1,40
 a00:	b7c5                	j	9e0 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 a02:	8bce                	mv	s7,s3
      state = 0;
 a04:	4981                	li	s3,0
 a06:	b3d9                	j	7cc <vprintf+0x4a>
 a08:	6906                	ld	s2,64(sp)
 a0a:	79e2                	ld	s3,56(sp)
 a0c:	7a42                	ld	s4,48(sp)
 a0e:	7aa2                	ld	s5,40(sp)
 a10:	7b02                	ld	s6,32(sp)
 a12:	6be2                	ld	s7,24(sp)
 a14:	6c42                	ld	s8,16(sp)
 a16:	6ca2                	ld	s9,8(sp)
    }
  }
}
 a18:	60e6                	ld	ra,88(sp)
 a1a:	6446                	ld	s0,80(sp)
 a1c:	64a6                	ld	s1,72(sp)
 a1e:	6125                	addi	sp,sp,96
 a20:	8082                	ret

0000000000000a22 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a22:	715d                	addi	sp,sp,-80
 a24:	ec06                	sd	ra,24(sp)
 a26:	e822                	sd	s0,16(sp)
 a28:	1000                	addi	s0,sp,32
 a2a:	e010                	sd	a2,0(s0)
 a2c:	e414                	sd	a3,8(s0)
 a2e:	e818                	sd	a4,16(s0)
 a30:	ec1c                	sd	a5,24(s0)
 a32:	03043023          	sd	a6,32(s0)
 a36:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a3a:	8622                	mv	a2,s0
 a3c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a40:	d43ff0ef          	jal	782 <vprintf>
}
 a44:	60e2                	ld	ra,24(sp)
 a46:	6442                	ld	s0,16(sp)
 a48:	6161                	addi	sp,sp,80
 a4a:	8082                	ret

0000000000000a4c <printf>:

void
printf(const char *fmt, ...)
{
 a4c:	711d                	addi	sp,sp,-96
 a4e:	ec06                	sd	ra,24(sp)
 a50:	e822                	sd	s0,16(sp)
 a52:	1000                	addi	s0,sp,32
 a54:	e40c                	sd	a1,8(s0)
 a56:	e810                	sd	a2,16(s0)
 a58:	ec14                	sd	a3,24(s0)
 a5a:	f018                	sd	a4,32(s0)
 a5c:	f41c                	sd	a5,40(s0)
 a5e:	03043823          	sd	a6,48(s0)
 a62:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a66:	00840613          	addi	a2,s0,8
 a6a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a6e:	85aa                	mv	a1,a0
 a70:	4505                	li	a0,1
 a72:	d11ff0ef          	jal	782 <vprintf>
}
 a76:	60e2                	ld	ra,24(sp)
 a78:	6442                	ld	s0,16(sp)
 a7a:	6125                	addi	sp,sp,96
 a7c:	8082                	ret

0000000000000a7e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a7e:	1141                	addi	sp,sp,-16
 a80:	e406                	sd	ra,8(sp)
 a82:	e022                	sd	s0,0(sp)
 a84:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a86:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8a:	00000797          	auipc	a5,0x0
 a8e:	5967b783          	ld	a5,1430(a5) # 1020 <freep>
 a92:	a02d                	j	abc <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a94:	4618                	lw	a4,8(a2)
 a96:	9f2d                	addw	a4,a4,a1
 a98:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a9c:	6398                	ld	a4,0(a5)
 a9e:	6310                	ld	a2,0(a4)
 aa0:	a83d                	j	ade <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 aa2:	ff852703          	lw	a4,-8(a0)
 aa6:	9f31                	addw	a4,a4,a2
 aa8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 aaa:	ff053683          	ld	a3,-16(a0)
 aae:	a091                	j	af2 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ab0:	6398                	ld	a4,0(a5)
 ab2:	00e7e463          	bltu	a5,a4,aba <free+0x3c>
 ab6:	00e6ea63          	bltu	a3,a4,aca <free+0x4c>
{
 aba:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 abc:	fed7fae3          	bgeu	a5,a3,ab0 <free+0x32>
 ac0:	6398                	ld	a4,0(a5)
 ac2:	00e6e463          	bltu	a3,a4,aca <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac6:	fee7eae3          	bltu	a5,a4,aba <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 aca:	ff852583          	lw	a1,-8(a0)
 ace:	6390                	ld	a2,0(a5)
 ad0:	02059813          	slli	a6,a1,0x20
 ad4:	01c85713          	srli	a4,a6,0x1c
 ad8:	9736                	add	a4,a4,a3
 ada:	fae60de3          	beq	a2,a4,a94 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 ade:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ae2:	4790                	lw	a2,8(a5)
 ae4:	02061593          	slli	a1,a2,0x20
 ae8:	01c5d713          	srli	a4,a1,0x1c
 aec:	973e                	add	a4,a4,a5
 aee:	fae68ae3          	beq	a3,a4,aa2 <free+0x24>
    p->s.ptr = bp->s.ptr;
 af2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 af4:	00000717          	auipc	a4,0x0
 af8:	52f73623          	sd	a5,1324(a4) # 1020 <freep>
}
 afc:	60a2                	ld	ra,8(sp)
 afe:	6402                	ld	s0,0(sp)
 b00:	0141                	addi	sp,sp,16
 b02:	8082                	ret

0000000000000b04 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b04:	7139                	addi	sp,sp,-64
 b06:	fc06                	sd	ra,56(sp)
 b08:	f822                	sd	s0,48(sp)
 b0a:	f04a                	sd	s2,32(sp)
 b0c:	ec4e                	sd	s3,24(sp)
 b0e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b10:	02051993          	slli	s3,a0,0x20
 b14:	0209d993          	srli	s3,s3,0x20
 b18:	09bd                	addi	s3,s3,15
 b1a:	0049d993          	srli	s3,s3,0x4
 b1e:	2985                	addiw	s3,s3,1
 b20:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 b22:	00000517          	auipc	a0,0x0
 b26:	4fe53503          	ld	a0,1278(a0) # 1020 <freep>
 b2a:	c905                	beqz	a0,b5a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b2c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b2e:	4798                	lw	a4,8(a5)
 b30:	09377663          	bgeu	a4,s3,bbc <malloc+0xb8>
 b34:	f426                	sd	s1,40(sp)
 b36:	e852                	sd	s4,16(sp)
 b38:	e456                	sd	s5,8(sp)
 b3a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b3c:	8a4e                	mv	s4,s3
 b3e:	6705                	lui	a4,0x1
 b40:	00e9f363          	bgeu	s3,a4,b46 <malloc+0x42>
 b44:	6a05                	lui	s4,0x1
 b46:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b4a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b4e:	00000497          	auipc	s1,0x0
 b52:	4d248493          	addi	s1,s1,1234 # 1020 <freep>
  if(p == SBRK_ERROR)
 b56:	5afd                	li	s5,-1
 b58:	a83d                	j	b96 <malloc+0x92>
 b5a:	f426                	sd	s1,40(sp)
 b5c:	e852                	sd	s4,16(sp)
 b5e:	e456                	sd	s5,8(sp)
 b60:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b62:	00000797          	auipc	a5,0x0
 b66:	4ce78793          	addi	a5,a5,1230 # 1030 <base>
 b6a:	00000717          	auipc	a4,0x0
 b6e:	4af73b23          	sd	a5,1206(a4) # 1020 <freep>
 b72:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b74:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b78:	b7d1                	j	b3c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b7a:	6398                	ld	a4,0(a5)
 b7c:	e118                	sd	a4,0(a0)
 b7e:	a899                	j	bd4 <malloc+0xd0>
  hp->s.size = nu;
 b80:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b84:	0541                	addi	a0,a0,16
 b86:	ef9ff0ef          	jal	a7e <free>
  return freep;
 b8a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b8c:	c125                	beqz	a0,bec <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b8e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b90:	4798                	lw	a4,8(a5)
 b92:	03277163          	bgeu	a4,s2,bb4 <malloc+0xb0>
    if(p == freep)
 b96:	6098                	ld	a4,0(s1)
 b98:	853e                	mv	a0,a5
 b9a:	fef71ae3          	bne	a4,a5,b8e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b9e:	8552                	mv	a0,s4
 ba0:	8c7ff0ef          	jal	466 <sbrk>
  if(p == SBRK_ERROR)
 ba4:	fd551ee3          	bne	a0,s5,b80 <malloc+0x7c>
        return 0;
 ba8:	4501                	li	a0,0
 baa:	74a2                	ld	s1,40(sp)
 bac:	6a42                	ld	s4,16(sp)
 bae:	6aa2                	ld	s5,8(sp)
 bb0:	6b02                	ld	s6,0(sp)
 bb2:	a03d                	j	be0 <malloc+0xdc>
 bb4:	74a2                	ld	s1,40(sp)
 bb6:	6a42                	ld	s4,16(sp)
 bb8:	6aa2                	ld	s5,8(sp)
 bba:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 bbc:	fae90fe3          	beq	s2,a4,b7a <malloc+0x76>
        p->s.size -= nunits;
 bc0:	4137073b          	subw	a4,a4,s3
 bc4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bc6:	02071693          	slli	a3,a4,0x20
 bca:	01c6d713          	srli	a4,a3,0x1c
 bce:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bd0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bd4:	00000717          	auipc	a4,0x0
 bd8:	44a73623          	sd	a0,1100(a4) # 1020 <freep>
      return (void*)(p + 1);
 bdc:	01078513          	addi	a0,a5,16
  }
}
 be0:	70e2                	ld	ra,56(sp)
 be2:	7442                	ld	s0,48(sp)
 be4:	7902                	ld	s2,32(sp)
 be6:	69e2                	ld	s3,24(sp)
 be8:	6121                	addi	sp,sp,64
 bea:	8082                	ret
 bec:	74a2                	ld	s1,40(sp)
 bee:	6a42                	ld	s4,16(sp)
 bf0:	6aa2                	ld	s5,8(sp)
 bf2:	6b02                	ld	s6,0(sp)
 bf4:	b7f5                	j	be0 <malloc+0xdc>
