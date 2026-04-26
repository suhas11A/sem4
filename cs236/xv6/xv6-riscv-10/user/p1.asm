
user/_p1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <increment>:

int VAR = 0;

#define ITER 1000000

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
  1e:	201000ef          	jal	a1e <free>

  for (int i = 0; i < ITER; i++) {
  22:	4481                	li	s1,0
    // TODO: Uncomment this line after implement futex(_, FUTEX_LOCK, 0)
    futex(&lock, FUTEX_LOCK, 0);
  24:	00001917          	auipc	s2,0x1
  28:	fe090913          	addi	s2,s2,-32 # 1004 <lock>

    if (i > 0 && i % (ITER / (4)) == 0) {
  2c:	431beb37          	lui	s6,0x431be
  30:	e83b0b13          	addi	s6,s6,-381 # 431bde83 <base+0x431bce73>
  34:	0003dab7          	lui	s5,0x3d
  38:	090a8a9b          	addiw	s5,s5,144 # 3d090 <base+0x3c080>
      printf("[T-%d] %d/%d iterations done\n", tid, i, ITER);
    }

    int tmp;
    tmp = VAR;
  3c:	00001997          	auipc	s3,0x1
  40:	fc498993          	addi	s3,s3,-60 # 1000 <VAR>
    tmp = VAR;
    tmp += 4;
    VAR = tmp;

    // TODO: Uncomment this line after implement futex(_, FUTEX_UNLOCK, 0)
    futex(&lock, FUTEX_UNLOCK, 0);
  44:	4b85                	li	s7,1
  for (int i = 0; i < ITER; i++) {
  46:	000f4a37          	lui	s4,0xf4
  4a:	240a0a13          	addi	s4,s4,576 # f4240 <base+0xf3230>
      printf("[T-%d] %d/%d iterations done\n", tid, i, ITER);
  4e:	00001c97          	auipc	s9,0x1
  52:	b52c8c93          	addi	s9,s9,-1198 # ba0 <malloc+0xfc>
  56:	a831                	j	72 <increment+0x72>
    tmp = VAR;
  58:	0009a783          	lw	a5,0(s3)
    tmp += 4;
  5c:	2785                	addiw	a5,a5,1
    VAR = tmp;
  5e:	00f9a023          	sw	a5,0(s3)
    futex(&lock, FUTEX_UNLOCK, 0);
  62:	4601                	li	a2,0
  64:	85de                	mv	a1,s7
  66:	854a                	mv	a0,s2
  68:	3fc000ef          	jal	464 <futex>
  for (int i = 0; i < ITER; i++) {
  6c:	2485                	addiw	s1,s1,1
  6e:	03448b63          	beq	s1,s4,a4 <increment+0xa4>
    futex(&lock, FUTEX_LOCK, 0);
  72:	4601                	li	a2,0
  74:	4581                	li	a1,0
  76:	854a                	mv	a0,s2
  78:	3ec000ef          	jal	464 <futex>
    if (i > 0 && i % (ITER / (4)) == 0) {
  7c:	04905e63          	blez	s1,d8 <increment+0xd8>
  80:	036487b3          	mul	a5,s1,s6
  84:	97c1                	srai	a5,a5,0x30
  86:	41f4d71b          	sraiw	a4,s1,0x1f
  8a:	9f99                	subw	a5,a5,a4
  8c:	02fa87bb          	mulw	a5,s5,a5
  90:	40f487bb          	subw	a5,s1,a5
  94:	f3f1                	bnez	a5,58 <increment+0x58>
      printf("[T-%d] %d/%d iterations done\n", tid, i, ITER);
  96:	86d2                	mv	a3,s4
  98:	8626                	mv	a2,s1
  9a:	85e2                	mv	a1,s8
  9c:	8566                	mv	a0,s9
  9e:	14f000ef          	jal	9ec <printf>
  a2:	bf5d                	j	58 <increment+0x58>
  }
  // TODO: Uncomment this line after implement futex(_, FUTEX_LOCK, 0)
  futex(&lock, FUTEX_LOCK, 0);
  a4:	4601                	li	a2,0
  a6:	4581                	li	a1,0
  a8:	00001517          	auipc	a0,0x1
  ac:	f5c50513          	addi	a0,a0,-164 # 1004 <lock>
  b0:	3b4000ef          	jal	464 <futex>
  printf("[T-%d] Finished\n", tid);
  b4:	85e2                	mv	a1,s8
  b6:	00001517          	auipc	a0,0x1
  ba:	b1250513          	addi	a0,a0,-1262 # bc8 <malloc+0x124>
  be:	12f000ef          	jal	9ec <printf>
  // TODO: Uncomment this line after implement futex(_, FUTEX_UNLOCK, 0)
  futex(&lock, FUTEX_UNLOCK, 0);
  c2:	4601                	li	a2,0
  c4:	4585                	li	a1,1
  c6:	00001517          	auipc	a0,0x1
  ca:	f3e50513          	addi	a0,a0,-194 # 1004 <lock>
  ce:	396000ef          	jal	464 <futex>

  exit(0);
  d2:	4501                	li	a0,0
  d4:	4de000ef          	jal	5b2 <exit>
    tmp = VAR;
  d8:	00001717          	auipc	a4,0x1
  dc:	f2870713          	addi	a4,a4,-216 # 1000 <VAR>
  e0:	431c                	lw	a5,0(a4)
    tmp += 4;
  e2:	2785                	addiw	a5,a5,1
    VAR = tmp;
  e4:	c31c                	sw	a5,0(a4)
    futex(&lock, FUTEX_UNLOCK, 0);
  e6:	4601                	li	a2,0
  e8:	4585                	li	a1,1
  ea:	00001517          	auipc	a0,0x1
  ee:	f1a50513          	addi	a0,a0,-230 # 1004 <lock>
  f2:	372000ef          	jal	464 <futex>
  for (int i = 0; i < ITER; i++) {
  f6:	2485                	addiw	s1,s1,1
  f8:	bfad                	j	72 <increment+0x72>

00000000000000fa <main>:
}

int main(int argc, char* argv[]) {
  fa:	7179                	addi	sp,sp,-48
  fc:	f406                	sd	ra,40(sp)
  fe:	f022                	sd	s0,32(sp)
 100:	ec26                	sd	s1,24(sp)
 102:	e84a                	sd	s2,16(sp)
 104:	e44e                	sd	s3,8(sp)
 106:	1800                	addi	s0,sp,48
  int N = 4;
  printf("Calling Process Print VAR value: %d, N: %d\n", VAR, N);
 108:	4611                	li	a2,4
 10a:	00001597          	auipc	a1,0x1
 10e:	ef65a583          	lw	a1,-266(a1) # 1000 <VAR>
 112:	00001517          	auipc	a0,0x1
 116:	ace50513          	addi	a0,a0,-1330 # be0 <malloc+0x13c>
 11a:	0d3000ef          	jal	9ec <printf>

  for (int i = 0; i < N; i++) {
 11e:	4481                	li	s1,0
    int* thread_rank = malloc(sizeof(int));
 120:	4911                	li	s2,4
    *thread_rank = i;
    create_thread(increment, thread_rank);
 122:	00000997          	auipc	s3,0x0
 126:	ede98993          	addi	s3,s3,-290 # 0 <increment>
    int* thread_rank = malloc(sizeof(int));
 12a:	854a                	mv	a0,s2
 12c:	179000ef          	jal	aa4 <malloc>
 130:	85aa                	mv	a1,a0
    *thread_rank = i;
 132:	c104                	sw	s1,0(a0)
    create_thread(increment, thread_rank);
 134:	854e                	mv	a0,s3
 136:	2fc000ef          	jal	432 <create_thread>
  for (int i = 0; i < N; i++) {
 13a:	2485                	addiw	s1,s1,1
 13c:	ff2497e3          	bne	s1,s2,12a <main+0x30>
  }

  for (int i = 0; i < N; i++) {
    join();
 140:	51a000ef          	jal	65a <join>
 144:	516000ef          	jal	65a <join>
 148:	512000ef          	jal	65a <join>
 14c:	50e000ef          	jal	65a <join>
  }

  printf("All threads joined, VAR value: %d, expected: %d\n", VAR, N * ITER);
 150:	003d1637          	lui	a2,0x3d1
 154:	90060613          	addi	a2,a2,-1792 # 3d0900 <base+0x3cf8f0>
 158:	00001597          	auipc	a1,0x1
 15c:	ea85a583          	lw	a1,-344(a1) # 1000 <VAR>
 160:	00001517          	auipc	a0,0x1
 164:	ab050513          	addi	a0,a0,-1360 # c10 <malloc+0x16c>
 168:	085000ef          	jal	9ec <printf>
  exit(0);
 16c:	4501                	li	a0,0
 16e:	444000ef          	jal	5b2 <exit>

0000000000000172 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 172:	1141                	addi	sp,sp,-16
 174:	e406                	sd	ra,8(sp)
 176:	e022                	sd	s0,0(sp)
 178:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 17a:	f81ff0ef          	jal	fa <main>
  exit(r);
 17e:	434000ef          	jal	5b2 <exit>

0000000000000182 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 182:	1141                	addi	sp,sp,-16
 184:	e406                	sd	ra,8(sp)
 186:	e022                	sd	s0,0(sp)
 188:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 18a:	87aa                	mv	a5,a0
 18c:	0585                	addi	a1,a1,1
 18e:	0785                	addi	a5,a5,1
 190:	fff5c703          	lbu	a4,-1(a1)
 194:	fee78fa3          	sb	a4,-1(a5)
 198:	fb75                	bnez	a4,18c <strcpy+0xa>
    ;
  return os;
}
 19a:	60a2                	ld	ra,8(sp)
 19c:	6402                	ld	s0,0(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret

00000000000001a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e406                	sd	ra,8(sp)
 1a6:	e022                	sd	s0,0(sp)
 1a8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cb91                	beqz	a5,1c2 <strcmp+0x20>
 1b0:	0005c703          	lbu	a4,0(a1)
 1b4:	00f71763          	bne	a4,a5,1c2 <strcmp+0x20>
    p++, q++;
 1b8:	0505                	addi	a0,a0,1
 1ba:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	fbe5                	bnez	a5,1b0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1c2:	0005c503          	lbu	a0,0(a1)
}
 1c6:	40a7853b          	subw	a0,a5,a0
 1ca:	60a2                	ld	ra,8(sp)
 1cc:	6402                	ld	s0,0(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret

00000000000001d2 <strlen>:

uint
strlen(const char *s)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e406                	sd	ra,8(sp)
 1d6:	e022                	sd	s0,0(sp)
 1d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1da:	00054783          	lbu	a5,0(a0)
 1de:	cf99                	beqz	a5,1fc <strlen+0x2a>
 1e0:	0505                	addi	a0,a0,1
 1e2:	87aa                	mv	a5,a0
 1e4:	86be                	mv	a3,a5
 1e6:	0785                	addi	a5,a5,1
 1e8:	fff7c703          	lbu	a4,-1(a5)
 1ec:	ff65                	bnez	a4,1e4 <strlen+0x12>
 1ee:	40a6853b          	subw	a0,a3,a0
 1f2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1f4:	60a2                	ld	ra,8(sp)
 1f6:	6402                	ld	s0,0(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret
  for(n = 0; s[n]; n++)
 1fc:	4501                	li	a0,0
 1fe:	bfdd                	j	1f4 <strlen+0x22>

0000000000000200 <memset>:

void*
memset(void *dst, int c, uint n)
{
 200:	1141                	addi	sp,sp,-16
 202:	e406                	sd	ra,8(sp)
 204:	e022                	sd	s0,0(sp)
 206:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 208:	ca19                	beqz	a2,21e <memset+0x1e>
 20a:	87aa                	mv	a5,a0
 20c:	1602                	slli	a2,a2,0x20
 20e:	9201                	srli	a2,a2,0x20
 210:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 214:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 218:	0785                	addi	a5,a5,1
 21a:	fee79de3          	bne	a5,a4,214 <memset+0x14>
  }
  return dst;
}
 21e:	60a2                	ld	ra,8(sp)
 220:	6402                	ld	s0,0(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret

0000000000000226 <strchr>:

char*
strchr(const char *s, char c)
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 22e:	00054783          	lbu	a5,0(a0)
 232:	cf81                	beqz	a5,24a <strchr+0x24>
    if(*s == c)
 234:	00f58763          	beq	a1,a5,242 <strchr+0x1c>
  for(; *s; s++)
 238:	0505                	addi	a0,a0,1
 23a:	00054783          	lbu	a5,0(a0)
 23e:	fbfd                	bnez	a5,234 <strchr+0xe>
      return (char*)s;
  return 0;
 240:	4501                	li	a0,0
}
 242:	60a2                	ld	ra,8(sp)
 244:	6402                	ld	s0,0(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  return 0;
 24a:	4501                	li	a0,0
 24c:	bfdd                	j	242 <strchr+0x1c>

000000000000024e <gets>:

char*
gets(char *buf, int max)
{
 24e:	7159                	addi	sp,sp,-112
 250:	f486                	sd	ra,104(sp)
 252:	f0a2                	sd	s0,96(sp)
 254:	eca6                	sd	s1,88(sp)
 256:	e8ca                	sd	s2,80(sp)
 258:	e4ce                	sd	s3,72(sp)
 25a:	e0d2                	sd	s4,64(sp)
 25c:	fc56                	sd	s5,56(sp)
 25e:	f85a                	sd	s6,48(sp)
 260:	f45e                	sd	s7,40(sp)
 262:	f062                	sd	s8,32(sp)
 264:	ec66                	sd	s9,24(sp)
 266:	e86a                	sd	s10,16(sp)
 268:	1880                	addi	s0,sp,112
 26a:	8caa                	mv	s9,a0
 26c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26e:	892a                	mv	s2,a0
 270:	4481                	li	s1,0
    cc = read(0, &c, 1);
 272:	f9f40b13          	addi	s6,s0,-97
 276:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 278:	4ba9                	li	s7,10
 27a:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 27c:	8d26                	mv	s10,s1
 27e:	0014899b          	addiw	s3,s1,1
 282:	84ce                	mv	s1,s3
 284:	0349d563          	bge	s3,s4,2ae <gets+0x60>
    cc = read(0, &c, 1);
 288:	8656                	mv	a2,s5
 28a:	85da                	mv	a1,s6
 28c:	4501                	li	a0,0
 28e:	33c000ef          	jal	5ca <read>
    if(cc < 1)
 292:	00a05e63          	blez	a0,2ae <gets+0x60>
    buf[i++] = c;
 296:	f9f44783          	lbu	a5,-97(s0)
 29a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 29e:	01778763          	beq	a5,s7,2ac <gets+0x5e>
 2a2:	0905                	addi	s2,s2,1
 2a4:	fd879ce3          	bne	a5,s8,27c <gets+0x2e>
    buf[i++] = c;
 2a8:	8d4e                	mv	s10,s3
 2aa:	a011                	j	2ae <gets+0x60>
 2ac:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 2ae:	9d66                	add	s10,s10,s9
 2b0:	000d0023          	sb	zero,0(s10)
  return buf;
}
 2b4:	8566                	mv	a0,s9
 2b6:	70a6                	ld	ra,104(sp)
 2b8:	7406                	ld	s0,96(sp)
 2ba:	64e6                	ld	s1,88(sp)
 2bc:	6946                	ld	s2,80(sp)
 2be:	69a6                	ld	s3,72(sp)
 2c0:	6a06                	ld	s4,64(sp)
 2c2:	7ae2                	ld	s5,56(sp)
 2c4:	7b42                	ld	s6,48(sp)
 2c6:	7ba2                	ld	s7,40(sp)
 2c8:	7c02                	ld	s8,32(sp)
 2ca:	6ce2                	ld	s9,24(sp)
 2cc:	6d42                	ld	s10,16(sp)
 2ce:	6165                	addi	sp,sp,112
 2d0:	8082                	ret

00000000000002d2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d2:	1101                	addi	sp,sp,-32
 2d4:	ec06                	sd	ra,24(sp)
 2d6:	e822                	sd	s0,16(sp)
 2d8:	e04a                	sd	s2,0(sp)
 2da:	1000                	addi	s0,sp,32
 2dc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2de:	4581                	li	a1,0
 2e0:	312000ef          	jal	5f2 <open>
  if(fd < 0)
 2e4:	02054263          	bltz	a0,308 <stat+0x36>
 2e8:	e426                	sd	s1,8(sp)
 2ea:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ec:	85ca                	mv	a1,s2
 2ee:	31c000ef          	jal	60a <fstat>
 2f2:	892a                	mv	s2,a0
  close(fd);
 2f4:	8526                	mv	a0,s1
 2f6:	2e4000ef          	jal	5da <close>
  return r;
 2fa:	64a2                	ld	s1,8(sp)
}
 2fc:	854a                	mv	a0,s2
 2fe:	60e2                	ld	ra,24(sp)
 300:	6442                	ld	s0,16(sp)
 302:	6902                	ld	s2,0(sp)
 304:	6105                	addi	sp,sp,32
 306:	8082                	ret
    return -1;
 308:	597d                	li	s2,-1
 30a:	bfcd                	j	2fc <stat+0x2a>

000000000000030c <atoi>:

int
atoi(const char *s)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e406                	sd	ra,8(sp)
 310:	e022                	sd	s0,0(sp)
 312:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 314:	00054683          	lbu	a3,0(a0)
 318:	fd06879b          	addiw	a5,a3,-48
 31c:	0ff7f793          	zext.b	a5,a5
 320:	4625                	li	a2,9
 322:	02f66963          	bltu	a2,a5,354 <atoi+0x48>
 326:	872a                	mv	a4,a0
  n = 0;
 328:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 32a:	0705                	addi	a4,a4,1
 32c:	0025179b          	slliw	a5,a0,0x2
 330:	9fa9                	addw	a5,a5,a0
 332:	0017979b          	slliw	a5,a5,0x1
 336:	9fb5                	addw	a5,a5,a3
 338:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 33c:	00074683          	lbu	a3,0(a4)
 340:	fd06879b          	addiw	a5,a3,-48
 344:	0ff7f793          	zext.b	a5,a5
 348:	fef671e3          	bgeu	a2,a5,32a <atoi+0x1e>
  return n;
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret
  n = 0;
 354:	4501                	li	a0,0
 356:	bfdd                	j	34c <atoi+0x40>

0000000000000358 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 358:	1141                	addi	sp,sp,-16
 35a:	e406                	sd	ra,8(sp)
 35c:	e022                	sd	s0,0(sp)
 35e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 360:	02b57563          	bgeu	a0,a1,38a <memmove+0x32>
    while(n-- > 0)
 364:	00c05f63          	blez	a2,382 <memmove+0x2a>
 368:	1602                	slli	a2,a2,0x20
 36a:	9201                	srli	a2,a2,0x20
 36c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 370:	872a                	mv	a4,a0
      *dst++ = *src++;
 372:	0585                	addi	a1,a1,1
 374:	0705                	addi	a4,a4,1
 376:	fff5c683          	lbu	a3,-1(a1)
 37a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 37e:	fee79ae3          	bne	a5,a4,372 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 382:	60a2                	ld	ra,8(sp)
 384:	6402                	ld	s0,0(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret
    dst += n;
 38a:	00c50733          	add	a4,a0,a2
    src += n;
 38e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 390:	fec059e3          	blez	a2,382 <memmove+0x2a>
 394:	fff6079b          	addiw	a5,a2,-1
 398:	1782                	slli	a5,a5,0x20
 39a:	9381                	srli	a5,a5,0x20
 39c:	fff7c793          	not	a5,a5
 3a0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3a2:	15fd                	addi	a1,a1,-1
 3a4:	177d                	addi	a4,a4,-1
 3a6:	0005c683          	lbu	a3,0(a1)
 3aa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ae:	fef71ae3          	bne	a4,a5,3a2 <memmove+0x4a>
 3b2:	bfc1                	j	382 <memmove+0x2a>

00000000000003b4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3b4:	1141                	addi	sp,sp,-16
 3b6:	e406                	sd	ra,8(sp)
 3b8:	e022                	sd	s0,0(sp)
 3ba:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3bc:	ca0d                	beqz	a2,3ee <memcmp+0x3a>
 3be:	fff6069b          	addiw	a3,a2,-1
 3c2:	1682                	slli	a3,a3,0x20
 3c4:	9281                	srli	a3,a3,0x20
 3c6:	0685                	addi	a3,a3,1
 3c8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ca:	00054783          	lbu	a5,0(a0)
 3ce:	0005c703          	lbu	a4,0(a1)
 3d2:	00e79863          	bne	a5,a4,3e2 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 3d6:	0505                	addi	a0,a0,1
    p2++;
 3d8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3da:	fed518e3          	bne	a0,a3,3ca <memcmp+0x16>
  }
  return 0;
 3de:	4501                	li	a0,0
 3e0:	a019                	j	3e6 <memcmp+0x32>
      return *p1 - *p2;
 3e2:	40e7853b          	subw	a0,a5,a4
}
 3e6:	60a2                	ld	ra,8(sp)
 3e8:	6402                	ld	s0,0(sp)
 3ea:	0141                	addi	sp,sp,16
 3ec:	8082                	ret
  return 0;
 3ee:	4501                	li	a0,0
 3f0:	bfdd                	j	3e6 <memcmp+0x32>

00000000000003f2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3f2:	1141                	addi	sp,sp,-16
 3f4:	e406                	sd	ra,8(sp)
 3f6:	e022                	sd	s0,0(sp)
 3f8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3fa:	f5fff0ef          	jal	358 <memmove>
}
 3fe:	60a2                	ld	ra,8(sp)
 400:	6402                	ld	s0,0(sp)
 402:	0141                	addi	sp,sp,16
 404:	8082                	ret

0000000000000406 <sbrk>:

char *
sbrk(int n) {
 406:	1141                	addi	sp,sp,-16
 408:	e406                	sd	ra,8(sp)
 40a:	e022                	sd	s0,0(sp)
 40c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 40e:	4585                	li	a1,1
 410:	22a000ef          	jal	63a <sys_sbrk>
}
 414:	60a2                	ld	ra,8(sp)
 416:	6402                	ld	s0,0(sp)
 418:	0141                	addi	sp,sp,16
 41a:	8082                	ret

000000000000041c <sbrklazy>:

char *
sbrklazy(int n) {
 41c:	1141                	addi	sp,sp,-16
 41e:	e406                	sd	ra,8(sp)
 420:	e022                	sd	s0,0(sp)
 422:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 424:	4589                	li	a1,2
 426:	214000ef          	jal	63a <sys_sbrk>
}
 42a:	60a2                	ld	ra,8(sp)
 42c:	6402                	ld	s0,0(sp)
 42e:	0141                	addi	sp,sp,16
 430:	8082                	ret

0000000000000432 <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 432:	1101                	addi	sp,sp,-32
 434:	ec06                	sd	ra,24(sp)
 436:	e822                	sd	s0,16(sp)
 438:	e426                	sd	s1,8(sp)
 43a:	e04a                	sd	s2,0(sp)
 43c:	1000                	addi	s0,sp,32
 43e:	84aa                	mv	s1,a0
 440:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 442:	6505                	lui	a0,0x1
 444:	fc3ff0ef          	jal	406 <sbrk>
 448:	6785                	lui	a5,0x1
 44a:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 44e:	9a41                	andi	a2,a2,-16
 450:	85ca                	mv	a1,s2
 452:	8526                	mv	a0,s1
 454:	1fe000ef          	jal	652 <clone>
}
 458:	60e2                	ld	ra,24(sp)
 45a:	6442                	ld	s0,16(sp)
 45c:	64a2                	ld	s1,8(sp)
 45e:	6902                	ld	s2,0(sp)
 460:	6105                	addi	sp,sp,32
 462:	8082                	ret

0000000000000464 <futex>:

void futex(int *uaddr, int ops, int val) {
 464:	7179                	addi	sp,sp,-48
 466:	f406                	sd	ra,40(sp)
 468:	f022                	sd	s0,32(sp)
 46a:	ec26                	sd	s1,24(sp)
 46c:	1800                	addi	s0,sp,48
 46e:	84aa                	mv	s1,a0
  if (ops==0) {
 470:	ed95                	bnez	a1,4ac <futex+0x48>
    if (val==0) {
 472:	c611                	beqz	a2,47e <futex+0x1a>
 474:	e84a                	sd	s2,16(sp)
 476:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 478:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 47a:	4985                	li	s3,1
 47c:	a005                	j	49c <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 47e:	4705                	li	a4,1
 480:	87ba                	mv	a5,a4
 482:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 486:	2781                	sext.w	a5,a5
 488:	ffe5                	bnez	a5,480 <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 48a:	70a2                	ld	ra,40(sp)
 48c:	7402                	ld	s0,32(sp)
 48e:	64e2                	ld	s1,24(sp)
 490:	6145                	addi	sp,sp,48
 492:	8082                	ret
        futex_wait(uaddr, 1);
 494:	85ce                	mv	a1,s3
 496:	8526                	mv	a0,s1
 498:	1ca000ef          	jal	662 <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 49c:	87ca                	mv	a5,s2
 49e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 4a2:	2781                	sext.w	a5,a5
 4a4:	fbe5                	bnez	a5,494 <futex+0x30>
 4a6:	6942                	ld	s2,16(sp)
 4a8:	69a2                	ld	s3,8(sp)
 4aa:	b7c5                	j	48a <futex+0x26>
    if (val==0) {
 4ac:	e611                	bnez	a2,4b8 <futex+0x54>
      __sync_lock_release(uaddr);
 4ae:	0310000f          	fence	rw,w
 4b2:	00052023          	sw	zero,0(a0) # 1000 <VAR>
 4b6:	bfd1                	j	48a <futex+0x26>
      __sync_lock_release(uaddr);
 4b8:	0310000f          	fence	rw,w
 4bc:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 4c0:	1aa000ef          	jal	66a <futex_wake>
  return;
 4c4:	b7d9                	j	48a <futex+0x26>

00000000000004c6 <sem_init>:

void sem_init(sem_t* s, int val) {
 4c6:	7179                	addi	sp,sp,-48
 4c8:	f406                	sd	ra,40(sp)
 4ca:	f022                	sd	s0,32(sp)
 4cc:	ec26                	sd	s1,24(sp)
 4ce:	e84a                	sd	s2,16(sp)
 4d0:	e44e                	sd	s3,8(sp)
 4d2:	1800                	addi	s0,sp,48
 4d4:	84aa                	mv	s1,a0
 4d6:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 4d8:	00450993          	addi	s3,a0,4
 4dc:	4605                	li	a2,1
 4de:	4581                	li	a1,0
 4e0:	854e                	mv	a0,s3
 4e2:	f83ff0ef          	jal	464 <futex>
  s->value = val;
 4e6:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4ea:	4605                	li	a2,1
 4ec:	85b2                	mv	a1,a2
 4ee:	854e                	mv	a0,s3
 4f0:	f75ff0ef          	jal	464 <futex>
  return;
}
 4f4:	70a2                	ld	ra,40(sp)
 4f6:	7402                	ld	s0,32(sp)
 4f8:	64e2                	ld	s1,24(sp)
 4fa:	6942                	ld	s2,16(sp)
 4fc:	69a2                	ld	s3,8(sp)
 4fe:	6145                	addi	sp,sp,48
 500:	8082                	ret

0000000000000502 <sem_down>:

void sem_down(sem_t* s) {
 502:	7179                	addi	sp,sp,-48
 504:	f406                	sd	ra,40(sp)
 506:	f022                	sd	s0,32(sp)
 508:	ec26                	sd	s1,24(sp)
 50a:	e84a                	sd	s2,16(sp)
 50c:	e44e                	sd	s3,8(sp)
 50e:	1800                	addi	s0,sp,48
 510:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 512:	00450993          	addi	s3,a0,4
 516:	4605                	li	a2,1
 518:	4581                	li	a1,0
 51a:	854e                	mv	a0,s3
 51c:	f49ff0ef          	jal	464 <futex>
  while(1) {
    if (s->value>0) {
 520:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 524:	4485                	li	s1,1
    if (s->value>0) {
 526:	02f04463          	bgtz	a5,54e <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 52a:	8626                	mv	a2,s1
 52c:	85a6                	mv	a1,s1
 52e:	854e                	mv	a0,s3
 530:	f35ff0ef          	jal	464 <futex>
      futex_wait(&s->value,1);
 534:	85a6                	mv	a1,s1
 536:	854a                	mv	a0,s2
 538:	12a000ef          	jal	662 <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 53c:	8626                	mv	a2,s1
 53e:	4581                	li	a1,0
 540:	854e                	mv	a0,s3
 542:	f23ff0ef          	jal	464 <futex>
    if (s->value>0) {
 546:	00092783          	lw	a5,0(s2)
 54a:	fef050e3          	blez	a5,52a <sem_down+0x28>
      s->value--;
 54e:	37fd                	addiw	a5,a5,-1 # fff <digits+0x3af>
 550:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 554:	4605                	li	a2,1
 556:	85b2                	mv	a1,a2
 558:	854e                	mv	a0,s3
 55a:	f0bff0ef          	jal	464 <futex>
  return;
}
 55e:	70a2                	ld	ra,40(sp)
 560:	7402                	ld	s0,32(sp)
 562:	64e2                	ld	s1,24(sp)
 564:	6942                	ld	s2,16(sp)
 566:	69a2                	ld	s3,8(sp)
 568:	6145                	addi	sp,sp,48
 56a:	8082                	ret

000000000000056c <sem_up>:

void sem_up(sem_t* s) {
 56c:	1101                	addi	sp,sp,-32
 56e:	ec06                	sd	ra,24(sp)
 570:	e822                	sd	s0,16(sp)
 572:	e426                	sd	s1,8(sp)
 574:	e04a                	sd	s2,0(sp)
 576:	1000                	addi	s0,sp,32
 578:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 57a:	00450913          	addi	s2,a0,4
 57e:	4605                	li	a2,1
 580:	4581                	li	a1,0
 582:	854a                	mv	a0,s2
 584:	ee1ff0ef          	jal	464 <futex>
  s->value++;
 588:	409c                	lw	a5,0(s1)
 58a:	2785                	addiw	a5,a5,1
 58c:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 58e:	8526                	mv	a0,s1
 590:	0da000ef          	jal	66a <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 594:	4605                	li	a2,1
 596:	85b2                	mv	a1,a2
 598:	854a                	mv	a0,s2
 59a:	ecbff0ef          	jal	464 <futex>
  return;
 59e:	60e2                	ld	ra,24(sp)
 5a0:	6442                	ld	s0,16(sp)
 5a2:	64a2                	ld	s1,8(sp)
 5a4:	6902                	ld	s2,0(sp)
 5a6:	6105                	addi	sp,sp,32
 5a8:	8082                	ret

00000000000005aa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5aa:	4885                	li	a7,1
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5b2:	4889                	li	a7,2
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <wait>:
.global wait
wait:
 li a7, SYS_wait
 5ba:	488d                	li	a7,3
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5c2:	4891                	li	a7,4
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <read>:
.global read
read:
 li a7, SYS_read
 5ca:	4895                	li	a7,5
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <write>:
.global write
write:
 li a7, SYS_write
 5d2:	48c1                	li	a7,16
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <close>:
.global close
close:
 li a7, SYS_close
 5da:	48d5                	li	a7,21
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5e2:	4899                	li	a7,6
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <exec>:
.global exec
exec:
 li a7, SYS_exec
 5ea:	489d                	li	a7,7
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <open>:
.global open
open:
 li a7, SYS_open
 5f2:	48bd                	li	a7,15
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5fa:	48c5                	li	a7,17
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 602:	48c9                	li	a7,18
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 60a:	48a1                	li	a7,8
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <link>:
.global link
link:
 li a7, SYS_link
 612:	48cd                	li	a7,19
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 61a:	48d1                	li	a7,20
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 622:	48a5                	li	a7,9
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <dup>:
.global dup
dup:
 li a7, SYS_dup
 62a:	48a9                	li	a7,10
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 632:	48ad                	li	a7,11
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 63a:	48b1                	li	a7,12
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <pause>:
.global pause
pause:
 li a7, SYS_pause
 642:	48b5                	li	a7,13
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 64a:	48b9                	li	a7,14
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <clone>:
.global clone
clone:
 li a7, SYS_clone
 652:	48d9                	li	a7,22
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <join>:
.global join
join:
 li a7, SYS_join
 65a:	48dd                	li	a7,23
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 662:	48e1                	li	a7,24
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 66a:	48e5                	li	a7,25
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 672:	1101                	addi	sp,sp,-32
 674:	ec06                	sd	ra,24(sp)
 676:	e822                	sd	s0,16(sp)
 678:	1000                	addi	s0,sp,32
 67a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 67e:	4605                	li	a2,1
 680:	fef40593          	addi	a1,s0,-17
 684:	f4fff0ef          	jal	5d2 <write>
}
 688:	60e2                	ld	ra,24(sp)
 68a:	6442                	ld	s0,16(sp)
 68c:	6105                	addi	sp,sp,32
 68e:	8082                	ret

0000000000000690 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 690:	715d                	addi	sp,sp,-80
 692:	e486                	sd	ra,72(sp)
 694:	e0a2                	sd	s0,64(sp)
 696:	fc26                	sd	s1,56(sp)
 698:	f84a                	sd	s2,48(sp)
 69a:	f44e                	sd	s3,40(sp)
 69c:	0880                	addi	s0,sp,80
 69e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 6a0:	c299                	beqz	a3,6a6 <printint+0x16>
 6a2:	0605cc63          	bltz	a1,71a <printint+0x8a>
  neg = 0;
 6a6:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 6a8:	fb840313          	addi	t1,s0,-72
  neg = 0;
 6ac:	869a                	mv	a3,t1
  i = 0;
 6ae:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 6b0:	00000817          	auipc	a6,0x0
 6b4:	5a080813          	addi	a6,a6,1440 # c50 <digits>
 6b8:	88be                	mv	a7,a5
 6ba:	0017851b          	addiw	a0,a5,1
 6be:	87aa                	mv	a5,a0
 6c0:	02c5f733          	remu	a4,a1,a2
 6c4:	9742                	add	a4,a4,a6
 6c6:	00074703          	lbu	a4,0(a4)
 6ca:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 6ce:	872e                	mv	a4,a1
 6d0:	02c5d5b3          	divu	a1,a1,a2
 6d4:	0685                	addi	a3,a3,1
 6d6:	fec771e3          	bgeu	a4,a2,6b8 <printint+0x28>
  if(neg)
 6da:	000e0c63          	beqz	t3,6f2 <printint+0x62>
    buf[i++] = '-';
 6de:	fd050793          	addi	a5,a0,-48
 6e2:	00878533          	add	a0,a5,s0
 6e6:	02d00793          	li	a5,45
 6ea:	fef50423          	sb	a5,-24(a0)
 6ee:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 6f2:	fff7899b          	addiw	s3,a5,-1
 6f6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 6fa:	fff4c583          	lbu	a1,-1(s1)
 6fe:	854a                	mv	a0,s2
 700:	f73ff0ef          	jal	672 <putc>
  while(--i >= 0)
 704:	39fd                	addiw	s3,s3,-1
 706:	14fd                	addi	s1,s1,-1
 708:	fe09d9e3          	bgez	s3,6fa <printint+0x6a>
}
 70c:	60a6                	ld	ra,72(sp)
 70e:	6406                	ld	s0,64(sp)
 710:	74e2                	ld	s1,56(sp)
 712:	7942                	ld	s2,48(sp)
 714:	79a2                	ld	s3,40(sp)
 716:	6161                	addi	sp,sp,80
 718:	8082                	ret
    x = -xx;
 71a:	40b005b3          	neg	a1,a1
    neg = 1;
 71e:	4e05                	li	t3,1
    x = -xx;
 720:	b761                	j	6a8 <printint+0x18>

0000000000000722 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 722:	711d                	addi	sp,sp,-96
 724:	ec86                	sd	ra,88(sp)
 726:	e8a2                	sd	s0,80(sp)
 728:	e4a6                	sd	s1,72(sp)
 72a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 72c:	0005c483          	lbu	s1,0(a1)
 730:	28048463          	beqz	s1,9b8 <vprintf+0x296>
 734:	e0ca                	sd	s2,64(sp)
 736:	fc4e                	sd	s3,56(sp)
 738:	f852                	sd	s4,48(sp)
 73a:	f456                	sd	s5,40(sp)
 73c:	f05a                	sd	s6,32(sp)
 73e:	ec5e                	sd	s7,24(sp)
 740:	e862                	sd	s8,16(sp)
 742:	e466                	sd	s9,8(sp)
 744:	8b2a                	mv	s6,a0
 746:	8a2e                	mv	s4,a1
 748:	8bb2                	mv	s7,a2
  state = 0;
 74a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 74c:	4901                	li	s2,0
 74e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 750:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 754:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 758:	06c00c93          	li	s9,108
 75c:	a00d                	j	77e <vprintf+0x5c>
        putc(fd, c0);
 75e:	85a6                	mv	a1,s1
 760:	855a                	mv	a0,s6
 762:	f11ff0ef          	jal	672 <putc>
 766:	a019                	j	76c <vprintf+0x4a>
    } else if(state == '%'){
 768:	03598363          	beq	s3,s5,78e <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 76c:	0019079b          	addiw	a5,s2,1
 770:	893e                	mv	s2,a5
 772:	873e                	mv	a4,a5
 774:	97d2                	add	a5,a5,s4
 776:	0007c483          	lbu	s1,0(a5)
 77a:	22048763          	beqz	s1,9a8 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 77e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 782:	fe0993e3          	bnez	s3,768 <vprintf+0x46>
      if(c0 == '%'){
 786:	fd579ce3          	bne	a5,s5,75e <vprintf+0x3c>
        state = '%';
 78a:	89be                	mv	s3,a5
 78c:	b7c5                	j	76c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 78e:	00ea06b3          	add	a3,s4,a4
 792:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 796:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 798:	c681                	beqz	a3,7a0 <vprintf+0x7e>
 79a:	9752                	add	a4,a4,s4
 79c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 7a0:	05878263          	beq	a5,s8,7e4 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 7a4:	05978c63          	beq	a5,s9,7fc <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 7a8:	07500713          	li	a4,117
 7ac:	0ee78663          	beq	a5,a4,898 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 7b0:	07800713          	li	a4,120
 7b4:	12e78863          	beq	a5,a4,8e4 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7b8:	07000713          	li	a4,112
 7bc:	14e78d63          	beq	a5,a4,916 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 7c0:	06300713          	li	a4,99
 7c4:	18e78c63          	beq	a5,a4,95c <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 7c8:	07300713          	li	a4,115
 7cc:	1ae78263          	beq	a5,a4,970 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7d0:	02500713          	li	a4,37
 7d4:	04e79463          	bne	a5,a4,81c <vprintf+0xfa>
        putc(fd, '%');
 7d8:	85ba                	mv	a1,a4
 7da:	855a                	mv	a0,s6
 7dc:	e97ff0ef          	jal	672 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	b769                	j	76c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 7e4:	008b8493          	addi	s1,s7,8
 7e8:	4685                	li	a3,1
 7ea:	4629                	li	a2,10
 7ec:	000ba583          	lw	a1,0(s7)
 7f0:	855a                	mv	a0,s6
 7f2:	e9fff0ef          	jal	690 <printint>
 7f6:	8ba6                	mv	s7,s1
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	bf8d                	j	76c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 7fc:	06400793          	li	a5,100
 800:	02f68963          	beq	a3,a5,832 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 804:	06c00793          	li	a5,108
 808:	04f68263          	beq	a3,a5,84c <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 80c:	07500793          	li	a5,117
 810:	0af68063          	beq	a3,a5,8b0 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 814:	07800793          	li	a5,120
 818:	0ef68263          	beq	a3,a5,8fc <vprintf+0x1da>
        putc(fd, '%');
 81c:	02500593          	li	a1,37
 820:	855a                	mv	a0,s6
 822:	e51ff0ef          	jal	672 <putc>
        putc(fd, c0);
 826:	85a6                	mv	a1,s1
 828:	855a                	mv	a0,s6
 82a:	e49ff0ef          	jal	672 <putc>
      state = 0;
 82e:	4981                	li	s3,0
 830:	bf35                	j	76c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 832:	008b8493          	addi	s1,s7,8
 836:	4685                	li	a3,1
 838:	4629                	li	a2,10
 83a:	000bb583          	ld	a1,0(s7)
 83e:	855a                	mv	a0,s6
 840:	e51ff0ef          	jal	690 <printint>
        i += 1;
 844:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 846:	8ba6                	mv	s7,s1
      state = 0;
 848:	4981                	li	s3,0
        i += 1;
 84a:	b70d                	j	76c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 84c:	06400793          	li	a5,100
 850:	02f60763          	beq	a2,a5,87e <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 854:	07500793          	li	a5,117
 858:	06f60963          	beq	a2,a5,8ca <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 85c:	07800793          	li	a5,120
 860:	faf61ee3          	bne	a2,a5,81c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 864:	008b8493          	addi	s1,s7,8
 868:	4681                	li	a3,0
 86a:	4641                	li	a2,16
 86c:	000bb583          	ld	a1,0(s7)
 870:	855a                	mv	a0,s6
 872:	e1fff0ef          	jal	690 <printint>
        i += 2;
 876:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 878:	8ba6                	mv	s7,s1
      state = 0;
 87a:	4981                	li	s3,0
        i += 2;
 87c:	bdc5                	j	76c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 87e:	008b8493          	addi	s1,s7,8
 882:	4685                	li	a3,1
 884:	4629                	li	a2,10
 886:	000bb583          	ld	a1,0(s7)
 88a:	855a                	mv	a0,s6
 88c:	e05ff0ef          	jal	690 <printint>
        i += 2;
 890:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 892:	8ba6                	mv	s7,s1
      state = 0;
 894:	4981                	li	s3,0
        i += 2;
 896:	bdd9                	j	76c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 898:	008b8493          	addi	s1,s7,8
 89c:	4681                	li	a3,0
 89e:	4629                	li	a2,10
 8a0:	000be583          	lwu	a1,0(s7)
 8a4:	855a                	mv	a0,s6
 8a6:	debff0ef          	jal	690 <printint>
 8aa:	8ba6                	mv	s7,s1
      state = 0;
 8ac:	4981                	li	s3,0
 8ae:	bd7d                	j	76c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8b0:	008b8493          	addi	s1,s7,8
 8b4:	4681                	li	a3,0
 8b6:	4629                	li	a2,10
 8b8:	000bb583          	ld	a1,0(s7)
 8bc:	855a                	mv	a0,s6
 8be:	dd3ff0ef          	jal	690 <printint>
        i += 1;
 8c2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8c4:	8ba6                	mv	s7,s1
      state = 0;
 8c6:	4981                	li	s3,0
        i += 1;
 8c8:	b555                	j	76c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ca:	008b8493          	addi	s1,s7,8
 8ce:	4681                	li	a3,0
 8d0:	4629                	li	a2,10
 8d2:	000bb583          	ld	a1,0(s7)
 8d6:	855a                	mv	a0,s6
 8d8:	db9ff0ef          	jal	690 <printint>
        i += 2;
 8dc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8de:	8ba6                	mv	s7,s1
      state = 0;
 8e0:	4981                	li	s3,0
        i += 2;
 8e2:	b569                	j	76c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 8e4:	008b8493          	addi	s1,s7,8
 8e8:	4681                	li	a3,0
 8ea:	4641                	li	a2,16
 8ec:	000be583          	lwu	a1,0(s7)
 8f0:	855a                	mv	a0,s6
 8f2:	d9fff0ef          	jal	690 <printint>
 8f6:	8ba6                	mv	s7,s1
      state = 0;
 8f8:	4981                	li	s3,0
 8fa:	bd8d                	j	76c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8fc:	008b8493          	addi	s1,s7,8
 900:	4681                	li	a3,0
 902:	4641                	li	a2,16
 904:	000bb583          	ld	a1,0(s7)
 908:	855a                	mv	a0,s6
 90a:	d87ff0ef          	jal	690 <printint>
        i += 1;
 90e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 910:	8ba6                	mv	s7,s1
      state = 0;
 912:	4981                	li	s3,0
        i += 1;
 914:	bda1                	j	76c <vprintf+0x4a>
 916:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 918:	008b8d13          	addi	s10,s7,8
 91c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 920:	03000593          	li	a1,48
 924:	855a                	mv	a0,s6
 926:	d4dff0ef          	jal	672 <putc>
  putc(fd, 'x');
 92a:	07800593          	li	a1,120
 92e:	855a                	mv	a0,s6
 930:	d43ff0ef          	jal	672 <putc>
 934:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 936:	00000b97          	auipc	s7,0x0
 93a:	31ab8b93          	addi	s7,s7,794 # c50 <digits>
 93e:	03c9d793          	srli	a5,s3,0x3c
 942:	97de                	add	a5,a5,s7
 944:	0007c583          	lbu	a1,0(a5)
 948:	855a                	mv	a0,s6
 94a:	d29ff0ef          	jal	672 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 94e:	0992                	slli	s3,s3,0x4
 950:	34fd                	addiw	s1,s1,-1
 952:	f4f5                	bnez	s1,93e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 954:	8bea                	mv	s7,s10
      state = 0;
 956:	4981                	li	s3,0
 958:	6d02                	ld	s10,0(sp)
 95a:	bd09                	j	76c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 95c:	008b8493          	addi	s1,s7,8
 960:	000bc583          	lbu	a1,0(s7)
 964:	855a                	mv	a0,s6
 966:	d0dff0ef          	jal	672 <putc>
 96a:	8ba6                	mv	s7,s1
      state = 0;
 96c:	4981                	li	s3,0
 96e:	bbfd                	j	76c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 970:	008b8993          	addi	s3,s7,8
 974:	000bb483          	ld	s1,0(s7)
 978:	cc91                	beqz	s1,994 <vprintf+0x272>
        for(; *s; s++)
 97a:	0004c583          	lbu	a1,0(s1)
 97e:	c195                	beqz	a1,9a2 <vprintf+0x280>
          putc(fd, *s);
 980:	855a                	mv	a0,s6
 982:	cf1ff0ef          	jal	672 <putc>
        for(; *s; s++)
 986:	0485                	addi	s1,s1,1
 988:	0004c583          	lbu	a1,0(s1)
 98c:	f9f5                	bnez	a1,980 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 98e:	8bce                	mv	s7,s3
      state = 0;
 990:	4981                	li	s3,0
 992:	bbe9                	j	76c <vprintf+0x4a>
          s = "(null)";
 994:	00000497          	auipc	s1,0x0
 998:	2b448493          	addi	s1,s1,692 # c48 <malloc+0x1a4>
        for(; *s; s++)
 99c:	02800593          	li	a1,40
 9a0:	b7c5                	j	980 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 9a2:	8bce                	mv	s7,s3
      state = 0;
 9a4:	4981                	li	s3,0
 9a6:	b3d9                	j	76c <vprintf+0x4a>
 9a8:	6906                	ld	s2,64(sp)
 9aa:	79e2                	ld	s3,56(sp)
 9ac:	7a42                	ld	s4,48(sp)
 9ae:	7aa2                	ld	s5,40(sp)
 9b0:	7b02                	ld	s6,32(sp)
 9b2:	6be2                	ld	s7,24(sp)
 9b4:	6c42                	ld	s8,16(sp)
 9b6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 9b8:	60e6                	ld	ra,88(sp)
 9ba:	6446                	ld	s0,80(sp)
 9bc:	64a6                	ld	s1,72(sp)
 9be:	6125                	addi	sp,sp,96
 9c0:	8082                	ret

00000000000009c2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9c2:	715d                	addi	sp,sp,-80
 9c4:	ec06                	sd	ra,24(sp)
 9c6:	e822                	sd	s0,16(sp)
 9c8:	1000                	addi	s0,sp,32
 9ca:	e010                	sd	a2,0(s0)
 9cc:	e414                	sd	a3,8(s0)
 9ce:	e818                	sd	a4,16(s0)
 9d0:	ec1c                	sd	a5,24(s0)
 9d2:	03043023          	sd	a6,32(s0)
 9d6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9da:	8622                	mv	a2,s0
 9dc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9e0:	d43ff0ef          	jal	722 <vprintf>
}
 9e4:	60e2                	ld	ra,24(sp)
 9e6:	6442                	ld	s0,16(sp)
 9e8:	6161                	addi	sp,sp,80
 9ea:	8082                	ret

00000000000009ec <printf>:

void
printf(const char *fmt, ...)
{
 9ec:	711d                	addi	sp,sp,-96
 9ee:	ec06                	sd	ra,24(sp)
 9f0:	e822                	sd	s0,16(sp)
 9f2:	1000                	addi	s0,sp,32
 9f4:	e40c                	sd	a1,8(s0)
 9f6:	e810                	sd	a2,16(s0)
 9f8:	ec14                	sd	a3,24(s0)
 9fa:	f018                	sd	a4,32(s0)
 9fc:	f41c                	sd	a5,40(s0)
 9fe:	03043823          	sd	a6,48(s0)
 a02:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a06:	00840613          	addi	a2,s0,8
 a0a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a0e:	85aa                	mv	a1,a0
 a10:	4505                	li	a0,1
 a12:	d11ff0ef          	jal	722 <vprintf>
}
 a16:	60e2                	ld	ra,24(sp)
 a18:	6442                	ld	s0,16(sp)
 a1a:	6125                	addi	sp,sp,96
 a1c:	8082                	ret

0000000000000a1e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a1e:	1141                	addi	sp,sp,-16
 a20:	e406                	sd	ra,8(sp)
 a22:	e022                	sd	s0,0(sp)
 a24:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a26:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a2a:	00000797          	auipc	a5,0x0
 a2e:	5de7b783          	ld	a5,1502(a5) # 1008 <freep>
 a32:	a02d                	j	a5c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a34:	4618                	lw	a4,8(a2)
 a36:	9f2d                	addw	a4,a4,a1
 a38:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a3c:	6398                	ld	a4,0(a5)
 a3e:	6310                	ld	a2,0(a4)
 a40:	a83d                	j	a7e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a42:	ff852703          	lw	a4,-8(a0)
 a46:	9f31                	addw	a4,a4,a2
 a48:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a4a:	ff053683          	ld	a3,-16(a0)
 a4e:	a091                	j	a92 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a50:	6398                	ld	a4,0(a5)
 a52:	00e7e463          	bltu	a5,a4,a5a <free+0x3c>
 a56:	00e6ea63          	bltu	a3,a4,a6a <free+0x4c>
{
 a5a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a5c:	fed7fae3          	bgeu	a5,a3,a50 <free+0x32>
 a60:	6398                	ld	a4,0(a5)
 a62:	00e6e463          	bltu	a3,a4,a6a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a66:	fee7eae3          	bltu	a5,a4,a5a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 a6a:	ff852583          	lw	a1,-8(a0)
 a6e:	6390                	ld	a2,0(a5)
 a70:	02059813          	slli	a6,a1,0x20
 a74:	01c85713          	srli	a4,a6,0x1c
 a78:	9736                	add	a4,a4,a3
 a7a:	fae60de3          	beq	a2,a4,a34 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a7e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a82:	4790                	lw	a2,8(a5)
 a84:	02061593          	slli	a1,a2,0x20
 a88:	01c5d713          	srli	a4,a1,0x1c
 a8c:	973e                	add	a4,a4,a5
 a8e:	fae68ae3          	beq	a3,a4,a42 <free+0x24>
    p->s.ptr = bp->s.ptr;
 a92:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a94:	00000717          	auipc	a4,0x0
 a98:	56f73a23          	sd	a5,1396(a4) # 1008 <freep>
}
 a9c:	60a2                	ld	ra,8(sp)
 a9e:	6402                	ld	s0,0(sp)
 aa0:	0141                	addi	sp,sp,16
 aa2:	8082                	ret

0000000000000aa4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 aa4:	7139                	addi	sp,sp,-64
 aa6:	fc06                	sd	ra,56(sp)
 aa8:	f822                	sd	s0,48(sp)
 aaa:	f04a                	sd	s2,32(sp)
 aac:	ec4e                	sd	s3,24(sp)
 aae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ab0:	02051993          	slli	s3,a0,0x20
 ab4:	0209d993          	srli	s3,s3,0x20
 ab8:	09bd                	addi	s3,s3,15
 aba:	0049d993          	srli	s3,s3,0x4
 abe:	2985                	addiw	s3,s3,1
 ac0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 ac2:	00000517          	auipc	a0,0x0
 ac6:	54653503          	ld	a0,1350(a0) # 1008 <freep>
 aca:	c905                	beqz	a0,afa <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 acc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ace:	4798                	lw	a4,8(a5)
 ad0:	09377663          	bgeu	a4,s3,b5c <malloc+0xb8>
 ad4:	f426                	sd	s1,40(sp)
 ad6:	e852                	sd	s4,16(sp)
 ad8:	e456                	sd	s5,8(sp)
 ada:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 adc:	8a4e                	mv	s4,s3
 ade:	6705                	lui	a4,0x1
 ae0:	00e9f363          	bgeu	s3,a4,ae6 <malloc+0x42>
 ae4:	6a05                	lui	s4,0x1
 ae6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 aea:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 aee:	00000497          	auipc	s1,0x0
 af2:	51a48493          	addi	s1,s1,1306 # 1008 <freep>
  if(p == SBRK_ERROR)
 af6:	5afd                	li	s5,-1
 af8:	a83d                	j	b36 <malloc+0x92>
 afa:	f426                	sd	s1,40(sp)
 afc:	e852                	sd	s4,16(sp)
 afe:	e456                	sd	s5,8(sp)
 b00:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b02:	00000797          	auipc	a5,0x0
 b06:	50e78793          	addi	a5,a5,1294 # 1010 <base>
 b0a:	00000717          	auipc	a4,0x0
 b0e:	4ef73f23          	sd	a5,1278(a4) # 1008 <freep>
 b12:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b14:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b18:	b7d1                	j	adc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b1a:	6398                	ld	a4,0(a5)
 b1c:	e118                	sd	a4,0(a0)
 b1e:	a899                	j	b74 <malloc+0xd0>
  hp->s.size = nu;
 b20:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b24:	0541                	addi	a0,a0,16
 b26:	ef9ff0ef          	jal	a1e <free>
  return freep;
 b2a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b2c:	c125                	beqz	a0,b8c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b2e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b30:	4798                	lw	a4,8(a5)
 b32:	03277163          	bgeu	a4,s2,b54 <malloc+0xb0>
    if(p == freep)
 b36:	6098                	ld	a4,0(s1)
 b38:	853e                	mv	a0,a5
 b3a:	fef71ae3          	bne	a4,a5,b2e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b3e:	8552                	mv	a0,s4
 b40:	8c7ff0ef          	jal	406 <sbrk>
  if(p == SBRK_ERROR)
 b44:	fd551ee3          	bne	a0,s5,b20 <malloc+0x7c>
        return 0;
 b48:	4501                	li	a0,0
 b4a:	74a2                	ld	s1,40(sp)
 b4c:	6a42                	ld	s4,16(sp)
 b4e:	6aa2                	ld	s5,8(sp)
 b50:	6b02                	ld	s6,0(sp)
 b52:	a03d                	j	b80 <malloc+0xdc>
 b54:	74a2                	ld	s1,40(sp)
 b56:	6a42                	ld	s4,16(sp)
 b58:	6aa2                	ld	s5,8(sp)
 b5a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b5c:	fae90fe3          	beq	s2,a4,b1a <malloc+0x76>
        p->s.size -= nunits;
 b60:	4137073b          	subw	a4,a4,s3
 b64:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b66:	02071693          	slli	a3,a4,0x20
 b6a:	01c6d713          	srli	a4,a3,0x1c
 b6e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b70:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b74:	00000717          	auipc	a4,0x0
 b78:	48a73a23          	sd	a0,1172(a4) # 1008 <freep>
      return (void*)(p + 1);
 b7c:	01078513          	addi	a0,a5,16
  }
}
 b80:	70e2                	ld	ra,56(sp)
 b82:	7442                	ld	s0,48(sp)
 b84:	7902                	ld	s2,32(sp)
 b86:	69e2                	ld	s3,24(sp)
 b88:	6121                	addi	sp,sp,64
 b8a:	8082                	ret
 b8c:	74a2                	ld	s1,40(sp)
 b8e:	6a42                	ld	s4,16(sp)
 b90:	6aa2                	ld	s5,8(sp)
 b92:	6b02                	ld	s6,0(sp)
 b94:	b7f5                	j	b80 <malloc+0xdc>
