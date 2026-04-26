
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	1c6000ef          	jal	1ee <atoi>
  2c:	498000ef          	jal	4c4 <kill>
  for(i=1; i<argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	45c000ef          	jal	494 <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  40:	00001597          	auipc	a1,0x1
  44:	a4058593          	addi	a1,a1,-1472 # a80 <malloc+0xfa>
  48:	4509                	li	a0,2
  4a:	05b000ef          	jal	8a4 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	444000ef          	jal	494 <exit>

0000000000000054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  5c:	fa5ff0ef          	jal	0 <main>
  exit(r);
  60:	434000ef          	jal	494 <exit>

0000000000000064 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6c:	87aa                	mv	a5,a0
  6e:	0585                	addi	a1,a1,1
  70:	0785                	addi	a5,a5,1
  72:	fff5c703          	lbu	a4,-1(a1)
  76:	fee78fa3          	sb	a4,-1(a5)
  7a:	fb75                	bnez	a4,6e <strcpy+0xa>
    ;
  return os;
}
  7c:	60a2                	ld	ra,8(sp)
  7e:	6402                	ld	s0,0(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  84:	1141                	addi	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  8c:	00054783          	lbu	a5,0(a0)
  90:	cb91                	beqz	a5,a4 <strcmp+0x20>
  92:	0005c703          	lbu	a4,0(a1)
  96:	00f71763          	bne	a4,a5,a4 <strcmp+0x20>
    p++, q++;
  9a:	0505                	addi	a0,a0,1
  9c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	fbe5                	bnez	a5,92 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a4:	0005c503          	lbu	a0,0(a1)
}
  a8:	40a7853b          	subw	a0,a5,a0
  ac:	60a2                	ld	ra,8(sp)
  ae:	6402                	ld	s0,0(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strlen>:

uint
strlen(const char *s)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cf99                	beqz	a5,de <strlen+0x2a>
  c2:	0505                	addi	a0,a0,1
  c4:	87aa                	mv	a5,a0
  c6:	86be                	mv	a3,a5
  c8:	0785                	addi	a5,a5,1
  ca:	fff7c703          	lbu	a4,-1(a5)
  ce:	ff65                	bnez	a4,c6 <strlen+0x12>
  d0:	40a6853b          	subw	a0,a3,a0
  d4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  d6:	60a2                	ld	ra,8(sp)
  d8:	6402                	ld	s0,0(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  for(n = 0; s[n]; n++)
  de:	4501                	li	a0,0
  e0:	bfdd                	j	d6 <strlen+0x22>

00000000000000e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e406                	sd	ra,8(sp)
  e6:	e022                	sd	s0,0(sp)
  e8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ea:	ca19                	beqz	a2,100 <memset+0x1e>
  ec:	87aa                	mv	a5,a0
  ee:	1602                	slli	a2,a2,0x20
  f0:	9201                	srli	a2,a2,0x20
  f2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  fa:	0785                	addi	a5,a5,1
  fc:	fee79de3          	bne	a5,a4,f6 <memset+0x14>
  }
  return dst;
}
 100:	60a2                	ld	ra,8(sp)
 102:	6402                	ld	s0,0(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret

0000000000000108 <strchr>:

char*
strchr(const char *s, char c)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 110:	00054783          	lbu	a5,0(a0)
 114:	cf81                	beqz	a5,12c <strchr+0x24>
    if(*s == c)
 116:	00f58763          	beq	a1,a5,124 <strchr+0x1c>
  for(; *s; s++)
 11a:	0505                	addi	a0,a0,1
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbfd                	bnez	a5,116 <strchr+0xe>
      return (char*)s;
  return 0;
 122:	4501                	li	a0,0
}
 124:	60a2                	ld	ra,8(sp)
 126:	6402                	ld	s0,0(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
  return 0;
 12c:	4501                	li	a0,0
 12e:	bfdd                	j	124 <strchr+0x1c>

0000000000000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	7159                	addi	sp,sp,-112
 132:	f486                	sd	ra,104(sp)
 134:	f0a2                	sd	s0,96(sp)
 136:	eca6                	sd	s1,88(sp)
 138:	e8ca                	sd	s2,80(sp)
 13a:	e4ce                	sd	s3,72(sp)
 13c:	e0d2                	sd	s4,64(sp)
 13e:	fc56                	sd	s5,56(sp)
 140:	f85a                	sd	s6,48(sp)
 142:	f45e                	sd	s7,40(sp)
 144:	f062                	sd	s8,32(sp)
 146:	ec66                	sd	s9,24(sp)
 148:	e86a                	sd	s10,16(sp)
 14a:	1880                	addi	s0,sp,112
 14c:	8caa                	mv	s9,a0
 14e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 150:	892a                	mv	s2,a0
 152:	4481                	li	s1,0
    cc = read(0, &c, 1);
 154:	f9f40b13          	addi	s6,s0,-97
 158:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 15a:	4ba9                	li	s7,10
 15c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 15e:	8d26                	mv	s10,s1
 160:	0014899b          	addiw	s3,s1,1
 164:	84ce                	mv	s1,s3
 166:	0349d563          	bge	s3,s4,190 <gets+0x60>
    cc = read(0, &c, 1);
 16a:	8656                	mv	a2,s5
 16c:	85da                	mv	a1,s6
 16e:	4501                	li	a0,0
 170:	33c000ef          	jal	4ac <read>
    if(cc < 1)
 174:	00a05e63          	blez	a0,190 <gets+0x60>
    buf[i++] = c;
 178:	f9f44783          	lbu	a5,-97(s0)
 17c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 180:	01778763          	beq	a5,s7,18e <gets+0x5e>
 184:	0905                	addi	s2,s2,1
 186:	fd879ce3          	bne	a5,s8,15e <gets+0x2e>
    buf[i++] = c;
 18a:	8d4e                	mv	s10,s3
 18c:	a011                	j	190 <gets+0x60>
 18e:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 190:	9d66                	add	s10,s10,s9
 192:	000d0023          	sb	zero,0(s10)
  return buf;
}
 196:	8566                	mv	a0,s9
 198:	70a6                	ld	ra,104(sp)
 19a:	7406                	ld	s0,96(sp)
 19c:	64e6                	ld	s1,88(sp)
 19e:	6946                	ld	s2,80(sp)
 1a0:	69a6                	ld	s3,72(sp)
 1a2:	6a06                	ld	s4,64(sp)
 1a4:	7ae2                	ld	s5,56(sp)
 1a6:	7b42                	ld	s6,48(sp)
 1a8:	7ba2                	ld	s7,40(sp)
 1aa:	7c02                	ld	s8,32(sp)
 1ac:	6ce2                	ld	s9,24(sp)
 1ae:	6d42                	ld	s10,16(sp)
 1b0:	6165                	addi	sp,sp,112
 1b2:	8082                	ret

00000000000001b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b4:	1101                	addi	sp,sp,-32
 1b6:	ec06                	sd	ra,24(sp)
 1b8:	e822                	sd	s0,16(sp)
 1ba:	e04a                	sd	s2,0(sp)
 1bc:	1000                	addi	s0,sp,32
 1be:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c0:	4581                	li	a1,0
 1c2:	312000ef          	jal	4d4 <open>
  if(fd < 0)
 1c6:	02054263          	bltz	a0,1ea <stat+0x36>
 1ca:	e426                	sd	s1,8(sp)
 1cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ce:	85ca                	mv	a1,s2
 1d0:	31c000ef          	jal	4ec <fstat>
 1d4:	892a                	mv	s2,a0
  close(fd);
 1d6:	8526                	mv	a0,s1
 1d8:	2e4000ef          	jal	4bc <close>
  return r;
 1dc:	64a2                	ld	s1,8(sp)
}
 1de:	854a                	mv	a0,s2
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	6902                	ld	s2,0(sp)
 1e6:	6105                	addi	sp,sp,32
 1e8:	8082                	ret
    return -1;
 1ea:	597d                	li	s2,-1
 1ec:	bfcd                	j	1de <stat+0x2a>

00000000000001ee <atoi>:

int
atoi(const char *s)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e406                	sd	ra,8(sp)
 1f2:	e022                	sd	s0,0(sp)
 1f4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f6:	00054683          	lbu	a3,0(a0)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	4625                	li	a2,9
 204:	02f66963          	bltu	a2,a5,236 <atoi+0x48>
 208:	872a                	mv	a4,a0
  n = 0;
 20a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 20c:	0705                	addi	a4,a4,1
 20e:	0025179b          	slliw	a5,a0,0x2
 212:	9fa9                	addw	a5,a5,a0
 214:	0017979b          	slliw	a5,a5,0x1
 218:	9fb5                	addw	a5,a5,a3
 21a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21e:	00074683          	lbu	a3,0(a4)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	fef671e3          	bgeu	a2,a5,20c <atoi+0x1e>
  return n;
}
 22e:	60a2                	ld	ra,8(sp)
 230:	6402                	ld	s0,0(sp)
 232:	0141                	addi	sp,sp,16
 234:	8082                	ret
  n = 0;
 236:	4501                	li	a0,0
 238:	bfdd                	j	22e <atoi+0x40>

000000000000023a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e406                	sd	ra,8(sp)
 23e:	e022                	sd	s0,0(sp)
 240:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 242:	02b57563          	bgeu	a0,a1,26c <memmove+0x32>
    while(n-- > 0)
 246:	00c05f63          	blez	a2,264 <memmove+0x2a>
 24a:	1602                	slli	a2,a2,0x20
 24c:	9201                	srli	a2,a2,0x20
 24e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 252:	872a                	mv	a4,a0
      *dst++ = *src++;
 254:	0585                	addi	a1,a1,1
 256:	0705                	addi	a4,a4,1
 258:	fff5c683          	lbu	a3,-1(a1)
 25c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 260:	fee79ae3          	bne	a5,a4,254 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 264:	60a2                	ld	ra,8(sp)
 266:	6402                	ld	s0,0(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret
    dst += n;
 26c:	00c50733          	add	a4,a0,a2
    src += n;
 270:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 272:	fec059e3          	blez	a2,264 <memmove+0x2a>
 276:	fff6079b          	addiw	a5,a2,-1
 27a:	1782                	slli	a5,a5,0x20
 27c:	9381                	srli	a5,a5,0x20
 27e:	fff7c793          	not	a5,a5
 282:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 284:	15fd                	addi	a1,a1,-1
 286:	177d                	addi	a4,a4,-1
 288:	0005c683          	lbu	a3,0(a1)
 28c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 290:	fef71ae3          	bne	a4,a5,284 <memmove+0x4a>
 294:	bfc1                	j	264 <memmove+0x2a>

0000000000000296 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 296:	1141                	addi	sp,sp,-16
 298:	e406                	sd	ra,8(sp)
 29a:	e022                	sd	s0,0(sp)
 29c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29e:	ca0d                	beqz	a2,2d0 <memcmp+0x3a>
 2a0:	fff6069b          	addiw	a3,a2,-1
 2a4:	1682                	slli	a3,a3,0x20
 2a6:	9281                	srli	a3,a3,0x20
 2a8:	0685                	addi	a3,a3,1
 2aa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	0005c703          	lbu	a4,0(a1)
 2b4:	00e79863          	bne	a5,a4,2c4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2b8:	0505                	addi	a0,a0,1
    p2++;
 2ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2bc:	fed518e3          	bne	a0,a3,2ac <memcmp+0x16>
  }
  return 0;
 2c0:	4501                	li	a0,0
 2c2:	a019                	j	2c8 <memcmp+0x32>
      return *p1 - *p2;
 2c4:	40e7853b          	subw	a0,a5,a4
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret
  return 0;
 2d0:	4501                	li	a0,0
 2d2:	bfdd                	j	2c8 <memcmp+0x32>

00000000000002d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e406                	sd	ra,8(sp)
 2d8:	e022                	sd	s0,0(sp)
 2da:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2dc:	f5fff0ef          	jal	23a <memmove>
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <sbrk>:

char *
sbrk(int n) {
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f0:	4585                	li	a1,1
 2f2:	22a000ef          	jal	51c <sys_sbrk>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <sbrklazy>:

char *
sbrklazy(int n) {
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 306:	4589                	li	a1,2
 308:	214000ef          	jal	51c <sys_sbrk>
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret

0000000000000314 <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 314:	1101                	addi	sp,sp,-32
 316:	ec06                	sd	ra,24(sp)
 318:	e822                	sd	s0,16(sp)
 31a:	e426                	sd	s1,8(sp)
 31c:	e04a                	sd	s2,0(sp)
 31e:	1000                	addi	s0,sp,32
 320:	84aa                	mv	s1,a0
 322:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 324:	6505                	lui	a0,0x1
 326:	fc3ff0ef          	jal	2e8 <sbrk>
 32a:	6785                	lui	a5,0x1
 32c:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 330:	9a41                	andi	a2,a2,-16
 332:	85ca                	mv	a1,s2
 334:	8526                	mv	a0,s1
 336:	1fe000ef          	jal	534 <clone>
}
 33a:	60e2                	ld	ra,24(sp)
 33c:	6442                	ld	s0,16(sp)
 33e:	64a2                	ld	s1,8(sp)
 340:	6902                	ld	s2,0(sp)
 342:	6105                	addi	sp,sp,32
 344:	8082                	ret

0000000000000346 <futex>:

void futex(int *uaddr, int ops, int val) {
 346:	7179                	addi	sp,sp,-48
 348:	f406                	sd	ra,40(sp)
 34a:	f022                	sd	s0,32(sp)
 34c:	ec26                	sd	s1,24(sp)
 34e:	1800                	addi	s0,sp,48
 350:	84aa                	mv	s1,a0
  if (ops==0) {
 352:	ed95                	bnez	a1,38e <futex+0x48>
    if (val==0) {
 354:	c611                	beqz	a2,360 <futex+0x1a>
 356:	e84a                	sd	s2,16(sp)
 358:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 35a:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 35c:	4985                	li	s3,1
 35e:	a005                	j	37e <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 360:	4705                	li	a4,1
 362:	87ba                	mv	a5,a4
 364:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 368:	2781                	sext.w	a5,a5
 36a:	ffe5                	bnez	a5,362 <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 36c:	70a2                	ld	ra,40(sp)
 36e:	7402                	ld	s0,32(sp)
 370:	64e2                	ld	s1,24(sp)
 372:	6145                	addi	sp,sp,48
 374:	8082                	ret
        futex_wait(uaddr, 1);
 376:	85ce                	mv	a1,s3
 378:	8526                	mv	a0,s1
 37a:	1ca000ef          	jal	544 <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 37e:	87ca                	mv	a5,s2
 380:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 384:	2781                	sext.w	a5,a5
 386:	fbe5                	bnez	a5,376 <futex+0x30>
 388:	6942                	ld	s2,16(sp)
 38a:	69a2                	ld	s3,8(sp)
 38c:	b7c5                	j	36c <futex+0x26>
    if (val==0) {
 38e:	e611                	bnez	a2,39a <futex+0x54>
      __sync_lock_release(uaddr);
 390:	0310000f          	fence	rw,w
 394:	00052023          	sw	zero,0(a0) # 1000 <freep>
 398:	bfd1                	j	36c <futex+0x26>
      __sync_lock_release(uaddr);
 39a:	0310000f          	fence	rw,w
 39e:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 3a2:	1aa000ef          	jal	54c <futex_wake>
  return;
 3a6:	b7d9                	j	36c <futex+0x26>

00000000000003a8 <sem_init>:

void sem_init(sem_t* s, int val) {
 3a8:	7179                	addi	sp,sp,-48
 3aa:	f406                	sd	ra,40(sp)
 3ac:	f022                	sd	s0,32(sp)
 3ae:	ec26                	sd	s1,24(sp)
 3b0:	e84a                	sd	s2,16(sp)
 3b2:	e44e                	sd	s3,8(sp)
 3b4:	1800                	addi	s0,sp,48
 3b6:	84aa                	mv	s1,a0
 3b8:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 3ba:	00450993          	addi	s3,a0,4
 3be:	4605                	li	a2,1
 3c0:	4581                	li	a1,0
 3c2:	854e                	mv	a0,s3
 3c4:	f83ff0ef          	jal	346 <futex>
  s->value = val;
 3c8:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 3cc:	4605                	li	a2,1
 3ce:	85b2                	mv	a1,a2
 3d0:	854e                	mv	a0,s3
 3d2:	f75ff0ef          	jal	346 <futex>
  return;
}
 3d6:	70a2                	ld	ra,40(sp)
 3d8:	7402                	ld	s0,32(sp)
 3da:	64e2                	ld	s1,24(sp)
 3dc:	6942                	ld	s2,16(sp)
 3de:	69a2                	ld	s3,8(sp)
 3e0:	6145                	addi	sp,sp,48
 3e2:	8082                	ret

00000000000003e4 <sem_down>:

void sem_down(sem_t* s) {
 3e4:	7179                	addi	sp,sp,-48
 3e6:	f406                	sd	ra,40(sp)
 3e8:	f022                	sd	s0,32(sp)
 3ea:	ec26                	sd	s1,24(sp)
 3ec:	e84a                	sd	s2,16(sp)
 3ee:	e44e                	sd	s3,8(sp)
 3f0:	1800                	addi	s0,sp,48
 3f2:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 3f4:	00450993          	addi	s3,a0,4
 3f8:	4605                	li	a2,1
 3fa:	4581                	li	a1,0
 3fc:	854e                	mv	a0,s3
 3fe:	f49ff0ef          	jal	346 <futex>
  while(1) {
    if (s->value>0) {
 402:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 406:	4485                	li	s1,1
    if (s->value>0) {
 408:	02f04463          	bgtz	a5,430 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 40c:	8626                	mv	a2,s1
 40e:	85a6                	mv	a1,s1
 410:	854e                	mv	a0,s3
 412:	f35ff0ef          	jal	346 <futex>
      futex_wait(&s->value,1);
 416:	85a6                	mv	a1,s1
 418:	854a                	mv	a0,s2
 41a:	12a000ef          	jal	544 <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 41e:	8626                	mv	a2,s1
 420:	4581                	li	a1,0
 422:	854e                	mv	a0,s3
 424:	f23ff0ef          	jal	346 <futex>
    if (s->value>0) {
 428:	00092783          	lw	a5,0(s2)
 42c:	fef050e3          	blez	a5,40c <sem_down+0x28>
      s->value--;
 430:	37fd                	addiw	a5,a5,-1 # fff <digits+0x55f>
 432:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 436:	4605                	li	a2,1
 438:	85b2                	mv	a1,a2
 43a:	854e                	mv	a0,s3
 43c:	f0bff0ef          	jal	346 <futex>
  return;
}
 440:	70a2                	ld	ra,40(sp)
 442:	7402                	ld	s0,32(sp)
 444:	64e2                	ld	s1,24(sp)
 446:	6942                	ld	s2,16(sp)
 448:	69a2                	ld	s3,8(sp)
 44a:	6145                	addi	sp,sp,48
 44c:	8082                	ret

000000000000044e <sem_up>:

void sem_up(sem_t* s) {
 44e:	1101                	addi	sp,sp,-32
 450:	ec06                	sd	ra,24(sp)
 452:	e822                	sd	s0,16(sp)
 454:	e426                	sd	s1,8(sp)
 456:	e04a                	sd	s2,0(sp)
 458:	1000                	addi	s0,sp,32
 45a:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 45c:	00450913          	addi	s2,a0,4
 460:	4605                	li	a2,1
 462:	4581                	li	a1,0
 464:	854a                	mv	a0,s2
 466:	ee1ff0ef          	jal	346 <futex>
  s->value++;
 46a:	409c                	lw	a5,0(s1)
 46c:	2785                	addiw	a5,a5,1
 46e:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 470:	8526                	mv	a0,s1
 472:	0da000ef          	jal	54c <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 476:	4605                	li	a2,1
 478:	85b2                	mv	a1,a2
 47a:	854a                	mv	a0,s2
 47c:	ecbff0ef          	jal	346 <futex>
  return;
 480:	60e2                	ld	ra,24(sp)
 482:	6442                	ld	s0,16(sp)
 484:	64a2                	ld	s1,8(sp)
 486:	6902                	ld	s2,0(sp)
 488:	6105                	addi	sp,sp,32
 48a:	8082                	ret

000000000000048c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 48c:	4885                	li	a7,1
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <exit>:
.global exit
exit:
 li a7, SYS_exit
 494:	4889                	li	a7,2
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <wait>:
.global wait
wait:
 li a7, SYS_wait
 49c:	488d                	li	a7,3
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4a4:	4891                	li	a7,4
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <read>:
.global read
read:
 li a7, SYS_read
 4ac:	4895                	li	a7,5
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <write>:
.global write
write:
 li a7, SYS_write
 4b4:	48c1                	li	a7,16
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <close>:
.global close
close:
 li a7, SYS_close
 4bc:	48d5                	li	a7,21
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4c4:	4899                	li	a7,6
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 4cc:	489d                	li	a7,7
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <open>:
.global open
open:
 li a7, SYS_open
 4d4:	48bd                	li	a7,15
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4dc:	48c5                	li	a7,17
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4e4:	48c9                	li	a7,18
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4ec:	48a1                	li	a7,8
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <link>:
.global link
link:
 li a7, SYS_link
 4f4:	48cd                	li	a7,19
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4fc:	48d1                	li	a7,20
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 504:	48a5                	li	a7,9
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <dup>:
.global dup
dup:
 li a7, SYS_dup
 50c:	48a9                	li	a7,10
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 514:	48ad                	li	a7,11
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 51c:	48b1                	li	a7,12
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <pause>:
.global pause
pause:
 li a7, SYS_pause
 524:	48b5                	li	a7,13
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 52c:	48b9                	li	a7,14
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <clone>:
.global clone
clone:
 li a7, SYS_clone
 534:	48d9                	li	a7,22
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <join>:
.global join
join:
 li a7, SYS_join
 53c:	48dd                	li	a7,23
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 544:	48e1                	li	a7,24
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 54c:	48e5                	li	a7,25
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 554:	1101                	addi	sp,sp,-32
 556:	ec06                	sd	ra,24(sp)
 558:	e822                	sd	s0,16(sp)
 55a:	1000                	addi	s0,sp,32
 55c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 560:	4605                	li	a2,1
 562:	fef40593          	addi	a1,s0,-17
 566:	f4fff0ef          	jal	4b4 <write>
}
 56a:	60e2                	ld	ra,24(sp)
 56c:	6442                	ld	s0,16(sp)
 56e:	6105                	addi	sp,sp,32
 570:	8082                	ret

0000000000000572 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 572:	715d                	addi	sp,sp,-80
 574:	e486                	sd	ra,72(sp)
 576:	e0a2                	sd	s0,64(sp)
 578:	fc26                	sd	s1,56(sp)
 57a:	f84a                	sd	s2,48(sp)
 57c:	f44e                	sd	s3,40(sp)
 57e:	0880                	addi	s0,sp,80
 580:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 582:	c299                	beqz	a3,588 <printint+0x16>
 584:	0605cc63          	bltz	a1,5fc <printint+0x8a>
  neg = 0;
 588:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 58a:	fb840313          	addi	t1,s0,-72
  neg = 0;
 58e:	869a                	mv	a3,t1
  i = 0;
 590:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 592:	00000817          	auipc	a6,0x0
 596:	50e80813          	addi	a6,a6,1294 # aa0 <digits>
 59a:	88be                	mv	a7,a5
 59c:	0017851b          	addiw	a0,a5,1
 5a0:	87aa                	mv	a5,a0
 5a2:	02c5f733          	remu	a4,a1,a2
 5a6:	9742                	add	a4,a4,a6
 5a8:	00074703          	lbu	a4,0(a4)
 5ac:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5b0:	872e                	mv	a4,a1
 5b2:	02c5d5b3          	divu	a1,a1,a2
 5b6:	0685                	addi	a3,a3,1
 5b8:	fec771e3          	bgeu	a4,a2,59a <printint+0x28>
  if(neg)
 5bc:	000e0c63          	beqz	t3,5d4 <printint+0x62>
    buf[i++] = '-';
 5c0:	fd050793          	addi	a5,a0,-48
 5c4:	00878533          	add	a0,a5,s0
 5c8:	02d00793          	li	a5,45
 5cc:	fef50423          	sb	a5,-24(a0)
 5d0:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 5d4:	fff7899b          	addiw	s3,a5,-1
 5d8:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 5dc:	fff4c583          	lbu	a1,-1(s1)
 5e0:	854a                	mv	a0,s2
 5e2:	f73ff0ef          	jal	554 <putc>
  while(--i >= 0)
 5e6:	39fd                	addiw	s3,s3,-1
 5e8:	14fd                	addi	s1,s1,-1
 5ea:	fe09d9e3          	bgez	s3,5dc <printint+0x6a>
}
 5ee:	60a6                	ld	ra,72(sp)
 5f0:	6406                	ld	s0,64(sp)
 5f2:	74e2                	ld	s1,56(sp)
 5f4:	7942                	ld	s2,48(sp)
 5f6:	79a2                	ld	s3,40(sp)
 5f8:	6161                	addi	sp,sp,80
 5fa:	8082                	ret
    x = -xx;
 5fc:	40b005b3          	neg	a1,a1
    neg = 1;
 600:	4e05                	li	t3,1
    x = -xx;
 602:	b761                	j	58a <printint+0x18>

0000000000000604 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 604:	711d                	addi	sp,sp,-96
 606:	ec86                	sd	ra,88(sp)
 608:	e8a2                	sd	s0,80(sp)
 60a:	e4a6                	sd	s1,72(sp)
 60c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 60e:	0005c483          	lbu	s1,0(a1)
 612:	28048463          	beqz	s1,89a <vprintf+0x296>
 616:	e0ca                	sd	s2,64(sp)
 618:	fc4e                	sd	s3,56(sp)
 61a:	f852                	sd	s4,48(sp)
 61c:	f456                	sd	s5,40(sp)
 61e:	f05a                	sd	s6,32(sp)
 620:	ec5e                	sd	s7,24(sp)
 622:	e862                	sd	s8,16(sp)
 624:	e466                	sd	s9,8(sp)
 626:	8b2a                	mv	s6,a0
 628:	8a2e                	mv	s4,a1
 62a:	8bb2                	mv	s7,a2
  state = 0;
 62c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 62e:	4901                	li	s2,0
 630:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 632:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 636:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 63a:	06c00c93          	li	s9,108
 63e:	a00d                	j	660 <vprintf+0x5c>
        putc(fd, c0);
 640:	85a6                	mv	a1,s1
 642:	855a                	mv	a0,s6
 644:	f11ff0ef          	jal	554 <putc>
 648:	a019                	j	64e <vprintf+0x4a>
    } else if(state == '%'){
 64a:	03598363          	beq	s3,s5,670 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 64e:	0019079b          	addiw	a5,s2,1
 652:	893e                	mv	s2,a5
 654:	873e                	mv	a4,a5
 656:	97d2                	add	a5,a5,s4
 658:	0007c483          	lbu	s1,0(a5)
 65c:	22048763          	beqz	s1,88a <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 660:	0004879b          	sext.w	a5,s1
    if(state == 0){
 664:	fe0993e3          	bnez	s3,64a <vprintf+0x46>
      if(c0 == '%'){
 668:	fd579ce3          	bne	a5,s5,640 <vprintf+0x3c>
        state = '%';
 66c:	89be                	mv	s3,a5
 66e:	b7c5                	j	64e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 670:	00ea06b3          	add	a3,s4,a4
 674:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 678:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 67a:	c681                	beqz	a3,682 <vprintf+0x7e>
 67c:	9752                	add	a4,a4,s4
 67e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 682:	05878263          	beq	a5,s8,6c6 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 686:	05978c63          	beq	a5,s9,6de <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 68a:	07500713          	li	a4,117
 68e:	0ee78663          	beq	a5,a4,77a <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 692:	07800713          	li	a4,120
 696:	12e78863          	beq	a5,a4,7c6 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 69a:	07000713          	li	a4,112
 69e:	14e78d63          	beq	a5,a4,7f8 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 6a2:	06300713          	li	a4,99
 6a6:	18e78c63          	beq	a5,a4,83e <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 6aa:	07300713          	li	a4,115
 6ae:	1ae78263          	beq	a5,a4,852 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6b2:	02500713          	li	a4,37
 6b6:	04e79463          	bne	a5,a4,6fe <vprintf+0xfa>
        putc(fd, '%');
 6ba:	85ba                	mv	a1,a4
 6bc:	855a                	mv	a0,s6
 6be:	e97ff0ef          	jal	554 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b769                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6c6:	008b8493          	addi	s1,s7,8
 6ca:	4685                	li	a3,1
 6cc:	4629                	li	a2,10
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	e9fff0ef          	jal	572 <printint>
 6d8:	8ba6                	mv	s7,s1
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bf8d                	j	64e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6de:	06400793          	li	a5,100
 6e2:	02f68963          	beq	a3,a5,714 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e6:	06c00793          	li	a5,108
 6ea:	04f68263          	beq	a3,a5,72e <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 6ee:	07500793          	li	a5,117
 6f2:	0af68063          	beq	a3,a5,792 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 6f6:	07800793          	li	a5,120
 6fa:	0ef68263          	beq	a3,a5,7de <vprintf+0x1da>
        putc(fd, '%');
 6fe:	02500593          	li	a1,37
 702:	855a                	mv	a0,s6
 704:	e51ff0ef          	jal	554 <putc>
        putc(fd, c0);
 708:	85a6                	mv	a1,s1
 70a:	855a                	mv	a0,s6
 70c:	e49ff0ef          	jal	554 <putc>
      state = 0;
 710:	4981                	li	s3,0
 712:	bf35                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 714:	008b8493          	addi	s1,s7,8
 718:	4685                	li	a3,1
 71a:	4629                	li	a2,10
 71c:	000bb583          	ld	a1,0(s7)
 720:	855a                	mv	a0,s6
 722:	e51ff0ef          	jal	572 <printint>
        i += 1;
 726:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 728:	8ba6                	mv	s7,s1
      state = 0;
 72a:	4981                	li	s3,0
        i += 1;
 72c:	b70d                	j	64e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 72e:	06400793          	li	a5,100
 732:	02f60763          	beq	a2,a5,760 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 736:	07500793          	li	a5,117
 73a:	06f60963          	beq	a2,a5,7ac <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 73e:	07800793          	li	a5,120
 742:	faf61ee3          	bne	a2,a5,6fe <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 746:	008b8493          	addi	s1,s7,8
 74a:	4681                	li	a3,0
 74c:	4641                	li	a2,16
 74e:	000bb583          	ld	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	e1fff0ef          	jal	572 <printint>
        i += 2;
 758:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 75a:	8ba6                	mv	s7,s1
      state = 0;
 75c:	4981                	li	s3,0
        i += 2;
 75e:	bdc5                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 760:	008b8493          	addi	s1,s7,8
 764:	4685                	li	a3,1
 766:	4629                	li	a2,10
 768:	000bb583          	ld	a1,0(s7)
 76c:	855a                	mv	a0,s6
 76e:	e05ff0ef          	jal	572 <printint>
        i += 2;
 772:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 774:	8ba6                	mv	s7,s1
      state = 0;
 776:	4981                	li	s3,0
        i += 2;
 778:	bdd9                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 77a:	008b8493          	addi	s1,s7,8
 77e:	4681                	li	a3,0
 780:	4629                	li	a2,10
 782:	000be583          	lwu	a1,0(s7)
 786:	855a                	mv	a0,s6
 788:	debff0ef          	jal	572 <printint>
 78c:	8ba6                	mv	s7,s1
      state = 0;
 78e:	4981                	li	s3,0
 790:	bd7d                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 792:	008b8493          	addi	s1,s7,8
 796:	4681                	li	a3,0
 798:	4629                	li	a2,10
 79a:	000bb583          	ld	a1,0(s7)
 79e:	855a                	mv	a0,s6
 7a0:	dd3ff0ef          	jal	572 <printint>
        i += 1;
 7a4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a6:	8ba6                	mv	s7,s1
      state = 0;
 7a8:	4981                	li	s3,0
        i += 1;
 7aa:	b555                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ac:	008b8493          	addi	s1,s7,8
 7b0:	4681                	li	a3,0
 7b2:	4629                	li	a2,10
 7b4:	000bb583          	ld	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	db9ff0ef          	jal	572 <printint>
        i += 2;
 7be:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c0:	8ba6                	mv	s7,s1
      state = 0;
 7c2:	4981                	li	s3,0
        i += 2;
 7c4:	b569                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7c6:	008b8493          	addi	s1,s7,8
 7ca:	4681                	li	a3,0
 7cc:	4641                	li	a2,16
 7ce:	000be583          	lwu	a1,0(s7)
 7d2:	855a                	mv	a0,s6
 7d4:	d9fff0ef          	jal	572 <printint>
 7d8:	8ba6                	mv	s7,s1
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	bd8d                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7de:	008b8493          	addi	s1,s7,8
 7e2:	4681                	li	a3,0
 7e4:	4641                	li	a2,16
 7e6:	000bb583          	ld	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	d87ff0ef          	jal	572 <printint>
        i += 1;
 7f0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f2:	8ba6                	mv	s7,s1
      state = 0;
 7f4:	4981                	li	s3,0
        i += 1;
 7f6:	bda1                	j	64e <vprintf+0x4a>
 7f8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7fa:	008b8d13          	addi	s10,s7,8
 7fe:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 802:	03000593          	li	a1,48
 806:	855a                	mv	a0,s6
 808:	d4dff0ef          	jal	554 <putc>
  putc(fd, 'x');
 80c:	07800593          	li	a1,120
 810:	855a                	mv	a0,s6
 812:	d43ff0ef          	jal	554 <putc>
 816:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 818:	00000b97          	auipc	s7,0x0
 81c:	288b8b93          	addi	s7,s7,648 # aa0 <digits>
 820:	03c9d793          	srli	a5,s3,0x3c
 824:	97de                	add	a5,a5,s7
 826:	0007c583          	lbu	a1,0(a5)
 82a:	855a                	mv	a0,s6
 82c:	d29ff0ef          	jal	554 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 830:	0992                	slli	s3,s3,0x4
 832:	34fd                	addiw	s1,s1,-1
 834:	f4f5                	bnez	s1,820 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 836:	8bea                	mv	s7,s10
      state = 0;
 838:	4981                	li	s3,0
 83a:	6d02                	ld	s10,0(sp)
 83c:	bd09                	j	64e <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 83e:	008b8493          	addi	s1,s7,8
 842:	000bc583          	lbu	a1,0(s7)
 846:	855a                	mv	a0,s6
 848:	d0dff0ef          	jal	554 <putc>
 84c:	8ba6                	mv	s7,s1
      state = 0;
 84e:	4981                	li	s3,0
 850:	bbfd                	j	64e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 852:	008b8993          	addi	s3,s7,8
 856:	000bb483          	ld	s1,0(s7)
 85a:	cc91                	beqz	s1,876 <vprintf+0x272>
        for(; *s; s++)
 85c:	0004c583          	lbu	a1,0(s1)
 860:	c195                	beqz	a1,884 <vprintf+0x280>
          putc(fd, *s);
 862:	855a                	mv	a0,s6
 864:	cf1ff0ef          	jal	554 <putc>
        for(; *s; s++)
 868:	0485                	addi	s1,s1,1
 86a:	0004c583          	lbu	a1,0(s1)
 86e:	f9f5                	bnez	a1,862 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 870:	8bce                	mv	s7,s3
      state = 0;
 872:	4981                	li	s3,0
 874:	bbe9                	j	64e <vprintf+0x4a>
          s = "(null)";
 876:	00000497          	auipc	s1,0x0
 87a:	22248493          	addi	s1,s1,546 # a98 <malloc+0x112>
        for(; *s; s++)
 87e:	02800593          	li	a1,40
 882:	b7c5                	j	862 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 884:	8bce                	mv	s7,s3
      state = 0;
 886:	4981                	li	s3,0
 888:	b3d9                	j	64e <vprintf+0x4a>
 88a:	6906                	ld	s2,64(sp)
 88c:	79e2                	ld	s3,56(sp)
 88e:	7a42                	ld	s4,48(sp)
 890:	7aa2                	ld	s5,40(sp)
 892:	7b02                	ld	s6,32(sp)
 894:	6be2                	ld	s7,24(sp)
 896:	6c42                	ld	s8,16(sp)
 898:	6ca2                	ld	s9,8(sp)
    }
  }
}
 89a:	60e6                	ld	ra,88(sp)
 89c:	6446                	ld	s0,80(sp)
 89e:	64a6                	ld	s1,72(sp)
 8a0:	6125                	addi	sp,sp,96
 8a2:	8082                	ret

00000000000008a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a4:	715d                	addi	sp,sp,-80
 8a6:	ec06                	sd	ra,24(sp)
 8a8:	e822                	sd	s0,16(sp)
 8aa:	1000                	addi	s0,sp,32
 8ac:	e010                	sd	a2,0(s0)
 8ae:	e414                	sd	a3,8(s0)
 8b0:	e818                	sd	a4,16(s0)
 8b2:	ec1c                	sd	a5,24(s0)
 8b4:	03043023          	sd	a6,32(s0)
 8b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8bc:	8622                	mv	a2,s0
 8be:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8c2:	d43ff0ef          	jal	604 <vprintf>
}
 8c6:	60e2                	ld	ra,24(sp)
 8c8:	6442                	ld	s0,16(sp)
 8ca:	6161                	addi	sp,sp,80
 8cc:	8082                	ret

00000000000008ce <printf>:

void
printf(const char *fmt, ...)
{
 8ce:	711d                	addi	sp,sp,-96
 8d0:	ec06                	sd	ra,24(sp)
 8d2:	e822                	sd	s0,16(sp)
 8d4:	1000                	addi	s0,sp,32
 8d6:	e40c                	sd	a1,8(s0)
 8d8:	e810                	sd	a2,16(s0)
 8da:	ec14                	sd	a3,24(s0)
 8dc:	f018                	sd	a4,32(s0)
 8de:	f41c                	sd	a5,40(s0)
 8e0:	03043823          	sd	a6,48(s0)
 8e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8e8:	00840613          	addi	a2,s0,8
 8ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f0:	85aa                	mv	a1,a0
 8f2:	4505                	li	a0,1
 8f4:	d11ff0ef          	jal	604 <vprintf>
}
 8f8:	60e2                	ld	ra,24(sp)
 8fa:	6442                	ld	s0,16(sp)
 8fc:	6125                	addi	sp,sp,96
 8fe:	8082                	ret

0000000000000900 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 900:	1141                	addi	sp,sp,-16
 902:	e406                	sd	ra,8(sp)
 904:	e022                	sd	s0,0(sp)
 906:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 908:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90c:	00000797          	auipc	a5,0x0
 910:	6f47b783          	ld	a5,1780(a5) # 1000 <freep>
 914:	a02d                	j	93e <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 916:	4618                	lw	a4,8(a2)
 918:	9f2d                	addw	a4,a4,a1
 91a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 91e:	6398                	ld	a4,0(a5)
 920:	6310                	ld	a2,0(a4)
 922:	a83d                	j	960 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 924:	ff852703          	lw	a4,-8(a0)
 928:	9f31                	addw	a4,a4,a2
 92a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 92c:	ff053683          	ld	a3,-16(a0)
 930:	a091                	j	974 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 932:	6398                	ld	a4,0(a5)
 934:	00e7e463          	bltu	a5,a4,93c <free+0x3c>
 938:	00e6ea63          	bltu	a3,a4,94c <free+0x4c>
{
 93c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93e:	fed7fae3          	bgeu	a5,a3,932 <free+0x32>
 942:	6398                	ld	a4,0(a5)
 944:	00e6e463          	bltu	a3,a4,94c <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 948:	fee7eae3          	bltu	a5,a4,93c <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 94c:	ff852583          	lw	a1,-8(a0)
 950:	6390                	ld	a2,0(a5)
 952:	02059813          	slli	a6,a1,0x20
 956:	01c85713          	srli	a4,a6,0x1c
 95a:	9736                	add	a4,a4,a3
 95c:	fae60de3          	beq	a2,a4,916 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 960:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 964:	4790                	lw	a2,8(a5)
 966:	02061593          	slli	a1,a2,0x20
 96a:	01c5d713          	srli	a4,a1,0x1c
 96e:	973e                	add	a4,a4,a5
 970:	fae68ae3          	beq	a3,a4,924 <free+0x24>
    p->s.ptr = bp->s.ptr;
 974:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 976:	00000717          	auipc	a4,0x0
 97a:	68f73523          	sd	a5,1674(a4) # 1000 <freep>
}
 97e:	60a2                	ld	ra,8(sp)
 980:	6402                	ld	s0,0(sp)
 982:	0141                	addi	sp,sp,16
 984:	8082                	ret

0000000000000986 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 986:	7139                	addi	sp,sp,-64
 988:	fc06                	sd	ra,56(sp)
 98a:	f822                	sd	s0,48(sp)
 98c:	f04a                	sd	s2,32(sp)
 98e:	ec4e                	sd	s3,24(sp)
 990:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 992:	02051993          	slli	s3,a0,0x20
 996:	0209d993          	srli	s3,s3,0x20
 99a:	09bd                	addi	s3,s3,15
 99c:	0049d993          	srli	s3,s3,0x4
 9a0:	2985                	addiw	s3,s3,1
 9a2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9a4:	00000517          	auipc	a0,0x0
 9a8:	65c53503          	ld	a0,1628(a0) # 1000 <freep>
 9ac:	c905                	beqz	a0,9dc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b0:	4798                	lw	a4,8(a5)
 9b2:	09377663          	bgeu	a4,s3,a3e <malloc+0xb8>
 9b6:	f426                	sd	s1,40(sp)
 9b8:	e852                	sd	s4,16(sp)
 9ba:	e456                	sd	s5,8(sp)
 9bc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9be:	8a4e                	mv	s4,s3
 9c0:	6705                	lui	a4,0x1
 9c2:	00e9f363          	bgeu	s3,a4,9c8 <malloc+0x42>
 9c6:	6a05                	lui	s4,0x1
 9c8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9cc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d0:	00000497          	auipc	s1,0x0
 9d4:	63048493          	addi	s1,s1,1584 # 1000 <freep>
  if(p == SBRK_ERROR)
 9d8:	5afd                	li	s5,-1
 9da:	a83d                	j	a18 <malloc+0x92>
 9dc:	f426                	sd	s1,40(sp)
 9de:	e852                	sd	s4,16(sp)
 9e0:	e456                	sd	s5,8(sp)
 9e2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9e4:	00000797          	auipc	a5,0x0
 9e8:	62c78793          	addi	a5,a5,1580 # 1010 <base>
 9ec:	00000717          	auipc	a4,0x0
 9f0:	60f73a23          	sd	a5,1556(a4) # 1000 <freep>
 9f4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9fa:	b7d1                	j	9be <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9fc:	6398                	ld	a4,0(a5)
 9fe:	e118                	sd	a4,0(a0)
 a00:	a899                	j	a56 <malloc+0xd0>
  hp->s.size = nu;
 a02:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a06:	0541                	addi	a0,a0,16
 a08:	ef9ff0ef          	jal	900 <free>
  return freep;
 a0c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a0e:	c125                	beqz	a0,a6e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a10:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a12:	4798                	lw	a4,8(a5)
 a14:	03277163          	bgeu	a4,s2,a36 <malloc+0xb0>
    if(p == freep)
 a18:	6098                	ld	a4,0(s1)
 a1a:	853e                	mv	a0,a5
 a1c:	fef71ae3          	bne	a4,a5,a10 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a20:	8552                	mv	a0,s4
 a22:	8c7ff0ef          	jal	2e8 <sbrk>
  if(p == SBRK_ERROR)
 a26:	fd551ee3          	bne	a0,s5,a02 <malloc+0x7c>
        return 0;
 a2a:	4501                	li	a0,0
 a2c:	74a2                	ld	s1,40(sp)
 a2e:	6a42                	ld	s4,16(sp)
 a30:	6aa2                	ld	s5,8(sp)
 a32:	6b02                	ld	s6,0(sp)
 a34:	a03d                	j	a62 <malloc+0xdc>
 a36:	74a2                	ld	s1,40(sp)
 a38:	6a42                	ld	s4,16(sp)
 a3a:	6aa2                	ld	s5,8(sp)
 a3c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a3e:	fae90fe3          	beq	s2,a4,9fc <malloc+0x76>
        p->s.size -= nunits;
 a42:	4137073b          	subw	a4,a4,s3
 a46:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a48:	02071693          	slli	a3,a4,0x20
 a4c:	01c6d713          	srli	a4,a3,0x1c
 a50:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a52:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a56:	00000717          	auipc	a4,0x0
 a5a:	5aa73523          	sd	a0,1450(a4) # 1000 <freep>
      return (void*)(p + 1);
 a5e:	01078513          	addi	a0,a5,16
  }
}
 a62:	70e2                	ld	ra,56(sp)
 a64:	7442                	ld	s0,48(sp)
 a66:	7902                	ld	s2,32(sp)
 a68:	69e2                	ld	s3,24(sp)
 a6a:	6121                	addi	sp,sp,64
 a6c:	8082                	ret
 a6e:	74a2                	ld	s1,40(sp)
 a70:	6a42                	ld	s4,16(sp)
 a72:	6aa2                	ld	s5,8(sp)
 a74:	6b02                	ld	s6,0(sp)
 a76:	b7f5                	j	a62 <malloc+0xdc>
