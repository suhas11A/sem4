
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
  40:	b44a0a13          	addi	s4,s4,-1212 # b80 <malloc+0xf2>
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
  78:	53c000ef          	jal	5b4 <read>
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
  a2:	b0250513          	addi	a0,a0,-1278 # ba0 <malloc+0x112>
  a6:	131000ef          	jal	9d6 <printf>
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
  cc:	ac850513          	addi	a0,a0,-1336 # b90 <malloc+0x102>
  d0:	107000ef          	jal	9d6 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	4c6000ef          	jal	59c <exit>

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
 108:	4d4000ef          	jal	5dc <open>
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
 11c:	4a8000ef          	jal	5c4 <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	474000ef          	jal	59c <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	a5658593          	addi	a1,a1,-1450 # b88 <malloc+0xfa>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	45a000ef          	jal	59c <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	a6650513          	addi	a0,a0,-1434 # bb0 <malloc+0x122>
 152:	085000ef          	jal	9d6 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	444000ef          	jal	59c <exit>

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
 168:	434000ef          	jal	59c <exit>

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
 278:	33c000ef          	jal	5b4 <read>
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
 2ca:	312000ef          	jal	5dc <open>
  if(fd < 0)
 2ce:	02054263          	bltz	a0,2f2 <stat+0x36>
 2d2:	e426                	sd	s1,8(sp)
 2d4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d6:	85ca                	mv	a1,s2
 2d8:	31c000ef          	jal	5f4 <fstat>
 2dc:	892a                	mv	s2,a0
  close(fd);
 2de:	8526                	mv	a0,s1
 2e0:	2e4000ef          	jal	5c4 <close>
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
 3fa:	22a000ef          	jal	624 <sys_sbrk>
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
 410:	214000ef          	jal	624 <sys_sbrk>
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
 43e:	1fe000ef          	jal	63c <clone>
}
 442:	60e2                	ld	ra,24(sp)
 444:	6442                	ld	s0,16(sp)
 446:	64a2                	ld	s1,8(sp)
 448:	6902                	ld	s2,0(sp)
 44a:	6105                	addi	sp,sp,32
 44c:	8082                	ret

000000000000044e <futex>:

void futex(int *uaddr, int ops, int val) {
 44e:	7179                	addi	sp,sp,-48
 450:	f406                	sd	ra,40(sp)
 452:	f022                	sd	s0,32(sp)
 454:	ec26                	sd	s1,24(sp)
 456:	1800                	addi	s0,sp,48
 458:	84aa                	mv	s1,a0
  if (ops==0) {
 45a:	ed95                	bnez	a1,496 <futex+0x48>
    if (val==0) {
 45c:	c611                	beqz	a2,468 <futex+0x1a>
 45e:	e84a                	sd	s2,16(sp)
 460:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 462:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 464:	4985                	li	s3,1
 466:	a005                	j	486 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 468:	4705                	li	a4,1
 46a:	87ba                	mv	a5,a4
 46c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 470:	2781                	sext.w	a5,a5
 472:	ffe5                	bnez	a5,46a <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 474:	70a2                	ld	ra,40(sp)
 476:	7402                	ld	s0,32(sp)
 478:	64e2                	ld	s1,24(sp)
 47a:	6145                	addi	sp,sp,48
 47c:	8082                	ret
        futex_wait(uaddr, 1);
 47e:	85ce                	mv	a1,s3
 480:	8526                	mv	a0,s1
 482:	1ca000ef          	jal	64c <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 486:	87ca                	mv	a5,s2
 488:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 48c:	2781                	sext.w	a5,a5
 48e:	fbe5                	bnez	a5,47e <futex+0x30>
 490:	6942                	ld	s2,16(sp)
 492:	69a2                	ld	s3,8(sp)
 494:	b7c5                	j	474 <futex+0x26>
    if (val==0) {
 496:	e611                	bnez	a2,4a2 <futex+0x54>
      __sync_lock_release(uaddr);
 498:	0310000f          	fence	rw,w
 49c:	00052023          	sw	zero,0(a0) # 1000 <freep>
 4a0:	bfd1                	j	474 <futex+0x26>
      __sync_lock_release(uaddr);
 4a2:	0310000f          	fence	rw,w
 4a6:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 4aa:	1aa000ef          	jal	654 <futex_wake>
  return;
 4ae:	b7d9                	j	474 <futex+0x26>

00000000000004b0 <sem_init>:

void sem_init(sem_t* s, int val) {
 4b0:	7179                	addi	sp,sp,-48
 4b2:	f406                	sd	ra,40(sp)
 4b4:	f022                	sd	s0,32(sp)
 4b6:	ec26                	sd	s1,24(sp)
 4b8:	e84a                	sd	s2,16(sp)
 4ba:	e44e                	sd	s3,8(sp)
 4bc:	1800                	addi	s0,sp,48
 4be:	84aa                	mv	s1,a0
 4c0:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 4c2:	00450993          	addi	s3,a0,4
 4c6:	4605                	li	a2,1
 4c8:	4581                	li	a1,0
 4ca:	854e                	mv	a0,s3
 4cc:	f83ff0ef          	jal	44e <futex>
  s->value = val;
 4d0:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 4d4:	4605                	li	a2,1
 4d6:	85b2                	mv	a1,a2
 4d8:	854e                	mv	a0,s3
 4da:	f75ff0ef          	jal	44e <futex>
  return;
}
 4de:	70a2                	ld	ra,40(sp)
 4e0:	7402                	ld	s0,32(sp)
 4e2:	64e2                	ld	s1,24(sp)
 4e4:	6942                	ld	s2,16(sp)
 4e6:	69a2                	ld	s3,8(sp)
 4e8:	6145                	addi	sp,sp,48
 4ea:	8082                	ret

00000000000004ec <sem_down>:

void sem_down(sem_t* s) {
 4ec:	7179                	addi	sp,sp,-48
 4ee:	f406                	sd	ra,40(sp)
 4f0:	f022                	sd	s0,32(sp)
 4f2:	ec26                	sd	s1,24(sp)
 4f4:	e84a                	sd	s2,16(sp)
 4f6:	e44e                	sd	s3,8(sp)
 4f8:	1800                	addi	s0,sp,48
 4fa:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 4fc:	00450993          	addi	s3,a0,4
 500:	4605                	li	a2,1
 502:	4581                	li	a1,0
 504:	854e                	mv	a0,s3
 506:	f49ff0ef          	jal	44e <futex>
  while(1) {
    if (s->value>0) {
 50a:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 50e:	4485                	li	s1,1
    if (s->value>0) {
 510:	02f04463          	bgtz	a5,538 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 514:	8626                	mv	a2,s1
 516:	85a6                	mv	a1,s1
 518:	854e                	mv	a0,s3
 51a:	f35ff0ef          	jal	44e <futex>
      futex_wait(&s->value,1);
 51e:	85a6                	mv	a1,s1
 520:	854a                	mv	a0,s2
 522:	12a000ef          	jal	64c <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 526:	8626                	mv	a2,s1
 528:	4581                	li	a1,0
 52a:	854e                	mv	a0,s3
 52c:	f23ff0ef          	jal	44e <futex>
    if (s->value>0) {
 530:	00092783          	lw	a5,0(s2)
 534:	fef050e3          	blez	a5,514 <sem_down+0x28>
      s->value--;
 538:	37fd                	addiw	a5,a5,-1 # fff <digits+0x42f>
 53a:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 53e:	4605                	li	a2,1
 540:	85b2                	mv	a1,a2
 542:	854e                	mv	a0,s3
 544:	f0bff0ef          	jal	44e <futex>
  return;
}
 548:	70a2                	ld	ra,40(sp)
 54a:	7402                	ld	s0,32(sp)
 54c:	64e2                	ld	s1,24(sp)
 54e:	6942                	ld	s2,16(sp)
 550:	69a2                	ld	s3,8(sp)
 552:	6145                	addi	sp,sp,48
 554:	8082                	ret

0000000000000556 <sem_up>:

void sem_up(sem_t* s) {
 556:	1101                	addi	sp,sp,-32
 558:	ec06                	sd	ra,24(sp)
 55a:	e822                	sd	s0,16(sp)
 55c:	e426                	sd	s1,8(sp)
 55e:	e04a                	sd	s2,0(sp)
 560:	1000                	addi	s0,sp,32
 562:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 564:	00450913          	addi	s2,a0,4
 568:	4605                	li	a2,1
 56a:	4581                	li	a1,0
 56c:	854a                	mv	a0,s2
 56e:	ee1ff0ef          	jal	44e <futex>
  s->value++;
 572:	409c                	lw	a5,0(s1)
 574:	2785                	addiw	a5,a5,1
 576:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 578:	8526                	mv	a0,s1
 57a:	0da000ef          	jal	654 <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 57e:	4605                	li	a2,1
 580:	85b2                	mv	a1,a2
 582:	854a                	mv	a0,s2
 584:	ecbff0ef          	jal	44e <futex>
  return;
 588:	60e2                	ld	ra,24(sp)
 58a:	6442                	ld	s0,16(sp)
 58c:	64a2                	ld	s1,8(sp)
 58e:	6902                	ld	s2,0(sp)
 590:	6105                	addi	sp,sp,32
 592:	8082                	ret

0000000000000594 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 594:	4885                	li	a7,1
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <exit>:
.global exit
exit:
 li a7, SYS_exit
 59c:	4889                	li	a7,2
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5a4:	488d                	li	a7,3
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5ac:	4891                	li	a7,4
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <read>:
.global read
read:
 li a7, SYS_read
 5b4:	4895                	li	a7,5
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <write>:
.global write
write:
 li a7, SYS_write
 5bc:	48c1                	li	a7,16
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <close>:
.global close
close:
 li a7, SYS_close
 5c4:	48d5                	li	a7,21
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5cc:	4899                	li	a7,6
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5d4:	489d                	li	a7,7
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <open>:
.global open
open:
 li a7, SYS_open
 5dc:	48bd                	li	a7,15
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5e4:	48c5                	li	a7,17
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ec:	48c9                	li	a7,18
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5f4:	48a1                	li	a7,8
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <link>:
.global link
link:
 li a7, SYS_link
 5fc:	48cd                	li	a7,19
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 604:	48d1                	li	a7,20
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 60c:	48a5                	li	a7,9
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <dup>:
.global dup
dup:
 li a7, SYS_dup
 614:	48a9                	li	a7,10
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 61c:	48ad                	li	a7,11
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 624:	48b1                	li	a7,12
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <pause>:
.global pause
pause:
 li a7, SYS_pause
 62c:	48b5                	li	a7,13
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 634:	48b9                	li	a7,14
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <clone>:
.global clone
clone:
 li a7, SYS_clone
 63c:	48d9                	li	a7,22
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <join>:
.global join
join:
 li a7, SYS_join
 644:	48dd                	li	a7,23
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 64c:	48e1                	li	a7,24
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 654:	48e5                	li	a7,25
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 65c:	1101                	addi	sp,sp,-32
 65e:	ec06                	sd	ra,24(sp)
 660:	e822                	sd	s0,16(sp)
 662:	1000                	addi	s0,sp,32
 664:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 668:	4605                	li	a2,1
 66a:	fef40593          	addi	a1,s0,-17
 66e:	f4fff0ef          	jal	5bc <write>
}
 672:	60e2                	ld	ra,24(sp)
 674:	6442                	ld	s0,16(sp)
 676:	6105                	addi	sp,sp,32
 678:	8082                	ret

000000000000067a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 67a:	715d                	addi	sp,sp,-80
 67c:	e486                	sd	ra,72(sp)
 67e:	e0a2                	sd	s0,64(sp)
 680:	fc26                	sd	s1,56(sp)
 682:	f84a                	sd	s2,48(sp)
 684:	f44e                	sd	s3,40(sp)
 686:	0880                	addi	s0,sp,80
 688:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 68a:	c299                	beqz	a3,690 <printint+0x16>
 68c:	0605cc63          	bltz	a1,704 <printint+0x8a>
  neg = 0;
 690:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 692:	fb840313          	addi	t1,s0,-72
  neg = 0;
 696:	869a                	mv	a3,t1
  i = 0;
 698:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 69a:	00000817          	auipc	a6,0x0
 69e:	53680813          	addi	a6,a6,1334 # bd0 <digits>
 6a2:	88be                	mv	a7,a5
 6a4:	0017851b          	addiw	a0,a5,1
 6a8:	87aa                	mv	a5,a0
 6aa:	02c5f733          	remu	a4,a1,a2
 6ae:	9742                	add	a4,a4,a6
 6b0:	00074703          	lbu	a4,0(a4)
 6b4:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 6b8:	872e                	mv	a4,a1
 6ba:	02c5d5b3          	divu	a1,a1,a2
 6be:	0685                	addi	a3,a3,1
 6c0:	fec771e3          	bgeu	a4,a2,6a2 <printint+0x28>
  if(neg)
 6c4:	000e0c63          	beqz	t3,6dc <printint+0x62>
    buf[i++] = '-';
 6c8:	fd050793          	addi	a5,a0,-48
 6cc:	00878533          	add	a0,a5,s0
 6d0:	02d00793          	li	a5,45
 6d4:	fef50423          	sb	a5,-24(a0)
 6d8:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 6dc:	fff7899b          	addiw	s3,a5,-1
 6e0:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 6e4:	fff4c583          	lbu	a1,-1(s1)
 6e8:	854a                	mv	a0,s2
 6ea:	f73ff0ef          	jal	65c <putc>
  while(--i >= 0)
 6ee:	39fd                	addiw	s3,s3,-1
 6f0:	14fd                	addi	s1,s1,-1
 6f2:	fe09d9e3          	bgez	s3,6e4 <printint+0x6a>
}
 6f6:	60a6                	ld	ra,72(sp)
 6f8:	6406                	ld	s0,64(sp)
 6fa:	74e2                	ld	s1,56(sp)
 6fc:	7942                	ld	s2,48(sp)
 6fe:	79a2                	ld	s3,40(sp)
 700:	6161                	addi	sp,sp,80
 702:	8082                	ret
    x = -xx;
 704:	40b005b3          	neg	a1,a1
    neg = 1;
 708:	4e05                	li	t3,1
    x = -xx;
 70a:	b761                	j	692 <printint+0x18>

000000000000070c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 70c:	711d                	addi	sp,sp,-96
 70e:	ec86                	sd	ra,88(sp)
 710:	e8a2                	sd	s0,80(sp)
 712:	e4a6                	sd	s1,72(sp)
 714:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 716:	0005c483          	lbu	s1,0(a1)
 71a:	28048463          	beqz	s1,9a2 <vprintf+0x296>
 71e:	e0ca                	sd	s2,64(sp)
 720:	fc4e                	sd	s3,56(sp)
 722:	f852                	sd	s4,48(sp)
 724:	f456                	sd	s5,40(sp)
 726:	f05a                	sd	s6,32(sp)
 728:	ec5e                	sd	s7,24(sp)
 72a:	e862                	sd	s8,16(sp)
 72c:	e466                	sd	s9,8(sp)
 72e:	8b2a                	mv	s6,a0
 730:	8a2e                	mv	s4,a1
 732:	8bb2                	mv	s7,a2
  state = 0;
 734:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 736:	4901                	li	s2,0
 738:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 73a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 73e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 742:	06c00c93          	li	s9,108
 746:	a00d                	j	768 <vprintf+0x5c>
        putc(fd, c0);
 748:	85a6                	mv	a1,s1
 74a:	855a                	mv	a0,s6
 74c:	f11ff0ef          	jal	65c <putc>
 750:	a019                	j	756 <vprintf+0x4a>
    } else if(state == '%'){
 752:	03598363          	beq	s3,s5,778 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 756:	0019079b          	addiw	a5,s2,1
 75a:	893e                	mv	s2,a5
 75c:	873e                	mv	a4,a5
 75e:	97d2                	add	a5,a5,s4
 760:	0007c483          	lbu	s1,0(a5)
 764:	22048763          	beqz	s1,992 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 768:	0004879b          	sext.w	a5,s1
    if(state == 0){
 76c:	fe0993e3          	bnez	s3,752 <vprintf+0x46>
      if(c0 == '%'){
 770:	fd579ce3          	bne	a5,s5,748 <vprintf+0x3c>
        state = '%';
 774:	89be                	mv	s3,a5
 776:	b7c5                	j	756 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 778:	00ea06b3          	add	a3,s4,a4
 77c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 780:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 782:	c681                	beqz	a3,78a <vprintf+0x7e>
 784:	9752                	add	a4,a4,s4
 786:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 78a:	05878263          	beq	a5,s8,7ce <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 78e:	05978c63          	beq	a5,s9,7e6 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 792:	07500713          	li	a4,117
 796:	0ee78663          	beq	a5,a4,882 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 79a:	07800713          	li	a4,120
 79e:	12e78863          	beq	a5,a4,8ce <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7a2:	07000713          	li	a4,112
 7a6:	14e78d63          	beq	a5,a4,900 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 7aa:	06300713          	li	a4,99
 7ae:	18e78c63          	beq	a5,a4,946 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 7b2:	07300713          	li	a4,115
 7b6:	1ae78263          	beq	a5,a4,95a <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7ba:	02500713          	li	a4,37
 7be:	04e79463          	bne	a5,a4,806 <vprintf+0xfa>
        putc(fd, '%');
 7c2:	85ba                	mv	a1,a4
 7c4:	855a                	mv	a0,s6
 7c6:	e97ff0ef          	jal	65c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	b769                	j	756 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 7ce:	008b8493          	addi	s1,s7,8
 7d2:	4685                	li	a3,1
 7d4:	4629                	li	a2,10
 7d6:	000ba583          	lw	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	e9fff0ef          	jal	67a <printint>
 7e0:	8ba6                	mv	s7,s1
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bf8d                	j	756 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 7e6:	06400793          	li	a5,100
 7ea:	02f68963          	beq	a3,a5,81c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7ee:	06c00793          	li	a5,108
 7f2:	04f68263          	beq	a3,a5,836 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 7f6:	07500793          	li	a5,117
 7fa:	0af68063          	beq	a3,a5,89a <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 7fe:	07800793          	li	a5,120
 802:	0ef68263          	beq	a3,a5,8e6 <vprintf+0x1da>
        putc(fd, '%');
 806:	02500593          	li	a1,37
 80a:	855a                	mv	a0,s6
 80c:	e51ff0ef          	jal	65c <putc>
        putc(fd, c0);
 810:	85a6                	mv	a1,s1
 812:	855a                	mv	a0,s6
 814:	e49ff0ef          	jal	65c <putc>
      state = 0;
 818:	4981                	li	s3,0
 81a:	bf35                	j	756 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 81c:	008b8493          	addi	s1,s7,8
 820:	4685                	li	a3,1
 822:	4629                	li	a2,10
 824:	000bb583          	ld	a1,0(s7)
 828:	855a                	mv	a0,s6
 82a:	e51ff0ef          	jal	67a <printint>
        i += 1;
 82e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 830:	8ba6                	mv	s7,s1
      state = 0;
 832:	4981                	li	s3,0
        i += 1;
 834:	b70d                	j	756 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 836:	06400793          	li	a5,100
 83a:	02f60763          	beq	a2,a5,868 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 83e:	07500793          	li	a5,117
 842:	06f60963          	beq	a2,a5,8b4 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 846:	07800793          	li	a5,120
 84a:	faf61ee3          	bne	a2,a5,806 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 84e:	008b8493          	addi	s1,s7,8
 852:	4681                	li	a3,0
 854:	4641                	li	a2,16
 856:	000bb583          	ld	a1,0(s7)
 85a:	855a                	mv	a0,s6
 85c:	e1fff0ef          	jal	67a <printint>
        i += 2;
 860:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 862:	8ba6                	mv	s7,s1
      state = 0;
 864:	4981                	li	s3,0
        i += 2;
 866:	bdc5                	j	756 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 868:	008b8493          	addi	s1,s7,8
 86c:	4685                	li	a3,1
 86e:	4629                	li	a2,10
 870:	000bb583          	ld	a1,0(s7)
 874:	855a                	mv	a0,s6
 876:	e05ff0ef          	jal	67a <printint>
        i += 2;
 87a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 87c:	8ba6                	mv	s7,s1
      state = 0;
 87e:	4981                	li	s3,0
        i += 2;
 880:	bdd9                	j	756 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 882:	008b8493          	addi	s1,s7,8
 886:	4681                	li	a3,0
 888:	4629                	li	a2,10
 88a:	000be583          	lwu	a1,0(s7)
 88e:	855a                	mv	a0,s6
 890:	debff0ef          	jal	67a <printint>
 894:	8ba6                	mv	s7,s1
      state = 0;
 896:	4981                	li	s3,0
 898:	bd7d                	j	756 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 89a:	008b8493          	addi	s1,s7,8
 89e:	4681                	li	a3,0
 8a0:	4629                	li	a2,10
 8a2:	000bb583          	ld	a1,0(s7)
 8a6:	855a                	mv	a0,s6
 8a8:	dd3ff0ef          	jal	67a <printint>
        i += 1;
 8ac:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ae:	8ba6                	mv	s7,s1
      state = 0;
 8b0:	4981                	li	s3,0
        i += 1;
 8b2:	b555                	j	756 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8b4:	008b8493          	addi	s1,s7,8
 8b8:	4681                	li	a3,0
 8ba:	4629                	li	a2,10
 8bc:	000bb583          	ld	a1,0(s7)
 8c0:	855a                	mv	a0,s6
 8c2:	db9ff0ef          	jal	67a <printint>
        i += 2;
 8c6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8c8:	8ba6                	mv	s7,s1
      state = 0;
 8ca:	4981                	li	s3,0
        i += 2;
 8cc:	b569                	j	756 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 8ce:	008b8493          	addi	s1,s7,8
 8d2:	4681                	li	a3,0
 8d4:	4641                	li	a2,16
 8d6:	000be583          	lwu	a1,0(s7)
 8da:	855a                	mv	a0,s6
 8dc:	d9fff0ef          	jal	67a <printint>
 8e0:	8ba6                	mv	s7,s1
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	bd8d                	j	756 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8e6:	008b8493          	addi	s1,s7,8
 8ea:	4681                	li	a3,0
 8ec:	4641                	li	a2,16
 8ee:	000bb583          	ld	a1,0(s7)
 8f2:	855a                	mv	a0,s6
 8f4:	d87ff0ef          	jal	67a <printint>
        i += 1;
 8f8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8fa:	8ba6                	mv	s7,s1
      state = 0;
 8fc:	4981                	li	s3,0
        i += 1;
 8fe:	bda1                	j	756 <vprintf+0x4a>
 900:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 902:	008b8d13          	addi	s10,s7,8
 906:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 90a:	03000593          	li	a1,48
 90e:	855a                	mv	a0,s6
 910:	d4dff0ef          	jal	65c <putc>
  putc(fd, 'x');
 914:	07800593          	li	a1,120
 918:	855a                	mv	a0,s6
 91a:	d43ff0ef          	jal	65c <putc>
 91e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 920:	00000b97          	auipc	s7,0x0
 924:	2b0b8b93          	addi	s7,s7,688 # bd0 <digits>
 928:	03c9d793          	srli	a5,s3,0x3c
 92c:	97de                	add	a5,a5,s7
 92e:	0007c583          	lbu	a1,0(a5)
 932:	855a                	mv	a0,s6
 934:	d29ff0ef          	jal	65c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 938:	0992                	slli	s3,s3,0x4
 93a:	34fd                	addiw	s1,s1,-1
 93c:	f4f5                	bnez	s1,928 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 93e:	8bea                	mv	s7,s10
      state = 0;
 940:	4981                	li	s3,0
 942:	6d02                	ld	s10,0(sp)
 944:	bd09                	j	756 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 946:	008b8493          	addi	s1,s7,8
 94a:	000bc583          	lbu	a1,0(s7)
 94e:	855a                	mv	a0,s6
 950:	d0dff0ef          	jal	65c <putc>
 954:	8ba6                	mv	s7,s1
      state = 0;
 956:	4981                	li	s3,0
 958:	bbfd                	j	756 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 95a:	008b8993          	addi	s3,s7,8
 95e:	000bb483          	ld	s1,0(s7)
 962:	cc91                	beqz	s1,97e <vprintf+0x272>
        for(; *s; s++)
 964:	0004c583          	lbu	a1,0(s1)
 968:	c195                	beqz	a1,98c <vprintf+0x280>
          putc(fd, *s);
 96a:	855a                	mv	a0,s6
 96c:	cf1ff0ef          	jal	65c <putc>
        for(; *s; s++)
 970:	0485                	addi	s1,s1,1
 972:	0004c583          	lbu	a1,0(s1)
 976:	f9f5                	bnez	a1,96a <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 978:	8bce                	mv	s7,s3
      state = 0;
 97a:	4981                	li	s3,0
 97c:	bbe9                	j	756 <vprintf+0x4a>
          s = "(null)";
 97e:	00000497          	auipc	s1,0x0
 982:	24a48493          	addi	s1,s1,586 # bc8 <malloc+0x13a>
        for(; *s; s++)
 986:	02800593          	li	a1,40
 98a:	b7c5                	j	96a <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 98c:	8bce                	mv	s7,s3
      state = 0;
 98e:	4981                	li	s3,0
 990:	b3d9                	j	756 <vprintf+0x4a>
 992:	6906                	ld	s2,64(sp)
 994:	79e2                	ld	s3,56(sp)
 996:	7a42                	ld	s4,48(sp)
 998:	7aa2                	ld	s5,40(sp)
 99a:	7b02                	ld	s6,32(sp)
 99c:	6be2                	ld	s7,24(sp)
 99e:	6c42                	ld	s8,16(sp)
 9a0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 9a2:	60e6                	ld	ra,88(sp)
 9a4:	6446                	ld	s0,80(sp)
 9a6:	64a6                	ld	s1,72(sp)
 9a8:	6125                	addi	sp,sp,96
 9aa:	8082                	ret

00000000000009ac <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9ac:	715d                	addi	sp,sp,-80
 9ae:	ec06                	sd	ra,24(sp)
 9b0:	e822                	sd	s0,16(sp)
 9b2:	1000                	addi	s0,sp,32
 9b4:	e010                	sd	a2,0(s0)
 9b6:	e414                	sd	a3,8(s0)
 9b8:	e818                	sd	a4,16(s0)
 9ba:	ec1c                	sd	a5,24(s0)
 9bc:	03043023          	sd	a6,32(s0)
 9c0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9c4:	8622                	mv	a2,s0
 9c6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9ca:	d43ff0ef          	jal	70c <vprintf>
}
 9ce:	60e2                	ld	ra,24(sp)
 9d0:	6442                	ld	s0,16(sp)
 9d2:	6161                	addi	sp,sp,80
 9d4:	8082                	ret

00000000000009d6 <printf>:

void
printf(const char *fmt, ...)
{
 9d6:	711d                	addi	sp,sp,-96
 9d8:	ec06                	sd	ra,24(sp)
 9da:	e822                	sd	s0,16(sp)
 9dc:	1000                	addi	s0,sp,32
 9de:	e40c                	sd	a1,8(s0)
 9e0:	e810                	sd	a2,16(s0)
 9e2:	ec14                	sd	a3,24(s0)
 9e4:	f018                	sd	a4,32(s0)
 9e6:	f41c                	sd	a5,40(s0)
 9e8:	03043823          	sd	a6,48(s0)
 9ec:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9f0:	00840613          	addi	a2,s0,8
 9f4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9f8:	85aa                	mv	a1,a0
 9fa:	4505                	li	a0,1
 9fc:	d11ff0ef          	jal	70c <vprintf>
}
 a00:	60e2                	ld	ra,24(sp)
 a02:	6442                	ld	s0,16(sp)
 a04:	6125                	addi	sp,sp,96
 a06:	8082                	ret

0000000000000a08 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a08:	1141                	addi	sp,sp,-16
 a0a:	e406                	sd	ra,8(sp)
 a0c:	e022                	sd	s0,0(sp)
 a0e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a10:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a14:	00000797          	auipc	a5,0x0
 a18:	5ec7b783          	ld	a5,1516(a5) # 1000 <freep>
 a1c:	a02d                	j	a46 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a1e:	4618                	lw	a4,8(a2)
 a20:	9f2d                	addw	a4,a4,a1
 a22:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a26:	6398                	ld	a4,0(a5)
 a28:	6310                	ld	a2,0(a4)
 a2a:	a83d                	j	a68 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a2c:	ff852703          	lw	a4,-8(a0)
 a30:	9f31                	addw	a4,a4,a2
 a32:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a34:	ff053683          	ld	a3,-16(a0)
 a38:	a091                	j	a7c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a3a:	6398                	ld	a4,0(a5)
 a3c:	00e7e463          	bltu	a5,a4,a44 <free+0x3c>
 a40:	00e6ea63          	bltu	a3,a4,a54 <free+0x4c>
{
 a44:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a46:	fed7fae3          	bgeu	a5,a3,a3a <free+0x32>
 a4a:	6398                	ld	a4,0(a5)
 a4c:	00e6e463          	bltu	a3,a4,a54 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a50:	fee7eae3          	bltu	a5,a4,a44 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 a54:	ff852583          	lw	a1,-8(a0)
 a58:	6390                	ld	a2,0(a5)
 a5a:	02059813          	slli	a6,a1,0x20
 a5e:	01c85713          	srli	a4,a6,0x1c
 a62:	9736                	add	a4,a4,a3
 a64:	fae60de3          	beq	a2,a4,a1e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a68:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a6c:	4790                	lw	a2,8(a5)
 a6e:	02061593          	slli	a1,a2,0x20
 a72:	01c5d713          	srli	a4,a1,0x1c
 a76:	973e                	add	a4,a4,a5
 a78:	fae68ae3          	beq	a3,a4,a2c <free+0x24>
    p->s.ptr = bp->s.ptr;
 a7c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a7e:	00000717          	auipc	a4,0x0
 a82:	58f73123          	sd	a5,1410(a4) # 1000 <freep>
}
 a86:	60a2                	ld	ra,8(sp)
 a88:	6402                	ld	s0,0(sp)
 a8a:	0141                	addi	sp,sp,16
 a8c:	8082                	ret

0000000000000a8e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a8e:	7139                	addi	sp,sp,-64
 a90:	fc06                	sd	ra,56(sp)
 a92:	f822                	sd	s0,48(sp)
 a94:	f04a                	sd	s2,32(sp)
 a96:	ec4e                	sd	s3,24(sp)
 a98:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a9a:	02051993          	slli	s3,a0,0x20
 a9e:	0209d993          	srli	s3,s3,0x20
 aa2:	09bd                	addi	s3,s3,15
 aa4:	0049d993          	srli	s3,s3,0x4
 aa8:	2985                	addiw	s3,s3,1
 aaa:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 aac:	00000517          	auipc	a0,0x0
 ab0:	55453503          	ld	a0,1364(a0) # 1000 <freep>
 ab4:	c905                	beqz	a0,ae4 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ab8:	4798                	lw	a4,8(a5)
 aba:	09377663          	bgeu	a4,s3,b46 <malloc+0xb8>
 abe:	f426                	sd	s1,40(sp)
 ac0:	e852                	sd	s4,16(sp)
 ac2:	e456                	sd	s5,8(sp)
 ac4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 ac6:	8a4e                	mv	s4,s3
 ac8:	6705                	lui	a4,0x1
 aca:	00e9f363          	bgeu	s3,a4,ad0 <malloc+0x42>
 ace:	6a05                	lui	s4,0x1
 ad0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ad4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ad8:	00000497          	auipc	s1,0x0
 adc:	52848493          	addi	s1,s1,1320 # 1000 <freep>
  if(p == SBRK_ERROR)
 ae0:	5afd                	li	s5,-1
 ae2:	a83d                	j	b20 <malloc+0x92>
 ae4:	f426                	sd	s1,40(sp)
 ae6:	e852                	sd	s4,16(sp)
 ae8:	e456                	sd	s5,8(sp)
 aea:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 aec:	00000797          	auipc	a5,0x0
 af0:	72478793          	addi	a5,a5,1828 # 1210 <base>
 af4:	00000717          	auipc	a4,0x0
 af8:	50f73623          	sd	a5,1292(a4) # 1000 <freep>
 afc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 afe:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b02:	b7d1                	j	ac6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b04:	6398                	ld	a4,0(a5)
 b06:	e118                	sd	a4,0(a0)
 b08:	a899                	j	b5e <malloc+0xd0>
  hp->s.size = nu;
 b0a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b0e:	0541                	addi	a0,a0,16
 b10:	ef9ff0ef          	jal	a08 <free>
  return freep;
 b14:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b16:	c125                	beqz	a0,b76 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b18:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b1a:	4798                	lw	a4,8(a5)
 b1c:	03277163          	bgeu	a4,s2,b3e <malloc+0xb0>
    if(p == freep)
 b20:	6098                	ld	a4,0(s1)
 b22:	853e                	mv	a0,a5
 b24:	fef71ae3          	bne	a4,a5,b18 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b28:	8552                	mv	a0,s4
 b2a:	8c7ff0ef          	jal	3f0 <sbrk>
  if(p == SBRK_ERROR)
 b2e:	fd551ee3          	bne	a0,s5,b0a <malloc+0x7c>
        return 0;
 b32:	4501                	li	a0,0
 b34:	74a2                	ld	s1,40(sp)
 b36:	6a42                	ld	s4,16(sp)
 b38:	6aa2                	ld	s5,8(sp)
 b3a:	6b02                	ld	s6,0(sp)
 b3c:	a03d                	j	b6a <malloc+0xdc>
 b3e:	74a2                	ld	s1,40(sp)
 b40:	6a42                	ld	s4,16(sp)
 b42:	6aa2                	ld	s5,8(sp)
 b44:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b46:	fae90fe3          	beq	s2,a4,b04 <malloc+0x76>
        p->s.size -= nunits;
 b4a:	4137073b          	subw	a4,a4,s3
 b4e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b50:	02071693          	slli	a3,a4,0x20
 b54:	01c6d713          	srli	a4,a3,0x1c
 b58:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b5a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b5e:	00000717          	auipc	a4,0x0
 b62:	4aa73123          	sd	a0,1186(a4) # 1000 <freep>
      return (void*)(p + 1);
 b66:	01078513          	addi	a0,a5,16
  }
}
 b6a:	70e2                	ld	ra,56(sp)
 b6c:	7442                	ld	s0,48(sp)
 b6e:	7902                	ld	s2,32(sp)
 b70:	69e2                	ld	s3,24(sp)
 b72:	6121                	addi	sp,sp,64
 b74:	8082                	ret
 b76:	74a2                	ld	s1,40(sp)
 b78:	6a42                	ld	s4,16(sp)
 b7a:	6aa2                	ld	s5,8(sp)
 b7c:	6b02                	ld	s6,0(sp)
 b7e:	b7f5                	j	b6a <malloc+0xdc>
