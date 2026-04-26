
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  1e:	00001797          	auipc	a5,0x1
  22:	b2278793          	addi	a5,a5,-1246 # b40 <malloc+0x126>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	adc50513          	addi	a0,a0,-1316 # b10 <malloc+0xf6>
  3c:	127000ef          	jal	962 <printf>
  memset(data, 'a', sizeof(data));
  40:	20000613          	li	a2,512
  44:	06100593          	li	a1,97
  48:	dc040513          	addi	a0,s0,-576
  4c:	12a000ef          	jal	176 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	4cc000ef          	jal	520 <fork>
  58:	00a04563          	bgtz	a0,62 <main+0x62>
  for(i = 0; i < 4; i++)
  5c:	2485                	addiw	s1,s1,1
  5e:	ff249be3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  62:	85a6                	mv	a1,s1
  64:	00001517          	auipc	a0,0x1
  68:	ac450513          	addi	a0,a0,-1340 # b28 <malloc+0x10e>
  6c:	0f7000ef          	jal	962 <printf>

  path[8] += i;
  70:	fc844783          	lbu	a5,-56(s0)
  74:	9fa5                	addw	a5,a5,s1
  76:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  7a:	20200593          	li	a1,514
  7e:	fc040513          	addi	a0,s0,-64
  82:	4e6000ef          	jal	568 <open>
  86:	892a                	mv	s2,a0
  88:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  8a:	dc040a13          	addi	s4,s0,-576
  8e:	20000993          	li	s3,512
  92:	864e                	mv	a2,s3
  94:	85d2                	mv	a1,s4
  96:	854a                	mv	a0,s2
  98:	4b0000ef          	jal	548 <write>
  for(i = 0; i < 20; i++)
  9c:	34fd                	addiw	s1,s1,-1
  9e:	f8f5                	bnez	s1,92 <main+0x92>
  close(fd);
  a0:	854a                	mv	a0,s2
  a2:	4ae000ef          	jal	550 <close>

  printf("read\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	a9250513          	addi	a0,a0,-1390 # b38 <malloc+0x11e>
  ae:	0b5000ef          	jal	962 <printf>

  fd = open(path, O_RDONLY);
  b2:	4581                	li	a1,0
  b4:	fc040513          	addi	a0,s0,-64
  b8:	4b0000ef          	jal	568 <open>
  bc:	892a                	mv	s2,a0
  be:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  c0:	dc040a13          	addi	s4,s0,-576
  c4:	20000993          	li	s3,512
  c8:	864e                	mv	a2,s3
  ca:	85d2                	mv	a1,s4
  cc:	854a                	mv	a0,s2
  ce:	472000ef          	jal	540 <read>
  for (i = 0; i < 20; i++)
  d2:	34fd                	addiw	s1,s1,-1
  d4:	f8f5                	bnez	s1,c8 <main+0xc8>
  close(fd);
  d6:	854a                	mv	a0,s2
  d8:	478000ef          	jal	550 <close>

  wait(0);
  dc:	4501                	li	a0,0
  de:	452000ef          	jal	530 <wait>

  exit(0);
  e2:	4501                	li	a0,0
  e4:	444000ef          	jal	528 <exit>

00000000000000e8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  f0:	f11ff0ef          	jal	0 <main>
  exit(r);
  f4:	434000ef          	jal	528 <exit>

00000000000000f8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 100:	87aa                	mv	a5,a0
 102:	0585                	addi	a1,a1,1
 104:	0785                	addi	a5,a5,1
 106:	fff5c703          	lbu	a4,-1(a1)
 10a:	fee78fa3          	sb	a4,-1(a5)
 10e:	fb75                	bnez	a4,102 <strcpy+0xa>
    ;
  return os;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 120:	00054783          	lbu	a5,0(a0)
 124:	cb91                	beqz	a5,138 <strcmp+0x20>
 126:	0005c703          	lbu	a4,0(a1)
 12a:	00f71763          	bne	a4,a5,138 <strcmp+0x20>
    p++, q++;
 12e:	0505                	addi	a0,a0,1
 130:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	fbe5                	bnez	a5,126 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 138:	0005c503          	lbu	a0,0(a1)
}
 13c:	40a7853b          	subw	a0,a5,a0
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <strlen>:

uint
strlen(const char *s)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 150:	00054783          	lbu	a5,0(a0)
 154:	cf99                	beqz	a5,172 <strlen+0x2a>
 156:	0505                	addi	a0,a0,1
 158:	87aa                	mv	a5,a0
 15a:	86be                	mv	a3,a5
 15c:	0785                	addi	a5,a5,1
 15e:	fff7c703          	lbu	a4,-1(a5)
 162:	ff65                	bnez	a4,15a <strlen+0x12>
 164:	40a6853b          	subw	a0,a3,a0
 168:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 16a:	60a2                	ld	ra,8(sp)
 16c:	6402                	ld	s0,0(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret
  for(n = 0; s[n]; n++)
 172:	4501                	li	a0,0
 174:	bfdd                	j	16a <strlen+0x22>

0000000000000176 <memset>:

void*
memset(void *dst, int c, uint n)
{
 176:	1141                	addi	sp,sp,-16
 178:	e406                	sd	ra,8(sp)
 17a:	e022                	sd	s0,0(sp)
 17c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 17e:	ca19                	beqz	a2,194 <memset+0x1e>
 180:	87aa                	mv	a5,a0
 182:	1602                	slli	a2,a2,0x20
 184:	9201                	srli	a2,a2,0x20
 186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 18a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 18e:	0785                	addi	a5,a5,1
 190:	fee79de3          	bne	a5,a4,18a <memset+0x14>
  }
  return dst;
}
 194:	60a2                	ld	ra,8(sp)
 196:	6402                	ld	s0,0(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <strchr>:

char*
strchr(const char *s, char c)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e406                	sd	ra,8(sp)
 1a0:	e022                	sd	s0,0(sp)
 1a2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a4:	00054783          	lbu	a5,0(a0)
 1a8:	cf81                	beqz	a5,1c0 <strchr+0x24>
    if(*s == c)
 1aa:	00f58763          	beq	a1,a5,1b8 <strchr+0x1c>
  for(; *s; s++)
 1ae:	0505                	addi	a0,a0,1
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	fbfd                	bnez	a5,1aa <strchr+0xe>
      return (char*)s;
  return 0;
 1b6:	4501                	li	a0,0
}
 1b8:	60a2                	ld	ra,8(sp)
 1ba:	6402                	ld	s0,0(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret
  return 0;
 1c0:	4501                	li	a0,0
 1c2:	bfdd                	j	1b8 <strchr+0x1c>

00000000000001c4 <gets>:

char*
gets(char *buf, int max)
{
 1c4:	7159                	addi	sp,sp,-112
 1c6:	f486                	sd	ra,104(sp)
 1c8:	f0a2                	sd	s0,96(sp)
 1ca:	eca6                	sd	s1,88(sp)
 1cc:	e8ca                	sd	s2,80(sp)
 1ce:	e4ce                	sd	s3,72(sp)
 1d0:	e0d2                	sd	s4,64(sp)
 1d2:	fc56                	sd	s5,56(sp)
 1d4:	f85a                	sd	s6,48(sp)
 1d6:	f45e                	sd	s7,40(sp)
 1d8:	f062                	sd	s8,32(sp)
 1da:	ec66                	sd	s9,24(sp)
 1dc:	e86a                	sd	s10,16(sp)
 1de:	1880                	addi	s0,sp,112
 1e0:	8caa                	mv	s9,a0
 1e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	892a                	mv	s2,a0
 1e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1e8:	f9f40b13          	addi	s6,s0,-97
 1ec:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ee:	4ba9                	li	s7,10
 1f0:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1f2:	8d26                	mv	s10,s1
 1f4:	0014899b          	addiw	s3,s1,1
 1f8:	84ce                	mv	s1,s3
 1fa:	0349d563          	bge	s3,s4,224 <gets+0x60>
    cc = read(0, &c, 1);
 1fe:	8656                	mv	a2,s5
 200:	85da                	mv	a1,s6
 202:	4501                	li	a0,0
 204:	33c000ef          	jal	540 <read>
    if(cc < 1)
 208:	00a05e63          	blez	a0,224 <gets+0x60>
    buf[i++] = c;
 20c:	f9f44783          	lbu	a5,-97(s0)
 210:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 214:	01778763          	beq	a5,s7,222 <gets+0x5e>
 218:	0905                	addi	s2,s2,1
 21a:	fd879ce3          	bne	a5,s8,1f2 <gets+0x2e>
    buf[i++] = c;
 21e:	8d4e                	mv	s10,s3
 220:	a011                	j	224 <gets+0x60>
 222:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 224:	9d66                	add	s10,s10,s9
 226:	000d0023          	sb	zero,0(s10)
  return buf;
}
 22a:	8566                	mv	a0,s9
 22c:	70a6                	ld	ra,104(sp)
 22e:	7406                	ld	s0,96(sp)
 230:	64e6                	ld	s1,88(sp)
 232:	6946                	ld	s2,80(sp)
 234:	69a6                	ld	s3,72(sp)
 236:	6a06                	ld	s4,64(sp)
 238:	7ae2                	ld	s5,56(sp)
 23a:	7b42                	ld	s6,48(sp)
 23c:	7ba2                	ld	s7,40(sp)
 23e:	7c02                	ld	s8,32(sp)
 240:	6ce2                	ld	s9,24(sp)
 242:	6d42                	ld	s10,16(sp)
 244:	6165                	addi	sp,sp,112
 246:	8082                	ret

0000000000000248 <stat>:

int
stat(const char *n, struct stat *st)
{
 248:	1101                	addi	sp,sp,-32
 24a:	ec06                	sd	ra,24(sp)
 24c:	e822                	sd	s0,16(sp)
 24e:	e04a                	sd	s2,0(sp)
 250:	1000                	addi	s0,sp,32
 252:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	4581                	li	a1,0
 256:	312000ef          	jal	568 <open>
  if(fd < 0)
 25a:	02054263          	bltz	a0,27e <stat+0x36>
 25e:	e426                	sd	s1,8(sp)
 260:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 262:	85ca                	mv	a1,s2
 264:	31c000ef          	jal	580 <fstat>
 268:	892a                	mv	s2,a0
  close(fd);
 26a:	8526                	mv	a0,s1
 26c:	2e4000ef          	jal	550 <close>
  return r;
 270:	64a2                	ld	s1,8(sp)
}
 272:	854a                	mv	a0,s2
 274:	60e2                	ld	ra,24(sp)
 276:	6442                	ld	s0,16(sp)
 278:	6902                	ld	s2,0(sp)
 27a:	6105                	addi	sp,sp,32
 27c:	8082                	ret
    return -1;
 27e:	597d                	li	s2,-1
 280:	bfcd                	j	272 <stat+0x2a>

0000000000000282 <atoi>:

int
atoi(const char *s)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28a:	00054683          	lbu	a3,0(a0)
 28e:	fd06879b          	addiw	a5,a3,-48
 292:	0ff7f793          	zext.b	a5,a5
 296:	4625                	li	a2,9
 298:	02f66963          	bltu	a2,a5,2ca <atoi+0x48>
 29c:	872a                	mv	a4,a0
  n = 0;
 29e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a0:	0705                	addi	a4,a4,1
 2a2:	0025179b          	slliw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	slliw	a5,a5,0x1
 2ac:	9fb5                	addw	a5,a5,a3
 2ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b2:	00074683          	lbu	a3,0(a4)
 2b6:	fd06879b          	addiw	a5,a3,-48
 2ba:	0ff7f793          	zext.b	a5,a5
 2be:	fef671e3          	bgeu	a2,a5,2a0 <atoi+0x1e>
  return n;
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  n = 0;
 2ca:	4501                	li	a0,0
 2cc:	bfdd                	j	2c2 <atoi+0x40>

00000000000002ce <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d6:	02b57563          	bgeu	a0,a1,300 <memmove+0x32>
    while(n-- > 0)
 2da:	00c05f63          	blez	a2,2f8 <memmove+0x2a>
 2de:	1602                	slli	a2,a2,0x20
 2e0:	9201                	srli	a2,a2,0x20
 2e2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e8:	0585                	addi	a1,a1,1
 2ea:	0705                	addi	a4,a4,1
 2ec:	fff5c683          	lbu	a3,-1(a1)
 2f0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f4:	fee79ae3          	bne	a5,a4,2e8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret
    dst += n;
 300:	00c50733          	add	a4,a0,a2
    src += n;
 304:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 306:	fec059e3          	blez	a2,2f8 <memmove+0x2a>
 30a:	fff6079b          	addiw	a5,a2,-1
 30e:	1782                	slli	a5,a5,0x20
 310:	9381                	srli	a5,a5,0x20
 312:	fff7c793          	not	a5,a5
 316:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 318:	15fd                	addi	a1,a1,-1
 31a:	177d                	addi	a4,a4,-1
 31c:	0005c683          	lbu	a3,0(a1)
 320:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 324:	fef71ae3          	bne	a4,a5,318 <memmove+0x4a>
 328:	bfc1                	j	2f8 <memmove+0x2a>

000000000000032a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 332:	ca0d                	beqz	a2,364 <memcmp+0x3a>
 334:	fff6069b          	addiw	a3,a2,-1
 338:	1682                	slli	a3,a3,0x20
 33a:	9281                	srli	a3,a3,0x20
 33c:	0685                	addi	a3,a3,1
 33e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 340:	00054783          	lbu	a5,0(a0)
 344:	0005c703          	lbu	a4,0(a1)
 348:	00e79863          	bne	a5,a4,358 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 34c:	0505                	addi	a0,a0,1
    p2++;
 34e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 350:	fed518e3          	bne	a0,a3,340 <memcmp+0x16>
  }
  return 0;
 354:	4501                	li	a0,0
 356:	a019                	j	35c <memcmp+0x32>
      return *p1 - *p2;
 358:	40e7853b          	subw	a0,a5,a4
}
 35c:	60a2                	ld	ra,8(sp)
 35e:	6402                	ld	s0,0(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
  return 0;
 364:	4501                	li	a0,0
 366:	bfdd                	j	35c <memcmp+0x32>

0000000000000368 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e406                	sd	ra,8(sp)
 36c:	e022                	sd	s0,0(sp)
 36e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 370:	f5fff0ef          	jal	2ce <memmove>
}
 374:	60a2                	ld	ra,8(sp)
 376:	6402                	ld	s0,0(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret

000000000000037c <sbrk>:

char *
sbrk(int n) {
 37c:	1141                	addi	sp,sp,-16
 37e:	e406                	sd	ra,8(sp)
 380:	e022                	sd	s0,0(sp)
 382:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 384:	4585                	li	a1,1
 386:	22a000ef          	jal	5b0 <sys_sbrk>
}
 38a:	60a2                	ld	ra,8(sp)
 38c:	6402                	ld	s0,0(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret

0000000000000392 <sbrklazy>:

char *
sbrklazy(int n) {
 392:	1141                	addi	sp,sp,-16
 394:	e406                	sd	ra,8(sp)
 396:	e022                	sd	s0,0(sp)
 398:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 39a:	4589                	li	a1,2
 39c:	214000ef          	jal	5b0 <sys_sbrk>
}
 3a0:	60a2                	ld	ra,8(sp)
 3a2:	6402                	ld	s0,0(sp)
 3a4:	0141                	addi	sp,sp,16
 3a6:	8082                	ret

00000000000003a8 <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 3a8:	1101                	addi	sp,sp,-32
 3aa:	ec06                	sd	ra,24(sp)
 3ac:	e822                	sd	s0,16(sp)
 3ae:	e426                	sd	s1,8(sp)
 3b0:	e04a                	sd	s2,0(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	84aa                	mv	s1,a0
 3b6:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 3b8:	6505                	lui	a0,0x1
 3ba:	fc3ff0ef          	jal	37c <sbrk>
 3be:	6785                	lui	a5,0x1
 3c0:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 3c4:	9a41                	andi	a2,a2,-16
 3c6:	85ca                	mv	a1,s2
 3c8:	8526                	mv	a0,s1
 3ca:	1fe000ef          	jal	5c8 <clone>
}
 3ce:	60e2                	ld	ra,24(sp)
 3d0:	6442                	ld	s0,16(sp)
 3d2:	64a2                	ld	s1,8(sp)
 3d4:	6902                	ld	s2,0(sp)
 3d6:	6105                	addi	sp,sp,32
 3d8:	8082                	ret

00000000000003da <futex>:

void futex(int *uaddr, int ops, int val) {
 3da:	7179                	addi	sp,sp,-48
 3dc:	f406                	sd	ra,40(sp)
 3de:	f022                	sd	s0,32(sp)
 3e0:	ec26                	sd	s1,24(sp)
 3e2:	1800                	addi	s0,sp,48
 3e4:	84aa                	mv	s1,a0
  if (ops==0) {
 3e6:	ed95                	bnez	a1,422 <futex+0x48>
    if (val==0) {
 3e8:	c611                	beqz	a2,3f4 <futex+0x1a>
 3ea:	e84a                	sd	s2,16(sp)
 3ec:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 3ee:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 3f0:	4985                	li	s3,1
 3f2:	a005                	j	412 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 3f4:	4705                	li	a4,1
 3f6:	87ba                	mv	a5,a4
 3f8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 3fc:	2781                	sext.w	a5,a5
 3fe:	ffe5                	bnez	a5,3f6 <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 400:	70a2                	ld	ra,40(sp)
 402:	7402                	ld	s0,32(sp)
 404:	64e2                	ld	s1,24(sp)
 406:	6145                	addi	sp,sp,48
 408:	8082                	ret
        futex_wait(uaddr, 1);
 40a:	85ce                	mv	a1,s3
 40c:	8526                	mv	a0,s1
 40e:	1ca000ef          	jal	5d8 <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 412:	87ca                	mv	a5,s2
 414:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 418:	2781                	sext.w	a5,a5
 41a:	fbe5                	bnez	a5,40a <futex+0x30>
 41c:	6942                	ld	s2,16(sp)
 41e:	69a2                	ld	s3,8(sp)
 420:	b7c5                	j	400 <futex+0x26>
    if (val==0) {
 422:	e611                	bnez	a2,42e <futex+0x54>
      __sync_lock_release(uaddr);
 424:	0310000f          	fence	rw,w
 428:	00052023          	sw	zero,0(a0) # 1000 <freep>
 42c:	bfd1                	j	400 <futex+0x26>
      __sync_lock_release(uaddr);
 42e:	0310000f          	fence	rw,w
 432:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 436:	1aa000ef          	jal	5e0 <futex_wake>
  return;
 43a:	b7d9                	j	400 <futex+0x26>

000000000000043c <sem_init>:

void sem_init(sem_t* s, int val) {
 43c:	7179                	addi	sp,sp,-48
 43e:	f406                	sd	ra,40(sp)
 440:	f022                	sd	s0,32(sp)
 442:	ec26                	sd	s1,24(sp)
 444:	e84a                	sd	s2,16(sp)
 446:	e44e                	sd	s3,8(sp)
 448:	1800                	addi	s0,sp,48
 44a:	84aa                	mv	s1,a0
 44c:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 44e:	00450993          	addi	s3,a0,4
 452:	4605                	li	a2,1
 454:	4581                	li	a1,0
 456:	854e                	mv	a0,s3
 458:	f83ff0ef          	jal	3da <futex>
  s->value = val;
 45c:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 460:	4605                	li	a2,1
 462:	85b2                	mv	a1,a2
 464:	854e                	mv	a0,s3
 466:	f75ff0ef          	jal	3da <futex>
  return;
}
 46a:	70a2                	ld	ra,40(sp)
 46c:	7402                	ld	s0,32(sp)
 46e:	64e2                	ld	s1,24(sp)
 470:	6942                	ld	s2,16(sp)
 472:	69a2                	ld	s3,8(sp)
 474:	6145                	addi	sp,sp,48
 476:	8082                	ret

0000000000000478 <sem_down>:

void sem_down(sem_t* s) {
 478:	7179                	addi	sp,sp,-48
 47a:	f406                	sd	ra,40(sp)
 47c:	f022                	sd	s0,32(sp)
 47e:	ec26                	sd	s1,24(sp)
 480:	e84a                	sd	s2,16(sp)
 482:	e44e                	sd	s3,8(sp)
 484:	1800                	addi	s0,sp,48
 486:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 488:	00450993          	addi	s3,a0,4
 48c:	4605                	li	a2,1
 48e:	4581                	li	a1,0
 490:	854e                	mv	a0,s3
 492:	f49ff0ef          	jal	3da <futex>
  while(1) {
    if (s->value>0) {
 496:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 49a:	4485                	li	s1,1
    if (s->value>0) {
 49c:	02f04463          	bgtz	a5,4c4 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 4a0:	8626                	mv	a2,s1
 4a2:	85a6                	mv	a1,s1
 4a4:	854e                	mv	a0,s3
 4a6:	f35ff0ef          	jal	3da <futex>
      futex_wait(&s->value,1);
 4aa:	85a6                	mv	a1,s1
 4ac:	854a                	mv	a0,s2
 4ae:	12a000ef          	jal	5d8 <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 4b2:	8626                	mv	a2,s1
 4b4:	4581                	li	a1,0
 4b6:	854e                	mv	a0,s3
 4b8:	f23ff0ef          	jal	3da <futex>
    if (s->value>0) {
 4bc:	00092783          	lw	a5,0(s2)
 4c0:	fef050e3          	blez	a5,4a0 <sem_down+0x28>
      s->value--;
 4c4:	37fd                	addiw	a5,a5,-1 # fff <digits+0x4a7>
 4c6:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4ca:	4605                	li	a2,1
 4cc:	85b2                	mv	a1,a2
 4ce:	854e                	mv	a0,s3
 4d0:	f0bff0ef          	jal	3da <futex>
  return;
}
 4d4:	70a2                	ld	ra,40(sp)
 4d6:	7402                	ld	s0,32(sp)
 4d8:	64e2                	ld	s1,24(sp)
 4da:	6942                	ld	s2,16(sp)
 4dc:	69a2                	ld	s3,8(sp)
 4de:	6145                	addi	sp,sp,48
 4e0:	8082                	ret

00000000000004e2 <sem_up>:

void sem_up(sem_t* s) {
 4e2:	1101                	addi	sp,sp,-32
 4e4:	ec06                	sd	ra,24(sp)
 4e6:	e822                	sd	s0,16(sp)
 4e8:	e426                	sd	s1,8(sp)
 4ea:	e04a                	sd	s2,0(sp)
 4ec:	1000                	addi	s0,sp,32
 4ee:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 4f0:	00450913          	addi	s2,a0,4
 4f4:	4605                	li	a2,1
 4f6:	4581                	li	a1,0
 4f8:	854a                	mv	a0,s2
 4fa:	ee1ff0ef          	jal	3da <futex>
  s->value++;
 4fe:	409c                	lw	a5,0(s1)
 500:	2785                	addiw	a5,a5,1
 502:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 504:	8526                	mv	a0,s1
 506:	0da000ef          	jal	5e0 <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 50a:	4605                	li	a2,1
 50c:	85b2                	mv	a1,a2
 50e:	854a                	mv	a0,s2
 510:	ecbff0ef          	jal	3da <futex>
  return;
 514:	60e2                	ld	ra,24(sp)
 516:	6442                	ld	s0,16(sp)
 518:	64a2                	ld	s1,8(sp)
 51a:	6902                	ld	s2,0(sp)
 51c:	6105                	addi	sp,sp,32
 51e:	8082                	ret

0000000000000520 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 520:	4885                	li	a7,1
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <exit>:
.global exit
exit:
 li a7, SYS_exit
 528:	4889                	li	a7,2
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <wait>:
.global wait
wait:
 li a7, SYS_wait
 530:	488d                	li	a7,3
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 538:	4891                	li	a7,4
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <read>:
.global read
read:
 li a7, SYS_read
 540:	4895                	li	a7,5
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <write>:
.global write
write:
 li a7, SYS_write
 548:	48c1                	li	a7,16
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <close>:
.global close
close:
 li a7, SYS_close
 550:	48d5                	li	a7,21
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <kill>:
.global kill
kill:
 li a7, SYS_kill
 558:	4899                	li	a7,6
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <exec>:
.global exec
exec:
 li a7, SYS_exec
 560:	489d                	li	a7,7
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <open>:
.global open
open:
 li a7, SYS_open
 568:	48bd                	li	a7,15
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 570:	48c5                	li	a7,17
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 578:	48c9                	li	a7,18
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 580:	48a1                	li	a7,8
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <link>:
.global link
link:
 li a7, SYS_link
 588:	48cd                	li	a7,19
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 590:	48d1                	li	a7,20
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 598:	48a5                	li	a7,9
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5a0:	48a9                	li	a7,10
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a8:	48ad                	li	a7,11
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5b0:	48b1                	li	a7,12
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5b8:	48b5                	li	a7,13
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5c0:	48b9                	li	a7,14
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <clone>:
.global clone
clone:
 li a7, SYS_clone
 5c8:	48d9                	li	a7,22
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <join>:
.global join
join:
 li a7, SYS_join
 5d0:	48dd                	li	a7,23
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 5d8:	48e1                	li	a7,24
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 5e0:	48e5                	li	a7,25
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5e8:	1101                	addi	sp,sp,-32
 5ea:	ec06                	sd	ra,24(sp)
 5ec:	e822                	sd	s0,16(sp)
 5ee:	1000                	addi	s0,sp,32
 5f0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5f4:	4605                	li	a2,1
 5f6:	fef40593          	addi	a1,s0,-17
 5fa:	f4fff0ef          	jal	548 <write>
}
 5fe:	60e2                	ld	ra,24(sp)
 600:	6442                	ld	s0,16(sp)
 602:	6105                	addi	sp,sp,32
 604:	8082                	ret

0000000000000606 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 606:	715d                	addi	sp,sp,-80
 608:	e486                	sd	ra,72(sp)
 60a:	e0a2                	sd	s0,64(sp)
 60c:	fc26                	sd	s1,56(sp)
 60e:	f84a                	sd	s2,48(sp)
 610:	f44e                	sd	s3,40(sp)
 612:	0880                	addi	s0,sp,80
 614:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 616:	c299                	beqz	a3,61c <printint+0x16>
 618:	0605cc63          	bltz	a1,690 <printint+0x8a>
  neg = 0;
 61c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 61e:	fb840313          	addi	t1,s0,-72
  neg = 0;
 622:	869a                	mv	a3,t1
  i = 0;
 624:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 626:	00000817          	auipc	a6,0x0
 62a:	53280813          	addi	a6,a6,1330 # b58 <digits>
 62e:	88be                	mv	a7,a5
 630:	0017851b          	addiw	a0,a5,1
 634:	87aa                	mv	a5,a0
 636:	02c5f733          	remu	a4,a1,a2
 63a:	9742                	add	a4,a4,a6
 63c:	00074703          	lbu	a4,0(a4)
 640:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 644:	872e                	mv	a4,a1
 646:	02c5d5b3          	divu	a1,a1,a2
 64a:	0685                	addi	a3,a3,1
 64c:	fec771e3          	bgeu	a4,a2,62e <printint+0x28>
  if(neg)
 650:	000e0c63          	beqz	t3,668 <printint+0x62>
    buf[i++] = '-';
 654:	fd050793          	addi	a5,a0,-48
 658:	00878533          	add	a0,a5,s0
 65c:	02d00793          	li	a5,45
 660:	fef50423          	sb	a5,-24(a0)
 664:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 668:	fff7899b          	addiw	s3,a5,-1
 66c:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 670:	fff4c583          	lbu	a1,-1(s1)
 674:	854a                	mv	a0,s2
 676:	f73ff0ef          	jal	5e8 <putc>
  while(--i >= 0)
 67a:	39fd                	addiw	s3,s3,-1
 67c:	14fd                	addi	s1,s1,-1
 67e:	fe09d9e3          	bgez	s3,670 <printint+0x6a>
}
 682:	60a6                	ld	ra,72(sp)
 684:	6406                	ld	s0,64(sp)
 686:	74e2                	ld	s1,56(sp)
 688:	7942                	ld	s2,48(sp)
 68a:	79a2                	ld	s3,40(sp)
 68c:	6161                	addi	sp,sp,80
 68e:	8082                	ret
    x = -xx;
 690:	40b005b3          	neg	a1,a1
    neg = 1;
 694:	4e05                	li	t3,1
    x = -xx;
 696:	b761                	j	61e <printint+0x18>

0000000000000698 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 698:	711d                	addi	sp,sp,-96
 69a:	ec86                	sd	ra,88(sp)
 69c:	e8a2                	sd	s0,80(sp)
 69e:	e4a6                	sd	s1,72(sp)
 6a0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6a2:	0005c483          	lbu	s1,0(a1)
 6a6:	28048463          	beqz	s1,92e <vprintf+0x296>
 6aa:	e0ca                	sd	s2,64(sp)
 6ac:	fc4e                	sd	s3,56(sp)
 6ae:	f852                	sd	s4,48(sp)
 6b0:	f456                	sd	s5,40(sp)
 6b2:	f05a                	sd	s6,32(sp)
 6b4:	ec5e                	sd	s7,24(sp)
 6b6:	e862                	sd	s8,16(sp)
 6b8:	e466                	sd	s9,8(sp)
 6ba:	8b2a                	mv	s6,a0
 6bc:	8a2e                	mv	s4,a1
 6be:	8bb2                	mv	s7,a2
  state = 0;
 6c0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6c2:	4901                	li	s2,0
 6c4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6c6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6ca:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6ce:	06c00c93          	li	s9,108
 6d2:	a00d                	j	6f4 <vprintf+0x5c>
        putc(fd, c0);
 6d4:	85a6                	mv	a1,s1
 6d6:	855a                	mv	a0,s6
 6d8:	f11ff0ef          	jal	5e8 <putc>
 6dc:	a019                	j	6e2 <vprintf+0x4a>
    } else if(state == '%'){
 6de:	03598363          	beq	s3,s5,704 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6e2:	0019079b          	addiw	a5,s2,1
 6e6:	893e                	mv	s2,a5
 6e8:	873e                	mv	a4,a5
 6ea:	97d2                	add	a5,a5,s4
 6ec:	0007c483          	lbu	s1,0(a5)
 6f0:	22048763          	beqz	s1,91e <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 6f4:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6f8:	fe0993e3          	bnez	s3,6de <vprintf+0x46>
      if(c0 == '%'){
 6fc:	fd579ce3          	bne	a5,s5,6d4 <vprintf+0x3c>
        state = '%';
 700:	89be                	mv	s3,a5
 702:	b7c5                	j	6e2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 704:	00ea06b3          	add	a3,s4,a4
 708:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 70c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 70e:	c681                	beqz	a3,716 <vprintf+0x7e>
 710:	9752                	add	a4,a4,s4
 712:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 716:	05878263          	beq	a5,s8,75a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 71a:	05978c63          	beq	a5,s9,772 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 71e:	07500713          	li	a4,117
 722:	0ee78663          	beq	a5,a4,80e <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 726:	07800713          	li	a4,120
 72a:	12e78863          	beq	a5,a4,85a <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 72e:	07000713          	li	a4,112
 732:	14e78d63          	beq	a5,a4,88c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 736:	06300713          	li	a4,99
 73a:	18e78c63          	beq	a5,a4,8d2 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 73e:	07300713          	li	a4,115
 742:	1ae78263          	beq	a5,a4,8e6 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 746:	02500713          	li	a4,37
 74a:	04e79463          	bne	a5,a4,792 <vprintf+0xfa>
        putc(fd, '%');
 74e:	85ba                	mv	a1,a4
 750:	855a                	mv	a0,s6
 752:	e97ff0ef          	jal	5e8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 756:	4981                	li	s3,0
 758:	b769                	j	6e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 75a:	008b8493          	addi	s1,s7,8
 75e:	4685                	li	a3,1
 760:	4629                	li	a2,10
 762:	000ba583          	lw	a1,0(s7)
 766:	855a                	mv	a0,s6
 768:	e9fff0ef          	jal	606 <printint>
 76c:	8ba6                	mv	s7,s1
      state = 0;
 76e:	4981                	li	s3,0
 770:	bf8d                	j	6e2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 772:	06400793          	li	a5,100
 776:	02f68963          	beq	a3,a5,7a8 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 77a:	06c00793          	li	a5,108
 77e:	04f68263          	beq	a3,a5,7c2 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 782:	07500793          	li	a5,117
 786:	0af68063          	beq	a3,a5,826 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 78a:	07800793          	li	a5,120
 78e:	0ef68263          	beq	a3,a5,872 <vprintf+0x1da>
        putc(fd, '%');
 792:	02500593          	li	a1,37
 796:	855a                	mv	a0,s6
 798:	e51ff0ef          	jal	5e8 <putc>
        putc(fd, c0);
 79c:	85a6                	mv	a1,s1
 79e:	855a                	mv	a0,s6
 7a0:	e49ff0ef          	jal	5e8 <putc>
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	bf35                	j	6e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a8:	008b8493          	addi	s1,s7,8
 7ac:	4685                	li	a3,1
 7ae:	4629                	li	a2,10
 7b0:	000bb583          	ld	a1,0(s7)
 7b4:	855a                	mv	a0,s6
 7b6:	e51ff0ef          	jal	606 <printint>
        i += 1;
 7ba:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7bc:	8ba6                	mv	s7,s1
      state = 0;
 7be:	4981                	li	s3,0
        i += 1;
 7c0:	b70d                	j	6e2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7c2:	06400793          	li	a5,100
 7c6:	02f60763          	beq	a2,a5,7f4 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7ca:	07500793          	li	a5,117
 7ce:	06f60963          	beq	a2,a5,840 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7d2:	07800793          	li	a5,120
 7d6:	faf61ee3          	bne	a2,a5,792 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7da:	008b8493          	addi	s1,s7,8
 7de:	4681                	li	a3,0
 7e0:	4641                	li	a2,16
 7e2:	000bb583          	ld	a1,0(s7)
 7e6:	855a                	mv	a0,s6
 7e8:	e1fff0ef          	jal	606 <printint>
        i += 2;
 7ec:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ee:	8ba6                	mv	s7,s1
      state = 0;
 7f0:	4981                	li	s3,0
        i += 2;
 7f2:	bdc5                	j	6e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f4:	008b8493          	addi	s1,s7,8
 7f8:	4685                	li	a3,1
 7fa:	4629                	li	a2,10
 7fc:	000bb583          	ld	a1,0(s7)
 800:	855a                	mv	a0,s6
 802:	e05ff0ef          	jal	606 <printint>
        i += 2;
 806:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 808:	8ba6                	mv	s7,s1
      state = 0;
 80a:	4981                	li	s3,0
        i += 2;
 80c:	bdd9                	j	6e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 80e:	008b8493          	addi	s1,s7,8
 812:	4681                	li	a3,0
 814:	4629                	li	a2,10
 816:	000be583          	lwu	a1,0(s7)
 81a:	855a                	mv	a0,s6
 81c:	debff0ef          	jal	606 <printint>
 820:	8ba6                	mv	s7,s1
      state = 0;
 822:	4981                	li	s3,0
 824:	bd7d                	j	6e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 826:	008b8493          	addi	s1,s7,8
 82a:	4681                	li	a3,0
 82c:	4629                	li	a2,10
 82e:	000bb583          	ld	a1,0(s7)
 832:	855a                	mv	a0,s6
 834:	dd3ff0ef          	jal	606 <printint>
        i += 1;
 838:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 83a:	8ba6                	mv	s7,s1
      state = 0;
 83c:	4981                	li	s3,0
        i += 1;
 83e:	b555                	j	6e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 840:	008b8493          	addi	s1,s7,8
 844:	4681                	li	a3,0
 846:	4629                	li	a2,10
 848:	000bb583          	ld	a1,0(s7)
 84c:	855a                	mv	a0,s6
 84e:	db9ff0ef          	jal	606 <printint>
        i += 2;
 852:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 854:	8ba6                	mv	s7,s1
      state = 0;
 856:	4981                	li	s3,0
        i += 2;
 858:	b569                	j	6e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 85a:	008b8493          	addi	s1,s7,8
 85e:	4681                	li	a3,0
 860:	4641                	li	a2,16
 862:	000be583          	lwu	a1,0(s7)
 866:	855a                	mv	a0,s6
 868:	d9fff0ef          	jal	606 <printint>
 86c:	8ba6                	mv	s7,s1
      state = 0;
 86e:	4981                	li	s3,0
 870:	bd8d                	j	6e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 872:	008b8493          	addi	s1,s7,8
 876:	4681                	li	a3,0
 878:	4641                	li	a2,16
 87a:	000bb583          	ld	a1,0(s7)
 87e:	855a                	mv	a0,s6
 880:	d87ff0ef          	jal	606 <printint>
        i += 1;
 884:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 886:	8ba6                	mv	s7,s1
      state = 0;
 888:	4981                	li	s3,0
        i += 1;
 88a:	bda1                	j	6e2 <vprintf+0x4a>
 88c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 88e:	008b8d13          	addi	s10,s7,8
 892:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 896:	03000593          	li	a1,48
 89a:	855a                	mv	a0,s6
 89c:	d4dff0ef          	jal	5e8 <putc>
  putc(fd, 'x');
 8a0:	07800593          	li	a1,120
 8a4:	855a                	mv	a0,s6
 8a6:	d43ff0ef          	jal	5e8 <putc>
 8aa:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8ac:	00000b97          	auipc	s7,0x0
 8b0:	2acb8b93          	addi	s7,s7,684 # b58 <digits>
 8b4:	03c9d793          	srli	a5,s3,0x3c
 8b8:	97de                	add	a5,a5,s7
 8ba:	0007c583          	lbu	a1,0(a5)
 8be:	855a                	mv	a0,s6
 8c0:	d29ff0ef          	jal	5e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8c4:	0992                	slli	s3,s3,0x4
 8c6:	34fd                	addiw	s1,s1,-1
 8c8:	f4f5                	bnez	s1,8b4 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 8ca:	8bea                	mv	s7,s10
      state = 0;
 8cc:	4981                	li	s3,0
 8ce:	6d02                	ld	s10,0(sp)
 8d0:	bd09                	j	6e2 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 8d2:	008b8493          	addi	s1,s7,8
 8d6:	000bc583          	lbu	a1,0(s7)
 8da:	855a                	mv	a0,s6
 8dc:	d0dff0ef          	jal	5e8 <putc>
 8e0:	8ba6                	mv	s7,s1
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	bbfd                	j	6e2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8e6:	008b8993          	addi	s3,s7,8
 8ea:	000bb483          	ld	s1,0(s7)
 8ee:	cc91                	beqz	s1,90a <vprintf+0x272>
        for(; *s; s++)
 8f0:	0004c583          	lbu	a1,0(s1)
 8f4:	c195                	beqz	a1,918 <vprintf+0x280>
          putc(fd, *s);
 8f6:	855a                	mv	a0,s6
 8f8:	cf1ff0ef          	jal	5e8 <putc>
        for(; *s; s++)
 8fc:	0485                	addi	s1,s1,1
 8fe:	0004c583          	lbu	a1,0(s1)
 902:	f9f5                	bnez	a1,8f6 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 904:	8bce                	mv	s7,s3
      state = 0;
 906:	4981                	li	s3,0
 908:	bbe9                	j	6e2 <vprintf+0x4a>
          s = "(null)";
 90a:	00000497          	auipc	s1,0x0
 90e:	24648493          	addi	s1,s1,582 # b50 <malloc+0x136>
        for(; *s; s++)
 912:	02800593          	li	a1,40
 916:	b7c5                	j	8f6 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 918:	8bce                	mv	s7,s3
      state = 0;
 91a:	4981                	li	s3,0
 91c:	b3d9                	j	6e2 <vprintf+0x4a>
 91e:	6906                	ld	s2,64(sp)
 920:	79e2                	ld	s3,56(sp)
 922:	7a42                	ld	s4,48(sp)
 924:	7aa2                	ld	s5,40(sp)
 926:	7b02                	ld	s6,32(sp)
 928:	6be2                	ld	s7,24(sp)
 92a:	6c42                	ld	s8,16(sp)
 92c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 92e:	60e6                	ld	ra,88(sp)
 930:	6446                	ld	s0,80(sp)
 932:	64a6                	ld	s1,72(sp)
 934:	6125                	addi	sp,sp,96
 936:	8082                	ret

0000000000000938 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 938:	715d                	addi	sp,sp,-80
 93a:	ec06                	sd	ra,24(sp)
 93c:	e822                	sd	s0,16(sp)
 93e:	1000                	addi	s0,sp,32
 940:	e010                	sd	a2,0(s0)
 942:	e414                	sd	a3,8(s0)
 944:	e818                	sd	a4,16(s0)
 946:	ec1c                	sd	a5,24(s0)
 948:	03043023          	sd	a6,32(s0)
 94c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 950:	8622                	mv	a2,s0
 952:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 956:	d43ff0ef          	jal	698 <vprintf>
}
 95a:	60e2                	ld	ra,24(sp)
 95c:	6442                	ld	s0,16(sp)
 95e:	6161                	addi	sp,sp,80
 960:	8082                	ret

0000000000000962 <printf>:

void
printf(const char *fmt, ...)
{
 962:	711d                	addi	sp,sp,-96
 964:	ec06                	sd	ra,24(sp)
 966:	e822                	sd	s0,16(sp)
 968:	1000                	addi	s0,sp,32
 96a:	e40c                	sd	a1,8(s0)
 96c:	e810                	sd	a2,16(s0)
 96e:	ec14                	sd	a3,24(s0)
 970:	f018                	sd	a4,32(s0)
 972:	f41c                	sd	a5,40(s0)
 974:	03043823          	sd	a6,48(s0)
 978:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 97c:	00840613          	addi	a2,s0,8
 980:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 984:	85aa                	mv	a1,a0
 986:	4505                	li	a0,1
 988:	d11ff0ef          	jal	698 <vprintf>
}
 98c:	60e2                	ld	ra,24(sp)
 98e:	6442                	ld	s0,16(sp)
 990:	6125                	addi	sp,sp,96
 992:	8082                	ret

0000000000000994 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 994:	1141                	addi	sp,sp,-16
 996:	e406                	sd	ra,8(sp)
 998:	e022                	sd	s0,0(sp)
 99a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 99c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a0:	00000797          	auipc	a5,0x0
 9a4:	6607b783          	ld	a5,1632(a5) # 1000 <freep>
 9a8:	a02d                	j	9d2 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9aa:	4618                	lw	a4,8(a2)
 9ac:	9f2d                	addw	a4,a4,a1
 9ae:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b2:	6398                	ld	a4,0(a5)
 9b4:	6310                	ld	a2,0(a4)
 9b6:	a83d                	j	9f4 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9b8:	ff852703          	lw	a4,-8(a0)
 9bc:	9f31                	addw	a4,a4,a2
 9be:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9c0:	ff053683          	ld	a3,-16(a0)
 9c4:	a091                	j	a08 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c6:	6398                	ld	a4,0(a5)
 9c8:	00e7e463          	bltu	a5,a4,9d0 <free+0x3c>
 9cc:	00e6ea63          	bltu	a3,a4,9e0 <free+0x4c>
{
 9d0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d2:	fed7fae3          	bgeu	a5,a3,9c6 <free+0x32>
 9d6:	6398                	ld	a4,0(a5)
 9d8:	00e6e463          	bltu	a3,a4,9e0 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9dc:	fee7eae3          	bltu	a5,a4,9d0 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9e0:	ff852583          	lw	a1,-8(a0)
 9e4:	6390                	ld	a2,0(a5)
 9e6:	02059813          	slli	a6,a1,0x20
 9ea:	01c85713          	srli	a4,a6,0x1c
 9ee:	9736                	add	a4,a4,a3
 9f0:	fae60de3          	beq	a2,a4,9aa <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9f4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9f8:	4790                	lw	a2,8(a5)
 9fa:	02061593          	slli	a1,a2,0x20
 9fe:	01c5d713          	srli	a4,a1,0x1c
 a02:	973e                	add	a4,a4,a5
 a04:	fae68ae3          	beq	a3,a4,9b8 <free+0x24>
    p->s.ptr = bp->s.ptr;
 a08:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a0a:	00000717          	auipc	a4,0x0
 a0e:	5ef73b23          	sd	a5,1526(a4) # 1000 <freep>
}
 a12:	60a2                	ld	ra,8(sp)
 a14:	6402                	ld	s0,0(sp)
 a16:	0141                	addi	sp,sp,16
 a18:	8082                	ret

0000000000000a1a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a1a:	7139                	addi	sp,sp,-64
 a1c:	fc06                	sd	ra,56(sp)
 a1e:	f822                	sd	s0,48(sp)
 a20:	f04a                	sd	s2,32(sp)
 a22:	ec4e                	sd	s3,24(sp)
 a24:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a26:	02051993          	slli	s3,a0,0x20
 a2a:	0209d993          	srli	s3,s3,0x20
 a2e:	09bd                	addi	s3,s3,15
 a30:	0049d993          	srli	s3,s3,0x4
 a34:	2985                	addiw	s3,s3,1
 a36:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a38:	00000517          	auipc	a0,0x0
 a3c:	5c853503          	ld	a0,1480(a0) # 1000 <freep>
 a40:	c905                	beqz	a0,a70 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a42:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a44:	4798                	lw	a4,8(a5)
 a46:	09377663          	bgeu	a4,s3,ad2 <malloc+0xb8>
 a4a:	f426                	sd	s1,40(sp)
 a4c:	e852                	sd	s4,16(sp)
 a4e:	e456                	sd	s5,8(sp)
 a50:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a52:	8a4e                	mv	s4,s3
 a54:	6705                	lui	a4,0x1
 a56:	00e9f363          	bgeu	s3,a4,a5c <malloc+0x42>
 a5a:	6a05                	lui	s4,0x1
 a5c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a60:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a64:	00000497          	auipc	s1,0x0
 a68:	59c48493          	addi	s1,s1,1436 # 1000 <freep>
  if(p == SBRK_ERROR)
 a6c:	5afd                	li	s5,-1
 a6e:	a83d                	j	aac <malloc+0x92>
 a70:	f426                	sd	s1,40(sp)
 a72:	e852                	sd	s4,16(sp)
 a74:	e456                	sd	s5,8(sp)
 a76:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a78:	00000797          	auipc	a5,0x0
 a7c:	59878793          	addi	a5,a5,1432 # 1010 <base>
 a80:	00000717          	auipc	a4,0x0
 a84:	58f73023          	sd	a5,1408(a4) # 1000 <freep>
 a88:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a8a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a8e:	b7d1                	j	a52 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a90:	6398                	ld	a4,0(a5)
 a92:	e118                	sd	a4,0(a0)
 a94:	a899                	j	aea <malloc+0xd0>
  hp->s.size = nu;
 a96:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a9a:	0541                	addi	a0,a0,16
 a9c:	ef9ff0ef          	jal	994 <free>
  return freep;
 aa0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 aa2:	c125                	beqz	a0,b02 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa6:	4798                	lw	a4,8(a5)
 aa8:	03277163          	bgeu	a4,s2,aca <malloc+0xb0>
    if(p == freep)
 aac:	6098                	ld	a4,0(s1)
 aae:	853e                	mv	a0,a5
 ab0:	fef71ae3          	bne	a4,a5,aa4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ab4:	8552                	mv	a0,s4
 ab6:	8c7ff0ef          	jal	37c <sbrk>
  if(p == SBRK_ERROR)
 aba:	fd551ee3          	bne	a0,s5,a96 <malloc+0x7c>
        return 0;
 abe:	4501                	li	a0,0
 ac0:	74a2                	ld	s1,40(sp)
 ac2:	6a42                	ld	s4,16(sp)
 ac4:	6aa2                	ld	s5,8(sp)
 ac6:	6b02                	ld	s6,0(sp)
 ac8:	a03d                	j	af6 <malloc+0xdc>
 aca:	74a2                	ld	s1,40(sp)
 acc:	6a42                	ld	s4,16(sp)
 ace:	6aa2                	ld	s5,8(sp)
 ad0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ad2:	fae90fe3          	beq	s2,a4,a90 <malloc+0x76>
        p->s.size -= nunits;
 ad6:	4137073b          	subw	a4,a4,s3
 ada:	c798                	sw	a4,8(a5)
        p += p->s.size;
 adc:	02071693          	slli	a3,a4,0x20
 ae0:	01c6d713          	srli	a4,a3,0x1c
 ae4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ae6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aea:	00000717          	auipc	a4,0x0
 aee:	50a73b23          	sd	a0,1302(a4) # 1000 <freep>
      return (void*)(p + 1);
 af2:	01078513          	addi	a0,a5,16
  }
}
 af6:	70e2                	ld	ra,56(sp)
 af8:	7442                	ld	s0,48(sp)
 afa:	7902                	ld	s2,32(sp)
 afc:	69e2                	ld	s3,24(sp)
 afe:	6121                	addi	sp,sp,64
 b00:	8082                	ret
 b02:	74a2                	ld	s1,40(sp)
 b04:	6a42                	ld	s4,16(sp)
 b06:	6aa2                	ld	s5,8(sp)
 b08:	6b02                	ld	s6,0(sp)
 b0a:	b7f5                	j	af6 <malloc+0xdc>
