
user/_mkdir:     file format elf64-littleriscv


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
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	4e6000ef          	jal	50e <mkdir>
  2c:	02054463          	bltz	a0,54 <main+0x54>
  for(i = 1; i < argc; i++){
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit(0);
  36:	4501                	li	a0,0
  38:	46e000ef          	jal	4a6 <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  40:	00001597          	auipc	a1,0x1
  44:	a5058593          	addi	a1,a1,-1456 # a90 <malloc+0xf8>
  48:	4509                	li	a0,2
  4a:	06d000ef          	jal	8b6 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	456000ef          	jal	4a6 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  54:	6090                	ld	a2,0(s1)
  56:	00001597          	auipc	a1,0x1
  5a:	a5258593          	addi	a1,a1,-1454 # aa8 <malloc+0x110>
  5e:	4509                	li	a0,2
  60:	057000ef          	jal	8b6 <fprintf>
      break;
  64:	bfc9                	j	36 <main+0x36>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  6e:	f93ff0ef          	jal	0 <main>
  exit(r);
  72:	434000ef          	jal	4a6 <exit>

0000000000000076 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  76:	1141                	addi	sp,sp,-16
  78:	e406                	sd	ra,8(sp)
  7a:	e022                	sd	s0,0(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0xa>
    ;
  return os;
}
  8e:	60a2                	ld	ra,8(sp)
  90:	6402                	ld	s0,0(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cb91                	beqz	a5,b6 <strcmp+0x20>
  a4:	0005c703          	lbu	a4,0(a1)
  a8:	00f71763          	bne	a4,a5,b6 <strcmp+0x20>
    p++, q++;
  ac:	0505                	addi	a0,a0,1
  ae:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	fbe5                	bnez	a5,a4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  b6:	0005c503          	lbu	a0,0(a1)
}
  ba:	40a7853b          	subw	a0,a5,a0
  be:	60a2                	ld	ra,8(sp)
  c0:	6402                	ld	s0,0(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strlen>:

uint
strlen(const char *s)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cf99                	beqz	a5,f0 <strlen+0x2a>
  d4:	0505                	addi	a0,a0,1
  d6:	87aa                	mv	a5,a0
  d8:	86be                	mv	a3,a5
  da:	0785                	addi	a5,a5,1
  dc:	fff7c703          	lbu	a4,-1(a5)
  e0:	ff65                	bnez	a4,d8 <strlen+0x12>
  e2:	40a6853b          	subw	a0,a3,a0
  e6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  e8:	60a2                	ld	ra,8(sp)
  ea:	6402                	ld	s0,0(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  for(n = 0; s[n]; n++)
  f0:	4501                	li	a0,0
  f2:	bfdd                	j	e8 <strlen+0x22>

00000000000000f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e406                	sd	ra,8(sp)
  f8:	e022                	sd	s0,0(sp)
  fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fc:	ca19                	beqz	a2,112 <memset+0x1e>
  fe:	87aa                	mv	a5,a0
 100:	1602                	slli	a2,a2,0x20
 102:	9201                	srli	a2,a2,0x20
 104:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 108:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10c:	0785                	addi	a5,a5,1
 10e:	fee79de3          	bne	a5,a4,108 <memset+0x14>
  }
  return dst;
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <strchr>:

char*
strchr(const char *s, char c)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e406                	sd	ra,8(sp)
 11e:	e022                	sd	s0,0(sp)
 120:	0800                	addi	s0,sp,16
  for(; *s; s++)
 122:	00054783          	lbu	a5,0(a0)
 126:	cf81                	beqz	a5,13e <strchr+0x24>
    if(*s == c)
 128:	00f58763          	beq	a1,a5,136 <strchr+0x1c>
  for(; *s; s++)
 12c:	0505                	addi	a0,a0,1
 12e:	00054783          	lbu	a5,0(a0)
 132:	fbfd                	bnez	a5,128 <strchr+0xe>
      return (char*)s;
  return 0;
 134:	4501                	li	a0,0
}
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret
  return 0;
 13e:	4501                	li	a0,0
 140:	bfdd                	j	136 <strchr+0x1c>

0000000000000142 <gets>:

char*
gets(char *buf, int max)
{
 142:	7159                	addi	sp,sp,-112
 144:	f486                	sd	ra,104(sp)
 146:	f0a2                	sd	s0,96(sp)
 148:	eca6                	sd	s1,88(sp)
 14a:	e8ca                	sd	s2,80(sp)
 14c:	e4ce                	sd	s3,72(sp)
 14e:	e0d2                	sd	s4,64(sp)
 150:	fc56                	sd	s5,56(sp)
 152:	f85a                	sd	s6,48(sp)
 154:	f45e                	sd	s7,40(sp)
 156:	f062                	sd	s8,32(sp)
 158:	ec66                	sd	s9,24(sp)
 15a:	e86a                	sd	s10,16(sp)
 15c:	1880                	addi	s0,sp,112
 15e:	8caa                	mv	s9,a0
 160:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 162:	892a                	mv	s2,a0
 164:	4481                	li	s1,0
    cc = read(0, &c, 1);
 166:	f9f40b13          	addi	s6,s0,-97
 16a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16c:	4ba9                	li	s7,10
 16e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 170:	8d26                	mv	s10,s1
 172:	0014899b          	addiw	s3,s1,1
 176:	84ce                	mv	s1,s3
 178:	0349d563          	bge	s3,s4,1a2 <gets+0x60>
    cc = read(0, &c, 1);
 17c:	8656                	mv	a2,s5
 17e:	85da                	mv	a1,s6
 180:	4501                	li	a0,0
 182:	33c000ef          	jal	4be <read>
    if(cc < 1)
 186:	00a05e63          	blez	a0,1a2 <gets+0x60>
    buf[i++] = c;
 18a:	f9f44783          	lbu	a5,-97(s0)
 18e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 192:	01778763          	beq	a5,s7,1a0 <gets+0x5e>
 196:	0905                	addi	s2,s2,1
 198:	fd879ce3          	bne	a5,s8,170 <gets+0x2e>
    buf[i++] = c;
 19c:	8d4e                	mv	s10,s3
 19e:	a011                	j	1a2 <gets+0x60>
 1a0:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1a2:	9d66                	add	s10,s10,s9
 1a4:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1a8:	8566                	mv	a0,s9
 1aa:	70a6                	ld	ra,104(sp)
 1ac:	7406                	ld	s0,96(sp)
 1ae:	64e6                	ld	s1,88(sp)
 1b0:	6946                	ld	s2,80(sp)
 1b2:	69a6                	ld	s3,72(sp)
 1b4:	6a06                	ld	s4,64(sp)
 1b6:	7ae2                	ld	s5,56(sp)
 1b8:	7b42                	ld	s6,48(sp)
 1ba:	7ba2                	ld	s7,40(sp)
 1bc:	7c02                	ld	s8,32(sp)
 1be:	6ce2                	ld	s9,24(sp)
 1c0:	6d42                	ld	s10,16(sp)
 1c2:	6165                	addi	sp,sp,112
 1c4:	8082                	ret

00000000000001c6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c6:	1101                	addi	sp,sp,-32
 1c8:	ec06                	sd	ra,24(sp)
 1ca:	e822                	sd	s0,16(sp)
 1cc:	e04a                	sd	s2,0(sp)
 1ce:	1000                	addi	s0,sp,32
 1d0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d2:	4581                	li	a1,0
 1d4:	312000ef          	jal	4e6 <open>
  if(fd < 0)
 1d8:	02054263          	bltz	a0,1fc <stat+0x36>
 1dc:	e426                	sd	s1,8(sp)
 1de:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e0:	85ca                	mv	a1,s2
 1e2:	31c000ef          	jal	4fe <fstat>
 1e6:	892a                	mv	s2,a0
  close(fd);
 1e8:	8526                	mv	a0,s1
 1ea:	2e4000ef          	jal	4ce <close>
  return r;
 1ee:	64a2                	ld	s1,8(sp)
}
 1f0:	854a                	mv	a0,s2
 1f2:	60e2                	ld	ra,24(sp)
 1f4:	6442                	ld	s0,16(sp)
 1f6:	6902                	ld	s2,0(sp)
 1f8:	6105                	addi	sp,sp,32
 1fa:	8082                	ret
    return -1;
 1fc:	597d                	li	s2,-1
 1fe:	bfcd                	j	1f0 <stat+0x2a>

0000000000000200 <atoi>:

int
atoi(const char *s)
{
 200:	1141                	addi	sp,sp,-16
 202:	e406                	sd	ra,8(sp)
 204:	e022                	sd	s0,0(sp)
 206:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 208:	00054683          	lbu	a3,0(a0)
 20c:	fd06879b          	addiw	a5,a3,-48
 210:	0ff7f793          	zext.b	a5,a5
 214:	4625                	li	a2,9
 216:	02f66963          	bltu	a2,a5,248 <atoi+0x48>
 21a:	872a                	mv	a4,a0
  n = 0;
 21c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 21e:	0705                	addi	a4,a4,1
 220:	0025179b          	slliw	a5,a0,0x2
 224:	9fa9                	addw	a5,a5,a0
 226:	0017979b          	slliw	a5,a5,0x1
 22a:	9fb5                	addw	a5,a5,a3
 22c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 230:	00074683          	lbu	a3,0(a4)
 234:	fd06879b          	addiw	a5,a3,-48
 238:	0ff7f793          	zext.b	a5,a5
 23c:	fef671e3          	bgeu	a2,a5,21e <atoi+0x1e>
  return n;
}
 240:	60a2                	ld	ra,8(sp)
 242:	6402                	ld	s0,0(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
  n = 0;
 248:	4501                	li	a0,0
 24a:	bfdd                	j	240 <atoi+0x40>

000000000000024c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 254:	02b57563          	bgeu	a0,a1,27e <memmove+0x32>
    while(n-- > 0)
 258:	00c05f63          	blez	a2,276 <memmove+0x2a>
 25c:	1602                	slli	a2,a2,0x20
 25e:	9201                	srli	a2,a2,0x20
 260:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 264:	872a                	mv	a4,a0
      *dst++ = *src++;
 266:	0585                	addi	a1,a1,1
 268:	0705                	addi	a4,a4,1
 26a:	fff5c683          	lbu	a3,-1(a1)
 26e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 272:	fee79ae3          	bne	a5,a4,266 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
    dst += n;
 27e:	00c50733          	add	a4,a0,a2
    src += n;
 282:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 284:	fec059e3          	blez	a2,276 <memmove+0x2a>
 288:	fff6079b          	addiw	a5,a2,-1
 28c:	1782                	slli	a5,a5,0x20
 28e:	9381                	srli	a5,a5,0x20
 290:	fff7c793          	not	a5,a5
 294:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 296:	15fd                	addi	a1,a1,-1
 298:	177d                	addi	a4,a4,-1
 29a:	0005c683          	lbu	a3,0(a1)
 29e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a2:	fef71ae3          	bne	a4,a5,296 <memmove+0x4a>
 2a6:	bfc1                	j	276 <memmove+0x2a>

00000000000002a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b0:	ca0d                	beqz	a2,2e2 <memcmp+0x3a>
 2b2:	fff6069b          	addiw	a3,a2,-1
 2b6:	1682                	slli	a3,a3,0x20
 2b8:	9281                	srli	a3,a3,0x20
 2ba:	0685                	addi	a3,a3,1
 2bc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2be:	00054783          	lbu	a5,0(a0)
 2c2:	0005c703          	lbu	a4,0(a1)
 2c6:	00e79863          	bne	a5,a4,2d6 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2ca:	0505                	addi	a0,a0,1
    p2++;
 2cc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ce:	fed518e3          	bne	a0,a3,2be <memcmp+0x16>
  }
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	a019                	j	2da <memcmp+0x32>
      return *p1 - *p2;
 2d6:	40e7853b          	subw	a0,a5,a4
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
  return 0;
 2e2:	4501                	li	a0,0
 2e4:	bfdd                	j	2da <memcmp+0x32>

00000000000002e6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ee:	f5fff0ef          	jal	24c <memmove>
}
 2f2:	60a2                	ld	ra,8(sp)
 2f4:	6402                	ld	s0,0(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret

00000000000002fa <sbrk>:

char *
sbrk(int n) {
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e406                	sd	ra,8(sp)
 2fe:	e022                	sd	s0,0(sp)
 300:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 302:	4585                	li	a1,1
 304:	22a000ef          	jal	52e <sys_sbrk>
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <sbrklazy>:

char *
sbrklazy(int n) {
 310:	1141                	addi	sp,sp,-16
 312:	e406                	sd	ra,8(sp)
 314:	e022                	sd	s0,0(sp)
 316:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 318:	4589                	li	a1,2
 31a:	214000ef          	jal	52e <sys_sbrk>
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret

0000000000000326 <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 326:	1101                	addi	sp,sp,-32
 328:	ec06                	sd	ra,24(sp)
 32a:	e822                	sd	s0,16(sp)
 32c:	e426                	sd	s1,8(sp)
 32e:	e04a                	sd	s2,0(sp)
 330:	1000                	addi	s0,sp,32
 332:	84aa                	mv	s1,a0
 334:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 336:	6505                	lui	a0,0x1
 338:	fc3ff0ef          	jal	2fa <sbrk>
 33c:	6785                	lui	a5,0x1
 33e:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 342:	9a41                	andi	a2,a2,-16
 344:	85ca                	mv	a1,s2
 346:	8526                	mv	a0,s1
 348:	1fe000ef          	jal	546 <clone>
}
 34c:	60e2                	ld	ra,24(sp)
 34e:	6442                	ld	s0,16(sp)
 350:	64a2                	ld	s1,8(sp)
 352:	6902                	ld	s2,0(sp)
 354:	6105                	addi	sp,sp,32
 356:	8082                	ret

0000000000000358 <futex>:

void futex(int *uaddr, int ops, int val) {
 358:	7179                	addi	sp,sp,-48
 35a:	f406                	sd	ra,40(sp)
 35c:	f022                	sd	s0,32(sp)
 35e:	ec26                	sd	s1,24(sp)
 360:	1800                	addi	s0,sp,48
 362:	84aa                	mv	s1,a0
  if (ops==0) {
 364:	ed95                	bnez	a1,3a0 <futex+0x48>
    if (val==0) {
 366:	c611                	beqz	a2,372 <futex+0x1a>
 368:	e84a                	sd	s2,16(sp)
 36a:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 36c:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 36e:	4985                	li	s3,1
 370:	a005                	j	390 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 372:	4705                	li	a4,1
 374:	87ba                	mv	a5,a4
 376:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 37a:	2781                	sext.w	a5,a5
 37c:	ffe5                	bnez	a5,374 <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 37e:	70a2                	ld	ra,40(sp)
 380:	7402                	ld	s0,32(sp)
 382:	64e2                	ld	s1,24(sp)
 384:	6145                	addi	sp,sp,48
 386:	8082                	ret
        futex_wait(uaddr, 1);
 388:	85ce                	mv	a1,s3
 38a:	8526                	mv	a0,s1
 38c:	1ca000ef          	jal	556 <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 390:	87ca                	mv	a5,s2
 392:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 396:	2781                	sext.w	a5,a5
 398:	fbe5                	bnez	a5,388 <futex+0x30>
 39a:	6942                	ld	s2,16(sp)
 39c:	69a2                	ld	s3,8(sp)
 39e:	b7c5                	j	37e <futex+0x26>
    if (val==0) {
 3a0:	e611                	bnez	a2,3ac <futex+0x54>
      __sync_lock_release(uaddr);
 3a2:	0310000f          	fence	rw,w
 3a6:	00052023          	sw	zero,0(a0) # 1000 <freep>
 3aa:	bfd1                	j	37e <futex+0x26>
      __sync_lock_release(uaddr);
 3ac:	0310000f          	fence	rw,w
 3b0:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 3b4:	1aa000ef          	jal	55e <futex_wake>
  return;
 3b8:	b7d9                	j	37e <futex+0x26>

00000000000003ba <sem_init>:

void sem_init(sem_t* s, int val) {
 3ba:	7179                	addi	sp,sp,-48
 3bc:	f406                	sd	ra,40(sp)
 3be:	f022                	sd	s0,32(sp)
 3c0:	ec26                	sd	s1,24(sp)
 3c2:	e84a                	sd	s2,16(sp)
 3c4:	e44e                	sd	s3,8(sp)
 3c6:	1800                	addi	s0,sp,48
 3c8:	84aa                	mv	s1,a0
 3ca:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 3cc:	00450993          	addi	s3,a0,4
 3d0:	4605                	li	a2,1
 3d2:	4581                	li	a1,0
 3d4:	854e                	mv	a0,s3
 3d6:	f83ff0ef          	jal	358 <futex>
  s->value = val;
 3da:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 3de:	4605                	li	a2,1
 3e0:	85b2                	mv	a1,a2
 3e2:	854e                	mv	a0,s3
 3e4:	f75ff0ef          	jal	358 <futex>
  return;
}
 3e8:	70a2                	ld	ra,40(sp)
 3ea:	7402                	ld	s0,32(sp)
 3ec:	64e2                	ld	s1,24(sp)
 3ee:	6942                	ld	s2,16(sp)
 3f0:	69a2                	ld	s3,8(sp)
 3f2:	6145                	addi	sp,sp,48
 3f4:	8082                	ret

00000000000003f6 <sem_down>:

void sem_down(sem_t* s) {
 3f6:	7179                	addi	sp,sp,-48
 3f8:	f406                	sd	ra,40(sp)
 3fa:	f022                	sd	s0,32(sp)
 3fc:	ec26                	sd	s1,24(sp)
 3fe:	e84a                	sd	s2,16(sp)
 400:	e44e                	sd	s3,8(sp)
 402:	1800                	addi	s0,sp,48
 404:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 406:	00450993          	addi	s3,a0,4
 40a:	4605                	li	a2,1
 40c:	4581                	li	a1,0
 40e:	854e                	mv	a0,s3
 410:	f49ff0ef          	jal	358 <futex>
  while(1) {
    if (s->value>0) {
 414:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 418:	4485                	li	s1,1
    if (s->value>0) {
 41a:	02f04463          	bgtz	a5,442 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 41e:	8626                	mv	a2,s1
 420:	85a6                	mv	a1,s1
 422:	854e                	mv	a0,s3
 424:	f35ff0ef          	jal	358 <futex>
      futex_wait(&s->value,1);
 428:	85a6                	mv	a1,s1
 42a:	854a                	mv	a0,s2
 42c:	12a000ef          	jal	556 <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 430:	8626                	mv	a2,s1
 432:	4581                	li	a1,0
 434:	854e                	mv	a0,s3
 436:	f23ff0ef          	jal	358 <futex>
    if (s->value>0) {
 43a:	00092783          	lw	a5,0(s2)
 43e:	fef050e3          	blez	a5,41e <sem_down+0x28>
      s->value--;
 442:	37fd                	addiw	a5,a5,-1 # fff <digits+0x52f>
 444:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 448:	4605                	li	a2,1
 44a:	85b2                	mv	a1,a2
 44c:	854e                	mv	a0,s3
 44e:	f0bff0ef          	jal	358 <futex>
  return;
}
 452:	70a2                	ld	ra,40(sp)
 454:	7402                	ld	s0,32(sp)
 456:	64e2                	ld	s1,24(sp)
 458:	6942                	ld	s2,16(sp)
 45a:	69a2                	ld	s3,8(sp)
 45c:	6145                	addi	sp,sp,48
 45e:	8082                	ret

0000000000000460 <sem_up>:

void sem_up(sem_t* s) {
 460:	1101                	addi	sp,sp,-32
 462:	ec06                	sd	ra,24(sp)
 464:	e822                	sd	s0,16(sp)
 466:	e426                	sd	s1,8(sp)
 468:	e04a                	sd	s2,0(sp)
 46a:	1000                	addi	s0,sp,32
 46c:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 46e:	00450913          	addi	s2,a0,4
 472:	4605                	li	a2,1
 474:	4581                	li	a1,0
 476:	854a                	mv	a0,s2
 478:	ee1ff0ef          	jal	358 <futex>
  s->value++;
 47c:	409c                	lw	a5,0(s1)
 47e:	2785                	addiw	a5,a5,1
 480:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 482:	8526                	mv	a0,s1
 484:	0da000ef          	jal	55e <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 488:	4605                	li	a2,1
 48a:	85b2                	mv	a1,a2
 48c:	854a                	mv	a0,s2
 48e:	ecbff0ef          	jal	358 <futex>
  return;
 492:	60e2                	ld	ra,24(sp)
 494:	6442                	ld	s0,16(sp)
 496:	64a2                	ld	s1,8(sp)
 498:	6902                	ld	s2,0(sp)
 49a:	6105                	addi	sp,sp,32
 49c:	8082                	ret

000000000000049e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 49e:	4885                	li	a7,1
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4a6:	4889                	li	a7,2
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ae:	488d                	li	a7,3
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4b6:	4891                	li	a7,4
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <read>:
.global read
read:
 li a7, SYS_read
 4be:	4895                	li	a7,5
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <write>:
.global write
write:
 li a7, SYS_write
 4c6:	48c1                	li	a7,16
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <close>:
.global close
close:
 li a7, SYS_close
 4ce:	48d5                	li	a7,21
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4d6:	4899                	li	a7,6
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <exec>:
.global exec
exec:
 li a7, SYS_exec
 4de:	489d                	li	a7,7
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <open>:
.global open
open:
 li a7, SYS_open
 4e6:	48bd                	li	a7,15
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4ee:	48c5                	li	a7,17
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4f6:	48c9                	li	a7,18
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4fe:	48a1                	li	a7,8
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <link>:
.global link
link:
 li a7, SYS_link
 506:	48cd                	li	a7,19
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 50e:	48d1                	li	a7,20
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 516:	48a5                	li	a7,9
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <dup>:
.global dup
dup:
 li a7, SYS_dup
 51e:	48a9                	li	a7,10
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 526:	48ad                	li	a7,11
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 52e:	48b1                	li	a7,12
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <pause>:
.global pause
pause:
 li a7, SYS_pause
 536:	48b5                	li	a7,13
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 53e:	48b9                	li	a7,14
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <clone>:
.global clone
clone:
 li a7, SYS_clone
 546:	48d9                	li	a7,22
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <join>:
.global join
join:
 li a7, SYS_join
 54e:	48dd                	li	a7,23
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 556:	48e1                	li	a7,24
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 55e:	48e5                	li	a7,25
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 566:	1101                	addi	sp,sp,-32
 568:	ec06                	sd	ra,24(sp)
 56a:	e822                	sd	s0,16(sp)
 56c:	1000                	addi	s0,sp,32
 56e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 572:	4605                	li	a2,1
 574:	fef40593          	addi	a1,s0,-17
 578:	f4fff0ef          	jal	4c6 <write>
}
 57c:	60e2                	ld	ra,24(sp)
 57e:	6442                	ld	s0,16(sp)
 580:	6105                	addi	sp,sp,32
 582:	8082                	ret

0000000000000584 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 584:	715d                	addi	sp,sp,-80
 586:	e486                	sd	ra,72(sp)
 588:	e0a2                	sd	s0,64(sp)
 58a:	fc26                	sd	s1,56(sp)
 58c:	f84a                	sd	s2,48(sp)
 58e:	f44e                	sd	s3,40(sp)
 590:	0880                	addi	s0,sp,80
 592:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 594:	c299                	beqz	a3,59a <printint+0x16>
 596:	0605cc63          	bltz	a1,60e <printint+0x8a>
  neg = 0;
 59a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 59c:	fb840313          	addi	t1,s0,-72
  neg = 0;
 5a0:	869a                	mv	a3,t1
  i = 0;
 5a2:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5a4:	00000817          	auipc	a6,0x0
 5a8:	52c80813          	addi	a6,a6,1324 # ad0 <digits>
 5ac:	88be                	mv	a7,a5
 5ae:	0017851b          	addiw	a0,a5,1
 5b2:	87aa                	mv	a5,a0
 5b4:	02c5f733          	remu	a4,a1,a2
 5b8:	9742                	add	a4,a4,a6
 5ba:	00074703          	lbu	a4,0(a4)
 5be:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5c2:	872e                	mv	a4,a1
 5c4:	02c5d5b3          	divu	a1,a1,a2
 5c8:	0685                	addi	a3,a3,1
 5ca:	fec771e3          	bgeu	a4,a2,5ac <printint+0x28>
  if(neg)
 5ce:	000e0c63          	beqz	t3,5e6 <printint+0x62>
    buf[i++] = '-';
 5d2:	fd050793          	addi	a5,a0,-48
 5d6:	00878533          	add	a0,a5,s0
 5da:	02d00793          	li	a5,45
 5de:	fef50423          	sb	a5,-24(a0)
 5e2:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 5e6:	fff7899b          	addiw	s3,a5,-1
 5ea:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 5ee:	fff4c583          	lbu	a1,-1(s1)
 5f2:	854a                	mv	a0,s2
 5f4:	f73ff0ef          	jal	566 <putc>
  while(--i >= 0)
 5f8:	39fd                	addiw	s3,s3,-1
 5fa:	14fd                	addi	s1,s1,-1
 5fc:	fe09d9e3          	bgez	s3,5ee <printint+0x6a>
}
 600:	60a6                	ld	ra,72(sp)
 602:	6406                	ld	s0,64(sp)
 604:	74e2                	ld	s1,56(sp)
 606:	7942                	ld	s2,48(sp)
 608:	79a2                	ld	s3,40(sp)
 60a:	6161                	addi	sp,sp,80
 60c:	8082                	ret
    x = -xx;
 60e:	40b005b3          	neg	a1,a1
    neg = 1;
 612:	4e05                	li	t3,1
    x = -xx;
 614:	b761                	j	59c <printint+0x18>

0000000000000616 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 616:	711d                	addi	sp,sp,-96
 618:	ec86                	sd	ra,88(sp)
 61a:	e8a2                	sd	s0,80(sp)
 61c:	e4a6                	sd	s1,72(sp)
 61e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 620:	0005c483          	lbu	s1,0(a1)
 624:	28048463          	beqz	s1,8ac <vprintf+0x296>
 628:	e0ca                	sd	s2,64(sp)
 62a:	fc4e                	sd	s3,56(sp)
 62c:	f852                	sd	s4,48(sp)
 62e:	f456                	sd	s5,40(sp)
 630:	f05a                	sd	s6,32(sp)
 632:	ec5e                	sd	s7,24(sp)
 634:	e862                	sd	s8,16(sp)
 636:	e466                	sd	s9,8(sp)
 638:	8b2a                	mv	s6,a0
 63a:	8a2e                	mv	s4,a1
 63c:	8bb2                	mv	s7,a2
  state = 0;
 63e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 640:	4901                	li	s2,0
 642:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 644:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 648:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 64c:	06c00c93          	li	s9,108
 650:	a00d                	j	672 <vprintf+0x5c>
        putc(fd, c0);
 652:	85a6                	mv	a1,s1
 654:	855a                	mv	a0,s6
 656:	f11ff0ef          	jal	566 <putc>
 65a:	a019                	j	660 <vprintf+0x4a>
    } else if(state == '%'){
 65c:	03598363          	beq	s3,s5,682 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 660:	0019079b          	addiw	a5,s2,1
 664:	893e                	mv	s2,a5
 666:	873e                	mv	a4,a5
 668:	97d2                	add	a5,a5,s4
 66a:	0007c483          	lbu	s1,0(a5)
 66e:	22048763          	beqz	s1,89c <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 672:	0004879b          	sext.w	a5,s1
    if(state == 0){
 676:	fe0993e3          	bnez	s3,65c <vprintf+0x46>
      if(c0 == '%'){
 67a:	fd579ce3          	bne	a5,s5,652 <vprintf+0x3c>
        state = '%';
 67e:	89be                	mv	s3,a5
 680:	b7c5                	j	660 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 682:	00ea06b3          	add	a3,s4,a4
 686:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 68a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 68c:	c681                	beqz	a3,694 <vprintf+0x7e>
 68e:	9752                	add	a4,a4,s4
 690:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 694:	05878263          	beq	a5,s8,6d8 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 698:	05978c63          	beq	a5,s9,6f0 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 69c:	07500713          	li	a4,117
 6a0:	0ee78663          	beq	a5,a4,78c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6a4:	07800713          	li	a4,120
 6a8:	12e78863          	beq	a5,a4,7d8 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6ac:	07000713          	li	a4,112
 6b0:	14e78d63          	beq	a5,a4,80a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 6b4:	06300713          	li	a4,99
 6b8:	18e78c63          	beq	a5,a4,850 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 6bc:	07300713          	li	a4,115
 6c0:	1ae78263          	beq	a5,a4,864 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6c4:	02500713          	li	a4,37
 6c8:	04e79463          	bne	a5,a4,710 <vprintf+0xfa>
        putc(fd, '%');
 6cc:	85ba                	mv	a1,a4
 6ce:	855a                	mv	a0,s6
 6d0:	e97ff0ef          	jal	566 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b769                	j	660 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6d8:	008b8493          	addi	s1,s7,8
 6dc:	4685                	li	a3,1
 6de:	4629                	li	a2,10
 6e0:	000ba583          	lw	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	e9fff0ef          	jal	584 <printint>
 6ea:	8ba6                	mv	s7,s1
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	bf8d                	j	660 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6f0:	06400793          	li	a5,100
 6f4:	02f68963          	beq	a3,a5,726 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f8:	06c00793          	li	a5,108
 6fc:	04f68263          	beq	a3,a5,740 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 700:	07500793          	li	a5,117
 704:	0af68063          	beq	a3,a5,7a4 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 708:	07800793          	li	a5,120
 70c:	0ef68263          	beq	a3,a5,7f0 <vprintf+0x1da>
        putc(fd, '%');
 710:	02500593          	li	a1,37
 714:	855a                	mv	a0,s6
 716:	e51ff0ef          	jal	566 <putc>
        putc(fd, c0);
 71a:	85a6                	mv	a1,s1
 71c:	855a                	mv	a0,s6
 71e:	e49ff0ef          	jal	566 <putc>
      state = 0;
 722:	4981                	li	s3,0
 724:	bf35                	j	660 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 726:	008b8493          	addi	s1,s7,8
 72a:	4685                	li	a3,1
 72c:	4629                	li	a2,10
 72e:	000bb583          	ld	a1,0(s7)
 732:	855a                	mv	a0,s6
 734:	e51ff0ef          	jal	584 <printint>
        i += 1;
 738:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 73a:	8ba6                	mv	s7,s1
      state = 0;
 73c:	4981                	li	s3,0
        i += 1;
 73e:	b70d                	j	660 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 740:	06400793          	li	a5,100
 744:	02f60763          	beq	a2,a5,772 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 748:	07500793          	li	a5,117
 74c:	06f60963          	beq	a2,a5,7be <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 750:	07800793          	li	a5,120
 754:	faf61ee3          	bne	a2,a5,710 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 758:	008b8493          	addi	s1,s7,8
 75c:	4681                	li	a3,0
 75e:	4641                	li	a2,16
 760:	000bb583          	ld	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	e1fff0ef          	jal	584 <printint>
        i += 2;
 76a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 76c:	8ba6                	mv	s7,s1
      state = 0;
 76e:	4981                	li	s3,0
        i += 2;
 770:	bdc5                	j	660 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 772:	008b8493          	addi	s1,s7,8
 776:	4685                	li	a3,1
 778:	4629                	li	a2,10
 77a:	000bb583          	ld	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	e05ff0ef          	jal	584 <printint>
        i += 2;
 784:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 786:	8ba6                	mv	s7,s1
      state = 0;
 788:	4981                	li	s3,0
        i += 2;
 78a:	bdd9                	j	660 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 78c:	008b8493          	addi	s1,s7,8
 790:	4681                	li	a3,0
 792:	4629                	li	a2,10
 794:	000be583          	lwu	a1,0(s7)
 798:	855a                	mv	a0,s6
 79a:	debff0ef          	jal	584 <printint>
 79e:	8ba6                	mv	s7,s1
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	bd7d                	j	660 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a4:	008b8493          	addi	s1,s7,8
 7a8:	4681                	li	a3,0
 7aa:	4629                	li	a2,10
 7ac:	000bb583          	ld	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	dd3ff0ef          	jal	584 <printint>
        i += 1;
 7b6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b8:	8ba6                	mv	s7,s1
      state = 0;
 7ba:	4981                	li	s3,0
        i += 1;
 7bc:	b555                	j	660 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7be:	008b8493          	addi	s1,s7,8
 7c2:	4681                	li	a3,0
 7c4:	4629                	li	a2,10
 7c6:	000bb583          	ld	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	db9ff0ef          	jal	584 <printint>
        i += 2;
 7d0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d2:	8ba6                	mv	s7,s1
      state = 0;
 7d4:	4981                	li	s3,0
        i += 2;
 7d6:	b569                	j	660 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7d8:	008b8493          	addi	s1,s7,8
 7dc:	4681                	li	a3,0
 7de:	4641                	li	a2,16
 7e0:	000be583          	lwu	a1,0(s7)
 7e4:	855a                	mv	a0,s6
 7e6:	d9fff0ef          	jal	584 <printint>
 7ea:	8ba6                	mv	s7,s1
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	bd8d                	j	660 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f0:	008b8493          	addi	s1,s7,8
 7f4:	4681                	li	a3,0
 7f6:	4641                	li	a2,16
 7f8:	000bb583          	ld	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	d87ff0ef          	jal	584 <printint>
        i += 1;
 802:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 804:	8ba6                	mv	s7,s1
      state = 0;
 806:	4981                	li	s3,0
        i += 1;
 808:	bda1                	j	660 <vprintf+0x4a>
 80a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 80c:	008b8d13          	addi	s10,s7,8
 810:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 814:	03000593          	li	a1,48
 818:	855a                	mv	a0,s6
 81a:	d4dff0ef          	jal	566 <putc>
  putc(fd, 'x');
 81e:	07800593          	li	a1,120
 822:	855a                	mv	a0,s6
 824:	d43ff0ef          	jal	566 <putc>
 828:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 82a:	00000b97          	auipc	s7,0x0
 82e:	2a6b8b93          	addi	s7,s7,678 # ad0 <digits>
 832:	03c9d793          	srli	a5,s3,0x3c
 836:	97de                	add	a5,a5,s7
 838:	0007c583          	lbu	a1,0(a5)
 83c:	855a                	mv	a0,s6
 83e:	d29ff0ef          	jal	566 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 842:	0992                	slli	s3,s3,0x4
 844:	34fd                	addiw	s1,s1,-1
 846:	f4f5                	bnez	s1,832 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 848:	8bea                	mv	s7,s10
      state = 0;
 84a:	4981                	li	s3,0
 84c:	6d02                	ld	s10,0(sp)
 84e:	bd09                	j	660 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 850:	008b8493          	addi	s1,s7,8
 854:	000bc583          	lbu	a1,0(s7)
 858:	855a                	mv	a0,s6
 85a:	d0dff0ef          	jal	566 <putc>
 85e:	8ba6                	mv	s7,s1
      state = 0;
 860:	4981                	li	s3,0
 862:	bbfd                	j	660 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 864:	008b8993          	addi	s3,s7,8
 868:	000bb483          	ld	s1,0(s7)
 86c:	cc91                	beqz	s1,888 <vprintf+0x272>
        for(; *s; s++)
 86e:	0004c583          	lbu	a1,0(s1)
 872:	c195                	beqz	a1,896 <vprintf+0x280>
          putc(fd, *s);
 874:	855a                	mv	a0,s6
 876:	cf1ff0ef          	jal	566 <putc>
        for(; *s; s++)
 87a:	0485                	addi	s1,s1,1
 87c:	0004c583          	lbu	a1,0(s1)
 880:	f9f5                	bnez	a1,874 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 882:	8bce                	mv	s7,s3
      state = 0;
 884:	4981                	li	s3,0
 886:	bbe9                	j	660 <vprintf+0x4a>
          s = "(null)";
 888:	00000497          	auipc	s1,0x0
 88c:	24048493          	addi	s1,s1,576 # ac8 <malloc+0x130>
        for(; *s; s++)
 890:	02800593          	li	a1,40
 894:	b7c5                	j	874 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 896:	8bce                	mv	s7,s3
      state = 0;
 898:	4981                	li	s3,0
 89a:	b3d9                	j	660 <vprintf+0x4a>
 89c:	6906                	ld	s2,64(sp)
 89e:	79e2                	ld	s3,56(sp)
 8a0:	7a42                	ld	s4,48(sp)
 8a2:	7aa2                	ld	s5,40(sp)
 8a4:	7b02                	ld	s6,32(sp)
 8a6:	6be2                	ld	s7,24(sp)
 8a8:	6c42                	ld	s8,16(sp)
 8aa:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8ac:	60e6                	ld	ra,88(sp)
 8ae:	6446                	ld	s0,80(sp)
 8b0:	64a6                	ld	s1,72(sp)
 8b2:	6125                	addi	sp,sp,96
 8b4:	8082                	ret

00000000000008b6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b6:	715d                	addi	sp,sp,-80
 8b8:	ec06                	sd	ra,24(sp)
 8ba:	e822                	sd	s0,16(sp)
 8bc:	1000                	addi	s0,sp,32
 8be:	e010                	sd	a2,0(s0)
 8c0:	e414                	sd	a3,8(s0)
 8c2:	e818                	sd	a4,16(s0)
 8c4:	ec1c                	sd	a5,24(s0)
 8c6:	03043023          	sd	a6,32(s0)
 8ca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ce:	8622                	mv	a2,s0
 8d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8d4:	d43ff0ef          	jal	616 <vprintf>
}
 8d8:	60e2                	ld	ra,24(sp)
 8da:	6442                	ld	s0,16(sp)
 8dc:	6161                	addi	sp,sp,80
 8de:	8082                	ret

00000000000008e0 <printf>:

void
printf(const char *fmt, ...)
{
 8e0:	711d                	addi	sp,sp,-96
 8e2:	ec06                	sd	ra,24(sp)
 8e4:	e822                	sd	s0,16(sp)
 8e6:	1000                	addi	s0,sp,32
 8e8:	e40c                	sd	a1,8(s0)
 8ea:	e810                	sd	a2,16(s0)
 8ec:	ec14                	sd	a3,24(s0)
 8ee:	f018                	sd	a4,32(s0)
 8f0:	f41c                	sd	a5,40(s0)
 8f2:	03043823          	sd	a6,48(s0)
 8f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8fa:	00840613          	addi	a2,s0,8
 8fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 902:	85aa                	mv	a1,a0
 904:	4505                	li	a0,1
 906:	d11ff0ef          	jal	616 <vprintf>
}
 90a:	60e2                	ld	ra,24(sp)
 90c:	6442                	ld	s0,16(sp)
 90e:	6125                	addi	sp,sp,96
 910:	8082                	ret

0000000000000912 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 912:	1141                	addi	sp,sp,-16
 914:	e406                	sd	ra,8(sp)
 916:	e022                	sd	s0,0(sp)
 918:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 91a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91e:	00000797          	auipc	a5,0x0
 922:	6e27b783          	ld	a5,1762(a5) # 1000 <freep>
 926:	a02d                	j	950 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 928:	4618                	lw	a4,8(a2)
 92a:	9f2d                	addw	a4,a4,a1
 92c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 930:	6398                	ld	a4,0(a5)
 932:	6310                	ld	a2,0(a4)
 934:	a83d                	j	972 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 936:	ff852703          	lw	a4,-8(a0)
 93a:	9f31                	addw	a4,a4,a2
 93c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 93e:	ff053683          	ld	a3,-16(a0)
 942:	a091                	j	986 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 944:	6398                	ld	a4,0(a5)
 946:	00e7e463          	bltu	a5,a4,94e <free+0x3c>
 94a:	00e6ea63          	bltu	a3,a4,95e <free+0x4c>
{
 94e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 950:	fed7fae3          	bgeu	a5,a3,944 <free+0x32>
 954:	6398                	ld	a4,0(a5)
 956:	00e6e463          	bltu	a3,a4,95e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95a:	fee7eae3          	bltu	a5,a4,94e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 95e:	ff852583          	lw	a1,-8(a0)
 962:	6390                	ld	a2,0(a5)
 964:	02059813          	slli	a6,a1,0x20
 968:	01c85713          	srli	a4,a6,0x1c
 96c:	9736                	add	a4,a4,a3
 96e:	fae60de3          	beq	a2,a4,928 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 972:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 976:	4790                	lw	a2,8(a5)
 978:	02061593          	slli	a1,a2,0x20
 97c:	01c5d713          	srli	a4,a1,0x1c
 980:	973e                	add	a4,a4,a5
 982:	fae68ae3          	beq	a3,a4,936 <free+0x24>
    p->s.ptr = bp->s.ptr;
 986:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 988:	00000717          	auipc	a4,0x0
 98c:	66f73c23          	sd	a5,1656(a4) # 1000 <freep>
}
 990:	60a2                	ld	ra,8(sp)
 992:	6402                	ld	s0,0(sp)
 994:	0141                	addi	sp,sp,16
 996:	8082                	ret

0000000000000998 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 998:	7139                	addi	sp,sp,-64
 99a:	fc06                	sd	ra,56(sp)
 99c:	f822                	sd	s0,48(sp)
 99e:	f04a                	sd	s2,32(sp)
 9a0:	ec4e                	sd	s3,24(sp)
 9a2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a4:	02051993          	slli	s3,a0,0x20
 9a8:	0209d993          	srli	s3,s3,0x20
 9ac:	09bd                	addi	s3,s3,15
 9ae:	0049d993          	srli	s3,s3,0x4
 9b2:	2985                	addiw	s3,s3,1
 9b4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9b6:	00000517          	auipc	a0,0x0
 9ba:	64a53503          	ld	a0,1610(a0) # 1000 <freep>
 9be:	c905                	beqz	a0,9ee <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c2:	4798                	lw	a4,8(a5)
 9c4:	09377663          	bgeu	a4,s3,a50 <malloc+0xb8>
 9c8:	f426                	sd	s1,40(sp)
 9ca:	e852                	sd	s4,16(sp)
 9cc:	e456                	sd	s5,8(sp)
 9ce:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9d0:	8a4e                	mv	s4,s3
 9d2:	6705                	lui	a4,0x1
 9d4:	00e9f363          	bgeu	s3,a4,9da <malloc+0x42>
 9d8:	6a05                	lui	s4,0x1
 9da:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9de:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9e2:	00000497          	auipc	s1,0x0
 9e6:	61e48493          	addi	s1,s1,1566 # 1000 <freep>
  if(p == SBRK_ERROR)
 9ea:	5afd                	li	s5,-1
 9ec:	a83d                	j	a2a <malloc+0x92>
 9ee:	f426                	sd	s1,40(sp)
 9f0:	e852                	sd	s4,16(sp)
 9f2:	e456                	sd	s5,8(sp)
 9f4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9f6:	00000797          	auipc	a5,0x0
 9fa:	61a78793          	addi	a5,a5,1562 # 1010 <base>
 9fe:	00000717          	auipc	a4,0x0
 a02:	60f73123          	sd	a5,1538(a4) # 1000 <freep>
 a06:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a08:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a0c:	b7d1                	j	9d0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a0e:	6398                	ld	a4,0(a5)
 a10:	e118                	sd	a4,0(a0)
 a12:	a899                	j	a68 <malloc+0xd0>
  hp->s.size = nu;
 a14:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a18:	0541                	addi	a0,a0,16
 a1a:	ef9ff0ef          	jal	912 <free>
  return freep;
 a1e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a20:	c125                	beqz	a0,a80 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a22:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a24:	4798                	lw	a4,8(a5)
 a26:	03277163          	bgeu	a4,s2,a48 <malloc+0xb0>
    if(p == freep)
 a2a:	6098                	ld	a4,0(s1)
 a2c:	853e                	mv	a0,a5
 a2e:	fef71ae3          	bne	a4,a5,a22 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a32:	8552                	mv	a0,s4
 a34:	8c7ff0ef          	jal	2fa <sbrk>
  if(p == SBRK_ERROR)
 a38:	fd551ee3          	bne	a0,s5,a14 <malloc+0x7c>
        return 0;
 a3c:	4501                	li	a0,0
 a3e:	74a2                	ld	s1,40(sp)
 a40:	6a42                	ld	s4,16(sp)
 a42:	6aa2                	ld	s5,8(sp)
 a44:	6b02                	ld	s6,0(sp)
 a46:	a03d                	j	a74 <malloc+0xdc>
 a48:	74a2                	ld	s1,40(sp)
 a4a:	6a42                	ld	s4,16(sp)
 a4c:	6aa2                	ld	s5,8(sp)
 a4e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a50:	fae90fe3          	beq	s2,a4,a0e <malloc+0x76>
        p->s.size -= nunits;
 a54:	4137073b          	subw	a4,a4,s3
 a58:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a5a:	02071693          	slli	a3,a4,0x20
 a5e:	01c6d713          	srli	a4,a3,0x1c
 a62:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a64:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a68:	00000717          	auipc	a4,0x0
 a6c:	58a73c23          	sd	a0,1432(a4) # 1000 <freep>
      return (void*)(p + 1);
 a70:	01078513          	addi	a0,a5,16
  }
}
 a74:	70e2                	ld	ra,56(sp)
 a76:	7442                	ld	s0,48(sp)
 a78:	7902                	ld	s2,32(sp)
 a7a:	69e2                	ld	s3,24(sp)
 a7c:	6121                	addi	sp,sp,64
 a7e:	8082                	ret
 a80:	74a2                	ld	s1,40(sp)
 a82:	6a42                	ld	s4,16(sp)
 a84:	6aa2                	ld	s5,8(sp)
 a86:	6b02                	ld	s6,0(sp)
 a88:	b7f5                	j	a74 <malloc+0xdc>
