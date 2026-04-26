
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	02c000ef          	jal	4a <matchhere>
  22:	e919                	bnez	a0,38 <matchstar+0x38>
  }while(*text!='\0' && (*text++==c || c=='.'));
  24:	0004c783          	lbu	a5,0(s1)
  28:	cb89                	beqz	a5,3a <matchstar+0x3a>
  2a:	0485                	addi	s1,s1,1
  2c:	2781                	sext.w	a5,a5
  2e:	ff2786e3          	beq	a5,s2,1a <matchstar+0x1a>
  32:	ff4904e3          	beq	s2,s4,1a <matchstar+0x1a>
  36:	a011                	j	3a <matchstar+0x3a>
      return 1;
  38:	4505                	li	a0,1
  return 0;
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6a02                	ld	s4,0(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret

000000000000004a <matchhere>:
  if(re[0] == '\0')
  4a:	00054703          	lbu	a4,0(a0)
  4e:	c73d                	beqz	a4,bc <matchhere+0x72>
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  58:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5a:	00154683          	lbu	a3,1(a0)
  5e:	02a00613          	li	a2,42
  62:	02c68563          	beq	a3,a2,8c <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  66:	02400613          	li	a2,36
  6a:	02c70863          	beq	a4,a2,9a <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6e:	0005c683          	lbu	a3,0(a1)
  return 0;
  72:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  74:	ca81                	beqz	a3,84 <matchhere+0x3a>
  76:	02e00613          	li	a2,46
  7a:	02c70b63          	beq	a4,a2,b0 <matchhere+0x66>
  return 0;
  7e:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  80:	02d70863          	beq	a4,a3,b0 <matchhere+0x66>
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret
    return matchstar(re[0], re+2, text);
  8c:	862e                	mv	a2,a1
  8e:	00250593          	addi	a1,a0,2
  92:	853a                	mv	a0,a4
  94:	f6dff0ef          	jal	0 <matchstar>
  98:	b7f5                	j	84 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  9a:	c691                	beqz	a3,a6 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  9c:	0005c683          	lbu	a3,0(a1)
  a0:	fef9                	bnez	a3,7e <matchhere+0x34>
  return 0;
  a2:	4501                	li	a0,0
  a4:	b7c5                	j	84 <matchhere+0x3a>
    return *text == '\0';
  a6:	0005c503          	lbu	a0,0(a1)
  aa:	00153513          	seqz	a0,a0
  ae:	bfd9                	j	84 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b0:	0585                	addi	a1,a1,1
  b2:	00178513          	addi	a0,a5,1
  b6:	f95ff0ef          	jal	4a <matchhere>
  ba:	b7e9                	j	84 <matchhere+0x3a>
    return 1;
  bc:	4505                	li	a0,1
}
  be:	8082                	ret

00000000000000c0 <match>:
{
  c0:	1101                	addi	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	e04a                	sd	s2,0(sp)
  ca:	1000                	addi	s0,sp,32
  cc:	892a                	mv	s2,a0
  ce:	84ae                	mv	s1,a1
  if(re[0] == '^')
  d0:	00054703          	lbu	a4,0(a0)
  d4:	05e00793          	li	a5,94
  d8:	00f70c63          	beq	a4,a5,f0 <match+0x30>
    if(matchhere(re, text))
  dc:	85a6                	mv	a1,s1
  de:	854a                	mv	a0,s2
  e0:	f6bff0ef          	jal	4a <matchhere>
  e4:	e911                	bnez	a0,f8 <match+0x38>
  }while(*text++ != '\0');
  e6:	0485                	addi	s1,s1,1
  e8:	fff4c783          	lbu	a5,-1(s1)
  ec:	fbe5                	bnez	a5,dc <match+0x1c>
  ee:	a031                	j	fa <match+0x3a>
    return matchhere(re+1, text);
  f0:	0505                	addi	a0,a0,1
  f2:	f59ff0ef          	jal	4a <matchhere>
  f6:	a011                	j	fa <match+0x3a>
      return 1;
  f8:	4505                	li	a0,1
}
  fa:	60e2                	ld	ra,24(sp)
  fc:	6442                	ld	s0,16(sp)
  fe:	64a2                	ld	s1,8(sp)
 100:	6902                	ld	s2,0(sp)
 102:	6105                	addi	sp,sp,32
 104:	8082                	ret

0000000000000106 <grep>:
{
 106:	711d                	addi	sp,sp,-96
 108:	ec86                	sd	ra,88(sp)
 10a:	e8a2                	sd	s0,80(sp)
 10c:	e4a6                	sd	s1,72(sp)
 10e:	e0ca                	sd	s2,64(sp)
 110:	fc4e                	sd	s3,56(sp)
 112:	f852                	sd	s4,48(sp)
 114:	f456                	sd	s5,40(sp)
 116:	f05a                	sd	s6,32(sp)
 118:	ec5e                	sd	s7,24(sp)
 11a:	e862                	sd	s8,16(sp)
 11c:	e466                	sd	s9,8(sp)
 11e:	e06a                	sd	s10,0(sp)
 120:	1080                	addi	s0,sp,96
 122:	8aaa                	mv	s5,a0
 124:	8cae                	mv	s9,a1
  m = 0;
 126:	4b01                	li	s6,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 128:	3ff00d13          	li	s10,1023
 12c:	00001b97          	auipc	s7,0x1
 130:	ee4b8b93          	addi	s7,s7,-284 # 1010 <buf>
    while((q = strchr(p, '\n')) != 0){
 134:	49a9                	li	s3,10
        write(1, p, q+1 - p);
 136:	4c05                	li	s8,1
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 138:	a82d                	j	172 <grep+0x6c>
      p = q+1;
 13a:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 13e:	85ce                	mv	a1,s3
 140:	854a                	mv	a0,s2
 142:	1d4000ef          	jal	316 <strchr>
 146:	84aa                	mv	s1,a0
 148:	c11d                	beqz	a0,16e <grep+0x68>
      *q = 0;
 14a:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 14e:	85ca                	mv	a1,s2
 150:	8556                	mv	a0,s5
 152:	f6fff0ef          	jal	c0 <match>
 156:	d175                	beqz	a0,13a <grep+0x34>
        *q = '\n';
 158:	01348023          	sb	s3,0(s1)
        write(1, p, q+1 - p);
 15c:	00148613          	addi	a2,s1,1
 160:	4126063b          	subw	a2,a2,s2
 164:	85ca                	mv	a1,s2
 166:	8562                	mv	a0,s8
 168:	55a000ef          	jal	6c2 <write>
 16c:	b7f9                	j	13a <grep+0x34>
    if(m > 0){
 16e:	03604463          	bgtz	s6,196 <grep+0x90>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 172:	416d063b          	subw	a2,s10,s6
 176:	016b85b3          	add	a1,s7,s6
 17a:	8566                	mv	a0,s9
 17c:	53e000ef          	jal	6ba <read>
 180:	02a05863          	blez	a0,1b0 <grep+0xaa>
    m += n;
 184:	00ab0a3b          	addw	s4,s6,a0
 188:	8b52                	mv	s6,s4
    buf[m] = '\0';
 18a:	014b87b3          	add	a5,s7,s4
 18e:	00078023          	sb	zero,0(a5)
    p = buf;
 192:	895e                	mv	s2,s7
    while((q = strchr(p, '\n')) != 0){
 194:	b76d                	j	13e <grep+0x38>
      m -= p - buf;
 196:	00001517          	auipc	a0,0x1
 19a:	e7a50513          	addi	a0,a0,-390 # 1010 <buf>
 19e:	40a907b3          	sub	a5,s2,a0
 1a2:	40fa063b          	subw	a2,s4,a5
 1a6:	8b32                	mv	s6,a2
      memmove(buf, p, m);
 1a8:	85ca                	mv	a1,s2
 1aa:	29e000ef          	jal	448 <memmove>
 1ae:	b7d1                	j	172 <grep+0x6c>
}
 1b0:	60e6                	ld	ra,88(sp)
 1b2:	6446                	ld	s0,80(sp)
 1b4:	64a6                	ld	s1,72(sp)
 1b6:	6906                	ld	s2,64(sp)
 1b8:	79e2                	ld	s3,56(sp)
 1ba:	7a42                	ld	s4,48(sp)
 1bc:	7aa2                	ld	s5,40(sp)
 1be:	7b02                	ld	s6,32(sp)
 1c0:	6be2                	ld	s7,24(sp)
 1c2:	6c42                	ld	s8,16(sp)
 1c4:	6ca2                	ld	s9,8(sp)
 1c6:	6d02                	ld	s10,0(sp)
 1c8:	6125                	addi	sp,sp,96
 1ca:	8082                	ret

00000000000001cc <main>:
{
 1cc:	7179                	addi	sp,sp,-48
 1ce:	f406                	sd	ra,40(sp)
 1d0:	f022                	sd	s0,32(sp)
 1d2:	ec26                	sd	s1,24(sp)
 1d4:	e84a                	sd	s2,16(sp)
 1d6:	e44e                	sd	s3,8(sp)
 1d8:	e052                	sd	s4,0(sp)
 1da:	1800                	addi	s0,sp,48
  if(argc <= 1){
 1dc:	4785                	li	a5,1
 1de:	04a7d663          	bge	a5,a0,22a <main+0x5e>
  pattern = argv[1];
 1e2:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1e6:	4789                	li	a5,2
 1e8:	04a7db63          	bge	a5,a0,23e <main+0x72>
 1ec:	01058913          	addi	s2,a1,16
 1f0:	ffd5099b          	addiw	s3,a0,-3
 1f4:	02099793          	slli	a5,s3,0x20
 1f8:	01d7d993          	srli	s3,a5,0x1d
 1fc:	05e1                	addi	a1,a1,24
 1fe:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 200:	4581                	li	a1,0
 202:	00093503          	ld	a0,0(s2)
 206:	4dc000ef          	jal	6e2 <open>
 20a:	84aa                	mv	s1,a0
 20c:	04054063          	bltz	a0,24c <main+0x80>
    grep(pattern, fd);
 210:	85aa                	mv	a1,a0
 212:	8552                	mv	a0,s4
 214:	ef3ff0ef          	jal	106 <grep>
    close(fd);
 218:	8526                	mv	a0,s1
 21a:	4b0000ef          	jal	6ca <close>
  for(i = 2; i < argc; i++){
 21e:	0921                	addi	s2,s2,8
 220:	ff3910e3          	bne	s2,s3,200 <main+0x34>
  exit(0);
 224:	4501                	li	a0,0
 226:	47c000ef          	jal	6a2 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 22a:	00001597          	auipc	a1,0x1
 22e:	a6658593          	addi	a1,a1,-1434 # c90 <malloc+0xfc>
 232:	4509                	li	a0,2
 234:	07f000ef          	jal	ab2 <fprintf>
    exit(1);
 238:	4505                	li	a0,1
 23a:	468000ef          	jal	6a2 <exit>
    grep(pattern, 0);
 23e:	4581                	li	a1,0
 240:	8552                	mv	a0,s4
 242:	ec5ff0ef          	jal	106 <grep>
    exit(0);
 246:	4501                	li	a0,0
 248:	45a000ef          	jal	6a2 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 24c:	00093583          	ld	a1,0(s2)
 250:	00001517          	auipc	a0,0x1
 254:	a6050513          	addi	a0,a0,-1440 # cb0 <malloc+0x11c>
 258:	085000ef          	jal	adc <printf>
      exit(1);
 25c:	4505                	li	a0,1
 25e:	444000ef          	jal	6a2 <exit>

0000000000000262 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 262:	1141                	addi	sp,sp,-16
 264:	e406                	sd	ra,8(sp)
 266:	e022                	sd	s0,0(sp)
 268:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 26a:	f63ff0ef          	jal	1cc <main>
  exit(r);
 26e:	434000ef          	jal	6a2 <exit>

0000000000000272 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 272:	1141                	addi	sp,sp,-16
 274:	e406                	sd	ra,8(sp)
 276:	e022                	sd	s0,0(sp)
 278:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 27a:	87aa                	mv	a5,a0
 27c:	0585                	addi	a1,a1,1
 27e:	0785                	addi	a5,a5,1
 280:	fff5c703          	lbu	a4,-1(a1)
 284:	fee78fa3          	sb	a4,-1(a5)
 288:	fb75                	bnez	a4,27c <strcpy+0xa>
    ;
  return os;
}
 28a:	60a2                	ld	ra,8(sp)
 28c:	6402                	ld	s0,0(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 29a:	00054783          	lbu	a5,0(a0)
 29e:	cb91                	beqz	a5,2b2 <strcmp+0x20>
 2a0:	0005c703          	lbu	a4,0(a1)
 2a4:	00f71763          	bne	a4,a5,2b2 <strcmp+0x20>
    p++, q++;
 2a8:	0505                	addi	a0,a0,1
 2aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	fbe5                	bnez	a5,2a0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2b2:	0005c503          	lbu	a0,0(a1)
}
 2b6:	40a7853b          	subw	a0,a5,a0
 2ba:	60a2                	ld	ra,8(sp)
 2bc:	6402                	ld	s0,0(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <strlen>:

uint
strlen(const char *s)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e406                	sd	ra,8(sp)
 2c6:	e022                	sd	s0,0(sp)
 2c8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	cf99                	beqz	a5,2ec <strlen+0x2a>
 2d0:	0505                	addi	a0,a0,1
 2d2:	87aa                	mv	a5,a0
 2d4:	86be                	mv	a3,a5
 2d6:	0785                	addi	a5,a5,1
 2d8:	fff7c703          	lbu	a4,-1(a5)
 2dc:	ff65                	bnez	a4,2d4 <strlen+0x12>
 2de:	40a6853b          	subw	a0,a3,a0
 2e2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
  for(n = 0; s[n]; n++)
 2ec:	4501                	li	a0,0
 2ee:	bfdd                	j	2e4 <strlen+0x22>

00000000000002f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e406                	sd	ra,8(sp)
 2f4:	e022                	sd	s0,0(sp)
 2f6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f8:	ca19                	beqz	a2,30e <memset+0x1e>
 2fa:	87aa                	mv	a5,a0
 2fc:	1602                	slli	a2,a2,0x20
 2fe:	9201                	srli	a2,a2,0x20
 300:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 304:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 308:	0785                	addi	a5,a5,1
 30a:	fee79de3          	bne	a5,a4,304 <memset+0x14>
  }
  return dst;
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret

0000000000000316 <strchr>:

char*
strchr(const char *s, char c)
{
 316:	1141                	addi	sp,sp,-16
 318:	e406                	sd	ra,8(sp)
 31a:	e022                	sd	s0,0(sp)
 31c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 31e:	00054783          	lbu	a5,0(a0)
 322:	cf81                	beqz	a5,33a <strchr+0x24>
    if(*s == c)
 324:	00f58763          	beq	a1,a5,332 <strchr+0x1c>
  for(; *s; s++)
 328:	0505                	addi	a0,a0,1
 32a:	00054783          	lbu	a5,0(a0)
 32e:	fbfd                	bnez	a5,324 <strchr+0xe>
      return (char*)s;
  return 0;
 330:	4501                	li	a0,0
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret
  return 0;
 33a:	4501                	li	a0,0
 33c:	bfdd                	j	332 <strchr+0x1c>

000000000000033e <gets>:

char*
gets(char *buf, int max)
{
 33e:	7159                	addi	sp,sp,-112
 340:	f486                	sd	ra,104(sp)
 342:	f0a2                	sd	s0,96(sp)
 344:	eca6                	sd	s1,88(sp)
 346:	e8ca                	sd	s2,80(sp)
 348:	e4ce                	sd	s3,72(sp)
 34a:	e0d2                	sd	s4,64(sp)
 34c:	fc56                	sd	s5,56(sp)
 34e:	f85a                	sd	s6,48(sp)
 350:	f45e                	sd	s7,40(sp)
 352:	f062                	sd	s8,32(sp)
 354:	ec66                	sd	s9,24(sp)
 356:	e86a                	sd	s10,16(sp)
 358:	1880                	addi	s0,sp,112
 35a:	8caa                	mv	s9,a0
 35c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 35e:	892a                	mv	s2,a0
 360:	4481                	li	s1,0
    cc = read(0, &c, 1);
 362:	f9f40b13          	addi	s6,s0,-97
 366:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 368:	4ba9                	li	s7,10
 36a:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 36c:	8d26                	mv	s10,s1
 36e:	0014899b          	addiw	s3,s1,1
 372:	84ce                	mv	s1,s3
 374:	0349d563          	bge	s3,s4,39e <gets+0x60>
    cc = read(0, &c, 1);
 378:	8656                	mv	a2,s5
 37a:	85da                	mv	a1,s6
 37c:	4501                	li	a0,0
 37e:	33c000ef          	jal	6ba <read>
    if(cc < 1)
 382:	00a05e63          	blez	a0,39e <gets+0x60>
    buf[i++] = c;
 386:	f9f44783          	lbu	a5,-97(s0)
 38a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 38e:	01778763          	beq	a5,s7,39c <gets+0x5e>
 392:	0905                	addi	s2,s2,1
 394:	fd879ce3          	bne	a5,s8,36c <gets+0x2e>
    buf[i++] = c;
 398:	8d4e                	mv	s10,s3
 39a:	a011                	j	39e <gets+0x60>
 39c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 39e:	9d66                	add	s10,s10,s9
 3a0:	000d0023          	sb	zero,0(s10)
  return buf;
}
 3a4:	8566                	mv	a0,s9
 3a6:	70a6                	ld	ra,104(sp)
 3a8:	7406                	ld	s0,96(sp)
 3aa:	64e6                	ld	s1,88(sp)
 3ac:	6946                	ld	s2,80(sp)
 3ae:	69a6                	ld	s3,72(sp)
 3b0:	6a06                	ld	s4,64(sp)
 3b2:	7ae2                	ld	s5,56(sp)
 3b4:	7b42                	ld	s6,48(sp)
 3b6:	7ba2                	ld	s7,40(sp)
 3b8:	7c02                	ld	s8,32(sp)
 3ba:	6ce2                	ld	s9,24(sp)
 3bc:	6d42                	ld	s10,16(sp)
 3be:	6165                	addi	sp,sp,112
 3c0:	8082                	ret

00000000000003c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3c2:	1101                	addi	sp,sp,-32
 3c4:	ec06                	sd	ra,24(sp)
 3c6:	e822                	sd	s0,16(sp)
 3c8:	e04a                	sd	s2,0(sp)
 3ca:	1000                	addi	s0,sp,32
 3cc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ce:	4581                	li	a1,0
 3d0:	312000ef          	jal	6e2 <open>
  if(fd < 0)
 3d4:	02054263          	bltz	a0,3f8 <stat+0x36>
 3d8:	e426                	sd	s1,8(sp)
 3da:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3dc:	85ca                	mv	a1,s2
 3de:	31c000ef          	jal	6fa <fstat>
 3e2:	892a                	mv	s2,a0
  close(fd);
 3e4:	8526                	mv	a0,s1
 3e6:	2e4000ef          	jal	6ca <close>
  return r;
 3ea:	64a2                	ld	s1,8(sp)
}
 3ec:	854a                	mv	a0,s2
 3ee:	60e2                	ld	ra,24(sp)
 3f0:	6442                	ld	s0,16(sp)
 3f2:	6902                	ld	s2,0(sp)
 3f4:	6105                	addi	sp,sp,32
 3f6:	8082                	ret
    return -1;
 3f8:	597d                	li	s2,-1
 3fa:	bfcd                	j	3ec <stat+0x2a>

00000000000003fc <atoi>:

int
atoi(const char *s)
{
 3fc:	1141                	addi	sp,sp,-16
 3fe:	e406                	sd	ra,8(sp)
 400:	e022                	sd	s0,0(sp)
 402:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 404:	00054683          	lbu	a3,0(a0)
 408:	fd06879b          	addiw	a5,a3,-48
 40c:	0ff7f793          	zext.b	a5,a5
 410:	4625                	li	a2,9
 412:	02f66963          	bltu	a2,a5,444 <atoi+0x48>
 416:	872a                	mv	a4,a0
  n = 0;
 418:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 41a:	0705                	addi	a4,a4,1
 41c:	0025179b          	slliw	a5,a0,0x2
 420:	9fa9                	addw	a5,a5,a0
 422:	0017979b          	slliw	a5,a5,0x1
 426:	9fb5                	addw	a5,a5,a3
 428:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 42c:	00074683          	lbu	a3,0(a4)
 430:	fd06879b          	addiw	a5,a3,-48
 434:	0ff7f793          	zext.b	a5,a5
 438:	fef671e3          	bgeu	a2,a5,41a <atoi+0x1e>
  return n;
}
 43c:	60a2                	ld	ra,8(sp)
 43e:	6402                	ld	s0,0(sp)
 440:	0141                	addi	sp,sp,16
 442:	8082                	ret
  n = 0;
 444:	4501                	li	a0,0
 446:	bfdd                	j	43c <atoi+0x40>

0000000000000448 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 448:	1141                	addi	sp,sp,-16
 44a:	e406                	sd	ra,8(sp)
 44c:	e022                	sd	s0,0(sp)
 44e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 450:	02b57563          	bgeu	a0,a1,47a <memmove+0x32>
    while(n-- > 0)
 454:	00c05f63          	blez	a2,472 <memmove+0x2a>
 458:	1602                	slli	a2,a2,0x20
 45a:	9201                	srli	a2,a2,0x20
 45c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 460:	872a                	mv	a4,a0
      *dst++ = *src++;
 462:	0585                	addi	a1,a1,1
 464:	0705                	addi	a4,a4,1
 466:	fff5c683          	lbu	a3,-1(a1)
 46a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 46e:	fee79ae3          	bne	a5,a4,462 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 472:	60a2                	ld	ra,8(sp)
 474:	6402                	ld	s0,0(sp)
 476:	0141                	addi	sp,sp,16
 478:	8082                	ret
    dst += n;
 47a:	00c50733          	add	a4,a0,a2
    src += n;
 47e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 480:	fec059e3          	blez	a2,472 <memmove+0x2a>
 484:	fff6079b          	addiw	a5,a2,-1
 488:	1782                	slli	a5,a5,0x20
 48a:	9381                	srli	a5,a5,0x20
 48c:	fff7c793          	not	a5,a5
 490:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 492:	15fd                	addi	a1,a1,-1
 494:	177d                	addi	a4,a4,-1
 496:	0005c683          	lbu	a3,0(a1)
 49a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 49e:	fef71ae3          	bne	a4,a5,492 <memmove+0x4a>
 4a2:	bfc1                	j	472 <memmove+0x2a>

00000000000004a4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4a4:	1141                	addi	sp,sp,-16
 4a6:	e406                	sd	ra,8(sp)
 4a8:	e022                	sd	s0,0(sp)
 4aa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ac:	ca0d                	beqz	a2,4de <memcmp+0x3a>
 4ae:	fff6069b          	addiw	a3,a2,-1
 4b2:	1682                	slli	a3,a3,0x20
 4b4:	9281                	srli	a3,a3,0x20
 4b6:	0685                	addi	a3,a3,1
 4b8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4ba:	00054783          	lbu	a5,0(a0)
 4be:	0005c703          	lbu	a4,0(a1)
 4c2:	00e79863          	bne	a5,a4,4d2 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 4c6:	0505                	addi	a0,a0,1
    p2++;
 4c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4ca:	fed518e3          	bne	a0,a3,4ba <memcmp+0x16>
  }
  return 0;
 4ce:	4501                	li	a0,0
 4d0:	a019                	j	4d6 <memcmp+0x32>
      return *p1 - *p2;
 4d2:	40e7853b          	subw	a0,a5,a4
}
 4d6:	60a2                	ld	ra,8(sp)
 4d8:	6402                	ld	s0,0(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret
  return 0;
 4de:	4501                	li	a0,0
 4e0:	bfdd                	j	4d6 <memcmp+0x32>

00000000000004e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4e2:	1141                	addi	sp,sp,-16
 4e4:	e406                	sd	ra,8(sp)
 4e6:	e022                	sd	s0,0(sp)
 4e8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4ea:	f5fff0ef          	jal	448 <memmove>
}
 4ee:	60a2                	ld	ra,8(sp)
 4f0:	6402                	ld	s0,0(sp)
 4f2:	0141                	addi	sp,sp,16
 4f4:	8082                	ret

00000000000004f6 <sbrk>:

char *
sbrk(int n) {
 4f6:	1141                	addi	sp,sp,-16
 4f8:	e406                	sd	ra,8(sp)
 4fa:	e022                	sd	s0,0(sp)
 4fc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4fe:	4585                	li	a1,1
 500:	22a000ef          	jal	72a <sys_sbrk>
}
 504:	60a2                	ld	ra,8(sp)
 506:	6402                	ld	s0,0(sp)
 508:	0141                	addi	sp,sp,16
 50a:	8082                	ret

000000000000050c <sbrklazy>:

char *
sbrklazy(int n) {
 50c:	1141                	addi	sp,sp,-16
 50e:	e406                	sd	ra,8(sp)
 510:	e022                	sd	s0,0(sp)
 512:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 514:	4589                	li	a1,2
 516:	214000ef          	jal	72a <sys_sbrk>
}
 51a:	60a2                	ld	ra,8(sp)
 51c:	6402                	ld	s0,0(sp)
 51e:	0141                	addi	sp,sp,16
 520:	8082                	ret

0000000000000522 <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 522:	1101                	addi	sp,sp,-32
 524:	ec06                	sd	ra,24(sp)
 526:	e822                	sd	s0,16(sp)
 528:	e426                	sd	s1,8(sp)
 52a:	e04a                	sd	s2,0(sp)
 52c:	1000                	addi	s0,sp,32
 52e:	84aa                	mv	s1,a0
 530:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 532:	6505                	lui	a0,0x1
 534:	fc3ff0ef          	jal	4f6 <sbrk>
 538:	6785                	lui	a5,0x1
 53a:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 53e:	9a41                	andi	a2,a2,-16
 540:	85ca                	mv	a1,s2
 542:	8526                	mv	a0,s1
 544:	1fe000ef          	jal	742 <clone>
}
 548:	60e2                	ld	ra,24(sp)
 54a:	6442                	ld	s0,16(sp)
 54c:	64a2                	ld	s1,8(sp)
 54e:	6902                	ld	s2,0(sp)
 550:	6105                	addi	sp,sp,32
 552:	8082                	ret

0000000000000554 <futex>:

void futex(int *uaddr, int ops, int val) {
 554:	7179                	addi	sp,sp,-48
 556:	f406                	sd	ra,40(sp)
 558:	f022                	sd	s0,32(sp)
 55a:	ec26                	sd	s1,24(sp)
 55c:	1800                	addi	s0,sp,48
 55e:	84aa                	mv	s1,a0
  if (ops==0) {
 560:	ed95                	bnez	a1,59c <futex+0x48>
    if (val==0) {
 562:	c611                	beqz	a2,56e <futex+0x1a>
 564:	e84a                	sd	s2,16(sp)
 566:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 568:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 56a:	4985                	li	s3,1
 56c:	a005                	j	58c <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 56e:	4705                	li	a4,1
 570:	87ba                	mv	a5,a4
 572:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 576:	2781                	sext.w	a5,a5
 578:	ffe5                	bnez	a5,570 <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 57a:	70a2                	ld	ra,40(sp)
 57c:	7402                	ld	s0,32(sp)
 57e:	64e2                	ld	s1,24(sp)
 580:	6145                	addi	sp,sp,48
 582:	8082                	ret
        futex_wait(uaddr, 1);
 584:	85ce                	mv	a1,s3
 586:	8526                	mv	a0,s1
 588:	1ca000ef          	jal	752 <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 58c:	87ca                	mv	a5,s2
 58e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 592:	2781                	sext.w	a5,a5
 594:	fbe5                	bnez	a5,584 <futex+0x30>
 596:	6942                	ld	s2,16(sp)
 598:	69a2                	ld	s3,8(sp)
 59a:	b7c5                	j	57a <futex+0x26>
    if (val==0) {
 59c:	e611                	bnez	a2,5a8 <futex+0x54>
      __sync_lock_release(uaddr);
 59e:	0310000f          	fence	rw,w
 5a2:	00052023          	sw	zero,0(a0) # 1000 <freep>
 5a6:	bfd1                	j	57a <futex+0x26>
      __sync_lock_release(uaddr);
 5a8:	0310000f          	fence	rw,w
 5ac:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 5b0:	1aa000ef          	jal	75a <futex_wake>
  return;
 5b4:	b7d9                	j	57a <futex+0x26>

00000000000005b6 <sem_init>:

void sem_init(sem_t* s, int val) {
 5b6:	7179                	addi	sp,sp,-48
 5b8:	f406                	sd	ra,40(sp)
 5ba:	f022                	sd	s0,32(sp)
 5bc:	ec26                	sd	s1,24(sp)
 5be:	e84a                	sd	s2,16(sp)
 5c0:	e44e                	sd	s3,8(sp)
 5c2:	1800                	addi	s0,sp,48
 5c4:	84aa                	mv	s1,a0
 5c6:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 5c8:	00450993          	addi	s3,a0,4
 5cc:	4605                	li	a2,1
 5ce:	4581                	li	a1,0
 5d0:	854e                	mv	a0,s3
 5d2:	f83ff0ef          	jal	554 <futex>
  s->value = val;
 5d6:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 5da:	4605                	li	a2,1
 5dc:	85b2                	mv	a1,a2
 5de:	854e                	mv	a0,s3
 5e0:	f75ff0ef          	jal	554 <futex>
  return;
}
 5e4:	70a2                	ld	ra,40(sp)
 5e6:	7402                	ld	s0,32(sp)
 5e8:	64e2                	ld	s1,24(sp)
 5ea:	6942                	ld	s2,16(sp)
 5ec:	69a2                	ld	s3,8(sp)
 5ee:	6145                	addi	sp,sp,48
 5f0:	8082                	ret

00000000000005f2 <sem_down>:

void sem_down(sem_t* s) {
 5f2:	7179                	addi	sp,sp,-48
 5f4:	f406                	sd	ra,40(sp)
 5f6:	f022                	sd	s0,32(sp)
 5f8:	ec26                	sd	s1,24(sp)
 5fa:	e84a                	sd	s2,16(sp)
 5fc:	e44e                	sd	s3,8(sp)
 5fe:	1800                	addi	s0,sp,48
 600:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 602:	00450993          	addi	s3,a0,4
 606:	4605                	li	a2,1
 608:	4581                	li	a1,0
 60a:	854e                	mv	a0,s3
 60c:	f49ff0ef          	jal	554 <futex>
  while(1) {
    if (s->value>0) {
 610:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 614:	4485                	li	s1,1
    if (s->value>0) {
 616:	02f04463          	bgtz	a5,63e <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 61a:	8626                	mv	a2,s1
 61c:	85a6                	mv	a1,s1
 61e:	854e                	mv	a0,s3
 620:	f35ff0ef          	jal	554 <futex>
      futex_wait(&s->value,1);
 624:	85a6                	mv	a1,s1
 626:	854a                	mv	a0,s2
 628:	12a000ef          	jal	752 <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 62c:	8626                	mv	a2,s1
 62e:	4581                	li	a1,0
 630:	854e                	mv	a0,s3
 632:	f23ff0ef          	jal	554 <futex>
    if (s->value>0) {
 636:	00092783          	lw	a5,0(s2)
 63a:	fef050e3          	blez	a5,61a <sem_down+0x28>
      s->value--;
 63e:	37fd                	addiw	a5,a5,-1 # fff <digits+0x32f>
 640:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 644:	4605                	li	a2,1
 646:	85b2                	mv	a1,a2
 648:	854e                	mv	a0,s3
 64a:	f0bff0ef          	jal	554 <futex>
  return;
}
 64e:	70a2                	ld	ra,40(sp)
 650:	7402                	ld	s0,32(sp)
 652:	64e2                	ld	s1,24(sp)
 654:	6942                	ld	s2,16(sp)
 656:	69a2                	ld	s3,8(sp)
 658:	6145                	addi	sp,sp,48
 65a:	8082                	ret

000000000000065c <sem_up>:

void sem_up(sem_t* s) {
 65c:	1101                	addi	sp,sp,-32
 65e:	ec06                	sd	ra,24(sp)
 660:	e822                	sd	s0,16(sp)
 662:	e426                	sd	s1,8(sp)
 664:	e04a                	sd	s2,0(sp)
 666:	1000                	addi	s0,sp,32
 668:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 66a:	00450913          	addi	s2,a0,4
 66e:	4605                	li	a2,1
 670:	4581                	li	a1,0
 672:	854a                	mv	a0,s2
 674:	ee1ff0ef          	jal	554 <futex>
  s->value++;
 678:	409c                	lw	a5,0(s1)
 67a:	2785                	addiw	a5,a5,1
 67c:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 67e:	8526                	mv	a0,s1
 680:	0da000ef          	jal	75a <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 684:	4605                	li	a2,1
 686:	85b2                	mv	a1,a2
 688:	854a                	mv	a0,s2
 68a:	ecbff0ef          	jal	554 <futex>
  return;
 68e:	60e2                	ld	ra,24(sp)
 690:	6442                	ld	s0,16(sp)
 692:	64a2                	ld	s1,8(sp)
 694:	6902                	ld	s2,0(sp)
 696:	6105                	addi	sp,sp,32
 698:	8082                	ret

000000000000069a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 69a:	4885                	li	a7,1
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6a2:	4889                	li	a7,2
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <wait>:
.global wait
wait:
 li a7, SYS_wait
 6aa:	488d                	li	a7,3
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6b2:	4891                	li	a7,4
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <read>:
.global read
read:
 li a7, SYS_read
 6ba:	4895                	li	a7,5
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <write>:
.global write
write:
 li a7, SYS_write
 6c2:	48c1                	li	a7,16
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <close>:
.global close
close:
 li a7, SYS_close
 6ca:	48d5                	li	a7,21
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 6d2:	4899                	li	a7,6
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <exec>:
.global exec
exec:
 li a7, SYS_exec
 6da:	489d                	li	a7,7
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <open>:
.global open
open:
 li a7, SYS_open
 6e2:	48bd                	li	a7,15
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6ea:	48c5                	li	a7,17
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6f2:	48c9                	li	a7,18
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6fa:	48a1                	li	a7,8
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <link>:
.global link
link:
 li a7, SYS_link
 702:	48cd                	li	a7,19
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 70a:	48d1                	li	a7,20
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 712:	48a5                	li	a7,9
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <dup>:
.global dup
dup:
 li a7, SYS_dup
 71a:	48a9                	li	a7,10
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 722:	48ad                	li	a7,11
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 72a:	48b1                	li	a7,12
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <pause>:
.global pause
pause:
 li a7, SYS_pause
 732:	48b5                	li	a7,13
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 73a:	48b9                	li	a7,14
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <clone>:
.global clone
clone:
 li a7, SYS_clone
 742:	48d9                	li	a7,22
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <join>:
.global join
join:
 li a7, SYS_join
 74a:	48dd                	li	a7,23
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 752:	48e1                	li	a7,24
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 75a:	48e5                	li	a7,25
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 762:	1101                	addi	sp,sp,-32
 764:	ec06                	sd	ra,24(sp)
 766:	e822                	sd	s0,16(sp)
 768:	1000                	addi	s0,sp,32
 76a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 76e:	4605                	li	a2,1
 770:	fef40593          	addi	a1,s0,-17
 774:	f4fff0ef          	jal	6c2 <write>
}
 778:	60e2                	ld	ra,24(sp)
 77a:	6442                	ld	s0,16(sp)
 77c:	6105                	addi	sp,sp,32
 77e:	8082                	ret

0000000000000780 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 780:	715d                	addi	sp,sp,-80
 782:	e486                	sd	ra,72(sp)
 784:	e0a2                	sd	s0,64(sp)
 786:	fc26                	sd	s1,56(sp)
 788:	f84a                	sd	s2,48(sp)
 78a:	f44e                	sd	s3,40(sp)
 78c:	0880                	addi	s0,sp,80
 78e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 790:	c299                	beqz	a3,796 <printint+0x16>
 792:	0605cc63          	bltz	a1,80a <printint+0x8a>
  neg = 0;
 796:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 798:	fb840313          	addi	t1,s0,-72
  neg = 0;
 79c:	869a                	mv	a3,t1
  i = 0;
 79e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 7a0:	00000817          	auipc	a6,0x0
 7a4:	53080813          	addi	a6,a6,1328 # cd0 <digits>
 7a8:	88be                	mv	a7,a5
 7aa:	0017851b          	addiw	a0,a5,1
 7ae:	87aa                	mv	a5,a0
 7b0:	02c5f733          	remu	a4,a1,a2
 7b4:	9742                	add	a4,a4,a6
 7b6:	00074703          	lbu	a4,0(a4)
 7ba:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 7be:	872e                	mv	a4,a1
 7c0:	02c5d5b3          	divu	a1,a1,a2
 7c4:	0685                	addi	a3,a3,1
 7c6:	fec771e3          	bgeu	a4,a2,7a8 <printint+0x28>
  if(neg)
 7ca:	000e0c63          	beqz	t3,7e2 <printint+0x62>
    buf[i++] = '-';
 7ce:	fd050793          	addi	a5,a0,-48
 7d2:	00878533          	add	a0,a5,s0
 7d6:	02d00793          	li	a5,45
 7da:	fef50423          	sb	a5,-24(a0)
 7de:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 7e2:	fff7899b          	addiw	s3,a5,-1
 7e6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 7ea:	fff4c583          	lbu	a1,-1(s1)
 7ee:	854a                	mv	a0,s2
 7f0:	f73ff0ef          	jal	762 <putc>
  while(--i >= 0)
 7f4:	39fd                	addiw	s3,s3,-1
 7f6:	14fd                	addi	s1,s1,-1
 7f8:	fe09d9e3          	bgez	s3,7ea <printint+0x6a>
}
 7fc:	60a6                	ld	ra,72(sp)
 7fe:	6406                	ld	s0,64(sp)
 800:	74e2                	ld	s1,56(sp)
 802:	7942                	ld	s2,48(sp)
 804:	79a2                	ld	s3,40(sp)
 806:	6161                	addi	sp,sp,80
 808:	8082                	ret
    x = -xx;
 80a:	40b005b3          	neg	a1,a1
    neg = 1;
 80e:	4e05                	li	t3,1
    x = -xx;
 810:	b761                	j	798 <printint+0x18>

0000000000000812 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 812:	711d                	addi	sp,sp,-96
 814:	ec86                	sd	ra,88(sp)
 816:	e8a2                	sd	s0,80(sp)
 818:	e4a6                	sd	s1,72(sp)
 81a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 81c:	0005c483          	lbu	s1,0(a1)
 820:	28048463          	beqz	s1,aa8 <vprintf+0x296>
 824:	e0ca                	sd	s2,64(sp)
 826:	fc4e                	sd	s3,56(sp)
 828:	f852                	sd	s4,48(sp)
 82a:	f456                	sd	s5,40(sp)
 82c:	f05a                	sd	s6,32(sp)
 82e:	ec5e                	sd	s7,24(sp)
 830:	e862                	sd	s8,16(sp)
 832:	e466                	sd	s9,8(sp)
 834:	8b2a                	mv	s6,a0
 836:	8a2e                	mv	s4,a1
 838:	8bb2                	mv	s7,a2
  state = 0;
 83a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 83c:	4901                	li	s2,0
 83e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 840:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 844:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 848:	06c00c93          	li	s9,108
 84c:	a00d                	j	86e <vprintf+0x5c>
        putc(fd, c0);
 84e:	85a6                	mv	a1,s1
 850:	855a                	mv	a0,s6
 852:	f11ff0ef          	jal	762 <putc>
 856:	a019                	j	85c <vprintf+0x4a>
    } else if(state == '%'){
 858:	03598363          	beq	s3,s5,87e <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 85c:	0019079b          	addiw	a5,s2,1
 860:	893e                	mv	s2,a5
 862:	873e                	mv	a4,a5
 864:	97d2                	add	a5,a5,s4
 866:	0007c483          	lbu	s1,0(a5)
 86a:	22048763          	beqz	s1,a98 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 86e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 872:	fe0993e3          	bnez	s3,858 <vprintf+0x46>
      if(c0 == '%'){
 876:	fd579ce3          	bne	a5,s5,84e <vprintf+0x3c>
        state = '%';
 87a:	89be                	mv	s3,a5
 87c:	b7c5                	j	85c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 87e:	00ea06b3          	add	a3,s4,a4
 882:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 886:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 888:	c681                	beqz	a3,890 <vprintf+0x7e>
 88a:	9752                	add	a4,a4,s4
 88c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 890:	05878263          	beq	a5,s8,8d4 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 894:	05978c63          	beq	a5,s9,8ec <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 898:	07500713          	li	a4,117
 89c:	0ee78663          	beq	a5,a4,988 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 8a0:	07800713          	li	a4,120
 8a4:	12e78863          	beq	a5,a4,9d4 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 8a8:	07000713          	li	a4,112
 8ac:	14e78d63          	beq	a5,a4,a06 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 8b0:	06300713          	li	a4,99
 8b4:	18e78c63          	beq	a5,a4,a4c <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 8b8:	07300713          	li	a4,115
 8bc:	1ae78263          	beq	a5,a4,a60 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 8c0:	02500713          	li	a4,37
 8c4:	04e79463          	bne	a5,a4,90c <vprintf+0xfa>
        putc(fd, '%');
 8c8:	85ba                	mv	a1,a4
 8ca:	855a                	mv	a0,s6
 8cc:	e97ff0ef          	jal	762 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 8d0:	4981                	li	s3,0
 8d2:	b769                	j	85c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 8d4:	008b8493          	addi	s1,s7,8
 8d8:	4685                	li	a3,1
 8da:	4629                	li	a2,10
 8dc:	000ba583          	lw	a1,0(s7)
 8e0:	855a                	mv	a0,s6
 8e2:	e9fff0ef          	jal	780 <printint>
 8e6:	8ba6                	mv	s7,s1
      state = 0;
 8e8:	4981                	li	s3,0
 8ea:	bf8d                	j	85c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 8ec:	06400793          	li	a5,100
 8f0:	02f68963          	beq	a3,a5,922 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8f4:	06c00793          	li	a5,108
 8f8:	04f68263          	beq	a3,a5,93c <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 8fc:	07500793          	li	a5,117
 900:	0af68063          	beq	a3,a5,9a0 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 904:	07800793          	li	a5,120
 908:	0ef68263          	beq	a3,a5,9ec <vprintf+0x1da>
        putc(fd, '%');
 90c:	02500593          	li	a1,37
 910:	855a                	mv	a0,s6
 912:	e51ff0ef          	jal	762 <putc>
        putc(fd, c0);
 916:	85a6                	mv	a1,s1
 918:	855a                	mv	a0,s6
 91a:	e49ff0ef          	jal	762 <putc>
      state = 0;
 91e:	4981                	li	s3,0
 920:	bf35                	j	85c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 922:	008b8493          	addi	s1,s7,8
 926:	4685                	li	a3,1
 928:	4629                	li	a2,10
 92a:	000bb583          	ld	a1,0(s7)
 92e:	855a                	mv	a0,s6
 930:	e51ff0ef          	jal	780 <printint>
        i += 1;
 934:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 936:	8ba6                	mv	s7,s1
      state = 0;
 938:	4981                	li	s3,0
        i += 1;
 93a:	b70d                	j	85c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 93c:	06400793          	li	a5,100
 940:	02f60763          	beq	a2,a5,96e <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 944:	07500793          	li	a5,117
 948:	06f60963          	beq	a2,a5,9ba <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 94c:	07800793          	li	a5,120
 950:	faf61ee3          	bne	a2,a5,90c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 954:	008b8493          	addi	s1,s7,8
 958:	4681                	li	a3,0
 95a:	4641                	li	a2,16
 95c:	000bb583          	ld	a1,0(s7)
 960:	855a                	mv	a0,s6
 962:	e1fff0ef          	jal	780 <printint>
        i += 2;
 966:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 968:	8ba6                	mv	s7,s1
      state = 0;
 96a:	4981                	li	s3,0
        i += 2;
 96c:	bdc5                	j	85c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 96e:	008b8493          	addi	s1,s7,8
 972:	4685                	li	a3,1
 974:	4629                	li	a2,10
 976:	000bb583          	ld	a1,0(s7)
 97a:	855a                	mv	a0,s6
 97c:	e05ff0ef          	jal	780 <printint>
        i += 2;
 980:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 982:	8ba6                	mv	s7,s1
      state = 0;
 984:	4981                	li	s3,0
        i += 2;
 986:	bdd9                	j	85c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 988:	008b8493          	addi	s1,s7,8
 98c:	4681                	li	a3,0
 98e:	4629                	li	a2,10
 990:	000be583          	lwu	a1,0(s7)
 994:	855a                	mv	a0,s6
 996:	debff0ef          	jal	780 <printint>
 99a:	8ba6                	mv	s7,s1
      state = 0;
 99c:	4981                	li	s3,0
 99e:	bd7d                	j	85c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9a0:	008b8493          	addi	s1,s7,8
 9a4:	4681                	li	a3,0
 9a6:	4629                	li	a2,10
 9a8:	000bb583          	ld	a1,0(s7)
 9ac:	855a                	mv	a0,s6
 9ae:	dd3ff0ef          	jal	780 <printint>
        i += 1;
 9b2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 9b4:	8ba6                	mv	s7,s1
      state = 0;
 9b6:	4981                	li	s3,0
        i += 1;
 9b8:	b555                	j	85c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9ba:	008b8493          	addi	s1,s7,8
 9be:	4681                	li	a3,0
 9c0:	4629                	li	a2,10
 9c2:	000bb583          	ld	a1,0(s7)
 9c6:	855a                	mv	a0,s6
 9c8:	db9ff0ef          	jal	780 <printint>
        i += 2;
 9cc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 9ce:	8ba6                	mv	s7,s1
      state = 0;
 9d0:	4981                	li	s3,0
        i += 2;
 9d2:	b569                	j	85c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 9d4:	008b8493          	addi	s1,s7,8
 9d8:	4681                	li	a3,0
 9da:	4641                	li	a2,16
 9dc:	000be583          	lwu	a1,0(s7)
 9e0:	855a                	mv	a0,s6
 9e2:	d9fff0ef          	jal	780 <printint>
 9e6:	8ba6                	mv	s7,s1
      state = 0;
 9e8:	4981                	li	s3,0
 9ea:	bd8d                	j	85c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9ec:	008b8493          	addi	s1,s7,8
 9f0:	4681                	li	a3,0
 9f2:	4641                	li	a2,16
 9f4:	000bb583          	ld	a1,0(s7)
 9f8:	855a                	mv	a0,s6
 9fa:	d87ff0ef          	jal	780 <printint>
        i += 1;
 9fe:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a00:	8ba6                	mv	s7,s1
      state = 0;
 a02:	4981                	li	s3,0
        i += 1;
 a04:	bda1                	j	85c <vprintf+0x4a>
 a06:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 a08:	008b8d13          	addi	s10,s7,8
 a0c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a10:	03000593          	li	a1,48
 a14:	855a                	mv	a0,s6
 a16:	d4dff0ef          	jal	762 <putc>
  putc(fd, 'x');
 a1a:	07800593          	li	a1,120
 a1e:	855a                	mv	a0,s6
 a20:	d43ff0ef          	jal	762 <putc>
 a24:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a26:	00000b97          	auipc	s7,0x0
 a2a:	2aab8b93          	addi	s7,s7,682 # cd0 <digits>
 a2e:	03c9d793          	srli	a5,s3,0x3c
 a32:	97de                	add	a5,a5,s7
 a34:	0007c583          	lbu	a1,0(a5)
 a38:	855a                	mv	a0,s6
 a3a:	d29ff0ef          	jal	762 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a3e:	0992                	slli	s3,s3,0x4
 a40:	34fd                	addiw	s1,s1,-1
 a42:	f4f5                	bnez	s1,a2e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 a44:	8bea                	mv	s7,s10
      state = 0;
 a46:	4981                	li	s3,0
 a48:	6d02                	ld	s10,0(sp)
 a4a:	bd09                	j	85c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 a4c:	008b8493          	addi	s1,s7,8
 a50:	000bc583          	lbu	a1,0(s7)
 a54:	855a                	mv	a0,s6
 a56:	d0dff0ef          	jal	762 <putc>
 a5a:	8ba6                	mv	s7,s1
      state = 0;
 a5c:	4981                	li	s3,0
 a5e:	bbfd                	j	85c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 a60:	008b8993          	addi	s3,s7,8
 a64:	000bb483          	ld	s1,0(s7)
 a68:	cc91                	beqz	s1,a84 <vprintf+0x272>
        for(; *s; s++)
 a6a:	0004c583          	lbu	a1,0(s1)
 a6e:	c195                	beqz	a1,a92 <vprintf+0x280>
          putc(fd, *s);
 a70:	855a                	mv	a0,s6
 a72:	cf1ff0ef          	jal	762 <putc>
        for(; *s; s++)
 a76:	0485                	addi	s1,s1,1
 a78:	0004c583          	lbu	a1,0(s1)
 a7c:	f9f5                	bnez	a1,a70 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 a7e:	8bce                	mv	s7,s3
      state = 0;
 a80:	4981                	li	s3,0
 a82:	bbe9                	j	85c <vprintf+0x4a>
          s = "(null)";
 a84:	00000497          	auipc	s1,0x0
 a88:	24448493          	addi	s1,s1,580 # cc8 <malloc+0x134>
        for(; *s; s++)
 a8c:	02800593          	li	a1,40
 a90:	b7c5                	j	a70 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 a92:	8bce                	mv	s7,s3
      state = 0;
 a94:	4981                	li	s3,0
 a96:	b3d9                	j	85c <vprintf+0x4a>
 a98:	6906                	ld	s2,64(sp)
 a9a:	79e2                	ld	s3,56(sp)
 a9c:	7a42                	ld	s4,48(sp)
 a9e:	7aa2                	ld	s5,40(sp)
 aa0:	7b02                	ld	s6,32(sp)
 aa2:	6be2                	ld	s7,24(sp)
 aa4:	6c42                	ld	s8,16(sp)
 aa6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 aa8:	60e6                	ld	ra,88(sp)
 aaa:	6446                	ld	s0,80(sp)
 aac:	64a6                	ld	s1,72(sp)
 aae:	6125                	addi	sp,sp,96
 ab0:	8082                	ret

0000000000000ab2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 ab2:	715d                	addi	sp,sp,-80
 ab4:	ec06                	sd	ra,24(sp)
 ab6:	e822                	sd	s0,16(sp)
 ab8:	1000                	addi	s0,sp,32
 aba:	e010                	sd	a2,0(s0)
 abc:	e414                	sd	a3,8(s0)
 abe:	e818                	sd	a4,16(s0)
 ac0:	ec1c                	sd	a5,24(s0)
 ac2:	03043023          	sd	a6,32(s0)
 ac6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 aca:	8622                	mv	a2,s0
 acc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ad0:	d43ff0ef          	jal	812 <vprintf>
}
 ad4:	60e2                	ld	ra,24(sp)
 ad6:	6442                	ld	s0,16(sp)
 ad8:	6161                	addi	sp,sp,80
 ada:	8082                	ret

0000000000000adc <printf>:

void
printf(const char *fmt, ...)
{
 adc:	711d                	addi	sp,sp,-96
 ade:	ec06                	sd	ra,24(sp)
 ae0:	e822                	sd	s0,16(sp)
 ae2:	1000                	addi	s0,sp,32
 ae4:	e40c                	sd	a1,8(s0)
 ae6:	e810                	sd	a2,16(s0)
 ae8:	ec14                	sd	a3,24(s0)
 aea:	f018                	sd	a4,32(s0)
 aec:	f41c                	sd	a5,40(s0)
 aee:	03043823          	sd	a6,48(s0)
 af2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 af6:	00840613          	addi	a2,s0,8
 afa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 afe:	85aa                	mv	a1,a0
 b00:	4505                	li	a0,1
 b02:	d11ff0ef          	jal	812 <vprintf>
}
 b06:	60e2                	ld	ra,24(sp)
 b08:	6442                	ld	s0,16(sp)
 b0a:	6125                	addi	sp,sp,96
 b0c:	8082                	ret

0000000000000b0e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b0e:	1141                	addi	sp,sp,-16
 b10:	e406                	sd	ra,8(sp)
 b12:	e022                	sd	s0,0(sp)
 b14:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b16:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b1a:	00000797          	auipc	a5,0x0
 b1e:	4e67b783          	ld	a5,1254(a5) # 1000 <freep>
 b22:	a02d                	j	b4c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b24:	4618                	lw	a4,8(a2)
 b26:	9f2d                	addw	a4,a4,a1
 b28:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b2c:	6398                	ld	a4,0(a5)
 b2e:	6310                	ld	a2,0(a4)
 b30:	a83d                	j	b6e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b32:	ff852703          	lw	a4,-8(a0)
 b36:	9f31                	addw	a4,a4,a2
 b38:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b3a:	ff053683          	ld	a3,-16(a0)
 b3e:	a091                	j	b82 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b40:	6398                	ld	a4,0(a5)
 b42:	00e7e463          	bltu	a5,a4,b4a <free+0x3c>
 b46:	00e6ea63          	bltu	a3,a4,b5a <free+0x4c>
{
 b4a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b4c:	fed7fae3          	bgeu	a5,a3,b40 <free+0x32>
 b50:	6398                	ld	a4,0(a5)
 b52:	00e6e463          	bltu	a3,a4,b5a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b56:	fee7eae3          	bltu	a5,a4,b4a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 b5a:	ff852583          	lw	a1,-8(a0)
 b5e:	6390                	ld	a2,0(a5)
 b60:	02059813          	slli	a6,a1,0x20
 b64:	01c85713          	srli	a4,a6,0x1c
 b68:	9736                	add	a4,a4,a3
 b6a:	fae60de3          	beq	a2,a4,b24 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 b6e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b72:	4790                	lw	a2,8(a5)
 b74:	02061593          	slli	a1,a2,0x20
 b78:	01c5d713          	srli	a4,a1,0x1c
 b7c:	973e                	add	a4,a4,a5
 b7e:	fae68ae3          	beq	a3,a4,b32 <free+0x24>
    p->s.ptr = bp->s.ptr;
 b82:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b84:	00000717          	auipc	a4,0x0
 b88:	46f73e23          	sd	a5,1148(a4) # 1000 <freep>
}
 b8c:	60a2                	ld	ra,8(sp)
 b8e:	6402                	ld	s0,0(sp)
 b90:	0141                	addi	sp,sp,16
 b92:	8082                	ret

0000000000000b94 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b94:	7139                	addi	sp,sp,-64
 b96:	fc06                	sd	ra,56(sp)
 b98:	f822                	sd	s0,48(sp)
 b9a:	f04a                	sd	s2,32(sp)
 b9c:	ec4e                	sd	s3,24(sp)
 b9e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ba0:	02051993          	slli	s3,a0,0x20
 ba4:	0209d993          	srli	s3,s3,0x20
 ba8:	09bd                	addi	s3,s3,15
 baa:	0049d993          	srli	s3,s3,0x4
 bae:	2985                	addiw	s3,s3,1
 bb0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 bb2:	00000517          	auipc	a0,0x0
 bb6:	44e53503          	ld	a0,1102(a0) # 1000 <freep>
 bba:	c905                	beqz	a0,bea <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bbc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bbe:	4798                	lw	a4,8(a5)
 bc0:	09377663          	bgeu	a4,s3,c4c <malloc+0xb8>
 bc4:	f426                	sd	s1,40(sp)
 bc6:	e852                	sd	s4,16(sp)
 bc8:	e456                	sd	s5,8(sp)
 bca:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 bcc:	8a4e                	mv	s4,s3
 bce:	6705                	lui	a4,0x1
 bd0:	00e9f363          	bgeu	s3,a4,bd6 <malloc+0x42>
 bd4:	6a05                	lui	s4,0x1
 bd6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bda:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bde:	00000497          	auipc	s1,0x0
 be2:	42248493          	addi	s1,s1,1058 # 1000 <freep>
  if(p == SBRK_ERROR)
 be6:	5afd                	li	s5,-1
 be8:	a83d                	j	c26 <malloc+0x92>
 bea:	f426                	sd	s1,40(sp)
 bec:	e852                	sd	s4,16(sp)
 bee:	e456                	sd	s5,8(sp)
 bf0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 bf2:	00001797          	auipc	a5,0x1
 bf6:	81e78793          	addi	a5,a5,-2018 # 1410 <base>
 bfa:	00000717          	auipc	a4,0x0
 bfe:	40f73323          	sd	a5,1030(a4) # 1000 <freep>
 c02:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c04:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c08:	b7d1                	j	bcc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 c0a:	6398                	ld	a4,0(a5)
 c0c:	e118                	sd	a4,0(a0)
 c0e:	a899                	j	c64 <malloc+0xd0>
  hp->s.size = nu;
 c10:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c14:	0541                	addi	a0,a0,16
 c16:	ef9ff0ef          	jal	b0e <free>
  return freep;
 c1a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 c1c:	c125                	beqz	a0,c7c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c1e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c20:	4798                	lw	a4,8(a5)
 c22:	03277163          	bgeu	a4,s2,c44 <malloc+0xb0>
    if(p == freep)
 c26:	6098                	ld	a4,0(s1)
 c28:	853e                	mv	a0,a5
 c2a:	fef71ae3          	bne	a4,a5,c1e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 c2e:	8552                	mv	a0,s4
 c30:	8c7ff0ef          	jal	4f6 <sbrk>
  if(p == SBRK_ERROR)
 c34:	fd551ee3          	bne	a0,s5,c10 <malloc+0x7c>
        return 0;
 c38:	4501                	li	a0,0
 c3a:	74a2                	ld	s1,40(sp)
 c3c:	6a42                	ld	s4,16(sp)
 c3e:	6aa2                	ld	s5,8(sp)
 c40:	6b02                	ld	s6,0(sp)
 c42:	a03d                	j	c70 <malloc+0xdc>
 c44:	74a2                	ld	s1,40(sp)
 c46:	6a42                	ld	s4,16(sp)
 c48:	6aa2                	ld	s5,8(sp)
 c4a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 c4c:	fae90fe3          	beq	s2,a4,c0a <malloc+0x76>
        p->s.size -= nunits;
 c50:	4137073b          	subw	a4,a4,s3
 c54:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c56:	02071693          	slli	a3,a4,0x20
 c5a:	01c6d713          	srli	a4,a3,0x1c
 c5e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c60:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c64:	00000717          	auipc	a4,0x0
 c68:	38a73e23          	sd	a0,924(a4) # 1000 <freep>
      return (void*)(p + 1);
 c6c:	01078513          	addi	a0,a5,16
  }
}
 c70:	70e2                	ld	ra,56(sp)
 c72:	7442                	ld	s0,48(sp)
 c74:	7902                	ld	s2,32(sp)
 c76:	69e2                	ld	s3,24(sp)
 c78:	6121                	addi	sp,sp,64
 c7a:	8082                	ret
 c7c:	74a2                	ld	s1,40(sp)
 c7e:	6a42                	ld	s4,16(sp)
 c80:	6aa2                	ld	s5,8(sp)
 c82:	6b02                	ld	s6,0(sp)
 c84:	b7f5                	j	c70 <malloc+0xdc>
