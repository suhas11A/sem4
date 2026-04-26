
user/_nettest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <txone>:
// this packet, and you can also see what
// happened with tcpdump -XXnr packets.pcap
//
void
txone()
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	1000                	addi	s0,sp,32
  printf("txone: sending one packet\n");
       8:	00002517          	auipc	a0,0x2
       c:	0e850513          	addi	a0,a0,232 # 20f0 <malloc+0xf4>
      10:	735010ef          	jal	1f44 <printf>
  uint32 dst = 0x0A000202; // 10.0.2.2
  int dport = NET_TESTS_PORT;
  char buf[5];
  buf[0] = 't';
      14:	07400793          	li	a5,116
      18:	fef40423          	sb	a5,-24(s0)
  buf[1] = 'x';
      1c:	07800793          	li	a5,120
      20:	fef404a3          	sb	a5,-23(s0)
  buf[2] = 'o';
      24:	06f00793          	li	a5,111
      28:	fef40523          	sb	a5,-22(s0)
  buf[3] = 'n';
      2c:	06e00793          	li	a5,110
      30:	fef405a3          	sb	a5,-21(s0)
  buf[4] = 'e';
      34:	06500793          	li	a5,101
      38:	fef40623          	sb	a5,-20(s0)
  if(send(2003, dst, dport, buf, 5) < 0){
      3c:	4715                	li	a4,5
      3e:	fe840693          	addi	a3,s0,-24
      42:	6619                	lui	a2,0x6
      44:	20b60613          	addi	a2,a2,523 # 620b <base+0x2ffb>
      48:	0a0005b7          	lui	a1,0xa000
      4c:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffcff2>
      50:	7d300513          	li	a0,2003
      54:	365010ef          	jal	1bb8 <send>
      58:	00054663          	bltz	a0,64 <txone+0x64>
    printf("txone: send() failed\n");
  }
}
      5c:	60e2                	ld	ra,24(sp)
      5e:	6442                	ld	s0,16(sp)
      60:	6105                	addi	sp,sp,32
      62:	8082                	ret
    printf("txone: send() failed\n");
      64:	00002517          	auipc	a0,0x2
      68:	0ac50513          	addi	a0,a0,172 # 2110 <malloc+0x114>
      6c:	6d9010ef          	jal	1f44 <printf>
}
      70:	b7f5                	j	5c <txone+0x5c>

0000000000000072 <rxone>:

int
rxone()
{
      72:	7171                	addi	sp,sp,-176
      74:	f506                	sd	ra,168(sp)
      76:	f122                	sd	s0,160(sp)
      78:	ed26                	sd	s1,152(sp)
      7a:	1900                	addi	s0,sp,176
  printf("rxone: starting\n");
      7c:	00002517          	auipc	a0,0x2
      80:	0ac50513          	addi	a0,a0,172 # 2128 <malloc+0x12c>
      84:	6c1010ef          	jal	1f44 <printf>

  if(bind(2000) < 0){
      88:	7d000513          	li	a0,2000
      8c:	31d010ef          	jal	1ba8 <bind>
      90:	08054263          	bltz	a0,114 <rxone+0xa2>
    fprintf(2, "rxone: bind() failed\n");
    return 0;
  }

  char ibuf[128];
  uint32 src = 0;
      94:	f4042e23          	sw	zero,-164(s0)
  uint16 sport = 0;
      98:	f4041d23          	sh	zero,-166(s0)
  int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
      9c:	07f00713          	li	a4,127
      a0:	f6040693          	addi	a3,s0,-160
      a4:	f5a40613          	addi	a2,s0,-166
      a8:	f5c40593          	addi	a1,s0,-164
      ac:	7d000513          	li	a0,2000
      b0:	311010ef          	jal	1bc0 <recv>
      b4:	84aa                	mv	s1,a0
  if(cc < 0){
      b6:	06054d63          	bltz	a0,130 <rxone+0xbe>
    fprintf(2, "rxone: recv() failed\n");
    return 0;
  }

  if(src != 0x0A000202){ // 10.0.2.2
      ba:	f5c42583          	lw	a1,-164(s0)
      be:	0a0007b7          	lui	a5,0xa000
      c2:	20278793          	addi	a5,a5,514 # a000202 <base+0x9ffcff2>
      c6:	06f59e63          	bne	a1,a5,142 <rxone+0xd0>
    printf("rxone: wrong ip src %x\n", src);
    return 0;
  }

  if(cc <= 0){
      ca:	c541                	beqz	a0,152 <rxone+0xe0>
    printf("rxone: empty packet\n");
    return 0;
  }

  ibuf[cc] = '\0';
      cc:	fe050793          	addi	a5,a0,-32
      d0:	008784b3          	add	s1,a5,s0
      d4:	f8048023          	sb	zero,-128(s1)
  printf("rxone: got \"%s\"\n", ibuf);
      d8:	f6040593          	addi	a1,s0,-160
      dc:	00002517          	auipc	a0,0x2
      e0:	0c450513          	addi	a0,a0,196 # 21a0 <malloc+0x1a4>
      e4:	661010ef          	jal	1f44 <printf>
  printf("rxone: OK\n");
      e8:	00002517          	auipc	a0,0x2
      ec:	0d050513          	addi	a0,a0,208 # 21b8 <malloc+0x1bc>
      f0:	655010ef          	jal	1f44 <printf>

  if(unbind(2000) < 0){
      f4:	7d000513          	li	a0,2000
      f8:	2b9010ef          	jal	1bb0 <unbind>
    fprintf(2, "rxone: unbind() failed\n");
    return 0;
  }

  return 1;
      fc:	4485                	li	s1,1
  if(unbind(2000) < 0){
      fe:	02055363          	bgez	a0,124 <rxone+0xb2>
    fprintf(2, "rxone: unbind() failed\n");
     102:	00002597          	auipc	a1,0x2
     106:	0c658593          	addi	a1,a1,198 # 21c8 <malloc+0x1cc>
     10a:	4509                	li	a0,2
     10c:	60f010ef          	jal	1f1a <fprintf>
    return 0;
     110:	4481                	li	s1,0
     112:	a809                	j	124 <rxone+0xb2>
    fprintf(2, "rxone: bind() failed\n");
     114:	00002597          	auipc	a1,0x2
     118:	02c58593          	addi	a1,a1,44 # 2140 <malloc+0x144>
     11c:	4509                	li	a0,2
     11e:	5fd010ef          	jal	1f1a <fprintf>
    return 0;
     122:	4481                	li	s1,0
}
     124:	8526                	mv	a0,s1
     126:	70aa                	ld	ra,168(sp)
     128:	740a                	ld	s0,160(sp)
     12a:	64ea                	ld	s1,152(sp)
     12c:	614d                	addi	sp,sp,176
     12e:	8082                	ret
    fprintf(2, "rxone: recv() failed\n");
     130:	00002597          	auipc	a1,0x2
     134:	02858593          	addi	a1,a1,40 # 2158 <malloc+0x15c>
     138:	4509                	li	a0,2
     13a:	5e1010ef          	jal	1f1a <fprintf>
    return 0;
     13e:	4481                	li	s1,0
     140:	b7d5                	j	124 <rxone+0xb2>
    printf("rxone: wrong ip src %x\n", src);
     142:	00002517          	auipc	a0,0x2
     146:	02e50513          	addi	a0,a0,46 # 2170 <malloc+0x174>
     14a:	5fb010ef          	jal	1f44 <printf>
    return 0;
     14e:	4481                	li	s1,0
     150:	bfd1                	j	124 <rxone+0xb2>
    printf("rxone: empty packet\n");
     152:	00002517          	auipc	a0,0x2
     156:	03650513          	addi	a0,a0,54 # 2188 <malloc+0x18c>
     15a:	5eb010ef          	jal	1f44 <printf>
    return 0;
     15e:	b7d9                	j	124 <rxone+0xb2>

0000000000000160 <rx>:
// outside of qemu, run
//   ./nettest.py rx
//
int
rx(char *name)
{
     160:	716d                	addi	sp,sp,-272
     162:	e606                	sd	ra,264(sp)
     164:	e222                	sd	s0,256(sp)
     166:	fda6                	sd	s1,248(sp)
     168:	f9ca                	sd	s2,240(sp)
     16a:	f5ce                	sd	s3,232(sp)
     16c:	f1d2                	sd	s4,224(sp)
     16e:	edd6                	sd	s5,216(sp)
     170:	e9da                	sd	s6,208(sp)
     172:	e5de                	sd	s7,200(sp)
     174:	e1e2                	sd	s8,192(sp)
     176:	fd66                	sd	s9,184(sp)
     178:	f96a                	sd	s10,176(sp)
     17a:	f56e                	sd	s11,168(sp)
     17c:	0a00                	addi	s0,sp,272
     17e:	eea43c23          	sd	a0,-264(s0)
  bind(2000);
     182:	7d000513          	li	a0,2000
     186:	223010ef          	jal	1ba8 <bind>
     18a:	4b11                	li	s6,4

  int lastseq = -1;
     18c:	5afd                	li	s5,-1

  while(ok < 4){
    char ibuf[128];
    uint32 src;
    uint16 sport;
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
     18e:	f1040a13          	addi	s4,s0,-240
     192:	f0a40d13          	addi	s10,s0,-246
     196:	f0c40c93          	addi	s9,s0,-244
     19a:	07f00c13          	li	s8,127
     19e:	7d000b93          	li	s7,2000
    if(cc < 0){
      fprintf(2, "nettest %s: recv() failed\n", name);
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
     1a2:	0a0009b7          	lui	s3,0xa000
     1a6:	20298993          	addi	s3,s3,514 # a000202 <base+0x9ffcff2>
      printf("wrong ip src %x\n", src);
      return 0;
    }

    if(cc < strlen("packet 1")){
     1aa:	00002d97          	auipc	s11,0x2
     1ae:	06ed8d93          	addi	s11,s11,110 # 2218 <malloc+0x21c>
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
     1b2:	8762                	mv	a4,s8
     1b4:	86d2                	mv	a3,s4
     1b6:	866a                	mv	a2,s10
     1b8:	85e6                	mv	a1,s9
     1ba:	855e                	mv	a0,s7
     1bc:	205010ef          	jal	1bc0 <recv>
     1c0:	84aa                	mv	s1,a0
    if(cc < 0){
     1c2:	10054a63          	bltz	a0,2d6 <rx+0x176>
    if(src != 0x0A000202){ // 10.0.2.2
     1c6:	f0c42583          	lw	a1,-244(s0)
     1ca:	13359063          	bne	a1,s3,2ea <rx+0x18a>
    if(cc < strlen("packet 1")){
     1ce:	856e                	mv	a0,s11
     1d0:	6d0010ef          	jal	18a0 <strlen>
     1d4:	12a4e263          	bltu	s1,a0,2f8 <rx+0x198>
      printf("len %d too short\n", cc);
      return 0;
    }

    if(cc > strlen("packet xxxxxx")){
     1d8:	00002517          	auipc	a0,0x2
     1dc:	06850513          	addi	a0,a0,104 # 2240 <malloc+0x244>
     1e0:	6c0010ef          	jal	18a0 <strlen>
     1e4:	12956263          	bltu	a0,s1,308 <rx+0x1a8>
      printf("len %d too long\n", cc);
      return 0;
    }

    if(memcmp(ibuf, "packet ", strlen("packet ")) != 0){
     1e8:	00002517          	auipc	a0,0x2
     1ec:	08050513          	addi	a0,a0,128 # 2268 <malloc+0x26c>
     1f0:	6b0010ef          	jal	18a0 <strlen>
     1f4:	862a                	mv	a2,a0
     1f6:	00002597          	auipc	a1,0x2
     1fa:	07258593          	addi	a1,a1,114 # 2268 <malloc+0x26c>
     1fe:	8552                	mv	a0,s4
     200:	083010ef          	jal	1a82 <memcmp>
     204:	892a                	mv	s2,a0
     206:	10051963          	bnez	a0,318 <rx+0x1b8>
      printf("packet doesn't start with packet\n");
      return 0;
    }

    ibuf[cc] = '\0';
     20a:	f9048793          	addi	a5,s1,-112
     20e:	97a2                	add	a5,a5,s0
     210:	f8078023          	sb	zero,-128(a5)
#define isdigit(x) ((x) >= '0' && (x) <= '9')
    if(!isdigit(ibuf[7])){
     214:	f1744583          	lbu	a1,-233(s0)
     218:	fd05879b          	addiw	a5,a1,-48
     21c:	0ff7f793          	zext.b	a5,a5
     220:	4725                	li	a4,9
     222:	10f76263          	bltu	a4,a5,326 <rx+0x1c6>
      printf("packet doesn't contain a number\n");
      return 0;
    }
    for(int i = 7; i < cc; i++){
     226:	479d                	li	a5,7
     228:	0297d663          	bge	a5,s1,254 <rx+0xf4>
     22c:	f1740713          	addi	a4,s0,-233
     230:	34e1                	addiw	s1,s1,-8
     232:	1482                	slli	s1,s1,0x20
     234:	9081                	srli	s1,s1,0x20
     236:	f1840693          	addi	a3,s0,-232
     23a:	96a6                	add	a3,a3,s1
      if(!isdigit(ibuf[i])){
     23c:	4625                	li	a2,9
     23e:	00074783          	lbu	a5,0(a4)
     242:	fd07879b          	addiw	a5,a5,-48
     246:	0ff7f793          	zext.b	a5,a5
     24a:	0ef66563          	bltu	a2,a5,334 <rx+0x1d4>
    for(int i = 7; i < cc; i++){
     24e:	0705                	addi	a4,a4,1
     250:	fed717e3          	bne	a4,a3,23e <rx+0xde>
        printf("packet contains non-digits in the number\n");
        return 0;
      }
    }
    int seq = ibuf[7] - '0';
     254:	fd05859b          	addiw	a1,a1,-48
     258:	872e                	mv	a4,a1
    if(isdigit(ibuf[8])){
     25a:	f1844783          	lbu	a5,-232(s0)
     25e:	fd07869b          	addiw	a3,a5,-48
     262:	0ff6f693          	zext.b	a3,a3
     266:	4625                	li	a2,9
     268:	02d66c63          	bltu	a2,a3,2a0 <rx+0x140>
      seq *= 10;
     26c:	0025971b          	slliw	a4,a1,0x2
     270:	9f2d                	addw	a4,a4,a1
     272:	0017171b          	slliw	a4,a4,0x1
      seq += ibuf[8] - '0';
     276:	fd07879b          	addiw	a5,a5,-48
     27a:	9fb9                	addw	a5,a5,a4
     27c:	873e                	mv	a4,a5
      if(isdigit(ibuf[9])){
     27e:	f1944603          	lbu	a2,-231(s0)
     282:	fd06069b          	addiw	a3,a2,-48
     286:	0ff6f693          	zext.b	a3,a3
     28a:	45a5                	li	a1,9
     28c:	00d5ea63          	bltu	a1,a3,2a0 <rx+0x140>
        seq *= 10;
     290:	0027971b          	slliw	a4,a5,0x2
     294:	9f3d                	addw	a4,a4,a5
     296:	0017171b          	slliw	a4,a4,0x1
        seq += ibuf[9] - '0';
     29a:	fd06061b          	addiw	a2,a2,-48
     29e:	9f31                	addw	a4,a4,a2
      }
    }

    if(lastseq != -1){
     2a0:	57fd                	li	a5,-1
     2a2:	00fa8563          	beq	s5,a5,2ac <rx+0x14c>
      if(seq != lastseq + 1){
     2a6:	2a85                	addiw	s5,s5,1
     2a8:	0aea9d63          	bne	s5,a4,362 <rx+0x202>
  while(ok < 4){
     2ac:	3b7d                	addiw	s6,s6,-1
     2ae:	020b1263          	bnez	s6,2d2 <rx+0x172>
    lastseq = seq;
    
    ok += 1;
  }

  printf("%s: OK\n", name);
     2b2:	ef843583          	ld	a1,-264(s0)
     2b6:	00002517          	auipc	a0,0x2
     2ba:	05a50513          	addi	a0,a0,90 # 2310 <malloc+0x314>
     2be:	487010ef          	jal	1f44 <printf>

  if(unbind(2000) < 0){
     2c2:	7d000513          	li	a0,2000
     2c6:	0eb010ef          	jal	1bb0 <unbind>
     2ca:	0a054563          	bltz	a0,374 <rx+0x214>
    fprintf(2, "nettest %s: unbind() failed\n", name);
    return 0;
  }

  return 1;
     2ce:	4905                	li	s2,1
     2d0:	a88d                	j	342 <rx+0x1e2>
     2d2:	8aba                	mv	s5,a4
     2d4:	bdf9                	j	1b2 <rx+0x52>
      fprintf(2, "nettest %s: recv() failed\n", name);
     2d6:	ef843603          	ld	a2,-264(s0)
     2da:	00002597          	auipc	a1,0x2
     2de:	f0658593          	addi	a1,a1,-250 # 21e0 <malloc+0x1e4>
     2e2:	4509                	li	a0,2
     2e4:	437010ef          	jal	1f1a <fprintf>
      return 0;
     2e8:	a8a1                	j	340 <rx+0x1e0>
      printf("wrong ip src %x\n", src);
     2ea:	00002517          	auipc	a0,0x2
     2ee:	f1650513          	addi	a0,a0,-234 # 2200 <malloc+0x204>
     2f2:	453010ef          	jal	1f44 <printf>
      return 0;
     2f6:	a0a9                	j	340 <rx+0x1e0>
      printf("len %d too short\n", cc);
     2f8:	85a6                	mv	a1,s1
     2fa:	00002517          	auipc	a0,0x2
     2fe:	f2e50513          	addi	a0,a0,-210 # 2228 <malloc+0x22c>
     302:	443010ef          	jal	1f44 <printf>
      return 0;
     306:	a82d                	j	340 <rx+0x1e0>
      printf("len %d too long\n", cc);
     308:	85a6                	mv	a1,s1
     30a:	00002517          	auipc	a0,0x2
     30e:	f4650513          	addi	a0,a0,-186 # 2250 <malloc+0x254>
     312:	433010ef          	jal	1f44 <printf>
      return 0;
     316:	a02d                	j	340 <rx+0x1e0>
      printf("packet doesn't start with packet\n");
     318:	00002517          	auipc	a0,0x2
     31c:	f5850513          	addi	a0,a0,-168 # 2270 <malloc+0x274>
     320:	425010ef          	jal	1f44 <printf>
      return 0;
     324:	a831                	j	340 <rx+0x1e0>
      printf("packet doesn't contain a number\n");
     326:	00002517          	auipc	a0,0x2
     32a:	f7250513          	addi	a0,a0,-142 # 2298 <malloc+0x29c>
     32e:	417010ef          	jal	1f44 <printf>
      return 0;
     332:	a039                	j	340 <rx+0x1e0>
        printf("packet contains non-digits in the number\n");
     334:	00002517          	auipc	a0,0x2
     338:	f8c50513          	addi	a0,a0,-116 # 22c0 <malloc+0x2c4>
     33c:	409010ef          	jal	1f44 <printf>
      return 0;
     340:	4901                	li	s2,0
}
     342:	854a                	mv	a0,s2
     344:	60b2                	ld	ra,264(sp)
     346:	6412                	ld	s0,256(sp)
     348:	74ee                	ld	s1,248(sp)
     34a:	794e                	ld	s2,240(sp)
     34c:	79ae                	ld	s3,232(sp)
     34e:	7a0e                	ld	s4,224(sp)
     350:	6aee                	ld	s5,216(sp)
     352:	6b4e                	ld	s6,208(sp)
     354:	6bae                	ld	s7,200(sp)
     356:	6c0e                	ld	s8,192(sp)
     358:	7cea                	ld	s9,184(sp)
     35a:	7d4a                	ld	s10,176(sp)
     35c:	7daa                	ld	s11,168(sp)
     35e:	6151                	addi	sp,sp,272
     360:	8082                	ret
        printf("got seq %d, expecting %d\n", seq, lastseq + 1);
     362:	8656                	mv	a2,s5
     364:	85ba                	mv	a1,a4
     366:	00002517          	auipc	a0,0x2
     36a:	f8a50513          	addi	a0,a0,-118 # 22f0 <malloc+0x2f4>
     36e:	3d7010ef          	jal	1f44 <printf>
        return 0;
     372:	b7f9                	j	340 <rx+0x1e0>
    fprintf(2, "nettest %s: unbind() failed\n", name);
     374:	ef843603          	ld	a2,-264(s0)
     378:	00002597          	auipc	a1,0x2
     37c:	fa058593          	addi	a1,a1,-96 # 2318 <malloc+0x31c>
     380:	4509                	li	a0,2
     382:	399010ef          	jal	1f1a <fprintf>
    return 0;
     386:	bf75                	j	342 <rx+0x1e2>

0000000000000388 <rx2>:
// outside of qemu, run
//   ./nettest.py rx2
//
int
rx2()
{
     388:	7111                	addi	sp,sp,-256
     38a:	fd86                	sd	ra,248(sp)
     38c:	f9a2                	sd	s0,240(sp)
     38e:	f5a6                	sd	s1,232(sp)
     390:	f1ca                	sd	s2,224(sp)
     392:	edce                	sd	s3,216(sp)
     394:	e9d2                	sd	s4,208(sp)
     396:	e5d6                	sd	s5,200(sp)
     398:	e1da                	sd	s6,192(sp)
     39a:	fd5e                	sd	s7,184(sp)
     39c:	f962                	sd	s8,176(sp)
     39e:	f566                	sd	s9,168(sp)
     3a0:	f16a                	sd	s10,160(sp)
     3a2:	0200                	addi	s0,sp,256
  bind(2000);
     3a4:	7d000513          	li	a0,2000
     3a8:	001010ef          	jal	1ba8 <bind>
  bind(2001);
     3ac:	7d100513          	li	a0,2001
     3b0:	7f8010ef          	jal	1ba8 <bind>
     3b4:	490d                	li	s2,3

  for(int i = 0; i < 3; i++){
    char ibuf[128];
    uint32 src;
    uint16 sport;
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
     3b6:	f1040993          	addi	s3,s0,-240
     3ba:	f0a40c93          	addi	s9,s0,-246
     3be:	f0c40c13          	addi	s8,s0,-244
     3c2:	07f00b93          	li	s7,127
     3c6:	7d000b13          	li	s6,2000
    if(cc < 0){
      fprintf(2, "nettest rx2: recv() failed\n");
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
     3ca:	0a000ab7          	lui	s5,0xa000
     3ce:	202a8a93          	addi	s5,s5,514 # a000202 <base+0x9ffcff2>
      printf("wrong ip src %x\n", src);
      return 0;
    }

    if(cc < strlen("one 1")){
     3d2:	00002d17          	auipc	s10,0x2
     3d6:	f86d0d13          	addi	s10,s10,-122 # 2358 <malloc+0x35c>
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
     3da:	875e                	mv	a4,s7
     3dc:	86ce                	mv	a3,s3
     3de:	8666                	mv	a2,s9
     3e0:	85e2                	mv	a1,s8
     3e2:	855a                	mv	a0,s6
     3e4:	7dc010ef          	jal	1bc0 <recv>
     3e8:	84aa                	mv	s1,a0
    if(cc < 0){
     3ea:	18054a63          	bltz	a0,57e <rx2+0x1f6>
    if(src != 0x0A000202){ // 10.0.2.2
     3ee:	f0c42583          	lw	a1,-244(s0)
     3f2:	19559f63          	bne	a1,s5,590 <rx2+0x208>
    if(cc < strlen("one 1")){
     3f6:	856a                	mv	a0,s10
     3f8:	4a8010ef          	jal	18a0 <strlen>
     3fc:	1aa4e163          	bltu	s1,a0,59e <rx2+0x216>
      printf("len %d too short\n", cc);
      return 0;
    }

    if(cc > strlen("one xxxxxx")){
     400:	00002517          	auipc	a0,0x2
     404:	f6050513          	addi	a0,a0,-160 # 2360 <malloc+0x364>
     408:	498010ef          	jal	18a0 <strlen>
     40c:	1a956163          	bltu	a0,s1,5ae <rx2+0x226>
      printf("len %d too long\n", cc);
      return 0;
    }

    if(memcmp(ibuf, "one ", strlen("one ")) != 0){
     410:	00002517          	auipc	a0,0x2
     414:	f6050513          	addi	a0,a0,-160 # 2370 <malloc+0x374>
     418:	488010ef          	jal	18a0 <strlen>
     41c:	862a                	mv	a2,a0
     41e:	00002597          	auipc	a1,0x2
     422:	f5258593          	addi	a1,a1,-174 # 2370 <malloc+0x374>
     426:	854e                	mv	a0,s3
     428:	65a010ef          	jal	1a82 <memcmp>
     42c:	8a2a                	mv	s4,a0
     42e:	18051863          	bnez	a0,5be <rx2+0x236>
  for(int i = 0; i < 3; i++){
     432:	397d                	addiw	s2,s2,-1
     434:	fa0913e3          	bnez	s2,3da <rx2+0x52>
     438:	ed6e                	sd	s11,152(sp)
     43a:	498d                	li	s3,3

  for(int i = 0; i < 3; i++){
    char ibuf[128];
    uint32 src;
    uint16 sport;
    int cc = recv(2001, &src, &sport, ibuf, sizeof(ibuf)-1);
     43c:	f1040a93          	addi	s5,s0,-240
     440:	f0a40d13          	addi	s10,s0,-246
     444:	f0c40c93          	addi	s9,s0,-244
     448:	07f00c13          	li	s8,127
     44c:	7d100b93          	li	s7,2001
    if(cc < 0){
      fprintf(2, "nettest rx2: recv() failed\n");
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
     450:	0a000b37          	lui	s6,0xa000
     454:	202b0b13          	addi	s6,s6,514 # a000202 <base+0x9ffcff2>
      printf("wrong ip src %x\n", src);
      return 0;
    }

    if(cc < strlen("one 1")){
     458:	00002d97          	auipc	s11,0x2
     45c:	f00d8d93          	addi	s11,s11,-256 # 2358 <malloc+0x35c>
    int cc = recv(2001, &src, &sport, ibuf, sizeof(ibuf)-1);
     460:	8762                	mv	a4,s8
     462:	86d6                	mv	a3,s5
     464:	866a                	mv	a2,s10
     466:	85e6                	mv	a1,s9
     468:	855e                	mv	a0,s7
     46a:	756010ef          	jal	1bc0 <recv>
     46e:	84aa                	mv	s1,a0
    if(cc < 0){
     470:	14054e63          	bltz	a0,5cc <rx2+0x244>
    if(src != 0x0A000202){ // 10.0.2.2
     474:	f0c42583          	lw	a1,-244(s0)
     478:	17659363          	bne	a1,s6,5de <rx2+0x256>
    if(cc < strlen("one 1")){
     47c:	856e                	mv	a0,s11
     47e:	422010ef          	jal	18a0 <strlen>
     482:	16a4e663          	bltu	s1,a0,5ee <rx2+0x266>
      printf("len %d too short\n", cc);
      return 0;
    }

    if(cc > strlen("one xxxxxx")){
     486:	00002517          	auipc	a0,0x2
     48a:	eda50513          	addi	a0,a0,-294 # 2360 <malloc+0x364>
     48e:	412010ef          	jal	18a0 <strlen>
     492:	16956763          	bltu	a0,s1,600 <rx2+0x278>
      printf("len %d too long\n", cc);
      return 0;
    }

    if(memcmp(ibuf, "two ", strlen("two ")) != 0){
     496:	00002517          	auipc	a0,0x2
     49a:	f0250513          	addi	a0,a0,-254 # 2398 <malloc+0x39c>
     49e:	402010ef          	jal	18a0 <strlen>
     4a2:	862a                	mv	a2,a0
     4a4:	00002597          	auipc	a1,0x2
     4a8:	ef458593          	addi	a1,a1,-268 # 2398 <malloc+0x39c>
     4ac:	8556                	mv	a0,s5
     4ae:	5d4010ef          	jal	1a82 <memcmp>
     4b2:	892a                	mv	s2,a0
     4b4:	14051f63          	bnez	a0,612 <rx2+0x28a>
  for(int i = 0; i < 3; i++){
     4b8:	39fd                	addiw	s3,s3,-1
     4ba:	fa0993e3          	bnez	s3,460 <rx2+0xd8>
     4be:	498d                	li	s3,3

  for(int i = 0; i < 3; i++){
    char ibuf[128];
    uint32 src;
    uint16 sport;
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
     4c0:	f1040a13          	addi	s4,s0,-240
     4c4:	f0a40c93          	addi	s9,s0,-246
     4c8:	f0c40c13          	addi	s8,s0,-244
     4cc:	07f00b93          	li	s7,127
     4d0:	7d000b13          	li	s6,2000
    if(cc < 0){
      fprintf(2, "nettest rx2: recv() failed\n");
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
     4d4:	0a000ab7          	lui	s5,0xa000
     4d8:	202a8a93          	addi	s5,s5,514 # a000202 <base+0x9ffcff2>
      printf("wrong ip src %x\n", src);
      return 0;
    }

    if(cc < strlen("one 1")){
     4dc:	00002d17          	auipc	s10,0x2
     4e0:	e7cd0d13          	addi	s10,s10,-388 # 2358 <malloc+0x35c>
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
     4e4:	875e                	mv	a4,s7
     4e6:	86d2                	mv	a3,s4
     4e8:	8666                	mv	a2,s9
     4ea:	85e2                	mv	a1,s8
     4ec:	855a                	mv	a0,s6
     4ee:	6d2010ef          	jal	1bc0 <recv>
     4f2:	84aa                	mv	s1,a0
    if(cc < 0){
     4f4:	12054763          	bltz	a0,622 <rx2+0x29a>
    if(src != 0x0A000202){ // 10.0.2.2
     4f8:	f0c42583          	lw	a1,-244(s0)
     4fc:	13559d63          	bne	a1,s5,636 <rx2+0x2ae>
    if(cc < strlen("one 1")){
     500:	856a                	mv	a0,s10
     502:	39e010ef          	jal	18a0 <strlen>
     506:	12a4ef63          	bltu	s1,a0,644 <rx2+0x2bc>
      printf("len %d too short\n", cc);
      return 0;
    }

    if(cc > strlen("one xxxxxx")){
     50a:	00002517          	auipc	a0,0x2
     50e:	e5650513          	addi	a0,a0,-426 # 2360 <malloc+0x364>
     512:	38e010ef          	jal	18a0 <strlen>
     516:	12956f63          	bltu	a0,s1,654 <rx2+0x2cc>
      printf("len %d too long\n", cc);
      return 0;
    }

    if(memcmp(ibuf, "one ", strlen("one ")) != 0){
     51a:	00002517          	auipc	a0,0x2
     51e:	e5650513          	addi	a0,a0,-426 # 2370 <malloc+0x374>
     522:	37e010ef          	jal	18a0 <strlen>
     526:	862a                	mv	a2,a0
     528:	00002597          	auipc	a1,0x2
     52c:	e4858593          	addi	a1,a1,-440 # 2370 <malloc+0x374>
     530:	8552                	mv	a0,s4
     532:	550010ef          	jal	1a82 <memcmp>
     536:	12051763          	bnez	a0,664 <rx2+0x2dc>
  for(int i = 0; i < 3; i++){
     53a:	39fd                	addiw	s3,s3,-1
     53c:	fa0994e3          	bnez	s3,4e4 <rx2+0x15c>
      printf("packet doesn't start with one\n");
      return 0;
    }
  }

  printf("rx2: OK\n");
     540:	00002517          	auipc	a0,0x2
     544:	e8050513          	addi	a0,a0,-384 # 23c0 <malloc+0x3c4>
     548:	1fd010ef          	jal	1f44 <printf>

  unbind(2000);
     54c:	7d000513          	li	a0,2000
     550:	660010ef          	jal	1bb0 <unbind>
  unbind(2001);
     554:	7d100513          	li	a0,2001
     558:	658010ef          	jal	1bb0 <unbind>

  return 1;
     55c:	4a05                	li	s4,1
     55e:	6dea                	ld	s11,152(sp)
}
     560:	8552                	mv	a0,s4
     562:	70ee                	ld	ra,248(sp)
     564:	744e                	ld	s0,240(sp)
     566:	74ae                	ld	s1,232(sp)
     568:	790e                	ld	s2,224(sp)
     56a:	69ee                	ld	s3,216(sp)
     56c:	6a4e                	ld	s4,208(sp)
     56e:	6aae                	ld	s5,200(sp)
     570:	6b0e                	ld	s6,192(sp)
     572:	7bea                	ld	s7,184(sp)
     574:	7c4a                	ld	s8,176(sp)
     576:	7caa                	ld	s9,168(sp)
     578:	7d0a                	ld	s10,160(sp)
     57a:	6111                	addi	sp,sp,256
     57c:	8082                	ret
      fprintf(2, "nettest rx2: recv() failed\n");
     57e:	00002597          	auipc	a1,0x2
     582:	dba58593          	addi	a1,a1,-582 # 2338 <malloc+0x33c>
     586:	4509                	li	a0,2
     588:	193010ef          	jal	1f1a <fprintf>
      return 0;
     58c:	4a01                	li	s4,0
     58e:	bfc9                	j	560 <rx2+0x1d8>
      printf("wrong ip src %x\n", src);
     590:	00002517          	auipc	a0,0x2
     594:	c7050513          	addi	a0,a0,-912 # 2200 <malloc+0x204>
     598:	1ad010ef          	jal	1f44 <printf>
      return 0;
     59c:	bfc5                	j	58c <rx2+0x204>
      printf("len %d too short\n", cc);
     59e:	85a6                	mv	a1,s1
     5a0:	00002517          	auipc	a0,0x2
     5a4:	c8850513          	addi	a0,a0,-888 # 2228 <malloc+0x22c>
     5a8:	19d010ef          	jal	1f44 <printf>
      return 0;
     5ac:	b7c5                	j	58c <rx2+0x204>
      printf("len %d too long\n", cc);
     5ae:	85a6                	mv	a1,s1
     5b0:	00002517          	auipc	a0,0x2
     5b4:	ca050513          	addi	a0,a0,-864 # 2250 <malloc+0x254>
     5b8:	18d010ef          	jal	1f44 <printf>
      return 0;
     5bc:	bfc1                	j	58c <rx2+0x204>
      printf("packet doesn't start with one\n");
     5be:	00002517          	auipc	a0,0x2
     5c2:	dba50513          	addi	a0,a0,-582 # 2378 <malloc+0x37c>
     5c6:	17f010ef          	jal	1f44 <printf>
      return 0;
     5ca:	b7c9                	j	58c <rx2+0x204>
      fprintf(2, "nettest rx2: recv() failed\n");
     5cc:	00002597          	auipc	a1,0x2
     5d0:	d6c58593          	addi	a1,a1,-660 # 2338 <malloc+0x33c>
     5d4:	4509                	li	a0,2
     5d6:	145010ef          	jal	1f1a <fprintf>
      return 0;
     5da:	6dea                	ld	s11,152(sp)
     5dc:	b751                	j	560 <rx2+0x1d8>
      printf("wrong ip src %x\n", src);
     5de:	00002517          	auipc	a0,0x2
     5e2:	c2250513          	addi	a0,a0,-990 # 2200 <malloc+0x204>
     5e6:	15f010ef          	jal	1f44 <printf>
      return 0;
     5ea:	6dea                	ld	s11,152(sp)
     5ec:	bf95                	j	560 <rx2+0x1d8>
      printf("len %d too short\n", cc);
     5ee:	85a6                	mv	a1,s1
     5f0:	00002517          	auipc	a0,0x2
     5f4:	c3850513          	addi	a0,a0,-968 # 2228 <malloc+0x22c>
     5f8:	14d010ef          	jal	1f44 <printf>
      return 0;
     5fc:	6dea                	ld	s11,152(sp)
     5fe:	b78d                	j	560 <rx2+0x1d8>
      printf("len %d too long\n", cc);
     600:	85a6                	mv	a1,s1
     602:	00002517          	auipc	a0,0x2
     606:	c4e50513          	addi	a0,a0,-946 # 2250 <malloc+0x254>
     60a:	13b010ef          	jal	1f44 <printf>
      return 0;
     60e:	6dea                	ld	s11,152(sp)
     610:	bf81                	j	560 <rx2+0x1d8>
      printf("packet doesn't start with two\n");
     612:	00002517          	auipc	a0,0x2
     616:	d8e50513          	addi	a0,a0,-626 # 23a0 <malloc+0x3a4>
     61a:	12b010ef          	jal	1f44 <printf>
      return 0;
     61e:	6dea                	ld	s11,152(sp)
     620:	b781                	j	560 <rx2+0x1d8>
      fprintf(2, "nettest rx2: recv() failed\n");
     622:	00002597          	auipc	a1,0x2
     626:	d1658593          	addi	a1,a1,-746 # 2338 <malloc+0x33c>
     62a:	4509                	li	a0,2
     62c:	0ef010ef          	jal	1f1a <fprintf>
      return 0;
     630:	8a4a                	mv	s4,s2
     632:	6dea                	ld	s11,152(sp)
     634:	b735                	j	560 <rx2+0x1d8>
      printf("wrong ip src %x\n", src);
     636:	00002517          	auipc	a0,0x2
     63a:	bca50513          	addi	a0,a0,-1078 # 2200 <malloc+0x204>
     63e:	107010ef          	jal	1f44 <printf>
      return 0;
     642:	b7fd                	j	630 <rx2+0x2a8>
      printf("len %d too short\n", cc);
     644:	85a6                	mv	a1,s1
     646:	00002517          	auipc	a0,0x2
     64a:	be250513          	addi	a0,a0,-1054 # 2228 <malloc+0x22c>
     64e:	0f7010ef          	jal	1f44 <printf>
      return 0;
     652:	bff9                	j	630 <rx2+0x2a8>
      printf("len %d too long\n", cc);
     654:	85a6                	mv	a1,s1
     656:	00002517          	auipc	a0,0x2
     65a:	bfa50513          	addi	a0,a0,-1030 # 2250 <malloc+0x254>
     65e:	0e7010ef          	jal	1f44 <printf>
      return 0;
     662:	b7f9                	j	630 <rx2+0x2a8>
      printf("packet doesn't start with one\n");
     664:	00002517          	auipc	a0,0x2
     668:	d1450513          	addi	a0,a0,-748 # 2378 <malloc+0x37c>
     66c:	0d9010ef          	jal	1f44 <printf>
      return 0;
     670:	b7c1                	j	630 <rx2+0x2a8>

0000000000000672 <tx>:
//
// send some UDP packets to nettest.py tx.
//
int
tx()
{
     672:	711d                	addi	sp,sp,-96
     674:	ec86                	sd	ra,88(sp)
     676:	e8a2                	sd	s0,80(sp)
     678:	e4a6                	sd	s1,72(sp)
     67a:	e0ca                	sd	s2,64(sp)
     67c:	fc4e                	sd	s3,56(sp)
     67e:	f852                	sd	s4,48(sp)
     680:	f456                	sd	s5,40(sp)
     682:	f05a                	sd	s6,32(sp)
     684:	ec5e                	sd	s7,24(sp)
     686:	e862                	sd	s8,16(sp)
     688:	1080                	addi	s0,sp,96
     68a:	03000493          	li	s1,48
  for(int ii = 0; ii < 5; ii++){
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[3];
    buf[0] = 't';
     68e:	07400b93          	li	s7,116
    buf[1] = ' ';
     692:	02000b13          	li	s6,32
    buf[2] = '0' + ii;
    if(send(2000, dst, dport, buf, 3) < 0){
     696:	fa840a93          	addi	s5,s0,-88
     69a:	4a0d                	li	s4,3
     69c:	6999                	lui	s3,0x6
     69e:	20b98993          	addi	s3,s3,523 # 620b <base+0x2ffb>
     6a2:	0a000937          	lui	s2,0xa000
     6a6:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffcff2>
     6aa:	7d000c13          	li	s8,2000
    buf[0] = 't';
     6ae:	fb740423          	sb	s7,-88(s0)
    buf[1] = ' ';
     6b2:	fb6404a3          	sb	s6,-87(s0)
    buf[2] = '0' + ii;
     6b6:	fa940523          	sb	s1,-86(s0)
    if(send(2000, dst, dport, buf, 3) < 0){
     6ba:	8752                	mv	a4,s4
     6bc:	86d6                	mv	a3,s5
     6be:	864e                	mv	a2,s3
     6c0:	85ca                	mv	a1,s2
     6c2:	8562                	mv	a0,s8
     6c4:	4f4010ef          	jal	1bb8 <send>
     6c8:	02054963          	bltz	a0,6fa <tx+0x88>
      printf("send() failed\n");
      return 0;
    }
    pause(10);
     6cc:	4529                	li	a0,10
     6ce:	4ca010ef          	jal	1b98 <pause>
  for(int ii = 0; ii < 5; ii++){
     6d2:	2485                	addiw	s1,s1,1
     6d4:	0ff4f493          	zext.b	s1,s1
     6d8:	03500793          	li	a5,53
     6dc:	fcf499e3          	bne	s1,a5,6ae <tx+0x3c>
  }

  // can't actually tell if the packets arrived.
  return 1;
     6e0:	4505                	li	a0,1
}
     6e2:	60e6                	ld	ra,88(sp)
     6e4:	6446                	ld	s0,80(sp)
     6e6:	64a6                	ld	s1,72(sp)
     6e8:	6906                	ld	s2,64(sp)
     6ea:	79e2                	ld	s3,56(sp)
     6ec:	7a42                	ld	s4,48(sp)
     6ee:	7aa2                	ld	s5,40(sp)
     6f0:	7b02                	ld	s6,32(sp)
     6f2:	6be2                	ld	s7,24(sp)
     6f4:	6c42                	ld	s8,16(sp)
     6f6:	6125                	addi	sp,sp,96
     6f8:	8082                	ret
      printf("send() failed\n");
     6fa:	00002517          	auipc	a0,0x2
     6fe:	cd650513          	addi	a0,a0,-810 # 23d0 <malloc+0x3d4>
     702:	043010ef          	jal	1f44 <printf>
      return 0;
     706:	4501                	li	a0,0
     708:	bfe9                	j	6e2 <tx+0x70>

000000000000070a <ping0>:
// expect a reply.
// nettest.py ping must be started first.
//
int
ping0()
{
     70a:	7171                	addi	sp,sp,-176
     70c:	f506                	sd	ra,168(sp)
     70e:	f122                	sd	s0,160(sp)
     710:	ed26                	sd	s1,152(sp)
     712:	e94a                	sd	s2,144(sp)
     714:	1900                	addi	s0,sp,176
  printf("ping0: starting\n");
     716:	00002517          	auipc	a0,0x2
     71a:	cca50513          	addi	a0,a0,-822 # 23e0 <malloc+0x3e4>
     71e:	027010ef          	jal	1f44 <printf>

  bind(2004);
     722:	7d400513          	li	a0,2004
     726:	482010ef          	jal	1ba8 <bind>
  
  uint32 dst = 0x0A000202; // 10.0.2.2
  int dport = NET_TESTS_PORT;
  char buf[5];
  memcpy(buf, "ping0", sizeof(buf));
     72a:	fd840493          	addi	s1,s0,-40
     72e:	4615                	li	a2,5
     730:	00002597          	auipc	a1,0x2
     734:	cc858593          	addi	a1,a1,-824 # 23f8 <malloc+0x3fc>
     738:	8526                	mv	a0,s1
     73a:	386010ef          	jal	1ac0 <memcpy>
  if(send(2004, dst, dport, buf, sizeof(buf)) < 0){
     73e:	4715                	li	a4,5
     740:	86a6                	mv	a3,s1
     742:	6619                	lui	a2,0x6
     744:	20b60613          	addi	a2,a2,523 # 620b <base+0x2ffb>
     748:	0a0005b7          	lui	a1,0xa000
     74c:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffcff2>
     750:	7d400513          	li	a0,2004
     754:	464010ef          	jal	1bb8 <send>
     758:	06054663          	bltz	a0,7c4 <ping0+0xba>
    printf("ping0: send() failed\n");
    return 0;
  }

  char ibuf[128];
  uint32 src = 0;
     75c:	f4042a23          	sw	zero,-172(s0)
  uint16 sport = 0;
     760:	f4041923          	sh	zero,-174(s0)
  memset(ibuf, 0, sizeof(ibuf));
     764:	f5840493          	addi	s1,s0,-168
     768:	08000613          	li	a2,128
     76c:	4581                	li	a1,0
     76e:	8526                	mv	a0,s1
     770:	15e010ef          	jal	18ce <memset>
  int cc = recv(2004, &src, &sport, ibuf, sizeof(ibuf)-1);
     774:	07f00713          	li	a4,127
     778:	86a6                	mv	a3,s1
     77a:	f5240613          	addi	a2,s0,-174
     77e:	f5440593          	addi	a1,s0,-172
     782:	7d400513          	li	a0,2004
     786:	43a010ef          	jal	1bc0 <recv>
     78a:	84aa                	mv	s1,a0
  if(cc < 0){
     78c:	04054a63          	bltz	a0,7e0 <ping0+0xd6>
    fprintf(2, "ping0: recv() failed\n");
    return 0;
  }
  
  if(src != 0x0A000202){ // 10.0.2.2
     790:	f5442583          	lw	a1,-172(s0)
     794:	0a0007b7          	lui	a5,0xa000
     798:	20278793          	addi	a5,a5,514 # a000202 <base+0x9ffcff2>
     79c:	04f59b63          	bne	a1,a5,7f2 <ping0+0xe8>
    printf("ping0: wrong ip src %x, expecting %x\n", src, 0x0A000202);
    return 0;
  }
  
  if(sport != NET_TESTS_PORT){
     7a0:	f5245583          	lhu	a1,-174(s0)
     7a4:	0005871b          	sext.w	a4,a1
     7a8:	6799                	lui	a5,0x6
     7aa:	20b78793          	addi	a5,a5,523 # 620b <base+0x2ffb>
     7ae:	04f70b63          	beq	a4,a5,804 <ping0+0xfa>
    printf("ping0: wrong sport %d, expecting %d\n", sport, NET_TESTS_PORT);
     7b2:	863e                	mv	a2,a5
     7b4:	00002517          	auipc	a0,0x2
     7b8:	ca450513          	addi	a0,a0,-860 # 2458 <malloc+0x45c>
     7bc:	788010ef          	jal	1f44 <printf>
    return 0;
     7c0:	4901                	li	s2,0
     7c2:	a801                	j	7d2 <ping0+0xc8>
    printf("ping0: send() failed\n");
     7c4:	00002517          	auipc	a0,0x2
     7c8:	c3c50513          	addi	a0,a0,-964 # 2400 <malloc+0x404>
     7cc:	778010ef          	jal	1f44 <printf>
    return 0;
     7d0:	4901                	li	s2,0
  printf("ping0: OK\n");

  unbind(2004);

  return 1;
}
     7d2:	854a                	mv	a0,s2
     7d4:	70aa                	ld	ra,168(sp)
     7d6:	740a                	ld	s0,160(sp)
     7d8:	64ea                	ld	s1,152(sp)
     7da:	694a                	ld	s2,144(sp)
     7dc:	614d                	addi	sp,sp,176
     7de:	8082                	ret
    fprintf(2, "ping0: recv() failed\n");
     7e0:	00002597          	auipc	a1,0x2
     7e4:	c3858593          	addi	a1,a1,-968 # 2418 <malloc+0x41c>
     7e8:	4509                	li	a0,2
     7ea:	730010ef          	jal	1f1a <fprintf>
    return 0;
     7ee:	4901                	li	s2,0
     7f0:	b7cd                	j	7d2 <ping0+0xc8>
    printf("ping0: wrong ip src %x, expecting %x\n", src, 0x0A000202);
     7f2:	863e                	mv	a2,a5
     7f4:	00002517          	auipc	a0,0x2
     7f8:	c3c50513          	addi	a0,a0,-964 # 2430 <malloc+0x434>
     7fc:	748010ef          	jal	1f44 <printf>
    return 0;
     800:	4901                	li	s2,0
     802:	bfc1                	j	7d2 <ping0+0xc8>
  if(memcmp(buf, ibuf, sizeof(buf)) != 0){
     804:	4615                	li	a2,5
     806:	f5840593          	addi	a1,s0,-168
     80a:	fd840513          	addi	a0,s0,-40
     80e:	274010ef          	jal	1a82 <memcmp>
     812:	892a                	mv	s2,a0
     814:	ed09                	bnez	a0,82e <ping0+0x124>
  if(cc != sizeof(buf)){
     816:	4795                	li	a5,5
     818:	02f48363          	beq	s1,a5,83e <ping0+0x134>
    printf("ping0: wrong length %d, expecting %ld\n", cc, sizeof(buf));
     81c:	863e                	mv	a2,a5
     81e:	85a6                	mv	a1,s1
     820:	00002517          	auipc	a0,0x2
     824:	c7850513          	addi	a0,a0,-904 # 2498 <malloc+0x49c>
     828:	71c010ef          	jal	1f44 <printf>
    return 0;
     82c:	b75d                	j	7d2 <ping0+0xc8>
    printf("ping0: wrong content\n");
     82e:	00002517          	auipc	a0,0x2
     832:	c5250513          	addi	a0,a0,-942 # 2480 <malloc+0x484>
     836:	70e010ef          	jal	1f44 <printf>
    return 0;
     83a:	4901                	li	s2,0
     83c:	bf59                	j	7d2 <ping0+0xc8>
  printf("ping0: OK\n");
     83e:	00002517          	auipc	a0,0x2
     842:	c8250513          	addi	a0,a0,-894 # 24c0 <malloc+0x4c4>
     846:	6fe010ef          	jal	1f44 <printf>
  unbind(2004);
     84a:	7d400513          	li	a0,2004
     84e:	362010ef          	jal	1bb0 <unbind>
  return 1;
     852:	4905                	li	s2,1
     854:	bfbd                	j	7d2 <ping0+0xc8>

0000000000000856 <ping1>:
// expect a reply to each.
// nettest.py ping must be started first.
//
int
ping1()
{
     856:	7151                	addi	sp,sp,-240
     858:	f586                	sd	ra,232(sp)
     85a:	f1a2                	sd	s0,224(sp)
     85c:	eda6                	sd	s1,216(sp)
     85e:	e9ca                	sd	s2,208(sp)
     860:	e5ce                	sd	s3,200(sp)
     862:	e1d2                	sd	s4,192(sp)
     864:	fd56                	sd	s5,184(sp)
     866:	f95a                	sd	s6,176(sp)
     868:	f55e                	sd	s7,168(sp)
     86a:	f162                	sd	s8,160(sp)
     86c:	ed66                	sd	s9,152(sp)
     86e:	1980                	addi	s0,sp,240
  printf("ping1: starting\n");
     870:	00002517          	auipc	a0,0x2
     874:	c6050513          	addi	a0,a0,-928 # 24d0 <malloc+0x4d4>
     878:	6cc010ef          	jal	1f44 <printf>

  bind(2005);
     87c:	7d500513          	li	a0,2005
     880:	328010ef          	jal	1ba8 <bind>
     884:	03000493          	li	s1,48
  
  for(int ii = 0; ii < 20; ii++){
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[3];
    buf[0] = 'p';
     888:	07000c93          	li	s9,112
    buf[1] = ' ';
     88c:	02000c13          	li	s8,32
    buf[2] = '0' + ii;
    if(send(2005, dst, dport, buf, 3) < 0){
     890:	f1840b93          	addi	s7,s0,-232
     894:	498d                	li	s3,3
     896:	6a99                	lui	s5,0x6
     898:	20ba8a93          	addi	s5,s5,523 # 620b <base+0x2ffb>
     89c:	0a000a37          	lui	s4,0xa000
     8a0:	202a0a13          	addi	s4,s4,514 # a000202 <base+0x9ffcff2>
     8a4:	7d500b13          	li	s6,2005
    buf[0] = 'p';
     8a8:	f1940c23          	sb	s9,-232(s0)
    buf[1] = ' ';
     8ac:	f1840ca3          	sb	s8,-231(s0)
    buf[2] = '0' + ii;
     8b0:	f0940d23          	sb	s1,-230(s0)
    if(send(2005, dst, dport, buf, 3) < 0){
     8b4:	874e                	mv	a4,s3
     8b6:	86de                	mv	a3,s7
     8b8:	8656                	mv	a2,s5
     8ba:	85d2                	mv	a1,s4
     8bc:	855a                	mv	a0,s6
     8be:	2fa010ef          	jal	1bb8 <send>
     8c2:	08054163          	bltz	a0,944 <ping1+0xee>
      printf("ping1: send() failed\n");
      return 0;
    }

    char ibuf[128];
    uint32 src = 0;
     8c6:	f0042e23          	sw	zero,-228(s0)
    uint16 sport = 0;
     8ca:	f0041b23          	sh	zero,-234(s0)
    memset(ibuf, 0, sizeof(ibuf));
     8ce:	f2040913          	addi	s2,s0,-224
     8d2:	08000613          	li	a2,128
     8d6:	4581                	li	a1,0
     8d8:	854a                	mv	a0,s2
     8da:	7f5000ef          	jal	18ce <memset>
    int cc = recv(2005, &src, &sport, ibuf, sizeof(ibuf)-1);
     8de:	07f00713          	li	a4,127
     8e2:	86ca                	mv	a3,s2
     8e4:	f1640613          	addi	a2,s0,-234
     8e8:	f1c40593          	addi	a1,s0,-228
     8ec:	855a                	mv	a0,s6
     8ee:	2d2010ef          	jal	1bc0 <recv>
     8f2:	892a                	mv	s2,a0
    if(cc < 0){
     8f4:	06054c63          	bltz	a0,96c <ping1+0x116>
      fprintf(2, "ping1: recv() failed\n");
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
     8f8:	f1c42583          	lw	a1,-228(s0)
     8fc:	09459063          	bne	a1,s4,97c <ping1+0x126>
      printf("ping1: wrong ip src %x, expecting %x\n", src, 0x0A000202);
      return 0;
    }

    if(sport != NET_TESTS_PORT){
     900:	f1645583          	lhu	a1,-234(s0)
     904:	0005879b          	sext.w	a5,a1
     908:	09579563          	bne	a5,s5,992 <ping1+0x13c>
      printf("ping1: wrong sport %d, expecting %d\n", sport, NET_TESTS_PORT);
      return 0;
    }

    if(memcmp(buf, ibuf, 3) != 0){
     90c:	864e                	mv	a2,s3
     90e:	f2040593          	addi	a1,s0,-224
     912:	855e                	mv	a0,s7
     914:	16e010ef          	jal	1a82 <memcmp>
     918:	e559                	bnez	a0,9a6 <ping1+0x150>
      printf("ping1: wrong content\n");
      return 0;
    }

    if(cc != 3){
     91a:	09391d63          	bne	s2,s3,9b4 <ping1+0x15e>
  for(int ii = 0; ii < 20; ii++){
     91e:	2485                	addiw	s1,s1,1
     920:	0ff4f493          	zext.b	s1,s1
     924:	04400793          	li	a5,68
     928:	f8f490e3          	bne	s1,a5,8a8 <ping1+0x52>
      printf("ping1: wrong length %d, expecting 3\n", cc);
      return 0;
    }
  }

  printf("ping1: OK\n");
     92c:	00002517          	auipc	a0,0x2
     930:	c7c50513          	addi	a0,a0,-900 # 25a8 <malloc+0x5ac>
     934:	610010ef          	jal	1f44 <printf>

  bind(2005);
     938:	7d500513          	li	a0,2005
     93c:	26c010ef          	jal	1ba8 <bind>

  return 1;
     940:	4505                	li	a0,1
     942:	a801                	j	952 <ping1+0xfc>
      printf("ping1: send() failed\n");
     944:	00002517          	auipc	a0,0x2
     948:	ba450513          	addi	a0,a0,-1116 # 24e8 <malloc+0x4ec>
     94c:	5f8010ef          	jal	1f44 <printf>
      return 0;
     950:	4501                	li	a0,0
}
     952:	70ae                	ld	ra,232(sp)
     954:	740e                	ld	s0,224(sp)
     956:	64ee                	ld	s1,216(sp)
     958:	694e                	ld	s2,208(sp)
     95a:	69ae                	ld	s3,200(sp)
     95c:	6a0e                	ld	s4,192(sp)
     95e:	7aea                	ld	s5,184(sp)
     960:	7b4a                	ld	s6,176(sp)
     962:	7baa                	ld	s7,168(sp)
     964:	7c0a                	ld	s8,160(sp)
     966:	6cea                	ld	s9,152(sp)
     968:	616d                	addi	sp,sp,240
     96a:	8082                	ret
      fprintf(2, "ping1: recv() failed\n");
     96c:	00002597          	auipc	a1,0x2
     970:	b9458593          	addi	a1,a1,-1132 # 2500 <malloc+0x504>
     974:	4509                	li	a0,2
     976:	5a4010ef          	jal	1f1a <fprintf>
      return 0;
     97a:	bfd9                	j	950 <ping1+0xfa>
      printf("ping1: wrong ip src %x, expecting %x\n", src, 0x0A000202);
     97c:	0a000637          	lui	a2,0xa000
     980:	20260613          	addi	a2,a2,514 # a000202 <base+0x9ffcff2>
     984:	00002517          	auipc	a0,0x2
     988:	b9450513          	addi	a0,a0,-1132 # 2518 <malloc+0x51c>
     98c:	5b8010ef          	jal	1f44 <printf>
      return 0;
     990:	b7c1                	j	950 <ping1+0xfa>
      printf("ping1: wrong sport %d, expecting %d\n", sport, NET_TESTS_PORT);
     992:	6619                	lui	a2,0x6
     994:	20b60613          	addi	a2,a2,523 # 620b <base+0x2ffb>
     998:	00002517          	auipc	a0,0x2
     99c:	ba850513          	addi	a0,a0,-1112 # 2540 <malloc+0x544>
     9a0:	5a4010ef          	jal	1f44 <printf>
      return 0;
     9a4:	b775                	j	950 <ping1+0xfa>
      printf("ping1: wrong content\n");
     9a6:	00002517          	auipc	a0,0x2
     9aa:	bc250513          	addi	a0,a0,-1086 # 2568 <malloc+0x56c>
     9ae:	596010ef          	jal	1f44 <printf>
      return 0;
     9b2:	bf79                	j	950 <ping1+0xfa>
      printf("ping1: wrong length %d, expecting 3\n", cc);
     9b4:	85ca                	mv	a1,s2
     9b6:	00002517          	auipc	a0,0x2
     9ba:	bca50513          	addi	a0,a0,-1078 # 2580 <malloc+0x584>
     9be:	586010ef          	jal	1f44 <printf>
      return 0;
     9c2:	b779                	j	950 <ping1+0xfa>

00000000000009c4 <ping2>:
// expect a reply to each to appear on the correct port.
// nettest.py ping must be started first.
//
int
ping2()
{
     9c4:	7111                	addi	sp,sp,-256
     9c6:	fd86                	sd	ra,248(sp)
     9c8:	f9a2                	sd	s0,240(sp)
     9ca:	f5a6                	sd	s1,232(sp)
     9cc:	f1ca                	sd	s2,224(sp)
     9ce:	edce                	sd	s3,216(sp)
     9d0:	e9d2                	sd	s4,208(sp)
     9d2:	e5d6                	sd	s5,200(sp)
     9d4:	e1da                	sd	s6,192(sp)
     9d6:	fd5e                	sd	s7,184(sp)
     9d8:	f962                	sd	s8,176(sp)
     9da:	0200                	addi	s0,sp,256
  printf("ping2: starting\n");
     9dc:	00002517          	auipc	a0,0x2
     9e0:	bdc50513          	addi	a0,a0,-1060 # 25b8 <malloc+0x5bc>
     9e4:	560010ef          	jal	1f44 <printf>
  
  bind(2006);
     9e8:	7d600513          	li	a0,2006
     9ec:	1bc010ef          	jal	1ba8 <bind>
  bind(2007);
     9f0:	7d700513          	li	a0,2007
     9f4:	1b4010ef          	jal	1ba8 <bind>
     9f8:	06100493          	li	s1,97
  for(int ii = 0; ii < 5; ii++){
    for(int port = 2006; port <= 2007; port++){
      uint32 dst = 0x0A000202; // 10.0.2.2
      int dport = NET_TESTS_PORT;
      char buf[4];
      buf[0] = 'p';
     9fc:	07000c13          	li	s8,112
      buf[1] = ' ';
     a00:	02000b93          	li	s7,32
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
      buf[3] = '!';
     a04:	02100b13          	li	s6,33
      if(send(port, dst, dport, buf, 4) < 0){
     a08:	f1040a93          	addi	s5,s0,-240
     a0c:	4a11                	li	s4,4
     a0e:	6999                	lui	s3,0x6
     a10:	20b98993          	addi	s3,s3,523 # 620b <base+0x2ffb>
     a14:	0a000937          	lui	s2,0xa000
     a18:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffcff2>
      buf[0] = 'p';
     a1c:	f1840823          	sb	s8,-240(s0)
      buf[1] = ' ';
     a20:	f17408a3          	sb	s7,-239(s0)
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     a24:	f0940923          	sb	s1,-238(s0)
      buf[3] = '!';
     a28:	f16409a3          	sb	s6,-237(s0)
      if(send(port, dst, dport, buf, 4) < 0){
     a2c:	8752                	mv	a4,s4
     a2e:	86d6                	mv	a3,s5
     a30:	864e                	mv	a2,s3
     a32:	85ca                	mv	a1,s2
     a34:	7d600513          	li	a0,2006
     a38:	180010ef          	jal	1bb8 <send>
     a3c:	12054f63          	bltz	a0,b7a <ping2+0x1b6>
      buf[0] = 'p';
     a40:	f1840823          	sb	s8,-240(s0)
      buf[1] = ' ';
     a44:	f17408a3          	sb	s7,-239(s0)
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     a48:	fe04879b          	addiw	a5,s1,-32
     a4c:	f0f40923          	sb	a5,-238(s0)
      buf[3] = '!';
     a50:	f16409a3          	sb	s6,-237(s0)
      if(send(port, dst, dport, buf, 4) < 0){
     a54:	8752                	mv	a4,s4
     a56:	86d6                	mv	a3,s5
     a58:	864e                	mv	a2,s3
     a5a:	85ca                	mv	a1,s2
     a5c:	7d700513          	li	a0,2007
     a60:	158010ef          	jal	1bb8 <send>
     a64:	10054b63          	bltz	a0,b7a <ping2+0x1b6>
  for(int ii = 0; ii < 5; ii++){
     a68:	2485                	addiw	s1,s1,1
     a6a:	0ff4f493          	zext.b	s1,s1
     a6e:	06600793          	li	a5,102
     a72:	faf495e3          	bne	s1,a5,a1c <ping2+0x58>
     a76:	f566                	sd	s9,168(sp)
     a78:	f16a                	sd	s10,160(sp)
     a7a:	ed6e                	sd	s11,152(sp)
        return 0;
      }
    }
  }

  for(int port = 2006; port <= 2007; port++){
     a7c:	7d600a13          	li	s4,2006
     a80:	04100d93          	li	s11,65
    for(int ii = 0; ii < 5; ii++){
      char ibuf[128];
      uint32 src = 0;
      uint16 sport = 0;
      memset(ibuf, 0, sizeof(ibuf));
     a84:	f1040913          	addi	s2,s0,-240
     a88:	08000c93          	li	s9,128
      int cc = recv(port, &src, &sport, ibuf, sizeof(ibuf)-1);
     a8c:	f0640c13          	addi	s8,s0,-250
     a90:	f0c40b93          	addi	s7,s0,-244
      if(cc < 0){
        fprintf(2, "ping2: recv() failed\n");
        return 0;
      }
      
      if(src != 0x0A000202){ // 10.0.2.2
     a94:	0a0009b7          	lui	s3,0xa000
     a98:	20298993          	addi	s3,s3,514 # a000202 <base+0x9ffcff2>
    for(int ii = 0; ii < 5; ii++){
     a9c:	82aa0793          	addi	a5,s4,-2006
     aa0:	84ee                	mv	s1,s11
     aa2:	e399                	bnez	a5,aa8 <ping2+0xe4>
     aa4:	06100493          	li	s1,97
     aa8:	0ff4f493          	zext.b	s1,s1
     aac:	00548d13          	addi	s10,s1,5
      int cc = recv(port, &src, &sport, ibuf, sizeof(ibuf)-1);
     ab0:	030a1b13          	slli	s6,s4,0x30
     ab4:	030b5b13          	srli	s6,s6,0x30
     ab8:	07f00a93          	li	s5,127
      uint32 src = 0;
     abc:	f0042623          	sw	zero,-244(s0)
      uint16 sport = 0;
     ac0:	f0041323          	sh	zero,-250(s0)
      memset(ibuf, 0, sizeof(ibuf));
     ac4:	8666                	mv	a2,s9
     ac6:	4581                	li	a1,0
     ac8:	854a                	mv	a0,s2
     aca:	605000ef          	jal	18ce <memset>
      int cc = recv(port, &src, &sport, ibuf, sizeof(ibuf)-1);
     ace:	8756                	mv	a4,s5
     ad0:	86ca                	mv	a3,s2
     ad2:	8662                	mv	a2,s8
     ad4:	85de                	mv	a1,s7
     ad6:	855a                	mv	a0,s6
     ad8:	0e8010ef          	jal	1bc0 <recv>
      if(cc < 0){
     adc:	0a054763          	bltz	a0,b8a <ping2+0x1c6>
      if(src != 0x0A000202){ // 10.0.2.2
     ae0:	f0c42583          	lw	a1,-244(s0)
     ae4:	0b359f63          	bne	a1,s3,ba2 <ping2+0x1de>
        printf("ping2: wrong ip src %x\n", src);
        return 0;
      }
      
      if(sport != NET_TESTS_PORT){
     ae8:	f0645583          	lhu	a1,-250(s0)
     aec:	0005871b          	sext.w	a4,a1
     af0:	6799                	lui	a5,0x6
     af2:	20b78793          	addi	a5,a5,523 # 620b <base+0x2ffb>
     af6:	0af71d63          	bne	a4,a5,bb0 <ping2+0x1ec>
        printf("ping2: wrong sport %d\n", sport);
        return 0;
      }
      
      if(cc != 4){
     afa:	4791                	li	a5,4
     afc:	0cf51163          	bne	a0,a5,bbe <ping2+0x1fa>
      }

      // printf("port=%d ii=%d: %c%c%c\n", port, ii, ibuf[0], ibuf[1], ibuf[2]);

      char buf[4];
      buf[0] = 'p';
     b00:	07000793          	li	a5,112
     b04:	f0f40423          	sb	a5,-248(s0)
      buf[1] = ' ';
     b08:	02000793          	li	a5,32
     b0c:	f0f404a3          	sb	a5,-247(s0)
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     b10:	f0940523          	sb	s1,-246(s0)
      buf[3] = '!';
     b14:	02100793          	li	a5,33
     b18:	f0f405a3          	sb	a5,-245(s0)

      if(memcmp(buf, ibuf, 3) != 0){
     b1c:	460d                	li	a2,3
     b1e:	85ca                	mv	a1,s2
     b20:	f0840513          	addi	a0,s0,-248
     b24:	75f000ef          	jal	1a82 <memcmp>
     b28:	e15d                	bnez	a0,bce <ping2+0x20a>
    for(int ii = 0; ii < 5; ii++){
     b2a:	2485                	addiw	s1,s1,1
     b2c:	0ff4f493          	zext.b	s1,s1
     b30:	f9a496e3          	bne	s1,s10,abc <ping2+0xf8>
  for(int port = 2006; port <= 2007; port++){
     b34:	2a05                	addiw	s4,s4,1
     b36:	7d800793          	li	a5,2008
     b3a:	f6fa11e3          	bne	s4,a5,a9c <ping2+0xd8>
        return 0;
      }
    }
  }

  printf("ping2: OK\n");
     b3e:	00002517          	auipc	a0,0x2
     b42:	b2250513          	addi	a0,a0,-1246 # 2660 <malloc+0x664>
     b46:	3fe010ef          	jal	1f44 <printf>

  unbind(2006);
     b4a:	7d600513          	li	a0,2006
     b4e:	062010ef          	jal	1bb0 <unbind>
  unbind(2007);
     b52:	7d700513          	li	a0,2007
     b56:	05a010ef          	jal	1bb0 <unbind>

  return 1;
     b5a:	4505                	li	a0,1
     b5c:	7caa                	ld	s9,168(sp)
     b5e:	7d0a                	ld	s10,160(sp)
     b60:	6dea                	ld	s11,152(sp)
}
     b62:	70ee                	ld	ra,248(sp)
     b64:	744e                	ld	s0,240(sp)
     b66:	74ae                	ld	s1,232(sp)
     b68:	790e                	ld	s2,224(sp)
     b6a:	69ee                	ld	s3,216(sp)
     b6c:	6a4e                	ld	s4,208(sp)
     b6e:	6aae                	ld	s5,200(sp)
     b70:	6b0e                	ld	s6,192(sp)
     b72:	7bea                	ld	s7,184(sp)
     b74:	7c4a                	ld	s8,176(sp)
     b76:	6111                	addi	sp,sp,256
     b78:	8082                	ret
        printf("ping2: send() failed\n");
     b7a:	00002517          	auipc	a0,0x2
     b7e:	a5650513          	addi	a0,a0,-1450 # 25d0 <malloc+0x5d4>
     b82:	3c2010ef          	jal	1f44 <printf>
        return 0;
     b86:	4501                	li	a0,0
     b88:	bfe9                	j	b62 <ping2+0x19e>
        fprintf(2, "ping2: recv() failed\n");
     b8a:	00002597          	auipc	a1,0x2
     b8e:	a5e58593          	addi	a1,a1,-1442 # 25e8 <malloc+0x5ec>
     b92:	4509                	li	a0,2
     b94:	386010ef          	jal	1f1a <fprintf>
        return 0;
     b98:	4501                	li	a0,0
     b9a:	7caa                	ld	s9,168(sp)
     b9c:	7d0a                	ld	s10,160(sp)
     b9e:	6dea                	ld	s11,152(sp)
     ba0:	b7c9                	j	b62 <ping2+0x19e>
        printf("ping2: wrong ip src %x\n", src);
     ba2:	00002517          	auipc	a0,0x2
     ba6:	a5e50513          	addi	a0,a0,-1442 # 2600 <malloc+0x604>
     baa:	39a010ef          	jal	1f44 <printf>
        return 0;
     bae:	b7ed                	j	b98 <ping2+0x1d4>
        printf("ping2: wrong sport %d\n", sport);
     bb0:	00002517          	auipc	a0,0x2
     bb4:	a6850513          	addi	a0,a0,-1432 # 2618 <malloc+0x61c>
     bb8:	38c010ef          	jal	1f44 <printf>
        return 0;
     bbc:	bff1                	j	b98 <ping2+0x1d4>
        printf("ping2: wrong length %d\n", cc);
     bbe:	85aa                	mv	a1,a0
     bc0:	00002517          	auipc	a0,0x2
     bc4:	a7050513          	addi	a0,a0,-1424 # 2630 <malloc+0x634>
     bc8:	37c010ef          	jal	1f44 <printf>
        return 0;
     bcc:	b7f1                	j	b98 <ping2+0x1d4>
        printf("ping2: wrong content\n");
     bce:	00002517          	auipc	a0,0x2
     bd2:	a7a50513          	addi	a0,a0,-1414 # 2648 <malloc+0x64c>
     bd6:	36e010ef          	jal	1f44 <printf>
        return 0;
     bda:	bf7d                	j	b98 <ping2+0x1d4>

0000000000000bdc <ping3>:
// check that port 2008 had a finite queue length (dropped some).
// nettest.py ping must be started first.
//
int
ping3()
{
     bdc:	7111                	addi	sp,sp,-256
     bde:	fd86                	sd	ra,248(sp)
     be0:	f9a2                	sd	s0,240(sp)
     be2:	f5a6                	sd	s1,232(sp)
     be4:	0200                	addi	s0,sp,256
  printf("ping3: starting\n");
     be6:	00002517          	auipc	a0,0x2
     bea:	a8a50513          	addi	a0,a0,-1398 # 2670 <malloc+0x674>
     bee:	356010ef          	jal	1f44 <printf>
  
  bind(2008);
     bf2:	7d800513          	li	a0,2008
     bf6:	7b3000ef          	jal	1ba8 <bind>
  bind(2009);
     bfa:	7d900513          	li	a0,2009
     bfe:	7ab000ef          	jal	1ba8 <bind>
  //
  {
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     c02:	07000793          	li	a5,112
     c06:	f0f40c23          	sb	a5,-232(s0)
    buf[1] = ' ';
     c0a:	02000793          	li	a5,32
     c0e:	f0f40ca3          	sb	a5,-231(s0)
    buf[2] = 'A';
     c12:	04100793          	li	a5,65
     c16:	f0f40d23          	sb	a5,-230(s0)
    buf[3] = '!';
     c1a:	02100793          	li	a5,33
     c1e:	f0f40da3          	sb	a5,-229(s0)
    if(send(2009, dst, dport, buf, 4) < 0){
     c22:	4711                	li	a4,4
     c24:	f1840693          	addi	a3,s0,-232
     c28:	6619                	lui	a2,0x6
     c2a:	20b60613          	addi	a2,a2,523 # 620b <base+0x2ffb>
     c2e:	0a0005b7          	lui	a1,0xa000
     c32:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffcff2>
     c36:	7d900513          	li	a0,2009
     c3a:	77f000ef          	jal	1bb8 <send>
     c3e:	1e054763          	bltz	a0,e2c <ping3+0x250>
     c42:	f1ca                	sd	s2,224(sp)
     c44:	edce                	sd	s3,216(sp)
     c46:	e9d2                	sd	s4,208(sp)
     c48:	e5d6                	sd	s5,200(sp)
     c4a:	e1da                	sd	s6,192(sp)
     c4c:	fd5e                	sd	s7,184(sp)
     c4e:	f962                	sd	s8,176(sp)
      printf("ping3: send() failed\n");
      return 0;
    }
  }
  pause(1);
     c50:	4505                	li	a0,1
     c52:	747000ef          	jal	1b98 <pause>
  //
  // send so many packets from 2008 and 2010 that some of the
  // replies must be dropped due to the requirement
  // for finite maximum queueing.
  //
  for(int ii = 0; ii < 257; ii++){
     c56:	4481                	li	s1,0
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     c58:	07000c13          	li	s8,112
    buf[1] = ' ';
     c5c:	02000b93          	li	s7,32
    buf[2] = 'a' + ii;
    buf[3] = '!';
     c60:	02100b13          	li	s6,33
    int port = 2008 + (ii % 2) * 2;
    if(send(port, dst, dport, buf, 4) < 0){
     c64:	f1840a93          	addi	s5,s0,-232
     c68:	4a11                	li	s4,4
     c6a:	6999                	lui	s3,0x6
     c6c:	20b98993          	addi	s3,s3,523 # 620b <base+0x2ffb>
     c70:	0a000937          	lui	s2,0xa000
     c74:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffcff2>
    buf[0] = 'p';
     c78:	f1840c23          	sb	s8,-232(s0)
    buf[1] = ' ';
     c7c:	f1740ca3          	sb	s7,-231(s0)
    buf[2] = 'a' + ii;
     c80:	0614879b          	addiw	a5,s1,97
     c84:	f0f40d23          	sb	a5,-230(s0)
    buf[3] = '!';
     c88:	f1640da3          	sb	s6,-229(s0)
    int port = 2008 + (ii % 2) * 2;
     c8c:	41f4d79b          	sraiw	a5,s1,0x1f
     c90:	01f7d79b          	srliw	a5,a5,0x1f
     c94:	0097853b          	addw	a0,a5,s1
     c98:	8905                	andi	a0,a0,1
     c9a:	9d1d                	subw	a0,a0,a5
     c9c:	3ec5051b          	addiw	a0,a0,1004
     ca0:	0015151b          	slliw	a0,a0,0x1
    if(send(port, dst, dport, buf, 4) < 0){
     ca4:	1542                	slli	a0,a0,0x30
     ca6:	9141                	srli	a0,a0,0x30
     ca8:	8752                	mv	a4,s4
     caa:	86d6                	mv	a3,s5
     cac:	864e                	mv	a2,s3
     cae:	85ca                	mv	a1,s2
     cb0:	709000ef          	jal	1bb8 <send>
     cb4:	18054463          	bltz	a0,e3c <ping3+0x260>
  for(int ii = 0; ii < 257; ii++){
     cb8:	2485                	addiw	s1,s1,1
     cba:	10100793          	li	a5,257
     cbe:	faf49de3          	bne	s1,a5,c78 <ping3+0x9c>
      printf("ping3: send() failed\n");
      return 0;
    }
  }
  pause(1);
     cc2:	4505                	li	a0,1
     cc4:	6d5000ef          	jal	1b98 <pause>
  //
  {
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     cc8:	07000793          	li	a5,112
     ccc:	f0f40c23          	sb	a5,-232(s0)
    buf[1] = ' ';
     cd0:	02000793          	li	a5,32
     cd4:	f0f40ca3          	sb	a5,-231(s0)
    buf[2] = 'B';
     cd8:	04200793          	li	a5,66
     cdc:	f0f40d23          	sb	a5,-230(s0)
    buf[3] = '!';
     ce0:	02100793          	li	a5,33
     ce4:	f0f40da3          	sb	a5,-229(s0)
    if(send(2009, dst, dport, buf, 4) < 0){
     ce8:	4711                	li	a4,4
     cea:	f1840693          	addi	a3,s0,-232
     cee:	6619                	lui	a2,0x6
     cf0:	20b60613          	addi	a2,a2,523 # 620b <base+0x2ffb>
     cf4:	0a0005b7          	lui	a1,0xa000
     cf8:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffcff2>
     cfc:	7d900513          	li	a0,2009
     d00:	6b9000ef          	jal	1bb8 <send>
     d04:	04100913          	li	s2,65
     d08:	14054e63          	bltz	a0,e64 <ping3+0x288>
     d0c:	f566                	sd	s9,168(sp)
  //
  for(int ii = 0; ii < 2; ii++){
    char ibuf[128];
    uint32 src = 0;
    uint16 sport = 0;
    memset(ibuf, 0, sizeof(ibuf));
     d0e:	f1840993          	addi	s3,s0,-232
     d12:	08000c93          	li	s9,128
    int cc = recv(2009, &src, &sport, ibuf, sizeof(ibuf)-1);
     d16:	f0e40c13          	addi	s8,s0,-242
     d1a:	f1440b93          	addi	s7,s0,-236
     d1e:	07f00b13          	li	s6,127
     d22:	7d900a93          	li	s5,2009
    if(cc < 0){
      fprintf(2, "ping3: recv() failed\n");
      return 0;
    }
    
    if(src != 0x0A000202){ // 10.0.2.2
     d26:	0a000a37          	lui	s4,0xa000
     d2a:	202a0a13          	addi	s4,s4,514 # a000202 <base+0x9ffcff2>
    uint32 src = 0;
     d2e:	f0042a23          	sw	zero,-236(s0)
    uint16 sport = 0;
     d32:	f0041723          	sh	zero,-242(s0)
    memset(ibuf, 0, sizeof(ibuf));
     d36:	8666                	mv	a2,s9
     d38:	4581                	li	a1,0
     d3a:	854e                	mv	a0,s3
     d3c:	393000ef          	jal	18ce <memset>
    int cc = recv(2009, &src, &sport, ibuf, sizeof(ibuf)-1);
     d40:	875a                	mv	a4,s6
     d42:	86ce                	mv	a3,s3
     d44:	8662                	mv	a2,s8
     d46:	85de                	mv	a1,s7
     d48:	8556                	mv	a0,s5
     d4a:	677000ef          	jal	1bc0 <recv>
    if(cc < 0){
     d4e:	12054a63          	bltz	a0,e82 <ping3+0x2a6>
    if(src != 0x0A000202){ // 10.0.2.2
     d52:	f1442583          	lw	a1,-236(s0)
     d56:	15459763          	bne	a1,s4,ea4 <ping3+0x2c8>
      printf("ping3: wrong ip src %x\n", src);
      return 0;
    }
    
    if(sport != NET_TESTS_PORT){
     d5a:	f0e45583          	lhu	a1,-242(s0)
     d5e:	0005871b          	sext.w	a4,a1
     d62:	6799                	lui	a5,0x6
     d64:	20b78793          	addi	a5,a5,523 # 620b <base+0x2ffb>
     d68:	14f71563          	bne	a4,a5,eb2 <ping3+0x2d6>
      printf("ping3: wrong sport %d\n", sport);
      return 0;
    }
      
    if(cc != 4){
     d6c:	4791                	li	a5,4
     d6e:	14f51963          	bne	a0,a5,ec0 <ping3+0x2e4>
    }

    // printf("port=%d ii=%d: %c%c%c\n", port, ii, ibuf[0], ibuf[1], ibuf[2]);

    char buf[4];
    buf[0] = 'p';
     d72:	07000793          	li	a5,112
     d76:	f0f40823          	sb	a5,-240(s0)
    buf[1] = ' ';
     d7a:	02000793          	li	a5,32
     d7e:	f0f408a3          	sb	a5,-239(s0)
    buf[2] = 'A' + ii;
     d82:	f1240923          	sb	s2,-238(s0)
    buf[3] = '!';
     d86:	02100793          	li	a5,33
     d8a:	f0f409a3          	sb	a5,-237(s0)
    
    if(memcmp(buf, ibuf, 3) != 0){
     d8e:	460d                	li	a2,3
     d90:	85ce                	mv	a1,s3
     d92:	f1040513          	addi	a0,s0,-240
     d96:	4ed000ef          	jal	1a82 <memcmp>
     d9a:	84aa                	mv	s1,a0
     d9c:	12051a63          	bnez	a0,ed0 <ping3+0x2f4>
  for(int ii = 0; ii < 2; ii++){
     da0:	2905                	addiw	s2,s2,1
     da2:	0ff97913          	zext.b	s2,s2
     da6:	04300793          	li	a5,67
     daa:	f8f912e3          	bne	s2,a5,d2e <ping3+0x152>

  //
  // now count how many replies were queued for 2008.
  //
  int fds[2];
  pipe(fds);
     dae:	f9840513          	addi	a0,s0,-104
     db2:	567000ef          	jal	1b18 <pipe>
  int pid = fork();
     db6:	54b000ef          	jal	1b00 <fork>
     dba:	89aa                	mv	s3,a0
  if(pid == 0){
     dbc:	12050163          	beqz	a0,ede <ping3+0x302>
      }
      write(fds[1], "x", 1);
    }
    exit(0);
  }
  close(fds[1]);
     dc0:	f9c42503          	lw	a0,-100(s0)
     dc4:	56d000ef          	jal	1b30 <close>

  pause(5);
     dc8:	4515                	li	a0,5
     dca:	5cf000ef          	jal	1b98 <pause>
  static char nbuf[512];
  int n = read(fds[0], nbuf, sizeof(nbuf));
     dce:	20000613          	li	a2,512
     dd2:	00002597          	auipc	a1,0x2
     dd6:	23e58593          	addi	a1,a1,574 # 3010 <nbuf.0>
     dda:	f9842503          	lw	a0,-104(s0)
     dde:	543000ef          	jal	1b20 <read>
     de2:	892a                	mv	s2,a0
  close(fds[0]);
     de4:	f9842503          	lw	a0,-104(s0)
     de8:	549000ef          	jal	1b30 <close>
  kill(pid);
     dec:	854e                	mv	a0,s3
     dee:	54b000ef          	jal	1b38 <kill>

  n -= 1; // the ":"
     df2:	fff9059b          	addiw	a1,s2,-1
  if(n > 16){
     df6:	47c1                	li	a5,16
     df8:	16b7c263          	blt	a5,a1,f5c <ping3+0x380>
    printf("ping3: too many packets (%d) were queued on a UDP port\n", n);
    return 0;
  }

  printf("ping3: OK\n");
     dfc:	00002517          	auipc	a0,0x2
     e00:	97c50513          	addi	a0,a0,-1668 # 2778 <malloc+0x77c>
     e04:	140010ef          	jal	1f44 <printf>

  unbind(2008);
     e08:	7d800513          	li	a0,2008
     e0c:	5a5000ef          	jal	1bb0 <unbind>
  unbind(2009);
     e10:	7d900513          	li	a0,2009
     e14:	59d000ef          	jal	1bb0 <unbind>

  return 1;
     e18:	4485                	li	s1,1
     e1a:	790e                	ld	s2,224(sp)
     e1c:	69ee                	ld	s3,216(sp)
     e1e:	6a4e                	ld	s4,208(sp)
     e20:	6aae                	ld	s5,200(sp)
     e22:	6b0e                	ld	s6,192(sp)
     e24:	7bea                	ld	s7,184(sp)
     e26:	7c4a                	ld	s8,176(sp)
     e28:	7caa                	ld	s9,168(sp)
     e2a:	a03d                	j	e58 <ping3+0x27c>
      printf("ping3: send() failed\n");
     e2c:	00002517          	auipc	a0,0x2
     e30:	85c50513          	addi	a0,a0,-1956 # 2688 <malloc+0x68c>
     e34:	110010ef          	jal	1f44 <printf>
      return 0;
     e38:	4481                	li	s1,0
     e3a:	a839                	j	e58 <ping3+0x27c>
      printf("ping3: send() failed\n");
     e3c:	00002517          	auipc	a0,0x2
     e40:	84c50513          	addi	a0,a0,-1972 # 2688 <malloc+0x68c>
     e44:	100010ef          	jal	1f44 <printf>
      return 0;
     e48:	4481                	li	s1,0
     e4a:	790e                	ld	s2,224(sp)
     e4c:	69ee                	ld	s3,216(sp)
     e4e:	6a4e                	ld	s4,208(sp)
     e50:	6aae                	ld	s5,200(sp)
     e52:	6b0e                	ld	s6,192(sp)
     e54:	7bea                	ld	s7,184(sp)
     e56:	7c4a                	ld	s8,176(sp)
}
     e58:	8526                	mv	a0,s1
     e5a:	70ee                	ld	ra,248(sp)
     e5c:	744e                	ld	s0,240(sp)
     e5e:	74ae                	ld	s1,232(sp)
     e60:	6111                	addi	sp,sp,256
     e62:	8082                	ret
      printf("ping3: send() failed\n");
     e64:	00002517          	auipc	a0,0x2
     e68:	82450513          	addi	a0,a0,-2012 # 2688 <malloc+0x68c>
     e6c:	0d8010ef          	jal	1f44 <printf>
      return 0;
     e70:	4481                	li	s1,0
     e72:	790e                	ld	s2,224(sp)
     e74:	69ee                	ld	s3,216(sp)
     e76:	6a4e                	ld	s4,208(sp)
     e78:	6aae                	ld	s5,200(sp)
     e7a:	6b0e                	ld	s6,192(sp)
     e7c:	7bea                	ld	s7,184(sp)
     e7e:	7c4a                	ld	s8,176(sp)
     e80:	bfe1                	j	e58 <ping3+0x27c>
      fprintf(2, "ping3: recv() failed\n");
     e82:	00002597          	auipc	a1,0x2
     e86:	81e58593          	addi	a1,a1,-2018 # 26a0 <malloc+0x6a4>
     e8a:	4509                	li	a0,2
     e8c:	08e010ef          	jal	1f1a <fprintf>
      return 0;
     e90:	4481                	li	s1,0
     e92:	790e                	ld	s2,224(sp)
     e94:	69ee                	ld	s3,216(sp)
     e96:	6a4e                	ld	s4,208(sp)
     e98:	6aae                	ld	s5,200(sp)
     e9a:	6b0e                	ld	s6,192(sp)
     e9c:	7bea                	ld	s7,184(sp)
     e9e:	7c4a                	ld	s8,176(sp)
     ea0:	7caa                	ld	s9,168(sp)
     ea2:	bf5d                	j	e58 <ping3+0x27c>
      printf("ping3: wrong ip src %x\n", src);
     ea4:	00002517          	auipc	a0,0x2
     ea8:	81450513          	addi	a0,a0,-2028 # 26b8 <malloc+0x6bc>
     eac:	098010ef          	jal	1f44 <printf>
      return 0;
     eb0:	b7c5                	j	e90 <ping3+0x2b4>
      printf("ping3: wrong sport %d\n", sport);
     eb2:	00002517          	auipc	a0,0x2
     eb6:	81e50513          	addi	a0,a0,-2018 # 26d0 <malloc+0x6d4>
     eba:	08a010ef          	jal	1f44 <printf>
      return 0;
     ebe:	bfc9                	j	e90 <ping3+0x2b4>
      printf("ping3: wrong length %d\n", cc);
     ec0:	85aa                	mv	a1,a0
     ec2:	00002517          	auipc	a0,0x2
     ec6:	82650513          	addi	a0,a0,-2010 # 26e8 <malloc+0x6ec>
     eca:	07a010ef          	jal	1f44 <printf>
      return 0;
     ece:	b7c9                	j	e90 <ping3+0x2b4>
      printf("ping3: wrong content\n");
     ed0:	00002517          	auipc	a0,0x2
     ed4:	83050513          	addi	a0,a0,-2000 # 2700 <malloc+0x704>
     ed8:	06c010ef          	jal	1f44 <printf>
      return 0;
     edc:	bf55                	j	e90 <ping3+0x2b4>
    close(fds[0]);
     ede:	f9842503          	lw	a0,-104(s0)
     ee2:	44f000ef          	jal	1b30 <close>
    write(fds[1], ":", 1); // ensure parent's read() doesn't block
     ee6:	4605                	li	a2,1
     ee8:	00002597          	auipc	a1,0x2
     eec:	83058593          	addi	a1,a1,-2000 # 2718 <malloc+0x71c>
     ef0:	f9c42503          	lw	a0,-100(s0)
     ef4:	435000ef          	jal	1b28 <write>
      memset(ibuf, 0, sizeof(ibuf));
     ef8:	f1840493          	addi	s1,s0,-232
     efc:	08000b93          	li	s7,128
      int cc = recv(2008, &src, &sport, ibuf, sizeof(ibuf)-1);
     f00:	f1040b13          	addi	s6,s0,-240
     f04:	f1440a93          	addi	s5,s0,-236
     f08:	07f00a13          	li	s4,127
     f0c:	7d800993          	li	s3,2008
      write(fds[1], "x", 1);
     f10:	4905                	li	s2,1
     f12:	a811                	j	f26 <ping3+0x34a>
     f14:	864a                	mv	a2,s2
     f16:	00002597          	auipc	a1,0x2
     f1a:	82258593          	addi	a1,a1,-2014 # 2738 <malloc+0x73c>
     f1e:	f9c42503          	lw	a0,-100(s0)
     f22:	407000ef          	jal	1b28 <write>
      uint32 src = 0;
     f26:	f0042a23          	sw	zero,-236(s0)
      uint16 sport = 0;
     f2a:	f0041823          	sh	zero,-240(s0)
      memset(ibuf, 0, sizeof(ibuf));
     f2e:	865e                	mv	a2,s7
     f30:	4581                	li	a1,0
     f32:	8526                	mv	a0,s1
     f34:	19b000ef          	jal	18ce <memset>
      int cc = recv(2008, &src, &sport, ibuf, sizeof(ibuf)-1);
     f38:	8752                	mv	a4,s4
     f3a:	86a6                	mv	a3,s1
     f3c:	865a                	mv	a2,s6
     f3e:	85d6                	mv	a1,s5
     f40:	854e                	mv	a0,s3
     f42:	47f000ef          	jal	1bc0 <recv>
      if(cc < 0){
     f46:	fc0557e3          	bgez	a0,f14 <ping3+0x338>
        printf("ping3: recv failed\n");
     f4a:	00001517          	auipc	a0,0x1
     f4e:	7d650513          	addi	a0,a0,2006 # 2720 <malloc+0x724>
     f52:	7f3000ef          	jal	1f44 <printf>
    exit(0);
     f56:	4501                	li	a0,0
     f58:	3b1000ef          	jal	1b08 <exit>
    printf("ping3: too many packets (%d) were queued on a UDP port\n", n);
     f5c:	00001517          	auipc	a0,0x1
     f60:	7e450513          	addi	a0,a0,2020 # 2740 <malloc+0x744>
     f64:	7e1000ef          	jal	1f44 <printf>
    return 0;
     f68:	790e                	ld	s2,224(sp)
     f6a:	69ee                	ld	s3,216(sp)
     f6c:	6a4e                	ld	s4,208(sp)
     f6e:	6aae                	ld	s5,200(sp)
     f70:	6b0e                	ld	s6,192(sp)
     f72:	7bea                	ld	s7,184(sp)
     f74:	7c4a                	ld	s8,176(sp)
     f76:	7caa                	ld	s9,168(sp)
     f78:	b5c5                	j	e58 <ping3+0x27c>

0000000000000f7a <encode_qname>:

// Encode a DNS name
void
encode_qname(char *qn, char *host)
{
     f7a:	7139                	addi	sp,sp,-64
     f7c:	fc06                	sd	ra,56(sp)
     f7e:	f822                	sd	s0,48(sp)
     f80:	f426                	sd	s1,40(sp)
     f82:	f04a                	sd	s2,32(sp)
     f84:	ec4e                	sd	s3,24(sp)
     f86:	e852                	sd	s4,16(sp)
     f88:	e456                	sd	s5,8(sp)
     f8a:	0080                	addi	s0,sp,64
     f8c:	8aaa                	mv	s5,a0
     f8e:	892e                	mv	s2,a1
  char *l = host; 
  
  for(char *c = host; c < host+strlen(host)+1; c++) {
     f90:	84ae                	mv	s1,a1
  char *l = host; 
     f92:	8a2e                	mv	s4,a1
    if(*c == '.') {
     f94:	02e00993          	li	s3,46
  for(char *c = host; c < host+strlen(host)+1; c++) {
     f98:	a029                	j	fa2 <encode_qname+0x28>
      *qn++ = (char) (c-l);
     f9a:	8ab2                	mv	s5,a2
      for(char *d = l; d < c; d++) {
        *qn++ = *d;
      }
      l = c+1; // skip .
     f9c:	00148a13          	addi	s4,s1,1
  for(char *c = host; c < host+strlen(host)+1; c++) {
     fa0:	0485                	addi	s1,s1,1
     fa2:	854a                	mv	a0,s2
     fa4:	0fd000ef          	jal	18a0 <strlen>
     fa8:	02051793          	slli	a5,a0,0x20
     fac:	9381                	srli	a5,a5,0x20
     fae:	0785                	addi	a5,a5,1
     fb0:	97ca                	add	a5,a5,s2
     fb2:	02f4fc63          	bgeu	s1,a5,fea <encode_qname+0x70>
    if(*c == '.') {
     fb6:	0004c783          	lbu	a5,0(s1)
     fba:	ff3793e3          	bne	a5,s3,fa0 <encode_qname+0x26>
      *qn++ = (char) (c-l);
     fbe:	001a8613          	addi	a2,s5,1
     fc2:	414487b3          	sub	a5,s1,s4
     fc6:	00fa8023          	sb	a5,0(s5)
      for(char *d = l; d < c; d++) {
     fca:	fc9a78e3          	bgeu	s4,s1,f9a <encode_qname+0x20>
     fce:	87d2                	mv	a5,s4
      *qn++ = (char) (c-l);
     fd0:	8732                	mv	a4,a2
        *qn++ = *d;
     fd2:	0705                	addi	a4,a4,1
     fd4:	0007c683          	lbu	a3,0(a5)
     fd8:	fed70fa3          	sb	a3,-1(a4)
      for(char *d = l; d < c; d++) {
     fdc:	0785                	addi	a5,a5,1
     fde:	fef49ae3          	bne	s1,a5,fd2 <encode_qname+0x58>
     fe2:	9626                	add	a2,a2,s1
     fe4:	41460ab3          	sub	s5,a2,s4
     fe8:	bf55                	j	f9c <encode_qname+0x22>
    }
  }
  *qn = '\0';
     fea:	000a8023          	sb	zero,0(s5)
}
     fee:	70e2                	ld	ra,56(sp)
     ff0:	7442                	ld	s0,48(sp)
     ff2:	74a2                	ld	s1,40(sp)
     ff4:	7902                	ld	s2,32(sp)
     ff6:	69e2                	ld	s3,24(sp)
     ff8:	6a42                	ld	s4,16(sp)
     ffa:	6aa2                	ld	s5,8(sp)
     ffc:	6121                	addi	sp,sp,64
     ffe:	8082                	ret

0000000000001000 <decode_qname>:

// Decode a DNS name
void
decode_qname(char *qn, int max)
{
  char *qnMax = qn + max;
    1000:	95aa                	add	a1,a1,a0
      break;
    for(int i = 0; i < l; i++) {
      *qn = *(qn+1);
      qn++;
    }
    *qn++ = '.';
    1002:	02e00813          	li	a6,46
    if(qn >= qnMax){
    1006:	02b57a63          	bgeu	a0,a1,103a <decode_qname+0x3a>
    int l = *qn;
    100a:	00054683          	lbu	a3,0(a0)
    if(l == 0)
    100e:	c2b9                	beqz	a3,1054 <decode_qname+0x54>
    1010:	fff6861b          	addiw	a2,a3,-1
    1014:	1602                	slli	a2,a2,0x20
    1016:	9201                	srli	a2,a2,0x20
    1018:	96aa                	add	a3,a3,a0
    101a:	87aa                	mv	a5,a0
      *qn = *(qn+1);
    101c:	0017c703          	lbu	a4,1(a5)
    1020:	00e78023          	sb	a4,0(a5)
      qn++;
    1024:	0785                	addi	a5,a5,1
    for(int i = 0; i < l; i++) {
    1026:	fed79be3          	bne	a5,a3,101c <decode_qname+0x1c>
    102a:	87aa                	mv	a5,a0
    102c:	9532                	add	a0,a0,a2
    *qn++ = '.';
    102e:	0509                	addi	a0,a0,2
    1030:	97b2                	add	a5,a5,a2
    1032:	010780a3          	sb	a6,1(a5)
    if(qn >= qnMax){
    1036:	fcb56ae3          	bltu	a0,a1,100a <decode_qname+0xa>
{
    103a:	1141                	addi	sp,sp,-16
    103c:	e406                	sd	ra,8(sp)
    103e:	e022                	sd	s0,0(sp)
    1040:	0800                	addi	s0,sp,16
      printf("invalid DNS reply\n");
    1042:	00001517          	auipc	a0,0x1
    1046:	74650513          	addi	a0,a0,1862 # 2788 <malloc+0x78c>
    104a:	6fb000ef          	jal	1f44 <printf>
      exit(1);
    104e:	4505                	li	a0,1
    1050:	2b9000ef          	jal	1b08 <exit>
    1054:	8082                	ret

0000000000001056 <dns_req>:
}

// Make a DNS request
int
dns_req(uint8 *obuf)
{
    1056:	7179                	addi	sp,sp,-48
    1058:	f406                	sd	ra,40(sp)
    105a:	f022                	sd	s0,32(sp)
    105c:	ec26                	sd	s1,24(sp)
    105e:	e84a                	sd	s2,16(sp)
    1060:	e44e                	sd	s3,8(sp)
    1062:	1800                	addi	s0,sp,48
  int len = 0;
  
  struct dns *hdr = (struct dns *) obuf;
  hdr->id = htons(6828);
    1064:	47e9                	li	a5,26
    1066:	00f50023          	sb	a5,0(a0)
    106a:	fac00793          	li	a5,-84
    106e:	00f500a3          	sb	a5,1(a0)
  hdr->rd = 1;
    1072:	00254783          	lbu	a5,2(a0)
    1076:	0017e793          	ori	a5,a5,1
    107a:	00f50123          	sb	a5,2(a0)
  hdr->qdcount = htons(1);
    107e:	00050223          	sb	zero,4(a0)
    1082:	4985                	li	s3,1
    1084:	013502a3          	sb	s3,5(a0)
  
  len += sizeof(struct dns);
  
  // qname part of question
  char *qname = (char *) (obuf + sizeof(struct dns));
    1088:	00c50493          	addi	s1,a0,12
  char *s = "www.cse.iitb.ac.in.";
  encode_qname(qname, s);
    108c:	00001597          	auipc	a1,0x1
    1090:	71458593          	addi	a1,a1,1812 # 27a0 <malloc+0x7a4>
    1094:	8526                	mv	a0,s1
    1096:	ee5ff0ef          	jal	f7a <encode_qname>
  len += strlen(qname) + 1;
    109a:	8526                	mv	a0,s1
    109c:	005000ef          	jal	18a0 <strlen>
    10a0:	892a                	mv	s2,a0

  // constants part of question
  struct dns_question *h = (struct dns_question *) (qname+strlen(qname)+1);
    10a2:	8526                	mv	a0,s1
    10a4:	7fc000ef          	jal	18a0 <strlen>
    10a8:	02051793          	slli	a5,a0,0x20
    10ac:	9381                	srli	a5,a5,0x20
    10ae:	97ce                	add	a5,a5,s3
    10b0:	94be                	add	s1,s1,a5
  h->qtype = htons(0x1);
    10b2:	00048023          	sb	zero,0(s1)
    10b6:	013480a3          	sb	s3,1(s1)
  h->qclass = htons(0x1);
    10ba:	00048123          	sb	zero,2(s1)
    10be:	013481a3          	sb	s3,3(s1)

  len += sizeof(struct dns_question);
  return len;
}
    10c2:	0119051b          	addiw	a0,s2,17
    10c6:	70a2                	ld	ra,40(sp)
    10c8:	7402                	ld	s0,32(sp)
    10ca:	64e2                	ld	s1,24(sp)
    10cc:	6942                	ld	s2,16(sp)
    10ce:	69a2                	ld	s3,8(sp)
    10d0:	6145                	addi	sp,sp,48
    10d2:	8082                	ret

00000000000010d4 <dns_rep>:

// Process DNS response
int
dns_rep(uint8 *ibuf, int cc)
{
    10d4:	7119                	addi	sp,sp,-128
    10d6:	fc86                	sd	ra,120(sp)
    10d8:	f8a2                	sd	s0,112(sp)
    10da:	f466                	sd	s9,40(sp)
    10dc:	0100                	addi	s0,sp,128
  struct dns *hdr = (struct dns *) ibuf;
  int len;
  char *qname = 0;
  int record = 0;

  if(cc < sizeof(struct dns)){
    10de:	47ad                	li	a5,11
    10e0:	0cb7f363          	bgeu	a5,a1,11a6 <dns_rep+0xd2>
    10e4:	f0ca                	sd	s2,96(sp)
    10e6:	e0da                	sd	s6,64(sp)
    10e8:	892a                	mv	s2,a0
    10ea:	8b2e                	mv	s6,a1
    printf("DNS reply too short\n");
    return 0;
  }

  if(!hdr->qr) {
    10ec:	00250783          	lb	a5,2(a0)
    10f0:	0c07d363          	bgez	a5,11b6 <dns_rep+0xe2>
    printf("Not a DNS reply for %d\n", ntohs(hdr->id));
    return 0;
  }

  if(hdr->id != htons(6828)){
    10f4:	00054703          	lbu	a4,0(a0)
    10f8:	00154783          	lbu	a5,1(a0)
    10fc:	07a2                	slli	a5,a5,0x8
    10fe:	00e7e6b3          	or	a3,a5,a4
    1102:	672d                	lui	a4,0xb
    1104:	c1a70713          	addi	a4,a4,-998 # ac1a <base+0x7a0a>
    1108:	0ee69363          	bne	a3,a4,11ee <dns_rep+0x11a>
    printf("DNS wrong id: %d\n", ntohs(hdr->id));
    return 0;
  }
  
  if(hdr->rcode != 0) {
    110c:	00354783          	lbu	a5,3(a0)
    1110:	8bbd                	andi	a5,a5,15
    1112:	0e079f63          	bnez	a5,1210 <dns_rep+0x13c>
    1116:	f4a6                	sd	s1,104(sp)
    1118:	ecce                	sd	s3,88(sp)
    111a:	e8d2                	sd	s4,80(sp)
    return 0;
  }
  
  len = sizeof(struct dns);

  for(int i =0; i < ntohs(hdr->qdcount); i++) {
    111c:	00454703          	lbu	a4,4(a0)
    1120:	00554783          	lbu	a5,5(a0)
    1124:	07a2                	slli	a5,a5,0x8
    1126:	8fd9                	or	a5,a5,a4
    1128:	4a01                	li	s4,0
  len = sizeof(struct dns);
    112a:	44b1                	li	s1,12
  char *qname = 0;
    112c:	4981                	li	s3,0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
    112e:	cf85                	beqz	a5,1166 <dns_rep+0x92>
    char *qn = (char *) (ibuf+len);
    1130:	009909b3          	add	s3,s2,s1
    qname = qn;
    decode_qname(qn, cc - len);
    1134:	409b05bb          	subw	a1,s6,s1
    1138:	854e                	mv	a0,s3
    113a:	ec7ff0ef          	jal	1000 <decode_qname>
    len += strlen(qn)+1;
    113e:	854e                	mv	a0,s3
    1140:	760000ef          	jal	18a0 <strlen>
    len += sizeof(struct dns_question);
    1144:	2515                	addiw	a0,a0,5
    1146:	9ca9                	addw	s1,s1,a0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
    1148:	2a05                	addiw	s4,s4,1
    114a:	00494703          	lbu	a4,4(s2)
    114e:	00594783          	lbu	a5,5(s2)
    1152:	07a2                	slli	a5,a5,0x8
    1154:	8f5d                	or	a4,a4,a5
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
    1156:	83a1                	srli	a5,a5,0x8
    1158:	0087171b          	slliw	a4,a4,0x8
    115c:	8fd9                	or	a5,a5,a4
    115e:	17c2                	slli	a5,a5,0x30
    1160:	93c1                	srli	a5,a5,0x30
    1162:	fcfa47e3          	blt	s4,a5,1130 <dns_rep+0x5c>
  }

  for(int i = 0; i < ntohs(hdr->ancount); i++) {
    1166:	00694703          	lbu	a4,6(s2)
    116a:	00794783          	lbu	a5,7(s2)
    116e:	07a2                	slli	a5,a5,0x8
    1170:	8fd9                	or	a5,a5,a4
    1172:	24078c63          	beqz	a5,13ca <dns_rep+0x2f6>
    1176:	e4d6                	sd	s5,72(sp)
    1178:	fc5e                	sd	s7,56(sp)
    117a:	f862                	sd	s8,48(sp)
    117c:	f06a                	sd	s10,32(sp)
    117e:	ec6e                	sd	s11,24(sp)
    1180:	00001797          	auipc	a5,0x1
    1184:	03078793          	addi	a5,a5,48 # 21b0 <malloc+0x1b4>
    1188:	00098363          	beqz	s3,118e <dns_rep+0xba>
    118c:	87ce                	mv	a5,s3
    118e:	f8f43423          	sd	a5,-120(s0)
    1192:	4a81                	li	s5,0
  int record = 0;
    1194:	4c81                	li	s9,0
      return 0;
    }
    
    char *qn = (char *) (ibuf+len);

    if((int) qn[0] > 63) {  // compression?
    1196:	03f00c13          	li	s8,63
      len += strlen(qn)+1;
    }
      
    struct dns_data *d = (struct dns_data *) (ibuf+len);
    len += sizeof(struct dns_data);
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
    119a:	10000b93          	li	s7,256
    119e:	40000d13          	li	s10,1024
      record = 1;
      printf("DNS arecord for %s is ", qname ? qname : "" );
      uint8 *ip = (ibuf+len);
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
      if((ip[0] != 10 || ip[1] != 129 || ip[2] != 3 || ip[3] != 3) ||
    11a2:	4da9                	li	s11,10
    11a4:	a211                	j	12a8 <dns_rep+0x1d4>
    printf("DNS reply too short\n");
    11a6:	00001517          	auipc	a0,0x1
    11aa:	61250513          	addi	a0,a0,1554 # 27b8 <malloc+0x7bc>
    11ae:	597000ef          	jal	1f44 <printf>
    return 0;
    11b2:	4c81                	li	s9,0
    11b4:	a03d                	j	11e2 <dns_rep+0x10e>
    printf("Not a DNS reply for %d\n", ntohs(hdr->id));
    11b6:	00054703          	lbu	a4,0(a0)
    11ba:	00154783          	lbu	a5,1(a0)
    11be:	07a2                	slli	a5,a5,0x8
    11c0:	8f5d                	or	a4,a4,a5
    11c2:	83a1                	srli	a5,a5,0x8
    11c4:	0087171b          	slliw	a4,a4,0x8
    11c8:	00e7e5b3          	or	a1,a5,a4
    11cc:	15c2                	slli	a1,a1,0x30
    11ce:	91c1                	srli	a1,a1,0x30
    11d0:	00001517          	auipc	a0,0x1
    11d4:	60050513          	addi	a0,a0,1536 # 27d0 <malloc+0x7d4>
    11d8:	56d000ef          	jal	1f44 <printf>
    return 0;
    11dc:	4c81                	li	s9,0
    11de:	7906                	ld	s2,96(sp)
    11e0:	6b06                	ld	s6,64(sp)
    printf("dns: didn't receive an arecord\n");
    return 0;
  }

  return 1;
}
    11e2:	8566                	mv	a0,s9
    11e4:	70e6                	ld	ra,120(sp)
    11e6:	7446                	ld	s0,112(sp)
    11e8:	7ca2                	ld	s9,40(sp)
    11ea:	6109                	addi	sp,sp,128
    11ec:	8082                	ret
    11ee:	0086d59b          	srliw	a1,a3,0x8
    11f2:	0086969b          	slliw	a3,a3,0x8
    11f6:	8dd5                	or	a1,a1,a3
    printf("DNS wrong id: %d\n", ntohs(hdr->id));
    11f8:	15c2                	slli	a1,a1,0x30
    11fa:	91c1                	srli	a1,a1,0x30
    11fc:	00001517          	auipc	a0,0x1
    1200:	5ec50513          	addi	a0,a0,1516 # 27e8 <malloc+0x7ec>
    1204:	541000ef          	jal	1f44 <printf>
    return 0;
    1208:	4c81                	li	s9,0
    120a:	7906                	ld	s2,96(sp)
    120c:	6b06                	ld	s6,64(sp)
    120e:	bfd1                	j	11e2 <dns_rep+0x10e>
    printf("DNS rcode error: %x\n", hdr->rcode);
    1210:	00354583          	lbu	a1,3(a0)
    1214:	89bd                	andi	a1,a1,15
    1216:	00001517          	auipc	a0,0x1
    121a:	5ea50513          	addi	a0,a0,1514 # 2800 <malloc+0x804>
    121e:	527000ef          	jal	1f44 <printf>
    return 0;
    1222:	4c81                	li	s9,0
    1224:	7906                	ld	s2,96(sp)
    1226:	6b06                	ld	s6,64(sp)
    1228:	bf6d                	j	11e2 <dns_rep+0x10e>
      printf("dns: invalid DNS reply\n");
    122a:	00001517          	auipc	a0,0x1
    122e:	5ee50513          	addi	a0,a0,1518 # 2818 <malloc+0x81c>
    1232:	513000ef          	jal	1f44 <printf>
      return 0;
    1236:	4c81                	li	s9,0
    1238:	74a6                	ld	s1,104(sp)
    123a:	7906                	ld	s2,96(sp)
    123c:	69e6                	ld	s3,88(sp)
    123e:	6a46                	ld	s4,80(sp)
    1240:	6aa6                	ld	s5,72(sp)
    1242:	6b06                	ld	s6,64(sp)
    1244:	7be2                	ld	s7,56(sp)
    1246:	7c42                	ld	s8,48(sp)
    1248:	7d02                	ld	s10,32(sp)
    124a:	6de2                	ld	s11,24(sp)
    124c:	bf59                	j	11e2 <dns_rep+0x10e>
      decode_qname(qn, cc - len);
    124e:	409b05bb          	subw	a1,s6,s1
    1252:	854e                	mv	a0,s3
    1254:	dadff0ef          	jal	1000 <decode_qname>
      len += strlen(qn)+1;
    1258:	854e                	mv	a0,s3
    125a:	646000ef          	jal	18a0 <strlen>
    125e:	2485                	addiw	s1,s1,1
    1260:	00a489bb          	addw	s3,s1,a0
    1264:	a8a1                	j	12bc <dns_rep+0x1e8>
        printf("dns: wrong ip address");
    1266:	00001517          	auipc	a0,0x1
    126a:	5f250513          	addi	a0,a0,1522 # 2858 <malloc+0x85c>
    126e:	4d7000ef          	jal	1f44 <printf>
        return 0;
    1272:	4c81                	li	s9,0
    1274:	74a6                	ld	s1,104(sp)
    1276:	7906                	ld	s2,96(sp)
    1278:	69e6                	ld	s3,88(sp)
    127a:	6a46                	ld	s4,80(sp)
    127c:	6aa6                	ld	s5,72(sp)
    127e:	6b06                	ld	s6,64(sp)
    1280:	7be2                	ld	s7,56(sp)
    1282:	7c42                	ld	s8,48(sp)
    1284:	7d02                	ld	s10,32(sp)
    1286:	6de2                	ld	s11,24(sp)
    1288:	bfa9                	j	11e2 <dns_rep+0x10e>
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
    128a:	2a85                	addiw	s5,s5,1
    128c:	00694703          	lbu	a4,6(s2)
    1290:	00794783          	lbu	a5,7(s2)
    1294:	07a2                	slli	a5,a5,0x8
    1296:	8f5d                	or	a4,a4,a5
    1298:	83a1                	srli	a5,a5,0x8
    129a:	0087171b          	slliw	a4,a4,0x8
    129e:	8fd9                	or	a5,a5,a4
    12a0:	17c2                	slli	a5,a5,0x30
    12a2:	93c1                	srli	a5,a5,0x30
    12a4:	08fadf63          	bge	s5,a5,1342 <dns_rep+0x26e>
    if(len >= cc){
    12a8:	f964d1e3          	bge	s1,s6,122a <dns_rep+0x156>
    char *qn = (char *) (ibuf+len);
    12ac:	009909b3          	add	s3,s2,s1
    if((int) qn[0] > 63) {  // compression?
    12b0:	0009c783          	lbu	a5,0(s3)
    12b4:	f8fc7de3          	bgeu	s8,a5,124e <dns_rep+0x17a>
      len += 2;
    12b8:	0024899b          	addiw	s3,s1,2
    struct dns_data *d = (struct dns_data *) (ibuf+len);
    12bc:	01390733          	add	a4,s2,s3
    len += sizeof(struct dns_data);
    12c0:	00a98a1b          	addiw	s4,s3,10
    12c4:	84d2                	mv	s1,s4
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
    12c6:	00074683          	lbu	a3,0(a4)
    12ca:	00174783          	lbu	a5,1(a4)
    12ce:	07a2                	slli	a5,a5,0x8
    12d0:	8fd5                	or	a5,a5,a3
    12d2:	fb779ce3          	bne	a5,s7,128a <dns_rep+0x1b6>
    12d6:	00874683          	lbu	a3,8(a4)
    12da:	00974783          	lbu	a5,9(a4)
    12de:	07a2                	slli	a5,a5,0x8
    12e0:	8fd5                	or	a5,a5,a3
    12e2:	fba794e3          	bne	a5,s10,128a <dns_rep+0x1b6>
      printf("DNS arecord for %s is ", qname ? qname : "" );
    12e6:	f8843583          	ld	a1,-120(s0)
    12ea:	00001517          	auipc	a0,0x1
    12ee:	54650513          	addi	a0,a0,1350 # 2830 <malloc+0x834>
    12f2:	453000ef          	jal	1f44 <printf>
      uint8 *ip = (ibuf+len);
    12f6:	9a4a                	add	s4,s4,s2
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
    12f8:	003a4703          	lbu	a4,3(s4)
    12fc:	002a4683          	lbu	a3,2(s4)
    1300:	001a4603          	lbu	a2,1(s4)
    1304:	000a4583          	lbu	a1,0(s4)
    1308:	00001517          	auipc	a0,0x1
    130c:	54050513          	addi	a0,a0,1344 # 2848 <malloc+0x84c>
    1310:	435000ef          	jal	1f44 <printf>
      if((ip[0] != 10 || ip[1] != 129 || ip[2] != 3 || ip[3] != 3) ||
    1314:	000a4783          	lbu	a5,0(s4)
    1318:	f5b797e3          	bne	a5,s11,1266 <dns_rep+0x192>
    131c:	001a4783          	lbu	a5,1(s4)
    1320:	08100713          	li	a4,129
    1324:	f4e791e3          	bne	a5,a4,1266 <dns_rep+0x192>
    1328:	002a4703          	lbu	a4,2(s4)
    132c:	478d                	li	a5,3
    132e:	f2f71ce3          	bne	a4,a5,1266 <dns_rep+0x192>
    1332:	003a4703          	lbu	a4,3(s4)
    1336:	f2f718e3          	bne	a4,a5,1266 <dns_rep+0x192>
      len += 4;
    133a:	00e9849b          	addiw	s1,s3,14
      record = 1;
    133e:	4c85                	li	s9,1
    1340:	b7a9                	j	128a <dns_rep+0x1b6>
    1342:	6aa6                	ld	s5,72(sp)
    1344:	7be2                	ld	s7,56(sp)
    1346:	7c42                	ld	s8,48(sp)
    1348:	7d02                	ld	s10,32(sp)
    134a:	6de2                	ld	s11,24(sp)
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
    134c:	00a94703          	lbu	a4,10(s2)
    1350:	00b94783          	lbu	a5,11(s2)
    1354:	07a2                	slli	a5,a5,0x8
    1356:	8f5d                	or	a4,a4,a5
    1358:	0087d613          	srli	a2,a5,0x8
    135c:	0087179b          	slliw	a5,a4,0x8
    1360:	8e5d                	or	a2,a2,a5
    1362:	1642                	slli	a2,a2,0x30
    1364:	9241                	srli	a2,a2,0x30
    1366:	cb21                	beqz	a4,13b6 <dns_rep+0x2e2>
    1368:	4681                	li	a3,0
    if(ntohs(d->type) != 41) {
    136a:	650d                	lui	a0,0x3
    136c:	90050513          	addi	a0,a0,-1792 # 2900 <malloc+0x904>
    if(*qn != 0) {
    1370:	009907b3          	add	a5,s2,s1
    1374:	0007c783          	lbu	a5,0(a5)
    1378:	ebb9                	bnez	a5,13ce <dns_rep+0x2fa>
    len += 1;
    137a:	0014879b          	addiw	a5,s1,1
    struct dns_data *d = (struct dns_data *) (ibuf+len);
    137e:	97ca                	add	a5,a5,s2
    len += sizeof(struct dns_data);
    1380:	24ad                	addiw	s1,s1,11
    if(ntohs(d->type) != 41) {
    1382:	0007c583          	lbu	a1,0(a5)
    1386:	0017c703          	lbu	a4,1(a5)
    138a:	0722                	slli	a4,a4,0x8
    138c:	8f4d                	or	a4,a4,a1
    138e:	04a71d63          	bne	a4,a0,13e8 <dns_rep+0x314>
    len += ntohs(d->len);
    1392:	0087c703          	lbu	a4,8(a5)
    1396:	0097c783          	lbu	a5,9(a5)
    139a:	07a2                	slli	a5,a5,0x8
    139c:	8f5d                	or	a4,a4,a5
    139e:	83a1                	srli	a5,a5,0x8
    13a0:	0087171b          	slliw	a4,a4,0x8
    13a4:	8fd9                	or	a5,a5,a4
    13a6:	0107979b          	slliw	a5,a5,0x10
    13aa:	0107d79b          	srliw	a5,a5,0x10
    13ae:	9cbd                	addw	s1,s1,a5
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
    13b0:	2685                	addiw	a3,a3,1
    13b2:	fac6cfe3          	blt	a3,a2,1370 <dns_rep+0x29c>
  if(len != cc) {
    13b6:	049b1663          	bne	s6,s1,1402 <dns_rep+0x32e>
  if(!record) {
    13ba:	060c8363          	beqz	s9,1420 <dns_rep+0x34c>
    13be:	74a6                	ld	s1,104(sp)
    13c0:	7906                	ld	s2,96(sp)
    13c2:	69e6                	ld	s3,88(sp)
    13c4:	6a46                	ld	s4,80(sp)
    13c6:	6b06                	ld	s6,64(sp)
    13c8:	bd29                	j	11e2 <dns_rep+0x10e>
  int record = 0;
    13ca:	4c81                	li	s9,0
    13cc:	b741                	j	134c <dns_rep+0x278>
      printf("dns: invalid name for EDNS\n");
    13ce:	00001517          	auipc	a0,0x1
    13d2:	4a250513          	addi	a0,a0,1186 # 2870 <malloc+0x874>
    13d6:	36f000ef          	jal	1f44 <printf>
      return 0;
    13da:	4c81                	li	s9,0
    13dc:	74a6                	ld	s1,104(sp)
    13de:	7906                	ld	s2,96(sp)
    13e0:	69e6                	ld	s3,88(sp)
    13e2:	6a46                	ld	s4,80(sp)
    13e4:	6b06                	ld	s6,64(sp)
    13e6:	bbf5                	j	11e2 <dns_rep+0x10e>
      printf("dns: invalid type for EDNS\n");
    13e8:	00001517          	auipc	a0,0x1
    13ec:	4a850513          	addi	a0,a0,1192 # 2890 <malloc+0x894>
    13f0:	355000ef          	jal	1f44 <printf>
      return 0;
    13f4:	4c81                	li	s9,0
    13f6:	74a6                	ld	s1,104(sp)
    13f8:	7906                	ld	s2,96(sp)
    13fa:	69e6                	ld	s3,88(sp)
    13fc:	6a46                	ld	s4,80(sp)
    13fe:	6b06                	ld	s6,64(sp)
    1400:	b3cd                	j	11e2 <dns_rep+0x10e>
    printf("dns: processed %d data bytes but received %d\n", len, cc);
    1402:	865a                	mv	a2,s6
    1404:	85a6                	mv	a1,s1
    1406:	00001517          	auipc	a0,0x1
    140a:	4aa50513          	addi	a0,a0,1194 # 28b0 <malloc+0x8b4>
    140e:	337000ef          	jal	1f44 <printf>
    return 0;
    1412:	4c81                	li	s9,0
    1414:	74a6                	ld	s1,104(sp)
    1416:	7906                	ld	s2,96(sp)
    1418:	69e6                	ld	s3,88(sp)
    141a:	6a46                	ld	s4,80(sp)
    141c:	6b06                	ld	s6,64(sp)
    141e:	b3d1                	j	11e2 <dns_rep+0x10e>
    printf("dns: didn't receive an arecord\n");
    1420:	00001517          	auipc	a0,0x1
    1424:	4c050513          	addi	a0,a0,1216 # 28e0 <malloc+0x8e4>
    1428:	31d000ef          	jal	1f44 <printf>
    142c:	74a6                	ld	s1,104(sp)
    142e:	7906                	ld	s2,96(sp)
    1430:	69e6                	ld	s3,88(sp)
    1432:	6a46                	ld	s4,80(sp)
    1434:	6b06                	ld	s6,64(sp)
    return 0;
    1436:	b375                	j	11e2 <dns_rep+0x10e>

0000000000001438 <dns>:

int
dns()
{
    1438:	1101                	addi	sp,sp,-32
    143a:	ec06                	sd	ra,24(sp)
    143c:	e822                	sd	s0,16(sp)
    143e:	e426                	sd	s1,8(sp)
    1440:	e04a                	sd	s2,0(sp)
    1442:	1000                	addi	s0,sp,32
    1444:	82010113          	addi	sp,sp,-2016
  uint8 obuf[N];
  uint8 ibuf[N];
  uint32 dst;
  int len;

  printf("dns: starting\n");
    1448:	00001517          	auipc	a0,0x1
    144c:	4b850513          	addi	a0,a0,1208 # 2900 <malloc+0x904>
    1450:	2f5000ef          	jal	1f44 <printf>

  memset(obuf, 0, N);
    1454:	bf840493          	addi	s1,s0,-1032
    1458:	3e800613          	li	a2,1000
    145c:	4581                	li	a1,0
    145e:	8526                	mv	a0,s1
    1460:	46e000ef          	jal	18ce <memset>
  memset(ibuf, 0, N);
    1464:	3e800613          	li	a2,1000
    1468:	4581                	li	a1,0
    146a:	81040513          	addi	a0,s0,-2032
    146e:	460000ef          	jal	18ce <memset>
  
  // 8.8.8.8: google's name server
  dst = (8 << 24) | (8 << 16) | (8 << 8) | (8 << 0);

  len = dns_req(obuf);
    1472:	8526                	mv	a0,s1
    1474:	be3ff0ef          	jal	1056 <dns_req>
    1478:	892a                	mv	s2,a0
  
  bind(10000);
    147a:	6509                	lui	a0,0x2
    147c:	71050513          	addi	a0,a0,1808 # 2710 <malloc+0x714>
    1480:	728000ef          	jal	1ba8 <bind>
  
  if(send(10000, dst, 53, (char*)obuf, len) < 0){
    1484:	874a                	mv	a4,s2
    1486:	86a6                	mv	a3,s1
    1488:	03500613          	li	a2,53
    148c:	080815b7          	lui	a1,0x8081
    1490:	80858593          	addi	a1,a1,-2040 # 8080808 <base+0x807d5f8>
    1494:	6509                	lui	a0,0x2
    1496:	71050513          	addi	a0,a0,1808 # 2710 <malloc+0x714>
    149a:	71e000ef          	jal	1bb8 <send>
    149e:	04054563          	bltz	a0,14e8 <dns+0xb0>
    return 0;
  }

  uint32 src;
  uint16 sport;
  int cc = recv(10000, &src, &sport, (char*)ibuf, sizeof(ibuf));
    14a2:	3e800713          	li	a4,1000
    14a6:	81040693          	addi	a3,s0,-2032
    14aa:	80a40613          	addi	a2,s0,-2038
    14ae:	80c40593          	addi	a1,s0,-2036
    14b2:	6509                	lui	a0,0x2
    14b4:	71050513          	addi	a0,a0,1808 # 2710 <malloc+0x714>
    14b8:	708000ef          	jal	1bc0 <recv>
    14bc:	84aa                	mv	s1,a0
  if(cc < 0){
    14be:	02054e63          	bltz	a0,14fa <dns+0xc2>
    fprintf(2, "dns: recv() failed\n");
    return 0;
  }

  unbind(10000);
    14c2:	6509                	lui	a0,0x2
    14c4:	71050513          	addi	a0,a0,1808 # 2710 <malloc+0x714>
    14c8:	6e8000ef          	jal	1bb0 <unbind>

  if(dns_rep(ibuf, cc)){
    14cc:	85a6                	mv	a1,s1
    14ce:	81040513          	addi	a0,s0,-2032
    14d2:	c03ff0ef          	jal	10d4 <dns_rep>
    14d6:	e91d                	bnez	a0,150c <dns+0xd4>
    printf("dns: OK\n");
    return 1;
  } else {
    return 0;
  }
}  
    14d8:	7e010113          	addi	sp,sp,2016
    14dc:	60e2                	ld	ra,24(sp)
    14de:	6442                	ld	s0,16(sp)
    14e0:	64a2                	ld	s1,8(sp)
    14e2:	6902                	ld	s2,0(sp)
    14e4:	6105                	addi	sp,sp,32
    14e6:	8082                	ret
    fprintf(2, "dns: send() failed\n");
    14e8:	00001597          	auipc	a1,0x1
    14ec:	42858593          	addi	a1,a1,1064 # 2910 <malloc+0x914>
    14f0:	4509                	li	a0,2
    14f2:	229000ef          	jal	1f1a <fprintf>
    return 0;
    14f6:	4501                	li	a0,0
    14f8:	b7c5                	j	14d8 <dns+0xa0>
    fprintf(2, "dns: recv() failed\n");
    14fa:	00001597          	auipc	a1,0x1
    14fe:	42e58593          	addi	a1,a1,1070 # 2928 <malloc+0x92c>
    1502:	4509                	li	a0,2
    1504:	217000ef          	jal	1f1a <fprintf>
    return 0;
    1508:	4501                	li	a0,0
    150a:	b7f9                	j	14d8 <dns+0xa0>
    printf("dns: OK\n");
    150c:	00001517          	auipc	a0,0x1
    1510:	43450513          	addi	a0,a0,1076 # 2940 <malloc+0x944>
    1514:	231000ef          	jal	1f44 <printf>
    return 1;
    1518:	4505                	li	a0,1
    151a:	bf7d                	j	14d8 <dns+0xa0>

000000000000151c <usage>:

void
usage()
{
    151c:	1141                	addi	sp,sp,-16
    151e:	e406                	sd	ra,8(sp)
    1520:	e022                	sd	s0,0(sp)
    1522:	0800                	addi	s0,sp,16
  printf("Usage: nettest txone\n");
    1524:	00001517          	auipc	a0,0x1
    1528:	42c50513          	addi	a0,a0,1068 # 2950 <malloc+0x954>
    152c:	219000ef          	jal	1f44 <printf>
  printf("       nettest tx\n");
    1530:	00001517          	auipc	a0,0x1
    1534:	43850513          	addi	a0,a0,1080 # 2968 <malloc+0x96c>
    1538:	20d000ef          	jal	1f44 <printf>
  printf("       nettest rxone\n");
    153c:	00001517          	auipc	a0,0x1
    1540:	44450513          	addi	a0,a0,1092 # 2980 <malloc+0x984>
    1544:	201000ef          	jal	1f44 <printf>
  printf("       nettest rx\n");
    1548:	00001517          	auipc	a0,0x1
    154c:	45050513          	addi	a0,a0,1104 # 2998 <malloc+0x99c>
    1550:	1f5000ef          	jal	1f44 <printf>
  printf("       nettest rx2\n");
    1554:	00001517          	auipc	a0,0x1
    1558:	45c50513          	addi	a0,a0,1116 # 29b0 <malloc+0x9b4>
    155c:	1e9000ef          	jal	1f44 <printf>
  printf("       nettest rxburst\n");
    1560:	00001517          	auipc	a0,0x1
    1564:	46850513          	addi	a0,a0,1128 # 29c8 <malloc+0x9cc>
    1568:	1dd000ef          	jal	1f44 <printf>
  printf("       nettest ping1\n");
    156c:	00001517          	auipc	a0,0x1
    1570:	47450513          	addi	a0,a0,1140 # 29e0 <malloc+0x9e4>
    1574:	1d1000ef          	jal	1f44 <printf>
  printf("       nettest ping2\n");
    1578:	00001517          	auipc	a0,0x1
    157c:	48050513          	addi	a0,a0,1152 # 29f8 <malloc+0x9fc>
    1580:	1c5000ef          	jal	1f44 <printf>
  printf("       nettest ping3\n");
    1584:	00001517          	auipc	a0,0x1
    1588:	48c50513          	addi	a0,a0,1164 # 2a10 <malloc+0xa14>
    158c:	1b9000ef          	jal	1f44 <printf>
  printf("       nettest dns\n");
    1590:	00001517          	auipc	a0,0x1
    1594:	49850513          	addi	a0,a0,1176 # 2a28 <malloc+0xa2c>
    1598:	1ad000ef          	jal	1f44 <printf>
  printf("       nettest grade\n");
    159c:	00001517          	auipc	a0,0x1
    15a0:	4a450513          	addi	a0,a0,1188 # 2a40 <malloc+0xa44>
    15a4:	1a1000ef          	jal	1f44 <printf>
  exit(1);
    15a8:	4505                	li	a0,1
    15aa:	55e000ef          	jal	1b08 <exit>

00000000000015ae <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    15ae:	7139                	addi	sp,sp,-64
    15b0:	fc06                	sd	ra,56(sp)
    15b2:	f822                	sd	s0,48(sp)
    15b4:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    15b6:	fc840513          	addi	a0,s0,-56
    15ba:	55e000ef          	jal	1b18 <pipe>
    15be:	04054f63          	bltz	a0,161c <countfree+0x6e>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    15c2:	53e000ef          	jal	1b00 <fork>

  if(pid < 0){
    15c6:	06054863          	bltz	a0,1636 <countfree+0x88>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    15ca:	e551                	bnez	a0,1656 <countfree+0xa8>
    15cc:	f426                	sd	s1,40(sp)
    15ce:	f04a                	sd	s2,32(sp)
    15d0:	ec4e                	sd	s3,24(sp)
    15d2:	e852                	sd	s4,16(sp)
    close(fds[0]);
    15d4:	fc842503          	lw	a0,-56(s0)
    15d8:	558000ef          	jal	1b30 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
    15dc:	6905                	lui	s2,0x1
      if(a == 0xffffffffffffffff){
    15de:	59fd                	li	s3,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    15e0:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    15e2:	00001a17          	auipc	s4,0x1
    15e6:	156a0a13          	addi	s4,s4,342 # 2738 <malloc+0x73c>
      uint64 a = (uint64) sbrk(4096);
    15ea:	854a                	mv	a0,s2
    15ec:	4e8000ef          	jal	1ad4 <sbrk>
      if(a == 0xffffffffffffffff){
    15f0:	07350063          	beq	a0,s3,1650 <countfree+0xa2>
      *(char *)(a + 4096 - 1) = 1;
    15f4:	954a                	add	a0,a0,s2
    15f6:	fe950fa3          	sb	s1,-1(a0)
      if(write(fds[1], "x", 1) != 1){
    15fa:	8626                	mv	a2,s1
    15fc:	85d2                	mv	a1,s4
    15fe:	fcc42503          	lw	a0,-52(s0)
    1602:	526000ef          	jal	1b28 <write>
    1606:	fe9502e3          	beq	a0,s1,15ea <countfree+0x3c>
        printf("write() failed in countfree()\n");
    160a:	00001517          	auipc	a0,0x1
    160e:	48e50513          	addi	a0,a0,1166 # 2a98 <malloc+0xa9c>
    1612:	133000ef          	jal	1f44 <printf>
        exit(1);
    1616:	4505                	li	a0,1
    1618:	4f0000ef          	jal	1b08 <exit>
    161c:	f426                	sd	s1,40(sp)
    161e:	f04a                	sd	s2,32(sp)
    1620:	ec4e                	sd	s3,24(sp)
    1622:	e852                	sd	s4,16(sp)
    printf("pipe() failed in countfree()\n");
    1624:	00001517          	auipc	a0,0x1
    1628:	43450513          	addi	a0,a0,1076 # 2a58 <malloc+0xa5c>
    162c:	119000ef          	jal	1f44 <printf>
    exit(1);
    1630:	4505                	li	a0,1
    1632:	4d6000ef          	jal	1b08 <exit>
    1636:	f426                	sd	s1,40(sp)
    1638:	f04a                	sd	s2,32(sp)
    163a:	ec4e                	sd	s3,24(sp)
    163c:	e852                	sd	s4,16(sp)
    printf("fork failed in countfree()\n");
    163e:	00001517          	auipc	a0,0x1
    1642:	43a50513          	addi	a0,a0,1082 # 2a78 <malloc+0xa7c>
    1646:	0ff000ef          	jal	1f44 <printf>
    exit(1);
    164a:	4505                	li	a0,1
    164c:	4bc000ef          	jal	1b08 <exit>
      }
    }

    exit(0);
    1650:	4501                	li	a0,0
    1652:	4b6000ef          	jal	1b08 <exit>
    1656:	f426                	sd	s1,40(sp)
    1658:	f04a                	sd	s2,32(sp)
    165a:	ec4e                	sd	s3,24(sp)
  }

  close(fds[1]);
    165c:	fcc42503          	lw	a0,-52(s0)
    1660:	4d0000ef          	jal	1b30 <close>

  int n = 0;
    1664:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    1666:	fc740993          	addi	s3,s0,-57
    166a:	4905                	li	s2,1
    166c:	864a                	mv	a2,s2
    166e:	85ce                	mv	a1,s3
    1670:	fc842503          	lw	a0,-56(s0)
    1674:	4ac000ef          	jal	1b20 <read>
    if(cc < 0){
    1678:	00054563          	bltz	a0,1682 <countfree+0xd4>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    167c:	cd09                	beqz	a0,1696 <countfree+0xe8>
      break;
    n += 1;
    167e:	2485                	addiw	s1,s1,1
  while(1){
    1680:	b7f5                	j	166c <countfree+0xbe>
    1682:	e852                	sd	s4,16(sp)
      printf("read() failed in countfree()\n");
    1684:	00001517          	auipc	a0,0x1
    1688:	43450513          	addi	a0,a0,1076 # 2ab8 <malloc+0xabc>
    168c:	0b9000ef          	jal	1f44 <printf>
      exit(1);
    1690:	4505                	li	a0,1
    1692:	476000ef          	jal	1b08 <exit>
  }

  close(fds[0]);
    1696:	fc842503          	lw	a0,-56(s0)
    169a:	496000ef          	jal	1b30 <close>
  wait((int*)0);
    169e:	4501                	li	a0,0
    16a0:	470000ef          	jal	1b10 <wait>
  
  return n;
}
    16a4:	8526                	mv	a0,s1
    16a6:	74a2                	ld	s1,40(sp)
    16a8:	7902                	ld	s2,32(sp)
    16aa:	69e2                	ld	s3,24(sp)
    16ac:	70e2                	ld	ra,56(sp)
    16ae:	7442                	ld	s0,48(sp)
    16b0:	6121                	addi	sp,sp,64
    16b2:	8082                	ret

00000000000016b4 <main>:

int
main(int argc, char *argv[])
{
    16b4:	1101                	addi	sp,sp,-32
    16b6:	ec06                	sd	ra,24(sp)
    16b8:	e822                	sd	s0,16(sp)
    16ba:	1000                	addi	s0,sp,32
  if(argc != 2)
    16bc:	4789                	li	a5,2
    16be:	00f50563          	beq	a0,a5,16c8 <main+0x14>
    16c2:	e426                	sd	s1,8(sp)
    usage();
    16c4:	e59ff0ef          	jal	151c <usage>
    16c8:	e426                	sd	s1,8(sp)
    16ca:	84ae                	mv	s1,a1

  if(strcmp(argv[1], "txone") == 0){
    16cc:	00001597          	auipc	a1,0x1
    16d0:	40c58593          	addi	a1,a1,1036 # 2ad8 <malloc+0xadc>
    16d4:	6488                	ld	a0,8(s1)
    16d6:	19a000ef          	jal	1870 <strcmp>
    16da:	e511                	bnez	a0,16e6 <main+0x32>
    txone();
    16dc:	925fe0ef          	jal	0 <txone>
    dns();
  } else {
    usage();
  }

  exit(0);
    16e0:	4501                	li	a0,0
    16e2:	426000ef          	jal	1b08 <exit>
  } else if(strcmp(argv[1], "rxone") == 0){
    16e6:	00001597          	auipc	a1,0x1
    16ea:	3fa58593          	addi	a1,a1,1018 # 2ae0 <malloc+0xae4>
    16ee:	6488                	ld	a0,8(s1)
    16f0:	180000ef          	jal	1870 <strcmp>
    16f4:	e501                	bnez	a0,16fc <main+0x48>
    rxone();
    16f6:	97dfe0ef          	jal	72 <rxone>
    16fa:	b7dd                	j	16e0 <main+0x2c>
  }else if(strcmp(argv[1], "rx") == 0 || strcmp(argv[1], "rxburst") == 0){
    16fc:	00001597          	auipc	a1,0x1
    1700:	3ec58593          	addi	a1,a1,1004 # 2ae8 <malloc+0xaec>
    1704:	6488                	ld	a0,8(s1)
    1706:	16a000ef          	jal	1870 <strcmp>
    170a:	c909                	beqz	a0,171c <main+0x68>
    170c:	00001597          	auipc	a1,0x1
    1710:	3e458593          	addi	a1,a1,996 # 2af0 <malloc+0xaf4>
    1714:	6488                	ld	a0,8(s1)
    1716:	15a000ef          	jal	1870 <strcmp>
    171a:	e509                	bnez	a0,1724 <main+0x70>
    rx(argv[1]);
    171c:	6488                	ld	a0,8(s1)
    171e:	a43fe0ef          	jal	160 <rx>
    1722:	bf7d                	j	16e0 <main+0x2c>
  } else if(strcmp(argv[1], "rx2") == 0){
    1724:	00001597          	auipc	a1,0x1
    1728:	3d458593          	addi	a1,a1,980 # 2af8 <malloc+0xafc>
    172c:	6488                	ld	a0,8(s1)
    172e:	142000ef          	jal	1870 <strcmp>
    1732:	e501                	bnez	a0,173a <main+0x86>
    rx2();
    1734:	c55fe0ef          	jal	388 <rx2>
    1738:	b765                	j	16e0 <main+0x2c>
  } else if(strcmp(argv[1], "tx") == 0){
    173a:	00001597          	auipc	a1,0x1
    173e:	3c658593          	addi	a1,a1,966 # 2b00 <malloc+0xb04>
    1742:	6488                	ld	a0,8(s1)
    1744:	12c000ef          	jal	1870 <strcmp>
    1748:	e501                	bnez	a0,1750 <main+0x9c>
    tx();
    174a:	f29fe0ef          	jal	672 <tx>
    174e:	bf49                	j	16e0 <main+0x2c>
  } else if(strcmp(argv[1], "ping0") == 0){
    1750:	00001597          	auipc	a1,0x1
    1754:	ca858593          	addi	a1,a1,-856 # 23f8 <malloc+0x3fc>
    1758:	6488                	ld	a0,8(s1)
    175a:	116000ef          	jal	1870 <strcmp>
    175e:	e501                	bnez	a0,1766 <main+0xb2>
    ping0();
    1760:	fabfe0ef          	jal	70a <ping0>
    1764:	bfb5                	j	16e0 <main+0x2c>
  } else if(strcmp(argv[1], "ping1") == 0){
    1766:	00001597          	auipc	a1,0x1
    176a:	3a258593          	addi	a1,a1,930 # 2b08 <malloc+0xb0c>
    176e:	6488                	ld	a0,8(s1)
    1770:	100000ef          	jal	1870 <strcmp>
    1774:	e501                	bnez	a0,177c <main+0xc8>
    ping1();
    1776:	8e0ff0ef          	jal	856 <ping1>
    177a:	b79d                	j	16e0 <main+0x2c>
  } else if(strcmp(argv[1], "ping2") == 0){
    177c:	00001597          	auipc	a1,0x1
    1780:	39458593          	addi	a1,a1,916 # 2b10 <malloc+0xb14>
    1784:	6488                	ld	a0,8(s1)
    1786:	0ea000ef          	jal	1870 <strcmp>
    178a:	e501                	bnez	a0,1792 <main+0xde>
    ping2();
    178c:	a38ff0ef          	jal	9c4 <ping2>
    1790:	bf81                	j	16e0 <main+0x2c>
  } else if(strcmp(argv[1], "ping3") == 0){
    1792:	00001597          	auipc	a1,0x1
    1796:	38658593          	addi	a1,a1,902 # 2b18 <malloc+0xb1c>
    179a:	6488                	ld	a0,8(s1)
    179c:	0d4000ef          	jal	1870 <strcmp>
    17a0:	e501                	bnez	a0,17a8 <main+0xf4>
    ping3();
    17a2:	c3aff0ef          	jal	bdc <ping3>
    17a6:	bf2d                	j	16e0 <main+0x2c>
  } else if(strcmp(argv[1], "grade") == 0){
    17a8:	00001597          	auipc	a1,0x1
    17ac:	37858593          	addi	a1,a1,888 # 2b20 <malloc+0xb24>
    17b0:	6488                	ld	a0,8(s1)
    17b2:	0be000ef          	jal	1870 <strcmp>
    17b6:	e925                	bnez	a0,1826 <main+0x172>
    int free0 = countfree();
    17b8:	df7ff0ef          	jal	15ae <countfree>
    17bc:	84aa                	mv	s1,a0
    txone();
    17be:	843fe0ef          	jal	0 <txone>
    pause(2);
    17c2:	4509                	li	a0,2
    17c4:	3d4000ef          	jal	1b98 <pause>
    ping0();
    17c8:	f43fe0ef          	jal	70a <ping0>
    pause(2);
    17cc:	4509                	li	a0,2
    17ce:	3ca000ef          	jal	1b98 <pause>
    ping1();
    17d2:	884ff0ef          	jal	856 <ping1>
    pause(2);
    17d6:	4509                	li	a0,2
    17d8:	3c0000ef          	jal	1b98 <pause>
    ping2();
    17dc:	9e8ff0ef          	jal	9c4 <ping2>
    pause(2);
    17e0:	4509                	li	a0,2
    17e2:	3b6000ef          	jal	1b98 <pause>
    ping3();
    17e6:	bf6ff0ef          	jal	bdc <ping3>
    pause(2);
    17ea:	4509                	li	a0,2
    17ec:	3ac000ef          	jal	1b98 <pause>
    dns();
    17f0:	c49ff0ef          	jal	1438 <dns>
    pause(2);
    17f4:	4509                	li	a0,2
    17f6:	3a2000ef          	jal	1b98 <pause>
    if ((free1 = countfree()) + 32 < free0) {
    17fa:	db5ff0ef          	jal	15ae <countfree>
    17fe:	85aa                	mv	a1,a0
    1800:	0205079b          	addiw	a5,a0,32
    1804:	0097da63          	bge	a5,s1,1818 <main+0x164>
      printf("free: FAILED -- lost too many free pages %d (out of %d)\n", free1, free0);
    1808:	8626                	mv	a2,s1
    180a:	00001517          	auipc	a0,0x1
    180e:	31e50513          	addi	a0,a0,798 # 2b28 <malloc+0xb2c>
    1812:	732000ef          	jal	1f44 <printf>
    1816:	b5e9                	j	16e0 <main+0x2c>
      printf("free: OK\n");
    1818:	00001517          	auipc	a0,0x1
    181c:	35050513          	addi	a0,a0,848 # 2b68 <malloc+0xb6c>
    1820:	724000ef          	jal	1f44 <printf>
    1824:	bd75                	j	16e0 <main+0x2c>
  } else if(strcmp(argv[1], "dns") == 0){
    1826:	00001597          	auipc	a1,0x1
    182a:	35258593          	addi	a1,a1,850 # 2b78 <malloc+0xb7c>
    182e:	6488                	ld	a0,8(s1)
    1830:	040000ef          	jal	1870 <strcmp>
    1834:	e501                	bnez	a0,183c <main+0x188>
    dns();
    1836:	c03ff0ef          	jal	1438 <dns>
    183a:	b55d                	j	16e0 <main+0x2c>
    usage();
    183c:	ce1ff0ef          	jal	151c <usage>

0000000000001840 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    1840:	1141                	addi	sp,sp,-16
    1842:	e406                	sd	ra,8(sp)
    1844:	e022                	sd	s0,0(sp)
    1846:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    1848:	e6dff0ef          	jal	16b4 <main>
  exit(r);
    184c:	2bc000ef          	jal	1b08 <exit>

0000000000001850 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    1850:	1141                	addi	sp,sp,-16
    1852:	e406                	sd	ra,8(sp)
    1854:	e022                	sd	s0,0(sp)
    1856:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1858:	87aa                	mv	a5,a0
    185a:	0585                	addi	a1,a1,1
    185c:	0785                	addi	a5,a5,1
    185e:	fff5c703          	lbu	a4,-1(a1)
    1862:	fee78fa3          	sb	a4,-1(a5)
    1866:	fb75                	bnez	a4,185a <strcpy+0xa>
    ;
  return os;
}
    1868:	60a2                	ld	ra,8(sp)
    186a:	6402                	ld	s0,0(sp)
    186c:	0141                	addi	sp,sp,16
    186e:	8082                	ret

0000000000001870 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1870:	1141                	addi	sp,sp,-16
    1872:	e406                	sd	ra,8(sp)
    1874:	e022                	sd	s0,0(sp)
    1876:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1878:	00054783          	lbu	a5,0(a0)
    187c:	cb91                	beqz	a5,1890 <strcmp+0x20>
    187e:	0005c703          	lbu	a4,0(a1)
    1882:	00f71763          	bne	a4,a5,1890 <strcmp+0x20>
    p++, q++;
    1886:	0505                	addi	a0,a0,1
    1888:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    188a:	00054783          	lbu	a5,0(a0)
    188e:	fbe5                	bnez	a5,187e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    1890:	0005c503          	lbu	a0,0(a1)
}
    1894:	40a7853b          	subw	a0,a5,a0
    1898:	60a2                	ld	ra,8(sp)
    189a:	6402                	ld	s0,0(sp)
    189c:	0141                	addi	sp,sp,16
    189e:	8082                	ret

00000000000018a0 <strlen>:

uint
strlen(const char *s)
{
    18a0:	1141                	addi	sp,sp,-16
    18a2:	e406                	sd	ra,8(sp)
    18a4:	e022                	sd	s0,0(sp)
    18a6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    18a8:	00054783          	lbu	a5,0(a0)
    18ac:	cf99                	beqz	a5,18ca <strlen+0x2a>
    18ae:	0505                	addi	a0,a0,1
    18b0:	87aa                	mv	a5,a0
    18b2:	86be                	mv	a3,a5
    18b4:	0785                	addi	a5,a5,1
    18b6:	fff7c703          	lbu	a4,-1(a5)
    18ba:	ff65                	bnez	a4,18b2 <strlen+0x12>
    18bc:	40a6853b          	subw	a0,a3,a0
    18c0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    18c2:	60a2                	ld	ra,8(sp)
    18c4:	6402                	ld	s0,0(sp)
    18c6:	0141                	addi	sp,sp,16
    18c8:	8082                	ret
  for(n = 0; s[n]; n++)
    18ca:	4501                	li	a0,0
    18cc:	bfdd                	j	18c2 <strlen+0x22>

00000000000018ce <memset>:

void*
memset(void *dst, int c, uint n)
{
    18ce:	1141                	addi	sp,sp,-16
    18d0:	e406                	sd	ra,8(sp)
    18d2:	e022                	sd	s0,0(sp)
    18d4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    18d6:	ca19                	beqz	a2,18ec <memset+0x1e>
    18d8:	87aa                	mv	a5,a0
    18da:	1602                	slli	a2,a2,0x20
    18dc:	9201                	srli	a2,a2,0x20
    18de:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    18e2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    18e6:	0785                	addi	a5,a5,1
    18e8:	fee79de3          	bne	a5,a4,18e2 <memset+0x14>
  }
  return dst;
}
    18ec:	60a2                	ld	ra,8(sp)
    18ee:	6402                	ld	s0,0(sp)
    18f0:	0141                	addi	sp,sp,16
    18f2:	8082                	ret

00000000000018f4 <strchr>:

char*
strchr(const char *s, char c)
{
    18f4:	1141                	addi	sp,sp,-16
    18f6:	e406                	sd	ra,8(sp)
    18f8:	e022                	sd	s0,0(sp)
    18fa:	0800                	addi	s0,sp,16
  for(; *s; s++)
    18fc:	00054783          	lbu	a5,0(a0)
    1900:	cf81                	beqz	a5,1918 <strchr+0x24>
    if(*s == c)
    1902:	00f58763          	beq	a1,a5,1910 <strchr+0x1c>
  for(; *s; s++)
    1906:	0505                	addi	a0,a0,1
    1908:	00054783          	lbu	a5,0(a0)
    190c:	fbfd                	bnez	a5,1902 <strchr+0xe>
      return (char*)s;
  return 0;
    190e:	4501                	li	a0,0
}
    1910:	60a2                	ld	ra,8(sp)
    1912:	6402                	ld	s0,0(sp)
    1914:	0141                	addi	sp,sp,16
    1916:	8082                	ret
  return 0;
    1918:	4501                	li	a0,0
    191a:	bfdd                	j	1910 <strchr+0x1c>

000000000000191c <gets>:

char*
gets(char *buf, int max)
{
    191c:	7159                	addi	sp,sp,-112
    191e:	f486                	sd	ra,104(sp)
    1920:	f0a2                	sd	s0,96(sp)
    1922:	eca6                	sd	s1,88(sp)
    1924:	e8ca                	sd	s2,80(sp)
    1926:	e4ce                	sd	s3,72(sp)
    1928:	e0d2                	sd	s4,64(sp)
    192a:	fc56                	sd	s5,56(sp)
    192c:	f85a                	sd	s6,48(sp)
    192e:	f45e                	sd	s7,40(sp)
    1930:	f062                	sd	s8,32(sp)
    1932:	ec66                	sd	s9,24(sp)
    1934:	e86a                	sd	s10,16(sp)
    1936:	1880                	addi	s0,sp,112
    1938:	8caa                	mv	s9,a0
    193a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    193c:	892a                	mv	s2,a0
    193e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    1940:	f9f40b13          	addi	s6,s0,-97
    1944:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1946:	4ba9                	li	s7,10
    1948:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
    194a:	8d26                	mv	s10,s1
    194c:	0014899b          	addiw	s3,s1,1
    1950:	84ce                	mv	s1,s3
    1952:	0349d563          	bge	s3,s4,197c <gets+0x60>
    cc = read(0, &c, 1);
    1956:	8656                	mv	a2,s5
    1958:	85da                	mv	a1,s6
    195a:	4501                	li	a0,0
    195c:	1c4000ef          	jal	1b20 <read>
    if(cc < 1)
    1960:	00a05e63          	blez	a0,197c <gets+0x60>
    buf[i++] = c;
    1964:	f9f44783          	lbu	a5,-97(s0)
    1968:	00f90023          	sb	a5,0(s2) # 1000 <decode_qname>
    if(c == '\n' || c == '\r')
    196c:	01778763          	beq	a5,s7,197a <gets+0x5e>
    1970:	0905                	addi	s2,s2,1
    1972:	fd879ce3          	bne	a5,s8,194a <gets+0x2e>
    buf[i++] = c;
    1976:	8d4e                	mv	s10,s3
    1978:	a011                	j	197c <gets+0x60>
    197a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
    197c:	9d66                	add	s10,s10,s9
    197e:	000d0023          	sb	zero,0(s10)
  return buf;
}
    1982:	8566                	mv	a0,s9
    1984:	70a6                	ld	ra,104(sp)
    1986:	7406                	ld	s0,96(sp)
    1988:	64e6                	ld	s1,88(sp)
    198a:	6946                	ld	s2,80(sp)
    198c:	69a6                	ld	s3,72(sp)
    198e:	6a06                	ld	s4,64(sp)
    1990:	7ae2                	ld	s5,56(sp)
    1992:	7b42                	ld	s6,48(sp)
    1994:	7ba2                	ld	s7,40(sp)
    1996:	7c02                	ld	s8,32(sp)
    1998:	6ce2                	ld	s9,24(sp)
    199a:	6d42                	ld	s10,16(sp)
    199c:	6165                	addi	sp,sp,112
    199e:	8082                	ret

00000000000019a0 <stat>:

int
stat(const char *n, struct stat *st)
{
    19a0:	1101                	addi	sp,sp,-32
    19a2:	ec06                	sd	ra,24(sp)
    19a4:	e822                	sd	s0,16(sp)
    19a6:	e04a                	sd	s2,0(sp)
    19a8:	1000                	addi	s0,sp,32
    19aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    19ac:	4581                	li	a1,0
    19ae:	19a000ef          	jal	1b48 <open>
  if(fd < 0)
    19b2:	02054263          	bltz	a0,19d6 <stat+0x36>
    19b6:	e426                	sd	s1,8(sp)
    19b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    19ba:	85ca                	mv	a1,s2
    19bc:	1a4000ef          	jal	1b60 <fstat>
    19c0:	892a                	mv	s2,a0
  close(fd);
    19c2:	8526                	mv	a0,s1
    19c4:	16c000ef          	jal	1b30 <close>
  return r;
    19c8:	64a2                	ld	s1,8(sp)
}
    19ca:	854a                	mv	a0,s2
    19cc:	60e2                	ld	ra,24(sp)
    19ce:	6442                	ld	s0,16(sp)
    19d0:	6902                	ld	s2,0(sp)
    19d2:	6105                	addi	sp,sp,32
    19d4:	8082                	ret
    return -1;
    19d6:	597d                	li	s2,-1
    19d8:	bfcd                	j	19ca <stat+0x2a>

00000000000019da <atoi>:

int
atoi(const char *s)
{
    19da:	1141                	addi	sp,sp,-16
    19dc:	e406                	sd	ra,8(sp)
    19de:	e022                	sd	s0,0(sp)
    19e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    19e2:	00054683          	lbu	a3,0(a0)
    19e6:	fd06879b          	addiw	a5,a3,-48
    19ea:	0ff7f793          	zext.b	a5,a5
    19ee:	4625                	li	a2,9
    19f0:	02f66963          	bltu	a2,a5,1a22 <atoi+0x48>
    19f4:	872a                	mv	a4,a0
  n = 0;
    19f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    19f8:	0705                	addi	a4,a4,1
    19fa:	0025179b          	slliw	a5,a0,0x2
    19fe:	9fa9                	addw	a5,a5,a0
    1a00:	0017979b          	slliw	a5,a5,0x1
    1a04:	9fb5                	addw	a5,a5,a3
    1a06:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    1a0a:	00074683          	lbu	a3,0(a4)
    1a0e:	fd06879b          	addiw	a5,a3,-48
    1a12:	0ff7f793          	zext.b	a5,a5
    1a16:	fef671e3          	bgeu	a2,a5,19f8 <atoi+0x1e>
  return n;
}
    1a1a:	60a2                	ld	ra,8(sp)
    1a1c:	6402                	ld	s0,0(sp)
    1a1e:	0141                	addi	sp,sp,16
    1a20:	8082                	ret
  n = 0;
    1a22:	4501                	li	a0,0
    1a24:	bfdd                	j	1a1a <atoi+0x40>

0000000000001a26 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1a26:	1141                	addi	sp,sp,-16
    1a28:	e406                	sd	ra,8(sp)
    1a2a:	e022                	sd	s0,0(sp)
    1a2c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    1a2e:	02b57563          	bgeu	a0,a1,1a58 <memmove+0x32>
    while(n-- > 0)
    1a32:	00c05f63          	blez	a2,1a50 <memmove+0x2a>
    1a36:	1602                	slli	a2,a2,0x20
    1a38:	9201                	srli	a2,a2,0x20
    1a3a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    1a3e:	872a                	mv	a4,a0
      *dst++ = *src++;
    1a40:	0585                	addi	a1,a1,1
    1a42:	0705                	addi	a4,a4,1
    1a44:	fff5c683          	lbu	a3,-1(a1)
    1a48:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    1a4c:	fee79ae3          	bne	a5,a4,1a40 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    1a50:	60a2                	ld	ra,8(sp)
    1a52:	6402                	ld	s0,0(sp)
    1a54:	0141                	addi	sp,sp,16
    1a56:	8082                	ret
    dst += n;
    1a58:	00c50733          	add	a4,a0,a2
    src += n;
    1a5c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    1a5e:	fec059e3          	blez	a2,1a50 <memmove+0x2a>
    1a62:	fff6079b          	addiw	a5,a2,-1
    1a66:	1782                	slli	a5,a5,0x20
    1a68:	9381                	srli	a5,a5,0x20
    1a6a:	fff7c793          	not	a5,a5
    1a6e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    1a70:	15fd                	addi	a1,a1,-1
    1a72:	177d                	addi	a4,a4,-1
    1a74:	0005c683          	lbu	a3,0(a1)
    1a78:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    1a7c:	fef71ae3          	bne	a4,a5,1a70 <memmove+0x4a>
    1a80:	bfc1                	j	1a50 <memmove+0x2a>

0000000000001a82 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1a82:	1141                	addi	sp,sp,-16
    1a84:	e406                	sd	ra,8(sp)
    1a86:	e022                	sd	s0,0(sp)
    1a88:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    1a8a:	ca0d                	beqz	a2,1abc <memcmp+0x3a>
    1a8c:	fff6069b          	addiw	a3,a2,-1
    1a90:	1682                	slli	a3,a3,0x20
    1a92:	9281                	srli	a3,a3,0x20
    1a94:	0685                	addi	a3,a3,1
    1a96:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1a98:	00054783          	lbu	a5,0(a0)
    1a9c:	0005c703          	lbu	a4,0(a1)
    1aa0:	00e79863          	bne	a5,a4,1ab0 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
    1aa4:	0505                	addi	a0,a0,1
    p2++;
    1aa6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    1aa8:	fed518e3          	bne	a0,a3,1a98 <memcmp+0x16>
  }
  return 0;
    1aac:	4501                	li	a0,0
    1aae:	a019                	j	1ab4 <memcmp+0x32>
      return *p1 - *p2;
    1ab0:	40e7853b          	subw	a0,a5,a4
}
    1ab4:	60a2                	ld	ra,8(sp)
    1ab6:	6402                	ld	s0,0(sp)
    1ab8:	0141                	addi	sp,sp,16
    1aba:	8082                	ret
  return 0;
    1abc:	4501                	li	a0,0
    1abe:	bfdd                	j	1ab4 <memcmp+0x32>

0000000000001ac0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    1ac0:	1141                	addi	sp,sp,-16
    1ac2:	e406                	sd	ra,8(sp)
    1ac4:	e022                	sd	s0,0(sp)
    1ac6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    1ac8:	f5fff0ef          	jal	1a26 <memmove>
}
    1acc:	60a2                	ld	ra,8(sp)
    1ace:	6402                	ld	s0,0(sp)
    1ad0:	0141                	addi	sp,sp,16
    1ad2:	8082                	ret

0000000000001ad4 <sbrk>:

char *
sbrk(int n) {
    1ad4:	1141                	addi	sp,sp,-16
    1ad6:	e406                	sd	ra,8(sp)
    1ad8:	e022                	sd	s0,0(sp)
    1ada:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    1adc:	4585                	li	a1,1
    1ade:	0b2000ef          	jal	1b90 <sys_sbrk>
}
    1ae2:	60a2                	ld	ra,8(sp)
    1ae4:	6402                	ld	s0,0(sp)
    1ae6:	0141                	addi	sp,sp,16
    1ae8:	8082                	ret

0000000000001aea <sbrklazy>:

char *
sbrklazy(int n) {
    1aea:	1141                	addi	sp,sp,-16
    1aec:	e406                	sd	ra,8(sp)
    1aee:	e022                	sd	s0,0(sp)
    1af0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    1af2:	4589                	li	a1,2
    1af4:	09c000ef          	jal	1b90 <sys_sbrk>
}
    1af8:	60a2                	ld	ra,8(sp)
    1afa:	6402                	ld	s0,0(sp)
    1afc:	0141                	addi	sp,sp,16
    1afe:	8082                	ret

0000000000001b00 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1b00:	4885                	li	a7,1
 ecall
    1b02:	00000073          	ecall
 ret
    1b06:	8082                	ret

0000000000001b08 <exit>:
.global exit
exit:
 li a7, SYS_exit
    1b08:	4889                	li	a7,2
 ecall
    1b0a:	00000073          	ecall
 ret
    1b0e:	8082                	ret

0000000000001b10 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1b10:	488d                	li	a7,3
 ecall
    1b12:	00000073          	ecall
 ret
    1b16:	8082                	ret

0000000000001b18 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1b18:	4891                	li	a7,4
 ecall
    1b1a:	00000073          	ecall
 ret
    1b1e:	8082                	ret

0000000000001b20 <read>:
.global read
read:
 li a7, SYS_read
    1b20:	4895                	li	a7,5
 ecall
    1b22:	00000073          	ecall
 ret
    1b26:	8082                	ret

0000000000001b28 <write>:
.global write
write:
 li a7, SYS_write
    1b28:	48c1                	li	a7,16
 ecall
    1b2a:	00000073          	ecall
 ret
    1b2e:	8082                	ret

0000000000001b30 <close>:
.global close
close:
 li a7, SYS_close
    1b30:	48d5                	li	a7,21
 ecall
    1b32:	00000073          	ecall
 ret
    1b36:	8082                	ret

0000000000001b38 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1b38:	4899                	li	a7,6
 ecall
    1b3a:	00000073          	ecall
 ret
    1b3e:	8082                	ret

0000000000001b40 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1b40:	489d                	li	a7,7
 ecall
    1b42:	00000073          	ecall
 ret
    1b46:	8082                	ret

0000000000001b48 <open>:
.global open
open:
 li a7, SYS_open
    1b48:	48bd                	li	a7,15
 ecall
    1b4a:	00000073          	ecall
 ret
    1b4e:	8082                	ret

0000000000001b50 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1b50:	48c5                	li	a7,17
 ecall
    1b52:	00000073          	ecall
 ret
    1b56:	8082                	ret

0000000000001b58 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1b58:	48c9                	li	a7,18
 ecall
    1b5a:	00000073          	ecall
 ret
    1b5e:	8082                	ret

0000000000001b60 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1b60:	48a1                	li	a7,8
 ecall
    1b62:	00000073          	ecall
 ret
    1b66:	8082                	ret

0000000000001b68 <link>:
.global link
link:
 li a7, SYS_link
    1b68:	48cd                	li	a7,19
 ecall
    1b6a:	00000073          	ecall
 ret
    1b6e:	8082                	ret

0000000000001b70 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1b70:	48d1                	li	a7,20
 ecall
    1b72:	00000073          	ecall
 ret
    1b76:	8082                	ret

0000000000001b78 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1b78:	48a5                	li	a7,9
 ecall
    1b7a:	00000073          	ecall
 ret
    1b7e:	8082                	ret

0000000000001b80 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1b80:	48a9                	li	a7,10
 ecall
    1b82:	00000073          	ecall
 ret
    1b86:	8082                	ret

0000000000001b88 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1b88:	48ad                	li	a7,11
 ecall
    1b8a:	00000073          	ecall
 ret
    1b8e:	8082                	ret

0000000000001b90 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    1b90:	48b1                	li	a7,12
 ecall
    1b92:	00000073          	ecall
 ret
    1b96:	8082                	ret

0000000000001b98 <pause>:
.global pause
pause:
 li a7, SYS_pause
    1b98:	48b5                	li	a7,13
 ecall
    1b9a:	00000073          	ecall
 ret
    1b9e:	8082                	ret

0000000000001ba0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1ba0:	48b9                	li	a7,14
 ecall
    1ba2:	00000073          	ecall
 ret
    1ba6:	8082                	ret

0000000000001ba8 <bind>:
.global bind
bind:
 li a7, SYS_bind
    1ba8:	48f5                	li	a7,29
 ecall
    1baa:	00000073          	ecall
 ret
    1bae:	8082                	ret

0000000000001bb0 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
    1bb0:	48f9                	li	a7,30
 ecall
    1bb2:	00000073          	ecall
 ret
    1bb6:	8082                	ret

0000000000001bb8 <send>:
.global send
send:
 li a7, SYS_send
    1bb8:	48fd                	li	a7,31
 ecall
    1bba:	00000073          	ecall
 ret
    1bbe:	8082                	ret

0000000000001bc0 <recv>:
.global recv
recv:
 li a7, SYS_recv
    1bc0:	02000893          	li	a7,32
 ecall
    1bc4:	00000073          	ecall
 ret
    1bc8:	8082                	ret

0000000000001bca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1bca:	1101                	addi	sp,sp,-32
    1bcc:	ec06                	sd	ra,24(sp)
    1bce:	e822                	sd	s0,16(sp)
    1bd0:	1000                	addi	s0,sp,32
    1bd2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1bd6:	4605                	li	a2,1
    1bd8:	fef40593          	addi	a1,s0,-17
    1bdc:	f4dff0ef          	jal	1b28 <write>
}
    1be0:	60e2                	ld	ra,24(sp)
    1be2:	6442                	ld	s0,16(sp)
    1be4:	6105                	addi	sp,sp,32
    1be6:	8082                	ret

0000000000001be8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    1be8:	715d                	addi	sp,sp,-80
    1bea:	e486                	sd	ra,72(sp)
    1bec:	e0a2                	sd	s0,64(sp)
    1bee:	fc26                	sd	s1,56(sp)
    1bf0:	f84a                	sd	s2,48(sp)
    1bf2:	f44e                	sd	s3,40(sp)
    1bf4:	0880                	addi	s0,sp,80
    1bf6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
    1bf8:	c299                	beqz	a3,1bfe <printint+0x16>
    1bfa:	0605cc63          	bltz	a1,1c72 <printint+0x8a>
  neg = 0;
    1bfe:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    1c00:	fb840313          	addi	t1,s0,-72
  neg = 0;
    1c04:	869a                	mv	a3,t1
  i = 0;
    1c06:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
    1c08:	00001817          	auipc	a6,0x1
    1c0c:	f8080813          	addi	a6,a6,-128 # 2b88 <digits>
    1c10:	88be                	mv	a7,a5
    1c12:	0017851b          	addiw	a0,a5,1
    1c16:	87aa                	mv	a5,a0
    1c18:	02c5f733          	remu	a4,a1,a2
    1c1c:	9742                	add	a4,a4,a6
    1c1e:	00074703          	lbu	a4,0(a4)
    1c22:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
    1c26:	872e                	mv	a4,a1
    1c28:	02c5d5b3          	divu	a1,a1,a2
    1c2c:	0685                	addi	a3,a3,1
    1c2e:	fec771e3          	bgeu	a4,a2,1c10 <printint+0x28>
  if(neg)
    1c32:	000e0c63          	beqz	t3,1c4a <printint+0x62>
    buf[i++] = '-';
    1c36:	fd050793          	addi	a5,a0,-48
    1c3a:	00878533          	add	a0,a5,s0
    1c3e:	02d00793          	li	a5,45
    1c42:	fef50423          	sb	a5,-24(a0)
    1c46:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    1c4a:	fff7899b          	addiw	s3,a5,-1
    1c4e:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
    1c52:	fff4c583          	lbu	a1,-1(s1)
    1c56:	854a                	mv	a0,s2
    1c58:	f73ff0ef          	jal	1bca <putc>
  while(--i >= 0)
    1c5c:	39fd                	addiw	s3,s3,-1
    1c5e:	14fd                	addi	s1,s1,-1
    1c60:	fe09d9e3          	bgez	s3,1c52 <printint+0x6a>
}
    1c64:	60a6                	ld	ra,72(sp)
    1c66:	6406                	ld	s0,64(sp)
    1c68:	74e2                	ld	s1,56(sp)
    1c6a:	7942                	ld	s2,48(sp)
    1c6c:	79a2                	ld	s3,40(sp)
    1c6e:	6161                	addi	sp,sp,80
    1c70:	8082                	ret
    x = -xx;
    1c72:	40b005b3          	neg	a1,a1
    neg = 1;
    1c76:	4e05                	li	t3,1
    x = -xx;
    1c78:	b761                	j	1c00 <printint+0x18>

0000000000001c7a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1c7a:	711d                	addi	sp,sp,-96
    1c7c:	ec86                	sd	ra,88(sp)
    1c7e:	e8a2                	sd	s0,80(sp)
    1c80:	e4a6                	sd	s1,72(sp)
    1c82:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1c84:	0005c483          	lbu	s1,0(a1)
    1c88:	28048463          	beqz	s1,1f10 <vprintf+0x296>
    1c8c:	e0ca                	sd	s2,64(sp)
    1c8e:	fc4e                	sd	s3,56(sp)
    1c90:	f852                	sd	s4,48(sp)
    1c92:	f456                	sd	s5,40(sp)
    1c94:	f05a                	sd	s6,32(sp)
    1c96:	ec5e                	sd	s7,24(sp)
    1c98:	e862                	sd	s8,16(sp)
    1c9a:	e466                	sd	s9,8(sp)
    1c9c:	8b2a                	mv	s6,a0
    1c9e:	8a2e                	mv	s4,a1
    1ca0:	8bb2                	mv	s7,a2
  state = 0;
    1ca2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    1ca4:	4901                	li	s2,0
    1ca6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    1ca8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1cac:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    1cb0:	06c00c93          	li	s9,108
    1cb4:	a00d                	j	1cd6 <vprintf+0x5c>
        putc(fd, c0);
    1cb6:	85a6                	mv	a1,s1
    1cb8:	855a                	mv	a0,s6
    1cba:	f11ff0ef          	jal	1bca <putc>
    1cbe:	a019                	j	1cc4 <vprintf+0x4a>
    } else if(state == '%'){
    1cc0:	03598363          	beq	s3,s5,1ce6 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
    1cc4:	0019079b          	addiw	a5,s2,1
    1cc8:	893e                	mv	s2,a5
    1cca:	873e                	mv	a4,a5
    1ccc:	97d2                	add	a5,a5,s4
    1cce:	0007c483          	lbu	s1,0(a5)
    1cd2:	22048763          	beqz	s1,1f00 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
    1cd6:	0004879b          	sext.w	a5,s1
    if(state == 0){
    1cda:	fe0993e3          	bnez	s3,1cc0 <vprintf+0x46>
      if(c0 == '%'){
    1cde:	fd579ce3          	bne	a5,s5,1cb6 <vprintf+0x3c>
        state = '%';
    1ce2:	89be                	mv	s3,a5
    1ce4:	b7c5                	j	1cc4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    1ce6:	00ea06b3          	add	a3,s4,a4
    1cea:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    1cee:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    1cf0:	c681                	beqz	a3,1cf8 <vprintf+0x7e>
    1cf2:	9752                	add	a4,a4,s4
    1cf4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    1cf8:	05878263          	beq	a5,s8,1d3c <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
    1cfc:	05978c63          	beq	a5,s9,1d54 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1d00:	07500713          	li	a4,117
    1d04:	0ee78663          	beq	a5,a4,1df0 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    1d08:	07800713          	li	a4,120
    1d0c:	12e78863          	beq	a5,a4,1e3c <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1d10:	07000713          	li	a4,112
    1d14:	14e78d63          	beq	a5,a4,1e6e <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
    1d18:	06300713          	li	a4,99
    1d1c:	18e78c63          	beq	a5,a4,1eb4 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
    1d20:	07300713          	li	a4,115
    1d24:	1ae78263          	beq	a5,a4,1ec8 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1d28:	02500713          	li	a4,37
    1d2c:	04e79463          	bne	a5,a4,1d74 <vprintf+0xfa>
        putc(fd, '%');
    1d30:	85ba                	mv	a1,a4
    1d32:	855a                	mv	a0,s6
    1d34:	e97ff0ef          	jal	1bca <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    1d38:	4981                	li	s3,0
    1d3a:	b769                	j	1cc4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    1d3c:	008b8493          	addi	s1,s7,8
    1d40:	4685                	li	a3,1
    1d42:	4629                	li	a2,10
    1d44:	000ba583          	lw	a1,0(s7)
    1d48:	855a                	mv	a0,s6
    1d4a:	e9fff0ef          	jal	1be8 <printint>
    1d4e:	8ba6                	mv	s7,s1
      state = 0;
    1d50:	4981                	li	s3,0
    1d52:	bf8d                	j	1cc4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1d54:	06400793          	li	a5,100
    1d58:	02f68963          	beq	a3,a5,1d8a <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1d5c:	06c00793          	li	a5,108
    1d60:	04f68263          	beq	a3,a5,1da4 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
    1d64:	07500793          	li	a5,117
    1d68:	0af68063          	beq	a3,a5,1e08 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
    1d6c:	07800793          	li	a5,120
    1d70:	0ef68263          	beq	a3,a5,1e54 <vprintf+0x1da>
        putc(fd, '%');
    1d74:	02500593          	li	a1,37
    1d78:	855a                	mv	a0,s6
    1d7a:	e51ff0ef          	jal	1bca <putc>
        putc(fd, c0);
    1d7e:	85a6                	mv	a1,s1
    1d80:	855a                	mv	a0,s6
    1d82:	e49ff0ef          	jal	1bca <putc>
      state = 0;
    1d86:	4981                	li	s3,0
    1d88:	bf35                	j	1cc4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1d8a:	008b8493          	addi	s1,s7,8
    1d8e:	4685                	li	a3,1
    1d90:	4629                	li	a2,10
    1d92:	000bb583          	ld	a1,0(s7)
    1d96:	855a                	mv	a0,s6
    1d98:	e51ff0ef          	jal	1be8 <printint>
        i += 1;
    1d9c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1d9e:	8ba6                	mv	s7,s1
      state = 0;
    1da0:	4981                	li	s3,0
        i += 1;
    1da2:	b70d                	j	1cc4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1da4:	06400793          	li	a5,100
    1da8:	02f60763          	beq	a2,a5,1dd6 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1dac:	07500793          	li	a5,117
    1db0:	06f60963          	beq	a2,a5,1e22 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1db4:	07800793          	li	a5,120
    1db8:	faf61ee3          	bne	a2,a5,1d74 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1dbc:	008b8493          	addi	s1,s7,8
    1dc0:	4681                	li	a3,0
    1dc2:	4641                	li	a2,16
    1dc4:	000bb583          	ld	a1,0(s7)
    1dc8:	855a                	mv	a0,s6
    1dca:	e1fff0ef          	jal	1be8 <printint>
        i += 2;
    1dce:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1dd0:	8ba6                	mv	s7,s1
      state = 0;
    1dd2:	4981                	li	s3,0
        i += 2;
    1dd4:	bdc5                	j	1cc4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1dd6:	008b8493          	addi	s1,s7,8
    1dda:	4685                	li	a3,1
    1ddc:	4629                	li	a2,10
    1dde:	000bb583          	ld	a1,0(s7)
    1de2:	855a                	mv	a0,s6
    1de4:	e05ff0ef          	jal	1be8 <printint>
        i += 2;
    1de8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    1dea:	8ba6                	mv	s7,s1
      state = 0;
    1dec:	4981                	li	s3,0
        i += 2;
    1dee:	bdd9                	j	1cc4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
    1df0:	008b8493          	addi	s1,s7,8
    1df4:	4681                	li	a3,0
    1df6:	4629                	li	a2,10
    1df8:	000be583          	lwu	a1,0(s7)
    1dfc:	855a                	mv	a0,s6
    1dfe:	debff0ef          	jal	1be8 <printint>
    1e02:	8ba6                	mv	s7,s1
      state = 0;
    1e04:	4981                	li	s3,0
    1e06:	bd7d                	j	1cc4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1e08:	008b8493          	addi	s1,s7,8
    1e0c:	4681                	li	a3,0
    1e0e:	4629                	li	a2,10
    1e10:	000bb583          	ld	a1,0(s7)
    1e14:	855a                	mv	a0,s6
    1e16:	dd3ff0ef          	jal	1be8 <printint>
        i += 1;
    1e1a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1e1c:	8ba6                	mv	s7,s1
      state = 0;
    1e1e:	4981                	li	s3,0
        i += 1;
    1e20:	b555                	j	1cc4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1e22:	008b8493          	addi	s1,s7,8
    1e26:	4681                	li	a3,0
    1e28:	4629                	li	a2,10
    1e2a:	000bb583          	ld	a1,0(s7)
    1e2e:	855a                	mv	a0,s6
    1e30:	db9ff0ef          	jal	1be8 <printint>
        i += 2;
    1e34:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1e36:	8ba6                	mv	s7,s1
      state = 0;
    1e38:	4981                	li	s3,0
        i += 2;
    1e3a:	b569                	j	1cc4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
    1e3c:	008b8493          	addi	s1,s7,8
    1e40:	4681                	li	a3,0
    1e42:	4641                	li	a2,16
    1e44:	000be583          	lwu	a1,0(s7)
    1e48:	855a                	mv	a0,s6
    1e4a:	d9fff0ef          	jal	1be8 <printint>
    1e4e:	8ba6                	mv	s7,s1
      state = 0;
    1e50:	4981                	li	s3,0
    1e52:	bd8d                	j	1cc4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1e54:	008b8493          	addi	s1,s7,8
    1e58:	4681                	li	a3,0
    1e5a:	4641                	li	a2,16
    1e5c:	000bb583          	ld	a1,0(s7)
    1e60:	855a                	mv	a0,s6
    1e62:	d87ff0ef          	jal	1be8 <printint>
        i += 1;
    1e66:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1e68:	8ba6                	mv	s7,s1
      state = 0;
    1e6a:	4981                	li	s3,0
        i += 1;
    1e6c:	bda1                	j	1cc4 <vprintf+0x4a>
    1e6e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1e70:	008b8d13          	addi	s10,s7,8
    1e74:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1e78:	03000593          	li	a1,48
    1e7c:	855a                	mv	a0,s6
    1e7e:	d4dff0ef          	jal	1bca <putc>
  putc(fd, 'x');
    1e82:	07800593          	li	a1,120
    1e86:	855a                	mv	a0,s6
    1e88:	d43ff0ef          	jal	1bca <putc>
    1e8c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1e8e:	00001b97          	auipc	s7,0x1
    1e92:	cfab8b93          	addi	s7,s7,-774 # 2b88 <digits>
    1e96:	03c9d793          	srli	a5,s3,0x3c
    1e9a:	97de                	add	a5,a5,s7
    1e9c:	0007c583          	lbu	a1,0(a5)
    1ea0:	855a                	mv	a0,s6
    1ea2:	d29ff0ef          	jal	1bca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1ea6:	0992                	slli	s3,s3,0x4
    1ea8:	34fd                	addiw	s1,s1,-1
    1eaa:	f4f5                	bnez	s1,1e96 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
    1eac:	8bea                	mv	s7,s10
      state = 0;
    1eae:	4981                	li	s3,0
    1eb0:	6d02                	ld	s10,0(sp)
    1eb2:	bd09                	j	1cc4 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    1eb4:	008b8493          	addi	s1,s7,8
    1eb8:	000bc583          	lbu	a1,0(s7)
    1ebc:	855a                	mv	a0,s6
    1ebe:	d0dff0ef          	jal	1bca <putc>
    1ec2:	8ba6                	mv	s7,s1
      state = 0;
    1ec4:	4981                	li	s3,0
    1ec6:	bbfd                	j	1cc4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1ec8:	008b8993          	addi	s3,s7,8
    1ecc:	000bb483          	ld	s1,0(s7)
    1ed0:	cc91                	beqz	s1,1eec <vprintf+0x272>
        for(; *s; s++)
    1ed2:	0004c583          	lbu	a1,0(s1)
    1ed6:	c195                	beqz	a1,1efa <vprintf+0x280>
          putc(fd, *s);
    1ed8:	855a                	mv	a0,s6
    1eda:	cf1ff0ef          	jal	1bca <putc>
        for(; *s; s++)
    1ede:	0485                	addi	s1,s1,1
    1ee0:	0004c583          	lbu	a1,0(s1)
    1ee4:	f9f5                	bnez	a1,1ed8 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
    1ee6:	8bce                	mv	s7,s3
      state = 0;
    1ee8:	4981                	li	s3,0
    1eea:	bbe9                	j	1cc4 <vprintf+0x4a>
          s = "(null)";
    1eec:	00001497          	auipc	s1,0x1
    1ef0:	c9448493          	addi	s1,s1,-876 # 2b80 <malloc+0xb84>
        for(; *s; s++)
    1ef4:	02800593          	li	a1,40
    1ef8:	b7c5                	j	1ed8 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
    1efa:	8bce                	mv	s7,s3
      state = 0;
    1efc:	4981                	li	s3,0
    1efe:	b3d9                	j	1cc4 <vprintf+0x4a>
    1f00:	6906                	ld	s2,64(sp)
    1f02:	79e2                	ld	s3,56(sp)
    1f04:	7a42                	ld	s4,48(sp)
    1f06:	7aa2                	ld	s5,40(sp)
    1f08:	7b02                	ld	s6,32(sp)
    1f0a:	6be2                	ld	s7,24(sp)
    1f0c:	6c42                	ld	s8,16(sp)
    1f0e:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1f10:	60e6                	ld	ra,88(sp)
    1f12:	6446                	ld	s0,80(sp)
    1f14:	64a6                	ld	s1,72(sp)
    1f16:	6125                	addi	sp,sp,96
    1f18:	8082                	ret

0000000000001f1a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1f1a:	715d                	addi	sp,sp,-80
    1f1c:	ec06                	sd	ra,24(sp)
    1f1e:	e822                	sd	s0,16(sp)
    1f20:	1000                	addi	s0,sp,32
    1f22:	e010                	sd	a2,0(s0)
    1f24:	e414                	sd	a3,8(s0)
    1f26:	e818                	sd	a4,16(s0)
    1f28:	ec1c                	sd	a5,24(s0)
    1f2a:	03043023          	sd	a6,32(s0)
    1f2e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1f32:	8622                	mv	a2,s0
    1f34:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1f38:	d43ff0ef          	jal	1c7a <vprintf>
}
    1f3c:	60e2                	ld	ra,24(sp)
    1f3e:	6442                	ld	s0,16(sp)
    1f40:	6161                	addi	sp,sp,80
    1f42:	8082                	ret

0000000000001f44 <printf>:

void
printf(const char *fmt, ...)
{
    1f44:	711d                	addi	sp,sp,-96
    1f46:	ec06                	sd	ra,24(sp)
    1f48:	e822                	sd	s0,16(sp)
    1f4a:	1000                	addi	s0,sp,32
    1f4c:	e40c                	sd	a1,8(s0)
    1f4e:	e810                	sd	a2,16(s0)
    1f50:	ec14                	sd	a3,24(s0)
    1f52:	f018                	sd	a4,32(s0)
    1f54:	f41c                	sd	a5,40(s0)
    1f56:	03043823          	sd	a6,48(s0)
    1f5a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1f5e:	00840613          	addi	a2,s0,8
    1f62:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1f66:	85aa                	mv	a1,a0
    1f68:	4505                	li	a0,1
    1f6a:	d11ff0ef          	jal	1c7a <vprintf>
}
    1f6e:	60e2                	ld	ra,24(sp)
    1f70:	6442                	ld	s0,16(sp)
    1f72:	6125                	addi	sp,sp,96
    1f74:	8082                	ret

0000000000001f76 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1f76:	1141                	addi	sp,sp,-16
    1f78:	e406                	sd	ra,8(sp)
    1f7a:	e022                	sd	s0,0(sp)
    1f7c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1f7e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1f82:	00001797          	auipc	a5,0x1
    1f86:	07e7b783          	ld	a5,126(a5) # 3000 <freep>
    1f8a:	a02d                	j	1fb4 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1f8c:	4618                	lw	a4,8(a2)
    1f8e:	9f2d                	addw	a4,a4,a1
    1f90:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1f94:	6398                	ld	a4,0(a5)
    1f96:	6310                	ld	a2,0(a4)
    1f98:	a83d                	j	1fd6 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1f9a:	ff852703          	lw	a4,-8(a0)
    1f9e:	9f31                	addw	a4,a4,a2
    1fa0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1fa2:	ff053683          	ld	a3,-16(a0)
    1fa6:	a091                	j	1fea <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1fa8:	6398                	ld	a4,0(a5)
    1faa:	00e7e463          	bltu	a5,a4,1fb2 <free+0x3c>
    1fae:	00e6ea63          	bltu	a3,a4,1fc2 <free+0x4c>
{
    1fb2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1fb4:	fed7fae3          	bgeu	a5,a3,1fa8 <free+0x32>
    1fb8:	6398                	ld	a4,0(a5)
    1fba:	00e6e463          	bltu	a3,a4,1fc2 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1fbe:	fee7eae3          	bltu	a5,a4,1fb2 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    1fc2:	ff852583          	lw	a1,-8(a0)
    1fc6:	6390                	ld	a2,0(a5)
    1fc8:	02059813          	slli	a6,a1,0x20
    1fcc:	01c85713          	srli	a4,a6,0x1c
    1fd0:	9736                	add	a4,a4,a3
    1fd2:	fae60de3          	beq	a2,a4,1f8c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    1fd6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1fda:	4790                	lw	a2,8(a5)
    1fdc:	02061593          	slli	a1,a2,0x20
    1fe0:	01c5d713          	srli	a4,a1,0x1c
    1fe4:	973e                	add	a4,a4,a5
    1fe6:	fae68ae3          	beq	a3,a4,1f9a <free+0x24>
    p->s.ptr = bp->s.ptr;
    1fea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1fec:	00001717          	auipc	a4,0x1
    1ff0:	00f73a23          	sd	a5,20(a4) # 3000 <freep>
}
    1ff4:	60a2                	ld	ra,8(sp)
    1ff6:	6402                	ld	s0,0(sp)
    1ff8:	0141                	addi	sp,sp,16
    1ffa:	8082                	ret

0000000000001ffc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1ffc:	7139                	addi	sp,sp,-64
    1ffe:	fc06                	sd	ra,56(sp)
    2000:	f822                	sd	s0,48(sp)
    2002:	f04a                	sd	s2,32(sp)
    2004:	ec4e                	sd	s3,24(sp)
    2006:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    2008:	02051993          	slli	s3,a0,0x20
    200c:	0209d993          	srli	s3,s3,0x20
    2010:	09bd                	addi	s3,s3,15
    2012:	0049d993          	srli	s3,s3,0x4
    2016:	2985                	addiw	s3,s3,1
    2018:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    201a:	00001517          	auipc	a0,0x1
    201e:	fe653503          	ld	a0,-26(a0) # 3000 <freep>
    2022:	c905                	beqz	a0,2052 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2024:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    2026:	4798                	lw	a4,8(a5)
    2028:	09377663          	bgeu	a4,s3,20b4 <malloc+0xb8>
    202c:	f426                	sd	s1,40(sp)
    202e:	e852                	sd	s4,16(sp)
    2030:	e456                	sd	s5,8(sp)
    2032:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    2034:	8a4e                	mv	s4,s3
    2036:	6705                	lui	a4,0x1
    2038:	00e9f363          	bgeu	s3,a4,203e <malloc+0x42>
    203c:	6a05                	lui	s4,0x1
    203e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    2042:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    2046:	00001497          	auipc	s1,0x1
    204a:	fba48493          	addi	s1,s1,-70 # 3000 <freep>
  if(p == SBRK_ERROR)
    204e:	5afd                	li	s5,-1
    2050:	a83d                	j	208e <malloc+0x92>
    2052:	f426                	sd	s1,40(sp)
    2054:	e852                	sd	s4,16(sp)
    2056:	e456                	sd	s5,8(sp)
    2058:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    205a:	00001797          	auipc	a5,0x1
    205e:	1b678793          	addi	a5,a5,438 # 3210 <base>
    2062:	00001717          	auipc	a4,0x1
    2066:	f8f73f23          	sd	a5,-98(a4) # 3000 <freep>
    206a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    206c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    2070:	b7d1                	j	2034 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    2072:	6398                	ld	a4,0(a5)
    2074:	e118                	sd	a4,0(a0)
    2076:	a899                	j	20cc <malloc+0xd0>
  hp->s.size = nu;
    2078:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    207c:	0541                	addi	a0,a0,16
    207e:	ef9ff0ef          	jal	1f76 <free>
  return freep;
    2082:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    2084:	c125                	beqz	a0,20e4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2086:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    2088:	4798                	lw	a4,8(a5)
    208a:	03277163          	bgeu	a4,s2,20ac <malloc+0xb0>
    if(p == freep)
    208e:	6098                	ld	a4,0(s1)
    2090:	853e                	mv	a0,a5
    2092:	fef71ae3          	bne	a4,a5,2086 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    2096:	8552                	mv	a0,s4
    2098:	a3dff0ef          	jal	1ad4 <sbrk>
  if(p == SBRK_ERROR)
    209c:	fd551ee3          	bne	a0,s5,2078 <malloc+0x7c>
        return 0;
    20a0:	4501                	li	a0,0
    20a2:	74a2                	ld	s1,40(sp)
    20a4:	6a42                	ld	s4,16(sp)
    20a6:	6aa2                	ld	s5,8(sp)
    20a8:	6b02                	ld	s6,0(sp)
    20aa:	a03d                	j	20d8 <malloc+0xdc>
    20ac:	74a2                	ld	s1,40(sp)
    20ae:	6a42                	ld	s4,16(sp)
    20b0:	6aa2                	ld	s5,8(sp)
    20b2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    20b4:	fae90fe3          	beq	s2,a4,2072 <malloc+0x76>
        p->s.size -= nunits;
    20b8:	4137073b          	subw	a4,a4,s3
    20bc:	c798                	sw	a4,8(a5)
        p += p->s.size;
    20be:	02071693          	slli	a3,a4,0x20
    20c2:	01c6d713          	srli	a4,a3,0x1c
    20c6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    20c8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    20cc:	00001717          	auipc	a4,0x1
    20d0:	f2a73a23          	sd	a0,-204(a4) # 3000 <freep>
      return (void*)(p + 1);
    20d4:	01078513          	addi	a0,a5,16
  }
}
    20d8:	70e2                	ld	ra,56(sp)
    20da:	7442                	ld	s0,48(sp)
    20dc:	7902                	ld	s2,32(sp)
    20de:	69e2                	ld	s3,24(sp)
    20e0:	6121                	addi	sp,sp,64
    20e2:	8082                	ret
    20e4:	74a2                	ld	s1,40(sp)
    20e6:	6a42                	ld	s4,16(sp)
    20e8:	6aa2                	ld	s5,8(sp)
    20ea:	6b02                	ld	s6,0(sp)
    20ec:	b7f5                	j	20d8 <malloc+0xdc>
