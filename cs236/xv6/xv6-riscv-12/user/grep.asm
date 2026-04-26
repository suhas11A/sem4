
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
 168:	3e2000ef          	jal	54a <write>
 16c:	b7f9                	j	13a <grep+0x34>
    if(m > 0){
 16e:	03604463          	bgtz	s6,196 <grep+0x90>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 172:	416d063b          	subw	a2,s10,s6
 176:	016b85b3          	add	a1,s7,s6
 17a:	8566                	mv	a0,s9
 17c:	3c6000ef          	jal	542 <read>
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
 206:	364000ef          	jal	56a <open>
 20a:	84aa                	mv	s1,a0
 20c:	04054063          	bltz	a0,24c <main+0x80>
    grep(pattern, fd);
 210:	85aa                	mv	a1,a0
 212:	8552                	mv	a0,s4
 214:	ef3ff0ef          	jal	106 <grep>
    close(fd);
 218:	8526                	mv	a0,s1
 21a:	338000ef          	jal	552 <close>
  for(i = 2; i < argc; i++){
 21e:	0921                	addi	s2,s2,8
 220:	ff3910e3          	bne	s2,s3,200 <main+0x34>
  exit(0);
 224:	4501                	li	a0,0
 226:	304000ef          	jal	52a <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 22a:	00001597          	auipc	a1,0x1
 22e:	8e658593          	addi	a1,a1,-1818 # b10 <malloc+0xf2>
 232:	4509                	li	a0,2
 234:	708000ef          	jal	93c <fprintf>
    exit(1);
 238:	4505                	li	a0,1
 23a:	2f0000ef          	jal	52a <exit>
    grep(pattern, 0);
 23e:	4581                	li	a1,0
 240:	8552                	mv	a0,s4
 242:	ec5ff0ef          	jal	106 <grep>
    exit(0);
 246:	4501                	li	a0,0
 248:	2e2000ef          	jal	52a <exit>
      printf("grep: cannot open %s\n", argv[i]);
 24c:	00093583          	ld	a1,0(s2)
 250:	00001517          	auipc	a0,0x1
 254:	8e050513          	addi	a0,a0,-1824 # b30 <malloc+0x112>
 258:	70e000ef          	jal	966 <printf>
      exit(1);
 25c:	4505                	li	a0,1
 25e:	2cc000ef          	jal	52a <exit>

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
 26e:	2bc000ef          	jal	52a <exit>

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
 37e:	1c4000ef          	jal	542 <read>
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
 3d0:	19a000ef          	jal	56a <open>
  if(fd < 0)
 3d4:	02054263          	bltz	a0,3f8 <stat+0x36>
 3d8:	e426                	sd	s1,8(sp)
 3da:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3dc:	85ca                	mv	a1,s2
 3de:	1a4000ef          	jal	582 <fstat>
 3e2:	892a                	mv	s2,a0
  close(fd);
 3e4:	8526                	mv	a0,s1
 3e6:	16c000ef          	jal	552 <close>
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
 500:	0b2000ef          	jal	5b2 <sys_sbrk>
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
 516:	09c000ef          	jal	5b2 <sys_sbrk>
}
 51a:	60a2                	ld	ra,8(sp)
 51c:	6402                	ld	s0,0(sp)
 51e:	0141                	addi	sp,sp,16
 520:	8082                	ret

0000000000000522 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 522:	4885                	li	a7,1
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <exit>:
.global exit
exit:
 li a7, SYS_exit
 52a:	4889                	li	a7,2
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <wait>:
.global wait
wait:
 li a7, SYS_wait
 532:	488d                	li	a7,3
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 53a:	4891                	li	a7,4
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <read>:
.global read
read:
 li a7, SYS_read
 542:	4895                	li	a7,5
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <write>:
.global write
write:
 li a7, SYS_write
 54a:	48c1                	li	a7,16
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <close>:
.global close
close:
 li a7, SYS_close
 552:	48d5                	li	a7,21
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <kill>:
.global kill
kill:
 li a7, SYS_kill
 55a:	4899                	li	a7,6
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <exec>:
.global exec
exec:
 li a7, SYS_exec
 562:	489d                	li	a7,7
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <open>:
.global open
open:
 li a7, SYS_open
 56a:	48bd                	li	a7,15
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 572:	48c5                	li	a7,17
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 57a:	48c9                	li	a7,18
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 582:	48a1                	li	a7,8
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <link>:
.global link
link:
 li a7, SYS_link
 58a:	48cd                	li	a7,19
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 592:	48d1                	li	a7,20
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 59a:	48a5                	li	a7,9
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5a2:	48a9                	li	a7,10
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5aa:	48ad                	li	a7,11
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5b2:	48b1                	li	a7,12
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <pause>:
.global pause
pause:
 li a7, SYS_pause
 5ba:	48b5                	li	a7,13
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5c2:	48b9                	li	a7,14
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <bind>:
.global bind
bind:
 li a7, SYS_bind
 5ca:	48f5                	li	a7,29
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 5d2:	48f9                	li	a7,30
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <send>:
.global send
send:
 li a7, SYS_send
 5da:	48fd                	li	a7,31
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <recv>:
.global recv
recv:
 li a7, SYS_recv
 5e2:	02000893          	li	a7,32
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ec:	1101                	addi	sp,sp,-32
 5ee:	ec06                	sd	ra,24(sp)
 5f0:	e822                	sd	s0,16(sp)
 5f2:	1000                	addi	s0,sp,32
 5f4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5f8:	4605                	li	a2,1
 5fa:	fef40593          	addi	a1,s0,-17
 5fe:	f4dff0ef          	jal	54a <write>
}
 602:	60e2                	ld	ra,24(sp)
 604:	6442                	ld	s0,16(sp)
 606:	6105                	addi	sp,sp,32
 608:	8082                	ret

000000000000060a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 60a:	715d                	addi	sp,sp,-80
 60c:	e486                	sd	ra,72(sp)
 60e:	e0a2                	sd	s0,64(sp)
 610:	fc26                	sd	s1,56(sp)
 612:	f84a                	sd	s2,48(sp)
 614:	f44e                	sd	s3,40(sp)
 616:	0880                	addi	s0,sp,80
 618:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 61a:	c299                	beqz	a3,620 <printint+0x16>
 61c:	0605cc63          	bltz	a1,694 <printint+0x8a>
  neg = 0;
 620:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 622:	fb840313          	addi	t1,s0,-72
  neg = 0;
 626:	869a                	mv	a3,t1
  i = 0;
 628:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 62a:	00000817          	auipc	a6,0x0
 62e:	52680813          	addi	a6,a6,1318 # b50 <digits>
 632:	88be                	mv	a7,a5
 634:	0017851b          	addiw	a0,a5,1
 638:	87aa                	mv	a5,a0
 63a:	02c5f733          	remu	a4,a1,a2
 63e:	9742                	add	a4,a4,a6
 640:	00074703          	lbu	a4,0(a4)
 644:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 648:	872e                	mv	a4,a1
 64a:	02c5d5b3          	divu	a1,a1,a2
 64e:	0685                	addi	a3,a3,1
 650:	fec771e3          	bgeu	a4,a2,632 <printint+0x28>
  if(neg)
 654:	000e0c63          	beqz	t3,66c <printint+0x62>
    buf[i++] = '-';
 658:	fd050793          	addi	a5,a0,-48
 65c:	00878533          	add	a0,a5,s0
 660:	02d00793          	li	a5,45
 664:	fef50423          	sb	a5,-24(a0)
 668:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 66c:	fff7899b          	addiw	s3,a5,-1
 670:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 674:	fff4c583          	lbu	a1,-1(s1)
 678:	854a                	mv	a0,s2
 67a:	f73ff0ef          	jal	5ec <putc>
  while(--i >= 0)
 67e:	39fd                	addiw	s3,s3,-1
 680:	14fd                	addi	s1,s1,-1
 682:	fe09d9e3          	bgez	s3,674 <printint+0x6a>
}
 686:	60a6                	ld	ra,72(sp)
 688:	6406                	ld	s0,64(sp)
 68a:	74e2                	ld	s1,56(sp)
 68c:	7942                	ld	s2,48(sp)
 68e:	79a2                	ld	s3,40(sp)
 690:	6161                	addi	sp,sp,80
 692:	8082                	ret
    x = -xx;
 694:	40b005b3          	neg	a1,a1
    neg = 1;
 698:	4e05                	li	t3,1
    x = -xx;
 69a:	b761                	j	622 <printint+0x18>

000000000000069c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 69c:	711d                	addi	sp,sp,-96
 69e:	ec86                	sd	ra,88(sp)
 6a0:	e8a2                	sd	s0,80(sp)
 6a2:	e4a6                	sd	s1,72(sp)
 6a4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6a6:	0005c483          	lbu	s1,0(a1)
 6aa:	28048463          	beqz	s1,932 <vprintf+0x296>
 6ae:	e0ca                	sd	s2,64(sp)
 6b0:	fc4e                	sd	s3,56(sp)
 6b2:	f852                	sd	s4,48(sp)
 6b4:	f456                	sd	s5,40(sp)
 6b6:	f05a                	sd	s6,32(sp)
 6b8:	ec5e                	sd	s7,24(sp)
 6ba:	e862                	sd	s8,16(sp)
 6bc:	e466                	sd	s9,8(sp)
 6be:	8b2a                	mv	s6,a0
 6c0:	8a2e                	mv	s4,a1
 6c2:	8bb2                	mv	s7,a2
  state = 0;
 6c4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6c6:	4901                	li	s2,0
 6c8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6ca:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6ce:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6d2:	06c00c93          	li	s9,108
 6d6:	a00d                	j	6f8 <vprintf+0x5c>
        putc(fd, c0);
 6d8:	85a6                	mv	a1,s1
 6da:	855a                	mv	a0,s6
 6dc:	f11ff0ef          	jal	5ec <putc>
 6e0:	a019                	j	6e6 <vprintf+0x4a>
    } else if(state == '%'){
 6e2:	03598363          	beq	s3,s5,708 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6e6:	0019079b          	addiw	a5,s2,1
 6ea:	893e                	mv	s2,a5
 6ec:	873e                	mv	a4,a5
 6ee:	97d2                	add	a5,a5,s4
 6f0:	0007c483          	lbu	s1,0(a5)
 6f4:	22048763          	beqz	s1,922 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 6f8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6fc:	fe0993e3          	bnez	s3,6e2 <vprintf+0x46>
      if(c0 == '%'){
 700:	fd579ce3          	bne	a5,s5,6d8 <vprintf+0x3c>
        state = '%';
 704:	89be                	mv	s3,a5
 706:	b7c5                	j	6e6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 708:	00ea06b3          	add	a3,s4,a4
 70c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 710:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 712:	c681                	beqz	a3,71a <vprintf+0x7e>
 714:	9752                	add	a4,a4,s4
 716:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 71a:	05878263          	beq	a5,s8,75e <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 71e:	05978c63          	beq	a5,s9,776 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 722:	07500713          	li	a4,117
 726:	0ee78663          	beq	a5,a4,812 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 72a:	07800713          	li	a4,120
 72e:	12e78863          	beq	a5,a4,85e <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 732:	07000713          	li	a4,112
 736:	14e78d63          	beq	a5,a4,890 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 73a:	06300713          	li	a4,99
 73e:	18e78c63          	beq	a5,a4,8d6 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 742:	07300713          	li	a4,115
 746:	1ae78263          	beq	a5,a4,8ea <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 74a:	02500713          	li	a4,37
 74e:	04e79463          	bne	a5,a4,796 <vprintf+0xfa>
        putc(fd, '%');
 752:	85ba                	mv	a1,a4
 754:	855a                	mv	a0,s6
 756:	e97ff0ef          	jal	5ec <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 75a:	4981                	li	s3,0
 75c:	b769                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 75e:	008b8493          	addi	s1,s7,8
 762:	4685                	li	a3,1
 764:	4629                	li	a2,10
 766:	000ba583          	lw	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	e9fff0ef          	jal	60a <printint>
 770:	8ba6                	mv	s7,s1
      state = 0;
 772:	4981                	li	s3,0
 774:	bf8d                	j	6e6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 776:	06400793          	li	a5,100
 77a:	02f68963          	beq	a3,a5,7ac <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 77e:	06c00793          	li	a5,108
 782:	04f68263          	beq	a3,a5,7c6 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 786:	07500793          	li	a5,117
 78a:	0af68063          	beq	a3,a5,82a <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 78e:	07800793          	li	a5,120
 792:	0ef68263          	beq	a3,a5,876 <vprintf+0x1da>
        putc(fd, '%');
 796:	02500593          	li	a1,37
 79a:	855a                	mv	a0,s6
 79c:	e51ff0ef          	jal	5ec <putc>
        putc(fd, c0);
 7a0:	85a6                	mv	a1,s1
 7a2:	855a                	mv	a0,s6
 7a4:	e49ff0ef          	jal	5ec <putc>
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bf35                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ac:	008b8493          	addi	s1,s7,8
 7b0:	4685                	li	a3,1
 7b2:	4629                	li	a2,10
 7b4:	000bb583          	ld	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	e51ff0ef          	jal	60a <printint>
        i += 1;
 7be:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c0:	8ba6                	mv	s7,s1
      state = 0;
 7c2:	4981                	li	s3,0
        i += 1;
 7c4:	b70d                	j	6e6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7c6:	06400793          	li	a5,100
 7ca:	02f60763          	beq	a2,a5,7f8 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7ce:	07500793          	li	a5,117
 7d2:	06f60963          	beq	a2,a5,844 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7d6:	07800793          	li	a5,120
 7da:	faf61ee3          	bne	a2,a5,796 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7de:	008b8493          	addi	s1,s7,8
 7e2:	4681                	li	a3,0
 7e4:	4641                	li	a2,16
 7e6:	000bb583          	ld	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	e1fff0ef          	jal	60a <printint>
        i += 2;
 7f0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f2:	8ba6                	mv	s7,s1
      state = 0;
 7f4:	4981                	li	s3,0
        i += 2;
 7f6:	bdc5                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f8:	008b8493          	addi	s1,s7,8
 7fc:	4685                	li	a3,1
 7fe:	4629                	li	a2,10
 800:	000bb583          	ld	a1,0(s7)
 804:	855a                	mv	a0,s6
 806:	e05ff0ef          	jal	60a <printint>
        i += 2;
 80a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 80c:	8ba6                	mv	s7,s1
      state = 0;
 80e:	4981                	li	s3,0
        i += 2;
 810:	bdd9                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 812:	008b8493          	addi	s1,s7,8
 816:	4681                	li	a3,0
 818:	4629                	li	a2,10
 81a:	000be583          	lwu	a1,0(s7)
 81e:	855a                	mv	a0,s6
 820:	debff0ef          	jal	60a <printint>
 824:	8ba6                	mv	s7,s1
      state = 0;
 826:	4981                	li	s3,0
 828:	bd7d                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 82a:	008b8493          	addi	s1,s7,8
 82e:	4681                	li	a3,0
 830:	4629                	li	a2,10
 832:	000bb583          	ld	a1,0(s7)
 836:	855a                	mv	a0,s6
 838:	dd3ff0ef          	jal	60a <printint>
        i += 1;
 83c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 83e:	8ba6                	mv	s7,s1
      state = 0;
 840:	4981                	li	s3,0
        i += 1;
 842:	b555                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 844:	008b8493          	addi	s1,s7,8
 848:	4681                	li	a3,0
 84a:	4629                	li	a2,10
 84c:	000bb583          	ld	a1,0(s7)
 850:	855a                	mv	a0,s6
 852:	db9ff0ef          	jal	60a <printint>
        i += 2;
 856:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 858:	8ba6                	mv	s7,s1
      state = 0;
 85a:	4981                	li	s3,0
        i += 2;
 85c:	b569                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 85e:	008b8493          	addi	s1,s7,8
 862:	4681                	li	a3,0
 864:	4641                	li	a2,16
 866:	000be583          	lwu	a1,0(s7)
 86a:	855a                	mv	a0,s6
 86c:	d9fff0ef          	jal	60a <printint>
 870:	8ba6                	mv	s7,s1
      state = 0;
 872:	4981                	li	s3,0
 874:	bd8d                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 876:	008b8493          	addi	s1,s7,8
 87a:	4681                	li	a3,0
 87c:	4641                	li	a2,16
 87e:	000bb583          	ld	a1,0(s7)
 882:	855a                	mv	a0,s6
 884:	d87ff0ef          	jal	60a <printint>
        i += 1;
 888:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 88a:	8ba6                	mv	s7,s1
      state = 0;
 88c:	4981                	li	s3,0
        i += 1;
 88e:	bda1                	j	6e6 <vprintf+0x4a>
 890:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 892:	008b8d13          	addi	s10,s7,8
 896:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 89a:	03000593          	li	a1,48
 89e:	855a                	mv	a0,s6
 8a0:	d4dff0ef          	jal	5ec <putc>
  putc(fd, 'x');
 8a4:	07800593          	li	a1,120
 8a8:	855a                	mv	a0,s6
 8aa:	d43ff0ef          	jal	5ec <putc>
 8ae:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8b0:	00000b97          	auipc	s7,0x0
 8b4:	2a0b8b93          	addi	s7,s7,672 # b50 <digits>
 8b8:	03c9d793          	srli	a5,s3,0x3c
 8bc:	97de                	add	a5,a5,s7
 8be:	0007c583          	lbu	a1,0(a5)
 8c2:	855a                	mv	a0,s6
 8c4:	d29ff0ef          	jal	5ec <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8c8:	0992                	slli	s3,s3,0x4
 8ca:	34fd                	addiw	s1,s1,-1
 8cc:	f4f5                	bnez	s1,8b8 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 8ce:	8bea                	mv	s7,s10
      state = 0;
 8d0:	4981                	li	s3,0
 8d2:	6d02                	ld	s10,0(sp)
 8d4:	bd09                	j	6e6 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 8d6:	008b8493          	addi	s1,s7,8
 8da:	000bc583          	lbu	a1,0(s7)
 8de:	855a                	mv	a0,s6
 8e0:	d0dff0ef          	jal	5ec <putc>
 8e4:	8ba6                	mv	s7,s1
      state = 0;
 8e6:	4981                	li	s3,0
 8e8:	bbfd                	j	6e6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8ea:	008b8993          	addi	s3,s7,8
 8ee:	000bb483          	ld	s1,0(s7)
 8f2:	cc91                	beqz	s1,90e <vprintf+0x272>
        for(; *s; s++)
 8f4:	0004c583          	lbu	a1,0(s1)
 8f8:	c195                	beqz	a1,91c <vprintf+0x280>
          putc(fd, *s);
 8fa:	855a                	mv	a0,s6
 8fc:	cf1ff0ef          	jal	5ec <putc>
        for(; *s; s++)
 900:	0485                	addi	s1,s1,1
 902:	0004c583          	lbu	a1,0(s1)
 906:	f9f5                	bnez	a1,8fa <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 908:	8bce                	mv	s7,s3
      state = 0;
 90a:	4981                	li	s3,0
 90c:	bbe9                	j	6e6 <vprintf+0x4a>
          s = "(null)";
 90e:	00000497          	auipc	s1,0x0
 912:	23a48493          	addi	s1,s1,570 # b48 <malloc+0x12a>
        for(; *s; s++)
 916:	02800593          	li	a1,40
 91a:	b7c5                	j	8fa <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 91c:	8bce                	mv	s7,s3
      state = 0;
 91e:	4981                	li	s3,0
 920:	b3d9                	j	6e6 <vprintf+0x4a>
 922:	6906                	ld	s2,64(sp)
 924:	79e2                	ld	s3,56(sp)
 926:	7a42                	ld	s4,48(sp)
 928:	7aa2                	ld	s5,40(sp)
 92a:	7b02                	ld	s6,32(sp)
 92c:	6be2                	ld	s7,24(sp)
 92e:	6c42                	ld	s8,16(sp)
 930:	6ca2                	ld	s9,8(sp)
    }
  }
}
 932:	60e6                	ld	ra,88(sp)
 934:	6446                	ld	s0,80(sp)
 936:	64a6                	ld	s1,72(sp)
 938:	6125                	addi	sp,sp,96
 93a:	8082                	ret

000000000000093c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 93c:	715d                	addi	sp,sp,-80
 93e:	ec06                	sd	ra,24(sp)
 940:	e822                	sd	s0,16(sp)
 942:	1000                	addi	s0,sp,32
 944:	e010                	sd	a2,0(s0)
 946:	e414                	sd	a3,8(s0)
 948:	e818                	sd	a4,16(s0)
 94a:	ec1c                	sd	a5,24(s0)
 94c:	03043023          	sd	a6,32(s0)
 950:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 954:	8622                	mv	a2,s0
 956:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 95a:	d43ff0ef          	jal	69c <vprintf>
}
 95e:	60e2                	ld	ra,24(sp)
 960:	6442                	ld	s0,16(sp)
 962:	6161                	addi	sp,sp,80
 964:	8082                	ret

0000000000000966 <printf>:

void
printf(const char *fmt, ...)
{
 966:	711d                	addi	sp,sp,-96
 968:	ec06                	sd	ra,24(sp)
 96a:	e822                	sd	s0,16(sp)
 96c:	1000                	addi	s0,sp,32
 96e:	e40c                	sd	a1,8(s0)
 970:	e810                	sd	a2,16(s0)
 972:	ec14                	sd	a3,24(s0)
 974:	f018                	sd	a4,32(s0)
 976:	f41c                	sd	a5,40(s0)
 978:	03043823          	sd	a6,48(s0)
 97c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 980:	00840613          	addi	a2,s0,8
 984:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 988:	85aa                	mv	a1,a0
 98a:	4505                	li	a0,1
 98c:	d11ff0ef          	jal	69c <vprintf>
}
 990:	60e2                	ld	ra,24(sp)
 992:	6442                	ld	s0,16(sp)
 994:	6125                	addi	sp,sp,96
 996:	8082                	ret

0000000000000998 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 998:	1141                	addi	sp,sp,-16
 99a:	e406                	sd	ra,8(sp)
 99c:	e022                	sd	s0,0(sp)
 99e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9a0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a4:	00000797          	auipc	a5,0x0
 9a8:	65c7b783          	ld	a5,1628(a5) # 1000 <freep>
 9ac:	a02d                	j	9d6 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9ae:	4618                	lw	a4,8(a2)
 9b0:	9f2d                	addw	a4,a4,a1
 9b2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b6:	6398                	ld	a4,0(a5)
 9b8:	6310                	ld	a2,0(a4)
 9ba:	a83d                	j	9f8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9bc:	ff852703          	lw	a4,-8(a0)
 9c0:	9f31                	addw	a4,a4,a2
 9c2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9c4:	ff053683          	ld	a3,-16(a0)
 9c8:	a091                	j	a0c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ca:	6398                	ld	a4,0(a5)
 9cc:	00e7e463          	bltu	a5,a4,9d4 <free+0x3c>
 9d0:	00e6ea63          	bltu	a3,a4,9e4 <free+0x4c>
{
 9d4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d6:	fed7fae3          	bgeu	a5,a3,9ca <free+0x32>
 9da:	6398                	ld	a4,0(a5)
 9dc:	00e6e463          	bltu	a3,a4,9e4 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9e0:	fee7eae3          	bltu	a5,a4,9d4 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9e4:	ff852583          	lw	a1,-8(a0)
 9e8:	6390                	ld	a2,0(a5)
 9ea:	02059813          	slli	a6,a1,0x20
 9ee:	01c85713          	srli	a4,a6,0x1c
 9f2:	9736                	add	a4,a4,a3
 9f4:	fae60de3          	beq	a2,a4,9ae <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9f8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9fc:	4790                	lw	a2,8(a5)
 9fe:	02061593          	slli	a1,a2,0x20
 a02:	01c5d713          	srli	a4,a1,0x1c
 a06:	973e                	add	a4,a4,a5
 a08:	fae68ae3          	beq	a3,a4,9bc <free+0x24>
    p->s.ptr = bp->s.ptr;
 a0c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a0e:	00000717          	auipc	a4,0x0
 a12:	5ef73923          	sd	a5,1522(a4) # 1000 <freep>
}
 a16:	60a2                	ld	ra,8(sp)
 a18:	6402                	ld	s0,0(sp)
 a1a:	0141                	addi	sp,sp,16
 a1c:	8082                	ret

0000000000000a1e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a1e:	7139                	addi	sp,sp,-64
 a20:	fc06                	sd	ra,56(sp)
 a22:	f822                	sd	s0,48(sp)
 a24:	f04a                	sd	s2,32(sp)
 a26:	ec4e                	sd	s3,24(sp)
 a28:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a2a:	02051993          	slli	s3,a0,0x20
 a2e:	0209d993          	srli	s3,s3,0x20
 a32:	09bd                	addi	s3,s3,15
 a34:	0049d993          	srli	s3,s3,0x4
 a38:	2985                	addiw	s3,s3,1
 a3a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a3c:	00000517          	auipc	a0,0x0
 a40:	5c453503          	ld	a0,1476(a0) # 1000 <freep>
 a44:	c905                	beqz	a0,a74 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a46:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a48:	4798                	lw	a4,8(a5)
 a4a:	09377663          	bgeu	a4,s3,ad6 <malloc+0xb8>
 a4e:	f426                	sd	s1,40(sp)
 a50:	e852                	sd	s4,16(sp)
 a52:	e456                	sd	s5,8(sp)
 a54:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a56:	8a4e                	mv	s4,s3
 a58:	6705                	lui	a4,0x1
 a5a:	00e9f363          	bgeu	s3,a4,a60 <malloc+0x42>
 a5e:	6a05                	lui	s4,0x1
 a60:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a64:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a68:	00000497          	auipc	s1,0x0
 a6c:	59848493          	addi	s1,s1,1432 # 1000 <freep>
  if(p == SBRK_ERROR)
 a70:	5afd                	li	s5,-1
 a72:	a83d                	j	ab0 <malloc+0x92>
 a74:	f426                	sd	s1,40(sp)
 a76:	e852                	sd	s4,16(sp)
 a78:	e456                	sd	s5,8(sp)
 a7a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a7c:	00001797          	auipc	a5,0x1
 a80:	99478793          	addi	a5,a5,-1644 # 1410 <base>
 a84:	00000717          	auipc	a4,0x0
 a88:	56f73e23          	sd	a5,1404(a4) # 1000 <freep>
 a8c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a8e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a92:	b7d1                	j	a56 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a94:	6398                	ld	a4,0(a5)
 a96:	e118                	sd	a4,0(a0)
 a98:	a899                	j	aee <malloc+0xd0>
  hp->s.size = nu;
 a9a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a9e:	0541                	addi	a0,a0,16
 aa0:	ef9ff0ef          	jal	998 <free>
  return freep;
 aa4:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 aa6:	c125                	beqz	a0,b06 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aaa:	4798                	lw	a4,8(a5)
 aac:	03277163          	bgeu	a4,s2,ace <malloc+0xb0>
    if(p == freep)
 ab0:	6098                	ld	a4,0(s1)
 ab2:	853e                	mv	a0,a5
 ab4:	fef71ae3          	bne	a4,a5,aa8 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ab8:	8552                	mv	a0,s4
 aba:	a3dff0ef          	jal	4f6 <sbrk>
  if(p == SBRK_ERROR)
 abe:	fd551ee3          	bne	a0,s5,a9a <malloc+0x7c>
        return 0;
 ac2:	4501                	li	a0,0
 ac4:	74a2                	ld	s1,40(sp)
 ac6:	6a42                	ld	s4,16(sp)
 ac8:	6aa2                	ld	s5,8(sp)
 aca:	6b02                	ld	s6,0(sp)
 acc:	a03d                	j	afa <malloc+0xdc>
 ace:	74a2                	ld	s1,40(sp)
 ad0:	6a42                	ld	s4,16(sp)
 ad2:	6aa2                	ld	s5,8(sp)
 ad4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ad6:	fae90fe3          	beq	s2,a4,a94 <malloc+0x76>
        p->s.size -= nunits;
 ada:	4137073b          	subw	a4,a4,s3
 ade:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ae0:	02071693          	slli	a3,a4,0x20
 ae4:	01c6d713          	srli	a4,a3,0x1c
 ae8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aee:	00000717          	auipc	a4,0x0
 af2:	50a73923          	sd	a0,1298(a4) # 1000 <freep>
      return (void*)(p + 1);
 af6:	01078513          	addi	a0,a5,16
  }
}
 afa:	70e2                	ld	ra,56(sp)
 afc:	7442                	ld	s0,48(sp)
 afe:	7902                	ld	s2,32(sp)
 b00:	69e2                	ld	s3,24(sp)
 b02:	6121                	addi	sp,sp,64
 b04:	8082                	ret
 b06:	74a2                	ld	s1,40(sp)
 b08:	6a42                	ld	s4,16(sp)
 b0a:	6aa2                	ld	s5,8(sp)
 b0c:	6b02                	ld	s6,0(sp)
 b0e:	b7f5                	j	afa <malloc+0xdc>
