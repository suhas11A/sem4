
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	a7058593          	addi	a1,a1,-1424 # a80 <malloc+0x100>
  18:	4509                	li	a0,2
  1a:	085000ef          	jal	89e <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	46e000ef          	jal	48e <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	4c2000ef          	jal	4ee <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	458000ef          	jal	48e <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	a5a58593          	addi	a1,a1,-1446 # a98 <malloc+0x118>
  46:	4509                	li	a0,2
  48:	057000ef          	jal	89e <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  56:	fabff0ef          	jal	0 <main>
  exit(r);
  5a:	434000ef          	jal	48e <exit>

000000000000005e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0xa>
    ;
  return os;
}
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x20>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x20>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf99                	beqz	a5,d8 <strlen+0x2a>
  bc:	0505                	addi	a0,a0,1
  be:	87aa                	mv	a5,a0
  c0:	86be                	mv	a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	ff65                	bnez	a4,c0 <strlen+0x12>
  ca:	40a6853b          	subw	a0,a3,a0
  ce:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret
  for(n = 0; s[n]; n++)
  d8:	4501                	li	a0,0
  da:	bfdd                	j	d0 <strlen+0x22>

00000000000000dc <memset>:

void*
memset(void *dst, int c, uint n)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e4:	ca19                	beqz	a2,fa <memset+0x1e>
  e6:	87aa                	mv	a5,a0
  e8:	1602                	slli	a2,a2,0x20
  ea:	9201                	srli	a2,a2,0x20
  ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f4:	0785                	addi	a5,a5,1
  f6:	fee79de3          	bne	a5,a4,f0 <memset+0x14>
  }
  return dst;
}
  fa:	60a2                	ld	ra,8(sp)
  fc:	6402                	ld	s0,0(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret

0000000000000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  for(; *s; s++)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cf81                	beqz	a5,126 <strchr+0x24>
    if(*s == c)
 110:	00f58763          	beq	a1,a5,11e <strchr+0x1c>
  for(; *s; s++)
 114:	0505                	addi	a0,a0,1
 116:	00054783          	lbu	a5,0(a0)
 11a:	fbfd                	bnez	a5,110 <strchr+0xe>
      return (char*)s;
  return 0;
 11c:	4501                	li	a0,0
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret
  return 0;
 126:	4501                	li	a0,0
 128:	bfdd                	j	11e <strchr+0x1c>

000000000000012a <gets>:

char*
gets(char *buf, int max)
{
 12a:	7159                	addi	sp,sp,-112
 12c:	f486                	sd	ra,104(sp)
 12e:	f0a2                	sd	s0,96(sp)
 130:	eca6                	sd	s1,88(sp)
 132:	e8ca                	sd	s2,80(sp)
 134:	e4ce                	sd	s3,72(sp)
 136:	e0d2                	sd	s4,64(sp)
 138:	fc56                	sd	s5,56(sp)
 13a:	f85a                	sd	s6,48(sp)
 13c:	f45e                	sd	s7,40(sp)
 13e:	f062                	sd	s8,32(sp)
 140:	ec66                	sd	s9,24(sp)
 142:	e86a                	sd	s10,16(sp)
 144:	1880                	addi	s0,sp,112
 146:	8caa                	mv	s9,a0
 148:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14a:	892a                	mv	s2,a0
 14c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 14e:	f9f40b13          	addi	s6,s0,-97
 152:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 154:	4ba9                	li	s7,10
 156:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 158:	8d26                	mv	s10,s1
 15a:	0014899b          	addiw	s3,s1,1
 15e:	84ce                	mv	s1,s3
 160:	0349d563          	bge	s3,s4,18a <gets+0x60>
    cc = read(0, &c, 1);
 164:	8656                	mv	a2,s5
 166:	85da                	mv	a1,s6
 168:	4501                	li	a0,0
 16a:	33c000ef          	jal	4a6 <read>
    if(cc < 1)
 16e:	00a05e63          	blez	a0,18a <gets+0x60>
    buf[i++] = c;
 172:	f9f44783          	lbu	a5,-97(s0)
 176:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17a:	01778763          	beq	a5,s7,188 <gets+0x5e>
 17e:	0905                	addi	s2,s2,1
 180:	fd879ce3          	bne	a5,s8,158 <gets+0x2e>
    buf[i++] = c;
 184:	8d4e                	mv	s10,s3
 186:	a011                	j	18a <gets+0x60>
 188:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 18a:	9d66                	add	s10,s10,s9
 18c:	000d0023          	sb	zero,0(s10)
  return buf;
}
 190:	8566                	mv	a0,s9
 192:	70a6                	ld	ra,104(sp)
 194:	7406                	ld	s0,96(sp)
 196:	64e6                	ld	s1,88(sp)
 198:	6946                	ld	s2,80(sp)
 19a:	69a6                	ld	s3,72(sp)
 19c:	6a06                	ld	s4,64(sp)
 19e:	7ae2                	ld	s5,56(sp)
 1a0:	7b42                	ld	s6,48(sp)
 1a2:	7ba2                	ld	s7,40(sp)
 1a4:	7c02                	ld	s8,32(sp)
 1a6:	6ce2                	ld	s9,24(sp)
 1a8:	6d42                	ld	s10,16(sp)
 1aa:	6165                	addi	sp,sp,112
 1ac:	8082                	ret

00000000000001ae <stat>:

int
stat(const char *n, struct stat *st)
{
 1ae:	1101                	addi	sp,sp,-32
 1b0:	ec06                	sd	ra,24(sp)
 1b2:	e822                	sd	s0,16(sp)
 1b4:	e04a                	sd	s2,0(sp)
 1b6:	1000                	addi	s0,sp,32
 1b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ba:	4581                	li	a1,0
 1bc:	312000ef          	jal	4ce <open>
  if(fd < 0)
 1c0:	02054263          	bltz	a0,1e4 <stat+0x36>
 1c4:	e426                	sd	s1,8(sp)
 1c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c8:	85ca                	mv	a1,s2
 1ca:	31c000ef          	jal	4e6 <fstat>
 1ce:	892a                	mv	s2,a0
  close(fd);
 1d0:	8526                	mv	a0,s1
 1d2:	2e4000ef          	jal	4b6 <close>
  return r;
 1d6:	64a2                	ld	s1,8(sp)
}
 1d8:	854a                	mv	a0,s2
 1da:	60e2                	ld	ra,24(sp)
 1dc:	6442                	ld	s0,16(sp)
 1de:	6902                	ld	s2,0(sp)
 1e0:	6105                	addi	sp,sp,32
 1e2:	8082                	ret
    return -1;
 1e4:	597d                	li	s2,-1
 1e6:	bfcd                	j	1d8 <stat+0x2a>

00000000000001e8 <atoi>:

int
atoi(const char *s)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e406                	sd	ra,8(sp)
 1ec:	e022                	sd	s0,0(sp)
 1ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f0:	00054683          	lbu	a3,0(a0)
 1f4:	fd06879b          	addiw	a5,a3,-48
 1f8:	0ff7f793          	zext.b	a5,a5
 1fc:	4625                	li	a2,9
 1fe:	02f66963          	bltu	a2,a5,230 <atoi+0x48>
 202:	872a                	mv	a4,a0
  n = 0;
 204:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 206:	0705                	addi	a4,a4,1
 208:	0025179b          	slliw	a5,a0,0x2
 20c:	9fa9                	addw	a5,a5,a0
 20e:	0017979b          	slliw	a5,a5,0x1
 212:	9fb5                	addw	a5,a5,a3
 214:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 218:	00074683          	lbu	a3,0(a4)
 21c:	fd06879b          	addiw	a5,a3,-48
 220:	0ff7f793          	zext.b	a5,a5
 224:	fef671e3          	bgeu	a2,a5,206 <atoi+0x1e>
  return n;
}
 228:	60a2                	ld	ra,8(sp)
 22a:	6402                	ld	s0,0(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
  n = 0;
 230:	4501                	li	a0,0
 232:	bfdd                	j	228 <atoi+0x40>

0000000000000234 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e406                	sd	ra,8(sp)
 238:	e022                	sd	s0,0(sp)
 23a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23c:	02b57563          	bgeu	a0,a1,266 <memmove+0x32>
    while(n-- > 0)
 240:	00c05f63          	blez	a2,25e <memmove+0x2a>
 244:	1602                	slli	a2,a2,0x20
 246:	9201                	srli	a2,a2,0x20
 248:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24c:	872a                	mv	a4,a0
      *dst++ = *src++;
 24e:	0585                	addi	a1,a1,1
 250:	0705                	addi	a4,a4,1
 252:	fff5c683          	lbu	a3,-1(a1)
 256:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25a:	fee79ae3          	bne	a5,a4,24e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25e:	60a2                	ld	ra,8(sp)
 260:	6402                	ld	s0,0(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
    dst += n;
 266:	00c50733          	add	a4,a0,a2
    src += n;
 26a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 26c:	fec059e3          	blez	a2,25e <memmove+0x2a>
 270:	fff6079b          	addiw	a5,a2,-1
 274:	1782                	slli	a5,a5,0x20
 276:	9381                	srli	a5,a5,0x20
 278:	fff7c793          	not	a5,a5
 27c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27e:	15fd                	addi	a1,a1,-1
 280:	177d                	addi	a4,a4,-1
 282:	0005c683          	lbu	a3,0(a1)
 286:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 28a:	fef71ae3          	bne	a4,a5,27e <memmove+0x4a>
 28e:	bfc1                	j	25e <memmove+0x2a>

0000000000000290 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 298:	ca0d                	beqz	a2,2ca <memcmp+0x3a>
 29a:	fff6069b          	addiw	a3,a2,-1
 29e:	1682                	slli	a3,a3,0x20
 2a0:	9281                	srli	a3,a3,0x20
 2a2:	0685                	addi	a3,a3,1
 2a4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	0005c703          	lbu	a4,0(a1)
 2ae:	00e79863          	bne	a5,a4,2be <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2b2:	0505                	addi	a0,a0,1
    p2++;
 2b4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b6:	fed518e3          	bne	a0,a3,2a6 <memcmp+0x16>
  }
  return 0;
 2ba:	4501                	li	a0,0
 2bc:	a019                	j	2c2 <memcmp+0x32>
      return *p1 - *p2;
 2be:	40e7853b          	subw	a0,a5,a4
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  return 0;
 2ca:	4501                	li	a0,0
 2cc:	bfdd                	j	2c2 <memcmp+0x32>

00000000000002ce <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d6:	f5fff0ef          	jal	234 <memmove>
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <sbrk>:

char *
sbrk(int n) {
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e406                	sd	ra,8(sp)
 2e6:	e022                	sd	s0,0(sp)
 2e8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2ea:	4585                	li	a1,1
 2ec:	22a000ef          	jal	516 <sys_sbrk>
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <sbrklazy>:

char *
sbrklazy(int n) {
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e406                	sd	ra,8(sp)
 2fc:	e022                	sd	s0,0(sp)
 2fe:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 300:	4589                	li	a1,2
 302:	214000ef          	jal	516 <sys_sbrk>
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 30e:	1101                	addi	sp,sp,-32
 310:	ec06                	sd	ra,24(sp)
 312:	e822                	sd	s0,16(sp)
 314:	e426                	sd	s1,8(sp)
 316:	e04a                	sd	s2,0(sp)
 318:	1000                	addi	s0,sp,32
 31a:	84aa                	mv	s1,a0
 31c:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 31e:	6505                	lui	a0,0x1
 320:	fc3ff0ef          	jal	2e2 <sbrk>
 324:	6785                	lui	a5,0x1
 326:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 32a:	9a41                	andi	a2,a2,-16
 32c:	85ca                	mv	a1,s2
 32e:	8526                	mv	a0,s1
 330:	1fe000ef          	jal	52e <clone>
}
 334:	60e2                	ld	ra,24(sp)
 336:	6442                	ld	s0,16(sp)
 338:	64a2                	ld	s1,8(sp)
 33a:	6902                	ld	s2,0(sp)
 33c:	6105                	addi	sp,sp,32
 33e:	8082                	ret

0000000000000340 <futex>:

void futex(int *uaddr, int ops, int val) {
 340:	7179                	addi	sp,sp,-48
 342:	f406                	sd	ra,40(sp)
 344:	f022                	sd	s0,32(sp)
 346:	ec26                	sd	s1,24(sp)
 348:	1800                	addi	s0,sp,48
 34a:	84aa                	mv	s1,a0
  if (ops==0) {
 34c:	ed95                	bnez	a1,388 <futex+0x48>
    if (val==0) {
 34e:	c611                	beqz	a2,35a <futex+0x1a>
 350:	e84a                	sd	s2,16(sp)
 352:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 354:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 356:	4985                	li	s3,1
 358:	a005                	j	378 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 35a:	4705                	li	a4,1
 35c:	87ba                	mv	a5,a4
 35e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 362:	2781                	sext.w	a5,a5
 364:	ffe5                	bnez	a5,35c <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 366:	70a2                	ld	ra,40(sp)
 368:	7402                	ld	s0,32(sp)
 36a:	64e2                	ld	s1,24(sp)
 36c:	6145                	addi	sp,sp,48
 36e:	8082                	ret
        futex_wait(uaddr, 1);
 370:	85ce                	mv	a1,s3
 372:	8526                	mv	a0,s1
 374:	1ca000ef          	jal	53e <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 378:	87ca                	mv	a5,s2
 37a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 37e:	2781                	sext.w	a5,a5
 380:	fbe5                	bnez	a5,370 <futex+0x30>
 382:	6942                	ld	s2,16(sp)
 384:	69a2                	ld	s3,8(sp)
 386:	b7c5                	j	366 <futex+0x26>
    if (val==0) {
 388:	e611                	bnez	a2,394 <futex+0x54>
      __sync_lock_release(uaddr);
 38a:	0310000f          	fence	rw,w
 38e:	00052023          	sw	zero,0(a0) # 1000 <freep>
 392:	bfd1                	j	366 <futex+0x26>
      __sync_lock_release(uaddr);
 394:	0310000f          	fence	rw,w
 398:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 39c:	1aa000ef          	jal	546 <futex_wake>
  return;
 3a0:	b7d9                	j	366 <futex+0x26>

00000000000003a2 <sem_init>:

void sem_init(sem_t* s, int val) {
 3a2:	7179                	addi	sp,sp,-48
 3a4:	f406                	sd	ra,40(sp)
 3a6:	f022                	sd	s0,32(sp)
 3a8:	ec26                	sd	s1,24(sp)
 3aa:	e84a                	sd	s2,16(sp)
 3ac:	e44e                	sd	s3,8(sp)
 3ae:	1800                	addi	s0,sp,48
 3b0:	84aa                	mv	s1,a0
 3b2:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 3b4:	00450993          	addi	s3,a0,4
 3b8:	4605                	li	a2,1
 3ba:	4581                	li	a1,0
 3bc:	854e                	mv	a0,s3
 3be:	f83ff0ef          	jal	340 <futex>
  s->value = val;
 3c2:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 3c6:	4605                	li	a2,1
 3c8:	85b2                	mv	a1,a2
 3ca:	854e                	mv	a0,s3
 3cc:	f75ff0ef          	jal	340 <futex>
  return;
}
 3d0:	70a2                	ld	ra,40(sp)
 3d2:	7402                	ld	s0,32(sp)
 3d4:	64e2                	ld	s1,24(sp)
 3d6:	6942                	ld	s2,16(sp)
 3d8:	69a2                	ld	s3,8(sp)
 3da:	6145                	addi	sp,sp,48
 3dc:	8082                	ret

00000000000003de <sem_down>:

void sem_down(sem_t* s) {
 3de:	7179                	addi	sp,sp,-48
 3e0:	f406                	sd	ra,40(sp)
 3e2:	f022                	sd	s0,32(sp)
 3e4:	ec26                	sd	s1,24(sp)
 3e6:	e84a                	sd	s2,16(sp)
 3e8:	e44e                	sd	s3,8(sp)
 3ea:	1800                	addi	s0,sp,48
 3ec:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 3ee:	00450993          	addi	s3,a0,4
 3f2:	4605                	li	a2,1
 3f4:	4581                	li	a1,0
 3f6:	854e                	mv	a0,s3
 3f8:	f49ff0ef          	jal	340 <futex>
  while(1) {
    if (s->value>0) {
 3fc:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 400:	4485                	li	s1,1
    if (s->value>0) {
 402:	02f04463          	bgtz	a5,42a <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 406:	8626                	mv	a2,s1
 408:	85a6                	mv	a1,s1
 40a:	854e                	mv	a0,s3
 40c:	f35ff0ef          	jal	340 <futex>
      futex_wait(&s->value,1);
 410:	85a6                	mv	a1,s1
 412:	854a                	mv	a0,s2
 414:	12a000ef          	jal	53e <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 418:	8626                	mv	a2,s1
 41a:	4581                	li	a1,0
 41c:	854e                	mv	a0,s3
 41e:	f23ff0ef          	jal	340 <futex>
    if (s->value>0) {
 422:	00092783          	lw	a5,0(s2)
 426:	fef050e3          	blez	a5,406 <sem_down+0x28>
      s->value--;
 42a:	37fd                	addiw	a5,a5,-1 # fff <digits+0x547>
 42c:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 430:	4605                	li	a2,1
 432:	85b2                	mv	a1,a2
 434:	854e                	mv	a0,s3
 436:	f0bff0ef          	jal	340 <futex>
  return;
}
 43a:	70a2                	ld	ra,40(sp)
 43c:	7402                	ld	s0,32(sp)
 43e:	64e2                	ld	s1,24(sp)
 440:	6942                	ld	s2,16(sp)
 442:	69a2                	ld	s3,8(sp)
 444:	6145                	addi	sp,sp,48
 446:	8082                	ret

0000000000000448 <sem_up>:

void sem_up(sem_t* s) {
 448:	1101                	addi	sp,sp,-32
 44a:	ec06                	sd	ra,24(sp)
 44c:	e822                	sd	s0,16(sp)
 44e:	e426                	sd	s1,8(sp)
 450:	e04a                	sd	s2,0(sp)
 452:	1000                	addi	s0,sp,32
 454:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 456:	00450913          	addi	s2,a0,4
 45a:	4605                	li	a2,1
 45c:	4581                	li	a1,0
 45e:	854a                	mv	a0,s2
 460:	ee1ff0ef          	jal	340 <futex>
  s->value++;
 464:	409c                	lw	a5,0(s1)
 466:	2785                	addiw	a5,a5,1
 468:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 46a:	8526                	mv	a0,s1
 46c:	0da000ef          	jal	546 <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 470:	4605                	li	a2,1
 472:	85b2                	mv	a1,a2
 474:	854a                	mv	a0,s2
 476:	ecbff0ef          	jal	340 <futex>
  return;
 47a:	60e2                	ld	ra,24(sp)
 47c:	6442                	ld	s0,16(sp)
 47e:	64a2                	ld	s1,8(sp)
 480:	6902                	ld	s2,0(sp)
 482:	6105                	addi	sp,sp,32
 484:	8082                	ret

0000000000000486 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 486:	4885                	li	a7,1
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <exit>:
.global exit
exit:
 li a7, SYS_exit
 48e:	4889                	li	a7,2
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <wait>:
.global wait
wait:
 li a7, SYS_wait
 496:	488d                	li	a7,3
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 49e:	4891                	li	a7,4
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <read>:
.global read
read:
 li a7, SYS_read
 4a6:	4895                	li	a7,5
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <write>:
.global write
write:
 li a7, SYS_write
 4ae:	48c1                	li	a7,16
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <close>:
.global close
close:
 li a7, SYS_close
 4b6:	48d5                	li	a7,21
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <kill>:
.global kill
kill:
 li a7, SYS_kill
 4be:	4899                	li	a7,6
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c6:	489d                	li	a7,7
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <open>:
.global open
open:
 li a7, SYS_open
 4ce:	48bd                	li	a7,15
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4d6:	48c5                	li	a7,17
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4de:	48c9                	li	a7,18
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e6:	48a1                	li	a7,8
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <link>:
.global link
link:
 li a7, SYS_link
 4ee:	48cd                	li	a7,19
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4f6:	48d1                	li	a7,20
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4fe:	48a5                	li	a7,9
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <dup>:
.global dup
dup:
 li a7, SYS_dup
 506:	48a9                	li	a7,10
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 50e:	48ad                	li	a7,11
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 516:	48b1                	li	a7,12
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <pause>:
.global pause
pause:
 li a7, SYS_pause
 51e:	48b5                	li	a7,13
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 526:	48b9                	li	a7,14
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <clone>:
.global clone
clone:
 li a7, SYS_clone
 52e:	48d9                	li	a7,22
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <join>:
.global join
join:
 li a7, SYS_join
 536:	48dd                	li	a7,23
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 53e:	48e1                	li	a7,24
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 546:	48e5                	li	a7,25
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 54e:	1101                	addi	sp,sp,-32
 550:	ec06                	sd	ra,24(sp)
 552:	e822                	sd	s0,16(sp)
 554:	1000                	addi	s0,sp,32
 556:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 55a:	4605                	li	a2,1
 55c:	fef40593          	addi	a1,s0,-17
 560:	f4fff0ef          	jal	4ae <write>
}
 564:	60e2                	ld	ra,24(sp)
 566:	6442                	ld	s0,16(sp)
 568:	6105                	addi	sp,sp,32
 56a:	8082                	ret

000000000000056c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 56c:	715d                	addi	sp,sp,-80
 56e:	e486                	sd	ra,72(sp)
 570:	e0a2                	sd	s0,64(sp)
 572:	fc26                	sd	s1,56(sp)
 574:	f84a                	sd	s2,48(sp)
 576:	f44e                	sd	s3,40(sp)
 578:	0880                	addi	s0,sp,80
 57a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 57c:	c299                	beqz	a3,582 <printint+0x16>
 57e:	0605cc63          	bltz	a1,5f6 <printint+0x8a>
  neg = 0;
 582:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 584:	fb840313          	addi	t1,s0,-72
  neg = 0;
 588:	869a                	mv	a3,t1
  i = 0;
 58a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 58c:	00000817          	auipc	a6,0x0
 590:	52c80813          	addi	a6,a6,1324 # ab8 <digits>
 594:	88be                	mv	a7,a5
 596:	0017851b          	addiw	a0,a5,1
 59a:	87aa                	mv	a5,a0
 59c:	02c5f733          	remu	a4,a1,a2
 5a0:	9742                	add	a4,a4,a6
 5a2:	00074703          	lbu	a4,0(a4)
 5a6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5aa:	872e                	mv	a4,a1
 5ac:	02c5d5b3          	divu	a1,a1,a2
 5b0:	0685                	addi	a3,a3,1
 5b2:	fec771e3          	bgeu	a4,a2,594 <printint+0x28>
  if(neg)
 5b6:	000e0c63          	beqz	t3,5ce <printint+0x62>
    buf[i++] = '-';
 5ba:	fd050793          	addi	a5,a0,-48
 5be:	00878533          	add	a0,a5,s0
 5c2:	02d00793          	li	a5,45
 5c6:	fef50423          	sb	a5,-24(a0)
 5ca:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 5ce:	fff7899b          	addiw	s3,a5,-1
 5d2:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 5d6:	fff4c583          	lbu	a1,-1(s1)
 5da:	854a                	mv	a0,s2
 5dc:	f73ff0ef          	jal	54e <putc>
  while(--i >= 0)
 5e0:	39fd                	addiw	s3,s3,-1
 5e2:	14fd                	addi	s1,s1,-1
 5e4:	fe09d9e3          	bgez	s3,5d6 <printint+0x6a>
}
 5e8:	60a6                	ld	ra,72(sp)
 5ea:	6406                	ld	s0,64(sp)
 5ec:	74e2                	ld	s1,56(sp)
 5ee:	7942                	ld	s2,48(sp)
 5f0:	79a2                	ld	s3,40(sp)
 5f2:	6161                	addi	sp,sp,80
 5f4:	8082                	ret
    x = -xx;
 5f6:	40b005b3          	neg	a1,a1
    neg = 1;
 5fa:	4e05                	li	t3,1
    x = -xx;
 5fc:	b761                	j	584 <printint+0x18>

00000000000005fe <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5fe:	711d                	addi	sp,sp,-96
 600:	ec86                	sd	ra,88(sp)
 602:	e8a2                	sd	s0,80(sp)
 604:	e4a6                	sd	s1,72(sp)
 606:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 608:	0005c483          	lbu	s1,0(a1)
 60c:	28048463          	beqz	s1,894 <vprintf+0x296>
 610:	e0ca                	sd	s2,64(sp)
 612:	fc4e                	sd	s3,56(sp)
 614:	f852                	sd	s4,48(sp)
 616:	f456                	sd	s5,40(sp)
 618:	f05a                	sd	s6,32(sp)
 61a:	ec5e                	sd	s7,24(sp)
 61c:	e862                	sd	s8,16(sp)
 61e:	e466                	sd	s9,8(sp)
 620:	8b2a                	mv	s6,a0
 622:	8a2e                	mv	s4,a1
 624:	8bb2                	mv	s7,a2
  state = 0;
 626:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 628:	4901                	li	s2,0
 62a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 62c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 630:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 634:	06c00c93          	li	s9,108
 638:	a00d                	j	65a <vprintf+0x5c>
        putc(fd, c0);
 63a:	85a6                	mv	a1,s1
 63c:	855a                	mv	a0,s6
 63e:	f11ff0ef          	jal	54e <putc>
 642:	a019                	j	648 <vprintf+0x4a>
    } else if(state == '%'){
 644:	03598363          	beq	s3,s5,66a <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 648:	0019079b          	addiw	a5,s2,1
 64c:	893e                	mv	s2,a5
 64e:	873e                	mv	a4,a5
 650:	97d2                	add	a5,a5,s4
 652:	0007c483          	lbu	s1,0(a5)
 656:	22048763          	beqz	s1,884 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 65a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 65e:	fe0993e3          	bnez	s3,644 <vprintf+0x46>
      if(c0 == '%'){
 662:	fd579ce3          	bne	a5,s5,63a <vprintf+0x3c>
        state = '%';
 666:	89be                	mv	s3,a5
 668:	b7c5                	j	648 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 66a:	00ea06b3          	add	a3,s4,a4
 66e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 672:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 674:	c681                	beqz	a3,67c <vprintf+0x7e>
 676:	9752                	add	a4,a4,s4
 678:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 67c:	05878263          	beq	a5,s8,6c0 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 680:	05978c63          	beq	a5,s9,6d8 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 684:	07500713          	li	a4,117
 688:	0ee78663          	beq	a5,a4,774 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 68c:	07800713          	li	a4,120
 690:	12e78863          	beq	a5,a4,7c0 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 694:	07000713          	li	a4,112
 698:	14e78d63          	beq	a5,a4,7f2 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 69c:	06300713          	li	a4,99
 6a0:	18e78c63          	beq	a5,a4,838 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 6a4:	07300713          	li	a4,115
 6a8:	1ae78263          	beq	a5,a4,84c <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6ac:	02500713          	li	a4,37
 6b0:	04e79463          	bne	a5,a4,6f8 <vprintf+0xfa>
        putc(fd, '%');
 6b4:	85ba                	mv	a1,a4
 6b6:	855a                	mv	a0,s6
 6b8:	e97ff0ef          	jal	54e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 6bc:	4981                	li	s3,0
 6be:	b769                	j	648 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6c0:	008b8493          	addi	s1,s7,8
 6c4:	4685                	li	a3,1
 6c6:	4629                	li	a2,10
 6c8:	000ba583          	lw	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	e9fff0ef          	jal	56c <printint>
 6d2:	8ba6                	mv	s7,s1
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bf8d                	j	648 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6d8:	06400793          	li	a5,100
 6dc:	02f68963          	beq	a3,a5,70e <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e0:	06c00793          	li	a5,108
 6e4:	04f68263          	beq	a3,a5,728 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 6e8:	07500793          	li	a5,117
 6ec:	0af68063          	beq	a3,a5,78c <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 6f0:	07800793          	li	a5,120
 6f4:	0ef68263          	beq	a3,a5,7d8 <vprintf+0x1da>
        putc(fd, '%');
 6f8:	02500593          	li	a1,37
 6fc:	855a                	mv	a0,s6
 6fe:	e51ff0ef          	jal	54e <putc>
        putc(fd, c0);
 702:	85a6                	mv	a1,s1
 704:	855a                	mv	a0,s6
 706:	e49ff0ef          	jal	54e <putc>
      state = 0;
 70a:	4981                	li	s3,0
 70c:	bf35                	j	648 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 70e:	008b8493          	addi	s1,s7,8
 712:	4685                	li	a3,1
 714:	4629                	li	a2,10
 716:	000bb583          	ld	a1,0(s7)
 71a:	855a                	mv	a0,s6
 71c:	e51ff0ef          	jal	56c <printint>
        i += 1;
 720:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 722:	8ba6                	mv	s7,s1
      state = 0;
 724:	4981                	li	s3,0
        i += 1;
 726:	b70d                	j	648 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 728:	06400793          	li	a5,100
 72c:	02f60763          	beq	a2,a5,75a <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 730:	07500793          	li	a5,117
 734:	06f60963          	beq	a2,a5,7a6 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 738:	07800793          	li	a5,120
 73c:	faf61ee3          	bne	a2,a5,6f8 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 740:	008b8493          	addi	s1,s7,8
 744:	4681                	li	a3,0
 746:	4641                	li	a2,16
 748:	000bb583          	ld	a1,0(s7)
 74c:	855a                	mv	a0,s6
 74e:	e1fff0ef          	jal	56c <printint>
        i += 2;
 752:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 754:	8ba6                	mv	s7,s1
      state = 0;
 756:	4981                	li	s3,0
        i += 2;
 758:	bdc5                	j	648 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 75a:	008b8493          	addi	s1,s7,8
 75e:	4685                	li	a3,1
 760:	4629                	li	a2,10
 762:	000bb583          	ld	a1,0(s7)
 766:	855a                	mv	a0,s6
 768:	e05ff0ef          	jal	56c <printint>
        i += 2;
 76c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 76e:	8ba6                	mv	s7,s1
      state = 0;
 770:	4981                	li	s3,0
        i += 2;
 772:	bdd9                	j	648 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 774:	008b8493          	addi	s1,s7,8
 778:	4681                	li	a3,0
 77a:	4629                	li	a2,10
 77c:	000be583          	lwu	a1,0(s7)
 780:	855a                	mv	a0,s6
 782:	debff0ef          	jal	56c <printint>
 786:	8ba6                	mv	s7,s1
      state = 0;
 788:	4981                	li	s3,0
 78a:	bd7d                	j	648 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 78c:	008b8493          	addi	s1,s7,8
 790:	4681                	li	a3,0
 792:	4629                	li	a2,10
 794:	000bb583          	ld	a1,0(s7)
 798:	855a                	mv	a0,s6
 79a:	dd3ff0ef          	jal	56c <printint>
        i += 1;
 79e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a0:	8ba6                	mv	s7,s1
      state = 0;
 7a2:	4981                	li	s3,0
        i += 1;
 7a4:	b555                	j	648 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a6:	008b8493          	addi	s1,s7,8
 7aa:	4681                	li	a3,0
 7ac:	4629                	li	a2,10
 7ae:	000bb583          	ld	a1,0(s7)
 7b2:	855a                	mv	a0,s6
 7b4:	db9ff0ef          	jal	56c <printint>
        i += 2;
 7b8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ba:	8ba6                	mv	s7,s1
      state = 0;
 7bc:	4981                	li	s3,0
        i += 2;
 7be:	b569                	j	648 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7c0:	008b8493          	addi	s1,s7,8
 7c4:	4681                	li	a3,0
 7c6:	4641                	li	a2,16
 7c8:	000be583          	lwu	a1,0(s7)
 7cc:	855a                	mv	a0,s6
 7ce:	d9fff0ef          	jal	56c <printint>
 7d2:	8ba6                	mv	s7,s1
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	bd8d                	j	648 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d8:	008b8493          	addi	s1,s7,8
 7dc:	4681                	li	a3,0
 7de:	4641                	li	a2,16
 7e0:	000bb583          	ld	a1,0(s7)
 7e4:	855a                	mv	a0,s6
 7e6:	d87ff0ef          	jal	56c <printint>
        i += 1;
 7ea:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ec:	8ba6                	mv	s7,s1
      state = 0;
 7ee:	4981                	li	s3,0
        i += 1;
 7f0:	bda1                	j	648 <vprintf+0x4a>
 7f2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7f4:	008b8d13          	addi	s10,s7,8
 7f8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7fc:	03000593          	li	a1,48
 800:	855a                	mv	a0,s6
 802:	d4dff0ef          	jal	54e <putc>
  putc(fd, 'x');
 806:	07800593          	li	a1,120
 80a:	855a                	mv	a0,s6
 80c:	d43ff0ef          	jal	54e <putc>
 810:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 812:	00000b97          	auipc	s7,0x0
 816:	2a6b8b93          	addi	s7,s7,678 # ab8 <digits>
 81a:	03c9d793          	srli	a5,s3,0x3c
 81e:	97de                	add	a5,a5,s7
 820:	0007c583          	lbu	a1,0(a5)
 824:	855a                	mv	a0,s6
 826:	d29ff0ef          	jal	54e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 82a:	0992                	slli	s3,s3,0x4
 82c:	34fd                	addiw	s1,s1,-1
 82e:	f4f5                	bnez	s1,81a <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 830:	8bea                	mv	s7,s10
      state = 0;
 832:	4981                	li	s3,0
 834:	6d02                	ld	s10,0(sp)
 836:	bd09                	j	648 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 838:	008b8493          	addi	s1,s7,8
 83c:	000bc583          	lbu	a1,0(s7)
 840:	855a                	mv	a0,s6
 842:	d0dff0ef          	jal	54e <putc>
 846:	8ba6                	mv	s7,s1
      state = 0;
 848:	4981                	li	s3,0
 84a:	bbfd                	j	648 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 84c:	008b8993          	addi	s3,s7,8
 850:	000bb483          	ld	s1,0(s7)
 854:	cc91                	beqz	s1,870 <vprintf+0x272>
        for(; *s; s++)
 856:	0004c583          	lbu	a1,0(s1)
 85a:	c195                	beqz	a1,87e <vprintf+0x280>
          putc(fd, *s);
 85c:	855a                	mv	a0,s6
 85e:	cf1ff0ef          	jal	54e <putc>
        for(; *s; s++)
 862:	0485                	addi	s1,s1,1
 864:	0004c583          	lbu	a1,0(s1)
 868:	f9f5                	bnez	a1,85c <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 86a:	8bce                	mv	s7,s3
      state = 0;
 86c:	4981                	li	s3,0
 86e:	bbe9                	j	648 <vprintf+0x4a>
          s = "(null)";
 870:	00000497          	auipc	s1,0x0
 874:	24048493          	addi	s1,s1,576 # ab0 <malloc+0x130>
        for(; *s; s++)
 878:	02800593          	li	a1,40
 87c:	b7c5                	j	85c <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 87e:	8bce                	mv	s7,s3
      state = 0;
 880:	4981                	li	s3,0
 882:	b3d9                	j	648 <vprintf+0x4a>
 884:	6906                	ld	s2,64(sp)
 886:	79e2                	ld	s3,56(sp)
 888:	7a42                	ld	s4,48(sp)
 88a:	7aa2                	ld	s5,40(sp)
 88c:	7b02                	ld	s6,32(sp)
 88e:	6be2                	ld	s7,24(sp)
 890:	6c42                	ld	s8,16(sp)
 892:	6ca2                	ld	s9,8(sp)
    }
  }
}
 894:	60e6                	ld	ra,88(sp)
 896:	6446                	ld	s0,80(sp)
 898:	64a6                	ld	s1,72(sp)
 89a:	6125                	addi	sp,sp,96
 89c:	8082                	ret

000000000000089e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 89e:	715d                	addi	sp,sp,-80
 8a0:	ec06                	sd	ra,24(sp)
 8a2:	e822                	sd	s0,16(sp)
 8a4:	1000                	addi	s0,sp,32
 8a6:	e010                	sd	a2,0(s0)
 8a8:	e414                	sd	a3,8(s0)
 8aa:	e818                	sd	a4,16(s0)
 8ac:	ec1c                	sd	a5,24(s0)
 8ae:	03043023          	sd	a6,32(s0)
 8b2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8b6:	8622                	mv	a2,s0
 8b8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8bc:	d43ff0ef          	jal	5fe <vprintf>
}
 8c0:	60e2                	ld	ra,24(sp)
 8c2:	6442                	ld	s0,16(sp)
 8c4:	6161                	addi	sp,sp,80
 8c6:	8082                	ret

00000000000008c8 <printf>:

void
printf(const char *fmt, ...)
{
 8c8:	711d                	addi	sp,sp,-96
 8ca:	ec06                	sd	ra,24(sp)
 8cc:	e822                	sd	s0,16(sp)
 8ce:	1000                	addi	s0,sp,32
 8d0:	e40c                	sd	a1,8(s0)
 8d2:	e810                	sd	a2,16(s0)
 8d4:	ec14                	sd	a3,24(s0)
 8d6:	f018                	sd	a4,32(s0)
 8d8:	f41c                	sd	a5,40(s0)
 8da:	03043823          	sd	a6,48(s0)
 8de:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8e2:	00840613          	addi	a2,s0,8
 8e6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8ea:	85aa                	mv	a1,a0
 8ec:	4505                	li	a0,1
 8ee:	d11ff0ef          	jal	5fe <vprintf>
}
 8f2:	60e2                	ld	ra,24(sp)
 8f4:	6442                	ld	s0,16(sp)
 8f6:	6125                	addi	sp,sp,96
 8f8:	8082                	ret

00000000000008fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8fa:	1141                	addi	sp,sp,-16
 8fc:	e406                	sd	ra,8(sp)
 8fe:	e022                	sd	s0,0(sp)
 900:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 902:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 906:	00000797          	auipc	a5,0x0
 90a:	6fa7b783          	ld	a5,1786(a5) # 1000 <freep>
 90e:	a02d                	j	938 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 910:	4618                	lw	a4,8(a2)
 912:	9f2d                	addw	a4,a4,a1
 914:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 918:	6398                	ld	a4,0(a5)
 91a:	6310                	ld	a2,0(a4)
 91c:	a83d                	j	95a <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 91e:	ff852703          	lw	a4,-8(a0)
 922:	9f31                	addw	a4,a4,a2
 924:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 926:	ff053683          	ld	a3,-16(a0)
 92a:	a091                	j	96e <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92c:	6398                	ld	a4,0(a5)
 92e:	00e7e463          	bltu	a5,a4,936 <free+0x3c>
 932:	00e6ea63          	bltu	a3,a4,946 <free+0x4c>
{
 936:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 938:	fed7fae3          	bgeu	a5,a3,92c <free+0x32>
 93c:	6398                	ld	a4,0(a5)
 93e:	00e6e463          	bltu	a3,a4,946 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 942:	fee7eae3          	bltu	a5,a4,936 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 946:	ff852583          	lw	a1,-8(a0)
 94a:	6390                	ld	a2,0(a5)
 94c:	02059813          	slli	a6,a1,0x20
 950:	01c85713          	srli	a4,a6,0x1c
 954:	9736                	add	a4,a4,a3
 956:	fae60de3          	beq	a2,a4,910 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 95a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 95e:	4790                	lw	a2,8(a5)
 960:	02061593          	slli	a1,a2,0x20
 964:	01c5d713          	srli	a4,a1,0x1c
 968:	973e                	add	a4,a4,a5
 96a:	fae68ae3          	beq	a3,a4,91e <free+0x24>
    p->s.ptr = bp->s.ptr;
 96e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 970:	00000717          	auipc	a4,0x0
 974:	68f73823          	sd	a5,1680(a4) # 1000 <freep>
}
 978:	60a2                	ld	ra,8(sp)
 97a:	6402                	ld	s0,0(sp)
 97c:	0141                	addi	sp,sp,16
 97e:	8082                	ret

0000000000000980 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 980:	7139                	addi	sp,sp,-64
 982:	fc06                	sd	ra,56(sp)
 984:	f822                	sd	s0,48(sp)
 986:	f04a                	sd	s2,32(sp)
 988:	ec4e                	sd	s3,24(sp)
 98a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 98c:	02051993          	slli	s3,a0,0x20
 990:	0209d993          	srli	s3,s3,0x20
 994:	09bd                	addi	s3,s3,15
 996:	0049d993          	srli	s3,s3,0x4
 99a:	2985                	addiw	s3,s3,1
 99c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 99e:	00000517          	auipc	a0,0x0
 9a2:	66253503          	ld	a0,1634(a0) # 1000 <freep>
 9a6:	c905                	beqz	a0,9d6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9aa:	4798                	lw	a4,8(a5)
 9ac:	09377663          	bgeu	a4,s3,a38 <malloc+0xb8>
 9b0:	f426                	sd	s1,40(sp)
 9b2:	e852                	sd	s4,16(sp)
 9b4:	e456                	sd	s5,8(sp)
 9b6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9b8:	8a4e                	mv	s4,s3
 9ba:	6705                	lui	a4,0x1
 9bc:	00e9f363          	bgeu	s3,a4,9c2 <malloc+0x42>
 9c0:	6a05                	lui	s4,0x1
 9c2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9c6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9ca:	00000497          	auipc	s1,0x0
 9ce:	63648493          	addi	s1,s1,1590 # 1000 <freep>
  if(p == SBRK_ERROR)
 9d2:	5afd                	li	s5,-1
 9d4:	a83d                	j	a12 <malloc+0x92>
 9d6:	f426                	sd	s1,40(sp)
 9d8:	e852                	sd	s4,16(sp)
 9da:	e456                	sd	s5,8(sp)
 9dc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9de:	00000797          	auipc	a5,0x0
 9e2:	63278793          	addi	a5,a5,1586 # 1010 <base>
 9e6:	00000717          	auipc	a4,0x0
 9ea:	60f73d23          	sd	a5,1562(a4) # 1000 <freep>
 9ee:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9f4:	b7d1                	j	9b8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9f6:	6398                	ld	a4,0(a5)
 9f8:	e118                	sd	a4,0(a0)
 9fa:	a899                	j	a50 <malloc+0xd0>
  hp->s.size = nu;
 9fc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a00:	0541                	addi	a0,a0,16
 a02:	ef9ff0ef          	jal	8fa <free>
  return freep;
 a06:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a08:	c125                	beqz	a0,a68 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0c:	4798                	lw	a4,8(a5)
 a0e:	03277163          	bgeu	a4,s2,a30 <malloc+0xb0>
    if(p == freep)
 a12:	6098                	ld	a4,0(s1)
 a14:	853e                	mv	a0,a5
 a16:	fef71ae3          	bne	a4,a5,a0a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a1a:	8552                	mv	a0,s4
 a1c:	8c7ff0ef          	jal	2e2 <sbrk>
  if(p == SBRK_ERROR)
 a20:	fd551ee3          	bne	a0,s5,9fc <malloc+0x7c>
        return 0;
 a24:	4501                	li	a0,0
 a26:	74a2                	ld	s1,40(sp)
 a28:	6a42                	ld	s4,16(sp)
 a2a:	6aa2                	ld	s5,8(sp)
 a2c:	6b02                	ld	s6,0(sp)
 a2e:	a03d                	j	a5c <malloc+0xdc>
 a30:	74a2                	ld	s1,40(sp)
 a32:	6a42                	ld	s4,16(sp)
 a34:	6aa2                	ld	s5,8(sp)
 a36:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a38:	fae90fe3          	beq	s2,a4,9f6 <malloc+0x76>
        p->s.size -= nunits;
 a3c:	4137073b          	subw	a4,a4,s3
 a40:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a42:	02071693          	slli	a3,a4,0x20
 a46:	01c6d713          	srli	a4,a3,0x1c
 a4a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a4c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a50:	00000717          	auipc	a4,0x0
 a54:	5aa73823          	sd	a0,1456(a4) # 1000 <freep>
      return (void*)(p + 1);
 a58:	01078513          	addi	a0,a5,16
  }
}
 a5c:	70e2                	ld	ra,56(sp)
 a5e:	7442                	ld	s0,48(sp)
 a60:	7902                	ld	s2,32(sp)
 a62:	69e2                	ld	s3,24(sp)
 a64:	6121                	addi	sp,sp,64
 a66:	8082                	ret
 a68:	74a2                	ld	s1,40(sp)
 a6a:	6a42                	ld	s4,16(sp)
 a6c:	6aa2                	ld	s5,8(sp)
 a6e:	6b02                	ld	s6,0(sp)
 a70:	b7f5                	j	a5c <malloc+0xdc>
