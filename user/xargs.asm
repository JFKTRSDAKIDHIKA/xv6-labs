
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"



int 
main(int argc, char* argv[MAXARG]){
   0:	da010113          	addi	sp,sp,-608
   4:	24113c23          	sd	ra,600(sp)
   8:	24813823          	sd	s0,592(sp)
   c:	24913423          	sd	s1,584(sp)
  10:	25213023          	sd	s2,576(sp)
  14:	23313c23          	sd	s3,568(sp)
  18:	23413823          	sd	s4,560(sp)
  1c:	23513423          	sd	s5,552(sp)
  20:	23613023          	sd	s6,544(sp)
  24:	21713c23          	sd	s7,536(sp)
  28:	21813823          	sd	s8,528(sp)
  2c:	21913423          	sd	s9,520(sp)
  30:	21a13023          	sd	s10,512(sp)
  34:	1480                	addi	s0,sp,608
  36:	8b2a                	mv	s6,a0
  38:	8bae                	mv	s7,a1
//  printf("fname: %s\n", argv[1]);
  for(int i = 2; i <= argc - 1; i++){
  3a:	4789                	li	a5,2
  3c:	00a7d563          	bge	a5,a0,46 <main+0x46>
  40:	2785                	addiw	a5,a5,1
  42:	fefb1fe3          	bne	s6,a5,40 <main+0x40>
  }while(flag == 1);
 if(flag != 0){
  // printf("buf: %s, size is: %d\n", buf, strlen(buf));
//  printf("argc: %d\n", argc);
 // printf("argv: %s %s %s\n",*( argv+1),*( argv+2),*( argv+3));
  char** new_argv = malloc((argc + 2) * sizeof(char*)); 
  46:	002b0c1b          	addiw	s8,s6,2
  4a:	003c1c1b          	slliw	s8,s8,0x3
  for (int i = 0; i < argc - 1; i++) {
    new_argv[i] = argv[i + 1];
  }
  new_argv[argc-1] = buf;
  4e:	003b1c93          	slli	s9,s6,0x3
  52:	ff8c8d13          	addi	s10,s9,-8
  56:	ffeb0a9b          	addiw	s5,s6,-2
  5a:	1a82                	slli	s5,s5,0x20
  5c:	020ada93          	srli	s5,s5,0x20
  60:	0a8e                	slli	s5,s5,0x3
  62:	010b8793          	addi	a5,s7,16
  66:	9abe                	add	s5,s5,a5
      n = 0;
  68:	4981                	li	s3,0
      if(buf[n] == '\n')
  6a:	4a29                	li	s4,10
      n = 0;
  6c:	894e                	mv	s2,s3
      p = buf;
  6e:	da040493          	addi	s1,s0,-608
      flag = read(0, p, 1);
  72:	4605                	li	a2,1
  74:	85a6                	mv	a1,s1
  76:	854e                	mv	a0,s3
  78:	00000097          	auipc	ra,0x0
  7c:	336080e7          	jalr	822(ra) # 3ae <read>
      if(buf[n] == '\n')
  80:	0004c783          	lbu	a5,0(s1)
  84:	01478863          	beq	a5,s4,94 <main+0x94>
    n++;
  88:	2905                	addiw	s2,s2,1
    p = p + 1;
  8a:	0485                	addi	s1,s1,1
  }while(flag == 1);
  8c:	4785                	li	a5,1
  8e:	fef502e3          	beq	a0,a5,72 <main+0x72>
  92:	a031                	j	9e <main+0x9e>
              buf[n] = '\0';
  94:	fa040793          	addi	a5,s0,-96
  98:	993e                	add	s2,s2,a5
  9a:	e0090023          	sb	zero,-512(s2)
 if(flag != 0){
  9e:	e511                	bnez	a0,aa <main+0xaa>
  }while(flag != 0);




  exit(0);
  a0:	4501                	li	a0,0
  a2:	00000097          	auipc	ra,0x0
  a6:	2f4080e7          	jalr	756(ra) # 396 <exit>
  char** new_argv = malloc((argc + 2) * sizeof(char*)); 
  aa:	8562                	mv	a0,s8
  ac:	00000097          	auipc	ra,0x0
  b0:	730080e7          	jalr	1840(ra) # 7dc <malloc>
  b4:	84aa                	mv	s1,a0
  for (int i = 0; i < argc - 1; i++) {
  b6:	4785                	li	a5,1
  b8:	0167db63          	bge	a5,s6,ce <main+0xce>
  bc:	008b8793          	addi	a5,s7,8
  c0:	872a                	mv	a4,a0
    new_argv[i] = argv[i + 1];
  c2:	6394                	ld	a3,0(a5)
  c4:	e314                	sd	a3,0(a4)
  for (int i = 0; i < argc - 1; i++) {
  c6:	07a1                	addi	a5,a5,8
  c8:	0721                	addi	a4,a4,8
  ca:	ff579ce3          	bne	a5,s5,c2 <main+0xc2>
  new_argv[argc-1] = buf;
  ce:	01a487b3          	add	a5,s1,s10
  d2:	da040713          	addi	a4,s0,-608
  d6:	e398                	sd	a4,0(a5)
  new_argv[argc] = 0; 
  d8:	019487b3          	add	a5,s1,s9
  dc:	0007b023          	sd	zero,0(a5)
   int  pid = fork();
  e0:	00000097          	auipc	ra,0x0
  e4:	2ae080e7          	jalr	686(ra) # 38e <fork>
   if(pid == 0){
  e8:	e909                	bnez	a0,fa <main+0xfa>
   exec(argv[1], new_argv);
  ea:	85a6                	mv	a1,s1
  ec:	008bb503          	ld	a0,8(s7)
  f0:	00000097          	auipc	ra,0x0
  f4:	2de080e7          	jalr	734(ra) # 3ce <exec>
  f8:	bf95                	j	6c <main+0x6c>
   wait(0);
  fa:	854e                	mv	a0,s3
  fc:	00000097          	auipc	ra,0x0
 100:	2a2080e7          	jalr	674(ra) # 39e <wait>
  }while(flag != 0);
 104:	b7a5                	j	6c <main+0x6c>

0000000000000106 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 10e:	00000097          	auipc	ra,0x0
 112:	ef2080e7          	jalr	-270(ra) # 0 <main>
  exit(0);
 116:	4501                	li	a0,0
 118:	00000097          	auipc	ra,0x0
 11c:	27e080e7          	jalr	638(ra) # 396 <exit>

0000000000000120 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 120:	1141                	addi	sp,sp,-16
 122:	e422                	sd	s0,8(sp)
 124:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 126:	87aa                	mv	a5,a0
 128:	0585                	addi	a1,a1,1
 12a:	0785                	addi	a5,a5,1
 12c:	fff5c703          	lbu	a4,-1(a1)
 130:	fee78fa3          	sb	a4,-1(a5)
 134:	fb75                	bnez	a4,128 <strcpy+0x8>
    ;
  return os;
}
 136:	6422                	ld	s0,8(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret

000000000000013c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13c:	1141                	addi	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 142:	00054783          	lbu	a5,0(a0)
 146:	cb91                	beqz	a5,15a <strcmp+0x1e>
 148:	0005c703          	lbu	a4,0(a1)
 14c:	00f71763          	bne	a4,a5,15a <strcmp+0x1e>
    p++, q++;
 150:	0505                	addi	a0,a0,1
 152:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 154:	00054783          	lbu	a5,0(a0)
 158:	fbe5                	bnez	a5,148 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 15a:	0005c503          	lbu	a0,0(a1)
}
 15e:	40a7853b          	subw	a0,a5,a0
 162:	6422                	ld	s0,8(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret

0000000000000168 <strlen>:

uint
strlen(const char *s)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e422                	sd	s0,8(sp)
 16c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16e:	00054783          	lbu	a5,0(a0)
 172:	cf91                	beqz	a5,18e <strlen+0x26>
 174:	0505                	addi	a0,a0,1
 176:	87aa                	mv	a5,a0
 178:	4685                	li	a3,1
 17a:	9e89                	subw	a3,a3,a0
 17c:	00f6853b          	addw	a0,a3,a5
 180:	0785                	addi	a5,a5,1
 182:	fff7c703          	lbu	a4,-1(a5)
 186:	fb7d                	bnez	a4,17c <strlen+0x14>
    ;
  return n;
}
 188:	6422                	ld	s0,8(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret
  for(n = 0; s[n]; n++)
 18e:	4501                	li	a0,0
 190:	bfe5                	j	188 <strlen+0x20>

0000000000000192 <memset>:

void*
memset(void *dst, int c, uint n)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 198:	ce09                	beqz	a2,1b2 <memset+0x20>
 19a:	87aa                	mv	a5,a0
 19c:	fff6071b          	addiw	a4,a2,-1
 1a0:	1702                	slli	a4,a4,0x20
 1a2:	9301                	srli	a4,a4,0x20
 1a4:	0705                	addi	a4,a4,1
 1a6:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1a8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ac:	0785                	addi	a5,a5,1
 1ae:	fee79de3          	bne	a5,a4,1a8 <memset+0x16>
  }
  return dst;
}
 1b2:	6422                	ld	s0,8(sp)
 1b4:	0141                	addi	sp,sp,16
 1b6:	8082                	ret

00000000000001b8 <strchr>:

char*
strchr(const char *s, char c)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	cb99                	beqz	a5,1d8 <strchr+0x20>
    if(*s == c)
 1c4:	00f58763          	beq	a1,a5,1d2 <strchr+0x1a>
  for(; *s; s++)
 1c8:	0505                	addi	a0,a0,1
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbfd                	bnez	a5,1c4 <strchr+0xc>
      return (char*)s;
  return 0;
 1d0:	4501                	li	a0,0
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret
  return 0;
 1d8:	4501                	li	a0,0
 1da:	bfe5                	j	1d2 <strchr+0x1a>

00000000000001dc <gets>:

char*
gets(char *buf, int max)
{
 1dc:	711d                	addi	sp,sp,-96
 1de:	ec86                	sd	ra,88(sp)
 1e0:	e8a2                	sd	s0,80(sp)
 1e2:	e4a6                	sd	s1,72(sp)
 1e4:	e0ca                	sd	s2,64(sp)
 1e6:	fc4e                	sd	s3,56(sp)
 1e8:	f852                	sd	s4,48(sp)
 1ea:	f456                	sd	s5,40(sp)
 1ec:	f05a                	sd	s6,32(sp)
 1ee:	ec5e                	sd	s7,24(sp)
 1f0:	1080                	addi	s0,sp,96
 1f2:	8baa                	mv	s7,a0
 1f4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f6:	892a                	mv	s2,a0
 1f8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1fa:	4aa9                	li	s5,10
 1fc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1fe:	89a6                	mv	s3,s1
 200:	2485                	addiw	s1,s1,1
 202:	0344d863          	bge	s1,s4,232 <gets+0x56>
    cc = read(0, &c, 1);
 206:	4605                	li	a2,1
 208:	faf40593          	addi	a1,s0,-81
 20c:	4501                	li	a0,0
 20e:	00000097          	auipc	ra,0x0
 212:	1a0080e7          	jalr	416(ra) # 3ae <read>
    if(cc < 1)
 216:	00a05e63          	blez	a0,232 <gets+0x56>
    buf[i++] = c;
 21a:	faf44783          	lbu	a5,-81(s0)
 21e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 222:	01578763          	beq	a5,s5,230 <gets+0x54>
 226:	0905                	addi	s2,s2,1
 228:	fd679be3          	bne	a5,s6,1fe <gets+0x22>
  for(i=0; i+1 < max; ){
 22c:	89a6                	mv	s3,s1
 22e:	a011                	j	232 <gets+0x56>
 230:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 232:	99de                	add	s3,s3,s7
 234:	00098023          	sb	zero,0(s3)
  return buf;
}
 238:	855e                	mv	a0,s7
 23a:	60e6                	ld	ra,88(sp)
 23c:	6446                	ld	s0,80(sp)
 23e:	64a6                	ld	s1,72(sp)
 240:	6906                	ld	s2,64(sp)
 242:	79e2                	ld	s3,56(sp)
 244:	7a42                	ld	s4,48(sp)
 246:	7aa2                	ld	s5,40(sp)
 248:	7b02                	ld	s6,32(sp)
 24a:	6be2                	ld	s7,24(sp)
 24c:	6125                	addi	sp,sp,96
 24e:	8082                	ret

0000000000000250 <stat>:

int
stat(const char *n, struct stat *st)
{
 250:	1101                	addi	sp,sp,-32
 252:	ec06                	sd	ra,24(sp)
 254:	e822                	sd	s0,16(sp)
 256:	e426                	sd	s1,8(sp)
 258:	e04a                	sd	s2,0(sp)
 25a:	1000                	addi	s0,sp,32
 25c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25e:	4581                	li	a1,0
 260:	00000097          	auipc	ra,0x0
 264:	176080e7          	jalr	374(ra) # 3d6 <open>
  if(fd < 0)
 268:	02054563          	bltz	a0,292 <stat+0x42>
 26c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 26e:	85ca                	mv	a1,s2
 270:	00000097          	auipc	ra,0x0
 274:	17e080e7          	jalr	382(ra) # 3ee <fstat>
 278:	892a                	mv	s2,a0
  close(fd);
 27a:	8526                	mv	a0,s1
 27c:	00000097          	auipc	ra,0x0
 280:	142080e7          	jalr	322(ra) # 3be <close>
  return r;
}
 284:	854a                	mv	a0,s2
 286:	60e2                	ld	ra,24(sp)
 288:	6442                	ld	s0,16(sp)
 28a:	64a2                	ld	s1,8(sp)
 28c:	6902                	ld	s2,0(sp)
 28e:	6105                	addi	sp,sp,32
 290:	8082                	ret
    return -1;
 292:	597d                	li	s2,-1
 294:	bfc5                	j	284 <stat+0x34>

0000000000000296 <atoi>:

int
atoi(const char *s)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29c:	00054603          	lbu	a2,0(a0)
 2a0:	fd06079b          	addiw	a5,a2,-48
 2a4:	0ff7f793          	andi	a5,a5,255
 2a8:	4725                	li	a4,9
 2aa:	02f76963          	bltu	a4,a5,2dc <atoi+0x46>
 2ae:	86aa                	mv	a3,a0
  n = 0;
 2b0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2b2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2b4:	0685                	addi	a3,a3,1
 2b6:	0025179b          	slliw	a5,a0,0x2
 2ba:	9fa9                	addw	a5,a5,a0
 2bc:	0017979b          	slliw	a5,a5,0x1
 2c0:	9fb1                	addw	a5,a5,a2
 2c2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c6:	0006c603          	lbu	a2,0(a3)
 2ca:	fd06071b          	addiw	a4,a2,-48
 2ce:	0ff77713          	andi	a4,a4,255
 2d2:	fee5f1e3          	bgeu	a1,a4,2b4 <atoi+0x1e>
  return n;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  n = 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <atoi+0x40>

00000000000002e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e6:	02b57663          	bgeu	a0,a1,312 <memmove+0x32>
    while(n-- > 0)
 2ea:	02c05163          	blez	a2,30c <memmove+0x2c>
 2ee:	fff6079b          	addiw	a5,a2,-1
 2f2:	1782                	slli	a5,a5,0x20
 2f4:	9381                	srli	a5,a5,0x20
 2f6:	0785                	addi	a5,a5,1
 2f8:	97aa                	add	a5,a5,a0
  dst = vdst;
 2fa:	872a                	mv	a4,a0
      *dst++ = *src++;
 2fc:	0585                	addi	a1,a1,1
 2fe:	0705                	addi	a4,a4,1
 300:	fff5c683          	lbu	a3,-1(a1)
 304:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 308:	fee79ae3          	bne	a5,a4,2fc <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret
    dst += n;
 312:	00c50733          	add	a4,a0,a2
    src += n;
 316:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 318:	fec05ae3          	blez	a2,30c <memmove+0x2c>
 31c:	fff6079b          	addiw	a5,a2,-1
 320:	1782                	slli	a5,a5,0x20
 322:	9381                	srli	a5,a5,0x20
 324:	fff7c793          	not	a5,a5
 328:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 32a:	15fd                	addi	a1,a1,-1
 32c:	177d                	addi	a4,a4,-1
 32e:	0005c683          	lbu	a3,0(a1)
 332:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 336:	fee79ae3          	bne	a5,a4,32a <memmove+0x4a>
 33a:	bfc9                	j	30c <memmove+0x2c>

000000000000033c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e422                	sd	s0,8(sp)
 340:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 342:	ca05                	beqz	a2,372 <memcmp+0x36>
 344:	fff6069b          	addiw	a3,a2,-1
 348:	1682                	slli	a3,a3,0x20
 34a:	9281                	srli	a3,a3,0x20
 34c:	0685                	addi	a3,a3,1
 34e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 350:	00054783          	lbu	a5,0(a0)
 354:	0005c703          	lbu	a4,0(a1)
 358:	00e79863          	bne	a5,a4,368 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 35c:	0505                	addi	a0,a0,1
    p2++;
 35e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 360:	fed518e3          	bne	a0,a3,350 <memcmp+0x14>
  }
  return 0;
 364:	4501                	li	a0,0
 366:	a019                	j	36c <memcmp+0x30>
      return *p1 - *p2;
 368:	40e7853b          	subw	a0,a5,a4
}
 36c:	6422                	ld	s0,8(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret
  return 0;
 372:	4501                	li	a0,0
 374:	bfe5                	j	36c <memcmp+0x30>

0000000000000376 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 376:	1141                	addi	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 37e:	00000097          	auipc	ra,0x0
 382:	f62080e7          	jalr	-158(ra) # 2e0 <memmove>
}
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret

000000000000038e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38e:	4885                	li	a7,1
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <exit>:
.global exit
exit:
 li a7, SYS_exit
 396:	4889                	li	a7,2
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <wait>:
.global wait
wait:
 li a7, SYS_wait
 39e:	488d                	li	a7,3
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a6:	4891                	li	a7,4
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <read>:
.global read
read:
 li a7, SYS_read
 3ae:	4895                	li	a7,5
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <write>:
.global write
write:
 li a7, SYS_write
 3b6:	48c1                	li	a7,16
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <close>:
.global close
close:
 li a7, SYS_close
 3be:	48d5                	li	a7,21
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c6:	4899                	li	a7,6
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ce:	489d                	li	a7,7
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <open>:
.global open
open:
 li a7, SYS_open
 3d6:	48bd                	li	a7,15
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3de:	48c5                	li	a7,17
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e6:	48c9                	li	a7,18
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ee:	48a1                	li	a7,8
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <link>:
.global link
link:
 li a7, SYS_link
 3f6:	48cd                	li	a7,19
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fe:	48d1                	li	a7,20
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 406:	48a5                	li	a7,9
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <dup>:
.global dup
dup:
 li a7, SYS_dup
 40e:	48a9                	li	a7,10
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 416:	48ad                	li	a7,11
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 41e:	48b1                	li	a7,12
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 426:	48b5                	li	a7,13
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42e:	48b9                	li	a7,14
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <trace>:
.global trace
trace:
 li a7, SYS_trace
 436:	48d9                	li	a7,22
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 43e:	48dd                	li	a7,23
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 446:	1101                	addi	sp,sp,-32
 448:	ec06                	sd	ra,24(sp)
 44a:	e822                	sd	s0,16(sp)
 44c:	1000                	addi	s0,sp,32
 44e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 452:	4605                	li	a2,1
 454:	fef40593          	addi	a1,s0,-17
 458:	00000097          	auipc	ra,0x0
 45c:	f5e080e7          	jalr	-162(ra) # 3b6 <write>
}
 460:	60e2                	ld	ra,24(sp)
 462:	6442                	ld	s0,16(sp)
 464:	6105                	addi	sp,sp,32
 466:	8082                	ret

0000000000000468 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 468:	7139                	addi	sp,sp,-64
 46a:	fc06                	sd	ra,56(sp)
 46c:	f822                	sd	s0,48(sp)
 46e:	f426                	sd	s1,40(sp)
 470:	f04a                	sd	s2,32(sp)
 472:	ec4e                	sd	s3,24(sp)
 474:	0080                	addi	s0,sp,64
 476:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 478:	c299                	beqz	a3,47e <printint+0x16>
 47a:	0805c863          	bltz	a1,50a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 47e:	2581                	sext.w	a1,a1
  neg = 0;
 480:	4881                	li	a7,0
 482:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 486:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 488:	2601                	sext.w	a2,a2
 48a:	00000517          	auipc	a0,0x0
 48e:	43e50513          	addi	a0,a0,1086 # 8c8 <digits>
 492:	883a                	mv	a6,a4
 494:	2705                	addiw	a4,a4,1
 496:	02c5f7bb          	remuw	a5,a1,a2
 49a:	1782                	slli	a5,a5,0x20
 49c:	9381                	srli	a5,a5,0x20
 49e:	97aa                	add	a5,a5,a0
 4a0:	0007c783          	lbu	a5,0(a5)
 4a4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a8:	0005879b          	sext.w	a5,a1
 4ac:	02c5d5bb          	divuw	a1,a1,a2
 4b0:	0685                	addi	a3,a3,1
 4b2:	fec7f0e3          	bgeu	a5,a2,492 <printint+0x2a>
  if(neg)
 4b6:	00088b63          	beqz	a7,4cc <printint+0x64>
    buf[i++] = '-';
 4ba:	fd040793          	addi	a5,s0,-48
 4be:	973e                	add	a4,a4,a5
 4c0:	02d00793          	li	a5,45
 4c4:	fef70823          	sb	a5,-16(a4)
 4c8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4cc:	02e05863          	blez	a4,4fc <printint+0x94>
 4d0:	fc040793          	addi	a5,s0,-64
 4d4:	00e78933          	add	s2,a5,a4
 4d8:	fff78993          	addi	s3,a5,-1
 4dc:	99ba                	add	s3,s3,a4
 4de:	377d                	addiw	a4,a4,-1
 4e0:	1702                	slli	a4,a4,0x20
 4e2:	9301                	srli	a4,a4,0x20
 4e4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e8:	fff94583          	lbu	a1,-1(s2)
 4ec:	8526                	mv	a0,s1
 4ee:	00000097          	auipc	ra,0x0
 4f2:	f58080e7          	jalr	-168(ra) # 446 <putc>
  while(--i >= 0)
 4f6:	197d                	addi	s2,s2,-1
 4f8:	ff3918e3          	bne	s2,s3,4e8 <printint+0x80>
}
 4fc:	70e2                	ld	ra,56(sp)
 4fe:	7442                	ld	s0,48(sp)
 500:	74a2                	ld	s1,40(sp)
 502:	7902                	ld	s2,32(sp)
 504:	69e2                	ld	s3,24(sp)
 506:	6121                	addi	sp,sp,64
 508:	8082                	ret
    x = -xx;
 50a:	40b005bb          	negw	a1,a1
    neg = 1;
 50e:	4885                	li	a7,1
    x = -xx;
 510:	bf8d                	j	482 <printint+0x1a>

0000000000000512 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 512:	7119                	addi	sp,sp,-128
 514:	fc86                	sd	ra,120(sp)
 516:	f8a2                	sd	s0,112(sp)
 518:	f4a6                	sd	s1,104(sp)
 51a:	f0ca                	sd	s2,96(sp)
 51c:	ecce                	sd	s3,88(sp)
 51e:	e8d2                	sd	s4,80(sp)
 520:	e4d6                	sd	s5,72(sp)
 522:	e0da                	sd	s6,64(sp)
 524:	fc5e                	sd	s7,56(sp)
 526:	f862                	sd	s8,48(sp)
 528:	f466                	sd	s9,40(sp)
 52a:	f06a                	sd	s10,32(sp)
 52c:	ec6e                	sd	s11,24(sp)
 52e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 530:	0005c903          	lbu	s2,0(a1)
 534:	18090f63          	beqz	s2,6d2 <vprintf+0x1c0>
 538:	8aaa                	mv	s5,a0
 53a:	8b32                	mv	s6,a2
 53c:	00158493          	addi	s1,a1,1
  state = 0;
 540:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 542:	02500a13          	li	s4,37
      if(c == 'd'){
 546:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 54a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 54e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 552:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 556:	00000b97          	auipc	s7,0x0
 55a:	372b8b93          	addi	s7,s7,882 # 8c8 <digits>
 55e:	a839                	j	57c <vprintf+0x6a>
        putc(fd, c);
 560:	85ca                	mv	a1,s2
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	ee2080e7          	jalr	-286(ra) # 446 <putc>
 56c:	a019                	j	572 <vprintf+0x60>
    } else if(state == '%'){
 56e:	01498f63          	beq	s3,s4,58c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 572:	0485                	addi	s1,s1,1
 574:	fff4c903          	lbu	s2,-1(s1)
 578:	14090d63          	beqz	s2,6d2 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 57c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 580:	fe0997e3          	bnez	s3,56e <vprintf+0x5c>
      if(c == '%'){
 584:	fd479ee3          	bne	a5,s4,560 <vprintf+0x4e>
        state = '%';
 588:	89be                	mv	s3,a5
 58a:	b7e5                	j	572 <vprintf+0x60>
      if(c == 'd'){
 58c:	05878063          	beq	a5,s8,5cc <vprintf+0xba>
      } else if(c == 'l') {
 590:	05978c63          	beq	a5,s9,5e8 <vprintf+0xd6>
      } else if(c == 'x') {
 594:	07a78863          	beq	a5,s10,604 <vprintf+0xf2>
      } else if(c == 'p') {
 598:	09b78463          	beq	a5,s11,620 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 59c:	07300713          	li	a4,115
 5a0:	0ce78663          	beq	a5,a4,66c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a4:	06300713          	li	a4,99
 5a8:	0ee78e63          	beq	a5,a4,6a4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5ac:	11478863          	beq	a5,s4,6bc <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b0:	85d2                	mv	a1,s4
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	e92080e7          	jalr	-366(ra) # 446 <putc>
        putc(fd, c);
 5bc:	85ca                	mv	a1,s2
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e86080e7          	jalr	-378(ra) # 446 <putc>
      }
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	b765                	j	572 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5cc:	008b0913          	addi	s2,s6,8
 5d0:	4685                	li	a3,1
 5d2:	4629                	li	a2,10
 5d4:	000b2583          	lw	a1,0(s6)
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	e8e080e7          	jalr	-370(ra) # 468 <printint>
 5e2:	8b4a                	mv	s6,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b771                	j	572 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e8:	008b0913          	addi	s2,s6,8
 5ec:	4681                	li	a3,0
 5ee:	4629                	li	a2,10
 5f0:	000b2583          	lw	a1,0(s6)
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	e72080e7          	jalr	-398(ra) # 468 <printint>
 5fe:	8b4a                	mv	s6,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	bf85                	j	572 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 604:	008b0913          	addi	s2,s6,8
 608:	4681                	li	a3,0
 60a:	4641                	li	a2,16
 60c:	000b2583          	lw	a1,0(s6)
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	e56080e7          	jalr	-426(ra) # 468 <printint>
 61a:	8b4a                	mv	s6,s2
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bf91                	j	572 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 620:	008b0793          	addi	a5,s6,8
 624:	f8f43423          	sd	a5,-120(s0)
 628:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 62c:	03000593          	li	a1,48
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	e14080e7          	jalr	-492(ra) # 446 <putc>
  putc(fd, 'x');
 63a:	85ea                	mv	a1,s10
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	e08080e7          	jalr	-504(ra) # 446 <putc>
 646:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 648:	03c9d793          	srli	a5,s3,0x3c
 64c:	97de                	add	a5,a5,s7
 64e:	0007c583          	lbu	a1,0(a5)
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	df2080e7          	jalr	-526(ra) # 446 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65c:	0992                	slli	s3,s3,0x4
 65e:	397d                	addiw	s2,s2,-1
 660:	fe0914e3          	bnez	s2,648 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 664:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 668:	4981                	li	s3,0
 66a:	b721                	j	572 <vprintf+0x60>
        s = va_arg(ap, char*);
 66c:	008b0993          	addi	s3,s6,8
 670:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 674:	02090163          	beqz	s2,696 <vprintf+0x184>
        while(*s != 0){
 678:	00094583          	lbu	a1,0(s2)
 67c:	c9a1                	beqz	a1,6cc <vprintf+0x1ba>
          putc(fd, *s);
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	dc6080e7          	jalr	-570(ra) # 446 <putc>
          s++;
 688:	0905                	addi	s2,s2,1
        while(*s != 0){
 68a:	00094583          	lbu	a1,0(s2)
 68e:	f9e5                	bnez	a1,67e <vprintf+0x16c>
        s = va_arg(ap, char*);
 690:	8b4e                	mv	s6,s3
      state = 0;
 692:	4981                	li	s3,0
 694:	bdf9                	j	572 <vprintf+0x60>
          s = "(null)";
 696:	00000917          	auipc	s2,0x0
 69a:	22a90913          	addi	s2,s2,554 # 8c0 <malloc+0xe4>
        while(*s != 0){
 69e:	02800593          	li	a1,40
 6a2:	bff1                	j	67e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6a4:	008b0913          	addi	s2,s6,8
 6a8:	000b4583          	lbu	a1,0(s6)
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	d98080e7          	jalr	-616(ra) # 446 <putc>
 6b6:	8b4a                	mv	s6,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bd65                	j	572 <vprintf+0x60>
        putc(fd, c);
 6bc:	85d2                	mv	a1,s4
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	d86080e7          	jalr	-634(ra) # 446 <putc>
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b565                	j	572 <vprintf+0x60>
        s = va_arg(ap, char*);
 6cc:	8b4e                	mv	s6,s3
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	b54d                	j	572 <vprintf+0x60>
    }
  }
}
 6d2:	70e6                	ld	ra,120(sp)
 6d4:	7446                	ld	s0,112(sp)
 6d6:	74a6                	ld	s1,104(sp)
 6d8:	7906                	ld	s2,96(sp)
 6da:	69e6                	ld	s3,88(sp)
 6dc:	6a46                	ld	s4,80(sp)
 6de:	6aa6                	ld	s5,72(sp)
 6e0:	6b06                	ld	s6,64(sp)
 6e2:	7be2                	ld	s7,56(sp)
 6e4:	7c42                	ld	s8,48(sp)
 6e6:	7ca2                	ld	s9,40(sp)
 6e8:	7d02                	ld	s10,32(sp)
 6ea:	6de2                	ld	s11,24(sp)
 6ec:	6109                	addi	sp,sp,128
 6ee:	8082                	ret

00000000000006f0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f0:	715d                	addi	sp,sp,-80
 6f2:	ec06                	sd	ra,24(sp)
 6f4:	e822                	sd	s0,16(sp)
 6f6:	1000                	addi	s0,sp,32
 6f8:	e010                	sd	a2,0(s0)
 6fa:	e414                	sd	a3,8(s0)
 6fc:	e818                	sd	a4,16(s0)
 6fe:	ec1c                	sd	a5,24(s0)
 700:	03043023          	sd	a6,32(s0)
 704:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 708:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70c:	8622                	mv	a2,s0
 70e:	00000097          	auipc	ra,0x0
 712:	e04080e7          	jalr	-508(ra) # 512 <vprintf>
}
 716:	60e2                	ld	ra,24(sp)
 718:	6442                	ld	s0,16(sp)
 71a:	6161                	addi	sp,sp,80
 71c:	8082                	ret

000000000000071e <printf>:

void
printf(const char *fmt, ...)
{
 71e:	711d                	addi	sp,sp,-96
 720:	ec06                	sd	ra,24(sp)
 722:	e822                	sd	s0,16(sp)
 724:	1000                	addi	s0,sp,32
 726:	e40c                	sd	a1,8(s0)
 728:	e810                	sd	a2,16(s0)
 72a:	ec14                	sd	a3,24(s0)
 72c:	f018                	sd	a4,32(s0)
 72e:	f41c                	sd	a5,40(s0)
 730:	03043823          	sd	a6,48(s0)
 734:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 738:	00840613          	addi	a2,s0,8
 73c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 740:	85aa                	mv	a1,a0
 742:	4505                	li	a0,1
 744:	00000097          	auipc	ra,0x0
 748:	dce080e7          	jalr	-562(ra) # 512 <vprintf>
}
 74c:	60e2                	ld	ra,24(sp)
 74e:	6442                	ld	s0,16(sp)
 750:	6125                	addi	sp,sp,96
 752:	8082                	ret

0000000000000754 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 754:	1141                	addi	sp,sp,-16
 756:	e422                	sd	s0,8(sp)
 758:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	00001797          	auipc	a5,0x1
 762:	8a27b783          	ld	a5,-1886(a5) # 1000 <freep>
 766:	a805                	j	796 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 768:	4618                	lw	a4,8(a2)
 76a:	9db9                	addw	a1,a1,a4
 76c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 770:	6398                	ld	a4,0(a5)
 772:	6318                	ld	a4,0(a4)
 774:	fee53823          	sd	a4,-16(a0)
 778:	a091                	j	7bc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 77a:	ff852703          	lw	a4,-8(a0)
 77e:	9e39                	addw	a2,a2,a4
 780:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 782:	ff053703          	ld	a4,-16(a0)
 786:	e398                	sd	a4,0(a5)
 788:	a099                	j	7ce <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78a:	6398                	ld	a4,0(a5)
 78c:	00e7e463          	bltu	a5,a4,794 <free+0x40>
 790:	00e6ea63          	bltu	a3,a4,7a4 <free+0x50>
{
 794:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 796:	fed7fae3          	bgeu	a5,a3,78a <free+0x36>
 79a:	6398                	ld	a4,0(a5)
 79c:	00e6e463          	bltu	a3,a4,7a4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a0:	fee7eae3          	bltu	a5,a4,794 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7a4:	ff852583          	lw	a1,-8(a0)
 7a8:	6390                	ld	a2,0(a5)
 7aa:	02059713          	slli	a4,a1,0x20
 7ae:	9301                	srli	a4,a4,0x20
 7b0:	0712                	slli	a4,a4,0x4
 7b2:	9736                	add	a4,a4,a3
 7b4:	fae60ae3          	beq	a2,a4,768 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7b8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7bc:	4790                	lw	a2,8(a5)
 7be:	02061713          	slli	a4,a2,0x20
 7c2:	9301                	srli	a4,a4,0x20
 7c4:	0712                	slli	a4,a4,0x4
 7c6:	973e                	add	a4,a4,a5
 7c8:	fae689e3          	beq	a3,a4,77a <free+0x26>
  } else
    p->s.ptr = bp;
 7cc:	e394                	sd	a3,0(a5)
  freep = p;
 7ce:	00001717          	auipc	a4,0x1
 7d2:	82f73923          	sd	a5,-1998(a4) # 1000 <freep>
}
 7d6:	6422                	ld	s0,8(sp)
 7d8:	0141                	addi	sp,sp,16
 7da:	8082                	ret

00000000000007dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7dc:	7139                	addi	sp,sp,-64
 7de:	fc06                	sd	ra,56(sp)
 7e0:	f822                	sd	s0,48(sp)
 7e2:	f426                	sd	s1,40(sp)
 7e4:	f04a                	sd	s2,32(sp)
 7e6:	ec4e                	sd	s3,24(sp)
 7e8:	e852                	sd	s4,16(sp)
 7ea:	e456                	sd	s5,8(sp)
 7ec:	e05a                	sd	s6,0(sp)
 7ee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f0:	02051493          	slli	s1,a0,0x20
 7f4:	9081                	srli	s1,s1,0x20
 7f6:	04bd                	addi	s1,s1,15
 7f8:	8091                	srli	s1,s1,0x4
 7fa:	0014899b          	addiw	s3,s1,1
 7fe:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 800:	00001517          	auipc	a0,0x1
 804:	80053503          	ld	a0,-2048(a0) # 1000 <freep>
 808:	c515                	beqz	a0,834 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80c:	4798                	lw	a4,8(a5)
 80e:	02977f63          	bgeu	a4,s1,84c <malloc+0x70>
 812:	8a4e                	mv	s4,s3
 814:	0009871b          	sext.w	a4,s3
 818:	6685                	lui	a3,0x1
 81a:	00d77363          	bgeu	a4,a3,820 <malloc+0x44>
 81e:	6a05                	lui	s4,0x1
 820:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 824:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 828:	00000917          	auipc	s2,0x0
 82c:	7d890913          	addi	s2,s2,2008 # 1000 <freep>
  if(p == (char*)-1)
 830:	5afd                	li	s5,-1
 832:	a88d                	j	8a4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 834:	00000797          	auipc	a5,0x0
 838:	7dc78793          	addi	a5,a5,2012 # 1010 <base>
 83c:	00000717          	auipc	a4,0x0
 840:	7cf73223          	sd	a5,1988(a4) # 1000 <freep>
 844:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 846:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84a:	b7e1                	j	812 <malloc+0x36>
      if(p->s.size == nunits)
 84c:	02e48b63          	beq	s1,a4,882 <malloc+0xa6>
        p->s.size -= nunits;
 850:	4137073b          	subw	a4,a4,s3
 854:	c798                	sw	a4,8(a5)
        p += p->s.size;
 856:	1702                	slli	a4,a4,0x20
 858:	9301                	srli	a4,a4,0x20
 85a:	0712                	slli	a4,a4,0x4
 85c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 85e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 862:	00000717          	auipc	a4,0x0
 866:	78a73f23          	sd	a0,1950(a4) # 1000 <freep>
      return (void*)(p + 1);
 86a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 86e:	70e2                	ld	ra,56(sp)
 870:	7442                	ld	s0,48(sp)
 872:	74a2                	ld	s1,40(sp)
 874:	7902                	ld	s2,32(sp)
 876:	69e2                	ld	s3,24(sp)
 878:	6a42                	ld	s4,16(sp)
 87a:	6aa2                	ld	s5,8(sp)
 87c:	6b02                	ld	s6,0(sp)
 87e:	6121                	addi	sp,sp,64
 880:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 882:	6398                	ld	a4,0(a5)
 884:	e118                	sd	a4,0(a0)
 886:	bff1                	j	862 <malloc+0x86>
  hp->s.size = nu;
 888:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88c:	0541                	addi	a0,a0,16
 88e:	00000097          	auipc	ra,0x0
 892:	ec6080e7          	jalr	-314(ra) # 754 <free>
  return freep;
 896:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 89a:	d971                	beqz	a0,86e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89e:	4798                	lw	a4,8(a5)
 8a0:	fa9776e3          	bgeu	a4,s1,84c <malloc+0x70>
    if(p == freep)
 8a4:	00093703          	ld	a4,0(s2)
 8a8:	853e                	mv	a0,a5
 8aa:	fef719e3          	bne	a4,a5,89c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8ae:	8552                	mv	a0,s4
 8b0:	00000097          	auipc	ra,0x0
 8b4:	b6e080e7          	jalr	-1170(ra) # 41e <sbrk>
  if(p == (char*)-1)
 8b8:	fd5518e3          	bne	a0,s5,888 <malloc+0xac>
        return 0;
 8bc:	4501                	li	a0,0
 8be:	bf45                	j	86e <malloc+0x92>
