
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
  ac:	4e8000ef          	jal	594 <open>
  b0:	06054363          	bltz	a0,116 <ls+0x80>
  b4:	26913c23          	sd	s1,632(sp)
  b8:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  ba:	d7840593          	addi	a1,s0,-648
  be:	4ee000ef          	jal	5ac <fstat>
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
  f2:	a8250513          	addi	a0,a0,-1406 # b70 <malloc+0x128>
  f6:	09b000ef          	jal	990 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  fa:	8526                	mv	a0,s1
  fc:	480000ef          	jal	57c <close>
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
 11c:	a2858593          	addi	a1,a1,-1496 # b40 <malloc+0xf8>
 120:	4509                	li	a0,2
 122:	045000ef          	jal	966 <fprintf>
    return;
 126:	bff9                	j	104 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 128:	864a                	mv	a2,s2
 12a:	00001597          	auipc	a1,0x1
 12e:	a2e58593          	addi	a1,a1,-1490 # b58 <malloc+0x110>
 132:	4509                	li	a0,2
 134:	033000ef          	jal	966 <fprintf>
    close(fd);
 138:	8526                	mv	a0,s1
 13a:	442000ef          	jal	57c <close>
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
 158:	a2c50513          	addi	a0,a0,-1492 # b80 <malloc+0x138>
 15c:	035000ef          	jal	990 <printf>
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
 1be:	9b6d0d13          	addi	s10,s10,-1610 # b70 <malloc+0x128>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c2:	a801                	j	1d2 <ls+0x13c>
        printf("ls: cannot stat %s\n", buf);
 1c4:	85d6                	mv	a1,s5
 1c6:	00001517          	auipc	a0,0x1
 1ca:	99250513          	addi	a0,a0,-1646 # b58 <malloc+0x110>
 1ce:	7c2000ef          	jal	990 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1d2:	864a                	mv	a2,s2
 1d4:	85d2                	mv	a1,s4
 1d6:	8526                	mv	a0,s1
 1d8:	394000ef          	jal	56c <read>
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
 216:	77a000ef          	jal	990 <printf>
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
 272:	2e2000ef          	jal	554 <exit>
 276:	e426                	sd	s1,8(sp)
 278:	e04a                	sd	s2,0(sp)
    ls(".");
 27a:	00001517          	auipc	a0,0x1
 27e:	91e50513          	addi	a0,a0,-1762 # b98 <malloc+0x150>
 282:	e15ff0ef          	jal	96 <ls>
    exit(0);
 286:	4501                	li	a0,0
 288:	2cc000ef          	jal	554 <exit>

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
 298:	2bc000ef          	jal	554 <exit>

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
 3a8:	1c4000ef          	jal	56c <read>
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
 3fa:	19a000ef          	jal	594 <open>
  if(fd < 0)
 3fe:	02054263          	bltz	a0,422 <stat+0x36>
 402:	e426                	sd	s1,8(sp)
 404:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 406:	85ca                	mv	a1,s2
 408:	1a4000ef          	jal	5ac <fstat>
 40c:	892a                	mv	s2,a0
  close(fd);
 40e:	8526                	mv	a0,s1
 410:	16c000ef          	jal	57c <close>
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
 52a:	0b2000ef          	jal	5dc <sys_sbrk>
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
 540:	09c000ef          	jal	5dc <sys_sbrk>
}
 544:	60a2                	ld	ra,8(sp)
 546:	6402                	ld	s0,0(sp)
 548:	0141                	addi	sp,sp,16
 54a:	8082                	ret

000000000000054c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 54c:	4885                	li	a7,1
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <exit>:
.global exit
exit:
 li a7, SYS_exit
 554:	4889                	li	a7,2
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <wait>:
.global wait
wait:
 li a7, SYS_wait
 55c:	488d                	li	a7,3
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 564:	4891                	li	a7,4
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <read>:
.global read
read:
 li a7, SYS_read
 56c:	4895                	li	a7,5
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <write>:
.global write
write:
 li a7, SYS_write
 574:	48c1                	li	a7,16
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <close>:
.global close
close:
 li a7, SYS_close
 57c:	48d5                	li	a7,21
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <kill>:
.global kill
kill:
 li a7, SYS_kill
 584:	4899                	li	a7,6
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <exec>:
.global exec
exec:
 li a7, SYS_exec
 58c:	489d                	li	a7,7
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <open>:
.global open
open:
 li a7, SYS_open
 594:	48bd                	li	a7,15
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 59c:	48c5                	li	a7,17
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5a4:	48c9                	li	a7,18
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ac:	48a1                	li	a7,8
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <link>:
.global link
link:
 li a7, SYS_link
 5b4:	48cd                	li	a7,19
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5bc:	48d1                	li	a7,20
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5c4:	48a5                	li	a7,9
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <dup>:
.global dup
dup:
 li a7, SYS_dup
 5cc:	48a9                	li	a7,10
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5d4:	48ad                	li	a7,11
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5dc:	48b1                	li	a7,12
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5e4:	48b5                	li	a7,13
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5ec:	48b9                	li	a7,14
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <bind>:
.global bind
bind:
 li a7, SYS_bind
 5f4:	48f5                	li	a7,29
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 5fc:	48f9                	li	a7,30
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <send>:
.global send
send:
 li a7, SYS_send
 604:	48fd                	li	a7,31
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <recv>:
.global recv
recv:
 li a7, SYS_recv
 60c:	02000893          	li	a7,32
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 616:	1101                	addi	sp,sp,-32
 618:	ec06                	sd	ra,24(sp)
 61a:	e822                	sd	s0,16(sp)
 61c:	1000                	addi	s0,sp,32
 61e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 622:	4605                	li	a2,1
 624:	fef40593          	addi	a1,s0,-17
 628:	f4dff0ef          	jal	574 <write>
}
 62c:	60e2                	ld	ra,24(sp)
 62e:	6442                	ld	s0,16(sp)
 630:	6105                	addi	sp,sp,32
 632:	8082                	ret

0000000000000634 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 634:	715d                	addi	sp,sp,-80
 636:	e486                	sd	ra,72(sp)
 638:	e0a2                	sd	s0,64(sp)
 63a:	fc26                	sd	s1,56(sp)
 63c:	f84a                	sd	s2,48(sp)
 63e:	f44e                	sd	s3,40(sp)
 640:	0880                	addi	s0,sp,80
 642:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 644:	c299                	beqz	a3,64a <printint+0x16>
 646:	0605cc63          	bltz	a1,6be <printint+0x8a>
  neg = 0;
 64a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 64c:	fb840313          	addi	t1,s0,-72
  neg = 0;
 650:	869a                	mv	a3,t1
  i = 0;
 652:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 654:	00000817          	auipc	a6,0x0
 658:	55480813          	addi	a6,a6,1364 # ba8 <digits>
 65c:	88be                	mv	a7,a5
 65e:	0017851b          	addiw	a0,a5,1
 662:	87aa                	mv	a5,a0
 664:	02c5f733          	remu	a4,a1,a2
 668:	9742                	add	a4,a4,a6
 66a:	00074703          	lbu	a4,0(a4)
 66e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 672:	872e                	mv	a4,a1
 674:	02c5d5b3          	divu	a1,a1,a2
 678:	0685                	addi	a3,a3,1
 67a:	fec771e3          	bgeu	a4,a2,65c <printint+0x28>
  if(neg)
 67e:	000e0c63          	beqz	t3,696 <printint+0x62>
    buf[i++] = '-';
 682:	fd050793          	addi	a5,a0,-48
 686:	00878533          	add	a0,a5,s0
 68a:	02d00793          	li	a5,45
 68e:	fef50423          	sb	a5,-24(a0)
 692:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 696:	fff7899b          	addiw	s3,a5,-1
 69a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 69e:	fff4c583          	lbu	a1,-1(s1)
 6a2:	854a                	mv	a0,s2
 6a4:	f73ff0ef          	jal	616 <putc>
  while(--i >= 0)
 6a8:	39fd                	addiw	s3,s3,-1
 6aa:	14fd                	addi	s1,s1,-1
 6ac:	fe09d9e3          	bgez	s3,69e <printint+0x6a>
}
 6b0:	60a6                	ld	ra,72(sp)
 6b2:	6406                	ld	s0,64(sp)
 6b4:	74e2                	ld	s1,56(sp)
 6b6:	7942                	ld	s2,48(sp)
 6b8:	79a2                	ld	s3,40(sp)
 6ba:	6161                	addi	sp,sp,80
 6bc:	8082                	ret
    x = -xx;
 6be:	40b005b3          	neg	a1,a1
    neg = 1;
 6c2:	4e05                	li	t3,1
    x = -xx;
 6c4:	b761                	j	64c <printint+0x18>

00000000000006c6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6c6:	711d                	addi	sp,sp,-96
 6c8:	ec86                	sd	ra,88(sp)
 6ca:	e8a2                	sd	s0,80(sp)
 6cc:	e4a6                	sd	s1,72(sp)
 6ce:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6d0:	0005c483          	lbu	s1,0(a1)
 6d4:	28048463          	beqz	s1,95c <vprintf+0x296>
 6d8:	e0ca                	sd	s2,64(sp)
 6da:	fc4e                	sd	s3,56(sp)
 6dc:	f852                	sd	s4,48(sp)
 6de:	f456                	sd	s5,40(sp)
 6e0:	f05a                	sd	s6,32(sp)
 6e2:	ec5e                	sd	s7,24(sp)
 6e4:	e862                	sd	s8,16(sp)
 6e6:	e466                	sd	s9,8(sp)
 6e8:	8b2a                	mv	s6,a0
 6ea:	8a2e                	mv	s4,a1
 6ec:	8bb2                	mv	s7,a2
  state = 0;
 6ee:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6f0:	4901                	li	s2,0
 6f2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6f4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6f8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6fc:	06c00c93          	li	s9,108
 700:	a00d                	j	722 <vprintf+0x5c>
        putc(fd, c0);
 702:	85a6                	mv	a1,s1
 704:	855a                	mv	a0,s6
 706:	f11ff0ef          	jal	616 <putc>
 70a:	a019                	j	710 <vprintf+0x4a>
    } else if(state == '%'){
 70c:	03598363          	beq	s3,s5,732 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 710:	0019079b          	addiw	a5,s2,1
 714:	893e                	mv	s2,a5
 716:	873e                	mv	a4,a5
 718:	97d2                	add	a5,a5,s4
 71a:	0007c483          	lbu	s1,0(a5)
 71e:	22048763          	beqz	s1,94c <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 722:	0004879b          	sext.w	a5,s1
    if(state == 0){
 726:	fe0993e3          	bnez	s3,70c <vprintf+0x46>
      if(c0 == '%'){
 72a:	fd579ce3          	bne	a5,s5,702 <vprintf+0x3c>
        state = '%';
 72e:	89be                	mv	s3,a5
 730:	b7c5                	j	710 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 732:	00ea06b3          	add	a3,s4,a4
 736:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 73a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 73c:	c681                	beqz	a3,744 <vprintf+0x7e>
 73e:	9752                	add	a4,a4,s4
 740:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 744:	05878263          	beq	a5,s8,788 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 748:	05978c63          	beq	a5,s9,7a0 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 74c:	07500713          	li	a4,117
 750:	0ee78663          	beq	a5,a4,83c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 754:	07800713          	li	a4,120
 758:	12e78863          	beq	a5,a4,888 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 75c:	07000713          	li	a4,112
 760:	14e78d63          	beq	a5,a4,8ba <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 764:	06300713          	li	a4,99
 768:	18e78c63          	beq	a5,a4,900 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 76c:	07300713          	li	a4,115
 770:	1ae78263          	beq	a5,a4,914 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 774:	02500713          	li	a4,37
 778:	04e79463          	bne	a5,a4,7c0 <vprintf+0xfa>
        putc(fd, '%');
 77c:	85ba                	mv	a1,a4
 77e:	855a                	mv	a0,s6
 780:	e97ff0ef          	jal	616 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 784:	4981                	li	s3,0
 786:	b769                	j	710 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 788:	008b8493          	addi	s1,s7,8
 78c:	4685                	li	a3,1
 78e:	4629                	li	a2,10
 790:	000ba583          	lw	a1,0(s7)
 794:	855a                	mv	a0,s6
 796:	e9fff0ef          	jal	634 <printint>
 79a:	8ba6                	mv	s7,s1
      state = 0;
 79c:	4981                	li	s3,0
 79e:	bf8d                	j	710 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 7a0:	06400793          	li	a5,100
 7a4:	02f68963          	beq	a3,a5,7d6 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7a8:	06c00793          	li	a5,108
 7ac:	04f68263          	beq	a3,a5,7f0 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 7b0:	07500793          	li	a5,117
 7b4:	0af68063          	beq	a3,a5,854 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 7b8:	07800793          	li	a5,120
 7bc:	0ef68263          	beq	a3,a5,8a0 <vprintf+0x1da>
        putc(fd, '%');
 7c0:	02500593          	li	a1,37
 7c4:	855a                	mv	a0,s6
 7c6:	e51ff0ef          	jal	616 <putc>
        putc(fd, c0);
 7ca:	85a6                	mv	a1,s1
 7cc:	855a                	mv	a0,s6
 7ce:	e49ff0ef          	jal	616 <putc>
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	bf35                	j	710 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d6:	008b8493          	addi	s1,s7,8
 7da:	4685                	li	a3,1
 7dc:	4629                	li	a2,10
 7de:	000bb583          	ld	a1,0(s7)
 7e2:	855a                	mv	a0,s6
 7e4:	e51ff0ef          	jal	634 <printint>
        i += 1;
 7e8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ea:	8ba6                	mv	s7,s1
      state = 0;
 7ec:	4981                	li	s3,0
        i += 1;
 7ee:	b70d                	j	710 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7f0:	06400793          	li	a5,100
 7f4:	02f60763          	beq	a2,a5,822 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7f8:	07500793          	li	a5,117
 7fc:	06f60963          	beq	a2,a5,86e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 800:	07800793          	li	a5,120
 804:	faf61ee3          	bne	a2,a5,7c0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 808:	008b8493          	addi	s1,s7,8
 80c:	4681                	li	a3,0
 80e:	4641                	li	a2,16
 810:	000bb583          	ld	a1,0(s7)
 814:	855a                	mv	a0,s6
 816:	e1fff0ef          	jal	634 <printint>
        i += 2;
 81a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 81c:	8ba6                	mv	s7,s1
      state = 0;
 81e:	4981                	li	s3,0
        i += 2;
 820:	bdc5                	j	710 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 822:	008b8493          	addi	s1,s7,8
 826:	4685                	li	a3,1
 828:	4629                	li	a2,10
 82a:	000bb583          	ld	a1,0(s7)
 82e:	855a                	mv	a0,s6
 830:	e05ff0ef          	jal	634 <printint>
        i += 2;
 834:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 836:	8ba6                	mv	s7,s1
      state = 0;
 838:	4981                	li	s3,0
        i += 2;
 83a:	bdd9                	j	710 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 83c:	008b8493          	addi	s1,s7,8
 840:	4681                	li	a3,0
 842:	4629                	li	a2,10
 844:	000be583          	lwu	a1,0(s7)
 848:	855a                	mv	a0,s6
 84a:	debff0ef          	jal	634 <printint>
 84e:	8ba6                	mv	s7,s1
      state = 0;
 850:	4981                	li	s3,0
 852:	bd7d                	j	710 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 854:	008b8493          	addi	s1,s7,8
 858:	4681                	li	a3,0
 85a:	4629                	li	a2,10
 85c:	000bb583          	ld	a1,0(s7)
 860:	855a                	mv	a0,s6
 862:	dd3ff0ef          	jal	634 <printint>
        i += 1;
 866:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 868:	8ba6                	mv	s7,s1
      state = 0;
 86a:	4981                	li	s3,0
        i += 1;
 86c:	b555                	j	710 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 86e:	008b8493          	addi	s1,s7,8
 872:	4681                	li	a3,0
 874:	4629                	li	a2,10
 876:	000bb583          	ld	a1,0(s7)
 87a:	855a                	mv	a0,s6
 87c:	db9ff0ef          	jal	634 <printint>
        i += 2;
 880:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 882:	8ba6                	mv	s7,s1
      state = 0;
 884:	4981                	li	s3,0
        i += 2;
 886:	b569                	j	710 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 888:	008b8493          	addi	s1,s7,8
 88c:	4681                	li	a3,0
 88e:	4641                	li	a2,16
 890:	000be583          	lwu	a1,0(s7)
 894:	855a                	mv	a0,s6
 896:	d9fff0ef          	jal	634 <printint>
 89a:	8ba6                	mv	s7,s1
      state = 0;
 89c:	4981                	li	s3,0
 89e:	bd8d                	j	710 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8a0:	008b8493          	addi	s1,s7,8
 8a4:	4681                	li	a3,0
 8a6:	4641                	li	a2,16
 8a8:	000bb583          	ld	a1,0(s7)
 8ac:	855a                	mv	a0,s6
 8ae:	d87ff0ef          	jal	634 <printint>
        i += 1;
 8b2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8b4:	8ba6                	mv	s7,s1
      state = 0;
 8b6:	4981                	li	s3,0
        i += 1;
 8b8:	bda1                	j	710 <vprintf+0x4a>
 8ba:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8bc:	008b8d13          	addi	s10,s7,8
 8c0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8c4:	03000593          	li	a1,48
 8c8:	855a                	mv	a0,s6
 8ca:	d4dff0ef          	jal	616 <putc>
  putc(fd, 'x');
 8ce:	07800593          	li	a1,120
 8d2:	855a                	mv	a0,s6
 8d4:	d43ff0ef          	jal	616 <putc>
 8d8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8da:	00000b97          	auipc	s7,0x0
 8de:	2ceb8b93          	addi	s7,s7,718 # ba8 <digits>
 8e2:	03c9d793          	srli	a5,s3,0x3c
 8e6:	97de                	add	a5,a5,s7
 8e8:	0007c583          	lbu	a1,0(a5)
 8ec:	855a                	mv	a0,s6
 8ee:	d29ff0ef          	jal	616 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8f2:	0992                	slli	s3,s3,0x4
 8f4:	34fd                	addiw	s1,s1,-1
 8f6:	f4f5                	bnez	s1,8e2 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 8f8:	8bea                	mv	s7,s10
      state = 0;
 8fa:	4981                	li	s3,0
 8fc:	6d02                	ld	s10,0(sp)
 8fe:	bd09                	j	710 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 900:	008b8493          	addi	s1,s7,8
 904:	000bc583          	lbu	a1,0(s7)
 908:	855a                	mv	a0,s6
 90a:	d0dff0ef          	jal	616 <putc>
 90e:	8ba6                	mv	s7,s1
      state = 0;
 910:	4981                	li	s3,0
 912:	bbfd                	j	710 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 914:	008b8993          	addi	s3,s7,8
 918:	000bb483          	ld	s1,0(s7)
 91c:	cc91                	beqz	s1,938 <vprintf+0x272>
        for(; *s; s++)
 91e:	0004c583          	lbu	a1,0(s1)
 922:	c195                	beqz	a1,946 <vprintf+0x280>
          putc(fd, *s);
 924:	855a                	mv	a0,s6
 926:	cf1ff0ef          	jal	616 <putc>
        for(; *s; s++)
 92a:	0485                	addi	s1,s1,1
 92c:	0004c583          	lbu	a1,0(s1)
 930:	f9f5                	bnez	a1,924 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 932:	8bce                	mv	s7,s3
      state = 0;
 934:	4981                	li	s3,0
 936:	bbe9                	j	710 <vprintf+0x4a>
          s = "(null)";
 938:	00000497          	auipc	s1,0x0
 93c:	26848493          	addi	s1,s1,616 # ba0 <malloc+0x158>
        for(; *s; s++)
 940:	02800593          	li	a1,40
 944:	b7c5                	j	924 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 946:	8bce                	mv	s7,s3
      state = 0;
 948:	4981                	li	s3,0
 94a:	b3d9                	j	710 <vprintf+0x4a>
 94c:	6906                	ld	s2,64(sp)
 94e:	79e2                	ld	s3,56(sp)
 950:	7a42                	ld	s4,48(sp)
 952:	7aa2                	ld	s5,40(sp)
 954:	7b02                	ld	s6,32(sp)
 956:	6be2                	ld	s7,24(sp)
 958:	6c42                	ld	s8,16(sp)
 95a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 95c:	60e6                	ld	ra,88(sp)
 95e:	6446                	ld	s0,80(sp)
 960:	64a6                	ld	s1,72(sp)
 962:	6125                	addi	sp,sp,96
 964:	8082                	ret

0000000000000966 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 966:	715d                	addi	sp,sp,-80
 968:	ec06                	sd	ra,24(sp)
 96a:	e822                	sd	s0,16(sp)
 96c:	1000                	addi	s0,sp,32
 96e:	e010                	sd	a2,0(s0)
 970:	e414                	sd	a3,8(s0)
 972:	e818                	sd	a4,16(s0)
 974:	ec1c                	sd	a5,24(s0)
 976:	03043023          	sd	a6,32(s0)
 97a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 97e:	8622                	mv	a2,s0
 980:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 984:	d43ff0ef          	jal	6c6 <vprintf>
}
 988:	60e2                	ld	ra,24(sp)
 98a:	6442                	ld	s0,16(sp)
 98c:	6161                	addi	sp,sp,80
 98e:	8082                	ret

0000000000000990 <printf>:

void
printf(const char *fmt, ...)
{
 990:	711d                	addi	sp,sp,-96
 992:	ec06                	sd	ra,24(sp)
 994:	e822                	sd	s0,16(sp)
 996:	1000                	addi	s0,sp,32
 998:	e40c                	sd	a1,8(s0)
 99a:	e810                	sd	a2,16(s0)
 99c:	ec14                	sd	a3,24(s0)
 99e:	f018                	sd	a4,32(s0)
 9a0:	f41c                	sd	a5,40(s0)
 9a2:	03043823          	sd	a6,48(s0)
 9a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9aa:	00840613          	addi	a2,s0,8
 9ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9b2:	85aa                	mv	a1,a0
 9b4:	4505                	li	a0,1
 9b6:	d11ff0ef          	jal	6c6 <vprintf>
}
 9ba:	60e2                	ld	ra,24(sp)
 9bc:	6442                	ld	s0,16(sp)
 9be:	6125                	addi	sp,sp,96
 9c0:	8082                	ret

00000000000009c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9c2:	1141                	addi	sp,sp,-16
 9c4:	e406                	sd	ra,8(sp)
 9c6:	e022                	sd	s0,0(sp)
 9c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9ca:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ce:	00000797          	auipc	a5,0x0
 9d2:	6327b783          	ld	a5,1586(a5) # 1000 <freep>
 9d6:	a02d                	j	a00 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9d8:	4618                	lw	a4,8(a2)
 9da:	9f2d                	addw	a4,a4,a1
 9dc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9e0:	6398                	ld	a4,0(a5)
 9e2:	6310                	ld	a2,0(a4)
 9e4:	a83d                	j	a22 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9e6:	ff852703          	lw	a4,-8(a0)
 9ea:	9f31                	addw	a4,a4,a2
 9ec:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9ee:	ff053683          	ld	a3,-16(a0)
 9f2:	a091                	j	a36 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9f4:	6398                	ld	a4,0(a5)
 9f6:	00e7e463          	bltu	a5,a4,9fe <free+0x3c>
 9fa:	00e6ea63          	bltu	a3,a4,a0e <free+0x4c>
{
 9fe:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a00:	fed7fae3          	bgeu	a5,a3,9f4 <free+0x32>
 a04:	6398                	ld	a4,0(a5)
 a06:	00e6e463          	bltu	a3,a4,a0e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a0a:	fee7eae3          	bltu	a5,a4,9fe <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 a0e:	ff852583          	lw	a1,-8(a0)
 a12:	6390                	ld	a2,0(a5)
 a14:	02059813          	slli	a6,a1,0x20
 a18:	01c85713          	srli	a4,a6,0x1c
 a1c:	9736                	add	a4,a4,a3
 a1e:	fae60de3          	beq	a2,a4,9d8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a22:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a26:	4790                	lw	a2,8(a5)
 a28:	02061593          	slli	a1,a2,0x20
 a2c:	01c5d713          	srli	a4,a1,0x1c
 a30:	973e                	add	a4,a4,a5
 a32:	fae68ae3          	beq	a3,a4,9e6 <free+0x24>
    p->s.ptr = bp->s.ptr;
 a36:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a38:	00000717          	auipc	a4,0x0
 a3c:	5cf73423          	sd	a5,1480(a4) # 1000 <freep>
}
 a40:	60a2                	ld	ra,8(sp)
 a42:	6402                	ld	s0,0(sp)
 a44:	0141                	addi	sp,sp,16
 a46:	8082                	ret

0000000000000a48 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a48:	7139                	addi	sp,sp,-64
 a4a:	fc06                	sd	ra,56(sp)
 a4c:	f822                	sd	s0,48(sp)
 a4e:	f04a                	sd	s2,32(sp)
 a50:	ec4e                	sd	s3,24(sp)
 a52:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a54:	02051993          	slli	s3,a0,0x20
 a58:	0209d993          	srli	s3,s3,0x20
 a5c:	09bd                	addi	s3,s3,15
 a5e:	0049d993          	srli	s3,s3,0x4
 a62:	2985                	addiw	s3,s3,1
 a64:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a66:	00000517          	auipc	a0,0x0
 a6a:	59a53503          	ld	a0,1434(a0) # 1000 <freep>
 a6e:	c905                	beqz	a0,a9e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a70:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a72:	4798                	lw	a4,8(a5)
 a74:	09377663          	bgeu	a4,s3,b00 <malloc+0xb8>
 a78:	f426                	sd	s1,40(sp)
 a7a:	e852                	sd	s4,16(sp)
 a7c:	e456                	sd	s5,8(sp)
 a7e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a80:	8a4e                	mv	s4,s3
 a82:	6705                	lui	a4,0x1
 a84:	00e9f363          	bgeu	s3,a4,a8a <malloc+0x42>
 a88:	6a05                	lui	s4,0x1
 a8a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a8e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a92:	00000497          	auipc	s1,0x0
 a96:	56e48493          	addi	s1,s1,1390 # 1000 <freep>
  if(p == SBRK_ERROR)
 a9a:	5afd                	li	s5,-1
 a9c:	a83d                	j	ada <malloc+0x92>
 a9e:	f426                	sd	s1,40(sp)
 aa0:	e852                	sd	s4,16(sp)
 aa2:	e456                	sd	s5,8(sp)
 aa4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 aa6:	00000797          	auipc	a5,0x0
 aaa:	57a78793          	addi	a5,a5,1402 # 1020 <base>
 aae:	00000717          	auipc	a4,0x0
 ab2:	54f73923          	sd	a5,1362(a4) # 1000 <freep>
 ab6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ab8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 abc:	b7d1                	j	a80 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 abe:	6398                	ld	a4,0(a5)
 ac0:	e118                	sd	a4,0(a0)
 ac2:	a899                	j	b18 <malloc+0xd0>
  hp->s.size = nu;
 ac4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ac8:	0541                	addi	a0,a0,16
 aca:	ef9ff0ef          	jal	9c2 <free>
  return freep;
 ace:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 ad0:	c125                	beqz	a0,b30 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ad4:	4798                	lw	a4,8(a5)
 ad6:	03277163          	bgeu	a4,s2,af8 <malloc+0xb0>
    if(p == freep)
 ada:	6098                	ld	a4,0(s1)
 adc:	853e                	mv	a0,a5
 ade:	fef71ae3          	bne	a4,a5,ad2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ae2:	8552                	mv	a0,s4
 ae4:	a3dff0ef          	jal	520 <sbrk>
  if(p == SBRK_ERROR)
 ae8:	fd551ee3          	bne	a0,s5,ac4 <malloc+0x7c>
        return 0;
 aec:	4501                	li	a0,0
 aee:	74a2                	ld	s1,40(sp)
 af0:	6a42                	ld	s4,16(sp)
 af2:	6aa2                	ld	s5,8(sp)
 af4:	6b02                	ld	s6,0(sp)
 af6:	a03d                	j	b24 <malloc+0xdc>
 af8:	74a2                	ld	s1,40(sp)
 afa:	6a42                	ld	s4,16(sp)
 afc:	6aa2                	ld	s5,8(sp)
 afe:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b00:	fae90fe3          	beq	s2,a4,abe <malloc+0x76>
        p->s.size -= nunits;
 b04:	4137073b          	subw	a4,a4,s3
 b08:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b0a:	02071693          	slli	a3,a4,0x20
 b0e:	01c6d713          	srli	a4,a3,0x1c
 b12:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b14:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b18:	00000717          	auipc	a4,0x0
 b1c:	4ea73423          	sd	a0,1256(a4) # 1000 <freep>
      return (void*)(p + 1);
 b20:	01078513          	addi	a0,a5,16
  }
}
 b24:	70e2                	ld	ra,56(sp)
 b26:	7442                	ld	s0,48(sp)
 b28:	7902                	ld	s2,32(sp)
 b2a:	69e2                	ld	s3,24(sp)
 b2c:	6121                	addi	sp,sp,64
 b2e:	8082                	ret
 b30:	74a2                	ld	s1,40(sp)
 b32:	6a42                	ld	s4,16(sp)
 b34:	6aa2                	ld	s5,8(sp)
 b36:	6b02                	ld	s6,0(sp)
 b38:	b7f5                	j	b24 <malloc+0xdc>
