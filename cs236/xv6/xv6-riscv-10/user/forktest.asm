
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
   c:	128000ef          	jal	134 <strlen>
  10:	862a                	mv	a2,a0
  12:	85a6                	mv	a1,s1
  14:	4505                	li	a0,1
  16:	51e000ef          	jal	534 <write>
}
  1a:	60e2                	ld	ra,24(sp)
  1c:	6442                	ld	s0,16(sp)
  1e:	64a2                	ld	s1,8(sp)
  20:	6105                	addi	sp,sp,32
  22:	8082                	ret

0000000000000024 <forktest>:

void
forktest(void)
{
  24:	1101                	addi	sp,sp,-32
  26:	ec06                	sd	ra,24(sp)
  28:	e822                	sd	s0,16(sp)
  2a:	e426                	sd	s1,8(sp)
  2c:	e04a                	sd	s2,0(sp)
  2e:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  30:	00000517          	auipc	a0,0x0
  34:	5a850513          	addi	a0,a0,1448 # 5d8 <futex_wake+0xc>
  38:	fc9ff0ef          	jal	0 <print>

  for(n=0; n<N; n++){
  3c:	4481                	li	s1,0
  3e:	3e800913          	li	s2,1000
    pid = fork();
  42:	4ca000ef          	jal	50c <fork>
    if(pid < 0)
  46:	04054363          	bltz	a0,8c <forktest+0x68>
      break;
    if(pid == 0)
  4a:	cd09                	beqz	a0,64 <forktest+0x40>
  for(n=0; n<N; n++){
  4c:	2485                	addiw	s1,s1,1
  4e:	ff249ae3          	bne	s1,s2,42 <forktest+0x1e>
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
  52:	00000517          	auipc	a0,0x0
  56:	5d650513          	addi	a0,a0,1494 # 628 <futex_wake+0x5c>
  5a:	fa7ff0ef          	jal	0 <print>
    exit(1);
  5e:	4505                	li	a0,1
  60:	4b4000ef          	jal	514 <exit>
      exit(0);
  64:	4b0000ef          	jal	514 <exit>
  }

  for(; n > 0; n--){
    if(wait(0) < 0){
      print("wait stopped early\n");
  68:	00000517          	auipc	a0,0x0
  6c:	58050513          	addi	a0,a0,1408 # 5e8 <futex_wake+0x1c>
  70:	f91ff0ef          	jal	0 <print>
      exit(1);
  74:	4505                	li	a0,1
  76:	49e000ef          	jal	514 <exit>
    }
  }

  if(wait(0) != -1){
    print("wait got too many\n");
  7a:	00000517          	auipc	a0,0x0
  7e:	58650513          	addi	a0,a0,1414 # 600 <futex_wake+0x34>
  82:	f7fff0ef          	jal	0 <print>
    exit(1);
  86:	4505                	li	a0,1
  88:	48c000ef          	jal	514 <exit>
  for(; n > 0; n--){
  8c:	00905963          	blez	s1,9e <forktest+0x7a>
    if(wait(0) < 0){
  90:	4501                	li	a0,0
  92:	48a000ef          	jal	51c <wait>
  96:	fc0549e3          	bltz	a0,68 <forktest+0x44>
  for(; n > 0; n--){
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f8f5                	bnez	s1,90 <forktest+0x6c>
  if(wait(0) != -1){
  9e:	4501                	li	a0,0
  a0:	47c000ef          	jal	51c <wait>
  a4:	57fd                	li	a5,-1
  a6:	fcf51ae3          	bne	a0,a5,7a <forktest+0x56>
  }

  print("fork test OK\n");
  aa:	00000517          	auipc	a0,0x0
  ae:	56e50513          	addi	a0,a0,1390 # 618 <futex_wake+0x4c>
  b2:	f4fff0ef          	jal	0 <print>
}
  b6:	60e2                	ld	ra,24(sp)
  b8:	6442                	ld	s0,16(sp)
  ba:	64a2                	ld	s1,8(sp)
  bc:	6902                	ld	s2,0(sp)
  be:	6105                	addi	sp,sp,32
  c0:	8082                	ret

00000000000000c2 <main>:

int
main(void)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e406                	sd	ra,8(sp)
  c6:	e022                	sd	s0,0(sp)
  c8:	0800                	addi	s0,sp,16
  forktest();
  ca:	f5bff0ef          	jal	24 <forktest>
  exit(0);
  ce:	4501                	li	a0,0
  d0:	444000ef          	jal	514 <exit>

00000000000000d4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e406                	sd	ra,8(sp)
  d8:	e022                	sd	s0,0(sp)
  da:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  dc:	fe7ff0ef          	jal	c2 <main>
  exit(r);
  e0:	434000ef          	jal	514 <exit>

00000000000000e4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ec:	87aa                	mv	a5,a0
  ee:	0585                	addi	a1,a1,1
  f0:	0785                	addi	a5,a5,1
  f2:	fff5c703          	lbu	a4,-1(a1)
  f6:	fee78fa3          	sb	a4,-1(a5)
  fa:	fb75                	bnez	a4,ee <strcpy+0xa>
    ;
  return os;
}
  fc:	60a2                	ld	ra,8(sp)
  fe:	6402                	ld	s0,0(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret

0000000000000104 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cb91                	beqz	a5,124 <strcmp+0x20>
 112:	0005c703          	lbu	a4,0(a1)
 116:	00f71763          	bne	a4,a5,124 <strcmp+0x20>
    p++, q++;
 11a:	0505                	addi	a0,a0,1
 11c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbe5                	bnez	a5,112 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 124:	0005c503          	lbu	a0,0(a1)
}
 128:	40a7853b          	subw	a0,a5,a0
 12c:	60a2                	ld	ra,8(sp)
 12e:	6402                	ld	s0,0(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strlen>:

uint
strlen(const char *s)
{
 134:	1141                	addi	sp,sp,-16
 136:	e406                	sd	ra,8(sp)
 138:	e022                	sd	s0,0(sp)
 13a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 13c:	00054783          	lbu	a5,0(a0)
 140:	cf99                	beqz	a5,15e <strlen+0x2a>
 142:	0505                	addi	a0,a0,1
 144:	87aa                	mv	a5,a0
 146:	86be                	mv	a3,a5
 148:	0785                	addi	a5,a5,1
 14a:	fff7c703          	lbu	a4,-1(a5)
 14e:	ff65                	bnez	a4,146 <strlen+0x12>
 150:	40a6853b          	subw	a0,a3,a0
 154:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 156:	60a2                	ld	ra,8(sp)
 158:	6402                	ld	s0,0(sp)
 15a:	0141                	addi	sp,sp,16
 15c:	8082                	ret
  for(n = 0; s[n]; n++)
 15e:	4501                	li	a0,0
 160:	bfdd                	j	156 <strlen+0x22>

0000000000000162 <memset>:

void*
memset(void *dst, int c, uint n)
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 16a:	ca19                	beqz	a2,180 <memset+0x1e>
 16c:	87aa                	mv	a5,a0
 16e:	1602                	slli	a2,a2,0x20
 170:	9201                	srli	a2,a2,0x20
 172:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 176:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 17a:	0785                	addi	a5,a5,1
 17c:	fee79de3          	bne	a5,a4,176 <memset+0x14>
  }
  return dst;
}
 180:	60a2                	ld	ra,8(sp)
 182:	6402                	ld	s0,0(sp)
 184:	0141                	addi	sp,sp,16
 186:	8082                	ret

0000000000000188 <strchr>:

char*
strchr(const char *s, char c)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e406                	sd	ra,8(sp)
 18c:	e022                	sd	s0,0(sp)
 18e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 190:	00054783          	lbu	a5,0(a0)
 194:	cf81                	beqz	a5,1ac <strchr+0x24>
    if(*s == c)
 196:	00f58763          	beq	a1,a5,1a4 <strchr+0x1c>
  for(; *s; s++)
 19a:	0505                	addi	a0,a0,1
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	fbfd                	bnez	a5,196 <strchr+0xe>
      return (char*)s;
  return 0;
 1a2:	4501                	li	a0,0
}
 1a4:	60a2                	ld	ra,8(sp)
 1a6:	6402                	ld	s0,0(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret
  return 0;
 1ac:	4501                	li	a0,0
 1ae:	bfdd                	j	1a4 <strchr+0x1c>

00000000000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	7159                	addi	sp,sp,-112
 1b2:	f486                	sd	ra,104(sp)
 1b4:	f0a2                	sd	s0,96(sp)
 1b6:	eca6                	sd	s1,88(sp)
 1b8:	e8ca                	sd	s2,80(sp)
 1ba:	e4ce                	sd	s3,72(sp)
 1bc:	e0d2                	sd	s4,64(sp)
 1be:	fc56                	sd	s5,56(sp)
 1c0:	f85a                	sd	s6,48(sp)
 1c2:	f45e                	sd	s7,40(sp)
 1c4:	f062                	sd	s8,32(sp)
 1c6:	ec66                	sd	s9,24(sp)
 1c8:	e86a                	sd	s10,16(sp)
 1ca:	1880                	addi	s0,sp,112
 1cc:	8caa                	mv	s9,a0
 1ce:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d0:	892a                	mv	s2,a0
 1d2:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1d4:	f9f40b13          	addi	s6,s0,-97
 1d8:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1da:	4ba9                	li	s7,10
 1dc:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1de:	8d26                	mv	s10,s1
 1e0:	0014899b          	addiw	s3,s1,1
 1e4:	84ce                	mv	s1,s3
 1e6:	0349d563          	bge	s3,s4,210 <gets+0x60>
    cc = read(0, &c, 1);
 1ea:	8656                	mv	a2,s5
 1ec:	85da                	mv	a1,s6
 1ee:	4501                	li	a0,0
 1f0:	33c000ef          	jal	52c <read>
    if(cc < 1)
 1f4:	00a05e63          	blez	a0,210 <gets+0x60>
    buf[i++] = c;
 1f8:	f9f44783          	lbu	a5,-97(s0)
 1fc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 200:	01778763          	beq	a5,s7,20e <gets+0x5e>
 204:	0905                	addi	s2,s2,1
 206:	fd879ce3          	bne	a5,s8,1de <gets+0x2e>
    buf[i++] = c;
 20a:	8d4e                	mv	s10,s3
 20c:	a011                	j	210 <gets+0x60>
 20e:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 210:	9d66                	add	s10,s10,s9
 212:	000d0023          	sb	zero,0(s10)
  return buf;
}
 216:	8566                	mv	a0,s9
 218:	70a6                	ld	ra,104(sp)
 21a:	7406                	ld	s0,96(sp)
 21c:	64e6                	ld	s1,88(sp)
 21e:	6946                	ld	s2,80(sp)
 220:	69a6                	ld	s3,72(sp)
 222:	6a06                	ld	s4,64(sp)
 224:	7ae2                	ld	s5,56(sp)
 226:	7b42                	ld	s6,48(sp)
 228:	7ba2                	ld	s7,40(sp)
 22a:	7c02                	ld	s8,32(sp)
 22c:	6ce2                	ld	s9,24(sp)
 22e:	6d42                	ld	s10,16(sp)
 230:	6165                	addi	sp,sp,112
 232:	8082                	ret

0000000000000234 <stat>:

int
stat(const char *n, struct stat *st)
{
 234:	1101                	addi	sp,sp,-32
 236:	ec06                	sd	ra,24(sp)
 238:	e822                	sd	s0,16(sp)
 23a:	e04a                	sd	s2,0(sp)
 23c:	1000                	addi	s0,sp,32
 23e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 240:	4581                	li	a1,0
 242:	312000ef          	jal	554 <open>
  if(fd < 0)
 246:	02054263          	bltz	a0,26a <stat+0x36>
 24a:	e426                	sd	s1,8(sp)
 24c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 24e:	85ca                	mv	a1,s2
 250:	31c000ef          	jal	56c <fstat>
 254:	892a                	mv	s2,a0
  close(fd);
 256:	8526                	mv	a0,s1
 258:	2e4000ef          	jal	53c <close>
  return r;
 25c:	64a2                	ld	s1,8(sp)
}
 25e:	854a                	mv	a0,s2
 260:	60e2                	ld	ra,24(sp)
 262:	6442                	ld	s0,16(sp)
 264:	6902                	ld	s2,0(sp)
 266:	6105                	addi	sp,sp,32
 268:	8082                	ret
    return -1;
 26a:	597d                	li	s2,-1
 26c:	bfcd                	j	25e <stat+0x2a>

000000000000026e <atoi>:

int
atoi(const char *s)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e406                	sd	ra,8(sp)
 272:	e022                	sd	s0,0(sp)
 274:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 276:	00054683          	lbu	a3,0(a0)
 27a:	fd06879b          	addiw	a5,a3,-48
 27e:	0ff7f793          	zext.b	a5,a5
 282:	4625                	li	a2,9
 284:	02f66963          	bltu	a2,a5,2b6 <atoi+0x48>
 288:	872a                	mv	a4,a0
  n = 0;
 28a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 28c:	0705                	addi	a4,a4,1
 28e:	0025179b          	slliw	a5,a0,0x2
 292:	9fa9                	addw	a5,a5,a0
 294:	0017979b          	slliw	a5,a5,0x1
 298:	9fb5                	addw	a5,a5,a3
 29a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 29e:	00074683          	lbu	a3,0(a4)
 2a2:	fd06879b          	addiw	a5,a3,-48
 2a6:	0ff7f793          	zext.b	a5,a5
 2aa:	fef671e3          	bgeu	a2,a5,28c <atoi+0x1e>
  return n;
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
  n = 0;
 2b6:	4501                	li	a0,0
 2b8:	bfdd                	j	2ae <atoi+0x40>

00000000000002ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e406                	sd	ra,8(sp)
 2be:	e022                	sd	s0,0(sp)
 2c0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c2:	02b57563          	bgeu	a0,a1,2ec <memmove+0x32>
    while(n-- > 0)
 2c6:	00c05f63          	blez	a2,2e4 <memmove+0x2a>
 2ca:	1602                	slli	a2,a2,0x20
 2cc:	9201                	srli	a2,a2,0x20
 2ce:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d4:	0585                	addi	a1,a1,1
 2d6:	0705                	addi	a4,a4,1
 2d8:	fff5c683          	lbu	a3,-1(a1)
 2dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2e0:	fee79ae3          	bne	a5,a4,2d4 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
    dst += n;
 2ec:	00c50733          	add	a4,a0,a2
    src += n;
 2f0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2f2:	fec059e3          	blez	a2,2e4 <memmove+0x2a>
 2f6:	fff6079b          	addiw	a5,a2,-1
 2fa:	1782                	slli	a5,a5,0x20
 2fc:	9381                	srli	a5,a5,0x20
 2fe:	fff7c793          	not	a5,a5
 302:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 304:	15fd                	addi	a1,a1,-1
 306:	177d                	addi	a4,a4,-1
 308:	0005c683          	lbu	a3,0(a1)
 30c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 310:	fef71ae3          	bne	a4,a5,304 <memmove+0x4a>
 314:	bfc1                	j	2e4 <memmove+0x2a>

0000000000000316 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 316:	1141                	addi	sp,sp,-16
 318:	e406                	sd	ra,8(sp)
 31a:	e022                	sd	s0,0(sp)
 31c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 31e:	ca0d                	beqz	a2,350 <memcmp+0x3a>
 320:	fff6069b          	addiw	a3,a2,-1
 324:	1682                	slli	a3,a3,0x20
 326:	9281                	srli	a3,a3,0x20
 328:	0685                	addi	a3,a3,1
 32a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 32c:	00054783          	lbu	a5,0(a0)
 330:	0005c703          	lbu	a4,0(a1)
 334:	00e79863          	bne	a5,a4,344 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 338:	0505                	addi	a0,a0,1
    p2++;
 33a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 33c:	fed518e3          	bne	a0,a3,32c <memcmp+0x16>
  }
  return 0;
 340:	4501                	li	a0,0
 342:	a019                	j	348 <memcmp+0x32>
      return *p1 - *p2;
 344:	40e7853b          	subw	a0,a5,a4
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret
  return 0;
 350:	4501                	li	a0,0
 352:	bfdd                	j	348 <memcmp+0x32>

0000000000000354 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 35c:	f5fff0ef          	jal	2ba <memmove>
}
 360:	60a2                	ld	ra,8(sp)
 362:	6402                	ld	s0,0(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <sbrk>:

char *
sbrk(int n) {
 368:	1141                	addi	sp,sp,-16
 36a:	e406                	sd	ra,8(sp)
 36c:	e022                	sd	s0,0(sp)
 36e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 370:	4585                	li	a1,1
 372:	22a000ef          	jal	59c <sys_sbrk>
}
 376:	60a2                	ld	ra,8(sp)
 378:	6402                	ld	s0,0(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret

000000000000037e <sbrklazy>:

char *
sbrklazy(int n) {
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 386:	4589                	li	a1,2
 388:	214000ef          	jal	59c <sys_sbrk>
}
 38c:	60a2                	ld	ra,8(sp)
 38e:	6402                	ld	s0,0(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret

0000000000000394 <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 394:	1101                	addi	sp,sp,-32
 396:	ec06                	sd	ra,24(sp)
 398:	e822                	sd	s0,16(sp)
 39a:	e426                	sd	s1,8(sp)
 39c:	e04a                	sd	s2,0(sp)
 39e:	1000                	addi	s0,sp,32
 3a0:	84aa                	mv	s1,a0
 3a2:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 3a4:	6505                	lui	a0,0x1
 3a6:	fc3ff0ef          	jal	368 <sbrk>
 3aa:	6785                	lui	a5,0x1
 3ac:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 3b0:	9a41                	andi	a2,a2,-16
 3b2:	85ca                	mv	a1,s2
 3b4:	8526                	mv	a0,s1
 3b6:	1fe000ef          	jal	5b4 <clone>
}
 3ba:	60e2                	ld	ra,24(sp)
 3bc:	6442                	ld	s0,16(sp)
 3be:	64a2                	ld	s1,8(sp)
 3c0:	6902                	ld	s2,0(sp)
 3c2:	6105                	addi	sp,sp,32
 3c4:	8082                	ret

00000000000003c6 <futex>:

void futex(int *uaddr, int ops, int val) {
 3c6:	7179                	addi	sp,sp,-48
 3c8:	f406                	sd	ra,40(sp)
 3ca:	f022                	sd	s0,32(sp)
 3cc:	ec26                	sd	s1,24(sp)
 3ce:	1800                	addi	s0,sp,48
 3d0:	84aa                	mv	s1,a0
  if (ops==0) {
 3d2:	ed95                	bnez	a1,40e <futex+0x48>
    if (val==0) {
 3d4:	c611                	beqz	a2,3e0 <futex+0x1a>
 3d6:	e84a                	sd	s2,16(sp)
 3d8:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 3da:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 3dc:	4985                	li	s3,1
 3de:	a005                	j	3fe <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 3e0:	4705                	li	a4,1
 3e2:	87ba                	mv	a5,a4
 3e4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 3e8:	2781                	sext.w	a5,a5
 3ea:	ffe5                	bnez	a5,3e2 <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 3ec:	70a2                	ld	ra,40(sp)
 3ee:	7402                	ld	s0,32(sp)
 3f0:	64e2                	ld	s1,24(sp)
 3f2:	6145                	addi	sp,sp,48
 3f4:	8082                	ret
        futex_wait(uaddr, 1);
 3f6:	85ce                	mv	a1,s3
 3f8:	8526                	mv	a0,s1
 3fa:	1ca000ef          	jal	5c4 <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 3fe:	87ca                	mv	a5,s2
 400:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 404:	2781                	sext.w	a5,a5
 406:	fbe5                	bnez	a5,3f6 <futex+0x30>
 408:	6942                	ld	s2,16(sp)
 40a:	69a2                	ld	s3,8(sp)
 40c:	b7c5                	j	3ec <futex+0x26>
    if (val==0) {
 40e:	e611                	bnez	a2,41a <futex+0x54>
      __sync_lock_release(uaddr);
 410:	0310000f          	fence	rw,w
 414:	00052023          	sw	zero,0(a0) # 1000 <__global_pointer$+0x1b9>
 418:	bfd1                	j	3ec <futex+0x26>
      __sync_lock_release(uaddr);
 41a:	0310000f          	fence	rw,w
 41e:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 422:	1aa000ef          	jal	5cc <futex_wake>
  return;
 426:	b7d9                	j	3ec <futex+0x26>

0000000000000428 <sem_init>:

void sem_init(sem_t* s, int val) {
 428:	7179                	addi	sp,sp,-48
 42a:	f406                	sd	ra,40(sp)
 42c:	f022                	sd	s0,32(sp)
 42e:	ec26                	sd	s1,24(sp)
 430:	e84a                	sd	s2,16(sp)
 432:	e44e                	sd	s3,8(sp)
 434:	1800                	addi	s0,sp,48
 436:	84aa                	mv	s1,a0
 438:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 43a:	00450993          	addi	s3,a0,4
 43e:	4605                	li	a2,1
 440:	4581                	li	a1,0
 442:	854e                	mv	a0,s3
 444:	f83ff0ef          	jal	3c6 <futex>
  s->value = val;
 448:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 44c:	4605                	li	a2,1
 44e:	85b2                	mv	a1,a2
 450:	854e                	mv	a0,s3
 452:	f75ff0ef          	jal	3c6 <futex>
  return;
}
 456:	70a2                	ld	ra,40(sp)
 458:	7402                	ld	s0,32(sp)
 45a:	64e2                	ld	s1,24(sp)
 45c:	6942                	ld	s2,16(sp)
 45e:	69a2                	ld	s3,8(sp)
 460:	6145                	addi	sp,sp,48
 462:	8082                	ret

0000000000000464 <sem_down>:

void sem_down(sem_t* s) {
 464:	7179                	addi	sp,sp,-48
 466:	f406                	sd	ra,40(sp)
 468:	f022                	sd	s0,32(sp)
 46a:	ec26                	sd	s1,24(sp)
 46c:	e84a                	sd	s2,16(sp)
 46e:	e44e                	sd	s3,8(sp)
 470:	1800                	addi	s0,sp,48
 472:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 474:	00450993          	addi	s3,a0,4
 478:	4605                	li	a2,1
 47a:	4581                	li	a1,0
 47c:	854e                	mv	a0,s3
 47e:	f49ff0ef          	jal	3c6 <futex>
  while(1) {
    if (s->value>0) {
 482:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 486:	4485                	li	s1,1
    if (s->value>0) {
 488:	02f04463          	bgtz	a5,4b0 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 48c:	8626                	mv	a2,s1
 48e:	85a6                	mv	a1,s1
 490:	854e                	mv	a0,s3
 492:	f35ff0ef          	jal	3c6 <futex>
      futex_wait(&s->value,1);
 496:	85a6                	mv	a1,s1
 498:	854a                	mv	a0,s2
 49a:	12a000ef          	jal	5c4 <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 49e:	8626                	mv	a2,s1
 4a0:	4581                	li	a1,0
 4a2:	854e                	mv	a0,s3
 4a4:	f23ff0ef          	jal	3c6 <futex>
    if (s->value>0) {
 4a8:	00092783          	lw	a5,0(s2)
 4ac:	fef050e3          	blez	a5,48c <sem_down+0x28>
      s->value--;
 4b0:	37fd                	addiw	a5,a5,-1 # fff <__global_pointer$+0x1b8>
 4b2:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4b6:	4605                	li	a2,1
 4b8:	85b2                	mv	a1,a2
 4ba:	854e                	mv	a0,s3
 4bc:	f0bff0ef          	jal	3c6 <futex>
  return;
}
 4c0:	70a2                	ld	ra,40(sp)
 4c2:	7402                	ld	s0,32(sp)
 4c4:	64e2                	ld	s1,24(sp)
 4c6:	6942                	ld	s2,16(sp)
 4c8:	69a2                	ld	s3,8(sp)
 4ca:	6145                	addi	sp,sp,48
 4cc:	8082                	ret

00000000000004ce <sem_up>:

void sem_up(sem_t* s) {
 4ce:	1101                	addi	sp,sp,-32
 4d0:	ec06                	sd	ra,24(sp)
 4d2:	e822                	sd	s0,16(sp)
 4d4:	e426                	sd	s1,8(sp)
 4d6:	e04a                	sd	s2,0(sp)
 4d8:	1000                	addi	s0,sp,32
 4da:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 4dc:	00450913          	addi	s2,a0,4
 4e0:	4605                	li	a2,1
 4e2:	4581                	li	a1,0
 4e4:	854a                	mv	a0,s2
 4e6:	ee1ff0ef          	jal	3c6 <futex>
  s->value++;
 4ea:	409c                	lw	a5,0(s1)
 4ec:	2785                	addiw	a5,a5,1
 4ee:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 4f0:	8526                	mv	a0,s1
 4f2:	0da000ef          	jal	5cc <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4f6:	4605                	li	a2,1
 4f8:	85b2                	mv	a1,a2
 4fa:	854a                	mv	a0,s2
 4fc:	ecbff0ef          	jal	3c6 <futex>
  return;
 500:	60e2                	ld	ra,24(sp)
 502:	6442                	ld	s0,16(sp)
 504:	64a2                	ld	s1,8(sp)
 506:	6902                	ld	s2,0(sp)
 508:	6105                	addi	sp,sp,32
 50a:	8082                	ret

000000000000050c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 50c:	4885                	li	a7,1
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <exit>:
.global exit
exit:
 li a7, SYS_exit
 514:	4889                	li	a7,2
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <wait>:
.global wait
wait:
 li a7, SYS_wait
 51c:	488d                	li	a7,3
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 524:	4891                	li	a7,4
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <read>:
.global read
read:
 li a7, SYS_read
 52c:	4895                	li	a7,5
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <write>:
.global write
write:
 li a7, SYS_write
 534:	48c1                	li	a7,16
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <close>:
.global close
close:
 li a7, SYS_close
 53c:	48d5                	li	a7,21
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <kill>:
.global kill
kill:
 li a7, SYS_kill
 544:	4899                	li	a7,6
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <exec>:
.global exec
exec:
 li a7, SYS_exec
 54c:	489d                	li	a7,7
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <open>:
.global open
open:
 li a7, SYS_open
 554:	48bd                	li	a7,15
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 55c:	48c5                	li	a7,17
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 564:	48c9                	li	a7,18
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 56c:	48a1                	li	a7,8
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <link>:
.global link
link:
 li a7, SYS_link
 574:	48cd                	li	a7,19
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 57c:	48d1                	li	a7,20
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 584:	48a5                	li	a7,9
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <dup>:
.global dup
dup:
 li a7, SYS_dup
 58c:	48a9                	li	a7,10
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 594:	48ad                	li	a7,11
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 59c:	48b1                	li	a7,12
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5a4:	48b5                	li	a7,13
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5ac:	48b9                	li	a7,14
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <clone>:
.global clone
clone:
 li a7, SYS_clone
 5b4:	48d9                	li	a7,22
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <join>:
.global join
join:
 li a7, SYS_join
 5bc:	48dd                	li	a7,23
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 5c4:	48e1                	li	a7,24
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 5cc:	48e5                	li	a7,25
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret
