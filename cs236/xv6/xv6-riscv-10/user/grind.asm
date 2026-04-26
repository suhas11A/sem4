
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
      c4:	2e050513          	addi	a0,a0,736 # 13a0 <malloc+0xf6>
      c8:	559000ef          	jal	e20 <mkdir>
  if(chdir("grindir") != 0){
      cc:	00001517          	auipc	a0,0x1
      d0:	2d450513          	addi	a0,a0,724 # 13a0 <malloc+0xf6>
      d4:	555000ef          	jal	e28 <chdir>
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
      f2:	2ba50513          	addi	a0,a0,698 # 13a8 <malloc+0xfe>
      f6:	0fc010ef          	jal	11f2 <printf>
    exit(1);
      fa:	4505                	li	a0,1
      fc:	4bd000ef          	jal	db8 <exit>
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
     118:	2bc50513          	addi	a0,a0,700 # 13d0 <malloc+0x126>
     11c:	50d000ef          	jal	e28 <chdir>
     120:	00001c17          	auipc	s8,0x1
     124:	2c0c0c13          	addi	s8,s8,704 # 13e0 <malloc+0x136>
     128:	c489                	beqz	s1,132 <go+0x88>
     12a:	00001c17          	auipc	s8,0x1
     12e:	2aec0c13          	addi	s8,s8,686 # 13d8 <malloc+0x12e>
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
     15e:	55690913          	addi	s2,s2,1366 # 16b0 <malloc+0x406>
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
     170:	27c50513          	addi	a0,a0,636 # 13e8 <malloc+0x13e>
     174:	485000ef          	jal	df8 <open>
     178:	469000ef          	jal	de0 <close>
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
     196:	443000ef          	jal	dd8 <write>
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
     1dc:	22050513          	addi	a0,a0,544 # 13f8 <malloc+0x14e>
     1e0:	419000ef          	jal	df8 <open>
     1e4:	3fd000ef          	jal	de0 <close>
     1e8:	bf51                	j	17c <go+0xd2>
      unlink("grindir/../a");
     1ea:	00001517          	auipc	a0,0x1
     1ee:	1fe50513          	addi	a0,a0,510 # 13e8 <malloc+0x13e>
     1f2:	417000ef          	jal	e08 <unlink>
     1f6:	b759                	j	17c <go+0xd2>
      if(chdir("grindir") != 0){
     1f8:	00001517          	auipc	a0,0x1
     1fc:	1a850513          	addi	a0,a0,424 # 13a0 <malloc+0xf6>
     200:	429000ef          	jal	e28 <chdir>
     204:	ed11                	bnez	a0,220 <go+0x176>
      unlink("../b");
     206:	00001517          	auipc	a0,0x1
     20a:	20a50513          	addi	a0,a0,522 # 1410 <malloc+0x166>
     20e:	3fb000ef          	jal	e08 <unlink>
      chdir("/");
     212:	00001517          	auipc	a0,0x1
     216:	1be50513          	addi	a0,a0,446 # 13d0 <malloc+0x126>
     21a:	40f000ef          	jal	e28 <chdir>
     21e:	bfb9                	j	17c <go+0xd2>
        printf("grind: chdir grindir failed\n");
     220:	00001517          	auipc	a0,0x1
     224:	18850513          	addi	a0,a0,392 # 13a8 <malloc+0xfe>
     228:	7cb000ef          	jal	11f2 <printf>
        exit(1);
     22c:	4505                	li	a0,1
     22e:	38b000ef          	jal	db8 <exit>
      close(fd);
     232:	8566                	mv	a0,s9
     234:	3ad000ef          	jal	de0 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     238:	20200593          	li	a1,514
     23c:	00001517          	auipc	a0,0x1
     240:	1dc50513          	addi	a0,a0,476 # 1418 <malloc+0x16e>
     244:	3b5000ef          	jal	df8 <open>
     248:	8caa                	mv	s9,a0
     24a:	bf0d                	j	17c <go+0xd2>
      close(fd);
     24c:	8566                	mv	a0,s9
     24e:	393000ef          	jal	de0 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     252:	20200593          	li	a1,514
     256:	00001517          	auipc	a0,0x1
     25a:	1d250513          	addi	a0,a0,466 # 1428 <malloc+0x17e>
     25e:	39b000ef          	jal	df8 <open>
     262:	8caa                	mv	s9,a0
     264:	bf21                	j	17c <go+0xd2>
      write(fd, buf, sizeof(buf));
     266:	3e700613          	li	a2,999
     26a:	00002597          	auipc	a1,0x2
     26e:	db658593          	addi	a1,a1,-586 # 2020 <buf.0>
     272:	8566                	mv	a0,s9
     274:	365000ef          	jal	dd8 <write>
     278:	b711                	j	17c <go+0xd2>
      read(fd, buf, sizeof(buf));
     27a:	3e700613          	li	a2,999
     27e:	00002597          	auipc	a1,0x2
     282:	da258593          	addi	a1,a1,-606 # 2020 <buf.0>
     286:	8566                	mv	a0,s9
     288:	349000ef          	jal	dd0 <read>
     28c:	bdc5                	j	17c <go+0xd2>
      mkdir("grindir/../a");
     28e:	00001517          	auipc	a0,0x1
     292:	15a50513          	addi	a0,a0,346 # 13e8 <malloc+0x13e>
     296:	38b000ef          	jal	e20 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     29a:	20200593          	li	a1,514
     29e:	00001517          	auipc	a0,0x1
     2a2:	1a250513          	addi	a0,a0,418 # 1440 <malloc+0x196>
     2a6:	353000ef          	jal	df8 <open>
     2aa:	337000ef          	jal	de0 <close>
      unlink("a/a");
     2ae:	00001517          	auipc	a0,0x1
     2b2:	1a250513          	addi	a0,a0,418 # 1450 <malloc+0x1a6>
     2b6:	353000ef          	jal	e08 <unlink>
     2ba:	b5c9                	j	17c <go+0xd2>
      mkdir("/../b");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	19c50513          	addi	a0,a0,412 # 1458 <malloc+0x1ae>
     2c4:	35d000ef          	jal	e20 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2c8:	20200593          	li	a1,514
     2cc:	00001517          	auipc	a0,0x1
     2d0:	19450513          	addi	a0,a0,404 # 1460 <malloc+0x1b6>
     2d4:	325000ef          	jal	df8 <open>
     2d8:	309000ef          	jal	de0 <close>
      unlink("b/b");
     2dc:	00001517          	auipc	a0,0x1
     2e0:	19450513          	addi	a0,a0,404 # 1470 <malloc+0x1c6>
     2e4:	325000ef          	jal	e08 <unlink>
     2e8:	bd51                	j	17c <go+0xd2>
      unlink("b");
     2ea:	00001517          	auipc	a0,0x1
     2ee:	18e50513          	addi	a0,a0,398 # 1478 <malloc+0x1ce>
     2f2:	317000ef          	jal	e08 <unlink>
      link("../grindir/./../a", "../b");
     2f6:	00001597          	auipc	a1,0x1
     2fa:	11a58593          	addi	a1,a1,282 # 1410 <malloc+0x166>
     2fe:	00001517          	auipc	a0,0x1
     302:	18250513          	addi	a0,a0,386 # 1480 <malloc+0x1d6>
     306:	313000ef          	jal	e18 <link>
     30a:	bd8d                	j	17c <go+0xd2>
      unlink("../grindir/../a");
     30c:	00001517          	auipc	a0,0x1
     310:	18c50513          	addi	a0,a0,396 # 1498 <malloc+0x1ee>
     314:	2f5000ef          	jal	e08 <unlink>
      link(".././b", "/grindir/../a");
     318:	00001597          	auipc	a1,0x1
     31c:	10058593          	addi	a1,a1,256 # 1418 <malloc+0x16e>
     320:	00001517          	auipc	a0,0x1
     324:	18850513          	addi	a0,a0,392 # 14a8 <malloc+0x1fe>
     328:	2f1000ef          	jal	e18 <link>
     32c:	bd81                	j	17c <go+0xd2>
      int pid = fork();
     32e:	283000ef          	jal	db0 <fork>
      if(pid == 0){
     332:	c519                	beqz	a0,340 <go+0x296>
      } else if(pid < 0){
     334:	00054863          	bltz	a0,344 <go+0x29a>
      wait(0);
     338:	4501                	li	a0,0
     33a:	287000ef          	jal	dc0 <wait>
     33e:	bd3d                	j	17c <go+0xd2>
        exit(0);
     340:	279000ef          	jal	db8 <exit>
        printf("grind: fork failed\n");
     344:	00001517          	auipc	a0,0x1
     348:	16c50513          	addi	a0,a0,364 # 14b0 <malloc+0x206>
     34c:	6a7000ef          	jal	11f2 <printf>
        exit(1);
     350:	4505                	li	a0,1
     352:	267000ef          	jal	db8 <exit>
      int pid = fork();
     356:	25b000ef          	jal	db0 <fork>
      if(pid == 0){
     35a:	c519                	beqz	a0,368 <go+0x2be>
      } else if(pid < 0){
     35c:	00054d63          	bltz	a0,376 <go+0x2cc>
      wait(0);
     360:	4501                	li	a0,0
     362:	25f000ef          	jal	dc0 <wait>
     366:	bd19                	j	17c <go+0xd2>
        fork();
     368:	249000ef          	jal	db0 <fork>
        fork();
     36c:	245000ef          	jal	db0 <fork>
        exit(0);
     370:	4501                	li	a0,0
     372:	247000ef          	jal	db8 <exit>
        printf("grind: fork failed\n");
     376:	00001517          	auipc	a0,0x1
     37a:	13a50513          	addi	a0,a0,314 # 14b0 <malloc+0x206>
     37e:	675000ef          	jal	11f2 <printf>
        exit(1);
     382:	4505                	li	a0,1
     384:	235000ef          	jal	db8 <exit>
      sbrk(6011);
     388:	6505                	lui	a0,0x1
     38a:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x6b>
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
     3b6:	1fb000ef          	jal	db0 <fork>
     3ba:	8d2a                	mv	s10,a0
      if(pid == 0){
     3bc:	c10d                	beqz	a0,3de <go+0x334>
      } else if(pid < 0){
     3be:	02054d63          	bltz	a0,3f8 <go+0x34e>
      if(chdir("../grindir/..") != 0){
     3c2:	00001517          	auipc	a0,0x1
     3c6:	10e50513          	addi	a0,a0,270 # 14d0 <malloc+0x226>
     3ca:	25f000ef          	jal	e28 <chdir>
     3ce:	ed15                	bnez	a0,40a <go+0x360>
      kill(pid);
     3d0:	856a                	mv	a0,s10
     3d2:	217000ef          	jal	de8 <kill>
      wait(0);
     3d6:	4501                	li	a0,0
     3d8:	1e9000ef          	jal	dc0 <wait>
     3dc:	b345                	j	17c <go+0xd2>
        close(open("a", O_CREATE|O_RDWR));
     3de:	20200593          	li	a1,514
     3e2:	00001517          	auipc	a0,0x1
     3e6:	0e650513          	addi	a0,a0,230 # 14c8 <malloc+0x21e>
     3ea:	20f000ef          	jal	df8 <open>
     3ee:	1f3000ef          	jal	de0 <close>
        exit(0);
     3f2:	4501                	li	a0,0
     3f4:	1c5000ef          	jal	db8 <exit>
        printf("grind: fork failed\n");
     3f8:	00001517          	auipc	a0,0x1
     3fc:	0b850513          	addi	a0,a0,184 # 14b0 <malloc+0x206>
     400:	5f3000ef          	jal	11f2 <printf>
        exit(1);
     404:	4505                	li	a0,1
     406:	1b3000ef          	jal	db8 <exit>
        printf("grind: chdir failed\n");
     40a:	00001517          	auipc	a0,0x1
     40e:	0d650513          	addi	a0,a0,214 # 14e0 <malloc+0x236>
     412:	5e1000ef          	jal	11f2 <printf>
        exit(1);
     416:	4505                	li	a0,1
     418:	1a1000ef          	jal	db8 <exit>
      int pid = fork();
     41c:	195000ef          	jal	db0 <fork>
      if(pid == 0){
     420:	c519                	beqz	a0,42e <go+0x384>
      } else if(pid < 0){
     422:	00054d63          	bltz	a0,43c <go+0x392>
      wait(0);
     426:	4501                	li	a0,0
     428:	199000ef          	jal	dc0 <wait>
     42c:	bb81                	j	17c <go+0xd2>
        kill(getpid());
     42e:	20b000ef          	jal	e38 <getpid>
     432:	1b7000ef          	jal	de8 <kill>
        exit(0);
     436:	4501                	li	a0,0
     438:	181000ef          	jal	db8 <exit>
        printf("grind: fork failed\n");
     43c:	00001517          	auipc	a0,0x1
     440:	07450513          	addi	a0,a0,116 # 14b0 <malloc+0x206>
     444:	5af000ef          	jal	11f2 <printf>
        exit(1);
     448:	4505                	li	a0,1
     44a:	16f000ef          	jal	db8 <exit>
      if(pipe(fds) < 0){
     44e:	f7840513          	addi	a0,s0,-136
     452:	177000ef          	jal	dc8 <pipe>
     456:	02054363          	bltz	a0,47c <go+0x3d2>
      int pid = fork();
     45a:	157000ef          	jal	db0 <fork>
      if(pid == 0){
     45e:	c905                	beqz	a0,48e <go+0x3e4>
      } else if(pid < 0){
     460:	08054263          	bltz	a0,4e4 <go+0x43a>
      close(fds[0]);
     464:	f7842503          	lw	a0,-136(s0)
     468:	179000ef          	jal	de0 <close>
      close(fds[1]);
     46c:	f7c42503          	lw	a0,-132(s0)
     470:	171000ef          	jal	de0 <close>
      wait(0);
     474:	4501                	li	a0,0
     476:	14b000ef          	jal	dc0 <wait>
     47a:	b309                	j	17c <go+0xd2>
        printf("grind: pipe failed\n");
     47c:	00001517          	auipc	a0,0x1
     480:	07c50513          	addi	a0,a0,124 # 14f8 <malloc+0x24e>
     484:	56f000ef          	jal	11f2 <printf>
        exit(1);
     488:	4505                	li	a0,1
     48a:	12f000ef          	jal	db8 <exit>
        fork();
     48e:	123000ef          	jal	db0 <fork>
        fork();
     492:	11f000ef          	jal	db0 <fork>
        if(write(fds[1], "x", 1) != 1)
     496:	4605                	li	a2,1
     498:	00001597          	auipc	a1,0x1
     49c:	07858593          	addi	a1,a1,120 # 1510 <malloc+0x266>
     4a0:	f7c42503          	lw	a0,-132(s0)
     4a4:	135000ef          	jal	dd8 <write>
     4a8:	4785                	li	a5,1
     4aa:	00f51f63          	bne	a0,a5,4c8 <go+0x41e>
        if(read(fds[0], &c, 1) != 1)
     4ae:	4605                	li	a2,1
     4b0:	f7040593          	addi	a1,s0,-144
     4b4:	f7842503          	lw	a0,-136(s0)
     4b8:	119000ef          	jal	dd0 <read>
     4bc:	4785                	li	a5,1
     4be:	00f51c63          	bne	a0,a5,4d6 <go+0x42c>
        exit(0);
     4c2:	4501                	li	a0,0
     4c4:	0f5000ef          	jal	db8 <exit>
          printf("grind: pipe write failed\n");
     4c8:	00001517          	auipc	a0,0x1
     4cc:	05050513          	addi	a0,a0,80 # 1518 <malloc+0x26e>
     4d0:	523000ef          	jal	11f2 <printf>
     4d4:	bfe9                	j	4ae <go+0x404>
          printf("grind: pipe read failed\n");
     4d6:	00001517          	auipc	a0,0x1
     4da:	06250513          	addi	a0,a0,98 # 1538 <malloc+0x28e>
     4de:	515000ef          	jal	11f2 <printf>
     4e2:	b7c5                	j	4c2 <go+0x418>
        printf("grind: fork failed\n");
     4e4:	00001517          	auipc	a0,0x1
     4e8:	fcc50513          	addi	a0,a0,-52 # 14b0 <malloc+0x206>
     4ec:	507000ef          	jal	11f2 <printf>
        exit(1);
     4f0:	4505                	li	a0,1
     4f2:	0c7000ef          	jal	db8 <exit>
      int pid = fork();
     4f6:	0bb000ef          	jal	db0 <fork>
      if(pid == 0){
     4fa:	c519                	beqz	a0,508 <go+0x45e>
      } else if(pid < 0){
     4fc:	04054f63          	bltz	a0,55a <go+0x4b0>
      wait(0);
     500:	4501                	li	a0,0
     502:	0bf000ef          	jal	dc0 <wait>
     506:	b99d                	j	17c <go+0xd2>
        unlink("a");
     508:	00001517          	auipc	a0,0x1
     50c:	fc050513          	addi	a0,a0,-64 # 14c8 <malloc+0x21e>
     510:	0f9000ef          	jal	e08 <unlink>
        mkdir("a");
     514:	00001517          	auipc	a0,0x1
     518:	fb450513          	addi	a0,a0,-76 # 14c8 <malloc+0x21e>
     51c:	105000ef          	jal	e20 <mkdir>
        chdir("a");
     520:	00001517          	auipc	a0,0x1
     524:	fa850513          	addi	a0,a0,-88 # 14c8 <malloc+0x21e>
     528:	101000ef          	jal	e28 <chdir>
        unlink("../a");
     52c:	00001517          	auipc	a0,0x1
     530:	02c50513          	addi	a0,a0,44 # 1558 <malloc+0x2ae>
     534:	0d5000ef          	jal	e08 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     538:	20200593          	li	a1,514
     53c:	00001517          	auipc	a0,0x1
     540:	fd450513          	addi	a0,a0,-44 # 1510 <malloc+0x266>
     544:	0b5000ef          	jal	df8 <open>
        unlink("x");
     548:	00001517          	auipc	a0,0x1
     54c:	fc850513          	addi	a0,a0,-56 # 1510 <malloc+0x266>
     550:	0b9000ef          	jal	e08 <unlink>
        exit(0);
     554:	4501                	li	a0,0
     556:	063000ef          	jal	db8 <exit>
        printf("grind: fork failed\n");
     55a:	00001517          	auipc	a0,0x1
     55e:	f5650513          	addi	a0,a0,-170 # 14b0 <malloc+0x206>
     562:	491000ef          	jal	11f2 <printf>
        exit(1);
     566:	4505                	li	a0,1
     568:	051000ef          	jal	db8 <exit>
      unlink("c");
     56c:	00001517          	auipc	a0,0x1
     570:	ff450513          	addi	a0,a0,-12 # 1560 <malloc+0x2b6>
     574:	095000ef          	jal	e08 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     578:	20200593          	li	a1,514
     57c:	00001517          	auipc	a0,0x1
     580:	fe450513          	addi	a0,a0,-28 # 1560 <malloc+0x2b6>
     584:	075000ef          	jal	df8 <open>
     588:	8d2a                	mv	s10,a0
      if(fd1 < 0){
     58a:	04054563          	bltz	a0,5d4 <go+0x52a>
      if(write(fd1, "x", 1) != 1){
     58e:	865e                	mv	a2,s7
     590:	00001597          	auipc	a1,0x1
     594:	f8058593          	addi	a1,a1,-128 # 1510 <malloc+0x266>
     598:	041000ef          	jal	dd8 <write>
     59c:	05751563          	bne	a0,s7,5e6 <go+0x53c>
      if(fstat(fd1, &st) != 0){
     5a0:	f7840593          	addi	a1,s0,-136
     5a4:	856a                	mv	a0,s10
     5a6:	06b000ef          	jal	e10 <fstat>
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
     5c2:	01f000ef          	jal	de0 <close>
      unlink("c");
     5c6:	00001517          	auipc	a0,0x1
     5ca:	f9a50513          	addi	a0,a0,-102 # 1560 <malloc+0x2b6>
     5ce:	03b000ef          	jal	e08 <unlink>
     5d2:	b66d                	j	17c <go+0xd2>
        printf("grind: create c failed\n");
     5d4:	00001517          	auipc	a0,0x1
     5d8:	f9450513          	addi	a0,a0,-108 # 1568 <malloc+0x2be>
     5dc:	417000ef          	jal	11f2 <printf>
        exit(1);
     5e0:	4505                	li	a0,1
     5e2:	7d6000ef          	jal	db8 <exit>
        printf("grind: write c failed\n");
     5e6:	00001517          	auipc	a0,0x1
     5ea:	f9a50513          	addi	a0,a0,-102 # 1580 <malloc+0x2d6>
     5ee:	405000ef          	jal	11f2 <printf>
        exit(1);
     5f2:	4505                	li	a0,1
     5f4:	7c4000ef          	jal	db8 <exit>
        printf("grind: fstat failed\n");
     5f8:	00001517          	auipc	a0,0x1
     5fc:	fa050513          	addi	a0,a0,-96 # 1598 <malloc+0x2ee>
     600:	3f3000ef          	jal	11f2 <printf>
        exit(1);
     604:	4505                	li	a0,1
     606:	7b2000ef          	jal	db8 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     60a:	2581                	sext.w	a1,a1
     60c:	00001517          	auipc	a0,0x1
     610:	fa450513          	addi	a0,a0,-92 # 15b0 <malloc+0x306>
     614:	3df000ef          	jal	11f2 <printf>
        exit(1);
     618:	4505                	li	a0,1
     61a:	79e000ef          	jal	db8 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     61e:	00001517          	auipc	a0,0x1
     622:	fba50513          	addi	a0,a0,-70 # 15d8 <malloc+0x32e>
     626:	3cd000ef          	jal	11f2 <printf>
        exit(1);
     62a:	4505                	li	a0,1
     62c:	78c000ef          	jal	db8 <exit>
      if(pipe(aa) < 0){
     630:	856e                	mv	a0,s11
     632:	796000ef          	jal	dc8 <pipe>
     636:	0c054263          	bltz	a0,6fa <go+0x650>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     63a:	f7040513          	addi	a0,s0,-144
     63e:	78a000ef          	jal	dc8 <pipe>
     642:	0c054663          	bltz	a0,70e <go+0x664>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     646:	76a000ef          	jal	db0 <fork>
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
     652:	75e000ef          	jal	db0 <fork>
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
     662:	77e000ef          	jal	de0 <close>
      close(aa[1]);
     666:	f6c42503          	lw	a0,-148(s0)
     66a:	776000ef          	jal	de0 <close>
      close(bb[1]);
     66e:	f7442503          	lw	a0,-140(s0)
     672:	76e000ef          	jal	de0 <close>
      char buf[4] = { 0, 0, 0, 0 };
     676:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf+0, 1);
     67a:	865e                	mv	a2,s7
     67c:	f6040593          	addi	a1,s0,-160
     680:	f7042503          	lw	a0,-144(s0)
     684:	74c000ef          	jal	dd0 <read>
      read(bb[0], buf+1, 1);
     688:	865e                	mv	a2,s7
     68a:	f6140593          	addi	a1,s0,-159
     68e:	f7042503          	lw	a0,-144(s0)
     692:	73e000ef          	jal	dd0 <read>
      read(bb[0], buf+2, 1);
     696:	865e                	mv	a2,s7
     698:	f6240593          	addi	a1,s0,-158
     69c:	f7042503          	lw	a0,-144(s0)
     6a0:	730000ef          	jal	dd0 <read>
      close(bb[0]);
     6a4:	f7042503          	lw	a0,-144(s0)
     6a8:	738000ef          	jal	de0 <close>
      int st1, st2;
      wait(&st1);
     6ac:	f6440513          	addi	a0,s0,-156
     6b0:	710000ef          	jal	dc0 <wait>
      wait(&st2);
     6b4:	f7840513          	addi	a0,s0,-136
     6b8:	708000ef          	jal	dc0 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     6bc:	f6442783          	lw	a5,-156(s0)
     6c0:	f7842703          	lw	a4,-136(s0)
     6c4:	8fd9                	or	a5,a5,a4
     6c6:	eb99                	bnez	a5,6dc <go+0x632>
     6c8:	00001597          	auipc	a1,0x1
     6cc:	fb058593          	addi	a1,a1,-80 # 1678 <malloc+0x3ce>
     6d0:	f6040513          	addi	a0,s0,-160
     6d4:	2d4000ef          	jal	9a8 <strcmp>
     6d8:	aa0502e3          	beqz	a0,17c <go+0xd2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     6dc:	f6040693          	addi	a3,s0,-160
     6e0:	f7842603          	lw	a2,-136(s0)
     6e4:	f6442583          	lw	a1,-156(s0)
     6e8:	00001517          	auipc	a0,0x1
     6ec:	f9850513          	addi	a0,a0,-104 # 1680 <malloc+0x3d6>
     6f0:	303000ef          	jal	11f2 <printf>
        exit(1);
     6f4:	4505                	li	a0,1
     6f6:	6c2000ef          	jal	db8 <exit>
        fprintf(2, "grind: pipe failed\n");
     6fa:	00001597          	auipc	a1,0x1
     6fe:	dfe58593          	addi	a1,a1,-514 # 14f8 <malloc+0x24e>
     702:	4509                	li	a0,2
     704:	2c5000ef          	jal	11c8 <fprintf>
        exit(1);
     708:	4505                	li	a0,1
     70a:	6ae000ef          	jal	db8 <exit>
        fprintf(2, "grind: pipe failed\n");
     70e:	00001597          	auipc	a1,0x1
     712:	dea58593          	addi	a1,a1,-534 # 14f8 <malloc+0x24e>
     716:	4509                	li	a0,2
     718:	2b1000ef          	jal	11c8 <fprintf>
        exit(1);
     71c:	4505                	li	a0,1
     71e:	69a000ef          	jal	db8 <exit>
        close(bb[0]);
     722:	f7042503          	lw	a0,-144(s0)
     726:	6ba000ef          	jal	de0 <close>
        close(bb[1]);
     72a:	f7442503          	lw	a0,-140(s0)
     72e:	6b2000ef          	jal	de0 <close>
        close(aa[0]);
     732:	f6842503          	lw	a0,-152(s0)
     736:	6aa000ef          	jal	de0 <close>
        close(1);
     73a:	4505                	li	a0,1
     73c:	6a4000ef          	jal	de0 <close>
        if(dup(aa[1]) != 1){
     740:	f6c42503          	lw	a0,-148(s0)
     744:	6ec000ef          	jal	e30 <dup>
     748:	4785                	li	a5,1
     74a:	00f50c63          	beq	a0,a5,762 <go+0x6b8>
          fprintf(2, "grind: dup failed\n");
     74e:	00001597          	auipc	a1,0x1
     752:	eb258593          	addi	a1,a1,-334 # 1600 <malloc+0x356>
     756:	4509                	li	a0,2
     758:	271000ef          	jal	11c8 <fprintf>
          exit(1);
     75c:	4505                	li	a0,1
     75e:	65a000ef          	jal	db8 <exit>
        close(aa[1]);
     762:	f6c42503          	lw	a0,-148(s0)
     766:	67a000ef          	jal	de0 <close>
        char *args[3] = { "echo", "hi", 0 };
     76a:	00001797          	auipc	a5,0x1
     76e:	eae78793          	addi	a5,a5,-338 # 1618 <malloc+0x36e>
     772:	f6f43c23          	sd	a5,-136(s0)
     776:	00001797          	auipc	a5,0x1
     77a:	eaa78793          	addi	a5,a5,-342 # 1620 <malloc+0x376>
     77e:	f8f43023          	sd	a5,-128(s0)
     782:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     786:	f7840593          	addi	a1,s0,-136
     78a:	00001517          	auipc	a0,0x1
     78e:	e9e50513          	addi	a0,a0,-354 # 1628 <malloc+0x37e>
     792:	65e000ef          	jal	df0 <exec>
        fprintf(2, "grind: echo: not found\n");
     796:	00001597          	auipc	a1,0x1
     79a:	ea258593          	addi	a1,a1,-350 # 1638 <malloc+0x38e>
     79e:	4509                	li	a0,2
     7a0:	229000ef          	jal	11c8 <fprintf>
        exit(2);
     7a4:	4509                	li	a0,2
     7a6:	612000ef          	jal	db8 <exit>
        fprintf(2, "grind: fork failed\n");
     7aa:	00001597          	auipc	a1,0x1
     7ae:	d0658593          	addi	a1,a1,-762 # 14b0 <malloc+0x206>
     7b2:	4509                	li	a0,2
     7b4:	215000ef          	jal	11c8 <fprintf>
        exit(3);
     7b8:	450d                	li	a0,3
     7ba:	5fe000ef          	jal	db8 <exit>
        close(aa[1]);
     7be:	f6c42503          	lw	a0,-148(s0)
     7c2:	61e000ef          	jal	de0 <close>
        close(bb[0]);
     7c6:	f7042503          	lw	a0,-144(s0)
     7ca:	616000ef          	jal	de0 <close>
        close(0);
     7ce:	4501                	li	a0,0
     7d0:	610000ef          	jal	de0 <close>
        if(dup(aa[0]) != 0){
     7d4:	f6842503          	lw	a0,-152(s0)
     7d8:	658000ef          	jal	e30 <dup>
     7dc:	c919                	beqz	a0,7f2 <go+0x748>
          fprintf(2, "grind: dup failed\n");
     7de:	00001597          	auipc	a1,0x1
     7e2:	e2258593          	addi	a1,a1,-478 # 1600 <malloc+0x356>
     7e6:	4509                	li	a0,2
     7e8:	1e1000ef          	jal	11c8 <fprintf>
          exit(4);
     7ec:	4511                	li	a0,4
     7ee:	5ca000ef          	jal	db8 <exit>
        close(aa[0]);
     7f2:	f6842503          	lw	a0,-152(s0)
     7f6:	5ea000ef          	jal	de0 <close>
        close(1);
     7fa:	4505                	li	a0,1
     7fc:	5e4000ef          	jal	de0 <close>
        if(dup(bb[1]) != 1){
     800:	f7442503          	lw	a0,-140(s0)
     804:	62c000ef          	jal	e30 <dup>
     808:	4785                	li	a5,1
     80a:	00f50c63          	beq	a0,a5,822 <go+0x778>
          fprintf(2, "grind: dup failed\n");
     80e:	00001597          	auipc	a1,0x1
     812:	df258593          	addi	a1,a1,-526 # 1600 <malloc+0x356>
     816:	4509                	li	a0,2
     818:	1b1000ef          	jal	11c8 <fprintf>
          exit(5);
     81c:	4515                	li	a0,5
     81e:	59a000ef          	jal	db8 <exit>
        close(bb[1]);
     822:	f7442503          	lw	a0,-140(s0)
     826:	5ba000ef          	jal	de0 <close>
        char *args[2] = { "cat", 0 };
     82a:	00001797          	auipc	a5,0x1
     82e:	e2678793          	addi	a5,a5,-474 # 1650 <malloc+0x3a6>
     832:	f6f43c23          	sd	a5,-136(s0)
     836:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     83a:	f7840593          	addi	a1,s0,-136
     83e:	00001517          	auipc	a0,0x1
     842:	e1a50513          	addi	a0,a0,-486 # 1658 <malloc+0x3ae>
     846:	5aa000ef          	jal	df0 <exec>
        fprintf(2, "grind: cat: not found\n");
     84a:	00001597          	auipc	a1,0x1
     84e:	e1658593          	addi	a1,a1,-490 # 1660 <malloc+0x3b6>
     852:	4509                	li	a0,2
     854:	175000ef          	jal	11c8 <fprintf>
        exit(6);
     858:	4519                	li	a0,6
     85a:	55e000ef          	jal	db8 <exit>
        fprintf(2, "grind: fork failed\n");
     85e:	00001597          	auipc	a1,0x1
     862:	c5258593          	addi	a1,a1,-942 # 14b0 <malloc+0x206>
     866:	4509                	li	a0,2
     868:	161000ef          	jal	11c8 <fprintf>
        exit(7);
     86c:	451d                	li	a0,7
     86e:	54a000ef          	jal	db8 <exit>

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
     87e:	c4e50513          	addi	a0,a0,-946 # 14c8 <malloc+0x21e>
     882:	586000ef          	jal	e08 <unlink>
  unlink("b");
     886:	00001517          	auipc	a0,0x1
     88a:	bf250513          	addi	a0,a0,-1038 # 1478 <malloc+0x1ce>
     88e:	57a000ef          	jal	e08 <unlink>
  
  int pid1 = fork();
     892:	51e000ef          	jal	db0 <fork>
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
     8c0:	bf450513          	addi	a0,a0,-1036 # 14b0 <malloc+0x206>
     8c4:	12f000ef          	jal	11f2 <printf>
    exit(1);
     8c8:	4505                	li	a0,1
     8ca:	4ee000ef          	jal	db8 <exit>
     8ce:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     8d0:	4e0000ef          	jal	db0 <fork>
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
     8e8:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x4f9>
     8ec:	8fb9                	xor	a5,a5,a4
     8ee:	e29c                	sd	a5,0(a3)
    go(1);
     8f0:	4505                	li	a0,1
     8f2:	fb8ff0ef          	jal	aa <go>
    printf("grind: fork failed\n");
     8f6:	00001517          	auipc	a0,0x1
     8fa:	bba50513          	addi	a0,a0,-1094 # 14b0 <malloc+0x206>
     8fe:	0f5000ef          	jal	11f2 <printf>
    exit(1);
     902:	4505                	li	a0,1
     904:	4b4000ef          	jal	db8 <exit>
    exit(0);
  }

  int st1 = -1;
     908:	57fd                	li	a5,-1
     90a:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     90e:	fdc40513          	addi	a0,s0,-36
     912:	4ae000ef          	jal	dc0 <wait>
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
     926:	49a000ef          	jal	dc0 <wait>

  exit(0);
     92a:	4501                	li	a0,0
     92c:	48c000ef          	jal	db8 <exit>
    kill(pid1);
     930:	8526                	mv	a0,s1
     932:	4b6000ef          	jal	de8 <kill>
    kill(pid2);
     936:	854a                	mv	a0,s2
     938:	4b0000ef          	jal	de8 <kill>
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
     95c:	4ec000ef          	jal	e48 <pause>
    rand_next += 1;
     960:	609c                	ld	a5,0(s1)
     962:	0785                	addi	a5,a5,1
     964:	e09c                	sd	a5,0(s1)
    int pid = fork();
     966:	44a000ef          	jal	db0 <fork>
    if(pid == 0){
     96a:	d575                	beqz	a0,956 <main+0x18>
    if(pid > 0){
     96c:	fea057e3          	blez	a0,95a <main+0x1c>
      wait(0);
     970:	4501                	li	a0,0
     972:	44e000ef          	jal	dc0 <wait>
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
     984:	434000ef          	jal	db8 <exit>

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
     a94:	33c000ef          	jal	dd0 <read>
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
     ae6:	312000ef          	jal	df8 <open>
  if(fd < 0)
     aea:	02054263          	bltz	a0,b0e <stat+0x36>
     aee:	e426                	sd	s1,8(sp)
     af0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     af2:	85ca                	mv	a1,s2
     af4:	31c000ef          	jal	e10 <fstat>
     af8:	892a                	mv	s2,a0
  close(fd);
     afa:	8526                	mv	a0,s1
     afc:	2e4000ef          	jal	de0 <close>
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
     c16:	22a000ef          	jal	e40 <sys_sbrk>
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
     c2c:	214000ef          	jal	e40 <sys_sbrk>
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
     c5a:	1fe000ef          	jal	e58 <clone>
}
     c5e:	60e2                	ld	ra,24(sp)
     c60:	6442                	ld	s0,16(sp)
     c62:	64a2                	ld	s1,8(sp)
     c64:	6902                	ld	s2,0(sp)
     c66:	6105                	addi	sp,sp,32
     c68:	8082                	ret

0000000000000c6a <futex>:

void futex(int *uaddr, int ops, int val) {
     c6a:	7179                	addi	sp,sp,-48
     c6c:	f406                	sd	ra,40(sp)
     c6e:	f022                	sd	s0,32(sp)
     c70:	ec26                	sd	s1,24(sp)
     c72:	1800                	addi	s0,sp,48
     c74:	84aa                	mv	s1,a0
  if (ops==0) {
     c76:	ed95                	bnez	a1,cb2 <futex+0x48>
    if (val==0) {
     c78:	c611                	beqz	a2,c84 <futex+0x1a>
     c7a:	e84a                	sd	s2,16(sp)
     c7c:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
     c7e:	4905                	li	s2,1
        futex_wait(uaddr, 1);
     c80:	4985                	li	s3,1
     c82:	a005                	j	ca2 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
     c84:	4705                	li	a4,1
     c86:	87ba                	mv	a5,a4
     c88:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
     c8c:	2781                	sext.w	a5,a5
     c8e:	ffe5                	bnez	a5,c86 <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
     c90:	70a2                	ld	ra,40(sp)
     c92:	7402                	ld	s0,32(sp)
     c94:	64e2                	ld	s1,24(sp)
     c96:	6145                	addi	sp,sp,48
     c98:	8082                	ret
        futex_wait(uaddr, 1);
     c9a:	85ce                	mv	a1,s3
     c9c:	8526                	mv	a0,s1
     c9e:	1ca000ef          	jal	e68 <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
     ca2:	87ca                	mv	a5,s2
     ca4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
     ca8:	2781                	sext.w	a5,a5
     caa:	fbe5                	bnez	a5,c9a <futex+0x30>
     cac:	6942                	ld	s2,16(sp)
     cae:	69a2                	ld	s3,8(sp)
     cb0:	b7c5                	j	c90 <futex+0x26>
    if (val==0) {
     cb2:	e611                	bnez	a2,cbe <futex+0x54>
      __sync_lock_release(uaddr);
     cb4:	0310000f          	fence	rw,w
     cb8:	00052023          	sw	zero,0(a0) # 1000 <vprintf+0xd8>
     cbc:	bfd1                	j	c90 <futex+0x26>
      __sync_lock_release(uaddr);
     cbe:	0310000f          	fence	rw,w
     cc2:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
     cc6:	1aa000ef          	jal	e70 <futex_wake>
  return;
     cca:	b7d9                	j	c90 <futex+0x26>

0000000000000ccc <sem_init>:

void sem_init(sem_t* s, int val) {
     ccc:	7179                	addi	sp,sp,-48
     cce:	f406                	sd	ra,40(sp)
     cd0:	f022                	sd	s0,32(sp)
     cd2:	ec26                	sd	s1,24(sp)
     cd4:	e84a                	sd	s2,16(sp)
     cd6:	e44e                	sd	s3,8(sp)
     cd8:	1800                	addi	s0,sp,48
     cda:	84aa                	mv	s1,a0
     cdc:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
     cde:	00450993          	addi	s3,a0,4
     ce2:	4605                	li	a2,1
     ce4:	4581                	li	a1,0
     ce6:	854e                	mv	a0,s3
     ce8:	f83ff0ef          	jal	c6a <futex>
  s->value = val;
     cec:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
     cf0:	4605                	li	a2,1
     cf2:	85b2                	mv	a1,a2
     cf4:	854e                	mv	a0,s3
     cf6:	f75ff0ef          	jal	c6a <futex>
  return;
}
     cfa:	70a2                	ld	ra,40(sp)
     cfc:	7402                	ld	s0,32(sp)
     cfe:	64e2                	ld	s1,24(sp)
     d00:	6942                	ld	s2,16(sp)
     d02:	69a2                	ld	s3,8(sp)
     d04:	6145                	addi	sp,sp,48
     d06:	8082                	ret

0000000000000d08 <sem_down>:

void sem_down(sem_t* s) {
     d08:	7179                	addi	sp,sp,-48
     d0a:	f406                	sd	ra,40(sp)
     d0c:	f022                	sd	s0,32(sp)
     d0e:	ec26                	sd	s1,24(sp)
     d10:	e84a                	sd	s2,16(sp)
     d12:	e44e                	sd	s3,8(sp)
     d14:	1800                	addi	s0,sp,48
     d16:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
     d18:	00450993          	addi	s3,a0,4
     d1c:	4605                	li	a2,1
     d1e:	4581                	li	a1,0
     d20:	854e                	mv	a0,s3
     d22:	f49ff0ef          	jal	c6a <futex>
  while(1) {
    if (s->value>0) {
     d26:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
     d2a:	4485                	li	s1,1
    if (s->value>0) {
     d2c:	02f04463          	bgtz	a5,d54 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
     d30:	8626                	mv	a2,s1
     d32:	85a6                	mv	a1,s1
     d34:	854e                	mv	a0,s3
     d36:	f35ff0ef          	jal	c6a <futex>
      futex_wait(&s->value,1);
     d3a:	85a6                	mv	a1,s1
     d3c:	854a                	mv	a0,s2
     d3e:	12a000ef          	jal	e68 <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
     d42:	8626                	mv	a2,s1
     d44:	4581                	li	a1,0
     d46:	854e                	mv	a0,s3
     d48:	f23ff0ef          	jal	c6a <futex>
    if (s->value>0) {
     d4c:	00092783          	lw	a5,0(s2)
     d50:	fef050e3          	blez	a5,d30 <sem_down+0x28>
      s->value--;
     d54:	37fd                	addiw	a5,a5,-1 # fff <vprintf+0xd7>
     d56:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
     d5a:	4605                	li	a2,1
     d5c:	85b2                	mv	a1,a2
     d5e:	854e                	mv	a0,s3
     d60:	f0bff0ef          	jal	c6a <futex>
  return;
}
     d64:	70a2                	ld	ra,40(sp)
     d66:	7402                	ld	s0,32(sp)
     d68:	64e2                	ld	s1,24(sp)
     d6a:	6942                	ld	s2,16(sp)
     d6c:	69a2                	ld	s3,8(sp)
     d6e:	6145                	addi	sp,sp,48
     d70:	8082                	ret

0000000000000d72 <sem_up>:

void sem_up(sem_t* s) {
     d72:	1101                	addi	sp,sp,-32
     d74:	ec06                	sd	ra,24(sp)
     d76:	e822                	sd	s0,16(sp)
     d78:	e426                	sd	s1,8(sp)
     d7a:	e04a                	sd	s2,0(sp)
     d7c:	1000                	addi	s0,sp,32
     d7e:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
     d80:	00450913          	addi	s2,a0,4
     d84:	4605                	li	a2,1
     d86:	4581                	li	a1,0
     d88:	854a                	mv	a0,s2
     d8a:	ee1ff0ef          	jal	c6a <futex>
  s->value++;
     d8e:	409c                	lw	a5,0(s1)
     d90:	2785                	addiw	a5,a5,1
     d92:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
     d94:	8526                	mv	a0,s1
     d96:	0da000ef          	jal	e70 <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
     d9a:	4605                	li	a2,1
     d9c:	85b2                	mv	a1,a2
     d9e:	854a                	mv	a0,s2
     da0:	ecbff0ef          	jal	c6a <futex>
  return;
     da4:	60e2                	ld	ra,24(sp)
     da6:	6442                	ld	s0,16(sp)
     da8:	64a2                	ld	s1,8(sp)
     daa:	6902                	ld	s2,0(sp)
     dac:	6105                	addi	sp,sp,32
     dae:	8082                	ret

0000000000000db0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     db0:	4885                	li	a7,1
 ecall
     db2:	00000073          	ecall
 ret
     db6:	8082                	ret

0000000000000db8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     db8:	4889                	li	a7,2
 ecall
     dba:	00000073          	ecall
 ret
     dbe:	8082                	ret

0000000000000dc0 <wait>:
.global wait
wait:
 li a7, SYS_wait
     dc0:	488d                	li	a7,3
 ecall
     dc2:	00000073          	ecall
 ret
     dc6:	8082                	ret

0000000000000dc8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     dc8:	4891                	li	a7,4
 ecall
     dca:	00000073          	ecall
 ret
     dce:	8082                	ret

0000000000000dd0 <read>:
.global read
read:
 li a7, SYS_read
     dd0:	4895                	li	a7,5
 ecall
     dd2:	00000073          	ecall
 ret
     dd6:	8082                	ret

0000000000000dd8 <write>:
.global write
write:
 li a7, SYS_write
     dd8:	48c1                	li	a7,16
 ecall
     dda:	00000073          	ecall
 ret
     dde:	8082                	ret

0000000000000de0 <close>:
.global close
close:
 li a7, SYS_close
     de0:	48d5                	li	a7,21
 ecall
     de2:	00000073          	ecall
 ret
     de6:	8082                	ret

0000000000000de8 <kill>:
.global kill
kill:
 li a7, SYS_kill
     de8:	4899                	li	a7,6
 ecall
     dea:	00000073          	ecall
 ret
     dee:	8082                	ret

0000000000000df0 <exec>:
.global exec
exec:
 li a7, SYS_exec
     df0:	489d                	li	a7,7
 ecall
     df2:	00000073          	ecall
 ret
     df6:	8082                	ret

0000000000000df8 <open>:
.global open
open:
 li a7, SYS_open
     df8:	48bd                	li	a7,15
 ecall
     dfa:	00000073          	ecall
 ret
     dfe:	8082                	ret

0000000000000e00 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e00:	48c5                	li	a7,17
 ecall
     e02:	00000073          	ecall
 ret
     e06:	8082                	ret

0000000000000e08 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e08:	48c9                	li	a7,18
 ecall
     e0a:	00000073          	ecall
 ret
     e0e:	8082                	ret

0000000000000e10 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e10:	48a1                	li	a7,8
 ecall
     e12:	00000073          	ecall
 ret
     e16:	8082                	ret

0000000000000e18 <link>:
.global link
link:
 li a7, SYS_link
     e18:	48cd                	li	a7,19
 ecall
     e1a:	00000073          	ecall
 ret
     e1e:	8082                	ret

0000000000000e20 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e20:	48d1                	li	a7,20
 ecall
     e22:	00000073          	ecall
 ret
     e26:	8082                	ret

0000000000000e28 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e28:	48a5                	li	a7,9
 ecall
     e2a:	00000073          	ecall
 ret
     e2e:	8082                	ret

0000000000000e30 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e30:	48a9                	li	a7,10
 ecall
     e32:	00000073          	ecall
 ret
     e36:	8082                	ret

0000000000000e38 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e38:	48ad                	li	a7,11
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     e40:	48b1                	li	a7,12
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <pause>:
.global pause
pause:
 li a7, SYS_pause
     e48:	48b5                	li	a7,13
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e50:	48b9                	li	a7,14
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <clone>:
.global clone
clone:
 li a7, SYS_clone
     e58:	48d9                	li	a7,22
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <join>:
.global join
join:
 li a7, SYS_join
     e60:	48dd                	li	a7,23
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
     e68:	48e1                	li	a7,24
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
     e70:	48e5                	li	a7,25
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e78:	1101                	addi	sp,sp,-32
     e7a:	ec06                	sd	ra,24(sp)
     e7c:	e822                	sd	s0,16(sp)
     e7e:	1000                	addi	s0,sp,32
     e80:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     e84:	4605                	li	a2,1
     e86:	fef40593          	addi	a1,s0,-17
     e8a:	f4fff0ef          	jal	dd8 <write>
}
     e8e:	60e2                	ld	ra,24(sp)
     e90:	6442                	ld	s0,16(sp)
     e92:	6105                	addi	sp,sp,32
     e94:	8082                	ret

0000000000000e96 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     e96:	715d                	addi	sp,sp,-80
     e98:	e486                	sd	ra,72(sp)
     e9a:	e0a2                	sd	s0,64(sp)
     e9c:	fc26                	sd	s1,56(sp)
     e9e:	f84a                	sd	s2,48(sp)
     ea0:	f44e                	sd	s3,40(sp)
     ea2:	0880                	addi	s0,sp,80
     ea4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     ea6:	c299                	beqz	a3,eac <printint+0x16>
     ea8:	0605cc63          	bltz	a1,f20 <printint+0x8a>
  neg = 0;
     eac:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     eae:	fb840313          	addi	t1,s0,-72
  neg = 0;
     eb2:	869a                	mv	a3,t1
  i = 0;
     eb4:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     eb6:	00001817          	auipc	a6,0x1
     eba:	85a80813          	addi	a6,a6,-1958 # 1710 <digits>
     ebe:	88be                	mv	a7,a5
     ec0:	0017851b          	addiw	a0,a5,1
     ec4:	87aa                	mv	a5,a0
     ec6:	02c5f733          	remu	a4,a1,a2
     eca:	9742                	add	a4,a4,a6
     ecc:	00074703          	lbu	a4,0(a4)
     ed0:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     ed4:	872e                	mv	a4,a1
     ed6:	02c5d5b3          	divu	a1,a1,a2
     eda:	0685                	addi	a3,a3,1
     edc:	fec771e3          	bgeu	a4,a2,ebe <printint+0x28>
  if(neg)
     ee0:	000e0c63          	beqz	t3,ef8 <printint+0x62>
    buf[i++] = '-';
     ee4:	fd050793          	addi	a5,a0,-48
     ee8:	00878533          	add	a0,a5,s0
     eec:	02d00793          	li	a5,45
     ef0:	fef50423          	sb	a5,-24(a0)
     ef4:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
     ef8:	fff7899b          	addiw	s3,a5,-1
     efc:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
     f00:	fff4c583          	lbu	a1,-1(s1)
     f04:	854a                	mv	a0,s2
     f06:	f73ff0ef          	jal	e78 <putc>
  while(--i >= 0)
     f0a:	39fd                	addiw	s3,s3,-1
     f0c:	14fd                	addi	s1,s1,-1
     f0e:	fe09d9e3          	bgez	s3,f00 <printint+0x6a>
}
     f12:	60a6                	ld	ra,72(sp)
     f14:	6406                	ld	s0,64(sp)
     f16:	74e2                	ld	s1,56(sp)
     f18:	7942                	ld	s2,48(sp)
     f1a:	79a2                	ld	s3,40(sp)
     f1c:	6161                	addi	sp,sp,80
     f1e:	8082                	ret
    x = -xx;
     f20:	40b005b3          	neg	a1,a1
    neg = 1;
     f24:	4e05                	li	t3,1
    x = -xx;
     f26:	b761                	j	eae <printint+0x18>

0000000000000f28 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f28:	711d                	addi	sp,sp,-96
     f2a:	ec86                	sd	ra,88(sp)
     f2c:	e8a2                	sd	s0,80(sp)
     f2e:	e4a6                	sd	s1,72(sp)
     f30:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f32:	0005c483          	lbu	s1,0(a1)
     f36:	28048463          	beqz	s1,11be <vprintf+0x296>
     f3a:	e0ca                	sd	s2,64(sp)
     f3c:	fc4e                	sd	s3,56(sp)
     f3e:	f852                	sd	s4,48(sp)
     f40:	f456                	sd	s5,40(sp)
     f42:	f05a                	sd	s6,32(sp)
     f44:	ec5e                	sd	s7,24(sp)
     f46:	e862                	sd	s8,16(sp)
     f48:	e466                	sd	s9,8(sp)
     f4a:	8b2a                	mv	s6,a0
     f4c:	8a2e                	mv	s4,a1
     f4e:	8bb2                	mv	s7,a2
  state = 0;
     f50:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     f52:	4901                	li	s2,0
     f54:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     f56:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     f5a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     f5e:	06c00c93          	li	s9,108
     f62:	a00d                	j	f84 <vprintf+0x5c>
        putc(fd, c0);
     f64:	85a6                	mv	a1,s1
     f66:	855a                	mv	a0,s6
     f68:	f11ff0ef          	jal	e78 <putc>
     f6c:	a019                	j	f72 <vprintf+0x4a>
    } else if(state == '%'){
     f6e:	03598363          	beq	s3,s5,f94 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
     f72:	0019079b          	addiw	a5,s2,1
     f76:	893e                	mv	s2,a5
     f78:	873e                	mv	a4,a5
     f7a:	97d2                	add	a5,a5,s4
     f7c:	0007c483          	lbu	s1,0(a5)
     f80:	22048763          	beqz	s1,11ae <vprintf+0x286>
    c0 = fmt[i] & 0xff;
     f84:	0004879b          	sext.w	a5,s1
    if(state == 0){
     f88:	fe0993e3          	bnez	s3,f6e <vprintf+0x46>
      if(c0 == '%'){
     f8c:	fd579ce3          	bne	a5,s5,f64 <vprintf+0x3c>
        state = '%';
     f90:	89be                	mv	s3,a5
     f92:	b7c5                	j	f72 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     f94:	00ea06b3          	add	a3,s4,a4
     f98:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     f9c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     f9e:	c681                	beqz	a3,fa6 <vprintf+0x7e>
     fa0:	9752                	add	a4,a4,s4
     fa2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     fa6:	05878263          	beq	a5,s8,fea <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     faa:	05978c63          	beq	a5,s9,1002 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     fae:	07500713          	li	a4,117
     fb2:	0ee78663          	beq	a5,a4,109e <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     fb6:	07800713          	li	a4,120
     fba:	12e78863          	beq	a5,a4,10ea <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     fbe:	07000713          	li	a4,112
     fc2:	14e78d63          	beq	a5,a4,111c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
     fc6:	06300713          	li	a4,99
     fca:	18e78c63          	beq	a5,a4,1162 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
     fce:	07300713          	li	a4,115
     fd2:	1ae78263          	beq	a5,a4,1176 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     fd6:	02500713          	li	a4,37
     fda:	04e79463          	bne	a5,a4,1022 <vprintf+0xfa>
        putc(fd, '%');
     fde:	85ba                	mv	a1,a4
     fe0:	855a                	mv	a0,s6
     fe2:	e97ff0ef          	jal	e78 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     fe6:	4981                	li	s3,0
     fe8:	b769                	j	f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     fea:	008b8493          	addi	s1,s7,8
     fee:	4685                	li	a3,1
     ff0:	4629                	li	a2,10
     ff2:	000ba583          	lw	a1,0(s7)
     ff6:	855a                	mv	a0,s6
     ff8:	e9fff0ef          	jal	e96 <printint>
     ffc:	8ba6                	mv	s7,s1
      state = 0;
     ffe:	4981                	li	s3,0
    1000:	bf8d                	j	f72 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1002:	06400793          	li	a5,100
    1006:	02f68963          	beq	a3,a5,1038 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    100a:	06c00793          	li	a5,108
    100e:	04f68263          	beq	a3,a5,1052 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
    1012:	07500793          	li	a5,117
    1016:	0af68063          	beq	a3,a5,10b6 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
    101a:	07800793          	li	a5,120
    101e:	0ef68263          	beq	a3,a5,1102 <vprintf+0x1da>
        putc(fd, '%');
    1022:	02500593          	li	a1,37
    1026:	855a                	mv	a0,s6
    1028:	e51ff0ef          	jal	e78 <putc>
        putc(fd, c0);
    102c:	85a6                	mv	a1,s1
    102e:	855a                	mv	a0,s6
    1030:	e49ff0ef          	jal	e78 <putc>
      state = 0;
    1034:	4981                	li	s3,0
    1036:	bf35                	j	f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1038:	008b8493          	addi	s1,s7,8
    103c:	4685                	li	a3,1
    103e:	4629                	li	a2,10
    1040:	000bb583          	ld	a1,0(s7)
    1044:	855a                	mv	a0,s6
    1046:	e51ff0ef          	jal	e96 <printint>
        i += 1;
    104a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    104c:	8ba6                	mv	s7,s1
      state = 0;
    104e:	4981                	li	s3,0
        i += 1;
    1050:	b70d                	j	f72 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1052:	06400793          	li	a5,100
    1056:	02f60763          	beq	a2,a5,1084 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    105a:	07500793          	li	a5,117
    105e:	06f60963          	beq	a2,a5,10d0 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1062:	07800793          	li	a5,120
    1066:	faf61ee3          	bne	a2,a5,1022 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
    106a:	008b8493          	addi	s1,s7,8
    106e:	4681                	li	a3,0
    1070:	4641                	li	a2,16
    1072:	000bb583          	ld	a1,0(s7)
    1076:	855a                	mv	a0,s6
    1078:	e1fff0ef          	jal	e96 <printint>
        i += 2;
    107c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    107e:	8ba6                	mv	s7,s1
      state = 0;
    1080:	4981                	li	s3,0
        i += 2;
    1082:	bdc5                	j	f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1084:	008b8493          	addi	s1,s7,8
    1088:	4685                	li	a3,1
    108a:	4629                	li	a2,10
    108c:	000bb583          	ld	a1,0(s7)
    1090:	855a                	mv	a0,s6
    1092:	e05ff0ef          	jal	e96 <printint>
        i += 2;
    1096:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    1098:	8ba6                	mv	s7,s1
      state = 0;
    109a:	4981                	li	s3,0
        i += 2;
    109c:	bdd9                	j	f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
    109e:	008b8493          	addi	s1,s7,8
    10a2:	4681                	li	a3,0
    10a4:	4629                	li	a2,10
    10a6:	000be583          	lwu	a1,0(s7)
    10aa:	855a                	mv	a0,s6
    10ac:	debff0ef          	jal	e96 <printint>
    10b0:	8ba6                	mv	s7,s1
      state = 0;
    10b2:	4981                	li	s3,0
    10b4:	bd7d                	j	f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10b6:	008b8493          	addi	s1,s7,8
    10ba:	4681                	li	a3,0
    10bc:	4629                	li	a2,10
    10be:	000bb583          	ld	a1,0(s7)
    10c2:	855a                	mv	a0,s6
    10c4:	dd3ff0ef          	jal	e96 <printint>
        i += 1;
    10c8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    10ca:	8ba6                	mv	s7,s1
      state = 0;
    10cc:	4981                	li	s3,0
        i += 1;
    10ce:	b555                	j	f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10d0:	008b8493          	addi	s1,s7,8
    10d4:	4681                	li	a3,0
    10d6:	4629                	li	a2,10
    10d8:	000bb583          	ld	a1,0(s7)
    10dc:	855a                	mv	a0,s6
    10de:	db9ff0ef          	jal	e96 <printint>
        i += 2;
    10e2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    10e4:	8ba6                	mv	s7,s1
      state = 0;
    10e6:	4981                	li	s3,0
        i += 2;
    10e8:	b569                	j	f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
    10ea:	008b8493          	addi	s1,s7,8
    10ee:	4681                	li	a3,0
    10f0:	4641                	li	a2,16
    10f2:	000be583          	lwu	a1,0(s7)
    10f6:	855a                	mv	a0,s6
    10f8:	d9fff0ef          	jal	e96 <printint>
    10fc:	8ba6                	mv	s7,s1
      state = 0;
    10fe:	4981                	li	s3,0
    1100:	bd8d                	j	f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1102:	008b8493          	addi	s1,s7,8
    1106:	4681                	li	a3,0
    1108:	4641                	li	a2,16
    110a:	000bb583          	ld	a1,0(s7)
    110e:	855a                	mv	a0,s6
    1110:	d87ff0ef          	jal	e96 <printint>
        i += 1;
    1114:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1116:	8ba6                	mv	s7,s1
      state = 0;
    1118:	4981                	li	s3,0
        i += 1;
    111a:	bda1                	j	f72 <vprintf+0x4a>
    111c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    111e:	008b8d13          	addi	s10,s7,8
    1122:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1126:	03000593          	li	a1,48
    112a:	855a                	mv	a0,s6
    112c:	d4dff0ef          	jal	e78 <putc>
  putc(fd, 'x');
    1130:	07800593          	li	a1,120
    1134:	855a                	mv	a0,s6
    1136:	d43ff0ef          	jal	e78 <putc>
    113a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    113c:	00000b97          	auipc	s7,0x0
    1140:	5d4b8b93          	addi	s7,s7,1492 # 1710 <digits>
    1144:	03c9d793          	srli	a5,s3,0x3c
    1148:	97de                	add	a5,a5,s7
    114a:	0007c583          	lbu	a1,0(a5)
    114e:	855a                	mv	a0,s6
    1150:	d29ff0ef          	jal	e78 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1154:	0992                	slli	s3,s3,0x4
    1156:	34fd                	addiw	s1,s1,-1
    1158:	f4f5                	bnez	s1,1144 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
    115a:	8bea                	mv	s7,s10
      state = 0;
    115c:	4981                	li	s3,0
    115e:	6d02                	ld	s10,0(sp)
    1160:	bd09                	j	f72 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    1162:	008b8493          	addi	s1,s7,8
    1166:	000bc583          	lbu	a1,0(s7)
    116a:	855a                	mv	a0,s6
    116c:	d0dff0ef          	jal	e78 <putc>
    1170:	8ba6                	mv	s7,s1
      state = 0;
    1172:	4981                	li	s3,0
    1174:	bbfd                	j	f72 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1176:	008b8993          	addi	s3,s7,8
    117a:	000bb483          	ld	s1,0(s7)
    117e:	cc91                	beqz	s1,119a <vprintf+0x272>
        for(; *s; s++)
    1180:	0004c583          	lbu	a1,0(s1)
    1184:	c195                	beqz	a1,11a8 <vprintf+0x280>
          putc(fd, *s);
    1186:	855a                	mv	a0,s6
    1188:	cf1ff0ef          	jal	e78 <putc>
        for(; *s; s++)
    118c:	0485                	addi	s1,s1,1
    118e:	0004c583          	lbu	a1,0(s1)
    1192:	f9f5                	bnez	a1,1186 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
    1194:	8bce                	mv	s7,s3
      state = 0;
    1196:	4981                	li	s3,0
    1198:	bbe9                	j	f72 <vprintf+0x4a>
          s = "(null)";
    119a:	00000497          	auipc	s1,0x0
    119e:	50e48493          	addi	s1,s1,1294 # 16a8 <malloc+0x3fe>
        for(; *s; s++)
    11a2:	02800593          	li	a1,40
    11a6:	b7c5                	j	1186 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
    11a8:	8bce                	mv	s7,s3
      state = 0;
    11aa:	4981                	li	s3,0
    11ac:	b3d9                	j	f72 <vprintf+0x4a>
    11ae:	6906                	ld	s2,64(sp)
    11b0:	79e2                	ld	s3,56(sp)
    11b2:	7a42                	ld	s4,48(sp)
    11b4:	7aa2                	ld	s5,40(sp)
    11b6:	7b02                	ld	s6,32(sp)
    11b8:	6be2                	ld	s7,24(sp)
    11ba:	6c42                	ld	s8,16(sp)
    11bc:	6ca2                	ld	s9,8(sp)
    }
  }
}
    11be:	60e6                	ld	ra,88(sp)
    11c0:	6446                	ld	s0,80(sp)
    11c2:	64a6                	ld	s1,72(sp)
    11c4:	6125                	addi	sp,sp,96
    11c6:	8082                	ret

00000000000011c8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11c8:	715d                	addi	sp,sp,-80
    11ca:	ec06                	sd	ra,24(sp)
    11cc:	e822                	sd	s0,16(sp)
    11ce:	1000                	addi	s0,sp,32
    11d0:	e010                	sd	a2,0(s0)
    11d2:	e414                	sd	a3,8(s0)
    11d4:	e818                	sd	a4,16(s0)
    11d6:	ec1c                	sd	a5,24(s0)
    11d8:	03043023          	sd	a6,32(s0)
    11dc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11e0:	8622                	mv	a2,s0
    11e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11e6:	d43ff0ef          	jal	f28 <vprintf>
}
    11ea:	60e2                	ld	ra,24(sp)
    11ec:	6442                	ld	s0,16(sp)
    11ee:	6161                	addi	sp,sp,80
    11f0:	8082                	ret

00000000000011f2 <printf>:

void
printf(const char *fmt, ...)
{
    11f2:	711d                	addi	sp,sp,-96
    11f4:	ec06                	sd	ra,24(sp)
    11f6:	e822                	sd	s0,16(sp)
    11f8:	1000                	addi	s0,sp,32
    11fa:	e40c                	sd	a1,8(s0)
    11fc:	e810                	sd	a2,16(s0)
    11fe:	ec14                	sd	a3,24(s0)
    1200:	f018                	sd	a4,32(s0)
    1202:	f41c                	sd	a5,40(s0)
    1204:	03043823          	sd	a6,48(s0)
    1208:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    120c:	00840613          	addi	a2,s0,8
    1210:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1214:	85aa                	mv	a1,a0
    1216:	4505                	li	a0,1
    1218:	d11ff0ef          	jal	f28 <vprintf>
}
    121c:	60e2                	ld	ra,24(sp)
    121e:	6442                	ld	s0,16(sp)
    1220:	6125                	addi	sp,sp,96
    1222:	8082                	ret

0000000000001224 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1224:	1141                	addi	sp,sp,-16
    1226:	e406                	sd	ra,8(sp)
    1228:	e022                	sd	s0,0(sp)
    122a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    122c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1230:	00001797          	auipc	a5,0x1
    1234:	de07b783          	ld	a5,-544(a5) # 2010 <freep>
    1238:	a02d                	j	1262 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    123a:	4618                	lw	a4,8(a2)
    123c:	9f2d                	addw	a4,a4,a1
    123e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1242:	6398                	ld	a4,0(a5)
    1244:	6310                	ld	a2,0(a4)
    1246:	a83d                	j	1284 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1248:	ff852703          	lw	a4,-8(a0)
    124c:	9f31                	addw	a4,a4,a2
    124e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1250:	ff053683          	ld	a3,-16(a0)
    1254:	a091                	j	1298 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1256:	6398                	ld	a4,0(a5)
    1258:	00e7e463          	bltu	a5,a4,1260 <free+0x3c>
    125c:	00e6ea63          	bltu	a3,a4,1270 <free+0x4c>
{
    1260:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1262:	fed7fae3          	bgeu	a5,a3,1256 <free+0x32>
    1266:	6398                	ld	a4,0(a5)
    1268:	00e6e463          	bltu	a3,a4,1270 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    126c:	fee7eae3          	bltu	a5,a4,1260 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    1270:	ff852583          	lw	a1,-8(a0)
    1274:	6390                	ld	a2,0(a5)
    1276:	02059813          	slli	a6,a1,0x20
    127a:	01c85713          	srli	a4,a6,0x1c
    127e:	9736                	add	a4,a4,a3
    1280:	fae60de3          	beq	a2,a4,123a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    1284:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1288:	4790                	lw	a2,8(a5)
    128a:	02061593          	slli	a1,a2,0x20
    128e:	01c5d713          	srli	a4,a1,0x1c
    1292:	973e                	add	a4,a4,a5
    1294:	fae68ae3          	beq	a3,a4,1248 <free+0x24>
    p->s.ptr = bp->s.ptr;
    1298:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    129a:	00001717          	auipc	a4,0x1
    129e:	d6f73b23          	sd	a5,-650(a4) # 2010 <freep>
}
    12a2:	60a2                	ld	ra,8(sp)
    12a4:	6402                	ld	s0,0(sp)
    12a6:	0141                	addi	sp,sp,16
    12a8:	8082                	ret

00000000000012aa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    12aa:	7139                	addi	sp,sp,-64
    12ac:	fc06                	sd	ra,56(sp)
    12ae:	f822                	sd	s0,48(sp)
    12b0:	f04a                	sd	s2,32(sp)
    12b2:	ec4e                	sd	s3,24(sp)
    12b4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12b6:	02051993          	slli	s3,a0,0x20
    12ba:	0209d993          	srli	s3,s3,0x20
    12be:	09bd                	addi	s3,s3,15
    12c0:	0049d993          	srli	s3,s3,0x4
    12c4:	2985                	addiw	s3,s3,1
    12c6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    12c8:	00001517          	auipc	a0,0x1
    12cc:	d4853503          	ld	a0,-696(a0) # 2010 <freep>
    12d0:	c905                	beqz	a0,1300 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12d4:	4798                	lw	a4,8(a5)
    12d6:	09377663          	bgeu	a4,s3,1362 <malloc+0xb8>
    12da:	f426                	sd	s1,40(sp)
    12dc:	e852                	sd	s4,16(sp)
    12de:	e456                	sd	s5,8(sp)
    12e0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    12e2:	8a4e                	mv	s4,s3
    12e4:	6705                	lui	a4,0x1
    12e6:	00e9f363          	bgeu	s3,a4,12ec <malloc+0x42>
    12ea:	6a05                	lui	s4,0x1
    12ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    12f0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    12f4:	00001497          	auipc	s1,0x1
    12f8:	d1c48493          	addi	s1,s1,-740 # 2010 <freep>
  if(p == SBRK_ERROR)
    12fc:	5afd                	li	s5,-1
    12fe:	a83d                	j	133c <malloc+0x92>
    1300:	f426                	sd	s1,40(sp)
    1302:	e852                	sd	s4,16(sp)
    1304:	e456                	sd	s5,8(sp)
    1306:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1308:	00001797          	auipc	a5,0x1
    130c:	10078793          	addi	a5,a5,256 # 2408 <base>
    1310:	00001717          	auipc	a4,0x1
    1314:	d0f73023          	sd	a5,-768(a4) # 2010 <freep>
    1318:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    131a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    131e:	b7d1                	j	12e2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    1320:	6398                	ld	a4,0(a5)
    1322:	e118                	sd	a4,0(a0)
    1324:	a899                	j	137a <malloc+0xd0>
  hp->s.size = nu;
    1326:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    132a:	0541                	addi	a0,a0,16
    132c:	ef9ff0ef          	jal	1224 <free>
  return freep;
    1330:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    1332:	c125                	beqz	a0,1392 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1334:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1336:	4798                	lw	a4,8(a5)
    1338:	03277163          	bgeu	a4,s2,135a <malloc+0xb0>
    if(p == freep)
    133c:	6098                	ld	a4,0(s1)
    133e:	853e                	mv	a0,a5
    1340:	fef71ae3          	bne	a4,a5,1334 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    1344:	8552                	mv	a0,s4
    1346:	8c7ff0ef          	jal	c0c <sbrk>
  if(p == SBRK_ERROR)
    134a:	fd551ee3          	bne	a0,s5,1326 <malloc+0x7c>
        return 0;
    134e:	4501                	li	a0,0
    1350:	74a2                	ld	s1,40(sp)
    1352:	6a42                	ld	s4,16(sp)
    1354:	6aa2                	ld	s5,8(sp)
    1356:	6b02                	ld	s6,0(sp)
    1358:	a03d                	j	1386 <malloc+0xdc>
    135a:	74a2                	ld	s1,40(sp)
    135c:	6a42                	ld	s4,16(sp)
    135e:	6aa2                	ld	s5,8(sp)
    1360:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1362:	fae90fe3          	beq	s2,a4,1320 <malloc+0x76>
        p->s.size -= nunits;
    1366:	4137073b          	subw	a4,a4,s3
    136a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    136c:	02071693          	slli	a3,a4,0x20
    1370:	01c6d713          	srli	a4,a3,0x1c
    1374:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1376:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    137a:	00001717          	auipc	a4,0x1
    137e:	c8a73b23          	sd	a0,-874(a4) # 2010 <freep>
      return (void*)(p + 1);
    1382:	01078513          	addi	a0,a5,16
  }
}
    1386:	70e2                	ld	ra,56(sp)
    1388:	7442                	ld	s0,48(sp)
    138a:	7902                	ld	s2,32(sp)
    138c:	69e2                	ld	s3,24(sp)
    138e:	6121                	addi	sp,sp,64
    1390:	8082                	ret
    1392:	74a2                	ld	s1,40(sp)
    1394:	6a42                	ld	s4,16(sp)
    1396:	6aa2                	ld	s5,8(sp)
    1398:	6b02                	ld	s6,0(sp)
    139a:	b7f5                	j	1386 <malloc+0xdc>
