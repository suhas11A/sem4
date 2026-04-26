
user/_tc-array:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <array_sum>:
int arr_size = 10;
int global_sum = 124;
int thread_sums[2] = { 0, 0 };

void array_sum(int *thread_rank)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    int sum = 0;
    if (*thread_rank == 0) {
   8:	00052803          	lw	a6,0(a0)
   c:	08081163          	bnez	a6,8e <array_sum+0x8e>
        for (int i = 0; i < arr_size / 2; i++) {
  10:	00001697          	auipc	a3,0x1
  14:	ff46a683          	lw	a3,-12(a3) # 1004 <arr_size>
  18:	4309                	li	t1,2
  1a:	0266c33b          	divw	t1,a3,t1
  1e:	889a                	mv	a7,t1
  20:	4785                	li	a5,1
  22:	06d7d463          	bge	a5,a3,8a <array_sum+0x8a>
  26:	00001717          	auipc	a4,0x1
  2a:	fea70713          	addi	a4,a4,-22 # 1010 <arr1>
  2e:	87c2                	mv	a5,a6
    int sum = 0;
  30:	8642                	mv	a2,a6
            sum += arr1[i];
  32:	430c                	lw	a1,0(a4)
  34:	9e2d                	addw	a2,a2,a1
        for (int i = 0; i < arr_size / 2; i++) {
  36:	2785                	addiw	a5,a5,1
  38:	0711                	addi	a4,a4,4
  3a:	ff17cce3          	blt	a5,a7,32 <array_sum+0x32>
        }
        for (int i = arr_size / 2; i < arr_size; i++) {
  3e:	02d8d563          	bge	a7,a3,68 <array_sum+0x68>
  42:	00001597          	auipc	a1,0x1
  46:	ff658593          	addi	a1,a1,-10 # 1038 <arr2>
  4a:	00231793          	slli	a5,t1,0x2
  4e:	97ae                	add	a5,a5,a1
  50:	4066873b          	subw	a4,a3,t1
  54:	1702                	slli	a4,a4,0x20
  56:	9301                	srli	a4,a4,0x20
  58:	971a                	add	a4,a4,t1
  5a:	070a                	slli	a4,a4,0x2
  5c:	972e                	add	a4,a4,a1
            sum += arr2[i];
  5e:	4394                	lw	a3,0(a5)
  60:	9e35                	addw	a2,a2,a3
        for (int i = arr_size / 2; i < arr_size; i++) {
  62:	0791                	addi	a5,a5,4
  64:	fee79de3          	bne	a5,a4,5e <array_sum+0x5e>
        for (int i = arr_size / 2; i < arr_size; i++) {
            sum += arr1[i];
        }
    }

    thread_sums[*thread_rank] = sum;
  68:	080a                	slli	a6,a6,0x2
  6a:	00001797          	auipc	a5,0x1
  6e:	ff678793          	addi	a5,a5,-10 # 1060 <thread_sums>
  72:	97c2                	add	a5,a5,a6
  74:	c390                	sw	a2,0(a5)
    printf("Thread Rank: %d, Sum Value: %d\n", *thread_rank, sum);
  76:	410c                	lw	a1,0(a0)
  78:	00001517          	auipc	a0,0x1
  7c:	9e850513          	addi	a0,a0,-1560 # a60 <malloc+0xf6>
  80:	033000ef          	jal	8b2 <printf>
    exit(0);
  84:	4501                	li	a0,0
  86:	402000ef          	jal	488 <exit>
    int sum = 0;
  8a:	8642                	mv	a2,a6
  8c:	bf4d                	j	3e <array_sum+0x3e>
    } else if (*thread_rank == 1) {
  8e:	4785                	li	a5,1
    int sum = 0;
  90:	4601                	li	a2,0
    } else if (*thread_rank == 1) {
  92:	fcf81be3          	bne	a6,a5,68 <array_sum+0x68>
        for (int i = 0; i < arr_size / 2; i++) {
  96:	00001597          	auipc	a1,0x1
  9a:	f6e5a583          	lw	a1,-146(a1) # 1004 <arr_size>
  9e:	4309                	li	t1,2
  a0:	0265c33b          	divw	t1,a1,t1
  a4:	889a                	mv	a7,t1
  a6:	04b7d363          	bge	a5,a1,ec <array_sum+0xec>
  aa:	00001717          	auipc	a4,0x1
  ae:	f8e70713          	addi	a4,a4,-114 # 1038 <arr2>
  b2:	4781                	li	a5,0
            sum += arr2[i];
  b4:	4314                	lw	a3,0(a4)
  b6:	9e35                	addw	a2,a2,a3
        for (int i = 0; i < arr_size / 2; i++) {
  b8:	2785                	addiw	a5,a5,1
  ba:	0711                	addi	a4,a4,4
  bc:	ff17cce3          	blt	a5,a7,b4 <array_sum+0xb4>
        for (int i = arr_size / 2; i < arr_size; i++) {
  c0:	fab8d4e3          	bge	a7,a1,68 <array_sum+0x68>
  c4:	00001697          	auipc	a3,0x1
  c8:	f4c68693          	addi	a3,a3,-180 # 1010 <arr1>
  cc:	00231793          	slli	a5,t1,0x2
  d0:	97b6                	add	a5,a5,a3
  d2:	4065873b          	subw	a4,a1,t1
  d6:	1702                	slli	a4,a4,0x20
  d8:	9301                	srli	a4,a4,0x20
  da:	971a                	add	a4,a4,t1
  dc:	070a                	slli	a4,a4,0x2
  de:	96ba                	add	a3,a3,a4
            sum += arr1[i];
  e0:	4398                	lw	a4,0(a5)
  e2:	9e39                	addw	a2,a2,a4
        for (int i = arr_size / 2; i < arr_size; i++) {
  e4:	0791                	addi	a5,a5,4
  e6:	fed79de3          	bne	a5,a3,e0 <array_sum+0xe0>
  ea:	bfbd                	j	68 <array_sum+0x68>
    int sum = 0;
  ec:	4601                	li	a2,0
  ee:	bfc9                	j	c0 <array_sum+0xc0>

00000000000000f0 <main>:
}

int main(int argc, char *argv[])
{
  f0:	7139                	addi	sp,sp,-64
  f2:	fc06                	sd	ra,56(sp)
  f4:	f822                	sd	s0,48(sp)
  f6:	f426                	sd	s1,40(sp)
  f8:	f04a                	sd	s2,32(sp)
  fa:	ec4e                	sd	s3,24(sp)
  fc:	e852                	sd	s4,16(sp)
  fe:	0080                	addi	s0,sp,64
    printf("Calling Process Print Check\n");
 100:	00001517          	auipc	a0,0x1
 104:	98050513          	addi	a0,a0,-1664 # a80 <malloc+0x116>
 108:	7aa000ef          	jal	8b2 <printf>

    for (int i = 0; i < 2; i++) {
 10c:	fc042623          	sw	zero,-52(s0)
        create_thread(array_sum, &i);
 110:	fcc40a13          	addi	s4,s0,-52
 114:	00000997          	auipc	s3,0x0
 118:	eec98993          	addi	s3,s3,-276 # 0 <array_sum>
        pause(100);
 11c:	06400913          	li	s2,100
    for (int i = 0; i < 2; i++) {
 120:	4485                	li	s1,1
        create_thread(array_sum, &i);
 122:	85d2                	mv	a1,s4
 124:	854e                	mv	a0,s3
 126:	328000ef          	jal	44e <create_thread>
        pause(100);
 12a:	854a                	mv	a0,s2
 12c:	3ec000ef          	jal	518 <pause>
    for (int i = 0; i < 2; i++) {
 130:	fcc42783          	lw	a5,-52(s0)
 134:	2785                	addiw	a5,a5,1
 136:	fcf42623          	sw	a5,-52(s0)
 13a:	fef4d4e3          	bge	s1,a5,122 <main+0x32>
    }

    for (int i = 0; i < 2; i++) {
        join();
 13e:	3f2000ef          	jal	530 <join>
 142:	3ee000ef          	jal	530 <join>
    }

    printf("All threads joined\n");
 146:	00001517          	auipc	a0,0x1
 14a:	96250513          	addi	a0,a0,-1694 # aa8 <malloc+0x13e>
 14e:	764000ef          	jal	8b2 <printf>
    if (thread_sums[0] + thread_sums[1] == global_sum) {
 152:	00001797          	auipc	a5,0x1
 156:	f0e78793          	addi	a5,a5,-242 # 1060 <thread_sums>
 15a:	4398                	lw	a4,0(a5)
 15c:	43cc                	lw	a1,4(a5)
 15e:	9db9                	addw	a1,a1,a4
 160:	00001617          	auipc	a2,0x1
 164:	ea062603          	lw	a2,-352(a2) # 1000 <global_sum>
 168:	00c58b63          	beq	a1,a2,17e <main+0x8e>
        printf(
            "Sum of thread calls is equal to that of both array sums, value: %d\n",
            global_sum);
    } else {
        printf(
 16c:	00001517          	auipc	a0,0x1
 170:	99c50513          	addi	a0,a0,-1636 # b08 <malloc+0x19e>
 174:	73e000ef          	jal	8b2 <printf>
            "Sum of thread calls is not equal to that of both array sums, thread sums: %d and array sum: %d\n",
            thread_sums[0] + thread_sums[1], global_sum);
    }

    exit(0);
 178:	4501                	li	a0,0
 17a:	30e000ef          	jal	488 <exit>
        printf(
 17e:	85b2                	mv	a1,a2
 180:	00001517          	auipc	a0,0x1
 184:	94050513          	addi	a0,a0,-1728 # ac0 <malloc+0x156>
 188:	72a000ef          	jal	8b2 <printf>
 18c:	b7f5                	j	178 <main+0x88>

000000000000018e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e406                	sd	ra,8(sp)
 192:	e022                	sd	s0,0(sp)
 194:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 196:	f5bff0ef          	jal	f0 <main>
  exit(r);
 19a:	2ee000ef          	jal	488 <exit>

000000000000019e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e406                	sd	ra,8(sp)
 1a2:	e022                	sd	s0,0(sp)
 1a4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a6:	87aa                	mv	a5,a0
 1a8:	0585                	addi	a1,a1,1
 1aa:	0785                	addi	a5,a5,1
 1ac:	fff5c703          	lbu	a4,-1(a1)
 1b0:	fee78fa3          	sb	a4,-1(a5)
 1b4:	fb75                	bnez	a4,1a8 <strcpy+0xa>
    ;
  return os;
}
 1b6:	60a2                	ld	ra,8(sp)
 1b8:	6402                	ld	s0,0(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret

00000000000001be <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e406                	sd	ra,8(sp)
 1c2:	e022                	sd	s0,0(sp)
 1c4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	cb91                	beqz	a5,1de <strcmp+0x20>
 1cc:	0005c703          	lbu	a4,0(a1)
 1d0:	00f71763          	bne	a4,a5,1de <strcmp+0x20>
    p++, q++;
 1d4:	0505                	addi	a0,a0,1
 1d6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	fbe5                	bnez	a5,1cc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1de:	0005c503          	lbu	a0,0(a1)
}
 1e2:	40a7853b          	subw	a0,a5,a0
 1e6:	60a2                	ld	ra,8(sp)
 1e8:	6402                	ld	s0,0(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret

00000000000001ee <strlen>:

uint
strlen(const char *s)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e406                	sd	ra,8(sp)
 1f2:	e022                	sd	s0,0(sp)
 1f4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f6:	00054783          	lbu	a5,0(a0)
 1fa:	cf99                	beqz	a5,218 <strlen+0x2a>
 1fc:	0505                	addi	a0,a0,1
 1fe:	87aa                	mv	a5,a0
 200:	86be                	mv	a3,a5
 202:	0785                	addi	a5,a5,1
 204:	fff7c703          	lbu	a4,-1(a5)
 208:	ff65                	bnez	a4,200 <strlen+0x12>
 20a:	40a6853b          	subw	a0,a3,a0
 20e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 210:	60a2                	ld	ra,8(sp)
 212:	6402                	ld	s0,0(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  for(n = 0; s[n]; n++)
 218:	4501                	li	a0,0
 21a:	bfdd                	j	210 <strlen+0x22>

000000000000021c <memset>:

void*
memset(void *dst, int c, uint n)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e406                	sd	ra,8(sp)
 220:	e022                	sd	s0,0(sp)
 222:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 224:	ca19                	beqz	a2,23a <memset+0x1e>
 226:	87aa                	mv	a5,a0
 228:	1602                	slli	a2,a2,0x20
 22a:	9201                	srli	a2,a2,0x20
 22c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 230:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 234:	0785                	addi	a5,a5,1
 236:	fee79de3          	bne	a5,a4,230 <memset+0x14>
  }
  return dst;
}
 23a:	60a2                	ld	ra,8(sp)
 23c:	6402                	ld	s0,0(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret

0000000000000242 <strchr>:

char*
strchr(const char *s, char c)
{
 242:	1141                	addi	sp,sp,-16
 244:	e406                	sd	ra,8(sp)
 246:	e022                	sd	s0,0(sp)
 248:	0800                	addi	s0,sp,16
  for(; *s; s++)
 24a:	00054783          	lbu	a5,0(a0)
 24e:	cf81                	beqz	a5,266 <strchr+0x24>
    if(*s == c)
 250:	00f58763          	beq	a1,a5,25e <strchr+0x1c>
  for(; *s; s++)
 254:	0505                	addi	a0,a0,1
 256:	00054783          	lbu	a5,0(a0)
 25a:	fbfd                	bnez	a5,250 <strchr+0xe>
      return (char*)s;
  return 0;
 25c:	4501                	li	a0,0
}
 25e:	60a2                	ld	ra,8(sp)
 260:	6402                	ld	s0,0(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
  return 0;
 266:	4501                	li	a0,0
 268:	bfdd                	j	25e <strchr+0x1c>

000000000000026a <gets>:

char*
gets(char *buf, int max)
{
 26a:	7159                	addi	sp,sp,-112
 26c:	f486                	sd	ra,104(sp)
 26e:	f0a2                	sd	s0,96(sp)
 270:	eca6                	sd	s1,88(sp)
 272:	e8ca                	sd	s2,80(sp)
 274:	e4ce                	sd	s3,72(sp)
 276:	e0d2                	sd	s4,64(sp)
 278:	fc56                	sd	s5,56(sp)
 27a:	f85a                	sd	s6,48(sp)
 27c:	f45e                	sd	s7,40(sp)
 27e:	f062                	sd	s8,32(sp)
 280:	ec66                	sd	s9,24(sp)
 282:	e86a                	sd	s10,16(sp)
 284:	1880                	addi	s0,sp,112
 286:	8caa                	mv	s9,a0
 288:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28a:	892a                	mv	s2,a0
 28c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 28e:	f9f40b13          	addi	s6,s0,-97
 292:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 294:	4ba9                	li	s7,10
 296:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 298:	8d26                	mv	s10,s1
 29a:	0014899b          	addiw	s3,s1,1
 29e:	84ce                	mv	s1,s3
 2a0:	0349d563          	bge	s3,s4,2ca <gets+0x60>
    cc = read(0, &c, 1);
 2a4:	8656                	mv	a2,s5
 2a6:	85da                	mv	a1,s6
 2a8:	4501                	li	a0,0
 2aa:	1f6000ef          	jal	4a0 <read>
    if(cc < 1)
 2ae:	00a05e63          	blez	a0,2ca <gets+0x60>
    buf[i++] = c;
 2b2:	f9f44783          	lbu	a5,-97(s0)
 2b6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2ba:	01778763          	beq	a5,s7,2c8 <gets+0x5e>
 2be:	0905                	addi	s2,s2,1
 2c0:	fd879ce3          	bne	a5,s8,298 <gets+0x2e>
    buf[i++] = c;
 2c4:	8d4e                	mv	s10,s3
 2c6:	a011                	j	2ca <gets+0x60>
 2c8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 2ca:	9d66                	add	s10,s10,s9
 2cc:	000d0023          	sb	zero,0(s10)
  return buf;
}
 2d0:	8566                	mv	a0,s9
 2d2:	70a6                	ld	ra,104(sp)
 2d4:	7406                	ld	s0,96(sp)
 2d6:	64e6                	ld	s1,88(sp)
 2d8:	6946                	ld	s2,80(sp)
 2da:	69a6                	ld	s3,72(sp)
 2dc:	6a06                	ld	s4,64(sp)
 2de:	7ae2                	ld	s5,56(sp)
 2e0:	7b42                	ld	s6,48(sp)
 2e2:	7ba2                	ld	s7,40(sp)
 2e4:	7c02                	ld	s8,32(sp)
 2e6:	6ce2                	ld	s9,24(sp)
 2e8:	6d42                	ld	s10,16(sp)
 2ea:	6165                	addi	sp,sp,112
 2ec:	8082                	ret

00000000000002ee <stat>:

int
stat(const char *n, struct stat *st)
{
 2ee:	1101                	addi	sp,sp,-32
 2f0:	ec06                	sd	ra,24(sp)
 2f2:	e822                	sd	s0,16(sp)
 2f4:	e04a                	sd	s2,0(sp)
 2f6:	1000                	addi	s0,sp,32
 2f8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2fa:	4581                	li	a1,0
 2fc:	1cc000ef          	jal	4c8 <open>
  if(fd < 0)
 300:	02054263          	bltz	a0,324 <stat+0x36>
 304:	e426                	sd	s1,8(sp)
 306:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 308:	85ca                	mv	a1,s2
 30a:	1d6000ef          	jal	4e0 <fstat>
 30e:	892a                	mv	s2,a0
  close(fd);
 310:	8526                	mv	a0,s1
 312:	19e000ef          	jal	4b0 <close>
  return r;
 316:	64a2                	ld	s1,8(sp)
}
 318:	854a                	mv	a0,s2
 31a:	60e2                	ld	ra,24(sp)
 31c:	6442                	ld	s0,16(sp)
 31e:	6902                	ld	s2,0(sp)
 320:	6105                	addi	sp,sp,32
 322:	8082                	ret
    return -1;
 324:	597d                	li	s2,-1
 326:	bfcd                	j	318 <stat+0x2a>

0000000000000328 <atoi>:

int
atoi(const char *s)
{
 328:	1141                	addi	sp,sp,-16
 32a:	e406                	sd	ra,8(sp)
 32c:	e022                	sd	s0,0(sp)
 32e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 330:	00054683          	lbu	a3,0(a0)
 334:	fd06879b          	addiw	a5,a3,-48
 338:	0ff7f793          	zext.b	a5,a5
 33c:	4625                	li	a2,9
 33e:	02f66963          	bltu	a2,a5,370 <atoi+0x48>
 342:	872a                	mv	a4,a0
  n = 0;
 344:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 346:	0705                	addi	a4,a4,1
 348:	0025179b          	slliw	a5,a0,0x2
 34c:	9fa9                	addw	a5,a5,a0
 34e:	0017979b          	slliw	a5,a5,0x1
 352:	9fb5                	addw	a5,a5,a3
 354:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 358:	00074683          	lbu	a3,0(a4)
 35c:	fd06879b          	addiw	a5,a3,-48
 360:	0ff7f793          	zext.b	a5,a5
 364:	fef671e3          	bgeu	a2,a5,346 <atoi+0x1e>
  return n;
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
  n = 0;
 370:	4501                	li	a0,0
 372:	bfdd                	j	368 <atoi+0x40>

0000000000000374 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 374:	1141                	addi	sp,sp,-16
 376:	e406                	sd	ra,8(sp)
 378:	e022                	sd	s0,0(sp)
 37a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 37c:	02b57563          	bgeu	a0,a1,3a6 <memmove+0x32>
    while(n-- > 0)
 380:	00c05f63          	blez	a2,39e <memmove+0x2a>
 384:	1602                	slli	a2,a2,0x20
 386:	9201                	srli	a2,a2,0x20
 388:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 38c:	872a                	mv	a4,a0
      *dst++ = *src++;
 38e:	0585                	addi	a1,a1,1
 390:	0705                	addi	a4,a4,1
 392:	fff5c683          	lbu	a3,-1(a1)
 396:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 39a:	fee79ae3          	bne	a5,a4,38e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 39e:	60a2                	ld	ra,8(sp)
 3a0:	6402                	ld	s0,0(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret
    dst += n;
 3a6:	00c50733          	add	a4,a0,a2
    src += n;
 3aa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ac:	fec059e3          	blez	a2,39e <memmove+0x2a>
 3b0:	fff6079b          	addiw	a5,a2,-1
 3b4:	1782                	slli	a5,a5,0x20
 3b6:	9381                	srli	a5,a5,0x20
 3b8:	fff7c793          	not	a5,a5
 3bc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3be:	15fd                	addi	a1,a1,-1
 3c0:	177d                	addi	a4,a4,-1
 3c2:	0005c683          	lbu	a3,0(a1)
 3c6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ca:	fef71ae3          	bne	a4,a5,3be <memmove+0x4a>
 3ce:	bfc1                	j	39e <memmove+0x2a>

00000000000003d0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3d0:	1141                	addi	sp,sp,-16
 3d2:	e406                	sd	ra,8(sp)
 3d4:	e022                	sd	s0,0(sp)
 3d6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3d8:	ca0d                	beqz	a2,40a <memcmp+0x3a>
 3da:	fff6069b          	addiw	a3,a2,-1
 3de:	1682                	slli	a3,a3,0x20
 3e0:	9281                	srli	a3,a3,0x20
 3e2:	0685                	addi	a3,a3,1
 3e4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3e6:	00054783          	lbu	a5,0(a0)
 3ea:	0005c703          	lbu	a4,0(a1)
 3ee:	00e79863          	bne	a5,a4,3fe <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 3f2:	0505                	addi	a0,a0,1
    p2++;
 3f4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3f6:	fed518e3          	bne	a0,a3,3e6 <memcmp+0x16>
  }
  return 0;
 3fa:	4501                	li	a0,0
 3fc:	a019                	j	402 <memcmp+0x32>
      return *p1 - *p2;
 3fe:	40e7853b          	subw	a0,a5,a4
}
 402:	60a2                	ld	ra,8(sp)
 404:	6402                	ld	s0,0(sp)
 406:	0141                	addi	sp,sp,16
 408:	8082                	ret
  return 0;
 40a:	4501                	li	a0,0
 40c:	bfdd                	j	402 <memcmp+0x32>

000000000000040e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 40e:	1141                	addi	sp,sp,-16
 410:	e406                	sd	ra,8(sp)
 412:	e022                	sd	s0,0(sp)
 414:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 416:	f5fff0ef          	jal	374 <memmove>
}
 41a:	60a2                	ld	ra,8(sp)
 41c:	6402                	ld	s0,0(sp)
 41e:	0141                	addi	sp,sp,16
 420:	8082                	ret

0000000000000422 <sbrk>:

char *
sbrk(int n) {
 422:	1141                	addi	sp,sp,-16
 424:	e406                	sd	ra,8(sp)
 426:	e022                	sd	s0,0(sp)
 428:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 42a:	4585                	li	a1,1
 42c:	0e4000ef          	jal	510 <sys_sbrk>
}
 430:	60a2                	ld	ra,8(sp)
 432:	6402                	ld	s0,0(sp)
 434:	0141                	addi	sp,sp,16
 436:	8082                	ret

0000000000000438 <sbrklazy>:

char *
sbrklazy(int n) {
 438:	1141                	addi	sp,sp,-16
 43a:	e406                	sd	ra,8(sp)
 43c:	e022                	sd	s0,0(sp)
 43e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 440:	4589                	li	a1,2
 442:	0ce000ef          	jal	510 <sys_sbrk>
}
 446:	60a2                	ld	ra,8(sp)
 448:	6402                	ld	s0,0(sp)
 44a:	0141                	addi	sp,sp,16
 44c:	8082                	ret

000000000000044e <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
 44e:	1101                	addi	sp,sp,-32
 450:	ec06                	sd	ra,24(sp)
 452:	e822                	sd	s0,16(sp)
 454:	e426                	sd	s1,8(sp)
 456:	e04a                	sd	s2,0(sp)
 458:	1000                	addi	s0,sp,32
 45a:	84aa                	mv	s1,a0
 45c:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
 45e:	6505                	lui	a0,0x1
 460:	fc3ff0ef          	jal	422 <sbrk>
 464:	6785                	lui	a5,0x1
 466:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
 46a:	9a41                	andi	a2,a2,-16
 46c:	85ca                	mv	a1,s2
 46e:	8526                	mv	a0,s1
 470:	0b8000ef          	jal	528 <clone>
 474:	60e2                	ld	ra,24(sp)
 476:	6442                	ld	s0,16(sp)
 478:	64a2                	ld	s1,8(sp)
 47a:	6902                	ld	s2,0(sp)
 47c:	6105                	addi	sp,sp,32
 47e:	8082                	ret

0000000000000480 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 480:	4885                	li	a7,1
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <exit>:
.global exit
exit:
 li a7, SYS_exit
 488:	4889                	li	a7,2
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <wait>:
.global wait
wait:
 li a7, SYS_wait
 490:	488d                	li	a7,3
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 498:	4891                	li	a7,4
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <read>:
.global read
read:
 li a7, SYS_read
 4a0:	4895                	li	a7,5
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <write>:
.global write
write:
 li a7, SYS_write
 4a8:	48c1                	li	a7,16
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <close>:
.global close
close:
 li a7, SYS_close
 4b0:	48d5                	li	a7,21
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b8:	4899                	li	a7,6
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c0:	489d                	li	a7,7
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <open>:
.global open
open:
 li a7, SYS_open
 4c8:	48bd                	li	a7,15
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4d0:	48c5                	li	a7,17
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d8:	48c9                	li	a7,18
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e0:	48a1                	li	a7,8
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <link>:
.global link
link:
 li a7, SYS_link
 4e8:	48cd                	li	a7,19
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4f0:	48d1                	li	a7,20
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f8:	48a5                	li	a7,9
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <dup>:
.global dup
dup:
 li a7, SYS_dup
 500:	48a9                	li	a7,10
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 508:	48ad                	li	a7,11
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 510:	48b1                	li	a7,12
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <pause>:
.global pause
pause:
 li a7, SYS_pause
 518:	48b5                	li	a7,13
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 520:	48b9                	li	a7,14
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <clone>:
.global clone
clone:
 li a7, SYS_clone
 528:	48d9                	li	a7,22
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <join>:
.global join
join:
 li a7, SYS_join
 530:	48dd                	li	a7,23
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 538:	1101                	addi	sp,sp,-32
 53a:	ec06                	sd	ra,24(sp)
 53c:	e822                	sd	s0,16(sp)
 53e:	1000                	addi	s0,sp,32
 540:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 544:	4605                	li	a2,1
 546:	fef40593          	addi	a1,s0,-17
 54a:	f5fff0ef          	jal	4a8 <write>
}
 54e:	60e2                	ld	ra,24(sp)
 550:	6442                	ld	s0,16(sp)
 552:	6105                	addi	sp,sp,32
 554:	8082                	ret

0000000000000556 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 556:	715d                	addi	sp,sp,-80
 558:	e486                	sd	ra,72(sp)
 55a:	e0a2                	sd	s0,64(sp)
 55c:	fc26                	sd	s1,56(sp)
 55e:	f84a                	sd	s2,48(sp)
 560:	f44e                	sd	s3,40(sp)
 562:	0880                	addi	s0,sp,80
 564:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 566:	c299                	beqz	a3,56c <printint+0x16>
 568:	0605cc63          	bltz	a1,5e0 <printint+0x8a>
  neg = 0;
 56c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 56e:	fb840313          	addi	t1,s0,-72
  neg = 0;
 572:	869a                	mv	a3,t1
  i = 0;
 574:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 576:	00000817          	auipc	a6,0x0
 57a:	5fa80813          	addi	a6,a6,1530 # b70 <digits>
 57e:	88be                	mv	a7,a5
 580:	0017851b          	addiw	a0,a5,1 # 1001 <global_sum+0x1>
 584:	87aa                	mv	a5,a0
 586:	02c5f733          	remu	a4,a1,a2
 58a:	9742                	add	a4,a4,a6
 58c:	00074703          	lbu	a4,0(a4)
 590:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 594:	872e                	mv	a4,a1
 596:	02c5d5b3          	divu	a1,a1,a2
 59a:	0685                	addi	a3,a3,1
 59c:	fec771e3          	bgeu	a4,a2,57e <printint+0x28>
  if(neg)
 5a0:	000e0c63          	beqz	t3,5b8 <printint+0x62>
    buf[i++] = '-';
 5a4:	fd050793          	addi	a5,a0,-48 # fd0 <digits+0x460>
 5a8:	00878533          	add	a0,a5,s0
 5ac:	02d00793          	li	a5,45
 5b0:	fef50423          	sb	a5,-24(a0)
 5b4:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 5b8:	fff7899b          	addiw	s3,a5,-1
 5bc:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 5c0:	fff4c583          	lbu	a1,-1(s1)
 5c4:	854a                	mv	a0,s2
 5c6:	f73ff0ef          	jal	538 <putc>
  while(--i >= 0)
 5ca:	39fd                	addiw	s3,s3,-1
 5cc:	14fd                	addi	s1,s1,-1
 5ce:	fe09d9e3          	bgez	s3,5c0 <printint+0x6a>
}
 5d2:	60a6                	ld	ra,72(sp)
 5d4:	6406                	ld	s0,64(sp)
 5d6:	74e2                	ld	s1,56(sp)
 5d8:	7942                	ld	s2,48(sp)
 5da:	79a2                	ld	s3,40(sp)
 5dc:	6161                	addi	sp,sp,80
 5de:	8082                	ret
    x = -xx;
 5e0:	40b005b3          	neg	a1,a1
    neg = 1;
 5e4:	4e05                	li	t3,1
    x = -xx;
 5e6:	b761                	j	56e <printint+0x18>

00000000000005e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5e8:	711d                	addi	sp,sp,-96
 5ea:	ec86                	sd	ra,88(sp)
 5ec:	e8a2                	sd	s0,80(sp)
 5ee:	e4a6                	sd	s1,72(sp)
 5f0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f2:	0005c483          	lbu	s1,0(a1)
 5f6:	28048463          	beqz	s1,87e <vprintf+0x296>
 5fa:	e0ca                	sd	s2,64(sp)
 5fc:	fc4e                	sd	s3,56(sp)
 5fe:	f852                	sd	s4,48(sp)
 600:	f456                	sd	s5,40(sp)
 602:	f05a                	sd	s6,32(sp)
 604:	ec5e                	sd	s7,24(sp)
 606:	e862                	sd	s8,16(sp)
 608:	e466                	sd	s9,8(sp)
 60a:	8b2a                	mv	s6,a0
 60c:	8a2e                	mv	s4,a1
 60e:	8bb2                	mv	s7,a2
  state = 0;
 610:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 612:	4901                	li	s2,0
 614:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 616:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 61a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 61e:	06c00c93          	li	s9,108
 622:	a00d                	j	644 <vprintf+0x5c>
        putc(fd, c0);
 624:	85a6                	mv	a1,s1
 626:	855a                	mv	a0,s6
 628:	f11ff0ef          	jal	538 <putc>
 62c:	a019                	j	632 <vprintf+0x4a>
    } else if(state == '%'){
 62e:	03598363          	beq	s3,s5,654 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 632:	0019079b          	addiw	a5,s2,1
 636:	893e                	mv	s2,a5
 638:	873e                	mv	a4,a5
 63a:	97d2                	add	a5,a5,s4
 63c:	0007c483          	lbu	s1,0(a5)
 640:	22048763          	beqz	s1,86e <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 644:	0004879b          	sext.w	a5,s1
    if(state == 0){
 648:	fe0993e3          	bnez	s3,62e <vprintf+0x46>
      if(c0 == '%'){
 64c:	fd579ce3          	bne	a5,s5,624 <vprintf+0x3c>
        state = '%';
 650:	89be                	mv	s3,a5
 652:	b7c5                	j	632 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 654:	00ea06b3          	add	a3,s4,a4
 658:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 65c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 65e:	c681                	beqz	a3,666 <vprintf+0x7e>
 660:	9752                	add	a4,a4,s4
 662:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 666:	05878263          	beq	a5,s8,6aa <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 66a:	05978c63          	beq	a5,s9,6c2 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 66e:	07500713          	li	a4,117
 672:	0ee78663          	beq	a5,a4,75e <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 676:	07800713          	li	a4,120
 67a:	12e78863          	beq	a5,a4,7aa <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 67e:	07000713          	li	a4,112
 682:	14e78d63          	beq	a5,a4,7dc <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 686:	06300713          	li	a4,99
 68a:	18e78c63          	beq	a5,a4,822 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 68e:	07300713          	li	a4,115
 692:	1ae78263          	beq	a5,a4,836 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 696:	02500713          	li	a4,37
 69a:	04e79463          	bne	a5,a4,6e2 <vprintf+0xfa>
        putc(fd, '%');
 69e:	85ba                	mv	a1,a4
 6a0:	855a                	mv	a0,s6
 6a2:	e97ff0ef          	jal	538 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b769                	j	632 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6aa:	008b8493          	addi	s1,s7,8
 6ae:	4685                	li	a3,1
 6b0:	4629                	li	a2,10
 6b2:	000ba583          	lw	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	e9fff0ef          	jal	556 <printint>
 6bc:	8ba6                	mv	s7,s1
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	bf8d                	j	632 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6c2:	06400793          	li	a5,100
 6c6:	02f68963          	beq	a3,a5,6f8 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6ca:	06c00793          	li	a5,108
 6ce:	04f68263          	beq	a3,a5,712 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 6d2:	07500793          	li	a5,117
 6d6:	0af68063          	beq	a3,a5,776 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 6da:	07800793          	li	a5,120
 6de:	0ef68263          	beq	a3,a5,7c2 <vprintf+0x1da>
        putc(fd, '%');
 6e2:	02500593          	li	a1,37
 6e6:	855a                	mv	a0,s6
 6e8:	e51ff0ef          	jal	538 <putc>
        putc(fd, c0);
 6ec:	85a6                	mv	a1,s1
 6ee:	855a                	mv	a0,s6
 6f0:	e49ff0ef          	jal	538 <putc>
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bf35                	j	632 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f8:	008b8493          	addi	s1,s7,8
 6fc:	4685                	li	a3,1
 6fe:	4629                	li	a2,10
 700:	000bb583          	ld	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	e51ff0ef          	jal	556 <printint>
        i += 1;
 70a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 70c:	8ba6                	mv	s7,s1
      state = 0;
 70e:	4981                	li	s3,0
        i += 1;
 710:	b70d                	j	632 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 712:	06400793          	li	a5,100
 716:	02f60763          	beq	a2,a5,744 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 71a:	07500793          	li	a5,117
 71e:	06f60963          	beq	a2,a5,790 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 722:	07800793          	li	a5,120
 726:	faf61ee3          	bne	a2,a5,6e2 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 72a:	008b8493          	addi	s1,s7,8
 72e:	4681                	li	a3,0
 730:	4641                	li	a2,16
 732:	000bb583          	ld	a1,0(s7)
 736:	855a                	mv	a0,s6
 738:	e1fff0ef          	jal	556 <printint>
        i += 2;
 73c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 73e:	8ba6                	mv	s7,s1
      state = 0;
 740:	4981                	li	s3,0
        i += 2;
 742:	bdc5                	j	632 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 744:	008b8493          	addi	s1,s7,8
 748:	4685                	li	a3,1
 74a:	4629                	li	a2,10
 74c:	000bb583          	ld	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	e05ff0ef          	jal	556 <printint>
        i += 2;
 756:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 758:	8ba6                	mv	s7,s1
      state = 0;
 75a:	4981                	li	s3,0
        i += 2;
 75c:	bdd9                	j	632 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 75e:	008b8493          	addi	s1,s7,8
 762:	4681                	li	a3,0
 764:	4629                	li	a2,10
 766:	000be583          	lwu	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	debff0ef          	jal	556 <printint>
 770:	8ba6                	mv	s7,s1
      state = 0;
 772:	4981                	li	s3,0
 774:	bd7d                	j	632 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 776:	008b8493          	addi	s1,s7,8
 77a:	4681                	li	a3,0
 77c:	4629                	li	a2,10
 77e:	000bb583          	ld	a1,0(s7)
 782:	855a                	mv	a0,s6
 784:	dd3ff0ef          	jal	556 <printint>
        i += 1;
 788:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 78a:	8ba6                	mv	s7,s1
      state = 0;
 78c:	4981                	li	s3,0
        i += 1;
 78e:	b555                	j	632 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 790:	008b8493          	addi	s1,s7,8
 794:	4681                	li	a3,0
 796:	4629                	li	a2,10
 798:	000bb583          	ld	a1,0(s7)
 79c:	855a                	mv	a0,s6
 79e:	db9ff0ef          	jal	556 <printint>
        i += 2;
 7a2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a4:	8ba6                	mv	s7,s1
      state = 0;
 7a6:	4981                	li	s3,0
        i += 2;
 7a8:	b569                	j	632 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7aa:	008b8493          	addi	s1,s7,8
 7ae:	4681                	li	a3,0
 7b0:	4641                	li	a2,16
 7b2:	000be583          	lwu	a1,0(s7)
 7b6:	855a                	mv	a0,s6
 7b8:	d9fff0ef          	jal	556 <printint>
 7bc:	8ba6                	mv	s7,s1
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	bd8d                	j	632 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c2:	008b8493          	addi	s1,s7,8
 7c6:	4681                	li	a3,0
 7c8:	4641                	li	a2,16
 7ca:	000bb583          	ld	a1,0(s7)
 7ce:	855a                	mv	a0,s6
 7d0:	d87ff0ef          	jal	556 <printint>
        i += 1;
 7d4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d6:	8ba6                	mv	s7,s1
      state = 0;
 7d8:	4981                	li	s3,0
        i += 1;
 7da:	bda1                	j	632 <vprintf+0x4a>
 7dc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7de:	008b8d13          	addi	s10,s7,8
 7e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7e6:	03000593          	li	a1,48
 7ea:	855a                	mv	a0,s6
 7ec:	d4dff0ef          	jal	538 <putc>
  putc(fd, 'x');
 7f0:	07800593          	li	a1,120
 7f4:	855a                	mv	a0,s6
 7f6:	d43ff0ef          	jal	538 <putc>
 7fa:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7fc:	00000b97          	auipc	s7,0x0
 800:	374b8b93          	addi	s7,s7,884 # b70 <digits>
 804:	03c9d793          	srli	a5,s3,0x3c
 808:	97de                	add	a5,a5,s7
 80a:	0007c583          	lbu	a1,0(a5)
 80e:	855a                	mv	a0,s6
 810:	d29ff0ef          	jal	538 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 814:	0992                	slli	s3,s3,0x4
 816:	34fd                	addiw	s1,s1,-1
 818:	f4f5                	bnez	s1,804 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 81a:	8bea                	mv	s7,s10
      state = 0;
 81c:	4981                	li	s3,0
 81e:	6d02                	ld	s10,0(sp)
 820:	bd09                	j	632 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 822:	008b8493          	addi	s1,s7,8
 826:	000bc583          	lbu	a1,0(s7)
 82a:	855a                	mv	a0,s6
 82c:	d0dff0ef          	jal	538 <putc>
 830:	8ba6                	mv	s7,s1
      state = 0;
 832:	4981                	li	s3,0
 834:	bbfd                	j	632 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 836:	008b8993          	addi	s3,s7,8
 83a:	000bb483          	ld	s1,0(s7)
 83e:	cc91                	beqz	s1,85a <vprintf+0x272>
        for(; *s; s++)
 840:	0004c583          	lbu	a1,0(s1)
 844:	c195                	beqz	a1,868 <vprintf+0x280>
          putc(fd, *s);
 846:	855a                	mv	a0,s6
 848:	cf1ff0ef          	jal	538 <putc>
        for(; *s; s++)
 84c:	0485                	addi	s1,s1,1
 84e:	0004c583          	lbu	a1,0(s1)
 852:	f9f5                	bnez	a1,846 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 854:	8bce                	mv	s7,s3
      state = 0;
 856:	4981                	li	s3,0
 858:	bbe9                	j	632 <vprintf+0x4a>
          s = "(null)";
 85a:	00000497          	auipc	s1,0x0
 85e:	30e48493          	addi	s1,s1,782 # b68 <malloc+0x1fe>
        for(; *s; s++)
 862:	02800593          	li	a1,40
 866:	b7c5                	j	846 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 868:	8bce                	mv	s7,s3
      state = 0;
 86a:	4981                	li	s3,0
 86c:	b3d9                	j	632 <vprintf+0x4a>
 86e:	6906                	ld	s2,64(sp)
 870:	79e2                	ld	s3,56(sp)
 872:	7a42                	ld	s4,48(sp)
 874:	7aa2                	ld	s5,40(sp)
 876:	7b02                	ld	s6,32(sp)
 878:	6be2                	ld	s7,24(sp)
 87a:	6c42                	ld	s8,16(sp)
 87c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 87e:	60e6                	ld	ra,88(sp)
 880:	6446                	ld	s0,80(sp)
 882:	64a6                	ld	s1,72(sp)
 884:	6125                	addi	sp,sp,96
 886:	8082                	ret

0000000000000888 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 888:	715d                	addi	sp,sp,-80
 88a:	ec06                	sd	ra,24(sp)
 88c:	e822                	sd	s0,16(sp)
 88e:	1000                	addi	s0,sp,32
 890:	e010                	sd	a2,0(s0)
 892:	e414                	sd	a3,8(s0)
 894:	e818                	sd	a4,16(s0)
 896:	ec1c                	sd	a5,24(s0)
 898:	03043023          	sd	a6,32(s0)
 89c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8a0:	8622                	mv	a2,s0
 8a2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8a6:	d43ff0ef          	jal	5e8 <vprintf>
}
 8aa:	60e2                	ld	ra,24(sp)
 8ac:	6442                	ld	s0,16(sp)
 8ae:	6161                	addi	sp,sp,80
 8b0:	8082                	ret

00000000000008b2 <printf>:

void
printf(const char *fmt, ...)
{
 8b2:	711d                	addi	sp,sp,-96
 8b4:	ec06                	sd	ra,24(sp)
 8b6:	e822                	sd	s0,16(sp)
 8b8:	1000                	addi	s0,sp,32
 8ba:	e40c                	sd	a1,8(s0)
 8bc:	e810                	sd	a2,16(s0)
 8be:	ec14                	sd	a3,24(s0)
 8c0:	f018                	sd	a4,32(s0)
 8c2:	f41c                	sd	a5,40(s0)
 8c4:	03043823          	sd	a6,48(s0)
 8c8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8cc:	00840613          	addi	a2,s0,8
 8d0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8d4:	85aa                	mv	a1,a0
 8d6:	4505                	li	a0,1
 8d8:	d11ff0ef          	jal	5e8 <vprintf>
}
 8dc:	60e2                	ld	ra,24(sp)
 8de:	6442                	ld	s0,16(sp)
 8e0:	6125                	addi	sp,sp,96
 8e2:	8082                	ret

00000000000008e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e4:	1141                	addi	sp,sp,-16
 8e6:	e406                	sd	ra,8(sp)
 8e8:	e022                	sd	s0,0(sp)
 8ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f0:	00000797          	auipc	a5,0x0
 8f4:	7787b783          	ld	a5,1912(a5) # 1068 <freep>
 8f8:	a02d                	j	922 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8fa:	4618                	lw	a4,8(a2)
 8fc:	9f2d                	addw	a4,a4,a1
 8fe:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 902:	6398                	ld	a4,0(a5)
 904:	6310                	ld	a2,0(a4)
 906:	a83d                	j	944 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 908:	ff852703          	lw	a4,-8(a0)
 90c:	9f31                	addw	a4,a4,a2
 90e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 910:	ff053683          	ld	a3,-16(a0)
 914:	a091                	j	958 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 916:	6398                	ld	a4,0(a5)
 918:	00e7e463          	bltu	a5,a4,920 <free+0x3c>
 91c:	00e6ea63          	bltu	a3,a4,930 <free+0x4c>
{
 920:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 922:	fed7fae3          	bgeu	a5,a3,916 <free+0x32>
 926:	6398                	ld	a4,0(a5)
 928:	00e6e463          	bltu	a3,a4,930 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92c:	fee7eae3          	bltu	a5,a4,920 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 930:	ff852583          	lw	a1,-8(a0)
 934:	6390                	ld	a2,0(a5)
 936:	02059813          	slli	a6,a1,0x20
 93a:	01c85713          	srli	a4,a6,0x1c
 93e:	9736                	add	a4,a4,a3
 940:	fae60de3          	beq	a2,a4,8fa <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 944:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 948:	4790                	lw	a2,8(a5)
 94a:	02061593          	slli	a1,a2,0x20
 94e:	01c5d713          	srli	a4,a1,0x1c
 952:	973e                	add	a4,a4,a5
 954:	fae68ae3          	beq	a3,a4,908 <free+0x24>
    p->s.ptr = bp->s.ptr;
 958:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 95a:	00000717          	auipc	a4,0x0
 95e:	70f73723          	sd	a5,1806(a4) # 1068 <freep>
}
 962:	60a2                	ld	ra,8(sp)
 964:	6402                	ld	s0,0(sp)
 966:	0141                	addi	sp,sp,16
 968:	8082                	ret

000000000000096a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 96a:	7139                	addi	sp,sp,-64
 96c:	fc06                	sd	ra,56(sp)
 96e:	f822                	sd	s0,48(sp)
 970:	f04a                	sd	s2,32(sp)
 972:	ec4e                	sd	s3,24(sp)
 974:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 976:	02051993          	slli	s3,a0,0x20
 97a:	0209d993          	srli	s3,s3,0x20
 97e:	09bd                	addi	s3,s3,15
 980:	0049d993          	srli	s3,s3,0x4
 984:	2985                	addiw	s3,s3,1
 986:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 988:	00000517          	auipc	a0,0x0
 98c:	6e053503          	ld	a0,1760(a0) # 1068 <freep>
 990:	c905                	beqz	a0,9c0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 992:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 994:	4798                	lw	a4,8(a5)
 996:	09377663          	bgeu	a4,s3,a22 <malloc+0xb8>
 99a:	f426                	sd	s1,40(sp)
 99c:	e852                	sd	s4,16(sp)
 99e:	e456                	sd	s5,8(sp)
 9a0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9a2:	8a4e                	mv	s4,s3
 9a4:	6705                	lui	a4,0x1
 9a6:	00e9f363          	bgeu	s3,a4,9ac <malloc+0x42>
 9aa:	6a05                	lui	s4,0x1
 9ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b4:	00000497          	auipc	s1,0x0
 9b8:	6b448493          	addi	s1,s1,1716 # 1068 <freep>
  if(p == SBRK_ERROR)
 9bc:	5afd                	li	s5,-1
 9be:	a83d                	j	9fc <malloc+0x92>
 9c0:	f426                	sd	s1,40(sp)
 9c2:	e852                	sd	s4,16(sp)
 9c4:	e456                	sd	s5,8(sp)
 9c6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9c8:	00000797          	auipc	a5,0x0
 9cc:	6a878793          	addi	a5,a5,1704 # 1070 <base>
 9d0:	00000717          	auipc	a4,0x0
 9d4:	68f73c23          	sd	a5,1688(a4) # 1068 <freep>
 9d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9de:	b7d1                	j	9a2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9e0:	6398                	ld	a4,0(a5)
 9e2:	e118                	sd	a4,0(a0)
 9e4:	a899                	j	a3a <malloc+0xd0>
  hp->s.size = nu;
 9e6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9ea:	0541                	addi	a0,a0,16
 9ec:	ef9ff0ef          	jal	8e4 <free>
  return freep;
 9f0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9f2:	c125                	beqz	a0,a52 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f6:	4798                	lw	a4,8(a5)
 9f8:	03277163          	bgeu	a4,s2,a1a <malloc+0xb0>
    if(p == freep)
 9fc:	6098                	ld	a4,0(s1)
 9fe:	853e                	mv	a0,a5
 a00:	fef71ae3          	bne	a4,a5,9f4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a04:	8552                	mv	a0,s4
 a06:	a1dff0ef          	jal	422 <sbrk>
  if(p == SBRK_ERROR)
 a0a:	fd551ee3          	bne	a0,s5,9e6 <malloc+0x7c>
        return 0;
 a0e:	4501                	li	a0,0
 a10:	74a2                	ld	s1,40(sp)
 a12:	6a42                	ld	s4,16(sp)
 a14:	6aa2                	ld	s5,8(sp)
 a16:	6b02                	ld	s6,0(sp)
 a18:	a03d                	j	a46 <malloc+0xdc>
 a1a:	74a2                	ld	s1,40(sp)
 a1c:	6a42                	ld	s4,16(sp)
 a1e:	6aa2                	ld	s5,8(sp)
 a20:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a22:	fae90fe3          	beq	s2,a4,9e0 <malloc+0x76>
        p->s.size -= nunits;
 a26:	4137073b          	subw	a4,a4,s3
 a2a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a2c:	02071693          	slli	a3,a4,0x20
 a30:	01c6d713          	srli	a4,a3,0x1c
 a34:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a36:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a3a:	00000717          	auipc	a4,0x0
 a3e:	62a73723          	sd	a0,1582(a4) # 1068 <freep>
      return (void*)(p + 1);
 a42:	01078513          	addi	a0,a5,16
  }
}
 a46:	70e2                	ld	ra,56(sp)
 a48:	7442                	ld	s0,48(sp)
 a4a:	7902                	ld	s2,32(sp)
 a4c:	69e2                	ld	s3,24(sp)
 a4e:	6121                	addi	sp,sp,64
 a50:	8082                	ret
 a52:	74a2                	ld	s1,40(sp)
 a54:	6a42                	ld	s4,16(sp)
 a56:	6aa2                	ld	s5,8(sp)
 a58:	6b02                	ld	s6,0(sp)
 a5a:	b7f5                	j	a46 <malloc+0xdc>
