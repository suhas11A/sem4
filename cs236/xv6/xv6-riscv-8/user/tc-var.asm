
user/_tc-var:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <increment>:
#include "kernel/fcntl.h"

int VAR = 0;

void increment(int *thread_rank)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
    int tmp = VAR;
   c:	00001917          	auipc	s2,0x1
  10:	ff490913          	addi	s2,s2,-12 # 1000 <VAR>
  14:	00092483          	lw	s1,0(s2)
    pause(10);
  18:	4529                	li	a0,10
  1a:	410000ef          	jal	42a <pause>
    tmp++;
    pause(10);
  1e:	4529                	li	a0,10
  20:	40a000ef          	jal	42a <pause>
    tmp++;
  24:	2485                	addiw	s1,s1,1
    VAR = tmp;
  26:	00992023          	sw	s1,0(s2)
    exit(0);
  2a:	4501                	li	a0,0
  2c:	36e000ef          	jal	39a <exit>

0000000000000030 <main>:
}

int main(int argc, char *argv[])
{
  30:	7139                	addi	sp,sp,-64
  32:	fc06                	sd	ra,56(sp)
  34:	f822                	sd	s0,48(sp)
  36:	f426                	sd	s1,40(sp)
  38:	f04a                	sd	s2,32(sp)
  3a:	ec4e                	sd	s3,24(sp)
  3c:	0080                	addi	s0,sp,64
    int N = 20;
    printf("Calling Process Print VAR value: %d, N: %d\n", VAR, N);
  3e:	4651                	li	a2,20
  40:	00001597          	auipc	a1,0x1
  44:	fc05a583          	lw	a1,-64(a1) # 1000 <VAR>
  48:	00001517          	auipc	a0,0x1
  4c:	92850513          	addi	a0,a0,-1752 # 970 <malloc+0xf4>
  50:	774000ef          	jal	7c4 <printf>

    for (int i = 0; i < N; i++) {
  54:	fc042623          	sw	zero,-52(s0)
        create_thread(increment, &i);
  58:	fcc40993          	addi	s3,s0,-52
  5c:	00000917          	auipc	s2,0x0
  60:	fa490913          	addi	s2,s2,-92 # 0 <increment>
    for (int i = 0; i < N; i++) {
  64:	44cd                	li	s1,19
        create_thread(increment, &i);
  66:	85ce                	mv	a1,s3
  68:	854a                	mv	a0,s2
  6a:	2f6000ef          	jal	360 <create_thread>
    for (int i = 0; i < N; i++) {
  6e:	fcc42783          	lw	a5,-52(s0)
  72:	2785                	addiw	a5,a5,1
  74:	fcf42623          	sw	a5,-52(s0)
  78:	fef4d7e3          	bge	s1,a5,66 <main+0x36>
    }

    for (int i = 0; i < N; i++) {
  7c:	44d1                	li	s1,20
        join();
  7e:	3c4000ef          	jal	442 <join>
    for (int i = 0; i < N; i++) {
  82:	34fd                	addiw	s1,s1,-1
  84:	fced                	bnez	s1,7e <main+0x4e>
    }

    printf("All threads joined, VAR value: %d\n", VAR);
  86:	00001597          	auipc	a1,0x1
  8a:	f7a5a583          	lw	a1,-134(a1) # 1000 <VAR>
  8e:	00001517          	auipc	a0,0x1
  92:	91250513          	addi	a0,a0,-1774 # 9a0 <malloc+0x124>
  96:	72e000ef          	jal	7c4 <printf>
    exit(0);
  9a:	4501                	li	a0,0
  9c:	2fe000ef          	jal	39a <exit>

00000000000000a0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e406                	sd	ra,8(sp)
  a4:	e022                	sd	s0,0(sp)
  a6:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  a8:	f89ff0ef          	jal	30 <main>
  exit(r);
  ac:	2ee000ef          	jal	39a <exit>

00000000000000b0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e406                	sd	ra,8(sp)
  b4:	e022                	sd	s0,0(sp)
  b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b8:	87aa                	mv	a5,a0
  ba:	0585                	addi	a1,a1,1
  bc:	0785                	addi	a5,a5,1
  be:	fff5c703          	lbu	a4,-1(a1)
  c2:	fee78fa3          	sb	a4,-1(a5)
  c6:	fb75                	bnez	a4,ba <strcpy+0xa>
    ;
  return os;
}
  c8:	60a2                	ld	ra,8(sp)
  ca:	6402                	ld	s0,0(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret

00000000000000d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e406                	sd	ra,8(sp)
  d4:	e022                	sd	s0,0(sp)
  d6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	cb91                	beqz	a5,f0 <strcmp+0x20>
  de:	0005c703          	lbu	a4,0(a1)
  e2:	00f71763          	bne	a4,a5,f0 <strcmp+0x20>
    p++, q++;
  e6:	0505                	addi	a0,a0,1
  e8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbe5                	bnez	a5,de <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  f0:	0005c503          	lbu	a0,0(a1)
}
  f4:	40a7853b          	subw	a0,a5,a0
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strlen>:

uint
strlen(const char *s)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	cf99                	beqz	a5,12a <strlen+0x2a>
 10e:	0505                	addi	a0,a0,1
 110:	87aa                	mv	a5,a0
 112:	86be                	mv	a3,a5
 114:	0785                	addi	a5,a5,1
 116:	fff7c703          	lbu	a4,-1(a5)
 11a:	ff65                	bnez	a4,112 <strlen+0x12>
 11c:	40a6853b          	subw	a0,a3,a0
 120:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 122:	60a2                	ld	ra,8(sp)
 124:	6402                	ld	s0,0(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret
  for(n = 0; s[n]; n++)
 12a:	4501                	li	a0,0
 12c:	bfdd                	j	122 <strlen+0x22>

000000000000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e406                	sd	ra,8(sp)
 132:	e022                	sd	s0,0(sp)
 134:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 136:	ca19                	beqz	a2,14c <memset+0x1e>
 138:	87aa                	mv	a5,a0
 13a:	1602                	slli	a2,a2,0x20
 13c:	9201                	srli	a2,a2,0x20
 13e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 142:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 146:	0785                	addi	a5,a5,1
 148:	fee79de3          	bne	a5,a4,142 <memset+0x14>
  }
  return dst;
}
 14c:	60a2                	ld	ra,8(sp)
 14e:	6402                	ld	s0,0(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <strchr>:

char*
strchr(const char *s, char c)
{
 154:	1141                	addi	sp,sp,-16
 156:	e406                	sd	ra,8(sp)
 158:	e022                	sd	s0,0(sp)
 15a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 15c:	00054783          	lbu	a5,0(a0)
 160:	cf81                	beqz	a5,178 <strchr+0x24>
    if(*s == c)
 162:	00f58763          	beq	a1,a5,170 <strchr+0x1c>
  for(; *s; s++)
 166:	0505                	addi	a0,a0,1
 168:	00054783          	lbu	a5,0(a0)
 16c:	fbfd                	bnez	a5,162 <strchr+0xe>
      return (char*)s;
  return 0;
 16e:	4501                	li	a0,0
}
 170:	60a2                	ld	ra,8(sp)
 172:	6402                	ld	s0,0(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret
  return 0;
 178:	4501                	li	a0,0
 17a:	bfdd                	j	170 <strchr+0x1c>

000000000000017c <gets>:

char*
gets(char *buf, int max)
{
 17c:	7159                	addi	sp,sp,-112
 17e:	f486                	sd	ra,104(sp)
 180:	f0a2                	sd	s0,96(sp)
 182:	eca6                	sd	s1,88(sp)
 184:	e8ca                	sd	s2,80(sp)
 186:	e4ce                	sd	s3,72(sp)
 188:	e0d2                	sd	s4,64(sp)
 18a:	fc56                	sd	s5,56(sp)
 18c:	f85a                	sd	s6,48(sp)
 18e:	f45e                	sd	s7,40(sp)
 190:	f062                	sd	s8,32(sp)
 192:	ec66                	sd	s9,24(sp)
 194:	e86a                	sd	s10,16(sp)
 196:	1880                	addi	s0,sp,112
 198:	8caa                	mv	s9,a0
 19a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19c:	892a                	mv	s2,a0
 19e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1a0:	f9f40b13          	addi	s6,s0,-97
 1a4:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a6:	4ba9                	li	s7,10
 1a8:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1aa:	8d26                	mv	s10,s1
 1ac:	0014899b          	addiw	s3,s1,1
 1b0:	84ce                	mv	s1,s3
 1b2:	0349d563          	bge	s3,s4,1dc <gets+0x60>
    cc = read(0, &c, 1);
 1b6:	8656                	mv	a2,s5
 1b8:	85da                	mv	a1,s6
 1ba:	4501                	li	a0,0
 1bc:	1f6000ef          	jal	3b2 <read>
    if(cc < 1)
 1c0:	00a05e63          	blez	a0,1dc <gets+0x60>
    buf[i++] = c;
 1c4:	f9f44783          	lbu	a5,-97(s0)
 1c8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1cc:	01778763          	beq	a5,s7,1da <gets+0x5e>
 1d0:	0905                	addi	s2,s2,1
 1d2:	fd879ce3          	bne	a5,s8,1aa <gets+0x2e>
    buf[i++] = c;
 1d6:	8d4e                	mv	s10,s3
 1d8:	a011                	j	1dc <gets+0x60>
 1da:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1dc:	9d66                	add	s10,s10,s9
 1de:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1e2:	8566                	mv	a0,s9
 1e4:	70a6                	ld	ra,104(sp)
 1e6:	7406                	ld	s0,96(sp)
 1e8:	64e6                	ld	s1,88(sp)
 1ea:	6946                	ld	s2,80(sp)
 1ec:	69a6                	ld	s3,72(sp)
 1ee:	6a06                	ld	s4,64(sp)
 1f0:	7ae2                	ld	s5,56(sp)
 1f2:	7b42                	ld	s6,48(sp)
 1f4:	7ba2                	ld	s7,40(sp)
 1f6:	7c02                	ld	s8,32(sp)
 1f8:	6ce2                	ld	s9,24(sp)
 1fa:	6d42                	ld	s10,16(sp)
 1fc:	6165                	addi	sp,sp,112
 1fe:	8082                	ret

0000000000000200 <stat>:

int
stat(const char *n, struct stat *st)
{
 200:	1101                	addi	sp,sp,-32
 202:	ec06                	sd	ra,24(sp)
 204:	e822                	sd	s0,16(sp)
 206:	e04a                	sd	s2,0(sp)
 208:	1000                	addi	s0,sp,32
 20a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20c:	4581                	li	a1,0
 20e:	1cc000ef          	jal	3da <open>
  if(fd < 0)
 212:	02054263          	bltz	a0,236 <stat+0x36>
 216:	e426                	sd	s1,8(sp)
 218:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 21a:	85ca                	mv	a1,s2
 21c:	1d6000ef          	jal	3f2 <fstat>
 220:	892a                	mv	s2,a0
  close(fd);
 222:	8526                	mv	a0,s1
 224:	19e000ef          	jal	3c2 <close>
  return r;
 228:	64a2                	ld	s1,8(sp)
}
 22a:	854a                	mv	a0,s2
 22c:	60e2                	ld	ra,24(sp)
 22e:	6442                	ld	s0,16(sp)
 230:	6902                	ld	s2,0(sp)
 232:	6105                	addi	sp,sp,32
 234:	8082                	ret
    return -1;
 236:	597d                	li	s2,-1
 238:	bfcd                	j	22a <stat+0x2a>

000000000000023a <atoi>:

int
atoi(const char *s)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e406                	sd	ra,8(sp)
 23e:	e022                	sd	s0,0(sp)
 240:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 242:	00054683          	lbu	a3,0(a0)
 246:	fd06879b          	addiw	a5,a3,-48
 24a:	0ff7f793          	zext.b	a5,a5
 24e:	4625                	li	a2,9
 250:	02f66963          	bltu	a2,a5,282 <atoi+0x48>
 254:	872a                	mv	a4,a0
  n = 0;
 256:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 258:	0705                	addi	a4,a4,1
 25a:	0025179b          	slliw	a5,a0,0x2
 25e:	9fa9                	addw	a5,a5,a0
 260:	0017979b          	slliw	a5,a5,0x1
 264:	9fb5                	addw	a5,a5,a3
 266:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 26a:	00074683          	lbu	a3,0(a4)
 26e:	fd06879b          	addiw	a5,a3,-48
 272:	0ff7f793          	zext.b	a5,a5
 276:	fef671e3          	bgeu	a2,a5,258 <atoi+0x1e>
  return n;
}
 27a:	60a2                	ld	ra,8(sp)
 27c:	6402                	ld	s0,0(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret
  n = 0;
 282:	4501                	li	a0,0
 284:	bfdd                	j	27a <atoi+0x40>

0000000000000286 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 28e:	02b57563          	bgeu	a0,a1,2b8 <memmove+0x32>
    while(n-- > 0)
 292:	00c05f63          	blez	a2,2b0 <memmove+0x2a>
 296:	1602                	slli	a2,a2,0x20
 298:	9201                	srli	a2,a2,0x20
 29a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 29e:	872a                	mv	a4,a0
      *dst++ = *src++;
 2a0:	0585                	addi	a1,a1,1
 2a2:	0705                	addi	a4,a4,1
 2a4:	fff5c683          	lbu	a3,-1(a1)
 2a8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ac:	fee79ae3          	bne	a5,a4,2a0 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
    dst += n;
 2b8:	00c50733          	add	a4,a0,a2
    src += n;
 2bc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2be:	fec059e3          	blez	a2,2b0 <memmove+0x2a>
 2c2:	fff6079b          	addiw	a5,a2,-1
 2c6:	1782                	slli	a5,a5,0x20
 2c8:	9381                	srli	a5,a5,0x20
 2ca:	fff7c793          	not	a5,a5
 2ce:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2d0:	15fd                	addi	a1,a1,-1
 2d2:	177d                	addi	a4,a4,-1
 2d4:	0005c683          	lbu	a3,0(a1)
 2d8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2dc:	fef71ae3          	bne	a4,a5,2d0 <memmove+0x4a>
 2e0:	bfc1                	j	2b0 <memmove+0x2a>

00000000000002e2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e406                	sd	ra,8(sp)
 2e6:	e022                	sd	s0,0(sp)
 2e8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ea:	ca0d                	beqz	a2,31c <memcmp+0x3a>
 2ec:	fff6069b          	addiw	a3,a2,-1
 2f0:	1682                	slli	a3,a3,0x20
 2f2:	9281                	srli	a3,a3,0x20
 2f4:	0685                	addi	a3,a3,1
 2f6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	0005c703          	lbu	a4,0(a1)
 300:	00e79863          	bne	a5,a4,310 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 304:	0505                	addi	a0,a0,1
    p2++;
 306:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 308:	fed518e3          	bne	a0,a3,2f8 <memcmp+0x16>
  }
  return 0;
 30c:	4501                	li	a0,0
 30e:	a019                	j	314 <memcmp+0x32>
      return *p1 - *p2;
 310:	40e7853b          	subw	a0,a5,a4
}
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret
  return 0;
 31c:	4501                	li	a0,0
 31e:	bfdd                	j	314 <memcmp+0x32>

0000000000000320 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 328:	f5fff0ef          	jal	286 <memmove>
}
 32c:	60a2                	ld	ra,8(sp)
 32e:	6402                	ld	s0,0(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret

0000000000000334 <sbrk>:

char *
sbrk(int n) {
 334:	1141                	addi	sp,sp,-16
 336:	e406                	sd	ra,8(sp)
 338:	e022                	sd	s0,0(sp)
 33a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 33c:	4585                	li	a1,1
 33e:	0e4000ef          	jal	422 <sys_sbrk>
}
 342:	60a2                	ld	ra,8(sp)
 344:	6402                	ld	s0,0(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret

000000000000034a <sbrklazy>:

char *
sbrklazy(int n) {
 34a:	1141                	addi	sp,sp,-16
 34c:	e406                	sd	ra,8(sp)
 34e:	e022                	sd	s0,0(sp)
 350:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 352:	4589                	li	a1,2
 354:	0ce000ef          	jal	422 <sys_sbrk>
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 360:	1101                	addi	sp,sp,-32
 362:	ec06                	sd	ra,24(sp)
 364:	e822                	sd	s0,16(sp)
 366:	e426                	sd	s1,8(sp)
 368:	e04a                	sd	s2,0(sp)
 36a:	1000                	addi	s0,sp,32
 36c:	84aa                	mv	s1,a0
 36e:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 370:	6505                	lui	a0,0x1
 372:	fc3ff0ef          	jal	334 <sbrk>
 376:	6785                	lui	a5,0x1
 378:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 37c:	9a41                	andi	a2,a2,-16
 37e:	85ca                	mv	a1,s2
 380:	8526                	mv	a0,s1
 382:	0b8000ef          	jal	43a <clone>
 386:	60e2                	ld	ra,24(sp)
 388:	6442                	ld	s0,16(sp)
 38a:	64a2                	ld	s1,8(sp)
 38c:	6902                	ld	s2,0(sp)
 38e:	6105                	addi	sp,sp,32
 390:	8082                	ret

0000000000000392 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 392:	4885                	li	a7,1
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <exit>:
.global exit
exit:
 li a7, SYS_exit
 39a:	4889                	li	a7,2
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a2:	488d                	li	a7,3
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3aa:	4891                	li	a7,4
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <read>:
.global read
read:
 li a7, SYS_read
 3b2:	4895                	li	a7,5
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <write>:
.global write
write:
 li a7, SYS_write
 3ba:	48c1                	li	a7,16
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <close>:
.global close
close:
 li a7, SYS_close
 3c2:	48d5                	li	a7,21
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ca:	4899                	li	a7,6
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d2:	489d                	li	a7,7
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <open>:
.global open
open:
 li a7, SYS_open
 3da:	48bd                	li	a7,15
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e2:	48c5                	li	a7,17
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ea:	48c9                	li	a7,18
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f2:	48a1                	li	a7,8
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <link>:
.global link
link:
 li a7, SYS_link
 3fa:	48cd                	li	a7,19
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 402:	48d1                	li	a7,20
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 40a:	48a5                	li	a7,9
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <dup>:
.global dup
dup:
 li a7, SYS_dup
 412:	48a9                	li	a7,10
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 41a:	48ad                	li	a7,11
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 422:	48b1                	li	a7,12
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <pause>:
.global pause
pause:
 li a7, SYS_pause
 42a:	48b5                	li	a7,13
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 432:	48b9                	li	a7,14
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <clone>:
.global clone
clone:
 li a7, SYS_clone
 43a:	48d9                	li	a7,22
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <join>:
.global join
join:
 li a7, SYS_join
 442:	48dd                	li	a7,23
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 44a:	1101                	addi	sp,sp,-32
 44c:	ec06                	sd	ra,24(sp)
 44e:	e822                	sd	s0,16(sp)
 450:	1000                	addi	s0,sp,32
 452:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 456:	4605                	li	a2,1
 458:	fef40593          	addi	a1,s0,-17
 45c:	f5fff0ef          	jal	3ba <write>
}
 460:	60e2                	ld	ra,24(sp)
 462:	6442                	ld	s0,16(sp)
 464:	6105                	addi	sp,sp,32
 466:	8082                	ret

0000000000000468 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 468:	715d                	addi	sp,sp,-80
 46a:	e486                	sd	ra,72(sp)
 46c:	e0a2                	sd	s0,64(sp)
 46e:	fc26                	sd	s1,56(sp)
 470:	f84a                	sd	s2,48(sp)
 472:	f44e                	sd	s3,40(sp)
 474:	0880                	addi	s0,sp,80
 476:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 478:	c299                	beqz	a3,47e <printint+0x16>
 47a:	0605cc63          	bltz	a1,4f2 <printint+0x8a>
  neg = 0;
 47e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 480:	fb840313          	addi	t1,s0,-72
  neg = 0;
 484:	869a                	mv	a3,t1
  i = 0;
 486:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 488:	00000817          	auipc	a6,0x0
 48c:	54880813          	addi	a6,a6,1352 # 9d0 <digits>
 490:	88be                	mv	a7,a5
 492:	0017851b          	addiw	a0,a5,1 # 1001 <VAR+0x1>
 496:	87aa                	mv	a5,a0
 498:	02c5f733          	remu	a4,a1,a2
 49c:	9742                	add	a4,a4,a6
 49e:	00074703          	lbu	a4,0(a4)
 4a2:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4a6:	872e                	mv	a4,a1
 4a8:	02c5d5b3          	divu	a1,a1,a2
 4ac:	0685                	addi	a3,a3,1
 4ae:	fec771e3          	bgeu	a4,a2,490 <printint+0x28>
  if(neg)
 4b2:	000e0c63          	beqz	t3,4ca <printint+0x62>
    buf[i++] = '-';
 4b6:	fd050793          	addi	a5,a0,-48 # fd0 <digits+0x600>
 4ba:	00878533          	add	a0,a5,s0
 4be:	02d00793          	li	a5,45
 4c2:	fef50423          	sb	a5,-24(a0)
 4c6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4ca:	fff7899b          	addiw	s3,a5,-1
 4ce:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4d2:	fff4c583          	lbu	a1,-1(s1)
 4d6:	854a                	mv	a0,s2
 4d8:	f73ff0ef          	jal	44a <putc>
  while(--i >= 0)
 4dc:	39fd                	addiw	s3,s3,-1
 4de:	14fd                	addi	s1,s1,-1
 4e0:	fe09d9e3          	bgez	s3,4d2 <printint+0x6a>
}
 4e4:	60a6                	ld	ra,72(sp)
 4e6:	6406                	ld	s0,64(sp)
 4e8:	74e2                	ld	s1,56(sp)
 4ea:	7942                	ld	s2,48(sp)
 4ec:	79a2                	ld	s3,40(sp)
 4ee:	6161                	addi	sp,sp,80
 4f0:	8082                	ret
    x = -xx;
 4f2:	40b005b3          	neg	a1,a1
    neg = 1;
 4f6:	4e05                	li	t3,1
    x = -xx;
 4f8:	b761                	j	480 <printint+0x18>

00000000000004fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fa:	711d                	addi	sp,sp,-96
 4fc:	ec86                	sd	ra,88(sp)
 4fe:	e8a2                	sd	s0,80(sp)
 500:	e4a6                	sd	s1,72(sp)
 502:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 504:	0005c483          	lbu	s1,0(a1)
 508:	28048463          	beqz	s1,790 <vprintf+0x296>
 50c:	e0ca                	sd	s2,64(sp)
 50e:	fc4e                	sd	s3,56(sp)
 510:	f852                	sd	s4,48(sp)
 512:	f456                	sd	s5,40(sp)
 514:	f05a                	sd	s6,32(sp)
 516:	ec5e                	sd	s7,24(sp)
 518:	e862                	sd	s8,16(sp)
 51a:	e466                	sd	s9,8(sp)
 51c:	8b2a                	mv	s6,a0
 51e:	8a2e                	mv	s4,a1
 520:	8bb2                	mv	s7,a2
  state = 0;
 522:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 524:	4901                	li	s2,0
 526:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 528:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 52c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 530:	06c00c93          	li	s9,108
 534:	a00d                	j	556 <vprintf+0x5c>
        putc(fd, c0);
 536:	85a6                	mv	a1,s1
 538:	855a                	mv	a0,s6
 53a:	f11ff0ef          	jal	44a <putc>
 53e:	a019                	j	544 <vprintf+0x4a>
    } else if(state == '%'){
 540:	03598363          	beq	s3,s5,566 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 544:	0019079b          	addiw	a5,s2,1
 548:	893e                	mv	s2,a5
 54a:	873e                	mv	a4,a5
 54c:	97d2                	add	a5,a5,s4
 54e:	0007c483          	lbu	s1,0(a5)
 552:	22048763          	beqz	s1,780 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 556:	0004879b          	sext.w	a5,s1
    if(state == 0){
 55a:	fe0993e3          	bnez	s3,540 <vprintf+0x46>
      if(c0 == '%'){
 55e:	fd579ce3          	bne	a5,s5,536 <vprintf+0x3c>
        state = '%';
 562:	89be                	mv	s3,a5
 564:	b7c5                	j	544 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 566:	00ea06b3          	add	a3,s4,a4
 56a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 56e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 570:	c681                	beqz	a3,578 <vprintf+0x7e>
 572:	9752                	add	a4,a4,s4
 574:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 578:	05878263          	beq	a5,s8,5bc <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 57c:	05978c63          	beq	a5,s9,5d4 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 580:	07500713          	li	a4,117
 584:	0ee78663          	beq	a5,a4,670 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 588:	07800713          	li	a4,120
 58c:	12e78863          	beq	a5,a4,6bc <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 590:	07000713          	li	a4,112
 594:	14e78d63          	beq	a5,a4,6ee <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 598:	06300713          	li	a4,99
 59c:	18e78c63          	beq	a5,a4,734 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5a0:	07300713          	li	a4,115
 5a4:	1ae78263          	beq	a5,a4,748 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5a8:	02500713          	li	a4,37
 5ac:	04e79463          	bne	a5,a4,5f4 <vprintf+0xfa>
        putc(fd, '%');
 5b0:	85ba                	mv	a1,a4
 5b2:	855a                	mv	a0,s6
 5b4:	e97ff0ef          	jal	44a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b769                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4685                	li	a3,1
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e9fff0ef          	jal	468 <printint>
 5ce:	8ba6                	mv	s7,s1
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bf8d                	j	544 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5d4:	06400793          	li	a5,100
 5d8:	02f68963          	beq	a3,a5,60a <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5dc:	06c00793          	li	a5,108
 5e0:	04f68263          	beq	a3,a5,624 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 5e4:	07500793          	li	a5,117
 5e8:	0af68063          	beq	a3,a5,688 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 5ec:	07800793          	li	a5,120
 5f0:	0ef68263          	beq	a3,a5,6d4 <vprintf+0x1da>
        putc(fd, '%');
 5f4:	02500593          	li	a1,37
 5f8:	855a                	mv	a0,s6
 5fa:	e51ff0ef          	jal	44a <putc>
        putc(fd, c0);
 5fe:	85a6                	mv	a1,s1
 600:	855a                	mv	a0,s6
 602:	e49ff0ef          	jal	44a <putc>
      state = 0;
 606:	4981                	li	s3,0
 608:	bf35                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60a:	008b8493          	addi	s1,s7,8
 60e:	4685                	li	a3,1
 610:	4629                	li	a2,10
 612:	000bb583          	ld	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	e51ff0ef          	jal	468 <printint>
        i += 1;
 61c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 61e:	8ba6                	mv	s7,s1
      state = 0;
 620:	4981                	li	s3,0
        i += 1;
 622:	b70d                	j	544 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 624:	06400793          	li	a5,100
 628:	02f60763          	beq	a2,a5,656 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 62c:	07500793          	li	a5,117
 630:	06f60963          	beq	a2,a5,6a2 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 634:	07800793          	li	a5,120
 638:	faf61ee3          	bne	a2,a5,5f4 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	008b8493          	addi	s1,s7,8
 640:	4681                	li	a3,0
 642:	4641                	li	a2,16
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	e1fff0ef          	jal	468 <printint>
        i += 2;
 64e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 650:	8ba6                	mv	s7,s1
      state = 0;
 652:	4981                	li	s3,0
        i += 2;
 654:	bdc5                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 656:	008b8493          	addi	s1,s7,8
 65a:	4685                	li	a3,1
 65c:	4629                	li	a2,10
 65e:	000bb583          	ld	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	e05ff0ef          	jal	468 <printint>
        i += 2;
 668:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 66a:	8ba6                	mv	s7,s1
      state = 0;
 66c:	4981                	li	s3,0
        i += 2;
 66e:	bdd9                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 670:	008b8493          	addi	s1,s7,8
 674:	4681                	li	a3,0
 676:	4629                	li	a2,10
 678:	000be583          	lwu	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	debff0ef          	jal	468 <printint>
 682:	8ba6                	mv	s7,s1
      state = 0;
 684:	4981                	li	s3,0
 686:	bd7d                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	008b8493          	addi	s1,s7,8
 68c:	4681                	li	a3,0
 68e:	4629                	li	a2,10
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	dd3ff0ef          	jal	468 <printint>
        i += 1;
 69a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 69c:	8ba6                	mv	s7,s1
      state = 0;
 69e:	4981                	li	s3,0
        i += 1;
 6a0:	b555                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a2:	008b8493          	addi	s1,s7,8
 6a6:	4681                	li	a3,0
 6a8:	4629                	li	a2,10
 6aa:	000bb583          	ld	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	db9ff0ef          	jal	468 <printint>
        i += 2;
 6b4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b6:	8ba6                	mv	s7,s1
      state = 0;
 6b8:	4981                	li	s3,0
        i += 2;
 6ba:	b569                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6bc:	008b8493          	addi	s1,s7,8
 6c0:	4681                	li	a3,0
 6c2:	4641                	li	a2,16
 6c4:	000be583          	lwu	a1,0(s7)
 6c8:	855a                	mv	a0,s6
 6ca:	d9fff0ef          	jal	468 <printint>
 6ce:	8ba6                	mv	s7,s1
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bd8d                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d4:	008b8493          	addi	s1,s7,8
 6d8:	4681                	li	a3,0
 6da:	4641                	li	a2,16
 6dc:	000bb583          	ld	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	d87ff0ef          	jal	468 <printint>
        i += 1;
 6e6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e8:	8ba6                	mv	s7,s1
      state = 0;
 6ea:	4981                	li	s3,0
        i += 1;
 6ec:	bda1                	j	544 <vprintf+0x4a>
 6ee:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6f0:	008b8d13          	addi	s10,s7,8
 6f4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6f8:	03000593          	li	a1,48
 6fc:	855a                	mv	a0,s6
 6fe:	d4dff0ef          	jal	44a <putc>
  putc(fd, 'x');
 702:	07800593          	li	a1,120
 706:	855a                	mv	a0,s6
 708:	d43ff0ef          	jal	44a <putc>
 70c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70e:	00000b97          	auipc	s7,0x0
 712:	2c2b8b93          	addi	s7,s7,706 # 9d0 <digits>
 716:	03c9d793          	srli	a5,s3,0x3c
 71a:	97de                	add	a5,a5,s7
 71c:	0007c583          	lbu	a1,0(a5)
 720:	855a                	mv	a0,s6
 722:	d29ff0ef          	jal	44a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 726:	0992                	slli	s3,s3,0x4
 728:	34fd                	addiw	s1,s1,-1
 72a:	f4f5                	bnez	s1,716 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 72c:	8bea                	mv	s7,s10
      state = 0;
 72e:	4981                	li	s3,0
 730:	6d02                	ld	s10,0(sp)
 732:	bd09                	j	544 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 734:	008b8493          	addi	s1,s7,8
 738:	000bc583          	lbu	a1,0(s7)
 73c:	855a                	mv	a0,s6
 73e:	d0dff0ef          	jal	44a <putc>
 742:	8ba6                	mv	s7,s1
      state = 0;
 744:	4981                	li	s3,0
 746:	bbfd                	j	544 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 748:	008b8993          	addi	s3,s7,8
 74c:	000bb483          	ld	s1,0(s7)
 750:	cc91                	beqz	s1,76c <vprintf+0x272>
        for(; *s; s++)
 752:	0004c583          	lbu	a1,0(s1)
 756:	c195                	beqz	a1,77a <vprintf+0x280>
          putc(fd, *s);
 758:	855a                	mv	a0,s6
 75a:	cf1ff0ef          	jal	44a <putc>
        for(; *s; s++)
 75e:	0485                	addi	s1,s1,1
 760:	0004c583          	lbu	a1,0(s1)
 764:	f9f5                	bnez	a1,758 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 766:	8bce                	mv	s7,s3
      state = 0;
 768:	4981                	li	s3,0
 76a:	bbe9                	j	544 <vprintf+0x4a>
          s = "(null)";
 76c:	00000497          	auipc	s1,0x0
 770:	25c48493          	addi	s1,s1,604 # 9c8 <malloc+0x14c>
        for(; *s; s++)
 774:	02800593          	li	a1,40
 778:	b7c5                	j	758 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 77a:	8bce                	mv	s7,s3
      state = 0;
 77c:	4981                	li	s3,0
 77e:	b3d9                	j	544 <vprintf+0x4a>
 780:	6906                	ld	s2,64(sp)
 782:	79e2                	ld	s3,56(sp)
 784:	7a42                	ld	s4,48(sp)
 786:	7aa2                	ld	s5,40(sp)
 788:	7b02                	ld	s6,32(sp)
 78a:	6be2                	ld	s7,24(sp)
 78c:	6c42                	ld	s8,16(sp)
 78e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 790:	60e6                	ld	ra,88(sp)
 792:	6446                	ld	s0,80(sp)
 794:	64a6                	ld	s1,72(sp)
 796:	6125                	addi	sp,sp,96
 798:	8082                	ret

000000000000079a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 79a:	715d                	addi	sp,sp,-80
 79c:	ec06                	sd	ra,24(sp)
 79e:	e822                	sd	s0,16(sp)
 7a0:	1000                	addi	s0,sp,32
 7a2:	e010                	sd	a2,0(s0)
 7a4:	e414                	sd	a3,8(s0)
 7a6:	e818                	sd	a4,16(s0)
 7a8:	ec1c                	sd	a5,24(s0)
 7aa:	03043023          	sd	a6,32(s0)
 7ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b2:	8622                	mv	a2,s0
 7b4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b8:	d43ff0ef          	jal	4fa <vprintf>
}
 7bc:	60e2                	ld	ra,24(sp)
 7be:	6442                	ld	s0,16(sp)
 7c0:	6161                	addi	sp,sp,80
 7c2:	8082                	ret

00000000000007c4 <printf>:

void
printf(const char *fmt, ...)
{
 7c4:	711d                	addi	sp,sp,-96
 7c6:	ec06                	sd	ra,24(sp)
 7c8:	e822                	sd	s0,16(sp)
 7ca:	1000                	addi	s0,sp,32
 7cc:	e40c                	sd	a1,8(s0)
 7ce:	e810                	sd	a2,16(s0)
 7d0:	ec14                	sd	a3,24(s0)
 7d2:	f018                	sd	a4,32(s0)
 7d4:	f41c                	sd	a5,40(s0)
 7d6:	03043823          	sd	a6,48(s0)
 7da:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7de:	00840613          	addi	a2,s0,8
 7e2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7e6:	85aa                	mv	a1,a0
 7e8:	4505                	li	a0,1
 7ea:	d11ff0ef          	jal	4fa <vprintf>
}
 7ee:	60e2                	ld	ra,24(sp)
 7f0:	6442                	ld	s0,16(sp)
 7f2:	6125                	addi	sp,sp,96
 7f4:	8082                	ret

00000000000007f6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f6:	1141                	addi	sp,sp,-16
 7f8:	e406                	sd	ra,8(sp)
 7fa:	e022                	sd	s0,0(sp)
 7fc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7fe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 802:	00001797          	auipc	a5,0x1
 806:	8067b783          	ld	a5,-2042(a5) # 1008 <freep>
 80a:	a02d                	j	834 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 80c:	4618                	lw	a4,8(a2)
 80e:	9f2d                	addw	a4,a4,a1
 810:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 814:	6398                	ld	a4,0(a5)
 816:	6310                	ld	a2,0(a4)
 818:	a83d                	j	856 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 81a:	ff852703          	lw	a4,-8(a0)
 81e:	9f31                	addw	a4,a4,a2
 820:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 822:	ff053683          	ld	a3,-16(a0)
 826:	a091                	j	86a <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	6398                	ld	a4,0(a5)
 82a:	00e7e463          	bltu	a5,a4,832 <free+0x3c>
 82e:	00e6ea63          	bltu	a3,a4,842 <free+0x4c>
{
 832:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 834:	fed7fae3          	bgeu	a5,a3,828 <free+0x32>
 838:	6398                	ld	a4,0(a5)
 83a:	00e6e463          	bltu	a3,a4,842 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83e:	fee7eae3          	bltu	a5,a4,832 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 842:	ff852583          	lw	a1,-8(a0)
 846:	6390                	ld	a2,0(a5)
 848:	02059813          	slli	a6,a1,0x20
 84c:	01c85713          	srli	a4,a6,0x1c
 850:	9736                	add	a4,a4,a3
 852:	fae60de3          	beq	a2,a4,80c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 856:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 85a:	4790                	lw	a2,8(a5)
 85c:	02061593          	slli	a1,a2,0x20
 860:	01c5d713          	srli	a4,a1,0x1c
 864:	973e                	add	a4,a4,a5
 866:	fae68ae3          	beq	a3,a4,81a <free+0x24>
    p->s.ptr = bp->s.ptr;
 86a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 86c:	00000717          	auipc	a4,0x0
 870:	78f73e23          	sd	a5,1948(a4) # 1008 <freep>
}
 874:	60a2                	ld	ra,8(sp)
 876:	6402                	ld	s0,0(sp)
 878:	0141                	addi	sp,sp,16
 87a:	8082                	ret

000000000000087c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 87c:	7139                	addi	sp,sp,-64
 87e:	fc06                	sd	ra,56(sp)
 880:	f822                	sd	s0,48(sp)
 882:	f04a                	sd	s2,32(sp)
 884:	ec4e                	sd	s3,24(sp)
 886:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 888:	02051993          	slli	s3,a0,0x20
 88c:	0209d993          	srli	s3,s3,0x20
 890:	09bd                	addi	s3,s3,15
 892:	0049d993          	srli	s3,s3,0x4
 896:	2985                	addiw	s3,s3,1
 898:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 89a:	00000517          	auipc	a0,0x0
 89e:	76e53503          	ld	a0,1902(a0) # 1008 <freep>
 8a2:	c905                	beqz	a0,8d2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a6:	4798                	lw	a4,8(a5)
 8a8:	09377663          	bgeu	a4,s3,934 <malloc+0xb8>
 8ac:	f426                	sd	s1,40(sp)
 8ae:	e852                	sd	s4,16(sp)
 8b0:	e456                	sd	s5,8(sp)
 8b2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8b4:	8a4e                	mv	s4,s3
 8b6:	6705                	lui	a4,0x1
 8b8:	00e9f363          	bgeu	s3,a4,8be <malloc+0x42>
 8bc:	6a05                	lui	s4,0x1
 8be:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c6:	00000497          	auipc	s1,0x0
 8ca:	74248493          	addi	s1,s1,1858 # 1008 <freep>
  if(p == SBRK_ERROR)
 8ce:	5afd                	li	s5,-1
 8d0:	a83d                	j	90e <malloc+0x92>
 8d2:	f426                	sd	s1,40(sp)
 8d4:	e852                	sd	s4,16(sp)
 8d6:	e456                	sd	s5,8(sp)
 8d8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8da:	00000797          	auipc	a5,0x0
 8de:	73678793          	addi	a5,a5,1846 # 1010 <base>
 8e2:	00000717          	auipc	a4,0x0
 8e6:	72f73323          	sd	a5,1830(a4) # 1008 <freep>
 8ea:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ec:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8f0:	b7d1                	j	8b4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8f2:	6398                	ld	a4,0(a5)
 8f4:	e118                	sd	a4,0(a0)
 8f6:	a899                	j	94c <malloc+0xd0>
  hp->s.size = nu;
 8f8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8fc:	0541                	addi	a0,a0,16
 8fe:	ef9ff0ef          	jal	7f6 <free>
  return freep;
 902:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 904:	c125                	beqz	a0,964 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 906:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 908:	4798                	lw	a4,8(a5)
 90a:	03277163          	bgeu	a4,s2,92c <malloc+0xb0>
    if(p == freep)
 90e:	6098                	ld	a4,0(s1)
 910:	853e                	mv	a0,a5
 912:	fef71ae3          	bne	a4,a5,906 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 916:	8552                	mv	a0,s4
 918:	a1dff0ef          	jal	334 <sbrk>
  if(p == SBRK_ERROR)
 91c:	fd551ee3          	bne	a0,s5,8f8 <malloc+0x7c>
        return 0;
 920:	4501                	li	a0,0
 922:	74a2                	ld	s1,40(sp)
 924:	6a42                	ld	s4,16(sp)
 926:	6aa2                	ld	s5,8(sp)
 928:	6b02                	ld	s6,0(sp)
 92a:	a03d                	j	958 <malloc+0xdc>
 92c:	74a2                	ld	s1,40(sp)
 92e:	6a42                	ld	s4,16(sp)
 930:	6aa2                	ld	s5,8(sp)
 932:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 934:	fae90fe3          	beq	s2,a4,8f2 <malloc+0x76>
        p->s.size -= nunits;
 938:	4137073b          	subw	a4,a4,s3
 93c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 93e:	02071693          	slli	a3,a4,0x20
 942:	01c6d713          	srli	a4,a3,0x1c
 946:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 948:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 94c:	00000717          	auipc	a4,0x0
 950:	6aa73e23          	sd	a0,1724(a4) # 1008 <freep>
      return (void*)(p + 1);
 954:	01078513          	addi	a0,a5,16
  }
}
 958:	70e2                	ld	ra,56(sp)
 95a:	7442                	ld	s0,48(sp)
 95c:	7902                	ld	s2,32(sp)
 95e:	69e2                	ld	s3,24(sp)
 960:	6121                	addi	sp,sp,64
 962:	8082                	ret
 964:	74a2                	ld	s1,40(sp)
 966:	6a42                	ld	s4,16(sp)
 968:	6aa2                	ld	s5,8(sp)
 96a:	6b02                	ld	s6,0(sp)
 96c:	b7f5                	j	958 <malloc+0xdc>
