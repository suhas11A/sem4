
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
  36:	20000d13          	li	s10,512
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  3a:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  3c:	00001a17          	auipc	s4,0x1
  40:	9f4a0a13          	addi	s4,s4,-1548 # a30 <malloc+0xf8>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  44:	a035                	j	70 <wc+0x70>
      if(strchr(" \r\t\n\v", buf[i]))
  46:	8552                	mv	a0,s4
  48:	1c8000ef          	jal	210 <strchr>
  4c:	c919                	beqz	a0,62 <wc+0x62>
        inword = 0;
  4e:	4901                	li	s2,0
    for(i=0; i<n; i++){
  50:	0485                	addi	s1,s1,1
  52:	01348d63          	beq	s1,s3,6c <wc+0x6c>
      if(buf[i] == '\n')
  56:	0004c583          	lbu	a1,0(s1)
  5a:	ff5596e3          	bne	a1,s5,46 <wc+0x46>
        l++;
  5e:	2b85                	addiw	s7,s7,1
  60:	b7dd                	j	46 <wc+0x46>
      else if(!inword){
  62:	fe0917e3          	bnez	s2,50 <wc+0x50>
        w++;
  66:	2c05                	addiw	s8,s8,1
        inword = 1;
  68:	4905                	li	s2,1
  6a:	b7dd                	j	50 <wc+0x50>
  6c:	019b0cbb          	addw	s9,s6,s9
  while((n = read(fd, buf, sizeof(buf))) > 0){
  70:	866a                	mv	a2,s10
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	3f6000ef          	jal	46e <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009b09b3          	add	s3,s6,s1
  8e:	b7e1                	j	56 <wc+0x56>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86e6                	mv	a3,s9
  9a:	8662                	mv	a2,s8
  9c:	85de                	mv	a1,s7
  9e:	00001517          	auipc	a0,0x1
  a2:	9b250513          	addi	a0,a0,-1614 # a50 <malloc+0x118>
  a6:	7da000ef          	jal	880 <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	97850513          	addi	a0,a0,-1672 # a40 <malloc+0x108>
  d0:	7b0000ef          	jal	880 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	380000ef          	jal	456 <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	38e000ef          	jal	496 <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	362000ef          	jal	47e <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	32e000ef          	jal	456 <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	90658593          	addi	a1,a1,-1786 # a38 <malloc+0x100>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	314000ef          	jal	456 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	91650513          	addi	a0,a0,-1770 # a60 <malloc+0x128>
 152:	72e000ef          	jal	880 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	2fe000ef          	jal	456 <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 164:	f77ff0ef          	jal	da <main>
  exit(r);
 168:	2ee000ef          	jal	456 <exit>

000000000000016c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e406                	sd	ra,8(sp)
 170:	e022                	sd	s0,0(sp)
 172:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 174:	87aa                	mv	a5,a0
 176:	0585                	addi	a1,a1,1
 178:	0785                	addi	a5,a5,1
 17a:	fff5c703          	lbu	a4,-1(a1)
 17e:	fee78fa3          	sb	a4,-1(a5)
 182:	fb75                	bnez	a4,176 <strcpy+0xa>
    ;
  return os;
}
 184:	60a2                	ld	ra,8(sp)
 186:	6402                	ld	s0,0(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e406                	sd	ra,8(sp)
 190:	e022                	sd	s0,0(sp)
 192:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 194:	00054783          	lbu	a5,0(a0)
 198:	cb91                	beqz	a5,1ac <strcmp+0x20>
 19a:	0005c703          	lbu	a4,0(a1)
 19e:	00f71763          	bne	a4,a5,1ac <strcmp+0x20>
    p++, q++;
 1a2:	0505                	addi	a0,a0,1
 1a4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	fbe5                	bnez	a5,19a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1ac:	0005c503          	lbu	a0,0(a1)
}
 1b0:	40a7853b          	subw	a0,a5,a0
 1b4:	60a2                	ld	ra,8(sp)
 1b6:	6402                	ld	s0,0(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <strlen>:

uint
strlen(const char *s)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e406                	sd	ra,8(sp)
 1c0:	e022                	sd	s0,0(sp)
 1c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	cf99                	beqz	a5,1e6 <strlen+0x2a>
 1ca:	0505                	addi	a0,a0,1
 1cc:	87aa                	mv	a5,a0
 1ce:	86be                	mv	a3,a5
 1d0:	0785                	addi	a5,a5,1
 1d2:	fff7c703          	lbu	a4,-1(a5)
 1d6:	ff65                	bnez	a4,1ce <strlen+0x12>
 1d8:	40a6853b          	subw	a0,a3,a0
 1dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1de:	60a2                	ld	ra,8(sp)
 1e0:	6402                	ld	s0,0(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  for(n = 0; s[n]; n++)
 1e6:	4501                	li	a0,0
 1e8:	bfdd                	j	1de <strlen+0x22>

00000000000001ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f2:	ca19                	beqz	a2,208 <memset+0x1e>
 1f4:	87aa                	mv	a5,a0
 1f6:	1602                	slli	a2,a2,0x20
 1f8:	9201                	srli	a2,a2,0x20
 1fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 202:	0785                	addi	a5,a5,1
 204:	fee79de3          	bne	a5,a4,1fe <memset+0x14>
  }
  return dst;
}
 208:	60a2                	ld	ra,8(sp)
 20a:	6402                	ld	s0,0(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret

0000000000000210 <strchr>:

char*
strchr(const char *s, char c)
{
 210:	1141                	addi	sp,sp,-16
 212:	e406                	sd	ra,8(sp)
 214:	e022                	sd	s0,0(sp)
 216:	0800                	addi	s0,sp,16
  for(; *s; s++)
 218:	00054783          	lbu	a5,0(a0)
 21c:	cf81                	beqz	a5,234 <strchr+0x24>
    if(*s == c)
 21e:	00f58763          	beq	a1,a5,22c <strchr+0x1c>
  for(; *s; s++)
 222:	0505                	addi	a0,a0,1
 224:	00054783          	lbu	a5,0(a0)
 228:	fbfd                	bnez	a5,21e <strchr+0xe>
      return (char*)s;
  return 0;
 22a:	4501                	li	a0,0
}
 22c:	60a2                	ld	ra,8(sp)
 22e:	6402                	ld	s0,0(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  return 0;
 234:	4501                	li	a0,0
 236:	bfdd                	j	22c <strchr+0x1c>

0000000000000238 <gets>:

char*
gets(char *buf, int max)
{
 238:	7159                	addi	sp,sp,-112
 23a:	f486                	sd	ra,104(sp)
 23c:	f0a2                	sd	s0,96(sp)
 23e:	eca6                	sd	s1,88(sp)
 240:	e8ca                	sd	s2,80(sp)
 242:	e4ce                	sd	s3,72(sp)
 244:	e0d2                	sd	s4,64(sp)
 246:	fc56                	sd	s5,56(sp)
 248:	f85a                	sd	s6,48(sp)
 24a:	f45e                	sd	s7,40(sp)
 24c:	f062                	sd	s8,32(sp)
 24e:	ec66                	sd	s9,24(sp)
 250:	e86a                	sd	s10,16(sp)
 252:	1880                	addi	s0,sp,112
 254:	8caa                	mv	s9,a0
 256:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 258:	892a                	mv	s2,a0
 25a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 25c:	f9f40b13          	addi	s6,s0,-97
 260:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 262:	4ba9                	li	s7,10
 264:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 266:	8d26                	mv	s10,s1
 268:	0014899b          	addiw	s3,s1,1
 26c:	84ce                	mv	s1,s3
 26e:	0349d563          	bge	s3,s4,298 <gets+0x60>
    cc = read(0, &c, 1);
 272:	8656                	mv	a2,s5
 274:	85da                	mv	a1,s6
 276:	4501                	li	a0,0
 278:	1f6000ef          	jal	46e <read>
    if(cc < 1)
 27c:	00a05e63          	blez	a0,298 <gets+0x60>
    buf[i++] = c;
 280:	f9f44783          	lbu	a5,-97(s0)
 284:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 288:	01778763          	beq	a5,s7,296 <gets+0x5e>
 28c:	0905                	addi	s2,s2,1
 28e:	fd879ce3          	bne	a5,s8,266 <gets+0x2e>
    buf[i++] = c;
 292:	8d4e                	mv	s10,s3
 294:	a011                	j	298 <gets+0x60>
 296:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 298:	9d66                	add	s10,s10,s9
 29a:	000d0023          	sb	zero,0(s10)
  return buf;
}
 29e:	8566                	mv	a0,s9
 2a0:	70a6                	ld	ra,104(sp)
 2a2:	7406                	ld	s0,96(sp)
 2a4:	64e6                	ld	s1,88(sp)
 2a6:	6946                	ld	s2,80(sp)
 2a8:	69a6                	ld	s3,72(sp)
 2aa:	6a06                	ld	s4,64(sp)
 2ac:	7ae2                	ld	s5,56(sp)
 2ae:	7b42                	ld	s6,48(sp)
 2b0:	7ba2                	ld	s7,40(sp)
 2b2:	7c02                	ld	s8,32(sp)
 2b4:	6ce2                	ld	s9,24(sp)
 2b6:	6d42                	ld	s10,16(sp)
 2b8:	6165                	addi	sp,sp,112
 2ba:	8082                	ret

00000000000002bc <stat>:

int
stat(const char *n, struct stat *st)
{
 2bc:	1101                	addi	sp,sp,-32
 2be:	ec06                	sd	ra,24(sp)
 2c0:	e822                	sd	s0,16(sp)
 2c2:	e04a                	sd	s2,0(sp)
 2c4:	1000                	addi	s0,sp,32
 2c6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c8:	4581                	li	a1,0
 2ca:	1cc000ef          	jal	496 <open>
  if(fd < 0)
 2ce:	02054263          	bltz	a0,2f2 <stat+0x36>
 2d2:	e426                	sd	s1,8(sp)
 2d4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d6:	85ca                	mv	a1,s2
 2d8:	1d6000ef          	jal	4ae <fstat>
 2dc:	892a                	mv	s2,a0
  close(fd);
 2de:	8526                	mv	a0,s1
 2e0:	19e000ef          	jal	47e <close>
  return r;
 2e4:	64a2                	ld	s1,8(sp)
}
 2e6:	854a                	mv	a0,s2
 2e8:	60e2                	ld	ra,24(sp)
 2ea:	6442                	ld	s0,16(sp)
 2ec:	6902                	ld	s2,0(sp)
 2ee:	6105                	addi	sp,sp,32
 2f0:	8082                	ret
    return -1;
 2f2:	597d                	li	s2,-1
 2f4:	bfcd                	j	2e6 <stat+0x2a>

00000000000002f6 <atoi>:

int
atoi(const char *s)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e406                	sd	ra,8(sp)
 2fa:	e022                	sd	s0,0(sp)
 2fc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fe:	00054683          	lbu	a3,0(a0)
 302:	fd06879b          	addiw	a5,a3,-48
 306:	0ff7f793          	zext.b	a5,a5
 30a:	4625                	li	a2,9
 30c:	02f66963          	bltu	a2,a5,33e <atoi+0x48>
 310:	872a                	mv	a4,a0
  n = 0;
 312:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 314:	0705                	addi	a4,a4,1
 316:	0025179b          	slliw	a5,a0,0x2
 31a:	9fa9                	addw	a5,a5,a0
 31c:	0017979b          	slliw	a5,a5,0x1
 320:	9fb5                	addw	a5,a5,a3
 322:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 326:	00074683          	lbu	a3,0(a4)
 32a:	fd06879b          	addiw	a5,a3,-48
 32e:	0ff7f793          	zext.b	a5,a5
 332:	fef671e3          	bgeu	a2,a5,314 <atoi+0x1e>
  return n;
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret
  n = 0;
 33e:	4501                	li	a0,0
 340:	bfdd                	j	336 <atoi+0x40>

0000000000000342 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e406                	sd	ra,8(sp)
 346:	e022                	sd	s0,0(sp)
 348:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34a:	02b57563          	bgeu	a0,a1,374 <memmove+0x32>
    while(n-- > 0)
 34e:	00c05f63          	blez	a2,36c <memmove+0x2a>
 352:	1602                	slli	a2,a2,0x20
 354:	9201                	srli	a2,a2,0x20
 356:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 35a:	872a                	mv	a4,a0
      *dst++ = *src++;
 35c:	0585                	addi	a1,a1,1
 35e:	0705                	addi	a4,a4,1
 360:	fff5c683          	lbu	a3,-1(a1)
 364:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 368:	fee79ae3          	bne	a5,a4,35c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 36c:	60a2                	ld	ra,8(sp)
 36e:	6402                	ld	s0,0(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret
    dst += n;
 374:	00c50733          	add	a4,a0,a2
    src += n;
 378:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 37a:	fec059e3          	blez	a2,36c <memmove+0x2a>
 37e:	fff6079b          	addiw	a5,a2,-1
 382:	1782                	slli	a5,a5,0x20
 384:	9381                	srli	a5,a5,0x20
 386:	fff7c793          	not	a5,a5
 38a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 38c:	15fd                	addi	a1,a1,-1
 38e:	177d                	addi	a4,a4,-1
 390:	0005c683          	lbu	a3,0(a1)
 394:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 398:	fef71ae3          	bne	a4,a5,38c <memmove+0x4a>
 39c:	bfc1                	j	36c <memmove+0x2a>

000000000000039e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 39e:	1141                	addi	sp,sp,-16
 3a0:	e406                	sd	ra,8(sp)
 3a2:	e022                	sd	s0,0(sp)
 3a4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a6:	ca0d                	beqz	a2,3d8 <memcmp+0x3a>
 3a8:	fff6069b          	addiw	a3,a2,-1
 3ac:	1682                	slli	a3,a3,0x20
 3ae:	9281                	srli	a3,a3,0x20
 3b0:	0685                	addi	a3,a3,1
 3b2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b4:	00054783          	lbu	a5,0(a0)
 3b8:	0005c703          	lbu	a4,0(a1)
 3bc:	00e79863          	bne	a5,a4,3cc <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 3c0:	0505                	addi	a0,a0,1
    p2++;
 3c2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c4:	fed518e3          	bne	a0,a3,3b4 <memcmp+0x16>
  }
  return 0;
 3c8:	4501                	li	a0,0
 3ca:	a019                	j	3d0 <memcmp+0x32>
      return *p1 - *p2;
 3cc:	40e7853b          	subw	a0,a5,a4
}
 3d0:	60a2                	ld	ra,8(sp)
 3d2:	6402                	ld	s0,0(sp)
 3d4:	0141                	addi	sp,sp,16
 3d6:	8082                	ret
  return 0;
 3d8:	4501                	li	a0,0
 3da:	bfdd                	j	3d0 <memcmp+0x32>

00000000000003dc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e406                	sd	ra,8(sp)
 3e0:	e022                	sd	s0,0(sp)
 3e2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e4:	f5fff0ef          	jal	342 <memmove>
}
 3e8:	60a2                	ld	ra,8(sp)
 3ea:	6402                	ld	s0,0(sp)
 3ec:	0141                	addi	sp,sp,16
 3ee:	8082                	ret

00000000000003f0 <sbrk>:

char *
sbrk(int n) {
 3f0:	1141                	addi	sp,sp,-16
 3f2:	e406                	sd	ra,8(sp)
 3f4:	e022                	sd	s0,0(sp)
 3f6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3f8:	4585                	li	a1,1
 3fa:	0e4000ef          	jal	4de <sys_sbrk>
}
 3fe:	60a2                	ld	ra,8(sp)
 400:	6402                	ld	s0,0(sp)
 402:	0141                	addi	sp,sp,16
 404:	8082                	ret

0000000000000406 <sbrklazy>:

char *
sbrklazy(int n) {
 406:	1141                	addi	sp,sp,-16
 408:	e406                	sd	ra,8(sp)
 40a:	e022                	sd	s0,0(sp)
 40c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 40e:	4589                	li	a1,2
 410:	0ce000ef          	jal	4de <sys_sbrk>
}
 414:	60a2                	ld	ra,8(sp)
 416:	6402                	ld	s0,0(sp)
 418:	0141                	addi	sp,sp,16
 41a:	8082                	ret

000000000000041c <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 41c:	1101                	addi	sp,sp,-32
 41e:	ec06                	sd	ra,24(sp)
 420:	e822                	sd	s0,16(sp)
 422:	e426                	sd	s1,8(sp)
 424:	e04a                	sd	s2,0(sp)
 426:	1000                	addi	s0,sp,32
 428:	84aa                	mv	s1,a0
 42a:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 42c:	6505                	lui	a0,0x1
 42e:	fc3ff0ef          	jal	3f0 <sbrk>
 432:	6785                	lui	a5,0x1
 434:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 438:	9a41                	andi	a2,a2,-16
 43a:	85ca                	mv	a1,s2
 43c:	8526                	mv	a0,s1
 43e:	0b8000ef          	jal	4f6 <clone>
 442:	60e2                	ld	ra,24(sp)
 444:	6442                	ld	s0,16(sp)
 446:	64a2                	ld	s1,8(sp)
 448:	6902                	ld	s2,0(sp)
 44a:	6105                	addi	sp,sp,32
 44c:	8082                	ret

000000000000044e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 44e:	4885                	li	a7,1
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <exit>:
.global exit
exit:
 li a7, SYS_exit
 456:	4889                	li	a7,2
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <wait>:
.global wait
wait:
 li a7, SYS_wait
 45e:	488d                	li	a7,3
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 466:	4891                	li	a7,4
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <read>:
.global read
read:
 li a7, SYS_read
 46e:	4895                	li	a7,5
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <write>:
.global write
write:
 li a7, SYS_write
 476:	48c1                	li	a7,16
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <close>:
.global close
close:
 li a7, SYS_close
 47e:	48d5                	li	a7,21
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <kill>:
.global kill
kill:
 li a7, SYS_kill
 486:	4899                	li	a7,6
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <exec>:
.global exec
exec:
 li a7, SYS_exec
 48e:	489d                	li	a7,7
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <open>:
.global open
open:
 li a7, SYS_open
 496:	48bd                	li	a7,15
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 49e:	48c5                	li	a7,17
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4a6:	48c9                	li	a7,18
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4ae:	48a1                	li	a7,8
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <link>:
.global link
link:
 li a7, SYS_link
 4b6:	48cd                	li	a7,19
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4be:	48d1                	li	a7,20
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4c6:	48a5                	li	a7,9
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ce:	48a9                	li	a7,10
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4d6:	48ad                	li	a7,11
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4de:	48b1                	li	a7,12
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4e6:	48b5                	li	a7,13
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ee:	48b9                	li	a7,14
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <clone>:
.global clone
clone:
 li a7, SYS_clone
 4f6:	48d9                	li	a7,22
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <join>:
.global join
join:
 li a7, SYS_join
 4fe:	48dd                	li	a7,23
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 506:	1101                	addi	sp,sp,-32
 508:	ec06                	sd	ra,24(sp)
 50a:	e822                	sd	s0,16(sp)
 50c:	1000                	addi	s0,sp,32
 50e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 512:	4605                	li	a2,1
 514:	fef40593          	addi	a1,s0,-17
 518:	f5fff0ef          	jal	476 <write>
}
 51c:	60e2                	ld	ra,24(sp)
 51e:	6442                	ld	s0,16(sp)
 520:	6105                	addi	sp,sp,32
 522:	8082                	ret

0000000000000524 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 524:	715d                	addi	sp,sp,-80
 526:	e486                	sd	ra,72(sp)
 528:	e0a2                	sd	s0,64(sp)
 52a:	fc26                	sd	s1,56(sp)
 52c:	f84a                	sd	s2,48(sp)
 52e:	f44e                	sd	s3,40(sp)
 530:	0880                	addi	s0,sp,80
 532:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 534:	c299                	beqz	a3,53a <printint+0x16>
 536:	0605cc63          	bltz	a1,5ae <printint+0x8a>
  neg = 0;
 53a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 53c:	fb840313          	addi	t1,s0,-72
  neg = 0;
 540:	869a                	mv	a3,t1
  i = 0;
 542:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 544:	00000817          	auipc	a6,0x0
 548:	53c80813          	addi	a6,a6,1340 # a80 <digits>
 54c:	88be                	mv	a7,a5
 54e:	0017851b          	addiw	a0,a5,1 # 1001 <freep+0x1>
 552:	87aa                	mv	a5,a0
 554:	02c5f733          	remu	a4,a1,a2
 558:	9742                	add	a4,a4,a6
 55a:	00074703          	lbu	a4,0(a4)
 55e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 562:	872e                	mv	a4,a1
 564:	02c5d5b3          	divu	a1,a1,a2
 568:	0685                	addi	a3,a3,1
 56a:	fec771e3          	bgeu	a4,a2,54c <printint+0x28>
  if(neg)
 56e:	000e0c63          	beqz	t3,586 <printint+0x62>
    buf[i++] = '-';
 572:	fd050793          	addi	a5,a0,-48 # fd0 <digits+0x550>
 576:	00878533          	add	a0,a5,s0
 57a:	02d00793          	li	a5,45
 57e:	fef50423          	sb	a5,-24(a0)
 582:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 586:	fff7899b          	addiw	s3,a5,-1
 58a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 58e:	fff4c583          	lbu	a1,-1(s1)
 592:	854a                	mv	a0,s2
 594:	f73ff0ef          	jal	506 <putc>
  while(--i >= 0)
 598:	39fd                	addiw	s3,s3,-1
 59a:	14fd                	addi	s1,s1,-1
 59c:	fe09d9e3          	bgez	s3,58e <printint+0x6a>
}
 5a0:	60a6                	ld	ra,72(sp)
 5a2:	6406                	ld	s0,64(sp)
 5a4:	74e2                	ld	s1,56(sp)
 5a6:	7942                	ld	s2,48(sp)
 5a8:	79a2                	ld	s3,40(sp)
 5aa:	6161                	addi	sp,sp,80
 5ac:	8082                	ret
    x = -xx;
 5ae:	40b005b3          	neg	a1,a1
    neg = 1;
 5b2:	4e05                	li	t3,1
    x = -xx;
 5b4:	b761                	j	53c <printint+0x18>

00000000000005b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b6:	711d                	addi	sp,sp,-96
 5b8:	ec86                	sd	ra,88(sp)
 5ba:	e8a2                	sd	s0,80(sp)
 5bc:	e4a6                	sd	s1,72(sp)
 5be:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c0:	0005c483          	lbu	s1,0(a1)
 5c4:	28048463          	beqz	s1,84c <vprintf+0x296>
 5c8:	e0ca                	sd	s2,64(sp)
 5ca:	fc4e                	sd	s3,56(sp)
 5cc:	f852                	sd	s4,48(sp)
 5ce:	f456                	sd	s5,40(sp)
 5d0:	f05a                	sd	s6,32(sp)
 5d2:	ec5e                	sd	s7,24(sp)
 5d4:	e862                	sd	s8,16(sp)
 5d6:	e466                	sd	s9,8(sp)
 5d8:	8b2a                	mv	s6,a0
 5da:	8a2e                	mv	s4,a1
 5dc:	8bb2                	mv	s7,a2
  state = 0;
 5de:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5e0:	4901                	li	s2,0
 5e2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5e4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5e8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5ec:	06c00c93          	li	s9,108
 5f0:	a00d                	j	612 <vprintf+0x5c>
        putc(fd, c0);
 5f2:	85a6                	mv	a1,s1
 5f4:	855a                	mv	a0,s6
 5f6:	f11ff0ef          	jal	506 <putc>
 5fa:	a019                	j	600 <vprintf+0x4a>
    } else if(state == '%'){
 5fc:	03598363          	beq	s3,s5,622 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 600:	0019079b          	addiw	a5,s2,1
 604:	893e                	mv	s2,a5
 606:	873e                	mv	a4,a5
 608:	97d2                	add	a5,a5,s4
 60a:	0007c483          	lbu	s1,0(a5)
 60e:	22048763          	beqz	s1,83c <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 612:	0004879b          	sext.w	a5,s1
    if(state == 0){
 616:	fe0993e3          	bnez	s3,5fc <vprintf+0x46>
      if(c0 == '%'){
 61a:	fd579ce3          	bne	a5,s5,5f2 <vprintf+0x3c>
        state = '%';
 61e:	89be                	mv	s3,a5
 620:	b7c5                	j	600 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 622:	00ea06b3          	add	a3,s4,a4
 626:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 62a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 62c:	c681                	beqz	a3,634 <vprintf+0x7e>
 62e:	9752                	add	a4,a4,s4
 630:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 634:	05878263          	beq	a5,s8,678 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 638:	05978c63          	beq	a5,s9,690 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 63c:	07500713          	li	a4,117
 640:	0ee78663          	beq	a5,a4,72c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 644:	07800713          	li	a4,120
 648:	12e78863          	beq	a5,a4,778 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 64c:	07000713          	li	a4,112
 650:	14e78d63          	beq	a5,a4,7aa <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 654:	06300713          	li	a4,99
 658:	18e78c63          	beq	a5,a4,7f0 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 65c:	07300713          	li	a4,115
 660:	1ae78263          	beq	a5,a4,804 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 664:	02500713          	li	a4,37
 668:	04e79463          	bne	a5,a4,6b0 <vprintf+0xfa>
        putc(fd, '%');
 66c:	85ba                	mv	a1,a4
 66e:	855a                	mv	a0,s6
 670:	e97ff0ef          	jal	506 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 674:	4981                	li	s3,0
 676:	b769                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 678:	008b8493          	addi	s1,s7,8
 67c:	4685                	li	a3,1
 67e:	4629                	li	a2,10
 680:	000ba583          	lw	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	e9fff0ef          	jal	524 <printint>
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bf8d                	j	600 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 690:	06400793          	li	a5,100
 694:	02f68963          	beq	a3,a5,6c6 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 698:	06c00793          	li	a5,108
 69c:	04f68263          	beq	a3,a5,6e0 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 6a0:	07500793          	li	a5,117
 6a4:	0af68063          	beq	a3,a5,744 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 6a8:	07800793          	li	a5,120
 6ac:	0ef68263          	beq	a3,a5,790 <vprintf+0x1da>
        putc(fd, '%');
 6b0:	02500593          	li	a1,37
 6b4:	855a                	mv	a0,s6
 6b6:	e51ff0ef          	jal	506 <putc>
        putc(fd, c0);
 6ba:	85a6                	mv	a1,s1
 6bc:	855a                	mv	a0,s6
 6be:	e49ff0ef          	jal	506 <putc>
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bf35                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c6:	008b8493          	addi	s1,s7,8
 6ca:	4685                	li	a3,1
 6cc:	4629                	li	a2,10
 6ce:	000bb583          	ld	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	e51ff0ef          	jal	524 <printint>
        i += 1;
 6d8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6da:	8ba6                	mv	s7,s1
      state = 0;
 6dc:	4981                	li	s3,0
        i += 1;
 6de:	b70d                	j	600 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e0:	06400793          	li	a5,100
 6e4:	02f60763          	beq	a2,a5,712 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6e8:	07500793          	li	a5,117
 6ec:	06f60963          	beq	a2,a5,75e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6f0:	07800793          	li	a5,120
 6f4:	faf61ee3          	bne	a2,a5,6b0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f8:	008b8493          	addi	s1,s7,8
 6fc:	4681                	li	a3,0
 6fe:	4641                	li	a2,16
 700:	000bb583          	ld	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	e1fff0ef          	jal	524 <printint>
        i += 2;
 70a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 70c:	8ba6                	mv	s7,s1
      state = 0;
 70e:	4981                	li	s3,0
        i += 2;
 710:	bdc5                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 712:	008b8493          	addi	s1,s7,8
 716:	4685                	li	a3,1
 718:	4629                	li	a2,10
 71a:	000bb583          	ld	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	e05ff0ef          	jal	524 <printint>
        i += 2;
 724:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 726:	8ba6                	mv	s7,s1
      state = 0;
 728:	4981                	li	s3,0
        i += 2;
 72a:	bdd9                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 72c:	008b8493          	addi	s1,s7,8
 730:	4681                	li	a3,0
 732:	4629                	li	a2,10
 734:	000be583          	lwu	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	debff0ef          	jal	524 <printint>
 73e:	8ba6                	mv	s7,s1
      state = 0;
 740:	4981                	li	s3,0
 742:	bd7d                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 744:	008b8493          	addi	s1,s7,8
 748:	4681                	li	a3,0
 74a:	4629                	li	a2,10
 74c:	000bb583          	ld	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	dd3ff0ef          	jal	524 <printint>
        i += 1;
 756:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 758:	8ba6                	mv	s7,s1
      state = 0;
 75a:	4981                	li	s3,0
        i += 1;
 75c:	b555                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 75e:	008b8493          	addi	s1,s7,8
 762:	4681                	li	a3,0
 764:	4629                	li	a2,10
 766:	000bb583          	ld	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	db9ff0ef          	jal	524 <printint>
        i += 2;
 770:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 772:	8ba6                	mv	s7,s1
      state = 0;
 774:	4981                	li	s3,0
        i += 2;
 776:	b569                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 778:	008b8493          	addi	s1,s7,8
 77c:	4681                	li	a3,0
 77e:	4641                	li	a2,16
 780:	000be583          	lwu	a1,0(s7)
 784:	855a                	mv	a0,s6
 786:	d9fff0ef          	jal	524 <printint>
 78a:	8ba6                	mv	s7,s1
      state = 0;
 78c:	4981                	li	s3,0
 78e:	bd8d                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 790:	008b8493          	addi	s1,s7,8
 794:	4681                	li	a3,0
 796:	4641                	li	a2,16
 798:	000bb583          	ld	a1,0(s7)
 79c:	855a                	mv	a0,s6
 79e:	d87ff0ef          	jal	524 <printint>
        i += 1;
 7a2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a4:	8ba6                	mv	s7,s1
      state = 0;
 7a6:	4981                	li	s3,0
        i += 1;
 7a8:	bda1                	j	600 <vprintf+0x4a>
 7aa:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7ac:	008b8d13          	addi	s10,s7,8
 7b0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7b4:	03000593          	li	a1,48
 7b8:	855a                	mv	a0,s6
 7ba:	d4dff0ef          	jal	506 <putc>
  putc(fd, 'x');
 7be:	07800593          	li	a1,120
 7c2:	855a                	mv	a0,s6
 7c4:	d43ff0ef          	jal	506 <putc>
 7c8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ca:	00000b97          	auipc	s7,0x0
 7ce:	2b6b8b93          	addi	s7,s7,694 # a80 <digits>
 7d2:	03c9d793          	srli	a5,s3,0x3c
 7d6:	97de                	add	a5,a5,s7
 7d8:	0007c583          	lbu	a1,0(a5)
 7dc:	855a                	mv	a0,s6
 7de:	d29ff0ef          	jal	506 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e2:	0992                	slli	s3,s3,0x4
 7e4:	34fd                	addiw	s1,s1,-1
 7e6:	f4f5                	bnez	s1,7d2 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7e8:	8bea                	mv	s7,s10
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	6d02                	ld	s10,0(sp)
 7ee:	bd09                	j	600 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7f0:	008b8493          	addi	s1,s7,8
 7f4:	000bc583          	lbu	a1,0(s7)
 7f8:	855a                	mv	a0,s6
 7fa:	d0dff0ef          	jal	506 <putc>
 7fe:	8ba6                	mv	s7,s1
      state = 0;
 800:	4981                	li	s3,0
 802:	bbfd                	j	600 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 804:	008b8993          	addi	s3,s7,8
 808:	000bb483          	ld	s1,0(s7)
 80c:	cc91                	beqz	s1,828 <vprintf+0x272>
        for(; *s; s++)
 80e:	0004c583          	lbu	a1,0(s1)
 812:	c195                	beqz	a1,836 <vprintf+0x280>
          putc(fd, *s);
 814:	855a                	mv	a0,s6
 816:	cf1ff0ef          	jal	506 <putc>
        for(; *s; s++)
 81a:	0485                	addi	s1,s1,1
 81c:	0004c583          	lbu	a1,0(s1)
 820:	f9f5                	bnez	a1,814 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 822:	8bce                	mv	s7,s3
      state = 0;
 824:	4981                	li	s3,0
 826:	bbe9                	j	600 <vprintf+0x4a>
          s = "(null)";
 828:	00000497          	auipc	s1,0x0
 82c:	25048493          	addi	s1,s1,592 # a78 <malloc+0x140>
        for(; *s; s++)
 830:	02800593          	li	a1,40
 834:	b7c5                	j	814 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 836:	8bce                	mv	s7,s3
      state = 0;
 838:	4981                	li	s3,0
 83a:	b3d9                	j	600 <vprintf+0x4a>
 83c:	6906                	ld	s2,64(sp)
 83e:	79e2                	ld	s3,56(sp)
 840:	7a42                	ld	s4,48(sp)
 842:	7aa2                	ld	s5,40(sp)
 844:	7b02                	ld	s6,32(sp)
 846:	6be2                	ld	s7,24(sp)
 848:	6c42                	ld	s8,16(sp)
 84a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 84c:	60e6                	ld	ra,88(sp)
 84e:	6446                	ld	s0,80(sp)
 850:	64a6                	ld	s1,72(sp)
 852:	6125                	addi	sp,sp,96
 854:	8082                	ret

0000000000000856 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 856:	715d                	addi	sp,sp,-80
 858:	ec06                	sd	ra,24(sp)
 85a:	e822                	sd	s0,16(sp)
 85c:	1000                	addi	s0,sp,32
 85e:	e010                	sd	a2,0(s0)
 860:	e414                	sd	a3,8(s0)
 862:	e818                	sd	a4,16(s0)
 864:	ec1c                	sd	a5,24(s0)
 866:	03043023          	sd	a6,32(s0)
 86a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 86e:	8622                	mv	a2,s0
 870:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 874:	d43ff0ef          	jal	5b6 <vprintf>
}
 878:	60e2                	ld	ra,24(sp)
 87a:	6442                	ld	s0,16(sp)
 87c:	6161                	addi	sp,sp,80
 87e:	8082                	ret

0000000000000880 <printf>:

void
printf(const char *fmt, ...)
{
 880:	711d                	addi	sp,sp,-96
 882:	ec06                	sd	ra,24(sp)
 884:	e822                	sd	s0,16(sp)
 886:	1000                	addi	s0,sp,32
 888:	e40c                	sd	a1,8(s0)
 88a:	e810                	sd	a2,16(s0)
 88c:	ec14                	sd	a3,24(s0)
 88e:	f018                	sd	a4,32(s0)
 890:	f41c                	sd	a5,40(s0)
 892:	03043823          	sd	a6,48(s0)
 896:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 89a:	00840613          	addi	a2,s0,8
 89e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8a2:	85aa                	mv	a1,a0
 8a4:	4505                	li	a0,1
 8a6:	d11ff0ef          	jal	5b6 <vprintf>
}
 8aa:	60e2                	ld	ra,24(sp)
 8ac:	6442                	ld	s0,16(sp)
 8ae:	6125                	addi	sp,sp,96
 8b0:	8082                	ret

00000000000008b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b2:	1141                	addi	sp,sp,-16
 8b4:	e406                	sd	ra,8(sp)
 8b6:	e022                	sd	s0,0(sp)
 8b8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ba:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8be:	00000797          	auipc	a5,0x0
 8c2:	7427b783          	ld	a5,1858(a5) # 1000 <freep>
 8c6:	a02d                	j	8f0 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c8:	4618                	lw	a4,8(a2)
 8ca:	9f2d                	addw	a4,a4,a1
 8cc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d0:	6398                	ld	a4,0(a5)
 8d2:	6310                	ld	a2,0(a4)
 8d4:	a83d                	j	912 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8d6:	ff852703          	lw	a4,-8(a0)
 8da:	9f31                	addw	a4,a4,a2
 8dc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8de:	ff053683          	ld	a3,-16(a0)
 8e2:	a091                	j	926 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e4:	6398                	ld	a4,0(a5)
 8e6:	00e7e463          	bltu	a5,a4,8ee <free+0x3c>
 8ea:	00e6ea63          	bltu	a3,a4,8fe <free+0x4c>
{
 8ee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f0:	fed7fae3          	bgeu	a5,a3,8e4 <free+0x32>
 8f4:	6398                	ld	a4,0(a5)
 8f6:	00e6e463          	bltu	a3,a4,8fe <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fa:	fee7eae3          	bltu	a5,a4,8ee <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 8fe:	ff852583          	lw	a1,-8(a0)
 902:	6390                	ld	a2,0(a5)
 904:	02059813          	slli	a6,a1,0x20
 908:	01c85713          	srli	a4,a6,0x1c
 90c:	9736                	add	a4,a4,a3
 90e:	fae60de3          	beq	a2,a4,8c8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 912:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 916:	4790                	lw	a2,8(a5)
 918:	02061593          	slli	a1,a2,0x20
 91c:	01c5d713          	srli	a4,a1,0x1c
 920:	973e                	add	a4,a4,a5
 922:	fae68ae3          	beq	a3,a4,8d6 <free+0x24>
    p->s.ptr = bp->s.ptr;
 926:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 928:	00000717          	auipc	a4,0x0
 92c:	6cf73c23          	sd	a5,1752(a4) # 1000 <freep>
}
 930:	60a2                	ld	ra,8(sp)
 932:	6402                	ld	s0,0(sp)
 934:	0141                	addi	sp,sp,16
 936:	8082                	ret

0000000000000938 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 938:	7139                	addi	sp,sp,-64
 93a:	fc06                	sd	ra,56(sp)
 93c:	f822                	sd	s0,48(sp)
 93e:	f04a                	sd	s2,32(sp)
 940:	ec4e                	sd	s3,24(sp)
 942:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 944:	02051993          	slli	s3,a0,0x20
 948:	0209d993          	srli	s3,s3,0x20
 94c:	09bd                	addi	s3,s3,15
 94e:	0049d993          	srli	s3,s3,0x4
 952:	2985                	addiw	s3,s3,1
 954:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 956:	00000517          	auipc	a0,0x0
 95a:	6aa53503          	ld	a0,1706(a0) # 1000 <freep>
 95e:	c905                	beqz	a0,98e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 960:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 962:	4798                	lw	a4,8(a5)
 964:	09377663          	bgeu	a4,s3,9f0 <malloc+0xb8>
 968:	f426                	sd	s1,40(sp)
 96a:	e852                	sd	s4,16(sp)
 96c:	e456                	sd	s5,8(sp)
 96e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 970:	8a4e                	mv	s4,s3
 972:	6705                	lui	a4,0x1
 974:	00e9f363          	bgeu	s3,a4,97a <malloc+0x42>
 978:	6a05                	lui	s4,0x1
 97a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 97e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 982:	00000497          	auipc	s1,0x0
 986:	67e48493          	addi	s1,s1,1662 # 1000 <freep>
  if(p == SBRK_ERROR)
 98a:	5afd                	li	s5,-1
 98c:	a83d                	j	9ca <malloc+0x92>
 98e:	f426                	sd	s1,40(sp)
 990:	e852                	sd	s4,16(sp)
 992:	e456                	sd	s5,8(sp)
 994:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 996:	00001797          	auipc	a5,0x1
 99a:	87a78793          	addi	a5,a5,-1926 # 1210 <base>
 99e:	00000717          	auipc	a4,0x0
 9a2:	66f73123          	sd	a5,1634(a4) # 1000 <freep>
 9a6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9a8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ac:	b7d1                	j	970 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9ae:	6398                	ld	a4,0(a5)
 9b0:	e118                	sd	a4,0(a0)
 9b2:	a899                	j	a08 <malloc+0xd0>
  hp->s.size = nu;
 9b4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9b8:	0541                	addi	a0,a0,16
 9ba:	ef9ff0ef          	jal	8b2 <free>
  return freep;
 9be:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9c0:	c125                	beqz	a0,a20 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c4:	4798                	lw	a4,8(a5)
 9c6:	03277163          	bgeu	a4,s2,9e8 <malloc+0xb0>
    if(p == freep)
 9ca:	6098                	ld	a4,0(s1)
 9cc:	853e                	mv	a0,a5
 9ce:	fef71ae3          	bne	a4,a5,9c2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9d2:	8552                	mv	a0,s4
 9d4:	a1dff0ef          	jal	3f0 <sbrk>
  if(p == SBRK_ERROR)
 9d8:	fd551ee3          	bne	a0,s5,9b4 <malloc+0x7c>
        return 0;
 9dc:	4501                	li	a0,0
 9de:	74a2                	ld	s1,40(sp)
 9e0:	6a42                	ld	s4,16(sp)
 9e2:	6aa2                	ld	s5,8(sp)
 9e4:	6b02                	ld	s6,0(sp)
 9e6:	a03d                	j	a14 <malloc+0xdc>
 9e8:	74a2                	ld	s1,40(sp)
 9ea:	6a42                	ld	s4,16(sp)
 9ec:	6aa2                	ld	s5,8(sp)
 9ee:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9f0:	fae90fe3          	beq	s2,a4,9ae <malloc+0x76>
        p->s.size -= nunits;
 9f4:	4137073b          	subw	a4,a4,s3
 9f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9fa:	02071693          	slli	a3,a4,0x20
 9fe:	01c6d713          	srli	a4,a3,0x1c
 a02:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a04:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a08:	00000717          	auipc	a4,0x0
 a0c:	5ea73c23          	sd	a0,1528(a4) # 1000 <freep>
      return (void*)(p + 1);
 a10:	01078513          	addi	a0,a5,16
  }
}
 a14:	70e2                	ld	ra,56(sp)
 a16:	7442                	ld	s0,48(sp)
 a18:	7902                	ld	s2,32(sp)
 a1a:	69e2                	ld	s3,24(sp)
 a1c:	6121                	addi	sp,sp,64
 a1e:	8082                	ret
 a20:	74a2                	ld	s1,40(sp)
 a22:	6a42                	ld	s4,16(sp)
 a24:	6aa2                	ld	s5,8(sp)
 a26:	6b02                	ld	s6,0(sp)
 a28:	b7f5                	j	a14 <malloc+0xdc>
