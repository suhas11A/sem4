
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	44e000ef          	jal	456 <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    pause(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	44c000ef          	jal	45e <exit>
    pause(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	4d6000ef          	jal	4ee <pause>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  26:	fdbff0ef          	jal	0 <main>
  exit(r);
  2a:	434000ef          	jal	45e <exit>

000000000000002e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  2e:	1141                	addi	sp,sp,-16
  30:	e406                	sd	ra,8(sp)
  32:	e022                	sd	s0,0(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0xa>
    ;
  return os;
}
  46:	60a2                	ld	ra,8(sp)
  48:	6402                	ld	s0,0(sp)
  4a:	0141                	addi	sp,sp,16
  4c:	8082                	ret

000000000000004e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  56:	00054783          	lbu	a5,0(a0)
  5a:	cb91                	beqz	a5,6e <strcmp+0x20>
  5c:	0005c703          	lbu	a4,0(a1)
  60:	00f71763          	bne	a4,a5,6e <strcmp+0x20>
    p++, q++;
  64:	0505                	addi	a0,a0,1
  66:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  68:	00054783          	lbu	a5,0(a0)
  6c:	fbe5                	bnez	a5,5c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  6e:	0005c503          	lbu	a0,0(a1)
}
  72:	40a7853b          	subw	a0,a5,a0
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strlen>:

uint
strlen(const char *s)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cf99                	beqz	a5,a8 <strlen+0x2a>
  8c:	0505                	addi	a0,a0,1
  8e:	87aa                	mv	a5,a0
  90:	86be                	mv	a3,a5
  92:	0785                	addi	a5,a5,1
  94:	fff7c703          	lbu	a4,-1(a5)
  98:	ff65                	bnez	a4,90 <strlen+0x12>
  9a:	40a6853b          	subw	a0,a3,a0
  9e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  a0:	60a2                	ld	ra,8(sp)
  a2:	6402                	ld	s0,0(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret
  for(n = 0; s[n]; n++)
  a8:	4501                	li	a0,0
  aa:	bfdd                	j	a0 <strlen+0x22>

00000000000000ac <memset>:

void*
memset(void *dst, int c, uint n)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b4:	ca19                	beqz	a2,ca <memset+0x1e>
  b6:	87aa                	mv	a5,a0
  b8:	1602                	slli	a2,a2,0x20
  ba:	9201                	srli	a2,a2,0x20
  bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c4:	0785                	addi	a5,a5,1
  c6:	fee79de3          	bne	a5,a4,c0 <memset+0x14>
  }
  return dst;
}
  ca:	60a2                	ld	ra,8(sp)
  cc:	6402                	ld	s0,0(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strchr>:

char*
strchr(const char *s, char c)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cf81                	beqz	a5,f6 <strchr+0x24>
    if(*s == c)
  e0:	00f58763          	beq	a1,a5,ee <strchr+0x1c>
  for(; *s; s++)
  e4:	0505                	addi	a0,a0,1
  e6:	00054783          	lbu	a5,0(a0)
  ea:	fbfd                	bnez	a5,e0 <strchr+0xe>
      return (char*)s;
  return 0;
  ec:	4501                	li	a0,0
}
  ee:	60a2                	ld	ra,8(sp)
  f0:	6402                	ld	s0,0(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret
  return 0;
  f6:	4501                	li	a0,0
  f8:	bfdd                	j	ee <strchr+0x1c>

00000000000000fa <gets>:

char*
gets(char *buf, int max)
{
  fa:	7159                	addi	sp,sp,-112
  fc:	f486                	sd	ra,104(sp)
  fe:	f0a2                	sd	s0,96(sp)
 100:	eca6                	sd	s1,88(sp)
 102:	e8ca                	sd	s2,80(sp)
 104:	e4ce                	sd	s3,72(sp)
 106:	e0d2                	sd	s4,64(sp)
 108:	fc56                	sd	s5,56(sp)
 10a:	f85a                	sd	s6,48(sp)
 10c:	f45e                	sd	s7,40(sp)
 10e:	f062                	sd	s8,32(sp)
 110:	ec66                	sd	s9,24(sp)
 112:	e86a                	sd	s10,16(sp)
 114:	1880                	addi	s0,sp,112
 116:	8caa                	mv	s9,a0
 118:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11a:	892a                	mv	s2,a0
 11c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 11e:	f9f40b13          	addi	s6,s0,-97
 122:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 124:	4ba9                	li	s7,10
 126:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 128:	8d26                	mv	s10,s1
 12a:	0014899b          	addiw	s3,s1,1
 12e:	84ce                	mv	s1,s3
 130:	0349d563          	bge	s3,s4,15a <gets+0x60>
    cc = read(0, &c, 1);
 134:	8656                	mv	a2,s5
 136:	85da                	mv	a1,s6
 138:	4501                	li	a0,0
 13a:	33c000ef          	jal	476 <read>
    if(cc < 1)
 13e:	00a05e63          	blez	a0,15a <gets+0x60>
    buf[i++] = c;
 142:	f9f44783          	lbu	a5,-97(s0)
 146:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 14a:	01778763          	beq	a5,s7,158 <gets+0x5e>
 14e:	0905                	addi	s2,s2,1
 150:	fd879ce3          	bne	a5,s8,128 <gets+0x2e>
    buf[i++] = c;
 154:	8d4e                	mv	s10,s3
 156:	a011                	j	15a <gets+0x60>
 158:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 15a:	9d66                	add	s10,s10,s9
 15c:	000d0023          	sb	zero,0(s10)
  return buf;
}
 160:	8566                	mv	a0,s9
 162:	70a6                	ld	ra,104(sp)
 164:	7406                	ld	s0,96(sp)
 166:	64e6                	ld	s1,88(sp)
 168:	6946                	ld	s2,80(sp)
 16a:	69a6                	ld	s3,72(sp)
 16c:	6a06                	ld	s4,64(sp)
 16e:	7ae2                	ld	s5,56(sp)
 170:	7b42                	ld	s6,48(sp)
 172:	7ba2                	ld	s7,40(sp)
 174:	7c02                	ld	s8,32(sp)
 176:	6ce2                	ld	s9,24(sp)
 178:	6d42                	ld	s10,16(sp)
 17a:	6165                	addi	sp,sp,112
 17c:	8082                	ret

000000000000017e <stat>:

int
stat(const char *n, struct stat *st)
{
 17e:	1101                	addi	sp,sp,-32
 180:	ec06                	sd	ra,24(sp)
 182:	e822                	sd	s0,16(sp)
 184:	e04a                	sd	s2,0(sp)
 186:	1000                	addi	s0,sp,32
 188:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18a:	4581                	li	a1,0
 18c:	312000ef          	jal	49e <open>
  if(fd < 0)
 190:	02054263          	bltz	a0,1b4 <stat+0x36>
 194:	e426                	sd	s1,8(sp)
 196:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 198:	85ca                	mv	a1,s2
 19a:	31c000ef          	jal	4b6 <fstat>
 19e:	892a                	mv	s2,a0
  close(fd);
 1a0:	8526                	mv	a0,s1
 1a2:	2e4000ef          	jal	486 <close>
  return r;
 1a6:	64a2                	ld	s1,8(sp)
}
 1a8:	854a                	mv	a0,s2
 1aa:	60e2                	ld	ra,24(sp)
 1ac:	6442                	ld	s0,16(sp)
 1ae:	6902                	ld	s2,0(sp)
 1b0:	6105                	addi	sp,sp,32
 1b2:	8082                	ret
    return -1;
 1b4:	597d                	li	s2,-1
 1b6:	bfcd                	j	1a8 <stat+0x2a>

00000000000001b8 <atoi>:

int
atoi(const char *s)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e406                	sd	ra,8(sp)
 1bc:	e022                	sd	s0,0(sp)
 1be:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c0:	00054683          	lbu	a3,0(a0)
 1c4:	fd06879b          	addiw	a5,a3,-48
 1c8:	0ff7f793          	zext.b	a5,a5
 1cc:	4625                	li	a2,9
 1ce:	02f66963          	bltu	a2,a5,200 <atoi+0x48>
 1d2:	872a                	mv	a4,a0
  n = 0;
 1d4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d6:	0705                	addi	a4,a4,1
 1d8:	0025179b          	slliw	a5,a0,0x2
 1dc:	9fa9                	addw	a5,a5,a0
 1de:	0017979b          	slliw	a5,a5,0x1
 1e2:	9fb5                	addw	a5,a5,a3
 1e4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e8:	00074683          	lbu	a3,0(a4)
 1ec:	fd06879b          	addiw	a5,a3,-48
 1f0:	0ff7f793          	zext.b	a5,a5
 1f4:	fef671e3          	bgeu	a2,a5,1d6 <atoi+0x1e>
  return n;
}
 1f8:	60a2                	ld	ra,8(sp)
 1fa:	6402                	ld	s0,0(sp)
 1fc:	0141                	addi	sp,sp,16
 1fe:	8082                	ret
  n = 0;
 200:	4501                	li	a0,0
 202:	bfdd                	j	1f8 <atoi+0x40>

0000000000000204 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 204:	1141                	addi	sp,sp,-16
 206:	e406                	sd	ra,8(sp)
 208:	e022                	sd	s0,0(sp)
 20a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 20c:	02b57563          	bgeu	a0,a1,236 <memmove+0x32>
    while(n-- > 0)
 210:	00c05f63          	blez	a2,22e <memmove+0x2a>
 214:	1602                	slli	a2,a2,0x20
 216:	9201                	srli	a2,a2,0x20
 218:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 21c:	872a                	mv	a4,a0
      *dst++ = *src++;
 21e:	0585                	addi	a1,a1,1
 220:	0705                	addi	a4,a4,1
 222:	fff5c683          	lbu	a3,-1(a1)
 226:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22a:	fee79ae3          	bne	a5,a4,21e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 22e:	60a2                	ld	ra,8(sp)
 230:	6402                	ld	s0,0(sp)
 232:	0141                	addi	sp,sp,16
 234:	8082                	ret
    dst += n;
 236:	00c50733          	add	a4,a0,a2
    src += n;
 23a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23c:	fec059e3          	blez	a2,22e <memmove+0x2a>
 240:	fff6079b          	addiw	a5,a2,-1
 244:	1782                	slli	a5,a5,0x20
 246:	9381                	srli	a5,a5,0x20
 248:	fff7c793          	not	a5,a5
 24c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 24e:	15fd                	addi	a1,a1,-1
 250:	177d                	addi	a4,a4,-1
 252:	0005c683          	lbu	a3,0(a1)
 256:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25a:	fef71ae3          	bne	a4,a5,24e <memmove+0x4a>
 25e:	bfc1                	j	22e <memmove+0x2a>

0000000000000260 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 260:	1141                	addi	sp,sp,-16
 262:	e406                	sd	ra,8(sp)
 264:	e022                	sd	s0,0(sp)
 266:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 268:	ca0d                	beqz	a2,29a <memcmp+0x3a>
 26a:	fff6069b          	addiw	a3,a2,-1
 26e:	1682                	slli	a3,a3,0x20
 270:	9281                	srli	a3,a3,0x20
 272:	0685                	addi	a3,a3,1
 274:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 276:	00054783          	lbu	a5,0(a0)
 27a:	0005c703          	lbu	a4,0(a1)
 27e:	00e79863          	bne	a5,a4,28e <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 282:	0505                	addi	a0,a0,1
    p2++;
 284:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 286:	fed518e3          	bne	a0,a3,276 <memcmp+0x16>
  }
  return 0;
 28a:	4501                	li	a0,0
 28c:	a019                	j	292 <memcmp+0x32>
      return *p1 - *p2;
 28e:	40e7853b          	subw	a0,a5,a4
}
 292:	60a2                	ld	ra,8(sp)
 294:	6402                	ld	s0,0(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret
  return 0;
 29a:	4501                	li	a0,0
 29c:	bfdd                	j	292 <memcmp+0x32>

000000000000029e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e406                	sd	ra,8(sp)
 2a2:	e022                	sd	s0,0(sp)
 2a4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a6:	f5fff0ef          	jal	204 <memmove>
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <sbrk>:

char *
sbrk(int n) {
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e406                	sd	ra,8(sp)
 2b6:	e022                	sd	s0,0(sp)
 2b8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2ba:	4585                	li	a1,1
 2bc:	22a000ef          	jal	4e6 <sys_sbrk>
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <sbrklazy>:

char *
sbrklazy(int n) {
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2d0:	4589                	li	a1,2
 2d2:	214000ef          	jal	4e6 <sys_sbrk>
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 2de:	1101                	addi	sp,sp,-32
 2e0:	ec06                	sd	ra,24(sp)
 2e2:	e822                	sd	s0,16(sp)
 2e4:	e426                	sd	s1,8(sp)
 2e6:	e04a                	sd	s2,0(sp)
 2e8:	1000                	addi	s0,sp,32
 2ea:	84aa                	mv	s1,a0
 2ec:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 2ee:	6505                	lui	a0,0x1
 2f0:	fc3ff0ef          	jal	2b2 <sbrk>
 2f4:	6785                	lui	a5,0x1
 2f6:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 2fa:	9a41                	andi	a2,a2,-16
 2fc:	85ca                	mv	a1,s2
 2fe:	8526                	mv	a0,s1
 300:	1fe000ef          	jal	4fe <clone>
}
 304:	60e2                	ld	ra,24(sp)
 306:	6442                	ld	s0,16(sp)
 308:	64a2                	ld	s1,8(sp)
 30a:	6902                	ld	s2,0(sp)
 30c:	6105                	addi	sp,sp,32
 30e:	8082                	ret

0000000000000310 <futex>:

void futex(int *uaddr, int ops, int val) {
 310:	7179                	addi	sp,sp,-48
 312:	f406                	sd	ra,40(sp)
 314:	f022                	sd	s0,32(sp)
 316:	ec26                	sd	s1,24(sp)
 318:	1800                	addi	s0,sp,48
 31a:	84aa                	mv	s1,a0
  if (ops==0) {
 31c:	ed95                	bnez	a1,358 <futex+0x48>
    if (val==0) {
 31e:	c611                	beqz	a2,32a <futex+0x1a>
 320:	e84a                	sd	s2,16(sp)
 322:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 324:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 326:	4985                	li	s3,1
 328:	a005                	j	348 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 32a:	4705                	li	a4,1
 32c:	87ba                	mv	a5,a4
 32e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 332:	2781                	sext.w	a5,a5
 334:	ffe5                	bnez	a5,32c <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 336:	70a2                	ld	ra,40(sp)
 338:	7402                	ld	s0,32(sp)
 33a:	64e2                	ld	s1,24(sp)
 33c:	6145                	addi	sp,sp,48
 33e:	8082                	ret
        futex_wait(uaddr, 1);
 340:	85ce                	mv	a1,s3
 342:	8526                	mv	a0,s1
 344:	1ca000ef          	jal	50e <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 348:	87ca                	mv	a5,s2
 34a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 34e:	2781                	sext.w	a5,a5
 350:	fbe5                	bnez	a5,340 <futex+0x30>
 352:	6942                	ld	s2,16(sp)
 354:	69a2                	ld	s3,8(sp)
 356:	b7c5                	j	336 <futex+0x26>
    if (val==0) {
 358:	e611                	bnez	a2,364 <futex+0x54>
      __sync_lock_release(uaddr);
 35a:	0310000f          	fence	rw,w
 35e:	00052023          	sw	zero,0(a0) # 1000 <freep>
 362:	bfd1                	j	336 <futex+0x26>
      __sync_lock_release(uaddr);
 364:	0310000f          	fence	rw,w
 368:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 36c:	1aa000ef          	jal	516 <futex_wake>
  return;
 370:	b7d9                	j	336 <futex+0x26>

0000000000000372 <sem_init>:

void sem_init(sem_t* s, int val) {
 372:	7179                	addi	sp,sp,-48
 374:	f406                	sd	ra,40(sp)
 376:	f022                	sd	s0,32(sp)
 378:	ec26                	sd	s1,24(sp)
 37a:	e84a                	sd	s2,16(sp)
 37c:	e44e                	sd	s3,8(sp)
 37e:	1800                	addi	s0,sp,48
 380:	84aa                	mv	s1,a0
 382:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 384:	00450993          	addi	s3,a0,4
 388:	4605                	li	a2,1
 38a:	4581                	li	a1,0
 38c:	854e                	mv	a0,s3
 38e:	f83ff0ef          	jal	310 <futex>
  s->value = val;
 392:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 396:	4605                	li	a2,1
 398:	85b2                	mv	a1,a2
 39a:	854e                	mv	a0,s3
 39c:	f75ff0ef          	jal	310 <futex>
  return;
}
 3a0:	70a2                	ld	ra,40(sp)
 3a2:	7402                	ld	s0,32(sp)
 3a4:	64e2                	ld	s1,24(sp)
 3a6:	6942                	ld	s2,16(sp)
 3a8:	69a2                	ld	s3,8(sp)
 3aa:	6145                	addi	sp,sp,48
 3ac:	8082                	ret

00000000000003ae <sem_down>:

void sem_down(sem_t* s) {
 3ae:	7179                	addi	sp,sp,-48
 3b0:	f406                	sd	ra,40(sp)
 3b2:	f022                	sd	s0,32(sp)
 3b4:	ec26                	sd	s1,24(sp)
 3b6:	e84a                	sd	s2,16(sp)
 3b8:	e44e                	sd	s3,8(sp)
 3ba:	1800                	addi	s0,sp,48
 3bc:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 3be:	00450993          	addi	s3,a0,4
 3c2:	4605                	li	a2,1
 3c4:	4581                	li	a1,0
 3c6:	854e                	mv	a0,s3
 3c8:	f49ff0ef          	jal	310 <futex>
  while(1) {
    if (s->value>0) {
 3cc:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 3d0:	4485                	li	s1,1
    if (s->value>0) {
 3d2:	02f04463          	bgtz	a5,3fa <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 3d6:	8626                	mv	a2,s1
 3d8:	85a6                	mv	a1,s1
 3da:	854e                	mv	a0,s3
 3dc:	f35ff0ef          	jal	310 <futex>
      futex_wait(&s->value,1);
 3e0:	85a6                	mv	a1,s1
 3e2:	854a                	mv	a0,s2
 3e4:	12a000ef          	jal	50e <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 3e8:	8626                	mv	a2,s1
 3ea:	4581                	li	a1,0
 3ec:	854e                	mv	a0,s3
 3ee:	f23ff0ef          	jal	310 <futex>
    if (s->value>0) {
 3f2:	00092783          	lw	a5,0(s2)
 3f6:	fef050e3          	blez	a5,3d6 <sem_down+0x28>
      s->value--;
 3fa:	37fd                	addiw	a5,a5,-1 # fff <digits+0x5a7>
 3fc:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 400:	4605                	li	a2,1
 402:	85b2                	mv	a1,a2
 404:	854e                	mv	a0,s3
 406:	f0bff0ef          	jal	310 <futex>
  return;
}
 40a:	70a2                	ld	ra,40(sp)
 40c:	7402                	ld	s0,32(sp)
 40e:	64e2                	ld	s1,24(sp)
 410:	6942                	ld	s2,16(sp)
 412:	69a2                	ld	s3,8(sp)
 414:	6145                	addi	sp,sp,48
 416:	8082                	ret

0000000000000418 <sem_up>:

void sem_up(sem_t* s) {
 418:	1101                	addi	sp,sp,-32
 41a:	ec06                	sd	ra,24(sp)
 41c:	e822                	sd	s0,16(sp)
 41e:	e426                	sd	s1,8(sp)
 420:	e04a                	sd	s2,0(sp)
 422:	1000                	addi	s0,sp,32
 424:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 426:	00450913          	addi	s2,a0,4
 42a:	4605                	li	a2,1
 42c:	4581                	li	a1,0
 42e:	854a                	mv	a0,s2
 430:	ee1ff0ef          	jal	310 <futex>
  s->value++;
 434:	409c                	lw	a5,0(s1)
 436:	2785                	addiw	a5,a5,1
 438:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 43a:	8526                	mv	a0,s1
 43c:	0da000ef          	jal	516 <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 440:	4605                	li	a2,1
 442:	85b2                	mv	a1,a2
 444:	854a                	mv	a0,s2
 446:	ecbff0ef          	jal	310 <futex>
  return;
 44a:	60e2                	ld	ra,24(sp)
 44c:	6442                	ld	s0,16(sp)
 44e:	64a2                	ld	s1,8(sp)
 450:	6902                	ld	s2,0(sp)
 452:	6105                	addi	sp,sp,32
 454:	8082                	ret

0000000000000456 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 456:	4885                	li	a7,1
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <exit>:
.global exit
exit:
 li a7, SYS_exit
 45e:	4889                	li	a7,2
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <wait>:
.global wait
wait:
 li a7, SYS_wait
 466:	488d                	li	a7,3
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 46e:	4891                	li	a7,4
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <read>:
.global read
read:
 li a7, SYS_read
 476:	4895                	li	a7,5
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <write>:
.global write
write:
 li a7, SYS_write
 47e:	48c1                	li	a7,16
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <close>:
.global close
close:
 li a7, SYS_close
 486:	48d5                	li	a7,21
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <kill>:
.global kill
kill:
 li a7, SYS_kill
 48e:	4899                	li	a7,6
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <exec>:
.global exec
exec:
 li a7, SYS_exec
 496:	489d                	li	a7,7
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <open>:
.global open
open:
 li a7, SYS_open
 49e:	48bd                	li	a7,15
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4a6:	48c5                	li	a7,17
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4ae:	48c9                	li	a7,18
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4b6:	48a1                	li	a7,8
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <link>:
.global link
link:
 li a7, SYS_link
 4be:	48cd                	li	a7,19
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4c6:	48d1                	li	a7,20
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ce:	48a5                	li	a7,9
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4d6:	48a9                	li	a7,10
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4de:	48ad                	li	a7,11
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4e6:	48b1                	li	a7,12
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <pause>:
.global pause
pause:
 li a7, SYS_pause
 4ee:	48b5                	li	a7,13
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4f6:	48b9                	li	a7,14
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <clone>:
.global clone
clone:
 li a7, SYS_clone
 4fe:	48d9                	li	a7,22
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <join>:
.global join
join:
 li a7, SYS_join
 506:	48dd                	li	a7,23
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 50e:	48e1                	li	a7,24
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 516:	48e5                	li	a7,25
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 51e:	1101                	addi	sp,sp,-32
 520:	ec06                	sd	ra,24(sp)
 522:	e822                	sd	s0,16(sp)
 524:	1000                	addi	s0,sp,32
 526:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 52a:	4605                	li	a2,1
 52c:	fef40593          	addi	a1,s0,-17
 530:	f4fff0ef          	jal	47e <write>
}
 534:	60e2                	ld	ra,24(sp)
 536:	6442                	ld	s0,16(sp)
 538:	6105                	addi	sp,sp,32
 53a:	8082                	ret

000000000000053c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 53c:	715d                	addi	sp,sp,-80
 53e:	e486                	sd	ra,72(sp)
 540:	e0a2                	sd	s0,64(sp)
 542:	fc26                	sd	s1,56(sp)
 544:	f84a                	sd	s2,48(sp)
 546:	f44e                	sd	s3,40(sp)
 548:	0880                	addi	s0,sp,80
 54a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 54c:	c299                	beqz	a3,552 <printint+0x16>
 54e:	0605cc63          	bltz	a1,5c6 <printint+0x8a>
  neg = 0;
 552:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 554:	fb840313          	addi	t1,s0,-72
  neg = 0;
 558:	869a                	mv	a3,t1
  i = 0;
 55a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 55c:	00000817          	auipc	a6,0x0
 560:	4fc80813          	addi	a6,a6,1276 # a58 <digits>
 564:	88be                	mv	a7,a5
 566:	0017851b          	addiw	a0,a5,1
 56a:	87aa                	mv	a5,a0
 56c:	02c5f733          	remu	a4,a1,a2
 570:	9742                	add	a4,a4,a6
 572:	00074703          	lbu	a4,0(a4)
 576:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 57a:	872e                	mv	a4,a1
 57c:	02c5d5b3          	divu	a1,a1,a2
 580:	0685                	addi	a3,a3,1
 582:	fec771e3          	bgeu	a4,a2,564 <printint+0x28>
  if(neg)
 586:	000e0c63          	beqz	t3,59e <printint+0x62>
    buf[i++] = '-';
 58a:	fd050793          	addi	a5,a0,-48
 58e:	00878533          	add	a0,a5,s0
 592:	02d00793          	li	a5,45
 596:	fef50423          	sb	a5,-24(a0)
 59a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 59e:	fff7899b          	addiw	s3,a5,-1
 5a2:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 5a6:	fff4c583          	lbu	a1,-1(s1)
 5aa:	854a                	mv	a0,s2
 5ac:	f73ff0ef          	jal	51e <putc>
  while(--i >= 0)
 5b0:	39fd                	addiw	s3,s3,-1
 5b2:	14fd                	addi	s1,s1,-1
 5b4:	fe09d9e3          	bgez	s3,5a6 <printint+0x6a>
}
 5b8:	60a6                	ld	ra,72(sp)
 5ba:	6406                	ld	s0,64(sp)
 5bc:	74e2                	ld	s1,56(sp)
 5be:	7942                	ld	s2,48(sp)
 5c0:	79a2                	ld	s3,40(sp)
 5c2:	6161                	addi	sp,sp,80
 5c4:	8082                	ret
    x = -xx;
 5c6:	40b005b3          	neg	a1,a1
    neg = 1;
 5ca:	4e05                	li	t3,1
    x = -xx;
 5cc:	b761                	j	554 <printint+0x18>

00000000000005ce <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ce:	711d                	addi	sp,sp,-96
 5d0:	ec86                	sd	ra,88(sp)
 5d2:	e8a2                	sd	s0,80(sp)
 5d4:	e4a6                	sd	s1,72(sp)
 5d6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5d8:	0005c483          	lbu	s1,0(a1)
 5dc:	28048463          	beqz	s1,864 <vprintf+0x296>
 5e0:	e0ca                	sd	s2,64(sp)
 5e2:	fc4e                	sd	s3,56(sp)
 5e4:	f852                	sd	s4,48(sp)
 5e6:	f456                	sd	s5,40(sp)
 5e8:	f05a                	sd	s6,32(sp)
 5ea:	ec5e                	sd	s7,24(sp)
 5ec:	e862                	sd	s8,16(sp)
 5ee:	e466                	sd	s9,8(sp)
 5f0:	8b2a                	mv	s6,a0
 5f2:	8a2e                	mv	s4,a1
 5f4:	8bb2                	mv	s7,a2
  state = 0;
 5f6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5f8:	4901                	li	s2,0
 5fa:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5fc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 600:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 604:	06c00c93          	li	s9,108
 608:	a00d                	j	62a <vprintf+0x5c>
        putc(fd, c0);
 60a:	85a6                	mv	a1,s1
 60c:	855a                	mv	a0,s6
 60e:	f11ff0ef          	jal	51e <putc>
 612:	a019                	j	618 <vprintf+0x4a>
    } else if(state == '%'){
 614:	03598363          	beq	s3,s5,63a <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 618:	0019079b          	addiw	a5,s2,1
 61c:	893e                	mv	s2,a5
 61e:	873e                	mv	a4,a5
 620:	97d2                	add	a5,a5,s4
 622:	0007c483          	lbu	s1,0(a5)
 626:	22048763          	beqz	s1,854 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 62a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 62e:	fe0993e3          	bnez	s3,614 <vprintf+0x46>
      if(c0 == '%'){
 632:	fd579ce3          	bne	a5,s5,60a <vprintf+0x3c>
        state = '%';
 636:	89be                	mv	s3,a5
 638:	b7c5                	j	618 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 63a:	00ea06b3          	add	a3,s4,a4
 63e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 642:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 644:	c681                	beqz	a3,64c <vprintf+0x7e>
 646:	9752                	add	a4,a4,s4
 648:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 64c:	05878263          	beq	a5,s8,690 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 650:	05978c63          	beq	a5,s9,6a8 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 654:	07500713          	li	a4,117
 658:	0ee78663          	beq	a5,a4,744 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 65c:	07800713          	li	a4,120
 660:	12e78863          	beq	a5,a4,790 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 664:	07000713          	li	a4,112
 668:	14e78d63          	beq	a5,a4,7c2 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 66c:	06300713          	li	a4,99
 670:	18e78c63          	beq	a5,a4,808 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 674:	07300713          	li	a4,115
 678:	1ae78263          	beq	a5,a4,81c <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 67c:	02500713          	li	a4,37
 680:	04e79463          	bne	a5,a4,6c8 <vprintf+0xfa>
        putc(fd, '%');
 684:	85ba                	mv	a1,a4
 686:	855a                	mv	a0,s6
 688:	e97ff0ef          	jal	51e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 68c:	4981                	li	s3,0
 68e:	b769                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 690:	008b8493          	addi	s1,s7,8
 694:	4685                	li	a3,1
 696:	4629                	li	a2,10
 698:	000ba583          	lw	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	e9fff0ef          	jal	53c <printint>
 6a2:	8ba6                	mv	s7,s1
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bf8d                	j	618 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6a8:	06400793          	li	a5,100
 6ac:	02f68963          	beq	a3,a5,6de <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6b0:	06c00793          	li	a5,108
 6b4:	04f68263          	beq	a3,a5,6f8 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 6b8:	07500793          	li	a5,117
 6bc:	0af68063          	beq	a3,a5,75c <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 6c0:	07800793          	li	a5,120
 6c4:	0ef68263          	beq	a3,a5,7a8 <vprintf+0x1da>
        putc(fd, '%');
 6c8:	02500593          	li	a1,37
 6cc:	855a                	mv	a0,s6
 6ce:	e51ff0ef          	jal	51e <putc>
        putc(fd, c0);
 6d2:	85a6                	mv	a1,s1
 6d4:	855a                	mv	a0,s6
 6d6:	e49ff0ef          	jal	51e <putc>
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bf35                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6de:	008b8493          	addi	s1,s7,8
 6e2:	4685                	li	a3,1
 6e4:	4629                	li	a2,10
 6e6:	000bb583          	ld	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	e51ff0ef          	jal	53c <printint>
        i += 1;
 6f0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f2:	8ba6                	mv	s7,s1
      state = 0;
 6f4:	4981                	li	s3,0
        i += 1;
 6f6:	b70d                	j	618 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f8:	06400793          	li	a5,100
 6fc:	02f60763          	beq	a2,a5,72a <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 700:	07500793          	li	a5,117
 704:	06f60963          	beq	a2,a5,776 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 708:	07800793          	li	a5,120
 70c:	faf61ee3          	bne	a2,a5,6c8 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 710:	008b8493          	addi	s1,s7,8
 714:	4681                	li	a3,0
 716:	4641                	li	a2,16
 718:	000bb583          	ld	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	e1fff0ef          	jal	53c <printint>
        i += 2;
 722:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 724:	8ba6                	mv	s7,s1
      state = 0;
 726:	4981                	li	s3,0
        i += 2;
 728:	bdc5                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 72a:	008b8493          	addi	s1,s7,8
 72e:	4685                	li	a3,1
 730:	4629                	li	a2,10
 732:	000bb583          	ld	a1,0(s7)
 736:	855a                	mv	a0,s6
 738:	e05ff0ef          	jal	53c <printint>
        i += 2;
 73c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 73e:	8ba6                	mv	s7,s1
      state = 0;
 740:	4981                	li	s3,0
        i += 2;
 742:	bdd9                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 744:	008b8493          	addi	s1,s7,8
 748:	4681                	li	a3,0
 74a:	4629                	li	a2,10
 74c:	000be583          	lwu	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	debff0ef          	jal	53c <printint>
 756:	8ba6                	mv	s7,s1
      state = 0;
 758:	4981                	li	s3,0
 75a:	bd7d                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 75c:	008b8493          	addi	s1,s7,8
 760:	4681                	li	a3,0
 762:	4629                	li	a2,10
 764:	000bb583          	ld	a1,0(s7)
 768:	855a                	mv	a0,s6
 76a:	dd3ff0ef          	jal	53c <printint>
        i += 1;
 76e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 770:	8ba6                	mv	s7,s1
      state = 0;
 772:	4981                	li	s3,0
        i += 1;
 774:	b555                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 776:	008b8493          	addi	s1,s7,8
 77a:	4681                	li	a3,0
 77c:	4629                	li	a2,10
 77e:	000bb583          	ld	a1,0(s7)
 782:	855a                	mv	a0,s6
 784:	db9ff0ef          	jal	53c <printint>
        i += 2;
 788:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 78a:	8ba6                	mv	s7,s1
      state = 0;
 78c:	4981                	li	s3,0
        i += 2;
 78e:	b569                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 790:	008b8493          	addi	s1,s7,8
 794:	4681                	li	a3,0
 796:	4641                	li	a2,16
 798:	000be583          	lwu	a1,0(s7)
 79c:	855a                	mv	a0,s6
 79e:	d9fff0ef          	jal	53c <printint>
 7a2:	8ba6                	mv	s7,s1
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	bd8d                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a8:	008b8493          	addi	s1,s7,8
 7ac:	4681                	li	a3,0
 7ae:	4641                	li	a2,16
 7b0:	000bb583          	ld	a1,0(s7)
 7b4:	855a                	mv	a0,s6
 7b6:	d87ff0ef          	jal	53c <printint>
        i += 1;
 7ba:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7bc:	8ba6                	mv	s7,s1
      state = 0;
 7be:	4981                	li	s3,0
        i += 1;
 7c0:	bda1                	j	618 <vprintf+0x4a>
 7c2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7c4:	008b8d13          	addi	s10,s7,8
 7c8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7cc:	03000593          	li	a1,48
 7d0:	855a                	mv	a0,s6
 7d2:	d4dff0ef          	jal	51e <putc>
  putc(fd, 'x');
 7d6:	07800593          	li	a1,120
 7da:	855a                	mv	a0,s6
 7dc:	d43ff0ef          	jal	51e <putc>
 7e0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e2:	00000b97          	auipc	s7,0x0
 7e6:	276b8b93          	addi	s7,s7,630 # a58 <digits>
 7ea:	03c9d793          	srli	a5,s3,0x3c
 7ee:	97de                	add	a5,a5,s7
 7f0:	0007c583          	lbu	a1,0(a5)
 7f4:	855a                	mv	a0,s6
 7f6:	d29ff0ef          	jal	51e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7fa:	0992                	slli	s3,s3,0x4
 7fc:	34fd                	addiw	s1,s1,-1
 7fe:	f4f5                	bnez	s1,7ea <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 800:	8bea                	mv	s7,s10
      state = 0;
 802:	4981                	li	s3,0
 804:	6d02                	ld	s10,0(sp)
 806:	bd09                	j	618 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 808:	008b8493          	addi	s1,s7,8
 80c:	000bc583          	lbu	a1,0(s7)
 810:	855a                	mv	a0,s6
 812:	d0dff0ef          	jal	51e <putc>
 816:	8ba6                	mv	s7,s1
      state = 0;
 818:	4981                	li	s3,0
 81a:	bbfd                	j	618 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 81c:	008b8993          	addi	s3,s7,8
 820:	000bb483          	ld	s1,0(s7)
 824:	cc91                	beqz	s1,840 <vprintf+0x272>
        for(; *s; s++)
 826:	0004c583          	lbu	a1,0(s1)
 82a:	c195                	beqz	a1,84e <vprintf+0x280>
          putc(fd, *s);
 82c:	855a                	mv	a0,s6
 82e:	cf1ff0ef          	jal	51e <putc>
        for(; *s; s++)
 832:	0485                	addi	s1,s1,1
 834:	0004c583          	lbu	a1,0(s1)
 838:	f9f5                	bnez	a1,82c <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 83a:	8bce                	mv	s7,s3
      state = 0;
 83c:	4981                	li	s3,0
 83e:	bbe9                	j	618 <vprintf+0x4a>
          s = "(null)";
 840:	00000497          	auipc	s1,0x0
 844:	21048493          	addi	s1,s1,528 # a50 <malloc+0x100>
        for(; *s; s++)
 848:	02800593          	li	a1,40
 84c:	b7c5                	j	82c <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 84e:	8bce                	mv	s7,s3
      state = 0;
 850:	4981                	li	s3,0
 852:	b3d9                	j	618 <vprintf+0x4a>
 854:	6906                	ld	s2,64(sp)
 856:	79e2                	ld	s3,56(sp)
 858:	7a42                	ld	s4,48(sp)
 85a:	7aa2                	ld	s5,40(sp)
 85c:	7b02                	ld	s6,32(sp)
 85e:	6be2                	ld	s7,24(sp)
 860:	6c42                	ld	s8,16(sp)
 862:	6ca2                	ld	s9,8(sp)
    }
  }
}
 864:	60e6                	ld	ra,88(sp)
 866:	6446                	ld	s0,80(sp)
 868:	64a6                	ld	s1,72(sp)
 86a:	6125                	addi	sp,sp,96
 86c:	8082                	ret

000000000000086e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 86e:	715d                	addi	sp,sp,-80
 870:	ec06                	sd	ra,24(sp)
 872:	e822                	sd	s0,16(sp)
 874:	1000                	addi	s0,sp,32
 876:	e010                	sd	a2,0(s0)
 878:	e414                	sd	a3,8(s0)
 87a:	e818                	sd	a4,16(s0)
 87c:	ec1c                	sd	a5,24(s0)
 87e:	03043023          	sd	a6,32(s0)
 882:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 886:	8622                	mv	a2,s0
 888:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 88c:	d43ff0ef          	jal	5ce <vprintf>
}
 890:	60e2                	ld	ra,24(sp)
 892:	6442                	ld	s0,16(sp)
 894:	6161                	addi	sp,sp,80
 896:	8082                	ret

0000000000000898 <printf>:

void
printf(const char *fmt, ...)
{
 898:	711d                	addi	sp,sp,-96
 89a:	ec06                	sd	ra,24(sp)
 89c:	e822                	sd	s0,16(sp)
 89e:	1000                	addi	s0,sp,32
 8a0:	e40c                	sd	a1,8(s0)
 8a2:	e810                	sd	a2,16(s0)
 8a4:	ec14                	sd	a3,24(s0)
 8a6:	f018                	sd	a4,32(s0)
 8a8:	f41c                	sd	a5,40(s0)
 8aa:	03043823          	sd	a6,48(s0)
 8ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8b2:	00840613          	addi	a2,s0,8
 8b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8ba:	85aa                	mv	a1,a0
 8bc:	4505                	li	a0,1
 8be:	d11ff0ef          	jal	5ce <vprintf>
}
 8c2:	60e2                	ld	ra,24(sp)
 8c4:	6442                	ld	s0,16(sp)
 8c6:	6125                	addi	sp,sp,96
 8c8:	8082                	ret

00000000000008ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ca:	1141                	addi	sp,sp,-16
 8cc:	e406                	sd	ra,8(sp)
 8ce:	e022                	sd	s0,0(sp)
 8d0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d6:	00000797          	auipc	a5,0x0
 8da:	72a7b783          	ld	a5,1834(a5) # 1000 <freep>
 8de:	a02d                	j	908 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8e0:	4618                	lw	a4,8(a2)
 8e2:	9f2d                	addw	a4,a4,a1
 8e4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e8:	6398                	ld	a4,0(a5)
 8ea:	6310                	ld	a2,0(a4)
 8ec:	a83d                	j	92a <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ee:	ff852703          	lw	a4,-8(a0)
 8f2:	9f31                	addw	a4,a4,a2
 8f4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8f6:	ff053683          	ld	a3,-16(a0)
 8fa:	a091                	j	93e <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fc:	6398                	ld	a4,0(a5)
 8fe:	00e7e463          	bltu	a5,a4,906 <free+0x3c>
 902:	00e6ea63          	bltu	a3,a4,916 <free+0x4c>
{
 906:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 908:	fed7fae3          	bgeu	a5,a3,8fc <free+0x32>
 90c:	6398                	ld	a4,0(a5)
 90e:	00e6e463          	bltu	a3,a4,916 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 912:	fee7eae3          	bltu	a5,a4,906 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 916:	ff852583          	lw	a1,-8(a0)
 91a:	6390                	ld	a2,0(a5)
 91c:	02059813          	slli	a6,a1,0x20
 920:	01c85713          	srli	a4,a6,0x1c
 924:	9736                	add	a4,a4,a3
 926:	fae60de3          	beq	a2,a4,8e0 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 92a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 92e:	4790                	lw	a2,8(a5)
 930:	02061593          	slli	a1,a2,0x20
 934:	01c5d713          	srli	a4,a1,0x1c
 938:	973e                	add	a4,a4,a5
 93a:	fae68ae3          	beq	a3,a4,8ee <free+0x24>
    p->s.ptr = bp->s.ptr;
 93e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 940:	00000717          	auipc	a4,0x0
 944:	6cf73023          	sd	a5,1728(a4) # 1000 <freep>
}
 948:	60a2                	ld	ra,8(sp)
 94a:	6402                	ld	s0,0(sp)
 94c:	0141                	addi	sp,sp,16
 94e:	8082                	ret

0000000000000950 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 950:	7139                	addi	sp,sp,-64
 952:	fc06                	sd	ra,56(sp)
 954:	f822                	sd	s0,48(sp)
 956:	f04a                	sd	s2,32(sp)
 958:	ec4e                	sd	s3,24(sp)
 95a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 95c:	02051993          	slli	s3,a0,0x20
 960:	0209d993          	srli	s3,s3,0x20
 964:	09bd                	addi	s3,s3,15
 966:	0049d993          	srli	s3,s3,0x4
 96a:	2985                	addiw	s3,s3,1
 96c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 96e:	00000517          	auipc	a0,0x0
 972:	69253503          	ld	a0,1682(a0) # 1000 <freep>
 976:	c905                	beqz	a0,9a6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 978:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 97a:	4798                	lw	a4,8(a5)
 97c:	09377663          	bgeu	a4,s3,a08 <malloc+0xb8>
 980:	f426                	sd	s1,40(sp)
 982:	e852                	sd	s4,16(sp)
 984:	e456                	sd	s5,8(sp)
 986:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 988:	8a4e                	mv	s4,s3
 98a:	6705                	lui	a4,0x1
 98c:	00e9f363          	bgeu	s3,a4,992 <malloc+0x42>
 990:	6a05                	lui	s4,0x1
 992:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 996:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 99a:	00000497          	auipc	s1,0x0
 99e:	66648493          	addi	s1,s1,1638 # 1000 <freep>
  if(p == SBRK_ERROR)
 9a2:	5afd                	li	s5,-1
 9a4:	a83d                	j	9e2 <malloc+0x92>
 9a6:	f426                	sd	s1,40(sp)
 9a8:	e852                	sd	s4,16(sp)
 9aa:	e456                	sd	s5,8(sp)
 9ac:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9ae:	00000797          	auipc	a5,0x0
 9b2:	66278793          	addi	a5,a5,1634 # 1010 <base>
 9b6:	00000717          	auipc	a4,0x0
 9ba:	64f73523          	sd	a5,1610(a4) # 1000 <freep>
 9be:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9c0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9c4:	b7d1                	j	988 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9c6:	6398                	ld	a4,0(a5)
 9c8:	e118                	sd	a4,0(a0)
 9ca:	a899                	j	a20 <malloc+0xd0>
  hp->s.size = nu;
 9cc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d0:	0541                	addi	a0,a0,16
 9d2:	ef9ff0ef          	jal	8ca <free>
  return freep;
 9d6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9d8:	c125                	beqz	a0,a38 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9dc:	4798                	lw	a4,8(a5)
 9de:	03277163          	bgeu	a4,s2,a00 <malloc+0xb0>
    if(p == freep)
 9e2:	6098                	ld	a4,0(s1)
 9e4:	853e                	mv	a0,a5
 9e6:	fef71ae3          	bne	a4,a5,9da <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9ea:	8552                	mv	a0,s4
 9ec:	8c7ff0ef          	jal	2b2 <sbrk>
  if(p == SBRK_ERROR)
 9f0:	fd551ee3          	bne	a0,s5,9cc <malloc+0x7c>
        return 0;
 9f4:	4501                	li	a0,0
 9f6:	74a2                	ld	s1,40(sp)
 9f8:	6a42                	ld	s4,16(sp)
 9fa:	6aa2                	ld	s5,8(sp)
 9fc:	6b02                	ld	s6,0(sp)
 9fe:	a03d                	j	a2c <malloc+0xdc>
 a00:	74a2                	ld	s1,40(sp)
 a02:	6a42                	ld	s4,16(sp)
 a04:	6aa2                	ld	s5,8(sp)
 a06:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a08:	fae90fe3          	beq	s2,a4,9c6 <malloc+0x76>
        p->s.size -= nunits;
 a0c:	4137073b          	subw	a4,a4,s3
 a10:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a12:	02071693          	slli	a3,a4,0x20
 a16:	01c6d713          	srli	a4,a3,0x1c
 a1a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a1c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a20:	00000717          	auipc	a4,0x0
 a24:	5ea73023          	sd	a0,1504(a4) # 1000 <freep>
      return (void*)(p + 1);
 a28:	01078513          	addi	a0,a5,16
  }
}
 a2c:	70e2                	ld	ra,56(sp)
 a2e:	7442                	ld	s0,48(sp)
 a30:	7902                	ld	s2,32(sp)
 a32:	69e2                	ld	s3,24(sp)
 a34:	6121                	addi	sp,sp,64
 a36:	8082                	ret
 a38:	74a2                	ld	s1,40(sp)
 a3a:	6a42                	ld	s4,16(sp)
 a3c:	6aa2                	ld	s5,8(sp)
 a3e:	6b02                	ld	s6,0(sp)
 a40:	b7f5                	j	a2c <malloc+0xdc>
