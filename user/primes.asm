
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
  1a:	602080e7          	jalr	1538(ra) # 618 <pipe>
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
  48:	5bc080e7          	jalr	1468(ra) # 600 <fork>
  4c:	84aa                	mv	s1,a0
  4e:	2e051963          	bnez	a0,340 <main+0x340>
  close(p[1]);
  52:	fbc42503          	lw	a0,-68(s0)
  56:	00000097          	auipc	ra,0x0
  5a:	5da080e7          	jalr	1498(ra) # 630 <close>
  read(p[0],buffer , 34*sizeof(int));
  5e:	08800613          	li	a2,136
  62:	ea840593          	addi	a1,s0,-344
  66:	fb842503          	lw	a0,-72(s0)
  6a:	00000097          	auipc	ra,0x0
  6e:	5b6080e7          	jalr	1462(ra) # 620 <read>
  close(p[0]);
  72:	fb842503          	lw	a0,-72(s0)
  76:	00000097          	auipc	ra,0x0
  7a:	5ba080e7          	jalr	1466(ra) # 630 <close>
  printf("prime %d\n",buffer[0]);
  7e:	ea842583          	lw	a1,-344(s0)
  82:	00001517          	auipc	a0,0x1
  86:	abe50513          	addi	a0,a0,-1346 # b40 <malloc+0xf2>
  8a:	00001097          	auipc	ra,0x1
  8e:	906080e7          	jalr	-1786(ra) # 990 <printf>
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
  ca:	552080e7          	jalr	1362(ra) # 618 <pipe>


    if(fork() == 0){//child process2
  ce:	00000097          	auipc	ra,0x0
  d2:	532080e7          	jalr	1330(ra) # 600 <fork>
  d6:	89aa                	mv	s3,a0
  d8:	22051463          	bnez	a0,300 <main+0x300>
      close(p[1]);
  dc:	e0c42503          	lw	a0,-500(s0)
  e0:	00000097          	auipc	ra,0x0
  e4:	550080e7          	jalr	1360(ra) # 630 <close>
      read(p[0],buffer , 34*sizeof(int));
  e8:	08800613          	li	a2,136
  ec:	ea840593          	addi	a1,s0,-344
  f0:	e0842503          	lw	a0,-504(s0)
  f4:	00000097          	auipc	ra,0x0
  f8:	52c080e7          	jalr	1324(ra) # 620 <read>
      close(p[0]);
  fc:	e0842503          	lw	a0,-504(s0)
 100:	00000097          	auipc	ra,0x0
 104:	530080e7          	jalr	1328(ra) # 630 <close>
      printf("prime %d\n", buffer[0]);
 108:	ea842583          	lw	a1,-344(s0)
 10c:	00001517          	auipc	a0,0x1
 110:	a3450513          	addi	a0,a0,-1484 # b40 <malloc+0xf2>
 114:	00001097          	auipc	ra,0x1
 118:	87c080e7          	jalr	-1924(ra) # 990 <printf>
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
 15c:	4c0080e7          	jalr	1216(ra) # 618 <pipe>


      if(fork() == 0){//child process3
 160:	00000097          	auipc	ra,0x0
 164:	4a0080e7          	jalr	1184(ra) # 600 <fork>
 168:	89aa                	mv	s3,a0
 16a:	14051b63          	bnez	a0,2c0 <main+0x2c0>
        close(p[1]);
 16e:	e1442503          	lw	a0,-492(s0)
 172:	00000097          	auipc	ra,0x0
 176:	4be080e7          	jalr	1214(ra) # 630 <close>
        read(p[0],buffer , 34*sizeof(int));
 17a:	08800613          	li	a2,136
 17e:	ea840593          	addi	a1,s0,-344
 182:	e1042503          	lw	a0,-496(s0)
 186:	00000097          	auipc	ra,0x0
 18a:	49a080e7          	jalr	1178(ra) # 620 <read>
	close(p[0]);
 18e:	e1042503          	lw	a0,-496(s0)
 192:	00000097          	auipc	ra,0x0
 196:	49e080e7          	jalr	1182(ra) # 630 <close>
        printf("prime %d\n", buffer[0]);
 19a:	ea842583          	lw	a1,-344(s0)
 19e:	00001517          	auipc	a0,0x1
 1a2:	9a250513          	addi	a0,a0,-1630 # b40 <malloc+0xf2>
 1a6:	00000097          	auipc	ra,0x0
 1aa:	7ea080e7          	jalr	2026(ra) # 990 <printf>
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
 1e6:	436080e7          	jalr	1078(ra) # 618 <pipe>

        if(fork() == 0){//child process4
 1ea:	00000097          	auipc	ra,0x0
 1ee:	416080e7          	jalr	1046(ra) # 600 <fork>
 1f2:	89aa                	mv	s3,a0
 1f4:	e551                	bnez	a0,280 <main+0x280>
	   close(p[1]);
 1f6:	e1c42503          	lw	a0,-484(s0)
 1fa:	00000097          	auipc	ra,0x0
 1fe:	436080e7          	jalr	1078(ra) # 630 <close>
           read(p[0],buffer , 34*sizeof(int));
 202:	08800613          	li	a2,136
 206:	ea840593          	addi	a1,s0,-344
 20a:	e1842503          	lw	a0,-488(s0)
 20e:	00000097          	auipc	ra,0x0
 212:	412080e7          	jalr	1042(ra) # 620 <read>
	   close(p[0]);
 216:	e1842503          	lw	a0,-488(s0)
 21a:	00000097          	auipc	ra,0x0
 21e:	416080e7          	jalr	1046(ra) # 630 <close>
           printf("prime %d\n", buffer[0]);
 222:	ea842583          	lw	a1,-344(s0)
 226:	00001517          	auipc	a0,0x1
 22a:	91a50513          	addi	a0,a0,-1766 # b40 <malloc+0xf2>
 22e:	00000097          	auipc	ra,0x0
 232:	762080e7          	jalr	1890(ra) # 990 <printf>
             i = i - 1;
             newnums[i] = 0;
             i = i + 1;
             if(buffer[i] % buffer[0] != 0 ){
               newnums[index] = buffer[i];
               printf("prime %d\n", newnums[index]);
 236:	00001a97          	auipc	s5,0x1
 23a:	90aa8a93          	addi	s5,s5,-1782 # b40 <malloc+0xf2>
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
 26e:	726080e7          	jalr	1830(ra) # 990 <printf>
               index ++;
 272:	2985                	addiw	s3,s3,1
 274:	b7f1                	j	240 <main+0x240>
        }
	   }



	     exit(0);
 276:	4501                	li	a0,0
 278:	00000097          	auipc	ra,0x0
 27c:	390080e7          	jalr	912(ra) # 608 <exit>
	}else{//child process3
         close(p[0]);
 280:	e1842503          	lw	a0,-488(s0)
 284:	00000097          	auipc	ra,0x0
 288:	3ac080e7          	jalr	940(ra) # 630 <close>
         write(p[1], newnums,4 *  sizeof(newnums));
 28c:	22000613          	li	a2,544
 290:	e2040593          	addi	a1,s0,-480
 294:	e1c42503          	lw	a0,-484(s0)
 298:	00000097          	auipc	ra,0x0
 29c:	390080e7          	jalr	912(ra) # 628 <write>
         close(p[1]);
 2a0:	e1c42503          	lw	a0,-484(s0)
 2a4:	00000097          	auipc	ra,0x0
 2a8:	38c080e7          	jalr	908(ra) # 630 <close>
	 wait(0);
 2ac:	4501                	li	a0,0
 2ae:	00000097          	auipc	ra,0x0
 2b2:	362080e7          	jalr	866(ra) # 610 <wait>
         exit(0);
 2b6:	4501                	li	a0,0
 2b8:	00000097          	auipc	ra,0x0
 2bc:	350080e7          	jalr	848(ra) # 608 <exit>




      }else{//child process 2
         close(p[0]);
 2c0:	e1042503          	lw	a0,-496(s0)
 2c4:	00000097          	auipc	ra,0x0
 2c8:	36c080e7          	jalr	876(ra) # 630 <close>
         write(p[1], newnums,4 *  sizeof(newnums));
 2cc:	22000613          	li	a2,544
 2d0:	e2040593          	addi	a1,s0,-480
 2d4:	e1442503          	lw	a0,-492(s0)
 2d8:	00000097          	auipc	ra,0x0
 2dc:	350080e7          	jalr	848(ra) # 628 <write>
         close(p[1]);
 2e0:	e1442503          	lw	a0,-492(s0)
 2e4:	00000097          	auipc	ra,0x0
 2e8:	34c080e7          	jalr	844(ra) # 630 <close>
	 wait(0);
 2ec:	4501                	li	a0,0
 2ee:	00000097          	auipc	ra,0x0
 2f2:	322080e7          	jalr	802(ra) # 610 <wait>
         exit(0);
 2f6:	4501                	li	a0,0
 2f8:	00000097          	auipc	ra,0x0
 2fc:	310080e7          	jalr	784(ra) # 608 <exit>


       
       
     }else{//child process 1
	 close(p[0]);
 300:	e0842503          	lw	a0,-504(s0)
 304:	00000097          	auipc	ra,0x0
 308:	32c080e7          	jalr	812(ra) # 630 <close>
	 write(p[1], newnums,4 *  sizeof(newnums)); 
 30c:	22000613          	li	a2,544
 310:	e2040593          	addi	a1,s0,-480
 314:	e0c42503          	lw	a0,-500(s0)
 318:	00000097          	auipc	ra,0x0
 31c:	310080e7          	jalr	784(ra) # 628 <write>
	 close(p[1]);
 320:	e0c42503          	lw	a0,-500(s0)
 324:	00000097          	auipc	ra,0x0
 328:	30c080e7          	jalr	780(ra) # 630 <close>
	 wait(0);
 32c:	4501                	li	a0,0
 32e:	00000097          	auipc	ra,0x0
 332:	2e2080e7          	jalr	738(ra) # 610 <wait>
         exit(0);	
 336:	4501                	li	a0,0
 338:	00000097          	auipc	ra,0x0
 33c:	2d0080e7          	jalr	720(ra) # 608 <exit>
       } 


  
}else{//main process
  close(p[0]);
 340:	fb842503          	lw	a0,-72(s0)
 344:	00000097          	auipc	ra,0x0
 348:	2ec080e7          	jalr	748(ra) # 630 <close>
  write(p[1], numbers,4 *  sizeof(numbers));
 34c:	22000613          	li	a2,544
 350:	f3040593          	addi	a1,s0,-208
 354:	fbc42503          	lw	a0,-68(s0)
 358:	00000097          	auipc	ra,0x0
 35c:	2d0080e7          	jalr	720(ra) # 628 <write>
  close(p[1]);
 360:	fbc42503          	lw	a0,-68(s0)
 364:	00000097          	auipc	ra,0x0
 368:	2cc080e7          	jalr	716(ra) # 630 <close>
  wait(0);
 36c:	4501                	li	a0,0
 36e:	00000097          	auipc	ra,0x0
 372:	2a2080e7          	jalr	674(ra) # 610 <wait>
  exit(0);
 376:	4501                	li	a0,0
 378:	00000097          	auipc	ra,0x0
 37c:	290080e7          	jalr	656(ra) # 608 <exit>

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
 396:	276080e7          	jalr	630(ra) # 608 <exit>

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
 412:	ca19                	beqz	a2,428 <memset+0x1c>
 414:	87aa                	mv	a5,a0
 416:	1602                	slli	a2,a2,0x20
 418:	9201                	srli	a2,a2,0x20
 41a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 41e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 422:	0785                	addi	a5,a5,1
 424:	fee79de3          	bne	a5,a4,41e <memset+0x12>
  }
  return dst;
}
 428:	6422                	ld	s0,8(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret

000000000000042e <strchr>:

char*
strchr(const char *s, char c)
{
 42e:	1141                	addi	sp,sp,-16
 430:	e422                	sd	s0,8(sp)
 432:	0800                	addi	s0,sp,16
  for(; *s; s++)
 434:	00054783          	lbu	a5,0(a0)
 438:	cb99                	beqz	a5,44e <strchr+0x20>
    if(*s == c)
 43a:	00f58763          	beq	a1,a5,448 <strchr+0x1a>
  for(; *s; s++)
 43e:	0505                	addi	a0,a0,1
 440:	00054783          	lbu	a5,0(a0)
 444:	fbfd                	bnez	a5,43a <strchr+0xc>
      return (char*)s;
  return 0;
 446:	4501                	li	a0,0
}
 448:	6422                	ld	s0,8(sp)
 44a:	0141                	addi	sp,sp,16
 44c:	8082                	ret
  return 0;
 44e:	4501                	li	a0,0
 450:	bfe5                	j	448 <strchr+0x1a>

0000000000000452 <gets>:

char*
gets(char *buf, int max)
{
 452:	711d                	addi	sp,sp,-96
 454:	ec86                	sd	ra,88(sp)
 456:	e8a2                	sd	s0,80(sp)
 458:	e4a6                	sd	s1,72(sp)
 45a:	e0ca                	sd	s2,64(sp)
 45c:	fc4e                	sd	s3,56(sp)
 45e:	f852                	sd	s4,48(sp)
 460:	f456                	sd	s5,40(sp)
 462:	f05a                	sd	s6,32(sp)
 464:	ec5e                	sd	s7,24(sp)
 466:	1080                	addi	s0,sp,96
 468:	8baa                	mv	s7,a0
 46a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 46c:	892a                	mv	s2,a0
 46e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 470:	4aa9                	li	s5,10
 472:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 474:	89a6                	mv	s3,s1
 476:	2485                	addiw	s1,s1,1
 478:	0344d863          	bge	s1,s4,4a8 <gets+0x56>
    cc = read(0, &c, 1);
 47c:	4605                	li	a2,1
 47e:	faf40593          	addi	a1,s0,-81
 482:	4501                	li	a0,0
 484:	00000097          	auipc	ra,0x0
 488:	19c080e7          	jalr	412(ra) # 620 <read>
    if(cc < 1)
 48c:	00a05e63          	blez	a0,4a8 <gets+0x56>
    buf[i++] = c;
 490:	faf44783          	lbu	a5,-81(s0)
 494:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 498:	01578763          	beq	a5,s5,4a6 <gets+0x54>
 49c:	0905                	addi	s2,s2,1
 49e:	fd679be3          	bne	a5,s6,474 <gets+0x22>
  for(i=0; i+1 < max; ){
 4a2:	89a6                	mv	s3,s1
 4a4:	a011                	j	4a8 <gets+0x56>
 4a6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4a8:	99de                	add	s3,s3,s7
 4aa:	00098023          	sb	zero,0(s3)
  return buf;
}
 4ae:	855e                	mv	a0,s7
 4b0:	60e6                	ld	ra,88(sp)
 4b2:	6446                	ld	s0,80(sp)
 4b4:	64a6                	ld	s1,72(sp)
 4b6:	6906                	ld	s2,64(sp)
 4b8:	79e2                	ld	s3,56(sp)
 4ba:	7a42                	ld	s4,48(sp)
 4bc:	7aa2                	ld	s5,40(sp)
 4be:	7b02                	ld	s6,32(sp)
 4c0:	6be2                	ld	s7,24(sp)
 4c2:	6125                	addi	sp,sp,96
 4c4:	8082                	ret

00000000000004c6 <stat>:

int
stat(const char *n, struct stat *st)
{
 4c6:	1101                	addi	sp,sp,-32
 4c8:	ec06                	sd	ra,24(sp)
 4ca:	e822                	sd	s0,16(sp)
 4cc:	e426                	sd	s1,8(sp)
 4ce:	e04a                	sd	s2,0(sp)
 4d0:	1000                	addi	s0,sp,32
 4d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d4:	4581                	li	a1,0
 4d6:	00000097          	auipc	ra,0x0
 4da:	172080e7          	jalr	370(ra) # 648 <open>
  if(fd < 0)
 4de:	02054563          	bltz	a0,508 <stat+0x42>
 4e2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4e4:	85ca                	mv	a1,s2
 4e6:	00000097          	auipc	ra,0x0
 4ea:	17a080e7          	jalr	378(ra) # 660 <fstat>
 4ee:	892a                	mv	s2,a0
  close(fd);
 4f0:	8526                	mv	a0,s1
 4f2:	00000097          	auipc	ra,0x0
 4f6:	13e080e7          	jalr	318(ra) # 630 <close>
  return r;
}
 4fa:	854a                	mv	a0,s2
 4fc:	60e2                	ld	ra,24(sp)
 4fe:	6442                	ld	s0,16(sp)
 500:	64a2                	ld	s1,8(sp)
 502:	6902                	ld	s2,0(sp)
 504:	6105                	addi	sp,sp,32
 506:	8082                	ret
    return -1;
 508:	597d                	li	s2,-1
 50a:	bfc5                	j	4fa <stat+0x34>

000000000000050c <atoi>:

int
atoi(const char *s)
{
 50c:	1141                	addi	sp,sp,-16
 50e:	e422                	sd	s0,8(sp)
 510:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 512:	00054603          	lbu	a2,0(a0)
 516:	fd06079b          	addiw	a5,a2,-48
 51a:	0ff7f793          	andi	a5,a5,255
 51e:	4725                	li	a4,9
 520:	02f76963          	bltu	a4,a5,552 <atoi+0x46>
 524:	86aa                	mv	a3,a0
  n = 0;
 526:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 528:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 52a:	0685                	addi	a3,a3,1
 52c:	0025179b          	slliw	a5,a0,0x2
 530:	9fa9                	addw	a5,a5,a0
 532:	0017979b          	slliw	a5,a5,0x1
 536:	9fb1                	addw	a5,a5,a2
 538:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 53c:	0006c603          	lbu	a2,0(a3)
 540:	fd06071b          	addiw	a4,a2,-48
 544:	0ff77713          	andi	a4,a4,255
 548:	fee5f1e3          	bgeu	a1,a4,52a <atoi+0x1e>
  return n;
}
 54c:	6422                	ld	s0,8(sp)
 54e:	0141                	addi	sp,sp,16
 550:	8082                	ret
  n = 0;
 552:	4501                	li	a0,0
 554:	bfe5                	j	54c <atoi+0x40>

0000000000000556 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 556:	1141                	addi	sp,sp,-16
 558:	e422                	sd	s0,8(sp)
 55a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 55c:	02b57463          	bgeu	a0,a1,584 <memmove+0x2e>
    while(n-- > 0)
 560:	00c05f63          	blez	a2,57e <memmove+0x28>
 564:	1602                	slli	a2,a2,0x20
 566:	9201                	srli	a2,a2,0x20
 568:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 56c:	872a                	mv	a4,a0
      *dst++ = *src++;
 56e:	0585                	addi	a1,a1,1
 570:	0705                	addi	a4,a4,1
 572:	fff5c683          	lbu	a3,-1(a1)
 576:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 57a:	fee79ae3          	bne	a5,a4,56e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 57e:	6422                	ld	s0,8(sp)
 580:	0141                	addi	sp,sp,16
 582:	8082                	ret
    dst += n;
 584:	00c50733          	add	a4,a0,a2
    src += n;
 588:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 58a:	fec05ae3          	blez	a2,57e <memmove+0x28>
 58e:	fff6079b          	addiw	a5,a2,-1
 592:	1782                	slli	a5,a5,0x20
 594:	9381                	srli	a5,a5,0x20
 596:	fff7c793          	not	a5,a5
 59a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 59c:	15fd                	addi	a1,a1,-1
 59e:	177d                	addi	a4,a4,-1
 5a0:	0005c683          	lbu	a3,0(a1)
 5a4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5a8:	fee79ae3          	bne	a5,a4,59c <memmove+0x46>
 5ac:	bfc9                	j	57e <memmove+0x28>

00000000000005ae <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5ae:	1141                	addi	sp,sp,-16
 5b0:	e422                	sd	s0,8(sp)
 5b2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5b4:	ca05                	beqz	a2,5e4 <memcmp+0x36>
 5b6:	fff6069b          	addiw	a3,a2,-1
 5ba:	1682                	slli	a3,a3,0x20
 5bc:	9281                	srli	a3,a3,0x20
 5be:	0685                	addi	a3,a3,1
 5c0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5c2:	00054783          	lbu	a5,0(a0)
 5c6:	0005c703          	lbu	a4,0(a1)
 5ca:	00e79863          	bne	a5,a4,5da <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5ce:	0505                	addi	a0,a0,1
    p2++;
 5d0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5d2:	fed518e3          	bne	a0,a3,5c2 <memcmp+0x14>
  }
  return 0;
 5d6:	4501                	li	a0,0
 5d8:	a019                	j	5de <memcmp+0x30>
      return *p1 - *p2;
 5da:	40e7853b          	subw	a0,a5,a4
}
 5de:	6422                	ld	s0,8(sp)
 5e0:	0141                	addi	sp,sp,16
 5e2:	8082                	ret
  return 0;
 5e4:	4501                	li	a0,0
 5e6:	bfe5                	j	5de <memcmp+0x30>

00000000000005e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5e8:	1141                	addi	sp,sp,-16
 5ea:	e406                	sd	ra,8(sp)
 5ec:	e022                	sd	s0,0(sp)
 5ee:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 5f0:	00000097          	auipc	ra,0x0
 5f4:	f66080e7          	jalr	-154(ra) # 556 <memmove>
}
 5f8:	60a2                	ld	ra,8(sp)
 5fa:	6402                	ld	s0,0(sp)
 5fc:	0141                	addi	sp,sp,16
 5fe:	8082                	ret

0000000000000600 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 600:	4885                	li	a7,1
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <exit>:
.global exit
exit:
 li a7, SYS_exit
 608:	4889                	li	a7,2
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <wait>:
.global wait
wait:
 li a7, SYS_wait
 610:	488d                	li	a7,3
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 618:	4891                	li	a7,4
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <read>:
.global read
read:
 li a7, SYS_read
 620:	4895                	li	a7,5
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <write>:
.global write
write:
 li a7, SYS_write
 628:	48c1                	li	a7,16
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <close>:
.global close
close:
 li a7, SYS_close
 630:	48d5                	li	a7,21
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <kill>:
.global kill
kill:
 li a7, SYS_kill
 638:	4899                	li	a7,6
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <exec>:
.global exec
exec:
 li a7, SYS_exec
 640:	489d                	li	a7,7
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <open>:
.global open
open:
 li a7, SYS_open
 648:	48bd                	li	a7,15
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 650:	48c5                	li	a7,17
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 658:	48c9                	li	a7,18
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 660:	48a1                	li	a7,8
 ecall
 662:	00000073          	ecall
 ret
 666:	8082                	ret

0000000000000668 <link>:
.global link
link:
 li a7, SYS_link
 668:	48cd                	li	a7,19
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 670:	48d1                	li	a7,20
 ecall
 672:	00000073          	ecall
 ret
 676:	8082                	ret

0000000000000678 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 678:	48a5                	li	a7,9
 ecall
 67a:	00000073          	ecall
 ret
 67e:	8082                	ret

0000000000000680 <dup>:
.global dup
dup:
 li a7, SYS_dup
 680:	48a9                	li	a7,10
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 688:	48ad                	li	a7,11
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 690:	48b1                	li	a7,12
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 698:	48b5                	li	a7,13
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6a0:	48b9                	li	a7,14
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <trace>:
.global trace
trace:
 li a7, SYS_trace
 6a8:	48d9                	li	a7,22
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 6b0:	48dd                	li	a7,23
 ecall
 6b2:	00000073          	ecall
 ret
 6b6:	8082                	ret

00000000000006b8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6b8:	1101                	addi	sp,sp,-32
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6c4:	4605                	li	a2,1
 6c6:	fef40593          	addi	a1,s0,-17
 6ca:	00000097          	auipc	ra,0x0
 6ce:	f5e080e7          	jalr	-162(ra) # 628 <write>
}
 6d2:	60e2                	ld	ra,24(sp)
 6d4:	6442                	ld	s0,16(sp)
 6d6:	6105                	addi	sp,sp,32
 6d8:	8082                	ret

00000000000006da <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6da:	7139                	addi	sp,sp,-64
 6dc:	fc06                	sd	ra,56(sp)
 6de:	f822                	sd	s0,48(sp)
 6e0:	f426                	sd	s1,40(sp)
 6e2:	f04a                	sd	s2,32(sp)
 6e4:	ec4e                	sd	s3,24(sp)
 6e6:	0080                	addi	s0,sp,64
 6e8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6ea:	c299                	beqz	a3,6f0 <printint+0x16>
 6ec:	0805c863          	bltz	a1,77c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6f0:	2581                	sext.w	a1,a1
  neg = 0;
 6f2:	4881                	li	a7,0
 6f4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6f8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6fa:	2601                	sext.w	a2,a2
 6fc:	00000517          	auipc	a0,0x0
 700:	45c50513          	addi	a0,a0,1116 # b58 <digits>
 704:	883a                	mv	a6,a4
 706:	2705                	addiw	a4,a4,1
 708:	02c5f7bb          	remuw	a5,a1,a2
 70c:	1782                	slli	a5,a5,0x20
 70e:	9381                	srli	a5,a5,0x20
 710:	97aa                	add	a5,a5,a0
 712:	0007c783          	lbu	a5,0(a5)
 716:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 71a:	0005879b          	sext.w	a5,a1
 71e:	02c5d5bb          	divuw	a1,a1,a2
 722:	0685                	addi	a3,a3,1
 724:	fec7f0e3          	bgeu	a5,a2,704 <printint+0x2a>
  if(neg)
 728:	00088b63          	beqz	a7,73e <printint+0x64>
    buf[i++] = '-';
 72c:	fd040793          	addi	a5,s0,-48
 730:	973e                	add	a4,a4,a5
 732:	02d00793          	li	a5,45
 736:	fef70823          	sb	a5,-16(a4)
 73a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 73e:	02e05863          	blez	a4,76e <printint+0x94>
 742:	fc040793          	addi	a5,s0,-64
 746:	00e78933          	add	s2,a5,a4
 74a:	fff78993          	addi	s3,a5,-1
 74e:	99ba                	add	s3,s3,a4
 750:	377d                	addiw	a4,a4,-1
 752:	1702                	slli	a4,a4,0x20
 754:	9301                	srli	a4,a4,0x20
 756:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 75a:	fff94583          	lbu	a1,-1(s2)
 75e:	8526                	mv	a0,s1
 760:	00000097          	auipc	ra,0x0
 764:	f58080e7          	jalr	-168(ra) # 6b8 <putc>
  while(--i >= 0)
 768:	197d                	addi	s2,s2,-1
 76a:	ff3918e3          	bne	s2,s3,75a <printint+0x80>
}
 76e:	70e2                	ld	ra,56(sp)
 770:	7442                	ld	s0,48(sp)
 772:	74a2                	ld	s1,40(sp)
 774:	7902                	ld	s2,32(sp)
 776:	69e2                	ld	s3,24(sp)
 778:	6121                	addi	sp,sp,64
 77a:	8082                	ret
    x = -xx;
 77c:	40b005bb          	negw	a1,a1
    neg = 1;
 780:	4885                	li	a7,1
    x = -xx;
 782:	bf8d                	j	6f4 <printint+0x1a>

0000000000000784 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 784:	7119                	addi	sp,sp,-128
 786:	fc86                	sd	ra,120(sp)
 788:	f8a2                	sd	s0,112(sp)
 78a:	f4a6                	sd	s1,104(sp)
 78c:	f0ca                	sd	s2,96(sp)
 78e:	ecce                	sd	s3,88(sp)
 790:	e8d2                	sd	s4,80(sp)
 792:	e4d6                	sd	s5,72(sp)
 794:	e0da                	sd	s6,64(sp)
 796:	fc5e                	sd	s7,56(sp)
 798:	f862                	sd	s8,48(sp)
 79a:	f466                	sd	s9,40(sp)
 79c:	f06a                	sd	s10,32(sp)
 79e:	ec6e                	sd	s11,24(sp)
 7a0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7a2:	0005c903          	lbu	s2,0(a1)
 7a6:	18090f63          	beqz	s2,944 <vprintf+0x1c0>
 7aa:	8aaa                	mv	s5,a0
 7ac:	8b32                	mv	s6,a2
 7ae:	00158493          	addi	s1,a1,1
  state = 0;
 7b2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7b4:	02500a13          	li	s4,37
      if(c == 'd'){
 7b8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7bc:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 7c0:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 7c4:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7c8:	00000b97          	auipc	s7,0x0
 7cc:	390b8b93          	addi	s7,s7,912 # b58 <digits>
 7d0:	a839                	j	7ee <vprintf+0x6a>
        putc(fd, c);
 7d2:	85ca                	mv	a1,s2
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	ee2080e7          	jalr	-286(ra) # 6b8 <putc>
 7de:	a019                	j	7e4 <vprintf+0x60>
    } else if(state == '%'){
 7e0:	01498f63          	beq	s3,s4,7fe <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 7e4:	0485                	addi	s1,s1,1
 7e6:	fff4c903          	lbu	s2,-1(s1)
 7ea:	14090d63          	beqz	s2,944 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 7ee:	0009079b          	sext.w	a5,s2
    if(state == 0){
 7f2:	fe0997e3          	bnez	s3,7e0 <vprintf+0x5c>
      if(c == '%'){
 7f6:	fd479ee3          	bne	a5,s4,7d2 <vprintf+0x4e>
        state = '%';
 7fa:	89be                	mv	s3,a5
 7fc:	b7e5                	j	7e4 <vprintf+0x60>
      if(c == 'd'){
 7fe:	05878063          	beq	a5,s8,83e <vprintf+0xba>
      } else if(c == 'l') {
 802:	05978c63          	beq	a5,s9,85a <vprintf+0xd6>
      } else if(c == 'x') {
 806:	07a78863          	beq	a5,s10,876 <vprintf+0xf2>
      } else if(c == 'p') {
 80a:	09b78463          	beq	a5,s11,892 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 80e:	07300713          	li	a4,115
 812:	0ce78663          	beq	a5,a4,8de <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 816:	06300713          	li	a4,99
 81a:	0ee78e63          	beq	a5,a4,916 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 81e:	11478863          	beq	a5,s4,92e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 822:	85d2                	mv	a1,s4
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	e92080e7          	jalr	-366(ra) # 6b8 <putc>
        putc(fd, c);
 82e:	85ca                	mv	a1,s2
 830:	8556                	mv	a0,s5
 832:	00000097          	auipc	ra,0x0
 836:	e86080e7          	jalr	-378(ra) # 6b8 <putc>
      }
      state = 0;
 83a:	4981                	li	s3,0
 83c:	b765                	j	7e4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 83e:	008b0913          	addi	s2,s6,8
 842:	4685                	li	a3,1
 844:	4629                	li	a2,10
 846:	000b2583          	lw	a1,0(s6)
 84a:	8556                	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	e8e080e7          	jalr	-370(ra) # 6da <printint>
 854:	8b4a                	mv	s6,s2
      state = 0;
 856:	4981                	li	s3,0
 858:	b771                	j	7e4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 85a:	008b0913          	addi	s2,s6,8
 85e:	4681                	li	a3,0
 860:	4629                	li	a2,10
 862:	000b2583          	lw	a1,0(s6)
 866:	8556                	mv	a0,s5
 868:	00000097          	auipc	ra,0x0
 86c:	e72080e7          	jalr	-398(ra) # 6da <printint>
 870:	8b4a                	mv	s6,s2
      state = 0;
 872:	4981                	li	s3,0
 874:	bf85                	j	7e4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 876:	008b0913          	addi	s2,s6,8
 87a:	4681                	li	a3,0
 87c:	4641                	li	a2,16
 87e:	000b2583          	lw	a1,0(s6)
 882:	8556                	mv	a0,s5
 884:	00000097          	auipc	ra,0x0
 888:	e56080e7          	jalr	-426(ra) # 6da <printint>
 88c:	8b4a                	mv	s6,s2
      state = 0;
 88e:	4981                	li	s3,0
 890:	bf91                	j	7e4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 892:	008b0793          	addi	a5,s6,8
 896:	f8f43423          	sd	a5,-120(s0)
 89a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 89e:	03000593          	li	a1,48
 8a2:	8556                	mv	a0,s5
 8a4:	00000097          	auipc	ra,0x0
 8a8:	e14080e7          	jalr	-492(ra) # 6b8 <putc>
  putc(fd, 'x');
 8ac:	85ea                	mv	a1,s10
 8ae:	8556                	mv	a0,s5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	e08080e7          	jalr	-504(ra) # 6b8 <putc>
 8b8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8ba:	03c9d793          	srli	a5,s3,0x3c
 8be:	97de                	add	a5,a5,s7
 8c0:	0007c583          	lbu	a1,0(a5)
 8c4:	8556                	mv	a0,s5
 8c6:	00000097          	auipc	ra,0x0
 8ca:	df2080e7          	jalr	-526(ra) # 6b8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8ce:	0992                	slli	s3,s3,0x4
 8d0:	397d                	addiw	s2,s2,-1
 8d2:	fe0914e3          	bnez	s2,8ba <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 8d6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 8da:	4981                	li	s3,0
 8dc:	b721                	j	7e4 <vprintf+0x60>
        s = va_arg(ap, char*);
 8de:	008b0993          	addi	s3,s6,8
 8e2:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 8e6:	02090163          	beqz	s2,908 <vprintf+0x184>
        while(*s != 0){
 8ea:	00094583          	lbu	a1,0(s2)
 8ee:	c9a1                	beqz	a1,93e <vprintf+0x1ba>
          putc(fd, *s);
 8f0:	8556                	mv	a0,s5
 8f2:	00000097          	auipc	ra,0x0
 8f6:	dc6080e7          	jalr	-570(ra) # 6b8 <putc>
          s++;
 8fa:	0905                	addi	s2,s2,1
        while(*s != 0){
 8fc:	00094583          	lbu	a1,0(s2)
 900:	f9e5                	bnez	a1,8f0 <vprintf+0x16c>
        s = va_arg(ap, char*);
 902:	8b4e                	mv	s6,s3
      state = 0;
 904:	4981                	li	s3,0
 906:	bdf9                	j	7e4 <vprintf+0x60>
          s = "(null)";
 908:	00000917          	auipc	s2,0x0
 90c:	24890913          	addi	s2,s2,584 # b50 <malloc+0x102>
        while(*s != 0){
 910:	02800593          	li	a1,40
 914:	bff1                	j	8f0 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 916:	008b0913          	addi	s2,s6,8
 91a:	000b4583          	lbu	a1,0(s6)
 91e:	8556                	mv	a0,s5
 920:	00000097          	auipc	ra,0x0
 924:	d98080e7          	jalr	-616(ra) # 6b8 <putc>
 928:	8b4a                	mv	s6,s2
      state = 0;
 92a:	4981                	li	s3,0
 92c:	bd65                	j	7e4 <vprintf+0x60>
        putc(fd, c);
 92e:	85d2                	mv	a1,s4
 930:	8556                	mv	a0,s5
 932:	00000097          	auipc	ra,0x0
 936:	d86080e7          	jalr	-634(ra) # 6b8 <putc>
      state = 0;
 93a:	4981                	li	s3,0
 93c:	b565                	j	7e4 <vprintf+0x60>
        s = va_arg(ap, char*);
 93e:	8b4e                	mv	s6,s3
      state = 0;
 940:	4981                	li	s3,0
 942:	b54d                	j	7e4 <vprintf+0x60>
    }
  }
}
 944:	70e6                	ld	ra,120(sp)
 946:	7446                	ld	s0,112(sp)
 948:	74a6                	ld	s1,104(sp)
 94a:	7906                	ld	s2,96(sp)
 94c:	69e6                	ld	s3,88(sp)
 94e:	6a46                	ld	s4,80(sp)
 950:	6aa6                	ld	s5,72(sp)
 952:	6b06                	ld	s6,64(sp)
 954:	7be2                	ld	s7,56(sp)
 956:	7c42                	ld	s8,48(sp)
 958:	7ca2                	ld	s9,40(sp)
 95a:	7d02                	ld	s10,32(sp)
 95c:	6de2                	ld	s11,24(sp)
 95e:	6109                	addi	sp,sp,128
 960:	8082                	ret

0000000000000962 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 962:	715d                	addi	sp,sp,-80
 964:	ec06                	sd	ra,24(sp)
 966:	e822                	sd	s0,16(sp)
 968:	1000                	addi	s0,sp,32
 96a:	e010                	sd	a2,0(s0)
 96c:	e414                	sd	a3,8(s0)
 96e:	e818                	sd	a4,16(s0)
 970:	ec1c                	sd	a5,24(s0)
 972:	03043023          	sd	a6,32(s0)
 976:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 97a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 97e:	8622                	mv	a2,s0
 980:	00000097          	auipc	ra,0x0
 984:	e04080e7          	jalr	-508(ra) # 784 <vprintf>
}
 988:	60e2                	ld	ra,24(sp)
 98a:	6442                	ld	s0,16(sp)
 98c:	6161                	addi	sp,sp,80
 98e:	8082                	ret

0000000000000990 <printf>:

void
printf(const char *fmt, ...)
{
 990:	711d                	addi	sp,sp,-96
 992:	ec06                	sd	ra,24(sp)
 994:	e822                	sd	s0,16(sp)
 996:	1000                	addi	s0,sp,32
 998:	e40c                	sd	a1,8(s0)
 99a:	e810                	sd	a2,16(s0)
 99c:	ec14                	sd	a3,24(s0)
 99e:	f018                	sd	a4,32(s0)
 9a0:	f41c                	sd	a5,40(s0)
 9a2:	03043823          	sd	a6,48(s0)
 9a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9aa:	00840613          	addi	a2,s0,8
 9ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9b2:	85aa                	mv	a1,a0
 9b4:	4505                	li	a0,1
 9b6:	00000097          	auipc	ra,0x0
 9ba:	dce080e7          	jalr	-562(ra) # 784 <vprintf>
}
 9be:	60e2                	ld	ra,24(sp)
 9c0:	6442                	ld	s0,16(sp)
 9c2:	6125                	addi	sp,sp,96
 9c4:	8082                	ret

00000000000009c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9c6:	1141                	addi	sp,sp,-16
 9c8:	e422                	sd	s0,8(sp)
 9ca:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9cc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d0:	00000797          	auipc	a5,0x0
 9d4:	6307b783          	ld	a5,1584(a5) # 1000 <freep>
 9d8:	a805                	j	a08 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9da:	4618                	lw	a4,8(a2)
 9dc:	9db9                	addw	a1,a1,a4
 9de:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9e2:	6398                	ld	a4,0(a5)
 9e4:	6318                	ld	a4,0(a4)
 9e6:	fee53823          	sd	a4,-16(a0)
 9ea:	a091                	j	a2e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9ec:	ff852703          	lw	a4,-8(a0)
 9f0:	9e39                	addw	a2,a2,a4
 9f2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 9f4:	ff053703          	ld	a4,-16(a0)
 9f8:	e398                	sd	a4,0(a5)
 9fa:	a099                	j	a40 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9fc:	6398                	ld	a4,0(a5)
 9fe:	00e7e463          	bltu	a5,a4,a06 <free+0x40>
 a02:	00e6ea63          	bltu	a3,a4,a16 <free+0x50>
{
 a06:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a08:	fed7fae3          	bgeu	a5,a3,9fc <free+0x36>
 a0c:	6398                	ld	a4,0(a5)
 a0e:	00e6e463          	bltu	a3,a4,a16 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a12:	fee7eae3          	bltu	a5,a4,a06 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a16:	ff852583          	lw	a1,-8(a0)
 a1a:	6390                	ld	a2,0(a5)
 a1c:	02059713          	slli	a4,a1,0x20
 a20:	9301                	srli	a4,a4,0x20
 a22:	0712                	slli	a4,a4,0x4
 a24:	9736                	add	a4,a4,a3
 a26:	fae60ae3          	beq	a2,a4,9da <free+0x14>
    bp->s.ptr = p->s.ptr;
 a2a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a2e:	4790                	lw	a2,8(a5)
 a30:	02061713          	slli	a4,a2,0x20
 a34:	9301                	srli	a4,a4,0x20
 a36:	0712                	slli	a4,a4,0x4
 a38:	973e                	add	a4,a4,a5
 a3a:	fae689e3          	beq	a3,a4,9ec <free+0x26>
  } else
    p->s.ptr = bp;
 a3e:	e394                	sd	a3,0(a5)
  freep = p;
 a40:	00000717          	auipc	a4,0x0
 a44:	5cf73023          	sd	a5,1472(a4) # 1000 <freep>
}
 a48:	6422                	ld	s0,8(sp)
 a4a:	0141                	addi	sp,sp,16
 a4c:	8082                	ret

0000000000000a4e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a4e:	7139                	addi	sp,sp,-64
 a50:	fc06                	sd	ra,56(sp)
 a52:	f822                	sd	s0,48(sp)
 a54:	f426                	sd	s1,40(sp)
 a56:	f04a                	sd	s2,32(sp)
 a58:	ec4e                	sd	s3,24(sp)
 a5a:	e852                	sd	s4,16(sp)
 a5c:	e456                	sd	s5,8(sp)
 a5e:	e05a                	sd	s6,0(sp)
 a60:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a62:	02051493          	slli	s1,a0,0x20
 a66:	9081                	srli	s1,s1,0x20
 a68:	04bd                	addi	s1,s1,15
 a6a:	8091                	srli	s1,s1,0x4
 a6c:	0014899b          	addiw	s3,s1,1
 a70:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a72:	00000517          	auipc	a0,0x0
 a76:	58e53503          	ld	a0,1422(a0) # 1000 <freep>
 a7a:	c515                	beqz	a0,aa6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a7e:	4798                	lw	a4,8(a5)
 a80:	02977f63          	bgeu	a4,s1,abe <malloc+0x70>
 a84:	8a4e                	mv	s4,s3
 a86:	0009871b          	sext.w	a4,s3
 a8a:	6685                	lui	a3,0x1
 a8c:	00d77363          	bgeu	a4,a3,a92 <malloc+0x44>
 a90:	6a05                	lui	s4,0x1
 a92:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a96:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a9a:	00000917          	auipc	s2,0x0
 a9e:	56690913          	addi	s2,s2,1382 # 1000 <freep>
  if(p == (char*)-1)
 aa2:	5afd                	li	s5,-1
 aa4:	a88d                	j	b16 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 aa6:	00000797          	auipc	a5,0x0
 aaa:	56a78793          	addi	a5,a5,1386 # 1010 <base>
 aae:	00000717          	auipc	a4,0x0
 ab2:	54f73923          	sd	a5,1362(a4) # 1000 <freep>
 ab6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ab8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 abc:	b7e1                	j	a84 <malloc+0x36>
      if(p->s.size == nunits)
 abe:	02e48b63          	beq	s1,a4,af4 <malloc+0xa6>
        p->s.size -= nunits;
 ac2:	4137073b          	subw	a4,a4,s3
 ac6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ac8:	1702                	slli	a4,a4,0x20
 aca:	9301                	srli	a4,a4,0x20
 acc:	0712                	slli	a4,a4,0x4
 ace:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ad0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ad4:	00000717          	auipc	a4,0x0
 ad8:	52a73623          	sd	a0,1324(a4) # 1000 <freep>
      return (void*)(p + 1);
 adc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ae0:	70e2                	ld	ra,56(sp)
 ae2:	7442                	ld	s0,48(sp)
 ae4:	74a2                	ld	s1,40(sp)
 ae6:	7902                	ld	s2,32(sp)
 ae8:	69e2                	ld	s3,24(sp)
 aea:	6a42                	ld	s4,16(sp)
 aec:	6aa2                	ld	s5,8(sp)
 aee:	6b02                	ld	s6,0(sp)
 af0:	6121                	addi	sp,sp,64
 af2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 af4:	6398                	ld	a4,0(a5)
 af6:	e118                	sd	a4,0(a0)
 af8:	bff1                	j	ad4 <malloc+0x86>
  hp->s.size = nu;
 afa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 afe:	0541                	addi	a0,a0,16
 b00:	00000097          	auipc	ra,0x0
 b04:	ec6080e7          	jalr	-314(ra) # 9c6 <free>
  return freep;
 b08:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b0c:	d971                	beqz	a0,ae0 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b0e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b10:	4798                	lw	a4,8(a5)
 b12:	fa9776e3          	bgeu	a4,s1,abe <malloc+0x70>
    if(p == freep)
 b16:	00093703          	ld	a4,0(s2)
 b1a:	853e                	mv	a0,a5
 b1c:	fef719e3          	bne	a4,a5,b0e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b20:	8552                	mv	a0,s4
 b22:	00000097          	auipc	ra,0x0
 b26:	b6e080e7          	jalr	-1170(ra) # 690 <sbrk>
  if(p == (char*)-1)
 b2a:	fd5518e3          	bne	a0,s5,afa <malloc+0xac>
        return 0;
 b2e:	4501                	li	a0,0
 b30:	bf45                	j	ae0 <malloc+0x92>
