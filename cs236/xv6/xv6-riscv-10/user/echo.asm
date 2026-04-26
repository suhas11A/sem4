
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  14:	4785                	li	a5,1
  16:	06a7d063          	bge	a5,a0,76 <main+0x76>
  1a:	00858493          	addi	s1,a1,8
  1e:	3579                	addiw	a0,a0,-2
  20:	02051793          	slli	a5,a0,0x20
  24:	01d7d513          	srli	a0,a5,0x1d
  28:	00a48ab3          	add	s5,s1,a0
  2c:	05c1                	addi	a1,a1,16
  2e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
  32:	4985                	li	s3,1
    if(i + 1 < argc){
      write(1, " ", 1);
  34:	00001b17          	auipc	s6,0x1
  38:	a6cb0b13          	addi	s6,s6,-1428 # aa0 <malloc+0xf2>
  3c:	a809                	j	4e <main+0x4e>
  3e:	864e                	mv	a2,s3
  40:	85da                	mv	a1,s6
  42:	854e                	mv	a0,s3
  44:	498000ef          	jal	4dc <write>
  for(i = 1; i < argc; i++){
  48:	04a1                	addi	s1,s1,8
  4a:	03448663          	beq	s1,s4,76 <main+0x76>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	088000ef          	jal	dc <strlen>
  58:	862a                	mv	a2,a0
  5a:	85ca                	mv	a1,s2
  5c:	854e                	mv	a0,s3
  5e:	47e000ef          	jal	4dc <write>
    if(i + 1 < argc){
  62:	fd549ee3          	bne	s1,s5,3e <main+0x3e>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	a4058593          	addi	a1,a1,-1472 # aa8 <malloc+0xfa>
  70:	8532                	mv	a0,a2
  72:	46a000ef          	jal	4dc <write>
    }
  }
  exit(0);
  76:	4501                	li	a0,0
  78:	444000ef          	jal	4bc <exit>

000000000000007c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e406                	sd	ra,8(sp)
  80:	e022                	sd	s0,0(sp)
  82:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  84:	f7dff0ef          	jal	0 <main>
  exit(r);
  88:	434000ef          	jal	4bc <exit>

000000000000008c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  94:	87aa                	mv	a5,a0
  96:	0585                	addi	a1,a1,1
  98:	0785                	addi	a5,a5,1
  9a:	fff5c703          	lbu	a4,-1(a1)
  9e:	fee78fa3          	sb	a4,-1(a5)
  a2:	fb75                	bnez	a4,96 <strcpy+0xa>
    ;
  return os;
}
  a4:	60a2                	ld	ra,8(sp)
  a6:	6402                	ld	s0,0(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cb91                	beqz	a5,cc <strcmp+0x20>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71763          	bne	a4,a5,cc <strcmp+0x20>
    p++, q++;
  c2:	0505                	addi	a0,a0,1
  c4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbe5                	bnez	a5,ba <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  cc:	0005c503          	lbu	a0,0(a1)
}
  d0:	40a7853b          	subw	a0,a5,a0
  d4:	60a2                	ld	ra,8(sp)
  d6:	6402                	ld	s0,0(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <strlen>:

uint
strlen(const char *s)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	cf99                	beqz	a5,106 <strlen+0x2a>
  ea:	0505                	addi	a0,a0,1
  ec:	87aa                	mv	a5,a0
  ee:	86be                	mv	a3,a5
  f0:	0785                	addi	a5,a5,1
  f2:	fff7c703          	lbu	a4,-1(a5)
  f6:	ff65                	bnez	a4,ee <strlen+0x12>
  f8:	40a6853b          	subw	a0,a3,a0
  fc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  fe:	60a2                	ld	ra,8(sp)
 100:	6402                	ld	s0,0(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret
  for(n = 0; s[n]; n++)
 106:	4501                	li	a0,0
 108:	bfdd                	j	fe <strlen+0x22>

000000000000010a <memset>:

void*
memset(void *dst, int c, uint n)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e406                	sd	ra,8(sp)
 10e:	e022                	sd	s0,0(sp)
 110:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 112:	ca19                	beqz	a2,128 <memset+0x1e>
 114:	87aa                	mv	a5,a0
 116:	1602                	slli	a2,a2,0x20
 118:	9201                	srli	a2,a2,0x20
 11a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 122:	0785                	addi	a5,a5,1
 124:	fee79de3          	bne	a5,a4,11e <memset+0x14>
  }
  return dst;
}
 128:	60a2                	ld	ra,8(sp)
 12a:	6402                	ld	s0,0(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	1141                	addi	sp,sp,-16
 132:	e406                	sd	ra,8(sp)
 134:	e022                	sd	s0,0(sp)
 136:	0800                	addi	s0,sp,16
  for(; *s; s++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf81                	beqz	a5,154 <strchr+0x24>
    if(*s == c)
 13e:	00f58763          	beq	a1,a5,14c <strchr+0x1c>
  for(; *s; s++)
 142:	0505                	addi	a0,a0,1
 144:	00054783          	lbu	a5,0(a0)
 148:	fbfd                	bnez	a5,13e <strchr+0xe>
      return (char*)s;
  return 0;
 14a:	4501                	li	a0,0
}
 14c:	60a2                	ld	ra,8(sp)
 14e:	6402                	ld	s0,0(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret
  return 0;
 154:	4501                	li	a0,0
 156:	bfdd                	j	14c <strchr+0x1c>

0000000000000158 <gets>:

char*
gets(char *buf, int max)
{
 158:	7159                	addi	sp,sp,-112
 15a:	f486                	sd	ra,104(sp)
 15c:	f0a2                	sd	s0,96(sp)
 15e:	eca6                	sd	s1,88(sp)
 160:	e8ca                	sd	s2,80(sp)
 162:	e4ce                	sd	s3,72(sp)
 164:	e0d2                	sd	s4,64(sp)
 166:	fc56                	sd	s5,56(sp)
 168:	f85a                	sd	s6,48(sp)
 16a:	f45e                	sd	s7,40(sp)
 16c:	f062                	sd	s8,32(sp)
 16e:	ec66                	sd	s9,24(sp)
 170:	e86a                	sd	s10,16(sp)
 172:	1880                	addi	s0,sp,112
 174:	8caa                	mv	s9,a0
 176:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 178:	892a                	mv	s2,a0
 17a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 17c:	f9f40b13          	addi	s6,s0,-97
 180:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 182:	4ba9                	li	s7,10
 184:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 186:	8d26                	mv	s10,s1
 188:	0014899b          	addiw	s3,s1,1
 18c:	84ce                	mv	s1,s3
 18e:	0349d563          	bge	s3,s4,1b8 <gets+0x60>
    cc = read(0, &c, 1);
 192:	8656                	mv	a2,s5
 194:	85da                	mv	a1,s6
 196:	4501                	li	a0,0
 198:	33c000ef          	jal	4d4 <read>
    if(cc < 1)
 19c:	00a05e63          	blez	a0,1b8 <gets+0x60>
    buf[i++] = c;
 1a0:	f9f44783          	lbu	a5,-97(s0)
 1a4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a8:	01778763          	beq	a5,s7,1b6 <gets+0x5e>
 1ac:	0905                	addi	s2,s2,1
 1ae:	fd879ce3          	bne	a5,s8,186 <gets+0x2e>
    buf[i++] = c;
 1b2:	8d4e                	mv	s10,s3
 1b4:	a011                	j	1b8 <gets+0x60>
 1b6:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1b8:	9d66                	add	s10,s10,s9
 1ba:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1be:	8566                	mv	a0,s9
 1c0:	70a6                	ld	ra,104(sp)
 1c2:	7406                	ld	s0,96(sp)
 1c4:	64e6                	ld	s1,88(sp)
 1c6:	6946                	ld	s2,80(sp)
 1c8:	69a6                	ld	s3,72(sp)
 1ca:	6a06                	ld	s4,64(sp)
 1cc:	7ae2                	ld	s5,56(sp)
 1ce:	7b42                	ld	s6,48(sp)
 1d0:	7ba2                	ld	s7,40(sp)
 1d2:	7c02                	ld	s8,32(sp)
 1d4:	6ce2                	ld	s9,24(sp)
 1d6:	6d42                	ld	s10,16(sp)
 1d8:	6165                	addi	sp,sp,112
 1da:	8082                	ret

00000000000001dc <stat>:

int
stat(const char *n, struct stat *st)
{
 1dc:	1101                	addi	sp,sp,-32
 1de:	ec06                	sd	ra,24(sp)
 1e0:	e822                	sd	s0,16(sp)
 1e2:	e04a                	sd	s2,0(sp)
 1e4:	1000                	addi	s0,sp,32
 1e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e8:	4581                	li	a1,0
 1ea:	312000ef          	jal	4fc <open>
  if(fd < 0)
 1ee:	02054263          	bltz	a0,212 <stat+0x36>
 1f2:	e426                	sd	s1,8(sp)
 1f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f6:	85ca                	mv	a1,s2
 1f8:	31c000ef          	jal	514 <fstat>
 1fc:	892a                	mv	s2,a0
  close(fd);
 1fe:	8526                	mv	a0,s1
 200:	2e4000ef          	jal	4e4 <close>
  return r;
 204:	64a2                	ld	s1,8(sp)
}
 206:	854a                	mv	a0,s2
 208:	60e2                	ld	ra,24(sp)
 20a:	6442                	ld	s0,16(sp)
 20c:	6902                	ld	s2,0(sp)
 20e:	6105                	addi	sp,sp,32
 210:	8082                	ret
    return -1;
 212:	597d                	li	s2,-1
 214:	bfcd                	j	206 <stat+0x2a>

0000000000000216 <atoi>:

int
atoi(const char *s)
{
 216:	1141                	addi	sp,sp,-16
 218:	e406                	sd	ra,8(sp)
 21a:	e022                	sd	s0,0(sp)
 21c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21e:	00054683          	lbu	a3,0(a0)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	4625                	li	a2,9
 22c:	02f66963          	bltu	a2,a5,25e <atoi+0x48>
 230:	872a                	mv	a4,a0
  n = 0;
 232:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 234:	0705                	addi	a4,a4,1
 236:	0025179b          	slliw	a5,a0,0x2
 23a:	9fa9                	addw	a5,a5,a0
 23c:	0017979b          	slliw	a5,a5,0x1
 240:	9fb5                	addw	a5,a5,a3
 242:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 246:	00074683          	lbu	a3,0(a4)
 24a:	fd06879b          	addiw	a5,a3,-48
 24e:	0ff7f793          	zext.b	a5,a5
 252:	fef671e3          	bgeu	a2,a5,234 <atoi+0x1e>
  return n;
}
 256:	60a2                	ld	ra,8(sp)
 258:	6402                	ld	s0,0(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  n = 0;
 25e:	4501                	li	a0,0
 260:	bfdd                	j	256 <atoi+0x40>

0000000000000262 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e406                	sd	ra,8(sp)
 266:	e022                	sd	s0,0(sp)
 268:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 26a:	02b57563          	bgeu	a0,a1,294 <memmove+0x32>
    while(n-- > 0)
 26e:	00c05f63          	blez	a2,28c <memmove+0x2a>
 272:	1602                	slli	a2,a2,0x20
 274:	9201                	srli	a2,a2,0x20
 276:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 27a:	872a                	mv	a4,a0
      *dst++ = *src++;
 27c:	0585                	addi	a1,a1,1
 27e:	0705                	addi	a4,a4,1
 280:	fff5c683          	lbu	a3,-1(a1)
 284:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 288:	fee79ae3          	bne	a5,a4,27c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
    dst += n;
 294:	00c50733          	add	a4,a0,a2
    src += n;
 298:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 29a:	fec059e3          	blez	a2,28c <memmove+0x2a>
 29e:	fff6079b          	addiw	a5,a2,-1
 2a2:	1782                	slli	a5,a5,0x20
 2a4:	9381                	srli	a5,a5,0x20
 2a6:	fff7c793          	not	a5,a5
 2aa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ac:	15fd                	addi	a1,a1,-1
 2ae:	177d                	addi	a4,a4,-1
 2b0:	0005c683          	lbu	a3,0(a1)
 2b4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b8:	fef71ae3          	bne	a4,a5,2ac <memmove+0x4a>
 2bc:	bfc1                	j	28c <memmove+0x2a>

00000000000002be <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e406                	sd	ra,8(sp)
 2c2:	e022                	sd	s0,0(sp)
 2c4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c6:	ca0d                	beqz	a2,2f8 <memcmp+0x3a>
 2c8:	fff6069b          	addiw	a3,a2,-1
 2cc:	1682                	slli	a3,a3,0x20
 2ce:	9281                	srli	a3,a3,0x20
 2d0:	0685                	addi	a3,a3,1
 2d2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	0005c703          	lbu	a4,0(a1)
 2dc:	00e79863          	bne	a5,a4,2ec <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2e0:	0505                	addi	a0,a0,1
    p2++;
 2e2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e4:	fed518e3          	bne	a0,a3,2d4 <memcmp+0x16>
  }
  return 0;
 2e8:	4501                	li	a0,0
 2ea:	a019                	j	2f0 <memcmp+0x32>
      return *p1 - *p2;
 2ec:	40e7853b          	subw	a0,a5,a4
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret
  return 0;
 2f8:	4501                	li	a0,0
 2fa:	bfdd                	j	2f0 <memcmp+0x32>

00000000000002fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e406                	sd	ra,8(sp)
 300:	e022                	sd	s0,0(sp)
 302:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 304:	f5fff0ef          	jal	262 <memmove>
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <sbrk>:

char *
sbrk(int n) {
 310:	1141                	addi	sp,sp,-16
 312:	e406                	sd	ra,8(sp)
 314:	e022                	sd	s0,0(sp)
 316:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 318:	4585                	li	a1,1
 31a:	22a000ef          	jal	544 <sys_sbrk>
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret

0000000000000326 <sbrklazy>:

char *
sbrklazy(int n) {
 326:	1141                	addi	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 32e:	4589                	li	a1,2
 330:	214000ef          	jal	544 <sys_sbrk>
}
 334:	60a2                	ld	ra,8(sp)
 336:	6402                	ld	s0,0(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret

000000000000033c <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 33c:	1101                	addi	sp,sp,-32
 33e:	ec06                	sd	ra,24(sp)
 340:	e822                	sd	s0,16(sp)
 342:	e426                	sd	s1,8(sp)
 344:	e04a                	sd	s2,0(sp)
 346:	1000                	addi	s0,sp,32
 348:	84aa                	mv	s1,a0
 34a:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 34c:	6505                	lui	a0,0x1
 34e:	fc3ff0ef          	jal	310 <sbrk>
 352:	6785                	lui	a5,0x1
 354:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 358:	9a41                	andi	a2,a2,-16
 35a:	85ca                	mv	a1,s2
 35c:	8526                	mv	a0,s1
 35e:	1fe000ef          	jal	55c <clone>
}
 362:	60e2                	ld	ra,24(sp)
 364:	6442                	ld	s0,16(sp)
 366:	64a2                	ld	s1,8(sp)
 368:	6902                	ld	s2,0(sp)
 36a:	6105                	addi	sp,sp,32
 36c:	8082                	ret

000000000000036e <futex>:

void futex(int *uaddr, int ops, int val) {
 36e:	7179                	addi	sp,sp,-48
 370:	f406                	sd	ra,40(sp)
 372:	f022                	sd	s0,32(sp)
 374:	ec26                	sd	s1,24(sp)
 376:	1800                	addi	s0,sp,48
 378:	84aa                	mv	s1,a0
  if (ops==0) {
 37a:	ed95                	bnez	a1,3b6 <futex+0x48>
    if (val==0) {
 37c:	c611                	beqz	a2,388 <futex+0x1a>
 37e:	e84a                	sd	s2,16(sp)
 380:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 382:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 384:	4985                	li	s3,1
 386:	a005                	j	3a6 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 388:	4705                	li	a4,1
 38a:	87ba                	mv	a5,a4
 38c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 390:	2781                	sext.w	a5,a5
 392:	ffe5                	bnez	a5,38a <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 394:	70a2                	ld	ra,40(sp)
 396:	7402                	ld	s0,32(sp)
 398:	64e2                	ld	s1,24(sp)
 39a:	6145                	addi	sp,sp,48
 39c:	8082                	ret
        futex_wait(uaddr, 1);
 39e:	85ce                	mv	a1,s3
 3a0:	8526                	mv	a0,s1
 3a2:	1ca000ef          	jal	56c <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 3a6:	87ca                	mv	a5,s2
 3a8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 3ac:	2781                	sext.w	a5,a5
 3ae:	fbe5                	bnez	a5,39e <futex+0x30>
 3b0:	6942                	ld	s2,16(sp)
 3b2:	69a2                	ld	s3,8(sp)
 3b4:	b7c5                	j	394 <futex+0x26>
    if (val==0) {
 3b6:	e611                	bnez	a2,3c2 <futex+0x54>
      __sync_lock_release(uaddr);
 3b8:	0310000f          	fence	rw,w
 3bc:	00052023          	sw	zero,0(a0) # 1000 <freep>
 3c0:	bfd1                	j	394 <futex+0x26>
      __sync_lock_release(uaddr);
 3c2:	0310000f          	fence	rw,w
 3c6:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 3ca:	1aa000ef          	jal	574 <futex_wake>
  return;
 3ce:	b7d9                	j	394 <futex+0x26>

00000000000003d0 <sem_init>:

void sem_init(sem_t* s, int val) {
 3d0:	7179                	addi	sp,sp,-48
 3d2:	f406                	sd	ra,40(sp)
 3d4:	f022                	sd	s0,32(sp)
 3d6:	ec26                	sd	s1,24(sp)
 3d8:	e84a                	sd	s2,16(sp)
 3da:	e44e                	sd	s3,8(sp)
 3dc:	1800                	addi	s0,sp,48
 3de:	84aa                	mv	s1,a0
 3e0:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 3e2:	00450993          	addi	s3,a0,4
 3e6:	4605                	li	a2,1
 3e8:	4581                	li	a1,0
 3ea:	854e                	mv	a0,s3
 3ec:	f83ff0ef          	jal	36e <futex>
  s->value = val;
 3f0:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 3f4:	4605                	li	a2,1
 3f6:	85b2                	mv	a1,a2
 3f8:	854e                	mv	a0,s3
 3fa:	f75ff0ef          	jal	36e <futex>
  return;
}
 3fe:	70a2                	ld	ra,40(sp)
 400:	7402                	ld	s0,32(sp)
 402:	64e2                	ld	s1,24(sp)
 404:	6942                	ld	s2,16(sp)
 406:	69a2                	ld	s3,8(sp)
 408:	6145                	addi	sp,sp,48
 40a:	8082                	ret

000000000000040c <sem_down>:

void sem_down(sem_t* s) {
 40c:	7179                	addi	sp,sp,-48
 40e:	f406                	sd	ra,40(sp)
 410:	f022                	sd	s0,32(sp)
 412:	ec26                	sd	s1,24(sp)
 414:	e84a                	sd	s2,16(sp)
 416:	e44e                	sd	s3,8(sp)
 418:	1800                	addi	s0,sp,48
 41a:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 41c:	00450993          	addi	s3,a0,4
 420:	4605                	li	a2,1
 422:	4581                	li	a1,0
 424:	854e                	mv	a0,s3
 426:	f49ff0ef          	jal	36e <futex>
  while(1) {
    if (s->value>0) {
 42a:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 42e:	4485                	li	s1,1
    if (s->value>0) {
 430:	02f04463          	bgtz	a5,458 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 434:	8626                	mv	a2,s1
 436:	85a6                	mv	a1,s1
 438:	854e                	mv	a0,s3
 43a:	f35ff0ef          	jal	36e <futex>
      futex_wait(&s->value,1);
 43e:	85a6                	mv	a1,s1
 440:	854a                	mv	a0,s2
 442:	12a000ef          	jal	56c <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 446:	8626                	mv	a2,s1
 448:	4581                	li	a1,0
 44a:	854e                	mv	a0,s3
 44c:	f23ff0ef          	jal	36e <futex>
    if (s->value>0) {
 450:	00092783          	lw	a5,0(s2)
 454:	fef050e3          	blez	a5,434 <sem_down+0x28>
      s->value--;
 458:	37fd                	addiw	a5,a5,-1 # fff <digits+0x547>
 45a:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 45e:	4605                	li	a2,1
 460:	85b2                	mv	a1,a2
 462:	854e                	mv	a0,s3
 464:	f0bff0ef          	jal	36e <futex>
  return;
}
 468:	70a2                	ld	ra,40(sp)
 46a:	7402                	ld	s0,32(sp)
 46c:	64e2                	ld	s1,24(sp)
 46e:	6942                	ld	s2,16(sp)
 470:	69a2                	ld	s3,8(sp)
 472:	6145                	addi	sp,sp,48
 474:	8082                	ret

0000000000000476 <sem_up>:

void sem_up(sem_t* s) {
 476:	1101                	addi	sp,sp,-32
 478:	ec06                	sd	ra,24(sp)
 47a:	e822                	sd	s0,16(sp)
 47c:	e426                	sd	s1,8(sp)
 47e:	e04a                	sd	s2,0(sp)
 480:	1000                	addi	s0,sp,32
 482:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 484:	00450913          	addi	s2,a0,4
 488:	4605                	li	a2,1
 48a:	4581                	li	a1,0
 48c:	854a                	mv	a0,s2
 48e:	ee1ff0ef          	jal	36e <futex>
  s->value++;
 492:	409c                	lw	a5,0(s1)
 494:	2785                	addiw	a5,a5,1
 496:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 498:	8526                	mv	a0,s1
 49a:	0da000ef          	jal	574 <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 49e:	4605                	li	a2,1
 4a0:	85b2                	mv	a1,a2
 4a2:	854a                	mv	a0,s2
 4a4:	ecbff0ef          	jal	36e <futex>
  return;
 4a8:	60e2                	ld	ra,24(sp)
 4aa:	6442                	ld	s0,16(sp)
 4ac:	64a2                	ld	s1,8(sp)
 4ae:	6902                	ld	s2,0(sp)
 4b0:	6105                	addi	sp,sp,32
 4b2:	8082                	ret

00000000000004b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4b4:	4885                	li	a7,1
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 4bc:	4889                	li	a7,2
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c4:	488d                	li	a7,3
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4cc:	4891                	li	a7,4
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <read>:
.global read
read:
 li a7, SYS_read
 4d4:	4895                	li	a7,5
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <write>:
.global write
write:
 li a7, SYS_write
 4dc:	48c1                	li	a7,16
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <close>:
.global close
close:
 li a7, SYS_close
 4e4:	48d5                	li	a7,21
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ec:	4899                	li	a7,6
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4f4:	489d                	li	a7,7
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <open>:
.global open
open:
 li a7, SYS_open
 4fc:	48bd                	li	a7,15
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 504:	48c5                	li	a7,17
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 50c:	48c9                	li	a7,18
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 514:	48a1                	li	a7,8
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <link>:
.global link
link:
 li a7, SYS_link
 51c:	48cd                	li	a7,19
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 524:	48d1                	li	a7,20
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 52c:	48a5                	li	a7,9
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <dup>:
.global dup
dup:
 li a7, SYS_dup
 534:	48a9                	li	a7,10
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 53c:	48ad                	li	a7,11
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 544:	48b1                	li	a7,12
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <pause>:
.global pause
pause:
 li a7, SYS_pause
 54c:	48b5                	li	a7,13
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 554:	48b9                	li	a7,14
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <clone>:
.global clone
clone:
 li a7, SYS_clone
 55c:	48d9                	li	a7,22
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <join>:
.global join
join:
 li a7, SYS_join
 564:	48dd                	li	a7,23
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 56c:	48e1                	li	a7,24
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 574:	48e5                	li	a7,25
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 57c:	1101                	addi	sp,sp,-32
 57e:	ec06                	sd	ra,24(sp)
 580:	e822                	sd	s0,16(sp)
 582:	1000                	addi	s0,sp,32
 584:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 588:	4605                	li	a2,1
 58a:	fef40593          	addi	a1,s0,-17
 58e:	f4fff0ef          	jal	4dc <write>
}
 592:	60e2                	ld	ra,24(sp)
 594:	6442                	ld	s0,16(sp)
 596:	6105                	addi	sp,sp,32
 598:	8082                	ret

000000000000059a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 59a:	715d                	addi	sp,sp,-80
 59c:	e486                	sd	ra,72(sp)
 59e:	e0a2                	sd	s0,64(sp)
 5a0:	fc26                	sd	s1,56(sp)
 5a2:	f84a                	sd	s2,48(sp)
 5a4:	f44e                	sd	s3,40(sp)
 5a6:	0880                	addi	s0,sp,80
 5a8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5aa:	c299                	beqz	a3,5b0 <printint+0x16>
 5ac:	0605cc63          	bltz	a1,624 <printint+0x8a>
  neg = 0;
 5b0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5b2:	fb840313          	addi	t1,s0,-72
  neg = 0;
 5b6:	869a                	mv	a3,t1
  i = 0;
 5b8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5ba:	00000817          	auipc	a6,0x0
 5be:	4fe80813          	addi	a6,a6,1278 # ab8 <digits>
 5c2:	88be                	mv	a7,a5
 5c4:	0017851b          	addiw	a0,a5,1
 5c8:	87aa                	mv	a5,a0
 5ca:	02c5f733          	remu	a4,a1,a2
 5ce:	9742                	add	a4,a4,a6
 5d0:	00074703          	lbu	a4,0(a4)
 5d4:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5d8:	872e                	mv	a4,a1
 5da:	02c5d5b3          	divu	a1,a1,a2
 5de:	0685                	addi	a3,a3,1
 5e0:	fec771e3          	bgeu	a4,a2,5c2 <printint+0x28>
  if(neg)
 5e4:	000e0c63          	beqz	t3,5fc <printint+0x62>
    buf[i++] = '-';
 5e8:	fd050793          	addi	a5,a0,-48
 5ec:	00878533          	add	a0,a5,s0
 5f0:	02d00793          	li	a5,45
 5f4:	fef50423          	sb	a5,-24(a0)
 5f8:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 5fc:	fff7899b          	addiw	s3,a5,-1
 600:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 604:	fff4c583          	lbu	a1,-1(s1)
 608:	854a                	mv	a0,s2
 60a:	f73ff0ef          	jal	57c <putc>
  while(--i >= 0)
 60e:	39fd                	addiw	s3,s3,-1
 610:	14fd                	addi	s1,s1,-1
 612:	fe09d9e3          	bgez	s3,604 <printint+0x6a>
}
 616:	60a6                	ld	ra,72(sp)
 618:	6406                	ld	s0,64(sp)
 61a:	74e2                	ld	s1,56(sp)
 61c:	7942                	ld	s2,48(sp)
 61e:	79a2                	ld	s3,40(sp)
 620:	6161                	addi	sp,sp,80
 622:	8082                	ret
    x = -xx;
 624:	40b005b3          	neg	a1,a1
    neg = 1;
 628:	4e05                	li	t3,1
    x = -xx;
 62a:	b761                	j	5b2 <printint+0x18>

000000000000062c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 62c:	711d                	addi	sp,sp,-96
 62e:	ec86                	sd	ra,88(sp)
 630:	e8a2                	sd	s0,80(sp)
 632:	e4a6                	sd	s1,72(sp)
 634:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 636:	0005c483          	lbu	s1,0(a1)
 63a:	28048463          	beqz	s1,8c2 <vprintf+0x296>
 63e:	e0ca                	sd	s2,64(sp)
 640:	fc4e                	sd	s3,56(sp)
 642:	f852                	sd	s4,48(sp)
 644:	f456                	sd	s5,40(sp)
 646:	f05a                	sd	s6,32(sp)
 648:	ec5e                	sd	s7,24(sp)
 64a:	e862                	sd	s8,16(sp)
 64c:	e466                	sd	s9,8(sp)
 64e:	8b2a                	mv	s6,a0
 650:	8a2e                	mv	s4,a1
 652:	8bb2                	mv	s7,a2
  state = 0;
 654:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 656:	4901                	li	s2,0
 658:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 65a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 65e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 662:	06c00c93          	li	s9,108
 666:	a00d                	j	688 <vprintf+0x5c>
        putc(fd, c0);
 668:	85a6                	mv	a1,s1
 66a:	855a                	mv	a0,s6
 66c:	f11ff0ef          	jal	57c <putc>
 670:	a019                	j	676 <vprintf+0x4a>
    } else if(state == '%'){
 672:	03598363          	beq	s3,s5,698 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 676:	0019079b          	addiw	a5,s2,1
 67a:	893e                	mv	s2,a5
 67c:	873e                	mv	a4,a5
 67e:	97d2                	add	a5,a5,s4
 680:	0007c483          	lbu	s1,0(a5)
 684:	22048763          	beqz	s1,8b2 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 688:	0004879b          	sext.w	a5,s1
    if(state == 0){
 68c:	fe0993e3          	bnez	s3,672 <vprintf+0x46>
      if(c0 == '%'){
 690:	fd579ce3          	bne	a5,s5,668 <vprintf+0x3c>
        state = '%';
 694:	89be                	mv	s3,a5
 696:	b7c5                	j	676 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 698:	00ea06b3          	add	a3,s4,a4
 69c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6a0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6a2:	c681                	beqz	a3,6aa <vprintf+0x7e>
 6a4:	9752                	add	a4,a4,s4
 6a6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6aa:	05878263          	beq	a5,s8,6ee <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6ae:	05978c63          	beq	a5,s9,706 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6b2:	07500713          	li	a4,117
 6b6:	0ee78663          	beq	a5,a4,7a2 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6ba:	07800713          	li	a4,120
 6be:	12e78863          	beq	a5,a4,7ee <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6c2:	07000713          	li	a4,112
 6c6:	14e78d63          	beq	a5,a4,820 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 6ca:	06300713          	li	a4,99
 6ce:	18e78c63          	beq	a5,a4,866 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 6d2:	07300713          	li	a4,115
 6d6:	1ae78263          	beq	a5,a4,87a <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6da:	02500713          	li	a4,37
 6de:	04e79463          	bne	a5,a4,726 <vprintf+0xfa>
        putc(fd, '%');
 6e2:	85ba                	mv	a1,a4
 6e4:	855a                	mv	a0,s6
 6e6:	e97ff0ef          	jal	57c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	b769                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6ee:	008b8493          	addi	s1,s7,8
 6f2:	4685                	li	a3,1
 6f4:	4629                	li	a2,10
 6f6:	000ba583          	lw	a1,0(s7)
 6fa:	855a                	mv	a0,s6
 6fc:	e9fff0ef          	jal	59a <printint>
 700:	8ba6                	mv	s7,s1
      state = 0;
 702:	4981                	li	s3,0
 704:	bf8d                	j	676 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 706:	06400793          	li	a5,100
 70a:	02f68963          	beq	a3,a5,73c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 70e:	06c00793          	li	a5,108
 712:	04f68263          	beq	a3,a5,756 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 716:	07500793          	li	a5,117
 71a:	0af68063          	beq	a3,a5,7ba <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 71e:	07800793          	li	a5,120
 722:	0ef68263          	beq	a3,a5,806 <vprintf+0x1da>
        putc(fd, '%');
 726:	02500593          	li	a1,37
 72a:	855a                	mv	a0,s6
 72c:	e51ff0ef          	jal	57c <putc>
        putc(fd, c0);
 730:	85a6                	mv	a1,s1
 732:	855a                	mv	a0,s6
 734:	e49ff0ef          	jal	57c <putc>
      state = 0;
 738:	4981                	li	s3,0
 73a:	bf35                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 73c:	008b8493          	addi	s1,s7,8
 740:	4685                	li	a3,1
 742:	4629                	li	a2,10
 744:	000bb583          	ld	a1,0(s7)
 748:	855a                	mv	a0,s6
 74a:	e51ff0ef          	jal	59a <printint>
        i += 1;
 74e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 750:	8ba6                	mv	s7,s1
      state = 0;
 752:	4981                	li	s3,0
        i += 1;
 754:	b70d                	j	676 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 756:	06400793          	li	a5,100
 75a:	02f60763          	beq	a2,a5,788 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 75e:	07500793          	li	a5,117
 762:	06f60963          	beq	a2,a5,7d4 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 766:	07800793          	li	a5,120
 76a:	faf61ee3          	bne	a2,a5,726 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 76e:	008b8493          	addi	s1,s7,8
 772:	4681                	li	a3,0
 774:	4641                	li	a2,16
 776:	000bb583          	ld	a1,0(s7)
 77a:	855a                	mv	a0,s6
 77c:	e1fff0ef          	jal	59a <printint>
        i += 2;
 780:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 782:	8ba6                	mv	s7,s1
      state = 0;
 784:	4981                	li	s3,0
        i += 2;
 786:	bdc5                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 788:	008b8493          	addi	s1,s7,8
 78c:	4685                	li	a3,1
 78e:	4629                	li	a2,10
 790:	000bb583          	ld	a1,0(s7)
 794:	855a                	mv	a0,s6
 796:	e05ff0ef          	jal	59a <printint>
        i += 2;
 79a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 79c:	8ba6                	mv	s7,s1
      state = 0;
 79e:	4981                	li	s3,0
        i += 2;
 7a0:	bdd9                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7a2:	008b8493          	addi	s1,s7,8
 7a6:	4681                	li	a3,0
 7a8:	4629                	li	a2,10
 7aa:	000be583          	lwu	a1,0(s7)
 7ae:	855a                	mv	a0,s6
 7b0:	debff0ef          	jal	59a <printint>
 7b4:	8ba6                	mv	s7,s1
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	bd7d                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ba:	008b8493          	addi	s1,s7,8
 7be:	4681                	li	a3,0
 7c0:	4629                	li	a2,10
 7c2:	000bb583          	ld	a1,0(s7)
 7c6:	855a                	mv	a0,s6
 7c8:	dd3ff0ef          	jal	59a <printint>
        i += 1;
 7cc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ce:	8ba6                	mv	s7,s1
      state = 0;
 7d0:	4981                	li	s3,0
        i += 1;
 7d2:	b555                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d4:	008b8493          	addi	s1,s7,8
 7d8:	4681                	li	a3,0
 7da:	4629                	li	a2,10
 7dc:	000bb583          	ld	a1,0(s7)
 7e0:	855a                	mv	a0,s6
 7e2:	db9ff0ef          	jal	59a <printint>
        i += 2;
 7e6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e8:	8ba6                	mv	s7,s1
      state = 0;
 7ea:	4981                	li	s3,0
        i += 2;
 7ec:	b569                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7ee:	008b8493          	addi	s1,s7,8
 7f2:	4681                	li	a3,0
 7f4:	4641                	li	a2,16
 7f6:	000be583          	lwu	a1,0(s7)
 7fa:	855a                	mv	a0,s6
 7fc:	d9fff0ef          	jal	59a <printint>
 800:	8ba6                	mv	s7,s1
      state = 0;
 802:	4981                	li	s3,0
 804:	bd8d                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 806:	008b8493          	addi	s1,s7,8
 80a:	4681                	li	a3,0
 80c:	4641                	li	a2,16
 80e:	000bb583          	ld	a1,0(s7)
 812:	855a                	mv	a0,s6
 814:	d87ff0ef          	jal	59a <printint>
        i += 1;
 818:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 81a:	8ba6                	mv	s7,s1
      state = 0;
 81c:	4981                	li	s3,0
        i += 1;
 81e:	bda1                	j	676 <vprintf+0x4a>
 820:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 822:	008b8d13          	addi	s10,s7,8
 826:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 82a:	03000593          	li	a1,48
 82e:	855a                	mv	a0,s6
 830:	d4dff0ef          	jal	57c <putc>
  putc(fd, 'x');
 834:	07800593          	li	a1,120
 838:	855a                	mv	a0,s6
 83a:	d43ff0ef          	jal	57c <putc>
 83e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 840:	00000b97          	auipc	s7,0x0
 844:	278b8b93          	addi	s7,s7,632 # ab8 <digits>
 848:	03c9d793          	srli	a5,s3,0x3c
 84c:	97de                	add	a5,a5,s7
 84e:	0007c583          	lbu	a1,0(a5)
 852:	855a                	mv	a0,s6
 854:	d29ff0ef          	jal	57c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 858:	0992                	slli	s3,s3,0x4
 85a:	34fd                	addiw	s1,s1,-1
 85c:	f4f5                	bnez	s1,848 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 85e:	8bea                	mv	s7,s10
      state = 0;
 860:	4981                	li	s3,0
 862:	6d02                	ld	s10,0(sp)
 864:	bd09                	j	676 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 866:	008b8493          	addi	s1,s7,8
 86a:	000bc583          	lbu	a1,0(s7)
 86e:	855a                	mv	a0,s6
 870:	d0dff0ef          	jal	57c <putc>
 874:	8ba6                	mv	s7,s1
      state = 0;
 876:	4981                	li	s3,0
 878:	bbfd                	j	676 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 87a:	008b8993          	addi	s3,s7,8
 87e:	000bb483          	ld	s1,0(s7)
 882:	cc91                	beqz	s1,89e <vprintf+0x272>
        for(; *s; s++)
 884:	0004c583          	lbu	a1,0(s1)
 888:	c195                	beqz	a1,8ac <vprintf+0x280>
          putc(fd, *s);
 88a:	855a                	mv	a0,s6
 88c:	cf1ff0ef          	jal	57c <putc>
        for(; *s; s++)
 890:	0485                	addi	s1,s1,1
 892:	0004c583          	lbu	a1,0(s1)
 896:	f9f5                	bnez	a1,88a <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 898:	8bce                	mv	s7,s3
      state = 0;
 89a:	4981                	li	s3,0
 89c:	bbe9                	j	676 <vprintf+0x4a>
          s = "(null)";
 89e:	00000497          	auipc	s1,0x0
 8a2:	21248493          	addi	s1,s1,530 # ab0 <malloc+0x102>
        for(; *s; s++)
 8a6:	02800593          	li	a1,40
 8aa:	b7c5                	j	88a <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 8ac:	8bce                	mv	s7,s3
      state = 0;
 8ae:	4981                	li	s3,0
 8b0:	b3d9                	j	676 <vprintf+0x4a>
 8b2:	6906                	ld	s2,64(sp)
 8b4:	79e2                	ld	s3,56(sp)
 8b6:	7a42                	ld	s4,48(sp)
 8b8:	7aa2                	ld	s5,40(sp)
 8ba:	7b02                	ld	s6,32(sp)
 8bc:	6be2                	ld	s7,24(sp)
 8be:	6c42                	ld	s8,16(sp)
 8c0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8c2:	60e6                	ld	ra,88(sp)
 8c4:	6446                	ld	s0,80(sp)
 8c6:	64a6                	ld	s1,72(sp)
 8c8:	6125                	addi	sp,sp,96
 8ca:	8082                	ret

00000000000008cc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8cc:	715d                	addi	sp,sp,-80
 8ce:	ec06                	sd	ra,24(sp)
 8d0:	e822                	sd	s0,16(sp)
 8d2:	1000                	addi	s0,sp,32
 8d4:	e010                	sd	a2,0(s0)
 8d6:	e414                	sd	a3,8(s0)
 8d8:	e818                	sd	a4,16(s0)
 8da:	ec1c                	sd	a5,24(s0)
 8dc:	03043023          	sd	a6,32(s0)
 8e0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8e4:	8622                	mv	a2,s0
 8e6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8ea:	d43ff0ef          	jal	62c <vprintf>
}
 8ee:	60e2                	ld	ra,24(sp)
 8f0:	6442                	ld	s0,16(sp)
 8f2:	6161                	addi	sp,sp,80
 8f4:	8082                	ret

00000000000008f6 <printf>:

void
printf(const char *fmt, ...)
{
 8f6:	711d                	addi	sp,sp,-96
 8f8:	ec06                	sd	ra,24(sp)
 8fa:	e822                	sd	s0,16(sp)
 8fc:	1000                	addi	s0,sp,32
 8fe:	e40c                	sd	a1,8(s0)
 900:	e810                	sd	a2,16(s0)
 902:	ec14                	sd	a3,24(s0)
 904:	f018                	sd	a4,32(s0)
 906:	f41c                	sd	a5,40(s0)
 908:	03043823          	sd	a6,48(s0)
 90c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 910:	00840613          	addi	a2,s0,8
 914:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 918:	85aa                	mv	a1,a0
 91a:	4505                	li	a0,1
 91c:	d11ff0ef          	jal	62c <vprintf>
}
 920:	60e2                	ld	ra,24(sp)
 922:	6442                	ld	s0,16(sp)
 924:	6125                	addi	sp,sp,96
 926:	8082                	ret

0000000000000928 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 928:	1141                	addi	sp,sp,-16
 92a:	e406                	sd	ra,8(sp)
 92c:	e022                	sd	s0,0(sp)
 92e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 930:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 934:	00000797          	auipc	a5,0x0
 938:	6cc7b783          	ld	a5,1740(a5) # 1000 <freep>
 93c:	a02d                	j	966 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 93e:	4618                	lw	a4,8(a2)
 940:	9f2d                	addw	a4,a4,a1
 942:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 946:	6398                	ld	a4,0(a5)
 948:	6310                	ld	a2,0(a4)
 94a:	a83d                	j	988 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 94c:	ff852703          	lw	a4,-8(a0)
 950:	9f31                	addw	a4,a4,a2
 952:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 954:	ff053683          	ld	a3,-16(a0)
 958:	a091                	j	99c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95a:	6398                	ld	a4,0(a5)
 95c:	00e7e463          	bltu	a5,a4,964 <free+0x3c>
 960:	00e6ea63          	bltu	a3,a4,974 <free+0x4c>
{
 964:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 966:	fed7fae3          	bgeu	a5,a3,95a <free+0x32>
 96a:	6398                	ld	a4,0(a5)
 96c:	00e6e463          	bltu	a3,a4,974 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 970:	fee7eae3          	bltu	a5,a4,964 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 974:	ff852583          	lw	a1,-8(a0)
 978:	6390                	ld	a2,0(a5)
 97a:	02059813          	slli	a6,a1,0x20
 97e:	01c85713          	srli	a4,a6,0x1c
 982:	9736                	add	a4,a4,a3
 984:	fae60de3          	beq	a2,a4,93e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 988:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 98c:	4790                	lw	a2,8(a5)
 98e:	02061593          	slli	a1,a2,0x20
 992:	01c5d713          	srli	a4,a1,0x1c
 996:	973e                	add	a4,a4,a5
 998:	fae68ae3          	beq	a3,a4,94c <free+0x24>
    p->s.ptr = bp->s.ptr;
 99c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 99e:	00000717          	auipc	a4,0x0
 9a2:	66f73123          	sd	a5,1634(a4) # 1000 <freep>
}
 9a6:	60a2                	ld	ra,8(sp)
 9a8:	6402                	ld	s0,0(sp)
 9aa:	0141                	addi	sp,sp,16
 9ac:	8082                	ret

00000000000009ae <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ae:	7139                	addi	sp,sp,-64
 9b0:	fc06                	sd	ra,56(sp)
 9b2:	f822                	sd	s0,48(sp)
 9b4:	f04a                	sd	s2,32(sp)
 9b6:	ec4e                	sd	s3,24(sp)
 9b8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ba:	02051993          	slli	s3,a0,0x20
 9be:	0209d993          	srli	s3,s3,0x20
 9c2:	09bd                	addi	s3,s3,15
 9c4:	0049d993          	srli	s3,s3,0x4
 9c8:	2985                	addiw	s3,s3,1
 9ca:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9cc:	00000517          	auipc	a0,0x0
 9d0:	63453503          	ld	a0,1588(a0) # 1000 <freep>
 9d4:	c905                	beqz	a0,a04 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d8:	4798                	lw	a4,8(a5)
 9da:	09377663          	bgeu	a4,s3,a66 <malloc+0xb8>
 9de:	f426                	sd	s1,40(sp)
 9e0:	e852                	sd	s4,16(sp)
 9e2:	e456                	sd	s5,8(sp)
 9e4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9e6:	8a4e                	mv	s4,s3
 9e8:	6705                	lui	a4,0x1
 9ea:	00e9f363          	bgeu	s3,a4,9f0 <malloc+0x42>
 9ee:	6a05                	lui	s4,0x1
 9f0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9f4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9f8:	00000497          	auipc	s1,0x0
 9fc:	60848493          	addi	s1,s1,1544 # 1000 <freep>
  if(p == SBRK_ERROR)
 a00:	5afd                	li	s5,-1
 a02:	a83d                	j	a40 <malloc+0x92>
 a04:	f426                	sd	s1,40(sp)
 a06:	e852                	sd	s4,16(sp)
 a08:	e456                	sd	s5,8(sp)
 a0a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a0c:	00000797          	auipc	a5,0x0
 a10:	60478793          	addi	a5,a5,1540 # 1010 <base>
 a14:	00000717          	auipc	a4,0x0
 a18:	5ef73623          	sd	a5,1516(a4) # 1000 <freep>
 a1c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a1e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a22:	b7d1                	j	9e6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a24:	6398                	ld	a4,0(a5)
 a26:	e118                	sd	a4,0(a0)
 a28:	a899                	j	a7e <malloc+0xd0>
  hp->s.size = nu;
 a2a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a2e:	0541                	addi	a0,a0,16
 a30:	ef9ff0ef          	jal	928 <free>
  return freep;
 a34:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a36:	c125                	beqz	a0,a96 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a38:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a3a:	4798                	lw	a4,8(a5)
 a3c:	03277163          	bgeu	a4,s2,a5e <malloc+0xb0>
    if(p == freep)
 a40:	6098                	ld	a4,0(s1)
 a42:	853e                	mv	a0,a5
 a44:	fef71ae3          	bne	a4,a5,a38 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a48:	8552                	mv	a0,s4
 a4a:	8c7ff0ef          	jal	310 <sbrk>
  if(p == SBRK_ERROR)
 a4e:	fd551ee3          	bne	a0,s5,a2a <malloc+0x7c>
        return 0;
 a52:	4501                	li	a0,0
 a54:	74a2                	ld	s1,40(sp)
 a56:	6a42                	ld	s4,16(sp)
 a58:	6aa2                	ld	s5,8(sp)
 a5a:	6b02                	ld	s6,0(sp)
 a5c:	a03d                	j	a8a <malloc+0xdc>
 a5e:	74a2                	ld	s1,40(sp)
 a60:	6a42                	ld	s4,16(sp)
 a62:	6aa2                	ld	s5,8(sp)
 a64:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a66:	fae90fe3          	beq	s2,a4,a24 <malloc+0x76>
        p->s.size -= nunits;
 a6a:	4137073b          	subw	a4,a4,s3
 a6e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a70:	02071693          	slli	a3,a4,0x20
 a74:	01c6d713          	srli	a4,a3,0x1c
 a78:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a7a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a7e:	00000717          	auipc	a4,0x0
 a82:	58a73123          	sd	a0,1410(a4) # 1000 <freep>
      return (void*)(p + 1);
 a86:	01078513          	addi	a0,a5,16
  }
}
 a8a:	70e2                	ld	ra,56(sp)
 a8c:	7442                	ld	s0,48(sp)
 a8e:	7902                	ld	s2,32(sp)
 a90:	69e2                	ld	s3,24(sp)
 a92:	6121                	addi	sp,sp,64
 a94:	8082                	ret
 a96:	74a2                	ld	s1,40(sp)
 a98:	6a42                	ld	s4,16(sp)
 a9a:	6aa2                	ld	s5,8(sp)
 a9c:	6b02                	ld	s6,0(sp)
 a9e:	b7f5                	j	a8a <malloc+0xdc>
