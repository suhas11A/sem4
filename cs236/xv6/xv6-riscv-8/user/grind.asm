
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       8:	611c                	ld	a5,0(a0)
       a:	0017d693          	srli	a3,a5,0x1
       e:	c0000737          	lui	a4,0xc0000
      12:	0705                	addi	a4,a4,1 # ffffffffc0000001 <base+0xffffffffbfffdbf9>
      14:	1706                	slli	a4,a4,0x21
      16:	0725                	addi	a4,a4,9
      18:	02e6b733          	mulhu	a4,a3,a4
      1c:	8375                	srli	a4,a4,0x1d
      1e:	01e71693          	slli	a3,a4,0x1e
      22:	40e68733          	sub	a4,a3,a4
      26:	0706                	slli	a4,a4,0x1
      28:	8f99                	sub	a5,a5,a4
      2a:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      2c:	1fe406b7          	lui	a3,0x1fe40
      30:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <base+0x1fe3d771>
      34:	41a70737          	lui	a4,0x41a70
      38:	5af70713          	addi	a4,a4,1455 # 41a705af <base+0x41a6e1a7>
      3c:	1702                	slli	a4,a4,0x20
      3e:	9736                	add	a4,a4,a3
      40:	02e79733          	mulh	a4,a5,a4
      44:	873d                	srai	a4,a4,0xf
      46:	43f7d693          	srai	a3,a5,0x3f
      4a:	8f15                	sub	a4,a4,a3
      4c:	66fd                	lui	a3,0x1f
      4e:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      52:	02d706b3          	mul	a3,a4,a3
      56:	8f95                	sub	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      58:	6691                	lui	a3,0x4
      5a:	1a768693          	addi	a3,a3,423 # 41a7 <base+0x1d9f>
      5e:	02d787b3          	mul	a5,a5,a3
      62:	76fd                	lui	a3,0xfffff
      64:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      68:	02d70733          	mul	a4,a4,a3
      6c:	97ba                	add	a5,a5,a4
    if (x < 0)
      6e:	0007ca63          	bltz	a5,82 <do_rand+0x82>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      72:	17fd                	addi	a5,a5,-1
    *ctx = x;
      74:	e11c                	sd	a5,0(a0)
    return (x);
}
      76:	0007851b          	sext.w	a0,a5
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
        x += 0x7fffffff;
      82:	80000737          	lui	a4,0x80000
      86:	fff74713          	not	a4,a4
      8a:	97ba                	add	a5,a5,a4
      8c:	b7dd                	j	72 <do_rand+0x72>

000000000000008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      8e:	1141                	addi	sp,sp,-16
      90:	e406                	sd	ra,8(sp)
      92:	e022                	sd	s0,0(sp)
      94:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      96:	00002517          	auipc	a0,0x2
      9a:	f6a50513          	addi	a0,a0,-150 # 2000 <rand_next>
      9e:	f63ff0ef          	jal	0 <do_rand>
}
      a2:	60a2                	ld	ra,8(sp)
      a4:	6402                	ld	s0,0(sp)
      a6:	0141                	addi	sp,sp,16
      a8:	8082                	ret

00000000000000aa <go>:

void
go(int which_child)
{
      aa:	7171                	addi	sp,sp,-176
      ac:	f506                	sd	ra,168(sp)
      ae:	f122                	sd	s0,160(sp)
      b0:	ed26                	sd	s1,152(sp)
      b2:	1900                	addi	s0,sp,176
      b4:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      b6:	4501                	li	a0,0
      b8:	355000ef          	jal	c0c <sbrk>
      bc:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
      c0:	00001517          	auipc	a0,0x1
      c4:	19050513          	addi	a0,a0,400 # 1250 <malloc+0xfc>
      c8:	413000ef          	jal	cda <mkdir>
  if(chdir("grindir") != 0){
      cc:	00001517          	auipc	a0,0x1
      d0:	18450513          	addi	a0,a0,388 # 1250 <malloc+0xfc>
      d4:	40f000ef          	jal	ce2 <chdir>
      d8:	c505                	beqz	a0,100 <go+0x56>
      da:	e94a                	sd	s2,144(sp)
      dc:	e54e                	sd	s3,136(sp)
      de:	e152                	sd	s4,128(sp)
      e0:	fcd6                	sd	s5,120(sp)
      e2:	f8da                	sd	s6,112(sp)
      e4:	f4de                	sd	s7,104(sp)
      e6:	f0e2                	sd	s8,96(sp)
      e8:	ece6                	sd	s9,88(sp)
      ea:	e8ea                	sd	s10,80(sp)
      ec:	e4ee                	sd	s11,72(sp)
    printf("grind: chdir grindir failed\n");
      ee:	00001517          	auipc	a0,0x1
      f2:	16a50513          	addi	a0,a0,362 # 1258 <malloc+0x104>
      f6:	7a7000ef          	jal	109c <printf>
    exit(1);
      fa:	4505                	li	a0,1
      fc:	377000ef          	jal	c72 <exit>
     100:	e94a                	sd	s2,144(sp)
     102:	e54e                	sd	s3,136(sp)
     104:	e152                	sd	s4,128(sp)
     106:	fcd6                	sd	s5,120(sp)
     108:	f8da                	sd	s6,112(sp)
     10a:	f4de                	sd	s7,104(sp)
     10c:	f0e2                	sd	s8,96(sp)
     10e:	ece6                	sd	s9,88(sp)
     110:	e8ea                	sd	s10,80(sp)
     112:	e4ee                	sd	s11,72(sp)
  }
  chdir("/");
     114:	00001517          	auipc	a0,0x1
     118:	16c50513          	addi	a0,a0,364 # 1280 <malloc+0x12c>
     11c:	3c7000ef          	jal	ce2 <chdir>
     120:	00001c17          	auipc	s8,0x1
     124:	170c0c13          	addi	s8,s8,368 # 1290 <malloc+0x13c>
     128:	c489                	beqz	s1,132 <go+0x88>
     12a:	00001c17          	auipc	s8,0x1
     12e:	15ec0c13          	addi	s8,s8,350 # 1288 <malloc+0x134>
  uint64 iters = 0;
     132:	4481                	li	s1,0
  int fd = -1;
     134:	5cfd                	li	s9,-1
  
  while(1){
    iters++;
    if((iters % 500) == 0)
     136:	e353f7b7          	lui	a5,0xe353f
     13a:	7cf78793          	addi	a5,a5,1999 # ffffffffe353f7cf <base+0xffffffffe353d3c7>
     13e:	20c4a9b7          	lui	s3,0x20c4a
     142:	ba698993          	addi	s3,s3,-1114 # 20c49ba6 <base+0x20c4779e>
     146:	1982                	slli	s3,s3,0x20
     148:	99be                	add	s3,s3,a5
     14a:	1f400b13          	li	s6,500
      write(1, which_child?"B":"A", 1);
     14e:	4b85                	li	s7,1
    int what = rand() % 23;
     150:	b2164a37          	lui	s4,0xb2164
     154:	2c9a0a13          	addi	s4,s4,713 # ffffffffb21642c9 <base+0xffffffffb2161ec1>
     158:	4ad9                	li	s5,22
     15a:	00001917          	auipc	s2,0x1
     15e:	40690913          	addi	s2,s2,1030 # 1560 <malloc+0x40c>
      close(fd1);
      unlink("c");
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     162:	f6840d93          	addi	s11,s0,-152
     166:	a819                	j	17c <go+0xd2>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     168:	20200593          	li	a1,514
     16c:	00001517          	auipc	a0,0x1
     170:	12c50513          	addi	a0,a0,300 # 1298 <malloc+0x144>
     174:	33f000ef          	jal	cb2 <open>
     178:	323000ef          	jal	c9a <close>
    iters++;
     17c:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     17e:	0024d793          	srli	a5,s1,0x2
     182:	0337b7b3          	mulhu	a5,a5,s3
     186:	8391                	srli	a5,a5,0x4
     188:	036787b3          	mul	a5,a5,s6
     18c:	00f49763          	bne	s1,a5,19a <go+0xf0>
      write(1, which_child?"B":"A", 1);
     190:	865e                	mv	a2,s7
     192:	85e2                	mv	a1,s8
     194:	855e                	mv	a0,s7
     196:	2fd000ef          	jal	c92 <write>
    int what = rand() % 23;
     19a:	ef5ff0ef          	jal	8e <rand>
     19e:	034507b3          	mul	a5,a0,s4
     1a2:	9381                	srli	a5,a5,0x20
     1a4:	9fa9                	addw	a5,a5,a0
     1a6:	4047d79b          	sraiw	a5,a5,0x4
     1aa:	41f5571b          	sraiw	a4,a0,0x1f
     1ae:	9f99                	subw	a5,a5,a4
     1b0:	0017971b          	slliw	a4,a5,0x1
     1b4:	9f3d                	addw	a4,a4,a5
     1b6:	0037171b          	slliw	a4,a4,0x3
     1ba:	40f707bb          	subw	a5,a4,a5
     1be:	9d1d                	subw	a0,a0,a5
     1c0:	faaaeee3          	bltu	s5,a0,17c <go+0xd2>
     1c4:	02051793          	slli	a5,a0,0x20
     1c8:	01e7d513          	srli	a0,a5,0x1e
     1cc:	954a                	add	a0,a0,s2
     1ce:	411c                	lw	a5,0(a0)
     1d0:	97ca                	add	a5,a5,s2
     1d2:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     1d4:	20200593          	li	a1,514
     1d8:	00001517          	auipc	a0,0x1
     1dc:	0d050513          	addi	a0,a0,208 # 12a8 <malloc+0x154>
     1e0:	2d3000ef          	jal	cb2 <open>
     1e4:	2b7000ef          	jal	c9a <close>
     1e8:	bf51                	j	17c <go+0xd2>
      unlink("grindir/../a");
     1ea:	00001517          	auipc	a0,0x1
     1ee:	0ae50513          	addi	a0,a0,174 # 1298 <malloc+0x144>
     1f2:	2d1000ef          	jal	cc2 <unlink>
     1f6:	b759                	j	17c <go+0xd2>
      if(chdir("grindir") != 0){
     1f8:	00001517          	auipc	a0,0x1
     1fc:	05850513          	addi	a0,a0,88 # 1250 <malloc+0xfc>
     200:	2e3000ef          	jal	ce2 <chdir>
     204:	ed11                	bnez	a0,220 <go+0x176>
      unlink("../b");
     206:	00001517          	auipc	a0,0x1
     20a:	0ba50513          	addi	a0,a0,186 # 12c0 <malloc+0x16c>
     20e:	2b5000ef          	jal	cc2 <unlink>
      chdir("/");
     212:	00001517          	auipc	a0,0x1
     216:	06e50513          	addi	a0,a0,110 # 1280 <malloc+0x12c>
     21a:	2c9000ef          	jal	ce2 <chdir>
     21e:	bfb9                	j	17c <go+0xd2>
        printf("grind: chdir grindir failed\n");
     220:	00001517          	auipc	a0,0x1
     224:	03850513          	addi	a0,a0,56 # 1258 <malloc+0x104>
     228:	675000ef          	jal	109c <printf>
        exit(1);
     22c:	4505                	li	a0,1
     22e:	245000ef          	jal	c72 <exit>
      close(fd);
     232:	8566                	mv	a0,s9
     234:	267000ef          	jal	c9a <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     238:	20200593          	li	a1,514
     23c:	00001517          	auipc	a0,0x1
     240:	08c50513          	addi	a0,a0,140 # 12c8 <malloc+0x174>
     244:	26f000ef          	jal	cb2 <open>
     248:	8caa                	mv	s9,a0
     24a:	bf0d                	j	17c <go+0xd2>
      close(fd);
     24c:	8566                	mv	a0,s9
     24e:	24d000ef          	jal	c9a <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     252:	20200593          	li	a1,514
     256:	00001517          	auipc	a0,0x1
     25a:	08250513          	addi	a0,a0,130 # 12d8 <malloc+0x184>
     25e:	255000ef          	jal	cb2 <open>
     262:	8caa                	mv	s9,a0
     264:	bf21                	j	17c <go+0xd2>
      write(fd, buf, sizeof(buf));
     266:	3e700613          	li	a2,999
     26a:	00002597          	auipc	a1,0x2
     26e:	db658593          	addi	a1,a1,-586 # 2020 <buf.0>
     272:	8566                	mv	a0,s9
     274:	21f000ef          	jal	c92 <write>
     278:	b711                	j	17c <go+0xd2>
      read(fd, buf, sizeof(buf));
     27a:	3e700613          	li	a2,999
     27e:	00002597          	auipc	a1,0x2
     282:	da258593          	addi	a1,a1,-606 # 2020 <buf.0>
     286:	8566                	mv	a0,s9
     288:	203000ef          	jal	c8a <read>
     28c:	bdc5                	j	17c <go+0xd2>
      mkdir("grindir/../a");
     28e:	00001517          	auipc	a0,0x1
     292:	00a50513          	addi	a0,a0,10 # 1298 <malloc+0x144>
     296:	245000ef          	jal	cda <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     29a:	20200593          	li	a1,514
     29e:	00001517          	auipc	a0,0x1
     2a2:	05250513          	addi	a0,a0,82 # 12f0 <malloc+0x19c>
     2a6:	20d000ef          	jal	cb2 <open>
     2aa:	1f1000ef          	jal	c9a <close>
      unlink("a/a");
     2ae:	00001517          	auipc	a0,0x1
     2b2:	05250513          	addi	a0,a0,82 # 1300 <malloc+0x1ac>
     2b6:	20d000ef          	jal	cc2 <unlink>
     2ba:	b5c9                	j	17c <go+0xd2>
      mkdir("/../b");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	04c50513          	addi	a0,a0,76 # 1308 <malloc+0x1b4>
     2c4:	217000ef          	jal	cda <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2c8:	20200593          	li	a1,514
     2cc:	00001517          	auipc	a0,0x1
     2d0:	04450513          	addi	a0,a0,68 # 1310 <malloc+0x1bc>
     2d4:	1df000ef          	jal	cb2 <open>
     2d8:	1c3000ef          	jal	c9a <close>
      unlink("b/b");
     2dc:	00001517          	auipc	a0,0x1
     2e0:	04450513          	addi	a0,a0,68 # 1320 <malloc+0x1cc>
     2e4:	1df000ef          	jal	cc2 <unlink>
     2e8:	bd51                	j	17c <go+0xd2>
      unlink("b");
     2ea:	00001517          	auipc	a0,0x1
     2ee:	03e50513          	addi	a0,a0,62 # 1328 <malloc+0x1d4>
     2f2:	1d1000ef          	jal	cc2 <unlink>
      link("../grindir/./../a", "../b");
     2f6:	00001597          	auipc	a1,0x1
     2fa:	fca58593          	addi	a1,a1,-54 # 12c0 <malloc+0x16c>
     2fe:	00001517          	auipc	a0,0x1
     302:	03250513          	addi	a0,a0,50 # 1330 <malloc+0x1dc>
     306:	1cd000ef          	jal	cd2 <link>
     30a:	bd8d                	j	17c <go+0xd2>
      unlink("../grindir/../a");
     30c:	00001517          	auipc	a0,0x1
     310:	03c50513          	addi	a0,a0,60 # 1348 <malloc+0x1f4>
     314:	1af000ef          	jal	cc2 <unlink>
      link(".././b", "/grindir/../a");
     318:	00001597          	auipc	a1,0x1
     31c:	fb058593          	addi	a1,a1,-80 # 12c8 <malloc+0x174>
     320:	00001517          	auipc	a0,0x1
     324:	03850513          	addi	a0,a0,56 # 1358 <malloc+0x204>
     328:	1ab000ef          	jal	cd2 <link>
     32c:	bd81                	j	17c <go+0xd2>
      int pid = fork();
     32e:	13d000ef          	jal	c6a <fork>
      if(pid == 0){
     332:	c519                	beqz	a0,340 <go+0x296>
      } else if(pid < 0){
     334:	00054863          	bltz	a0,344 <go+0x29a>
      wait(0);
     338:	4501                	li	a0,0
     33a:	141000ef          	jal	c7a <wait>
     33e:	bd3d                	j	17c <go+0xd2>
        exit(0);
     340:	133000ef          	jal	c72 <exit>
        printf("grind: fork failed\n");
     344:	00001517          	auipc	a0,0x1
     348:	01c50513          	addi	a0,a0,28 # 1360 <malloc+0x20c>
     34c:	551000ef          	jal	109c <printf>
        exit(1);
     350:	4505                	li	a0,1
     352:	121000ef          	jal	c72 <exit>
      int pid = fork();
     356:	115000ef          	jal	c6a <fork>
      if(pid == 0){
     35a:	c519                	beqz	a0,368 <go+0x2be>
      } else if(pid < 0){
     35c:	00054d63          	bltz	a0,376 <go+0x2cc>
      wait(0);
     360:	4501                	li	a0,0
     362:	119000ef          	jal	c7a <wait>
     366:	bd19                	j	17c <go+0xd2>
        fork();
     368:	103000ef          	jal	c6a <fork>
        fork();
     36c:	0ff000ef          	jal	c6a <fork>
        exit(0);
     370:	4501                	li	a0,0
     372:	101000ef          	jal	c72 <exit>
        printf("grind: fork failed\n");
     376:	00001517          	auipc	a0,0x1
     37a:	fea50513          	addi	a0,a0,-22 # 1360 <malloc+0x20c>
     37e:	51f000ef          	jal	109c <printf>
        exit(1);
     382:	4505                	li	a0,1
     384:	0ef000ef          	jal	c72 <exit>
      sbrk(6011);
     388:	6505                	lui	a0,0x1
     38a:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x1bb>
     38e:	07f000ef          	jal	c0c <sbrk>
     392:	b3ed                	j	17c <go+0xd2>
      if(sbrk(0) > break0)
     394:	4501                	li	a0,0
     396:	077000ef          	jal	c0c <sbrk>
     39a:	f5843783          	ld	a5,-168(s0)
     39e:	dca7ffe3          	bgeu	a5,a0,17c <go+0xd2>
        sbrk(-(sbrk(0) - break0));
     3a2:	4501                	li	a0,0
     3a4:	069000ef          	jal	c0c <sbrk>
     3a8:	f5843783          	ld	a5,-168(s0)
     3ac:	40a7853b          	subw	a0,a5,a0
     3b0:	05d000ef          	jal	c0c <sbrk>
     3b4:	b3e1                	j	17c <go+0xd2>
      int pid = fork();
     3b6:	0b5000ef          	jal	c6a <fork>
     3ba:	8d2a                	mv	s10,a0
      if(pid == 0){
     3bc:	c10d                	beqz	a0,3de <go+0x334>
      } else if(pid < 0){
     3be:	02054d63          	bltz	a0,3f8 <go+0x34e>
      if(chdir("../grindir/..") != 0){
     3c2:	00001517          	auipc	a0,0x1
     3c6:	fbe50513          	addi	a0,a0,-66 # 1380 <malloc+0x22c>
     3ca:	119000ef          	jal	ce2 <chdir>
     3ce:	ed15                	bnez	a0,40a <go+0x360>
      kill(pid);
     3d0:	856a                	mv	a0,s10
     3d2:	0d1000ef          	jal	ca2 <kill>
      wait(0);
     3d6:	4501                	li	a0,0
     3d8:	0a3000ef          	jal	c7a <wait>
     3dc:	b345                	j	17c <go+0xd2>
        close(open("a", O_CREATE|O_RDWR));
     3de:	20200593          	li	a1,514
     3e2:	00001517          	auipc	a0,0x1
     3e6:	f9650513          	addi	a0,a0,-106 # 1378 <malloc+0x224>
     3ea:	0c9000ef          	jal	cb2 <open>
     3ee:	0ad000ef          	jal	c9a <close>
        exit(0);
     3f2:	4501                	li	a0,0
     3f4:	07f000ef          	jal	c72 <exit>
        printf("grind: fork failed\n");
     3f8:	00001517          	auipc	a0,0x1
     3fc:	f6850513          	addi	a0,a0,-152 # 1360 <malloc+0x20c>
     400:	49d000ef          	jal	109c <printf>
        exit(1);
     404:	4505                	li	a0,1
     406:	06d000ef          	jal	c72 <exit>
        printf("grind: chdir failed\n");
     40a:	00001517          	auipc	a0,0x1
     40e:	f8650513          	addi	a0,a0,-122 # 1390 <malloc+0x23c>
     412:	48b000ef          	jal	109c <printf>
        exit(1);
     416:	4505                	li	a0,1
     418:	05b000ef          	jal	c72 <exit>
      int pid = fork();
     41c:	04f000ef          	jal	c6a <fork>
      if(pid == 0){
     420:	c519                	beqz	a0,42e <go+0x384>
      } else if(pid < 0){
     422:	00054d63          	bltz	a0,43c <go+0x392>
      wait(0);
     426:	4501                	li	a0,0
     428:	053000ef          	jal	c7a <wait>
     42c:	bb81                	j	17c <go+0xd2>
        kill(getpid());
     42e:	0c5000ef          	jal	cf2 <getpid>
     432:	071000ef          	jal	ca2 <kill>
        exit(0);
     436:	4501                	li	a0,0
     438:	03b000ef          	jal	c72 <exit>
        printf("grind: fork failed\n");
     43c:	00001517          	auipc	a0,0x1
     440:	f2450513          	addi	a0,a0,-220 # 1360 <malloc+0x20c>
     444:	459000ef          	jal	109c <printf>
        exit(1);
     448:	4505                	li	a0,1
     44a:	029000ef          	jal	c72 <exit>
      if(pipe(fds) < 0){
     44e:	f7840513          	addi	a0,s0,-136
     452:	031000ef          	jal	c82 <pipe>
     456:	02054363          	bltz	a0,47c <go+0x3d2>
      int pid = fork();
     45a:	011000ef          	jal	c6a <fork>
      if(pid == 0){
     45e:	c905                	beqz	a0,48e <go+0x3e4>
      } else if(pid < 0){
     460:	08054263          	bltz	a0,4e4 <go+0x43a>
      close(fds[0]);
     464:	f7842503          	lw	a0,-136(s0)
     468:	033000ef          	jal	c9a <close>
      close(fds[1]);
     46c:	f7c42503          	lw	a0,-132(s0)
     470:	02b000ef          	jal	c9a <close>
      wait(0);
     474:	4501                	li	a0,0
     476:	005000ef          	jal	c7a <wait>
     47a:	b309                	j	17c <go+0xd2>
        printf("grind: pipe failed\n");
     47c:	00001517          	auipc	a0,0x1
     480:	f2c50513          	addi	a0,a0,-212 # 13a8 <malloc+0x254>
     484:	419000ef          	jal	109c <printf>
        exit(1);
     488:	4505                	li	a0,1
     48a:	7e8000ef          	jal	c72 <exit>
        fork();
     48e:	7dc000ef          	jal	c6a <fork>
        fork();
     492:	7d8000ef          	jal	c6a <fork>
        if(write(fds[1], "x", 1) != 1)
     496:	4605                	li	a2,1
     498:	00001597          	auipc	a1,0x1
     49c:	f2858593          	addi	a1,a1,-216 # 13c0 <malloc+0x26c>
     4a0:	f7c42503          	lw	a0,-132(s0)
     4a4:	7ee000ef          	jal	c92 <write>
     4a8:	4785                	li	a5,1
     4aa:	00f51f63          	bne	a0,a5,4c8 <go+0x41e>
        if(read(fds[0], &c, 1) != 1)
     4ae:	4605                	li	a2,1
     4b0:	f7040593          	addi	a1,s0,-144
     4b4:	f7842503          	lw	a0,-136(s0)
     4b8:	7d2000ef          	jal	c8a <read>
     4bc:	4785                	li	a5,1
     4be:	00f51c63          	bne	a0,a5,4d6 <go+0x42c>
        exit(0);
     4c2:	4501                	li	a0,0
     4c4:	7ae000ef          	jal	c72 <exit>
          printf("grind: pipe write failed\n");
     4c8:	00001517          	auipc	a0,0x1
     4cc:	f0050513          	addi	a0,a0,-256 # 13c8 <malloc+0x274>
     4d0:	3cd000ef          	jal	109c <printf>
     4d4:	bfe9                	j	4ae <go+0x404>
          printf("grind: pipe read failed\n");
     4d6:	00001517          	auipc	a0,0x1
     4da:	f1250513          	addi	a0,a0,-238 # 13e8 <malloc+0x294>
     4de:	3bf000ef          	jal	109c <printf>
     4e2:	b7c5                	j	4c2 <go+0x418>
        printf("grind: fork failed\n");
     4e4:	00001517          	auipc	a0,0x1
     4e8:	e7c50513          	addi	a0,a0,-388 # 1360 <malloc+0x20c>
     4ec:	3b1000ef          	jal	109c <printf>
        exit(1);
     4f0:	4505                	li	a0,1
     4f2:	780000ef          	jal	c72 <exit>
      int pid = fork();
     4f6:	774000ef          	jal	c6a <fork>
      if(pid == 0){
     4fa:	c519                	beqz	a0,508 <go+0x45e>
      } else if(pid < 0){
     4fc:	04054f63          	bltz	a0,55a <go+0x4b0>
      wait(0);
     500:	4501                	li	a0,0
     502:	778000ef          	jal	c7a <wait>
     506:	b99d                	j	17c <go+0xd2>
        unlink("a");
     508:	00001517          	auipc	a0,0x1
     50c:	e7050513          	addi	a0,a0,-400 # 1378 <malloc+0x224>
     510:	7b2000ef          	jal	cc2 <unlink>
        mkdir("a");
     514:	00001517          	auipc	a0,0x1
     518:	e6450513          	addi	a0,a0,-412 # 1378 <malloc+0x224>
     51c:	7be000ef          	jal	cda <mkdir>
        chdir("a");
     520:	00001517          	auipc	a0,0x1
     524:	e5850513          	addi	a0,a0,-424 # 1378 <malloc+0x224>
     528:	7ba000ef          	jal	ce2 <chdir>
        unlink("../a");
     52c:	00001517          	auipc	a0,0x1
     530:	edc50513          	addi	a0,a0,-292 # 1408 <malloc+0x2b4>
     534:	78e000ef          	jal	cc2 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     538:	20200593          	li	a1,514
     53c:	00001517          	auipc	a0,0x1
     540:	e8450513          	addi	a0,a0,-380 # 13c0 <malloc+0x26c>
     544:	76e000ef          	jal	cb2 <open>
        unlink("x");
     548:	00001517          	auipc	a0,0x1
     54c:	e7850513          	addi	a0,a0,-392 # 13c0 <malloc+0x26c>
     550:	772000ef          	jal	cc2 <unlink>
        exit(0);
     554:	4501                	li	a0,0
     556:	71c000ef          	jal	c72 <exit>
        printf("grind: fork failed\n");
     55a:	00001517          	auipc	a0,0x1
     55e:	e0650513          	addi	a0,a0,-506 # 1360 <malloc+0x20c>
     562:	33b000ef          	jal	109c <printf>
        exit(1);
     566:	4505                	li	a0,1
     568:	70a000ef          	jal	c72 <exit>
      unlink("c");
     56c:	00001517          	auipc	a0,0x1
     570:	ea450513          	addi	a0,a0,-348 # 1410 <malloc+0x2bc>
     574:	74e000ef          	jal	cc2 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     578:	20200593          	li	a1,514
     57c:	00001517          	auipc	a0,0x1
     580:	e9450513          	addi	a0,a0,-364 # 1410 <malloc+0x2bc>
     584:	72e000ef          	jal	cb2 <open>
     588:	8d2a                	mv	s10,a0
      if(fd1 < 0){
     58a:	04054563          	bltz	a0,5d4 <go+0x52a>
      if(write(fd1, "x", 1) != 1){
     58e:	865e                	mv	a2,s7
     590:	00001597          	auipc	a1,0x1
     594:	e3058593          	addi	a1,a1,-464 # 13c0 <malloc+0x26c>
     598:	6fa000ef          	jal	c92 <write>
     59c:	05751563          	bne	a0,s7,5e6 <go+0x53c>
      if(fstat(fd1, &st) != 0){
     5a0:	f7840593          	addi	a1,s0,-136
     5a4:	856a                	mv	a0,s10
     5a6:	724000ef          	jal	cca <fstat>
     5aa:	e539                	bnez	a0,5f8 <go+0x54e>
      if(st.size != 1){
     5ac:	f8843583          	ld	a1,-120(s0)
     5b0:	05759d63          	bne	a1,s7,60a <go+0x560>
      if(st.ino > 200){
     5b4:	f7c42583          	lw	a1,-132(s0)
     5b8:	0c800793          	li	a5,200
     5bc:	06b7e163          	bltu	a5,a1,61e <go+0x574>
      close(fd1);
     5c0:	856a                	mv	a0,s10
     5c2:	6d8000ef          	jal	c9a <close>
      unlink("c");
     5c6:	00001517          	auipc	a0,0x1
     5ca:	e4a50513          	addi	a0,a0,-438 # 1410 <malloc+0x2bc>
     5ce:	6f4000ef          	jal	cc2 <unlink>
     5d2:	b66d                	j	17c <go+0xd2>
        printf("grind: create c failed\n");
     5d4:	00001517          	auipc	a0,0x1
     5d8:	e4450513          	addi	a0,a0,-444 # 1418 <malloc+0x2c4>
     5dc:	2c1000ef          	jal	109c <printf>
        exit(1);
     5e0:	4505                	li	a0,1
     5e2:	690000ef          	jal	c72 <exit>
        printf("grind: write c failed\n");
     5e6:	00001517          	auipc	a0,0x1
     5ea:	e4a50513          	addi	a0,a0,-438 # 1430 <malloc+0x2dc>
     5ee:	2af000ef          	jal	109c <printf>
        exit(1);
     5f2:	4505                	li	a0,1
     5f4:	67e000ef          	jal	c72 <exit>
        printf("grind: fstat failed\n");
     5f8:	00001517          	auipc	a0,0x1
     5fc:	e5050513          	addi	a0,a0,-432 # 1448 <malloc+0x2f4>
     600:	29d000ef          	jal	109c <printf>
        exit(1);
     604:	4505                	li	a0,1
     606:	66c000ef          	jal	c72 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     60a:	2581                	sext.w	a1,a1
     60c:	00001517          	auipc	a0,0x1
     610:	e5450513          	addi	a0,a0,-428 # 1460 <malloc+0x30c>
     614:	289000ef          	jal	109c <printf>
        exit(1);
     618:	4505                	li	a0,1
     61a:	658000ef          	jal	c72 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     61e:	00001517          	auipc	a0,0x1
     622:	e6a50513          	addi	a0,a0,-406 # 1488 <malloc+0x334>
     626:	277000ef          	jal	109c <printf>
        exit(1);
     62a:	4505                	li	a0,1
     62c:	646000ef          	jal	c72 <exit>
      if(pipe(aa) < 0){
     630:	856e                	mv	a0,s11
     632:	650000ef          	jal	c82 <pipe>
     636:	0c054263          	bltz	a0,6fa <go+0x650>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     63a:	f7040513          	addi	a0,s0,-144
     63e:	644000ef          	jal	c82 <pipe>
     642:	0c054663          	bltz	a0,70e <go+0x664>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     646:	624000ef          	jal	c6a <fork>
      if(pid1 == 0){
     64a:	0c050c63          	beqz	a0,722 <go+0x678>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     64e:	14054e63          	bltz	a0,7aa <go+0x700>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     652:	618000ef          	jal	c6a <fork>
      if(pid2 == 0){
     656:	16050463          	beqz	a0,7be <go+0x714>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     65a:	20054263          	bltz	a0,85e <go+0x7b4>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     65e:	f6842503          	lw	a0,-152(s0)
     662:	638000ef          	jal	c9a <close>
      close(aa[1]);
     666:	f6c42503          	lw	a0,-148(s0)
     66a:	630000ef          	jal	c9a <close>
      close(bb[1]);
     66e:	f7442503          	lw	a0,-140(s0)
     672:	628000ef          	jal	c9a <close>
      char buf[4] = { 0, 0, 0, 0 };
     676:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf+0, 1);
     67a:	865e                	mv	a2,s7
     67c:	f6040593          	addi	a1,s0,-160
     680:	f7042503          	lw	a0,-144(s0)
     684:	606000ef          	jal	c8a <read>
      read(bb[0], buf+1, 1);
     688:	865e                	mv	a2,s7
     68a:	f6140593          	addi	a1,s0,-159
     68e:	f7042503          	lw	a0,-144(s0)
     692:	5f8000ef          	jal	c8a <read>
      read(bb[0], buf+2, 1);
     696:	865e                	mv	a2,s7
     698:	f6240593          	addi	a1,s0,-158
     69c:	f7042503          	lw	a0,-144(s0)
     6a0:	5ea000ef          	jal	c8a <read>
      close(bb[0]);
     6a4:	f7042503          	lw	a0,-144(s0)
     6a8:	5f2000ef          	jal	c9a <close>
      int st1, st2;
      wait(&st1);
     6ac:	f6440513          	addi	a0,s0,-156
     6b0:	5ca000ef          	jal	c7a <wait>
      wait(&st2);
     6b4:	f7840513          	addi	a0,s0,-136
     6b8:	5c2000ef          	jal	c7a <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     6bc:	f6442783          	lw	a5,-156(s0)
     6c0:	f7842703          	lw	a4,-136(s0)
     6c4:	8fd9                	or	a5,a5,a4
     6c6:	eb99                	bnez	a5,6dc <go+0x632>
     6c8:	00001597          	auipc	a1,0x1
     6cc:	e6058593          	addi	a1,a1,-416 # 1528 <malloc+0x3d4>
     6d0:	f6040513          	addi	a0,s0,-160
     6d4:	2d4000ef          	jal	9a8 <strcmp>
     6d8:	aa0502e3          	beqz	a0,17c <go+0xd2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     6dc:	f6040693          	addi	a3,s0,-160
     6e0:	f7842603          	lw	a2,-136(s0)
     6e4:	f6442583          	lw	a1,-156(s0)
     6e8:	00001517          	auipc	a0,0x1
     6ec:	e4850513          	addi	a0,a0,-440 # 1530 <malloc+0x3dc>
     6f0:	1ad000ef          	jal	109c <printf>
        exit(1);
     6f4:	4505                	li	a0,1
     6f6:	57c000ef          	jal	c72 <exit>
        fprintf(2, "grind: pipe failed\n");
     6fa:	00001597          	auipc	a1,0x1
     6fe:	cae58593          	addi	a1,a1,-850 # 13a8 <malloc+0x254>
     702:	4509                	li	a0,2
     704:	16f000ef          	jal	1072 <fprintf>
        exit(1);
     708:	4505                	li	a0,1
     70a:	568000ef          	jal	c72 <exit>
        fprintf(2, "grind: pipe failed\n");
     70e:	00001597          	auipc	a1,0x1
     712:	c9a58593          	addi	a1,a1,-870 # 13a8 <malloc+0x254>
     716:	4509                	li	a0,2
     718:	15b000ef          	jal	1072 <fprintf>
        exit(1);
     71c:	4505                	li	a0,1
     71e:	554000ef          	jal	c72 <exit>
        close(bb[0]);
     722:	f7042503          	lw	a0,-144(s0)
     726:	574000ef          	jal	c9a <close>
        close(bb[1]);
     72a:	f7442503          	lw	a0,-140(s0)
     72e:	56c000ef          	jal	c9a <close>
        close(aa[0]);
     732:	f6842503          	lw	a0,-152(s0)
     736:	564000ef          	jal	c9a <close>
        close(1);
     73a:	4505                	li	a0,1
     73c:	55e000ef          	jal	c9a <close>
        if(dup(aa[1]) != 1){
     740:	f6c42503          	lw	a0,-148(s0)
     744:	5a6000ef          	jal	cea <dup>
     748:	4785                	li	a5,1
     74a:	00f50c63          	beq	a0,a5,762 <go+0x6b8>
          fprintf(2, "grind: dup failed\n");
     74e:	00001597          	auipc	a1,0x1
     752:	d6258593          	addi	a1,a1,-670 # 14b0 <malloc+0x35c>
     756:	4509                	li	a0,2
     758:	11b000ef          	jal	1072 <fprintf>
          exit(1);
     75c:	4505                	li	a0,1
     75e:	514000ef          	jal	c72 <exit>
        close(aa[1]);
     762:	f6c42503          	lw	a0,-148(s0)
     766:	534000ef          	jal	c9a <close>
        char *args[3] = { "echo", "hi", 0 };
     76a:	00001797          	auipc	a5,0x1
     76e:	d5e78793          	addi	a5,a5,-674 # 14c8 <malloc+0x374>
     772:	f6f43c23          	sd	a5,-136(s0)
     776:	00001797          	auipc	a5,0x1
     77a:	d5a78793          	addi	a5,a5,-678 # 14d0 <malloc+0x37c>
     77e:	f8f43023          	sd	a5,-128(s0)
     782:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     786:	f7840593          	addi	a1,s0,-136
     78a:	00001517          	auipc	a0,0x1
     78e:	d4e50513          	addi	a0,a0,-690 # 14d8 <malloc+0x384>
     792:	518000ef          	jal	caa <exec>
        fprintf(2, "grind: echo: not found\n");
     796:	00001597          	auipc	a1,0x1
     79a:	d5258593          	addi	a1,a1,-686 # 14e8 <malloc+0x394>
     79e:	4509                	li	a0,2
     7a0:	0d3000ef          	jal	1072 <fprintf>
        exit(2);
     7a4:	4509                	li	a0,2
     7a6:	4cc000ef          	jal	c72 <exit>
        fprintf(2, "grind: fork failed\n");
     7aa:	00001597          	auipc	a1,0x1
     7ae:	bb658593          	addi	a1,a1,-1098 # 1360 <malloc+0x20c>
     7b2:	4509                	li	a0,2
     7b4:	0bf000ef          	jal	1072 <fprintf>
        exit(3);
     7b8:	450d                	li	a0,3
     7ba:	4b8000ef          	jal	c72 <exit>
        close(aa[1]);
     7be:	f6c42503          	lw	a0,-148(s0)
     7c2:	4d8000ef          	jal	c9a <close>
        close(bb[0]);
     7c6:	f7042503          	lw	a0,-144(s0)
     7ca:	4d0000ef          	jal	c9a <close>
        close(0);
     7ce:	4501                	li	a0,0
     7d0:	4ca000ef          	jal	c9a <close>
        if(dup(aa[0]) != 0){
     7d4:	f6842503          	lw	a0,-152(s0)
     7d8:	512000ef          	jal	cea <dup>
     7dc:	c919                	beqz	a0,7f2 <go+0x748>
          fprintf(2, "grind: dup failed\n");
     7de:	00001597          	auipc	a1,0x1
     7e2:	cd258593          	addi	a1,a1,-814 # 14b0 <malloc+0x35c>
     7e6:	4509                	li	a0,2
     7e8:	08b000ef          	jal	1072 <fprintf>
          exit(4);
     7ec:	4511                	li	a0,4
     7ee:	484000ef          	jal	c72 <exit>
        close(aa[0]);
     7f2:	f6842503          	lw	a0,-152(s0)
     7f6:	4a4000ef          	jal	c9a <close>
        close(1);
     7fa:	4505                	li	a0,1
     7fc:	49e000ef          	jal	c9a <close>
        if(dup(bb[1]) != 1){
     800:	f7442503          	lw	a0,-140(s0)
     804:	4e6000ef          	jal	cea <dup>
     808:	4785                	li	a5,1
     80a:	00f50c63          	beq	a0,a5,822 <go+0x778>
          fprintf(2, "grind: dup failed\n");
     80e:	00001597          	auipc	a1,0x1
     812:	ca258593          	addi	a1,a1,-862 # 14b0 <malloc+0x35c>
     816:	4509                	li	a0,2
     818:	05b000ef          	jal	1072 <fprintf>
          exit(5);
     81c:	4515                	li	a0,5
     81e:	454000ef          	jal	c72 <exit>
        close(bb[1]);
     822:	f7442503          	lw	a0,-140(s0)
     826:	474000ef          	jal	c9a <close>
        char *args[2] = { "cat", 0 };
     82a:	00001797          	auipc	a5,0x1
     82e:	cd678793          	addi	a5,a5,-810 # 1500 <malloc+0x3ac>
     832:	f6f43c23          	sd	a5,-136(s0)
     836:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     83a:	f7840593          	addi	a1,s0,-136
     83e:	00001517          	auipc	a0,0x1
     842:	cca50513          	addi	a0,a0,-822 # 1508 <malloc+0x3b4>
     846:	464000ef          	jal	caa <exec>
        fprintf(2, "grind: cat: not found\n");
     84a:	00001597          	auipc	a1,0x1
     84e:	cc658593          	addi	a1,a1,-826 # 1510 <malloc+0x3bc>
     852:	4509                	li	a0,2
     854:	01f000ef          	jal	1072 <fprintf>
        exit(6);
     858:	4519                	li	a0,6
     85a:	418000ef          	jal	c72 <exit>
        fprintf(2, "grind: fork failed\n");
     85e:	00001597          	auipc	a1,0x1
     862:	b0258593          	addi	a1,a1,-1278 # 1360 <malloc+0x20c>
     866:	4509                	li	a0,2
     868:	00b000ef          	jal	1072 <fprintf>
        exit(7);
     86c:	451d                	li	a0,7
     86e:	404000ef          	jal	c72 <exit>

0000000000000872 <iter>:
  }
}

void
iter()
{
     872:	7179                	addi	sp,sp,-48
     874:	f406                	sd	ra,40(sp)
     876:	f022                	sd	s0,32(sp)
     878:	1800                	addi	s0,sp,48
  unlink("a");
     87a:	00001517          	auipc	a0,0x1
     87e:	afe50513          	addi	a0,a0,-1282 # 1378 <malloc+0x224>
     882:	440000ef          	jal	cc2 <unlink>
  unlink("b");
     886:	00001517          	auipc	a0,0x1
     88a:	aa250513          	addi	a0,a0,-1374 # 1328 <malloc+0x1d4>
     88e:	434000ef          	jal	cc2 <unlink>
  
  int pid1 = fork();
     892:	3d8000ef          	jal	c6a <fork>
  if(pid1 < 0){
     896:	02054163          	bltz	a0,8b8 <iter+0x46>
     89a:	ec26                	sd	s1,24(sp)
     89c:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     89e:	e905                	bnez	a0,8ce <iter+0x5c>
     8a0:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     8a2:	00001717          	auipc	a4,0x1
     8a6:	75e70713          	addi	a4,a4,1886 # 2000 <rand_next>
     8aa:	631c                	ld	a5,0(a4)
     8ac:	01f7c793          	xori	a5,a5,31
     8b0:	e31c                	sd	a5,0(a4)
    go(0);
     8b2:	4501                	li	a0,0
     8b4:	ff6ff0ef          	jal	aa <go>
     8b8:	ec26                	sd	s1,24(sp)
     8ba:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     8bc:	00001517          	auipc	a0,0x1
     8c0:	aa450513          	addi	a0,a0,-1372 # 1360 <malloc+0x20c>
     8c4:	7d8000ef          	jal	109c <printf>
    exit(1);
     8c8:	4505                	li	a0,1
     8ca:	3a8000ef          	jal	c72 <exit>
     8ce:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     8d0:	39a000ef          	jal	c6a <fork>
     8d4:	892a                	mv	s2,a0
  if(pid2 < 0){
     8d6:	02054063          	bltz	a0,8f6 <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     8da:	e51d                	bnez	a0,908 <iter+0x96>
    rand_next ^= 7177;
     8dc:	00001697          	auipc	a3,0x1
     8e0:	72468693          	addi	a3,a3,1828 # 2000 <rand_next>
     8e4:	629c                	ld	a5,0(a3)
     8e6:	6709                	lui	a4,0x2
     8e8:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x649>
     8ec:	8fb9                	xor	a5,a5,a4
     8ee:	e29c                	sd	a5,0(a3)
    go(1);
     8f0:	4505                	li	a0,1
     8f2:	fb8ff0ef          	jal	aa <go>
    printf("grind: fork failed\n");
     8f6:	00001517          	auipc	a0,0x1
     8fa:	a6a50513          	addi	a0,a0,-1430 # 1360 <malloc+0x20c>
     8fe:	79e000ef          	jal	109c <printf>
    exit(1);
     902:	4505                	li	a0,1
     904:	36e000ef          	jal	c72 <exit>
    exit(0);
  }

  int st1 = -1;
     908:	57fd                	li	a5,-1
     90a:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     90e:	fdc40513          	addi	a0,s0,-36
     912:	368000ef          	jal	c7a <wait>
  if(st1 != 0){
     916:	fdc42783          	lw	a5,-36(s0)
     91a:	eb99                	bnez	a5,930 <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     91c:	57fd                	li	a5,-1
     91e:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     922:	fd840513          	addi	a0,s0,-40
     926:	354000ef          	jal	c7a <wait>

  exit(0);
     92a:	4501                	li	a0,0
     92c:	346000ef          	jal	c72 <exit>
    kill(pid1);
     930:	8526                	mv	a0,s1
     932:	370000ef          	jal	ca2 <kill>
    kill(pid2);
     936:	854a                	mv	a0,s2
     938:	36a000ef          	jal	ca2 <kill>
     93c:	b7c5                	j	91c <iter+0xaa>

000000000000093e <main>:
}

int
main()
{
     93e:	1101                	addi	sp,sp,-32
     940:	ec06                	sd	ra,24(sp)
     942:	e822                	sd	s0,16(sp)
     944:	e426                	sd	s1,8(sp)
     946:	e04a                	sd	s2,0(sp)
     948:	1000                	addi	s0,sp,32
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    pause(20);
     94a:	4951                	li	s2,20
    rand_next += 1;
     94c:	00001497          	auipc	s1,0x1
     950:	6b448493          	addi	s1,s1,1716 # 2000 <rand_next>
     954:	a809                	j	966 <main+0x28>
      iter();
     956:	f1dff0ef          	jal	872 <iter>
    pause(20);
     95a:	854a                	mv	a0,s2
     95c:	3a6000ef          	jal	d02 <pause>
    rand_next += 1;
     960:	609c                	ld	a5,0(s1)
     962:	0785                	addi	a5,a5,1
     964:	e09c                	sd	a5,0(s1)
    int pid = fork();
     966:	304000ef          	jal	c6a <fork>
    if(pid == 0){
     96a:	d575                	beqz	a0,956 <main+0x18>
    if(pid > 0){
     96c:	fea057e3          	blez	a0,95a <main+0x1c>
      wait(0);
     970:	4501                	li	a0,0
     972:	308000ef          	jal	c7a <wait>
     976:	b7d5                	j	95a <main+0x1c>

0000000000000978 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     978:	1141                	addi	sp,sp,-16
     97a:	e406                	sd	ra,8(sp)
     97c:	e022                	sd	s0,0(sp)
     97e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     980:	fbfff0ef          	jal	93e <main>
  exit(r);
     984:	2ee000ef          	jal	c72 <exit>

0000000000000988 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     988:	1141                	addi	sp,sp,-16
     98a:	e406                	sd	ra,8(sp)
     98c:	e022                	sd	s0,0(sp)
     98e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     990:	87aa                	mv	a5,a0
     992:	0585                	addi	a1,a1,1
     994:	0785                	addi	a5,a5,1
     996:	fff5c703          	lbu	a4,-1(a1)
     99a:	fee78fa3          	sb	a4,-1(a5)
     99e:	fb75                	bnez	a4,992 <strcpy+0xa>
    ;
  return os;
}
     9a0:	60a2                	ld	ra,8(sp)
     9a2:	6402                	ld	s0,0(sp)
     9a4:	0141                	addi	sp,sp,16
     9a6:	8082                	ret

00000000000009a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9a8:	1141                	addi	sp,sp,-16
     9aa:	e406                	sd	ra,8(sp)
     9ac:	e022                	sd	s0,0(sp)
     9ae:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9b0:	00054783          	lbu	a5,0(a0)
     9b4:	cb91                	beqz	a5,9c8 <strcmp+0x20>
     9b6:	0005c703          	lbu	a4,0(a1)
     9ba:	00f71763          	bne	a4,a5,9c8 <strcmp+0x20>
    p++, q++;
     9be:	0505                	addi	a0,a0,1
     9c0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9c2:	00054783          	lbu	a5,0(a0)
     9c6:	fbe5                	bnez	a5,9b6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     9c8:	0005c503          	lbu	a0,0(a1)
}
     9cc:	40a7853b          	subw	a0,a5,a0
     9d0:	60a2                	ld	ra,8(sp)
     9d2:	6402                	ld	s0,0(sp)
     9d4:	0141                	addi	sp,sp,16
     9d6:	8082                	ret

00000000000009d8 <strlen>:

uint
strlen(const char *s)
{
     9d8:	1141                	addi	sp,sp,-16
     9da:	e406                	sd	ra,8(sp)
     9dc:	e022                	sd	s0,0(sp)
     9de:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9e0:	00054783          	lbu	a5,0(a0)
     9e4:	cf99                	beqz	a5,a02 <strlen+0x2a>
     9e6:	0505                	addi	a0,a0,1
     9e8:	87aa                	mv	a5,a0
     9ea:	86be                	mv	a3,a5
     9ec:	0785                	addi	a5,a5,1
     9ee:	fff7c703          	lbu	a4,-1(a5)
     9f2:	ff65                	bnez	a4,9ea <strlen+0x12>
     9f4:	40a6853b          	subw	a0,a3,a0
     9f8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     9fa:	60a2                	ld	ra,8(sp)
     9fc:	6402                	ld	s0,0(sp)
     9fe:	0141                	addi	sp,sp,16
     a00:	8082                	ret
  for(n = 0; s[n]; n++)
     a02:	4501                	li	a0,0
     a04:	bfdd                	j	9fa <strlen+0x22>

0000000000000a06 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a06:	1141                	addi	sp,sp,-16
     a08:	e406                	sd	ra,8(sp)
     a0a:	e022                	sd	s0,0(sp)
     a0c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a0e:	ca19                	beqz	a2,a24 <memset+0x1e>
     a10:	87aa                	mv	a5,a0
     a12:	1602                	slli	a2,a2,0x20
     a14:	9201                	srli	a2,a2,0x20
     a16:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a1a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a1e:	0785                	addi	a5,a5,1
     a20:	fee79de3          	bne	a5,a4,a1a <memset+0x14>
  }
  return dst;
}
     a24:	60a2                	ld	ra,8(sp)
     a26:	6402                	ld	s0,0(sp)
     a28:	0141                	addi	sp,sp,16
     a2a:	8082                	ret

0000000000000a2c <strchr>:

char*
strchr(const char *s, char c)
{
     a2c:	1141                	addi	sp,sp,-16
     a2e:	e406                	sd	ra,8(sp)
     a30:	e022                	sd	s0,0(sp)
     a32:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a34:	00054783          	lbu	a5,0(a0)
     a38:	cf81                	beqz	a5,a50 <strchr+0x24>
    if(*s == c)
     a3a:	00f58763          	beq	a1,a5,a48 <strchr+0x1c>
  for(; *s; s++)
     a3e:	0505                	addi	a0,a0,1
     a40:	00054783          	lbu	a5,0(a0)
     a44:	fbfd                	bnez	a5,a3a <strchr+0xe>
      return (char*)s;
  return 0;
     a46:	4501                	li	a0,0
}
     a48:	60a2                	ld	ra,8(sp)
     a4a:	6402                	ld	s0,0(sp)
     a4c:	0141                	addi	sp,sp,16
     a4e:	8082                	ret
  return 0;
     a50:	4501                	li	a0,0
     a52:	bfdd                	j	a48 <strchr+0x1c>

0000000000000a54 <gets>:

char*
gets(char *buf, int max)
{
     a54:	7159                	addi	sp,sp,-112
     a56:	f486                	sd	ra,104(sp)
     a58:	f0a2                	sd	s0,96(sp)
     a5a:	eca6                	sd	s1,88(sp)
     a5c:	e8ca                	sd	s2,80(sp)
     a5e:	e4ce                	sd	s3,72(sp)
     a60:	e0d2                	sd	s4,64(sp)
     a62:	fc56                	sd	s5,56(sp)
     a64:	f85a                	sd	s6,48(sp)
     a66:	f45e                	sd	s7,40(sp)
     a68:	f062                	sd	s8,32(sp)
     a6a:	ec66                	sd	s9,24(sp)
     a6c:	e86a                	sd	s10,16(sp)
     a6e:	1880                	addi	s0,sp,112
     a70:	8caa                	mv	s9,a0
     a72:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a74:	892a                	mv	s2,a0
     a76:	4481                	li	s1,0
    cc = read(0, &c, 1);
     a78:	f9f40b13          	addi	s6,s0,-97
     a7c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a7e:	4ba9                	li	s7,10
     a80:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     a82:	8d26                	mv	s10,s1
     a84:	0014899b          	addiw	s3,s1,1
     a88:	84ce                	mv	s1,s3
     a8a:	0349d563          	bge	s3,s4,ab4 <gets+0x60>
    cc = read(0, &c, 1);
     a8e:	8656                	mv	a2,s5
     a90:	85da                	mv	a1,s6
     a92:	4501                	li	a0,0
     a94:	1f6000ef          	jal	c8a <read>
    if(cc < 1)
     a98:	00a05e63          	blez	a0,ab4 <gets+0x60>
    buf[i++] = c;
     a9c:	f9f44783          	lbu	a5,-97(s0)
     aa0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     aa4:	01778763          	beq	a5,s7,ab2 <gets+0x5e>
     aa8:	0905                	addi	s2,s2,1
     aaa:	fd879ce3          	bne	a5,s8,a82 <gets+0x2e>
    buf[i++] = c;
     aae:	8d4e                	mv	s10,s3
     ab0:	a011                	j	ab4 <gets+0x60>
     ab2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     ab4:	9d66                	add	s10,s10,s9
     ab6:	000d0023          	sb	zero,0(s10)
  return buf;
}
     aba:	8566                	mv	a0,s9
     abc:	70a6                	ld	ra,104(sp)
     abe:	7406                	ld	s0,96(sp)
     ac0:	64e6                	ld	s1,88(sp)
     ac2:	6946                	ld	s2,80(sp)
     ac4:	69a6                	ld	s3,72(sp)
     ac6:	6a06                	ld	s4,64(sp)
     ac8:	7ae2                	ld	s5,56(sp)
     aca:	7b42                	ld	s6,48(sp)
     acc:	7ba2                	ld	s7,40(sp)
     ace:	7c02                	ld	s8,32(sp)
     ad0:	6ce2                	ld	s9,24(sp)
     ad2:	6d42                	ld	s10,16(sp)
     ad4:	6165                	addi	sp,sp,112
     ad6:	8082                	ret

0000000000000ad8 <stat>:

int
stat(const char *n, struct stat *st)
{
     ad8:	1101                	addi	sp,sp,-32
     ada:	ec06                	sd	ra,24(sp)
     adc:	e822                	sd	s0,16(sp)
     ade:	e04a                	sd	s2,0(sp)
     ae0:	1000                	addi	s0,sp,32
     ae2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ae4:	4581                	li	a1,0
     ae6:	1cc000ef          	jal	cb2 <open>
  if(fd < 0)
     aea:	02054263          	bltz	a0,b0e <stat+0x36>
     aee:	e426                	sd	s1,8(sp)
     af0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     af2:	85ca                	mv	a1,s2
     af4:	1d6000ef          	jal	cca <fstat>
     af8:	892a                	mv	s2,a0
  close(fd);
     afa:	8526                	mv	a0,s1
     afc:	19e000ef          	jal	c9a <close>
  return r;
     b00:	64a2                	ld	s1,8(sp)
}
     b02:	854a                	mv	a0,s2
     b04:	60e2                	ld	ra,24(sp)
     b06:	6442                	ld	s0,16(sp)
     b08:	6902                	ld	s2,0(sp)
     b0a:	6105                	addi	sp,sp,32
     b0c:	8082                	ret
    return -1;
     b0e:	597d                	li	s2,-1
     b10:	bfcd                	j	b02 <stat+0x2a>

0000000000000b12 <atoi>:

int
atoi(const char *s)
{
     b12:	1141                	addi	sp,sp,-16
     b14:	e406                	sd	ra,8(sp)
     b16:	e022                	sd	s0,0(sp)
     b18:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b1a:	00054683          	lbu	a3,0(a0)
     b1e:	fd06879b          	addiw	a5,a3,-48
     b22:	0ff7f793          	zext.b	a5,a5
     b26:	4625                	li	a2,9
     b28:	02f66963          	bltu	a2,a5,b5a <atoi+0x48>
     b2c:	872a                	mv	a4,a0
  n = 0;
     b2e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b30:	0705                	addi	a4,a4,1
     b32:	0025179b          	slliw	a5,a0,0x2
     b36:	9fa9                	addw	a5,a5,a0
     b38:	0017979b          	slliw	a5,a5,0x1
     b3c:	9fb5                	addw	a5,a5,a3
     b3e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b42:	00074683          	lbu	a3,0(a4)
     b46:	fd06879b          	addiw	a5,a3,-48
     b4a:	0ff7f793          	zext.b	a5,a5
     b4e:	fef671e3          	bgeu	a2,a5,b30 <atoi+0x1e>
  return n;
}
     b52:	60a2                	ld	ra,8(sp)
     b54:	6402                	ld	s0,0(sp)
     b56:	0141                	addi	sp,sp,16
     b58:	8082                	ret
  n = 0;
     b5a:	4501                	li	a0,0
     b5c:	bfdd                	j	b52 <atoi+0x40>

0000000000000b5e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b5e:	1141                	addi	sp,sp,-16
     b60:	e406                	sd	ra,8(sp)
     b62:	e022                	sd	s0,0(sp)
     b64:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b66:	02b57563          	bgeu	a0,a1,b90 <memmove+0x32>
    while(n-- > 0)
     b6a:	00c05f63          	blez	a2,b88 <memmove+0x2a>
     b6e:	1602                	slli	a2,a2,0x20
     b70:	9201                	srli	a2,a2,0x20
     b72:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b76:	872a                	mv	a4,a0
      *dst++ = *src++;
     b78:	0585                	addi	a1,a1,1
     b7a:	0705                	addi	a4,a4,1
     b7c:	fff5c683          	lbu	a3,-1(a1)
     b80:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b84:	fee79ae3          	bne	a5,a4,b78 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b88:	60a2                	ld	ra,8(sp)
     b8a:	6402                	ld	s0,0(sp)
     b8c:	0141                	addi	sp,sp,16
     b8e:	8082                	ret
    dst += n;
     b90:	00c50733          	add	a4,a0,a2
    src += n;
     b94:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b96:	fec059e3          	blez	a2,b88 <memmove+0x2a>
     b9a:	fff6079b          	addiw	a5,a2,-1
     b9e:	1782                	slli	a5,a5,0x20
     ba0:	9381                	srli	a5,a5,0x20
     ba2:	fff7c793          	not	a5,a5
     ba6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ba8:	15fd                	addi	a1,a1,-1
     baa:	177d                	addi	a4,a4,-1
     bac:	0005c683          	lbu	a3,0(a1)
     bb0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     bb4:	fef71ae3          	bne	a4,a5,ba8 <memmove+0x4a>
     bb8:	bfc1                	j	b88 <memmove+0x2a>

0000000000000bba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bba:	1141                	addi	sp,sp,-16
     bbc:	e406                	sd	ra,8(sp)
     bbe:	e022                	sd	s0,0(sp)
     bc0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bc2:	ca0d                	beqz	a2,bf4 <memcmp+0x3a>
     bc4:	fff6069b          	addiw	a3,a2,-1
     bc8:	1682                	slli	a3,a3,0x20
     bca:	9281                	srli	a3,a3,0x20
     bcc:	0685                	addi	a3,a3,1
     bce:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     bd0:	00054783          	lbu	a5,0(a0)
     bd4:	0005c703          	lbu	a4,0(a1)
     bd8:	00e79863          	bne	a5,a4,be8 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     bdc:	0505                	addi	a0,a0,1
    p2++;
     bde:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     be0:	fed518e3          	bne	a0,a3,bd0 <memcmp+0x16>
  }
  return 0;
     be4:	4501                	li	a0,0
     be6:	a019                	j	bec <memcmp+0x32>
      return *p1 - *p2;
     be8:	40e7853b          	subw	a0,a5,a4
}
     bec:	60a2                	ld	ra,8(sp)
     bee:	6402                	ld	s0,0(sp)
     bf0:	0141                	addi	sp,sp,16
     bf2:	8082                	ret
  return 0;
     bf4:	4501                	li	a0,0
     bf6:	bfdd                	j	bec <memcmp+0x32>

0000000000000bf8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bf8:	1141                	addi	sp,sp,-16
     bfa:	e406                	sd	ra,8(sp)
     bfc:	e022                	sd	s0,0(sp)
     bfe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c00:	f5fff0ef          	jal	b5e <memmove>
}
     c04:	60a2                	ld	ra,8(sp)
     c06:	6402                	ld	s0,0(sp)
     c08:	0141                	addi	sp,sp,16
     c0a:	8082                	ret

0000000000000c0c <sbrk>:

char *
sbrk(int n) {
     c0c:	1141                	addi	sp,sp,-16
     c0e:	e406                	sd	ra,8(sp)
     c10:	e022                	sd	s0,0(sp)
     c12:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c14:	4585                	li	a1,1
     c16:	0e4000ef          	jal	cfa <sys_sbrk>
}
     c1a:	60a2                	ld	ra,8(sp)
     c1c:	6402                	ld	s0,0(sp)
     c1e:	0141                	addi	sp,sp,16
     c20:	8082                	ret

0000000000000c22 <sbrklazy>:

char *
sbrklazy(int n) {
     c22:	1141                	addi	sp,sp,-16
     c24:	e406                	sd	ra,8(sp)
     c26:	e022                	sd	s0,0(sp)
     c28:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c2a:	4589                	li	a1,2
     c2c:	0ce000ef          	jal	cfa <sys_sbrk>
}
     c30:	60a2                	ld	ra,8(sp)
     c32:	6402                	ld	s0,0(sp)
     c34:	0141                	addi	sp,sp,16
     c36:	8082                	ret

0000000000000c38 <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
     c38:	1101                	addi	sp,sp,-32
     c3a:	ec06                	sd	ra,24(sp)
     c3c:	e822                	sd	s0,16(sp)
     c3e:	e426                	sd	s1,8(sp)
     c40:	e04a                	sd	s2,0(sp)
     c42:	1000                	addi	s0,sp,32
     c44:	84aa                	mv	s1,a0
     c46:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
     c48:	6505                	lui	a0,0x1
     c4a:	fc3ff0ef          	jal	c0c <sbrk>
     c4e:	6785                	lui	a5,0x1
     c50:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
     c54:	9a41                	andi	a2,a2,-16
     c56:	85ca                	mv	a1,s2
     c58:	8526                	mv	a0,s1
     c5a:	0b8000ef          	jal	d12 <clone>
     c5e:	60e2                	ld	ra,24(sp)
     c60:	6442                	ld	s0,16(sp)
     c62:	64a2                	ld	s1,8(sp)
     c64:	6902                	ld	s2,0(sp)
     c66:	6105                	addi	sp,sp,32
     c68:	8082                	ret

0000000000000c6a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c6a:	4885                	li	a7,1
 ecall
     c6c:	00000073          	ecall
 ret
     c70:	8082                	ret

0000000000000c72 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c72:	4889                	li	a7,2
 ecall
     c74:	00000073          	ecall
 ret
     c78:	8082                	ret

0000000000000c7a <wait>:
.global wait
wait:
 li a7, SYS_wait
     c7a:	488d                	li	a7,3
 ecall
     c7c:	00000073          	ecall
 ret
     c80:	8082                	ret

0000000000000c82 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c82:	4891                	li	a7,4
 ecall
     c84:	00000073          	ecall
 ret
     c88:	8082                	ret

0000000000000c8a <read>:
.global read
read:
 li a7, SYS_read
     c8a:	4895                	li	a7,5
 ecall
     c8c:	00000073          	ecall
 ret
     c90:	8082                	ret

0000000000000c92 <write>:
.global write
write:
 li a7, SYS_write
     c92:	48c1                	li	a7,16
 ecall
     c94:	00000073          	ecall
 ret
     c98:	8082                	ret

0000000000000c9a <close>:
.global close
close:
 li a7, SYS_close
     c9a:	48d5                	li	a7,21
 ecall
     c9c:	00000073          	ecall
 ret
     ca0:	8082                	ret

0000000000000ca2 <kill>:
.global kill
kill:
 li a7, SYS_kill
     ca2:	4899                	li	a7,6
 ecall
     ca4:	00000073          	ecall
 ret
     ca8:	8082                	ret

0000000000000caa <exec>:
.global exec
exec:
 li a7, SYS_exec
     caa:	489d                	li	a7,7
 ecall
     cac:	00000073          	ecall
 ret
     cb0:	8082                	ret

0000000000000cb2 <open>:
.global open
open:
 li a7, SYS_open
     cb2:	48bd                	li	a7,15
 ecall
     cb4:	00000073          	ecall
 ret
     cb8:	8082                	ret

0000000000000cba <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     cba:	48c5                	li	a7,17
 ecall
     cbc:	00000073          	ecall
 ret
     cc0:	8082                	ret

0000000000000cc2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     cc2:	48c9                	li	a7,18
 ecall
     cc4:	00000073          	ecall
 ret
     cc8:	8082                	ret

0000000000000cca <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     cca:	48a1                	li	a7,8
 ecall
     ccc:	00000073          	ecall
 ret
     cd0:	8082                	ret

0000000000000cd2 <link>:
.global link
link:
 li a7, SYS_link
     cd2:	48cd                	li	a7,19
 ecall
     cd4:	00000073          	ecall
 ret
     cd8:	8082                	ret

0000000000000cda <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     cda:	48d1                	li	a7,20
 ecall
     cdc:	00000073          	ecall
 ret
     ce0:	8082                	ret

0000000000000ce2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ce2:	48a5                	li	a7,9
 ecall
     ce4:	00000073          	ecall
 ret
     ce8:	8082                	ret

0000000000000cea <dup>:
.global dup
dup:
 li a7, SYS_dup
     cea:	48a9                	li	a7,10
 ecall
     cec:	00000073          	ecall
 ret
     cf0:	8082                	ret

0000000000000cf2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     cf2:	48ad                	li	a7,11
 ecall
     cf4:	00000073          	ecall
 ret
     cf8:	8082                	ret

0000000000000cfa <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     cfa:	48b1                	li	a7,12
 ecall
     cfc:	00000073          	ecall
 ret
     d00:	8082                	ret

0000000000000d02 <pause>:
.global pause
pause:
 li a7, SYS_pause
     d02:	48b5                	li	a7,13
 ecall
     d04:	00000073          	ecall
 ret
     d08:	8082                	ret

0000000000000d0a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     d0a:	48b9                	li	a7,14
 ecall
     d0c:	00000073          	ecall
 ret
     d10:	8082                	ret

0000000000000d12 <clone>:
.global clone
clone:
 li a7, SYS_clone
     d12:	48d9                	li	a7,22
 ecall
     d14:	00000073          	ecall
 ret
     d18:	8082                	ret

0000000000000d1a <join>:
.global join
join:
 li a7, SYS_join
     d1a:	48dd                	li	a7,23
 ecall
     d1c:	00000073          	ecall
 ret
     d20:	8082                	ret

0000000000000d22 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d22:	1101                	addi	sp,sp,-32
     d24:	ec06                	sd	ra,24(sp)
     d26:	e822                	sd	s0,16(sp)
     d28:	1000                	addi	s0,sp,32
     d2a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d2e:	4605                	li	a2,1
     d30:	fef40593          	addi	a1,s0,-17
     d34:	f5fff0ef          	jal	c92 <write>
}
     d38:	60e2                	ld	ra,24(sp)
     d3a:	6442                	ld	s0,16(sp)
     d3c:	6105                	addi	sp,sp,32
     d3e:	8082                	ret

0000000000000d40 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     d40:	715d                	addi	sp,sp,-80
     d42:	e486                	sd	ra,72(sp)
     d44:	e0a2                	sd	s0,64(sp)
     d46:	fc26                	sd	s1,56(sp)
     d48:	f84a                	sd	s2,48(sp)
     d4a:	f44e                	sd	s3,40(sp)
     d4c:	0880                	addi	s0,sp,80
     d4e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     d50:	c299                	beqz	a3,d56 <printint+0x16>
     d52:	0605cc63          	bltz	a1,dca <printint+0x8a>
  neg = 0;
     d56:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     d58:	fb840313          	addi	t1,s0,-72
  neg = 0;
     d5c:	869a                	mv	a3,t1
  i = 0;
     d5e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     d60:	00001817          	auipc	a6,0x1
     d64:	86080813          	addi	a6,a6,-1952 # 15c0 <digits>
     d68:	88be                	mv	a7,a5
     d6a:	0017851b          	addiw	a0,a5,1 # 1001 <vprintf+0x22f>
     d6e:	87aa                	mv	a5,a0
     d70:	02c5f733          	remu	a4,a1,a2
     d74:	9742                	add	a4,a4,a6
     d76:	00074703          	lbu	a4,0(a4)
     d7a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     d7e:	872e                	mv	a4,a1
     d80:	02c5d5b3          	divu	a1,a1,a2
     d84:	0685                	addi	a3,a3,1
     d86:	fec771e3          	bgeu	a4,a2,d68 <printint+0x28>
  if(neg)
     d8a:	000e0c63          	beqz	t3,da2 <printint+0x62>
    buf[i++] = '-';
     d8e:	fd050793          	addi	a5,a0,-48 # fd0 <vprintf+0x1fe>
     d92:	00878533          	add	a0,a5,s0
     d96:	02d00793          	li	a5,45
     d9a:	fef50423          	sb	a5,-24(a0)
     d9e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
     da2:	fff7899b          	addiw	s3,a5,-1
     da6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
     daa:	fff4c583          	lbu	a1,-1(s1)
     dae:	854a                	mv	a0,s2
     db0:	f73ff0ef          	jal	d22 <putc>
  while(--i >= 0)
     db4:	39fd                	addiw	s3,s3,-1
     db6:	14fd                	addi	s1,s1,-1
     db8:	fe09d9e3          	bgez	s3,daa <printint+0x6a>
}
     dbc:	60a6                	ld	ra,72(sp)
     dbe:	6406                	ld	s0,64(sp)
     dc0:	74e2                	ld	s1,56(sp)
     dc2:	7942                	ld	s2,48(sp)
     dc4:	79a2                	ld	s3,40(sp)
     dc6:	6161                	addi	sp,sp,80
     dc8:	8082                	ret
    x = -xx;
     dca:	40b005b3          	neg	a1,a1
    neg = 1;
     dce:	4e05                	li	t3,1
    x = -xx;
     dd0:	b761                	j	d58 <printint+0x18>

0000000000000dd2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     dd2:	711d                	addi	sp,sp,-96
     dd4:	ec86                	sd	ra,88(sp)
     dd6:	e8a2                	sd	s0,80(sp)
     dd8:	e4a6                	sd	s1,72(sp)
     dda:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     ddc:	0005c483          	lbu	s1,0(a1)
     de0:	28048463          	beqz	s1,1068 <vprintf+0x296>
     de4:	e0ca                	sd	s2,64(sp)
     de6:	fc4e                	sd	s3,56(sp)
     de8:	f852                	sd	s4,48(sp)
     dea:	f456                	sd	s5,40(sp)
     dec:	f05a                	sd	s6,32(sp)
     dee:	ec5e                	sd	s7,24(sp)
     df0:	e862                	sd	s8,16(sp)
     df2:	e466                	sd	s9,8(sp)
     df4:	8b2a                	mv	s6,a0
     df6:	8a2e                	mv	s4,a1
     df8:	8bb2                	mv	s7,a2
  state = 0;
     dfa:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     dfc:	4901                	li	s2,0
     dfe:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     e00:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     e04:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e08:	06c00c93          	li	s9,108
     e0c:	a00d                	j	e2e <vprintf+0x5c>
        putc(fd, c0);
     e0e:	85a6                	mv	a1,s1
     e10:	855a                	mv	a0,s6
     e12:	f11ff0ef          	jal	d22 <putc>
     e16:	a019                	j	e1c <vprintf+0x4a>
    } else if(state == '%'){
     e18:	03598363          	beq	s3,s5,e3e <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
     e1c:	0019079b          	addiw	a5,s2,1
     e20:	893e                	mv	s2,a5
     e22:	873e                	mv	a4,a5
     e24:	97d2                	add	a5,a5,s4
     e26:	0007c483          	lbu	s1,0(a5)
     e2a:	22048763          	beqz	s1,1058 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
     e2e:	0004879b          	sext.w	a5,s1
    if(state == 0){
     e32:	fe0993e3          	bnez	s3,e18 <vprintf+0x46>
      if(c0 == '%'){
     e36:	fd579ce3          	bne	a5,s5,e0e <vprintf+0x3c>
        state = '%';
     e3a:	89be                	mv	s3,a5
     e3c:	b7c5                	j	e1c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     e3e:	00ea06b3          	add	a3,s4,a4
     e42:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e46:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     e48:	c681                	beqz	a3,e50 <vprintf+0x7e>
     e4a:	9752                	add	a4,a4,s4
     e4c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     e50:	05878263          	beq	a5,s8,e94 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     e54:	05978c63          	beq	a5,s9,eac <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     e58:	07500713          	li	a4,117
     e5c:	0ee78663          	beq	a5,a4,f48 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     e60:	07800713          	li	a4,120
     e64:	12e78863          	beq	a5,a4,f94 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e68:	07000713          	li	a4,112
     e6c:	14e78d63          	beq	a5,a4,fc6 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
     e70:	06300713          	li	a4,99
     e74:	18e78c63          	beq	a5,a4,100c <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
     e78:	07300713          	li	a4,115
     e7c:	1ae78263          	beq	a5,a4,1020 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e80:	02500713          	li	a4,37
     e84:	04e79463          	bne	a5,a4,ecc <vprintf+0xfa>
        putc(fd, '%');
     e88:	85ba                	mv	a1,a4
     e8a:	855a                	mv	a0,s6
     e8c:	e97ff0ef          	jal	d22 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e90:	4981                	li	s3,0
     e92:	b769                	j	e1c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     e94:	008b8493          	addi	s1,s7,8
     e98:	4685                	li	a3,1
     e9a:	4629                	li	a2,10
     e9c:	000ba583          	lw	a1,0(s7)
     ea0:	855a                	mv	a0,s6
     ea2:	e9fff0ef          	jal	d40 <printint>
     ea6:	8ba6                	mv	s7,s1
      state = 0;
     ea8:	4981                	li	s3,0
     eaa:	bf8d                	j	e1c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     eac:	06400793          	li	a5,100
     eb0:	02f68963          	beq	a3,a5,ee2 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     eb4:	06c00793          	li	a5,108
     eb8:	04f68263          	beq	a3,a5,efc <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
     ebc:	07500793          	li	a5,117
     ec0:	0af68063          	beq	a3,a5,f60 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
     ec4:	07800793          	li	a5,120
     ec8:	0ef68263          	beq	a3,a5,fac <vprintf+0x1da>
        putc(fd, '%');
     ecc:	02500593          	li	a1,37
     ed0:	855a                	mv	a0,s6
     ed2:	e51ff0ef          	jal	d22 <putc>
        putc(fd, c0);
     ed6:	85a6                	mv	a1,s1
     ed8:	855a                	mv	a0,s6
     eda:	e49ff0ef          	jal	d22 <putc>
      state = 0;
     ede:	4981                	li	s3,0
     ee0:	bf35                	j	e1c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ee2:	008b8493          	addi	s1,s7,8
     ee6:	4685                	li	a3,1
     ee8:	4629                	li	a2,10
     eea:	000bb583          	ld	a1,0(s7)
     eee:	855a                	mv	a0,s6
     ef0:	e51ff0ef          	jal	d40 <printint>
        i += 1;
     ef4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     ef6:	8ba6                	mv	s7,s1
      state = 0;
     ef8:	4981                	li	s3,0
        i += 1;
     efa:	b70d                	j	e1c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     efc:	06400793          	li	a5,100
     f00:	02f60763          	beq	a2,a5,f2e <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     f04:	07500793          	li	a5,117
     f08:	06f60963          	beq	a2,a5,f7a <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     f0c:	07800793          	li	a5,120
     f10:	faf61ee3          	bne	a2,a5,ecc <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f14:	008b8493          	addi	s1,s7,8
     f18:	4681                	li	a3,0
     f1a:	4641                	li	a2,16
     f1c:	000bb583          	ld	a1,0(s7)
     f20:	855a                	mv	a0,s6
     f22:	e1fff0ef          	jal	d40 <printint>
        i += 2;
     f26:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f28:	8ba6                	mv	s7,s1
      state = 0;
     f2a:	4981                	li	s3,0
        i += 2;
     f2c:	bdc5                	j	e1c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f2e:	008b8493          	addi	s1,s7,8
     f32:	4685                	li	a3,1
     f34:	4629                	li	a2,10
     f36:	000bb583          	ld	a1,0(s7)
     f3a:	855a                	mv	a0,s6
     f3c:	e05ff0ef          	jal	d40 <printint>
        i += 2;
     f40:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f42:	8ba6                	mv	s7,s1
      state = 0;
     f44:	4981                	li	s3,0
        i += 2;
     f46:	bdd9                	j	e1c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
     f48:	008b8493          	addi	s1,s7,8
     f4c:	4681                	li	a3,0
     f4e:	4629                	li	a2,10
     f50:	000be583          	lwu	a1,0(s7)
     f54:	855a                	mv	a0,s6
     f56:	debff0ef          	jal	d40 <printint>
     f5a:	8ba6                	mv	s7,s1
      state = 0;
     f5c:	4981                	li	s3,0
     f5e:	bd7d                	j	e1c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f60:	008b8493          	addi	s1,s7,8
     f64:	4681                	li	a3,0
     f66:	4629                	li	a2,10
     f68:	000bb583          	ld	a1,0(s7)
     f6c:	855a                	mv	a0,s6
     f6e:	dd3ff0ef          	jal	d40 <printint>
        i += 1;
     f72:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f74:	8ba6                	mv	s7,s1
      state = 0;
     f76:	4981                	li	s3,0
        i += 1;
     f78:	b555                	j	e1c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f7a:	008b8493          	addi	s1,s7,8
     f7e:	4681                	li	a3,0
     f80:	4629                	li	a2,10
     f82:	000bb583          	ld	a1,0(s7)
     f86:	855a                	mv	a0,s6
     f88:	db9ff0ef          	jal	d40 <printint>
        i += 2;
     f8c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f8e:	8ba6                	mv	s7,s1
      state = 0;
     f90:	4981                	li	s3,0
        i += 2;
     f92:	b569                	j	e1c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
     f94:	008b8493          	addi	s1,s7,8
     f98:	4681                	li	a3,0
     f9a:	4641                	li	a2,16
     f9c:	000be583          	lwu	a1,0(s7)
     fa0:	855a                	mv	a0,s6
     fa2:	d9fff0ef          	jal	d40 <printint>
     fa6:	8ba6                	mv	s7,s1
      state = 0;
     fa8:	4981                	li	s3,0
     faa:	bd8d                	j	e1c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     fac:	008b8493          	addi	s1,s7,8
     fb0:	4681                	li	a3,0
     fb2:	4641                	li	a2,16
     fb4:	000bb583          	ld	a1,0(s7)
     fb8:	855a                	mv	a0,s6
     fba:	d87ff0ef          	jal	d40 <printint>
        i += 1;
     fbe:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     fc0:	8ba6                	mv	s7,s1
      state = 0;
     fc2:	4981                	li	s3,0
        i += 1;
     fc4:	bda1                	j	e1c <vprintf+0x4a>
     fc6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     fc8:	008b8d13          	addi	s10,s7,8
     fcc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     fd0:	03000593          	li	a1,48
     fd4:	855a                	mv	a0,s6
     fd6:	d4dff0ef          	jal	d22 <putc>
  putc(fd, 'x');
     fda:	07800593          	li	a1,120
     fde:	855a                	mv	a0,s6
     fe0:	d43ff0ef          	jal	d22 <putc>
     fe4:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fe6:	00000b97          	auipc	s7,0x0
     fea:	5dab8b93          	addi	s7,s7,1498 # 15c0 <digits>
     fee:	03c9d793          	srli	a5,s3,0x3c
     ff2:	97de                	add	a5,a5,s7
     ff4:	0007c583          	lbu	a1,0(a5)
     ff8:	855a                	mv	a0,s6
     ffa:	d29ff0ef          	jal	d22 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     ffe:	0992                	slli	s3,s3,0x4
    1000:	34fd                	addiw	s1,s1,-1
    1002:	f4f5                	bnez	s1,fee <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
    1004:	8bea                	mv	s7,s10
      state = 0;
    1006:	4981                	li	s3,0
    1008:	6d02                	ld	s10,0(sp)
    100a:	bd09                	j	e1c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    100c:	008b8493          	addi	s1,s7,8
    1010:	000bc583          	lbu	a1,0(s7)
    1014:	855a                	mv	a0,s6
    1016:	d0dff0ef          	jal	d22 <putc>
    101a:	8ba6                	mv	s7,s1
      state = 0;
    101c:	4981                	li	s3,0
    101e:	bbfd                	j	e1c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1020:	008b8993          	addi	s3,s7,8
    1024:	000bb483          	ld	s1,0(s7)
    1028:	cc91                	beqz	s1,1044 <vprintf+0x272>
        for(; *s; s++)
    102a:	0004c583          	lbu	a1,0(s1)
    102e:	c195                	beqz	a1,1052 <vprintf+0x280>
          putc(fd, *s);
    1030:	855a                	mv	a0,s6
    1032:	cf1ff0ef          	jal	d22 <putc>
        for(; *s; s++)
    1036:	0485                	addi	s1,s1,1
    1038:	0004c583          	lbu	a1,0(s1)
    103c:	f9f5                	bnez	a1,1030 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
    103e:	8bce                	mv	s7,s3
      state = 0;
    1040:	4981                	li	s3,0
    1042:	bbe9                	j	e1c <vprintf+0x4a>
          s = "(null)";
    1044:	00000497          	auipc	s1,0x0
    1048:	51448493          	addi	s1,s1,1300 # 1558 <malloc+0x404>
        for(; *s; s++)
    104c:	02800593          	li	a1,40
    1050:	b7c5                	j	1030 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
    1052:	8bce                	mv	s7,s3
      state = 0;
    1054:	4981                	li	s3,0
    1056:	b3d9                	j	e1c <vprintf+0x4a>
    1058:	6906                	ld	s2,64(sp)
    105a:	79e2                	ld	s3,56(sp)
    105c:	7a42                	ld	s4,48(sp)
    105e:	7aa2                	ld	s5,40(sp)
    1060:	7b02                	ld	s6,32(sp)
    1062:	6be2                	ld	s7,24(sp)
    1064:	6c42                	ld	s8,16(sp)
    1066:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1068:	60e6                	ld	ra,88(sp)
    106a:	6446                	ld	s0,80(sp)
    106c:	64a6                	ld	s1,72(sp)
    106e:	6125                	addi	sp,sp,96
    1070:	8082                	ret

0000000000001072 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1072:	715d                	addi	sp,sp,-80
    1074:	ec06                	sd	ra,24(sp)
    1076:	e822                	sd	s0,16(sp)
    1078:	1000                	addi	s0,sp,32
    107a:	e010                	sd	a2,0(s0)
    107c:	e414                	sd	a3,8(s0)
    107e:	e818                	sd	a4,16(s0)
    1080:	ec1c                	sd	a5,24(s0)
    1082:	03043023          	sd	a6,32(s0)
    1086:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    108a:	8622                	mv	a2,s0
    108c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1090:	d43ff0ef          	jal	dd2 <vprintf>
}
    1094:	60e2                	ld	ra,24(sp)
    1096:	6442                	ld	s0,16(sp)
    1098:	6161                	addi	sp,sp,80
    109a:	8082                	ret

000000000000109c <printf>:

void
printf(const char *fmt, ...)
{
    109c:	711d                	addi	sp,sp,-96
    109e:	ec06                	sd	ra,24(sp)
    10a0:	e822                	sd	s0,16(sp)
    10a2:	1000                	addi	s0,sp,32
    10a4:	e40c                	sd	a1,8(s0)
    10a6:	e810                	sd	a2,16(s0)
    10a8:	ec14                	sd	a3,24(s0)
    10aa:	f018                	sd	a4,32(s0)
    10ac:	f41c                	sd	a5,40(s0)
    10ae:	03043823          	sd	a6,48(s0)
    10b2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10b6:	00840613          	addi	a2,s0,8
    10ba:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10be:	85aa                	mv	a1,a0
    10c0:	4505                	li	a0,1
    10c2:	d11ff0ef          	jal	dd2 <vprintf>
}
    10c6:	60e2                	ld	ra,24(sp)
    10c8:	6442                	ld	s0,16(sp)
    10ca:	6125                	addi	sp,sp,96
    10cc:	8082                	ret

00000000000010ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10ce:	1141                	addi	sp,sp,-16
    10d0:	e406                	sd	ra,8(sp)
    10d2:	e022                	sd	s0,0(sp)
    10d4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10d6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10da:	00001797          	auipc	a5,0x1
    10de:	f367b783          	ld	a5,-202(a5) # 2010 <freep>
    10e2:	a02d                	j	110c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    10e4:	4618                	lw	a4,8(a2)
    10e6:	9f2d                	addw	a4,a4,a1
    10e8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10ec:	6398                	ld	a4,0(a5)
    10ee:	6310                	ld	a2,0(a4)
    10f0:	a83d                	j	112e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    10f2:	ff852703          	lw	a4,-8(a0)
    10f6:	9f31                	addw	a4,a4,a2
    10f8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    10fa:	ff053683          	ld	a3,-16(a0)
    10fe:	a091                	j	1142 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1100:	6398                	ld	a4,0(a5)
    1102:	00e7e463          	bltu	a5,a4,110a <free+0x3c>
    1106:	00e6ea63          	bltu	a3,a4,111a <free+0x4c>
{
    110a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    110c:	fed7fae3          	bgeu	a5,a3,1100 <free+0x32>
    1110:	6398                	ld	a4,0(a5)
    1112:	00e6e463          	bltu	a3,a4,111a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1116:	fee7eae3          	bltu	a5,a4,110a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    111a:	ff852583          	lw	a1,-8(a0)
    111e:	6390                	ld	a2,0(a5)
    1120:	02059813          	slli	a6,a1,0x20
    1124:	01c85713          	srli	a4,a6,0x1c
    1128:	9736                	add	a4,a4,a3
    112a:	fae60de3          	beq	a2,a4,10e4 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    112e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1132:	4790                	lw	a2,8(a5)
    1134:	02061593          	slli	a1,a2,0x20
    1138:	01c5d713          	srli	a4,a1,0x1c
    113c:	973e                	add	a4,a4,a5
    113e:	fae68ae3          	beq	a3,a4,10f2 <free+0x24>
    p->s.ptr = bp->s.ptr;
    1142:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1144:	00001717          	auipc	a4,0x1
    1148:	ecf73623          	sd	a5,-308(a4) # 2010 <freep>
}
    114c:	60a2                	ld	ra,8(sp)
    114e:	6402                	ld	s0,0(sp)
    1150:	0141                	addi	sp,sp,16
    1152:	8082                	ret

0000000000001154 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1154:	7139                	addi	sp,sp,-64
    1156:	fc06                	sd	ra,56(sp)
    1158:	f822                	sd	s0,48(sp)
    115a:	f04a                	sd	s2,32(sp)
    115c:	ec4e                	sd	s3,24(sp)
    115e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1160:	02051993          	slli	s3,a0,0x20
    1164:	0209d993          	srli	s3,s3,0x20
    1168:	09bd                	addi	s3,s3,15
    116a:	0049d993          	srli	s3,s3,0x4
    116e:	2985                	addiw	s3,s3,1
    1170:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1172:	00001517          	auipc	a0,0x1
    1176:	e9e53503          	ld	a0,-354(a0) # 2010 <freep>
    117a:	c905                	beqz	a0,11aa <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    117c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    117e:	4798                	lw	a4,8(a5)
    1180:	09377663          	bgeu	a4,s3,120c <malloc+0xb8>
    1184:	f426                	sd	s1,40(sp)
    1186:	e852                	sd	s4,16(sp)
    1188:	e456                	sd	s5,8(sp)
    118a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    118c:	8a4e                	mv	s4,s3
    118e:	6705                	lui	a4,0x1
    1190:	00e9f363          	bgeu	s3,a4,1196 <malloc+0x42>
    1194:	6a05                	lui	s4,0x1
    1196:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    119a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    119e:	00001497          	auipc	s1,0x1
    11a2:	e7248493          	addi	s1,s1,-398 # 2010 <freep>
  if(p == SBRK_ERROR)
    11a6:	5afd                	li	s5,-1
    11a8:	a83d                	j	11e6 <malloc+0x92>
    11aa:	f426                	sd	s1,40(sp)
    11ac:	e852                	sd	s4,16(sp)
    11ae:	e456                	sd	s5,8(sp)
    11b0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11b2:	00001797          	auipc	a5,0x1
    11b6:	25678793          	addi	a5,a5,598 # 2408 <base>
    11ba:	00001717          	auipc	a4,0x1
    11be:	e4f73b23          	sd	a5,-426(a4) # 2010 <freep>
    11c2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11c4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11c8:	b7d1                	j	118c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    11ca:	6398                	ld	a4,0(a5)
    11cc:	e118                	sd	a4,0(a0)
    11ce:	a899                	j	1224 <malloc+0xd0>
  hp->s.size = nu;
    11d0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11d4:	0541                	addi	a0,a0,16
    11d6:	ef9ff0ef          	jal	10ce <free>
  return freep;
    11da:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    11dc:	c125                	beqz	a0,123c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11e0:	4798                	lw	a4,8(a5)
    11e2:	03277163          	bgeu	a4,s2,1204 <malloc+0xb0>
    if(p == freep)
    11e6:	6098                	ld	a4,0(s1)
    11e8:	853e                	mv	a0,a5
    11ea:	fef71ae3          	bne	a4,a5,11de <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    11ee:	8552                	mv	a0,s4
    11f0:	a1dff0ef          	jal	c0c <sbrk>
  if(p == SBRK_ERROR)
    11f4:	fd551ee3          	bne	a0,s5,11d0 <malloc+0x7c>
        return 0;
    11f8:	4501                	li	a0,0
    11fa:	74a2                	ld	s1,40(sp)
    11fc:	6a42                	ld	s4,16(sp)
    11fe:	6aa2                	ld	s5,8(sp)
    1200:	6b02                	ld	s6,0(sp)
    1202:	a03d                	j	1230 <malloc+0xdc>
    1204:	74a2                	ld	s1,40(sp)
    1206:	6a42                	ld	s4,16(sp)
    1208:	6aa2                	ld	s5,8(sp)
    120a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    120c:	fae90fe3          	beq	s2,a4,11ca <malloc+0x76>
        p->s.size -= nunits;
    1210:	4137073b          	subw	a4,a4,s3
    1214:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1216:	02071693          	slli	a3,a4,0x20
    121a:	01c6d713          	srli	a4,a3,0x1c
    121e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1220:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1224:	00001717          	auipc	a4,0x1
    1228:	dea73623          	sd	a0,-532(a4) # 2010 <freep>
      return (void*)(p + 1);
    122c:	01078513          	addi	a0,a5,16
  }
}
    1230:	70e2                	ld	ra,56(sp)
    1232:	7442                	ld	s0,48(sp)
    1234:	7902                	ld	s2,32(sp)
    1236:	69e2                	ld	s3,24(sp)
    1238:	6121                	addi	sp,sp,64
    123a:	8082                	ret
    123c:	74a2                	ld	s1,40(sp)
    123e:	6a42                	ld	s4,16(sp)
    1240:	6aa2                	ld	s5,8(sp)
    1242:	6b02                	ld	s6,0(sp)
    1244:	b7f5                	j	1230 <malloc+0xdc>
