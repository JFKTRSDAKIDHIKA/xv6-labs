
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main()
{ 
   0:	7101                	addi	sp,sp,-512
   2:	ff86                	sd	ra,504(sp)
   4:	fba2                	sd	s0,496(sp)
   6:	f7a6                	sd	s1,488(sp)
   8:	f3ca                	sd	s2,480(sp)
   a:	efce                	sd	s3,472(sp)
   c:	ebd2                	sd	s4,464(sp)
   e:	e7d6                	sd	s5,456(sp)
  10:	0400                	addi	s0,sp,512
  int index = 0;
  int p[2];
  pipe(p);
  12:	fb840513          	addi	a0,s0,-72
  16:	00000097          	auipc	ra,0x0
  1a:	60a080e7          	jalr	1546(ra) # 620 <pipe>
  int numbers[34];
  int buffer[34];
  int newnums[34] = {0};
  1e:	08800613          	li	a2,136
  22:	4581                	li	a1,0
  24:	e2040513          	addi	a0,s0,-480
  28:	00000097          	auipc	ra,0x0
  2c:	3e4080e7          	jalr	996(ra) # 40c <memset>
  for(int i = 2; i <= 35; i++){
  30:	f3040713          	addi	a4,s0,-208
  34:	4789                	li	a5,2
  36:	02400693          	li	a3,36
    int index = i - 2;
    numbers[index] = i;
  3a:	c31c                	sw	a5,0(a4)
  for(int i = 2; i <= 35; i++){
  3c:	2785                	addiw	a5,a5,1
  3e:	0711                	addi	a4,a4,4
  40:	fed79de3          	bne	a5,a3,3a <main+0x3a>
  }


if(fork() == 0){//child process1
  44:	00000097          	auipc	ra,0x0
  48:	5c4080e7          	jalr	1476(ra) # 608 <fork>
  4c:	84aa                	mv	s1,a0
  4e:	2e051963          	bnez	a0,340 <main+0x340>
  close(p[1]);
  52:	fbc42503          	lw	a0,-68(s0)
  56:	00000097          	auipc	ra,0x0
  5a:	5e2080e7          	jalr	1506(ra) # 638 <close>
  read(p[0],buffer , 34*sizeof(int));
  5e:	08800613          	li	a2,136
  62:	ea840593          	addi	a1,s0,-344
  66:	fb842503          	lw	a0,-72(s0)
  6a:	00000097          	auipc	ra,0x0
  6e:	5be080e7          	jalr	1470(ra) # 628 <read>
  close(p[0]);
  72:	fb842503          	lw	a0,-72(s0)
  76:	00000097          	auipc	ra,0x0
  7a:	5c2080e7          	jalr	1474(ra) # 638 <close>
  printf("prime %d\n",buffer[0]);
  7e:	ea842583          	lw	a1,-344(s0)
  82:	00001517          	auipc	a0,0x1
  86:	abe50513          	addi	a0,a0,-1346 # b40 <malloc+0xea>
  8a:	00001097          	auipc	ra,0x1
  8e:	90e080e7          	jalr	-1778(ra) # 998 <printf>
  index = 0;
  for(int i = 1; i <= 33; i++){
      if(buffer[i] % buffer[0] != 0 ){
  92:	ea842583          	lw	a1,-344(s0)
  96:	eac40913          	addi	s2,s0,-340
  9a:	f3040613          	addi	a2,s0,-208
  9e:	87ca                	mv	a5,s2
  a0:	a021                	j	a8 <main+0xa8>
  for(int i = 1; i <= 33; i++){
  a2:	0791                	addi	a5,a5,4
  a4:	00c78f63          	beq	a5,a2,c2 <main+0xc2>
      if(buffer[i] % buffer[0] != 0 ){
  a8:	4398                	lw	a4,0(a5)
  aa:	02b766bb          	remw	a3,a4,a1
  ae:	daf5                	beqz	a3,a2 <main+0xa2>
        newnums[index] = buffer[i];
  b0:	00249693          	slli	a3,s1,0x2
  b4:	fc040513          	addi	a0,s0,-64
  b8:	96aa                	add	a3,a3,a0
  ba:	e6e6a023          	sw	a4,-416(a3)
	index ++;
  be:	2485                	addiw	s1,s1,1
  c0:	b7cd                	j	a2 <main+0xa2>
      }
    }
  int p[2];
  pipe(p);
  c2:	e0840513          	addi	a0,s0,-504
  c6:	00000097          	auipc	ra,0x0
  ca:	55a080e7          	jalr	1370(ra) # 620 <pipe>


    if(fork() == 0){//child process2
  ce:	00000097          	auipc	ra,0x0
  d2:	53a080e7          	jalr	1338(ra) # 608 <fork>
  d6:	89aa                	mv	s3,a0
  d8:	22051463          	bnez	a0,300 <main+0x300>
      close(p[1]);
  dc:	e0c42503          	lw	a0,-500(s0)
  e0:	00000097          	auipc	ra,0x0
  e4:	558080e7          	jalr	1368(ra) # 638 <close>
      read(p[0],buffer , 34*sizeof(int));
  e8:	08800613          	li	a2,136
  ec:	ea840593          	addi	a1,s0,-344
  f0:	e0842503          	lw	a0,-504(s0)
  f4:	00000097          	auipc	ra,0x0
  f8:	534080e7          	jalr	1332(ra) # 628 <read>
      close(p[0]);
  fc:	e0842503          	lw	a0,-504(s0)
 100:	00000097          	auipc	ra,0x0
 104:	538080e7          	jalr	1336(ra) # 638 <close>
      printf("prime %d\n", buffer[0]);
 108:	ea842583          	lw	a1,-344(s0)
 10c:	00001517          	auipc	a0,0x1
 110:	a3450513          	addi	a0,a0,-1484 # b40 <malloc+0xea>
 114:	00001097          	auipc	ra,0x1
 118:	884080e7          	jalr	-1916(ra) # 998 <printf>
      index = 0;
      for(int i = 1; i <= 33; i++){
	i = i - 1;
	newnums[i] = 0;
	i = i + 1;
        if(buffer[i] % buffer[0] != 0 ){
 11c:	ea842583          	lw	a1,-344(s0)
 120:	e2040a13          	addi	s4,s0,-480
 124:	ea440493          	addi	s1,s0,-348
 128:	874a                	mv	a4,s2
 12a:	87d2                	mv	a5,s4
 12c:	a029                	j	136 <main+0x136>
      for(int i = 1; i <= 33; i++){
 12e:	0791                	addi	a5,a5,4
 130:	0711                	addi	a4,a4,4
 132:	02978163          	beq	a5,s1,154 <main+0x154>
	newnums[i] = 0;
 136:	0007a023          	sw	zero,0(a5)
        if(buffer[i] % buffer[0] != 0 ){
 13a:	4314                	lw	a3,0(a4)
 13c:	02b6e63b          	remw	a2,a3,a1
 140:	d67d                	beqz	a2,12e <main+0x12e>
	  newnums[index] = buffer[i];
 142:	00299613          	slli	a2,s3,0x2
 146:	fc040513          	addi	a0,s0,-64
 14a:	962a                	add	a2,a2,a0
 14c:	e6d62023          	sw	a3,-416(a2)
          index ++;
 150:	2985                	addiw	s3,s3,1
 152:	bff1                	j	12e <main+0x12e>
        } 
      }
      int p[2];
      pipe(p);
 154:	e1040513          	addi	a0,s0,-496
 158:	00000097          	auipc	ra,0x0
 15c:	4c8080e7          	jalr	1224(ra) # 620 <pipe>


      if(fork() == 0){//child process3
 160:	00000097          	auipc	ra,0x0
 164:	4a8080e7          	jalr	1192(ra) # 608 <fork>
 168:	89aa                	mv	s3,a0
 16a:	14051b63          	bnez	a0,2c0 <main+0x2c0>
        close(p[1]);
 16e:	e1442503          	lw	a0,-492(s0)
 172:	00000097          	auipc	ra,0x0
 176:	4c6080e7          	jalr	1222(ra) # 638 <close>
        read(p[0],buffer , 34*sizeof(int));
 17a:	08800613          	li	a2,136
 17e:	ea840593          	addi	a1,s0,-344
 182:	e1042503          	lw	a0,-496(s0)
 186:	00000097          	auipc	ra,0x0
 18a:	4a2080e7          	jalr	1186(ra) # 628 <read>
	close(p[0]);
 18e:	e1042503          	lw	a0,-496(s0)
 192:	00000097          	auipc	ra,0x0
 196:	4a6080e7          	jalr	1190(ra) # 638 <close>
        printf("prime %d\n", buffer[0]);
 19a:	ea842583          	lw	a1,-344(s0)
 19e:	00001517          	auipc	a0,0x1
 1a2:	9a250513          	addi	a0,a0,-1630 # b40 <malloc+0xea>
 1a6:	00000097          	auipc	ra,0x0
 1aa:	7f2080e7          	jalr	2034(ra) # 998 <printf>
	index = 0;
        for(int i = 1; i <= 33; i++){
          i = i - 1;
          newnums[i] = 0;
          i = i + 1;
          if(buffer[i] % buffer[0] != 0 ){
 1ae:	ea842583          	lw	a1,-344(s0)
 1b2:	874a                	mv	a4,s2
 1b4:	87d2                	mv	a5,s4
 1b6:	a029                	j	1c0 <main+0x1c0>
        for(int i = 1; i <= 33; i++){
 1b8:	0791                	addi	a5,a5,4
 1ba:	0711                	addi	a4,a4,4
 1bc:	02978163          	beq	a5,s1,1de <main+0x1de>
          newnums[i] = 0;
 1c0:	0007a023          	sw	zero,0(a5)
          if(buffer[i] % buffer[0] != 0 ){
 1c4:	4314                	lw	a3,0(a4)
 1c6:	02b6e63b          	remw	a2,a3,a1
 1ca:	d67d                	beqz	a2,1b8 <main+0x1b8>
            newnums[index] = buffer[i];
 1cc:	00299613          	slli	a2,s3,0x2
 1d0:	fc040513          	addi	a0,s0,-64
 1d4:	962a                	add	a2,a2,a0
 1d6:	e6d62023          	sw	a3,-416(a2)
            index ++;
 1da:	2985                	addiw	s3,s3,1
 1dc:	bff1                	j	1b8 <main+0x1b8>
        }
      }
      int p[2];
      pipe(p);
 1de:	e1840513          	addi	a0,s0,-488
 1e2:	00000097          	auipc	ra,0x0
 1e6:	43e080e7          	jalr	1086(ra) # 620 <pipe>

        if(fork() == 0){//child process4
 1ea:	00000097          	auipc	ra,0x0
 1ee:	41e080e7          	jalr	1054(ra) # 608 <fork>
 1f2:	89aa                	mv	s3,a0
 1f4:	e551                	bnez	a0,280 <main+0x280>
	   close(p[1]);
 1f6:	e1c42503          	lw	a0,-484(s0)
 1fa:	00000097          	auipc	ra,0x0
 1fe:	43e080e7          	jalr	1086(ra) # 638 <close>
           read(p[0],buffer , 34*sizeof(int));
 202:	08800613          	li	a2,136
 206:	ea840593          	addi	a1,s0,-344
 20a:	e1842503          	lw	a0,-488(s0)
 20e:	00000097          	auipc	ra,0x0
 212:	41a080e7          	jalr	1050(ra) # 628 <read>
	   close(p[0]);
 216:	e1842503          	lw	a0,-488(s0)
 21a:	00000097          	auipc	ra,0x0
 21e:	41e080e7          	jalr	1054(ra) # 638 <close>
           printf("prime %d\n", buffer[0]);
 222:	ea842583          	lw	a1,-344(s0)
 226:	00001517          	auipc	a0,0x1
 22a:	91a50513          	addi	a0,a0,-1766 # b40 <malloc+0xea>
 22e:	00000097          	auipc	ra,0x0
 232:	76a080e7          	jalr	1898(ra) # 998 <printf>
             i = i - 1;
             newnums[i] = 0;
             i = i + 1;
             if(buffer[i] % buffer[0] != 0 ){
               newnums[index] = buffer[i];
               printf("prime %d\n", newnums[index]);
 236:	00001a97          	auipc	s5,0x1
 23a:	90aa8a93          	addi	s5,s5,-1782 # b40 <malloc+0xea>
 23e:	a029                	j	248 <main+0x248>
           for(int i = 1; i <= 33; i++){
 240:	0a11                	addi	s4,s4,4
 242:	0911                	addi	s2,s2,4
 244:	029a0963          	beq	s4,s1,276 <main+0x276>
             newnums[i] = 0;
 248:	000a2023          	sw	zero,0(s4)
             if(buffer[i] % buffer[0] != 0 ){
 24c:	00092583          	lw	a1,0(s2)
 250:	ea842783          	lw	a5,-344(s0)
 254:	02f5e7bb          	remw	a5,a1,a5
 258:	d7e5                	beqz	a5,240 <main+0x240>
               newnums[index] = buffer[i];
 25a:	00299793          	slli	a5,s3,0x2
 25e:	fc040713          	addi	a4,s0,-64
 262:	97ba                	add	a5,a5,a4
 264:	e6b7a023          	sw	a1,-416(a5)
               printf("prime %d\n", newnums[index]);
 268:	8556                	mv	a0,s5
 26a:	00000097          	auipc	ra,0x0
 26e:	72e080e7          	jalr	1838(ra) # 998 <printf>
               index ++;
 272:	2985                	addiw	s3,s3,1
 274:	b7f1                	j	240 <main+0x240>
        }
	   }



	     exit(0);
 276:	4501                	li	a0,0
 278:	00000097          	auipc	ra,0x0
 27c:	398080e7          	jalr	920(ra) # 610 <exit>
	}else{//child process3
         close(p[0]);
 280:	e1842503          	lw	a0,-488(s0)
 284:	00000097          	auipc	ra,0x0
 288:	3b4080e7          	jalr	948(ra) # 638 <close>
         write(p[1], newnums,4 *  sizeof(newnums));
 28c:	22000613          	li	a2,544
 290:	e2040593          	addi	a1,s0,-480
 294:	e1c42503          	lw	a0,-484(s0)
 298:	00000097          	auipc	ra,0x0
 29c:	398080e7          	jalr	920(ra) # 630 <write>
         close(p[1]);
 2a0:	e1c42503          	lw	a0,-484(s0)
 2a4:	00000097          	auipc	ra,0x0
 2a8:	394080e7          	jalr	916(ra) # 638 <close>
	 wait(0);
 2ac:	4501                	li	a0,0
 2ae:	00000097          	auipc	ra,0x0
 2b2:	36a080e7          	jalr	874(ra) # 618 <wait>
         exit(0);
 2b6:	4501                	li	a0,0
 2b8:	00000097          	auipc	ra,0x0
 2bc:	358080e7          	jalr	856(ra) # 610 <exit>




      }else{//child process 2
         close(p[0]);
 2c0:	e1042503          	lw	a0,-496(s0)
 2c4:	00000097          	auipc	ra,0x0
 2c8:	374080e7          	jalr	884(ra) # 638 <close>
         write(p[1], newnums,4 *  sizeof(newnums));
 2cc:	22000613          	li	a2,544
 2d0:	e2040593          	addi	a1,s0,-480
 2d4:	e1442503          	lw	a0,-492(s0)
 2d8:	00000097          	auipc	ra,0x0
 2dc:	358080e7          	jalr	856(ra) # 630 <write>
         close(p[1]);
 2e0:	e1442503          	lw	a0,-492(s0)
 2e4:	00000097          	auipc	ra,0x0
 2e8:	354080e7          	jalr	852(ra) # 638 <close>
	 wait(0);
 2ec:	4501                	li	a0,0
 2ee:	00000097          	auipc	ra,0x0
 2f2:	32a080e7          	jalr	810(ra) # 618 <wait>
         exit(0);
 2f6:	4501                	li	a0,0
 2f8:	00000097          	auipc	ra,0x0
 2fc:	318080e7          	jalr	792(ra) # 610 <exit>


       
       
     }else{//child process 1
	 close(p[0]);
 300:	e0842503          	lw	a0,-504(s0)
 304:	00000097          	auipc	ra,0x0
 308:	334080e7          	jalr	820(ra) # 638 <close>
	 write(p[1], newnums,4 *  sizeof(newnums)); 
 30c:	22000613          	li	a2,544
 310:	e2040593          	addi	a1,s0,-480
 314:	e0c42503          	lw	a0,-500(s0)
 318:	00000097          	auipc	ra,0x0
 31c:	318080e7          	jalr	792(ra) # 630 <write>
	 close(p[1]);
 320:	e0c42503          	lw	a0,-500(s0)
 324:	00000097          	auipc	ra,0x0
 328:	314080e7          	jalr	788(ra) # 638 <close>
	 wait(0);
 32c:	4501                	li	a0,0
 32e:	00000097          	auipc	ra,0x0
 332:	2ea080e7          	jalr	746(ra) # 618 <wait>
         exit(0);	
 336:	4501                	li	a0,0
 338:	00000097          	auipc	ra,0x0
 33c:	2d8080e7          	jalr	728(ra) # 610 <exit>
       } 


  
}else{//main process
  close(p[0]);
 340:	fb842503          	lw	a0,-72(s0)
 344:	00000097          	auipc	ra,0x0
 348:	2f4080e7          	jalr	756(ra) # 638 <close>
  write(p[1], numbers,4 *  sizeof(numbers));
 34c:	22000613          	li	a2,544
 350:	f3040593          	addi	a1,s0,-208
 354:	fbc42503          	lw	a0,-68(s0)
 358:	00000097          	auipc	ra,0x0
 35c:	2d8080e7          	jalr	728(ra) # 630 <write>
  close(p[1]);
 360:	fbc42503          	lw	a0,-68(s0)
 364:	00000097          	auipc	ra,0x0
 368:	2d4080e7          	jalr	724(ra) # 638 <close>
  wait(0);
 36c:	4501                	li	a0,0
 36e:	00000097          	auipc	ra,0x0
 372:	2aa080e7          	jalr	682(ra) # 618 <wait>
  exit(0);
 376:	4501                	li	a0,0
 378:	00000097          	auipc	ra,0x0
 37c:	298080e7          	jalr	664(ra) # 610 <exit>

0000000000000380 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 380:	1141                	addi	sp,sp,-16
 382:	e406                	sd	ra,8(sp)
 384:	e022                	sd	s0,0(sp)
 386:	0800                	addi	s0,sp,16
  extern int main();
  main();
 388:	00000097          	auipc	ra,0x0
 38c:	c78080e7          	jalr	-904(ra) # 0 <main>
  exit(0);
 390:	4501                	li	a0,0
 392:	00000097          	auipc	ra,0x0
 396:	27e080e7          	jalr	638(ra) # 610 <exit>

000000000000039a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 39a:	1141                	addi	sp,sp,-16
 39c:	e422                	sd	s0,8(sp)
 39e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3a0:	87aa                	mv	a5,a0
 3a2:	0585                	addi	a1,a1,1
 3a4:	0785                	addi	a5,a5,1
 3a6:	fff5c703          	lbu	a4,-1(a1)
 3aa:	fee78fa3          	sb	a4,-1(a5)
 3ae:	fb75                	bnez	a4,3a2 <strcpy+0x8>
    ;
  return os;
}
 3b0:	6422                	ld	s0,8(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret

00000000000003b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e422                	sd	s0,8(sp)
 3ba:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3bc:	00054783          	lbu	a5,0(a0)
 3c0:	cb91                	beqz	a5,3d4 <strcmp+0x1e>
 3c2:	0005c703          	lbu	a4,0(a1)
 3c6:	00f71763          	bne	a4,a5,3d4 <strcmp+0x1e>
    p++, q++;
 3ca:	0505                	addi	a0,a0,1
 3cc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3ce:	00054783          	lbu	a5,0(a0)
 3d2:	fbe5                	bnez	a5,3c2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3d4:	0005c503          	lbu	a0,0(a1)
}
 3d8:	40a7853b          	subw	a0,a5,a0
 3dc:	6422                	ld	s0,8(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret

00000000000003e2 <strlen>:

uint
strlen(const char *s)
{
 3e2:	1141                	addi	sp,sp,-16
 3e4:	e422                	sd	s0,8(sp)
 3e6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3e8:	00054783          	lbu	a5,0(a0)
 3ec:	cf91                	beqz	a5,408 <strlen+0x26>
 3ee:	0505                	addi	a0,a0,1
 3f0:	87aa                	mv	a5,a0
 3f2:	4685                	li	a3,1
 3f4:	9e89                	subw	a3,a3,a0
 3f6:	00f6853b          	addw	a0,a3,a5
 3fa:	0785                	addi	a5,a5,1
 3fc:	fff7c703          	lbu	a4,-1(a5)
 400:	fb7d                	bnez	a4,3f6 <strlen+0x14>
    ;
  return n;
}
 402:	6422                	ld	s0,8(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret
  for(n = 0; s[n]; n++)
 408:	4501                	li	a0,0
 40a:	bfe5                	j	402 <strlen+0x20>

000000000000040c <memset>:

void*
memset(void *dst, int c, uint n)
{
 40c:	1141                	addi	sp,sp,-16
 40e:	e422                	sd	s0,8(sp)
 410:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 412:	ce09                	beqz	a2,42c <memset+0x20>
 414:	87aa                	mv	a5,a0
 416:	fff6071b          	addiw	a4,a2,-1
 41a:	1702                	slli	a4,a4,0x20
 41c:	9301                	srli	a4,a4,0x20
 41e:	0705                	addi	a4,a4,1
 420:	972a                	add	a4,a4,a0
    cdst[i] = c;
 422:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 426:	0785                	addi	a5,a5,1
 428:	fee79de3          	bne	a5,a4,422 <memset+0x16>
  }
  return dst;
}
 42c:	6422                	ld	s0,8(sp)
 42e:	0141                	addi	sp,sp,16
 430:	8082                	ret

0000000000000432 <strchr>:

char*
strchr(const char *s, char c)
{
 432:	1141                	addi	sp,sp,-16
 434:	e422                	sd	s0,8(sp)
 436:	0800                	addi	s0,sp,16
  for(; *s; s++)
 438:	00054783          	lbu	a5,0(a0)
 43c:	cb99                	beqz	a5,452 <strchr+0x20>
    if(*s == c)
 43e:	00f58763          	beq	a1,a5,44c <strchr+0x1a>
  for(; *s; s++)
 442:	0505                	addi	a0,a0,1
 444:	00054783          	lbu	a5,0(a0)
 448:	fbfd                	bnez	a5,43e <strchr+0xc>
      return (char*)s;
  return 0;
 44a:	4501                	li	a0,0
}
 44c:	6422                	ld	s0,8(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret
  return 0;
 452:	4501                	li	a0,0
 454:	bfe5                	j	44c <strchr+0x1a>

0000000000000456 <gets>:

char*
gets(char *buf, int max)
{
 456:	711d                	addi	sp,sp,-96
 458:	ec86                	sd	ra,88(sp)
 45a:	e8a2                	sd	s0,80(sp)
 45c:	e4a6                	sd	s1,72(sp)
 45e:	e0ca                	sd	s2,64(sp)
 460:	fc4e                	sd	s3,56(sp)
 462:	f852                	sd	s4,48(sp)
 464:	f456                	sd	s5,40(sp)
 466:	f05a                	sd	s6,32(sp)
 468:	ec5e                	sd	s7,24(sp)
 46a:	1080                	addi	s0,sp,96
 46c:	8baa                	mv	s7,a0
 46e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 470:	892a                	mv	s2,a0
 472:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 474:	4aa9                	li	s5,10
 476:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 478:	89a6                	mv	s3,s1
 47a:	2485                	addiw	s1,s1,1
 47c:	0344d863          	bge	s1,s4,4ac <gets+0x56>
    cc = read(0, &c, 1);
 480:	4605                	li	a2,1
 482:	faf40593          	addi	a1,s0,-81
 486:	4501                	li	a0,0
 488:	00000097          	auipc	ra,0x0
 48c:	1a0080e7          	jalr	416(ra) # 628 <read>
    if(cc < 1)
 490:	00a05e63          	blez	a0,4ac <gets+0x56>
    buf[i++] = c;
 494:	faf44783          	lbu	a5,-81(s0)
 498:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 49c:	01578763          	beq	a5,s5,4aa <gets+0x54>
 4a0:	0905                	addi	s2,s2,1
 4a2:	fd679be3          	bne	a5,s6,478 <gets+0x22>
  for(i=0; i+1 < max; ){
 4a6:	89a6                	mv	s3,s1
 4a8:	a011                	j	4ac <gets+0x56>
 4aa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4ac:	99de                	add	s3,s3,s7
 4ae:	00098023          	sb	zero,0(s3)
  return buf;
}
 4b2:	855e                	mv	a0,s7
 4b4:	60e6                	ld	ra,88(sp)
 4b6:	6446                	ld	s0,80(sp)
 4b8:	64a6                	ld	s1,72(sp)
 4ba:	6906                	ld	s2,64(sp)
 4bc:	79e2                	ld	s3,56(sp)
 4be:	7a42                	ld	s4,48(sp)
 4c0:	7aa2                	ld	s5,40(sp)
 4c2:	7b02                	ld	s6,32(sp)
 4c4:	6be2                	ld	s7,24(sp)
 4c6:	6125                	addi	sp,sp,96
 4c8:	8082                	ret

00000000000004ca <stat>:

int
stat(const char *n, struct stat *st)
{
 4ca:	1101                	addi	sp,sp,-32
 4cc:	ec06                	sd	ra,24(sp)
 4ce:	e822                	sd	s0,16(sp)
 4d0:	e426                	sd	s1,8(sp)
 4d2:	e04a                	sd	s2,0(sp)
 4d4:	1000                	addi	s0,sp,32
 4d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d8:	4581                	li	a1,0
 4da:	00000097          	auipc	ra,0x0
 4de:	176080e7          	jalr	374(ra) # 650 <open>
  if(fd < 0)
 4e2:	02054563          	bltz	a0,50c <stat+0x42>
 4e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4e8:	85ca                	mv	a1,s2
 4ea:	00000097          	auipc	ra,0x0
 4ee:	17e080e7          	jalr	382(ra) # 668 <fstat>
 4f2:	892a                	mv	s2,a0
  close(fd);
 4f4:	8526                	mv	a0,s1
 4f6:	00000097          	auipc	ra,0x0
 4fa:	142080e7          	jalr	322(ra) # 638 <close>
  return r;
}
 4fe:	854a                	mv	a0,s2
 500:	60e2                	ld	ra,24(sp)
 502:	6442                	ld	s0,16(sp)
 504:	64a2                	ld	s1,8(sp)
 506:	6902                	ld	s2,0(sp)
 508:	6105                	addi	sp,sp,32
 50a:	8082                	ret
    return -1;
 50c:	597d                	li	s2,-1
 50e:	bfc5                	j	4fe <stat+0x34>

0000000000000510 <atoi>:

int
atoi(const char *s)
{
 510:	1141                	addi	sp,sp,-16
 512:	e422                	sd	s0,8(sp)
 514:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 516:	00054603          	lbu	a2,0(a0)
 51a:	fd06079b          	addiw	a5,a2,-48
 51e:	0ff7f793          	andi	a5,a5,255
 522:	4725                	li	a4,9
 524:	02f76963          	bltu	a4,a5,556 <atoi+0x46>
 528:	86aa                	mv	a3,a0
  n = 0;
 52a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 52c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 52e:	0685                	addi	a3,a3,1
 530:	0025179b          	slliw	a5,a0,0x2
 534:	9fa9                	addw	a5,a5,a0
 536:	0017979b          	slliw	a5,a5,0x1
 53a:	9fb1                	addw	a5,a5,a2
 53c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 540:	0006c603          	lbu	a2,0(a3)
 544:	fd06071b          	addiw	a4,a2,-48
 548:	0ff77713          	andi	a4,a4,255
 54c:	fee5f1e3          	bgeu	a1,a4,52e <atoi+0x1e>
  return n;
}
 550:	6422                	ld	s0,8(sp)
 552:	0141                	addi	sp,sp,16
 554:	8082                	ret
  n = 0;
 556:	4501                	li	a0,0
 558:	bfe5                	j	550 <atoi+0x40>

000000000000055a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 55a:	1141                	addi	sp,sp,-16
 55c:	e422                	sd	s0,8(sp)
 55e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 560:	02b57663          	bgeu	a0,a1,58c <memmove+0x32>
    while(n-- > 0)
 564:	02c05163          	blez	a2,586 <memmove+0x2c>
 568:	fff6079b          	addiw	a5,a2,-1
 56c:	1782                	slli	a5,a5,0x20
 56e:	9381                	srli	a5,a5,0x20
 570:	0785                	addi	a5,a5,1
 572:	97aa                	add	a5,a5,a0
  dst = vdst;
 574:	872a                	mv	a4,a0
      *dst++ = *src++;
 576:	0585                	addi	a1,a1,1
 578:	0705                	addi	a4,a4,1
 57a:	fff5c683          	lbu	a3,-1(a1)
 57e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 582:	fee79ae3          	bne	a5,a4,576 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 586:	6422                	ld	s0,8(sp)
 588:	0141                	addi	sp,sp,16
 58a:	8082                	ret
    dst += n;
 58c:	00c50733          	add	a4,a0,a2
    src += n;
 590:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 592:	fec05ae3          	blez	a2,586 <memmove+0x2c>
 596:	fff6079b          	addiw	a5,a2,-1
 59a:	1782                	slli	a5,a5,0x20
 59c:	9381                	srli	a5,a5,0x20
 59e:	fff7c793          	not	a5,a5
 5a2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5a4:	15fd                	addi	a1,a1,-1
 5a6:	177d                	addi	a4,a4,-1
 5a8:	0005c683          	lbu	a3,0(a1)
 5ac:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5b0:	fee79ae3          	bne	a5,a4,5a4 <memmove+0x4a>
 5b4:	bfc9                	j	586 <memmove+0x2c>

00000000000005b6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5b6:	1141                	addi	sp,sp,-16
 5b8:	e422                	sd	s0,8(sp)
 5ba:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5bc:	ca05                	beqz	a2,5ec <memcmp+0x36>
 5be:	fff6069b          	addiw	a3,a2,-1
 5c2:	1682                	slli	a3,a3,0x20
 5c4:	9281                	srli	a3,a3,0x20
 5c6:	0685                	addi	a3,a3,1
 5c8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5ca:	00054783          	lbu	a5,0(a0)
 5ce:	0005c703          	lbu	a4,0(a1)
 5d2:	00e79863          	bne	a5,a4,5e2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5d6:	0505                	addi	a0,a0,1
    p2++;
 5d8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5da:	fed518e3          	bne	a0,a3,5ca <memcmp+0x14>
  }
  return 0;
 5de:	4501                	li	a0,0
 5e0:	a019                	j	5e6 <memcmp+0x30>
      return *p1 - *p2;
 5e2:	40e7853b          	subw	a0,a5,a4
}
 5e6:	6422                	ld	s0,8(sp)
 5e8:	0141                	addi	sp,sp,16
 5ea:	8082                	ret
  return 0;
 5ec:	4501                	li	a0,0
 5ee:	bfe5                	j	5e6 <memcmp+0x30>

00000000000005f0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5f0:	1141                	addi	sp,sp,-16
 5f2:	e406                	sd	ra,8(sp)
 5f4:	e022                	sd	s0,0(sp)
 5f6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 5f8:	00000097          	auipc	ra,0x0
 5fc:	f62080e7          	jalr	-158(ra) # 55a <memmove>
}
 600:	60a2                	ld	ra,8(sp)
 602:	6402                	ld	s0,0(sp)
 604:	0141                	addi	sp,sp,16
 606:	8082                	ret

0000000000000608 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 608:	4885                	li	a7,1
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <exit>:
.global exit
exit:
 li a7, SYS_exit
 610:	4889                	li	a7,2
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <wait>:
.global wait
wait:
 li a7, SYS_wait
 618:	488d                	li	a7,3
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 620:	4891                	li	a7,4
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <read>:
.global read
read:
 li a7, SYS_read
 628:	4895                	li	a7,5
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <write>:
.global write
write:
 li a7, SYS_write
 630:	48c1                	li	a7,16
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <close>:
.global close
close:
 li a7, SYS_close
 638:	48d5                	li	a7,21
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <kill>:
.global kill
kill:
 li a7, SYS_kill
 640:	4899                	li	a7,6
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <exec>:
.global exec
exec:
 li a7, SYS_exec
 648:	489d                	li	a7,7
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <open>:
.global open
open:
 li a7, SYS_open
 650:	48bd                	li	a7,15
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 658:	48c5                	li	a7,17
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 660:	48c9                	li	a7,18
 ecall
 662:	00000073          	ecall
 ret
 666:	8082                	ret

0000000000000668 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 668:	48a1                	li	a7,8
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <link>:
.global link
link:
 li a7, SYS_link
 670:	48cd                	li	a7,19
 ecall
 672:	00000073          	ecall
 ret
 676:	8082                	ret

0000000000000678 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 678:	48d1                	li	a7,20
 ecall
 67a:	00000073          	ecall
 ret
 67e:	8082                	ret

0000000000000680 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 680:	48a5                	li	a7,9
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <dup>:
.global dup
dup:
 li a7, SYS_dup
 688:	48a9                	li	a7,10
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 690:	48ad                	li	a7,11
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 698:	48b1                	li	a7,12
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6a0:	48b5                	li	a7,13
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6a8:	48b9                	li	a7,14
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <trace>:
.global trace
trace:
 li a7, SYS_trace
 6b0:	48d9                	li	a7,22
 ecall
 6b2:	00000073          	ecall
 ret
 6b6:	8082                	ret

00000000000006b8 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 6b8:	48dd                	li	a7,23
 ecall
 6ba:	00000073          	ecall
 ret
 6be:	8082                	ret

00000000000006c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6c0:	1101                	addi	sp,sp,-32
 6c2:	ec06                	sd	ra,24(sp)
 6c4:	e822                	sd	s0,16(sp)
 6c6:	1000                	addi	s0,sp,32
 6c8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6cc:	4605                	li	a2,1
 6ce:	fef40593          	addi	a1,s0,-17
 6d2:	00000097          	auipc	ra,0x0
 6d6:	f5e080e7          	jalr	-162(ra) # 630 <write>
}
 6da:	60e2                	ld	ra,24(sp)
 6dc:	6442                	ld	s0,16(sp)
 6de:	6105                	addi	sp,sp,32
 6e0:	8082                	ret

00000000000006e2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6e2:	7139                	addi	sp,sp,-64
 6e4:	fc06                	sd	ra,56(sp)
 6e6:	f822                	sd	s0,48(sp)
 6e8:	f426                	sd	s1,40(sp)
 6ea:	f04a                	sd	s2,32(sp)
 6ec:	ec4e                	sd	s3,24(sp)
 6ee:	0080                	addi	s0,sp,64
 6f0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6f2:	c299                	beqz	a3,6f8 <printint+0x16>
 6f4:	0805c863          	bltz	a1,784 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6f8:	2581                	sext.w	a1,a1
  neg = 0;
 6fa:	4881                	li	a7,0
 6fc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 700:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 702:	2601                	sext.w	a2,a2
 704:	00000517          	auipc	a0,0x0
 708:	45450513          	addi	a0,a0,1108 # b58 <digits>
 70c:	883a                	mv	a6,a4
 70e:	2705                	addiw	a4,a4,1
 710:	02c5f7bb          	remuw	a5,a1,a2
 714:	1782                	slli	a5,a5,0x20
 716:	9381                	srli	a5,a5,0x20
 718:	97aa                	add	a5,a5,a0
 71a:	0007c783          	lbu	a5,0(a5)
 71e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 722:	0005879b          	sext.w	a5,a1
 726:	02c5d5bb          	divuw	a1,a1,a2
 72a:	0685                	addi	a3,a3,1
 72c:	fec7f0e3          	bgeu	a5,a2,70c <printint+0x2a>
  if(neg)
 730:	00088b63          	beqz	a7,746 <printint+0x64>
    buf[i++] = '-';
 734:	fd040793          	addi	a5,s0,-48
 738:	973e                	add	a4,a4,a5
 73a:	02d00793          	li	a5,45
 73e:	fef70823          	sb	a5,-16(a4)
 742:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 746:	02e05863          	blez	a4,776 <printint+0x94>
 74a:	fc040793          	addi	a5,s0,-64
 74e:	00e78933          	add	s2,a5,a4
 752:	fff78993          	addi	s3,a5,-1
 756:	99ba                	add	s3,s3,a4
 758:	377d                	addiw	a4,a4,-1
 75a:	1702                	slli	a4,a4,0x20
 75c:	9301                	srli	a4,a4,0x20
 75e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 762:	fff94583          	lbu	a1,-1(s2)
 766:	8526                	mv	a0,s1
 768:	00000097          	auipc	ra,0x0
 76c:	f58080e7          	jalr	-168(ra) # 6c0 <putc>
  while(--i >= 0)
 770:	197d                	addi	s2,s2,-1
 772:	ff3918e3          	bne	s2,s3,762 <printint+0x80>
}
 776:	70e2                	ld	ra,56(sp)
 778:	7442                	ld	s0,48(sp)
 77a:	74a2                	ld	s1,40(sp)
 77c:	7902                	ld	s2,32(sp)
 77e:	69e2                	ld	s3,24(sp)
 780:	6121                	addi	sp,sp,64
 782:	8082                	ret
    x = -xx;
 784:	40b005bb          	negw	a1,a1
    neg = 1;
 788:	4885                	li	a7,1
    x = -xx;
 78a:	bf8d                	j	6fc <printint+0x1a>

000000000000078c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 78c:	7119                	addi	sp,sp,-128
 78e:	fc86                	sd	ra,120(sp)
 790:	f8a2                	sd	s0,112(sp)
 792:	f4a6                	sd	s1,104(sp)
 794:	f0ca                	sd	s2,96(sp)
 796:	ecce                	sd	s3,88(sp)
 798:	e8d2                	sd	s4,80(sp)
 79a:	e4d6                	sd	s5,72(sp)
 79c:	e0da                	sd	s6,64(sp)
 79e:	fc5e                	sd	s7,56(sp)
 7a0:	f862                	sd	s8,48(sp)
 7a2:	f466                	sd	s9,40(sp)
 7a4:	f06a                	sd	s10,32(sp)
 7a6:	ec6e                	sd	s11,24(sp)
 7a8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7aa:	0005c903          	lbu	s2,0(a1)
 7ae:	18090f63          	beqz	s2,94c <vprintf+0x1c0>
 7b2:	8aaa                	mv	s5,a0
 7b4:	8b32                	mv	s6,a2
 7b6:	00158493          	addi	s1,a1,1
  state = 0;
 7ba:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7bc:	02500a13          	li	s4,37
      if(c == 'd'){
 7c0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7c4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 7c8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 7cc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7d0:	00000b97          	auipc	s7,0x0
 7d4:	388b8b93          	addi	s7,s7,904 # b58 <digits>
 7d8:	a839                	j	7f6 <vprintf+0x6a>
        putc(fd, c);
 7da:	85ca                	mv	a1,s2
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	ee2080e7          	jalr	-286(ra) # 6c0 <putc>
 7e6:	a019                	j	7ec <vprintf+0x60>
    } else if(state == '%'){
 7e8:	01498f63          	beq	s3,s4,806 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 7ec:	0485                	addi	s1,s1,1
 7ee:	fff4c903          	lbu	s2,-1(s1)
 7f2:	14090d63          	beqz	s2,94c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 7f6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 7fa:	fe0997e3          	bnez	s3,7e8 <vprintf+0x5c>
      if(c == '%'){
 7fe:	fd479ee3          	bne	a5,s4,7da <vprintf+0x4e>
        state = '%';
 802:	89be                	mv	s3,a5
 804:	b7e5                	j	7ec <vprintf+0x60>
      if(c == 'd'){
 806:	05878063          	beq	a5,s8,846 <vprintf+0xba>
      } else if(c == 'l') {
 80a:	05978c63          	beq	a5,s9,862 <vprintf+0xd6>
      } else if(c == 'x') {
 80e:	07a78863          	beq	a5,s10,87e <vprintf+0xf2>
      } else if(c == 'p') {
 812:	09b78463          	beq	a5,s11,89a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 816:	07300713          	li	a4,115
 81a:	0ce78663          	beq	a5,a4,8e6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 81e:	06300713          	li	a4,99
 822:	0ee78e63          	beq	a5,a4,91e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 826:	11478863          	beq	a5,s4,936 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 82a:	85d2                	mv	a1,s4
 82c:	8556                	mv	a0,s5
 82e:	00000097          	auipc	ra,0x0
 832:	e92080e7          	jalr	-366(ra) # 6c0 <putc>
        putc(fd, c);
 836:	85ca                	mv	a1,s2
 838:	8556                	mv	a0,s5
 83a:	00000097          	auipc	ra,0x0
 83e:	e86080e7          	jalr	-378(ra) # 6c0 <putc>
      }
      state = 0;
 842:	4981                	li	s3,0
 844:	b765                	j	7ec <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 846:	008b0913          	addi	s2,s6,8
 84a:	4685                	li	a3,1
 84c:	4629                	li	a2,10
 84e:	000b2583          	lw	a1,0(s6)
 852:	8556                	mv	a0,s5
 854:	00000097          	auipc	ra,0x0
 858:	e8e080e7          	jalr	-370(ra) # 6e2 <printint>
 85c:	8b4a                	mv	s6,s2
      state = 0;
 85e:	4981                	li	s3,0
 860:	b771                	j	7ec <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 862:	008b0913          	addi	s2,s6,8
 866:	4681                	li	a3,0
 868:	4629                	li	a2,10
 86a:	000b2583          	lw	a1,0(s6)
 86e:	8556                	mv	a0,s5
 870:	00000097          	auipc	ra,0x0
 874:	e72080e7          	jalr	-398(ra) # 6e2 <printint>
 878:	8b4a                	mv	s6,s2
      state = 0;
 87a:	4981                	li	s3,0
 87c:	bf85                	j	7ec <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 87e:	008b0913          	addi	s2,s6,8
 882:	4681                	li	a3,0
 884:	4641                	li	a2,16
 886:	000b2583          	lw	a1,0(s6)
 88a:	8556                	mv	a0,s5
 88c:	00000097          	auipc	ra,0x0
 890:	e56080e7          	jalr	-426(ra) # 6e2 <printint>
 894:	8b4a                	mv	s6,s2
      state = 0;
 896:	4981                	li	s3,0
 898:	bf91                	j	7ec <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 89a:	008b0793          	addi	a5,s6,8
 89e:	f8f43423          	sd	a5,-120(s0)
 8a2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8a6:	03000593          	li	a1,48
 8aa:	8556                	mv	a0,s5
 8ac:	00000097          	auipc	ra,0x0
 8b0:	e14080e7          	jalr	-492(ra) # 6c0 <putc>
  putc(fd, 'x');
 8b4:	85ea                	mv	a1,s10
 8b6:	8556                	mv	a0,s5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	e08080e7          	jalr	-504(ra) # 6c0 <putc>
 8c0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8c2:	03c9d793          	srli	a5,s3,0x3c
 8c6:	97de                	add	a5,a5,s7
 8c8:	0007c583          	lbu	a1,0(a5)
 8cc:	8556                	mv	a0,s5
 8ce:	00000097          	auipc	ra,0x0
 8d2:	df2080e7          	jalr	-526(ra) # 6c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8d6:	0992                	slli	s3,s3,0x4
 8d8:	397d                	addiw	s2,s2,-1
 8da:	fe0914e3          	bnez	s2,8c2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 8de:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	b721                	j	7ec <vprintf+0x60>
        s = va_arg(ap, char*);
 8e6:	008b0993          	addi	s3,s6,8
 8ea:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 8ee:	02090163          	beqz	s2,910 <vprintf+0x184>
        while(*s != 0){
 8f2:	00094583          	lbu	a1,0(s2)
 8f6:	c9a1                	beqz	a1,946 <vprintf+0x1ba>
          putc(fd, *s);
 8f8:	8556                	mv	a0,s5
 8fa:	00000097          	auipc	ra,0x0
 8fe:	dc6080e7          	jalr	-570(ra) # 6c0 <putc>
          s++;
 902:	0905                	addi	s2,s2,1
        while(*s != 0){
 904:	00094583          	lbu	a1,0(s2)
 908:	f9e5                	bnez	a1,8f8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 90a:	8b4e                	mv	s6,s3
      state = 0;
 90c:	4981                	li	s3,0
 90e:	bdf9                	j	7ec <vprintf+0x60>
          s = "(null)";
 910:	00000917          	auipc	s2,0x0
 914:	24090913          	addi	s2,s2,576 # b50 <malloc+0xfa>
        while(*s != 0){
 918:	02800593          	li	a1,40
 91c:	bff1                	j	8f8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 91e:	008b0913          	addi	s2,s6,8
 922:	000b4583          	lbu	a1,0(s6)
 926:	8556                	mv	a0,s5
 928:	00000097          	auipc	ra,0x0
 92c:	d98080e7          	jalr	-616(ra) # 6c0 <putc>
 930:	8b4a                	mv	s6,s2
      state = 0;
 932:	4981                	li	s3,0
 934:	bd65                	j	7ec <vprintf+0x60>
        putc(fd, c);
 936:	85d2                	mv	a1,s4
 938:	8556                	mv	a0,s5
 93a:	00000097          	auipc	ra,0x0
 93e:	d86080e7          	jalr	-634(ra) # 6c0 <putc>
      state = 0;
 942:	4981                	li	s3,0
 944:	b565                	j	7ec <vprintf+0x60>
        s = va_arg(ap, char*);
 946:	8b4e                	mv	s6,s3
      state = 0;
 948:	4981                	li	s3,0
 94a:	b54d                	j	7ec <vprintf+0x60>
    }
  }
}
 94c:	70e6                	ld	ra,120(sp)
 94e:	7446                	ld	s0,112(sp)
 950:	74a6                	ld	s1,104(sp)
 952:	7906                	ld	s2,96(sp)
 954:	69e6                	ld	s3,88(sp)
 956:	6a46                	ld	s4,80(sp)
 958:	6aa6                	ld	s5,72(sp)
 95a:	6b06                	ld	s6,64(sp)
 95c:	7be2                	ld	s7,56(sp)
 95e:	7c42                	ld	s8,48(sp)
 960:	7ca2                	ld	s9,40(sp)
 962:	7d02                	ld	s10,32(sp)
 964:	6de2                	ld	s11,24(sp)
 966:	6109                	addi	sp,sp,128
 968:	8082                	ret

000000000000096a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 96a:	715d                	addi	sp,sp,-80
 96c:	ec06                	sd	ra,24(sp)
 96e:	e822                	sd	s0,16(sp)
 970:	1000                	addi	s0,sp,32
 972:	e010                	sd	a2,0(s0)
 974:	e414                	sd	a3,8(s0)
 976:	e818                	sd	a4,16(s0)
 978:	ec1c                	sd	a5,24(s0)
 97a:	03043023          	sd	a6,32(s0)
 97e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 982:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 986:	8622                	mv	a2,s0
 988:	00000097          	auipc	ra,0x0
 98c:	e04080e7          	jalr	-508(ra) # 78c <vprintf>
}
 990:	60e2                	ld	ra,24(sp)
 992:	6442                	ld	s0,16(sp)
 994:	6161                	addi	sp,sp,80
 996:	8082                	ret

0000000000000998 <printf>:

void
printf(const char *fmt, ...)
{
 998:	711d                	addi	sp,sp,-96
 99a:	ec06                	sd	ra,24(sp)
 99c:	e822                	sd	s0,16(sp)
 99e:	1000                	addi	s0,sp,32
 9a0:	e40c                	sd	a1,8(s0)
 9a2:	e810                	sd	a2,16(s0)
 9a4:	ec14                	sd	a3,24(s0)
 9a6:	f018                	sd	a4,32(s0)
 9a8:	f41c                	sd	a5,40(s0)
 9aa:	03043823          	sd	a6,48(s0)
 9ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9b2:	00840613          	addi	a2,s0,8
 9b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9ba:	85aa                	mv	a1,a0
 9bc:	4505                	li	a0,1
 9be:	00000097          	auipc	ra,0x0
 9c2:	dce080e7          	jalr	-562(ra) # 78c <vprintf>
}
 9c6:	60e2                	ld	ra,24(sp)
 9c8:	6442                	ld	s0,16(sp)
 9ca:	6125                	addi	sp,sp,96
 9cc:	8082                	ret

00000000000009ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9ce:	1141                	addi	sp,sp,-16
 9d0:	e422                	sd	s0,8(sp)
 9d2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9d4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d8:	00000797          	auipc	a5,0x0
 9dc:	6287b783          	ld	a5,1576(a5) # 1000 <freep>
 9e0:	a805                	j	a10 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9e2:	4618                	lw	a4,8(a2)
 9e4:	9db9                	addw	a1,a1,a4
 9e6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9ea:	6398                	ld	a4,0(a5)
 9ec:	6318                	ld	a4,0(a4)
 9ee:	fee53823          	sd	a4,-16(a0)
 9f2:	a091                	j	a36 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9f4:	ff852703          	lw	a4,-8(a0)
 9f8:	9e39                	addw	a2,a2,a4
 9fa:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 9fc:	ff053703          	ld	a4,-16(a0)
 a00:	e398                	sd	a4,0(a5)
 a02:	a099                	j	a48 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a04:	6398                	ld	a4,0(a5)
 a06:	00e7e463          	bltu	a5,a4,a0e <free+0x40>
 a0a:	00e6ea63          	bltu	a3,a4,a1e <free+0x50>
{
 a0e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a10:	fed7fae3          	bgeu	a5,a3,a04 <free+0x36>
 a14:	6398                	ld	a4,0(a5)
 a16:	00e6e463          	bltu	a3,a4,a1e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a1a:	fee7eae3          	bltu	a5,a4,a0e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a1e:	ff852583          	lw	a1,-8(a0)
 a22:	6390                	ld	a2,0(a5)
 a24:	02059713          	slli	a4,a1,0x20
 a28:	9301                	srli	a4,a4,0x20
 a2a:	0712                	slli	a4,a4,0x4
 a2c:	9736                	add	a4,a4,a3
 a2e:	fae60ae3          	beq	a2,a4,9e2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 a32:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a36:	4790                	lw	a2,8(a5)
 a38:	02061713          	slli	a4,a2,0x20
 a3c:	9301                	srli	a4,a4,0x20
 a3e:	0712                	slli	a4,a4,0x4
 a40:	973e                	add	a4,a4,a5
 a42:	fae689e3          	beq	a3,a4,9f4 <free+0x26>
  } else
    p->s.ptr = bp;
 a46:	e394                	sd	a3,0(a5)
  freep = p;
 a48:	00000717          	auipc	a4,0x0
 a4c:	5af73c23          	sd	a5,1464(a4) # 1000 <freep>
}
 a50:	6422                	ld	s0,8(sp)
 a52:	0141                	addi	sp,sp,16
 a54:	8082                	ret

0000000000000a56 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a56:	7139                	addi	sp,sp,-64
 a58:	fc06                	sd	ra,56(sp)
 a5a:	f822                	sd	s0,48(sp)
 a5c:	f426                	sd	s1,40(sp)
 a5e:	f04a                	sd	s2,32(sp)
 a60:	ec4e                	sd	s3,24(sp)
 a62:	e852                	sd	s4,16(sp)
 a64:	e456                	sd	s5,8(sp)
 a66:	e05a                	sd	s6,0(sp)
 a68:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a6a:	02051493          	slli	s1,a0,0x20
 a6e:	9081                	srli	s1,s1,0x20
 a70:	04bd                	addi	s1,s1,15
 a72:	8091                	srli	s1,s1,0x4
 a74:	0014899b          	addiw	s3,s1,1
 a78:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a7a:	00000517          	auipc	a0,0x0
 a7e:	58653503          	ld	a0,1414(a0) # 1000 <freep>
 a82:	c515                	beqz	a0,aae <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a84:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a86:	4798                	lw	a4,8(a5)
 a88:	02977f63          	bgeu	a4,s1,ac6 <malloc+0x70>
 a8c:	8a4e                	mv	s4,s3
 a8e:	0009871b          	sext.w	a4,s3
 a92:	6685                	lui	a3,0x1
 a94:	00d77363          	bgeu	a4,a3,a9a <malloc+0x44>
 a98:	6a05                	lui	s4,0x1
 a9a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a9e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 aa2:	00000917          	auipc	s2,0x0
 aa6:	55e90913          	addi	s2,s2,1374 # 1000 <freep>
  if(p == (char*)-1)
 aaa:	5afd                	li	s5,-1
 aac:	a88d                	j	b1e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 aae:	00000797          	auipc	a5,0x0
 ab2:	56278793          	addi	a5,a5,1378 # 1010 <base>
 ab6:	00000717          	auipc	a4,0x0
 aba:	54f73523          	sd	a5,1354(a4) # 1000 <freep>
 abe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ac0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ac4:	b7e1                	j	a8c <malloc+0x36>
      if(p->s.size == nunits)
 ac6:	02e48b63          	beq	s1,a4,afc <malloc+0xa6>
        p->s.size -= nunits;
 aca:	4137073b          	subw	a4,a4,s3
 ace:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ad0:	1702                	slli	a4,a4,0x20
 ad2:	9301                	srli	a4,a4,0x20
 ad4:	0712                	slli	a4,a4,0x4
 ad6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ad8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 adc:	00000717          	auipc	a4,0x0
 ae0:	52a73223          	sd	a0,1316(a4) # 1000 <freep>
      return (void*)(p + 1);
 ae4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ae8:	70e2                	ld	ra,56(sp)
 aea:	7442                	ld	s0,48(sp)
 aec:	74a2                	ld	s1,40(sp)
 aee:	7902                	ld	s2,32(sp)
 af0:	69e2                	ld	s3,24(sp)
 af2:	6a42                	ld	s4,16(sp)
 af4:	6aa2                	ld	s5,8(sp)
 af6:	6b02                	ld	s6,0(sp)
 af8:	6121                	addi	sp,sp,64
 afa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 afc:	6398                	ld	a4,0(a5)
 afe:	e118                	sd	a4,0(a0)
 b00:	bff1                	j	adc <malloc+0x86>
  hp->s.size = nu;
 b02:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b06:	0541                	addi	a0,a0,16
 b08:	00000097          	auipc	ra,0x0
 b0c:	ec6080e7          	jalr	-314(ra) # 9ce <free>
  return freep;
 b10:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b14:	d971                	beqz	a0,ae8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b16:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b18:	4798                	lw	a4,8(a5)
 b1a:	fa9776e3          	bgeu	a4,s1,ac6 <malloc+0x70>
    if(p == freep)
 b1e:	00093703          	ld	a4,0(s2)
 b22:	853e                	mv	a0,a5
 b24:	fef719e3          	bne	a4,a5,b16 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b28:	8552                	mv	a0,s4
 b2a:	00000097          	auipc	ra,0x0
 b2e:	b6e080e7          	jalr	-1170(ra) # 698 <sbrk>
  if(p == (char*)-1)
 b32:	fd5518e3          	bne	a0,s5,b02 <malloc+0xac>
        return 0;
 b36:	4501                	li	a0,0
 b38:	bf45                	j	ae8 <malloc+0x92>
