
user/_forphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
  int fd = 0;
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)
  struct stat st;
  char *ff = "file0";
  
  if ((fd = open(ff, O_CREATE|O_WRONLY)) < 0) {
   c:	20100593          	li	a1,513
  10:	00001517          	auipc	a0,0x1
  14:	ae050513          	addi	a0,a0,-1312 # af0 <malloc+0xf8>
  18:	52e000ef          	jal	546 <open>
  1c:	04054463          	bltz	a0,64 <main+0x64>
    printf("%s: open failed\n", s);
    exit(1);
  }
  if(fstat(fd, &st) < 0){
  20:	fc840593          	addi	a1,s0,-56
  24:	53a000ef          	jal	55e <fstat>
  28:	04054863          	bltz	a0,78 <main+0x78>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
    exit(1);
  }
  if (unlink(ff) < 0) {
  2c:	00001517          	auipc	a0,0x1
  30:	ac450513          	addi	a0,a0,-1340 # af0 <malloc+0xf8>
  34:	522000ef          	jal	556 <unlink>
  38:	04054f63          	bltz	a0,96 <main+0x96>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  if (open(ff, O_RDONLY) != -1) {
  3c:	4581                	li	a1,0
  3e:	00001517          	auipc	a0,0x1
  42:	ab250513          	addi	a0,a0,-1358 # af0 <malloc+0xf8>
  46:	500000ef          	jal	546 <open>
  4a:	57fd                	li	a5,-1
  4c:	04f50f63          	beq	a0,a5,aa <main+0xaa>
    printf("%s: open successed\n", s);
  50:	85a6                	mv	a1,s1
  52:	00001517          	auipc	a0,0x1
  56:	afe50513          	addi	a0,a0,-1282 # b50 <malloc+0x158>
  5a:	0e7000ef          	jal	940 <printf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	4a6000ef          	jal	506 <exit>
    printf("%s: open failed\n", s);
  64:	85a6                	mv	a1,s1
  66:	00001517          	auipc	a0,0x1
  6a:	a9a50513          	addi	a0,a0,-1382 # b00 <malloc+0x108>
  6e:	0d3000ef          	jal	940 <printf>
    exit(1);
  72:	4505                	li	a0,1
  74:	492000ef          	jal	506 <exit>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
  78:	00001697          	auipc	a3,0x1
  7c:	aa068693          	addi	a3,a3,-1376 # b18 <malloc+0x120>
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	a9e58593          	addi	a1,a1,-1378 # b20 <malloc+0x128>
  8a:	4509                	li	a0,2
  8c:	08b000ef          	jal	916 <fprintf>
    exit(1);
  90:	4505                	li	a0,1
  92:	474000ef          	jal	506 <exit>
    printf("%s: unlink failed\n", s);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	aa050513          	addi	a0,a0,-1376 # b38 <malloc+0x140>
  a0:	0a1000ef          	jal	940 <printf>
    exit(1);
  a4:	4505                	li	a0,1
  a6:	460000ef          	jal	506 <exit>
  }
  printf("wait for kill and reclaim %d\n", st.ino);
  aa:	fcc42583          	lw	a1,-52(s0)
  ae:	00001517          	auipc	a0,0x1
  b2:	aba50513          	addi	a0,a0,-1350 # b68 <malloc+0x170>
  b6:	08b000ef          	jal	940 <printf>
  // sit around until killed
  for(;;) pause(1000);
  ba:	3e800493          	li	s1,1000
  be:	8526                	mv	a0,s1
  c0:	4d6000ef          	jal	596 <pause>
  c4:	bfed                	j	be <main+0xbe>

00000000000000c6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  ce:	f33ff0ef          	jal	0 <main>
  exit(r);
  d2:	434000ef          	jal	506 <exit>

00000000000000d6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e406                	sd	ra,8(sp)
  da:	e022                	sd	s0,0(sp)
  dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  de:	87aa                	mv	a5,a0
  e0:	0585                	addi	a1,a1,1
  e2:	0785                	addi	a5,a5,1
  e4:	fff5c703          	lbu	a4,-1(a1)
  e8:	fee78fa3          	sb	a4,-1(a5)
  ec:	fb75                	bnez	a4,e0 <strcpy+0xa>
    ;
  return os;
}
  ee:	60a2                	ld	ra,8(sp)
  f0:	6402                	ld	s0,0(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  fe:	00054783          	lbu	a5,0(a0)
 102:	cb91                	beqz	a5,116 <strcmp+0x20>
 104:	0005c703          	lbu	a4,0(a1)
 108:	00f71763          	bne	a4,a5,116 <strcmp+0x20>
    p++, q++;
 10c:	0505                	addi	a0,a0,1
 10e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 110:	00054783          	lbu	a5,0(a0)
 114:	fbe5                	bnez	a5,104 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 116:	0005c503          	lbu	a0,0(a1)
}
 11a:	40a7853b          	subw	a0,a5,a0
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strlen>:

uint
strlen(const char *s)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cf99                	beqz	a5,150 <strlen+0x2a>
 134:	0505                	addi	a0,a0,1
 136:	87aa                	mv	a5,a0
 138:	86be                	mv	a3,a5
 13a:	0785                	addi	a5,a5,1
 13c:	fff7c703          	lbu	a4,-1(a5)
 140:	ff65                	bnez	a4,138 <strlen+0x12>
 142:	40a6853b          	subw	a0,a3,a0
 146:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 148:	60a2                	ld	ra,8(sp)
 14a:	6402                	ld	s0,0(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret
  for(n = 0; s[n]; n++)
 150:	4501                	li	a0,0
 152:	bfdd                	j	148 <strlen+0x22>

0000000000000154 <memset>:

void*
memset(void *dst, int c, uint n)
{
 154:	1141                	addi	sp,sp,-16
 156:	e406                	sd	ra,8(sp)
 158:	e022                	sd	s0,0(sp)
 15a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 15c:	ca19                	beqz	a2,172 <memset+0x1e>
 15e:	87aa                	mv	a5,a0
 160:	1602                	slli	a2,a2,0x20
 162:	9201                	srli	a2,a2,0x20
 164:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 168:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 16c:	0785                	addi	a5,a5,1
 16e:	fee79de3          	bne	a5,a4,168 <memset+0x14>
  }
  return dst;
}
 172:	60a2                	ld	ra,8(sp)
 174:	6402                	ld	s0,0(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret

000000000000017a <strchr>:

char*
strchr(const char *s, char c)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e406                	sd	ra,8(sp)
 17e:	e022                	sd	s0,0(sp)
 180:	0800                	addi	s0,sp,16
  for(; *s; s++)
 182:	00054783          	lbu	a5,0(a0)
 186:	cf81                	beqz	a5,19e <strchr+0x24>
    if(*s == c)
 188:	00f58763          	beq	a1,a5,196 <strchr+0x1c>
  for(; *s; s++)
 18c:	0505                	addi	a0,a0,1
 18e:	00054783          	lbu	a5,0(a0)
 192:	fbfd                	bnez	a5,188 <strchr+0xe>
      return (char*)s;
  return 0;
 194:	4501                	li	a0,0
}
 196:	60a2                	ld	ra,8(sp)
 198:	6402                	ld	s0,0(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret
  return 0;
 19e:	4501                	li	a0,0
 1a0:	bfdd                	j	196 <strchr+0x1c>

00000000000001a2 <gets>:

char*
gets(char *buf, int max)
{
 1a2:	7159                	addi	sp,sp,-112
 1a4:	f486                	sd	ra,104(sp)
 1a6:	f0a2                	sd	s0,96(sp)
 1a8:	eca6                	sd	s1,88(sp)
 1aa:	e8ca                	sd	s2,80(sp)
 1ac:	e4ce                	sd	s3,72(sp)
 1ae:	e0d2                	sd	s4,64(sp)
 1b0:	fc56                	sd	s5,56(sp)
 1b2:	f85a                	sd	s6,48(sp)
 1b4:	f45e                	sd	s7,40(sp)
 1b6:	f062                	sd	s8,32(sp)
 1b8:	ec66                	sd	s9,24(sp)
 1ba:	e86a                	sd	s10,16(sp)
 1bc:	1880                	addi	s0,sp,112
 1be:	8caa                	mv	s9,a0
 1c0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c2:	892a                	mv	s2,a0
 1c4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1c6:	f9f40b13          	addi	s6,s0,-97
 1ca:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1cc:	4ba9                	li	s7,10
 1ce:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1d0:	8d26                	mv	s10,s1
 1d2:	0014899b          	addiw	s3,s1,1
 1d6:	84ce                	mv	s1,s3
 1d8:	0349d563          	bge	s3,s4,202 <gets+0x60>
    cc = read(0, &c, 1);
 1dc:	8656                	mv	a2,s5
 1de:	85da                	mv	a1,s6
 1e0:	4501                	li	a0,0
 1e2:	33c000ef          	jal	51e <read>
    if(cc < 1)
 1e6:	00a05e63          	blez	a0,202 <gets+0x60>
    buf[i++] = c;
 1ea:	f9f44783          	lbu	a5,-97(s0)
 1ee:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f2:	01778763          	beq	a5,s7,200 <gets+0x5e>
 1f6:	0905                	addi	s2,s2,1
 1f8:	fd879ce3          	bne	a5,s8,1d0 <gets+0x2e>
    buf[i++] = c;
 1fc:	8d4e                	mv	s10,s3
 1fe:	a011                	j	202 <gets+0x60>
 200:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 202:	9d66                	add	s10,s10,s9
 204:	000d0023          	sb	zero,0(s10)
  return buf;
}
 208:	8566                	mv	a0,s9
 20a:	70a6                	ld	ra,104(sp)
 20c:	7406                	ld	s0,96(sp)
 20e:	64e6                	ld	s1,88(sp)
 210:	6946                	ld	s2,80(sp)
 212:	69a6                	ld	s3,72(sp)
 214:	6a06                	ld	s4,64(sp)
 216:	7ae2                	ld	s5,56(sp)
 218:	7b42                	ld	s6,48(sp)
 21a:	7ba2                	ld	s7,40(sp)
 21c:	7c02                	ld	s8,32(sp)
 21e:	6ce2                	ld	s9,24(sp)
 220:	6d42                	ld	s10,16(sp)
 222:	6165                	addi	sp,sp,112
 224:	8082                	ret

0000000000000226 <stat>:

int
stat(const char *n, struct stat *st)
{
 226:	1101                	addi	sp,sp,-32
 228:	ec06                	sd	ra,24(sp)
 22a:	e822                	sd	s0,16(sp)
 22c:	e04a                	sd	s2,0(sp)
 22e:	1000                	addi	s0,sp,32
 230:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 232:	4581                	li	a1,0
 234:	312000ef          	jal	546 <open>
  if(fd < 0)
 238:	02054263          	bltz	a0,25c <stat+0x36>
 23c:	e426                	sd	s1,8(sp)
 23e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 240:	85ca                	mv	a1,s2
 242:	31c000ef          	jal	55e <fstat>
 246:	892a                	mv	s2,a0
  close(fd);
 248:	8526                	mv	a0,s1
 24a:	2e4000ef          	jal	52e <close>
  return r;
 24e:	64a2                	ld	s1,8(sp)
}
 250:	854a                	mv	a0,s2
 252:	60e2                	ld	ra,24(sp)
 254:	6442                	ld	s0,16(sp)
 256:	6902                	ld	s2,0(sp)
 258:	6105                	addi	sp,sp,32
 25a:	8082                	ret
    return -1;
 25c:	597d                	li	s2,-1
 25e:	bfcd                	j	250 <stat+0x2a>

0000000000000260 <atoi>:

int
atoi(const char *s)
{
 260:	1141                	addi	sp,sp,-16
 262:	e406                	sd	ra,8(sp)
 264:	e022                	sd	s0,0(sp)
 266:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 268:	00054683          	lbu	a3,0(a0)
 26c:	fd06879b          	addiw	a5,a3,-48
 270:	0ff7f793          	zext.b	a5,a5
 274:	4625                	li	a2,9
 276:	02f66963          	bltu	a2,a5,2a8 <atoi+0x48>
 27a:	872a                	mv	a4,a0
  n = 0;
 27c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 27e:	0705                	addi	a4,a4,1
 280:	0025179b          	slliw	a5,a0,0x2
 284:	9fa9                	addw	a5,a5,a0
 286:	0017979b          	slliw	a5,a5,0x1
 28a:	9fb5                	addw	a5,a5,a3
 28c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 290:	00074683          	lbu	a3,0(a4)
 294:	fd06879b          	addiw	a5,a3,-48
 298:	0ff7f793          	zext.b	a5,a5
 29c:	fef671e3          	bgeu	a2,a5,27e <atoi+0x1e>
  return n;
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret
  n = 0;
 2a8:	4501                	li	a0,0
 2aa:	bfdd                	j	2a0 <atoi+0x40>

00000000000002ac <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e406                	sd	ra,8(sp)
 2b0:	e022                	sd	s0,0(sp)
 2b2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b4:	02b57563          	bgeu	a0,a1,2de <memmove+0x32>
    while(n-- > 0)
 2b8:	00c05f63          	blez	a2,2d6 <memmove+0x2a>
 2bc:	1602                	slli	a2,a2,0x20
 2be:	9201                	srli	a2,a2,0x20
 2c0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c6:	0585                	addi	a1,a1,1
 2c8:	0705                	addi	a4,a4,1
 2ca:	fff5c683          	lbu	a3,-1(a1)
 2ce:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d2:	fee79ae3          	bne	a5,a4,2c6 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret
    dst += n;
 2de:	00c50733          	add	a4,a0,a2
    src += n;
 2e2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e4:	fec059e3          	blez	a2,2d6 <memmove+0x2a>
 2e8:	fff6079b          	addiw	a5,a2,-1
 2ec:	1782                	slli	a5,a5,0x20
 2ee:	9381                	srli	a5,a5,0x20
 2f0:	fff7c793          	not	a5,a5
 2f4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f6:	15fd                	addi	a1,a1,-1
 2f8:	177d                	addi	a4,a4,-1
 2fa:	0005c683          	lbu	a3,0(a1)
 2fe:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 302:	fef71ae3          	bne	a4,a5,2f6 <memmove+0x4a>
 306:	bfc1                	j	2d6 <memmove+0x2a>

0000000000000308 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e406                	sd	ra,8(sp)
 30c:	e022                	sd	s0,0(sp)
 30e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 310:	ca0d                	beqz	a2,342 <memcmp+0x3a>
 312:	fff6069b          	addiw	a3,a2,-1
 316:	1682                	slli	a3,a3,0x20
 318:	9281                	srli	a3,a3,0x20
 31a:	0685                	addi	a3,a3,1
 31c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 31e:	00054783          	lbu	a5,0(a0)
 322:	0005c703          	lbu	a4,0(a1)
 326:	00e79863          	bne	a5,a4,336 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 32a:	0505                	addi	a0,a0,1
    p2++;
 32c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32e:	fed518e3          	bne	a0,a3,31e <memcmp+0x16>
  }
  return 0;
 332:	4501                	li	a0,0
 334:	a019                	j	33a <memcmp+0x32>
      return *p1 - *p2;
 336:	40e7853b          	subw	a0,a5,a4
}
 33a:	60a2                	ld	ra,8(sp)
 33c:	6402                	ld	s0,0(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  return 0;
 342:	4501                	li	a0,0
 344:	bfdd                	j	33a <memcmp+0x32>

0000000000000346 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e406                	sd	ra,8(sp)
 34a:	e022                	sd	s0,0(sp)
 34c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34e:	f5fff0ef          	jal	2ac <memmove>
}
 352:	60a2                	ld	ra,8(sp)
 354:	6402                	ld	s0,0(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret

000000000000035a <sbrk>:

char *
sbrk(int n) {
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 362:	4585                	li	a1,1
 364:	22a000ef          	jal	58e <sys_sbrk>
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret

0000000000000370 <sbrklazy>:

char *
sbrklazy(int n) {
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 378:	4589                	li	a1,2
 37a:	214000ef          	jal	58e <sys_sbrk>
}
 37e:	60a2                	ld	ra,8(sp)
 380:	6402                	ld	s0,0(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret

0000000000000386 <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 386:	1101                	addi	sp,sp,-32
 388:	ec06                	sd	ra,24(sp)
 38a:	e822                	sd	s0,16(sp)
 38c:	e426                	sd	s1,8(sp)
 38e:	e04a                	sd	s2,0(sp)
 390:	1000                	addi	s0,sp,32
 392:	84aa                	mv	s1,a0
 394:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 396:	6505                	lui	a0,0x1
 398:	fc3ff0ef          	jal	35a <sbrk>
 39c:	6785                	lui	a5,0x1
 39e:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 3a2:	9a41                	andi	a2,a2,-16
 3a4:	85ca                	mv	a1,s2
 3a6:	8526                	mv	a0,s1
 3a8:	1fe000ef          	jal	5a6 <clone>
}
 3ac:	60e2                	ld	ra,24(sp)
 3ae:	6442                	ld	s0,16(sp)
 3b0:	64a2                	ld	s1,8(sp)
 3b2:	6902                	ld	s2,0(sp)
 3b4:	6105                	addi	sp,sp,32
 3b6:	8082                	ret

00000000000003b8 <futex>:

void futex(int *uaddr, int ops, int val) {
 3b8:	7179                	addi	sp,sp,-48
 3ba:	f406                	sd	ra,40(sp)
 3bc:	f022                	sd	s0,32(sp)
 3be:	ec26                	sd	s1,24(sp)
 3c0:	1800                	addi	s0,sp,48
 3c2:	84aa                	mv	s1,a0
  if (ops==0) {
 3c4:	ed95                	bnez	a1,400 <futex+0x48>
    if (val==0) {
 3c6:	c611                	beqz	a2,3d2 <futex+0x1a>
 3c8:	e84a                	sd	s2,16(sp)
 3ca:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 3cc:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 3ce:	4985                	li	s3,1
 3d0:	a005                	j	3f0 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 3d2:	4705                	li	a4,1
 3d4:	87ba                	mv	a5,a4
 3d6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 3da:	2781                	sext.w	a5,a5
 3dc:	ffe5                	bnez	a5,3d4 <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 3de:	70a2                	ld	ra,40(sp)
 3e0:	7402                	ld	s0,32(sp)
 3e2:	64e2                	ld	s1,24(sp)
 3e4:	6145                	addi	sp,sp,48
 3e6:	8082                	ret
        futex_wait(uaddr, 1);
 3e8:	85ce                	mv	a1,s3
 3ea:	8526                	mv	a0,s1
 3ec:	1ca000ef          	jal	5b6 <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 3f0:	87ca                	mv	a5,s2
 3f2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 3f6:	2781                	sext.w	a5,a5
 3f8:	fbe5                	bnez	a5,3e8 <futex+0x30>
 3fa:	6942                	ld	s2,16(sp)
 3fc:	69a2                	ld	s3,8(sp)
 3fe:	b7c5                	j	3de <futex+0x26>
    if (val==0) {
 400:	e611                	bnez	a2,40c <futex+0x54>
      __sync_lock_release(uaddr);
 402:	0310000f          	fence	rw,w
 406:	00052023          	sw	zero,0(a0) # 1000 <freep>
 40a:	bfd1                	j	3de <futex+0x26>
      __sync_lock_release(uaddr);
 40c:	0310000f          	fence	rw,w
 410:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 414:	1aa000ef          	jal	5be <futex_wake>
  return;
 418:	b7d9                	j	3de <futex+0x26>

000000000000041a <sem_init>:

void sem_init(sem_t* s, int val) {
 41a:	7179                	addi	sp,sp,-48
 41c:	f406                	sd	ra,40(sp)
 41e:	f022                	sd	s0,32(sp)
 420:	ec26                	sd	s1,24(sp)
 422:	e84a                	sd	s2,16(sp)
 424:	e44e                	sd	s3,8(sp)
 426:	1800                	addi	s0,sp,48
 428:	84aa                	mv	s1,a0
 42a:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 42c:	00450993          	addi	s3,a0,4
 430:	4605                	li	a2,1
 432:	4581                	li	a1,0
 434:	854e                	mv	a0,s3
 436:	f83ff0ef          	jal	3b8 <futex>
  s->value = val;
 43a:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 43e:	4605                	li	a2,1
 440:	85b2                	mv	a1,a2
 442:	854e                	mv	a0,s3
 444:	f75ff0ef          	jal	3b8 <futex>
  return;
}
 448:	70a2                	ld	ra,40(sp)
 44a:	7402                	ld	s0,32(sp)
 44c:	64e2                	ld	s1,24(sp)
 44e:	6942                	ld	s2,16(sp)
 450:	69a2                	ld	s3,8(sp)
 452:	6145                	addi	sp,sp,48
 454:	8082                	ret

0000000000000456 <sem_down>:

void sem_down(sem_t* s) {
 456:	7179                	addi	sp,sp,-48
 458:	f406                	sd	ra,40(sp)
 45a:	f022                	sd	s0,32(sp)
 45c:	ec26                	sd	s1,24(sp)
 45e:	e84a                	sd	s2,16(sp)
 460:	e44e                	sd	s3,8(sp)
 462:	1800                	addi	s0,sp,48
 464:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 466:	00450993          	addi	s3,a0,4
 46a:	4605                	li	a2,1
 46c:	4581                	li	a1,0
 46e:	854e                	mv	a0,s3
 470:	f49ff0ef          	jal	3b8 <futex>
  while(1) {
    if (s->value>0) {
 474:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 478:	4485                	li	s1,1
    if (s->value>0) {
 47a:	02f04463          	bgtz	a5,4a2 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 47e:	8626                	mv	a2,s1
 480:	85a6                	mv	a1,s1
 482:	854e                	mv	a0,s3
 484:	f35ff0ef          	jal	3b8 <futex>
      futex_wait(&s->value,1);
 488:	85a6                	mv	a1,s1
 48a:	854a                	mv	a0,s2
 48c:	12a000ef          	jal	5b6 <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 490:	8626                	mv	a2,s1
 492:	4581                	li	a1,0
 494:	854e                	mv	a0,s3
 496:	f23ff0ef          	jal	3b8 <futex>
    if (s->value>0) {
 49a:	00092783          	lw	a5,0(s2)
 49e:	fef050e3          	blez	a5,47e <sem_down+0x28>
      s->value--;
 4a2:	37fd                	addiw	a5,a5,-1 # fff <digits+0x46f>
 4a4:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4a8:	4605                	li	a2,1
 4aa:	85b2                	mv	a1,a2
 4ac:	854e                	mv	a0,s3
 4ae:	f0bff0ef          	jal	3b8 <futex>
  return;
}
 4b2:	70a2                	ld	ra,40(sp)
 4b4:	7402                	ld	s0,32(sp)
 4b6:	64e2                	ld	s1,24(sp)
 4b8:	6942                	ld	s2,16(sp)
 4ba:	69a2                	ld	s3,8(sp)
 4bc:	6145                	addi	sp,sp,48
 4be:	8082                	ret

00000000000004c0 <sem_up>:

void sem_up(sem_t* s) {
 4c0:	1101                	addi	sp,sp,-32
 4c2:	ec06                	sd	ra,24(sp)
 4c4:	e822                	sd	s0,16(sp)
 4c6:	e426                	sd	s1,8(sp)
 4c8:	e04a                	sd	s2,0(sp)
 4ca:	1000                	addi	s0,sp,32
 4cc:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 4ce:	00450913          	addi	s2,a0,4
 4d2:	4605                	li	a2,1
 4d4:	4581                	li	a1,0
 4d6:	854a                	mv	a0,s2
 4d8:	ee1ff0ef          	jal	3b8 <futex>
  s->value++;
 4dc:	409c                	lw	a5,0(s1)
 4de:	2785                	addiw	a5,a5,1
 4e0:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 4e2:	8526                	mv	a0,s1
 4e4:	0da000ef          	jal	5be <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4e8:	4605                	li	a2,1
 4ea:	85b2                	mv	a1,a2
 4ec:	854a                	mv	a0,s2
 4ee:	ecbff0ef          	jal	3b8 <futex>
  return;
 4f2:	60e2                	ld	ra,24(sp)
 4f4:	6442                	ld	s0,16(sp)
 4f6:	64a2                	ld	s1,8(sp)
 4f8:	6902                	ld	s2,0(sp)
 4fa:	6105                	addi	sp,sp,32
 4fc:	8082                	ret

00000000000004fe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4fe:	4885                	li	a7,1
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <exit>:
.global exit
exit:
 li a7, SYS_exit
 506:	4889                	li	a7,2
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <wait>:
.global wait
wait:
 li a7, SYS_wait
 50e:	488d                	li	a7,3
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 516:	4891                	li	a7,4
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <read>:
.global read
read:
 li a7, SYS_read
 51e:	4895                	li	a7,5
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <write>:
.global write
write:
 li a7, SYS_write
 526:	48c1                	li	a7,16
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <close>:
.global close
close:
 li a7, SYS_close
 52e:	48d5                	li	a7,21
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <kill>:
.global kill
kill:
 li a7, SYS_kill
 536:	4899                	li	a7,6
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <exec>:
.global exec
exec:
 li a7, SYS_exec
 53e:	489d                	li	a7,7
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <open>:
.global open
open:
 li a7, SYS_open
 546:	48bd                	li	a7,15
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 54e:	48c5                	li	a7,17
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 556:	48c9                	li	a7,18
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 55e:	48a1                	li	a7,8
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <link>:
.global link
link:
 li a7, SYS_link
 566:	48cd                	li	a7,19
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 56e:	48d1                	li	a7,20
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 576:	48a5                	li	a7,9
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <dup>:
.global dup
dup:
 li a7, SYS_dup
 57e:	48a9                	li	a7,10
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 586:	48ad                	li	a7,11
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 58e:	48b1                	li	a7,12
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <pause>:
.global pause
pause:
 li a7, SYS_pause
 596:	48b5                	li	a7,13
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 59e:	48b9                	li	a7,14
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <clone>:
.global clone
clone:
 li a7, SYS_clone
 5a6:	48d9                	li	a7,22
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <join>:
.global join
join:
 li a7, SYS_join
 5ae:	48dd                	li	a7,23
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 5b6:	48e1                	li	a7,24
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 5be:	48e5                	li	a7,25
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c6:	1101                	addi	sp,sp,-32
 5c8:	ec06                	sd	ra,24(sp)
 5ca:	e822                	sd	s0,16(sp)
 5cc:	1000                	addi	s0,sp,32
 5ce:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5d2:	4605                	li	a2,1
 5d4:	fef40593          	addi	a1,s0,-17
 5d8:	f4fff0ef          	jal	526 <write>
}
 5dc:	60e2                	ld	ra,24(sp)
 5de:	6442                	ld	s0,16(sp)
 5e0:	6105                	addi	sp,sp,32
 5e2:	8082                	ret

00000000000005e4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5e4:	715d                	addi	sp,sp,-80
 5e6:	e486                	sd	ra,72(sp)
 5e8:	e0a2                	sd	s0,64(sp)
 5ea:	fc26                	sd	s1,56(sp)
 5ec:	f84a                	sd	s2,48(sp)
 5ee:	f44e                	sd	s3,40(sp)
 5f0:	0880                	addi	s0,sp,80
 5f2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5f4:	c299                	beqz	a3,5fa <printint+0x16>
 5f6:	0605cc63          	bltz	a1,66e <printint+0x8a>
  neg = 0;
 5fa:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5fc:	fb840313          	addi	t1,s0,-72
  neg = 0;
 600:	869a                	mv	a3,t1
  i = 0;
 602:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 604:	00000817          	auipc	a6,0x0
 608:	58c80813          	addi	a6,a6,1420 # b90 <digits>
 60c:	88be                	mv	a7,a5
 60e:	0017851b          	addiw	a0,a5,1
 612:	87aa                	mv	a5,a0
 614:	02c5f733          	remu	a4,a1,a2
 618:	9742                	add	a4,a4,a6
 61a:	00074703          	lbu	a4,0(a4)
 61e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 622:	872e                	mv	a4,a1
 624:	02c5d5b3          	divu	a1,a1,a2
 628:	0685                	addi	a3,a3,1
 62a:	fec771e3          	bgeu	a4,a2,60c <printint+0x28>
  if(neg)
 62e:	000e0c63          	beqz	t3,646 <printint+0x62>
    buf[i++] = '-';
 632:	fd050793          	addi	a5,a0,-48
 636:	00878533          	add	a0,a5,s0
 63a:	02d00793          	li	a5,45
 63e:	fef50423          	sb	a5,-24(a0)
 642:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 646:	fff7899b          	addiw	s3,a5,-1
 64a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 64e:	fff4c583          	lbu	a1,-1(s1)
 652:	854a                	mv	a0,s2
 654:	f73ff0ef          	jal	5c6 <putc>
  while(--i >= 0)
 658:	39fd                	addiw	s3,s3,-1
 65a:	14fd                	addi	s1,s1,-1
 65c:	fe09d9e3          	bgez	s3,64e <printint+0x6a>
}
 660:	60a6                	ld	ra,72(sp)
 662:	6406                	ld	s0,64(sp)
 664:	74e2                	ld	s1,56(sp)
 666:	7942                	ld	s2,48(sp)
 668:	79a2                	ld	s3,40(sp)
 66a:	6161                	addi	sp,sp,80
 66c:	8082                	ret
    x = -xx;
 66e:	40b005b3          	neg	a1,a1
    neg = 1;
 672:	4e05                	li	t3,1
    x = -xx;
 674:	b761                	j	5fc <printint+0x18>

0000000000000676 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 676:	711d                	addi	sp,sp,-96
 678:	ec86                	sd	ra,88(sp)
 67a:	e8a2                	sd	s0,80(sp)
 67c:	e4a6                	sd	s1,72(sp)
 67e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 680:	0005c483          	lbu	s1,0(a1)
 684:	28048463          	beqz	s1,90c <vprintf+0x296>
 688:	e0ca                	sd	s2,64(sp)
 68a:	fc4e                	sd	s3,56(sp)
 68c:	f852                	sd	s4,48(sp)
 68e:	f456                	sd	s5,40(sp)
 690:	f05a                	sd	s6,32(sp)
 692:	ec5e                	sd	s7,24(sp)
 694:	e862                	sd	s8,16(sp)
 696:	e466                	sd	s9,8(sp)
 698:	8b2a                	mv	s6,a0
 69a:	8a2e                	mv	s4,a1
 69c:	8bb2                	mv	s7,a2
  state = 0;
 69e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6a0:	4901                	li	s2,0
 6a2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6a4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6a8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6ac:	06c00c93          	li	s9,108
 6b0:	a00d                	j	6d2 <vprintf+0x5c>
        putc(fd, c0);
 6b2:	85a6                	mv	a1,s1
 6b4:	855a                	mv	a0,s6
 6b6:	f11ff0ef          	jal	5c6 <putc>
 6ba:	a019                	j	6c0 <vprintf+0x4a>
    } else if(state == '%'){
 6bc:	03598363          	beq	s3,s5,6e2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6c0:	0019079b          	addiw	a5,s2,1
 6c4:	893e                	mv	s2,a5
 6c6:	873e                	mv	a4,a5
 6c8:	97d2                	add	a5,a5,s4
 6ca:	0007c483          	lbu	s1,0(a5)
 6ce:	22048763          	beqz	s1,8fc <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 6d2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6d6:	fe0993e3          	bnez	s3,6bc <vprintf+0x46>
      if(c0 == '%'){
 6da:	fd579ce3          	bne	a5,s5,6b2 <vprintf+0x3c>
        state = '%';
 6de:	89be                	mv	s3,a5
 6e0:	b7c5                	j	6c0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6e2:	00ea06b3          	add	a3,s4,a4
 6e6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6ea:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6ec:	c681                	beqz	a3,6f4 <vprintf+0x7e>
 6ee:	9752                	add	a4,a4,s4
 6f0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6f4:	05878263          	beq	a5,s8,738 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6f8:	05978c63          	beq	a5,s9,750 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6fc:	07500713          	li	a4,117
 700:	0ee78663          	beq	a5,a4,7ec <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 704:	07800713          	li	a4,120
 708:	12e78863          	beq	a5,a4,838 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 70c:	07000713          	li	a4,112
 710:	14e78d63          	beq	a5,a4,86a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 714:	06300713          	li	a4,99
 718:	18e78c63          	beq	a5,a4,8b0 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 71c:	07300713          	li	a4,115
 720:	1ae78263          	beq	a5,a4,8c4 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 724:	02500713          	li	a4,37
 728:	04e79463          	bne	a5,a4,770 <vprintf+0xfa>
        putc(fd, '%');
 72c:	85ba                	mv	a1,a4
 72e:	855a                	mv	a0,s6
 730:	e97ff0ef          	jal	5c6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 734:	4981                	li	s3,0
 736:	b769                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 738:	008b8493          	addi	s1,s7,8
 73c:	4685                	li	a3,1
 73e:	4629                	li	a2,10
 740:	000ba583          	lw	a1,0(s7)
 744:	855a                	mv	a0,s6
 746:	e9fff0ef          	jal	5e4 <printint>
 74a:	8ba6                	mv	s7,s1
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bf8d                	j	6c0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 750:	06400793          	li	a5,100
 754:	02f68963          	beq	a3,a5,786 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 758:	06c00793          	li	a5,108
 75c:	04f68263          	beq	a3,a5,7a0 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 760:	07500793          	li	a5,117
 764:	0af68063          	beq	a3,a5,804 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 768:	07800793          	li	a5,120
 76c:	0ef68263          	beq	a3,a5,850 <vprintf+0x1da>
        putc(fd, '%');
 770:	02500593          	li	a1,37
 774:	855a                	mv	a0,s6
 776:	e51ff0ef          	jal	5c6 <putc>
        putc(fd, c0);
 77a:	85a6                	mv	a1,s1
 77c:	855a                	mv	a0,s6
 77e:	e49ff0ef          	jal	5c6 <putc>
      state = 0;
 782:	4981                	li	s3,0
 784:	bf35                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 786:	008b8493          	addi	s1,s7,8
 78a:	4685                	li	a3,1
 78c:	4629                	li	a2,10
 78e:	000bb583          	ld	a1,0(s7)
 792:	855a                	mv	a0,s6
 794:	e51ff0ef          	jal	5e4 <printint>
        i += 1;
 798:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 79a:	8ba6                	mv	s7,s1
      state = 0;
 79c:	4981                	li	s3,0
        i += 1;
 79e:	b70d                	j	6c0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7a0:	06400793          	li	a5,100
 7a4:	02f60763          	beq	a2,a5,7d2 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7a8:	07500793          	li	a5,117
 7ac:	06f60963          	beq	a2,a5,81e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7b0:	07800793          	li	a5,120
 7b4:	faf61ee3          	bne	a2,a5,770 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b8:	008b8493          	addi	s1,s7,8
 7bc:	4681                	li	a3,0
 7be:	4641                	li	a2,16
 7c0:	000bb583          	ld	a1,0(s7)
 7c4:	855a                	mv	a0,s6
 7c6:	e1fff0ef          	jal	5e4 <printint>
        i += 2;
 7ca:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7cc:	8ba6                	mv	s7,s1
      state = 0;
 7ce:	4981                	li	s3,0
        i += 2;
 7d0:	bdc5                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d2:	008b8493          	addi	s1,s7,8
 7d6:	4685                	li	a3,1
 7d8:	4629                	li	a2,10
 7da:	000bb583          	ld	a1,0(s7)
 7de:	855a                	mv	a0,s6
 7e0:	e05ff0ef          	jal	5e4 <printint>
        i += 2;
 7e4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e6:	8ba6                	mv	s7,s1
      state = 0;
 7e8:	4981                	li	s3,0
        i += 2;
 7ea:	bdd9                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7ec:	008b8493          	addi	s1,s7,8
 7f0:	4681                	li	a3,0
 7f2:	4629                	li	a2,10
 7f4:	000be583          	lwu	a1,0(s7)
 7f8:	855a                	mv	a0,s6
 7fa:	debff0ef          	jal	5e4 <printint>
 7fe:	8ba6                	mv	s7,s1
      state = 0;
 800:	4981                	li	s3,0
 802:	bd7d                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 804:	008b8493          	addi	s1,s7,8
 808:	4681                	li	a3,0
 80a:	4629                	li	a2,10
 80c:	000bb583          	ld	a1,0(s7)
 810:	855a                	mv	a0,s6
 812:	dd3ff0ef          	jal	5e4 <printint>
        i += 1;
 816:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 818:	8ba6                	mv	s7,s1
      state = 0;
 81a:	4981                	li	s3,0
        i += 1;
 81c:	b555                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 81e:	008b8493          	addi	s1,s7,8
 822:	4681                	li	a3,0
 824:	4629                	li	a2,10
 826:	000bb583          	ld	a1,0(s7)
 82a:	855a                	mv	a0,s6
 82c:	db9ff0ef          	jal	5e4 <printint>
        i += 2;
 830:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 832:	8ba6                	mv	s7,s1
      state = 0;
 834:	4981                	li	s3,0
        i += 2;
 836:	b569                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 838:	008b8493          	addi	s1,s7,8
 83c:	4681                	li	a3,0
 83e:	4641                	li	a2,16
 840:	000be583          	lwu	a1,0(s7)
 844:	855a                	mv	a0,s6
 846:	d9fff0ef          	jal	5e4 <printint>
 84a:	8ba6                	mv	s7,s1
      state = 0;
 84c:	4981                	li	s3,0
 84e:	bd8d                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 850:	008b8493          	addi	s1,s7,8
 854:	4681                	li	a3,0
 856:	4641                	li	a2,16
 858:	000bb583          	ld	a1,0(s7)
 85c:	855a                	mv	a0,s6
 85e:	d87ff0ef          	jal	5e4 <printint>
        i += 1;
 862:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 864:	8ba6                	mv	s7,s1
      state = 0;
 866:	4981                	li	s3,0
        i += 1;
 868:	bda1                	j	6c0 <vprintf+0x4a>
 86a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 86c:	008b8d13          	addi	s10,s7,8
 870:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 874:	03000593          	li	a1,48
 878:	855a                	mv	a0,s6
 87a:	d4dff0ef          	jal	5c6 <putc>
  putc(fd, 'x');
 87e:	07800593          	li	a1,120
 882:	855a                	mv	a0,s6
 884:	d43ff0ef          	jal	5c6 <putc>
 888:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 88a:	00000b97          	auipc	s7,0x0
 88e:	306b8b93          	addi	s7,s7,774 # b90 <digits>
 892:	03c9d793          	srli	a5,s3,0x3c
 896:	97de                	add	a5,a5,s7
 898:	0007c583          	lbu	a1,0(a5)
 89c:	855a                	mv	a0,s6
 89e:	d29ff0ef          	jal	5c6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8a2:	0992                	slli	s3,s3,0x4
 8a4:	34fd                	addiw	s1,s1,-1
 8a6:	f4f5                	bnez	s1,892 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 8a8:	8bea                	mv	s7,s10
      state = 0;
 8aa:	4981                	li	s3,0
 8ac:	6d02                	ld	s10,0(sp)
 8ae:	bd09                	j	6c0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 8b0:	008b8493          	addi	s1,s7,8
 8b4:	000bc583          	lbu	a1,0(s7)
 8b8:	855a                	mv	a0,s6
 8ba:	d0dff0ef          	jal	5c6 <putc>
 8be:	8ba6                	mv	s7,s1
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	bbfd                	j	6c0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8c4:	008b8993          	addi	s3,s7,8
 8c8:	000bb483          	ld	s1,0(s7)
 8cc:	cc91                	beqz	s1,8e8 <vprintf+0x272>
        for(; *s; s++)
 8ce:	0004c583          	lbu	a1,0(s1)
 8d2:	c195                	beqz	a1,8f6 <vprintf+0x280>
          putc(fd, *s);
 8d4:	855a                	mv	a0,s6
 8d6:	cf1ff0ef          	jal	5c6 <putc>
        for(; *s; s++)
 8da:	0485                	addi	s1,s1,1
 8dc:	0004c583          	lbu	a1,0(s1)
 8e0:	f9f5                	bnez	a1,8d4 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 8e2:	8bce                	mv	s7,s3
      state = 0;
 8e4:	4981                	li	s3,0
 8e6:	bbe9                	j	6c0 <vprintf+0x4a>
          s = "(null)";
 8e8:	00000497          	auipc	s1,0x0
 8ec:	2a048493          	addi	s1,s1,672 # b88 <malloc+0x190>
        for(; *s; s++)
 8f0:	02800593          	li	a1,40
 8f4:	b7c5                	j	8d4 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 8f6:	8bce                	mv	s7,s3
      state = 0;
 8f8:	4981                	li	s3,0
 8fa:	b3d9                	j	6c0 <vprintf+0x4a>
 8fc:	6906                	ld	s2,64(sp)
 8fe:	79e2                	ld	s3,56(sp)
 900:	7a42                	ld	s4,48(sp)
 902:	7aa2                	ld	s5,40(sp)
 904:	7b02                	ld	s6,32(sp)
 906:	6be2                	ld	s7,24(sp)
 908:	6c42                	ld	s8,16(sp)
 90a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 90c:	60e6                	ld	ra,88(sp)
 90e:	6446                	ld	s0,80(sp)
 910:	64a6                	ld	s1,72(sp)
 912:	6125                	addi	sp,sp,96
 914:	8082                	ret

0000000000000916 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 916:	715d                	addi	sp,sp,-80
 918:	ec06                	sd	ra,24(sp)
 91a:	e822                	sd	s0,16(sp)
 91c:	1000                	addi	s0,sp,32
 91e:	e010                	sd	a2,0(s0)
 920:	e414                	sd	a3,8(s0)
 922:	e818                	sd	a4,16(s0)
 924:	ec1c                	sd	a5,24(s0)
 926:	03043023          	sd	a6,32(s0)
 92a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 92e:	8622                	mv	a2,s0
 930:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 934:	d43ff0ef          	jal	676 <vprintf>
}
 938:	60e2                	ld	ra,24(sp)
 93a:	6442                	ld	s0,16(sp)
 93c:	6161                	addi	sp,sp,80
 93e:	8082                	ret

0000000000000940 <printf>:

void
printf(const char *fmt, ...)
{
 940:	711d                	addi	sp,sp,-96
 942:	ec06                	sd	ra,24(sp)
 944:	e822                	sd	s0,16(sp)
 946:	1000                	addi	s0,sp,32
 948:	e40c                	sd	a1,8(s0)
 94a:	e810                	sd	a2,16(s0)
 94c:	ec14                	sd	a3,24(s0)
 94e:	f018                	sd	a4,32(s0)
 950:	f41c                	sd	a5,40(s0)
 952:	03043823          	sd	a6,48(s0)
 956:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 95a:	00840613          	addi	a2,s0,8
 95e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 962:	85aa                	mv	a1,a0
 964:	4505                	li	a0,1
 966:	d11ff0ef          	jal	676 <vprintf>
}
 96a:	60e2                	ld	ra,24(sp)
 96c:	6442                	ld	s0,16(sp)
 96e:	6125                	addi	sp,sp,96
 970:	8082                	ret

0000000000000972 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 972:	1141                	addi	sp,sp,-16
 974:	e406                	sd	ra,8(sp)
 976:	e022                	sd	s0,0(sp)
 978:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 97a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97e:	00000797          	auipc	a5,0x0
 982:	6827b783          	ld	a5,1666(a5) # 1000 <freep>
 986:	a02d                	j	9b0 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 988:	4618                	lw	a4,8(a2)
 98a:	9f2d                	addw	a4,a4,a1
 98c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 990:	6398                	ld	a4,0(a5)
 992:	6310                	ld	a2,0(a4)
 994:	a83d                	j	9d2 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 996:	ff852703          	lw	a4,-8(a0)
 99a:	9f31                	addw	a4,a4,a2
 99c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 99e:	ff053683          	ld	a3,-16(a0)
 9a2:	a091                	j	9e6 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a4:	6398                	ld	a4,0(a5)
 9a6:	00e7e463          	bltu	a5,a4,9ae <free+0x3c>
 9aa:	00e6ea63          	bltu	a3,a4,9be <free+0x4c>
{
 9ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b0:	fed7fae3          	bgeu	a5,a3,9a4 <free+0x32>
 9b4:	6398                	ld	a4,0(a5)
 9b6:	00e6e463          	bltu	a3,a4,9be <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ba:	fee7eae3          	bltu	a5,a4,9ae <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9be:	ff852583          	lw	a1,-8(a0)
 9c2:	6390                	ld	a2,0(a5)
 9c4:	02059813          	slli	a6,a1,0x20
 9c8:	01c85713          	srli	a4,a6,0x1c
 9cc:	9736                	add	a4,a4,a3
 9ce:	fae60de3          	beq	a2,a4,988 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9d2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9d6:	4790                	lw	a2,8(a5)
 9d8:	02061593          	slli	a1,a2,0x20
 9dc:	01c5d713          	srli	a4,a1,0x1c
 9e0:	973e                	add	a4,a4,a5
 9e2:	fae68ae3          	beq	a3,a4,996 <free+0x24>
    p->s.ptr = bp->s.ptr;
 9e6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9e8:	00000717          	auipc	a4,0x0
 9ec:	60f73c23          	sd	a5,1560(a4) # 1000 <freep>
}
 9f0:	60a2                	ld	ra,8(sp)
 9f2:	6402                	ld	s0,0(sp)
 9f4:	0141                	addi	sp,sp,16
 9f6:	8082                	ret

00000000000009f8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9f8:	7139                	addi	sp,sp,-64
 9fa:	fc06                	sd	ra,56(sp)
 9fc:	f822                	sd	s0,48(sp)
 9fe:	f04a                	sd	s2,32(sp)
 a00:	ec4e                	sd	s3,24(sp)
 a02:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a04:	02051993          	slli	s3,a0,0x20
 a08:	0209d993          	srli	s3,s3,0x20
 a0c:	09bd                	addi	s3,s3,15
 a0e:	0049d993          	srli	s3,s3,0x4
 a12:	2985                	addiw	s3,s3,1
 a14:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a16:	00000517          	auipc	a0,0x0
 a1a:	5ea53503          	ld	a0,1514(a0) # 1000 <freep>
 a1e:	c905                	beqz	a0,a4e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a20:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a22:	4798                	lw	a4,8(a5)
 a24:	09377663          	bgeu	a4,s3,ab0 <malloc+0xb8>
 a28:	f426                	sd	s1,40(sp)
 a2a:	e852                	sd	s4,16(sp)
 a2c:	e456                	sd	s5,8(sp)
 a2e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a30:	8a4e                	mv	s4,s3
 a32:	6705                	lui	a4,0x1
 a34:	00e9f363          	bgeu	s3,a4,a3a <malloc+0x42>
 a38:	6a05                	lui	s4,0x1
 a3a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a3e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a42:	00000497          	auipc	s1,0x0
 a46:	5be48493          	addi	s1,s1,1470 # 1000 <freep>
  if(p == SBRK_ERROR)
 a4a:	5afd                	li	s5,-1
 a4c:	a83d                	j	a8a <malloc+0x92>
 a4e:	f426                	sd	s1,40(sp)
 a50:	e852                	sd	s4,16(sp)
 a52:	e456                	sd	s5,8(sp)
 a54:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a56:	00000797          	auipc	a5,0x0
 a5a:	7b278793          	addi	a5,a5,1970 # 1208 <base>
 a5e:	00000717          	auipc	a4,0x0
 a62:	5af73123          	sd	a5,1442(a4) # 1000 <freep>
 a66:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a68:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a6c:	b7d1                	j	a30 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a6e:	6398                	ld	a4,0(a5)
 a70:	e118                	sd	a4,0(a0)
 a72:	a899                	j	ac8 <malloc+0xd0>
  hp->s.size = nu;
 a74:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a78:	0541                	addi	a0,a0,16
 a7a:	ef9ff0ef          	jal	972 <free>
  return freep;
 a7e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a80:	c125                	beqz	a0,ae0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a82:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a84:	4798                	lw	a4,8(a5)
 a86:	03277163          	bgeu	a4,s2,aa8 <malloc+0xb0>
    if(p == freep)
 a8a:	6098                	ld	a4,0(s1)
 a8c:	853e                	mv	a0,a5
 a8e:	fef71ae3          	bne	a4,a5,a82 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a92:	8552                	mv	a0,s4
 a94:	8c7ff0ef          	jal	35a <sbrk>
  if(p == SBRK_ERROR)
 a98:	fd551ee3          	bne	a0,s5,a74 <malloc+0x7c>
        return 0;
 a9c:	4501                	li	a0,0
 a9e:	74a2                	ld	s1,40(sp)
 aa0:	6a42                	ld	s4,16(sp)
 aa2:	6aa2                	ld	s5,8(sp)
 aa4:	6b02                	ld	s6,0(sp)
 aa6:	a03d                	j	ad4 <malloc+0xdc>
 aa8:	74a2                	ld	s1,40(sp)
 aaa:	6a42                	ld	s4,16(sp)
 aac:	6aa2                	ld	s5,8(sp)
 aae:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ab0:	fae90fe3          	beq	s2,a4,a6e <malloc+0x76>
        p->s.size -= nunits;
 ab4:	4137073b          	subw	a4,a4,s3
 ab8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aba:	02071693          	slli	a3,a4,0x20
 abe:	01c6d713          	srli	a4,a3,0x1c
 ac2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ac4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ac8:	00000717          	auipc	a4,0x0
 acc:	52a73c23          	sd	a0,1336(a4) # 1000 <freep>
      return (void*)(p + 1);
 ad0:	01078513          	addi	a0,a5,16
  }
}
 ad4:	70e2                	ld	ra,56(sp)
 ad6:	7442                	ld	s0,48(sp)
 ad8:	7902                	ld	s2,32(sp)
 ada:	69e2                	ld	s3,24(sp)
 adc:	6121                	addi	sp,sp,64
 ade:	8082                	ret
 ae0:	74a2                	ld	s1,40(sp)
 ae2:	6a42                	ld	s4,16(sp)
 ae4:	6aa2                	ld	s5,8(sp)
 ae6:	6b02                	ld	s6,0(sp)
 ae8:	b7f5                	j	ad4 <malloc+0xdc>
