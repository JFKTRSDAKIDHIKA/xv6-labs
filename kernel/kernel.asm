
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a5813103          	ld	sp,-1448(sp) # 80008a58 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	097050ef          	jal	ra,800058ac <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	0e078793          	addi	a5,a5,224 # 80022110 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	156080e7          	jalr	342(ra) # 8000019e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	a5090913          	addi	s2,s2,-1456 # 80008aa0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	252080e7          	jalr	594(ra) # 800062ac <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2f2080e7          	jalr	754(ra) # 80006360 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	cd8080e7          	jalr	-808(ra) # 80005d62 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	9b450513          	addi	a0,a0,-1612 # 80008aa0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	128080e7          	jalr	296(ra) # 8000621c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	01050513          	addi	a0,a0,16 # 80022110 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	97e48493          	addi	s1,s1,-1666 # 80008aa0 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	180080e7          	jalr	384(ra) # 800062ac <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	96650513          	addi	a0,a0,-1690 # 80008aa0 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	21c080e7          	jalr	540(ra) # 80006360 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	04c080e7          	jalr	76(ra) # 8000019e <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	93a50513          	addi	a0,a0,-1734 # 80008aa0 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	1f2080e7          	jalr	498(ra) # 80006360 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <kfreemem>:

// calculate the num of free memory
int kfreemem(void){
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  int num = 0;
  struct run *p;
  p = kmem.freelist;
    8000017e:	00009797          	auipc	a5,0x9
    80000182:	93a7b783          	ld	a5,-1734(a5) # 80008ab8 <kmem+0x18>
  while(p != 0){
    80000186:	cb91                	beqz	a5,8000019a <kfreemem+0x22>
  int num = 0;
    80000188:	4501                	li	a0,0
    num = num + 1;
    8000018a:	2505                	addiw	a0,a0,1
    p = p->next;
    8000018c:	639c                	ld	a5,0(a5)
  while(p != 0){
    8000018e:	fff5                	bnez	a5,8000018a <kfreemem+0x12>
  }
 // printf("kfreemen: %d", PGSIZE * num);
  return PGSIZE * num;
}
    80000190:	00c5151b          	slliw	a0,a0,0xc
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret
  int num = 0;
    8000019a:	4501                	li	a0,0
    8000019c:	bfd5                	j	80000190 <kfreemem+0x18>

000000008000019e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001a4:	ce09                	beqz	a2,800001be <memset+0x20>
    800001a6:	87aa                	mv	a5,a0
    800001a8:	fff6071b          	addiw	a4,a2,-1
    800001ac:	1702                	slli	a4,a4,0x20
    800001ae:	9301                	srli	a4,a4,0x20
    800001b0:	0705                	addi	a4,a4,1
    800001b2:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001b8:	0785                	addi	a5,a5,1
    800001ba:	fee79de3          	bne	a5,a4,800001b4 <memset+0x16>
  }
  return dst;
}
    800001be:	6422                	ld	s0,8(sp)
    800001c0:	0141                	addi	sp,sp,16
    800001c2:	8082                	ret

00000000800001c4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001c4:	1141                	addi	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ca:	ca05                	beqz	a2,800001fa <memcmp+0x36>
    800001cc:	fff6069b          	addiw	a3,a2,-1
    800001d0:	1682                	slli	a3,a3,0x20
    800001d2:	9281                	srli	a3,a3,0x20
    800001d4:	0685                	addi	a3,a3,1
    800001d6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001d8:	00054783          	lbu	a5,0(a0)
    800001dc:	0005c703          	lbu	a4,0(a1)
    800001e0:	00e79863          	bne	a5,a4,800001f0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001e4:	0505                	addi	a0,a0,1
    800001e6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001e8:	fed518e3          	bne	a0,a3,800001d8 <memcmp+0x14>
  }

  return 0;
    800001ec:	4501                	li	a0,0
    800001ee:	a019                	j	800001f4 <memcmp+0x30>
      return *s1 - *s2;
    800001f0:	40e7853b          	subw	a0,a5,a4
}
    800001f4:	6422                	ld	s0,8(sp)
    800001f6:	0141                	addi	sp,sp,16
    800001f8:	8082                	ret
  return 0;
    800001fa:	4501                	li	a0,0
    800001fc:	bfe5                	j	800001f4 <memcmp+0x30>

00000000800001fe <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001fe:	1141                	addi	sp,sp,-16
    80000200:	e422                	sd	s0,8(sp)
    80000202:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000204:	ca0d                	beqz	a2,80000236 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000206:	00a5f963          	bgeu	a1,a0,80000218 <memmove+0x1a>
    8000020a:	02061693          	slli	a3,a2,0x20
    8000020e:	9281                	srli	a3,a3,0x20
    80000210:	00d58733          	add	a4,a1,a3
    80000214:	02e56463          	bltu	a0,a4,8000023c <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	0785                	addi	a5,a5,1
    80000222:	97ae                	add	a5,a5,a1
    80000224:	872a                	mv	a4,a0
      *d++ = *s++;
    80000226:	0585                	addi	a1,a1,1
    80000228:	0705                	addi	a4,a4,1
    8000022a:	fff5c683          	lbu	a3,-1(a1)
    8000022e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000232:	fef59ae3          	bne	a1,a5,80000226 <memmove+0x28>

  return dst;
}
    80000236:	6422                	ld	s0,8(sp)
    80000238:	0141                	addi	sp,sp,16
    8000023a:	8082                	ret
    d += n;
    8000023c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000023e:	fff6079b          	addiw	a5,a2,-1
    80000242:	1782                	slli	a5,a5,0x20
    80000244:	9381                	srli	a5,a5,0x20
    80000246:	fff7c793          	not	a5,a5
    8000024a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000024c:	177d                	addi	a4,a4,-1
    8000024e:	16fd                	addi	a3,a3,-1
    80000250:	00074603          	lbu	a2,0(a4)
    80000254:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000258:	fef71ae3          	bne	a4,a5,8000024c <memmove+0x4e>
    8000025c:	bfe9                	j	80000236 <memmove+0x38>

000000008000025e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000025e:	1141                	addi	sp,sp,-16
    80000260:	e406                	sd	ra,8(sp)
    80000262:	e022                	sd	s0,0(sp)
    80000264:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000266:	00000097          	auipc	ra,0x0
    8000026a:	f98080e7          	jalr	-104(ra) # 800001fe <memmove>
}
    8000026e:	60a2                	ld	ra,8(sp)
    80000270:	6402                	ld	s0,0(sp)
    80000272:	0141                	addi	sp,sp,16
    80000274:	8082                	ret

0000000080000276 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000276:	1141                	addi	sp,sp,-16
    80000278:	e422                	sd	s0,8(sp)
    8000027a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000027c:	ce11                	beqz	a2,80000298 <strncmp+0x22>
    8000027e:	00054783          	lbu	a5,0(a0)
    80000282:	cf89                	beqz	a5,8000029c <strncmp+0x26>
    80000284:	0005c703          	lbu	a4,0(a1)
    80000288:	00f71a63          	bne	a4,a5,8000029c <strncmp+0x26>
    n--, p++, q++;
    8000028c:	367d                	addiw	a2,a2,-1
    8000028e:	0505                	addi	a0,a0,1
    80000290:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000292:	f675                	bnez	a2,8000027e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000294:	4501                	li	a0,0
    80000296:	a809                	j	800002a8 <strncmp+0x32>
    80000298:	4501                	li	a0,0
    8000029a:	a039                	j	800002a8 <strncmp+0x32>
  if(n == 0)
    8000029c:	ca09                	beqz	a2,800002ae <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000029e:	00054503          	lbu	a0,0(a0)
    800002a2:	0005c783          	lbu	a5,0(a1)
    800002a6:	9d1d                	subw	a0,a0,a5
}
    800002a8:	6422                	ld	s0,8(sp)
    800002aa:	0141                	addi	sp,sp,16
    800002ac:	8082                	ret
    return 0;
    800002ae:	4501                	li	a0,0
    800002b0:	bfe5                	j	800002a8 <strncmp+0x32>

00000000800002b2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002b2:	1141                	addi	sp,sp,-16
    800002b4:	e422                	sd	s0,8(sp)
    800002b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002b8:	872a                	mv	a4,a0
    800002ba:	8832                	mv	a6,a2
    800002bc:	367d                	addiw	a2,a2,-1
    800002be:	01005963          	blez	a6,800002d0 <strncpy+0x1e>
    800002c2:	0705                	addi	a4,a4,1
    800002c4:	0005c783          	lbu	a5,0(a1)
    800002c8:	fef70fa3          	sb	a5,-1(a4)
    800002cc:	0585                	addi	a1,a1,1
    800002ce:	f7f5                	bnez	a5,800002ba <strncpy+0x8>
    ;
  while(n-- > 0)
    800002d0:	00c05d63          	blez	a2,800002ea <strncpy+0x38>
    800002d4:	86ba                	mv	a3,a4
    *s++ = 0;
    800002d6:	0685                	addi	a3,a3,1
    800002d8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002dc:	fff6c793          	not	a5,a3
    800002e0:	9fb9                	addw	a5,a5,a4
    800002e2:	010787bb          	addw	a5,a5,a6
    800002e6:	fef048e3          	bgtz	a5,800002d6 <strncpy+0x24>
  return os;
}
    800002ea:	6422                	ld	s0,8(sp)
    800002ec:	0141                	addi	sp,sp,16
    800002ee:	8082                	ret

00000000800002f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002f0:	1141                	addi	sp,sp,-16
    800002f2:	e422                	sd	s0,8(sp)
    800002f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002f6:	02c05363          	blez	a2,8000031c <safestrcpy+0x2c>
    800002fa:	fff6069b          	addiw	a3,a2,-1
    800002fe:	1682                	slli	a3,a3,0x20
    80000300:	9281                	srli	a3,a3,0x20
    80000302:	96ae                	add	a3,a3,a1
    80000304:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000306:	00d58963          	beq	a1,a3,80000318 <safestrcpy+0x28>
    8000030a:	0585                	addi	a1,a1,1
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff5c703          	lbu	a4,-1(a1)
    80000312:	fee78fa3          	sb	a4,-1(a5)
    80000316:	fb65                	bnez	a4,80000306 <safestrcpy+0x16>
    ;
  *s = 0;
    80000318:	00078023          	sb	zero,0(a5)
  return os;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret

0000000080000322 <strlen>:

int
strlen(const char *s)
{
    80000322:	1141                	addi	sp,sp,-16
    80000324:	e422                	sd	s0,8(sp)
    80000326:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000328:	00054783          	lbu	a5,0(a0)
    8000032c:	cf91                	beqz	a5,80000348 <strlen+0x26>
    8000032e:	0505                	addi	a0,a0,1
    80000330:	87aa                	mv	a5,a0
    80000332:	4685                	li	a3,1
    80000334:	9e89                	subw	a3,a3,a0
    80000336:	00f6853b          	addw	a0,a3,a5
    8000033a:	0785                	addi	a5,a5,1
    8000033c:	fff7c703          	lbu	a4,-1(a5)
    80000340:	fb7d                	bnez	a4,80000336 <strlen+0x14>
    ;
  return n;
}
    80000342:	6422                	ld	s0,8(sp)
    80000344:	0141                	addi	sp,sp,16
    80000346:	8082                	ret
  for(n = 0; s[n]; n++)
    80000348:	4501                	li	a0,0
    8000034a:	bfe5                	j	80000342 <strlen+0x20>

000000008000034c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000034c:	1141                	addi	sp,sp,-16
    8000034e:	e406                	sd	ra,8(sp)
    80000350:	e022                	sd	s0,0(sp)
    80000352:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000354:	00001097          	auipc	ra,0x1
    80000358:	b56080e7          	jalr	-1194(ra) # 80000eaa <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000035c:	00008717          	auipc	a4,0x8
    80000360:	71470713          	addi	a4,a4,1812 # 80008a70 <started>
  if(cpuid() == 0){
    80000364:	c139                	beqz	a0,800003aa <main+0x5e>
    while(started == 0)
    80000366:	431c                	lw	a5,0(a4)
    80000368:	2781                	sext.w	a5,a5
    8000036a:	dff5                	beqz	a5,80000366 <main+0x1a>
      ;
    __sync_synchronize();
    8000036c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000370:	00001097          	auipc	ra,0x1
    80000374:	b3a080e7          	jalr	-1222(ra) # 80000eaa <cpuid>
    80000378:	85aa                	mv	a1,a0
    8000037a:	00008517          	auipc	a0,0x8
    8000037e:	cbe50513          	addi	a0,a0,-834 # 80008038 <etext+0x38>
    80000382:	00006097          	auipc	ra,0x6
    80000386:	a2a080e7          	jalr	-1494(ra) # 80005dac <printf>
    kvminithart();    // turn on paging
    8000038a:	00000097          	auipc	ra,0x0
    8000038e:	0d8080e7          	jalr	216(ra) # 80000462 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000392:	00002097          	auipc	ra,0x2
    80000396:	818080e7          	jalr	-2024(ra) # 80001baa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000039a:	00005097          	auipc	ra,0x5
    8000039e:	e66080e7          	jalr	-410(ra) # 80005200 <plicinithart>
  }

  scheduler();        
    800003a2:	00001097          	auipc	ra,0x1
    800003a6:	032080e7          	jalr	50(ra) # 800013d4 <scheduler>
    consoleinit();
    800003aa:	00006097          	auipc	ra,0x6
    800003ae:	8ca080e7          	jalr	-1846(ra) # 80005c74 <consoleinit>
    printfinit();
    800003b2:	00006097          	auipc	ra,0x6
    800003b6:	be0080e7          	jalr	-1056(ra) # 80005f92 <printfinit>
    printf("\n");
    800003ba:	00008517          	auipc	a0,0x8
    800003be:	c8e50513          	addi	a0,a0,-882 # 80008048 <etext+0x48>
    800003c2:	00006097          	auipc	ra,0x6
    800003c6:	9ea080e7          	jalr	-1558(ra) # 80005dac <printf>
    printf("xv6 kernel is booting\n");
    800003ca:	00008517          	auipc	a0,0x8
    800003ce:	c5650513          	addi	a0,a0,-938 # 80008020 <etext+0x20>
    800003d2:	00006097          	auipc	ra,0x6
    800003d6:	9da080e7          	jalr	-1574(ra) # 80005dac <printf>
    printf("\n");
    800003da:	00008517          	auipc	a0,0x8
    800003de:	c6e50513          	addi	a0,a0,-914 # 80008048 <etext+0x48>
    800003e2:	00006097          	auipc	ra,0x6
    800003e6:	9ca080e7          	jalr	-1590(ra) # 80005dac <printf>
    kinit();         // physical page allocator
    800003ea:	00000097          	auipc	ra,0x0
    800003ee:	cf2080e7          	jalr	-782(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003f2:	00000097          	auipc	ra,0x0
    800003f6:	34a080e7          	jalr	842(ra) # 8000073c <kvminit>
    kvminithart();   // turn on paging
    800003fa:	00000097          	auipc	ra,0x0
    800003fe:	068080e7          	jalr	104(ra) # 80000462 <kvminithart>
    procinit();      // process table
    80000402:	00001097          	auipc	ra,0x1
    80000406:	9f4080e7          	jalr	-1548(ra) # 80000df6 <procinit>
    trapinit();      // trap vectors
    8000040a:	00001097          	auipc	ra,0x1
    8000040e:	778080e7          	jalr	1912(ra) # 80001b82 <trapinit>
    trapinithart();  // install kernel trap vector
    80000412:	00001097          	auipc	ra,0x1
    80000416:	798080e7          	jalr	1944(ra) # 80001baa <trapinithart>
    plicinit();      // set up interrupt controller
    8000041a:	00005097          	auipc	ra,0x5
    8000041e:	dd0080e7          	jalr	-560(ra) # 800051ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000422:	00005097          	auipc	ra,0x5
    80000426:	dde080e7          	jalr	-546(ra) # 80005200 <plicinithart>
    binit();         // buffer cache
    8000042a:	00002097          	auipc	ra,0x2
    8000042e:	f96080e7          	jalr	-106(ra) # 800023c0 <binit>
    iinit();         // inode table
    80000432:	00002097          	auipc	ra,0x2
    80000436:	63a080e7          	jalr	1594(ra) # 80002a6c <iinit>
    fileinit();      // file table
    8000043a:	00003097          	auipc	ra,0x3
    8000043e:	5d8080e7          	jalr	1496(ra) # 80003a12 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000442:	00005097          	auipc	ra,0x5
    80000446:	ec6080e7          	jalr	-314(ra) # 80005308 <virtio_disk_init>
    userinit();      // first user process
    8000044a:	00001097          	auipc	ra,0x1
    8000044e:	d68080e7          	jalr	-664(ra) # 800011b2 <userinit>
    __sync_synchronize();
    80000452:	0ff0000f          	fence
    started = 1;
    80000456:	4785                	li	a5,1
    80000458:	00008717          	auipc	a4,0x8
    8000045c:	60f72c23          	sw	a5,1560(a4) # 80008a70 <started>
    80000460:	b789                	j	800003a2 <main+0x56>

0000000080000462 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000462:	1141                	addi	sp,sp,-16
    80000464:	e422                	sd	s0,8(sp)
    80000466:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000468:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000046c:	00008797          	auipc	a5,0x8
    80000470:	60c7b783          	ld	a5,1548(a5) # 80008a78 <kernel_pagetable>
    80000474:	83b1                	srli	a5,a5,0xc
    80000476:	577d                	li	a4,-1
    80000478:	177e                	slli	a4,a4,0x3f
    8000047a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000047c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000480:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000484:	6422                	ld	s0,8(sp)
    80000486:	0141                	addi	sp,sp,16
    80000488:	8082                	ret

000000008000048a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000048a:	7139                	addi	sp,sp,-64
    8000048c:	fc06                	sd	ra,56(sp)
    8000048e:	f822                	sd	s0,48(sp)
    80000490:	f426                	sd	s1,40(sp)
    80000492:	f04a                	sd	s2,32(sp)
    80000494:	ec4e                	sd	s3,24(sp)
    80000496:	e852                	sd	s4,16(sp)
    80000498:	e456                	sd	s5,8(sp)
    8000049a:	e05a                	sd	s6,0(sp)
    8000049c:	0080                	addi	s0,sp,64
    8000049e:	84aa                	mv	s1,a0
    800004a0:	89ae                	mv	s3,a1
    800004a2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004a4:	57fd                	li	a5,-1
    800004a6:	83e9                	srli	a5,a5,0x1a
    800004a8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004aa:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004ac:	04b7f263          	bgeu	a5,a1,800004f0 <walk+0x66>
    panic("walk");
    800004b0:	00008517          	auipc	a0,0x8
    800004b4:	ba050513          	addi	a0,a0,-1120 # 80008050 <etext+0x50>
    800004b8:	00006097          	auipc	ra,0x6
    800004bc:	8aa080e7          	jalr	-1878(ra) # 80005d62 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004c0:	060a8663          	beqz	s5,8000052c <walk+0xa2>
    800004c4:	00000097          	auipc	ra,0x0
    800004c8:	c54080e7          	jalr	-940(ra) # 80000118 <kalloc>
    800004cc:	84aa                	mv	s1,a0
    800004ce:	c529                	beqz	a0,80000518 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004d0:	6605                	lui	a2,0x1
    800004d2:	4581                	li	a1,0
    800004d4:	00000097          	auipc	ra,0x0
    800004d8:	cca080e7          	jalr	-822(ra) # 8000019e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004dc:	00c4d793          	srli	a5,s1,0xc
    800004e0:	07aa                	slli	a5,a5,0xa
    800004e2:	0017e793          	ori	a5,a5,1
    800004e6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004ea:	3a5d                	addiw	s4,s4,-9
    800004ec:	036a0063          	beq	s4,s6,8000050c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004f0:	0149d933          	srl	s2,s3,s4
    800004f4:	1ff97913          	andi	s2,s2,511
    800004f8:	090e                	slli	s2,s2,0x3
    800004fa:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004fc:	00093483          	ld	s1,0(s2)
    80000500:	0014f793          	andi	a5,s1,1
    80000504:	dfd5                	beqz	a5,800004c0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000506:	80a9                	srli	s1,s1,0xa
    80000508:	04b2                	slli	s1,s1,0xc
    8000050a:	b7c5                	j	800004ea <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000050c:	00c9d513          	srli	a0,s3,0xc
    80000510:	1ff57513          	andi	a0,a0,511
    80000514:	050e                	slli	a0,a0,0x3
    80000516:	9526                	add	a0,a0,s1
}
    80000518:	70e2                	ld	ra,56(sp)
    8000051a:	7442                	ld	s0,48(sp)
    8000051c:	74a2                	ld	s1,40(sp)
    8000051e:	7902                	ld	s2,32(sp)
    80000520:	69e2                	ld	s3,24(sp)
    80000522:	6a42                	ld	s4,16(sp)
    80000524:	6aa2                	ld	s5,8(sp)
    80000526:	6b02                	ld	s6,0(sp)
    80000528:	6121                	addi	sp,sp,64
    8000052a:	8082                	ret
        return 0;
    8000052c:	4501                	li	a0,0
    8000052e:	b7ed                	j	80000518 <walk+0x8e>

0000000080000530 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000530:	57fd                	li	a5,-1
    80000532:	83e9                	srli	a5,a5,0x1a
    80000534:	00b7f463          	bgeu	a5,a1,8000053c <walkaddr+0xc>
    return 0;
    80000538:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000053a:	8082                	ret
{
    8000053c:	1141                	addi	sp,sp,-16
    8000053e:	e406                	sd	ra,8(sp)
    80000540:	e022                	sd	s0,0(sp)
    80000542:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000544:	4601                	li	a2,0
    80000546:	00000097          	auipc	ra,0x0
    8000054a:	f44080e7          	jalr	-188(ra) # 8000048a <walk>
  if(pte == 0)
    8000054e:	c105                	beqz	a0,8000056e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000550:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000552:	0117f693          	andi	a3,a5,17
    80000556:	4745                	li	a4,17
    return 0;
    80000558:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000055a:	00e68663          	beq	a3,a4,80000566 <walkaddr+0x36>
}
    8000055e:	60a2                	ld	ra,8(sp)
    80000560:	6402                	ld	s0,0(sp)
    80000562:	0141                	addi	sp,sp,16
    80000564:	8082                	ret
  pa = PTE2PA(*pte);
    80000566:	00a7d513          	srli	a0,a5,0xa
    8000056a:	0532                	slli	a0,a0,0xc
  return pa;
    8000056c:	bfcd                	j	8000055e <walkaddr+0x2e>
    return 0;
    8000056e:	4501                	li	a0,0
    80000570:	b7fd                	j	8000055e <walkaddr+0x2e>

0000000080000572 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000572:	715d                	addi	sp,sp,-80
    80000574:	e486                	sd	ra,72(sp)
    80000576:	e0a2                	sd	s0,64(sp)
    80000578:	fc26                	sd	s1,56(sp)
    8000057a:	f84a                	sd	s2,48(sp)
    8000057c:	f44e                	sd	s3,40(sp)
    8000057e:	f052                	sd	s4,32(sp)
    80000580:	ec56                	sd	s5,24(sp)
    80000582:	e85a                	sd	s6,16(sp)
    80000584:	e45e                	sd	s7,8(sp)
    80000586:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000588:	03459793          	slli	a5,a1,0x34
    8000058c:	e385                	bnez	a5,800005ac <mappages+0x3a>
    8000058e:	8aaa                	mv	s5,a0
    80000590:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000592:	03461793          	slli	a5,a2,0x34
    80000596:	e39d                	bnez	a5,800005bc <mappages+0x4a>
    panic("mappages: size not aligned");

  if(size == 0)
    80000598:	ca15                	beqz	a2,800005cc <mappages+0x5a>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000059a:	79fd                	lui	s3,0xfffff
    8000059c:	964e                	add	a2,a2,s3
    8000059e:	00b609b3          	add	s3,a2,a1
  a = va;
    800005a2:	892e                	mv	s2,a1
    800005a4:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005a8:	6b85                	lui	s7,0x1
    800005aa:	a091                	j	800005ee <mappages+0x7c>
    panic("mappages: va not aligned");
    800005ac:	00008517          	auipc	a0,0x8
    800005b0:	aac50513          	addi	a0,a0,-1364 # 80008058 <etext+0x58>
    800005b4:	00005097          	auipc	ra,0x5
    800005b8:	7ae080e7          	jalr	1966(ra) # 80005d62 <panic>
    panic("mappages: size not aligned");
    800005bc:	00008517          	auipc	a0,0x8
    800005c0:	abc50513          	addi	a0,a0,-1348 # 80008078 <etext+0x78>
    800005c4:	00005097          	auipc	ra,0x5
    800005c8:	79e080e7          	jalr	1950(ra) # 80005d62 <panic>
    panic("mappages: size");
    800005cc:	00008517          	auipc	a0,0x8
    800005d0:	acc50513          	addi	a0,a0,-1332 # 80008098 <etext+0x98>
    800005d4:	00005097          	auipc	ra,0x5
    800005d8:	78e080e7          	jalr	1934(ra) # 80005d62 <panic>
      panic("mappages: remap");
    800005dc:	00008517          	auipc	a0,0x8
    800005e0:	acc50513          	addi	a0,a0,-1332 # 800080a8 <etext+0xa8>
    800005e4:	00005097          	auipc	ra,0x5
    800005e8:	77e080e7          	jalr	1918(ra) # 80005d62 <panic>
    a += PGSIZE;
    800005ec:	995e                	add	s2,s2,s7
  for(;;){
    800005ee:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005f2:	4605                	li	a2,1
    800005f4:	85ca                	mv	a1,s2
    800005f6:	8556                	mv	a0,s5
    800005f8:	00000097          	auipc	ra,0x0
    800005fc:	e92080e7          	jalr	-366(ra) # 8000048a <walk>
    80000600:	cd19                	beqz	a0,8000061e <mappages+0xac>
    if(*pte & PTE_V)
    80000602:	611c                	ld	a5,0(a0)
    80000604:	8b85                	andi	a5,a5,1
    80000606:	fbf9                	bnez	a5,800005dc <mappages+0x6a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000608:	80b1                	srli	s1,s1,0xc
    8000060a:	04aa                	slli	s1,s1,0xa
    8000060c:	0164e4b3          	or	s1,s1,s6
    80000610:	0014e493          	ori	s1,s1,1
    80000614:	e104                	sd	s1,0(a0)
    if(a == last)
    80000616:	fd391be3          	bne	s2,s3,800005ec <mappages+0x7a>
    pa += PGSIZE;
  }
  return 0;
    8000061a:	4501                	li	a0,0
    8000061c:	a011                	j	80000620 <mappages+0xae>
      return -1;
    8000061e:	557d                	li	a0,-1
}
    80000620:	60a6                	ld	ra,72(sp)
    80000622:	6406                	ld	s0,64(sp)
    80000624:	74e2                	ld	s1,56(sp)
    80000626:	7942                	ld	s2,48(sp)
    80000628:	79a2                	ld	s3,40(sp)
    8000062a:	7a02                	ld	s4,32(sp)
    8000062c:	6ae2                	ld	s5,24(sp)
    8000062e:	6b42                	ld	s6,16(sp)
    80000630:	6ba2                	ld	s7,8(sp)
    80000632:	6161                	addi	sp,sp,80
    80000634:	8082                	ret

0000000080000636 <kvmmap>:
{
    80000636:	1141                	addi	sp,sp,-16
    80000638:	e406                	sd	ra,8(sp)
    8000063a:	e022                	sd	s0,0(sp)
    8000063c:	0800                	addi	s0,sp,16
    8000063e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000640:	86b2                	mv	a3,a2
    80000642:	863e                	mv	a2,a5
    80000644:	00000097          	auipc	ra,0x0
    80000648:	f2e080e7          	jalr	-210(ra) # 80000572 <mappages>
    8000064c:	e509                	bnez	a0,80000656 <kvmmap+0x20>
}
    8000064e:	60a2                	ld	ra,8(sp)
    80000650:	6402                	ld	s0,0(sp)
    80000652:	0141                	addi	sp,sp,16
    80000654:	8082                	ret
    panic("kvmmap");
    80000656:	00008517          	auipc	a0,0x8
    8000065a:	a6250513          	addi	a0,a0,-1438 # 800080b8 <etext+0xb8>
    8000065e:	00005097          	auipc	ra,0x5
    80000662:	704080e7          	jalr	1796(ra) # 80005d62 <panic>

0000000080000666 <kvmmake>:
{
    80000666:	1101                	addi	sp,sp,-32
    80000668:	ec06                	sd	ra,24(sp)
    8000066a:	e822                	sd	s0,16(sp)
    8000066c:	e426                	sd	s1,8(sp)
    8000066e:	e04a                	sd	s2,0(sp)
    80000670:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000672:	00000097          	auipc	ra,0x0
    80000676:	aa6080e7          	jalr	-1370(ra) # 80000118 <kalloc>
    8000067a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000067c:	6605                	lui	a2,0x1
    8000067e:	4581                	li	a1,0
    80000680:	00000097          	auipc	ra,0x0
    80000684:	b1e080e7          	jalr	-1250(ra) # 8000019e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000688:	4719                	li	a4,6
    8000068a:	6685                	lui	a3,0x1
    8000068c:	10000637          	lui	a2,0x10000
    80000690:	100005b7          	lui	a1,0x10000
    80000694:	8526                	mv	a0,s1
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	fa0080e7          	jalr	-96(ra) # 80000636 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000069e:	4719                	li	a4,6
    800006a0:	6685                	lui	a3,0x1
    800006a2:	10001637          	lui	a2,0x10001
    800006a6:	100015b7          	lui	a1,0x10001
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	f8a080e7          	jalr	-118(ra) # 80000636 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b4:	4719                	li	a4,6
    800006b6:	004006b7          	lui	a3,0x400
    800006ba:	0c000637          	lui	a2,0xc000
    800006be:	0c0005b7          	lui	a1,0xc000
    800006c2:	8526                	mv	a0,s1
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	f72080e7          	jalr	-142(ra) # 80000636 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006cc:	00008917          	auipc	s2,0x8
    800006d0:	93490913          	addi	s2,s2,-1740 # 80008000 <etext>
    800006d4:	4729                	li	a4,10
    800006d6:	80008697          	auipc	a3,0x80008
    800006da:	92a68693          	addi	a3,a3,-1750 # 8000 <_entry-0x7fff8000>
    800006de:	4605                	li	a2,1
    800006e0:	067e                	slli	a2,a2,0x1f
    800006e2:	85b2                	mv	a1,a2
    800006e4:	8526                	mv	a0,s1
    800006e6:	00000097          	auipc	ra,0x0
    800006ea:	f50080e7          	jalr	-176(ra) # 80000636 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ee:	4719                	li	a4,6
    800006f0:	46c5                	li	a3,17
    800006f2:	06ee                	slli	a3,a3,0x1b
    800006f4:	412686b3          	sub	a3,a3,s2
    800006f8:	864a                	mv	a2,s2
    800006fa:	85ca                	mv	a1,s2
    800006fc:	8526                	mv	a0,s1
    800006fe:	00000097          	auipc	ra,0x0
    80000702:	f38080e7          	jalr	-200(ra) # 80000636 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000706:	4729                	li	a4,10
    80000708:	6685                	lui	a3,0x1
    8000070a:	00007617          	auipc	a2,0x7
    8000070e:	8f660613          	addi	a2,a2,-1802 # 80007000 <_trampoline>
    80000712:	040005b7          	lui	a1,0x4000
    80000716:	15fd                	addi	a1,a1,-1
    80000718:	05b2                	slli	a1,a1,0xc
    8000071a:	8526                	mv	a0,s1
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	f1a080e7          	jalr	-230(ra) # 80000636 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000724:	8526                	mv	a0,s1
    80000726:	00000097          	auipc	ra,0x0
    8000072a:	63a080e7          	jalr	1594(ra) # 80000d60 <proc_mapstacks>
}
    8000072e:	8526                	mv	a0,s1
    80000730:	60e2                	ld	ra,24(sp)
    80000732:	6442                	ld	s0,16(sp)
    80000734:	64a2                	ld	s1,8(sp)
    80000736:	6902                	ld	s2,0(sp)
    80000738:	6105                	addi	sp,sp,32
    8000073a:	8082                	ret

000000008000073c <kvminit>:
{
    8000073c:	1141                	addi	sp,sp,-16
    8000073e:	e406                	sd	ra,8(sp)
    80000740:	e022                	sd	s0,0(sp)
    80000742:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000744:	00000097          	auipc	ra,0x0
    80000748:	f22080e7          	jalr	-222(ra) # 80000666 <kvmmake>
    8000074c:	00008797          	auipc	a5,0x8
    80000750:	32a7b623          	sd	a0,812(a5) # 80008a78 <kernel_pagetable>
}
    80000754:	60a2                	ld	ra,8(sp)
    80000756:	6402                	ld	s0,0(sp)
    80000758:	0141                	addi	sp,sp,16
    8000075a:	8082                	ret

000000008000075c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000075c:	715d                	addi	sp,sp,-80
    8000075e:	e486                	sd	ra,72(sp)
    80000760:	e0a2                	sd	s0,64(sp)
    80000762:	fc26                	sd	s1,56(sp)
    80000764:	f84a                	sd	s2,48(sp)
    80000766:	f44e                	sd	s3,40(sp)
    80000768:	f052                	sd	s4,32(sp)
    8000076a:	ec56                	sd	s5,24(sp)
    8000076c:	e85a                	sd	s6,16(sp)
    8000076e:	e45e                	sd	s7,8(sp)
    80000770:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000772:	03459793          	slli	a5,a1,0x34
    80000776:	e795                	bnez	a5,800007a2 <uvmunmap+0x46>
    80000778:	8a2a                	mv	s4,a0
    8000077a:	892e                	mv	s2,a1
    8000077c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077e:	0632                	slli	a2,a2,0xc
    80000780:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000784:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000786:	6b05                	lui	s6,0x1
    80000788:	0735e863          	bltu	a1,s3,800007f8 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000078c:	60a6                	ld	ra,72(sp)
    8000078e:	6406                	ld	s0,64(sp)
    80000790:	74e2                	ld	s1,56(sp)
    80000792:	7942                	ld	s2,48(sp)
    80000794:	79a2                	ld	s3,40(sp)
    80000796:	7a02                	ld	s4,32(sp)
    80000798:	6ae2                	ld	s5,24(sp)
    8000079a:	6b42                	ld	s6,16(sp)
    8000079c:	6ba2                	ld	s7,8(sp)
    8000079e:	6161                	addi	sp,sp,80
    800007a0:	8082                	ret
    panic("uvmunmap: not aligned");
    800007a2:	00008517          	auipc	a0,0x8
    800007a6:	91e50513          	addi	a0,a0,-1762 # 800080c0 <etext+0xc0>
    800007aa:	00005097          	auipc	ra,0x5
    800007ae:	5b8080e7          	jalr	1464(ra) # 80005d62 <panic>
      panic("uvmunmap: walk");
    800007b2:	00008517          	auipc	a0,0x8
    800007b6:	92650513          	addi	a0,a0,-1754 # 800080d8 <etext+0xd8>
    800007ba:	00005097          	auipc	ra,0x5
    800007be:	5a8080e7          	jalr	1448(ra) # 80005d62 <panic>
      panic("uvmunmap: not mapped");
    800007c2:	00008517          	auipc	a0,0x8
    800007c6:	92650513          	addi	a0,a0,-1754 # 800080e8 <etext+0xe8>
    800007ca:	00005097          	auipc	ra,0x5
    800007ce:	598080e7          	jalr	1432(ra) # 80005d62 <panic>
      panic("uvmunmap: not a leaf");
    800007d2:	00008517          	auipc	a0,0x8
    800007d6:	92e50513          	addi	a0,a0,-1746 # 80008100 <etext+0x100>
    800007da:	00005097          	auipc	ra,0x5
    800007de:	588080e7          	jalr	1416(ra) # 80005d62 <panic>
      uint64 pa = PTE2PA(*pte);
    800007e2:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e4:	0532                	slli	a0,a0,0xc
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	836080e7          	jalr	-1994(ra) # 8000001c <kfree>
    *pte = 0;
    800007ee:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007f2:	995a                	add	s2,s2,s6
    800007f4:	f9397ce3          	bgeu	s2,s3,8000078c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f8:	4601                	li	a2,0
    800007fa:	85ca                	mv	a1,s2
    800007fc:	8552                	mv	a0,s4
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	c8c080e7          	jalr	-884(ra) # 8000048a <walk>
    80000806:	84aa                	mv	s1,a0
    80000808:	d54d                	beqz	a0,800007b2 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000080a:	6108                	ld	a0,0(a0)
    8000080c:	00157793          	andi	a5,a0,1
    80000810:	dbcd                	beqz	a5,800007c2 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000812:	3ff57793          	andi	a5,a0,1023
    80000816:	fb778ee3          	beq	a5,s7,800007d2 <uvmunmap+0x76>
    if(do_free){
    8000081a:	fc0a8ae3          	beqz	s5,800007ee <uvmunmap+0x92>
    8000081e:	b7d1                	j	800007e2 <uvmunmap+0x86>

0000000080000820 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000820:	1101                	addi	sp,sp,-32
    80000822:	ec06                	sd	ra,24(sp)
    80000824:	e822                	sd	s0,16(sp)
    80000826:	e426                	sd	s1,8(sp)
    80000828:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	8ee080e7          	jalr	-1810(ra) # 80000118 <kalloc>
    80000832:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000834:	c519                	beqz	a0,80000842 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	964080e7          	jalr	-1692(ra) # 8000019e <memset>
  return pagetable;
}
    80000842:	8526                	mv	a0,s1
    80000844:	60e2                	ld	ra,24(sp)
    80000846:	6442                	ld	s0,16(sp)
    80000848:	64a2                	ld	s1,8(sp)
    8000084a:	6105                	addi	sp,sp,32
    8000084c:	8082                	ret

000000008000084e <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084e:	7179                	addi	sp,sp,-48
    80000850:	f406                	sd	ra,40(sp)
    80000852:	f022                	sd	s0,32(sp)
    80000854:	ec26                	sd	s1,24(sp)
    80000856:	e84a                	sd	s2,16(sp)
    80000858:	e44e                	sd	s3,8(sp)
    8000085a:	e052                	sd	s4,0(sp)
    8000085c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085e:	6785                	lui	a5,0x1
    80000860:	04f67863          	bgeu	a2,a5,800008b0 <uvmfirst+0x62>
    80000864:	8a2a                	mv	s4,a0
    80000866:	89ae                	mv	s3,a1
    80000868:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000086a:	00000097          	auipc	ra,0x0
    8000086e:	8ae080e7          	jalr	-1874(ra) # 80000118 <kalloc>
    80000872:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000874:	6605                	lui	a2,0x1
    80000876:	4581                	li	a1,0
    80000878:	00000097          	auipc	ra,0x0
    8000087c:	926080e7          	jalr	-1754(ra) # 8000019e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000880:	4779                	li	a4,30
    80000882:	86ca                	mv	a3,s2
    80000884:	6605                	lui	a2,0x1
    80000886:	4581                	li	a1,0
    80000888:	8552                	mv	a0,s4
    8000088a:	00000097          	auipc	ra,0x0
    8000088e:	ce8080e7          	jalr	-792(ra) # 80000572 <mappages>
  memmove(mem, src, sz);
    80000892:	8626                	mv	a2,s1
    80000894:	85ce                	mv	a1,s3
    80000896:	854a                	mv	a0,s2
    80000898:	00000097          	auipc	ra,0x0
    8000089c:	966080e7          	jalr	-1690(ra) # 800001fe <memmove>
}
    800008a0:	70a2                	ld	ra,40(sp)
    800008a2:	7402                	ld	s0,32(sp)
    800008a4:	64e2                	ld	s1,24(sp)
    800008a6:	6942                	ld	s2,16(sp)
    800008a8:	69a2                	ld	s3,8(sp)
    800008aa:	6a02                	ld	s4,0(sp)
    800008ac:	6145                	addi	sp,sp,48
    800008ae:	8082                	ret
    panic("uvmfirst: more than a page");
    800008b0:	00008517          	auipc	a0,0x8
    800008b4:	86850513          	addi	a0,a0,-1944 # 80008118 <etext+0x118>
    800008b8:	00005097          	auipc	ra,0x5
    800008bc:	4aa080e7          	jalr	1194(ra) # 80005d62 <panic>

00000000800008c0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008c0:	1101                	addi	sp,sp,-32
    800008c2:	ec06                	sd	ra,24(sp)
    800008c4:	e822                	sd	s0,16(sp)
    800008c6:	e426                	sd	s1,8(sp)
    800008c8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008ca:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008cc:	00b67d63          	bgeu	a2,a1,800008e6 <uvmdealloc+0x26>
    800008d0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1
    800008d6:	00f60733          	add	a4,a2,a5
    800008da:	767d                	lui	a2,0xfffff
    800008dc:	8f71                	and	a4,a4,a2
    800008de:	97ae                	add	a5,a5,a1
    800008e0:	8ff1                	and	a5,a5,a2
    800008e2:	00f76863          	bltu	a4,a5,800008f2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e6:	8526                	mv	a0,s1
    800008e8:	60e2                	ld	ra,24(sp)
    800008ea:	6442                	ld	s0,16(sp)
    800008ec:	64a2                	ld	s1,8(sp)
    800008ee:	6105                	addi	sp,sp,32
    800008f0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008f2:	8f99                	sub	a5,a5,a4
    800008f4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f6:	4685                	li	a3,1
    800008f8:	0007861b          	sext.w	a2,a5
    800008fc:	85ba                	mv	a1,a4
    800008fe:	00000097          	auipc	ra,0x0
    80000902:	e5e080e7          	jalr	-418(ra) # 8000075c <uvmunmap>
    80000906:	b7c5                	j	800008e6 <uvmdealloc+0x26>

0000000080000908 <uvmalloc>:
  if(newsz < oldsz)
    80000908:	0ab66563          	bltu	a2,a1,800009b2 <uvmalloc+0xaa>
{
    8000090c:	7139                	addi	sp,sp,-64
    8000090e:	fc06                	sd	ra,56(sp)
    80000910:	f822                	sd	s0,48(sp)
    80000912:	f426                	sd	s1,40(sp)
    80000914:	f04a                	sd	s2,32(sp)
    80000916:	ec4e                	sd	s3,24(sp)
    80000918:	e852                	sd	s4,16(sp)
    8000091a:	e456                	sd	s5,8(sp)
    8000091c:	e05a                	sd	s6,0(sp)
    8000091e:	0080                	addi	s0,sp,64
    80000920:	8aaa                	mv	s5,a0
    80000922:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000924:	6985                	lui	s3,0x1
    80000926:	19fd                	addi	s3,s3,-1
    80000928:	95ce                	add	a1,a1,s3
    8000092a:	79fd                	lui	s3,0xfffff
    8000092c:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000930:	08c9f363          	bgeu	s3,a2,800009b6 <uvmalloc+0xae>
    80000934:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000936:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000093a:	fffff097          	auipc	ra,0xfffff
    8000093e:	7de080e7          	jalr	2014(ra) # 80000118 <kalloc>
    80000942:	84aa                	mv	s1,a0
    if(mem == 0){
    80000944:	c51d                	beqz	a0,80000972 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000946:	6605                	lui	a2,0x1
    80000948:	4581                	li	a1,0
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	854080e7          	jalr	-1964(ra) # 8000019e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000952:	875a                	mv	a4,s6
    80000954:	86a6                	mv	a3,s1
    80000956:	6605                	lui	a2,0x1
    80000958:	85ca                	mv	a1,s2
    8000095a:	8556                	mv	a0,s5
    8000095c:	00000097          	auipc	ra,0x0
    80000960:	c16080e7          	jalr	-1002(ra) # 80000572 <mappages>
    80000964:	e90d                	bnez	a0,80000996 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000966:	6785                	lui	a5,0x1
    80000968:	993e                	add	s2,s2,a5
    8000096a:	fd4968e3          	bltu	s2,s4,8000093a <uvmalloc+0x32>
  return newsz;
    8000096e:	8552                	mv	a0,s4
    80000970:	a809                	j	80000982 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000972:	864e                	mv	a2,s3
    80000974:	85ca                	mv	a1,s2
    80000976:	8556                	mv	a0,s5
    80000978:	00000097          	auipc	ra,0x0
    8000097c:	f48080e7          	jalr	-184(ra) # 800008c0 <uvmdealloc>
      return 0;
    80000980:	4501                	li	a0,0
}
    80000982:	70e2                	ld	ra,56(sp)
    80000984:	7442                	ld	s0,48(sp)
    80000986:	74a2                	ld	s1,40(sp)
    80000988:	7902                	ld	s2,32(sp)
    8000098a:	69e2                	ld	s3,24(sp)
    8000098c:	6a42                	ld	s4,16(sp)
    8000098e:	6aa2                	ld	s5,8(sp)
    80000990:	6b02                	ld	s6,0(sp)
    80000992:	6121                	addi	sp,sp,64
    80000994:	8082                	ret
      kfree(mem);
    80000996:	8526                	mv	a0,s1
    80000998:	fffff097          	auipc	ra,0xfffff
    8000099c:	684080e7          	jalr	1668(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009a0:	864e                	mv	a2,s3
    800009a2:	85ca                	mv	a1,s2
    800009a4:	8556                	mv	a0,s5
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	f1a080e7          	jalr	-230(ra) # 800008c0 <uvmdealloc>
      return 0;
    800009ae:	4501                	li	a0,0
    800009b0:	bfc9                	j	80000982 <uvmalloc+0x7a>
    return oldsz;
    800009b2:	852e                	mv	a0,a1
}
    800009b4:	8082                	ret
  return newsz;
    800009b6:	8532                	mv	a0,a2
    800009b8:	b7e9                	j	80000982 <uvmalloc+0x7a>

00000000800009ba <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009ba:	7179                	addi	sp,sp,-48
    800009bc:	f406                	sd	ra,40(sp)
    800009be:	f022                	sd	s0,32(sp)
    800009c0:	ec26                	sd	s1,24(sp)
    800009c2:	e84a                	sd	s2,16(sp)
    800009c4:	e44e                	sd	s3,8(sp)
    800009c6:	e052                	sd	s4,0(sp)
    800009c8:	1800                	addi	s0,sp,48
    800009ca:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009cc:	84aa                	mv	s1,a0
    800009ce:	6905                	lui	s2,0x1
    800009d0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d2:	4985                	li	s3,1
    800009d4:	a821                	j	800009ec <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009d6:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009d8:	0532                	slli	a0,a0,0xc
    800009da:	00000097          	auipc	ra,0x0
    800009de:	fe0080e7          	jalr	-32(ra) # 800009ba <freewalk>
      pagetable[i] = 0;
    800009e2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009e6:	04a1                	addi	s1,s1,8
    800009e8:	03248163          	beq	s1,s2,80000a0a <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009ec:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ee:	00f57793          	andi	a5,a0,15
    800009f2:	ff3782e3          	beq	a5,s3,800009d6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009f6:	8905                	andi	a0,a0,1
    800009f8:	d57d                	beqz	a0,800009e6 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009fa:	00007517          	auipc	a0,0x7
    800009fe:	73e50513          	addi	a0,a0,1854 # 80008138 <etext+0x138>
    80000a02:	00005097          	auipc	ra,0x5
    80000a06:	360080e7          	jalr	864(ra) # 80005d62 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a0a:	8552                	mv	a0,s4
    80000a0c:	fffff097          	auipc	ra,0xfffff
    80000a10:	610080e7          	jalr	1552(ra) # 8000001c <kfree>
}
    80000a14:	70a2                	ld	ra,40(sp)
    80000a16:	7402                	ld	s0,32(sp)
    80000a18:	64e2                	ld	s1,24(sp)
    80000a1a:	6942                	ld	s2,16(sp)
    80000a1c:	69a2                	ld	s3,8(sp)
    80000a1e:	6a02                	ld	s4,0(sp)
    80000a20:	6145                	addi	sp,sp,48
    80000a22:	8082                	ret

0000000080000a24 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a24:	1101                	addi	sp,sp,-32
    80000a26:	ec06                	sd	ra,24(sp)
    80000a28:	e822                	sd	s0,16(sp)
    80000a2a:	e426                	sd	s1,8(sp)
    80000a2c:	1000                	addi	s0,sp,32
    80000a2e:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a30:	e999                	bnez	a1,80000a46 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a32:	8526                	mv	a0,s1
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	f86080e7          	jalr	-122(ra) # 800009ba <freewalk>
}
    80000a3c:	60e2                	ld	ra,24(sp)
    80000a3e:	6442                	ld	s0,16(sp)
    80000a40:	64a2                	ld	s1,8(sp)
    80000a42:	6105                	addi	sp,sp,32
    80000a44:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a46:	6605                	lui	a2,0x1
    80000a48:	167d                	addi	a2,a2,-1
    80000a4a:	962e                	add	a2,a2,a1
    80000a4c:	4685                	li	a3,1
    80000a4e:	8231                	srli	a2,a2,0xc
    80000a50:	4581                	li	a1,0
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	d0a080e7          	jalr	-758(ra) # 8000075c <uvmunmap>
    80000a5a:	bfe1                	j	80000a32 <uvmfree+0xe>

0000000080000a5c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a5c:	c679                	beqz	a2,80000b2a <uvmcopy+0xce>
{
    80000a5e:	715d                	addi	sp,sp,-80
    80000a60:	e486                	sd	ra,72(sp)
    80000a62:	e0a2                	sd	s0,64(sp)
    80000a64:	fc26                	sd	s1,56(sp)
    80000a66:	f84a                	sd	s2,48(sp)
    80000a68:	f44e                	sd	s3,40(sp)
    80000a6a:	f052                	sd	s4,32(sp)
    80000a6c:	ec56                	sd	s5,24(sp)
    80000a6e:	e85a                	sd	s6,16(sp)
    80000a70:	e45e                	sd	s7,8(sp)
    80000a72:	0880                	addi	s0,sp,80
    80000a74:	8b2a                	mv	s6,a0
    80000a76:	8aae                	mv	s5,a1
    80000a78:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a7a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a7c:	4601                	li	a2,0
    80000a7e:	85ce                	mv	a1,s3
    80000a80:	855a                	mv	a0,s6
    80000a82:	00000097          	auipc	ra,0x0
    80000a86:	a08080e7          	jalr	-1528(ra) # 8000048a <walk>
    80000a8a:	c531                	beqz	a0,80000ad6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a8c:	6118                	ld	a4,0(a0)
    80000a8e:	00177793          	andi	a5,a4,1
    80000a92:	cbb1                	beqz	a5,80000ae6 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a94:	00a75593          	srli	a1,a4,0xa
    80000a98:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a9c:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000aa0:	fffff097          	auipc	ra,0xfffff
    80000aa4:	678080e7          	jalr	1656(ra) # 80000118 <kalloc>
    80000aa8:	892a                	mv	s2,a0
    80000aaa:	c939                	beqz	a0,80000b00 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aac:	6605                	lui	a2,0x1
    80000aae:	85de                	mv	a1,s7
    80000ab0:	fffff097          	auipc	ra,0xfffff
    80000ab4:	74e080e7          	jalr	1870(ra) # 800001fe <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000ab8:	8726                	mv	a4,s1
    80000aba:	86ca                	mv	a3,s2
    80000abc:	6605                	lui	a2,0x1
    80000abe:	85ce                	mv	a1,s3
    80000ac0:	8556                	mv	a0,s5
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	ab0080e7          	jalr	-1360(ra) # 80000572 <mappages>
    80000aca:	e515                	bnez	a0,80000af6 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000acc:	6785                	lui	a5,0x1
    80000ace:	99be                	add	s3,s3,a5
    80000ad0:	fb49e6e3          	bltu	s3,s4,80000a7c <uvmcopy+0x20>
    80000ad4:	a081                	j	80000b14 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ad6:	00007517          	auipc	a0,0x7
    80000ada:	67250513          	addi	a0,a0,1650 # 80008148 <etext+0x148>
    80000ade:	00005097          	auipc	ra,0x5
    80000ae2:	284080e7          	jalr	644(ra) # 80005d62 <panic>
      panic("uvmcopy: page not present");
    80000ae6:	00007517          	auipc	a0,0x7
    80000aea:	68250513          	addi	a0,a0,1666 # 80008168 <etext+0x168>
    80000aee:	00005097          	auipc	ra,0x5
    80000af2:	274080e7          	jalr	628(ra) # 80005d62 <panic>
      kfree(mem);
    80000af6:	854a                	mv	a0,s2
    80000af8:	fffff097          	auipc	ra,0xfffff
    80000afc:	524080e7          	jalr	1316(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b00:	4685                	li	a3,1
    80000b02:	00c9d613          	srli	a2,s3,0xc
    80000b06:	4581                	li	a1,0
    80000b08:	8556                	mv	a0,s5
    80000b0a:	00000097          	auipc	ra,0x0
    80000b0e:	c52080e7          	jalr	-942(ra) # 8000075c <uvmunmap>
  return -1;
    80000b12:	557d                	li	a0,-1
}
    80000b14:	60a6                	ld	ra,72(sp)
    80000b16:	6406                	ld	s0,64(sp)
    80000b18:	74e2                	ld	s1,56(sp)
    80000b1a:	7942                	ld	s2,48(sp)
    80000b1c:	79a2                	ld	s3,40(sp)
    80000b1e:	7a02                	ld	s4,32(sp)
    80000b20:	6ae2                	ld	s5,24(sp)
    80000b22:	6b42                	ld	s6,16(sp)
    80000b24:	6ba2                	ld	s7,8(sp)
    80000b26:	6161                	addi	sp,sp,80
    80000b28:	8082                	ret
  return 0;
    80000b2a:	4501                	li	a0,0
}
    80000b2c:	8082                	ret

0000000080000b2e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b2e:	1141                	addi	sp,sp,-16
    80000b30:	e406                	sd	ra,8(sp)
    80000b32:	e022                	sd	s0,0(sp)
    80000b34:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b36:	4601                	li	a2,0
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	952080e7          	jalr	-1710(ra) # 8000048a <walk>
  if(pte == 0)
    80000b40:	c901                	beqz	a0,80000b50 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b42:	611c                	ld	a5,0(a0)
    80000b44:	9bbd                	andi	a5,a5,-17
    80000b46:	e11c                	sd	a5,0(a0)
}
    80000b48:	60a2                	ld	ra,8(sp)
    80000b4a:	6402                	ld	s0,0(sp)
    80000b4c:	0141                	addi	sp,sp,16
    80000b4e:	8082                	ret
    panic("uvmclear");
    80000b50:	00007517          	auipc	a0,0x7
    80000b54:	63850513          	addi	a0,a0,1592 # 80008188 <etext+0x188>
    80000b58:	00005097          	auipc	ra,0x5
    80000b5c:	20a080e7          	jalr	522(ra) # 80005d62 <panic>

0000000080000b60 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b60:	cac9                	beqz	a3,80000bf2 <copyout+0x92>
{
    80000b62:	711d                	addi	sp,sp,-96
    80000b64:	ec86                	sd	ra,88(sp)
    80000b66:	e8a2                	sd	s0,80(sp)
    80000b68:	e4a6                	sd	s1,72(sp)
    80000b6a:	e0ca                	sd	s2,64(sp)
    80000b6c:	fc4e                	sd	s3,56(sp)
    80000b6e:	f852                	sd	s4,48(sp)
    80000b70:	f456                	sd	s5,40(sp)
    80000b72:	f05a                	sd	s6,32(sp)
    80000b74:	ec5e                	sd	s7,24(sp)
    80000b76:	e862                	sd	s8,16(sp)
    80000b78:	e466                	sd	s9,8(sp)
    80000b7a:	e06a                	sd	s10,0(sp)
    80000b7c:	1080                	addi	s0,sp,96
    80000b7e:	8baa                	mv	s7,a0
    80000b80:	8aae                	mv	s5,a1
    80000b82:	8b32                	mv	s6,a2
    80000b84:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b86:	74fd                	lui	s1,0xfffff
    80000b88:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000b8a:	57fd                	li	a5,-1
    80000b8c:	83e9                	srli	a5,a5,0x1a
    80000b8e:	0697e463          	bltu	a5,s1,80000bf6 <copyout+0x96>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b92:	4cd5                	li	s9,21
    80000b94:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000b96:	8c3e                	mv	s8,a5
    80000b98:	a035                	j	80000bc4 <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b9a:	83a9                	srli	a5,a5,0xa
    80000b9c:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b9e:	409a8533          	sub	a0,s5,s1
    80000ba2:	0009061b          	sext.w	a2,s2
    80000ba6:	85da                	mv	a1,s6
    80000ba8:	953e                	add	a0,a0,a5
    80000baa:	fffff097          	auipc	ra,0xfffff
    80000bae:	654080e7          	jalr	1620(ra) # 800001fe <memmove>

    len -= n;
    80000bb2:	412989b3          	sub	s3,s3,s2
    src += n;
    80000bb6:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000bb8:	02098b63          	beqz	s3,80000bee <copyout+0x8e>
    if(va0 >= MAXVA)
    80000bbc:	034c6f63          	bltu	s8,s4,80000bfa <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000bc0:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000bc2:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000bc4:	4601                	li	a2,0
    80000bc6:	85a6                	mv	a1,s1
    80000bc8:	855e                	mv	a0,s7
    80000bca:	00000097          	auipc	ra,0x0
    80000bce:	8c0080e7          	jalr	-1856(ra) # 8000048a <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bd2:	c515                	beqz	a0,80000bfe <copyout+0x9e>
    80000bd4:	611c                	ld	a5,0(a0)
    80000bd6:	0157f713          	andi	a4,a5,21
    80000bda:	05971163          	bne	a4,s9,80000c1c <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80000bde:	01a48a33          	add	s4,s1,s10
    80000be2:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000be6:	fb29fae3          	bgeu	s3,s2,80000b9a <copyout+0x3a>
    80000bea:	894e                	mv	s2,s3
    80000bec:	b77d                	j	80000b9a <copyout+0x3a>
  }
  return 0;
    80000bee:	4501                	li	a0,0
    80000bf0:	a801                	j	80000c00 <copyout+0xa0>
    80000bf2:	4501                	li	a0,0
}
    80000bf4:	8082                	ret
      return -1;
    80000bf6:	557d                	li	a0,-1
    80000bf8:	a021                	j	80000c00 <copyout+0xa0>
    80000bfa:	557d                	li	a0,-1
    80000bfc:	a011                	j	80000c00 <copyout+0xa0>
      return -1;
    80000bfe:	557d                	li	a0,-1
}
    80000c00:	60e6                	ld	ra,88(sp)
    80000c02:	6446                	ld	s0,80(sp)
    80000c04:	64a6                	ld	s1,72(sp)
    80000c06:	6906                	ld	s2,64(sp)
    80000c08:	79e2                	ld	s3,56(sp)
    80000c0a:	7a42                	ld	s4,48(sp)
    80000c0c:	7aa2                	ld	s5,40(sp)
    80000c0e:	7b02                	ld	s6,32(sp)
    80000c10:	6be2                	ld	s7,24(sp)
    80000c12:	6c42                	ld	s8,16(sp)
    80000c14:	6ca2                	ld	s9,8(sp)
    80000c16:	6d02                	ld	s10,0(sp)
    80000c18:	6125                	addi	sp,sp,96
    80000c1a:	8082                	ret
      return -1;
    80000c1c:	557d                	li	a0,-1
    80000c1e:	b7cd                	j	80000c00 <copyout+0xa0>

0000000080000c20 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c20:	c6bd                	beqz	a3,80000c8e <copyin+0x6e>
{
    80000c22:	715d                	addi	sp,sp,-80
    80000c24:	e486                	sd	ra,72(sp)
    80000c26:	e0a2                	sd	s0,64(sp)
    80000c28:	fc26                	sd	s1,56(sp)
    80000c2a:	f84a                	sd	s2,48(sp)
    80000c2c:	f44e                	sd	s3,40(sp)
    80000c2e:	f052                	sd	s4,32(sp)
    80000c30:	ec56                	sd	s5,24(sp)
    80000c32:	e85a                	sd	s6,16(sp)
    80000c34:	e45e                	sd	s7,8(sp)
    80000c36:	e062                	sd	s8,0(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8b2a                	mv	s6,a0
    80000c3c:	8a2e                	mv	s4,a1
    80000c3e:	8c32                	mv	s8,a2
    80000c40:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6a85                	lui	s5,0x1
    80000c46:	a015                	j	80000c6a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c48:	9562                	add	a0,a0,s8
    80000c4a:	0004861b          	sext.w	a2,s1
    80000c4e:	412505b3          	sub	a1,a0,s2
    80000c52:	8552                	mv	a0,s4
    80000c54:	fffff097          	auipc	ra,0xfffff
    80000c58:	5aa080e7          	jalr	1450(ra) # 800001fe <memmove>

    len -= n;
    80000c5c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c60:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c62:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c66:	02098263          	beqz	s3,80000c8a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c6a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c6e:	85ca                	mv	a1,s2
    80000c70:	855a                	mv	a0,s6
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	8be080e7          	jalr	-1858(ra) # 80000530 <walkaddr>
    if(pa0 == 0)
    80000c7a:	cd01                	beqz	a0,80000c92 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c7c:	418904b3          	sub	s1,s2,s8
    80000c80:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c82:	fc99f3e3          	bgeu	s3,s1,80000c48 <copyin+0x28>
    80000c86:	84ce                	mv	s1,s3
    80000c88:	b7c1                	j	80000c48 <copyin+0x28>
  }
  return 0;
    80000c8a:	4501                	li	a0,0
    80000c8c:	a021                	j	80000c94 <copyin+0x74>
    80000c8e:	4501                	li	a0,0
}
    80000c90:	8082                	ret
      return -1;
    80000c92:	557d                	li	a0,-1
}
    80000c94:	60a6                	ld	ra,72(sp)
    80000c96:	6406                	ld	s0,64(sp)
    80000c98:	74e2                	ld	s1,56(sp)
    80000c9a:	7942                	ld	s2,48(sp)
    80000c9c:	79a2                	ld	s3,40(sp)
    80000c9e:	7a02                	ld	s4,32(sp)
    80000ca0:	6ae2                	ld	s5,24(sp)
    80000ca2:	6b42                	ld	s6,16(sp)
    80000ca4:	6ba2                	ld	s7,8(sp)
    80000ca6:	6c02                	ld	s8,0(sp)
    80000ca8:	6161                	addi	sp,sp,80
    80000caa:	8082                	ret

0000000080000cac <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000cac:	c6c5                	beqz	a3,80000d54 <copyinstr+0xa8>
{
    80000cae:	715d                	addi	sp,sp,-80
    80000cb0:	e486                	sd	ra,72(sp)
    80000cb2:	e0a2                	sd	s0,64(sp)
    80000cb4:	fc26                	sd	s1,56(sp)
    80000cb6:	f84a                	sd	s2,48(sp)
    80000cb8:	f44e                	sd	s3,40(sp)
    80000cba:	f052                	sd	s4,32(sp)
    80000cbc:	ec56                	sd	s5,24(sp)
    80000cbe:	e85a                	sd	s6,16(sp)
    80000cc0:	e45e                	sd	s7,8(sp)
    80000cc2:	0880                	addi	s0,sp,80
    80000cc4:	8a2a                	mv	s4,a0
    80000cc6:	8b2e                	mv	s6,a1
    80000cc8:	8bb2                	mv	s7,a2
    80000cca:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000ccc:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cce:	6985                	lui	s3,0x1
    80000cd0:	a035                	j	80000cfc <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cd2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cd6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cd8:	0017b793          	seqz	a5,a5
    80000cdc:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ce0:	60a6                	ld	ra,72(sp)
    80000ce2:	6406                	ld	s0,64(sp)
    80000ce4:	74e2                	ld	s1,56(sp)
    80000ce6:	7942                	ld	s2,48(sp)
    80000ce8:	79a2                	ld	s3,40(sp)
    80000cea:	7a02                	ld	s4,32(sp)
    80000cec:	6ae2                	ld	s5,24(sp)
    80000cee:	6b42                	ld	s6,16(sp)
    80000cf0:	6ba2                	ld	s7,8(sp)
    80000cf2:	6161                	addi	sp,sp,80
    80000cf4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cf6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cfa:	c8a9                	beqz	s1,80000d4c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cfc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d00:	85ca                	mv	a1,s2
    80000d02:	8552                	mv	a0,s4
    80000d04:	00000097          	auipc	ra,0x0
    80000d08:	82c080e7          	jalr	-2004(ra) # 80000530 <walkaddr>
    if(pa0 == 0)
    80000d0c:	c131                	beqz	a0,80000d50 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000d0e:	41790833          	sub	a6,s2,s7
    80000d12:	984e                	add	a6,a6,s3
    if(n > max)
    80000d14:	0104f363          	bgeu	s1,a6,80000d1a <copyinstr+0x6e>
    80000d18:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d1a:	955e                	add	a0,a0,s7
    80000d1c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d20:	fc080be3          	beqz	a6,80000cf6 <copyinstr+0x4a>
    80000d24:	985a                	add	a6,a6,s6
    80000d26:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d28:	41650633          	sub	a2,a0,s6
    80000d2c:	14fd                	addi	s1,s1,-1
    80000d2e:	9b26                	add	s6,s6,s1
    80000d30:	00f60733          	add	a4,a2,a5
    80000d34:	00074703          	lbu	a4,0(a4)
    80000d38:	df49                	beqz	a4,80000cd2 <copyinstr+0x26>
        *dst = *p;
    80000d3a:	00e78023          	sb	a4,0(a5)
      --max;
    80000d3e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d42:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d44:	ff0796e3          	bne	a5,a6,80000d30 <copyinstr+0x84>
      dst++;
    80000d48:	8b42                	mv	s6,a6
    80000d4a:	b775                	j	80000cf6 <copyinstr+0x4a>
    80000d4c:	4781                	li	a5,0
    80000d4e:	b769                	j	80000cd8 <copyinstr+0x2c>
      return -1;
    80000d50:	557d                	li	a0,-1
    80000d52:	b779                	j	80000ce0 <copyinstr+0x34>
  int got_null = 0;
    80000d54:	4781                	li	a5,0
  if(got_null){
    80000d56:	0017b793          	seqz	a5,a5
    80000d5a:	40f00533          	neg	a0,a5
}
    80000d5e:	8082                	ret

0000000080000d60 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d60:	7139                	addi	sp,sp,-64
    80000d62:	fc06                	sd	ra,56(sp)
    80000d64:	f822                	sd	s0,48(sp)
    80000d66:	f426                	sd	s1,40(sp)
    80000d68:	f04a                	sd	s2,32(sp)
    80000d6a:	ec4e                	sd	s3,24(sp)
    80000d6c:	e852                	sd	s4,16(sp)
    80000d6e:	e456                	sd	s5,8(sp)
    80000d70:	e05a                	sd	s6,0(sp)
    80000d72:	0080                	addi	s0,sp,64
    80000d74:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d76:	00008497          	auipc	s1,0x8
    80000d7a:	17a48493          	addi	s1,s1,378 # 80008ef0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d7e:	8b26                	mv	s6,s1
    80000d80:	00007a97          	auipc	s5,0x7
    80000d84:	280a8a93          	addi	s5,s5,640 # 80008000 <etext>
    80000d88:	04000937          	lui	s2,0x4000
    80000d8c:	197d                	addi	s2,s2,-1
    80000d8e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d90:	0000ea17          	auipc	s4,0xe
    80000d94:	d60a0a13          	addi	s4,s4,-672 # 8000eaf0 <tickslock>
    char *pa = kalloc();
    80000d98:	fffff097          	auipc	ra,0xfffff
    80000d9c:	380080e7          	jalr	896(ra) # 80000118 <kalloc>
    80000da0:	862a                	mv	a2,a0
    if(pa == 0)
    80000da2:	c131                	beqz	a0,80000de6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000da4:	416485b3          	sub	a1,s1,s6
    80000da8:	8591                	srai	a1,a1,0x4
    80000daa:	000ab783          	ld	a5,0(s5)
    80000dae:	02f585b3          	mul	a1,a1,a5
    80000db2:	2585                	addiw	a1,a1,1
    80000db4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000db8:	4719                	li	a4,6
    80000dba:	6685                	lui	a3,0x1
    80000dbc:	40b905b3          	sub	a1,s2,a1
    80000dc0:	854e                	mv	a0,s3
    80000dc2:	00000097          	auipc	ra,0x0
    80000dc6:	874080e7          	jalr	-1932(ra) # 80000636 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dca:	17048493          	addi	s1,s1,368
    80000dce:	fd4495e3          	bne	s1,s4,80000d98 <proc_mapstacks+0x38>
  }
}
    80000dd2:	70e2                	ld	ra,56(sp)
    80000dd4:	7442                	ld	s0,48(sp)
    80000dd6:	74a2                	ld	s1,40(sp)
    80000dd8:	7902                	ld	s2,32(sp)
    80000dda:	69e2                	ld	s3,24(sp)
    80000ddc:	6a42                	ld	s4,16(sp)
    80000dde:	6aa2                	ld	s5,8(sp)
    80000de0:	6b02                	ld	s6,0(sp)
    80000de2:	6121                	addi	sp,sp,64
    80000de4:	8082                	ret
      panic("kalloc");
    80000de6:	00007517          	auipc	a0,0x7
    80000dea:	3b250513          	addi	a0,a0,946 # 80008198 <etext+0x198>
    80000dee:	00005097          	auipc	ra,0x5
    80000df2:	f74080e7          	jalr	-140(ra) # 80005d62 <panic>

0000000080000df6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000df6:	7139                	addi	sp,sp,-64
    80000df8:	fc06                	sd	ra,56(sp)
    80000dfa:	f822                	sd	s0,48(sp)
    80000dfc:	f426                	sd	s1,40(sp)
    80000dfe:	f04a                	sd	s2,32(sp)
    80000e00:	ec4e                	sd	s3,24(sp)
    80000e02:	e852                	sd	s4,16(sp)
    80000e04:	e456                	sd	s5,8(sp)
    80000e06:	e05a                	sd	s6,0(sp)
    80000e08:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e0a:	00007597          	auipc	a1,0x7
    80000e0e:	39658593          	addi	a1,a1,918 # 800081a0 <etext+0x1a0>
    80000e12:	00008517          	auipc	a0,0x8
    80000e16:	cae50513          	addi	a0,a0,-850 # 80008ac0 <pid_lock>
    80000e1a:	00005097          	auipc	ra,0x5
    80000e1e:	402080e7          	jalr	1026(ra) # 8000621c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e22:	00007597          	auipc	a1,0x7
    80000e26:	38658593          	addi	a1,a1,902 # 800081a8 <etext+0x1a8>
    80000e2a:	00008517          	auipc	a0,0x8
    80000e2e:	cae50513          	addi	a0,a0,-850 # 80008ad8 <wait_lock>
    80000e32:	00005097          	auipc	ra,0x5
    80000e36:	3ea080e7          	jalr	1002(ra) # 8000621c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e3a:	00008497          	auipc	s1,0x8
    80000e3e:	0b648493          	addi	s1,s1,182 # 80008ef0 <proc>
      initlock(&p->lock, "proc");
    80000e42:	00007b17          	auipc	s6,0x7
    80000e46:	376b0b13          	addi	s6,s6,886 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e4a:	8aa6                	mv	s5,s1
    80000e4c:	00007a17          	auipc	s4,0x7
    80000e50:	1b4a0a13          	addi	s4,s4,436 # 80008000 <etext>
    80000e54:	04000937          	lui	s2,0x4000
    80000e58:	197d                	addi	s2,s2,-1
    80000e5a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e5c:	0000e997          	auipc	s3,0xe
    80000e60:	c9498993          	addi	s3,s3,-876 # 8000eaf0 <tickslock>
      initlock(&p->lock, "proc");
    80000e64:	85da                	mv	a1,s6
    80000e66:	8526                	mv	a0,s1
    80000e68:	00005097          	auipc	ra,0x5
    80000e6c:	3b4080e7          	jalr	948(ra) # 8000621c <initlock>
      p->state = UNUSED;
    80000e70:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e74:	415487b3          	sub	a5,s1,s5
    80000e78:	8791                	srai	a5,a5,0x4
    80000e7a:	000a3703          	ld	a4,0(s4)
    80000e7e:	02e787b3          	mul	a5,a5,a4
    80000e82:	2785                	addiw	a5,a5,1
    80000e84:	00d7979b          	slliw	a5,a5,0xd
    80000e88:	40f907b3          	sub	a5,s2,a5
    80000e8c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e8e:	17048493          	addi	s1,s1,368
    80000e92:	fd3499e3          	bne	s1,s3,80000e64 <procinit+0x6e>
  }
}
    80000e96:	70e2                	ld	ra,56(sp)
    80000e98:	7442                	ld	s0,48(sp)
    80000e9a:	74a2                	ld	s1,40(sp)
    80000e9c:	7902                	ld	s2,32(sp)
    80000e9e:	69e2                	ld	s3,24(sp)
    80000ea0:	6a42                	ld	s4,16(sp)
    80000ea2:	6aa2                	ld	s5,8(sp)
    80000ea4:	6b02                	ld	s6,0(sp)
    80000ea6:	6121                	addi	sp,sp,64
    80000ea8:	8082                	ret

0000000080000eaa <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000eaa:	1141                	addi	sp,sp,-16
    80000eac:	e422                	sd	s0,8(sp)
    80000eae:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000eb0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000eb2:	2501                	sext.w	a0,a0
    80000eb4:	6422                	ld	s0,8(sp)
    80000eb6:	0141                	addi	sp,sp,16
    80000eb8:	8082                	ret

0000000080000eba <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000eba:	1141                	addi	sp,sp,-16
    80000ebc:	e422                	sd	s0,8(sp)
    80000ebe:	0800                	addi	s0,sp,16
    80000ec0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000ec2:	2781                	sext.w	a5,a5
    80000ec4:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ec6:	00008517          	auipc	a0,0x8
    80000eca:	c2a50513          	addi	a0,a0,-982 # 80008af0 <cpus>
    80000ece:	953e                	add	a0,a0,a5
    80000ed0:	6422                	ld	s0,8(sp)
    80000ed2:	0141                	addi	sp,sp,16
    80000ed4:	8082                	ret

0000000080000ed6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000ed6:	1101                	addi	sp,sp,-32
    80000ed8:	ec06                	sd	ra,24(sp)
    80000eda:	e822                	sd	s0,16(sp)
    80000edc:	e426                	sd	s1,8(sp)
    80000ede:	1000                	addi	s0,sp,32
  push_off();
    80000ee0:	00005097          	auipc	ra,0x5
    80000ee4:	380080e7          	jalr	896(ra) # 80006260 <push_off>
    80000ee8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eea:	2781                	sext.w	a5,a5
    80000eec:	079e                	slli	a5,a5,0x7
    80000eee:	00008717          	auipc	a4,0x8
    80000ef2:	bd270713          	addi	a4,a4,-1070 # 80008ac0 <pid_lock>
    80000ef6:	97ba                	add	a5,a5,a4
    80000ef8:	7b84                	ld	s1,48(a5)
  pop_off();
    80000efa:	00005097          	auipc	ra,0x5
    80000efe:	406080e7          	jalr	1030(ra) # 80006300 <pop_off>
  return p;
}
    80000f02:	8526                	mv	a0,s1
    80000f04:	60e2                	ld	ra,24(sp)
    80000f06:	6442                	ld	s0,16(sp)
    80000f08:	64a2                	ld	s1,8(sp)
    80000f0a:	6105                	addi	sp,sp,32
    80000f0c:	8082                	ret

0000000080000f0e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f0e:	1141                	addi	sp,sp,-16
    80000f10:	e406                	sd	ra,8(sp)
    80000f12:	e022                	sd	s0,0(sp)
    80000f14:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	fc0080e7          	jalr	-64(ra) # 80000ed6 <myproc>
    80000f1e:	00005097          	auipc	ra,0x5
    80000f22:	442080e7          	jalr	1090(ra) # 80006360 <release>

  if (first) {
    80000f26:	00008797          	auipc	a5,0x8
    80000f2a:	a2a7a783          	lw	a5,-1494(a5) # 80008950 <first.1681>
    80000f2e:	eb89                	bnez	a5,80000f40 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f30:	00001097          	auipc	ra,0x1
    80000f34:	c92080e7          	jalr	-878(ra) # 80001bc2 <usertrapret>
}
    80000f38:	60a2                	ld	ra,8(sp)
    80000f3a:	6402                	ld	s0,0(sp)
    80000f3c:	0141                	addi	sp,sp,16
    80000f3e:	8082                	ret
    fsinit(ROOTDEV);
    80000f40:	4505                	li	a0,1
    80000f42:	00002097          	auipc	ra,0x2
    80000f46:	aaa080e7          	jalr	-1366(ra) # 800029ec <fsinit>
    first = 0;
    80000f4a:	00008797          	auipc	a5,0x8
    80000f4e:	a007a323          	sw	zero,-1530(a5) # 80008950 <first.1681>
    __sync_synchronize();
    80000f52:	0ff0000f          	fence
    80000f56:	bfe9                	j	80000f30 <forkret+0x22>

0000000080000f58 <allocpid>:
{
    80000f58:	1101                	addi	sp,sp,-32
    80000f5a:	ec06                	sd	ra,24(sp)
    80000f5c:	e822                	sd	s0,16(sp)
    80000f5e:	e426                	sd	s1,8(sp)
    80000f60:	e04a                	sd	s2,0(sp)
    80000f62:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f64:	00008917          	auipc	s2,0x8
    80000f68:	b5c90913          	addi	s2,s2,-1188 # 80008ac0 <pid_lock>
    80000f6c:	854a                	mv	a0,s2
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	33e080e7          	jalr	830(ra) # 800062ac <acquire>
  pid = nextpid;
    80000f76:	00008797          	auipc	a5,0x8
    80000f7a:	9de78793          	addi	a5,a5,-1570 # 80008954 <nextpid>
    80000f7e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f80:	0014871b          	addiw	a4,s1,1
    80000f84:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f86:	854a                	mv	a0,s2
    80000f88:	00005097          	auipc	ra,0x5
    80000f8c:	3d8080e7          	jalr	984(ra) # 80006360 <release>
}
    80000f90:	8526                	mv	a0,s1
    80000f92:	60e2                	ld	ra,24(sp)
    80000f94:	6442                	ld	s0,16(sp)
    80000f96:	64a2                	ld	s1,8(sp)
    80000f98:	6902                	ld	s2,0(sp)
    80000f9a:	6105                	addi	sp,sp,32
    80000f9c:	8082                	ret

0000000080000f9e <proc_pagetable>:
{
    80000f9e:	1101                	addi	sp,sp,-32
    80000fa0:	ec06                	sd	ra,24(sp)
    80000fa2:	e822                	sd	s0,16(sp)
    80000fa4:	e426                	sd	s1,8(sp)
    80000fa6:	e04a                	sd	s2,0(sp)
    80000fa8:	1000                	addi	s0,sp,32
    80000faa:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000fac:	00000097          	auipc	ra,0x0
    80000fb0:	874080e7          	jalr	-1932(ra) # 80000820 <uvmcreate>
    80000fb4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000fb6:	c121                	beqz	a0,80000ff6 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fb8:	4729                	li	a4,10
    80000fba:	00006697          	auipc	a3,0x6
    80000fbe:	04668693          	addi	a3,a3,70 # 80007000 <_trampoline>
    80000fc2:	6605                	lui	a2,0x1
    80000fc4:	040005b7          	lui	a1,0x4000
    80000fc8:	15fd                	addi	a1,a1,-1
    80000fca:	05b2                	slli	a1,a1,0xc
    80000fcc:	fffff097          	auipc	ra,0xfffff
    80000fd0:	5a6080e7          	jalr	1446(ra) # 80000572 <mappages>
    80000fd4:	02054863          	bltz	a0,80001004 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fd8:	4719                	li	a4,6
    80000fda:	05893683          	ld	a3,88(s2)
    80000fde:	6605                	lui	a2,0x1
    80000fe0:	020005b7          	lui	a1,0x2000
    80000fe4:	15fd                	addi	a1,a1,-1
    80000fe6:	05b6                	slli	a1,a1,0xd
    80000fe8:	8526                	mv	a0,s1
    80000fea:	fffff097          	auipc	ra,0xfffff
    80000fee:	588080e7          	jalr	1416(ra) # 80000572 <mappages>
    80000ff2:	02054163          	bltz	a0,80001014 <proc_pagetable+0x76>
}
    80000ff6:	8526                	mv	a0,s1
    80000ff8:	60e2                	ld	ra,24(sp)
    80000ffa:	6442                	ld	s0,16(sp)
    80000ffc:	64a2                	ld	s1,8(sp)
    80000ffe:	6902                	ld	s2,0(sp)
    80001000:	6105                	addi	sp,sp,32
    80001002:	8082                	ret
    uvmfree(pagetable, 0);
    80001004:	4581                	li	a1,0
    80001006:	8526                	mv	a0,s1
    80001008:	00000097          	auipc	ra,0x0
    8000100c:	a1c080e7          	jalr	-1508(ra) # 80000a24 <uvmfree>
    return 0;
    80001010:	4481                	li	s1,0
    80001012:	b7d5                	j	80000ff6 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001014:	4681                	li	a3,0
    80001016:	4605                	li	a2,1
    80001018:	040005b7          	lui	a1,0x4000
    8000101c:	15fd                	addi	a1,a1,-1
    8000101e:	05b2                	slli	a1,a1,0xc
    80001020:	8526                	mv	a0,s1
    80001022:	fffff097          	auipc	ra,0xfffff
    80001026:	73a080e7          	jalr	1850(ra) # 8000075c <uvmunmap>
    uvmfree(pagetable, 0);
    8000102a:	4581                	li	a1,0
    8000102c:	8526                	mv	a0,s1
    8000102e:	00000097          	auipc	ra,0x0
    80001032:	9f6080e7          	jalr	-1546(ra) # 80000a24 <uvmfree>
    return 0;
    80001036:	4481                	li	s1,0
    80001038:	bf7d                	j	80000ff6 <proc_pagetable+0x58>

000000008000103a <proc_freepagetable>:
{
    8000103a:	1101                	addi	sp,sp,-32
    8000103c:	ec06                	sd	ra,24(sp)
    8000103e:	e822                	sd	s0,16(sp)
    80001040:	e426                	sd	s1,8(sp)
    80001042:	e04a                	sd	s2,0(sp)
    80001044:	1000                	addi	s0,sp,32
    80001046:	84aa                	mv	s1,a0
    80001048:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000104a:	4681                	li	a3,0
    8000104c:	4605                	li	a2,1
    8000104e:	040005b7          	lui	a1,0x4000
    80001052:	15fd                	addi	a1,a1,-1
    80001054:	05b2                	slli	a1,a1,0xc
    80001056:	fffff097          	auipc	ra,0xfffff
    8000105a:	706080e7          	jalr	1798(ra) # 8000075c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000105e:	4681                	li	a3,0
    80001060:	4605                	li	a2,1
    80001062:	020005b7          	lui	a1,0x2000
    80001066:	15fd                	addi	a1,a1,-1
    80001068:	05b6                	slli	a1,a1,0xd
    8000106a:	8526                	mv	a0,s1
    8000106c:	fffff097          	auipc	ra,0xfffff
    80001070:	6f0080e7          	jalr	1776(ra) # 8000075c <uvmunmap>
  uvmfree(pagetable, sz);
    80001074:	85ca                	mv	a1,s2
    80001076:	8526                	mv	a0,s1
    80001078:	00000097          	auipc	ra,0x0
    8000107c:	9ac080e7          	jalr	-1620(ra) # 80000a24 <uvmfree>
}
    80001080:	60e2                	ld	ra,24(sp)
    80001082:	6442                	ld	s0,16(sp)
    80001084:	64a2                	ld	s1,8(sp)
    80001086:	6902                	ld	s2,0(sp)
    80001088:	6105                	addi	sp,sp,32
    8000108a:	8082                	ret

000000008000108c <freeproc>:
{
    8000108c:	1101                	addi	sp,sp,-32
    8000108e:	ec06                	sd	ra,24(sp)
    80001090:	e822                	sd	s0,16(sp)
    80001092:	e426                	sd	s1,8(sp)
    80001094:	1000                	addi	s0,sp,32
    80001096:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001098:	6d28                	ld	a0,88(a0)
    8000109a:	c509                	beqz	a0,800010a4 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	f80080e7          	jalr	-128(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800010a4:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800010a8:	68a8                	ld	a0,80(s1)
    800010aa:	c511                	beqz	a0,800010b6 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800010ac:	64ac                	ld	a1,72(s1)
    800010ae:	00000097          	auipc	ra,0x0
    800010b2:	f8c080e7          	jalr	-116(ra) # 8000103a <proc_freepagetable>
  p->pagetable = 0;
    800010b6:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010ba:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010be:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010c2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010c6:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010ca:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010ce:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010d2:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010d6:	0004ac23          	sw	zero,24(s1)
}
    800010da:	60e2                	ld	ra,24(sp)
    800010dc:	6442                	ld	s0,16(sp)
    800010de:	64a2                	ld	s1,8(sp)
    800010e0:	6105                	addi	sp,sp,32
    800010e2:	8082                	ret

00000000800010e4 <allocproc>:
{
    800010e4:	1101                	addi	sp,sp,-32
    800010e6:	ec06                	sd	ra,24(sp)
    800010e8:	e822                	sd	s0,16(sp)
    800010ea:	e426                	sd	s1,8(sp)
    800010ec:	e04a                	sd	s2,0(sp)
    800010ee:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010f0:	00008497          	auipc	s1,0x8
    800010f4:	e0048493          	addi	s1,s1,-512 # 80008ef0 <proc>
    800010f8:	0000e917          	auipc	s2,0xe
    800010fc:	9f890913          	addi	s2,s2,-1544 # 8000eaf0 <tickslock>
    acquire(&p->lock);
    80001100:	8526                	mv	a0,s1
    80001102:	00005097          	auipc	ra,0x5
    80001106:	1aa080e7          	jalr	426(ra) # 800062ac <acquire>
    if(p->state == UNUSED) {
    8000110a:	4c9c                	lw	a5,24(s1)
    8000110c:	cf81                	beqz	a5,80001124 <allocproc+0x40>
      release(&p->lock);
    8000110e:	8526                	mv	a0,s1
    80001110:	00005097          	auipc	ra,0x5
    80001114:	250080e7          	jalr	592(ra) # 80006360 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001118:	17048493          	addi	s1,s1,368
    8000111c:	ff2492e3          	bne	s1,s2,80001100 <allocproc+0x1c>
  return 0;
    80001120:	4481                	li	s1,0
    80001122:	a889                	j	80001174 <allocproc+0x90>
  p->pid = allocpid();
    80001124:	00000097          	auipc	ra,0x0
    80001128:	e34080e7          	jalr	-460(ra) # 80000f58 <allocpid>
    8000112c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000112e:	4785                	li	a5,1
    80001130:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001132:	fffff097          	auipc	ra,0xfffff
    80001136:	fe6080e7          	jalr	-26(ra) # 80000118 <kalloc>
    8000113a:	892a                	mv	s2,a0
    8000113c:	eca8                	sd	a0,88(s1)
    8000113e:	c131                	beqz	a0,80001182 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001140:	8526                	mv	a0,s1
    80001142:	00000097          	auipc	ra,0x0
    80001146:	e5c080e7          	jalr	-420(ra) # 80000f9e <proc_pagetable>
    8000114a:	892a                	mv	s2,a0
    8000114c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000114e:	c531                	beqz	a0,8000119a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001150:	07000613          	li	a2,112
    80001154:	4581                	li	a1,0
    80001156:	06048513          	addi	a0,s1,96
    8000115a:	fffff097          	auipc	ra,0xfffff
    8000115e:	044080e7          	jalr	68(ra) # 8000019e <memset>
  p->context.ra = (uint64)forkret;
    80001162:	00000797          	auipc	a5,0x0
    80001166:	dac78793          	addi	a5,a5,-596 # 80000f0e <forkret>
    8000116a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000116c:	60bc                	ld	a5,64(s1)
    8000116e:	6705                	lui	a4,0x1
    80001170:	97ba                	add	a5,a5,a4
    80001172:	f4bc                	sd	a5,104(s1)
}
    80001174:	8526                	mv	a0,s1
    80001176:	60e2                	ld	ra,24(sp)
    80001178:	6442                	ld	s0,16(sp)
    8000117a:	64a2                	ld	s1,8(sp)
    8000117c:	6902                	ld	s2,0(sp)
    8000117e:	6105                	addi	sp,sp,32
    80001180:	8082                	ret
    freeproc(p);
    80001182:	8526                	mv	a0,s1
    80001184:	00000097          	auipc	ra,0x0
    80001188:	f08080e7          	jalr	-248(ra) # 8000108c <freeproc>
    release(&p->lock);
    8000118c:	8526                	mv	a0,s1
    8000118e:	00005097          	auipc	ra,0x5
    80001192:	1d2080e7          	jalr	466(ra) # 80006360 <release>
    return 0;
    80001196:	84ca                	mv	s1,s2
    80001198:	bff1                	j	80001174 <allocproc+0x90>
    freeproc(p);
    8000119a:	8526                	mv	a0,s1
    8000119c:	00000097          	auipc	ra,0x0
    800011a0:	ef0080e7          	jalr	-272(ra) # 8000108c <freeproc>
    release(&p->lock);
    800011a4:	8526                	mv	a0,s1
    800011a6:	00005097          	auipc	ra,0x5
    800011aa:	1ba080e7          	jalr	442(ra) # 80006360 <release>
    return 0;
    800011ae:	84ca                	mv	s1,s2
    800011b0:	b7d1                	j	80001174 <allocproc+0x90>

00000000800011b2 <userinit>:
{
    800011b2:	1101                	addi	sp,sp,-32
    800011b4:	ec06                	sd	ra,24(sp)
    800011b6:	e822                	sd	s0,16(sp)
    800011b8:	e426                	sd	s1,8(sp)
    800011ba:	1000                	addi	s0,sp,32
  p = allocproc();
    800011bc:	00000097          	auipc	ra,0x0
    800011c0:	f28080e7          	jalr	-216(ra) # 800010e4 <allocproc>
    800011c4:	84aa                	mv	s1,a0
  initproc = p;
    800011c6:	00008797          	auipc	a5,0x8
    800011ca:	8aa7bd23          	sd	a0,-1862(a5) # 80008a80 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011ce:	03400613          	li	a2,52
    800011d2:	00007597          	auipc	a1,0x7
    800011d6:	78e58593          	addi	a1,a1,1934 # 80008960 <initcode>
    800011da:	6928                	ld	a0,80(a0)
    800011dc:	fffff097          	auipc	ra,0xfffff
    800011e0:	672080e7          	jalr	1650(ra) # 8000084e <uvmfirst>
  p->sz = PGSIZE;
    800011e4:	6785                	lui	a5,0x1
    800011e6:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011e8:	6cb8                	ld	a4,88(s1)
    800011ea:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011ee:	6cb8                	ld	a4,88(s1)
    800011f0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011f2:	4641                	li	a2,16
    800011f4:	00007597          	auipc	a1,0x7
    800011f8:	fcc58593          	addi	a1,a1,-52 # 800081c0 <etext+0x1c0>
    800011fc:	15848513          	addi	a0,s1,344
    80001200:	fffff097          	auipc	ra,0xfffff
    80001204:	0f0080e7          	jalr	240(ra) # 800002f0 <safestrcpy>
  p->cwd = namei("/");
    80001208:	00007517          	auipc	a0,0x7
    8000120c:	fc850513          	addi	a0,a0,-56 # 800081d0 <etext+0x1d0>
    80001210:	00002097          	auipc	ra,0x2
    80001214:	1fe080e7          	jalr	510(ra) # 8000340e <namei>
    80001218:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000121c:	478d                	li	a5,3
    8000121e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001220:	8526                	mv	a0,s1
    80001222:	00005097          	auipc	ra,0x5
    80001226:	13e080e7          	jalr	318(ra) # 80006360 <release>
}
    8000122a:	60e2                	ld	ra,24(sp)
    8000122c:	6442                	ld	s0,16(sp)
    8000122e:	64a2                	ld	s1,8(sp)
    80001230:	6105                	addi	sp,sp,32
    80001232:	8082                	ret

0000000080001234 <growproc>:
{
    80001234:	1101                	addi	sp,sp,-32
    80001236:	ec06                	sd	ra,24(sp)
    80001238:	e822                	sd	s0,16(sp)
    8000123a:	e426                	sd	s1,8(sp)
    8000123c:	e04a                	sd	s2,0(sp)
    8000123e:	1000                	addi	s0,sp,32
    80001240:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001242:	00000097          	auipc	ra,0x0
    80001246:	c94080e7          	jalr	-876(ra) # 80000ed6 <myproc>
    8000124a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000124c:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000124e:	01204c63          	bgtz	s2,80001266 <growproc+0x32>
  } else if(n < 0){
    80001252:	02094663          	bltz	s2,8000127e <growproc+0x4a>
  p->sz = sz;
    80001256:	e4ac                	sd	a1,72(s1)
  return 0;
    80001258:	4501                	li	a0,0
}
    8000125a:	60e2                	ld	ra,24(sp)
    8000125c:	6442                	ld	s0,16(sp)
    8000125e:	64a2                	ld	s1,8(sp)
    80001260:	6902                	ld	s2,0(sp)
    80001262:	6105                	addi	sp,sp,32
    80001264:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001266:	4691                	li	a3,4
    80001268:	00b90633          	add	a2,s2,a1
    8000126c:	6928                	ld	a0,80(a0)
    8000126e:	fffff097          	auipc	ra,0xfffff
    80001272:	69a080e7          	jalr	1690(ra) # 80000908 <uvmalloc>
    80001276:	85aa                	mv	a1,a0
    80001278:	fd79                	bnez	a0,80001256 <growproc+0x22>
      return -1;
    8000127a:	557d                	li	a0,-1
    8000127c:	bff9                	j	8000125a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000127e:	00b90633          	add	a2,s2,a1
    80001282:	6928                	ld	a0,80(a0)
    80001284:	fffff097          	auipc	ra,0xfffff
    80001288:	63c080e7          	jalr	1596(ra) # 800008c0 <uvmdealloc>
    8000128c:	85aa                	mv	a1,a0
    8000128e:	b7e1                	j	80001256 <growproc+0x22>

0000000080001290 <fork>:
{
    80001290:	7179                	addi	sp,sp,-48
    80001292:	f406                	sd	ra,40(sp)
    80001294:	f022                	sd	s0,32(sp)
    80001296:	ec26                	sd	s1,24(sp)
    80001298:	e84a                	sd	s2,16(sp)
    8000129a:	e44e                	sd	s3,8(sp)
    8000129c:	e052                	sd	s4,0(sp)
    8000129e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012a0:	00000097          	auipc	ra,0x0
    800012a4:	c36080e7          	jalr	-970(ra) # 80000ed6 <myproc>
    800012a8:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800012aa:	00000097          	auipc	ra,0x0
    800012ae:	e3a080e7          	jalr	-454(ra) # 800010e4 <allocproc>
    800012b2:	10050f63          	beqz	a0,800013d0 <fork+0x140>
    800012b6:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012b8:	04893603          	ld	a2,72(s2)
    800012bc:	692c                	ld	a1,80(a0)
    800012be:	05093503          	ld	a0,80(s2)
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	79a080e7          	jalr	1946(ra) # 80000a5c <uvmcopy>
    800012ca:	04054a63          	bltz	a0,8000131e <fork+0x8e>
  np->sz = p->sz;
    800012ce:	04893783          	ld	a5,72(s2)
    800012d2:	04f9b423          	sd	a5,72(s3)
  np->mask = p->mask;
    800012d6:	16892783          	lw	a5,360(s2)
    800012da:	16f9a423          	sw	a5,360(s3)
  *(np->trapframe) = *(p->trapframe);
    800012de:	05893683          	ld	a3,88(s2)
    800012e2:	87b6                	mv	a5,a3
    800012e4:	0589b703          	ld	a4,88(s3)
    800012e8:	12068693          	addi	a3,a3,288
    800012ec:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012f0:	6788                	ld	a0,8(a5)
    800012f2:	6b8c                	ld	a1,16(a5)
    800012f4:	6f90                	ld	a2,24(a5)
    800012f6:	01073023          	sd	a6,0(a4)
    800012fa:	e708                	sd	a0,8(a4)
    800012fc:	eb0c                	sd	a1,16(a4)
    800012fe:	ef10                	sd	a2,24(a4)
    80001300:	02078793          	addi	a5,a5,32
    80001304:	02070713          	addi	a4,a4,32
    80001308:	fed792e3          	bne	a5,a3,800012ec <fork+0x5c>
  np->trapframe->a0 = 0;
    8000130c:	0589b783          	ld	a5,88(s3)
    80001310:	0607b823          	sd	zero,112(a5)
    80001314:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001318:	15000a13          	li	s4,336
    8000131c:	a03d                	j	8000134a <fork+0xba>
    freeproc(np);
    8000131e:	854e                	mv	a0,s3
    80001320:	00000097          	auipc	ra,0x0
    80001324:	d6c080e7          	jalr	-660(ra) # 8000108c <freeproc>
    release(&np->lock);
    80001328:	854e                	mv	a0,s3
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	036080e7          	jalr	54(ra) # 80006360 <release>
    return -1;
    80001332:	5a7d                	li	s4,-1
    80001334:	a069                	j	800013be <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001336:	00002097          	auipc	ra,0x2
    8000133a:	76e080e7          	jalr	1902(ra) # 80003aa4 <filedup>
    8000133e:	009987b3          	add	a5,s3,s1
    80001342:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001344:	04a1                	addi	s1,s1,8
    80001346:	01448763          	beq	s1,s4,80001354 <fork+0xc4>
    if(p->ofile[i])
    8000134a:	009907b3          	add	a5,s2,s1
    8000134e:	6388                	ld	a0,0(a5)
    80001350:	f17d                	bnez	a0,80001336 <fork+0xa6>
    80001352:	bfcd                	j	80001344 <fork+0xb4>
  np->cwd = idup(p->cwd);
    80001354:	15093503          	ld	a0,336(s2)
    80001358:	00002097          	auipc	ra,0x2
    8000135c:	8d2080e7          	jalr	-1838(ra) # 80002c2a <idup>
    80001360:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001364:	4641                	li	a2,16
    80001366:	15890593          	addi	a1,s2,344
    8000136a:	15898513          	addi	a0,s3,344
    8000136e:	fffff097          	auipc	ra,0xfffff
    80001372:	f82080e7          	jalr	-126(ra) # 800002f0 <safestrcpy>
  pid = np->pid;
    80001376:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000137a:	854e                	mv	a0,s3
    8000137c:	00005097          	auipc	ra,0x5
    80001380:	fe4080e7          	jalr	-28(ra) # 80006360 <release>
  acquire(&wait_lock);
    80001384:	00007497          	auipc	s1,0x7
    80001388:	75448493          	addi	s1,s1,1876 # 80008ad8 <wait_lock>
    8000138c:	8526                	mv	a0,s1
    8000138e:	00005097          	auipc	ra,0x5
    80001392:	f1e080e7          	jalr	-226(ra) # 800062ac <acquire>
  np->parent = p;
    80001396:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000139a:	8526                	mv	a0,s1
    8000139c:	00005097          	auipc	ra,0x5
    800013a0:	fc4080e7          	jalr	-60(ra) # 80006360 <release>
  acquire(&np->lock);
    800013a4:	854e                	mv	a0,s3
    800013a6:	00005097          	auipc	ra,0x5
    800013aa:	f06080e7          	jalr	-250(ra) # 800062ac <acquire>
  np->state = RUNNABLE;
    800013ae:	478d                	li	a5,3
    800013b0:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800013b4:	854e                	mv	a0,s3
    800013b6:	00005097          	auipc	ra,0x5
    800013ba:	faa080e7          	jalr	-86(ra) # 80006360 <release>
}
    800013be:	8552                	mv	a0,s4
    800013c0:	70a2                	ld	ra,40(sp)
    800013c2:	7402                	ld	s0,32(sp)
    800013c4:	64e2                	ld	s1,24(sp)
    800013c6:	6942                	ld	s2,16(sp)
    800013c8:	69a2                	ld	s3,8(sp)
    800013ca:	6a02                	ld	s4,0(sp)
    800013cc:	6145                	addi	sp,sp,48
    800013ce:	8082                	ret
    return -1;
    800013d0:	5a7d                	li	s4,-1
    800013d2:	b7f5                	j	800013be <fork+0x12e>

00000000800013d4 <scheduler>:
{
    800013d4:	7139                	addi	sp,sp,-64
    800013d6:	fc06                	sd	ra,56(sp)
    800013d8:	f822                	sd	s0,48(sp)
    800013da:	f426                	sd	s1,40(sp)
    800013dc:	f04a                	sd	s2,32(sp)
    800013de:	ec4e                	sd	s3,24(sp)
    800013e0:	e852                	sd	s4,16(sp)
    800013e2:	e456                	sd	s5,8(sp)
    800013e4:	e05a                	sd	s6,0(sp)
    800013e6:	0080                	addi	s0,sp,64
    800013e8:	8792                	mv	a5,tp
  int id = r_tp();
    800013ea:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ec:	00779a93          	slli	s5,a5,0x7
    800013f0:	00007717          	auipc	a4,0x7
    800013f4:	6d070713          	addi	a4,a4,1744 # 80008ac0 <pid_lock>
    800013f8:	9756                	add	a4,a4,s5
    800013fa:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013fe:	00007717          	auipc	a4,0x7
    80001402:	6fa70713          	addi	a4,a4,1786 # 80008af8 <cpus+0x8>
    80001406:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001408:	498d                	li	s3,3
        p->state = RUNNING;
    8000140a:	4b11                	li	s6,4
        c->proc = p;
    8000140c:	079e                	slli	a5,a5,0x7
    8000140e:	00007a17          	auipc	s4,0x7
    80001412:	6b2a0a13          	addi	s4,s4,1714 # 80008ac0 <pid_lock>
    80001416:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001418:	0000d917          	auipc	s2,0xd
    8000141c:	6d890913          	addi	s2,s2,1752 # 8000eaf0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001420:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001424:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001428:	10079073          	csrw	sstatus,a5
    8000142c:	00008497          	auipc	s1,0x8
    80001430:	ac448493          	addi	s1,s1,-1340 # 80008ef0 <proc>
    80001434:	a03d                	j	80001462 <scheduler+0x8e>
        p->state = RUNNING;
    80001436:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000143a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000143e:	06048593          	addi	a1,s1,96
    80001442:	8556                	mv	a0,s5
    80001444:	00000097          	auipc	ra,0x0
    80001448:	6d4080e7          	jalr	1748(ra) # 80001b18 <swtch>
        c->proc = 0;
    8000144c:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001450:	8526                	mv	a0,s1
    80001452:	00005097          	auipc	ra,0x5
    80001456:	f0e080e7          	jalr	-242(ra) # 80006360 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000145a:	17048493          	addi	s1,s1,368
    8000145e:	fd2481e3          	beq	s1,s2,80001420 <scheduler+0x4c>
      acquire(&p->lock);
    80001462:	8526                	mv	a0,s1
    80001464:	00005097          	auipc	ra,0x5
    80001468:	e48080e7          	jalr	-440(ra) # 800062ac <acquire>
      if(p->state == RUNNABLE) {
    8000146c:	4c9c                	lw	a5,24(s1)
    8000146e:	ff3791e3          	bne	a5,s3,80001450 <scheduler+0x7c>
    80001472:	b7d1                	j	80001436 <scheduler+0x62>

0000000080001474 <sched>:
{
    80001474:	7179                	addi	sp,sp,-48
    80001476:	f406                	sd	ra,40(sp)
    80001478:	f022                	sd	s0,32(sp)
    8000147a:	ec26                	sd	s1,24(sp)
    8000147c:	e84a                	sd	s2,16(sp)
    8000147e:	e44e                	sd	s3,8(sp)
    80001480:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001482:	00000097          	auipc	ra,0x0
    80001486:	a54080e7          	jalr	-1452(ra) # 80000ed6 <myproc>
    8000148a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000148c:	00005097          	auipc	ra,0x5
    80001490:	da6080e7          	jalr	-602(ra) # 80006232 <holding>
    80001494:	c93d                	beqz	a0,8000150a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001496:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001498:	2781                	sext.w	a5,a5
    8000149a:	079e                	slli	a5,a5,0x7
    8000149c:	00007717          	auipc	a4,0x7
    800014a0:	62470713          	addi	a4,a4,1572 # 80008ac0 <pid_lock>
    800014a4:	97ba                	add	a5,a5,a4
    800014a6:	0a87a703          	lw	a4,168(a5)
    800014aa:	4785                	li	a5,1
    800014ac:	06f71763          	bne	a4,a5,8000151a <sched+0xa6>
  if(p->state == RUNNING)
    800014b0:	4c98                	lw	a4,24(s1)
    800014b2:	4791                	li	a5,4
    800014b4:	06f70b63          	beq	a4,a5,8000152a <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014b8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014bc:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014be:	efb5                	bnez	a5,8000153a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014c0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014c2:	00007917          	auipc	s2,0x7
    800014c6:	5fe90913          	addi	s2,s2,1534 # 80008ac0 <pid_lock>
    800014ca:	2781                	sext.w	a5,a5
    800014cc:	079e                	slli	a5,a5,0x7
    800014ce:	97ca                	add	a5,a5,s2
    800014d0:	0ac7a983          	lw	s3,172(a5)
    800014d4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014d6:	2781                	sext.w	a5,a5
    800014d8:	079e                	slli	a5,a5,0x7
    800014da:	00007597          	auipc	a1,0x7
    800014de:	61e58593          	addi	a1,a1,1566 # 80008af8 <cpus+0x8>
    800014e2:	95be                	add	a1,a1,a5
    800014e4:	06048513          	addi	a0,s1,96
    800014e8:	00000097          	auipc	ra,0x0
    800014ec:	630080e7          	jalr	1584(ra) # 80001b18 <swtch>
    800014f0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014f2:	2781                	sext.w	a5,a5
    800014f4:	079e                	slli	a5,a5,0x7
    800014f6:	97ca                	add	a5,a5,s2
    800014f8:	0b37a623          	sw	s3,172(a5)
}
    800014fc:	70a2                	ld	ra,40(sp)
    800014fe:	7402                	ld	s0,32(sp)
    80001500:	64e2                	ld	s1,24(sp)
    80001502:	6942                	ld	s2,16(sp)
    80001504:	69a2                	ld	s3,8(sp)
    80001506:	6145                	addi	sp,sp,48
    80001508:	8082                	ret
    panic("sched p->lock");
    8000150a:	00007517          	auipc	a0,0x7
    8000150e:	cce50513          	addi	a0,a0,-818 # 800081d8 <etext+0x1d8>
    80001512:	00005097          	auipc	ra,0x5
    80001516:	850080e7          	jalr	-1968(ra) # 80005d62 <panic>
    panic("sched locks");
    8000151a:	00007517          	auipc	a0,0x7
    8000151e:	cce50513          	addi	a0,a0,-818 # 800081e8 <etext+0x1e8>
    80001522:	00005097          	auipc	ra,0x5
    80001526:	840080e7          	jalr	-1984(ra) # 80005d62 <panic>
    panic("sched running");
    8000152a:	00007517          	auipc	a0,0x7
    8000152e:	cce50513          	addi	a0,a0,-818 # 800081f8 <etext+0x1f8>
    80001532:	00005097          	auipc	ra,0x5
    80001536:	830080e7          	jalr	-2000(ra) # 80005d62 <panic>
    panic("sched interruptible");
    8000153a:	00007517          	auipc	a0,0x7
    8000153e:	cce50513          	addi	a0,a0,-818 # 80008208 <etext+0x208>
    80001542:	00005097          	auipc	ra,0x5
    80001546:	820080e7          	jalr	-2016(ra) # 80005d62 <panic>

000000008000154a <yield>:
{
    8000154a:	1101                	addi	sp,sp,-32
    8000154c:	ec06                	sd	ra,24(sp)
    8000154e:	e822                	sd	s0,16(sp)
    80001550:	e426                	sd	s1,8(sp)
    80001552:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001554:	00000097          	auipc	ra,0x0
    80001558:	982080e7          	jalr	-1662(ra) # 80000ed6 <myproc>
    8000155c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	d4e080e7          	jalr	-690(ra) # 800062ac <acquire>
  p->state = RUNNABLE;
    80001566:	478d                	li	a5,3
    80001568:	cc9c                	sw	a5,24(s1)
  sched();
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	f0a080e7          	jalr	-246(ra) # 80001474 <sched>
  release(&p->lock);
    80001572:	8526                	mv	a0,s1
    80001574:	00005097          	auipc	ra,0x5
    80001578:	dec080e7          	jalr	-532(ra) # 80006360 <release>
}
    8000157c:	60e2                	ld	ra,24(sp)
    8000157e:	6442                	ld	s0,16(sp)
    80001580:	64a2                	ld	s1,8(sp)
    80001582:	6105                	addi	sp,sp,32
    80001584:	8082                	ret

0000000080001586 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001586:	7179                	addi	sp,sp,-48
    80001588:	f406                	sd	ra,40(sp)
    8000158a:	f022                	sd	s0,32(sp)
    8000158c:	ec26                	sd	s1,24(sp)
    8000158e:	e84a                	sd	s2,16(sp)
    80001590:	e44e                	sd	s3,8(sp)
    80001592:	1800                	addi	s0,sp,48
    80001594:	89aa                	mv	s3,a0
    80001596:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001598:	00000097          	auipc	ra,0x0
    8000159c:	93e080e7          	jalr	-1730(ra) # 80000ed6 <myproc>
    800015a0:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	d0a080e7          	jalr	-758(ra) # 800062ac <acquire>
  release(lk);
    800015aa:	854a                	mv	a0,s2
    800015ac:	00005097          	auipc	ra,0x5
    800015b0:	db4080e7          	jalr	-588(ra) # 80006360 <release>

  // Go to sleep.
  p->chan = chan;
    800015b4:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015b8:	4789                	li	a5,2
    800015ba:	cc9c                	sw	a5,24(s1)

  sched();
    800015bc:	00000097          	auipc	ra,0x0
    800015c0:	eb8080e7          	jalr	-328(ra) # 80001474 <sched>

  // Tidy up.
  p->chan = 0;
    800015c4:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015c8:	8526                	mv	a0,s1
    800015ca:	00005097          	auipc	ra,0x5
    800015ce:	d96080e7          	jalr	-618(ra) # 80006360 <release>
  acquire(lk);
    800015d2:	854a                	mv	a0,s2
    800015d4:	00005097          	auipc	ra,0x5
    800015d8:	cd8080e7          	jalr	-808(ra) # 800062ac <acquire>
}
    800015dc:	70a2                	ld	ra,40(sp)
    800015de:	7402                	ld	s0,32(sp)
    800015e0:	64e2                	ld	s1,24(sp)
    800015e2:	6942                	ld	s2,16(sp)
    800015e4:	69a2                	ld	s3,8(sp)
    800015e6:	6145                	addi	sp,sp,48
    800015e8:	8082                	ret

00000000800015ea <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015ea:	7139                	addi	sp,sp,-64
    800015ec:	fc06                	sd	ra,56(sp)
    800015ee:	f822                	sd	s0,48(sp)
    800015f0:	f426                	sd	s1,40(sp)
    800015f2:	f04a                	sd	s2,32(sp)
    800015f4:	ec4e                	sd	s3,24(sp)
    800015f6:	e852                	sd	s4,16(sp)
    800015f8:	e456                	sd	s5,8(sp)
    800015fa:	0080                	addi	s0,sp,64
    800015fc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015fe:	00008497          	auipc	s1,0x8
    80001602:	8f248493          	addi	s1,s1,-1806 # 80008ef0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001606:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001608:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000160a:	0000d917          	auipc	s2,0xd
    8000160e:	4e690913          	addi	s2,s2,1254 # 8000eaf0 <tickslock>
    80001612:	a821                	j	8000162a <wakeup+0x40>
        p->state = RUNNABLE;
    80001614:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001618:	8526                	mv	a0,s1
    8000161a:	00005097          	auipc	ra,0x5
    8000161e:	d46080e7          	jalr	-698(ra) # 80006360 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001622:	17048493          	addi	s1,s1,368
    80001626:	03248463          	beq	s1,s2,8000164e <wakeup+0x64>
    if(p != myproc()){
    8000162a:	00000097          	auipc	ra,0x0
    8000162e:	8ac080e7          	jalr	-1876(ra) # 80000ed6 <myproc>
    80001632:	fea488e3          	beq	s1,a0,80001622 <wakeup+0x38>
      acquire(&p->lock);
    80001636:	8526                	mv	a0,s1
    80001638:	00005097          	auipc	ra,0x5
    8000163c:	c74080e7          	jalr	-908(ra) # 800062ac <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001640:	4c9c                	lw	a5,24(s1)
    80001642:	fd379be3          	bne	a5,s3,80001618 <wakeup+0x2e>
    80001646:	709c                	ld	a5,32(s1)
    80001648:	fd4798e3          	bne	a5,s4,80001618 <wakeup+0x2e>
    8000164c:	b7e1                	j	80001614 <wakeup+0x2a>
    }
  }
}
    8000164e:	70e2                	ld	ra,56(sp)
    80001650:	7442                	ld	s0,48(sp)
    80001652:	74a2                	ld	s1,40(sp)
    80001654:	7902                	ld	s2,32(sp)
    80001656:	69e2                	ld	s3,24(sp)
    80001658:	6a42                	ld	s4,16(sp)
    8000165a:	6aa2                	ld	s5,8(sp)
    8000165c:	6121                	addi	sp,sp,64
    8000165e:	8082                	ret

0000000080001660 <reparent>:
{
    80001660:	7179                	addi	sp,sp,-48
    80001662:	f406                	sd	ra,40(sp)
    80001664:	f022                	sd	s0,32(sp)
    80001666:	ec26                	sd	s1,24(sp)
    80001668:	e84a                	sd	s2,16(sp)
    8000166a:	e44e                	sd	s3,8(sp)
    8000166c:	e052                	sd	s4,0(sp)
    8000166e:	1800                	addi	s0,sp,48
    80001670:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001672:	00008497          	auipc	s1,0x8
    80001676:	87e48493          	addi	s1,s1,-1922 # 80008ef0 <proc>
      pp->parent = initproc;
    8000167a:	00007a17          	auipc	s4,0x7
    8000167e:	406a0a13          	addi	s4,s4,1030 # 80008a80 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001682:	0000d997          	auipc	s3,0xd
    80001686:	46e98993          	addi	s3,s3,1134 # 8000eaf0 <tickslock>
    8000168a:	a029                	j	80001694 <reparent+0x34>
    8000168c:	17048493          	addi	s1,s1,368
    80001690:	01348d63          	beq	s1,s3,800016aa <reparent+0x4a>
    if(pp->parent == p){
    80001694:	7c9c                	ld	a5,56(s1)
    80001696:	ff279be3          	bne	a5,s2,8000168c <reparent+0x2c>
      pp->parent = initproc;
    8000169a:	000a3503          	ld	a0,0(s4)
    8000169e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800016a0:	00000097          	auipc	ra,0x0
    800016a4:	f4a080e7          	jalr	-182(ra) # 800015ea <wakeup>
    800016a8:	b7d5                	j	8000168c <reparent+0x2c>
}
    800016aa:	70a2                	ld	ra,40(sp)
    800016ac:	7402                	ld	s0,32(sp)
    800016ae:	64e2                	ld	s1,24(sp)
    800016b0:	6942                	ld	s2,16(sp)
    800016b2:	69a2                	ld	s3,8(sp)
    800016b4:	6a02                	ld	s4,0(sp)
    800016b6:	6145                	addi	sp,sp,48
    800016b8:	8082                	ret

00000000800016ba <exit>:
{
    800016ba:	7179                	addi	sp,sp,-48
    800016bc:	f406                	sd	ra,40(sp)
    800016be:	f022                	sd	s0,32(sp)
    800016c0:	ec26                	sd	s1,24(sp)
    800016c2:	e84a                	sd	s2,16(sp)
    800016c4:	e44e                	sd	s3,8(sp)
    800016c6:	e052                	sd	s4,0(sp)
    800016c8:	1800                	addi	s0,sp,48
    800016ca:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016cc:	00000097          	auipc	ra,0x0
    800016d0:	80a080e7          	jalr	-2038(ra) # 80000ed6 <myproc>
    800016d4:	89aa                	mv	s3,a0
  if(p == initproc)
    800016d6:	00007797          	auipc	a5,0x7
    800016da:	3aa7b783          	ld	a5,938(a5) # 80008a80 <initproc>
    800016de:	0d050493          	addi	s1,a0,208
    800016e2:	15050913          	addi	s2,a0,336
    800016e6:	02a79363          	bne	a5,a0,8000170c <exit+0x52>
    panic("init exiting");
    800016ea:	00007517          	auipc	a0,0x7
    800016ee:	b3650513          	addi	a0,a0,-1226 # 80008220 <etext+0x220>
    800016f2:	00004097          	auipc	ra,0x4
    800016f6:	670080e7          	jalr	1648(ra) # 80005d62 <panic>
      fileclose(f);
    800016fa:	00002097          	auipc	ra,0x2
    800016fe:	3fc080e7          	jalr	1020(ra) # 80003af6 <fileclose>
      p->ofile[fd] = 0;
    80001702:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001706:	04a1                	addi	s1,s1,8
    80001708:	01248563          	beq	s1,s2,80001712 <exit+0x58>
    if(p->ofile[fd]){
    8000170c:	6088                	ld	a0,0(s1)
    8000170e:	f575                	bnez	a0,800016fa <exit+0x40>
    80001710:	bfdd                	j	80001706 <exit+0x4c>
  begin_op();
    80001712:	00002097          	auipc	ra,0x2
    80001716:	f18080e7          	jalr	-232(ra) # 8000362a <begin_op>
  iput(p->cwd);
    8000171a:	1509b503          	ld	a0,336(s3)
    8000171e:	00001097          	auipc	ra,0x1
    80001722:	704080e7          	jalr	1796(ra) # 80002e22 <iput>
  end_op();
    80001726:	00002097          	auipc	ra,0x2
    8000172a:	f84080e7          	jalr	-124(ra) # 800036aa <end_op>
  p->cwd = 0;
    8000172e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001732:	00007497          	auipc	s1,0x7
    80001736:	3a648493          	addi	s1,s1,934 # 80008ad8 <wait_lock>
    8000173a:	8526                	mv	a0,s1
    8000173c:	00005097          	auipc	ra,0x5
    80001740:	b70080e7          	jalr	-1168(ra) # 800062ac <acquire>
  reparent(p);
    80001744:	854e                	mv	a0,s3
    80001746:	00000097          	auipc	ra,0x0
    8000174a:	f1a080e7          	jalr	-230(ra) # 80001660 <reparent>
  wakeup(p->parent);
    8000174e:	0389b503          	ld	a0,56(s3)
    80001752:	00000097          	auipc	ra,0x0
    80001756:	e98080e7          	jalr	-360(ra) # 800015ea <wakeup>
  acquire(&p->lock);
    8000175a:	854e                	mv	a0,s3
    8000175c:	00005097          	auipc	ra,0x5
    80001760:	b50080e7          	jalr	-1200(ra) # 800062ac <acquire>
  p->xstate = status;
    80001764:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001768:	4795                	li	a5,5
    8000176a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000176e:	8526                	mv	a0,s1
    80001770:	00005097          	auipc	ra,0x5
    80001774:	bf0080e7          	jalr	-1040(ra) # 80006360 <release>
  sched();
    80001778:	00000097          	auipc	ra,0x0
    8000177c:	cfc080e7          	jalr	-772(ra) # 80001474 <sched>
  panic("zombie exit");
    80001780:	00007517          	auipc	a0,0x7
    80001784:	ab050513          	addi	a0,a0,-1360 # 80008230 <etext+0x230>
    80001788:	00004097          	auipc	ra,0x4
    8000178c:	5da080e7          	jalr	1498(ra) # 80005d62 <panic>

0000000080001790 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001790:	7179                	addi	sp,sp,-48
    80001792:	f406                	sd	ra,40(sp)
    80001794:	f022                	sd	s0,32(sp)
    80001796:	ec26                	sd	s1,24(sp)
    80001798:	e84a                	sd	s2,16(sp)
    8000179a:	e44e                	sd	s3,8(sp)
    8000179c:	1800                	addi	s0,sp,48
    8000179e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800017a0:	00007497          	auipc	s1,0x7
    800017a4:	75048493          	addi	s1,s1,1872 # 80008ef0 <proc>
    800017a8:	0000d997          	auipc	s3,0xd
    800017ac:	34898993          	addi	s3,s3,840 # 8000eaf0 <tickslock>
    acquire(&p->lock);
    800017b0:	8526                	mv	a0,s1
    800017b2:	00005097          	auipc	ra,0x5
    800017b6:	afa080e7          	jalr	-1286(ra) # 800062ac <acquire>
    if(p->pid == pid){
    800017ba:	589c                	lw	a5,48(s1)
    800017bc:	01278d63          	beq	a5,s2,800017d6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017c0:	8526                	mv	a0,s1
    800017c2:	00005097          	auipc	ra,0x5
    800017c6:	b9e080e7          	jalr	-1122(ra) # 80006360 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017ca:	17048493          	addi	s1,s1,368
    800017ce:	ff3491e3          	bne	s1,s3,800017b0 <kill+0x20>
  }
  return -1;
    800017d2:	557d                	li	a0,-1
    800017d4:	a829                	j	800017ee <kill+0x5e>
      p->killed = 1;
    800017d6:	4785                	li	a5,1
    800017d8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017da:	4c98                	lw	a4,24(s1)
    800017dc:	4789                	li	a5,2
    800017de:	00f70f63          	beq	a4,a5,800017fc <kill+0x6c>
      release(&p->lock);
    800017e2:	8526                	mv	a0,s1
    800017e4:	00005097          	auipc	ra,0x5
    800017e8:	b7c080e7          	jalr	-1156(ra) # 80006360 <release>
      return 0;
    800017ec:	4501                	li	a0,0
}
    800017ee:	70a2                	ld	ra,40(sp)
    800017f0:	7402                	ld	s0,32(sp)
    800017f2:	64e2                	ld	s1,24(sp)
    800017f4:	6942                	ld	s2,16(sp)
    800017f6:	69a2                	ld	s3,8(sp)
    800017f8:	6145                	addi	sp,sp,48
    800017fa:	8082                	ret
        p->state = RUNNABLE;
    800017fc:	478d                	li	a5,3
    800017fe:	cc9c                	sw	a5,24(s1)
    80001800:	b7cd                	j	800017e2 <kill+0x52>

0000000080001802 <setkilled>:

void
setkilled(struct proc *p)
{
    80001802:	1101                	addi	sp,sp,-32
    80001804:	ec06                	sd	ra,24(sp)
    80001806:	e822                	sd	s0,16(sp)
    80001808:	e426                	sd	s1,8(sp)
    8000180a:	1000                	addi	s0,sp,32
    8000180c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	a9e080e7          	jalr	-1378(ra) # 800062ac <acquire>
  p->killed = 1;
    80001816:	4785                	li	a5,1
    80001818:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000181a:	8526                	mv	a0,s1
    8000181c:	00005097          	auipc	ra,0x5
    80001820:	b44080e7          	jalr	-1212(ra) # 80006360 <release>
}
    80001824:	60e2                	ld	ra,24(sp)
    80001826:	6442                	ld	s0,16(sp)
    80001828:	64a2                	ld	s1,8(sp)
    8000182a:	6105                	addi	sp,sp,32
    8000182c:	8082                	ret

000000008000182e <killed>:

int
killed(struct proc *p)
{
    8000182e:	1101                	addi	sp,sp,-32
    80001830:	ec06                	sd	ra,24(sp)
    80001832:	e822                	sd	s0,16(sp)
    80001834:	e426                	sd	s1,8(sp)
    80001836:	e04a                	sd	s2,0(sp)
    80001838:	1000                	addi	s0,sp,32
    8000183a:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000183c:	00005097          	auipc	ra,0x5
    80001840:	a70080e7          	jalr	-1424(ra) # 800062ac <acquire>
  k = p->killed;
    80001844:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001848:	8526                	mv	a0,s1
    8000184a:	00005097          	auipc	ra,0x5
    8000184e:	b16080e7          	jalr	-1258(ra) # 80006360 <release>
  return k;
}
    80001852:	854a                	mv	a0,s2
    80001854:	60e2                	ld	ra,24(sp)
    80001856:	6442                	ld	s0,16(sp)
    80001858:	64a2                	ld	s1,8(sp)
    8000185a:	6902                	ld	s2,0(sp)
    8000185c:	6105                	addi	sp,sp,32
    8000185e:	8082                	ret

0000000080001860 <wait>:
{
    80001860:	715d                	addi	sp,sp,-80
    80001862:	e486                	sd	ra,72(sp)
    80001864:	e0a2                	sd	s0,64(sp)
    80001866:	fc26                	sd	s1,56(sp)
    80001868:	f84a                	sd	s2,48(sp)
    8000186a:	f44e                	sd	s3,40(sp)
    8000186c:	f052                	sd	s4,32(sp)
    8000186e:	ec56                	sd	s5,24(sp)
    80001870:	e85a                	sd	s6,16(sp)
    80001872:	e45e                	sd	s7,8(sp)
    80001874:	e062                	sd	s8,0(sp)
    80001876:	0880                	addi	s0,sp,80
    80001878:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000187a:	fffff097          	auipc	ra,0xfffff
    8000187e:	65c080e7          	jalr	1628(ra) # 80000ed6 <myproc>
    80001882:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001884:	00007517          	auipc	a0,0x7
    80001888:	25450513          	addi	a0,a0,596 # 80008ad8 <wait_lock>
    8000188c:	00005097          	auipc	ra,0x5
    80001890:	a20080e7          	jalr	-1504(ra) # 800062ac <acquire>
    havekids = 0;
    80001894:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001896:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001898:	0000d997          	auipc	s3,0xd
    8000189c:	25898993          	addi	s3,s3,600 # 8000eaf0 <tickslock>
        havekids = 1;
    800018a0:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018a2:	00007c17          	auipc	s8,0x7
    800018a6:	236c0c13          	addi	s8,s8,566 # 80008ad8 <wait_lock>
    havekids = 0;
    800018aa:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018ac:	00007497          	auipc	s1,0x7
    800018b0:	64448493          	addi	s1,s1,1604 # 80008ef0 <proc>
    800018b4:	a0bd                	j	80001922 <wait+0xc2>
          pid = pp->pid;
    800018b6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018ba:	000b0e63          	beqz	s6,800018d6 <wait+0x76>
    800018be:	4691                	li	a3,4
    800018c0:	02c48613          	addi	a2,s1,44
    800018c4:	85da                	mv	a1,s6
    800018c6:	05093503          	ld	a0,80(s2)
    800018ca:	fffff097          	auipc	ra,0xfffff
    800018ce:	296080e7          	jalr	662(ra) # 80000b60 <copyout>
    800018d2:	02054563          	bltz	a0,800018fc <wait+0x9c>
          freeproc(pp);
    800018d6:	8526                	mv	a0,s1
    800018d8:	fffff097          	auipc	ra,0xfffff
    800018dc:	7b4080e7          	jalr	1972(ra) # 8000108c <freeproc>
          release(&pp->lock);
    800018e0:	8526                	mv	a0,s1
    800018e2:	00005097          	auipc	ra,0x5
    800018e6:	a7e080e7          	jalr	-1410(ra) # 80006360 <release>
          release(&wait_lock);
    800018ea:	00007517          	auipc	a0,0x7
    800018ee:	1ee50513          	addi	a0,a0,494 # 80008ad8 <wait_lock>
    800018f2:	00005097          	auipc	ra,0x5
    800018f6:	a6e080e7          	jalr	-1426(ra) # 80006360 <release>
          return pid;
    800018fa:	a0b5                	j	80001966 <wait+0x106>
            release(&pp->lock);
    800018fc:	8526                	mv	a0,s1
    800018fe:	00005097          	auipc	ra,0x5
    80001902:	a62080e7          	jalr	-1438(ra) # 80006360 <release>
            release(&wait_lock);
    80001906:	00007517          	auipc	a0,0x7
    8000190a:	1d250513          	addi	a0,a0,466 # 80008ad8 <wait_lock>
    8000190e:	00005097          	auipc	ra,0x5
    80001912:	a52080e7          	jalr	-1454(ra) # 80006360 <release>
            return -1;
    80001916:	59fd                	li	s3,-1
    80001918:	a0b9                	j	80001966 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000191a:	17048493          	addi	s1,s1,368
    8000191e:	03348463          	beq	s1,s3,80001946 <wait+0xe6>
      if(pp->parent == p){
    80001922:	7c9c                	ld	a5,56(s1)
    80001924:	ff279be3          	bne	a5,s2,8000191a <wait+0xba>
        acquire(&pp->lock);
    80001928:	8526                	mv	a0,s1
    8000192a:	00005097          	auipc	ra,0x5
    8000192e:	982080e7          	jalr	-1662(ra) # 800062ac <acquire>
        if(pp->state == ZOMBIE){
    80001932:	4c9c                	lw	a5,24(s1)
    80001934:	f94781e3          	beq	a5,s4,800018b6 <wait+0x56>
        release(&pp->lock);
    80001938:	8526                	mv	a0,s1
    8000193a:	00005097          	auipc	ra,0x5
    8000193e:	a26080e7          	jalr	-1498(ra) # 80006360 <release>
        havekids = 1;
    80001942:	8756                	mv	a4,s5
    80001944:	bfd9                	j	8000191a <wait+0xba>
    if(!havekids || killed(p)){
    80001946:	c719                	beqz	a4,80001954 <wait+0xf4>
    80001948:	854a                	mv	a0,s2
    8000194a:	00000097          	auipc	ra,0x0
    8000194e:	ee4080e7          	jalr	-284(ra) # 8000182e <killed>
    80001952:	c51d                	beqz	a0,80001980 <wait+0x120>
      release(&wait_lock);
    80001954:	00007517          	auipc	a0,0x7
    80001958:	18450513          	addi	a0,a0,388 # 80008ad8 <wait_lock>
    8000195c:	00005097          	auipc	ra,0x5
    80001960:	a04080e7          	jalr	-1532(ra) # 80006360 <release>
      return -1;
    80001964:	59fd                	li	s3,-1
}
    80001966:	854e                	mv	a0,s3
    80001968:	60a6                	ld	ra,72(sp)
    8000196a:	6406                	ld	s0,64(sp)
    8000196c:	74e2                	ld	s1,56(sp)
    8000196e:	7942                	ld	s2,48(sp)
    80001970:	79a2                	ld	s3,40(sp)
    80001972:	7a02                	ld	s4,32(sp)
    80001974:	6ae2                	ld	s5,24(sp)
    80001976:	6b42                	ld	s6,16(sp)
    80001978:	6ba2                	ld	s7,8(sp)
    8000197a:	6c02                	ld	s8,0(sp)
    8000197c:	6161                	addi	sp,sp,80
    8000197e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001980:	85e2                	mv	a1,s8
    80001982:	854a                	mv	a0,s2
    80001984:	00000097          	auipc	ra,0x0
    80001988:	c02080e7          	jalr	-1022(ra) # 80001586 <sleep>
    havekids = 0;
    8000198c:	bf39                	j	800018aa <wait+0x4a>

000000008000198e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000198e:	7179                	addi	sp,sp,-48
    80001990:	f406                	sd	ra,40(sp)
    80001992:	f022                	sd	s0,32(sp)
    80001994:	ec26                	sd	s1,24(sp)
    80001996:	e84a                	sd	s2,16(sp)
    80001998:	e44e                	sd	s3,8(sp)
    8000199a:	e052                	sd	s4,0(sp)
    8000199c:	1800                	addi	s0,sp,48
    8000199e:	84aa                	mv	s1,a0
    800019a0:	892e                	mv	s2,a1
    800019a2:	89b2                	mv	s3,a2
    800019a4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019a6:	fffff097          	auipc	ra,0xfffff
    800019aa:	530080e7          	jalr	1328(ra) # 80000ed6 <myproc>
  if(user_dst){
    800019ae:	c08d                	beqz	s1,800019d0 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019b0:	86d2                	mv	a3,s4
    800019b2:	864e                	mv	a2,s3
    800019b4:	85ca                	mv	a1,s2
    800019b6:	6928                	ld	a0,80(a0)
    800019b8:	fffff097          	auipc	ra,0xfffff
    800019bc:	1a8080e7          	jalr	424(ra) # 80000b60 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019c0:	70a2                	ld	ra,40(sp)
    800019c2:	7402                	ld	s0,32(sp)
    800019c4:	64e2                	ld	s1,24(sp)
    800019c6:	6942                	ld	s2,16(sp)
    800019c8:	69a2                	ld	s3,8(sp)
    800019ca:	6a02                	ld	s4,0(sp)
    800019cc:	6145                	addi	sp,sp,48
    800019ce:	8082                	ret
    memmove((char *)dst, src, len);
    800019d0:	000a061b          	sext.w	a2,s4
    800019d4:	85ce                	mv	a1,s3
    800019d6:	854a                	mv	a0,s2
    800019d8:	fffff097          	auipc	ra,0xfffff
    800019dc:	826080e7          	jalr	-2010(ra) # 800001fe <memmove>
    return 0;
    800019e0:	8526                	mv	a0,s1
    800019e2:	bff9                	j	800019c0 <either_copyout+0x32>

00000000800019e4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019e4:	7179                	addi	sp,sp,-48
    800019e6:	f406                	sd	ra,40(sp)
    800019e8:	f022                	sd	s0,32(sp)
    800019ea:	ec26                	sd	s1,24(sp)
    800019ec:	e84a                	sd	s2,16(sp)
    800019ee:	e44e                	sd	s3,8(sp)
    800019f0:	e052                	sd	s4,0(sp)
    800019f2:	1800                	addi	s0,sp,48
    800019f4:	892a                	mv	s2,a0
    800019f6:	84ae                	mv	s1,a1
    800019f8:	89b2                	mv	s3,a2
    800019fa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019fc:	fffff097          	auipc	ra,0xfffff
    80001a00:	4da080e7          	jalr	1242(ra) # 80000ed6 <myproc>
  if(user_src){
    80001a04:	c08d                	beqz	s1,80001a26 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a06:	86d2                	mv	a3,s4
    80001a08:	864e                	mv	a2,s3
    80001a0a:	85ca                	mv	a1,s2
    80001a0c:	6928                	ld	a0,80(a0)
    80001a0e:	fffff097          	auipc	ra,0xfffff
    80001a12:	212080e7          	jalr	530(ra) # 80000c20 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a16:	70a2                	ld	ra,40(sp)
    80001a18:	7402                	ld	s0,32(sp)
    80001a1a:	64e2                	ld	s1,24(sp)
    80001a1c:	6942                	ld	s2,16(sp)
    80001a1e:	69a2                	ld	s3,8(sp)
    80001a20:	6a02                	ld	s4,0(sp)
    80001a22:	6145                	addi	sp,sp,48
    80001a24:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a26:	000a061b          	sext.w	a2,s4
    80001a2a:	85ce                	mv	a1,s3
    80001a2c:	854a                	mv	a0,s2
    80001a2e:	ffffe097          	auipc	ra,0xffffe
    80001a32:	7d0080e7          	jalr	2000(ra) # 800001fe <memmove>
    return 0;
    80001a36:	8526                	mv	a0,s1
    80001a38:	bff9                	j	80001a16 <either_copyin+0x32>

0000000080001a3a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a3a:	715d                	addi	sp,sp,-80
    80001a3c:	e486                	sd	ra,72(sp)
    80001a3e:	e0a2                	sd	s0,64(sp)
    80001a40:	fc26                	sd	s1,56(sp)
    80001a42:	f84a                	sd	s2,48(sp)
    80001a44:	f44e                	sd	s3,40(sp)
    80001a46:	f052                	sd	s4,32(sp)
    80001a48:	ec56                	sd	s5,24(sp)
    80001a4a:	e85a                	sd	s6,16(sp)
    80001a4c:	e45e                	sd	s7,8(sp)
    80001a4e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a50:	00006517          	auipc	a0,0x6
    80001a54:	5f850513          	addi	a0,a0,1528 # 80008048 <etext+0x48>
    80001a58:	00004097          	auipc	ra,0x4
    80001a5c:	354080e7          	jalr	852(ra) # 80005dac <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a60:	00007497          	auipc	s1,0x7
    80001a64:	5e848493          	addi	s1,s1,1512 # 80009048 <proc+0x158>
    80001a68:	0000d917          	auipc	s2,0xd
    80001a6c:	1e090913          	addi	s2,s2,480 # 8000ec48 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a70:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a72:	00006997          	auipc	s3,0x6
    80001a76:	7ce98993          	addi	s3,s3,1998 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001a7a:	00006a97          	auipc	s5,0x6
    80001a7e:	7cea8a93          	addi	s5,s5,1998 # 80008248 <etext+0x248>
    printf("\n");
    80001a82:	00006a17          	auipc	s4,0x6
    80001a86:	5c6a0a13          	addi	s4,s4,1478 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a8a:	00006b97          	auipc	s7,0x6
    80001a8e:	7feb8b93          	addi	s7,s7,2046 # 80008288 <states.1725>
    80001a92:	a00d                	j	80001ab4 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a94:	ed86a583          	lw	a1,-296(a3)
    80001a98:	8556                	mv	a0,s5
    80001a9a:	00004097          	auipc	ra,0x4
    80001a9e:	312080e7          	jalr	786(ra) # 80005dac <printf>
    printf("\n");
    80001aa2:	8552                	mv	a0,s4
    80001aa4:	00004097          	auipc	ra,0x4
    80001aa8:	308080e7          	jalr	776(ra) # 80005dac <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aac:	17048493          	addi	s1,s1,368
    80001ab0:	03248163          	beq	s1,s2,80001ad2 <procdump+0x98>
    if(p->state == UNUSED)
    80001ab4:	86a6                	mv	a3,s1
    80001ab6:	ec04a783          	lw	a5,-320(s1)
    80001aba:	dbed                	beqz	a5,80001aac <procdump+0x72>
      state = "???";
    80001abc:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001abe:	fcfb6be3          	bltu	s6,a5,80001a94 <procdump+0x5a>
    80001ac2:	1782                	slli	a5,a5,0x20
    80001ac4:	9381                	srli	a5,a5,0x20
    80001ac6:	078e                	slli	a5,a5,0x3
    80001ac8:	97de                	add	a5,a5,s7
    80001aca:	6390                	ld	a2,0(a5)
    80001acc:	f661                	bnez	a2,80001a94 <procdump+0x5a>
      state = "???";
    80001ace:	864e                	mv	a2,s3
    80001ad0:	b7d1                	j	80001a94 <procdump+0x5a>
  }
}
    80001ad2:	60a6                	ld	ra,72(sp)
    80001ad4:	6406                	ld	s0,64(sp)
    80001ad6:	74e2                	ld	s1,56(sp)
    80001ad8:	7942                	ld	s2,48(sp)
    80001ada:	79a2                	ld	s3,40(sp)
    80001adc:	7a02                	ld	s4,32(sp)
    80001ade:	6ae2                	ld	s5,24(sp)
    80001ae0:	6b42                	ld	s6,16(sp)
    80001ae2:	6ba2                	ld	s7,8(sp)
    80001ae4:	6161                	addi	sp,sp,80
    80001ae6:	8082                	ret

0000000080001ae8 <kprocnum>:

// calculate the num of processes
int 
kprocnum(void){
    80001ae8:	1141                	addi	sp,sp,-16
    80001aea:	e422                	sd	s0,8(sp)
    80001aec:	0800                	addi	s0,sp,16
  struct proc *p;
  int num = 0;
    80001aee:	4501                	li	a0,0
  for(p = proc; p < &proc[NPROC]; p++){
    80001af0:	00007797          	auipc	a5,0x7
    80001af4:	40078793          	addi	a5,a5,1024 # 80008ef0 <proc>
    80001af8:	0000d697          	auipc	a3,0xd
    80001afc:	ff868693          	addi	a3,a3,-8 # 8000eaf0 <tickslock>
    80001b00:	a029                	j	80001b0a <kprocnum+0x22>
    80001b02:	17078793          	addi	a5,a5,368
    80001b06:	00d78663          	beq	a5,a3,80001b12 <kprocnum+0x2a>
    if(p->state != UNUSED)
    80001b0a:	4f98                	lw	a4,24(a5)
    80001b0c:	db7d                	beqz	a4,80001b02 <kprocnum+0x1a>
      num++;
    80001b0e:	2505                	addiw	a0,a0,1
    80001b10:	bfcd                	j	80001b02 <kprocnum+0x1a>
  }
 // printf("kprocnum returns: %d", num);
  return num;
}
    80001b12:	6422                	ld	s0,8(sp)
    80001b14:	0141                	addi	sp,sp,16
    80001b16:	8082                	ret

0000000080001b18 <swtch>:
    80001b18:	00153023          	sd	ra,0(a0)
    80001b1c:	00253423          	sd	sp,8(a0)
    80001b20:	e900                	sd	s0,16(a0)
    80001b22:	ed04                	sd	s1,24(a0)
    80001b24:	03253023          	sd	s2,32(a0)
    80001b28:	03353423          	sd	s3,40(a0)
    80001b2c:	03453823          	sd	s4,48(a0)
    80001b30:	03553c23          	sd	s5,56(a0)
    80001b34:	05653023          	sd	s6,64(a0)
    80001b38:	05753423          	sd	s7,72(a0)
    80001b3c:	05853823          	sd	s8,80(a0)
    80001b40:	05953c23          	sd	s9,88(a0)
    80001b44:	07a53023          	sd	s10,96(a0)
    80001b48:	07b53423          	sd	s11,104(a0)
    80001b4c:	0005b083          	ld	ra,0(a1)
    80001b50:	0085b103          	ld	sp,8(a1)
    80001b54:	6980                	ld	s0,16(a1)
    80001b56:	6d84                	ld	s1,24(a1)
    80001b58:	0205b903          	ld	s2,32(a1)
    80001b5c:	0285b983          	ld	s3,40(a1)
    80001b60:	0305ba03          	ld	s4,48(a1)
    80001b64:	0385ba83          	ld	s5,56(a1)
    80001b68:	0405bb03          	ld	s6,64(a1)
    80001b6c:	0485bb83          	ld	s7,72(a1)
    80001b70:	0505bc03          	ld	s8,80(a1)
    80001b74:	0585bc83          	ld	s9,88(a1)
    80001b78:	0605bd03          	ld	s10,96(a1)
    80001b7c:	0685bd83          	ld	s11,104(a1)
    80001b80:	8082                	ret

0000000080001b82 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b82:	1141                	addi	sp,sp,-16
    80001b84:	e406                	sd	ra,8(sp)
    80001b86:	e022                	sd	s0,0(sp)
    80001b88:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b8a:	00006597          	auipc	a1,0x6
    80001b8e:	72e58593          	addi	a1,a1,1838 # 800082b8 <states.1725+0x30>
    80001b92:	0000d517          	auipc	a0,0xd
    80001b96:	f5e50513          	addi	a0,a0,-162 # 8000eaf0 <tickslock>
    80001b9a:	00004097          	auipc	ra,0x4
    80001b9e:	682080e7          	jalr	1666(ra) # 8000621c <initlock>
}
    80001ba2:	60a2                	ld	ra,8(sp)
    80001ba4:	6402                	ld	s0,0(sp)
    80001ba6:	0141                	addi	sp,sp,16
    80001ba8:	8082                	ret

0000000080001baa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001baa:	1141                	addi	sp,sp,-16
    80001bac:	e422                	sd	s0,8(sp)
    80001bae:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bb0:	00003797          	auipc	a5,0x3
    80001bb4:	58078793          	addi	a5,a5,1408 # 80005130 <kernelvec>
    80001bb8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bbc:	6422                	ld	s0,8(sp)
    80001bbe:	0141                	addi	sp,sp,16
    80001bc0:	8082                	ret

0000000080001bc2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bc2:	1141                	addi	sp,sp,-16
    80001bc4:	e406                	sd	ra,8(sp)
    80001bc6:	e022                	sd	s0,0(sp)
    80001bc8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bca:	fffff097          	auipc	ra,0xfffff
    80001bce:	30c080e7          	jalr	780(ra) # 80000ed6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bd2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bd6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bd8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001bdc:	00005617          	auipc	a2,0x5
    80001be0:	42460613          	addi	a2,a2,1060 # 80007000 <_trampoline>
    80001be4:	00005697          	auipc	a3,0x5
    80001be8:	41c68693          	addi	a3,a3,1052 # 80007000 <_trampoline>
    80001bec:	8e91                	sub	a3,a3,a2
    80001bee:	040007b7          	lui	a5,0x4000
    80001bf2:	17fd                	addi	a5,a5,-1
    80001bf4:	07b2                	slli	a5,a5,0xc
    80001bf6:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bf8:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bfc:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bfe:	180026f3          	csrr	a3,satp
    80001c02:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c04:	6d38                	ld	a4,88(a0)
    80001c06:	6134                	ld	a3,64(a0)
    80001c08:	6585                	lui	a1,0x1
    80001c0a:	96ae                	add	a3,a3,a1
    80001c0c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c0e:	6d38                	ld	a4,88(a0)
    80001c10:	00000697          	auipc	a3,0x0
    80001c14:	13068693          	addi	a3,a3,304 # 80001d40 <usertrap>
    80001c18:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c1a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c1c:	8692                	mv	a3,tp
    80001c1e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c20:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c24:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c28:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c2c:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c30:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c32:	6f18                	ld	a4,24(a4)
    80001c34:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c38:	6928                	ld	a0,80(a0)
    80001c3a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c3c:	00005717          	auipc	a4,0x5
    80001c40:	46070713          	addi	a4,a4,1120 # 8000709c <userret>
    80001c44:	8f11                	sub	a4,a4,a2
    80001c46:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c48:	577d                	li	a4,-1
    80001c4a:	177e                	slli	a4,a4,0x3f
    80001c4c:	8d59                	or	a0,a0,a4
    80001c4e:	9782                	jalr	a5
}
    80001c50:	60a2                	ld	ra,8(sp)
    80001c52:	6402                	ld	s0,0(sp)
    80001c54:	0141                	addi	sp,sp,16
    80001c56:	8082                	ret

0000000080001c58 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c58:	1101                	addi	sp,sp,-32
    80001c5a:	ec06                	sd	ra,24(sp)
    80001c5c:	e822                	sd	s0,16(sp)
    80001c5e:	e426                	sd	s1,8(sp)
    80001c60:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c62:	0000d497          	auipc	s1,0xd
    80001c66:	e8e48493          	addi	s1,s1,-370 # 8000eaf0 <tickslock>
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	00004097          	auipc	ra,0x4
    80001c70:	640080e7          	jalr	1600(ra) # 800062ac <acquire>
  ticks++;
    80001c74:	00007517          	auipc	a0,0x7
    80001c78:	e1450513          	addi	a0,a0,-492 # 80008a88 <ticks>
    80001c7c:	411c                	lw	a5,0(a0)
    80001c7e:	2785                	addiw	a5,a5,1
    80001c80:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c82:	00000097          	auipc	ra,0x0
    80001c86:	968080e7          	jalr	-1688(ra) # 800015ea <wakeup>
  release(&tickslock);
    80001c8a:	8526                	mv	a0,s1
    80001c8c:	00004097          	auipc	ra,0x4
    80001c90:	6d4080e7          	jalr	1748(ra) # 80006360 <release>
}
    80001c94:	60e2                	ld	ra,24(sp)
    80001c96:	6442                	ld	s0,16(sp)
    80001c98:	64a2                	ld	s1,8(sp)
    80001c9a:	6105                	addi	sp,sp,32
    80001c9c:	8082                	ret

0000000080001c9e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c9e:	1101                	addi	sp,sp,-32
    80001ca0:	ec06                	sd	ra,24(sp)
    80001ca2:	e822                	sd	s0,16(sp)
    80001ca4:	e426                	sd	s1,8(sp)
    80001ca6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ca8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001cac:	00074d63          	bltz	a4,80001cc6 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001cb0:	57fd                	li	a5,-1
    80001cb2:	17fe                	slli	a5,a5,0x3f
    80001cb4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cb6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cb8:	06f70363          	beq	a4,a5,80001d1e <devintr+0x80>
  }
}
    80001cbc:	60e2                	ld	ra,24(sp)
    80001cbe:	6442                	ld	s0,16(sp)
    80001cc0:	64a2                	ld	s1,8(sp)
    80001cc2:	6105                	addi	sp,sp,32
    80001cc4:	8082                	ret
     (scause & 0xff) == 9){
    80001cc6:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001cca:	46a5                	li	a3,9
    80001ccc:	fed792e3          	bne	a5,a3,80001cb0 <devintr+0x12>
    int irq = plic_claim();
    80001cd0:	00003097          	auipc	ra,0x3
    80001cd4:	568080e7          	jalr	1384(ra) # 80005238 <plic_claim>
    80001cd8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cda:	47a9                	li	a5,10
    80001cdc:	02f50763          	beq	a0,a5,80001d0a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001ce0:	4785                	li	a5,1
    80001ce2:	02f50963          	beq	a0,a5,80001d14 <devintr+0x76>
    return 1;
    80001ce6:	4505                	li	a0,1
    } else if(irq){
    80001ce8:	d8f1                	beqz	s1,80001cbc <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cea:	85a6                	mv	a1,s1
    80001cec:	00006517          	auipc	a0,0x6
    80001cf0:	5d450513          	addi	a0,a0,1492 # 800082c0 <states.1725+0x38>
    80001cf4:	00004097          	auipc	ra,0x4
    80001cf8:	0b8080e7          	jalr	184(ra) # 80005dac <printf>
      plic_complete(irq);
    80001cfc:	8526                	mv	a0,s1
    80001cfe:	00003097          	auipc	ra,0x3
    80001d02:	55e080e7          	jalr	1374(ra) # 8000525c <plic_complete>
    return 1;
    80001d06:	4505                	li	a0,1
    80001d08:	bf55                	j	80001cbc <devintr+0x1e>
      uartintr();
    80001d0a:	00004097          	auipc	ra,0x4
    80001d0e:	4c2080e7          	jalr	1218(ra) # 800061cc <uartintr>
    80001d12:	b7ed                	j	80001cfc <devintr+0x5e>
      virtio_disk_intr();
    80001d14:	00004097          	auipc	ra,0x4
    80001d18:	a72080e7          	jalr	-1422(ra) # 80005786 <virtio_disk_intr>
    80001d1c:	b7c5                	j	80001cfc <devintr+0x5e>
    if(cpuid() == 0){
    80001d1e:	fffff097          	auipc	ra,0xfffff
    80001d22:	18c080e7          	jalr	396(ra) # 80000eaa <cpuid>
    80001d26:	c901                	beqz	a0,80001d36 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d28:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d2c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d2e:	14479073          	csrw	sip,a5
    return 2;
    80001d32:	4509                	li	a0,2
    80001d34:	b761                	j	80001cbc <devintr+0x1e>
      clockintr();
    80001d36:	00000097          	auipc	ra,0x0
    80001d3a:	f22080e7          	jalr	-222(ra) # 80001c58 <clockintr>
    80001d3e:	b7ed                	j	80001d28 <devintr+0x8a>

0000000080001d40 <usertrap>:
{
    80001d40:	1101                	addi	sp,sp,-32
    80001d42:	ec06                	sd	ra,24(sp)
    80001d44:	e822                	sd	s0,16(sp)
    80001d46:	e426                	sd	s1,8(sp)
    80001d48:	e04a                	sd	s2,0(sp)
    80001d4a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d4c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d50:	1007f793          	andi	a5,a5,256
    80001d54:	e3b1                	bnez	a5,80001d98 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d56:	00003797          	auipc	a5,0x3
    80001d5a:	3da78793          	addi	a5,a5,986 # 80005130 <kernelvec>
    80001d5e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d62:	fffff097          	auipc	ra,0xfffff
    80001d66:	174080e7          	jalr	372(ra) # 80000ed6 <myproc>
    80001d6a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d6c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d6e:	14102773          	csrr	a4,sepc
    80001d72:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d74:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d78:	47a1                	li	a5,8
    80001d7a:	02f70763          	beq	a4,a5,80001da8 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d7e:	00000097          	auipc	ra,0x0
    80001d82:	f20080e7          	jalr	-224(ra) # 80001c9e <devintr>
    80001d86:	892a                	mv	s2,a0
    80001d88:	c151                	beqz	a0,80001e0c <usertrap+0xcc>
  if(killed(p))
    80001d8a:	8526                	mv	a0,s1
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	aa2080e7          	jalr	-1374(ra) # 8000182e <killed>
    80001d94:	c929                	beqz	a0,80001de6 <usertrap+0xa6>
    80001d96:	a099                	j	80001ddc <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d98:	00006517          	auipc	a0,0x6
    80001d9c:	54850513          	addi	a0,a0,1352 # 800082e0 <states.1725+0x58>
    80001da0:	00004097          	auipc	ra,0x4
    80001da4:	fc2080e7          	jalr	-62(ra) # 80005d62 <panic>
    if(killed(p))
    80001da8:	00000097          	auipc	ra,0x0
    80001dac:	a86080e7          	jalr	-1402(ra) # 8000182e <killed>
    80001db0:	e921                	bnez	a0,80001e00 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001db2:	6cb8                	ld	a4,88(s1)
    80001db4:	6f1c                	ld	a5,24(a4)
    80001db6:	0791                	addi	a5,a5,4
    80001db8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dbe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dc2:	10079073          	csrw	sstatus,a5
    syscall();
    80001dc6:	00000097          	auipc	ra,0x0
    80001dca:	2d4080e7          	jalr	724(ra) # 8000209a <syscall>
  if(killed(p))
    80001dce:	8526                	mv	a0,s1
    80001dd0:	00000097          	auipc	ra,0x0
    80001dd4:	a5e080e7          	jalr	-1442(ra) # 8000182e <killed>
    80001dd8:	c911                	beqz	a0,80001dec <usertrap+0xac>
    80001dda:	4901                	li	s2,0
    exit(-1);
    80001ddc:	557d                	li	a0,-1
    80001dde:	00000097          	auipc	ra,0x0
    80001de2:	8dc080e7          	jalr	-1828(ra) # 800016ba <exit>
  if(which_dev == 2)
    80001de6:	4789                	li	a5,2
    80001de8:	04f90f63          	beq	s2,a5,80001e46 <usertrap+0x106>
  usertrapret();
    80001dec:	00000097          	auipc	ra,0x0
    80001df0:	dd6080e7          	jalr	-554(ra) # 80001bc2 <usertrapret>
}
    80001df4:	60e2                	ld	ra,24(sp)
    80001df6:	6442                	ld	s0,16(sp)
    80001df8:	64a2                	ld	s1,8(sp)
    80001dfa:	6902                	ld	s2,0(sp)
    80001dfc:	6105                	addi	sp,sp,32
    80001dfe:	8082                	ret
      exit(-1);
    80001e00:	557d                	li	a0,-1
    80001e02:	00000097          	auipc	ra,0x0
    80001e06:	8b8080e7          	jalr	-1864(ra) # 800016ba <exit>
    80001e0a:	b765                	j	80001db2 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e0c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e10:	5890                	lw	a2,48(s1)
    80001e12:	00006517          	auipc	a0,0x6
    80001e16:	4ee50513          	addi	a0,a0,1262 # 80008300 <states.1725+0x78>
    80001e1a:	00004097          	auipc	ra,0x4
    80001e1e:	f92080e7          	jalr	-110(ra) # 80005dac <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e22:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e26:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e2a:	00006517          	auipc	a0,0x6
    80001e2e:	50650513          	addi	a0,a0,1286 # 80008330 <states.1725+0xa8>
    80001e32:	00004097          	auipc	ra,0x4
    80001e36:	f7a080e7          	jalr	-134(ra) # 80005dac <printf>
    setkilled(p);
    80001e3a:	8526                	mv	a0,s1
    80001e3c:	00000097          	auipc	ra,0x0
    80001e40:	9c6080e7          	jalr	-1594(ra) # 80001802 <setkilled>
    80001e44:	b769                	j	80001dce <usertrap+0x8e>
    yield();
    80001e46:	fffff097          	auipc	ra,0xfffff
    80001e4a:	704080e7          	jalr	1796(ra) # 8000154a <yield>
    80001e4e:	bf79                	j	80001dec <usertrap+0xac>

0000000080001e50 <kerneltrap>:
{
    80001e50:	7179                	addi	sp,sp,-48
    80001e52:	f406                	sd	ra,40(sp)
    80001e54:	f022                	sd	s0,32(sp)
    80001e56:	ec26                	sd	s1,24(sp)
    80001e58:	e84a                	sd	s2,16(sp)
    80001e5a:	e44e                	sd	s3,8(sp)
    80001e5c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e5e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e62:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e66:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e6a:	1004f793          	andi	a5,s1,256
    80001e6e:	cb85                	beqz	a5,80001e9e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e70:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e74:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e76:	ef85                	bnez	a5,80001eae <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e78:	00000097          	auipc	ra,0x0
    80001e7c:	e26080e7          	jalr	-474(ra) # 80001c9e <devintr>
    80001e80:	cd1d                	beqz	a0,80001ebe <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e82:	4789                	li	a5,2
    80001e84:	06f50a63          	beq	a0,a5,80001ef8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e88:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e8c:	10049073          	csrw	sstatus,s1
}
    80001e90:	70a2                	ld	ra,40(sp)
    80001e92:	7402                	ld	s0,32(sp)
    80001e94:	64e2                	ld	s1,24(sp)
    80001e96:	6942                	ld	s2,16(sp)
    80001e98:	69a2                	ld	s3,8(sp)
    80001e9a:	6145                	addi	sp,sp,48
    80001e9c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e9e:	00006517          	auipc	a0,0x6
    80001ea2:	4b250513          	addi	a0,a0,1202 # 80008350 <states.1725+0xc8>
    80001ea6:	00004097          	auipc	ra,0x4
    80001eaa:	ebc080e7          	jalr	-324(ra) # 80005d62 <panic>
    panic("kerneltrap: interrupts enabled");
    80001eae:	00006517          	auipc	a0,0x6
    80001eb2:	4ca50513          	addi	a0,a0,1226 # 80008378 <states.1725+0xf0>
    80001eb6:	00004097          	auipc	ra,0x4
    80001eba:	eac080e7          	jalr	-340(ra) # 80005d62 <panic>
    printf("scause %p\n", scause);
    80001ebe:	85ce                	mv	a1,s3
    80001ec0:	00006517          	auipc	a0,0x6
    80001ec4:	4d850513          	addi	a0,a0,1240 # 80008398 <states.1725+0x110>
    80001ec8:	00004097          	auipc	ra,0x4
    80001ecc:	ee4080e7          	jalr	-284(ra) # 80005dac <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ed0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ed4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ed8:	00006517          	auipc	a0,0x6
    80001edc:	4d050513          	addi	a0,a0,1232 # 800083a8 <states.1725+0x120>
    80001ee0:	00004097          	auipc	ra,0x4
    80001ee4:	ecc080e7          	jalr	-308(ra) # 80005dac <printf>
    panic("kerneltrap");
    80001ee8:	00006517          	auipc	a0,0x6
    80001eec:	4d850513          	addi	a0,a0,1240 # 800083c0 <states.1725+0x138>
    80001ef0:	00004097          	auipc	ra,0x4
    80001ef4:	e72080e7          	jalr	-398(ra) # 80005d62 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	fde080e7          	jalr	-34(ra) # 80000ed6 <myproc>
    80001f00:	d541                	beqz	a0,80001e88 <kerneltrap+0x38>
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	fd4080e7          	jalr	-44(ra) # 80000ed6 <myproc>
    80001f0a:	4d18                	lw	a4,24(a0)
    80001f0c:	4791                	li	a5,4
    80001f0e:	f6f71de3          	bne	a4,a5,80001e88 <kerneltrap+0x38>
    yield();
    80001f12:	fffff097          	auipc	ra,0xfffff
    80001f16:	638080e7          	jalr	1592(ra) # 8000154a <yield>
    80001f1a:	b7bd                	j	80001e88 <kerneltrap+0x38>

0000000080001f1c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f1c:	1101                	addi	sp,sp,-32
    80001f1e:	ec06                	sd	ra,24(sp)
    80001f20:	e822                	sd	s0,16(sp)
    80001f22:	e426                	sd	s1,8(sp)
    80001f24:	1000                	addi	s0,sp,32
    80001f26:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f28:	fffff097          	auipc	ra,0xfffff
    80001f2c:	fae080e7          	jalr	-82(ra) # 80000ed6 <myproc>
  switch (n) {
    80001f30:	4795                	li	a5,5
    80001f32:	0497e163          	bltu	a5,s1,80001f74 <argraw+0x58>
    80001f36:	048a                	slli	s1,s1,0x2
    80001f38:	00006717          	auipc	a4,0x6
    80001f3c:	58870713          	addi	a4,a4,1416 # 800084c0 <states.1725+0x238>
    80001f40:	94ba                	add	s1,s1,a4
    80001f42:	409c                	lw	a5,0(s1)
    80001f44:	97ba                	add	a5,a5,a4
    80001f46:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f48:	6d3c                	ld	a5,88(a0)
    80001f4a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f4c:	60e2                	ld	ra,24(sp)
    80001f4e:	6442                	ld	s0,16(sp)
    80001f50:	64a2                	ld	s1,8(sp)
    80001f52:	6105                	addi	sp,sp,32
    80001f54:	8082                	ret
    return p->trapframe->a1;
    80001f56:	6d3c                	ld	a5,88(a0)
    80001f58:	7fa8                	ld	a0,120(a5)
    80001f5a:	bfcd                	j	80001f4c <argraw+0x30>
    return p->trapframe->a2;
    80001f5c:	6d3c                	ld	a5,88(a0)
    80001f5e:	63c8                	ld	a0,128(a5)
    80001f60:	b7f5                	j	80001f4c <argraw+0x30>
    return p->trapframe->a3;
    80001f62:	6d3c                	ld	a5,88(a0)
    80001f64:	67c8                	ld	a0,136(a5)
    80001f66:	b7dd                	j	80001f4c <argraw+0x30>
    return p->trapframe->a4;
    80001f68:	6d3c                	ld	a5,88(a0)
    80001f6a:	6bc8                	ld	a0,144(a5)
    80001f6c:	b7c5                	j	80001f4c <argraw+0x30>
    return p->trapframe->a5;
    80001f6e:	6d3c                	ld	a5,88(a0)
    80001f70:	6fc8                	ld	a0,152(a5)
    80001f72:	bfe9                	j	80001f4c <argraw+0x30>
  panic("argraw");
    80001f74:	00006517          	auipc	a0,0x6
    80001f78:	45c50513          	addi	a0,a0,1116 # 800083d0 <states.1725+0x148>
    80001f7c:	00004097          	auipc	ra,0x4
    80001f80:	de6080e7          	jalr	-538(ra) # 80005d62 <panic>

0000000080001f84 <fetchaddr>:
{
    80001f84:	1101                	addi	sp,sp,-32
    80001f86:	ec06                	sd	ra,24(sp)
    80001f88:	e822                	sd	s0,16(sp)
    80001f8a:	e426                	sd	s1,8(sp)
    80001f8c:	e04a                	sd	s2,0(sp)
    80001f8e:	1000                	addi	s0,sp,32
    80001f90:	84aa                	mv	s1,a0
    80001f92:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	f42080e7          	jalr	-190(ra) # 80000ed6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f9c:	653c                	ld	a5,72(a0)
    80001f9e:	02f4f863          	bgeu	s1,a5,80001fce <fetchaddr+0x4a>
    80001fa2:	00848713          	addi	a4,s1,8
    80001fa6:	02e7e663          	bltu	a5,a4,80001fd2 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001faa:	46a1                	li	a3,8
    80001fac:	8626                	mv	a2,s1
    80001fae:	85ca                	mv	a1,s2
    80001fb0:	6928                	ld	a0,80(a0)
    80001fb2:	fffff097          	auipc	ra,0xfffff
    80001fb6:	c6e080e7          	jalr	-914(ra) # 80000c20 <copyin>
    80001fba:	00a03533          	snez	a0,a0
    80001fbe:	40a00533          	neg	a0,a0
}
    80001fc2:	60e2                	ld	ra,24(sp)
    80001fc4:	6442                	ld	s0,16(sp)
    80001fc6:	64a2                	ld	s1,8(sp)
    80001fc8:	6902                	ld	s2,0(sp)
    80001fca:	6105                	addi	sp,sp,32
    80001fcc:	8082                	ret
    return -1;
    80001fce:	557d                	li	a0,-1
    80001fd0:	bfcd                	j	80001fc2 <fetchaddr+0x3e>
    80001fd2:	557d                	li	a0,-1
    80001fd4:	b7fd                	j	80001fc2 <fetchaddr+0x3e>

0000000080001fd6 <fetchstr>:
{
    80001fd6:	7179                	addi	sp,sp,-48
    80001fd8:	f406                	sd	ra,40(sp)
    80001fda:	f022                	sd	s0,32(sp)
    80001fdc:	ec26                	sd	s1,24(sp)
    80001fde:	e84a                	sd	s2,16(sp)
    80001fe0:	e44e                	sd	s3,8(sp)
    80001fe2:	1800                	addi	s0,sp,48
    80001fe4:	892a                	mv	s2,a0
    80001fe6:	84ae                	mv	s1,a1
    80001fe8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	eec080e7          	jalr	-276(ra) # 80000ed6 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001ff2:	86ce                	mv	a3,s3
    80001ff4:	864a                	mv	a2,s2
    80001ff6:	85a6                	mv	a1,s1
    80001ff8:	6928                	ld	a0,80(a0)
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	cb2080e7          	jalr	-846(ra) # 80000cac <copyinstr>
    80002002:	00054e63          	bltz	a0,8000201e <fetchstr+0x48>
  return strlen(buf);
    80002006:	8526                	mv	a0,s1
    80002008:	ffffe097          	auipc	ra,0xffffe
    8000200c:	31a080e7          	jalr	794(ra) # 80000322 <strlen>
}
    80002010:	70a2                	ld	ra,40(sp)
    80002012:	7402                	ld	s0,32(sp)
    80002014:	64e2                	ld	s1,24(sp)
    80002016:	6942                	ld	s2,16(sp)
    80002018:	69a2                	ld	s3,8(sp)
    8000201a:	6145                	addi	sp,sp,48
    8000201c:	8082                	ret
    return -1;
    8000201e:	557d                	li	a0,-1
    80002020:	bfc5                	j	80002010 <fetchstr+0x3a>

0000000080002022 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002022:	1101                	addi	sp,sp,-32
    80002024:	ec06                	sd	ra,24(sp)
    80002026:	e822                	sd	s0,16(sp)
    80002028:	e426                	sd	s1,8(sp)
    8000202a:	1000                	addi	s0,sp,32
    8000202c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000202e:	00000097          	auipc	ra,0x0
    80002032:	eee080e7          	jalr	-274(ra) # 80001f1c <argraw>
    80002036:	c088                	sw	a0,0(s1)
}
    80002038:	60e2                	ld	ra,24(sp)
    8000203a:	6442                	ld	s0,16(sp)
    8000203c:	64a2                	ld	s1,8(sp)
    8000203e:	6105                	addi	sp,sp,32
    80002040:	8082                	ret

0000000080002042 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002042:	1101                	addi	sp,sp,-32
    80002044:	ec06                	sd	ra,24(sp)
    80002046:	e822                	sd	s0,16(sp)
    80002048:	e426                	sd	s1,8(sp)
    8000204a:	1000                	addi	s0,sp,32
    8000204c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000204e:	00000097          	auipc	ra,0x0
    80002052:	ece080e7          	jalr	-306(ra) # 80001f1c <argraw>
    80002056:	e088                	sd	a0,0(s1)
}
    80002058:	60e2                	ld	ra,24(sp)
    8000205a:	6442                	ld	s0,16(sp)
    8000205c:	64a2                	ld	s1,8(sp)
    8000205e:	6105                	addi	sp,sp,32
    80002060:	8082                	ret

0000000080002062 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002062:	7179                	addi	sp,sp,-48
    80002064:	f406                	sd	ra,40(sp)
    80002066:	f022                	sd	s0,32(sp)
    80002068:	ec26                	sd	s1,24(sp)
    8000206a:	e84a                	sd	s2,16(sp)
    8000206c:	1800                	addi	s0,sp,48
    8000206e:	84ae                	mv	s1,a1
    80002070:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002072:	fd840593          	addi	a1,s0,-40
    80002076:	00000097          	auipc	ra,0x0
    8000207a:	fcc080e7          	jalr	-52(ra) # 80002042 <argaddr>
  return fetchstr(addr, buf, max);
    8000207e:	864a                	mv	a2,s2
    80002080:	85a6                	mv	a1,s1
    80002082:	fd843503          	ld	a0,-40(s0)
    80002086:	00000097          	auipc	ra,0x0
    8000208a:	f50080e7          	jalr	-176(ra) # 80001fd6 <fetchstr>
}
    8000208e:	70a2                	ld	ra,40(sp)
    80002090:	7402                	ld	s0,32(sp)
    80002092:	64e2                	ld	s1,24(sp)
    80002094:	6942                	ld	s2,16(sp)
    80002096:	6145                	addi	sp,sp,48
    80002098:	8082                	ret

000000008000209a <syscall>:
    "sysinfo"
};

void
syscall(void)
{
    8000209a:	7179                	addi	sp,sp,-48
    8000209c:	f406                	sd	ra,40(sp)
    8000209e:	f022                	sd	s0,32(sp)
    800020a0:	ec26                	sd	s1,24(sp)
    800020a2:	e84a                	sd	s2,16(sp)
    800020a4:	e44e                	sd	s3,8(sp)
    800020a6:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    800020a8:	fffff097          	auipc	ra,0xfffff
    800020ac:	e2e080e7          	jalr	-466(ra) # 80000ed6 <myproc>
    800020b0:	84aa                	mv	s1,a0
  num = p->trapframe->a7;
    800020b2:	6d3c                	ld	a5,88(a0)
    800020b4:	77dc                	ld	a5,168(a5)
    800020b6:	0007891b          	sext.w	s2,a5

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020ba:	37fd                	addiw	a5,a5,-1
    800020bc:	4759                	li	a4,22
    800020be:	04f76d63          	bltu	a4,a5,80002118 <syscall+0x7e>
    800020c2:	00391713          	slli	a4,s2,0x3
    800020c6:	00006797          	auipc	a5,0x6
    800020ca:	41278793          	addi	a5,a5,1042 # 800084d8 <syscalls>
    800020ce:	97ba                	add	a5,a5,a4
    800020d0:	639c                	ld	a5,0(a5)
    800020d2:	c3b9                	beqz	a5,80002118 <syscall+0x7e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    int mdval;
    mdval = syscalls[num]();
    800020d4:	9782                	jalr	a5
    800020d6:	0005099b          	sext.w	s3,a0
    if(p->mask & (1 << num))
    800020da:	1684a783          	lw	a5,360(s1)
    800020de:	4127d7bb          	sraw	a5,a5,s2
    800020e2:	8b85                	andi	a5,a5,1
    800020e4:	e789                	bnez	a5,800020ee <syscall+0x54>
    {
      //printf("num - 1 : %d, corresponding syscallname: %s\n", num - 1, syscallname[num - 1]);
      printf("%d: syscall %s -> %d\n", p->pid, syscallname[num - 1], mdval);
    }
    p->trapframe->a0 = mdval;
    800020e6:	6cbc                	ld	a5,88(s1)
    800020e8:	0737b823          	sd	s3,112(a5)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020ec:	a0a9                	j	80002136 <syscall+0x9c>
      printf("%d: syscall %s -> %d\n", p->pid, syscallname[num - 1], mdval);
    800020ee:	397d                	addiw	s2,s2,-1
    800020f0:	00391793          	slli	a5,s2,0x3
    800020f4:	00007917          	auipc	s2,0x7
    800020f8:	8a490913          	addi	s2,s2,-1884 # 80008998 <syscallname>
    800020fc:	993e                	add	s2,s2,a5
    800020fe:	86ce                	mv	a3,s3
    80002100:	00093603          	ld	a2,0(s2)
    80002104:	588c                	lw	a1,48(s1)
    80002106:	00006517          	auipc	a0,0x6
    8000210a:	2d250513          	addi	a0,a0,722 # 800083d8 <states.1725+0x150>
    8000210e:	00004097          	auipc	ra,0x4
    80002112:	c9e080e7          	jalr	-866(ra) # 80005dac <printf>
    80002116:	bfc1                	j	800020e6 <syscall+0x4c>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002118:	86ca                	mv	a3,s2
    8000211a:	15848613          	addi	a2,s1,344
    8000211e:	588c                	lw	a1,48(s1)
    80002120:	00006517          	auipc	a0,0x6
    80002124:	2d050513          	addi	a0,a0,720 # 800083f0 <states.1725+0x168>
    80002128:	00004097          	auipc	ra,0x4
    8000212c:	c84080e7          	jalr	-892(ra) # 80005dac <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002130:	6cbc                	ld	a5,88(s1)
    80002132:	577d                	li	a4,-1
    80002134:	fbb8                	sd	a4,112(a5)
  }
}
    80002136:	70a2                	ld	ra,40(sp)
    80002138:	7402                	ld	s0,32(sp)
    8000213a:	64e2                	ld	s1,24(sp)
    8000213c:	6942                	ld	s2,16(sp)
    8000213e:	69a2                	ld	s3,8(sp)
    80002140:	6145                	addi	sp,sp,48
    80002142:	8082                	ret

0000000080002144 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80002144:	1101                	addi	sp,sp,-32
    80002146:	ec06                	sd	ra,24(sp)
    80002148:	e822                	sd	s0,16(sp)
    8000214a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000214c:	fec40593          	addi	a1,s0,-20
    80002150:	4501                	li	a0,0
    80002152:	00000097          	auipc	ra,0x0
    80002156:	ed0080e7          	jalr	-304(ra) # 80002022 <argint>
  exit(n);
    8000215a:	fec42503          	lw	a0,-20(s0)
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	55c080e7          	jalr	1372(ra) # 800016ba <exit>
  return 0;  // not reached
}
    80002166:	4501                	li	a0,0
    80002168:	60e2                	ld	ra,24(sp)
    8000216a:	6442                	ld	s0,16(sp)
    8000216c:	6105                	addi	sp,sp,32
    8000216e:	8082                	ret

0000000080002170 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002170:	1141                	addi	sp,sp,-16
    80002172:	e406                	sd	ra,8(sp)
    80002174:	e022                	sd	s0,0(sp)
    80002176:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002178:	fffff097          	auipc	ra,0xfffff
    8000217c:	d5e080e7          	jalr	-674(ra) # 80000ed6 <myproc>
}
    80002180:	5908                	lw	a0,48(a0)
    80002182:	60a2                	ld	ra,8(sp)
    80002184:	6402                	ld	s0,0(sp)
    80002186:	0141                	addi	sp,sp,16
    80002188:	8082                	ret

000000008000218a <sys_fork>:

uint64
sys_fork(void)
{
    8000218a:	1141                	addi	sp,sp,-16
    8000218c:	e406                	sd	ra,8(sp)
    8000218e:	e022                	sd	s0,0(sp)
    80002190:	0800                	addi	s0,sp,16
  return fork();
    80002192:	fffff097          	auipc	ra,0xfffff
    80002196:	0fe080e7          	jalr	254(ra) # 80001290 <fork>
}
    8000219a:	60a2                	ld	ra,8(sp)
    8000219c:	6402                	ld	s0,0(sp)
    8000219e:	0141                	addi	sp,sp,16
    800021a0:	8082                	ret

00000000800021a2 <sys_wait>:

uint64
sys_wait(void)
{
    800021a2:	1101                	addi	sp,sp,-32
    800021a4:	ec06                	sd	ra,24(sp)
    800021a6:	e822                	sd	s0,16(sp)
    800021a8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021aa:	fe840593          	addi	a1,s0,-24
    800021ae:	4501                	li	a0,0
    800021b0:	00000097          	auipc	ra,0x0
    800021b4:	e92080e7          	jalr	-366(ra) # 80002042 <argaddr>
  return wait(p);
    800021b8:	fe843503          	ld	a0,-24(s0)
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	6a4080e7          	jalr	1700(ra) # 80001860 <wait>
}
    800021c4:	60e2                	ld	ra,24(sp)
    800021c6:	6442                	ld	s0,16(sp)
    800021c8:	6105                	addi	sp,sp,32
    800021ca:	8082                	ret

00000000800021cc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021cc:	7179                	addi	sp,sp,-48
    800021ce:	f406                	sd	ra,40(sp)
    800021d0:	f022                	sd	s0,32(sp)
    800021d2:	ec26                	sd	s1,24(sp)
    800021d4:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021d6:	fdc40593          	addi	a1,s0,-36
    800021da:	4501                	li	a0,0
    800021dc:	00000097          	auipc	ra,0x0
    800021e0:	e46080e7          	jalr	-442(ra) # 80002022 <argint>
  addr = myproc()->sz;
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	cf2080e7          	jalr	-782(ra) # 80000ed6 <myproc>
    800021ec:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021ee:	fdc42503          	lw	a0,-36(s0)
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	042080e7          	jalr	66(ra) # 80001234 <growproc>
    800021fa:	00054863          	bltz	a0,8000220a <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021fe:	8526                	mv	a0,s1
    80002200:	70a2                	ld	ra,40(sp)
    80002202:	7402                	ld	s0,32(sp)
    80002204:	64e2                	ld	s1,24(sp)
    80002206:	6145                	addi	sp,sp,48
    80002208:	8082                	ret
    return -1;
    8000220a:	54fd                	li	s1,-1
    8000220c:	bfcd                	j	800021fe <sys_sbrk+0x32>

000000008000220e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000220e:	7139                	addi	sp,sp,-64
    80002210:	fc06                	sd	ra,56(sp)
    80002212:	f822                	sd	s0,48(sp)
    80002214:	f426                	sd	s1,40(sp)
    80002216:	f04a                	sd	s2,32(sp)
    80002218:	ec4e                	sd	s3,24(sp)
    8000221a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000221c:	fcc40593          	addi	a1,s0,-52
    80002220:	4501                	li	a0,0
    80002222:	00000097          	auipc	ra,0x0
    80002226:	e00080e7          	jalr	-512(ra) # 80002022 <argint>
  if(n < 0)
    8000222a:	fcc42783          	lw	a5,-52(s0)
    8000222e:	0607cf63          	bltz	a5,800022ac <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002232:	0000d517          	auipc	a0,0xd
    80002236:	8be50513          	addi	a0,a0,-1858 # 8000eaf0 <tickslock>
    8000223a:	00004097          	auipc	ra,0x4
    8000223e:	072080e7          	jalr	114(ra) # 800062ac <acquire>
  ticks0 = ticks;
    80002242:	00007917          	auipc	s2,0x7
    80002246:	84692903          	lw	s2,-1978(s2) # 80008a88 <ticks>
  while(ticks - ticks0 < n){
    8000224a:	fcc42783          	lw	a5,-52(s0)
    8000224e:	cf9d                	beqz	a5,8000228c <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002250:	0000d997          	auipc	s3,0xd
    80002254:	8a098993          	addi	s3,s3,-1888 # 8000eaf0 <tickslock>
    80002258:	00007497          	auipc	s1,0x7
    8000225c:	83048493          	addi	s1,s1,-2000 # 80008a88 <ticks>
    if(killed(myproc())){
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	c76080e7          	jalr	-906(ra) # 80000ed6 <myproc>
    80002268:	fffff097          	auipc	ra,0xfffff
    8000226c:	5c6080e7          	jalr	1478(ra) # 8000182e <killed>
    80002270:	e129                	bnez	a0,800022b2 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002272:	85ce                	mv	a1,s3
    80002274:	8526                	mv	a0,s1
    80002276:	fffff097          	auipc	ra,0xfffff
    8000227a:	310080e7          	jalr	784(ra) # 80001586 <sleep>
  while(ticks - ticks0 < n){
    8000227e:	409c                	lw	a5,0(s1)
    80002280:	412787bb          	subw	a5,a5,s2
    80002284:	fcc42703          	lw	a4,-52(s0)
    80002288:	fce7ece3          	bltu	a5,a4,80002260 <sys_sleep+0x52>
  }
  release(&tickslock);
    8000228c:	0000d517          	auipc	a0,0xd
    80002290:	86450513          	addi	a0,a0,-1948 # 8000eaf0 <tickslock>
    80002294:	00004097          	auipc	ra,0x4
    80002298:	0cc080e7          	jalr	204(ra) # 80006360 <release>
  return 0;
    8000229c:	4501                	li	a0,0
}
    8000229e:	70e2                	ld	ra,56(sp)
    800022a0:	7442                	ld	s0,48(sp)
    800022a2:	74a2                	ld	s1,40(sp)
    800022a4:	7902                	ld	s2,32(sp)
    800022a6:	69e2                	ld	s3,24(sp)
    800022a8:	6121                	addi	sp,sp,64
    800022aa:	8082                	ret
    n = 0;
    800022ac:	fc042623          	sw	zero,-52(s0)
    800022b0:	b749                	j	80002232 <sys_sleep+0x24>
      release(&tickslock);
    800022b2:	0000d517          	auipc	a0,0xd
    800022b6:	83e50513          	addi	a0,a0,-1986 # 8000eaf0 <tickslock>
    800022ba:	00004097          	auipc	ra,0x4
    800022be:	0a6080e7          	jalr	166(ra) # 80006360 <release>
      return -1;
    800022c2:	557d                	li	a0,-1
    800022c4:	bfe9                	j	8000229e <sys_sleep+0x90>

00000000800022c6 <sys_kill>:

uint64
sys_kill(void)
{
    800022c6:	1101                	addi	sp,sp,-32
    800022c8:	ec06                	sd	ra,24(sp)
    800022ca:	e822                	sd	s0,16(sp)
    800022cc:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022ce:	fec40593          	addi	a1,s0,-20
    800022d2:	4501                	li	a0,0
    800022d4:	00000097          	auipc	ra,0x0
    800022d8:	d4e080e7          	jalr	-690(ra) # 80002022 <argint>
  return kill(pid);
    800022dc:	fec42503          	lw	a0,-20(s0)
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	4b0080e7          	jalr	1200(ra) # 80001790 <kill>
}
    800022e8:	60e2                	ld	ra,24(sp)
    800022ea:	6442                	ld	s0,16(sp)
    800022ec:	6105                	addi	sp,sp,32
    800022ee:	8082                	ret

00000000800022f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022f0:	1101                	addi	sp,sp,-32
    800022f2:	ec06                	sd	ra,24(sp)
    800022f4:	e822                	sd	s0,16(sp)
    800022f6:	e426                	sd	s1,8(sp)
    800022f8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022fa:	0000c517          	auipc	a0,0xc
    800022fe:	7f650513          	addi	a0,a0,2038 # 8000eaf0 <tickslock>
    80002302:	00004097          	auipc	ra,0x4
    80002306:	faa080e7          	jalr	-86(ra) # 800062ac <acquire>
  xticks = ticks;
    8000230a:	00006497          	auipc	s1,0x6
    8000230e:	77e4a483          	lw	s1,1918(s1) # 80008a88 <ticks>
  release(&tickslock);
    80002312:	0000c517          	auipc	a0,0xc
    80002316:	7de50513          	addi	a0,a0,2014 # 8000eaf0 <tickslock>
    8000231a:	00004097          	auipc	ra,0x4
    8000231e:	046080e7          	jalr	70(ra) # 80006360 <release>
  return xticks;
}
    80002322:	02049513          	slli	a0,s1,0x20
    80002326:	9101                	srli	a0,a0,0x20
    80002328:	60e2                	ld	ra,24(sp)
    8000232a:	6442                	ld	s0,16(sp)
    8000232c:	64a2                	ld	s1,8(sp)
    8000232e:	6105                	addi	sp,sp,32
    80002330:	8082                	ret

0000000080002332 <sys_trace>:

uint64
sys_trace(void)
{
    80002332:	1101                	addi	sp,sp,-32
    80002334:	ec06                	sd	ra,24(sp)
    80002336:	e822                	sd	s0,16(sp)
    80002338:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);
    8000233a:	fec40593          	addi	a1,s0,-20
    8000233e:	4501                	li	a0,0
    80002340:	00000097          	auipc	ra,0x0
    80002344:	ce2080e7          	jalr	-798(ra) # 80002022 <argint>
  if(mask < 0)
    80002348:	fec42783          	lw	a5,-20(s0)
    return -1;
    8000234c:	557d                	li	a0,-1
  if(mask < 0)
    8000234e:	0007cb63          	bltz	a5,80002364 <sys_trace+0x32>
  myproc()->mask = mask;
    80002352:	fffff097          	auipc	ra,0xfffff
    80002356:	b84080e7          	jalr	-1148(ra) # 80000ed6 <myproc>
    8000235a:	fec42783          	lw	a5,-20(s0)
    8000235e:	16f52423          	sw	a5,360(a0)
  return 0;  
    80002362:	4501                	li	a0,0
}
    80002364:	60e2                	ld	ra,24(sp)
    80002366:	6442                	ld	s0,16(sp)
    80002368:	6105                	addi	sp,sp,32
    8000236a:	8082                	ret

000000008000236c <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    8000236c:	7179                	addi	sp,sp,-48
    8000236e:	f406                	sd	ra,40(sp)
    80002370:	f022                	sd	s0,32(sp)
    80002372:	1800                	addi	s0,sp,48
  struct sysinfo info;
  info.freemem = kfreemem();
    80002374:	ffffe097          	auipc	ra,0xffffe
    80002378:	e04080e7          	jalr	-508(ra) # 80000178 <kfreemem>
    8000237c:	fea43023          	sd	a0,-32(s0)
  info.nproc = kprocnum();
    80002380:	fffff097          	auipc	ra,0xfffff
    80002384:	768080e7          	jalr	1896(ra) # 80001ae8 <kprocnum>
    80002388:	fea43423          	sd	a0,-24(s0)
  
  uint64 addr;
  argaddr(0, &addr);
    8000238c:	fd840593          	addi	a1,s0,-40
    80002390:	4501                	li	a0,0
    80002392:	00000097          	auipc	ra,0x0
    80002396:	cb0080e7          	jalr	-848(ra) # 80002042 <argaddr>
  
  if(copyout(myproc()->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    8000239a:	fffff097          	auipc	ra,0xfffff
    8000239e:	b3c080e7          	jalr	-1220(ra) # 80000ed6 <myproc>
    800023a2:	46c1                	li	a3,16
    800023a4:	fe040613          	addi	a2,s0,-32
    800023a8:	fd843583          	ld	a1,-40(s0)
    800023ac:	6928                	ld	a0,80(a0)
    800023ae:	ffffe097          	auipc	ra,0xffffe
    800023b2:	7b2080e7          	jalr	1970(ra) # 80000b60 <copyout>
    return -1;

  return 0;


}
    800023b6:	957d                	srai	a0,a0,0x3f
    800023b8:	70a2                	ld	ra,40(sp)
    800023ba:	7402                	ld	s0,32(sp)
    800023bc:	6145                	addi	sp,sp,48
    800023be:	8082                	ret

00000000800023c0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023c0:	7179                	addi	sp,sp,-48
    800023c2:	f406                	sd	ra,40(sp)
    800023c4:	f022                	sd	s0,32(sp)
    800023c6:	ec26                	sd	s1,24(sp)
    800023c8:	e84a                	sd	s2,16(sp)
    800023ca:	e44e                	sd	s3,8(sp)
    800023cc:	e052                	sd	s4,0(sp)
    800023ce:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023d0:	00006597          	auipc	a1,0x6
    800023d4:	1c858593          	addi	a1,a1,456 # 80008598 <syscalls+0xc0>
    800023d8:	0000c517          	auipc	a0,0xc
    800023dc:	73050513          	addi	a0,a0,1840 # 8000eb08 <bcache>
    800023e0:	00004097          	auipc	ra,0x4
    800023e4:	e3c080e7          	jalr	-452(ra) # 8000621c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023e8:	00014797          	auipc	a5,0x14
    800023ec:	72078793          	addi	a5,a5,1824 # 80016b08 <bcache+0x8000>
    800023f0:	00015717          	auipc	a4,0x15
    800023f4:	98070713          	addi	a4,a4,-1664 # 80016d70 <bcache+0x8268>
    800023f8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023fc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002400:	0000c497          	auipc	s1,0xc
    80002404:	72048493          	addi	s1,s1,1824 # 8000eb20 <bcache+0x18>
    b->next = bcache.head.next;
    80002408:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000240a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000240c:	00006a17          	auipc	s4,0x6
    80002410:	194a0a13          	addi	s4,s4,404 # 800085a0 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002414:	2b893783          	ld	a5,696(s2)
    80002418:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000241a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000241e:	85d2                	mv	a1,s4
    80002420:	01048513          	addi	a0,s1,16
    80002424:	00001097          	auipc	ra,0x1
    80002428:	4c4080e7          	jalr	1220(ra) # 800038e8 <initsleeplock>
    bcache.head.next->prev = b;
    8000242c:	2b893783          	ld	a5,696(s2)
    80002430:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002432:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002436:	45848493          	addi	s1,s1,1112
    8000243a:	fd349de3          	bne	s1,s3,80002414 <binit+0x54>
  }
}
    8000243e:	70a2                	ld	ra,40(sp)
    80002440:	7402                	ld	s0,32(sp)
    80002442:	64e2                	ld	s1,24(sp)
    80002444:	6942                	ld	s2,16(sp)
    80002446:	69a2                	ld	s3,8(sp)
    80002448:	6a02                	ld	s4,0(sp)
    8000244a:	6145                	addi	sp,sp,48
    8000244c:	8082                	ret

000000008000244e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000244e:	7179                	addi	sp,sp,-48
    80002450:	f406                	sd	ra,40(sp)
    80002452:	f022                	sd	s0,32(sp)
    80002454:	ec26                	sd	s1,24(sp)
    80002456:	e84a                	sd	s2,16(sp)
    80002458:	e44e                	sd	s3,8(sp)
    8000245a:	1800                	addi	s0,sp,48
    8000245c:	89aa                	mv	s3,a0
    8000245e:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002460:	0000c517          	auipc	a0,0xc
    80002464:	6a850513          	addi	a0,a0,1704 # 8000eb08 <bcache>
    80002468:	00004097          	auipc	ra,0x4
    8000246c:	e44080e7          	jalr	-444(ra) # 800062ac <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002470:	00015497          	auipc	s1,0x15
    80002474:	9504b483          	ld	s1,-1712(s1) # 80016dc0 <bcache+0x82b8>
    80002478:	00015797          	auipc	a5,0x15
    8000247c:	8f878793          	addi	a5,a5,-1800 # 80016d70 <bcache+0x8268>
    80002480:	02f48f63          	beq	s1,a5,800024be <bread+0x70>
    80002484:	873e                	mv	a4,a5
    80002486:	a021                	j	8000248e <bread+0x40>
    80002488:	68a4                	ld	s1,80(s1)
    8000248a:	02e48a63          	beq	s1,a4,800024be <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000248e:	449c                	lw	a5,8(s1)
    80002490:	ff379ce3          	bne	a5,s3,80002488 <bread+0x3a>
    80002494:	44dc                	lw	a5,12(s1)
    80002496:	ff2799e3          	bne	a5,s2,80002488 <bread+0x3a>
      b->refcnt++;
    8000249a:	40bc                	lw	a5,64(s1)
    8000249c:	2785                	addiw	a5,a5,1
    8000249e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024a0:	0000c517          	auipc	a0,0xc
    800024a4:	66850513          	addi	a0,a0,1640 # 8000eb08 <bcache>
    800024a8:	00004097          	auipc	ra,0x4
    800024ac:	eb8080e7          	jalr	-328(ra) # 80006360 <release>
      acquiresleep(&b->lock);
    800024b0:	01048513          	addi	a0,s1,16
    800024b4:	00001097          	auipc	ra,0x1
    800024b8:	46e080e7          	jalr	1134(ra) # 80003922 <acquiresleep>
      return b;
    800024bc:	a8b9                	j	8000251a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024be:	00015497          	auipc	s1,0x15
    800024c2:	8fa4b483          	ld	s1,-1798(s1) # 80016db8 <bcache+0x82b0>
    800024c6:	00015797          	auipc	a5,0x15
    800024ca:	8aa78793          	addi	a5,a5,-1878 # 80016d70 <bcache+0x8268>
    800024ce:	00f48863          	beq	s1,a5,800024de <bread+0x90>
    800024d2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024d4:	40bc                	lw	a5,64(s1)
    800024d6:	cf81                	beqz	a5,800024ee <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024d8:	64a4                	ld	s1,72(s1)
    800024da:	fee49de3          	bne	s1,a4,800024d4 <bread+0x86>
  panic("bget: no buffers");
    800024de:	00006517          	auipc	a0,0x6
    800024e2:	0ca50513          	addi	a0,a0,202 # 800085a8 <syscalls+0xd0>
    800024e6:	00004097          	auipc	ra,0x4
    800024ea:	87c080e7          	jalr	-1924(ra) # 80005d62 <panic>
      b->dev = dev;
    800024ee:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800024f2:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800024f6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024fa:	4785                	li	a5,1
    800024fc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024fe:	0000c517          	auipc	a0,0xc
    80002502:	60a50513          	addi	a0,a0,1546 # 8000eb08 <bcache>
    80002506:	00004097          	auipc	ra,0x4
    8000250a:	e5a080e7          	jalr	-422(ra) # 80006360 <release>
      acquiresleep(&b->lock);
    8000250e:	01048513          	addi	a0,s1,16
    80002512:	00001097          	auipc	ra,0x1
    80002516:	410080e7          	jalr	1040(ra) # 80003922 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000251a:	409c                	lw	a5,0(s1)
    8000251c:	cb89                	beqz	a5,8000252e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000251e:	8526                	mv	a0,s1
    80002520:	70a2                	ld	ra,40(sp)
    80002522:	7402                	ld	s0,32(sp)
    80002524:	64e2                	ld	s1,24(sp)
    80002526:	6942                	ld	s2,16(sp)
    80002528:	69a2                	ld	s3,8(sp)
    8000252a:	6145                	addi	sp,sp,48
    8000252c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000252e:	4581                	li	a1,0
    80002530:	8526                	mv	a0,s1
    80002532:	00003097          	auipc	ra,0x3
    80002536:	fc6080e7          	jalr	-58(ra) # 800054f8 <virtio_disk_rw>
    b->valid = 1;
    8000253a:	4785                	li	a5,1
    8000253c:	c09c                	sw	a5,0(s1)
  return b;
    8000253e:	b7c5                	j	8000251e <bread+0xd0>

0000000080002540 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002540:	1101                	addi	sp,sp,-32
    80002542:	ec06                	sd	ra,24(sp)
    80002544:	e822                	sd	s0,16(sp)
    80002546:	e426                	sd	s1,8(sp)
    80002548:	1000                	addi	s0,sp,32
    8000254a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000254c:	0541                	addi	a0,a0,16
    8000254e:	00001097          	auipc	ra,0x1
    80002552:	46e080e7          	jalr	1134(ra) # 800039bc <holdingsleep>
    80002556:	cd01                	beqz	a0,8000256e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002558:	4585                	li	a1,1
    8000255a:	8526                	mv	a0,s1
    8000255c:	00003097          	auipc	ra,0x3
    80002560:	f9c080e7          	jalr	-100(ra) # 800054f8 <virtio_disk_rw>
}
    80002564:	60e2                	ld	ra,24(sp)
    80002566:	6442                	ld	s0,16(sp)
    80002568:	64a2                	ld	s1,8(sp)
    8000256a:	6105                	addi	sp,sp,32
    8000256c:	8082                	ret
    panic("bwrite");
    8000256e:	00006517          	auipc	a0,0x6
    80002572:	05250513          	addi	a0,a0,82 # 800085c0 <syscalls+0xe8>
    80002576:	00003097          	auipc	ra,0x3
    8000257a:	7ec080e7          	jalr	2028(ra) # 80005d62 <panic>

000000008000257e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000257e:	1101                	addi	sp,sp,-32
    80002580:	ec06                	sd	ra,24(sp)
    80002582:	e822                	sd	s0,16(sp)
    80002584:	e426                	sd	s1,8(sp)
    80002586:	e04a                	sd	s2,0(sp)
    80002588:	1000                	addi	s0,sp,32
    8000258a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000258c:	01050913          	addi	s2,a0,16
    80002590:	854a                	mv	a0,s2
    80002592:	00001097          	auipc	ra,0x1
    80002596:	42a080e7          	jalr	1066(ra) # 800039bc <holdingsleep>
    8000259a:	c92d                	beqz	a0,8000260c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000259c:	854a                	mv	a0,s2
    8000259e:	00001097          	auipc	ra,0x1
    800025a2:	3da080e7          	jalr	986(ra) # 80003978 <releasesleep>

  acquire(&bcache.lock);
    800025a6:	0000c517          	auipc	a0,0xc
    800025aa:	56250513          	addi	a0,a0,1378 # 8000eb08 <bcache>
    800025ae:	00004097          	auipc	ra,0x4
    800025b2:	cfe080e7          	jalr	-770(ra) # 800062ac <acquire>
  b->refcnt--;
    800025b6:	40bc                	lw	a5,64(s1)
    800025b8:	37fd                	addiw	a5,a5,-1
    800025ba:	0007871b          	sext.w	a4,a5
    800025be:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025c0:	eb05                	bnez	a4,800025f0 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025c2:	68bc                	ld	a5,80(s1)
    800025c4:	64b8                	ld	a4,72(s1)
    800025c6:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025c8:	64bc                	ld	a5,72(s1)
    800025ca:	68b8                	ld	a4,80(s1)
    800025cc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025ce:	00014797          	auipc	a5,0x14
    800025d2:	53a78793          	addi	a5,a5,1338 # 80016b08 <bcache+0x8000>
    800025d6:	2b87b703          	ld	a4,696(a5)
    800025da:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025dc:	00014717          	auipc	a4,0x14
    800025e0:	79470713          	addi	a4,a4,1940 # 80016d70 <bcache+0x8268>
    800025e4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025e6:	2b87b703          	ld	a4,696(a5)
    800025ea:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025ec:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025f0:	0000c517          	auipc	a0,0xc
    800025f4:	51850513          	addi	a0,a0,1304 # 8000eb08 <bcache>
    800025f8:	00004097          	auipc	ra,0x4
    800025fc:	d68080e7          	jalr	-664(ra) # 80006360 <release>
}
    80002600:	60e2                	ld	ra,24(sp)
    80002602:	6442                	ld	s0,16(sp)
    80002604:	64a2                	ld	s1,8(sp)
    80002606:	6902                	ld	s2,0(sp)
    80002608:	6105                	addi	sp,sp,32
    8000260a:	8082                	ret
    panic("brelse");
    8000260c:	00006517          	auipc	a0,0x6
    80002610:	fbc50513          	addi	a0,a0,-68 # 800085c8 <syscalls+0xf0>
    80002614:	00003097          	auipc	ra,0x3
    80002618:	74e080e7          	jalr	1870(ra) # 80005d62 <panic>

000000008000261c <bpin>:

void
bpin(struct buf *b) {
    8000261c:	1101                	addi	sp,sp,-32
    8000261e:	ec06                	sd	ra,24(sp)
    80002620:	e822                	sd	s0,16(sp)
    80002622:	e426                	sd	s1,8(sp)
    80002624:	1000                	addi	s0,sp,32
    80002626:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002628:	0000c517          	auipc	a0,0xc
    8000262c:	4e050513          	addi	a0,a0,1248 # 8000eb08 <bcache>
    80002630:	00004097          	auipc	ra,0x4
    80002634:	c7c080e7          	jalr	-900(ra) # 800062ac <acquire>
  b->refcnt++;
    80002638:	40bc                	lw	a5,64(s1)
    8000263a:	2785                	addiw	a5,a5,1
    8000263c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000263e:	0000c517          	auipc	a0,0xc
    80002642:	4ca50513          	addi	a0,a0,1226 # 8000eb08 <bcache>
    80002646:	00004097          	auipc	ra,0x4
    8000264a:	d1a080e7          	jalr	-742(ra) # 80006360 <release>
}
    8000264e:	60e2                	ld	ra,24(sp)
    80002650:	6442                	ld	s0,16(sp)
    80002652:	64a2                	ld	s1,8(sp)
    80002654:	6105                	addi	sp,sp,32
    80002656:	8082                	ret

0000000080002658 <bunpin>:

void
bunpin(struct buf *b) {
    80002658:	1101                	addi	sp,sp,-32
    8000265a:	ec06                	sd	ra,24(sp)
    8000265c:	e822                	sd	s0,16(sp)
    8000265e:	e426                	sd	s1,8(sp)
    80002660:	1000                	addi	s0,sp,32
    80002662:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002664:	0000c517          	auipc	a0,0xc
    80002668:	4a450513          	addi	a0,a0,1188 # 8000eb08 <bcache>
    8000266c:	00004097          	auipc	ra,0x4
    80002670:	c40080e7          	jalr	-960(ra) # 800062ac <acquire>
  b->refcnt--;
    80002674:	40bc                	lw	a5,64(s1)
    80002676:	37fd                	addiw	a5,a5,-1
    80002678:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000267a:	0000c517          	auipc	a0,0xc
    8000267e:	48e50513          	addi	a0,a0,1166 # 8000eb08 <bcache>
    80002682:	00004097          	auipc	ra,0x4
    80002686:	cde080e7          	jalr	-802(ra) # 80006360 <release>
}
    8000268a:	60e2                	ld	ra,24(sp)
    8000268c:	6442                	ld	s0,16(sp)
    8000268e:	64a2                	ld	s1,8(sp)
    80002690:	6105                	addi	sp,sp,32
    80002692:	8082                	ret

0000000080002694 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002694:	1101                	addi	sp,sp,-32
    80002696:	ec06                	sd	ra,24(sp)
    80002698:	e822                	sd	s0,16(sp)
    8000269a:	e426                	sd	s1,8(sp)
    8000269c:	e04a                	sd	s2,0(sp)
    8000269e:	1000                	addi	s0,sp,32
    800026a0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026a2:	00d5d59b          	srliw	a1,a1,0xd
    800026a6:	00015797          	auipc	a5,0x15
    800026aa:	b3e7a783          	lw	a5,-1218(a5) # 800171e4 <sb+0x1c>
    800026ae:	9dbd                	addw	a1,a1,a5
    800026b0:	00000097          	auipc	ra,0x0
    800026b4:	d9e080e7          	jalr	-610(ra) # 8000244e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026b8:	0074f713          	andi	a4,s1,7
    800026bc:	4785                	li	a5,1
    800026be:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026c2:	14ce                	slli	s1,s1,0x33
    800026c4:	90d9                	srli	s1,s1,0x36
    800026c6:	00950733          	add	a4,a0,s1
    800026ca:	05874703          	lbu	a4,88(a4)
    800026ce:	00e7f6b3          	and	a3,a5,a4
    800026d2:	c69d                	beqz	a3,80002700 <bfree+0x6c>
    800026d4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026d6:	94aa                	add	s1,s1,a0
    800026d8:	fff7c793          	not	a5,a5
    800026dc:	8ff9                	and	a5,a5,a4
    800026de:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800026e2:	00001097          	auipc	ra,0x1
    800026e6:	120080e7          	jalr	288(ra) # 80003802 <log_write>
  brelse(bp);
    800026ea:	854a                	mv	a0,s2
    800026ec:	00000097          	auipc	ra,0x0
    800026f0:	e92080e7          	jalr	-366(ra) # 8000257e <brelse>
}
    800026f4:	60e2                	ld	ra,24(sp)
    800026f6:	6442                	ld	s0,16(sp)
    800026f8:	64a2                	ld	s1,8(sp)
    800026fa:	6902                	ld	s2,0(sp)
    800026fc:	6105                	addi	sp,sp,32
    800026fe:	8082                	ret
    panic("freeing free block");
    80002700:	00006517          	auipc	a0,0x6
    80002704:	ed050513          	addi	a0,a0,-304 # 800085d0 <syscalls+0xf8>
    80002708:	00003097          	auipc	ra,0x3
    8000270c:	65a080e7          	jalr	1626(ra) # 80005d62 <panic>

0000000080002710 <balloc>:
{
    80002710:	711d                	addi	sp,sp,-96
    80002712:	ec86                	sd	ra,88(sp)
    80002714:	e8a2                	sd	s0,80(sp)
    80002716:	e4a6                	sd	s1,72(sp)
    80002718:	e0ca                	sd	s2,64(sp)
    8000271a:	fc4e                	sd	s3,56(sp)
    8000271c:	f852                	sd	s4,48(sp)
    8000271e:	f456                	sd	s5,40(sp)
    80002720:	f05a                	sd	s6,32(sp)
    80002722:	ec5e                	sd	s7,24(sp)
    80002724:	e862                	sd	s8,16(sp)
    80002726:	e466                	sd	s9,8(sp)
    80002728:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000272a:	00015797          	auipc	a5,0x15
    8000272e:	aa27a783          	lw	a5,-1374(a5) # 800171cc <sb+0x4>
    80002732:	10078163          	beqz	a5,80002834 <balloc+0x124>
    80002736:	8baa                	mv	s7,a0
    80002738:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000273a:	00015b17          	auipc	s6,0x15
    8000273e:	a8eb0b13          	addi	s6,s6,-1394 # 800171c8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002742:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002744:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002746:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002748:	6c89                	lui	s9,0x2
    8000274a:	a061                	j	800027d2 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000274c:	974a                	add	a4,a4,s2
    8000274e:	8fd5                	or	a5,a5,a3
    80002750:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002754:	854a                	mv	a0,s2
    80002756:	00001097          	auipc	ra,0x1
    8000275a:	0ac080e7          	jalr	172(ra) # 80003802 <log_write>
        brelse(bp);
    8000275e:	854a                	mv	a0,s2
    80002760:	00000097          	auipc	ra,0x0
    80002764:	e1e080e7          	jalr	-482(ra) # 8000257e <brelse>
  bp = bread(dev, bno);
    80002768:	85a6                	mv	a1,s1
    8000276a:	855e                	mv	a0,s7
    8000276c:	00000097          	auipc	ra,0x0
    80002770:	ce2080e7          	jalr	-798(ra) # 8000244e <bread>
    80002774:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002776:	40000613          	li	a2,1024
    8000277a:	4581                	li	a1,0
    8000277c:	05850513          	addi	a0,a0,88
    80002780:	ffffe097          	auipc	ra,0xffffe
    80002784:	a1e080e7          	jalr	-1506(ra) # 8000019e <memset>
  log_write(bp);
    80002788:	854a                	mv	a0,s2
    8000278a:	00001097          	auipc	ra,0x1
    8000278e:	078080e7          	jalr	120(ra) # 80003802 <log_write>
  brelse(bp);
    80002792:	854a                	mv	a0,s2
    80002794:	00000097          	auipc	ra,0x0
    80002798:	dea080e7          	jalr	-534(ra) # 8000257e <brelse>
}
    8000279c:	8526                	mv	a0,s1
    8000279e:	60e6                	ld	ra,88(sp)
    800027a0:	6446                	ld	s0,80(sp)
    800027a2:	64a6                	ld	s1,72(sp)
    800027a4:	6906                	ld	s2,64(sp)
    800027a6:	79e2                	ld	s3,56(sp)
    800027a8:	7a42                	ld	s4,48(sp)
    800027aa:	7aa2                	ld	s5,40(sp)
    800027ac:	7b02                	ld	s6,32(sp)
    800027ae:	6be2                	ld	s7,24(sp)
    800027b0:	6c42                	ld	s8,16(sp)
    800027b2:	6ca2                	ld	s9,8(sp)
    800027b4:	6125                	addi	sp,sp,96
    800027b6:	8082                	ret
    brelse(bp);
    800027b8:	854a                	mv	a0,s2
    800027ba:	00000097          	auipc	ra,0x0
    800027be:	dc4080e7          	jalr	-572(ra) # 8000257e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027c2:	015c87bb          	addw	a5,s9,s5
    800027c6:	00078a9b          	sext.w	s5,a5
    800027ca:	004b2703          	lw	a4,4(s6)
    800027ce:	06eaf363          	bgeu	s5,a4,80002834 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800027d2:	41fad79b          	sraiw	a5,s5,0x1f
    800027d6:	0137d79b          	srliw	a5,a5,0x13
    800027da:	015787bb          	addw	a5,a5,s5
    800027de:	40d7d79b          	sraiw	a5,a5,0xd
    800027e2:	01cb2583          	lw	a1,28(s6)
    800027e6:	9dbd                	addw	a1,a1,a5
    800027e8:	855e                	mv	a0,s7
    800027ea:	00000097          	auipc	ra,0x0
    800027ee:	c64080e7          	jalr	-924(ra) # 8000244e <bread>
    800027f2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027f4:	004b2503          	lw	a0,4(s6)
    800027f8:	000a849b          	sext.w	s1,s5
    800027fc:	8662                	mv	a2,s8
    800027fe:	faa4fde3          	bgeu	s1,a0,800027b8 <balloc+0xa8>
      m = 1 << (bi % 8);
    80002802:	41f6579b          	sraiw	a5,a2,0x1f
    80002806:	01d7d69b          	srliw	a3,a5,0x1d
    8000280a:	00c6873b          	addw	a4,a3,a2
    8000280e:	00777793          	andi	a5,a4,7
    80002812:	9f95                	subw	a5,a5,a3
    80002814:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002818:	4037571b          	sraiw	a4,a4,0x3
    8000281c:	00e906b3          	add	a3,s2,a4
    80002820:	0586c683          	lbu	a3,88(a3)
    80002824:	00d7f5b3          	and	a1,a5,a3
    80002828:	d195                	beqz	a1,8000274c <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000282a:	2605                	addiw	a2,a2,1
    8000282c:	2485                	addiw	s1,s1,1
    8000282e:	fd4618e3          	bne	a2,s4,800027fe <balloc+0xee>
    80002832:	b759                	j	800027b8 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002834:	00006517          	auipc	a0,0x6
    80002838:	db450513          	addi	a0,a0,-588 # 800085e8 <syscalls+0x110>
    8000283c:	00003097          	auipc	ra,0x3
    80002840:	570080e7          	jalr	1392(ra) # 80005dac <printf>
  return 0;
    80002844:	4481                	li	s1,0
    80002846:	bf99                	j	8000279c <balloc+0x8c>

0000000080002848 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002848:	7179                	addi	sp,sp,-48
    8000284a:	f406                	sd	ra,40(sp)
    8000284c:	f022                	sd	s0,32(sp)
    8000284e:	ec26                	sd	s1,24(sp)
    80002850:	e84a                	sd	s2,16(sp)
    80002852:	e44e                	sd	s3,8(sp)
    80002854:	e052                	sd	s4,0(sp)
    80002856:	1800                	addi	s0,sp,48
    80002858:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000285a:	47ad                	li	a5,11
    8000285c:	02b7e763          	bltu	a5,a1,8000288a <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002860:	02059493          	slli	s1,a1,0x20
    80002864:	9081                	srli	s1,s1,0x20
    80002866:	048a                	slli	s1,s1,0x2
    80002868:	94aa                	add	s1,s1,a0
    8000286a:	0504a903          	lw	s2,80(s1)
    8000286e:	06091e63          	bnez	s2,800028ea <bmap+0xa2>
      addr = balloc(ip->dev);
    80002872:	4108                	lw	a0,0(a0)
    80002874:	00000097          	auipc	ra,0x0
    80002878:	e9c080e7          	jalr	-356(ra) # 80002710 <balloc>
    8000287c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002880:	06090563          	beqz	s2,800028ea <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002884:	0524a823          	sw	s2,80(s1)
    80002888:	a08d                	j	800028ea <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000288a:	ff45849b          	addiw	s1,a1,-12
    8000288e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002892:	0ff00793          	li	a5,255
    80002896:	08e7e563          	bltu	a5,a4,80002920 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000289a:	08052903          	lw	s2,128(a0)
    8000289e:	00091d63          	bnez	s2,800028b8 <bmap+0x70>
      addr = balloc(ip->dev);
    800028a2:	4108                	lw	a0,0(a0)
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	e6c080e7          	jalr	-404(ra) # 80002710 <balloc>
    800028ac:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028b0:	02090d63          	beqz	s2,800028ea <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800028b4:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800028b8:	85ca                	mv	a1,s2
    800028ba:	0009a503          	lw	a0,0(s3)
    800028be:	00000097          	auipc	ra,0x0
    800028c2:	b90080e7          	jalr	-1136(ra) # 8000244e <bread>
    800028c6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028c8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028cc:	02049593          	slli	a1,s1,0x20
    800028d0:	9181                	srli	a1,a1,0x20
    800028d2:	058a                	slli	a1,a1,0x2
    800028d4:	00b784b3          	add	s1,a5,a1
    800028d8:	0004a903          	lw	s2,0(s1)
    800028dc:	02090063          	beqz	s2,800028fc <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028e0:	8552                	mv	a0,s4
    800028e2:	00000097          	auipc	ra,0x0
    800028e6:	c9c080e7          	jalr	-868(ra) # 8000257e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028ea:	854a                	mv	a0,s2
    800028ec:	70a2                	ld	ra,40(sp)
    800028ee:	7402                	ld	s0,32(sp)
    800028f0:	64e2                	ld	s1,24(sp)
    800028f2:	6942                	ld	s2,16(sp)
    800028f4:	69a2                	ld	s3,8(sp)
    800028f6:	6a02                	ld	s4,0(sp)
    800028f8:	6145                	addi	sp,sp,48
    800028fa:	8082                	ret
      addr = balloc(ip->dev);
    800028fc:	0009a503          	lw	a0,0(s3)
    80002900:	00000097          	auipc	ra,0x0
    80002904:	e10080e7          	jalr	-496(ra) # 80002710 <balloc>
    80002908:	0005091b          	sext.w	s2,a0
      if(addr){
    8000290c:	fc090ae3          	beqz	s2,800028e0 <bmap+0x98>
        a[bn] = addr;
    80002910:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002914:	8552                	mv	a0,s4
    80002916:	00001097          	auipc	ra,0x1
    8000291a:	eec080e7          	jalr	-276(ra) # 80003802 <log_write>
    8000291e:	b7c9                	j	800028e0 <bmap+0x98>
  panic("bmap: out of range");
    80002920:	00006517          	auipc	a0,0x6
    80002924:	ce050513          	addi	a0,a0,-800 # 80008600 <syscalls+0x128>
    80002928:	00003097          	auipc	ra,0x3
    8000292c:	43a080e7          	jalr	1082(ra) # 80005d62 <panic>

0000000080002930 <iget>:
{
    80002930:	7179                	addi	sp,sp,-48
    80002932:	f406                	sd	ra,40(sp)
    80002934:	f022                	sd	s0,32(sp)
    80002936:	ec26                	sd	s1,24(sp)
    80002938:	e84a                	sd	s2,16(sp)
    8000293a:	e44e                	sd	s3,8(sp)
    8000293c:	e052                	sd	s4,0(sp)
    8000293e:	1800                	addi	s0,sp,48
    80002940:	89aa                	mv	s3,a0
    80002942:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002944:	00015517          	auipc	a0,0x15
    80002948:	8a450513          	addi	a0,a0,-1884 # 800171e8 <itable>
    8000294c:	00004097          	auipc	ra,0x4
    80002950:	960080e7          	jalr	-1696(ra) # 800062ac <acquire>
  empty = 0;
    80002954:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002956:	00015497          	auipc	s1,0x15
    8000295a:	8aa48493          	addi	s1,s1,-1878 # 80017200 <itable+0x18>
    8000295e:	00016697          	auipc	a3,0x16
    80002962:	33268693          	addi	a3,a3,818 # 80018c90 <log>
    80002966:	a039                	j	80002974 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002968:	02090b63          	beqz	s2,8000299e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000296c:	08848493          	addi	s1,s1,136
    80002970:	02d48a63          	beq	s1,a3,800029a4 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002974:	449c                	lw	a5,8(s1)
    80002976:	fef059e3          	blez	a5,80002968 <iget+0x38>
    8000297a:	4098                	lw	a4,0(s1)
    8000297c:	ff3716e3          	bne	a4,s3,80002968 <iget+0x38>
    80002980:	40d8                	lw	a4,4(s1)
    80002982:	ff4713e3          	bne	a4,s4,80002968 <iget+0x38>
      ip->ref++;
    80002986:	2785                	addiw	a5,a5,1
    80002988:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000298a:	00015517          	auipc	a0,0x15
    8000298e:	85e50513          	addi	a0,a0,-1954 # 800171e8 <itable>
    80002992:	00004097          	auipc	ra,0x4
    80002996:	9ce080e7          	jalr	-1586(ra) # 80006360 <release>
      return ip;
    8000299a:	8926                	mv	s2,s1
    8000299c:	a03d                	j	800029ca <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000299e:	f7f9                	bnez	a5,8000296c <iget+0x3c>
    800029a0:	8926                	mv	s2,s1
    800029a2:	b7e9                	j	8000296c <iget+0x3c>
  if(empty == 0)
    800029a4:	02090c63          	beqz	s2,800029dc <iget+0xac>
  ip->dev = dev;
    800029a8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029ac:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029b0:	4785                	li	a5,1
    800029b2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029b6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029ba:	00015517          	auipc	a0,0x15
    800029be:	82e50513          	addi	a0,a0,-2002 # 800171e8 <itable>
    800029c2:	00004097          	auipc	ra,0x4
    800029c6:	99e080e7          	jalr	-1634(ra) # 80006360 <release>
}
    800029ca:	854a                	mv	a0,s2
    800029cc:	70a2                	ld	ra,40(sp)
    800029ce:	7402                	ld	s0,32(sp)
    800029d0:	64e2                	ld	s1,24(sp)
    800029d2:	6942                	ld	s2,16(sp)
    800029d4:	69a2                	ld	s3,8(sp)
    800029d6:	6a02                	ld	s4,0(sp)
    800029d8:	6145                	addi	sp,sp,48
    800029da:	8082                	ret
    panic("iget: no inodes");
    800029dc:	00006517          	auipc	a0,0x6
    800029e0:	c3c50513          	addi	a0,a0,-964 # 80008618 <syscalls+0x140>
    800029e4:	00003097          	auipc	ra,0x3
    800029e8:	37e080e7          	jalr	894(ra) # 80005d62 <panic>

00000000800029ec <fsinit>:
fsinit(int dev) {
    800029ec:	7179                	addi	sp,sp,-48
    800029ee:	f406                	sd	ra,40(sp)
    800029f0:	f022                	sd	s0,32(sp)
    800029f2:	ec26                	sd	s1,24(sp)
    800029f4:	e84a                	sd	s2,16(sp)
    800029f6:	e44e                	sd	s3,8(sp)
    800029f8:	1800                	addi	s0,sp,48
    800029fa:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029fc:	4585                	li	a1,1
    800029fe:	00000097          	auipc	ra,0x0
    80002a02:	a50080e7          	jalr	-1456(ra) # 8000244e <bread>
    80002a06:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a08:	00014997          	auipc	s3,0x14
    80002a0c:	7c098993          	addi	s3,s3,1984 # 800171c8 <sb>
    80002a10:	02000613          	li	a2,32
    80002a14:	05850593          	addi	a1,a0,88
    80002a18:	854e                	mv	a0,s3
    80002a1a:	ffffd097          	auipc	ra,0xffffd
    80002a1e:	7e4080e7          	jalr	2020(ra) # 800001fe <memmove>
  brelse(bp);
    80002a22:	8526                	mv	a0,s1
    80002a24:	00000097          	auipc	ra,0x0
    80002a28:	b5a080e7          	jalr	-1190(ra) # 8000257e <brelse>
  if(sb.magic != FSMAGIC)
    80002a2c:	0009a703          	lw	a4,0(s3)
    80002a30:	102037b7          	lui	a5,0x10203
    80002a34:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a38:	02f71263          	bne	a4,a5,80002a5c <fsinit+0x70>
  initlog(dev, &sb);
    80002a3c:	00014597          	auipc	a1,0x14
    80002a40:	78c58593          	addi	a1,a1,1932 # 800171c8 <sb>
    80002a44:	854a                	mv	a0,s2
    80002a46:	00001097          	auipc	ra,0x1
    80002a4a:	b40080e7          	jalr	-1216(ra) # 80003586 <initlog>
}
    80002a4e:	70a2                	ld	ra,40(sp)
    80002a50:	7402                	ld	s0,32(sp)
    80002a52:	64e2                	ld	s1,24(sp)
    80002a54:	6942                	ld	s2,16(sp)
    80002a56:	69a2                	ld	s3,8(sp)
    80002a58:	6145                	addi	sp,sp,48
    80002a5a:	8082                	ret
    panic("invalid file system");
    80002a5c:	00006517          	auipc	a0,0x6
    80002a60:	bcc50513          	addi	a0,a0,-1076 # 80008628 <syscalls+0x150>
    80002a64:	00003097          	auipc	ra,0x3
    80002a68:	2fe080e7          	jalr	766(ra) # 80005d62 <panic>

0000000080002a6c <iinit>:
{
    80002a6c:	7179                	addi	sp,sp,-48
    80002a6e:	f406                	sd	ra,40(sp)
    80002a70:	f022                	sd	s0,32(sp)
    80002a72:	ec26                	sd	s1,24(sp)
    80002a74:	e84a                	sd	s2,16(sp)
    80002a76:	e44e                	sd	s3,8(sp)
    80002a78:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a7a:	00006597          	auipc	a1,0x6
    80002a7e:	bc658593          	addi	a1,a1,-1082 # 80008640 <syscalls+0x168>
    80002a82:	00014517          	auipc	a0,0x14
    80002a86:	76650513          	addi	a0,a0,1894 # 800171e8 <itable>
    80002a8a:	00003097          	auipc	ra,0x3
    80002a8e:	792080e7          	jalr	1938(ra) # 8000621c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a92:	00014497          	auipc	s1,0x14
    80002a96:	77e48493          	addi	s1,s1,1918 # 80017210 <itable+0x28>
    80002a9a:	00016997          	auipc	s3,0x16
    80002a9e:	20698993          	addi	s3,s3,518 # 80018ca0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002aa2:	00006917          	auipc	s2,0x6
    80002aa6:	ba690913          	addi	s2,s2,-1114 # 80008648 <syscalls+0x170>
    80002aaa:	85ca                	mv	a1,s2
    80002aac:	8526                	mv	a0,s1
    80002aae:	00001097          	auipc	ra,0x1
    80002ab2:	e3a080e7          	jalr	-454(ra) # 800038e8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ab6:	08848493          	addi	s1,s1,136
    80002aba:	ff3498e3          	bne	s1,s3,80002aaa <iinit+0x3e>
}
    80002abe:	70a2                	ld	ra,40(sp)
    80002ac0:	7402                	ld	s0,32(sp)
    80002ac2:	64e2                	ld	s1,24(sp)
    80002ac4:	6942                	ld	s2,16(sp)
    80002ac6:	69a2                	ld	s3,8(sp)
    80002ac8:	6145                	addi	sp,sp,48
    80002aca:	8082                	ret

0000000080002acc <ialloc>:
{
    80002acc:	715d                	addi	sp,sp,-80
    80002ace:	e486                	sd	ra,72(sp)
    80002ad0:	e0a2                	sd	s0,64(sp)
    80002ad2:	fc26                	sd	s1,56(sp)
    80002ad4:	f84a                	sd	s2,48(sp)
    80002ad6:	f44e                	sd	s3,40(sp)
    80002ad8:	f052                	sd	s4,32(sp)
    80002ada:	ec56                	sd	s5,24(sp)
    80002adc:	e85a                	sd	s6,16(sp)
    80002ade:	e45e                	sd	s7,8(sp)
    80002ae0:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ae2:	00014717          	auipc	a4,0x14
    80002ae6:	6f272703          	lw	a4,1778(a4) # 800171d4 <sb+0xc>
    80002aea:	4785                	li	a5,1
    80002aec:	04e7fa63          	bgeu	a5,a4,80002b40 <ialloc+0x74>
    80002af0:	8aaa                	mv	s5,a0
    80002af2:	8bae                	mv	s7,a1
    80002af4:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002af6:	00014a17          	auipc	s4,0x14
    80002afa:	6d2a0a13          	addi	s4,s4,1746 # 800171c8 <sb>
    80002afe:	00048b1b          	sext.w	s6,s1
    80002b02:	0044d593          	srli	a1,s1,0x4
    80002b06:	018a2783          	lw	a5,24(s4)
    80002b0a:	9dbd                	addw	a1,a1,a5
    80002b0c:	8556                	mv	a0,s5
    80002b0e:	00000097          	auipc	ra,0x0
    80002b12:	940080e7          	jalr	-1728(ra) # 8000244e <bread>
    80002b16:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b18:	05850993          	addi	s3,a0,88
    80002b1c:	00f4f793          	andi	a5,s1,15
    80002b20:	079a                	slli	a5,a5,0x6
    80002b22:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b24:	00099783          	lh	a5,0(s3)
    80002b28:	c3a1                	beqz	a5,80002b68 <ialloc+0x9c>
    brelse(bp);
    80002b2a:	00000097          	auipc	ra,0x0
    80002b2e:	a54080e7          	jalr	-1452(ra) # 8000257e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b32:	0485                	addi	s1,s1,1
    80002b34:	00ca2703          	lw	a4,12(s4)
    80002b38:	0004879b          	sext.w	a5,s1
    80002b3c:	fce7e1e3          	bltu	a5,a4,80002afe <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b40:	00006517          	auipc	a0,0x6
    80002b44:	b1050513          	addi	a0,a0,-1264 # 80008650 <syscalls+0x178>
    80002b48:	00003097          	auipc	ra,0x3
    80002b4c:	264080e7          	jalr	612(ra) # 80005dac <printf>
  return 0;
    80002b50:	4501                	li	a0,0
}
    80002b52:	60a6                	ld	ra,72(sp)
    80002b54:	6406                	ld	s0,64(sp)
    80002b56:	74e2                	ld	s1,56(sp)
    80002b58:	7942                	ld	s2,48(sp)
    80002b5a:	79a2                	ld	s3,40(sp)
    80002b5c:	7a02                	ld	s4,32(sp)
    80002b5e:	6ae2                	ld	s5,24(sp)
    80002b60:	6b42                	ld	s6,16(sp)
    80002b62:	6ba2                	ld	s7,8(sp)
    80002b64:	6161                	addi	sp,sp,80
    80002b66:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b68:	04000613          	li	a2,64
    80002b6c:	4581                	li	a1,0
    80002b6e:	854e                	mv	a0,s3
    80002b70:	ffffd097          	auipc	ra,0xffffd
    80002b74:	62e080e7          	jalr	1582(ra) # 8000019e <memset>
      dip->type = type;
    80002b78:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b7c:	854a                	mv	a0,s2
    80002b7e:	00001097          	auipc	ra,0x1
    80002b82:	c84080e7          	jalr	-892(ra) # 80003802 <log_write>
      brelse(bp);
    80002b86:	854a                	mv	a0,s2
    80002b88:	00000097          	auipc	ra,0x0
    80002b8c:	9f6080e7          	jalr	-1546(ra) # 8000257e <brelse>
      return iget(dev, inum);
    80002b90:	85da                	mv	a1,s6
    80002b92:	8556                	mv	a0,s5
    80002b94:	00000097          	auipc	ra,0x0
    80002b98:	d9c080e7          	jalr	-612(ra) # 80002930 <iget>
    80002b9c:	bf5d                	j	80002b52 <ialloc+0x86>

0000000080002b9e <iupdate>:
{
    80002b9e:	1101                	addi	sp,sp,-32
    80002ba0:	ec06                	sd	ra,24(sp)
    80002ba2:	e822                	sd	s0,16(sp)
    80002ba4:	e426                	sd	s1,8(sp)
    80002ba6:	e04a                	sd	s2,0(sp)
    80002ba8:	1000                	addi	s0,sp,32
    80002baa:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bac:	415c                	lw	a5,4(a0)
    80002bae:	0047d79b          	srliw	a5,a5,0x4
    80002bb2:	00014597          	auipc	a1,0x14
    80002bb6:	62e5a583          	lw	a1,1582(a1) # 800171e0 <sb+0x18>
    80002bba:	9dbd                	addw	a1,a1,a5
    80002bbc:	4108                	lw	a0,0(a0)
    80002bbe:	00000097          	auipc	ra,0x0
    80002bc2:	890080e7          	jalr	-1904(ra) # 8000244e <bread>
    80002bc6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bc8:	05850793          	addi	a5,a0,88
    80002bcc:	40c8                	lw	a0,4(s1)
    80002bce:	893d                	andi	a0,a0,15
    80002bd0:	051a                	slli	a0,a0,0x6
    80002bd2:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002bd4:	04449703          	lh	a4,68(s1)
    80002bd8:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002bdc:	04649703          	lh	a4,70(s1)
    80002be0:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002be4:	04849703          	lh	a4,72(s1)
    80002be8:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002bec:	04a49703          	lh	a4,74(s1)
    80002bf0:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002bf4:	44f8                	lw	a4,76(s1)
    80002bf6:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bf8:	03400613          	li	a2,52
    80002bfc:	05048593          	addi	a1,s1,80
    80002c00:	0531                	addi	a0,a0,12
    80002c02:	ffffd097          	auipc	ra,0xffffd
    80002c06:	5fc080e7          	jalr	1532(ra) # 800001fe <memmove>
  log_write(bp);
    80002c0a:	854a                	mv	a0,s2
    80002c0c:	00001097          	auipc	ra,0x1
    80002c10:	bf6080e7          	jalr	-1034(ra) # 80003802 <log_write>
  brelse(bp);
    80002c14:	854a                	mv	a0,s2
    80002c16:	00000097          	auipc	ra,0x0
    80002c1a:	968080e7          	jalr	-1688(ra) # 8000257e <brelse>
}
    80002c1e:	60e2                	ld	ra,24(sp)
    80002c20:	6442                	ld	s0,16(sp)
    80002c22:	64a2                	ld	s1,8(sp)
    80002c24:	6902                	ld	s2,0(sp)
    80002c26:	6105                	addi	sp,sp,32
    80002c28:	8082                	ret

0000000080002c2a <idup>:
{
    80002c2a:	1101                	addi	sp,sp,-32
    80002c2c:	ec06                	sd	ra,24(sp)
    80002c2e:	e822                	sd	s0,16(sp)
    80002c30:	e426                	sd	s1,8(sp)
    80002c32:	1000                	addi	s0,sp,32
    80002c34:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c36:	00014517          	auipc	a0,0x14
    80002c3a:	5b250513          	addi	a0,a0,1458 # 800171e8 <itable>
    80002c3e:	00003097          	auipc	ra,0x3
    80002c42:	66e080e7          	jalr	1646(ra) # 800062ac <acquire>
  ip->ref++;
    80002c46:	449c                	lw	a5,8(s1)
    80002c48:	2785                	addiw	a5,a5,1
    80002c4a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c4c:	00014517          	auipc	a0,0x14
    80002c50:	59c50513          	addi	a0,a0,1436 # 800171e8 <itable>
    80002c54:	00003097          	auipc	ra,0x3
    80002c58:	70c080e7          	jalr	1804(ra) # 80006360 <release>
}
    80002c5c:	8526                	mv	a0,s1
    80002c5e:	60e2                	ld	ra,24(sp)
    80002c60:	6442                	ld	s0,16(sp)
    80002c62:	64a2                	ld	s1,8(sp)
    80002c64:	6105                	addi	sp,sp,32
    80002c66:	8082                	ret

0000000080002c68 <ilock>:
{
    80002c68:	1101                	addi	sp,sp,-32
    80002c6a:	ec06                	sd	ra,24(sp)
    80002c6c:	e822                	sd	s0,16(sp)
    80002c6e:	e426                	sd	s1,8(sp)
    80002c70:	e04a                	sd	s2,0(sp)
    80002c72:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c74:	c115                	beqz	a0,80002c98 <ilock+0x30>
    80002c76:	84aa                	mv	s1,a0
    80002c78:	451c                	lw	a5,8(a0)
    80002c7a:	00f05f63          	blez	a5,80002c98 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c7e:	0541                	addi	a0,a0,16
    80002c80:	00001097          	auipc	ra,0x1
    80002c84:	ca2080e7          	jalr	-862(ra) # 80003922 <acquiresleep>
  if(ip->valid == 0){
    80002c88:	40bc                	lw	a5,64(s1)
    80002c8a:	cf99                	beqz	a5,80002ca8 <ilock+0x40>
}
    80002c8c:	60e2                	ld	ra,24(sp)
    80002c8e:	6442                	ld	s0,16(sp)
    80002c90:	64a2                	ld	s1,8(sp)
    80002c92:	6902                	ld	s2,0(sp)
    80002c94:	6105                	addi	sp,sp,32
    80002c96:	8082                	ret
    panic("ilock");
    80002c98:	00006517          	auipc	a0,0x6
    80002c9c:	9d050513          	addi	a0,a0,-1584 # 80008668 <syscalls+0x190>
    80002ca0:	00003097          	auipc	ra,0x3
    80002ca4:	0c2080e7          	jalr	194(ra) # 80005d62 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ca8:	40dc                	lw	a5,4(s1)
    80002caa:	0047d79b          	srliw	a5,a5,0x4
    80002cae:	00014597          	auipc	a1,0x14
    80002cb2:	5325a583          	lw	a1,1330(a1) # 800171e0 <sb+0x18>
    80002cb6:	9dbd                	addw	a1,a1,a5
    80002cb8:	4088                	lw	a0,0(s1)
    80002cba:	fffff097          	auipc	ra,0xfffff
    80002cbe:	794080e7          	jalr	1940(ra) # 8000244e <bread>
    80002cc2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cc4:	05850593          	addi	a1,a0,88
    80002cc8:	40dc                	lw	a5,4(s1)
    80002cca:	8bbd                	andi	a5,a5,15
    80002ccc:	079a                	slli	a5,a5,0x6
    80002cce:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cd0:	00059783          	lh	a5,0(a1)
    80002cd4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cd8:	00259783          	lh	a5,2(a1)
    80002cdc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ce0:	00459783          	lh	a5,4(a1)
    80002ce4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ce8:	00659783          	lh	a5,6(a1)
    80002cec:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cf0:	459c                	lw	a5,8(a1)
    80002cf2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cf4:	03400613          	li	a2,52
    80002cf8:	05b1                	addi	a1,a1,12
    80002cfa:	05048513          	addi	a0,s1,80
    80002cfe:	ffffd097          	auipc	ra,0xffffd
    80002d02:	500080e7          	jalr	1280(ra) # 800001fe <memmove>
    brelse(bp);
    80002d06:	854a                	mv	a0,s2
    80002d08:	00000097          	auipc	ra,0x0
    80002d0c:	876080e7          	jalr	-1930(ra) # 8000257e <brelse>
    ip->valid = 1;
    80002d10:	4785                	li	a5,1
    80002d12:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d14:	04449783          	lh	a5,68(s1)
    80002d18:	fbb5                	bnez	a5,80002c8c <ilock+0x24>
      panic("ilock: no type");
    80002d1a:	00006517          	auipc	a0,0x6
    80002d1e:	95650513          	addi	a0,a0,-1706 # 80008670 <syscalls+0x198>
    80002d22:	00003097          	auipc	ra,0x3
    80002d26:	040080e7          	jalr	64(ra) # 80005d62 <panic>

0000000080002d2a <iunlock>:
{
    80002d2a:	1101                	addi	sp,sp,-32
    80002d2c:	ec06                	sd	ra,24(sp)
    80002d2e:	e822                	sd	s0,16(sp)
    80002d30:	e426                	sd	s1,8(sp)
    80002d32:	e04a                	sd	s2,0(sp)
    80002d34:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d36:	c905                	beqz	a0,80002d66 <iunlock+0x3c>
    80002d38:	84aa                	mv	s1,a0
    80002d3a:	01050913          	addi	s2,a0,16
    80002d3e:	854a                	mv	a0,s2
    80002d40:	00001097          	auipc	ra,0x1
    80002d44:	c7c080e7          	jalr	-900(ra) # 800039bc <holdingsleep>
    80002d48:	cd19                	beqz	a0,80002d66 <iunlock+0x3c>
    80002d4a:	449c                	lw	a5,8(s1)
    80002d4c:	00f05d63          	blez	a5,80002d66 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d50:	854a                	mv	a0,s2
    80002d52:	00001097          	auipc	ra,0x1
    80002d56:	c26080e7          	jalr	-986(ra) # 80003978 <releasesleep>
}
    80002d5a:	60e2                	ld	ra,24(sp)
    80002d5c:	6442                	ld	s0,16(sp)
    80002d5e:	64a2                	ld	s1,8(sp)
    80002d60:	6902                	ld	s2,0(sp)
    80002d62:	6105                	addi	sp,sp,32
    80002d64:	8082                	ret
    panic("iunlock");
    80002d66:	00006517          	auipc	a0,0x6
    80002d6a:	91a50513          	addi	a0,a0,-1766 # 80008680 <syscalls+0x1a8>
    80002d6e:	00003097          	auipc	ra,0x3
    80002d72:	ff4080e7          	jalr	-12(ra) # 80005d62 <panic>

0000000080002d76 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d76:	7179                	addi	sp,sp,-48
    80002d78:	f406                	sd	ra,40(sp)
    80002d7a:	f022                	sd	s0,32(sp)
    80002d7c:	ec26                	sd	s1,24(sp)
    80002d7e:	e84a                	sd	s2,16(sp)
    80002d80:	e44e                	sd	s3,8(sp)
    80002d82:	e052                	sd	s4,0(sp)
    80002d84:	1800                	addi	s0,sp,48
    80002d86:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d88:	05050493          	addi	s1,a0,80
    80002d8c:	08050913          	addi	s2,a0,128
    80002d90:	a021                	j	80002d98 <itrunc+0x22>
    80002d92:	0491                	addi	s1,s1,4
    80002d94:	01248d63          	beq	s1,s2,80002dae <itrunc+0x38>
    if(ip->addrs[i]){
    80002d98:	408c                	lw	a1,0(s1)
    80002d9a:	dde5                	beqz	a1,80002d92 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d9c:	0009a503          	lw	a0,0(s3)
    80002da0:	00000097          	auipc	ra,0x0
    80002da4:	8f4080e7          	jalr	-1804(ra) # 80002694 <bfree>
      ip->addrs[i] = 0;
    80002da8:	0004a023          	sw	zero,0(s1)
    80002dac:	b7dd                	j	80002d92 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dae:	0809a583          	lw	a1,128(s3)
    80002db2:	e185                	bnez	a1,80002dd2 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002db4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002db8:	854e                	mv	a0,s3
    80002dba:	00000097          	auipc	ra,0x0
    80002dbe:	de4080e7          	jalr	-540(ra) # 80002b9e <iupdate>
}
    80002dc2:	70a2                	ld	ra,40(sp)
    80002dc4:	7402                	ld	s0,32(sp)
    80002dc6:	64e2                	ld	s1,24(sp)
    80002dc8:	6942                	ld	s2,16(sp)
    80002dca:	69a2                	ld	s3,8(sp)
    80002dcc:	6a02                	ld	s4,0(sp)
    80002dce:	6145                	addi	sp,sp,48
    80002dd0:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dd2:	0009a503          	lw	a0,0(s3)
    80002dd6:	fffff097          	auipc	ra,0xfffff
    80002dda:	678080e7          	jalr	1656(ra) # 8000244e <bread>
    80002dde:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002de0:	05850493          	addi	s1,a0,88
    80002de4:	45850913          	addi	s2,a0,1112
    80002de8:	a811                	j	80002dfc <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002dea:	0009a503          	lw	a0,0(s3)
    80002dee:	00000097          	auipc	ra,0x0
    80002df2:	8a6080e7          	jalr	-1882(ra) # 80002694 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002df6:	0491                	addi	s1,s1,4
    80002df8:	01248563          	beq	s1,s2,80002e02 <itrunc+0x8c>
      if(a[j])
    80002dfc:	408c                	lw	a1,0(s1)
    80002dfe:	dde5                	beqz	a1,80002df6 <itrunc+0x80>
    80002e00:	b7ed                	j	80002dea <itrunc+0x74>
    brelse(bp);
    80002e02:	8552                	mv	a0,s4
    80002e04:	fffff097          	auipc	ra,0xfffff
    80002e08:	77a080e7          	jalr	1914(ra) # 8000257e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e0c:	0809a583          	lw	a1,128(s3)
    80002e10:	0009a503          	lw	a0,0(s3)
    80002e14:	00000097          	auipc	ra,0x0
    80002e18:	880080e7          	jalr	-1920(ra) # 80002694 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e1c:	0809a023          	sw	zero,128(s3)
    80002e20:	bf51                	j	80002db4 <itrunc+0x3e>

0000000080002e22 <iput>:
{
    80002e22:	1101                	addi	sp,sp,-32
    80002e24:	ec06                	sd	ra,24(sp)
    80002e26:	e822                	sd	s0,16(sp)
    80002e28:	e426                	sd	s1,8(sp)
    80002e2a:	e04a                	sd	s2,0(sp)
    80002e2c:	1000                	addi	s0,sp,32
    80002e2e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e30:	00014517          	auipc	a0,0x14
    80002e34:	3b850513          	addi	a0,a0,952 # 800171e8 <itable>
    80002e38:	00003097          	auipc	ra,0x3
    80002e3c:	474080e7          	jalr	1140(ra) # 800062ac <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e40:	4498                	lw	a4,8(s1)
    80002e42:	4785                	li	a5,1
    80002e44:	02f70363          	beq	a4,a5,80002e6a <iput+0x48>
  ip->ref--;
    80002e48:	449c                	lw	a5,8(s1)
    80002e4a:	37fd                	addiw	a5,a5,-1
    80002e4c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e4e:	00014517          	auipc	a0,0x14
    80002e52:	39a50513          	addi	a0,a0,922 # 800171e8 <itable>
    80002e56:	00003097          	auipc	ra,0x3
    80002e5a:	50a080e7          	jalr	1290(ra) # 80006360 <release>
}
    80002e5e:	60e2                	ld	ra,24(sp)
    80002e60:	6442                	ld	s0,16(sp)
    80002e62:	64a2                	ld	s1,8(sp)
    80002e64:	6902                	ld	s2,0(sp)
    80002e66:	6105                	addi	sp,sp,32
    80002e68:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e6a:	40bc                	lw	a5,64(s1)
    80002e6c:	dff1                	beqz	a5,80002e48 <iput+0x26>
    80002e6e:	04a49783          	lh	a5,74(s1)
    80002e72:	fbf9                	bnez	a5,80002e48 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e74:	01048913          	addi	s2,s1,16
    80002e78:	854a                	mv	a0,s2
    80002e7a:	00001097          	auipc	ra,0x1
    80002e7e:	aa8080e7          	jalr	-1368(ra) # 80003922 <acquiresleep>
    release(&itable.lock);
    80002e82:	00014517          	auipc	a0,0x14
    80002e86:	36650513          	addi	a0,a0,870 # 800171e8 <itable>
    80002e8a:	00003097          	auipc	ra,0x3
    80002e8e:	4d6080e7          	jalr	1238(ra) # 80006360 <release>
    itrunc(ip);
    80002e92:	8526                	mv	a0,s1
    80002e94:	00000097          	auipc	ra,0x0
    80002e98:	ee2080e7          	jalr	-286(ra) # 80002d76 <itrunc>
    ip->type = 0;
    80002e9c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ea0:	8526                	mv	a0,s1
    80002ea2:	00000097          	auipc	ra,0x0
    80002ea6:	cfc080e7          	jalr	-772(ra) # 80002b9e <iupdate>
    ip->valid = 0;
    80002eaa:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002eae:	854a                	mv	a0,s2
    80002eb0:	00001097          	auipc	ra,0x1
    80002eb4:	ac8080e7          	jalr	-1336(ra) # 80003978 <releasesleep>
    acquire(&itable.lock);
    80002eb8:	00014517          	auipc	a0,0x14
    80002ebc:	33050513          	addi	a0,a0,816 # 800171e8 <itable>
    80002ec0:	00003097          	auipc	ra,0x3
    80002ec4:	3ec080e7          	jalr	1004(ra) # 800062ac <acquire>
    80002ec8:	b741                	j	80002e48 <iput+0x26>

0000000080002eca <iunlockput>:
{
    80002eca:	1101                	addi	sp,sp,-32
    80002ecc:	ec06                	sd	ra,24(sp)
    80002ece:	e822                	sd	s0,16(sp)
    80002ed0:	e426                	sd	s1,8(sp)
    80002ed2:	1000                	addi	s0,sp,32
    80002ed4:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ed6:	00000097          	auipc	ra,0x0
    80002eda:	e54080e7          	jalr	-428(ra) # 80002d2a <iunlock>
  iput(ip);
    80002ede:	8526                	mv	a0,s1
    80002ee0:	00000097          	auipc	ra,0x0
    80002ee4:	f42080e7          	jalr	-190(ra) # 80002e22 <iput>
}
    80002ee8:	60e2                	ld	ra,24(sp)
    80002eea:	6442                	ld	s0,16(sp)
    80002eec:	64a2                	ld	s1,8(sp)
    80002eee:	6105                	addi	sp,sp,32
    80002ef0:	8082                	ret

0000000080002ef2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ef2:	1141                	addi	sp,sp,-16
    80002ef4:	e422                	sd	s0,8(sp)
    80002ef6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ef8:	411c                	lw	a5,0(a0)
    80002efa:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002efc:	415c                	lw	a5,4(a0)
    80002efe:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f00:	04451783          	lh	a5,68(a0)
    80002f04:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f08:	04a51783          	lh	a5,74(a0)
    80002f0c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f10:	04c56783          	lwu	a5,76(a0)
    80002f14:	e99c                	sd	a5,16(a1)
}
    80002f16:	6422                	ld	s0,8(sp)
    80002f18:	0141                	addi	sp,sp,16
    80002f1a:	8082                	ret

0000000080002f1c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f1c:	457c                	lw	a5,76(a0)
    80002f1e:	0ed7e963          	bltu	a5,a3,80003010 <readi+0xf4>
{
    80002f22:	7159                	addi	sp,sp,-112
    80002f24:	f486                	sd	ra,104(sp)
    80002f26:	f0a2                	sd	s0,96(sp)
    80002f28:	eca6                	sd	s1,88(sp)
    80002f2a:	e8ca                	sd	s2,80(sp)
    80002f2c:	e4ce                	sd	s3,72(sp)
    80002f2e:	e0d2                	sd	s4,64(sp)
    80002f30:	fc56                	sd	s5,56(sp)
    80002f32:	f85a                	sd	s6,48(sp)
    80002f34:	f45e                	sd	s7,40(sp)
    80002f36:	f062                	sd	s8,32(sp)
    80002f38:	ec66                	sd	s9,24(sp)
    80002f3a:	e86a                	sd	s10,16(sp)
    80002f3c:	e46e                	sd	s11,8(sp)
    80002f3e:	1880                	addi	s0,sp,112
    80002f40:	8b2a                	mv	s6,a0
    80002f42:	8bae                	mv	s7,a1
    80002f44:	8a32                	mv	s4,a2
    80002f46:	84b6                	mv	s1,a3
    80002f48:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f4a:	9f35                	addw	a4,a4,a3
    return 0;
    80002f4c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f4e:	0ad76063          	bltu	a4,a3,80002fee <readi+0xd2>
  if(off + n > ip->size)
    80002f52:	00e7f463          	bgeu	a5,a4,80002f5a <readi+0x3e>
    n = ip->size - off;
    80002f56:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f5a:	0a0a8963          	beqz	s5,8000300c <readi+0xf0>
    80002f5e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f60:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f64:	5c7d                	li	s8,-1
    80002f66:	a82d                	j	80002fa0 <readi+0x84>
    80002f68:	020d1d93          	slli	s11,s10,0x20
    80002f6c:	020ddd93          	srli	s11,s11,0x20
    80002f70:	05890613          	addi	a2,s2,88
    80002f74:	86ee                	mv	a3,s11
    80002f76:	963a                	add	a2,a2,a4
    80002f78:	85d2                	mv	a1,s4
    80002f7a:	855e                	mv	a0,s7
    80002f7c:	fffff097          	auipc	ra,0xfffff
    80002f80:	a12080e7          	jalr	-1518(ra) # 8000198e <either_copyout>
    80002f84:	05850d63          	beq	a0,s8,80002fde <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f88:	854a                	mv	a0,s2
    80002f8a:	fffff097          	auipc	ra,0xfffff
    80002f8e:	5f4080e7          	jalr	1524(ra) # 8000257e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f92:	013d09bb          	addw	s3,s10,s3
    80002f96:	009d04bb          	addw	s1,s10,s1
    80002f9a:	9a6e                	add	s4,s4,s11
    80002f9c:	0559f763          	bgeu	s3,s5,80002fea <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002fa0:	00a4d59b          	srliw	a1,s1,0xa
    80002fa4:	855a                	mv	a0,s6
    80002fa6:	00000097          	auipc	ra,0x0
    80002faa:	8a2080e7          	jalr	-1886(ra) # 80002848 <bmap>
    80002fae:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fb2:	cd85                	beqz	a1,80002fea <readi+0xce>
    bp = bread(ip->dev, addr);
    80002fb4:	000b2503          	lw	a0,0(s6)
    80002fb8:	fffff097          	auipc	ra,0xfffff
    80002fbc:	496080e7          	jalr	1174(ra) # 8000244e <bread>
    80002fc0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fc2:	3ff4f713          	andi	a4,s1,1023
    80002fc6:	40ec87bb          	subw	a5,s9,a4
    80002fca:	413a86bb          	subw	a3,s5,s3
    80002fce:	8d3e                	mv	s10,a5
    80002fd0:	2781                	sext.w	a5,a5
    80002fd2:	0006861b          	sext.w	a2,a3
    80002fd6:	f8f679e3          	bgeu	a2,a5,80002f68 <readi+0x4c>
    80002fda:	8d36                	mv	s10,a3
    80002fdc:	b771                	j	80002f68 <readi+0x4c>
      brelse(bp);
    80002fde:	854a                	mv	a0,s2
    80002fe0:	fffff097          	auipc	ra,0xfffff
    80002fe4:	59e080e7          	jalr	1438(ra) # 8000257e <brelse>
      tot = -1;
    80002fe8:	59fd                	li	s3,-1
  }
  return tot;
    80002fea:	0009851b          	sext.w	a0,s3
}
    80002fee:	70a6                	ld	ra,104(sp)
    80002ff0:	7406                	ld	s0,96(sp)
    80002ff2:	64e6                	ld	s1,88(sp)
    80002ff4:	6946                	ld	s2,80(sp)
    80002ff6:	69a6                	ld	s3,72(sp)
    80002ff8:	6a06                	ld	s4,64(sp)
    80002ffa:	7ae2                	ld	s5,56(sp)
    80002ffc:	7b42                	ld	s6,48(sp)
    80002ffe:	7ba2                	ld	s7,40(sp)
    80003000:	7c02                	ld	s8,32(sp)
    80003002:	6ce2                	ld	s9,24(sp)
    80003004:	6d42                	ld	s10,16(sp)
    80003006:	6da2                	ld	s11,8(sp)
    80003008:	6165                	addi	sp,sp,112
    8000300a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000300c:	89d6                	mv	s3,s5
    8000300e:	bff1                	j	80002fea <readi+0xce>
    return 0;
    80003010:	4501                	li	a0,0
}
    80003012:	8082                	ret

0000000080003014 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003014:	457c                	lw	a5,76(a0)
    80003016:	10d7e863          	bltu	a5,a3,80003126 <writei+0x112>
{
    8000301a:	7159                	addi	sp,sp,-112
    8000301c:	f486                	sd	ra,104(sp)
    8000301e:	f0a2                	sd	s0,96(sp)
    80003020:	eca6                	sd	s1,88(sp)
    80003022:	e8ca                	sd	s2,80(sp)
    80003024:	e4ce                	sd	s3,72(sp)
    80003026:	e0d2                	sd	s4,64(sp)
    80003028:	fc56                	sd	s5,56(sp)
    8000302a:	f85a                	sd	s6,48(sp)
    8000302c:	f45e                	sd	s7,40(sp)
    8000302e:	f062                	sd	s8,32(sp)
    80003030:	ec66                	sd	s9,24(sp)
    80003032:	e86a                	sd	s10,16(sp)
    80003034:	e46e                	sd	s11,8(sp)
    80003036:	1880                	addi	s0,sp,112
    80003038:	8aaa                	mv	s5,a0
    8000303a:	8bae                	mv	s7,a1
    8000303c:	8a32                	mv	s4,a2
    8000303e:	8936                	mv	s2,a3
    80003040:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003042:	00e687bb          	addw	a5,a3,a4
    80003046:	0ed7e263          	bltu	a5,a3,8000312a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000304a:	00043737          	lui	a4,0x43
    8000304e:	0ef76063          	bltu	a4,a5,8000312e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003052:	0c0b0863          	beqz	s6,80003122 <writei+0x10e>
    80003056:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003058:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000305c:	5c7d                	li	s8,-1
    8000305e:	a091                	j	800030a2 <writei+0x8e>
    80003060:	020d1d93          	slli	s11,s10,0x20
    80003064:	020ddd93          	srli	s11,s11,0x20
    80003068:	05848513          	addi	a0,s1,88
    8000306c:	86ee                	mv	a3,s11
    8000306e:	8652                	mv	a2,s4
    80003070:	85de                	mv	a1,s7
    80003072:	953a                	add	a0,a0,a4
    80003074:	fffff097          	auipc	ra,0xfffff
    80003078:	970080e7          	jalr	-1680(ra) # 800019e4 <either_copyin>
    8000307c:	07850263          	beq	a0,s8,800030e0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003080:	8526                	mv	a0,s1
    80003082:	00000097          	auipc	ra,0x0
    80003086:	780080e7          	jalr	1920(ra) # 80003802 <log_write>
    brelse(bp);
    8000308a:	8526                	mv	a0,s1
    8000308c:	fffff097          	auipc	ra,0xfffff
    80003090:	4f2080e7          	jalr	1266(ra) # 8000257e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003094:	013d09bb          	addw	s3,s10,s3
    80003098:	012d093b          	addw	s2,s10,s2
    8000309c:	9a6e                	add	s4,s4,s11
    8000309e:	0569f663          	bgeu	s3,s6,800030ea <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030a2:	00a9559b          	srliw	a1,s2,0xa
    800030a6:	8556                	mv	a0,s5
    800030a8:	fffff097          	auipc	ra,0xfffff
    800030ac:	7a0080e7          	jalr	1952(ra) # 80002848 <bmap>
    800030b0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030b4:	c99d                	beqz	a1,800030ea <writei+0xd6>
    bp = bread(ip->dev, addr);
    800030b6:	000aa503          	lw	a0,0(s5)
    800030ba:	fffff097          	auipc	ra,0xfffff
    800030be:	394080e7          	jalr	916(ra) # 8000244e <bread>
    800030c2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030c4:	3ff97713          	andi	a4,s2,1023
    800030c8:	40ec87bb          	subw	a5,s9,a4
    800030cc:	413b06bb          	subw	a3,s6,s3
    800030d0:	8d3e                	mv	s10,a5
    800030d2:	2781                	sext.w	a5,a5
    800030d4:	0006861b          	sext.w	a2,a3
    800030d8:	f8f674e3          	bgeu	a2,a5,80003060 <writei+0x4c>
    800030dc:	8d36                	mv	s10,a3
    800030de:	b749                	j	80003060 <writei+0x4c>
      brelse(bp);
    800030e0:	8526                	mv	a0,s1
    800030e2:	fffff097          	auipc	ra,0xfffff
    800030e6:	49c080e7          	jalr	1180(ra) # 8000257e <brelse>
  }

  if(off > ip->size)
    800030ea:	04caa783          	lw	a5,76(s5)
    800030ee:	0127f463          	bgeu	a5,s2,800030f6 <writei+0xe2>
    ip->size = off;
    800030f2:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030f6:	8556                	mv	a0,s5
    800030f8:	00000097          	auipc	ra,0x0
    800030fc:	aa6080e7          	jalr	-1370(ra) # 80002b9e <iupdate>

  return tot;
    80003100:	0009851b          	sext.w	a0,s3
}
    80003104:	70a6                	ld	ra,104(sp)
    80003106:	7406                	ld	s0,96(sp)
    80003108:	64e6                	ld	s1,88(sp)
    8000310a:	6946                	ld	s2,80(sp)
    8000310c:	69a6                	ld	s3,72(sp)
    8000310e:	6a06                	ld	s4,64(sp)
    80003110:	7ae2                	ld	s5,56(sp)
    80003112:	7b42                	ld	s6,48(sp)
    80003114:	7ba2                	ld	s7,40(sp)
    80003116:	7c02                	ld	s8,32(sp)
    80003118:	6ce2                	ld	s9,24(sp)
    8000311a:	6d42                	ld	s10,16(sp)
    8000311c:	6da2                	ld	s11,8(sp)
    8000311e:	6165                	addi	sp,sp,112
    80003120:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003122:	89da                	mv	s3,s6
    80003124:	bfc9                	j	800030f6 <writei+0xe2>
    return -1;
    80003126:	557d                	li	a0,-1
}
    80003128:	8082                	ret
    return -1;
    8000312a:	557d                	li	a0,-1
    8000312c:	bfe1                	j	80003104 <writei+0xf0>
    return -1;
    8000312e:	557d                	li	a0,-1
    80003130:	bfd1                	j	80003104 <writei+0xf0>

0000000080003132 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003132:	1141                	addi	sp,sp,-16
    80003134:	e406                	sd	ra,8(sp)
    80003136:	e022                	sd	s0,0(sp)
    80003138:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000313a:	4639                	li	a2,14
    8000313c:	ffffd097          	auipc	ra,0xffffd
    80003140:	13a080e7          	jalr	314(ra) # 80000276 <strncmp>
}
    80003144:	60a2                	ld	ra,8(sp)
    80003146:	6402                	ld	s0,0(sp)
    80003148:	0141                	addi	sp,sp,16
    8000314a:	8082                	ret

000000008000314c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000314c:	7139                	addi	sp,sp,-64
    8000314e:	fc06                	sd	ra,56(sp)
    80003150:	f822                	sd	s0,48(sp)
    80003152:	f426                	sd	s1,40(sp)
    80003154:	f04a                	sd	s2,32(sp)
    80003156:	ec4e                	sd	s3,24(sp)
    80003158:	e852                	sd	s4,16(sp)
    8000315a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000315c:	04451703          	lh	a4,68(a0)
    80003160:	4785                	li	a5,1
    80003162:	00f71a63          	bne	a4,a5,80003176 <dirlookup+0x2a>
    80003166:	892a                	mv	s2,a0
    80003168:	89ae                	mv	s3,a1
    8000316a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000316c:	457c                	lw	a5,76(a0)
    8000316e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003170:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003172:	e79d                	bnez	a5,800031a0 <dirlookup+0x54>
    80003174:	a8a5                	j	800031ec <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003176:	00005517          	auipc	a0,0x5
    8000317a:	51250513          	addi	a0,a0,1298 # 80008688 <syscalls+0x1b0>
    8000317e:	00003097          	auipc	ra,0x3
    80003182:	be4080e7          	jalr	-1052(ra) # 80005d62 <panic>
      panic("dirlookup read");
    80003186:	00005517          	auipc	a0,0x5
    8000318a:	51a50513          	addi	a0,a0,1306 # 800086a0 <syscalls+0x1c8>
    8000318e:	00003097          	auipc	ra,0x3
    80003192:	bd4080e7          	jalr	-1068(ra) # 80005d62 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003196:	24c1                	addiw	s1,s1,16
    80003198:	04c92783          	lw	a5,76(s2)
    8000319c:	04f4f763          	bgeu	s1,a5,800031ea <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031a0:	4741                	li	a4,16
    800031a2:	86a6                	mv	a3,s1
    800031a4:	fc040613          	addi	a2,s0,-64
    800031a8:	4581                	li	a1,0
    800031aa:	854a                	mv	a0,s2
    800031ac:	00000097          	auipc	ra,0x0
    800031b0:	d70080e7          	jalr	-656(ra) # 80002f1c <readi>
    800031b4:	47c1                	li	a5,16
    800031b6:	fcf518e3          	bne	a0,a5,80003186 <dirlookup+0x3a>
    if(de.inum == 0)
    800031ba:	fc045783          	lhu	a5,-64(s0)
    800031be:	dfe1                	beqz	a5,80003196 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031c0:	fc240593          	addi	a1,s0,-62
    800031c4:	854e                	mv	a0,s3
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	f6c080e7          	jalr	-148(ra) # 80003132 <namecmp>
    800031ce:	f561                	bnez	a0,80003196 <dirlookup+0x4a>
      if(poff)
    800031d0:	000a0463          	beqz	s4,800031d8 <dirlookup+0x8c>
        *poff = off;
    800031d4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031d8:	fc045583          	lhu	a1,-64(s0)
    800031dc:	00092503          	lw	a0,0(s2)
    800031e0:	fffff097          	auipc	ra,0xfffff
    800031e4:	750080e7          	jalr	1872(ra) # 80002930 <iget>
    800031e8:	a011                	j	800031ec <dirlookup+0xa0>
  return 0;
    800031ea:	4501                	li	a0,0
}
    800031ec:	70e2                	ld	ra,56(sp)
    800031ee:	7442                	ld	s0,48(sp)
    800031f0:	74a2                	ld	s1,40(sp)
    800031f2:	7902                	ld	s2,32(sp)
    800031f4:	69e2                	ld	s3,24(sp)
    800031f6:	6a42                	ld	s4,16(sp)
    800031f8:	6121                	addi	sp,sp,64
    800031fa:	8082                	ret

00000000800031fc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031fc:	711d                	addi	sp,sp,-96
    800031fe:	ec86                	sd	ra,88(sp)
    80003200:	e8a2                	sd	s0,80(sp)
    80003202:	e4a6                	sd	s1,72(sp)
    80003204:	e0ca                	sd	s2,64(sp)
    80003206:	fc4e                	sd	s3,56(sp)
    80003208:	f852                	sd	s4,48(sp)
    8000320a:	f456                	sd	s5,40(sp)
    8000320c:	f05a                	sd	s6,32(sp)
    8000320e:	ec5e                	sd	s7,24(sp)
    80003210:	e862                	sd	s8,16(sp)
    80003212:	e466                	sd	s9,8(sp)
    80003214:	1080                	addi	s0,sp,96
    80003216:	84aa                	mv	s1,a0
    80003218:	8b2e                	mv	s6,a1
    8000321a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000321c:	00054703          	lbu	a4,0(a0)
    80003220:	02f00793          	li	a5,47
    80003224:	02f70363          	beq	a4,a5,8000324a <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003228:	ffffe097          	auipc	ra,0xffffe
    8000322c:	cae080e7          	jalr	-850(ra) # 80000ed6 <myproc>
    80003230:	15053503          	ld	a0,336(a0)
    80003234:	00000097          	auipc	ra,0x0
    80003238:	9f6080e7          	jalr	-1546(ra) # 80002c2a <idup>
    8000323c:	89aa                	mv	s3,a0
  while(*path == '/')
    8000323e:	02f00913          	li	s2,47
  len = path - s;
    80003242:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003244:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003246:	4c05                	li	s8,1
    80003248:	a865                	j	80003300 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000324a:	4585                	li	a1,1
    8000324c:	4505                	li	a0,1
    8000324e:	fffff097          	auipc	ra,0xfffff
    80003252:	6e2080e7          	jalr	1762(ra) # 80002930 <iget>
    80003256:	89aa                	mv	s3,a0
    80003258:	b7dd                	j	8000323e <namex+0x42>
      iunlockput(ip);
    8000325a:	854e                	mv	a0,s3
    8000325c:	00000097          	auipc	ra,0x0
    80003260:	c6e080e7          	jalr	-914(ra) # 80002eca <iunlockput>
      return 0;
    80003264:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003266:	854e                	mv	a0,s3
    80003268:	60e6                	ld	ra,88(sp)
    8000326a:	6446                	ld	s0,80(sp)
    8000326c:	64a6                	ld	s1,72(sp)
    8000326e:	6906                	ld	s2,64(sp)
    80003270:	79e2                	ld	s3,56(sp)
    80003272:	7a42                	ld	s4,48(sp)
    80003274:	7aa2                	ld	s5,40(sp)
    80003276:	7b02                	ld	s6,32(sp)
    80003278:	6be2                	ld	s7,24(sp)
    8000327a:	6c42                	ld	s8,16(sp)
    8000327c:	6ca2                	ld	s9,8(sp)
    8000327e:	6125                	addi	sp,sp,96
    80003280:	8082                	ret
      iunlock(ip);
    80003282:	854e                	mv	a0,s3
    80003284:	00000097          	auipc	ra,0x0
    80003288:	aa6080e7          	jalr	-1370(ra) # 80002d2a <iunlock>
      return ip;
    8000328c:	bfe9                	j	80003266 <namex+0x6a>
      iunlockput(ip);
    8000328e:	854e                	mv	a0,s3
    80003290:	00000097          	auipc	ra,0x0
    80003294:	c3a080e7          	jalr	-966(ra) # 80002eca <iunlockput>
      return 0;
    80003298:	89d2                	mv	s3,s4
    8000329a:	b7f1                	j	80003266 <namex+0x6a>
  len = path - s;
    8000329c:	40b48633          	sub	a2,s1,a1
    800032a0:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032a4:	094cd463          	bge	s9,s4,8000332c <namex+0x130>
    memmove(name, s, DIRSIZ);
    800032a8:	4639                	li	a2,14
    800032aa:	8556                	mv	a0,s5
    800032ac:	ffffd097          	auipc	ra,0xffffd
    800032b0:	f52080e7          	jalr	-174(ra) # 800001fe <memmove>
  while(*path == '/')
    800032b4:	0004c783          	lbu	a5,0(s1)
    800032b8:	01279763          	bne	a5,s2,800032c6 <namex+0xca>
    path++;
    800032bc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032be:	0004c783          	lbu	a5,0(s1)
    800032c2:	ff278de3          	beq	a5,s2,800032bc <namex+0xc0>
    ilock(ip);
    800032c6:	854e                	mv	a0,s3
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	9a0080e7          	jalr	-1632(ra) # 80002c68 <ilock>
    if(ip->type != T_DIR){
    800032d0:	04499783          	lh	a5,68(s3)
    800032d4:	f98793e3          	bne	a5,s8,8000325a <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800032d8:	000b0563          	beqz	s6,800032e2 <namex+0xe6>
    800032dc:	0004c783          	lbu	a5,0(s1)
    800032e0:	d3cd                	beqz	a5,80003282 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032e2:	865e                	mv	a2,s7
    800032e4:	85d6                	mv	a1,s5
    800032e6:	854e                	mv	a0,s3
    800032e8:	00000097          	auipc	ra,0x0
    800032ec:	e64080e7          	jalr	-412(ra) # 8000314c <dirlookup>
    800032f0:	8a2a                	mv	s4,a0
    800032f2:	dd51                	beqz	a0,8000328e <namex+0x92>
    iunlockput(ip);
    800032f4:	854e                	mv	a0,s3
    800032f6:	00000097          	auipc	ra,0x0
    800032fa:	bd4080e7          	jalr	-1068(ra) # 80002eca <iunlockput>
    ip = next;
    800032fe:	89d2                	mv	s3,s4
  while(*path == '/')
    80003300:	0004c783          	lbu	a5,0(s1)
    80003304:	05279763          	bne	a5,s2,80003352 <namex+0x156>
    path++;
    80003308:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000330a:	0004c783          	lbu	a5,0(s1)
    8000330e:	ff278de3          	beq	a5,s2,80003308 <namex+0x10c>
  if(*path == 0)
    80003312:	c79d                	beqz	a5,80003340 <namex+0x144>
    path++;
    80003314:	85a6                	mv	a1,s1
  len = path - s;
    80003316:	8a5e                	mv	s4,s7
    80003318:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000331a:	01278963          	beq	a5,s2,8000332c <namex+0x130>
    8000331e:	dfbd                	beqz	a5,8000329c <namex+0xa0>
    path++;
    80003320:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003322:	0004c783          	lbu	a5,0(s1)
    80003326:	ff279ce3          	bne	a5,s2,8000331e <namex+0x122>
    8000332a:	bf8d                	j	8000329c <namex+0xa0>
    memmove(name, s, len);
    8000332c:	2601                	sext.w	a2,a2
    8000332e:	8556                	mv	a0,s5
    80003330:	ffffd097          	auipc	ra,0xffffd
    80003334:	ece080e7          	jalr	-306(ra) # 800001fe <memmove>
    name[len] = 0;
    80003338:	9a56                	add	s4,s4,s5
    8000333a:	000a0023          	sb	zero,0(s4)
    8000333e:	bf9d                	j	800032b4 <namex+0xb8>
  if(nameiparent){
    80003340:	f20b03e3          	beqz	s6,80003266 <namex+0x6a>
    iput(ip);
    80003344:	854e                	mv	a0,s3
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	adc080e7          	jalr	-1316(ra) # 80002e22 <iput>
    return 0;
    8000334e:	4981                	li	s3,0
    80003350:	bf19                	j	80003266 <namex+0x6a>
  if(*path == 0)
    80003352:	d7fd                	beqz	a5,80003340 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003354:	0004c783          	lbu	a5,0(s1)
    80003358:	85a6                	mv	a1,s1
    8000335a:	b7d1                	j	8000331e <namex+0x122>

000000008000335c <dirlink>:
{
    8000335c:	7139                	addi	sp,sp,-64
    8000335e:	fc06                	sd	ra,56(sp)
    80003360:	f822                	sd	s0,48(sp)
    80003362:	f426                	sd	s1,40(sp)
    80003364:	f04a                	sd	s2,32(sp)
    80003366:	ec4e                	sd	s3,24(sp)
    80003368:	e852                	sd	s4,16(sp)
    8000336a:	0080                	addi	s0,sp,64
    8000336c:	892a                	mv	s2,a0
    8000336e:	8a2e                	mv	s4,a1
    80003370:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003372:	4601                	li	a2,0
    80003374:	00000097          	auipc	ra,0x0
    80003378:	dd8080e7          	jalr	-552(ra) # 8000314c <dirlookup>
    8000337c:	e93d                	bnez	a0,800033f2 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000337e:	04c92483          	lw	s1,76(s2)
    80003382:	c49d                	beqz	s1,800033b0 <dirlink+0x54>
    80003384:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003386:	4741                	li	a4,16
    80003388:	86a6                	mv	a3,s1
    8000338a:	fc040613          	addi	a2,s0,-64
    8000338e:	4581                	li	a1,0
    80003390:	854a                	mv	a0,s2
    80003392:	00000097          	auipc	ra,0x0
    80003396:	b8a080e7          	jalr	-1142(ra) # 80002f1c <readi>
    8000339a:	47c1                	li	a5,16
    8000339c:	06f51163          	bne	a0,a5,800033fe <dirlink+0xa2>
    if(de.inum == 0)
    800033a0:	fc045783          	lhu	a5,-64(s0)
    800033a4:	c791                	beqz	a5,800033b0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033a6:	24c1                	addiw	s1,s1,16
    800033a8:	04c92783          	lw	a5,76(s2)
    800033ac:	fcf4ede3          	bltu	s1,a5,80003386 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033b0:	4639                	li	a2,14
    800033b2:	85d2                	mv	a1,s4
    800033b4:	fc240513          	addi	a0,s0,-62
    800033b8:	ffffd097          	auipc	ra,0xffffd
    800033bc:	efa080e7          	jalr	-262(ra) # 800002b2 <strncpy>
  de.inum = inum;
    800033c0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033c4:	4741                	li	a4,16
    800033c6:	86a6                	mv	a3,s1
    800033c8:	fc040613          	addi	a2,s0,-64
    800033cc:	4581                	li	a1,0
    800033ce:	854a                	mv	a0,s2
    800033d0:	00000097          	auipc	ra,0x0
    800033d4:	c44080e7          	jalr	-956(ra) # 80003014 <writei>
    800033d8:	1541                	addi	a0,a0,-16
    800033da:	00a03533          	snez	a0,a0
    800033de:	40a00533          	neg	a0,a0
}
    800033e2:	70e2                	ld	ra,56(sp)
    800033e4:	7442                	ld	s0,48(sp)
    800033e6:	74a2                	ld	s1,40(sp)
    800033e8:	7902                	ld	s2,32(sp)
    800033ea:	69e2                	ld	s3,24(sp)
    800033ec:	6a42                	ld	s4,16(sp)
    800033ee:	6121                	addi	sp,sp,64
    800033f0:	8082                	ret
    iput(ip);
    800033f2:	00000097          	auipc	ra,0x0
    800033f6:	a30080e7          	jalr	-1488(ra) # 80002e22 <iput>
    return -1;
    800033fa:	557d                	li	a0,-1
    800033fc:	b7dd                	j	800033e2 <dirlink+0x86>
      panic("dirlink read");
    800033fe:	00005517          	auipc	a0,0x5
    80003402:	2b250513          	addi	a0,a0,690 # 800086b0 <syscalls+0x1d8>
    80003406:	00003097          	auipc	ra,0x3
    8000340a:	95c080e7          	jalr	-1700(ra) # 80005d62 <panic>

000000008000340e <namei>:

struct inode*
namei(char *path)
{
    8000340e:	1101                	addi	sp,sp,-32
    80003410:	ec06                	sd	ra,24(sp)
    80003412:	e822                	sd	s0,16(sp)
    80003414:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003416:	fe040613          	addi	a2,s0,-32
    8000341a:	4581                	li	a1,0
    8000341c:	00000097          	auipc	ra,0x0
    80003420:	de0080e7          	jalr	-544(ra) # 800031fc <namex>
}
    80003424:	60e2                	ld	ra,24(sp)
    80003426:	6442                	ld	s0,16(sp)
    80003428:	6105                	addi	sp,sp,32
    8000342a:	8082                	ret

000000008000342c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000342c:	1141                	addi	sp,sp,-16
    8000342e:	e406                	sd	ra,8(sp)
    80003430:	e022                	sd	s0,0(sp)
    80003432:	0800                	addi	s0,sp,16
    80003434:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003436:	4585                	li	a1,1
    80003438:	00000097          	auipc	ra,0x0
    8000343c:	dc4080e7          	jalr	-572(ra) # 800031fc <namex>
}
    80003440:	60a2                	ld	ra,8(sp)
    80003442:	6402                	ld	s0,0(sp)
    80003444:	0141                	addi	sp,sp,16
    80003446:	8082                	ret

0000000080003448 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003448:	1101                	addi	sp,sp,-32
    8000344a:	ec06                	sd	ra,24(sp)
    8000344c:	e822                	sd	s0,16(sp)
    8000344e:	e426                	sd	s1,8(sp)
    80003450:	e04a                	sd	s2,0(sp)
    80003452:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003454:	00016917          	auipc	s2,0x16
    80003458:	83c90913          	addi	s2,s2,-1988 # 80018c90 <log>
    8000345c:	01892583          	lw	a1,24(s2)
    80003460:	02892503          	lw	a0,40(s2)
    80003464:	fffff097          	auipc	ra,0xfffff
    80003468:	fea080e7          	jalr	-22(ra) # 8000244e <bread>
    8000346c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000346e:	02c92683          	lw	a3,44(s2)
    80003472:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003474:	02d05763          	blez	a3,800034a2 <write_head+0x5a>
    80003478:	00016797          	auipc	a5,0x16
    8000347c:	84878793          	addi	a5,a5,-1976 # 80018cc0 <log+0x30>
    80003480:	05c50713          	addi	a4,a0,92
    80003484:	36fd                	addiw	a3,a3,-1
    80003486:	1682                	slli	a3,a3,0x20
    80003488:	9281                	srli	a3,a3,0x20
    8000348a:	068a                	slli	a3,a3,0x2
    8000348c:	00016617          	auipc	a2,0x16
    80003490:	83860613          	addi	a2,a2,-1992 # 80018cc4 <log+0x34>
    80003494:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003496:	4390                	lw	a2,0(a5)
    80003498:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000349a:	0791                	addi	a5,a5,4
    8000349c:	0711                	addi	a4,a4,4
    8000349e:	fed79ce3          	bne	a5,a3,80003496 <write_head+0x4e>
  }
  bwrite(buf);
    800034a2:	8526                	mv	a0,s1
    800034a4:	fffff097          	auipc	ra,0xfffff
    800034a8:	09c080e7          	jalr	156(ra) # 80002540 <bwrite>
  brelse(buf);
    800034ac:	8526                	mv	a0,s1
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	0d0080e7          	jalr	208(ra) # 8000257e <brelse>
}
    800034b6:	60e2                	ld	ra,24(sp)
    800034b8:	6442                	ld	s0,16(sp)
    800034ba:	64a2                	ld	s1,8(sp)
    800034bc:	6902                	ld	s2,0(sp)
    800034be:	6105                	addi	sp,sp,32
    800034c0:	8082                	ret

00000000800034c2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034c2:	00015797          	auipc	a5,0x15
    800034c6:	7fa7a783          	lw	a5,2042(a5) # 80018cbc <log+0x2c>
    800034ca:	0af05d63          	blez	a5,80003584 <install_trans+0xc2>
{
    800034ce:	7139                	addi	sp,sp,-64
    800034d0:	fc06                	sd	ra,56(sp)
    800034d2:	f822                	sd	s0,48(sp)
    800034d4:	f426                	sd	s1,40(sp)
    800034d6:	f04a                	sd	s2,32(sp)
    800034d8:	ec4e                	sd	s3,24(sp)
    800034da:	e852                	sd	s4,16(sp)
    800034dc:	e456                	sd	s5,8(sp)
    800034de:	e05a                	sd	s6,0(sp)
    800034e0:	0080                	addi	s0,sp,64
    800034e2:	8b2a                	mv	s6,a0
    800034e4:	00015a97          	auipc	s5,0x15
    800034e8:	7dca8a93          	addi	s5,s5,2012 # 80018cc0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ec:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ee:	00015997          	auipc	s3,0x15
    800034f2:	7a298993          	addi	s3,s3,1954 # 80018c90 <log>
    800034f6:	a035                	j	80003522 <install_trans+0x60>
      bunpin(dbuf);
    800034f8:	8526                	mv	a0,s1
    800034fa:	fffff097          	auipc	ra,0xfffff
    800034fe:	15e080e7          	jalr	350(ra) # 80002658 <bunpin>
    brelse(lbuf);
    80003502:	854a                	mv	a0,s2
    80003504:	fffff097          	auipc	ra,0xfffff
    80003508:	07a080e7          	jalr	122(ra) # 8000257e <brelse>
    brelse(dbuf);
    8000350c:	8526                	mv	a0,s1
    8000350e:	fffff097          	auipc	ra,0xfffff
    80003512:	070080e7          	jalr	112(ra) # 8000257e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003516:	2a05                	addiw	s4,s4,1
    80003518:	0a91                	addi	s5,s5,4
    8000351a:	02c9a783          	lw	a5,44(s3)
    8000351e:	04fa5963          	bge	s4,a5,80003570 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003522:	0189a583          	lw	a1,24(s3)
    80003526:	014585bb          	addw	a1,a1,s4
    8000352a:	2585                	addiw	a1,a1,1
    8000352c:	0289a503          	lw	a0,40(s3)
    80003530:	fffff097          	auipc	ra,0xfffff
    80003534:	f1e080e7          	jalr	-226(ra) # 8000244e <bread>
    80003538:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000353a:	000aa583          	lw	a1,0(s5)
    8000353e:	0289a503          	lw	a0,40(s3)
    80003542:	fffff097          	auipc	ra,0xfffff
    80003546:	f0c080e7          	jalr	-244(ra) # 8000244e <bread>
    8000354a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000354c:	40000613          	li	a2,1024
    80003550:	05890593          	addi	a1,s2,88
    80003554:	05850513          	addi	a0,a0,88
    80003558:	ffffd097          	auipc	ra,0xffffd
    8000355c:	ca6080e7          	jalr	-858(ra) # 800001fe <memmove>
    bwrite(dbuf);  // write dst to disk
    80003560:	8526                	mv	a0,s1
    80003562:	fffff097          	auipc	ra,0xfffff
    80003566:	fde080e7          	jalr	-34(ra) # 80002540 <bwrite>
    if(recovering == 0)
    8000356a:	f80b1ce3          	bnez	s6,80003502 <install_trans+0x40>
    8000356e:	b769                	j	800034f8 <install_trans+0x36>
}
    80003570:	70e2                	ld	ra,56(sp)
    80003572:	7442                	ld	s0,48(sp)
    80003574:	74a2                	ld	s1,40(sp)
    80003576:	7902                	ld	s2,32(sp)
    80003578:	69e2                	ld	s3,24(sp)
    8000357a:	6a42                	ld	s4,16(sp)
    8000357c:	6aa2                	ld	s5,8(sp)
    8000357e:	6b02                	ld	s6,0(sp)
    80003580:	6121                	addi	sp,sp,64
    80003582:	8082                	ret
    80003584:	8082                	ret

0000000080003586 <initlog>:
{
    80003586:	7179                	addi	sp,sp,-48
    80003588:	f406                	sd	ra,40(sp)
    8000358a:	f022                	sd	s0,32(sp)
    8000358c:	ec26                	sd	s1,24(sp)
    8000358e:	e84a                	sd	s2,16(sp)
    80003590:	e44e                	sd	s3,8(sp)
    80003592:	1800                	addi	s0,sp,48
    80003594:	892a                	mv	s2,a0
    80003596:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003598:	00015497          	auipc	s1,0x15
    8000359c:	6f848493          	addi	s1,s1,1784 # 80018c90 <log>
    800035a0:	00005597          	auipc	a1,0x5
    800035a4:	12058593          	addi	a1,a1,288 # 800086c0 <syscalls+0x1e8>
    800035a8:	8526                	mv	a0,s1
    800035aa:	00003097          	auipc	ra,0x3
    800035ae:	c72080e7          	jalr	-910(ra) # 8000621c <initlock>
  log.start = sb->logstart;
    800035b2:	0149a583          	lw	a1,20(s3)
    800035b6:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035b8:	0109a783          	lw	a5,16(s3)
    800035bc:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035be:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035c2:	854a                	mv	a0,s2
    800035c4:	fffff097          	auipc	ra,0xfffff
    800035c8:	e8a080e7          	jalr	-374(ra) # 8000244e <bread>
  log.lh.n = lh->n;
    800035cc:	4d3c                	lw	a5,88(a0)
    800035ce:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035d0:	02f05563          	blez	a5,800035fa <initlog+0x74>
    800035d4:	05c50713          	addi	a4,a0,92
    800035d8:	00015697          	auipc	a3,0x15
    800035dc:	6e868693          	addi	a3,a3,1768 # 80018cc0 <log+0x30>
    800035e0:	37fd                	addiw	a5,a5,-1
    800035e2:	1782                	slli	a5,a5,0x20
    800035e4:	9381                	srli	a5,a5,0x20
    800035e6:	078a                	slli	a5,a5,0x2
    800035e8:	06050613          	addi	a2,a0,96
    800035ec:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800035ee:	4310                	lw	a2,0(a4)
    800035f0:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800035f2:	0711                	addi	a4,a4,4
    800035f4:	0691                	addi	a3,a3,4
    800035f6:	fef71ce3          	bne	a4,a5,800035ee <initlog+0x68>
  brelse(buf);
    800035fa:	fffff097          	auipc	ra,0xfffff
    800035fe:	f84080e7          	jalr	-124(ra) # 8000257e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003602:	4505                	li	a0,1
    80003604:	00000097          	auipc	ra,0x0
    80003608:	ebe080e7          	jalr	-322(ra) # 800034c2 <install_trans>
  log.lh.n = 0;
    8000360c:	00015797          	auipc	a5,0x15
    80003610:	6a07a823          	sw	zero,1712(a5) # 80018cbc <log+0x2c>
  write_head(); // clear the log
    80003614:	00000097          	auipc	ra,0x0
    80003618:	e34080e7          	jalr	-460(ra) # 80003448 <write_head>
}
    8000361c:	70a2                	ld	ra,40(sp)
    8000361e:	7402                	ld	s0,32(sp)
    80003620:	64e2                	ld	s1,24(sp)
    80003622:	6942                	ld	s2,16(sp)
    80003624:	69a2                	ld	s3,8(sp)
    80003626:	6145                	addi	sp,sp,48
    80003628:	8082                	ret

000000008000362a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000362a:	1101                	addi	sp,sp,-32
    8000362c:	ec06                	sd	ra,24(sp)
    8000362e:	e822                	sd	s0,16(sp)
    80003630:	e426                	sd	s1,8(sp)
    80003632:	e04a                	sd	s2,0(sp)
    80003634:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003636:	00015517          	auipc	a0,0x15
    8000363a:	65a50513          	addi	a0,a0,1626 # 80018c90 <log>
    8000363e:	00003097          	auipc	ra,0x3
    80003642:	c6e080e7          	jalr	-914(ra) # 800062ac <acquire>
  while(1){
    if(log.committing){
    80003646:	00015497          	auipc	s1,0x15
    8000364a:	64a48493          	addi	s1,s1,1610 # 80018c90 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000364e:	4979                	li	s2,30
    80003650:	a039                	j	8000365e <begin_op+0x34>
      sleep(&log, &log.lock);
    80003652:	85a6                	mv	a1,s1
    80003654:	8526                	mv	a0,s1
    80003656:	ffffe097          	auipc	ra,0xffffe
    8000365a:	f30080e7          	jalr	-208(ra) # 80001586 <sleep>
    if(log.committing){
    8000365e:	50dc                	lw	a5,36(s1)
    80003660:	fbed                	bnez	a5,80003652 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003662:	509c                	lw	a5,32(s1)
    80003664:	0017871b          	addiw	a4,a5,1
    80003668:	0007069b          	sext.w	a3,a4
    8000366c:	0027179b          	slliw	a5,a4,0x2
    80003670:	9fb9                	addw	a5,a5,a4
    80003672:	0017979b          	slliw	a5,a5,0x1
    80003676:	54d8                	lw	a4,44(s1)
    80003678:	9fb9                	addw	a5,a5,a4
    8000367a:	00f95963          	bge	s2,a5,8000368c <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000367e:	85a6                	mv	a1,s1
    80003680:	8526                	mv	a0,s1
    80003682:	ffffe097          	auipc	ra,0xffffe
    80003686:	f04080e7          	jalr	-252(ra) # 80001586 <sleep>
    8000368a:	bfd1                	j	8000365e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000368c:	00015517          	auipc	a0,0x15
    80003690:	60450513          	addi	a0,a0,1540 # 80018c90 <log>
    80003694:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003696:	00003097          	auipc	ra,0x3
    8000369a:	cca080e7          	jalr	-822(ra) # 80006360 <release>
      break;
    }
  }
}
    8000369e:	60e2                	ld	ra,24(sp)
    800036a0:	6442                	ld	s0,16(sp)
    800036a2:	64a2                	ld	s1,8(sp)
    800036a4:	6902                	ld	s2,0(sp)
    800036a6:	6105                	addi	sp,sp,32
    800036a8:	8082                	ret

00000000800036aa <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036aa:	7139                	addi	sp,sp,-64
    800036ac:	fc06                	sd	ra,56(sp)
    800036ae:	f822                	sd	s0,48(sp)
    800036b0:	f426                	sd	s1,40(sp)
    800036b2:	f04a                	sd	s2,32(sp)
    800036b4:	ec4e                	sd	s3,24(sp)
    800036b6:	e852                	sd	s4,16(sp)
    800036b8:	e456                	sd	s5,8(sp)
    800036ba:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036bc:	00015497          	auipc	s1,0x15
    800036c0:	5d448493          	addi	s1,s1,1492 # 80018c90 <log>
    800036c4:	8526                	mv	a0,s1
    800036c6:	00003097          	auipc	ra,0x3
    800036ca:	be6080e7          	jalr	-1050(ra) # 800062ac <acquire>
  log.outstanding -= 1;
    800036ce:	509c                	lw	a5,32(s1)
    800036d0:	37fd                	addiw	a5,a5,-1
    800036d2:	0007891b          	sext.w	s2,a5
    800036d6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036d8:	50dc                	lw	a5,36(s1)
    800036da:	efb9                	bnez	a5,80003738 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036dc:	06091663          	bnez	s2,80003748 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800036e0:	00015497          	auipc	s1,0x15
    800036e4:	5b048493          	addi	s1,s1,1456 # 80018c90 <log>
    800036e8:	4785                	li	a5,1
    800036ea:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036ec:	8526                	mv	a0,s1
    800036ee:	00003097          	auipc	ra,0x3
    800036f2:	c72080e7          	jalr	-910(ra) # 80006360 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036f6:	54dc                	lw	a5,44(s1)
    800036f8:	06f04763          	bgtz	a5,80003766 <end_op+0xbc>
    acquire(&log.lock);
    800036fc:	00015497          	auipc	s1,0x15
    80003700:	59448493          	addi	s1,s1,1428 # 80018c90 <log>
    80003704:	8526                	mv	a0,s1
    80003706:	00003097          	auipc	ra,0x3
    8000370a:	ba6080e7          	jalr	-1114(ra) # 800062ac <acquire>
    log.committing = 0;
    8000370e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003712:	8526                	mv	a0,s1
    80003714:	ffffe097          	auipc	ra,0xffffe
    80003718:	ed6080e7          	jalr	-298(ra) # 800015ea <wakeup>
    release(&log.lock);
    8000371c:	8526                	mv	a0,s1
    8000371e:	00003097          	auipc	ra,0x3
    80003722:	c42080e7          	jalr	-958(ra) # 80006360 <release>
}
    80003726:	70e2                	ld	ra,56(sp)
    80003728:	7442                	ld	s0,48(sp)
    8000372a:	74a2                	ld	s1,40(sp)
    8000372c:	7902                	ld	s2,32(sp)
    8000372e:	69e2                	ld	s3,24(sp)
    80003730:	6a42                	ld	s4,16(sp)
    80003732:	6aa2                	ld	s5,8(sp)
    80003734:	6121                	addi	sp,sp,64
    80003736:	8082                	ret
    panic("log.committing");
    80003738:	00005517          	auipc	a0,0x5
    8000373c:	f9050513          	addi	a0,a0,-112 # 800086c8 <syscalls+0x1f0>
    80003740:	00002097          	auipc	ra,0x2
    80003744:	622080e7          	jalr	1570(ra) # 80005d62 <panic>
    wakeup(&log);
    80003748:	00015497          	auipc	s1,0x15
    8000374c:	54848493          	addi	s1,s1,1352 # 80018c90 <log>
    80003750:	8526                	mv	a0,s1
    80003752:	ffffe097          	auipc	ra,0xffffe
    80003756:	e98080e7          	jalr	-360(ra) # 800015ea <wakeup>
  release(&log.lock);
    8000375a:	8526                	mv	a0,s1
    8000375c:	00003097          	auipc	ra,0x3
    80003760:	c04080e7          	jalr	-1020(ra) # 80006360 <release>
  if(do_commit){
    80003764:	b7c9                	j	80003726 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003766:	00015a97          	auipc	s5,0x15
    8000376a:	55aa8a93          	addi	s5,s5,1370 # 80018cc0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000376e:	00015a17          	auipc	s4,0x15
    80003772:	522a0a13          	addi	s4,s4,1314 # 80018c90 <log>
    80003776:	018a2583          	lw	a1,24(s4)
    8000377a:	012585bb          	addw	a1,a1,s2
    8000377e:	2585                	addiw	a1,a1,1
    80003780:	028a2503          	lw	a0,40(s4)
    80003784:	fffff097          	auipc	ra,0xfffff
    80003788:	cca080e7          	jalr	-822(ra) # 8000244e <bread>
    8000378c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000378e:	000aa583          	lw	a1,0(s5)
    80003792:	028a2503          	lw	a0,40(s4)
    80003796:	fffff097          	auipc	ra,0xfffff
    8000379a:	cb8080e7          	jalr	-840(ra) # 8000244e <bread>
    8000379e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037a0:	40000613          	li	a2,1024
    800037a4:	05850593          	addi	a1,a0,88
    800037a8:	05848513          	addi	a0,s1,88
    800037ac:	ffffd097          	auipc	ra,0xffffd
    800037b0:	a52080e7          	jalr	-1454(ra) # 800001fe <memmove>
    bwrite(to);  // write the log
    800037b4:	8526                	mv	a0,s1
    800037b6:	fffff097          	auipc	ra,0xfffff
    800037ba:	d8a080e7          	jalr	-630(ra) # 80002540 <bwrite>
    brelse(from);
    800037be:	854e                	mv	a0,s3
    800037c0:	fffff097          	auipc	ra,0xfffff
    800037c4:	dbe080e7          	jalr	-578(ra) # 8000257e <brelse>
    brelse(to);
    800037c8:	8526                	mv	a0,s1
    800037ca:	fffff097          	auipc	ra,0xfffff
    800037ce:	db4080e7          	jalr	-588(ra) # 8000257e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037d2:	2905                	addiw	s2,s2,1
    800037d4:	0a91                	addi	s5,s5,4
    800037d6:	02ca2783          	lw	a5,44(s4)
    800037da:	f8f94ee3          	blt	s2,a5,80003776 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037de:	00000097          	auipc	ra,0x0
    800037e2:	c6a080e7          	jalr	-918(ra) # 80003448 <write_head>
    install_trans(0); // Now install writes to home locations
    800037e6:	4501                	li	a0,0
    800037e8:	00000097          	auipc	ra,0x0
    800037ec:	cda080e7          	jalr	-806(ra) # 800034c2 <install_trans>
    log.lh.n = 0;
    800037f0:	00015797          	auipc	a5,0x15
    800037f4:	4c07a623          	sw	zero,1228(a5) # 80018cbc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037f8:	00000097          	auipc	ra,0x0
    800037fc:	c50080e7          	jalr	-944(ra) # 80003448 <write_head>
    80003800:	bdf5                	j	800036fc <end_op+0x52>

0000000080003802 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003802:	1101                	addi	sp,sp,-32
    80003804:	ec06                	sd	ra,24(sp)
    80003806:	e822                	sd	s0,16(sp)
    80003808:	e426                	sd	s1,8(sp)
    8000380a:	e04a                	sd	s2,0(sp)
    8000380c:	1000                	addi	s0,sp,32
    8000380e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003810:	00015917          	auipc	s2,0x15
    80003814:	48090913          	addi	s2,s2,1152 # 80018c90 <log>
    80003818:	854a                	mv	a0,s2
    8000381a:	00003097          	auipc	ra,0x3
    8000381e:	a92080e7          	jalr	-1390(ra) # 800062ac <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003822:	02c92603          	lw	a2,44(s2)
    80003826:	47f5                	li	a5,29
    80003828:	06c7c563          	blt	a5,a2,80003892 <log_write+0x90>
    8000382c:	00015797          	auipc	a5,0x15
    80003830:	4807a783          	lw	a5,1152(a5) # 80018cac <log+0x1c>
    80003834:	37fd                	addiw	a5,a5,-1
    80003836:	04f65e63          	bge	a2,a5,80003892 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000383a:	00015797          	auipc	a5,0x15
    8000383e:	4767a783          	lw	a5,1142(a5) # 80018cb0 <log+0x20>
    80003842:	06f05063          	blez	a5,800038a2 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003846:	4781                	li	a5,0
    80003848:	06c05563          	blez	a2,800038b2 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000384c:	44cc                	lw	a1,12(s1)
    8000384e:	00015717          	auipc	a4,0x15
    80003852:	47270713          	addi	a4,a4,1138 # 80018cc0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003856:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003858:	4314                	lw	a3,0(a4)
    8000385a:	04b68c63          	beq	a3,a1,800038b2 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000385e:	2785                	addiw	a5,a5,1
    80003860:	0711                	addi	a4,a4,4
    80003862:	fef61be3          	bne	a2,a5,80003858 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003866:	0621                	addi	a2,a2,8
    80003868:	060a                	slli	a2,a2,0x2
    8000386a:	00015797          	auipc	a5,0x15
    8000386e:	42678793          	addi	a5,a5,1062 # 80018c90 <log>
    80003872:	963e                	add	a2,a2,a5
    80003874:	44dc                	lw	a5,12(s1)
    80003876:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003878:	8526                	mv	a0,s1
    8000387a:	fffff097          	auipc	ra,0xfffff
    8000387e:	da2080e7          	jalr	-606(ra) # 8000261c <bpin>
    log.lh.n++;
    80003882:	00015717          	auipc	a4,0x15
    80003886:	40e70713          	addi	a4,a4,1038 # 80018c90 <log>
    8000388a:	575c                	lw	a5,44(a4)
    8000388c:	2785                	addiw	a5,a5,1
    8000388e:	d75c                	sw	a5,44(a4)
    80003890:	a835                	j	800038cc <log_write+0xca>
    panic("too big a transaction");
    80003892:	00005517          	auipc	a0,0x5
    80003896:	e4650513          	addi	a0,a0,-442 # 800086d8 <syscalls+0x200>
    8000389a:	00002097          	auipc	ra,0x2
    8000389e:	4c8080e7          	jalr	1224(ra) # 80005d62 <panic>
    panic("log_write outside of trans");
    800038a2:	00005517          	auipc	a0,0x5
    800038a6:	e4e50513          	addi	a0,a0,-434 # 800086f0 <syscalls+0x218>
    800038aa:	00002097          	auipc	ra,0x2
    800038ae:	4b8080e7          	jalr	1208(ra) # 80005d62 <panic>
  log.lh.block[i] = b->blockno;
    800038b2:	00878713          	addi	a4,a5,8
    800038b6:	00271693          	slli	a3,a4,0x2
    800038ba:	00015717          	auipc	a4,0x15
    800038be:	3d670713          	addi	a4,a4,982 # 80018c90 <log>
    800038c2:	9736                	add	a4,a4,a3
    800038c4:	44d4                	lw	a3,12(s1)
    800038c6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038c8:	faf608e3          	beq	a2,a5,80003878 <log_write+0x76>
  }
  release(&log.lock);
    800038cc:	00015517          	auipc	a0,0x15
    800038d0:	3c450513          	addi	a0,a0,964 # 80018c90 <log>
    800038d4:	00003097          	auipc	ra,0x3
    800038d8:	a8c080e7          	jalr	-1396(ra) # 80006360 <release>
}
    800038dc:	60e2                	ld	ra,24(sp)
    800038de:	6442                	ld	s0,16(sp)
    800038e0:	64a2                	ld	s1,8(sp)
    800038e2:	6902                	ld	s2,0(sp)
    800038e4:	6105                	addi	sp,sp,32
    800038e6:	8082                	ret

00000000800038e8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038e8:	1101                	addi	sp,sp,-32
    800038ea:	ec06                	sd	ra,24(sp)
    800038ec:	e822                	sd	s0,16(sp)
    800038ee:	e426                	sd	s1,8(sp)
    800038f0:	e04a                	sd	s2,0(sp)
    800038f2:	1000                	addi	s0,sp,32
    800038f4:	84aa                	mv	s1,a0
    800038f6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038f8:	00005597          	auipc	a1,0x5
    800038fc:	e1858593          	addi	a1,a1,-488 # 80008710 <syscalls+0x238>
    80003900:	0521                	addi	a0,a0,8
    80003902:	00003097          	auipc	ra,0x3
    80003906:	91a080e7          	jalr	-1766(ra) # 8000621c <initlock>
  lk->name = name;
    8000390a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000390e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003912:	0204a423          	sw	zero,40(s1)
}
    80003916:	60e2                	ld	ra,24(sp)
    80003918:	6442                	ld	s0,16(sp)
    8000391a:	64a2                	ld	s1,8(sp)
    8000391c:	6902                	ld	s2,0(sp)
    8000391e:	6105                	addi	sp,sp,32
    80003920:	8082                	ret

0000000080003922 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003922:	1101                	addi	sp,sp,-32
    80003924:	ec06                	sd	ra,24(sp)
    80003926:	e822                	sd	s0,16(sp)
    80003928:	e426                	sd	s1,8(sp)
    8000392a:	e04a                	sd	s2,0(sp)
    8000392c:	1000                	addi	s0,sp,32
    8000392e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003930:	00850913          	addi	s2,a0,8
    80003934:	854a                	mv	a0,s2
    80003936:	00003097          	auipc	ra,0x3
    8000393a:	976080e7          	jalr	-1674(ra) # 800062ac <acquire>
  while (lk->locked) {
    8000393e:	409c                	lw	a5,0(s1)
    80003940:	cb89                	beqz	a5,80003952 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003942:	85ca                	mv	a1,s2
    80003944:	8526                	mv	a0,s1
    80003946:	ffffe097          	auipc	ra,0xffffe
    8000394a:	c40080e7          	jalr	-960(ra) # 80001586 <sleep>
  while (lk->locked) {
    8000394e:	409c                	lw	a5,0(s1)
    80003950:	fbed                	bnez	a5,80003942 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003952:	4785                	li	a5,1
    80003954:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003956:	ffffd097          	auipc	ra,0xffffd
    8000395a:	580080e7          	jalr	1408(ra) # 80000ed6 <myproc>
    8000395e:	591c                	lw	a5,48(a0)
    80003960:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003962:	854a                	mv	a0,s2
    80003964:	00003097          	auipc	ra,0x3
    80003968:	9fc080e7          	jalr	-1540(ra) # 80006360 <release>
}
    8000396c:	60e2                	ld	ra,24(sp)
    8000396e:	6442                	ld	s0,16(sp)
    80003970:	64a2                	ld	s1,8(sp)
    80003972:	6902                	ld	s2,0(sp)
    80003974:	6105                	addi	sp,sp,32
    80003976:	8082                	ret

0000000080003978 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003978:	1101                	addi	sp,sp,-32
    8000397a:	ec06                	sd	ra,24(sp)
    8000397c:	e822                	sd	s0,16(sp)
    8000397e:	e426                	sd	s1,8(sp)
    80003980:	e04a                	sd	s2,0(sp)
    80003982:	1000                	addi	s0,sp,32
    80003984:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003986:	00850913          	addi	s2,a0,8
    8000398a:	854a                	mv	a0,s2
    8000398c:	00003097          	auipc	ra,0x3
    80003990:	920080e7          	jalr	-1760(ra) # 800062ac <acquire>
  lk->locked = 0;
    80003994:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003998:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000399c:	8526                	mv	a0,s1
    8000399e:	ffffe097          	auipc	ra,0xffffe
    800039a2:	c4c080e7          	jalr	-948(ra) # 800015ea <wakeup>
  release(&lk->lk);
    800039a6:	854a                	mv	a0,s2
    800039a8:	00003097          	auipc	ra,0x3
    800039ac:	9b8080e7          	jalr	-1608(ra) # 80006360 <release>
}
    800039b0:	60e2                	ld	ra,24(sp)
    800039b2:	6442                	ld	s0,16(sp)
    800039b4:	64a2                	ld	s1,8(sp)
    800039b6:	6902                	ld	s2,0(sp)
    800039b8:	6105                	addi	sp,sp,32
    800039ba:	8082                	ret

00000000800039bc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039bc:	7179                	addi	sp,sp,-48
    800039be:	f406                	sd	ra,40(sp)
    800039c0:	f022                	sd	s0,32(sp)
    800039c2:	ec26                	sd	s1,24(sp)
    800039c4:	e84a                	sd	s2,16(sp)
    800039c6:	e44e                	sd	s3,8(sp)
    800039c8:	1800                	addi	s0,sp,48
    800039ca:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039cc:	00850913          	addi	s2,a0,8
    800039d0:	854a                	mv	a0,s2
    800039d2:	00003097          	auipc	ra,0x3
    800039d6:	8da080e7          	jalr	-1830(ra) # 800062ac <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039da:	409c                	lw	a5,0(s1)
    800039dc:	ef99                	bnez	a5,800039fa <holdingsleep+0x3e>
    800039de:	4481                	li	s1,0
  release(&lk->lk);
    800039e0:	854a                	mv	a0,s2
    800039e2:	00003097          	auipc	ra,0x3
    800039e6:	97e080e7          	jalr	-1666(ra) # 80006360 <release>
  return r;
}
    800039ea:	8526                	mv	a0,s1
    800039ec:	70a2                	ld	ra,40(sp)
    800039ee:	7402                	ld	s0,32(sp)
    800039f0:	64e2                	ld	s1,24(sp)
    800039f2:	6942                	ld	s2,16(sp)
    800039f4:	69a2                	ld	s3,8(sp)
    800039f6:	6145                	addi	sp,sp,48
    800039f8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039fa:	0284a983          	lw	s3,40(s1)
    800039fe:	ffffd097          	auipc	ra,0xffffd
    80003a02:	4d8080e7          	jalr	1240(ra) # 80000ed6 <myproc>
    80003a06:	5904                	lw	s1,48(a0)
    80003a08:	413484b3          	sub	s1,s1,s3
    80003a0c:	0014b493          	seqz	s1,s1
    80003a10:	bfc1                	j	800039e0 <holdingsleep+0x24>

0000000080003a12 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a12:	1141                	addi	sp,sp,-16
    80003a14:	e406                	sd	ra,8(sp)
    80003a16:	e022                	sd	s0,0(sp)
    80003a18:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a1a:	00005597          	auipc	a1,0x5
    80003a1e:	d0658593          	addi	a1,a1,-762 # 80008720 <syscalls+0x248>
    80003a22:	00015517          	auipc	a0,0x15
    80003a26:	3b650513          	addi	a0,a0,950 # 80018dd8 <ftable>
    80003a2a:	00002097          	auipc	ra,0x2
    80003a2e:	7f2080e7          	jalr	2034(ra) # 8000621c <initlock>
}
    80003a32:	60a2                	ld	ra,8(sp)
    80003a34:	6402                	ld	s0,0(sp)
    80003a36:	0141                	addi	sp,sp,16
    80003a38:	8082                	ret

0000000080003a3a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a3a:	1101                	addi	sp,sp,-32
    80003a3c:	ec06                	sd	ra,24(sp)
    80003a3e:	e822                	sd	s0,16(sp)
    80003a40:	e426                	sd	s1,8(sp)
    80003a42:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a44:	00015517          	auipc	a0,0x15
    80003a48:	39450513          	addi	a0,a0,916 # 80018dd8 <ftable>
    80003a4c:	00003097          	auipc	ra,0x3
    80003a50:	860080e7          	jalr	-1952(ra) # 800062ac <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a54:	00015497          	auipc	s1,0x15
    80003a58:	39c48493          	addi	s1,s1,924 # 80018df0 <ftable+0x18>
    80003a5c:	00016717          	auipc	a4,0x16
    80003a60:	33470713          	addi	a4,a4,820 # 80019d90 <disk>
    if(f->ref == 0){
    80003a64:	40dc                	lw	a5,4(s1)
    80003a66:	cf99                	beqz	a5,80003a84 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a68:	02848493          	addi	s1,s1,40
    80003a6c:	fee49ce3          	bne	s1,a4,80003a64 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a70:	00015517          	auipc	a0,0x15
    80003a74:	36850513          	addi	a0,a0,872 # 80018dd8 <ftable>
    80003a78:	00003097          	auipc	ra,0x3
    80003a7c:	8e8080e7          	jalr	-1816(ra) # 80006360 <release>
  return 0;
    80003a80:	4481                	li	s1,0
    80003a82:	a819                	j	80003a98 <filealloc+0x5e>
      f->ref = 1;
    80003a84:	4785                	li	a5,1
    80003a86:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a88:	00015517          	auipc	a0,0x15
    80003a8c:	35050513          	addi	a0,a0,848 # 80018dd8 <ftable>
    80003a90:	00003097          	auipc	ra,0x3
    80003a94:	8d0080e7          	jalr	-1840(ra) # 80006360 <release>
}
    80003a98:	8526                	mv	a0,s1
    80003a9a:	60e2                	ld	ra,24(sp)
    80003a9c:	6442                	ld	s0,16(sp)
    80003a9e:	64a2                	ld	s1,8(sp)
    80003aa0:	6105                	addi	sp,sp,32
    80003aa2:	8082                	ret

0000000080003aa4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003aa4:	1101                	addi	sp,sp,-32
    80003aa6:	ec06                	sd	ra,24(sp)
    80003aa8:	e822                	sd	s0,16(sp)
    80003aaa:	e426                	sd	s1,8(sp)
    80003aac:	1000                	addi	s0,sp,32
    80003aae:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ab0:	00015517          	auipc	a0,0x15
    80003ab4:	32850513          	addi	a0,a0,808 # 80018dd8 <ftable>
    80003ab8:	00002097          	auipc	ra,0x2
    80003abc:	7f4080e7          	jalr	2036(ra) # 800062ac <acquire>
  if(f->ref < 1)
    80003ac0:	40dc                	lw	a5,4(s1)
    80003ac2:	02f05263          	blez	a5,80003ae6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ac6:	2785                	addiw	a5,a5,1
    80003ac8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003aca:	00015517          	auipc	a0,0x15
    80003ace:	30e50513          	addi	a0,a0,782 # 80018dd8 <ftable>
    80003ad2:	00003097          	auipc	ra,0x3
    80003ad6:	88e080e7          	jalr	-1906(ra) # 80006360 <release>
  return f;
}
    80003ada:	8526                	mv	a0,s1
    80003adc:	60e2                	ld	ra,24(sp)
    80003ade:	6442                	ld	s0,16(sp)
    80003ae0:	64a2                	ld	s1,8(sp)
    80003ae2:	6105                	addi	sp,sp,32
    80003ae4:	8082                	ret
    panic("filedup");
    80003ae6:	00005517          	auipc	a0,0x5
    80003aea:	c4250513          	addi	a0,a0,-958 # 80008728 <syscalls+0x250>
    80003aee:	00002097          	auipc	ra,0x2
    80003af2:	274080e7          	jalr	628(ra) # 80005d62 <panic>

0000000080003af6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003af6:	7139                	addi	sp,sp,-64
    80003af8:	fc06                	sd	ra,56(sp)
    80003afa:	f822                	sd	s0,48(sp)
    80003afc:	f426                	sd	s1,40(sp)
    80003afe:	f04a                	sd	s2,32(sp)
    80003b00:	ec4e                	sd	s3,24(sp)
    80003b02:	e852                	sd	s4,16(sp)
    80003b04:	e456                	sd	s5,8(sp)
    80003b06:	0080                	addi	s0,sp,64
    80003b08:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b0a:	00015517          	auipc	a0,0x15
    80003b0e:	2ce50513          	addi	a0,a0,718 # 80018dd8 <ftable>
    80003b12:	00002097          	auipc	ra,0x2
    80003b16:	79a080e7          	jalr	1946(ra) # 800062ac <acquire>
  if(f->ref < 1)
    80003b1a:	40dc                	lw	a5,4(s1)
    80003b1c:	06f05163          	blez	a5,80003b7e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b20:	37fd                	addiw	a5,a5,-1
    80003b22:	0007871b          	sext.w	a4,a5
    80003b26:	c0dc                	sw	a5,4(s1)
    80003b28:	06e04363          	bgtz	a4,80003b8e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b2c:	0004a903          	lw	s2,0(s1)
    80003b30:	0094ca83          	lbu	s5,9(s1)
    80003b34:	0104ba03          	ld	s4,16(s1)
    80003b38:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b3c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b40:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b44:	00015517          	auipc	a0,0x15
    80003b48:	29450513          	addi	a0,a0,660 # 80018dd8 <ftable>
    80003b4c:	00003097          	auipc	ra,0x3
    80003b50:	814080e7          	jalr	-2028(ra) # 80006360 <release>

  if(ff.type == FD_PIPE){
    80003b54:	4785                	li	a5,1
    80003b56:	04f90d63          	beq	s2,a5,80003bb0 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b5a:	3979                	addiw	s2,s2,-2
    80003b5c:	4785                	li	a5,1
    80003b5e:	0527e063          	bltu	a5,s2,80003b9e <fileclose+0xa8>
    begin_op();
    80003b62:	00000097          	auipc	ra,0x0
    80003b66:	ac8080e7          	jalr	-1336(ra) # 8000362a <begin_op>
    iput(ff.ip);
    80003b6a:	854e                	mv	a0,s3
    80003b6c:	fffff097          	auipc	ra,0xfffff
    80003b70:	2b6080e7          	jalr	694(ra) # 80002e22 <iput>
    end_op();
    80003b74:	00000097          	auipc	ra,0x0
    80003b78:	b36080e7          	jalr	-1226(ra) # 800036aa <end_op>
    80003b7c:	a00d                	j	80003b9e <fileclose+0xa8>
    panic("fileclose");
    80003b7e:	00005517          	auipc	a0,0x5
    80003b82:	bb250513          	addi	a0,a0,-1102 # 80008730 <syscalls+0x258>
    80003b86:	00002097          	auipc	ra,0x2
    80003b8a:	1dc080e7          	jalr	476(ra) # 80005d62 <panic>
    release(&ftable.lock);
    80003b8e:	00015517          	auipc	a0,0x15
    80003b92:	24a50513          	addi	a0,a0,586 # 80018dd8 <ftable>
    80003b96:	00002097          	auipc	ra,0x2
    80003b9a:	7ca080e7          	jalr	1994(ra) # 80006360 <release>
  }
}
    80003b9e:	70e2                	ld	ra,56(sp)
    80003ba0:	7442                	ld	s0,48(sp)
    80003ba2:	74a2                	ld	s1,40(sp)
    80003ba4:	7902                	ld	s2,32(sp)
    80003ba6:	69e2                	ld	s3,24(sp)
    80003ba8:	6a42                	ld	s4,16(sp)
    80003baa:	6aa2                	ld	s5,8(sp)
    80003bac:	6121                	addi	sp,sp,64
    80003bae:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bb0:	85d6                	mv	a1,s5
    80003bb2:	8552                	mv	a0,s4
    80003bb4:	00000097          	auipc	ra,0x0
    80003bb8:	34c080e7          	jalr	844(ra) # 80003f00 <pipeclose>
    80003bbc:	b7cd                	j	80003b9e <fileclose+0xa8>

0000000080003bbe <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bbe:	715d                	addi	sp,sp,-80
    80003bc0:	e486                	sd	ra,72(sp)
    80003bc2:	e0a2                	sd	s0,64(sp)
    80003bc4:	fc26                	sd	s1,56(sp)
    80003bc6:	f84a                	sd	s2,48(sp)
    80003bc8:	f44e                	sd	s3,40(sp)
    80003bca:	0880                	addi	s0,sp,80
    80003bcc:	84aa                	mv	s1,a0
    80003bce:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bd0:	ffffd097          	auipc	ra,0xffffd
    80003bd4:	306080e7          	jalr	774(ra) # 80000ed6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bd8:	409c                	lw	a5,0(s1)
    80003bda:	37f9                	addiw	a5,a5,-2
    80003bdc:	4705                	li	a4,1
    80003bde:	04f76763          	bltu	a4,a5,80003c2c <filestat+0x6e>
    80003be2:	892a                	mv	s2,a0
    ilock(f->ip);
    80003be4:	6c88                	ld	a0,24(s1)
    80003be6:	fffff097          	auipc	ra,0xfffff
    80003bea:	082080e7          	jalr	130(ra) # 80002c68 <ilock>
    stati(f->ip, &st);
    80003bee:	fb840593          	addi	a1,s0,-72
    80003bf2:	6c88                	ld	a0,24(s1)
    80003bf4:	fffff097          	auipc	ra,0xfffff
    80003bf8:	2fe080e7          	jalr	766(ra) # 80002ef2 <stati>
    iunlock(f->ip);
    80003bfc:	6c88                	ld	a0,24(s1)
    80003bfe:	fffff097          	auipc	ra,0xfffff
    80003c02:	12c080e7          	jalr	300(ra) # 80002d2a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c06:	46e1                	li	a3,24
    80003c08:	fb840613          	addi	a2,s0,-72
    80003c0c:	85ce                	mv	a1,s3
    80003c0e:	05093503          	ld	a0,80(s2)
    80003c12:	ffffd097          	auipc	ra,0xffffd
    80003c16:	f4e080e7          	jalr	-178(ra) # 80000b60 <copyout>
    80003c1a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c1e:	60a6                	ld	ra,72(sp)
    80003c20:	6406                	ld	s0,64(sp)
    80003c22:	74e2                	ld	s1,56(sp)
    80003c24:	7942                	ld	s2,48(sp)
    80003c26:	79a2                	ld	s3,40(sp)
    80003c28:	6161                	addi	sp,sp,80
    80003c2a:	8082                	ret
  return -1;
    80003c2c:	557d                	li	a0,-1
    80003c2e:	bfc5                	j	80003c1e <filestat+0x60>

0000000080003c30 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c30:	7179                	addi	sp,sp,-48
    80003c32:	f406                	sd	ra,40(sp)
    80003c34:	f022                	sd	s0,32(sp)
    80003c36:	ec26                	sd	s1,24(sp)
    80003c38:	e84a                	sd	s2,16(sp)
    80003c3a:	e44e                	sd	s3,8(sp)
    80003c3c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c3e:	00854783          	lbu	a5,8(a0)
    80003c42:	c3d5                	beqz	a5,80003ce6 <fileread+0xb6>
    80003c44:	84aa                	mv	s1,a0
    80003c46:	89ae                	mv	s3,a1
    80003c48:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c4a:	411c                	lw	a5,0(a0)
    80003c4c:	4705                	li	a4,1
    80003c4e:	04e78963          	beq	a5,a4,80003ca0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c52:	470d                	li	a4,3
    80003c54:	04e78d63          	beq	a5,a4,80003cae <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c58:	4709                	li	a4,2
    80003c5a:	06e79e63          	bne	a5,a4,80003cd6 <fileread+0xa6>
    ilock(f->ip);
    80003c5e:	6d08                	ld	a0,24(a0)
    80003c60:	fffff097          	auipc	ra,0xfffff
    80003c64:	008080e7          	jalr	8(ra) # 80002c68 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c68:	874a                	mv	a4,s2
    80003c6a:	5094                	lw	a3,32(s1)
    80003c6c:	864e                	mv	a2,s3
    80003c6e:	4585                	li	a1,1
    80003c70:	6c88                	ld	a0,24(s1)
    80003c72:	fffff097          	auipc	ra,0xfffff
    80003c76:	2aa080e7          	jalr	682(ra) # 80002f1c <readi>
    80003c7a:	892a                	mv	s2,a0
    80003c7c:	00a05563          	blez	a0,80003c86 <fileread+0x56>
      f->off += r;
    80003c80:	509c                	lw	a5,32(s1)
    80003c82:	9fa9                	addw	a5,a5,a0
    80003c84:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c86:	6c88                	ld	a0,24(s1)
    80003c88:	fffff097          	auipc	ra,0xfffff
    80003c8c:	0a2080e7          	jalr	162(ra) # 80002d2a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c90:	854a                	mv	a0,s2
    80003c92:	70a2                	ld	ra,40(sp)
    80003c94:	7402                	ld	s0,32(sp)
    80003c96:	64e2                	ld	s1,24(sp)
    80003c98:	6942                	ld	s2,16(sp)
    80003c9a:	69a2                	ld	s3,8(sp)
    80003c9c:	6145                	addi	sp,sp,48
    80003c9e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ca0:	6908                	ld	a0,16(a0)
    80003ca2:	00000097          	auipc	ra,0x0
    80003ca6:	3ce080e7          	jalr	974(ra) # 80004070 <piperead>
    80003caa:	892a                	mv	s2,a0
    80003cac:	b7d5                	j	80003c90 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cae:	02451783          	lh	a5,36(a0)
    80003cb2:	03079693          	slli	a3,a5,0x30
    80003cb6:	92c1                	srli	a3,a3,0x30
    80003cb8:	4725                	li	a4,9
    80003cba:	02d76863          	bltu	a4,a3,80003cea <fileread+0xba>
    80003cbe:	0792                	slli	a5,a5,0x4
    80003cc0:	00015717          	auipc	a4,0x15
    80003cc4:	07870713          	addi	a4,a4,120 # 80018d38 <devsw>
    80003cc8:	97ba                	add	a5,a5,a4
    80003cca:	639c                	ld	a5,0(a5)
    80003ccc:	c38d                	beqz	a5,80003cee <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003cce:	4505                	li	a0,1
    80003cd0:	9782                	jalr	a5
    80003cd2:	892a                	mv	s2,a0
    80003cd4:	bf75                	j	80003c90 <fileread+0x60>
    panic("fileread");
    80003cd6:	00005517          	auipc	a0,0x5
    80003cda:	a6a50513          	addi	a0,a0,-1430 # 80008740 <syscalls+0x268>
    80003cde:	00002097          	auipc	ra,0x2
    80003ce2:	084080e7          	jalr	132(ra) # 80005d62 <panic>
    return -1;
    80003ce6:	597d                	li	s2,-1
    80003ce8:	b765                	j	80003c90 <fileread+0x60>
      return -1;
    80003cea:	597d                	li	s2,-1
    80003cec:	b755                	j	80003c90 <fileread+0x60>
    80003cee:	597d                	li	s2,-1
    80003cf0:	b745                	j	80003c90 <fileread+0x60>

0000000080003cf2 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003cf2:	715d                	addi	sp,sp,-80
    80003cf4:	e486                	sd	ra,72(sp)
    80003cf6:	e0a2                	sd	s0,64(sp)
    80003cf8:	fc26                	sd	s1,56(sp)
    80003cfa:	f84a                	sd	s2,48(sp)
    80003cfc:	f44e                	sd	s3,40(sp)
    80003cfe:	f052                	sd	s4,32(sp)
    80003d00:	ec56                	sd	s5,24(sp)
    80003d02:	e85a                	sd	s6,16(sp)
    80003d04:	e45e                	sd	s7,8(sp)
    80003d06:	e062                	sd	s8,0(sp)
    80003d08:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d0a:	00954783          	lbu	a5,9(a0)
    80003d0e:	10078663          	beqz	a5,80003e1a <filewrite+0x128>
    80003d12:	892a                	mv	s2,a0
    80003d14:	8aae                	mv	s5,a1
    80003d16:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d18:	411c                	lw	a5,0(a0)
    80003d1a:	4705                	li	a4,1
    80003d1c:	02e78263          	beq	a5,a4,80003d40 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d20:	470d                	li	a4,3
    80003d22:	02e78663          	beq	a5,a4,80003d4e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d26:	4709                	li	a4,2
    80003d28:	0ee79163          	bne	a5,a4,80003e0a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d2c:	0ac05d63          	blez	a2,80003de6 <filewrite+0xf4>
    int i = 0;
    80003d30:	4981                	li	s3,0
    80003d32:	6b05                	lui	s6,0x1
    80003d34:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d38:	6b85                	lui	s7,0x1
    80003d3a:	c00b8b9b          	addiw	s7,s7,-1024
    80003d3e:	a861                	j	80003dd6 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d40:	6908                	ld	a0,16(a0)
    80003d42:	00000097          	auipc	ra,0x0
    80003d46:	22e080e7          	jalr	558(ra) # 80003f70 <pipewrite>
    80003d4a:	8a2a                	mv	s4,a0
    80003d4c:	a045                	j	80003dec <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d4e:	02451783          	lh	a5,36(a0)
    80003d52:	03079693          	slli	a3,a5,0x30
    80003d56:	92c1                	srli	a3,a3,0x30
    80003d58:	4725                	li	a4,9
    80003d5a:	0cd76263          	bltu	a4,a3,80003e1e <filewrite+0x12c>
    80003d5e:	0792                	slli	a5,a5,0x4
    80003d60:	00015717          	auipc	a4,0x15
    80003d64:	fd870713          	addi	a4,a4,-40 # 80018d38 <devsw>
    80003d68:	97ba                	add	a5,a5,a4
    80003d6a:	679c                	ld	a5,8(a5)
    80003d6c:	cbdd                	beqz	a5,80003e22 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d6e:	4505                	li	a0,1
    80003d70:	9782                	jalr	a5
    80003d72:	8a2a                	mv	s4,a0
    80003d74:	a8a5                	j	80003dec <filewrite+0xfa>
    80003d76:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d7a:	00000097          	auipc	ra,0x0
    80003d7e:	8b0080e7          	jalr	-1872(ra) # 8000362a <begin_op>
      ilock(f->ip);
    80003d82:	01893503          	ld	a0,24(s2)
    80003d86:	fffff097          	auipc	ra,0xfffff
    80003d8a:	ee2080e7          	jalr	-286(ra) # 80002c68 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d8e:	8762                	mv	a4,s8
    80003d90:	02092683          	lw	a3,32(s2)
    80003d94:	01598633          	add	a2,s3,s5
    80003d98:	4585                	li	a1,1
    80003d9a:	01893503          	ld	a0,24(s2)
    80003d9e:	fffff097          	auipc	ra,0xfffff
    80003da2:	276080e7          	jalr	630(ra) # 80003014 <writei>
    80003da6:	84aa                	mv	s1,a0
    80003da8:	00a05763          	blez	a0,80003db6 <filewrite+0xc4>
        f->off += r;
    80003dac:	02092783          	lw	a5,32(s2)
    80003db0:	9fa9                	addw	a5,a5,a0
    80003db2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003db6:	01893503          	ld	a0,24(s2)
    80003dba:	fffff097          	auipc	ra,0xfffff
    80003dbe:	f70080e7          	jalr	-144(ra) # 80002d2a <iunlock>
      end_op();
    80003dc2:	00000097          	auipc	ra,0x0
    80003dc6:	8e8080e7          	jalr	-1816(ra) # 800036aa <end_op>

      if(r != n1){
    80003dca:	009c1f63          	bne	s8,s1,80003de8 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003dce:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dd2:	0149db63          	bge	s3,s4,80003de8 <filewrite+0xf6>
      int n1 = n - i;
    80003dd6:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003dda:	84be                	mv	s1,a5
    80003ddc:	2781                	sext.w	a5,a5
    80003dde:	f8fb5ce3          	bge	s6,a5,80003d76 <filewrite+0x84>
    80003de2:	84de                	mv	s1,s7
    80003de4:	bf49                	j	80003d76 <filewrite+0x84>
    int i = 0;
    80003de6:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003de8:	013a1f63          	bne	s4,s3,80003e06 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dec:	8552                	mv	a0,s4
    80003dee:	60a6                	ld	ra,72(sp)
    80003df0:	6406                	ld	s0,64(sp)
    80003df2:	74e2                	ld	s1,56(sp)
    80003df4:	7942                	ld	s2,48(sp)
    80003df6:	79a2                	ld	s3,40(sp)
    80003df8:	7a02                	ld	s4,32(sp)
    80003dfa:	6ae2                	ld	s5,24(sp)
    80003dfc:	6b42                	ld	s6,16(sp)
    80003dfe:	6ba2                	ld	s7,8(sp)
    80003e00:	6c02                	ld	s8,0(sp)
    80003e02:	6161                	addi	sp,sp,80
    80003e04:	8082                	ret
    ret = (i == n ? n : -1);
    80003e06:	5a7d                	li	s4,-1
    80003e08:	b7d5                	j	80003dec <filewrite+0xfa>
    panic("filewrite");
    80003e0a:	00005517          	auipc	a0,0x5
    80003e0e:	94650513          	addi	a0,a0,-1722 # 80008750 <syscalls+0x278>
    80003e12:	00002097          	auipc	ra,0x2
    80003e16:	f50080e7          	jalr	-176(ra) # 80005d62 <panic>
    return -1;
    80003e1a:	5a7d                	li	s4,-1
    80003e1c:	bfc1                	j	80003dec <filewrite+0xfa>
      return -1;
    80003e1e:	5a7d                	li	s4,-1
    80003e20:	b7f1                	j	80003dec <filewrite+0xfa>
    80003e22:	5a7d                	li	s4,-1
    80003e24:	b7e1                	j	80003dec <filewrite+0xfa>

0000000080003e26 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e26:	7179                	addi	sp,sp,-48
    80003e28:	f406                	sd	ra,40(sp)
    80003e2a:	f022                	sd	s0,32(sp)
    80003e2c:	ec26                	sd	s1,24(sp)
    80003e2e:	e84a                	sd	s2,16(sp)
    80003e30:	e44e                	sd	s3,8(sp)
    80003e32:	e052                	sd	s4,0(sp)
    80003e34:	1800                	addi	s0,sp,48
    80003e36:	84aa                	mv	s1,a0
    80003e38:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e3a:	0005b023          	sd	zero,0(a1)
    80003e3e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e42:	00000097          	auipc	ra,0x0
    80003e46:	bf8080e7          	jalr	-1032(ra) # 80003a3a <filealloc>
    80003e4a:	e088                	sd	a0,0(s1)
    80003e4c:	c551                	beqz	a0,80003ed8 <pipealloc+0xb2>
    80003e4e:	00000097          	auipc	ra,0x0
    80003e52:	bec080e7          	jalr	-1044(ra) # 80003a3a <filealloc>
    80003e56:	00aa3023          	sd	a0,0(s4)
    80003e5a:	c92d                	beqz	a0,80003ecc <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e5c:	ffffc097          	auipc	ra,0xffffc
    80003e60:	2bc080e7          	jalr	700(ra) # 80000118 <kalloc>
    80003e64:	892a                	mv	s2,a0
    80003e66:	c125                	beqz	a0,80003ec6 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e68:	4985                	li	s3,1
    80003e6a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e6e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e72:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e76:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e7a:	00004597          	auipc	a1,0x4
    80003e7e:	5ae58593          	addi	a1,a1,1454 # 80008428 <states.1725+0x1a0>
    80003e82:	00002097          	auipc	ra,0x2
    80003e86:	39a080e7          	jalr	922(ra) # 8000621c <initlock>
  (*f0)->type = FD_PIPE;
    80003e8a:	609c                	ld	a5,0(s1)
    80003e8c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e90:	609c                	ld	a5,0(s1)
    80003e92:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e96:	609c                	ld	a5,0(s1)
    80003e98:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e9c:	609c                	ld	a5,0(s1)
    80003e9e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ea2:	000a3783          	ld	a5,0(s4)
    80003ea6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003eaa:	000a3783          	ld	a5,0(s4)
    80003eae:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003eb2:	000a3783          	ld	a5,0(s4)
    80003eb6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003eba:	000a3783          	ld	a5,0(s4)
    80003ebe:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ec2:	4501                	li	a0,0
    80003ec4:	a025                	j	80003eec <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ec6:	6088                	ld	a0,0(s1)
    80003ec8:	e501                	bnez	a0,80003ed0 <pipealloc+0xaa>
    80003eca:	a039                	j	80003ed8 <pipealloc+0xb2>
    80003ecc:	6088                	ld	a0,0(s1)
    80003ece:	c51d                	beqz	a0,80003efc <pipealloc+0xd6>
    fileclose(*f0);
    80003ed0:	00000097          	auipc	ra,0x0
    80003ed4:	c26080e7          	jalr	-986(ra) # 80003af6 <fileclose>
  if(*f1)
    80003ed8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003edc:	557d                	li	a0,-1
  if(*f1)
    80003ede:	c799                	beqz	a5,80003eec <pipealloc+0xc6>
    fileclose(*f1);
    80003ee0:	853e                	mv	a0,a5
    80003ee2:	00000097          	auipc	ra,0x0
    80003ee6:	c14080e7          	jalr	-1004(ra) # 80003af6 <fileclose>
  return -1;
    80003eea:	557d                	li	a0,-1
}
    80003eec:	70a2                	ld	ra,40(sp)
    80003eee:	7402                	ld	s0,32(sp)
    80003ef0:	64e2                	ld	s1,24(sp)
    80003ef2:	6942                	ld	s2,16(sp)
    80003ef4:	69a2                	ld	s3,8(sp)
    80003ef6:	6a02                	ld	s4,0(sp)
    80003ef8:	6145                	addi	sp,sp,48
    80003efa:	8082                	ret
  return -1;
    80003efc:	557d                	li	a0,-1
    80003efe:	b7fd                	j	80003eec <pipealloc+0xc6>

0000000080003f00 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f00:	1101                	addi	sp,sp,-32
    80003f02:	ec06                	sd	ra,24(sp)
    80003f04:	e822                	sd	s0,16(sp)
    80003f06:	e426                	sd	s1,8(sp)
    80003f08:	e04a                	sd	s2,0(sp)
    80003f0a:	1000                	addi	s0,sp,32
    80003f0c:	84aa                	mv	s1,a0
    80003f0e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f10:	00002097          	auipc	ra,0x2
    80003f14:	39c080e7          	jalr	924(ra) # 800062ac <acquire>
  if(writable){
    80003f18:	02090d63          	beqz	s2,80003f52 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f1c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f20:	21848513          	addi	a0,s1,536
    80003f24:	ffffd097          	auipc	ra,0xffffd
    80003f28:	6c6080e7          	jalr	1734(ra) # 800015ea <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f2c:	2204b783          	ld	a5,544(s1)
    80003f30:	eb95                	bnez	a5,80003f64 <pipeclose+0x64>
    release(&pi->lock);
    80003f32:	8526                	mv	a0,s1
    80003f34:	00002097          	auipc	ra,0x2
    80003f38:	42c080e7          	jalr	1068(ra) # 80006360 <release>
    kfree((char*)pi);
    80003f3c:	8526                	mv	a0,s1
    80003f3e:	ffffc097          	auipc	ra,0xffffc
    80003f42:	0de080e7          	jalr	222(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f46:	60e2                	ld	ra,24(sp)
    80003f48:	6442                	ld	s0,16(sp)
    80003f4a:	64a2                	ld	s1,8(sp)
    80003f4c:	6902                	ld	s2,0(sp)
    80003f4e:	6105                	addi	sp,sp,32
    80003f50:	8082                	ret
    pi->readopen = 0;
    80003f52:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f56:	21c48513          	addi	a0,s1,540
    80003f5a:	ffffd097          	auipc	ra,0xffffd
    80003f5e:	690080e7          	jalr	1680(ra) # 800015ea <wakeup>
    80003f62:	b7e9                	j	80003f2c <pipeclose+0x2c>
    release(&pi->lock);
    80003f64:	8526                	mv	a0,s1
    80003f66:	00002097          	auipc	ra,0x2
    80003f6a:	3fa080e7          	jalr	1018(ra) # 80006360 <release>
}
    80003f6e:	bfe1                	j	80003f46 <pipeclose+0x46>

0000000080003f70 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f70:	7159                	addi	sp,sp,-112
    80003f72:	f486                	sd	ra,104(sp)
    80003f74:	f0a2                	sd	s0,96(sp)
    80003f76:	eca6                	sd	s1,88(sp)
    80003f78:	e8ca                	sd	s2,80(sp)
    80003f7a:	e4ce                	sd	s3,72(sp)
    80003f7c:	e0d2                	sd	s4,64(sp)
    80003f7e:	fc56                	sd	s5,56(sp)
    80003f80:	f85a                	sd	s6,48(sp)
    80003f82:	f45e                	sd	s7,40(sp)
    80003f84:	f062                	sd	s8,32(sp)
    80003f86:	ec66                	sd	s9,24(sp)
    80003f88:	1880                	addi	s0,sp,112
    80003f8a:	84aa                	mv	s1,a0
    80003f8c:	8aae                	mv	s5,a1
    80003f8e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f90:	ffffd097          	auipc	ra,0xffffd
    80003f94:	f46080e7          	jalr	-186(ra) # 80000ed6 <myproc>
    80003f98:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f9a:	8526                	mv	a0,s1
    80003f9c:	00002097          	auipc	ra,0x2
    80003fa0:	310080e7          	jalr	784(ra) # 800062ac <acquire>
  while(i < n){
    80003fa4:	0d405463          	blez	s4,8000406c <pipewrite+0xfc>
    80003fa8:	8ba6                	mv	s7,s1
  int i = 0;
    80003faa:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fac:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fae:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fb2:	21c48c13          	addi	s8,s1,540
    80003fb6:	a08d                	j	80004018 <pipewrite+0xa8>
      release(&pi->lock);
    80003fb8:	8526                	mv	a0,s1
    80003fba:	00002097          	auipc	ra,0x2
    80003fbe:	3a6080e7          	jalr	934(ra) # 80006360 <release>
      return -1;
    80003fc2:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fc4:	854a                	mv	a0,s2
    80003fc6:	70a6                	ld	ra,104(sp)
    80003fc8:	7406                	ld	s0,96(sp)
    80003fca:	64e6                	ld	s1,88(sp)
    80003fcc:	6946                	ld	s2,80(sp)
    80003fce:	69a6                	ld	s3,72(sp)
    80003fd0:	6a06                	ld	s4,64(sp)
    80003fd2:	7ae2                	ld	s5,56(sp)
    80003fd4:	7b42                	ld	s6,48(sp)
    80003fd6:	7ba2                	ld	s7,40(sp)
    80003fd8:	7c02                	ld	s8,32(sp)
    80003fda:	6ce2                	ld	s9,24(sp)
    80003fdc:	6165                	addi	sp,sp,112
    80003fde:	8082                	ret
      wakeup(&pi->nread);
    80003fe0:	8566                	mv	a0,s9
    80003fe2:	ffffd097          	auipc	ra,0xffffd
    80003fe6:	608080e7          	jalr	1544(ra) # 800015ea <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fea:	85de                	mv	a1,s7
    80003fec:	8562                	mv	a0,s8
    80003fee:	ffffd097          	auipc	ra,0xffffd
    80003ff2:	598080e7          	jalr	1432(ra) # 80001586 <sleep>
    80003ff6:	a839                	j	80004014 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ff8:	21c4a783          	lw	a5,540(s1)
    80003ffc:	0017871b          	addiw	a4,a5,1
    80004000:	20e4ae23          	sw	a4,540(s1)
    80004004:	1ff7f793          	andi	a5,a5,511
    80004008:	97a6                	add	a5,a5,s1
    8000400a:	f9f44703          	lbu	a4,-97(s0)
    8000400e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004012:	2905                	addiw	s2,s2,1
  while(i < n){
    80004014:	05495063          	bge	s2,s4,80004054 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80004018:	2204a783          	lw	a5,544(s1)
    8000401c:	dfd1                	beqz	a5,80003fb8 <pipewrite+0x48>
    8000401e:	854e                	mv	a0,s3
    80004020:	ffffe097          	auipc	ra,0xffffe
    80004024:	80e080e7          	jalr	-2034(ra) # 8000182e <killed>
    80004028:	f941                	bnez	a0,80003fb8 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000402a:	2184a783          	lw	a5,536(s1)
    8000402e:	21c4a703          	lw	a4,540(s1)
    80004032:	2007879b          	addiw	a5,a5,512
    80004036:	faf705e3          	beq	a4,a5,80003fe0 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000403a:	4685                	li	a3,1
    8000403c:	01590633          	add	a2,s2,s5
    80004040:	f9f40593          	addi	a1,s0,-97
    80004044:	0509b503          	ld	a0,80(s3)
    80004048:	ffffd097          	auipc	ra,0xffffd
    8000404c:	bd8080e7          	jalr	-1064(ra) # 80000c20 <copyin>
    80004050:	fb6514e3          	bne	a0,s6,80003ff8 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004054:	21848513          	addi	a0,s1,536
    80004058:	ffffd097          	auipc	ra,0xffffd
    8000405c:	592080e7          	jalr	1426(ra) # 800015ea <wakeup>
  release(&pi->lock);
    80004060:	8526                	mv	a0,s1
    80004062:	00002097          	auipc	ra,0x2
    80004066:	2fe080e7          	jalr	766(ra) # 80006360 <release>
  return i;
    8000406a:	bfa9                	j	80003fc4 <pipewrite+0x54>
  int i = 0;
    8000406c:	4901                	li	s2,0
    8000406e:	b7dd                	j	80004054 <pipewrite+0xe4>

0000000080004070 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004070:	715d                	addi	sp,sp,-80
    80004072:	e486                	sd	ra,72(sp)
    80004074:	e0a2                	sd	s0,64(sp)
    80004076:	fc26                	sd	s1,56(sp)
    80004078:	f84a                	sd	s2,48(sp)
    8000407a:	f44e                	sd	s3,40(sp)
    8000407c:	f052                	sd	s4,32(sp)
    8000407e:	ec56                	sd	s5,24(sp)
    80004080:	e85a                	sd	s6,16(sp)
    80004082:	0880                	addi	s0,sp,80
    80004084:	84aa                	mv	s1,a0
    80004086:	892e                	mv	s2,a1
    80004088:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000408a:	ffffd097          	auipc	ra,0xffffd
    8000408e:	e4c080e7          	jalr	-436(ra) # 80000ed6 <myproc>
    80004092:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004094:	8b26                	mv	s6,s1
    80004096:	8526                	mv	a0,s1
    80004098:	00002097          	auipc	ra,0x2
    8000409c:	214080e7          	jalr	532(ra) # 800062ac <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040a0:	2184a703          	lw	a4,536(s1)
    800040a4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040a8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ac:	02f71763          	bne	a4,a5,800040da <piperead+0x6a>
    800040b0:	2244a783          	lw	a5,548(s1)
    800040b4:	c39d                	beqz	a5,800040da <piperead+0x6a>
    if(killed(pr)){
    800040b6:	8552                	mv	a0,s4
    800040b8:	ffffd097          	auipc	ra,0xffffd
    800040bc:	776080e7          	jalr	1910(ra) # 8000182e <killed>
    800040c0:	e941                	bnez	a0,80004150 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040c2:	85da                	mv	a1,s6
    800040c4:	854e                	mv	a0,s3
    800040c6:	ffffd097          	auipc	ra,0xffffd
    800040ca:	4c0080e7          	jalr	1216(ra) # 80001586 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ce:	2184a703          	lw	a4,536(s1)
    800040d2:	21c4a783          	lw	a5,540(s1)
    800040d6:	fcf70de3          	beq	a4,a5,800040b0 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040da:	09505263          	blez	s5,8000415e <piperead+0xee>
    800040de:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040e0:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040e2:	2184a783          	lw	a5,536(s1)
    800040e6:	21c4a703          	lw	a4,540(s1)
    800040ea:	02f70d63          	beq	a4,a5,80004124 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040ee:	0017871b          	addiw	a4,a5,1
    800040f2:	20e4ac23          	sw	a4,536(s1)
    800040f6:	1ff7f793          	andi	a5,a5,511
    800040fa:	97a6                	add	a5,a5,s1
    800040fc:	0187c783          	lbu	a5,24(a5)
    80004100:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004104:	4685                	li	a3,1
    80004106:	fbf40613          	addi	a2,s0,-65
    8000410a:	85ca                	mv	a1,s2
    8000410c:	050a3503          	ld	a0,80(s4)
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	a50080e7          	jalr	-1456(ra) # 80000b60 <copyout>
    80004118:	01650663          	beq	a0,s6,80004124 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000411c:	2985                	addiw	s3,s3,1
    8000411e:	0905                	addi	s2,s2,1
    80004120:	fd3a91e3          	bne	s5,s3,800040e2 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004124:	21c48513          	addi	a0,s1,540
    80004128:	ffffd097          	auipc	ra,0xffffd
    8000412c:	4c2080e7          	jalr	1218(ra) # 800015ea <wakeup>
  release(&pi->lock);
    80004130:	8526                	mv	a0,s1
    80004132:	00002097          	auipc	ra,0x2
    80004136:	22e080e7          	jalr	558(ra) # 80006360 <release>
  return i;
}
    8000413a:	854e                	mv	a0,s3
    8000413c:	60a6                	ld	ra,72(sp)
    8000413e:	6406                	ld	s0,64(sp)
    80004140:	74e2                	ld	s1,56(sp)
    80004142:	7942                	ld	s2,48(sp)
    80004144:	79a2                	ld	s3,40(sp)
    80004146:	7a02                	ld	s4,32(sp)
    80004148:	6ae2                	ld	s5,24(sp)
    8000414a:	6b42                	ld	s6,16(sp)
    8000414c:	6161                	addi	sp,sp,80
    8000414e:	8082                	ret
      release(&pi->lock);
    80004150:	8526                	mv	a0,s1
    80004152:	00002097          	auipc	ra,0x2
    80004156:	20e080e7          	jalr	526(ra) # 80006360 <release>
      return -1;
    8000415a:	59fd                	li	s3,-1
    8000415c:	bff9                	j	8000413a <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000415e:	4981                	li	s3,0
    80004160:	b7d1                	j	80004124 <piperead+0xb4>

0000000080004162 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004162:	1141                	addi	sp,sp,-16
    80004164:	e422                	sd	s0,8(sp)
    80004166:	0800                	addi	s0,sp,16
    80004168:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000416a:	8905                	andi	a0,a0,1
    8000416c:	c111                	beqz	a0,80004170 <flags2perm+0xe>
      perm = PTE_X;
    8000416e:	4521                	li	a0,8
    if(flags & 0x2)
    80004170:	8b89                	andi	a5,a5,2
    80004172:	c399                	beqz	a5,80004178 <flags2perm+0x16>
      perm |= PTE_W;
    80004174:	00456513          	ori	a0,a0,4
    return perm;
}
    80004178:	6422                	ld	s0,8(sp)
    8000417a:	0141                	addi	sp,sp,16
    8000417c:	8082                	ret

000000008000417e <exec>:

int
exec(char *path, char **argv)
{
    8000417e:	df010113          	addi	sp,sp,-528
    80004182:	20113423          	sd	ra,520(sp)
    80004186:	20813023          	sd	s0,512(sp)
    8000418a:	ffa6                	sd	s1,504(sp)
    8000418c:	fbca                	sd	s2,496(sp)
    8000418e:	f7ce                	sd	s3,488(sp)
    80004190:	f3d2                	sd	s4,480(sp)
    80004192:	efd6                	sd	s5,472(sp)
    80004194:	ebda                	sd	s6,464(sp)
    80004196:	e7de                	sd	s7,456(sp)
    80004198:	e3e2                	sd	s8,448(sp)
    8000419a:	ff66                	sd	s9,440(sp)
    8000419c:	fb6a                	sd	s10,432(sp)
    8000419e:	f76e                	sd	s11,424(sp)
    800041a0:	0c00                	addi	s0,sp,528
    800041a2:	84aa                	mv	s1,a0
    800041a4:	dea43c23          	sd	a0,-520(s0)
    800041a8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041ac:	ffffd097          	auipc	ra,0xffffd
    800041b0:	d2a080e7          	jalr	-726(ra) # 80000ed6 <myproc>
    800041b4:	892a                	mv	s2,a0

  begin_op();
    800041b6:	fffff097          	auipc	ra,0xfffff
    800041ba:	474080e7          	jalr	1140(ra) # 8000362a <begin_op>

  if((ip = namei(path)) == 0){
    800041be:	8526                	mv	a0,s1
    800041c0:	fffff097          	auipc	ra,0xfffff
    800041c4:	24e080e7          	jalr	590(ra) # 8000340e <namei>
    800041c8:	c92d                	beqz	a0,8000423a <exec+0xbc>
    800041ca:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041cc:	fffff097          	auipc	ra,0xfffff
    800041d0:	a9c080e7          	jalr	-1380(ra) # 80002c68 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041d4:	04000713          	li	a4,64
    800041d8:	4681                	li	a3,0
    800041da:	e5040613          	addi	a2,s0,-432
    800041de:	4581                	li	a1,0
    800041e0:	8526                	mv	a0,s1
    800041e2:	fffff097          	auipc	ra,0xfffff
    800041e6:	d3a080e7          	jalr	-710(ra) # 80002f1c <readi>
    800041ea:	04000793          	li	a5,64
    800041ee:	00f51a63          	bne	a0,a5,80004202 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041f2:	e5042703          	lw	a4,-432(s0)
    800041f6:	464c47b7          	lui	a5,0x464c4
    800041fa:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041fe:	04f70463          	beq	a4,a5,80004246 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004202:	8526                	mv	a0,s1
    80004204:	fffff097          	auipc	ra,0xfffff
    80004208:	cc6080e7          	jalr	-826(ra) # 80002eca <iunlockput>
    end_op();
    8000420c:	fffff097          	auipc	ra,0xfffff
    80004210:	49e080e7          	jalr	1182(ra) # 800036aa <end_op>
  }
  return -1;
    80004214:	557d                	li	a0,-1
}
    80004216:	20813083          	ld	ra,520(sp)
    8000421a:	20013403          	ld	s0,512(sp)
    8000421e:	74fe                	ld	s1,504(sp)
    80004220:	795e                	ld	s2,496(sp)
    80004222:	79be                	ld	s3,488(sp)
    80004224:	7a1e                	ld	s4,480(sp)
    80004226:	6afe                	ld	s5,472(sp)
    80004228:	6b5e                	ld	s6,464(sp)
    8000422a:	6bbe                	ld	s7,456(sp)
    8000422c:	6c1e                	ld	s8,448(sp)
    8000422e:	7cfa                	ld	s9,440(sp)
    80004230:	7d5a                	ld	s10,432(sp)
    80004232:	7dba                	ld	s11,424(sp)
    80004234:	21010113          	addi	sp,sp,528
    80004238:	8082                	ret
    end_op();
    8000423a:	fffff097          	auipc	ra,0xfffff
    8000423e:	470080e7          	jalr	1136(ra) # 800036aa <end_op>
    return -1;
    80004242:	557d                	li	a0,-1
    80004244:	bfc9                	j	80004216 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004246:	854a                	mv	a0,s2
    80004248:	ffffd097          	auipc	ra,0xffffd
    8000424c:	d56080e7          	jalr	-682(ra) # 80000f9e <proc_pagetable>
    80004250:	8baa                	mv	s7,a0
    80004252:	d945                	beqz	a0,80004202 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004254:	e7042983          	lw	s3,-400(s0)
    80004258:	e8845783          	lhu	a5,-376(s0)
    8000425c:	c7ad                	beqz	a5,800042c6 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000425e:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004260:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004262:	6c85                	lui	s9,0x1
    80004264:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004268:	def43823          	sd	a5,-528(s0)
    8000426c:	ac0d                	j	8000449e <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000426e:	00004517          	auipc	a0,0x4
    80004272:	4f250513          	addi	a0,a0,1266 # 80008760 <syscalls+0x288>
    80004276:	00002097          	auipc	ra,0x2
    8000427a:	aec080e7          	jalr	-1300(ra) # 80005d62 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000427e:	8756                	mv	a4,s5
    80004280:	012d86bb          	addw	a3,s11,s2
    80004284:	4581                	li	a1,0
    80004286:	8526                	mv	a0,s1
    80004288:	fffff097          	auipc	ra,0xfffff
    8000428c:	c94080e7          	jalr	-876(ra) # 80002f1c <readi>
    80004290:	2501                	sext.w	a0,a0
    80004292:	1aaa9a63          	bne	s5,a0,80004446 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    80004296:	6785                	lui	a5,0x1
    80004298:	0127893b          	addw	s2,a5,s2
    8000429c:	77fd                	lui	a5,0xfffff
    8000429e:	01478a3b          	addw	s4,a5,s4
    800042a2:	1f897563          	bgeu	s2,s8,8000448c <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    800042a6:	02091593          	slli	a1,s2,0x20
    800042aa:	9181                	srli	a1,a1,0x20
    800042ac:	95ea                	add	a1,a1,s10
    800042ae:	855e                	mv	a0,s7
    800042b0:	ffffc097          	auipc	ra,0xffffc
    800042b4:	280080e7          	jalr	640(ra) # 80000530 <walkaddr>
    800042b8:	862a                	mv	a2,a0
    if(pa == 0)
    800042ba:	d955                	beqz	a0,8000426e <exec+0xf0>
      n = PGSIZE;
    800042bc:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042be:	fd9a70e3          	bgeu	s4,s9,8000427e <exec+0x100>
      n = sz - i;
    800042c2:	8ad2                	mv	s5,s4
    800042c4:	bf6d                	j	8000427e <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042c6:	4a01                	li	s4,0
  iunlockput(ip);
    800042c8:	8526                	mv	a0,s1
    800042ca:	fffff097          	auipc	ra,0xfffff
    800042ce:	c00080e7          	jalr	-1024(ra) # 80002eca <iunlockput>
  end_op();
    800042d2:	fffff097          	auipc	ra,0xfffff
    800042d6:	3d8080e7          	jalr	984(ra) # 800036aa <end_op>
  p = myproc();
    800042da:	ffffd097          	auipc	ra,0xffffd
    800042de:	bfc080e7          	jalr	-1028(ra) # 80000ed6 <myproc>
    800042e2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042e4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042e8:	6785                	lui	a5,0x1
    800042ea:	17fd                	addi	a5,a5,-1
    800042ec:	9a3e                	add	s4,s4,a5
    800042ee:	757d                	lui	a0,0xfffff
    800042f0:	00aa77b3          	and	a5,s4,a0
    800042f4:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042f8:	4691                	li	a3,4
    800042fa:	6609                	lui	a2,0x2
    800042fc:	963e                	add	a2,a2,a5
    800042fe:	85be                	mv	a1,a5
    80004300:	855e                	mv	a0,s7
    80004302:	ffffc097          	auipc	ra,0xffffc
    80004306:	606080e7          	jalr	1542(ra) # 80000908 <uvmalloc>
    8000430a:	8b2a                	mv	s6,a0
  ip = 0;
    8000430c:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000430e:	12050c63          	beqz	a0,80004446 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004312:	75f9                	lui	a1,0xffffe
    80004314:	95aa                	add	a1,a1,a0
    80004316:	855e                	mv	a0,s7
    80004318:	ffffd097          	auipc	ra,0xffffd
    8000431c:	816080e7          	jalr	-2026(ra) # 80000b2e <uvmclear>
  stackbase = sp - PGSIZE;
    80004320:	7c7d                	lui	s8,0xfffff
    80004322:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004324:	e0043783          	ld	a5,-512(s0)
    80004328:	6388                	ld	a0,0(a5)
    8000432a:	c535                	beqz	a0,80004396 <exec+0x218>
    8000432c:	e9040993          	addi	s3,s0,-368
    80004330:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004334:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004336:	ffffc097          	auipc	ra,0xffffc
    8000433a:	fec080e7          	jalr	-20(ra) # 80000322 <strlen>
    8000433e:	2505                	addiw	a0,a0,1
    80004340:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004344:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004348:	13896663          	bltu	s2,s8,80004474 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000434c:	e0043d83          	ld	s11,-512(s0)
    80004350:	000dba03          	ld	s4,0(s11)
    80004354:	8552                	mv	a0,s4
    80004356:	ffffc097          	auipc	ra,0xffffc
    8000435a:	fcc080e7          	jalr	-52(ra) # 80000322 <strlen>
    8000435e:	0015069b          	addiw	a3,a0,1
    80004362:	8652                	mv	a2,s4
    80004364:	85ca                	mv	a1,s2
    80004366:	855e                	mv	a0,s7
    80004368:	ffffc097          	auipc	ra,0xffffc
    8000436c:	7f8080e7          	jalr	2040(ra) # 80000b60 <copyout>
    80004370:	10054663          	bltz	a0,8000447c <exec+0x2fe>
    ustack[argc] = sp;
    80004374:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004378:	0485                	addi	s1,s1,1
    8000437a:	008d8793          	addi	a5,s11,8
    8000437e:	e0f43023          	sd	a5,-512(s0)
    80004382:	008db503          	ld	a0,8(s11)
    80004386:	c911                	beqz	a0,8000439a <exec+0x21c>
    if(argc >= MAXARG)
    80004388:	09a1                	addi	s3,s3,8
    8000438a:	fb3c96e3          	bne	s9,s3,80004336 <exec+0x1b8>
  sz = sz1;
    8000438e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004392:	4481                	li	s1,0
    80004394:	a84d                	j	80004446 <exec+0x2c8>
  sp = sz;
    80004396:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004398:	4481                	li	s1,0
  ustack[argc] = 0;
    8000439a:	00349793          	slli	a5,s1,0x3
    8000439e:	f9040713          	addi	a4,s0,-112
    800043a2:	97ba                	add	a5,a5,a4
    800043a4:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043a8:	00148693          	addi	a3,s1,1
    800043ac:	068e                	slli	a3,a3,0x3
    800043ae:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043b2:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043b6:	01897663          	bgeu	s2,s8,800043c2 <exec+0x244>
  sz = sz1;
    800043ba:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043be:	4481                	li	s1,0
    800043c0:	a059                	j	80004446 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043c2:	e9040613          	addi	a2,s0,-368
    800043c6:	85ca                	mv	a1,s2
    800043c8:	855e                	mv	a0,s7
    800043ca:	ffffc097          	auipc	ra,0xffffc
    800043ce:	796080e7          	jalr	1942(ra) # 80000b60 <copyout>
    800043d2:	0a054963          	bltz	a0,80004484 <exec+0x306>
  p->trapframe->a1 = sp;
    800043d6:	058ab783          	ld	a5,88(s5)
    800043da:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043de:	df843783          	ld	a5,-520(s0)
    800043e2:	0007c703          	lbu	a4,0(a5)
    800043e6:	cf11                	beqz	a4,80004402 <exec+0x284>
    800043e8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043ea:	02f00693          	li	a3,47
    800043ee:	a039                	j	800043fc <exec+0x27e>
      last = s+1;
    800043f0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043f4:	0785                	addi	a5,a5,1
    800043f6:	fff7c703          	lbu	a4,-1(a5)
    800043fa:	c701                	beqz	a4,80004402 <exec+0x284>
    if(*s == '/')
    800043fc:	fed71ce3          	bne	a4,a3,800043f4 <exec+0x276>
    80004400:	bfc5                	j	800043f0 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004402:	4641                	li	a2,16
    80004404:	df843583          	ld	a1,-520(s0)
    80004408:	158a8513          	addi	a0,s5,344
    8000440c:	ffffc097          	auipc	ra,0xffffc
    80004410:	ee4080e7          	jalr	-284(ra) # 800002f0 <safestrcpy>
  oldpagetable = p->pagetable;
    80004414:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004418:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000441c:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004420:	058ab783          	ld	a5,88(s5)
    80004424:	e6843703          	ld	a4,-408(s0)
    80004428:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000442a:	058ab783          	ld	a5,88(s5)
    8000442e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004432:	85ea                	mv	a1,s10
    80004434:	ffffd097          	auipc	ra,0xffffd
    80004438:	c06080e7          	jalr	-1018(ra) # 8000103a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000443c:	0004851b          	sext.w	a0,s1
    80004440:	bbd9                	j	80004216 <exec+0x98>
    80004442:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004446:	e0843583          	ld	a1,-504(s0)
    8000444a:	855e                	mv	a0,s7
    8000444c:	ffffd097          	auipc	ra,0xffffd
    80004450:	bee080e7          	jalr	-1042(ra) # 8000103a <proc_freepagetable>
  if(ip){
    80004454:	da0497e3          	bnez	s1,80004202 <exec+0x84>
  return -1;
    80004458:	557d                	li	a0,-1
    8000445a:	bb75                	j	80004216 <exec+0x98>
    8000445c:	e1443423          	sd	s4,-504(s0)
    80004460:	b7dd                	j	80004446 <exec+0x2c8>
    80004462:	e1443423          	sd	s4,-504(s0)
    80004466:	b7c5                	j	80004446 <exec+0x2c8>
    80004468:	e1443423          	sd	s4,-504(s0)
    8000446c:	bfe9                	j	80004446 <exec+0x2c8>
    8000446e:	e1443423          	sd	s4,-504(s0)
    80004472:	bfd1                	j	80004446 <exec+0x2c8>
  sz = sz1;
    80004474:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004478:	4481                	li	s1,0
    8000447a:	b7f1                	j	80004446 <exec+0x2c8>
  sz = sz1;
    8000447c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004480:	4481                	li	s1,0
    80004482:	b7d1                	j	80004446 <exec+0x2c8>
  sz = sz1;
    80004484:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004488:	4481                	li	s1,0
    8000448a:	bf75                	j	80004446 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000448c:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004490:	2b05                	addiw	s6,s6,1
    80004492:	0389899b          	addiw	s3,s3,56
    80004496:	e8845783          	lhu	a5,-376(s0)
    8000449a:	e2fb57e3          	bge	s6,a5,800042c8 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000449e:	2981                	sext.w	s3,s3
    800044a0:	03800713          	li	a4,56
    800044a4:	86ce                	mv	a3,s3
    800044a6:	e1840613          	addi	a2,s0,-488
    800044aa:	4581                	li	a1,0
    800044ac:	8526                	mv	a0,s1
    800044ae:	fffff097          	auipc	ra,0xfffff
    800044b2:	a6e080e7          	jalr	-1426(ra) # 80002f1c <readi>
    800044b6:	03800793          	li	a5,56
    800044ba:	f8f514e3          	bne	a0,a5,80004442 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    800044be:	e1842783          	lw	a5,-488(s0)
    800044c2:	4705                	li	a4,1
    800044c4:	fce796e3          	bne	a5,a4,80004490 <exec+0x312>
    if(ph.memsz < ph.filesz)
    800044c8:	e4043903          	ld	s2,-448(s0)
    800044cc:	e3843783          	ld	a5,-456(s0)
    800044d0:	f8f966e3          	bltu	s2,a5,8000445c <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044d4:	e2843783          	ld	a5,-472(s0)
    800044d8:	993e                	add	s2,s2,a5
    800044da:	f8f964e3          	bltu	s2,a5,80004462 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800044de:	df043703          	ld	a4,-528(s0)
    800044e2:	8ff9                	and	a5,a5,a4
    800044e4:	f3d1                	bnez	a5,80004468 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044e6:	e1c42503          	lw	a0,-484(s0)
    800044ea:	00000097          	auipc	ra,0x0
    800044ee:	c78080e7          	jalr	-904(ra) # 80004162 <flags2perm>
    800044f2:	86aa                	mv	a3,a0
    800044f4:	864a                	mv	a2,s2
    800044f6:	85d2                	mv	a1,s4
    800044f8:	855e                	mv	a0,s7
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	40e080e7          	jalr	1038(ra) # 80000908 <uvmalloc>
    80004502:	e0a43423          	sd	a0,-504(s0)
    80004506:	d525                	beqz	a0,8000446e <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004508:	e2843d03          	ld	s10,-472(s0)
    8000450c:	e2042d83          	lw	s11,-480(s0)
    80004510:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004514:	f60c0ce3          	beqz	s8,8000448c <exec+0x30e>
    80004518:	8a62                	mv	s4,s8
    8000451a:	4901                	li	s2,0
    8000451c:	b369                	j	800042a6 <exec+0x128>

000000008000451e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000451e:	7179                	addi	sp,sp,-48
    80004520:	f406                	sd	ra,40(sp)
    80004522:	f022                	sd	s0,32(sp)
    80004524:	ec26                	sd	s1,24(sp)
    80004526:	e84a                	sd	s2,16(sp)
    80004528:	1800                	addi	s0,sp,48
    8000452a:	892e                	mv	s2,a1
    8000452c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000452e:	fdc40593          	addi	a1,s0,-36
    80004532:	ffffe097          	auipc	ra,0xffffe
    80004536:	af0080e7          	jalr	-1296(ra) # 80002022 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000453a:	fdc42703          	lw	a4,-36(s0)
    8000453e:	47bd                	li	a5,15
    80004540:	02e7eb63          	bltu	a5,a4,80004576 <argfd+0x58>
    80004544:	ffffd097          	auipc	ra,0xffffd
    80004548:	992080e7          	jalr	-1646(ra) # 80000ed6 <myproc>
    8000454c:	fdc42703          	lw	a4,-36(s0)
    80004550:	01a70793          	addi	a5,a4,26
    80004554:	078e                	slli	a5,a5,0x3
    80004556:	953e                	add	a0,a0,a5
    80004558:	611c                	ld	a5,0(a0)
    8000455a:	c385                	beqz	a5,8000457a <argfd+0x5c>
    return -1;
  if(pfd)
    8000455c:	00090463          	beqz	s2,80004564 <argfd+0x46>
    *pfd = fd;
    80004560:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004564:	4501                	li	a0,0
  if(pf)
    80004566:	c091                	beqz	s1,8000456a <argfd+0x4c>
    *pf = f;
    80004568:	e09c                	sd	a5,0(s1)
}
    8000456a:	70a2                	ld	ra,40(sp)
    8000456c:	7402                	ld	s0,32(sp)
    8000456e:	64e2                	ld	s1,24(sp)
    80004570:	6942                	ld	s2,16(sp)
    80004572:	6145                	addi	sp,sp,48
    80004574:	8082                	ret
    return -1;
    80004576:	557d                	li	a0,-1
    80004578:	bfcd                	j	8000456a <argfd+0x4c>
    8000457a:	557d                	li	a0,-1
    8000457c:	b7fd                	j	8000456a <argfd+0x4c>

000000008000457e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000457e:	1101                	addi	sp,sp,-32
    80004580:	ec06                	sd	ra,24(sp)
    80004582:	e822                	sd	s0,16(sp)
    80004584:	e426                	sd	s1,8(sp)
    80004586:	1000                	addi	s0,sp,32
    80004588:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000458a:	ffffd097          	auipc	ra,0xffffd
    8000458e:	94c080e7          	jalr	-1716(ra) # 80000ed6 <myproc>
    80004592:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004594:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdcfc0>
    80004598:	4501                	li	a0,0
    8000459a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000459c:	6398                	ld	a4,0(a5)
    8000459e:	cb19                	beqz	a4,800045b4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045a0:	2505                	addiw	a0,a0,1
    800045a2:	07a1                	addi	a5,a5,8
    800045a4:	fed51ce3          	bne	a0,a3,8000459c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045a8:	557d                	li	a0,-1
}
    800045aa:	60e2                	ld	ra,24(sp)
    800045ac:	6442                	ld	s0,16(sp)
    800045ae:	64a2                	ld	s1,8(sp)
    800045b0:	6105                	addi	sp,sp,32
    800045b2:	8082                	ret
      p->ofile[fd] = f;
    800045b4:	01a50793          	addi	a5,a0,26
    800045b8:	078e                	slli	a5,a5,0x3
    800045ba:	963e                	add	a2,a2,a5
    800045bc:	e204                	sd	s1,0(a2)
      return fd;
    800045be:	b7f5                	j	800045aa <fdalloc+0x2c>

00000000800045c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045c0:	715d                	addi	sp,sp,-80
    800045c2:	e486                	sd	ra,72(sp)
    800045c4:	e0a2                	sd	s0,64(sp)
    800045c6:	fc26                	sd	s1,56(sp)
    800045c8:	f84a                	sd	s2,48(sp)
    800045ca:	f44e                	sd	s3,40(sp)
    800045cc:	f052                	sd	s4,32(sp)
    800045ce:	ec56                	sd	s5,24(sp)
    800045d0:	e85a                	sd	s6,16(sp)
    800045d2:	0880                	addi	s0,sp,80
    800045d4:	8b2e                	mv	s6,a1
    800045d6:	89b2                	mv	s3,a2
    800045d8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045da:	fb040593          	addi	a1,s0,-80
    800045de:	fffff097          	auipc	ra,0xfffff
    800045e2:	e4e080e7          	jalr	-434(ra) # 8000342c <nameiparent>
    800045e6:	84aa                	mv	s1,a0
    800045e8:	16050063          	beqz	a0,80004748 <create+0x188>
    return 0;

  ilock(dp);
    800045ec:	ffffe097          	auipc	ra,0xffffe
    800045f0:	67c080e7          	jalr	1660(ra) # 80002c68 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045f4:	4601                	li	a2,0
    800045f6:	fb040593          	addi	a1,s0,-80
    800045fa:	8526                	mv	a0,s1
    800045fc:	fffff097          	auipc	ra,0xfffff
    80004600:	b50080e7          	jalr	-1200(ra) # 8000314c <dirlookup>
    80004604:	8aaa                	mv	s5,a0
    80004606:	c931                	beqz	a0,8000465a <create+0x9a>
    iunlockput(dp);
    80004608:	8526                	mv	a0,s1
    8000460a:	fffff097          	auipc	ra,0xfffff
    8000460e:	8c0080e7          	jalr	-1856(ra) # 80002eca <iunlockput>
    ilock(ip);
    80004612:	8556                	mv	a0,s5
    80004614:	ffffe097          	auipc	ra,0xffffe
    80004618:	654080e7          	jalr	1620(ra) # 80002c68 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000461c:	000b059b          	sext.w	a1,s6
    80004620:	4789                	li	a5,2
    80004622:	02f59563          	bne	a1,a5,8000464c <create+0x8c>
    80004626:	044ad783          	lhu	a5,68(s5)
    8000462a:	37f9                	addiw	a5,a5,-2
    8000462c:	17c2                	slli	a5,a5,0x30
    8000462e:	93c1                	srli	a5,a5,0x30
    80004630:	4705                	li	a4,1
    80004632:	00f76d63          	bltu	a4,a5,8000464c <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004636:	8556                	mv	a0,s5
    80004638:	60a6                	ld	ra,72(sp)
    8000463a:	6406                	ld	s0,64(sp)
    8000463c:	74e2                	ld	s1,56(sp)
    8000463e:	7942                	ld	s2,48(sp)
    80004640:	79a2                	ld	s3,40(sp)
    80004642:	7a02                	ld	s4,32(sp)
    80004644:	6ae2                	ld	s5,24(sp)
    80004646:	6b42                	ld	s6,16(sp)
    80004648:	6161                	addi	sp,sp,80
    8000464a:	8082                	ret
    iunlockput(ip);
    8000464c:	8556                	mv	a0,s5
    8000464e:	fffff097          	auipc	ra,0xfffff
    80004652:	87c080e7          	jalr	-1924(ra) # 80002eca <iunlockput>
    return 0;
    80004656:	4a81                	li	s5,0
    80004658:	bff9                	j	80004636 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000465a:	85da                	mv	a1,s6
    8000465c:	4088                	lw	a0,0(s1)
    8000465e:	ffffe097          	auipc	ra,0xffffe
    80004662:	46e080e7          	jalr	1134(ra) # 80002acc <ialloc>
    80004666:	8a2a                	mv	s4,a0
    80004668:	c921                	beqz	a0,800046b8 <create+0xf8>
  ilock(ip);
    8000466a:	ffffe097          	auipc	ra,0xffffe
    8000466e:	5fe080e7          	jalr	1534(ra) # 80002c68 <ilock>
  ip->major = major;
    80004672:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004676:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000467a:	4785                	li	a5,1
    8000467c:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80004680:	8552                	mv	a0,s4
    80004682:	ffffe097          	auipc	ra,0xffffe
    80004686:	51c080e7          	jalr	1308(ra) # 80002b9e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000468a:	000b059b          	sext.w	a1,s6
    8000468e:	4785                	li	a5,1
    80004690:	02f58b63          	beq	a1,a5,800046c6 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    80004694:	004a2603          	lw	a2,4(s4)
    80004698:	fb040593          	addi	a1,s0,-80
    8000469c:	8526                	mv	a0,s1
    8000469e:	fffff097          	auipc	ra,0xfffff
    800046a2:	cbe080e7          	jalr	-834(ra) # 8000335c <dirlink>
    800046a6:	06054f63          	bltz	a0,80004724 <create+0x164>
  iunlockput(dp);
    800046aa:	8526                	mv	a0,s1
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	81e080e7          	jalr	-2018(ra) # 80002eca <iunlockput>
  return ip;
    800046b4:	8ad2                	mv	s5,s4
    800046b6:	b741                	j	80004636 <create+0x76>
    iunlockput(dp);
    800046b8:	8526                	mv	a0,s1
    800046ba:	fffff097          	auipc	ra,0xfffff
    800046be:	810080e7          	jalr	-2032(ra) # 80002eca <iunlockput>
    return 0;
    800046c2:	8ad2                	mv	s5,s4
    800046c4:	bf8d                	j	80004636 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046c6:	004a2603          	lw	a2,4(s4)
    800046ca:	00004597          	auipc	a1,0x4
    800046ce:	0b658593          	addi	a1,a1,182 # 80008780 <syscalls+0x2a8>
    800046d2:	8552                	mv	a0,s4
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	c88080e7          	jalr	-888(ra) # 8000335c <dirlink>
    800046dc:	04054463          	bltz	a0,80004724 <create+0x164>
    800046e0:	40d0                	lw	a2,4(s1)
    800046e2:	00004597          	auipc	a1,0x4
    800046e6:	0a658593          	addi	a1,a1,166 # 80008788 <syscalls+0x2b0>
    800046ea:	8552                	mv	a0,s4
    800046ec:	fffff097          	auipc	ra,0xfffff
    800046f0:	c70080e7          	jalr	-912(ra) # 8000335c <dirlink>
    800046f4:	02054863          	bltz	a0,80004724 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    800046f8:	004a2603          	lw	a2,4(s4)
    800046fc:	fb040593          	addi	a1,s0,-80
    80004700:	8526                	mv	a0,s1
    80004702:	fffff097          	auipc	ra,0xfffff
    80004706:	c5a080e7          	jalr	-934(ra) # 8000335c <dirlink>
    8000470a:	00054d63          	bltz	a0,80004724 <create+0x164>
    dp->nlink++;  // for ".."
    8000470e:	04a4d783          	lhu	a5,74(s1)
    80004712:	2785                	addiw	a5,a5,1
    80004714:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004718:	8526                	mv	a0,s1
    8000471a:	ffffe097          	auipc	ra,0xffffe
    8000471e:	484080e7          	jalr	1156(ra) # 80002b9e <iupdate>
    80004722:	b761                	j	800046aa <create+0xea>
  ip->nlink = 0;
    80004724:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004728:	8552                	mv	a0,s4
    8000472a:	ffffe097          	auipc	ra,0xffffe
    8000472e:	474080e7          	jalr	1140(ra) # 80002b9e <iupdate>
  iunlockput(ip);
    80004732:	8552                	mv	a0,s4
    80004734:	ffffe097          	auipc	ra,0xffffe
    80004738:	796080e7          	jalr	1942(ra) # 80002eca <iunlockput>
  iunlockput(dp);
    8000473c:	8526                	mv	a0,s1
    8000473e:	ffffe097          	auipc	ra,0xffffe
    80004742:	78c080e7          	jalr	1932(ra) # 80002eca <iunlockput>
  return 0;
    80004746:	bdc5                	j	80004636 <create+0x76>
    return 0;
    80004748:	8aaa                	mv	s5,a0
    8000474a:	b5f5                	j	80004636 <create+0x76>

000000008000474c <sys_dup>:
{
    8000474c:	7179                	addi	sp,sp,-48
    8000474e:	f406                	sd	ra,40(sp)
    80004750:	f022                	sd	s0,32(sp)
    80004752:	ec26                	sd	s1,24(sp)
    80004754:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004756:	fd840613          	addi	a2,s0,-40
    8000475a:	4581                	li	a1,0
    8000475c:	4501                	li	a0,0
    8000475e:	00000097          	auipc	ra,0x0
    80004762:	dc0080e7          	jalr	-576(ra) # 8000451e <argfd>
    return -1;
    80004766:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004768:	02054363          	bltz	a0,8000478e <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000476c:	fd843503          	ld	a0,-40(s0)
    80004770:	00000097          	auipc	ra,0x0
    80004774:	e0e080e7          	jalr	-498(ra) # 8000457e <fdalloc>
    80004778:	84aa                	mv	s1,a0
    return -1;
    8000477a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000477c:	00054963          	bltz	a0,8000478e <sys_dup+0x42>
  filedup(f);
    80004780:	fd843503          	ld	a0,-40(s0)
    80004784:	fffff097          	auipc	ra,0xfffff
    80004788:	320080e7          	jalr	800(ra) # 80003aa4 <filedup>
  return fd;
    8000478c:	87a6                	mv	a5,s1
}
    8000478e:	853e                	mv	a0,a5
    80004790:	70a2                	ld	ra,40(sp)
    80004792:	7402                	ld	s0,32(sp)
    80004794:	64e2                	ld	s1,24(sp)
    80004796:	6145                	addi	sp,sp,48
    80004798:	8082                	ret

000000008000479a <sys_read>:
{
    8000479a:	7179                	addi	sp,sp,-48
    8000479c:	f406                	sd	ra,40(sp)
    8000479e:	f022                	sd	s0,32(sp)
    800047a0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047a2:	fd840593          	addi	a1,s0,-40
    800047a6:	4505                	li	a0,1
    800047a8:	ffffe097          	auipc	ra,0xffffe
    800047ac:	89a080e7          	jalr	-1894(ra) # 80002042 <argaddr>
  argint(2, &n);
    800047b0:	fe440593          	addi	a1,s0,-28
    800047b4:	4509                	li	a0,2
    800047b6:	ffffe097          	auipc	ra,0xffffe
    800047ba:	86c080e7          	jalr	-1940(ra) # 80002022 <argint>
  if(argfd(0, 0, &f) < 0)
    800047be:	fe840613          	addi	a2,s0,-24
    800047c2:	4581                	li	a1,0
    800047c4:	4501                	li	a0,0
    800047c6:	00000097          	auipc	ra,0x0
    800047ca:	d58080e7          	jalr	-680(ra) # 8000451e <argfd>
    800047ce:	87aa                	mv	a5,a0
    return -1;
    800047d0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047d2:	0007cc63          	bltz	a5,800047ea <sys_read+0x50>
  return fileread(f, p, n);
    800047d6:	fe442603          	lw	a2,-28(s0)
    800047da:	fd843583          	ld	a1,-40(s0)
    800047de:	fe843503          	ld	a0,-24(s0)
    800047e2:	fffff097          	auipc	ra,0xfffff
    800047e6:	44e080e7          	jalr	1102(ra) # 80003c30 <fileread>
}
    800047ea:	70a2                	ld	ra,40(sp)
    800047ec:	7402                	ld	s0,32(sp)
    800047ee:	6145                	addi	sp,sp,48
    800047f0:	8082                	ret

00000000800047f2 <sys_write>:
{
    800047f2:	7179                	addi	sp,sp,-48
    800047f4:	f406                	sd	ra,40(sp)
    800047f6:	f022                	sd	s0,32(sp)
    800047f8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047fa:	fd840593          	addi	a1,s0,-40
    800047fe:	4505                	li	a0,1
    80004800:	ffffe097          	auipc	ra,0xffffe
    80004804:	842080e7          	jalr	-1982(ra) # 80002042 <argaddr>
  argint(2, &n);
    80004808:	fe440593          	addi	a1,s0,-28
    8000480c:	4509                	li	a0,2
    8000480e:	ffffe097          	auipc	ra,0xffffe
    80004812:	814080e7          	jalr	-2028(ra) # 80002022 <argint>
  if(argfd(0, 0, &f) < 0)
    80004816:	fe840613          	addi	a2,s0,-24
    8000481a:	4581                	li	a1,0
    8000481c:	4501                	li	a0,0
    8000481e:	00000097          	auipc	ra,0x0
    80004822:	d00080e7          	jalr	-768(ra) # 8000451e <argfd>
    80004826:	87aa                	mv	a5,a0
    return -1;
    80004828:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000482a:	0007cc63          	bltz	a5,80004842 <sys_write+0x50>
  return filewrite(f, p, n);
    8000482e:	fe442603          	lw	a2,-28(s0)
    80004832:	fd843583          	ld	a1,-40(s0)
    80004836:	fe843503          	ld	a0,-24(s0)
    8000483a:	fffff097          	auipc	ra,0xfffff
    8000483e:	4b8080e7          	jalr	1208(ra) # 80003cf2 <filewrite>
}
    80004842:	70a2                	ld	ra,40(sp)
    80004844:	7402                	ld	s0,32(sp)
    80004846:	6145                	addi	sp,sp,48
    80004848:	8082                	ret

000000008000484a <sys_close>:
{
    8000484a:	1101                	addi	sp,sp,-32
    8000484c:	ec06                	sd	ra,24(sp)
    8000484e:	e822                	sd	s0,16(sp)
    80004850:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004852:	fe040613          	addi	a2,s0,-32
    80004856:	fec40593          	addi	a1,s0,-20
    8000485a:	4501                	li	a0,0
    8000485c:	00000097          	auipc	ra,0x0
    80004860:	cc2080e7          	jalr	-830(ra) # 8000451e <argfd>
    return -1;
    80004864:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004866:	02054463          	bltz	a0,8000488e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000486a:	ffffc097          	auipc	ra,0xffffc
    8000486e:	66c080e7          	jalr	1644(ra) # 80000ed6 <myproc>
    80004872:	fec42783          	lw	a5,-20(s0)
    80004876:	07e9                	addi	a5,a5,26
    80004878:	078e                	slli	a5,a5,0x3
    8000487a:	97aa                	add	a5,a5,a0
    8000487c:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004880:	fe043503          	ld	a0,-32(s0)
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	272080e7          	jalr	626(ra) # 80003af6 <fileclose>
  return 0;
    8000488c:	4781                	li	a5,0
}
    8000488e:	853e                	mv	a0,a5
    80004890:	60e2                	ld	ra,24(sp)
    80004892:	6442                	ld	s0,16(sp)
    80004894:	6105                	addi	sp,sp,32
    80004896:	8082                	ret

0000000080004898 <sys_fstat>:
{
    80004898:	1101                	addi	sp,sp,-32
    8000489a:	ec06                	sd	ra,24(sp)
    8000489c:	e822                	sd	s0,16(sp)
    8000489e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800048a0:	fe040593          	addi	a1,s0,-32
    800048a4:	4505                	li	a0,1
    800048a6:	ffffd097          	auipc	ra,0xffffd
    800048aa:	79c080e7          	jalr	1948(ra) # 80002042 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800048ae:	fe840613          	addi	a2,s0,-24
    800048b2:	4581                	li	a1,0
    800048b4:	4501                	li	a0,0
    800048b6:	00000097          	auipc	ra,0x0
    800048ba:	c68080e7          	jalr	-920(ra) # 8000451e <argfd>
    800048be:	87aa                	mv	a5,a0
    return -1;
    800048c0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048c2:	0007ca63          	bltz	a5,800048d6 <sys_fstat+0x3e>
  return filestat(f, st);
    800048c6:	fe043583          	ld	a1,-32(s0)
    800048ca:	fe843503          	ld	a0,-24(s0)
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	2f0080e7          	jalr	752(ra) # 80003bbe <filestat>
}
    800048d6:	60e2                	ld	ra,24(sp)
    800048d8:	6442                	ld	s0,16(sp)
    800048da:	6105                	addi	sp,sp,32
    800048dc:	8082                	ret

00000000800048de <sys_link>:
{
    800048de:	7169                	addi	sp,sp,-304
    800048e0:	f606                	sd	ra,296(sp)
    800048e2:	f222                	sd	s0,288(sp)
    800048e4:	ee26                	sd	s1,280(sp)
    800048e6:	ea4a                	sd	s2,272(sp)
    800048e8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048ea:	08000613          	li	a2,128
    800048ee:	ed040593          	addi	a1,s0,-304
    800048f2:	4501                	li	a0,0
    800048f4:	ffffd097          	auipc	ra,0xffffd
    800048f8:	76e080e7          	jalr	1902(ra) # 80002062 <argstr>
    return -1;
    800048fc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048fe:	10054e63          	bltz	a0,80004a1a <sys_link+0x13c>
    80004902:	08000613          	li	a2,128
    80004906:	f5040593          	addi	a1,s0,-176
    8000490a:	4505                	li	a0,1
    8000490c:	ffffd097          	auipc	ra,0xffffd
    80004910:	756080e7          	jalr	1878(ra) # 80002062 <argstr>
    return -1;
    80004914:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004916:	10054263          	bltz	a0,80004a1a <sys_link+0x13c>
  begin_op();
    8000491a:	fffff097          	auipc	ra,0xfffff
    8000491e:	d10080e7          	jalr	-752(ra) # 8000362a <begin_op>
  if((ip = namei(old)) == 0){
    80004922:	ed040513          	addi	a0,s0,-304
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	ae8080e7          	jalr	-1304(ra) # 8000340e <namei>
    8000492e:	84aa                	mv	s1,a0
    80004930:	c551                	beqz	a0,800049bc <sys_link+0xde>
  ilock(ip);
    80004932:	ffffe097          	auipc	ra,0xffffe
    80004936:	336080e7          	jalr	822(ra) # 80002c68 <ilock>
  if(ip->type == T_DIR){
    8000493a:	04449703          	lh	a4,68(s1)
    8000493e:	4785                	li	a5,1
    80004940:	08f70463          	beq	a4,a5,800049c8 <sys_link+0xea>
  ip->nlink++;
    80004944:	04a4d783          	lhu	a5,74(s1)
    80004948:	2785                	addiw	a5,a5,1
    8000494a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000494e:	8526                	mv	a0,s1
    80004950:	ffffe097          	auipc	ra,0xffffe
    80004954:	24e080e7          	jalr	590(ra) # 80002b9e <iupdate>
  iunlock(ip);
    80004958:	8526                	mv	a0,s1
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	3d0080e7          	jalr	976(ra) # 80002d2a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004962:	fd040593          	addi	a1,s0,-48
    80004966:	f5040513          	addi	a0,s0,-176
    8000496a:	fffff097          	auipc	ra,0xfffff
    8000496e:	ac2080e7          	jalr	-1342(ra) # 8000342c <nameiparent>
    80004972:	892a                	mv	s2,a0
    80004974:	c935                	beqz	a0,800049e8 <sys_link+0x10a>
  ilock(dp);
    80004976:	ffffe097          	auipc	ra,0xffffe
    8000497a:	2f2080e7          	jalr	754(ra) # 80002c68 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000497e:	00092703          	lw	a4,0(s2)
    80004982:	409c                	lw	a5,0(s1)
    80004984:	04f71d63          	bne	a4,a5,800049de <sys_link+0x100>
    80004988:	40d0                	lw	a2,4(s1)
    8000498a:	fd040593          	addi	a1,s0,-48
    8000498e:	854a                	mv	a0,s2
    80004990:	fffff097          	auipc	ra,0xfffff
    80004994:	9cc080e7          	jalr	-1588(ra) # 8000335c <dirlink>
    80004998:	04054363          	bltz	a0,800049de <sys_link+0x100>
  iunlockput(dp);
    8000499c:	854a                	mv	a0,s2
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	52c080e7          	jalr	1324(ra) # 80002eca <iunlockput>
  iput(ip);
    800049a6:	8526                	mv	a0,s1
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	47a080e7          	jalr	1146(ra) # 80002e22 <iput>
  end_op();
    800049b0:	fffff097          	auipc	ra,0xfffff
    800049b4:	cfa080e7          	jalr	-774(ra) # 800036aa <end_op>
  return 0;
    800049b8:	4781                	li	a5,0
    800049ba:	a085                	j	80004a1a <sys_link+0x13c>
    end_op();
    800049bc:	fffff097          	auipc	ra,0xfffff
    800049c0:	cee080e7          	jalr	-786(ra) # 800036aa <end_op>
    return -1;
    800049c4:	57fd                	li	a5,-1
    800049c6:	a891                	j	80004a1a <sys_link+0x13c>
    iunlockput(ip);
    800049c8:	8526                	mv	a0,s1
    800049ca:	ffffe097          	auipc	ra,0xffffe
    800049ce:	500080e7          	jalr	1280(ra) # 80002eca <iunlockput>
    end_op();
    800049d2:	fffff097          	auipc	ra,0xfffff
    800049d6:	cd8080e7          	jalr	-808(ra) # 800036aa <end_op>
    return -1;
    800049da:	57fd                	li	a5,-1
    800049dc:	a83d                	j	80004a1a <sys_link+0x13c>
    iunlockput(dp);
    800049de:	854a                	mv	a0,s2
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	4ea080e7          	jalr	1258(ra) # 80002eca <iunlockput>
  ilock(ip);
    800049e8:	8526                	mv	a0,s1
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	27e080e7          	jalr	638(ra) # 80002c68 <ilock>
  ip->nlink--;
    800049f2:	04a4d783          	lhu	a5,74(s1)
    800049f6:	37fd                	addiw	a5,a5,-1
    800049f8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049fc:	8526                	mv	a0,s1
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	1a0080e7          	jalr	416(ra) # 80002b9e <iupdate>
  iunlockput(ip);
    80004a06:	8526                	mv	a0,s1
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	4c2080e7          	jalr	1218(ra) # 80002eca <iunlockput>
  end_op();
    80004a10:	fffff097          	auipc	ra,0xfffff
    80004a14:	c9a080e7          	jalr	-870(ra) # 800036aa <end_op>
  return -1;
    80004a18:	57fd                	li	a5,-1
}
    80004a1a:	853e                	mv	a0,a5
    80004a1c:	70b2                	ld	ra,296(sp)
    80004a1e:	7412                	ld	s0,288(sp)
    80004a20:	64f2                	ld	s1,280(sp)
    80004a22:	6952                	ld	s2,272(sp)
    80004a24:	6155                	addi	sp,sp,304
    80004a26:	8082                	ret

0000000080004a28 <sys_unlink>:
{
    80004a28:	7151                	addi	sp,sp,-240
    80004a2a:	f586                	sd	ra,232(sp)
    80004a2c:	f1a2                	sd	s0,224(sp)
    80004a2e:	eda6                	sd	s1,216(sp)
    80004a30:	e9ca                	sd	s2,208(sp)
    80004a32:	e5ce                	sd	s3,200(sp)
    80004a34:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a36:	08000613          	li	a2,128
    80004a3a:	f3040593          	addi	a1,s0,-208
    80004a3e:	4501                	li	a0,0
    80004a40:	ffffd097          	auipc	ra,0xffffd
    80004a44:	622080e7          	jalr	1570(ra) # 80002062 <argstr>
    80004a48:	18054163          	bltz	a0,80004bca <sys_unlink+0x1a2>
  begin_op();
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	bde080e7          	jalr	-1058(ra) # 8000362a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a54:	fb040593          	addi	a1,s0,-80
    80004a58:	f3040513          	addi	a0,s0,-208
    80004a5c:	fffff097          	auipc	ra,0xfffff
    80004a60:	9d0080e7          	jalr	-1584(ra) # 8000342c <nameiparent>
    80004a64:	84aa                	mv	s1,a0
    80004a66:	c979                	beqz	a0,80004b3c <sys_unlink+0x114>
  ilock(dp);
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	200080e7          	jalr	512(ra) # 80002c68 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a70:	00004597          	auipc	a1,0x4
    80004a74:	d1058593          	addi	a1,a1,-752 # 80008780 <syscalls+0x2a8>
    80004a78:	fb040513          	addi	a0,s0,-80
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	6b6080e7          	jalr	1718(ra) # 80003132 <namecmp>
    80004a84:	14050a63          	beqz	a0,80004bd8 <sys_unlink+0x1b0>
    80004a88:	00004597          	auipc	a1,0x4
    80004a8c:	d0058593          	addi	a1,a1,-768 # 80008788 <syscalls+0x2b0>
    80004a90:	fb040513          	addi	a0,s0,-80
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	69e080e7          	jalr	1694(ra) # 80003132 <namecmp>
    80004a9c:	12050e63          	beqz	a0,80004bd8 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004aa0:	f2c40613          	addi	a2,s0,-212
    80004aa4:	fb040593          	addi	a1,s0,-80
    80004aa8:	8526                	mv	a0,s1
    80004aaa:	ffffe097          	auipc	ra,0xffffe
    80004aae:	6a2080e7          	jalr	1698(ra) # 8000314c <dirlookup>
    80004ab2:	892a                	mv	s2,a0
    80004ab4:	12050263          	beqz	a0,80004bd8 <sys_unlink+0x1b0>
  ilock(ip);
    80004ab8:	ffffe097          	auipc	ra,0xffffe
    80004abc:	1b0080e7          	jalr	432(ra) # 80002c68 <ilock>
  if(ip->nlink < 1)
    80004ac0:	04a91783          	lh	a5,74(s2)
    80004ac4:	08f05263          	blez	a5,80004b48 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ac8:	04491703          	lh	a4,68(s2)
    80004acc:	4785                	li	a5,1
    80004ace:	08f70563          	beq	a4,a5,80004b58 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004ad2:	4641                	li	a2,16
    80004ad4:	4581                	li	a1,0
    80004ad6:	fc040513          	addi	a0,s0,-64
    80004ada:	ffffb097          	auipc	ra,0xffffb
    80004ade:	6c4080e7          	jalr	1732(ra) # 8000019e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ae2:	4741                	li	a4,16
    80004ae4:	f2c42683          	lw	a3,-212(s0)
    80004ae8:	fc040613          	addi	a2,s0,-64
    80004aec:	4581                	li	a1,0
    80004aee:	8526                	mv	a0,s1
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	524080e7          	jalr	1316(ra) # 80003014 <writei>
    80004af8:	47c1                	li	a5,16
    80004afa:	0af51563          	bne	a0,a5,80004ba4 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004afe:	04491703          	lh	a4,68(s2)
    80004b02:	4785                	li	a5,1
    80004b04:	0af70863          	beq	a4,a5,80004bb4 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b08:	8526                	mv	a0,s1
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	3c0080e7          	jalr	960(ra) # 80002eca <iunlockput>
  ip->nlink--;
    80004b12:	04a95783          	lhu	a5,74(s2)
    80004b16:	37fd                	addiw	a5,a5,-1
    80004b18:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b1c:	854a                	mv	a0,s2
    80004b1e:	ffffe097          	auipc	ra,0xffffe
    80004b22:	080080e7          	jalr	128(ra) # 80002b9e <iupdate>
  iunlockput(ip);
    80004b26:	854a                	mv	a0,s2
    80004b28:	ffffe097          	auipc	ra,0xffffe
    80004b2c:	3a2080e7          	jalr	930(ra) # 80002eca <iunlockput>
  end_op();
    80004b30:	fffff097          	auipc	ra,0xfffff
    80004b34:	b7a080e7          	jalr	-1158(ra) # 800036aa <end_op>
  return 0;
    80004b38:	4501                	li	a0,0
    80004b3a:	a84d                	j	80004bec <sys_unlink+0x1c4>
    end_op();
    80004b3c:	fffff097          	auipc	ra,0xfffff
    80004b40:	b6e080e7          	jalr	-1170(ra) # 800036aa <end_op>
    return -1;
    80004b44:	557d                	li	a0,-1
    80004b46:	a05d                	j	80004bec <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b48:	00004517          	auipc	a0,0x4
    80004b4c:	c4850513          	addi	a0,a0,-952 # 80008790 <syscalls+0x2b8>
    80004b50:	00001097          	auipc	ra,0x1
    80004b54:	212080e7          	jalr	530(ra) # 80005d62 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b58:	04c92703          	lw	a4,76(s2)
    80004b5c:	02000793          	li	a5,32
    80004b60:	f6e7f9e3          	bgeu	a5,a4,80004ad2 <sys_unlink+0xaa>
    80004b64:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b68:	4741                	li	a4,16
    80004b6a:	86ce                	mv	a3,s3
    80004b6c:	f1840613          	addi	a2,s0,-232
    80004b70:	4581                	li	a1,0
    80004b72:	854a                	mv	a0,s2
    80004b74:	ffffe097          	auipc	ra,0xffffe
    80004b78:	3a8080e7          	jalr	936(ra) # 80002f1c <readi>
    80004b7c:	47c1                	li	a5,16
    80004b7e:	00f51b63          	bne	a0,a5,80004b94 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b82:	f1845783          	lhu	a5,-232(s0)
    80004b86:	e7a1                	bnez	a5,80004bce <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b88:	29c1                	addiw	s3,s3,16
    80004b8a:	04c92783          	lw	a5,76(s2)
    80004b8e:	fcf9ede3          	bltu	s3,a5,80004b68 <sys_unlink+0x140>
    80004b92:	b781                	j	80004ad2 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b94:	00004517          	auipc	a0,0x4
    80004b98:	c1450513          	addi	a0,a0,-1004 # 800087a8 <syscalls+0x2d0>
    80004b9c:	00001097          	auipc	ra,0x1
    80004ba0:	1c6080e7          	jalr	454(ra) # 80005d62 <panic>
    panic("unlink: writei");
    80004ba4:	00004517          	auipc	a0,0x4
    80004ba8:	c1c50513          	addi	a0,a0,-996 # 800087c0 <syscalls+0x2e8>
    80004bac:	00001097          	auipc	ra,0x1
    80004bb0:	1b6080e7          	jalr	438(ra) # 80005d62 <panic>
    dp->nlink--;
    80004bb4:	04a4d783          	lhu	a5,74(s1)
    80004bb8:	37fd                	addiw	a5,a5,-1
    80004bba:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bbe:	8526                	mv	a0,s1
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	fde080e7          	jalr	-34(ra) # 80002b9e <iupdate>
    80004bc8:	b781                	j	80004b08 <sys_unlink+0xe0>
    return -1;
    80004bca:	557d                	li	a0,-1
    80004bcc:	a005                	j	80004bec <sys_unlink+0x1c4>
    iunlockput(ip);
    80004bce:	854a                	mv	a0,s2
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	2fa080e7          	jalr	762(ra) # 80002eca <iunlockput>
  iunlockput(dp);
    80004bd8:	8526                	mv	a0,s1
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	2f0080e7          	jalr	752(ra) # 80002eca <iunlockput>
  end_op();
    80004be2:	fffff097          	auipc	ra,0xfffff
    80004be6:	ac8080e7          	jalr	-1336(ra) # 800036aa <end_op>
  return -1;
    80004bea:	557d                	li	a0,-1
}
    80004bec:	70ae                	ld	ra,232(sp)
    80004bee:	740e                	ld	s0,224(sp)
    80004bf0:	64ee                	ld	s1,216(sp)
    80004bf2:	694e                	ld	s2,208(sp)
    80004bf4:	69ae                	ld	s3,200(sp)
    80004bf6:	616d                	addi	sp,sp,240
    80004bf8:	8082                	ret

0000000080004bfa <sys_open>:

uint64
sys_open(void)
{
    80004bfa:	7131                	addi	sp,sp,-192
    80004bfc:	fd06                	sd	ra,184(sp)
    80004bfe:	f922                	sd	s0,176(sp)
    80004c00:	f526                	sd	s1,168(sp)
    80004c02:	f14a                	sd	s2,160(sp)
    80004c04:	ed4e                	sd	s3,152(sp)
    80004c06:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c08:	f4c40593          	addi	a1,s0,-180
    80004c0c:	4505                	li	a0,1
    80004c0e:	ffffd097          	auipc	ra,0xffffd
    80004c12:	414080e7          	jalr	1044(ra) # 80002022 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c16:	08000613          	li	a2,128
    80004c1a:	f5040593          	addi	a1,s0,-176
    80004c1e:	4501                	li	a0,0
    80004c20:	ffffd097          	auipc	ra,0xffffd
    80004c24:	442080e7          	jalr	1090(ra) # 80002062 <argstr>
    80004c28:	87aa                	mv	a5,a0
    return -1;
    80004c2a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c2c:	0a07c963          	bltz	a5,80004cde <sys_open+0xe4>

  begin_op();
    80004c30:	fffff097          	auipc	ra,0xfffff
    80004c34:	9fa080e7          	jalr	-1542(ra) # 8000362a <begin_op>

  if(omode & O_CREATE){
    80004c38:	f4c42783          	lw	a5,-180(s0)
    80004c3c:	2007f793          	andi	a5,a5,512
    80004c40:	cfc5                	beqz	a5,80004cf8 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c42:	4681                	li	a3,0
    80004c44:	4601                	li	a2,0
    80004c46:	4589                	li	a1,2
    80004c48:	f5040513          	addi	a0,s0,-176
    80004c4c:	00000097          	auipc	ra,0x0
    80004c50:	974080e7          	jalr	-1676(ra) # 800045c0 <create>
    80004c54:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c56:	c959                	beqz	a0,80004cec <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c58:	04449703          	lh	a4,68(s1)
    80004c5c:	478d                	li	a5,3
    80004c5e:	00f71763          	bne	a4,a5,80004c6c <sys_open+0x72>
    80004c62:	0464d703          	lhu	a4,70(s1)
    80004c66:	47a5                	li	a5,9
    80004c68:	0ce7ed63          	bltu	a5,a4,80004d42 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c6c:	fffff097          	auipc	ra,0xfffff
    80004c70:	dce080e7          	jalr	-562(ra) # 80003a3a <filealloc>
    80004c74:	89aa                	mv	s3,a0
    80004c76:	10050363          	beqz	a0,80004d7c <sys_open+0x182>
    80004c7a:	00000097          	auipc	ra,0x0
    80004c7e:	904080e7          	jalr	-1788(ra) # 8000457e <fdalloc>
    80004c82:	892a                	mv	s2,a0
    80004c84:	0e054763          	bltz	a0,80004d72 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c88:	04449703          	lh	a4,68(s1)
    80004c8c:	478d                	li	a5,3
    80004c8e:	0cf70563          	beq	a4,a5,80004d58 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c92:	4789                	li	a5,2
    80004c94:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c98:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c9c:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004ca0:	f4c42783          	lw	a5,-180(s0)
    80004ca4:	0017c713          	xori	a4,a5,1
    80004ca8:	8b05                	andi	a4,a4,1
    80004caa:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cae:	0037f713          	andi	a4,a5,3
    80004cb2:	00e03733          	snez	a4,a4
    80004cb6:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cba:	4007f793          	andi	a5,a5,1024
    80004cbe:	c791                	beqz	a5,80004cca <sys_open+0xd0>
    80004cc0:	04449703          	lh	a4,68(s1)
    80004cc4:	4789                	li	a5,2
    80004cc6:	0af70063          	beq	a4,a5,80004d66 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004cca:	8526                	mv	a0,s1
    80004ccc:	ffffe097          	auipc	ra,0xffffe
    80004cd0:	05e080e7          	jalr	94(ra) # 80002d2a <iunlock>
  end_op();
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	9d6080e7          	jalr	-1578(ra) # 800036aa <end_op>

  return fd;
    80004cdc:	854a                	mv	a0,s2
}
    80004cde:	70ea                	ld	ra,184(sp)
    80004ce0:	744a                	ld	s0,176(sp)
    80004ce2:	74aa                	ld	s1,168(sp)
    80004ce4:	790a                	ld	s2,160(sp)
    80004ce6:	69ea                	ld	s3,152(sp)
    80004ce8:	6129                	addi	sp,sp,192
    80004cea:	8082                	ret
      end_op();
    80004cec:	fffff097          	auipc	ra,0xfffff
    80004cf0:	9be080e7          	jalr	-1602(ra) # 800036aa <end_op>
      return -1;
    80004cf4:	557d                	li	a0,-1
    80004cf6:	b7e5                	j	80004cde <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004cf8:	f5040513          	addi	a0,s0,-176
    80004cfc:	ffffe097          	auipc	ra,0xffffe
    80004d00:	712080e7          	jalr	1810(ra) # 8000340e <namei>
    80004d04:	84aa                	mv	s1,a0
    80004d06:	c905                	beqz	a0,80004d36 <sys_open+0x13c>
    ilock(ip);
    80004d08:	ffffe097          	auipc	ra,0xffffe
    80004d0c:	f60080e7          	jalr	-160(ra) # 80002c68 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d10:	04449703          	lh	a4,68(s1)
    80004d14:	4785                	li	a5,1
    80004d16:	f4f711e3          	bne	a4,a5,80004c58 <sys_open+0x5e>
    80004d1a:	f4c42783          	lw	a5,-180(s0)
    80004d1e:	d7b9                	beqz	a5,80004c6c <sys_open+0x72>
      iunlockput(ip);
    80004d20:	8526                	mv	a0,s1
    80004d22:	ffffe097          	auipc	ra,0xffffe
    80004d26:	1a8080e7          	jalr	424(ra) # 80002eca <iunlockput>
      end_op();
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	980080e7          	jalr	-1664(ra) # 800036aa <end_op>
      return -1;
    80004d32:	557d                	li	a0,-1
    80004d34:	b76d                	j	80004cde <sys_open+0xe4>
      end_op();
    80004d36:	fffff097          	auipc	ra,0xfffff
    80004d3a:	974080e7          	jalr	-1676(ra) # 800036aa <end_op>
      return -1;
    80004d3e:	557d                	li	a0,-1
    80004d40:	bf79                	j	80004cde <sys_open+0xe4>
    iunlockput(ip);
    80004d42:	8526                	mv	a0,s1
    80004d44:	ffffe097          	auipc	ra,0xffffe
    80004d48:	186080e7          	jalr	390(ra) # 80002eca <iunlockput>
    end_op();
    80004d4c:	fffff097          	auipc	ra,0xfffff
    80004d50:	95e080e7          	jalr	-1698(ra) # 800036aa <end_op>
    return -1;
    80004d54:	557d                	li	a0,-1
    80004d56:	b761                	j	80004cde <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d58:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d5c:	04649783          	lh	a5,70(s1)
    80004d60:	02f99223          	sh	a5,36(s3)
    80004d64:	bf25                	j	80004c9c <sys_open+0xa2>
    itrunc(ip);
    80004d66:	8526                	mv	a0,s1
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	00e080e7          	jalr	14(ra) # 80002d76 <itrunc>
    80004d70:	bfa9                	j	80004cca <sys_open+0xd0>
      fileclose(f);
    80004d72:	854e                	mv	a0,s3
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	d82080e7          	jalr	-638(ra) # 80003af6 <fileclose>
    iunlockput(ip);
    80004d7c:	8526                	mv	a0,s1
    80004d7e:	ffffe097          	auipc	ra,0xffffe
    80004d82:	14c080e7          	jalr	332(ra) # 80002eca <iunlockput>
    end_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	924080e7          	jalr	-1756(ra) # 800036aa <end_op>
    return -1;
    80004d8e:	557d                	li	a0,-1
    80004d90:	b7b9                	j	80004cde <sys_open+0xe4>

0000000080004d92 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d92:	7175                	addi	sp,sp,-144
    80004d94:	e506                	sd	ra,136(sp)
    80004d96:	e122                	sd	s0,128(sp)
    80004d98:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d9a:	fffff097          	auipc	ra,0xfffff
    80004d9e:	890080e7          	jalr	-1904(ra) # 8000362a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004da2:	08000613          	li	a2,128
    80004da6:	f7040593          	addi	a1,s0,-144
    80004daa:	4501                	li	a0,0
    80004dac:	ffffd097          	auipc	ra,0xffffd
    80004db0:	2b6080e7          	jalr	694(ra) # 80002062 <argstr>
    80004db4:	02054963          	bltz	a0,80004de6 <sys_mkdir+0x54>
    80004db8:	4681                	li	a3,0
    80004dba:	4601                	li	a2,0
    80004dbc:	4585                	li	a1,1
    80004dbe:	f7040513          	addi	a0,s0,-144
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	7fe080e7          	jalr	2046(ra) # 800045c0 <create>
    80004dca:	cd11                	beqz	a0,80004de6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dcc:	ffffe097          	auipc	ra,0xffffe
    80004dd0:	0fe080e7          	jalr	254(ra) # 80002eca <iunlockput>
  end_op();
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	8d6080e7          	jalr	-1834(ra) # 800036aa <end_op>
  return 0;
    80004ddc:	4501                	li	a0,0
}
    80004dde:	60aa                	ld	ra,136(sp)
    80004de0:	640a                	ld	s0,128(sp)
    80004de2:	6149                	addi	sp,sp,144
    80004de4:	8082                	ret
    end_op();
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	8c4080e7          	jalr	-1852(ra) # 800036aa <end_op>
    return -1;
    80004dee:	557d                	li	a0,-1
    80004df0:	b7fd                	j	80004dde <sys_mkdir+0x4c>

0000000080004df2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004df2:	7135                	addi	sp,sp,-160
    80004df4:	ed06                	sd	ra,152(sp)
    80004df6:	e922                	sd	s0,144(sp)
    80004df8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	830080e7          	jalr	-2000(ra) # 8000362a <begin_op>
  argint(1, &major);
    80004e02:	f6c40593          	addi	a1,s0,-148
    80004e06:	4505                	li	a0,1
    80004e08:	ffffd097          	auipc	ra,0xffffd
    80004e0c:	21a080e7          	jalr	538(ra) # 80002022 <argint>
  argint(2, &minor);
    80004e10:	f6840593          	addi	a1,s0,-152
    80004e14:	4509                	li	a0,2
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	20c080e7          	jalr	524(ra) # 80002022 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e1e:	08000613          	li	a2,128
    80004e22:	f7040593          	addi	a1,s0,-144
    80004e26:	4501                	li	a0,0
    80004e28:	ffffd097          	auipc	ra,0xffffd
    80004e2c:	23a080e7          	jalr	570(ra) # 80002062 <argstr>
    80004e30:	02054b63          	bltz	a0,80004e66 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e34:	f6841683          	lh	a3,-152(s0)
    80004e38:	f6c41603          	lh	a2,-148(s0)
    80004e3c:	458d                	li	a1,3
    80004e3e:	f7040513          	addi	a0,s0,-144
    80004e42:	fffff097          	auipc	ra,0xfffff
    80004e46:	77e080e7          	jalr	1918(ra) # 800045c0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e4a:	cd11                	beqz	a0,80004e66 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e4c:	ffffe097          	auipc	ra,0xffffe
    80004e50:	07e080e7          	jalr	126(ra) # 80002eca <iunlockput>
  end_op();
    80004e54:	fffff097          	auipc	ra,0xfffff
    80004e58:	856080e7          	jalr	-1962(ra) # 800036aa <end_op>
  return 0;
    80004e5c:	4501                	li	a0,0
}
    80004e5e:	60ea                	ld	ra,152(sp)
    80004e60:	644a                	ld	s0,144(sp)
    80004e62:	610d                	addi	sp,sp,160
    80004e64:	8082                	ret
    end_op();
    80004e66:	fffff097          	auipc	ra,0xfffff
    80004e6a:	844080e7          	jalr	-1980(ra) # 800036aa <end_op>
    return -1;
    80004e6e:	557d                	li	a0,-1
    80004e70:	b7fd                	j	80004e5e <sys_mknod+0x6c>

0000000080004e72 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e72:	7135                	addi	sp,sp,-160
    80004e74:	ed06                	sd	ra,152(sp)
    80004e76:	e922                	sd	s0,144(sp)
    80004e78:	e526                	sd	s1,136(sp)
    80004e7a:	e14a                	sd	s2,128(sp)
    80004e7c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e7e:	ffffc097          	auipc	ra,0xffffc
    80004e82:	058080e7          	jalr	88(ra) # 80000ed6 <myproc>
    80004e86:	892a                	mv	s2,a0
  
  begin_op();
    80004e88:	ffffe097          	auipc	ra,0xffffe
    80004e8c:	7a2080e7          	jalr	1954(ra) # 8000362a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e90:	08000613          	li	a2,128
    80004e94:	f6040593          	addi	a1,s0,-160
    80004e98:	4501                	li	a0,0
    80004e9a:	ffffd097          	auipc	ra,0xffffd
    80004e9e:	1c8080e7          	jalr	456(ra) # 80002062 <argstr>
    80004ea2:	04054b63          	bltz	a0,80004ef8 <sys_chdir+0x86>
    80004ea6:	f6040513          	addi	a0,s0,-160
    80004eaa:	ffffe097          	auipc	ra,0xffffe
    80004eae:	564080e7          	jalr	1380(ra) # 8000340e <namei>
    80004eb2:	84aa                	mv	s1,a0
    80004eb4:	c131                	beqz	a0,80004ef8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004eb6:	ffffe097          	auipc	ra,0xffffe
    80004eba:	db2080e7          	jalr	-590(ra) # 80002c68 <ilock>
  if(ip->type != T_DIR){
    80004ebe:	04449703          	lh	a4,68(s1)
    80004ec2:	4785                	li	a5,1
    80004ec4:	04f71063          	bne	a4,a5,80004f04 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ec8:	8526                	mv	a0,s1
    80004eca:	ffffe097          	auipc	ra,0xffffe
    80004ece:	e60080e7          	jalr	-416(ra) # 80002d2a <iunlock>
  iput(p->cwd);
    80004ed2:	15093503          	ld	a0,336(s2)
    80004ed6:	ffffe097          	auipc	ra,0xffffe
    80004eda:	f4c080e7          	jalr	-180(ra) # 80002e22 <iput>
  end_op();
    80004ede:	ffffe097          	auipc	ra,0xffffe
    80004ee2:	7cc080e7          	jalr	1996(ra) # 800036aa <end_op>
  p->cwd = ip;
    80004ee6:	14993823          	sd	s1,336(s2)
  return 0;
    80004eea:	4501                	li	a0,0
}
    80004eec:	60ea                	ld	ra,152(sp)
    80004eee:	644a                	ld	s0,144(sp)
    80004ef0:	64aa                	ld	s1,136(sp)
    80004ef2:	690a                	ld	s2,128(sp)
    80004ef4:	610d                	addi	sp,sp,160
    80004ef6:	8082                	ret
    end_op();
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	7b2080e7          	jalr	1970(ra) # 800036aa <end_op>
    return -1;
    80004f00:	557d                	li	a0,-1
    80004f02:	b7ed                	j	80004eec <sys_chdir+0x7a>
    iunlockput(ip);
    80004f04:	8526                	mv	a0,s1
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	fc4080e7          	jalr	-60(ra) # 80002eca <iunlockput>
    end_op();
    80004f0e:	ffffe097          	auipc	ra,0xffffe
    80004f12:	79c080e7          	jalr	1948(ra) # 800036aa <end_op>
    return -1;
    80004f16:	557d                	li	a0,-1
    80004f18:	bfd1                	j	80004eec <sys_chdir+0x7a>

0000000080004f1a <sys_exec>:

uint64
sys_exec(void)
{
    80004f1a:	7145                	addi	sp,sp,-464
    80004f1c:	e786                	sd	ra,456(sp)
    80004f1e:	e3a2                	sd	s0,448(sp)
    80004f20:	ff26                	sd	s1,440(sp)
    80004f22:	fb4a                	sd	s2,432(sp)
    80004f24:	f74e                	sd	s3,424(sp)
    80004f26:	f352                	sd	s4,416(sp)
    80004f28:	ef56                	sd	s5,408(sp)
    80004f2a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f2c:	e3840593          	addi	a1,s0,-456
    80004f30:	4505                	li	a0,1
    80004f32:	ffffd097          	auipc	ra,0xffffd
    80004f36:	110080e7          	jalr	272(ra) # 80002042 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f3a:	08000613          	li	a2,128
    80004f3e:	f4040593          	addi	a1,s0,-192
    80004f42:	4501                	li	a0,0
    80004f44:	ffffd097          	auipc	ra,0xffffd
    80004f48:	11e080e7          	jalr	286(ra) # 80002062 <argstr>
    80004f4c:	87aa                	mv	a5,a0
    return -1;
    80004f4e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f50:	0c07c263          	bltz	a5,80005014 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f54:	10000613          	li	a2,256
    80004f58:	4581                	li	a1,0
    80004f5a:	e4040513          	addi	a0,s0,-448
    80004f5e:	ffffb097          	auipc	ra,0xffffb
    80004f62:	240080e7          	jalr	576(ra) # 8000019e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f66:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f6a:	89a6                	mv	s3,s1
    80004f6c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f6e:	02000a13          	li	s4,32
    80004f72:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f76:	00391513          	slli	a0,s2,0x3
    80004f7a:	e3040593          	addi	a1,s0,-464
    80004f7e:	e3843783          	ld	a5,-456(s0)
    80004f82:	953e                	add	a0,a0,a5
    80004f84:	ffffd097          	auipc	ra,0xffffd
    80004f88:	000080e7          	jalr	ra # 80001f84 <fetchaddr>
    80004f8c:	02054a63          	bltz	a0,80004fc0 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004f90:	e3043783          	ld	a5,-464(s0)
    80004f94:	c3b9                	beqz	a5,80004fda <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f96:	ffffb097          	auipc	ra,0xffffb
    80004f9a:	182080e7          	jalr	386(ra) # 80000118 <kalloc>
    80004f9e:	85aa                	mv	a1,a0
    80004fa0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fa4:	cd11                	beqz	a0,80004fc0 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fa6:	6605                	lui	a2,0x1
    80004fa8:	e3043503          	ld	a0,-464(s0)
    80004fac:	ffffd097          	auipc	ra,0xffffd
    80004fb0:	02a080e7          	jalr	42(ra) # 80001fd6 <fetchstr>
    80004fb4:	00054663          	bltz	a0,80004fc0 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004fb8:	0905                	addi	s2,s2,1
    80004fba:	09a1                	addi	s3,s3,8
    80004fbc:	fb491be3          	bne	s2,s4,80004f72 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fc0:	10048913          	addi	s2,s1,256
    80004fc4:	6088                	ld	a0,0(s1)
    80004fc6:	c531                	beqz	a0,80005012 <sys_exec+0xf8>
    kfree(argv[i]);
    80004fc8:	ffffb097          	auipc	ra,0xffffb
    80004fcc:	054080e7          	jalr	84(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fd0:	04a1                	addi	s1,s1,8
    80004fd2:	ff2499e3          	bne	s1,s2,80004fc4 <sys_exec+0xaa>
  return -1;
    80004fd6:	557d                	li	a0,-1
    80004fd8:	a835                	j	80005014 <sys_exec+0xfa>
      argv[i] = 0;
    80004fda:	0a8e                	slli	s5,s5,0x3
    80004fdc:	fc040793          	addi	a5,s0,-64
    80004fe0:	9abe                	add	s5,s5,a5
    80004fe2:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004fe6:	e4040593          	addi	a1,s0,-448
    80004fea:	f4040513          	addi	a0,s0,-192
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	190080e7          	jalr	400(ra) # 8000417e <exec>
    80004ff6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ff8:	10048993          	addi	s3,s1,256
    80004ffc:	6088                	ld	a0,0(s1)
    80004ffe:	c901                	beqz	a0,8000500e <sys_exec+0xf4>
    kfree(argv[i]);
    80005000:	ffffb097          	auipc	ra,0xffffb
    80005004:	01c080e7          	jalr	28(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005008:	04a1                	addi	s1,s1,8
    8000500a:	ff3499e3          	bne	s1,s3,80004ffc <sys_exec+0xe2>
  return ret;
    8000500e:	854a                	mv	a0,s2
    80005010:	a011                	j	80005014 <sys_exec+0xfa>
  return -1;
    80005012:	557d                	li	a0,-1
}
    80005014:	60be                	ld	ra,456(sp)
    80005016:	641e                	ld	s0,448(sp)
    80005018:	74fa                	ld	s1,440(sp)
    8000501a:	795a                	ld	s2,432(sp)
    8000501c:	79ba                	ld	s3,424(sp)
    8000501e:	7a1a                	ld	s4,416(sp)
    80005020:	6afa                	ld	s5,408(sp)
    80005022:	6179                	addi	sp,sp,464
    80005024:	8082                	ret

0000000080005026 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005026:	7139                	addi	sp,sp,-64
    80005028:	fc06                	sd	ra,56(sp)
    8000502a:	f822                	sd	s0,48(sp)
    8000502c:	f426                	sd	s1,40(sp)
    8000502e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005030:	ffffc097          	auipc	ra,0xffffc
    80005034:	ea6080e7          	jalr	-346(ra) # 80000ed6 <myproc>
    80005038:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000503a:	fd840593          	addi	a1,s0,-40
    8000503e:	4501                	li	a0,0
    80005040:	ffffd097          	auipc	ra,0xffffd
    80005044:	002080e7          	jalr	2(ra) # 80002042 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005048:	fc840593          	addi	a1,s0,-56
    8000504c:	fd040513          	addi	a0,s0,-48
    80005050:	fffff097          	auipc	ra,0xfffff
    80005054:	dd6080e7          	jalr	-554(ra) # 80003e26 <pipealloc>
    return -1;
    80005058:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000505a:	0c054463          	bltz	a0,80005122 <sys_pipe+0xfc>
  fd0 = -1;
    8000505e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005062:	fd043503          	ld	a0,-48(s0)
    80005066:	fffff097          	auipc	ra,0xfffff
    8000506a:	518080e7          	jalr	1304(ra) # 8000457e <fdalloc>
    8000506e:	fca42223          	sw	a0,-60(s0)
    80005072:	08054b63          	bltz	a0,80005108 <sys_pipe+0xe2>
    80005076:	fc843503          	ld	a0,-56(s0)
    8000507a:	fffff097          	auipc	ra,0xfffff
    8000507e:	504080e7          	jalr	1284(ra) # 8000457e <fdalloc>
    80005082:	fca42023          	sw	a0,-64(s0)
    80005086:	06054863          	bltz	a0,800050f6 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000508a:	4691                	li	a3,4
    8000508c:	fc440613          	addi	a2,s0,-60
    80005090:	fd843583          	ld	a1,-40(s0)
    80005094:	68a8                	ld	a0,80(s1)
    80005096:	ffffc097          	auipc	ra,0xffffc
    8000509a:	aca080e7          	jalr	-1334(ra) # 80000b60 <copyout>
    8000509e:	02054063          	bltz	a0,800050be <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050a2:	4691                	li	a3,4
    800050a4:	fc040613          	addi	a2,s0,-64
    800050a8:	fd843583          	ld	a1,-40(s0)
    800050ac:	0591                	addi	a1,a1,4
    800050ae:	68a8                	ld	a0,80(s1)
    800050b0:	ffffc097          	auipc	ra,0xffffc
    800050b4:	ab0080e7          	jalr	-1360(ra) # 80000b60 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050b8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ba:	06055463          	bgez	a0,80005122 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800050be:	fc442783          	lw	a5,-60(s0)
    800050c2:	07e9                	addi	a5,a5,26
    800050c4:	078e                	slli	a5,a5,0x3
    800050c6:	97a6                	add	a5,a5,s1
    800050c8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050cc:	fc042503          	lw	a0,-64(s0)
    800050d0:	0569                	addi	a0,a0,26
    800050d2:	050e                	slli	a0,a0,0x3
    800050d4:	94aa                	add	s1,s1,a0
    800050d6:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800050da:	fd043503          	ld	a0,-48(s0)
    800050de:	fffff097          	auipc	ra,0xfffff
    800050e2:	a18080e7          	jalr	-1512(ra) # 80003af6 <fileclose>
    fileclose(wf);
    800050e6:	fc843503          	ld	a0,-56(s0)
    800050ea:	fffff097          	auipc	ra,0xfffff
    800050ee:	a0c080e7          	jalr	-1524(ra) # 80003af6 <fileclose>
    return -1;
    800050f2:	57fd                	li	a5,-1
    800050f4:	a03d                	j	80005122 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800050f6:	fc442783          	lw	a5,-60(s0)
    800050fa:	0007c763          	bltz	a5,80005108 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800050fe:	07e9                	addi	a5,a5,26
    80005100:	078e                	slli	a5,a5,0x3
    80005102:	94be                	add	s1,s1,a5
    80005104:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005108:	fd043503          	ld	a0,-48(s0)
    8000510c:	fffff097          	auipc	ra,0xfffff
    80005110:	9ea080e7          	jalr	-1558(ra) # 80003af6 <fileclose>
    fileclose(wf);
    80005114:	fc843503          	ld	a0,-56(s0)
    80005118:	fffff097          	auipc	ra,0xfffff
    8000511c:	9de080e7          	jalr	-1570(ra) # 80003af6 <fileclose>
    return -1;
    80005120:	57fd                	li	a5,-1
}
    80005122:	853e                	mv	a0,a5
    80005124:	70e2                	ld	ra,56(sp)
    80005126:	7442                	ld	s0,48(sp)
    80005128:	74a2                	ld	s1,40(sp)
    8000512a:	6121                	addi	sp,sp,64
    8000512c:	8082                	ret
	...

0000000080005130 <kernelvec>:
    80005130:	7111                	addi	sp,sp,-256
    80005132:	e006                	sd	ra,0(sp)
    80005134:	e40a                	sd	sp,8(sp)
    80005136:	e80e                	sd	gp,16(sp)
    80005138:	ec12                	sd	tp,24(sp)
    8000513a:	f016                	sd	t0,32(sp)
    8000513c:	f41a                	sd	t1,40(sp)
    8000513e:	f81e                	sd	t2,48(sp)
    80005140:	fc22                	sd	s0,56(sp)
    80005142:	e0a6                	sd	s1,64(sp)
    80005144:	e4aa                	sd	a0,72(sp)
    80005146:	e8ae                	sd	a1,80(sp)
    80005148:	ecb2                	sd	a2,88(sp)
    8000514a:	f0b6                	sd	a3,96(sp)
    8000514c:	f4ba                	sd	a4,104(sp)
    8000514e:	f8be                	sd	a5,112(sp)
    80005150:	fcc2                	sd	a6,120(sp)
    80005152:	e146                	sd	a7,128(sp)
    80005154:	e54a                	sd	s2,136(sp)
    80005156:	e94e                	sd	s3,144(sp)
    80005158:	ed52                	sd	s4,152(sp)
    8000515a:	f156                	sd	s5,160(sp)
    8000515c:	f55a                	sd	s6,168(sp)
    8000515e:	f95e                	sd	s7,176(sp)
    80005160:	fd62                	sd	s8,184(sp)
    80005162:	e1e6                	sd	s9,192(sp)
    80005164:	e5ea                	sd	s10,200(sp)
    80005166:	e9ee                	sd	s11,208(sp)
    80005168:	edf2                	sd	t3,216(sp)
    8000516a:	f1f6                	sd	t4,224(sp)
    8000516c:	f5fa                	sd	t5,232(sp)
    8000516e:	f9fe                	sd	t6,240(sp)
    80005170:	ce1fc0ef          	jal	ra,80001e50 <kerneltrap>
    80005174:	6082                	ld	ra,0(sp)
    80005176:	6122                	ld	sp,8(sp)
    80005178:	61c2                	ld	gp,16(sp)
    8000517a:	7282                	ld	t0,32(sp)
    8000517c:	7322                	ld	t1,40(sp)
    8000517e:	73c2                	ld	t2,48(sp)
    80005180:	7462                	ld	s0,56(sp)
    80005182:	6486                	ld	s1,64(sp)
    80005184:	6526                	ld	a0,72(sp)
    80005186:	65c6                	ld	a1,80(sp)
    80005188:	6666                	ld	a2,88(sp)
    8000518a:	7686                	ld	a3,96(sp)
    8000518c:	7726                	ld	a4,104(sp)
    8000518e:	77c6                	ld	a5,112(sp)
    80005190:	7866                	ld	a6,120(sp)
    80005192:	688a                	ld	a7,128(sp)
    80005194:	692a                	ld	s2,136(sp)
    80005196:	69ca                	ld	s3,144(sp)
    80005198:	6a6a                	ld	s4,152(sp)
    8000519a:	7a8a                	ld	s5,160(sp)
    8000519c:	7b2a                	ld	s6,168(sp)
    8000519e:	7bca                	ld	s7,176(sp)
    800051a0:	7c6a                	ld	s8,184(sp)
    800051a2:	6c8e                	ld	s9,192(sp)
    800051a4:	6d2e                	ld	s10,200(sp)
    800051a6:	6dce                	ld	s11,208(sp)
    800051a8:	6e6e                	ld	t3,216(sp)
    800051aa:	7e8e                	ld	t4,224(sp)
    800051ac:	7f2e                	ld	t5,232(sp)
    800051ae:	7fce                	ld	t6,240(sp)
    800051b0:	6111                	addi	sp,sp,256
    800051b2:	10200073          	sret
    800051b6:	00000013          	nop
    800051ba:	00000013          	nop
    800051be:	0001                	nop

00000000800051c0 <timervec>:
    800051c0:	34051573          	csrrw	a0,mscratch,a0
    800051c4:	e10c                	sd	a1,0(a0)
    800051c6:	e510                	sd	a2,8(a0)
    800051c8:	e914                	sd	a3,16(a0)
    800051ca:	6d0c                	ld	a1,24(a0)
    800051cc:	7110                	ld	a2,32(a0)
    800051ce:	6194                	ld	a3,0(a1)
    800051d0:	96b2                	add	a3,a3,a2
    800051d2:	e194                	sd	a3,0(a1)
    800051d4:	4589                	li	a1,2
    800051d6:	14459073          	csrw	sip,a1
    800051da:	6914                	ld	a3,16(a0)
    800051dc:	6510                	ld	a2,8(a0)
    800051de:	610c                	ld	a1,0(a0)
    800051e0:	34051573          	csrrw	a0,mscratch,a0
    800051e4:	30200073          	mret
	...

00000000800051ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051ea:	1141                	addi	sp,sp,-16
    800051ec:	e422                	sd	s0,8(sp)
    800051ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051f0:	0c0007b7          	lui	a5,0xc000
    800051f4:	4705                	li	a4,1
    800051f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051f8:	c3d8                	sw	a4,4(a5)
}
    800051fa:	6422                	ld	s0,8(sp)
    800051fc:	0141                	addi	sp,sp,16
    800051fe:	8082                	ret

0000000080005200 <plicinithart>:

void
plicinithart(void)
{
    80005200:	1141                	addi	sp,sp,-16
    80005202:	e406                	sd	ra,8(sp)
    80005204:	e022                	sd	s0,0(sp)
    80005206:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005208:	ffffc097          	auipc	ra,0xffffc
    8000520c:	ca2080e7          	jalr	-862(ra) # 80000eaa <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005210:	0085171b          	slliw	a4,a0,0x8
    80005214:	0c0027b7          	lui	a5,0xc002
    80005218:	97ba                	add	a5,a5,a4
    8000521a:	40200713          	li	a4,1026
    8000521e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005222:	00d5151b          	slliw	a0,a0,0xd
    80005226:	0c2017b7          	lui	a5,0xc201
    8000522a:	953e                	add	a0,a0,a5
    8000522c:	00052023          	sw	zero,0(a0)
}
    80005230:	60a2                	ld	ra,8(sp)
    80005232:	6402                	ld	s0,0(sp)
    80005234:	0141                	addi	sp,sp,16
    80005236:	8082                	ret

0000000080005238 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005238:	1141                	addi	sp,sp,-16
    8000523a:	e406                	sd	ra,8(sp)
    8000523c:	e022                	sd	s0,0(sp)
    8000523e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005240:	ffffc097          	auipc	ra,0xffffc
    80005244:	c6a080e7          	jalr	-918(ra) # 80000eaa <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005248:	00d5179b          	slliw	a5,a0,0xd
    8000524c:	0c201537          	lui	a0,0xc201
    80005250:	953e                	add	a0,a0,a5
  return irq;
}
    80005252:	4148                	lw	a0,4(a0)
    80005254:	60a2                	ld	ra,8(sp)
    80005256:	6402                	ld	s0,0(sp)
    80005258:	0141                	addi	sp,sp,16
    8000525a:	8082                	ret

000000008000525c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000525c:	1101                	addi	sp,sp,-32
    8000525e:	ec06                	sd	ra,24(sp)
    80005260:	e822                	sd	s0,16(sp)
    80005262:	e426                	sd	s1,8(sp)
    80005264:	1000                	addi	s0,sp,32
    80005266:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	c42080e7          	jalr	-958(ra) # 80000eaa <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005270:	00d5151b          	slliw	a0,a0,0xd
    80005274:	0c2017b7          	lui	a5,0xc201
    80005278:	97aa                	add	a5,a5,a0
    8000527a:	c3c4                	sw	s1,4(a5)
}
    8000527c:	60e2                	ld	ra,24(sp)
    8000527e:	6442                	ld	s0,16(sp)
    80005280:	64a2                	ld	s1,8(sp)
    80005282:	6105                	addi	sp,sp,32
    80005284:	8082                	ret

0000000080005286 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005286:	1141                	addi	sp,sp,-16
    80005288:	e406                	sd	ra,8(sp)
    8000528a:	e022                	sd	s0,0(sp)
    8000528c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000528e:	479d                	li	a5,7
    80005290:	04a7cc63          	blt	a5,a0,800052e8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005294:	00015797          	auipc	a5,0x15
    80005298:	afc78793          	addi	a5,a5,-1284 # 80019d90 <disk>
    8000529c:	97aa                	add	a5,a5,a0
    8000529e:	0187c783          	lbu	a5,24(a5)
    800052a2:	ebb9                	bnez	a5,800052f8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052a4:	00451613          	slli	a2,a0,0x4
    800052a8:	00015797          	auipc	a5,0x15
    800052ac:	ae878793          	addi	a5,a5,-1304 # 80019d90 <disk>
    800052b0:	6394                	ld	a3,0(a5)
    800052b2:	96b2                	add	a3,a3,a2
    800052b4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052b8:	6398                	ld	a4,0(a5)
    800052ba:	9732                	add	a4,a4,a2
    800052bc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800052c0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800052c4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052c8:	953e                	add	a0,a0,a5
    800052ca:	4785                	li	a5,1
    800052cc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800052d0:	00015517          	auipc	a0,0x15
    800052d4:	ad850513          	addi	a0,a0,-1320 # 80019da8 <disk+0x18>
    800052d8:	ffffc097          	auipc	ra,0xffffc
    800052dc:	312080e7          	jalr	786(ra) # 800015ea <wakeup>
}
    800052e0:	60a2                	ld	ra,8(sp)
    800052e2:	6402                	ld	s0,0(sp)
    800052e4:	0141                	addi	sp,sp,16
    800052e6:	8082                	ret
    panic("free_desc 1");
    800052e8:	00003517          	auipc	a0,0x3
    800052ec:	4e850513          	addi	a0,a0,1256 # 800087d0 <syscalls+0x2f8>
    800052f0:	00001097          	auipc	ra,0x1
    800052f4:	a72080e7          	jalr	-1422(ra) # 80005d62 <panic>
    panic("free_desc 2");
    800052f8:	00003517          	auipc	a0,0x3
    800052fc:	4e850513          	addi	a0,a0,1256 # 800087e0 <syscalls+0x308>
    80005300:	00001097          	auipc	ra,0x1
    80005304:	a62080e7          	jalr	-1438(ra) # 80005d62 <panic>

0000000080005308 <virtio_disk_init>:
{
    80005308:	1101                	addi	sp,sp,-32
    8000530a:	ec06                	sd	ra,24(sp)
    8000530c:	e822                	sd	s0,16(sp)
    8000530e:	e426                	sd	s1,8(sp)
    80005310:	e04a                	sd	s2,0(sp)
    80005312:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005314:	00003597          	auipc	a1,0x3
    80005318:	4dc58593          	addi	a1,a1,1244 # 800087f0 <syscalls+0x318>
    8000531c:	00015517          	auipc	a0,0x15
    80005320:	b9c50513          	addi	a0,a0,-1124 # 80019eb8 <disk+0x128>
    80005324:	00001097          	auipc	ra,0x1
    80005328:	ef8080e7          	jalr	-264(ra) # 8000621c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000532c:	100017b7          	lui	a5,0x10001
    80005330:	4398                	lw	a4,0(a5)
    80005332:	2701                	sext.w	a4,a4
    80005334:	747277b7          	lui	a5,0x74727
    80005338:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000533c:	14f71e63          	bne	a4,a5,80005498 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005340:	100017b7          	lui	a5,0x10001
    80005344:	43dc                	lw	a5,4(a5)
    80005346:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005348:	4709                	li	a4,2
    8000534a:	14e79763          	bne	a5,a4,80005498 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000534e:	100017b7          	lui	a5,0x10001
    80005352:	479c                	lw	a5,8(a5)
    80005354:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005356:	14e79163          	bne	a5,a4,80005498 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000535a:	100017b7          	lui	a5,0x10001
    8000535e:	47d8                	lw	a4,12(a5)
    80005360:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005362:	554d47b7          	lui	a5,0x554d4
    80005366:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000536a:	12f71763          	bne	a4,a5,80005498 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000536e:	100017b7          	lui	a5,0x10001
    80005372:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005376:	4705                	li	a4,1
    80005378:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000537a:	470d                	li	a4,3
    8000537c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000537e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005380:	c7ffe737          	lui	a4,0xc7ffe
    80005384:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc64f>
    80005388:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000538a:	2701                	sext.w	a4,a4
    8000538c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000538e:	472d                	li	a4,11
    80005390:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005392:	0707a903          	lw	s2,112(a5)
    80005396:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005398:	00897793          	andi	a5,s2,8
    8000539c:	10078663          	beqz	a5,800054a8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053a0:	100017b7          	lui	a5,0x10001
    800053a4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800053a8:	43fc                	lw	a5,68(a5)
    800053aa:	2781                	sext.w	a5,a5
    800053ac:	10079663          	bnez	a5,800054b8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053b0:	100017b7          	lui	a5,0x10001
    800053b4:	5bdc                	lw	a5,52(a5)
    800053b6:	2781                	sext.w	a5,a5
  if(max == 0)
    800053b8:	10078863          	beqz	a5,800054c8 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800053bc:	471d                	li	a4,7
    800053be:	10f77d63          	bgeu	a4,a5,800054d8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800053c2:	ffffb097          	auipc	ra,0xffffb
    800053c6:	d56080e7          	jalr	-682(ra) # 80000118 <kalloc>
    800053ca:	00015497          	auipc	s1,0x15
    800053ce:	9c648493          	addi	s1,s1,-1594 # 80019d90 <disk>
    800053d2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800053d4:	ffffb097          	auipc	ra,0xffffb
    800053d8:	d44080e7          	jalr	-700(ra) # 80000118 <kalloc>
    800053dc:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800053de:	ffffb097          	auipc	ra,0xffffb
    800053e2:	d3a080e7          	jalr	-710(ra) # 80000118 <kalloc>
    800053e6:	87aa                	mv	a5,a0
    800053e8:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800053ea:	6088                	ld	a0,0(s1)
    800053ec:	cd75                	beqz	a0,800054e8 <virtio_disk_init+0x1e0>
    800053ee:	00015717          	auipc	a4,0x15
    800053f2:	9aa73703          	ld	a4,-1622(a4) # 80019d98 <disk+0x8>
    800053f6:	cb6d                	beqz	a4,800054e8 <virtio_disk_init+0x1e0>
    800053f8:	cbe5                	beqz	a5,800054e8 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    800053fa:	6605                	lui	a2,0x1
    800053fc:	4581                	li	a1,0
    800053fe:	ffffb097          	auipc	ra,0xffffb
    80005402:	da0080e7          	jalr	-608(ra) # 8000019e <memset>
  memset(disk.avail, 0, PGSIZE);
    80005406:	00015497          	auipc	s1,0x15
    8000540a:	98a48493          	addi	s1,s1,-1654 # 80019d90 <disk>
    8000540e:	6605                	lui	a2,0x1
    80005410:	4581                	li	a1,0
    80005412:	6488                	ld	a0,8(s1)
    80005414:	ffffb097          	auipc	ra,0xffffb
    80005418:	d8a080e7          	jalr	-630(ra) # 8000019e <memset>
  memset(disk.used, 0, PGSIZE);
    8000541c:	6605                	lui	a2,0x1
    8000541e:	4581                	li	a1,0
    80005420:	6888                	ld	a0,16(s1)
    80005422:	ffffb097          	auipc	ra,0xffffb
    80005426:	d7c080e7          	jalr	-644(ra) # 8000019e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000542a:	100017b7          	lui	a5,0x10001
    8000542e:	4721                	li	a4,8
    80005430:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005432:	4098                	lw	a4,0(s1)
    80005434:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005438:	40d8                	lw	a4,4(s1)
    8000543a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000543e:	6498                	ld	a4,8(s1)
    80005440:	0007069b          	sext.w	a3,a4
    80005444:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005448:	9701                	srai	a4,a4,0x20
    8000544a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000544e:	6898                	ld	a4,16(s1)
    80005450:	0007069b          	sext.w	a3,a4
    80005454:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005458:	9701                	srai	a4,a4,0x20
    8000545a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000545e:	4685                	li	a3,1
    80005460:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005462:	4705                	li	a4,1
    80005464:	00d48c23          	sb	a3,24(s1)
    80005468:	00e48ca3          	sb	a4,25(s1)
    8000546c:	00e48d23          	sb	a4,26(s1)
    80005470:	00e48da3          	sb	a4,27(s1)
    80005474:	00e48e23          	sb	a4,28(s1)
    80005478:	00e48ea3          	sb	a4,29(s1)
    8000547c:	00e48f23          	sb	a4,30(s1)
    80005480:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005484:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005488:	0727a823          	sw	s2,112(a5)
}
    8000548c:	60e2                	ld	ra,24(sp)
    8000548e:	6442                	ld	s0,16(sp)
    80005490:	64a2                	ld	s1,8(sp)
    80005492:	6902                	ld	s2,0(sp)
    80005494:	6105                	addi	sp,sp,32
    80005496:	8082                	ret
    panic("could not find virtio disk");
    80005498:	00003517          	auipc	a0,0x3
    8000549c:	36850513          	addi	a0,a0,872 # 80008800 <syscalls+0x328>
    800054a0:	00001097          	auipc	ra,0x1
    800054a4:	8c2080e7          	jalr	-1854(ra) # 80005d62 <panic>
    panic("virtio disk FEATURES_OK unset");
    800054a8:	00003517          	auipc	a0,0x3
    800054ac:	37850513          	addi	a0,a0,888 # 80008820 <syscalls+0x348>
    800054b0:	00001097          	auipc	ra,0x1
    800054b4:	8b2080e7          	jalr	-1870(ra) # 80005d62 <panic>
    panic("virtio disk should not be ready");
    800054b8:	00003517          	auipc	a0,0x3
    800054bc:	38850513          	addi	a0,a0,904 # 80008840 <syscalls+0x368>
    800054c0:	00001097          	auipc	ra,0x1
    800054c4:	8a2080e7          	jalr	-1886(ra) # 80005d62 <panic>
    panic("virtio disk has no queue 0");
    800054c8:	00003517          	auipc	a0,0x3
    800054cc:	39850513          	addi	a0,a0,920 # 80008860 <syscalls+0x388>
    800054d0:	00001097          	auipc	ra,0x1
    800054d4:	892080e7          	jalr	-1902(ra) # 80005d62 <panic>
    panic("virtio disk max queue too short");
    800054d8:	00003517          	auipc	a0,0x3
    800054dc:	3a850513          	addi	a0,a0,936 # 80008880 <syscalls+0x3a8>
    800054e0:	00001097          	auipc	ra,0x1
    800054e4:	882080e7          	jalr	-1918(ra) # 80005d62 <panic>
    panic("virtio disk kalloc");
    800054e8:	00003517          	auipc	a0,0x3
    800054ec:	3b850513          	addi	a0,a0,952 # 800088a0 <syscalls+0x3c8>
    800054f0:	00001097          	auipc	ra,0x1
    800054f4:	872080e7          	jalr	-1934(ra) # 80005d62 <panic>

00000000800054f8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054f8:	7159                	addi	sp,sp,-112
    800054fa:	f486                	sd	ra,104(sp)
    800054fc:	f0a2                	sd	s0,96(sp)
    800054fe:	eca6                	sd	s1,88(sp)
    80005500:	e8ca                	sd	s2,80(sp)
    80005502:	e4ce                	sd	s3,72(sp)
    80005504:	e0d2                	sd	s4,64(sp)
    80005506:	fc56                	sd	s5,56(sp)
    80005508:	f85a                	sd	s6,48(sp)
    8000550a:	f45e                	sd	s7,40(sp)
    8000550c:	f062                	sd	s8,32(sp)
    8000550e:	ec66                	sd	s9,24(sp)
    80005510:	e86a                	sd	s10,16(sp)
    80005512:	1880                	addi	s0,sp,112
    80005514:	892a                	mv	s2,a0
    80005516:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005518:	00c52c83          	lw	s9,12(a0)
    8000551c:	001c9c9b          	slliw	s9,s9,0x1
    80005520:	1c82                	slli	s9,s9,0x20
    80005522:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005526:	00015517          	auipc	a0,0x15
    8000552a:	99250513          	addi	a0,a0,-1646 # 80019eb8 <disk+0x128>
    8000552e:	00001097          	auipc	ra,0x1
    80005532:	d7e080e7          	jalr	-642(ra) # 800062ac <acquire>
  for(int i = 0; i < 3; i++){
    80005536:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005538:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000553a:	00015b17          	auipc	s6,0x15
    8000553e:	856b0b13          	addi	s6,s6,-1962 # 80019d90 <disk>
  for(int i = 0; i < 3; i++){
    80005542:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005544:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005546:	00015c17          	auipc	s8,0x15
    8000554a:	972c0c13          	addi	s8,s8,-1678 # 80019eb8 <disk+0x128>
    8000554e:	a8b5                	j	800055ca <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005550:	00fb06b3          	add	a3,s6,a5
    80005554:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005558:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000555a:	0207c563          	bltz	a5,80005584 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000555e:	2485                	addiw	s1,s1,1
    80005560:	0711                	addi	a4,a4,4
    80005562:	1f548a63          	beq	s1,s5,80005756 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005566:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005568:	00015697          	auipc	a3,0x15
    8000556c:	82868693          	addi	a3,a3,-2008 # 80019d90 <disk>
    80005570:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005572:	0186c583          	lbu	a1,24(a3)
    80005576:	fde9                	bnez	a1,80005550 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005578:	2785                	addiw	a5,a5,1
    8000557a:	0685                	addi	a3,a3,1
    8000557c:	ff779be3          	bne	a5,s7,80005572 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005580:	57fd                	li	a5,-1
    80005582:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005584:	02905a63          	blez	s1,800055b8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005588:	f9042503          	lw	a0,-112(s0)
    8000558c:	00000097          	auipc	ra,0x0
    80005590:	cfa080e7          	jalr	-774(ra) # 80005286 <free_desc>
      for(int j = 0; j < i; j++)
    80005594:	4785                	li	a5,1
    80005596:	0297d163          	bge	a5,s1,800055b8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000559a:	f9442503          	lw	a0,-108(s0)
    8000559e:	00000097          	auipc	ra,0x0
    800055a2:	ce8080e7          	jalr	-792(ra) # 80005286 <free_desc>
      for(int j = 0; j < i; j++)
    800055a6:	4789                	li	a5,2
    800055a8:	0097d863          	bge	a5,s1,800055b8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800055ac:	f9842503          	lw	a0,-104(s0)
    800055b0:	00000097          	auipc	ra,0x0
    800055b4:	cd6080e7          	jalr	-810(ra) # 80005286 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055b8:	85e2                	mv	a1,s8
    800055ba:	00014517          	auipc	a0,0x14
    800055be:	7ee50513          	addi	a0,a0,2030 # 80019da8 <disk+0x18>
    800055c2:	ffffc097          	auipc	ra,0xffffc
    800055c6:	fc4080e7          	jalr	-60(ra) # 80001586 <sleep>
  for(int i = 0; i < 3; i++){
    800055ca:	f9040713          	addi	a4,s0,-112
    800055ce:	84ce                	mv	s1,s3
    800055d0:	bf59                	j	80005566 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055d2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800055d6:	00479693          	slli	a3,a5,0x4
    800055da:	00014797          	auipc	a5,0x14
    800055de:	7b678793          	addi	a5,a5,1974 # 80019d90 <disk>
    800055e2:	97b6                	add	a5,a5,a3
    800055e4:	4685                	li	a3,1
    800055e6:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055e8:	00014597          	auipc	a1,0x14
    800055ec:	7a858593          	addi	a1,a1,1960 # 80019d90 <disk>
    800055f0:	00a60793          	addi	a5,a2,10
    800055f4:	0792                	slli	a5,a5,0x4
    800055f6:	97ae                	add	a5,a5,a1
    800055f8:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    800055fc:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005600:	f6070693          	addi	a3,a4,-160
    80005604:	619c                	ld	a5,0(a1)
    80005606:	97b6                	add	a5,a5,a3
    80005608:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000560a:	6188                	ld	a0,0(a1)
    8000560c:	96aa                	add	a3,a3,a0
    8000560e:	47c1                	li	a5,16
    80005610:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005612:	4785                	li	a5,1
    80005614:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005618:	f9442783          	lw	a5,-108(s0)
    8000561c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005620:	0792                	slli	a5,a5,0x4
    80005622:	953e                	add	a0,a0,a5
    80005624:	05890693          	addi	a3,s2,88
    80005628:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000562a:	6188                	ld	a0,0(a1)
    8000562c:	97aa                	add	a5,a5,a0
    8000562e:	40000693          	li	a3,1024
    80005632:	c794                	sw	a3,8(a5)
  if(write)
    80005634:	100d0d63          	beqz	s10,8000574e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005638:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000563c:	00c7d683          	lhu	a3,12(a5)
    80005640:	0016e693          	ori	a3,a3,1
    80005644:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005648:	f9842583          	lw	a1,-104(s0)
    8000564c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005650:	00014697          	auipc	a3,0x14
    80005654:	74068693          	addi	a3,a3,1856 # 80019d90 <disk>
    80005658:	00260793          	addi	a5,a2,2
    8000565c:	0792                	slli	a5,a5,0x4
    8000565e:	97b6                	add	a5,a5,a3
    80005660:	587d                	li	a6,-1
    80005662:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005666:	0592                	slli	a1,a1,0x4
    80005668:	952e                	add	a0,a0,a1
    8000566a:	f9070713          	addi	a4,a4,-112
    8000566e:	9736                	add	a4,a4,a3
    80005670:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005672:	6298                	ld	a4,0(a3)
    80005674:	972e                	add	a4,a4,a1
    80005676:	4585                	li	a1,1
    80005678:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000567a:	4509                	li	a0,2
    8000567c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005680:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005684:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005688:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000568c:	6698                	ld	a4,8(a3)
    8000568e:	00275783          	lhu	a5,2(a4)
    80005692:	8b9d                	andi	a5,a5,7
    80005694:	0786                	slli	a5,a5,0x1
    80005696:	97ba                	add	a5,a5,a4
    80005698:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000569c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056a0:	6698                	ld	a4,8(a3)
    800056a2:	00275783          	lhu	a5,2(a4)
    800056a6:	2785                	addiw	a5,a5,1
    800056a8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056ac:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056b0:	100017b7          	lui	a5,0x10001
    800056b4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056b8:	00492703          	lw	a4,4(s2)
    800056bc:	4785                	li	a5,1
    800056be:	02f71163          	bne	a4,a5,800056e0 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800056c2:	00014997          	auipc	s3,0x14
    800056c6:	7f698993          	addi	s3,s3,2038 # 80019eb8 <disk+0x128>
  while(b->disk == 1) {
    800056ca:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056cc:	85ce                	mv	a1,s3
    800056ce:	854a                	mv	a0,s2
    800056d0:	ffffc097          	auipc	ra,0xffffc
    800056d4:	eb6080e7          	jalr	-330(ra) # 80001586 <sleep>
  while(b->disk == 1) {
    800056d8:	00492783          	lw	a5,4(s2)
    800056dc:	fe9788e3          	beq	a5,s1,800056cc <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    800056e0:	f9042903          	lw	s2,-112(s0)
    800056e4:	00290793          	addi	a5,s2,2
    800056e8:	00479713          	slli	a4,a5,0x4
    800056ec:	00014797          	auipc	a5,0x14
    800056f0:	6a478793          	addi	a5,a5,1700 # 80019d90 <disk>
    800056f4:	97ba                	add	a5,a5,a4
    800056f6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800056fa:	00014997          	auipc	s3,0x14
    800056fe:	69698993          	addi	s3,s3,1686 # 80019d90 <disk>
    80005702:	00491713          	slli	a4,s2,0x4
    80005706:	0009b783          	ld	a5,0(s3)
    8000570a:	97ba                	add	a5,a5,a4
    8000570c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005710:	854a                	mv	a0,s2
    80005712:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005716:	00000097          	auipc	ra,0x0
    8000571a:	b70080e7          	jalr	-1168(ra) # 80005286 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000571e:	8885                	andi	s1,s1,1
    80005720:	f0ed                	bnez	s1,80005702 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005722:	00014517          	auipc	a0,0x14
    80005726:	79650513          	addi	a0,a0,1942 # 80019eb8 <disk+0x128>
    8000572a:	00001097          	auipc	ra,0x1
    8000572e:	c36080e7          	jalr	-970(ra) # 80006360 <release>
}
    80005732:	70a6                	ld	ra,104(sp)
    80005734:	7406                	ld	s0,96(sp)
    80005736:	64e6                	ld	s1,88(sp)
    80005738:	6946                	ld	s2,80(sp)
    8000573a:	69a6                	ld	s3,72(sp)
    8000573c:	6a06                	ld	s4,64(sp)
    8000573e:	7ae2                	ld	s5,56(sp)
    80005740:	7b42                	ld	s6,48(sp)
    80005742:	7ba2                	ld	s7,40(sp)
    80005744:	7c02                	ld	s8,32(sp)
    80005746:	6ce2                	ld	s9,24(sp)
    80005748:	6d42                	ld	s10,16(sp)
    8000574a:	6165                	addi	sp,sp,112
    8000574c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000574e:	4689                	li	a3,2
    80005750:	00d79623          	sh	a3,12(a5)
    80005754:	b5e5                	j	8000563c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005756:	f9042603          	lw	a2,-112(s0)
    8000575a:	00a60713          	addi	a4,a2,10
    8000575e:	0712                	slli	a4,a4,0x4
    80005760:	00014517          	auipc	a0,0x14
    80005764:	63850513          	addi	a0,a0,1592 # 80019d98 <disk+0x8>
    80005768:	953a                	add	a0,a0,a4
  if(write)
    8000576a:	e60d14e3          	bnez	s10,800055d2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000576e:	00a60793          	addi	a5,a2,10
    80005772:	00479693          	slli	a3,a5,0x4
    80005776:	00014797          	auipc	a5,0x14
    8000577a:	61a78793          	addi	a5,a5,1562 # 80019d90 <disk>
    8000577e:	97b6                	add	a5,a5,a3
    80005780:	0007a423          	sw	zero,8(a5)
    80005784:	b595                	j	800055e8 <virtio_disk_rw+0xf0>

0000000080005786 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005786:	1101                	addi	sp,sp,-32
    80005788:	ec06                	sd	ra,24(sp)
    8000578a:	e822                	sd	s0,16(sp)
    8000578c:	e426                	sd	s1,8(sp)
    8000578e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005790:	00014497          	auipc	s1,0x14
    80005794:	60048493          	addi	s1,s1,1536 # 80019d90 <disk>
    80005798:	00014517          	auipc	a0,0x14
    8000579c:	72050513          	addi	a0,a0,1824 # 80019eb8 <disk+0x128>
    800057a0:	00001097          	auipc	ra,0x1
    800057a4:	b0c080e7          	jalr	-1268(ra) # 800062ac <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057a8:	10001737          	lui	a4,0x10001
    800057ac:	533c                	lw	a5,96(a4)
    800057ae:	8b8d                	andi	a5,a5,3
    800057b0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057b2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057b6:	689c                	ld	a5,16(s1)
    800057b8:	0204d703          	lhu	a4,32(s1)
    800057bc:	0027d783          	lhu	a5,2(a5)
    800057c0:	04f70863          	beq	a4,a5,80005810 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800057c4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057c8:	6898                	ld	a4,16(s1)
    800057ca:	0204d783          	lhu	a5,32(s1)
    800057ce:	8b9d                	andi	a5,a5,7
    800057d0:	078e                	slli	a5,a5,0x3
    800057d2:	97ba                	add	a5,a5,a4
    800057d4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057d6:	00278713          	addi	a4,a5,2
    800057da:	0712                	slli	a4,a4,0x4
    800057dc:	9726                	add	a4,a4,s1
    800057de:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800057e2:	e721                	bnez	a4,8000582a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057e4:	0789                	addi	a5,a5,2
    800057e6:	0792                	slli	a5,a5,0x4
    800057e8:	97a6                	add	a5,a5,s1
    800057ea:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800057ec:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057f0:	ffffc097          	auipc	ra,0xffffc
    800057f4:	dfa080e7          	jalr	-518(ra) # 800015ea <wakeup>

    disk.used_idx += 1;
    800057f8:	0204d783          	lhu	a5,32(s1)
    800057fc:	2785                	addiw	a5,a5,1
    800057fe:	17c2                	slli	a5,a5,0x30
    80005800:	93c1                	srli	a5,a5,0x30
    80005802:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005806:	6898                	ld	a4,16(s1)
    80005808:	00275703          	lhu	a4,2(a4)
    8000580c:	faf71ce3          	bne	a4,a5,800057c4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005810:	00014517          	auipc	a0,0x14
    80005814:	6a850513          	addi	a0,a0,1704 # 80019eb8 <disk+0x128>
    80005818:	00001097          	auipc	ra,0x1
    8000581c:	b48080e7          	jalr	-1208(ra) # 80006360 <release>
}
    80005820:	60e2                	ld	ra,24(sp)
    80005822:	6442                	ld	s0,16(sp)
    80005824:	64a2                	ld	s1,8(sp)
    80005826:	6105                	addi	sp,sp,32
    80005828:	8082                	ret
      panic("virtio_disk_intr status");
    8000582a:	00003517          	auipc	a0,0x3
    8000582e:	08e50513          	addi	a0,a0,142 # 800088b8 <syscalls+0x3e0>
    80005832:	00000097          	auipc	ra,0x0
    80005836:	530080e7          	jalr	1328(ra) # 80005d62 <panic>

000000008000583a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000583a:	1141                	addi	sp,sp,-16
    8000583c:	e422                	sd	s0,8(sp)
    8000583e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005840:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005844:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005848:	0037979b          	slliw	a5,a5,0x3
    8000584c:	02004737          	lui	a4,0x2004
    80005850:	97ba                	add	a5,a5,a4
    80005852:	0200c737          	lui	a4,0x200c
    80005856:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000585a:	000f4637          	lui	a2,0xf4
    8000585e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005862:	95b2                	add	a1,a1,a2
    80005864:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005866:	00269713          	slli	a4,a3,0x2
    8000586a:	9736                	add	a4,a4,a3
    8000586c:	00371693          	slli	a3,a4,0x3
    80005870:	00014717          	auipc	a4,0x14
    80005874:	66070713          	addi	a4,a4,1632 # 80019ed0 <timer_scratch>
    80005878:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000587a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000587c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000587e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005882:	00000797          	auipc	a5,0x0
    80005886:	93e78793          	addi	a5,a5,-1730 # 800051c0 <timervec>
    8000588a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000588e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005892:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005896:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000589a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000589e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058a2:	30479073          	csrw	mie,a5
}
    800058a6:	6422                	ld	s0,8(sp)
    800058a8:	0141                	addi	sp,sp,16
    800058aa:	8082                	ret

00000000800058ac <start>:
{
    800058ac:	1141                	addi	sp,sp,-16
    800058ae:	e406                	sd	ra,8(sp)
    800058b0:	e022                	sd	s0,0(sp)
    800058b2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058b4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058b8:	7779                	lui	a4,0xffffe
    800058ba:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc6ef>
    800058be:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058c0:	6705                	lui	a4,0x1
    800058c2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058c6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058c8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058cc:	ffffb797          	auipc	a5,0xffffb
    800058d0:	a8078793          	addi	a5,a5,-1408 # 8000034c <main>
    800058d4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058d8:	4781                	li	a5,0
    800058da:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058de:	67c1                	lui	a5,0x10
    800058e0:	17fd                	addi	a5,a5,-1
    800058e2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058e6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058ea:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058ee:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058f2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058f6:	57fd                	li	a5,-1
    800058f8:	83a9                	srli	a5,a5,0xa
    800058fa:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058fe:	47bd                	li	a5,15
    80005900:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005904:	00000097          	auipc	ra,0x0
    80005908:	f36080e7          	jalr	-202(ra) # 8000583a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000590c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005910:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005912:	823e                	mv	tp,a5
  asm volatile("mret");
    80005914:	30200073          	mret
}
    80005918:	60a2                	ld	ra,8(sp)
    8000591a:	6402                	ld	s0,0(sp)
    8000591c:	0141                	addi	sp,sp,16
    8000591e:	8082                	ret

0000000080005920 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005920:	715d                	addi	sp,sp,-80
    80005922:	e486                	sd	ra,72(sp)
    80005924:	e0a2                	sd	s0,64(sp)
    80005926:	fc26                	sd	s1,56(sp)
    80005928:	f84a                	sd	s2,48(sp)
    8000592a:	f44e                	sd	s3,40(sp)
    8000592c:	f052                	sd	s4,32(sp)
    8000592e:	ec56                	sd	s5,24(sp)
    80005930:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005932:	04c05663          	blez	a2,8000597e <consolewrite+0x5e>
    80005936:	8a2a                	mv	s4,a0
    80005938:	84ae                	mv	s1,a1
    8000593a:	89b2                	mv	s3,a2
    8000593c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000593e:	5afd                	li	s5,-1
    80005940:	4685                	li	a3,1
    80005942:	8626                	mv	a2,s1
    80005944:	85d2                	mv	a1,s4
    80005946:	fbf40513          	addi	a0,s0,-65
    8000594a:	ffffc097          	auipc	ra,0xffffc
    8000594e:	09a080e7          	jalr	154(ra) # 800019e4 <either_copyin>
    80005952:	01550c63          	beq	a0,s5,8000596a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005956:	fbf44503          	lbu	a0,-65(s0)
    8000595a:	00000097          	auipc	ra,0x0
    8000595e:	794080e7          	jalr	1940(ra) # 800060ee <uartputc>
  for(i = 0; i < n; i++){
    80005962:	2905                	addiw	s2,s2,1
    80005964:	0485                	addi	s1,s1,1
    80005966:	fd299de3          	bne	s3,s2,80005940 <consolewrite+0x20>
  }

  return i;
}
    8000596a:	854a                	mv	a0,s2
    8000596c:	60a6                	ld	ra,72(sp)
    8000596e:	6406                	ld	s0,64(sp)
    80005970:	74e2                	ld	s1,56(sp)
    80005972:	7942                	ld	s2,48(sp)
    80005974:	79a2                	ld	s3,40(sp)
    80005976:	7a02                	ld	s4,32(sp)
    80005978:	6ae2                	ld	s5,24(sp)
    8000597a:	6161                	addi	sp,sp,80
    8000597c:	8082                	ret
  for(i = 0; i < n; i++){
    8000597e:	4901                	li	s2,0
    80005980:	b7ed                	j	8000596a <consolewrite+0x4a>

0000000080005982 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005982:	7119                	addi	sp,sp,-128
    80005984:	fc86                	sd	ra,120(sp)
    80005986:	f8a2                	sd	s0,112(sp)
    80005988:	f4a6                	sd	s1,104(sp)
    8000598a:	f0ca                	sd	s2,96(sp)
    8000598c:	ecce                	sd	s3,88(sp)
    8000598e:	e8d2                	sd	s4,80(sp)
    80005990:	e4d6                	sd	s5,72(sp)
    80005992:	e0da                	sd	s6,64(sp)
    80005994:	fc5e                	sd	s7,56(sp)
    80005996:	f862                	sd	s8,48(sp)
    80005998:	f466                	sd	s9,40(sp)
    8000599a:	f06a                	sd	s10,32(sp)
    8000599c:	ec6e                	sd	s11,24(sp)
    8000599e:	0100                	addi	s0,sp,128
    800059a0:	8b2a                	mv	s6,a0
    800059a2:	8aae                	mv	s5,a1
    800059a4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059a6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800059aa:	0001c517          	auipc	a0,0x1c
    800059ae:	66650513          	addi	a0,a0,1638 # 80022010 <cons>
    800059b2:	00001097          	auipc	ra,0x1
    800059b6:	8fa080e7          	jalr	-1798(ra) # 800062ac <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059ba:	0001c497          	auipc	s1,0x1c
    800059be:	65648493          	addi	s1,s1,1622 # 80022010 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059c2:	89a6                	mv	s3,s1
    800059c4:	0001c917          	auipc	s2,0x1c
    800059c8:	6e490913          	addi	s2,s2,1764 # 800220a8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800059cc:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059ce:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059d0:	4da9                	li	s11,10
  while(n > 0){
    800059d2:	07405b63          	blez	s4,80005a48 <consoleread+0xc6>
    while(cons.r == cons.w){
    800059d6:	0984a783          	lw	a5,152(s1)
    800059da:	09c4a703          	lw	a4,156(s1)
    800059de:	02f71763          	bne	a4,a5,80005a0c <consoleread+0x8a>
      if(killed(myproc())){
    800059e2:	ffffb097          	auipc	ra,0xffffb
    800059e6:	4f4080e7          	jalr	1268(ra) # 80000ed6 <myproc>
    800059ea:	ffffc097          	auipc	ra,0xffffc
    800059ee:	e44080e7          	jalr	-444(ra) # 8000182e <killed>
    800059f2:	e535                	bnez	a0,80005a5e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    800059f4:	85ce                	mv	a1,s3
    800059f6:	854a                	mv	a0,s2
    800059f8:	ffffc097          	auipc	ra,0xffffc
    800059fc:	b8e080e7          	jalr	-1138(ra) # 80001586 <sleep>
    while(cons.r == cons.w){
    80005a00:	0984a783          	lw	a5,152(s1)
    80005a04:	09c4a703          	lw	a4,156(s1)
    80005a08:	fcf70de3          	beq	a4,a5,800059e2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005a0c:	0017871b          	addiw	a4,a5,1
    80005a10:	08e4ac23          	sw	a4,152(s1)
    80005a14:	07f7f713          	andi	a4,a5,127
    80005a18:	9726                	add	a4,a4,s1
    80005a1a:	01874703          	lbu	a4,24(a4)
    80005a1e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a22:	079c0663          	beq	s8,s9,80005a8e <consoleread+0x10c>
    cbuf = c;
    80005a26:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a2a:	4685                	li	a3,1
    80005a2c:	f8f40613          	addi	a2,s0,-113
    80005a30:	85d6                	mv	a1,s5
    80005a32:	855a                	mv	a0,s6
    80005a34:	ffffc097          	auipc	ra,0xffffc
    80005a38:	f5a080e7          	jalr	-166(ra) # 8000198e <either_copyout>
    80005a3c:	01a50663          	beq	a0,s10,80005a48 <consoleread+0xc6>
    dst++;
    80005a40:	0a85                	addi	s5,s5,1
    --n;
    80005a42:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a44:	f9bc17e3          	bne	s8,s11,800059d2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a48:	0001c517          	auipc	a0,0x1c
    80005a4c:	5c850513          	addi	a0,a0,1480 # 80022010 <cons>
    80005a50:	00001097          	auipc	ra,0x1
    80005a54:	910080e7          	jalr	-1776(ra) # 80006360 <release>

  return target - n;
    80005a58:	414b853b          	subw	a0,s7,s4
    80005a5c:	a811                	j	80005a70 <consoleread+0xee>
        release(&cons.lock);
    80005a5e:	0001c517          	auipc	a0,0x1c
    80005a62:	5b250513          	addi	a0,a0,1458 # 80022010 <cons>
    80005a66:	00001097          	auipc	ra,0x1
    80005a6a:	8fa080e7          	jalr	-1798(ra) # 80006360 <release>
        return -1;
    80005a6e:	557d                	li	a0,-1
}
    80005a70:	70e6                	ld	ra,120(sp)
    80005a72:	7446                	ld	s0,112(sp)
    80005a74:	74a6                	ld	s1,104(sp)
    80005a76:	7906                	ld	s2,96(sp)
    80005a78:	69e6                	ld	s3,88(sp)
    80005a7a:	6a46                	ld	s4,80(sp)
    80005a7c:	6aa6                	ld	s5,72(sp)
    80005a7e:	6b06                	ld	s6,64(sp)
    80005a80:	7be2                	ld	s7,56(sp)
    80005a82:	7c42                	ld	s8,48(sp)
    80005a84:	7ca2                	ld	s9,40(sp)
    80005a86:	7d02                	ld	s10,32(sp)
    80005a88:	6de2                	ld	s11,24(sp)
    80005a8a:	6109                	addi	sp,sp,128
    80005a8c:	8082                	ret
      if(n < target){
    80005a8e:	000a071b          	sext.w	a4,s4
    80005a92:	fb777be3          	bgeu	a4,s7,80005a48 <consoleread+0xc6>
        cons.r--;
    80005a96:	0001c717          	auipc	a4,0x1c
    80005a9a:	60f72923          	sw	a5,1554(a4) # 800220a8 <cons+0x98>
    80005a9e:	b76d                	j	80005a48 <consoleread+0xc6>

0000000080005aa0 <consputc>:
{
    80005aa0:	1141                	addi	sp,sp,-16
    80005aa2:	e406                	sd	ra,8(sp)
    80005aa4:	e022                	sd	s0,0(sp)
    80005aa6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005aa8:	10000793          	li	a5,256
    80005aac:	00f50a63          	beq	a0,a5,80005ac0 <consputc+0x20>
    uartputc_sync(c);
    80005ab0:	00000097          	auipc	ra,0x0
    80005ab4:	564080e7          	jalr	1380(ra) # 80006014 <uartputc_sync>
}
    80005ab8:	60a2                	ld	ra,8(sp)
    80005aba:	6402                	ld	s0,0(sp)
    80005abc:	0141                	addi	sp,sp,16
    80005abe:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ac0:	4521                	li	a0,8
    80005ac2:	00000097          	auipc	ra,0x0
    80005ac6:	552080e7          	jalr	1362(ra) # 80006014 <uartputc_sync>
    80005aca:	02000513          	li	a0,32
    80005ace:	00000097          	auipc	ra,0x0
    80005ad2:	546080e7          	jalr	1350(ra) # 80006014 <uartputc_sync>
    80005ad6:	4521                	li	a0,8
    80005ad8:	00000097          	auipc	ra,0x0
    80005adc:	53c080e7          	jalr	1340(ra) # 80006014 <uartputc_sync>
    80005ae0:	bfe1                	j	80005ab8 <consputc+0x18>

0000000080005ae2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ae2:	1101                	addi	sp,sp,-32
    80005ae4:	ec06                	sd	ra,24(sp)
    80005ae6:	e822                	sd	s0,16(sp)
    80005ae8:	e426                	sd	s1,8(sp)
    80005aea:	e04a                	sd	s2,0(sp)
    80005aec:	1000                	addi	s0,sp,32
    80005aee:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005af0:	0001c517          	auipc	a0,0x1c
    80005af4:	52050513          	addi	a0,a0,1312 # 80022010 <cons>
    80005af8:	00000097          	auipc	ra,0x0
    80005afc:	7b4080e7          	jalr	1972(ra) # 800062ac <acquire>

  switch(c){
    80005b00:	47d5                	li	a5,21
    80005b02:	0af48663          	beq	s1,a5,80005bae <consoleintr+0xcc>
    80005b06:	0297ca63          	blt	a5,s1,80005b3a <consoleintr+0x58>
    80005b0a:	47a1                	li	a5,8
    80005b0c:	0ef48763          	beq	s1,a5,80005bfa <consoleintr+0x118>
    80005b10:	47c1                	li	a5,16
    80005b12:	10f49a63          	bne	s1,a5,80005c26 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b16:	ffffc097          	auipc	ra,0xffffc
    80005b1a:	f24080e7          	jalr	-220(ra) # 80001a3a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b1e:	0001c517          	auipc	a0,0x1c
    80005b22:	4f250513          	addi	a0,a0,1266 # 80022010 <cons>
    80005b26:	00001097          	auipc	ra,0x1
    80005b2a:	83a080e7          	jalr	-1990(ra) # 80006360 <release>
}
    80005b2e:	60e2                	ld	ra,24(sp)
    80005b30:	6442                	ld	s0,16(sp)
    80005b32:	64a2                	ld	s1,8(sp)
    80005b34:	6902                	ld	s2,0(sp)
    80005b36:	6105                	addi	sp,sp,32
    80005b38:	8082                	ret
  switch(c){
    80005b3a:	07f00793          	li	a5,127
    80005b3e:	0af48e63          	beq	s1,a5,80005bfa <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b42:	0001c717          	auipc	a4,0x1c
    80005b46:	4ce70713          	addi	a4,a4,1230 # 80022010 <cons>
    80005b4a:	0a072783          	lw	a5,160(a4)
    80005b4e:	09872703          	lw	a4,152(a4)
    80005b52:	9f99                	subw	a5,a5,a4
    80005b54:	07f00713          	li	a4,127
    80005b58:	fcf763e3          	bltu	a4,a5,80005b1e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b5c:	47b5                	li	a5,13
    80005b5e:	0cf48763          	beq	s1,a5,80005c2c <consoleintr+0x14a>
      consputc(c);
    80005b62:	8526                	mv	a0,s1
    80005b64:	00000097          	auipc	ra,0x0
    80005b68:	f3c080e7          	jalr	-196(ra) # 80005aa0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b6c:	0001c797          	auipc	a5,0x1c
    80005b70:	4a478793          	addi	a5,a5,1188 # 80022010 <cons>
    80005b74:	0a07a683          	lw	a3,160(a5)
    80005b78:	0016871b          	addiw	a4,a3,1
    80005b7c:	0007061b          	sext.w	a2,a4
    80005b80:	0ae7a023          	sw	a4,160(a5)
    80005b84:	07f6f693          	andi	a3,a3,127
    80005b88:	97b6                	add	a5,a5,a3
    80005b8a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005b8e:	47a9                	li	a5,10
    80005b90:	0cf48563          	beq	s1,a5,80005c5a <consoleintr+0x178>
    80005b94:	4791                	li	a5,4
    80005b96:	0cf48263          	beq	s1,a5,80005c5a <consoleintr+0x178>
    80005b9a:	0001c797          	auipc	a5,0x1c
    80005b9e:	50e7a783          	lw	a5,1294(a5) # 800220a8 <cons+0x98>
    80005ba2:	9f1d                	subw	a4,a4,a5
    80005ba4:	08000793          	li	a5,128
    80005ba8:	f6f71be3          	bne	a4,a5,80005b1e <consoleintr+0x3c>
    80005bac:	a07d                	j	80005c5a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bae:	0001c717          	auipc	a4,0x1c
    80005bb2:	46270713          	addi	a4,a4,1122 # 80022010 <cons>
    80005bb6:	0a072783          	lw	a5,160(a4)
    80005bba:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bbe:	0001c497          	auipc	s1,0x1c
    80005bc2:	45248493          	addi	s1,s1,1106 # 80022010 <cons>
    while(cons.e != cons.w &&
    80005bc6:	4929                	li	s2,10
    80005bc8:	f4f70be3          	beq	a4,a5,80005b1e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bcc:	37fd                	addiw	a5,a5,-1
    80005bce:	07f7f713          	andi	a4,a5,127
    80005bd2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bd4:	01874703          	lbu	a4,24(a4)
    80005bd8:	f52703e3          	beq	a4,s2,80005b1e <consoleintr+0x3c>
      cons.e--;
    80005bdc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005be0:	10000513          	li	a0,256
    80005be4:	00000097          	auipc	ra,0x0
    80005be8:	ebc080e7          	jalr	-324(ra) # 80005aa0 <consputc>
    while(cons.e != cons.w &&
    80005bec:	0a04a783          	lw	a5,160(s1)
    80005bf0:	09c4a703          	lw	a4,156(s1)
    80005bf4:	fcf71ce3          	bne	a4,a5,80005bcc <consoleintr+0xea>
    80005bf8:	b71d                	j	80005b1e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005bfa:	0001c717          	auipc	a4,0x1c
    80005bfe:	41670713          	addi	a4,a4,1046 # 80022010 <cons>
    80005c02:	0a072783          	lw	a5,160(a4)
    80005c06:	09c72703          	lw	a4,156(a4)
    80005c0a:	f0f70ae3          	beq	a4,a5,80005b1e <consoleintr+0x3c>
      cons.e--;
    80005c0e:	37fd                	addiw	a5,a5,-1
    80005c10:	0001c717          	auipc	a4,0x1c
    80005c14:	4af72023          	sw	a5,1184(a4) # 800220b0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c18:	10000513          	li	a0,256
    80005c1c:	00000097          	auipc	ra,0x0
    80005c20:	e84080e7          	jalr	-380(ra) # 80005aa0 <consputc>
    80005c24:	bded                	j	80005b1e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c26:	ee048ce3          	beqz	s1,80005b1e <consoleintr+0x3c>
    80005c2a:	bf21                	j	80005b42 <consoleintr+0x60>
      consputc(c);
    80005c2c:	4529                	li	a0,10
    80005c2e:	00000097          	auipc	ra,0x0
    80005c32:	e72080e7          	jalr	-398(ra) # 80005aa0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c36:	0001c797          	auipc	a5,0x1c
    80005c3a:	3da78793          	addi	a5,a5,986 # 80022010 <cons>
    80005c3e:	0a07a703          	lw	a4,160(a5)
    80005c42:	0017069b          	addiw	a3,a4,1
    80005c46:	0006861b          	sext.w	a2,a3
    80005c4a:	0ad7a023          	sw	a3,160(a5)
    80005c4e:	07f77713          	andi	a4,a4,127
    80005c52:	97ba                	add	a5,a5,a4
    80005c54:	4729                	li	a4,10
    80005c56:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c5a:	0001c797          	auipc	a5,0x1c
    80005c5e:	44c7a923          	sw	a2,1106(a5) # 800220ac <cons+0x9c>
        wakeup(&cons.r);
    80005c62:	0001c517          	auipc	a0,0x1c
    80005c66:	44650513          	addi	a0,a0,1094 # 800220a8 <cons+0x98>
    80005c6a:	ffffc097          	auipc	ra,0xffffc
    80005c6e:	980080e7          	jalr	-1664(ra) # 800015ea <wakeup>
    80005c72:	b575                	j	80005b1e <consoleintr+0x3c>

0000000080005c74 <consoleinit>:

void
consoleinit(void)
{
    80005c74:	1141                	addi	sp,sp,-16
    80005c76:	e406                	sd	ra,8(sp)
    80005c78:	e022                	sd	s0,0(sp)
    80005c7a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c7c:	00003597          	auipc	a1,0x3
    80005c80:	c5458593          	addi	a1,a1,-940 # 800088d0 <syscalls+0x3f8>
    80005c84:	0001c517          	auipc	a0,0x1c
    80005c88:	38c50513          	addi	a0,a0,908 # 80022010 <cons>
    80005c8c:	00000097          	auipc	ra,0x0
    80005c90:	590080e7          	jalr	1424(ra) # 8000621c <initlock>

  uartinit();
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	330080e7          	jalr	816(ra) # 80005fc4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c9c:	00013797          	auipc	a5,0x13
    80005ca0:	09c78793          	addi	a5,a5,156 # 80018d38 <devsw>
    80005ca4:	00000717          	auipc	a4,0x0
    80005ca8:	cde70713          	addi	a4,a4,-802 # 80005982 <consoleread>
    80005cac:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cae:	00000717          	auipc	a4,0x0
    80005cb2:	c7270713          	addi	a4,a4,-910 # 80005920 <consolewrite>
    80005cb6:	ef98                	sd	a4,24(a5)
}
    80005cb8:	60a2                	ld	ra,8(sp)
    80005cba:	6402                	ld	s0,0(sp)
    80005cbc:	0141                	addi	sp,sp,16
    80005cbe:	8082                	ret

0000000080005cc0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cc0:	7179                	addi	sp,sp,-48
    80005cc2:	f406                	sd	ra,40(sp)
    80005cc4:	f022                	sd	s0,32(sp)
    80005cc6:	ec26                	sd	s1,24(sp)
    80005cc8:	e84a                	sd	s2,16(sp)
    80005cca:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ccc:	c219                	beqz	a2,80005cd2 <printint+0x12>
    80005cce:	08054663          	bltz	a0,80005d5a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005cd2:	2501                	sext.w	a0,a0
    80005cd4:	4881                	li	a7,0
    80005cd6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cda:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cdc:	2581                	sext.w	a1,a1
    80005cde:	00003617          	auipc	a2,0x3
    80005ce2:	c2260613          	addi	a2,a2,-990 # 80008900 <digits>
    80005ce6:	883a                	mv	a6,a4
    80005ce8:	2705                	addiw	a4,a4,1
    80005cea:	02b577bb          	remuw	a5,a0,a1
    80005cee:	1782                	slli	a5,a5,0x20
    80005cf0:	9381                	srli	a5,a5,0x20
    80005cf2:	97b2                	add	a5,a5,a2
    80005cf4:	0007c783          	lbu	a5,0(a5)
    80005cf8:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005cfc:	0005079b          	sext.w	a5,a0
    80005d00:	02b5553b          	divuw	a0,a0,a1
    80005d04:	0685                	addi	a3,a3,1
    80005d06:	feb7f0e3          	bgeu	a5,a1,80005ce6 <printint+0x26>

  if(sign)
    80005d0a:	00088b63          	beqz	a7,80005d20 <printint+0x60>
    buf[i++] = '-';
    80005d0e:	fe040793          	addi	a5,s0,-32
    80005d12:	973e                	add	a4,a4,a5
    80005d14:	02d00793          	li	a5,45
    80005d18:	fef70823          	sb	a5,-16(a4)
    80005d1c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d20:	02e05763          	blez	a4,80005d4e <printint+0x8e>
    80005d24:	fd040793          	addi	a5,s0,-48
    80005d28:	00e784b3          	add	s1,a5,a4
    80005d2c:	fff78913          	addi	s2,a5,-1
    80005d30:	993a                	add	s2,s2,a4
    80005d32:	377d                	addiw	a4,a4,-1
    80005d34:	1702                	slli	a4,a4,0x20
    80005d36:	9301                	srli	a4,a4,0x20
    80005d38:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d3c:	fff4c503          	lbu	a0,-1(s1)
    80005d40:	00000097          	auipc	ra,0x0
    80005d44:	d60080e7          	jalr	-672(ra) # 80005aa0 <consputc>
  while(--i >= 0)
    80005d48:	14fd                	addi	s1,s1,-1
    80005d4a:	ff2499e3          	bne	s1,s2,80005d3c <printint+0x7c>
}
    80005d4e:	70a2                	ld	ra,40(sp)
    80005d50:	7402                	ld	s0,32(sp)
    80005d52:	64e2                	ld	s1,24(sp)
    80005d54:	6942                	ld	s2,16(sp)
    80005d56:	6145                	addi	sp,sp,48
    80005d58:	8082                	ret
    x = -xx;
    80005d5a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d5e:	4885                	li	a7,1
    x = -xx;
    80005d60:	bf9d                	j	80005cd6 <printint+0x16>

0000000080005d62 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d62:	1101                	addi	sp,sp,-32
    80005d64:	ec06                	sd	ra,24(sp)
    80005d66:	e822                	sd	s0,16(sp)
    80005d68:	e426                	sd	s1,8(sp)
    80005d6a:	1000                	addi	s0,sp,32
    80005d6c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d6e:	0001c797          	auipc	a5,0x1c
    80005d72:	3607a123          	sw	zero,866(a5) # 800220d0 <pr+0x18>
  printf("panic: ");
    80005d76:	00003517          	auipc	a0,0x3
    80005d7a:	b6250513          	addi	a0,a0,-1182 # 800088d8 <syscalls+0x400>
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	02e080e7          	jalr	46(ra) # 80005dac <printf>
  printf(s);
    80005d86:	8526                	mv	a0,s1
    80005d88:	00000097          	auipc	ra,0x0
    80005d8c:	024080e7          	jalr	36(ra) # 80005dac <printf>
  printf("\n");
    80005d90:	00002517          	auipc	a0,0x2
    80005d94:	2b850513          	addi	a0,a0,696 # 80008048 <etext+0x48>
    80005d98:	00000097          	auipc	ra,0x0
    80005d9c:	014080e7          	jalr	20(ra) # 80005dac <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005da0:	4785                	li	a5,1
    80005da2:	00003717          	auipc	a4,0x3
    80005da6:	cef72523          	sw	a5,-790(a4) # 80008a8c <panicked>
  for(;;)
    80005daa:	a001                	j	80005daa <panic+0x48>

0000000080005dac <printf>:
{
    80005dac:	7131                	addi	sp,sp,-192
    80005dae:	fc86                	sd	ra,120(sp)
    80005db0:	f8a2                	sd	s0,112(sp)
    80005db2:	f4a6                	sd	s1,104(sp)
    80005db4:	f0ca                	sd	s2,96(sp)
    80005db6:	ecce                	sd	s3,88(sp)
    80005db8:	e8d2                	sd	s4,80(sp)
    80005dba:	e4d6                	sd	s5,72(sp)
    80005dbc:	e0da                	sd	s6,64(sp)
    80005dbe:	fc5e                	sd	s7,56(sp)
    80005dc0:	f862                	sd	s8,48(sp)
    80005dc2:	f466                	sd	s9,40(sp)
    80005dc4:	f06a                	sd	s10,32(sp)
    80005dc6:	ec6e                	sd	s11,24(sp)
    80005dc8:	0100                	addi	s0,sp,128
    80005dca:	8a2a                	mv	s4,a0
    80005dcc:	e40c                	sd	a1,8(s0)
    80005dce:	e810                	sd	a2,16(s0)
    80005dd0:	ec14                	sd	a3,24(s0)
    80005dd2:	f018                	sd	a4,32(s0)
    80005dd4:	f41c                	sd	a5,40(s0)
    80005dd6:	03043823          	sd	a6,48(s0)
    80005dda:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dde:	0001cd97          	auipc	s11,0x1c
    80005de2:	2f2dad83          	lw	s11,754(s11) # 800220d0 <pr+0x18>
  if(locking)
    80005de6:	020d9b63          	bnez	s11,80005e1c <printf+0x70>
  if (fmt == 0)
    80005dea:	040a0263          	beqz	s4,80005e2e <printf+0x82>
  va_start(ap, fmt);
    80005dee:	00840793          	addi	a5,s0,8
    80005df2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005df6:	000a4503          	lbu	a0,0(s4)
    80005dfa:	16050263          	beqz	a0,80005f5e <printf+0x1b2>
    80005dfe:	4481                	li	s1,0
    if(c != '%'){
    80005e00:	02500a93          	li	s5,37
    switch(c){
    80005e04:	07000b13          	li	s6,112
  consputc('x');
    80005e08:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e0a:	00003b97          	auipc	s7,0x3
    80005e0e:	af6b8b93          	addi	s7,s7,-1290 # 80008900 <digits>
    switch(c){
    80005e12:	07300c93          	li	s9,115
    80005e16:	06400c13          	li	s8,100
    80005e1a:	a82d                	j	80005e54 <printf+0xa8>
    acquire(&pr.lock);
    80005e1c:	0001c517          	auipc	a0,0x1c
    80005e20:	29c50513          	addi	a0,a0,668 # 800220b8 <pr>
    80005e24:	00000097          	auipc	ra,0x0
    80005e28:	488080e7          	jalr	1160(ra) # 800062ac <acquire>
    80005e2c:	bf7d                	j	80005dea <printf+0x3e>
    panic("null fmt");
    80005e2e:	00003517          	auipc	a0,0x3
    80005e32:	aba50513          	addi	a0,a0,-1350 # 800088e8 <syscalls+0x410>
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	f2c080e7          	jalr	-212(ra) # 80005d62 <panic>
      consputc(c);
    80005e3e:	00000097          	auipc	ra,0x0
    80005e42:	c62080e7          	jalr	-926(ra) # 80005aa0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e46:	2485                	addiw	s1,s1,1
    80005e48:	009a07b3          	add	a5,s4,s1
    80005e4c:	0007c503          	lbu	a0,0(a5)
    80005e50:	10050763          	beqz	a0,80005f5e <printf+0x1b2>
    if(c != '%'){
    80005e54:	ff5515e3          	bne	a0,s5,80005e3e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e58:	2485                	addiw	s1,s1,1
    80005e5a:	009a07b3          	add	a5,s4,s1
    80005e5e:	0007c783          	lbu	a5,0(a5)
    80005e62:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e66:	cfe5                	beqz	a5,80005f5e <printf+0x1b2>
    switch(c){
    80005e68:	05678a63          	beq	a5,s6,80005ebc <printf+0x110>
    80005e6c:	02fb7663          	bgeu	s6,a5,80005e98 <printf+0xec>
    80005e70:	09978963          	beq	a5,s9,80005f02 <printf+0x156>
    80005e74:	07800713          	li	a4,120
    80005e78:	0ce79863          	bne	a5,a4,80005f48 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e7c:	f8843783          	ld	a5,-120(s0)
    80005e80:	00878713          	addi	a4,a5,8
    80005e84:	f8e43423          	sd	a4,-120(s0)
    80005e88:	4605                	li	a2,1
    80005e8a:	85ea                	mv	a1,s10
    80005e8c:	4388                	lw	a0,0(a5)
    80005e8e:	00000097          	auipc	ra,0x0
    80005e92:	e32080e7          	jalr	-462(ra) # 80005cc0 <printint>
      break;
    80005e96:	bf45                	j	80005e46 <printf+0x9a>
    switch(c){
    80005e98:	0b578263          	beq	a5,s5,80005f3c <printf+0x190>
    80005e9c:	0b879663          	bne	a5,s8,80005f48 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005ea0:	f8843783          	ld	a5,-120(s0)
    80005ea4:	00878713          	addi	a4,a5,8
    80005ea8:	f8e43423          	sd	a4,-120(s0)
    80005eac:	4605                	li	a2,1
    80005eae:	45a9                	li	a1,10
    80005eb0:	4388                	lw	a0,0(a5)
    80005eb2:	00000097          	auipc	ra,0x0
    80005eb6:	e0e080e7          	jalr	-498(ra) # 80005cc0 <printint>
      break;
    80005eba:	b771                	j	80005e46 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ebc:	f8843783          	ld	a5,-120(s0)
    80005ec0:	00878713          	addi	a4,a5,8
    80005ec4:	f8e43423          	sd	a4,-120(s0)
    80005ec8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005ecc:	03000513          	li	a0,48
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	bd0080e7          	jalr	-1072(ra) # 80005aa0 <consputc>
  consputc('x');
    80005ed8:	07800513          	li	a0,120
    80005edc:	00000097          	auipc	ra,0x0
    80005ee0:	bc4080e7          	jalr	-1084(ra) # 80005aa0 <consputc>
    80005ee4:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ee6:	03c9d793          	srli	a5,s3,0x3c
    80005eea:	97de                	add	a5,a5,s7
    80005eec:	0007c503          	lbu	a0,0(a5)
    80005ef0:	00000097          	auipc	ra,0x0
    80005ef4:	bb0080e7          	jalr	-1104(ra) # 80005aa0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ef8:	0992                	slli	s3,s3,0x4
    80005efa:	397d                	addiw	s2,s2,-1
    80005efc:	fe0915e3          	bnez	s2,80005ee6 <printf+0x13a>
    80005f00:	b799                	j	80005e46 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f02:	f8843783          	ld	a5,-120(s0)
    80005f06:	00878713          	addi	a4,a5,8
    80005f0a:	f8e43423          	sd	a4,-120(s0)
    80005f0e:	0007b903          	ld	s2,0(a5)
    80005f12:	00090e63          	beqz	s2,80005f2e <printf+0x182>
      for(; *s; s++)
    80005f16:	00094503          	lbu	a0,0(s2)
    80005f1a:	d515                	beqz	a0,80005e46 <printf+0x9a>
        consputc(*s);
    80005f1c:	00000097          	auipc	ra,0x0
    80005f20:	b84080e7          	jalr	-1148(ra) # 80005aa0 <consputc>
      for(; *s; s++)
    80005f24:	0905                	addi	s2,s2,1
    80005f26:	00094503          	lbu	a0,0(s2)
    80005f2a:	f96d                	bnez	a0,80005f1c <printf+0x170>
    80005f2c:	bf29                	j	80005e46 <printf+0x9a>
        s = "(null)";
    80005f2e:	00003917          	auipc	s2,0x3
    80005f32:	9b290913          	addi	s2,s2,-1614 # 800088e0 <syscalls+0x408>
      for(; *s; s++)
    80005f36:	02800513          	li	a0,40
    80005f3a:	b7cd                	j	80005f1c <printf+0x170>
      consputc('%');
    80005f3c:	8556                	mv	a0,s5
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	b62080e7          	jalr	-1182(ra) # 80005aa0 <consputc>
      break;
    80005f46:	b701                	j	80005e46 <printf+0x9a>
      consputc('%');
    80005f48:	8556                	mv	a0,s5
    80005f4a:	00000097          	auipc	ra,0x0
    80005f4e:	b56080e7          	jalr	-1194(ra) # 80005aa0 <consputc>
      consputc(c);
    80005f52:	854a                	mv	a0,s2
    80005f54:	00000097          	auipc	ra,0x0
    80005f58:	b4c080e7          	jalr	-1204(ra) # 80005aa0 <consputc>
      break;
    80005f5c:	b5ed                	j	80005e46 <printf+0x9a>
  if(locking)
    80005f5e:	020d9163          	bnez	s11,80005f80 <printf+0x1d4>
}
    80005f62:	70e6                	ld	ra,120(sp)
    80005f64:	7446                	ld	s0,112(sp)
    80005f66:	74a6                	ld	s1,104(sp)
    80005f68:	7906                	ld	s2,96(sp)
    80005f6a:	69e6                	ld	s3,88(sp)
    80005f6c:	6a46                	ld	s4,80(sp)
    80005f6e:	6aa6                	ld	s5,72(sp)
    80005f70:	6b06                	ld	s6,64(sp)
    80005f72:	7be2                	ld	s7,56(sp)
    80005f74:	7c42                	ld	s8,48(sp)
    80005f76:	7ca2                	ld	s9,40(sp)
    80005f78:	7d02                	ld	s10,32(sp)
    80005f7a:	6de2                	ld	s11,24(sp)
    80005f7c:	6129                	addi	sp,sp,192
    80005f7e:	8082                	ret
    release(&pr.lock);
    80005f80:	0001c517          	auipc	a0,0x1c
    80005f84:	13850513          	addi	a0,a0,312 # 800220b8 <pr>
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	3d8080e7          	jalr	984(ra) # 80006360 <release>
}
    80005f90:	bfc9                	j	80005f62 <printf+0x1b6>

0000000080005f92 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f92:	1101                	addi	sp,sp,-32
    80005f94:	ec06                	sd	ra,24(sp)
    80005f96:	e822                	sd	s0,16(sp)
    80005f98:	e426                	sd	s1,8(sp)
    80005f9a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f9c:	0001c497          	auipc	s1,0x1c
    80005fa0:	11c48493          	addi	s1,s1,284 # 800220b8 <pr>
    80005fa4:	00003597          	auipc	a1,0x3
    80005fa8:	95458593          	addi	a1,a1,-1708 # 800088f8 <syscalls+0x420>
    80005fac:	8526                	mv	a0,s1
    80005fae:	00000097          	auipc	ra,0x0
    80005fb2:	26e080e7          	jalr	622(ra) # 8000621c <initlock>
  pr.locking = 1;
    80005fb6:	4785                	li	a5,1
    80005fb8:	cc9c                	sw	a5,24(s1)
}
    80005fba:	60e2                	ld	ra,24(sp)
    80005fbc:	6442                	ld	s0,16(sp)
    80005fbe:	64a2                	ld	s1,8(sp)
    80005fc0:	6105                	addi	sp,sp,32
    80005fc2:	8082                	ret

0000000080005fc4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fc4:	1141                	addi	sp,sp,-16
    80005fc6:	e406                	sd	ra,8(sp)
    80005fc8:	e022                	sd	s0,0(sp)
    80005fca:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fcc:	100007b7          	lui	a5,0x10000
    80005fd0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fd4:	f8000713          	li	a4,-128
    80005fd8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fdc:	470d                	li	a4,3
    80005fde:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fe2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fe6:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fea:	469d                	li	a3,7
    80005fec:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ff0:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ff4:	00003597          	auipc	a1,0x3
    80005ff8:	92458593          	addi	a1,a1,-1756 # 80008918 <digits+0x18>
    80005ffc:	0001c517          	auipc	a0,0x1c
    80006000:	0dc50513          	addi	a0,a0,220 # 800220d8 <uart_tx_lock>
    80006004:	00000097          	auipc	ra,0x0
    80006008:	218080e7          	jalr	536(ra) # 8000621c <initlock>
}
    8000600c:	60a2                	ld	ra,8(sp)
    8000600e:	6402                	ld	s0,0(sp)
    80006010:	0141                	addi	sp,sp,16
    80006012:	8082                	ret

0000000080006014 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006014:	1101                	addi	sp,sp,-32
    80006016:	ec06                	sd	ra,24(sp)
    80006018:	e822                	sd	s0,16(sp)
    8000601a:	e426                	sd	s1,8(sp)
    8000601c:	1000                	addi	s0,sp,32
    8000601e:	84aa                	mv	s1,a0
  push_off();
    80006020:	00000097          	auipc	ra,0x0
    80006024:	240080e7          	jalr	576(ra) # 80006260 <push_off>

  if(panicked){
    80006028:	00003797          	auipc	a5,0x3
    8000602c:	a647a783          	lw	a5,-1436(a5) # 80008a8c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006030:	10000737          	lui	a4,0x10000
  if(panicked){
    80006034:	c391                	beqz	a5,80006038 <uartputc_sync+0x24>
    for(;;)
    80006036:	a001                	j	80006036 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006038:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000603c:	0ff7f793          	andi	a5,a5,255
    80006040:	0207f793          	andi	a5,a5,32
    80006044:	dbf5                	beqz	a5,80006038 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006046:	0ff4f793          	andi	a5,s1,255
    8000604a:	10000737          	lui	a4,0x10000
    8000604e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006052:	00000097          	auipc	ra,0x0
    80006056:	2ae080e7          	jalr	686(ra) # 80006300 <pop_off>
}
    8000605a:	60e2                	ld	ra,24(sp)
    8000605c:	6442                	ld	s0,16(sp)
    8000605e:	64a2                	ld	s1,8(sp)
    80006060:	6105                	addi	sp,sp,32
    80006062:	8082                	ret

0000000080006064 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006064:	00003717          	auipc	a4,0x3
    80006068:	a2c73703          	ld	a4,-1492(a4) # 80008a90 <uart_tx_r>
    8000606c:	00003797          	auipc	a5,0x3
    80006070:	a2c7b783          	ld	a5,-1492(a5) # 80008a98 <uart_tx_w>
    80006074:	06e78c63          	beq	a5,a4,800060ec <uartstart+0x88>
{
    80006078:	7139                	addi	sp,sp,-64
    8000607a:	fc06                	sd	ra,56(sp)
    8000607c:	f822                	sd	s0,48(sp)
    8000607e:	f426                	sd	s1,40(sp)
    80006080:	f04a                	sd	s2,32(sp)
    80006082:	ec4e                	sd	s3,24(sp)
    80006084:	e852                	sd	s4,16(sp)
    80006086:	e456                	sd	s5,8(sp)
    80006088:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000608a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000608e:	0001ca17          	auipc	s4,0x1c
    80006092:	04aa0a13          	addi	s4,s4,74 # 800220d8 <uart_tx_lock>
    uart_tx_r += 1;
    80006096:	00003497          	auipc	s1,0x3
    8000609a:	9fa48493          	addi	s1,s1,-1542 # 80008a90 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000609e:	00003997          	auipc	s3,0x3
    800060a2:	9fa98993          	addi	s3,s3,-1542 # 80008a98 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060a6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060aa:	0ff7f793          	andi	a5,a5,255
    800060ae:	0207f793          	andi	a5,a5,32
    800060b2:	c785                	beqz	a5,800060da <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060b4:	01f77793          	andi	a5,a4,31
    800060b8:	97d2                	add	a5,a5,s4
    800060ba:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800060be:	0705                	addi	a4,a4,1
    800060c0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060c2:	8526                	mv	a0,s1
    800060c4:	ffffb097          	auipc	ra,0xffffb
    800060c8:	526080e7          	jalr	1318(ra) # 800015ea <wakeup>
    
    WriteReg(THR, c);
    800060cc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060d0:	6098                	ld	a4,0(s1)
    800060d2:	0009b783          	ld	a5,0(s3)
    800060d6:	fce798e3          	bne	a5,a4,800060a6 <uartstart+0x42>
  }
}
    800060da:	70e2                	ld	ra,56(sp)
    800060dc:	7442                	ld	s0,48(sp)
    800060de:	74a2                	ld	s1,40(sp)
    800060e0:	7902                	ld	s2,32(sp)
    800060e2:	69e2                	ld	s3,24(sp)
    800060e4:	6a42                	ld	s4,16(sp)
    800060e6:	6aa2                	ld	s5,8(sp)
    800060e8:	6121                	addi	sp,sp,64
    800060ea:	8082                	ret
    800060ec:	8082                	ret

00000000800060ee <uartputc>:
{
    800060ee:	7179                	addi	sp,sp,-48
    800060f0:	f406                	sd	ra,40(sp)
    800060f2:	f022                	sd	s0,32(sp)
    800060f4:	ec26                	sd	s1,24(sp)
    800060f6:	e84a                	sd	s2,16(sp)
    800060f8:	e44e                	sd	s3,8(sp)
    800060fa:	e052                	sd	s4,0(sp)
    800060fc:	1800                	addi	s0,sp,48
    800060fe:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006100:	0001c517          	auipc	a0,0x1c
    80006104:	fd850513          	addi	a0,a0,-40 # 800220d8 <uart_tx_lock>
    80006108:	00000097          	auipc	ra,0x0
    8000610c:	1a4080e7          	jalr	420(ra) # 800062ac <acquire>
  if(panicked){
    80006110:	00003797          	auipc	a5,0x3
    80006114:	97c7a783          	lw	a5,-1668(a5) # 80008a8c <panicked>
    80006118:	e7c9                	bnez	a5,800061a2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000611a:	00003797          	auipc	a5,0x3
    8000611e:	97e7b783          	ld	a5,-1666(a5) # 80008a98 <uart_tx_w>
    80006122:	00003717          	auipc	a4,0x3
    80006126:	96e73703          	ld	a4,-1682(a4) # 80008a90 <uart_tx_r>
    8000612a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000612e:	0001ca17          	auipc	s4,0x1c
    80006132:	faaa0a13          	addi	s4,s4,-86 # 800220d8 <uart_tx_lock>
    80006136:	00003497          	auipc	s1,0x3
    8000613a:	95a48493          	addi	s1,s1,-1702 # 80008a90 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000613e:	00003917          	auipc	s2,0x3
    80006142:	95a90913          	addi	s2,s2,-1702 # 80008a98 <uart_tx_w>
    80006146:	00f71f63          	bne	a4,a5,80006164 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000614a:	85d2                	mv	a1,s4
    8000614c:	8526                	mv	a0,s1
    8000614e:	ffffb097          	auipc	ra,0xffffb
    80006152:	438080e7          	jalr	1080(ra) # 80001586 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006156:	00093783          	ld	a5,0(s2)
    8000615a:	6098                	ld	a4,0(s1)
    8000615c:	02070713          	addi	a4,a4,32
    80006160:	fef705e3          	beq	a4,a5,8000614a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006164:	0001c497          	auipc	s1,0x1c
    80006168:	f7448493          	addi	s1,s1,-140 # 800220d8 <uart_tx_lock>
    8000616c:	01f7f713          	andi	a4,a5,31
    80006170:	9726                	add	a4,a4,s1
    80006172:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006176:	0785                	addi	a5,a5,1
    80006178:	00003717          	auipc	a4,0x3
    8000617c:	92f73023          	sd	a5,-1760(a4) # 80008a98 <uart_tx_w>
  uartstart();
    80006180:	00000097          	auipc	ra,0x0
    80006184:	ee4080e7          	jalr	-284(ra) # 80006064 <uartstart>
  release(&uart_tx_lock);
    80006188:	8526                	mv	a0,s1
    8000618a:	00000097          	auipc	ra,0x0
    8000618e:	1d6080e7          	jalr	470(ra) # 80006360 <release>
}
    80006192:	70a2                	ld	ra,40(sp)
    80006194:	7402                	ld	s0,32(sp)
    80006196:	64e2                	ld	s1,24(sp)
    80006198:	6942                	ld	s2,16(sp)
    8000619a:	69a2                	ld	s3,8(sp)
    8000619c:	6a02                	ld	s4,0(sp)
    8000619e:	6145                	addi	sp,sp,48
    800061a0:	8082                	ret
    for(;;)
    800061a2:	a001                	j	800061a2 <uartputc+0xb4>

00000000800061a4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061a4:	1141                	addi	sp,sp,-16
    800061a6:	e422                	sd	s0,8(sp)
    800061a8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061aa:	100007b7          	lui	a5,0x10000
    800061ae:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061b2:	8b85                	andi	a5,a5,1
    800061b4:	cb91                	beqz	a5,800061c8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800061b6:	100007b7          	lui	a5,0x10000
    800061ba:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800061be:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800061c2:	6422                	ld	s0,8(sp)
    800061c4:	0141                	addi	sp,sp,16
    800061c6:	8082                	ret
    return -1;
    800061c8:	557d                	li	a0,-1
    800061ca:	bfe5                	j	800061c2 <uartgetc+0x1e>

00000000800061cc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800061cc:	1101                	addi	sp,sp,-32
    800061ce:	ec06                	sd	ra,24(sp)
    800061d0:	e822                	sd	s0,16(sp)
    800061d2:	e426                	sd	s1,8(sp)
    800061d4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061d6:	54fd                	li	s1,-1
    int c = uartgetc();
    800061d8:	00000097          	auipc	ra,0x0
    800061dc:	fcc080e7          	jalr	-52(ra) # 800061a4 <uartgetc>
    if(c == -1)
    800061e0:	00950763          	beq	a0,s1,800061ee <uartintr+0x22>
      break;
    consoleintr(c);
    800061e4:	00000097          	auipc	ra,0x0
    800061e8:	8fe080e7          	jalr	-1794(ra) # 80005ae2 <consoleintr>
  while(1){
    800061ec:	b7f5                	j	800061d8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061ee:	0001c497          	auipc	s1,0x1c
    800061f2:	eea48493          	addi	s1,s1,-278 # 800220d8 <uart_tx_lock>
    800061f6:	8526                	mv	a0,s1
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	0b4080e7          	jalr	180(ra) # 800062ac <acquire>
  uartstart();
    80006200:	00000097          	auipc	ra,0x0
    80006204:	e64080e7          	jalr	-412(ra) # 80006064 <uartstart>
  release(&uart_tx_lock);
    80006208:	8526                	mv	a0,s1
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	156080e7          	jalr	342(ra) # 80006360 <release>
}
    80006212:	60e2                	ld	ra,24(sp)
    80006214:	6442                	ld	s0,16(sp)
    80006216:	64a2                	ld	s1,8(sp)
    80006218:	6105                	addi	sp,sp,32
    8000621a:	8082                	ret

000000008000621c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000621c:	1141                	addi	sp,sp,-16
    8000621e:	e422                	sd	s0,8(sp)
    80006220:	0800                	addi	s0,sp,16
  lk->name = name;
    80006222:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006224:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006228:	00053823          	sd	zero,16(a0)
}
    8000622c:	6422                	ld	s0,8(sp)
    8000622e:	0141                	addi	sp,sp,16
    80006230:	8082                	ret

0000000080006232 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006232:	411c                	lw	a5,0(a0)
    80006234:	e399                	bnez	a5,8000623a <holding+0x8>
    80006236:	4501                	li	a0,0
  return r;
}
    80006238:	8082                	ret
{
    8000623a:	1101                	addi	sp,sp,-32
    8000623c:	ec06                	sd	ra,24(sp)
    8000623e:	e822                	sd	s0,16(sp)
    80006240:	e426                	sd	s1,8(sp)
    80006242:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006244:	6904                	ld	s1,16(a0)
    80006246:	ffffb097          	auipc	ra,0xffffb
    8000624a:	c74080e7          	jalr	-908(ra) # 80000eba <mycpu>
    8000624e:	40a48533          	sub	a0,s1,a0
    80006252:	00153513          	seqz	a0,a0
}
    80006256:	60e2                	ld	ra,24(sp)
    80006258:	6442                	ld	s0,16(sp)
    8000625a:	64a2                	ld	s1,8(sp)
    8000625c:	6105                	addi	sp,sp,32
    8000625e:	8082                	ret

0000000080006260 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006260:	1101                	addi	sp,sp,-32
    80006262:	ec06                	sd	ra,24(sp)
    80006264:	e822                	sd	s0,16(sp)
    80006266:	e426                	sd	s1,8(sp)
    80006268:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000626a:	100024f3          	csrr	s1,sstatus
    8000626e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006272:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006274:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006278:	ffffb097          	auipc	ra,0xffffb
    8000627c:	c42080e7          	jalr	-958(ra) # 80000eba <mycpu>
    80006280:	5d3c                	lw	a5,120(a0)
    80006282:	cf89                	beqz	a5,8000629c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006284:	ffffb097          	auipc	ra,0xffffb
    80006288:	c36080e7          	jalr	-970(ra) # 80000eba <mycpu>
    8000628c:	5d3c                	lw	a5,120(a0)
    8000628e:	2785                	addiw	a5,a5,1
    80006290:	dd3c                	sw	a5,120(a0)
}
    80006292:	60e2                	ld	ra,24(sp)
    80006294:	6442                	ld	s0,16(sp)
    80006296:	64a2                	ld	s1,8(sp)
    80006298:	6105                	addi	sp,sp,32
    8000629a:	8082                	ret
    mycpu()->intena = old;
    8000629c:	ffffb097          	auipc	ra,0xffffb
    800062a0:	c1e080e7          	jalr	-994(ra) # 80000eba <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062a4:	8085                	srli	s1,s1,0x1
    800062a6:	8885                	andi	s1,s1,1
    800062a8:	dd64                	sw	s1,124(a0)
    800062aa:	bfe9                	j	80006284 <push_off+0x24>

00000000800062ac <acquire>:
{
    800062ac:	1101                	addi	sp,sp,-32
    800062ae:	ec06                	sd	ra,24(sp)
    800062b0:	e822                	sd	s0,16(sp)
    800062b2:	e426                	sd	s1,8(sp)
    800062b4:	1000                	addi	s0,sp,32
    800062b6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062b8:	00000097          	auipc	ra,0x0
    800062bc:	fa8080e7          	jalr	-88(ra) # 80006260 <push_off>
  if(holding(lk))
    800062c0:	8526                	mv	a0,s1
    800062c2:	00000097          	auipc	ra,0x0
    800062c6:	f70080e7          	jalr	-144(ra) # 80006232 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062ca:	4705                	li	a4,1
  if(holding(lk))
    800062cc:	e115                	bnez	a0,800062f0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062ce:	87ba                	mv	a5,a4
    800062d0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062d4:	2781                	sext.w	a5,a5
    800062d6:	ffe5                	bnez	a5,800062ce <acquire+0x22>
  __sync_synchronize();
    800062d8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062dc:	ffffb097          	auipc	ra,0xffffb
    800062e0:	bde080e7          	jalr	-1058(ra) # 80000eba <mycpu>
    800062e4:	e888                	sd	a0,16(s1)
}
    800062e6:	60e2                	ld	ra,24(sp)
    800062e8:	6442                	ld	s0,16(sp)
    800062ea:	64a2                	ld	s1,8(sp)
    800062ec:	6105                	addi	sp,sp,32
    800062ee:	8082                	ret
    panic("acquire");
    800062f0:	00002517          	auipc	a0,0x2
    800062f4:	63050513          	addi	a0,a0,1584 # 80008920 <digits+0x20>
    800062f8:	00000097          	auipc	ra,0x0
    800062fc:	a6a080e7          	jalr	-1430(ra) # 80005d62 <panic>

0000000080006300 <pop_off>:

void
pop_off(void)
{
    80006300:	1141                	addi	sp,sp,-16
    80006302:	e406                	sd	ra,8(sp)
    80006304:	e022                	sd	s0,0(sp)
    80006306:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006308:	ffffb097          	auipc	ra,0xffffb
    8000630c:	bb2080e7          	jalr	-1102(ra) # 80000eba <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006310:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006314:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006316:	e78d                	bnez	a5,80006340 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006318:	5d3c                	lw	a5,120(a0)
    8000631a:	02f05b63          	blez	a5,80006350 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000631e:	37fd                	addiw	a5,a5,-1
    80006320:	0007871b          	sext.w	a4,a5
    80006324:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006326:	eb09                	bnez	a4,80006338 <pop_off+0x38>
    80006328:	5d7c                	lw	a5,124(a0)
    8000632a:	c799                	beqz	a5,80006338 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000632c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006330:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006334:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006338:	60a2                	ld	ra,8(sp)
    8000633a:	6402                	ld	s0,0(sp)
    8000633c:	0141                	addi	sp,sp,16
    8000633e:	8082                	ret
    panic("pop_off - interruptible");
    80006340:	00002517          	auipc	a0,0x2
    80006344:	5e850513          	addi	a0,a0,1512 # 80008928 <digits+0x28>
    80006348:	00000097          	auipc	ra,0x0
    8000634c:	a1a080e7          	jalr	-1510(ra) # 80005d62 <panic>
    panic("pop_off");
    80006350:	00002517          	auipc	a0,0x2
    80006354:	5f050513          	addi	a0,a0,1520 # 80008940 <digits+0x40>
    80006358:	00000097          	auipc	ra,0x0
    8000635c:	a0a080e7          	jalr	-1526(ra) # 80005d62 <panic>

0000000080006360 <release>:
{
    80006360:	1101                	addi	sp,sp,-32
    80006362:	ec06                	sd	ra,24(sp)
    80006364:	e822                	sd	s0,16(sp)
    80006366:	e426                	sd	s1,8(sp)
    80006368:	1000                	addi	s0,sp,32
    8000636a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000636c:	00000097          	auipc	ra,0x0
    80006370:	ec6080e7          	jalr	-314(ra) # 80006232 <holding>
    80006374:	c115                	beqz	a0,80006398 <release+0x38>
  lk->cpu = 0;
    80006376:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000637a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000637e:	0f50000f          	fence	iorw,ow
    80006382:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006386:	00000097          	auipc	ra,0x0
    8000638a:	f7a080e7          	jalr	-134(ra) # 80006300 <pop_off>
}
    8000638e:	60e2                	ld	ra,24(sp)
    80006390:	6442                	ld	s0,16(sp)
    80006392:	64a2                	ld	s1,8(sp)
    80006394:	6105                	addi	sp,sp,32
    80006396:	8082                	ret
    panic("release");
    80006398:	00002517          	auipc	a0,0x2
    8000639c:	5b050513          	addi	a0,a0,1456 # 80008948 <digits+0x48>
    800063a0:	00000097          	auipc	ra,0x0
    800063a4:	9c2080e7          	jalr	-1598(ra) # 80005d62 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
