
user/_dorphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)

  if(mkdir("dd") != 0){
   c:	00001517          	auipc	a0,0x1
  10:	aa450513          	addi	a0,a0,-1372 # ab0 <malloc+0xf2>
  14:	520000ef          	jal	534 <mkdir>
  18:	c919                	beqz	a0,2e <main+0x2e>
    printf("%s: mkdir dd failed\n", s);
  1a:	85a6                	mv	a1,s1
  1c:	00001517          	auipc	a0,0x1
  20:	a9c50513          	addi	a0,a0,-1380 # ab8 <malloc+0xfa>
  24:	0e3000ef          	jal	906 <printf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	4a2000ef          	jal	4cc <exit>
  }

  if(chdir("dd") != 0){
  2e:	00001517          	auipc	a0,0x1
  32:	a8250513          	addi	a0,a0,-1406 # ab0 <malloc+0xf2>
  36:	506000ef          	jal	53c <chdir>
  3a:	c919                	beqz	a0,50 <main+0x50>
    printf("%s: chdir dd failed\n", s);
  3c:	85a6                	mv	a1,s1
  3e:	00001517          	auipc	a0,0x1
  42:	a9250513          	addi	a0,a0,-1390 # ad0 <malloc+0x112>
  46:	0c1000ef          	jal	906 <printf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	480000ef          	jal	4cc <exit>
  }

  if (unlink("../dd") < 0) {
  50:	00001517          	auipc	a0,0x1
  54:	a9850513          	addi	a0,a0,-1384 # ae8 <malloc+0x12a>
  58:	4c4000ef          	jal	51c <unlink>
  5c:	00054e63          	bltz	a0,78 <main+0x78>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  printf("wait for kill and reclaim\n");
  60:	00001517          	auipc	a0,0x1
  64:	aa850513          	addi	a0,a0,-1368 # b08 <malloc+0x14a>
  68:	09f000ef          	jal	906 <printf>
  // sit around until killed
  for(;;) pause(1000);
  6c:	3e800493          	li	s1,1000
  70:	8526                	mv	a0,s1
  72:	4ea000ef          	jal	55c <pause>
  76:	bfed                	j	70 <main+0x70>
    printf("%s: unlink failed\n", s);
  78:	85a6                	mv	a1,s1
  7a:	00001517          	auipc	a0,0x1
  7e:	a7650513          	addi	a0,a0,-1418 # af0 <malloc+0x132>
  82:	085000ef          	jal	906 <printf>
    exit(1);
  86:	4505                	li	a0,1
  88:	444000ef          	jal	4cc <exit>

000000000000008c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  94:	f6dff0ef          	jal	0 <main>
  exit(r);
  98:	434000ef          	jal	4cc <exit>

000000000000009c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e406                	sd	ra,8(sp)
  a0:	e022                	sd	s0,0(sp)
  a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a4:	87aa                	mv	a5,a0
  a6:	0585                	addi	a1,a1,1
  a8:	0785                	addi	a5,a5,1
  aa:	fff5c703          	lbu	a4,-1(a1)
  ae:	fee78fa3          	sb	a4,-1(a5)
  b2:	fb75                	bnez	a4,a6 <strcpy+0xa>
    ;
  return os;
}
  b4:	60a2                	ld	ra,8(sp)
  b6:	6402                	ld	s0,0(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb91                	beqz	a5,dc <strcmp+0x20>
  ca:	0005c703          	lbu	a4,0(a1)
  ce:	00f71763          	bne	a4,a5,dc <strcmp+0x20>
    p++, q++;
  d2:	0505                	addi	a0,a0,1
  d4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbe5                	bnez	a5,ca <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  dc:	0005c503          	lbu	a0,0(a1)
}
  e0:	40a7853b          	subw	a0,a5,a0
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strlen>:

uint
strlen(const char *s)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cf99                	beqz	a5,116 <strlen+0x2a>
  fa:	0505                	addi	a0,a0,1
  fc:	87aa                	mv	a5,a0
  fe:	86be                	mv	a3,a5
 100:	0785                	addi	a5,a5,1
 102:	fff7c703          	lbu	a4,-1(a5)
 106:	ff65                	bnez	a4,fe <strlen+0x12>
 108:	40a6853b          	subw	a0,a3,a0
 10c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 10e:	60a2                	ld	ra,8(sp)
 110:	6402                	ld	s0,0(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret
  for(n = 0; s[n]; n++)
 116:	4501                	li	a0,0
 118:	bfdd                	j	10e <strlen+0x22>

000000000000011a <memset>:

void*
memset(void *dst, int c, uint n)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e406                	sd	ra,8(sp)
 11e:	e022                	sd	s0,0(sp)
 120:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 122:	ca19                	beqz	a2,138 <memset+0x1e>
 124:	87aa                	mv	a5,a0
 126:	1602                	slli	a2,a2,0x20
 128:	9201                	srli	a2,a2,0x20
 12a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 12e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 132:	0785                	addi	a5,a5,1
 134:	fee79de3          	bne	a5,a4,12e <memset+0x14>
  }
  return dst;
}
 138:	60a2                	ld	ra,8(sp)
 13a:	6402                	ld	s0,0(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	1141                	addi	sp,sp,-16
 142:	e406                	sd	ra,8(sp)
 144:	e022                	sd	s0,0(sp)
 146:	0800                	addi	s0,sp,16
  for(; *s; s++)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cf81                	beqz	a5,164 <strchr+0x24>
    if(*s == c)
 14e:	00f58763          	beq	a1,a5,15c <strchr+0x1c>
  for(; *s; s++)
 152:	0505                	addi	a0,a0,1
 154:	00054783          	lbu	a5,0(a0)
 158:	fbfd                	bnez	a5,14e <strchr+0xe>
      return (char*)s;
  return 0;
 15a:	4501                	li	a0,0
}
 15c:	60a2                	ld	ra,8(sp)
 15e:	6402                	ld	s0,0(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret
  return 0;
 164:	4501                	li	a0,0
 166:	bfdd                	j	15c <strchr+0x1c>

0000000000000168 <gets>:

char*
gets(char *buf, int max)
{
 168:	7159                	addi	sp,sp,-112
 16a:	f486                	sd	ra,104(sp)
 16c:	f0a2                	sd	s0,96(sp)
 16e:	eca6                	sd	s1,88(sp)
 170:	e8ca                	sd	s2,80(sp)
 172:	e4ce                	sd	s3,72(sp)
 174:	e0d2                	sd	s4,64(sp)
 176:	fc56                	sd	s5,56(sp)
 178:	f85a                	sd	s6,48(sp)
 17a:	f45e                	sd	s7,40(sp)
 17c:	f062                	sd	s8,32(sp)
 17e:	ec66                	sd	s9,24(sp)
 180:	e86a                	sd	s10,16(sp)
 182:	1880                	addi	s0,sp,112
 184:	8caa                	mv	s9,a0
 186:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 188:	892a                	mv	s2,a0
 18a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 18c:	f9f40b13          	addi	s6,s0,-97
 190:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 192:	4ba9                	li	s7,10
 194:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 196:	8d26                	mv	s10,s1
 198:	0014899b          	addiw	s3,s1,1
 19c:	84ce                	mv	s1,s3
 19e:	0349d563          	bge	s3,s4,1c8 <gets+0x60>
    cc = read(0, &c, 1);
 1a2:	8656                	mv	a2,s5
 1a4:	85da                	mv	a1,s6
 1a6:	4501                	li	a0,0
 1a8:	33c000ef          	jal	4e4 <read>
    if(cc < 1)
 1ac:	00a05e63          	blez	a0,1c8 <gets+0x60>
    buf[i++] = c;
 1b0:	f9f44783          	lbu	a5,-97(s0)
 1b4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1b8:	01778763          	beq	a5,s7,1c6 <gets+0x5e>
 1bc:	0905                	addi	s2,s2,1
 1be:	fd879ce3          	bne	a5,s8,196 <gets+0x2e>
    buf[i++] = c;
 1c2:	8d4e                	mv	s10,s3
 1c4:	a011                	j	1c8 <gets+0x60>
 1c6:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1c8:	9d66                	add	s10,s10,s9
 1ca:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1ce:	8566                	mv	a0,s9
 1d0:	70a6                	ld	ra,104(sp)
 1d2:	7406                	ld	s0,96(sp)
 1d4:	64e6                	ld	s1,88(sp)
 1d6:	6946                	ld	s2,80(sp)
 1d8:	69a6                	ld	s3,72(sp)
 1da:	6a06                	ld	s4,64(sp)
 1dc:	7ae2                	ld	s5,56(sp)
 1de:	7b42                	ld	s6,48(sp)
 1e0:	7ba2                	ld	s7,40(sp)
 1e2:	7c02                	ld	s8,32(sp)
 1e4:	6ce2                	ld	s9,24(sp)
 1e6:	6d42                	ld	s10,16(sp)
 1e8:	6165                	addi	sp,sp,112
 1ea:	8082                	ret

00000000000001ec <stat>:

int
stat(const char *n, struct stat *st)
{
 1ec:	1101                	addi	sp,sp,-32
 1ee:	ec06                	sd	ra,24(sp)
 1f0:	e822                	sd	s0,16(sp)
 1f2:	e04a                	sd	s2,0(sp)
 1f4:	1000                	addi	s0,sp,32
 1f6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f8:	4581                	li	a1,0
 1fa:	312000ef          	jal	50c <open>
  if(fd < 0)
 1fe:	02054263          	bltz	a0,222 <stat+0x36>
 202:	e426                	sd	s1,8(sp)
 204:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 206:	85ca                	mv	a1,s2
 208:	31c000ef          	jal	524 <fstat>
 20c:	892a                	mv	s2,a0
  close(fd);
 20e:	8526                	mv	a0,s1
 210:	2e4000ef          	jal	4f4 <close>
  return r;
 214:	64a2                	ld	s1,8(sp)
}
 216:	854a                	mv	a0,s2
 218:	60e2                	ld	ra,24(sp)
 21a:	6442                	ld	s0,16(sp)
 21c:	6902                	ld	s2,0(sp)
 21e:	6105                	addi	sp,sp,32
 220:	8082                	ret
    return -1;
 222:	597d                	li	s2,-1
 224:	bfcd                	j	216 <stat+0x2a>

0000000000000226 <atoi>:

int
atoi(const char *s)
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22e:	00054683          	lbu	a3,0(a0)
 232:	fd06879b          	addiw	a5,a3,-48
 236:	0ff7f793          	zext.b	a5,a5
 23a:	4625                	li	a2,9
 23c:	02f66963          	bltu	a2,a5,26e <atoi+0x48>
 240:	872a                	mv	a4,a0
  n = 0;
 242:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 244:	0705                	addi	a4,a4,1
 246:	0025179b          	slliw	a5,a0,0x2
 24a:	9fa9                	addw	a5,a5,a0
 24c:	0017979b          	slliw	a5,a5,0x1
 250:	9fb5                	addw	a5,a5,a3
 252:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 256:	00074683          	lbu	a3,0(a4)
 25a:	fd06879b          	addiw	a5,a3,-48
 25e:	0ff7f793          	zext.b	a5,a5
 262:	fef671e3          	bgeu	a2,a5,244 <atoi+0x1e>
  return n;
}
 266:	60a2                	ld	ra,8(sp)
 268:	6402                	ld	s0,0(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret
  n = 0;
 26e:	4501                	li	a0,0
 270:	bfdd                	j	266 <atoi+0x40>

0000000000000272 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 272:	1141                	addi	sp,sp,-16
 274:	e406                	sd	ra,8(sp)
 276:	e022                	sd	s0,0(sp)
 278:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 27a:	02b57563          	bgeu	a0,a1,2a4 <memmove+0x32>
    while(n-- > 0)
 27e:	00c05f63          	blez	a2,29c <memmove+0x2a>
 282:	1602                	slli	a2,a2,0x20
 284:	9201                	srli	a2,a2,0x20
 286:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 28a:	872a                	mv	a4,a0
      *dst++ = *src++;
 28c:	0585                	addi	a1,a1,1
 28e:	0705                	addi	a4,a4,1
 290:	fff5c683          	lbu	a3,-1(a1)
 294:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 298:	fee79ae3          	bne	a5,a4,28c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
    dst += n;
 2a4:	00c50733          	add	a4,a0,a2
    src += n;
 2a8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2aa:	fec059e3          	blez	a2,29c <memmove+0x2a>
 2ae:	fff6079b          	addiw	a5,a2,-1
 2b2:	1782                	slli	a5,a5,0x20
 2b4:	9381                	srli	a5,a5,0x20
 2b6:	fff7c793          	not	a5,a5
 2ba:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2bc:	15fd                	addi	a1,a1,-1
 2be:	177d                	addi	a4,a4,-1
 2c0:	0005c683          	lbu	a3,0(a1)
 2c4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c8:	fef71ae3          	bne	a4,a5,2bc <memmove+0x4a>
 2cc:	bfc1                	j	29c <memmove+0x2a>

00000000000002ce <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d6:	ca0d                	beqz	a2,308 <memcmp+0x3a>
 2d8:	fff6069b          	addiw	a3,a2,-1
 2dc:	1682                	slli	a3,a3,0x20
 2de:	9281                	srli	a3,a3,0x20
 2e0:	0685                	addi	a3,a3,1
 2e2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	0005c703          	lbu	a4,0(a1)
 2ec:	00e79863          	bne	a5,a4,2fc <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2f0:	0505                	addi	a0,a0,1
    p2++;
 2f2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f4:	fed518e3          	bne	a0,a3,2e4 <memcmp+0x16>
  }
  return 0;
 2f8:	4501                	li	a0,0
 2fa:	a019                	j	300 <memcmp+0x32>
      return *p1 - *p2;
 2fc:	40e7853b          	subw	a0,a5,a4
}
 300:	60a2                	ld	ra,8(sp)
 302:	6402                	ld	s0,0(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret
  return 0;
 308:	4501                	li	a0,0
 30a:	bfdd                	j	300 <memcmp+0x32>

000000000000030c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e406                	sd	ra,8(sp)
 310:	e022                	sd	s0,0(sp)
 312:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 314:	f5fff0ef          	jal	272 <memmove>
}
 318:	60a2                	ld	ra,8(sp)
 31a:	6402                	ld	s0,0(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret

0000000000000320 <sbrk>:

char *
sbrk(int n) {
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 328:	4585                	li	a1,1
 32a:	22a000ef          	jal	554 <sys_sbrk>
}
 32e:	60a2                	ld	ra,8(sp)
 330:	6402                	ld	s0,0(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret

0000000000000336 <sbrklazy>:

char *
sbrklazy(int n) {
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 33e:	4589                	li	a1,2
 340:	214000ef          	jal	554 <sys_sbrk>
}
 344:	60a2                	ld	ra,8(sp)
 346:	6402                	ld	s0,0(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret

000000000000034c <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 34c:	1101                	addi	sp,sp,-32
 34e:	ec06                	sd	ra,24(sp)
 350:	e822                	sd	s0,16(sp)
 352:	e426                	sd	s1,8(sp)
 354:	e04a                	sd	s2,0(sp)
 356:	1000                	addi	s0,sp,32
 358:	84aa                	mv	s1,a0
 35a:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 35c:	6505                	lui	a0,0x1
 35e:	fc3ff0ef          	jal	320 <sbrk>
 362:	6785                	lui	a5,0x1
 364:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 368:	9a41                	andi	a2,a2,-16
 36a:	85ca                	mv	a1,s2
 36c:	8526                	mv	a0,s1
 36e:	1fe000ef          	jal	56c <clone>
}
 372:	60e2                	ld	ra,24(sp)
 374:	6442                	ld	s0,16(sp)
 376:	64a2                	ld	s1,8(sp)
 378:	6902                	ld	s2,0(sp)
 37a:	6105                	addi	sp,sp,32
 37c:	8082                	ret

000000000000037e <futex>:

void futex(int *uaddr, int ops, int val) {
 37e:	7179                	addi	sp,sp,-48
 380:	f406                	sd	ra,40(sp)
 382:	f022                	sd	s0,32(sp)
 384:	ec26                	sd	s1,24(sp)
 386:	1800                	addi	s0,sp,48
 388:	84aa                	mv	s1,a0
  if (ops==0) {
 38a:	ed95                	bnez	a1,3c6 <futex+0x48>
    if (val==0) {
 38c:	c611                	beqz	a2,398 <futex+0x1a>
 38e:	e84a                	sd	s2,16(sp)
 390:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 392:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 394:	4985                	li	s3,1
 396:	a005                	j	3b6 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 398:	4705                	li	a4,1
 39a:	87ba                	mv	a5,a4
 39c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 3a0:	2781                	sext.w	a5,a5
 3a2:	ffe5                	bnez	a5,39a <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 3a4:	70a2                	ld	ra,40(sp)
 3a6:	7402                	ld	s0,32(sp)
 3a8:	64e2                	ld	s1,24(sp)
 3aa:	6145                	addi	sp,sp,48
 3ac:	8082                	ret
        futex_wait(uaddr, 1);
 3ae:	85ce                	mv	a1,s3
 3b0:	8526                	mv	a0,s1
 3b2:	1ca000ef          	jal	57c <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 3b6:	87ca                	mv	a5,s2
 3b8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 3bc:	2781                	sext.w	a5,a5
 3be:	fbe5                	bnez	a5,3ae <futex+0x30>
 3c0:	6942                	ld	s2,16(sp)
 3c2:	69a2                	ld	s3,8(sp)
 3c4:	b7c5                	j	3a4 <futex+0x26>
    if (val==0) {
 3c6:	e611                	bnez	a2,3d2 <futex+0x54>
      __sync_lock_release(uaddr);
 3c8:	0310000f          	fence	rw,w
 3cc:	00052023          	sw	zero,0(a0) # 1000 <freep>
 3d0:	bfd1                	j	3a4 <futex+0x26>
      __sync_lock_release(uaddr);
 3d2:	0310000f          	fence	rw,w
 3d6:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 3da:	1aa000ef          	jal	584 <futex_wake>
  return;
 3de:	b7d9                	j	3a4 <futex+0x26>

00000000000003e0 <sem_init>:

void sem_init(sem_t* s, int val) {
 3e0:	7179                	addi	sp,sp,-48
 3e2:	f406                	sd	ra,40(sp)
 3e4:	f022                	sd	s0,32(sp)
 3e6:	ec26                	sd	s1,24(sp)
 3e8:	e84a                	sd	s2,16(sp)
 3ea:	e44e                	sd	s3,8(sp)
 3ec:	1800                	addi	s0,sp,48
 3ee:	84aa                	mv	s1,a0
 3f0:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 3f2:	00450993          	addi	s3,a0,4
 3f6:	4605                	li	a2,1
 3f8:	4581                	li	a1,0
 3fa:	854e                	mv	a0,s3
 3fc:	f83ff0ef          	jal	37e <futex>
  s->value = val;
 400:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 404:	4605                	li	a2,1
 406:	85b2                	mv	a1,a2
 408:	854e                	mv	a0,s3
 40a:	f75ff0ef          	jal	37e <futex>
  return;
}
 40e:	70a2                	ld	ra,40(sp)
 410:	7402                	ld	s0,32(sp)
 412:	64e2                	ld	s1,24(sp)
 414:	6942                	ld	s2,16(sp)
 416:	69a2                	ld	s3,8(sp)
 418:	6145                	addi	sp,sp,48
 41a:	8082                	ret

000000000000041c <sem_down>:

void sem_down(sem_t* s) {
 41c:	7179                	addi	sp,sp,-48
 41e:	f406                	sd	ra,40(sp)
 420:	f022                	sd	s0,32(sp)
 422:	ec26                	sd	s1,24(sp)
 424:	e84a                	sd	s2,16(sp)
 426:	e44e                	sd	s3,8(sp)
 428:	1800                	addi	s0,sp,48
 42a:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 42c:	00450993          	addi	s3,a0,4
 430:	4605                	li	a2,1
 432:	4581                	li	a1,0
 434:	854e                	mv	a0,s3
 436:	f49ff0ef          	jal	37e <futex>
  while(1) {
    if (s->value>0) {
 43a:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 43e:	4485                	li	s1,1
    if (s->value>0) {
 440:	02f04463          	bgtz	a5,468 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 444:	8626                	mv	a2,s1
 446:	85a6                	mv	a1,s1
 448:	854e                	mv	a0,s3
 44a:	f35ff0ef          	jal	37e <futex>
      futex_wait(&s->value,1);
 44e:	85a6                	mv	a1,s1
 450:	854a                	mv	a0,s2
 452:	12a000ef          	jal	57c <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 456:	8626                	mv	a2,s1
 458:	4581                	li	a1,0
 45a:	854e                	mv	a0,s3
 45c:	f23ff0ef          	jal	37e <futex>
    if (s->value>0) {
 460:	00092783          	lw	a5,0(s2)
 464:	fef050e3          	blez	a5,444 <sem_down+0x28>
      s->value--;
 468:	37fd                	addiw	a5,a5,-1 # fff <digits+0x4cf>
 46a:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 46e:	4605                	li	a2,1
 470:	85b2                	mv	a1,a2
 472:	854e                	mv	a0,s3
 474:	f0bff0ef          	jal	37e <futex>
  return;
}
 478:	70a2                	ld	ra,40(sp)
 47a:	7402                	ld	s0,32(sp)
 47c:	64e2                	ld	s1,24(sp)
 47e:	6942                	ld	s2,16(sp)
 480:	69a2                	ld	s3,8(sp)
 482:	6145                	addi	sp,sp,48
 484:	8082                	ret

0000000000000486 <sem_up>:

void sem_up(sem_t* s) {
 486:	1101                	addi	sp,sp,-32
 488:	ec06                	sd	ra,24(sp)
 48a:	e822                	sd	s0,16(sp)
 48c:	e426                	sd	s1,8(sp)
 48e:	e04a                	sd	s2,0(sp)
 490:	1000                	addi	s0,sp,32
 492:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 494:	00450913          	addi	s2,a0,4
 498:	4605                	li	a2,1
 49a:	4581                	li	a1,0
 49c:	854a                	mv	a0,s2
 49e:	ee1ff0ef          	jal	37e <futex>
  s->value++;
 4a2:	409c                	lw	a5,0(s1)
 4a4:	2785                	addiw	a5,a5,1
 4a6:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 4a8:	8526                	mv	a0,s1
 4aa:	0da000ef          	jal	584 <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4ae:	4605                	li	a2,1
 4b0:	85b2                	mv	a1,a2
 4b2:	854a                	mv	a0,s2
 4b4:	ecbff0ef          	jal	37e <futex>
  return;
 4b8:	60e2                	ld	ra,24(sp)
 4ba:	6442                	ld	s0,16(sp)
 4bc:	64a2                	ld	s1,8(sp)
 4be:	6902                	ld	s2,0(sp)
 4c0:	6105                	addi	sp,sp,32
 4c2:	8082                	ret

00000000000004c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4c4:	4885                	li	a7,1
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <exit>:
.global exit
exit:
 li a7, SYS_exit
 4cc:	4889                	li	a7,2
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4d4:	488d                	li	a7,3
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4dc:	4891                	li	a7,4
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <read>:
.global read
read:
 li a7, SYS_read
 4e4:	4895                	li	a7,5
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <write>:
.global write
write:
 li a7, SYS_write
 4ec:	48c1                	li	a7,16
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <close>:
.global close
close:
 li a7, SYS_close
 4f4:	48d5                	li	a7,21
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <kill>:
.global kill
kill:
 li a7, SYS_kill
 4fc:	4899                	li	a7,6
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <exec>:
.global exec
exec:
 li a7, SYS_exec
 504:	489d                	li	a7,7
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <open>:
.global open
open:
 li a7, SYS_open
 50c:	48bd                	li	a7,15
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 514:	48c5                	li	a7,17
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 51c:	48c9                	li	a7,18
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 524:	48a1                	li	a7,8
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <link>:
.global link
link:
 li a7, SYS_link
 52c:	48cd                	li	a7,19
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 534:	48d1                	li	a7,20
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 53c:	48a5                	li	a7,9
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <dup>:
.global dup
dup:
 li a7, SYS_dup
 544:	48a9                	li	a7,10
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 54c:	48ad                	li	a7,11
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 554:	48b1                	li	a7,12
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <pause>:
.global pause
pause:
 li a7, SYS_pause
 55c:	48b5                	li	a7,13
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 564:	48b9                	li	a7,14
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <clone>:
.global clone
clone:
 li a7, SYS_clone
 56c:	48d9                	li	a7,22
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <join>:
.global join
join:
 li a7, SYS_join
 574:	48dd                	li	a7,23
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 57c:	48e1                	li	a7,24
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 584:	48e5                	li	a7,25
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 58c:	1101                	addi	sp,sp,-32
 58e:	ec06                	sd	ra,24(sp)
 590:	e822                	sd	s0,16(sp)
 592:	1000                	addi	s0,sp,32
 594:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 598:	4605                	li	a2,1
 59a:	fef40593          	addi	a1,s0,-17
 59e:	f4fff0ef          	jal	4ec <write>
}
 5a2:	60e2                	ld	ra,24(sp)
 5a4:	6442                	ld	s0,16(sp)
 5a6:	6105                	addi	sp,sp,32
 5a8:	8082                	ret

00000000000005aa <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5aa:	715d                	addi	sp,sp,-80
 5ac:	e486                	sd	ra,72(sp)
 5ae:	e0a2                	sd	s0,64(sp)
 5b0:	fc26                	sd	s1,56(sp)
 5b2:	f84a                	sd	s2,48(sp)
 5b4:	f44e                	sd	s3,40(sp)
 5b6:	0880                	addi	s0,sp,80
 5b8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5ba:	c299                	beqz	a3,5c0 <printint+0x16>
 5bc:	0605cc63          	bltz	a1,634 <printint+0x8a>
  neg = 0;
 5c0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5c2:	fb840313          	addi	t1,s0,-72
  neg = 0;
 5c6:	869a                	mv	a3,t1
  i = 0;
 5c8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5ca:	00000817          	auipc	a6,0x0
 5ce:	56680813          	addi	a6,a6,1382 # b30 <digits>
 5d2:	88be                	mv	a7,a5
 5d4:	0017851b          	addiw	a0,a5,1
 5d8:	87aa                	mv	a5,a0
 5da:	02c5f733          	remu	a4,a1,a2
 5de:	9742                	add	a4,a4,a6
 5e0:	00074703          	lbu	a4,0(a4)
 5e4:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5e8:	872e                	mv	a4,a1
 5ea:	02c5d5b3          	divu	a1,a1,a2
 5ee:	0685                	addi	a3,a3,1
 5f0:	fec771e3          	bgeu	a4,a2,5d2 <printint+0x28>
  if(neg)
 5f4:	000e0c63          	beqz	t3,60c <printint+0x62>
    buf[i++] = '-';
 5f8:	fd050793          	addi	a5,a0,-48
 5fc:	00878533          	add	a0,a5,s0
 600:	02d00793          	li	a5,45
 604:	fef50423          	sb	a5,-24(a0)
 608:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 60c:	fff7899b          	addiw	s3,a5,-1
 610:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 614:	fff4c583          	lbu	a1,-1(s1)
 618:	854a                	mv	a0,s2
 61a:	f73ff0ef          	jal	58c <putc>
  while(--i >= 0)
 61e:	39fd                	addiw	s3,s3,-1
 620:	14fd                	addi	s1,s1,-1
 622:	fe09d9e3          	bgez	s3,614 <printint+0x6a>
}
 626:	60a6                	ld	ra,72(sp)
 628:	6406                	ld	s0,64(sp)
 62a:	74e2                	ld	s1,56(sp)
 62c:	7942                	ld	s2,48(sp)
 62e:	79a2                	ld	s3,40(sp)
 630:	6161                	addi	sp,sp,80
 632:	8082                	ret
    x = -xx;
 634:	40b005b3          	neg	a1,a1
    neg = 1;
 638:	4e05                	li	t3,1
    x = -xx;
 63a:	b761                	j	5c2 <printint+0x18>

000000000000063c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 63c:	711d                	addi	sp,sp,-96
 63e:	ec86                	sd	ra,88(sp)
 640:	e8a2                	sd	s0,80(sp)
 642:	e4a6                	sd	s1,72(sp)
 644:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 646:	0005c483          	lbu	s1,0(a1)
 64a:	28048463          	beqz	s1,8d2 <vprintf+0x296>
 64e:	e0ca                	sd	s2,64(sp)
 650:	fc4e                	sd	s3,56(sp)
 652:	f852                	sd	s4,48(sp)
 654:	f456                	sd	s5,40(sp)
 656:	f05a                	sd	s6,32(sp)
 658:	ec5e                	sd	s7,24(sp)
 65a:	e862                	sd	s8,16(sp)
 65c:	e466                	sd	s9,8(sp)
 65e:	8b2a                	mv	s6,a0
 660:	8a2e                	mv	s4,a1
 662:	8bb2                	mv	s7,a2
  state = 0;
 664:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 666:	4901                	li	s2,0
 668:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 66a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 66e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 672:	06c00c93          	li	s9,108
 676:	a00d                	j	698 <vprintf+0x5c>
        putc(fd, c0);
 678:	85a6                	mv	a1,s1
 67a:	855a                	mv	a0,s6
 67c:	f11ff0ef          	jal	58c <putc>
 680:	a019                	j	686 <vprintf+0x4a>
    } else if(state == '%'){
 682:	03598363          	beq	s3,s5,6a8 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 686:	0019079b          	addiw	a5,s2,1
 68a:	893e                	mv	s2,a5
 68c:	873e                	mv	a4,a5
 68e:	97d2                	add	a5,a5,s4
 690:	0007c483          	lbu	s1,0(a5)
 694:	22048763          	beqz	s1,8c2 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 698:	0004879b          	sext.w	a5,s1
    if(state == 0){
 69c:	fe0993e3          	bnez	s3,682 <vprintf+0x46>
      if(c0 == '%'){
 6a0:	fd579ce3          	bne	a5,s5,678 <vprintf+0x3c>
        state = '%';
 6a4:	89be                	mv	s3,a5
 6a6:	b7c5                	j	686 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6a8:	00ea06b3          	add	a3,s4,a4
 6ac:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6b0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6b2:	c681                	beqz	a3,6ba <vprintf+0x7e>
 6b4:	9752                	add	a4,a4,s4
 6b6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6ba:	05878263          	beq	a5,s8,6fe <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6be:	05978c63          	beq	a5,s9,716 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6c2:	07500713          	li	a4,117
 6c6:	0ee78663          	beq	a5,a4,7b2 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6ca:	07800713          	li	a4,120
 6ce:	12e78863          	beq	a5,a4,7fe <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6d2:	07000713          	li	a4,112
 6d6:	14e78d63          	beq	a5,a4,830 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 6da:	06300713          	li	a4,99
 6de:	18e78c63          	beq	a5,a4,876 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 6e2:	07300713          	li	a4,115
 6e6:	1ae78263          	beq	a5,a4,88a <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6ea:	02500713          	li	a4,37
 6ee:	04e79463          	bne	a5,a4,736 <vprintf+0xfa>
        putc(fd, '%');
 6f2:	85ba                	mv	a1,a4
 6f4:	855a                	mv	a0,s6
 6f6:	e97ff0ef          	jal	58c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b769                	j	686 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6fe:	008b8493          	addi	s1,s7,8
 702:	4685                	li	a3,1
 704:	4629                	li	a2,10
 706:	000ba583          	lw	a1,0(s7)
 70a:	855a                	mv	a0,s6
 70c:	e9fff0ef          	jal	5aa <printint>
 710:	8ba6                	mv	s7,s1
      state = 0;
 712:	4981                	li	s3,0
 714:	bf8d                	j	686 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 716:	06400793          	li	a5,100
 71a:	02f68963          	beq	a3,a5,74c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 71e:	06c00793          	li	a5,108
 722:	04f68263          	beq	a3,a5,766 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 726:	07500793          	li	a5,117
 72a:	0af68063          	beq	a3,a5,7ca <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 72e:	07800793          	li	a5,120
 732:	0ef68263          	beq	a3,a5,816 <vprintf+0x1da>
        putc(fd, '%');
 736:	02500593          	li	a1,37
 73a:	855a                	mv	a0,s6
 73c:	e51ff0ef          	jal	58c <putc>
        putc(fd, c0);
 740:	85a6                	mv	a1,s1
 742:	855a                	mv	a0,s6
 744:	e49ff0ef          	jal	58c <putc>
      state = 0;
 748:	4981                	li	s3,0
 74a:	bf35                	j	686 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 74c:	008b8493          	addi	s1,s7,8
 750:	4685                	li	a3,1
 752:	4629                	li	a2,10
 754:	000bb583          	ld	a1,0(s7)
 758:	855a                	mv	a0,s6
 75a:	e51ff0ef          	jal	5aa <printint>
        i += 1;
 75e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 760:	8ba6                	mv	s7,s1
      state = 0;
 762:	4981                	li	s3,0
        i += 1;
 764:	b70d                	j	686 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 766:	06400793          	li	a5,100
 76a:	02f60763          	beq	a2,a5,798 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 76e:	07500793          	li	a5,117
 772:	06f60963          	beq	a2,a5,7e4 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 776:	07800793          	li	a5,120
 77a:	faf61ee3          	bne	a2,a5,736 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 77e:	008b8493          	addi	s1,s7,8
 782:	4681                	li	a3,0
 784:	4641                	li	a2,16
 786:	000bb583          	ld	a1,0(s7)
 78a:	855a                	mv	a0,s6
 78c:	e1fff0ef          	jal	5aa <printint>
        i += 2;
 790:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 792:	8ba6                	mv	s7,s1
      state = 0;
 794:	4981                	li	s3,0
        i += 2;
 796:	bdc5                	j	686 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 798:	008b8493          	addi	s1,s7,8
 79c:	4685                	li	a3,1
 79e:	4629                	li	a2,10
 7a0:	000bb583          	ld	a1,0(s7)
 7a4:	855a                	mv	a0,s6
 7a6:	e05ff0ef          	jal	5aa <printint>
        i += 2;
 7aa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ac:	8ba6                	mv	s7,s1
      state = 0;
 7ae:	4981                	li	s3,0
        i += 2;
 7b0:	bdd9                	j	686 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7b2:	008b8493          	addi	s1,s7,8
 7b6:	4681                	li	a3,0
 7b8:	4629                	li	a2,10
 7ba:	000be583          	lwu	a1,0(s7)
 7be:	855a                	mv	a0,s6
 7c0:	debff0ef          	jal	5aa <printint>
 7c4:	8ba6                	mv	s7,s1
      state = 0;
 7c6:	4981                	li	s3,0
 7c8:	bd7d                	j	686 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ca:	008b8493          	addi	s1,s7,8
 7ce:	4681                	li	a3,0
 7d0:	4629                	li	a2,10
 7d2:	000bb583          	ld	a1,0(s7)
 7d6:	855a                	mv	a0,s6
 7d8:	dd3ff0ef          	jal	5aa <printint>
        i += 1;
 7dc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7de:	8ba6                	mv	s7,s1
      state = 0;
 7e0:	4981                	li	s3,0
        i += 1;
 7e2:	b555                	j	686 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e4:	008b8493          	addi	s1,s7,8
 7e8:	4681                	li	a3,0
 7ea:	4629                	li	a2,10
 7ec:	000bb583          	ld	a1,0(s7)
 7f0:	855a                	mv	a0,s6
 7f2:	db9ff0ef          	jal	5aa <printint>
        i += 2;
 7f6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f8:	8ba6                	mv	s7,s1
      state = 0;
 7fa:	4981                	li	s3,0
        i += 2;
 7fc:	b569                	j	686 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7fe:	008b8493          	addi	s1,s7,8
 802:	4681                	li	a3,0
 804:	4641                	li	a2,16
 806:	000be583          	lwu	a1,0(s7)
 80a:	855a                	mv	a0,s6
 80c:	d9fff0ef          	jal	5aa <printint>
 810:	8ba6                	mv	s7,s1
      state = 0;
 812:	4981                	li	s3,0
 814:	bd8d                	j	686 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 816:	008b8493          	addi	s1,s7,8
 81a:	4681                	li	a3,0
 81c:	4641                	li	a2,16
 81e:	000bb583          	ld	a1,0(s7)
 822:	855a                	mv	a0,s6
 824:	d87ff0ef          	jal	5aa <printint>
        i += 1;
 828:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 82a:	8ba6                	mv	s7,s1
      state = 0;
 82c:	4981                	li	s3,0
        i += 1;
 82e:	bda1                	j	686 <vprintf+0x4a>
 830:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 832:	008b8d13          	addi	s10,s7,8
 836:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 83a:	03000593          	li	a1,48
 83e:	855a                	mv	a0,s6
 840:	d4dff0ef          	jal	58c <putc>
  putc(fd, 'x');
 844:	07800593          	li	a1,120
 848:	855a                	mv	a0,s6
 84a:	d43ff0ef          	jal	58c <putc>
 84e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 850:	00000b97          	auipc	s7,0x0
 854:	2e0b8b93          	addi	s7,s7,736 # b30 <digits>
 858:	03c9d793          	srli	a5,s3,0x3c
 85c:	97de                	add	a5,a5,s7
 85e:	0007c583          	lbu	a1,0(a5)
 862:	855a                	mv	a0,s6
 864:	d29ff0ef          	jal	58c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 868:	0992                	slli	s3,s3,0x4
 86a:	34fd                	addiw	s1,s1,-1
 86c:	f4f5                	bnez	s1,858 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 86e:	8bea                	mv	s7,s10
      state = 0;
 870:	4981                	li	s3,0
 872:	6d02                	ld	s10,0(sp)
 874:	bd09                	j	686 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 876:	008b8493          	addi	s1,s7,8
 87a:	000bc583          	lbu	a1,0(s7)
 87e:	855a                	mv	a0,s6
 880:	d0dff0ef          	jal	58c <putc>
 884:	8ba6                	mv	s7,s1
      state = 0;
 886:	4981                	li	s3,0
 888:	bbfd                	j	686 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 88a:	008b8993          	addi	s3,s7,8
 88e:	000bb483          	ld	s1,0(s7)
 892:	cc91                	beqz	s1,8ae <vprintf+0x272>
        for(; *s; s++)
 894:	0004c583          	lbu	a1,0(s1)
 898:	c195                	beqz	a1,8bc <vprintf+0x280>
          putc(fd, *s);
 89a:	855a                	mv	a0,s6
 89c:	cf1ff0ef          	jal	58c <putc>
        for(; *s; s++)
 8a0:	0485                	addi	s1,s1,1
 8a2:	0004c583          	lbu	a1,0(s1)
 8a6:	f9f5                	bnez	a1,89a <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 8a8:	8bce                	mv	s7,s3
      state = 0;
 8aa:	4981                	li	s3,0
 8ac:	bbe9                	j	686 <vprintf+0x4a>
          s = "(null)";
 8ae:	00000497          	auipc	s1,0x0
 8b2:	27a48493          	addi	s1,s1,634 # b28 <malloc+0x16a>
        for(; *s; s++)
 8b6:	02800593          	li	a1,40
 8ba:	b7c5                	j	89a <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 8bc:	8bce                	mv	s7,s3
      state = 0;
 8be:	4981                	li	s3,0
 8c0:	b3d9                	j	686 <vprintf+0x4a>
 8c2:	6906                	ld	s2,64(sp)
 8c4:	79e2                	ld	s3,56(sp)
 8c6:	7a42                	ld	s4,48(sp)
 8c8:	7aa2                	ld	s5,40(sp)
 8ca:	7b02                	ld	s6,32(sp)
 8cc:	6be2                	ld	s7,24(sp)
 8ce:	6c42                	ld	s8,16(sp)
 8d0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8d2:	60e6                	ld	ra,88(sp)
 8d4:	6446                	ld	s0,80(sp)
 8d6:	64a6                	ld	s1,72(sp)
 8d8:	6125                	addi	sp,sp,96
 8da:	8082                	ret

00000000000008dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8dc:	715d                	addi	sp,sp,-80
 8de:	ec06                	sd	ra,24(sp)
 8e0:	e822                	sd	s0,16(sp)
 8e2:	1000                	addi	s0,sp,32
 8e4:	e010                	sd	a2,0(s0)
 8e6:	e414                	sd	a3,8(s0)
 8e8:	e818                	sd	a4,16(s0)
 8ea:	ec1c                	sd	a5,24(s0)
 8ec:	03043023          	sd	a6,32(s0)
 8f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8f4:	8622                	mv	a2,s0
 8f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8fa:	d43ff0ef          	jal	63c <vprintf>
}
 8fe:	60e2                	ld	ra,24(sp)
 900:	6442                	ld	s0,16(sp)
 902:	6161                	addi	sp,sp,80
 904:	8082                	ret

0000000000000906 <printf>:

void
printf(const char *fmt, ...)
{
 906:	711d                	addi	sp,sp,-96
 908:	ec06                	sd	ra,24(sp)
 90a:	e822                	sd	s0,16(sp)
 90c:	1000                	addi	s0,sp,32
 90e:	e40c                	sd	a1,8(s0)
 910:	e810                	sd	a2,16(s0)
 912:	ec14                	sd	a3,24(s0)
 914:	f018                	sd	a4,32(s0)
 916:	f41c                	sd	a5,40(s0)
 918:	03043823          	sd	a6,48(s0)
 91c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 920:	00840613          	addi	a2,s0,8
 924:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 928:	85aa                	mv	a1,a0
 92a:	4505                	li	a0,1
 92c:	d11ff0ef          	jal	63c <vprintf>
}
 930:	60e2                	ld	ra,24(sp)
 932:	6442                	ld	s0,16(sp)
 934:	6125                	addi	sp,sp,96
 936:	8082                	ret

0000000000000938 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 938:	1141                	addi	sp,sp,-16
 93a:	e406                	sd	ra,8(sp)
 93c:	e022                	sd	s0,0(sp)
 93e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 940:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 944:	00000797          	auipc	a5,0x0
 948:	6bc7b783          	ld	a5,1724(a5) # 1000 <freep>
 94c:	a02d                	j	976 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 94e:	4618                	lw	a4,8(a2)
 950:	9f2d                	addw	a4,a4,a1
 952:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 956:	6398                	ld	a4,0(a5)
 958:	6310                	ld	a2,0(a4)
 95a:	a83d                	j	998 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 95c:	ff852703          	lw	a4,-8(a0)
 960:	9f31                	addw	a4,a4,a2
 962:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 964:	ff053683          	ld	a3,-16(a0)
 968:	a091                	j	9ac <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 96a:	6398                	ld	a4,0(a5)
 96c:	00e7e463          	bltu	a5,a4,974 <free+0x3c>
 970:	00e6ea63          	bltu	a3,a4,984 <free+0x4c>
{
 974:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 976:	fed7fae3          	bgeu	a5,a3,96a <free+0x32>
 97a:	6398                	ld	a4,0(a5)
 97c:	00e6e463          	bltu	a3,a4,984 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 980:	fee7eae3          	bltu	a5,a4,974 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 984:	ff852583          	lw	a1,-8(a0)
 988:	6390                	ld	a2,0(a5)
 98a:	02059813          	slli	a6,a1,0x20
 98e:	01c85713          	srli	a4,a6,0x1c
 992:	9736                	add	a4,a4,a3
 994:	fae60de3          	beq	a2,a4,94e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 998:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 99c:	4790                	lw	a2,8(a5)
 99e:	02061593          	slli	a1,a2,0x20
 9a2:	01c5d713          	srli	a4,a1,0x1c
 9a6:	973e                	add	a4,a4,a5
 9a8:	fae68ae3          	beq	a3,a4,95c <free+0x24>
    p->s.ptr = bp->s.ptr;
 9ac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9ae:	00000717          	auipc	a4,0x0
 9b2:	64f73923          	sd	a5,1618(a4) # 1000 <freep>
}
 9b6:	60a2                	ld	ra,8(sp)
 9b8:	6402                	ld	s0,0(sp)
 9ba:	0141                	addi	sp,sp,16
 9bc:	8082                	ret

00000000000009be <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9be:	7139                	addi	sp,sp,-64
 9c0:	fc06                	sd	ra,56(sp)
 9c2:	f822                	sd	s0,48(sp)
 9c4:	f04a                	sd	s2,32(sp)
 9c6:	ec4e                	sd	s3,24(sp)
 9c8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ca:	02051993          	slli	s3,a0,0x20
 9ce:	0209d993          	srli	s3,s3,0x20
 9d2:	09bd                	addi	s3,s3,15
 9d4:	0049d993          	srli	s3,s3,0x4
 9d8:	2985                	addiw	s3,s3,1
 9da:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9dc:	00000517          	auipc	a0,0x0
 9e0:	62453503          	ld	a0,1572(a0) # 1000 <freep>
 9e4:	c905                	beqz	a0,a14 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e8:	4798                	lw	a4,8(a5)
 9ea:	09377663          	bgeu	a4,s3,a76 <malloc+0xb8>
 9ee:	f426                	sd	s1,40(sp)
 9f0:	e852                	sd	s4,16(sp)
 9f2:	e456                	sd	s5,8(sp)
 9f4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9f6:	8a4e                	mv	s4,s3
 9f8:	6705                	lui	a4,0x1
 9fa:	00e9f363          	bgeu	s3,a4,a00 <malloc+0x42>
 9fe:	6a05                	lui	s4,0x1
 a00:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a04:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a08:	00000497          	auipc	s1,0x0
 a0c:	5f848493          	addi	s1,s1,1528 # 1000 <freep>
  if(p == SBRK_ERROR)
 a10:	5afd                	li	s5,-1
 a12:	a83d                	j	a50 <malloc+0x92>
 a14:	f426                	sd	s1,40(sp)
 a16:	e852                	sd	s4,16(sp)
 a18:	e456                	sd	s5,8(sp)
 a1a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a1c:	00000797          	auipc	a5,0x0
 a20:	7ec78793          	addi	a5,a5,2028 # 1208 <base>
 a24:	00000717          	auipc	a4,0x0
 a28:	5cf73e23          	sd	a5,1500(a4) # 1000 <freep>
 a2c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a2e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a32:	b7d1                	j	9f6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a34:	6398                	ld	a4,0(a5)
 a36:	e118                	sd	a4,0(a0)
 a38:	a899                	j	a8e <malloc+0xd0>
  hp->s.size = nu;
 a3a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a3e:	0541                	addi	a0,a0,16
 a40:	ef9ff0ef          	jal	938 <free>
  return freep;
 a44:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a46:	c125                	beqz	a0,aa6 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a48:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a4a:	4798                	lw	a4,8(a5)
 a4c:	03277163          	bgeu	a4,s2,a6e <malloc+0xb0>
    if(p == freep)
 a50:	6098                	ld	a4,0(s1)
 a52:	853e                	mv	a0,a5
 a54:	fef71ae3          	bne	a4,a5,a48 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a58:	8552                	mv	a0,s4
 a5a:	8c7ff0ef          	jal	320 <sbrk>
  if(p == SBRK_ERROR)
 a5e:	fd551ee3          	bne	a0,s5,a3a <malloc+0x7c>
        return 0;
 a62:	4501                	li	a0,0
 a64:	74a2                	ld	s1,40(sp)
 a66:	6a42                	ld	s4,16(sp)
 a68:	6aa2                	ld	s5,8(sp)
 a6a:	6b02                	ld	s6,0(sp)
 a6c:	a03d                	j	a9a <malloc+0xdc>
 a6e:	74a2                	ld	s1,40(sp)
 a70:	6a42                	ld	s4,16(sp)
 a72:	6aa2                	ld	s5,8(sp)
 a74:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a76:	fae90fe3          	beq	s2,a4,a34 <malloc+0x76>
        p->s.size -= nunits;
 a7a:	4137073b          	subw	a4,a4,s3
 a7e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a80:	02071693          	slli	a3,a4,0x20
 a84:	01c6d713          	srli	a4,a3,0x1c
 a88:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a8a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a8e:	00000717          	auipc	a4,0x0
 a92:	56a73923          	sd	a0,1394(a4) # 1000 <freep>
      return (void*)(p + 1);
 a96:	01078513          	addi	a0,a5,16
  }
}
 a9a:	70e2                	ld	ra,56(sp)
 a9c:	7442                	ld	s0,48(sp)
 a9e:	7902                	ld	s2,32(sp)
 aa0:	69e2                	ld	s3,24(sp)
 aa2:	6121                	addi	sp,sp,64
 aa4:	8082                	ret
 aa6:	74a2                	ld	s1,40(sp)
 aa8:	6a42                	ld	s4,16(sp)
 aaa:	6aa2                	ld	s5,8(sp)
 aac:	6b02                	ld	s6,0(sp)
 aae:	b7f5                	j	a9a <malloc+0xdc>
