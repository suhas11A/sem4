
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	3ce58593          	addi	a1,a1,974 # 13e0 <malloc+0xf6>
      1a:	8532                	mv	a0,a2
      1c:	5fd000ef          	jal	e18 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	221000ef          	jal	a46 <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	267000ef          	jal	a94 <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a0053b          	negw	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	39c58593          	addi	a1,a1,924 # 13f0 <malloc+0x106>
      5c:	4509                	li	a0,2
      5e:	1aa010ef          	jal	1208 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	595000ef          	jal	df8 <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	581000ef          	jal	df0 <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	37650513          	addi	a0,a0,886 # 13f8 <malloc+0x10e>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	1800                	addi	s0,sp,48
  if(cmd == 0)
      96:	c115                	beqz	a0,ba <runcmd+0x2c>
      98:	ec26                	sd	s1,24(sp)
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e163          	bltu	a5,a4,c2 <runcmd+0x34>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	44e70713          	addi	a4,a4,1102 # 14f8 <malloc+0x20e>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
      ba:	ec26                	sd	s1,24(sp)
    exit(1);
      bc:	4505                	li	a0,1
      be:	53b000ef          	jal	df8 <exit>
    panic("runcmd");
      c2:	00001517          	auipc	a0,0x1
      c6:	33e50513          	addi	a0,a0,830 # 1400 <malloc+0x116>
      ca:	f81ff0ef          	jal	4a <panic>
    if(ecmd->argv[0] == 0)
      ce:	6508                	ld	a0,8(a0)
      d0:	c105                	beqz	a0,f0 <runcmd+0x62>
    exec(ecmd->argv[0], ecmd->argv);
      d2:	00848593          	addi	a1,s1,8
      d6:	55b000ef          	jal	e30 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      da:	6490                	ld	a2,8(s1)
      dc:	00001597          	auipc	a1,0x1
      e0:	32c58593          	addi	a1,a1,812 # 1408 <malloc+0x11e>
      e4:	4509                	li	a0,2
      e6:	122010ef          	jal	1208 <fprintf>
  exit(0);
      ea:	4501                	li	a0,0
      ec:	50d000ef          	jal	df8 <exit>
      exit(1);
      f0:	4505                	li	a0,1
      f2:	507000ef          	jal	df8 <exit>
    close(rcmd->fd);
      f6:	5148                	lw	a0,36(a0)
      f8:	529000ef          	jal	e20 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fc:	508c                	lw	a1,32(s1)
      fe:	6888                	ld	a0,16(s1)
     100:	539000ef          	jal	e38 <open>
     104:	00054563          	bltz	a0,10e <runcmd+0x80>
    runcmd(rcmd->cmd);
     108:	6488                	ld	a0,8(s1)
     10a:	f85ff0ef          	jal	8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10e:	6890                	ld	a2,16(s1)
     110:	00001597          	auipc	a1,0x1
     114:	30858593          	addi	a1,a1,776 # 1418 <malloc+0x12e>
     118:	4509                	li	a0,2
     11a:	0ee010ef          	jal	1208 <fprintf>
      exit(1);
     11e:	4505                	li	a0,1
     120:	4d9000ef          	jal	df8 <exit>
    if(fork1() == 0)
     124:	f45ff0ef          	jal	68 <fork1>
     128:	e501                	bnez	a0,130 <runcmd+0xa2>
      runcmd(lcmd->left);
     12a:	6488                	ld	a0,8(s1)
     12c:	f63ff0ef          	jal	8e <runcmd>
    wait(0);
     130:	4501                	li	a0,0
     132:	4cf000ef          	jal	e00 <wait>
    runcmd(lcmd->right);
     136:	6888                	ld	a0,16(s1)
     138:	f57ff0ef          	jal	8e <runcmd>
    if(pipe(p) < 0)
     13c:	fd840513          	addi	a0,s0,-40
     140:	4c9000ef          	jal	e08 <pipe>
     144:	02054763          	bltz	a0,172 <runcmd+0xe4>
    if(fork1() == 0){
     148:	f21ff0ef          	jal	68 <fork1>
     14c:	e90d                	bnez	a0,17e <runcmd+0xf0>
      close(1);
     14e:	4505                	li	a0,1
     150:	4d1000ef          	jal	e20 <close>
      dup(p[1]);
     154:	fdc42503          	lw	a0,-36(s0)
     158:	519000ef          	jal	e70 <dup>
      close(p[0]);
     15c:	fd842503          	lw	a0,-40(s0)
     160:	4c1000ef          	jal	e20 <close>
      close(p[1]);
     164:	fdc42503          	lw	a0,-36(s0)
     168:	4b9000ef          	jal	e20 <close>
      runcmd(pcmd->left);
     16c:	6488                	ld	a0,8(s1)
     16e:	f21ff0ef          	jal	8e <runcmd>
      panic("pipe");
     172:	00001517          	auipc	a0,0x1
     176:	2b650513          	addi	a0,a0,694 # 1428 <malloc+0x13e>
     17a:	ed1ff0ef          	jal	4a <panic>
    if(fork1() == 0){
     17e:	eebff0ef          	jal	68 <fork1>
     182:	e115                	bnez	a0,1a6 <runcmd+0x118>
      close(0);
     184:	49d000ef          	jal	e20 <close>
      dup(p[0]);
     188:	fd842503          	lw	a0,-40(s0)
     18c:	4e5000ef          	jal	e70 <dup>
      close(p[0]);
     190:	fd842503          	lw	a0,-40(s0)
     194:	48d000ef          	jal	e20 <close>
      close(p[1]);
     198:	fdc42503          	lw	a0,-36(s0)
     19c:	485000ef          	jal	e20 <close>
      runcmd(pcmd->right);
     1a0:	6888                	ld	a0,16(s1)
     1a2:	eedff0ef          	jal	8e <runcmd>
    close(p[0]);
     1a6:	fd842503          	lw	a0,-40(s0)
     1aa:	477000ef          	jal	e20 <close>
    close(p[1]);
     1ae:	fdc42503          	lw	a0,-36(s0)
     1b2:	46f000ef          	jal	e20 <close>
    wait(0);
     1b6:	4501                	li	a0,0
     1b8:	449000ef          	jal	e00 <wait>
    wait(0);
     1bc:	4501                	li	a0,0
     1be:	443000ef          	jal	e00 <wait>
    break;
     1c2:	b725                	j	ea <runcmd+0x5c>
    if(fork1() == 0)
     1c4:	ea5ff0ef          	jal	68 <fork1>
     1c8:	f20511e3          	bnez	a0,ea <runcmd+0x5c>
      runcmd(bcmd->cmd);
     1cc:	6488                	ld	a0,8(s1)
     1ce:	ec1ff0ef          	jal	8e <runcmd>

00000000000001d2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d2:	1101                	addi	sp,sp,-32
     1d4:	ec06                	sd	ra,24(sp)
     1d6:	e822                	sd	s0,16(sp)
     1d8:	e426                	sd	s1,8(sp)
     1da:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1dc:	0a800513          	li	a0,168
     1e0:	10a010ef          	jal	12ea <malloc>
     1e4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e6:	0a800613          	li	a2,168
     1ea:	4581                	li	a1,0
     1ec:	05b000ef          	jal	a46 <memset>
  cmd->type = EXEC;
     1f0:	4785                	li	a5,1
     1f2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f4:	8526                	mv	a0,s1
     1f6:	60e2                	ld	ra,24(sp)
     1f8:	6442                	ld	s0,16(sp)
     1fa:	64a2                	ld	s1,8(sp)
     1fc:	6105                	addi	sp,sp,32
     1fe:	8082                	ret

0000000000000200 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     200:	7139                	addi	sp,sp,-64
     202:	fc06                	sd	ra,56(sp)
     204:	f822                	sd	s0,48(sp)
     206:	f426                	sd	s1,40(sp)
     208:	f04a                	sd	s2,32(sp)
     20a:	ec4e                	sd	s3,24(sp)
     20c:	e852                	sd	s4,16(sp)
     20e:	e456                	sd	s5,8(sp)
     210:	e05a                	sd	s6,0(sp)
     212:	0080                	addi	s0,sp,64
     214:	8b2a                	mv	s6,a0
     216:	8aae                	mv	s5,a1
     218:	8a32                	mv	s4,a2
     21a:	89b6                	mv	s3,a3
     21c:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21e:	02800513          	li	a0,40
     222:	0c8010ef          	jal	12ea <malloc>
     226:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     228:	02800613          	li	a2,40
     22c:	4581                	li	a1,0
     22e:	019000ef          	jal	a46 <memset>
  cmd->type = REDIR;
     232:	4789                	li	a5,2
     234:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     236:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     23a:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     23e:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     242:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     246:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     24a:	8526                	mv	a0,s1
     24c:	70e2                	ld	ra,56(sp)
     24e:	7442                	ld	s0,48(sp)
     250:	74a2                	ld	s1,40(sp)
     252:	7902                	ld	s2,32(sp)
     254:	69e2                	ld	s3,24(sp)
     256:	6a42                	ld	s4,16(sp)
     258:	6aa2                	ld	s5,8(sp)
     25a:	6b02                	ld	s6,0(sp)
     25c:	6121                	addi	sp,sp,64
     25e:	8082                	ret

0000000000000260 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     260:	7179                	addi	sp,sp,-48
     262:	f406                	sd	ra,40(sp)
     264:	f022                	sd	s0,32(sp)
     266:	ec26                	sd	s1,24(sp)
     268:	e84a                	sd	s2,16(sp)
     26a:	e44e                	sd	s3,8(sp)
     26c:	1800                	addi	s0,sp,48
     26e:	89aa                	mv	s3,a0
     270:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     272:	4561                	li	a0,24
     274:	076010ef          	jal	12ea <malloc>
     278:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     27a:	4661                	li	a2,24
     27c:	4581                	li	a1,0
     27e:	7c8000ef          	jal	a46 <memset>
  cmd->type = PIPE;
     282:	478d                	li	a5,3
     284:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     286:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     28a:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     28e:	8526                	mv	a0,s1
     290:	70a2                	ld	ra,40(sp)
     292:	7402                	ld	s0,32(sp)
     294:	64e2                	ld	s1,24(sp)
     296:	6942                	ld	s2,16(sp)
     298:	69a2                	ld	s3,8(sp)
     29a:	6145                	addi	sp,sp,48
     29c:	8082                	ret

000000000000029e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29e:	7179                	addi	sp,sp,-48
     2a0:	f406                	sd	ra,40(sp)
     2a2:	f022                	sd	s0,32(sp)
     2a4:	ec26                	sd	s1,24(sp)
     2a6:	e84a                	sd	s2,16(sp)
     2a8:	e44e                	sd	s3,8(sp)
     2aa:	1800                	addi	s0,sp,48
     2ac:	89aa                	mv	s3,a0
     2ae:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b0:	4561                	li	a0,24
     2b2:	038010ef          	jal	12ea <malloc>
     2b6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b8:	4661                	li	a2,24
     2ba:	4581                	li	a1,0
     2bc:	78a000ef          	jal	a46 <memset>
  cmd->type = LIST;
     2c0:	4791                	li	a5,4
     2c2:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c4:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2c8:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     2cc:	8526                	mv	a0,s1
     2ce:	70a2                	ld	ra,40(sp)
     2d0:	7402                	ld	s0,32(sp)
     2d2:	64e2                	ld	s1,24(sp)
     2d4:	6942                	ld	s2,16(sp)
     2d6:	69a2                	ld	s3,8(sp)
     2d8:	6145                	addi	sp,sp,48
     2da:	8082                	ret

00000000000002dc <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2dc:	1101                	addi	sp,sp,-32
     2de:	ec06                	sd	ra,24(sp)
     2e0:	e822                	sd	s0,16(sp)
     2e2:	e426                	sd	s1,8(sp)
     2e4:	e04a                	sd	s2,0(sp)
     2e6:	1000                	addi	s0,sp,32
     2e8:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ea:	4541                	li	a0,16
     2ec:	7ff000ef          	jal	12ea <malloc>
     2f0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f2:	4641                	li	a2,16
     2f4:	4581                	li	a1,0
     2f6:	750000ef          	jal	a46 <memset>
  cmd->type = BACK;
     2fa:	4795                	li	a5,5
     2fc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fe:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     302:	8526                	mv	a0,s1
     304:	60e2                	ld	ra,24(sp)
     306:	6442                	ld	s0,16(sp)
     308:	64a2                	ld	s1,8(sp)
     30a:	6902                	ld	s2,0(sp)
     30c:	6105                	addi	sp,sp,32
     30e:	8082                	ret

0000000000000310 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     310:	7139                	addi	sp,sp,-64
     312:	fc06                	sd	ra,56(sp)
     314:	f822                	sd	s0,48(sp)
     316:	f426                	sd	s1,40(sp)
     318:	f04a                	sd	s2,32(sp)
     31a:	ec4e                	sd	s3,24(sp)
     31c:	e852                	sd	s4,16(sp)
     31e:	e456                	sd	s5,8(sp)
     320:	e05a                	sd	s6,0(sp)
     322:	0080                	addi	s0,sp,64
     324:	8a2a                	mv	s4,a0
     326:	892e                	mv	s2,a1
     328:	8ab2                	mv	s5,a2
     32a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32c:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32e:	00002997          	auipc	s3,0x2
     332:	cda98993          	addi	s3,s3,-806 # 2008 <whitespace>
     336:	00b4fc63          	bgeu	s1,a1,34e <gettoken+0x3e>
     33a:	0004c583          	lbu	a1,0(s1)
     33e:	854e                	mv	a0,s3
     340:	72c000ef          	jal	a6c <strchr>
     344:	c509                	beqz	a0,34e <gettoken+0x3e>
    s++;
     346:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     348:	fe9919e3          	bne	s2,s1,33a <gettoken+0x2a>
     34c:	84ca                	mv	s1,s2
  if(q)
     34e:	000a8463          	beqz	s5,356 <gettoken+0x46>
    *q = s;
     352:	009ab023          	sd	s1,0(s5)
  ret = *s;
     356:	0004c783          	lbu	a5,0(s1)
     35a:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35e:	03c00713          	li	a4,60
     362:	06f76463          	bltu	a4,a5,3ca <gettoken+0xba>
     366:	03a00713          	li	a4,58
     36a:	00f76e63          	bltu	a4,a5,386 <gettoken+0x76>
     36e:	cf89                	beqz	a5,388 <gettoken+0x78>
     370:	02600713          	li	a4,38
     374:	00e78963          	beq	a5,a4,386 <gettoken+0x76>
     378:	fd87879b          	addiw	a5,a5,-40
     37c:	0ff7f793          	zext.b	a5,a5
     380:	4705                	li	a4,1
     382:	06f76b63          	bltu	a4,a5,3f8 <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     386:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     388:	000b0463          	beqz	s6,390 <gettoken+0x80>
    *eq = s;
     38c:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     390:	00002997          	auipc	s3,0x2
     394:	c7898993          	addi	s3,s3,-904 # 2008 <whitespace>
     398:	0124fc63          	bgeu	s1,s2,3b0 <gettoken+0xa0>
     39c:	0004c583          	lbu	a1,0(s1)
     3a0:	854e                	mv	a0,s3
     3a2:	6ca000ef          	jal	a6c <strchr>
     3a6:	c509                	beqz	a0,3b0 <gettoken+0xa0>
    s++;
     3a8:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3aa:	fe9919e3          	bne	s2,s1,39c <gettoken+0x8c>
     3ae:	84ca                	mv	s1,s2
  *ps = s;
     3b0:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3b4:	8556                	mv	a0,s5
     3b6:	70e2                	ld	ra,56(sp)
     3b8:	7442                	ld	s0,48(sp)
     3ba:	74a2                	ld	s1,40(sp)
     3bc:	7902                	ld	s2,32(sp)
     3be:	69e2                	ld	s3,24(sp)
     3c0:	6a42                	ld	s4,16(sp)
     3c2:	6aa2                	ld	s5,8(sp)
     3c4:	6b02                	ld	s6,0(sp)
     3c6:	6121                	addi	sp,sp,64
     3c8:	8082                	ret
  switch(*s){
     3ca:	03e00713          	li	a4,62
     3ce:	02e79163          	bne	a5,a4,3f0 <gettoken+0xe0>
    s++;
     3d2:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     3d6:	0014c703          	lbu	a4,1(s1)
     3da:	03e00793          	li	a5,62
      s++;
     3de:	0489                	addi	s1,s1,2
      ret = '+';
     3e0:	02b00a93          	li	s5,43
    if(*s == '>'){
     3e4:	faf702e3          	beq	a4,a5,388 <gettoken+0x78>
    s++;
     3e8:	84b6                	mv	s1,a3
  ret = *s;
     3ea:	03e00a93          	li	s5,62
     3ee:	bf69                	j	388 <gettoken+0x78>
  switch(*s){
     3f0:	07c00713          	li	a4,124
     3f4:	f8e789e3          	beq	a5,a4,386 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3f8:	00002997          	auipc	s3,0x2
     3fc:	c1098993          	addi	s3,s3,-1008 # 2008 <whitespace>
     400:	00002a97          	auipc	s5,0x2
     404:	c00a8a93          	addi	s5,s5,-1024 # 2000 <symbols>
     408:	0324fd63          	bgeu	s1,s2,442 <gettoken+0x132>
     40c:	0004c583          	lbu	a1,0(s1)
     410:	854e                	mv	a0,s3
     412:	65a000ef          	jal	a6c <strchr>
     416:	e11d                	bnez	a0,43c <gettoken+0x12c>
     418:	0004c583          	lbu	a1,0(s1)
     41c:	8556                	mv	a0,s5
     41e:	64e000ef          	jal	a6c <strchr>
     422:	e911                	bnez	a0,436 <gettoken+0x126>
      s++;
     424:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     426:	fe9913e3          	bne	s2,s1,40c <gettoken+0xfc>
  if(eq)
     42a:	84ca                	mv	s1,s2
    ret = 'a';
     42c:	06100a93          	li	s5,97
  if(eq)
     430:	f40b1ee3          	bnez	s6,38c <gettoken+0x7c>
     434:	bfb5                	j	3b0 <gettoken+0xa0>
    ret = 'a';
     436:	06100a93          	li	s5,97
     43a:	b7b9                	j	388 <gettoken+0x78>
     43c:	06100a93          	li	s5,97
     440:	b7a1                	j	388 <gettoken+0x78>
     442:	06100a93          	li	s5,97
  if(eq)
     446:	f40b13e3          	bnez	s6,38c <gettoken+0x7c>
     44a:	b79d                	j	3b0 <gettoken+0xa0>

000000000000044c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     44c:	7139                	addi	sp,sp,-64
     44e:	fc06                	sd	ra,56(sp)
     450:	f822                	sd	s0,48(sp)
     452:	f426                	sd	s1,40(sp)
     454:	f04a                	sd	s2,32(sp)
     456:	ec4e                	sd	s3,24(sp)
     458:	e852                	sd	s4,16(sp)
     45a:	e456                	sd	s5,8(sp)
     45c:	0080                	addi	s0,sp,64
     45e:	8a2a                	mv	s4,a0
     460:	892e                	mv	s2,a1
     462:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     464:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     466:	00002997          	auipc	s3,0x2
     46a:	ba298993          	addi	s3,s3,-1118 # 2008 <whitespace>
     46e:	00b4fc63          	bgeu	s1,a1,486 <peek+0x3a>
     472:	0004c583          	lbu	a1,0(s1)
     476:	854e                	mv	a0,s3
     478:	5f4000ef          	jal	a6c <strchr>
     47c:	c509                	beqz	a0,486 <peek+0x3a>
    s++;
     47e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     480:	fe9919e3          	bne	s2,s1,472 <peek+0x26>
     484:	84ca                	mv	s1,s2
  *ps = s;
     486:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     48a:	0004c583          	lbu	a1,0(s1)
     48e:	4501                	li	a0,0
     490:	e991                	bnez	a1,4a4 <peek+0x58>
}
     492:	70e2                	ld	ra,56(sp)
     494:	7442                	ld	s0,48(sp)
     496:	74a2                	ld	s1,40(sp)
     498:	7902                	ld	s2,32(sp)
     49a:	69e2                	ld	s3,24(sp)
     49c:	6a42                	ld	s4,16(sp)
     49e:	6aa2                	ld	s5,8(sp)
     4a0:	6121                	addi	sp,sp,64
     4a2:	8082                	ret
  return *s && strchr(toks, *s);
     4a4:	8556                	mv	a0,s5
     4a6:	5c6000ef          	jal	a6c <strchr>
     4aa:	00a03533          	snez	a0,a0
     4ae:	b7d5                	j	492 <peek+0x46>

00000000000004b0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4b0:	7159                	addi	sp,sp,-112
     4b2:	f486                	sd	ra,104(sp)
     4b4:	f0a2                	sd	s0,96(sp)
     4b6:	eca6                	sd	s1,88(sp)
     4b8:	e8ca                	sd	s2,80(sp)
     4ba:	e4ce                	sd	s3,72(sp)
     4bc:	e0d2                	sd	s4,64(sp)
     4be:	fc56                	sd	s5,56(sp)
     4c0:	f85a                	sd	s6,48(sp)
     4c2:	f45e                	sd	s7,40(sp)
     4c4:	f062                	sd	s8,32(sp)
     4c6:	ec66                	sd	s9,24(sp)
     4c8:	1880                	addi	s0,sp,112
     4ca:	8a2a                	mv	s4,a0
     4cc:	89ae                	mv	s3,a1
     4ce:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4d0:	00001b17          	auipc	s6,0x1
     4d4:	f80b0b13          	addi	s6,s6,-128 # 1450 <malloc+0x166>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4d8:	f9040c93          	addi	s9,s0,-112
     4dc:	f9840c13          	addi	s8,s0,-104
     4e0:	06100b93          	li	s7,97
  while(peek(ps, es, "<>")){
     4e4:	a00d                	j	506 <parseredirs+0x56>
      panic("missing file for redirection");
     4e6:	00001517          	auipc	a0,0x1
     4ea:	f4a50513          	addi	a0,a0,-182 # 1430 <malloc+0x146>
     4ee:	b5dff0ef          	jal	4a <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4f2:	4701                	li	a4,0
     4f4:	4681                	li	a3,0
     4f6:	f9043603          	ld	a2,-112(s0)
     4fa:	f9843583          	ld	a1,-104(s0)
     4fe:	8552                	mv	a0,s4
     500:	d01ff0ef          	jal	200 <redircmd>
     504:	8a2a                	mv	s4,a0
    switch(tok){
     506:	03c00a93          	li	s5,60
  while(peek(ps, es, "<>")){
     50a:	865a                	mv	a2,s6
     50c:	85ca                	mv	a1,s2
     50e:	854e                	mv	a0,s3
     510:	f3dff0ef          	jal	44c <peek>
     514:	c135                	beqz	a0,578 <parseredirs+0xc8>
    tok = gettoken(ps, es, 0, 0);
     516:	4681                	li	a3,0
     518:	4601                	li	a2,0
     51a:	85ca                	mv	a1,s2
     51c:	854e                	mv	a0,s3
     51e:	df3ff0ef          	jal	310 <gettoken>
     522:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     524:	86e6                	mv	a3,s9
     526:	8662                	mv	a2,s8
     528:	85ca                	mv	a1,s2
     52a:	854e                	mv	a0,s3
     52c:	de5ff0ef          	jal	310 <gettoken>
     530:	fb751be3          	bne	a0,s7,4e6 <parseredirs+0x36>
    switch(tok){
     534:	fb548fe3          	beq	s1,s5,4f2 <parseredirs+0x42>
     538:	03e00793          	li	a5,62
     53c:	02f48263          	beq	s1,a5,560 <parseredirs+0xb0>
     540:	02b00793          	li	a5,43
     544:	fcf493e3          	bne	s1,a5,50a <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     548:	4705                	li	a4,1
     54a:	20100693          	li	a3,513
     54e:	f9043603          	ld	a2,-112(s0)
     552:	f9843583          	ld	a1,-104(s0)
     556:	8552                	mv	a0,s4
     558:	ca9ff0ef          	jal	200 <redircmd>
     55c:	8a2a                	mv	s4,a0
      break;
     55e:	b765                	j	506 <parseredirs+0x56>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     560:	4705                	li	a4,1
     562:	60100693          	li	a3,1537
     566:	f9043603          	ld	a2,-112(s0)
     56a:	f9843583          	ld	a1,-104(s0)
     56e:	8552                	mv	a0,s4
     570:	c91ff0ef          	jal	200 <redircmd>
     574:	8a2a                	mv	s4,a0
      break;
     576:	bf41                	j	506 <parseredirs+0x56>
    }
  }
  return cmd;
}
     578:	8552                	mv	a0,s4
     57a:	70a6                	ld	ra,104(sp)
     57c:	7406                	ld	s0,96(sp)
     57e:	64e6                	ld	s1,88(sp)
     580:	6946                	ld	s2,80(sp)
     582:	69a6                	ld	s3,72(sp)
     584:	6a06                	ld	s4,64(sp)
     586:	7ae2                	ld	s5,56(sp)
     588:	7b42                	ld	s6,48(sp)
     58a:	7ba2                	ld	s7,40(sp)
     58c:	7c02                	ld	s8,32(sp)
     58e:	6ce2                	ld	s9,24(sp)
     590:	6165                	addi	sp,sp,112
     592:	8082                	ret

0000000000000594 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     594:	7119                	addi	sp,sp,-128
     596:	fc86                	sd	ra,120(sp)
     598:	f8a2                	sd	s0,112(sp)
     59a:	f4a6                	sd	s1,104(sp)
     59c:	e8d2                	sd	s4,80(sp)
     59e:	e4d6                	sd	s5,72(sp)
     5a0:	0100                	addi	s0,sp,128
     5a2:	8a2a                	mv	s4,a0
     5a4:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     5a6:	00001617          	auipc	a2,0x1
     5aa:	eb260613          	addi	a2,a2,-334 # 1458 <malloc+0x16e>
     5ae:	e9fff0ef          	jal	44c <peek>
     5b2:	e121                	bnez	a0,5f2 <parseexec+0x5e>
     5b4:	f0ca                	sd	s2,96(sp)
     5b6:	ecce                	sd	s3,88(sp)
     5b8:	e0da                	sd	s6,64(sp)
     5ba:	fc5e                	sd	s7,56(sp)
     5bc:	f862                	sd	s8,48(sp)
     5be:	f466                	sd	s9,40(sp)
     5c0:	f06a                	sd	s10,32(sp)
     5c2:	ec6e                	sd	s11,24(sp)
     5c4:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5c6:	c0dff0ef          	jal	1d2 <execcmd>
     5ca:	8daa                	mv	s11,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5cc:	8656                	mv	a2,s5
     5ce:	85d2                	mv	a1,s4
     5d0:	ee1ff0ef          	jal	4b0 <parseredirs>
     5d4:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5d6:	008d8913          	addi	s2,s11,8
     5da:	00001b17          	auipc	s6,0x1
     5de:	e9eb0b13          	addi	s6,s6,-354 # 1478 <malloc+0x18e>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     5e2:	f8040c13          	addi	s8,s0,-128
     5e6:	f8840b93          	addi	s7,s0,-120
      break;
    if(tok != 'a')
     5ea:	06100d13          	li	s10,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5ee:	4ca9                	li	s9,10
  while(!peek(ps, es, "|)&;")){
     5f0:	a815                	j	624 <parseexec+0x90>
    return parseblock(ps, es);
     5f2:	85d6                	mv	a1,s5
     5f4:	8552                	mv	a0,s4
     5f6:	170000ef          	jal	766 <parseblock>
     5fa:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5fc:	8526                	mv	a0,s1
     5fe:	70e6                	ld	ra,120(sp)
     600:	7446                	ld	s0,112(sp)
     602:	74a6                	ld	s1,104(sp)
     604:	6a46                	ld	s4,80(sp)
     606:	6aa6                	ld	s5,72(sp)
     608:	6109                	addi	sp,sp,128
     60a:	8082                	ret
      panic("syntax");
     60c:	00001517          	auipc	a0,0x1
     610:	e5450513          	addi	a0,a0,-428 # 1460 <malloc+0x176>
     614:	a37ff0ef          	jal	4a <panic>
    ret = parseredirs(ret, ps, es);
     618:	8656                	mv	a2,s5
     61a:	85d2                	mv	a1,s4
     61c:	8526                	mv	a0,s1
     61e:	e93ff0ef          	jal	4b0 <parseredirs>
     622:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     624:	865a                	mv	a2,s6
     626:	85d6                	mv	a1,s5
     628:	8552                	mv	a0,s4
     62a:	e23ff0ef          	jal	44c <peek>
     62e:	ed05                	bnez	a0,666 <parseexec+0xd2>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     630:	86e2                	mv	a3,s8
     632:	865e                	mv	a2,s7
     634:	85d6                	mv	a1,s5
     636:	8552                	mv	a0,s4
     638:	cd9ff0ef          	jal	310 <gettoken>
     63c:	c50d                	beqz	a0,666 <parseexec+0xd2>
    if(tok != 'a')
     63e:	fda517e3          	bne	a0,s10,60c <parseexec+0x78>
    cmd->argv[argc] = q;
     642:	f8843783          	ld	a5,-120(s0)
     646:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     64a:	f8043783          	ld	a5,-128(s0)
     64e:	04f93823          	sd	a5,80(s2)
    argc++;
     652:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     654:	0921                	addi	s2,s2,8
     656:	fd9991e3          	bne	s3,s9,618 <parseexec+0x84>
      panic("too many args");
     65a:	00001517          	auipc	a0,0x1
     65e:	e0e50513          	addi	a0,a0,-498 # 1468 <malloc+0x17e>
     662:	9e9ff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     666:	098e                	slli	s3,s3,0x3
     668:	9dce                	add	s11,s11,s3
     66a:	000db423          	sd	zero,8(s11)
  cmd->eargv[argc] = 0;
     66e:	040dbc23          	sd	zero,88(s11)
     672:	7906                	ld	s2,96(sp)
     674:	69e6                	ld	s3,88(sp)
     676:	6b06                	ld	s6,64(sp)
     678:	7be2                	ld	s7,56(sp)
     67a:	7c42                	ld	s8,48(sp)
     67c:	7ca2                	ld	s9,40(sp)
     67e:	7d02                	ld	s10,32(sp)
     680:	6de2                	ld	s11,24(sp)
  return ret;
     682:	bfad                	j	5fc <parseexec+0x68>

0000000000000684 <parsepipe>:
{
     684:	7179                	addi	sp,sp,-48
     686:	f406                	sd	ra,40(sp)
     688:	f022                	sd	s0,32(sp)
     68a:	ec26                	sd	s1,24(sp)
     68c:	e84a                	sd	s2,16(sp)
     68e:	e44e                	sd	s3,8(sp)
     690:	1800                	addi	s0,sp,48
     692:	892a                	mv	s2,a0
     694:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     696:	effff0ef          	jal	594 <parseexec>
     69a:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     69c:	00001617          	auipc	a2,0x1
     6a0:	de460613          	addi	a2,a2,-540 # 1480 <malloc+0x196>
     6a4:	85ce                	mv	a1,s3
     6a6:	854a                	mv	a0,s2
     6a8:	da5ff0ef          	jal	44c <peek>
     6ac:	e909                	bnez	a0,6be <parsepipe+0x3a>
}
     6ae:	8526                	mv	a0,s1
     6b0:	70a2                	ld	ra,40(sp)
     6b2:	7402                	ld	s0,32(sp)
     6b4:	64e2                	ld	s1,24(sp)
     6b6:	6942                	ld	s2,16(sp)
     6b8:	69a2                	ld	s3,8(sp)
     6ba:	6145                	addi	sp,sp,48
     6bc:	8082                	ret
    gettoken(ps, es, 0, 0);
     6be:	4681                	li	a3,0
     6c0:	4601                	li	a2,0
     6c2:	85ce                	mv	a1,s3
     6c4:	854a                	mv	a0,s2
     6c6:	c4bff0ef          	jal	310 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ca:	85ce                	mv	a1,s3
     6cc:	854a                	mv	a0,s2
     6ce:	fb7ff0ef          	jal	684 <parsepipe>
     6d2:	85aa                	mv	a1,a0
     6d4:	8526                	mv	a0,s1
     6d6:	b8bff0ef          	jal	260 <pipecmd>
     6da:	84aa                	mv	s1,a0
  return cmd;
     6dc:	bfc9                	j	6ae <parsepipe+0x2a>

00000000000006de <parseline>:
{
     6de:	7179                	addi	sp,sp,-48
     6e0:	f406                	sd	ra,40(sp)
     6e2:	f022                	sd	s0,32(sp)
     6e4:	ec26                	sd	s1,24(sp)
     6e6:	e84a                	sd	s2,16(sp)
     6e8:	e44e                	sd	s3,8(sp)
     6ea:	e052                	sd	s4,0(sp)
     6ec:	1800                	addi	s0,sp,48
     6ee:	892a                	mv	s2,a0
     6f0:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6f2:	f93ff0ef          	jal	684 <parsepipe>
     6f6:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6f8:	00001a17          	auipc	s4,0x1
     6fc:	d90a0a13          	addi	s4,s4,-624 # 1488 <malloc+0x19e>
     700:	a819                	j	716 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     702:	4681                	li	a3,0
     704:	4601                	li	a2,0
     706:	85ce                	mv	a1,s3
     708:	854a                	mv	a0,s2
     70a:	c07ff0ef          	jal	310 <gettoken>
    cmd = backcmd(cmd);
     70e:	8526                	mv	a0,s1
     710:	bcdff0ef          	jal	2dc <backcmd>
     714:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     716:	8652                	mv	a2,s4
     718:	85ce                	mv	a1,s3
     71a:	854a                	mv	a0,s2
     71c:	d31ff0ef          	jal	44c <peek>
     720:	f16d                	bnez	a0,702 <parseline+0x24>
  if(peek(ps, es, ";")){
     722:	00001617          	auipc	a2,0x1
     726:	d6e60613          	addi	a2,a2,-658 # 1490 <malloc+0x1a6>
     72a:	85ce                	mv	a1,s3
     72c:	854a                	mv	a0,s2
     72e:	d1fff0ef          	jal	44c <peek>
     732:	e911                	bnez	a0,746 <parseline+0x68>
}
     734:	8526                	mv	a0,s1
     736:	70a2                	ld	ra,40(sp)
     738:	7402                	ld	s0,32(sp)
     73a:	64e2                	ld	s1,24(sp)
     73c:	6942                	ld	s2,16(sp)
     73e:	69a2                	ld	s3,8(sp)
     740:	6a02                	ld	s4,0(sp)
     742:	6145                	addi	sp,sp,48
     744:	8082                	ret
    gettoken(ps, es, 0, 0);
     746:	4681                	li	a3,0
     748:	4601                	li	a2,0
     74a:	85ce                	mv	a1,s3
     74c:	854a                	mv	a0,s2
     74e:	bc3ff0ef          	jal	310 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     752:	85ce                	mv	a1,s3
     754:	854a                	mv	a0,s2
     756:	f89ff0ef          	jal	6de <parseline>
     75a:	85aa                	mv	a1,a0
     75c:	8526                	mv	a0,s1
     75e:	b41ff0ef          	jal	29e <listcmd>
     762:	84aa                	mv	s1,a0
  return cmd;
     764:	bfc1                	j	734 <parseline+0x56>

0000000000000766 <parseblock>:
{
     766:	7179                	addi	sp,sp,-48
     768:	f406                	sd	ra,40(sp)
     76a:	f022                	sd	s0,32(sp)
     76c:	ec26                	sd	s1,24(sp)
     76e:	e84a                	sd	s2,16(sp)
     770:	e44e                	sd	s3,8(sp)
     772:	1800                	addi	s0,sp,48
     774:	84aa                	mv	s1,a0
     776:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     778:	00001617          	auipc	a2,0x1
     77c:	ce060613          	addi	a2,a2,-800 # 1458 <malloc+0x16e>
     780:	ccdff0ef          	jal	44c <peek>
     784:	c539                	beqz	a0,7d2 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     786:	4681                	li	a3,0
     788:	4601                	li	a2,0
     78a:	85ca                	mv	a1,s2
     78c:	8526                	mv	a0,s1
     78e:	b83ff0ef          	jal	310 <gettoken>
  cmd = parseline(ps, es);
     792:	85ca                	mv	a1,s2
     794:	8526                	mv	a0,s1
     796:	f49ff0ef          	jal	6de <parseline>
     79a:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     79c:	00001617          	auipc	a2,0x1
     7a0:	d0c60613          	addi	a2,a2,-756 # 14a8 <malloc+0x1be>
     7a4:	85ca                	mv	a1,s2
     7a6:	8526                	mv	a0,s1
     7a8:	ca5ff0ef          	jal	44c <peek>
     7ac:	c90d                	beqz	a0,7de <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     7ae:	4681                	li	a3,0
     7b0:	4601                	li	a2,0
     7b2:	85ca                	mv	a1,s2
     7b4:	8526                	mv	a0,s1
     7b6:	b5bff0ef          	jal	310 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7ba:	864a                	mv	a2,s2
     7bc:	85a6                	mv	a1,s1
     7be:	854e                	mv	a0,s3
     7c0:	cf1ff0ef          	jal	4b0 <parseredirs>
}
     7c4:	70a2                	ld	ra,40(sp)
     7c6:	7402                	ld	s0,32(sp)
     7c8:	64e2                	ld	s1,24(sp)
     7ca:	6942                	ld	s2,16(sp)
     7cc:	69a2                	ld	s3,8(sp)
     7ce:	6145                	addi	sp,sp,48
     7d0:	8082                	ret
    panic("parseblock");
     7d2:	00001517          	auipc	a0,0x1
     7d6:	cc650513          	addi	a0,a0,-826 # 1498 <malloc+0x1ae>
     7da:	871ff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     7de:	00001517          	auipc	a0,0x1
     7e2:	cd250513          	addi	a0,a0,-814 # 14b0 <malloc+0x1c6>
     7e6:	865ff0ef          	jal	4a <panic>

00000000000007ea <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7ea:	1101                	addi	sp,sp,-32
     7ec:	ec06                	sd	ra,24(sp)
     7ee:	e822                	sd	s0,16(sp)
     7f0:	e426                	sd	s1,8(sp)
     7f2:	1000                	addi	s0,sp,32
     7f4:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7f6:	c131                	beqz	a0,83a <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7f8:	4118                	lw	a4,0(a0)
     7fa:	4795                	li	a5,5
     7fc:	02e7ef63          	bltu	a5,a4,83a <nulterminate+0x50>
     800:	00056783          	lwu	a5,0(a0)
     804:	078a                	slli	a5,a5,0x2
     806:	00001717          	auipc	a4,0x1
     80a:	d0a70713          	addi	a4,a4,-758 # 1510 <malloc+0x226>
     80e:	97ba                	add	a5,a5,a4
     810:	439c                	lw	a5,0(a5)
     812:	97ba                	add	a5,a5,a4
     814:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     816:	651c                	ld	a5,8(a0)
     818:	c38d                	beqz	a5,83a <nulterminate+0x50>
     81a:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     81e:	67b8                	ld	a4,72(a5)
     820:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     824:	07a1                	addi	a5,a5,8
     826:	ff87b703          	ld	a4,-8(a5)
     82a:	fb75                	bnez	a4,81e <nulterminate+0x34>
     82c:	a039                	j	83a <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     82e:	6508                	ld	a0,8(a0)
     830:	fbbff0ef          	jal	7ea <nulterminate>
    *rcmd->efile = 0;
     834:	6c9c                	ld	a5,24(s1)
     836:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     83a:	8526                	mv	a0,s1
     83c:	60e2                	ld	ra,24(sp)
     83e:	6442                	ld	s0,16(sp)
     840:	64a2                	ld	s1,8(sp)
     842:	6105                	addi	sp,sp,32
     844:	8082                	ret
    nulterminate(pcmd->left);
     846:	6508                	ld	a0,8(a0)
     848:	fa3ff0ef          	jal	7ea <nulterminate>
    nulterminate(pcmd->right);
     84c:	6888                	ld	a0,16(s1)
     84e:	f9dff0ef          	jal	7ea <nulterminate>
    break;
     852:	b7e5                	j	83a <nulterminate+0x50>
    nulterminate(lcmd->left);
     854:	6508                	ld	a0,8(a0)
     856:	f95ff0ef          	jal	7ea <nulterminate>
    nulterminate(lcmd->right);
     85a:	6888                	ld	a0,16(s1)
     85c:	f8fff0ef          	jal	7ea <nulterminate>
    break;
     860:	bfe9                	j	83a <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     862:	6508                	ld	a0,8(a0)
     864:	f87ff0ef          	jal	7ea <nulterminate>
    break;
     868:	bfc9                	j	83a <nulterminate+0x50>

000000000000086a <parsecmd>:
{
     86a:	7139                	addi	sp,sp,-64
     86c:	fc06                	sd	ra,56(sp)
     86e:	f822                	sd	s0,48(sp)
     870:	f426                	sd	s1,40(sp)
     872:	f04a                	sd	s2,32(sp)
     874:	ec4e                	sd	s3,24(sp)
     876:	0080                	addi	s0,sp,64
     878:	fca43423          	sd	a0,-56(s0)
  es = s + strlen(s);
     87c:	84aa                	mv	s1,a0
     87e:	19a000ef          	jal	a18 <strlen>
     882:	1502                	slli	a0,a0,0x20
     884:	9101                	srli	a0,a0,0x20
     886:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     888:	fc840993          	addi	s3,s0,-56
     88c:	85a6                	mv	a1,s1
     88e:	854e                	mv	a0,s3
     890:	e4fff0ef          	jal	6de <parseline>
     894:	892a                	mv	s2,a0
  peek(&s, es, "");
     896:	00001617          	auipc	a2,0x1
     89a:	b5260613          	addi	a2,a2,-1198 # 13e8 <malloc+0xfe>
     89e:	85a6                	mv	a1,s1
     8a0:	854e                	mv	a0,s3
     8a2:	babff0ef          	jal	44c <peek>
  if(s != es){
     8a6:	fc843603          	ld	a2,-56(s0)
     8aa:	00961d63          	bne	a2,s1,8c4 <parsecmd+0x5a>
  nulterminate(cmd);
     8ae:	854a                	mv	a0,s2
     8b0:	f3bff0ef          	jal	7ea <nulterminate>
}
     8b4:	854a                	mv	a0,s2
     8b6:	70e2                	ld	ra,56(sp)
     8b8:	7442                	ld	s0,48(sp)
     8ba:	74a2                	ld	s1,40(sp)
     8bc:	7902                	ld	s2,32(sp)
     8be:	69e2                	ld	s3,24(sp)
     8c0:	6121                	addi	sp,sp,64
     8c2:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     8c4:	00001597          	auipc	a1,0x1
     8c8:	c0458593          	addi	a1,a1,-1020 # 14c8 <malloc+0x1de>
     8cc:	4509                	li	a0,2
     8ce:	13b000ef          	jal	1208 <fprintf>
    panic("syntax");
     8d2:	00001517          	auipc	a0,0x1
     8d6:	b8e50513          	addi	a0,a0,-1138 # 1460 <malloc+0x176>
     8da:	f70ff0ef          	jal	4a <panic>

00000000000008de <main>:
{
     8de:	7139                	addi	sp,sp,-64
     8e0:	fc06                	sd	ra,56(sp)
     8e2:	f822                	sd	s0,48(sp)
     8e4:	f426                	sd	s1,40(sp)
     8e6:	f04a                	sd	s2,32(sp)
     8e8:	ec4e                	sd	s3,24(sp)
     8ea:	e852                	sd	s4,16(sp)
     8ec:	e456                	sd	s5,8(sp)
     8ee:	e05a                	sd	s6,0(sp)
     8f0:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     8f2:	4489                	li	s1,2
     8f4:	00001917          	auipc	s2,0x1
     8f8:	be490913          	addi	s2,s2,-1052 # 14d8 <malloc+0x1ee>
     8fc:	85a6                	mv	a1,s1
     8fe:	854a                	mv	a0,s2
     900:	538000ef          	jal	e38 <open>
     904:	00054663          	bltz	a0,910 <main+0x32>
    if(fd >= 3){
     908:	fea4dae3          	bge	s1,a0,8fc <main+0x1e>
      close(fd);
     90c:	514000ef          	jal	e20 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     910:	00001a97          	auipc	s5,0x1
     914:	710a8a93          	addi	s5,s5,1808 # 2020 <buf.0>
    while (*cmd == ' ' || *cmd == '\t')
     918:	02000913          	li	s2,32
     91c:	49a5                	li	s3,9
    if (*cmd == '\n') // is a blank command
     91e:	4b29                	li	s6,10
     920:	a815                	j	954 <main+0x76>
      cmd++;
     922:	0485                	addi	s1,s1,1
    while (*cmd == ' ' || *cmd == '\t')
     924:	0004c783          	lbu	a5,0(s1)
     928:	ff278de3          	beq	a5,s2,922 <main+0x44>
     92c:	ff378be3          	beq	a5,s3,922 <main+0x44>
    if (*cmd == '\n') // is a blank command
     930:	03678463          	beq	a5,s6,958 <main+0x7a>
    if(cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' '){
     934:	06300713          	li	a4,99
     938:	00e79863          	bne	a5,a4,948 <main+0x6a>
     93c:	0014c703          	lbu	a4,1(s1)
     940:	06400793          	li	a5,100
     944:	02f70563          	beq	a4,a5,96e <main+0x90>
      if(fork1() == 0)
     948:	f20ff0ef          	jal	68 <fork1>
     94c:	cd31                	beqz	a0,9a8 <main+0xca>
      wait(0);
     94e:	4501                	li	a0,0
     950:	4b0000ef          	jal	e00 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     954:	06400a13          	li	s4,100
     958:	85d2                	mv	a1,s4
     95a:	8556                	mv	a0,s5
     95c:	ea4ff0ef          	jal	0 <getcmd>
     960:	04054963          	bltz	a0,9b2 <main+0xd4>
    char *cmd = buf;
     964:	00001497          	auipc	s1,0x1
     968:	6bc48493          	addi	s1,s1,1724 # 2020 <buf.0>
     96c:	bf65                	j	924 <main+0x46>
    if(cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' '){
     96e:	0024c783          	lbu	a5,2(s1)
     972:	fd279be3          	bne	a5,s2,948 <main+0x6a>
      cmd[strlen(cmd)-1] = 0;  // chop \n
     976:	8526                	mv	a0,s1
     978:	0a0000ef          	jal	a18 <strlen>
     97c:	fff5079b          	addiw	a5,a0,-1
     980:	1782                	slli	a5,a5,0x20
     982:	9381                	srli	a5,a5,0x20
     984:	97a6                	add	a5,a5,s1
     986:	00078023          	sb	zero,0(a5)
      if(chdir(cmd+3) < 0)
     98a:	048d                	addi	s1,s1,3
     98c:	8526                	mv	a0,s1
     98e:	4da000ef          	jal	e68 <chdir>
     992:	fc0551e3          	bgez	a0,954 <main+0x76>
        fprintf(2, "cannot cd %s\n", cmd+3);
     996:	8626                	mv	a2,s1
     998:	00001597          	auipc	a1,0x1
     99c:	b4858593          	addi	a1,a1,-1208 # 14e0 <malloc+0x1f6>
     9a0:	4509                	li	a0,2
     9a2:	067000ef          	jal	1208 <fprintf>
     9a6:	b77d                	j	954 <main+0x76>
        runcmd(parsecmd(cmd));
     9a8:	8526                	mv	a0,s1
     9aa:	ec1ff0ef          	jal	86a <parsecmd>
     9ae:	ee0ff0ef          	jal	8e <runcmd>
  exit(0);
     9b2:	4501                	li	a0,0
     9b4:	444000ef          	jal	df8 <exit>

00000000000009b8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     9b8:	1141                	addi	sp,sp,-16
     9ba:	e406                	sd	ra,8(sp)
     9bc:	e022                	sd	s0,0(sp)
     9be:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     9c0:	f1fff0ef          	jal	8de <main>
  exit(r);
     9c4:	434000ef          	jal	df8 <exit>

00000000000009c8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9c8:	1141                	addi	sp,sp,-16
     9ca:	e406                	sd	ra,8(sp)
     9cc:	e022                	sd	s0,0(sp)
     9ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9d0:	87aa                	mv	a5,a0
     9d2:	0585                	addi	a1,a1,1
     9d4:	0785                	addi	a5,a5,1
     9d6:	fff5c703          	lbu	a4,-1(a1)
     9da:	fee78fa3          	sb	a4,-1(a5)
     9de:	fb75                	bnez	a4,9d2 <strcpy+0xa>
    ;
  return os;
}
     9e0:	60a2                	ld	ra,8(sp)
     9e2:	6402                	ld	s0,0(sp)
     9e4:	0141                	addi	sp,sp,16
     9e6:	8082                	ret

00000000000009e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9e8:	1141                	addi	sp,sp,-16
     9ea:	e406                	sd	ra,8(sp)
     9ec:	e022                	sd	s0,0(sp)
     9ee:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9f0:	00054783          	lbu	a5,0(a0)
     9f4:	cb91                	beqz	a5,a08 <strcmp+0x20>
     9f6:	0005c703          	lbu	a4,0(a1)
     9fa:	00f71763          	bne	a4,a5,a08 <strcmp+0x20>
    p++, q++;
     9fe:	0505                	addi	a0,a0,1
     a00:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     a02:	00054783          	lbu	a5,0(a0)
     a06:	fbe5                	bnez	a5,9f6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     a08:	0005c503          	lbu	a0,0(a1)
}
     a0c:	40a7853b          	subw	a0,a5,a0
     a10:	60a2                	ld	ra,8(sp)
     a12:	6402                	ld	s0,0(sp)
     a14:	0141                	addi	sp,sp,16
     a16:	8082                	ret

0000000000000a18 <strlen>:

uint
strlen(const char *s)
{
     a18:	1141                	addi	sp,sp,-16
     a1a:	e406                	sd	ra,8(sp)
     a1c:	e022                	sd	s0,0(sp)
     a1e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     a20:	00054783          	lbu	a5,0(a0)
     a24:	cf99                	beqz	a5,a42 <strlen+0x2a>
     a26:	0505                	addi	a0,a0,1
     a28:	87aa                	mv	a5,a0
     a2a:	86be                	mv	a3,a5
     a2c:	0785                	addi	a5,a5,1
     a2e:	fff7c703          	lbu	a4,-1(a5)
     a32:	ff65                	bnez	a4,a2a <strlen+0x12>
     a34:	40a6853b          	subw	a0,a3,a0
     a38:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     a3a:	60a2                	ld	ra,8(sp)
     a3c:	6402                	ld	s0,0(sp)
     a3e:	0141                	addi	sp,sp,16
     a40:	8082                	ret
  for(n = 0; s[n]; n++)
     a42:	4501                	li	a0,0
     a44:	bfdd                	j	a3a <strlen+0x22>

0000000000000a46 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a46:	1141                	addi	sp,sp,-16
     a48:	e406                	sd	ra,8(sp)
     a4a:	e022                	sd	s0,0(sp)
     a4c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a4e:	ca19                	beqz	a2,a64 <memset+0x1e>
     a50:	87aa                	mv	a5,a0
     a52:	1602                	slli	a2,a2,0x20
     a54:	9201                	srli	a2,a2,0x20
     a56:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a5a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a5e:	0785                	addi	a5,a5,1
     a60:	fee79de3          	bne	a5,a4,a5a <memset+0x14>
  }
  return dst;
}
     a64:	60a2                	ld	ra,8(sp)
     a66:	6402                	ld	s0,0(sp)
     a68:	0141                	addi	sp,sp,16
     a6a:	8082                	ret

0000000000000a6c <strchr>:

char*
strchr(const char *s, char c)
{
     a6c:	1141                	addi	sp,sp,-16
     a6e:	e406                	sd	ra,8(sp)
     a70:	e022                	sd	s0,0(sp)
     a72:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a74:	00054783          	lbu	a5,0(a0)
     a78:	cf81                	beqz	a5,a90 <strchr+0x24>
    if(*s == c)
     a7a:	00f58763          	beq	a1,a5,a88 <strchr+0x1c>
  for(; *s; s++)
     a7e:	0505                	addi	a0,a0,1
     a80:	00054783          	lbu	a5,0(a0)
     a84:	fbfd                	bnez	a5,a7a <strchr+0xe>
      return (char*)s;
  return 0;
     a86:	4501                	li	a0,0
}
     a88:	60a2                	ld	ra,8(sp)
     a8a:	6402                	ld	s0,0(sp)
     a8c:	0141                	addi	sp,sp,16
     a8e:	8082                	ret
  return 0;
     a90:	4501                	li	a0,0
     a92:	bfdd                	j	a88 <strchr+0x1c>

0000000000000a94 <gets>:

char*
gets(char *buf, int max)
{
     a94:	7159                	addi	sp,sp,-112
     a96:	f486                	sd	ra,104(sp)
     a98:	f0a2                	sd	s0,96(sp)
     a9a:	eca6                	sd	s1,88(sp)
     a9c:	e8ca                	sd	s2,80(sp)
     a9e:	e4ce                	sd	s3,72(sp)
     aa0:	e0d2                	sd	s4,64(sp)
     aa2:	fc56                	sd	s5,56(sp)
     aa4:	f85a                	sd	s6,48(sp)
     aa6:	f45e                	sd	s7,40(sp)
     aa8:	f062                	sd	s8,32(sp)
     aaa:	ec66                	sd	s9,24(sp)
     aac:	e86a                	sd	s10,16(sp)
     aae:	1880                	addi	s0,sp,112
     ab0:	8caa                	mv	s9,a0
     ab2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ab4:	892a                	mv	s2,a0
     ab6:	4481                	li	s1,0
    cc = read(0, &c, 1);
     ab8:	f9f40b13          	addi	s6,s0,-97
     abc:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     abe:	4ba9                	li	s7,10
     ac0:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     ac2:	8d26                	mv	s10,s1
     ac4:	0014899b          	addiw	s3,s1,1
     ac8:	84ce                	mv	s1,s3
     aca:	0349d563          	bge	s3,s4,af4 <gets+0x60>
    cc = read(0, &c, 1);
     ace:	8656                	mv	a2,s5
     ad0:	85da                	mv	a1,s6
     ad2:	4501                	li	a0,0
     ad4:	33c000ef          	jal	e10 <read>
    if(cc < 1)
     ad8:	00a05e63          	blez	a0,af4 <gets+0x60>
    buf[i++] = c;
     adc:	f9f44783          	lbu	a5,-97(s0)
     ae0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     ae4:	01778763          	beq	a5,s7,af2 <gets+0x5e>
     ae8:	0905                	addi	s2,s2,1
     aea:	fd879ce3          	bne	a5,s8,ac2 <gets+0x2e>
    buf[i++] = c;
     aee:	8d4e                	mv	s10,s3
     af0:	a011                	j	af4 <gets+0x60>
     af2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     af4:	9d66                	add	s10,s10,s9
     af6:	000d0023          	sb	zero,0(s10)
  return buf;
}
     afa:	8566                	mv	a0,s9
     afc:	70a6                	ld	ra,104(sp)
     afe:	7406                	ld	s0,96(sp)
     b00:	64e6                	ld	s1,88(sp)
     b02:	6946                	ld	s2,80(sp)
     b04:	69a6                	ld	s3,72(sp)
     b06:	6a06                	ld	s4,64(sp)
     b08:	7ae2                	ld	s5,56(sp)
     b0a:	7b42                	ld	s6,48(sp)
     b0c:	7ba2                	ld	s7,40(sp)
     b0e:	7c02                	ld	s8,32(sp)
     b10:	6ce2                	ld	s9,24(sp)
     b12:	6d42                	ld	s10,16(sp)
     b14:	6165                	addi	sp,sp,112
     b16:	8082                	ret

0000000000000b18 <stat>:

int
stat(const char *n, struct stat *st)
{
     b18:	1101                	addi	sp,sp,-32
     b1a:	ec06                	sd	ra,24(sp)
     b1c:	e822                	sd	s0,16(sp)
     b1e:	e04a                	sd	s2,0(sp)
     b20:	1000                	addi	s0,sp,32
     b22:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b24:	4581                	li	a1,0
     b26:	312000ef          	jal	e38 <open>
  if(fd < 0)
     b2a:	02054263          	bltz	a0,b4e <stat+0x36>
     b2e:	e426                	sd	s1,8(sp)
     b30:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     b32:	85ca                	mv	a1,s2
     b34:	31c000ef          	jal	e50 <fstat>
     b38:	892a                	mv	s2,a0
  close(fd);
     b3a:	8526                	mv	a0,s1
     b3c:	2e4000ef          	jal	e20 <close>
  return r;
     b40:	64a2                	ld	s1,8(sp)
}
     b42:	854a                	mv	a0,s2
     b44:	60e2                	ld	ra,24(sp)
     b46:	6442                	ld	s0,16(sp)
     b48:	6902                	ld	s2,0(sp)
     b4a:	6105                	addi	sp,sp,32
     b4c:	8082                	ret
    return -1;
     b4e:	597d                	li	s2,-1
     b50:	bfcd                	j	b42 <stat+0x2a>

0000000000000b52 <atoi>:

int
atoi(const char *s)
{
     b52:	1141                	addi	sp,sp,-16
     b54:	e406                	sd	ra,8(sp)
     b56:	e022                	sd	s0,0(sp)
     b58:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b5a:	00054683          	lbu	a3,0(a0)
     b5e:	fd06879b          	addiw	a5,a3,-48
     b62:	0ff7f793          	zext.b	a5,a5
     b66:	4625                	li	a2,9
     b68:	02f66963          	bltu	a2,a5,b9a <atoi+0x48>
     b6c:	872a                	mv	a4,a0
  n = 0;
     b6e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b70:	0705                	addi	a4,a4,1
     b72:	0025179b          	slliw	a5,a0,0x2
     b76:	9fa9                	addw	a5,a5,a0
     b78:	0017979b          	slliw	a5,a5,0x1
     b7c:	9fb5                	addw	a5,a5,a3
     b7e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b82:	00074683          	lbu	a3,0(a4)
     b86:	fd06879b          	addiw	a5,a3,-48
     b8a:	0ff7f793          	zext.b	a5,a5
     b8e:	fef671e3          	bgeu	a2,a5,b70 <atoi+0x1e>
  return n;
}
     b92:	60a2                	ld	ra,8(sp)
     b94:	6402                	ld	s0,0(sp)
     b96:	0141                	addi	sp,sp,16
     b98:	8082                	ret
  n = 0;
     b9a:	4501                	li	a0,0
     b9c:	bfdd                	j	b92 <atoi+0x40>

0000000000000b9e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b9e:	1141                	addi	sp,sp,-16
     ba0:	e406                	sd	ra,8(sp)
     ba2:	e022                	sd	s0,0(sp)
     ba4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     ba6:	02b57563          	bgeu	a0,a1,bd0 <memmove+0x32>
    while(n-- > 0)
     baa:	00c05f63          	blez	a2,bc8 <memmove+0x2a>
     bae:	1602                	slli	a2,a2,0x20
     bb0:	9201                	srli	a2,a2,0x20
     bb2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     bb6:	872a                	mv	a4,a0
      *dst++ = *src++;
     bb8:	0585                	addi	a1,a1,1
     bba:	0705                	addi	a4,a4,1
     bbc:	fff5c683          	lbu	a3,-1(a1)
     bc0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     bc4:	fee79ae3          	bne	a5,a4,bb8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     bc8:	60a2                	ld	ra,8(sp)
     bca:	6402                	ld	s0,0(sp)
     bcc:	0141                	addi	sp,sp,16
     bce:	8082                	ret
    dst += n;
     bd0:	00c50733          	add	a4,a0,a2
    src += n;
     bd4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     bd6:	fec059e3          	blez	a2,bc8 <memmove+0x2a>
     bda:	fff6079b          	addiw	a5,a2,-1
     bde:	1782                	slli	a5,a5,0x20
     be0:	9381                	srli	a5,a5,0x20
     be2:	fff7c793          	not	a5,a5
     be6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     be8:	15fd                	addi	a1,a1,-1
     bea:	177d                	addi	a4,a4,-1
     bec:	0005c683          	lbu	a3,0(a1)
     bf0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     bf4:	fef71ae3          	bne	a4,a5,be8 <memmove+0x4a>
     bf8:	bfc1                	j	bc8 <memmove+0x2a>

0000000000000bfa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bfa:	1141                	addi	sp,sp,-16
     bfc:	e406                	sd	ra,8(sp)
     bfe:	e022                	sd	s0,0(sp)
     c00:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     c02:	ca0d                	beqz	a2,c34 <memcmp+0x3a>
     c04:	fff6069b          	addiw	a3,a2,-1
     c08:	1682                	slli	a3,a3,0x20
     c0a:	9281                	srli	a3,a3,0x20
     c0c:	0685                	addi	a3,a3,1
     c0e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     c10:	00054783          	lbu	a5,0(a0)
     c14:	0005c703          	lbu	a4,0(a1)
     c18:	00e79863          	bne	a5,a4,c28 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     c1c:	0505                	addi	a0,a0,1
    p2++;
     c1e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     c20:	fed518e3          	bne	a0,a3,c10 <memcmp+0x16>
  }
  return 0;
     c24:	4501                	li	a0,0
     c26:	a019                	j	c2c <memcmp+0x32>
      return *p1 - *p2;
     c28:	40e7853b          	subw	a0,a5,a4
}
     c2c:	60a2                	ld	ra,8(sp)
     c2e:	6402                	ld	s0,0(sp)
     c30:	0141                	addi	sp,sp,16
     c32:	8082                	ret
  return 0;
     c34:	4501                	li	a0,0
     c36:	bfdd                	j	c2c <memcmp+0x32>

0000000000000c38 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c38:	1141                	addi	sp,sp,-16
     c3a:	e406                	sd	ra,8(sp)
     c3c:	e022                	sd	s0,0(sp)
     c3e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c40:	f5fff0ef          	jal	b9e <memmove>
}
     c44:	60a2                	ld	ra,8(sp)
     c46:	6402                	ld	s0,0(sp)
     c48:	0141                	addi	sp,sp,16
     c4a:	8082                	ret

0000000000000c4c <sbrk>:

char *
sbrk(int n) {
     c4c:	1141                	addi	sp,sp,-16
     c4e:	e406                	sd	ra,8(sp)
     c50:	e022                	sd	s0,0(sp)
     c52:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c54:	4585                	li	a1,1
     c56:	22a000ef          	jal	e80 <sys_sbrk>
}
     c5a:	60a2                	ld	ra,8(sp)
     c5c:	6402                	ld	s0,0(sp)
     c5e:	0141                	addi	sp,sp,16
     c60:	8082                	ret

0000000000000c62 <sbrklazy>:

char *
sbrklazy(int n) {
     c62:	1141                	addi	sp,sp,-16
     c64:	e406                	sd	ra,8(sp)
     c66:	e022                	sd	s0,0(sp)
     c68:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c6a:	4589                	li	a1,2
     c6c:	214000ef          	jal	e80 <sys_sbrk>
}
     c70:	60a2                	ld	ra,8(sp)
     c72:	6402                	ld	s0,0(sp)
     c74:	0141                	addi	sp,sp,16
     c76:	8082                	ret

0000000000000c78 <create_thread>:

int
create_thread(void(*fn)(int *), int *arg)
{
     c78:	1101                	addi	sp,sp,-32
     c7a:	ec06                	sd	ra,24(sp)
     c7c:	e822                	sd	s0,16(sp)
     c7e:	e426                	sd	s1,8(sp)
     c80:	e04a                	sd	s2,0(sp)
     c82:	1000                	addi	s0,sp,32
     c84:	84aa                	mv	s1,a0
     c86:	892e                	mv	s2,a1
  uint64 sz = USERSTACK * PGSIZE;
  void *stack = sbrk(sz) + sz;
     c88:	6505                	lui	a0,0x1
     c8a:	fc3ff0ef          	jal	c4c <sbrk>
     c8e:	6785                	lui	a5,0x1
     c90:	00f50633          	add	a2,a0,a5
  stack -= (uint64)stack % 16;
  return clone(fn, arg, stack);
     c94:	9a41                	andi	a2,a2,-16
     c96:	85ca                	mv	a1,s2
     c98:	8526                	mv	a0,s1
     c9a:	1fe000ef          	jal	e98 <clone>
}
     c9e:	60e2                	ld	ra,24(sp)
     ca0:	6442                	ld	s0,16(sp)
     ca2:	64a2                	ld	s1,8(sp)
     ca4:	6902                	ld	s2,0(sp)
     ca6:	6105                	addi	sp,sp,32
     ca8:	8082                	ret

0000000000000caa <futex>:

void futex(int *uaddr, int ops, int val) {
     caa:	7179                	addi	sp,sp,-48
     cac:	f406                	sd	ra,40(sp)
     cae:	f022                	sd	s0,32(sp)
     cb0:	ec26                	sd	s1,24(sp)
     cb2:	1800                	addi	s0,sp,48
     cb4:	84aa                	mv	s1,a0
  if (ops==0) {
     cb6:	ed95                	bnez	a1,cf2 <futex+0x48>
    if (val==0) {
     cb8:	c611                	beqz	a2,cc4 <futex+0x1a>
     cba:	e84a                	sd	s2,16(sp)
     cbc:	e44e                	sd	s3,8(sp)
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
    }
    else {
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
     cbe:	4905                	li	s2,1
        futex_wait(uaddr, 1);
     cc0:	4985                	li	s3,1
     cc2:	a005                	j	ce2 <futex+0x38>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) ;
     cc4:	4705                	li	a4,1
     cc6:	87ba                	mv	a5,a4
     cc8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
     ccc:	2781                	sext.w	a5,a5
     cce:	ffe5                	bnez	a5,cc6 <futex+0x1c>
      __sync_lock_release(uaddr);
      futex_wake(uaddr);
    }
  }
  return;
}
     cd0:	70a2                	ld	ra,40(sp)
     cd2:	7402                	ld	s0,32(sp)
     cd4:	64e2                	ld	s1,24(sp)
     cd6:	6145                	addi	sp,sp,48
     cd8:	8082                	ret
        futex_wait(uaddr, 1);
     cda:	85ce                	mv	a1,s3
     cdc:	8526                	mv	a0,s1
     cde:	1ca000ef          	jal	ea8 <futex_wait>
      while(__sync_lock_test_and_set(uaddr, 1) != 0) {
     ce2:	87ca                	mv	a5,s2
     ce4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
     ce8:	2781                	sext.w	a5,a5
     cea:	fbe5                	bnez	a5,cda <futex+0x30>
     cec:	6942                	ld	s2,16(sp)
     cee:	69a2                	ld	s3,8(sp)
     cf0:	b7c5                	j	cd0 <futex+0x26>
    if (val==0) {
     cf2:	e611                	bnez	a2,cfe <futex+0x54>
      __sync_lock_release(uaddr);
     cf4:	0310000f          	fence	rw,w
     cf8:	00052023          	sw	zero,0(a0) # 1000 <vprintf+0x98>
     cfc:	bfd1                	j	cd0 <futex+0x26>
      __sync_lock_release(uaddr);
     cfe:	0310000f          	fence	rw,w
     d02:	00052023          	sw	zero,0(a0)
      futex_wake(uaddr);
     d06:	1aa000ef          	jal	eb0 <futex_wake>
  return;
     d0a:	b7d9                	j	cd0 <futex+0x26>

0000000000000d0c <sem_init>:

void sem_init(sem_t* s, int val) {
     d0c:	7179                	addi	sp,sp,-48
     d0e:	f406                	sd	ra,40(sp)
     d10:	f022                	sd	s0,32(sp)
     d12:	ec26                	sd	s1,24(sp)
     d14:	e84a                	sd	s2,16(sp)
     d16:	e44e                	sd	s3,8(sp)
     d18:	1800                	addi	s0,sp,48
     d1a:	84aa                	mv	s1,a0
     d1c:	892e                	mv	s2,a1
  futex(&s->lock, FUTEX_LOCK, 1);
     d1e:	00450993          	addi	s3,a0,4
     d22:	4605                	li	a2,1
     d24:	4581                	li	a1,0
     d26:	854e                	mv	a0,s3
     d28:	f83ff0ef          	jal	caa <futex>
  s->value = val;
     d2c:	0124a023          	sw	s2,0(s1)
  futex(&s->lock, FUTEX_UNLOCK, 1);
     d30:	4605                	li	a2,1
     d32:	85b2                	mv	a1,a2
     d34:	854e                	mv	a0,s3
     d36:	f75ff0ef          	jal	caa <futex>
  return;
}
     d3a:	70a2                	ld	ra,40(sp)
     d3c:	7402                	ld	s0,32(sp)
     d3e:	64e2                	ld	s1,24(sp)
     d40:	6942                	ld	s2,16(sp)
     d42:	69a2                	ld	s3,8(sp)
     d44:	6145                	addi	sp,sp,48
     d46:	8082                	ret

0000000000000d48 <sem_down>:

void sem_down(sem_t* s) {
     d48:	7179                	addi	sp,sp,-48
     d4a:	f406                	sd	ra,40(sp)
     d4c:	f022                	sd	s0,32(sp)
     d4e:	ec26                	sd	s1,24(sp)
     d50:	e84a                	sd	s2,16(sp)
     d52:	e44e                	sd	s3,8(sp)
     d54:	1800                	addi	s0,sp,48
     d56:	892a                	mv	s2,a0
  futex(&s->lock, FUTEX_LOCK, 1);
     d58:	00450993          	addi	s3,a0,4
     d5c:	4605                	li	a2,1
     d5e:	4581                	li	a1,0
     d60:	854e                	mv	a0,s3
     d62:	f49ff0ef          	jal	caa <futex>
  while(1) {
    if (s->value>0) {
     d66:	00092783          	lw	a5,0(s2)
      s->value--;
      break;
    }
    else {
      futex(&s->lock, FUTEX_UNLOCK, 1);
     d6a:	4485                	li	s1,1
    if (s->value>0) {
     d6c:	02f04463          	bgtz	a5,d94 <sem_down+0x4c>
      futex(&s->lock, FUTEX_UNLOCK, 1);
     d70:	8626                	mv	a2,s1
     d72:	85a6                	mv	a1,s1
     d74:	854e                	mv	a0,s3
     d76:	f35ff0ef          	jal	caa <futex>
      futex_wait(&s->value,1);
     d7a:	85a6                	mv	a1,s1
     d7c:	854a                	mv	a0,s2
     d7e:	12a000ef          	jal	ea8 <futex_wait>
      futex(&s->lock, FUTEX_LOCK, 1);
     d82:	8626                	mv	a2,s1
     d84:	4581                	li	a1,0
     d86:	854e                	mv	a0,s3
     d88:	f23ff0ef          	jal	caa <futex>
    if (s->value>0) {
     d8c:	00092783          	lw	a5,0(s2)
     d90:	fef050e3          	blez	a5,d70 <sem_down+0x28>
      s->value--;
     d94:	37fd                	addiw	a5,a5,-1 # fff <vprintf+0x97>
     d96:	00f92023          	sw	a5,0(s2)
    }
  }
  futex(&s->lock, FUTEX_UNLOCK, 1);
     d9a:	4605                	li	a2,1
     d9c:	85b2                	mv	a1,a2
     d9e:	854e                	mv	a0,s3
     da0:	f0bff0ef          	jal	caa <futex>
  return;
}
     da4:	70a2                	ld	ra,40(sp)
     da6:	7402                	ld	s0,32(sp)
     da8:	64e2                	ld	s1,24(sp)
     daa:	6942                	ld	s2,16(sp)
     dac:	69a2                	ld	s3,8(sp)
     dae:	6145                	addi	sp,sp,48
     db0:	8082                	ret

0000000000000db2 <sem_up>:

void sem_up(sem_t* s) {
     db2:	1101                	addi	sp,sp,-32
     db4:	ec06                	sd	ra,24(sp)
     db6:	e822                	sd	s0,16(sp)
     db8:	e426                	sd	s1,8(sp)
     dba:	e04a                	sd	s2,0(sp)
     dbc:	1000                	addi	s0,sp,32
     dbe:	84aa                	mv	s1,a0
  futex(&s->lock, FUTEX_LOCK, 1);
     dc0:	00450913          	addi	s2,a0,4
     dc4:	4605                	li	a2,1
     dc6:	4581                	li	a1,0
     dc8:	854a                	mv	a0,s2
     dca:	ee1ff0ef          	jal	caa <futex>
  s->value++;
     dce:	409c                	lw	a5,0(s1)
     dd0:	2785                	addiw	a5,a5,1
     dd2:	c09c                	sw	a5,0(s1)
  futex_wake(&s->value);
     dd4:	8526                	mv	a0,s1
     dd6:	0da000ef          	jal	eb0 <futex_wake>
  futex(&s->lock, FUTEX_UNLOCK, 1);
     dda:	4605                	li	a2,1
     ddc:	85b2                	mv	a1,a2
     dde:	854a                	mv	a0,s2
     de0:	ecbff0ef          	jal	caa <futex>
  return;
     de4:	60e2                	ld	ra,24(sp)
     de6:	6442                	ld	s0,16(sp)
     de8:	64a2                	ld	s1,8(sp)
     dea:	6902                	ld	s2,0(sp)
     dec:	6105                	addi	sp,sp,32
     dee:	8082                	ret

0000000000000df0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     df0:	4885                	li	a7,1
 ecall
     df2:	00000073          	ecall
 ret
     df6:	8082                	ret

0000000000000df8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     df8:	4889                	li	a7,2
 ecall
     dfa:	00000073          	ecall
 ret
     dfe:	8082                	ret

0000000000000e00 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e00:	488d                	li	a7,3
 ecall
     e02:	00000073          	ecall
 ret
     e06:	8082                	ret

0000000000000e08 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e08:	4891                	li	a7,4
 ecall
     e0a:	00000073          	ecall
 ret
     e0e:	8082                	ret

0000000000000e10 <read>:
.global read
read:
 li a7, SYS_read
     e10:	4895                	li	a7,5
 ecall
     e12:	00000073          	ecall
 ret
     e16:	8082                	ret

0000000000000e18 <write>:
.global write
write:
 li a7, SYS_write
     e18:	48c1                	li	a7,16
 ecall
     e1a:	00000073          	ecall
 ret
     e1e:	8082                	ret

0000000000000e20 <close>:
.global close
close:
 li a7, SYS_close
     e20:	48d5                	li	a7,21
 ecall
     e22:	00000073          	ecall
 ret
     e26:	8082                	ret

0000000000000e28 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e28:	4899                	li	a7,6
 ecall
     e2a:	00000073          	ecall
 ret
     e2e:	8082                	ret

0000000000000e30 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e30:	489d                	li	a7,7
 ecall
     e32:	00000073          	ecall
 ret
     e36:	8082                	ret

0000000000000e38 <open>:
.global open
open:
 li a7, SYS_open
     e38:	48bd                	li	a7,15
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e40:	48c5                	li	a7,17
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e48:	48c9                	li	a7,18
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e50:	48a1                	li	a7,8
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <link>:
.global link
link:
 li a7, SYS_link
     e58:	48cd                	li	a7,19
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e60:	48d1                	li	a7,20
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e68:	48a5                	li	a7,9
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e70:	48a9                	li	a7,10
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e78:	48ad                	li	a7,11
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     e80:	48b1                	li	a7,12
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <pause>:
.global pause
pause:
 li a7, SYS_pause
     e88:	48b5                	li	a7,13
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e90:	48b9                	li	a7,14
 ecall
     e92:	00000073          	ecall
 ret
     e96:	8082                	ret

0000000000000e98 <clone>:
.global clone
clone:
 li a7, SYS_clone
     e98:	48d9                	li	a7,22
 ecall
     e9a:	00000073          	ecall
 ret
     e9e:	8082                	ret

0000000000000ea0 <join>:
.global join
join:
 li a7, SYS_join
     ea0:	48dd                	li	a7,23
 ecall
     ea2:	00000073          	ecall
 ret
     ea6:	8082                	ret

0000000000000ea8 <futex_wait>:
.global futex_wait
futex_wait:
 li a7, SYS_futex_wait
     ea8:	48e1                	li	a7,24
 ecall
     eaa:	00000073          	ecall
 ret
     eae:	8082                	ret

0000000000000eb0 <futex_wake>:
.global futex_wake
futex_wake:
 li a7, SYS_futex_wake
     eb0:	48e5                	li	a7,25
 ecall
     eb2:	00000073          	ecall
 ret
     eb6:	8082                	ret

0000000000000eb8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     eb8:	1101                	addi	sp,sp,-32
     eba:	ec06                	sd	ra,24(sp)
     ebc:	e822                	sd	s0,16(sp)
     ebe:	1000                	addi	s0,sp,32
     ec0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ec4:	4605                	li	a2,1
     ec6:	fef40593          	addi	a1,s0,-17
     eca:	f4fff0ef          	jal	e18 <write>
}
     ece:	60e2                	ld	ra,24(sp)
     ed0:	6442                	ld	s0,16(sp)
     ed2:	6105                	addi	sp,sp,32
     ed4:	8082                	ret

0000000000000ed6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     ed6:	715d                	addi	sp,sp,-80
     ed8:	e486                	sd	ra,72(sp)
     eda:	e0a2                	sd	s0,64(sp)
     edc:	fc26                	sd	s1,56(sp)
     ede:	f84a                	sd	s2,48(sp)
     ee0:	f44e                	sd	s3,40(sp)
     ee2:	0880                	addi	s0,sp,80
     ee4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     ee6:	c299                	beqz	a3,eec <printint+0x16>
     ee8:	0605cc63          	bltz	a1,f60 <printint+0x8a>
  neg = 0;
     eec:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     eee:	fb840313          	addi	t1,s0,-72
  neg = 0;
     ef2:	869a                	mv	a3,t1
  i = 0;
     ef4:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     ef6:	00000817          	auipc	a6,0x0
     efa:	63280813          	addi	a6,a6,1586 # 1528 <digits>
     efe:	88be                	mv	a7,a5
     f00:	0017851b          	addiw	a0,a5,1
     f04:	87aa                	mv	a5,a0
     f06:	02c5f733          	remu	a4,a1,a2
     f0a:	9742                	add	a4,a4,a6
     f0c:	00074703          	lbu	a4,0(a4)
     f10:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     f14:	872e                	mv	a4,a1
     f16:	02c5d5b3          	divu	a1,a1,a2
     f1a:	0685                	addi	a3,a3,1
     f1c:	fec771e3          	bgeu	a4,a2,efe <printint+0x28>
  if(neg)
     f20:	000e0c63          	beqz	t3,f38 <printint+0x62>
    buf[i++] = '-';
     f24:	fd050793          	addi	a5,a0,-48
     f28:	00878533          	add	a0,a5,s0
     f2c:	02d00793          	li	a5,45
     f30:	fef50423          	sb	a5,-24(a0)
     f34:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
     f38:	fff7899b          	addiw	s3,a5,-1
     f3c:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
     f40:	fff4c583          	lbu	a1,-1(s1)
     f44:	854a                	mv	a0,s2
     f46:	f73ff0ef          	jal	eb8 <putc>
  while(--i >= 0)
     f4a:	39fd                	addiw	s3,s3,-1
     f4c:	14fd                	addi	s1,s1,-1
     f4e:	fe09d9e3          	bgez	s3,f40 <printint+0x6a>
}
     f52:	60a6                	ld	ra,72(sp)
     f54:	6406                	ld	s0,64(sp)
     f56:	74e2                	ld	s1,56(sp)
     f58:	7942                	ld	s2,48(sp)
     f5a:	79a2                	ld	s3,40(sp)
     f5c:	6161                	addi	sp,sp,80
     f5e:	8082                	ret
    x = -xx;
     f60:	40b005b3          	neg	a1,a1
    neg = 1;
     f64:	4e05                	li	t3,1
    x = -xx;
     f66:	b761                	j	eee <printint+0x18>

0000000000000f68 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f68:	711d                	addi	sp,sp,-96
     f6a:	ec86                	sd	ra,88(sp)
     f6c:	e8a2                	sd	s0,80(sp)
     f6e:	e4a6                	sd	s1,72(sp)
     f70:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f72:	0005c483          	lbu	s1,0(a1)
     f76:	28048463          	beqz	s1,11fe <vprintf+0x296>
     f7a:	e0ca                	sd	s2,64(sp)
     f7c:	fc4e                	sd	s3,56(sp)
     f7e:	f852                	sd	s4,48(sp)
     f80:	f456                	sd	s5,40(sp)
     f82:	f05a                	sd	s6,32(sp)
     f84:	ec5e                	sd	s7,24(sp)
     f86:	e862                	sd	s8,16(sp)
     f88:	e466                	sd	s9,8(sp)
     f8a:	8b2a                	mv	s6,a0
     f8c:	8a2e                	mv	s4,a1
     f8e:	8bb2                	mv	s7,a2
  state = 0;
     f90:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     f92:	4901                	li	s2,0
     f94:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     f96:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     f9a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     f9e:	06c00c93          	li	s9,108
     fa2:	a00d                	j	fc4 <vprintf+0x5c>
        putc(fd, c0);
     fa4:	85a6                	mv	a1,s1
     fa6:	855a                	mv	a0,s6
     fa8:	f11ff0ef          	jal	eb8 <putc>
     fac:	a019                	j	fb2 <vprintf+0x4a>
    } else if(state == '%'){
     fae:	03598363          	beq	s3,s5,fd4 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
     fb2:	0019079b          	addiw	a5,s2,1
     fb6:	893e                	mv	s2,a5
     fb8:	873e                	mv	a4,a5
     fba:	97d2                	add	a5,a5,s4
     fbc:	0007c483          	lbu	s1,0(a5)
     fc0:	22048763          	beqz	s1,11ee <vprintf+0x286>
    c0 = fmt[i] & 0xff;
     fc4:	0004879b          	sext.w	a5,s1
    if(state == 0){
     fc8:	fe0993e3          	bnez	s3,fae <vprintf+0x46>
      if(c0 == '%'){
     fcc:	fd579ce3          	bne	a5,s5,fa4 <vprintf+0x3c>
        state = '%';
     fd0:	89be                	mv	s3,a5
     fd2:	b7c5                	j	fb2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     fd4:	00ea06b3          	add	a3,s4,a4
     fd8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     fdc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     fde:	c681                	beqz	a3,fe6 <vprintf+0x7e>
     fe0:	9752                	add	a4,a4,s4
     fe2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     fe6:	05878263          	beq	a5,s8,102a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     fea:	05978c63          	beq	a5,s9,1042 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     fee:	07500713          	li	a4,117
     ff2:	0ee78663          	beq	a5,a4,10de <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     ff6:	07800713          	li	a4,120
     ffa:	12e78863          	beq	a5,a4,112a <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     ffe:	07000713          	li	a4,112
    1002:	14e78d63          	beq	a5,a4,115c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
    1006:	06300713          	li	a4,99
    100a:	18e78c63          	beq	a5,a4,11a2 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
    100e:	07300713          	li	a4,115
    1012:	1ae78263          	beq	a5,a4,11b6 <vprintf+0x24e>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1016:	02500713          	li	a4,37
    101a:	04e79463          	bne	a5,a4,1062 <vprintf+0xfa>
        putc(fd, '%');
    101e:	85ba                	mv	a1,a4
    1020:	855a                	mv	a0,s6
    1022:	e97ff0ef          	jal	eb8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    1026:	4981                	li	s3,0
    1028:	b769                	j	fb2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    102a:	008b8493          	addi	s1,s7,8
    102e:	4685                	li	a3,1
    1030:	4629                	li	a2,10
    1032:	000ba583          	lw	a1,0(s7)
    1036:	855a                	mv	a0,s6
    1038:	e9fff0ef          	jal	ed6 <printint>
    103c:	8ba6                	mv	s7,s1
      state = 0;
    103e:	4981                	li	s3,0
    1040:	bf8d                	j	fb2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1042:	06400793          	li	a5,100
    1046:	02f68963          	beq	a3,a5,1078 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    104a:	06c00793          	li	a5,108
    104e:	04f68263          	beq	a3,a5,1092 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
    1052:	07500793          	li	a5,117
    1056:	0af68063          	beq	a3,a5,10f6 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
    105a:	07800793          	li	a5,120
    105e:	0ef68263          	beq	a3,a5,1142 <vprintf+0x1da>
        putc(fd, '%');
    1062:	02500593          	li	a1,37
    1066:	855a                	mv	a0,s6
    1068:	e51ff0ef          	jal	eb8 <putc>
        putc(fd, c0);
    106c:	85a6                	mv	a1,s1
    106e:	855a                	mv	a0,s6
    1070:	e49ff0ef          	jal	eb8 <putc>
      state = 0;
    1074:	4981                	li	s3,0
    1076:	bf35                	j	fb2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1078:	008b8493          	addi	s1,s7,8
    107c:	4685                	li	a3,1
    107e:	4629                	li	a2,10
    1080:	000bb583          	ld	a1,0(s7)
    1084:	855a                	mv	a0,s6
    1086:	e51ff0ef          	jal	ed6 <printint>
        i += 1;
    108a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    108c:	8ba6                	mv	s7,s1
      state = 0;
    108e:	4981                	li	s3,0
        i += 1;
    1090:	b70d                	j	fb2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1092:	06400793          	li	a5,100
    1096:	02f60763          	beq	a2,a5,10c4 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    109a:	07500793          	li	a5,117
    109e:	06f60963          	beq	a2,a5,1110 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    10a2:	07800793          	li	a5,120
    10a6:	faf61ee3          	bne	a2,a5,1062 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
    10aa:	008b8493          	addi	s1,s7,8
    10ae:	4681                	li	a3,0
    10b0:	4641                	li	a2,16
    10b2:	000bb583          	ld	a1,0(s7)
    10b6:	855a                	mv	a0,s6
    10b8:	e1fff0ef          	jal	ed6 <printint>
        i += 2;
    10bc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    10be:	8ba6                	mv	s7,s1
      state = 0;
    10c0:	4981                	li	s3,0
        i += 2;
    10c2:	bdc5                	j	fb2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    10c4:	008b8493          	addi	s1,s7,8
    10c8:	4685                	li	a3,1
    10ca:	4629                	li	a2,10
    10cc:	000bb583          	ld	a1,0(s7)
    10d0:	855a                	mv	a0,s6
    10d2:	e05ff0ef          	jal	ed6 <printint>
        i += 2;
    10d6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    10d8:	8ba6                	mv	s7,s1
      state = 0;
    10da:	4981                	li	s3,0
        i += 2;
    10dc:	bdd9                	j	fb2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
    10de:	008b8493          	addi	s1,s7,8
    10e2:	4681                	li	a3,0
    10e4:	4629                	li	a2,10
    10e6:	000be583          	lwu	a1,0(s7)
    10ea:	855a                	mv	a0,s6
    10ec:	debff0ef          	jal	ed6 <printint>
    10f0:	8ba6                	mv	s7,s1
      state = 0;
    10f2:	4981                	li	s3,0
    10f4:	bd7d                	j	fb2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10f6:	008b8493          	addi	s1,s7,8
    10fa:	4681                	li	a3,0
    10fc:	4629                	li	a2,10
    10fe:	000bb583          	ld	a1,0(s7)
    1102:	855a                	mv	a0,s6
    1104:	dd3ff0ef          	jal	ed6 <printint>
        i += 1;
    1108:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    110a:	8ba6                	mv	s7,s1
      state = 0;
    110c:	4981                	li	s3,0
        i += 1;
    110e:	b555                	j	fb2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1110:	008b8493          	addi	s1,s7,8
    1114:	4681                	li	a3,0
    1116:	4629                	li	a2,10
    1118:	000bb583          	ld	a1,0(s7)
    111c:	855a                	mv	a0,s6
    111e:	db9ff0ef          	jal	ed6 <printint>
        i += 2;
    1122:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1124:	8ba6                	mv	s7,s1
      state = 0;
    1126:	4981                	li	s3,0
        i += 2;
    1128:	b569                	j	fb2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
    112a:	008b8493          	addi	s1,s7,8
    112e:	4681                	li	a3,0
    1130:	4641                	li	a2,16
    1132:	000be583          	lwu	a1,0(s7)
    1136:	855a                	mv	a0,s6
    1138:	d9fff0ef          	jal	ed6 <printint>
    113c:	8ba6                	mv	s7,s1
      state = 0;
    113e:	4981                	li	s3,0
    1140:	bd8d                	j	fb2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1142:	008b8493          	addi	s1,s7,8
    1146:	4681                	li	a3,0
    1148:	4641                	li	a2,16
    114a:	000bb583          	ld	a1,0(s7)
    114e:	855a                	mv	a0,s6
    1150:	d87ff0ef          	jal	ed6 <printint>
        i += 1;
    1154:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1156:	8ba6                	mv	s7,s1
      state = 0;
    1158:	4981                	li	s3,0
        i += 1;
    115a:	bda1                	j	fb2 <vprintf+0x4a>
    115c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    115e:	008b8d13          	addi	s10,s7,8
    1162:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1166:	03000593          	li	a1,48
    116a:	855a                	mv	a0,s6
    116c:	d4dff0ef          	jal	eb8 <putc>
  putc(fd, 'x');
    1170:	07800593          	li	a1,120
    1174:	855a                	mv	a0,s6
    1176:	d43ff0ef          	jal	eb8 <putc>
    117a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    117c:	00000b97          	auipc	s7,0x0
    1180:	3acb8b93          	addi	s7,s7,940 # 1528 <digits>
    1184:	03c9d793          	srli	a5,s3,0x3c
    1188:	97de                	add	a5,a5,s7
    118a:	0007c583          	lbu	a1,0(a5)
    118e:	855a                	mv	a0,s6
    1190:	d29ff0ef          	jal	eb8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1194:	0992                	slli	s3,s3,0x4
    1196:	34fd                	addiw	s1,s1,-1
    1198:	f4f5                	bnez	s1,1184 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
    119a:	8bea                	mv	s7,s10
      state = 0;
    119c:	4981                	li	s3,0
    119e:	6d02                	ld	s10,0(sp)
    11a0:	bd09                	j	fb2 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    11a2:	008b8493          	addi	s1,s7,8
    11a6:	000bc583          	lbu	a1,0(s7)
    11aa:	855a                	mv	a0,s6
    11ac:	d0dff0ef          	jal	eb8 <putc>
    11b0:	8ba6                	mv	s7,s1
      state = 0;
    11b2:	4981                	li	s3,0
    11b4:	bbfd                	j	fb2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    11b6:	008b8993          	addi	s3,s7,8
    11ba:	000bb483          	ld	s1,0(s7)
    11be:	cc91                	beqz	s1,11da <vprintf+0x272>
        for(; *s; s++)
    11c0:	0004c583          	lbu	a1,0(s1)
    11c4:	c195                	beqz	a1,11e8 <vprintf+0x280>
          putc(fd, *s);
    11c6:	855a                	mv	a0,s6
    11c8:	cf1ff0ef          	jal	eb8 <putc>
        for(; *s; s++)
    11cc:	0485                	addi	s1,s1,1
    11ce:	0004c583          	lbu	a1,0(s1)
    11d2:	f9f5                	bnez	a1,11c6 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
    11d4:	8bce                	mv	s7,s3
      state = 0;
    11d6:	4981                	li	s3,0
    11d8:	bbe9                	j	fb2 <vprintf+0x4a>
          s = "(null)";
    11da:	00000497          	auipc	s1,0x0
    11de:	31648493          	addi	s1,s1,790 # 14f0 <malloc+0x206>
        for(; *s; s++)
    11e2:	02800593          	li	a1,40
    11e6:	b7c5                	j	11c6 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
    11e8:	8bce                	mv	s7,s3
      state = 0;
    11ea:	4981                	li	s3,0
    11ec:	b3d9                	j	fb2 <vprintf+0x4a>
    11ee:	6906                	ld	s2,64(sp)
    11f0:	79e2                	ld	s3,56(sp)
    11f2:	7a42                	ld	s4,48(sp)
    11f4:	7aa2                	ld	s5,40(sp)
    11f6:	7b02                	ld	s6,32(sp)
    11f8:	6be2                	ld	s7,24(sp)
    11fa:	6c42                	ld	s8,16(sp)
    11fc:	6ca2                	ld	s9,8(sp)
    }
  }
}
    11fe:	60e6                	ld	ra,88(sp)
    1200:	6446                	ld	s0,80(sp)
    1202:	64a6                	ld	s1,72(sp)
    1204:	6125                	addi	sp,sp,96
    1206:	8082                	ret

0000000000001208 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1208:	715d                	addi	sp,sp,-80
    120a:	ec06                	sd	ra,24(sp)
    120c:	e822                	sd	s0,16(sp)
    120e:	1000                	addi	s0,sp,32
    1210:	e010                	sd	a2,0(s0)
    1212:	e414                	sd	a3,8(s0)
    1214:	e818                	sd	a4,16(s0)
    1216:	ec1c                	sd	a5,24(s0)
    1218:	03043023          	sd	a6,32(s0)
    121c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1220:	8622                	mv	a2,s0
    1222:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1226:	d43ff0ef          	jal	f68 <vprintf>
}
    122a:	60e2                	ld	ra,24(sp)
    122c:	6442                	ld	s0,16(sp)
    122e:	6161                	addi	sp,sp,80
    1230:	8082                	ret

0000000000001232 <printf>:

void
printf(const char *fmt, ...)
{
    1232:	711d                	addi	sp,sp,-96
    1234:	ec06                	sd	ra,24(sp)
    1236:	e822                	sd	s0,16(sp)
    1238:	1000                	addi	s0,sp,32
    123a:	e40c                	sd	a1,8(s0)
    123c:	e810                	sd	a2,16(s0)
    123e:	ec14                	sd	a3,24(s0)
    1240:	f018                	sd	a4,32(s0)
    1242:	f41c                	sd	a5,40(s0)
    1244:	03043823          	sd	a6,48(s0)
    1248:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    124c:	00840613          	addi	a2,s0,8
    1250:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1254:	85aa                	mv	a1,a0
    1256:	4505                	li	a0,1
    1258:	d11ff0ef          	jal	f68 <vprintf>
}
    125c:	60e2                	ld	ra,24(sp)
    125e:	6442                	ld	s0,16(sp)
    1260:	6125                	addi	sp,sp,96
    1262:	8082                	ret

0000000000001264 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1264:	1141                	addi	sp,sp,-16
    1266:	e406                	sd	ra,8(sp)
    1268:	e022                	sd	s0,0(sp)
    126a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    126c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1270:	00001797          	auipc	a5,0x1
    1274:	da07b783          	ld	a5,-608(a5) # 2010 <freep>
    1278:	a02d                	j	12a2 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    127a:	4618                	lw	a4,8(a2)
    127c:	9f2d                	addw	a4,a4,a1
    127e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1282:	6398                	ld	a4,0(a5)
    1284:	6310                	ld	a2,0(a4)
    1286:	a83d                	j	12c4 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1288:	ff852703          	lw	a4,-8(a0)
    128c:	9f31                	addw	a4,a4,a2
    128e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1290:	ff053683          	ld	a3,-16(a0)
    1294:	a091                	j	12d8 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1296:	6398                	ld	a4,0(a5)
    1298:	00e7e463          	bltu	a5,a4,12a0 <free+0x3c>
    129c:	00e6ea63          	bltu	a3,a4,12b0 <free+0x4c>
{
    12a0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12a2:	fed7fae3          	bgeu	a5,a3,1296 <free+0x32>
    12a6:	6398                	ld	a4,0(a5)
    12a8:	00e6e463          	bltu	a3,a4,12b0 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12ac:	fee7eae3          	bltu	a5,a4,12a0 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    12b0:	ff852583          	lw	a1,-8(a0)
    12b4:	6390                	ld	a2,0(a5)
    12b6:	02059813          	slli	a6,a1,0x20
    12ba:	01c85713          	srli	a4,a6,0x1c
    12be:	9736                	add	a4,a4,a3
    12c0:	fae60de3          	beq	a2,a4,127a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    12c4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    12c8:	4790                	lw	a2,8(a5)
    12ca:	02061593          	slli	a1,a2,0x20
    12ce:	01c5d713          	srli	a4,a1,0x1c
    12d2:	973e                	add	a4,a4,a5
    12d4:	fae68ae3          	beq	a3,a4,1288 <free+0x24>
    p->s.ptr = bp->s.ptr;
    12d8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    12da:	00001717          	auipc	a4,0x1
    12de:	d2f73b23          	sd	a5,-714(a4) # 2010 <freep>
}
    12e2:	60a2                	ld	ra,8(sp)
    12e4:	6402                	ld	s0,0(sp)
    12e6:	0141                	addi	sp,sp,16
    12e8:	8082                	ret

00000000000012ea <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    12ea:	7139                	addi	sp,sp,-64
    12ec:	fc06                	sd	ra,56(sp)
    12ee:	f822                	sd	s0,48(sp)
    12f0:	f04a                	sd	s2,32(sp)
    12f2:	ec4e                	sd	s3,24(sp)
    12f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12f6:	02051993          	slli	s3,a0,0x20
    12fa:	0209d993          	srli	s3,s3,0x20
    12fe:	09bd                	addi	s3,s3,15
    1300:	0049d993          	srli	s3,s3,0x4
    1304:	2985                	addiw	s3,s3,1
    1306:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1308:	00001517          	auipc	a0,0x1
    130c:	d0853503          	ld	a0,-760(a0) # 2010 <freep>
    1310:	c905                	beqz	a0,1340 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1312:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1314:	4798                	lw	a4,8(a5)
    1316:	09377663          	bgeu	a4,s3,13a2 <malloc+0xb8>
    131a:	f426                	sd	s1,40(sp)
    131c:	e852                	sd	s4,16(sp)
    131e:	e456                	sd	s5,8(sp)
    1320:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1322:	8a4e                	mv	s4,s3
    1324:	6705                	lui	a4,0x1
    1326:	00e9f363          	bgeu	s3,a4,132c <malloc+0x42>
    132a:	6a05                	lui	s4,0x1
    132c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1330:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1334:	00001497          	auipc	s1,0x1
    1338:	cdc48493          	addi	s1,s1,-804 # 2010 <freep>
  if(p == SBRK_ERROR)
    133c:	5afd                	li	s5,-1
    133e:	a83d                	j	137c <malloc+0x92>
    1340:	f426                	sd	s1,40(sp)
    1342:	e852                	sd	s4,16(sp)
    1344:	e456                	sd	s5,8(sp)
    1346:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1348:	00001797          	auipc	a5,0x1
    134c:	d4078793          	addi	a5,a5,-704 # 2088 <base>
    1350:	00001717          	auipc	a4,0x1
    1354:	ccf73023          	sd	a5,-832(a4) # 2010 <freep>
    1358:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    135a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    135e:	b7d1                	j	1322 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    1360:	6398                	ld	a4,0(a5)
    1362:	e118                	sd	a4,0(a0)
    1364:	a899                	j	13ba <malloc+0xd0>
  hp->s.size = nu;
    1366:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    136a:	0541                	addi	a0,a0,16
    136c:	ef9ff0ef          	jal	1264 <free>
  return freep;
    1370:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    1372:	c125                	beqz	a0,13d2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1374:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1376:	4798                	lw	a4,8(a5)
    1378:	03277163          	bgeu	a4,s2,139a <malloc+0xb0>
    if(p == freep)
    137c:	6098                	ld	a4,0(s1)
    137e:	853e                	mv	a0,a5
    1380:	fef71ae3          	bne	a4,a5,1374 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    1384:	8552                	mv	a0,s4
    1386:	8c7ff0ef          	jal	c4c <sbrk>
  if(p == SBRK_ERROR)
    138a:	fd551ee3          	bne	a0,s5,1366 <malloc+0x7c>
        return 0;
    138e:	4501                	li	a0,0
    1390:	74a2                	ld	s1,40(sp)
    1392:	6a42                	ld	s4,16(sp)
    1394:	6aa2                	ld	s5,8(sp)
    1396:	6b02                	ld	s6,0(sp)
    1398:	a03d                	j	13c6 <malloc+0xdc>
    139a:	74a2                	ld	s1,40(sp)
    139c:	6a42                	ld	s4,16(sp)
    139e:	6aa2                	ld	s5,8(sp)
    13a0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    13a2:	fae90fe3          	beq	s2,a4,1360 <malloc+0x76>
        p->s.size -= nunits;
    13a6:	4137073b          	subw	a4,a4,s3
    13aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
    13ac:	02071693          	slli	a3,a4,0x20
    13b0:	01c6d713          	srli	a4,a3,0x1c
    13b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    13b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    13ba:	00001717          	auipc	a4,0x1
    13be:	c4a73b23          	sd	a0,-938(a4) # 2010 <freep>
      return (void*)(p + 1);
    13c2:	01078513          	addi	a0,a5,16
  }
}
    13c6:	70e2                	ld	ra,56(sp)
    13c8:	7442                	ld	s0,48(sp)
    13ca:	7902                	ld	s2,32(sp)
    13cc:	69e2                	ld	s3,24(sp)
    13ce:	6121                	addi	sp,sp,64
    13d0:	8082                	ret
    13d2:	74a2                	ld	s1,40(sp)
    13d4:	6a42                	ld	s4,16(sp)
    13d6:	6aa2                	ld	s5,8(sp)
    13d8:	6b02                	ld	s6,0(sp)
    13da:	b7f5                	j	13c6 <malloc+0xdc>
