
user/_eg:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
}
   close(fd);
}

char*
fmtname(char *path) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
   // static char buf[DIRSIZ+1];
    char *p;

    // Find first character after last slash.
    for (p = path + strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	23a080e7          	jalr	570(ra) # 246 <strlen>
  14:	1502                	slli	a0,a0,0x20
  16:	9101                	srli	a0,a0,0x20
  18:	9526                	add	a0,a0,s1
  1a:	02f00713          	li	a4,47
  1e:	00956963          	bltu	a0,s1,30 <fmtname+0x30>
  22:	00054783          	lbu	a5,0(a0)
  26:	00e78563          	beq	a5,a4,30 <fmtname+0x30>
  2a:	157d                	addi	a0,a0,-1
  2c:	fe957be3          	bgeu	a0,s1,22 <fmtname+0x22>
   // if (strlen(p) >= DIRSIZ)
        return p;
   // memmove(buf, p, strlen(p));
   // memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
   // return buf;
}
  30:	0505                	addi	a0,a0,1
  32:	60e2                	ld	ra,24(sp)
  34:	6442                	ld	s0,16(sp)
  36:	64a2                	ld	s1,8(sp)
  38:	6105                	addi	sp,sp,32
  3a:	8082                	ret

000000000000003c <recur_>:
void recur_(char* path, char* target){
  3c:	db010113          	addi	sp,sp,-592
  40:	24113423          	sd	ra,584(sp)
  44:	24813023          	sd	s0,576(sp)
  48:	22913c23          	sd	s1,568(sp)
  4c:	23213823          	sd	s2,560(sp)
  50:	23313423          	sd	s3,552(sp)
  54:	23413023          	sd	s4,544(sp)
  58:	21513c23          	sd	s5,536(sp)
  5c:	21613823          	sd	s6,528(sp)
  60:	21713423          	sd	s7,520(sp)
  64:	21813023          	sd	s8,512(sp)
  68:	0c80                	addi	s0,sp,592
  6a:	8a2a                	mv	s4,a0
  6c:	8aae                	mv	s5,a1
  fd = open(path, O_RDONLY);
  6e:	4581                	li	a1,0
  70:	00000097          	auipc	ra,0x0
  74:	43c080e7          	jalr	1084(ra) # 4ac <open>
  78:	84aa                	mv	s1,a0
  fstat(fd, &st);// we need to check the type of the file or directory.
  7a:	00001917          	auipc	s2,0x1
  7e:	f9690913          	addi	s2,s2,-106 # 1010 <st>
  82:	85ca                	mv	a1,s2
  84:	00000097          	auipc	ra,0x0
  88:	440080e7          	jalr	1088(ra) # 4c4 <fstat>
  if(st.type == 2){
  8c:	00891783          	lh	a5,8(s2)
  90:	0007869b          	sext.w	a3,a5
  94:	4709                	li	a4,2
  96:	0ae68a63          	beq	a3,a4,14a <recur_+0x10e>
  else if(st.type == 3){
  9a:	2781                	sext.w	a5,a5
  9c:	470d                	li	a4,3
  9e:	0ee78163          	beq	a5,a4,180 <recur_+0x144>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
  a2:	00001917          	auipc	s2,0x1
  a6:	f8690913          	addi	s2,s2,-122 # 1028 <de>
      if(de.inum != 0 && strcmp(de.name , ".") && strcmp(de.name, "..")){// iterate throuth all the subitems.
  aa:	00001997          	auipc	s3,0x1
  ae:	f6698993          	addi	s3,s3,-154 # 1010 <st>
  b2:	00001b17          	auipc	s6,0x1
  b6:	f78b0b13          	addi	s6,s6,-136 # 102a <de+0x2>
  ba:	00001b97          	auipc	s7,0x1
  be:	8eeb8b93          	addi	s7,s7,-1810 # 9a8 <malloc+0xf6>
  c2:	00001c17          	auipc	s8,0x1
  c6:	8eec0c13          	addi	s8,s8,-1810 # 9b0 <malloc+0xfe>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
  ca:	4641                	li	a2,16
  cc:	85ca                	mv	a1,s2
  ce:	8526                	mv	a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	3b4080e7          	jalr	948(ra) # 484 <read>
  d8:	47c1                	li	a5,16
  da:	0af51963          	bne	a0,a5,18c <recur_+0x150>
      if(de.inum != 0 && strcmp(de.name , ".") && strcmp(de.name, "..")){// iterate throuth all the subitems.
  de:	0189d783          	lhu	a5,24(s3)
  e2:	d7e5                	beqz	a5,ca <recur_+0x8e>
  e4:	85de                	mv	a1,s7
  e6:	855a                	mv	a0,s6
  e8:	00000097          	auipc	ra,0x0
  ec:	132080e7          	jalr	306(ra) # 21a <strcmp>
  f0:	dd69                	beqz	a0,ca <recur_+0x8e>
  f2:	85e2                	mv	a1,s8
  f4:	855a                	mv	a0,s6
  f6:	00000097          	auipc	ra,0x0
  fa:	124080e7          	jalr	292(ra) # 21a <strcmp>
  fe:	d571                	beqz	a0,ca <recur_+0x8e>
	strcpy(buf, path);
 100:	85d2                	mv	a1,s4
 102:	db040513          	addi	a0,s0,-592
 106:	00000097          	auipc	ra,0x0
 10a:	0f8080e7          	jalr	248(ra) # 1fe <strcpy>
	p = buf + strlen(buf);//p pointing to the end of the buf, namely '\0'
 10e:	db040513          	addi	a0,s0,-592
 112:	00000097          	auipc	ra,0x0
 116:	134080e7          	jalr	308(ra) # 246 <strlen>
 11a:	1502                	slli	a0,a0,0x20
 11c:	9101                	srli	a0,a0,0x20
 11e:	db040793          	addi	a5,s0,-592
 122:	953e                	add	a0,a0,a5
	*p = '/';
 124:	02f00793          	li	a5,47
 128:	00f50023          	sb	a5,0(a0)
        memmove(p, de.name, DIRSIZ);
 12c:	4639                	li	a2,14
 12e:	85da                	mv	a1,s6
 130:	0505                	addi	a0,a0,1
 132:	00000097          	auipc	ra,0x0
 136:	288080e7          	jalr	648(ra) # 3ba <memmove>
	recur_(buf, target);
 13a:	85d6                	mv	a1,s5
 13c:	db040513          	addi	a0,s0,-592
 140:	00000097          	auipc	ra,0x0
 144:	efc080e7          	jalr	-260(ra) # 3c <recur_>
 148:	b749                	j	ca <recur_+0x8e>
    if(strcmp(fmtname(path), target) == 0) {
 14a:	8552                	mv	a0,s4
 14c:	00000097          	auipc	ra,0x0
 150:	eb4080e7          	jalr	-332(ra) # 0 <fmtname>
 154:	85d6                	mv	a1,s5
 156:	00000097          	auipc	ra,0x0
 15a:	0c4080e7          	jalr	196(ra) # 21a <strcmp>
 15e:	c519                	beqz	a0,16c <recur_+0x130>
    close(fd);
 160:	8526                	mv	a0,s1
 162:	00000097          	auipc	ra,0x0
 166:	332080e7          	jalr	818(ra) # 494 <close>
    return;
 16a:	a035                	j	196 <recur_+0x15a>
      printf("%s\n", path);
 16c:	85d2                	mv	a1,s4
 16e:	00001517          	auipc	a0,0x1
 172:	83250513          	addi	a0,a0,-1998 # 9a0 <malloc+0xee>
 176:	00000097          	auipc	ra,0x0
 17a:	67e080e7          	jalr	1662(ra) # 7f4 <printf>
 17e:	b7cd                	j	160 <recur_+0x124>
     close(fd);
 180:	8526                	mv	a0,s1
 182:	00000097          	auipc	ra,0x0
 186:	312080e7          	jalr	786(ra) # 494 <close>
     return;
 18a:	a031                	j	196 <recur_+0x15a>
   close(fd);
 18c:	8526                	mv	a0,s1
 18e:	00000097          	auipc	ra,0x0
 192:	306080e7          	jalr	774(ra) # 494 <close>
}
 196:	24813083          	ld	ra,584(sp)
 19a:	24013403          	ld	s0,576(sp)
 19e:	23813483          	ld	s1,568(sp)
 1a2:	23013903          	ld	s2,560(sp)
 1a6:	22813983          	ld	s3,552(sp)
 1aa:	22013a03          	ld	s4,544(sp)
 1ae:	21813a83          	ld	s5,536(sp)
 1b2:	21013b03          	ld	s6,528(sp)
 1b6:	20813b83          	ld	s7,520(sp)
 1ba:	20013c03          	ld	s8,512(sp)
 1be:	25010113          	addi	sp,sp,592
 1c2:	8082                	ret

00000000000001c4 <main>:




int
main(int argc,char*  argv[]){
 1c4:	1141                	addi	sp,sp,-16
 1c6:	e406                	sd	ra,8(sp)
 1c8:	e022                	sd	s0,0(sp)
 1ca:	0800                	addi	s0,sp,16
 1cc:	87ae                	mv	a5,a1
recur_(argv[1], argv[2]);   
 1ce:	698c                	ld	a1,16(a1)
 1d0:	6788                	ld	a0,8(a5)
 1d2:	00000097          	auipc	ra,0x0
 1d6:	e6a080e7          	jalr	-406(ra) # 3c <recur_>
exit(0);
 1da:	4501                	li	a0,0
 1dc:	00000097          	auipc	ra,0x0
 1e0:	290080e7          	jalr	656(ra) # 46c <exit>

00000000000001e4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e406                	sd	ra,8(sp)
 1e8:	e022                	sd	s0,0(sp)
 1ea:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1ec:	00000097          	auipc	ra,0x0
 1f0:	fd8080e7          	jalr	-40(ra) # 1c4 <main>
  exit(0);
 1f4:	4501                	li	a0,0
 1f6:	00000097          	auipc	ra,0x0
 1fa:	276080e7          	jalr	630(ra) # 46c <exit>

00000000000001fe <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 204:	87aa                	mv	a5,a0
 206:	0585                	addi	a1,a1,1
 208:	0785                	addi	a5,a5,1
 20a:	fff5c703          	lbu	a4,-1(a1)
 20e:	fee78fa3          	sb	a4,-1(a5)
 212:	fb75                	bnez	a4,206 <strcpy+0x8>
    ;
  return os;
}
 214:	6422                	ld	s0,8(sp)
 216:	0141                	addi	sp,sp,16
 218:	8082                	ret

000000000000021a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21a:	1141                	addi	sp,sp,-16
 21c:	e422                	sd	s0,8(sp)
 21e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 220:	00054783          	lbu	a5,0(a0)
 224:	cb91                	beqz	a5,238 <strcmp+0x1e>
 226:	0005c703          	lbu	a4,0(a1)
 22a:	00f71763          	bne	a4,a5,238 <strcmp+0x1e>
    p++, q++;
 22e:	0505                	addi	a0,a0,1
 230:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 232:	00054783          	lbu	a5,0(a0)
 236:	fbe5                	bnez	a5,226 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 238:	0005c503          	lbu	a0,0(a1)
}
 23c:	40a7853b          	subw	a0,a5,a0
 240:	6422                	ld	s0,8(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret

0000000000000246 <strlen>:

uint
strlen(const char *s)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 24c:	00054783          	lbu	a5,0(a0)
 250:	cf91                	beqz	a5,26c <strlen+0x26>
 252:	0505                	addi	a0,a0,1
 254:	87aa                	mv	a5,a0
 256:	4685                	li	a3,1
 258:	9e89                	subw	a3,a3,a0
 25a:	00f6853b          	addw	a0,a3,a5
 25e:	0785                	addi	a5,a5,1
 260:	fff7c703          	lbu	a4,-1(a5)
 264:	fb7d                	bnez	a4,25a <strlen+0x14>
    ;
  return n;
}
 266:	6422                	ld	s0,8(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret
  for(n = 0; s[n]; n++)
 26c:	4501                	li	a0,0
 26e:	bfe5                	j	266 <strlen+0x20>

0000000000000270 <memset>:

void*
memset(void *dst, int c, uint n)
{
 270:	1141                	addi	sp,sp,-16
 272:	e422                	sd	s0,8(sp)
 274:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 276:	ca19                	beqz	a2,28c <memset+0x1c>
 278:	87aa                	mv	a5,a0
 27a:	1602                	slli	a2,a2,0x20
 27c:	9201                	srli	a2,a2,0x20
 27e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 282:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 286:	0785                	addi	a5,a5,1
 288:	fee79de3          	bne	a5,a4,282 <memset+0x12>
  }
  return dst;
}
 28c:	6422                	ld	s0,8(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <strchr>:

char*
strchr(const char *s, char c)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  for(; *s; s++)
 298:	00054783          	lbu	a5,0(a0)
 29c:	cb99                	beqz	a5,2b2 <strchr+0x20>
    if(*s == c)
 29e:	00f58763          	beq	a1,a5,2ac <strchr+0x1a>
  for(; *s; s++)
 2a2:	0505                	addi	a0,a0,1
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	fbfd                	bnez	a5,29e <strchr+0xc>
      return (char*)s;
  return 0;
 2aa:	4501                	li	a0,0
}
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret
  return 0;
 2b2:	4501                	li	a0,0
 2b4:	bfe5                	j	2ac <strchr+0x1a>

00000000000002b6 <gets>:

char*
gets(char *buf, int max)
{
 2b6:	711d                	addi	sp,sp,-96
 2b8:	ec86                	sd	ra,88(sp)
 2ba:	e8a2                	sd	s0,80(sp)
 2bc:	e4a6                	sd	s1,72(sp)
 2be:	e0ca                	sd	s2,64(sp)
 2c0:	fc4e                	sd	s3,56(sp)
 2c2:	f852                	sd	s4,48(sp)
 2c4:	f456                	sd	s5,40(sp)
 2c6:	f05a                	sd	s6,32(sp)
 2c8:	ec5e                	sd	s7,24(sp)
 2ca:	1080                	addi	s0,sp,96
 2cc:	8baa                	mv	s7,a0
 2ce:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d0:	892a                	mv	s2,a0
 2d2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d4:	4aa9                	li	s5,10
 2d6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2d8:	89a6                	mv	s3,s1
 2da:	2485                	addiw	s1,s1,1
 2dc:	0344d863          	bge	s1,s4,30c <gets+0x56>
    cc = read(0, &c, 1);
 2e0:	4605                	li	a2,1
 2e2:	faf40593          	addi	a1,s0,-81
 2e6:	4501                	li	a0,0
 2e8:	00000097          	auipc	ra,0x0
 2ec:	19c080e7          	jalr	412(ra) # 484 <read>
    if(cc < 1)
 2f0:	00a05e63          	blez	a0,30c <gets+0x56>
    buf[i++] = c;
 2f4:	faf44783          	lbu	a5,-81(s0)
 2f8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2fc:	01578763          	beq	a5,s5,30a <gets+0x54>
 300:	0905                	addi	s2,s2,1
 302:	fd679be3          	bne	a5,s6,2d8 <gets+0x22>
  for(i=0; i+1 < max; ){
 306:	89a6                	mv	s3,s1
 308:	a011                	j	30c <gets+0x56>
 30a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 30c:	99de                	add	s3,s3,s7
 30e:	00098023          	sb	zero,0(s3)
  return buf;
}
 312:	855e                	mv	a0,s7
 314:	60e6                	ld	ra,88(sp)
 316:	6446                	ld	s0,80(sp)
 318:	64a6                	ld	s1,72(sp)
 31a:	6906                	ld	s2,64(sp)
 31c:	79e2                	ld	s3,56(sp)
 31e:	7a42                	ld	s4,48(sp)
 320:	7aa2                	ld	s5,40(sp)
 322:	7b02                	ld	s6,32(sp)
 324:	6be2                	ld	s7,24(sp)
 326:	6125                	addi	sp,sp,96
 328:	8082                	ret

000000000000032a <stat>:

int
stat(const char *n, struct stat *st)
{
 32a:	1101                	addi	sp,sp,-32
 32c:	ec06                	sd	ra,24(sp)
 32e:	e822                	sd	s0,16(sp)
 330:	e426                	sd	s1,8(sp)
 332:	e04a                	sd	s2,0(sp)
 334:	1000                	addi	s0,sp,32
 336:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 338:	4581                	li	a1,0
 33a:	00000097          	auipc	ra,0x0
 33e:	172080e7          	jalr	370(ra) # 4ac <open>
  if(fd < 0)
 342:	02054563          	bltz	a0,36c <stat+0x42>
 346:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 348:	85ca                	mv	a1,s2
 34a:	00000097          	auipc	ra,0x0
 34e:	17a080e7          	jalr	378(ra) # 4c4 <fstat>
 352:	892a                	mv	s2,a0
  close(fd);
 354:	8526                	mv	a0,s1
 356:	00000097          	auipc	ra,0x0
 35a:	13e080e7          	jalr	318(ra) # 494 <close>
  return r;
}
 35e:	854a                	mv	a0,s2
 360:	60e2                	ld	ra,24(sp)
 362:	6442                	ld	s0,16(sp)
 364:	64a2                	ld	s1,8(sp)
 366:	6902                	ld	s2,0(sp)
 368:	6105                	addi	sp,sp,32
 36a:	8082                	ret
    return -1;
 36c:	597d                	li	s2,-1
 36e:	bfc5                	j	35e <stat+0x34>

0000000000000370 <atoi>:

int
atoi(const char *s)
{
 370:	1141                	addi	sp,sp,-16
 372:	e422                	sd	s0,8(sp)
 374:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 376:	00054603          	lbu	a2,0(a0)
 37a:	fd06079b          	addiw	a5,a2,-48
 37e:	0ff7f793          	andi	a5,a5,255
 382:	4725                	li	a4,9
 384:	02f76963          	bltu	a4,a5,3b6 <atoi+0x46>
 388:	86aa                	mv	a3,a0
  n = 0;
 38a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 38c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 38e:	0685                	addi	a3,a3,1
 390:	0025179b          	slliw	a5,a0,0x2
 394:	9fa9                	addw	a5,a5,a0
 396:	0017979b          	slliw	a5,a5,0x1
 39a:	9fb1                	addw	a5,a5,a2
 39c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3a0:	0006c603          	lbu	a2,0(a3)
 3a4:	fd06071b          	addiw	a4,a2,-48
 3a8:	0ff77713          	andi	a4,a4,255
 3ac:	fee5f1e3          	bgeu	a1,a4,38e <atoi+0x1e>
  return n;
}
 3b0:	6422                	ld	s0,8(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret
  n = 0;
 3b6:	4501                	li	a0,0
 3b8:	bfe5                	j	3b0 <atoi+0x40>

00000000000003ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e422                	sd	s0,8(sp)
 3be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c0:	02b57463          	bgeu	a0,a1,3e8 <memmove+0x2e>
    while(n-- > 0)
 3c4:	00c05f63          	blez	a2,3e2 <memmove+0x28>
 3c8:	1602                	slli	a2,a2,0x20
 3ca:	9201                	srli	a2,a2,0x20
 3cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d0:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d2:	0585                	addi	a1,a1,1
 3d4:	0705                	addi	a4,a4,1
 3d6:	fff5c683          	lbu	a3,-1(a1)
 3da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3de:	fee79ae3          	bne	a5,a4,3d2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e2:	6422                	ld	s0,8(sp)
 3e4:	0141                	addi	sp,sp,16
 3e6:	8082                	ret
    dst += n;
 3e8:	00c50733          	add	a4,a0,a2
    src += n;
 3ec:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ee:	fec05ae3          	blez	a2,3e2 <memmove+0x28>
 3f2:	fff6079b          	addiw	a5,a2,-1
 3f6:	1782                	slli	a5,a5,0x20
 3f8:	9381                	srli	a5,a5,0x20
 3fa:	fff7c793          	not	a5,a5
 3fe:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 400:	15fd                	addi	a1,a1,-1
 402:	177d                	addi	a4,a4,-1
 404:	0005c683          	lbu	a3,0(a1)
 408:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 40c:	fee79ae3          	bne	a5,a4,400 <memmove+0x46>
 410:	bfc9                	j	3e2 <memmove+0x28>

0000000000000412 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 412:	1141                	addi	sp,sp,-16
 414:	e422                	sd	s0,8(sp)
 416:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 418:	ca05                	beqz	a2,448 <memcmp+0x36>
 41a:	fff6069b          	addiw	a3,a2,-1
 41e:	1682                	slli	a3,a3,0x20
 420:	9281                	srli	a3,a3,0x20
 422:	0685                	addi	a3,a3,1
 424:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 426:	00054783          	lbu	a5,0(a0)
 42a:	0005c703          	lbu	a4,0(a1)
 42e:	00e79863          	bne	a5,a4,43e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 432:	0505                	addi	a0,a0,1
    p2++;
 434:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 436:	fed518e3          	bne	a0,a3,426 <memcmp+0x14>
  }
  return 0;
 43a:	4501                	li	a0,0
 43c:	a019                	j	442 <memcmp+0x30>
      return *p1 - *p2;
 43e:	40e7853b          	subw	a0,a5,a4
}
 442:	6422                	ld	s0,8(sp)
 444:	0141                	addi	sp,sp,16
 446:	8082                	ret
  return 0;
 448:	4501                	li	a0,0
 44a:	bfe5                	j	442 <memcmp+0x30>

000000000000044c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 44c:	1141                	addi	sp,sp,-16
 44e:	e406                	sd	ra,8(sp)
 450:	e022                	sd	s0,0(sp)
 452:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 454:	00000097          	auipc	ra,0x0
 458:	f66080e7          	jalr	-154(ra) # 3ba <memmove>
}
 45c:	60a2                	ld	ra,8(sp)
 45e:	6402                	ld	s0,0(sp)
 460:	0141                	addi	sp,sp,16
 462:	8082                	ret

0000000000000464 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 464:	4885                	li	a7,1
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <exit>:
.global exit
exit:
 li a7, SYS_exit
 46c:	4889                	li	a7,2
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <wait>:
.global wait
wait:
 li a7, SYS_wait
 474:	488d                	li	a7,3
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 47c:	4891                	li	a7,4
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <read>:
.global read
read:
 li a7, SYS_read
 484:	4895                	li	a7,5
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <write>:
.global write
write:
 li a7, SYS_write
 48c:	48c1                	li	a7,16
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <close>:
.global close
close:
 li a7, SYS_close
 494:	48d5                	li	a7,21
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <kill>:
.global kill
kill:
 li a7, SYS_kill
 49c:	4899                	li	a7,6
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a4:	489d                	li	a7,7
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <open>:
.global open
open:
 li a7, SYS_open
 4ac:	48bd                	li	a7,15
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b4:	48c5                	li	a7,17
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4bc:	48c9                	li	a7,18
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c4:	48a1                	li	a7,8
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <link>:
.global link
link:
 li a7, SYS_link
 4cc:	48cd                	li	a7,19
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d4:	48d1                	li	a7,20
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4dc:	48a5                	li	a7,9
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e4:	48a9                	li	a7,10
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ec:	48ad                	li	a7,11
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f4:	48b1                	li	a7,12
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4fc:	48b5                	li	a7,13
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 504:	48b9                	li	a7,14
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <trace>:
.global trace
trace:
 li a7, SYS_trace
 50c:	48d9                	li	a7,22
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 514:	48dd                	li	a7,23
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 51c:	1101                	addi	sp,sp,-32
 51e:	ec06                	sd	ra,24(sp)
 520:	e822                	sd	s0,16(sp)
 522:	1000                	addi	s0,sp,32
 524:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 528:	4605                	li	a2,1
 52a:	fef40593          	addi	a1,s0,-17
 52e:	00000097          	auipc	ra,0x0
 532:	f5e080e7          	jalr	-162(ra) # 48c <write>
}
 536:	60e2                	ld	ra,24(sp)
 538:	6442                	ld	s0,16(sp)
 53a:	6105                	addi	sp,sp,32
 53c:	8082                	ret

000000000000053e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 53e:	7139                	addi	sp,sp,-64
 540:	fc06                	sd	ra,56(sp)
 542:	f822                	sd	s0,48(sp)
 544:	f426                	sd	s1,40(sp)
 546:	f04a                	sd	s2,32(sp)
 548:	ec4e                	sd	s3,24(sp)
 54a:	0080                	addi	s0,sp,64
 54c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 54e:	c299                	beqz	a3,554 <printint+0x16>
 550:	0805c863          	bltz	a1,5e0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 554:	2581                	sext.w	a1,a1
  neg = 0;
 556:	4881                	li	a7,0
 558:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 55c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 55e:	2601                	sext.w	a2,a2
 560:	00000517          	auipc	a0,0x0
 564:	46050513          	addi	a0,a0,1120 # 9c0 <digits>
 568:	883a                	mv	a6,a4
 56a:	2705                	addiw	a4,a4,1
 56c:	02c5f7bb          	remuw	a5,a1,a2
 570:	1782                	slli	a5,a5,0x20
 572:	9381                	srli	a5,a5,0x20
 574:	97aa                	add	a5,a5,a0
 576:	0007c783          	lbu	a5,0(a5)
 57a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 57e:	0005879b          	sext.w	a5,a1
 582:	02c5d5bb          	divuw	a1,a1,a2
 586:	0685                	addi	a3,a3,1
 588:	fec7f0e3          	bgeu	a5,a2,568 <printint+0x2a>
  if(neg)
 58c:	00088b63          	beqz	a7,5a2 <printint+0x64>
    buf[i++] = '-';
 590:	fd040793          	addi	a5,s0,-48
 594:	973e                	add	a4,a4,a5
 596:	02d00793          	li	a5,45
 59a:	fef70823          	sb	a5,-16(a4)
 59e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5a2:	02e05863          	blez	a4,5d2 <printint+0x94>
 5a6:	fc040793          	addi	a5,s0,-64
 5aa:	00e78933          	add	s2,a5,a4
 5ae:	fff78993          	addi	s3,a5,-1
 5b2:	99ba                	add	s3,s3,a4
 5b4:	377d                	addiw	a4,a4,-1
 5b6:	1702                	slli	a4,a4,0x20
 5b8:	9301                	srli	a4,a4,0x20
 5ba:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5be:	fff94583          	lbu	a1,-1(s2)
 5c2:	8526                	mv	a0,s1
 5c4:	00000097          	auipc	ra,0x0
 5c8:	f58080e7          	jalr	-168(ra) # 51c <putc>
  while(--i >= 0)
 5cc:	197d                	addi	s2,s2,-1
 5ce:	ff3918e3          	bne	s2,s3,5be <printint+0x80>
}
 5d2:	70e2                	ld	ra,56(sp)
 5d4:	7442                	ld	s0,48(sp)
 5d6:	74a2                	ld	s1,40(sp)
 5d8:	7902                	ld	s2,32(sp)
 5da:	69e2                	ld	s3,24(sp)
 5dc:	6121                	addi	sp,sp,64
 5de:	8082                	ret
    x = -xx;
 5e0:	40b005bb          	negw	a1,a1
    neg = 1;
 5e4:	4885                	li	a7,1
    x = -xx;
 5e6:	bf8d                	j	558 <printint+0x1a>

00000000000005e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5e8:	7119                	addi	sp,sp,-128
 5ea:	fc86                	sd	ra,120(sp)
 5ec:	f8a2                	sd	s0,112(sp)
 5ee:	f4a6                	sd	s1,104(sp)
 5f0:	f0ca                	sd	s2,96(sp)
 5f2:	ecce                	sd	s3,88(sp)
 5f4:	e8d2                	sd	s4,80(sp)
 5f6:	e4d6                	sd	s5,72(sp)
 5f8:	e0da                	sd	s6,64(sp)
 5fa:	fc5e                	sd	s7,56(sp)
 5fc:	f862                	sd	s8,48(sp)
 5fe:	f466                	sd	s9,40(sp)
 600:	f06a                	sd	s10,32(sp)
 602:	ec6e                	sd	s11,24(sp)
 604:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 606:	0005c903          	lbu	s2,0(a1)
 60a:	18090f63          	beqz	s2,7a8 <vprintf+0x1c0>
 60e:	8aaa                	mv	s5,a0
 610:	8b32                	mv	s6,a2
 612:	00158493          	addi	s1,a1,1
  state = 0;
 616:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 618:	02500a13          	li	s4,37
      if(c == 'd'){
 61c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 620:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 624:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 628:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 62c:	00000b97          	auipc	s7,0x0
 630:	394b8b93          	addi	s7,s7,916 # 9c0 <digits>
 634:	a839                	j	652 <vprintf+0x6a>
        putc(fd, c);
 636:	85ca                	mv	a1,s2
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	ee2080e7          	jalr	-286(ra) # 51c <putc>
 642:	a019                	j	648 <vprintf+0x60>
    } else if(state == '%'){
 644:	01498f63          	beq	s3,s4,662 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 648:	0485                	addi	s1,s1,1
 64a:	fff4c903          	lbu	s2,-1(s1)
 64e:	14090d63          	beqz	s2,7a8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 652:	0009079b          	sext.w	a5,s2
    if(state == 0){
 656:	fe0997e3          	bnez	s3,644 <vprintf+0x5c>
      if(c == '%'){
 65a:	fd479ee3          	bne	a5,s4,636 <vprintf+0x4e>
        state = '%';
 65e:	89be                	mv	s3,a5
 660:	b7e5                	j	648 <vprintf+0x60>
      if(c == 'd'){
 662:	05878063          	beq	a5,s8,6a2 <vprintf+0xba>
      } else if(c == 'l') {
 666:	05978c63          	beq	a5,s9,6be <vprintf+0xd6>
      } else if(c == 'x') {
 66a:	07a78863          	beq	a5,s10,6da <vprintf+0xf2>
      } else if(c == 'p') {
 66e:	09b78463          	beq	a5,s11,6f6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 672:	07300713          	li	a4,115
 676:	0ce78663          	beq	a5,a4,742 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 67a:	06300713          	li	a4,99
 67e:	0ee78e63          	beq	a5,a4,77a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 682:	11478863          	beq	a5,s4,792 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 686:	85d2                	mv	a1,s4
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	e92080e7          	jalr	-366(ra) # 51c <putc>
        putc(fd, c);
 692:	85ca                	mv	a1,s2
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	e86080e7          	jalr	-378(ra) # 51c <putc>
      }
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	b765                	j	648 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6a2:	008b0913          	addi	s2,s6,8
 6a6:	4685                	li	a3,1
 6a8:	4629                	li	a2,10
 6aa:	000b2583          	lw	a1,0(s6)
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	e8e080e7          	jalr	-370(ra) # 53e <printint>
 6b8:	8b4a                	mv	s6,s2
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	b771                	j	648 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	008b0913          	addi	s2,s6,8
 6c2:	4681                	li	a3,0
 6c4:	4629                	li	a2,10
 6c6:	000b2583          	lw	a1,0(s6)
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	e72080e7          	jalr	-398(ra) # 53e <printint>
 6d4:	8b4a                	mv	s6,s2
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	bf85                	j	648 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6da:	008b0913          	addi	s2,s6,8
 6de:	4681                	li	a3,0
 6e0:	4641                	li	a2,16
 6e2:	000b2583          	lw	a1,0(s6)
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e56080e7          	jalr	-426(ra) # 53e <printint>
 6f0:	8b4a                	mv	s6,s2
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bf91                	j	648 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6f6:	008b0793          	addi	a5,s6,8
 6fa:	f8f43423          	sd	a5,-120(s0)
 6fe:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 702:	03000593          	li	a1,48
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	e14080e7          	jalr	-492(ra) # 51c <putc>
  putc(fd, 'x');
 710:	85ea                	mv	a1,s10
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	e08080e7          	jalr	-504(ra) # 51c <putc>
 71c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 71e:	03c9d793          	srli	a5,s3,0x3c
 722:	97de                	add	a5,a5,s7
 724:	0007c583          	lbu	a1,0(a5)
 728:	8556                	mv	a0,s5
 72a:	00000097          	auipc	ra,0x0
 72e:	df2080e7          	jalr	-526(ra) # 51c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 732:	0992                	slli	s3,s3,0x4
 734:	397d                	addiw	s2,s2,-1
 736:	fe0914e3          	bnez	s2,71e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 73a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 73e:	4981                	li	s3,0
 740:	b721                	j	648 <vprintf+0x60>
        s = va_arg(ap, char*);
 742:	008b0993          	addi	s3,s6,8
 746:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 74a:	02090163          	beqz	s2,76c <vprintf+0x184>
        while(*s != 0){
 74e:	00094583          	lbu	a1,0(s2)
 752:	c9a1                	beqz	a1,7a2 <vprintf+0x1ba>
          putc(fd, *s);
 754:	8556                	mv	a0,s5
 756:	00000097          	auipc	ra,0x0
 75a:	dc6080e7          	jalr	-570(ra) # 51c <putc>
          s++;
 75e:	0905                	addi	s2,s2,1
        while(*s != 0){
 760:	00094583          	lbu	a1,0(s2)
 764:	f9e5                	bnez	a1,754 <vprintf+0x16c>
        s = va_arg(ap, char*);
 766:	8b4e                	mv	s6,s3
      state = 0;
 768:	4981                	li	s3,0
 76a:	bdf9                	j	648 <vprintf+0x60>
          s = "(null)";
 76c:	00000917          	auipc	s2,0x0
 770:	24c90913          	addi	s2,s2,588 # 9b8 <malloc+0x106>
        while(*s != 0){
 774:	02800593          	li	a1,40
 778:	bff1                	j	754 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 77a:	008b0913          	addi	s2,s6,8
 77e:	000b4583          	lbu	a1,0(s6)
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	d98080e7          	jalr	-616(ra) # 51c <putc>
 78c:	8b4a                	mv	s6,s2
      state = 0;
 78e:	4981                	li	s3,0
 790:	bd65                	j	648 <vprintf+0x60>
        putc(fd, c);
 792:	85d2                	mv	a1,s4
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	d86080e7          	jalr	-634(ra) # 51c <putc>
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	b565                	j	648 <vprintf+0x60>
        s = va_arg(ap, char*);
 7a2:	8b4e                	mv	s6,s3
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b54d                	j	648 <vprintf+0x60>
    }
  }
}
 7a8:	70e6                	ld	ra,120(sp)
 7aa:	7446                	ld	s0,112(sp)
 7ac:	74a6                	ld	s1,104(sp)
 7ae:	7906                	ld	s2,96(sp)
 7b0:	69e6                	ld	s3,88(sp)
 7b2:	6a46                	ld	s4,80(sp)
 7b4:	6aa6                	ld	s5,72(sp)
 7b6:	6b06                	ld	s6,64(sp)
 7b8:	7be2                	ld	s7,56(sp)
 7ba:	7c42                	ld	s8,48(sp)
 7bc:	7ca2                	ld	s9,40(sp)
 7be:	7d02                	ld	s10,32(sp)
 7c0:	6de2                	ld	s11,24(sp)
 7c2:	6109                	addi	sp,sp,128
 7c4:	8082                	ret

00000000000007c6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c6:	715d                	addi	sp,sp,-80
 7c8:	ec06                	sd	ra,24(sp)
 7ca:	e822                	sd	s0,16(sp)
 7cc:	1000                	addi	s0,sp,32
 7ce:	e010                	sd	a2,0(s0)
 7d0:	e414                	sd	a3,8(s0)
 7d2:	e818                	sd	a4,16(s0)
 7d4:	ec1c                	sd	a5,24(s0)
 7d6:	03043023          	sd	a6,32(s0)
 7da:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e2:	8622                	mv	a2,s0
 7e4:	00000097          	auipc	ra,0x0
 7e8:	e04080e7          	jalr	-508(ra) # 5e8 <vprintf>
}
 7ec:	60e2                	ld	ra,24(sp)
 7ee:	6442                	ld	s0,16(sp)
 7f0:	6161                	addi	sp,sp,80
 7f2:	8082                	ret

00000000000007f4 <printf>:

void
printf(const char *fmt, ...)
{
 7f4:	711d                	addi	sp,sp,-96
 7f6:	ec06                	sd	ra,24(sp)
 7f8:	e822                	sd	s0,16(sp)
 7fa:	1000                	addi	s0,sp,32
 7fc:	e40c                	sd	a1,8(s0)
 7fe:	e810                	sd	a2,16(s0)
 800:	ec14                	sd	a3,24(s0)
 802:	f018                	sd	a4,32(s0)
 804:	f41c                	sd	a5,40(s0)
 806:	03043823          	sd	a6,48(s0)
 80a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 80e:	00840613          	addi	a2,s0,8
 812:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 816:	85aa                	mv	a1,a0
 818:	4505                	li	a0,1
 81a:	00000097          	auipc	ra,0x0
 81e:	dce080e7          	jalr	-562(ra) # 5e8 <vprintf>
}
 822:	60e2                	ld	ra,24(sp)
 824:	6442                	ld	s0,16(sp)
 826:	6125                	addi	sp,sp,96
 828:	8082                	ret

000000000000082a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 82a:	1141                	addi	sp,sp,-16
 82c:	e422                	sd	s0,8(sp)
 82e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 830:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 834:	00000797          	auipc	a5,0x0
 838:	7cc7b783          	ld	a5,1996(a5) # 1000 <freep>
 83c:	a805                	j	86c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 83e:	4618                	lw	a4,8(a2)
 840:	9db9                	addw	a1,a1,a4
 842:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	6398                	ld	a4,0(a5)
 848:	6318                	ld	a4,0(a4)
 84a:	fee53823          	sd	a4,-16(a0)
 84e:	a091                	j	892 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 850:	ff852703          	lw	a4,-8(a0)
 854:	9e39                	addw	a2,a2,a4
 856:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 858:	ff053703          	ld	a4,-16(a0)
 85c:	e398                	sd	a4,0(a5)
 85e:	a099                	j	8a4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	6398                	ld	a4,0(a5)
 862:	00e7e463          	bltu	a5,a4,86a <free+0x40>
 866:	00e6ea63          	bltu	a3,a4,87a <free+0x50>
{
 86a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86c:	fed7fae3          	bgeu	a5,a3,860 <free+0x36>
 870:	6398                	ld	a4,0(a5)
 872:	00e6e463          	bltu	a3,a4,87a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 876:	fee7eae3          	bltu	a5,a4,86a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 87a:	ff852583          	lw	a1,-8(a0)
 87e:	6390                	ld	a2,0(a5)
 880:	02059713          	slli	a4,a1,0x20
 884:	9301                	srli	a4,a4,0x20
 886:	0712                	slli	a4,a4,0x4
 888:	9736                	add	a4,a4,a3
 88a:	fae60ae3          	beq	a2,a4,83e <free+0x14>
    bp->s.ptr = p->s.ptr;
 88e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 892:	4790                	lw	a2,8(a5)
 894:	02061713          	slli	a4,a2,0x20
 898:	9301                	srli	a4,a4,0x20
 89a:	0712                	slli	a4,a4,0x4
 89c:	973e                	add	a4,a4,a5
 89e:	fae689e3          	beq	a3,a4,850 <free+0x26>
  } else
    p->s.ptr = bp;
 8a2:	e394                	sd	a3,0(a5)
  freep = p;
 8a4:	00000717          	auipc	a4,0x0
 8a8:	74f73e23          	sd	a5,1884(a4) # 1000 <freep>
}
 8ac:	6422                	ld	s0,8(sp)
 8ae:	0141                	addi	sp,sp,16
 8b0:	8082                	ret

00000000000008b2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8b2:	7139                	addi	sp,sp,-64
 8b4:	fc06                	sd	ra,56(sp)
 8b6:	f822                	sd	s0,48(sp)
 8b8:	f426                	sd	s1,40(sp)
 8ba:	f04a                	sd	s2,32(sp)
 8bc:	ec4e                	sd	s3,24(sp)
 8be:	e852                	sd	s4,16(sp)
 8c0:	e456                	sd	s5,8(sp)
 8c2:	e05a                	sd	s6,0(sp)
 8c4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c6:	02051493          	slli	s1,a0,0x20
 8ca:	9081                	srli	s1,s1,0x20
 8cc:	04bd                	addi	s1,s1,15
 8ce:	8091                	srli	s1,s1,0x4
 8d0:	0014899b          	addiw	s3,s1,1
 8d4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8d6:	00000517          	auipc	a0,0x0
 8da:	72a53503          	ld	a0,1834(a0) # 1000 <freep>
 8de:	c515                	beqz	a0,90a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e2:	4798                	lw	a4,8(a5)
 8e4:	02977f63          	bgeu	a4,s1,922 <malloc+0x70>
 8e8:	8a4e                	mv	s4,s3
 8ea:	0009871b          	sext.w	a4,s3
 8ee:	6685                	lui	a3,0x1
 8f0:	00d77363          	bgeu	a4,a3,8f6 <malloc+0x44>
 8f4:	6a05                	lui	s4,0x1
 8f6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8fa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8fe:	00000917          	auipc	s2,0x0
 902:	70290913          	addi	s2,s2,1794 # 1000 <freep>
  if(p == (char*)-1)
 906:	5afd                	li	s5,-1
 908:	a88d                	j	97a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 90a:	00000797          	auipc	a5,0x0
 90e:	72e78793          	addi	a5,a5,1838 # 1038 <base>
 912:	00000717          	auipc	a4,0x0
 916:	6ef73723          	sd	a5,1774(a4) # 1000 <freep>
 91a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 91c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 920:	b7e1                	j	8e8 <malloc+0x36>
      if(p->s.size == nunits)
 922:	02e48b63          	beq	s1,a4,958 <malloc+0xa6>
        p->s.size -= nunits;
 926:	4137073b          	subw	a4,a4,s3
 92a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 92c:	1702                	slli	a4,a4,0x20
 92e:	9301                	srli	a4,a4,0x20
 930:	0712                	slli	a4,a4,0x4
 932:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 934:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 938:	00000717          	auipc	a4,0x0
 93c:	6ca73423          	sd	a0,1736(a4) # 1000 <freep>
      return (void*)(p + 1);
 940:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 944:	70e2                	ld	ra,56(sp)
 946:	7442                	ld	s0,48(sp)
 948:	74a2                	ld	s1,40(sp)
 94a:	7902                	ld	s2,32(sp)
 94c:	69e2                	ld	s3,24(sp)
 94e:	6a42                	ld	s4,16(sp)
 950:	6aa2                	ld	s5,8(sp)
 952:	6b02                	ld	s6,0(sp)
 954:	6121                	addi	sp,sp,64
 956:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 958:	6398                	ld	a4,0(a5)
 95a:	e118                	sd	a4,0(a0)
 95c:	bff1                	j	938 <malloc+0x86>
  hp->s.size = nu;
 95e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 962:	0541                	addi	a0,a0,16
 964:	00000097          	auipc	ra,0x0
 968:	ec6080e7          	jalr	-314(ra) # 82a <free>
  return freep;
 96c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 970:	d971                	beqz	a0,944 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 972:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 974:	4798                	lw	a4,8(a5)
 976:	fa9776e3          	bgeu	a4,s1,922 <malloc+0x70>
    if(p == freep)
 97a:	00093703          	ld	a4,0(s2)
 97e:	853e                	mv	a0,a5
 980:	fef719e3          	bne	a4,a5,972 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 984:	8552                	mv	a0,s4
 986:	00000097          	auipc	ra,0x0
 98a:	b6e080e7          	jalr	-1170(ra) # 4f4 <sbrk>
  if(p == (char*)-1)
 98e:	fd5518e3          	bne	a0,s5,95e <malloc+0xac>
        return 0;
 992:	4501                	li	a0,0
 994:	bf45                	j	944 <malloc+0x92>
