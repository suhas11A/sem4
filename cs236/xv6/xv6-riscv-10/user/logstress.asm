
user/_logstress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
main(int argc, char **argv)
{
  int fd, n;
  enum { N = 250, SZ=2000 };
  
  for (int i = 1; i < argc; i++){
   0:	4785                	li	a5,1
   2:	0ea7de63          	bge	a5,a0,fe <main+0xfe>
{
   6:	7139                	addi	sp,sp,-64
   8:	fc06                	sd	ra,56(sp)
   a:	f822                	sd	s0,48(sp)
   c:	f426                	sd	s1,40(sp)
   e:	f04a                	sd	s2,32(sp)
  10:	ec4e                	sd	s3,24(sp)
  12:	e852                	sd	s4,16(sp)
  14:	0080                	addi	s0,sp,64
  16:	892a                	mv	s2,a0
  18:	8a2e                	mv	s4,a1
  for (int i = 1; i < argc; i++){
  1a:	84be                	mv	s1,a5
  1c:	a011                	j	20 <main+0x20>
  1e:	84be                	mv	s1,a5
    int pid1 = fork();
  20:	51a000ef          	jal	53a <fork>
    if(pid1 < 0){
  24:	00054b63          	bltz	a0,3a <main+0x3a>
      printf("%s: fork failed\n", argv[0]);
      exit(1);
    }
    if(pid1 == 0) {
  28:	c505                	beqz	a0,50 <main+0x50>
  for (int i = 1; i < argc; i++){
  2a:	0014879b          	addiw	a5,s1,1
  2e:	fef918e3          	bne	s2,a5,1e <main+0x1e>
      }
      exit(0);
    }
  }
  int xstatus;
  for(int i = 1; i < argc; i++){
  32:	4905                	li	s2,1
    wait(&xstatus);
  34:	fcc40993          	addi	s3,s0,-52
  38:	a871                	j	d4 <main+0xd4>
      printf("%s: fork failed\n", argv[0]);
  3a:	000a3583          	ld	a1,0(s4)
  3e:	00001517          	auipc	a0,0x1
  42:	af250513          	addi	a0,a0,-1294 # b30 <malloc+0xfc>
  46:	137000ef          	jal	97c <printf>
      exit(1);
  4a:	4505                	li	a0,1
  4c:	4f6000ef          	jal	542 <exit>
      fd = open(argv[i], O_CREATE | O_RDWR);
  50:	00349913          	slli	s2,s1,0x3
  54:	9952                	add	s2,s2,s4
  56:	20200593          	li	a1,514
  5a:	00093503          	ld	a0,0(s2)
  5e:	524000ef          	jal	582 <open>
  62:	89aa                	mv	s3,a0
      if(fd < 0){
  64:	04054063          	bltz	a0,a4 <main+0xa4>
      memset(buf, '0'+i, SZ);
  68:	7d000613          	li	a2,2000
  6c:	0304859b          	addiw	a1,s1,48
  70:	00001517          	auipc	a0,0x1
  74:	fa050513          	addi	a0,a0,-96 # 1010 <buf>
  78:	118000ef          	jal	190 <memset>
  7c:	0fa00493          	li	s1,250
        if((n = write(fd, buf, SZ)) != SZ){
  80:	00001a17          	auipc	s4,0x1
  84:	f90a0a13          	addi	s4,s4,-112 # 1010 <buf>
  88:	7d000913          	li	s2,2000
  8c:	864a                	mv	a2,s2
  8e:	85d2                	mv	a1,s4
  90:	854e                	mv	a0,s3
  92:	4d0000ef          	jal	562 <write>
  96:	03251463          	bne	a0,s2,be <main+0xbe>
      for(i = 0; i < N; i++){
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f8e5                	bnez	s1,8c <main+0x8c>
      exit(0);
  9e:	4501                	li	a0,0
  a0:	4a2000ef          	jal	542 <exit>
        printf("%s: create %s failed\n", argv[0], argv[i]);
  a4:	00093603          	ld	a2,0(s2)
  a8:	000a3583          	ld	a1,0(s4)
  ac:	00001517          	auipc	a0,0x1
  b0:	a9c50513          	addi	a0,a0,-1380 # b48 <malloc+0x114>
  b4:	0c9000ef          	jal	97c <printf>
        exit(1);
  b8:	4505                	li	a0,1
  ba:	488000ef          	jal	542 <exit>
          printf("write failed %d\n", n);
  be:	85aa                	mv	a1,a0
  c0:	00001517          	auipc	a0,0x1
  c4:	aa050513          	addi	a0,a0,-1376 # b60 <malloc+0x12c>
  c8:	0b5000ef          	jal	97c <printf>
          exit(1);
  cc:	4505                	li	a0,1
  ce:	474000ef          	jal	542 <exit>
  d2:	893e                	mv	s2,a5
    wait(&xstatus);
  d4:	854e                	mv	a0,s3
  d6:	474000ef          	jal	54a <wait>
    if(xstatus != 0)
  da:	fcc42503          	lw	a0,-52(s0)
  de:	ed11                	bnez	a0,fa <main+0xfa>
  for(int i = 1; i < argc; i++){
  e0:	0019079b          	addiw	a5,s2,1
  e4:	ff2497e3          	bne	s1,s2,d2 <main+0xd2>
      exit(xstatus);
  }
  return 0;
}
  e8:	4501                	li	a0,0
  ea:	70e2                	ld	ra,56(sp)
  ec:	7442                	ld	s0,48(sp)
  ee:	74a2                	ld	s1,40(sp)
  f0:	7902                	ld	s2,32(sp)
  f2:	69e2                	ld	s3,24(sp)
  f4:	6a42                	ld	s4,16(sp)
  f6:	6121                	addi	sp,sp,64
  f8:	8082                	ret
      exit(xstatus);
  fa:	448000ef          	jal	542 <exit>
}
  fe:	4501                	li	a0,0
 100:	8082                	ret

0000000000000102 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 10a:	ef7ff0ef          	jal	0 <main>
  exit(r);
 10e:	434000ef          	jal	542 <exit>

0000000000000112 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11a:	87aa                	mv	a5,a0
 11c:	0585                	addi	a1,a1,1
 11e:	0785                	addi	a5,a5,1
 120:	fff5c703          	lbu	a4,-1(a1)
 124:	fee78fa3          	sb	a4,-1(a5)
 128:	fb75                	bnez	a4,11c <strcpy+0xa>
    ;
  return os;
}
 12a:	60a2                	ld	ra,8(sp)
 12c:	6402                	ld	s0,0(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 132:	1141                	addi	sp,sp,-16
 134:	e406                	sd	ra,8(sp)
 136:	e022                	sd	s0,0(sp)
 138:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cb91                	beqz	a5,152 <strcmp+0x20>
 140:	0005c703          	lbu	a4,0(a1)
 144:	00f71763          	bne	a4,a5,152 <strcmp+0x20>
    p++, q++;
 148:	0505                	addi	a0,a0,1
 14a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 14c:	00054783          	lbu	a5,0(a0)
 150:	fbe5                	bnez	a5,140 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 152:	0005c503          	lbu	a0,0(a1)
}
 156:	40a7853b          	subw	a0,a5,a0
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strlen>:

uint
strlen(const char *s)
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cf99                	beqz	a5,18c <strlen+0x2a>
 170:	0505                	addi	a0,a0,1
 172:	87aa                	mv	a5,a0
 174:	86be                	mv	a3,a5
 176:	0785                	addi	a5,a5,1
 178:	fff7c703          	lbu	a4,-1(a5)
 17c:	ff65                	bnez	a4,174 <strlen+0x12>
 17e:	40a6853b          	subw	a0,a3,a0
 182:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 184:	60a2                	ld	ra,8(sp)
 186:	6402                	ld	s0,0(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for(n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfdd                	j	184 <strlen+0x22>

0000000000000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 198:	ca19                	beqz	a2,1ae <memset+0x1e>
 19a:	87aa                	mv	a5,a0
 19c:	1602                	slli	a2,a2,0x20
 19e:	9201                	srli	a2,a2,0x20
 1a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a8:	0785                	addi	a5,a5,1
 1aa:	fee79de3          	bne	a5,a4,1a4 <memset+0x14>
  }
  return dst;
}
 1ae:	60a2                	ld	ra,8(sp)
 1b0:	6402                	ld	s0,0(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strchr>:

char*
strchr(const char *s, char c)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e406                	sd	ra,8(sp)
 1ba:	e022                	sd	s0,0(sp)
 1bc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	cf81                	beqz	a5,1da <strchr+0x24>
    if(*s == c)
 1c4:	00f58763          	beq	a1,a5,1d2 <strchr+0x1c>
  for(; *s; s++)
 1c8:	0505                	addi	a0,a0,1
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbfd                	bnez	a5,1c4 <strchr+0xe>
      return (char*)s;
  return 0;
 1d0:	4501                	li	a0,0
}
 1d2:	60a2                	ld	ra,8(sp)
 1d4:	6402                	ld	s0,0(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfdd                	j	1d2 <strchr+0x1c>

00000000000001de <gets>:

char*
gets(char *buf, int max)
{
 1de:	7159                	addi	sp,sp,-112
 1e0:	f486                	sd	ra,104(sp)
 1e2:	f0a2                	sd	s0,96(sp)
 1e4:	eca6                	sd	s1,88(sp)
 1e6:	e8ca                	sd	s2,80(sp)
 1e8:	e4ce                	sd	s3,72(sp)
 1ea:	e0d2                	sd	s4,64(sp)
 1ec:	fc56                	sd	s5,56(sp)
 1ee:	f85a                	sd	s6,48(sp)
 1f0:	f45e                	sd	s7,40(sp)
 1f2:	f062                	sd	s8,32(sp)
 1f4:	ec66                	sd	s9,24(sp)
 1f6:	e86a                	sd	s10,16(sp)
 1f8:	1880                	addi	s0,sp,112
 1fa:	8caa                	mv	s9,a0
 1fc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fe:	892a                	mv	s2,a0
 200:	4481                	li	s1,0
    cc = read(0, &c, 1);
 202:	f9f40b13          	addi	s6,s0,-97
 206:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 208:	4ba9                	li	s7,10
 20a:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 20c:	8d26                	mv	s10,s1
 20e:	0014899b          	addiw	s3,s1,1
 212:	84ce                	mv	s1,s3
 214:	0349d563          	bge	s3,s4,23e <gets+0x60>
    cc = read(0, &c, 1);
 218:	8656                	mv	a2,s5
 21a:	85da                	mv	a1,s6
 21c:	4501                	li	a0,0
 21e:	33c000ef          	jal	55a <read>
    if(cc < 1)
 222:	00a05e63          	blez	a0,23e <gets+0x60>
    buf[i++] = c;
 226:	f9f44783          	lbu	a5,-97(s0)
 22a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 22e:	01778763          	beq	a5,s7,23c <gets+0x5e>
 232:	0905                	addi	s2,s2,1
 234:	fd879ce3          	bne	a5,s8,20c <gets+0x2e>
    buf[i++] = c;
 238:	8d4e                	mv	s10,s3
 23a:	a011                	j	23e <gets+0x60>
 23c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 23e:	9d66                	add	s10,s10,s9
 240:	000d0023          	sb	zero,0(s10)
  return buf;
}
 244:	8566                	mv	a0,s9
 246:	70a6                	ld	ra,104(sp)
 248:	7406                	ld	s0,96(sp)
 24a:	64e6                	ld	s1,88(sp)
 24c:	6946                	ld	s2,80(sp)
 24e:	69a6                	ld	s3,72(sp)
 250:	6a06                	ld	s4,64(sp)
 252:	7ae2                	ld	s5,56(sp)
 254:	7b42                	ld	s6,48(sp)
 256:	7ba2                	ld	s7,40(sp)
 258:	7c02                	ld	s8,32(sp)
 25a:	6ce2                	ld	s9,24(sp)
 25c:	6d42                	ld	s10,16(sp)
 25e:	6165                	addi	sp,sp,112
 260:	8082                	ret

0000000000000262 <stat>:

int
stat(const char *n, struct stat *st)
{
 262:	1101                	addi	sp,sp,-32
 264:	ec06                	sd	ra,24(sp)
 266:	e822                	sd	s0,16(sp)
 268:	e04a                	sd	s2,0(sp)
 26a:	1000                	addi	s0,sp,32
 26c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26e:	4581                	li	a1,0
 270:	312000ef          	jal	582 <open>
  if(fd < 0)
 274:	02054263          	bltz	a0,298 <stat+0x36>
 278:	e426                	sd	s1,8(sp)
 27a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 27c:	85ca                	mv	a1,s2
 27e:	31c000ef          	jal	59a <fstat>
 282:	892a                	mv	s2,a0
  close(fd);
 284:	8526                	mv	a0,s1
 286:	2e4000ef          	jal	56a <close>
  return r;
 28a:	64a2                	ld	s1,8(sp)
}
 28c:	854a                	mv	a0,s2
 28e:	60e2                	ld	ra,24(sp)
 290:	6442                	ld	s0,16(sp)
 292:	6902                	ld	s2,0(sp)
 294:	6105                	addi	sp,sp,32
 296:	8082                	ret
    return -1;
 298:	597d                	li	s2,-1
 29a:	bfcd                	j	28c <stat+0x2a>

000000000000029c <atoi>:

int
atoi(const char *s)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a4:	00054683          	lbu	a3,0(a0)
 2a8:	fd06879b          	addiw	a5,a3,-48
 2ac:	0ff7f793          	zext.b	a5,a5
 2b0:	4625                	li	a2,9
 2b2:	02f66963          	bltu	a2,a5,2e4 <atoi+0x48>
 2b6:	872a                	mv	a4,a0
  n = 0;
 2b8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ba:	0705                	addi	a4,a4,1
 2bc:	0025179b          	slliw	a5,a0,0x2
 2c0:	9fa9                	addw	a5,a5,a0
 2c2:	0017979b          	slliw	a5,a5,0x1
 2c6:	9fb5                	addw	a5,a5,a3
 2c8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2cc:	00074683          	lbu	a3,0(a4)
 2d0:	fd06879b          	addiw	a5,a3,-48
 2d4:	0ff7f793          	zext.b	a5,a5
 2d8:	fef671e3          	bgeu	a2,a5,2ba <atoi+0x1e>
  return n;
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  n = 0;
 2e4:	4501                	li	a0,0
 2e6:	bfdd                	j	2dc <atoi+0x40>

00000000000002e8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f0:	02b57563          	bgeu	a0,a1,31a <memmove+0x32>
    while(n-- > 0)
 2f4:	00c05f63          	blez	a2,312 <memmove+0x2a>
 2f8:	1602                	slli	a2,a2,0x20
 2fa:	9201                	srli	a2,a2,0x20
 2fc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 300:	872a                	mv	a4,a0
      *dst++ = *src++;
 302:	0585                	addi	a1,a1,1
 304:	0705                	addi	a4,a4,1
 306:	fff5c683          	lbu	a3,-1(a1)
 30a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 30e:	fee79ae3          	bne	a5,a4,302 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret
    dst += n;
 31a:	00c50733          	add	a4,a0,a2
    src += n;
 31e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 320:	fec059e3          	blez	a2,312 <memmove+0x2a>
 324:	fff6079b          	addiw	a5,a2,-1
 328:	1782                	slli	a5,a5,0x20
 32a:	9381                	srli	a5,a5,0x20
 32c:	fff7c793          	not	a5,a5
 330:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 332:	15fd                	addi	a1,a1,-1
 334:	177d                	addi	a4,a4,-1
 336:	0005c683          	lbu	a3,0(a1)
 33a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 33e:	fef71ae3          	bne	a4,a5,332 <memmove+0x4a>
 342:	bfc1                	j	312 <memmove+0x2a>

0000000000000344 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 34c:	ca0d                	beqz	a2,37e <memcmp+0x3a>
 34e:	fff6069b          	addiw	a3,a2,-1
 352:	1682                	slli	a3,a3,0x20
 354:	9281                	srli	a3,a3,0x20
 356:	0685                	addi	a3,a3,1
 358:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 35a:	00054783          	lbu	a5,0(a0)
 35e:	0005c703          	lbu	a4,0(a1)
 362:	00e79863          	bne	a5,a4,372 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 366:	0505                	addi	a0,a0,1
    p2++;
 368:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 36a:	fed518e3          	bne	a0,a3,35a <memcmp+0x16>
  }
  return 0;
 36e:	4501                	li	a0,0
 370:	a019                	j	376 <memcmp+0x32>
      return *p1 - *p2;
 372:	40e7853b          	subw	a0,a5,a4
}
 376:	60a2                	ld	ra,8(sp)
 378:	6402                	ld	s0,0(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
  return 0;
 37e:	4501                	li	a0,0
 380:	bfdd                	j	376 <memcmp+0x32>

0000000000000382 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 382:	1141                	addi	sp,sp,-16
 384:	e406                	sd	ra,8(sp)
 386:	e022                	sd	s0,0(sp)
 388:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 38a:	f5fff0ef          	jal	2e8 <memmove>
}
 38e:	60a2                	ld	ra,8(sp)
 390:	6402                	ld	s0,0(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret

0000000000000396 <sbrk>:

char *
sbrk(int n) {
 396:	1141                	addi	sp,sp,-16
 398:	e406                	sd	ra,8(sp)
 39a:	e022                	sd	s0,0(sp)
 39c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 39e:	4585                	li	a1,1
 3a0:	22a000ef          	jal	5ca <sys_sbrk>
}
 3a4:	60a2                	ld	ra,8(sp)
 3a6:	6402                	ld	s0,0(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret

00000000000003ac <sbrklazy>:

char *
sbrklazy(int n) {
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e406                	sd	ra,8(sp)
 3b0:	e022                	sd	s0,0(sp)
 3b2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3b4:	4589                	li	a1,2
 3b6:	214000ef          	jal	5ca <sys_sbrk>
}
 3ba:	60a2                	ld	ra,8(sp)
 3bc:	6402                	ld	s0,0(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret

00000000000003c2 <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 3c2:	1101                	addi	sp,sp,-32
 3c4:	ec06                	sd	ra,24(sp)
 3c6:	e822                	sd	s0,16(sp)
 3c8:	e426                	sd	s1,8(sp)
 3ca:	e04a                	sd	s2,0(sp)
 3cc:	1000                	addi	s0,sp,32
 3ce:	84aa                	mv	s1,a0
 3d0:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 3d2:	6505                	lui	a0,0x1
 3d4:	fc3ff0ef          	jal	396 <sbrk>
 3d8:	6785                	lui	a5,0x1
 3da:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 3de:	9a41                	andi	a2,a2,-16
 3e0:	85ca                	mv	a1,s2
 3e2:	8526                	mv	a0,s1
 3e4:	1fe000ef          	jal	5e2 <clone>
}
 3e8:	60e2                	ld	ra,24(sp)
 3ea:	6442                	ld	s0,16(sp)
 3ec:	64a2                	ld	s1,8(sp)
 3ee:	6902                	ld	s2,0(sp)
 3f0:	6105                	addi	sp,sp,32
 3f2:	8082                	ret

00000000000003f4 <futex>:

void futex(int *uaddr, int ops, int val) {
 3f4:	7179                	addi	sp,sp,-48
 3f6:	f406                	sd	ra,40(sp)
 3f8:	f022                	sd	s0,32(sp)
 3fa:	ec26                	sd	s1,24(sp)
 3fc:	1800                	addi	s0,sp,48
 3fe:	84aa                	mv	s1,a0
  if (ops==0) {
 400:	ed95                	bnez	a1,43c <futex+0x48>
    if (val==0) {
 402:	c611                	beqz	a2,40e <futex+0x1a>
 404:	e84a                	sd	s2,16(sp)
 406:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 408:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 40a:	4985                	li	s3,1
 40c:	a005                	j	42c <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 40e:	4705                	li	a4,1
 410:	87ba                	mv	a5,a4
 412:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 416:	2781                	sext.w	a5,a5
 418:	ffe5                	bnez	a5,410 <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 41a:	70a2                	ld	ra,40(sp)
 41c:	7402                	ld	s0,32(sp)
 41e:	64e2                	ld	s1,24(sp)
 420:	6145                	addi	sp,sp,48
 422:	8082                	ret
        futex_wait(uaddr, 1);
 424:	85ce                	mv	a1,s3
 426:	8526                	mv	a0,s1
 428:	1ca000ef          	jal	5f2 <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 42c:	87ca                	mv	a5,s2
 42e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 432:	2781                	sext.w	a5,a5
 434:	fbe5                	bnez	a5,424 <futex+0x30>
 436:	6942                	ld	s2,16(sp)
 438:	69a2                	ld	s3,8(sp)
 43a:	b7c5                	j	41a <futex+0x26>
    if (val==0) {
 43c:	e611                	bnez	a2,448 <futex+0x54>
      __sync_lock_release(uaddr);
 43e:	0310000f          	fence	rw,w
 442:	00052023          	sw	zero,0(a0) # 1000 <freep>
 446:	bfd1                	j	41a <futex+0x26>
      __sync_lock_release(uaddr);
 448:	0310000f          	fence	rw,w
 44c:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 450:	1aa000ef          	jal	5fa <futex_wake>
  return;
 454:	b7d9                	j	41a <futex+0x26>

0000000000000456 <sem_init>:

void sem_init(sem_t* s, int val) {
 456:	7179                	addi	sp,sp,-48
 458:	f406                	sd	ra,40(sp)
 45a:	f022                	sd	s0,32(sp)
 45c:	ec26                	sd	s1,24(sp)
 45e:	e84a                	sd	s2,16(sp)
 460:	e44e                	sd	s3,8(sp)
 462:	1800                	addi	s0,sp,48
 464:	84aa                	mv	s1,a0
 466:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 468:	00450993          	addi	s3,a0,4
 46c:	4605                	li	a2,1
 46e:	4581                	li	a1,0
 470:	854e                	mv	a0,s3
 472:	f83ff0ef          	jal	3f4 <futex>
  s->value = val;
 476:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 47a:	4605                	li	a2,1
 47c:	85b2                	mv	a1,a2
 47e:	854e                	mv	a0,s3
 480:	f75ff0ef          	jal	3f4 <futex>
  return;
}
 484:	70a2                	ld	ra,40(sp)
 486:	7402                	ld	s0,32(sp)
 488:	64e2                	ld	s1,24(sp)
 48a:	6942                	ld	s2,16(sp)
 48c:	69a2                	ld	s3,8(sp)
 48e:	6145                	addi	sp,sp,48
 490:	8082                	ret

0000000000000492 <sem_down>:

void sem_down(sem_t* s) {
 492:	7179                	addi	sp,sp,-48
 494:	f406                	sd	ra,40(sp)
 496:	f022                	sd	s0,32(sp)
 498:	ec26                	sd	s1,24(sp)
 49a:	e84a                	sd	s2,16(sp)
 49c:	e44e                	sd	s3,8(sp)
 49e:	1800                	addi	s0,sp,48
 4a0:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 4a2:	00450993          	addi	s3,a0,4
 4a6:	4605                	li	a2,1
 4a8:	4581                	li	a1,0
 4aa:	854e                	mv	a0,s3
 4ac:	f49ff0ef          	jal	3f4 <futex>
  while(1) {
    if (s->value>0) {
 4b0:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 4b4:	4485                	li	s1,1
    if (s->value>0) {
 4b6:	02f04463          	bgtz	a5,4de <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 4ba:	8626                	mv	a2,s1
 4bc:	85a6                	mv	a1,s1
 4be:	854e                	mv	a0,s3
 4c0:	f35ff0ef          	jal	3f4 <futex>
      futex_wait(&s->value,1);
 4c4:	85a6                	mv	a1,s1
 4c6:	854a                	mv	a0,s2
 4c8:	12a000ef          	jal	5f2 <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 4cc:	8626                	mv	a2,s1
 4ce:	4581                	li	a1,0
 4d0:	854e                	mv	a0,s3
 4d2:	f23ff0ef          	jal	3f4 <futex>
    if (s->value>0) {
 4d6:	00092783          	lw	a5,0(s2)
 4da:	fef050e3          	blez	a5,4ba <sem_down+0x28>
      s->value--;
 4de:	37fd                	addiw	a5,a5,-1 # fff <digits+0x47f>
 4e0:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4e4:	4605                	li	a2,1
 4e6:	85b2                	mv	a1,a2
 4e8:	854e                	mv	a0,s3
 4ea:	f0bff0ef          	jal	3f4 <futex>
  return;
}
 4ee:	70a2                	ld	ra,40(sp)
 4f0:	7402                	ld	s0,32(sp)
 4f2:	64e2                	ld	s1,24(sp)
 4f4:	6942                	ld	s2,16(sp)
 4f6:	69a2                	ld	s3,8(sp)
 4f8:	6145                	addi	sp,sp,48
 4fa:	8082                	ret

00000000000004fc <sem_up>:

void sem_up(sem_t* s) {
 4fc:	1101                	addi	sp,sp,-32
 4fe:	ec06                	sd	ra,24(sp)
 500:	e822                	sd	s0,16(sp)
 502:	e426                	sd	s1,8(sp)
 504:	e04a                	sd	s2,0(sp)
 506:	1000                	addi	s0,sp,32
 508:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 50a:	00450913          	addi	s2,a0,4
 50e:	4605                	li	a2,1
 510:	4581                	li	a1,0
 512:	854a                	mv	a0,s2
 514:	ee1ff0ef          	jal	3f4 <futex>
  s->value++;
 518:	409c                	lw	a5,0(s1)
 51a:	2785                	addiw	a5,a5,1
 51c:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 51e:	8526                	mv	a0,s1
 520:	0da000ef          	jal	5fa <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 524:	4605                	li	a2,1
 526:	85b2                	mv	a1,a2
 528:	854a                	mv	a0,s2
 52a:	ecbff0ef          	jal	3f4 <futex>
  return;
 52e:	60e2                	ld	ra,24(sp)
 530:	6442                	ld	s0,16(sp)
 532:	64a2                	ld	s1,8(sp)
 534:	6902                	ld	s2,0(sp)
 536:	6105                	addi	sp,sp,32
 538:	8082                	ret

000000000000053a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 53a:	4885                	li	a7,1
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <exit>:
.global exit
exit:
 li a7, SYS_exit
 542:	4889                	li	a7,2
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <wait>:
.global wait
wait:
 li a7, SYS_wait
 54a:	488d                	li	a7,3
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 552:	4891                	li	a7,4
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <read>:
.global read
read:
 li a7, SYS_read
 55a:	4895                	li	a7,5
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <write>:
.global write
write:
 li a7, SYS_write
 562:	48c1                	li	a7,16
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <close>:
.global close
close:
 li a7, SYS_close
 56a:	48d5                	li	a7,21
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <kill>:
.global kill
kill:
 li a7, SYS_kill
 572:	4899                	li	a7,6
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <exec>:
.global exec
exec:
 li a7, SYS_exec
 57a:	489d                	li	a7,7
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <open>:
.global open
open:
 li a7, SYS_open
 582:	48bd                	li	a7,15
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 58a:	48c5                	li	a7,17
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 592:	48c9                	li	a7,18
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 59a:	48a1                	li	a7,8
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <link>:
.global link
link:
 li a7, SYS_link
 5a2:	48cd                	li	a7,19
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5aa:	48d1                	li	a7,20
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5b2:	48a5                	li	a7,9
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ba:	48a9                	li	a7,10
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5c2:	48ad                	li	a7,11
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5ca:	48b1                	li	a7,12
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5d2:	48b5                	li	a7,13
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5da:	48b9                	li	a7,14
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <clone>:
.global clone
clone:
 li a7, SYS_clone
 5e2:	48d9                	li	a7,22
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <join>:
.global join
join:
 li a7, SYS_join
 5ea:	48dd                	li	a7,23
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 5f2:	48e1                	li	a7,24
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 5fa:	48e5                	li	a7,25
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 602:	1101                	addi	sp,sp,-32
 604:	ec06                	sd	ra,24(sp)
 606:	e822                	sd	s0,16(sp)
 608:	1000                	addi	s0,sp,32
 60a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 60e:	4605                	li	a2,1
 610:	fef40593          	addi	a1,s0,-17
 614:	f4fff0ef          	jal	562 <write>
}
 618:	60e2                	ld	ra,24(sp)
 61a:	6442                	ld	s0,16(sp)
 61c:	6105                	addi	sp,sp,32
 61e:	8082                	ret

0000000000000620 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 620:	715d                	addi	sp,sp,-80
 622:	e486                	sd	ra,72(sp)
 624:	e0a2                	sd	s0,64(sp)
 626:	fc26                	sd	s1,56(sp)
 628:	f84a                	sd	s2,48(sp)
 62a:	f44e                	sd	s3,40(sp)
 62c:	0880                	addi	s0,sp,80
 62e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 630:	c299                	beqz	a3,636 <printint+0x16>
 632:	0605cc63          	bltz	a1,6aa <printint+0x8a>
  neg = 0;
 636:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 638:	fb840313          	addi	t1,s0,-72
  neg = 0;
 63c:	869a                	mv	a3,t1
  i = 0;
 63e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 640:	00000817          	auipc	a6,0x0
 644:	54080813          	addi	a6,a6,1344 # b80 <digits>
 648:	88be                	mv	a7,a5
 64a:	0017851b          	addiw	a0,a5,1
 64e:	87aa                	mv	a5,a0
 650:	02c5f733          	remu	a4,a1,a2
 654:	9742                	add	a4,a4,a6
 656:	00074703          	lbu	a4,0(a4)
 65a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 65e:	872e                	mv	a4,a1
 660:	02c5d5b3          	divu	a1,a1,a2
 664:	0685                	addi	a3,a3,1
 666:	fec771e3          	bgeu	a4,a2,648 <printint+0x28>
  if(neg)
 66a:	000e0c63          	beqz	t3,682 <printint+0x62>
    buf[i++] = '-';
 66e:	fd050793          	addi	a5,a0,-48
 672:	00878533          	add	a0,a5,s0
 676:	02d00793          	li	a5,45
 67a:	fef50423          	sb	a5,-24(a0)
 67e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 682:	fff7899b          	addiw	s3,a5,-1
 686:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 68a:	fff4c583          	lbu	a1,-1(s1)
 68e:	854a                	mv	a0,s2
 690:	f73ff0ef          	jal	602 <putc>
  while(--i >= 0)
 694:	39fd                	addiw	s3,s3,-1
 696:	14fd                	addi	s1,s1,-1
 698:	fe09d9e3          	bgez	s3,68a <printint+0x6a>
}
 69c:	60a6                	ld	ra,72(sp)
 69e:	6406                	ld	s0,64(sp)
 6a0:	74e2                	ld	s1,56(sp)
 6a2:	7942                	ld	s2,48(sp)
 6a4:	79a2                	ld	s3,40(sp)
 6a6:	6161                	addi	sp,sp,80
 6a8:	8082                	ret
    x = -xx;
 6aa:	40b005b3          	neg	a1,a1
    neg = 1;
 6ae:	4e05                	li	t3,1
    x = -xx;
 6b0:	b761                	j	638 <printint+0x18>

00000000000006b2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6b2:	711d                	addi	sp,sp,-96
 6b4:	ec86                	sd	ra,88(sp)
 6b6:	e8a2                	sd	s0,80(sp)
 6b8:	e4a6                	sd	s1,72(sp)
 6ba:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6bc:	0005c483          	lbu	s1,0(a1)
 6c0:	28048463          	beqz	s1,948 <vprintf+0x296>
 6c4:	e0ca                	sd	s2,64(sp)
 6c6:	fc4e                	sd	s3,56(sp)
 6c8:	f852                	sd	s4,48(sp)
 6ca:	f456                	sd	s5,40(sp)
 6cc:	f05a                	sd	s6,32(sp)
 6ce:	ec5e                	sd	s7,24(sp)
 6d0:	e862                	sd	s8,16(sp)
 6d2:	e466                	sd	s9,8(sp)
 6d4:	8b2a                	mv	s6,a0
 6d6:	8a2e                	mv	s4,a1
 6d8:	8bb2                	mv	s7,a2
  state = 0;
 6da:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6dc:	4901                	li	s2,0
 6de:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6e0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6e4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6e8:	06c00c93          	li	s9,108
 6ec:	a00d                	j	70e <vprintf+0x5c>
        putc(fd, c0);
 6ee:	85a6                	mv	a1,s1
 6f0:	855a                	mv	a0,s6
 6f2:	f11ff0ef          	jal	602 <putc>
 6f6:	a019                	j	6fc <vprintf+0x4a>
    } else if(state == '%'){
 6f8:	03598363          	beq	s3,s5,71e <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6fc:	0019079b          	addiw	a5,s2,1
 700:	893e                	mv	s2,a5
 702:	873e                	mv	a4,a5
 704:	97d2                	add	a5,a5,s4
 706:	0007c483          	lbu	s1,0(a5)
 70a:	22048763          	beqz	s1,938 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 70e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 712:	fe0993e3          	bnez	s3,6f8 <vprintf+0x46>
      if(c0 == '%'){
 716:	fd579ce3          	bne	a5,s5,6ee <vprintf+0x3c>
        state = '%';
 71a:	89be                	mv	s3,a5
 71c:	b7c5                	j	6fc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 71e:	00ea06b3          	add	a3,s4,a4
 722:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 726:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 728:	c681                	beqz	a3,730 <vprintf+0x7e>
 72a:	9752                	add	a4,a4,s4
 72c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 730:	05878263          	beq	a5,s8,774 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 734:	05978c63          	beq	a5,s9,78c <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 738:	07500713          	li	a4,117
 73c:	0ee78663          	beq	a5,a4,828 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 740:	07800713          	li	a4,120
 744:	12e78863          	beq	a5,a4,874 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 748:	07000713          	li	a4,112
 74c:	14e78d63          	beq	a5,a4,8a6 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 750:	06300713          	li	a4,99
 754:	18e78c63          	beq	a5,a4,8ec <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 758:	07300713          	li	a4,115
 75c:	1ae78263          	beq	a5,a4,900 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 760:	02500713          	li	a4,37
 764:	04e79463          	bne	a5,a4,7ac <vprintf+0xfa>
        putc(fd, '%');
 768:	85ba                	mv	a1,a4
 76a:	855a                	mv	a0,s6
 76c:	e97ff0ef          	jal	602 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 770:	4981                	li	s3,0
 772:	b769                	j	6fc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 774:	008b8493          	addi	s1,s7,8
 778:	4685                	li	a3,1
 77a:	4629                	li	a2,10
 77c:	000ba583          	lw	a1,0(s7)
 780:	855a                	mv	a0,s6
 782:	e9fff0ef          	jal	620 <printint>
 786:	8ba6                	mv	s7,s1
      state = 0;
 788:	4981                	li	s3,0
 78a:	bf8d                	j	6fc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 78c:	06400793          	li	a5,100
 790:	02f68963          	beq	a3,a5,7c2 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 794:	06c00793          	li	a5,108
 798:	04f68263          	beq	a3,a5,7dc <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 79c:	07500793          	li	a5,117
 7a0:	0af68063          	beq	a3,a5,840 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 7a4:	07800793          	li	a5,120
 7a8:	0ef68263          	beq	a3,a5,88c <vprintf+0x1da>
        putc(fd, '%');
 7ac:	02500593          	li	a1,37
 7b0:	855a                	mv	a0,s6
 7b2:	e51ff0ef          	jal	602 <putc>
        putc(fd, c0);
 7b6:	85a6                	mv	a1,s1
 7b8:	855a                	mv	a0,s6
 7ba:	e49ff0ef          	jal	602 <putc>
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	bf35                	j	6fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c2:	008b8493          	addi	s1,s7,8
 7c6:	4685                	li	a3,1
 7c8:	4629                	li	a2,10
 7ca:	000bb583          	ld	a1,0(s7)
 7ce:	855a                	mv	a0,s6
 7d0:	e51ff0ef          	jal	620 <printint>
        i += 1;
 7d4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d6:	8ba6                	mv	s7,s1
      state = 0;
 7d8:	4981                	li	s3,0
        i += 1;
 7da:	b70d                	j	6fc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7dc:	06400793          	li	a5,100
 7e0:	02f60763          	beq	a2,a5,80e <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7e4:	07500793          	li	a5,117
 7e8:	06f60963          	beq	a2,a5,85a <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7ec:	07800793          	li	a5,120
 7f0:	faf61ee3          	bne	a2,a5,7ac <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f4:	008b8493          	addi	s1,s7,8
 7f8:	4681                	li	a3,0
 7fa:	4641                	li	a2,16
 7fc:	000bb583          	ld	a1,0(s7)
 800:	855a                	mv	a0,s6
 802:	e1fff0ef          	jal	620 <printint>
        i += 2;
 806:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 808:	8ba6                	mv	s7,s1
      state = 0;
 80a:	4981                	li	s3,0
        i += 2;
 80c:	bdc5                	j	6fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 80e:	008b8493          	addi	s1,s7,8
 812:	4685                	li	a3,1
 814:	4629                	li	a2,10
 816:	000bb583          	ld	a1,0(s7)
 81a:	855a                	mv	a0,s6
 81c:	e05ff0ef          	jal	620 <printint>
        i += 2;
 820:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 822:	8ba6                	mv	s7,s1
      state = 0;
 824:	4981                	li	s3,0
        i += 2;
 826:	bdd9                	j	6fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 828:	008b8493          	addi	s1,s7,8
 82c:	4681                	li	a3,0
 82e:	4629                	li	a2,10
 830:	000be583          	lwu	a1,0(s7)
 834:	855a                	mv	a0,s6
 836:	debff0ef          	jal	620 <printint>
 83a:	8ba6                	mv	s7,s1
      state = 0;
 83c:	4981                	li	s3,0
 83e:	bd7d                	j	6fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 840:	008b8493          	addi	s1,s7,8
 844:	4681                	li	a3,0
 846:	4629                	li	a2,10
 848:	000bb583          	ld	a1,0(s7)
 84c:	855a                	mv	a0,s6
 84e:	dd3ff0ef          	jal	620 <printint>
        i += 1;
 852:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 854:	8ba6                	mv	s7,s1
      state = 0;
 856:	4981                	li	s3,0
        i += 1;
 858:	b555                	j	6fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 85a:	008b8493          	addi	s1,s7,8
 85e:	4681                	li	a3,0
 860:	4629                	li	a2,10
 862:	000bb583          	ld	a1,0(s7)
 866:	855a                	mv	a0,s6
 868:	db9ff0ef          	jal	620 <printint>
        i += 2;
 86c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 86e:	8ba6                	mv	s7,s1
      state = 0;
 870:	4981                	li	s3,0
        i += 2;
 872:	b569                	j	6fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 874:	008b8493          	addi	s1,s7,8
 878:	4681                	li	a3,0
 87a:	4641                	li	a2,16
 87c:	000be583          	lwu	a1,0(s7)
 880:	855a                	mv	a0,s6
 882:	d9fff0ef          	jal	620 <printint>
 886:	8ba6                	mv	s7,s1
      state = 0;
 888:	4981                	li	s3,0
 88a:	bd8d                	j	6fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 88c:	008b8493          	addi	s1,s7,8
 890:	4681                	li	a3,0
 892:	4641                	li	a2,16
 894:	000bb583          	ld	a1,0(s7)
 898:	855a                	mv	a0,s6
 89a:	d87ff0ef          	jal	620 <printint>
        i += 1;
 89e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8a0:	8ba6                	mv	s7,s1
      state = 0;
 8a2:	4981                	li	s3,0
        i += 1;
 8a4:	bda1                	j	6fc <vprintf+0x4a>
 8a6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8a8:	008b8d13          	addi	s10,s7,8
 8ac:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8b0:	03000593          	li	a1,48
 8b4:	855a                	mv	a0,s6
 8b6:	d4dff0ef          	jal	602 <putc>
  putc(fd, 'x');
 8ba:	07800593          	li	a1,120
 8be:	855a                	mv	a0,s6
 8c0:	d43ff0ef          	jal	602 <putc>
 8c4:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8c6:	00000b97          	auipc	s7,0x0
 8ca:	2bab8b93          	addi	s7,s7,698 # b80 <digits>
 8ce:	03c9d793          	srli	a5,s3,0x3c
 8d2:	97de                	add	a5,a5,s7
 8d4:	0007c583          	lbu	a1,0(a5)
 8d8:	855a                	mv	a0,s6
 8da:	d29ff0ef          	jal	602 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8de:	0992                	slli	s3,s3,0x4
 8e0:	34fd                	addiw	s1,s1,-1
 8e2:	f4f5                	bnez	s1,8ce <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 8e4:	8bea                	mv	s7,s10
      state = 0;
 8e6:	4981                	li	s3,0
 8e8:	6d02                	ld	s10,0(sp)
 8ea:	bd09                	j	6fc <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 8ec:	008b8493          	addi	s1,s7,8
 8f0:	000bc583          	lbu	a1,0(s7)
 8f4:	855a                	mv	a0,s6
 8f6:	d0dff0ef          	jal	602 <putc>
 8fa:	8ba6                	mv	s7,s1
      state = 0;
 8fc:	4981                	li	s3,0
 8fe:	bbfd                	j	6fc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 900:	008b8993          	addi	s3,s7,8
 904:	000bb483          	ld	s1,0(s7)
 908:	cc91                	beqz	s1,924 <vprintf+0x272>
        for(; *s; s++)
 90a:	0004c583          	lbu	a1,0(s1)
 90e:	c195                	beqz	a1,932 <vprintf+0x280>
          putc(fd, *s);
 910:	855a                	mv	a0,s6
 912:	cf1ff0ef          	jal	602 <putc>
        for(; *s; s++)
 916:	0485                	addi	s1,s1,1
 918:	0004c583          	lbu	a1,0(s1)
 91c:	f9f5                	bnez	a1,910 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 91e:	8bce                	mv	s7,s3
      state = 0;
 920:	4981                	li	s3,0
 922:	bbe9                	j	6fc <vprintf+0x4a>
          s = "(null)";
 924:	00000497          	auipc	s1,0x0
 928:	25448493          	addi	s1,s1,596 # b78 <malloc+0x144>
        for(; *s; s++)
 92c:	02800593          	li	a1,40
 930:	b7c5                	j	910 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 932:	8bce                	mv	s7,s3
      state = 0;
 934:	4981                	li	s3,0
 936:	b3d9                	j	6fc <vprintf+0x4a>
 938:	6906                	ld	s2,64(sp)
 93a:	79e2                	ld	s3,56(sp)
 93c:	7a42                	ld	s4,48(sp)
 93e:	7aa2                	ld	s5,40(sp)
 940:	7b02                	ld	s6,32(sp)
 942:	6be2                	ld	s7,24(sp)
 944:	6c42                	ld	s8,16(sp)
 946:	6ca2                	ld	s9,8(sp)
    }
  }
}
 948:	60e6                	ld	ra,88(sp)
 94a:	6446                	ld	s0,80(sp)
 94c:	64a6                	ld	s1,72(sp)
 94e:	6125                	addi	sp,sp,96
 950:	8082                	ret

0000000000000952 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 952:	715d                	addi	sp,sp,-80
 954:	ec06                	sd	ra,24(sp)
 956:	e822                	sd	s0,16(sp)
 958:	1000                	addi	s0,sp,32
 95a:	e010                	sd	a2,0(s0)
 95c:	e414                	sd	a3,8(s0)
 95e:	e818                	sd	a4,16(s0)
 960:	ec1c                	sd	a5,24(s0)
 962:	03043023          	sd	a6,32(s0)
 966:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 96a:	8622                	mv	a2,s0
 96c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 970:	d43ff0ef          	jal	6b2 <vprintf>
}
 974:	60e2                	ld	ra,24(sp)
 976:	6442                	ld	s0,16(sp)
 978:	6161                	addi	sp,sp,80
 97a:	8082                	ret

000000000000097c <printf>:

void
printf(const char *fmt, ...)
{
 97c:	711d                	addi	sp,sp,-96
 97e:	ec06                	sd	ra,24(sp)
 980:	e822                	sd	s0,16(sp)
 982:	1000                	addi	s0,sp,32
 984:	e40c                	sd	a1,8(s0)
 986:	e810                	sd	a2,16(s0)
 988:	ec14                	sd	a3,24(s0)
 98a:	f018                	sd	a4,32(s0)
 98c:	f41c                	sd	a5,40(s0)
 98e:	03043823          	sd	a6,48(s0)
 992:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 996:	00840613          	addi	a2,s0,8
 99a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 99e:	85aa                	mv	a1,a0
 9a0:	4505                	li	a0,1
 9a2:	d11ff0ef          	jal	6b2 <vprintf>
}
 9a6:	60e2                	ld	ra,24(sp)
 9a8:	6442                	ld	s0,16(sp)
 9aa:	6125                	addi	sp,sp,96
 9ac:	8082                	ret

00000000000009ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9ae:	1141                	addi	sp,sp,-16
 9b0:	e406                	sd	ra,8(sp)
 9b2:	e022                	sd	s0,0(sp)
 9b4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9b6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ba:	00000797          	auipc	a5,0x0
 9be:	6467b783          	ld	a5,1606(a5) # 1000 <freep>
 9c2:	a02d                	j	9ec <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9c4:	4618                	lw	a4,8(a2)
 9c6:	9f2d                	addw	a4,a4,a1
 9c8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9cc:	6398                	ld	a4,0(a5)
 9ce:	6310                	ld	a2,0(a4)
 9d0:	a83d                	j	a0e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9d2:	ff852703          	lw	a4,-8(a0)
 9d6:	9f31                	addw	a4,a4,a2
 9d8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9da:	ff053683          	ld	a3,-16(a0)
 9de:	a091                	j	a22 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9e0:	6398                	ld	a4,0(a5)
 9e2:	00e7e463          	bltu	a5,a4,9ea <free+0x3c>
 9e6:	00e6ea63          	bltu	a3,a4,9fa <free+0x4c>
{
 9ea:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ec:	fed7fae3          	bgeu	a5,a3,9e0 <free+0x32>
 9f0:	6398                	ld	a4,0(a5)
 9f2:	00e6e463          	bltu	a3,a4,9fa <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9f6:	fee7eae3          	bltu	a5,a4,9ea <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9fa:	ff852583          	lw	a1,-8(a0)
 9fe:	6390                	ld	a2,0(a5)
 a00:	02059813          	slli	a6,a1,0x20
 a04:	01c85713          	srli	a4,a6,0x1c
 a08:	9736                	add	a4,a4,a3
 a0a:	fae60de3          	beq	a2,a4,9c4 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a0e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a12:	4790                	lw	a2,8(a5)
 a14:	02061593          	slli	a1,a2,0x20
 a18:	01c5d713          	srli	a4,a1,0x1c
 a1c:	973e                	add	a4,a4,a5
 a1e:	fae68ae3          	beq	a3,a4,9d2 <free+0x24>
    p->s.ptr = bp->s.ptr;
 a22:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a24:	00000717          	auipc	a4,0x0
 a28:	5cf73e23          	sd	a5,1500(a4) # 1000 <freep>
}
 a2c:	60a2                	ld	ra,8(sp)
 a2e:	6402                	ld	s0,0(sp)
 a30:	0141                	addi	sp,sp,16
 a32:	8082                	ret

0000000000000a34 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a34:	7139                	addi	sp,sp,-64
 a36:	fc06                	sd	ra,56(sp)
 a38:	f822                	sd	s0,48(sp)
 a3a:	f04a                	sd	s2,32(sp)
 a3c:	ec4e                	sd	s3,24(sp)
 a3e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a40:	02051993          	slli	s3,a0,0x20
 a44:	0209d993          	srli	s3,s3,0x20
 a48:	09bd                	addi	s3,s3,15
 a4a:	0049d993          	srli	s3,s3,0x4
 a4e:	2985                	addiw	s3,s3,1
 a50:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a52:	00000517          	auipc	a0,0x0
 a56:	5ae53503          	ld	a0,1454(a0) # 1000 <freep>
 a5a:	c905                	beqz	a0,a8a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a5e:	4798                	lw	a4,8(a5)
 a60:	09377663          	bgeu	a4,s3,aec <malloc+0xb8>
 a64:	f426                	sd	s1,40(sp)
 a66:	e852                	sd	s4,16(sp)
 a68:	e456                	sd	s5,8(sp)
 a6a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a6c:	8a4e                	mv	s4,s3
 a6e:	6705                	lui	a4,0x1
 a70:	00e9f363          	bgeu	s3,a4,a76 <malloc+0x42>
 a74:	6a05                	lui	s4,0x1
 a76:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a7a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a7e:	00000497          	auipc	s1,0x0
 a82:	58248493          	addi	s1,s1,1410 # 1000 <freep>
  if(p == SBRK_ERROR)
 a86:	5afd                	li	s5,-1
 a88:	a83d                	j	ac6 <malloc+0x92>
 a8a:	f426                	sd	s1,40(sp)
 a8c:	e852                	sd	s4,16(sp)
 a8e:	e456                	sd	s5,8(sp)
 a90:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a92:	00000797          	auipc	a5,0x0
 a96:	77678793          	addi	a5,a5,1910 # 1208 <base>
 a9a:	00000717          	auipc	a4,0x0
 a9e:	56f73323          	sd	a5,1382(a4) # 1000 <freep>
 aa2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 aa4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aa8:	b7d1                	j	a6c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 aaa:	6398                	ld	a4,0(a5)
 aac:	e118                	sd	a4,0(a0)
 aae:	a899                	j	b04 <malloc+0xd0>
  hp->s.size = nu;
 ab0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ab4:	0541                	addi	a0,a0,16
 ab6:	ef9ff0ef          	jal	9ae <free>
  return freep;
 aba:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 abc:	c125                	beqz	a0,b1c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 abe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ac0:	4798                	lw	a4,8(a5)
 ac2:	03277163          	bgeu	a4,s2,ae4 <malloc+0xb0>
    if(p == freep)
 ac6:	6098                	ld	a4,0(s1)
 ac8:	853e                	mv	a0,a5
 aca:	fef71ae3          	bne	a4,a5,abe <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ace:	8552                	mv	a0,s4
 ad0:	8c7ff0ef          	jal	396 <sbrk>
  if(p == SBRK_ERROR)
 ad4:	fd551ee3          	bne	a0,s5,ab0 <malloc+0x7c>
        return 0;
 ad8:	4501                	li	a0,0
 ada:	74a2                	ld	s1,40(sp)
 adc:	6a42                	ld	s4,16(sp)
 ade:	6aa2                	ld	s5,8(sp)
 ae0:	6b02                	ld	s6,0(sp)
 ae2:	a03d                	j	b10 <malloc+0xdc>
 ae4:	74a2                	ld	s1,40(sp)
 ae6:	6a42                	ld	s4,16(sp)
 ae8:	6aa2                	ld	s5,8(sp)
 aea:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aec:	fae90fe3          	beq	s2,a4,aaa <malloc+0x76>
        p->s.size -= nunits;
 af0:	4137073b          	subw	a4,a4,s3
 af4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 af6:	02071693          	slli	a3,a4,0x20
 afa:	01c6d713          	srli	a4,a3,0x1c
 afe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b00:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b04:	00000717          	auipc	a4,0x0
 b08:	4ea73e23          	sd	a0,1276(a4) # 1000 <freep>
      return (void*)(p + 1);
 b0c:	01078513          	addi	a0,a5,16
  }
}
 b10:	70e2                	ld	ra,56(sp)
 b12:	7442                	ld	s0,48(sp)
 b14:	7902                	ld	s2,32(sp)
 b16:	69e2                	ld	s3,24(sp)
 b18:	6121                	addi	sp,sp,64
 b1a:	8082                	ret
 b1c:	74a2                	ld	s1,40(sp)
 b1e:	6a42                	ld	s4,16(sp)
 b20:	6aa2                	ld	s5,8(sp)
 b22:	6b02                	ld	s6,0(sp)
 b24:	b7f5                	j	b10 <malloc+0xdc>
