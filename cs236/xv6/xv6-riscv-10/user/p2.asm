
user/_p2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <increment>:

int VAR = 0;

#define ITER 100000

void increment(int* thread_rank) {
   0:	711d                	addi	sp,sp,-96
   2:	ec86                	sd	ra,88(sp)
   4:	e8a2                	sd	s0,80(sp)
   6:	e4a6                	sd	s1,72(sp)
   8:	e0ca                	sd	s2,64(sp)
   a:	fc4e                	sd	s3,56(sp)
   c:	f852                	sd	s4,48(sp)
   e:	f456                	sd	s5,40(sp)
  10:	f05a                	sd	s6,32(sp)
  12:	ec5e                	sd	s7,24(sp)
  14:	e862                	sd	s8,16(sp)
  16:	e466                	sd	s9,8(sp)
  18:	1080                	addi	s0,sp,96
  int tid = *thread_rank;
  1a:	00052c03          	lw	s8,0(a0)
  free(thread_rank);
  1e:	1fd000ef          	jal	a1a <free>

  for (int i = 0; i < ITER; i++) {
  22:	4481                	li	s1,0
    // TODO: Uncomment this line after implement futex(_, FUTEX_LOCK, 1)
    futex(&lock, FUTEX_LOCK, 1);
  24:	4985                	li	s3,1
  26:	00001917          	auipc	s2,0x1
  2a:	fde90913          	addi	s2,s2,-34 # 1004 <lock>
    
    if (i > 0 && i % (ITER / (10)) == 0) {
  2e:	68db9bb7          	lui	s7,0x68db9
  32:	badb8b93          	addi	s7,s7,-1107 # 68db8bad <base+0x68db7b9d>
  36:	6b09                	lui	s6,0x2
  38:	710b0b1b          	addiw	s6,s6,1808 # 2710 <base+0x1700>
      printf("[T-%d] %d/%d iterations done\n", tid, i, ITER);
    }
    
    int tmp;
    tmp = VAR;
  3c:	00001a17          	auipc	s4,0x1
  40:	fc4a0a13          	addi	s4,s4,-60 # 1000 <VAR>
  for (int i = 0; i < ITER; i++) {
  44:	6ae1                	lui	s5,0x18
  46:	6a0a8a93          	addi	s5,s5,1696 # 186a0 <base+0x17690>
      printf("[T-%d] %d/%d iterations done\n", tid, i, ITER);
  4a:	00001c97          	auipc	s9,0x1
  4e:	b56c8c93          	addi	s9,s9,-1194 # ba0 <malloc+0x100>
  52:	a831                	j	6e <increment+0x6e>
    tmp = VAR;
  54:	000a2783          	lw	a5,0(s4)
    tmp = VAR;
    tmp += 2;
    VAR = tmp;

    tmp = VAR;
    tmp += 4;
  58:	2785                	addiw	a5,a5,1
    VAR = tmp;
  5a:	00fa2023          	sw	a5,0(s4)

    // TODO: Uncomment this line after implement futex(_, FUTEX_UNLOCK, 1)
    futex(&lock, FUTEX_UNLOCK, 1);
  5e:	864e                	mv	a2,s3
  60:	85ce                	mv	a1,s3
  62:	854a                	mv	a0,s2
  64:	3fc000ef          	jal	460 <futex>
  for (int i = 0; i < ITER; i++) {
  68:	2485                	addiw	s1,s1,1
  6a:	03548b63          	beq	s1,s5,a0 <increment+0xa0>
    futex(&lock, FUTEX_LOCK, 1);
  6e:	864e                	mv	a2,s3
  70:	4581                	li	a1,0
  72:	854a                	mv	a0,s2
  74:	3ec000ef          	jal	460 <futex>
    if (i > 0 && i % (ITER / (10)) == 0) {
  78:	04905e63          	blez	s1,d4 <increment+0xd4>
  7c:	037487b3          	mul	a5,s1,s7
  80:	97b1                	srai	a5,a5,0x2c
  82:	41f4d71b          	sraiw	a4,s1,0x1f
  86:	9f99                	subw	a5,a5,a4
  88:	02fb07bb          	mulw	a5,s6,a5
  8c:	40f487bb          	subw	a5,s1,a5
  90:	f3f1                	bnez	a5,54 <increment+0x54>
      printf("[T-%d] %d/%d iterations done\n", tid, i, ITER);
  92:	86d6                	mv	a3,s5
  94:	8626                	mv	a2,s1
  96:	85e2                	mv	a1,s8
  98:	8566                	mv	a0,s9
  9a:	14f000ef          	jal	9e8 <printf>
  9e:	bf5d                	j	54 <increment+0x54>
  }
  // TODO: Uncomment this line after implement futex(_, FUTEX_LOCK, 1)
    futex(&lock, FUTEX_LOCK, 1);
  a0:	4605                	li	a2,1
  a2:	4581                	li	a1,0
  a4:	00001517          	auipc	a0,0x1
  a8:	f6050513          	addi	a0,a0,-160 # 1004 <lock>
  ac:	3b4000ef          	jal	460 <futex>
  printf("[T-%d] Finished\n", tid);
  b0:	85e2                	mv	a1,s8
  b2:	00001517          	auipc	a0,0x1
  b6:	b1650513          	addi	a0,a0,-1258 # bc8 <malloc+0x128>
  ba:	12f000ef          	jal	9e8 <printf>
  // TODO: Uncomment this line after implement futex(_, FUTEX_UNLOCK, 1)
    futex(&lock, FUTEX_UNLOCK, 1);
  be:	4605                	li	a2,1
  c0:	85b2                	mv	a1,a2
  c2:	00001517          	auipc	a0,0x1
  c6:	f4250513          	addi	a0,a0,-190 # 1004 <lock>
  ca:	396000ef          	jal	460 <futex>

  exit(0);
  ce:	4501                	li	a0,0
  d0:	4de000ef          	jal	5ae <exit>
    tmp = VAR;
  d4:	00001717          	auipc	a4,0x1
  d8:	f2c70713          	addi	a4,a4,-212 # 1000 <VAR>
  dc:	431c                	lw	a5,0(a4)
    tmp += 4;
  de:	2785                	addiw	a5,a5,1
    VAR = tmp;
  e0:	c31c                	sw	a5,0(a4)
    futex(&lock, FUTEX_UNLOCK, 1);
  e2:	4605                	li	a2,1
  e4:	85b2                	mv	a1,a2
  e6:	00001517          	auipc	a0,0x1
  ea:	f1e50513          	addi	a0,a0,-226 # 1004 <lock>
  ee:	372000ef          	jal	460 <futex>
  for (int i = 0; i < ITER; i++) {
  f2:	2485                	addiw	s1,s1,1
  f4:	bfad                	j	6e <increment+0x6e>

00000000000000f6 <main>:
}

int main(int argc, char* argv[]) {
  f6:	7179                	addi	sp,sp,-48
  f8:	f406                	sd	ra,40(sp)
  fa:	f022                	sd	s0,32(sp)
  fc:	ec26                	sd	s1,24(sp)
  fe:	e84a                	sd	s2,16(sp)
 100:	e44e                	sd	s3,8(sp)
 102:	1800                	addi	s0,sp,48
  int N = 4;
  printf("Calling Process Print VAR value: %d, N: %d\n", VAR, N);
 104:	4611                	li	a2,4
 106:	00001597          	auipc	a1,0x1
 10a:	efa5a583          	lw	a1,-262(a1) # 1000 <VAR>
 10e:	00001517          	auipc	a0,0x1
 112:	ad250513          	addi	a0,a0,-1326 # be0 <malloc+0x140>
 116:	0d3000ef          	jal	9e8 <printf>

  for (int i = 0; i < N; i++) {
 11a:	4481                	li	s1,0
    int* thread_rank = malloc(sizeof(int));
 11c:	4911                	li	s2,4
    *thread_rank = i;
    create_thread(increment, thread_rank);
 11e:	00000997          	auipc	s3,0x0
 122:	ee298993          	addi	s3,s3,-286 # 0 <increment>
    int* thread_rank = malloc(sizeof(int));
 126:	854a                	mv	a0,s2
 128:	179000ef          	jal	aa0 <malloc>
 12c:	85aa                	mv	a1,a0
    *thread_rank = i;
 12e:	c104                	sw	s1,0(a0)
    create_thread(increment, thread_rank);
 130:	854e                	mv	a0,s3
 132:	2fc000ef          	jal	42e <create_thread>
  for (int i = 0; i < N; i++) {
 136:	2485                	addiw	s1,s1,1
 138:	ff2497e3          	bne	s1,s2,126 <main+0x30>
  }

  for (int i = 0; i < N; i++) {
    join();
 13c:	51a000ef          	jal	656 <join>
 140:	516000ef          	jal	656 <join>
 144:	512000ef          	jal	656 <join>
 148:	50e000ef          	jal	656 <join>
  }

  printf("All threads joined, VAR value: %d, expected: %d\n", VAR, N * ITER);
 14c:	00062637          	lui	a2,0x62
 150:	a8060613          	addi	a2,a2,-1408 # 61a80 <base+0x60a70>
 154:	00001597          	auipc	a1,0x1
 158:	eac5a583          	lw	a1,-340(a1) # 1000 <VAR>
 15c:	00001517          	auipc	a0,0x1
 160:	ab450513          	addi	a0,a0,-1356 # c10 <malloc+0x170>
 164:	085000ef          	jal	9e8 <printf>
  exit(0);
 168:	4501                	li	a0,0
 16a:	444000ef          	jal	5ae <exit>

000000000000016e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 176:	f81ff0ef          	jal	f6 <main>
  exit(r);
 17a:	434000ef          	jal	5ae <exit>

000000000000017e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e406                	sd	ra,8(sp)
 182:	e022                	sd	s0,0(sp)
 184:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 186:	87aa                	mv	a5,a0
 188:	0585                	addi	a1,a1,1
 18a:	0785                	addi	a5,a5,1
 18c:	fff5c703          	lbu	a4,-1(a1)
 190:	fee78fa3          	sb	a4,-1(a5)
 194:	fb75                	bnez	a4,188 <strcpy+0xa>
    ;
  return os;
}
 196:	60a2                	ld	ra,8(sp)
 198:	6402                	ld	s0,0(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret

000000000000019e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e406                	sd	ra,8(sp)
 1a2:	e022                	sd	s0,0(sp)
 1a4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	cb91                	beqz	a5,1be <strcmp+0x20>
 1ac:	0005c703          	lbu	a4,0(a1)
 1b0:	00f71763          	bne	a4,a5,1be <strcmp+0x20>
    p++, q++;
 1b4:	0505                	addi	a0,a0,1
 1b6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbe5                	bnez	a5,1ac <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1be:	0005c503          	lbu	a0,0(a1)
}
 1c2:	40a7853b          	subw	a0,a5,a0
 1c6:	60a2                	ld	ra,8(sp)
 1c8:	6402                	ld	s0,0(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret

00000000000001ce <strlen>:

uint
strlen(const char *s)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e406                	sd	ra,8(sp)
 1d2:	e022                	sd	s0,0(sp)
 1d4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	cf99                	beqz	a5,1f8 <strlen+0x2a>
 1dc:	0505                	addi	a0,a0,1
 1de:	87aa                	mv	a5,a0
 1e0:	86be                	mv	a3,a5
 1e2:	0785                	addi	a5,a5,1
 1e4:	fff7c703          	lbu	a4,-1(a5)
 1e8:	ff65                	bnez	a4,1e0 <strlen+0x12>
 1ea:	40a6853b          	subw	a0,a3,a0
 1ee:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1f0:	60a2                	ld	ra,8(sp)
 1f2:	6402                	ld	s0,0(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret
  for(n = 0; s[n]; n++)
 1f8:	4501                	li	a0,0
 1fa:	bfdd                	j	1f0 <strlen+0x22>

00000000000001fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e406                	sd	ra,8(sp)
 200:	e022                	sd	s0,0(sp)
 202:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 204:	ca19                	beqz	a2,21a <memset+0x1e>
 206:	87aa                	mv	a5,a0
 208:	1602                	slli	a2,a2,0x20
 20a:	9201                	srli	a2,a2,0x20
 20c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 210:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 214:	0785                	addi	a5,a5,1
 216:	fee79de3          	bne	a5,a4,210 <memset+0x14>
  }
  return dst;
}
 21a:	60a2                	ld	ra,8(sp)
 21c:	6402                	ld	s0,0(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret

0000000000000222 <strchr>:

char*
strchr(const char *s, char c)
{
 222:	1141                	addi	sp,sp,-16
 224:	e406                	sd	ra,8(sp)
 226:	e022                	sd	s0,0(sp)
 228:	0800                	addi	s0,sp,16
  for(; *s; s++)
 22a:	00054783          	lbu	a5,0(a0)
 22e:	cf81                	beqz	a5,246 <strchr+0x24>
    if(*s == c)
 230:	00f58763          	beq	a1,a5,23e <strchr+0x1c>
  for(; *s; s++)
 234:	0505                	addi	a0,a0,1
 236:	00054783          	lbu	a5,0(a0)
 23a:	fbfd                	bnez	a5,230 <strchr+0xe>
      return (char*)s;
  return 0;
 23c:	4501                	li	a0,0
}
 23e:	60a2                	ld	ra,8(sp)
 240:	6402                	ld	s0,0(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret
  return 0;
 246:	4501                	li	a0,0
 248:	bfdd                	j	23e <strchr+0x1c>

000000000000024a <gets>:

char*
gets(char *buf, int max)
{
 24a:	7159                	addi	sp,sp,-112
 24c:	f486                	sd	ra,104(sp)
 24e:	f0a2                	sd	s0,96(sp)
 250:	eca6                	sd	s1,88(sp)
 252:	e8ca                	sd	s2,80(sp)
 254:	e4ce                	sd	s3,72(sp)
 256:	e0d2                	sd	s4,64(sp)
 258:	fc56                	sd	s5,56(sp)
 25a:	f85a                	sd	s6,48(sp)
 25c:	f45e                	sd	s7,40(sp)
 25e:	f062                	sd	s8,32(sp)
 260:	ec66                	sd	s9,24(sp)
 262:	e86a                	sd	s10,16(sp)
 264:	1880                	addi	s0,sp,112
 266:	8caa                	mv	s9,a0
 268:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26a:	892a                	mv	s2,a0
 26c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 26e:	f9f40b13          	addi	s6,s0,-97
 272:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 274:	4ba9                	li	s7,10
 276:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 278:	8d26                	mv	s10,s1
 27a:	0014899b          	addiw	s3,s1,1
 27e:	84ce                	mv	s1,s3
 280:	0349d563          	bge	s3,s4,2aa <gets+0x60>
    cc = read(0, &c, 1);
 284:	8656                	mv	a2,s5
 286:	85da                	mv	a1,s6
 288:	4501                	li	a0,0
 28a:	33c000ef          	jal	5c6 <read>
    if(cc < 1)
 28e:	00a05e63          	blez	a0,2aa <gets+0x60>
    buf[i++] = c;
 292:	f9f44783          	lbu	a5,-97(s0)
 296:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 29a:	01778763          	beq	a5,s7,2a8 <gets+0x5e>
 29e:	0905                	addi	s2,s2,1
 2a0:	fd879ce3          	bne	a5,s8,278 <gets+0x2e>
    buf[i++] = c;
 2a4:	8d4e                	mv	s10,s3
 2a6:	a011                	j	2aa <gets+0x60>
 2a8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 2aa:	9d66                	add	s10,s10,s9
 2ac:	000d0023          	sb	zero,0(s10)
  return buf;
}
 2b0:	8566                	mv	a0,s9
 2b2:	70a6                	ld	ra,104(sp)
 2b4:	7406                	ld	s0,96(sp)
 2b6:	64e6                	ld	s1,88(sp)
 2b8:	6946                	ld	s2,80(sp)
 2ba:	69a6                	ld	s3,72(sp)
 2bc:	6a06                	ld	s4,64(sp)
 2be:	7ae2                	ld	s5,56(sp)
 2c0:	7b42                	ld	s6,48(sp)
 2c2:	7ba2                	ld	s7,40(sp)
 2c4:	7c02                	ld	s8,32(sp)
 2c6:	6ce2                	ld	s9,24(sp)
 2c8:	6d42                	ld	s10,16(sp)
 2ca:	6165                	addi	sp,sp,112
 2cc:	8082                	ret

00000000000002ce <stat>:

int
stat(const char *n, struct stat *st)
{
 2ce:	1101                	addi	sp,sp,-32
 2d0:	ec06                	sd	ra,24(sp)
 2d2:	e822                	sd	s0,16(sp)
 2d4:	e04a                	sd	s2,0(sp)
 2d6:	1000                	addi	s0,sp,32
 2d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2da:	4581                	li	a1,0
 2dc:	312000ef          	jal	5ee <open>
  if(fd < 0)
 2e0:	02054263          	bltz	a0,304 <stat+0x36>
 2e4:	e426                	sd	s1,8(sp)
 2e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e8:	85ca                	mv	a1,s2
 2ea:	31c000ef          	jal	606 <fstat>
 2ee:	892a                	mv	s2,a0
  close(fd);
 2f0:	8526                	mv	a0,s1
 2f2:	2e4000ef          	jal	5d6 <close>
  return r;
 2f6:	64a2                	ld	s1,8(sp)
}
 2f8:	854a                	mv	a0,s2
 2fa:	60e2                	ld	ra,24(sp)
 2fc:	6442                	ld	s0,16(sp)
 2fe:	6902                	ld	s2,0(sp)
 300:	6105                	addi	sp,sp,32
 302:	8082                	ret
    return -1;
 304:	597d                	li	s2,-1
 306:	bfcd                	j	2f8 <stat+0x2a>

0000000000000308 <atoi>:

int
atoi(const char *s)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e406                	sd	ra,8(sp)
 30c:	e022                	sd	s0,0(sp)
 30e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 310:	00054683          	lbu	a3,0(a0)
 314:	fd06879b          	addiw	a5,a3,-48
 318:	0ff7f793          	zext.b	a5,a5
 31c:	4625                	li	a2,9
 31e:	02f66963          	bltu	a2,a5,350 <atoi+0x48>
 322:	872a                	mv	a4,a0
  n = 0;
 324:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 326:	0705                	addi	a4,a4,1
 328:	0025179b          	slliw	a5,a0,0x2
 32c:	9fa9                	addw	a5,a5,a0
 32e:	0017979b          	slliw	a5,a5,0x1
 332:	9fb5                	addw	a5,a5,a3
 334:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 338:	00074683          	lbu	a3,0(a4)
 33c:	fd06879b          	addiw	a5,a3,-48
 340:	0ff7f793          	zext.b	a5,a5
 344:	fef671e3          	bgeu	a2,a5,326 <atoi+0x1e>
  return n;
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret
  n = 0;
 350:	4501                	li	a0,0
 352:	bfdd                	j	348 <atoi+0x40>

0000000000000354 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 35c:	02b57563          	bgeu	a0,a1,386 <memmove+0x32>
    while(n-- > 0)
 360:	00c05f63          	blez	a2,37e <memmove+0x2a>
 364:	1602                	slli	a2,a2,0x20
 366:	9201                	srli	a2,a2,0x20
 368:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 36c:	872a                	mv	a4,a0
      *dst++ = *src++;
 36e:	0585                	addi	a1,a1,1
 370:	0705                	addi	a4,a4,1
 372:	fff5c683          	lbu	a3,-1(a1)
 376:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 37a:	fee79ae3          	bne	a5,a4,36e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 37e:	60a2                	ld	ra,8(sp)
 380:	6402                	ld	s0,0(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret
    dst += n;
 386:	00c50733          	add	a4,a0,a2
    src += n;
 38a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 38c:	fec059e3          	blez	a2,37e <memmove+0x2a>
 390:	fff6079b          	addiw	a5,a2,-1
 394:	1782                	slli	a5,a5,0x20
 396:	9381                	srli	a5,a5,0x20
 398:	fff7c793          	not	a5,a5
 39c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 39e:	15fd                	addi	a1,a1,-1
 3a0:	177d                	addi	a4,a4,-1
 3a2:	0005c683          	lbu	a3,0(a1)
 3a6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3aa:	fef71ae3          	bne	a4,a5,39e <memmove+0x4a>
 3ae:	bfc1                	j	37e <memmove+0x2a>

00000000000003b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3b0:	1141                	addi	sp,sp,-16
 3b2:	e406                	sd	ra,8(sp)
 3b4:	e022                	sd	s0,0(sp)
 3b6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3b8:	ca0d                	beqz	a2,3ea <memcmp+0x3a>
 3ba:	fff6069b          	addiw	a3,a2,-1
 3be:	1682                	slli	a3,a3,0x20
 3c0:	9281                	srli	a3,a3,0x20
 3c2:	0685                	addi	a3,a3,1
 3c4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3c6:	00054783          	lbu	a5,0(a0)
 3ca:	0005c703          	lbu	a4,0(a1)
 3ce:	00e79863          	bne	a5,a4,3de <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 3d2:	0505                	addi	a0,a0,1
    p2++;
 3d4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3d6:	fed518e3          	bne	a0,a3,3c6 <memcmp+0x16>
  }
  return 0;
 3da:	4501                	li	a0,0
 3dc:	a019                	j	3e2 <memcmp+0x32>
      return *p1 - *p2;
 3de:	40e7853b          	subw	a0,a5,a4
}
 3e2:	60a2                	ld	ra,8(sp)
 3e4:	6402                	ld	s0,0(sp)
 3e6:	0141                	addi	sp,sp,16
 3e8:	8082                	ret
  return 0;
 3ea:	4501                	li	a0,0
 3ec:	bfdd                	j	3e2 <memcmp+0x32>

00000000000003ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ee:	1141                	addi	sp,sp,-16
 3f0:	e406                	sd	ra,8(sp)
 3f2:	e022                	sd	s0,0(sp)
 3f4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3f6:	f5fff0ef          	jal	354 <memmove>
}
 3fa:	60a2                	ld	ra,8(sp)
 3fc:	6402                	ld	s0,0(sp)
 3fe:	0141                	addi	sp,sp,16
 400:	8082                	ret

0000000000000402 <sbrk>:

char *
sbrk(int n) {
 402:	1141                	addi	sp,sp,-16
 404:	e406                	sd	ra,8(sp)
 406:	e022                	sd	s0,0(sp)
 408:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 40a:	4585                	li	a1,1
 40c:	22a000ef          	jal	636 <sys_sbrk>
}
 410:	60a2                	ld	ra,8(sp)
 412:	6402                	ld	s0,0(sp)
 414:	0141                	addi	sp,sp,16
 416:	8082                	ret

0000000000000418 <sbrklazy>:

char *
sbrklazy(int n) {
 418:	1141                	addi	sp,sp,-16
 41a:	e406                	sd	ra,8(sp)
 41c:	e022                	sd	s0,0(sp)
 41e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 420:	4589                	li	a1,2
 422:	214000ef          	jal	636 <sys_sbrk>
}
 426:	60a2                	ld	ra,8(sp)
 428:	6402                	ld	s0,0(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret

000000000000042e <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 42e:	1101                	addi	sp,sp,-32
 430:	ec06                	sd	ra,24(sp)
 432:	e822                	sd	s0,16(sp)
 434:	e426                	sd	s1,8(sp)
 436:	e04a                	sd	s2,0(sp)
 438:	1000                	addi	s0,sp,32
 43a:	84aa                	mv	s1,a0
 43c:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 43e:	6505                	lui	a0,0x1
 440:	fc3ff0ef          	jal	402 <sbrk>
 444:	6785                	lui	a5,0x1
 446:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 44a:	9a41                	andi	a2,a2,-16
 44c:	85ca                	mv	a1,s2
 44e:	8526                	mv	a0,s1
 450:	1fe000ef          	jal	64e <clone>
}
 454:	60e2                	ld	ra,24(sp)
 456:	6442                	ld	s0,16(sp)
 458:	64a2                	ld	s1,8(sp)
 45a:	6902                	ld	s2,0(sp)
 45c:	6105                	addi	sp,sp,32
 45e:	8082                	ret

0000000000000460 <futex>:

void futex(int *uaddr, int ops, int val) {
 460:	7179                	addi	sp,sp,-48
 462:	f406                	sd	ra,40(sp)
 464:	f022                	sd	s0,32(sp)
 466:	ec26                	sd	s1,24(sp)
 468:	1800                	addi	s0,sp,48
 46a:	84aa                	mv	s1,a0
  if (ops==0) {
 46c:	ed95                	bnez	a1,4a8 <futex+0x48>
    if (val==0) {
 46e:	c611                	beqz	a2,47a <futex+0x1a>
 470:	e84a                	sd	s2,16(sp)
 472:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 474:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 476:	4985                	li	s3,1
 478:	a005                	j	498 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 47a:	4705                	li	a4,1
 47c:	87ba                	mv	a5,a4
 47e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 482:	2781                	sext.w	a5,a5
 484:	ffe5                	bnez	a5,47c <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 486:	70a2                	ld	ra,40(sp)
 488:	7402                	ld	s0,32(sp)
 48a:	64e2                	ld	s1,24(sp)
 48c:	6145                	addi	sp,sp,48
 48e:	8082                	ret
        futex_wait(uaddr, 1);
 490:	85ce                	mv	a1,s3
 492:	8526                	mv	a0,s1
 494:	1ca000ef          	jal	65e <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 498:	87ca                	mv	a5,s2
 49a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 49e:	2781                	sext.w	a5,a5
 4a0:	fbe5                	bnez	a5,490 <futex+0x30>
 4a2:	6942                	ld	s2,16(sp)
 4a4:	69a2                	ld	s3,8(sp)
 4a6:	b7c5                	j	486 <futex+0x26>
    if (val==0) {
 4a8:	e611                	bnez	a2,4b4 <futex+0x54>
      __sync_lock_release(uaddr);
 4aa:	0310000f          	fence	rw,w
 4ae:	00052023          	sw	zero,0(a0) # 1000 <VAR>
 4b2:	bfd1                	j	486 <futex+0x26>
      __sync_lock_release(uaddr);
 4b4:	0310000f          	fence	rw,w
 4b8:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 4bc:	1aa000ef          	jal	666 <futex_wake>
  return;
 4c0:	b7d9                	j	486 <futex+0x26>

00000000000004c2 <sem_init>:

void sem_init(sem_t* s, int val) {
 4c2:	7179                	addi	sp,sp,-48
 4c4:	f406                	sd	ra,40(sp)
 4c6:	f022                	sd	s0,32(sp)
 4c8:	ec26                	sd	s1,24(sp)
 4ca:	e84a                	sd	s2,16(sp)
 4cc:	e44e                	sd	s3,8(sp)
 4ce:	1800                	addi	s0,sp,48
 4d0:	84aa                	mv	s1,a0
 4d2:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 4d4:	00450993          	addi	s3,a0,4
 4d8:	4605                	li	a2,1
 4da:	4581                	li	a1,0
 4dc:	854e                	mv	a0,s3
 4de:	f83ff0ef          	jal	460 <futex>
  s->value = val;
 4e2:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4e6:	4605                	li	a2,1
 4e8:	85b2                	mv	a1,a2
 4ea:	854e                	mv	a0,s3
 4ec:	f75ff0ef          	jal	460 <futex>
  return;
}
 4f0:	70a2                	ld	ra,40(sp)
 4f2:	7402                	ld	s0,32(sp)
 4f4:	64e2                	ld	s1,24(sp)
 4f6:	6942                	ld	s2,16(sp)
 4f8:	69a2                	ld	s3,8(sp)
 4fa:	6145                	addi	sp,sp,48
 4fc:	8082                	ret

00000000000004fe <sem_down>:

void sem_down(sem_t* s) {
 4fe:	7179                	addi	sp,sp,-48
 500:	f406                	sd	ra,40(sp)
 502:	f022                	sd	s0,32(sp)
 504:	ec26                	sd	s1,24(sp)
 506:	e84a                	sd	s2,16(sp)
 508:	e44e                	sd	s3,8(sp)
 50a:	1800                	addi	s0,sp,48
 50c:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 50e:	00450993          	addi	s3,a0,4
 512:	4605                	li	a2,1
 514:	4581                	li	a1,0
 516:	854e                	mv	a0,s3
 518:	f49ff0ef          	jal	460 <futex>
  while(1) {
    if (s->value>0) {
 51c:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 520:	4485                	li	s1,1
    if (s->value>0) {
 522:	02f04463          	bgtz	a5,54a <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 526:	8626                	mv	a2,s1
 528:	85a6                	mv	a1,s1
 52a:	854e                	mv	a0,s3
 52c:	f35ff0ef          	jal	460 <futex>
      futex_wait(&s->value,1);
 530:	85a6                	mv	a1,s1
 532:	854a                	mv	a0,s2
 534:	12a000ef          	jal	65e <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 538:	8626                	mv	a2,s1
 53a:	4581                	li	a1,0
 53c:	854e                	mv	a0,s3
 53e:	f23ff0ef          	jal	460 <futex>
    if (s->value>0) {
 542:	00092783          	lw	a5,0(s2)
 546:	fef050e3          	blez	a5,526 <sem_down+0x28>
      s->value--;
 54a:	37fd                	addiw	a5,a5,-1 # fff <digits+0x3af>
 54c:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 550:	4605                	li	a2,1
 552:	85b2                	mv	a1,a2
 554:	854e                	mv	a0,s3
 556:	f0bff0ef          	jal	460 <futex>
  return;
}
 55a:	70a2                	ld	ra,40(sp)
 55c:	7402                	ld	s0,32(sp)
 55e:	64e2                	ld	s1,24(sp)
 560:	6942                	ld	s2,16(sp)
 562:	69a2                	ld	s3,8(sp)
 564:	6145                	addi	sp,sp,48
 566:	8082                	ret

0000000000000568 <sem_up>:

void sem_up(sem_t* s) {
 568:	1101                	addi	sp,sp,-32
 56a:	ec06                	sd	ra,24(sp)
 56c:	e822                	sd	s0,16(sp)
 56e:	e426                	sd	s1,8(sp)
 570:	e04a                	sd	s2,0(sp)
 572:	1000                	addi	s0,sp,32
 574:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 576:	00450913          	addi	s2,a0,4
 57a:	4605                	li	a2,1
 57c:	4581                	li	a1,0
 57e:	854a                	mv	a0,s2
 580:	ee1ff0ef          	jal	460 <futex>
  s->value++;
 584:	409c                	lw	a5,0(s1)
 586:	2785                	addiw	a5,a5,1
 588:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 58a:	8526                	mv	a0,s1
 58c:	0da000ef          	jal	666 <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 590:	4605                	li	a2,1
 592:	85b2                	mv	a1,a2
 594:	854a                	mv	a0,s2
 596:	ecbff0ef          	jal	460 <futex>
  return;
 59a:	60e2                	ld	ra,24(sp)
 59c:	6442                	ld	s0,16(sp)
 59e:	64a2                	ld	s1,8(sp)
 5a0:	6902                	ld	s2,0(sp)
 5a2:	6105                	addi	sp,sp,32
 5a4:	8082                	ret

00000000000005a6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5a6:	4885                	li	a7,1
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <exit>:
.global exit
exit:
 li a7, SYS_exit
 5ae:	4889                	li	a7,2
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5b6:	488d                	li	a7,3
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5be:	4891                	li	a7,4
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <read>:
.global read
read:
 li a7, SYS_read
 5c6:	4895                	li	a7,5
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <write>:
.global write
write:
 li a7, SYS_write
 5ce:	48c1                	li	a7,16
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <close>:
.global close
close:
 li a7, SYS_close
 5d6:	48d5                	li	a7,21
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <kill>:
.global kill
kill:
 li a7, SYS_kill
 5de:	4899                	li	a7,6
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5e6:	489d                	li	a7,7
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <open>:
.global open
open:
 li a7, SYS_open
 5ee:	48bd                	li	a7,15
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5f6:	48c5                	li	a7,17
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5fe:	48c9                	li	a7,18
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 606:	48a1                	li	a7,8
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <link>:
.global link
link:
 li a7, SYS_link
 60e:	48cd                	li	a7,19
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 616:	48d1                	li	a7,20
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 61e:	48a5                	li	a7,9
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <dup>:
.global dup
dup:
 li a7, SYS_dup
 626:	48a9                	li	a7,10
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 62e:	48ad                	li	a7,11
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 636:	48b1                	li	a7,12
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <pause>:
.global pause
pause:
 li a7, SYS_pause
 63e:	48b5                	li	a7,13
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 646:	48b9                	li	a7,14
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <clone>:
.global clone
clone:
 li a7, SYS_clone
 64e:	48d9                	li	a7,22
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <join>:
.global join
join:
 li a7, SYS_join
 656:	48dd                	li	a7,23
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 65e:	48e1                	li	a7,24
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 666:	48e5                	li	a7,25
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 66e:	1101                	addi	sp,sp,-32
 670:	ec06                	sd	ra,24(sp)
 672:	e822                	sd	s0,16(sp)
 674:	1000                	addi	s0,sp,32
 676:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 67a:	4605                	li	a2,1
 67c:	fef40593          	addi	a1,s0,-17
 680:	f4fff0ef          	jal	5ce <write>
}
 684:	60e2                	ld	ra,24(sp)
 686:	6442                	ld	s0,16(sp)
 688:	6105                	addi	sp,sp,32
 68a:	8082                	ret

000000000000068c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 68c:	715d                	addi	sp,sp,-80
 68e:	e486                	sd	ra,72(sp)
 690:	e0a2                	sd	s0,64(sp)
 692:	fc26                	sd	s1,56(sp)
 694:	f84a                	sd	s2,48(sp)
 696:	f44e                	sd	s3,40(sp)
 698:	0880                	addi	s0,sp,80
 69a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 69c:	c299                	beqz	a3,6a2 <printint+0x16>
 69e:	0605cc63          	bltz	a1,716 <printint+0x8a>
  neg = 0;
 6a2:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 6a4:	fb840313          	addi	t1,s0,-72
  neg = 0;
 6a8:	869a                	mv	a3,t1
  i = 0;
 6aa:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 6ac:	00000817          	auipc	a6,0x0
 6b0:	5a480813          	addi	a6,a6,1444 # c50 <digits>
 6b4:	88be                	mv	a7,a5
 6b6:	0017851b          	addiw	a0,a5,1
 6ba:	87aa                	mv	a5,a0
 6bc:	02c5f733          	remu	a4,a1,a2
 6c0:	9742                	add	a4,a4,a6
 6c2:	00074703          	lbu	a4,0(a4)
 6c6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 6ca:	872e                	mv	a4,a1
 6cc:	02c5d5b3          	divu	a1,a1,a2
 6d0:	0685                	addi	a3,a3,1
 6d2:	fec771e3          	bgeu	a4,a2,6b4 <printint+0x28>
  if(neg)
 6d6:	000e0c63          	beqz	t3,6ee <printint+0x62>
    buf[i++] = '-';
 6da:	fd050793          	addi	a5,a0,-48
 6de:	00878533          	add	a0,a5,s0
 6e2:	02d00793          	li	a5,45
 6e6:	fef50423          	sb	a5,-24(a0)
 6ea:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 6ee:	fff7899b          	addiw	s3,a5,-1
 6f2:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 6f6:	fff4c583          	lbu	a1,-1(s1)
 6fa:	854a                	mv	a0,s2
 6fc:	f73ff0ef          	jal	66e <putc>
  while(--i >= 0)
 700:	39fd                	addiw	s3,s3,-1
 702:	14fd                	addi	s1,s1,-1
 704:	fe09d9e3          	bgez	s3,6f6 <printint+0x6a>
}
 708:	60a6                	ld	ra,72(sp)
 70a:	6406                	ld	s0,64(sp)
 70c:	74e2                	ld	s1,56(sp)
 70e:	7942                	ld	s2,48(sp)
 710:	79a2                	ld	s3,40(sp)
 712:	6161                	addi	sp,sp,80
 714:	8082                	ret
    x = -xx;
 716:	40b005b3          	neg	a1,a1
    neg = 1;
 71a:	4e05                	li	t3,1
    x = -xx;
 71c:	b761                	j	6a4 <printint+0x18>

000000000000071e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 71e:	711d                	addi	sp,sp,-96
 720:	ec86                	sd	ra,88(sp)
 722:	e8a2                	sd	s0,80(sp)
 724:	e4a6                	sd	s1,72(sp)
 726:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 728:	0005c483          	lbu	s1,0(a1)
 72c:	28048463          	beqz	s1,9b4 <vprintf+0x296>
 730:	e0ca                	sd	s2,64(sp)
 732:	fc4e                	sd	s3,56(sp)
 734:	f852                	sd	s4,48(sp)
 736:	f456                	sd	s5,40(sp)
 738:	f05a                	sd	s6,32(sp)
 73a:	ec5e                	sd	s7,24(sp)
 73c:	e862                	sd	s8,16(sp)
 73e:	e466                	sd	s9,8(sp)
 740:	8b2a                	mv	s6,a0
 742:	8a2e                	mv	s4,a1
 744:	8bb2                	mv	s7,a2
  state = 0;
 746:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 748:	4901                	li	s2,0
 74a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 74c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 750:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 754:	06c00c93          	li	s9,108
 758:	a00d                	j	77a <vprintf+0x5c>
        putc(fd, c0);
 75a:	85a6                	mv	a1,s1
 75c:	855a                	mv	a0,s6
 75e:	f11ff0ef          	jal	66e <putc>
 762:	a019                	j	768 <vprintf+0x4a>
    } else if(state == '%'){
 764:	03598363          	beq	s3,s5,78a <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 768:	0019079b          	addiw	a5,s2,1
 76c:	893e                	mv	s2,a5
 76e:	873e                	mv	a4,a5
 770:	97d2                	add	a5,a5,s4
 772:	0007c483          	lbu	s1,0(a5)
 776:	22048763          	beqz	s1,9a4 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 77a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 77e:	fe0993e3          	bnez	s3,764 <vprintf+0x46>
      if(c0 == '%'){
 782:	fd579ce3          	bne	a5,s5,75a <vprintf+0x3c>
        state = '%';
 786:	89be                	mv	s3,a5
 788:	b7c5                	j	768 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 78a:	00ea06b3          	add	a3,s4,a4
 78e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 792:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 794:	c681                	beqz	a3,79c <vprintf+0x7e>
 796:	9752                	add	a4,a4,s4
 798:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 79c:	05878263          	beq	a5,s8,7e0 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 7a0:	05978c63          	beq	a5,s9,7f8 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 7a4:	07500713          	li	a4,117
 7a8:	0ee78663          	beq	a5,a4,894 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 7ac:	07800713          	li	a4,120
 7b0:	12e78863          	beq	a5,a4,8e0 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7b4:	07000713          	li	a4,112
 7b8:	14e78d63          	beq	a5,a4,912 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 7bc:	06300713          	li	a4,99
 7c0:	18e78c63          	beq	a5,a4,958 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 7c4:	07300713          	li	a4,115
 7c8:	1ae78263          	beq	a5,a4,96c <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7cc:	02500713          	li	a4,37
 7d0:	04e79463          	bne	a5,a4,818 <vprintf+0xfa>
        putc(fd, '%');
 7d4:	85ba                	mv	a1,a4
 7d6:	855a                	mv	a0,s6
 7d8:	e97ff0ef          	jal	66e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b769                	j	768 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 7e0:	008b8493          	addi	s1,s7,8
 7e4:	4685                	li	a3,1
 7e6:	4629                	li	a2,10
 7e8:	000ba583          	lw	a1,0(s7)
 7ec:	855a                	mv	a0,s6
 7ee:	e9fff0ef          	jal	68c <printint>
 7f2:	8ba6                	mv	s7,s1
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	bf8d                	j	768 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 7f8:	06400793          	li	a5,100
 7fc:	02f68963          	beq	a3,a5,82e <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 800:	06c00793          	li	a5,108
 804:	04f68263          	beq	a3,a5,848 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 808:	07500793          	li	a5,117
 80c:	0af68063          	beq	a3,a5,8ac <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 810:	07800793          	li	a5,120
 814:	0ef68263          	beq	a3,a5,8f8 <vprintf+0x1da>
        putc(fd, '%');
 818:	02500593          	li	a1,37
 81c:	855a                	mv	a0,s6
 81e:	e51ff0ef          	jal	66e <putc>
        putc(fd, c0);
 822:	85a6                	mv	a1,s1
 824:	855a                	mv	a0,s6
 826:	e49ff0ef          	jal	66e <putc>
      state = 0;
 82a:	4981                	li	s3,0
 82c:	bf35                	j	768 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 82e:	008b8493          	addi	s1,s7,8
 832:	4685                	li	a3,1
 834:	4629                	li	a2,10
 836:	000bb583          	ld	a1,0(s7)
 83a:	855a                	mv	a0,s6
 83c:	e51ff0ef          	jal	68c <printint>
        i += 1;
 840:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 842:	8ba6                	mv	s7,s1
      state = 0;
 844:	4981                	li	s3,0
        i += 1;
 846:	b70d                	j	768 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 848:	06400793          	li	a5,100
 84c:	02f60763          	beq	a2,a5,87a <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 850:	07500793          	li	a5,117
 854:	06f60963          	beq	a2,a5,8c6 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 858:	07800793          	li	a5,120
 85c:	faf61ee3          	bne	a2,a5,818 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 860:	008b8493          	addi	s1,s7,8
 864:	4681                	li	a3,0
 866:	4641                	li	a2,16
 868:	000bb583          	ld	a1,0(s7)
 86c:	855a                	mv	a0,s6
 86e:	e1fff0ef          	jal	68c <printint>
        i += 2;
 872:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 874:	8ba6                	mv	s7,s1
      state = 0;
 876:	4981                	li	s3,0
        i += 2;
 878:	bdc5                	j	768 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 87a:	008b8493          	addi	s1,s7,8
 87e:	4685                	li	a3,1
 880:	4629                	li	a2,10
 882:	000bb583          	ld	a1,0(s7)
 886:	855a                	mv	a0,s6
 888:	e05ff0ef          	jal	68c <printint>
        i += 2;
 88c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 88e:	8ba6                	mv	s7,s1
      state = 0;
 890:	4981                	li	s3,0
        i += 2;
 892:	bdd9                	j	768 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 894:	008b8493          	addi	s1,s7,8
 898:	4681                	li	a3,0
 89a:	4629                	li	a2,10
 89c:	000be583          	lwu	a1,0(s7)
 8a0:	855a                	mv	a0,s6
 8a2:	debff0ef          	jal	68c <printint>
 8a6:	8ba6                	mv	s7,s1
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	bd7d                	j	768 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ac:	008b8493          	addi	s1,s7,8
 8b0:	4681                	li	a3,0
 8b2:	4629                	li	a2,10
 8b4:	000bb583          	ld	a1,0(s7)
 8b8:	855a                	mv	a0,s6
 8ba:	dd3ff0ef          	jal	68c <printint>
        i += 1;
 8be:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8c0:	8ba6                	mv	s7,s1
      state = 0;
 8c2:	4981                	li	s3,0
        i += 1;
 8c4:	b555                	j	768 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8c6:	008b8493          	addi	s1,s7,8
 8ca:	4681                	li	a3,0
 8cc:	4629                	li	a2,10
 8ce:	000bb583          	ld	a1,0(s7)
 8d2:	855a                	mv	a0,s6
 8d4:	db9ff0ef          	jal	68c <printint>
        i += 2;
 8d8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8da:	8ba6                	mv	s7,s1
      state = 0;
 8dc:	4981                	li	s3,0
        i += 2;
 8de:	b569                	j	768 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 8e0:	008b8493          	addi	s1,s7,8
 8e4:	4681                	li	a3,0
 8e6:	4641                	li	a2,16
 8e8:	000be583          	lwu	a1,0(s7)
 8ec:	855a                	mv	a0,s6
 8ee:	d9fff0ef          	jal	68c <printint>
 8f2:	8ba6                	mv	s7,s1
      state = 0;
 8f4:	4981                	li	s3,0
 8f6:	bd8d                	j	768 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8f8:	008b8493          	addi	s1,s7,8
 8fc:	4681                	li	a3,0
 8fe:	4641                	li	a2,16
 900:	000bb583          	ld	a1,0(s7)
 904:	855a                	mv	a0,s6
 906:	d87ff0ef          	jal	68c <printint>
        i += 1;
 90a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 90c:	8ba6                	mv	s7,s1
      state = 0;
 90e:	4981                	li	s3,0
        i += 1;
 910:	bda1                	j	768 <vprintf+0x4a>
 912:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 914:	008b8d13          	addi	s10,s7,8
 918:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 91c:	03000593          	li	a1,48
 920:	855a                	mv	a0,s6
 922:	d4dff0ef          	jal	66e <putc>
  putc(fd, 'x');
 926:	07800593          	li	a1,120
 92a:	855a                	mv	a0,s6
 92c:	d43ff0ef          	jal	66e <putc>
 930:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 932:	00000b97          	auipc	s7,0x0
 936:	31eb8b93          	addi	s7,s7,798 # c50 <digits>
 93a:	03c9d793          	srli	a5,s3,0x3c
 93e:	97de                	add	a5,a5,s7
 940:	0007c583          	lbu	a1,0(a5)
 944:	855a                	mv	a0,s6
 946:	d29ff0ef          	jal	66e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 94a:	0992                	slli	s3,s3,0x4
 94c:	34fd                	addiw	s1,s1,-1
 94e:	f4f5                	bnez	s1,93a <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 950:	8bea                	mv	s7,s10
      state = 0;
 952:	4981                	li	s3,0
 954:	6d02                	ld	s10,0(sp)
 956:	bd09                	j	768 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 958:	008b8493          	addi	s1,s7,8
 95c:	000bc583          	lbu	a1,0(s7)
 960:	855a                	mv	a0,s6
 962:	d0dff0ef          	jal	66e <putc>
 966:	8ba6                	mv	s7,s1
      state = 0;
 968:	4981                	li	s3,0
 96a:	bbfd                	j	768 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 96c:	008b8993          	addi	s3,s7,8
 970:	000bb483          	ld	s1,0(s7)
 974:	cc91                	beqz	s1,990 <vprintf+0x272>
        for(; *s; s++)
 976:	0004c583          	lbu	a1,0(s1)
 97a:	c195                	beqz	a1,99e <vprintf+0x280>
          putc(fd, *s);
 97c:	855a                	mv	a0,s6
 97e:	cf1ff0ef          	jal	66e <putc>
        for(; *s; s++)
 982:	0485                	addi	s1,s1,1
 984:	0004c583          	lbu	a1,0(s1)
 988:	f9f5                	bnez	a1,97c <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 98a:	8bce                	mv	s7,s3
      state = 0;
 98c:	4981                	li	s3,0
 98e:	bbe9                	j	768 <vprintf+0x4a>
          s = "(null)";
 990:	00000497          	auipc	s1,0x0
 994:	2b848493          	addi	s1,s1,696 # c48 <malloc+0x1a8>
        for(; *s; s++)
 998:	02800593          	li	a1,40
 99c:	b7c5                	j	97c <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 99e:	8bce                	mv	s7,s3
      state = 0;
 9a0:	4981                	li	s3,0
 9a2:	b3d9                	j	768 <vprintf+0x4a>
 9a4:	6906                	ld	s2,64(sp)
 9a6:	79e2                	ld	s3,56(sp)
 9a8:	7a42                	ld	s4,48(sp)
 9aa:	7aa2                	ld	s5,40(sp)
 9ac:	7b02                	ld	s6,32(sp)
 9ae:	6be2                	ld	s7,24(sp)
 9b0:	6c42                	ld	s8,16(sp)
 9b2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 9b4:	60e6                	ld	ra,88(sp)
 9b6:	6446                	ld	s0,80(sp)
 9b8:	64a6                	ld	s1,72(sp)
 9ba:	6125                	addi	sp,sp,96
 9bc:	8082                	ret

00000000000009be <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9be:	715d                	addi	sp,sp,-80
 9c0:	ec06                	sd	ra,24(sp)
 9c2:	e822                	sd	s0,16(sp)
 9c4:	1000                	addi	s0,sp,32
 9c6:	e010                	sd	a2,0(s0)
 9c8:	e414                	sd	a3,8(s0)
 9ca:	e818                	sd	a4,16(s0)
 9cc:	ec1c                	sd	a5,24(s0)
 9ce:	03043023          	sd	a6,32(s0)
 9d2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9d6:	8622                	mv	a2,s0
 9d8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9dc:	d43ff0ef          	jal	71e <vprintf>
}
 9e0:	60e2                	ld	ra,24(sp)
 9e2:	6442                	ld	s0,16(sp)
 9e4:	6161                	addi	sp,sp,80
 9e6:	8082                	ret

00000000000009e8 <printf>:

void
printf(const char *fmt, ...)
{
 9e8:	711d                	addi	sp,sp,-96
 9ea:	ec06                	sd	ra,24(sp)
 9ec:	e822                	sd	s0,16(sp)
 9ee:	1000                	addi	s0,sp,32
 9f0:	e40c                	sd	a1,8(s0)
 9f2:	e810                	sd	a2,16(s0)
 9f4:	ec14                	sd	a3,24(s0)
 9f6:	f018                	sd	a4,32(s0)
 9f8:	f41c                	sd	a5,40(s0)
 9fa:	03043823          	sd	a6,48(s0)
 9fe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a02:	00840613          	addi	a2,s0,8
 a06:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a0a:	85aa                	mv	a1,a0
 a0c:	4505                	li	a0,1
 a0e:	d11ff0ef          	jal	71e <vprintf>
}
 a12:	60e2                	ld	ra,24(sp)
 a14:	6442                	ld	s0,16(sp)
 a16:	6125                	addi	sp,sp,96
 a18:	8082                	ret

0000000000000a1a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a1a:	1141                	addi	sp,sp,-16
 a1c:	e406                	sd	ra,8(sp)
 a1e:	e022                	sd	s0,0(sp)
 a20:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a22:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a26:	00000797          	auipc	a5,0x0
 a2a:	5e27b783          	ld	a5,1506(a5) # 1008 <freep>
 a2e:	a02d                	j	a58 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a30:	4618                	lw	a4,8(a2)
 a32:	9f2d                	addw	a4,a4,a1
 a34:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a38:	6398                	ld	a4,0(a5)
 a3a:	6310                	ld	a2,0(a4)
 a3c:	a83d                	j	a7a <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a3e:	ff852703          	lw	a4,-8(a0)
 a42:	9f31                	addw	a4,a4,a2
 a44:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a46:	ff053683          	ld	a3,-16(a0)
 a4a:	a091                	j	a8e <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a4c:	6398                	ld	a4,0(a5)
 a4e:	00e7e463          	bltu	a5,a4,a56 <free+0x3c>
 a52:	00e6ea63          	bltu	a3,a4,a66 <free+0x4c>
{
 a56:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a58:	fed7fae3          	bgeu	a5,a3,a4c <free+0x32>
 a5c:	6398                	ld	a4,0(a5)
 a5e:	00e6e463          	bltu	a3,a4,a66 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a62:	fee7eae3          	bltu	a5,a4,a56 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 a66:	ff852583          	lw	a1,-8(a0)
 a6a:	6390                	ld	a2,0(a5)
 a6c:	02059813          	slli	a6,a1,0x20
 a70:	01c85713          	srli	a4,a6,0x1c
 a74:	9736                	add	a4,a4,a3
 a76:	fae60de3          	beq	a2,a4,a30 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a7a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a7e:	4790                	lw	a2,8(a5)
 a80:	02061593          	slli	a1,a2,0x20
 a84:	01c5d713          	srli	a4,a1,0x1c
 a88:	973e                	add	a4,a4,a5
 a8a:	fae68ae3          	beq	a3,a4,a3e <free+0x24>
    p->s.ptr = bp->s.ptr;
 a8e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a90:	00000717          	auipc	a4,0x0
 a94:	56f73c23          	sd	a5,1400(a4) # 1008 <freep>
}
 a98:	60a2                	ld	ra,8(sp)
 a9a:	6402                	ld	s0,0(sp)
 a9c:	0141                	addi	sp,sp,16
 a9e:	8082                	ret

0000000000000aa0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 aa0:	7139                	addi	sp,sp,-64
 aa2:	fc06                	sd	ra,56(sp)
 aa4:	f822                	sd	s0,48(sp)
 aa6:	f04a                	sd	s2,32(sp)
 aa8:	ec4e                	sd	s3,24(sp)
 aaa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 aac:	02051993          	slli	s3,a0,0x20
 ab0:	0209d993          	srli	s3,s3,0x20
 ab4:	09bd                	addi	s3,s3,15
 ab6:	0049d993          	srli	s3,s3,0x4
 aba:	2985                	addiw	s3,s3,1
 abc:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 abe:	00000517          	auipc	a0,0x0
 ac2:	54a53503          	ld	a0,1354(a0) # 1008 <freep>
 ac6:	c905                	beqz	a0,af6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aca:	4798                	lw	a4,8(a5)
 acc:	09377663          	bgeu	a4,s3,b58 <malloc+0xb8>
 ad0:	f426                	sd	s1,40(sp)
 ad2:	e852                	sd	s4,16(sp)
 ad4:	e456                	sd	s5,8(sp)
 ad6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 ad8:	8a4e                	mv	s4,s3
 ada:	6705                	lui	a4,0x1
 adc:	00e9f363          	bgeu	s3,a4,ae2 <malloc+0x42>
 ae0:	6a05                	lui	s4,0x1
 ae2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ae6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 aea:	00000497          	auipc	s1,0x0
 aee:	51e48493          	addi	s1,s1,1310 # 1008 <freep>
  if(p == SBRK_ERROR)
 af2:	5afd                	li	s5,-1
 af4:	a83d                	j	b32 <malloc+0x92>
 af6:	f426                	sd	s1,40(sp)
 af8:	e852                	sd	s4,16(sp)
 afa:	e456                	sd	s5,8(sp)
 afc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 afe:	00000797          	auipc	a5,0x0
 b02:	51278793          	addi	a5,a5,1298 # 1010 <base>
 b06:	00000717          	auipc	a4,0x0
 b0a:	50f73123          	sd	a5,1282(a4) # 1008 <freep>
 b0e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b10:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b14:	b7d1                	j	ad8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b16:	6398                	ld	a4,0(a5)
 b18:	e118                	sd	a4,0(a0)
 b1a:	a899                	j	b70 <malloc+0xd0>
  hp->s.size = nu;
 b1c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b20:	0541                	addi	a0,a0,16
 b22:	ef9ff0ef          	jal	a1a <free>
  return freep;
 b26:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b28:	c125                	beqz	a0,b88 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b2a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b2c:	4798                	lw	a4,8(a5)
 b2e:	03277163          	bgeu	a4,s2,b50 <malloc+0xb0>
    if(p == freep)
 b32:	6098                	ld	a4,0(s1)
 b34:	853e                	mv	a0,a5
 b36:	fef71ae3          	bne	a4,a5,b2a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b3a:	8552                	mv	a0,s4
 b3c:	8c7ff0ef          	jal	402 <sbrk>
  if(p == SBRK_ERROR)
 b40:	fd551ee3          	bne	a0,s5,b1c <malloc+0x7c>
        return 0;
 b44:	4501                	li	a0,0
 b46:	74a2                	ld	s1,40(sp)
 b48:	6a42                	ld	s4,16(sp)
 b4a:	6aa2                	ld	s5,8(sp)
 b4c:	6b02                	ld	s6,0(sp)
 b4e:	a03d                	j	b7c <malloc+0xdc>
 b50:	74a2                	ld	s1,40(sp)
 b52:	6a42                	ld	s4,16(sp)
 b54:	6aa2                	ld	s5,8(sp)
 b56:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b58:	fae90fe3          	beq	s2,a4,b16 <malloc+0x76>
        p->s.size -= nunits;
 b5c:	4137073b          	subw	a4,a4,s3
 b60:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b62:	02071693          	slli	a3,a4,0x20
 b66:	01c6d713          	srli	a4,a3,0x1c
 b6a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b6c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b70:	00000717          	auipc	a4,0x0
 b74:	48a73c23          	sd	a0,1176(a4) # 1008 <freep>
      return (void*)(p + 1);
 b78:	01078513          	addi	a0,a5,16
  }
}
 b7c:	70e2                	ld	ra,56(sp)
 b7e:	7442                	ld	s0,48(sp)
 b80:	7902                	ld	s2,32(sp)
 b82:	69e2                	ld	s3,24(sp)
 b84:	6121                	addi	sp,sp,64
 b86:	8082                	ret
 b88:	74a2                	ld	s1,40(sp)
 b8a:	6a42                	ld	s4,16(sp)
 b8c:	6aa2                	ld	s5,8(sp)
 b8e:	6b02                	ld	s6,0(sp)
 b90:	b7f5                	j	b7c <malloc+0xdc>
