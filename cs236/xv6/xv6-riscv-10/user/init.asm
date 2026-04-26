
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	ad250513          	addi	a0,a0,-1326 # ae0 <malloc+0xf2>
  16:	526000ef          	jal	53c <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	554000ef          	jal	574 <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	54e000ef          	jal	574 <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	abe90913          	addi	s2,s2,-1346 # ae8 <malloc+0xfa>
  32:	854a                	mv	a0,s2
  34:	103000ef          	jal	936 <printf>
    pid = fork();
  38:	4bc000ef          	jal	4f4 <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	4be000ef          	jal	504 <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	ae650513          	addi	a0,a0,-1306 # b38 <malloc+0x14a>
  5a:	0dd000ef          	jal	936 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	49c000ef          	jal	4fc <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	a7850513          	addi	a0,a0,-1416 # ae0 <malloc+0xf2>
  70:	4d4000ef          	jal	544 <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	a6a50513          	addi	a0,a0,-1430 # ae0 <malloc+0xf2>
  7e:	4be000ef          	jal	53c <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	a7c50513          	addi	a0,a0,-1412 # b00 <malloc+0x112>
  8c:	0ab000ef          	jal	936 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	46a000ef          	jal	4fc <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	a7a50513          	addi	a0,a0,-1414 # b18 <malloc+0x12a>
  a6:	48e000ef          	jal	534 <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	a7650513          	addi	a0,a0,-1418 # b20 <malloc+0x132>
  b2:	085000ef          	jal	936 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	444000ef          	jal	4fc <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  c4:	f3dff0ef          	jal	0 <main>
  exit(r);
  c8:	434000ef          	jal	4fc <exit>

00000000000000cc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d4:	87aa                	mv	a5,a0
  d6:	0585                	addi	a1,a1,1
  d8:	0785                	addi	a5,a5,1
  da:	fff5c703          	lbu	a4,-1(a1)
  de:	fee78fa3          	sb	a4,-1(a5)
  e2:	fb75                	bnez	a4,d6 <strcpy+0xa>
    ;
  return os;
}
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cb91                	beqz	a5,10c <strcmp+0x20>
  fa:	0005c703          	lbu	a4,0(a1)
  fe:	00f71763          	bne	a4,a5,10c <strcmp+0x20>
    p++, q++;
 102:	0505                	addi	a0,a0,1
 104:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbe5                	bnez	a5,fa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 10c:	0005c503          	lbu	a0,0(a1)
}
 110:	40a7853b          	subw	a0,a5,a0
 114:	60a2                	ld	ra,8(sp)
 116:	6402                	ld	s0,0(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strlen>:

uint
strlen(const char *s)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf99                	beqz	a5,146 <strlen+0x2a>
 12a:	0505                	addi	a0,a0,1
 12c:	87aa                	mv	a5,a0
 12e:	86be                	mv	a3,a5
 130:	0785                	addi	a5,a5,1
 132:	fff7c703          	lbu	a4,-1(a5)
 136:	ff65                	bnez	a4,12e <strlen+0x12>
 138:	40a6853b          	subw	a0,a3,a0
 13c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 13e:	60a2                	ld	ra,8(sp)
 140:	6402                	ld	s0,0(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret
  for(n = 0; s[n]; n++)
 146:	4501                	li	a0,0
 148:	bfdd                	j	13e <strlen+0x22>

000000000000014a <memset>:

void*
memset(void *dst, int c, uint n)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 152:	ca19                	beqz	a2,168 <memset+0x1e>
 154:	87aa                	mv	a5,a0
 156:	1602                	slli	a2,a2,0x20
 158:	9201                	srli	a2,a2,0x20
 15a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 15e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 162:	0785                	addi	a5,a5,1
 164:	fee79de3          	bne	a5,a4,15e <memset+0x14>
  }
  return dst;
}
 168:	60a2                	ld	ra,8(sp)
 16a:	6402                	ld	s0,0(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret

0000000000000170 <strchr>:

char*
strchr(const char *s, char c)
{
 170:	1141                	addi	sp,sp,-16
 172:	e406                	sd	ra,8(sp)
 174:	e022                	sd	s0,0(sp)
 176:	0800                	addi	s0,sp,16
  for(; *s; s++)
 178:	00054783          	lbu	a5,0(a0)
 17c:	cf81                	beqz	a5,194 <strchr+0x24>
    if(*s == c)
 17e:	00f58763          	beq	a1,a5,18c <strchr+0x1c>
  for(; *s; s++)
 182:	0505                	addi	a0,a0,1
 184:	00054783          	lbu	a5,0(a0)
 188:	fbfd                	bnez	a5,17e <strchr+0xe>
      return (char*)s;
  return 0;
 18a:	4501                	li	a0,0
}
 18c:	60a2                	ld	ra,8(sp)
 18e:	6402                	ld	s0,0(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret
  return 0;
 194:	4501                	li	a0,0
 196:	bfdd                	j	18c <strchr+0x1c>

0000000000000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	7159                	addi	sp,sp,-112
 19a:	f486                	sd	ra,104(sp)
 19c:	f0a2                	sd	s0,96(sp)
 19e:	eca6                	sd	s1,88(sp)
 1a0:	e8ca                	sd	s2,80(sp)
 1a2:	e4ce                	sd	s3,72(sp)
 1a4:	e0d2                	sd	s4,64(sp)
 1a6:	fc56                	sd	s5,56(sp)
 1a8:	f85a                	sd	s6,48(sp)
 1aa:	f45e                	sd	s7,40(sp)
 1ac:	f062                	sd	s8,32(sp)
 1ae:	ec66                	sd	s9,24(sp)
 1b0:	e86a                	sd	s10,16(sp)
 1b2:	1880                	addi	s0,sp,112
 1b4:	8caa                	mv	s9,a0
 1b6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b8:	892a                	mv	s2,a0
 1ba:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1bc:	f9f40b13          	addi	s6,s0,-97
 1c0:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c2:	4ba9                	li	s7,10
 1c4:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1c6:	8d26                	mv	s10,s1
 1c8:	0014899b          	addiw	s3,s1,1
 1cc:	84ce                	mv	s1,s3
 1ce:	0349d563          	bge	s3,s4,1f8 <gets+0x60>
    cc = read(0, &c, 1);
 1d2:	8656                	mv	a2,s5
 1d4:	85da                	mv	a1,s6
 1d6:	4501                	li	a0,0
 1d8:	33c000ef          	jal	514 <read>
    if(cc < 1)
 1dc:	00a05e63          	blez	a0,1f8 <gets+0x60>
    buf[i++] = c;
 1e0:	f9f44783          	lbu	a5,-97(s0)
 1e4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e8:	01778763          	beq	a5,s7,1f6 <gets+0x5e>
 1ec:	0905                	addi	s2,s2,1
 1ee:	fd879ce3          	bne	a5,s8,1c6 <gets+0x2e>
    buf[i++] = c;
 1f2:	8d4e                	mv	s10,s3
 1f4:	a011                	j	1f8 <gets+0x60>
 1f6:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1f8:	9d66                	add	s10,s10,s9
 1fa:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1fe:	8566                	mv	a0,s9
 200:	70a6                	ld	ra,104(sp)
 202:	7406                	ld	s0,96(sp)
 204:	64e6                	ld	s1,88(sp)
 206:	6946                	ld	s2,80(sp)
 208:	69a6                	ld	s3,72(sp)
 20a:	6a06                	ld	s4,64(sp)
 20c:	7ae2                	ld	s5,56(sp)
 20e:	7b42                	ld	s6,48(sp)
 210:	7ba2                	ld	s7,40(sp)
 212:	7c02                	ld	s8,32(sp)
 214:	6ce2                	ld	s9,24(sp)
 216:	6d42                	ld	s10,16(sp)
 218:	6165                	addi	sp,sp,112
 21a:	8082                	ret

000000000000021c <stat>:

int
stat(const char *n, struct stat *st)
{
 21c:	1101                	addi	sp,sp,-32
 21e:	ec06                	sd	ra,24(sp)
 220:	e822                	sd	s0,16(sp)
 222:	e04a                	sd	s2,0(sp)
 224:	1000                	addi	s0,sp,32
 226:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 228:	4581                	li	a1,0
 22a:	312000ef          	jal	53c <open>
  if(fd < 0)
 22e:	02054263          	bltz	a0,252 <stat+0x36>
 232:	e426                	sd	s1,8(sp)
 234:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 236:	85ca                	mv	a1,s2
 238:	31c000ef          	jal	554 <fstat>
 23c:	892a                	mv	s2,a0
  close(fd);
 23e:	8526                	mv	a0,s1
 240:	2e4000ef          	jal	524 <close>
  return r;
 244:	64a2                	ld	s1,8(sp)
}
 246:	854a                	mv	a0,s2
 248:	60e2                	ld	ra,24(sp)
 24a:	6442                	ld	s0,16(sp)
 24c:	6902                	ld	s2,0(sp)
 24e:	6105                	addi	sp,sp,32
 250:	8082                	ret
    return -1;
 252:	597d                	li	s2,-1
 254:	bfcd                	j	246 <stat+0x2a>

0000000000000256 <atoi>:

int
atoi(const char *s)
{
 256:	1141                	addi	sp,sp,-16
 258:	e406                	sd	ra,8(sp)
 25a:	e022                	sd	s0,0(sp)
 25c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25e:	00054683          	lbu	a3,0(a0)
 262:	fd06879b          	addiw	a5,a3,-48
 266:	0ff7f793          	zext.b	a5,a5
 26a:	4625                	li	a2,9
 26c:	02f66963          	bltu	a2,a5,29e <atoi+0x48>
 270:	872a                	mv	a4,a0
  n = 0;
 272:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 274:	0705                	addi	a4,a4,1
 276:	0025179b          	slliw	a5,a0,0x2
 27a:	9fa9                	addw	a5,a5,a0
 27c:	0017979b          	slliw	a5,a5,0x1
 280:	9fb5                	addw	a5,a5,a3
 282:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 286:	00074683          	lbu	a3,0(a4)
 28a:	fd06879b          	addiw	a5,a3,-48
 28e:	0ff7f793          	zext.b	a5,a5
 292:	fef671e3          	bgeu	a2,a5,274 <atoi+0x1e>
  return n;
}
 296:	60a2                	ld	ra,8(sp)
 298:	6402                	ld	s0,0(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  n = 0;
 29e:	4501                	li	a0,0
 2a0:	bfdd                	j	296 <atoi+0x40>

00000000000002a2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2aa:	02b57563          	bgeu	a0,a1,2d4 <memmove+0x32>
    while(n-- > 0)
 2ae:	00c05f63          	blez	a2,2cc <memmove+0x2a>
 2b2:	1602                	slli	a2,a2,0x20
 2b4:	9201                	srli	a2,a2,0x20
 2b6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ba:	872a                	mv	a4,a0
      *dst++ = *src++;
 2bc:	0585                	addi	a1,a1,1
 2be:	0705                	addi	a4,a4,1
 2c0:	fff5c683          	lbu	a3,-1(a1)
 2c4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c8:	fee79ae3          	bne	a5,a4,2bc <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2cc:	60a2                	ld	ra,8(sp)
 2ce:	6402                	ld	s0,0(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
    dst += n;
 2d4:	00c50733          	add	a4,a0,a2
    src += n;
 2d8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2da:	fec059e3          	blez	a2,2cc <memmove+0x2a>
 2de:	fff6079b          	addiw	a5,a2,-1
 2e2:	1782                	slli	a5,a5,0x20
 2e4:	9381                	srli	a5,a5,0x20
 2e6:	fff7c793          	not	a5,a5
 2ea:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ec:	15fd                	addi	a1,a1,-1
 2ee:	177d                	addi	a4,a4,-1
 2f0:	0005c683          	lbu	a3,0(a1)
 2f4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f8:	fef71ae3          	bne	a4,a5,2ec <memmove+0x4a>
 2fc:	bfc1                	j	2cc <memmove+0x2a>

00000000000002fe <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 306:	ca0d                	beqz	a2,338 <memcmp+0x3a>
 308:	fff6069b          	addiw	a3,a2,-1
 30c:	1682                	slli	a3,a3,0x20
 30e:	9281                	srli	a3,a3,0x20
 310:	0685                	addi	a3,a3,1
 312:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 314:	00054783          	lbu	a5,0(a0)
 318:	0005c703          	lbu	a4,0(a1)
 31c:	00e79863          	bne	a5,a4,32c <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 320:	0505                	addi	a0,a0,1
    p2++;
 322:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 324:	fed518e3          	bne	a0,a3,314 <memcmp+0x16>
  }
  return 0;
 328:	4501                	li	a0,0
 32a:	a019                	j	330 <memcmp+0x32>
      return *p1 - *p2;
 32c:	40e7853b          	subw	a0,a5,a4
}
 330:	60a2                	ld	ra,8(sp)
 332:	6402                	ld	s0,0(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret
  return 0;
 338:	4501                	li	a0,0
 33a:	bfdd                	j	330 <memcmp+0x32>

000000000000033c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e406                	sd	ra,8(sp)
 340:	e022                	sd	s0,0(sp)
 342:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 344:	f5fff0ef          	jal	2a2 <memmove>
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret

0000000000000350 <sbrk>:

char *
sbrk(int n) {
 350:	1141                	addi	sp,sp,-16
 352:	e406                	sd	ra,8(sp)
 354:	e022                	sd	s0,0(sp)
 356:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 358:	4585                	li	a1,1
 35a:	22a000ef          	jal	584 <sys_sbrk>
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret

0000000000000366 <sbrklazy>:

char *
sbrklazy(int n) {
 366:	1141                	addi	sp,sp,-16
 368:	e406                	sd	ra,8(sp)
 36a:	e022                	sd	s0,0(sp)
 36c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 36e:	4589                	li	a1,2
 370:	214000ef          	jal	584 <sys_sbrk>
}
 374:	60a2                	ld	ra,8(sp)
 376:	6402                	ld	s0,0(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret

000000000000037c <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 37c:	1101                	addi	sp,sp,-32
 37e:	ec06                	sd	ra,24(sp)
 380:	e822                	sd	s0,16(sp)
 382:	e426                	sd	s1,8(sp)
 384:	e04a                	sd	s2,0(sp)
 386:	1000                	addi	s0,sp,32
 388:	84aa                	mv	s1,a0
 38a:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 38c:	6505                	lui	a0,0x1
 38e:	fc3ff0ef          	jal	350 <sbrk>
 392:	6785                	lui	a5,0x1
 394:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 398:	9a41                	andi	a2,a2,-16
 39a:	85ca                	mv	a1,s2
 39c:	8526                	mv	a0,s1
 39e:	1fe000ef          	jal	59c <clone>
}
 3a2:	60e2                	ld	ra,24(sp)
 3a4:	6442                	ld	s0,16(sp)
 3a6:	64a2                	ld	s1,8(sp)
 3a8:	6902                	ld	s2,0(sp)
 3aa:	6105                	addi	sp,sp,32
 3ac:	8082                	ret

00000000000003ae <futex>:

void futex(int *uaddr, int ops, int val) {
 3ae:	7179                	addi	sp,sp,-48
 3b0:	f406                	sd	ra,40(sp)
 3b2:	f022                	sd	s0,32(sp)
 3b4:	ec26                	sd	s1,24(sp)
 3b6:	1800                	addi	s0,sp,48
 3b8:	84aa                	mv	s1,a0
  if (ops==0) {
 3ba:	ed95                	bnez	a1,3f6 <futex+0x48>
    if (val==0) {
 3bc:	c611                	beqz	a2,3c8 <futex+0x1a>
 3be:	e84a                	sd	s2,16(sp)
 3c0:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 3c2:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 3c4:	4985                	li	s3,1
 3c6:	a005                	j	3e6 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 3c8:	4705                	li	a4,1
 3ca:	87ba                	mv	a5,a4
 3cc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 3d0:	2781                	sext.w	a5,a5
 3d2:	ffe5                	bnez	a5,3ca <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 3d4:	70a2                	ld	ra,40(sp)
 3d6:	7402                	ld	s0,32(sp)
 3d8:	64e2                	ld	s1,24(sp)
 3da:	6145                	addi	sp,sp,48
 3dc:	8082                	ret
        futex_wait(uaddr, 1);
 3de:	85ce                	mv	a1,s3
 3e0:	8526                	mv	a0,s1
 3e2:	1ca000ef          	jal	5ac <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 3e6:	87ca                	mv	a5,s2
 3e8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 3ec:	2781                	sext.w	a5,a5
 3ee:	fbe5                	bnez	a5,3de <futex+0x30>
 3f0:	6942                	ld	s2,16(sp)
 3f2:	69a2                	ld	s3,8(sp)
 3f4:	b7c5                	j	3d4 <futex+0x26>
    if (val==0) {
 3f6:	e611                	bnez	a2,402 <futex+0x54>
      __sync_lock_release(uaddr);
 3f8:	0310000f          	fence	rw,w
 3fc:	00052023          	sw	zero,0(a0) # 1000 <argv>
 400:	bfd1                	j	3d4 <futex+0x26>
      __sync_lock_release(uaddr);
 402:	0310000f          	fence	rw,w
 406:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 40a:	1aa000ef          	jal	5b4 <futex_wake>
  return;
 40e:	b7d9                	j	3d4 <futex+0x26>

0000000000000410 <sem_init>:

void sem_init(sem_t* s, int val) {
 410:	7179                	addi	sp,sp,-48
 412:	f406                	sd	ra,40(sp)
 414:	f022                	sd	s0,32(sp)
 416:	ec26                	sd	s1,24(sp)
 418:	e84a                	sd	s2,16(sp)
 41a:	e44e                	sd	s3,8(sp)
 41c:	1800                	addi	s0,sp,48
 41e:	84aa                	mv	s1,a0
 420:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 422:	00450993          	addi	s3,a0,4
 426:	4605                	li	a2,1
 428:	4581                	li	a1,0
 42a:	854e                	mv	a0,s3
 42c:	f83ff0ef          	jal	3ae <futex>
  s->value = val;
 430:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 434:	4605                	li	a2,1
 436:	85b2                	mv	a1,a2
 438:	854e                	mv	a0,s3
 43a:	f75ff0ef          	jal	3ae <futex>
  return;
}
 43e:	70a2                	ld	ra,40(sp)
 440:	7402                	ld	s0,32(sp)
 442:	64e2                	ld	s1,24(sp)
 444:	6942                	ld	s2,16(sp)
 446:	69a2                	ld	s3,8(sp)
 448:	6145                	addi	sp,sp,48
 44a:	8082                	ret

000000000000044c <sem_down>:

void sem_down(sem_t* s) {
 44c:	7179                	addi	sp,sp,-48
 44e:	f406                	sd	ra,40(sp)
 450:	f022                	sd	s0,32(sp)
 452:	ec26                	sd	s1,24(sp)
 454:	e84a                	sd	s2,16(sp)
 456:	e44e                	sd	s3,8(sp)
 458:	1800                	addi	s0,sp,48
 45a:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 45c:	00450993          	addi	s3,a0,4
 460:	4605                	li	a2,1
 462:	4581                	li	a1,0
 464:	854e                	mv	a0,s3
 466:	f49ff0ef          	jal	3ae <futex>
  while(1) {
    if (s->value>0) {
 46a:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 46e:	4485                	li	s1,1
    if (s->value>0) {
 470:	02f04463          	bgtz	a5,498 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 474:	8626                	mv	a2,s1
 476:	85a6                	mv	a1,s1
 478:	854e                	mv	a0,s3
 47a:	f35ff0ef          	jal	3ae <futex>
      futex_wait(&s->value,1);
 47e:	85a6                	mv	a1,s1
 480:	854a                	mv	a0,s2
 482:	12a000ef          	jal	5ac <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 486:	8626                	mv	a2,s1
 488:	4581                	li	a1,0
 48a:	854e                	mv	a0,s3
 48c:	f23ff0ef          	jal	3ae <futex>
    if (s->value>0) {
 490:	00092783          	lw	a5,0(s2)
 494:	fef050e3          	blez	a5,474 <sem_down+0x28>
      s->value--;
 498:	37fd                	addiw	a5,a5,-1 # fff <digits+0x49f>
 49a:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 49e:	4605                	li	a2,1
 4a0:	85b2                	mv	a1,a2
 4a2:	854e                	mv	a0,s3
 4a4:	f0bff0ef          	jal	3ae <futex>
  return;
}
 4a8:	70a2                	ld	ra,40(sp)
 4aa:	7402                	ld	s0,32(sp)
 4ac:	64e2                	ld	s1,24(sp)
 4ae:	6942                	ld	s2,16(sp)
 4b0:	69a2                	ld	s3,8(sp)
 4b2:	6145                	addi	sp,sp,48
 4b4:	8082                	ret

00000000000004b6 <sem_up>:

void sem_up(sem_t* s) {
 4b6:	1101                	addi	sp,sp,-32
 4b8:	ec06                	sd	ra,24(sp)
 4ba:	e822                	sd	s0,16(sp)
 4bc:	e426                	sd	s1,8(sp)
 4be:	e04a                	sd	s2,0(sp)
 4c0:	1000                	addi	s0,sp,32
 4c2:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 4c4:	00450913          	addi	s2,a0,4
 4c8:	4605                	li	a2,1
 4ca:	4581                	li	a1,0
 4cc:	854a                	mv	a0,s2
 4ce:	ee1ff0ef          	jal	3ae <futex>
  s->value++;
 4d2:	409c                	lw	a5,0(s1)
 4d4:	2785                	addiw	a5,a5,1
 4d6:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 4d8:	8526                	mv	a0,s1
 4da:	0da000ef          	jal	5b4 <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4de:	4605                	li	a2,1
 4e0:	85b2                	mv	a1,a2
 4e2:	854a                	mv	a0,s2
 4e4:	ecbff0ef          	jal	3ae <futex>
  return;
 4e8:	60e2                	ld	ra,24(sp)
 4ea:	6442                	ld	s0,16(sp)
 4ec:	64a2                	ld	s1,8(sp)
 4ee:	6902                	ld	s2,0(sp)
 4f0:	6105                	addi	sp,sp,32
 4f2:	8082                	ret

00000000000004f4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4f4:	4885                	li	a7,1
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <exit>:
.global exit
exit:
 li a7, SYS_exit
 4fc:	4889                	li	a7,2
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <wait>:
.global wait
wait:
 li a7, SYS_wait
 504:	488d                	li	a7,3
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 50c:	4891                	li	a7,4
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <read>:
.global read
read:
 li a7, SYS_read
 514:	4895                	li	a7,5
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <write>:
.global write
write:
 li a7, SYS_write
 51c:	48c1                	li	a7,16
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <close>:
.global close
close:
 li a7, SYS_close
 524:	48d5                	li	a7,21
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <kill>:
.global kill
kill:
 li a7, SYS_kill
 52c:	4899                	li	a7,6
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <exec>:
.global exec
exec:
 li a7, SYS_exec
 534:	489d                	li	a7,7
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <open>:
.global open
open:
 li a7, SYS_open
 53c:	48bd                	li	a7,15
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 544:	48c5                	li	a7,17
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 54c:	48c9                	li	a7,18
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 554:	48a1                	li	a7,8
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <link>:
.global link
link:
 li a7, SYS_link
 55c:	48cd                	li	a7,19
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 564:	48d1                	li	a7,20
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 56c:	48a5                	li	a7,9
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <dup>:
.global dup
dup:
 li a7, SYS_dup
 574:	48a9                	li	a7,10
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 57c:	48ad                	li	a7,11
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 584:	48b1                	li	a7,12
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <pause>:
.global pause
pause:
 li a7, SYS_pause
 58c:	48b5                	li	a7,13
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 594:	48b9                	li	a7,14
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <clone>:
.global clone
clone:
 li a7, SYS_clone
 59c:	48d9                	li	a7,22
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <join>:
.global join
join:
 li a7, SYS_join
 5a4:	48dd                	li	a7,23
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 5ac:	48e1                	li	a7,24
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 5b4:	48e5                	li	a7,25
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5bc:	1101                	addi	sp,sp,-32
 5be:	ec06                	sd	ra,24(sp)
 5c0:	e822                	sd	s0,16(sp)
 5c2:	1000                	addi	s0,sp,32
 5c4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5c8:	4605                	li	a2,1
 5ca:	fef40593          	addi	a1,s0,-17
 5ce:	f4fff0ef          	jal	51c <write>
}
 5d2:	60e2                	ld	ra,24(sp)
 5d4:	6442                	ld	s0,16(sp)
 5d6:	6105                	addi	sp,sp,32
 5d8:	8082                	ret

00000000000005da <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5da:	715d                	addi	sp,sp,-80
 5dc:	e486                	sd	ra,72(sp)
 5de:	e0a2                	sd	s0,64(sp)
 5e0:	fc26                	sd	s1,56(sp)
 5e2:	f84a                	sd	s2,48(sp)
 5e4:	f44e                	sd	s3,40(sp)
 5e6:	0880                	addi	s0,sp,80
 5e8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5ea:	c299                	beqz	a3,5f0 <printint+0x16>
 5ec:	0605cc63          	bltz	a1,664 <printint+0x8a>
  neg = 0;
 5f0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5f2:	fb840313          	addi	t1,s0,-72
  neg = 0;
 5f6:	869a                	mv	a3,t1
  i = 0;
 5f8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5fa:	00000817          	auipc	a6,0x0
 5fe:	56680813          	addi	a6,a6,1382 # b60 <digits>
 602:	88be                	mv	a7,a5
 604:	0017851b          	addiw	a0,a5,1
 608:	87aa                	mv	a5,a0
 60a:	02c5f733          	remu	a4,a1,a2
 60e:	9742                	add	a4,a4,a6
 610:	00074703          	lbu	a4,0(a4)
 614:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 618:	872e                	mv	a4,a1
 61a:	02c5d5b3          	divu	a1,a1,a2
 61e:	0685                	addi	a3,a3,1
 620:	fec771e3          	bgeu	a4,a2,602 <printint+0x28>
  if(neg)
 624:	000e0c63          	beqz	t3,63c <printint+0x62>
    buf[i++] = '-';
 628:	fd050793          	addi	a5,a0,-48
 62c:	00878533          	add	a0,a5,s0
 630:	02d00793          	li	a5,45
 634:	fef50423          	sb	a5,-24(a0)
 638:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 63c:	fff7899b          	addiw	s3,a5,-1
 640:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 644:	fff4c583          	lbu	a1,-1(s1)
 648:	854a                	mv	a0,s2
 64a:	f73ff0ef          	jal	5bc <putc>
  while(--i >= 0)
 64e:	39fd                	addiw	s3,s3,-1
 650:	14fd                	addi	s1,s1,-1
 652:	fe09d9e3          	bgez	s3,644 <printint+0x6a>
}
 656:	60a6                	ld	ra,72(sp)
 658:	6406                	ld	s0,64(sp)
 65a:	74e2                	ld	s1,56(sp)
 65c:	7942                	ld	s2,48(sp)
 65e:	79a2                	ld	s3,40(sp)
 660:	6161                	addi	sp,sp,80
 662:	8082                	ret
    x = -xx;
 664:	40b005b3          	neg	a1,a1
    neg = 1;
 668:	4e05                	li	t3,1
    x = -xx;
 66a:	b761                	j	5f2 <printint+0x18>

000000000000066c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 66c:	711d                	addi	sp,sp,-96
 66e:	ec86                	sd	ra,88(sp)
 670:	e8a2                	sd	s0,80(sp)
 672:	e4a6                	sd	s1,72(sp)
 674:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 676:	0005c483          	lbu	s1,0(a1)
 67a:	28048463          	beqz	s1,902 <vprintf+0x296>
 67e:	e0ca                	sd	s2,64(sp)
 680:	fc4e                	sd	s3,56(sp)
 682:	f852                	sd	s4,48(sp)
 684:	f456                	sd	s5,40(sp)
 686:	f05a                	sd	s6,32(sp)
 688:	ec5e                	sd	s7,24(sp)
 68a:	e862                	sd	s8,16(sp)
 68c:	e466                	sd	s9,8(sp)
 68e:	8b2a                	mv	s6,a0
 690:	8a2e                	mv	s4,a1
 692:	8bb2                	mv	s7,a2
  state = 0;
 694:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 696:	4901                	li	s2,0
 698:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 69a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 69e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6a2:	06c00c93          	li	s9,108
 6a6:	a00d                	j	6c8 <vprintf+0x5c>
        putc(fd, c0);
 6a8:	85a6                	mv	a1,s1
 6aa:	855a                	mv	a0,s6
 6ac:	f11ff0ef          	jal	5bc <putc>
 6b0:	a019                	j	6b6 <vprintf+0x4a>
    } else if(state == '%'){
 6b2:	03598363          	beq	s3,s5,6d8 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6b6:	0019079b          	addiw	a5,s2,1
 6ba:	893e                	mv	s2,a5
 6bc:	873e                	mv	a4,a5
 6be:	97d2                	add	a5,a5,s4
 6c0:	0007c483          	lbu	s1,0(a5)
 6c4:	22048763          	beqz	s1,8f2 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 6c8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6cc:	fe0993e3          	bnez	s3,6b2 <vprintf+0x46>
      if(c0 == '%'){
 6d0:	fd579ce3          	bne	a5,s5,6a8 <vprintf+0x3c>
        state = '%';
 6d4:	89be                	mv	s3,a5
 6d6:	b7c5                	j	6b6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6d8:	00ea06b3          	add	a3,s4,a4
 6dc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6e0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6e2:	c681                	beqz	a3,6ea <vprintf+0x7e>
 6e4:	9752                	add	a4,a4,s4
 6e6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6ea:	05878263          	beq	a5,s8,72e <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6ee:	05978c63          	beq	a5,s9,746 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6f2:	07500713          	li	a4,117
 6f6:	0ee78663          	beq	a5,a4,7e2 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6fa:	07800713          	li	a4,120
 6fe:	12e78863          	beq	a5,a4,82e <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 702:	07000713          	li	a4,112
 706:	14e78d63          	beq	a5,a4,860 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 70a:	06300713          	li	a4,99
 70e:	18e78c63          	beq	a5,a4,8a6 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 712:	07300713          	li	a4,115
 716:	1ae78263          	beq	a5,a4,8ba <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 71a:	02500713          	li	a4,37
 71e:	04e79463          	bne	a5,a4,766 <vprintf+0xfa>
        putc(fd, '%');
 722:	85ba                	mv	a1,a4
 724:	855a                	mv	a0,s6
 726:	e97ff0ef          	jal	5bc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 72a:	4981                	li	s3,0
 72c:	b769                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 72e:	008b8493          	addi	s1,s7,8
 732:	4685                	li	a3,1
 734:	4629                	li	a2,10
 736:	000ba583          	lw	a1,0(s7)
 73a:	855a                	mv	a0,s6
 73c:	e9fff0ef          	jal	5da <printint>
 740:	8ba6                	mv	s7,s1
      state = 0;
 742:	4981                	li	s3,0
 744:	bf8d                	j	6b6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 746:	06400793          	li	a5,100
 74a:	02f68963          	beq	a3,a5,77c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 74e:	06c00793          	li	a5,108
 752:	04f68263          	beq	a3,a5,796 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 756:	07500793          	li	a5,117
 75a:	0af68063          	beq	a3,a5,7fa <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 75e:	07800793          	li	a5,120
 762:	0ef68263          	beq	a3,a5,846 <vprintf+0x1da>
        putc(fd, '%');
 766:	02500593          	li	a1,37
 76a:	855a                	mv	a0,s6
 76c:	e51ff0ef          	jal	5bc <putc>
        putc(fd, c0);
 770:	85a6                	mv	a1,s1
 772:	855a                	mv	a0,s6
 774:	e49ff0ef          	jal	5bc <putc>
      state = 0;
 778:	4981                	li	s3,0
 77a:	bf35                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 77c:	008b8493          	addi	s1,s7,8
 780:	4685                	li	a3,1
 782:	4629                	li	a2,10
 784:	000bb583          	ld	a1,0(s7)
 788:	855a                	mv	a0,s6
 78a:	e51ff0ef          	jal	5da <printint>
        i += 1;
 78e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 790:	8ba6                	mv	s7,s1
      state = 0;
 792:	4981                	li	s3,0
        i += 1;
 794:	b70d                	j	6b6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 796:	06400793          	li	a5,100
 79a:	02f60763          	beq	a2,a5,7c8 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 79e:	07500793          	li	a5,117
 7a2:	06f60963          	beq	a2,a5,814 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7a6:	07800793          	li	a5,120
 7aa:	faf61ee3          	bne	a2,a5,766 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ae:	008b8493          	addi	s1,s7,8
 7b2:	4681                	li	a3,0
 7b4:	4641                	li	a2,16
 7b6:	000bb583          	ld	a1,0(s7)
 7ba:	855a                	mv	a0,s6
 7bc:	e1fff0ef          	jal	5da <printint>
        i += 2;
 7c0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c2:	8ba6                	mv	s7,s1
      state = 0;
 7c4:	4981                	li	s3,0
        i += 2;
 7c6:	bdc5                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c8:	008b8493          	addi	s1,s7,8
 7cc:	4685                	li	a3,1
 7ce:	4629                	li	a2,10
 7d0:	000bb583          	ld	a1,0(s7)
 7d4:	855a                	mv	a0,s6
 7d6:	e05ff0ef          	jal	5da <printint>
        i += 2;
 7da:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7dc:	8ba6                	mv	s7,s1
      state = 0;
 7de:	4981                	li	s3,0
        i += 2;
 7e0:	bdd9                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7e2:	008b8493          	addi	s1,s7,8
 7e6:	4681                	li	a3,0
 7e8:	4629                	li	a2,10
 7ea:	000be583          	lwu	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	debff0ef          	jal	5da <printint>
 7f4:	8ba6                	mv	s7,s1
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	bd7d                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fa:	008b8493          	addi	s1,s7,8
 7fe:	4681                	li	a3,0
 800:	4629                	li	a2,10
 802:	000bb583          	ld	a1,0(s7)
 806:	855a                	mv	a0,s6
 808:	dd3ff0ef          	jal	5da <printint>
        i += 1;
 80c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 80e:	8ba6                	mv	s7,s1
      state = 0;
 810:	4981                	li	s3,0
        i += 1;
 812:	b555                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 814:	008b8493          	addi	s1,s7,8
 818:	4681                	li	a3,0
 81a:	4629                	li	a2,10
 81c:	000bb583          	ld	a1,0(s7)
 820:	855a                	mv	a0,s6
 822:	db9ff0ef          	jal	5da <printint>
        i += 2;
 826:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 828:	8ba6                	mv	s7,s1
      state = 0;
 82a:	4981                	li	s3,0
        i += 2;
 82c:	b569                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 82e:	008b8493          	addi	s1,s7,8
 832:	4681                	li	a3,0
 834:	4641                	li	a2,16
 836:	000be583          	lwu	a1,0(s7)
 83a:	855a                	mv	a0,s6
 83c:	d9fff0ef          	jal	5da <printint>
 840:	8ba6                	mv	s7,s1
      state = 0;
 842:	4981                	li	s3,0
 844:	bd8d                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 846:	008b8493          	addi	s1,s7,8
 84a:	4681                	li	a3,0
 84c:	4641                	li	a2,16
 84e:	000bb583          	ld	a1,0(s7)
 852:	855a                	mv	a0,s6
 854:	d87ff0ef          	jal	5da <printint>
        i += 1;
 858:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 85a:	8ba6                	mv	s7,s1
      state = 0;
 85c:	4981                	li	s3,0
        i += 1;
 85e:	bda1                	j	6b6 <vprintf+0x4a>
 860:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 862:	008b8d13          	addi	s10,s7,8
 866:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 86a:	03000593          	li	a1,48
 86e:	855a                	mv	a0,s6
 870:	d4dff0ef          	jal	5bc <putc>
  putc(fd, 'x');
 874:	07800593          	li	a1,120
 878:	855a                	mv	a0,s6
 87a:	d43ff0ef          	jal	5bc <putc>
 87e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 880:	00000b97          	auipc	s7,0x0
 884:	2e0b8b93          	addi	s7,s7,736 # b60 <digits>
 888:	03c9d793          	srli	a5,s3,0x3c
 88c:	97de                	add	a5,a5,s7
 88e:	0007c583          	lbu	a1,0(a5)
 892:	855a                	mv	a0,s6
 894:	d29ff0ef          	jal	5bc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 898:	0992                	slli	s3,s3,0x4
 89a:	34fd                	addiw	s1,s1,-1
 89c:	f4f5                	bnez	s1,888 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 89e:	8bea                	mv	s7,s10
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	6d02                	ld	s10,0(sp)
 8a4:	bd09                	j	6b6 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 8a6:	008b8493          	addi	s1,s7,8
 8aa:	000bc583          	lbu	a1,0(s7)
 8ae:	855a                	mv	a0,s6
 8b0:	d0dff0ef          	jal	5bc <putc>
 8b4:	8ba6                	mv	s7,s1
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	bbfd                	j	6b6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8ba:	008b8993          	addi	s3,s7,8
 8be:	000bb483          	ld	s1,0(s7)
 8c2:	cc91                	beqz	s1,8de <vprintf+0x272>
        for(; *s; s++)
 8c4:	0004c583          	lbu	a1,0(s1)
 8c8:	c195                	beqz	a1,8ec <vprintf+0x280>
          putc(fd, *s);
 8ca:	855a                	mv	a0,s6
 8cc:	cf1ff0ef          	jal	5bc <putc>
        for(; *s; s++)
 8d0:	0485                	addi	s1,s1,1
 8d2:	0004c583          	lbu	a1,0(s1)
 8d6:	f9f5                	bnez	a1,8ca <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 8d8:	8bce                	mv	s7,s3
      state = 0;
 8da:	4981                	li	s3,0
 8dc:	bbe9                	j	6b6 <vprintf+0x4a>
          s = "(null)";
 8de:	00000497          	auipc	s1,0x0
 8e2:	27a48493          	addi	s1,s1,634 # b58 <malloc+0x16a>
        for(; *s; s++)
 8e6:	02800593          	li	a1,40
 8ea:	b7c5                	j	8ca <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 8ec:	8bce                	mv	s7,s3
      state = 0;
 8ee:	4981                	li	s3,0
 8f0:	b3d9                	j	6b6 <vprintf+0x4a>
 8f2:	6906                	ld	s2,64(sp)
 8f4:	79e2                	ld	s3,56(sp)
 8f6:	7a42                	ld	s4,48(sp)
 8f8:	7aa2                	ld	s5,40(sp)
 8fa:	7b02                	ld	s6,32(sp)
 8fc:	6be2                	ld	s7,24(sp)
 8fe:	6c42                	ld	s8,16(sp)
 900:	6ca2                	ld	s9,8(sp)
    }
  }
}
 902:	60e6                	ld	ra,88(sp)
 904:	6446                	ld	s0,80(sp)
 906:	64a6                	ld	s1,72(sp)
 908:	6125                	addi	sp,sp,96
 90a:	8082                	ret

000000000000090c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 90c:	715d                	addi	sp,sp,-80
 90e:	ec06                	sd	ra,24(sp)
 910:	e822                	sd	s0,16(sp)
 912:	1000                	addi	s0,sp,32
 914:	e010                	sd	a2,0(s0)
 916:	e414                	sd	a3,8(s0)
 918:	e818                	sd	a4,16(s0)
 91a:	ec1c                	sd	a5,24(s0)
 91c:	03043023          	sd	a6,32(s0)
 920:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 924:	8622                	mv	a2,s0
 926:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 92a:	d43ff0ef          	jal	66c <vprintf>
}
 92e:	60e2                	ld	ra,24(sp)
 930:	6442                	ld	s0,16(sp)
 932:	6161                	addi	sp,sp,80
 934:	8082                	ret

0000000000000936 <printf>:

void
printf(const char *fmt, ...)
{
 936:	711d                	addi	sp,sp,-96
 938:	ec06                	sd	ra,24(sp)
 93a:	e822                	sd	s0,16(sp)
 93c:	1000                	addi	s0,sp,32
 93e:	e40c                	sd	a1,8(s0)
 940:	e810                	sd	a2,16(s0)
 942:	ec14                	sd	a3,24(s0)
 944:	f018                	sd	a4,32(s0)
 946:	f41c                	sd	a5,40(s0)
 948:	03043823          	sd	a6,48(s0)
 94c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 950:	00840613          	addi	a2,s0,8
 954:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 958:	85aa                	mv	a1,a0
 95a:	4505                	li	a0,1
 95c:	d11ff0ef          	jal	66c <vprintf>
}
 960:	60e2                	ld	ra,24(sp)
 962:	6442                	ld	s0,16(sp)
 964:	6125                	addi	sp,sp,96
 966:	8082                	ret

0000000000000968 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 968:	1141                	addi	sp,sp,-16
 96a:	e406                	sd	ra,8(sp)
 96c:	e022                	sd	s0,0(sp)
 96e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 970:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 974:	00000797          	auipc	a5,0x0
 978:	69c7b783          	ld	a5,1692(a5) # 1010 <freep>
 97c:	a02d                	j	9a6 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 97e:	4618                	lw	a4,8(a2)
 980:	9f2d                	addw	a4,a4,a1
 982:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 986:	6398                	ld	a4,0(a5)
 988:	6310                	ld	a2,0(a4)
 98a:	a83d                	j	9c8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 98c:	ff852703          	lw	a4,-8(a0)
 990:	9f31                	addw	a4,a4,a2
 992:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 994:	ff053683          	ld	a3,-16(a0)
 998:	a091                	j	9dc <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99a:	6398                	ld	a4,0(a5)
 99c:	00e7e463          	bltu	a5,a4,9a4 <free+0x3c>
 9a0:	00e6ea63          	bltu	a3,a4,9b4 <free+0x4c>
{
 9a4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a6:	fed7fae3          	bgeu	a5,a3,99a <free+0x32>
 9aa:	6398                	ld	a4,0(a5)
 9ac:	00e6e463          	bltu	a3,a4,9b4 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b0:	fee7eae3          	bltu	a5,a4,9a4 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9b4:	ff852583          	lw	a1,-8(a0)
 9b8:	6390                	ld	a2,0(a5)
 9ba:	02059813          	slli	a6,a1,0x20
 9be:	01c85713          	srli	a4,a6,0x1c
 9c2:	9736                	add	a4,a4,a3
 9c4:	fae60de3          	beq	a2,a4,97e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9c8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9cc:	4790                	lw	a2,8(a5)
 9ce:	02061593          	slli	a1,a2,0x20
 9d2:	01c5d713          	srli	a4,a1,0x1c
 9d6:	973e                	add	a4,a4,a5
 9d8:	fae68ae3          	beq	a3,a4,98c <free+0x24>
    p->s.ptr = bp->s.ptr;
 9dc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9de:	00000717          	auipc	a4,0x0
 9e2:	62f73923          	sd	a5,1586(a4) # 1010 <freep>
}
 9e6:	60a2                	ld	ra,8(sp)
 9e8:	6402                	ld	s0,0(sp)
 9ea:	0141                	addi	sp,sp,16
 9ec:	8082                	ret

00000000000009ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ee:	7139                	addi	sp,sp,-64
 9f0:	fc06                	sd	ra,56(sp)
 9f2:	f822                	sd	s0,48(sp)
 9f4:	f04a                	sd	s2,32(sp)
 9f6:	ec4e                	sd	s3,24(sp)
 9f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9fa:	02051993          	slli	s3,a0,0x20
 9fe:	0209d993          	srli	s3,s3,0x20
 a02:	09bd                	addi	s3,s3,15
 a04:	0049d993          	srli	s3,s3,0x4
 a08:	2985                	addiw	s3,s3,1
 a0a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a0c:	00000517          	auipc	a0,0x0
 a10:	60453503          	ld	a0,1540(a0) # 1010 <freep>
 a14:	c905                	beqz	a0,a44 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a16:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a18:	4798                	lw	a4,8(a5)
 a1a:	09377663          	bgeu	a4,s3,aa6 <malloc+0xb8>
 a1e:	f426                	sd	s1,40(sp)
 a20:	e852                	sd	s4,16(sp)
 a22:	e456                	sd	s5,8(sp)
 a24:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a26:	8a4e                	mv	s4,s3
 a28:	6705                	lui	a4,0x1
 a2a:	00e9f363          	bgeu	s3,a4,a30 <malloc+0x42>
 a2e:	6a05                	lui	s4,0x1
 a30:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a34:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a38:	00000497          	auipc	s1,0x0
 a3c:	5d848493          	addi	s1,s1,1496 # 1010 <freep>
  if(p == SBRK_ERROR)
 a40:	5afd                	li	s5,-1
 a42:	a83d                	j	a80 <malloc+0x92>
 a44:	f426                	sd	s1,40(sp)
 a46:	e852                	sd	s4,16(sp)
 a48:	e456                	sd	s5,8(sp)
 a4a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a4c:	00000797          	auipc	a5,0x0
 a50:	5d478793          	addi	a5,a5,1492 # 1020 <base>
 a54:	00000717          	auipc	a4,0x0
 a58:	5af73e23          	sd	a5,1468(a4) # 1010 <freep>
 a5c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a5e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a62:	b7d1                	j	a26 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a64:	6398                	ld	a4,0(a5)
 a66:	e118                	sd	a4,0(a0)
 a68:	a899                	j	abe <malloc+0xd0>
  hp->s.size = nu;
 a6a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a6e:	0541                	addi	a0,a0,16
 a70:	ef9ff0ef          	jal	968 <free>
  return freep;
 a74:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a76:	c125                	beqz	a0,ad6 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a78:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a7a:	4798                	lw	a4,8(a5)
 a7c:	03277163          	bgeu	a4,s2,a9e <malloc+0xb0>
    if(p == freep)
 a80:	6098                	ld	a4,0(s1)
 a82:	853e                	mv	a0,a5
 a84:	fef71ae3          	bne	a4,a5,a78 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a88:	8552                	mv	a0,s4
 a8a:	8c7ff0ef          	jal	350 <sbrk>
  if(p == SBRK_ERROR)
 a8e:	fd551ee3          	bne	a0,s5,a6a <malloc+0x7c>
        return 0;
 a92:	4501                	li	a0,0
 a94:	74a2                	ld	s1,40(sp)
 a96:	6a42                	ld	s4,16(sp)
 a98:	6aa2                	ld	s5,8(sp)
 a9a:	6b02                	ld	s6,0(sp)
 a9c:	a03d                	j	aca <malloc+0xdc>
 a9e:	74a2                	ld	s1,40(sp)
 aa0:	6a42                	ld	s4,16(sp)
 aa2:	6aa2                	ld	s5,8(sp)
 aa4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aa6:	fae90fe3          	beq	s2,a4,a64 <malloc+0x76>
        p->s.size -= nunits;
 aaa:	4137073b          	subw	a4,a4,s3
 aae:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ab0:	02071693          	slli	a3,a4,0x20
 ab4:	01c6d713          	srli	a4,a3,0x1c
 ab8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aba:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 abe:	00000717          	auipc	a4,0x0
 ac2:	54a73923          	sd	a0,1362(a4) # 1010 <freep>
      return (void*)(p + 1);
 ac6:	01078513          	addi	a0,a5,16
  }
}
 aca:	70e2                	ld	ra,56(sp)
 acc:	7442                	ld	s0,48(sp)
 ace:	7902                	ld	s2,32(sp)
 ad0:	69e2                	ld	s3,24(sp)
 ad2:	6121                	addi	sp,sp,64
 ad4:	8082                	ret
 ad6:	74a2                	ld	s1,40(sp)
 ad8:	6a42                	ld	s4,16(sp)
 ada:	6aa2                	ld	s5,8(sp)
 adc:	6b02                	ld	s6,0(sp)
 ade:	b7f5                	j	aca <malloc+0xdc>
