
user/_p3:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <worker>:
int lock = 0;
int VAR = 0;

#define ITER 5

void worker(int* arg) {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	e85a                	sd	s6,16(sp)
  12:	e45e                	sd	s7,8(sp)
  14:	0880                	addi	s0,sp,80
  int tid = *arg;
  16:	00052b83          	lw	s7,0(a0)
  free(arg);
  1a:	15f000ef          	jal	978 <free>
  1e:	4495                	li	s1,5

  for (int i = 0; i < ITER; i++) {
    futex(&lock, FUTEX_LOCK, 1);
  20:	4a05                	li	s4,1
  22:	00001997          	auipc	s3,0x1
  26:	fe298993          	addi	s3,s3,-30 # 1004 <lock>

    printf("[T-%d] in CS\n", tid);
  2a:	00001b17          	auipc	s6,0x1
  2e:	ac6b0b13          	addi	s6,s6,-1338 # af0 <malloc+0xf2>

    pause(10);
  32:	4aa9                	li	s5,10

    VAR++;
  34:	00001917          	auipc	s2,0x1
  38:	fcc90913          	addi	s2,s2,-52 # 1000 <VAR>
    futex(&lock, FUTEX_LOCK, 1);
  3c:	8652                	mv	a2,s4
  3e:	4581                	li	a1,0
  40:	854e                	mv	a0,s3
  42:	37c000ef          	jal	3be <futex>
    printf("[T-%d] in CS\n", tid);
  46:	85de                	mv	a1,s7
  48:	855a                	mv	a0,s6
  4a:	0fd000ef          	jal	946 <printf>
    pause(10);
  4e:	8556                	mv	a0,s5
  50:	54c000ef          	jal	59c <pause>
    VAR++;
  54:	00092783          	lw	a5,0(s2)
  58:	2785                	addiw	a5,a5,1
  5a:	00f92023          	sw	a5,0(s2)

    futex(&lock, FUTEX_UNLOCK, 1);
  5e:	8652                	mv	a2,s4
  60:	85d2                	mv	a1,s4
  62:	854e                	mv	a0,s3
  64:	35a000ef          	jal	3be <futex>
  for (int i = 0; i < ITER; i++) {
  68:	34fd                	addiw	s1,s1,-1
  6a:	f8e9                	bnez	s1,3c <worker+0x3c>
  }

  exit(0);
  6c:	4501                	li	a0,0
  6e:	49e000ef          	jal	50c <exit>

0000000000000072 <main>:
}

int main() {
  72:	7179                	addi	sp,sp,-48
  74:	f406                	sd	ra,40(sp)
  76:	f022                	sd	s0,32(sp)
  78:	ec26                	sd	s1,24(sp)
  7a:	e84a                	sd	s2,16(sp)
  7c:	e44e                	sd	s3,8(sp)
  7e:	1800                	addi	s0,sp,48
  int N = 4;

  for (int i = 0; i < N; i++) {
  80:	4481                	li	s1,0
    int* arg = malloc(sizeof(int));
  82:	4911                	li	s2,4
    *arg = i;
    create_thread(worker, arg);
  84:	00000997          	auipc	s3,0x0
  88:	f7c98993          	addi	s3,s3,-132 # 0 <worker>
    int* arg = malloc(sizeof(int));
  8c:	854a                	mv	a0,s2
  8e:	171000ef          	jal	9fe <malloc>
  92:	85aa                	mv	a1,a0
    *arg = i;
  94:	c104                	sw	s1,0(a0)
    create_thread(worker, arg);
  96:	854e                	mv	a0,s3
  98:	2f4000ef          	jal	38c <create_thread>
  for (int i = 0; i < N; i++) {
  9c:	2485                	addiw	s1,s1,1
  9e:	ff2497e3          	bne	s1,s2,8c <main+0x1a>
  }

  for (int i = 0; i < N; i++) join();
  a2:	512000ef          	jal	5b4 <join>
  a6:	50e000ef          	jal	5b4 <join>
  aa:	50a000ef          	jal	5b4 <join>
  ae:	506000ef          	jal	5b4 <join>

  printf("Final VAR: %d\n", VAR);
  b2:	00001597          	auipc	a1,0x1
  b6:	f4e5a583          	lw	a1,-178(a1) # 1000 <VAR>
  ba:	00001517          	auipc	a0,0x1
  be:	a4650513          	addi	a0,a0,-1466 # b00 <malloc+0x102>
  c2:	085000ef          	jal	946 <printf>
  exit(0);
  c6:	4501                	li	a0,0
  c8:	444000ef          	jal	50c <exit>

00000000000000cc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  d4:	f9fff0ef          	jal	72 <main>
  exit(r);
  d8:	434000ef          	jal	50c <exit>

00000000000000dc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e4:	87aa                	mv	a5,a0
  e6:	0585                	addi	a1,a1,1
  e8:	0785                	addi	a5,a5,1
  ea:	fff5c703          	lbu	a4,-1(a1)
  ee:	fee78fa3          	sb	a4,-1(a5)
  f2:	fb75                	bnez	a4,e6 <strcpy+0xa>
    ;
  return os;
}
  f4:	60a2                	ld	ra,8(sp)
  f6:	6402                	ld	s0,0(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret

00000000000000fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e406                	sd	ra,8(sp)
 100:	e022                	sd	s0,0(sp)
 102:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 104:	00054783          	lbu	a5,0(a0)
 108:	cb91                	beqz	a5,11c <strcmp+0x20>
 10a:	0005c703          	lbu	a4,0(a1)
 10e:	00f71763          	bne	a4,a5,11c <strcmp+0x20>
    p++, q++;
 112:	0505                	addi	a0,a0,1
 114:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 116:	00054783          	lbu	a5,0(a0)
 11a:	fbe5                	bnez	a5,10a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 11c:	0005c503          	lbu	a0,0(a1)
}
 120:	40a7853b          	subw	a0,a5,a0
 124:	60a2                	ld	ra,8(sp)
 126:	6402                	ld	s0,0(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <strlen>:

uint
strlen(const char *s)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e406                	sd	ra,8(sp)
 130:	e022                	sd	s0,0(sp)
 132:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 134:	00054783          	lbu	a5,0(a0)
 138:	cf99                	beqz	a5,156 <strlen+0x2a>
 13a:	0505                	addi	a0,a0,1
 13c:	87aa                	mv	a5,a0
 13e:	86be                	mv	a3,a5
 140:	0785                	addi	a5,a5,1
 142:	fff7c703          	lbu	a4,-1(a5)
 146:	ff65                	bnez	a4,13e <strlen+0x12>
 148:	40a6853b          	subw	a0,a3,a0
 14c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 14e:	60a2                	ld	ra,8(sp)
 150:	6402                	ld	s0,0(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret
  for(n = 0; s[n]; n++)
 156:	4501                	li	a0,0
 158:	bfdd                	j	14e <strlen+0x22>

000000000000015a <memset>:

void*
memset(void *dst, int c, uint n)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e406                	sd	ra,8(sp)
 15e:	e022                	sd	s0,0(sp)
 160:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 162:	ca19                	beqz	a2,178 <memset+0x1e>
 164:	87aa                	mv	a5,a0
 166:	1602                	slli	a2,a2,0x20
 168:	9201                	srli	a2,a2,0x20
 16a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 16e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 172:	0785                	addi	a5,a5,1
 174:	fee79de3          	bne	a5,a4,16e <memset+0x14>
  }
  return dst;
}
 178:	60a2                	ld	ra,8(sp)
 17a:	6402                	ld	s0,0(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret

0000000000000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	1141                	addi	sp,sp,-16
 182:	e406                	sd	ra,8(sp)
 184:	e022                	sd	s0,0(sp)
 186:	0800                	addi	s0,sp,16
  for(; *s; s++)
 188:	00054783          	lbu	a5,0(a0)
 18c:	cf81                	beqz	a5,1a4 <strchr+0x24>
    if(*s == c)
 18e:	00f58763          	beq	a1,a5,19c <strchr+0x1c>
  for(; *s; s++)
 192:	0505                	addi	a0,a0,1
 194:	00054783          	lbu	a5,0(a0)
 198:	fbfd                	bnez	a5,18e <strchr+0xe>
      return (char*)s;
  return 0;
 19a:	4501                	li	a0,0
}
 19c:	60a2                	ld	ra,8(sp)
 19e:	6402                	ld	s0,0(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret
  return 0;
 1a4:	4501                	li	a0,0
 1a6:	bfdd                	j	19c <strchr+0x1c>

00000000000001a8 <gets>:

char*
gets(char *buf, int max)
{
 1a8:	7159                	addi	sp,sp,-112
 1aa:	f486                	sd	ra,104(sp)
 1ac:	f0a2                	sd	s0,96(sp)
 1ae:	eca6                	sd	s1,88(sp)
 1b0:	e8ca                	sd	s2,80(sp)
 1b2:	e4ce                	sd	s3,72(sp)
 1b4:	e0d2                	sd	s4,64(sp)
 1b6:	fc56                	sd	s5,56(sp)
 1b8:	f85a                	sd	s6,48(sp)
 1ba:	f45e                	sd	s7,40(sp)
 1bc:	f062                	sd	s8,32(sp)
 1be:	ec66                	sd	s9,24(sp)
 1c0:	e86a                	sd	s10,16(sp)
 1c2:	1880                	addi	s0,sp,112
 1c4:	8caa                	mv	s9,a0
 1c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c8:	892a                	mv	s2,a0
 1ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1cc:	f9f40b13          	addi	s6,s0,-97
 1d0:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d2:	4ba9                	li	s7,10
 1d4:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1d6:	8d26                	mv	s10,s1
 1d8:	0014899b          	addiw	s3,s1,1
 1dc:	84ce                	mv	s1,s3
 1de:	0349d563          	bge	s3,s4,208 <gets+0x60>
    cc = read(0, &c, 1);
 1e2:	8656                	mv	a2,s5
 1e4:	85da                	mv	a1,s6
 1e6:	4501                	li	a0,0
 1e8:	33c000ef          	jal	524 <read>
    if(cc < 1)
 1ec:	00a05e63          	blez	a0,208 <gets+0x60>
    buf[i++] = c;
 1f0:	f9f44783          	lbu	a5,-97(s0)
 1f4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f8:	01778763          	beq	a5,s7,206 <gets+0x5e>
 1fc:	0905                	addi	s2,s2,1
 1fe:	fd879ce3          	bne	a5,s8,1d6 <gets+0x2e>
    buf[i++] = c;
 202:	8d4e                	mv	s10,s3
 204:	a011                	j	208 <gets+0x60>
 206:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 208:	9d66                	add	s10,s10,s9
 20a:	000d0023          	sb	zero,0(s10)
  return buf;
}
 20e:	8566                	mv	a0,s9
 210:	70a6                	ld	ra,104(sp)
 212:	7406                	ld	s0,96(sp)
 214:	64e6                	ld	s1,88(sp)
 216:	6946                	ld	s2,80(sp)
 218:	69a6                	ld	s3,72(sp)
 21a:	6a06                	ld	s4,64(sp)
 21c:	7ae2                	ld	s5,56(sp)
 21e:	7b42                	ld	s6,48(sp)
 220:	7ba2                	ld	s7,40(sp)
 222:	7c02                	ld	s8,32(sp)
 224:	6ce2                	ld	s9,24(sp)
 226:	6d42                	ld	s10,16(sp)
 228:	6165                	addi	sp,sp,112
 22a:	8082                	ret

000000000000022c <stat>:

int
stat(const char *n, struct stat *st)
{
 22c:	1101                	addi	sp,sp,-32
 22e:	ec06                	sd	ra,24(sp)
 230:	e822                	sd	s0,16(sp)
 232:	e04a                	sd	s2,0(sp)
 234:	1000                	addi	s0,sp,32
 236:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 238:	4581                	li	a1,0
 23a:	312000ef          	jal	54c <open>
  if(fd < 0)
 23e:	02054263          	bltz	a0,262 <stat+0x36>
 242:	e426                	sd	s1,8(sp)
 244:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 246:	85ca                	mv	a1,s2
 248:	31c000ef          	jal	564 <fstat>
 24c:	892a                	mv	s2,a0
  close(fd);
 24e:	8526                	mv	a0,s1
 250:	2e4000ef          	jal	534 <close>
  return r;
 254:	64a2                	ld	s1,8(sp)
}
 256:	854a                	mv	a0,s2
 258:	60e2                	ld	ra,24(sp)
 25a:	6442                	ld	s0,16(sp)
 25c:	6902                	ld	s2,0(sp)
 25e:	6105                	addi	sp,sp,32
 260:	8082                	ret
    return -1;
 262:	597d                	li	s2,-1
 264:	bfcd                	j	256 <stat+0x2a>

0000000000000266 <atoi>:

int
atoi(const char *s)
{
 266:	1141                	addi	sp,sp,-16
 268:	e406                	sd	ra,8(sp)
 26a:	e022                	sd	s0,0(sp)
 26c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26e:	00054683          	lbu	a3,0(a0)
 272:	fd06879b          	addiw	a5,a3,-48
 276:	0ff7f793          	zext.b	a5,a5
 27a:	4625                	li	a2,9
 27c:	02f66963          	bltu	a2,a5,2ae <atoi+0x48>
 280:	872a                	mv	a4,a0
  n = 0;
 282:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 284:	0705                	addi	a4,a4,1
 286:	0025179b          	slliw	a5,a0,0x2
 28a:	9fa9                	addw	a5,a5,a0
 28c:	0017979b          	slliw	a5,a5,0x1
 290:	9fb5                	addw	a5,a5,a3
 292:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 296:	00074683          	lbu	a3,0(a4)
 29a:	fd06879b          	addiw	a5,a3,-48
 29e:	0ff7f793          	zext.b	a5,a5
 2a2:	fef671e3          	bgeu	a2,a5,284 <atoi+0x1e>
  return n;
}
 2a6:	60a2                	ld	ra,8(sp)
 2a8:	6402                	ld	s0,0(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
  n = 0;
 2ae:	4501                	li	a0,0
 2b0:	bfdd                	j	2a6 <atoi+0x40>

00000000000002b2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e406                	sd	ra,8(sp)
 2b6:	e022                	sd	s0,0(sp)
 2b8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ba:	02b57563          	bgeu	a0,a1,2e4 <memmove+0x32>
    while(n-- > 0)
 2be:	00c05f63          	blez	a2,2dc <memmove+0x2a>
 2c2:	1602                	slli	a2,a2,0x20
 2c4:	9201                	srli	a2,a2,0x20
 2c6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 2cc:	0585                	addi	a1,a1,1
 2ce:	0705                	addi	a4,a4,1
 2d0:	fff5c683          	lbu	a3,-1(a1)
 2d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d8:	fee79ae3          	bne	a5,a4,2cc <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
    dst += n;
 2e4:	00c50733          	add	a4,a0,a2
    src += n;
 2e8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ea:	fec059e3          	blez	a2,2dc <memmove+0x2a>
 2ee:	fff6079b          	addiw	a5,a2,-1
 2f2:	1782                	slli	a5,a5,0x20
 2f4:	9381                	srli	a5,a5,0x20
 2f6:	fff7c793          	not	a5,a5
 2fa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2fc:	15fd                	addi	a1,a1,-1
 2fe:	177d                	addi	a4,a4,-1
 300:	0005c683          	lbu	a3,0(a1)
 304:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 308:	fef71ae3          	bne	a4,a5,2fc <memmove+0x4a>
 30c:	bfc1                	j	2dc <memmove+0x2a>

000000000000030e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e406                	sd	ra,8(sp)
 312:	e022                	sd	s0,0(sp)
 314:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 316:	ca0d                	beqz	a2,348 <memcmp+0x3a>
 318:	fff6069b          	addiw	a3,a2,-1
 31c:	1682                	slli	a3,a3,0x20
 31e:	9281                	srli	a3,a3,0x20
 320:	0685                	addi	a3,a3,1
 322:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 324:	00054783          	lbu	a5,0(a0)
 328:	0005c703          	lbu	a4,0(a1)
 32c:	00e79863          	bne	a5,a4,33c <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 330:	0505                	addi	a0,a0,1
    p2++;
 332:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 334:	fed518e3          	bne	a0,a3,324 <memcmp+0x16>
  }
  return 0;
 338:	4501                	li	a0,0
 33a:	a019                	j	340 <memcmp+0x32>
      return *p1 - *p2;
 33c:	40e7853b          	subw	a0,a5,a4
}
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret
  return 0;
 348:	4501                	li	a0,0
 34a:	bfdd                	j	340 <memcmp+0x32>

000000000000034c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e406                	sd	ra,8(sp)
 350:	e022                	sd	s0,0(sp)
 352:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 354:	f5fff0ef          	jal	2b2 <memmove>
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <sbrk>:

char *
sbrk(int n) {
 360:	1141                	addi	sp,sp,-16
 362:	e406                	sd	ra,8(sp)
 364:	e022                	sd	s0,0(sp)
 366:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 368:	4585                	li	a1,1
 36a:	22a000ef          	jal	594 <sys_sbrk>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <sbrklazy>:

char *
sbrklazy(int n) {
 376:	1141                	addi	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 37e:	4589                	li	a1,2
 380:	214000ef          	jal	594 <sys_sbrk>
}
 384:	60a2                	ld	ra,8(sp)
 386:	6402                	ld	s0,0(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret

000000000000038c <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 38c:	1101                	addi	sp,sp,-32
 38e:	ec06                	sd	ra,24(sp)
 390:	e822                	sd	s0,16(sp)
 392:	e426                	sd	s1,8(sp)
 394:	e04a                	sd	s2,0(sp)
 396:	1000                	addi	s0,sp,32
 398:	84aa                	mv	s1,a0
 39a:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 39c:	6505                	lui	a0,0x1
 39e:	fc3ff0ef          	jal	360 <sbrk>
 3a2:	6785                	lui	a5,0x1
 3a4:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 3a8:	9a41                	andi	a2,a2,-16
 3aa:	85ca                	mv	a1,s2
 3ac:	8526                	mv	a0,s1
 3ae:	1fe000ef          	jal	5ac <clone>
}
 3b2:	60e2                	ld	ra,24(sp)
 3b4:	6442                	ld	s0,16(sp)
 3b6:	64a2                	ld	s1,8(sp)
 3b8:	6902                	ld	s2,0(sp)
 3ba:	6105                	addi	sp,sp,32
 3bc:	8082                	ret

00000000000003be <futex>:

void futex(int *uaddr, int ops, int val) {
 3be:	7179                	addi	sp,sp,-48
 3c0:	f406                	sd	ra,40(sp)
 3c2:	f022                	sd	s0,32(sp)
 3c4:	ec26                	sd	s1,24(sp)
 3c6:	1800                	addi	s0,sp,48
 3c8:	84aa                	mv	s1,a0
  if (ops==0) {
 3ca:	ed95                	bnez	a1,406 <futex+0x48>
    if (val==0) {
 3cc:	c611                	beqz	a2,3d8 <futex+0x1a>
 3ce:	e84a                	sd	s2,16(sp)
 3d0:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 3d2:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 3d4:	4985                	li	s3,1
 3d6:	a005                	j	3f6 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 3d8:	4705                	li	a4,1
 3da:	87ba                	mv	a5,a4
 3dc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 3e0:	2781                	sext.w	a5,a5
 3e2:	ffe5                	bnez	a5,3da <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 3e4:	70a2                	ld	ra,40(sp)
 3e6:	7402                	ld	s0,32(sp)
 3e8:	64e2                	ld	s1,24(sp)
 3ea:	6145                	addi	sp,sp,48
 3ec:	8082                	ret
        futex_wait(uaddr, 1);
 3ee:	85ce                	mv	a1,s3
 3f0:	8526                	mv	a0,s1
 3f2:	1ca000ef          	jal	5bc <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 3f6:	87ca                	mv	a5,s2
 3f8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 3fc:	2781                	sext.w	a5,a5
 3fe:	fbe5                	bnez	a5,3ee <futex+0x30>
 400:	6942                	ld	s2,16(sp)
 402:	69a2                	ld	s3,8(sp)
 404:	b7c5                	j	3e4 <futex+0x26>
    if (val==0) {
 406:	e611                	bnez	a2,412 <futex+0x54>
      __sync_lock_release(uaddr);
 408:	0310000f          	fence	rw,w
 40c:	00052023          	sw	zero,0(a0) # 1000 <VAR>
 410:	bfd1                	j	3e4 <futex+0x26>
      __sync_lock_release(uaddr);
 412:	0310000f          	fence	rw,w
 416:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 41a:	1aa000ef          	jal	5c4 <futex_wake>
  return;
 41e:	b7d9                	j	3e4 <futex+0x26>

0000000000000420 <sem_init>:

void sem_init(sem_t* s, int val) {
 420:	7179                	addi	sp,sp,-48
 422:	f406                	sd	ra,40(sp)
 424:	f022                	sd	s0,32(sp)
 426:	ec26                	sd	s1,24(sp)
 428:	e84a                	sd	s2,16(sp)
 42a:	e44e                	sd	s3,8(sp)
 42c:	1800                	addi	s0,sp,48
 42e:	84aa                	mv	s1,a0
 430:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 432:	00450993          	addi	s3,a0,4
 436:	4605                	li	a2,1
 438:	4581                	li	a1,0
 43a:	854e                	mv	a0,s3
 43c:	f83ff0ef          	jal	3be <futex>
  s->value = val;
 440:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 444:	4605                	li	a2,1
 446:	85b2                	mv	a1,a2
 448:	854e                	mv	a0,s3
 44a:	f75ff0ef          	jal	3be <futex>
  return;
}
 44e:	70a2                	ld	ra,40(sp)
 450:	7402                	ld	s0,32(sp)
 452:	64e2                	ld	s1,24(sp)
 454:	6942                	ld	s2,16(sp)
 456:	69a2                	ld	s3,8(sp)
 458:	6145                	addi	sp,sp,48
 45a:	8082                	ret

000000000000045c <sem_down>:

void sem_down(sem_t* s) {
 45c:	7179                	addi	sp,sp,-48
 45e:	f406                	sd	ra,40(sp)
 460:	f022                	sd	s0,32(sp)
 462:	ec26                	sd	s1,24(sp)
 464:	e84a                	sd	s2,16(sp)
 466:	e44e                	sd	s3,8(sp)
 468:	1800                	addi	s0,sp,48
 46a:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 46c:	00450993          	addi	s3,a0,4
 470:	4605                	li	a2,1
 472:	4581                	li	a1,0
 474:	854e                	mv	a0,s3
 476:	f49ff0ef          	jal	3be <futex>
  while(1) {
    if (s->value>0) {
 47a:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 47e:	4485                	li	s1,1
    if (s->value>0) {
 480:	02f04463          	bgtz	a5,4a8 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 484:	8626                	mv	a2,s1
 486:	85a6                	mv	a1,s1
 488:	854e                	mv	a0,s3
 48a:	f35ff0ef          	jal	3be <futex>
      futex_wait(&s->value,1);
 48e:	85a6                	mv	a1,s1
 490:	854a                	mv	a0,s2
 492:	12a000ef          	jal	5bc <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 496:	8626                	mv	a2,s1
 498:	4581                	li	a1,0
 49a:	854e                	mv	a0,s3
 49c:	f23ff0ef          	jal	3be <futex>
    if (s->value>0) {
 4a0:	00092783          	lw	a5,0(s2)
 4a4:	fef050e3          	blez	a5,484 <sem_down+0x28>
      s->value--;
 4a8:	37fd                	addiw	a5,a5,-1 # fff <digits+0x4e7>
 4aa:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4ae:	4605                	li	a2,1
 4b0:	85b2                	mv	a1,a2
 4b2:	854e                	mv	a0,s3
 4b4:	f0bff0ef          	jal	3be <futex>
  return;
}
 4b8:	70a2                	ld	ra,40(sp)
 4ba:	7402                	ld	s0,32(sp)
 4bc:	64e2                	ld	s1,24(sp)
 4be:	6942                	ld	s2,16(sp)
 4c0:	69a2                	ld	s3,8(sp)
 4c2:	6145                	addi	sp,sp,48
 4c4:	8082                	ret

00000000000004c6 <sem_up>:

void sem_up(sem_t* s) {
 4c6:	1101                	addi	sp,sp,-32
 4c8:	ec06                	sd	ra,24(sp)
 4ca:	e822                	sd	s0,16(sp)
 4cc:	e426                	sd	s1,8(sp)
 4ce:	e04a                	sd	s2,0(sp)
 4d0:	1000                	addi	s0,sp,32
 4d2:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 4d4:	00450913          	addi	s2,a0,4
 4d8:	4605                	li	a2,1
 4da:	4581                	li	a1,0
 4dc:	854a                	mv	a0,s2
 4de:	ee1ff0ef          	jal	3be <futex>
  s->value++;
 4e2:	409c                	lw	a5,0(s1)
 4e4:	2785                	addiw	a5,a5,1
 4e6:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 4e8:	8526                	mv	a0,s1
 4ea:	0da000ef          	jal	5c4 <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4ee:	4605                	li	a2,1
 4f0:	85b2                	mv	a1,a2
 4f2:	854a                	mv	a0,s2
 4f4:	ecbff0ef          	jal	3be <futex>
  return;
 4f8:	60e2                	ld	ra,24(sp)
 4fa:	6442                	ld	s0,16(sp)
 4fc:	64a2                	ld	s1,8(sp)
 4fe:	6902                	ld	s2,0(sp)
 500:	6105                	addi	sp,sp,32
 502:	8082                	ret

0000000000000504 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 504:	4885                	li	a7,1
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <exit>:
.global exit
exit:
 li a7, SYS_exit
 50c:	4889                	li	a7,2
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <wait>:
.global wait
wait:
 li a7, SYS_wait
 514:	488d                	li	a7,3
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 51c:	4891                	li	a7,4
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <read>:
.global read
read:
 li a7, SYS_read
 524:	4895                	li	a7,5
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <write>:
.global write
write:
 li a7, SYS_write
 52c:	48c1                	li	a7,16
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <close>:
.global close
close:
 li a7, SYS_close
 534:	48d5                	li	a7,21
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <kill>:
.global kill
kill:
 li a7, SYS_kill
 53c:	4899                	li	a7,6
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <exec>:
.global exec
exec:
 li a7, SYS_exec
 544:	489d                	li	a7,7
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <open>:
.global open
open:
 li a7, SYS_open
 54c:	48bd                	li	a7,15
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 554:	48c5                	li	a7,17
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 55c:	48c9                	li	a7,18
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 564:	48a1                	li	a7,8
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <link>:
.global link
link:
 li a7, SYS_link
 56c:	48cd                	li	a7,19
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 574:	48d1                	li	a7,20
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 57c:	48a5                	li	a7,9
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <dup>:
.global dup
dup:
 li a7, SYS_dup
 584:	48a9                	li	a7,10
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 58c:	48ad                	li	a7,11
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 594:	48b1                	li	a7,12
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <pause>:
.global pause
pause:
 li a7, SYS_pause
 59c:	48b5                	li	a7,13
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a4:	48b9                	li	a7,14
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <clone>:
.global clone
clone:
 li a7, SYS_clone
 5ac:	48d9                	li	a7,22
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <join>:
.global join
join:
 li a7, SYS_join
 5b4:	48dd                	li	a7,23
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 5bc:	48e1                	li	a7,24
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 5c4:	48e5                	li	a7,25
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5cc:	1101                	addi	sp,sp,-32
 5ce:	ec06                	sd	ra,24(sp)
 5d0:	e822                	sd	s0,16(sp)
 5d2:	1000                	addi	s0,sp,32
 5d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5d8:	4605                	li	a2,1
 5da:	fef40593          	addi	a1,s0,-17
 5de:	f4fff0ef          	jal	52c <write>
}
 5e2:	60e2                	ld	ra,24(sp)
 5e4:	6442                	ld	s0,16(sp)
 5e6:	6105                	addi	sp,sp,32
 5e8:	8082                	ret

00000000000005ea <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5ea:	715d                	addi	sp,sp,-80
 5ec:	e486                	sd	ra,72(sp)
 5ee:	e0a2                	sd	s0,64(sp)
 5f0:	fc26                	sd	s1,56(sp)
 5f2:	f84a                	sd	s2,48(sp)
 5f4:	f44e                	sd	s3,40(sp)
 5f6:	0880                	addi	s0,sp,80
 5f8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5fa:	c299                	beqz	a3,600 <printint+0x16>
 5fc:	0605cc63          	bltz	a1,674 <printint+0x8a>
  neg = 0;
 600:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 602:	fb840313          	addi	t1,s0,-72
  neg = 0;
 606:	869a                	mv	a3,t1
  i = 0;
 608:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 60a:	00000817          	auipc	a6,0x0
 60e:	50e80813          	addi	a6,a6,1294 # b18 <digits>
 612:	88be                	mv	a7,a5
 614:	0017851b          	addiw	a0,a5,1
 618:	87aa                	mv	a5,a0
 61a:	02c5f733          	remu	a4,a1,a2
 61e:	9742                	add	a4,a4,a6
 620:	00074703          	lbu	a4,0(a4)
 624:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 628:	872e                	mv	a4,a1
 62a:	02c5d5b3          	divu	a1,a1,a2
 62e:	0685                	addi	a3,a3,1
 630:	fec771e3          	bgeu	a4,a2,612 <printint+0x28>
  if(neg)
 634:	000e0c63          	beqz	t3,64c <printint+0x62>
    buf[i++] = '-';
 638:	fd050793          	addi	a5,a0,-48
 63c:	00878533          	add	a0,a5,s0
 640:	02d00793          	li	a5,45
 644:	fef50423          	sb	a5,-24(a0)
 648:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 64c:	fff7899b          	addiw	s3,a5,-1
 650:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 654:	fff4c583          	lbu	a1,-1(s1)
 658:	854a                	mv	a0,s2
 65a:	f73ff0ef          	jal	5cc <putc>
  while(--i >= 0)
 65e:	39fd                	addiw	s3,s3,-1
 660:	14fd                	addi	s1,s1,-1
 662:	fe09d9e3          	bgez	s3,654 <printint+0x6a>
}
 666:	60a6                	ld	ra,72(sp)
 668:	6406                	ld	s0,64(sp)
 66a:	74e2                	ld	s1,56(sp)
 66c:	7942                	ld	s2,48(sp)
 66e:	79a2                	ld	s3,40(sp)
 670:	6161                	addi	sp,sp,80
 672:	8082                	ret
    x = -xx;
 674:	40b005b3          	neg	a1,a1
    neg = 1;
 678:	4e05                	li	t3,1
    x = -xx;
 67a:	b761                	j	602 <printint+0x18>

000000000000067c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67c:	711d                	addi	sp,sp,-96
 67e:	ec86                	sd	ra,88(sp)
 680:	e8a2                	sd	s0,80(sp)
 682:	e4a6                	sd	s1,72(sp)
 684:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 686:	0005c483          	lbu	s1,0(a1)
 68a:	28048463          	beqz	s1,912 <vprintf+0x296>
 68e:	e0ca                	sd	s2,64(sp)
 690:	fc4e                	sd	s3,56(sp)
 692:	f852                	sd	s4,48(sp)
 694:	f456                	sd	s5,40(sp)
 696:	f05a                	sd	s6,32(sp)
 698:	ec5e                	sd	s7,24(sp)
 69a:	e862                	sd	s8,16(sp)
 69c:	e466                	sd	s9,8(sp)
 69e:	8b2a                	mv	s6,a0
 6a0:	8a2e                	mv	s4,a1
 6a2:	8bb2                	mv	s7,a2
  state = 0;
 6a4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6a6:	4901                	li	s2,0
 6a8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6aa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6ae:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6b2:	06c00c93          	li	s9,108
 6b6:	a00d                	j	6d8 <vprintf+0x5c>
        putc(fd, c0);
 6b8:	85a6                	mv	a1,s1
 6ba:	855a                	mv	a0,s6
 6bc:	f11ff0ef          	jal	5cc <putc>
 6c0:	a019                	j	6c6 <vprintf+0x4a>
    } else if(state == '%'){
 6c2:	03598363          	beq	s3,s5,6e8 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6c6:	0019079b          	addiw	a5,s2,1
 6ca:	893e                	mv	s2,a5
 6cc:	873e                	mv	a4,a5
 6ce:	97d2                	add	a5,a5,s4
 6d0:	0007c483          	lbu	s1,0(a5)
 6d4:	22048763          	beqz	s1,902 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 6d8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6dc:	fe0993e3          	bnez	s3,6c2 <vprintf+0x46>
      if(c0 == '%'){
 6e0:	fd579ce3          	bne	a5,s5,6b8 <vprintf+0x3c>
        state = '%';
 6e4:	89be                	mv	s3,a5
 6e6:	b7c5                	j	6c6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6e8:	00ea06b3          	add	a3,s4,a4
 6ec:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6f0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6f2:	c681                	beqz	a3,6fa <vprintf+0x7e>
 6f4:	9752                	add	a4,a4,s4
 6f6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6fa:	05878263          	beq	a5,s8,73e <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6fe:	05978c63          	beq	a5,s9,756 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 702:	07500713          	li	a4,117
 706:	0ee78663          	beq	a5,a4,7f2 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 70a:	07800713          	li	a4,120
 70e:	12e78863          	beq	a5,a4,83e <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 712:	07000713          	li	a4,112
 716:	14e78d63          	beq	a5,a4,870 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 71a:	06300713          	li	a4,99
 71e:	18e78c63          	beq	a5,a4,8b6 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 722:	07300713          	li	a4,115
 726:	1ae78263          	beq	a5,a4,8ca <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 72a:	02500713          	li	a4,37
 72e:	04e79463          	bne	a5,a4,776 <vprintf+0xfa>
        putc(fd, '%');
 732:	85ba                	mv	a1,a4
 734:	855a                	mv	a0,s6
 736:	e97ff0ef          	jal	5cc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 73a:	4981                	li	s3,0
 73c:	b769                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 73e:	008b8493          	addi	s1,s7,8
 742:	4685                	li	a3,1
 744:	4629                	li	a2,10
 746:	000ba583          	lw	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	e9fff0ef          	jal	5ea <printint>
 750:	8ba6                	mv	s7,s1
      state = 0;
 752:	4981                	li	s3,0
 754:	bf8d                	j	6c6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 756:	06400793          	li	a5,100
 75a:	02f68963          	beq	a3,a5,78c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 75e:	06c00793          	li	a5,108
 762:	04f68263          	beq	a3,a5,7a6 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 766:	07500793          	li	a5,117
 76a:	0af68063          	beq	a3,a5,80a <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 76e:	07800793          	li	a5,120
 772:	0ef68263          	beq	a3,a5,856 <vprintf+0x1da>
        putc(fd, '%');
 776:	02500593          	li	a1,37
 77a:	855a                	mv	a0,s6
 77c:	e51ff0ef          	jal	5cc <putc>
        putc(fd, c0);
 780:	85a6                	mv	a1,s1
 782:	855a                	mv	a0,s6
 784:	e49ff0ef          	jal	5cc <putc>
      state = 0;
 788:	4981                	li	s3,0
 78a:	bf35                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 78c:	008b8493          	addi	s1,s7,8
 790:	4685                	li	a3,1
 792:	4629                	li	a2,10
 794:	000bb583          	ld	a1,0(s7)
 798:	855a                	mv	a0,s6
 79a:	e51ff0ef          	jal	5ea <printint>
        i += 1;
 79e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a0:	8ba6                	mv	s7,s1
      state = 0;
 7a2:	4981                	li	s3,0
        i += 1;
 7a4:	b70d                	j	6c6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7a6:	06400793          	li	a5,100
 7aa:	02f60763          	beq	a2,a5,7d8 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7ae:	07500793          	li	a5,117
 7b2:	06f60963          	beq	a2,a5,824 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7b6:	07800793          	li	a5,120
 7ba:	faf61ee3          	bne	a2,a5,776 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7be:	008b8493          	addi	s1,s7,8
 7c2:	4681                	li	a3,0
 7c4:	4641                	li	a2,16
 7c6:	000bb583          	ld	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	e1fff0ef          	jal	5ea <printint>
        i += 2;
 7d0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d2:	8ba6                	mv	s7,s1
      state = 0;
 7d4:	4981                	li	s3,0
        i += 2;
 7d6:	bdc5                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d8:	008b8493          	addi	s1,s7,8
 7dc:	4685                	li	a3,1
 7de:	4629                	li	a2,10
 7e0:	000bb583          	ld	a1,0(s7)
 7e4:	855a                	mv	a0,s6
 7e6:	e05ff0ef          	jal	5ea <printint>
        i += 2;
 7ea:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ec:	8ba6                	mv	s7,s1
      state = 0;
 7ee:	4981                	li	s3,0
        i += 2;
 7f0:	bdd9                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7f2:	008b8493          	addi	s1,s7,8
 7f6:	4681                	li	a3,0
 7f8:	4629                	li	a2,10
 7fa:	000be583          	lwu	a1,0(s7)
 7fe:	855a                	mv	a0,s6
 800:	debff0ef          	jal	5ea <printint>
 804:	8ba6                	mv	s7,s1
      state = 0;
 806:	4981                	li	s3,0
 808:	bd7d                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 80a:	008b8493          	addi	s1,s7,8
 80e:	4681                	li	a3,0
 810:	4629                	li	a2,10
 812:	000bb583          	ld	a1,0(s7)
 816:	855a                	mv	a0,s6
 818:	dd3ff0ef          	jal	5ea <printint>
        i += 1;
 81c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 81e:	8ba6                	mv	s7,s1
      state = 0;
 820:	4981                	li	s3,0
        i += 1;
 822:	b555                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 824:	008b8493          	addi	s1,s7,8
 828:	4681                	li	a3,0
 82a:	4629                	li	a2,10
 82c:	000bb583          	ld	a1,0(s7)
 830:	855a                	mv	a0,s6
 832:	db9ff0ef          	jal	5ea <printint>
        i += 2;
 836:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 838:	8ba6                	mv	s7,s1
      state = 0;
 83a:	4981                	li	s3,0
        i += 2;
 83c:	b569                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 83e:	008b8493          	addi	s1,s7,8
 842:	4681                	li	a3,0
 844:	4641                	li	a2,16
 846:	000be583          	lwu	a1,0(s7)
 84a:	855a                	mv	a0,s6
 84c:	d9fff0ef          	jal	5ea <printint>
 850:	8ba6                	mv	s7,s1
      state = 0;
 852:	4981                	li	s3,0
 854:	bd8d                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 856:	008b8493          	addi	s1,s7,8
 85a:	4681                	li	a3,0
 85c:	4641                	li	a2,16
 85e:	000bb583          	ld	a1,0(s7)
 862:	855a                	mv	a0,s6
 864:	d87ff0ef          	jal	5ea <printint>
        i += 1;
 868:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 86a:	8ba6                	mv	s7,s1
      state = 0;
 86c:	4981                	li	s3,0
        i += 1;
 86e:	bda1                	j	6c6 <vprintf+0x4a>
 870:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 872:	008b8d13          	addi	s10,s7,8
 876:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 87a:	03000593          	li	a1,48
 87e:	855a                	mv	a0,s6
 880:	d4dff0ef          	jal	5cc <putc>
  putc(fd, 'x');
 884:	07800593          	li	a1,120
 888:	855a                	mv	a0,s6
 88a:	d43ff0ef          	jal	5cc <putc>
 88e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 890:	00000b97          	auipc	s7,0x0
 894:	288b8b93          	addi	s7,s7,648 # b18 <digits>
 898:	03c9d793          	srli	a5,s3,0x3c
 89c:	97de                	add	a5,a5,s7
 89e:	0007c583          	lbu	a1,0(a5)
 8a2:	855a                	mv	a0,s6
 8a4:	d29ff0ef          	jal	5cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8a8:	0992                	slli	s3,s3,0x4
 8aa:	34fd                	addiw	s1,s1,-1
 8ac:	f4f5                	bnez	s1,898 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 8ae:	8bea                	mv	s7,s10
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	6d02                	ld	s10,0(sp)
 8b4:	bd09                	j	6c6 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 8b6:	008b8493          	addi	s1,s7,8
 8ba:	000bc583          	lbu	a1,0(s7)
 8be:	855a                	mv	a0,s6
 8c0:	d0dff0ef          	jal	5cc <putc>
 8c4:	8ba6                	mv	s7,s1
      state = 0;
 8c6:	4981                	li	s3,0
 8c8:	bbfd                	j	6c6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8ca:	008b8993          	addi	s3,s7,8
 8ce:	000bb483          	ld	s1,0(s7)
 8d2:	cc91                	beqz	s1,8ee <vprintf+0x272>
        for(; *s; s++)
 8d4:	0004c583          	lbu	a1,0(s1)
 8d8:	c195                	beqz	a1,8fc <vprintf+0x280>
          putc(fd, *s);
 8da:	855a                	mv	a0,s6
 8dc:	cf1ff0ef          	jal	5cc <putc>
        for(; *s; s++)
 8e0:	0485                	addi	s1,s1,1
 8e2:	0004c583          	lbu	a1,0(s1)
 8e6:	f9f5                	bnez	a1,8da <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 8e8:	8bce                	mv	s7,s3
      state = 0;
 8ea:	4981                	li	s3,0
 8ec:	bbe9                	j	6c6 <vprintf+0x4a>
          s = "(null)";
 8ee:	00000497          	auipc	s1,0x0
 8f2:	22248493          	addi	s1,s1,546 # b10 <malloc+0x112>
        for(; *s; s++)
 8f6:	02800593          	li	a1,40
 8fa:	b7c5                	j	8da <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 8fc:	8bce                	mv	s7,s3
      state = 0;
 8fe:	4981                	li	s3,0
 900:	b3d9                	j	6c6 <vprintf+0x4a>
 902:	6906                	ld	s2,64(sp)
 904:	79e2                	ld	s3,56(sp)
 906:	7a42                	ld	s4,48(sp)
 908:	7aa2                	ld	s5,40(sp)
 90a:	7b02                	ld	s6,32(sp)
 90c:	6be2                	ld	s7,24(sp)
 90e:	6c42                	ld	s8,16(sp)
 910:	6ca2                	ld	s9,8(sp)
    }
  }
}
 912:	60e6                	ld	ra,88(sp)
 914:	6446                	ld	s0,80(sp)
 916:	64a6                	ld	s1,72(sp)
 918:	6125                	addi	sp,sp,96
 91a:	8082                	ret

000000000000091c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 91c:	715d                	addi	sp,sp,-80
 91e:	ec06                	sd	ra,24(sp)
 920:	e822                	sd	s0,16(sp)
 922:	1000                	addi	s0,sp,32
 924:	e010                	sd	a2,0(s0)
 926:	e414                	sd	a3,8(s0)
 928:	e818                	sd	a4,16(s0)
 92a:	ec1c                	sd	a5,24(s0)
 92c:	03043023          	sd	a6,32(s0)
 930:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 934:	8622                	mv	a2,s0
 936:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 93a:	d43ff0ef          	jal	67c <vprintf>
}
 93e:	60e2                	ld	ra,24(sp)
 940:	6442                	ld	s0,16(sp)
 942:	6161                	addi	sp,sp,80
 944:	8082                	ret

0000000000000946 <printf>:

void
printf(const char *fmt, ...)
{
 946:	711d                	addi	sp,sp,-96
 948:	ec06                	sd	ra,24(sp)
 94a:	e822                	sd	s0,16(sp)
 94c:	1000                	addi	s0,sp,32
 94e:	e40c                	sd	a1,8(s0)
 950:	e810                	sd	a2,16(s0)
 952:	ec14                	sd	a3,24(s0)
 954:	f018                	sd	a4,32(s0)
 956:	f41c                	sd	a5,40(s0)
 958:	03043823          	sd	a6,48(s0)
 95c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 960:	00840613          	addi	a2,s0,8
 964:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 968:	85aa                	mv	a1,a0
 96a:	4505                	li	a0,1
 96c:	d11ff0ef          	jal	67c <vprintf>
}
 970:	60e2                	ld	ra,24(sp)
 972:	6442                	ld	s0,16(sp)
 974:	6125                	addi	sp,sp,96
 976:	8082                	ret

0000000000000978 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 978:	1141                	addi	sp,sp,-16
 97a:	e406                	sd	ra,8(sp)
 97c:	e022                	sd	s0,0(sp)
 97e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 980:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 984:	00000797          	auipc	a5,0x0
 988:	6847b783          	ld	a5,1668(a5) # 1008 <freep>
 98c:	a02d                	j	9b6 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 98e:	4618                	lw	a4,8(a2)
 990:	9f2d                	addw	a4,a4,a1
 992:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 996:	6398                	ld	a4,0(a5)
 998:	6310                	ld	a2,0(a4)
 99a:	a83d                	j	9d8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 99c:	ff852703          	lw	a4,-8(a0)
 9a0:	9f31                	addw	a4,a4,a2
 9a2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9a4:	ff053683          	ld	a3,-16(a0)
 9a8:	a091                	j	9ec <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9aa:	6398                	ld	a4,0(a5)
 9ac:	00e7e463          	bltu	a5,a4,9b4 <free+0x3c>
 9b0:	00e6ea63          	bltu	a3,a4,9c4 <free+0x4c>
{
 9b4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b6:	fed7fae3          	bgeu	a5,a3,9aa <free+0x32>
 9ba:	6398                	ld	a4,0(a5)
 9bc:	00e6e463          	bltu	a3,a4,9c4 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c0:	fee7eae3          	bltu	a5,a4,9b4 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9c4:	ff852583          	lw	a1,-8(a0)
 9c8:	6390                	ld	a2,0(a5)
 9ca:	02059813          	slli	a6,a1,0x20
 9ce:	01c85713          	srli	a4,a6,0x1c
 9d2:	9736                	add	a4,a4,a3
 9d4:	fae60de3          	beq	a2,a4,98e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9d8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9dc:	4790                	lw	a2,8(a5)
 9de:	02061593          	slli	a1,a2,0x20
 9e2:	01c5d713          	srli	a4,a1,0x1c
 9e6:	973e                	add	a4,a4,a5
 9e8:	fae68ae3          	beq	a3,a4,99c <free+0x24>
    p->s.ptr = bp->s.ptr;
 9ec:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9ee:	00000717          	auipc	a4,0x0
 9f2:	60f73d23          	sd	a5,1562(a4) # 1008 <freep>
}
 9f6:	60a2                	ld	ra,8(sp)
 9f8:	6402                	ld	s0,0(sp)
 9fa:	0141                	addi	sp,sp,16
 9fc:	8082                	ret

00000000000009fe <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9fe:	7139                	addi	sp,sp,-64
 a00:	fc06                	sd	ra,56(sp)
 a02:	f822                	sd	s0,48(sp)
 a04:	f04a                	sd	s2,32(sp)
 a06:	ec4e                	sd	s3,24(sp)
 a08:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a0a:	02051993          	slli	s3,a0,0x20
 a0e:	0209d993          	srli	s3,s3,0x20
 a12:	09bd                	addi	s3,s3,15
 a14:	0049d993          	srli	s3,s3,0x4
 a18:	2985                	addiw	s3,s3,1
 a1a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a1c:	00000517          	auipc	a0,0x0
 a20:	5ec53503          	ld	a0,1516(a0) # 1008 <freep>
 a24:	c905                	beqz	a0,a54 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a26:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a28:	4798                	lw	a4,8(a5)
 a2a:	09377663          	bgeu	a4,s3,ab6 <malloc+0xb8>
 a2e:	f426                	sd	s1,40(sp)
 a30:	e852                	sd	s4,16(sp)
 a32:	e456                	sd	s5,8(sp)
 a34:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a36:	8a4e                	mv	s4,s3
 a38:	6705                	lui	a4,0x1
 a3a:	00e9f363          	bgeu	s3,a4,a40 <malloc+0x42>
 a3e:	6a05                	lui	s4,0x1
 a40:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a44:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a48:	00000497          	auipc	s1,0x0
 a4c:	5c048493          	addi	s1,s1,1472 # 1008 <freep>
  if(p == SBRK_ERROR)
 a50:	5afd                	li	s5,-1
 a52:	a83d                	j	a90 <malloc+0x92>
 a54:	f426                	sd	s1,40(sp)
 a56:	e852                	sd	s4,16(sp)
 a58:	e456                	sd	s5,8(sp)
 a5a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a5c:	00000797          	auipc	a5,0x0
 a60:	5b478793          	addi	a5,a5,1460 # 1010 <base>
 a64:	00000717          	auipc	a4,0x0
 a68:	5af73223          	sd	a5,1444(a4) # 1008 <freep>
 a6c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a6e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a72:	b7d1                	j	a36 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a74:	6398                	ld	a4,0(a5)
 a76:	e118                	sd	a4,0(a0)
 a78:	a899                	j	ace <malloc+0xd0>
  hp->s.size = nu;
 a7a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a7e:	0541                	addi	a0,a0,16
 a80:	ef9ff0ef          	jal	978 <free>
  return freep;
 a84:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a86:	c125                	beqz	a0,ae6 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a88:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a8a:	4798                	lw	a4,8(a5)
 a8c:	03277163          	bgeu	a4,s2,aae <malloc+0xb0>
    if(p == freep)
 a90:	6098                	ld	a4,0(s1)
 a92:	853e                	mv	a0,a5
 a94:	fef71ae3          	bne	a4,a5,a88 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a98:	8552                	mv	a0,s4
 a9a:	8c7ff0ef          	jal	360 <sbrk>
  if(p == SBRK_ERROR)
 a9e:	fd551ee3          	bne	a0,s5,a7a <malloc+0x7c>
        return 0;
 aa2:	4501                	li	a0,0
 aa4:	74a2                	ld	s1,40(sp)
 aa6:	6a42                	ld	s4,16(sp)
 aa8:	6aa2                	ld	s5,8(sp)
 aaa:	6b02                	ld	s6,0(sp)
 aac:	a03d                	j	ada <malloc+0xdc>
 aae:	74a2                	ld	s1,40(sp)
 ab0:	6a42                	ld	s4,16(sp)
 ab2:	6aa2                	ld	s5,8(sp)
 ab4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ab6:	fae90fe3          	beq	s2,a4,a74 <malloc+0x76>
        p->s.size -= nunits;
 aba:	4137073b          	subw	a4,a4,s3
 abe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ac0:	02071693          	slli	a3,a4,0x20
 ac4:	01c6d713          	srli	a4,a3,0x1c
 ac8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ace:	00000717          	auipc	a4,0x0
 ad2:	52a73d23          	sd	a0,1338(a4) # 1008 <freep>
      return (void*)(p + 1);
 ad6:	01078513          	addi	a0,a5,16
  }
}
 ada:	70e2                	ld	ra,56(sp)
 adc:	7442                	ld	s0,48(sp)
 ade:	7902                	ld	s2,32(sp)
 ae0:	69e2                	ld	s3,24(sp)
 ae2:	6121                	addi	sp,sp,64
 ae4:	8082                	ret
 ae6:	74a2                	ld	s1,40(sp)
 ae8:	6a42                	ld	s4,16(sp)
 aea:	6aa2                	ld	s5,8(sp)
 aec:	6b02                	ld	s6,0(sp)
 aee:	b7f5                	j	ada <malloc+0xdc>
