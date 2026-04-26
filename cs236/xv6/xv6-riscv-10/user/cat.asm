
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	00001917          	auipc	s2,0x1
  18:	ffc90913          	addi	s2,s2,-4 # 1010 <buf>
  1c:	20000a13          	li	s4,512
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	526000ef          	jal	54e <read>
  2c:	84aa                	mv	s1,a0
  2e:	02a05363          	blez	a0,54 <cat+0x54>
    if (write(1, buf, n) != n) {
  32:	8626                	mv	a2,s1
  34:	85ca                	mv	a1,s2
  36:	8556                	mv	a0,s5
  38:	51e000ef          	jal	556 <write>
  3c:	fe9503e3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	ae058593          	addi	a1,a1,-1312 # b20 <malloc+0xf8>
  48:	4509                	li	a0,2
  4a:	0fd000ef          	jal	946 <fprintf>
      exit(1);
  4e:	4505                	li	a0,1
  50:	4e6000ef          	jal	536 <exit>
    }
  }
  if(n < 0){
  54:	00054b63          	bltz	a0,6a <cat+0x6a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  58:	70e2                	ld	ra,56(sp)
  5a:	7442                	ld	s0,48(sp)
  5c:	74a2                	ld	s1,40(sp)
  5e:	7902                	ld	s2,32(sp)
  60:	69e2                	ld	s3,24(sp)
  62:	6a42                	ld	s4,16(sp)
  64:	6aa2                	ld	s5,8(sp)
  66:	6121                	addi	sp,sp,64
  68:	8082                	ret
    fprintf(2, "cat: read error\n");
  6a:	00001597          	auipc	a1,0x1
  6e:	ace58593          	addi	a1,a1,-1330 # b38 <malloc+0x110>
  72:	4509                	li	a0,2
  74:	0d3000ef          	jal	946 <fprintf>
    exit(1);
  78:	4505                	li	a0,1
  7a:	4bc000ef          	jal	536 <exit>

000000000000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	7179                	addi	sp,sp,-48
  80:	f406                	sd	ra,40(sp)
  82:	f022                	sd	s0,32(sp)
  84:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  86:	4785                	li	a5,1
  88:	04a7d263          	bge	a5,a0,cc <main+0x4e>
  8c:	ec26                	sd	s1,24(sp)
  8e:	e84a                	sd	s2,16(sp)
  90:	e44e                	sd	s3,8(sp)
  92:	00858913          	addi	s2,a1,8
  96:	ffe5099b          	addiw	s3,a0,-2
  9a:	02099793          	slli	a5,s3,0x20
  9e:	01d7d993          	srli	s3,a5,0x1d
  a2:	05c1                	addi	a1,a1,16
  a4:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  a6:	4581                	li	a1,0
  a8:	00093503          	ld	a0,0(s2)
  ac:	4ca000ef          	jal	576 <open>
  b0:	84aa                	mv	s1,a0
  b2:	02054663          	bltz	a0,de <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  b6:	f4bff0ef          	jal	0 <cat>
    close(fd);
  ba:	8526                	mv	a0,s1
  bc:	4a2000ef          	jal	55e <close>
  for(i = 1; i < argc; i++){
  c0:	0921                	addi	s2,s2,8
  c2:	ff3912e3          	bne	s2,s3,a6 <main+0x28>
  }
  exit(0);
  c6:	4501                	li	a0,0
  c8:	46e000ef          	jal	536 <exit>
  cc:	ec26                	sd	s1,24(sp)
  ce:	e84a                	sd	s2,16(sp)
  d0:	e44e                	sd	s3,8(sp)
    cat(0);
  d2:	4501                	li	a0,0
  d4:	f2dff0ef          	jal	0 <cat>
    exit(0);
  d8:	4501                	li	a0,0
  da:	45c000ef          	jal	536 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  de:	00093603          	ld	a2,0(s2)
  e2:	00001597          	auipc	a1,0x1
  e6:	a6e58593          	addi	a1,a1,-1426 # b50 <malloc+0x128>
  ea:	4509                	li	a0,2
  ec:	05b000ef          	jal	946 <fprintf>
      exit(1);
  f0:	4505                	li	a0,1
  f2:	444000ef          	jal	536 <exit>

00000000000000f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  fe:	f81ff0ef          	jal	7e <main>
  exit(r);
 102:	434000ef          	jal	536 <exit>

0000000000000106 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10e:	87aa                	mv	a5,a0
 110:	0585                	addi	a1,a1,1
 112:	0785                	addi	a5,a5,1
 114:	fff5c703          	lbu	a4,-1(a1)
 118:	fee78fa3          	sb	a4,-1(a5)
 11c:	fb75                	bnez	a4,110 <strcpy+0xa>
    ;
  return os;
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb91                	beqz	a5,146 <strcmp+0x20>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71763          	bne	a4,a5,146 <strcmp+0x20>
    p++, q++;
 13c:	0505                	addi	a0,a0,1
 13e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	fbe5                	bnez	a5,134 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 146:	0005c503          	lbu	a0,0(a1)
}
 14a:	40a7853b          	subw	a0,a5,a0
 14e:	60a2                	ld	ra,8(sp)
 150:	6402                	ld	s0,0(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strlen>:

uint
strlen(const char *s)
{
 156:	1141                	addi	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cf99                	beqz	a5,180 <strlen+0x2a>
 164:	0505                	addi	a0,a0,1
 166:	87aa                	mv	a5,a0
 168:	86be                	mv	a3,a5
 16a:	0785                	addi	a5,a5,1
 16c:	fff7c703          	lbu	a4,-1(a5)
 170:	ff65                	bnez	a4,168 <strlen+0x12>
 172:	40a6853b          	subw	a0,a3,a0
 176:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 178:	60a2                	ld	ra,8(sp)
 17a:	6402                	ld	s0,0(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret
  for(n = 0; s[n]; n++)
 180:	4501                	li	a0,0
 182:	bfdd                	j	178 <strlen+0x22>

0000000000000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	1141                	addi	sp,sp,-16
 186:	e406                	sd	ra,8(sp)
 188:	e022                	sd	s0,0(sp)
 18a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18c:	ca19                	beqz	a2,1a2 <memset+0x1e>
 18e:	87aa                	mv	a5,a0
 190:	1602                	slli	a2,a2,0x20
 192:	9201                	srli	a2,a2,0x20
 194:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 198:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19c:	0785                	addi	a5,a5,1
 19e:	fee79de3          	bne	a5,a4,198 <memset+0x14>
  }
  return dst;
}
 1a2:	60a2                	ld	ra,8(sp)
 1a4:	6402                	ld	s0,0(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <strchr>:

char*
strchr(const char *s, char c)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	cf81                	beqz	a5,1ce <strchr+0x24>
    if(*s == c)
 1b8:	00f58763          	beq	a1,a5,1c6 <strchr+0x1c>
  for(; *s; s++)
 1bc:	0505                	addi	a0,a0,1
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	fbfd                	bnez	a5,1b8 <strchr+0xe>
      return (char*)s;
  return 0;
 1c4:	4501                	li	a0,0
}
 1c6:	60a2                	ld	ra,8(sp)
 1c8:	6402                	ld	s0,0(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret
  return 0;
 1ce:	4501                	li	a0,0
 1d0:	bfdd                	j	1c6 <strchr+0x1c>

00000000000001d2 <gets>:

char*
gets(char *buf, int max)
{
 1d2:	7159                	addi	sp,sp,-112
 1d4:	f486                	sd	ra,104(sp)
 1d6:	f0a2                	sd	s0,96(sp)
 1d8:	eca6                	sd	s1,88(sp)
 1da:	e8ca                	sd	s2,80(sp)
 1dc:	e4ce                	sd	s3,72(sp)
 1de:	e0d2                	sd	s4,64(sp)
 1e0:	fc56                	sd	s5,56(sp)
 1e2:	f85a                	sd	s6,48(sp)
 1e4:	f45e                	sd	s7,40(sp)
 1e6:	f062                	sd	s8,32(sp)
 1e8:	ec66                	sd	s9,24(sp)
 1ea:	e86a                	sd	s10,16(sp)
 1ec:	1880                	addi	s0,sp,112
 1ee:	8caa                	mv	s9,a0
 1f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f2:	892a                	mv	s2,a0
 1f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1f6:	f9f40b13          	addi	s6,s0,-97
 1fa:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1fc:	4ba9                	li	s7,10
 1fe:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 200:	8d26                	mv	s10,s1
 202:	0014899b          	addiw	s3,s1,1
 206:	84ce                	mv	s1,s3
 208:	0349d563          	bge	s3,s4,232 <gets+0x60>
    cc = read(0, &c, 1);
 20c:	8656                	mv	a2,s5
 20e:	85da                	mv	a1,s6
 210:	4501                	li	a0,0
 212:	33c000ef          	jal	54e <read>
    if(cc < 1)
 216:	00a05e63          	blez	a0,232 <gets+0x60>
    buf[i++] = c;
 21a:	f9f44783          	lbu	a5,-97(s0)
 21e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 222:	01778763          	beq	a5,s7,230 <gets+0x5e>
 226:	0905                	addi	s2,s2,1
 228:	fd879ce3          	bne	a5,s8,200 <gets+0x2e>
    buf[i++] = c;
 22c:	8d4e                	mv	s10,s3
 22e:	a011                	j	232 <gets+0x60>
 230:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 232:	9d66                	add	s10,s10,s9
 234:	000d0023          	sb	zero,0(s10)
  return buf;
}
 238:	8566                	mv	a0,s9
 23a:	70a6                	ld	ra,104(sp)
 23c:	7406                	ld	s0,96(sp)
 23e:	64e6                	ld	s1,88(sp)
 240:	6946                	ld	s2,80(sp)
 242:	69a6                	ld	s3,72(sp)
 244:	6a06                	ld	s4,64(sp)
 246:	7ae2                	ld	s5,56(sp)
 248:	7b42                	ld	s6,48(sp)
 24a:	7ba2                	ld	s7,40(sp)
 24c:	7c02                	ld	s8,32(sp)
 24e:	6ce2                	ld	s9,24(sp)
 250:	6d42                	ld	s10,16(sp)
 252:	6165                	addi	sp,sp,112
 254:	8082                	ret

0000000000000256 <stat>:

int
stat(const char *n, struct stat *st)
{
 256:	1101                	addi	sp,sp,-32
 258:	ec06                	sd	ra,24(sp)
 25a:	e822                	sd	s0,16(sp)
 25c:	e04a                	sd	s2,0(sp)
 25e:	1000                	addi	s0,sp,32
 260:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 262:	4581                	li	a1,0
 264:	312000ef          	jal	576 <open>
  if(fd < 0)
 268:	02054263          	bltz	a0,28c <stat+0x36>
 26c:	e426                	sd	s1,8(sp)
 26e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	31c000ef          	jal	58e <fstat>
 276:	892a                	mv	s2,a0
  close(fd);
 278:	8526                	mv	a0,s1
 27a:	2e4000ef          	jal	55e <close>
  return r;
 27e:	64a2                	ld	s1,8(sp)
}
 280:	854a                	mv	a0,s2
 282:	60e2                	ld	ra,24(sp)
 284:	6442                	ld	s0,16(sp)
 286:	6902                	ld	s2,0(sp)
 288:	6105                	addi	sp,sp,32
 28a:	8082                	ret
    return -1;
 28c:	597d                	li	s2,-1
 28e:	bfcd                	j	280 <stat+0x2a>

0000000000000290 <atoi>:

int
atoi(const char *s)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 298:	00054683          	lbu	a3,0(a0)
 29c:	fd06879b          	addiw	a5,a3,-48
 2a0:	0ff7f793          	zext.b	a5,a5
 2a4:	4625                	li	a2,9
 2a6:	02f66963          	bltu	a2,a5,2d8 <atoi+0x48>
 2aa:	872a                	mv	a4,a0
  n = 0;
 2ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ae:	0705                	addi	a4,a4,1
 2b0:	0025179b          	slliw	a5,a0,0x2
 2b4:	9fa9                	addw	a5,a5,a0
 2b6:	0017979b          	slliw	a5,a5,0x1
 2ba:	9fb5                	addw	a5,a5,a3
 2bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c0:	00074683          	lbu	a3,0(a4)
 2c4:	fd06879b          	addiw	a5,a3,-48
 2c8:	0ff7f793          	zext.b	a5,a5
 2cc:	fef671e3          	bgeu	a2,a5,2ae <atoi+0x1e>
  return n;
}
 2d0:	60a2                	ld	ra,8(sp)
 2d2:	6402                	ld	s0,0(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
  n = 0;
 2d8:	4501                	li	a0,0
 2da:	bfdd                	j	2d0 <atoi+0x40>

00000000000002dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e4:	02b57563          	bgeu	a0,a1,30e <memmove+0x32>
    while(n-- > 0)
 2e8:	00c05f63          	blez	a2,306 <memmove+0x2a>
 2ec:	1602                	slli	a2,a2,0x20
 2ee:	9201                	srli	a2,a2,0x20
 2f0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f6:	0585                	addi	a1,a1,1
 2f8:	0705                	addi	a4,a4,1
 2fa:	fff5c683          	lbu	a3,-1(a1)
 2fe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 302:	fee79ae3          	bne	a5,a4,2f6 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
    dst += n;
 30e:	00c50733          	add	a4,a0,a2
    src += n;
 312:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 314:	fec059e3          	blez	a2,306 <memmove+0x2a>
 318:	fff6079b          	addiw	a5,a2,-1
 31c:	1782                	slli	a5,a5,0x20
 31e:	9381                	srli	a5,a5,0x20
 320:	fff7c793          	not	a5,a5
 324:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 326:	15fd                	addi	a1,a1,-1
 328:	177d                	addi	a4,a4,-1
 32a:	0005c683          	lbu	a3,0(a1)
 32e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 332:	fef71ae3          	bne	a4,a5,326 <memmove+0x4a>
 336:	bfc1                	j	306 <memmove+0x2a>

0000000000000338 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 340:	ca0d                	beqz	a2,372 <memcmp+0x3a>
 342:	fff6069b          	addiw	a3,a2,-1
 346:	1682                	slli	a3,a3,0x20
 348:	9281                	srli	a3,a3,0x20
 34a:	0685                	addi	a3,a3,1
 34c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34e:	00054783          	lbu	a5,0(a0)
 352:	0005c703          	lbu	a4,0(a1)
 356:	00e79863          	bne	a5,a4,366 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 35a:	0505                	addi	a0,a0,1
    p2++;
 35c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35e:	fed518e3          	bne	a0,a3,34e <memcmp+0x16>
  }
  return 0;
 362:	4501                	li	a0,0
 364:	a019                	j	36a <memcmp+0x32>
      return *p1 - *p2;
 366:	40e7853b          	subw	a0,a5,a4
}
 36a:	60a2                	ld	ra,8(sp)
 36c:	6402                	ld	s0,0(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret
  return 0;
 372:	4501                	li	a0,0
 374:	bfdd                	j	36a <memcmp+0x32>

0000000000000376 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 376:	1141                	addi	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 37e:	f5fff0ef          	jal	2dc <memmove>
}
 382:	60a2                	ld	ra,8(sp)
 384:	6402                	ld	s0,0(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <sbrk>:

char *
sbrk(int n) {
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 392:	4585                	li	a1,1
 394:	22a000ef          	jal	5be <sys_sbrk>
}
 398:	60a2                	ld	ra,8(sp)
 39a:	6402                	ld	s0,0(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <sbrklazy>:

char *
sbrklazy(int n) {
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e406                	sd	ra,8(sp)
 3a4:	e022                	sd	s0,0(sp)
 3a6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3a8:	4589                	li	a1,2
 3aa:	214000ef          	jal	5be <sys_sbrk>
}
 3ae:	60a2                	ld	ra,8(sp)
 3b0:	6402                	ld	s0,0(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret

00000000000003b6 <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 3b6:	1101                	addi	sp,sp,-32
 3b8:	ec06                	sd	ra,24(sp)
 3ba:	e822                	sd	s0,16(sp)
 3bc:	e426                	sd	s1,8(sp)
 3be:	e04a                	sd	s2,0(sp)
 3c0:	1000                	addi	s0,sp,32
 3c2:	84aa                	mv	s1,a0
 3c4:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 3c6:	6505                	lui	a0,0x1
 3c8:	fc3ff0ef          	jal	38a <sbrk>
 3cc:	6785                	lui	a5,0x1
 3ce:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 3d2:	9a41                	andi	a2,a2,-16
 3d4:	85ca                	mv	a1,s2
 3d6:	8526                	mv	a0,s1
 3d8:	1fe000ef          	jal	5d6 <clone>
}
 3dc:	60e2                	ld	ra,24(sp)
 3de:	6442                	ld	s0,16(sp)
 3e0:	64a2                	ld	s1,8(sp)
 3e2:	6902                	ld	s2,0(sp)
 3e4:	6105                	addi	sp,sp,32
 3e6:	8082                	ret

00000000000003e8 <futex>:

void futex(int *uaddr, int ops, int val) {
 3e8:	7179                	addi	sp,sp,-48
 3ea:	f406                	sd	ra,40(sp)
 3ec:	f022                	sd	s0,32(sp)
 3ee:	ec26                	sd	s1,24(sp)
 3f0:	1800                	addi	s0,sp,48
 3f2:	84aa                	mv	s1,a0
  if (ops==0) {
 3f4:	ed95                	bnez	a1,430 <futex+0x48>
    if (val==0) {
 3f6:	c611                	beqz	a2,402 <futex+0x1a>
 3f8:	e84a                	sd	s2,16(sp)
 3fa:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 3fc:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 3fe:	4985                	li	s3,1
 400:	a005                	j	420 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 402:	4705                	li	a4,1
 404:	87ba                	mv	a5,a4
 406:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 40a:	2781                	sext.w	a5,a5
 40c:	ffe5                	bnez	a5,404 <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 40e:	70a2                	ld	ra,40(sp)
 410:	7402                	ld	s0,32(sp)
 412:	64e2                	ld	s1,24(sp)
 414:	6145                	addi	sp,sp,48
 416:	8082                	ret
        futex_wait(uaddr, 1);
 418:	85ce                	mv	a1,s3
 41a:	8526                	mv	a0,s1
 41c:	1ca000ef          	jal	5e6 <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 420:	87ca                	mv	a5,s2
 422:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 426:	2781                	sext.w	a5,a5
 428:	fbe5                	bnez	a5,418 <futex+0x30>
 42a:	6942                	ld	s2,16(sp)
 42c:	69a2                	ld	s3,8(sp)
 42e:	b7c5                	j	40e <futex+0x26>
    if (val==0) {
 430:	e611                	bnez	a2,43c <futex+0x54>
      __sync_lock_release(uaddr);
 432:	0310000f          	fence	rw,w
 436:	00052023          	sw	zero,0(a0) # 1000 <freep>
 43a:	bfd1                	j	40e <futex+0x26>
      __sync_lock_release(uaddr);
 43c:	0310000f          	fence	rw,w
 440:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 444:	1aa000ef          	jal	5ee <futex_wake>
  return;
 448:	b7d9                	j	40e <futex+0x26>

000000000000044a <sem_init>:

void sem_init(sem_t* s, int val) {
 44a:	7179                	addi	sp,sp,-48
 44c:	f406                	sd	ra,40(sp)
 44e:	f022                	sd	s0,32(sp)
 450:	ec26                	sd	s1,24(sp)
 452:	e84a                	sd	s2,16(sp)
 454:	e44e                	sd	s3,8(sp)
 456:	1800                	addi	s0,sp,48
 458:	84aa                	mv	s1,a0
 45a:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 45c:	00450993          	addi	s3,a0,4
 460:	4605                	li	a2,1
 462:	4581                	li	a1,0
 464:	854e                	mv	a0,s3
 466:	f83ff0ef          	jal	3e8 <futex>
  s->value = val;
 46a:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 46e:	4605                	li	a2,1
 470:	85b2                	mv	a1,a2
 472:	854e                	mv	a0,s3
 474:	f75ff0ef          	jal	3e8 <futex>
  return;
}
 478:	70a2                	ld	ra,40(sp)
 47a:	7402                	ld	s0,32(sp)
 47c:	64e2                	ld	s1,24(sp)
 47e:	6942                	ld	s2,16(sp)
 480:	69a2                	ld	s3,8(sp)
 482:	6145                	addi	sp,sp,48
 484:	8082                	ret

0000000000000486 <sem_down>:

void sem_down(sem_t* s) {
 486:	7179                	addi	sp,sp,-48
 488:	f406                	sd	ra,40(sp)
 48a:	f022                	sd	s0,32(sp)
 48c:	ec26                	sd	s1,24(sp)
 48e:	e84a                	sd	s2,16(sp)
 490:	e44e                	sd	s3,8(sp)
 492:	1800                	addi	s0,sp,48
 494:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 496:	00450993          	addi	s3,a0,4
 49a:	4605                	li	a2,1
 49c:	4581                	li	a1,0
 49e:	854e                	mv	a0,s3
 4a0:	f49ff0ef          	jal	3e8 <futex>
  while(1) {
    if (s->value>0) {
 4a4:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 4a8:	4485                	li	s1,1
    if (s->value>0) {
 4aa:	02f04463          	bgtz	a5,4d2 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 4ae:	8626                	mv	a2,s1
 4b0:	85a6                	mv	a1,s1
 4b2:	854e                	mv	a0,s3
 4b4:	f35ff0ef          	jal	3e8 <futex>
      futex_wait(&s->value,1);
 4b8:	85a6                	mv	a1,s1
 4ba:	854a                	mv	a0,s2
 4bc:	12a000ef          	jal	5e6 <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 4c0:	8626                	mv	a2,s1
 4c2:	4581                	li	a1,0
 4c4:	854e                	mv	a0,s3
 4c6:	f23ff0ef          	jal	3e8 <futex>
    if (s->value>0) {
 4ca:	00092783          	lw	a5,0(s2)
 4ce:	fef050e3          	blez	a5,4ae <sem_down+0x28>
      s->value--;
 4d2:	37fd                	addiw	a5,a5,-1 # fff <digits+0x48f>
 4d4:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4d8:	4605                	li	a2,1
 4da:	85b2                	mv	a1,a2
 4dc:	854e                	mv	a0,s3
 4de:	f0bff0ef          	jal	3e8 <futex>
  return;
}
 4e2:	70a2                	ld	ra,40(sp)
 4e4:	7402                	ld	s0,32(sp)
 4e6:	64e2                	ld	s1,24(sp)
 4e8:	6942                	ld	s2,16(sp)
 4ea:	69a2                	ld	s3,8(sp)
 4ec:	6145                	addi	sp,sp,48
 4ee:	8082                	ret

00000000000004f0 <sem_up>:

void sem_up(sem_t* s) {
 4f0:	1101                	addi	sp,sp,-32
 4f2:	ec06                	sd	ra,24(sp)
 4f4:	e822                	sd	s0,16(sp)
 4f6:	e426                	sd	s1,8(sp)
 4f8:	e04a                	sd	s2,0(sp)
 4fa:	1000                	addi	s0,sp,32
 4fc:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 4fe:	00450913          	addi	s2,a0,4
 502:	4605                	li	a2,1
 504:	4581                	li	a1,0
 506:	854a                	mv	a0,s2
 508:	ee1ff0ef          	jal	3e8 <futex>
  s->value++;
 50c:	409c                	lw	a5,0(s1)
 50e:	2785                	addiw	a5,a5,1
 510:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 512:	8526                	mv	a0,s1
 514:	0da000ef          	jal	5ee <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 518:	4605                	li	a2,1
 51a:	85b2                	mv	a1,a2
 51c:	854a                	mv	a0,s2
 51e:	ecbff0ef          	jal	3e8 <futex>
  return;
 522:	60e2                	ld	ra,24(sp)
 524:	6442                	ld	s0,16(sp)
 526:	64a2                	ld	s1,8(sp)
 528:	6902                	ld	s2,0(sp)
 52a:	6105                	addi	sp,sp,32
 52c:	8082                	ret

000000000000052e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 52e:	4885                	li	a7,1
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <exit>:
.global exit
exit:
 li a7, SYS_exit
 536:	4889                	li	a7,2
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <wait>:
.global wait
wait:
 li a7, SYS_wait
 53e:	488d                	li	a7,3
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 546:	4891                	li	a7,4
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <read>:
.global read
read:
 li a7, SYS_read
 54e:	4895                	li	a7,5
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <write>:
.global write
write:
 li a7, SYS_write
 556:	48c1                	li	a7,16
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <close>:
.global close
close:
 li a7, SYS_close
 55e:	48d5                	li	a7,21
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <kill>:
.global kill
kill:
 li a7, SYS_kill
 566:	4899                	li	a7,6
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <exec>:
.global exec
exec:
 li a7, SYS_exec
 56e:	489d                	li	a7,7
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <open>:
.global open
open:
 li a7, SYS_open
 576:	48bd                	li	a7,15
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 57e:	48c5                	li	a7,17
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 586:	48c9                	li	a7,18
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 58e:	48a1                	li	a7,8
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <link>:
.global link
link:
 li a7, SYS_link
 596:	48cd                	li	a7,19
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 59e:	48d1                	li	a7,20
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5a6:	48a5                	li	a7,9
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ae:	48a9                	li	a7,10
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5b6:	48ad                	li	a7,11
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5be:	48b1                	li	a7,12
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5c6:	48b5                	li	a7,13
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5ce:	48b9                	li	a7,14
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <clone>:
.global clone
clone:
 li a7, SYS_clone
 5d6:	48d9                	li	a7,22
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <join>:
.global join
join:
 li a7, SYS_join
 5de:	48dd                	li	a7,23
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 5e6:	48e1                	li	a7,24
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 5ee:	48e5                	li	a7,25
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5f6:	1101                	addi	sp,sp,-32
 5f8:	ec06                	sd	ra,24(sp)
 5fa:	e822                	sd	s0,16(sp)
 5fc:	1000                	addi	s0,sp,32
 5fe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 602:	4605                	li	a2,1
 604:	fef40593          	addi	a1,s0,-17
 608:	f4fff0ef          	jal	556 <write>
}
 60c:	60e2                	ld	ra,24(sp)
 60e:	6442                	ld	s0,16(sp)
 610:	6105                	addi	sp,sp,32
 612:	8082                	ret

0000000000000614 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 614:	715d                	addi	sp,sp,-80
 616:	e486                	sd	ra,72(sp)
 618:	e0a2                	sd	s0,64(sp)
 61a:	fc26                	sd	s1,56(sp)
 61c:	f84a                	sd	s2,48(sp)
 61e:	f44e                	sd	s3,40(sp)
 620:	0880                	addi	s0,sp,80
 622:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 624:	c299                	beqz	a3,62a <printint+0x16>
 626:	0605cc63          	bltz	a1,69e <printint+0x8a>
  neg = 0;
 62a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 62c:	fb840313          	addi	t1,s0,-72
  neg = 0;
 630:	869a                	mv	a3,t1
  i = 0;
 632:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 634:	00000817          	auipc	a6,0x0
 638:	53c80813          	addi	a6,a6,1340 # b70 <digits>
 63c:	88be                	mv	a7,a5
 63e:	0017851b          	addiw	a0,a5,1
 642:	87aa                	mv	a5,a0
 644:	02c5f733          	remu	a4,a1,a2
 648:	9742                	add	a4,a4,a6
 64a:	00074703          	lbu	a4,0(a4)
 64e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 652:	872e                	mv	a4,a1
 654:	02c5d5b3          	divu	a1,a1,a2
 658:	0685                	addi	a3,a3,1
 65a:	fec771e3          	bgeu	a4,a2,63c <printint+0x28>
  if(neg)
 65e:	000e0c63          	beqz	t3,676 <printint+0x62>
    buf[i++] = '-';
 662:	fd050793          	addi	a5,a0,-48
 666:	00878533          	add	a0,a5,s0
 66a:	02d00793          	li	a5,45
 66e:	fef50423          	sb	a5,-24(a0)
 672:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 676:	fff7899b          	addiw	s3,a5,-1
 67a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 67e:	fff4c583          	lbu	a1,-1(s1)
 682:	854a                	mv	a0,s2
 684:	f73ff0ef          	jal	5f6 <putc>
  while(--i >= 0)
 688:	39fd                	addiw	s3,s3,-1
 68a:	14fd                	addi	s1,s1,-1
 68c:	fe09d9e3          	bgez	s3,67e <printint+0x6a>
}
 690:	60a6                	ld	ra,72(sp)
 692:	6406                	ld	s0,64(sp)
 694:	74e2                	ld	s1,56(sp)
 696:	7942                	ld	s2,48(sp)
 698:	79a2                	ld	s3,40(sp)
 69a:	6161                	addi	sp,sp,80
 69c:	8082                	ret
    x = -xx;
 69e:	40b005b3          	neg	a1,a1
    neg = 1;
 6a2:	4e05                	li	t3,1
    x = -xx;
 6a4:	b761                	j	62c <printint+0x18>

00000000000006a6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6a6:	711d                	addi	sp,sp,-96
 6a8:	ec86                	sd	ra,88(sp)
 6aa:	e8a2                	sd	s0,80(sp)
 6ac:	e4a6                	sd	s1,72(sp)
 6ae:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6b0:	0005c483          	lbu	s1,0(a1)
 6b4:	28048463          	beqz	s1,93c <vprintf+0x296>
 6b8:	e0ca                	sd	s2,64(sp)
 6ba:	fc4e                	sd	s3,56(sp)
 6bc:	f852                	sd	s4,48(sp)
 6be:	f456                	sd	s5,40(sp)
 6c0:	f05a                	sd	s6,32(sp)
 6c2:	ec5e                	sd	s7,24(sp)
 6c4:	e862                	sd	s8,16(sp)
 6c6:	e466                	sd	s9,8(sp)
 6c8:	8b2a                	mv	s6,a0
 6ca:	8a2e                	mv	s4,a1
 6cc:	8bb2                	mv	s7,a2
  state = 0;
 6ce:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6d0:	4901                	li	s2,0
 6d2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6d4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6d8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6dc:	06c00c93          	li	s9,108
 6e0:	a00d                	j	702 <vprintf+0x5c>
        putc(fd, c0);
 6e2:	85a6                	mv	a1,s1
 6e4:	855a                	mv	a0,s6
 6e6:	f11ff0ef          	jal	5f6 <putc>
 6ea:	a019                	j	6f0 <vprintf+0x4a>
    } else if(state == '%'){
 6ec:	03598363          	beq	s3,s5,712 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6f0:	0019079b          	addiw	a5,s2,1
 6f4:	893e                	mv	s2,a5
 6f6:	873e                	mv	a4,a5
 6f8:	97d2                	add	a5,a5,s4
 6fa:	0007c483          	lbu	s1,0(a5)
 6fe:	22048763          	beqz	s1,92c <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 702:	0004879b          	sext.w	a5,s1
    if(state == 0){
 706:	fe0993e3          	bnez	s3,6ec <vprintf+0x46>
      if(c0 == '%'){
 70a:	fd579ce3          	bne	a5,s5,6e2 <vprintf+0x3c>
        state = '%';
 70e:	89be                	mv	s3,a5
 710:	b7c5                	j	6f0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 712:	00ea06b3          	add	a3,s4,a4
 716:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 71a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 71c:	c681                	beqz	a3,724 <vprintf+0x7e>
 71e:	9752                	add	a4,a4,s4
 720:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 724:	05878263          	beq	a5,s8,768 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 728:	05978c63          	beq	a5,s9,780 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 72c:	07500713          	li	a4,117
 730:	0ee78663          	beq	a5,a4,81c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 734:	07800713          	li	a4,120
 738:	12e78863          	beq	a5,a4,868 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 73c:	07000713          	li	a4,112
 740:	14e78d63          	beq	a5,a4,89a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 744:	06300713          	li	a4,99
 748:	18e78c63          	beq	a5,a4,8e0 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 74c:	07300713          	li	a4,115
 750:	1ae78263          	beq	a5,a4,8f4 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 754:	02500713          	li	a4,37
 758:	04e79463          	bne	a5,a4,7a0 <vprintf+0xfa>
        putc(fd, '%');
 75c:	85ba                	mv	a1,a4
 75e:	855a                	mv	a0,s6
 760:	e97ff0ef          	jal	5f6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 764:	4981                	li	s3,0
 766:	b769                	j	6f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 768:	008b8493          	addi	s1,s7,8
 76c:	4685                	li	a3,1
 76e:	4629                	li	a2,10
 770:	000ba583          	lw	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	e9fff0ef          	jal	614 <printint>
 77a:	8ba6                	mv	s7,s1
      state = 0;
 77c:	4981                	li	s3,0
 77e:	bf8d                	j	6f0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 780:	06400793          	li	a5,100
 784:	02f68963          	beq	a3,a5,7b6 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 788:	06c00793          	li	a5,108
 78c:	04f68263          	beq	a3,a5,7d0 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 790:	07500793          	li	a5,117
 794:	0af68063          	beq	a3,a5,834 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 798:	07800793          	li	a5,120
 79c:	0ef68263          	beq	a3,a5,880 <vprintf+0x1da>
        putc(fd, '%');
 7a0:	02500593          	li	a1,37
 7a4:	855a                	mv	a0,s6
 7a6:	e51ff0ef          	jal	5f6 <putc>
        putc(fd, c0);
 7aa:	85a6                	mv	a1,s1
 7ac:	855a                	mv	a0,s6
 7ae:	e49ff0ef          	jal	5f6 <putc>
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	bf35                	j	6f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b6:	008b8493          	addi	s1,s7,8
 7ba:	4685                	li	a3,1
 7bc:	4629                	li	a2,10
 7be:	000bb583          	ld	a1,0(s7)
 7c2:	855a                	mv	a0,s6
 7c4:	e51ff0ef          	jal	614 <printint>
        i += 1;
 7c8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ca:	8ba6                	mv	s7,s1
      state = 0;
 7cc:	4981                	li	s3,0
        i += 1;
 7ce:	b70d                	j	6f0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7d0:	06400793          	li	a5,100
 7d4:	02f60763          	beq	a2,a5,802 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7d8:	07500793          	li	a5,117
 7dc:	06f60963          	beq	a2,a5,84e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7e0:	07800793          	li	a5,120
 7e4:	faf61ee3          	bne	a2,a5,7a0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e8:	008b8493          	addi	s1,s7,8
 7ec:	4681                	li	a3,0
 7ee:	4641                	li	a2,16
 7f0:	000bb583          	ld	a1,0(s7)
 7f4:	855a                	mv	a0,s6
 7f6:	e1fff0ef          	jal	614 <printint>
        i += 2;
 7fa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7fc:	8ba6                	mv	s7,s1
      state = 0;
 7fe:	4981                	li	s3,0
        i += 2;
 800:	bdc5                	j	6f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 802:	008b8493          	addi	s1,s7,8
 806:	4685                	li	a3,1
 808:	4629                	li	a2,10
 80a:	000bb583          	ld	a1,0(s7)
 80e:	855a                	mv	a0,s6
 810:	e05ff0ef          	jal	614 <printint>
        i += 2;
 814:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 816:	8ba6                	mv	s7,s1
      state = 0;
 818:	4981                	li	s3,0
        i += 2;
 81a:	bdd9                	j	6f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 81c:	008b8493          	addi	s1,s7,8
 820:	4681                	li	a3,0
 822:	4629                	li	a2,10
 824:	000be583          	lwu	a1,0(s7)
 828:	855a                	mv	a0,s6
 82a:	debff0ef          	jal	614 <printint>
 82e:	8ba6                	mv	s7,s1
      state = 0;
 830:	4981                	li	s3,0
 832:	bd7d                	j	6f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 834:	008b8493          	addi	s1,s7,8
 838:	4681                	li	a3,0
 83a:	4629                	li	a2,10
 83c:	000bb583          	ld	a1,0(s7)
 840:	855a                	mv	a0,s6
 842:	dd3ff0ef          	jal	614 <printint>
        i += 1;
 846:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 848:	8ba6                	mv	s7,s1
      state = 0;
 84a:	4981                	li	s3,0
        i += 1;
 84c:	b555                	j	6f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 84e:	008b8493          	addi	s1,s7,8
 852:	4681                	li	a3,0
 854:	4629                	li	a2,10
 856:	000bb583          	ld	a1,0(s7)
 85a:	855a                	mv	a0,s6
 85c:	db9ff0ef          	jal	614 <printint>
        i += 2;
 860:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 862:	8ba6                	mv	s7,s1
      state = 0;
 864:	4981                	li	s3,0
        i += 2;
 866:	b569                	j	6f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 868:	008b8493          	addi	s1,s7,8
 86c:	4681                	li	a3,0
 86e:	4641                	li	a2,16
 870:	000be583          	lwu	a1,0(s7)
 874:	855a                	mv	a0,s6
 876:	d9fff0ef          	jal	614 <printint>
 87a:	8ba6                	mv	s7,s1
      state = 0;
 87c:	4981                	li	s3,0
 87e:	bd8d                	j	6f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 880:	008b8493          	addi	s1,s7,8
 884:	4681                	li	a3,0
 886:	4641                	li	a2,16
 888:	000bb583          	ld	a1,0(s7)
 88c:	855a                	mv	a0,s6
 88e:	d87ff0ef          	jal	614 <printint>
        i += 1;
 892:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 894:	8ba6                	mv	s7,s1
      state = 0;
 896:	4981                	li	s3,0
        i += 1;
 898:	bda1                	j	6f0 <vprintf+0x4a>
 89a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 89c:	008b8d13          	addi	s10,s7,8
 8a0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8a4:	03000593          	li	a1,48
 8a8:	855a                	mv	a0,s6
 8aa:	d4dff0ef          	jal	5f6 <putc>
  putc(fd, 'x');
 8ae:	07800593          	li	a1,120
 8b2:	855a                	mv	a0,s6
 8b4:	d43ff0ef          	jal	5f6 <putc>
 8b8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8ba:	00000b97          	auipc	s7,0x0
 8be:	2b6b8b93          	addi	s7,s7,694 # b70 <digits>
 8c2:	03c9d793          	srli	a5,s3,0x3c
 8c6:	97de                	add	a5,a5,s7
 8c8:	0007c583          	lbu	a1,0(a5)
 8cc:	855a                	mv	a0,s6
 8ce:	d29ff0ef          	jal	5f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8d2:	0992                	slli	s3,s3,0x4
 8d4:	34fd                	addiw	s1,s1,-1
 8d6:	f4f5                	bnez	s1,8c2 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 8d8:	8bea                	mv	s7,s10
      state = 0;
 8da:	4981                	li	s3,0
 8dc:	6d02                	ld	s10,0(sp)
 8de:	bd09                	j	6f0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 8e0:	008b8493          	addi	s1,s7,8
 8e4:	000bc583          	lbu	a1,0(s7)
 8e8:	855a                	mv	a0,s6
 8ea:	d0dff0ef          	jal	5f6 <putc>
 8ee:	8ba6                	mv	s7,s1
      state = 0;
 8f0:	4981                	li	s3,0
 8f2:	bbfd                	j	6f0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8f4:	008b8993          	addi	s3,s7,8
 8f8:	000bb483          	ld	s1,0(s7)
 8fc:	cc91                	beqz	s1,918 <vprintf+0x272>
        for(; *s; s++)
 8fe:	0004c583          	lbu	a1,0(s1)
 902:	c195                	beqz	a1,926 <vprintf+0x280>
          putc(fd, *s);
 904:	855a                	mv	a0,s6
 906:	cf1ff0ef          	jal	5f6 <putc>
        for(; *s; s++)
 90a:	0485                	addi	s1,s1,1
 90c:	0004c583          	lbu	a1,0(s1)
 910:	f9f5                	bnez	a1,904 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 912:	8bce                	mv	s7,s3
      state = 0;
 914:	4981                	li	s3,0
 916:	bbe9                	j	6f0 <vprintf+0x4a>
          s = "(null)";
 918:	00000497          	auipc	s1,0x0
 91c:	25048493          	addi	s1,s1,592 # b68 <malloc+0x140>
        for(; *s; s++)
 920:	02800593          	li	a1,40
 924:	b7c5                	j	904 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 926:	8bce                	mv	s7,s3
      state = 0;
 928:	4981                	li	s3,0
 92a:	b3d9                	j	6f0 <vprintf+0x4a>
 92c:	6906                	ld	s2,64(sp)
 92e:	79e2                	ld	s3,56(sp)
 930:	7a42                	ld	s4,48(sp)
 932:	7aa2                	ld	s5,40(sp)
 934:	7b02                	ld	s6,32(sp)
 936:	6be2                	ld	s7,24(sp)
 938:	6c42                	ld	s8,16(sp)
 93a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 93c:	60e6                	ld	ra,88(sp)
 93e:	6446                	ld	s0,80(sp)
 940:	64a6                	ld	s1,72(sp)
 942:	6125                	addi	sp,sp,96
 944:	8082                	ret

0000000000000946 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 946:	715d                	addi	sp,sp,-80
 948:	ec06                	sd	ra,24(sp)
 94a:	e822                	sd	s0,16(sp)
 94c:	1000                	addi	s0,sp,32
 94e:	e010                	sd	a2,0(s0)
 950:	e414                	sd	a3,8(s0)
 952:	e818                	sd	a4,16(s0)
 954:	ec1c                	sd	a5,24(s0)
 956:	03043023          	sd	a6,32(s0)
 95a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 95e:	8622                	mv	a2,s0
 960:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 964:	d43ff0ef          	jal	6a6 <vprintf>
}
 968:	60e2                	ld	ra,24(sp)
 96a:	6442                	ld	s0,16(sp)
 96c:	6161                	addi	sp,sp,80
 96e:	8082                	ret

0000000000000970 <printf>:

void
printf(const char *fmt, ...)
{
 970:	711d                	addi	sp,sp,-96
 972:	ec06                	sd	ra,24(sp)
 974:	e822                	sd	s0,16(sp)
 976:	1000                	addi	s0,sp,32
 978:	e40c                	sd	a1,8(s0)
 97a:	e810                	sd	a2,16(s0)
 97c:	ec14                	sd	a3,24(s0)
 97e:	f018                	sd	a4,32(s0)
 980:	f41c                	sd	a5,40(s0)
 982:	03043823          	sd	a6,48(s0)
 986:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 98a:	00840613          	addi	a2,s0,8
 98e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 992:	85aa                	mv	a1,a0
 994:	4505                	li	a0,1
 996:	d11ff0ef          	jal	6a6 <vprintf>
}
 99a:	60e2                	ld	ra,24(sp)
 99c:	6442                	ld	s0,16(sp)
 99e:	6125                	addi	sp,sp,96
 9a0:	8082                	ret

00000000000009a2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9a2:	1141                	addi	sp,sp,-16
 9a4:	e406                	sd	ra,8(sp)
 9a6:	e022                	sd	s0,0(sp)
 9a8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9aa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ae:	00000797          	auipc	a5,0x0
 9b2:	6527b783          	ld	a5,1618(a5) # 1000 <freep>
 9b6:	a02d                	j	9e0 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9b8:	4618                	lw	a4,8(a2)
 9ba:	9f2d                	addw	a4,a4,a1
 9bc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9c0:	6398                	ld	a4,0(a5)
 9c2:	6310                	ld	a2,0(a4)
 9c4:	a83d                	j	a02 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9c6:	ff852703          	lw	a4,-8(a0)
 9ca:	9f31                	addw	a4,a4,a2
 9cc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9ce:	ff053683          	ld	a3,-16(a0)
 9d2:	a091                	j	a16 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d4:	6398                	ld	a4,0(a5)
 9d6:	00e7e463          	bltu	a5,a4,9de <free+0x3c>
 9da:	00e6ea63          	bltu	a3,a4,9ee <free+0x4c>
{
 9de:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9e0:	fed7fae3          	bgeu	a5,a3,9d4 <free+0x32>
 9e4:	6398                	ld	a4,0(a5)
 9e6:	00e6e463          	bltu	a3,a4,9ee <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ea:	fee7eae3          	bltu	a5,a4,9de <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9ee:	ff852583          	lw	a1,-8(a0)
 9f2:	6390                	ld	a2,0(a5)
 9f4:	02059813          	slli	a6,a1,0x20
 9f8:	01c85713          	srli	a4,a6,0x1c
 9fc:	9736                	add	a4,a4,a3
 9fe:	fae60de3          	beq	a2,a4,9b8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a02:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a06:	4790                	lw	a2,8(a5)
 a08:	02061593          	slli	a1,a2,0x20
 a0c:	01c5d713          	srli	a4,a1,0x1c
 a10:	973e                	add	a4,a4,a5
 a12:	fae68ae3          	beq	a3,a4,9c6 <free+0x24>
    p->s.ptr = bp->s.ptr;
 a16:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a18:	00000717          	auipc	a4,0x0
 a1c:	5ef73423          	sd	a5,1512(a4) # 1000 <freep>
}
 a20:	60a2                	ld	ra,8(sp)
 a22:	6402                	ld	s0,0(sp)
 a24:	0141                	addi	sp,sp,16
 a26:	8082                	ret

0000000000000a28 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a28:	7139                	addi	sp,sp,-64
 a2a:	fc06                	sd	ra,56(sp)
 a2c:	f822                	sd	s0,48(sp)
 a2e:	f04a                	sd	s2,32(sp)
 a30:	ec4e                	sd	s3,24(sp)
 a32:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a34:	02051993          	slli	s3,a0,0x20
 a38:	0209d993          	srli	s3,s3,0x20
 a3c:	09bd                	addi	s3,s3,15
 a3e:	0049d993          	srli	s3,s3,0x4
 a42:	2985                	addiw	s3,s3,1
 a44:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a46:	00000517          	auipc	a0,0x0
 a4a:	5ba53503          	ld	a0,1466(a0) # 1000 <freep>
 a4e:	c905                	beqz	a0,a7e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a50:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a52:	4798                	lw	a4,8(a5)
 a54:	09377663          	bgeu	a4,s3,ae0 <malloc+0xb8>
 a58:	f426                	sd	s1,40(sp)
 a5a:	e852                	sd	s4,16(sp)
 a5c:	e456                	sd	s5,8(sp)
 a5e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a60:	8a4e                	mv	s4,s3
 a62:	6705                	lui	a4,0x1
 a64:	00e9f363          	bgeu	s3,a4,a6a <malloc+0x42>
 a68:	6a05                	lui	s4,0x1
 a6a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a6e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a72:	00000497          	auipc	s1,0x0
 a76:	58e48493          	addi	s1,s1,1422 # 1000 <freep>
  if(p == SBRK_ERROR)
 a7a:	5afd                	li	s5,-1
 a7c:	a83d                	j	aba <malloc+0x92>
 a7e:	f426                	sd	s1,40(sp)
 a80:	e852                	sd	s4,16(sp)
 a82:	e456                	sd	s5,8(sp)
 a84:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a86:	00000797          	auipc	a5,0x0
 a8a:	78a78793          	addi	a5,a5,1930 # 1210 <base>
 a8e:	00000717          	auipc	a4,0x0
 a92:	56f73923          	sd	a5,1394(a4) # 1000 <freep>
 a96:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a98:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a9c:	b7d1                	j	a60 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a9e:	6398                	ld	a4,0(a5)
 aa0:	e118                	sd	a4,0(a0)
 aa2:	a899                	j	af8 <malloc+0xd0>
  hp->s.size = nu;
 aa4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 aa8:	0541                	addi	a0,a0,16
 aaa:	ef9ff0ef          	jal	9a2 <free>
  return freep;
 aae:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 ab0:	c125                	beqz	a0,b10 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ab4:	4798                	lw	a4,8(a5)
 ab6:	03277163          	bgeu	a4,s2,ad8 <malloc+0xb0>
    if(p == freep)
 aba:	6098                	ld	a4,0(s1)
 abc:	853e                	mv	a0,a5
 abe:	fef71ae3          	bne	a4,a5,ab2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ac2:	8552                	mv	a0,s4
 ac4:	8c7ff0ef          	jal	38a <sbrk>
  if(p == SBRK_ERROR)
 ac8:	fd551ee3          	bne	a0,s5,aa4 <malloc+0x7c>
        return 0;
 acc:	4501                	li	a0,0
 ace:	74a2                	ld	s1,40(sp)
 ad0:	6a42                	ld	s4,16(sp)
 ad2:	6aa2                	ld	s5,8(sp)
 ad4:	6b02                	ld	s6,0(sp)
 ad6:	a03d                	j	b04 <malloc+0xdc>
 ad8:	74a2                	ld	s1,40(sp)
 ada:	6a42                	ld	s4,16(sp)
 adc:	6aa2                	ld	s5,8(sp)
 ade:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ae0:	fae90fe3          	beq	s2,a4,a9e <malloc+0x76>
        p->s.size -= nunits;
 ae4:	4137073b          	subw	a4,a4,s3
 ae8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aea:	02071693          	slli	a3,a4,0x20
 aee:	01c6d713          	srli	a4,a3,0x1c
 af2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 af4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 af8:	00000717          	auipc	a4,0x0
 afc:	50a73423          	sd	a0,1288(a4) # 1000 <freep>
      return (void*)(p + 1);
 b00:	01078513          	addi	a0,a5,16
  }
}
 b04:	70e2                	ld	ra,56(sp)
 b06:	7442                	ld	s0,48(sp)
 b08:	7902                	ld	s2,32(sp)
 b0a:	69e2                	ld	s3,24(sp)
 b0c:	6121                	addi	sp,sp,64
 b0e:	8082                	ret
 b10:	74a2                	ld	s1,40(sp)
 b12:	6a42                	ld	s4,16(sp)
 b14:	6aa2                	ld	s5,8(sp)
 b16:	6b02                	ld	s6,0(sp)
 b18:	b7f5                	j	b04 <malloc+0xdc>
