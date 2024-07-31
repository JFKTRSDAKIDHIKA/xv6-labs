
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	ff010113          	addi	sp,sp,-16 # 80019ff0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	049050ef          	jal	ra,8000585e <start>

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
    80000034:	0c078793          	addi	a5,a5,192 # 800220f0 <end>
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
    80000054:	a3090913          	addi	s2,s2,-1488 # 80008a80 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	1f0080e7          	jalr	496(ra) # 8000624a <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	290080e7          	jalr	656(ra) # 800062fe <release>
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
    8000008e:	c84080e7          	jalr	-892(ra) # 80005d0e <panic>

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
    800000f0:	99450513          	addi	a0,a0,-1644 # 80008a80 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	0c6080e7          	jalr	198(ra) # 800061ba <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	ff050513          	addi	a0,a0,-16 # 800220f0 <end>
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
    80000126:	95e48493          	addi	s1,s1,-1698 # 80008a80 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	11e080e7          	jalr	286(ra) # 8000624a <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	94650513          	addi	a0,a0,-1722 # 80008a80 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	1ba080e7          	jalr	442(ra) # 800062fe <release>

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
    8000016a:	91a50513          	addi	a0,a0,-1766 # 80008a80 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	190080e7          	jalr	400(ra) # 800062fe <release>
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
    80000182:	91a7b783          	ld	a5,-1766(a5) # 80008a98 <kmem+0x18>
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
    800001a4:	ca19                	beqz	a2,800001ba <memset+0x1c>
    800001a6:	87aa                	mv	a5,a0
    800001a8:	1602                	slli	a2,a2,0x20
    800001aa:	9201                	srli	a2,a2,0x20
    800001ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001b4:	0785                	addi	a5,a5,1
    800001b6:	fee79de3          	bne	a5,a4,800001b0 <memset+0x12>
  }
  return dst;
}
    800001ba:	6422                	ld	s0,8(sp)
    800001bc:	0141                	addi	sp,sp,16
    800001be:	8082                	ret

00000000800001c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001c0:	1141                	addi	sp,sp,-16
    800001c2:	e422                	sd	s0,8(sp)
    800001c4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001c6:	ca05                	beqz	a2,800001f6 <memcmp+0x36>
    800001c8:	fff6069b          	addiw	a3,a2,-1
    800001cc:	1682                	slli	a3,a3,0x20
    800001ce:	9281                	srli	a3,a3,0x20
    800001d0:	0685                	addi	a3,a3,1
    800001d2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001d4:	00054783          	lbu	a5,0(a0)
    800001d8:	0005c703          	lbu	a4,0(a1)
    800001dc:	00e79863          	bne	a5,a4,800001ec <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001e0:	0505                	addi	a0,a0,1
    800001e2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001e4:	fed518e3          	bne	a0,a3,800001d4 <memcmp+0x14>
  }

  return 0;
    800001e8:	4501                	li	a0,0
    800001ea:	a019                	j	800001f0 <memcmp+0x30>
      return *s1 - *s2;
    800001ec:	40e7853b          	subw	a0,a5,a4
}
    800001f0:	6422                	ld	s0,8(sp)
    800001f2:	0141                	addi	sp,sp,16
    800001f4:	8082                	ret
  return 0;
    800001f6:	4501                	li	a0,0
    800001f8:	bfe5                	j	800001f0 <memcmp+0x30>

00000000800001fa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001fa:	1141                	addi	sp,sp,-16
    800001fc:	e422                	sd	s0,8(sp)
    800001fe:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000200:	c205                	beqz	a2,80000220 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000202:	02a5e263          	bltu	a1,a0,80000226 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000206:	1602                	slli	a2,a2,0x20
    80000208:	9201                	srli	a2,a2,0x20
    8000020a:	00c587b3          	add	a5,a1,a2
{
    8000020e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000210:	0585                	addi	a1,a1,1
    80000212:	0705                	addi	a4,a4,1
    80000214:	fff5c683          	lbu	a3,-1(a1)
    80000218:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000021c:	fef59ae3          	bne	a1,a5,80000210 <memmove+0x16>

  return dst;
}
    80000220:	6422                	ld	s0,8(sp)
    80000222:	0141                	addi	sp,sp,16
    80000224:	8082                	ret
  if(s < d && s + n > d){
    80000226:	02061693          	slli	a3,a2,0x20
    8000022a:	9281                	srli	a3,a3,0x20
    8000022c:	00d58733          	add	a4,a1,a3
    80000230:	fce57be3          	bgeu	a0,a4,80000206 <memmove+0xc>
    d += n;
    80000234:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000236:	fff6079b          	addiw	a5,a2,-1
    8000023a:	1782                	slli	a5,a5,0x20
    8000023c:	9381                	srli	a5,a5,0x20
    8000023e:	fff7c793          	not	a5,a5
    80000242:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000244:	177d                	addi	a4,a4,-1
    80000246:	16fd                	addi	a3,a3,-1
    80000248:	00074603          	lbu	a2,0(a4)
    8000024c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000250:	fee79ae3          	bne	a5,a4,80000244 <memmove+0x4a>
    80000254:	b7f1                	j	80000220 <memmove+0x26>

0000000080000256 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000256:	1141                	addi	sp,sp,-16
    80000258:	e406                	sd	ra,8(sp)
    8000025a:	e022                	sd	s0,0(sp)
    8000025c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000025e:	00000097          	auipc	ra,0x0
    80000262:	f9c080e7          	jalr	-100(ra) # 800001fa <memmove>
}
    80000266:	60a2                	ld	ra,8(sp)
    80000268:	6402                	ld	s0,0(sp)
    8000026a:	0141                	addi	sp,sp,16
    8000026c:	8082                	ret

000000008000026e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000026e:	1141                	addi	sp,sp,-16
    80000270:	e422                	sd	s0,8(sp)
    80000272:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000274:	ce11                	beqz	a2,80000290 <strncmp+0x22>
    80000276:	00054783          	lbu	a5,0(a0)
    8000027a:	cf89                	beqz	a5,80000294 <strncmp+0x26>
    8000027c:	0005c703          	lbu	a4,0(a1)
    80000280:	00f71a63          	bne	a4,a5,80000294 <strncmp+0x26>
    n--, p++, q++;
    80000284:	367d                	addiw	a2,a2,-1
    80000286:	0505                	addi	a0,a0,1
    80000288:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000028a:	f675                	bnez	a2,80000276 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000028c:	4501                	li	a0,0
    8000028e:	a809                	j	800002a0 <strncmp+0x32>
    80000290:	4501                	li	a0,0
    80000292:	a039                	j	800002a0 <strncmp+0x32>
  if(n == 0)
    80000294:	ca09                	beqz	a2,800002a6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000296:	00054503          	lbu	a0,0(a0)
    8000029a:	0005c783          	lbu	a5,0(a1)
    8000029e:	9d1d                	subw	a0,a0,a5
}
    800002a0:	6422                	ld	s0,8(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    return 0;
    800002a6:	4501                	li	a0,0
    800002a8:	bfe5                	j	800002a0 <strncmp+0x32>

00000000800002aa <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002aa:	1141                	addi	sp,sp,-16
    800002ac:	e422                	sd	s0,8(sp)
    800002ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002b0:	872a                	mv	a4,a0
    800002b2:	8832                	mv	a6,a2
    800002b4:	367d                	addiw	a2,a2,-1
    800002b6:	01005963          	blez	a6,800002c8 <strncpy+0x1e>
    800002ba:	0705                	addi	a4,a4,1
    800002bc:	0005c783          	lbu	a5,0(a1)
    800002c0:	fef70fa3          	sb	a5,-1(a4)
    800002c4:	0585                	addi	a1,a1,1
    800002c6:	f7f5                	bnez	a5,800002b2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002c8:	86ba                	mv	a3,a4
    800002ca:	00c05c63          	blez	a2,800002e2 <strncpy+0x38>
    *s++ = 0;
    800002ce:	0685                	addi	a3,a3,1
    800002d0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002d4:	fff6c793          	not	a5,a3
    800002d8:	9fb9                	addw	a5,a5,a4
    800002da:	010787bb          	addw	a5,a5,a6
    800002de:	fef048e3          	bgtz	a5,800002ce <strncpy+0x24>
  return os;
}
    800002e2:	6422                	ld	s0,8(sp)
    800002e4:	0141                	addi	sp,sp,16
    800002e6:	8082                	ret

00000000800002e8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e422                	sd	s0,8(sp)
    800002ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ee:	02c05363          	blez	a2,80000314 <safestrcpy+0x2c>
    800002f2:	fff6069b          	addiw	a3,a2,-1
    800002f6:	1682                	slli	a3,a3,0x20
    800002f8:	9281                	srli	a3,a3,0x20
    800002fa:	96ae                	add	a3,a3,a1
    800002fc:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002fe:	00d58963          	beq	a1,a3,80000310 <safestrcpy+0x28>
    80000302:	0585                	addi	a1,a1,1
    80000304:	0785                	addi	a5,a5,1
    80000306:	fff5c703          	lbu	a4,-1(a1)
    8000030a:	fee78fa3          	sb	a4,-1(a5)
    8000030e:	fb65                	bnez	a4,800002fe <safestrcpy+0x16>
    ;
  *s = 0;
    80000310:	00078023          	sb	zero,0(a5)
  return os;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret

000000008000031a <strlen>:

int
strlen(const char *s)
{
    8000031a:	1141                	addi	sp,sp,-16
    8000031c:	e422                	sd	s0,8(sp)
    8000031e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000320:	00054783          	lbu	a5,0(a0)
    80000324:	cf91                	beqz	a5,80000340 <strlen+0x26>
    80000326:	0505                	addi	a0,a0,1
    80000328:	87aa                	mv	a5,a0
    8000032a:	4685                	li	a3,1
    8000032c:	9e89                	subw	a3,a3,a0
    8000032e:	00f6853b          	addw	a0,a3,a5
    80000332:	0785                	addi	a5,a5,1
    80000334:	fff7c703          	lbu	a4,-1(a5)
    80000338:	fb7d                	bnez	a4,8000032e <strlen+0x14>
    ;
  return n;
}
    8000033a:	6422                	ld	s0,8(sp)
    8000033c:	0141                	addi	sp,sp,16
    8000033e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000340:	4501                	li	a0,0
    80000342:	bfe5                	j	8000033a <strlen+0x20>

0000000080000344 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000344:	1141                	addi	sp,sp,-16
    80000346:	e406                	sd	ra,8(sp)
    80000348:	e022                	sd	s0,0(sp)
    8000034a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000034c:	00001097          	auipc	ra,0x1
    80000350:	b58080e7          	jalr	-1192(ra) # 80000ea4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000354:	00008717          	auipc	a4,0x8
    80000358:	6fc70713          	addi	a4,a4,1788 # 80008a50 <started>
  if(cpuid() == 0){
    8000035c:	c139                	beqz	a0,800003a2 <main+0x5e>
    while(started == 0)
    8000035e:	431c                	lw	a5,0(a4)
    80000360:	2781                	sext.w	a5,a5
    80000362:	dff5                	beqz	a5,8000035e <main+0x1a>
      ;
    __sync_synchronize();
    80000364:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000368:	00001097          	auipc	ra,0x1
    8000036c:	b3c080e7          	jalr	-1220(ra) # 80000ea4 <cpuid>
    80000370:	85aa                	mv	a1,a0
    80000372:	00008517          	auipc	a0,0x8
    80000376:	cc650513          	addi	a0,a0,-826 # 80008038 <etext+0x38>
    8000037a:	00006097          	auipc	ra,0x6
    8000037e:	9de080e7          	jalr	-1570(ra) # 80005d58 <printf>
    kvminithart();    // turn on paging
    80000382:	00000097          	auipc	ra,0x0
    80000386:	0d8080e7          	jalr	216(ra) # 8000045a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000038a:	00002097          	auipc	ra,0x2
    8000038e:	81e080e7          	jalr	-2018(ra) # 80001ba8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000392:	00005097          	auipc	ra,0x5
    80000396:	e7e080e7          	jalr	-386(ra) # 80005210 <plicinithart>
  }

  scheduler();        
    8000039a:	00001097          	auipc	ra,0x1
    8000039e:	038080e7          	jalr	56(ra) # 800013d2 <scheduler>
    consoleinit();
    800003a2:	00006097          	auipc	ra,0x6
    800003a6:	87e080e7          	jalr	-1922(ra) # 80005c20 <consoleinit>
    printfinit();
    800003aa:	00006097          	auipc	ra,0x6
    800003ae:	b8e080e7          	jalr	-1138(ra) # 80005f38 <printfinit>
    printf("\n");
    800003b2:	00008517          	auipc	a0,0x8
    800003b6:	c9650513          	addi	a0,a0,-874 # 80008048 <etext+0x48>
    800003ba:	00006097          	auipc	ra,0x6
    800003be:	99e080e7          	jalr	-1634(ra) # 80005d58 <printf>
    printf("xv6 kernel is booting\n");
    800003c2:	00008517          	auipc	a0,0x8
    800003c6:	c5e50513          	addi	a0,a0,-930 # 80008020 <etext+0x20>
    800003ca:	00006097          	auipc	ra,0x6
    800003ce:	98e080e7          	jalr	-1650(ra) # 80005d58 <printf>
    printf("\n");
    800003d2:	00008517          	auipc	a0,0x8
    800003d6:	c7650513          	addi	a0,a0,-906 # 80008048 <etext+0x48>
    800003da:	00006097          	auipc	ra,0x6
    800003de:	97e080e7          	jalr	-1666(ra) # 80005d58 <printf>
    kinit();         // physical page allocator
    800003e2:	00000097          	auipc	ra,0x0
    800003e6:	cfa080e7          	jalr	-774(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003ea:	00000097          	auipc	ra,0x0
    800003ee:	34a080e7          	jalr	842(ra) # 80000734 <kvminit>
    kvminithart();   // turn on paging
    800003f2:	00000097          	auipc	ra,0x0
    800003f6:	068080e7          	jalr	104(ra) # 8000045a <kvminithart>
    procinit();      // process table
    800003fa:	00001097          	auipc	ra,0x1
    800003fe:	9f6080e7          	jalr	-1546(ra) # 80000df0 <procinit>
    trapinit();      // trap vectors
    80000402:	00001097          	auipc	ra,0x1
    80000406:	77e080e7          	jalr	1918(ra) # 80001b80 <trapinit>
    trapinithart();  // install kernel trap vector
    8000040a:	00001097          	auipc	ra,0x1
    8000040e:	79e080e7          	jalr	1950(ra) # 80001ba8 <trapinithart>
    plicinit();      // set up interrupt controller
    80000412:	00005097          	auipc	ra,0x5
    80000416:	de8080e7          	jalr	-536(ra) # 800051fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000041a:	00005097          	auipc	ra,0x5
    8000041e:	df6080e7          	jalr	-522(ra) # 80005210 <plicinithart>
    binit();         // buffer cache
    80000422:	00002097          	auipc	ra,0x2
    80000426:	f9c080e7          	jalr	-100(ra) # 800023be <binit>
    iinit();         // inode table
    8000042a:	00002097          	auipc	ra,0x2
    8000042e:	640080e7          	jalr	1600(ra) # 80002a6a <iinit>
    fileinit();      // file table
    80000432:	00003097          	auipc	ra,0x3
    80000436:	5de080e7          	jalr	1502(ra) # 80003a10 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000043a:	00005097          	auipc	ra,0x5
    8000043e:	ede080e7          	jalr	-290(ra) # 80005318 <virtio_disk_init>
    userinit();      // first user process
    80000442:	00001097          	auipc	ra,0x1
    80000446:	d6a080e7          	jalr	-662(ra) # 800011ac <userinit>
    __sync_synchronize();
    8000044a:	0ff0000f          	fence
    started = 1;
    8000044e:	4785                	li	a5,1
    80000450:	00008717          	auipc	a4,0x8
    80000454:	60f72023          	sw	a5,1536(a4) # 80008a50 <started>
    80000458:	b789                	j	8000039a <main+0x56>

000000008000045a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000045a:	1141                	addi	sp,sp,-16
    8000045c:	e422                	sd	s0,8(sp)
    8000045e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000460:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000464:	00008797          	auipc	a5,0x8
    80000468:	5f47b783          	ld	a5,1524(a5) # 80008a58 <kernel_pagetable>
    8000046c:	83b1                	srli	a5,a5,0xc
    8000046e:	577d                	li	a4,-1
    80000470:	177e                	slli	a4,a4,0x3f
    80000472:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000474:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000478:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000047c:	6422                	ld	s0,8(sp)
    8000047e:	0141                	addi	sp,sp,16
    80000480:	8082                	ret

0000000080000482 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000482:	7139                	addi	sp,sp,-64
    80000484:	fc06                	sd	ra,56(sp)
    80000486:	f822                	sd	s0,48(sp)
    80000488:	f426                	sd	s1,40(sp)
    8000048a:	f04a                	sd	s2,32(sp)
    8000048c:	ec4e                	sd	s3,24(sp)
    8000048e:	e852                	sd	s4,16(sp)
    80000490:	e456                	sd	s5,8(sp)
    80000492:	e05a                	sd	s6,0(sp)
    80000494:	0080                	addi	s0,sp,64
    80000496:	84aa                	mv	s1,a0
    80000498:	89ae                	mv	s3,a1
    8000049a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000049c:	57fd                	li	a5,-1
    8000049e:	83e9                	srli	a5,a5,0x1a
    800004a0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004a2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004a4:	04b7f263          	bgeu	a5,a1,800004e8 <walk+0x66>
    panic("walk");
    800004a8:	00008517          	auipc	a0,0x8
    800004ac:	ba850513          	addi	a0,a0,-1112 # 80008050 <etext+0x50>
    800004b0:	00006097          	auipc	ra,0x6
    800004b4:	85e080e7          	jalr	-1954(ra) # 80005d0e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004b8:	060a8663          	beqz	s5,80000524 <walk+0xa2>
    800004bc:	00000097          	auipc	ra,0x0
    800004c0:	c5c080e7          	jalr	-932(ra) # 80000118 <kalloc>
    800004c4:	84aa                	mv	s1,a0
    800004c6:	c529                	beqz	a0,80000510 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004c8:	6605                	lui	a2,0x1
    800004ca:	4581                	li	a1,0
    800004cc:	00000097          	auipc	ra,0x0
    800004d0:	cd2080e7          	jalr	-814(ra) # 8000019e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004d4:	00c4d793          	srli	a5,s1,0xc
    800004d8:	07aa                	slli	a5,a5,0xa
    800004da:	0017e793          	ori	a5,a5,1
    800004de:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004e2:	3a5d                	addiw	s4,s4,-9
    800004e4:	036a0063          	beq	s4,s6,80000504 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004e8:	0149d933          	srl	s2,s3,s4
    800004ec:	1ff97913          	andi	s2,s2,511
    800004f0:	090e                	slli	s2,s2,0x3
    800004f2:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004f4:	00093483          	ld	s1,0(s2)
    800004f8:	0014f793          	andi	a5,s1,1
    800004fc:	dfd5                	beqz	a5,800004b8 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004fe:	80a9                	srli	s1,s1,0xa
    80000500:	04b2                	slli	s1,s1,0xc
    80000502:	b7c5                	j	800004e2 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000504:	00c9d513          	srli	a0,s3,0xc
    80000508:	1ff57513          	andi	a0,a0,511
    8000050c:	050e                	slli	a0,a0,0x3
    8000050e:	9526                	add	a0,a0,s1
}
    80000510:	70e2                	ld	ra,56(sp)
    80000512:	7442                	ld	s0,48(sp)
    80000514:	74a2                	ld	s1,40(sp)
    80000516:	7902                	ld	s2,32(sp)
    80000518:	69e2                	ld	s3,24(sp)
    8000051a:	6a42                	ld	s4,16(sp)
    8000051c:	6aa2                	ld	s5,8(sp)
    8000051e:	6b02                	ld	s6,0(sp)
    80000520:	6121                	addi	sp,sp,64
    80000522:	8082                	ret
        return 0;
    80000524:	4501                	li	a0,0
    80000526:	b7ed                	j	80000510 <walk+0x8e>

0000000080000528 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000528:	57fd                	li	a5,-1
    8000052a:	83e9                	srli	a5,a5,0x1a
    8000052c:	00b7f463          	bgeu	a5,a1,80000534 <walkaddr+0xc>
    return 0;
    80000530:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000532:	8082                	ret
{
    80000534:	1141                	addi	sp,sp,-16
    80000536:	e406                	sd	ra,8(sp)
    80000538:	e022                	sd	s0,0(sp)
    8000053a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000053c:	4601                	li	a2,0
    8000053e:	00000097          	auipc	ra,0x0
    80000542:	f44080e7          	jalr	-188(ra) # 80000482 <walk>
  if(pte == 0)
    80000546:	c105                	beqz	a0,80000566 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000548:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000054a:	0117f693          	andi	a3,a5,17
    8000054e:	4745                	li	a4,17
    return 0;
    80000550:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000552:	00e68663          	beq	a3,a4,8000055e <walkaddr+0x36>
}
    80000556:	60a2                	ld	ra,8(sp)
    80000558:	6402                	ld	s0,0(sp)
    8000055a:	0141                	addi	sp,sp,16
    8000055c:	8082                	ret
  pa = PTE2PA(*pte);
    8000055e:	00a7d513          	srli	a0,a5,0xa
    80000562:	0532                	slli	a0,a0,0xc
  return pa;
    80000564:	bfcd                	j	80000556 <walkaddr+0x2e>
    return 0;
    80000566:	4501                	li	a0,0
    80000568:	b7fd                	j	80000556 <walkaddr+0x2e>

000000008000056a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000056a:	715d                	addi	sp,sp,-80
    8000056c:	e486                	sd	ra,72(sp)
    8000056e:	e0a2                	sd	s0,64(sp)
    80000570:	fc26                	sd	s1,56(sp)
    80000572:	f84a                	sd	s2,48(sp)
    80000574:	f44e                	sd	s3,40(sp)
    80000576:	f052                	sd	s4,32(sp)
    80000578:	ec56                	sd	s5,24(sp)
    8000057a:	e85a                	sd	s6,16(sp)
    8000057c:	e45e                	sd	s7,8(sp)
    8000057e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000580:	03459793          	slli	a5,a1,0x34
    80000584:	e7b9                	bnez	a5,800005d2 <mappages+0x68>
    80000586:	8aaa                	mv	s5,a0
    80000588:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000058a:	03461793          	slli	a5,a2,0x34
    8000058e:	ebb1                	bnez	a5,800005e2 <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    80000590:	c22d                	beqz	a2,800005f2 <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000592:	79fd                	lui	s3,0xfffff
    80000594:	964e                	add	a2,a2,s3
    80000596:	00b609b3          	add	s3,a2,a1
  a = va;
    8000059a:	892e                	mv	s2,a1
    8000059c:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005a0:	6b85                	lui	s7,0x1
    800005a2:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a6:	4605                	li	a2,1
    800005a8:	85ca                	mv	a1,s2
    800005aa:	8556                	mv	a0,s5
    800005ac:	00000097          	auipc	ra,0x0
    800005b0:	ed6080e7          	jalr	-298(ra) # 80000482 <walk>
    800005b4:	cd39                	beqz	a0,80000612 <mappages+0xa8>
    if(*pte & PTE_V)
    800005b6:	611c                	ld	a5,0(a0)
    800005b8:	8b85                	andi	a5,a5,1
    800005ba:	e7a1                	bnez	a5,80000602 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005bc:	80b1                	srli	s1,s1,0xc
    800005be:	04aa                	slli	s1,s1,0xa
    800005c0:	0164e4b3          	or	s1,s1,s6
    800005c4:	0014e493          	ori	s1,s1,1
    800005c8:	e104                	sd	s1,0(a0)
    if(a == last)
    800005ca:	07390063          	beq	s2,s3,8000062a <mappages+0xc0>
    a += PGSIZE;
    800005ce:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005d0:	bfc9                	j	800005a2 <mappages+0x38>
    panic("mappages: va not aligned");
    800005d2:	00008517          	auipc	a0,0x8
    800005d6:	a8650513          	addi	a0,a0,-1402 # 80008058 <etext+0x58>
    800005da:	00005097          	auipc	ra,0x5
    800005de:	734080e7          	jalr	1844(ra) # 80005d0e <panic>
    panic("mappages: size not aligned");
    800005e2:	00008517          	auipc	a0,0x8
    800005e6:	a9650513          	addi	a0,a0,-1386 # 80008078 <etext+0x78>
    800005ea:	00005097          	auipc	ra,0x5
    800005ee:	724080e7          	jalr	1828(ra) # 80005d0e <panic>
    panic("mappages: size");
    800005f2:	00008517          	auipc	a0,0x8
    800005f6:	aa650513          	addi	a0,a0,-1370 # 80008098 <etext+0x98>
    800005fa:	00005097          	auipc	ra,0x5
    800005fe:	714080e7          	jalr	1812(ra) # 80005d0e <panic>
      panic("mappages: remap");
    80000602:	00008517          	auipc	a0,0x8
    80000606:	aa650513          	addi	a0,a0,-1370 # 800080a8 <etext+0xa8>
    8000060a:	00005097          	auipc	ra,0x5
    8000060e:	704080e7          	jalr	1796(ra) # 80005d0e <panic>
      return -1;
    80000612:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000614:	60a6                	ld	ra,72(sp)
    80000616:	6406                	ld	s0,64(sp)
    80000618:	74e2                	ld	s1,56(sp)
    8000061a:	7942                	ld	s2,48(sp)
    8000061c:	79a2                	ld	s3,40(sp)
    8000061e:	7a02                	ld	s4,32(sp)
    80000620:	6ae2                	ld	s5,24(sp)
    80000622:	6b42                	ld	s6,16(sp)
    80000624:	6ba2                	ld	s7,8(sp)
    80000626:	6161                	addi	sp,sp,80
    80000628:	8082                	ret
  return 0;
    8000062a:	4501                	li	a0,0
    8000062c:	b7e5                	j	80000614 <mappages+0xaa>

000000008000062e <kvmmap>:
{
    8000062e:	1141                	addi	sp,sp,-16
    80000630:	e406                	sd	ra,8(sp)
    80000632:	e022                	sd	s0,0(sp)
    80000634:	0800                	addi	s0,sp,16
    80000636:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000638:	86b2                	mv	a3,a2
    8000063a:	863e                	mv	a2,a5
    8000063c:	00000097          	auipc	ra,0x0
    80000640:	f2e080e7          	jalr	-210(ra) # 8000056a <mappages>
    80000644:	e509                	bnez	a0,8000064e <kvmmap+0x20>
}
    80000646:	60a2                	ld	ra,8(sp)
    80000648:	6402                	ld	s0,0(sp)
    8000064a:	0141                	addi	sp,sp,16
    8000064c:	8082                	ret
    panic("kvmmap");
    8000064e:	00008517          	auipc	a0,0x8
    80000652:	a6a50513          	addi	a0,a0,-1430 # 800080b8 <etext+0xb8>
    80000656:	00005097          	auipc	ra,0x5
    8000065a:	6b8080e7          	jalr	1720(ra) # 80005d0e <panic>

000000008000065e <kvmmake>:
{
    8000065e:	1101                	addi	sp,sp,-32
    80000660:	ec06                	sd	ra,24(sp)
    80000662:	e822                	sd	s0,16(sp)
    80000664:	e426                	sd	s1,8(sp)
    80000666:	e04a                	sd	s2,0(sp)
    80000668:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000066a:	00000097          	auipc	ra,0x0
    8000066e:	aae080e7          	jalr	-1362(ra) # 80000118 <kalloc>
    80000672:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000674:	6605                	lui	a2,0x1
    80000676:	4581                	li	a1,0
    80000678:	00000097          	auipc	ra,0x0
    8000067c:	b26080e7          	jalr	-1242(ra) # 8000019e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000680:	4719                	li	a4,6
    80000682:	6685                	lui	a3,0x1
    80000684:	10000637          	lui	a2,0x10000
    80000688:	100005b7          	lui	a1,0x10000
    8000068c:	8526                	mv	a0,s1
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	fa0080e7          	jalr	-96(ra) # 8000062e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000696:	4719                	li	a4,6
    80000698:	6685                	lui	a3,0x1
    8000069a:	10001637          	lui	a2,0x10001
    8000069e:	100015b7          	lui	a1,0x10001
    800006a2:	8526                	mv	a0,s1
    800006a4:	00000097          	auipc	ra,0x0
    800006a8:	f8a080e7          	jalr	-118(ra) # 8000062e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006ac:	4719                	li	a4,6
    800006ae:	004006b7          	lui	a3,0x400
    800006b2:	0c000637          	lui	a2,0xc000
    800006b6:	0c0005b7          	lui	a1,0xc000
    800006ba:	8526                	mv	a0,s1
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	f72080e7          	jalr	-142(ra) # 8000062e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c4:	00008917          	auipc	s2,0x8
    800006c8:	93c90913          	addi	s2,s2,-1732 # 80008000 <etext>
    800006cc:	4729                	li	a4,10
    800006ce:	80008697          	auipc	a3,0x80008
    800006d2:	93268693          	addi	a3,a3,-1742 # 8000 <_entry-0x7fff8000>
    800006d6:	4605                	li	a2,1
    800006d8:	067e                	slli	a2,a2,0x1f
    800006da:	85b2                	mv	a1,a2
    800006dc:	8526                	mv	a0,s1
    800006de:	00000097          	auipc	ra,0x0
    800006e2:	f50080e7          	jalr	-176(ra) # 8000062e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006e6:	4719                	li	a4,6
    800006e8:	46c5                	li	a3,17
    800006ea:	06ee                	slli	a3,a3,0x1b
    800006ec:	412686b3          	sub	a3,a3,s2
    800006f0:	864a                	mv	a2,s2
    800006f2:	85ca                	mv	a1,s2
    800006f4:	8526                	mv	a0,s1
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f38080e7          	jalr	-200(ra) # 8000062e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006fe:	4729                	li	a4,10
    80000700:	6685                	lui	a3,0x1
    80000702:	00007617          	auipc	a2,0x7
    80000706:	8fe60613          	addi	a2,a2,-1794 # 80007000 <_trampoline>
    8000070a:	040005b7          	lui	a1,0x4000
    8000070e:	15fd                	addi	a1,a1,-1
    80000710:	05b2                	slli	a1,a1,0xc
    80000712:	8526                	mv	a0,s1
    80000714:	00000097          	auipc	ra,0x0
    80000718:	f1a080e7          	jalr	-230(ra) # 8000062e <kvmmap>
  proc_mapstacks(kpgtbl);
    8000071c:	8526                	mv	a0,s1
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	63c080e7          	jalr	1596(ra) # 80000d5a <proc_mapstacks>
}
    80000726:	8526                	mv	a0,s1
    80000728:	60e2                	ld	ra,24(sp)
    8000072a:	6442                	ld	s0,16(sp)
    8000072c:	64a2                	ld	s1,8(sp)
    8000072e:	6902                	ld	s2,0(sp)
    80000730:	6105                	addi	sp,sp,32
    80000732:	8082                	ret

0000000080000734 <kvminit>:
{
    80000734:	1141                	addi	sp,sp,-16
    80000736:	e406                	sd	ra,8(sp)
    80000738:	e022                	sd	s0,0(sp)
    8000073a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000073c:	00000097          	auipc	ra,0x0
    80000740:	f22080e7          	jalr	-222(ra) # 8000065e <kvmmake>
    80000744:	00008797          	auipc	a5,0x8
    80000748:	30a7ba23          	sd	a0,788(a5) # 80008a58 <kernel_pagetable>
}
    8000074c:	60a2                	ld	ra,8(sp)
    8000074e:	6402                	ld	s0,0(sp)
    80000750:	0141                	addi	sp,sp,16
    80000752:	8082                	ret

0000000080000754 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000754:	715d                	addi	sp,sp,-80
    80000756:	e486                	sd	ra,72(sp)
    80000758:	e0a2                	sd	s0,64(sp)
    8000075a:	fc26                	sd	s1,56(sp)
    8000075c:	f84a                	sd	s2,48(sp)
    8000075e:	f44e                	sd	s3,40(sp)
    80000760:	f052                	sd	s4,32(sp)
    80000762:	ec56                	sd	s5,24(sp)
    80000764:	e85a                	sd	s6,16(sp)
    80000766:	e45e                	sd	s7,8(sp)
    80000768:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000076a:	03459793          	slli	a5,a1,0x34
    8000076e:	e795                	bnez	a5,8000079a <uvmunmap+0x46>
    80000770:	8a2a                	mv	s4,a0
    80000772:	892e                	mv	s2,a1
    80000774:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000776:	0632                	slli	a2,a2,0xc
    80000778:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000077c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077e:	6b05                	lui	s6,0x1
    80000780:	0735e263          	bltu	a1,s3,800007e4 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000784:	60a6                	ld	ra,72(sp)
    80000786:	6406                	ld	s0,64(sp)
    80000788:	74e2                	ld	s1,56(sp)
    8000078a:	7942                	ld	s2,48(sp)
    8000078c:	79a2                	ld	s3,40(sp)
    8000078e:	7a02                	ld	s4,32(sp)
    80000790:	6ae2                	ld	s5,24(sp)
    80000792:	6b42                	ld	s6,16(sp)
    80000794:	6ba2                	ld	s7,8(sp)
    80000796:	6161                	addi	sp,sp,80
    80000798:	8082                	ret
    panic("uvmunmap: not aligned");
    8000079a:	00008517          	auipc	a0,0x8
    8000079e:	92650513          	addi	a0,a0,-1754 # 800080c0 <etext+0xc0>
    800007a2:	00005097          	auipc	ra,0x5
    800007a6:	56c080e7          	jalr	1388(ra) # 80005d0e <panic>
      panic("uvmunmap: walk");
    800007aa:	00008517          	auipc	a0,0x8
    800007ae:	92e50513          	addi	a0,a0,-1746 # 800080d8 <etext+0xd8>
    800007b2:	00005097          	auipc	ra,0x5
    800007b6:	55c080e7          	jalr	1372(ra) # 80005d0e <panic>
      panic("uvmunmap: not mapped");
    800007ba:	00008517          	auipc	a0,0x8
    800007be:	92e50513          	addi	a0,a0,-1746 # 800080e8 <etext+0xe8>
    800007c2:	00005097          	auipc	ra,0x5
    800007c6:	54c080e7          	jalr	1356(ra) # 80005d0e <panic>
      panic("uvmunmap: not a leaf");
    800007ca:	00008517          	auipc	a0,0x8
    800007ce:	93650513          	addi	a0,a0,-1738 # 80008100 <etext+0x100>
    800007d2:	00005097          	auipc	ra,0x5
    800007d6:	53c080e7          	jalr	1340(ra) # 80005d0e <panic>
    *pte = 0;
    800007da:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007de:	995a                	add	s2,s2,s6
    800007e0:	fb3972e3          	bgeu	s2,s3,80000784 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007e4:	4601                	li	a2,0
    800007e6:	85ca                	mv	a1,s2
    800007e8:	8552                	mv	a0,s4
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	c98080e7          	jalr	-872(ra) # 80000482 <walk>
    800007f2:	84aa                	mv	s1,a0
    800007f4:	d95d                	beqz	a0,800007aa <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007f6:	6108                	ld	a0,0(a0)
    800007f8:	00157793          	andi	a5,a0,1
    800007fc:	dfdd                	beqz	a5,800007ba <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007fe:	3ff57793          	andi	a5,a0,1023
    80000802:	fd7784e3          	beq	a5,s7,800007ca <uvmunmap+0x76>
    if(do_free){
    80000806:	fc0a8ae3          	beqz	s5,800007da <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000080a:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000080c:	0532                	slli	a0,a0,0xc
    8000080e:	00000097          	auipc	ra,0x0
    80000812:	80e080e7          	jalr	-2034(ra) # 8000001c <kfree>
    80000816:	b7d1                	j	800007da <uvmunmap+0x86>

0000000080000818 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000818:	1101                	addi	sp,sp,-32
    8000081a:	ec06                	sd	ra,24(sp)
    8000081c:	e822                	sd	s0,16(sp)
    8000081e:	e426                	sd	s1,8(sp)
    80000820:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000822:	00000097          	auipc	ra,0x0
    80000826:	8f6080e7          	jalr	-1802(ra) # 80000118 <kalloc>
    8000082a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000082c:	c519                	beqz	a0,8000083a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000082e:	6605                	lui	a2,0x1
    80000830:	4581                	li	a1,0
    80000832:	00000097          	auipc	ra,0x0
    80000836:	96c080e7          	jalr	-1684(ra) # 8000019e <memset>
  return pagetable;
}
    8000083a:	8526                	mv	a0,s1
    8000083c:	60e2                	ld	ra,24(sp)
    8000083e:	6442                	ld	s0,16(sp)
    80000840:	64a2                	ld	s1,8(sp)
    80000842:	6105                	addi	sp,sp,32
    80000844:	8082                	ret

0000000080000846 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000846:	7179                	addi	sp,sp,-48
    80000848:	f406                	sd	ra,40(sp)
    8000084a:	f022                	sd	s0,32(sp)
    8000084c:	ec26                	sd	s1,24(sp)
    8000084e:	e84a                	sd	s2,16(sp)
    80000850:	e44e                	sd	s3,8(sp)
    80000852:	e052                	sd	s4,0(sp)
    80000854:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000856:	6785                	lui	a5,0x1
    80000858:	04f67863          	bgeu	a2,a5,800008a8 <uvmfirst+0x62>
    8000085c:	8a2a                	mv	s4,a0
    8000085e:	89ae                	mv	s3,a1
    80000860:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000862:	00000097          	auipc	ra,0x0
    80000866:	8b6080e7          	jalr	-1866(ra) # 80000118 <kalloc>
    8000086a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000086c:	6605                	lui	a2,0x1
    8000086e:	4581                	li	a1,0
    80000870:	00000097          	auipc	ra,0x0
    80000874:	92e080e7          	jalr	-1746(ra) # 8000019e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000878:	4779                	li	a4,30
    8000087a:	86ca                	mv	a3,s2
    8000087c:	6605                	lui	a2,0x1
    8000087e:	4581                	li	a1,0
    80000880:	8552                	mv	a0,s4
    80000882:	00000097          	auipc	ra,0x0
    80000886:	ce8080e7          	jalr	-792(ra) # 8000056a <mappages>
  memmove(mem, src, sz);
    8000088a:	8626                	mv	a2,s1
    8000088c:	85ce                	mv	a1,s3
    8000088e:	854a                	mv	a0,s2
    80000890:	00000097          	auipc	ra,0x0
    80000894:	96a080e7          	jalr	-1686(ra) # 800001fa <memmove>
}
    80000898:	70a2                	ld	ra,40(sp)
    8000089a:	7402                	ld	s0,32(sp)
    8000089c:	64e2                	ld	s1,24(sp)
    8000089e:	6942                	ld	s2,16(sp)
    800008a0:	69a2                	ld	s3,8(sp)
    800008a2:	6a02                	ld	s4,0(sp)
    800008a4:	6145                	addi	sp,sp,48
    800008a6:	8082                	ret
    panic("uvmfirst: more than a page");
    800008a8:	00008517          	auipc	a0,0x8
    800008ac:	87050513          	addi	a0,a0,-1936 # 80008118 <etext+0x118>
    800008b0:	00005097          	auipc	ra,0x5
    800008b4:	45e080e7          	jalr	1118(ra) # 80005d0e <panic>

00000000800008b8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008b8:	1101                	addi	sp,sp,-32
    800008ba:	ec06                	sd	ra,24(sp)
    800008bc:	e822                	sd	s0,16(sp)
    800008be:	e426                	sd	s1,8(sp)
    800008c0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c4:	00b67d63          	bgeu	a2,a1,800008de <uvmdealloc+0x26>
    800008c8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ca:	6785                	lui	a5,0x1
    800008cc:	17fd                	addi	a5,a5,-1
    800008ce:	00f60733          	add	a4,a2,a5
    800008d2:	767d                	lui	a2,0xfffff
    800008d4:	8f71                	and	a4,a4,a2
    800008d6:	97ae                	add	a5,a5,a1
    800008d8:	8ff1                	and	a5,a5,a2
    800008da:	00f76863          	bltu	a4,a5,800008ea <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008de:	8526                	mv	a0,s1
    800008e0:	60e2                	ld	ra,24(sp)
    800008e2:	6442                	ld	s0,16(sp)
    800008e4:	64a2                	ld	s1,8(sp)
    800008e6:	6105                	addi	sp,sp,32
    800008e8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ea:	8f99                	sub	a5,a5,a4
    800008ec:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ee:	4685                	li	a3,1
    800008f0:	0007861b          	sext.w	a2,a5
    800008f4:	85ba                	mv	a1,a4
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	e5e080e7          	jalr	-418(ra) # 80000754 <uvmunmap>
    800008fe:	b7c5                	j	800008de <uvmdealloc+0x26>

0000000080000900 <uvmalloc>:
  if(newsz < oldsz)
    80000900:	0ab66563          	bltu	a2,a1,800009aa <uvmalloc+0xaa>
{
    80000904:	7139                	addi	sp,sp,-64
    80000906:	fc06                	sd	ra,56(sp)
    80000908:	f822                	sd	s0,48(sp)
    8000090a:	f426                	sd	s1,40(sp)
    8000090c:	f04a                	sd	s2,32(sp)
    8000090e:	ec4e                	sd	s3,24(sp)
    80000910:	e852                	sd	s4,16(sp)
    80000912:	e456                	sd	s5,8(sp)
    80000914:	e05a                	sd	s6,0(sp)
    80000916:	0080                	addi	s0,sp,64
    80000918:	8aaa                	mv	s5,a0
    8000091a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091c:	6985                	lui	s3,0x1
    8000091e:	19fd                	addi	s3,s3,-1
    80000920:	95ce                	add	a1,a1,s3
    80000922:	79fd                	lui	s3,0xfffff
    80000924:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000928:	08c9f363          	bgeu	s3,a2,800009ae <uvmalloc+0xae>
    8000092c:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000092e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000932:	fffff097          	auipc	ra,0xfffff
    80000936:	7e6080e7          	jalr	2022(ra) # 80000118 <kalloc>
    8000093a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093c:	c51d                	beqz	a0,8000096a <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000093e:	6605                	lui	a2,0x1
    80000940:	4581                	li	a1,0
    80000942:	00000097          	auipc	ra,0x0
    80000946:	85c080e7          	jalr	-1956(ra) # 8000019e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000094a:	875a                	mv	a4,s6
    8000094c:	86a6                	mv	a3,s1
    8000094e:	6605                	lui	a2,0x1
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	c16080e7          	jalr	-1002(ra) # 8000056a <mappages>
    8000095c:	e90d                	bnez	a0,8000098e <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095e:	6785                	lui	a5,0x1
    80000960:	993e                	add	s2,s2,a5
    80000962:	fd4968e3          	bltu	s2,s4,80000932 <uvmalloc+0x32>
  return newsz;
    80000966:	8552                	mv	a0,s4
    80000968:	a809                	j	8000097a <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000096a:	864e                	mv	a2,s3
    8000096c:	85ca                	mv	a1,s2
    8000096e:	8556                	mv	a0,s5
    80000970:	00000097          	auipc	ra,0x0
    80000974:	f48080e7          	jalr	-184(ra) # 800008b8 <uvmdealloc>
      return 0;
    80000978:	4501                	li	a0,0
}
    8000097a:	70e2                	ld	ra,56(sp)
    8000097c:	7442                	ld	s0,48(sp)
    8000097e:	74a2                	ld	s1,40(sp)
    80000980:	7902                	ld	s2,32(sp)
    80000982:	69e2                	ld	s3,24(sp)
    80000984:	6a42                	ld	s4,16(sp)
    80000986:	6aa2                	ld	s5,8(sp)
    80000988:	6b02                	ld	s6,0(sp)
    8000098a:	6121                	addi	sp,sp,64
    8000098c:	8082                	ret
      kfree(mem);
    8000098e:	8526                	mv	a0,s1
    80000990:	fffff097          	auipc	ra,0xfffff
    80000994:	68c080e7          	jalr	1676(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000998:	864e                	mv	a2,s3
    8000099a:	85ca                	mv	a1,s2
    8000099c:	8556                	mv	a0,s5
    8000099e:	00000097          	auipc	ra,0x0
    800009a2:	f1a080e7          	jalr	-230(ra) # 800008b8 <uvmdealloc>
      return 0;
    800009a6:	4501                	li	a0,0
    800009a8:	bfc9                	j	8000097a <uvmalloc+0x7a>
    return oldsz;
    800009aa:	852e                	mv	a0,a1
}
    800009ac:	8082                	ret
  return newsz;
    800009ae:	8532                	mv	a0,a2
    800009b0:	b7e9                	j	8000097a <uvmalloc+0x7a>

00000000800009b2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009b2:	7179                	addi	sp,sp,-48
    800009b4:	f406                	sd	ra,40(sp)
    800009b6:	f022                	sd	s0,32(sp)
    800009b8:	ec26                	sd	s1,24(sp)
    800009ba:	e84a                	sd	s2,16(sp)
    800009bc:	e44e                	sd	s3,8(sp)
    800009be:	e052                	sd	s4,0(sp)
    800009c0:	1800                	addi	s0,sp,48
    800009c2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009c4:	84aa                	mv	s1,a0
    800009c6:	6905                	lui	s2,0x1
    800009c8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ca:	4985                	li	s3,1
    800009cc:	a821                	j	800009e4 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009ce:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009d0:	0532                	slli	a0,a0,0xc
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	fe0080e7          	jalr	-32(ra) # 800009b2 <freewalk>
      pagetable[i] = 0;
    800009da:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009de:	04a1                	addi	s1,s1,8
    800009e0:	03248163          	beq	s1,s2,80000a02 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009e4:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e6:	00f57793          	andi	a5,a0,15
    800009ea:	ff3782e3          	beq	a5,s3,800009ce <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ee:	8905                	andi	a0,a0,1
    800009f0:	d57d                	beqz	a0,800009de <freewalk+0x2c>
      panic("freewalk: leaf");
    800009f2:	00007517          	auipc	a0,0x7
    800009f6:	74650513          	addi	a0,a0,1862 # 80008138 <etext+0x138>
    800009fa:	00005097          	auipc	ra,0x5
    800009fe:	314080e7          	jalr	788(ra) # 80005d0e <panic>
    }
  }
  kfree((void*)pagetable);
    80000a02:	8552                	mv	a0,s4
    80000a04:	fffff097          	auipc	ra,0xfffff
    80000a08:	618080e7          	jalr	1560(ra) # 8000001c <kfree>
}
    80000a0c:	70a2                	ld	ra,40(sp)
    80000a0e:	7402                	ld	s0,32(sp)
    80000a10:	64e2                	ld	s1,24(sp)
    80000a12:	6942                	ld	s2,16(sp)
    80000a14:	69a2                	ld	s3,8(sp)
    80000a16:	6a02                	ld	s4,0(sp)
    80000a18:	6145                	addi	sp,sp,48
    80000a1a:	8082                	ret

0000000080000a1c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a1c:	1101                	addi	sp,sp,-32
    80000a1e:	ec06                	sd	ra,24(sp)
    80000a20:	e822                	sd	s0,16(sp)
    80000a22:	e426                	sd	s1,8(sp)
    80000a24:	1000                	addi	s0,sp,32
    80000a26:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a28:	e999                	bnez	a1,80000a3e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a2a:	8526                	mv	a0,s1
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	f86080e7          	jalr	-122(ra) # 800009b2 <freewalk>
}
    80000a34:	60e2                	ld	ra,24(sp)
    80000a36:	6442                	ld	s0,16(sp)
    80000a38:	64a2                	ld	s1,8(sp)
    80000a3a:	6105                	addi	sp,sp,32
    80000a3c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a3e:	6605                	lui	a2,0x1
    80000a40:	167d                	addi	a2,a2,-1
    80000a42:	962e                	add	a2,a2,a1
    80000a44:	4685                	li	a3,1
    80000a46:	8231                	srli	a2,a2,0xc
    80000a48:	4581                	li	a1,0
    80000a4a:	00000097          	auipc	ra,0x0
    80000a4e:	d0a080e7          	jalr	-758(ra) # 80000754 <uvmunmap>
    80000a52:	bfe1                	j	80000a2a <uvmfree+0xe>

0000000080000a54 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a54:	c679                	beqz	a2,80000b22 <uvmcopy+0xce>
{
    80000a56:	715d                	addi	sp,sp,-80
    80000a58:	e486                	sd	ra,72(sp)
    80000a5a:	e0a2                	sd	s0,64(sp)
    80000a5c:	fc26                	sd	s1,56(sp)
    80000a5e:	f84a                	sd	s2,48(sp)
    80000a60:	f44e                	sd	s3,40(sp)
    80000a62:	f052                	sd	s4,32(sp)
    80000a64:	ec56                	sd	s5,24(sp)
    80000a66:	e85a                	sd	s6,16(sp)
    80000a68:	e45e                	sd	s7,8(sp)
    80000a6a:	0880                	addi	s0,sp,80
    80000a6c:	8b2a                	mv	s6,a0
    80000a6e:	8aae                	mv	s5,a1
    80000a70:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a72:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a74:	4601                	li	a2,0
    80000a76:	85ce                	mv	a1,s3
    80000a78:	855a                	mv	a0,s6
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	a08080e7          	jalr	-1528(ra) # 80000482 <walk>
    80000a82:	c531                	beqz	a0,80000ace <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a84:	6118                	ld	a4,0(a0)
    80000a86:	00177793          	andi	a5,a4,1
    80000a8a:	cbb1                	beqz	a5,80000ade <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a8c:	00a75593          	srli	a1,a4,0xa
    80000a90:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a94:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a98:	fffff097          	auipc	ra,0xfffff
    80000a9c:	680080e7          	jalr	1664(ra) # 80000118 <kalloc>
    80000aa0:	892a                	mv	s2,a0
    80000aa2:	c939                	beqz	a0,80000af8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aa4:	6605                	lui	a2,0x1
    80000aa6:	85de                	mv	a1,s7
    80000aa8:	fffff097          	auipc	ra,0xfffff
    80000aac:	752080e7          	jalr	1874(ra) # 800001fa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000ab0:	8726                	mv	a4,s1
    80000ab2:	86ca                	mv	a3,s2
    80000ab4:	6605                	lui	a2,0x1
    80000ab6:	85ce                	mv	a1,s3
    80000ab8:	8556                	mv	a0,s5
    80000aba:	00000097          	auipc	ra,0x0
    80000abe:	ab0080e7          	jalr	-1360(ra) # 8000056a <mappages>
    80000ac2:	e515                	bnez	a0,80000aee <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ac4:	6785                	lui	a5,0x1
    80000ac6:	99be                	add	s3,s3,a5
    80000ac8:	fb49e6e3          	bltu	s3,s4,80000a74 <uvmcopy+0x20>
    80000acc:	a081                	j	80000b0c <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ace:	00007517          	auipc	a0,0x7
    80000ad2:	67a50513          	addi	a0,a0,1658 # 80008148 <etext+0x148>
    80000ad6:	00005097          	auipc	ra,0x5
    80000ada:	238080e7          	jalr	568(ra) # 80005d0e <panic>
      panic("uvmcopy: page not present");
    80000ade:	00007517          	auipc	a0,0x7
    80000ae2:	68a50513          	addi	a0,a0,1674 # 80008168 <etext+0x168>
    80000ae6:	00005097          	auipc	ra,0x5
    80000aea:	228080e7          	jalr	552(ra) # 80005d0e <panic>
      kfree(mem);
    80000aee:	854a                	mv	a0,s2
    80000af0:	fffff097          	auipc	ra,0xfffff
    80000af4:	52c080e7          	jalr	1324(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af8:	4685                	li	a3,1
    80000afa:	00c9d613          	srli	a2,s3,0xc
    80000afe:	4581                	li	a1,0
    80000b00:	8556                	mv	a0,s5
    80000b02:	00000097          	auipc	ra,0x0
    80000b06:	c52080e7          	jalr	-942(ra) # 80000754 <uvmunmap>
  return -1;
    80000b0a:	557d                	li	a0,-1
}
    80000b0c:	60a6                	ld	ra,72(sp)
    80000b0e:	6406                	ld	s0,64(sp)
    80000b10:	74e2                	ld	s1,56(sp)
    80000b12:	7942                	ld	s2,48(sp)
    80000b14:	79a2                	ld	s3,40(sp)
    80000b16:	7a02                	ld	s4,32(sp)
    80000b18:	6ae2                	ld	s5,24(sp)
    80000b1a:	6b42                	ld	s6,16(sp)
    80000b1c:	6ba2                	ld	s7,8(sp)
    80000b1e:	6161                	addi	sp,sp,80
    80000b20:	8082                	ret
  return 0;
    80000b22:	4501                	li	a0,0
}
    80000b24:	8082                	ret

0000000080000b26 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b26:	1141                	addi	sp,sp,-16
    80000b28:	e406                	sd	ra,8(sp)
    80000b2a:	e022                	sd	s0,0(sp)
    80000b2c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b2e:	4601                	li	a2,0
    80000b30:	00000097          	auipc	ra,0x0
    80000b34:	952080e7          	jalr	-1710(ra) # 80000482 <walk>
  if(pte == 0)
    80000b38:	c901                	beqz	a0,80000b48 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b3a:	611c                	ld	a5,0(a0)
    80000b3c:	9bbd                	andi	a5,a5,-17
    80000b3e:	e11c                	sd	a5,0(a0)
}
    80000b40:	60a2                	ld	ra,8(sp)
    80000b42:	6402                	ld	s0,0(sp)
    80000b44:	0141                	addi	sp,sp,16
    80000b46:	8082                	ret
    panic("uvmclear");
    80000b48:	00007517          	auipc	a0,0x7
    80000b4c:	64050513          	addi	a0,a0,1600 # 80008188 <etext+0x188>
    80000b50:	00005097          	auipc	ra,0x5
    80000b54:	1be080e7          	jalr	446(ra) # 80005d0e <panic>

0000000080000b58 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b58:	cac9                	beqz	a3,80000bea <copyout+0x92>
{
    80000b5a:	711d                	addi	sp,sp,-96
    80000b5c:	ec86                	sd	ra,88(sp)
    80000b5e:	e8a2                	sd	s0,80(sp)
    80000b60:	e4a6                	sd	s1,72(sp)
    80000b62:	e0ca                	sd	s2,64(sp)
    80000b64:	fc4e                	sd	s3,56(sp)
    80000b66:	f852                	sd	s4,48(sp)
    80000b68:	f456                	sd	s5,40(sp)
    80000b6a:	f05a                	sd	s6,32(sp)
    80000b6c:	ec5e                	sd	s7,24(sp)
    80000b6e:	e862                	sd	s8,16(sp)
    80000b70:	e466                	sd	s9,8(sp)
    80000b72:	e06a                	sd	s10,0(sp)
    80000b74:	1080                	addi	s0,sp,96
    80000b76:	8baa                	mv	s7,a0
    80000b78:	8aae                	mv	s5,a1
    80000b7a:	8b32                	mv	s6,a2
    80000b7c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b7e:	74fd                	lui	s1,0xfffff
    80000b80:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000b82:	57fd                	li	a5,-1
    80000b84:	83e9                	srli	a5,a5,0x1a
    80000b86:	0697e463          	bltu	a5,s1,80000bee <copyout+0x96>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b8a:	4cd5                	li	s9,21
    80000b8c:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000b8e:	8c3e                	mv	s8,a5
    80000b90:	a035                	j	80000bbc <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b92:	83a9                	srli	a5,a5,0xa
    80000b94:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b96:	409a8533          	sub	a0,s5,s1
    80000b9a:	0009061b          	sext.w	a2,s2
    80000b9e:	85da                	mv	a1,s6
    80000ba0:	953e                	add	a0,a0,a5
    80000ba2:	fffff097          	auipc	ra,0xfffff
    80000ba6:	658080e7          	jalr	1624(ra) # 800001fa <memmove>

    len -= n;
    80000baa:	412989b3          	sub	s3,s3,s2
    src += n;
    80000bae:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000bb0:	02098b63          	beqz	s3,80000be6 <copyout+0x8e>
    if(va0 >= MAXVA)
    80000bb4:	034c6f63          	bltu	s8,s4,80000bf2 <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000bb8:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000bba:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000bbc:	4601                	li	a2,0
    80000bbe:	85a6                	mv	a1,s1
    80000bc0:	855e                	mv	a0,s7
    80000bc2:	00000097          	auipc	ra,0x0
    80000bc6:	8c0080e7          	jalr	-1856(ra) # 80000482 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bca:	c515                	beqz	a0,80000bf6 <copyout+0x9e>
    80000bcc:	611c                	ld	a5,0(a0)
    80000bce:	0157f713          	andi	a4,a5,21
    80000bd2:	05971163          	bne	a4,s9,80000c14 <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80000bd6:	01a48a33          	add	s4,s1,s10
    80000bda:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000bde:	fb29fae3          	bgeu	s3,s2,80000b92 <copyout+0x3a>
    80000be2:	894e                	mv	s2,s3
    80000be4:	b77d                	j	80000b92 <copyout+0x3a>
  }
  return 0;
    80000be6:	4501                	li	a0,0
    80000be8:	a801                	j	80000bf8 <copyout+0xa0>
    80000bea:	4501                	li	a0,0
}
    80000bec:	8082                	ret
      return -1;
    80000bee:	557d                	li	a0,-1
    80000bf0:	a021                	j	80000bf8 <copyout+0xa0>
    80000bf2:	557d                	li	a0,-1
    80000bf4:	a011                	j	80000bf8 <copyout+0xa0>
      return -1;
    80000bf6:	557d                	li	a0,-1
}
    80000bf8:	60e6                	ld	ra,88(sp)
    80000bfa:	6446                	ld	s0,80(sp)
    80000bfc:	64a6                	ld	s1,72(sp)
    80000bfe:	6906                	ld	s2,64(sp)
    80000c00:	79e2                	ld	s3,56(sp)
    80000c02:	7a42                	ld	s4,48(sp)
    80000c04:	7aa2                	ld	s5,40(sp)
    80000c06:	7b02                	ld	s6,32(sp)
    80000c08:	6be2                	ld	s7,24(sp)
    80000c0a:	6c42                	ld	s8,16(sp)
    80000c0c:	6ca2                	ld	s9,8(sp)
    80000c0e:	6d02                	ld	s10,0(sp)
    80000c10:	6125                	addi	sp,sp,96
    80000c12:	8082                	ret
      return -1;
    80000c14:	557d                	li	a0,-1
    80000c16:	b7cd                	j	80000bf8 <copyout+0xa0>

0000000080000c18 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c18:	caa5                	beqz	a3,80000c88 <copyin+0x70>
{
    80000c1a:	715d                	addi	sp,sp,-80
    80000c1c:	e486                	sd	ra,72(sp)
    80000c1e:	e0a2                	sd	s0,64(sp)
    80000c20:	fc26                	sd	s1,56(sp)
    80000c22:	f84a                	sd	s2,48(sp)
    80000c24:	f44e                	sd	s3,40(sp)
    80000c26:	f052                	sd	s4,32(sp)
    80000c28:	ec56                	sd	s5,24(sp)
    80000c2a:	e85a                	sd	s6,16(sp)
    80000c2c:	e45e                	sd	s7,8(sp)
    80000c2e:	e062                	sd	s8,0(sp)
    80000c30:	0880                	addi	s0,sp,80
    80000c32:	8b2a                	mv	s6,a0
    80000c34:	8a2e                	mv	s4,a1
    80000c36:	8c32                	mv	s8,a2
    80000c38:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c3a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c3c:	6a85                	lui	s5,0x1
    80000c3e:	a01d                	j	80000c64 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c40:	018505b3          	add	a1,a0,s8
    80000c44:	0004861b          	sext.w	a2,s1
    80000c48:	412585b3          	sub	a1,a1,s2
    80000c4c:	8552                	mv	a0,s4
    80000c4e:	fffff097          	auipc	ra,0xfffff
    80000c52:	5ac080e7          	jalr	1452(ra) # 800001fa <memmove>

    len -= n;
    80000c56:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c5a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c5c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c60:	02098263          	beqz	s3,80000c84 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c64:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c68:	85ca                	mv	a1,s2
    80000c6a:	855a                	mv	a0,s6
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	8bc080e7          	jalr	-1860(ra) # 80000528 <walkaddr>
    if(pa0 == 0)
    80000c74:	cd01                	beqz	a0,80000c8c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c76:	418904b3          	sub	s1,s2,s8
    80000c7a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c7c:	fc99f2e3          	bgeu	s3,s1,80000c40 <copyin+0x28>
    80000c80:	84ce                	mv	s1,s3
    80000c82:	bf7d                	j	80000c40 <copyin+0x28>
  }
  return 0;
    80000c84:	4501                	li	a0,0
    80000c86:	a021                	j	80000c8e <copyin+0x76>
    80000c88:	4501                	li	a0,0
}
    80000c8a:	8082                	ret
      return -1;
    80000c8c:	557d                	li	a0,-1
}
    80000c8e:	60a6                	ld	ra,72(sp)
    80000c90:	6406                	ld	s0,64(sp)
    80000c92:	74e2                	ld	s1,56(sp)
    80000c94:	7942                	ld	s2,48(sp)
    80000c96:	79a2                	ld	s3,40(sp)
    80000c98:	7a02                	ld	s4,32(sp)
    80000c9a:	6ae2                	ld	s5,24(sp)
    80000c9c:	6b42                	ld	s6,16(sp)
    80000c9e:	6ba2                	ld	s7,8(sp)
    80000ca0:	6c02                	ld	s8,0(sp)
    80000ca2:	6161                	addi	sp,sp,80
    80000ca4:	8082                	ret

0000000080000ca6 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000ca6:	c6c5                	beqz	a3,80000d4e <copyinstr+0xa8>
{
    80000ca8:	715d                	addi	sp,sp,-80
    80000caa:	e486                	sd	ra,72(sp)
    80000cac:	e0a2                	sd	s0,64(sp)
    80000cae:	fc26                	sd	s1,56(sp)
    80000cb0:	f84a                	sd	s2,48(sp)
    80000cb2:	f44e                	sd	s3,40(sp)
    80000cb4:	f052                	sd	s4,32(sp)
    80000cb6:	ec56                	sd	s5,24(sp)
    80000cb8:	e85a                	sd	s6,16(sp)
    80000cba:	e45e                	sd	s7,8(sp)
    80000cbc:	0880                	addi	s0,sp,80
    80000cbe:	8a2a                	mv	s4,a0
    80000cc0:	8b2e                	mv	s6,a1
    80000cc2:	8bb2                	mv	s7,a2
    80000cc4:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000cc6:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cc8:	6985                	lui	s3,0x1
    80000cca:	a035                	j	80000cf6 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ccc:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cd0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cd2:	0017b793          	seqz	a5,a5
    80000cd6:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cda:	60a6                	ld	ra,72(sp)
    80000cdc:	6406                	ld	s0,64(sp)
    80000cde:	74e2                	ld	s1,56(sp)
    80000ce0:	7942                	ld	s2,48(sp)
    80000ce2:	79a2                	ld	s3,40(sp)
    80000ce4:	7a02                	ld	s4,32(sp)
    80000ce6:	6ae2                	ld	s5,24(sp)
    80000ce8:	6b42                	ld	s6,16(sp)
    80000cea:	6ba2                	ld	s7,8(sp)
    80000cec:	6161                	addi	sp,sp,80
    80000cee:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cf0:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cf4:	c8a9                	beqz	s1,80000d46 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cf6:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cfa:	85ca                	mv	a1,s2
    80000cfc:	8552                	mv	a0,s4
    80000cfe:	00000097          	auipc	ra,0x0
    80000d02:	82a080e7          	jalr	-2006(ra) # 80000528 <walkaddr>
    if(pa0 == 0)
    80000d06:	c131                	beqz	a0,80000d4a <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000d08:	41790833          	sub	a6,s2,s7
    80000d0c:	984e                	add	a6,a6,s3
    if(n > max)
    80000d0e:	0104f363          	bgeu	s1,a6,80000d14 <copyinstr+0x6e>
    80000d12:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d14:	955e                	add	a0,a0,s7
    80000d16:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d1a:	fc080be3          	beqz	a6,80000cf0 <copyinstr+0x4a>
    80000d1e:	985a                	add	a6,a6,s6
    80000d20:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d22:	41650633          	sub	a2,a0,s6
    80000d26:	14fd                	addi	s1,s1,-1
    80000d28:	9b26                	add	s6,s6,s1
    80000d2a:	00f60733          	add	a4,a2,a5
    80000d2e:	00074703          	lbu	a4,0(a4)
    80000d32:	df49                	beqz	a4,80000ccc <copyinstr+0x26>
        *dst = *p;
    80000d34:	00e78023          	sb	a4,0(a5)
      --max;
    80000d38:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d3c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d3e:	ff0796e3          	bne	a5,a6,80000d2a <copyinstr+0x84>
      dst++;
    80000d42:	8b42                	mv	s6,a6
    80000d44:	b775                	j	80000cf0 <copyinstr+0x4a>
    80000d46:	4781                	li	a5,0
    80000d48:	b769                	j	80000cd2 <copyinstr+0x2c>
      return -1;
    80000d4a:	557d                	li	a0,-1
    80000d4c:	b779                	j	80000cda <copyinstr+0x34>
  int got_null = 0;
    80000d4e:	4781                	li	a5,0
  if(got_null){
    80000d50:	0017b793          	seqz	a5,a5
    80000d54:	40f00533          	neg	a0,a5
}
    80000d58:	8082                	ret

0000000080000d5a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d5a:	7139                	addi	sp,sp,-64
    80000d5c:	fc06                	sd	ra,56(sp)
    80000d5e:	f822                	sd	s0,48(sp)
    80000d60:	f426                	sd	s1,40(sp)
    80000d62:	f04a                	sd	s2,32(sp)
    80000d64:	ec4e                	sd	s3,24(sp)
    80000d66:	e852                	sd	s4,16(sp)
    80000d68:	e456                	sd	s5,8(sp)
    80000d6a:	e05a                	sd	s6,0(sp)
    80000d6c:	0080                	addi	s0,sp,64
    80000d6e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d70:	00008497          	auipc	s1,0x8
    80000d74:	16048493          	addi	s1,s1,352 # 80008ed0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d78:	8b26                	mv	s6,s1
    80000d7a:	00007a97          	auipc	s5,0x7
    80000d7e:	286a8a93          	addi	s5,s5,646 # 80008000 <etext>
    80000d82:	04000937          	lui	s2,0x4000
    80000d86:	197d                	addi	s2,s2,-1
    80000d88:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8a:	0000ea17          	auipc	s4,0xe
    80000d8e:	d46a0a13          	addi	s4,s4,-698 # 8000ead0 <tickslock>
    char *pa = kalloc();
    80000d92:	fffff097          	auipc	ra,0xfffff
    80000d96:	386080e7          	jalr	902(ra) # 80000118 <kalloc>
    80000d9a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d9c:	c131                	beqz	a0,80000de0 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d9e:	416485b3          	sub	a1,s1,s6
    80000da2:	8591                	srai	a1,a1,0x4
    80000da4:	000ab783          	ld	a5,0(s5)
    80000da8:	02f585b3          	mul	a1,a1,a5
    80000dac:	2585                	addiw	a1,a1,1
    80000dae:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000db2:	4719                	li	a4,6
    80000db4:	6685                	lui	a3,0x1
    80000db6:	40b905b3          	sub	a1,s2,a1
    80000dba:	854e                	mv	a0,s3
    80000dbc:	00000097          	auipc	ra,0x0
    80000dc0:	872080e7          	jalr	-1934(ra) # 8000062e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dc4:	17048493          	addi	s1,s1,368
    80000dc8:	fd4495e3          	bne	s1,s4,80000d92 <proc_mapstacks+0x38>
  }
}
    80000dcc:	70e2                	ld	ra,56(sp)
    80000dce:	7442                	ld	s0,48(sp)
    80000dd0:	74a2                	ld	s1,40(sp)
    80000dd2:	7902                	ld	s2,32(sp)
    80000dd4:	69e2                	ld	s3,24(sp)
    80000dd6:	6a42                	ld	s4,16(sp)
    80000dd8:	6aa2                	ld	s5,8(sp)
    80000dda:	6b02                	ld	s6,0(sp)
    80000ddc:	6121                	addi	sp,sp,64
    80000dde:	8082                	ret
      panic("kalloc");
    80000de0:	00007517          	auipc	a0,0x7
    80000de4:	3b850513          	addi	a0,a0,952 # 80008198 <etext+0x198>
    80000de8:	00005097          	auipc	ra,0x5
    80000dec:	f26080e7          	jalr	-218(ra) # 80005d0e <panic>

0000000080000df0 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000df0:	7139                	addi	sp,sp,-64
    80000df2:	fc06                	sd	ra,56(sp)
    80000df4:	f822                	sd	s0,48(sp)
    80000df6:	f426                	sd	s1,40(sp)
    80000df8:	f04a                	sd	s2,32(sp)
    80000dfa:	ec4e                	sd	s3,24(sp)
    80000dfc:	e852                	sd	s4,16(sp)
    80000dfe:	e456                	sd	s5,8(sp)
    80000e00:	e05a                	sd	s6,0(sp)
    80000e02:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e04:	00007597          	auipc	a1,0x7
    80000e08:	39c58593          	addi	a1,a1,924 # 800081a0 <etext+0x1a0>
    80000e0c:	00008517          	auipc	a0,0x8
    80000e10:	c9450513          	addi	a0,a0,-876 # 80008aa0 <pid_lock>
    80000e14:	00005097          	auipc	ra,0x5
    80000e18:	3a6080e7          	jalr	934(ra) # 800061ba <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e1c:	00007597          	auipc	a1,0x7
    80000e20:	38c58593          	addi	a1,a1,908 # 800081a8 <etext+0x1a8>
    80000e24:	00008517          	auipc	a0,0x8
    80000e28:	c9450513          	addi	a0,a0,-876 # 80008ab8 <wait_lock>
    80000e2c:	00005097          	auipc	ra,0x5
    80000e30:	38e080e7          	jalr	910(ra) # 800061ba <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e34:	00008497          	auipc	s1,0x8
    80000e38:	09c48493          	addi	s1,s1,156 # 80008ed0 <proc>
      initlock(&p->lock, "proc");
    80000e3c:	00007b17          	auipc	s6,0x7
    80000e40:	37cb0b13          	addi	s6,s6,892 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e44:	8aa6                	mv	s5,s1
    80000e46:	00007a17          	auipc	s4,0x7
    80000e4a:	1baa0a13          	addi	s4,s4,442 # 80008000 <etext>
    80000e4e:	04000937          	lui	s2,0x4000
    80000e52:	197d                	addi	s2,s2,-1
    80000e54:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e56:	0000e997          	auipc	s3,0xe
    80000e5a:	c7a98993          	addi	s3,s3,-902 # 8000ead0 <tickslock>
      initlock(&p->lock, "proc");
    80000e5e:	85da                	mv	a1,s6
    80000e60:	8526                	mv	a0,s1
    80000e62:	00005097          	auipc	ra,0x5
    80000e66:	358080e7          	jalr	856(ra) # 800061ba <initlock>
      p->state = UNUSED;
    80000e6a:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e6e:	415487b3          	sub	a5,s1,s5
    80000e72:	8791                	srai	a5,a5,0x4
    80000e74:	000a3703          	ld	a4,0(s4)
    80000e78:	02e787b3          	mul	a5,a5,a4
    80000e7c:	2785                	addiw	a5,a5,1
    80000e7e:	00d7979b          	slliw	a5,a5,0xd
    80000e82:	40f907b3          	sub	a5,s2,a5
    80000e86:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e88:	17048493          	addi	s1,s1,368
    80000e8c:	fd3499e3          	bne	s1,s3,80000e5e <procinit+0x6e>
  }
}
    80000e90:	70e2                	ld	ra,56(sp)
    80000e92:	7442                	ld	s0,48(sp)
    80000e94:	74a2                	ld	s1,40(sp)
    80000e96:	7902                	ld	s2,32(sp)
    80000e98:	69e2                	ld	s3,24(sp)
    80000e9a:	6a42                	ld	s4,16(sp)
    80000e9c:	6aa2                	ld	s5,8(sp)
    80000e9e:	6b02                	ld	s6,0(sp)
    80000ea0:	6121                	addi	sp,sp,64
    80000ea2:	8082                	ret

0000000080000ea4 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000ea4:	1141                	addi	sp,sp,-16
    80000ea6:	e422                	sd	s0,8(sp)
    80000ea8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000eaa:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000eac:	2501                	sext.w	a0,a0
    80000eae:	6422                	ld	s0,8(sp)
    80000eb0:	0141                	addi	sp,sp,16
    80000eb2:	8082                	ret

0000000080000eb4 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000eb4:	1141                	addi	sp,sp,-16
    80000eb6:	e422                	sd	s0,8(sp)
    80000eb8:	0800                	addi	s0,sp,16
    80000eba:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000ebc:	2781                	sext.w	a5,a5
    80000ebe:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ec0:	00008517          	auipc	a0,0x8
    80000ec4:	c1050513          	addi	a0,a0,-1008 # 80008ad0 <cpus>
    80000ec8:	953e                	add	a0,a0,a5
    80000eca:	6422                	ld	s0,8(sp)
    80000ecc:	0141                	addi	sp,sp,16
    80000ece:	8082                	ret

0000000080000ed0 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000ed0:	1101                	addi	sp,sp,-32
    80000ed2:	ec06                	sd	ra,24(sp)
    80000ed4:	e822                	sd	s0,16(sp)
    80000ed6:	e426                	sd	s1,8(sp)
    80000ed8:	1000                	addi	s0,sp,32
  push_off();
    80000eda:	00005097          	auipc	ra,0x5
    80000ede:	324080e7          	jalr	804(ra) # 800061fe <push_off>
    80000ee2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ee4:	2781                	sext.w	a5,a5
    80000ee6:	079e                	slli	a5,a5,0x7
    80000ee8:	00008717          	auipc	a4,0x8
    80000eec:	bb870713          	addi	a4,a4,-1096 # 80008aa0 <pid_lock>
    80000ef0:	97ba                	add	a5,a5,a4
    80000ef2:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ef4:	00005097          	auipc	ra,0x5
    80000ef8:	3aa080e7          	jalr	938(ra) # 8000629e <pop_off>
  return p;
}
    80000efc:	8526                	mv	a0,s1
    80000efe:	60e2                	ld	ra,24(sp)
    80000f00:	6442                	ld	s0,16(sp)
    80000f02:	64a2                	ld	s1,8(sp)
    80000f04:	6105                	addi	sp,sp,32
    80000f06:	8082                	ret

0000000080000f08 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f08:	1141                	addi	sp,sp,-16
    80000f0a:	e406                	sd	ra,8(sp)
    80000f0c:	e022                	sd	s0,0(sp)
    80000f0e:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	fc0080e7          	jalr	-64(ra) # 80000ed0 <myproc>
    80000f18:	00005097          	auipc	ra,0x5
    80000f1c:	3e6080e7          	jalr	998(ra) # 800062fe <release>

  if (first) {
    80000f20:	00008797          	auipc	a5,0x8
    80000f24:	a307a783          	lw	a5,-1488(a5) # 80008950 <first.1>
    80000f28:	eb89                	bnez	a5,80000f3a <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f2a:	00001097          	auipc	ra,0x1
    80000f2e:	c96080e7          	jalr	-874(ra) # 80001bc0 <usertrapret>
}
    80000f32:	60a2                	ld	ra,8(sp)
    80000f34:	6402                	ld	s0,0(sp)
    80000f36:	0141                	addi	sp,sp,16
    80000f38:	8082                	ret
    fsinit(ROOTDEV);
    80000f3a:	4505                	li	a0,1
    80000f3c:	00002097          	auipc	ra,0x2
    80000f40:	aae080e7          	jalr	-1362(ra) # 800029ea <fsinit>
    first = 0;
    80000f44:	00008797          	auipc	a5,0x8
    80000f48:	a007a623          	sw	zero,-1524(a5) # 80008950 <first.1>
    __sync_synchronize();
    80000f4c:	0ff0000f          	fence
    80000f50:	bfe9                	j	80000f2a <forkret+0x22>

0000000080000f52 <allocpid>:
{
    80000f52:	1101                	addi	sp,sp,-32
    80000f54:	ec06                	sd	ra,24(sp)
    80000f56:	e822                	sd	s0,16(sp)
    80000f58:	e426                	sd	s1,8(sp)
    80000f5a:	e04a                	sd	s2,0(sp)
    80000f5c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f5e:	00008917          	auipc	s2,0x8
    80000f62:	b4290913          	addi	s2,s2,-1214 # 80008aa0 <pid_lock>
    80000f66:	854a                	mv	a0,s2
    80000f68:	00005097          	auipc	ra,0x5
    80000f6c:	2e2080e7          	jalr	738(ra) # 8000624a <acquire>
  pid = nextpid;
    80000f70:	00008797          	auipc	a5,0x8
    80000f74:	9e478793          	addi	a5,a5,-1564 # 80008954 <nextpid>
    80000f78:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f7a:	0014871b          	addiw	a4,s1,1
    80000f7e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f80:	854a                	mv	a0,s2
    80000f82:	00005097          	auipc	ra,0x5
    80000f86:	37c080e7          	jalr	892(ra) # 800062fe <release>
}
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	60e2                	ld	ra,24(sp)
    80000f8e:	6442                	ld	s0,16(sp)
    80000f90:	64a2                	ld	s1,8(sp)
    80000f92:	6902                	ld	s2,0(sp)
    80000f94:	6105                	addi	sp,sp,32
    80000f96:	8082                	ret

0000000080000f98 <proc_pagetable>:
{
    80000f98:	1101                	addi	sp,sp,-32
    80000f9a:	ec06                	sd	ra,24(sp)
    80000f9c:	e822                	sd	s0,16(sp)
    80000f9e:	e426                	sd	s1,8(sp)
    80000fa0:	e04a                	sd	s2,0(sp)
    80000fa2:	1000                	addi	s0,sp,32
    80000fa4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	872080e7          	jalr	-1934(ra) # 80000818 <uvmcreate>
    80000fae:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000fb0:	c121                	beqz	a0,80000ff0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fb2:	4729                	li	a4,10
    80000fb4:	00006697          	auipc	a3,0x6
    80000fb8:	04c68693          	addi	a3,a3,76 # 80007000 <_trampoline>
    80000fbc:	6605                	lui	a2,0x1
    80000fbe:	040005b7          	lui	a1,0x4000
    80000fc2:	15fd                	addi	a1,a1,-1
    80000fc4:	05b2                	slli	a1,a1,0xc
    80000fc6:	fffff097          	auipc	ra,0xfffff
    80000fca:	5a4080e7          	jalr	1444(ra) # 8000056a <mappages>
    80000fce:	02054863          	bltz	a0,80000ffe <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fd2:	4719                	li	a4,6
    80000fd4:	05893683          	ld	a3,88(s2)
    80000fd8:	6605                	lui	a2,0x1
    80000fda:	020005b7          	lui	a1,0x2000
    80000fde:	15fd                	addi	a1,a1,-1
    80000fe0:	05b6                	slli	a1,a1,0xd
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	586080e7          	jalr	1414(ra) # 8000056a <mappages>
    80000fec:	02054163          	bltz	a0,8000100e <proc_pagetable+0x76>
}
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	60e2                	ld	ra,24(sp)
    80000ff4:	6442                	ld	s0,16(sp)
    80000ff6:	64a2                	ld	s1,8(sp)
    80000ff8:	6902                	ld	s2,0(sp)
    80000ffa:	6105                	addi	sp,sp,32
    80000ffc:	8082                	ret
    uvmfree(pagetable, 0);
    80000ffe:	4581                	li	a1,0
    80001000:	8526                	mv	a0,s1
    80001002:	00000097          	auipc	ra,0x0
    80001006:	a1a080e7          	jalr	-1510(ra) # 80000a1c <uvmfree>
    return 0;
    8000100a:	4481                	li	s1,0
    8000100c:	b7d5                	j	80000ff0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000100e:	4681                	li	a3,0
    80001010:	4605                	li	a2,1
    80001012:	040005b7          	lui	a1,0x4000
    80001016:	15fd                	addi	a1,a1,-1
    80001018:	05b2                	slli	a1,a1,0xc
    8000101a:	8526                	mv	a0,s1
    8000101c:	fffff097          	auipc	ra,0xfffff
    80001020:	738080e7          	jalr	1848(ra) # 80000754 <uvmunmap>
    uvmfree(pagetable, 0);
    80001024:	4581                	li	a1,0
    80001026:	8526                	mv	a0,s1
    80001028:	00000097          	auipc	ra,0x0
    8000102c:	9f4080e7          	jalr	-1548(ra) # 80000a1c <uvmfree>
    return 0;
    80001030:	4481                	li	s1,0
    80001032:	bf7d                	j	80000ff0 <proc_pagetable+0x58>

0000000080001034 <proc_freepagetable>:
{
    80001034:	1101                	addi	sp,sp,-32
    80001036:	ec06                	sd	ra,24(sp)
    80001038:	e822                	sd	s0,16(sp)
    8000103a:	e426                	sd	s1,8(sp)
    8000103c:	e04a                	sd	s2,0(sp)
    8000103e:	1000                	addi	s0,sp,32
    80001040:	84aa                	mv	s1,a0
    80001042:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001044:	4681                	li	a3,0
    80001046:	4605                	li	a2,1
    80001048:	040005b7          	lui	a1,0x4000
    8000104c:	15fd                	addi	a1,a1,-1
    8000104e:	05b2                	slli	a1,a1,0xc
    80001050:	fffff097          	auipc	ra,0xfffff
    80001054:	704080e7          	jalr	1796(ra) # 80000754 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001058:	4681                	li	a3,0
    8000105a:	4605                	li	a2,1
    8000105c:	020005b7          	lui	a1,0x2000
    80001060:	15fd                	addi	a1,a1,-1
    80001062:	05b6                	slli	a1,a1,0xd
    80001064:	8526                	mv	a0,s1
    80001066:	fffff097          	auipc	ra,0xfffff
    8000106a:	6ee080e7          	jalr	1774(ra) # 80000754 <uvmunmap>
  uvmfree(pagetable, sz);
    8000106e:	85ca                	mv	a1,s2
    80001070:	8526                	mv	a0,s1
    80001072:	00000097          	auipc	ra,0x0
    80001076:	9aa080e7          	jalr	-1622(ra) # 80000a1c <uvmfree>
}
    8000107a:	60e2                	ld	ra,24(sp)
    8000107c:	6442                	ld	s0,16(sp)
    8000107e:	64a2                	ld	s1,8(sp)
    80001080:	6902                	ld	s2,0(sp)
    80001082:	6105                	addi	sp,sp,32
    80001084:	8082                	ret

0000000080001086 <freeproc>:
{
    80001086:	1101                	addi	sp,sp,-32
    80001088:	ec06                	sd	ra,24(sp)
    8000108a:	e822                	sd	s0,16(sp)
    8000108c:	e426                	sd	s1,8(sp)
    8000108e:	1000                	addi	s0,sp,32
    80001090:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001092:	6d28                	ld	a0,88(a0)
    80001094:	c509                	beqz	a0,8000109e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001096:	fffff097          	auipc	ra,0xfffff
    8000109a:	f86080e7          	jalr	-122(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000109e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800010a2:	68a8                	ld	a0,80(s1)
    800010a4:	c511                	beqz	a0,800010b0 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800010a6:	64ac                	ld	a1,72(s1)
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	f8c080e7          	jalr	-116(ra) # 80001034 <proc_freepagetable>
  p->pagetable = 0;
    800010b0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010b4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010b8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010bc:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010c0:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010c4:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010c8:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010cc:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010d0:	0004ac23          	sw	zero,24(s1)
}
    800010d4:	60e2                	ld	ra,24(sp)
    800010d6:	6442                	ld	s0,16(sp)
    800010d8:	64a2                	ld	s1,8(sp)
    800010da:	6105                	addi	sp,sp,32
    800010dc:	8082                	ret

00000000800010de <allocproc>:
{
    800010de:	1101                	addi	sp,sp,-32
    800010e0:	ec06                	sd	ra,24(sp)
    800010e2:	e822                	sd	s0,16(sp)
    800010e4:	e426                	sd	s1,8(sp)
    800010e6:	e04a                	sd	s2,0(sp)
    800010e8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ea:	00008497          	auipc	s1,0x8
    800010ee:	de648493          	addi	s1,s1,-538 # 80008ed0 <proc>
    800010f2:	0000e917          	auipc	s2,0xe
    800010f6:	9de90913          	addi	s2,s2,-1570 # 8000ead0 <tickslock>
    acquire(&p->lock);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00005097          	auipc	ra,0x5
    80001100:	14e080e7          	jalr	334(ra) # 8000624a <acquire>
    if(p->state == UNUSED) {
    80001104:	4c9c                	lw	a5,24(s1)
    80001106:	cf81                	beqz	a5,8000111e <allocproc+0x40>
      release(&p->lock);
    80001108:	8526                	mv	a0,s1
    8000110a:	00005097          	auipc	ra,0x5
    8000110e:	1f4080e7          	jalr	500(ra) # 800062fe <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001112:	17048493          	addi	s1,s1,368
    80001116:	ff2492e3          	bne	s1,s2,800010fa <allocproc+0x1c>
  return 0;
    8000111a:	4481                	li	s1,0
    8000111c:	a889                	j	8000116e <allocproc+0x90>
  p->pid = allocpid();
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	e34080e7          	jalr	-460(ra) # 80000f52 <allocpid>
    80001126:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001128:	4785                	li	a5,1
    8000112a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000112c:	fffff097          	auipc	ra,0xfffff
    80001130:	fec080e7          	jalr	-20(ra) # 80000118 <kalloc>
    80001134:	892a                	mv	s2,a0
    80001136:	eca8                	sd	a0,88(s1)
    80001138:	c131                	beqz	a0,8000117c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000113a:	8526                	mv	a0,s1
    8000113c:	00000097          	auipc	ra,0x0
    80001140:	e5c080e7          	jalr	-420(ra) # 80000f98 <proc_pagetable>
    80001144:	892a                	mv	s2,a0
    80001146:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001148:	c531                	beqz	a0,80001194 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000114a:	07000613          	li	a2,112
    8000114e:	4581                	li	a1,0
    80001150:	06048513          	addi	a0,s1,96
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	04a080e7          	jalr	74(ra) # 8000019e <memset>
  p->context.ra = (uint64)forkret;
    8000115c:	00000797          	auipc	a5,0x0
    80001160:	dac78793          	addi	a5,a5,-596 # 80000f08 <forkret>
    80001164:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001166:	60bc                	ld	a5,64(s1)
    80001168:	6705                	lui	a4,0x1
    8000116a:	97ba                	add	a5,a5,a4
    8000116c:	f4bc                	sd	a5,104(s1)
}
    8000116e:	8526                	mv	a0,s1
    80001170:	60e2                	ld	ra,24(sp)
    80001172:	6442                	ld	s0,16(sp)
    80001174:	64a2                	ld	s1,8(sp)
    80001176:	6902                	ld	s2,0(sp)
    80001178:	6105                	addi	sp,sp,32
    8000117a:	8082                	ret
    freeproc(p);
    8000117c:	8526                	mv	a0,s1
    8000117e:	00000097          	auipc	ra,0x0
    80001182:	f08080e7          	jalr	-248(ra) # 80001086 <freeproc>
    release(&p->lock);
    80001186:	8526                	mv	a0,s1
    80001188:	00005097          	auipc	ra,0x5
    8000118c:	176080e7          	jalr	374(ra) # 800062fe <release>
    return 0;
    80001190:	84ca                	mv	s1,s2
    80001192:	bff1                	j	8000116e <allocproc+0x90>
    freeproc(p);
    80001194:	8526                	mv	a0,s1
    80001196:	00000097          	auipc	ra,0x0
    8000119a:	ef0080e7          	jalr	-272(ra) # 80001086 <freeproc>
    release(&p->lock);
    8000119e:	8526                	mv	a0,s1
    800011a0:	00005097          	auipc	ra,0x5
    800011a4:	15e080e7          	jalr	350(ra) # 800062fe <release>
    return 0;
    800011a8:	84ca                	mv	s1,s2
    800011aa:	b7d1                	j	8000116e <allocproc+0x90>

00000000800011ac <userinit>:
{
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	e426                	sd	s1,8(sp)
    800011b4:	1000                	addi	s0,sp,32
  p = allocproc();
    800011b6:	00000097          	auipc	ra,0x0
    800011ba:	f28080e7          	jalr	-216(ra) # 800010de <allocproc>
    800011be:	84aa                	mv	s1,a0
  initproc = p;
    800011c0:	00008797          	auipc	a5,0x8
    800011c4:	8aa7b023          	sd	a0,-1888(a5) # 80008a60 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011c8:	03400613          	li	a2,52
    800011cc:	00007597          	auipc	a1,0x7
    800011d0:	79458593          	addi	a1,a1,1940 # 80008960 <initcode>
    800011d4:	6928                	ld	a0,80(a0)
    800011d6:	fffff097          	auipc	ra,0xfffff
    800011da:	670080e7          	jalr	1648(ra) # 80000846 <uvmfirst>
  p->sz = PGSIZE;
    800011de:	6785                	lui	a5,0x1
    800011e0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011e2:	6cb8                	ld	a4,88(s1)
    800011e4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011e8:	6cb8                	ld	a4,88(s1)
    800011ea:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011ec:	4641                	li	a2,16
    800011ee:	00007597          	auipc	a1,0x7
    800011f2:	fd258593          	addi	a1,a1,-46 # 800081c0 <etext+0x1c0>
    800011f6:	15848513          	addi	a0,s1,344
    800011fa:	fffff097          	auipc	ra,0xfffff
    800011fe:	0ee080e7          	jalr	238(ra) # 800002e8 <safestrcpy>
  p->cwd = namei("/");
    80001202:	00007517          	auipc	a0,0x7
    80001206:	fce50513          	addi	a0,a0,-50 # 800081d0 <etext+0x1d0>
    8000120a:	00002097          	auipc	ra,0x2
    8000120e:	202080e7          	jalr	514(ra) # 8000340c <namei>
    80001212:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001216:	478d                	li	a5,3
    80001218:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000121a:	8526                	mv	a0,s1
    8000121c:	00005097          	auipc	ra,0x5
    80001220:	0e2080e7          	jalr	226(ra) # 800062fe <release>
}
    80001224:	60e2                	ld	ra,24(sp)
    80001226:	6442                	ld	s0,16(sp)
    80001228:	64a2                	ld	s1,8(sp)
    8000122a:	6105                	addi	sp,sp,32
    8000122c:	8082                	ret

000000008000122e <growproc>:
{
    8000122e:	1101                	addi	sp,sp,-32
    80001230:	ec06                	sd	ra,24(sp)
    80001232:	e822                	sd	s0,16(sp)
    80001234:	e426                	sd	s1,8(sp)
    80001236:	e04a                	sd	s2,0(sp)
    80001238:	1000                	addi	s0,sp,32
    8000123a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000123c:	00000097          	auipc	ra,0x0
    80001240:	c94080e7          	jalr	-876(ra) # 80000ed0 <myproc>
    80001244:	84aa                	mv	s1,a0
  sz = p->sz;
    80001246:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001248:	01204c63          	bgtz	s2,80001260 <growproc+0x32>
  } else if(n < 0){
    8000124c:	02094663          	bltz	s2,80001278 <growproc+0x4a>
  p->sz = sz;
    80001250:	e4ac                	sd	a1,72(s1)
  return 0;
    80001252:	4501                	li	a0,0
}
    80001254:	60e2                	ld	ra,24(sp)
    80001256:	6442                	ld	s0,16(sp)
    80001258:	64a2                	ld	s1,8(sp)
    8000125a:	6902                	ld	s2,0(sp)
    8000125c:	6105                	addi	sp,sp,32
    8000125e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001260:	4691                	li	a3,4
    80001262:	00b90633          	add	a2,s2,a1
    80001266:	6928                	ld	a0,80(a0)
    80001268:	fffff097          	auipc	ra,0xfffff
    8000126c:	698080e7          	jalr	1688(ra) # 80000900 <uvmalloc>
    80001270:	85aa                	mv	a1,a0
    80001272:	fd79                	bnez	a0,80001250 <growproc+0x22>
      return -1;
    80001274:	557d                	li	a0,-1
    80001276:	bff9                	j	80001254 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001278:	00b90633          	add	a2,s2,a1
    8000127c:	6928                	ld	a0,80(a0)
    8000127e:	fffff097          	auipc	ra,0xfffff
    80001282:	63a080e7          	jalr	1594(ra) # 800008b8 <uvmdealloc>
    80001286:	85aa                	mv	a1,a0
    80001288:	b7e1                	j	80001250 <growproc+0x22>

000000008000128a <fork>:
{
    8000128a:	7139                	addi	sp,sp,-64
    8000128c:	fc06                	sd	ra,56(sp)
    8000128e:	f822                	sd	s0,48(sp)
    80001290:	f426                	sd	s1,40(sp)
    80001292:	f04a                	sd	s2,32(sp)
    80001294:	ec4e                	sd	s3,24(sp)
    80001296:	e852                	sd	s4,16(sp)
    80001298:	e456                	sd	s5,8(sp)
    8000129a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	c34080e7          	jalr	-972(ra) # 80000ed0 <myproc>
    800012a4:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	e38080e7          	jalr	-456(ra) # 800010de <allocproc>
    800012ae:	12050063          	beqz	a0,800013ce <fork+0x144>
    800012b2:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012b4:	048ab603          	ld	a2,72(s5)
    800012b8:	692c                	ld	a1,80(a0)
    800012ba:	050ab503          	ld	a0,80(s5)
    800012be:	fffff097          	auipc	ra,0xfffff
    800012c2:	796080e7          	jalr	1942(ra) # 80000a54 <uvmcopy>
    800012c6:	04054c63          	bltz	a0,8000131e <fork+0x94>
  np->sz = p->sz;
    800012ca:	048ab783          	ld	a5,72(s5)
    800012ce:	04f9b423          	sd	a5,72(s3)
  np->mask = p->mask;
    800012d2:	168aa783          	lw	a5,360(s5)
    800012d6:	16f9a423          	sw	a5,360(s3)
  *(np->trapframe) = *(p->trapframe);
    800012da:	058ab683          	ld	a3,88(s5)
    800012de:	87b6                	mv	a5,a3
    800012e0:	0589b703          	ld	a4,88(s3)
    800012e4:	12068693          	addi	a3,a3,288
    800012e8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ec:	6788                	ld	a0,8(a5)
    800012ee:	6b8c                	ld	a1,16(a5)
    800012f0:	6f90                	ld	a2,24(a5)
    800012f2:	01073023          	sd	a6,0(a4)
    800012f6:	e708                	sd	a0,8(a4)
    800012f8:	eb0c                	sd	a1,16(a4)
    800012fa:	ef10                	sd	a2,24(a4)
    800012fc:	02078793          	addi	a5,a5,32
    80001300:	02070713          	addi	a4,a4,32
    80001304:	fed792e3          	bne	a5,a3,800012e8 <fork+0x5e>
  np->trapframe->a0 = 0;
    80001308:	0589b783          	ld	a5,88(s3)
    8000130c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001310:	0d0a8493          	addi	s1,s5,208
    80001314:	0d098913          	addi	s2,s3,208
    80001318:	150a8a13          	addi	s4,s5,336
    8000131c:	a00d                	j	8000133e <fork+0xb4>
    freeproc(np);
    8000131e:	854e                	mv	a0,s3
    80001320:	00000097          	auipc	ra,0x0
    80001324:	d66080e7          	jalr	-666(ra) # 80001086 <freeproc>
    release(&np->lock);
    80001328:	854e                	mv	a0,s3
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	fd4080e7          	jalr	-44(ra) # 800062fe <release>
    return -1;
    80001332:	597d                	li	s2,-1
    80001334:	a059                	j	800013ba <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001336:	04a1                	addi	s1,s1,8
    80001338:	0921                	addi	s2,s2,8
    8000133a:	01448b63          	beq	s1,s4,80001350 <fork+0xc6>
    if(p->ofile[i])
    8000133e:	6088                	ld	a0,0(s1)
    80001340:	d97d                	beqz	a0,80001336 <fork+0xac>
      np->ofile[i] = filedup(p->ofile[i]);
    80001342:	00002097          	auipc	ra,0x2
    80001346:	760080e7          	jalr	1888(ra) # 80003aa2 <filedup>
    8000134a:	00a93023          	sd	a0,0(s2)
    8000134e:	b7e5                	j	80001336 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001350:	150ab503          	ld	a0,336(s5)
    80001354:	00002097          	auipc	ra,0x2
    80001358:	8d4080e7          	jalr	-1836(ra) # 80002c28 <idup>
    8000135c:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001360:	4641                	li	a2,16
    80001362:	158a8593          	addi	a1,s5,344
    80001366:	15898513          	addi	a0,s3,344
    8000136a:	fffff097          	auipc	ra,0xfffff
    8000136e:	f7e080e7          	jalr	-130(ra) # 800002e8 <safestrcpy>
  pid = np->pid;
    80001372:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001376:	854e                	mv	a0,s3
    80001378:	00005097          	auipc	ra,0x5
    8000137c:	f86080e7          	jalr	-122(ra) # 800062fe <release>
  acquire(&wait_lock);
    80001380:	00007497          	auipc	s1,0x7
    80001384:	73848493          	addi	s1,s1,1848 # 80008ab8 <wait_lock>
    80001388:	8526                	mv	a0,s1
    8000138a:	00005097          	auipc	ra,0x5
    8000138e:	ec0080e7          	jalr	-320(ra) # 8000624a <acquire>
  np->parent = p;
    80001392:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001396:	8526                	mv	a0,s1
    80001398:	00005097          	auipc	ra,0x5
    8000139c:	f66080e7          	jalr	-154(ra) # 800062fe <release>
  acquire(&np->lock);
    800013a0:	854e                	mv	a0,s3
    800013a2:	00005097          	auipc	ra,0x5
    800013a6:	ea8080e7          	jalr	-344(ra) # 8000624a <acquire>
  np->state = RUNNABLE;
    800013aa:	478d                	li	a5,3
    800013ac:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800013b0:	854e                	mv	a0,s3
    800013b2:	00005097          	auipc	ra,0x5
    800013b6:	f4c080e7          	jalr	-180(ra) # 800062fe <release>
}
    800013ba:	854a                	mv	a0,s2
    800013bc:	70e2                	ld	ra,56(sp)
    800013be:	7442                	ld	s0,48(sp)
    800013c0:	74a2                	ld	s1,40(sp)
    800013c2:	7902                	ld	s2,32(sp)
    800013c4:	69e2                	ld	s3,24(sp)
    800013c6:	6a42                	ld	s4,16(sp)
    800013c8:	6aa2                	ld	s5,8(sp)
    800013ca:	6121                	addi	sp,sp,64
    800013cc:	8082                	ret
    return -1;
    800013ce:	597d                	li	s2,-1
    800013d0:	b7ed                	j	800013ba <fork+0x130>

00000000800013d2 <scheduler>:
{
    800013d2:	7139                	addi	sp,sp,-64
    800013d4:	fc06                	sd	ra,56(sp)
    800013d6:	f822                	sd	s0,48(sp)
    800013d8:	f426                	sd	s1,40(sp)
    800013da:	f04a                	sd	s2,32(sp)
    800013dc:	ec4e                	sd	s3,24(sp)
    800013de:	e852                	sd	s4,16(sp)
    800013e0:	e456                	sd	s5,8(sp)
    800013e2:	e05a                	sd	s6,0(sp)
    800013e4:	0080                	addi	s0,sp,64
    800013e6:	8792                	mv	a5,tp
  int id = r_tp();
    800013e8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ea:	00779a93          	slli	s5,a5,0x7
    800013ee:	00007717          	auipc	a4,0x7
    800013f2:	6b270713          	addi	a4,a4,1714 # 80008aa0 <pid_lock>
    800013f6:	9756                	add	a4,a4,s5
    800013f8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013fc:	00007717          	auipc	a4,0x7
    80001400:	6dc70713          	addi	a4,a4,1756 # 80008ad8 <cpus+0x8>
    80001404:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001406:	498d                	li	s3,3
        p->state = RUNNING;
    80001408:	4b11                	li	s6,4
        c->proc = p;
    8000140a:	079e                	slli	a5,a5,0x7
    8000140c:	00007a17          	auipc	s4,0x7
    80001410:	694a0a13          	addi	s4,s4,1684 # 80008aa0 <pid_lock>
    80001414:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001416:	0000d917          	auipc	s2,0xd
    8000141a:	6ba90913          	addi	s2,s2,1722 # 8000ead0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000141e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001422:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001426:	10079073          	csrw	sstatus,a5
    8000142a:	00008497          	auipc	s1,0x8
    8000142e:	aa648493          	addi	s1,s1,-1370 # 80008ed0 <proc>
    80001432:	a811                	j	80001446 <scheduler+0x74>
      release(&p->lock);
    80001434:	8526                	mv	a0,s1
    80001436:	00005097          	auipc	ra,0x5
    8000143a:	ec8080e7          	jalr	-312(ra) # 800062fe <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000143e:	17048493          	addi	s1,s1,368
    80001442:	fd248ee3          	beq	s1,s2,8000141e <scheduler+0x4c>
      acquire(&p->lock);
    80001446:	8526                	mv	a0,s1
    80001448:	00005097          	auipc	ra,0x5
    8000144c:	e02080e7          	jalr	-510(ra) # 8000624a <acquire>
      if(p->state == RUNNABLE) {
    80001450:	4c9c                	lw	a5,24(s1)
    80001452:	ff3791e3          	bne	a5,s3,80001434 <scheduler+0x62>
        p->state = RUNNING;
    80001456:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000145a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000145e:	06048593          	addi	a1,s1,96
    80001462:	8556                	mv	a0,s5
    80001464:	00000097          	auipc	ra,0x0
    80001468:	6b2080e7          	jalr	1714(ra) # 80001b16 <swtch>
        c->proc = 0;
    8000146c:	020a3823          	sd	zero,48(s4)
    80001470:	b7d1                	j	80001434 <scheduler+0x62>

0000000080001472 <sched>:
{
    80001472:	7179                	addi	sp,sp,-48
    80001474:	f406                	sd	ra,40(sp)
    80001476:	f022                	sd	s0,32(sp)
    80001478:	ec26                	sd	s1,24(sp)
    8000147a:	e84a                	sd	s2,16(sp)
    8000147c:	e44e                	sd	s3,8(sp)
    8000147e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001480:	00000097          	auipc	ra,0x0
    80001484:	a50080e7          	jalr	-1456(ra) # 80000ed0 <myproc>
    80001488:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000148a:	00005097          	auipc	ra,0x5
    8000148e:	d46080e7          	jalr	-698(ra) # 800061d0 <holding>
    80001492:	c93d                	beqz	a0,80001508 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001494:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001496:	2781                	sext.w	a5,a5
    80001498:	079e                	slli	a5,a5,0x7
    8000149a:	00007717          	auipc	a4,0x7
    8000149e:	60670713          	addi	a4,a4,1542 # 80008aa0 <pid_lock>
    800014a2:	97ba                	add	a5,a5,a4
    800014a4:	0a87a703          	lw	a4,168(a5)
    800014a8:	4785                	li	a5,1
    800014aa:	06f71763          	bne	a4,a5,80001518 <sched+0xa6>
  if(p->state == RUNNING)
    800014ae:	4c98                	lw	a4,24(s1)
    800014b0:	4791                	li	a5,4
    800014b2:	06f70b63          	beq	a4,a5,80001528 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014b6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014ba:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014bc:	efb5                	bnez	a5,80001538 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014be:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014c0:	00007917          	auipc	s2,0x7
    800014c4:	5e090913          	addi	s2,s2,1504 # 80008aa0 <pid_lock>
    800014c8:	2781                	sext.w	a5,a5
    800014ca:	079e                	slli	a5,a5,0x7
    800014cc:	97ca                	add	a5,a5,s2
    800014ce:	0ac7a983          	lw	s3,172(a5)
    800014d2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014d4:	2781                	sext.w	a5,a5
    800014d6:	079e                	slli	a5,a5,0x7
    800014d8:	00007597          	auipc	a1,0x7
    800014dc:	60058593          	addi	a1,a1,1536 # 80008ad8 <cpus+0x8>
    800014e0:	95be                	add	a1,a1,a5
    800014e2:	06048513          	addi	a0,s1,96
    800014e6:	00000097          	auipc	ra,0x0
    800014ea:	630080e7          	jalr	1584(ra) # 80001b16 <swtch>
    800014ee:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014f0:	2781                	sext.w	a5,a5
    800014f2:	079e                	slli	a5,a5,0x7
    800014f4:	97ca                	add	a5,a5,s2
    800014f6:	0b37a623          	sw	s3,172(a5)
}
    800014fa:	70a2                	ld	ra,40(sp)
    800014fc:	7402                	ld	s0,32(sp)
    800014fe:	64e2                	ld	s1,24(sp)
    80001500:	6942                	ld	s2,16(sp)
    80001502:	69a2                	ld	s3,8(sp)
    80001504:	6145                	addi	sp,sp,48
    80001506:	8082                	ret
    panic("sched p->lock");
    80001508:	00007517          	auipc	a0,0x7
    8000150c:	cd050513          	addi	a0,a0,-816 # 800081d8 <etext+0x1d8>
    80001510:	00004097          	auipc	ra,0x4
    80001514:	7fe080e7          	jalr	2046(ra) # 80005d0e <panic>
    panic("sched locks");
    80001518:	00007517          	auipc	a0,0x7
    8000151c:	cd050513          	addi	a0,a0,-816 # 800081e8 <etext+0x1e8>
    80001520:	00004097          	auipc	ra,0x4
    80001524:	7ee080e7          	jalr	2030(ra) # 80005d0e <panic>
    panic("sched running");
    80001528:	00007517          	auipc	a0,0x7
    8000152c:	cd050513          	addi	a0,a0,-816 # 800081f8 <etext+0x1f8>
    80001530:	00004097          	auipc	ra,0x4
    80001534:	7de080e7          	jalr	2014(ra) # 80005d0e <panic>
    panic("sched interruptible");
    80001538:	00007517          	auipc	a0,0x7
    8000153c:	cd050513          	addi	a0,a0,-816 # 80008208 <etext+0x208>
    80001540:	00004097          	auipc	ra,0x4
    80001544:	7ce080e7          	jalr	1998(ra) # 80005d0e <panic>

0000000080001548 <yield>:
{
    80001548:	1101                	addi	sp,sp,-32
    8000154a:	ec06                	sd	ra,24(sp)
    8000154c:	e822                	sd	s0,16(sp)
    8000154e:	e426                	sd	s1,8(sp)
    80001550:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001552:	00000097          	auipc	ra,0x0
    80001556:	97e080e7          	jalr	-1666(ra) # 80000ed0 <myproc>
    8000155a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	cee080e7          	jalr	-786(ra) # 8000624a <acquire>
  p->state = RUNNABLE;
    80001564:	478d                	li	a5,3
    80001566:	cc9c                	sw	a5,24(s1)
  sched();
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	f0a080e7          	jalr	-246(ra) # 80001472 <sched>
  release(&p->lock);
    80001570:	8526                	mv	a0,s1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	d8c080e7          	jalr	-628(ra) # 800062fe <release>
}
    8000157a:	60e2                	ld	ra,24(sp)
    8000157c:	6442                	ld	s0,16(sp)
    8000157e:	64a2                	ld	s1,8(sp)
    80001580:	6105                	addi	sp,sp,32
    80001582:	8082                	ret

0000000080001584 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001584:	7179                	addi	sp,sp,-48
    80001586:	f406                	sd	ra,40(sp)
    80001588:	f022                	sd	s0,32(sp)
    8000158a:	ec26                	sd	s1,24(sp)
    8000158c:	e84a                	sd	s2,16(sp)
    8000158e:	e44e                	sd	s3,8(sp)
    80001590:	1800                	addi	s0,sp,48
    80001592:	89aa                	mv	s3,a0
    80001594:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	93a080e7          	jalr	-1734(ra) # 80000ed0 <myproc>
    8000159e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015a0:	00005097          	auipc	ra,0x5
    800015a4:	caa080e7          	jalr	-854(ra) # 8000624a <acquire>
  release(lk);
    800015a8:	854a                	mv	a0,s2
    800015aa:	00005097          	auipc	ra,0x5
    800015ae:	d54080e7          	jalr	-684(ra) # 800062fe <release>

  // Go to sleep.
  p->chan = chan;
    800015b2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015b6:	4789                	li	a5,2
    800015b8:	cc9c                	sw	a5,24(s1)

  sched();
    800015ba:	00000097          	auipc	ra,0x0
    800015be:	eb8080e7          	jalr	-328(ra) # 80001472 <sched>

  // Tidy up.
  p->chan = 0;
    800015c2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015c6:	8526                	mv	a0,s1
    800015c8:	00005097          	auipc	ra,0x5
    800015cc:	d36080e7          	jalr	-714(ra) # 800062fe <release>
  acquire(lk);
    800015d0:	854a                	mv	a0,s2
    800015d2:	00005097          	auipc	ra,0x5
    800015d6:	c78080e7          	jalr	-904(ra) # 8000624a <acquire>
}
    800015da:	70a2                	ld	ra,40(sp)
    800015dc:	7402                	ld	s0,32(sp)
    800015de:	64e2                	ld	s1,24(sp)
    800015e0:	6942                	ld	s2,16(sp)
    800015e2:	69a2                	ld	s3,8(sp)
    800015e4:	6145                	addi	sp,sp,48
    800015e6:	8082                	ret

00000000800015e8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015e8:	7139                	addi	sp,sp,-64
    800015ea:	fc06                	sd	ra,56(sp)
    800015ec:	f822                	sd	s0,48(sp)
    800015ee:	f426                	sd	s1,40(sp)
    800015f0:	f04a                	sd	s2,32(sp)
    800015f2:	ec4e                	sd	s3,24(sp)
    800015f4:	e852                	sd	s4,16(sp)
    800015f6:	e456                	sd	s5,8(sp)
    800015f8:	0080                	addi	s0,sp,64
    800015fa:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015fc:	00008497          	auipc	s1,0x8
    80001600:	8d448493          	addi	s1,s1,-1836 # 80008ed0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001604:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001606:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001608:	0000d917          	auipc	s2,0xd
    8000160c:	4c890913          	addi	s2,s2,1224 # 8000ead0 <tickslock>
    80001610:	a811                	j	80001624 <wakeup+0x3c>
      }
      release(&p->lock);
    80001612:	8526                	mv	a0,s1
    80001614:	00005097          	auipc	ra,0x5
    80001618:	cea080e7          	jalr	-790(ra) # 800062fe <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000161c:	17048493          	addi	s1,s1,368
    80001620:	03248663          	beq	s1,s2,8000164c <wakeup+0x64>
    if(p != myproc()){
    80001624:	00000097          	auipc	ra,0x0
    80001628:	8ac080e7          	jalr	-1876(ra) # 80000ed0 <myproc>
    8000162c:	fea488e3          	beq	s1,a0,8000161c <wakeup+0x34>
      acquire(&p->lock);
    80001630:	8526                	mv	a0,s1
    80001632:	00005097          	auipc	ra,0x5
    80001636:	c18080e7          	jalr	-1000(ra) # 8000624a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000163a:	4c9c                	lw	a5,24(s1)
    8000163c:	fd379be3          	bne	a5,s3,80001612 <wakeup+0x2a>
    80001640:	709c                	ld	a5,32(s1)
    80001642:	fd4798e3          	bne	a5,s4,80001612 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001646:	0154ac23          	sw	s5,24(s1)
    8000164a:	b7e1                	j	80001612 <wakeup+0x2a>
    }
  }
}
    8000164c:	70e2                	ld	ra,56(sp)
    8000164e:	7442                	ld	s0,48(sp)
    80001650:	74a2                	ld	s1,40(sp)
    80001652:	7902                	ld	s2,32(sp)
    80001654:	69e2                	ld	s3,24(sp)
    80001656:	6a42                	ld	s4,16(sp)
    80001658:	6aa2                	ld	s5,8(sp)
    8000165a:	6121                	addi	sp,sp,64
    8000165c:	8082                	ret

000000008000165e <reparent>:
{
    8000165e:	7179                	addi	sp,sp,-48
    80001660:	f406                	sd	ra,40(sp)
    80001662:	f022                	sd	s0,32(sp)
    80001664:	ec26                	sd	s1,24(sp)
    80001666:	e84a                	sd	s2,16(sp)
    80001668:	e44e                	sd	s3,8(sp)
    8000166a:	e052                	sd	s4,0(sp)
    8000166c:	1800                	addi	s0,sp,48
    8000166e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001670:	00008497          	auipc	s1,0x8
    80001674:	86048493          	addi	s1,s1,-1952 # 80008ed0 <proc>
      pp->parent = initproc;
    80001678:	00007a17          	auipc	s4,0x7
    8000167c:	3e8a0a13          	addi	s4,s4,1000 # 80008a60 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001680:	0000d997          	auipc	s3,0xd
    80001684:	45098993          	addi	s3,s3,1104 # 8000ead0 <tickslock>
    80001688:	a029                	j	80001692 <reparent+0x34>
    8000168a:	17048493          	addi	s1,s1,368
    8000168e:	01348d63          	beq	s1,s3,800016a8 <reparent+0x4a>
    if(pp->parent == p){
    80001692:	7c9c                	ld	a5,56(s1)
    80001694:	ff279be3          	bne	a5,s2,8000168a <reparent+0x2c>
      pp->parent = initproc;
    80001698:	000a3503          	ld	a0,0(s4)
    8000169c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	f4a080e7          	jalr	-182(ra) # 800015e8 <wakeup>
    800016a6:	b7d5                	j	8000168a <reparent+0x2c>
}
    800016a8:	70a2                	ld	ra,40(sp)
    800016aa:	7402                	ld	s0,32(sp)
    800016ac:	64e2                	ld	s1,24(sp)
    800016ae:	6942                	ld	s2,16(sp)
    800016b0:	69a2                	ld	s3,8(sp)
    800016b2:	6a02                	ld	s4,0(sp)
    800016b4:	6145                	addi	sp,sp,48
    800016b6:	8082                	ret

00000000800016b8 <exit>:
{
    800016b8:	7179                	addi	sp,sp,-48
    800016ba:	f406                	sd	ra,40(sp)
    800016bc:	f022                	sd	s0,32(sp)
    800016be:	ec26                	sd	s1,24(sp)
    800016c0:	e84a                	sd	s2,16(sp)
    800016c2:	e44e                	sd	s3,8(sp)
    800016c4:	e052                	sd	s4,0(sp)
    800016c6:	1800                	addi	s0,sp,48
    800016c8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016ca:	00000097          	auipc	ra,0x0
    800016ce:	806080e7          	jalr	-2042(ra) # 80000ed0 <myproc>
    800016d2:	89aa                	mv	s3,a0
  if(p == initproc)
    800016d4:	00007797          	auipc	a5,0x7
    800016d8:	38c7b783          	ld	a5,908(a5) # 80008a60 <initproc>
    800016dc:	0d050493          	addi	s1,a0,208
    800016e0:	15050913          	addi	s2,a0,336
    800016e4:	02a79363          	bne	a5,a0,8000170a <exit+0x52>
    panic("init exiting");
    800016e8:	00007517          	auipc	a0,0x7
    800016ec:	b3850513          	addi	a0,a0,-1224 # 80008220 <etext+0x220>
    800016f0:	00004097          	auipc	ra,0x4
    800016f4:	61e080e7          	jalr	1566(ra) # 80005d0e <panic>
      fileclose(f);
    800016f8:	00002097          	auipc	ra,0x2
    800016fc:	3fc080e7          	jalr	1020(ra) # 80003af4 <fileclose>
      p->ofile[fd] = 0;
    80001700:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001704:	04a1                	addi	s1,s1,8
    80001706:	01248563          	beq	s1,s2,80001710 <exit+0x58>
    if(p->ofile[fd]){
    8000170a:	6088                	ld	a0,0(s1)
    8000170c:	f575                	bnez	a0,800016f8 <exit+0x40>
    8000170e:	bfdd                	j	80001704 <exit+0x4c>
  begin_op();
    80001710:	00002097          	auipc	ra,0x2
    80001714:	f18080e7          	jalr	-232(ra) # 80003628 <begin_op>
  iput(p->cwd);
    80001718:	1509b503          	ld	a0,336(s3)
    8000171c:	00001097          	auipc	ra,0x1
    80001720:	704080e7          	jalr	1796(ra) # 80002e20 <iput>
  end_op();
    80001724:	00002097          	auipc	ra,0x2
    80001728:	f84080e7          	jalr	-124(ra) # 800036a8 <end_op>
  p->cwd = 0;
    8000172c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001730:	00007497          	auipc	s1,0x7
    80001734:	38848493          	addi	s1,s1,904 # 80008ab8 <wait_lock>
    80001738:	8526                	mv	a0,s1
    8000173a:	00005097          	auipc	ra,0x5
    8000173e:	b10080e7          	jalr	-1264(ra) # 8000624a <acquire>
  reparent(p);
    80001742:	854e                	mv	a0,s3
    80001744:	00000097          	auipc	ra,0x0
    80001748:	f1a080e7          	jalr	-230(ra) # 8000165e <reparent>
  wakeup(p->parent);
    8000174c:	0389b503          	ld	a0,56(s3)
    80001750:	00000097          	auipc	ra,0x0
    80001754:	e98080e7          	jalr	-360(ra) # 800015e8 <wakeup>
  acquire(&p->lock);
    80001758:	854e                	mv	a0,s3
    8000175a:	00005097          	auipc	ra,0x5
    8000175e:	af0080e7          	jalr	-1296(ra) # 8000624a <acquire>
  p->xstate = status;
    80001762:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001766:	4795                	li	a5,5
    80001768:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000176c:	8526                	mv	a0,s1
    8000176e:	00005097          	auipc	ra,0x5
    80001772:	b90080e7          	jalr	-1136(ra) # 800062fe <release>
  sched();
    80001776:	00000097          	auipc	ra,0x0
    8000177a:	cfc080e7          	jalr	-772(ra) # 80001472 <sched>
  panic("zombie exit");
    8000177e:	00007517          	auipc	a0,0x7
    80001782:	ab250513          	addi	a0,a0,-1358 # 80008230 <etext+0x230>
    80001786:	00004097          	auipc	ra,0x4
    8000178a:	588080e7          	jalr	1416(ra) # 80005d0e <panic>

000000008000178e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000178e:	7179                	addi	sp,sp,-48
    80001790:	f406                	sd	ra,40(sp)
    80001792:	f022                	sd	s0,32(sp)
    80001794:	ec26                	sd	s1,24(sp)
    80001796:	e84a                	sd	s2,16(sp)
    80001798:	e44e                	sd	s3,8(sp)
    8000179a:	1800                	addi	s0,sp,48
    8000179c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000179e:	00007497          	auipc	s1,0x7
    800017a2:	73248493          	addi	s1,s1,1842 # 80008ed0 <proc>
    800017a6:	0000d997          	auipc	s3,0xd
    800017aa:	32a98993          	addi	s3,s3,810 # 8000ead0 <tickslock>
    acquire(&p->lock);
    800017ae:	8526                	mv	a0,s1
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	a9a080e7          	jalr	-1382(ra) # 8000624a <acquire>
    if(p->pid == pid){
    800017b8:	589c                	lw	a5,48(s1)
    800017ba:	01278d63          	beq	a5,s2,800017d4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	b3e080e7          	jalr	-1218(ra) # 800062fe <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017c8:	17048493          	addi	s1,s1,368
    800017cc:	ff3491e3          	bne	s1,s3,800017ae <kill+0x20>
  }
  return -1;
    800017d0:	557d                	li	a0,-1
    800017d2:	a829                	j	800017ec <kill+0x5e>
      p->killed = 1;
    800017d4:	4785                	li	a5,1
    800017d6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017d8:	4c98                	lw	a4,24(s1)
    800017da:	4789                	li	a5,2
    800017dc:	00f70f63          	beq	a4,a5,800017fa <kill+0x6c>
      release(&p->lock);
    800017e0:	8526                	mv	a0,s1
    800017e2:	00005097          	auipc	ra,0x5
    800017e6:	b1c080e7          	jalr	-1252(ra) # 800062fe <release>
      return 0;
    800017ea:	4501                	li	a0,0
}
    800017ec:	70a2                	ld	ra,40(sp)
    800017ee:	7402                	ld	s0,32(sp)
    800017f0:	64e2                	ld	s1,24(sp)
    800017f2:	6942                	ld	s2,16(sp)
    800017f4:	69a2                	ld	s3,8(sp)
    800017f6:	6145                	addi	sp,sp,48
    800017f8:	8082                	ret
        p->state = RUNNABLE;
    800017fa:	478d                	li	a5,3
    800017fc:	cc9c                	sw	a5,24(s1)
    800017fe:	b7cd                	j	800017e0 <kill+0x52>

0000000080001800 <setkilled>:

void
setkilled(struct proc *p)
{
    80001800:	1101                	addi	sp,sp,-32
    80001802:	ec06                	sd	ra,24(sp)
    80001804:	e822                	sd	s0,16(sp)
    80001806:	e426                	sd	s1,8(sp)
    80001808:	1000                	addi	s0,sp,32
    8000180a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	a3e080e7          	jalr	-1474(ra) # 8000624a <acquire>
  p->killed = 1;
    80001814:	4785                	li	a5,1
    80001816:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	ae4080e7          	jalr	-1308(ra) # 800062fe <release>
}
    80001822:	60e2                	ld	ra,24(sp)
    80001824:	6442                	ld	s0,16(sp)
    80001826:	64a2                	ld	s1,8(sp)
    80001828:	6105                	addi	sp,sp,32
    8000182a:	8082                	ret

000000008000182c <killed>:

int
killed(struct proc *p)
{
    8000182c:	1101                	addi	sp,sp,-32
    8000182e:	ec06                	sd	ra,24(sp)
    80001830:	e822                	sd	s0,16(sp)
    80001832:	e426                	sd	s1,8(sp)
    80001834:	e04a                	sd	s2,0(sp)
    80001836:	1000                	addi	s0,sp,32
    80001838:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000183a:	00005097          	auipc	ra,0x5
    8000183e:	a10080e7          	jalr	-1520(ra) # 8000624a <acquire>
  k = p->killed;
    80001842:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001846:	8526                	mv	a0,s1
    80001848:	00005097          	auipc	ra,0x5
    8000184c:	ab6080e7          	jalr	-1354(ra) # 800062fe <release>
  return k;
}
    80001850:	854a                	mv	a0,s2
    80001852:	60e2                	ld	ra,24(sp)
    80001854:	6442                	ld	s0,16(sp)
    80001856:	64a2                	ld	s1,8(sp)
    80001858:	6902                	ld	s2,0(sp)
    8000185a:	6105                	addi	sp,sp,32
    8000185c:	8082                	ret

000000008000185e <wait>:
{
    8000185e:	715d                	addi	sp,sp,-80
    80001860:	e486                	sd	ra,72(sp)
    80001862:	e0a2                	sd	s0,64(sp)
    80001864:	fc26                	sd	s1,56(sp)
    80001866:	f84a                	sd	s2,48(sp)
    80001868:	f44e                	sd	s3,40(sp)
    8000186a:	f052                	sd	s4,32(sp)
    8000186c:	ec56                	sd	s5,24(sp)
    8000186e:	e85a                	sd	s6,16(sp)
    80001870:	e45e                	sd	s7,8(sp)
    80001872:	e062                	sd	s8,0(sp)
    80001874:	0880                	addi	s0,sp,80
    80001876:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001878:	fffff097          	auipc	ra,0xfffff
    8000187c:	658080e7          	jalr	1624(ra) # 80000ed0 <myproc>
    80001880:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001882:	00007517          	auipc	a0,0x7
    80001886:	23650513          	addi	a0,a0,566 # 80008ab8 <wait_lock>
    8000188a:	00005097          	auipc	ra,0x5
    8000188e:	9c0080e7          	jalr	-1600(ra) # 8000624a <acquire>
    havekids = 0;
    80001892:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001894:	4a15                	li	s4,5
        havekids = 1;
    80001896:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001898:	0000d997          	auipc	s3,0xd
    8000189c:	23898993          	addi	s3,s3,568 # 8000ead0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018a0:	00007c17          	auipc	s8,0x7
    800018a4:	218c0c13          	addi	s8,s8,536 # 80008ab8 <wait_lock>
    havekids = 0;
    800018a8:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018aa:	00007497          	auipc	s1,0x7
    800018ae:	62648493          	addi	s1,s1,1574 # 80008ed0 <proc>
    800018b2:	a0bd                	j	80001920 <wait+0xc2>
          pid = pp->pid;
    800018b4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018b8:	000b0e63          	beqz	s6,800018d4 <wait+0x76>
    800018bc:	4691                	li	a3,4
    800018be:	02c48613          	addi	a2,s1,44
    800018c2:	85da                	mv	a1,s6
    800018c4:	05093503          	ld	a0,80(s2)
    800018c8:	fffff097          	auipc	ra,0xfffff
    800018cc:	290080e7          	jalr	656(ra) # 80000b58 <copyout>
    800018d0:	02054563          	bltz	a0,800018fa <wait+0x9c>
          freeproc(pp);
    800018d4:	8526                	mv	a0,s1
    800018d6:	fffff097          	auipc	ra,0xfffff
    800018da:	7b0080e7          	jalr	1968(ra) # 80001086 <freeproc>
          release(&pp->lock);
    800018de:	8526                	mv	a0,s1
    800018e0:	00005097          	auipc	ra,0x5
    800018e4:	a1e080e7          	jalr	-1506(ra) # 800062fe <release>
          release(&wait_lock);
    800018e8:	00007517          	auipc	a0,0x7
    800018ec:	1d050513          	addi	a0,a0,464 # 80008ab8 <wait_lock>
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	a0e080e7          	jalr	-1522(ra) # 800062fe <release>
          return pid;
    800018f8:	a0b5                	j	80001964 <wait+0x106>
            release(&pp->lock);
    800018fa:	8526                	mv	a0,s1
    800018fc:	00005097          	auipc	ra,0x5
    80001900:	a02080e7          	jalr	-1534(ra) # 800062fe <release>
            release(&wait_lock);
    80001904:	00007517          	auipc	a0,0x7
    80001908:	1b450513          	addi	a0,a0,436 # 80008ab8 <wait_lock>
    8000190c:	00005097          	auipc	ra,0x5
    80001910:	9f2080e7          	jalr	-1550(ra) # 800062fe <release>
            return -1;
    80001914:	59fd                	li	s3,-1
    80001916:	a0b9                	j	80001964 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001918:	17048493          	addi	s1,s1,368
    8000191c:	03348463          	beq	s1,s3,80001944 <wait+0xe6>
      if(pp->parent == p){
    80001920:	7c9c                	ld	a5,56(s1)
    80001922:	ff279be3          	bne	a5,s2,80001918 <wait+0xba>
        acquire(&pp->lock);
    80001926:	8526                	mv	a0,s1
    80001928:	00005097          	auipc	ra,0x5
    8000192c:	922080e7          	jalr	-1758(ra) # 8000624a <acquire>
        if(pp->state == ZOMBIE){
    80001930:	4c9c                	lw	a5,24(s1)
    80001932:	f94781e3          	beq	a5,s4,800018b4 <wait+0x56>
        release(&pp->lock);
    80001936:	8526                	mv	a0,s1
    80001938:	00005097          	auipc	ra,0x5
    8000193c:	9c6080e7          	jalr	-1594(ra) # 800062fe <release>
        havekids = 1;
    80001940:	8756                	mv	a4,s5
    80001942:	bfd9                	j	80001918 <wait+0xba>
    if(!havekids || killed(p)){
    80001944:	c719                	beqz	a4,80001952 <wait+0xf4>
    80001946:	854a                	mv	a0,s2
    80001948:	00000097          	auipc	ra,0x0
    8000194c:	ee4080e7          	jalr	-284(ra) # 8000182c <killed>
    80001950:	c51d                	beqz	a0,8000197e <wait+0x120>
      release(&wait_lock);
    80001952:	00007517          	auipc	a0,0x7
    80001956:	16650513          	addi	a0,a0,358 # 80008ab8 <wait_lock>
    8000195a:	00005097          	auipc	ra,0x5
    8000195e:	9a4080e7          	jalr	-1628(ra) # 800062fe <release>
      return -1;
    80001962:	59fd                	li	s3,-1
}
    80001964:	854e                	mv	a0,s3
    80001966:	60a6                	ld	ra,72(sp)
    80001968:	6406                	ld	s0,64(sp)
    8000196a:	74e2                	ld	s1,56(sp)
    8000196c:	7942                	ld	s2,48(sp)
    8000196e:	79a2                	ld	s3,40(sp)
    80001970:	7a02                	ld	s4,32(sp)
    80001972:	6ae2                	ld	s5,24(sp)
    80001974:	6b42                	ld	s6,16(sp)
    80001976:	6ba2                	ld	s7,8(sp)
    80001978:	6c02                	ld	s8,0(sp)
    8000197a:	6161                	addi	sp,sp,80
    8000197c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000197e:	85e2                	mv	a1,s8
    80001980:	854a                	mv	a0,s2
    80001982:	00000097          	auipc	ra,0x0
    80001986:	c02080e7          	jalr	-1022(ra) # 80001584 <sleep>
    havekids = 0;
    8000198a:	bf39                	j	800018a8 <wait+0x4a>

000000008000198c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000198c:	7179                	addi	sp,sp,-48
    8000198e:	f406                	sd	ra,40(sp)
    80001990:	f022                	sd	s0,32(sp)
    80001992:	ec26                	sd	s1,24(sp)
    80001994:	e84a                	sd	s2,16(sp)
    80001996:	e44e                	sd	s3,8(sp)
    80001998:	e052                	sd	s4,0(sp)
    8000199a:	1800                	addi	s0,sp,48
    8000199c:	84aa                	mv	s1,a0
    8000199e:	892e                	mv	s2,a1
    800019a0:	89b2                	mv	s3,a2
    800019a2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	52c080e7          	jalr	1324(ra) # 80000ed0 <myproc>
  if(user_dst){
    800019ac:	c08d                	beqz	s1,800019ce <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019ae:	86d2                	mv	a3,s4
    800019b0:	864e                	mv	a2,s3
    800019b2:	85ca                	mv	a1,s2
    800019b4:	6928                	ld	a0,80(a0)
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	1a2080e7          	jalr	418(ra) # 80000b58 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019be:	70a2                	ld	ra,40(sp)
    800019c0:	7402                	ld	s0,32(sp)
    800019c2:	64e2                	ld	s1,24(sp)
    800019c4:	6942                	ld	s2,16(sp)
    800019c6:	69a2                	ld	s3,8(sp)
    800019c8:	6a02                	ld	s4,0(sp)
    800019ca:	6145                	addi	sp,sp,48
    800019cc:	8082                	ret
    memmove((char *)dst, src, len);
    800019ce:	000a061b          	sext.w	a2,s4
    800019d2:	85ce                	mv	a1,s3
    800019d4:	854a                	mv	a0,s2
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	824080e7          	jalr	-2012(ra) # 800001fa <memmove>
    return 0;
    800019de:	8526                	mv	a0,s1
    800019e0:	bff9                	j	800019be <either_copyout+0x32>

00000000800019e2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019e2:	7179                	addi	sp,sp,-48
    800019e4:	f406                	sd	ra,40(sp)
    800019e6:	f022                	sd	s0,32(sp)
    800019e8:	ec26                	sd	s1,24(sp)
    800019ea:	e84a                	sd	s2,16(sp)
    800019ec:	e44e                	sd	s3,8(sp)
    800019ee:	e052                	sd	s4,0(sp)
    800019f0:	1800                	addi	s0,sp,48
    800019f2:	892a                	mv	s2,a0
    800019f4:	84ae                	mv	s1,a1
    800019f6:	89b2                	mv	s3,a2
    800019f8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019fa:	fffff097          	auipc	ra,0xfffff
    800019fe:	4d6080e7          	jalr	1238(ra) # 80000ed0 <myproc>
  if(user_src){
    80001a02:	c08d                	beqz	s1,80001a24 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a04:	86d2                	mv	a3,s4
    80001a06:	864e                	mv	a2,s3
    80001a08:	85ca                	mv	a1,s2
    80001a0a:	6928                	ld	a0,80(a0)
    80001a0c:	fffff097          	auipc	ra,0xfffff
    80001a10:	20c080e7          	jalr	524(ra) # 80000c18 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a14:	70a2                	ld	ra,40(sp)
    80001a16:	7402                	ld	s0,32(sp)
    80001a18:	64e2                	ld	s1,24(sp)
    80001a1a:	6942                	ld	s2,16(sp)
    80001a1c:	69a2                	ld	s3,8(sp)
    80001a1e:	6a02                	ld	s4,0(sp)
    80001a20:	6145                	addi	sp,sp,48
    80001a22:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a24:	000a061b          	sext.w	a2,s4
    80001a28:	85ce                	mv	a1,s3
    80001a2a:	854a                	mv	a0,s2
    80001a2c:	ffffe097          	auipc	ra,0xffffe
    80001a30:	7ce080e7          	jalr	1998(ra) # 800001fa <memmove>
    return 0;
    80001a34:	8526                	mv	a0,s1
    80001a36:	bff9                	j	80001a14 <either_copyin+0x32>

0000000080001a38 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a38:	715d                	addi	sp,sp,-80
    80001a3a:	e486                	sd	ra,72(sp)
    80001a3c:	e0a2                	sd	s0,64(sp)
    80001a3e:	fc26                	sd	s1,56(sp)
    80001a40:	f84a                	sd	s2,48(sp)
    80001a42:	f44e                	sd	s3,40(sp)
    80001a44:	f052                	sd	s4,32(sp)
    80001a46:	ec56                	sd	s5,24(sp)
    80001a48:	e85a                	sd	s6,16(sp)
    80001a4a:	e45e                	sd	s7,8(sp)
    80001a4c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a4e:	00006517          	auipc	a0,0x6
    80001a52:	5fa50513          	addi	a0,a0,1530 # 80008048 <etext+0x48>
    80001a56:	00004097          	auipc	ra,0x4
    80001a5a:	302080e7          	jalr	770(ra) # 80005d58 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a5e:	00007497          	auipc	s1,0x7
    80001a62:	5ca48493          	addi	s1,s1,1482 # 80009028 <proc+0x158>
    80001a66:	0000d917          	auipc	s2,0xd
    80001a6a:	1c290913          	addi	s2,s2,450 # 8000ec28 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a6e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a70:	00006997          	auipc	s3,0x6
    80001a74:	7d098993          	addi	s3,s3,2000 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001a78:	00006a97          	auipc	s5,0x6
    80001a7c:	7d0a8a93          	addi	s5,s5,2000 # 80008248 <etext+0x248>
    printf("\n");
    80001a80:	00006a17          	auipc	s4,0x6
    80001a84:	5c8a0a13          	addi	s4,s4,1480 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a88:	00007b97          	auipc	s7,0x7
    80001a8c:	800b8b93          	addi	s7,s7,-2048 # 80008288 <states.0>
    80001a90:	a00d                	j	80001ab2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a92:	ed86a583          	lw	a1,-296(a3)
    80001a96:	8556                	mv	a0,s5
    80001a98:	00004097          	auipc	ra,0x4
    80001a9c:	2c0080e7          	jalr	704(ra) # 80005d58 <printf>
    printf("\n");
    80001aa0:	8552                	mv	a0,s4
    80001aa2:	00004097          	auipc	ra,0x4
    80001aa6:	2b6080e7          	jalr	694(ra) # 80005d58 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aaa:	17048493          	addi	s1,s1,368
    80001aae:	03248163          	beq	s1,s2,80001ad0 <procdump+0x98>
    if(p->state == UNUSED)
    80001ab2:	86a6                	mv	a3,s1
    80001ab4:	ec04a783          	lw	a5,-320(s1)
    80001ab8:	dbed                	beqz	a5,80001aaa <procdump+0x72>
      state = "???";
    80001aba:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001abc:	fcfb6be3          	bltu	s6,a5,80001a92 <procdump+0x5a>
    80001ac0:	1782                	slli	a5,a5,0x20
    80001ac2:	9381                	srli	a5,a5,0x20
    80001ac4:	078e                	slli	a5,a5,0x3
    80001ac6:	97de                	add	a5,a5,s7
    80001ac8:	6390                	ld	a2,0(a5)
    80001aca:	f661                	bnez	a2,80001a92 <procdump+0x5a>
      state = "???";
    80001acc:	864e                	mv	a2,s3
    80001ace:	b7d1                	j	80001a92 <procdump+0x5a>
  }
}
    80001ad0:	60a6                	ld	ra,72(sp)
    80001ad2:	6406                	ld	s0,64(sp)
    80001ad4:	74e2                	ld	s1,56(sp)
    80001ad6:	7942                	ld	s2,48(sp)
    80001ad8:	79a2                	ld	s3,40(sp)
    80001ada:	7a02                	ld	s4,32(sp)
    80001adc:	6ae2                	ld	s5,24(sp)
    80001ade:	6b42                	ld	s6,16(sp)
    80001ae0:	6ba2                	ld	s7,8(sp)
    80001ae2:	6161                	addi	sp,sp,80
    80001ae4:	8082                	ret

0000000080001ae6 <kprocnum>:

// calculate the num of processes
int 
kprocnum(void){
    80001ae6:	1141                	addi	sp,sp,-16
    80001ae8:	e422                	sd	s0,8(sp)
    80001aea:	0800                	addi	s0,sp,16
  struct proc *p;
  int num = 0;
    80001aec:	4501                	li	a0,0
  for(p = proc; p < &proc[NPROC]; p++){
    80001aee:	00007797          	auipc	a5,0x7
    80001af2:	3e278793          	addi	a5,a5,994 # 80008ed0 <proc>
    80001af6:	0000d697          	auipc	a3,0xd
    80001afa:	fda68693          	addi	a3,a3,-38 # 8000ead0 <tickslock>
    80001afe:	a029                	j	80001b08 <kprocnum+0x22>
    80001b00:	17078793          	addi	a5,a5,368
    80001b04:	00d78663          	beq	a5,a3,80001b10 <kprocnum+0x2a>
    if(p->state != UNUSED)
    80001b08:	4f98                	lw	a4,24(a5)
    80001b0a:	db7d                	beqz	a4,80001b00 <kprocnum+0x1a>
      num++;
    80001b0c:	2505                	addiw	a0,a0,1
    80001b0e:	bfcd                	j	80001b00 <kprocnum+0x1a>
  }
 // printf("kprocnum returns: %d", num);
  return num;
}
    80001b10:	6422                	ld	s0,8(sp)
    80001b12:	0141                	addi	sp,sp,16
    80001b14:	8082                	ret

0000000080001b16 <swtch>:
    80001b16:	00153023          	sd	ra,0(a0)
    80001b1a:	00253423          	sd	sp,8(a0)
    80001b1e:	e900                	sd	s0,16(a0)
    80001b20:	ed04                	sd	s1,24(a0)
    80001b22:	03253023          	sd	s2,32(a0)
    80001b26:	03353423          	sd	s3,40(a0)
    80001b2a:	03453823          	sd	s4,48(a0)
    80001b2e:	03553c23          	sd	s5,56(a0)
    80001b32:	05653023          	sd	s6,64(a0)
    80001b36:	05753423          	sd	s7,72(a0)
    80001b3a:	05853823          	sd	s8,80(a0)
    80001b3e:	05953c23          	sd	s9,88(a0)
    80001b42:	07a53023          	sd	s10,96(a0)
    80001b46:	07b53423          	sd	s11,104(a0)
    80001b4a:	0005b083          	ld	ra,0(a1)
    80001b4e:	0085b103          	ld	sp,8(a1)
    80001b52:	6980                	ld	s0,16(a1)
    80001b54:	6d84                	ld	s1,24(a1)
    80001b56:	0205b903          	ld	s2,32(a1)
    80001b5a:	0285b983          	ld	s3,40(a1)
    80001b5e:	0305ba03          	ld	s4,48(a1)
    80001b62:	0385ba83          	ld	s5,56(a1)
    80001b66:	0405bb03          	ld	s6,64(a1)
    80001b6a:	0485bb83          	ld	s7,72(a1)
    80001b6e:	0505bc03          	ld	s8,80(a1)
    80001b72:	0585bc83          	ld	s9,88(a1)
    80001b76:	0605bd03          	ld	s10,96(a1)
    80001b7a:	0685bd83          	ld	s11,104(a1)
    80001b7e:	8082                	ret

0000000080001b80 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b80:	1141                	addi	sp,sp,-16
    80001b82:	e406                	sd	ra,8(sp)
    80001b84:	e022                	sd	s0,0(sp)
    80001b86:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b88:	00006597          	auipc	a1,0x6
    80001b8c:	73058593          	addi	a1,a1,1840 # 800082b8 <states.0+0x30>
    80001b90:	0000d517          	auipc	a0,0xd
    80001b94:	f4050513          	addi	a0,a0,-192 # 8000ead0 <tickslock>
    80001b98:	00004097          	auipc	ra,0x4
    80001b9c:	622080e7          	jalr	1570(ra) # 800061ba <initlock>
}
    80001ba0:	60a2                	ld	ra,8(sp)
    80001ba2:	6402                	ld	s0,0(sp)
    80001ba4:	0141                	addi	sp,sp,16
    80001ba6:	8082                	ret

0000000080001ba8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ba8:	1141                	addi	sp,sp,-16
    80001baa:	e422                	sd	s0,8(sp)
    80001bac:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bae:	00003797          	auipc	a5,0x3
    80001bb2:	59278793          	addi	a5,a5,1426 # 80005140 <kernelvec>
    80001bb6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bba:	6422                	ld	s0,8(sp)
    80001bbc:	0141                	addi	sp,sp,16
    80001bbe:	8082                	ret

0000000080001bc0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bc0:	1141                	addi	sp,sp,-16
    80001bc2:	e406                	sd	ra,8(sp)
    80001bc4:	e022                	sd	s0,0(sp)
    80001bc6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bc8:	fffff097          	auipc	ra,0xfffff
    80001bcc:	308080e7          	jalr	776(ra) # 80000ed0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bd0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bd4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bd6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001bda:	00005617          	auipc	a2,0x5
    80001bde:	42660613          	addi	a2,a2,1062 # 80007000 <_trampoline>
    80001be2:	00005697          	auipc	a3,0x5
    80001be6:	41e68693          	addi	a3,a3,1054 # 80007000 <_trampoline>
    80001bea:	8e91                	sub	a3,a3,a2
    80001bec:	040007b7          	lui	a5,0x4000
    80001bf0:	17fd                	addi	a5,a5,-1
    80001bf2:	07b2                	slli	a5,a5,0xc
    80001bf4:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bf6:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bfa:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bfc:	180026f3          	csrr	a3,satp
    80001c00:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c02:	6d38                	ld	a4,88(a0)
    80001c04:	6134                	ld	a3,64(a0)
    80001c06:	6585                	lui	a1,0x1
    80001c08:	96ae                	add	a3,a3,a1
    80001c0a:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c0c:	6d38                	ld	a4,88(a0)
    80001c0e:	00000697          	auipc	a3,0x0
    80001c12:	13068693          	addi	a3,a3,304 # 80001d3e <usertrap>
    80001c16:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c18:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c1a:	8692                	mv	a3,tp
    80001c1c:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c1e:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c22:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c26:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c2a:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c2e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c30:	6f18                	ld	a4,24(a4)
    80001c32:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c36:	6928                	ld	a0,80(a0)
    80001c38:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c3a:	00005717          	auipc	a4,0x5
    80001c3e:	46270713          	addi	a4,a4,1122 # 8000709c <userret>
    80001c42:	8f11                	sub	a4,a4,a2
    80001c44:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c46:	577d                	li	a4,-1
    80001c48:	177e                	slli	a4,a4,0x3f
    80001c4a:	8d59                	or	a0,a0,a4
    80001c4c:	9782                	jalr	a5
}
    80001c4e:	60a2                	ld	ra,8(sp)
    80001c50:	6402                	ld	s0,0(sp)
    80001c52:	0141                	addi	sp,sp,16
    80001c54:	8082                	ret

0000000080001c56 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c56:	1101                	addi	sp,sp,-32
    80001c58:	ec06                	sd	ra,24(sp)
    80001c5a:	e822                	sd	s0,16(sp)
    80001c5c:	e426                	sd	s1,8(sp)
    80001c5e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c60:	0000d497          	auipc	s1,0xd
    80001c64:	e7048493          	addi	s1,s1,-400 # 8000ead0 <tickslock>
    80001c68:	8526                	mv	a0,s1
    80001c6a:	00004097          	auipc	ra,0x4
    80001c6e:	5e0080e7          	jalr	1504(ra) # 8000624a <acquire>
  ticks++;
    80001c72:	00007517          	auipc	a0,0x7
    80001c76:	df650513          	addi	a0,a0,-522 # 80008a68 <ticks>
    80001c7a:	411c                	lw	a5,0(a0)
    80001c7c:	2785                	addiw	a5,a5,1
    80001c7e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c80:	00000097          	auipc	ra,0x0
    80001c84:	968080e7          	jalr	-1688(ra) # 800015e8 <wakeup>
  release(&tickslock);
    80001c88:	8526                	mv	a0,s1
    80001c8a:	00004097          	auipc	ra,0x4
    80001c8e:	674080e7          	jalr	1652(ra) # 800062fe <release>
}
    80001c92:	60e2                	ld	ra,24(sp)
    80001c94:	6442                	ld	s0,16(sp)
    80001c96:	64a2                	ld	s1,8(sp)
    80001c98:	6105                	addi	sp,sp,32
    80001c9a:	8082                	ret

0000000080001c9c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c9c:	1101                	addi	sp,sp,-32
    80001c9e:	ec06                	sd	ra,24(sp)
    80001ca0:	e822                	sd	s0,16(sp)
    80001ca2:	e426                	sd	s1,8(sp)
    80001ca4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ca6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001caa:	00074d63          	bltz	a4,80001cc4 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001cae:	57fd                	li	a5,-1
    80001cb0:	17fe                	slli	a5,a5,0x3f
    80001cb2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cb4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cb6:	06f70363          	beq	a4,a5,80001d1c <devintr+0x80>
  }
}
    80001cba:	60e2                	ld	ra,24(sp)
    80001cbc:	6442                	ld	s0,16(sp)
    80001cbe:	64a2                	ld	s1,8(sp)
    80001cc0:	6105                	addi	sp,sp,32
    80001cc2:	8082                	ret
     (scause & 0xff) == 9){
    80001cc4:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001cc8:	46a5                	li	a3,9
    80001cca:	fed792e3          	bne	a5,a3,80001cae <devintr+0x12>
    int irq = plic_claim();
    80001cce:	00003097          	auipc	ra,0x3
    80001cd2:	57a080e7          	jalr	1402(ra) # 80005248 <plic_claim>
    80001cd6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cd8:	47a9                	li	a5,10
    80001cda:	02f50763          	beq	a0,a5,80001d08 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001cde:	4785                	li	a5,1
    80001ce0:	02f50963          	beq	a0,a5,80001d12 <devintr+0x76>
    return 1;
    80001ce4:	4505                	li	a0,1
    } else if(irq){
    80001ce6:	d8f1                	beqz	s1,80001cba <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001ce8:	85a6                	mv	a1,s1
    80001cea:	00006517          	auipc	a0,0x6
    80001cee:	5d650513          	addi	a0,a0,1494 # 800082c0 <states.0+0x38>
    80001cf2:	00004097          	auipc	ra,0x4
    80001cf6:	066080e7          	jalr	102(ra) # 80005d58 <printf>
      plic_complete(irq);
    80001cfa:	8526                	mv	a0,s1
    80001cfc:	00003097          	auipc	ra,0x3
    80001d00:	570080e7          	jalr	1392(ra) # 8000526c <plic_complete>
    return 1;
    80001d04:	4505                	li	a0,1
    80001d06:	bf55                	j	80001cba <devintr+0x1e>
      uartintr();
    80001d08:	00004097          	auipc	ra,0x4
    80001d0c:	462080e7          	jalr	1122(ra) # 8000616a <uartintr>
    80001d10:	b7ed                	j	80001cfa <devintr+0x5e>
      virtio_disk_intr();
    80001d12:	00004097          	auipc	ra,0x4
    80001d16:	a26080e7          	jalr	-1498(ra) # 80005738 <virtio_disk_intr>
    80001d1a:	b7c5                	j	80001cfa <devintr+0x5e>
    if(cpuid() == 0){
    80001d1c:	fffff097          	auipc	ra,0xfffff
    80001d20:	188080e7          	jalr	392(ra) # 80000ea4 <cpuid>
    80001d24:	c901                	beqz	a0,80001d34 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d26:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d2a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d2c:	14479073          	csrw	sip,a5
    return 2;
    80001d30:	4509                	li	a0,2
    80001d32:	b761                	j	80001cba <devintr+0x1e>
      clockintr();
    80001d34:	00000097          	auipc	ra,0x0
    80001d38:	f22080e7          	jalr	-222(ra) # 80001c56 <clockintr>
    80001d3c:	b7ed                	j	80001d26 <devintr+0x8a>

0000000080001d3e <usertrap>:
{
    80001d3e:	1101                	addi	sp,sp,-32
    80001d40:	ec06                	sd	ra,24(sp)
    80001d42:	e822                	sd	s0,16(sp)
    80001d44:	e426                	sd	s1,8(sp)
    80001d46:	e04a                	sd	s2,0(sp)
    80001d48:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d4a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d4e:	1007f793          	andi	a5,a5,256
    80001d52:	e3b1                	bnez	a5,80001d96 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d54:	00003797          	auipc	a5,0x3
    80001d58:	3ec78793          	addi	a5,a5,1004 # 80005140 <kernelvec>
    80001d5c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d60:	fffff097          	auipc	ra,0xfffff
    80001d64:	170080e7          	jalr	368(ra) # 80000ed0 <myproc>
    80001d68:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d6a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d6c:	14102773          	csrr	a4,sepc
    80001d70:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d72:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d76:	47a1                	li	a5,8
    80001d78:	02f70763          	beq	a4,a5,80001da6 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d7c:	00000097          	auipc	ra,0x0
    80001d80:	f20080e7          	jalr	-224(ra) # 80001c9c <devintr>
    80001d84:	892a                	mv	s2,a0
    80001d86:	c151                	beqz	a0,80001e0a <usertrap+0xcc>
  if(killed(p))
    80001d88:	8526                	mv	a0,s1
    80001d8a:	00000097          	auipc	ra,0x0
    80001d8e:	aa2080e7          	jalr	-1374(ra) # 8000182c <killed>
    80001d92:	c929                	beqz	a0,80001de4 <usertrap+0xa6>
    80001d94:	a099                	j	80001dda <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d96:	00006517          	auipc	a0,0x6
    80001d9a:	54a50513          	addi	a0,a0,1354 # 800082e0 <states.0+0x58>
    80001d9e:	00004097          	auipc	ra,0x4
    80001da2:	f70080e7          	jalr	-144(ra) # 80005d0e <panic>
    if(killed(p))
    80001da6:	00000097          	auipc	ra,0x0
    80001daa:	a86080e7          	jalr	-1402(ra) # 8000182c <killed>
    80001dae:	e921                	bnez	a0,80001dfe <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001db0:	6cb8                	ld	a4,88(s1)
    80001db2:	6f1c                	ld	a5,24(a4)
    80001db4:	0791                	addi	a5,a5,4
    80001db6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dbc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dc0:	10079073          	csrw	sstatus,a5
    syscall();
    80001dc4:	00000097          	auipc	ra,0x0
    80001dc8:	2d4080e7          	jalr	724(ra) # 80002098 <syscall>
  if(killed(p))
    80001dcc:	8526                	mv	a0,s1
    80001dce:	00000097          	auipc	ra,0x0
    80001dd2:	a5e080e7          	jalr	-1442(ra) # 8000182c <killed>
    80001dd6:	c911                	beqz	a0,80001dea <usertrap+0xac>
    80001dd8:	4901                	li	s2,0
    exit(-1);
    80001dda:	557d                	li	a0,-1
    80001ddc:	00000097          	auipc	ra,0x0
    80001de0:	8dc080e7          	jalr	-1828(ra) # 800016b8 <exit>
  if(which_dev == 2)
    80001de4:	4789                	li	a5,2
    80001de6:	04f90f63          	beq	s2,a5,80001e44 <usertrap+0x106>
  usertrapret();
    80001dea:	00000097          	auipc	ra,0x0
    80001dee:	dd6080e7          	jalr	-554(ra) # 80001bc0 <usertrapret>
}
    80001df2:	60e2                	ld	ra,24(sp)
    80001df4:	6442                	ld	s0,16(sp)
    80001df6:	64a2                	ld	s1,8(sp)
    80001df8:	6902                	ld	s2,0(sp)
    80001dfa:	6105                	addi	sp,sp,32
    80001dfc:	8082                	ret
      exit(-1);
    80001dfe:	557d                	li	a0,-1
    80001e00:	00000097          	auipc	ra,0x0
    80001e04:	8b8080e7          	jalr	-1864(ra) # 800016b8 <exit>
    80001e08:	b765                	j	80001db0 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e0a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e0e:	5890                	lw	a2,48(s1)
    80001e10:	00006517          	auipc	a0,0x6
    80001e14:	4f050513          	addi	a0,a0,1264 # 80008300 <states.0+0x78>
    80001e18:	00004097          	auipc	ra,0x4
    80001e1c:	f40080e7          	jalr	-192(ra) # 80005d58 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e20:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e24:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e28:	00006517          	auipc	a0,0x6
    80001e2c:	50850513          	addi	a0,a0,1288 # 80008330 <states.0+0xa8>
    80001e30:	00004097          	auipc	ra,0x4
    80001e34:	f28080e7          	jalr	-216(ra) # 80005d58 <printf>
    setkilled(p);
    80001e38:	8526                	mv	a0,s1
    80001e3a:	00000097          	auipc	ra,0x0
    80001e3e:	9c6080e7          	jalr	-1594(ra) # 80001800 <setkilled>
    80001e42:	b769                	j	80001dcc <usertrap+0x8e>
    yield();
    80001e44:	fffff097          	auipc	ra,0xfffff
    80001e48:	704080e7          	jalr	1796(ra) # 80001548 <yield>
    80001e4c:	bf79                	j	80001dea <usertrap+0xac>

0000000080001e4e <kerneltrap>:
{
    80001e4e:	7179                	addi	sp,sp,-48
    80001e50:	f406                	sd	ra,40(sp)
    80001e52:	f022                	sd	s0,32(sp)
    80001e54:	ec26                	sd	s1,24(sp)
    80001e56:	e84a                	sd	s2,16(sp)
    80001e58:	e44e                	sd	s3,8(sp)
    80001e5a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e5c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e60:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e64:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e68:	1004f793          	andi	a5,s1,256
    80001e6c:	cb85                	beqz	a5,80001e9c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e6e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e72:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e74:	ef85                	bnez	a5,80001eac <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e76:	00000097          	auipc	ra,0x0
    80001e7a:	e26080e7          	jalr	-474(ra) # 80001c9c <devintr>
    80001e7e:	cd1d                	beqz	a0,80001ebc <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e80:	4789                	li	a5,2
    80001e82:	06f50a63          	beq	a0,a5,80001ef6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e86:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e8a:	10049073          	csrw	sstatus,s1
}
    80001e8e:	70a2                	ld	ra,40(sp)
    80001e90:	7402                	ld	s0,32(sp)
    80001e92:	64e2                	ld	s1,24(sp)
    80001e94:	6942                	ld	s2,16(sp)
    80001e96:	69a2                	ld	s3,8(sp)
    80001e98:	6145                	addi	sp,sp,48
    80001e9a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e9c:	00006517          	auipc	a0,0x6
    80001ea0:	4b450513          	addi	a0,a0,1204 # 80008350 <states.0+0xc8>
    80001ea4:	00004097          	auipc	ra,0x4
    80001ea8:	e6a080e7          	jalr	-406(ra) # 80005d0e <panic>
    panic("kerneltrap: interrupts enabled");
    80001eac:	00006517          	auipc	a0,0x6
    80001eb0:	4cc50513          	addi	a0,a0,1228 # 80008378 <states.0+0xf0>
    80001eb4:	00004097          	auipc	ra,0x4
    80001eb8:	e5a080e7          	jalr	-422(ra) # 80005d0e <panic>
    printf("scause %p\n", scause);
    80001ebc:	85ce                	mv	a1,s3
    80001ebe:	00006517          	auipc	a0,0x6
    80001ec2:	4da50513          	addi	a0,a0,1242 # 80008398 <states.0+0x110>
    80001ec6:	00004097          	auipc	ra,0x4
    80001eca:	e92080e7          	jalr	-366(ra) # 80005d58 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ece:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ed2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ed6:	00006517          	auipc	a0,0x6
    80001eda:	4d250513          	addi	a0,a0,1234 # 800083a8 <states.0+0x120>
    80001ede:	00004097          	auipc	ra,0x4
    80001ee2:	e7a080e7          	jalr	-390(ra) # 80005d58 <printf>
    panic("kerneltrap");
    80001ee6:	00006517          	auipc	a0,0x6
    80001eea:	4da50513          	addi	a0,a0,1242 # 800083c0 <states.0+0x138>
    80001eee:	00004097          	auipc	ra,0x4
    80001ef2:	e20080e7          	jalr	-480(ra) # 80005d0e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	fda080e7          	jalr	-38(ra) # 80000ed0 <myproc>
    80001efe:	d541                	beqz	a0,80001e86 <kerneltrap+0x38>
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	fd0080e7          	jalr	-48(ra) # 80000ed0 <myproc>
    80001f08:	4d18                	lw	a4,24(a0)
    80001f0a:	4791                	li	a5,4
    80001f0c:	f6f71de3          	bne	a4,a5,80001e86 <kerneltrap+0x38>
    yield();
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	638080e7          	jalr	1592(ra) # 80001548 <yield>
    80001f18:	b7bd                	j	80001e86 <kerneltrap+0x38>

0000000080001f1a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f1a:	1101                	addi	sp,sp,-32
    80001f1c:	ec06                	sd	ra,24(sp)
    80001f1e:	e822                	sd	s0,16(sp)
    80001f20:	e426                	sd	s1,8(sp)
    80001f22:	1000                	addi	s0,sp,32
    80001f24:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f26:	fffff097          	auipc	ra,0xfffff
    80001f2a:	faa080e7          	jalr	-86(ra) # 80000ed0 <myproc>
  switch (n) {
    80001f2e:	4795                	li	a5,5
    80001f30:	0497e163          	bltu	a5,s1,80001f72 <argraw+0x58>
    80001f34:	048a                	slli	s1,s1,0x2
    80001f36:	00006717          	auipc	a4,0x6
    80001f3a:	58a70713          	addi	a4,a4,1418 # 800084c0 <states.0+0x238>
    80001f3e:	94ba                	add	s1,s1,a4
    80001f40:	409c                	lw	a5,0(s1)
    80001f42:	97ba                	add	a5,a5,a4
    80001f44:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f46:	6d3c                	ld	a5,88(a0)
    80001f48:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f4a:	60e2                	ld	ra,24(sp)
    80001f4c:	6442                	ld	s0,16(sp)
    80001f4e:	64a2                	ld	s1,8(sp)
    80001f50:	6105                	addi	sp,sp,32
    80001f52:	8082                	ret
    return p->trapframe->a1;
    80001f54:	6d3c                	ld	a5,88(a0)
    80001f56:	7fa8                	ld	a0,120(a5)
    80001f58:	bfcd                	j	80001f4a <argraw+0x30>
    return p->trapframe->a2;
    80001f5a:	6d3c                	ld	a5,88(a0)
    80001f5c:	63c8                	ld	a0,128(a5)
    80001f5e:	b7f5                	j	80001f4a <argraw+0x30>
    return p->trapframe->a3;
    80001f60:	6d3c                	ld	a5,88(a0)
    80001f62:	67c8                	ld	a0,136(a5)
    80001f64:	b7dd                	j	80001f4a <argraw+0x30>
    return p->trapframe->a4;
    80001f66:	6d3c                	ld	a5,88(a0)
    80001f68:	6bc8                	ld	a0,144(a5)
    80001f6a:	b7c5                	j	80001f4a <argraw+0x30>
    return p->trapframe->a5;
    80001f6c:	6d3c                	ld	a5,88(a0)
    80001f6e:	6fc8                	ld	a0,152(a5)
    80001f70:	bfe9                	j	80001f4a <argraw+0x30>
  panic("argraw");
    80001f72:	00006517          	auipc	a0,0x6
    80001f76:	45e50513          	addi	a0,a0,1118 # 800083d0 <states.0+0x148>
    80001f7a:	00004097          	auipc	ra,0x4
    80001f7e:	d94080e7          	jalr	-620(ra) # 80005d0e <panic>

0000000080001f82 <fetchaddr>:
{
    80001f82:	1101                	addi	sp,sp,-32
    80001f84:	ec06                	sd	ra,24(sp)
    80001f86:	e822                	sd	s0,16(sp)
    80001f88:	e426                	sd	s1,8(sp)
    80001f8a:	e04a                	sd	s2,0(sp)
    80001f8c:	1000                	addi	s0,sp,32
    80001f8e:	84aa                	mv	s1,a0
    80001f90:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f92:	fffff097          	auipc	ra,0xfffff
    80001f96:	f3e080e7          	jalr	-194(ra) # 80000ed0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f9a:	653c                	ld	a5,72(a0)
    80001f9c:	02f4f863          	bgeu	s1,a5,80001fcc <fetchaddr+0x4a>
    80001fa0:	00848713          	addi	a4,s1,8
    80001fa4:	02e7e663          	bltu	a5,a4,80001fd0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fa8:	46a1                	li	a3,8
    80001faa:	8626                	mv	a2,s1
    80001fac:	85ca                	mv	a1,s2
    80001fae:	6928                	ld	a0,80(a0)
    80001fb0:	fffff097          	auipc	ra,0xfffff
    80001fb4:	c68080e7          	jalr	-920(ra) # 80000c18 <copyin>
    80001fb8:	00a03533          	snez	a0,a0
    80001fbc:	40a00533          	neg	a0,a0
}
    80001fc0:	60e2                	ld	ra,24(sp)
    80001fc2:	6442                	ld	s0,16(sp)
    80001fc4:	64a2                	ld	s1,8(sp)
    80001fc6:	6902                	ld	s2,0(sp)
    80001fc8:	6105                	addi	sp,sp,32
    80001fca:	8082                	ret
    return -1;
    80001fcc:	557d                	li	a0,-1
    80001fce:	bfcd                	j	80001fc0 <fetchaddr+0x3e>
    80001fd0:	557d                	li	a0,-1
    80001fd2:	b7fd                	j	80001fc0 <fetchaddr+0x3e>

0000000080001fd4 <fetchstr>:
{
    80001fd4:	7179                	addi	sp,sp,-48
    80001fd6:	f406                	sd	ra,40(sp)
    80001fd8:	f022                	sd	s0,32(sp)
    80001fda:	ec26                	sd	s1,24(sp)
    80001fdc:	e84a                	sd	s2,16(sp)
    80001fde:	e44e                	sd	s3,8(sp)
    80001fe0:	1800                	addi	s0,sp,48
    80001fe2:	892a                	mv	s2,a0
    80001fe4:	84ae                	mv	s1,a1
    80001fe6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fe8:	fffff097          	auipc	ra,0xfffff
    80001fec:	ee8080e7          	jalr	-280(ra) # 80000ed0 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001ff0:	86ce                	mv	a3,s3
    80001ff2:	864a                	mv	a2,s2
    80001ff4:	85a6                	mv	a1,s1
    80001ff6:	6928                	ld	a0,80(a0)
    80001ff8:	fffff097          	auipc	ra,0xfffff
    80001ffc:	cae080e7          	jalr	-850(ra) # 80000ca6 <copyinstr>
    80002000:	00054e63          	bltz	a0,8000201c <fetchstr+0x48>
  return strlen(buf);
    80002004:	8526                	mv	a0,s1
    80002006:	ffffe097          	auipc	ra,0xffffe
    8000200a:	314080e7          	jalr	788(ra) # 8000031a <strlen>
}
    8000200e:	70a2                	ld	ra,40(sp)
    80002010:	7402                	ld	s0,32(sp)
    80002012:	64e2                	ld	s1,24(sp)
    80002014:	6942                	ld	s2,16(sp)
    80002016:	69a2                	ld	s3,8(sp)
    80002018:	6145                	addi	sp,sp,48
    8000201a:	8082                	ret
    return -1;
    8000201c:	557d                	li	a0,-1
    8000201e:	bfc5                	j	8000200e <fetchstr+0x3a>

0000000080002020 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002020:	1101                	addi	sp,sp,-32
    80002022:	ec06                	sd	ra,24(sp)
    80002024:	e822                	sd	s0,16(sp)
    80002026:	e426                	sd	s1,8(sp)
    80002028:	1000                	addi	s0,sp,32
    8000202a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000202c:	00000097          	auipc	ra,0x0
    80002030:	eee080e7          	jalr	-274(ra) # 80001f1a <argraw>
    80002034:	c088                	sw	a0,0(s1)
}
    80002036:	60e2                	ld	ra,24(sp)
    80002038:	6442                	ld	s0,16(sp)
    8000203a:	64a2                	ld	s1,8(sp)
    8000203c:	6105                	addi	sp,sp,32
    8000203e:	8082                	ret

0000000080002040 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002040:	1101                	addi	sp,sp,-32
    80002042:	ec06                	sd	ra,24(sp)
    80002044:	e822                	sd	s0,16(sp)
    80002046:	e426                	sd	s1,8(sp)
    80002048:	1000                	addi	s0,sp,32
    8000204a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000204c:	00000097          	auipc	ra,0x0
    80002050:	ece080e7          	jalr	-306(ra) # 80001f1a <argraw>
    80002054:	e088                	sd	a0,0(s1)
}
    80002056:	60e2                	ld	ra,24(sp)
    80002058:	6442                	ld	s0,16(sp)
    8000205a:	64a2                	ld	s1,8(sp)
    8000205c:	6105                	addi	sp,sp,32
    8000205e:	8082                	ret

0000000080002060 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002060:	7179                	addi	sp,sp,-48
    80002062:	f406                	sd	ra,40(sp)
    80002064:	f022                	sd	s0,32(sp)
    80002066:	ec26                	sd	s1,24(sp)
    80002068:	e84a                	sd	s2,16(sp)
    8000206a:	1800                	addi	s0,sp,48
    8000206c:	84ae                	mv	s1,a1
    8000206e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002070:	fd840593          	addi	a1,s0,-40
    80002074:	00000097          	auipc	ra,0x0
    80002078:	fcc080e7          	jalr	-52(ra) # 80002040 <argaddr>
  return fetchstr(addr, buf, max);
    8000207c:	864a                	mv	a2,s2
    8000207e:	85a6                	mv	a1,s1
    80002080:	fd843503          	ld	a0,-40(s0)
    80002084:	00000097          	auipc	ra,0x0
    80002088:	f50080e7          	jalr	-176(ra) # 80001fd4 <fetchstr>
}
    8000208c:	70a2                	ld	ra,40(sp)
    8000208e:	7402                	ld	s0,32(sp)
    80002090:	64e2                	ld	s1,24(sp)
    80002092:	6942                	ld	s2,16(sp)
    80002094:	6145                	addi	sp,sp,48
    80002096:	8082                	ret

0000000080002098 <syscall>:
    "sysinfo"
};

void
syscall(void)
{
    80002098:	7179                	addi	sp,sp,-48
    8000209a:	f406                	sd	ra,40(sp)
    8000209c:	f022                	sd	s0,32(sp)
    8000209e:	ec26                	sd	s1,24(sp)
    800020a0:	e84a                	sd	s2,16(sp)
    800020a2:	e44e                	sd	s3,8(sp)
    800020a4:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    800020a6:	fffff097          	auipc	ra,0xfffff
    800020aa:	e2a080e7          	jalr	-470(ra) # 80000ed0 <myproc>
    800020ae:	84aa                	mv	s1,a0
  num = p->trapframe->a7;
    800020b0:	6d3c                	ld	a5,88(a0)
    800020b2:	77dc                	ld	a5,168(a5)
    800020b4:	0007891b          	sext.w	s2,a5

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020b8:	37fd                	addiw	a5,a5,-1
    800020ba:	4759                	li	a4,22
    800020bc:	04f76d63          	bltu	a4,a5,80002116 <syscall+0x7e>
    800020c0:	00391713          	slli	a4,s2,0x3
    800020c4:	00006797          	auipc	a5,0x6
    800020c8:	41478793          	addi	a5,a5,1044 # 800084d8 <syscalls>
    800020cc:	97ba                	add	a5,a5,a4
    800020ce:	639c                	ld	a5,0(a5)
    800020d0:	c3b9                	beqz	a5,80002116 <syscall+0x7e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    int mdval;
    mdval = syscalls[num]();
    800020d2:	9782                	jalr	a5
    800020d4:	0005099b          	sext.w	s3,a0
    if(p->mask & (1 << num))
    800020d8:	1684a783          	lw	a5,360(s1)
    800020dc:	4127d7bb          	sraw	a5,a5,s2
    800020e0:	8b85                	andi	a5,a5,1
    800020e2:	e789                	bnez	a5,800020ec <syscall+0x54>
    {
      //printf("num - 1 : %d, corresponding syscallname: %s\n", num - 1, syscallname[num - 1]);
      printf("%d: syscall %s -> %d\n", p->pid, syscallname[num - 1], mdval);
    }
    p->trapframe->a0 = mdval;
    800020e4:	6cbc                	ld	a5,88(s1)
    800020e6:	0737b823          	sd	s3,112(a5)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020ea:	a0a9                	j	80002134 <syscall+0x9c>
      printf("%d: syscall %s -> %d\n", p->pid, syscallname[num - 1], mdval);
    800020ec:	397d                	addiw	s2,s2,-1
    800020ee:	00391793          	slli	a5,s2,0x3
    800020f2:	00007917          	auipc	s2,0x7
    800020f6:	8a690913          	addi	s2,s2,-1882 # 80008998 <syscallname>
    800020fa:	993e                	add	s2,s2,a5
    800020fc:	86ce                	mv	a3,s3
    800020fe:	00093603          	ld	a2,0(s2)
    80002102:	588c                	lw	a1,48(s1)
    80002104:	00006517          	auipc	a0,0x6
    80002108:	2d450513          	addi	a0,a0,724 # 800083d8 <states.0+0x150>
    8000210c:	00004097          	auipc	ra,0x4
    80002110:	c4c080e7          	jalr	-948(ra) # 80005d58 <printf>
    80002114:	bfc1                	j	800020e4 <syscall+0x4c>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002116:	86ca                	mv	a3,s2
    80002118:	15848613          	addi	a2,s1,344
    8000211c:	588c                	lw	a1,48(s1)
    8000211e:	00006517          	auipc	a0,0x6
    80002122:	2d250513          	addi	a0,a0,722 # 800083f0 <states.0+0x168>
    80002126:	00004097          	auipc	ra,0x4
    8000212a:	c32080e7          	jalr	-974(ra) # 80005d58 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000212e:	6cbc                	ld	a5,88(s1)
    80002130:	577d                	li	a4,-1
    80002132:	fbb8                	sd	a4,112(a5)
  }
}
    80002134:	70a2                	ld	ra,40(sp)
    80002136:	7402                	ld	s0,32(sp)
    80002138:	64e2                	ld	s1,24(sp)
    8000213a:	6942                	ld	s2,16(sp)
    8000213c:	69a2                	ld	s3,8(sp)
    8000213e:	6145                	addi	sp,sp,48
    80002140:	8082                	ret

0000000080002142 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80002142:	1101                	addi	sp,sp,-32
    80002144:	ec06                	sd	ra,24(sp)
    80002146:	e822                	sd	s0,16(sp)
    80002148:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000214a:	fec40593          	addi	a1,s0,-20
    8000214e:	4501                	li	a0,0
    80002150:	00000097          	auipc	ra,0x0
    80002154:	ed0080e7          	jalr	-304(ra) # 80002020 <argint>
  exit(n);
    80002158:	fec42503          	lw	a0,-20(s0)
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	55c080e7          	jalr	1372(ra) # 800016b8 <exit>
  return 0;  // not reached
}
    80002164:	4501                	li	a0,0
    80002166:	60e2                	ld	ra,24(sp)
    80002168:	6442                	ld	s0,16(sp)
    8000216a:	6105                	addi	sp,sp,32
    8000216c:	8082                	ret

000000008000216e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000216e:	1141                	addi	sp,sp,-16
    80002170:	e406                	sd	ra,8(sp)
    80002172:	e022                	sd	s0,0(sp)
    80002174:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	d5a080e7          	jalr	-678(ra) # 80000ed0 <myproc>
}
    8000217e:	5908                	lw	a0,48(a0)
    80002180:	60a2                	ld	ra,8(sp)
    80002182:	6402                	ld	s0,0(sp)
    80002184:	0141                	addi	sp,sp,16
    80002186:	8082                	ret

0000000080002188 <sys_fork>:

uint64
sys_fork(void)
{
    80002188:	1141                	addi	sp,sp,-16
    8000218a:	e406                	sd	ra,8(sp)
    8000218c:	e022                	sd	s0,0(sp)
    8000218e:	0800                	addi	s0,sp,16
  return fork();
    80002190:	fffff097          	auipc	ra,0xfffff
    80002194:	0fa080e7          	jalr	250(ra) # 8000128a <fork>
}
    80002198:	60a2                	ld	ra,8(sp)
    8000219a:	6402                	ld	s0,0(sp)
    8000219c:	0141                	addi	sp,sp,16
    8000219e:	8082                	ret

00000000800021a0 <sys_wait>:

uint64
sys_wait(void)
{
    800021a0:	1101                	addi	sp,sp,-32
    800021a2:	ec06                	sd	ra,24(sp)
    800021a4:	e822                	sd	s0,16(sp)
    800021a6:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021a8:	fe840593          	addi	a1,s0,-24
    800021ac:	4501                	li	a0,0
    800021ae:	00000097          	auipc	ra,0x0
    800021b2:	e92080e7          	jalr	-366(ra) # 80002040 <argaddr>
  return wait(p);
    800021b6:	fe843503          	ld	a0,-24(s0)
    800021ba:	fffff097          	auipc	ra,0xfffff
    800021be:	6a4080e7          	jalr	1700(ra) # 8000185e <wait>
}
    800021c2:	60e2                	ld	ra,24(sp)
    800021c4:	6442                	ld	s0,16(sp)
    800021c6:	6105                	addi	sp,sp,32
    800021c8:	8082                	ret

00000000800021ca <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021ca:	7179                	addi	sp,sp,-48
    800021cc:	f406                	sd	ra,40(sp)
    800021ce:	f022                	sd	s0,32(sp)
    800021d0:	ec26                	sd	s1,24(sp)
    800021d2:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021d4:	fdc40593          	addi	a1,s0,-36
    800021d8:	4501                	li	a0,0
    800021da:	00000097          	auipc	ra,0x0
    800021de:	e46080e7          	jalr	-442(ra) # 80002020 <argint>
  addr = myproc()->sz;
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	cee080e7          	jalr	-786(ra) # 80000ed0 <myproc>
    800021ea:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021ec:	fdc42503          	lw	a0,-36(s0)
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	03e080e7          	jalr	62(ra) # 8000122e <growproc>
    800021f8:	00054863          	bltz	a0,80002208 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021fc:	8526                	mv	a0,s1
    800021fe:	70a2                	ld	ra,40(sp)
    80002200:	7402                	ld	s0,32(sp)
    80002202:	64e2                	ld	s1,24(sp)
    80002204:	6145                	addi	sp,sp,48
    80002206:	8082                	ret
    return -1;
    80002208:	54fd                	li	s1,-1
    8000220a:	bfcd                	j	800021fc <sys_sbrk+0x32>

000000008000220c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000220c:	7139                	addi	sp,sp,-64
    8000220e:	fc06                	sd	ra,56(sp)
    80002210:	f822                	sd	s0,48(sp)
    80002212:	f426                	sd	s1,40(sp)
    80002214:	f04a                	sd	s2,32(sp)
    80002216:	ec4e                	sd	s3,24(sp)
    80002218:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000221a:	fcc40593          	addi	a1,s0,-52
    8000221e:	4501                	li	a0,0
    80002220:	00000097          	auipc	ra,0x0
    80002224:	e00080e7          	jalr	-512(ra) # 80002020 <argint>
  if(n < 0)
    80002228:	fcc42783          	lw	a5,-52(s0)
    8000222c:	0607cf63          	bltz	a5,800022aa <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002230:	0000d517          	auipc	a0,0xd
    80002234:	8a050513          	addi	a0,a0,-1888 # 8000ead0 <tickslock>
    80002238:	00004097          	auipc	ra,0x4
    8000223c:	012080e7          	jalr	18(ra) # 8000624a <acquire>
  ticks0 = ticks;
    80002240:	00007917          	auipc	s2,0x7
    80002244:	82892903          	lw	s2,-2008(s2) # 80008a68 <ticks>
  while(ticks - ticks0 < n){
    80002248:	fcc42783          	lw	a5,-52(s0)
    8000224c:	cf9d                	beqz	a5,8000228a <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000224e:	0000d997          	auipc	s3,0xd
    80002252:	88298993          	addi	s3,s3,-1918 # 8000ead0 <tickslock>
    80002256:	00007497          	auipc	s1,0x7
    8000225a:	81248493          	addi	s1,s1,-2030 # 80008a68 <ticks>
    if(killed(myproc())){
    8000225e:	fffff097          	auipc	ra,0xfffff
    80002262:	c72080e7          	jalr	-910(ra) # 80000ed0 <myproc>
    80002266:	fffff097          	auipc	ra,0xfffff
    8000226a:	5c6080e7          	jalr	1478(ra) # 8000182c <killed>
    8000226e:	e129                	bnez	a0,800022b0 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002270:	85ce                	mv	a1,s3
    80002272:	8526                	mv	a0,s1
    80002274:	fffff097          	auipc	ra,0xfffff
    80002278:	310080e7          	jalr	784(ra) # 80001584 <sleep>
  while(ticks - ticks0 < n){
    8000227c:	409c                	lw	a5,0(s1)
    8000227e:	412787bb          	subw	a5,a5,s2
    80002282:	fcc42703          	lw	a4,-52(s0)
    80002286:	fce7ece3          	bltu	a5,a4,8000225e <sys_sleep+0x52>
  }
  release(&tickslock);
    8000228a:	0000d517          	auipc	a0,0xd
    8000228e:	84650513          	addi	a0,a0,-1978 # 8000ead0 <tickslock>
    80002292:	00004097          	auipc	ra,0x4
    80002296:	06c080e7          	jalr	108(ra) # 800062fe <release>
  return 0;
    8000229a:	4501                	li	a0,0
}
    8000229c:	70e2                	ld	ra,56(sp)
    8000229e:	7442                	ld	s0,48(sp)
    800022a0:	74a2                	ld	s1,40(sp)
    800022a2:	7902                	ld	s2,32(sp)
    800022a4:	69e2                	ld	s3,24(sp)
    800022a6:	6121                	addi	sp,sp,64
    800022a8:	8082                	ret
    n = 0;
    800022aa:	fc042623          	sw	zero,-52(s0)
    800022ae:	b749                	j	80002230 <sys_sleep+0x24>
      release(&tickslock);
    800022b0:	0000d517          	auipc	a0,0xd
    800022b4:	82050513          	addi	a0,a0,-2016 # 8000ead0 <tickslock>
    800022b8:	00004097          	auipc	ra,0x4
    800022bc:	046080e7          	jalr	70(ra) # 800062fe <release>
      return -1;
    800022c0:	557d                	li	a0,-1
    800022c2:	bfe9                	j	8000229c <sys_sleep+0x90>

00000000800022c4 <sys_kill>:

uint64
sys_kill(void)
{
    800022c4:	1101                	addi	sp,sp,-32
    800022c6:	ec06                	sd	ra,24(sp)
    800022c8:	e822                	sd	s0,16(sp)
    800022ca:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022cc:	fec40593          	addi	a1,s0,-20
    800022d0:	4501                	li	a0,0
    800022d2:	00000097          	auipc	ra,0x0
    800022d6:	d4e080e7          	jalr	-690(ra) # 80002020 <argint>
  return kill(pid);
    800022da:	fec42503          	lw	a0,-20(s0)
    800022de:	fffff097          	auipc	ra,0xfffff
    800022e2:	4b0080e7          	jalr	1200(ra) # 8000178e <kill>
}
    800022e6:	60e2                	ld	ra,24(sp)
    800022e8:	6442                	ld	s0,16(sp)
    800022ea:	6105                	addi	sp,sp,32
    800022ec:	8082                	ret

00000000800022ee <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022ee:	1101                	addi	sp,sp,-32
    800022f0:	ec06                	sd	ra,24(sp)
    800022f2:	e822                	sd	s0,16(sp)
    800022f4:	e426                	sd	s1,8(sp)
    800022f6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022f8:	0000c517          	auipc	a0,0xc
    800022fc:	7d850513          	addi	a0,a0,2008 # 8000ead0 <tickslock>
    80002300:	00004097          	auipc	ra,0x4
    80002304:	f4a080e7          	jalr	-182(ra) # 8000624a <acquire>
  xticks = ticks;
    80002308:	00006497          	auipc	s1,0x6
    8000230c:	7604a483          	lw	s1,1888(s1) # 80008a68 <ticks>
  release(&tickslock);
    80002310:	0000c517          	auipc	a0,0xc
    80002314:	7c050513          	addi	a0,a0,1984 # 8000ead0 <tickslock>
    80002318:	00004097          	auipc	ra,0x4
    8000231c:	fe6080e7          	jalr	-26(ra) # 800062fe <release>
  return xticks;
}
    80002320:	02049513          	slli	a0,s1,0x20
    80002324:	9101                	srli	a0,a0,0x20
    80002326:	60e2                	ld	ra,24(sp)
    80002328:	6442                	ld	s0,16(sp)
    8000232a:	64a2                	ld	s1,8(sp)
    8000232c:	6105                	addi	sp,sp,32
    8000232e:	8082                	ret

0000000080002330 <sys_trace>:

uint64
sys_trace(void)
{
    80002330:	1101                	addi	sp,sp,-32
    80002332:	ec06                	sd	ra,24(sp)
    80002334:	e822                	sd	s0,16(sp)
    80002336:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);
    80002338:	fec40593          	addi	a1,s0,-20
    8000233c:	4501                	li	a0,0
    8000233e:	00000097          	auipc	ra,0x0
    80002342:	ce2080e7          	jalr	-798(ra) # 80002020 <argint>
  if(mask < 0)
    80002346:	fec42783          	lw	a5,-20(s0)
    return -1;
    8000234a:	557d                	li	a0,-1
  if(mask < 0)
    8000234c:	0007cb63          	bltz	a5,80002362 <sys_trace+0x32>
  myproc()->mask = mask;
    80002350:	fffff097          	auipc	ra,0xfffff
    80002354:	b80080e7          	jalr	-1152(ra) # 80000ed0 <myproc>
    80002358:	fec42783          	lw	a5,-20(s0)
    8000235c:	16f52423          	sw	a5,360(a0)
  return 0;  
    80002360:	4501                	li	a0,0
}
    80002362:	60e2                	ld	ra,24(sp)
    80002364:	6442                	ld	s0,16(sp)
    80002366:	6105                	addi	sp,sp,32
    80002368:	8082                	ret

000000008000236a <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    8000236a:	7179                	addi	sp,sp,-48
    8000236c:	f406                	sd	ra,40(sp)
    8000236e:	f022                	sd	s0,32(sp)
    80002370:	1800                	addi	s0,sp,48
  struct sysinfo info;
  info.freemem = kfreemem();
    80002372:	ffffe097          	auipc	ra,0xffffe
    80002376:	e06080e7          	jalr	-506(ra) # 80000178 <kfreemem>
    8000237a:	fea43023          	sd	a0,-32(s0)
  info.nproc = kprocnum();
    8000237e:	fffff097          	auipc	ra,0xfffff
    80002382:	768080e7          	jalr	1896(ra) # 80001ae6 <kprocnum>
    80002386:	fea43423          	sd	a0,-24(s0)
  
  uint64 addr;
  argaddr(0, &addr);
    8000238a:	fd840593          	addi	a1,s0,-40
    8000238e:	4501                	li	a0,0
    80002390:	00000097          	auipc	ra,0x0
    80002394:	cb0080e7          	jalr	-848(ra) # 80002040 <argaddr>
  
  if(copyout(myproc()->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    80002398:	fffff097          	auipc	ra,0xfffff
    8000239c:	b38080e7          	jalr	-1224(ra) # 80000ed0 <myproc>
    800023a0:	46c1                	li	a3,16
    800023a2:	fe040613          	addi	a2,s0,-32
    800023a6:	fd843583          	ld	a1,-40(s0)
    800023aa:	6928                	ld	a0,80(a0)
    800023ac:	ffffe097          	auipc	ra,0xffffe
    800023b0:	7ac080e7          	jalr	1964(ra) # 80000b58 <copyout>
    return -1;

  return 0;


}
    800023b4:	957d                	srai	a0,a0,0x3f
    800023b6:	70a2                	ld	ra,40(sp)
    800023b8:	7402                	ld	s0,32(sp)
    800023ba:	6145                	addi	sp,sp,48
    800023bc:	8082                	ret

00000000800023be <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023be:	7179                	addi	sp,sp,-48
    800023c0:	f406                	sd	ra,40(sp)
    800023c2:	f022                	sd	s0,32(sp)
    800023c4:	ec26                	sd	s1,24(sp)
    800023c6:	e84a                	sd	s2,16(sp)
    800023c8:	e44e                	sd	s3,8(sp)
    800023ca:	e052                	sd	s4,0(sp)
    800023cc:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023ce:	00006597          	auipc	a1,0x6
    800023d2:	1ca58593          	addi	a1,a1,458 # 80008598 <syscalls+0xc0>
    800023d6:	0000c517          	auipc	a0,0xc
    800023da:	71250513          	addi	a0,a0,1810 # 8000eae8 <bcache>
    800023de:	00004097          	auipc	ra,0x4
    800023e2:	ddc080e7          	jalr	-548(ra) # 800061ba <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023e6:	00014797          	auipc	a5,0x14
    800023ea:	70278793          	addi	a5,a5,1794 # 80016ae8 <bcache+0x8000>
    800023ee:	00015717          	auipc	a4,0x15
    800023f2:	96270713          	addi	a4,a4,-1694 # 80016d50 <bcache+0x8268>
    800023f6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023fa:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023fe:	0000c497          	auipc	s1,0xc
    80002402:	70248493          	addi	s1,s1,1794 # 8000eb00 <bcache+0x18>
    b->next = bcache.head.next;
    80002406:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002408:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000240a:	00006a17          	auipc	s4,0x6
    8000240e:	196a0a13          	addi	s4,s4,406 # 800085a0 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002412:	2b893783          	ld	a5,696(s2)
    80002416:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002418:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000241c:	85d2                	mv	a1,s4
    8000241e:	01048513          	addi	a0,s1,16
    80002422:	00001097          	auipc	ra,0x1
    80002426:	4c4080e7          	jalr	1220(ra) # 800038e6 <initsleeplock>
    bcache.head.next->prev = b;
    8000242a:	2b893783          	ld	a5,696(s2)
    8000242e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002430:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002434:	45848493          	addi	s1,s1,1112
    80002438:	fd349de3          	bne	s1,s3,80002412 <binit+0x54>
  }
}
    8000243c:	70a2                	ld	ra,40(sp)
    8000243e:	7402                	ld	s0,32(sp)
    80002440:	64e2                	ld	s1,24(sp)
    80002442:	6942                	ld	s2,16(sp)
    80002444:	69a2                	ld	s3,8(sp)
    80002446:	6a02                	ld	s4,0(sp)
    80002448:	6145                	addi	sp,sp,48
    8000244a:	8082                	ret

000000008000244c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000244c:	7179                	addi	sp,sp,-48
    8000244e:	f406                	sd	ra,40(sp)
    80002450:	f022                	sd	s0,32(sp)
    80002452:	ec26                	sd	s1,24(sp)
    80002454:	e84a                	sd	s2,16(sp)
    80002456:	e44e                	sd	s3,8(sp)
    80002458:	1800                	addi	s0,sp,48
    8000245a:	892a                	mv	s2,a0
    8000245c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000245e:	0000c517          	auipc	a0,0xc
    80002462:	68a50513          	addi	a0,a0,1674 # 8000eae8 <bcache>
    80002466:	00004097          	auipc	ra,0x4
    8000246a:	de4080e7          	jalr	-540(ra) # 8000624a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000246e:	00015497          	auipc	s1,0x15
    80002472:	9324b483          	ld	s1,-1742(s1) # 80016da0 <bcache+0x82b8>
    80002476:	00015797          	auipc	a5,0x15
    8000247a:	8da78793          	addi	a5,a5,-1830 # 80016d50 <bcache+0x8268>
    8000247e:	02f48f63          	beq	s1,a5,800024bc <bread+0x70>
    80002482:	873e                	mv	a4,a5
    80002484:	a021                	j	8000248c <bread+0x40>
    80002486:	68a4                	ld	s1,80(s1)
    80002488:	02e48a63          	beq	s1,a4,800024bc <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000248c:	449c                	lw	a5,8(s1)
    8000248e:	ff279ce3          	bne	a5,s2,80002486 <bread+0x3a>
    80002492:	44dc                	lw	a5,12(s1)
    80002494:	ff3799e3          	bne	a5,s3,80002486 <bread+0x3a>
      b->refcnt++;
    80002498:	40bc                	lw	a5,64(s1)
    8000249a:	2785                	addiw	a5,a5,1
    8000249c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000249e:	0000c517          	auipc	a0,0xc
    800024a2:	64a50513          	addi	a0,a0,1610 # 8000eae8 <bcache>
    800024a6:	00004097          	auipc	ra,0x4
    800024aa:	e58080e7          	jalr	-424(ra) # 800062fe <release>
      acquiresleep(&b->lock);
    800024ae:	01048513          	addi	a0,s1,16
    800024b2:	00001097          	auipc	ra,0x1
    800024b6:	46e080e7          	jalr	1134(ra) # 80003920 <acquiresleep>
      return b;
    800024ba:	a8b9                	j	80002518 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024bc:	00015497          	auipc	s1,0x15
    800024c0:	8dc4b483          	ld	s1,-1828(s1) # 80016d98 <bcache+0x82b0>
    800024c4:	00015797          	auipc	a5,0x15
    800024c8:	88c78793          	addi	a5,a5,-1908 # 80016d50 <bcache+0x8268>
    800024cc:	00f48863          	beq	s1,a5,800024dc <bread+0x90>
    800024d0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024d2:	40bc                	lw	a5,64(s1)
    800024d4:	cf81                	beqz	a5,800024ec <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024d6:	64a4                	ld	s1,72(s1)
    800024d8:	fee49de3          	bne	s1,a4,800024d2 <bread+0x86>
  panic("bget: no buffers");
    800024dc:	00006517          	auipc	a0,0x6
    800024e0:	0cc50513          	addi	a0,a0,204 # 800085a8 <syscalls+0xd0>
    800024e4:	00004097          	auipc	ra,0x4
    800024e8:	82a080e7          	jalr	-2006(ra) # 80005d0e <panic>
      b->dev = dev;
    800024ec:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024f0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024f4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024f8:	4785                	li	a5,1
    800024fa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024fc:	0000c517          	auipc	a0,0xc
    80002500:	5ec50513          	addi	a0,a0,1516 # 8000eae8 <bcache>
    80002504:	00004097          	auipc	ra,0x4
    80002508:	dfa080e7          	jalr	-518(ra) # 800062fe <release>
      acquiresleep(&b->lock);
    8000250c:	01048513          	addi	a0,s1,16
    80002510:	00001097          	auipc	ra,0x1
    80002514:	410080e7          	jalr	1040(ra) # 80003920 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002518:	409c                	lw	a5,0(s1)
    8000251a:	cb89                	beqz	a5,8000252c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000251c:	8526                	mv	a0,s1
    8000251e:	70a2                	ld	ra,40(sp)
    80002520:	7402                	ld	s0,32(sp)
    80002522:	64e2                	ld	s1,24(sp)
    80002524:	6942                	ld	s2,16(sp)
    80002526:	69a2                	ld	s3,8(sp)
    80002528:	6145                	addi	sp,sp,48
    8000252a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000252c:	4581                	li	a1,0
    8000252e:	8526                	mv	a0,s1
    80002530:	00003097          	auipc	ra,0x3
    80002534:	fd4080e7          	jalr	-44(ra) # 80005504 <virtio_disk_rw>
    b->valid = 1;
    80002538:	4785                	li	a5,1
    8000253a:	c09c                	sw	a5,0(s1)
  return b;
    8000253c:	b7c5                	j	8000251c <bread+0xd0>

000000008000253e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000253e:	1101                	addi	sp,sp,-32
    80002540:	ec06                	sd	ra,24(sp)
    80002542:	e822                	sd	s0,16(sp)
    80002544:	e426                	sd	s1,8(sp)
    80002546:	1000                	addi	s0,sp,32
    80002548:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000254a:	0541                	addi	a0,a0,16
    8000254c:	00001097          	auipc	ra,0x1
    80002550:	46e080e7          	jalr	1134(ra) # 800039ba <holdingsleep>
    80002554:	cd01                	beqz	a0,8000256c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002556:	4585                	li	a1,1
    80002558:	8526                	mv	a0,s1
    8000255a:	00003097          	auipc	ra,0x3
    8000255e:	faa080e7          	jalr	-86(ra) # 80005504 <virtio_disk_rw>
}
    80002562:	60e2                	ld	ra,24(sp)
    80002564:	6442                	ld	s0,16(sp)
    80002566:	64a2                	ld	s1,8(sp)
    80002568:	6105                	addi	sp,sp,32
    8000256a:	8082                	ret
    panic("bwrite");
    8000256c:	00006517          	auipc	a0,0x6
    80002570:	05450513          	addi	a0,a0,84 # 800085c0 <syscalls+0xe8>
    80002574:	00003097          	auipc	ra,0x3
    80002578:	79a080e7          	jalr	1946(ra) # 80005d0e <panic>

000000008000257c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000257c:	1101                	addi	sp,sp,-32
    8000257e:	ec06                	sd	ra,24(sp)
    80002580:	e822                	sd	s0,16(sp)
    80002582:	e426                	sd	s1,8(sp)
    80002584:	e04a                	sd	s2,0(sp)
    80002586:	1000                	addi	s0,sp,32
    80002588:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000258a:	01050913          	addi	s2,a0,16
    8000258e:	854a                	mv	a0,s2
    80002590:	00001097          	auipc	ra,0x1
    80002594:	42a080e7          	jalr	1066(ra) # 800039ba <holdingsleep>
    80002598:	c92d                	beqz	a0,8000260a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000259a:	854a                	mv	a0,s2
    8000259c:	00001097          	auipc	ra,0x1
    800025a0:	3da080e7          	jalr	986(ra) # 80003976 <releasesleep>

  acquire(&bcache.lock);
    800025a4:	0000c517          	auipc	a0,0xc
    800025a8:	54450513          	addi	a0,a0,1348 # 8000eae8 <bcache>
    800025ac:	00004097          	auipc	ra,0x4
    800025b0:	c9e080e7          	jalr	-866(ra) # 8000624a <acquire>
  b->refcnt--;
    800025b4:	40bc                	lw	a5,64(s1)
    800025b6:	37fd                	addiw	a5,a5,-1
    800025b8:	0007871b          	sext.w	a4,a5
    800025bc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025be:	eb05                	bnez	a4,800025ee <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025c0:	68bc                	ld	a5,80(s1)
    800025c2:	64b8                	ld	a4,72(s1)
    800025c4:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025c6:	64bc                	ld	a5,72(s1)
    800025c8:	68b8                	ld	a4,80(s1)
    800025ca:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025cc:	00014797          	auipc	a5,0x14
    800025d0:	51c78793          	addi	a5,a5,1308 # 80016ae8 <bcache+0x8000>
    800025d4:	2b87b703          	ld	a4,696(a5)
    800025d8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025da:	00014717          	auipc	a4,0x14
    800025de:	77670713          	addi	a4,a4,1910 # 80016d50 <bcache+0x8268>
    800025e2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025e4:	2b87b703          	ld	a4,696(a5)
    800025e8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025ea:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025ee:	0000c517          	auipc	a0,0xc
    800025f2:	4fa50513          	addi	a0,a0,1274 # 8000eae8 <bcache>
    800025f6:	00004097          	auipc	ra,0x4
    800025fa:	d08080e7          	jalr	-760(ra) # 800062fe <release>
}
    800025fe:	60e2                	ld	ra,24(sp)
    80002600:	6442                	ld	s0,16(sp)
    80002602:	64a2                	ld	s1,8(sp)
    80002604:	6902                	ld	s2,0(sp)
    80002606:	6105                	addi	sp,sp,32
    80002608:	8082                	ret
    panic("brelse");
    8000260a:	00006517          	auipc	a0,0x6
    8000260e:	fbe50513          	addi	a0,a0,-66 # 800085c8 <syscalls+0xf0>
    80002612:	00003097          	auipc	ra,0x3
    80002616:	6fc080e7          	jalr	1788(ra) # 80005d0e <panic>

000000008000261a <bpin>:

void
bpin(struct buf *b) {
    8000261a:	1101                	addi	sp,sp,-32
    8000261c:	ec06                	sd	ra,24(sp)
    8000261e:	e822                	sd	s0,16(sp)
    80002620:	e426                	sd	s1,8(sp)
    80002622:	1000                	addi	s0,sp,32
    80002624:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002626:	0000c517          	auipc	a0,0xc
    8000262a:	4c250513          	addi	a0,a0,1218 # 8000eae8 <bcache>
    8000262e:	00004097          	auipc	ra,0x4
    80002632:	c1c080e7          	jalr	-996(ra) # 8000624a <acquire>
  b->refcnt++;
    80002636:	40bc                	lw	a5,64(s1)
    80002638:	2785                	addiw	a5,a5,1
    8000263a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000263c:	0000c517          	auipc	a0,0xc
    80002640:	4ac50513          	addi	a0,a0,1196 # 8000eae8 <bcache>
    80002644:	00004097          	auipc	ra,0x4
    80002648:	cba080e7          	jalr	-838(ra) # 800062fe <release>
}
    8000264c:	60e2                	ld	ra,24(sp)
    8000264e:	6442                	ld	s0,16(sp)
    80002650:	64a2                	ld	s1,8(sp)
    80002652:	6105                	addi	sp,sp,32
    80002654:	8082                	ret

0000000080002656 <bunpin>:

void
bunpin(struct buf *b) {
    80002656:	1101                	addi	sp,sp,-32
    80002658:	ec06                	sd	ra,24(sp)
    8000265a:	e822                	sd	s0,16(sp)
    8000265c:	e426                	sd	s1,8(sp)
    8000265e:	1000                	addi	s0,sp,32
    80002660:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002662:	0000c517          	auipc	a0,0xc
    80002666:	48650513          	addi	a0,a0,1158 # 8000eae8 <bcache>
    8000266a:	00004097          	auipc	ra,0x4
    8000266e:	be0080e7          	jalr	-1056(ra) # 8000624a <acquire>
  b->refcnt--;
    80002672:	40bc                	lw	a5,64(s1)
    80002674:	37fd                	addiw	a5,a5,-1
    80002676:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002678:	0000c517          	auipc	a0,0xc
    8000267c:	47050513          	addi	a0,a0,1136 # 8000eae8 <bcache>
    80002680:	00004097          	auipc	ra,0x4
    80002684:	c7e080e7          	jalr	-898(ra) # 800062fe <release>
}
    80002688:	60e2                	ld	ra,24(sp)
    8000268a:	6442                	ld	s0,16(sp)
    8000268c:	64a2                	ld	s1,8(sp)
    8000268e:	6105                	addi	sp,sp,32
    80002690:	8082                	ret

0000000080002692 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002692:	1101                	addi	sp,sp,-32
    80002694:	ec06                	sd	ra,24(sp)
    80002696:	e822                	sd	s0,16(sp)
    80002698:	e426                	sd	s1,8(sp)
    8000269a:	e04a                	sd	s2,0(sp)
    8000269c:	1000                	addi	s0,sp,32
    8000269e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026a0:	00d5d59b          	srliw	a1,a1,0xd
    800026a4:	00015797          	auipc	a5,0x15
    800026a8:	b207a783          	lw	a5,-1248(a5) # 800171c4 <sb+0x1c>
    800026ac:	9dbd                	addw	a1,a1,a5
    800026ae:	00000097          	auipc	ra,0x0
    800026b2:	d9e080e7          	jalr	-610(ra) # 8000244c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026b6:	0074f713          	andi	a4,s1,7
    800026ba:	4785                	li	a5,1
    800026bc:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026c0:	14ce                	slli	s1,s1,0x33
    800026c2:	90d9                	srli	s1,s1,0x36
    800026c4:	00950733          	add	a4,a0,s1
    800026c8:	05874703          	lbu	a4,88(a4)
    800026cc:	00e7f6b3          	and	a3,a5,a4
    800026d0:	c69d                	beqz	a3,800026fe <bfree+0x6c>
    800026d2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026d4:	94aa                	add	s1,s1,a0
    800026d6:	fff7c793          	not	a5,a5
    800026da:	8ff9                	and	a5,a5,a4
    800026dc:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800026e0:	00001097          	auipc	ra,0x1
    800026e4:	120080e7          	jalr	288(ra) # 80003800 <log_write>
  brelse(bp);
    800026e8:	854a                	mv	a0,s2
    800026ea:	00000097          	auipc	ra,0x0
    800026ee:	e92080e7          	jalr	-366(ra) # 8000257c <brelse>
}
    800026f2:	60e2                	ld	ra,24(sp)
    800026f4:	6442                	ld	s0,16(sp)
    800026f6:	64a2                	ld	s1,8(sp)
    800026f8:	6902                	ld	s2,0(sp)
    800026fa:	6105                	addi	sp,sp,32
    800026fc:	8082                	ret
    panic("freeing free block");
    800026fe:	00006517          	auipc	a0,0x6
    80002702:	ed250513          	addi	a0,a0,-302 # 800085d0 <syscalls+0xf8>
    80002706:	00003097          	auipc	ra,0x3
    8000270a:	608080e7          	jalr	1544(ra) # 80005d0e <panic>

000000008000270e <balloc>:
{
    8000270e:	711d                	addi	sp,sp,-96
    80002710:	ec86                	sd	ra,88(sp)
    80002712:	e8a2                	sd	s0,80(sp)
    80002714:	e4a6                	sd	s1,72(sp)
    80002716:	e0ca                	sd	s2,64(sp)
    80002718:	fc4e                	sd	s3,56(sp)
    8000271a:	f852                	sd	s4,48(sp)
    8000271c:	f456                	sd	s5,40(sp)
    8000271e:	f05a                	sd	s6,32(sp)
    80002720:	ec5e                	sd	s7,24(sp)
    80002722:	e862                	sd	s8,16(sp)
    80002724:	e466                	sd	s9,8(sp)
    80002726:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002728:	00015797          	auipc	a5,0x15
    8000272c:	a847a783          	lw	a5,-1404(a5) # 800171ac <sb+0x4>
    80002730:	10078163          	beqz	a5,80002832 <balloc+0x124>
    80002734:	8baa                	mv	s7,a0
    80002736:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002738:	00015b17          	auipc	s6,0x15
    8000273c:	a70b0b13          	addi	s6,s6,-1424 # 800171a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002740:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002742:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002744:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002746:	6c89                	lui	s9,0x2
    80002748:	a061                	j	800027d0 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000274a:	974a                	add	a4,a4,s2
    8000274c:	8fd5                	or	a5,a5,a3
    8000274e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002752:	854a                	mv	a0,s2
    80002754:	00001097          	auipc	ra,0x1
    80002758:	0ac080e7          	jalr	172(ra) # 80003800 <log_write>
        brelse(bp);
    8000275c:	854a                	mv	a0,s2
    8000275e:	00000097          	auipc	ra,0x0
    80002762:	e1e080e7          	jalr	-482(ra) # 8000257c <brelse>
  bp = bread(dev, bno);
    80002766:	85a6                	mv	a1,s1
    80002768:	855e                	mv	a0,s7
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	ce2080e7          	jalr	-798(ra) # 8000244c <bread>
    80002772:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002774:	40000613          	li	a2,1024
    80002778:	4581                	li	a1,0
    8000277a:	05850513          	addi	a0,a0,88
    8000277e:	ffffe097          	auipc	ra,0xffffe
    80002782:	a20080e7          	jalr	-1504(ra) # 8000019e <memset>
  log_write(bp);
    80002786:	854a                	mv	a0,s2
    80002788:	00001097          	auipc	ra,0x1
    8000278c:	078080e7          	jalr	120(ra) # 80003800 <log_write>
  brelse(bp);
    80002790:	854a                	mv	a0,s2
    80002792:	00000097          	auipc	ra,0x0
    80002796:	dea080e7          	jalr	-534(ra) # 8000257c <brelse>
}
    8000279a:	8526                	mv	a0,s1
    8000279c:	60e6                	ld	ra,88(sp)
    8000279e:	6446                	ld	s0,80(sp)
    800027a0:	64a6                	ld	s1,72(sp)
    800027a2:	6906                	ld	s2,64(sp)
    800027a4:	79e2                	ld	s3,56(sp)
    800027a6:	7a42                	ld	s4,48(sp)
    800027a8:	7aa2                	ld	s5,40(sp)
    800027aa:	7b02                	ld	s6,32(sp)
    800027ac:	6be2                	ld	s7,24(sp)
    800027ae:	6c42                	ld	s8,16(sp)
    800027b0:	6ca2                	ld	s9,8(sp)
    800027b2:	6125                	addi	sp,sp,96
    800027b4:	8082                	ret
    brelse(bp);
    800027b6:	854a                	mv	a0,s2
    800027b8:	00000097          	auipc	ra,0x0
    800027bc:	dc4080e7          	jalr	-572(ra) # 8000257c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027c0:	015c87bb          	addw	a5,s9,s5
    800027c4:	00078a9b          	sext.w	s5,a5
    800027c8:	004b2703          	lw	a4,4(s6)
    800027cc:	06eaf363          	bgeu	s5,a4,80002832 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800027d0:	41fad79b          	sraiw	a5,s5,0x1f
    800027d4:	0137d79b          	srliw	a5,a5,0x13
    800027d8:	015787bb          	addw	a5,a5,s5
    800027dc:	40d7d79b          	sraiw	a5,a5,0xd
    800027e0:	01cb2583          	lw	a1,28(s6)
    800027e4:	9dbd                	addw	a1,a1,a5
    800027e6:	855e                	mv	a0,s7
    800027e8:	00000097          	auipc	ra,0x0
    800027ec:	c64080e7          	jalr	-924(ra) # 8000244c <bread>
    800027f0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027f2:	004b2503          	lw	a0,4(s6)
    800027f6:	000a849b          	sext.w	s1,s5
    800027fa:	8662                	mv	a2,s8
    800027fc:	faa4fde3          	bgeu	s1,a0,800027b6 <balloc+0xa8>
      m = 1 << (bi % 8);
    80002800:	41f6579b          	sraiw	a5,a2,0x1f
    80002804:	01d7d69b          	srliw	a3,a5,0x1d
    80002808:	00c6873b          	addw	a4,a3,a2
    8000280c:	00777793          	andi	a5,a4,7
    80002810:	9f95                	subw	a5,a5,a3
    80002812:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002816:	4037571b          	sraiw	a4,a4,0x3
    8000281a:	00e906b3          	add	a3,s2,a4
    8000281e:	0586c683          	lbu	a3,88(a3)
    80002822:	00d7f5b3          	and	a1,a5,a3
    80002826:	d195                	beqz	a1,8000274a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002828:	2605                	addiw	a2,a2,1
    8000282a:	2485                	addiw	s1,s1,1
    8000282c:	fd4618e3          	bne	a2,s4,800027fc <balloc+0xee>
    80002830:	b759                	j	800027b6 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002832:	00006517          	auipc	a0,0x6
    80002836:	db650513          	addi	a0,a0,-586 # 800085e8 <syscalls+0x110>
    8000283a:	00003097          	auipc	ra,0x3
    8000283e:	51e080e7          	jalr	1310(ra) # 80005d58 <printf>
  return 0;
    80002842:	4481                	li	s1,0
    80002844:	bf99                	j	8000279a <balloc+0x8c>

0000000080002846 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002846:	7179                	addi	sp,sp,-48
    80002848:	f406                	sd	ra,40(sp)
    8000284a:	f022                	sd	s0,32(sp)
    8000284c:	ec26                	sd	s1,24(sp)
    8000284e:	e84a                	sd	s2,16(sp)
    80002850:	e44e                	sd	s3,8(sp)
    80002852:	e052                	sd	s4,0(sp)
    80002854:	1800                	addi	s0,sp,48
    80002856:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002858:	47ad                	li	a5,11
    8000285a:	02b7e763          	bltu	a5,a1,80002888 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    8000285e:	02059493          	slli	s1,a1,0x20
    80002862:	9081                	srli	s1,s1,0x20
    80002864:	048a                	slli	s1,s1,0x2
    80002866:	94aa                	add	s1,s1,a0
    80002868:	0504a903          	lw	s2,80(s1)
    8000286c:	06091e63          	bnez	s2,800028e8 <bmap+0xa2>
      addr = balloc(ip->dev);
    80002870:	4108                	lw	a0,0(a0)
    80002872:	00000097          	auipc	ra,0x0
    80002876:	e9c080e7          	jalr	-356(ra) # 8000270e <balloc>
    8000287a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000287e:	06090563          	beqz	s2,800028e8 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002882:	0524a823          	sw	s2,80(s1)
    80002886:	a08d                	j	800028e8 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002888:	ff45849b          	addiw	s1,a1,-12
    8000288c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002890:	0ff00793          	li	a5,255
    80002894:	08e7e563          	bltu	a5,a4,8000291e <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002898:	08052903          	lw	s2,128(a0)
    8000289c:	00091d63          	bnez	s2,800028b6 <bmap+0x70>
      addr = balloc(ip->dev);
    800028a0:	4108                	lw	a0,0(a0)
    800028a2:	00000097          	auipc	ra,0x0
    800028a6:	e6c080e7          	jalr	-404(ra) # 8000270e <balloc>
    800028aa:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028ae:	02090d63          	beqz	s2,800028e8 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800028b2:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800028b6:	85ca                	mv	a1,s2
    800028b8:	0009a503          	lw	a0,0(s3)
    800028bc:	00000097          	auipc	ra,0x0
    800028c0:	b90080e7          	jalr	-1136(ra) # 8000244c <bread>
    800028c4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028c6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028ca:	02049593          	slli	a1,s1,0x20
    800028ce:	9181                	srli	a1,a1,0x20
    800028d0:	058a                	slli	a1,a1,0x2
    800028d2:	00b784b3          	add	s1,a5,a1
    800028d6:	0004a903          	lw	s2,0(s1)
    800028da:	02090063          	beqz	s2,800028fa <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028de:	8552                	mv	a0,s4
    800028e0:	00000097          	auipc	ra,0x0
    800028e4:	c9c080e7          	jalr	-868(ra) # 8000257c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028e8:	854a                	mv	a0,s2
    800028ea:	70a2                	ld	ra,40(sp)
    800028ec:	7402                	ld	s0,32(sp)
    800028ee:	64e2                	ld	s1,24(sp)
    800028f0:	6942                	ld	s2,16(sp)
    800028f2:	69a2                	ld	s3,8(sp)
    800028f4:	6a02                	ld	s4,0(sp)
    800028f6:	6145                	addi	sp,sp,48
    800028f8:	8082                	ret
      addr = balloc(ip->dev);
    800028fa:	0009a503          	lw	a0,0(s3)
    800028fe:	00000097          	auipc	ra,0x0
    80002902:	e10080e7          	jalr	-496(ra) # 8000270e <balloc>
    80002906:	0005091b          	sext.w	s2,a0
      if(addr){
    8000290a:	fc090ae3          	beqz	s2,800028de <bmap+0x98>
        a[bn] = addr;
    8000290e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002912:	8552                	mv	a0,s4
    80002914:	00001097          	auipc	ra,0x1
    80002918:	eec080e7          	jalr	-276(ra) # 80003800 <log_write>
    8000291c:	b7c9                	j	800028de <bmap+0x98>
  panic("bmap: out of range");
    8000291e:	00006517          	auipc	a0,0x6
    80002922:	ce250513          	addi	a0,a0,-798 # 80008600 <syscalls+0x128>
    80002926:	00003097          	auipc	ra,0x3
    8000292a:	3e8080e7          	jalr	1000(ra) # 80005d0e <panic>

000000008000292e <iget>:
{
    8000292e:	7179                	addi	sp,sp,-48
    80002930:	f406                	sd	ra,40(sp)
    80002932:	f022                	sd	s0,32(sp)
    80002934:	ec26                	sd	s1,24(sp)
    80002936:	e84a                	sd	s2,16(sp)
    80002938:	e44e                	sd	s3,8(sp)
    8000293a:	e052                	sd	s4,0(sp)
    8000293c:	1800                	addi	s0,sp,48
    8000293e:	89aa                	mv	s3,a0
    80002940:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002942:	00015517          	auipc	a0,0x15
    80002946:	88650513          	addi	a0,a0,-1914 # 800171c8 <itable>
    8000294a:	00004097          	auipc	ra,0x4
    8000294e:	900080e7          	jalr	-1792(ra) # 8000624a <acquire>
  empty = 0;
    80002952:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002954:	00015497          	auipc	s1,0x15
    80002958:	88c48493          	addi	s1,s1,-1908 # 800171e0 <itable+0x18>
    8000295c:	00016697          	auipc	a3,0x16
    80002960:	31468693          	addi	a3,a3,788 # 80018c70 <log>
    80002964:	a039                	j	80002972 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002966:	02090b63          	beqz	s2,8000299c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000296a:	08848493          	addi	s1,s1,136
    8000296e:	02d48a63          	beq	s1,a3,800029a2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002972:	449c                	lw	a5,8(s1)
    80002974:	fef059e3          	blez	a5,80002966 <iget+0x38>
    80002978:	4098                	lw	a4,0(s1)
    8000297a:	ff3716e3          	bne	a4,s3,80002966 <iget+0x38>
    8000297e:	40d8                	lw	a4,4(s1)
    80002980:	ff4713e3          	bne	a4,s4,80002966 <iget+0x38>
      ip->ref++;
    80002984:	2785                	addiw	a5,a5,1
    80002986:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002988:	00015517          	auipc	a0,0x15
    8000298c:	84050513          	addi	a0,a0,-1984 # 800171c8 <itable>
    80002990:	00004097          	auipc	ra,0x4
    80002994:	96e080e7          	jalr	-1682(ra) # 800062fe <release>
      return ip;
    80002998:	8926                	mv	s2,s1
    8000299a:	a03d                	j	800029c8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000299c:	f7f9                	bnez	a5,8000296a <iget+0x3c>
    8000299e:	8926                	mv	s2,s1
    800029a0:	b7e9                	j	8000296a <iget+0x3c>
  if(empty == 0)
    800029a2:	02090c63          	beqz	s2,800029da <iget+0xac>
  ip->dev = dev;
    800029a6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029aa:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029ae:	4785                	li	a5,1
    800029b0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029b4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029b8:	00015517          	auipc	a0,0x15
    800029bc:	81050513          	addi	a0,a0,-2032 # 800171c8 <itable>
    800029c0:	00004097          	auipc	ra,0x4
    800029c4:	93e080e7          	jalr	-1730(ra) # 800062fe <release>
}
    800029c8:	854a                	mv	a0,s2
    800029ca:	70a2                	ld	ra,40(sp)
    800029cc:	7402                	ld	s0,32(sp)
    800029ce:	64e2                	ld	s1,24(sp)
    800029d0:	6942                	ld	s2,16(sp)
    800029d2:	69a2                	ld	s3,8(sp)
    800029d4:	6a02                	ld	s4,0(sp)
    800029d6:	6145                	addi	sp,sp,48
    800029d8:	8082                	ret
    panic("iget: no inodes");
    800029da:	00006517          	auipc	a0,0x6
    800029de:	c3e50513          	addi	a0,a0,-962 # 80008618 <syscalls+0x140>
    800029e2:	00003097          	auipc	ra,0x3
    800029e6:	32c080e7          	jalr	812(ra) # 80005d0e <panic>

00000000800029ea <fsinit>:
fsinit(int dev) {
    800029ea:	7179                	addi	sp,sp,-48
    800029ec:	f406                	sd	ra,40(sp)
    800029ee:	f022                	sd	s0,32(sp)
    800029f0:	ec26                	sd	s1,24(sp)
    800029f2:	e84a                	sd	s2,16(sp)
    800029f4:	e44e                	sd	s3,8(sp)
    800029f6:	1800                	addi	s0,sp,48
    800029f8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029fa:	4585                	li	a1,1
    800029fc:	00000097          	auipc	ra,0x0
    80002a00:	a50080e7          	jalr	-1456(ra) # 8000244c <bread>
    80002a04:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a06:	00014997          	auipc	s3,0x14
    80002a0a:	7a298993          	addi	s3,s3,1954 # 800171a8 <sb>
    80002a0e:	02000613          	li	a2,32
    80002a12:	05850593          	addi	a1,a0,88
    80002a16:	854e                	mv	a0,s3
    80002a18:	ffffd097          	auipc	ra,0xffffd
    80002a1c:	7e2080e7          	jalr	2018(ra) # 800001fa <memmove>
  brelse(bp);
    80002a20:	8526                	mv	a0,s1
    80002a22:	00000097          	auipc	ra,0x0
    80002a26:	b5a080e7          	jalr	-1190(ra) # 8000257c <brelse>
  if(sb.magic != FSMAGIC)
    80002a2a:	0009a703          	lw	a4,0(s3)
    80002a2e:	102037b7          	lui	a5,0x10203
    80002a32:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a36:	02f71263          	bne	a4,a5,80002a5a <fsinit+0x70>
  initlog(dev, &sb);
    80002a3a:	00014597          	auipc	a1,0x14
    80002a3e:	76e58593          	addi	a1,a1,1902 # 800171a8 <sb>
    80002a42:	854a                	mv	a0,s2
    80002a44:	00001097          	auipc	ra,0x1
    80002a48:	b40080e7          	jalr	-1216(ra) # 80003584 <initlog>
}
    80002a4c:	70a2                	ld	ra,40(sp)
    80002a4e:	7402                	ld	s0,32(sp)
    80002a50:	64e2                	ld	s1,24(sp)
    80002a52:	6942                	ld	s2,16(sp)
    80002a54:	69a2                	ld	s3,8(sp)
    80002a56:	6145                	addi	sp,sp,48
    80002a58:	8082                	ret
    panic("invalid file system");
    80002a5a:	00006517          	auipc	a0,0x6
    80002a5e:	bce50513          	addi	a0,a0,-1074 # 80008628 <syscalls+0x150>
    80002a62:	00003097          	auipc	ra,0x3
    80002a66:	2ac080e7          	jalr	684(ra) # 80005d0e <panic>

0000000080002a6a <iinit>:
{
    80002a6a:	7179                	addi	sp,sp,-48
    80002a6c:	f406                	sd	ra,40(sp)
    80002a6e:	f022                	sd	s0,32(sp)
    80002a70:	ec26                	sd	s1,24(sp)
    80002a72:	e84a                	sd	s2,16(sp)
    80002a74:	e44e                	sd	s3,8(sp)
    80002a76:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a78:	00006597          	auipc	a1,0x6
    80002a7c:	bc858593          	addi	a1,a1,-1080 # 80008640 <syscalls+0x168>
    80002a80:	00014517          	auipc	a0,0x14
    80002a84:	74850513          	addi	a0,a0,1864 # 800171c8 <itable>
    80002a88:	00003097          	auipc	ra,0x3
    80002a8c:	732080e7          	jalr	1842(ra) # 800061ba <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a90:	00014497          	auipc	s1,0x14
    80002a94:	76048493          	addi	s1,s1,1888 # 800171f0 <itable+0x28>
    80002a98:	00016997          	auipc	s3,0x16
    80002a9c:	1e898993          	addi	s3,s3,488 # 80018c80 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002aa0:	00006917          	auipc	s2,0x6
    80002aa4:	ba890913          	addi	s2,s2,-1112 # 80008648 <syscalls+0x170>
    80002aa8:	85ca                	mv	a1,s2
    80002aaa:	8526                	mv	a0,s1
    80002aac:	00001097          	auipc	ra,0x1
    80002ab0:	e3a080e7          	jalr	-454(ra) # 800038e6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ab4:	08848493          	addi	s1,s1,136
    80002ab8:	ff3498e3          	bne	s1,s3,80002aa8 <iinit+0x3e>
}
    80002abc:	70a2                	ld	ra,40(sp)
    80002abe:	7402                	ld	s0,32(sp)
    80002ac0:	64e2                	ld	s1,24(sp)
    80002ac2:	6942                	ld	s2,16(sp)
    80002ac4:	69a2                	ld	s3,8(sp)
    80002ac6:	6145                	addi	sp,sp,48
    80002ac8:	8082                	ret

0000000080002aca <ialloc>:
{
    80002aca:	715d                	addi	sp,sp,-80
    80002acc:	e486                	sd	ra,72(sp)
    80002ace:	e0a2                	sd	s0,64(sp)
    80002ad0:	fc26                	sd	s1,56(sp)
    80002ad2:	f84a                	sd	s2,48(sp)
    80002ad4:	f44e                	sd	s3,40(sp)
    80002ad6:	f052                	sd	s4,32(sp)
    80002ad8:	ec56                	sd	s5,24(sp)
    80002ada:	e85a                	sd	s6,16(sp)
    80002adc:	e45e                	sd	s7,8(sp)
    80002ade:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ae0:	00014717          	auipc	a4,0x14
    80002ae4:	6d472703          	lw	a4,1748(a4) # 800171b4 <sb+0xc>
    80002ae8:	4785                	li	a5,1
    80002aea:	04e7fa63          	bgeu	a5,a4,80002b3e <ialloc+0x74>
    80002aee:	8aaa                	mv	s5,a0
    80002af0:	8bae                	mv	s7,a1
    80002af2:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002af4:	00014a17          	auipc	s4,0x14
    80002af8:	6b4a0a13          	addi	s4,s4,1716 # 800171a8 <sb>
    80002afc:	00048b1b          	sext.w	s6,s1
    80002b00:	0044d793          	srli	a5,s1,0x4
    80002b04:	018a2583          	lw	a1,24(s4)
    80002b08:	9dbd                	addw	a1,a1,a5
    80002b0a:	8556                	mv	a0,s5
    80002b0c:	00000097          	auipc	ra,0x0
    80002b10:	940080e7          	jalr	-1728(ra) # 8000244c <bread>
    80002b14:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b16:	05850993          	addi	s3,a0,88
    80002b1a:	00f4f793          	andi	a5,s1,15
    80002b1e:	079a                	slli	a5,a5,0x6
    80002b20:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b22:	00099783          	lh	a5,0(s3)
    80002b26:	c3a1                	beqz	a5,80002b66 <ialloc+0x9c>
    brelse(bp);
    80002b28:	00000097          	auipc	ra,0x0
    80002b2c:	a54080e7          	jalr	-1452(ra) # 8000257c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b30:	0485                	addi	s1,s1,1
    80002b32:	00ca2703          	lw	a4,12(s4)
    80002b36:	0004879b          	sext.w	a5,s1
    80002b3a:	fce7e1e3          	bltu	a5,a4,80002afc <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b3e:	00006517          	auipc	a0,0x6
    80002b42:	b1250513          	addi	a0,a0,-1262 # 80008650 <syscalls+0x178>
    80002b46:	00003097          	auipc	ra,0x3
    80002b4a:	212080e7          	jalr	530(ra) # 80005d58 <printf>
  return 0;
    80002b4e:	4501                	li	a0,0
}
    80002b50:	60a6                	ld	ra,72(sp)
    80002b52:	6406                	ld	s0,64(sp)
    80002b54:	74e2                	ld	s1,56(sp)
    80002b56:	7942                	ld	s2,48(sp)
    80002b58:	79a2                	ld	s3,40(sp)
    80002b5a:	7a02                	ld	s4,32(sp)
    80002b5c:	6ae2                	ld	s5,24(sp)
    80002b5e:	6b42                	ld	s6,16(sp)
    80002b60:	6ba2                	ld	s7,8(sp)
    80002b62:	6161                	addi	sp,sp,80
    80002b64:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b66:	04000613          	li	a2,64
    80002b6a:	4581                	li	a1,0
    80002b6c:	854e                	mv	a0,s3
    80002b6e:	ffffd097          	auipc	ra,0xffffd
    80002b72:	630080e7          	jalr	1584(ra) # 8000019e <memset>
      dip->type = type;
    80002b76:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b7a:	854a                	mv	a0,s2
    80002b7c:	00001097          	auipc	ra,0x1
    80002b80:	c84080e7          	jalr	-892(ra) # 80003800 <log_write>
      brelse(bp);
    80002b84:	854a                	mv	a0,s2
    80002b86:	00000097          	auipc	ra,0x0
    80002b8a:	9f6080e7          	jalr	-1546(ra) # 8000257c <brelse>
      return iget(dev, inum);
    80002b8e:	85da                	mv	a1,s6
    80002b90:	8556                	mv	a0,s5
    80002b92:	00000097          	auipc	ra,0x0
    80002b96:	d9c080e7          	jalr	-612(ra) # 8000292e <iget>
    80002b9a:	bf5d                	j	80002b50 <ialloc+0x86>

0000000080002b9c <iupdate>:
{
    80002b9c:	1101                	addi	sp,sp,-32
    80002b9e:	ec06                	sd	ra,24(sp)
    80002ba0:	e822                	sd	s0,16(sp)
    80002ba2:	e426                	sd	s1,8(sp)
    80002ba4:	e04a                	sd	s2,0(sp)
    80002ba6:	1000                	addi	s0,sp,32
    80002ba8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002baa:	415c                	lw	a5,4(a0)
    80002bac:	0047d79b          	srliw	a5,a5,0x4
    80002bb0:	00014597          	auipc	a1,0x14
    80002bb4:	6105a583          	lw	a1,1552(a1) # 800171c0 <sb+0x18>
    80002bb8:	9dbd                	addw	a1,a1,a5
    80002bba:	4108                	lw	a0,0(a0)
    80002bbc:	00000097          	auipc	ra,0x0
    80002bc0:	890080e7          	jalr	-1904(ra) # 8000244c <bread>
    80002bc4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bc6:	05850793          	addi	a5,a0,88
    80002bca:	40c8                	lw	a0,4(s1)
    80002bcc:	893d                	andi	a0,a0,15
    80002bce:	051a                	slli	a0,a0,0x6
    80002bd0:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002bd2:	04449703          	lh	a4,68(s1)
    80002bd6:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002bda:	04649703          	lh	a4,70(s1)
    80002bde:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002be2:	04849703          	lh	a4,72(s1)
    80002be6:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002bea:	04a49703          	lh	a4,74(s1)
    80002bee:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002bf2:	44f8                	lw	a4,76(s1)
    80002bf4:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bf6:	03400613          	li	a2,52
    80002bfa:	05048593          	addi	a1,s1,80
    80002bfe:	0531                	addi	a0,a0,12
    80002c00:	ffffd097          	auipc	ra,0xffffd
    80002c04:	5fa080e7          	jalr	1530(ra) # 800001fa <memmove>
  log_write(bp);
    80002c08:	854a                	mv	a0,s2
    80002c0a:	00001097          	auipc	ra,0x1
    80002c0e:	bf6080e7          	jalr	-1034(ra) # 80003800 <log_write>
  brelse(bp);
    80002c12:	854a                	mv	a0,s2
    80002c14:	00000097          	auipc	ra,0x0
    80002c18:	968080e7          	jalr	-1688(ra) # 8000257c <brelse>
}
    80002c1c:	60e2                	ld	ra,24(sp)
    80002c1e:	6442                	ld	s0,16(sp)
    80002c20:	64a2                	ld	s1,8(sp)
    80002c22:	6902                	ld	s2,0(sp)
    80002c24:	6105                	addi	sp,sp,32
    80002c26:	8082                	ret

0000000080002c28 <idup>:
{
    80002c28:	1101                	addi	sp,sp,-32
    80002c2a:	ec06                	sd	ra,24(sp)
    80002c2c:	e822                	sd	s0,16(sp)
    80002c2e:	e426                	sd	s1,8(sp)
    80002c30:	1000                	addi	s0,sp,32
    80002c32:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c34:	00014517          	auipc	a0,0x14
    80002c38:	59450513          	addi	a0,a0,1428 # 800171c8 <itable>
    80002c3c:	00003097          	auipc	ra,0x3
    80002c40:	60e080e7          	jalr	1550(ra) # 8000624a <acquire>
  ip->ref++;
    80002c44:	449c                	lw	a5,8(s1)
    80002c46:	2785                	addiw	a5,a5,1
    80002c48:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c4a:	00014517          	auipc	a0,0x14
    80002c4e:	57e50513          	addi	a0,a0,1406 # 800171c8 <itable>
    80002c52:	00003097          	auipc	ra,0x3
    80002c56:	6ac080e7          	jalr	1708(ra) # 800062fe <release>
}
    80002c5a:	8526                	mv	a0,s1
    80002c5c:	60e2                	ld	ra,24(sp)
    80002c5e:	6442                	ld	s0,16(sp)
    80002c60:	64a2                	ld	s1,8(sp)
    80002c62:	6105                	addi	sp,sp,32
    80002c64:	8082                	ret

0000000080002c66 <ilock>:
{
    80002c66:	1101                	addi	sp,sp,-32
    80002c68:	ec06                	sd	ra,24(sp)
    80002c6a:	e822                	sd	s0,16(sp)
    80002c6c:	e426                	sd	s1,8(sp)
    80002c6e:	e04a                	sd	s2,0(sp)
    80002c70:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c72:	c115                	beqz	a0,80002c96 <ilock+0x30>
    80002c74:	84aa                	mv	s1,a0
    80002c76:	451c                	lw	a5,8(a0)
    80002c78:	00f05f63          	blez	a5,80002c96 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c7c:	0541                	addi	a0,a0,16
    80002c7e:	00001097          	auipc	ra,0x1
    80002c82:	ca2080e7          	jalr	-862(ra) # 80003920 <acquiresleep>
  if(ip->valid == 0){
    80002c86:	40bc                	lw	a5,64(s1)
    80002c88:	cf99                	beqz	a5,80002ca6 <ilock+0x40>
}
    80002c8a:	60e2                	ld	ra,24(sp)
    80002c8c:	6442                	ld	s0,16(sp)
    80002c8e:	64a2                	ld	s1,8(sp)
    80002c90:	6902                	ld	s2,0(sp)
    80002c92:	6105                	addi	sp,sp,32
    80002c94:	8082                	ret
    panic("ilock");
    80002c96:	00006517          	auipc	a0,0x6
    80002c9a:	9d250513          	addi	a0,a0,-1582 # 80008668 <syscalls+0x190>
    80002c9e:	00003097          	auipc	ra,0x3
    80002ca2:	070080e7          	jalr	112(ra) # 80005d0e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ca6:	40dc                	lw	a5,4(s1)
    80002ca8:	0047d79b          	srliw	a5,a5,0x4
    80002cac:	00014597          	auipc	a1,0x14
    80002cb0:	5145a583          	lw	a1,1300(a1) # 800171c0 <sb+0x18>
    80002cb4:	9dbd                	addw	a1,a1,a5
    80002cb6:	4088                	lw	a0,0(s1)
    80002cb8:	fffff097          	auipc	ra,0xfffff
    80002cbc:	794080e7          	jalr	1940(ra) # 8000244c <bread>
    80002cc0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cc2:	05850593          	addi	a1,a0,88
    80002cc6:	40dc                	lw	a5,4(s1)
    80002cc8:	8bbd                	andi	a5,a5,15
    80002cca:	079a                	slli	a5,a5,0x6
    80002ccc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cce:	00059783          	lh	a5,0(a1)
    80002cd2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cd6:	00259783          	lh	a5,2(a1)
    80002cda:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cde:	00459783          	lh	a5,4(a1)
    80002ce2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ce6:	00659783          	lh	a5,6(a1)
    80002cea:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cee:	459c                	lw	a5,8(a1)
    80002cf0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cf2:	03400613          	li	a2,52
    80002cf6:	05b1                	addi	a1,a1,12
    80002cf8:	05048513          	addi	a0,s1,80
    80002cfc:	ffffd097          	auipc	ra,0xffffd
    80002d00:	4fe080e7          	jalr	1278(ra) # 800001fa <memmove>
    brelse(bp);
    80002d04:	854a                	mv	a0,s2
    80002d06:	00000097          	auipc	ra,0x0
    80002d0a:	876080e7          	jalr	-1930(ra) # 8000257c <brelse>
    ip->valid = 1;
    80002d0e:	4785                	li	a5,1
    80002d10:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d12:	04449783          	lh	a5,68(s1)
    80002d16:	fbb5                	bnez	a5,80002c8a <ilock+0x24>
      panic("ilock: no type");
    80002d18:	00006517          	auipc	a0,0x6
    80002d1c:	95850513          	addi	a0,a0,-1704 # 80008670 <syscalls+0x198>
    80002d20:	00003097          	auipc	ra,0x3
    80002d24:	fee080e7          	jalr	-18(ra) # 80005d0e <panic>

0000000080002d28 <iunlock>:
{
    80002d28:	1101                	addi	sp,sp,-32
    80002d2a:	ec06                	sd	ra,24(sp)
    80002d2c:	e822                	sd	s0,16(sp)
    80002d2e:	e426                	sd	s1,8(sp)
    80002d30:	e04a                	sd	s2,0(sp)
    80002d32:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d34:	c905                	beqz	a0,80002d64 <iunlock+0x3c>
    80002d36:	84aa                	mv	s1,a0
    80002d38:	01050913          	addi	s2,a0,16
    80002d3c:	854a                	mv	a0,s2
    80002d3e:	00001097          	auipc	ra,0x1
    80002d42:	c7c080e7          	jalr	-900(ra) # 800039ba <holdingsleep>
    80002d46:	cd19                	beqz	a0,80002d64 <iunlock+0x3c>
    80002d48:	449c                	lw	a5,8(s1)
    80002d4a:	00f05d63          	blez	a5,80002d64 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d4e:	854a                	mv	a0,s2
    80002d50:	00001097          	auipc	ra,0x1
    80002d54:	c26080e7          	jalr	-986(ra) # 80003976 <releasesleep>
}
    80002d58:	60e2                	ld	ra,24(sp)
    80002d5a:	6442                	ld	s0,16(sp)
    80002d5c:	64a2                	ld	s1,8(sp)
    80002d5e:	6902                	ld	s2,0(sp)
    80002d60:	6105                	addi	sp,sp,32
    80002d62:	8082                	ret
    panic("iunlock");
    80002d64:	00006517          	auipc	a0,0x6
    80002d68:	91c50513          	addi	a0,a0,-1764 # 80008680 <syscalls+0x1a8>
    80002d6c:	00003097          	auipc	ra,0x3
    80002d70:	fa2080e7          	jalr	-94(ra) # 80005d0e <panic>

0000000080002d74 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d74:	7179                	addi	sp,sp,-48
    80002d76:	f406                	sd	ra,40(sp)
    80002d78:	f022                	sd	s0,32(sp)
    80002d7a:	ec26                	sd	s1,24(sp)
    80002d7c:	e84a                	sd	s2,16(sp)
    80002d7e:	e44e                	sd	s3,8(sp)
    80002d80:	e052                	sd	s4,0(sp)
    80002d82:	1800                	addi	s0,sp,48
    80002d84:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d86:	05050493          	addi	s1,a0,80
    80002d8a:	08050913          	addi	s2,a0,128
    80002d8e:	a021                	j	80002d96 <itrunc+0x22>
    80002d90:	0491                	addi	s1,s1,4
    80002d92:	01248d63          	beq	s1,s2,80002dac <itrunc+0x38>
    if(ip->addrs[i]){
    80002d96:	408c                	lw	a1,0(s1)
    80002d98:	dde5                	beqz	a1,80002d90 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d9a:	0009a503          	lw	a0,0(s3)
    80002d9e:	00000097          	auipc	ra,0x0
    80002da2:	8f4080e7          	jalr	-1804(ra) # 80002692 <bfree>
      ip->addrs[i] = 0;
    80002da6:	0004a023          	sw	zero,0(s1)
    80002daa:	b7dd                	j	80002d90 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dac:	0809a583          	lw	a1,128(s3)
    80002db0:	e185                	bnez	a1,80002dd0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002db2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002db6:	854e                	mv	a0,s3
    80002db8:	00000097          	auipc	ra,0x0
    80002dbc:	de4080e7          	jalr	-540(ra) # 80002b9c <iupdate>
}
    80002dc0:	70a2                	ld	ra,40(sp)
    80002dc2:	7402                	ld	s0,32(sp)
    80002dc4:	64e2                	ld	s1,24(sp)
    80002dc6:	6942                	ld	s2,16(sp)
    80002dc8:	69a2                	ld	s3,8(sp)
    80002dca:	6a02                	ld	s4,0(sp)
    80002dcc:	6145                	addi	sp,sp,48
    80002dce:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dd0:	0009a503          	lw	a0,0(s3)
    80002dd4:	fffff097          	auipc	ra,0xfffff
    80002dd8:	678080e7          	jalr	1656(ra) # 8000244c <bread>
    80002ddc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002dde:	05850493          	addi	s1,a0,88
    80002de2:	45850913          	addi	s2,a0,1112
    80002de6:	a021                	j	80002dee <itrunc+0x7a>
    80002de8:	0491                	addi	s1,s1,4
    80002dea:	01248b63          	beq	s1,s2,80002e00 <itrunc+0x8c>
      if(a[j])
    80002dee:	408c                	lw	a1,0(s1)
    80002df0:	dde5                	beqz	a1,80002de8 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002df2:	0009a503          	lw	a0,0(s3)
    80002df6:	00000097          	auipc	ra,0x0
    80002dfa:	89c080e7          	jalr	-1892(ra) # 80002692 <bfree>
    80002dfe:	b7ed                	j	80002de8 <itrunc+0x74>
    brelse(bp);
    80002e00:	8552                	mv	a0,s4
    80002e02:	fffff097          	auipc	ra,0xfffff
    80002e06:	77a080e7          	jalr	1914(ra) # 8000257c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e0a:	0809a583          	lw	a1,128(s3)
    80002e0e:	0009a503          	lw	a0,0(s3)
    80002e12:	00000097          	auipc	ra,0x0
    80002e16:	880080e7          	jalr	-1920(ra) # 80002692 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e1a:	0809a023          	sw	zero,128(s3)
    80002e1e:	bf51                	j	80002db2 <itrunc+0x3e>

0000000080002e20 <iput>:
{
    80002e20:	1101                	addi	sp,sp,-32
    80002e22:	ec06                	sd	ra,24(sp)
    80002e24:	e822                	sd	s0,16(sp)
    80002e26:	e426                	sd	s1,8(sp)
    80002e28:	e04a                	sd	s2,0(sp)
    80002e2a:	1000                	addi	s0,sp,32
    80002e2c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e2e:	00014517          	auipc	a0,0x14
    80002e32:	39a50513          	addi	a0,a0,922 # 800171c8 <itable>
    80002e36:	00003097          	auipc	ra,0x3
    80002e3a:	414080e7          	jalr	1044(ra) # 8000624a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e3e:	4498                	lw	a4,8(s1)
    80002e40:	4785                	li	a5,1
    80002e42:	02f70363          	beq	a4,a5,80002e68 <iput+0x48>
  ip->ref--;
    80002e46:	449c                	lw	a5,8(s1)
    80002e48:	37fd                	addiw	a5,a5,-1
    80002e4a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e4c:	00014517          	auipc	a0,0x14
    80002e50:	37c50513          	addi	a0,a0,892 # 800171c8 <itable>
    80002e54:	00003097          	auipc	ra,0x3
    80002e58:	4aa080e7          	jalr	1194(ra) # 800062fe <release>
}
    80002e5c:	60e2                	ld	ra,24(sp)
    80002e5e:	6442                	ld	s0,16(sp)
    80002e60:	64a2                	ld	s1,8(sp)
    80002e62:	6902                	ld	s2,0(sp)
    80002e64:	6105                	addi	sp,sp,32
    80002e66:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e68:	40bc                	lw	a5,64(s1)
    80002e6a:	dff1                	beqz	a5,80002e46 <iput+0x26>
    80002e6c:	04a49783          	lh	a5,74(s1)
    80002e70:	fbf9                	bnez	a5,80002e46 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e72:	01048913          	addi	s2,s1,16
    80002e76:	854a                	mv	a0,s2
    80002e78:	00001097          	auipc	ra,0x1
    80002e7c:	aa8080e7          	jalr	-1368(ra) # 80003920 <acquiresleep>
    release(&itable.lock);
    80002e80:	00014517          	auipc	a0,0x14
    80002e84:	34850513          	addi	a0,a0,840 # 800171c8 <itable>
    80002e88:	00003097          	auipc	ra,0x3
    80002e8c:	476080e7          	jalr	1142(ra) # 800062fe <release>
    itrunc(ip);
    80002e90:	8526                	mv	a0,s1
    80002e92:	00000097          	auipc	ra,0x0
    80002e96:	ee2080e7          	jalr	-286(ra) # 80002d74 <itrunc>
    ip->type = 0;
    80002e9a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e9e:	8526                	mv	a0,s1
    80002ea0:	00000097          	auipc	ra,0x0
    80002ea4:	cfc080e7          	jalr	-772(ra) # 80002b9c <iupdate>
    ip->valid = 0;
    80002ea8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002eac:	854a                	mv	a0,s2
    80002eae:	00001097          	auipc	ra,0x1
    80002eb2:	ac8080e7          	jalr	-1336(ra) # 80003976 <releasesleep>
    acquire(&itable.lock);
    80002eb6:	00014517          	auipc	a0,0x14
    80002eba:	31250513          	addi	a0,a0,786 # 800171c8 <itable>
    80002ebe:	00003097          	auipc	ra,0x3
    80002ec2:	38c080e7          	jalr	908(ra) # 8000624a <acquire>
    80002ec6:	b741                	j	80002e46 <iput+0x26>

0000000080002ec8 <iunlockput>:
{
    80002ec8:	1101                	addi	sp,sp,-32
    80002eca:	ec06                	sd	ra,24(sp)
    80002ecc:	e822                	sd	s0,16(sp)
    80002ece:	e426                	sd	s1,8(sp)
    80002ed0:	1000                	addi	s0,sp,32
    80002ed2:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ed4:	00000097          	auipc	ra,0x0
    80002ed8:	e54080e7          	jalr	-428(ra) # 80002d28 <iunlock>
  iput(ip);
    80002edc:	8526                	mv	a0,s1
    80002ede:	00000097          	auipc	ra,0x0
    80002ee2:	f42080e7          	jalr	-190(ra) # 80002e20 <iput>
}
    80002ee6:	60e2                	ld	ra,24(sp)
    80002ee8:	6442                	ld	s0,16(sp)
    80002eea:	64a2                	ld	s1,8(sp)
    80002eec:	6105                	addi	sp,sp,32
    80002eee:	8082                	ret

0000000080002ef0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ef0:	1141                	addi	sp,sp,-16
    80002ef2:	e422                	sd	s0,8(sp)
    80002ef4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ef6:	411c                	lw	a5,0(a0)
    80002ef8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002efa:	415c                	lw	a5,4(a0)
    80002efc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002efe:	04451783          	lh	a5,68(a0)
    80002f02:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f06:	04a51783          	lh	a5,74(a0)
    80002f0a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f0e:	04c56783          	lwu	a5,76(a0)
    80002f12:	e99c                	sd	a5,16(a1)
}
    80002f14:	6422                	ld	s0,8(sp)
    80002f16:	0141                	addi	sp,sp,16
    80002f18:	8082                	ret

0000000080002f1a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f1a:	457c                	lw	a5,76(a0)
    80002f1c:	0ed7e963          	bltu	a5,a3,8000300e <readi+0xf4>
{
    80002f20:	7159                	addi	sp,sp,-112
    80002f22:	f486                	sd	ra,104(sp)
    80002f24:	f0a2                	sd	s0,96(sp)
    80002f26:	eca6                	sd	s1,88(sp)
    80002f28:	e8ca                	sd	s2,80(sp)
    80002f2a:	e4ce                	sd	s3,72(sp)
    80002f2c:	e0d2                	sd	s4,64(sp)
    80002f2e:	fc56                	sd	s5,56(sp)
    80002f30:	f85a                	sd	s6,48(sp)
    80002f32:	f45e                	sd	s7,40(sp)
    80002f34:	f062                	sd	s8,32(sp)
    80002f36:	ec66                	sd	s9,24(sp)
    80002f38:	e86a                	sd	s10,16(sp)
    80002f3a:	e46e                	sd	s11,8(sp)
    80002f3c:	1880                	addi	s0,sp,112
    80002f3e:	8b2a                	mv	s6,a0
    80002f40:	8bae                	mv	s7,a1
    80002f42:	8a32                	mv	s4,a2
    80002f44:	84b6                	mv	s1,a3
    80002f46:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f48:	9f35                	addw	a4,a4,a3
    return 0;
    80002f4a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f4c:	0ad76063          	bltu	a4,a3,80002fec <readi+0xd2>
  if(off + n > ip->size)
    80002f50:	00e7f463          	bgeu	a5,a4,80002f58 <readi+0x3e>
    n = ip->size - off;
    80002f54:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f58:	0a0a8963          	beqz	s5,8000300a <readi+0xf0>
    80002f5c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f5e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f62:	5c7d                	li	s8,-1
    80002f64:	a82d                	j	80002f9e <readi+0x84>
    80002f66:	020d1d93          	slli	s11,s10,0x20
    80002f6a:	020ddd93          	srli	s11,s11,0x20
    80002f6e:	05890793          	addi	a5,s2,88
    80002f72:	86ee                	mv	a3,s11
    80002f74:	963e                	add	a2,a2,a5
    80002f76:	85d2                	mv	a1,s4
    80002f78:	855e                	mv	a0,s7
    80002f7a:	fffff097          	auipc	ra,0xfffff
    80002f7e:	a12080e7          	jalr	-1518(ra) # 8000198c <either_copyout>
    80002f82:	05850d63          	beq	a0,s8,80002fdc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f86:	854a                	mv	a0,s2
    80002f88:	fffff097          	auipc	ra,0xfffff
    80002f8c:	5f4080e7          	jalr	1524(ra) # 8000257c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f90:	013d09bb          	addw	s3,s10,s3
    80002f94:	009d04bb          	addw	s1,s10,s1
    80002f98:	9a6e                	add	s4,s4,s11
    80002f9a:	0559f763          	bgeu	s3,s5,80002fe8 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f9e:	00a4d59b          	srliw	a1,s1,0xa
    80002fa2:	855a                	mv	a0,s6
    80002fa4:	00000097          	auipc	ra,0x0
    80002fa8:	8a2080e7          	jalr	-1886(ra) # 80002846 <bmap>
    80002fac:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fb0:	cd85                	beqz	a1,80002fe8 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002fb2:	000b2503          	lw	a0,0(s6)
    80002fb6:	fffff097          	auipc	ra,0xfffff
    80002fba:	496080e7          	jalr	1174(ra) # 8000244c <bread>
    80002fbe:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fc0:	3ff4f613          	andi	a2,s1,1023
    80002fc4:	40cc87bb          	subw	a5,s9,a2
    80002fc8:	413a873b          	subw	a4,s5,s3
    80002fcc:	8d3e                	mv	s10,a5
    80002fce:	2781                	sext.w	a5,a5
    80002fd0:	0007069b          	sext.w	a3,a4
    80002fd4:	f8f6f9e3          	bgeu	a3,a5,80002f66 <readi+0x4c>
    80002fd8:	8d3a                	mv	s10,a4
    80002fda:	b771                	j	80002f66 <readi+0x4c>
      brelse(bp);
    80002fdc:	854a                	mv	a0,s2
    80002fde:	fffff097          	auipc	ra,0xfffff
    80002fe2:	59e080e7          	jalr	1438(ra) # 8000257c <brelse>
      tot = -1;
    80002fe6:	59fd                	li	s3,-1
  }
  return tot;
    80002fe8:	0009851b          	sext.w	a0,s3
}
    80002fec:	70a6                	ld	ra,104(sp)
    80002fee:	7406                	ld	s0,96(sp)
    80002ff0:	64e6                	ld	s1,88(sp)
    80002ff2:	6946                	ld	s2,80(sp)
    80002ff4:	69a6                	ld	s3,72(sp)
    80002ff6:	6a06                	ld	s4,64(sp)
    80002ff8:	7ae2                	ld	s5,56(sp)
    80002ffa:	7b42                	ld	s6,48(sp)
    80002ffc:	7ba2                	ld	s7,40(sp)
    80002ffe:	7c02                	ld	s8,32(sp)
    80003000:	6ce2                	ld	s9,24(sp)
    80003002:	6d42                	ld	s10,16(sp)
    80003004:	6da2                	ld	s11,8(sp)
    80003006:	6165                	addi	sp,sp,112
    80003008:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000300a:	89d6                	mv	s3,s5
    8000300c:	bff1                	j	80002fe8 <readi+0xce>
    return 0;
    8000300e:	4501                	li	a0,0
}
    80003010:	8082                	ret

0000000080003012 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003012:	457c                	lw	a5,76(a0)
    80003014:	10d7e863          	bltu	a5,a3,80003124 <writei+0x112>
{
    80003018:	7159                	addi	sp,sp,-112
    8000301a:	f486                	sd	ra,104(sp)
    8000301c:	f0a2                	sd	s0,96(sp)
    8000301e:	eca6                	sd	s1,88(sp)
    80003020:	e8ca                	sd	s2,80(sp)
    80003022:	e4ce                	sd	s3,72(sp)
    80003024:	e0d2                	sd	s4,64(sp)
    80003026:	fc56                	sd	s5,56(sp)
    80003028:	f85a                	sd	s6,48(sp)
    8000302a:	f45e                	sd	s7,40(sp)
    8000302c:	f062                	sd	s8,32(sp)
    8000302e:	ec66                	sd	s9,24(sp)
    80003030:	e86a                	sd	s10,16(sp)
    80003032:	e46e                	sd	s11,8(sp)
    80003034:	1880                	addi	s0,sp,112
    80003036:	8aaa                	mv	s5,a0
    80003038:	8bae                	mv	s7,a1
    8000303a:	8a32                	mv	s4,a2
    8000303c:	8936                	mv	s2,a3
    8000303e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003040:	00e687bb          	addw	a5,a3,a4
    80003044:	0ed7e263          	bltu	a5,a3,80003128 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003048:	00043737          	lui	a4,0x43
    8000304c:	0ef76063          	bltu	a4,a5,8000312c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003050:	0c0b0863          	beqz	s6,80003120 <writei+0x10e>
    80003054:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003056:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000305a:	5c7d                	li	s8,-1
    8000305c:	a091                	j	800030a0 <writei+0x8e>
    8000305e:	020d1d93          	slli	s11,s10,0x20
    80003062:	020ddd93          	srli	s11,s11,0x20
    80003066:	05848793          	addi	a5,s1,88
    8000306a:	86ee                	mv	a3,s11
    8000306c:	8652                	mv	a2,s4
    8000306e:	85de                	mv	a1,s7
    80003070:	953e                	add	a0,a0,a5
    80003072:	fffff097          	auipc	ra,0xfffff
    80003076:	970080e7          	jalr	-1680(ra) # 800019e2 <either_copyin>
    8000307a:	07850263          	beq	a0,s8,800030de <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000307e:	8526                	mv	a0,s1
    80003080:	00000097          	auipc	ra,0x0
    80003084:	780080e7          	jalr	1920(ra) # 80003800 <log_write>
    brelse(bp);
    80003088:	8526                	mv	a0,s1
    8000308a:	fffff097          	auipc	ra,0xfffff
    8000308e:	4f2080e7          	jalr	1266(ra) # 8000257c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003092:	013d09bb          	addw	s3,s10,s3
    80003096:	012d093b          	addw	s2,s10,s2
    8000309a:	9a6e                	add	s4,s4,s11
    8000309c:	0569f663          	bgeu	s3,s6,800030e8 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030a0:	00a9559b          	srliw	a1,s2,0xa
    800030a4:	8556                	mv	a0,s5
    800030a6:	fffff097          	auipc	ra,0xfffff
    800030aa:	7a0080e7          	jalr	1952(ra) # 80002846 <bmap>
    800030ae:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030b2:	c99d                	beqz	a1,800030e8 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800030b4:	000aa503          	lw	a0,0(s5)
    800030b8:	fffff097          	auipc	ra,0xfffff
    800030bc:	394080e7          	jalr	916(ra) # 8000244c <bread>
    800030c0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030c2:	3ff97513          	andi	a0,s2,1023
    800030c6:	40ac87bb          	subw	a5,s9,a0
    800030ca:	413b073b          	subw	a4,s6,s3
    800030ce:	8d3e                	mv	s10,a5
    800030d0:	2781                	sext.w	a5,a5
    800030d2:	0007069b          	sext.w	a3,a4
    800030d6:	f8f6f4e3          	bgeu	a3,a5,8000305e <writei+0x4c>
    800030da:	8d3a                	mv	s10,a4
    800030dc:	b749                	j	8000305e <writei+0x4c>
      brelse(bp);
    800030de:	8526                	mv	a0,s1
    800030e0:	fffff097          	auipc	ra,0xfffff
    800030e4:	49c080e7          	jalr	1180(ra) # 8000257c <brelse>
  }

  if(off > ip->size)
    800030e8:	04caa783          	lw	a5,76(s5)
    800030ec:	0127f463          	bgeu	a5,s2,800030f4 <writei+0xe2>
    ip->size = off;
    800030f0:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030f4:	8556                	mv	a0,s5
    800030f6:	00000097          	auipc	ra,0x0
    800030fa:	aa6080e7          	jalr	-1370(ra) # 80002b9c <iupdate>

  return tot;
    800030fe:	0009851b          	sext.w	a0,s3
}
    80003102:	70a6                	ld	ra,104(sp)
    80003104:	7406                	ld	s0,96(sp)
    80003106:	64e6                	ld	s1,88(sp)
    80003108:	6946                	ld	s2,80(sp)
    8000310a:	69a6                	ld	s3,72(sp)
    8000310c:	6a06                	ld	s4,64(sp)
    8000310e:	7ae2                	ld	s5,56(sp)
    80003110:	7b42                	ld	s6,48(sp)
    80003112:	7ba2                	ld	s7,40(sp)
    80003114:	7c02                	ld	s8,32(sp)
    80003116:	6ce2                	ld	s9,24(sp)
    80003118:	6d42                	ld	s10,16(sp)
    8000311a:	6da2                	ld	s11,8(sp)
    8000311c:	6165                	addi	sp,sp,112
    8000311e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003120:	89da                	mv	s3,s6
    80003122:	bfc9                	j	800030f4 <writei+0xe2>
    return -1;
    80003124:	557d                	li	a0,-1
}
    80003126:	8082                	ret
    return -1;
    80003128:	557d                	li	a0,-1
    8000312a:	bfe1                	j	80003102 <writei+0xf0>
    return -1;
    8000312c:	557d                	li	a0,-1
    8000312e:	bfd1                	j	80003102 <writei+0xf0>

0000000080003130 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003130:	1141                	addi	sp,sp,-16
    80003132:	e406                	sd	ra,8(sp)
    80003134:	e022                	sd	s0,0(sp)
    80003136:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003138:	4639                	li	a2,14
    8000313a:	ffffd097          	auipc	ra,0xffffd
    8000313e:	134080e7          	jalr	308(ra) # 8000026e <strncmp>
}
    80003142:	60a2                	ld	ra,8(sp)
    80003144:	6402                	ld	s0,0(sp)
    80003146:	0141                	addi	sp,sp,16
    80003148:	8082                	ret

000000008000314a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000314a:	7139                	addi	sp,sp,-64
    8000314c:	fc06                	sd	ra,56(sp)
    8000314e:	f822                	sd	s0,48(sp)
    80003150:	f426                	sd	s1,40(sp)
    80003152:	f04a                	sd	s2,32(sp)
    80003154:	ec4e                	sd	s3,24(sp)
    80003156:	e852                	sd	s4,16(sp)
    80003158:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000315a:	04451703          	lh	a4,68(a0)
    8000315e:	4785                	li	a5,1
    80003160:	00f71a63          	bne	a4,a5,80003174 <dirlookup+0x2a>
    80003164:	892a                	mv	s2,a0
    80003166:	89ae                	mv	s3,a1
    80003168:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000316a:	457c                	lw	a5,76(a0)
    8000316c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000316e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003170:	e79d                	bnez	a5,8000319e <dirlookup+0x54>
    80003172:	a8a5                	j	800031ea <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003174:	00005517          	auipc	a0,0x5
    80003178:	51450513          	addi	a0,a0,1300 # 80008688 <syscalls+0x1b0>
    8000317c:	00003097          	auipc	ra,0x3
    80003180:	b92080e7          	jalr	-1134(ra) # 80005d0e <panic>
      panic("dirlookup read");
    80003184:	00005517          	auipc	a0,0x5
    80003188:	51c50513          	addi	a0,a0,1308 # 800086a0 <syscalls+0x1c8>
    8000318c:	00003097          	auipc	ra,0x3
    80003190:	b82080e7          	jalr	-1150(ra) # 80005d0e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003194:	24c1                	addiw	s1,s1,16
    80003196:	04c92783          	lw	a5,76(s2)
    8000319a:	04f4f763          	bgeu	s1,a5,800031e8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000319e:	4741                	li	a4,16
    800031a0:	86a6                	mv	a3,s1
    800031a2:	fc040613          	addi	a2,s0,-64
    800031a6:	4581                	li	a1,0
    800031a8:	854a                	mv	a0,s2
    800031aa:	00000097          	auipc	ra,0x0
    800031ae:	d70080e7          	jalr	-656(ra) # 80002f1a <readi>
    800031b2:	47c1                	li	a5,16
    800031b4:	fcf518e3          	bne	a0,a5,80003184 <dirlookup+0x3a>
    if(de.inum == 0)
    800031b8:	fc045783          	lhu	a5,-64(s0)
    800031bc:	dfe1                	beqz	a5,80003194 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031be:	fc240593          	addi	a1,s0,-62
    800031c2:	854e                	mv	a0,s3
    800031c4:	00000097          	auipc	ra,0x0
    800031c8:	f6c080e7          	jalr	-148(ra) # 80003130 <namecmp>
    800031cc:	f561                	bnez	a0,80003194 <dirlookup+0x4a>
      if(poff)
    800031ce:	000a0463          	beqz	s4,800031d6 <dirlookup+0x8c>
        *poff = off;
    800031d2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031d6:	fc045583          	lhu	a1,-64(s0)
    800031da:	00092503          	lw	a0,0(s2)
    800031de:	fffff097          	auipc	ra,0xfffff
    800031e2:	750080e7          	jalr	1872(ra) # 8000292e <iget>
    800031e6:	a011                	j	800031ea <dirlookup+0xa0>
  return 0;
    800031e8:	4501                	li	a0,0
}
    800031ea:	70e2                	ld	ra,56(sp)
    800031ec:	7442                	ld	s0,48(sp)
    800031ee:	74a2                	ld	s1,40(sp)
    800031f0:	7902                	ld	s2,32(sp)
    800031f2:	69e2                	ld	s3,24(sp)
    800031f4:	6a42                	ld	s4,16(sp)
    800031f6:	6121                	addi	sp,sp,64
    800031f8:	8082                	ret

00000000800031fa <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031fa:	711d                	addi	sp,sp,-96
    800031fc:	ec86                	sd	ra,88(sp)
    800031fe:	e8a2                	sd	s0,80(sp)
    80003200:	e4a6                	sd	s1,72(sp)
    80003202:	e0ca                	sd	s2,64(sp)
    80003204:	fc4e                	sd	s3,56(sp)
    80003206:	f852                	sd	s4,48(sp)
    80003208:	f456                	sd	s5,40(sp)
    8000320a:	f05a                	sd	s6,32(sp)
    8000320c:	ec5e                	sd	s7,24(sp)
    8000320e:	e862                	sd	s8,16(sp)
    80003210:	e466                	sd	s9,8(sp)
    80003212:	1080                	addi	s0,sp,96
    80003214:	84aa                	mv	s1,a0
    80003216:	8aae                	mv	s5,a1
    80003218:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000321a:	00054703          	lbu	a4,0(a0)
    8000321e:	02f00793          	li	a5,47
    80003222:	02f70363          	beq	a4,a5,80003248 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003226:	ffffe097          	auipc	ra,0xffffe
    8000322a:	caa080e7          	jalr	-854(ra) # 80000ed0 <myproc>
    8000322e:	15053503          	ld	a0,336(a0)
    80003232:	00000097          	auipc	ra,0x0
    80003236:	9f6080e7          	jalr	-1546(ra) # 80002c28 <idup>
    8000323a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000323c:	02f00913          	li	s2,47
  len = path - s;
    80003240:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003242:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003244:	4b85                	li	s7,1
    80003246:	a865                	j	800032fe <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003248:	4585                	li	a1,1
    8000324a:	4505                	li	a0,1
    8000324c:	fffff097          	auipc	ra,0xfffff
    80003250:	6e2080e7          	jalr	1762(ra) # 8000292e <iget>
    80003254:	89aa                	mv	s3,a0
    80003256:	b7dd                	j	8000323c <namex+0x42>
      iunlockput(ip);
    80003258:	854e                	mv	a0,s3
    8000325a:	00000097          	auipc	ra,0x0
    8000325e:	c6e080e7          	jalr	-914(ra) # 80002ec8 <iunlockput>
      return 0;
    80003262:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003264:	854e                	mv	a0,s3
    80003266:	60e6                	ld	ra,88(sp)
    80003268:	6446                	ld	s0,80(sp)
    8000326a:	64a6                	ld	s1,72(sp)
    8000326c:	6906                	ld	s2,64(sp)
    8000326e:	79e2                	ld	s3,56(sp)
    80003270:	7a42                	ld	s4,48(sp)
    80003272:	7aa2                	ld	s5,40(sp)
    80003274:	7b02                	ld	s6,32(sp)
    80003276:	6be2                	ld	s7,24(sp)
    80003278:	6c42                	ld	s8,16(sp)
    8000327a:	6ca2                	ld	s9,8(sp)
    8000327c:	6125                	addi	sp,sp,96
    8000327e:	8082                	ret
      iunlock(ip);
    80003280:	854e                	mv	a0,s3
    80003282:	00000097          	auipc	ra,0x0
    80003286:	aa6080e7          	jalr	-1370(ra) # 80002d28 <iunlock>
      return ip;
    8000328a:	bfe9                	j	80003264 <namex+0x6a>
      iunlockput(ip);
    8000328c:	854e                	mv	a0,s3
    8000328e:	00000097          	auipc	ra,0x0
    80003292:	c3a080e7          	jalr	-966(ra) # 80002ec8 <iunlockput>
      return 0;
    80003296:	89e6                	mv	s3,s9
    80003298:	b7f1                	j	80003264 <namex+0x6a>
  len = path - s;
    8000329a:	40b48633          	sub	a2,s1,a1
    8000329e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800032a2:	099c5463          	bge	s8,s9,8000332a <namex+0x130>
    memmove(name, s, DIRSIZ);
    800032a6:	4639                	li	a2,14
    800032a8:	8552                	mv	a0,s4
    800032aa:	ffffd097          	auipc	ra,0xffffd
    800032ae:	f50080e7          	jalr	-176(ra) # 800001fa <memmove>
  while(*path == '/')
    800032b2:	0004c783          	lbu	a5,0(s1)
    800032b6:	01279763          	bne	a5,s2,800032c4 <namex+0xca>
    path++;
    800032ba:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032bc:	0004c783          	lbu	a5,0(s1)
    800032c0:	ff278de3          	beq	a5,s2,800032ba <namex+0xc0>
    ilock(ip);
    800032c4:	854e                	mv	a0,s3
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	9a0080e7          	jalr	-1632(ra) # 80002c66 <ilock>
    if(ip->type != T_DIR){
    800032ce:	04499783          	lh	a5,68(s3)
    800032d2:	f97793e3          	bne	a5,s7,80003258 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800032d6:	000a8563          	beqz	s5,800032e0 <namex+0xe6>
    800032da:	0004c783          	lbu	a5,0(s1)
    800032de:	d3cd                	beqz	a5,80003280 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032e0:	865a                	mv	a2,s6
    800032e2:	85d2                	mv	a1,s4
    800032e4:	854e                	mv	a0,s3
    800032e6:	00000097          	auipc	ra,0x0
    800032ea:	e64080e7          	jalr	-412(ra) # 8000314a <dirlookup>
    800032ee:	8caa                	mv	s9,a0
    800032f0:	dd51                	beqz	a0,8000328c <namex+0x92>
    iunlockput(ip);
    800032f2:	854e                	mv	a0,s3
    800032f4:	00000097          	auipc	ra,0x0
    800032f8:	bd4080e7          	jalr	-1068(ra) # 80002ec8 <iunlockput>
    ip = next;
    800032fc:	89e6                	mv	s3,s9
  while(*path == '/')
    800032fe:	0004c783          	lbu	a5,0(s1)
    80003302:	05279763          	bne	a5,s2,80003350 <namex+0x156>
    path++;
    80003306:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003308:	0004c783          	lbu	a5,0(s1)
    8000330c:	ff278de3          	beq	a5,s2,80003306 <namex+0x10c>
  if(*path == 0)
    80003310:	c79d                	beqz	a5,8000333e <namex+0x144>
    path++;
    80003312:	85a6                	mv	a1,s1
  len = path - s;
    80003314:	8cda                	mv	s9,s6
    80003316:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003318:	01278963          	beq	a5,s2,8000332a <namex+0x130>
    8000331c:	dfbd                	beqz	a5,8000329a <namex+0xa0>
    path++;
    8000331e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003320:	0004c783          	lbu	a5,0(s1)
    80003324:	ff279ce3          	bne	a5,s2,8000331c <namex+0x122>
    80003328:	bf8d                	j	8000329a <namex+0xa0>
    memmove(name, s, len);
    8000332a:	2601                	sext.w	a2,a2
    8000332c:	8552                	mv	a0,s4
    8000332e:	ffffd097          	auipc	ra,0xffffd
    80003332:	ecc080e7          	jalr	-308(ra) # 800001fa <memmove>
    name[len] = 0;
    80003336:	9cd2                	add	s9,s9,s4
    80003338:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000333c:	bf9d                	j	800032b2 <namex+0xb8>
  if(nameiparent){
    8000333e:	f20a83e3          	beqz	s5,80003264 <namex+0x6a>
    iput(ip);
    80003342:	854e                	mv	a0,s3
    80003344:	00000097          	auipc	ra,0x0
    80003348:	adc080e7          	jalr	-1316(ra) # 80002e20 <iput>
    return 0;
    8000334c:	4981                	li	s3,0
    8000334e:	bf19                	j	80003264 <namex+0x6a>
  if(*path == 0)
    80003350:	d7fd                	beqz	a5,8000333e <namex+0x144>
  while(*path != '/' && *path != 0)
    80003352:	0004c783          	lbu	a5,0(s1)
    80003356:	85a6                	mv	a1,s1
    80003358:	b7d1                	j	8000331c <namex+0x122>

000000008000335a <dirlink>:
{
    8000335a:	7139                	addi	sp,sp,-64
    8000335c:	fc06                	sd	ra,56(sp)
    8000335e:	f822                	sd	s0,48(sp)
    80003360:	f426                	sd	s1,40(sp)
    80003362:	f04a                	sd	s2,32(sp)
    80003364:	ec4e                	sd	s3,24(sp)
    80003366:	e852                	sd	s4,16(sp)
    80003368:	0080                	addi	s0,sp,64
    8000336a:	892a                	mv	s2,a0
    8000336c:	8a2e                	mv	s4,a1
    8000336e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003370:	4601                	li	a2,0
    80003372:	00000097          	auipc	ra,0x0
    80003376:	dd8080e7          	jalr	-552(ra) # 8000314a <dirlookup>
    8000337a:	e93d                	bnez	a0,800033f0 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000337c:	04c92483          	lw	s1,76(s2)
    80003380:	c49d                	beqz	s1,800033ae <dirlink+0x54>
    80003382:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003384:	4741                	li	a4,16
    80003386:	86a6                	mv	a3,s1
    80003388:	fc040613          	addi	a2,s0,-64
    8000338c:	4581                	li	a1,0
    8000338e:	854a                	mv	a0,s2
    80003390:	00000097          	auipc	ra,0x0
    80003394:	b8a080e7          	jalr	-1142(ra) # 80002f1a <readi>
    80003398:	47c1                	li	a5,16
    8000339a:	06f51163          	bne	a0,a5,800033fc <dirlink+0xa2>
    if(de.inum == 0)
    8000339e:	fc045783          	lhu	a5,-64(s0)
    800033a2:	c791                	beqz	a5,800033ae <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033a4:	24c1                	addiw	s1,s1,16
    800033a6:	04c92783          	lw	a5,76(s2)
    800033aa:	fcf4ede3          	bltu	s1,a5,80003384 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033ae:	4639                	li	a2,14
    800033b0:	85d2                	mv	a1,s4
    800033b2:	fc240513          	addi	a0,s0,-62
    800033b6:	ffffd097          	auipc	ra,0xffffd
    800033ba:	ef4080e7          	jalr	-268(ra) # 800002aa <strncpy>
  de.inum = inum;
    800033be:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033c2:	4741                	li	a4,16
    800033c4:	86a6                	mv	a3,s1
    800033c6:	fc040613          	addi	a2,s0,-64
    800033ca:	4581                	li	a1,0
    800033cc:	854a                	mv	a0,s2
    800033ce:	00000097          	auipc	ra,0x0
    800033d2:	c44080e7          	jalr	-956(ra) # 80003012 <writei>
    800033d6:	1541                	addi	a0,a0,-16
    800033d8:	00a03533          	snez	a0,a0
    800033dc:	40a00533          	neg	a0,a0
}
    800033e0:	70e2                	ld	ra,56(sp)
    800033e2:	7442                	ld	s0,48(sp)
    800033e4:	74a2                	ld	s1,40(sp)
    800033e6:	7902                	ld	s2,32(sp)
    800033e8:	69e2                	ld	s3,24(sp)
    800033ea:	6a42                	ld	s4,16(sp)
    800033ec:	6121                	addi	sp,sp,64
    800033ee:	8082                	ret
    iput(ip);
    800033f0:	00000097          	auipc	ra,0x0
    800033f4:	a30080e7          	jalr	-1488(ra) # 80002e20 <iput>
    return -1;
    800033f8:	557d                	li	a0,-1
    800033fa:	b7dd                	j	800033e0 <dirlink+0x86>
      panic("dirlink read");
    800033fc:	00005517          	auipc	a0,0x5
    80003400:	2b450513          	addi	a0,a0,692 # 800086b0 <syscalls+0x1d8>
    80003404:	00003097          	auipc	ra,0x3
    80003408:	90a080e7          	jalr	-1782(ra) # 80005d0e <panic>

000000008000340c <namei>:

struct inode*
namei(char *path)
{
    8000340c:	1101                	addi	sp,sp,-32
    8000340e:	ec06                	sd	ra,24(sp)
    80003410:	e822                	sd	s0,16(sp)
    80003412:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003414:	fe040613          	addi	a2,s0,-32
    80003418:	4581                	li	a1,0
    8000341a:	00000097          	auipc	ra,0x0
    8000341e:	de0080e7          	jalr	-544(ra) # 800031fa <namex>
}
    80003422:	60e2                	ld	ra,24(sp)
    80003424:	6442                	ld	s0,16(sp)
    80003426:	6105                	addi	sp,sp,32
    80003428:	8082                	ret

000000008000342a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000342a:	1141                	addi	sp,sp,-16
    8000342c:	e406                	sd	ra,8(sp)
    8000342e:	e022                	sd	s0,0(sp)
    80003430:	0800                	addi	s0,sp,16
    80003432:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003434:	4585                	li	a1,1
    80003436:	00000097          	auipc	ra,0x0
    8000343a:	dc4080e7          	jalr	-572(ra) # 800031fa <namex>
}
    8000343e:	60a2                	ld	ra,8(sp)
    80003440:	6402                	ld	s0,0(sp)
    80003442:	0141                	addi	sp,sp,16
    80003444:	8082                	ret

0000000080003446 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003446:	1101                	addi	sp,sp,-32
    80003448:	ec06                	sd	ra,24(sp)
    8000344a:	e822                	sd	s0,16(sp)
    8000344c:	e426                	sd	s1,8(sp)
    8000344e:	e04a                	sd	s2,0(sp)
    80003450:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003452:	00016917          	auipc	s2,0x16
    80003456:	81e90913          	addi	s2,s2,-2018 # 80018c70 <log>
    8000345a:	01892583          	lw	a1,24(s2)
    8000345e:	02892503          	lw	a0,40(s2)
    80003462:	fffff097          	auipc	ra,0xfffff
    80003466:	fea080e7          	jalr	-22(ra) # 8000244c <bread>
    8000346a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000346c:	02c92683          	lw	a3,44(s2)
    80003470:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003472:	02d05763          	blez	a3,800034a0 <write_head+0x5a>
    80003476:	00016797          	auipc	a5,0x16
    8000347a:	82a78793          	addi	a5,a5,-2006 # 80018ca0 <log+0x30>
    8000347e:	05c50713          	addi	a4,a0,92
    80003482:	36fd                	addiw	a3,a3,-1
    80003484:	1682                	slli	a3,a3,0x20
    80003486:	9281                	srli	a3,a3,0x20
    80003488:	068a                	slli	a3,a3,0x2
    8000348a:	00016617          	auipc	a2,0x16
    8000348e:	81a60613          	addi	a2,a2,-2022 # 80018ca4 <log+0x34>
    80003492:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003494:	4390                	lw	a2,0(a5)
    80003496:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003498:	0791                	addi	a5,a5,4
    8000349a:	0711                	addi	a4,a4,4
    8000349c:	fed79ce3          	bne	a5,a3,80003494 <write_head+0x4e>
  }
  bwrite(buf);
    800034a0:	8526                	mv	a0,s1
    800034a2:	fffff097          	auipc	ra,0xfffff
    800034a6:	09c080e7          	jalr	156(ra) # 8000253e <bwrite>
  brelse(buf);
    800034aa:	8526                	mv	a0,s1
    800034ac:	fffff097          	auipc	ra,0xfffff
    800034b0:	0d0080e7          	jalr	208(ra) # 8000257c <brelse>
}
    800034b4:	60e2                	ld	ra,24(sp)
    800034b6:	6442                	ld	s0,16(sp)
    800034b8:	64a2                	ld	s1,8(sp)
    800034ba:	6902                	ld	s2,0(sp)
    800034bc:	6105                	addi	sp,sp,32
    800034be:	8082                	ret

00000000800034c0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034c0:	00015797          	auipc	a5,0x15
    800034c4:	7dc7a783          	lw	a5,2012(a5) # 80018c9c <log+0x2c>
    800034c8:	0af05d63          	blez	a5,80003582 <install_trans+0xc2>
{
    800034cc:	7139                	addi	sp,sp,-64
    800034ce:	fc06                	sd	ra,56(sp)
    800034d0:	f822                	sd	s0,48(sp)
    800034d2:	f426                	sd	s1,40(sp)
    800034d4:	f04a                	sd	s2,32(sp)
    800034d6:	ec4e                	sd	s3,24(sp)
    800034d8:	e852                	sd	s4,16(sp)
    800034da:	e456                	sd	s5,8(sp)
    800034dc:	e05a                	sd	s6,0(sp)
    800034de:	0080                	addi	s0,sp,64
    800034e0:	8b2a                	mv	s6,a0
    800034e2:	00015a97          	auipc	s5,0x15
    800034e6:	7bea8a93          	addi	s5,s5,1982 # 80018ca0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ea:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ec:	00015997          	auipc	s3,0x15
    800034f0:	78498993          	addi	s3,s3,1924 # 80018c70 <log>
    800034f4:	a00d                	j	80003516 <install_trans+0x56>
    brelse(lbuf);
    800034f6:	854a                	mv	a0,s2
    800034f8:	fffff097          	auipc	ra,0xfffff
    800034fc:	084080e7          	jalr	132(ra) # 8000257c <brelse>
    brelse(dbuf);
    80003500:	8526                	mv	a0,s1
    80003502:	fffff097          	auipc	ra,0xfffff
    80003506:	07a080e7          	jalr	122(ra) # 8000257c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000350a:	2a05                	addiw	s4,s4,1
    8000350c:	0a91                	addi	s5,s5,4
    8000350e:	02c9a783          	lw	a5,44(s3)
    80003512:	04fa5e63          	bge	s4,a5,8000356e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003516:	0189a583          	lw	a1,24(s3)
    8000351a:	014585bb          	addw	a1,a1,s4
    8000351e:	2585                	addiw	a1,a1,1
    80003520:	0289a503          	lw	a0,40(s3)
    80003524:	fffff097          	auipc	ra,0xfffff
    80003528:	f28080e7          	jalr	-216(ra) # 8000244c <bread>
    8000352c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000352e:	000aa583          	lw	a1,0(s5)
    80003532:	0289a503          	lw	a0,40(s3)
    80003536:	fffff097          	auipc	ra,0xfffff
    8000353a:	f16080e7          	jalr	-234(ra) # 8000244c <bread>
    8000353e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003540:	40000613          	li	a2,1024
    80003544:	05890593          	addi	a1,s2,88
    80003548:	05850513          	addi	a0,a0,88
    8000354c:	ffffd097          	auipc	ra,0xffffd
    80003550:	cae080e7          	jalr	-850(ra) # 800001fa <memmove>
    bwrite(dbuf);  // write dst to disk
    80003554:	8526                	mv	a0,s1
    80003556:	fffff097          	auipc	ra,0xfffff
    8000355a:	fe8080e7          	jalr	-24(ra) # 8000253e <bwrite>
    if(recovering == 0)
    8000355e:	f80b1ce3          	bnez	s6,800034f6 <install_trans+0x36>
      bunpin(dbuf);
    80003562:	8526                	mv	a0,s1
    80003564:	fffff097          	auipc	ra,0xfffff
    80003568:	0f2080e7          	jalr	242(ra) # 80002656 <bunpin>
    8000356c:	b769                	j	800034f6 <install_trans+0x36>
}
    8000356e:	70e2                	ld	ra,56(sp)
    80003570:	7442                	ld	s0,48(sp)
    80003572:	74a2                	ld	s1,40(sp)
    80003574:	7902                	ld	s2,32(sp)
    80003576:	69e2                	ld	s3,24(sp)
    80003578:	6a42                	ld	s4,16(sp)
    8000357a:	6aa2                	ld	s5,8(sp)
    8000357c:	6b02                	ld	s6,0(sp)
    8000357e:	6121                	addi	sp,sp,64
    80003580:	8082                	ret
    80003582:	8082                	ret

0000000080003584 <initlog>:
{
    80003584:	7179                	addi	sp,sp,-48
    80003586:	f406                	sd	ra,40(sp)
    80003588:	f022                	sd	s0,32(sp)
    8000358a:	ec26                	sd	s1,24(sp)
    8000358c:	e84a                	sd	s2,16(sp)
    8000358e:	e44e                	sd	s3,8(sp)
    80003590:	1800                	addi	s0,sp,48
    80003592:	892a                	mv	s2,a0
    80003594:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003596:	00015497          	auipc	s1,0x15
    8000359a:	6da48493          	addi	s1,s1,1754 # 80018c70 <log>
    8000359e:	00005597          	auipc	a1,0x5
    800035a2:	12258593          	addi	a1,a1,290 # 800086c0 <syscalls+0x1e8>
    800035a6:	8526                	mv	a0,s1
    800035a8:	00003097          	auipc	ra,0x3
    800035ac:	c12080e7          	jalr	-1006(ra) # 800061ba <initlock>
  log.start = sb->logstart;
    800035b0:	0149a583          	lw	a1,20(s3)
    800035b4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035b6:	0109a783          	lw	a5,16(s3)
    800035ba:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035bc:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035c0:	854a                	mv	a0,s2
    800035c2:	fffff097          	auipc	ra,0xfffff
    800035c6:	e8a080e7          	jalr	-374(ra) # 8000244c <bread>
  log.lh.n = lh->n;
    800035ca:	4d34                	lw	a3,88(a0)
    800035cc:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035ce:	02d05563          	blez	a3,800035f8 <initlog+0x74>
    800035d2:	05c50793          	addi	a5,a0,92
    800035d6:	00015717          	auipc	a4,0x15
    800035da:	6ca70713          	addi	a4,a4,1738 # 80018ca0 <log+0x30>
    800035de:	36fd                	addiw	a3,a3,-1
    800035e0:	1682                	slli	a3,a3,0x20
    800035e2:	9281                	srli	a3,a3,0x20
    800035e4:	068a                	slli	a3,a3,0x2
    800035e6:	06050613          	addi	a2,a0,96
    800035ea:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800035ec:	4390                	lw	a2,0(a5)
    800035ee:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035f0:	0791                	addi	a5,a5,4
    800035f2:	0711                	addi	a4,a4,4
    800035f4:	fed79ce3          	bne	a5,a3,800035ec <initlog+0x68>
  brelse(buf);
    800035f8:	fffff097          	auipc	ra,0xfffff
    800035fc:	f84080e7          	jalr	-124(ra) # 8000257c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003600:	4505                	li	a0,1
    80003602:	00000097          	auipc	ra,0x0
    80003606:	ebe080e7          	jalr	-322(ra) # 800034c0 <install_trans>
  log.lh.n = 0;
    8000360a:	00015797          	auipc	a5,0x15
    8000360e:	6807a923          	sw	zero,1682(a5) # 80018c9c <log+0x2c>
  write_head(); // clear the log
    80003612:	00000097          	auipc	ra,0x0
    80003616:	e34080e7          	jalr	-460(ra) # 80003446 <write_head>
}
    8000361a:	70a2                	ld	ra,40(sp)
    8000361c:	7402                	ld	s0,32(sp)
    8000361e:	64e2                	ld	s1,24(sp)
    80003620:	6942                	ld	s2,16(sp)
    80003622:	69a2                	ld	s3,8(sp)
    80003624:	6145                	addi	sp,sp,48
    80003626:	8082                	ret

0000000080003628 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003628:	1101                	addi	sp,sp,-32
    8000362a:	ec06                	sd	ra,24(sp)
    8000362c:	e822                	sd	s0,16(sp)
    8000362e:	e426                	sd	s1,8(sp)
    80003630:	e04a                	sd	s2,0(sp)
    80003632:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003634:	00015517          	auipc	a0,0x15
    80003638:	63c50513          	addi	a0,a0,1596 # 80018c70 <log>
    8000363c:	00003097          	auipc	ra,0x3
    80003640:	c0e080e7          	jalr	-1010(ra) # 8000624a <acquire>
  while(1){
    if(log.committing){
    80003644:	00015497          	auipc	s1,0x15
    80003648:	62c48493          	addi	s1,s1,1580 # 80018c70 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000364c:	4979                	li	s2,30
    8000364e:	a039                	j	8000365c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003650:	85a6                	mv	a1,s1
    80003652:	8526                	mv	a0,s1
    80003654:	ffffe097          	auipc	ra,0xffffe
    80003658:	f30080e7          	jalr	-208(ra) # 80001584 <sleep>
    if(log.committing){
    8000365c:	50dc                	lw	a5,36(s1)
    8000365e:	fbed                	bnez	a5,80003650 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003660:	509c                	lw	a5,32(s1)
    80003662:	0017871b          	addiw	a4,a5,1
    80003666:	0007069b          	sext.w	a3,a4
    8000366a:	0027179b          	slliw	a5,a4,0x2
    8000366e:	9fb9                	addw	a5,a5,a4
    80003670:	0017979b          	slliw	a5,a5,0x1
    80003674:	54d8                	lw	a4,44(s1)
    80003676:	9fb9                	addw	a5,a5,a4
    80003678:	00f95963          	bge	s2,a5,8000368a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000367c:	85a6                	mv	a1,s1
    8000367e:	8526                	mv	a0,s1
    80003680:	ffffe097          	auipc	ra,0xffffe
    80003684:	f04080e7          	jalr	-252(ra) # 80001584 <sleep>
    80003688:	bfd1                	j	8000365c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000368a:	00015517          	auipc	a0,0x15
    8000368e:	5e650513          	addi	a0,a0,1510 # 80018c70 <log>
    80003692:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003694:	00003097          	auipc	ra,0x3
    80003698:	c6a080e7          	jalr	-918(ra) # 800062fe <release>
      break;
    }
  }
}
    8000369c:	60e2                	ld	ra,24(sp)
    8000369e:	6442                	ld	s0,16(sp)
    800036a0:	64a2                	ld	s1,8(sp)
    800036a2:	6902                	ld	s2,0(sp)
    800036a4:	6105                	addi	sp,sp,32
    800036a6:	8082                	ret

00000000800036a8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036a8:	7139                	addi	sp,sp,-64
    800036aa:	fc06                	sd	ra,56(sp)
    800036ac:	f822                	sd	s0,48(sp)
    800036ae:	f426                	sd	s1,40(sp)
    800036b0:	f04a                	sd	s2,32(sp)
    800036b2:	ec4e                	sd	s3,24(sp)
    800036b4:	e852                	sd	s4,16(sp)
    800036b6:	e456                	sd	s5,8(sp)
    800036b8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036ba:	00015497          	auipc	s1,0x15
    800036be:	5b648493          	addi	s1,s1,1462 # 80018c70 <log>
    800036c2:	8526                	mv	a0,s1
    800036c4:	00003097          	auipc	ra,0x3
    800036c8:	b86080e7          	jalr	-1146(ra) # 8000624a <acquire>
  log.outstanding -= 1;
    800036cc:	509c                	lw	a5,32(s1)
    800036ce:	37fd                	addiw	a5,a5,-1
    800036d0:	0007891b          	sext.w	s2,a5
    800036d4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036d6:	50dc                	lw	a5,36(s1)
    800036d8:	e7b9                	bnez	a5,80003726 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036da:	04091e63          	bnez	s2,80003736 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036de:	00015497          	auipc	s1,0x15
    800036e2:	59248493          	addi	s1,s1,1426 # 80018c70 <log>
    800036e6:	4785                	li	a5,1
    800036e8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036ea:	8526                	mv	a0,s1
    800036ec:	00003097          	auipc	ra,0x3
    800036f0:	c12080e7          	jalr	-1006(ra) # 800062fe <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036f4:	54dc                	lw	a5,44(s1)
    800036f6:	06f04763          	bgtz	a5,80003764 <end_op+0xbc>
    acquire(&log.lock);
    800036fa:	00015497          	auipc	s1,0x15
    800036fe:	57648493          	addi	s1,s1,1398 # 80018c70 <log>
    80003702:	8526                	mv	a0,s1
    80003704:	00003097          	auipc	ra,0x3
    80003708:	b46080e7          	jalr	-1210(ra) # 8000624a <acquire>
    log.committing = 0;
    8000370c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003710:	8526                	mv	a0,s1
    80003712:	ffffe097          	auipc	ra,0xffffe
    80003716:	ed6080e7          	jalr	-298(ra) # 800015e8 <wakeup>
    release(&log.lock);
    8000371a:	8526                	mv	a0,s1
    8000371c:	00003097          	auipc	ra,0x3
    80003720:	be2080e7          	jalr	-1054(ra) # 800062fe <release>
}
    80003724:	a03d                	j	80003752 <end_op+0xaa>
    panic("log.committing");
    80003726:	00005517          	auipc	a0,0x5
    8000372a:	fa250513          	addi	a0,a0,-94 # 800086c8 <syscalls+0x1f0>
    8000372e:	00002097          	auipc	ra,0x2
    80003732:	5e0080e7          	jalr	1504(ra) # 80005d0e <panic>
    wakeup(&log);
    80003736:	00015497          	auipc	s1,0x15
    8000373a:	53a48493          	addi	s1,s1,1338 # 80018c70 <log>
    8000373e:	8526                	mv	a0,s1
    80003740:	ffffe097          	auipc	ra,0xffffe
    80003744:	ea8080e7          	jalr	-344(ra) # 800015e8 <wakeup>
  release(&log.lock);
    80003748:	8526                	mv	a0,s1
    8000374a:	00003097          	auipc	ra,0x3
    8000374e:	bb4080e7          	jalr	-1100(ra) # 800062fe <release>
}
    80003752:	70e2                	ld	ra,56(sp)
    80003754:	7442                	ld	s0,48(sp)
    80003756:	74a2                	ld	s1,40(sp)
    80003758:	7902                	ld	s2,32(sp)
    8000375a:	69e2                	ld	s3,24(sp)
    8000375c:	6a42                	ld	s4,16(sp)
    8000375e:	6aa2                	ld	s5,8(sp)
    80003760:	6121                	addi	sp,sp,64
    80003762:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003764:	00015a97          	auipc	s5,0x15
    80003768:	53ca8a93          	addi	s5,s5,1340 # 80018ca0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000376c:	00015a17          	auipc	s4,0x15
    80003770:	504a0a13          	addi	s4,s4,1284 # 80018c70 <log>
    80003774:	018a2583          	lw	a1,24(s4)
    80003778:	012585bb          	addw	a1,a1,s2
    8000377c:	2585                	addiw	a1,a1,1
    8000377e:	028a2503          	lw	a0,40(s4)
    80003782:	fffff097          	auipc	ra,0xfffff
    80003786:	cca080e7          	jalr	-822(ra) # 8000244c <bread>
    8000378a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000378c:	000aa583          	lw	a1,0(s5)
    80003790:	028a2503          	lw	a0,40(s4)
    80003794:	fffff097          	auipc	ra,0xfffff
    80003798:	cb8080e7          	jalr	-840(ra) # 8000244c <bread>
    8000379c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000379e:	40000613          	li	a2,1024
    800037a2:	05850593          	addi	a1,a0,88
    800037a6:	05848513          	addi	a0,s1,88
    800037aa:	ffffd097          	auipc	ra,0xffffd
    800037ae:	a50080e7          	jalr	-1456(ra) # 800001fa <memmove>
    bwrite(to);  // write the log
    800037b2:	8526                	mv	a0,s1
    800037b4:	fffff097          	auipc	ra,0xfffff
    800037b8:	d8a080e7          	jalr	-630(ra) # 8000253e <bwrite>
    brelse(from);
    800037bc:	854e                	mv	a0,s3
    800037be:	fffff097          	auipc	ra,0xfffff
    800037c2:	dbe080e7          	jalr	-578(ra) # 8000257c <brelse>
    brelse(to);
    800037c6:	8526                	mv	a0,s1
    800037c8:	fffff097          	auipc	ra,0xfffff
    800037cc:	db4080e7          	jalr	-588(ra) # 8000257c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037d0:	2905                	addiw	s2,s2,1
    800037d2:	0a91                	addi	s5,s5,4
    800037d4:	02ca2783          	lw	a5,44(s4)
    800037d8:	f8f94ee3          	blt	s2,a5,80003774 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037dc:	00000097          	auipc	ra,0x0
    800037e0:	c6a080e7          	jalr	-918(ra) # 80003446 <write_head>
    install_trans(0); // Now install writes to home locations
    800037e4:	4501                	li	a0,0
    800037e6:	00000097          	auipc	ra,0x0
    800037ea:	cda080e7          	jalr	-806(ra) # 800034c0 <install_trans>
    log.lh.n = 0;
    800037ee:	00015797          	auipc	a5,0x15
    800037f2:	4a07a723          	sw	zero,1198(a5) # 80018c9c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037f6:	00000097          	auipc	ra,0x0
    800037fa:	c50080e7          	jalr	-944(ra) # 80003446 <write_head>
    800037fe:	bdf5                	j	800036fa <end_op+0x52>

0000000080003800 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003800:	1101                	addi	sp,sp,-32
    80003802:	ec06                	sd	ra,24(sp)
    80003804:	e822                	sd	s0,16(sp)
    80003806:	e426                	sd	s1,8(sp)
    80003808:	e04a                	sd	s2,0(sp)
    8000380a:	1000                	addi	s0,sp,32
    8000380c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000380e:	00015917          	auipc	s2,0x15
    80003812:	46290913          	addi	s2,s2,1122 # 80018c70 <log>
    80003816:	854a                	mv	a0,s2
    80003818:	00003097          	auipc	ra,0x3
    8000381c:	a32080e7          	jalr	-1486(ra) # 8000624a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003820:	02c92603          	lw	a2,44(s2)
    80003824:	47f5                	li	a5,29
    80003826:	06c7c563          	blt	a5,a2,80003890 <log_write+0x90>
    8000382a:	00015797          	auipc	a5,0x15
    8000382e:	4627a783          	lw	a5,1122(a5) # 80018c8c <log+0x1c>
    80003832:	37fd                	addiw	a5,a5,-1
    80003834:	04f65e63          	bge	a2,a5,80003890 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003838:	00015797          	auipc	a5,0x15
    8000383c:	4587a783          	lw	a5,1112(a5) # 80018c90 <log+0x20>
    80003840:	06f05063          	blez	a5,800038a0 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003844:	4781                	li	a5,0
    80003846:	06c05563          	blez	a2,800038b0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000384a:	44cc                	lw	a1,12(s1)
    8000384c:	00015717          	auipc	a4,0x15
    80003850:	45470713          	addi	a4,a4,1108 # 80018ca0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003854:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003856:	4314                	lw	a3,0(a4)
    80003858:	04b68c63          	beq	a3,a1,800038b0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000385c:	2785                	addiw	a5,a5,1
    8000385e:	0711                	addi	a4,a4,4
    80003860:	fef61be3          	bne	a2,a5,80003856 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003864:	0621                	addi	a2,a2,8
    80003866:	060a                	slli	a2,a2,0x2
    80003868:	00015797          	auipc	a5,0x15
    8000386c:	40878793          	addi	a5,a5,1032 # 80018c70 <log>
    80003870:	963e                	add	a2,a2,a5
    80003872:	44dc                	lw	a5,12(s1)
    80003874:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003876:	8526                	mv	a0,s1
    80003878:	fffff097          	auipc	ra,0xfffff
    8000387c:	da2080e7          	jalr	-606(ra) # 8000261a <bpin>
    log.lh.n++;
    80003880:	00015717          	auipc	a4,0x15
    80003884:	3f070713          	addi	a4,a4,1008 # 80018c70 <log>
    80003888:	575c                	lw	a5,44(a4)
    8000388a:	2785                	addiw	a5,a5,1
    8000388c:	d75c                	sw	a5,44(a4)
    8000388e:	a835                	j	800038ca <log_write+0xca>
    panic("too big a transaction");
    80003890:	00005517          	auipc	a0,0x5
    80003894:	e4850513          	addi	a0,a0,-440 # 800086d8 <syscalls+0x200>
    80003898:	00002097          	auipc	ra,0x2
    8000389c:	476080e7          	jalr	1142(ra) # 80005d0e <panic>
    panic("log_write outside of trans");
    800038a0:	00005517          	auipc	a0,0x5
    800038a4:	e5050513          	addi	a0,a0,-432 # 800086f0 <syscalls+0x218>
    800038a8:	00002097          	auipc	ra,0x2
    800038ac:	466080e7          	jalr	1126(ra) # 80005d0e <panic>
  log.lh.block[i] = b->blockno;
    800038b0:	00878713          	addi	a4,a5,8
    800038b4:	00271693          	slli	a3,a4,0x2
    800038b8:	00015717          	auipc	a4,0x15
    800038bc:	3b870713          	addi	a4,a4,952 # 80018c70 <log>
    800038c0:	9736                	add	a4,a4,a3
    800038c2:	44d4                	lw	a3,12(s1)
    800038c4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038c6:	faf608e3          	beq	a2,a5,80003876 <log_write+0x76>
  }
  release(&log.lock);
    800038ca:	00015517          	auipc	a0,0x15
    800038ce:	3a650513          	addi	a0,a0,934 # 80018c70 <log>
    800038d2:	00003097          	auipc	ra,0x3
    800038d6:	a2c080e7          	jalr	-1492(ra) # 800062fe <release>
}
    800038da:	60e2                	ld	ra,24(sp)
    800038dc:	6442                	ld	s0,16(sp)
    800038de:	64a2                	ld	s1,8(sp)
    800038e0:	6902                	ld	s2,0(sp)
    800038e2:	6105                	addi	sp,sp,32
    800038e4:	8082                	ret

00000000800038e6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038e6:	1101                	addi	sp,sp,-32
    800038e8:	ec06                	sd	ra,24(sp)
    800038ea:	e822                	sd	s0,16(sp)
    800038ec:	e426                	sd	s1,8(sp)
    800038ee:	e04a                	sd	s2,0(sp)
    800038f0:	1000                	addi	s0,sp,32
    800038f2:	84aa                	mv	s1,a0
    800038f4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038f6:	00005597          	auipc	a1,0x5
    800038fa:	e1a58593          	addi	a1,a1,-486 # 80008710 <syscalls+0x238>
    800038fe:	0521                	addi	a0,a0,8
    80003900:	00003097          	auipc	ra,0x3
    80003904:	8ba080e7          	jalr	-1862(ra) # 800061ba <initlock>
  lk->name = name;
    80003908:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000390c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003910:	0204a423          	sw	zero,40(s1)
}
    80003914:	60e2                	ld	ra,24(sp)
    80003916:	6442                	ld	s0,16(sp)
    80003918:	64a2                	ld	s1,8(sp)
    8000391a:	6902                	ld	s2,0(sp)
    8000391c:	6105                	addi	sp,sp,32
    8000391e:	8082                	ret

0000000080003920 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003920:	1101                	addi	sp,sp,-32
    80003922:	ec06                	sd	ra,24(sp)
    80003924:	e822                	sd	s0,16(sp)
    80003926:	e426                	sd	s1,8(sp)
    80003928:	e04a                	sd	s2,0(sp)
    8000392a:	1000                	addi	s0,sp,32
    8000392c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000392e:	00850913          	addi	s2,a0,8
    80003932:	854a                	mv	a0,s2
    80003934:	00003097          	auipc	ra,0x3
    80003938:	916080e7          	jalr	-1770(ra) # 8000624a <acquire>
  while (lk->locked) {
    8000393c:	409c                	lw	a5,0(s1)
    8000393e:	cb89                	beqz	a5,80003950 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003940:	85ca                	mv	a1,s2
    80003942:	8526                	mv	a0,s1
    80003944:	ffffe097          	auipc	ra,0xffffe
    80003948:	c40080e7          	jalr	-960(ra) # 80001584 <sleep>
  while (lk->locked) {
    8000394c:	409c                	lw	a5,0(s1)
    8000394e:	fbed                	bnez	a5,80003940 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003950:	4785                	li	a5,1
    80003952:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003954:	ffffd097          	auipc	ra,0xffffd
    80003958:	57c080e7          	jalr	1404(ra) # 80000ed0 <myproc>
    8000395c:	591c                	lw	a5,48(a0)
    8000395e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003960:	854a                	mv	a0,s2
    80003962:	00003097          	auipc	ra,0x3
    80003966:	99c080e7          	jalr	-1636(ra) # 800062fe <release>
}
    8000396a:	60e2                	ld	ra,24(sp)
    8000396c:	6442                	ld	s0,16(sp)
    8000396e:	64a2                	ld	s1,8(sp)
    80003970:	6902                	ld	s2,0(sp)
    80003972:	6105                	addi	sp,sp,32
    80003974:	8082                	ret

0000000080003976 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003976:	1101                	addi	sp,sp,-32
    80003978:	ec06                	sd	ra,24(sp)
    8000397a:	e822                	sd	s0,16(sp)
    8000397c:	e426                	sd	s1,8(sp)
    8000397e:	e04a                	sd	s2,0(sp)
    80003980:	1000                	addi	s0,sp,32
    80003982:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003984:	00850913          	addi	s2,a0,8
    80003988:	854a                	mv	a0,s2
    8000398a:	00003097          	auipc	ra,0x3
    8000398e:	8c0080e7          	jalr	-1856(ra) # 8000624a <acquire>
  lk->locked = 0;
    80003992:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003996:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000399a:	8526                	mv	a0,s1
    8000399c:	ffffe097          	auipc	ra,0xffffe
    800039a0:	c4c080e7          	jalr	-948(ra) # 800015e8 <wakeup>
  release(&lk->lk);
    800039a4:	854a                	mv	a0,s2
    800039a6:	00003097          	auipc	ra,0x3
    800039aa:	958080e7          	jalr	-1704(ra) # 800062fe <release>
}
    800039ae:	60e2                	ld	ra,24(sp)
    800039b0:	6442                	ld	s0,16(sp)
    800039b2:	64a2                	ld	s1,8(sp)
    800039b4:	6902                	ld	s2,0(sp)
    800039b6:	6105                	addi	sp,sp,32
    800039b8:	8082                	ret

00000000800039ba <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039ba:	7179                	addi	sp,sp,-48
    800039bc:	f406                	sd	ra,40(sp)
    800039be:	f022                	sd	s0,32(sp)
    800039c0:	ec26                	sd	s1,24(sp)
    800039c2:	e84a                	sd	s2,16(sp)
    800039c4:	e44e                	sd	s3,8(sp)
    800039c6:	1800                	addi	s0,sp,48
    800039c8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039ca:	00850913          	addi	s2,a0,8
    800039ce:	854a                	mv	a0,s2
    800039d0:	00003097          	auipc	ra,0x3
    800039d4:	87a080e7          	jalr	-1926(ra) # 8000624a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039d8:	409c                	lw	a5,0(s1)
    800039da:	ef99                	bnez	a5,800039f8 <holdingsleep+0x3e>
    800039dc:	4481                	li	s1,0
  release(&lk->lk);
    800039de:	854a                	mv	a0,s2
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	91e080e7          	jalr	-1762(ra) # 800062fe <release>
  return r;
}
    800039e8:	8526                	mv	a0,s1
    800039ea:	70a2                	ld	ra,40(sp)
    800039ec:	7402                	ld	s0,32(sp)
    800039ee:	64e2                	ld	s1,24(sp)
    800039f0:	6942                	ld	s2,16(sp)
    800039f2:	69a2                	ld	s3,8(sp)
    800039f4:	6145                	addi	sp,sp,48
    800039f6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039f8:	0284a983          	lw	s3,40(s1)
    800039fc:	ffffd097          	auipc	ra,0xffffd
    80003a00:	4d4080e7          	jalr	1236(ra) # 80000ed0 <myproc>
    80003a04:	5904                	lw	s1,48(a0)
    80003a06:	413484b3          	sub	s1,s1,s3
    80003a0a:	0014b493          	seqz	s1,s1
    80003a0e:	bfc1                	j	800039de <holdingsleep+0x24>

0000000080003a10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a10:	1141                	addi	sp,sp,-16
    80003a12:	e406                	sd	ra,8(sp)
    80003a14:	e022                	sd	s0,0(sp)
    80003a16:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a18:	00005597          	auipc	a1,0x5
    80003a1c:	d0858593          	addi	a1,a1,-760 # 80008720 <syscalls+0x248>
    80003a20:	00015517          	auipc	a0,0x15
    80003a24:	39850513          	addi	a0,a0,920 # 80018db8 <ftable>
    80003a28:	00002097          	auipc	ra,0x2
    80003a2c:	792080e7          	jalr	1938(ra) # 800061ba <initlock>
}
    80003a30:	60a2                	ld	ra,8(sp)
    80003a32:	6402                	ld	s0,0(sp)
    80003a34:	0141                	addi	sp,sp,16
    80003a36:	8082                	ret

0000000080003a38 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a38:	1101                	addi	sp,sp,-32
    80003a3a:	ec06                	sd	ra,24(sp)
    80003a3c:	e822                	sd	s0,16(sp)
    80003a3e:	e426                	sd	s1,8(sp)
    80003a40:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a42:	00015517          	auipc	a0,0x15
    80003a46:	37650513          	addi	a0,a0,886 # 80018db8 <ftable>
    80003a4a:	00003097          	auipc	ra,0x3
    80003a4e:	800080e7          	jalr	-2048(ra) # 8000624a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a52:	00015497          	auipc	s1,0x15
    80003a56:	37e48493          	addi	s1,s1,894 # 80018dd0 <ftable+0x18>
    80003a5a:	00016717          	auipc	a4,0x16
    80003a5e:	31670713          	addi	a4,a4,790 # 80019d70 <disk>
    if(f->ref == 0){
    80003a62:	40dc                	lw	a5,4(s1)
    80003a64:	cf99                	beqz	a5,80003a82 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a66:	02848493          	addi	s1,s1,40
    80003a6a:	fee49ce3          	bne	s1,a4,80003a62 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a6e:	00015517          	auipc	a0,0x15
    80003a72:	34a50513          	addi	a0,a0,842 # 80018db8 <ftable>
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	888080e7          	jalr	-1912(ra) # 800062fe <release>
  return 0;
    80003a7e:	4481                	li	s1,0
    80003a80:	a819                	j	80003a96 <filealloc+0x5e>
      f->ref = 1;
    80003a82:	4785                	li	a5,1
    80003a84:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a86:	00015517          	auipc	a0,0x15
    80003a8a:	33250513          	addi	a0,a0,818 # 80018db8 <ftable>
    80003a8e:	00003097          	auipc	ra,0x3
    80003a92:	870080e7          	jalr	-1936(ra) # 800062fe <release>
}
    80003a96:	8526                	mv	a0,s1
    80003a98:	60e2                	ld	ra,24(sp)
    80003a9a:	6442                	ld	s0,16(sp)
    80003a9c:	64a2                	ld	s1,8(sp)
    80003a9e:	6105                	addi	sp,sp,32
    80003aa0:	8082                	ret

0000000080003aa2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003aa2:	1101                	addi	sp,sp,-32
    80003aa4:	ec06                	sd	ra,24(sp)
    80003aa6:	e822                	sd	s0,16(sp)
    80003aa8:	e426                	sd	s1,8(sp)
    80003aaa:	1000                	addi	s0,sp,32
    80003aac:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003aae:	00015517          	auipc	a0,0x15
    80003ab2:	30a50513          	addi	a0,a0,778 # 80018db8 <ftable>
    80003ab6:	00002097          	auipc	ra,0x2
    80003aba:	794080e7          	jalr	1940(ra) # 8000624a <acquire>
  if(f->ref < 1)
    80003abe:	40dc                	lw	a5,4(s1)
    80003ac0:	02f05263          	blez	a5,80003ae4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ac4:	2785                	addiw	a5,a5,1
    80003ac6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ac8:	00015517          	auipc	a0,0x15
    80003acc:	2f050513          	addi	a0,a0,752 # 80018db8 <ftable>
    80003ad0:	00003097          	auipc	ra,0x3
    80003ad4:	82e080e7          	jalr	-2002(ra) # 800062fe <release>
  return f;
}
    80003ad8:	8526                	mv	a0,s1
    80003ada:	60e2                	ld	ra,24(sp)
    80003adc:	6442                	ld	s0,16(sp)
    80003ade:	64a2                	ld	s1,8(sp)
    80003ae0:	6105                	addi	sp,sp,32
    80003ae2:	8082                	ret
    panic("filedup");
    80003ae4:	00005517          	auipc	a0,0x5
    80003ae8:	c4450513          	addi	a0,a0,-956 # 80008728 <syscalls+0x250>
    80003aec:	00002097          	auipc	ra,0x2
    80003af0:	222080e7          	jalr	546(ra) # 80005d0e <panic>

0000000080003af4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003af4:	7139                	addi	sp,sp,-64
    80003af6:	fc06                	sd	ra,56(sp)
    80003af8:	f822                	sd	s0,48(sp)
    80003afa:	f426                	sd	s1,40(sp)
    80003afc:	f04a                	sd	s2,32(sp)
    80003afe:	ec4e                	sd	s3,24(sp)
    80003b00:	e852                	sd	s4,16(sp)
    80003b02:	e456                	sd	s5,8(sp)
    80003b04:	0080                	addi	s0,sp,64
    80003b06:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b08:	00015517          	auipc	a0,0x15
    80003b0c:	2b050513          	addi	a0,a0,688 # 80018db8 <ftable>
    80003b10:	00002097          	auipc	ra,0x2
    80003b14:	73a080e7          	jalr	1850(ra) # 8000624a <acquire>
  if(f->ref < 1)
    80003b18:	40dc                	lw	a5,4(s1)
    80003b1a:	06f05163          	blez	a5,80003b7c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b1e:	37fd                	addiw	a5,a5,-1
    80003b20:	0007871b          	sext.w	a4,a5
    80003b24:	c0dc                	sw	a5,4(s1)
    80003b26:	06e04363          	bgtz	a4,80003b8c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b2a:	0004a903          	lw	s2,0(s1)
    80003b2e:	0094ca83          	lbu	s5,9(s1)
    80003b32:	0104ba03          	ld	s4,16(s1)
    80003b36:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b3a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b3e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b42:	00015517          	auipc	a0,0x15
    80003b46:	27650513          	addi	a0,a0,630 # 80018db8 <ftable>
    80003b4a:	00002097          	auipc	ra,0x2
    80003b4e:	7b4080e7          	jalr	1972(ra) # 800062fe <release>

  if(ff.type == FD_PIPE){
    80003b52:	4785                	li	a5,1
    80003b54:	04f90d63          	beq	s2,a5,80003bae <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b58:	3979                	addiw	s2,s2,-2
    80003b5a:	4785                	li	a5,1
    80003b5c:	0527e063          	bltu	a5,s2,80003b9c <fileclose+0xa8>
    begin_op();
    80003b60:	00000097          	auipc	ra,0x0
    80003b64:	ac8080e7          	jalr	-1336(ra) # 80003628 <begin_op>
    iput(ff.ip);
    80003b68:	854e                	mv	a0,s3
    80003b6a:	fffff097          	auipc	ra,0xfffff
    80003b6e:	2b6080e7          	jalr	694(ra) # 80002e20 <iput>
    end_op();
    80003b72:	00000097          	auipc	ra,0x0
    80003b76:	b36080e7          	jalr	-1226(ra) # 800036a8 <end_op>
    80003b7a:	a00d                	j	80003b9c <fileclose+0xa8>
    panic("fileclose");
    80003b7c:	00005517          	auipc	a0,0x5
    80003b80:	bb450513          	addi	a0,a0,-1100 # 80008730 <syscalls+0x258>
    80003b84:	00002097          	auipc	ra,0x2
    80003b88:	18a080e7          	jalr	394(ra) # 80005d0e <panic>
    release(&ftable.lock);
    80003b8c:	00015517          	auipc	a0,0x15
    80003b90:	22c50513          	addi	a0,a0,556 # 80018db8 <ftable>
    80003b94:	00002097          	auipc	ra,0x2
    80003b98:	76a080e7          	jalr	1898(ra) # 800062fe <release>
  }
}
    80003b9c:	70e2                	ld	ra,56(sp)
    80003b9e:	7442                	ld	s0,48(sp)
    80003ba0:	74a2                	ld	s1,40(sp)
    80003ba2:	7902                	ld	s2,32(sp)
    80003ba4:	69e2                	ld	s3,24(sp)
    80003ba6:	6a42                	ld	s4,16(sp)
    80003ba8:	6aa2                	ld	s5,8(sp)
    80003baa:	6121                	addi	sp,sp,64
    80003bac:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bae:	85d6                	mv	a1,s5
    80003bb0:	8552                	mv	a0,s4
    80003bb2:	00000097          	auipc	ra,0x0
    80003bb6:	34c080e7          	jalr	844(ra) # 80003efe <pipeclose>
    80003bba:	b7cd                	j	80003b9c <fileclose+0xa8>

0000000080003bbc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bbc:	715d                	addi	sp,sp,-80
    80003bbe:	e486                	sd	ra,72(sp)
    80003bc0:	e0a2                	sd	s0,64(sp)
    80003bc2:	fc26                	sd	s1,56(sp)
    80003bc4:	f84a                	sd	s2,48(sp)
    80003bc6:	f44e                	sd	s3,40(sp)
    80003bc8:	0880                	addi	s0,sp,80
    80003bca:	84aa                	mv	s1,a0
    80003bcc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bce:	ffffd097          	auipc	ra,0xffffd
    80003bd2:	302080e7          	jalr	770(ra) # 80000ed0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bd6:	409c                	lw	a5,0(s1)
    80003bd8:	37f9                	addiw	a5,a5,-2
    80003bda:	4705                	li	a4,1
    80003bdc:	04f76763          	bltu	a4,a5,80003c2a <filestat+0x6e>
    80003be0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003be2:	6c88                	ld	a0,24(s1)
    80003be4:	fffff097          	auipc	ra,0xfffff
    80003be8:	082080e7          	jalr	130(ra) # 80002c66 <ilock>
    stati(f->ip, &st);
    80003bec:	fb840593          	addi	a1,s0,-72
    80003bf0:	6c88                	ld	a0,24(s1)
    80003bf2:	fffff097          	auipc	ra,0xfffff
    80003bf6:	2fe080e7          	jalr	766(ra) # 80002ef0 <stati>
    iunlock(f->ip);
    80003bfa:	6c88                	ld	a0,24(s1)
    80003bfc:	fffff097          	auipc	ra,0xfffff
    80003c00:	12c080e7          	jalr	300(ra) # 80002d28 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c04:	46e1                	li	a3,24
    80003c06:	fb840613          	addi	a2,s0,-72
    80003c0a:	85ce                	mv	a1,s3
    80003c0c:	05093503          	ld	a0,80(s2)
    80003c10:	ffffd097          	auipc	ra,0xffffd
    80003c14:	f48080e7          	jalr	-184(ra) # 80000b58 <copyout>
    80003c18:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c1c:	60a6                	ld	ra,72(sp)
    80003c1e:	6406                	ld	s0,64(sp)
    80003c20:	74e2                	ld	s1,56(sp)
    80003c22:	7942                	ld	s2,48(sp)
    80003c24:	79a2                	ld	s3,40(sp)
    80003c26:	6161                	addi	sp,sp,80
    80003c28:	8082                	ret
  return -1;
    80003c2a:	557d                	li	a0,-1
    80003c2c:	bfc5                	j	80003c1c <filestat+0x60>

0000000080003c2e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c2e:	7179                	addi	sp,sp,-48
    80003c30:	f406                	sd	ra,40(sp)
    80003c32:	f022                	sd	s0,32(sp)
    80003c34:	ec26                	sd	s1,24(sp)
    80003c36:	e84a                	sd	s2,16(sp)
    80003c38:	e44e                	sd	s3,8(sp)
    80003c3a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c3c:	00854783          	lbu	a5,8(a0)
    80003c40:	c3d5                	beqz	a5,80003ce4 <fileread+0xb6>
    80003c42:	84aa                	mv	s1,a0
    80003c44:	89ae                	mv	s3,a1
    80003c46:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c48:	411c                	lw	a5,0(a0)
    80003c4a:	4705                	li	a4,1
    80003c4c:	04e78963          	beq	a5,a4,80003c9e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c50:	470d                	li	a4,3
    80003c52:	04e78d63          	beq	a5,a4,80003cac <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c56:	4709                	li	a4,2
    80003c58:	06e79e63          	bne	a5,a4,80003cd4 <fileread+0xa6>
    ilock(f->ip);
    80003c5c:	6d08                	ld	a0,24(a0)
    80003c5e:	fffff097          	auipc	ra,0xfffff
    80003c62:	008080e7          	jalr	8(ra) # 80002c66 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c66:	874a                	mv	a4,s2
    80003c68:	5094                	lw	a3,32(s1)
    80003c6a:	864e                	mv	a2,s3
    80003c6c:	4585                	li	a1,1
    80003c6e:	6c88                	ld	a0,24(s1)
    80003c70:	fffff097          	auipc	ra,0xfffff
    80003c74:	2aa080e7          	jalr	682(ra) # 80002f1a <readi>
    80003c78:	892a                	mv	s2,a0
    80003c7a:	00a05563          	blez	a0,80003c84 <fileread+0x56>
      f->off += r;
    80003c7e:	509c                	lw	a5,32(s1)
    80003c80:	9fa9                	addw	a5,a5,a0
    80003c82:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c84:	6c88                	ld	a0,24(s1)
    80003c86:	fffff097          	auipc	ra,0xfffff
    80003c8a:	0a2080e7          	jalr	162(ra) # 80002d28 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c8e:	854a                	mv	a0,s2
    80003c90:	70a2                	ld	ra,40(sp)
    80003c92:	7402                	ld	s0,32(sp)
    80003c94:	64e2                	ld	s1,24(sp)
    80003c96:	6942                	ld	s2,16(sp)
    80003c98:	69a2                	ld	s3,8(sp)
    80003c9a:	6145                	addi	sp,sp,48
    80003c9c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c9e:	6908                	ld	a0,16(a0)
    80003ca0:	00000097          	auipc	ra,0x0
    80003ca4:	3c6080e7          	jalr	966(ra) # 80004066 <piperead>
    80003ca8:	892a                	mv	s2,a0
    80003caa:	b7d5                	j	80003c8e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cac:	02451783          	lh	a5,36(a0)
    80003cb0:	03079693          	slli	a3,a5,0x30
    80003cb4:	92c1                	srli	a3,a3,0x30
    80003cb6:	4725                	li	a4,9
    80003cb8:	02d76863          	bltu	a4,a3,80003ce8 <fileread+0xba>
    80003cbc:	0792                	slli	a5,a5,0x4
    80003cbe:	00015717          	auipc	a4,0x15
    80003cc2:	05a70713          	addi	a4,a4,90 # 80018d18 <devsw>
    80003cc6:	97ba                	add	a5,a5,a4
    80003cc8:	639c                	ld	a5,0(a5)
    80003cca:	c38d                	beqz	a5,80003cec <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ccc:	4505                	li	a0,1
    80003cce:	9782                	jalr	a5
    80003cd0:	892a                	mv	s2,a0
    80003cd2:	bf75                	j	80003c8e <fileread+0x60>
    panic("fileread");
    80003cd4:	00005517          	auipc	a0,0x5
    80003cd8:	a6c50513          	addi	a0,a0,-1428 # 80008740 <syscalls+0x268>
    80003cdc:	00002097          	auipc	ra,0x2
    80003ce0:	032080e7          	jalr	50(ra) # 80005d0e <panic>
    return -1;
    80003ce4:	597d                	li	s2,-1
    80003ce6:	b765                	j	80003c8e <fileread+0x60>
      return -1;
    80003ce8:	597d                	li	s2,-1
    80003cea:	b755                	j	80003c8e <fileread+0x60>
    80003cec:	597d                	li	s2,-1
    80003cee:	b745                	j	80003c8e <fileread+0x60>

0000000080003cf0 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003cf0:	715d                	addi	sp,sp,-80
    80003cf2:	e486                	sd	ra,72(sp)
    80003cf4:	e0a2                	sd	s0,64(sp)
    80003cf6:	fc26                	sd	s1,56(sp)
    80003cf8:	f84a                	sd	s2,48(sp)
    80003cfa:	f44e                	sd	s3,40(sp)
    80003cfc:	f052                	sd	s4,32(sp)
    80003cfe:	ec56                	sd	s5,24(sp)
    80003d00:	e85a                	sd	s6,16(sp)
    80003d02:	e45e                	sd	s7,8(sp)
    80003d04:	e062                	sd	s8,0(sp)
    80003d06:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d08:	00954783          	lbu	a5,9(a0)
    80003d0c:	10078663          	beqz	a5,80003e18 <filewrite+0x128>
    80003d10:	892a                	mv	s2,a0
    80003d12:	8aae                	mv	s5,a1
    80003d14:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d16:	411c                	lw	a5,0(a0)
    80003d18:	4705                	li	a4,1
    80003d1a:	02e78263          	beq	a5,a4,80003d3e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d1e:	470d                	li	a4,3
    80003d20:	02e78663          	beq	a5,a4,80003d4c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d24:	4709                	li	a4,2
    80003d26:	0ee79163          	bne	a5,a4,80003e08 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d2a:	0ac05d63          	blez	a2,80003de4 <filewrite+0xf4>
    int i = 0;
    80003d2e:	4981                	li	s3,0
    80003d30:	6b05                	lui	s6,0x1
    80003d32:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d36:	6b85                	lui	s7,0x1
    80003d38:	c00b8b9b          	addiw	s7,s7,-1024
    80003d3c:	a861                	j	80003dd4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d3e:	6908                	ld	a0,16(a0)
    80003d40:	00000097          	auipc	ra,0x0
    80003d44:	22e080e7          	jalr	558(ra) # 80003f6e <pipewrite>
    80003d48:	8a2a                	mv	s4,a0
    80003d4a:	a045                	j	80003dea <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d4c:	02451783          	lh	a5,36(a0)
    80003d50:	03079693          	slli	a3,a5,0x30
    80003d54:	92c1                	srli	a3,a3,0x30
    80003d56:	4725                	li	a4,9
    80003d58:	0cd76263          	bltu	a4,a3,80003e1c <filewrite+0x12c>
    80003d5c:	0792                	slli	a5,a5,0x4
    80003d5e:	00015717          	auipc	a4,0x15
    80003d62:	fba70713          	addi	a4,a4,-70 # 80018d18 <devsw>
    80003d66:	97ba                	add	a5,a5,a4
    80003d68:	679c                	ld	a5,8(a5)
    80003d6a:	cbdd                	beqz	a5,80003e20 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d6c:	4505                	li	a0,1
    80003d6e:	9782                	jalr	a5
    80003d70:	8a2a                	mv	s4,a0
    80003d72:	a8a5                	j	80003dea <filewrite+0xfa>
    80003d74:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d78:	00000097          	auipc	ra,0x0
    80003d7c:	8b0080e7          	jalr	-1872(ra) # 80003628 <begin_op>
      ilock(f->ip);
    80003d80:	01893503          	ld	a0,24(s2)
    80003d84:	fffff097          	auipc	ra,0xfffff
    80003d88:	ee2080e7          	jalr	-286(ra) # 80002c66 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d8c:	8762                	mv	a4,s8
    80003d8e:	02092683          	lw	a3,32(s2)
    80003d92:	01598633          	add	a2,s3,s5
    80003d96:	4585                	li	a1,1
    80003d98:	01893503          	ld	a0,24(s2)
    80003d9c:	fffff097          	auipc	ra,0xfffff
    80003da0:	276080e7          	jalr	630(ra) # 80003012 <writei>
    80003da4:	84aa                	mv	s1,a0
    80003da6:	00a05763          	blez	a0,80003db4 <filewrite+0xc4>
        f->off += r;
    80003daa:	02092783          	lw	a5,32(s2)
    80003dae:	9fa9                	addw	a5,a5,a0
    80003db0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003db4:	01893503          	ld	a0,24(s2)
    80003db8:	fffff097          	auipc	ra,0xfffff
    80003dbc:	f70080e7          	jalr	-144(ra) # 80002d28 <iunlock>
      end_op();
    80003dc0:	00000097          	auipc	ra,0x0
    80003dc4:	8e8080e7          	jalr	-1816(ra) # 800036a8 <end_op>

      if(r != n1){
    80003dc8:	009c1f63          	bne	s8,s1,80003de6 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003dcc:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dd0:	0149db63          	bge	s3,s4,80003de6 <filewrite+0xf6>
      int n1 = n - i;
    80003dd4:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003dd8:	84be                	mv	s1,a5
    80003dda:	2781                	sext.w	a5,a5
    80003ddc:	f8fb5ce3          	bge	s6,a5,80003d74 <filewrite+0x84>
    80003de0:	84de                	mv	s1,s7
    80003de2:	bf49                	j	80003d74 <filewrite+0x84>
    int i = 0;
    80003de4:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003de6:	013a1f63          	bne	s4,s3,80003e04 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dea:	8552                	mv	a0,s4
    80003dec:	60a6                	ld	ra,72(sp)
    80003dee:	6406                	ld	s0,64(sp)
    80003df0:	74e2                	ld	s1,56(sp)
    80003df2:	7942                	ld	s2,48(sp)
    80003df4:	79a2                	ld	s3,40(sp)
    80003df6:	7a02                	ld	s4,32(sp)
    80003df8:	6ae2                	ld	s5,24(sp)
    80003dfa:	6b42                	ld	s6,16(sp)
    80003dfc:	6ba2                	ld	s7,8(sp)
    80003dfe:	6c02                	ld	s8,0(sp)
    80003e00:	6161                	addi	sp,sp,80
    80003e02:	8082                	ret
    ret = (i == n ? n : -1);
    80003e04:	5a7d                	li	s4,-1
    80003e06:	b7d5                	j	80003dea <filewrite+0xfa>
    panic("filewrite");
    80003e08:	00005517          	auipc	a0,0x5
    80003e0c:	94850513          	addi	a0,a0,-1720 # 80008750 <syscalls+0x278>
    80003e10:	00002097          	auipc	ra,0x2
    80003e14:	efe080e7          	jalr	-258(ra) # 80005d0e <panic>
    return -1;
    80003e18:	5a7d                	li	s4,-1
    80003e1a:	bfc1                	j	80003dea <filewrite+0xfa>
      return -1;
    80003e1c:	5a7d                	li	s4,-1
    80003e1e:	b7f1                	j	80003dea <filewrite+0xfa>
    80003e20:	5a7d                	li	s4,-1
    80003e22:	b7e1                	j	80003dea <filewrite+0xfa>

0000000080003e24 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e24:	7179                	addi	sp,sp,-48
    80003e26:	f406                	sd	ra,40(sp)
    80003e28:	f022                	sd	s0,32(sp)
    80003e2a:	ec26                	sd	s1,24(sp)
    80003e2c:	e84a                	sd	s2,16(sp)
    80003e2e:	e44e                	sd	s3,8(sp)
    80003e30:	e052                	sd	s4,0(sp)
    80003e32:	1800                	addi	s0,sp,48
    80003e34:	84aa                	mv	s1,a0
    80003e36:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e38:	0005b023          	sd	zero,0(a1)
    80003e3c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e40:	00000097          	auipc	ra,0x0
    80003e44:	bf8080e7          	jalr	-1032(ra) # 80003a38 <filealloc>
    80003e48:	e088                	sd	a0,0(s1)
    80003e4a:	c551                	beqz	a0,80003ed6 <pipealloc+0xb2>
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	bec080e7          	jalr	-1044(ra) # 80003a38 <filealloc>
    80003e54:	00aa3023          	sd	a0,0(s4)
    80003e58:	c92d                	beqz	a0,80003eca <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e5a:	ffffc097          	auipc	ra,0xffffc
    80003e5e:	2be080e7          	jalr	702(ra) # 80000118 <kalloc>
    80003e62:	892a                	mv	s2,a0
    80003e64:	c125                	beqz	a0,80003ec4 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e66:	4985                	li	s3,1
    80003e68:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e6c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e70:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e74:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e78:	00004597          	auipc	a1,0x4
    80003e7c:	5b058593          	addi	a1,a1,1456 # 80008428 <states.0+0x1a0>
    80003e80:	00002097          	auipc	ra,0x2
    80003e84:	33a080e7          	jalr	826(ra) # 800061ba <initlock>
  (*f0)->type = FD_PIPE;
    80003e88:	609c                	ld	a5,0(s1)
    80003e8a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e8e:	609c                	ld	a5,0(s1)
    80003e90:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e94:	609c                	ld	a5,0(s1)
    80003e96:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e9a:	609c                	ld	a5,0(s1)
    80003e9c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ea0:	000a3783          	ld	a5,0(s4)
    80003ea4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ea8:	000a3783          	ld	a5,0(s4)
    80003eac:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003eb0:	000a3783          	ld	a5,0(s4)
    80003eb4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003eb8:	000a3783          	ld	a5,0(s4)
    80003ebc:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ec0:	4501                	li	a0,0
    80003ec2:	a025                	j	80003eea <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ec4:	6088                	ld	a0,0(s1)
    80003ec6:	e501                	bnez	a0,80003ece <pipealloc+0xaa>
    80003ec8:	a039                	j	80003ed6 <pipealloc+0xb2>
    80003eca:	6088                	ld	a0,0(s1)
    80003ecc:	c51d                	beqz	a0,80003efa <pipealloc+0xd6>
    fileclose(*f0);
    80003ece:	00000097          	auipc	ra,0x0
    80003ed2:	c26080e7          	jalr	-986(ra) # 80003af4 <fileclose>
  if(*f1)
    80003ed6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003eda:	557d                	li	a0,-1
  if(*f1)
    80003edc:	c799                	beqz	a5,80003eea <pipealloc+0xc6>
    fileclose(*f1);
    80003ede:	853e                	mv	a0,a5
    80003ee0:	00000097          	auipc	ra,0x0
    80003ee4:	c14080e7          	jalr	-1004(ra) # 80003af4 <fileclose>
  return -1;
    80003ee8:	557d                	li	a0,-1
}
    80003eea:	70a2                	ld	ra,40(sp)
    80003eec:	7402                	ld	s0,32(sp)
    80003eee:	64e2                	ld	s1,24(sp)
    80003ef0:	6942                	ld	s2,16(sp)
    80003ef2:	69a2                	ld	s3,8(sp)
    80003ef4:	6a02                	ld	s4,0(sp)
    80003ef6:	6145                	addi	sp,sp,48
    80003ef8:	8082                	ret
  return -1;
    80003efa:	557d                	li	a0,-1
    80003efc:	b7fd                	j	80003eea <pipealloc+0xc6>

0000000080003efe <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003efe:	1101                	addi	sp,sp,-32
    80003f00:	ec06                	sd	ra,24(sp)
    80003f02:	e822                	sd	s0,16(sp)
    80003f04:	e426                	sd	s1,8(sp)
    80003f06:	e04a                	sd	s2,0(sp)
    80003f08:	1000                	addi	s0,sp,32
    80003f0a:	84aa                	mv	s1,a0
    80003f0c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f0e:	00002097          	auipc	ra,0x2
    80003f12:	33c080e7          	jalr	828(ra) # 8000624a <acquire>
  if(writable){
    80003f16:	02090d63          	beqz	s2,80003f50 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f1a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f1e:	21848513          	addi	a0,s1,536
    80003f22:	ffffd097          	auipc	ra,0xffffd
    80003f26:	6c6080e7          	jalr	1734(ra) # 800015e8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f2a:	2204b783          	ld	a5,544(s1)
    80003f2e:	eb95                	bnez	a5,80003f62 <pipeclose+0x64>
    release(&pi->lock);
    80003f30:	8526                	mv	a0,s1
    80003f32:	00002097          	auipc	ra,0x2
    80003f36:	3cc080e7          	jalr	972(ra) # 800062fe <release>
    kfree((char*)pi);
    80003f3a:	8526                	mv	a0,s1
    80003f3c:	ffffc097          	auipc	ra,0xffffc
    80003f40:	0e0080e7          	jalr	224(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f44:	60e2                	ld	ra,24(sp)
    80003f46:	6442                	ld	s0,16(sp)
    80003f48:	64a2                	ld	s1,8(sp)
    80003f4a:	6902                	ld	s2,0(sp)
    80003f4c:	6105                	addi	sp,sp,32
    80003f4e:	8082                	ret
    pi->readopen = 0;
    80003f50:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f54:	21c48513          	addi	a0,s1,540
    80003f58:	ffffd097          	auipc	ra,0xffffd
    80003f5c:	690080e7          	jalr	1680(ra) # 800015e8 <wakeup>
    80003f60:	b7e9                	j	80003f2a <pipeclose+0x2c>
    release(&pi->lock);
    80003f62:	8526                	mv	a0,s1
    80003f64:	00002097          	auipc	ra,0x2
    80003f68:	39a080e7          	jalr	922(ra) # 800062fe <release>
}
    80003f6c:	bfe1                	j	80003f44 <pipeclose+0x46>

0000000080003f6e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f6e:	711d                	addi	sp,sp,-96
    80003f70:	ec86                	sd	ra,88(sp)
    80003f72:	e8a2                	sd	s0,80(sp)
    80003f74:	e4a6                	sd	s1,72(sp)
    80003f76:	e0ca                	sd	s2,64(sp)
    80003f78:	fc4e                	sd	s3,56(sp)
    80003f7a:	f852                	sd	s4,48(sp)
    80003f7c:	f456                	sd	s5,40(sp)
    80003f7e:	f05a                	sd	s6,32(sp)
    80003f80:	ec5e                	sd	s7,24(sp)
    80003f82:	e862                	sd	s8,16(sp)
    80003f84:	1080                	addi	s0,sp,96
    80003f86:	84aa                	mv	s1,a0
    80003f88:	8aae                	mv	s5,a1
    80003f8a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f8c:	ffffd097          	auipc	ra,0xffffd
    80003f90:	f44080e7          	jalr	-188(ra) # 80000ed0 <myproc>
    80003f94:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f96:	8526                	mv	a0,s1
    80003f98:	00002097          	auipc	ra,0x2
    80003f9c:	2b2080e7          	jalr	690(ra) # 8000624a <acquire>
  while(i < n){
    80003fa0:	0b405663          	blez	s4,8000404c <pipewrite+0xde>
  int i = 0;
    80003fa4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fa6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fa8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fac:	21c48b93          	addi	s7,s1,540
    80003fb0:	a089                	j	80003ff2 <pipewrite+0x84>
      release(&pi->lock);
    80003fb2:	8526                	mv	a0,s1
    80003fb4:	00002097          	auipc	ra,0x2
    80003fb8:	34a080e7          	jalr	842(ra) # 800062fe <release>
      return -1;
    80003fbc:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fbe:	854a                	mv	a0,s2
    80003fc0:	60e6                	ld	ra,88(sp)
    80003fc2:	6446                	ld	s0,80(sp)
    80003fc4:	64a6                	ld	s1,72(sp)
    80003fc6:	6906                	ld	s2,64(sp)
    80003fc8:	79e2                	ld	s3,56(sp)
    80003fca:	7a42                	ld	s4,48(sp)
    80003fcc:	7aa2                	ld	s5,40(sp)
    80003fce:	7b02                	ld	s6,32(sp)
    80003fd0:	6be2                	ld	s7,24(sp)
    80003fd2:	6c42                	ld	s8,16(sp)
    80003fd4:	6125                	addi	sp,sp,96
    80003fd6:	8082                	ret
      wakeup(&pi->nread);
    80003fd8:	8562                	mv	a0,s8
    80003fda:	ffffd097          	auipc	ra,0xffffd
    80003fde:	60e080e7          	jalr	1550(ra) # 800015e8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fe2:	85a6                	mv	a1,s1
    80003fe4:	855e                	mv	a0,s7
    80003fe6:	ffffd097          	auipc	ra,0xffffd
    80003fea:	59e080e7          	jalr	1438(ra) # 80001584 <sleep>
  while(i < n){
    80003fee:	07495063          	bge	s2,s4,8000404e <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003ff2:	2204a783          	lw	a5,544(s1)
    80003ff6:	dfd5                	beqz	a5,80003fb2 <pipewrite+0x44>
    80003ff8:	854e                	mv	a0,s3
    80003ffa:	ffffe097          	auipc	ra,0xffffe
    80003ffe:	832080e7          	jalr	-1998(ra) # 8000182c <killed>
    80004002:	f945                	bnez	a0,80003fb2 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004004:	2184a783          	lw	a5,536(s1)
    80004008:	21c4a703          	lw	a4,540(s1)
    8000400c:	2007879b          	addiw	a5,a5,512
    80004010:	fcf704e3          	beq	a4,a5,80003fd8 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004014:	4685                	li	a3,1
    80004016:	01590633          	add	a2,s2,s5
    8000401a:	faf40593          	addi	a1,s0,-81
    8000401e:	0509b503          	ld	a0,80(s3)
    80004022:	ffffd097          	auipc	ra,0xffffd
    80004026:	bf6080e7          	jalr	-1034(ra) # 80000c18 <copyin>
    8000402a:	03650263          	beq	a0,s6,8000404e <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000402e:	21c4a783          	lw	a5,540(s1)
    80004032:	0017871b          	addiw	a4,a5,1
    80004036:	20e4ae23          	sw	a4,540(s1)
    8000403a:	1ff7f793          	andi	a5,a5,511
    8000403e:	97a6                	add	a5,a5,s1
    80004040:	faf44703          	lbu	a4,-81(s0)
    80004044:	00e78c23          	sb	a4,24(a5)
      i++;
    80004048:	2905                	addiw	s2,s2,1
    8000404a:	b755                	j	80003fee <pipewrite+0x80>
  int i = 0;
    8000404c:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000404e:	21848513          	addi	a0,s1,536
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	596080e7          	jalr	1430(ra) # 800015e8 <wakeup>
  release(&pi->lock);
    8000405a:	8526                	mv	a0,s1
    8000405c:	00002097          	auipc	ra,0x2
    80004060:	2a2080e7          	jalr	674(ra) # 800062fe <release>
  return i;
    80004064:	bfa9                	j	80003fbe <pipewrite+0x50>

0000000080004066 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004066:	715d                	addi	sp,sp,-80
    80004068:	e486                	sd	ra,72(sp)
    8000406a:	e0a2                	sd	s0,64(sp)
    8000406c:	fc26                	sd	s1,56(sp)
    8000406e:	f84a                	sd	s2,48(sp)
    80004070:	f44e                	sd	s3,40(sp)
    80004072:	f052                	sd	s4,32(sp)
    80004074:	ec56                	sd	s5,24(sp)
    80004076:	e85a                	sd	s6,16(sp)
    80004078:	0880                	addi	s0,sp,80
    8000407a:	84aa                	mv	s1,a0
    8000407c:	892e                	mv	s2,a1
    8000407e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	e50080e7          	jalr	-432(ra) # 80000ed0 <myproc>
    80004088:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000408a:	8526                	mv	a0,s1
    8000408c:	00002097          	auipc	ra,0x2
    80004090:	1be080e7          	jalr	446(ra) # 8000624a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004094:	2184a703          	lw	a4,536(s1)
    80004098:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000409c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040a0:	02f71763          	bne	a4,a5,800040ce <piperead+0x68>
    800040a4:	2244a783          	lw	a5,548(s1)
    800040a8:	c39d                	beqz	a5,800040ce <piperead+0x68>
    if(killed(pr)){
    800040aa:	8552                	mv	a0,s4
    800040ac:	ffffd097          	auipc	ra,0xffffd
    800040b0:	780080e7          	jalr	1920(ra) # 8000182c <killed>
    800040b4:	e941                	bnez	a0,80004144 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040b6:	85a6                	mv	a1,s1
    800040b8:	854e                	mv	a0,s3
    800040ba:	ffffd097          	auipc	ra,0xffffd
    800040be:	4ca080e7          	jalr	1226(ra) # 80001584 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040c2:	2184a703          	lw	a4,536(s1)
    800040c6:	21c4a783          	lw	a5,540(s1)
    800040ca:	fcf70de3          	beq	a4,a5,800040a4 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ce:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040d0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040d2:	05505363          	blez	s5,80004118 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800040d6:	2184a783          	lw	a5,536(s1)
    800040da:	21c4a703          	lw	a4,540(s1)
    800040de:	02f70d63          	beq	a4,a5,80004118 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040e2:	0017871b          	addiw	a4,a5,1
    800040e6:	20e4ac23          	sw	a4,536(s1)
    800040ea:	1ff7f793          	andi	a5,a5,511
    800040ee:	97a6                	add	a5,a5,s1
    800040f0:	0187c783          	lbu	a5,24(a5)
    800040f4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040f8:	4685                	li	a3,1
    800040fa:	fbf40613          	addi	a2,s0,-65
    800040fe:	85ca                	mv	a1,s2
    80004100:	050a3503          	ld	a0,80(s4)
    80004104:	ffffd097          	auipc	ra,0xffffd
    80004108:	a54080e7          	jalr	-1452(ra) # 80000b58 <copyout>
    8000410c:	01650663          	beq	a0,s6,80004118 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004110:	2985                	addiw	s3,s3,1
    80004112:	0905                	addi	s2,s2,1
    80004114:	fd3a91e3          	bne	s5,s3,800040d6 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004118:	21c48513          	addi	a0,s1,540
    8000411c:	ffffd097          	auipc	ra,0xffffd
    80004120:	4cc080e7          	jalr	1228(ra) # 800015e8 <wakeup>
  release(&pi->lock);
    80004124:	8526                	mv	a0,s1
    80004126:	00002097          	auipc	ra,0x2
    8000412a:	1d8080e7          	jalr	472(ra) # 800062fe <release>
  return i;
}
    8000412e:	854e                	mv	a0,s3
    80004130:	60a6                	ld	ra,72(sp)
    80004132:	6406                	ld	s0,64(sp)
    80004134:	74e2                	ld	s1,56(sp)
    80004136:	7942                	ld	s2,48(sp)
    80004138:	79a2                	ld	s3,40(sp)
    8000413a:	7a02                	ld	s4,32(sp)
    8000413c:	6ae2                	ld	s5,24(sp)
    8000413e:	6b42                	ld	s6,16(sp)
    80004140:	6161                	addi	sp,sp,80
    80004142:	8082                	ret
      release(&pi->lock);
    80004144:	8526                	mv	a0,s1
    80004146:	00002097          	auipc	ra,0x2
    8000414a:	1b8080e7          	jalr	440(ra) # 800062fe <release>
      return -1;
    8000414e:	59fd                	li	s3,-1
    80004150:	bff9                	j	8000412e <piperead+0xc8>

0000000080004152 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004152:	1141                	addi	sp,sp,-16
    80004154:	e422                	sd	s0,8(sp)
    80004156:	0800                	addi	s0,sp,16
    80004158:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000415a:	8905                	andi	a0,a0,1
    8000415c:	c111                	beqz	a0,80004160 <flags2perm+0xe>
      perm = PTE_X;
    8000415e:	4521                	li	a0,8
    if(flags & 0x2)
    80004160:	8b89                	andi	a5,a5,2
    80004162:	c399                	beqz	a5,80004168 <flags2perm+0x16>
      perm |= PTE_W;
    80004164:	00456513          	ori	a0,a0,4
    return perm;
}
    80004168:	6422                	ld	s0,8(sp)
    8000416a:	0141                	addi	sp,sp,16
    8000416c:	8082                	ret

000000008000416e <exec>:

int
exec(char *path, char **argv)
{
    8000416e:	de010113          	addi	sp,sp,-544
    80004172:	20113c23          	sd	ra,536(sp)
    80004176:	20813823          	sd	s0,528(sp)
    8000417a:	20913423          	sd	s1,520(sp)
    8000417e:	21213023          	sd	s2,512(sp)
    80004182:	ffce                	sd	s3,504(sp)
    80004184:	fbd2                	sd	s4,496(sp)
    80004186:	f7d6                	sd	s5,488(sp)
    80004188:	f3da                	sd	s6,480(sp)
    8000418a:	efde                	sd	s7,472(sp)
    8000418c:	ebe2                	sd	s8,464(sp)
    8000418e:	e7e6                	sd	s9,456(sp)
    80004190:	e3ea                	sd	s10,448(sp)
    80004192:	ff6e                	sd	s11,440(sp)
    80004194:	1400                	addi	s0,sp,544
    80004196:	892a                	mv	s2,a0
    80004198:	dea43423          	sd	a0,-536(s0)
    8000419c:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041a0:	ffffd097          	auipc	ra,0xffffd
    800041a4:	d30080e7          	jalr	-720(ra) # 80000ed0 <myproc>
    800041a8:	84aa                	mv	s1,a0

  begin_op();
    800041aa:	fffff097          	auipc	ra,0xfffff
    800041ae:	47e080e7          	jalr	1150(ra) # 80003628 <begin_op>

  if((ip = namei(path)) == 0){
    800041b2:	854a                	mv	a0,s2
    800041b4:	fffff097          	auipc	ra,0xfffff
    800041b8:	258080e7          	jalr	600(ra) # 8000340c <namei>
    800041bc:	c93d                	beqz	a0,80004232 <exec+0xc4>
    800041be:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041c0:	fffff097          	auipc	ra,0xfffff
    800041c4:	aa6080e7          	jalr	-1370(ra) # 80002c66 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041c8:	04000713          	li	a4,64
    800041cc:	4681                	li	a3,0
    800041ce:	e5040613          	addi	a2,s0,-432
    800041d2:	4581                	li	a1,0
    800041d4:	8556                	mv	a0,s5
    800041d6:	fffff097          	auipc	ra,0xfffff
    800041da:	d44080e7          	jalr	-700(ra) # 80002f1a <readi>
    800041de:	04000793          	li	a5,64
    800041e2:	00f51a63          	bne	a0,a5,800041f6 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041e6:	e5042703          	lw	a4,-432(s0)
    800041ea:	464c47b7          	lui	a5,0x464c4
    800041ee:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041f2:	04f70663          	beq	a4,a5,8000423e <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041f6:	8556                	mv	a0,s5
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	cd0080e7          	jalr	-816(ra) # 80002ec8 <iunlockput>
    end_op();
    80004200:	fffff097          	auipc	ra,0xfffff
    80004204:	4a8080e7          	jalr	1192(ra) # 800036a8 <end_op>
  }
  return -1;
    80004208:	557d                	li	a0,-1
}
    8000420a:	21813083          	ld	ra,536(sp)
    8000420e:	21013403          	ld	s0,528(sp)
    80004212:	20813483          	ld	s1,520(sp)
    80004216:	20013903          	ld	s2,512(sp)
    8000421a:	79fe                	ld	s3,504(sp)
    8000421c:	7a5e                	ld	s4,496(sp)
    8000421e:	7abe                	ld	s5,488(sp)
    80004220:	7b1e                	ld	s6,480(sp)
    80004222:	6bfe                	ld	s7,472(sp)
    80004224:	6c5e                	ld	s8,464(sp)
    80004226:	6cbe                	ld	s9,456(sp)
    80004228:	6d1e                	ld	s10,448(sp)
    8000422a:	7dfa                	ld	s11,440(sp)
    8000422c:	22010113          	addi	sp,sp,544
    80004230:	8082                	ret
    end_op();
    80004232:	fffff097          	auipc	ra,0xfffff
    80004236:	476080e7          	jalr	1142(ra) # 800036a8 <end_op>
    return -1;
    8000423a:	557d                	li	a0,-1
    8000423c:	b7f9                	j	8000420a <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000423e:	8526                	mv	a0,s1
    80004240:	ffffd097          	auipc	ra,0xffffd
    80004244:	d58080e7          	jalr	-680(ra) # 80000f98 <proc_pagetable>
    80004248:	8b2a                	mv	s6,a0
    8000424a:	d555                	beqz	a0,800041f6 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000424c:	e7042783          	lw	a5,-400(s0)
    80004250:	e8845703          	lhu	a4,-376(s0)
    80004254:	c735                	beqz	a4,800042c0 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004256:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004258:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000425c:	6a05                	lui	s4,0x1
    8000425e:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004262:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004266:	6d85                	lui	s11,0x1
    80004268:	7d7d                	lui	s10,0xfffff
    8000426a:	a481                	j	800044aa <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000426c:	00004517          	auipc	a0,0x4
    80004270:	4f450513          	addi	a0,a0,1268 # 80008760 <syscalls+0x288>
    80004274:	00002097          	auipc	ra,0x2
    80004278:	a9a080e7          	jalr	-1382(ra) # 80005d0e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000427c:	874a                	mv	a4,s2
    8000427e:	009c86bb          	addw	a3,s9,s1
    80004282:	4581                	li	a1,0
    80004284:	8556                	mv	a0,s5
    80004286:	fffff097          	auipc	ra,0xfffff
    8000428a:	c94080e7          	jalr	-876(ra) # 80002f1a <readi>
    8000428e:	2501                	sext.w	a0,a0
    80004290:	1aa91a63          	bne	s2,a0,80004444 <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    80004294:	009d84bb          	addw	s1,s11,s1
    80004298:	013d09bb          	addw	s3,s10,s3
    8000429c:	1f74f763          	bgeu	s1,s7,8000448a <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    800042a0:	02049593          	slli	a1,s1,0x20
    800042a4:	9181                	srli	a1,a1,0x20
    800042a6:	95e2                	add	a1,a1,s8
    800042a8:	855a                	mv	a0,s6
    800042aa:	ffffc097          	auipc	ra,0xffffc
    800042ae:	27e080e7          	jalr	638(ra) # 80000528 <walkaddr>
    800042b2:	862a                	mv	a2,a0
    if(pa == 0)
    800042b4:	dd45                	beqz	a0,8000426c <exec+0xfe>
      n = PGSIZE;
    800042b6:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800042b8:	fd49f2e3          	bgeu	s3,s4,8000427c <exec+0x10e>
      n = sz - i;
    800042bc:	894e                	mv	s2,s3
    800042be:	bf7d                	j	8000427c <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042c0:	4901                	li	s2,0
  iunlockput(ip);
    800042c2:	8556                	mv	a0,s5
    800042c4:	fffff097          	auipc	ra,0xfffff
    800042c8:	c04080e7          	jalr	-1020(ra) # 80002ec8 <iunlockput>
  end_op();
    800042cc:	fffff097          	auipc	ra,0xfffff
    800042d0:	3dc080e7          	jalr	988(ra) # 800036a8 <end_op>
  p = myproc();
    800042d4:	ffffd097          	auipc	ra,0xffffd
    800042d8:	bfc080e7          	jalr	-1028(ra) # 80000ed0 <myproc>
    800042dc:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800042de:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042e2:	6785                	lui	a5,0x1
    800042e4:	17fd                	addi	a5,a5,-1
    800042e6:	993e                	add	s2,s2,a5
    800042e8:	77fd                	lui	a5,0xfffff
    800042ea:	00f977b3          	and	a5,s2,a5
    800042ee:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042f2:	4691                	li	a3,4
    800042f4:	6609                	lui	a2,0x2
    800042f6:	963e                	add	a2,a2,a5
    800042f8:	85be                	mv	a1,a5
    800042fa:	855a                	mv	a0,s6
    800042fc:	ffffc097          	auipc	ra,0xffffc
    80004300:	604080e7          	jalr	1540(ra) # 80000900 <uvmalloc>
    80004304:	8c2a                	mv	s8,a0
  ip = 0;
    80004306:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004308:	12050e63          	beqz	a0,80004444 <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000430c:	75f9                	lui	a1,0xffffe
    8000430e:	95aa                	add	a1,a1,a0
    80004310:	855a                	mv	a0,s6
    80004312:	ffffd097          	auipc	ra,0xffffd
    80004316:	814080e7          	jalr	-2028(ra) # 80000b26 <uvmclear>
  stackbase = sp - PGSIZE;
    8000431a:	7afd                	lui	s5,0xfffff
    8000431c:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000431e:	df043783          	ld	a5,-528(s0)
    80004322:	6388                	ld	a0,0(a5)
    80004324:	c925                	beqz	a0,80004394 <exec+0x226>
    80004326:	e9040993          	addi	s3,s0,-368
    8000432a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000432e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004330:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004332:	ffffc097          	auipc	ra,0xffffc
    80004336:	fe8080e7          	jalr	-24(ra) # 8000031a <strlen>
    8000433a:	0015079b          	addiw	a5,a0,1
    8000433e:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004342:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004346:	13596663          	bltu	s2,s5,80004472 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000434a:	df043d83          	ld	s11,-528(s0)
    8000434e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004352:	8552                	mv	a0,s4
    80004354:	ffffc097          	auipc	ra,0xffffc
    80004358:	fc6080e7          	jalr	-58(ra) # 8000031a <strlen>
    8000435c:	0015069b          	addiw	a3,a0,1
    80004360:	8652                	mv	a2,s4
    80004362:	85ca                	mv	a1,s2
    80004364:	855a                	mv	a0,s6
    80004366:	ffffc097          	auipc	ra,0xffffc
    8000436a:	7f2080e7          	jalr	2034(ra) # 80000b58 <copyout>
    8000436e:	10054663          	bltz	a0,8000447a <exec+0x30c>
    ustack[argc] = sp;
    80004372:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004376:	0485                	addi	s1,s1,1
    80004378:	008d8793          	addi	a5,s11,8
    8000437c:	def43823          	sd	a5,-528(s0)
    80004380:	008db503          	ld	a0,8(s11)
    80004384:	c911                	beqz	a0,80004398 <exec+0x22a>
    if(argc >= MAXARG)
    80004386:	09a1                	addi	s3,s3,8
    80004388:	fb3c95e3          	bne	s9,s3,80004332 <exec+0x1c4>
  sz = sz1;
    8000438c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004390:	4a81                	li	s5,0
    80004392:	a84d                	j	80004444 <exec+0x2d6>
  sp = sz;
    80004394:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004396:	4481                	li	s1,0
  ustack[argc] = 0;
    80004398:	00349793          	slli	a5,s1,0x3
    8000439c:	f9040713          	addi	a4,s0,-112
    800043a0:	97ba                	add	a5,a5,a4
    800043a2:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdce10>
  sp -= (argc+1) * sizeof(uint64);
    800043a6:	00148693          	addi	a3,s1,1
    800043aa:	068e                	slli	a3,a3,0x3
    800043ac:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043b0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043b4:	01597663          	bgeu	s2,s5,800043c0 <exec+0x252>
  sz = sz1;
    800043b8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043bc:	4a81                	li	s5,0
    800043be:	a059                	j	80004444 <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043c0:	e9040613          	addi	a2,s0,-368
    800043c4:	85ca                	mv	a1,s2
    800043c6:	855a                	mv	a0,s6
    800043c8:	ffffc097          	auipc	ra,0xffffc
    800043cc:	790080e7          	jalr	1936(ra) # 80000b58 <copyout>
    800043d0:	0a054963          	bltz	a0,80004482 <exec+0x314>
  p->trapframe->a1 = sp;
    800043d4:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800043d8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043dc:	de843783          	ld	a5,-536(s0)
    800043e0:	0007c703          	lbu	a4,0(a5)
    800043e4:	cf11                	beqz	a4,80004400 <exec+0x292>
    800043e6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043e8:	02f00693          	li	a3,47
    800043ec:	a039                	j	800043fa <exec+0x28c>
      last = s+1;
    800043ee:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800043f2:	0785                	addi	a5,a5,1
    800043f4:	fff7c703          	lbu	a4,-1(a5)
    800043f8:	c701                	beqz	a4,80004400 <exec+0x292>
    if(*s == '/')
    800043fa:	fed71ce3          	bne	a4,a3,800043f2 <exec+0x284>
    800043fe:	bfc5                	j	800043ee <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    80004400:	4641                	li	a2,16
    80004402:	de843583          	ld	a1,-536(s0)
    80004406:	158b8513          	addi	a0,s7,344
    8000440a:	ffffc097          	auipc	ra,0xffffc
    8000440e:	ede080e7          	jalr	-290(ra) # 800002e8 <safestrcpy>
  oldpagetable = p->pagetable;
    80004412:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004416:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000441a:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000441e:	058bb783          	ld	a5,88(s7)
    80004422:	e6843703          	ld	a4,-408(s0)
    80004426:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004428:	058bb783          	ld	a5,88(s7)
    8000442c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004430:	85ea                	mv	a1,s10
    80004432:	ffffd097          	auipc	ra,0xffffd
    80004436:	c02080e7          	jalr	-1022(ra) # 80001034 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000443a:	0004851b          	sext.w	a0,s1
    8000443e:	b3f1                	j	8000420a <exec+0x9c>
    80004440:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004444:	df843583          	ld	a1,-520(s0)
    80004448:	855a                	mv	a0,s6
    8000444a:	ffffd097          	auipc	ra,0xffffd
    8000444e:	bea080e7          	jalr	-1046(ra) # 80001034 <proc_freepagetable>
  if(ip){
    80004452:	da0a92e3          	bnez	s5,800041f6 <exec+0x88>
  return -1;
    80004456:	557d                	li	a0,-1
    80004458:	bb4d                	j	8000420a <exec+0x9c>
    8000445a:	df243c23          	sd	s2,-520(s0)
    8000445e:	b7dd                	j	80004444 <exec+0x2d6>
    80004460:	df243c23          	sd	s2,-520(s0)
    80004464:	b7c5                	j	80004444 <exec+0x2d6>
    80004466:	df243c23          	sd	s2,-520(s0)
    8000446a:	bfe9                	j	80004444 <exec+0x2d6>
    8000446c:	df243c23          	sd	s2,-520(s0)
    80004470:	bfd1                	j	80004444 <exec+0x2d6>
  sz = sz1;
    80004472:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004476:	4a81                	li	s5,0
    80004478:	b7f1                	j	80004444 <exec+0x2d6>
  sz = sz1;
    8000447a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000447e:	4a81                	li	s5,0
    80004480:	b7d1                	j	80004444 <exec+0x2d6>
  sz = sz1;
    80004482:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004486:	4a81                	li	s5,0
    80004488:	bf75                	j	80004444 <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000448a:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000448e:	e0843783          	ld	a5,-504(s0)
    80004492:	0017869b          	addiw	a3,a5,1
    80004496:	e0d43423          	sd	a3,-504(s0)
    8000449a:	e0043783          	ld	a5,-512(s0)
    8000449e:	0387879b          	addiw	a5,a5,56
    800044a2:	e8845703          	lhu	a4,-376(s0)
    800044a6:	e0e6dee3          	bge	a3,a4,800042c2 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044aa:	2781                	sext.w	a5,a5
    800044ac:	e0f43023          	sd	a5,-512(s0)
    800044b0:	03800713          	li	a4,56
    800044b4:	86be                	mv	a3,a5
    800044b6:	e1840613          	addi	a2,s0,-488
    800044ba:	4581                	li	a1,0
    800044bc:	8556                	mv	a0,s5
    800044be:	fffff097          	auipc	ra,0xfffff
    800044c2:	a5c080e7          	jalr	-1444(ra) # 80002f1a <readi>
    800044c6:	03800793          	li	a5,56
    800044ca:	f6f51be3          	bne	a0,a5,80004440 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    800044ce:	e1842783          	lw	a5,-488(s0)
    800044d2:	4705                	li	a4,1
    800044d4:	fae79de3          	bne	a5,a4,8000448e <exec+0x320>
    if(ph.memsz < ph.filesz)
    800044d8:	e4043483          	ld	s1,-448(s0)
    800044dc:	e3843783          	ld	a5,-456(s0)
    800044e0:	f6f4ede3          	bltu	s1,a5,8000445a <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044e4:	e2843783          	ld	a5,-472(s0)
    800044e8:	94be                	add	s1,s1,a5
    800044ea:	f6f4ebe3          	bltu	s1,a5,80004460 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    800044ee:	de043703          	ld	a4,-544(s0)
    800044f2:	8ff9                	and	a5,a5,a4
    800044f4:	fbad                	bnez	a5,80004466 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044f6:	e1c42503          	lw	a0,-484(s0)
    800044fa:	00000097          	auipc	ra,0x0
    800044fe:	c58080e7          	jalr	-936(ra) # 80004152 <flags2perm>
    80004502:	86aa                	mv	a3,a0
    80004504:	8626                	mv	a2,s1
    80004506:	85ca                	mv	a1,s2
    80004508:	855a                	mv	a0,s6
    8000450a:	ffffc097          	auipc	ra,0xffffc
    8000450e:	3f6080e7          	jalr	1014(ra) # 80000900 <uvmalloc>
    80004512:	dea43c23          	sd	a0,-520(s0)
    80004516:	d939                	beqz	a0,8000446c <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004518:	e2843c03          	ld	s8,-472(s0)
    8000451c:	e2042c83          	lw	s9,-480(s0)
    80004520:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004524:	f60b83e3          	beqz	s7,8000448a <exec+0x31c>
    80004528:	89de                	mv	s3,s7
    8000452a:	4481                	li	s1,0
    8000452c:	bb95                	j	800042a0 <exec+0x132>

000000008000452e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000452e:	7179                	addi	sp,sp,-48
    80004530:	f406                	sd	ra,40(sp)
    80004532:	f022                	sd	s0,32(sp)
    80004534:	ec26                	sd	s1,24(sp)
    80004536:	e84a                	sd	s2,16(sp)
    80004538:	1800                	addi	s0,sp,48
    8000453a:	892e                	mv	s2,a1
    8000453c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000453e:	fdc40593          	addi	a1,s0,-36
    80004542:	ffffe097          	auipc	ra,0xffffe
    80004546:	ade080e7          	jalr	-1314(ra) # 80002020 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000454a:	fdc42703          	lw	a4,-36(s0)
    8000454e:	47bd                	li	a5,15
    80004550:	02e7eb63          	bltu	a5,a4,80004586 <argfd+0x58>
    80004554:	ffffd097          	auipc	ra,0xffffd
    80004558:	97c080e7          	jalr	-1668(ra) # 80000ed0 <myproc>
    8000455c:	fdc42703          	lw	a4,-36(s0)
    80004560:	01a70793          	addi	a5,a4,26
    80004564:	078e                	slli	a5,a5,0x3
    80004566:	953e                	add	a0,a0,a5
    80004568:	611c                	ld	a5,0(a0)
    8000456a:	c385                	beqz	a5,8000458a <argfd+0x5c>
    return -1;
  if(pfd)
    8000456c:	00090463          	beqz	s2,80004574 <argfd+0x46>
    *pfd = fd;
    80004570:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004574:	4501                	li	a0,0
  if(pf)
    80004576:	c091                	beqz	s1,8000457a <argfd+0x4c>
    *pf = f;
    80004578:	e09c                	sd	a5,0(s1)
}
    8000457a:	70a2                	ld	ra,40(sp)
    8000457c:	7402                	ld	s0,32(sp)
    8000457e:	64e2                	ld	s1,24(sp)
    80004580:	6942                	ld	s2,16(sp)
    80004582:	6145                	addi	sp,sp,48
    80004584:	8082                	ret
    return -1;
    80004586:	557d                	li	a0,-1
    80004588:	bfcd                	j	8000457a <argfd+0x4c>
    8000458a:	557d                	li	a0,-1
    8000458c:	b7fd                	j	8000457a <argfd+0x4c>

000000008000458e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000458e:	1101                	addi	sp,sp,-32
    80004590:	ec06                	sd	ra,24(sp)
    80004592:	e822                	sd	s0,16(sp)
    80004594:	e426                	sd	s1,8(sp)
    80004596:	1000                	addi	s0,sp,32
    80004598:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000459a:	ffffd097          	auipc	ra,0xffffd
    8000459e:	936080e7          	jalr	-1738(ra) # 80000ed0 <myproc>
    800045a2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045a4:	0d050793          	addi	a5,a0,208
    800045a8:	4501                	li	a0,0
    800045aa:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045ac:	6398                	ld	a4,0(a5)
    800045ae:	cb19                	beqz	a4,800045c4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045b0:	2505                	addiw	a0,a0,1
    800045b2:	07a1                	addi	a5,a5,8
    800045b4:	fed51ce3          	bne	a0,a3,800045ac <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045b8:	557d                	li	a0,-1
}
    800045ba:	60e2                	ld	ra,24(sp)
    800045bc:	6442                	ld	s0,16(sp)
    800045be:	64a2                	ld	s1,8(sp)
    800045c0:	6105                	addi	sp,sp,32
    800045c2:	8082                	ret
      p->ofile[fd] = f;
    800045c4:	01a50793          	addi	a5,a0,26
    800045c8:	078e                	slli	a5,a5,0x3
    800045ca:	963e                	add	a2,a2,a5
    800045cc:	e204                	sd	s1,0(a2)
      return fd;
    800045ce:	b7f5                	j	800045ba <fdalloc+0x2c>

00000000800045d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045d0:	715d                	addi	sp,sp,-80
    800045d2:	e486                	sd	ra,72(sp)
    800045d4:	e0a2                	sd	s0,64(sp)
    800045d6:	fc26                	sd	s1,56(sp)
    800045d8:	f84a                	sd	s2,48(sp)
    800045da:	f44e                	sd	s3,40(sp)
    800045dc:	f052                	sd	s4,32(sp)
    800045de:	ec56                	sd	s5,24(sp)
    800045e0:	e85a                	sd	s6,16(sp)
    800045e2:	0880                	addi	s0,sp,80
    800045e4:	8b2e                	mv	s6,a1
    800045e6:	89b2                	mv	s3,a2
    800045e8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045ea:	fb040593          	addi	a1,s0,-80
    800045ee:	fffff097          	auipc	ra,0xfffff
    800045f2:	e3c080e7          	jalr	-452(ra) # 8000342a <nameiparent>
    800045f6:	84aa                	mv	s1,a0
    800045f8:	14050f63          	beqz	a0,80004756 <create+0x186>
    return 0;

  ilock(dp);
    800045fc:	ffffe097          	auipc	ra,0xffffe
    80004600:	66a080e7          	jalr	1642(ra) # 80002c66 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004604:	4601                	li	a2,0
    80004606:	fb040593          	addi	a1,s0,-80
    8000460a:	8526                	mv	a0,s1
    8000460c:	fffff097          	auipc	ra,0xfffff
    80004610:	b3e080e7          	jalr	-1218(ra) # 8000314a <dirlookup>
    80004614:	8aaa                	mv	s5,a0
    80004616:	c931                	beqz	a0,8000466a <create+0x9a>
    iunlockput(dp);
    80004618:	8526                	mv	a0,s1
    8000461a:	fffff097          	auipc	ra,0xfffff
    8000461e:	8ae080e7          	jalr	-1874(ra) # 80002ec8 <iunlockput>
    ilock(ip);
    80004622:	8556                	mv	a0,s5
    80004624:	ffffe097          	auipc	ra,0xffffe
    80004628:	642080e7          	jalr	1602(ra) # 80002c66 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000462c:	000b059b          	sext.w	a1,s6
    80004630:	4789                	li	a5,2
    80004632:	02f59563          	bne	a1,a5,8000465c <create+0x8c>
    80004636:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdcf54>
    8000463a:	37f9                	addiw	a5,a5,-2
    8000463c:	17c2                	slli	a5,a5,0x30
    8000463e:	93c1                	srli	a5,a5,0x30
    80004640:	4705                	li	a4,1
    80004642:	00f76d63          	bltu	a4,a5,8000465c <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004646:	8556                	mv	a0,s5
    80004648:	60a6                	ld	ra,72(sp)
    8000464a:	6406                	ld	s0,64(sp)
    8000464c:	74e2                	ld	s1,56(sp)
    8000464e:	7942                	ld	s2,48(sp)
    80004650:	79a2                	ld	s3,40(sp)
    80004652:	7a02                	ld	s4,32(sp)
    80004654:	6ae2                	ld	s5,24(sp)
    80004656:	6b42                	ld	s6,16(sp)
    80004658:	6161                	addi	sp,sp,80
    8000465a:	8082                	ret
    iunlockput(ip);
    8000465c:	8556                	mv	a0,s5
    8000465e:	fffff097          	auipc	ra,0xfffff
    80004662:	86a080e7          	jalr	-1942(ra) # 80002ec8 <iunlockput>
    return 0;
    80004666:	4a81                	li	s5,0
    80004668:	bff9                	j	80004646 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000466a:	85da                	mv	a1,s6
    8000466c:	4088                	lw	a0,0(s1)
    8000466e:	ffffe097          	auipc	ra,0xffffe
    80004672:	45c080e7          	jalr	1116(ra) # 80002aca <ialloc>
    80004676:	8a2a                	mv	s4,a0
    80004678:	c539                	beqz	a0,800046c6 <create+0xf6>
  ilock(ip);
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	5ec080e7          	jalr	1516(ra) # 80002c66 <ilock>
  ip->major = major;
    80004682:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004686:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000468a:	4905                	li	s2,1
    8000468c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004690:	8552                	mv	a0,s4
    80004692:	ffffe097          	auipc	ra,0xffffe
    80004696:	50a080e7          	jalr	1290(ra) # 80002b9c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000469a:	000b059b          	sext.w	a1,s6
    8000469e:	03258b63          	beq	a1,s2,800046d4 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800046a2:	004a2603          	lw	a2,4(s4)
    800046a6:	fb040593          	addi	a1,s0,-80
    800046aa:	8526                	mv	a0,s1
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	cae080e7          	jalr	-850(ra) # 8000335a <dirlink>
    800046b4:	06054f63          	bltz	a0,80004732 <create+0x162>
  iunlockput(dp);
    800046b8:	8526                	mv	a0,s1
    800046ba:	fffff097          	auipc	ra,0xfffff
    800046be:	80e080e7          	jalr	-2034(ra) # 80002ec8 <iunlockput>
  return ip;
    800046c2:	8ad2                	mv	s5,s4
    800046c4:	b749                	j	80004646 <create+0x76>
    iunlockput(dp);
    800046c6:	8526                	mv	a0,s1
    800046c8:	fffff097          	auipc	ra,0xfffff
    800046cc:	800080e7          	jalr	-2048(ra) # 80002ec8 <iunlockput>
    return 0;
    800046d0:	8ad2                	mv	s5,s4
    800046d2:	bf95                	j	80004646 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046d4:	004a2603          	lw	a2,4(s4)
    800046d8:	00004597          	auipc	a1,0x4
    800046dc:	0a858593          	addi	a1,a1,168 # 80008780 <syscalls+0x2a8>
    800046e0:	8552                	mv	a0,s4
    800046e2:	fffff097          	auipc	ra,0xfffff
    800046e6:	c78080e7          	jalr	-904(ra) # 8000335a <dirlink>
    800046ea:	04054463          	bltz	a0,80004732 <create+0x162>
    800046ee:	40d0                	lw	a2,4(s1)
    800046f0:	00004597          	auipc	a1,0x4
    800046f4:	09858593          	addi	a1,a1,152 # 80008788 <syscalls+0x2b0>
    800046f8:	8552                	mv	a0,s4
    800046fa:	fffff097          	auipc	ra,0xfffff
    800046fe:	c60080e7          	jalr	-928(ra) # 8000335a <dirlink>
    80004702:	02054863          	bltz	a0,80004732 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004706:	004a2603          	lw	a2,4(s4)
    8000470a:	fb040593          	addi	a1,s0,-80
    8000470e:	8526                	mv	a0,s1
    80004710:	fffff097          	auipc	ra,0xfffff
    80004714:	c4a080e7          	jalr	-950(ra) # 8000335a <dirlink>
    80004718:	00054d63          	bltz	a0,80004732 <create+0x162>
    dp->nlink++;  // for ".."
    8000471c:	04a4d783          	lhu	a5,74(s1)
    80004720:	2785                	addiw	a5,a5,1
    80004722:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004726:	8526                	mv	a0,s1
    80004728:	ffffe097          	auipc	ra,0xffffe
    8000472c:	474080e7          	jalr	1140(ra) # 80002b9c <iupdate>
    80004730:	b761                	j	800046b8 <create+0xe8>
  ip->nlink = 0;
    80004732:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004736:	8552                	mv	a0,s4
    80004738:	ffffe097          	auipc	ra,0xffffe
    8000473c:	464080e7          	jalr	1124(ra) # 80002b9c <iupdate>
  iunlockput(ip);
    80004740:	8552                	mv	a0,s4
    80004742:	ffffe097          	auipc	ra,0xffffe
    80004746:	786080e7          	jalr	1926(ra) # 80002ec8 <iunlockput>
  iunlockput(dp);
    8000474a:	8526                	mv	a0,s1
    8000474c:	ffffe097          	auipc	ra,0xffffe
    80004750:	77c080e7          	jalr	1916(ra) # 80002ec8 <iunlockput>
  return 0;
    80004754:	bdcd                	j	80004646 <create+0x76>
    return 0;
    80004756:	8aaa                	mv	s5,a0
    80004758:	b5fd                	j	80004646 <create+0x76>

000000008000475a <sys_dup>:
{
    8000475a:	7179                	addi	sp,sp,-48
    8000475c:	f406                	sd	ra,40(sp)
    8000475e:	f022                	sd	s0,32(sp)
    80004760:	ec26                	sd	s1,24(sp)
    80004762:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004764:	fd840613          	addi	a2,s0,-40
    80004768:	4581                	li	a1,0
    8000476a:	4501                	li	a0,0
    8000476c:	00000097          	auipc	ra,0x0
    80004770:	dc2080e7          	jalr	-574(ra) # 8000452e <argfd>
    return -1;
    80004774:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004776:	02054363          	bltz	a0,8000479c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000477a:	fd843503          	ld	a0,-40(s0)
    8000477e:	00000097          	auipc	ra,0x0
    80004782:	e10080e7          	jalr	-496(ra) # 8000458e <fdalloc>
    80004786:	84aa                	mv	s1,a0
    return -1;
    80004788:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000478a:	00054963          	bltz	a0,8000479c <sys_dup+0x42>
  filedup(f);
    8000478e:	fd843503          	ld	a0,-40(s0)
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	310080e7          	jalr	784(ra) # 80003aa2 <filedup>
  return fd;
    8000479a:	87a6                	mv	a5,s1
}
    8000479c:	853e                	mv	a0,a5
    8000479e:	70a2                	ld	ra,40(sp)
    800047a0:	7402                	ld	s0,32(sp)
    800047a2:	64e2                	ld	s1,24(sp)
    800047a4:	6145                	addi	sp,sp,48
    800047a6:	8082                	ret

00000000800047a8 <sys_read>:
{
    800047a8:	7179                	addi	sp,sp,-48
    800047aa:	f406                	sd	ra,40(sp)
    800047ac:	f022                	sd	s0,32(sp)
    800047ae:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047b0:	fd840593          	addi	a1,s0,-40
    800047b4:	4505                	li	a0,1
    800047b6:	ffffe097          	auipc	ra,0xffffe
    800047ba:	88a080e7          	jalr	-1910(ra) # 80002040 <argaddr>
  argint(2, &n);
    800047be:	fe440593          	addi	a1,s0,-28
    800047c2:	4509                	li	a0,2
    800047c4:	ffffe097          	auipc	ra,0xffffe
    800047c8:	85c080e7          	jalr	-1956(ra) # 80002020 <argint>
  if(argfd(0, 0, &f) < 0)
    800047cc:	fe840613          	addi	a2,s0,-24
    800047d0:	4581                	li	a1,0
    800047d2:	4501                	li	a0,0
    800047d4:	00000097          	auipc	ra,0x0
    800047d8:	d5a080e7          	jalr	-678(ra) # 8000452e <argfd>
    800047dc:	87aa                	mv	a5,a0
    return -1;
    800047de:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047e0:	0007cc63          	bltz	a5,800047f8 <sys_read+0x50>
  return fileread(f, p, n);
    800047e4:	fe442603          	lw	a2,-28(s0)
    800047e8:	fd843583          	ld	a1,-40(s0)
    800047ec:	fe843503          	ld	a0,-24(s0)
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	43e080e7          	jalr	1086(ra) # 80003c2e <fileread>
}
    800047f8:	70a2                	ld	ra,40(sp)
    800047fa:	7402                	ld	s0,32(sp)
    800047fc:	6145                	addi	sp,sp,48
    800047fe:	8082                	ret

0000000080004800 <sys_write>:
{
    80004800:	7179                	addi	sp,sp,-48
    80004802:	f406                	sd	ra,40(sp)
    80004804:	f022                	sd	s0,32(sp)
    80004806:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004808:	fd840593          	addi	a1,s0,-40
    8000480c:	4505                	li	a0,1
    8000480e:	ffffe097          	auipc	ra,0xffffe
    80004812:	832080e7          	jalr	-1998(ra) # 80002040 <argaddr>
  argint(2, &n);
    80004816:	fe440593          	addi	a1,s0,-28
    8000481a:	4509                	li	a0,2
    8000481c:	ffffe097          	auipc	ra,0xffffe
    80004820:	804080e7          	jalr	-2044(ra) # 80002020 <argint>
  if(argfd(0, 0, &f) < 0)
    80004824:	fe840613          	addi	a2,s0,-24
    80004828:	4581                	li	a1,0
    8000482a:	4501                	li	a0,0
    8000482c:	00000097          	auipc	ra,0x0
    80004830:	d02080e7          	jalr	-766(ra) # 8000452e <argfd>
    80004834:	87aa                	mv	a5,a0
    return -1;
    80004836:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004838:	0007cc63          	bltz	a5,80004850 <sys_write+0x50>
  return filewrite(f, p, n);
    8000483c:	fe442603          	lw	a2,-28(s0)
    80004840:	fd843583          	ld	a1,-40(s0)
    80004844:	fe843503          	ld	a0,-24(s0)
    80004848:	fffff097          	auipc	ra,0xfffff
    8000484c:	4a8080e7          	jalr	1192(ra) # 80003cf0 <filewrite>
}
    80004850:	70a2                	ld	ra,40(sp)
    80004852:	7402                	ld	s0,32(sp)
    80004854:	6145                	addi	sp,sp,48
    80004856:	8082                	ret

0000000080004858 <sys_close>:
{
    80004858:	1101                	addi	sp,sp,-32
    8000485a:	ec06                	sd	ra,24(sp)
    8000485c:	e822                	sd	s0,16(sp)
    8000485e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004860:	fe040613          	addi	a2,s0,-32
    80004864:	fec40593          	addi	a1,s0,-20
    80004868:	4501                	li	a0,0
    8000486a:	00000097          	auipc	ra,0x0
    8000486e:	cc4080e7          	jalr	-828(ra) # 8000452e <argfd>
    return -1;
    80004872:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004874:	02054463          	bltz	a0,8000489c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004878:	ffffc097          	auipc	ra,0xffffc
    8000487c:	658080e7          	jalr	1624(ra) # 80000ed0 <myproc>
    80004880:	fec42783          	lw	a5,-20(s0)
    80004884:	07e9                	addi	a5,a5,26
    80004886:	078e                	slli	a5,a5,0x3
    80004888:	97aa                	add	a5,a5,a0
    8000488a:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000488e:	fe043503          	ld	a0,-32(s0)
    80004892:	fffff097          	auipc	ra,0xfffff
    80004896:	262080e7          	jalr	610(ra) # 80003af4 <fileclose>
  return 0;
    8000489a:	4781                	li	a5,0
}
    8000489c:	853e                	mv	a0,a5
    8000489e:	60e2                	ld	ra,24(sp)
    800048a0:	6442                	ld	s0,16(sp)
    800048a2:	6105                	addi	sp,sp,32
    800048a4:	8082                	ret

00000000800048a6 <sys_fstat>:
{
    800048a6:	1101                	addi	sp,sp,-32
    800048a8:	ec06                	sd	ra,24(sp)
    800048aa:	e822                	sd	s0,16(sp)
    800048ac:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800048ae:	fe040593          	addi	a1,s0,-32
    800048b2:	4505                	li	a0,1
    800048b4:	ffffd097          	auipc	ra,0xffffd
    800048b8:	78c080e7          	jalr	1932(ra) # 80002040 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800048bc:	fe840613          	addi	a2,s0,-24
    800048c0:	4581                	li	a1,0
    800048c2:	4501                	li	a0,0
    800048c4:	00000097          	auipc	ra,0x0
    800048c8:	c6a080e7          	jalr	-918(ra) # 8000452e <argfd>
    800048cc:	87aa                	mv	a5,a0
    return -1;
    800048ce:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048d0:	0007ca63          	bltz	a5,800048e4 <sys_fstat+0x3e>
  return filestat(f, st);
    800048d4:	fe043583          	ld	a1,-32(s0)
    800048d8:	fe843503          	ld	a0,-24(s0)
    800048dc:	fffff097          	auipc	ra,0xfffff
    800048e0:	2e0080e7          	jalr	736(ra) # 80003bbc <filestat>
}
    800048e4:	60e2                	ld	ra,24(sp)
    800048e6:	6442                	ld	s0,16(sp)
    800048e8:	6105                	addi	sp,sp,32
    800048ea:	8082                	ret

00000000800048ec <sys_link>:
{
    800048ec:	7169                	addi	sp,sp,-304
    800048ee:	f606                	sd	ra,296(sp)
    800048f0:	f222                	sd	s0,288(sp)
    800048f2:	ee26                	sd	s1,280(sp)
    800048f4:	ea4a                	sd	s2,272(sp)
    800048f6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048f8:	08000613          	li	a2,128
    800048fc:	ed040593          	addi	a1,s0,-304
    80004900:	4501                	li	a0,0
    80004902:	ffffd097          	auipc	ra,0xffffd
    80004906:	75e080e7          	jalr	1886(ra) # 80002060 <argstr>
    return -1;
    8000490a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000490c:	10054e63          	bltz	a0,80004a28 <sys_link+0x13c>
    80004910:	08000613          	li	a2,128
    80004914:	f5040593          	addi	a1,s0,-176
    80004918:	4505                	li	a0,1
    8000491a:	ffffd097          	auipc	ra,0xffffd
    8000491e:	746080e7          	jalr	1862(ra) # 80002060 <argstr>
    return -1;
    80004922:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004924:	10054263          	bltz	a0,80004a28 <sys_link+0x13c>
  begin_op();
    80004928:	fffff097          	auipc	ra,0xfffff
    8000492c:	d00080e7          	jalr	-768(ra) # 80003628 <begin_op>
  if((ip = namei(old)) == 0){
    80004930:	ed040513          	addi	a0,s0,-304
    80004934:	fffff097          	auipc	ra,0xfffff
    80004938:	ad8080e7          	jalr	-1320(ra) # 8000340c <namei>
    8000493c:	84aa                	mv	s1,a0
    8000493e:	c551                	beqz	a0,800049ca <sys_link+0xde>
  ilock(ip);
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	326080e7          	jalr	806(ra) # 80002c66 <ilock>
  if(ip->type == T_DIR){
    80004948:	04449703          	lh	a4,68(s1)
    8000494c:	4785                	li	a5,1
    8000494e:	08f70463          	beq	a4,a5,800049d6 <sys_link+0xea>
  ip->nlink++;
    80004952:	04a4d783          	lhu	a5,74(s1)
    80004956:	2785                	addiw	a5,a5,1
    80004958:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000495c:	8526                	mv	a0,s1
    8000495e:	ffffe097          	auipc	ra,0xffffe
    80004962:	23e080e7          	jalr	574(ra) # 80002b9c <iupdate>
  iunlock(ip);
    80004966:	8526                	mv	a0,s1
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	3c0080e7          	jalr	960(ra) # 80002d28 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004970:	fd040593          	addi	a1,s0,-48
    80004974:	f5040513          	addi	a0,s0,-176
    80004978:	fffff097          	auipc	ra,0xfffff
    8000497c:	ab2080e7          	jalr	-1358(ra) # 8000342a <nameiparent>
    80004980:	892a                	mv	s2,a0
    80004982:	c935                	beqz	a0,800049f6 <sys_link+0x10a>
  ilock(dp);
    80004984:	ffffe097          	auipc	ra,0xffffe
    80004988:	2e2080e7          	jalr	738(ra) # 80002c66 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000498c:	00092703          	lw	a4,0(s2)
    80004990:	409c                	lw	a5,0(s1)
    80004992:	04f71d63          	bne	a4,a5,800049ec <sys_link+0x100>
    80004996:	40d0                	lw	a2,4(s1)
    80004998:	fd040593          	addi	a1,s0,-48
    8000499c:	854a                	mv	a0,s2
    8000499e:	fffff097          	auipc	ra,0xfffff
    800049a2:	9bc080e7          	jalr	-1604(ra) # 8000335a <dirlink>
    800049a6:	04054363          	bltz	a0,800049ec <sys_link+0x100>
  iunlockput(dp);
    800049aa:	854a                	mv	a0,s2
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	51c080e7          	jalr	1308(ra) # 80002ec8 <iunlockput>
  iput(ip);
    800049b4:	8526                	mv	a0,s1
    800049b6:	ffffe097          	auipc	ra,0xffffe
    800049ba:	46a080e7          	jalr	1130(ra) # 80002e20 <iput>
  end_op();
    800049be:	fffff097          	auipc	ra,0xfffff
    800049c2:	cea080e7          	jalr	-790(ra) # 800036a8 <end_op>
  return 0;
    800049c6:	4781                	li	a5,0
    800049c8:	a085                	j	80004a28 <sys_link+0x13c>
    end_op();
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	cde080e7          	jalr	-802(ra) # 800036a8 <end_op>
    return -1;
    800049d2:	57fd                	li	a5,-1
    800049d4:	a891                	j	80004a28 <sys_link+0x13c>
    iunlockput(ip);
    800049d6:	8526                	mv	a0,s1
    800049d8:	ffffe097          	auipc	ra,0xffffe
    800049dc:	4f0080e7          	jalr	1264(ra) # 80002ec8 <iunlockput>
    end_op();
    800049e0:	fffff097          	auipc	ra,0xfffff
    800049e4:	cc8080e7          	jalr	-824(ra) # 800036a8 <end_op>
    return -1;
    800049e8:	57fd                	li	a5,-1
    800049ea:	a83d                	j	80004a28 <sys_link+0x13c>
    iunlockput(dp);
    800049ec:	854a                	mv	a0,s2
    800049ee:	ffffe097          	auipc	ra,0xffffe
    800049f2:	4da080e7          	jalr	1242(ra) # 80002ec8 <iunlockput>
  ilock(ip);
    800049f6:	8526                	mv	a0,s1
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	26e080e7          	jalr	622(ra) # 80002c66 <ilock>
  ip->nlink--;
    80004a00:	04a4d783          	lhu	a5,74(s1)
    80004a04:	37fd                	addiw	a5,a5,-1
    80004a06:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a0a:	8526                	mv	a0,s1
    80004a0c:	ffffe097          	auipc	ra,0xffffe
    80004a10:	190080e7          	jalr	400(ra) # 80002b9c <iupdate>
  iunlockput(ip);
    80004a14:	8526                	mv	a0,s1
    80004a16:	ffffe097          	auipc	ra,0xffffe
    80004a1a:	4b2080e7          	jalr	1202(ra) # 80002ec8 <iunlockput>
  end_op();
    80004a1e:	fffff097          	auipc	ra,0xfffff
    80004a22:	c8a080e7          	jalr	-886(ra) # 800036a8 <end_op>
  return -1;
    80004a26:	57fd                	li	a5,-1
}
    80004a28:	853e                	mv	a0,a5
    80004a2a:	70b2                	ld	ra,296(sp)
    80004a2c:	7412                	ld	s0,288(sp)
    80004a2e:	64f2                	ld	s1,280(sp)
    80004a30:	6952                	ld	s2,272(sp)
    80004a32:	6155                	addi	sp,sp,304
    80004a34:	8082                	ret

0000000080004a36 <sys_unlink>:
{
    80004a36:	7151                	addi	sp,sp,-240
    80004a38:	f586                	sd	ra,232(sp)
    80004a3a:	f1a2                	sd	s0,224(sp)
    80004a3c:	eda6                	sd	s1,216(sp)
    80004a3e:	e9ca                	sd	s2,208(sp)
    80004a40:	e5ce                	sd	s3,200(sp)
    80004a42:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a44:	08000613          	li	a2,128
    80004a48:	f3040593          	addi	a1,s0,-208
    80004a4c:	4501                	li	a0,0
    80004a4e:	ffffd097          	auipc	ra,0xffffd
    80004a52:	612080e7          	jalr	1554(ra) # 80002060 <argstr>
    80004a56:	18054163          	bltz	a0,80004bd8 <sys_unlink+0x1a2>
  begin_op();
    80004a5a:	fffff097          	auipc	ra,0xfffff
    80004a5e:	bce080e7          	jalr	-1074(ra) # 80003628 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a62:	fb040593          	addi	a1,s0,-80
    80004a66:	f3040513          	addi	a0,s0,-208
    80004a6a:	fffff097          	auipc	ra,0xfffff
    80004a6e:	9c0080e7          	jalr	-1600(ra) # 8000342a <nameiparent>
    80004a72:	84aa                	mv	s1,a0
    80004a74:	c979                	beqz	a0,80004b4a <sys_unlink+0x114>
  ilock(dp);
    80004a76:	ffffe097          	auipc	ra,0xffffe
    80004a7a:	1f0080e7          	jalr	496(ra) # 80002c66 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a7e:	00004597          	auipc	a1,0x4
    80004a82:	d0258593          	addi	a1,a1,-766 # 80008780 <syscalls+0x2a8>
    80004a86:	fb040513          	addi	a0,s0,-80
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	6a6080e7          	jalr	1702(ra) # 80003130 <namecmp>
    80004a92:	14050a63          	beqz	a0,80004be6 <sys_unlink+0x1b0>
    80004a96:	00004597          	auipc	a1,0x4
    80004a9a:	cf258593          	addi	a1,a1,-782 # 80008788 <syscalls+0x2b0>
    80004a9e:	fb040513          	addi	a0,s0,-80
    80004aa2:	ffffe097          	auipc	ra,0xffffe
    80004aa6:	68e080e7          	jalr	1678(ra) # 80003130 <namecmp>
    80004aaa:	12050e63          	beqz	a0,80004be6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004aae:	f2c40613          	addi	a2,s0,-212
    80004ab2:	fb040593          	addi	a1,s0,-80
    80004ab6:	8526                	mv	a0,s1
    80004ab8:	ffffe097          	auipc	ra,0xffffe
    80004abc:	692080e7          	jalr	1682(ra) # 8000314a <dirlookup>
    80004ac0:	892a                	mv	s2,a0
    80004ac2:	12050263          	beqz	a0,80004be6 <sys_unlink+0x1b0>
  ilock(ip);
    80004ac6:	ffffe097          	auipc	ra,0xffffe
    80004aca:	1a0080e7          	jalr	416(ra) # 80002c66 <ilock>
  if(ip->nlink < 1)
    80004ace:	04a91783          	lh	a5,74(s2)
    80004ad2:	08f05263          	blez	a5,80004b56 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ad6:	04491703          	lh	a4,68(s2)
    80004ada:	4785                	li	a5,1
    80004adc:	08f70563          	beq	a4,a5,80004b66 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004ae0:	4641                	li	a2,16
    80004ae2:	4581                	li	a1,0
    80004ae4:	fc040513          	addi	a0,s0,-64
    80004ae8:	ffffb097          	auipc	ra,0xffffb
    80004aec:	6b6080e7          	jalr	1718(ra) # 8000019e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004af0:	4741                	li	a4,16
    80004af2:	f2c42683          	lw	a3,-212(s0)
    80004af6:	fc040613          	addi	a2,s0,-64
    80004afa:	4581                	li	a1,0
    80004afc:	8526                	mv	a0,s1
    80004afe:	ffffe097          	auipc	ra,0xffffe
    80004b02:	514080e7          	jalr	1300(ra) # 80003012 <writei>
    80004b06:	47c1                	li	a5,16
    80004b08:	0af51563          	bne	a0,a5,80004bb2 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b0c:	04491703          	lh	a4,68(s2)
    80004b10:	4785                	li	a5,1
    80004b12:	0af70863          	beq	a4,a5,80004bc2 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b16:	8526                	mv	a0,s1
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	3b0080e7          	jalr	944(ra) # 80002ec8 <iunlockput>
  ip->nlink--;
    80004b20:	04a95783          	lhu	a5,74(s2)
    80004b24:	37fd                	addiw	a5,a5,-1
    80004b26:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b2a:	854a                	mv	a0,s2
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	070080e7          	jalr	112(ra) # 80002b9c <iupdate>
  iunlockput(ip);
    80004b34:	854a                	mv	a0,s2
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	392080e7          	jalr	914(ra) # 80002ec8 <iunlockput>
  end_op();
    80004b3e:	fffff097          	auipc	ra,0xfffff
    80004b42:	b6a080e7          	jalr	-1174(ra) # 800036a8 <end_op>
  return 0;
    80004b46:	4501                	li	a0,0
    80004b48:	a84d                	j	80004bfa <sys_unlink+0x1c4>
    end_op();
    80004b4a:	fffff097          	auipc	ra,0xfffff
    80004b4e:	b5e080e7          	jalr	-1186(ra) # 800036a8 <end_op>
    return -1;
    80004b52:	557d                	li	a0,-1
    80004b54:	a05d                	j	80004bfa <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b56:	00004517          	auipc	a0,0x4
    80004b5a:	c3a50513          	addi	a0,a0,-966 # 80008790 <syscalls+0x2b8>
    80004b5e:	00001097          	auipc	ra,0x1
    80004b62:	1b0080e7          	jalr	432(ra) # 80005d0e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b66:	04c92703          	lw	a4,76(s2)
    80004b6a:	02000793          	li	a5,32
    80004b6e:	f6e7f9e3          	bgeu	a5,a4,80004ae0 <sys_unlink+0xaa>
    80004b72:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b76:	4741                	li	a4,16
    80004b78:	86ce                	mv	a3,s3
    80004b7a:	f1840613          	addi	a2,s0,-232
    80004b7e:	4581                	li	a1,0
    80004b80:	854a                	mv	a0,s2
    80004b82:	ffffe097          	auipc	ra,0xffffe
    80004b86:	398080e7          	jalr	920(ra) # 80002f1a <readi>
    80004b8a:	47c1                	li	a5,16
    80004b8c:	00f51b63          	bne	a0,a5,80004ba2 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b90:	f1845783          	lhu	a5,-232(s0)
    80004b94:	e7a1                	bnez	a5,80004bdc <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b96:	29c1                	addiw	s3,s3,16
    80004b98:	04c92783          	lw	a5,76(s2)
    80004b9c:	fcf9ede3          	bltu	s3,a5,80004b76 <sys_unlink+0x140>
    80004ba0:	b781                	j	80004ae0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ba2:	00004517          	auipc	a0,0x4
    80004ba6:	c0650513          	addi	a0,a0,-1018 # 800087a8 <syscalls+0x2d0>
    80004baa:	00001097          	auipc	ra,0x1
    80004bae:	164080e7          	jalr	356(ra) # 80005d0e <panic>
    panic("unlink: writei");
    80004bb2:	00004517          	auipc	a0,0x4
    80004bb6:	c0e50513          	addi	a0,a0,-1010 # 800087c0 <syscalls+0x2e8>
    80004bba:	00001097          	auipc	ra,0x1
    80004bbe:	154080e7          	jalr	340(ra) # 80005d0e <panic>
    dp->nlink--;
    80004bc2:	04a4d783          	lhu	a5,74(s1)
    80004bc6:	37fd                	addiw	a5,a5,-1
    80004bc8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bcc:	8526                	mv	a0,s1
    80004bce:	ffffe097          	auipc	ra,0xffffe
    80004bd2:	fce080e7          	jalr	-50(ra) # 80002b9c <iupdate>
    80004bd6:	b781                	j	80004b16 <sys_unlink+0xe0>
    return -1;
    80004bd8:	557d                	li	a0,-1
    80004bda:	a005                	j	80004bfa <sys_unlink+0x1c4>
    iunlockput(ip);
    80004bdc:	854a                	mv	a0,s2
    80004bde:	ffffe097          	auipc	ra,0xffffe
    80004be2:	2ea080e7          	jalr	746(ra) # 80002ec8 <iunlockput>
  iunlockput(dp);
    80004be6:	8526                	mv	a0,s1
    80004be8:	ffffe097          	auipc	ra,0xffffe
    80004bec:	2e0080e7          	jalr	736(ra) # 80002ec8 <iunlockput>
  end_op();
    80004bf0:	fffff097          	auipc	ra,0xfffff
    80004bf4:	ab8080e7          	jalr	-1352(ra) # 800036a8 <end_op>
  return -1;
    80004bf8:	557d                	li	a0,-1
}
    80004bfa:	70ae                	ld	ra,232(sp)
    80004bfc:	740e                	ld	s0,224(sp)
    80004bfe:	64ee                	ld	s1,216(sp)
    80004c00:	694e                	ld	s2,208(sp)
    80004c02:	69ae                	ld	s3,200(sp)
    80004c04:	616d                	addi	sp,sp,240
    80004c06:	8082                	ret

0000000080004c08 <sys_open>:

uint64
sys_open(void)
{
    80004c08:	7131                	addi	sp,sp,-192
    80004c0a:	fd06                	sd	ra,184(sp)
    80004c0c:	f922                	sd	s0,176(sp)
    80004c0e:	f526                	sd	s1,168(sp)
    80004c10:	f14a                	sd	s2,160(sp)
    80004c12:	ed4e                	sd	s3,152(sp)
    80004c14:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c16:	f4c40593          	addi	a1,s0,-180
    80004c1a:	4505                	li	a0,1
    80004c1c:	ffffd097          	auipc	ra,0xffffd
    80004c20:	404080e7          	jalr	1028(ra) # 80002020 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c24:	08000613          	li	a2,128
    80004c28:	f5040593          	addi	a1,s0,-176
    80004c2c:	4501                	li	a0,0
    80004c2e:	ffffd097          	auipc	ra,0xffffd
    80004c32:	432080e7          	jalr	1074(ra) # 80002060 <argstr>
    80004c36:	87aa                	mv	a5,a0
    return -1;
    80004c38:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c3a:	0a07c963          	bltz	a5,80004cec <sys_open+0xe4>

  begin_op();
    80004c3e:	fffff097          	auipc	ra,0xfffff
    80004c42:	9ea080e7          	jalr	-1558(ra) # 80003628 <begin_op>

  if(omode & O_CREATE){
    80004c46:	f4c42783          	lw	a5,-180(s0)
    80004c4a:	2007f793          	andi	a5,a5,512
    80004c4e:	cfc5                	beqz	a5,80004d06 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c50:	4681                	li	a3,0
    80004c52:	4601                	li	a2,0
    80004c54:	4589                	li	a1,2
    80004c56:	f5040513          	addi	a0,s0,-176
    80004c5a:	00000097          	auipc	ra,0x0
    80004c5e:	976080e7          	jalr	-1674(ra) # 800045d0 <create>
    80004c62:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c64:	c959                	beqz	a0,80004cfa <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c66:	04449703          	lh	a4,68(s1)
    80004c6a:	478d                	li	a5,3
    80004c6c:	00f71763          	bne	a4,a5,80004c7a <sys_open+0x72>
    80004c70:	0464d703          	lhu	a4,70(s1)
    80004c74:	47a5                	li	a5,9
    80004c76:	0ce7ed63          	bltu	a5,a4,80004d50 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	dbe080e7          	jalr	-578(ra) # 80003a38 <filealloc>
    80004c82:	89aa                	mv	s3,a0
    80004c84:	10050363          	beqz	a0,80004d8a <sys_open+0x182>
    80004c88:	00000097          	auipc	ra,0x0
    80004c8c:	906080e7          	jalr	-1786(ra) # 8000458e <fdalloc>
    80004c90:	892a                	mv	s2,a0
    80004c92:	0e054763          	bltz	a0,80004d80 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c96:	04449703          	lh	a4,68(s1)
    80004c9a:	478d                	li	a5,3
    80004c9c:	0cf70563          	beq	a4,a5,80004d66 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ca0:	4789                	li	a5,2
    80004ca2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004ca6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004caa:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cae:	f4c42783          	lw	a5,-180(s0)
    80004cb2:	0017c713          	xori	a4,a5,1
    80004cb6:	8b05                	andi	a4,a4,1
    80004cb8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cbc:	0037f713          	andi	a4,a5,3
    80004cc0:	00e03733          	snez	a4,a4
    80004cc4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cc8:	4007f793          	andi	a5,a5,1024
    80004ccc:	c791                	beqz	a5,80004cd8 <sys_open+0xd0>
    80004cce:	04449703          	lh	a4,68(s1)
    80004cd2:	4789                	li	a5,2
    80004cd4:	0af70063          	beq	a4,a5,80004d74 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004cd8:	8526                	mv	a0,s1
    80004cda:	ffffe097          	auipc	ra,0xffffe
    80004cde:	04e080e7          	jalr	78(ra) # 80002d28 <iunlock>
  end_op();
    80004ce2:	fffff097          	auipc	ra,0xfffff
    80004ce6:	9c6080e7          	jalr	-1594(ra) # 800036a8 <end_op>

  return fd;
    80004cea:	854a                	mv	a0,s2
}
    80004cec:	70ea                	ld	ra,184(sp)
    80004cee:	744a                	ld	s0,176(sp)
    80004cf0:	74aa                	ld	s1,168(sp)
    80004cf2:	790a                	ld	s2,160(sp)
    80004cf4:	69ea                	ld	s3,152(sp)
    80004cf6:	6129                	addi	sp,sp,192
    80004cf8:	8082                	ret
      end_op();
    80004cfa:	fffff097          	auipc	ra,0xfffff
    80004cfe:	9ae080e7          	jalr	-1618(ra) # 800036a8 <end_op>
      return -1;
    80004d02:	557d                	li	a0,-1
    80004d04:	b7e5                	j	80004cec <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d06:	f5040513          	addi	a0,s0,-176
    80004d0a:	ffffe097          	auipc	ra,0xffffe
    80004d0e:	702080e7          	jalr	1794(ra) # 8000340c <namei>
    80004d12:	84aa                	mv	s1,a0
    80004d14:	c905                	beqz	a0,80004d44 <sys_open+0x13c>
    ilock(ip);
    80004d16:	ffffe097          	auipc	ra,0xffffe
    80004d1a:	f50080e7          	jalr	-176(ra) # 80002c66 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d1e:	04449703          	lh	a4,68(s1)
    80004d22:	4785                	li	a5,1
    80004d24:	f4f711e3          	bne	a4,a5,80004c66 <sys_open+0x5e>
    80004d28:	f4c42783          	lw	a5,-180(s0)
    80004d2c:	d7b9                	beqz	a5,80004c7a <sys_open+0x72>
      iunlockput(ip);
    80004d2e:	8526                	mv	a0,s1
    80004d30:	ffffe097          	auipc	ra,0xffffe
    80004d34:	198080e7          	jalr	408(ra) # 80002ec8 <iunlockput>
      end_op();
    80004d38:	fffff097          	auipc	ra,0xfffff
    80004d3c:	970080e7          	jalr	-1680(ra) # 800036a8 <end_op>
      return -1;
    80004d40:	557d                	li	a0,-1
    80004d42:	b76d                	j	80004cec <sys_open+0xe4>
      end_op();
    80004d44:	fffff097          	auipc	ra,0xfffff
    80004d48:	964080e7          	jalr	-1692(ra) # 800036a8 <end_op>
      return -1;
    80004d4c:	557d                	li	a0,-1
    80004d4e:	bf79                	j	80004cec <sys_open+0xe4>
    iunlockput(ip);
    80004d50:	8526                	mv	a0,s1
    80004d52:	ffffe097          	auipc	ra,0xffffe
    80004d56:	176080e7          	jalr	374(ra) # 80002ec8 <iunlockput>
    end_op();
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	94e080e7          	jalr	-1714(ra) # 800036a8 <end_op>
    return -1;
    80004d62:	557d                	li	a0,-1
    80004d64:	b761                	j	80004cec <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d66:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d6a:	04649783          	lh	a5,70(s1)
    80004d6e:	02f99223          	sh	a5,36(s3)
    80004d72:	bf25                	j	80004caa <sys_open+0xa2>
    itrunc(ip);
    80004d74:	8526                	mv	a0,s1
    80004d76:	ffffe097          	auipc	ra,0xffffe
    80004d7a:	ffe080e7          	jalr	-2(ra) # 80002d74 <itrunc>
    80004d7e:	bfa9                	j	80004cd8 <sys_open+0xd0>
      fileclose(f);
    80004d80:	854e                	mv	a0,s3
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	d72080e7          	jalr	-654(ra) # 80003af4 <fileclose>
    iunlockput(ip);
    80004d8a:	8526                	mv	a0,s1
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	13c080e7          	jalr	316(ra) # 80002ec8 <iunlockput>
    end_op();
    80004d94:	fffff097          	auipc	ra,0xfffff
    80004d98:	914080e7          	jalr	-1772(ra) # 800036a8 <end_op>
    return -1;
    80004d9c:	557d                	li	a0,-1
    80004d9e:	b7b9                	j	80004cec <sys_open+0xe4>

0000000080004da0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004da0:	7175                	addi	sp,sp,-144
    80004da2:	e506                	sd	ra,136(sp)
    80004da4:	e122                	sd	s0,128(sp)
    80004da6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004da8:	fffff097          	auipc	ra,0xfffff
    80004dac:	880080e7          	jalr	-1920(ra) # 80003628 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004db0:	08000613          	li	a2,128
    80004db4:	f7040593          	addi	a1,s0,-144
    80004db8:	4501                	li	a0,0
    80004dba:	ffffd097          	auipc	ra,0xffffd
    80004dbe:	2a6080e7          	jalr	678(ra) # 80002060 <argstr>
    80004dc2:	02054963          	bltz	a0,80004df4 <sys_mkdir+0x54>
    80004dc6:	4681                	li	a3,0
    80004dc8:	4601                	li	a2,0
    80004dca:	4585                	li	a1,1
    80004dcc:	f7040513          	addi	a0,s0,-144
    80004dd0:	00000097          	auipc	ra,0x0
    80004dd4:	800080e7          	jalr	-2048(ra) # 800045d0 <create>
    80004dd8:	cd11                	beqz	a0,80004df4 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dda:	ffffe097          	auipc	ra,0xffffe
    80004dde:	0ee080e7          	jalr	238(ra) # 80002ec8 <iunlockput>
  end_op();
    80004de2:	fffff097          	auipc	ra,0xfffff
    80004de6:	8c6080e7          	jalr	-1850(ra) # 800036a8 <end_op>
  return 0;
    80004dea:	4501                	li	a0,0
}
    80004dec:	60aa                	ld	ra,136(sp)
    80004dee:	640a                	ld	s0,128(sp)
    80004df0:	6149                	addi	sp,sp,144
    80004df2:	8082                	ret
    end_op();
    80004df4:	fffff097          	auipc	ra,0xfffff
    80004df8:	8b4080e7          	jalr	-1868(ra) # 800036a8 <end_op>
    return -1;
    80004dfc:	557d                	li	a0,-1
    80004dfe:	b7fd                	j	80004dec <sys_mkdir+0x4c>

0000000080004e00 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e00:	7135                	addi	sp,sp,-160
    80004e02:	ed06                	sd	ra,152(sp)
    80004e04:	e922                	sd	s0,144(sp)
    80004e06:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	820080e7          	jalr	-2016(ra) # 80003628 <begin_op>
  argint(1, &major);
    80004e10:	f6c40593          	addi	a1,s0,-148
    80004e14:	4505                	li	a0,1
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	20a080e7          	jalr	522(ra) # 80002020 <argint>
  argint(2, &minor);
    80004e1e:	f6840593          	addi	a1,s0,-152
    80004e22:	4509                	li	a0,2
    80004e24:	ffffd097          	auipc	ra,0xffffd
    80004e28:	1fc080e7          	jalr	508(ra) # 80002020 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e2c:	08000613          	li	a2,128
    80004e30:	f7040593          	addi	a1,s0,-144
    80004e34:	4501                	li	a0,0
    80004e36:	ffffd097          	auipc	ra,0xffffd
    80004e3a:	22a080e7          	jalr	554(ra) # 80002060 <argstr>
    80004e3e:	02054b63          	bltz	a0,80004e74 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e42:	f6841683          	lh	a3,-152(s0)
    80004e46:	f6c41603          	lh	a2,-148(s0)
    80004e4a:	458d                	li	a1,3
    80004e4c:	f7040513          	addi	a0,s0,-144
    80004e50:	fffff097          	auipc	ra,0xfffff
    80004e54:	780080e7          	jalr	1920(ra) # 800045d0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e58:	cd11                	beqz	a0,80004e74 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e5a:	ffffe097          	auipc	ra,0xffffe
    80004e5e:	06e080e7          	jalr	110(ra) # 80002ec8 <iunlockput>
  end_op();
    80004e62:	fffff097          	auipc	ra,0xfffff
    80004e66:	846080e7          	jalr	-1978(ra) # 800036a8 <end_op>
  return 0;
    80004e6a:	4501                	li	a0,0
}
    80004e6c:	60ea                	ld	ra,152(sp)
    80004e6e:	644a                	ld	s0,144(sp)
    80004e70:	610d                	addi	sp,sp,160
    80004e72:	8082                	ret
    end_op();
    80004e74:	fffff097          	auipc	ra,0xfffff
    80004e78:	834080e7          	jalr	-1996(ra) # 800036a8 <end_op>
    return -1;
    80004e7c:	557d                	li	a0,-1
    80004e7e:	b7fd                	j	80004e6c <sys_mknod+0x6c>

0000000080004e80 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e80:	7135                	addi	sp,sp,-160
    80004e82:	ed06                	sd	ra,152(sp)
    80004e84:	e922                	sd	s0,144(sp)
    80004e86:	e526                	sd	s1,136(sp)
    80004e88:	e14a                	sd	s2,128(sp)
    80004e8a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e8c:	ffffc097          	auipc	ra,0xffffc
    80004e90:	044080e7          	jalr	68(ra) # 80000ed0 <myproc>
    80004e94:	892a                	mv	s2,a0
  
  begin_op();
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	792080e7          	jalr	1938(ra) # 80003628 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e9e:	08000613          	li	a2,128
    80004ea2:	f6040593          	addi	a1,s0,-160
    80004ea6:	4501                	li	a0,0
    80004ea8:	ffffd097          	auipc	ra,0xffffd
    80004eac:	1b8080e7          	jalr	440(ra) # 80002060 <argstr>
    80004eb0:	04054b63          	bltz	a0,80004f06 <sys_chdir+0x86>
    80004eb4:	f6040513          	addi	a0,s0,-160
    80004eb8:	ffffe097          	auipc	ra,0xffffe
    80004ebc:	554080e7          	jalr	1364(ra) # 8000340c <namei>
    80004ec0:	84aa                	mv	s1,a0
    80004ec2:	c131                	beqz	a0,80004f06 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ec4:	ffffe097          	auipc	ra,0xffffe
    80004ec8:	da2080e7          	jalr	-606(ra) # 80002c66 <ilock>
  if(ip->type != T_DIR){
    80004ecc:	04449703          	lh	a4,68(s1)
    80004ed0:	4785                	li	a5,1
    80004ed2:	04f71063          	bne	a4,a5,80004f12 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ed6:	8526                	mv	a0,s1
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	e50080e7          	jalr	-432(ra) # 80002d28 <iunlock>
  iput(p->cwd);
    80004ee0:	15093503          	ld	a0,336(s2)
    80004ee4:	ffffe097          	auipc	ra,0xffffe
    80004ee8:	f3c080e7          	jalr	-196(ra) # 80002e20 <iput>
  end_op();
    80004eec:	ffffe097          	auipc	ra,0xffffe
    80004ef0:	7bc080e7          	jalr	1980(ra) # 800036a8 <end_op>
  p->cwd = ip;
    80004ef4:	14993823          	sd	s1,336(s2)
  return 0;
    80004ef8:	4501                	li	a0,0
}
    80004efa:	60ea                	ld	ra,152(sp)
    80004efc:	644a                	ld	s0,144(sp)
    80004efe:	64aa                	ld	s1,136(sp)
    80004f00:	690a                	ld	s2,128(sp)
    80004f02:	610d                	addi	sp,sp,160
    80004f04:	8082                	ret
    end_op();
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	7a2080e7          	jalr	1954(ra) # 800036a8 <end_op>
    return -1;
    80004f0e:	557d                	li	a0,-1
    80004f10:	b7ed                	j	80004efa <sys_chdir+0x7a>
    iunlockput(ip);
    80004f12:	8526                	mv	a0,s1
    80004f14:	ffffe097          	auipc	ra,0xffffe
    80004f18:	fb4080e7          	jalr	-76(ra) # 80002ec8 <iunlockput>
    end_op();
    80004f1c:	ffffe097          	auipc	ra,0xffffe
    80004f20:	78c080e7          	jalr	1932(ra) # 800036a8 <end_op>
    return -1;
    80004f24:	557d                	li	a0,-1
    80004f26:	bfd1                	j	80004efa <sys_chdir+0x7a>

0000000080004f28 <sys_exec>:

uint64
sys_exec(void)
{
    80004f28:	7145                	addi	sp,sp,-464
    80004f2a:	e786                	sd	ra,456(sp)
    80004f2c:	e3a2                	sd	s0,448(sp)
    80004f2e:	ff26                	sd	s1,440(sp)
    80004f30:	fb4a                	sd	s2,432(sp)
    80004f32:	f74e                	sd	s3,424(sp)
    80004f34:	f352                	sd	s4,416(sp)
    80004f36:	ef56                	sd	s5,408(sp)
    80004f38:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f3a:	e3840593          	addi	a1,s0,-456
    80004f3e:	4505                	li	a0,1
    80004f40:	ffffd097          	auipc	ra,0xffffd
    80004f44:	100080e7          	jalr	256(ra) # 80002040 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f48:	08000613          	li	a2,128
    80004f4c:	f4040593          	addi	a1,s0,-192
    80004f50:	4501                	li	a0,0
    80004f52:	ffffd097          	auipc	ra,0xffffd
    80004f56:	10e080e7          	jalr	270(ra) # 80002060 <argstr>
    80004f5a:	87aa                	mv	a5,a0
    return -1;
    80004f5c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f5e:	0c07c263          	bltz	a5,80005022 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f62:	10000613          	li	a2,256
    80004f66:	4581                	li	a1,0
    80004f68:	e4040513          	addi	a0,s0,-448
    80004f6c:	ffffb097          	auipc	ra,0xffffb
    80004f70:	232080e7          	jalr	562(ra) # 8000019e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f74:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f78:	89a6                	mv	s3,s1
    80004f7a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f7c:	02000a13          	li	s4,32
    80004f80:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f84:	00391793          	slli	a5,s2,0x3
    80004f88:	e3040593          	addi	a1,s0,-464
    80004f8c:	e3843503          	ld	a0,-456(s0)
    80004f90:	953e                	add	a0,a0,a5
    80004f92:	ffffd097          	auipc	ra,0xffffd
    80004f96:	ff0080e7          	jalr	-16(ra) # 80001f82 <fetchaddr>
    80004f9a:	02054a63          	bltz	a0,80004fce <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004f9e:	e3043783          	ld	a5,-464(s0)
    80004fa2:	c3b9                	beqz	a5,80004fe8 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fa4:	ffffb097          	auipc	ra,0xffffb
    80004fa8:	174080e7          	jalr	372(ra) # 80000118 <kalloc>
    80004fac:	85aa                	mv	a1,a0
    80004fae:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fb2:	cd11                	beqz	a0,80004fce <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fb4:	6605                	lui	a2,0x1
    80004fb6:	e3043503          	ld	a0,-464(s0)
    80004fba:	ffffd097          	auipc	ra,0xffffd
    80004fbe:	01a080e7          	jalr	26(ra) # 80001fd4 <fetchstr>
    80004fc2:	00054663          	bltz	a0,80004fce <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004fc6:	0905                	addi	s2,s2,1
    80004fc8:	09a1                	addi	s3,s3,8
    80004fca:	fb491be3          	bne	s2,s4,80004f80 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fce:	10048913          	addi	s2,s1,256
    80004fd2:	6088                	ld	a0,0(s1)
    80004fd4:	c531                	beqz	a0,80005020 <sys_exec+0xf8>
    kfree(argv[i]);
    80004fd6:	ffffb097          	auipc	ra,0xffffb
    80004fda:	046080e7          	jalr	70(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fde:	04a1                	addi	s1,s1,8
    80004fe0:	ff2499e3          	bne	s1,s2,80004fd2 <sys_exec+0xaa>
  return -1;
    80004fe4:	557d                	li	a0,-1
    80004fe6:	a835                	j	80005022 <sys_exec+0xfa>
      argv[i] = 0;
    80004fe8:	0a8e                	slli	s5,s5,0x3
    80004fea:	fc040793          	addi	a5,s0,-64
    80004fee:	9abe                	add	s5,s5,a5
    80004ff0:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ff4:	e4040593          	addi	a1,s0,-448
    80004ff8:	f4040513          	addi	a0,s0,-192
    80004ffc:	fffff097          	auipc	ra,0xfffff
    80005000:	172080e7          	jalr	370(ra) # 8000416e <exec>
    80005004:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005006:	10048993          	addi	s3,s1,256
    8000500a:	6088                	ld	a0,0(s1)
    8000500c:	c901                	beqz	a0,8000501c <sys_exec+0xf4>
    kfree(argv[i]);
    8000500e:	ffffb097          	auipc	ra,0xffffb
    80005012:	00e080e7          	jalr	14(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005016:	04a1                	addi	s1,s1,8
    80005018:	ff3499e3          	bne	s1,s3,8000500a <sys_exec+0xe2>
  return ret;
    8000501c:	854a                	mv	a0,s2
    8000501e:	a011                	j	80005022 <sys_exec+0xfa>
  return -1;
    80005020:	557d                	li	a0,-1
}
    80005022:	60be                	ld	ra,456(sp)
    80005024:	641e                	ld	s0,448(sp)
    80005026:	74fa                	ld	s1,440(sp)
    80005028:	795a                	ld	s2,432(sp)
    8000502a:	79ba                	ld	s3,424(sp)
    8000502c:	7a1a                	ld	s4,416(sp)
    8000502e:	6afa                	ld	s5,408(sp)
    80005030:	6179                	addi	sp,sp,464
    80005032:	8082                	ret

0000000080005034 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005034:	7139                	addi	sp,sp,-64
    80005036:	fc06                	sd	ra,56(sp)
    80005038:	f822                	sd	s0,48(sp)
    8000503a:	f426                	sd	s1,40(sp)
    8000503c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000503e:	ffffc097          	auipc	ra,0xffffc
    80005042:	e92080e7          	jalr	-366(ra) # 80000ed0 <myproc>
    80005046:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005048:	fd840593          	addi	a1,s0,-40
    8000504c:	4501                	li	a0,0
    8000504e:	ffffd097          	auipc	ra,0xffffd
    80005052:	ff2080e7          	jalr	-14(ra) # 80002040 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005056:	fc840593          	addi	a1,s0,-56
    8000505a:	fd040513          	addi	a0,s0,-48
    8000505e:	fffff097          	auipc	ra,0xfffff
    80005062:	dc6080e7          	jalr	-570(ra) # 80003e24 <pipealloc>
    return -1;
    80005066:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005068:	0c054463          	bltz	a0,80005130 <sys_pipe+0xfc>
  fd0 = -1;
    8000506c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005070:	fd043503          	ld	a0,-48(s0)
    80005074:	fffff097          	auipc	ra,0xfffff
    80005078:	51a080e7          	jalr	1306(ra) # 8000458e <fdalloc>
    8000507c:	fca42223          	sw	a0,-60(s0)
    80005080:	08054b63          	bltz	a0,80005116 <sys_pipe+0xe2>
    80005084:	fc843503          	ld	a0,-56(s0)
    80005088:	fffff097          	auipc	ra,0xfffff
    8000508c:	506080e7          	jalr	1286(ra) # 8000458e <fdalloc>
    80005090:	fca42023          	sw	a0,-64(s0)
    80005094:	06054863          	bltz	a0,80005104 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005098:	4691                	li	a3,4
    8000509a:	fc440613          	addi	a2,s0,-60
    8000509e:	fd843583          	ld	a1,-40(s0)
    800050a2:	68a8                	ld	a0,80(s1)
    800050a4:	ffffc097          	auipc	ra,0xffffc
    800050a8:	ab4080e7          	jalr	-1356(ra) # 80000b58 <copyout>
    800050ac:	02054063          	bltz	a0,800050cc <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050b0:	4691                	li	a3,4
    800050b2:	fc040613          	addi	a2,s0,-64
    800050b6:	fd843583          	ld	a1,-40(s0)
    800050ba:	0591                	addi	a1,a1,4
    800050bc:	68a8                	ld	a0,80(s1)
    800050be:	ffffc097          	auipc	ra,0xffffc
    800050c2:	a9a080e7          	jalr	-1382(ra) # 80000b58 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050c6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050c8:	06055463          	bgez	a0,80005130 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800050cc:	fc442783          	lw	a5,-60(s0)
    800050d0:	07e9                	addi	a5,a5,26
    800050d2:	078e                	slli	a5,a5,0x3
    800050d4:	97a6                	add	a5,a5,s1
    800050d6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050da:	fc042503          	lw	a0,-64(s0)
    800050de:	0569                	addi	a0,a0,26
    800050e0:	050e                	slli	a0,a0,0x3
    800050e2:	94aa                	add	s1,s1,a0
    800050e4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800050e8:	fd043503          	ld	a0,-48(s0)
    800050ec:	fffff097          	auipc	ra,0xfffff
    800050f0:	a08080e7          	jalr	-1528(ra) # 80003af4 <fileclose>
    fileclose(wf);
    800050f4:	fc843503          	ld	a0,-56(s0)
    800050f8:	fffff097          	auipc	ra,0xfffff
    800050fc:	9fc080e7          	jalr	-1540(ra) # 80003af4 <fileclose>
    return -1;
    80005100:	57fd                	li	a5,-1
    80005102:	a03d                	j	80005130 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005104:	fc442783          	lw	a5,-60(s0)
    80005108:	0007c763          	bltz	a5,80005116 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000510c:	07e9                	addi	a5,a5,26
    8000510e:	078e                	slli	a5,a5,0x3
    80005110:	94be                	add	s1,s1,a5
    80005112:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005116:	fd043503          	ld	a0,-48(s0)
    8000511a:	fffff097          	auipc	ra,0xfffff
    8000511e:	9da080e7          	jalr	-1574(ra) # 80003af4 <fileclose>
    fileclose(wf);
    80005122:	fc843503          	ld	a0,-56(s0)
    80005126:	fffff097          	auipc	ra,0xfffff
    8000512a:	9ce080e7          	jalr	-1586(ra) # 80003af4 <fileclose>
    return -1;
    8000512e:	57fd                	li	a5,-1
}
    80005130:	853e                	mv	a0,a5
    80005132:	70e2                	ld	ra,56(sp)
    80005134:	7442                	ld	s0,48(sp)
    80005136:	74a2                	ld	s1,40(sp)
    80005138:	6121                	addi	sp,sp,64
    8000513a:	8082                	ret
    8000513c:	0000                	unimp
	...

0000000080005140 <kernelvec>:
    80005140:	7111                	addi	sp,sp,-256
    80005142:	e006                	sd	ra,0(sp)
    80005144:	e40a                	sd	sp,8(sp)
    80005146:	e80e                	sd	gp,16(sp)
    80005148:	ec12                	sd	tp,24(sp)
    8000514a:	f016                	sd	t0,32(sp)
    8000514c:	f41a                	sd	t1,40(sp)
    8000514e:	f81e                	sd	t2,48(sp)
    80005150:	fc22                	sd	s0,56(sp)
    80005152:	e0a6                	sd	s1,64(sp)
    80005154:	e4aa                	sd	a0,72(sp)
    80005156:	e8ae                	sd	a1,80(sp)
    80005158:	ecb2                	sd	a2,88(sp)
    8000515a:	f0b6                	sd	a3,96(sp)
    8000515c:	f4ba                	sd	a4,104(sp)
    8000515e:	f8be                	sd	a5,112(sp)
    80005160:	fcc2                	sd	a6,120(sp)
    80005162:	e146                	sd	a7,128(sp)
    80005164:	e54a                	sd	s2,136(sp)
    80005166:	e94e                	sd	s3,144(sp)
    80005168:	ed52                	sd	s4,152(sp)
    8000516a:	f156                	sd	s5,160(sp)
    8000516c:	f55a                	sd	s6,168(sp)
    8000516e:	f95e                	sd	s7,176(sp)
    80005170:	fd62                	sd	s8,184(sp)
    80005172:	e1e6                	sd	s9,192(sp)
    80005174:	e5ea                	sd	s10,200(sp)
    80005176:	e9ee                	sd	s11,208(sp)
    80005178:	edf2                	sd	t3,216(sp)
    8000517a:	f1f6                	sd	t4,224(sp)
    8000517c:	f5fa                	sd	t5,232(sp)
    8000517e:	f9fe                	sd	t6,240(sp)
    80005180:	ccffc0ef          	jal	ra,80001e4e <kerneltrap>
    80005184:	6082                	ld	ra,0(sp)
    80005186:	6122                	ld	sp,8(sp)
    80005188:	61c2                	ld	gp,16(sp)
    8000518a:	7282                	ld	t0,32(sp)
    8000518c:	7322                	ld	t1,40(sp)
    8000518e:	73c2                	ld	t2,48(sp)
    80005190:	7462                	ld	s0,56(sp)
    80005192:	6486                	ld	s1,64(sp)
    80005194:	6526                	ld	a0,72(sp)
    80005196:	65c6                	ld	a1,80(sp)
    80005198:	6666                	ld	a2,88(sp)
    8000519a:	7686                	ld	a3,96(sp)
    8000519c:	7726                	ld	a4,104(sp)
    8000519e:	77c6                	ld	a5,112(sp)
    800051a0:	7866                	ld	a6,120(sp)
    800051a2:	688a                	ld	a7,128(sp)
    800051a4:	692a                	ld	s2,136(sp)
    800051a6:	69ca                	ld	s3,144(sp)
    800051a8:	6a6a                	ld	s4,152(sp)
    800051aa:	7a8a                	ld	s5,160(sp)
    800051ac:	7b2a                	ld	s6,168(sp)
    800051ae:	7bca                	ld	s7,176(sp)
    800051b0:	7c6a                	ld	s8,184(sp)
    800051b2:	6c8e                	ld	s9,192(sp)
    800051b4:	6d2e                	ld	s10,200(sp)
    800051b6:	6dce                	ld	s11,208(sp)
    800051b8:	6e6e                	ld	t3,216(sp)
    800051ba:	7e8e                	ld	t4,224(sp)
    800051bc:	7f2e                	ld	t5,232(sp)
    800051be:	7fce                	ld	t6,240(sp)
    800051c0:	6111                	addi	sp,sp,256
    800051c2:	10200073          	sret
    800051c6:	00000013          	nop
    800051ca:	00000013          	nop
    800051ce:	0001                	nop

00000000800051d0 <timervec>:
    800051d0:	34051573          	csrrw	a0,mscratch,a0
    800051d4:	e10c                	sd	a1,0(a0)
    800051d6:	e510                	sd	a2,8(a0)
    800051d8:	e914                	sd	a3,16(a0)
    800051da:	6d0c                	ld	a1,24(a0)
    800051dc:	7110                	ld	a2,32(a0)
    800051de:	6194                	ld	a3,0(a1)
    800051e0:	96b2                	add	a3,a3,a2
    800051e2:	e194                	sd	a3,0(a1)
    800051e4:	4589                	li	a1,2
    800051e6:	14459073          	csrw	sip,a1
    800051ea:	6914                	ld	a3,16(a0)
    800051ec:	6510                	ld	a2,8(a0)
    800051ee:	610c                	ld	a1,0(a0)
    800051f0:	34051573          	csrrw	a0,mscratch,a0
    800051f4:	30200073          	mret
	...

00000000800051fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051fa:	1141                	addi	sp,sp,-16
    800051fc:	e422                	sd	s0,8(sp)
    800051fe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005200:	0c0007b7          	lui	a5,0xc000
    80005204:	4705                	li	a4,1
    80005206:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005208:	c3d8                	sw	a4,4(a5)
}
    8000520a:	6422                	ld	s0,8(sp)
    8000520c:	0141                	addi	sp,sp,16
    8000520e:	8082                	ret

0000000080005210 <plicinithart>:

void
plicinithart(void)
{
    80005210:	1141                	addi	sp,sp,-16
    80005212:	e406                	sd	ra,8(sp)
    80005214:	e022                	sd	s0,0(sp)
    80005216:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005218:	ffffc097          	auipc	ra,0xffffc
    8000521c:	c8c080e7          	jalr	-884(ra) # 80000ea4 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005220:	0085171b          	slliw	a4,a0,0x8
    80005224:	0c0027b7          	lui	a5,0xc002
    80005228:	97ba                	add	a5,a5,a4
    8000522a:	40200713          	li	a4,1026
    8000522e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005232:	00d5151b          	slliw	a0,a0,0xd
    80005236:	0c2017b7          	lui	a5,0xc201
    8000523a:	953e                	add	a0,a0,a5
    8000523c:	00052023          	sw	zero,0(a0)
}
    80005240:	60a2                	ld	ra,8(sp)
    80005242:	6402                	ld	s0,0(sp)
    80005244:	0141                	addi	sp,sp,16
    80005246:	8082                	ret

0000000080005248 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005248:	1141                	addi	sp,sp,-16
    8000524a:	e406                	sd	ra,8(sp)
    8000524c:	e022                	sd	s0,0(sp)
    8000524e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005250:	ffffc097          	auipc	ra,0xffffc
    80005254:	c54080e7          	jalr	-940(ra) # 80000ea4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005258:	00d5179b          	slliw	a5,a0,0xd
    8000525c:	0c201537          	lui	a0,0xc201
    80005260:	953e                	add	a0,a0,a5
  return irq;
}
    80005262:	4148                	lw	a0,4(a0)
    80005264:	60a2                	ld	ra,8(sp)
    80005266:	6402                	ld	s0,0(sp)
    80005268:	0141                	addi	sp,sp,16
    8000526a:	8082                	ret

000000008000526c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000526c:	1101                	addi	sp,sp,-32
    8000526e:	ec06                	sd	ra,24(sp)
    80005270:	e822                	sd	s0,16(sp)
    80005272:	e426                	sd	s1,8(sp)
    80005274:	1000                	addi	s0,sp,32
    80005276:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005278:	ffffc097          	auipc	ra,0xffffc
    8000527c:	c2c080e7          	jalr	-980(ra) # 80000ea4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005280:	00d5151b          	slliw	a0,a0,0xd
    80005284:	0c2017b7          	lui	a5,0xc201
    80005288:	97aa                	add	a5,a5,a0
    8000528a:	c3c4                	sw	s1,4(a5)
}
    8000528c:	60e2                	ld	ra,24(sp)
    8000528e:	6442                	ld	s0,16(sp)
    80005290:	64a2                	ld	s1,8(sp)
    80005292:	6105                	addi	sp,sp,32
    80005294:	8082                	ret

0000000080005296 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005296:	1141                	addi	sp,sp,-16
    80005298:	e406                	sd	ra,8(sp)
    8000529a:	e022                	sd	s0,0(sp)
    8000529c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000529e:	479d                	li	a5,7
    800052a0:	04a7cc63          	blt	a5,a0,800052f8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800052a4:	00015797          	auipc	a5,0x15
    800052a8:	acc78793          	addi	a5,a5,-1332 # 80019d70 <disk>
    800052ac:	97aa                	add	a5,a5,a0
    800052ae:	0187c783          	lbu	a5,24(a5)
    800052b2:	ebb9                	bnez	a5,80005308 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052b4:	00451613          	slli	a2,a0,0x4
    800052b8:	00015797          	auipc	a5,0x15
    800052bc:	ab878793          	addi	a5,a5,-1352 # 80019d70 <disk>
    800052c0:	6394                	ld	a3,0(a5)
    800052c2:	96b2                	add	a3,a3,a2
    800052c4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052c8:	6398                	ld	a4,0(a5)
    800052ca:	9732                	add	a4,a4,a2
    800052cc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800052d0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800052d4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052d8:	953e                	add	a0,a0,a5
    800052da:	4785                	li	a5,1
    800052dc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800052e0:	00015517          	auipc	a0,0x15
    800052e4:	aa850513          	addi	a0,a0,-1368 # 80019d88 <disk+0x18>
    800052e8:	ffffc097          	auipc	ra,0xffffc
    800052ec:	300080e7          	jalr	768(ra) # 800015e8 <wakeup>
}
    800052f0:	60a2                	ld	ra,8(sp)
    800052f2:	6402                	ld	s0,0(sp)
    800052f4:	0141                	addi	sp,sp,16
    800052f6:	8082                	ret
    panic("free_desc 1");
    800052f8:	00003517          	auipc	a0,0x3
    800052fc:	4d850513          	addi	a0,a0,1240 # 800087d0 <syscalls+0x2f8>
    80005300:	00001097          	auipc	ra,0x1
    80005304:	a0e080e7          	jalr	-1522(ra) # 80005d0e <panic>
    panic("free_desc 2");
    80005308:	00003517          	auipc	a0,0x3
    8000530c:	4d850513          	addi	a0,a0,1240 # 800087e0 <syscalls+0x308>
    80005310:	00001097          	auipc	ra,0x1
    80005314:	9fe080e7          	jalr	-1538(ra) # 80005d0e <panic>

0000000080005318 <virtio_disk_init>:
{
    80005318:	1101                	addi	sp,sp,-32
    8000531a:	ec06                	sd	ra,24(sp)
    8000531c:	e822                	sd	s0,16(sp)
    8000531e:	e426                	sd	s1,8(sp)
    80005320:	e04a                	sd	s2,0(sp)
    80005322:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005324:	00003597          	auipc	a1,0x3
    80005328:	4cc58593          	addi	a1,a1,1228 # 800087f0 <syscalls+0x318>
    8000532c:	00015517          	auipc	a0,0x15
    80005330:	b6c50513          	addi	a0,a0,-1172 # 80019e98 <disk+0x128>
    80005334:	00001097          	auipc	ra,0x1
    80005338:	e86080e7          	jalr	-378(ra) # 800061ba <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000533c:	100017b7          	lui	a5,0x10001
    80005340:	4398                	lw	a4,0(a5)
    80005342:	2701                	sext.w	a4,a4
    80005344:	747277b7          	lui	a5,0x74727
    80005348:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000534c:	14f71c63          	bne	a4,a5,800054a4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005350:	100017b7          	lui	a5,0x10001
    80005354:	43dc                	lw	a5,4(a5)
    80005356:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005358:	4709                	li	a4,2
    8000535a:	14e79563          	bne	a5,a4,800054a4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000535e:	100017b7          	lui	a5,0x10001
    80005362:	479c                	lw	a5,8(a5)
    80005364:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005366:	12e79f63          	bne	a5,a4,800054a4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000536a:	100017b7          	lui	a5,0x10001
    8000536e:	47d8                	lw	a4,12(a5)
    80005370:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005372:	554d47b7          	lui	a5,0x554d4
    80005376:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000537a:	12f71563          	bne	a4,a5,800054a4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000537e:	100017b7          	lui	a5,0x10001
    80005382:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005386:	4705                	li	a4,1
    80005388:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000538a:	470d                	li	a4,3
    8000538c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000538e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005390:	c7ffe737          	lui	a4,0xc7ffe
    80005394:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc66f>
    80005398:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000539a:	2701                	sext.w	a4,a4
    8000539c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000539e:	472d                	li	a4,11
    800053a0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800053a2:	5bbc                	lw	a5,112(a5)
    800053a4:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800053a8:	8ba1                	andi	a5,a5,8
    800053aa:	10078563          	beqz	a5,800054b4 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053ae:	100017b7          	lui	a5,0x10001
    800053b2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800053b6:	43fc                	lw	a5,68(a5)
    800053b8:	2781                	sext.w	a5,a5
    800053ba:	10079563          	bnez	a5,800054c4 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053be:	100017b7          	lui	a5,0x10001
    800053c2:	5bdc                	lw	a5,52(a5)
    800053c4:	2781                	sext.w	a5,a5
  if(max == 0)
    800053c6:	10078763          	beqz	a5,800054d4 <virtio_disk_init+0x1bc>
  if(max < NUM)
    800053ca:	471d                	li	a4,7
    800053cc:	10f77c63          	bgeu	a4,a5,800054e4 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    800053d0:	ffffb097          	auipc	ra,0xffffb
    800053d4:	d48080e7          	jalr	-696(ra) # 80000118 <kalloc>
    800053d8:	00015497          	auipc	s1,0x15
    800053dc:	99848493          	addi	s1,s1,-1640 # 80019d70 <disk>
    800053e0:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800053e2:	ffffb097          	auipc	ra,0xffffb
    800053e6:	d36080e7          	jalr	-714(ra) # 80000118 <kalloc>
    800053ea:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800053ec:	ffffb097          	auipc	ra,0xffffb
    800053f0:	d2c080e7          	jalr	-724(ra) # 80000118 <kalloc>
    800053f4:	87aa                	mv	a5,a0
    800053f6:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800053f8:	6088                	ld	a0,0(s1)
    800053fa:	cd6d                	beqz	a0,800054f4 <virtio_disk_init+0x1dc>
    800053fc:	00015717          	auipc	a4,0x15
    80005400:	97c73703          	ld	a4,-1668(a4) # 80019d78 <disk+0x8>
    80005404:	cb65                	beqz	a4,800054f4 <virtio_disk_init+0x1dc>
    80005406:	c7fd                	beqz	a5,800054f4 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80005408:	6605                	lui	a2,0x1
    8000540a:	4581                	li	a1,0
    8000540c:	ffffb097          	auipc	ra,0xffffb
    80005410:	d92080e7          	jalr	-622(ra) # 8000019e <memset>
  memset(disk.avail, 0, PGSIZE);
    80005414:	00015497          	auipc	s1,0x15
    80005418:	95c48493          	addi	s1,s1,-1700 # 80019d70 <disk>
    8000541c:	6605                	lui	a2,0x1
    8000541e:	4581                	li	a1,0
    80005420:	6488                	ld	a0,8(s1)
    80005422:	ffffb097          	auipc	ra,0xffffb
    80005426:	d7c080e7          	jalr	-644(ra) # 8000019e <memset>
  memset(disk.used, 0, PGSIZE);
    8000542a:	6605                	lui	a2,0x1
    8000542c:	4581                	li	a1,0
    8000542e:	6888                	ld	a0,16(s1)
    80005430:	ffffb097          	auipc	ra,0xffffb
    80005434:	d6e080e7          	jalr	-658(ra) # 8000019e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005438:	100017b7          	lui	a5,0x10001
    8000543c:	4721                	li	a4,8
    8000543e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005440:	4098                	lw	a4,0(s1)
    80005442:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005446:	40d8                	lw	a4,4(s1)
    80005448:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000544c:	6498                	ld	a4,8(s1)
    8000544e:	0007069b          	sext.w	a3,a4
    80005452:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005456:	9701                	srai	a4,a4,0x20
    80005458:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000545c:	6898                	ld	a4,16(s1)
    8000545e:	0007069b          	sext.w	a3,a4
    80005462:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005466:	9701                	srai	a4,a4,0x20
    80005468:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000546c:	4705                	li	a4,1
    8000546e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005470:	00e48c23          	sb	a4,24(s1)
    80005474:	00e48ca3          	sb	a4,25(s1)
    80005478:	00e48d23          	sb	a4,26(s1)
    8000547c:	00e48da3          	sb	a4,27(s1)
    80005480:	00e48e23          	sb	a4,28(s1)
    80005484:	00e48ea3          	sb	a4,29(s1)
    80005488:	00e48f23          	sb	a4,30(s1)
    8000548c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005490:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005494:	0727a823          	sw	s2,112(a5)
}
    80005498:	60e2                	ld	ra,24(sp)
    8000549a:	6442                	ld	s0,16(sp)
    8000549c:	64a2                	ld	s1,8(sp)
    8000549e:	6902                	ld	s2,0(sp)
    800054a0:	6105                	addi	sp,sp,32
    800054a2:	8082                	ret
    panic("could not find virtio disk");
    800054a4:	00003517          	auipc	a0,0x3
    800054a8:	35c50513          	addi	a0,a0,860 # 80008800 <syscalls+0x328>
    800054ac:	00001097          	auipc	ra,0x1
    800054b0:	862080e7          	jalr	-1950(ra) # 80005d0e <panic>
    panic("virtio disk FEATURES_OK unset");
    800054b4:	00003517          	auipc	a0,0x3
    800054b8:	36c50513          	addi	a0,a0,876 # 80008820 <syscalls+0x348>
    800054bc:	00001097          	auipc	ra,0x1
    800054c0:	852080e7          	jalr	-1966(ra) # 80005d0e <panic>
    panic("virtio disk should not be ready");
    800054c4:	00003517          	auipc	a0,0x3
    800054c8:	37c50513          	addi	a0,a0,892 # 80008840 <syscalls+0x368>
    800054cc:	00001097          	auipc	ra,0x1
    800054d0:	842080e7          	jalr	-1982(ra) # 80005d0e <panic>
    panic("virtio disk has no queue 0");
    800054d4:	00003517          	auipc	a0,0x3
    800054d8:	38c50513          	addi	a0,a0,908 # 80008860 <syscalls+0x388>
    800054dc:	00001097          	auipc	ra,0x1
    800054e0:	832080e7          	jalr	-1998(ra) # 80005d0e <panic>
    panic("virtio disk max queue too short");
    800054e4:	00003517          	auipc	a0,0x3
    800054e8:	39c50513          	addi	a0,a0,924 # 80008880 <syscalls+0x3a8>
    800054ec:	00001097          	auipc	ra,0x1
    800054f0:	822080e7          	jalr	-2014(ra) # 80005d0e <panic>
    panic("virtio disk kalloc");
    800054f4:	00003517          	auipc	a0,0x3
    800054f8:	3ac50513          	addi	a0,a0,940 # 800088a0 <syscalls+0x3c8>
    800054fc:	00001097          	auipc	ra,0x1
    80005500:	812080e7          	jalr	-2030(ra) # 80005d0e <panic>

0000000080005504 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005504:	7119                	addi	sp,sp,-128
    80005506:	fc86                	sd	ra,120(sp)
    80005508:	f8a2                	sd	s0,112(sp)
    8000550a:	f4a6                	sd	s1,104(sp)
    8000550c:	f0ca                	sd	s2,96(sp)
    8000550e:	ecce                	sd	s3,88(sp)
    80005510:	e8d2                	sd	s4,80(sp)
    80005512:	e4d6                	sd	s5,72(sp)
    80005514:	e0da                	sd	s6,64(sp)
    80005516:	fc5e                	sd	s7,56(sp)
    80005518:	f862                	sd	s8,48(sp)
    8000551a:	f466                	sd	s9,40(sp)
    8000551c:	f06a                	sd	s10,32(sp)
    8000551e:	ec6e                	sd	s11,24(sp)
    80005520:	0100                	addi	s0,sp,128
    80005522:	8aaa                	mv	s5,a0
    80005524:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005526:	00c52d03          	lw	s10,12(a0)
    8000552a:	001d1d1b          	slliw	s10,s10,0x1
    8000552e:	1d02                	slli	s10,s10,0x20
    80005530:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005534:	00015517          	auipc	a0,0x15
    80005538:	96450513          	addi	a0,a0,-1692 # 80019e98 <disk+0x128>
    8000553c:	00001097          	auipc	ra,0x1
    80005540:	d0e080e7          	jalr	-754(ra) # 8000624a <acquire>
  for(int i = 0; i < 3; i++){
    80005544:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005546:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005548:	00015b97          	auipc	s7,0x15
    8000554c:	828b8b93          	addi	s7,s7,-2008 # 80019d70 <disk>
  for(int i = 0; i < 3; i++){
    80005550:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005552:	00015c97          	auipc	s9,0x15
    80005556:	946c8c93          	addi	s9,s9,-1722 # 80019e98 <disk+0x128>
    8000555a:	a08d                	j	800055bc <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000555c:	00fb8733          	add	a4,s7,a5
    80005560:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005564:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005566:	0207c563          	bltz	a5,80005590 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000556a:	2905                	addiw	s2,s2,1
    8000556c:	0611                	addi	a2,a2,4
    8000556e:	05690c63          	beq	s2,s6,800055c6 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005572:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005574:	00014717          	auipc	a4,0x14
    80005578:	7fc70713          	addi	a4,a4,2044 # 80019d70 <disk>
    8000557c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000557e:	01874683          	lbu	a3,24(a4)
    80005582:	fee9                	bnez	a3,8000555c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005584:	2785                	addiw	a5,a5,1
    80005586:	0705                	addi	a4,a4,1
    80005588:	fe979be3          	bne	a5,s1,8000557e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000558c:	57fd                	li	a5,-1
    8000558e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005590:	01205d63          	blez	s2,800055aa <virtio_disk_rw+0xa6>
    80005594:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005596:	000a2503          	lw	a0,0(s4)
    8000559a:	00000097          	auipc	ra,0x0
    8000559e:	cfc080e7          	jalr	-772(ra) # 80005296 <free_desc>
      for(int j = 0; j < i; j++)
    800055a2:	2d85                	addiw	s11,s11,1
    800055a4:	0a11                	addi	s4,s4,4
    800055a6:	ffb918e3          	bne	s2,s11,80005596 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055aa:	85e6                	mv	a1,s9
    800055ac:	00014517          	auipc	a0,0x14
    800055b0:	7dc50513          	addi	a0,a0,2012 # 80019d88 <disk+0x18>
    800055b4:	ffffc097          	auipc	ra,0xffffc
    800055b8:	fd0080e7          	jalr	-48(ra) # 80001584 <sleep>
  for(int i = 0; i < 3; i++){
    800055bc:	f8040a13          	addi	s4,s0,-128
{
    800055c0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800055c2:	894e                	mv	s2,s3
    800055c4:	b77d                	j	80005572 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055c6:	f8042583          	lw	a1,-128(s0)
    800055ca:	00a58793          	addi	a5,a1,10
    800055ce:	0792                	slli	a5,a5,0x4

  if(write)
    800055d0:	00014617          	auipc	a2,0x14
    800055d4:	7a060613          	addi	a2,a2,1952 # 80019d70 <disk>
    800055d8:	00f60733          	add	a4,a2,a5
    800055dc:	018036b3          	snez	a3,s8
    800055e0:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055e2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800055e6:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055ea:	f6078693          	addi	a3,a5,-160
    800055ee:	6218                	ld	a4,0(a2)
    800055f0:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055f2:	00878513          	addi	a0,a5,8
    800055f6:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055f8:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055fa:	6208                	ld	a0,0(a2)
    800055fc:	96aa                	add	a3,a3,a0
    800055fe:	4741                	li	a4,16
    80005600:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005602:	4705                	li	a4,1
    80005604:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005608:	f8442703          	lw	a4,-124(s0)
    8000560c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005610:	0712                	slli	a4,a4,0x4
    80005612:	953a                	add	a0,a0,a4
    80005614:	058a8693          	addi	a3,s5,88
    80005618:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000561a:	6208                	ld	a0,0(a2)
    8000561c:	972a                	add	a4,a4,a0
    8000561e:	40000693          	li	a3,1024
    80005622:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005624:	001c3c13          	seqz	s8,s8
    80005628:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000562a:	001c6c13          	ori	s8,s8,1
    8000562e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005632:	f8842603          	lw	a2,-120(s0)
    80005636:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000563a:	00014697          	auipc	a3,0x14
    8000563e:	73668693          	addi	a3,a3,1846 # 80019d70 <disk>
    80005642:	00258713          	addi	a4,a1,2
    80005646:	0712                	slli	a4,a4,0x4
    80005648:	9736                	add	a4,a4,a3
    8000564a:	587d                	li	a6,-1
    8000564c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005650:	0612                	slli	a2,a2,0x4
    80005652:	9532                	add	a0,a0,a2
    80005654:	f9078793          	addi	a5,a5,-112
    80005658:	97b6                	add	a5,a5,a3
    8000565a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    8000565c:	629c                	ld	a5,0(a3)
    8000565e:	97b2                	add	a5,a5,a2
    80005660:	4605                	li	a2,1
    80005662:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005664:	4509                	li	a0,2
    80005666:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    8000566a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000566e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005672:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005676:	6698                	ld	a4,8(a3)
    80005678:	00275783          	lhu	a5,2(a4)
    8000567c:	8b9d                	andi	a5,a5,7
    8000567e:	0786                	slli	a5,a5,0x1
    80005680:	97ba                	add	a5,a5,a4
    80005682:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005686:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000568a:	6698                	ld	a4,8(a3)
    8000568c:	00275783          	lhu	a5,2(a4)
    80005690:	2785                	addiw	a5,a5,1
    80005692:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005696:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000569a:	100017b7          	lui	a5,0x10001
    8000569e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056a2:	004aa783          	lw	a5,4(s5)
    800056a6:	02c79163          	bne	a5,a2,800056c8 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800056aa:	00014917          	auipc	s2,0x14
    800056ae:	7ee90913          	addi	s2,s2,2030 # 80019e98 <disk+0x128>
  while(b->disk == 1) {
    800056b2:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056b4:	85ca                	mv	a1,s2
    800056b6:	8556                	mv	a0,s5
    800056b8:	ffffc097          	auipc	ra,0xffffc
    800056bc:	ecc080e7          	jalr	-308(ra) # 80001584 <sleep>
  while(b->disk == 1) {
    800056c0:	004aa783          	lw	a5,4(s5)
    800056c4:	fe9788e3          	beq	a5,s1,800056b4 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800056c8:	f8042903          	lw	s2,-128(s0)
    800056cc:	00290793          	addi	a5,s2,2
    800056d0:	00479713          	slli	a4,a5,0x4
    800056d4:	00014797          	auipc	a5,0x14
    800056d8:	69c78793          	addi	a5,a5,1692 # 80019d70 <disk>
    800056dc:	97ba                	add	a5,a5,a4
    800056de:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800056e2:	00014997          	auipc	s3,0x14
    800056e6:	68e98993          	addi	s3,s3,1678 # 80019d70 <disk>
    800056ea:	00491713          	slli	a4,s2,0x4
    800056ee:	0009b783          	ld	a5,0(s3)
    800056f2:	97ba                	add	a5,a5,a4
    800056f4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056f8:	854a                	mv	a0,s2
    800056fa:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056fe:	00000097          	auipc	ra,0x0
    80005702:	b98080e7          	jalr	-1128(ra) # 80005296 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005706:	8885                	andi	s1,s1,1
    80005708:	f0ed                	bnez	s1,800056ea <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000570a:	00014517          	auipc	a0,0x14
    8000570e:	78e50513          	addi	a0,a0,1934 # 80019e98 <disk+0x128>
    80005712:	00001097          	auipc	ra,0x1
    80005716:	bec080e7          	jalr	-1044(ra) # 800062fe <release>
}
    8000571a:	70e6                	ld	ra,120(sp)
    8000571c:	7446                	ld	s0,112(sp)
    8000571e:	74a6                	ld	s1,104(sp)
    80005720:	7906                	ld	s2,96(sp)
    80005722:	69e6                	ld	s3,88(sp)
    80005724:	6a46                	ld	s4,80(sp)
    80005726:	6aa6                	ld	s5,72(sp)
    80005728:	6b06                	ld	s6,64(sp)
    8000572a:	7be2                	ld	s7,56(sp)
    8000572c:	7c42                	ld	s8,48(sp)
    8000572e:	7ca2                	ld	s9,40(sp)
    80005730:	7d02                	ld	s10,32(sp)
    80005732:	6de2                	ld	s11,24(sp)
    80005734:	6109                	addi	sp,sp,128
    80005736:	8082                	ret

0000000080005738 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005738:	1101                	addi	sp,sp,-32
    8000573a:	ec06                	sd	ra,24(sp)
    8000573c:	e822                	sd	s0,16(sp)
    8000573e:	e426                	sd	s1,8(sp)
    80005740:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005742:	00014497          	auipc	s1,0x14
    80005746:	62e48493          	addi	s1,s1,1582 # 80019d70 <disk>
    8000574a:	00014517          	auipc	a0,0x14
    8000574e:	74e50513          	addi	a0,a0,1870 # 80019e98 <disk+0x128>
    80005752:	00001097          	auipc	ra,0x1
    80005756:	af8080e7          	jalr	-1288(ra) # 8000624a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000575a:	10001737          	lui	a4,0x10001
    8000575e:	533c                	lw	a5,96(a4)
    80005760:	8b8d                	andi	a5,a5,3
    80005762:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005764:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005768:	689c                	ld	a5,16(s1)
    8000576a:	0204d703          	lhu	a4,32(s1)
    8000576e:	0027d783          	lhu	a5,2(a5)
    80005772:	04f70863          	beq	a4,a5,800057c2 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005776:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000577a:	6898                	ld	a4,16(s1)
    8000577c:	0204d783          	lhu	a5,32(s1)
    80005780:	8b9d                	andi	a5,a5,7
    80005782:	078e                	slli	a5,a5,0x3
    80005784:	97ba                	add	a5,a5,a4
    80005786:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005788:	00278713          	addi	a4,a5,2
    8000578c:	0712                	slli	a4,a4,0x4
    8000578e:	9726                	add	a4,a4,s1
    80005790:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005794:	e721                	bnez	a4,800057dc <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005796:	0789                	addi	a5,a5,2
    80005798:	0792                	slli	a5,a5,0x4
    8000579a:	97a6                	add	a5,a5,s1
    8000579c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000579e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057a2:	ffffc097          	auipc	ra,0xffffc
    800057a6:	e46080e7          	jalr	-442(ra) # 800015e8 <wakeup>

    disk.used_idx += 1;
    800057aa:	0204d783          	lhu	a5,32(s1)
    800057ae:	2785                	addiw	a5,a5,1
    800057b0:	17c2                	slli	a5,a5,0x30
    800057b2:	93c1                	srli	a5,a5,0x30
    800057b4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057b8:	6898                	ld	a4,16(s1)
    800057ba:	00275703          	lhu	a4,2(a4)
    800057be:	faf71ce3          	bne	a4,a5,80005776 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800057c2:	00014517          	auipc	a0,0x14
    800057c6:	6d650513          	addi	a0,a0,1750 # 80019e98 <disk+0x128>
    800057ca:	00001097          	auipc	ra,0x1
    800057ce:	b34080e7          	jalr	-1228(ra) # 800062fe <release>
}
    800057d2:	60e2                	ld	ra,24(sp)
    800057d4:	6442                	ld	s0,16(sp)
    800057d6:	64a2                	ld	s1,8(sp)
    800057d8:	6105                	addi	sp,sp,32
    800057da:	8082                	ret
      panic("virtio_disk_intr status");
    800057dc:	00003517          	auipc	a0,0x3
    800057e0:	0dc50513          	addi	a0,a0,220 # 800088b8 <syscalls+0x3e0>
    800057e4:	00000097          	auipc	ra,0x0
    800057e8:	52a080e7          	jalr	1322(ra) # 80005d0e <panic>

00000000800057ec <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800057ec:	1141                	addi	sp,sp,-16
    800057ee:	e422                	sd	s0,8(sp)
    800057f0:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057f2:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800057f6:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800057fa:	0037979b          	slliw	a5,a5,0x3
    800057fe:	02004737          	lui	a4,0x2004
    80005802:	97ba                	add	a5,a5,a4
    80005804:	0200c737          	lui	a4,0x200c
    80005808:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000580c:	000f4637          	lui	a2,0xf4
    80005810:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005814:	95b2                	add	a1,a1,a2
    80005816:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005818:	00269713          	slli	a4,a3,0x2
    8000581c:	9736                	add	a4,a4,a3
    8000581e:	00371693          	slli	a3,a4,0x3
    80005822:	00014717          	auipc	a4,0x14
    80005826:	68e70713          	addi	a4,a4,1678 # 80019eb0 <timer_scratch>
    8000582a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000582c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000582e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005830:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005834:	00000797          	auipc	a5,0x0
    80005838:	99c78793          	addi	a5,a5,-1636 # 800051d0 <timervec>
    8000583c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005840:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005844:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005848:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000584c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005850:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005854:	30479073          	csrw	mie,a5
}
    80005858:	6422                	ld	s0,8(sp)
    8000585a:	0141                	addi	sp,sp,16
    8000585c:	8082                	ret

000000008000585e <start>:
{
    8000585e:	1141                	addi	sp,sp,-16
    80005860:	e406                	sd	ra,8(sp)
    80005862:	e022                	sd	s0,0(sp)
    80005864:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005866:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000586a:	7779                	lui	a4,0xffffe
    8000586c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc70f>
    80005870:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005872:	6705                	lui	a4,0x1
    80005874:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005878:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000587a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000587e:	ffffb797          	auipc	a5,0xffffb
    80005882:	ac678793          	addi	a5,a5,-1338 # 80000344 <main>
    80005886:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000588a:	4781                	li	a5,0
    8000588c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005890:	67c1                	lui	a5,0x10
    80005892:	17fd                	addi	a5,a5,-1
    80005894:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005898:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000589c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058a0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058a4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058a8:	57fd                	li	a5,-1
    800058aa:	83a9                	srli	a5,a5,0xa
    800058ac:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058b0:	47bd                	li	a5,15
    800058b2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058b6:	00000097          	auipc	ra,0x0
    800058ba:	f36080e7          	jalr	-202(ra) # 800057ec <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058be:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058c2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058c4:	823e                	mv	tp,a5
  asm volatile("mret");
    800058c6:	30200073          	mret
}
    800058ca:	60a2                	ld	ra,8(sp)
    800058cc:	6402                	ld	s0,0(sp)
    800058ce:	0141                	addi	sp,sp,16
    800058d0:	8082                	ret

00000000800058d2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058d2:	715d                	addi	sp,sp,-80
    800058d4:	e486                	sd	ra,72(sp)
    800058d6:	e0a2                	sd	s0,64(sp)
    800058d8:	fc26                	sd	s1,56(sp)
    800058da:	f84a                	sd	s2,48(sp)
    800058dc:	f44e                	sd	s3,40(sp)
    800058de:	f052                	sd	s4,32(sp)
    800058e0:	ec56                	sd	s5,24(sp)
    800058e2:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800058e4:	04c05663          	blez	a2,80005930 <consolewrite+0x5e>
    800058e8:	8a2a                	mv	s4,a0
    800058ea:	84ae                	mv	s1,a1
    800058ec:	89b2                	mv	s3,a2
    800058ee:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800058f0:	5afd                	li	s5,-1
    800058f2:	4685                	li	a3,1
    800058f4:	8626                	mv	a2,s1
    800058f6:	85d2                	mv	a1,s4
    800058f8:	fbf40513          	addi	a0,s0,-65
    800058fc:	ffffc097          	auipc	ra,0xffffc
    80005900:	0e6080e7          	jalr	230(ra) # 800019e2 <either_copyin>
    80005904:	01550c63          	beq	a0,s5,8000591c <consolewrite+0x4a>
      break;
    uartputc(c);
    80005908:	fbf44503          	lbu	a0,-65(s0)
    8000590c:	00000097          	auipc	ra,0x0
    80005910:	780080e7          	jalr	1920(ra) # 8000608c <uartputc>
  for(i = 0; i < n; i++){
    80005914:	2905                	addiw	s2,s2,1
    80005916:	0485                	addi	s1,s1,1
    80005918:	fd299de3          	bne	s3,s2,800058f2 <consolewrite+0x20>
  }

  return i;
}
    8000591c:	854a                	mv	a0,s2
    8000591e:	60a6                	ld	ra,72(sp)
    80005920:	6406                	ld	s0,64(sp)
    80005922:	74e2                	ld	s1,56(sp)
    80005924:	7942                	ld	s2,48(sp)
    80005926:	79a2                	ld	s3,40(sp)
    80005928:	7a02                	ld	s4,32(sp)
    8000592a:	6ae2                	ld	s5,24(sp)
    8000592c:	6161                	addi	sp,sp,80
    8000592e:	8082                	ret
  for(i = 0; i < n; i++){
    80005930:	4901                	li	s2,0
    80005932:	b7ed                	j	8000591c <consolewrite+0x4a>

0000000080005934 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005934:	7159                	addi	sp,sp,-112
    80005936:	f486                	sd	ra,104(sp)
    80005938:	f0a2                	sd	s0,96(sp)
    8000593a:	eca6                	sd	s1,88(sp)
    8000593c:	e8ca                	sd	s2,80(sp)
    8000593e:	e4ce                	sd	s3,72(sp)
    80005940:	e0d2                	sd	s4,64(sp)
    80005942:	fc56                	sd	s5,56(sp)
    80005944:	f85a                	sd	s6,48(sp)
    80005946:	f45e                	sd	s7,40(sp)
    80005948:	f062                	sd	s8,32(sp)
    8000594a:	ec66                	sd	s9,24(sp)
    8000594c:	e86a                	sd	s10,16(sp)
    8000594e:	1880                	addi	s0,sp,112
    80005950:	8aaa                	mv	s5,a0
    80005952:	8a2e                	mv	s4,a1
    80005954:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005956:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000595a:	0001c517          	auipc	a0,0x1c
    8000595e:	69650513          	addi	a0,a0,1686 # 80021ff0 <cons>
    80005962:	00001097          	auipc	ra,0x1
    80005966:	8e8080e7          	jalr	-1816(ra) # 8000624a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000596a:	0001c497          	auipc	s1,0x1c
    8000596e:	68648493          	addi	s1,s1,1670 # 80021ff0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005972:	0001c917          	auipc	s2,0x1c
    80005976:	71690913          	addi	s2,s2,1814 # 80022088 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000597a:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000597c:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000597e:	4ca9                	li	s9,10
  while(n > 0){
    80005980:	07305b63          	blez	s3,800059f6 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005984:	0984a783          	lw	a5,152(s1)
    80005988:	09c4a703          	lw	a4,156(s1)
    8000598c:	02f71763          	bne	a4,a5,800059ba <consoleread+0x86>
      if(killed(myproc())){
    80005990:	ffffb097          	auipc	ra,0xffffb
    80005994:	540080e7          	jalr	1344(ra) # 80000ed0 <myproc>
    80005998:	ffffc097          	auipc	ra,0xffffc
    8000599c:	e94080e7          	jalr	-364(ra) # 8000182c <killed>
    800059a0:	e535                	bnez	a0,80005a0c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800059a2:	85a6                	mv	a1,s1
    800059a4:	854a                	mv	a0,s2
    800059a6:	ffffc097          	auipc	ra,0xffffc
    800059aa:	bde080e7          	jalr	-1058(ra) # 80001584 <sleep>
    while(cons.r == cons.w){
    800059ae:	0984a783          	lw	a5,152(s1)
    800059b2:	09c4a703          	lw	a4,156(s1)
    800059b6:	fcf70de3          	beq	a4,a5,80005990 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800059ba:	0017871b          	addiw	a4,a5,1
    800059be:	08e4ac23          	sw	a4,152(s1)
    800059c2:	07f7f713          	andi	a4,a5,127
    800059c6:	9726                	add	a4,a4,s1
    800059c8:	01874703          	lbu	a4,24(a4)
    800059cc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800059d0:	077d0563          	beq	s10,s7,80005a3a <consoleread+0x106>
    cbuf = c;
    800059d4:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059d8:	4685                	li	a3,1
    800059da:	f9f40613          	addi	a2,s0,-97
    800059de:	85d2                	mv	a1,s4
    800059e0:	8556                	mv	a0,s5
    800059e2:	ffffc097          	auipc	ra,0xffffc
    800059e6:	faa080e7          	jalr	-86(ra) # 8000198c <either_copyout>
    800059ea:	01850663          	beq	a0,s8,800059f6 <consoleread+0xc2>
    dst++;
    800059ee:	0a05                	addi	s4,s4,1
    --n;
    800059f0:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800059f2:	f99d17e3          	bne	s10,s9,80005980 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800059f6:	0001c517          	auipc	a0,0x1c
    800059fa:	5fa50513          	addi	a0,a0,1530 # 80021ff0 <cons>
    800059fe:	00001097          	auipc	ra,0x1
    80005a02:	900080e7          	jalr	-1792(ra) # 800062fe <release>

  return target - n;
    80005a06:	413b053b          	subw	a0,s6,s3
    80005a0a:	a811                	j	80005a1e <consoleread+0xea>
        release(&cons.lock);
    80005a0c:	0001c517          	auipc	a0,0x1c
    80005a10:	5e450513          	addi	a0,a0,1508 # 80021ff0 <cons>
    80005a14:	00001097          	auipc	ra,0x1
    80005a18:	8ea080e7          	jalr	-1814(ra) # 800062fe <release>
        return -1;
    80005a1c:	557d                	li	a0,-1
}
    80005a1e:	70a6                	ld	ra,104(sp)
    80005a20:	7406                	ld	s0,96(sp)
    80005a22:	64e6                	ld	s1,88(sp)
    80005a24:	6946                	ld	s2,80(sp)
    80005a26:	69a6                	ld	s3,72(sp)
    80005a28:	6a06                	ld	s4,64(sp)
    80005a2a:	7ae2                	ld	s5,56(sp)
    80005a2c:	7b42                	ld	s6,48(sp)
    80005a2e:	7ba2                	ld	s7,40(sp)
    80005a30:	7c02                	ld	s8,32(sp)
    80005a32:	6ce2                	ld	s9,24(sp)
    80005a34:	6d42                	ld	s10,16(sp)
    80005a36:	6165                	addi	sp,sp,112
    80005a38:	8082                	ret
      if(n < target){
    80005a3a:	0009871b          	sext.w	a4,s3
    80005a3e:	fb677ce3          	bgeu	a4,s6,800059f6 <consoleread+0xc2>
        cons.r--;
    80005a42:	0001c717          	auipc	a4,0x1c
    80005a46:	64f72323          	sw	a5,1606(a4) # 80022088 <cons+0x98>
    80005a4a:	b775                	j	800059f6 <consoleread+0xc2>

0000000080005a4c <consputc>:
{
    80005a4c:	1141                	addi	sp,sp,-16
    80005a4e:	e406                	sd	ra,8(sp)
    80005a50:	e022                	sd	s0,0(sp)
    80005a52:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a54:	10000793          	li	a5,256
    80005a58:	00f50a63          	beq	a0,a5,80005a6c <consputc+0x20>
    uartputc_sync(c);
    80005a5c:	00000097          	auipc	ra,0x0
    80005a60:	55e080e7          	jalr	1374(ra) # 80005fba <uartputc_sync>
}
    80005a64:	60a2                	ld	ra,8(sp)
    80005a66:	6402                	ld	s0,0(sp)
    80005a68:	0141                	addi	sp,sp,16
    80005a6a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a6c:	4521                	li	a0,8
    80005a6e:	00000097          	auipc	ra,0x0
    80005a72:	54c080e7          	jalr	1356(ra) # 80005fba <uartputc_sync>
    80005a76:	02000513          	li	a0,32
    80005a7a:	00000097          	auipc	ra,0x0
    80005a7e:	540080e7          	jalr	1344(ra) # 80005fba <uartputc_sync>
    80005a82:	4521                	li	a0,8
    80005a84:	00000097          	auipc	ra,0x0
    80005a88:	536080e7          	jalr	1334(ra) # 80005fba <uartputc_sync>
    80005a8c:	bfe1                	j	80005a64 <consputc+0x18>

0000000080005a8e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a8e:	1101                	addi	sp,sp,-32
    80005a90:	ec06                	sd	ra,24(sp)
    80005a92:	e822                	sd	s0,16(sp)
    80005a94:	e426                	sd	s1,8(sp)
    80005a96:	e04a                	sd	s2,0(sp)
    80005a98:	1000                	addi	s0,sp,32
    80005a9a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a9c:	0001c517          	auipc	a0,0x1c
    80005aa0:	55450513          	addi	a0,a0,1364 # 80021ff0 <cons>
    80005aa4:	00000097          	auipc	ra,0x0
    80005aa8:	7a6080e7          	jalr	1958(ra) # 8000624a <acquire>

  switch(c){
    80005aac:	47d5                	li	a5,21
    80005aae:	0af48663          	beq	s1,a5,80005b5a <consoleintr+0xcc>
    80005ab2:	0297ca63          	blt	a5,s1,80005ae6 <consoleintr+0x58>
    80005ab6:	47a1                	li	a5,8
    80005ab8:	0ef48763          	beq	s1,a5,80005ba6 <consoleintr+0x118>
    80005abc:	47c1                	li	a5,16
    80005abe:	10f49a63          	bne	s1,a5,80005bd2 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005ac2:	ffffc097          	auipc	ra,0xffffc
    80005ac6:	f76080e7          	jalr	-138(ra) # 80001a38 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005aca:	0001c517          	auipc	a0,0x1c
    80005ace:	52650513          	addi	a0,a0,1318 # 80021ff0 <cons>
    80005ad2:	00001097          	auipc	ra,0x1
    80005ad6:	82c080e7          	jalr	-2004(ra) # 800062fe <release>
}
    80005ada:	60e2                	ld	ra,24(sp)
    80005adc:	6442                	ld	s0,16(sp)
    80005ade:	64a2                	ld	s1,8(sp)
    80005ae0:	6902                	ld	s2,0(sp)
    80005ae2:	6105                	addi	sp,sp,32
    80005ae4:	8082                	ret
  switch(c){
    80005ae6:	07f00793          	li	a5,127
    80005aea:	0af48e63          	beq	s1,a5,80005ba6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005aee:	0001c717          	auipc	a4,0x1c
    80005af2:	50270713          	addi	a4,a4,1282 # 80021ff0 <cons>
    80005af6:	0a072783          	lw	a5,160(a4)
    80005afa:	09872703          	lw	a4,152(a4)
    80005afe:	9f99                	subw	a5,a5,a4
    80005b00:	07f00713          	li	a4,127
    80005b04:	fcf763e3          	bltu	a4,a5,80005aca <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b08:	47b5                	li	a5,13
    80005b0a:	0cf48763          	beq	s1,a5,80005bd8 <consoleintr+0x14a>
      consputc(c);
    80005b0e:	8526                	mv	a0,s1
    80005b10:	00000097          	auipc	ra,0x0
    80005b14:	f3c080e7          	jalr	-196(ra) # 80005a4c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b18:	0001c797          	auipc	a5,0x1c
    80005b1c:	4d878793          	addi	a5,a5,1240 # 80021ff0 <cons>
    80005b20:	0a07a683          	lw	a3,160(a5)
    80005b24:	0016871b          	addiw	a4,a3,1
    80005b28:	0007061b          	sext.w	a2,a4
    80005b2c:	0ae7a023          	sw	a4,160(a5)
    80005b30:	07f6f693          	andi	a3,a3,127
    80005b34:	97b6                	add	a5,a5,a3
    80005b36:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005b3a:	47a9                	li	a5,10
    80005b3c:	0cf48563          	beq	s1,a5,80005c06 <consoleintr+0x178>
    80005b40:	4791                	li	a5,4
    80005b42:	0cf48263          	beq	s1,a5,80005c06 <consoleintr+0x178>
    80005b46:	0001c797          	auipc	a5,0x1c
    80005b4a:	5427a783          	lw	a5,1346(a5) # 80022088 <cons+0x98>
    80005b4e:	9f1d                	subw	a4,a4,a5
    80005b50:	08000793          	li	a5,128
    80005b54:	f6f71be3          	bne	a4,a5,80005aca <consoleintr+0x3c>
    80005b58:	a07d                	j	80005c06 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b5a:	0001c717          	auipc	a4,0x1c
    80005b5e:	49670713          	addi	a4,a4,1174 # 80021ff0 <cons>
    80005b62:	0a072783          	lw	a5,160(a4)
    80005b66:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b6a:	0001c497          	auipc	s1,0x1c
    80005b6e:	48648493          	addi	s1,s1,1158 # 80021ff0 <cons>
    while(cons.e != cons.w &&
    80005b72:	4929                	li	s2,10
    80005b74:	f4f70be3          	beq	a4,a5,80005aca <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b78:	37fd                	addiw	a5,a5,-1
    80005b7a:	07f7f713          	andi	a4,a5,127
    80005b7e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b80:	01874703          	lbu	a4,24(a4)
    80005b84:	f52703e3          	beq	a4,s2,80005aca <consoleintr+0x3c>
      cons.e--;
    80005b88:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b8c:	10000513          	li	a0,256
    80005b90:	00000097          	auipc	ra,0x0
    80005b94:	ebc080e7          	jalr	-324(ra) # 80005a4c <consputc>
    while(cons.e != cons.w &&
    80005b98:	0a04a783          	lw	a5,160(s1)
    80005b9c:	09c4a703          	lw	a4,156(s1)
    80005ba0:	fcf71ce3          	bne	a4,a5,80005b78 <consoleintr+0xea>
    80005ba4:	b71d                	j	80005aca <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ba6:	0001c717          	auipc	a4,0x1c
    80005baa:	44a70713          	addi	a4,a4,1098 # 80021ff0 <cons>
    80005bae:	0a072783          	lw	a5,160(a4)
    80005bb2:	09c72703          	lw	a4,156(a4)
    80005bb6:	f0f70ae3          	beq	a4,a5,80005aca <consoleintr+0x3c>
      cons.e--;
    80005bba:	37fd                	addiw	a5,a5,-1
    80005bbc:	0001c717          	auipc	a4,0x1c
    80005bc0:	4cf72a23          	sw	a5,1236(a4) # 80022090 <cons+0xa0>
      consputc(BACKSPACE);
    80005bc4:	10000513          	li	a0,256
    80005bc8:	00000097          	auipc	ra,0x0
    80005bcc:	e84080e7          	jalr	-380(ra) # 80005a4c <consputc>
    80005bd0:	bded                	j	80005aca <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005bd2:	ee048ce3          	beqz	s1,80005aca <consoleintr+0x3c>
    80005bd6:	bf21                	j	80005aee <consoleintr+0x60>
      consputc(c);
    80005bd8:	4529                	li	a0,10
    80005bda:	00000097          	auipc	ra,0x0
    80005bde:	e72080e7          	jalr	-398(ra) # 80005a4c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005be2:	0001c797          	auipc	a5,0x1c
    80005be6:	40e78793          	addi	a5,a5,1038 # 80021ff0 <cons>
    80005bea:	0a07a703          	lw	a4,160(a5)
    80005bee:	0017069b          	addiw	a3,a4,1
    80005bf2:	0006861b          	sext.w	a2,a3
    80005bf6:	0ad7a023          	sw	a3,160(a5)
    80005bfa:	07f77713          	andi	a4,a4,127
    80005bfe:	97ba                	add	a5,a5,a4
    80005c00:	4729                	li	a4,10
    80005c02:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c06:	0001c797          	auipc	a5,0x1c
    80005c0a:	48c7a323          	sw	a2,1158(a5) # 8002208c <cons+0x9c>
        wakeup(&cons.r);
    80005c0e:	0001c517          	auipc	a0,0x1c
    80005c12:	47a50513          	addi	a0,a0,1146 # 80022088 <cons+0x98>
    80005c16:	ffffc097          	auipc	ra,0xffffc
    80005c1a:	9d2080e7          	jalr	-1582(ra) # 800015e8 <wakeup>
    80005c1e:	b575                	j	80005aca <consoleintr+0x3c>

0000000080005c20 <consoleinit>:

void
consoleinit(void)
{
    80005c20:	1141                	addi	sp,sp,-16
    80005c22:	e406                	sd	ra,8(sp)
    80005c24:	e022                	sd	s0,0(sp)
    80005c26:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c28:	00003597          	auipc	a1,0x3
    80005c2c:	ca858593          	addi	a1,a1,-856 # 800088d0 <syscalls+0x3f8>
    80005c30:	0001c517          	auipc	a0,0x1c
    80005c34:	3c050513          	addi	a0,a0,960 # 80021ff0 <cons>
    80005c38:	00000097          	auipc	ra,0x0
    80005c3c:	582080e7          	jalr	1410(ra) # 800061ba <initlock>

  uartinit();
    80005c40:	00000097          	auipc	ra,0x0
    80005c44:	32a080e7          	jalr	810(ra) # 80005f6a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c48:	00013797          	auipc	a5,0x13
    80005c4c:	0d078793          	addi	a5,a5,208 # 80018d18 <devsw>
    80005c50:	00000717          	auipc	a4,0x0
    80005c54:	ce470713          	addi	a4,a4,-796 # 80005934 <consoleread>
    80005c58:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c5a:	00000717          	auipc	a4,0x0
    80005c5e:	c7870713          	addi	a4,a4,-904 # 800058d2 <consolewrite>
    80005c62:	ef98                	sd	a4,24(a5)
}
    80005c64:	60a2                	ld	ra,8(sp)
    80005c66:	6402                	ld	s0,0(sp)
    80005c68:	0141                	addi	sp,sp,16
    80005c6a:	8082                	ret

0000000080005c6c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c6c:	7179                	addi	sp,sp,-48
    80005c6e:	f406                	sd	ra,40(sp)
    80005c70:	f022                	sd	s0,32(sp)
    80005c72:	ec26                	sd	s1,24(sp)
    80005c74:	e84a                	sd	s2,16(sp)
    80005c76:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c78:	c219                	beqz	a2,80005c7e <printint+0x12>
    80005c7a:	08054663          	bltz	a0,80005d06 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c7e:	2501                	sext.w	a0,a0
    80005c80:	4881                	li	a7,0
    80005c82:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c86:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c88:	2581                	sext.w	a1,a1
    80005c8a:	00003617          	auipc	a2,0x3
    80005c8e:	c7660613          	addi	a2,a2,-906 # 80008900 <digits>
    80005c92:	883a                	mv	a6,a4
    80005c94:	2705                	addiw	a4,a4,1
    80005c96:	02b577bb          	remuw	a5,a0,a1
    80005c9a:	1782                	slli	a5,a5,0x20
    80005c9c:	9381                	srli	a5,a5,0x20
    80005c9e:	97b2                	add	a5,a5,a2
    80005ca0:	0007c783          	lbu	a5,0(a5)
    80005ca4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ca8:	0005079b          	sext.w	a5,a0
    80005cac:	02b5553b          	divuw	a0,a0,a1
    80005cb0:	0685                	addi	a3,a3,1
    80005cb2:	feb7f0e3          	bgeu	a5,a1,80005c92 <printint+0x26>

  if(sign)
    80005cb6:	00088b63          	beqz	a7,80005ccc <printint+0x60>
    buf[i++] = '-';
    80005cba:	fe040793          	addi	a5,s0,-32
    80005cbe:	973e                	add	a4,a4,a5
    80005cc0:	02d00793          	li	a5,45
    80005cc4:	fef70823          	sb	a5,-16(a4)
    80005cc8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ccc:	02e05763          	blez	a4,80005cfa <printint+0x8e>
    80005cd0:	fd040793          	addi	a5,s0,-48
    80005cd4:	00e784b3          	add	s1,a5,a4
    80005cd8:	fff78913          	addi	s2,a5,-1
    80005cdc:	993a                	add	s2,s2,a4
    80005cde:	377d                	addiw	a4,a4,-1
    80005ce0:	1702                	slli	a4,a4,0x20
    80005ce2:	9301                	srli	a4,a4,0x20
    80005ce4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005ce8:	fff4c503          	lbu	a0,-1(s1)
    80005cec:	00000097          	auipc	ra,0x0
    80005cf0:	d60080e7          	jalr	-672(ra) # 80005a4c <consputc>
  while(--i >= 0)
    80005cf4:	14fd                	addi	s1,s1,-1
    80005cf6:	ff2499e3          	bne	s1,s2,80005ce8 <printint+0x7c>
}
    80005cfa:	70a2                	ld	ra,40(sp)
    80005cfc:	7402                	ld	s0,32(sp)
    80005cfe:	64e2                	ld	s1,24(sp)
    80005d00:	6942                	ld	s2,16(sp)
    80005d02:	6145                	addi	sp,sp,48
    80005d04:	8082                	ret
    x = -xx;
    80005d06:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d0a:	4885                	li	a7,1
    x = -xx;
    80005d0c:	bf9d                	j	80005c82 <printint+0x16>

0000000080005d0e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d0e:	1101                	addi	sp,sp,-32
    80005d10:	ec06                	sd	ra,24(sp)
    80005d12:	e822                	sd	s0,16(sp)
    80005d14:	e426                	sd	s1,8(sp)
    80005d16:	1000                	addi	s0,sp,32
    80005d18:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d1a:	0001c797          	auipc	a5,0x1c
    80005d1e:	3807ab23          	sw	zero,918(a5) # 800220b0 <pr+0x18>
  printf("panic: ");
    80005d22:	00003517          	auipc	a0,0x3
    80005d26:	bb650513          	addi	a0,a0,-1098 # 800088d8 <syscalls+0x400>
    80005d2a:	00000097          	auipc	ra,0x0
    80005d2e:	02e080e7          	jalr	46(ra) # 80005d58 <printf>
  printf(s);
    80005d32:	8526                	mv	a0,s1
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	024080e7          	jalr	36(ra) # 80005d58 <printf>
  printf("\n");
    80005d3c:	00002517          	auipc	a0,0x2
    80005d40:	30c50513          	addi	a0,a0,780 # 80008048 <etext+0x48>
    80005d44:	00000097          	auipc	ra,0x0
    80005d48:	014080e7          	jalr	20(ra) # 80005d58 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d4c:	4785                	li	a5,1
    80005d4e:	00003717          	auipc	a4,0x3
    80005d52:	d0f72f23          	sw	a5,-738(a4) # 80008a6c <panicked>
  for(;;)
    80005d56:	a001                	j	80005d56 <panic+0x48>

0000000080005d58 <printf>:
{
    80005d58:	7131                	addi	sp,sp,-192
    80005d5a:	fc86                	sd	ra,120(sp)
    80005d5c:	f8a2                	sd	s0,112(sp)
    80005d5e:	f4a6                	sd	s1,104(sp)
    80005d60:	f0ca                	sd	s2,96(sp)
    80005d62:	ecce                	sd	s3,88(sp)
    80005d64:	e8d2                	sd	s4,80(sp)
    80005d66:	e4d6                	sd	s5,72(sp)
    80005d68:	e0da                	sd	s6,64(sp)
    80005d6a:	fc5e                	sd	s7,56(sp)
    80005d6c:	f862                	sd	s8,48(sp)
    80005d6e:	f466                	sd	s9,40(sp)
    80005d70:	f06a                	sd	s10,32(sp)
    80005d72:	ec6e                	sd	s11,24(sp)
    80005d74:	0100                	addi	s0,sp,128
    80005d76:	8a2a                	mv	s4,a0
    80005d78:	e40c                	sd	a1,8(s0)
    80005d7a:	e810                	sd	a2,16(s0)
    80005d7c:	ec14                	sd	a3,24(s0)
    80005d7e:	f018                	sd	a4,32(s0)
    80005d80:	f41c                	sd	a5,40(s0)
    80005d82:	03043823          	sd	a6,48(s0)
    80005d86:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d8a:	0001cd97          	auipc	s11,0x1c
    80005d8e:	326dad83          	lw	s11,806(s11) # 800220b0 <pr+0x18>
  if(locking)
    80005d92:	020d9b63          	bnez	s11,80005dc8 <printf+0x70>
  if (fmt == 0)
    80005d96:	040a0263          	beqz	s4,80005dda <printf+0x82>
  va_start(ap, fmt);
    80005d9a:	00840793          	addi	a5,s0,8
    80005d9e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005da2:	000a4503          	lbu	a0,0(s4)
    80005da6:	14050f63          	beqz	a0,80005f04 <printf+0x1ac>
    80005daa:	4981                	li	s3,0
    if(c != '%'){
    80005dac:	02500a93          	li	s5,37
    switch(c){
    80005db0:	07000b93          	li	s7,112
  consputc('x');
    80005db4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005db6:	00003b17          	auipc	s6,0x3
    80005dba:	b4ab0b13          	addi	s6,s6,-1206 # 80008900 <digits>
    switch(c){
    80005dbe:	07300c93          	li	s9,115
    80005dc2:	06400c13          	li	s8,100
    80005dc6:	a82d                	j	80005e00 <printf+0xa8>
    acquire(&pr.lock);
    80005dc8:	0001c517          	auipc	a0,0x1c
    80005dcc:	2d050513          	addi	a0,a0,720 # 80022098 <pr>
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	47a080e7          	jalr	1146(ra) # 8000624a <acquire>
    80005dd8:	bf7d                	j	80005d96 <printf+0x3e>
    panic("null fmt");
    80005dda:	00003517          	auipc	a0,0x3
    80005dde:	b0e50513          	addi	a0,a0,-1266 # 800088e8 <syscalls+0x410>
    80005de2:	00000097          	auipc	ra,0x0
    80005de6:	f2c080e7          	jalr	-212(ra) # 80005d0e <panic>
      consputc(c);
    80005dea:	00000097          	auipc	ra,0x0
    80005dee:	c62080e7          	jalr	-926(ra) # 80005a4c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005df2:	2985                	addiw	s3,s3,1
    80005df4:	013a07b3          	add	a5,s4,s3
    80005df8:	0007c503          	lbu	a0,0(a5)
    80005dfc:	10050463          	beqz	a0,80005f04 <printf+0x1ac>
    if(c != '%'){
    80005e00:	ff5515e3          	bne	a0,s5,80005dea <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e04:	2985                	addiw	s3,s3,1
    80005e06:	013a07b3          	add	a5,s4,s3
    80005e0a:	0007c783          	lbu	a5,0(a5)
    80005e0e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e12:	cbed                	beqz	a5,80005f04 <printf+0x1ac>
    switch(c){
    80005e14:	05778a63          	beq	a5,s7,80005e68 <printf+0x110>
    80005e18:	02fbf663          	bgeu	s7,a5,80005e44 <printf+0xec>
    80005e1c:	09978863          	beq	a5,s9,80005eac <printf+0x154>
    80005e20:	07800713          	li	a4,120
    80005e24:	0ce79563          	bne	a5,a4,80005eee <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005e28:	f8843783          	ld	a5,-120(s0)
    80005e2c:	00878713          	addi	a4,a5,8
    80005e30:	f8e43423          	sd	a4,-120(s0)
    80005e34:	4605                	li	a2,1
    80005e36:	85ea                	mv	a1,s10
    80005e38:	4388                	lw	a0,0(a5)
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	e32080e7          	jalr	-462(ra) # 80005c6c <printint>
      break;
    80005e42:	bf45                	j	80005df2 <printf+0x9a>
    switch(c){
    80005e44:	09578f63          	beq	a5,s5,80005ee2 <printf+0x18a>
    80005e48:	0b879363          	bne	a5,s8,80005eee <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005e4c:	f8843783          	ld	a5,-120(s0)
    80005e50:	00878713          	addi	a4,a5,8
    80005e54:	f8e43423          	sd	a4,-120(s0)
    80005e58:	4605                	li	a2,1
    80005e5a:	45a9                	li	a1,10
    80005e5c:	4388                	lw	a0,0(a5)
    80005e5e:	00000097          	auipc	ra,0x0
    80005e62:	e0e080e7          	jalr	-498(ra) # 80005c6c <printint>
      break;
    80005e66:	b771                	j	80005df2 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e68:	f8843783          	ld	a5,-120(s0)
    80005e6c:	00878713          	addi	a4,a5,8
    80005e70:	f8e43423          	sd	a4,-120(s0)
    80005e74:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e78:	03000513          	li	a0,48
    80005e7c:	00000097          	auipc	ra,0x0
    80005e80:	bd0080e7          	jalr	-1072(ra) # 80005a4c <consputc>
  consputc('x');
    80005e84:	07800513          	li	a0,120
    80005e88:	00000097          	auipc	ra,0x0
    80005e8c:	bc4080e7          	jalr	-1084(ra) # 80005a4c <consputc>
    80005e90:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e92:	03c95793          	srli	a5,s2,0x3c
    80005e96:	97da                	add	a5,a5,s6
    80005e98:	0007c503          	lbu	a0,0(a5)
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	bb0080e7          	jalr	-1104(ra) # 80005a4c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ea4:	0912                	slli	s2,s2,0x4
    80005ea6:	34fd                	addiw	s1,s1,-1
    80005ea8:	f4ed                	bnez	s1,80005e92 <printf+0x13a>
    80005eaa:	b7a1                	j	80005df2 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005eac:	f8843783          	ld	a5,-120(s0)
    80005eb0:	00878713          	addi	a4,a5,8
    80005eb4:	f8e43423          	sd	a4,-120(s0)
    80005eb8:	6384                	ld	s1,0(a5)
    80005eba:	cc89                	beqz	s1,80005ed4 <printf+0x17c>
      for(; *s; s++)
    80005ebc:	0004c503          	lbu	a0,0(s1)
    80005ec0:	d90d                	beqz	a0,80005df2 <printf+0x9a>
        consputc(*s);
    80005ec2:	00000097          	auipc	ra,0x0
    80005ec6:	b8a080e7          	jalr	-1142(ra) # 80005a4c <consputc>
      for(; *s; s++)
    80005eca:	0485                	addi	s1,s1,1
    80005ecc:	0004c503          	lbu	a0,0(s1)
    80005ed0:	f96d                	bnez	a0,80005ec2 <printf+0x16a>
    80005ed2:	b705                	j	80005df2 <printf+0x9a>
        s = "(null)";
    80005ed4:	00003497          	auipc	s1,0x3
    80005ed8:	a0c48493          	addi	s1,s1,-1524 # 800088e0 <syscalls+0x408>
      for(; *s; s++)
    80005edc:	02800513          	li	a0,40
    80005ee0:	b7cd                	j	80005ec2 <printf+0x16a>
      consputc('%');
    80005ee2:	8556                	mv	a0,s5
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	b68080e7          	jalr	-1176(ra) # 80005a4c <consputc>
      break;
    80005eec:	b719                	j	80005df2 <printf+0x9a>
      consputc('%');
    80005eee:	8556                	mv	a0,s5
    80005ef0:	00000097          	auipc	ra,0x0
    80005ef4:	b5c080e7          	jalr	-1188(ra) # 80005a4c <consputc>
      consputc(c);
    80005ef8:	8526                	mv	a0,s1
    80005efa:	00000097          	auipc	ra,0x0
    80005efe:	b52080e7          	jalr	-1198(ra) # 80005a4c <consputc>
      break;
    80005f02:	bdc5                	j	80005df2 <printf+0x9a>
  if(locking)
    80005f04:	020d9163          	bnez	s11,80005f26 <printf+0x1ce>
}
    80005f08:	70e6                	ld	ra,120(sp)
    80005f0a:	7446                	ld	s0,112(sp)
    80005f0c:	74a6                	ld	s1,104(sp)
    80005f0e:	7906                	ld	s2,96(sp)
    80005f10:	69e6                	ld	s3,88(sp)
    80005f12:	6a46                	ld	s4,80(sp)
    80005f14:	6aa6                	ld	s5,72(sp)
    80005f16:	6b06                	ld	s6,64(sp)
    80005f18:	7be2                	ld	s7,56(sp)
    80005f1a:	7c42                	ld	s8,48(sp)
    80005f1c:	7ca2                	ld	s9,40(sp)
    80005f1e:	7d02                	ld	s10,32(sp)
    80005f20:	6de2                	ld	s11,24(sp)
    80005f22:	6129                	addi	sp,sp,192
    80005f24:	8082                	ret
    release(&pr.lock);
    80005f26:	0001c517          	auipc	a0,0x1c
    80005f2a:	17250513          	addi	a0,a0,370 # 80022098 <pr>
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	3d0080e7          	jalr	976(ra) # 800062fe <release>
}
    80005f36:	bfc9                	j	80005f08 <printf+0x1b0>

0000000080005f38 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f38:	1101                	addi	sp,sp,-32
    80005f3a:	ec06                	sd	ra,24(sp)
    80005f3c:	e822                	sd	s0,16(sp)
    80005f3e:	e426                	sd	s1,8(sp)
    80005f40:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f42:	0001c497          	auipc	s1,0x1c
    80005f46:	15648493          	addi	s1,s1,342 # 80022098 <pr>
    80005f4a:	00003597          	auipc	a1,0x3
    80005f4e:	9ae58593          	addi	a1,a1,-1618 # 800088f8 <syscalls+0x420>
    80005f52:	8526                	mv	a0,s1
    80005f54:	00000097          	auipc	ra,0x0
    80005f58:	266080e7          	jalr	614(ra) # 800061ba <initlock>
  pr.locking = 1;
    80005f5c:	4785                	li	a5,1
    80005f5e:	cc9c                	sw	a5,24(s1)
}
    80005f60:	60e2                	ld	ra,24(sp)
    80005f62:	6442                	ld	s0,16(sp)
    80005f64:	64a2                	ld	s1,8(sp)
    80005f66:	6105                	addi	sp,sp,32
    80005f68:	8082                	ret

0000000080005f6a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f6a:	1141                	addi	sp,sp,-16
    80005f6c:	e406                	sd	ra,8(sp)
    80005f6e:	e022                	sd	s0,0(sp)
    80005f70:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f72:	100007b7          	lui	a5,0x10000
    80005f76:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f7a:	f8000713          	li	a4,-128
    80005f7e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f82:	470d                	li	a4,3
    80005f84:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f88:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f8c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f90:	469d                	li	a3,7
    80005f92:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f96:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f9a:	00003597          	auipc	a1,0x3
    80005f9e:	97e58593          	addi	a1,a1,-1666 # 80008918 <digits+0x18>
    80005fa2:	0001c517          	auipc	a0,0x1c
    80005fa6:	11650513          	addi	a0,a0,278 # 800220b8 <uart_tx_lock>
    80005faa:	00000097          	auipc	ra,0x0
    80005fae:	210080e7          	jalr	528(ra) # 800061ba <initlock>
}
    80005fb2:	60a2                	ld	ra,8(sp)
    80005fb4:	6402                	ld	s0,0(sp)
    80005fb6:	0141                	addi	sp,sp,16
    80005fb8:	8082                	ret

0000000080005fba <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fba:	1101                	addi	sp,sp,-32
    80005fbc:	ec06                	sd	ra,24(sp)
    80005fbe:	e822                	sd	s0,16(sp)
    80005fc0:	e426                	sd	s1,8(sp)
    80005fc2:	1000                	addi	s0,sp,32
    80005fc4:	84aa                	mv	s1,a0
  push_off();
    80005fc6:	00000097          	auipc	ra,0x0
    80005fca:	238080e7          	jalr	568(ra) # 800061fe <push_off>

  if(panicked){
    80005fce:	00003797          	auipc	a5,0x3
    80005fd2:	a9e7a783          	lw	a5,-1378(a5) # 80008a6c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fd6:	10000737          	lui	a4,0x10000
  if(panicked){
    80005fda:	c391                	beqz	a5,80005fde <uartputc_sync+0x24>
    for(;;)
    80005fdc:	a001                	j	80005fdc <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fde:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005fe2:	0207f793          	andi	a5,a5,32
    80005fe6:	dfe5                	beqz	a5,80005fde <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005fe8:	0ff4f513          	andi	a0,s1,255
    80005fec:	100007b7          	lui	a5,0x10000
    80005ff0:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005ff4:	00000097          	auipc	ra,0x0
    80005ff8:	2aa080e7          	jalr	682(ra) # 8000629e <pop_off>
}
    80005ffc:	60e2                	ld	ra,24(sp)
    80005ffe:	6442                	ld	s0,16(sp)
    80006000:	64a2                	ld	s1,8(sp)
    80006002:	6105                	addi	sp,sp,32
    80006004:	8082                	ret

0000000080006006 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006006:	00003797          	auipc	a5,0x3
    8000600a:	a6a7b783          	ld	a5,-1430(a5) # 80008a70 <uart_tx_r>
    8000600e:	00003717          	auipc	a4,0x3
    80006012:	a6a73703          	ld	a4,-1430(a4) # 80008a78 <uart_tx_w>
    80006016:	06f70a63          	beq	a4,a5,8000608a <uartstart+0x84>
{
    8000601a:	7139                	addi	sp,sp,-64
    8000601c:	fc06                	sd	ra,56(sp)
    8000601e:	f822                	sd	s0,48(sp)
    80006020:	f426                	sd	s1,40(sp)
    80006022:	f04a                	sd	s2,32(sp)
    80006024:	ec4e                	sd	s3,24(sp)
    80006026:	e852                	sd	s4,16(sp)
    80006028:	e456                	sd	s5,8(sp)
    8000602a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000602c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006030:	0001ca17          	auipc	s4,0x1c
    80006034:	088a0a13          	addi	s4,s4,136 # 800220b8 <uart_tx_lock>
    uart_tx_r += 1;
    80006038:	00003497          	auipc	s1,0x3
    8000603c:	a3848493          	addi	s1,s1,-1480 # 80008a70 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006040:	00003997          	auipc	s3,0x3
    80006044:	a3898993          	addi	s3,s3,-1480 # 80008a78 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006048:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000604c:	02077713          	andi	a4,a4,32
    80006050:	c705                	beqz	a4,80006078 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006052:	01f7f713          	andi	a4,a5,31
    80006056:	9752                	add	a4,a4,s4
    80006058:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000605c:	0785                	addi	a5,a5,1
    8000605e:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006060:	8526                	mv	a0,s1
    80006062:	ffffb097          	auipc	ra,0xffffb
    80006066:	586080e7          	jalr	1414(ra) # 800015e8 <wakeup>
    
    WriteReg(THR, c);
    8000606a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000606e:	609c                	ld	a5,0(s1)
    80006070:	0009b703          	ld	a4,0(s3)
    80006074:	fcf71ae3          	bne	a4,a5,80006048 <uartstart+0x42>
  }
}
    80006078:	70e2                	ld	ra,56(sp)
    8000607a:	7442                	ld	s0,48(sp)
    8000607c:	74a2                	ld	s1,40(sp)
    8000607e:	7902                	ld	s2,32(sp)
    80006080:	69e2                	ld	s3,24(sp)
    80006082:	6a42                	ld	s4,16(sp)
    80006084:	6aa2                	ld	s5,8(sp)
    80006086:	6121                	addi	sp,sp,64
    80006088:	8082                	ret
    8000608a:	8082                	ret

000000008000608c <uartputc>:
{
    8000608c:	7179                	addi	sp,sp,-48
    8000608e:	f406                	sd	ra,40(sp)
    80006090:	f022                	sd	s0,32(sp)
    80006092:	ec26                	sd	s1,24(sp)
    80006094:	e84a                	sd	s2,16(sp)
    80006096:	e44e                	sd	s3,8(sp)
    80006098:	e052                	sd	s4,0(sp)
    8000609a:	1800                	addi	s0,sp,48
    8000609c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000609e:	0001c517          	auipc	a0,0x1c
    800060a2:	01a50513          	addi	a0,a0,26 # 800220b8 <uart_tx_lock>
    800060a6:	00000097          	auipc	ra,0x0
    800060aa:	1a4080e7          	jalr	420(ra) # 8000624a <acquire>
  if(panicked){
    800060ae:	00003797          	auipc	a5,0x3
    800060b2:	9be7a783          	lw	a5,-1602(a5) # 80008a6c <panicked>
    800060b6:	e7c9                	bnez	a5,80006140 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060b8:	00003717          	auipc	a4,0x3
    800060bc:	9c073703          	ld	a4,-1600(a4) # 80008a78 <uart_tx_w>
    800060c0:	00003797          	auipc	a5,0x3
    800060c4:	9b07b783          	ld	a5,-1616(a5) # 80008a70 <uart_tx_r>
    800060c8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800060cc:	0001c997          	auipc	s3,0x1c
    800060d0:	fec98993          	addi	s3,s3,-20 # 800220b8 <uart_tx_lock>
    800060d4:	00003497          	auipc	s1,0x3
    800060d8:	99c48493          	addi	s1,s1,-1636 # 80008a70 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060dc:	00003917          	auipc	s2,0x3
    800060e0:	99c90913          	addi	s2,s2,-1636 # 80008a78 <uart_tx_w>
    800060e4:	00e79f63          	bne	a5,a4,80006102 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800060e8:	85ce                	mv	a1,s3
    800060ea:	8526                	mv	a0,s1
    800060ec:	ffffb097          	auipc	ra,0xffffb
    800060f0:	498080e7          	jalr	1176(ra) # 80001584 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060f4:	00093703          	ld	a4,0(s2)
    800060f8:	609c                	ld	a5,0(s1)
    800060fa:	02078793          	addi	a5,a5,32
    800060fe:	fee785e3          	beq	a5,a4,800060e8 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006102:	0001c497          	auipc	s1,0x1c
    80006106:	fb648493          	addi	s1,s1,-74 # 800220b8 <uart_tx_lock>
    8000610a:	01f77793          	andi	a5,a4,31
    8000610e:	97a6                	add	a5,a5,s1
    80006110:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006114:	0705                	addi	a4,a4,1
    80006116:	00003797          	auipc	a5,0x3
    8000611a:	96e7b123          	sd	a4,-1694(a5) # 80008a78 <uart_tx_w>
  uartstart();
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	ee8080e7          	jalr	-280(ra) # 80006006 <uartstart>
  release(&uart_tx_lock);
    80006126:	8526                	mv	a0,s1
    80006128:	00000097          	auipc	ra,0x0
    8000612c:	1d6080e7          	jalr	470(ra) # 800062fe <release>
}
    80006130:	70a2                	ld	ra,40(sp)
    80006132:	7402                	ld	s0,32(sp)
    80006134:	64e2                	ld	s1,24(sp)
    80006136:	6942                	ld	s2,16(sp)
    80006138:	69a2                	ld	s3,8(sp)
    8000613a:	6a02                	ld	s4,0(sp)
    8000613c:	6145                	addi	sp,sp,48
    8000613e:	8082                	ret
    for(;;)
    80006140:	a001                	j	80006140 <uartputc+0xb4>

0000000080006142 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006142:	1141                	addi	sp,sp,-16
    80006144:	e422                	sd	s0,8(sp)
    80006146:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006148:	100007b7          	lui	a5,0x10000
    8000614c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006150:	8b85                	andi	a5,a5,1
    80006152:	cb91                	beqz	a5,80006166 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006154:	100007b7          	lui	a5,0x10000
    80006158:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000615c:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006160:	6422                	ld	s0,8(sp)
    80006162:	0141                	addi	sp,sp,16
    80006164:	8082                	ret
    return -1;
    80006166:	557d                	li	a0,-1
    80006168:	bfe5                	j	80006160 <uartgetc+0x1e>

000000008000616a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000616a:	1101                	addi	sp,sp,-32
    8000616c:	ec06                	sd	ra,24(sp)
    8000616e:	e822                	sd	s0,16(sp)
    80006170:	e426                	sd	s1,8(sp)
    80006172:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006174:	54fd                	li	s1,-1
    80006176:	a029                	j	80006180 <uartintr+0x16>
      break;
    consoleintr(c);
    80006178:	00000097          	auipc	ra,0x0
    8000617c:	916080e7          	jalr	-1770(ra) # 80005a8e <consoleintr>
    int c = uartgetc();
    80006180:	00000097          	auipc	ra,0x0
    80006184:	fc2080e7          	jalr	-62(ra) # 80006142 <uartgetc>
    if(c == -1)
    80006188:	fe9518e3          	bne	a0,s1,80006178 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000618c:	0001c497          	auipc	s1,0x1c
    80006190:	f2c48493          	addi	s1,s1,-212 # 800220b8 <uart_tx_lock>
    80006194:	8526                	mv	a0,s1
    80006196:	00000097          	auipc	ra,0x0
    8000619a:	0b4080e7          	jalr	180(ra) # 8000624a <acquire>
  uartstart();
    8000619e:	00000097          	auipc	ra,0x0
    800061a2:	e68080e7          	jalr	-408(ra) # 80006006 <uartstart>
  release(&uart_tx_lock);
    800061a6:	8526                	mv	a0,s1
    800061a8:	00000097          	auipc	ra,0x0
    800061ac:	156080e7          	jalr	342(ra) # 800062fe <release>
}
    800061b0:	60e2                	ld	ra,24(sp)
    800061b2:	6442                	ld	s0,16(sp)
    800061b4:	64a2                	ld	s1,8(sp)
    800061b6:	6105                	addi	sp,sp,32
    800061b8:	8082                	ret

00000000800061ba <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061ba:	1141                	addi	sp,sp,-16
    800061bc:	e422                	sd	s0,8(sp)
    800061be:	0800                	addi	s0,sp,16
  lk->name = name;
    800061c0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061c2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061c6:	00053823          	sd	zero,16(a0)
}
    800061ca:	6422                	ld	s0,8(sp)
    800061cc:	0141                	addi	sp,sp,16
    800061ce:	8082                	ret

00000000800061d0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061d0:	411c                	lw	a5,0(a0)
    800061d2:	e399                	bnez	a5,800061d8 <holding+0x8>
    800061d4:	4501                	li	a0,0
  return r;
}
    800061d6:	8082                	ret
{
    800061d8:	1101                	addi	sp,sp,-32
    800061da:	ec06                	sd	ra,24(sp)
    800061dc:	e822                	sd	s0,16(sp)
    800061de:	e426                	sd	s1,8(sp)
    800061e0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061e2:	6904                	ld	s1,16(a0)
    800061e4:	ffffb097          	auipc	ra,0xffffb
    800061e8:	cd0080e7          	jalr	-816(ra) # 80000eb4 <mycpu>
    800061ec:	40a48533          	sub	a0,s1,a0
    800061f0:	00153513          	seqz	a0,a0
}
    800061f4:	60e2                	ld	ra,24(sp)
    800061f6:	6442                	ld	s0,16(sp)
    800061f8:	64a2                	ld	s1,8(sp)
    800061fa:	6105                	addi	sp,sp,32
    800061fc:	8082                	ret

00000000800061fe <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061fe:	1101                	addi	sp,sp,-32
    80006200:	ec06                	sd	ra,24(sp)
    80006202:	e822                	sd	s0,16(sp)
    80006204:	e426                	sd	s1,8(sp)
    80006206:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006208:	100024f3          	csrr	s1,sstatus
    8000620c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006210:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006212:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006216:	ffffb097          	auipc	ra,0xffffb
    8000621a:	c9e080e7          	jalr	-866(ra) # 80000eb4 <mycpu>
    8000621e:	5d3c                	lw	a5,120(a0)
    80006220:	cf89                	beqz	a5,8000623a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006222:	ffffb097          	auipc	ra,0xffffb
    80006226:	c92080e7          	jalr	-878(ra) # 80000eb4 <mycpu>
    8000622a:	5d3c                	lw	a5,120(a0)
    8000622c:	2785                	addiw	a5,a5,1
    8000622e:	dd3c                	sw	a5,120(a0)
}
    80006230:	60e2                	ld	ra,24(sp)
    80006232:	6442                	ld	s0,16(sp)
    80006234:	64a2                	ld	s1,8(sp)
    80006236:	6105                	addi	sp,sp,32
    80006238:	8082                	ret
    mycpu()->intena = old;
    8000623a:	ffffb097          	auipc	ra,0xffffb
    8000623e:	c7a080e7          	jalr	-902(ra) # 80000eb4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006242:	8085                	srli	s1,s1,0x1
    80006244:	8885                	andi	s1,s1,1
    80006246:	dd64                	sw	s1,124(a0)
    80006248:	bfe9                	j	80006222 <push_off+0x24>

000000008000624a <acquire>:
{
    8000624a:	1101                	addi	sp,sp,-32
    8000624c:	ec06                	sd	ra,24(sp)
    8000624e:	e822                	sd	s0,16(sp)
    80006250:	e426                	sd	s1,8(sp)
    80006252:	1000                	addi	s0,sp,32
    80006254:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006256:	00000097          	auipc	ra,0x0
    8000625a:	fa8080e7          	jalr	-88(ra) # 800061fe <push_off>
  if(holding(lk))
    8000625e:	8526                	mv	a0,s1
    80006260:	00000097          	auipc	ra,0x0
    80006264:	f70080e7          	jalr	-144(ra) # 800061d0 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006268:	4705                	li	a4,1
  if(holding(lk))
    8000626a:	e115                	bnez	a0,8000628e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000626c:	87ba                	mv	a5,a4
    8000626e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006272:	2781                	sext.w	a5,a5
    80006274:	ffe5                	bnez	a5,8000626c <acquire+0x22>
  __sync_synchronize();
    80006276:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000627a:	ffffb097          	auipc	ra,0xffffb
    8000627e:	c3a080e7          	jalr	-966(ra) # 80000eb4 <mycpu>
    80006282:	e888                	sd	a0,16(s1)
}
    80006284:	60e2                	ld	ra,24(sp)
    80006286:	6442                	ld	s0,16(sp)
    80006288:	64a2                	ld	s1,8(sp)
    8000628a:	6105                	addi	sp,sp,32
    8000628c:	8082                	ret
    panic("acquire");
    8000628e:	00002517          	auipc	a0,0x2
    80006292:	69250513          	addi	a0,a0,1682 # 80008920 <digits+0x20>
    80006296:	00000097          	auipc	ra,0x0
    8000629a:	a78080e7          	jalr	-1416(ra) # 80005d0e <panic>

000000008000629e <pop_off>:

void
pop_off(void)
{
    8000629e:	1141                	addi	sp,sp,-16
    800062a0:	e406                	sd	ra,8(sp)
    800062a2:	e022                	sd	s0,0(sp)
    800062a4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062a6:	ffffb097          	auipc	ra,0xffffb
    800062aa:	c0e080e7          	jalr	-1010(ra) # 80000eb4 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062ae:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062b2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062b4:	e78d                	bnez	a5,800062de <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062b6:	5d3c                	lw	a5,120(a0)
    800062b8:	02f05b63          	blez	a5,800062ee <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062bc:	37fd                	addiw	a5,a5,-1
    800062be:	0007871b          	sext.w	a4,a5
    800062c2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062c4:	eb09                	bnez	a4,800062d6 <pop_off+0x38>
    800062c6:	5d7c                	lw	a5,124(a0)
    800062c8:	c799                	beqz	a5,800062d6 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062ca:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062ce:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062d2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800062d6:	60a2                	ld	ra,8(sp)
    800062d8:	6402                	ld	s0,0(sp)
    800062da:	0141                	addi	sp,sp,16
    800062dc:	8082                	ret
    panic("pop_off - interruptible");
    800062de:	00002517          	auipc	a0,0x2
    800062e2:	64a50513          	addi	a0,a0,1610 # 80008928 <digits+0x28>
    800062e6:	00000097          	auipc	ra,0x0
    800062ea:	a28080e7          	jalr	-1496(ra) # 80005d0e <panic>
    panic("pop_off");
    800062ee:	00002517          	auipc	a0,0x2
    800062f2:	65250513          	addi	a0,a0,1618 # 80008940 <digits+0x40>
    800062f6:	00000097          	auipc	ra,0x0
    800062fa:	a18080e7          	jalr	-1512(ra) # 80005d0e <panic>

00000000800062fe <release>:
{
    800062fe:	1101                	addi	sp,sp,-32
    80006300:	ec06                	sd	ra,24(sp)
    80006302:	e822                	sd	s0,16(sp)
    80006304:	e426                	sd	s1,8(sp)
    80006306:	1000                	addi	s0,sp,32
    80006308:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000630a:	00000097          	auipc	ra,0x0
    8000630e:	ec6080e7          	jalr	-314(ra) # 800061d0 <holding>
    80006312:	c115                	beqz	a0,80006336 <release+0x38>
  lk->cpu = 0;
    80006314:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006318:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000631c:	0f50000f          	fence	iorw,ow
    80006320:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006324:	00000097          	auipc	ra,0x0
    80006328:	f7a080e7          	jalr	-134(ra) # 8000629e <pop_off>
}
    8000632c:	60e2                	ld	ra,24(sp)
    8000632e:	6442                	ld	s0,16(sp)
    80006330:	64a2                	ld	s1,8(sp)
    80006332:	6105                	addi	sp,sp,32
    80006334:	8082                	ret
    panic("release");
    80006336:	00002517          	auipc	a0,0x2
    8000633a:	61250513          	addi	a0,a0,1554 # 80008948 <digits+0x48>
    8000633e:	00000097          	auipc	ra,0x0
    80006342:	9d0080e7          	jalr	-1584(ra) # 80005d0e <panic>
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
