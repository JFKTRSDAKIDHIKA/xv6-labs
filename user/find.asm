
user/_find:     file format elf64-littleriscv


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
  10:	244080e7          	jalr	580(ra) # 250 <strlen>
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
  3c:	da010113          	addi	sp,sp,-608
  40:	24113c23          	sd	ra,600(sp)
  44:	24813823          	sd	s0,592(sp)
  48:	24913423          	sd	s1,584(sp)
  4c:	25213023          	sd	s2,576(sp)
  50:	23313c23          	sd	s3,568(sp)
  54:	23413823          	sd	s4,560(sp)
  58:	23513423          	sd	s5,552(sp)
  5c:	23613023          	sd	s6,544(sp)
  60:	21713c23          	sd	s7,536(sp)
  64:	21813823          	sd	s8,528(sp)
  68:	21913423          	sd	s9,520(sp)
  6c:	1480                	addi	s0,sp,608
  6e:	8a2a                	mv	s4,a0
  70:	8aae                	mv	s5,a1
  fd = open(path, O_RDONLY);
  72:	4581                	li	a1,0
  74:	00000097          	auipc	ra,0x0
  78:	44a080e7          	jalr	1098(ra) # 4be <open>
  7c:	84aa                	mv	s1,a0
  fstat(fd, &st);// we need to check the type of the file or directory.
  7e:	00001917          	auipc	s2,0x1
  82:	f9290913          	addi	s2,s2,-110 # 1010 <st>
  86:	85ca                	mv	a1,s2
  88:	00000097          	auipc	ra,0x0
  8c:	44e080e7          	jalr	1102(ra) # 4d6 <fstat>
  if(st.type == 2){
  90:	00891783          	lh	a5,8(s2)
  94:	0007869b          	sext.w	a3,a5
  98:	4709                	li	a4,2
  9a:	0ae68b63          	beq	a3,a4,150 <recur_+0x114>
  else if(st.type == 3){
  9e:	2781                	sext.w	a5,a5
  a0:	470d                	li	a4,3
  a2:	0ee78263          	beq	a5,a4,186 <recur_+0x14a>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
  a6:	00001917          	auipc	s2,0x1
  aa:	f8290913          	addi	s2,s2,-126 # 1028 <de>
      if(de.inum != 0 && strcmp(de.name , ".") && strcmp(de.name, "..")){// iterate throuth all the subitems.
  ae:	00001997          	auipc	s3,0x1
  b2:	f6298993          	addi	s3,s3,-158 # 1010 <st>
  b6:	00001c17          	auipc	s8,0x1
  ba:	902c0c13          	addi	s8,s8,-1790 # 9b8 <malloc+0xf4>
  be:	00001b17          	auipc	s6,0x1
  c2:	f6cb0b13          	addi	s6,s6,-148 # 102a <de+0x2>
  c6:	00001c97          	auipc	s9,0x1
  ca:	8fac8c93          	addi	s9,s9,-1798 # 9c0 <malloc+0xfc>
  ce:	8bda                	mv	s7,s6
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
  d0:	4641                	li	a2,16
  d2:	85ca                	mv	a1,s2
  d4:	8526                	mv	a0,s1
  d6:	00000097          	auipc	ra,0x0
  da:	3c0080e7          	jalr	960(ra) # 496 <read>
  de:	47c1                	li	a5,16
  e0:	0af51963          	bne	a0,a5,192 <recur_+0x156>
      if(de.inum != 0 && strcmp(de.name , ".") && strcmp(de.name, "..")){// iterate throuth all the subitems.
  e4:	0189d783          	lhu	a5,24(s3)
  e8:	d7e5                	beqz	a5,d0 <recur_+0x94>
  ea:	85e2                	mv	a1,s8
  ec:	855e                	mv	a0,s7
  ee:	00000097          	auipc	ra,0x0
  f2:	136080e7          	jalr	310(ra) # 224 <strcmp>
  f6:	dd69                	beqz	a0,d0 <recur_+0x94>
  f8:	85e6                	mv	a1,s9
  fa:	855e                	mv	a0,s7
  fc:	00000097          	auipc	ra,0x0
 100:	128080e7          	jalr	296(ra) # 224 <strcmp>
 104:	d571                	beqz	a0,d0 <recur_+0x94>
        strcpy(buf, path);
 106:	85d2                	mv	a1,s4
 108:	da040513          	addi	a0,s0,-608
 10c:	00000097          	auipc	ra,0x0
 110:	0fc080e7          	jalr	252(ra) # 208 <strcpy>
        p = buf + strlen(buf);//p pointing to the end of the buf, namely '\0'
 114:	da040513          	addi	a0,s0,-608
 118:	00000097          	auipc	ra,0x0
 11c:	138080e7          	jalr	312(ra) # 250 <strlen>
 120:	1502                	slli	a0,a0,0x20
 122:	9101                	srli	a0,a0,0x20
 124:	da040793          	addi	a5,s0,-608
 128:	953e                	add	a0,a0,a5
        *p = '/';
 12a:	02f00793          	li	a5,47
 12e:	00f50023          	sb	a5,0(a0)
        memmove(p, de.name, DIRSIZ);
 132:	4639                	li	a2,14
 134:	85da                	mv	a1,s6
 136:	0505                	addi	a0,a0,1
 138:	00000097          	auipc	ra,0x0
 13c:	290080e7          	jalr	656(ra) # 3c8 <memmove>
        recur_(buf, target);
 140:	85d6                	mv	a1,s5
 142:	da040513          	addi	a0,s0,-608
 146:	00000097          	auipc	ra,0x0
 14a:	ef6080e7          	jalr	-266(ra) # 3c <recur_>
 14e:	b749                	j	d0 <recur_+0x94>
    if(strcmp(fmtname(path), target) == 0) {
 150:	8552                	mv	a0,s4
 152:	00000097          	auipc	ra,0x0
 156:	eae080e7          	jalr	-338(ra) # 0 <fmtname>
 15a:	85d6                	mv	a1,s5
 15c:	00000097          	auipc	ra,0x0
 160:	0c8080e7          	jalr	200(ra) # 224 <strcmp>
 164:	c519                	beqz	a0,172 <recur_+0x136>
    close(fd);
 166:	8526                	mv	a0,s1
 168:	00000097          	auipc	ra,0x0
 16c:	33e080e7          	jalr	830(ra) # 4a6 <close>
    return;
 170:	a035                	j	19c <recur_+0x160>
      printf("%s\n", path);
 172:	85d2                	mv	a1,s4
 174:	00001517          	auipc	a0,0x1
 178:	83c50513          	addi	a0,a0,-1988 # 9b0 <malloc+0xec>
 17c:	00000097          	auipc	ra,0x0
 180:	68a080e7          	jalr	1674(ra) # 806 <printf>
 184:	b7cd                	j	166 <recur_+0x12a>
     close(fd);
 186:	8526                	mv	a0,s1
 188:	00000097          	auipc	ra,0x0
 18c:	31e080e7          	jalr	798(ra) # 4a6 <close>
     return;
 190:	a031                	j	19c <recur_+0x160>
   close(fd);
 192:	8526                	mv	a0,s1
 194:	00000097          	auipc	ra,0x0
 198:	312080e7          	jalr	786(ra) # 4a6 <close>
}
 19c:	25813083          	ld	ra,600(sp)
 1a0:	25013403          	ld	s0,592(sp)
 1a4:	24813483          	ld	s1,584(sp)
 1a8:	24013903          	ld	s2,576(sp)
 1ac:	23813983          	ld	s3,568(sp)
 1b0:	23013a03          	ld	s4,560(sp)
 1b4:	22813a83          	ld	s5,552(sp)
 1b8:	22013b03          	ld	s6,544(sp)
 1bc:	21813b83          	ld	s7,536(sp)
 1c0:	21013c03          	ld	s8,528(sp)
 1c4:	20813c83          	ld	s9,520(sp)
 1c8:	26010113          	addi	sp,sp,608
 1cc:	8082                	ret

00000000000001ce <main>:




int
main(int argc,char*  argv[]){
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e406                	sd	ra,8(sp)
 1d2:	e022                	sd	s0,0(sp)
 1d4:	0800                	addi	s0,sp,16
 1d6:	87ae                	mv	a5,a1
recur_(argv[1], argv[2]);
 1d8:	698c                	ld	a1,16(a1)
 1da:	6788                	ld	a0,8(a5)
 1dc:	00000097          	auipc	ra,0x0
 1e0:	e60080e7          	jalr	-416(ra) # 3c <recur_>
exit(0);
 1e4:	4501                	li	a0,0
 1e6:	00000097          	auipc	ra,0x0
 1ea:	298080e7          	jalr	664(ra) # 47e <exit>

00000000000001ee <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e406                	sd	ra,8(sp)
 1f2:	e022                	sd	s0,0(sp)
 1f4:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1f6:	00000097          	auipc	ra,0x0
 1fa:	fd8080e7          	jalr	-40(ra) # 1ce <main>
  exit(0);
 1fe:	4501                	li	a0,0
 200:	00000097          	auipc	ra,0x0
 204:	27e080e7          	jalr	638(ra) # 47e <exit>

0000000000000208 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 20e:	87aa                	mv	a5,a0
 210:	0585                	addi	a1,a1,1
 212:	0785                	addi	a5,a5,1
 214:	fff5c703          	lbu	a4,-1(a1)
 218:	fee78fa3          	sb	a4,-1(a5)
 21c:	fb75                	bnez	a4,210 <strcpy+0x8>
    ;
  return os;
}
 21e:	6422                	ld	s0,8(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret

0000000000000224 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 224:	1141                	addi	sp,sp,-16
 226:	e422                	sd	s0,8(sp)
 228:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 22a:	00054783          	lbu	a5,0(a0)
 22e:	cb91                	beqz	a5,242 <strcmp+0x1e>
 230:	0005c703          	lbu	a4,0(a1)
 234:	00f71763          	bne	a4,a5,242 <strcmp+0x1e>
    p++, q++;
 238:	0505                	addi	a0,a0,1
 23a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 23c:	00054783          	lbu	a5,0(a0)
 240:	fbe5                	bnez	a5,230 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 242:	0005c503          	lbu	a0,0(a1)
}
 246:	40a7853b          	subw	a0,a5,a0
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret

0000000000000250 <strlen>:

uint
strlen(const char *s)
{
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 256:	00054783          	lbu	a5,0(a0)
 25a:	cf91                	beqz	a5,276 <strlen+0x26>
 25c:	0505                	addi	a0,a0,1
 25e:	87aa                	mv	a5,a0
 260:	4685                	li	a3,1
 262:	9e89                	subw	a3,a3,a0
 264:	00f6853b          	addw	a0,a3,a5
 268:	0785                	addi	a5,a5,1
 26a:	fff7c703          	lbu	a4,-1(a5)
 26e:	fb7d                	bnez	a4,264 <strlen+0x14>
    ;
  return n;
}
 270:	6422                	ld	s0,8(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret
  for(n = 0; s[n]; n++)
 276:	4501                	li	a0,0
 278:	bfe5                	j	270 <strlen+0x20>

000000000000027a <memset>:

void*
memset(void *dst, int c, uint n)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 280:	ce09                	beqz	a2,29a <memset+0x20>
 282:	87aa                	mv	a5,a0
 284:	fff6071b          	addiw	a4,a2,-1
 288:	1702                	slli	a4,a4,0x20
 28a:	9301                	srli	a4,a4,0x20
 28c:	0705                	addi	a4,a4,1
 28e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 290:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 294:	0785                	addi	a5,a5,1
 296:	fee79de3          	bne	a5,a4,290 <memset+0x16>
  }
  return dst;
}
 29a:	6422                	ld	s0,8(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <strchr>:

char*
strchr(const char *s, char c)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	cb99                	beqz	a5,2c0 <strchr+0x20>
    if(*s == c)
 2ac:	00f58763          	beq	a1,a5,2ba <strchr+0x1a>
  for(; *s; s++)
 2b0:	0505                	addi	a0,a0,1
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	fbfd                	bnez	a5,2ac <strchr+0xc>
      return (char*)s;
  return 0;
 2b8:	4501                	li	a0,0
}
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
  return 0;
 2c0:	4501                	li	a0,0
 2c2:	bfe5                	j	2ba <strchr+0x1a>

00000000000002c4 <gets>:

char*
gets(char *buf, int max)
{
 2c4:	711d                	addi	sp,sp,-96
 2c6:	ec86                	sd	ra,88(sp)
 2c8:	e8a2                	sd	s0,80(sp)
 2ca:	e4a6                	sd	s1,72(sp)
 2cc:	e0ca                	sd	s2,64(sp)
 2ce:	fc4e                	sd	s3,56(sp)
 2d0:	f852                	sd	s4,48(sp)
 2d2:	f456                	sd	s5,40(sp)
 2d4:	f05a                	sd	s6,32(sp)
 2d6:	ec5e                	sd	s7,24(sp)
 2d8:	1080                	addi	s0,sp,96
 2da:	8baa                	mv	s7,a0
 2dc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2de:	892a                	mv	s2,a0
 2e0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2e2:	4aa9                	li	s5,10
 2e4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2e6:	89a6                	mv	s3,s1
 2e8:	2485                	addiw	s1,s1,1
 2ea:	0344d863          	bge	s1,s4,31a <gets+0x56>
    cc = read(0, &c, 1);
 2ee:	4605                	li	a2,1
 2f0:	faf40593          	addi	a1,s0,-81
 2f4:	4501                	li	a0,0
 2f6:	00000097          	auipc	ra,0x0
 2fa:	1a0080e7          	jalr	416(ra) # 496 <read>
    if(cc < 1)
 2fe:	00a05e63          	blez	a0,31a <gets+0x56>
    buf[i++] = c;
 302:	faf44783          	lbu	a5,-81(s0)
 306:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 30a:	01578763          	beq	a5,s5,318 <gets+0x54>
 30e:	0905                	addi	s2,s2,1
 310:	fd679be3          	bne	a5,s6,2e6 <gets+0x22>
  for(i=0; i+1 < max; ){
 314:	89a6                	mv	s3,s1
 316:	a011                	j	31a <gets+0x56>
 318:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 31a:	99de                	add	s3,s3,s7
 31c:	00098023          	sb	zero,0(s3)
  return buf;
}
 320:	855e                	mv	a0,s7
 322:	60e6                	ld	ra,88(sp)
 324:	6446                	ld	s0,80(sp)
 326:	64a6                	ld	s1,72(sp)
 328:	6906                	ld	s2,64(sp)
 32a:	79e2                	ld	s3,56(sp)
 32c:	7a42                	ld	s4,48(sp)
 32e:	7aa2                	ld	s5,40(sp)
 330:	7b02                	ld	s6,32(sp)
 332:	6be2                	ld	s7,24(sp)
 334:	6125                	addi	sp,sp,96
 336:	8082                	ret

0000000000000338 <stat>:

int
stat(const char *n, struct stat *st)
{
 338:	1101                	addi	sp,sp,-32
 33a:	ec06                	sd	ra,24(sp)
 33c:	e822                	sd	s0,16(sp)
 33e:	e426                	sd	s1,8(sp)
 340:	e04a                	sd	s2,0(sp)
 342:	1000                	addi	s0,sp,32
 344:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 346:	4581                	li	a1,0
 348:	00000097          	auipc	ra,0x0
 34c:	176080e7          	jalr	374(ra) # 4be <open>
  if(fd < 0)
 350:	02054563          	bltz	a0,37a <stat+0x42>
 354:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 356:	85ca                	mv	a1,s2
 358:	00000097          	auipc	ra,0x0
 35c:	17e080e7          	jalr	382(ra) # 4d6 <fstat>
 360:	892a                	mv	s2,a0
  close(fd);
 362:	8526                	mv	a0,s1
 364:	00000097          	auipc	ra,0x0
 368:	142080e7          	jalr	322(ra) # 4a6 <close>
  return r;
}
 36c:	854a                	mv	a0,s2
 36e:	60e2                	ld	ra,24(sp)
 370:	6442                	ld	s0,16(sp)
 372:	64a2                	ld	s1,8(sp)
 374:	6902                	ld	s2,0(sp)
 376:	6105                	addi	sp,sp,32
 378:	8082                	ret
    return -1;
 37a:	597d                	li	s2,-1
 37c:	bfc5                	j	36c <stat+0x34>

000000000000037e <atoi>:

int
atoi(const char *s)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e422                	sd	s0,8(sp)
 382:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 384:	00054603          	lbu	a2,0(a0)
 388:	fd06079b          	addiw	a5,a2,-48
 38c:	0ff7f793          	andi	a5,a5,255
 390:	4725                	li	a4,9
 392:	02f76963          	bltu	a4,a5,3c4 <atoi+0x46>
 396:	86aa                	mv	a3,a0
  n = 0;
 398:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 39a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 39c:	0685                	addi	a3,a3,1
 39e:	0025179b          	slliw	a5,a0,0x2
 3a2:	9fa9                	addw	a5,a5,a0
 3a4:	0017979b          	slliw	a5,a5,0x1
 3a8:	9fb1                	addw	a5,a5,a2
 3aa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3ae:	0006c603          	lbu	a2,0(a3)
 3b2:	fd06071b          	addiw	a4,a2,-48
 3b6:	0ff77713          	andi	a4,a4,255
 3ba:	fee5f1e3          	bgeu	a1,a4,39c <atoi+0x1e>
  return n;
}
 3be:	6422                	ld	s0,8(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret
  n = 0;
 3c4:	4501                	li	a0,0
 3c6:	bfe5                	j	3be <atoi+0x40>

00000000000003c8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3c8:	1141                	addi	sp,sp,-16
 3ca:	e422                	sd	s0,8(sp)
 3cc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3ce:	02b57663          	bgeu	a0,a1,3fa <memmove+0x32>
    while(n-- > 0)
 3d2:	02c05163          	blez	a2,3f4 <memmove+0x2c>
 3d6:	fff6079b          	addiw	a5,a2,-1
 3da:	1782                	slli	a5,a5,0x20
 3dc:	9381                	srli	a5,a5,0x20
 3de:	0785                	addi	a5,a5,1
 3e0:	97aa                	add	a5,a5,a0
  dst = vdst;
 3e2:	872a                	mv	a4,a0
      *dst++ = *src++;
 3e4:	0585                	addi	a1,a1,1
 3e6:	0705                	addi	a4,a4,1
 3e8:	fff5c683          	lbu	a3,-1(a1)
 3ec:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3f0:	fee79ae3          	bne	a5,a4,3e4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3f4:	6422                	ld	s0,8(sp)
 3f6:	0141                	addi	sp,sp,16
 3f8:	8082                	ret
    dst += n;
 3fa:	00c50733          	add	a4,a0,a2
    src += n;
 3fe:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 400:	fec05ae3          	blez	a2,3f4 <memmove+0x2c>
 404:	fff6079b          	addiw	a5,a2,-1
 408:	1782                	slli	a5,a5,0x20
 40a:	9381                	srli	a5,a5,0x20
 40c:	fff7c793          	not	a5,a5
 410:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 412:	15fd                	addi	a1,a1,-1
 414:	177d                	addi	a4,a4,-1
 416:	0005c683          	lbu	a3,0(a1)
 41a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 41e:	fee79ae3          	bne	a5,a4,412 <memmove+0x4a>
 422:	bfc9                	j	3f4 <memmove+0x2c>

0000000000000424 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 424:	1141                	addi	sp,sp,-16
 426:	e422                	sd	s0,8(sp)
 428:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 42a:	ca05                	beqz	a2,45a <memcmp+0x36>
 42c:	fff6069b          	addiw	a3,a2,-1
 430:	1682                	slli	a3,a3,0x20
 432:	9281                	srli	a3,a3,0x20
 434:	0685                	addi	a3,a3,1
 436:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 438:	00054783          	lbu	a5,0(a0)
 43c:	0005c703          	lbu	a4,0(a1)
 440:	00e79863          	bne	a5,a4,450 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 444:	0505                	addi	a0,a0,1
    p2++;
 446:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 448:	fed518e3          	bne	a0,a3,438 <memcmp+0x14>
  }
  return 0;
 44c:	4501                	li	a0,0
 44e:	a019                	j	454 <memcmp+0x30>
      return *p1 - *p2;
 450:	40e7853b          	subw	a0,a5,a4
}
 454:	6422                	ld	s0,8(sp)
 456:	0141                	addi	sp,sp,16
 458:	8082                	ret
  return 0;
 45a:	4501                	li	a0,0
 45c:	bfe5                	j	454 <memcmp+0x30>

000000000000045e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 45e:	1141                	addi	sp,sp,-16
 460:	e406                	sd	ra,8(sp)
 462:	e022                	sd	s0,0(sp)
 464:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 466:	00000097          	auipc	ra,0x0
 46a:	f62080e7          	jalr	-158(ra) # 3c8 <memmove>
}
 46e:	60a2                	ld	ra,8(sp)
 470:	6402                	ld	s0,0(sp)
 472:	0141                	addi	sp,sp,16
 474:	8082                	ret

0000000000000476 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 476:	4885                	li	a7,1
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <exit>:
.global exit
exit:
 li a7, SYS_exit
 47e:	4889                	li	a7,2
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <wait>:
.global wait
wait:
 li a7, SYS_wait
 486:	488d                	li	a7,3
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 48e:	4891                	li	a7,4
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <read>:
.global read
read:
 li a7, SYS_read
 496:	4895                	li	a7,5
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <write>:
.global write
write:
 li a7, SYS_write
 49e:	48c1                	li	a7,16
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <close>:
.global close
close:
 li a7, SYS_close
 4a6:	48d5                	li	a7,21
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ae:	4899                	li	a7,6
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4b6:	489d                	li	a7,7
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <open>:
.global open
open:
 li a7, SYS_open
 4be:	48bd                	li	a7,15
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4c6:	48c5                	li	a7,17
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4ce:	48c9                	li	a7,18
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4d6:	48a1                	li	a7,8
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <link>:
.global link
link:
 li a7, SYS_link
 4de:	48cd                	li	a7,19
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4e6:	48d1                	li	a7,20
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ee:	48a5                	li	a7,9
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4f6:	48a9                	li	a7,10
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4fe:	48ad                	li	a7,11
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 506:	48b1                	li	a7,12
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 50e:	48b5                	li	a7,13
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 516:	48b9                	li	a7,14
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <trace>:
.global trace
trace:
 li a7, SYS_trace
 51e:	48d9                	li	a7,22
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 526:	48dd                	li	a7,23
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 52e:	1101                	addi	sp,sp,-32
 530:	ec06                	sd	ra,24(sp)
 532:	e822                	sd	s0,16(sp)
 534:	1000                	addi	s0,sp,32
 536:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 53a:	4605                	li	a2,1
 53c:	fef40593          	addi	a1,s0,-17
 540:	00000097          	auipc	ra,0x0
 544:	f5e080e7          	jalr	-162(ra) # 49e <write>
}
 548:	60e2                	ld	ra,24(sp)
 54a:	6442                	ld	s0,16(sp)
 54c:	6105                	addi	sp,sp,32
 54e:	8082                	ret

0000000000000550 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 550:	7139                	addi	sp,sp,-64
 552:	fc06                	sd	ra,56(sp)
 554:	f822                	sd	s0,48(sp)
 556:	f426                	sd	s1,40(sp)
 558:	f04a                	sd	s2,32(sp)
 55a:	ec4e                	sd	s3,24(sp)
 55c:	0080                	addi	s0,sp,64
 55e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 560:	c299                	beqz	a3,566 <printint+0x16>
 562:	0805c863          	bltz	a1,5f2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 566:	2581                	sext.w	a1,a1
  neg = 0;
 568:	4881                	li	a7,0
 56a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 56e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 570:	2601                	sext.w	a2,a2
 572:	00000517          	auipc	a0,0x0
 576:	45e50513          	addi	a0,a0,1118 # 9d0 <digits>
 57a:	883a                	mv	a6,a4
 57c:	2705                	addiw	a4,a4,1
 57e:	02c5f7bb          	remuw	a5,a1,a2
 582:	1782                	slli	a5,a5,0x20
 584:	9381                	srli	a5,a5,0x20
 586:	97aa                	add	a5,a5,a0
 588:	0007c783          	lbu	a5,0(a5)
 58c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 590:	0005879b          	sext.w	a5,a1
 594:	02c5d5bb          	divuw	a1,a1,a2
 598:	0685                	addi	a3,a3,1
 59a:	fec7f0e3          	bgeu	a5,a2,57a <printint+0x2a>
  if(neg)
 59e:	00088b63          	beqz	a7,5b4 <printint+0x64>
    buf[i++] = '-';
 5a2:	fd040793          	addi	a5,s0,-48
 5a6:	973e                	add	a4,a4,a5
 5a8:	02d00793          	li	a5,45
 5ac:	fef70823          	sb	a5,-16(a4)
 5b0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5b4:	02e05863          	blez	a4,5e4 <printint+0x94>
 5b8:	fc040793          	addi	a5,s0,-64
 5bc:	00e78933          	add	s2,a5,a4
 5c0:	fff78993          	addi	s3,a5,-1
 5c4:	99ba                	add	s3,s3,a4
 5c6:	377d                	addiw	a4,a4,-1
 5c8:	1702                	slli	a4,a4,0x20
 5ca:	9301                	srli	a4,a4,0x20
 5cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5d0:	fff94583          	lbu	a1,-1(s2)
 5d4:	8526                	mv	a0,s1
 5d6:	00000097          	auipc	ra,0x0
 5da:	f58080e7          	jalr	-168(ra) # 52e <putc>
  while(--i >= 0)
 5de:	197d                	addi	s2,s2,-1
 5e0:	ff3918e3          	bne	s2,s3,5d0 <printint+0x80>
}
 5e4:	70e2                	ld	ra,56(sp)
 5e6:	7442                	ld	s0,48(sp)
 5e8:	74a2                	ld	s1,40(sp)
 5ea:	7902                	ld	s2,32(sp)
 5ec:	69e2                	ld	s3,24(sp)
 5ee:	6121                	addi	sp,sp,64
 5f0:	8082                	ret
    x = -xx;
 5f2:	40b005bb          	negw	a1,a1
    neg = 1;
 5f6:	4885                	li	a7,1
    x = -xx;
 5f8:	bf8d                	j	56a <printint+0x1a>

00000000000005fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5fa:	7119                	addi	sp,sp,-128
 5fc:	fc86                	sd	ra,120(sp)
 5fe:	f8a2                	sd	s0,112(sp)
 600:	f4a6                	sd	s1,104(sp)
 602:	f0ca                	sd	s2,96(sp)
 604:	ecce                	sd	s3,88(sp)
 606:	e8d2                	sd	s4,80(sp)
 608:	e4d6                	sd	s5,72(sp)
 60a:	e0da                	sd	s6,64(sp)
 60c:	fc5e                	sd	s7,56(sp)
 60e:	f862                	sd	s8,48(sp)
 610:	f466                	sd	s9,40(sp)
 612:	f06a                	sd	s10,32(sp)
 614:	ec6e                	sd	s11,24(sp)
 616:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 618:	0005c903          	lbu	s2,0(a1)
 61c:	18090f63          	beqz	s2,7ba <vprintf+0x1c0>
 620:	8aaa                	mv	s5,a0
 622:	8b32                	mv	s6,a2
 624:	00158493          	addi	s1,a1,1
  state = 0;
 628:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 62a:	02500a13          	li	s4,37
      if(c == 'd'){
 62e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 632:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 636:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 63a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63e:	00000b97          	auipc	s7,0x0
 642:	392b8b93          	addi	s7,s7,914 # 9d0 <digits>
 646:	a839                	j	664 <vprintf+0x6a>
        putc(fd, c);
 648:	85ca                	mv	a1,s2
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	ee2080e7          	jalr	-286(ra) # 52e <putc>
 654:	a019                	j	65a <vprintf+0x60>
    } else if(state == '%'){
 656:	01498f63          	beq	s3,s4,674 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 65a:	0485                	addi	s1,s1,1
 65c:	fff4c903          	lbu	s2,-1(s1)
 660:	14090d63          	beqz	s2,7ba <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 664:	0009079b          	sext.w	a5,s2
    if(state == 0){
 668:	fe0997e3          	bnez	s3,656 <vprintf+0x5c>
      if(c == '%'){
 66c:	fd479ee3          	bne	a5,s4,648 <vprintf+0x4e>
        state = '%';
 670:	89be                	mv	s3,a5
 672:	b7e5                	j	65a <vprintf+0x60>
      if(c == 'd'){
 674:	05878063          	beq	a5,s8,6b4 <vprintf+0xba>
      } else if(c == 'l') {
 678:	05978c63          	beq	a5,s9,6d0 <vprintf+0xd6>
      } else if(c == 'x') {
 67c:	07a78863          	beq	a5,s10,6ec <vprintf+0xf2>
      } else if(c == 'p') {
 680:	09b78463          	beq	a5,s11,708 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 684:	07300713          	li	a4,115
 688:	0ce78663          	beq	a5,a4,754 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 68c:	06300713          	li	a4,99
 690:	0ee78e63          	beq	a5,a4,78c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 694:	11478863          	beq	a5,s4,7a4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 698:	85d2                	mv	a1,s4
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	e92080e7          	jalr	-366(ra) # 52e <putc>
        putc(fd, c);
 6a4:	85ca                	mv	a1,s2
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e86080e7          	jalr	-378(ra) # 52e <putc>
      }
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b765                	j	65a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6b4:	008b0913          	addi	s2,s6,8
 6b8:	4685                	li	a3,1
 6ba:	4629                	li	a2,10
 6bc:	000b2583          	lw	a1,0(s6)
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e8e080e7          	jalr	-370(ra) # 550 <printint>
 6ca:	8b4a                	mv	s6,s2
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b771                	j	65a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d0:	008b0913          	addi	s2,s6,8
 6d4:	4681                	li	a3,0
 6d6:	4629                	li	a2,10
 6d8:	000b2583          	lw	a1,0(s6)
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	e72080e7          	jalr	-398(ra) # 550 <printint>
 6e6:	8b4a                	mv	s6,s2
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bf85                	j	65a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6ec:	008b0913          	addi	s2,s6,8
 6f0:	4681                	li	a3,0
 6f2:	4641                	li	a2,16
 6f4:	000b2583          	lw	a1,0(s6)
 6f8:	8556                	mv	a0,s5
 6fa:	00000097          	auipc	ra,0x0
 6fe:	e56080e7          	jalr	-426(ra) # 550 <printint>
 702:	8b4a                	mv	s6,s2
      state = 0;
 704:	4981                	li	s3,0
 706:	bf91                	j	65a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 708:	008b0793          	addi	a5,s6,8
 70c:	f8f43423          	sd	a5,-120(s0)
 710:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 714:	03000593          	li	a1,48
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	e14080e7          	jalr	-492(ra) # 52e <putc>
  putc(fd, 'x');
 722:	85ea                	mv	a1,s10
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	e08080e7          	jalr	-504(ra) # 52e <putc>
 72e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 730:	03c9d793          	srli	a5,s3,0x3c
 734:	97de                	add	a5,a5,s7
 736:	0007c583          	lbu	a1,0(a5)
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	df2080e7          	jalr	-526(ra) # 52e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 744:	0992                	slli	s3,s3,0x4
 746:	397d                	addiw	s2,s2,-1
 748:	fe0914e3          	bnez	s2,730 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 74c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 750:	4981                	li	s3,0
 752:	b721                	j	65a <vprintf+0x60>
        s = va_arg(ap, char*);
 754:	008b0993          	addi	s3,s6,8
 758:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 75c:	02090163          	beqz	s2,77e <vprintf+0x184>
        while(*s != 0){
 760:	00094583          	lbu	a1,0(s2)
 764:	c9a1                	beqz	a1,7b4 <vprintf+0x1ba>
          putc(fd, *s);
 766:	8556                	mv	a0,s5
 768:	00000097          	auipc	ra,0x0
 76c:	dc6080e7          	jalr	-570(ra) # 52e <putc>
          s++;
 770:	0905                	addi	s2,s2,1
        while(*s != 0){
 772:	00094583          	lbu	a1,0(s2)
 776:	f9e5                	bnez	a1,766 <vprintf+0x16c>
        s = va_arg(ap, char*);
 778:	8b4e                	mv	s6,s3
      state = 0;
 77a:	4981                	li	s3,0
 77c:	bdf9                	j	65a <vprintf+0x60>
          s = "(null)";
 77e:	00000917          	auipc	s2,0x0
 782:	24a90913          	addi	s2,s2,586 # 9c8 <malloc+0x104>
        while(*s != 0){
 786:	02800593          	li	a1,40
 78a:	bff1                	j	766 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 78c:	008b0913          	addi	s2,s6,8
 790:	000b4583          	lbu	a1,0(s6)
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	d98080e7          	jalr	-616(ra) # 52e <putc>
 79e:	8b4a                	mv	s6,s2
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	bd65                	j	65a <vprintf+0x60>
        putc(fd, c);
 7a4:	85d2                	mv	a1,s4
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	d86080e7          	jalr	-634(ra) # 52e <putc>
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b565                	j	65a <vprintf+0x60>
        s = va_arg(ap, char*);
 7b4:	8b4e                	mv	s6,s3
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b54d                	j	65a <vprintf+0x60>
    }
  }
}
 7ba:	70e6                	ld	ra,120(sp)
 7bc:	7446                	ld	s0,112(sp)
 7be:	74a6                	ld	s1,104(sp)
 7c0:	7906                	ld	s2,96(sp)
 7c2:	69e6                	ld	s3,88(sp)
 7c4:	6a46                	ld	s4,80(sp)
 7c6:	6aa6                	ld	s5,72(sp)
 7c8:	6b06                	ld	s6,64(sp)
 7ca:	7be2                	ld	s7,56(sp)
 7cc:	7c42                	ld	s8,48(sp)
 7ce:	7ca2                	ld	s9,40(sp)
 7d0:	7d02                	ld	s10,32(sp)
 7d2:	6de2                	ld	s11,24(sp)
 7d4:	6109                	addi	sp,sp,128
 7d6:	8082                	ret

00000000000007d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d8:	715d                	addi	sp,sp,-80
 7da:	ec06                	sd	ra,24(sp)
 7dc:	e822                	sd	s0,16(sp)
 7de:	1000                	addi	s0,sp,32
 7e0:	e010                	sd	a2,0(s0)
 7e2:	e414                	sd	a3,8(s0)
 7e4:	e818                	sd	a4,16(s0)
 7e6:	ec1c                	sd	a5,24(s0)
 7e8:	03043023          	sd	a6,32(s0)
 7ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f4:	8622                	mv	a2,s0
 7f6:	00000097          	auipc	ra,0x0
 7fa:	e04080e7          	jalr	-508(ra) # 5fa <vprintf>
}
 7fe:	60e2                	ld	ra,24(sp)
 800:	6442                	ld	s0,16(sp)
 802:	6161                	addi	sp,sp,80
 804:	8082                	ret

0000000000000806 <printf>:

void
printf(const char *fmt, ...)
{
 806:	711d                	addi	sp,sp,-96
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e40c                	sd	a1,8(s0)
 810:	e810                	sd	a2,16(s0)
 812:	ec14                	sd	a3,24(s0)
 814:	f018                	sd	a4,32(s0)
 816:	f41c                	sd	a5,40(s0)
 818:	03043823          	sd	a6,48(s0)
 81c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 820:	00840613          	addi	a2,s0,8
 824:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 828:	85aa                	mv	a1,a0
 82a:	4505                	li	a0,1
 82c:	00000097          	auipc	ra,0x0
 830:	dce080e7          	jalr	-562(ra) # 5fa <vprintf>
}
 834:	60e2                	ld	ra,24(sp)
 836:	6442                	ld	s0,16(sp)
 838:	6125                	addi	sp,sp,96
 83a:	8082                	ret

000000000000083c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83c:	1141                	addi	sp,sp,-16
 83e:	e422                	sd	s0,8(sp)
 840:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 842:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 846:	00000797          	auipc	a5,0x0
 84a:	7ba7b783          	ld	a5,1978(a5) # 1000 <freep>
 84e:	a805                	j	87e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 850:	4618                	lw	a4,8(a2)
 852:	9db9                	addw	a1,a1,a4
 854:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 858:	6398                	ld	a4,0(a5)
 85a:	6318                	ld	a4,0(a4)
 85c:	fee53823          	sd	a4,-16(a0)
 860:	a091                	j	8a4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 862:	ff852703          	lw	a4,-8(a0)
 866:	9e39                	addw	a2,a2,a4
 868:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 86a:	ff053703          	ld	a4,-16(a0)
 86e:	e398                	sd	a4,0(a5)
 870:	a099                	j	8b6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 872:	6398                	ld	a4,0(a5)
 874:	00e7e463          	bltu	a5,a4,87c <free+0x40>
 878:	00e6ea63          	bltu	a3,a4,88c <free+0x50>
{
 87c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87e:	fed7fae3          	bgeu	a5,a3,872 <free+0x36>
 882:	6398                	ld	a4,0(a5)
 884:	00e6e463          	bltu	a3,a4,88c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 888:	fee7eae3          	bltu	a5,a4,87c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 88c:	ff852583          	lw	a1,-8(a0)
 890:	6390                	ld	a2,0(a5)
 892:	02059713          	slli	a4,a1,0x20
 896:	9301                	srli	a4,a4,0x20
 898:	0712                	slli	a4,a4,0x4
 89a:	9736                	add	a4,a4,a3
 89c:	fae60ae3          	beq	a2,a4,850 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8a0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8a4:	4790                	lw	a2,8(a5)
 8a6:	02061713          	slli	a4,a2,0x20
 8aa:	9301                	srli	a4,a4,0x20
 8ac:	0712                	slli	a4,a4,0x4
 8ae:	973e                	add	a4,a4,a5
 8b0:	fae689e3          	beq	a3,a4,862 <free+0x26>
  } else
    p->s.ptr = bp;
 8b4:	e394                	sd	a3,0(a5)
  freep = p;
 8b6:	00000717          	auipc	a4,0x0
 8ba:	74f73523          	sd	a5,1866(a4) # 1000 <freep>
}
 8be:	6422                	ld	s0,8(sp)
 8c0:	0141                	addi	sp,sp,16
 8c2:	8082                	ret

00000000000008c4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c4:	7139                	addi	sp,sp,-64
 8c6:	fc06                	sd	ra,56(sp)
 8c8:	f822                	sd	s0,48(sp)
 8ca:	f426                	sd	s1,40(sp)
 8cc:	f04a                	sd	s2,32(sp)
 8ce:	ec4e                	sd	s3,24(sp)
 8d0:	e852                	sd	s4,16(sp)
 8d2:	e456                	sd	s5,8(sp)
 8d4:	e05a                	sd	s6,0(sp)
 8d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d8:	02051493          	slli	s1,a0,0x20
 8dc:	9081                	srli	s1,s1,0x20
 8de:	04bd                	addi	s1,s1,15
 8e0:	8091                	srli	s1,s1,0x4
 8e2:	0014899b          	addiw	s3,s1,1
 8e6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8e8:	00000517          	auipc	a0,0x0
 8ec:	71853503          	ld	a0,1816(a0) # 1000 <freep>
 8f0:	c515                	beqz	a0,91c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f4:	4798                	lw	a4,8(a5)
 8f6:	02977f63          	bgeu	a4,s1,934 <malloc+0x70>
 8fa:	8a4e                	mv	s4,s3
 8fc:	0009871b          	sext.w	a4,s3
 900:	6685                	lui	a3,0x1
 902:	00d77363          	bgeu	a4,a3,908 <malloc+0x44>
 906:	6a05                	lui	s4,0x1
 908:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 90c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 910:	00000917          	auipc	s2,0x0
 914:	6f090913          	addi	s2,s2,1776 # 1000 <freep>
  if(p == (char*)-1)
 918:	5afd                	li	s5,-1
 91a:	a88d                	j	98c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 91c:	00000797          	auipc	a5,0x0
 920:	71c78793          	addi	a5,a5,1820 # 1038 <base>
 924:	00000717          	auipc	a4,0x0
 928:	6cf73e23          	sd	a5,1756(a4) # 1000 <freep>
 92c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 92e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 932:	b7e1                	j	8fa <malloc+0x36>
      if(p->s.size == nunits)
 934:	02e48b63          	beq	s1,a4,96a <malloc+0xa6>
        p->s.size -= nunits;
 938:	4137073b          	subw	a4,a4,s3
 93c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 93e:	1702                	slli	a4,a4,0x20
 940:	9301                	srli	a4,a4,0x20
 942:	0712                	slli	a4,a4,0x4
 944:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 946:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 94a:	00000717          	auipc	a4,0x0
 94e:	6aa73b23          	sd	a0,1718(a4) # 1000 <freep>
      return (void*)(p + 1);
 952:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 956:	70e2                	ld	ra,56(sp)
 958:	7442                	ld	s0,48(sp)
 95a:	74a2                	ld	s1,40(sp)
 95c:	7902                	ld	s2,32(sp)
 95e:	69e2                	ld	s3,24(sp)
 960:	6a42                	ld	s4,16(sp)
 962:	6aa2                	ld	s5,8(sp)
 964:	6b02                	ld	s6,0(sp)
 966:	6121                	addi	sp,sp,64
 968:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 96a:	6398                	ld	a4,0(a5)
 96c:	e118                	sd	a4,0(a0)
 96e:	bff1                	j	94a <malloc+0x86>
  hp->s.size = nu;
 970:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 974:	0541                	addi	a0,a0,16
 976:	00000097          	auipc	ra,0x0
 97a:	ec6080e7          	jalr	-314(ra) # 83c <free>
  return freep;
 97e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 982:	d971                	beqz	a0,956 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 984:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 986:	4798                	lw	a4,8(a5)
 988:	fa9776e3          	bgeu	a4,s1,934 <malloc+0x70>
    if(p == freep)
 98c:	00093703          	ld	a4,0(s2)
 990:	853e                	mv	a0,a5
 992:	fef719e3          	bne	a4,a5,984 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 996:	8552                	mv	a0,s4
 998:	00000097          	auipc	ra,0x0
 99c:	b6e080e7          	jalr	-1170(ra) # 506 <sbrk>
  if(p == (char*)-1)
 9a0:	fd5518e3          	bne	a0,s5,970 <malloc+0xac>
        return 0;
 9a4:	4501                	li	a0,0
 9a6:	bf45                	j	956 <malloc+0x92>
