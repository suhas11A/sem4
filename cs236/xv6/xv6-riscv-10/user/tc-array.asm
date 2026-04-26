
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
  7c:	b4850513          	addi	a0,a0,-1208 # bc0 <malloc+0x100>
  80:	189000ef          	jal	a08 <printf>
    exit(0);
  84:	4501                	li	a0,0
  86:	548000ef          	jal	5ce <exit>
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
 104:	ae050513          	addi	a0,a0,-1312 # be0 <malloc+0x120>
 108:	101000ef          	jal	a08 <printf>

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
 12c:	532000ef          	jal	65e <pause>
    for (int i = 0; i < 2; i++) {
 130:	fcc42783          	lw	a5,-52(s0)
 134:	2785                	addiw	a5,a5,1
 136:	fcf42623          	sw	a5,-52(s0)
 13a:	fef4d4e3          	bge	s1,a5,122 <main+0x32>
    }

    for (int i = 0; i < 2; i++) {
        join();
 13e:	538000ef          	jal	676 <join>
 142:	534000ef          	jal	676 <join>
    }

    printf("All threads joined\n");
 146:	00001517          	auipc	a0,0x1
 14a:	ac250513          	addi	a0,a0,-1342 # c08 <malloc+0x148>
 14e:	0bb000ef          	jal	a08 <printf>
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
 170:	afc50513          	addi	a0,a0,-1284 # c68 <malloc+0x1a8>
 174:	095000ef          	jal	a08 <printf>
            "Sum of thread calls is not equal to that of both array sums, thread sums: %d and array sum: %d\n",
            thread_sums[0] + thread_sums[1], global_sum);
    }

    exit(0);
 178:	4501                	li	a0,0
 17a:	454000ef          	jal	5ce <exit>
        printf(
 17e:	85b2                	mv	a1,a2
 180:	00001517          	auipc	a0,0x1
 184:	aa050513          	addi	a0,a0,-1376 # c20 <malloc+0x160>
 188:	081000ef          	jal	a08 <printf>
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
 19a:	434000ef          	jal	5ce <exit>

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
 2aa:	33c000ef          	jal	5e6 <read>
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
 2fc:	312000ef          	jal	60e <open>
  if(fd < 0)
 300:	02054263          	bltz	a0,324 <stat+0x36>
 304:	e426                	sd	s1,8(sp)
 306:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 308:	85ca                	mv	a1,s2
 30a:	31c000ef          	jal	626 <fstat>
 30e:	892a                	mv	s2,a0
  close(fd);
 310:	8526                	mv	a0,s1
 312:	2e4000ef          	jal	5f6 <close>
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
 42c:	22a000ef          	jal	656 <sys_sbrk>
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
 442:	214000ef          	jal	656 <sys_sbrk>
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
 470:	1fe000ef          	jal	66e <clone>
}
 474:	60e2                	ld	ra,24(sp)
 476:	6442                	ld	s0,16(sp)
 478:	64a2                	ld	s1,8(sp)
 47a:	6902                	ld	s2,0(sp)
 47c:	6105                	addi	sp,sp,32
 47e:	8082                	ret

0000000000000480 <futex>:

void futex(int *uaddr, int ops, int val) {
 480:	7179                	addi	sp,sp,-48
 482:	f406                	sd	ra,40(sp)
 484:	f022                	sd	s0,32(sp)
 486:	ec26                	sd	s1,24(sp)
 488:	1800                	addi	s0,sp,48
 48a:	84aa                	mv	s1,a0
  if (ops==0) {
 48c:	ed95                	bnez	a1,4c8 <futex+0x48>
    if (val==0) {
 48e:	c611                	beqz	a2,49a <futex+0x1a>
 490:	e84a                	sd	s2,16(sp)
 492:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 494:	4905                	li	s2,1
        futex_wait(uaddr, 1);
 496:	4985                	li	s3,1
 498:	a005                	j	4b8 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
 49a:	4705                	li	a4,1
 49c:	87ba                	mv	a5,a4
 49e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 4a2:	2781                	sext.w	a5,a5
 4a4:	ffe5                	bnez	a5,49c <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
 4a6:	70a2                	ld	ra,40(sp)
 4a8:	7402                	ld	s0,32(sp)
 4aa:	64e2                	ld	s1,24(sp)
 4ac:	6145                	addi	sp,sp,48
 4ae:	8082                	ret
        futex_wait(uaddr, 1);
 4b0:	85ce                	mv	a1,s3
 4b2:	8526                	mv	a0,s1
 4b4:	1ca000ef          	jal	67e <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
 4b8:	87ca                	mv	a5,s2
 4ba:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
 4be:	2781                	sext.w	a5,a5
 4c0:	fbe5                	bnez	a5,4b0 <futex+0x30>
 4c2:	6942                	ld	s2,16(sp)
 4c4:	69a2                	ld	s3,8(sp)
 4c6:	b7c5                	j	4a6 <futex+0x26>
    if (val==0) {
 4c8:	e611                	bnez	a2,4d4 <futex+0x54>
      __sync_lock_release(uaddr);
 4ca:	0310000f          	fence	rw,w
 4ce:	00052023          	sw	zero,0(a0) # 1000 <global_sum>
 4d2:	bfd1                	j	4a6 <futex+0x26>
      __sync_lock_release(uaddr);
 4d4:	0310000f          	fence	rw,w
 4d8:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
 4dc:	1aa000ef          	jal	686 <futex_wake>
  return;
 4e0:	b7d9                	j	4a6 <futex+0x26>

00000000000004e2 <sem_init>:

void sem_init(sem_t* s, int val) {
 4e2:	7179                	addi	sp,sp,-48
 4e4:	f406                	sd	ra,40(sp)
 4e6:	f022                	sd	s0,32(sp)
 4e8:	ec26                	sd	s1,24(sp)
 4ea:	e84a                	sd	s2,16(sp)
 4ec:	e44e                	sd	s3,8(sp)
 4ee:	1800                	addi	s0,sp,48
 4f0:	84aa                	mv	s1,a0
 4f2:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
 4f4:	00450993          	addi	s3,a0,4
 4f8:	4605                	li	a2,1
 4fa:	4581                	li	a1,0
 4fc:	854e                	mv	a0,s3
 4fe:	f83ff0ef          	jal	480 <futex>
  s->value = val;
 502:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
 506:	4605                	li	a2,1
 508:	85b2                	mv	a1,a2
 50a:	854e                	mv	a0,s3
 50c:	f75ff0ef          	jal	480 <futex>
  return;
}
 510:	70a2                	ld	ra,40(sp)
 512:	7402                	ld	s0,32(sp)
 514:	64e2                	ld	s1,24(sp)
 516:	6942                	ld	s2,16(sp)
 518:	69a2                	ld	s3,8(sp)
 51a:	6145                	addi	sp,sp,48
 51c:	8082                	ret

000000000000051e <sem_down>:

void sem_down(sem_t* s) {
 51e:	7179                	addi	sp,sp,-48
 520:	f406                	sd	ra,40(sp)
 522:	f022                	sd	s0,32(sp)
 524:	ec26                	sd	s1,24(sp)
 526:	e84a                	sd	s2,16(sp)
 528:	e44e                	sd	s3,8(sp)
 52a:	1800                	addi	s0,sp,48
 52c:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 52e:	00450993          	addi	s3,a0,4
 532:	4605                	li	a2,1
 534:	4581                	li	a1,0
 536:	854e                	mv	a0,s3
 538:	f49ff0ef          	jal	480 <futex>
  while(1) {
    if (s->value>0) {
 53c:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
 540:	4485                	li	s1,1
    if (s->value>0) {
 542:	02f04463          	bgtz	a5,56a <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
 546:	8626                	mv	a2,s1
 548:	85a6                	mv	a1,s1
 54a:	854e                	mv	a0,s3
 54c:	f35ff0ef          	jal	480 <futex>
      futex_wait(&s->value,1);
 550:	85a6                	mv	a1,s1
 552:	854a                	mv	a0,s2
 554:	12a000ef          	jal	67e <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
 558:	8626                	mv	a2,s1
 55a:	4581                	li	a1,0
 55c:	854e                	mv	a0,s3
 55e:	f23ff0ef          	jal	480 <futex>
    if (s->value>0) {
 562:	00092783          	lw	a5,0(s2)
 566:	fef050e3          	blez	a5,546 <sem_down+0x28>
      s->value--;
 56a:	37fd                	addiw	a5,a5,-1 # fff <digits+0x32f>
 56c:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
 570:	4605                	li	a2,1
 572:	85b2                	mv	a1,a2
 574:	854e                	mv	a0,s3
 576:	f0bff0ef          	jal	480 <futex>
  return;
}
 57a:	70a2                	ld	ra,40(sp)
 57c:	7402                	ld	s0,32(sp)
 57e:	64e2                	ld	s1,24(sp)
 580:	6942                	ld	s2,16(sp)
 582:	69a2                	ld	s3,8(sp)
 584:	6145                	addi	sp,sp,48
 586:	8082                	ret

0000000000000588 <sem_up>:

void sem_up(sem_t* s) {
 588:	1101                	addi	sp,sp,-32
 58a:	ec06                	sd	ra,24(sp)
 58c:	e822                	sd	s0,16(sp)
 58e:	e426                	sd	s1,8(sp)
 590:	e04a                	sd	s2,0(sp)
 592:	1000                	addi	s0,sp,32
 594:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
 596:	00450913          	addi	s2,a0,4
 59a:	4605                	li	a2,1
 59c:	4581                	li	a1,0
 59e:	854a                	mv	a0,s2
 5a0:	ee1ff0ef          	jal	480 <futex>
  s->value++;
 5a4:	409c                	lw	a5,0(s1)
 5a6:	2785                	addiw	a5,a5,1
 5a8:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
 5aa:	8526                	mv	a0,s1
 5ac:	0da000ef          	jal	686 <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
 5b0:	4605                	li	a2,1
 5b2:	85b2                	mv	a1,a2
 5b4:	854a                	mv	a0,s2
 5b6:	ecbff0ef          	jal	480 <futex>
  return;
 5ba:	60e2                	ld	ra,24(sp)
 5bc:	6442                	ld	s0,16(sp)
 5be:	64a2                	ld	s1,8(sp)
 5c0:	6902                	ld	s2,0(sp)
 5c2:	6105                	addi	sp,sp,32
 5c4:	8082                	ret

00000000000005c6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5c6:	4885                	li	a7,1
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <exit>:
.global exit
exit:
 li a7, SYS_exit
 5ce:	4889                	li	a7,2
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5d6:	488d                	li	a7,3
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5de:	4891                	li	a7,4
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <read>:
.global read
read:
 li a7, SYS_read
 5e6:	4895                	li	a7,5
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <write>:
.global write
write:
 li a7, SYS_write
 5ee:	48c1                	li	a7,16
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <close>:
.global close
close:
 li a7, SYS_close
 5f6:	48d5                	li	a7,21
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <kill>:
.global kill
kill:
 li a7, SYS_kill
 5fe:	4899                	li	a7,6
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <exec>:
.global exec
exec:
 li a7, SYS_exec
 606:	489d                	li	a7,7
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <open>:
.global open
open:
 li a7, SYS_open
 60e:	48bd                	li	a7,15
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 616:	48c5                	li	a7,17
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 61e:	48c9                	li	a7,18
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 626:	48a1                	li	a7,8
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <link>:
.global link
link:
 li a7, SYS_link
 62e:	48cd                	li	a7,19
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 636:	48d1                	li	a7,20
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 63e:	48a5                	li	a7,9
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <dup>:
.global dup
dup:
 li a7, SYS_dup
 646:	48a9                	li	a7,10
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 64e:	48ad                	li	a7,11
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 656:	48b1                	li	a7,12
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <pause>:
.global pause
pause:
 li a7, SYS_pause
 65e:	48b5                	li	a7,13
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 666:	48b9                	li	a7,14
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <clone>:
.global clone
clone:
 li a7, SYS_clone
 66e:	48d9                	li	a7,22
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <join>:
.global join
join:
 li a7, SYS_join
 676:	48dd                	li	a7,23
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
 67e:	48e1                	li	a7,24
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
 686:	48e5                	li	a7,25
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 68e:	1101                	addi	sp,sp,-32
 690:	ec06                	sd	ra,24(sp)
 692:	e822                	sd	s0,16(sp)
 694:	1000                	addi	s0,sp,32
 696:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 69a:	4605                	li	a2,1
 69c:	fef40593          	addi	a1,s0,-17
 6a0:	f4fff0ef          	jal	5ee <write>
}
 6a4:	60e2                	ld	ra,24(sp)
 6a6:	6442                	ld	s0,16(sp)
 6a8:	6105                	addi	sp,sp,32
 6aa:	8082                	ret

00000000000006ac <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 6ac:	715d                	addi	sp,sp,-80
 6ae:	e486                	sd	ra,72(sp)
 6b0:	e0a2                	sd	s0,64(sp)
 6b2:	fc26                	sd	s1,56(sp)
 6b4:	f84a                	sd	s2,48(sp)
 6b6:	f44e                	sd	s3,40(sp)
 6b8:	0880                	addi	s0,sp,80
 6ba:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 6bc:	c299                	beqz	a3,6c2 <printint+0x16>
 6be:	0605cc63          	bltz	a1,736 <printint+0x8a>
  neg = 0;
 6c2:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 6c4:	fb840313          	addi	t1,s0,-72
  neg = 0;
 6c8:	869a                	mv	a3,t1
  i = 0;
 6ca:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 6cc:	00000817          	auipc	a6,0x0
 6d0:	60480813          	addi	a6,a6,1540 # cd0 <digits>
 6d4:	88be                	mv	a7,a5
 6d6:	0017851b          	addiw	a0,a5,1
 6da:	87aa                	mv	a5,a0
 6dc:	02c5f733          	remu	a4,a1,a2
 6e0:	9742                	add	a4,a4,a6
 6e2:	00074703          	lbu	a4,0(a4)
 6e6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 6ea:	872e                	mv	a4,a1
 6ec:	02c5d5b3          	divu	a1,a1,a2
 6f0:	0685                	addi	a3,a3,1
 6f2:	fec771e3          	bgeu	a4,a2,6d4 <printint+0x28>
  if(neg)
 6f6:	000e0c63          	beqz	t3,70e <printint+0x62>
    buf[i++] = '-';
 6fa:	fd050793          	addi	a5,a0,-48
 6fe:	00878533          	add	a0,a5,s0
 702:	02d00793          	li	a5,45
 706:	fef50423          	sb	a5,-24(a0)
 70a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 70e:	fff7899b          	addiw	s3,a5,-1
 712:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 716:	fff4c583          	lbu	a1,-1(s1)
 71a:	854a                	mv	a0,s2
 71c:	f73ff0ef          	jal	68e <putc>
  while(--i >= 0)
 720:	39fd                	addiw	s3,s3,-1
 722:	14fd                	addi	s1,s1,-1
 724:	fe09d9e3          	bgez	s3,716 <printint+0x6a>
}
 728:	60a6                	ld	ra,72(sp)
 72a:	6406                	ld	s0,64(sp)
 72c:	74e2                	ld	s1,56(sp)
 72e:	7942                	ld	s2,48(sp)
 730:	79a2                	ld	s3,40(sp)
 732:	6161                	addi	sp,sp,80
 734:	8082                	ret
    x = -xx;
 736:	40b005b3          	neg	a1,a1
    neg = 1;
 73a:	4e05                	li	t3,1
    x = -xx;
 73c:	b761                	j	6c4 <printint+0x18>

000000000000073e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 73e:	711d                	addi	sp,sp,-96
 740:	ec86                	sd	ra,88(sp)
 742:	e8a2                	sd	s0,80(sp)
 744:	e4a6                	sd	s1,72(sp)
 746:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 748:	0005c483          	lbu	s1,0(a1)
 74c:	28048463          	beqz	s1,9d4 <vprintf+0x296>
 750:	e0ca                	sd	s2,64(sp)
 752:	fc4e                	sd	s3,56(sp)
 754:	f852                	sd	s4,48(sp)
 756:	f456                	sd	s5,40(sp)
 758:	f05a                	sd	s6,32(sp)
 75a:	ec5e                	sd	s7,24(sp)
 75c:	e862                	sd	s8,16(sp)
 75e:	e466                	sd	s9,8(sp)
 760:	8b2a                	mv	s6,a0
 762:	8a2e                	mv	s4,a1
 764:	8bb2                	mv	s7,a2
  state = 0;
 766:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 768:	4901                	li	s2,0
 76a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 76c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 770:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 774:	06c00c93          	li	s9,108
 778:	a00d                	j	79a <vprintf+0x5c>
        putc(fd, c0);
 77a:	85a6                	mv	a1,s1
 77c:	855a                	mv	a0,s6
 77e:	f11ff0ef          	jal	68e <putc>
 782:	a019                	j	788 <vprintf+0x4a>
    } else if(state == '%'){
 784:	03598363          	beq	s3,s5,7aa <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 788:	0019079b          	addiw	a5,s2,1
 78c:	893e                	mv	s2,a5
 78e:	873e                	mv	a4,a5
 790:	97d2                	add	a5,a5,s4
 792:	0007c483          	lbu	s1,0(a5)
 796:	22048763          	beqz	s1,9c4 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 79a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 79e:	fe0993e3          	bnez	s3,784 <vprintf+0x46>
      if(c0 == '%'){
 7a2:	fd579ce3          	bne	a5,s5,77a <vprintf+0x3c>
        state = '%';
 7a6:	89be                	mv	s3,a5
 7a8:	b7c5                	j	788 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 7aa:	00ea06b3          	add	a3,s4,a4
 7ae:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 7b2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 7b4:	c681                	beqz	a3,7bc <vprintf+0x7e>
 7b6:	9752                	add	a4,a4,s4
 7b8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 7bc:	05878263          	beq	a5,s8,800 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 7c0:	05978c63          	beq	a5,s9,818 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 7c4:	07500713          	li	a4,117
 7c8:	0ee78663          	beq	a5,a4,8b4 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 7cc:	07800713          	li	a4,120
 7d0:	12e78863          	beq	a5,a4,900 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7d4:	07000713          	li	a4,112
 7d8:	14e78d63          	beq	a5,a4,932 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 7dc:	06300713          	li	a4,99
 7e0:	18e78c63          	beq	a5,a4,978 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 7e4:	07300713          	li	a4,115
 7e8:	1ae78263          	beq	a5,a4,98c <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7ec:	02500713          	li	a4,37
 7f0:	04e79463          	bne	a5,a4,838 <vprintf+0xfa>
        putc(fd, '%');
 7f4:	85ba                	mv	a1,a4
 7f6:	855a                	mv	a0,s6
 7f8:	e97ff0ef          	jal	68e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	b769                	j	788 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 800:	008b8493          	addi	s1,s7,8
 804:	4685                	li	a3,1
 806:	4629                	li	a2,10
 808:	000ba583          	lw	a1,0(s7)
 80c:	855a                	mv	a0,s6
 80e:	e9fff0ef          	jal	6ac <printint>
 812:	8ba6                	mv	s7,s1
      state = 0;
 814:	4981                	li	s3,0
 816:	bf8d                	j	788 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 818:	06400793          	li	a5,100
 81c:	02f68963          	beq	a3,a5,84e <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 820:	06c00793          	li	a5,108
 824:	04f68263          	beq	a3,a5,868 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 828:	07500793          	li	a5,117
 82c:	0af68063          	beq	a3,a5,8cc <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 830:	07800793          	li	a5,120
 834:	0ef68263          	beq	a3,a5,918 <vprintf+0x1da>
        putc(fd, '%');
 838:	02500593          	li	a1,37
 83c:	855a                	mv	a0,s6
 83e:	e51ff0ef          	jal	68e <putc>
        putc(fd, c0);
 842:	85a6                	mv	a1,s1
 844:	855a                	mv	a0,s6
 846:	e49ff0ef          	jal	68e <putc>
      state = 0;
 84a:	4981                	li	s3,0
 84c:	bf35                	j	788 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 84e:	008b8493          	addi	s1,s7,8
 852:	4685                	li	a3,1
 854:	4629                	li	a2,10
 856:	000bb583          	ld	a1,0(s7)
 85a:	855a                	mv	a0,s6
 85c:	e51ff0ef          	jal	6ac <printint>
        i += 1;
 860:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 862:	8ba6                	mv	s7,s1
      state = 0;
 864:	4981                	li	s3,0
        i += 1;
 866:	b70d                	j	788 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 868:	06400793          	li	a5,100
 86c:	02f60763          	beq	a2,a5,89a <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 870:	07500793          	li	a5,117
 874:	06f60963          	beq	a2,a5,8e6 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 878:	07800793          	li	a5,120
 87c:	faf61ee3          	bne	a2,a5,838 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 880:	008b8493          	addi	s1,s7,8
 884:	4681                	li	a3,0
 886:	4641                	li	a2,16
 888:	000bb583          	ld	a1,0(s7)
 88c:	855a                	mv	a0,s6
 88e:	e1fff0ef          	jal	6ac <printint>
        i += 2;
 892:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 894:	8ba6                	mv	s7,s1
      state = 0;
 896:	4981                	li	s3,0
        i += 2;
 898:	bdc5                	j	788 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 89a:	008b8493          	addi	s1,s7,8
 89e:	4685                	li	a3,1
 8a0:	4629                	li	a2,10
 8a2:	000bb583          	ld	a1,0(s7)
 8a6:	855a                	mv	a0,s6
 8a8:	e05ff0ef          	jal	6ac <printint>
        i += 2;
 8ac:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8ae:	8ba6                	mv	s7,s1
      state = 0;
 8b0:	4981                	li	s3,0
        i += 2;
 8b2:	bdd9                	j	788 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 8b4:	008b8493          	addi	s1,s7,8
 8b8:	4681                	li	a3,0
 8ba:	4629                	li	a2,10
 8bc:	000be583          	lwu	a1,0(s7)
 8c0:	855a                	mv	a0,s6
 8c2:	debff0ef          	jal	6ac <printint>
 8c6:	8ba6                	mv	s7,s1
      state = 0;
 8c8:	4981                	li	s3,0
 8ca:	bd7d                	j	788 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8cc:	008b8493          	addi	s1,s7,8
 8d0:	4681                	li	a3,0
 8d2:	4629                	li	a2,10
 8d4:	000bb583          	ld	a1,0(s7)
 8d8:	855a                	mv	a0,s6
 8da:	dd3ff0ef          	jal	6ac <printint>
        i += 1;
 8de:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8e0:	8ba6                	mv	s7,s1
      state = 0;
 8e2:	4981                	li	s3,0
        i += 1;
 8e4:	b555                	j	788 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8e6:	008b8493          	addi	s1,s7,8
 8ea:	4681                	li	a3,0
 8ec:	4629                	li	a2,10
 8ee:	000bb583          	ld	a1,0(s7)
 8f2:	855a                	mv	a0,s6
 8f4:	db9ff0ef          	jal	6ac <printint>
        i += 2;
 8f8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8fa:	8ba6                	mv	s7,s1
      state = 0;
 8fc:	4981                	li	s3,0
        i += 2;
 8fe:	b569                	j	788 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 900:	008b8493          	addi	s1,s7,8
 904:	4681                	li	a3,0
 906:	4641                	li	a2,16
 908:	000be583          	lwu	a1,0(s7)
 90c:	855a                	mv	a0,s6
 90e:	d9fff0ef          	jal	6ac <printint>
 912:	8ba6                	mv	s7,s1
      state = 0;
 914:	4981                	li	s3,0
 916:	bd8d                	j	788 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 918:	008b8493          	addi	s1,s7,8
 91c:	4681                	li	a3,0
 91e:	4641                	li	a2,16
 920:	000bb583          	ld	a1,0(s7)
 924:	855a                	mv	a0,s6
 926:	d87ff0ef          	jal	6ac <printint>
        i += 1;
 92a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 92c:	8ba6                	mv	s7,s1
      state = 0;
 92e:	4981                	li	s3,0
        i += 1;
 930:	bda1                	j	788 <vprintf+0x4a>
 932:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 934:	008b8d13          	addi	s10,s7,8
 938:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 93c:	03000593          	li	a1,48
 940:	855a                	mv	a0,s6
 942:	d4dff0ef          	jal	68e <putc>
  putc(fd, 'x');
 946:	07800593          	li	a1,120
 94a:	855a                	mv	a0,s6
 94c:	d43ff0ef          	jal	68e <putc>
 950:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 952:	00000b97          	auipc	s7,0x0
 956:	37eb8b93          	addi	s7,s7,894 # cd0 <digits>
 95a:	03c9d793          	srli	a5,s3,0x3c
 95e:	97de                	add	a5,a5,s7
 960:	0007c583          	lbu	a1,0(a5)
 964:	855a                	mv	a0,s6
 966:	d29ff0ef          	jal	68e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 96a:	0992                	slli	s3,s3,0x4
 96c:	34fd                	addiw	s1,s1,-1
 96e:	f4f5                	bnez	s1,95a <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 970:	8bea                	mv	s7,s10
      state = 0;
 972:	4981                	li	s3,0
 974:	6d02                	ld	s10,0(sp)
 976:	bd09                	j	788 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 978:	008b8493          	addi	s1,s7,8
 97c:	000bc583          	lbu	a1,0(s7)
 980:	855a                	mv	a0,s6
 982:	d0dff0ef          	jal	68e <putc>
 986:	8ba6                	mv	s7,s1
      state = 0;
 988:	4981                	li	s3,0
 98a:	bbfd                	j	788 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 98c:	008b8993          	addi	s3,s7,8
 990:	000bb483          	ld	s1,0(s7)
 994:	cc91                	beqz	s1,9b0 <vprintf+0x272>
        for(; *s; s++)
 996:	0004c583          	lbu	a1,0(s1)
 99a:	c195                	beqz	a1,9be <vprintf+0x280>
          putc(fd, *s);
 99c:	855a                	mv	a0,s6
 99e:	cf1ff0ef          	jal	68e <putc>
        for(; *s; s++)
 9a2:	0485                	addi	s1,s1,1
 9a4:	0004c583          	lbu	a1,0(s1)
 9a8:	f9f5                	bnez	a1,99c <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 9aa:	8bce                	mv	s7,s3
      state = 0;
 9ac:	4981                	li	s3,0
 9ae:	bbe9                	j	788 <vprintf+0x4a>
          s = "(null)";
 9b0:	00000497          	auipc	s1,0x0
 9b4:	31848493          	addi	s1,s1,792 # cc8 <malloc+0x208>
        for(; *s; s++)
 9b8:	02800593          	li	a1,40
 9bc:	b7c5                	j	99c <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 9be:	8bce                	mv	s7,s3
      state = 0;
 9c0:	4981                	li	s3,0
 9c2:	b3d9                	j	788 <vprintf+0x4a>
 9c4:	6906                	ld	s2,64(sp)
 9c6:	79e2                	ld	s3,56(sp)
 9c8:	7a42                	ld	s4,48(sp)
 9ca:	7aa2                	ld	s5,40(sp)
 9cc:	7b02                	ld	s6,32(sp)
 9ce:	6be2                	ld	s7,24(sp)
 9d0:	6c42                	ld	s8,16(sp)
 9d2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 9d4:	60e6                	ld	ra,88(sp)
 9d6:	6446                	ld	s0,80(sp)
 9d8:	64a6                	ld	s1,72(sp)
 9da:	6125                	addi	sp,sp,96
 9dc:	8082                	ret

00000000000009de <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9de:	715d                	addi	sp,sp,-80
 9e0:	ec06                	sd	ra,24(sp)
 9e2:	e822                	sd	s0,16(sp)
 9e4:	1000                	addi	s0,sp,32
 9e6:	e010                	sd	a2,0(s0)
 9e8:	e414                	sd	a3,8(s0)
 9ea:	e818                	sd	a4,16(s0)
 9ec:	ec1c                	sd	a5,24(s0)
 9ee:	03043023          	sd	a6,32(s0)
 9f2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9f6:	8622                	mv	a2,s0
 9f8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9fc:	d43ff0ef          	jal	73e <vprintf>
}
 a00:	60e2                	ld	ra,24(sp)
 a02:	6442                	ld	s0,16(sp)
 a04:	6161                	addi	sp,sp,80
 a06:	8082                	ret

0000000000000a08 <printf>:

void
printf(const char *fmt, ...)
{
 a08:	711d                	addi	sp,sp,-96
 a0a:	ec06                	sd	ra,24(sp)
 a0c:	e822                	sd	s0,16(sp)
 a0e:	1000                	addi	s0,sp,32
 a10:	e40c                	sd	a1,8(s0)
 a12:	e810                	sd	a2,16(s0)
 a14:	ec14                	sd	a3,24(s0)
 a16:	f018                	sd	a4,32(s0)
 a18:	f41c                	sd	a5,40(s0)
 a1a:	03043823          	sd	a6,48(s0)
 a1e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a22:	00840613          	addi	a2,s0,8
 a26:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a2a:	85aa                	mv	a1,a0
 a2c:	4505                	li	a0,1
 a2e:	d11ff0ef          	jal	73e <vprintf>
}
 a32:	60e2                	ld	ra,24(sp)
 a34:	6442                	ld	s0,16(sp)
 a36:	6125                	addi	sp,sp,96
 a38:	8082                	ret

0000000000000a3a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a3a:	1141                	addi	sp,sp,-16
 a3c:	e406                	sd	ra,8(sp)
 a3e:	e022                	sd	s0,0(sp)
 a40:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a42:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a46:	00000797          	auipc	a5,0x0
 a4a:	6227b783          	ld	a5,1570(a5) # 1068 <freep>
 a4e:	a02d                	j	a78 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a50:	4618                	lw	a4,8(a2)
 a52:	9f2d                	addw	a4,a4,a1
 a54:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a58:	6398                	ld	a4,0(a5)
 a5a:	6310                	ld	a2,0(a4)
 a5c:	a83d                	j	a9a <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a5e:	ff852703          	lw	a4,-8(a0)
 a62:	9f31                	addw	a4,a4,a2
 a64:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a66:	ff053683          	ld	a3,-16(a0)
 a6a:	a091                	j	aae <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a6c:	6398                	ld	a4,0(a5)
 a6e:	00e7e463          	bltu	a5,a4,a76 <free+0x3c>
 a72:	00e6ea63          	bltu	a3,a4,a86 <free+0x4c>
{
 a76:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a78:	fed7fae3          	bgeu	a5,a3,a6c <free+0x32>
 a7c:	6398                	ld	a4,0(a5)
 a7e:	00e6e463          	bltu	a3,a4,a86 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a82:	fee7eae3          	bltu	a5,a4,a76 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 a86:	ff852583          	lw	a1,-8(a0)
 a8a:	6390                	ld	a2,0(a5)
 a8c:	02059813          	slli	a6,a1,0x20
 a90:	01c85713          	srli	a4,a6,0x1c
 a94:	9736                	add	a4,a4,a3
 a96:	fae60de3          	beq	a2,a4,a50 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a9a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a9e:	4790                	lw	a2,8(a5)
 aa0:	02061593          	slli	a1,a2,0x20
 aa4:	01c5d713          	srli	a4,a1,0x1c
 aa8:	973e                	add	a4,a4,a5
 aaa:	fae68ae3          	beq	a3,a4,a5e <free+0x24>
    p->s.ptr = bp->s.ptr;
 aae:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ab0:	00000717          	auipc	a4,0x0
 ab4:	5af73c23          	sd	a5,1464(a4) # 1068 <freep>
}
 ab8:	60a2                	ld	ra,8(sp)
 aba:	6402                	ld	s0,0(sp)
 abc:	0141                	addi	sp,sp,16
 abe:	8082                	ret

0000000000000ac0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ac0:	7139                	addi	sp,sp,-64
 ac2:	fc06                	sd	ra,56(sp)
 ac4:	f822                	sd	s0,48(sp)
 ac6:	f04a                	sd	s2,32(sp)
 ac8:	ec4e                	sd	s3,24(sp)
 aca:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 acc:	02051993          	slli	s3,a0,0x20
 ad0:	0209d993          	srli	s3,s3,0x20
 ad4:	09bd                	addi	s3,s3,15
 ad6:	0049d993          	srli	s3,s3,0x4
 ada:	2985                	addiw	s3,s3,1
 adc:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 ade:	00000517          	auipc	a0,0x0
 ae2:	58a53503          	ld	a0,1418(a0) # 1068 <freep>
 ae6:	c905                	beqz	a0,b16 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ae8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aea:	4798                	lw	a4,8(a5)
 aec:	09377663          	bgeu	a4,s3,b78 <malloc+0xb8>
 af0:	f426                	sd	s1,40(sp)
 af2:	e852                	sd	s4,16(sp)
 af4:	e456                	sd	s5,8(sp)
 af6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 af8:	8a4e                	mv	s4,s3
 afa:	6705                	lui	a4,0x1
 afc:	00e9f363          	bgeu	s3,a4,b02 <malloc+0x42>
 b00:	6a05                	lui	s4,0x1
 b02:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b06:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b0a:	00000497          	auipc	s1,0x0
 b0e:	55e48493          	addi	s1,s1,1374 # 1068 <freep>
  if(p == SBRK_ERROR)
 b12:	5afd                	li	s5,-1
 b14:	a83d                	j	b52 <malloc+0x92>
 b16:	f426                	sd	s1,40(sp)
 b18:	e852                	sd	s4,16(sp)
 b1a:	e456                	sd	s5,8(sp)
 b1c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b1e:	00000797          	auipc	a5,0x0
 b22:	55278793          	addi	a5,a5,1362 # 1070 <base>
 b26:	00000717          	auipc	a4,0x0
 b2a:	54f73123          	sd	a5,1346(a4) # 1068 <freep>
 b2e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b30:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b34:	b7d1                	j	af8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b36:	6398                	ld	a4,0(a5)
 b38:	e118                	sd	a4,0(a0)
 b3a:	a899                	j	b90 <malloc+0xd0>
  hp->s.size = nu;
 b3c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b40:	0541                	addi	a0,a0,16
 b42:	ef9ff0ef          	jal	a3a <free>
  return freep;
 b46:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b48:	c125                	beqz	a0,ba8 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b4a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b4c:	4798                	lw	a4,8(a5)
 b4e:	03277163          	bgeu	a4,s2,b70 <malloc+0xb0>
    if(p == freep)
 b52:	6098                	ld	a4,0(s1)
 b54:	853e                	mv	a0,a5
 b56:	fef71ae3          	bne	a4,a5,b4a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b5a:	8552                	mv	a0,s4
 b5c:	8c7ff0ef          	jal	422 <sbrk>
  if(p == SBRK_ERROR)
 b60:	fd551ee3          	bne	a0,s5,b3c <malloc+0x7c>
        return 0;
 b64:	4501                	li	a0,0
 b66:	74a2                	ld	s1,40(sp)
 b68:	6a42                	ld	s4,16(sp)
 b6a:	6aa2                	ld	s5,8(sp)
 b6c:	6b02                	ld	s6,0(sp)
 b6e:	a03d                	j	b9c <malloc+0xdc>
 b70:	74a2                	ld	s1,40(sp)
 b72:	6a42                	ld	s4,16(sp)
 b74:	6aa2                	ld	s5,8(sp)
 b76:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b78:	fae90fe3          	beq	s2,a4,b36 <malloc+0x76>
        p->s.size -= nunits;
 b7c:	4137073b          	subw	a4,a4,s3
 b80:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b82:	02071693          	slli	a3,a4,0x20
 b86:	01c6d713          	srli	a4,a3,0x1c
 b8a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b8c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b90:	00000717          	auipc	a4,0x0
 b94:	4ca73c23          	sd	a0,1240(a4) # 1068 <freep>
      return (void*)(p + 1);
 b98:	01078513          	addi	a0,a5,16
  }
}
 b9c:	70e2                	ld	ra,56(sp)
 b9e:	7442                	ld	s0,48(sp)
 ba0:	7902                	ld	s2,32(sp)
 ba2:	69e2                	ld	s3,24(sp)
 ba4:	6121                	addi	sp,sp,64
 ba6:	8082                	ret
 ba8:	74a2                	ld	s1,40(sp)
 baa:	6a42                	ld	s4,16(sp)
 bac:	6aa2                	ld	s5,8(sp)
 bae:	6b02                	ld	s6,0(sp)
 bb0:	b7f5                	j	b9c <malloc+0xdc>
