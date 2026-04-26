
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2e0000ef          	jal	2ec <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	2b8000ef          	jal	2ec <strlen>
  38:	47b5                	li	a5,13
  3a:	00a7f863          	bgeu	a5,a0,4a <fmtname+0x4a>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  buf[sizeof(buf)-1] = '\0';
  return buf;
}
  3e:	8526                	mv	a0,s1
  40:	70a2                	ld	ra,40(sp)
  42:	7402                	ld	s0,32(sp)
  44:	64e2                	ld	s1,24(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret
  4a:	e84a                	sd	s2,16(sp)
  4c:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  4e:	8526                	mv	a0,s1
  50:	29c000ef          	jal	2ec <strlen>
  54:	862a                	mv	a2,a0
  56:	00001997          	auipc	s3,0x1
  5a:	fba98993          	addi	s3,s3,-70 # 1010 <buf.0>
  5e:	85a6                	mv	a1,s1
  60:	854e                	mv	a0,s3
  62:	410000ef          	jal	472 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  66:	8526                	mv	a0,s1
  68:	284000ef          	jal	2ec <strlen>
  6c:	892a                	mv	s2,a0
  6e:	8526                	mv	a0,s1
  70:	27c000ef          	jal	2ec <strlen>
  74:	1902                	slli	s2,s2,0x20
  76:	02095913          	srli	s2,s2,0x20
  7a:	4639                	li	a2,14
  7c:	9e09                	subw	a2,a2,a0
  7e:	02000593          	li	a1,32
  82:	01298533          	add	a0,s3,s2
  86:	294000ef          	jal	31a <memset>
  buf[sizeof(buf)-1] = '\0';
  8a:	00098723          	sb	zero,14(s3)
  return buf;
  8e:	84ce                	mv	s1,s3
  90:	6942                	ld	s2,16(sp)
  92:	69a2                	ld	s3,8(sp)
  94:	b76d                	j	3e <fmtname+0x3e>

0000000000000096 <ls>:

void
ls(char *path)
{
  96:	d7010113          	addi	sp,sp,-656
  9a:	28113423          	sd	ra,648(sp)
  9e:	28813023          	sd	s0,640(sp)
  a2:	27213823          	sd	s2,624(sp)
  a6:	0d00                	addi	s0,sp,656
  a8:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  aa:	4581                	li	a1,0
  ac:	660000ef          	jal	70c <open>
  b0:	06054363          	bltz	a0,116 <ls+0x80>
  b4:	26913c23          	sd	s1,632(sp)
  b8:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  ba:	d7840593          	addi	a1,s0,-648
  be:	666000ef          	jal	724 <fstat>
  c2:	06054363          	bltz	a0,128 <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c6:	d8041783          	lh	a5,-640(s0)
  ca:	4705                	li	a4,1
  cc:	06e78c63          	beq	a5,a4,144 <ls+0xae>
  d0:	37f9                	addiw	a5,a5,-2
  d2:	17c2                	slli	a5,a5,0x30
  d4:	93c1                	srli	a5,a5,0x30
  d6:	02f76263          	bltu	a4,a5,fa <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  da:	854a                	mv	a0,s2
  dc:	f25ff0ef          	jal	0 <fmtname>
  e0:	85aa                	mv	a1,a0
  e2:	d8842703          	lw	a4,-632(s0)
  e6:	d7c42683          	lw	a3,-644(s0)
  ea:	d8041603          	lh	a2,-640(s0)
  ee:	00001517          	auipc	a0,0x1
  f2:	bf250513          	addi	a0,a0,-1038 # ce0 <malloc+0x122>
  f6:	211000ef          	jal	b06 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  fa:	8526                	mv	a0,s1
  fc:	5f8000ef          	jal	6f4 <close>
 100:	27813483          	ld	s1,632(sp)
}
 104:	28813083          	ld	ra,648(sp)
 108:	28013403          	ld	s0,640(sp)
 10c:	27013903          	ld	s2,624(sp)
 110:	29010113          	addi	sp,sp,656
 114:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 116:	864a                	mv	a2,s2
 118:	00001597          	auipc	a1,0x1
 11c:	b9858593          	addi	a1,a1,-1128 # cb0 <malloc+0xf2>
 120:	4509                	li	a0,2
 122:	1bb000ef          	jal	adc <fprintf>
    return;
 126:	bff9                	j	104 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 128:	864a                	mv	a2,s2
 12a:	00001597          	auipc	a1,0x1
 12e:	b9e58593          	addi	a1,a1,-1122 # cc8 <malloc+0x10a>
 132:	4509                	li	a0,2
 134:	1a9000ef          	jal	adc <fprintf>
    close(fd);
 138:	8526                	mv	a0,s1
 13a:	5ba000ef          	jal	6f4 <close>
    return;
 13e:	27813483          	ld	s1,632(sp)
 142:	b7c9                	j	104 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 144:	854a                	mv	a0,s2
 146:	1a6000ef          	jal	2ec <strlen>
 14a:	2541                	addiw	a0,a0,16
 14c:	20000793          	li	a5,512
 150:	00a7f963          	bgeu	a5,a0,162 <ls+0xcc>
      printf("ls: path too long\n");
 154:	00001517          	auipc	a0,0x1
 158:	b9c50513          	addi	a0,a0,-1124 # cf0 <malloc+0x132>
 15c:	1ab000ef          	jal	b06 <printf>
      break;
 160:	bf69                	j	fa <ls+0x64>
 162:	27313423          	sd	s3,616(sp)
 166:	27413023          	sd	s4,608(sp)
 16a:	25513c23          	sd	s5,600(sp)
 16e:	25613823          	sd	s6,592(sp)
 172:	25713423          	sd	s7,584(sp)
 176:	25813023          	sd	s8,576(sp)
 17a:	23913c23          	sd	s9,568(sp)
 17e:	23a13823          	sd	s10,560(sp)
    strcpy(buf, path);
 182:	da040993          	addi	s3,s0,-608
 186:	85ca                	mv	a1,s2
 188:	854e                	mv	a0,s3
 18a:	112000ef          	jal	29c <strcpy>
    p = buf+strlen(buf);
 18e:	854e                	mv	a0,s3
 190:	15c000ef          	jal	2ec <strlen>
 194:	1502                	slli	a0,a0,0x20
 196:	9101                	srli	a0,a0,0x20
 198:	99aa                	add	s3,s3,a0
    *p++ = '/';
 19a:	00198c93          	addi	s9,s3,1
 19e:	02f00793          	li	a5,47
 1a2:	00f98023          	sb	a5,0(s3)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a6:	d9040a13          	addi	s4,s0,-624
 1aa:	4941                	li	s2,16
      memmove(p, de.name, DIRSIZ);
 1ac:	d9240c13          	addi	s8,s0,-622
 1b0:	4bb9                	li	s7,14
      if(stat(buf, &st) < 0){
 1b2:	d7840b13          	addi	s6,s0,-648
 1b6:	da040a93          	addi	s5,s0,-608
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1ba:	00001d17          	auipc	s10,0x1
 1be:	b26d0d13          	addi	s10,s10,-1242 # ce0 <malloc+0x122>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c2:	a801                	j	1d2 <ls+0x13c>
        printf("ls: cannot stat %s\n", buf);
 1c4:	85d6                	mv	a1,s5
 1c6:	00001517          	auipc	a0,0x1
 1ca:	b0250513          	addi	a0,a0,-1278 # cc8 <malloc+0x10a>
 1ce:	139000ef          	jal	b06 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1d2:	864a                	mv	a2,s2
 1d4:	85d2                	mv	a1,s4
 1d6:	8526                	mv	a0,s1
 1d8:	50c000ef          	jal	6e4 <read>
 1dc:	05251063          	bne	a0,s2,21c <ls+0x186>
      if(de.inum == 0)
 1e0:	d9045783          	lhu	a5,-624(s0)
 1e4:	d7fd                	beqz	a5,1d2 <ls+0x13c>
      memmove(p, de.name, DIRSIZ);
 1e6:	865e                	mv	a2,s7
 1e8:	85e2                	mv	a1,s8
 1ea:	8566                	mv	a0,s9
 1ec:	286000ef          	jal	472 <memmove>
      p[DIRSIZ] = 0;
 1f0:	000987a3          	sb	zero,15(s3)
      if(stat(buf, &st) < 0){
 1f4:	85da                	mv	a1,s6
 1f6:	8556                	mv	a0,s5
 1f8:	1f4000ef          	jal	3ec <stat>
 1fc:	fc0544e3          	bltz	a0,1c4 <ls+0x12e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 200:	8556                	mv	a0,s5
 202:	dffff0ef          	jal	0 <fmtname>
 206:	85aa                	mv	a1,a0
 208:	d8842703          	lw	a4,-632(s0)
 20c:	d7c42683          	lw	a3,-644(s0)
 210:	d8041603          	lh	a2,-640(s0)
 214:	856a                	mv	a0,s10
 216:	0f1000ef          	jal	b06 <printf>
 21a:	bf65                	j	1d2 <ls+0x13c>
 21c:	26813983          	ld	s3,616(sp)
 220:	26013a03          	ld	s4,608(sp)
 224:	25813a83          	ld	s5,600(sp)
 228:	25013b03          	ld	s6,592(sp)
 22c:	24813b83          	ld	s7,584(sp)
 230:	24013c03          	ld	s8,576(sp)
 234:	23813c83          	ld	s9,568(sp)
 238:	23013d03          	ld	s10,560(sp)
 23c:	bd7d                	j	fa <ls+0x64>

000000000000023e <main>:

int
main(int argc, char *argv[])
{
 23e:	1101                	addi	sp,sp,-32
 240:	ec06                	sd	ra,24(sp)
 242:	e822                	sd	s0,16(sp)
 244:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 246:	4785                	li	a5,1
 248:	02a7d763          	bge	a5,a0,276 <main+0x38>
 24c:	e426                	sd	s1,8(sp)
 24e:	e04a                	sd	s2,0(sp)
 250:	00858493          	addi	s1,a1,8
 254:	ffe5091b          	addiw	s2,a0,-2
 258:	02091793          	slli	a5,s2,0x20
 25c:	01d7d913          	srli	s2,a5,0x1d
 260:	05c1                	addi	a1,a1,16
 262:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 264:	6088                	ld	a0,0(s1)
 266:	e31ff0ef          	jal	96 <ls>
  for(i=1; i<argc; i++)
 26a:	04a1                	addi	s1,s1,8
 26c:	ff249ce3          	bne	s1,s2,264 <main+0x26>
  exit(0);
 270:	4501                	li	a0,0
 272:	45a000ef          	jal	6cc <exit>
 276:	e426                	sd	s1,8(sp)
 278:	e04a                	sd	s2,0(sp)
    ls(".");
 27a:	00001517          	auipc	a0,0x1
 27e:	a8e50513          	addi	a0,a0,-1394 # d08 <malloc+0x14a>
 282:	e15ff0ef          	jal	96 <ls>
    exit(0);
 286:	4501                	li	a0,0
 288:	444000ef          	jal	6cc <exit>

000000000000028c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 294:	fabff0ef          	jal	23e <main>
  exit(r);
 298:	434000ef          	jal	6cc <exit>

000000000000029c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a4:	87aa                	mv	a5,a0
 2a6:	0585                	addi	a1,a1,1
 2a8:	0785                	addi	a5,a5,1
 2aa:	fff5c703          	lbu	a4,-1(a1)
 2ae:	fee78fa3          	sb	a4,-1(a5)
 2b2:	fb75                	bnez	a4,2a6 <strcpy+0xa>
    ;
  return os;
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	cb91                	beqz	a5,2dc <strcmp+0x20>
 2ca:	0005c703          	lbu	a4,0(a1)
 2ce:	00f71763          	bne	a4,a5,2dc <strcmp+0x20>
    p++, q++;
 2d2:	0505                	addi	a0,a0,1
 2d4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	fbe5                	bnez	a5,2ca <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2dc:	0005c503          	lbu	a0,0(a1)
}
 2e0:	40a7853b          	subw	a0,a5,a0
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <strlen>:

uint
strlen(const char *s)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	cf99                	beqz	a5,316 <strlen+0x2a>
 2fa:	0505                	addi	a0,a0,1
 2fc:	87aa                	mv	a5,a0
 2fe:	86be                	mv	a3,a5
 300:	0785                	addi	a5,a5,1
 302:	fff7c703          	lbu	a4,-1(a5)
 306:	ff65                	bnez	a4,2fe <strlen+0x12>
 308:	40a6853b          	subw	a0,a3,a0
 30c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
  for(n = 0; s[n]; n++)
 316:	4501                	li	a0,0
 318:	bfdd                	j	30e <strlen+0x22>

000000000000031a <memset>:

void*
memset(void *dst, int c, uint n)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e406                	sd	ra,8(sp)
 31e:	e022                	sd	s0,0(sp)
 320:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 322:	ca19                	beqz	a2,338 <memset+0x1e>
 324:	87aa                	mv	a5,a0
 326:	1602                	slli	a2,a2,0x20
 328:	9201                	srli	a2,a2,0x20
 32a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 32e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 332:	0785                	addi	a5,a5,1
 334:	fee79de3          	bne	a5,a4,32e <memset+0x14>
  }
  return dst;
}
 338:	60a2                	ld	ra,8(sp)
 33a:	6402                	ld	s0,0(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret

0000000000000340 <strchr>:

char*
strchr(const char *s, char c)
{
 340:	1141                	addi	sp,sp,-16
 342:	e406                	sd	ra,8(sp)
 344:	e022                	sd	s0,0(sp)
 346:	0800                	addi	s0,sp,16
  for(; *s; s++)
 348:	00054783          	lbu	a5,0(a0)
 34c:	cf81                	beqz	a5,364 <strchr+0x24>
    if(*s == c)
 34e:	00f58763          	beq	a1,a5,35c <strchr+0x1c>
  for(; *s; s++)
 352:	0505                	addi	a0,a0,1
 354:	00054783          	lbu	a5,0(a0)
 358:	fbfd                	bnez	a5,34e <strchr+0xe>
      return (char*)s;
  return 0;
 35a:	4501                	li	a0,0
}
 35c:	60a2                	ld	ra,8(sp)
 35e:	6402                	ld	s0,0(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
  return 0;
 364:	4501                	li	a0,0
 366:	bfdd                	j	35c <strchr+0x1c>

0000000000000368 <gets>:

char*
gets(char *buf, int max)
{
 368:	7159                	addi	sp,sp,-112
 36a:	f486                	sd	ra,104(sp)
 36c:	f0a2                	sd	s0,96(sp)
 36e:	eca6                	sd	s1,88(sp)
 370:	e8ca                	sd	s2,80(sp)
 372:	e4ce                	sd	s3,72(sp)
 374:	e0d2                	sd	s4,64(sp)
 376:	fc56                	sd	s5,56(sp)
 378:	f85a                	sd	s6,48(sp)
 37a:	f45e                	sd	s7,40(sp)
 37c:	f062                	sd	s8,32(sp)
 37e:	ec66                	sd	s9,24(sp)
 380:	e86a                	sd	s10,16(sp)
 382:	1880                	addi	s0,sp,112
 384:	8caa                	mv	s9,a0
 386:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 388:	892a                	mv	s2,a0
 38a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 38c:	f9f40b13          	addi	s6,s0,-97
 390:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 392:	4ba9                	li	s7,10
 394:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 396:	8d26                	mv	s10,s1
 398:	0014899b          	addiw	s3,s1,1
 39c:	84ce                	mv	s1,s3
 39e:	0349d563          	bge	s3,s4,3c8 <gets+0x60>
    cc = read(0, &c, 1);
 3a2:	8656                	mv	a2,s5
 3a4:	85da                	mv	a1,s6
 3a6:	4501                	li	a0,0
 3a8:	33c000ef          	jal	6e4 <read>
    if(cc < 1)
 3ac:	00a05e63          	blez	a0,3c8 <gets+0x60>
    buf[i++] = c;
 3b0:	f9f44783          	lbu	a5,-97(s0)
 3b4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b8:	01778763          	beq	a5,s7,3c6 <gets+0x5e>
 3bc:	0905                	addi	s2,s2,1
 3be:	fd879ce3          	bne	a5,s8,396 <gets+0x2e>
    buf[i++] = c;
 3c2:	8d4e                	mv	s10,s3
 3c4:	a011                	j	3c8 <gets+0x60>
 3c6:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 3c8:	9d66                	add	s10,s10,s9
 3ca:	000d0023          	sb	zero,0(s10)
  return buf;
}
 3ce:	8566                	mv	a0,s9
 3d0:	70a6                	ld	ra,104(sp)
 3d2:	7406                	ld	s0,96(sp)
 3d4:	64e6                	ld	s1,88(sp)
 3d6:	6946                	ld	s2,80(sp)
 3d8:	69a6                	ld	s3,72(sp)
 3da:	6a06                	ld	s4,64(sp)
 3dc:	7ae2                	ld	s5,56(sp)
 3de:	7b42                	ld	s6,48(sp)
 3e0:	7ba2                	ld	s7,40(sp)
 3e2:	7c02                	ld	s8,32(sp)
 3e4:	6ce2                	ld	s9,24(sp)
 3e6:	6d42                	ld	s10,16(sp)
 3e8:	6165                	addi	sp,sp,112
 3ea:	8082                	ret

00000000000003ec <stat>:

int
stat(const char *n, struct stat *st)
{
 3ec:	1101                	addi	sp,sp,-32
 3ee:	ec06                	sd	ra,24(sp)
 3f0:	e822                	sd	s0,16(sp)
 3f2:	e04a                	sd	s2,0(sp)
 3f4:	1000                	addi	s0,sp,32
 3f6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f8:	4581                	li	a1,0
 3fa:	312000ef          	jal	70c <open>
  if(fd < 0)
 3fe:	02054263          	bltz	a0,422 <stat+0x36>
 402:	e426                	sd	s1,8(sp)
 404:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 406:	85ca                	mv	a1,s2
 408:	31c000ef          	jal	724 <fstat>
 40c:	892a                	mv	s2,a0
  close(fd);
 40e:	8526                	mv	a0,s1
 410:	2e4000ef          	jal	6f4 <close>
  return r;
 414:	64a2                	ld	s1,8(sp)
}
 416:	854a                	mv	a0,s2
 418:	60e2                	ld	ra,24(sp)
 41a:	6442                	ld	s0,16(sp)
 41c:	6902                	ld	s2,0(sp)
 41e:	6105                	addi	sp,sp,32
 420:	8082                	ret
    return -1;
 422:	597d                	li	s2,-1
 424:	bfcd                	j	416 <stat+0x2a>

0000000000000426 <atoi>:

int
atoi(const char *s)
{
 426:	1141                	addi	sp,sp,-16
 428:	e406                	sd	ra,8(sp)
 42a:	e022                	sd	s0,0(sp)
 42c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 42e:	00054683          	lbu	a3,0(a0)
 432:	fd06879b          	addiw	a5,a3,-48
 436:	0ff7f793          	zext.b	a5,a5
 43a:	4625                	li	a2,9
 43c:	02f66963          	bltu	a2,a5,46e <atoi+0x48>
 440:	872a                	mv	a4,a0
  n = 0;
 442:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 444:	0705                	addi	a4,a4,1
 446:	0025179b          	slliw	a5,a0,0x2
 44a:	9fa9                	addw	a5,a5,a0
 44c:	0017979b          	slliw	a5,a5,0x1
 450:	9fb5                	addw	a5,a5,a3
 452:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 456:	00074683          	lbu	a3,0(a4)
 45a:	fd06879b          	addiw	a5,a3,-48
 45e:	0ff7f793          	zext.b	a5,a5
 462:	fef671e3          	bgeu	a2,a5,444 <atoi+0x1e>
  return n;
}
 466:	60a2                	ld	ra,8(sp)
 468:	6402                	ld	s0,0(sp)
 46a:	0141                	addi	sp,sp,16
 46c:	8082                	ret
  n = 0;
 46e:	4501                	li	a0,0
 470:	bfdd                	j	466 <atoi+0x40>

0000000000000472 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 472:	1141                	addi	sp,sp,-16
 474:	e406                	sd	ra,8(sp)
 476:	e022                	sd	s0,0(sp)
 478:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 47a:	02b57563          	bgeu	a0,a1,4a4 <memmove+0x32>
    while(n-- > 0)
 47e:	00c05f63          	blez	a2,49c <memmove+0x2a>
 482:	1602                	slli	a2,a2,0x20
 484:	9201                	srli	a2,a2,0x20
 486:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 48a:	872a                	mv	a4,a0
      *dst++ = *src++;
 48c:	0585                	addi	a1,a1,1
 48e:	0705                	addi	a4,a4,1
 490:	fff5c683          	lbu	a3,-1(a1)
 494:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 498:	fee79ae3          	bne	a5,a4,48c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 49c:	60a2                	ld	ra,8(sp)
 49e:	6402                	ld	s0,0(sp)
 4a0:	0141                	addi	sp,sp,16
 4a2:	8082                	ret
    dst += n;
 4a4:	00c50733          	add	a4,a0,a2
    src += n;
 4a8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4aa:	fec059e3          	blez	a2,49c <memmove+0x2a>
 4ae:	fff6079b          	addiw	a5,a2,-1
 4b2:	1782                	slli	a5,a5,0x20
 4b4:	9381                	srli	a5,a5,0x20
 4b6:	fff7c793          	not	a5,a5
 4ba:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4bc:	15fd                	addi	a1,a1,-1
 4be:	177d                	addi	a4,a4,-1
 4c0:	0005c683          	lbu	a3,0(a1)
 4c4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4c8:	fef71ae3          	bne	a4,a5,4bc <memmove+0x4a>
 4cc:	bfc1                	j	49c <memmove+0x2a>

00000000000004ce <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ce:	1141                	addi	sp,sp,-16
 4d0:	e406                	sd	ra,8(sp)
 4d2:	e022                	sd	s0,0(sp)
 4d4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4d6:	ca0d                	beqz	a2,508 <memcmp+0x3a>
 4d8:	fff6069b          	addiw	a3,a2,-1
 4dc:	1682                	slli	a3,a3,0x20
 4de:	9281                	srli	a3,a3,0x20
 4e0:	0685                	addi	a3,a3,1
 4e2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4e4:	00054783          	lbu	a5,0(a0)
 4e8:	0005c703          	lbu	a4,0(a1)
 4ec:	00e79863          	bne	a5,a4,4fc <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 4f0:	0505                	addi	a0,a0,1
    p2++;
 4f2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4f4:	fed518e3          	bne	a0,a3,4e4 <memcmp+0x16>
  }
  return 0;
 4f8:	4501                	li	a0,0
 4fa:	a019                	j	500 <memcmp+0x32>
      return *p1 - *p2;
 4fc:	40e7853b          	subw	a0,a5,a4
}
 500:	60a2                	ld	ra,8(sp)
 502:	6402                	ld	s0,0(sp)
 504:	0141                	addi	sp,sp,16
 506:	8082                	ret
  return 0;
 508:	4501                	li	a0,0
 50a:	bfdd                	j	500 <memcmp+0x32>

000000000000050c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 50c:	1141                	addi	sp,sp,-16
 50e:	e406                	sd	ra,8(sp)
 510:	e022                	sd	s0,0(sp)
 512:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 514:	f5fff0ef          	jal	472 <memmove>
}
 518:	60a2                	ld	ra,8(sp)
 51a:	6402                	ld	s0,0(sp)
 51c:	0141                	addi	sp,sp,16
 51e:	8082                	ret

0000000000000520 <sbrk>:

char *
sbrk(int n) {
 520:	1141                	addi	sp,sp,-16
 522:	e406                	sd	ra,8(sp)
 524:	e022                	sd	s0,0(sp)
 526:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 528:	4585                	li	a1,1
 52a:	22a000ef          	jal	754 <sys_sbrk>
}
 52e:	60a2                	ld	ra,8(sp)
 530:	6402                	ld	s0,0(sp)
 532:	0141                	addi	sp,sp,16
 534:	8082                	ret

0000000000000536 <sbrklazy>:

char *
sbrklazy(int n) {
 536:	1141                	addi	sp,sp,-16
 538:	e406                	sd	ra,8(sp)
 53a:	e022                	sd	s0,0(sp)
 53c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 53e:	4589                	li	a1,2
 540:	214000ef          	jal	754 <sys_sbrk>
}
 544:	60a2                	ld	ra,8(sp)
 546:	6402                	ld	s0,0(sp)
 548:	0141                	addi	sp,sp,16
 54a:	8082                	ret

000000000000054c <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 54c:	1101                	addi	sp,sp,-32
 54e:	ec06                	sd	ra,24(sp)
 550:	e822                	sd	s0,16(sp)
 552:	e426                	sd	s1,8(sp)
 554:	e04a                	sd	s2,0(sp)
 556:	1000                	addi	s0,sp,32
 558:	84aa                	mv	s1,a0
 55a:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 55c:	6505                	lui	a0,0x1
 55e:	fc3ff0ef          	jal	520 <sbrk>
 562:	6785                	lui	a5,0x1
 564:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 568:	9a41                	andi	a2,a2,-16
 56a:	85ca                	mv	a1,s2
 56c:	8526                	mv	a0,s1
 56e:	1fe000ef          	jal	76c <clone>
}
 572:	60e2                	ld	ra,24(sp)
 574:	6442                	ld	s0,16(sp)
 576:	64a2                	ld	s1,8(sp)
 578:	6902                	ld	s2,0(sp)
 57a:	6105                	addi	sp,sp,32
 57c:	8082                	ret

000000000000057e <futex>:

void futex(int *uaddr, int ops, int val) {
 57e:	7179                	addi	sp,sp,-48
 580:	f406                	sd	ra,40(sp)
 582:	f022                	sd	s0,32(sp)
 584:	ec26                	sd	s1,24(sp)
 586:	1800                	addi	s0,sp,48
 588:	84aa                	mv	s1,a0
  if (ops==0) {
 58a:	ed95                	bnez	a1,5c6 <futex+0x48>
    if (val==0) {
 58c:	c611                	beqz	a2,598 <futex+0x1a>
 58e:	e84a                	sd	s2,16(sp)
 590:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 592:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 594:	4985                	li	s3,1
 596:	a005                	j	5b6 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 598:	4705                	li	a4,1
 59a:	87ba                	mv	a5,a4
 59c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 5a0:	2781                	sext.w	a5,a5
 5a2:	ffe5                	bnez	a5,59a <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 5a4:	70a2                	ld	ra,40(sp)
 5a6:	7402                	ld	s0,32(sp)
 5a8:	64e2                	ld	s1,24(sp)
 5aa:	6145                	addi	sp,sp,48
 5ac:	8082                	ret
        futex_wait(uaddr, 1);
 5ae:	85ce                	mv	a1,s3
 5b0:	8526                	mv	a0,s1
 5b2:	1ca000ef          	jal	77c <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 5b6:	87ca                	mv	a5,s2
 5b8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 5bc:	2781                	sext.w	a5,a5
 5be:	fbe5                	bnez	a5,5ae <futex+0x30>
 5c0:	6942                	ld	s2,16(sp)
 5c2:	69a2                	ld	s3,8(sp)
 5c4:	b7c5                	j	5a4 <futex+0x26>
    if (val==0) {
 5c6:	e611                	bnez	a2,5d2 <futex+0x54>
      __sync_lock_release(uaddr);
 5c8:	0310000f          	fence	rw,w
 5cc:	00052023          	sw	zero,0(a0) # 1000 <freep>
 5d0:	bfd1                	j	5a4 <futex+0x26>
      __sync_lock_release(uaddr);
 5d2:	0310000f          	fence	rw,w
 5d6:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 5da:	1aa000ef          	jal	784 <futex_wake>
  return;
 5de:	b7d9                	j	5a4 <futex+0x26>

00000000000005e0 <sem_init>:

void sem_init(sem_t* s, int val) {
 5e0:	7179                	addi	sp,sp,-48
 5e2:	f406                	sd	ra,40(sp)
 5e4:	f022                	sd	s0,32(sp)
 5e6:	ec26                	sd	s1,24(sp)
 5e8:	e84a                	sd	s2,16(sp)
 5ea:	e44e                	sd	s3,8(sp)
 5ec:	1800                	addi	s0,sp,48
 5ee:	84aa                	mv	s1,a0
 5f0:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 5f2:	00450993          	addi	s3,a0,4
 5f6:	4605                	li	a2,1
 5f8:	4581                	li	a1,0
 5fa:	854e                	mv	a0,s3
 5fc:	f83ff0ef          	jal	57e <futex>
  s->value = val;
 600:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 604:	4605                	li	a2,1
 606:	85b2                	mv	a1,a2
 608:	854e                	mv	a0,s3
 60a:	f75ff0ef          	jal	57e <futex>
  return;
}
 60e:	70a2                	ld	ra,40(sp)
 610:	7402                	ld	s0,32(sp)
 612:	64e2                	ld	s1,24(sp)
 614:	6942                	ld	s2,16(sp)
 616:	69a2                	ld	s3,8(sp)
 618:	6145                	addi	sp,sp,48
 61a:	8082                	ret

000000000000061c <sem_down>:

void sem_down(sem_t* s) {
 61c:	7179                	addi	sp,sp,-48
 61e:	f406                	sd	ra,40(sp)
 620:	f022                	sd	s0,32(sp)
 622:	ec26                	sd	s1,24(sp)
 624:	e84a                	sd	s2,16(sp)
 626:	e44e                	sd	s3,8(sp)
 628:	1800                	addi	s0,sp,48
 62a:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 62c:	00450993          	addi	s3,a0,4
 630:	4605                	li	a2,1
 632:	4581                	li	a1,0
 634:	854e                	mv	a0,s3
 636:	f49ff0ef          	jal	57e <futex>
  while(1) {
    if (s->value>0) {
 63a:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 63e:	4485                	li	s1,1
    if (s->value>0) {
 640:	02f04463          	bgtz	a5,668 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 644:	8626                	mv	a2,s1
 646:	85a6                	mv	a1,s1
 648:	854e                	mv	a0,s3
 64a:	f35ff0ef          	jal	57e <futex>
      futex_wait(&s->value,1);
 64e:	85a6                	mv	a1,s1
 650:	854a                	mv	a0,s2
 652:	12a000ef          	jal	77c <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 656:	8626                	mv	a2,s1
 658:	4581                	li	a1,0
 65a:	854e                	mv	a0,s3
 65c:	f23ff0ef          	jal	57e <futex>
    if (s->value>0) {
 660:	00092783          	lw	a5,0(s2)
 664:	fef050e3          	blez	a5,644 <sem_down+0x28>
      s->value--;
 668:	37fd                	addiw	a5,a5,-1 # fff <digits+0x2e7>
 66a:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 66e:	4605                	li	a2,1
 670:	85b2                	mv	a1,a2
 672:	854e                	mv	a0,s3
 674:	f0bff0ef          	jal	57e <futex>
  return;
}
 678:	70a2                	ld	ra,40(sp)
 67a:	7402                	ld	s0,32(sp)
 67c:	64e2                	ld	s1,24(sp)
 67e:	6942                	ld	s2,16(sp)
 680:	69a2                	ld	s3,8(sp)
 682:	6145                	addi	sp,sp,48
 684:	8082                	ret

0000000000000686 <sem_up>:

void sem_up(sem_t* s) {
 686:	1101                	addi	sp,sp,-32
 688:	ec06                	sd	ra,24(sp)
 68a:	e822                	sd	s0,16(sp)
 68c:	e426                	sd	s1,8(sp)
 68e:	e04a                	sd	s2,0(sp)
 690:	1000                	addi	s0,sp,32
 692:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 694:	00450913          	addi	s2,a0,4
 698:	4605                	li	a2,1
 69a:	4581                	li	a1,0
 69c:	854a                	mv	a0,s2
 69e:	ee1ff0ef          	jal	57e <futex>
  s->value++;
 6a2:	409c                	lw	a5,0(s1)
 6a4:	2785                	addiw	a5,a5,1
 6a6:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 6a8:	8526                	mv	a0,s1
 6aa:	0da000ef          	jal	784 <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 6ae:	4605                	li	a2,1
 6b0:	85b2                	mv	a1,a2
 6b2:	854a                	mv	a0,s2
 6b4:	ecbff0ef          	jal	57e <futex>
  return;
 6b8:	60e2                	ld	ra,24(sp)
 6ba:	6442                	ld	s0,16(sp)
 6bc:	64a2                	ld	s1,8(sp)
 6be:	6902                	ld	s2,0(sp)
 6c0:	6105                	addi	sp,sp,32
 6c2:	8082                	ret

00000000000006c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6c4:	4885                	li	a7,1
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <exit>:
.global exit
exit:
 li a7, SYS_exit
 6cc:	4889                	li	a7,2
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6d4:	488d                	li	a7,3
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6dc:	4891                	li	a7,4
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <read>:
.global read
read:
 li a7, SYS_read
 6e4:	4895                	li	a7,5
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <write>:
.global write
write:
 li a7, SYS_write
 6ec:	48c1                	li	a7,16
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <close>:
.global close
close:
 li a7, SYS_close
 6f4:	48d5                	li	a7,21
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <kill>:
.global kill
kill:
 li a7, SYS_kill
 6fc:	4899                	li	a7,6
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <exec>:
.global exec
exec:
 li a7, SYS_exec
 704:	489d                	li	a7,7
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <open>:
.global open
open:
 li a7, SYS_open
 70c:	48bd                	li	a7,15
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 714:	48c5                	li	a7,17
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 71c:	48c9                	li	a7,18
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 724:	48a1                	li	a7,8
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <link>:
.global link
link:
 li a7, SYS_link
 72c:	48cd                	li	a7,19
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 734:	48d1                	li	a7,20
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 73c:	48a5                	li	a7,9
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <dup>:
.global dup
dup:
 li a7, SYS_dup
 744:	48a9                	li	a7,10
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 74c:	48ad                	li	a7,11
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 754:	48b1                	li	a7,12
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <pause>:
.global pause
pause:
 li a7, SYS_pause
 75c:	48b5                	li	a7,13
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 764:	48b9                	li	a7,14
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <clone>:
.global clone
clone:
 li a7, SYS_clone
 76c:	48d9                	li	a7,22
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <join>:
.global join
join:
 li a7, SYS_join
 774:	48dd                	li	a7,23
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 77c:	48e1                	li	a7,24
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 784:	48e5                	li	a7,25
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 78c:	1101                	addi	sp,sp,-32
 78e:	ec06                	sd	ra,24(sp)
 790:	e822                	sd	s0,16(sp)
 792:	1000                	addi	s0,sp,32
 794:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 798:	4605                	li	a2,1
 79a:	fef40593          	addi	a1,s0,-17
 79e:	f4fff0ef          	jal	6ec <write>
}
 7a2:	60e2                	ld	ra,24(sp)
 7a4:	6442                	ld	s0,16(sp)
 7a6:	6105                	addi	sp,sp,32
 7a8:	8082                	ret

00000000000007aa <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 7aa:	715d                	addi	sp,sp,-80
 7ac:	e486                	sd	ra,72(sp)
 7ae:	e0a2                	sd	s0,64(sp)
 7b0:	fc26                	sd	s1,56(sp)
 7b2:	f84a                	sd	s2,48(sp)
 7b4:	f44e                	sd	s3,40(sp)
 7b6:	0880                	addi	s0,sp,80
 7b8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 7ba:	c299                	beqz	a3,7c0 <printint+0x16>
 7bc:	0605cc63          	bltz	a1,834 <printint+0x8a>
  neg = 0;
 7c0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 7c2:	fb840313          	addi	t1,s0,-72
  neg = 0;
 7c6:	869a                	mv	a3,t1
  i = 0;
 7c8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 7ca:	00000817          	auipc	a6,0x0
 7ce:	54e80813          	addi	a6,a6,1358 # d18 <digits>
 7d2:	88be                	mv	a7,a5
 7d4:	0017851b          	addiw	a0,a5,1
 7d8:	87aa                	mv	a5,a0
 7da:	02c5f733          	remu	a4,a1,a2
 7de:	9742                	add	a4,a4,a6
 7e0:	00074703          	lbu	a4,0(a4)
 7e4:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 7e8:	872e                	mv	a4,a1
 7ea:	02c5d5b3          	divu	a1,a1,a2
 7ee:	0685                	addi	a3,a3,1
 7f0:	fec771e3          	bgeu	a4,a2,7d2 <printint+0x28>
  if(neg)
 7f4:	000e0c63          	beqz	t3,80c <printint+0x62>
    buf[i++] = '-';
 7f8:	fd050793          	addi	a5,a0,-48
 7fc:	00878533          	add	a0,a5,s0
 800:	02d00793          	li	a5,45
 804:	fef50423          	sb	a5,-24(a0)
 808:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 80c:	fff7899b          	addiw	s3,a5,-1
 810:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 814:	fff4c583          	lbu	a1,-1(s1)
 818:	854a                	mv	a0,s2
 81a:	f73ff0ef          	jal	78c <putc>
  while(--i >= 0)
 81e:	39fd                	addiw	s3,s3,-1
 820:	14fd                	addi	s1,s1,-1
 822:	fe09d9e3          	bgez	s3,814 <printint+0x6a>
}
 826:	60a6                	ld	ra,72(sp)
 828:	6406                	ld	s0,64(sp)
 82a:	74e2                	ld	s1,56(sp)
 82c:	7942                	ld	s2,48(sp)
 82e:	79a2                	ld	s3,40(sp)
 830:	6161                	addi	sp,sp,80
 832:	8082                	ret
    x = -xx;
 834:	40b005b3          	neg	a1,a1
    neg = 1;
 838:	4e05                	li	t3,1
    x = -xx;
 83a:	b761                	j	7c2 <printint+0x18>

000000000000083c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 83c:	711d                	addi	sp,sp,-96
 83e:	ec86                	sd	ra,88(sp)
 840:	e8a2                	sd	s0,80(sp)
 842:	e4a6                	sd	s1,72(sp)
 844:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 846:	0005c483          	lbu	s1,0(a1)
 84a:	28048463          	beqz	s1,ad2 <vprintf+0x296>
 84e:	e0ca                	sd	s2,64(sp)
 850:	fc4e                	sd	s3,56(sp)
 852:	f852                	sd	s4,48(sp)
 854:	f456                	sd	s5,40(sp)
 856:	f05a                	sd	s6,32(sp)
 858:	ec5e                	sd	s7,24(sp)
 85a:	e862                	sd	s8,16(sp)
 85c:	e466                	sd	s9,8(sp)
 85e:	8b2a                	mv	s6,a0
 860:	8a2e                	mv	s4,a1
 862:	8bb2                	mv	s7,a2
  state = 0;
 864:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 866:	4901                	li	s2,0
 868:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 86a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 86e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 872:	06c00c93          	li	s9,108
 876:	a00d                	j	898 <vprintf+0x5c>
        putc(fd, c0);
 878:	85a6                	mv	a1,s1
 87a:	855a                	mv	a0,s6
 87c:	f11ff0ef          	jal	78c <putc>
 880:	a019                	j	886 <vprintf+0x4a>
    } else if(state == '%'){
 882:	03598363          	beq	s3,s5,8a8 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 886:	0019079b          	addiw	a5,s2,1
 88a:	893e                	mv	s2,a5
 88c:	873e                	mv	a4,a5
 88e:	97d2                	add	a5,a5,s4
 890:	0007c483          	lbu	s1,0(a5)
 894:	22048763          	beqz	s1,ac2 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 898:	0004879b          	sext.w	a5,s1
    if(state == 0){
 89c:	fe0993e3          	bnez	s3,882 <vprintf+0x46>
      if(c0 == '%'){
 8a0:	fd579ce3          	bne	a5,s5,878 <vprintf+0x3c>
        state = '%';
 8a4:	89be                	mv	s3,a5
 8a6:	b7c5                	j	886 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 8a8:	00ea06b3          	add	a3,s4,a4
 8ac:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 8b0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 8b2:	c681                	beqz	a3,8ba <vprintf+0x7e>
 8b4:	9752                	add	a4,a4,s4
 8b6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 8ba:	05878263          	beq	a5,s8,8fe <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 8be:	05978c63          	beq	a5,s9,916 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 8c2:	07500713          	li	a4,117
 8c6:	0ee78663          	beq	a5,a4,9b2 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 8ca:	07800713          	li	a4,120
 8ce:	12e78863          	beq	a5,a4,9fe <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 8d2:	07000713          	li	a4,112
 8d6:	14e78d63          	beq	a5,a4,a30 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 8da:	06300713          	li	a4,99
 8de:	18e78c63          	beq	a5,a4,a76 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 8e2:	07300713          	li	a4,115
 8e6:	1ae78263          	beq	a5,a4,a8a <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 8ea:	02500713          	li	a4,37
 8ee:	04e79463          	bne	a5,a4,936 <vprintf+0xfa>
        putc(fd, '%');
 8f2:	85ba                	mv	a1,a4
 8f4:	855a                	mv	a0,s6
 8f6:	e97ff0ef          	jal	78c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 8fa:	4981                	li	s3,0
 8fc:	b769                	j	886 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 8fe:	008b8493          	addi	s1,s7,8
 902:	4685                	li	a3,1
 904:	4629                	li	a2,10
 906:	000ba583          	lw	a1,0(s7)
 90a:	855a                	mv	a0,s6
 90c:	e9fff0ef          	jal	7aa <printint>
 910:	8ba6                	mv	s7,s1
      state = 0;
 912:	4981                	li	s3,0
 914:	bf8d                	j	886 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 916:	06400793          	li	a5,100
 91a:	02f68963          	beq	a3,a5,94c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 91e:	06c00793          	li	a5,108
 922:	04f68263          	beq	a3,a5,966 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 926:	07500793          	li	a5,117
 92a:	0af68063          	beq	a3,a5,9ca <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 92e:	07800793          	li	a5,120
 932:	0ef68263          	beq	a3,a5,a16 <vprintf+0x1da>
        putc(fd, '%');
 936:	02500593          	li	a1,37
 93a:	855a                	mv	a0,s6
 93c:	e51ff0ef          	jal	78c <putc>
        putc(fd, c0);
 940:	85a6                	mv	a1,s1
 942:	855a                	mv	a0,s6
 944:	e49ff0ef          	jal	78c <putc>
      state = 0;
 948:	4981                	li	s3,0
 94a:	bf35                	j	886 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 94c:	008b8493          	addi	s1,s7,8
 950:	4685                	li	a3,1
 952:	4629                	li	a2,10
 954:	000bb583          	ld	a1,0(s7)
 958:	855a                	mv	a0,s6
 95a:	e51ff0ef          	jal	7aa <printint>
        i += 1;
 95e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 960:	8ba6                	mv	s7,s1
      state = 0;
 962:	4981                	li	s3,0
        i += 1;
 964:	b70d                	j	886 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 966:	06400793          	li	a5,100
 96a:	02f60763          	beq	a2,a5,998 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 96e:	07500793          	li	a5,117
 972:	06f60963          	beq	a2,a5,9e4 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 976:	07800793          	li	a5,120
 97a:	faf61ee3          	bne	a2,a5,936 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 97e:	008b8493          	addi	s1,s7,8
 982:	4681                	li	a3,0
 984:	4641                	li	a2,16
 986:	000bb583          	ld	a1,0(s7)
 98a:	855a                	mv	a0,s6
 98c:	e1fff0ef          	jal	7aa <printint>
        i += 2;
 990:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 992:	8ba6                	mv	s7,s1
      state = 0;
 994:	4981                	li	s3,0
        i += 2;
 996:	bdc5                	j	886 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 998:	008b8493          	addi	s1,s7,8
 99c:	4685                	li	a3,1
 99e:	4629                	li	a2,10
 9a0:	000bb583          	ld	a1,0(s7)
 9a4:	855a                	mv	a0,s6
 9a6:	e05ff0ef          	jal	7aa <printint>
        i += 2;
 9aa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 9ac:	8ba6                	mv	s7,s1
      state = 0;
 9ae:	4981                	li	s3,0
        i += 2;
 9b0:	bdd9                	j	886 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 9b2:	008b8493          	addi	s1,s7,8
 9b6:	4681                	li	a3,0
 9b8:	4629                	li	a2,10
 9ba:	000be583          	lwu	a1,0(s7)
 9be:	855a                	mv	a0,s6
 9c0:	debff0ef          	jal	7aa <printint>
 9c4:	8ba6                	mv	s7,s1
      state = 0;
 9c6:	4981                	li	s3,0
 9c8:	bd7d                	j	886 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9ca:	008b8493          	addi	s1,s7,8
 9ce:	4681                	li	a3,0
 9d0:	4629                	li	a2,10
 9d2:	000bb583          	ld	a1,0(s7)
 9d6:	855a                	mv	a0,s6
 9d8:	dd3ff0ef          	jal	7aa <printint>
        i += 1;
 9dc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 9de:	8ba6                	mv	s7,s1
      state = 0;
 9e0:	4981                	li	s3,0
        i += 1;
 9e2:	b555                	j	886 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9e4:	008b8493          	addi	s1,s7,8
 9e8:	4681                	li	a3,0
 9ea:	4629                	li	a2,10
 9ec:	000bb583          	ld	a1,0(s7)
 9f0:	855a                	mv	a0,s6
 9f2:	db9ff0ef          	jal	7aa <printint>
        i += 2;
 9f6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 9f8:	8ba6                	mv	s7,s1
      state = 0;
 9fa:	4981                	li	s3,0
        i += 2;
 9fc:	b569                	j	886 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 9fe:	008b8493          	addi	s1,s7,8
 a02:	4681                	li	a3,0
 a04:	4641                	li	a2,16
 a06:	000be583          	lwu	a1,0(s7)
 a0a:	855a                	mv	a0,s6
 a0c:	d9fff0ef          	jal	7aa <printint>
 a10:	8ba6                	mv	s7,s1
      state = 0;
 a12:	4981                	li	s3,0
 a14:	bd8d                	j	886 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a16:	008b8493          	addi	s1,s7,8
 a1a:	4681                	li	a3,0
 a1c:	4641                	li	a2,16
 a1e:	000bb583          	ld	a1,0(s7)
 a22:	855a                	mv	a0,s6
 a24:	d87ff0ef          	jal	7aa <printint>
        i += 1;
 a28:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a2a:	8ba6                	mv	s7,s1
      state = 0;
 a2c:	4981                	li	s3,0
        i += 1;
 a2e:	bda1                	j	886 <vprintf+0x4a>
 a30:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 a32:	008b8d13          	addi	s10,s7,8
 a36:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a3a:	03000593          	li	a1,48
 a3e:	855a                	mv	a0,s6
 a40:	d4dff0ef          	jal	78c <putc>
  putc(fd, 'x');
 a44:	07800593          	li	a1,120
 a48:	855a                	mv	a0,s6
 a4a:	d43ff0ef          	jal	78c <putc>
 a4e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a50:	00000b97          	auipc	s7,0x0
 a54:	2c8b8b93          	addi	s7,s7,712 # d18 <digits>
 a58:	03c9d793          	srli	a5,s3,0x3c
 a5c:	97de                	add	a5,a5,s7
 a5e:	0007c583          	lbu	a1,0(a5)
 a62:	855a                	mv	a0,s6
 a64:	d29ff0ef          	jal	78c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a68:	0992                	slli	s3,s3,0x4
 a6a:	34fd                	addiw	s1,s1,-1
 a6c:	f4f5                	bnez	s1,a58 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 a6e:	8bea                	mv	s7,s10
      state = 0;
 a70:	4981                	li	s3,0
 a72:	6d02                	ld	s10,0(sp)
 a74:	bd09                	j	886 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 a76:	008b8493          	addi	s1,s7,8
 a7a:	000bc583          	lbu	a1,0(s7)
 a7e:	855a                	mv	a0,s6
 a80:	d0dff0ef          	jal	78c <putc>
 a84:	8ba6                	mv	s7,s1
      state = 0;
 a86:	4981                	li	s3,0
 a88:	bbfd                	j	886 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 a8a:	008b8993          	addi	s3,s7,8
 a8e:	000bb483          	ld	s1,0(s7)
 a92:	cc91                	beqz	s1,aae <vprintf+0x272>
        for(; *s; s++)
 a94:	0004c583          	lbu	a1,0(s1)
 a98:	c195                	beqz	a1,abc <vprintf+0x280>
          putc(fd, *s);
 a9a:	855a                	mv	a0,s6
 a9c:	cf1ff0ef          	jal	78c <putc>
        for(; *s; s++)
 aa0:	0485                	addi	s1,s1,1
 aa2:	0004c583          	lbu	a1,0(s1)
 aa6:	f9f5                	bnez	a1,a9a <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 aa8:	8bce                	mv	s7,s3
      state = 0;
 aaa:	4981                	li	s3,0
 aac:	bbe9                	j	886 <vprintf+0x4a>
          s = "(null)";
 aae:	00000497          	auipc	s1,0x0
 ab2:	26248493          	addi	s1,s1,610 # d10 <malloc+0x152>
        for(; *s; s++)
 ab6:	02800593          	li	a1,40
 aba:	b7c5                	j	a9a <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 abc:	8bce                	mv	s7,s3
      state = 0;
 abe:	4981                	li	s3,0
 ac0:	b3d9                	j	886 <vprintf+0x4a>
 ac2:	6906                	ld	s2,64(sp)
 ac4:	79e2                	ld	s3,56(sp)
 ac6:	7a42                	ld	s4,48(sp)
 ac8:	7aa2                	ld	s5,40(sp)
 aca:	7b02                	ld	s6,32(sp)
 acc:	6be2                	ld	s7,24(sp)
 ace:	6c42                	ld	s8,16(sp)
 ad0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 ad2:	60e6                	ld	ra,88(sp)
 ad4:	6446                	ld	s0,80(sp)
 ad6:	64a6                	ld	s1,72(sp)
 ad8:	6125                	addi	sp,sp,96
 ada:	8082                	ret

0000000000000adc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 adc:	715d                	addi	sp,sp,-80
 ade:	ec06                	sd	ra,24(sp)
 ae0:	e822                	sd	s0,16(sp)
 ae2:	1000                	addi	s0,sp,32
 ae4:	e010                	sd	a2,0(s0)
 ae6:	e414                	sd	a3,8(s0)
 ae8:	e818                	sd	a4,16(s0)
 aea:	ec1c                	sd	a5,24(s0)
 aec:	03043023          	sd	a6,32(s0)
 af0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 af4:	8622                	mv	a2,s0
 af6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 afa:	d43ff0ef          	jal	83c <vprintf>
}
 afe:	60e2                	ld	ra,24(sp)
 b00:	6442                	ld	s0,16(sp)
 b02:	6161                	addi	sp,sp,80
 b04:	8082                	ret

0000000000000b06 <printf>:

void
printf(const char *fmt, ...)
{
 b06:	711d                	addi	sp,sp,-96
 b08:	ec06                	sd	ra,24(sp)
 b0a:	e822                	sd	s0,16(sp)
 b0c:	1000                	addi	s0,sp,32
 b0e:	e40c                	sd	a1,8(s0)
 b10:	e810                	sd	a2,16(s0)
 b12:	ec14                	sd	a3,24(s0)
 b14:	f018                	sd	a4,32(s0)
 b16:	f41c                	sd	a5,40(s0)
 b18:	03043823          	sd	a6,48(s0)
 b1c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b20:	00840613          	addi	a2,s0,8
 b24:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b28:	85aa                	mv	a1,a0
 b2a:	4505                	li	a0,1
 b2c:	d11ff0ef          	jal	83c <vprintf>
}
 b30:	60e2                	ld	ra,24(sp)
 b32:	6442                	ld	s0,16(sp)
 b34:	6125                	addi	sp,sp,96
 b36:	8082                	ret

0000000000000b38 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b38:	1141                	addi	sp,sp,-16
 b3a:	e406                	sd	ra,8(sp)
 b3c:	e022                	sd	s0,0(sp)
 b3e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b40:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b44:	00000797          	auipc	a5,0x0
 b48:	4bc7b783          	ld	a5,1212(a5) # 1000 <freep>
 b4c:	a02d                	j	b76 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b4e:	4618                	lw	a4,8(a2)
 b50:	9f2d                	addw	a4,a4,a1
 b52:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b56:	6398                	ld	a4,0(a5)
 b58:	6310                	ld	a2,0(a4)
 b5a:	a83d                	j	b98 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b5c:	ff852703          	lw	a4,-8(a0)
 b60:	9f31                	addw	a4,a4,a2
 b62:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b64:	ff053683          	ld	a3,-16(a0)
 b68:	a091                	j	bac <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b6a:	6398                	ld	a4,0(a5)
 b6c:	00e7e463          	bltu	a5,a4,b74 <free+0x3c>
 b70:	00e6ea63          	bltu	a3,a4,b84 <free+0x4c>
{
 b74:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b76:	fed7fae3          	bgeu	a5,a3,b6a <free+0x32>
 b7a:	6398                	ld	a4,0(a5)
 b7c:	00e6e463          	bltu	a3,a4,b84 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b80:	fee7eae3          	bltu	a5,a4,b74 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 b84:	ff852583          	lw	a1,-8(a0)
 b88:	6390                	ld	a2,0(a5)
 b8a:	02059813          	slli	a6,a1,0x20
 b8e:	01c85713          	srli	a4,a6,0x1c
 b92:	9736                	add	a4,a4,a3
 b94:	fae60de3          	beq	a2,a4,b4e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 b98:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b9c:	4790                	lw	a2,8(a5)
 b9e:	02061593          	slli	a1,a2,0x20
 ba2:	01c5d713          	srli	a4,a1,0x1c
 ba6:	973e                	add	a4,a4,a5
 ba8:	fae68ae3          	beq	a3,a4,b5c <free+0x24>
    p->s.ptr = bp->s.ptr;
 bac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bae:	00000717          	auipc	a4,0x0
 bb2:	44f73923          	sd	a5,1106(a4) # 1000 <freep>
}
 bb6:	60a2                	ld	ra,8(sp)
 bb8:	6402                	ld	s0,0(sp)
 bba:	0141                	addi	sp,sp,16
 bbc:	8082                	ret

0000000000000bbe <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 bbe:	7139                	addi	sp,sp,-64
 bc0:	fc06                	sd	ra,56(sp)
 bc2:	f822                	sd	s0,48(sp)
 bc4:	f04a                	sd	s2,32(sp)
 bc6:	ec4e                	sd	s3,24(sp)
 bc8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bca:	02051993          	slli	s3,a0,0x20
 bce:	0209d993          	srli	s3,s3,0x20
 bd2:	09bd                	addi	s3,s3,15
 bd4:	0049d993          	srli	s3,s3,0x4
 bd8:	2985                	addiw	s3,s3,1
 bda:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 bdc:	00000517          	auipc	a0,0x0
 be0:	42453503          	ld	a0,1060(a0) # 1000 <freep>
 be4:	c905                	beqz	a0,c14 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 be6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 be8:	4798                	lw	a4,8(a5)
 bea:	09377663          	bgeu	a4,s3,c76 <malloc+0xb8>
 bee:	f426                	sd	s1,40(sp)
 bf0:	e852                	sd	s4,16(sp)
 bf2:	e456                	sd	s5,8(sp)
 bf4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 bf6:	8a4e                	mv	s4,s3
 bf8:	6705                	lui	a4,0x1
 bfa:	00e9f363          	bgeu	s3,a4,c00 <malloc+0x42>
 bfe:	6a05                	lui	s4,0x1
 c00:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c04:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c08:	00000497          	auipc	s1,0x0
 c0c:	3f848493          	addi	s1,s1,1016 # 1000 <freep>
  if(p == SBRK_ERROR)
 c10:	5afd                	li	s5,-1
 c12:	a83d                	j	c50 <malloc+0x92>
 c14:	f426                	sd	s1,40(sp)
 c16:	e852                	sd	s4,16(sp)
 c18:	e456                	sd	s5,8(sp)
 c1a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c1c:	00000797          	auipc	a5,0x0
 c20:	40478793          	addi	a5,a5,1028 # 1020 <base>
 c24:	00000717          	auipc	a4,0x0
 c28:	3cf73e23          	sd	a5,988(a4) # 1000 <freep>
 c2c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c2e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c32:	b7d1                	j	bf6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 c34:	6398                	ld	a4,0(a5)
 c36:	e118                	sd	a4,0(a0)
 c38:	a899                	j	c8e <malloc+0xd0>
  hp->s.size = nu;
 c3a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c3e:	0541                	addi	a0,a0,16
 c40:	ef9ff0ef          	jal	b38 <free>
  return freep;
 c44:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 c46:	c125                	beqz	a0,ca6 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c48:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c4a:	4798                	lw	a4,8(a5)
 c4c:	03277163          	bgeu	a4,s2,c6e <malloc+0xb0>
    if(p == freep)
 c50:	6098                	ld	a4,0(s1)
 c52:	853e                	mv	a0,a5
 c54:	fef71ae3          	bne	a4,a5,c48 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 c58:	8552                	mv	a0,s4
 c5a:	8c7ff0ef          	jal	520 <sbrk>
  if(p == SBRK_ERROR)
 c5e:	fd551ee3          	bne	a0,s5,c3a <malloc+0x7c>
        return 0;
 c62:	4501                	li	a0,0
 c64:	74a2                	ld	s1,40(sp)
 c66:	6a42                	ld	s4,16(sp)
 c68:	6aa2                	ld	s5,8(sp)
 c6a:	6b02                	ld	s6,0(sp)
 c6c:	a03d                	j	c9a <malloc+0xdc>
 c6e:	74a2                	ld	s1,40(sp)
 c70:	6a42                	ld	s4,16(sp)
 c72:	6aa2                	ld	s5,8(sp)
 c74:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 c76:	fae90fe3          	beq	s2,a4,c34 <malloc+0x76>
        p->s.size -= nunits;
 c7a:	4137073b          	subw	a4,a4,s3
 c7e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c80:	02071693          	slli	a3,a4,0x20
 c84:	01c6d713          	srli	a4,a3,0x1c
 c88:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c8a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c8e:	00000717          	auipc	a4,0x0
 c92:	36a73923          	sd	a0,882(a4) # 1000 <freep>
      return (void*)(p + 1);
 c96:	01078513          	addi	a0,a5,16
  }
}
 c9a:	70e2                	ld	ra,56(sp)
 c9c:	7442                	ld	s0,48(sp)
 c9e:	7902                	ld	s2,32(sp)
 ca0:	69e2                	ld	s3,24(sp)
 ca2:	6121                	addi	sp,sp,64
 ca4:	8082                	ret
 ca6:	74a2                	ld	s1,40(sp)
 ca8:	6a42                	ld	s4,16(sp)
 caa:	6aa2                	ld	s5,8(sp)
 cac:	6b02                	ld	s6,0(sp)
 cae:	b7f5                	j	c9a <malloc+0xdc>
