
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
  ac:	51a000ef          	jal	5c6 <open>
  b0:	06054363          	bltz	a0,116 <ls+0x80>
  b4:	26913c23          	sd	s1,632(sp)
  b8:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  ba:	d7840593          	addi	a1,s0,-648
  be:	520000ef          	jal	5de <fstat>
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
  f2:	aa250513          	addi	a0,a0,-1374 # b90 <malloc+0x128>
  f6:	0bb000ef          	jal	9b0 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  fa:	8526                	mv	a0,s1
  fc:	4b2000ef          	jal	5ae <close>
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
 11c:	a4858593          	addi	a1,a1,-1464 # b60 <malloc+0xf8>
 120:	4509                	li	a0,2
 122:	065000ef          	jal	986 <fprintf>
    return;
 126:	bff9                	j	104 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 128:	864a                	mv	a2,s2
 12a:	00001597          	auipc	a1,0x1
 12e:	a4e58593          	addi	a1,a1,-1458 # b78 <malloc+0x110>
 132:	4509                	li	a0,2
 134:	053000ef          	jal	986 <fprintf>
    close(fd);
 138:	8526                	mv	a0,s1
 13a:	474000ef          	jal	5ae <close>
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
 158:	a4c50513          	addi	a0,a0,-1460 # ba0 <malloc+0x138>
 15c:	055000ef          	jal	9b0 <printf>
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
 1be:	9d6d0d13          	addi	s10,s10,-1578 # b90 <malloc+0x128>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c2:	a801                	j	1d2 <ls+0x13c>
        printf("ls: cannot stat %s\n", buf);
 1c4:	85d6                	mv	a1,s5
 1c6:	00001517          	auipc	a0,0x1
 1ca:	9b250513          	addi	a0,a0,-1614 # b78 <malloc+0x110>
 1ce:	7e2000ef          	jal	9b0 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1d2:	864a                	mv	a2,s2
 1d4:	85d2                	mv	a1,s4
 1d6:	8526                	mv	a0,s1
 1d8:	3c6000ef          	jal	59e <read>
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
 216:	79a000ef          	jal	9b0 <printf>
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
 272:	314000ef          	jal	586 <exit>
 276:	e426                	sd	s1,8(sp)
 278:	e04a                	sd	s2,0(sp)
    ls(".");
 27a:	00001517          	auipc	a0,0x1
 27e:	93e50513          	addi	a0,a0,-1730 # bb8 <malloc+0x150>
 282:	e15ff0ef          	jal	96 <ls>
    exit(0);
 286:	4501                	li	a0,0
 288:	2fe000ef          	jal	586 <exit>

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
 298:	2ee000ef          	jal	586 <exit>

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
 3a8:	1f6000ef          	jal	59e <read>
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
 3fa:	1cc000ef          	jal	5c6 <open>
  if(fd < 0)
 3fe:	02054263          	bltz	a0,422 <stat+0x36>
 402:	e426                	sd	s1,8(sp)
 404:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 406:	85ca                	mv	a1,s2
 408:	1d6000ef          	jal	5de <fstat>
 40c:	892a                	mv	s2,a0
  close(fd);
 40e:	8526                	mv	a0,s1
 410:	19e000ef          	jal	5ae <close>
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
 52a:	0e4000ef          	jal	60e <sys_sbrk>
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
 540:	0ce000ef          	jal	60e <sys_sbrk>
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
 56e:	0b8000ef          	jal	626 <clone>
 572:	60e2                	ld	ra,24(sp)
 574:	6442                	ld	s0,16(sp)
 576:	64a2                	ld	s1,8(sp)
 578:	6902                	ld	s2,0(sp)
 57a:	6105                	addi	sp,sp,32
 57c:	8082                	ret

000000000000057e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 57e:	4885                	li	a7,1
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <exit>:
.global exit
exit:
 li a7, SYS_exit
 586:	4889                	li	a7,2
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <wait>:
.global wait
wait:
 li a7, SYS_wait
 58e:	488d                	li	a7,3
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 596:	4891                	li	a7,4
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <read>:
.global read
read:
 li a7, SYS_read
 59e:	4895                	li	a7,5
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <write>:
.global write
write:
 li a7, SYS_write
 5a6:	48c1                	li	a7,16
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <close>:
.global close
close:
 li a7, SYS_close
 5ae:	48d5                	li	a7,21
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5b6:	4899                	li	a7,6
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <exec>:
.global exec
exec:
 li a7, SYS_exec
 5be:	489d                	li	a7,7
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <open>:
.global open
open:
 li a7, SYS_open
 5c6:	48bd                	li	a7,15
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5ce:	48c5                	li	a7,17
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5d6:	48c9                	li	a7,18
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5de:	48a1                	li	a7,8
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <link>:
.global link
link:
 li a7, SYS_link
 5e6:	48cd                	li	a7,19
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ee:	48d1                	li	a7,20
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5f6:	48a5                	li	a7,9
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <dup>:
.global dup
dup:
 li a7, SYS_dup
 5fe:	48a9                	li	a7,10
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 606:	48ad                	li	a7,11
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 60e:	48b1                	li	a7,12
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <pause>:
.global pause
pause:
 li a7, SYS_pause
 616:	48b5                	li	a7,13
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 61e:	48b9                	li	a7,14
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <clone>:
.global clone
clone:
 li a7, SYS_clone
 626:	48d9                	li	a7,22
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <join>:
.global join
join:
 li a7, SYS_join
 62e:	48dd                	li	a7,23
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 636:	1101                	addi	sp,sp,-32
 638:	ec06                	sd	ra,24(sp)
 63a:	e822                	sd	s0,16(sp)
 63c:	1000                	addi	s0,sp,32
 63e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 642:	4605                	li	a2,1
 644:	fef40593          	addi	a1,s0,-17
 648:	f5fff0ef          	jal	5a6 <write>
}
 64c:	60e2                	ld	ra,24(sp)
 64e:	6442                	ld	s0,16(sp)
 650:	6105                	addi	sp,sp,32
 652:	8082                	ret

0000000000000654 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 654:	715d                	addi	sp,sp,-80
 656:	e486                	sd	ra,72(sp)
 658:	e0a2                	sd	s0,64(sp)
 65a:	fc26                	sd	s1,56(sp)
 65c:	f84a                	sd	s2,48(sp)
 65e:	f44e                	sd	s3,40(sp)
 660:	0880                	addi	s0,sp,80
 662:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 664:	c299                	beqz	a3,66a <printint+0x16>
 666:	0605cc63          	bltz	a1,6de <printint+0x8a>
  neg = 0;
 66a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 66c:	fb840313          	addi	t1,s0,-72
  neg = 0;
 670:	869a                	mv	a3,t1
  i = 0;
 672:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 674:	00000817          	auipc	a6,0x0
 678:	55480813          	addi	a6,a6,1364 # bc8 <digits>
 67c:	88be                	mv	a7,a5
 67e:	0017851b          	addiw	a0,a5,1 # 1001 <freep+0x1>
 682:	87aa                	mv	a5,a0
 684:	02c5f733          	remu	a4,a1,a2
 688:	9742                	add	a4,a4,a6
 68a:	00074703          	lbu	a4,0(a4)
 68e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 692:	872e                	mv	a4,a1
 694:	02c5d5b3          	divu	a1,a1,a2
 698:	0685                	addi	a3,a3,1
 69a:	fec771e3          	bgeu	a4,a2,67c <printint+0x28>
  if(neg)
 69e:	000e0c63          	beqz	t3,6b6 <printint+0x62>
    buf[i++] = '-';
 6a2:	fd050793          	addi	a5,a0,-48 # fd0 <digits+0x408>
 6a6:	00878533          	add	a0,a5,s0
 6aa:	02d00793          	li	a5,45
 6ae:	fef50423          	sb	a5,-24(a0)
 6b2:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 6b6:	fff7899b          	addiw	s3,a5,-1
 6ba:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 6be:	fff4c583          	lbu	a1,-1(s1)
 6c2:	854a                	mv	a0,s2
 6c4:	f73ff0ef          	jal	636 <putc>
  while(--i >= 0)
 6c8:	39fd                	addiw	s3,s3,-1
 6ca:	14fd                	addi	s1,s1,-1
 6cc:	fe09d9e3          	bgez	s3,6be <printint+0x6a>
}
 6d0:	60a6                	ld	ra,72(sp)
 6d2:	6406                	ld	s0,64(sp)
 6d4:	74e2                	ld	s1,56(sp)
 6d6:	7942                	ld	s2,48(sp)
 6d8:	79a2                	ld	s3,40(sp)
 6da:	6161                	addi	sp,sp,80
 6dc:	8082                	ret
    x = -xx;
 6de:	40b005b3          	neg	a1,a1
    neg = 1;
 6e2:	4e05                	li	t3,1
    x = -xx;
 6e4:	b761                	j	66c <printint+0x18>

00000000000006e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6e6:	711d                	addi	sp,sp,-96
 6e8:	ec86                	sd	ra,88(sp)
 6ea:	e8a2                	sd	s0,80(sp)
 6ec:	e4a6                	sd	s1,72(sp)
 6ee:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6f0:	0005c483          	lbu	s1,0(a1)
 6f4:	28048463          	beqz	s1,97c <vprintf+0x296>
 6f8:	e0ca                	sd	s2,64(sp)
 6fa:	fc4e                	sd	s3,56(sp)
 6fc:	f852                	sd	s4,48(sp)
 6fe:	f456                	sd	s5,40(sp)
 700:	f05a                	sd	s6,32(sp)
 702:	ec5e                	sd	s7,24(sp)
 704:	e862                	sd	s8,16(sp)
 706:	e466                	sd	s9,8(sp)
 708:	8b2a                	mv	s6,a0
 70a:	8a2e                	mv	s4,a1
 70c:	8bb2                	mv	s7,a2
  state = 0;
 70e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 710:	4901                	li	s2,0
 712:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 714:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 718:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 71c:	06c00c93          	li	s9,108
 720:	a00d                	j	742 <vprintf+0x5c>
        putc(fd, c0);
 722:	85a6                	mv	a1,s1
 724:	855a                	mv	a0,s6
 726:	f11ff0ef          	jal	636 <putc>
 72a:	a019                	j	730 <vprintf+0x4a>
    } else if(state == '%'){
 72c:	03598363          	beq	s3,s5,752 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 730:	0019079b          	addiw	a5,s2,1
 734:	893e                	mv	s2,a5
 736:	873e                	mv	a4,a5
 738:	97d2                	add	a5,a5,s4
 73a:	0007c483          	lbu	s1,0(a5)
 73e:	22048763          	beqz	s1,96c <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 742:	0004879b          	sext.w	a5,s1
    if(state == 0){
 746:	fe0993e3          	bnez	s3,72c <vprintf+0x46>
      if(c0 == '%'){
 74a:	fd579ce3          	bne	a5,s5,722 <vprintf+0x3c>
        state = '%';
 74e:	89be                	mv	s3,a5
 750:	b7c5                	j	730 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 752:	00ea06b3          	add	a3,s4,a4
 756:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 75a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 75c:	c681                	beqz	a3,764 <vprintf+0x7e>
 75e:	9752                	add	a4,a4,s4
 760:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 764:	05878263          	beq	a5,s8,7a8 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 768:	05978c63          	beq	a5,s9,7c0 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 76c:	07500713          	li	a4,117
 770:	0ee78663          	beq	a5,a4,85c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 774:	07800713          	li	a4,120
 778:	12e78863          	beq	a5,a4,8a8 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 77c:	07000713          	li	a4,112
 780:	14e78d63          	beq	a5,a4,8da <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 784:	06300713          	li	a4,99
 788:	18e78c63          	beq	a5,a4,920 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 78c:	07300713          	li	a4,115
 790:	1ae78263          	beq	a5,a4,934 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 794:	02500713          	li	a4,37
 798:	04e79463          	bne	a5,a4,7e0 <vprintf+0xfa>
        putc(fd, '%');
 79c:	85ba                	mv	a1,a4
 79e:	855a                	mv	a0,s6
 7a0:	e97ff0ef          	jal	636 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b769                	j	730 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 7a8:	008b8493          	addi	s1,s7,8
 7ac:	4685                	li	a3,1
 7ae:	4629                	li	a2,10
 7b0:	000ba583          	lw	a1,0(s7)
 7b4:	855a                	mv	a0,s6
 7b6:	e9fff0ef          	jal	654 <printint>
 7ba:	8ba6                	mv	s7,s1
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	bf8d                	j	730 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 7c0:	06400793          	li	a5,100
 7c4:	02f68963          	beq	a3,a5,7f6 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7c8:	06c00793          	li	a5,108
 7cc:	04f68263          	beq	a3,a5,810 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 7d0:	07500793          	li	a5,117
 7d4:	0af68063          	beq	a3,a5,874 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 7d8:	07800793          	li	a5,120
 7dc:	0ef68263          	beq	a3,a5,8c0 <vprintf+0x1da>
        putc(fd, '%');
 7e0:	02500593          	li	a1,37
 7e4:	855a                	mv	a0,s6
 7e6:	e51ff0ef          	jal	636 <putc>
        putc(fd, c0);
 7ea:	85a6                	mv	a1,s1
 7ec:	855a                	mv	a0,s6
 7ee:	e49ff0ef          	jal	636 <putc>
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	bf35                	j	730 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f6:	008b8493          	addi	s1,s7,8
 7fa:	4685                	li	a3,1
 7fc:	4629                	li	a2,10
 7fe:	000bb583          	ld	a1,0(s7)
 802:	855a                	mv	a0,s6
 804:	e51ff0ef          	jal	654 <printint>
        i += 1;
 808:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 80a:	8ba6                	mv	s7,s1
      state = 0;
 80c:	4981                	li	s3,0
        i += 1;
 80e:	b70d                	j	730 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 810:	06400793          	li	a5,100
 814:	02f60763          	beq	a2,a5,842 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 818:	07500793          	li	a5,117
 81c:	06f60963          	beq	a2,a5,88e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 820:	07800793          	li	a5,120
 824:	faf61ee3          	bne	a2,a5,7e0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 828:	008b8493          	addi	s1,s7,8
 82c:	4681                	li	a3,0
 82e:	4641                	li	a2,16
 830:	000bb583          	ld	a1,0(s7)
 834:	855a                	mv	a0,s6
 836:	e1fff0ef          	jal	654 <printint>
        i += 2;
 83a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 83c:	8ba6                	mv	s7,s1
      state = 0;
 83e:	4981                	li	s3,0
        i += 2;
 840:	bdc5                	j	730 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 842:	008b8493          	addi	s1,s7,8
 846:	4685                	li	a3,1
 848:	4629                	li	a2,10
 84a:	000bb583          	ld	a1,0(s7)
 84e:	855a                	mv	a0,s6
 850:	e05ff0ef          	jal	654 <printint>
        i += 2;
 854:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 856:	8ba6                	mv	s7,s1
      state = 0;
 858:	4981                	li	s3,0
        i += 2;
 85a:	bdd9                	j	730 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 85c:	008b8493          	addi	s1,s7,8
 860:	4681                	li	a3,0
 862:	4629                	li	a2,10
 864:	000be583          	lwu	a1,0(s7)
 868:	855a                	mv	a0,s6
 86a:	debff0ef          	jal	654 <printint>
 86e:	8ba6                	mv	s7,s1
      state = 0;
 870:	4981                	li	s3,0
 872:	bd7d                	j	730 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 874:	008b8493          	addi	s1,s7,8
 878:	4681                	li	a3,0
 87a:	4629                	li	a2,10
 87c:	000bb583          	ld	a1,0(s7)
 880:	855a                	mv	a0,s6
 882:	dd3ff0ef          	jal	654 <printint>
        i += 1;
 886:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 888:	8ba6                	mv	s7,s1
      state = 0;
 88a:	4981                	li	s3,0
        i += 1;
 88c:	b555                	j	730 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 88e:	008b8493          	addi	s1,s7,8
 892:	4681                	li	a3,0
 894:	4629                	li	a2,10
 896:	000bb583          	ld	a1,0(s7)
 89a:	855a                	mv	a0,s6
 89c:	db9ff0ef          	jal	654 <printint>
        i += 2;
 8a0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8a2:	8ba6                	mv	s7,s1
      state = 0;
 8a4:	4981                	li	s3,0
        i += 2;
 8a6:	b569                	j	730 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 8a8:	008b8493          	addi	s1,s7,8
 8ac:	4681                	li	a3,0
 8ae:	4641                	li	a2,16
 8b0:	000be583          	lwu	a1,0(s7)
 8b4:	855a                	mv	a0,s6
 8b6:	d9fff0ef          	jal	654 <printint>
 8ba:	8ba6                	mv	s7,s1
      state = 0;
 8bc:	4981                	li	s3,0
 8be:	bd8d                	j	730 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8c0:	008b8493          	addi	s1,s7,8
 8c4:	4681                	li	a3,0
 8c6:	4641                	li	a2,16
 8c8:	000bb583          	ld	a1,0(s7)
 8cc:	855a                	mv	a0,s6
 8ce:	d87ff0ef          	jal	654 <printint>
        i += 1;
 8d2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8d4:	8ba6                	mv	s7,s1
      state = 0;
 8d6:	4981                	li	s3,0
        i += 1;
 8d8:	bda1                	j	730 <vprintf+0x4a>
 8da:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8dc:	008b8d13          	addi	s10,s7,8
 8e0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8e4:	03000593          	li	a1,48
 8e8:	855a                	mv	a0,s6
 8ea:	d4dff0ef          	jal	636 <putc>
  putc(fd, 'x');
 8ee:	07800593          	li	a1,120
 8f2:	855a                	mv	a0,s6
 8f4:	d43ff0ef          	jal	636 <putc>
 8f8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8fa:	00000b97          	auipc	s7,0x0
 8fe:	2ceb8b93          	addi	s7,s7,718 # bc8 <digits>
 902:	03c9d793          	srli	a5,s3,0x3c
 906:	97de                	add	a5,a5,s7
 908:	0007c583          	lbu	a1,0(a5)
 90c:	855a                	mv	a0,s6
 90e:	d29ff0ef          	jal	636 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 912:	0992                	slli	s3,s3,0x4
 914:	34fd                	addiw	s1,s1,-1
 916:	f4f5                	bnez	s1,902 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 918:	8bea                	mv	s7,s10
      state = 0;
 91a:	4981                	li	s3,0
 91c:	6d02                	ld	s10,0(sp)
 91e:	bd09                	j	730 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 920:	008b8493          	addi	s1,s7,8
 924:	000bc583          	lbu	a1,0(s7)
 928:	855a                	mv	a0,s6
 92a:	d0dff0ef          	jal	636 <putc>
 92e:	8ba6                	mv	s7,s1
      state = 0;
 930:	4981                	li	s3,0
 932:	bbfd                	j	730 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 934:	008b8993          	addi	s3,s7,8
 938:	000bb483          	ld	s1,0(s7)
 93c:	cc91                	beqz	s1,958 <vprintf+0x272>
        for(; *s; s++)
 93e:	0004c583          	lbu	a1,0(s1)
 942:	c195                	beqz	a1,966 <vprintf+0x280>
          putc(fd, *s);
 944:	855a                	mv	a0,s6
 946:	cf1ff0ef          	jal	636 <putc>
        for(; *s; s++)
 94a:	0485                	addi	s1,s1,1
 94c:	0004c583          	lbu	a1,0(s1)
 950:	f9f5                	bnez	a1,944 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 952:	8bce                	mv	s7,s3
      state = 0;
 954:	4981                	li	s3,0
 956:	bbe9                	j	730 <vprintf+0x4a>
          s = "(null)";
 958:	00000497          	auipc	s1,0x0
 95c:	26848493          	addi	s1,s1,616 # bc0 <malloc+0x158>
        for(; *s; s++)
 960:	02800593          	li	a1,40
 964:	b7c5                	j	944 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 966:	8bce                	mv	s7,s3
      state = 0;
 968:	4981                	li	s3,0
 96a:	b3d9                	j	730 <vprintf+0x4a>
 96c:	6906                	ld	s2,64(sp)
 96e:	79e2                	ld	s3,56(sp)
 970:	7a42                	ld	s4,48(sp)
 972:	7aa2                	ld	s5,40(sp)
 974:	7b02                	ld	s6,32(sp)
 976:	6be2                	ld	s7,24(sp)
 978:	6c42                	ld	s8,16(sp)
 97a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 97c:	60e6                	ld	ra,88(sp)
 97e:	6446                	ld	s0,80(sp)
 980:	64a6                	ld	s1,72(sp)
 982:	6125                	addi	sp,sp,96
 984:	8082                	ret

0000000000000986 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 986:	715d                	addi	sp,sp,-80
 988:	ec06                	sd	ra,24(sp)
 98a:	e822                	sd	s0,16(sp)
 98c:	1000                	addi	s0,sp,32
 98e:	e010                	sd	a2,0(s0)
 990:	e414                	sd	a3,8(s0)
 992:	e818                	sd	a4,16(s0)
 994:	ec1c                	sd	a5,24(s0)
 996:	03043023          	sd	a6,32(s0)
 99a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 99e:	8622                	mv	a2,s0
 9a0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9a4:	d43ff0ef          	jal	6e6 <vprintf>
}
 9a8:	60e2                	ld	ra,24(sp)
 9aa:	6442                	ld	s0,16(sp)
 9ac:	6161                	addi	sp,sp,80
 9ae:	8082                	ret

00000000000009b0 <printf>:

void
printf(const char *fmt, ...)
{
 9b0:	711d                	addi	sp,sp,-96
 9b2:	ec06                	sd	ra,24(sp)
 9b4:	e822                	sd	s0,16(sp)
 9b6:	1000                	addi	s0,sp,32
 9b8:	e40c                	sd	a1,8(s0)
 9ba:	e810                	sd	a2,16(s0)
 9bc:	ec14                	sd	a3,24(s0)
 9be:	f018                	sd	a4,32(s0)
 9c0:	f41c                	sd	a5,40(s0)
 9c2:	03043823          	sd	a6,48(s0)
 9c6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9ca:	00840613          	addi	a2,s0,8
 9ce:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9d2:	85aa                	mv	a1,a0
 9d4:	4505                	li	a0,1
 9d6:	d11ff0ef          	jal	6e6 <vprintf>
}
 9da:	60e2                	ld	ra,24(sp)
 9dc:	6442                	ld	s0,16(sp)
 9de:	6125                	addi	sp,sp,96
 9e0:	8082                	ret

00000000000009e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9e2:	1141                	addi	sp,sp,-16
 9e4:	e406                	sd	ra,8(sp)
 9e6:	e022                	sd	s0,0(sp)
 9e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ee:	00000797          	auipc	a5,0x0
 9f2:	6127b783          	ld	a5,1554(a5) # 1000 <freep>
 9f6:	a02d                	j	a20 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9f8:	4618                	lw	a4,8(a2)
 9fa:	9f2d                	addw	a4,a4,a1
 9fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a00:	6398                	ld	a4,0(a5)
 a02:	6310                	ld	a2,0(a4)
 a04:	a83d                	j	a42 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a06:	ff852703          	lw	a4,-8(a0)
 a0a:	9f31                	addw	a4,a4,a2
 a0c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a0e:	ff053683          	ld	a3,-16(a0)
 a12:	a091                	j	a56 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a14:	6398                	ld	a4,0(a5)
 a16:	00e7e463          	bltu	a5,a4,a1e <free+0x3c>
 a1a:	00e6ea63          	bltu	a3,a4,a2e <free+0x4c>
{
 a1e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a20:	fed7fae3          	bgeu	a5,a3,a14 <free+0x32>
 a24:	6398                	ld	a4,0(a5)
 a26:	00e6e463          	bltu	a3,a4,a2e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a2a:	fee7eae3          	bltu	a5,a4,a1e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 a2e:	ff852583          	lw	a1,-8(a0)
 a32:	6390                	ld	a2,0(a5)
 a34:	02059813          	slli	a6,a1,0x20
 a38:	01c85713          	srli	a4,a6,0x1c
 a3c:	9736                	add	a4,a4,a3
 a3e:	fae60de3          	beq	a2,a4,9f8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a42:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a46:	4790                	lw	a2,8(a5)
 a48:	02061593          	slli	a1,a2,0x20
 a4c:	01c5d713          	srli	a4,a1,0x1c
 a50:	973e                	add	a4,a4,a5
 a52:	fae68ae3          	beq	a3,a4,a06 <free+0x24>
    p->s.ptr = bp->s.ptr;
 a56:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a58:	00000717          	auipc	a4,0x0
 a5c:	5af73423          	sd	a5,1448(a4) # 1000 <freep>
}
 a60:	60a2                	ld	ra,8(sp)
 a62:	6402                	ld	s0,0(sp)
 a64:	0141                	addi	sp,sp,16
 a66:	8082                	ret

0000000000000a68 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a68:	7139                	addi	sp,sp,-64
 a6a:	fc06                	sd	ra,56(sp)
 a6c:	f822                	sd	s0,48(sp)
 a6e:	f04a                	sd	s2,32(sp)
 a70:	ec4e                	sd	s3,24(sp)
 a72:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a74:	02051993          	slli	s3,a0,0x20
 a78:	0209d993          	srli	s3,s3,0x20
 a7c:	09bd                	addi	s3,s3,15
 a7e:	0049d993          	srli	s3,s3,0x4
 a82:	2985                	addiw	s3,s3,1
 a84:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a86:	00000517          	auipc	a0,0x0
 a8a:	57a53503          	ld	a0,1402(a0) # 1000 <freep>
 a8e:	c905                	beqz	a0,abe <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a90:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a92:	4798                	lw	a4,8(a5)
 a94:	09377663          	bgeu	a4,s3,b20 <malloc+0xb8>
 a98:	f426                	sd	s1,40(sp)
 a9a:	e852                	sd	s4,16(sp)
 a9c:	e456                	sd	s5,8(sp)
 a9e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 aa0:	8a4e                	mv	s4,s3
 aa2:	6705                	lui	a4,0x1
 aa4:	00e9f363          	bgeu	s3,a4,aaa <malloc+0x42>
 aa8:	6a05                	lui	s4,0x1
 aaa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 aae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ab2:	00000497          	auipc	s1,0x0
 ab6:	54e48493          	addi	s1,s1,1358 # 1000 <freep>
  if(p == SBRK_ERROR)
 aba:	5afd                	li	s5,-1
 abc:	a83d                	j	afa <malloc+0x92>
 abe:	f426                	sd	s1,40(sp)
 ac0:	e852                	sd	s4,16(sp)
 ac2:	e456                	sd	s5,8(sp)
 ac4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 ac6:	00000797          	auipc	a5,0x0
 aca:	55a78793          	addi	a5,a5,1370 # 1020 <base>
 ace:	00000717          	auipc	a4,0x0
 ad2:	52f73923          	sd	a5,1330(a4) # 1000 <freep>
 ad6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ad8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 adc:	b7d1                	j	aa0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 ade:	6398                	ld	a4,0(a5)
 ae0:	e118                	sd	a4,0(a0)
 ae2:	a899                	j	b38 <malloc+0xd0>
  hp->s.size = nu;
 ae4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ae8:	0541                	addi	a0,a0,16
 aea:	ef9ff0ef          	jal	9e2 <free>
  return freep;
 aee:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 af0:	c125                	beqz	a0,b50 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 af2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 af4:	4798                	lw	a4,8(a5)
 af6:	03277163          	bgeu	a4,s2,b18 <malloc+0xb0>
    if(p == freep)
 afa:	6098                	ld	a4,0(s1)
 afc:	853e                	mv	a0,a5
 afe:	fef71ae3          	bne	a4,a5,af2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b02:	8552                	mv	a0,s4
 b04:	a1dff0ef          	jal	520 <sbrk>
  if(p == SBRK_ERROR)
 b08:	fd551ee3          	bne	a0,s5,ae4 <malloc+0x7c>
        return 0;
 b0c:	4501                	li	a0,0
 b0e:	74a2                	ld	s1,40(sp)
 b10:	6a42                	ld	s4,16(sp)
 b12:	6aa2                	ld	s5,8(sp)
 b14:	6b02                	ld	s6,0(sp)
 b16:	a03d                	j	b44 <malloc+0xdc>
 b18:	74a2                	ld	s1,40(sp)
 b1a:	6a42                	ld	s4,16(sp)
 b1c:	6aa2                	ld	s5,8(sp)
 b1e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b20:	fae90fe3          	beq	s2,a4,ade <malloc+0x76>
        p->s.size -= nunits;
 b24:	4137073b          	subw	a4,a4,s3
 b28:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b2a:	02071693          	slli	a3,a4,0x20
 b2e:	01c6d713          	srli	a4,a3,0x1c
 b32:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b34:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b38:	00000717          	auipc	a4,0x0
 b3c:	4ca73423          	sd	a0,1224(a4) # 1000 <freep>
      return (void*)(p + 1);
 b40:	01078513          	addi	a0,a5,16
  }
}
 b44:	70e2                	ld	ra,56(sp)
 b46:	7442                	ld	s0,48(sp)
 b48:	7902                	ld	s2,32(sp)
 b4a:	69e2                	ld	s3,24(sp)
 b4c:	6121                	addi	sp,sp,64
 b4e:	8082                	ret
 b50:	74a2                	ld	s1,40(sp)
 b52:	6a42                	ld	s4,16(sp)
 b54:	6aa2                	ld	s5,8(sp)
 b56:	6b02                	ld	s6,0(sp)
 b58:	b7f5                	j	b44 <malloc+0xdc>
