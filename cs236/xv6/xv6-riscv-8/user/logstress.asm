
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
  20:	3d4000ef          	jal	3f4 <fork>
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
  42:	99250513          	addi	a0,a0,-1646 # 9d0 <malloc+0xf2>
  46:	7e0000ef          	jal	826 <printf>
      exit(1);
  4a:	4505                	li	a0,1
  4c:	3b0000ef          	jal	3fc <exit>
      fd = open(argv[i], O_CREATE | O_RDWR);
  50:	00349913          	slli	s2,s1,0x3
  54:	9952                	add	s2,s2,s4
  56:	20200593          	li	a1,514
  5a:	00093503          	ld	a0,0(s2)
  5e:	3de000ef          	jal	43c <open>
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
  92:	38a000ef          	jal	41c <write>
  96:	03251463          	bne	a0,s2,be <main+0xbe>
      for(i = 0; i < N; i++){
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f8e5                	bnez	s1,8c <main+0x8c>
      exit(0);
  9e:	4501                	li	a0,0
  a0:	35c000ef          	jal	3fc <exit>
        printf("%s: create %s failed\n", argv[0], argv[i]);
  a4:	00093603          	ld	a2,0(s2)
  a8:	000a3583          	ld	a1,0(s4)
  ac:	00001517          	auipc	a0,0x1
  b0:	93c50513          	addi	a0,a0,-1732 # 9e8 <malloc+0x10a>
  b4:	772000ef          	jal	826 <printf>
        exit(1);
  b8:	4505                	li	a0,1
  ba:	342000ef          	jal	3fc <exit>
          printf("write failed %d\n", n);
  be:	85aa                	mv	a1,a0
  c0:	00001517          	auipc	a0,0x1
  c4:	94050513          	addi	a0,a0,-1728 # a00 <malloc+0x122>
  c8:	75e000ef          	jal	826 <printf>
          exit(1);
  cc:	4505                	li	a0,1
  ce:	32e000ef          	jal	3fc <exit>
  d2:	893e                	mv	s2,a5
    wait(&xstatus);
  d4:	854e                	mv	a0,s3
  d6:	32e000ef          	jal	404 <wait>
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
  fa:	302000ef          	jal	3fc <exit>
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
 10e:	2ee000ef          	jal	3fc <exit>

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
 21e:	1f6000ef          	jal	414 <read>
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
 270:	1cc000ef          	jal	43c <open>
  if(fd < 0)
 274:	02054263          	bltz	a0,298 <stat+0x36>
 278:	e426                	sd	s1,8(sp)
 27a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 27c:	85ca                	mv	a1,s2
 27e:	1d6000ef          	jal	454 <fstat>
 282:	892a                	mv	s2,a0
  close(fd);
 284:	8526                	mv	a0,s1
 286:	19e000ef          	jal	424 <close>
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
 3a0:	0e4000ef          	jal	484 <sys_sbrk>
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
 3b6:	0ce000ef          	jal	484 <sys_sbrk>
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
 3e4:	0b8000ef          	jal	49c <clone>
 3e8:	60e2                	ld	ra,24(sp)
 3ea:	6442                	ld	s0,16(sp)
 3ec:	64a2                	ld	s1,8(sp)
 3ee:	6902                	ld	s2,0(sp)
 3f0:	6105                	addi	sp,sp,32
 3f2:	8082                	ret

00000000000003f4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f4:	4885                	li	a7,1
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <exit>:
.global exit
exit:
 li a7, SYS_exit
 3fc:	4889                	li	a7,2
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <wait>:
.global wait
wait:
 li a7, SYS_wait
 404:	488d                	li	a7,3
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 40c:	4891                	li	a7,4
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <read>:
.global read
read:
 li a7, SYS_read
 414:	4895                	li	a7,5
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <write>:
.global write
write:
 li a7, SYS_write
 41c:	48c1                	li	a7,16
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <close>:
.global close
close:
 li a7, SYS_close
 424:	48d5                	li	a7,21
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <kill>:
.global kill
kill:
 li a7, SYS_kill
 42c:	4899                	li	a7,6
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <exec>:
.global exec
exec:
 li a7, SYS_exec
 434:	489d                	li	a7,7
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <open>:
.global open
open:
 li a7, SYS_open
 43c:	48bd                	li	a7,15
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 444:	48c5                	li	a7,17
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 44c:	48c9                	li	a7,18
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 454:	48a1                	li	a7,8
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <link>:
.global link
link:
 li a7, SYS_link
 45c:	48cd                	li	a7,19
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 464:	48d1                	li	a7,20
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 46c:	48a5                	li	a7,9
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <dup>:
.global dup
dup:
 li a7, SYS_dup
 474:	48a9                	li	a7,10
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 47c:	48ad                	li	a7,11
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 484:	48b1                	li	a7,12
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <pause>:
.global pause
pause:
 li a7, SYS_pause
 48c:	48b5                	li	a7,13
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 494:	48b9                	li	a7,14
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <clone>:
.global clone
clone:
 li a7, SYS_clone
 49c:	48d9                	li	a7,22
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <join>:
.global join
join:
 li a7, SYS_join
 4a4:	48dd                	li	a7,23
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ac:	1101                	addi	sp,sp,-32
 4ae:	ec06                	sd	ra,24(sp)
 4b0:	e822                	sd	s0,16(sp)
 4b2:	1000                	addi	s0,sp,32
 4b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4b8:	4605                	li	a2,1
 4ba:	fef40593          	addi	a1,s0,-17
 4be:	f5fff0ef          	jal	41c <write>
}
 4c2:	60e2                	ld	ra,24(sp)
 4c4:	6442                	ld	s0,16(sp)
 4c6:	6105                	addi	sp,sp,32
 4c8:	8082                	ret

00000000000004ca <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4ca:	715d                	addi	sp,sp,-80
 4cc:	e486                	sd	ra,72(sp)
 4ce:	e0a2                	sd	s0,64(sp)
 4d0:	fc26                	sd	s1,56(sp)
 4d2:	f84a                	sd	s2,48(sp)
 4d4:	f44e                	sd	s3,40(sp)
 4d6:	0880                	addi	s0,sp,80
 4d8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4da:	c299                	beqz	a3,4e0 <printint+0x16>
 4dc:	0605cc63          	bltz	a1,554 <printint+0x8a>
  neg = 0;
 4e0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4e2:	fb840313          	addi	t1,s0,-72
  neg = 0;
 4e6:	869a                	mv	a3,t1
  i = 0;
 4e8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4ea:	00000817          	auipc	a6,0x0
 4ee:	53680813          	addi	a6,a6,1334 # a20 <digits>
 4f2:	88be                	mv	a7,a5
 4f4:	0017851b          	addiw	a0,a5,1 # 1001 <freep+0x1>
 4f8:	87aa                	mv	a5,a0
 4fa:	02c5f733          	remu	a4,a1,a2
 4fe:	9742                	add	a4,a4,a6
 500:	00074703          	lbu	a4,0(a4)
 504:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 508:	872e                	mv	a4,a1
 50a:	02c5d5b3          	divu	a1,a1,a2
 50e:	0685                	addi	a3,a3,1
 510:	fec771e3          	bgeu	a4,a2,4f2 <printint+0x28>
  if(neg)
 514:	000e0c63          	beqz	t3,52c <printint+0x62>
    buf[i++] = '-';
 518:	fd050793          	addi	a5,a0,-48 # fd0 <digits+0x5b0>
 51c:	00878533          	add	a0,a5,s0
 520:	02d00793          	li	a5,45
 524:	fef50423          	sb	a5,-24(a0)
 528:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 52c:	fff7899b          	addiw	s3,a5,-1
 530:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 534:	fff4c583          	lbu	a1,-1(s1)
 538:	854a                	mv	a0,s2
 53a:	f73ff0ef          	jal	4ac <putc>
  while(--i >= 0)
 53e:	39fd                	addiw	s3,s3,-1
 540:	14fd                	addi	s1,s1,-1
 542:	fe09d9e3          	bgez	s3,534 <printint+0x6a>
}
 546:	60a6                	ld	ra,72(sp)
 548:	6406                	ld	s0,64(sp)
 54a:	74e2                	ld	s1,56(sp)
 54c:	7942                	ld	s2,48(sp)
 54e:	79a2                	ld	s3,40(sp)
 550:	6161                	addi	sp,sp,80
 552:	8082                	ret
    x = -xx;
 554:	40b005b3          	neg	a1,a1
    neg = 1;
 558:	4e05                	li	t3,1
    x = -xx;
 55a:	b761                	j	4e2 <printint+0x18>

000000000000055c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 55c:	711d                	addi	sp,sp,-96
 55e:	ec86                	sd	ra,88(sp)
 560:	e8a2                	sd	s0,80(sp)
 562:	e4a6                	sd	s1,72(sp)
 564:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 566:	0005c483          	lbu	s1,0(a1)
 56a:	28048463          	beqz	s1,7f2 <vprintf+0x296>
 56e:	e0ca                	sd	s2,64(sp)
 570:	fc4e                	sd	s3,56(sp)
 572:	f852                	sd	s4,48(sp)
 574:	f456                	sd	s5,40(sp)
 576:	f05a                	sd	s6,32(sp)
 578:	ec5e                	sd	s7,24(sp)
 57a:	e862                	sd	s8,16(sp)
 57c:	e466                	sd	s9,8(sp)
 57e:	8b2a                	mv	s6,a0
 580:	8a2e                	mv	s4,a1
 582:	8bb2                	mv	s7,a2
  state = 0;
 584:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 586:	4901                	li	s2,0
 588:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 58a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 58e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 592:	06c00c93          	li	s9,108
 596:	a00d                	j	5b8 <vprintf+0x5c>
        putc(fd, c0);
 598:	85a6                	mv	a1,s1
 59a:	855a                	mv	a0,s6
 59c:	f11ff0ef          	jal	4ac <putc>
 5a0:	a019                	j	5a6 <vprintf+0x4a>
    } else if(state == '%'){
 5a2:	03598363          	beq	s3,s5,5c8 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 5a6:	0019079b          	addiw	a5,s2,1
 5aa:	893e                	mv	s2,a5
 5ac:	873e                	mv	a4,a5
 5ae:	97d2                	add	a5,a5,s4
 5b0:	0007c483          	lbu	s1,0(a5)
 5b4:	22048763          	beqz	s1,7e2 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 5b8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5bc:	fe0993e3          	bnez	s3,5a2 <vprintf+0x46>
      if(c0 == '%'){
 5c0:	fd579ce3          	bne	a5,s5,598 <vprintf+0x3c>
        state = '%';
 5c4:	89be                	mv	s3,a5
 5c6:	b7c5                	j	5a6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5c8:	00ea06b3          	add	a3,s4,a4
 5cc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5d0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5d2:	c681                	beqz	a3,5da <vprintf+0x7e>
 5d4:	9752                	add	a4,a4,s4
 5d6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5da:	05878263          	beq	a5,s8,61e <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5de:	05978c63          	beq	a5,s9,636 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5e2:	07500713          	li	a4,117
 5e6:	0ee78663          	beq	a5,a4,6d2 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5ea:	07800713          	li	a4,120
 5ee:	12e78863          	beq	a5,a4,71e <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5f2:	07000713          	li	a4,112
 5f6:	14e78d63          	beq	a5,a4,750 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5fa:	06300713          	li	a4,99
 5fe:	18e78c63          	beq	a5,a4,796 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 602:	07300713          	li	a4,115
 606:	1ae78263          	beq	a5,a4,7aa <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 60a:	02500713          	li	a4,37
 60e:	04e79463          	bne	a5,a4,656 <vprintf+0xfa>
        putc(fd, '%');
 612:	85ba                	mv	a1,a4
 614:	855a                	mv	a0,s6
 616:	e97ff0ef          	jal	4ac <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 61a:	4981                	li	s3,0
 61c:	b769                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 61e:	008b8493          	addi	s1,s7,8
 622:	4685                	li	a3,1
 624:	4629                	li	a2,10
 626:	000ba583          	lw	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	e9fff0ef          	jal	4ca <printint>
 630:	8ba6                	mv	s7,s1
      state = 0;
 632:	4981                	li	s3,0
 634:	bf8d                	j	5a6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 636:	06400793          	li	a5,100
 63a:	02f68963          	beq	a3,a5,66c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 63e:	06c00793          	li	a5,108
 642:	04f68263          	beq	a3,a5,686 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 646:	07500793          	li	a5,117
 64a:	0af68063          	beq	a3,a5,6ea <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 64e:	07800793          	li	a5,120
 652:	0ef68263          	beq	a3,a5,736 <vprintf+0x1da>
        putc(fd, '%');
 656:	02500593          	li	a1,37
 65a:	855a                	mv	a0,s6
 65c:	e51ff0ef          	jal	4ac <putc>
        putc(fd, c0);
 660:	85a6                	mv	a1,s1
 662:	855a                	mv	a0,s6
 664:	e49ff0ef          	jal	4ac <putc>
      state = 0;
 668:	4981                	li	s3,0
 66a:	bf35                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 66c:	008b8493          	addi	s1,s7,8
 670:	4685                	li	a3,1
 672:	4629                	li	a2,10
 674:	000bb583          	ld	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	e51ff0ef          	jal	4ca <printint>
        i += 1;
 67e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 680:	8ba6                	mv	s7,s1
      state = 0;
 682:	4981                	li	s3,0
        i += 1;
 684:	b70d                	j	5a6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 686:	06400793          	li	a5,100
 68a:	02f60763          	beq	a2,a5,6b8 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 68e:	07500793          	li	a5,117
 692:	06f60963          	beq	a2,a5,704 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 696:	07800793          	li	a5,120
 69a:	faf61ee3          	bne	a2,a5,656 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 69e:	008b8493          	addi	s1,s7,8
 6a2:	4681                	li	a3,0
 6a4:	4641                	li	a2,16
 6a6:	000bb583          	ld	a1,0(s7)
 6aa:	855a                	mv	a0,s6
 6ac:	e1fff0ef          	jal	4ca <printint>
        i += 2;
 6b0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b2:	8ba6                	mv	s7,s1
      state = 0;
 6b4:	4981                	li	s3,0
        i += 2;
 6b6:	bdc5                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b8:	008b8493          	addi	s1,s7,8
 6bc:	4685                	li	a3,1
 6be:	4629                	li	a2,10
 6c0:	000bb583          	ld	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	e05ff0ef          	jal	4ca <printint>
        i += 2;
 6ca:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6cc:	8ba6                	mv	s7,s1
      state = 0;
 6ce:	4981                	li	s3,0
        i += 2;
 6d0:	bdd9                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6d2:	008b8493          	addi	s1,s7,8
 6d6:	4681                	li	a3,0
 6d8:	4629                	li	a2,10
 6da:	000be583          	lwu	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	debff0ef          	jal	4ca <printint>
 6e4:	8ba6                	mv	s7,s1
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bd7d                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ea:	008b8493          	addi	s1,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4629                	li	a2,10
 6f2:	000bb583          	ld	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	dd3ff0ef          	jal	4ca <printint>
        i += 1;
 6fc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fe:	8ba6                	mv	s7,s1
      state = 0;
 700:	4981                	li	s3,0
        i += 1;
 702:	b555                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 704:	008b8493          	addi	s1,s7,8
 708:	4681                	li	a3,0
 70a:	4629                	li	a2,10
 70c:	000bb583          	ld	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	db9ff0ef          	jal	4ca <printint>
        i += 2;
 716:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 718:	8ba6                	mv	s7,s1
      state = 0;
 71a:	4981                	li	s3,0
        i += 2;
 71c:	b569                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 71e:	008b8493          	addi	s1,s7,8
 722:	4681                	li	a3,0
 724:	4641                	li	a2,16
 726:	000be583          	lwu	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	d9fff0ef          	jal	4ca <printint>
 730:	8ba6                	mv	s7,s1
      state = 0;
 732:	4981                	li	s3,0
 734:	bd8d                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 736:	008b8493          	addi	s1,s7,8
 73a:	4681                	li	a3,0
 73c:	4641                	li	a2,16
 73e:	000bb583          	ld	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	d87ff0ef          	jal	4ca <printint>
        i += 1;
 748:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 74a:	8ba6                	mv	s7,s1
      state = 0;
 74c:	4981                	li	s3,0
        i += 1;
 74e:	bda1                	j	5a6 <vprintf+0x4a>
 750:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 752:	008b8d13          	addi	s10,s7,8
 756:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 75a:	03000593          	li	a1,48
 75e:	855a                	mv	a0,s6
 760:	d4dff0ef          	jal	4ac <putc>
  putc(fd, 'x');
 764:	07800593          	li	a1,120
 768:	855a                	mv	a0,s6
 76a:	d43ff0ef          	jal	4ac <putc>
 76e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 770:	00000b97          	auipc	s7,0x0
 774:	2b0b8b93          	addi	s7,s7,688 # a20 <digits>
 778:	03c9d793          	srli	a5,s3,0x3c
 77c:	97de                	add	a5,a5,s7
 77e:	0007c583          	lbu	a1,0(a5)
 782:	855a                	mv	a0,s6
 784:	d29ff0ef          	jal	4ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 788:	0992                	slli	s3,s3,0x4
 78a:	34fd                	addiw	s1,s1,-1
 78c:	f4f5                	bnez	s1,778 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 78e:	8bea                	mv	s7,s10
      state = 0;
 790:	4981                	li	s3,0
 792:	6d02                	ld	s10,0(sp)
 794:	bd09                	j	5a6 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 796:	008b8493          	addi	s1,s7,8
 79a:	000bc583          	lbu	a1,0(s7)
 79e:	855a                	mv	a0,s6
 7a0:	d0dff0ef          	jal	4ac <putc>
 7a4:	8ba6                	mv	s7,s1
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	bbfd                	j	5a6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7aa:	008b8993          	addi	s3,s7,8
 7ae:	000bb483          	ld	s1,0(s7)
 7b2:	cc91                	beqz	s1,7ce <vprintf+0x272>
        for(; *s; s++)
 7b4:	0004c583          	lbu	a1,0(s1)
 7b8:	c195                	beqz	a1,7dc <vprintf+0x280>
          putc(fd, *s);
 7ba:	855a                	mv	a0,s6
 7bc:	cf1ff0ef          	jal	4ac <putc>
        for(; *s; s++)
 7c0:	0485                	addi	s1,s1,1
 7c2:	0004c583          	lbu	a1,0(s1)
 7c6:	f9f5                	bnez	a1,7ba <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 7c8:	8bce                	mv	s7,s3
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	bbe9                	j	5a6 <vprintf+0x4a>
          s = "(null)";
 7ce:	00000497          	auipc	s1,0x0
 7d2:	24a48493          	addi	s1,s1,586 # a18 <malloc+0x13a>
        for(; *s; s++)
 7d6:	02800593          	li	a1,40
 7da:	b7c5                	j	7ba <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 7dc:	8bce                	mv	s7,s3
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b3d9                	j	5a6 <vprintf+0x4a>
 7e2:	6906                	ld	s2,64(sp)
 7e4:	79e2                	ld	s3,56(sp)
 7e6:	7a42                	ld	s4,48(sp)
 7e8:	7aa2                	ld	s5,40(sp)
 7ea:	7b02                	ld	s6,32(sp)
 7ec:	6be2                	ld	s7,24(sp)
 7ee:	6c42                	ld	s8,16(sp)
 7f0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7f2:	60e6                	ld	ra,88(sp)
 7f4:	6446                	ld	s0,80(sp)
 7f6:	64a6                	ld	s1,72(sp)
 7f8:	6125                	addi	sp,sp,96
 7fa:	8082                	ret

00000000000007fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7fc:	715d                	addi	sp,sp,-80
 7fe:	ec06                	sd	ra,24(sp)
 800:	e822                	sd	s0,16(sp)
 802:	1000                	addi	s0,sp,32
 804:	e010                	sd	a2,0(s0)
 806:	e414                	sd	a3,8(s0)
 808:	e818                	sd	a4,16(s0)
 80a:	ec1c                	sd	a5,24(s0)
 80c:	03043023          	sd	a6,32(s0)
 810:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 814:	8622                	mv	a2,s0
 816:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 81a:	d43ff0ef          	jal	55c <vprintf>
}
 81e:	60e2                	ld	ra,24(sp)
 820:	6442                	ld	s0,16(sp)
 822:	6161                	addi	sp,sp,80
 824:	8082                	ret

0000000000000826 <printf>:

void
printf(const char *fmt, ...)
{
 826:	711d                	addi	sp,sp,-96
 828:	ec06                	sd	ra,24(sp)
 82a:	e822                	sd	s0,16(sp)
 82c:	1000                	addi	s0,sp,32
 82e:	e40c                	sd	a1,8(s0)
 830:	e810                	sd	a2,16(s0)
 832:	ec14                	sd	a3,24(s0)
 834:	f018                	sd	a4,32(s0)
 836:	f41c                	sd	a5,40(s0)
 838:	03043823          	sd	a6,48(s0)
 83c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 840:	00840613          	addi	a2,s0,8
 844:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 848:	85aa                	mv	a1,a0
 84a:	4505                	li	a0,1
 84c:	d11ff0ef          	jal	55c <vprintf>
}
 850:	60e2                	ld	ra,24(sp)
 852:	6442                	ld	s0,16(sp)
 854:	6125                	addi	sp,sp,96
 856:	8082                	ret

0000000000000858 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 858:	1141                	addi	sp,sp,-16
 85a:	e406                	sd	ra,8(sp)
 85c:	e022                	sd	s0,0(sp)
 85e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 860:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 864:	00000797          	auipc	a5,0x0
 868:	79c7b783          	ld	a5,1948(a5) # 1000 <freep>
 86c:	a02d                	j	896 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 86e:	4618                	lw	a4,8(a2)
 870:	9f2d                	addw	a4,a4,a1
 872:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	6398                	ld	a4,0(a5)
 878:	6310                	ld	a2,0(a4)
 87a:	a83d                	j	8b8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 87c:	ff852703          	lw	a4,-8(a0)
 880:	9f31                	addw	a4,a4,a2
 882:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 884:	ff053683          	ld	a3,-16(a0)
 888:	a091                	j	8cc <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88a:	6398                	ld	a4,0(a5)
 88c:	00e7e463          	bltu	a5,a4,894 <free+0x3c>
 890:	00e6ea63          	bltu	a3,a4,8a4 <free+0x4c>
{
 894:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 896:	fed7fae3          	bgeu	a5,a3,88a <free+0x32>
 89a:	6398                	ld	a4,0(a5)
 89c:	00e6e463          	bltu	a3,a4,8a4 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	fee7eae3          	bltu	a5,a4,894 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 8a4:	ff852583          	lw	a1,-8(a0)
 8a8:	6390                	ld	a2,0(a5)
 8aa:	02059813          	slli	a6,a1,0x20
 8ae:	01c85713          	srli	a4,a6,0x1c
 8b2:	9736                	add	a4,a4,a3
 8b4:	fae60de3          	beq	a2,a4,86e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 8b8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8bc:	4790                	lw	a2,8(a5)
 8be:	02061593          	slli	a1,a2,0x20
 8c2:	01c5d713          	srli	a4,a1,0x1c
 8c6:	973e                	add	a4,a4,a5
 8c8:	fae68ae3          	beq	a3,a4,87c <free+0x24>
    p->s.ptr = bp->s.ptr;
 8cc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ce:	00000717          	auipc	a4,0x0
 8d2:	72f73923          	sd	a5,1842(a4) # 1000 <freep>
}
 8d6:	60a2                	ld	ra,8(sp)
 8d8:	6402                	ld	s0,0(sp)
 8da:	0141                	addi	sp,sp,16
 8dc:	8082                	ret

00000000000008de <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8de:	7139                	addi	sp,sp,-64
 8e0:	fc06                	sd	ra,56(sp)
 8e2:	f822                	sd	s0,48(sp)
 8e4:	f04a                	sd	s2,32(sp)
 8e6:	ec4e                	sd	s3,24(sp)
 8e8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ea:	02051993          	slli	s3,a0,0x20
 8ee:	0209d993          	srli	s3,s3,0x20
 8f2:	09bd                	addi	s3,s3,15
 8f4:	0049d993          	srli	s3,s3,0x4
 8f8:	2985                	addiw	s3,s3,1
 8fa:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8fc:	00000517          	auipc	a0,0x0
 900:	70453503          	ld	a0,1796(a0) # 1000 <freep>
 904:	c905                	beqz	a0,934 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 906:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 908:	4798                	lw	a4,8(a5)
 90a:	09377663          	bgeu	a4,s3,996 <malloc+0xb8>
 90e:	f426                	sd	s1,40(sp)
 910:	e852                	sd	s4,16(sp)
 912:	e456                	sd	s5,8(sp)
 914:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 916:	8a4e                	mv	s4,s3
 918:	6705                	lui	a4,0x1
 91a:	00e9f363          	bgeu	s3,a4,920 <malloc+0x42>
 91e:	6a05                	lui	s4,0x1
 920:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 924:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 928:	00000497          	auipc	s1,0x0
 92c:	6d848493          	addi	s1,s1,1752 # 1000 <freep>
  if(p == SBRK_ERROR)
 930:	5afd                	li	s5,-1
 932:	a83d                	j	970 <malloc+0x92>
 934:	f426                	sd	s1,40(sp)
 936:	e852                	sd	s4,16(sp)
 938:	e456                	sd	s5,8(sp)
 93a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 93c:	00001797          	auipc	a5,0x1
 940:	8cc78793          	addi	a5,a5,-1844 # 1208 <base>
 944:	00000717          	auipc	a4,0x0
 948:	6af73e23          	sd	a5,1724(a4) # 1000 <freep>
 94c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 94e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 952:	b7d1                	j	916 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 954:	6398                	ld	a4,0(a5)
 956:	e118                	sd	a4,0(a0)
 958:	a899                	j	9ae <malloc+0xd0>
  hp->s.size = nu;
 95a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 95e:	0541                	addi	a0,a0,16
 960:	ef9ff0ef          	jal	858 <free>
  return freep;
 964:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 966:	c125                	beqz	a0,9c6 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 968:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 96a:	4798                	lw	a4,8(a5)
 96c:	03277163          	bgeu	a4,s2,98e <malloc+0xb0>
    if(p == freep)
 970:	6098                	ld	a4,0(s1)
 972:	853e                	mv	a0,a5
 974:	fef71ae3          	bne	a4,a5,968 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 978:	8552                	mv	a0,s4
 97a:	a1dff0ef          	jal	396 <sbrk>
  if(p == SBRK_ERROR)
 97e:	fd551ee3          	bne	a0,s5,95a <malloc+0x7c>
        return 0;
 982:	4501                	li	a0,0
 984:	74a2                	ld	s1,40(sp)
 986:	6a42                	ld	s4,16(sp)
 988:	6aa2                	ld	s5,8(sp)
 98a:	6b02                	ld	s6,0(sp)
 98c:	a03d                	j	9ba <malloc+0xdc>
 98e:	74a2                	ld	s1,40(sp)
 990:	6a42                	ld	s4,16(sp)
 992:	6aa2                	ld	s5,8(sp)
 994:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 996:	fae90fe3          	beq	s2,a4,954 <malloc+0x76>
        p->s.size -= nunits;
 99a:	4137073b          	subw	a4,a4,s3
 99e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a0:	02071693          	slli	a3,a4,0x20
 9a4:	01c6d713          	srli	a4,a3,0x1c
 9a8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9aa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ae:	00000717          	auipc	a4,0x0
 9b2:	64a73923          	sd	a0,1618(a4) # 1000 <freep>
      return (void*)(p + 1);
 9b6:	01078513          	addi	a0,a5,16
  }
}
 9ba:	70e2                	ld	ra,56(sp)
 9bc:	7442                	ld	s0,48(sp)
 9be:	7902                	ld	s2,32(sp)
 9c0:	69e2                	ld	s3,24(sp)
 9c2:	6121                	addi	sp,sp,64
 9c4:	8082                	ret
 9c6:	74a2                	ld	s1,40(sp)
 9c8:	6a42                	ld	s4,16(sp)
 9ca:	6aa2                	ld	s5,8(sp)
 9cc:	6b02                	ld	s6,0(sp)
 9ce:	b7f5                	j	9ba <malloc+0xdc>
