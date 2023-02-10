
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	e3010113          	addi	sp,sp,-464 # 80019e30 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	6d8050ef          	jal	ra,800056ee <start>

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
    80000034:	f0078793          	addi	a5,a5,-256 # 80021f30 <end>
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
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	87090913          	addi	s2,s2,-1936 # 800088c0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	080080e7          	jalr	128(ra) # 800060da <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	120080e7          	jalr	288(ra) # 8000618e <release>
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
    8000008e:	b14080e7          	jalr	-1260(ra) # 80005b9e <panic>

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
    800000ec:	00008517          	auipc	a0,0x8
    800000f0:	7d450513          	addi	a0,a0,2004 # 800088c0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	f56080e7          	jalr	-170(ra) # 8000604a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	e3050513          	addi	a0,a0,-464 # 80021f30 <end>
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
    80000122:	00008497          	auipc	s1,0x8
    80000126:	79e48493          	addi	s1,s1,1950 # 800088c0 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	fae080e7          	jalr	-82(ra) # 800060da <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	78650513          	addi	a0,a0,1926 # 800088c0 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	04a080e7          	jalr	74(ra) # 8000618e <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00008517          	auipc	a0,0x8
    8000016a:	75a50513          	addi	a0,a0,1882 # 800088c0 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	020080e7          	jalr	32(ra) # 8000618e <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ca19                	beqz	a2,80000194 <memset+0x1c>
    80000180:	87aa                	mv	a5,a0
    80000182:	1602                	slli	a2,a2,0x20
    80000184:	9201                	srli	a2,a2,0x20
    80000186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018e:	0785                	addi	a5,a5,1
    80000190:	fee79de3          	bne	a5,a4,8000018a <memset+0x12>
  }
  return dst;
}
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret

000000008000019a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019a:	1141                	addi	sp,sp,-16
    8000019c:	e422                	sd	s0,8(sp)
    8000019e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a0:	ca05                	beqz	a2,800001d0 <memcmp+0x36>
    800001a2:	fff6069b          	addiw	a3,a2,-1
    800001a6:	1682                	slli	a3,a3,0x20
    800001a8:	9281                	srli	a3,a3,0x20
    800001aa:	0685                	addi	a3,a3,1
    800001ac:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001ae:	00054783          	lbu	a5,0(a0)
    800001b2:	0005c703          	lbu	a4,0(a1)
    800001b6:	00e79863          	bne	a5,a4,800001c6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001ba:	0505                	addi	a0,a0,1
    800001bc:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001be:	fed518e3          	bne	a0,a3,800001ae <memcmp+0x14>
  }

  return 0;
    800001c2:	4501                	li	a0,0
    800001c4:	a019                	j	800001ca <memcmp+0x30>
      return *s1 - *s2;
    800001c6:	40e7853b          	subw	a0,a5,a4
}
    800001ca:	6422                	ld	s0,8(sp)
    800001cc:	0141                	addi	sp,sp,16
    800001ce:	8082                	ret
  return 0;
    800001d0:	4501                	li	a0,0
    800001d2:	bfe5                	j	800001ca <memcmp+0x30>

00000000800001d4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d4:	1141                	addi	sp,sp,-16
    800001d6:	e422                	sd	s0,8(sp)
    800001d8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001da:	c205                	beqz	a2,800001fa <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001dc:	02a5e263          	bltu	a1,a0,80000200 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e0:	1602                	slli	a2,a2,0x20
    800001e2:	9201                	srli	a2,a2,0x20
    800001e4:	00c587b3          	add	a5,a1,a2
{
    800001e8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ea:	0585                	addi	a1,a1,1
    800001ec:	0705                	addi	a4,a4,1
    800001ee:	fff5c683          	lbu	a3,-1(a1)
    800001f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f6:	fef59ae3          	bne	a1,a5,800001ea <memmove+0x16>

  return dst;
}
    800001fa:	6422                	ld	s0,8(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret
  if(s < d && s + n > d){
    80000200:	02061693          	slli	a3,a2,0x20
    80000204:	9281                	srli	a3,a3,0x20
    80000206:	00d58733          	add	a4,a1,a3
    8000020a:	fce57be3          	bgeu	a0,a4,800001e0 <memmove+0xc>
    d += n;
    8000020e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000210:	fff6079b          	addiw	a5,a2,-1
    80000214:	1782                	slli	a5,a5,0x20
    80000216:	9381                	srli	a5,a5,0x20
    80000218:	fff7c793          	not	a5,a5
    8000021c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000021e:	177d                	addi	a4,a4,-1
    80000220:	16fd                	addi	a3,a3,-1
    80000222:	00074603          	lbu	a2,0(a4)
    80000226:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022a:	fee79ae3          	bne	a5,a4,8000021e <memmove+0x4a>
    8000022e:	b7f1                	j	800001fa <memmove+0x26>

0000000080000230 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000230:	1141                	addi	sp,sp,-16
    80000232:	e406                	sd	ra,8(sp)
    80000234:	e022                	sd	s0,0(sp)
    80000236:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	f9c080e7          	jalr	-100(ra) # 800001d4 <memmove>
}
    80000240:	60a2                	ld	ra,8(sp)
    80000242:	6402                	ld	s0,0(sp)
    80000244:	0141                	addi	sp,sp,16
    80000246:	8082                	ret

0000000080000248 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e422                	sd	s0,8(sp)
    8000024c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000024e:	ce11                	beqz	a2,8000026a <strncmp+0x22>
    80000250:	00054783          	lbu	a5,0(a0)
    80000254:	cf89                	beqz	a5,8000026e <strncmp+0x26>
    80000256:	0005c703          	lbu	a4,0(a1)
    8000025a:	00f71a63          	bne	a4,a5,8000026e <strncmp+0x26>
    n--, p++, q++;
    8000025e:	367d                	addiw	a2,a2,-1
    80000260:	0505                	addi	a0,a0,1
    80000262:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000264:	f675                	bnez	a2,80000250 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000266:	4501                	li	a0,0
    80000268:	a809                	j	8000027a <strncmp+0x32>
    8000026a:	4501                	li	a0,0
    8000026c:	a039                	j	8000027a <strncmp+0x32>
  if(n == 0)
    8000026e:	ca09                	beqz	a2,80000280 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret
    return 0;
    80000280:	4501                	li	a0,0
    80000282:	bfe5                	j	8000027a <strncmp+0x32>

0000000080000284 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e422                	sd	s0,8(sp)
    80000288:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028a:	872a                	mv	a4,a0
    8000028c:	8832                	mv	a6,a2
    8000028e:	367d                	addiw	a2,a2,-1
    80000290:	01005963          	blez	a6,800002a2 <strncpy+0x1e>
    80000294:	0705                	addi	a4,a4,1
    80000296:	0005c783          	lbu	a5,0(a1)
    8000029a:	fef70fa3          	sb	a5,-1(a4)
    8000029e:	0585                	addi	a1,a1,1
    800002a0:	f7f5                	bnez	a5,8000028c <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a2:	86ba                	mv	a3,a4
    800002a4:	00c05c63          	blez	a2,800002bc <strncpy+0x38>
    *s++ = 0;
    800002a8:	0685                	addi	a3,a3,1
    800002aa:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002ae:	fff6c793          	not	a5,a3
    800002b2:	9fb9                	addw	a5,a5,a4
    800002b4:	010787bb          	addw	a5,a5,a6
    800002b8:	fef048e3          	bgtz	a5,800002a8 <strncpy+0x24>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	4685                	li	a3,1
    80000306:	9e89                	subw	a3,a3,a0
    80000308:	00f6853b          	addw	a0,a3,a5
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff7c703          	lbu	a4,-1(a5)
    80000312:	fb7d                	bnez	a4,80000308 <strlen+0x14>
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	b00080e7          	jalr	-1280(ra) # 80000e26 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	56270713          	addi	a4,a4,1378 # 80008890 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	ae4080e7          	jalr	-1308(ra) # 80000e26 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	894080e7          	jalr	-1900(ra) # 80005be8 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	796080e7          	jalr	1942(ra) # 80001afa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	d34080e7          	jalr	-716(ra) # 800050a0 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fe0080e7          	jalr	-32(ra) # 80001354 <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	734080e7          	jalr	1844(ra) # 80005ab0 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	a44080e7          	jalr	-1468(ra) # 80005dc8 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	854080e7          	jalr	-1964(ra) # 80005be8 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	844080e7          	jalr	-1980(ra) # 80005be8 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	834080e7          	jalr	-1996(ra) # 80005be8 <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d20080e7          	jalr	-736(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	326080e7          	jalr	806(ra) # 800006ea <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	99e080e7          	jalr	-1634(ra) # 80000d72 <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	6f6080e7          	jalr	1782(ra) # 80001ad2 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	716080e7          	jalr	1814(ra) # 80001afa <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	c9e080e7          	jalr	-866(ra) # 8000508a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	cac080e7          	jalr	-852(ra) # 800050a0 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	e48080e7          	jalr	-440(ra) # 80002244 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	4ec080e7          	jalr	1260(ra) # 800028f0 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	48a080e7          	jalr	1162(ra) # 80003896 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	d94080e7          	jalr	-620(ra) # 800051a8 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d0e080e7          	jalr	-754(ra) # 8000112a <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	46f72323          	sw	a5,1126(a4) # 80008890 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	45a7b783          	ld	a5,1114(a5) # 80008898 <kernel_pagetable>
    80000446:	83b1                	srli	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	slli	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	addi	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	addi	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srli	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	addi	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00005097          	auipc	ra,0x5
    8000048e:	714080e7          	jalr	1812(ra) # 80005b9e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c82080e7          	jalr	-894(ra) # 80000118 <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd2080e7          	jalr	-814(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srli	a5,s1,0xc
    800004b2:	07aa                	slli	a5,a5,0xa
    800004b4:	0017e793          	ori	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addiw	s4,s4,-9
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	andi	s2,s2,511
    800004ca:	090e                	slli	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	andi	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srli	s1,s1,0xa
    800004da:	04b2                	slli	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srli	a0,s3,0xc
    800004e2:	1ff57513          	andi	a0,a0,511
    800004e6:	050e                	slli	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	addi	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srli	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	addi	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	andi	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	00a7d513          	srli	a0,a5,0xa
    8000053c:	0532                	slli	a0,a0,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	addi	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055a:	c639                	beqz	a2,800005a8 <mappages+0x64>
    8000055c:	8aaa                	mv	s5,a0
    8000055e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000560:	77fd                	lui	a5,0xfffff
    80000562:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000566:	15fd                	addi	a1,a1,-1
    80000568:	00c589b3          	add	s3,a1,a2
    8000056c:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000570:	8952                	mv	s2,s4
    80000572:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000576:	6b85                	lui	s7,0x1
    80000578:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057c:	4605                	li	a2,1
    8000057e:	85ca                	mv	a1,s2
    80000580:	8556                	mv	a0,s5
    80000582:	00000097          	auipc	ra,0x0
    80000586:	eda080e7          	jalr	-294(ra) # 8000045c <walk>
    8000058a:	cd1d                	beqz	a0,800005c8 <mappages+0x84>
    if(*pte & PTE_V)
    8000058c:	611c                	ld	a5,0(a0)
    8000058e:	8b85                	andi	a5,a5,1
    80000590:	e785                	bnez	a5,800005b8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000592:	80b1                	srli	s1,s1,0xc
    80000594:	04aa                	slli	s1,s1,0xa
    80000596:	0164e4b3          	or	s1,s1,s6
    8000059a:	0014e493          	ori	s1,s1,1
    8000059e:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a0:	05390063          	beq	s2,s3,800005e0 <mappages+0x9c>
    a += PGSIZE;
    800005a4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a6:	bfc9                	j	80000578 <mappages+0x34>
    panic("mappages: size");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	ab050513          	addi	a0,a0,-1360 # 80008058 <etext+0x58>
    800005b0:	00005097          	auipc	ra,0x5
    800005b4:	5ee080e7          	jalr	1518(ra) # 80005b9e <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	5de080e7          	jalr	1502(ra) # 80005b9e <panic>
      return -1;
    800005c8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ca:	60a6                	ld	ra,72(sp)
    800005cc:	6406                	ld	s0,64(sp)
    800005ce:	74e2                	ld	s1,56(sp)
    800005d0:	7942                	ld	s2,48(sp)
    800005d2:	79a2                	ld	s3,40(sp)
    800005d4:	7a02                	ld	s4,32(sp)
    800005d6:	6ae2                	ld	s5,24(sp)
    800005d8:	6b42                	ld	s6,16(sp)
    800005da:	6ba2                	ld	s7,8(sp)
    800005dc:	6161                	addi	sp,sp,80
    800005de:	8082                	ret
  return 0;
    800005e0:	4501                	li	a0,0
    800005e2:	b7e5                	j	800005ca <mappages+0x86>

00000000800005e4 <kvmmap>:
{
    800005e4:	1141                	addi	sp,sp,-16
    800005e6:	e406                	sd	ra,8(sp)
    800005e8:	e022                	sd	s0,0(sp)
    800005ea:	0800                	addi	s0,sp,16
    800005ec:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ee:	86b2                	mv	a3,a2
    800005f0:	863e                	mv	a2,a5
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	f52080e7          	jalr	-174(ra) # 80000544 <mappages>
    800005fa:	e509                	bnez	a0,80000604 <kvmmap+0x20>
}
    800005fc:	60a2                	ld	ra,8(sp)
    800005fe:	6402                	ld	s0,0(sp)
    80000600:	0141                	addi	sp,sp,16
    80000602:	8082                	ret
    panic("kvmmap");
    80000604:	00008517          	auipc	a0,0x8
    80000608:	a7450513          	addi	a0,a0,-1420 # 80008078 <etext+0x78>
    8000060c:	00005097          	auipc	ra,0x5
    80000610:	592080e7          	jalr	1426(ra) # 80005b9e <panic>

0000000080000614 <kvmmake>:
{
    80000614:	1101                	addi	sp,sp,-32
    80000616:	ec06                	sd	ra,24(sp)
    80000618:	e822                	sd	s0,16(sp)
    8000061a:	e426                	sd	s1,8(sp)
    8000061c:	e04a                	sd	s2,0(sp)
    8000061e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000620:	00000097          	auipc	ra,0x0
    80000624:	af8080e7          	jalr	-1288(ra) # 80000118 <kalloc>
    80000628:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062a:	6605                	lui	a2,0x1
    8000062c:	4581                	li	a1,0
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	b4a080e7          	jalr	-1206(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000636:	4719                	li	a4,6
    80000638:	6685                	lui	a3,0x1
    8000063a:	10000637          	lui	a2,0x10000
    8000063e:	100005b7          	lui	a1,0x10000
    80000642:	8526                	mv	a0,s1
    80000644:	00000097          	auipc	ra,0x0
    80000648:	fa0080e7          	jalr	-96(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064c:	4719                	li	a4,6
    8000064e:	6685                	lui	a3,0x1
    80000650:	10001637          	lui	a2,0x10001
    80000654:	100015b7          	lui	a1,0x10001
    80000658:	8526                	mv	a0,s1
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f8a080e7          	jalr	-118(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	004006b7          	lui	a3,0x400
    80000668:	0c000637          	lui	a2,0xc000
    8000066c:	0c0005b7          	lui	a1,0xc000
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f72080e7          	jalr	-142(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067a:	00008917          	auipc	s2,0x8
    8000067e:	98690913          	addi	s2,s2,-1658 # 80008000 <etext>
    80000682:	4729                	li	a4,10
    80000684:	80008697          	auipc	a3,0x80008
    80000688:	97c68693          	addi	a3,a3,-1668 # 8000 <_entry-0x7fff8000>
    8000068c:	4605                	li	a2,1
    8000068e:	067e                	slli	a2,a2,0x1f
    80000690:	85b2                	mv	a1,a2
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	f50080e7          	jalr	-176(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069c:	4719                	li	a4,6
    8000069e:	46c5                	li	a3,17
    800006a0:	06ee                	slli	a3,a3,0x1b
    800006a2:	412686b3          	sub	a3,a3,s2
    800006a6:	864a                	mv	a2,s2
    800006a8:	85ca                	mv	a1,s2
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	f38080e7          	jalr	-200(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b4:	4729                	li	a4,10
    800006b6:	6685                	lui	a3,0x1
    800006b8:	00007617          	auipc	a2,0x7
    800006bc:	94860613          	addi	a2,a2,-1720 # 80007000 <_trampoline>
    800006c0:	040005b7          	lui	a1,0x4000
    800006c4:	15fd                	addi	a1,a1,-1
    800006c6:	05b2                	slli	a1,a1,0xc
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f1a080e7          	jalr	-230(ra) # 800005e4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	608080e7          	jalr	1544(ra) # 80000cdc <proc_mapstacks>
}
    800006dc:	8526                	mv	a0,s1
    800006de:	60e2                	ld	ra,24(sp)
    800006e0:	6442                	ld	s0,16(sp)
    800006e2:	64a2                	ld	s1,8(sp)
    800006e4:	6902                	ld	s2,0(sp)
    800006e6:	6105                	addi	sp,sp,32
    800006e8:	8082                	ret

00000000800006ea <kvminit>:
{
    800006ea:	1141                	addi	sp,sp,-16
    800006ec:	e406                	sd	ra,8(sp)
    800006ee:	e022                	sd	s0,0(sp)
    800006f0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f22080e7          	jalr	-222(ra) # 80000614 <kvmmake>
    800006fa:	00008797          	auipc	a5,0x8
    800006fe:	18a7bf23          	sd	a0,414(a5) # 80008898 <kernel_pagetable>
}
    80000702:	60a2                	ld	ra,8(sp)
    80000704:	6402                	ld	s0,0(sp)
    80000706:	0141                	addi	sp,sp,16
    80000708:	8082                	ret

000000008000070a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070a:	715d                	addi	sp,sp,-80
    8000070c:	e486                	sd	ra,72(sp)
    8000070e:	e0a2                	sd	s0,64(sp)
    80000710:	fc26                	sd	s1,56(sp)
    80000712:	f84a                	sd	s2,48(sp)
    80000714:	f44e                	sd	s3,40(sp)
    80000716:	f052                	sd	s4,32(sp)
    80000718:	ec56                	sd	s5,24(sp)
    8000071a:	e85a                	sd	s6,16(sp)
    8000071c:	e45e                	sd	s7,8(sp)
    8000071e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000720:	03459793          	slli	a5,a1,0x34
    80000724:	e795                	bnez	a5,80000750 <uvmunmap+0x46>
    80000726:	8a2a                	mv	s4,a0
    80000728:	892e                	mv	s2,a1
    8000072a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072c:	0632                	slli	a2,a2,0xc
    8000072e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000732:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	6b05                	lui	s6,0x1
    80000736:	0735e263          	bltu	a1,s3,8000079a <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073a:	60a6                	ld	ra,72(sp)
    8000073c:	6406                	ld	s0,64(sp)
    8000073e:	74e2                	ld	s1,56(sp)
    80000740:	7942                	ld	s2,48(sp)
    80000742:	79a2                	ld	s3,40(sp)
    80000744:	7a02                	ld	s4,32(sp)
    80000746:	6ae2                	ld	s5,24(sp)
    80000748:	6b42                	ld	s6,16(sp)
    8000074a:	6ba2                	ld	s7,8(sp)
    8000074c:	6161                	addi	sp,sp,80
    8000074e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	93050513          	addi	a0,a0,-1744 # 80008080 <etext+0x80>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	446080e7          	jalr	1094(ra) # 80005b9e <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	436080e7          	jalr	1078(ra) # 80005b9e <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	426080e7          	jalr	1062(ra) # 80005b9e <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	416080e7          	jalr	1046(ra) # 80005b9e <panic>
    *pte = 0;
    80000790:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000794:	995a                	add	s2,s2,s6
    80000796:	fb3972e3          	bgeu	s2,s3,8000073a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079a:	4601                	li	a2,0
    8000079c:	85ca                	mv	a1,s2
    8000079e:	8552                	mv	a0,s4
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	cbc080e7          	jalr	-836(ra) # 8000045c <walk>
    800007a8:	84aa                	mv	s1,a0
    800007aa:	d95d                	beqz	a0,80000760 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ac:	6108                	ld	a0,0(a0)
    800007ae:	00157793          	andi	a5,a0,1
    800007b2:	dfdd                	beqz	a5,80000770 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b4:	3ff57793          	andi	a5,a0,1023
    800007b8:	fd7784e3          	beq	a5,s7,80000780 <uvmunmap+0x76>
    if(do_free){
    800007bc:	fc0a8ae3          	beqz	s5,80000790 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c2:	0532                	slli	a0,a0,0xc
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	858080e7          	jalr	-1960(ra) # 8000001c <kfree>
    800007cc:	b7d1                	j	80000790 <uvmunmap+0x86>

00000000800007ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	940080e7          	jalr	-1728(ra) # 80000118 <kalloc>
    800007e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e2:	c519                	beqz	a0,800007f0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e4:	6605                	lui	a2,0x1
    800007e6:	4581                	li	a1,0
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	990080e7          	jalr	-1648(ra) # 80000178 <memset>
  return pagetable;
}
    800007f0:	8526                	mv	a0,s1
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fc:	7179                	addi	sp,sp,-48
    800007fe:	f406                	sd	ra,40(sp)
    80000800:	f022                	sd	s0,32(sp)
    80000802:	ec26                	sd	s1,24(sp)
    80000804:	e84a                	sd	s2,16(sp)
    80000806:	e44e                	sd	s3,8(sp)
    80000808:	e052                	sd	s4,0(sp)
    8000080a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080c:	6785                	lui	a5,0x1
    8000080e:	04f67863          	bgeu	a2,a5,8000085e <uvmfirst+0x62>
    80000812:	8a2a                	mv	s4,a0
    80000814:	89ae                	mv	s3,a1
    80000816:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	900080e7          	jalr	-1792(ra) # 80000118 <kalloc>
    80000820:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	952080e7          	jalr	-1710(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082e:	4779                	li	a4,30
    80000830:	86ca                	mv	a3,s2
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	8552                	mv	a0,s4
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	d0c080e7          	jalr	-756(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000840:	8626                	mv	a2,s1
    80000842:	85ce                	mv	a1,s3
    80000844:	854a                	mv	a0,s2
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	98e080e7          	jalr	-1650(ra) # 800001d4 <memmove>
}
    8000084e:	70a2                	ld	ra,40(sp)
    80000850:	7402                	ld	s0,32(sp)
    80000852:	64e2                	ld	s1,24(sp)
    80000854:	6942                	ld	s2,16(sp)
    80000856:	69a2                	ld	s3,8(sp)
    80000858:	6a02                	ld	s4,0(sp)
    8000085a:	6145                	addi	sp,sp,48
    8000085c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000085e:	00008517          	auipc	a0,0x8
    80000862:	87a50513          	addi	a0,a0,-1926 # 800080d8 <etext+0xd8>
    80000866:	00005097          	auipc	ra,0x5
    8000086a:	338080e7          	jalr	824(ra) # 80005b9e <panic>

000000008000086e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086e:	1101                	addi	sp,sp,-32
    80000870:	ec06                	sd	ra,24(sp)
    80000872:	e822                	sd	s0,16(sp)
    80000874:	e426                	sd	s1,8(sp)
    80000876:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000878:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087a:	00b67d63          	bgeu	a2,a1,80000894 <uvmdealloc+0x26>
    8000087e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000880:	6785                	lui	a5,0x1
    80000882:	17fd                	addi	a5,a5,-1
    80000884:	00f60733          	add	a4,a2,a5
    80000888:	767d                	lui	a2,0xfffff
    8000088a:	8f71                	and	a4,a4,a2
    8000088c:	97ae                	add	a5,a5,a1
    8000088e:	8ff1                	and	a5,a5,a2
    80000890:	00f76863          	bltu	a4,a5,800008a0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000894:	8526                	mv	a0,s1
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a0:	8f99                	sub	a5,a5,a4
    800008a2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a4:	4685                	li	a3,1
    800008a6:	0007861b          	sext.w	a2,a5
    800008aa:	85ba                	mv	a1,a4
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	e5e080e7          	jalr	-418(ra) # 8000070a <uvmunmap>
    800008b4:	b7c5                	j	80000894 <uvmdealloc+0x26>

00000000800008b6 <uvmalloc>:
  if(newsz < oldsz)
    800008b6:	0ab66563          	bltu	a2,a1,80000960 <uvmalloc+0xaa>
{
    800008ba:	7139                	addi	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	f426                	sd	s1,40(sp)
    800008c2:	f04a                	sd	s2,32(sp)
    800008c4:	ec4e                	sd	s3,24(sp)
    800008c6:	e852                	sd	s4,16(sp)
    800008c8:	e456                	sd	s5,8(sp)
    800008ca:	e05a                	sd	s6,0(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6985                	lui	s3,0x1
    800008d4:	19fd                	addi	s3,s3,-1
    800008d6:	95ce                	add	a1,a1,s3
    800008d8:	79fd                	lui	s3,0xfffff
    800008da:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f363          	bgeu	s3,a2,80000964 <uvmalloc+0xae>
    800008e2:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e4:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	830080e7          	jalr	-2000(ra) # 80000118 <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c51d                	beqz	a0,80000920 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	880080e7          	jalr	-1920(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000900:	875a                	mv	a4,s6
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c3a080e7          	jalr	-966(ra) # 80000544 <mappages>
    80000912:	e90d                	bnez	a0,80000944 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x32>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	a809                	j	80000930 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000920:	864e                	mv	a2,s3
    80000922:	85ca                	mv	a1,s2
    80000924:	8556                	mv	a0,s5
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	f48080e7          	jalr	-184(ra) # 8000086e <uvmdealloc>
      return 0;
    8000092e:	4501                	li	a0,0
}
    80000930:	70e2                	ld	ra,56(sp)
    80000932:	7442                	ld	s0,48(sp)
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
    80000938:	69e2                	ld	s3,24(sp)
    8000093a:	6a42                	ld	s4,16(sp)
    8000093c:	6aa2                	ld	s5,8(sp)
    8000093e:	6b02                	ld	s6,0(sp)
    80000940:	6121                	addi	sp,sp,64
    80000942:	8082                	ret
      kfree(mem);
    80000944:	8526                	mv	a0,s1
    80000946:	fffff097          	auipc	ra,0xfffff
    8000094a:	6d6080e7          	jalr	1750(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094e:	864e                	mv	a2,s3
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	f1a080e7          	jalr	-230(ra) # 8000086e <uvmdealloc>
      return 0;
    8000095c:	4501                	li	a0,0
    8000095e:	bfc9                	j	80000930 <uvmalloc+0x7a>
    return oldsz;
    80000960:	852e                	mv	a0,a1
}
    80000962:	8082                	ret
  return newsz;
    80000964:	8532                	mv	a0,a2
    80000966:	b7e9                	j	80000930 <uvmalloc+0x7a>

0000000080000968 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000968:	7179                	addi	sp,sp,-48
    8000096a:	f406                	sd	ra,40(sp)
    8000096c:	f022                	sd	s0,32(sp)
    8000096e:	ec26                	sd	s1,24(sp)
    80000970:	e84a                	sd	s2,16(sp)
    80000972:	e44e                	sd	s3,8(sp)
    80000974:	e052                	sd	s4,0(sp)
    80000976:	1800                	addi	s0,sp,48
    80000978:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097a:	84aa                	mv	s1,a0
    8000097c:	6905                	lui	s2,0x1
    8000097e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000980:	4985                	li	s3,1
    80000982:	a821                	j	8000099a <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000984:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000986:	0532                	slli	a0,a0,0xc
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	fe0080e7          	jalr	-32(ra) # 80000968 <freewalk>
      pagetable[i] = 0;
    80000990:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000994:	04a1                	addi	s1,s1,8
    80000996:	03248163          	beq	s1,s2,800009b8 <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000099a:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000099c:	00f57793          	andi	a5,a0,15
    800009a0:	ff3782e3          	beq	a5,s3,80000984 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a4:	8905                	andi	a0,a0,1
    800009a6:	d57d                	beqz	a0,80000994 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a8:	00007517          	auipc	a0,0x7
    800009ac:	75050513          	addi	a0,a0,1872 # 800080f8 <etext+0xf8>
    800009b0:	00005097          	auipc	ra,0x5
    800009b4:	1ee080e7          	jalr	494(ra) # 80005b9e <panic>
    }
  }
  kfree((void*)pagetable);
    800009b8:	8552                	mv	a0,s4
    800009ba:	fffff097          	auipc	ra,0xfffff
    800009be:	662080e7          	jalr	1634(ra) # 8000001c <kfree>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret

00000000800009d2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d2:	1101                	addi	sp,sp,-32
    800009d4:	ec06                	sd	ra,24(sp)
    800009d6:	e822                	sd	s0,16(sp)
    800009d8:	e426                	sd	s1,8(sp)
    800009da:	1000                	addi	s0,sp,32
    800009dc:	84aa                	mv	s1,a0
  if(sz > 0)
    800009de:	e999                	bnez	a1,800009f4 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e0:	8526                	mv	a0,s1
    800009e2:	00000097          	auipc	ra,0x0
    800009e6:	f86080e7          	jalr	-122(ra) # 80000968 <freewalk>
}
    800009ea:	60e2                	ld	ra,24(sp)
    800009ec:	6442                	ld	s0,16(sp)
    800009ee:	64a2                	ld	s1,8(sp)
    800009f0:	6105                	addi	sp,sp,32
    800009f2:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f4:	6605                	lui	a2,0x1
    800009f6:	167d                	addi	a2,a2,-1
    800009f8:	962e                	add	a2,a2,a1
    800009fa:	4685                	li	a3,1
    800009fc:	8231                	srli	a2,a2,0xc
    800009fe:	4581                	li	a1,0
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	d0a080e7          	jalr	-758(ra) # 8000070a <uvmunmap>
    80000a08:	bfe1                	j	800009e0 <uvmfree+0xe>

0000000080000a0a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a0a:	c679                	beqz	a2,80000ad8 <uvmcopy+0xce>
{
    80000a0c:	715d                	addi	sp,sp,-80
    80000a0e:	e486                	sd	ra,72(sp)
    80000a10:	e0a2                	sd	s0,64(sp)
    80000a12:	fc26                	sd	s1,56(sp)
    80000a14:	f84a                	sd	s2,48(sp)
    80000a16:	f44e                	sd	s3,40(sp)
    80000a18:	f052                	sd	s4,32(sp)
    80000a1a:	ec56                	sd	s5,24(sp)
    80000a1c:	e85a                	sd	s6,16(sp)
    80000a1e:	e45e                	sd	s7,8(sp)
    80000a20:	0880                	addi	s0,sp,80
    80000a22:	8b2a                	mv	s6,a0
    80000a24:	8aae                	mv	s5,a1
    80000a26:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a28:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a2a:	4601                	li	a2,0
    80000a2c:	85ce                	mv	a1,s3
    80000a2e:	855a                	mv	a0,s6
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	a2c080e7          	jalr	-1492(ra) # 8000045c <walk>
    80000a38:	c531                	beqz	a0,80000a84 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a3a:	6118                	ld	a4,0(a0)
    80000a3c:	00177793          	andi	a5,a4,1
    80000a40:	cbb1                	beqz	a5,80000a94 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a42:	00a75593          	srli	a1,a4,0xa
    80000a46:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a4a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4e:	fffff097          	auipc	ra,0xfffff
    80000a52:	6ca080e7          	jalr	1738(ra) # 80000118 <kalloc>
    80000a56:	892a                	mv	s2,a0
    80000a58:	c939                	beqz	a0,80000aae <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a5a:	6605                	lui	a2,0x1
    80000a5c:	85de                	mv	a1,s7
    80000a5e:	fffff097          	auipc	ra,0xfffff
    80000a62:	776080e7          	jalr	1910(ra) # 800001d4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a66:	8726                	mv	a4,s1
    80000a68:	86ca                	mv	a3,s2
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	85ce                	mv	a1,s3
    80000a6e:	8556                	mv	a0,s5
    80000a70:	00000097          	auipc	ra,0x0
    80000a74:	ad4080e7          	jalr	-1324(ra) # 80000544 <mappages>
    80000a78:	e515                	bnez	a0,80000aa4 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a7a:	6785                	lui	a5,0x1
    80000a7c:	99be                	add	s3,s3,a5
    80000a7e:	fb49e6e3          	bltu	s3,s4,80000a2a <uvmcopy+0x20>
    80000a82:	a081                	j	80000ac2 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a84:	00007517          	auipc	a0,0x7
    80000a88:	68450513          	addi	a0,a0,1668 # 80008108 <etext+0x108>
    80000a8c:	00005097          	auipc	ra,0x5
    80000a90:	112080e7          	jalr	274(ra) # 80005b9e <panic>
      panic("uvmcopy: page not present");
    80000a94:	00007517          	auipc	a0,0x7
    80000a98:	69450513          	addi	a0,a0,1684 # 80008128 <etext+0x128>
    80000a9c:	00005097          	auipc	ra,0x5
    80000aa0:	102080e7          	jalr	258(ra) # 80005b9e <panic>
      kfree(mem);
    80000aa4:	854a                	mv	a0,s2
    80000aa6:	fffff097          	auipc	ra,0xfffff
    80000aaa:	576080e7          	jalr	1398(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aae:	4685                	li	a3,1
    80000ab0:	00c9d613          	srli	a2,s3,0xc
    80000ab4:	4581                	li	a1,0
    80000ab6:	8556                	mv	a0,s5
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	c52080e7          	jalr	-942(ra) # 8000070a <uvmunmap>
  return -1;
    80000ac0:	557d                	li	a0,-1
}
    80000ac2:	60a6                	ld	ra,72(sp)
    80000ac4:	6406                	ld	s0,64(sp)
    80000ac6:	74e2                	ld	s1,56(sp)
    80000ac8:	7942                	ld	s2,48(sp)
    80000aca:	79a2                	ld	s3,40(sp)
    80000acc:	7a02                	ld	s4,32(sp)
    80000ace:	6ae2                	ld	s5,24(sp)
    80000ad0:	6b42                	ld	s6,16(sp)
    80000ad2:	6ba2                	ld	s7,8(sp)
    80000ad4:	6161                	addi	sp,sp,80
    80000ad6:	8082                	ret
  return 0;
    80000ad8:	4501                	li	a0,0
}
    80000ada:	8082                	ret

0000000080000adc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000adc:	1141                	addi	sp,sp,-16
    80000ade:	e406                	sd	ra,8(sp)
    80000ae0:	e022                	sd	s0,0(sp)
    80000ae2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae4:	4601                	li	a2,0
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	976080e7          	jalr	-1674(ra) # 8000045c <walk>
  if(pte == 0)
    80000aee:	c901                	beqz	a0,80000afe <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af0:	611c                	ld	a5,0(a0)
    80000af2:	9bbd                	andi	a5,a5,-17
    80000af4:	e11c                	sd	a5,0(a0)
}
    80000af6:	60a2                	ld	ra,8(sp)
    80000af8:	6402                	ld	s0,0(sp)
    80000afa:	0141                	addi	sp,sp,16
    80000afc:	8082                	ret
    panic("uvmclear");
    80000afe:	00007517          	auipc	a0,0x7
    80000b02:	64a50513          	addi	a0,a0,1610 # 80008148 <etext+0x148>
    80000b06:	00005097          	auipc	ra,0x5
    80000b0a:	098080e7          	jalr	152(ra) # 80005b9e <panic>

0000000080000b0e <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0e:	c6bd                	beqz	a3,80000b7c <copyout+0x6e>
{
    80000b10:	715d                	addi	sp,sp,-80
    80000b12:	e486                	sd	ra,72(sp)
    80000b14:	e0a2                	sd	s0,64(sp)
    80000b16:	fc26                	sd	s1,56(sp)
    80000b18:	f84a                	sd	s2,48(sp)
    80000b1a:	f44e                	sd	s3,40(sp)
    80000b1c:	f052                	sd	s4,32(sp)
    80000b1e:	ec56                	sd	s5,24(sp)
    80000b20:	e85a                	sd	s6,16(sp)
    80000b22:	e45e                	sd	s7,8(sp)
    80000b24:	e062                	sd	s8,0(sp)
    80000b26:	0880                	addi	s0,sp,80
    80000b28:	8b2a                	mv	s6,a0
    80000b2a:	8c2e                	mv	s8,a1
    80000b2c:	8a32                	mv	s4,a2
    80000b2e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b30:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b32:	6a85                	lui	s5,0x1
    80000b34:	a015                	j	80000b58 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b36:	9562                	add	a0,a0,s8
    80000b38:	0004861b          	sext.w	a2,s1
    80000b3c:	85d2                	mv	a1,s4
    80000b3e:	41250533          	sub	a0,a0,s2
    80000b42:	fffff097          	auipc	ra,0xfffff
    80000b46:	692080e7          	jalr	1682(ra) # 800001d4 <memmove>

    len -= n;
    80000b4a:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b50:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b54:	02098263          	beqz	s3,80000b78 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b58:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b5c:	85ca                	mv	a1,s2
    80000b5e:	855a                	mv	a0,s6
    80000b60:	00000097          	auipc	ra,0x0
    80000b64:	9a2080e7          	jalr	-1630(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000b68:	cd01                	beqz	a0,80000b80 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b6a:	418904b3          	sub	s1,s2,s8
    80000b6e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b70:	fc99f3e3          	bgeu	s3,s1,80000b36 <copyout+0x28>
    80000b74:	84ce                	mv	s1,s3
    80000b76:	b7c1                	j	80000b36 <copyout+0x28>
  }
  return 0;
    80000b78:	4501                	li	a0,0
    80000b7a:	a021                	j	80000b82 <copyout+0x74>
    80000b7c:	4501                	li	a0,0
}
    80000b7e:	8082                	ret
      return -1;
    80000b80:	557d                	li	a0,-1
}
    80000b82:	60a6                	ld	ra,72(sp)
    80000b84:	6406                	ld	s0,64(sp)
    80000b86:	74e2                	ld	s1,56(sp)
    80000b88:	7942                	ld	s2,48(sp)
    80000b8a:	79a2                	ld	s3,40(sp)
    80000b8c:	7a02                	ld	s4,32(sp)
    80000b8e:	6ae2                	ld	s5,24(sp)
    80000b90:	6b42                	ld	s6,16(sp)
    80000b92:	6ba2                	ld	s7,8(sp)
    80000b94:	6c02                	ld	s8,0(sp)
    80000b96:	6161                	addi	sp,sp,80
    80000b98:	8082                	ret

0000000080000b9a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b9a:	caa5                	beqz	a3,80000c0a <copyin+0x70>
{
    80000b9c:	715d                	addi	sp,sp,-80
    80000b9e:	e486                	sd	ra,72(sp)
    80000ba0:	e0a2                	sd	s0,64(sp)
    80000ba2:	fc26                	sd	s1,56(sp)
    80000ba4:	f84a                	sd	s2,48(sp)
    80000ba6:	f44e                	sd	s3,40(sp)
    80000ba8:	f052                	sd	s4,32(sp)
    80000baa:	ec56                	sd	s5,24(sp)
    80000bac:	e85a                	sd	s6,16(sp)
    80000bae:	e45e                	sd	s7,8(sp)
    80000bb0:	e062                	sd	s8,0(sp)
    80000bb2:	0880                	addi	s0,sp,80
    80000bb4:	8b2a                	mv	s6,a0
    80000bb6:	8a2e                	mv	s4,a1
    80000bb8:	8c32                	mv	s8,a2
    80000bba:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bbc:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bbe:	6a85                	lui	s5,0x1
    80000bc0:	a01d                	j	80000be6 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc2:	018505b3          	add	a1,a0,s8
    80000bc6:	0004861b          	sext.w	a2,s1
    80000bca:	412585b3          	sub	a1,a1,s2
    80000bce:	8552                	mv	a0,s4
    80000bd0:	fffff097          	auipc	ra,0xfffff
    80000bd4:	604080e7          	jalr	1540(ra) # 800001d4 <memmove>

    len -= n;
    80000bd8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bdc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bde:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be2:	02098263          	beqz	s3,80000c06 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000be6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bea:	85ca                	mv	a1,s2
    80000bec:	855a                	mv	a0,s6
    80000bee:	00000097          	auipc	ra,0x0
    80000bf2:	914080e7          	jalr	-1772(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000bf6:	cd01                	beqz	a0,80000c0e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bf8:	418904b3          	sub	s1,s2,s8
    80000bfc:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bfe:	fc99f2e3          	bgeu	s3,s1,80000bc2 <copyin+0x28>
    80000c02:	84ce                	mv	s1,s3
    80000c04:	bf7d                	j	80000bc2 <copyin+0x28>
  }
  return 0;
    80000c06:	4501                	li	a0,0
    80000c08:	a021                	j	80000c10 <copyin+0x76>
    80000c0a:	4501                	li	a0,0
}
    80000c0c:	8082                	ret
      return -1;
    80000c0e:	557d                	li	a0,-1
}
    80000c10:	60a6                	ld	ra,72(sp)
    80000c12:	6406                	ld	s0,64(sp)
    80000c14:	74e2                	ld	s1,56(sp)
    80000c16:	7942                	ld	s2,48(sp)
    80000c18:	79a2                	ld	s3,40(sp)
    80000c1a:	7a02                	ld	s4,32(sp)
    80000c1c:	6ae2                	ld	s5,24(sp)
    80000c1e:	6b42                	ld	s6,16(sp)
    80000c20:	6ba2                	ld	s7,8(sp)
    80000c22:	6c02                	ld	s8,0(sp)
    80000c24:	6161                	addi	sp,sp,80
    80000c26:	8082                	ret

0000000080000c28 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c28:	c6c5                	beqz	a3,80000cd0 <copyinstr+0xa8>
{
    80000c2a:	715d                	addi	sp,sp,-80
    80000c2c:	e486                	sd	ra,72(sp)
    80000c2e:	e0a2                	sd	s0,64(sp)
    80000c30:	fc26                	sd	s1,56(sp)
    80000c32:	f84a                	sd	s2,48(sp)
    80000c34:	f44e                	sd	s3,40(sp)
    80000c36:	f052                	sd	s4,32(sp)
    80000c38:	ec56                	sd	s5,24(sp)
    80000c3a:	e85a                	sd	s6,16(sp)
    80000c3c:	e45e                	sd	s7,8(sp)
    80000c3e:	0880                	addi	s0,sp,80
    80000c40:	8a2a                	mv	s4,a0
    80000c42:	8b2e                	mv	s6,a1
    80000c44:	8bb2                	mv	s7,a2
    80000c46:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c48:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4a:	6985                	lui	s3,0x1
    80000c4c:	a035                	j	80000c78 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c4e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c52:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c54:	0017b793          	seqz	a5,a5
    80000c58:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c5c:	60a6                	ld	ra,72(sp)
    80000c5e:	6406                	ld	s0,64(sp)
    80000c60:	74e2                	ld	s1,56(sp)
    80000c62:	7942                	ld	s2,48(sp)
    80000c64:	79a2                	ld	s3,40(sp)
    80000c66:	7a02                	ld	s4,32(sp)
    80000c68:	6ae2                	ld	s5,24(sp)
    80000c6a:	6b42                	ld	s6,16(sp)
    80000c6c:	6ba2                	ld	s7,8(sp)
    80000c6e:	6161                	addi	sp,sp,80
    80000c70:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c72:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c76:	c8a9                	beqz	s1,80000cc8 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c78:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c7c:	85ca                	mv	a1,s2
    80000c7e:	8552                	mv	a0,s4
    80000c80:	00000097          	auipc	ra,0x0
    80000c84:	882080e7          	jalr	-1918(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000c88:	c131                	beqz	a0,80000ccc <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c8a:	41790833          	sub	a6,s2,s7
    80000c8e:	984e                	add	a6,a6,s3
    if(n > max)
    80000c90:	0104f363          	bgeu	s1,a6,80000c96 <copyinstr+0x6e>
    80000c94:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c96:	955e                	add	a0,a0,s7
    80000c98:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c9c:	fc080be3          	beqz	a6,80000c72 <copyinstr+0x4a>
    80000ca0:	985a                	add	a6,a6,s6
    80000ca2:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    80000ca8:	14fd                	addi	s1,s1,-1
    80000caa:	9b26                	add	s6,s6,s1
    80000cac:	00f60733          	add	a4,a2,a5
    80000cb0:	00074703          	lbu	a4,0(a4)
    80000cb4:	df49                	beqz	a4,80000c4e <copyinstr+0x26>
        *dst = *p;
    80000cb6:	00e78023          	sb	a4,0(a5)
      --max;
    80000cba:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cbe:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc0:	ff0796e3          	bne	a5,a6,80000cac <copyinstr+0x84>
      dst++;
    80000cc4:	8b42                	mv	s6,a6
    80000cc6:	b775                	j	80000c72 <copyinstr+0x4a>
    80000cc8:	4781                	li	a5,0
    80000cca:	b769                	j	80000c54 <copyinstr+0x2c>
      return -1;
    80000ccc:	557d                	li	a0,-1
    80000cce:	b779                	j	80000c5c <copyinstr+0x34>
  int got_null = 0;
    80000cd0:	4781                	li	a5,0
  if(got_null){
    80000cd2:	0017b793          	seqz	a5,a5
    80000cd6:	40f00533          	neg	a0,a5
}
    80000cda:	8082                	ret

0000000080000cdc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cdc:	7139                	addi	sp,sp,-64
    80000cde:	fc06                	sd	ra,56(sp)
    80000ce0:	f822                	sd	s0,48(sp)
    80000ce2:	f426                	sd	s1,40(sp)
    80000ce4:	f04a                	sd	s2,32(sp)
    80000ce6:	ec4e                	sd	s3,24(sp)
    80000ce8:	e852                	sd	s4,16(sp)
    80000cea:	e456                	sd	s5,8(sp)
    80000cec:	e05a                	sd	s6,0(sp)
    80000cee:	0080                	addi	s0,sp,64
    80000cf0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	00008497          	auipc	s1,0x8
    80000cf6:	01e48493          	addi	s1,s1,30 # 80008d10 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cfa:	8b26                	mv	s6,s1
    80000cfc:	00007a97          	auipc	s5,0x7
    80000d00:	304a8a93          	addi	s5,s5,772 # 80008000 <etext>
    80000d04:	04000937          	lui	s2,0x4000
    80000d08:	197d                	addi	s2,s2,-1
    80000d0a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	0000ea17          	auipc	s4,0xe
    80000d10:	c04a0a13          	addi	s4,s4,-1020 # 8000e910 <tickslock>
    char *pa = kalloc();
    80000d14:	fffff097          	auipc	ra,0xfffff
    80000d18:	404080e7          	jalr	1028(ra) # 80000118 <kalloc>
    80000d1c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d1e:	c131                	beqz	a0,80000d62 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d20:	416485b3          	sub	a1,s1,s6
    80000d24:	8591                	srai	a1,a1,0x4
    80000d26:	000ab783          	ld	a5,0(s5)
    80000d2a:	02f585b3          	mul	a1,a1,a5
    80000d2e:	2585                	addiw	a1,a1,1
    80000d30:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d34:	4719                	li	a4,6
    80000d36:	6685                	lui	a3,0x1
    80000d38:	40b905b3          	sub	a1,s2,a1
    80000d3c:	854e                	mv	a0,s3
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	8a6080e7          	jalr	-1882(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d46:	17048493          	addi	s1,s1,368
    80000d4a:	fd4495e3          	bne	s1,s4,80000d14 <proc_mapstacks+0x38>
  }
}
    80000d4e:	70e2                	ld	ra,56(sp)
    80000d50:	7442                	ld	s0,48(sp)
    80000d52:	74a2                	ld	s1,40(sp)
    80000d54:	7902                	ld	s2,32(sp)
    80000d56:	69e2                	ld	s3,24(sp)
    80000d58:	6a42                	ld	s4,16(sp)
    80000d5a:	6aa2                	ld	s5,8(sp)
    80000d5c:	6b02                	ld	s6,0(sp)
    80000d5e:	6121                	addi	sp,sp,64
    80000d60:	8082                	ret
      panic("kalloc");
    80000d62:	00007517          	auipc	a0,0x7
    80000d66:	3f650513          	addi	a0,a0,1014 # 80008158 <etext+0x158>
    80000d6a:	00005097          	auipc	ra,0x5
    80000d6e:	e34080e7          	jalr	-460(ra) # 80005b9e <panic>

0000000080000d72 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d72:	7139                	addi	sp,sp,-64
    80000d74:	fc06                	sd	ra,56(sp)
    80000d76:	f822                	sd	s0,48(sp)
    80000d78:	f426                	sd	s1,40(sp)
    80000d7a:	f04a                	sd	s2,32(sp)
    80000d7c:	ec4e                	sd	s3,24(sp)
    80000d7e:	e852                	sd	s4,16(sp)
    80000d80:	e456                	sd	s5,8(sp)
    80000d82:	e05a                	sd	s6,0(sp)
    80000d84:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d86:	00007597          	auipc	a1,0x7
    80000d8a:	3da58593          	addi	a1,a1,986 # 80008160 <etext+0x160>
    80000d8e:	00008517          	auipc	a0,0x8
    80000d92:	b5250513          	addi	a0,a0,-1198 # 800088e0 <pid_lock>
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	2b4080e7          	jalr	692(ra) # 8000604a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d9e:	00007597          	auipc	a1,0x7
    80000da2:	3ca58593          	addi	a1,a1,970 # 80008168 <etext+0x168>
    80000da6:	00008517          	auipc	a0,0x8
    80000daa:	b5250513          	addi	a0,a0,-1198 # 800088f8 <wait_lock>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	29c080e7          	jalr	668(ra) # 8000604a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db6:	00008497          	auipc	s1,0x8
    80000dba:	f5a48493          	addi	s1,s1,-166 # 80008d10 <proc>
      initlock(&p->lock, "proc");
    80000dbe:	00007b17          	auipc	s6,0x7
    80000dc2:	3bab0b13          	addi	s6,s6,954 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dc6:	8aa6                	mv	s5,s1
    80000dc8:	00007a17          	auipc	s4,0x7
    80000dcc:	238a0a13          	addi	s4,s4,568 # 80008000 <etext>
    80000dd0:	04000937          	lui	s2,0x4000
    80000dd4:	197d                	addi	s2,s2,-1
    80000dd6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd8:	0000e997          	auipc	s3,0xe
    80000ddc:	b3898993          	addi	s3,s3,-1224 # 8000e910 <tickslock>
      initlock(&p->lock, "proc");
    80000de0:	85da                	mv	a1,s6
    80000de2:	8526                	mv	a0,s1
    80000de4:	00005097          	auipc	ra,0x5
    80000de8:	266080e7          	jalr	614(ra) # 8000604a <initlock>
      p->state = UNUSED;
    80000dec:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df0:	415487b3          	sub	a5,s1,s5
    80000df4:	8791                	srai	a5,a5,0x4
    80000df6:	000a3703          	ld	a4,0(s4)
    80000dfa:	02e787b3          	mul	a5,a5,a4
    80000dfe:	2785                	addiw	a5,a5,1
    80000e00:	00d7979b          	slliw	a5,a5,0xd
    80000e04:	40f907b3          	sub	a5,s2,a5
    80000e08:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	17048493          	addi	s1,s1,368
    80000e0e:	fd3499e3          	bne	s1,s3,80000de0 <procinit+0x6e>
  }
}
    80000e12:	70e2                	ld	ra,56(sp)
    80000e14:	7442                	ld	s0,48(sp)
    80000e16:	74a2                	ld	s1,40(sp)
    80000e18:	7902                	ld	s2,32(sp)
    80000e1a:	69e2                	ld	s3,24(sp)
    80000e1c:	6a42                	ld	s4,16(sp)
    80000e1e:	6aa2                	ld	s5,8(sp)
    80000e20:	6b02                	ld	s6,0(sp)
    80000e22:	6121                	addi	sp,sp,64
    80000e24:	8082                	ret

0000000080000e26 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e26:	1141                	addi	sp,sp,-16
    80000e28:	e422                	sd	s0,8(sp)
    80000e2a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e2c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e2e:	2501                	sext.w	a0,a0
    80000e30:	6422                	ld	s0,8(sp)
    80000e32:	0141                	addi	sp,sp,16
    80000e34:	8082                	ret

0000000080000e36 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e36:	1141                	addi	sp,sp,-16
    80000e38:	e422                	sd	s0,8(sp)
    80000e3a:	0800                	addi	s0,sp,16
    80000e3c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e3e:	2781                	sext.w	a5,a5
    80000e40:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e42:	00008517          	auipc	a0,0x8
    80000e46:	ace50513          	addi	a0,a0,-1330 # 80008910 <cpus>
    80000e4a:	953e                	add	a0,a0,a5
    80000e4c:	6422                	ld	s0,8(sp)
    80000e4e:	0141                	addi	sp,sp,16
    80000e50:	8082                	ret

0000000080000e52 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e52:	1101                	addi	sp,sp,-32
    80000e54:	ec06                	sd	ra,24(sp)
    80000e56:	e822                	sd	s0,16(sp)
    80000e58:	e426                	sd	s1,8(sp)
    80000e5a:	1000                	addi	s0,sp,32
  push_off();
    80000e5c:	00005097          	auipc	ra,0x5
    80000e60:	232080e7          	jalr	562(ra) # 8000608e <push_off>
    80000e64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e66:	2781                	sext.w	a5,a5
    80000e68:	079e                	slli	a5,a5,0x7
    80000e6a:	00008717          	auipc	a4,0x8
    80000e6e:	a7670713          	addi	a4,a4,-1418 # 800088e0 <pid_lock>
    80000e72:	97ba                	add	a5,a5,a4
    80000e74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	2b8080e7          	jalr	696(ra) # 8000612e <pop_off>
  return p;
}
    80000e7e:	8526                	mv	a0,s1
    80000e80:	60e2                	ld	ra,24(sp)
    80000e82:	6442                	ld	s0,16(sp)
    80000e84:	64a2                	ld	s1,8(sp)
    80000e86:	6105                	addi	sp,sp,32
    80000e88:	8082                	ret

0000000080000e8a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e8a:	1141                	addi	sp,sp,-16
    80000e8c:	e406                	sd	ra,8(sp)
    80000e8e:	e022                	sd	s0,0(sp)
    80000e90:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e92:	00000097          	auipc	ra,0x0
    80000e96:	fc0080e7          	jalr	-64(ra) # 80000e52 <myproc>
    80000e9a:	00005097          	auipc	ra,0x5
    80000e9e:	2f4080e7          	jalr	756(ra) # 8000618e <release>

  if (first) {
    80000ea2:	00008797          	auipc	a5,0x8
    80000ea6:	99e7a783          	lw	a5,-1634(a5) # 80008840 <first.1>
    80000eaa:	eb89                	bnez	a5,80000ebc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eac:	00001097          	auipc	ra,0x1
    80000eb0:	c66080e7          	jalr	-922(ra) # 80001b12 <usertrapret>
}
    80000eb4:	60a2                	ld	ra,8(sp)
    80000eb6:	6402                	ld	s0,0(sp)
    80000eb8:	0141                	addi	sp,sp,16
    80000eba:	8082                	ret
    first = 0;
    80000ebc:	00008797          	auipc	a5,0x8
    80000ec0:	9807a223          	sw	zero,-1660(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000ec4:	4505                	li	a0,1
    80000ec6:	00002097          	auipc	ra,0x2
    80000eca:	9aa080e7          	jalr	-1622(ra) # 80002870 <fsinit>
    80000ece:	bff9                	j	80000eac <forkret+0x22>

0000000080000ed0 <allocpid>:
{
    80000ed0:	1101                	addi	sp,sp,-32
    80000ed2:	ec06                	sd	ra,24(sp)
    80000ed4:	e822                	sd	s0,16(sp)
    80000ed6:	e426                	sd	s1,8(sp)
    80000ed8:	e04a                	sd	s2,0(sp)
    80000eda:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000edc:	00008917          	auipc	s2,0x8
    80000ee0:	a0490913          	addi	s2,s2,-1532 # 800088e0 <pid_lock>
    80000ee4:	854a                	mv	a0,s2
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	1f4080e7          	jalr	500(ra) # 800060da <acquire>
  pid = nextpid;
    80000eee:	00008797          	auipc	a5,0x8
    80000ef2:	95678793          	addi	a5,a5,-1706 # 80008844 <nextpid>
    80000ef6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef8:	0014871b          	addiw	a4,s1,1
    80000efc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000efe:	854a                	mv	a0,s2
    80000f00:	00005097          	auipc	ra,0x5
    80000f04:	28e080e7          	jalr	654(ra) # 8000618e <release>
}
    80000f08:	8526                	mv	a0,s1
    80000f0a:	60e2                	ld	ra,24(sp)
    80000f0c:	6442                	ld	s0,16(sp)
    80000f0e:	64a2                	ld	s1,8(sp)
    80000f10:	6902                	ld	s2,0(sp)
    80000f12:	6105                	addi	sp,sp,32
    80000f14:	8082                	ret

0000000080000f16 <proc_pagetable>:
{
    80000f16:	1101                	addi	sp,sp,-32
    80000f18:	ec06                	sd	ra,24(sp)
    80000f1a:	e822                	sd	s0,16(sp)
    80000f1c:	e426                	sd	s1,8(sp)
    80000f1e:	e04a                	sd	s2,0(sp)
    80000f20:	1000                	addi	s0,sp,32
    80000f22:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	8aa080e7          	jalr	-1878(ra) # 800007ce <uvmcreate>
    80000f2c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f2e:	c121                	beqz	a0,80000f6e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f30:	4729                	li	a4,10
    80000f32:	00006697          	auipc	a3,0x6
    80000f36:	0ce68693          	addi	a3,a3,206 # 80007000 <_trampoline>
    80000f3a:	6605                	lui	a2,0x1
    80000f3c:	040005b7          	lui	a1,0x4000
    80000f40:	15fd                	addi	a1,a1,-1
    80000f42:	05b2                	slli	a1,a1,0xc
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	600080e7          	jalr	1536(ra) # 80000544 <mappages>
    80000f4c:	02054863          	bltz	a0,80000f7c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f50:	4719                	li	a4,6
    80000f52:	05893683          	ld	a3,88(s2)
    80000f56:	6605                	lui	a2,0x1
    80000f58:	020005b7          	lui	a1,0x2000
    80000f5c:	15fd                	addi	a1,a1,-1
    80000f5e:	05b6                	slli	a1,a1,0xd
    80000f60:	8526                	mv	a0,s1
    80000f62:	fffff097          	auipc	ra,0xfffff
    80000f66:	5e2080e7          	jalr	1506(ra) # 80000544 <mappages>
    80000f6a:	02054163          	bltz	a0,80000f8c <proc_pagetable+0x76>
}
    80000f6e:	8526                	mv	a0,s1
    80000f70:	60e2                	ld	ra,24(sp)
    80000f72:	6442                	ld	s0,16(sp)
    80000f74:	64a2                	ld	s1,8(sp)
    80000f76:	6902                	ld	s2,0(sp)
    80000f78:	6105                	addi	sp,sp,32
    80000f7a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f7c:	4581                	li	a1,0
    80000f7e:	8526                	mv	a0,s1
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	a52080e7          	jalr	-1454(ra) # 800009d2 <uvmfree>
    return 0;
    80000f88:	4481                	li	s1,0
    80000f8a:	b7d5                	j	80000f6e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f8c:	4681                	li	a3,0
    80000f8e:	4605                	li	a2,1
    80000f90:	040005b7          	lui	a1,0x4000
    80000f94:	15fd                	addi	a1,a1,-1
    80000f96:	05b2                	slli	a1,a1,0xc
    80000f98:	8526                	mv	a0,s1
    80000f9a:	fffff097          	auipc	ra,0xfffff
    80000f9e:	770080e7          	jalr	1904(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa2:	4581                	li	a1,0
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	a2c080e7          	jalr	-1492(ra) # 800009d2 <uvmfree>
    return 0;
    80000fae:	4481                	li	s1,0
    80000fb0:	bf7d                	j	80000f6e <proc_pagetable+0x58>

0000000080000fb2 <proc_freepagetable>:
{
    80000fb2:	1101                	addi	sp,sp,-32
    80000fb4:	ec06                	sd	ra,24(sp)
    80000fb6:	e822                	sd	s0,16(sp)
    80000fb8:	e426                	sd	s1,8(sp)
    80000fba:	e04a                	sd	s2,0(sp)
    80000fbc:	1000                	addi	s0,sp,32
    80000fbe:	84aa                	mv	s1,a0
    80000fc0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc2:	4681                	li	a3,0
    80000fc4:	4605                	li	a2,1
    80000fc6:	040005b7          	lui	a1,0x4000
    80000fca:	15fd                	addi	a1,a1,-1
    80000fcc:	05b2                	slli	a1,a1,0xc
    80000fce:	fffff097          	auipc	ra,0xfffff
    80000fd2:	73c080e7          	jalr	1852(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fd6:	4681                	li	a3,0
    80000fd8:	4605                	li	a2,1
    80000fda:	020005b7          	lui	a1,0x2000
    80000fde:	15fd                	addi	a1,a1,-1
    80000fe0:	05b6                	slli	a1,a1,0xd
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	726080e7          	jalr	1830(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    80000fec:	85ca                	mv	a1,s2
    80000fee:	8526                	mv	a0,s1
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	9e2080e7          	jalr	-1566(ra) # 800009d2 <uvmfree>
}
    80000ff8:	60e2                	ld	ra,24(sp)
    80000ffa:	6442                	ld	s0,16(sp)
    80000ffc:	64a2                	ld	s1,8(sp)
    80000ffe:	6902                	ld	s2,0(sp)
    80001000:	6105                	addi	sp,sp,32
    80001002:	8082                	ret

0000000080001004 <freeproc>:
{
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	1000                	addi	s0,sp,32
    8000100e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001010:	6d28                	ld	a0,88(a0)
    80001012:	c509                	beqz	a0,8000101c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	008080e7          	jalr	8(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000101c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001020:	68a8                	ld	a0,80(s1)
    80001022:	c511                	beqz	a0,8000102e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001024:	64ac                	ld	a1,72(s1)
    80001026:	00000097          	auipc	ra,0x0
    8000102a:	f8c080e7          	jalr	-116(ra) # 80000fb2 <proc_freepagetable>
  p->pagetable = 0;
    8000102e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001032:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001036:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000103a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000103e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001042:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001046:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000104a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000104e:	0004ac23          	sw	zero,24(s1)
}
    80001052:	60e2                	ld	ra,24(sp)
    80001054:	6442                	ld	s0,16(sp)
    80001056:	64a2                	ld	s1,8(sp)
    80001058:	6105                	addi	sp,sp,32
    8000105a:	8082                	ret

000000008000105c <allocproc>:
{
    8000105c:	1101                	addi	sp,sp,-32
    8000105e:	ec06                	sd	ra,24(sp)
    80001060:	e822                	sd	s0,16(sp)
    80001062:	e426                	sd	s1,8(sp)
    80001064:	e04a                	sd	s2,0(sp)
    80001066:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001068:	00008497          	auipc	s1,0x8
    8000106c:	ca848493          	addi	s1,s1,-856 # 80008d10 <proc>
    80001070:	0000e917          	auipc	s2,0xe
    80001074:	8a090913          	addi	s2,s2,-1888 # 8000e910 <tickslock>
    acquire(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	060080e7          	jalr	96(ra) # 800060da <acquire>
    if(p->state == UNUSED) {
    80001082:	4c9c                	lw	a5,24(s1)
    80001084:	cf81                	beqz	a5,8000109c <allocproc+0x40>
      release(&p->lock);
    80001086:	8526                	mv	a0,s1
    80001088:	00005097          	auipc	ra,0x5
    8000108c:	106080e7          	jalr	262(ra) # 8000618e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001090:	17048493          	addi	s1,s1,368
    80001094:	ff2492e3          	bne	s1,s2,80001078 <allocproc+0x1c>
  return 0;
    80001098:	4481                	li	s1,0
    8000109a:	a889                	j	800010ec <allocproc+0x90>
  p->pid = allocpid();
    8000109c:	00000097          	auipc	ra,0x0
    800010a0:	e34080e7          	jalr	-460(ra) # 80000ed0 <allocpid>
    800010a4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a6:	4785                	li	a5,1
    800010a8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	06e080e7          	jalr	110(ra) # 80000118 <kalloc>
    800010b2:	892a                	mv	s2,a0
    800010b4:	eca8                	sd	a0,88(s1)
    800010b6:	c131                	beqz	a0,800010fa <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010b8:	8526                	mv	a0,s1
    800010ba:	00000097          	auipc	ra,0x0
    800010be:	e5c080e7          	jalr	-420(ra) # 80000f16 <proc_pagetable>
    800010c2:	892a                	mv	s2,a0
    800010c4:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010c6:	c531                	beqz	a0,80001112 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010c8:	07000613          	li	a2,112
    800010cc:	4581                	li	a1,0
    800010ce:	06048513          	addi	a0,s1,96
    800010d2:	fffff097          	auipc	ra,0xfffff
    800010d6:	0a6080e7          	jalr	166(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010da:	00000797          	auipc	a5,0x0
    800010de:	db078793          	addi	a5,a5,-592 # 80000e8a <forkret>
    800010e2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e4:	60bc                	ld	a5,64(s1)
    800010e6:	6705                	lui	a4,0x1
    800010e8:	97ba                	add	a5,a5,a4
    800010ea:	f4bc                	sd	a5,104(s1)
}
    800010ec:	8526                	mv	a0,s1
    800010ee:	60e2                	ld	ra,24(sp)
    800010f0:	6442                	ld	s0,16(sp)
    800010f2:	64a2                	ld	s1,8(sp)
    800010f4:	6902                	ld	s2,0(sp)
    800010f6:	6105                	addi	sp,sp,32
    800010f8:	8082                	ret
    freeproc(p);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	f08080e7          	jalr	-248(ra) # 80001004 <freeproc>
    release(&p->lock);
    80001104:	8526                	mv	a0,s1
    80001106:	00005097          	auipc	ra,0x5
    8000110a:	088080e7          	jalr	136(ra) # 8000618e <release>
    return 0;
    8000110e:	84ca                	mv	s1,s2
    80001110:	bff1                	j	800010ec <allocproc+0x90>
    freeproc(p);
    80001112:	8526                	mv	a0,s1
    80001114:	00000097          	auipc	ra,0x0
    80001118:	ef0080e7          	jalr	-272(ra) # 80001004 <freeproc>
    release(&p->lock);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00005097          	auipc	ra,0x5
    80001122:	070080e7          	jalr	112(ra) # 8000618e <release>
    return 0;
    80001126:	84ca                	mv	s1,s2
    80001128:	b7d1                	j	800010ec <allocproc+0x90>

000000008000112a <userinit>:
{
    8000112a:	1101                	addi	sp,sp,-32
    8000112c:	ec06                	sd	ra,24(sp)
    8000112e:	e822                	sd	s0,16(sp)
    80001130:	e426                	sd	s1,8(sp)
    80001132:	1000                	addi	s0,sp,32
  p = allocproc();
    80001134:	00000097          	auipc	ra,0x0
    80001138:	f28080e7          	jalr	-216(ra) # 8000105c <allocproc>
    8000113c:	84aa                	mv	s1,a0
  initproc = p;
    8000113e:	00007797          	auipc	a5,0x7
    80001142:	76a7b123          	sd	a0,1890(a5) # 800088a0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001146:	03400613          	li	a2,52
    8000114a:	00007597          	auipc	a1,0x7
    8000114e:	70658593          	addi	a1,a1,1798 # 80008850 <initcode>
    80001152:	6928                	ld	a0,80(a0)
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	6a8080e7          	jalr	1704(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    8000115c:	6785                	lui	a5,0x1
    8000115e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001160:	6cb8                	ld	a4,88(s1)
    80001162:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001166:	6cb8                	ld	a4,88(s1)
    80001168:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116a:	4641                	li	a2,16
    8000116c:	00007597          	auipc	a1,0x7
    80001170:	01458593          	addi	a1,a1,20 # 80008180 <etext+0x180>
    80001174:	15848513          	addi	a0,s1,344
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	14a080e7          	jalr	330(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001180:	00007517          	auipc	a0,0x7
    80001184:	01050513          	addi	a0,a0,16 # 80008190 <etext+0x190>
    80001188:	00002097          	auipc	ra,0x2
    8000118c:	10a080e7          	jalr	266(ra) # 80003292 <namei>
    80001190:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001194:	478d                	li	a5,3
    80001196:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001198:	8526                	mv	a0,s1
    8000119a:	00005097          	auipc	ra,0x5
    8000119e:	ff4080e7          	jalr	-12(ra) # 8000618e <release>
}
    800011a2:	60e2                	ld	ra,24(sp)
    800011a4:	6442                	ld	s0,16(sp)
    800011a6:	64a2                	ld	s1,8(sp)
    800011a8:	6105                	addi	sp,sp,32
    800011aa:	8082                	ret

00000000800011ac <growproc>:
{
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	e426                	sd	s1,8(sp)
    800011b4:	e04a                	sd	s2,0(sp)
    800011b6:	1000                	addi	s0,sp,32
    800011b8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	c98080e7          	jalr	-872(ra) # 80000e52 <myproc>
    800011c2:	84aa                	mv	s1,a0
  sz = p->sz;
    800011c4:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011c6:	01204c63          	bgtz	s2,800011de <growproc+0x32>
  } else if(n < 0){
    800011ca:	02094663          	bltz	s2,800011f6 <growproc+0x4a>
  p->sz = sz;
    800011ce:	e4ac                	sd	a1,72(s1)
  return 0;
    800011d0:	4501                	li	a0,0
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011de:	4691                	li	a3,4
    800011e0:	00b90633          	add	a2,s2,a1
    800011e4:	6928                	ld	a0,80(a0)
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	6d0080e7          	jalr	1744(ra) # 800008b6 <uvmalloc>
    800011ee:	85aa                	mv	a1,a0
    800011f0:	fd79                	bnez	a0,800011ce <growproc+0x22>
      return -1;
    800011f2:	557d                	li	a0,-1
    800011f4:	bff9                	j	800011d2 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f6:	00b90633          	add	a2,s2,a1
    800011fa:	6928                	ld	a0,80(a0)
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	672080e7          	jalr	1650(ra) # 8000086e <uvmdealloc>
    80001204:	85aa                	mv	a1,a0
    80001206:	b7e1                	j	800011ce <growproc+0x22>

0000000080001208 <fork>:
{
    80001208:	7139                	addi	sp,sp,-64
    8000120a:	fc06                	sd	ra,56(sp)
    8000120c:	f822                	sd	s0,48(sp)
    8000120e:	f426                	sd	s1,40(sp)
    80001210:	f04a                	sd	s2,32(sp)
    80001212:	ec4e                	sd	s3,24(sp)
    80001214:	e852                	sd	s4,16(sp)
    80001216:	e456                	sd	s5,8(sp)
    80001218:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	c38080e7          	jalr	-968(ra) # 80000e52 <myproc>
    80001222:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001224:	00000097          	auipc	ra,0x0
    80001228:	e38080e7          	jalr	-456(ra) # 8000105c <allocproc>
    8000122c:	12050263          	beqz	a0,80001350 <fork+0x148>
    80001230:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001232:	048ab603          	ld	a2,72(s5)
    80001236:	692c                	ld	a1,80(a0)
    80001238:	050ab503          	ld	a0,80(s5)
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	7ce080e7          	jalr	1998(ra) # 80000a0a <uvmcopy>
    80001244:	04054e63          	bltz	a0,800012a0 <fork+0x98>
  np->sz = p->sz;
    80001248:	048ab783          	ld	a5,72(s5)
    8000124c:	04f9b423          	sd	a5,72(s3)
  np->tickets = p->tickets;
    80001250:	168aa783          	lw	a5,360(s5)
    80001254:	16f9a423          	sw	a5,360(s3)
  np->ticks = 0;
    80001258:	1609a623          	sw	zero,364(s3)
  *(np->trapframe) = *(p->trapframe);
    8000125c:	058ab683          	ld	a3,88(s5)
    80001260:	87b6                	mv	a5,a3
    80001262:	0589b703          	ld	a4,88(s3)
    80001266:	12068693          	addi	a3,a3,288
    8000126a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000126e:	6788                	ld	a0,8(a5)
    80001270:	6b8c                	ld	a1,16(a5)
    80001272:	6f90                	ld	a2,24(a5)
    80001274:	01073023          	sd	a6,0(a4)
    80001278:	e708                	sd	a0,8(a4)
    8000127a:	eb0c                	sd	a1,16(a4)
    8000127c:	ef10                	sd	a2,24(a4)
    8000127e:	02078793          	addi	a5,a5,32
    80001282:	02070713          	addi	a4,a4,32
    80001286:	fed792e3          	bne	a5,a3,8000126a <fork+0x62>
  np->trapframe->a0 = 0;
    8000128a:	0589b783          	ld	a5,88(s3)
    8000128e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001292:	0d0a8493          	addi	s1,s5,208
    80001296:	0d098913          	addi	s2,s3,208
    8000129a:	150a8a13          	addi	s4,s5,336
    8000129e:	a00d                	j	800012c0 <fork+0xb8>
    freeproc(np);
    800012a0:	854e                	mv	a0,s3
    800012a2:	00000097          	auipc	ra,0x0
    800012a6:	d62080e7          	jalr	-670(ra) # 80001004 <freeproc>
    release(&np->lock);
    800012aa:	854e                	mv	a0,s3
    800012ac:	00005097          	auipc	ra,0x5
    800012b0:	ee2080e7          	jalr	-286(ra) # 8000618e <release>
    return -1;
    800012b4:	597d                	li	s2,-1
    800012b6:	a059                	j	8000133c <fork+0x134>
  for(i = 0; i < NOFILE; i++)
    800012b8:	04a1                	addi	s1,s1,8
    800012ba:	0921                	addi	s2,s2,8
    800012bc:	01448b63          	beq	s1,s4,800012d2 <fork+0xca>
    if(p->ofile[i])
    800012c0:	6088                	ld	a0,0(s1)
    800012c2:	d97d                	beqz	a0,800012b8 <fork+0xb0>
      np->ofile[i] = filedup(p->ofile[i]);
    800012c4:	00002097          	auipc	ra,0x2
    800012c8:	664080e7          	jalr	1636(ra) # 80003928 <filedup>
    800012cc:	00a93023          	sd	a0,0(s2)
    800012d0:	b7e5                	j	800012b8 <fork+0xb0>
  np->cwd = idup(p->cwd);
    800012d2:	150ab503          	ld	a0,336(s5)
    800012d6:	00001097          	auipc	ra,0x1
    800012da:	7d8080e7          	jalr	2008(ra) # 80002aae <idup>
    800012de:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012e2:	4641                	li	a2,16
    800012e4:	158a8593          	addi	a1,s5,344
    800012e8:	15898513          	addi	a0,s3,344
    800012ec:	fffff097          	auipc	ra,0xfffff
    800012f0:	fd6080e7          	jalr	-42(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    800012f4:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800012f8:	854e                	mv	a0,s3
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	e94080e7          	jalr	-364(ra) # 8000618e <release>
  acquire(&wait_lock);
    80001302:	00007497          	auipc	s1,0x7
    80001306:	5f648493          	addi	s1,s1,1526 # 800088f8 <wait_lock>
    8000130a:	8526                	mv	a0,s1
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	dce080e7          	jalr	-562(ra) # 800060da <acquire>
  np->parent = p;
    80001314:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001318:	8526                	mv	a0,s1
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	e74080e7          	jalr	-396(ra) # 8000618e <release>
  acquire(&np->lock);
    80001322:	854e                	mv	a0,s3
    80001324:	00005097          	auipc	ra,0x5
    80001328:	db6080e7          	jalr	-586(ra) # 800060da <acquire>
  np->state = RUNNABLE;
    8000132c:	478d                	li	a5,3
    8000132e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001332:	854e                	mv	a0,s3
    80001334:	00005097          	auipc	ra,0x5
    80001338:	e5a080e7          	jalr	-422(ra) # 8000618e <release>
}
    8000133c:	854a                	mv	a0,s2
    8000133e:	70e2                	ld	ra,56(sp)
    80001340:	7442                	ld	s0,48(sp)
    80001342:	74a2                	ld	s1,40(sp)
    80001344:	7902                	ld	s2,32(sp)
    80001346:	69e2                	ld	s3,24(sp)
    80001348:	6a42                	ld	s4,16(sp)
    8000134a:	6aa2                	ld	s5,8(sp)
    8000134c:	6121                	addi	sp,sp,64
    8000134e:	8082                	ret
    return -1;
    80001350:	597d                	li	s2,-1
    80001352:	b7ed                	j	8000133c <fork+0x134>

0000000080001354 <scheduler>:
{
    80001354:	7139                	addi	sp,sp,-64
    80001356:	fc06                	sd	ra,56(sp)
    80001358:	f822                	sd	s0,48(sp)
    8000135a:	f426                	sd	s1,40(sp)
    8000135c:	f04a                	sd	s2,32(sp)
    8000135e:	ec4e                	sd	s3,24(sp)
    80001360:	e852                	sd	s4,16(sp)
    80001362:	e456                	sd	s5,8(sp)
    80001364:	e05a                	sd	s6,0(sp)
    80001366:	0080                	addi	s0,sp,64
    80001368:	8792                	mv	a5,tp
  int id = r_tp();
    8000136a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000136c:	00779a93          	slli	s5,a5,0x7
    80001370:	00007717          	auipc	a4,0x7
    80001374:	57070713          	addi	a4,a4,1392 # 800088e0 <pid_lock>
    80001378:	9756                	add	a4,a4,s5
    8000137a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000137e:	00007717          	auipc	a4,0x7
    80001382:	59a70713          	addi	a4,a4,1434 # 80008918 <cpus+0x8>
    80001386:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001388:	498d                	li	s3,3
        p->state = RUNNING;
    8000138a:	4b11                	li	s6,4
        c->proc = p;
    8000138c:	079e                	slli	a5,a5,0x7
    8000138e:	00007a17          	auipc	s4,0x7
    80001392:	552a0a13          	addi	s4,s4,1362 # 800088e0 <pid_lock>
    80001396:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001398:	0000d917          	auipc	s2,0xd
    8000139c:	57890913          	addi	s2,s2,1400 # 8000e910 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013a0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013a8:	10079073          	csrw	sstatus,a5
    800013ac:	00008497          	auipc	s1,0x8
    800013b0:	96448493          	addi	s1,s1,-1692 # 80008d10 <proc>
    800013b4:	a811                	j	800013c8 <scheduler+0x74>
      release(&p->lock);
    800013b6:	8526                	mv	a0,s1
    800013b8:	00005097          	auipc	ra,0x5
    800013bc:	dd6080e7          	jalr	-554(ra) # 8000618e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013c0:	17048493          	addi	s1,s1,368
    800013c4:	fd248ee3          	beq	s1,s2,800013a0 <scheduler+0x4c>
      acquire(&p->lock);
    800013c8:	8526                	mv	a0,s1
    800013ca:	00005097          	auipc	ra,0x5
    800013ce:	d10080e7          	jalr	-752(ra) # 800060da <acquire>
      if(p->state == RUNNABLE) {
    800013d2:	4c9c                	lw	a5,24(s1)
    800013d4:	ff3791e3          	bne	a5,s3,800013b6 <scheduler+0x62>
        p->state = RUNNING;
    800013d8:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013dc:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013e0:	06048593          	addi	a1,s1,96
    800013e4:	8556                	mv	a0,s5
    800013e6:	00000097          	auipc	ra,0x0
    800013ea:	682080e7          	jalr	1666(ra) # 80001a68 <swtch>
        c->proc = 0;
    800013ee:	020a3823          	sd	zero,48(s4)
    800013f2:	b7d1                	j	800013b6 <scheduler+0x62>

00000000800013f4 <sched>:
{
    800013f4:	7179                	addi	sp,sp,-48
    800013f6:	f406                	sd	ra,40(sp)
    800013f8:	f022                	sd	s0,32(sp)
    800013fa:	ec26                	sd	s1,24(sp)
    800013fc:	e84a                	sd	s2,16(sp)
    800013fe:	e44e                	sd	s3,8(sp)
    80001400:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001402:	00000097          	auipc	ra,0x0
    80001406:	a50080e7          	jalr	-1456(ra) # 80000e52 <myproc>
    8000140a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000140c:	00005097          	auipc	ra,0x5
    80001410:	c54080e7          	jalr	-940(ra) # 80006060 <holding>
    80001414:	c93d                	beqz	a0,8000148a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001416:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001418:	2781                	sext.w	a5,a5
    8000141a:	079e                	slli	a5,a5,0x7
    8000141c:	00007717          	auipc	a4,0x7
    80001420:	4c470713          	addi	a4,a4,1220 # 800088e0 <pid_lock>
    80001424:	97ba                	add	a5,a5,a4
    80001426:	0a87a703          	lw	a4,168(a5)
    8000142a:	4785                	li	a5,1
    8000142c:	06f71763          	bne	a4,a5,8000149a <sched+0xa6>
  if(p->state == RUNNING)
    80001430:	4c98                	lw	a4,24(s1)
    80001432:	4791                	li	a5,4
    80001434:	06f70b63          	beq	a4,a5,800014aa <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001438:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000143c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000143e:	efb5                	bnez	a5,800014ba <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001440:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001442:	00007917          	auipc	s2,0x7
    80001446:	49e90913          	addi	s2,s2,1182 # 800088e0 <pid_lock>
    8000144a:	2781                	sext.w	a5,a5
    8000144c:	079e                	slli	a5,a5,0x7
    8000144e:	97ca                	add	a5,a5,s2
    80001450:	0ac7a983          	lw	s3,172(a5)
    80001454:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001456:	2781                	sext.w	a5,a5
    80001458:	079e                	slli	a5,a5,0x7
    8000145a:	00007597          	auipc	a1,0x7
    8000145e:	4be58593          	addi	a1,a1,1214 # 80008918 <cpus+0x8>
    80001462:	95be                	add	a1,a1,a5
    80001464:	06048513          	addi	a0,s1,96
    80001468:	00000097          	auipc	ra,0x0
    8000146c:	600080e7          	jalr	1536(ra) # 80001a68 <swtch>
    80001470:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001472:	2781                	sext.w	a5,a5
    80001474:	079e                	slli	a5,a5,0x7
    80001476:	97ca                	add	a5,a5,s2
    80001478:	0b37a623          	sw	s3,172(a5)
}
    8000147c:	70a2                	ld	ra,40(sp)
    8000147e:	7402                	ld	s0,32(sp)
    80001480:	64e2                	ld	s1,24(sp)
    80001482:	6942                	ld	s2,16(sp)
    80001484:	69a2                	ld	s3,8(sp)
    80001486:	6145                	addi	sp,sp,48
    80001488:	8082                	ret
    panic("sched p->lock");
    8000148a:	00007517          	auipc	a0,0x7
    8000148e:	d0e50513          	addi	a0,a0,-754 # 80008198 <etext+0x198>
    80001492:	00004097          	auipc	ra,0x4
    80001496:	70c080e7          	jalr	1804(ra) # 80005b9e <panic>
    panic("sched locks");
    8000149a:	00007517          	auipc	a0,0x7
    8000149e:	d0e50513          	addi	a0,a0,-754 # 800081a8 <etext+0x1a8>
    800014a2:	00004097          	auipc	ra,0x4
    800014a6:	6fc080e7          	jalr	1788(ra) # 80005b9e <panic>
    panic("sched running");
    800014aa:	00007517          	auipc	a0,0x7
    800014ae:	d0e50513          	addi	a0,a0,-754 # 800081b8 <etext+0x1b8>
    800014b2:	00004097          	auipc	ra,0x4
    800014b6:	6ec080e7          	jalr	1772(ra) # 80005b9e <panic>
    panic("sched interruptible");
    800014ba:	00007517          	auipc	a0,0x7
    800014be:	d0e50513          	addi	a0,a0,-754 # 800081c8 <etext+0x1c8>
    800014c2:	00004097          	auipc	ra,0x4
    800014c6:	6dc080e7          	jalr	1756(ra) # 80005b9e <panic>

00000000800014ca <yield>:
{
    800014ca:	1101                	addi	sp,sp,-32
    800014cc:	ec06                	sd	ra,24(sp)
    800014ce:	e822                	sd	s0,16(sp)
    800014d0:	e426                	sd	s1,8(sp)
    800014d2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014d4:	00000097          	auipc	ra,0x0
    800014d8:	97e080e7          	jalr	-1666(ra) # 80000e52 <myproc>
    800014dc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014de:	00005097          	auipc	ra,0x5
    800014e2:	bfc080e7          	jalr	-1028(ra) # 800060da <acquire>
  p->state = RUNNABLE;
    800014e6:	478d                	li	a5,3
    800014e8:	cc9c                	sw	a5,24(s1)
  sched();
    800014ea:	00000097          	auipc	ra,0x0
    800014ee:	f0a080e7          	jalr	-246(ra) # 800013f4 <sched>
  release(&p->lock);
    800014f2:	8526                	mv	a0,s1
    800014f4:	00005097          	auipc	ra,0x5
    800014f8:	c9a080e7          	jalr	-870(ra) # 8000618e <release>
}
    800014fc:	60e2                	ld	ra,24(sp)
    800014fe:	6442                	ld	s0,16(sp)
    80001500:	64a2                	ld	s1,8(sp)
    80001502:	6105                	addi	sp,sp,32
    80001504:	8082                	ret

0000000080001506 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001506:	7179                	addi	sp,sp,-48
    80001508:	f406                	sd	ra,40(sp)
    8000150a:	f022                	sd	s0,32(sp)
    8000150c:	ec26                	sd	s1,24(sp)
    8000150e:	e84a                	sd	s2,16(sp)
    80001510:	e44e                	sd	s3,8(sp)
    80001512:	1800                	addi	s0,sp,48
    80001514:	89aa                	mv	s3,a0
    80001516:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	93a080e7          	jalr	-1734(ra) # 80000e52 <myproc>
    80001520:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001522:	00005097          	auipc	ra,0x5
    80001526:	bb8080e7          	jalr	-1096(ra) # 800060da <acquire>
  release(lk);
    8000152a:	854a                	mv	a0,s2
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	c62080e7          	jalr	-926(ra) # 8000618e <release>

  // Go to sleep.
  p->chan = chan;
    80001534:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001538:	4789                	li	a5,2
    8000153a:	cc9c                	sw	a5,24(s1)

  sched();
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	eb8080e7          	jalr	-328(ra) # 800013f4 <sched>

  // Tidy up.
  p->chan = 0;
    80001544:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001548:	8526                	mv	a0,s1
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	c44080e7          	jalr	-956(ra) # 8000618e <release>
  acquire(lk);
    80001552:	854a                	mv	a0,s2
    80001554:	00005097          	auipc	ra,0x5
    80001558:	b86080e7          	jalr	-1146(ra) # 800060da <acquire>
}
    8000155c:	70a2                	ld	ra,40(sp)
    8000155e:	7402                	ld	s0,32(sp)
    80001560:	64e2                	ld	s1,24(sp)
    80001562:	6942                	ld	s2,16(sp)
    80001564:	69a2                	ld	s3,8(sp)
    80001566:	6145                	addi	sp,sp,48
    80001568:	8082                	ret

000000008000156a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000156a:	7139                	addi	sp,sp,-64
    8000156c:	fc06                	sd	ra,56(sp)
    8000156e:	f822                	sd	s0,48(sp)
    80001570:	f426                	sd	s1,40(sp)
    80001572:	f04a                	sd	s2,32(sp)
    80001574:	ec4e                	sd	s3,24(sp)
    80001576:	e852                	sd	s4,16(sp)
    80001578:	e456                	sd	s5,8(sp)
    8000157a:	0080                	addi	s0,sp,64
    8000157c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000157e:	00007497          	auipc	s1,0x7
    80001582:	79248493          	addi	s1,s1,1938 # 80008d10 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001586:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001588:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000158a:	0000d917          	auipc	s2,0xd
    8000158e:	38690913          	addi	s2,s2,902 # 8000e910 <tickslock>
    80001592:	a811                	j	800015a6 <wakeup+0x3c>
      }
      release(&p->lock);
    80001594:	8526                	mv	a0,s1
    80001596:	00005097          	auipc	ra,0x5
    8000159a:	bf8080e7          	jalr	-1032(ra) # 8000618e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000159e:	17048493          	addi	s1,s1,368
    800015a2:	03248663          	beq	s1,s2,800015ce <wakeup+0x64>
    if(p != myproc()){
    800015a6:	00000097          	auipc	ra,0x0
    800015aa:	8ac080e7          	jalr	-1876(ra) # 80000e52 <myproc>
    800015ae:	fea488e3          	beq	s1,a0,8000159e <wakeup+0x34>
      acquire(&p->lock);
    800015b2:	8526                	mv	a0,s1
    800015b4:	00005097          	auipc	ra,0x5
    800015b8:	b26080e7          	jalr	-1242(ra) # 800060da <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015bc:	4c9c                	lw	a5,24(s1)
    800015be:	fd379be3          	bne	a5,s3,80001594 <wakeup+0x2a>
    800015c2:	709c                	ld	a5,32(s1)
    800015c4:	fd4798e3          	bne	a5,s4,80001594 <wakeup+0x2a>
        p->state = RUNNABLE;
    800015c8:	0154ac23          	sw	s5,24(s1)
    800015cc:	b7e1                	j	80001594 <wakeup+0x2a>
    }
  }
}
    800015ce:	70e2                	ld	ra,56(sp)
    800015d0:	7442                	ld	s0,48(sp)
    800015d2:	74a2                	ld	s1,40(sp)
    800015d4:	7902                	ld	s2,32(sp)
    800015d6:	69e2                	ld	s3,24(sp)
    800015d8:	6a42                	ld	s4,16(sp)
    800015da:	6aa2                	ld	s5,8(sp)
    800015dc:	6121                	addi	sp,sp,64
    800015de:	8082                	ret

00000000800015e0 <reparent>:
{
    800015e0:	7179                	addi	sp,sp,-48
    800015e2:	f406                	sd	ra,40(sp)
    800015e4:	f022                	sd	s0,32(sp)
    800015e6:	ec26                	sd	s1,24(sp)
    800015e8:	e84a                	sd	s2,16(sp)
    800015ea:	e44e                	sd	s3,8(sp)
    800015ec:	e052                	sd	s4,0(sp)
    800015ee:	1800                	addi	s0,sp,48
    800015f0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f2:	00007497          	auipc	s1,0x7
    800015f6:	71e48493          	addi	s1,s1,1822 # 80008d10 <proc>
      pp->parent = initproc;
    800015fa:	00007a17          	auipc	s4,0x7
    800015fe:	2a6a0a13          	addi	s4,s4,678 # 800088a0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001602:	0000d997          	auipc	s3,0xd
    80001606:	30e98993          	addi	s3,s3,782 # 8000e910 <tickslock>
    8000160a:	a029                	j	80001614 <reparent+0x34>
    8000160c:	17048493          	addi	s1,s1,368
    80001610:	01348d63          	beq	s1,s3,8000162a <reparent+0x4a>
    if(pp->parent == p){
    80001614:	7c9c                	ld	a5,56(s1)
    80001616:	ff279be3          	bne	a5,s2,8000160c <reparent+0x2c>
      pp->parent = initproc;
    8000161a:	000a3503          	ld	a0,0(s4)
    8000161e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001620:	00000097          	auipc	ra,0x0
    80001624:	f4a080e7          	jalr	-182(ra) # 8000156a <wakeup>
    80001628:	b7d5                	j	8000160c <reparent+0x2c>
}
    8000162a:	70a2                	ld	ra,40(sp)
    8000162c:	7402                	ld	s0,32(sp)
    8000162e:	64e2                	ld	s1,24(sp)
    80001630:	6942                	ld	s2,16(sp)
    80001632:	69a2                	ld	s3,8(sp)
    80001634:	6a02                	ld	s4,0(sp)
    80001636:	6145                	addi	sp,sp,48
    80001638:	8082                	ret

000000008000163a <exit>:
{
    8000163a:	7179                	addi	sp,sp,-48
    8000163c:	f406                	sd	ra,40(sp)
    8000163e:	f022                	sd	s0,32(sp)
    80001640:	ec26                	sd	s1,24(sp)
    80001642:	e84a                	sd	s2,16(sp)
    80001644:	e44e                	sd	s3,8(sp)
    80001646:	e052                	sd	s4,0(sp)
    80001648:	1800                	addi	s0,sp,48
    8000164a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000164c:	00000097          	auipc	ra,0x0
    80001650:	806080e7          	jalr	-2042(ra) # 80000e52 <myproc>
    80001654:	89aa                	mv	s3,a0
  if(p == initproc)
    80001656:	00007797          	auipc	a5,0x7
    8000165a:	24a7b783          	ld	a5,586(a5) # 800088a0 <initproc>
    8000165e:	0d050493          	addi	s1,a0,208
    80001662:	15050913          	addi	s2,a0,336
    80001666:	02a79363          	bne	a5,a0,8000168c <exit+0x52>
    panic("init exiting");
    8000166a:	00007517          	auipc	a0,0x7
    8000166e:	b7650513          	addi	a0,a0,-1162 # 800081e0 <etext+0x1e0>
    80001672:	00004097          	auipc	ra,0x4
    80001676:	52c080e7          	jalr	1324(ra) # 80005b9e <panic>
      fileclose(f);
    8000167a:	00002097          	auipc	ra,0x2
    8000167e:	300080e7          	jalr	768(ra) # 8000397a <fileclose>
      p->ofile[fd] = 0;
    80001682:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001686:	04a1                	addi	s1,s1,8
    80001688:	01248563          	beq	s1,s2,80001692 <exit+0x58>
    if(p->ofile[fd]){
    8000168c:	6088                	ld	a0,0(s1)
    8000168e:	f575                	bnez	a0,8000167a <exit+0x40>
    80001690:	bfdd                	j	80001686 <exit+0x4c>
  begin_op();
    80001692:	00002097          	auipc	ra,0x2
    80001696:	e1c080e7          	jalr	-484(ra) # 800034ae <begin_op>
  iput(p->cwd);
    8000169a:	1509b503          	ld	a0,336(s3)
    8000169e:	00001097          	auipc	ra,0x1
    800016a2:	608080e7          	jalr	1544(ra) # 80002ca6 <iput>
  end_op();
    800016a6:	00002097          	auipc	ra,0x2
    800016aa:	e88080e7          	jalr	-376(ra) # 8000352e <end_op>
  p->cwd = 0;
    800016ae:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016b2:	00007497          	auipc	s1,0x7
    800016b6:	24648493          	addi	s1,s1,582 # 800088f8 <wait_lock>
    800016ba:	8526                	mv	a0,s1
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	a1e080e7          	jalr	-1506(ra) # 800060da <acquire>
  reparent(p);
    800016c4:	854e                	mv	a0,s3
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	f1a080e7          	jalr	-230(ra) # 800015e0 <reparent>
  wakeup(p->parent);
    800016ce:	0389b503          	ld	a0,56(s3)
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	e98080e7          	jalr	-360(ra) # 8000156a <wakeup>
  acquire(&p->lock);
    800016da:	854e                	mv	a0,s3
    800016dc:	00005097          	auipc	ra,0x5
    800016e0:	9fe080e7          	jalr	-1538(ra) # 800060da <acquire>
  p->xstate = status;
    800016e4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016e8:	4795                	li	a5,5
    800016ea:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016ee:	8526                	mv	a0,s1
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	a9e080e7          	jalr	-1378(ra) # 8000618e <release>
  sched();
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	cfc080e7          	jalr	-772(ra) # 800013f4 <sched>
  panic("zombie exit");
    80001700:	00007517          	auipc	a0,0x7
    80001704:	af050513          	addi	a0,a0,-1296 # 800081f0 <etext+0x1f0>
    80001708:	00004097          	auipc	ra,0x4
    8000170c:	496080e7          	jalr	1174(ra) # 80005b9e <panic>

0000000080001710 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001710:	7179                	addi	sp,sp,-48
    80001712:	f406                	sd	ra,40(sp)
    80001714:	f022                	sd	s0,32(sp)
    80001716:	ec26                	sd	s1,24(sp)
    80001718:	e84a                	sd	s2,16(sp)
    8000171a:	e44e                	sd	s3,8(sp)
    8000171c:	1800                	addi	s0,sp,48
    8000171e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001720:	00007497          	auipc	s1,0x7
    80001724:	5f048493          	addi	s1,s1,1520 # 80008d10 <proc>
    80001728:	0000d997          	auipc	s3,0xd
    8000172c:	1e898993          	addi	s3,s3,488 # 8000e910 <tickslock>
    acquire(&p->lock);
    80001730:	8526                	mv	a0,s1
    80001732:	00005097          	auipc	ra,0x5
    80001736:	9a8080e7          	jalr	-1624(ra) # 800060da <acquire>
    if(p->pid == pid){
    8000173a:	589c                	lw	a5,48(s1)
    8000173c:	01278d63          	beq	a5,s2,80001756 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001740:	8526                	mv	a0,s1
    80001742:	00005097          	auipc	ra,0x5
    80001746:	a4c080e7          	jalr	-1460(ra) # 8000618e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000174a:	17048493          	addi	s1,s1,368
    8000174e:	ff3491e3          	bne	s1,s3,80001730 <kill+0x20>
  }
  return -1;
    80001752:	557d                	li	a0,-1
    80001754:	a829                	j	8000176e <kill+0x5e>
      p->killed = 1;
    80001756:	4785                	li	a5,1
    80001758:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000175a:	4c98                	lw	a4,24(s1)
    8000175c:	4789                	li	a5,2
    8000175e:	00f70f63          	beq	a4,a5,8000177c <kill+0x6c>
      release(&p->lock);
    80001762:	8526                	mv	a0,s1
    80001764:	00005097          	auipc	ra,0x5
    80001768:	a2a080e7          	jalr	-1494(ra) # 8000618e <release>
      return 0;
    8000176c:	4501                	li	a0,0
}
    8000176e:	70a2                	ld	ra,40(sp)
    80001770:	7402                	ld	s0,32(sp)
    80001772:	64e2                	ld	s1,24(sp)
    80001774:	6942                	ld	s2,16(sp)
    80001776:	69a2                	ld	s3,8(sp)
    80001778:	6145                	addi	sp,sp,48
    8000177a:	8082                	ret
        p->state = RUNNABLE;
    8000177c:	478d                	li	a5,3
    8000177e:	cc9c                	sw	a5,24(s1)
    80001780:	b7cd                	j	80001762 <kill+0x52>

0000000080001782 <setkilled>:

void
setkilled(struct proc *p)
{
    80001782:	1101                	addi	sp,sp,-32
    80001784:	ec06                	sd	ra,24(sp)
    80001786:	e822                	sd	s0,16(sp)
    80001788:	e426                	sd	s1,8(sp)
    8000178a:	1000                	addi	s0,sp,32
    8000178c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000178e:	00005097          	auipc	ra,0x5
    80001792:	94c080e7          	jalr	-1716(ra) # 800060da <acquire>
  p->killed = 1;
    80001796:	4785                	li	a5,1
    80001798:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000179a:	8526                	mv	a0,s1
    8000179c:	00005097          	auipc	ra,0x5
    800017a0:	9f2080e7          	jalr	-1550(ra) # 8000618e <release>
}
    800017a4:	60e2                	ld	ra,24(sp)
    800017a6:	6442                	ld	s0,16(sp)
    800017a8:	64a2                	ld	s1,8(sp)
    800017aa:	6105                	addi	sp,sp,32
    800017ac:	8082                	ret

00000000800017ae <killed>:

int
killed(struct proc *p)
{
    800017ae:	1101                	addi	sp,sp,-32
    800017b0:	ec06                	sd	ra,24(sp)
    800017b2:	e822                	sd	s0,16(sp)
    800017b4:	e426                	sd	s1,8(sp)
    800017b6:	e04a                	sd	s2,0(sp)
    800017b8:	1000                	addi	s0,sp,32
    800017ba:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	91e080e7          	jalr	-1762(ra) # 800060da <acquire>
  k = p->killed;
    800017c4:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017c8:	8526                	mv	a0,s1
    800017ca:	00005097          	auipc	ra,0x5
    800017ce:	9c4080e7          	jalr	-1596(ra) # 8000618e <release>
  return k;
}
    800017d2:	854a                	mv	a0,s2
    800017d4:	60e2                	ld	ra,24(sp)
    800017d6:	6442                	ld	s0,16(sp)
    800017d8:	64a2                	ld	s1,8(sp)
    800017da:	6902                	ld	s2,0(sp)
    800017dc:	6105                	addi	sp,sp,32
    800017de:	8082                	ret

00000000800017e0 <wait>:
{
    800017e0:	715d                	addi	sp,sp,-80
    800017e2:	e486                	sd	ra,72(sp)
    800017e4:	e0a2                	sd	s0,64(sp)
    800017e6:	fc26                	sd	s1,56(sp)
    800017e8:	f84a                	sd	s2,48(sp)
    800017ea:	f44e                	sd	s3,40(sp)
    800017ec:	f052                	sd	s4,32(sp)
    800017ee:	ec56                	sd	s5,24(sp)
    800017f0:	e85a                	sd	s6,16(sp)
    800017f2:	e45e                	sd	s7,8(sp)
    800017f4:	e062                	sd	s8,0(sp)
    800017f6:	0880                	addi	s0,sp,80
    800017f8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017fa:	fffff097          	auipc	ra,0xfffff
    800017fe:	658080e7          	jalr	1624(ra) # 80000e52 <myproc>
    80001802:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001804:	00007517          	auipc	a0,0x7
    80001808:	0f450513          	addi	a0,a0,244 # 800088f8 <wait_lock>
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	8ce080e7          	jalr	-1842(ra) # 800060da <acquire>
    havekids = 0;
    80001814:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001816:	4a15                	li	s4,5
        havekids = 1;
    80001818:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000181a:	0000d997          	auipc	s3,0xd
    8000181e:	0f698993          	addi	s3,s3,246 # 8000e910 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001822:	00007c17          	auipc	s8,0x7
    80001826:	0d6c0c13          	addi	s8,s8,214 # 800088f8 <wait_lock>
    havekids = 0;
    8000182a:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000182c:	00007497          	auipc	s1,0x7
    80001830:	4e448493          	addi	s1,s1,1252 # 80008d10 <proc>
    80001834:	a0bd                	j	800018a2 <wait+0xc2>
          pid = pp->pid;
    80001836:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000183a:	000b0e63          	beqz	s6,80001856 <wait+0x76>
    8000183e:	4691                	li	a3,4
    80001840:	02c48613          	addi	a2,s1,44
    80001844:	85da                	mv	a1,s6
    80001846:	05093503          	ld	a0,80(s2)
    8000184a:	fffff097          	auipc	ra,0xfffff
    8000184e:	2c4080e7          	jalr	708(ra) # 80000b0e <copyout>
    80001852:	02054563          	bltz	a0,8000187c <wait+0x9c>
          freeproc(pp);
    80001856:	8526                	mv	a0,s1
    80001858:	fffff097          	auipc	ra,0xfffff
    8000185c:	7ac080e7          	jalr	1964(ra) # 80001004 <freeproc>
          release(&pp->lock);
    80001860:	8526                	mv	a0,s1
    80001862:	00005097          	auipc	ra,0x5
    80001866:	92c080e7          	jalr	-1748(ra) # 8000618e <release>
          release(&wait_lock);
    8000186a:	00007517          	auipc	a0,0x7
    8000186e:	08e50513          	addi	a0,a0,142 # 800088f8 <wait_lock>
    80001872:	00005097          	auipc	ra,0x5
    80001876:	91c080e7          	jalr	-1764(ra) # 8000618e <release>
          return pid;
    8000187a:	a0b5                	j	800018e6 <wait+0x106>
            release(&pp->lock);
    8000187c:	8526                	mv	a0,s1
    8000187e:	00005097          	auipc	ra,0x5
    80001882:	910080e7          	jalr	-1776(ra) # 8000618e <release>
            release(&wait_lock);
    80001886:	00007517          	auipc	a0,0x7
    8000188a:	07250513          	addi	a0,a0,114 # 800088f8 <wait_lock>
    8000188e:	00005097          	auipc	ra,0x5
    80001892:	900080e7          	jalr	-1792(ra) # 8000618e <release>
            return -1;
    80001896:	59fd                	li	s3,-1
    80001898:	a0b9                	j	800018e6 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000189a:	17048493          	addi	s1,s1,368
    8000189e:	03348463          	beq	s1,s3,800018c6 <wait+0xe6>
      if(pp->parent == p){
    800018a2:	7c9c                	ld	a5,56(s1)
    800018a4:	ff279be3          	bne	a5,s2,8000189a <wait+0xba>
        acquire(&pp->lock);
    800018a8:	8526                	mv	a0,s1
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	830080e7          	jalr	-2000(ra) # 800060da <acquire>
        if(pp->state == ZOMBIE){
    800018b2:	4c9c                	lw	a5,24(s1)
    800018b4:	f94781e3          	beq	a5,s4,80001836 <wait+0x56>
        release(&pp->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	8d4080e7          	jalr	-1836(ra) # 8000618e <release>
        havekids = 1;
    800018c2:	8756                	mv	a4,s5
    800018c4:	bfd9                	j	8000189a <wait+0xba>
    if(!havekids || killed(p)){
    800018c6:	c719                	beqz	a4,800018d4 <wait+0xf4>
    800018c8:	854a                	mv	a0,s2
    800018ca:	00000097          	auipc	ra,0x0
    800018ce:	ee4080e7          	jalr	-284(ra) # 800017ae <killed>
    800018d2:	c51d                	beqz	a0,80001900 <wait+0x120>
      release(&wait_lock);
    800018d4:	00007517          	auipc	a0,0x7
    800018d8:	02450513          	addi	a0,a0,36 # 800088f8 <wait_lock>
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	8b2080e7          	jalr	-1870(ra) # 8000618e <release>
      return -1;
    800018e4:	59fd                	li	s3,-1
}
    800018e6:	854e                	mv	a0,s3
    800018e8:	60a6                	ld	ra,72(sp)
    800018ea:	6406                	ld	s0,64(sp)
    800018ec:	74e2                	ld	s1,56(sp)
    800018ee:	7942                	ld	s2,48(sp)
    800018f0:	79a2                	ld	s3,40(sp)
    800018f2:	7a02                	ld	s4,32(sp)
    800018f4:	6ae2                	ld	s5,24(sp)
    800018f6:	6b42                	ld	s6,16(sp)
    800018f8:	6ba2                	ld	s7,8(sp)
    800018fa:	6c02                	ld	s8,0(sp)
    800018fc:	6161                	addi	sp,sp,80
    800018fe:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001900:	85e2                	mv	a1,s8
    80001902:	854a                	mv	a0,s2
    80001904:	00000097          	auipc	ra,0x0
    80001908:	c02080e7          	jalr	-1022(ra) # 80001506 <sleep>
    havekids = 0;
    8000190c:	bf39                	j	8000182a <wait+0x4a>

000000008000190e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000190e:	7179                	addi	sp,sp,-48
    80001910:	f406                	sd	ra,40(sp)
    80001912:	f022                	sd	s0,32(sp)
    80001914:	ec26                	sd	s1,24(sp)
    80001916:	e84a                	sd	s2,16(sp)
    80001918:	e44e                	sd	s3,8(sp)
    8000191a:	e052                	sd	s4,0(sp)
    8000191c:	1800                	addi	s0,sp,48
    8000191e:	84aa                	mv	s1,a0
    80001920:	892e                	mv	s2,a1
    80001922:	89b2                	mv	s3,a2
    80001924:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	52c080e7          	jalr	1324(ra) # 80000e52 <myproc>
  if(user_dst){
    8000192e:	c08d                	beqz	s1,80001950 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001930:	86d2                	mv	a3,s4
    80001932:	864e                	mv	a2,s3
    80001934:	85ca                	mv	a1,s2
    80001936:	6928                	ld	a0,80(a0)
    80001938:	fffff097          	auipc	ra,0xfffff
    8000193c:	1d6080e7          	jalr	470(ra) # 80000b0e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001940:	70a2                	ld	ra,40(sp)
    80001942:	7402                	ld	s0,32(sp)
    80001944:	64e2                	ld	s1,24(sp)
    80001946:	6942                	ld	s2,16(sp)
    80001948:	69a2                	ld	s3,8(sp)
    8000194a:	6a02                	ld	s4,0(sp)
    8000194c:	6145                	addi	sp,sp,48
    8000194e:	8082                	ret
    memmove((char *)dst, src, len);
    80001950:	000a061b          	sext.w	a2,s4
    80001954:	85ce                	mv	a1,s3
    80001956:	854a                	mv	a0,s2
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	87c080e7          	jalr	-1924(ra) # 800001d4 <memmove>
    return 0;
    80001960:	8526                	mv	a0,s1
    80001962:	bff9                	j	80001940 <either_copyout+0x32>

0000000080001964 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001964:	7179                	addi	sp,sp,-48
    80001966:	f406                	sd	ra,40(sp)
    80001968:	f022                	sd	s0,32(sp)
    8000196a:	ec26                	sd	s1,24(sp)
    8000196c:	e84a                	sd	s2,16(sp)
    8000196e:	e44e                	sd	s3,8(sp)
    80001970:	e052                	sd	s4,0(sp)
    80001972:	1800                	addi	s0,sp,48
    80001974:	892a                	mv	s2,a0
    80001976:	84ae                	mv	s1,a1
    80001978:	89b2                	mv	s3,a2
    8000197a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000197c:	fffff097          	auipc	ra,0xfffff
    80001980:	4d6080e7          	jalr	1238(ra) # 80000e52 <myproc>
  if(user_src){
    80001984:	c08d                	beqz	s1,800019a6 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001986:	86d2                	mv	a3,s4
    80001988:	864e                	mv	a2,s3
    8000198a:	85ca                	mv	a1,s2
    8000198c:	6928                	ld	a0,80(a0)
    8000198e:	fffff097          	auipc	ra,0xfffff
    80001992:	20c080e7          	jalr	524(ra) # 80000b9a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001996:	70a2                	ld	ra,40(sp)
    80001998:	7402                	ld	s0,32(sp)
    8000199a:	64e2                	ld	s1,24(sp)
    8000199c:	6942                	ld	s2,16(sp)
    8000199e:	69a2                	ld	s3,8(sp)
    800019a0:	6a02                	ld	s4,0(sp)
    800019a2:	6145                	addi	sp,sp,48
    800019a4:	8082                	ret
    memmove(dst, (char*)src, len);
    800019a6:	000a061b          	sext.w	a2,s4
    800019aa:	85ce                	mv	a1,s3
    800019ac:	854a                	mv	a0,s2
    800019ae:	fffff097          	auipc	ra,0xfffff
    800019b2:	826080e7          	jalr	-2010(ra) # 800001d4 <memmove>
    return 0;
    800019b6:	8526                	mv	a0,s1
    800019b8:	bff9                	j	80001996 <either_copyin+0x32>

00000000800019ba <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019ba:	715d                	addi	sp,sp,-80
    800019bc:	e486                	sd	ra,72(sp)
    800019be:	e0a2                	sd	s0,64(sp)
    800019c0:	fc26                	sd	s1,56(sp)
    800019c2:	f84a                	sd	s2,48(sp)
    800019c4:	f44e                	sd	s3,40(sp)
    800019c6:	f052                	sd	s4,32(sp)
    800019c8:	ec56                	sd	s5,24(sp)
    800019ca:	e85a                	sd	s6,16(sp)
    800019cc:	e45e                	sd	s7,8(sp)
    800019ce:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019d0:	00006517          	auipc	a0,0x6
    800019d4:	67850513          	addi	a0,a0,1656 # 80008048 <etext+0x48>
    800019d8:	00004097          	auipc	ra,0x4
    800019dc:	210080e7          	jalr	528(ra) # 80005be8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019e0:	00007497          	auipc	s1,0x7
    800019e4:	48848493          	addi	s1,s1,1160 # 80008e68 <proc+0x158>
    800019e8:	0000d917          	auipc	s2,0xd
    800019ec:	08090913          	addi	s2,s2,128 # 8000ea68 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019f2:	00007997          	auipc	s3,0x7
    800019f6:	80e98993          	addi	s3,s3,-2034 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019fa:	00007a97          	auipc	s5,0x7
    800019fe:	80ea8a93          	addi	s5,s5,-2034 # 80008208 <etext+0x208>
    printf("\n");
    80001a02:	00006a17          	auipc	s4,0x6
    80001a06:	646a0a13          	addi	s4,s4,1606 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a0a:	00007b97          	auipc	s7,0x7
    80001a0e:	83eb8b93          	addi	s7,s7,-1986 # 80008248 <states.0>
    80001a12:	a00d                	j	80001a34 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a14:	ed86a583          	lw	a1,-296(a3)
    80001a18:	8556                	mv	a0,s5
    80001a1a:	00004097          	auipc	ra,0x4
    80001a1e:	1ce080e7          	jalr	462(ra) # 80005be8 <printf>
    printf("\n");
    80001a22:	8552                	mv	a0,s4
    80001a24:	00004097          	auipc	ra,0x4
    80001a28:	1c4080e7          	jalr	452(ra) # 80005be8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a2c:	17048493          	addi	s1,s1,368
    80001a30:	03248163          	beq	s1,s2,80001a52 <procdump+0x98>
    if(p->state == UNUSED)
    80001a34:	86a6                	mv	a3,s1
    80001a36:	ec04a783          	lw	a5,-320(s1)
    80001a3a:	dbed                	beqz	a5,80001a2c <procdump+0x72>
      state = "???";
    80001a3c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3e:	fcfb6be3          	bltu	s6,a5,80001a14 <procdump+0x5a>
    80001a42:	1782                	slli	a5,a5,0x20
    80001a44:	9381                	srli	a5,a5,0x20
    80001a46:	078e                	slli	a5,a5,0x3
    80001a48:	97de                	add	a5,a5,s7
    80001a4a:	6390                	ld	a2,0(a5)
    80001a4c:	f661                	bnez	a2,80001a14 <procdump+0x5a>
      state = "???";
    80001a4e:	864e                	mv	a2,s3
    80001a50:	b7d1                	j	80001a14 <procdump+0x5a>
  }
}
    80001a52:	60a6                	ld	ra,72(sp)
    80001a54:	6406                	ld	s0,64(sp)
    80001a56:	74e2                	ld	s1,56(sp)
    80001a58:	7942                	ld	s2,48(sp)
    80001a5a:	79a2                	ld	s3,40(sp)
    80001a5c:	7a02                	ld	s4,32(sp)
    80001a5e:	6ae2                	ld	s5,24(sp)
    80001a60:	6b42                	ld	s6,16(sp)
    80001a62:	6ba2                	ld	s7,8(sp)
    80001a64:	6161                	addi	sp,sp,80
    80001a66:	8082                	ret

0000000080001a68 <swtch>:
    80001a68:	00153023          	sd	ra,0(a0)
    80001a6c:	00253423          	sd	sp,8(a0)
    80001a70:	e900                	sd	s0,16(a0)
    80001a72:	ed04                	sd	s1,24(a0)
    80001a74:	03253023          	sd	s2,32(a0)
    80001a78:	03353423          	sd	s3,40(a0)
    80001a7c:	03453823          	sd	s4,48(a0)
    80001a80:	03553c23          	sd	s5,56(a0)
    80001a84:	05653023          	sd	s6,64(a0)
    80001a88:	05753423          	sd	s7,72(a0)
    80001a8c:	05853823          	sd	s8,80(a0)
    80001a90:	05953c23          	sd	s9,88(a0)
    80001a94:	07a53023          	sd	s10,96(a0)
    80001a98:	07b53423          	sd	s11,104(a0)
    80001a9c:	0005b083          	ld	ra,0(a1)
    80001aa0:	0085b103          	ld	sp,8(a1)
    80001aa4:	6980                	ld	s0,16(a1)
    80001aa6:	6d84                	ld	s1,24(a1)
    80001aa8:	0205b903          	ld	s2,32(a1)
    80001aac:	0285b983          	ld	s3,40(a1)
    80001ab0:	0305ba03          	ld	s4,48(a1)
    80001ab4:	0385ba83          	ld	s5,56(a1)
    80001ab8:	0405bb03          	ld	s6,64(a1)
    80001abc:	0485bb83          	ld	s7,72(a1)
    80001ac0:	0505bc03          	ld	s8,80(a1)
    80001ac4:	0585bc83          	ld	s9,88(a1)
    80001ac8:	0605bd03          	ld	s10,96(a1)
    80001acc:	0685bd83          	ld	s11,104(a1)
    80001ad0:	8082                	ret

0000000080001ad2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ad2:	1141                	addi	sp,sp,-16
    80001ad4:	e406                	sd	ra,8(sp)
    80001ad6:	e022                	sd	s0,0(sp)
    80001ad8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ada:	00006597          	auipc	a1,0x6
    80001ade:	79e58593          	addi	a1,a1,1950 # 80008278 <states.0+0x30>
    80001ae2:	0000d517          	auipc	a0,0xd
    80001ae6:	e2e50513          	addi	a0,a0,-466 # 8000e910 <tickslock>
    80001aea:	00004097          	auipc	ra,0x4
    80001aee:	560080e7          	jalr	1376(ra) # 8000604a <initlock>
}
    80001af2:	60a2                	ld	ra,8(sp)
    80001af4:	6402                	ld	s0,0(sp)
    80001af6:	0141                	addi	sp,sp,16
    80001af8:	8082                	ret

0000000080001afa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001afa:	1141                	addi	sp,sp,-16
    80001afc:	e422                	sd	s0,8(sp)
    80001afe:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b00:	00003797          	auipc	a5,0x3
    80001b04:	4d078793          	addi	a5,a5,1232 # 80004fd0 <kernelvec>
    80001b08:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b0c:	6422                	ld	s0,8(sp)
    80001b0e:	0141                	addi	sp,sp,16
    80001b10:	8082                	ret

0000000080001b12 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b12:	1141                	addi	sp,sp,-16
    80001b14:	e406                	sd	ra,8(sp)
    80001b16:	e022                	sd	s0,0(sp)
    80001b18:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b1a:	fffff097          	auipc	ra,0xfffff
    80001b1e:	338080e7          	jalr	824(ra) # 80000e52 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b26:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b28:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b2c:	00005617          	auipc	a2,0x5
    80001b30:	4d460613          	addi	a2,a2,1236 # 80007000 <_trampoline>
    80001b34:	00005697          	auipc	a3,0x5
    80001b38:	4cc68693          	addi	a3,a3,1228 # 80007000 <_trampoline>
    80001b3c:	8e91                	sub	a3,a3,a2
    80001b3e:	040007b7          	lui	a5,0x4000
    80001b42:	17fd                	addi	a5,a5,-1
    80001b44:	07b2                	slli	a5,a5,0xc
    80001b46:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b48:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b4c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b4e:	180026f3          	csrr	a3,satp
    80001b52:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b54:	6d38                	ld	a4,88(a0)
    80001b56:	6134                	ld	a3,64(a0)
    80001b58:	6585                	lui	a1,0x1
    80001b5a:	96ae                	add	a3,a3,a1
    80001b5c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b5e:	6d38                	ld	a4,88(a0)
    80001b60:	00000697          	auipc	a3,0x0
    80001b64:	13068693          	addi	a3,a3,304 # 80001c90 <usertrap>
    80001b68:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b6a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b6c:	8692                	mv	a3,tp
    80001b6e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b70:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b74:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b78:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b7c:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b80:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b82:	6f18                	ld	a4,24(a4)
    80001b84:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b88:	6928                	ld	a0,80(a0)
    80001b8a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b8c:	00005717          	auipc	a4,0x5
    80001b90:	51070713          	addi	a4,a4,1296 # 8000709c <userret>
    80001b94:	8f11                	sub	a4,a4,a2
    80001b96:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b98:	577d                	li	a4,-1
    80001b9a:	177e                	slli	a4,a4,0x3f
    80001b9c:	8d59                	or	a0,a0,a4
    80001b9e:	9782                	jalr	a5
}
    80001ba0:	60a2                	ld	ra,8(sp)
    80001ba2:	6402                	ld	s0,0(sp)
    80001ba4:	0141                	addi	sp,sp,16
    80001ba6:	8082                	ret

0000000080001ba8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ba8:	1101                	addi	sp,sp,-32
    80001baa:	ec06                	sd	ra,24(sp)
    80001bac:	e822                	sd	s0,16(sp)
    80001bae:	e426                	sd	s1,8(sp)
    80001bb0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bb2:	0000d497          	auipc	s1,0xd
    80001bb6:	d5e48493          	addi	s1,s1,-674 # 8000e910 <tickslock>
    80001bba:	8526                	mv	a0,s1
    80001bbc:	00004097          	auipc	ra,0x4
    80001bc0:	51e080e7          	jalr	1310(ra) # 800060da <acquire>
  ticks++;
    80001bc4:	00007517          	auipc	a0,0x7
    80001bc8:	ce450513          	addi	a0,a0,-796 # 800088a8 <ticks>
    80001bcc:	411c                	lw	a5,0(a0)
    80001bce:	2785                	addiw	a5,a5,1
    80001bd0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bd2:	00000097          	auipc	ra,0x0
    80001bd6:	998080e7          	jalr	-1640(ra) # 8000156a <wakeup>
  release(&tickslock);
    80001bda:	8526                	mv	a0,s1
    80001bdc:	00004097          	auipc	ra,0x4
    80001be0:	5b2080e7          	jalr	1458(ra) # 8000618e <release>
}
    80001be4:	60e2                	ld	ra,24(sp)
    80001be6:	6442                	ld	s0,16(sp)
    80001be8:	64a2                	ld	s1,8(sp)
    80001bea:	6105                	addi	sp,sp,32
    80001bec:	8082                	ret

0000000080001bee <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001bee:	1101                	addi	sp,sp,-32
    80001bf0:	ec06                	sd	ra,24(sp)
    80001bf2:	e822                	sd	s0,16(sp)
    80001bf4:	e426                	sd	s1,8(sp)
    80001bf6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bf8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bfc:	00074d63          	bltz	a4,80001c16 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c00:	57fd                	li	a5,-1
    80001c02:	17fe                	slli	a5,a5,0x3f
    80001c04:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c06:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c08:	06f70363          	beq	a4,a5,80001c6e <devintr+0x80>
  }
}
    80001c0c:	60e2                	ld	ra,24(sp)
    80001c0e:	6442                	ld	s0,16(sp)
    80001c10:	64a2                	ld	s1,8(sp)
    80001c12:	6105                	addi	sp,sp,32
    80001c14:	8082                	ret
     (scause & 0xff) == 9){
    80001c16:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c1a:	46a5                	li	a3,9
    80001c1c:	fed792e3          	bne	a5,a3,80001c00 <devintr+0x12>
    int irq = plic_claim();
    80001c20:	00003097          	auipc	ra,0x3
    80001c24:	4b8080e7          	jalr	1208(ra) # 800050d8 <plic_claim>
    80001c28:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c2a:	47a9                	li	a5,10
    80001c2c:	02f50763          	beq	a0,a5,80001c5a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c30:	4785                	li	a5,1
    80001c32:	02f50963          	beq	a0,a5,80001c64 <devintr+0x76>
    return 1;
    80001c36:	4505                	li	a0,1
    } else if(irq){
    80001c38:	d8f1                	beqz	s1,80001c0c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c3a:	85a6                	mv	a1,s1
    80001c3c:	00006517          	auipc	a0,0x6
    80001c40:	64450513          	addi	a0,a0,1604 # 80008280 <states.0+0x38>
    80001c44:	00004097          	auipc	ra,0x4
    80001c48:	fa4080e7          	jalr	-92(ra) # 80005be8 <printf>
      plic_complete(irq);
    80001c4c:	8526                	mv	a0,s1
    80001c4e:	00003097          	auipc	ra,0x3
    80001c52:	4ae080e7          	jalr	1198(ra) # 800050fc <plic_complete>
    return 1;
    80001c56:	4505                	li	a0,1
    80001c58:	bf55                	j	80001c0c <devintr+0x1e>
      uartintr();
    80001c5a:	00004097          	auipc	ra,0x4
    80001c5e:	3a0080e7          	jalr	928(ra) # 80005ffa <uartintr>
    80001c62:	b7ed                	j	80001c4c <devintr+0x5e>
      virtio_disk_intr();
    80001c64:	00004097          	auipc	ra,0x4
    80001c68:	964080e7          	jalr	-1692(ra) # 800055c8 <virtio_disk_intr>
    80001c6c:	b7c5                	j	80001c4c <devintr+0x5e>
    if(cpuid() == 0){
    80001c6e:	fffff097          	auipc	ra,0xfffff
    80001c72:	1b8080e7          	jalr	440(ra) # 80000e26 <cpuid>
    80001c76:	c901                	beqz	a0,80001c86 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c78:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c7c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c7e:	14479073          	csrw	sip,a5
    return 2;
    80001c82:	4509                	li	a0,2
    80001c84:	b761                	j	80001c0c <devintr+0x1e>
      clockintr();
    80001c86:	00000097          	auipc	ra,0x0
    80001c8a:	f22080e7          	jalr	-222(ra) # 80001ba8 <clockintr>
    80001c8e:	b7ed                	j	80001c78 <devintr+0x8a>

0000000080001c90 <usertrap>:
{
    80001c90:	1101                	addi	sp,sp,-32
    80001c92:	ec06                	sd	ra,24(sp)
    80001c94:	e822                	sd	s0,16(sp)
    80001c96:	e426                	sd	s1,8(sp)
    80001c98:	e04a                	sd	s2,0(sp)
    80001c9a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c9c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ca0:	1007f793          	andi	a5,a5,256
    80001ca4:	e3b1                	bnez	a5,80001ce8 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca6:	00003797          	auipc	a5,0x3
    80001caa:	32a78793          	addi	a5,a5,810 # 80004fd0 <kernelvec>
    80001cae:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cb2:	fffff097          	auipc	ra,0xfffff
    80001cb6:	1a0080e7          	jalr	416(ra) # 80000e52 <myproc>
    80001cba:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cbc:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cbe:	14102773          	csrr	a4,sepc
    80001cc2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cc4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cc8:	47a1                	li	a5,8
    80001cca:	02f70763          	beq	a4,a5,80001cf8 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001cce:	00000097          	auipc	ra,0x0
    80001cd2:	f20080e7          	jalr	-224(ra) # 80001bee <devintr>
    80001cd6:	892a                	mv	s2,a0
    80001cd8:	c151                	beqz	a0,80001d5c <usertrap+0xcc>
  if(killed(p))
    80001cda:	8526                	mv	a0,s1
    80001cdc:	00000097          	auipc	ra,0x0
    80001ce0:	ad2080e7          	jalr	-1326(ra) # 800017ae <killed>
    80001ce4:	c929                	beqz	a0,80001d36 <usertrap+0xa6>
    80001ce6:	a099                	j	80001d2c <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001ce8:	00006517          	auipc	a0,0x6
    80001cec:	5b850513          	addi	a0,a0,1464 # 800082a0 <states.0+0x58>
    80001cf0:	00004097          	auipc	ra,0x4
    80001cf4:	eae080e7          	jalr	-338(ra) # 80005b9e <panic>
    if(killed(p))
    80001cf8:	00000097          	auipc	ra,0x0
    80001cfc:	ab6080e7          	jalr	-1354(ra) # 800017ae <killed>
    80001d00:	e921                	bnez	a0,80001d50 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d02:	6cb8                	ld	a4,88(s1)
    80001d04:	6f1c                	ld	a5,24(a4)
    80001d06:	0791                	addi	a5,a5,4
    80001d08:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d0e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d12:	10079073          	csrw	sstatus,a5
    syscall();
    80001d16:	00000097          	auipc	ra,0x0
    80001d1a:	2d4080e7          	jalr	724(ra) # 80001fea <syscall>
  if(killed(p))
    80001d1e:	8526                	mv	a0,s1
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	a8e080e7          	jalr	-1394(ra) # 800017ae <killed>
    80001d28:	c911                	beqz	a0,80001d3c <usertrap+0xac>
    80001d2a:	4901                	li	s2,0
    exit(-1);
    80001d2c:	557d                	li	a0,-1
    80001d2e:	00000097          	auipc	ra,0x0
    80001d32:	90c080e7          	jalr	-1780(ra) # 8000163a <exit>
  if(which_dev == 2)
    80001d36:	4789                	li	a5,2
    80001d38:	04f90f63          	beq	s2,a5,80001d96 <usertrap+0x106>
  usertrapret();
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	dd6080e7          	jalr	-554(ra) # 80001b12 <usertrapret>
}
    80001d44:	60e2                	ld	ra,24(sp)
    80001d46:	6442                	ld	s0,16(sp)
    80001d48:	64a2                	ld	s1,8(sp)
    80001d4a:	6902                	ld	s2,0(sp)
    80001d4c:	6105                	addi	sp,sp,32
    80001d4e:	8082                	ret
      exit(-1);
    80001d50:	557d                	li	a0,-1
    80001d52:	00000097          	auipc	ra,0x0
    80001d56:	8e8080e7          	jalr	-1816(ra) # 8000163a <exit>
    80001d5a:	b765                	j	80001d02 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d5c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d60:	5890                	lw	a2,48(s1)
    80001d62:	00006517          	auipc	a0,0x6
    80001d66:	55e50513          	addi	a0,a0,1374 # 800082c0 <states.0+0x78>
    80001d6a:	00004097          	auipc	ra,0x4
    80001d6e:	e7e080e7          	jalr	-386(ra) # 80005be8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d72:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d76:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d7a:	00006517          	auipc	a0,0x6
    80001d7e:	57650513          	addi	a0,a0,1398 # 800082f0 <states.0+0xa8>
    80001d82:	00004097          	auipc	ra,0x4
    80001d86:	e66080e7          	jalr	-410(ra) # 80005be8 <printf>
    setkilled(p);
    80001d8a:	8526                	mv	a0,s1
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	9f6080e7          	jalr	-1546(ra) # 80001782 <setkilled>
    80001d94:	b769                	j	80001d1e <usertrap+0x8e>
    yield();
    80001d96:	fffff097          	auipc	ra,0xfffff
    80001d9a:	734080e7          	jalr	1844(ra) # 800014ca <yield>
    80001d9e:	bf79                	j	80001d3c <usertrap+0xac>

0000000080001da0 <kerneltrap>:
{
    80001da0:	7179                	addi	sp,sp,-48
    80001da2:	f406                	sd	ra,40(sp)
    80001da4:	f022                	sd	s0,32(sp)
    80001da6:	ec26                	sd	s1,24(sp)
    80001da8:	e84a                	sd	s2,16(sp)
    80001daa:	e44e                	sd	s3,8(sp)
    80001dac:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dae:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dba:	1004f793          	andi	a5,s1,256
    80001dbe:	cb85                	beqz	a5,80001dee <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dc4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dc6:	ef85                	bnez	a5,80001dfe <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dc8:	00000097          	auipc	ra,0x0
    80001dcc:	e26080e7          	jalr	-474(ra) # 80001bee <devintr>
    80001dd0:	cd1d                	beqz	a0,80001e0e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dd2:	4789                	li	a5,2
    80001dd4:	06f50a63          	beq	a0,a5,80001e48 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dd8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ddc:	10049073          	csrw	sstatus,s1
}
    80001de0:	70a2                	ld	ra,40(sp)
    80001de2:	7402                	ld	s0,32(sp)
    80001de4:	64e2                	ld	s1,24(sp)
    80001de6:	6942                	ld	s2,16(sp)
    80001de8:	69a2                	ld	s3,8(sp)
    80001dea:	6145                	addi	sp,sp,48
    80001dec:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dee:	00006517          	auipc	a0,0x6
    80001df2:	52250513          	addi	a0,a0,1314 # 80008310 <states.0+0xc8>
    80001df6:	00004097          	auipc	ra,0x4
    80001dfa:	da8080e7          	jalr	-600(ra) # 80005b9e <panic>
    panic("kerneltrap: interrupts enabled");
    80001dfe:	00006517          	auipc	a0,0x6
    80001e02:	53a50513          	addi	a0,a0,1338 # 80008338 <states.0+0xf0>
    80001e06:	00004097          	auipc	ra,0x4
    80001e0a:	d98080e7          	jalr	-616(ra) # 80005b9e <panic>
    printf("scause %p\n", scause);
    80001e0e:	85ce                	mv	a1,s3
    80001e10:	00006517          	auipc	a0,0x6
    80001e14:	54850513          	addi	a0,a0,1352 # 80008358 <states.0+0x110>
    80001e18:	00004097          	auipc	ra,0x4
    80001e1c:	dd0080e7          	jalr	-560(ra) # 80005be8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e20:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e24:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e28:	00006517          	auipc	a0,0x6
    80001e2c:	54050513          	addi	a0,a0,1344 # 80008368 <states.0+0x120>
    80001e30:	00004097          	auipc	ra,0x4
    80001e34:	db8080e7          	jalr	-584(ra) # 80005be8 <printf>
    panic("kerneltrap");
    80001e38:	00006517          	auipc	a0,0x6
    80001e3c:	54850513          	addi	a0,a0,1352 # 80008380 <states.0+0x138>
    80001e40:	00004097          	auipc	ra,0x4
    80001e44:	d5e080e7          	jalr	-674(ra) # 80005b9e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e48:	fffff097          	auipc	ra,0xfffff
    80001e4c:	00a080e7          	jalr	10(ra) # 80000e52 <myproc>
    80001e50:	d541                	beqz	a0,80001dd8 <kerneltrap+0x38>
    80001e52:	fffff097          	auipc	ra,0xfffff
    80001e56:	000080e7          	jalr	ra # 80000e52 <myproc>
    80001e5a:	4d18                	lw	a4,24(a0)
    80001e5c:	4791                	li	a5,4
    80001e5e:	f6f71de3          	bne	a4,a5,80001dd8 <kerneltrap+0x38>
    yield();
    80001e62:	fffff097          	auipc	ra,0xfffff
    80001e66:	668080e7          	jalr	1640(ra) # 800014ca <yield>
    80001e6a:	b7bd                	j	80001dd8 <kerneltrap+0x38>

0000000080001e6c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e6c:	1101                	addi	sp,sp,-32
    80001e6e:	ec06                	sd	ra,24(sp)
    80001e70:	e822                	sd	s0,16(sp)
    80001e72:	e426                	sd	s1,8(sp)
    80001e74:	1000                	addi	s0,sp,32
    80001e76:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	fda080e7          	jalr	-38(ra) # 80000e52 <myproc>
  switch (n) {
    80001e80:	4795                	li	a5,5
    80001e82:	0497e163          	bltu	a5,s1,80001ec4 <argraw+0x58>
    80001e86:	048a                	slli	s1,s1,0x2
    80001e88:	00006717          	auipc	a4,0x6
    80001e8c:	53070713          	addi	a4,a4,1328 # 800083b8 <states.0+0x170>
    80001e90:	94ba                	add	s1,s1,a4
    80001e92:	409c                	lw	a5,0(s1)
    80001e94:	97ba                	add	a5,a5,a4
    80001e96:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e98:	6d3c                	ld	a5,88(a0)
    80001e9a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e9c:	60e2                	ld	ra,24(sp)
    80001e9e:	6442                	ld	s0,16(sp)
    80001ea0:	64a2                	ld	s1,8(sp)
    80001ea2:	6105                	addi	sp,sp,32
    80001ea4:	8082                	ret
    return p->trapframe->a1;
    80001ea6:	6d3c                	ld	a5,88(a0)
    80001ea8:	7fa8                	ld	a0,120(a5)
    80001eaa:	bfcd                	j	80001e9c <argraw+0x30>
    return p->trapframe->a2;
    80001eac:	6d3c                	ld	a5,88(a0)
    80001eae:	63c8                	ld	a0,128(a5)
    80001eb0:	b7f5                	j	80001e9c <argraw+0x30>
    return p->trapframe->a3;
    80001eb2:	6d3c                	ld	a5,88(a0)
    80001eb4:	67c8                	ld	a0,136(a5)
    80001eb6:	b7dd                	j	80001e9c <argraw+0x30>
    return p->trapframe->a4;
    80001eb8:	6d3c                	ld	a5,88(a0)
    80001eba:	6bc8                	ld	a0,144(a5)
    80001ebc:	b7c5                	j	80001e9c <argraw+0x30>
    return p->trapframe->a5;
    80001ebe:	6d3c                	ld	a5,88(a0)
    80001ec0:	6fc8                	ld	a0,152(a5)
    80001ec2:	bfe9                	j	80001e9c <argraw+0x30>
  panic("argraw");
    80001ec4:	00006517          	auipc	a0,0x6
    80001ec8:	4cc50513          	addi	a0,a0,1228 # 80008390 <states.0+0x148>
    80001ecc:	00004097          	auipc	ra,0x4
    80001ed0:	cd2080e7          	jalr	-814(ra) # 80005b9e <panic>

0000000080001ed4 <fetchaddr>:
{
    80001ed4:	1101                	addi	sp,sp,-32
    80001ed6:	ec06                	sd	ra,24(sp)
    80001ed8:	e822                	sd	s0,16(sp)
    80001eda:	e426                	sd	s1,8(sp)
    80001edc:	e04a                	sd	s2,0(sp)
    80001ede:	1000                	addi	s0,sp,32
    80001ee0:	84aa                	mv	s1,a0
    80001ee2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	f6e080e7          	jalr	-146(ra) # 80000e52 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001eec:	653c                	ld	a5,72(a0)
    80001eee:	02f4f863          	bgeu	s1,a5,80001f1e <fetchaddr+0x4a>
    80001ef2:	00848713          	addi	a4,s1,8
    80001ef6:	02e7e663          	bltu	a5,a4,80001f22 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001efa:	46a1                	li	a3,8
    80001efc:	8626                	mv	a2,s1
    80001efe:	85ca                	mv	a1,s2
    80001f00:	6928                	ld	a0,80(a0)
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	c98080e7          	jalr	-872(ra) # 80000b9a <copyin>
    80001f0a:	00a03533          	snez	a0,a0
    80001f0e:	40a00533          	neg	a0,a0
}
    80001f12:	60e2                	ld	ra,24(sp)
    80001f14:	6442                	ld	s0,16(sp)
    80001f16:	64a2                	ld	s1,8(sp)
    80001f18:	6902                	ld	s2,0(sp)
    80001f1a:	6105                	addi	sp,sp,32
    80001f1c:	8082                	ret
    return -1;
    80001f1e:	557d                	li	a0,-1
    80001f20:	bfcd                	j	80001f12 <fetchaddr+0x3e>
    80001f22:	557d                	li	a0,-1
    80001f24:	b7fd                	j	80001f12 <fetchaddr+0x3e>

0000000080001f26 <fetchstr>:
{
    80001f26:	7179                	addi	sp,sp,-48
    80001f28:	f406                	sd	ra,40(sp)
    80001f2a:	f022                	sd	s0,32(sp)
    80001f2c:	ec26                	sd	s1,24(sp)
    80001f2e:	e84a                	sd	s2,16(sp)
    80001f30:	e44e                	sd	s3,8(sp)
    80001f32:	1800                	addi	s0,sp,48
    80001f34:	892a                	mv	s2,a0
    80001f36:	84ae                	mv	s1,a1
    80001f38:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	f18080e7          	jalr	-232(ra) # 80000e52 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f42:	86ce                	mv	a3,s3
    80001f44:	864a                	mv	a2,s2
    80001f46:	85a6                	mv	a1,s1
    80001f48:	6928                	ld	a0,80(a0)
    80001f4a:	fffff097          	auipc	ra,0xfffff
    80001f4e:	cde080e7          	jalr	-802(ra) # 80000c28 <copyinstr>
    80001f52:	00054e63          	bltz	a0,80001f6e <fetchstr+0x48>
  return strlen(buf);
    80001f56:	8526                	mv	a0,s1
    80001f58:	ffffe097          	auipc	ra,0xffffe
    80001f5c:	39c080e7          	jalr	924(ra) # 800002f4 <strlen>
}
    80001f60:	70a2                	ld	ra,40(sp)
    80001f62:	7402                	ld	s0,32(sp)
    80001f64:	64e2                	ld	s1,24(sp)
    80001f66:	6942                	ld	s2,16(sp)
    80001f68:	69a2                	ld	s3,8(sp)
    80001f6a:	6145                	addi	sp,sp,48
    80001f6c:	8082                	ret
    return -1;
    80001f6e:	557d                	li	a0,-1
    80001f70:	bfc5                	j	80001f60 <fetchstr+0x3a>

0000000080001f72 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f72:	1101                	addi	sp,sp,-32
    80001f74:	ec06                	sd	ra,24(sp)
    80001f76:	e822                	sd	s0,16(sp)
    80001f78:	e426                	sd	s1,8(sp)
    80001f7a:	1000                	addi	s0,sp,32
    80001f7c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f7e:	00000097          	auipc	ra,0x0
    80001f82:	eee080e7          	jalr	-274(ra) # 80001e6c <argraw>
    80001f86:	c088                	sw	a0,0(s1)
}
    80001f88:	60e2                	ld	ra,24(sp)
    80001f8a:	6442                	ld	s0,16(sp)
    80001f8c:	64a2                	ld	s1,8(sp)
    80001f8e:	6105                	addi	sp,sp,32
    80001f90:	8082                	ret

0000000080001f92 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f92:	1101                	addi	sp,sp,-32
    80001f94:	ec06                	sd	ra,24(sp)
    80001f96:	e822                	sd	s0,16(sp)
    80001f98:	e426                	sd	s1,8(sp)
    80001f9a:	1000                	addi	s0,sp,32
    80001f9c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f9e:	00000097          	auipc	ra,0x0
    80001fa2:	ece080e7          	jalr	-306(ra) # 80001e6c <argraw>
    80001fa6:	e088                	sd	a0,0(s1)
}
    80001fa8:	60e2                	ld	ra,24(sp)
    80001faa:	6442                	ld	s0,16(sp)
    80001fac:	64a2                	ld	s1,8(sp)
    80001fae:	6105                	addi	sp,sp,32
    80001fb0:	8082                	ret

0000000080001fb2 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fb2:	7179                	addi	sp,sp,-48
    80001fb4:	f406                	sd	ra,40(sp)
    80001fb6:	f022                	sd	s0,32(sp)
    80001fb8:	ec26                	sd	s1,24(sp)
    80001fba:	e84a                	sd	s2,16(sp)
    80001fbc:	1800                	addi	s0,sp,48
    80001fbe:	84ae                	mv	s1,a1
    80001fc0:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001fc2:	fd840593          	addi	a1,s0,-40
    80001fc6:	00000097          	auipc	ra,0x0
    80001fca:	fcc080e7          	jalr	-52(ra) # 80001f92 <argaddr>
  return fetchstr(addr, buf, max);
    80001fce:	864a                	mv	a2,s2
    80001fd0:	85a6                	mv	a1,s1
    80001fd2:	fd843503          	ld	a0,-40(s0)
    80001fd6:	00000097          	auipc	ra,0x0
    80001fda:	f50080e7          	jalr	-176(ra) # 80001f26 <fetchstr>
}
    80001fde:	70a2                	ld	ra,40(sp)
    80001fe0:	7402                	ld	s0,32(sp)
    80001fe2:	64e2                	ld	s1,24(sp)
    80001fe4:	6942                	ld	s2,16(sp)
    80001fe6:	6145                	addi	sp,sp,48
    80001fe8:	8082                	ret

0000000080001fea <syscall>:
//[SYS_getprocessinfo]  sys_getprocessinfo,
};

void
syscall(void)
{
    80001fea:	1101                	addi	sp,sp,-32
    80001fec:	ec06                	sd	ra,24(sp)
    80001fee:	e822                	sd	s0,16(sp)
    80001ff0:	e426                	sd	s1,8(sp)
    80001ff2:	e04a                	sd	s2,0(sp)
    80001ff4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001ff6:	fffff097          	auipc	ra,0xfffff
    80001ffa:	e5c080e7          	jalr	-420(ra) # 80000e52 <myproc>
    80001ffe:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002000:	05853903          	ld	s2,88(a0)
    80002004:	0a893783          	ld	a5,168(s2)
    80002008:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000200c:	37fd                	addiw	a5,a5,-1
    8000200e:	4751                	li	a4,20
    80002010:	00f76f63          	bltu	a4,a5,8000202e <syscall+0x44>
    80002014:	00369713          	slli	a4,a3,0x3
    80002018:	00006797          	auipc	a5,0x6
    8000201c:	3b878793          	addi	a5,a5,952 # 800083d0 <syscalls>
    80002020:	97ba                	add	a5,a5,a4
    80002022:	639c                	ld	a5,0(a5)
    80002024:	c789                	beqz	a5,8000202e <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002026:	9782                	jalr	a5
    80002028:	06a93823          	sd	a0,112(s2)
    8000202c:	a839                	j	8000204a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000202e:	15848613          	addi	a2,s1,344
    80002032:	588c                	lw	a1,48(s1)
    80002034:	00006517          	auipc	a0,0x6
    80002038:	36450513          	addi	a0,a0,868 # 80008398 <states.0+0x150>
    8000203c:	00004097          	auipc	ra,0x4
    80002040:	bac080e7          	jalr	-1108(ra) # 80005be8 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002044:	6cbc                	ld	a5,88(s1)
    80002046:	577d                	li	a4,-1
    80002048:	fbb8                	sd	a4,112(a5)
  }
}
    8000204a:	60e2                	ld	ra,24(sp)
    8000204c:	6442                	ld	s0,16(sp)
    8000204e:	64a2                	ld	s1,8(sp)
    80002050:	6902                	ld	s2,0(sp)
    80002052:	6105                	addi	sp,sp,32
    80002054:	8082                	ret

0000000080002056 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002056:	1101                	addi	sp,sp,-32
    80002058:	ec06                	sd	ra,24(sp)
    8000205a:	e822                	sd	s0,16(sp)
    8000205c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000205e:	fec40593          	addi	a1,s0,-20
    80002062:	4501                	li	a0,0
    80002064:	00000097          	auipc	ra,0x0
    80002068:	f0e080e7          	jalr	-242(ra) # 80001f72 <argint>
  exit(n);
    8000206c:	fec42503          	lw	a0,-20(s0)
    80002070:	fffff097          	auipc	ra,0xfffff
    80002074:	5ca080e7          	jalr	1482(ra) # 8000163a <exit>
  return 0;  // not reached
}
    80002078:	4501                	li	a0,0
    8000207a:	60e2                	ld	ra,24(sp)
    8000207c:	6442                	ld	s0,16(sp)
    8000207e:	6105                	addi	sp,sp,32
    80002080:	8082                	ret

0000000080002082 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002082:	1141                	addi	sp,sp,-16
    80002084:	e406                	sd	ra,8(sp)
    80002086:	e022                	sd	s0,0(sp)
    80002088:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000208a:	fffff097          	auipc	ra,0xfffff
    8000208e:	dc8080e7          	jalr	-568(ra) # 80000e52 <myproc>
}
    80002092:	5908                	lw	a0,48(a0)
    80002094:	60a2                	ld	ra,8(sp)
    80002096:	6402                	ld	s0,0(sp)
    80002098:	0141                	addi	sp,sp,16
    8000209a:	8082                	ret

000000008000209c <sys_fork>:

uint64
sys_fork(void)
{
    8000209c:	1141                	addi	sp,sp,-16
    8000209e:	e406                	sd	ra,8(sp)
    800020a0:	e022                	sd	s0,0(sp)
    800020a2:	0800                	addi	s0,sp,16
  return fork();
    800020a4:	fffff097          	auipc	ra,0xfffff
    800020a8:	164080e7          	jalr	356(ra) # 80001208 <fork>
}
    800020ac:	60a2                	ld	ra,8(sp)
    800020ae:	6402                	ld	s0,0(sp)
    800020b0:	0141                	addi	sp,sp,16
    800020b2:	8082                	ret

00000000800020b4 <sys_wait>:

uint64
sys_wait(void)
{
    800020b4:	1101                	addi	sp,sp,-32
    800020b6:	ec06                	sd	ra,24(sp)
    800020b8:	e822                	sd	s0,16(sp)
    800020ba:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020bc:	fe840593          	addi	a1,s0,-24
    800020c0:	4501                	li	a0,0
    800020c2:	00000097          	auipc	ra,0x0
    800020c6:	ed0080e7          	jalr	-304(ra) # 80001f92 <argaddr>
  return wait(p);
    800020ca:	fe843503          	ld	a0,-24(s0)
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	712080e7          	jalr	1810(ra) # 800017e0 <wait>
}
    800020d6:	60e2                	ld	ra,24(sp)
    800020d8:	6442                	ld	s0,16(sp)
    800020da:	6105                	addi	sp,sp,32
    800020dc:	8082                	ret

00000000800020de <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020de:	7179                	addi	sp,sp,-48
    800020e0:	f406                	sd	ra,40(sp)
    800020e2:	f022                	sd	s0,32(sp)
    800020e4:	ec26                	sd	s1,24(sp)
    800020e6:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020e8:	fdc40593          	addi	a1,s0,-36
    800020ec:	4501                	li	a0,0
    800020ee:	00000097          	auipc	ra,0x0
    800020f2:	e84080e7          	jalr	-380(ra) # 80001f72 <argint>
  addr = myproc()->sz;
    800020f6:	fffff097          	auipc	ra,0xfffff
    800020fa:	d5c080e7          	jalr	-676(ra) # 80000e52 <myproc>
    800020fe:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002100:	fdc42503          	lw	a0,-36(s0)
    80002104:	fffff097          	auipc	ra,0xfffff
    80002108:	0a8080e7          	jalr	168(ra) # 800011ac <growproc>
    8000210c:	00054863          	bltz	a0,8000211c <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002110:	8526                	mv	a0,s1
    80002112:	70a2                	ld	ra,40(sp)
    80002114:	7402                	ld	s0,32(sp)
    80002116:	64e2                	ld	s1,24(sp)
    80002118:	6145                	addi	sp,sp,48
    8000211a:	8082                	ret
    return -1;
    8000211c:	54fd                	li	s1,-1
    8000211e:	bfcd                	j	80002110 <sys_sbrk+0x32>

0000000080002120 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002120:	7139                	addi	sp,sp,-64
    80002122:	fc06                	sd	ra,56(sp)
    80002124:	f822                	sd	s0,48(sp)
    80002126:	f426                	sd	s1,40(sp)
    80002128:	f04a                	sd	s2,32(sp)
    8000212a:	ec4e                	sd	s3,24(sp)
    8000212c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000212e:	fcc40593          	addi	a1,s0,-52
    80002132:	4501                	li	a0,0
    80002134:	00000097          	auipc	ra,0x0
    80002138:	e3e080e7          	jalr	-450(ra) # 80001f72 <argint>
  if(n < 0)
    8000213c:	fcc42783          	lw	a5,-52(s0)
    80002140:	0607cf63          	bltz	a5,800021be <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002144:	0000c517          	auipc	a0,0xc
    80002148:	7cc50513          	addi	a0,a0,1996 # 8000e910 <tickslock>
    8000214c:	00004097          	auipc	ra,0x4
    80002150:	f8e080e7          	jalr	-114(ra) # 800060da <acquire>
  ticks0 = ticks;
    80002154:	00006917          	auipc	s2,0x6
    80002158:	75492903          	lw	s2,1876(s2) # 800088a8 <ticks>
  while(ticks - ticks0 < n){
    8000215c:	fcc42783          	lw	a5,-52(s0)
    80002160:	cf9d                	beqz	a5,8000219e <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002162:	0000c997          	auipc	s3,0xc
    80002166:	7ae98993          	addi	s3,s3,1966 # 8000e910 <tickslock>
    8000216a:	00006497          	auipc	s1,0x6
    8000216e:	73e48493          	addi	s1,s1,1854 # 800088a8 <ticks>
    if(killed(myproc())){
    80002172:	fffff097          	auipc	ra,0xfffff
    80002176:	ce0080e7          	jalr	-800(ra) # 80000e52 <myproc>
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	634080e7          	jalr	1588(ra) # 800017ae <killed>
    80002182:	e129                	bnez	a0,800021c4 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002184:	85ce                	mv	a1,s3
    80002186:	8526                	mv	a0,s1
    80002188:	fffff097          	auipc	ra,0xfffff
    8000218c:	37e080e7          	jalr	894(ra) # 80001506 <sleep>
  while(ticks - ticks0 < n){
    80002190:	409c                	lw	a5,0(s1)
    80002192:	412787bb          	subw	a5,a5,s2
    80002196:	fcc42703          	lw	a4,-52(s0)
    8000219a:	fce7ece3          	bltu	a5,a4,80002172 <sys_sleep+0x52>
  }
  release(&tickslock);
    8000219e:	0000c517          	auipc	a0,0xc
    800021a2:	77250513          	addi	a0,a0,1906 # 8000e910 <tickslock>
    800021a6:	00004097          	auipc	ra,0x4
    800021aa:	fe8080e7          	jalr	-24(ra) # 8000618e <release>
  return 0;
    800021ae:	4501                	li	a0,0
}
    800021b0:	70e2                	ld	ra,56(sp)
    800021b2:	7442                	ld	s0,48(sp)
    800021b4:	74a2                	ld	s1,40(sp)
    800021b6:	7902                	ld	s2,32(sp)
    800021b8:	69e2                	ld	s3,24(sp)
    800021ba:	6121                	addi	sp,sp,64
    800021bc:	8082                	ret
    n = 0;
    800021be:	fc042623          	sw	zero,-52(s0)
    800021c2:	b749                	j	80002144 <sys_sleep+0x24>
      release(&tickslock);
    800021c4:	0000c517          	auipc	a0,0xc
    800021c8:	74c50513          	addi	a0,a0,1868 # 8000e910 <tickslock>
    800021cc:	00004097          	auipc	ra,0x4
    800021d0:	fc2080e7          	jalr	-62(ra) # 8000618e <release>
      return -1;
    800021d4:	557d                	li	a0,-1
    800021d6:	bfe9                	j	800021b0 <sys_sleep+0x90>

00000000800021d8 <sys_kill>:

uint64
sys_kill(void)
{
    800021d8:	1101                	addi	sp,sp,-32
    800021da:	ec06                	sd	ra,24(sp)
    800021dc:	e822                	sd	s0,16(sp)
    800021de:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021e0:	fec40593          	addi	a1,s0,-20
    800021e4:	4501                	li	a0,0
    800021e6:	00000097          	auipc	ra,0x0
    800021ea:	d8c080e7          	jalr	-628(ra) # 80001f72 <argint>
  return kill(pid);
    800021ee:	fec42503          	lw	a0,-20(s0)
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	51e080e7          	jalr	1310(ra) # 80001710 <kill>
}
    800021fa:	60e2                	ld	ra,24(sp)
    800021fc:	6442                	ld	s0,16(sp)
    800021fe:	6105                	addi	sp,sp,32
    80002200:	8082                	ret

0000000080002202 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002202:	1101                	addi	sp,sp,-32
    80002204:	ec06                	sd	ra,24(sp)
    80002206:	e822                	sd	s0,16(sp)
    80002208:	e426                	sd	s1,8(sp)
    8000220a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000220c:	0000c517          	auipc	a0,0xc
    80002210:	70450513          	addi	a0,a0,1796 # 8000e910 <tickslock>
    80002214:	00004097          	auipc	ra,0x4
    80002218:	ec6080e7          	jalr	-314(ra) # 800060da <acquire>
  xticks = ticks;
    8000221c:	00006497          	auipc	s1,0x6
    80002220:	68c4a483          	lw	s1,1676(s1) # 800088a8 <ticks>
  release(&tickslock);
    80002224:	0000c517          	auipc	a0,0xc
    80002228:	6ec50513          	addi	a0,a0,1772 # 8000e910 <tickslock>
    8000222c:	00004097          	auipc	ra,0x4
    80002230:	f62080e7          	jalr	-158(ra) # 8000618e <release>
  return xticks;
}
    80002234:	02049513          	slli	a0,s1,0x20
    80002238:	9101                	srli	a0,a0,0x20
    8000223a:	60e2                	ld	ra,24(sp)
    8000223c:	6442                	ld	s0,16(sp)
    8000223e:	64a2                	ld	s1,8(sp)
    80002240:	6105                	addi	sp,sp,32
    80002242:	8082                	ret

0000000080002244 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002244:	7179                	addi	sp,sp,-48
    80002246:	f406                	sd	ra,40(sp)
    80002248:	f022                	sd	s0,32(sp)
    8000224a:	ec26                	sd	s1,24(sp)
    8000224c:	e84a                	sd	s2,16(sp)
    8000224e:	e44e                	sd	s3,8(sp)
    80002250:	e052                	sd	s4,0(sp)
    80002252:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002254:	00006597          	auipc	a1,0x6
    80002258:	22c58593          	addi	a1,a1,556 # 80008480 <syscalls+0xb0>
    8000225c:	0000c517          	auipc	a0,0xc
    80002260:	6cc50513          	addi	a0,a0,1740 # 8000e928 <bcache>
    80002264:	00004097          	auipc	ra,0x4
    80002268:	de6080e7          	jalr	-538(ra) # 8000604a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000226c:	00014797          	auipc	a5,0x14
    80002270:	6bc78793          	addi	a5,a5,1724 # 80016928 <bcache+0x8000>
    80002274:	00015717          	auipc	a4,0x15
    80002278:	91c70713          	addi	a4,a4,-1764 # 80016b90 <bcache+0x8268>
    8000227c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002280:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002284:	0000c497          	auipc	s1,0xc
    80002288:	6bc48493          	addi	s1,s1,1724 # 8000e940 <bcache+0x18>
    b->next = bcache.head.next;
    8000228c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000228e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002290:	00006a17          	auipc	s4,0x6
    80002294:	1f8a0a13          	addi	s4,s4,504 # 80008488 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002298:	2b893783          	ld	a5,696(s2)
    8000229c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000229e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022a2:	85d2                	mv	a1,s4
    800022a4:	01048513          	addi	a0,s1,16
    800022a8:	00001097          	auipc	ra,0x1
    800022ac:	4c4080e7          	jalr	1220(ra) # 8000376c <initsleeplock>
    bcache.head.next->prev = b;
    800022b0:	2b893783          	ld	a5,696(s2)
    800022b4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022b6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022ba:	45848493          	addi	s1,s1,1112
    800022be:	fd349de3          	bne	s1,s3,80002298 <binit+0x54>
  }
}
    800022c2:	70a2                	ld	ra,40(sp)
    800022c4:	7402                	ld	s0,32(sp)
    800022c6:	64e2                	ld	s1,24(sp)
    800022c8:	6942                	ld	s2,16(sp)
    800022ca:	69a2                	ld	s3,8(sp)
    800022cc:	6a02                	ld	s4,0(sp)
    800022ce:	6145                	addi	sp,sp,48
    800022d0:	8082                	ret

00000000800022d2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022d2:	7179                	addi	sp,sp,-48
    800022d4:	f406                	sd	ra,40(sp)
    800022d6:	f022                	sd	s0,32(sp)
    800022d8:	ec26                	sd	s1,24(sp)
    800022da:	e84a                	sd	s2,16(sp)
    800022dc:	e44e                	sd	s3,8(sp)
    800022de:	1800                	addi	s0,sp,48
    800022e0:	892a                	mv	s2,a0
    800022e2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022e4:	0000c517          	auipc	a0,0xc
    800022e8:	64450513          	addi	a0,a0,1604 # 8000e928 <bcache>
    800022ec:	00004097          	auipc	ra,0x4
    800022f0:	dee080e7          	jalr	-530(ra) # 800060da <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022f4:	00015497          	auipc	s1,0x15
    800022f8:	8ec4b483          	ld	s1,-1812(s1) # 80016be0 <bcache+0x82b8>
    800022fc:	00015797          	auipc	a5,0x15
    80002300:	89478793          	addi	a5,a5,-1900 # 80016b90 <bcache+0x8268>
    80002304:	02f48f63          	beq	s1,a5,80002342 <bread+0x70>
    80002308:	873e                	mv	a4,a5
    8000230a:	a021                	j	80002312 <bread+0x40>
    8000230c:	68a4                	ld	s1,80(s1)
    8000230e:	02e48a63          	beq	s1,a4,80002342 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002312:	449c                	lw	a5,8(s1)
    80002314:	ff279ce3          	bne	a5,s2,8000230c <bread+0x3a>
    80002318:	44dc                	lw	a5,12(s1)
    8000231a:	ff3799e3          	bne	a5,s3,8000230c <bread+0x3a>
      b->refcnt++;
    8000231e:	40bc                	lw	a5,64(s1)
    80002320:	2785                	addiw	a5,a5,1
    80002322:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002324:	0000c517          	auipc	a0,0xc
    80002328:	60450513          	addi	a0,a0,1540 # 8000e928 <bcache>
    8000232c:	00004097          	auipc	ra,0x4
    80002330:	e62080e7          	jalr	-414(ra) # 8000618e <release>
      acquiresleep(&b->lock);
    80002334:	01048513          	addi	a0,s1,16
    80002338:	00001097          	auipc	ra,0x1
    8000233c:	46e080e7          	jalr	1134(ra) # 800037a6 <acquiresleep>
      return b;
    80002340:	a8b9                	j	8000239e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002342:	00015497          	auipc	s1,0x15
    80002346:	8964b483          	ld	s1,-1898(s1) # 80016bd8 <bcache+0x82b0>
    8000234a:	00015797          	auipc	a5,0x15
    8000234e:	84678793          	addi	a5,a5,-1978 # 80016b90 <bcache+0x8268>
    80002352:	00f48863          	beq	s1,a5,80002362 <bread+0x90>
    80002356:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002358:	40bc                	lw	a5,64(s1)
    8000235a:	cf81                	beqz	a5,80002372 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000235c:	64a4                	ld	s1,72(s1)
    8000235e:	fee49de3          	bne	s1,a4,80002358 <bread+0x86>
  panic("bget: no buffers");
    80002362:	00006517          	auipc	a0,0x6
    80002366:	12e50513          	addi	a0,a0,302 # 80008490 <syscalls+0xc0>
    8000236a:	00004097          	auipc	ra,0x4
    8000236e:	834080e7          	jalr	-1996(ra) # 80005b9e <panic>
      b->dev = dev;
    80002372:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002376:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000237a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000237e:	4785                	li	a5,1
    80002380:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002382:	0000c517          	auipc	a0,0xc
    80002386:	5a650513          	addi	a0,a0,1446 # 8000e928 <bcache>
    8000238a:	00004097          	auipc	ra,0x4
    8000238e:	e04080e7          	jalr	-508(ra) # 8000618e <release>
      acquiresleep(&b->lock);
    80002392:	01048513          	addi	a0,s1,16
    80002396:	00001097          	auipc	ra,0x1
    8000239a:	410080e7          	jalr	1040(ra) # 800037a6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000239e:	409c                	lw	a5,0(s1)
    800023a0:	cb89                	beqz	a5,800023b2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023a2:	8526                	mv	a0,s1
    800023a4:	70a2                	ld	ra,40(sp)
    800023a6:	7402                	ld	s0,32(sp)
    800023a8:	64e2                	ld	s1,24(sp)
    800023aa:	6942                	ld	s2,16(sp)
    800023ac:	69a2                	ld	s3,8(sp)
    800023ae:	6145                	addi	sp,sp,48
    800023b0:	8082                	ret
    virtio_disk_rw(b, 0);
    800023b2:	4581                	li	a1,0
    800023b4:	8526                	mv	a0,s1
    800023b6:	00003097          	auipc	ra,0x3
    800023ba:	fde080e7          	jalr	-34(ra) # 80005394 <virtio_disk_rw>
    b->valid = 1;
    800023be:	4785                	li	a5,1
    800023c0:	c09c                	sw	a5,0(s1)
  return b;
    800023c2:	b7c5                	j	800023a2 <bread+0xd0>

00000000800023c4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023c4:	1101                	addi	sp,sp,-32
    800023c6:	ec06                	sd	ra,24(sp)
    800023c8:	e822                	sd	s0,16(sp)
    800023ca:	e426                	sd	s1,8(sp)
    800023cc:	1000                	addi	s0,sp,32
    800023ce:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023d0:	0541                	addi	a0,a0,16
    800023d2:	00001097          	auipc	ra,0x1
    800023d6:	46e080e7          	jalr	1134(ra) # 80003840 <holdingsleep>
    800023da:	cd01                	beqz	a0,800023f2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023dc:	4585                	li	a1,1
    800023de:	8526                	mv	a0,s1
    800023e0:	00003097          	auipc	ra,0x3
    800023e4:	fb4080e7          	jalr	-76(ra) # 80005394 <virtio_disk_rw>
}
    800023e8:	60e2                	ld	ra,24(sp)
    800023ea:	6442                	ld	s0,16(sp)
    800023ec:	64a2                	ld	s1,8(sp)
    800023ee:	6105                	addi	sp,sp,32
    800023f0:	8082                	ret
    panic("bwrite");
    800023f2:	00006517          	auipc	a0,0x6
    800023f6:	0b650513          	addi	a0,a0,182 # 800084a8 <syscalls+0xd8>
    800023fa:	00003097          	auipc	ra,0x3
    800023fe:	7a4080e7          	jalr	1956(ra) # 80005b9e <panic>

0000000080002402 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002402:	1101                	addi	sp,sp,-32
    80002404:	ec06                	sd	ra,24(sp)
    80002406:	e822                	sd	s0,16(sp)
    80002408:	e426                	sd	s1,8(sp)
    8000240a:	e04a                	sd	s2,0(sp)
    8000240c:	1000                	addi	s0,sp,32
    8000240e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002410:	01050913          	addi	s2,a0,16
    80002414:	854a                	mv	a0,s2
    80002416:	00001097          	auipc	ra,0x1
    8000241a:	42a080e7          	jalr	1066(ra) # 80003840 <holdingsleep>
    8000241e:	c92d                	beqz	a0,80002490 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002420:	854a                	mv	a0,s2
    80002422:	00001097          	auipc	ra,0x1
    80002426:	3da080e7          	jalr	986(ra) # 800037fc <releasesleep>

  acquire(&bcache.lock);
    8000242a:	0000c517          	auipc	a0,0xc
    8000242e:	4fe50513          	addi	a0,a0,1278 # 8000e928 <bcache>
    80002432:	00004097          	auipc	ra,0x4
    80002436:	ca8080e7          	jalr	-856(ra) # 800060da <acquire>
  b->refcnt--;
    8000243a:	40bc                	lw	a5,64(s1)
    8000243c:	37fd                	addiw	a5,a5,-1
    8000243e:	0007871b          	sext.w	a4,a5
    80002442:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002444:	eb05                	bnez	a4,80002474 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002446:	68bc                	ld	a5,80(s1)
    80002448:	64b8                	ld	a4,72(s1)
    8000244a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000244c:	64bc                	ld	a5,72(s1)
    8000244e:	68b8                	ld	a4,80(s1)
    80002450:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002452:	00014797          	auipc	a5,0x14
    80002456:	4d678793          	addi	a5,a5,1238 # 80016928 <bcache+0x8000>
    8000245a:	2b87b703          	ld	a4,696(a5)
    8000245e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002460:	00014717          	auipc	a4,0x14
    80002464:	73070713          	addi	a4,a4,1840 # 80016b90 <bcache+0x8268>
    80002468:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000246a:	2b87b703          	ld	a4,696(a5)
    8000246e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002470:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002474:	0000c517          	auipc	a0,0xc
    80002478:	4b450513          	addi	a0,a0,1204 # 8000e928 <bcache>
    8000247c:	00004097          	auipc	ra,0x4
    80002480:	d12080e7          	jalr	-750(ra) # 8000618e <release>
}
    80002484:	60e2                	ld	ra,24(sp)
    80002486:	6442                	ld	s0,16(sp)
    80002488:	64a2                	ld	s1,8(sp)
    8000248a:	6902                	ld	s2,0(sp)
    8000248c:	6105                	addi	sp,sp,32
    8000248e:	8082                	ret
    panic("brelse");
    80002490:	00006517          	auipc	a0,0x6
    80002494:	02050513          	addi	a0,a0,32 # 800084b0 <syscalls+0xe0>
    80002498:	00003097          	auipc	ra,0x3
    8000249c:	706080e7          	jalr	1798(ra) # 80005b9e <panic>

00000000800024a0 <bpin>:

void
bpin(struct buf *b) {
    800024a0:	1101                	addi	sp,sp,-32
    800024a2:	ec06                	sd	ra,24(sp)
    800024a4:	e822                	sd	s0,16(sp)
    800024a6:	e426                	sd	s1,8(sp)
    800024a8:	1000                	addi	s0,sp,32
    800024aa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024ac:	0000c517          	auipc	a0,0xc
    800024b0:	47c50513          	addi	a0,a0,1148 # 8000e928 <bcache>
    800024b4:	00004097          	auipc	ra,0x4
    800024b8:	c26080e7          	jalr	-986(ra) # 800060da <acquire>
  b->refcnt++;
    800024bc:	40bc                	lw	a5,64(s1)
    800024be:	2785                	addiw	a5,a5,1
    800024c0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024c2:	0000c517          	auipc	a0,0xc
    800024c6:	46650513          	addi	a0,a0,1126 # 8000e928 <bcache>
    800024ca:	00004097          	auipc	ra,0x4
    800024ce:	cc4080e7          	jalr	-828(ra) # 8000618e <release>
}
    800024d2:	60e2                	ld	ra,24(sp)
    800024d4:	6442                	ld	s0,16(sp)
    800024d6:	64a2                	ld	s1,8(sp)
    800024d8:	6105                	addi	sp,sp,32
    800024da:	8082                	ret

00000000800024dc <bunpin>:

void
bunpin(struct buf *b) {
    800024dc:	1101                	addi	sp,sp,-32
    800024de:	ec06                	sd	ra,24(sp)
    800024e0:	e822                	sd	s0,16(sp)
    800024e2:	e426                	sd	s1,8(sp)
    800024e4:	1000                	addi	s0,sp,32
    800024e6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024e8:	0000c517          	auipc	a0,0xc
    800024ec:	44050513          	addi	a0,a0,1088 # 8000e928 <bcache>
    800024f0:	00004097          	auipc	ra,0x4
    800024f4:	bea080e7          	jalr	-1046(ra) # 800060da <acquire>
  b->refcnt--;
    800024f8:	40bc                	lw	a5,64(s1)
    800024fa:	37fd                	addiw	a5,a5,-1
    800024fc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024fe:	0000c517          	auipc	a0,0xc
    80002502:	42a50513          	addi	a0,a0,1066 # 8000e928 <bcache>
    80002506:	00004097          	auipc	ra,0x4
    8000250a:	c88080e7          	jalr	-888(ra) # 8000618e <release>
}
    8000250e:	60e2                	ld	ra,24(sp)
    80002510:	6442                	ld	s0,16(sp)
    80002512:	64a2                	ld	s1,8(sp)
    80002514:	6105                	addi	sp,sp,32
    80002516:	8082                	ret

0000000080002518 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002518:	1101                	addi	sp,sp,-32
    8000251a:	ec06                	sd	ra,24(sp)
    8000251c:	e822                	sd	s0,16(sp)
    8000251e:	e426                	sd	s1,8(sp)
    80002520:	e04a                	sd	s2,0(sp)
    80002522:	1000                	addi	s0,sp,32
    80002524:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002526:	00d5d59b          	srliw	a1,a1,0xd
    8000252a:	00015797          	auipc	a5,0x15
    8000252e:	ada7a783          	lw	a5,-1318(a5) # 80017004 <sb+0x1c>
    80002532:	9dbd                	addw	a1,a1,a5
    80002534:	00000097          	auipc	ra,0x0
    80002538:	d9e080e7          	jalr	-610(ra) # 800022d2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000253c:	0074f713          	andi	a4,s1,7
    80002540:	4785                	li	a5,1
    80002542:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002546:	14ce                	slli	s1,s1,0x33
    80002548:	90d9                	srli	s1,s1,0x36
    8000254a:	00950733          	add	a4,a0,s1
    8000254e:	05874703          	lbu	a4,88(a4)
    80002552:	00e7f6b3          	and	a3,a5,a4
    80002556:	c69d                	beqz	a3,80002584 <bfree+0x6c>
    80002558:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000255a:	94aa                	add	s1,s1,a0
    8000255c:	fff7c793          	not	a5,a5
    80002560:	8ff9                	and	a5,a5,a4
    80002562:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002566:	00001097          	auipc	ra,0x1
    8000256a:	120080e7          	jalr	288(ra) # 80003686 <log_write>
  brelse(bp);
    8000256e:	854a                	mv	a0,s2
    80002570:	00000097          	auipc	ra,0x0
    80002574:	e92080e7          	jalr	-366(ra) # 80002402 <brelse>
}
    80002578:	60e2                	ld	ra,24(sp)
    8000257a:	6442                	ld	s0,16(sp)
    8000257c:	64a2                	ld	s1,8(sp)
    8000257e:	6902                	ld	s2,0(sp)
    80002580:	6105                	addi	sp,sp,32
    80002582:	8082                	ret
    panic("freeing free block");
    80002584:	00006517          	auipc	a0,0x6
    80002588:	f3450513          	addi	a0,a0,-204 # 800084b8 <syscalls+0xe8>
    8000258c:	00003097          	auipc	ra,0x3
    80002590:	612080e7          	jalr	1554(ra) # 80005b9e <panic>

0000000080002594 <balloc>:
{
    80002594:	711d                	addi	sp,sp,-96
    80002596:	ec86                	sd	ra,88(sp)
    80002598:	e8a2                	sd	s0,80(sp)
    8000259a:	e4a6                	sd	s1,72(sp)
    8000259c:	e0ca                	sd	s2,64(sp)
    8000259e:	fc4e                	sd	s3,56(sp)
    800025a0:	f852                	sd	s4,48(sp)
    800025a2:	f456                	sd	s5,40(sp)
    800025a4:	f05a                	sd	s6,32(sp)
    800025a6:	ec5e                	sd	s7,24(sp)
    800025a8:	e862                	sd	s8,16(sp)
    800025aa:	e466                	sd	s9,8(sp)
    800025ac:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025ae:	00015797          	auipc	a5,0x15
    800025b2:	a3e7a783          	lw	a5,-1474(a5) # 80016fec <sb+0x4>
    800025b6:	10078163          	beqz	a5,800026b8 <balloc+0x124>
    800025ba:	8baa                	mv	s7,a0
    800025bc:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025be:	00015b17          	auipc	s6,0x15
    800025c2:	a2ab0b13          	addi	s6,s6,-1494 # 80016fe8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025c6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025c8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ca:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025cc:	6c89                	lui	s9,0x2
    800025ce:	a061                	j	80002656 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025d0:	974a                	add	a4,a4,s2
    800025d2:	8fd5                	or	a5,a5,a3
    800025d4:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025d8:	854a                	mv	a0,s2
    800025da:	00001097          	auipc	ra,0x1
    800025de:	0ac080e7          	jalr	172(ra) # 80003686 <log_write>
        brelse(bp);
    800025e2:	854a                	mv	a0,s2
    800025e4:	00000097          	auipc	ra,0x0
    800025e8:	e1e080e7          	jalr	-482(ra) # 80002402 <brelse>
  bp = bread(dev, bno);
    800025ec:	85a6                	mv	a1,s1
    800025ee:	855e                	mv	a0,s7
    800025f0:	00000097          	auipc	ra,0x0
    800025f4:	ce2080e7          	jalr	-798(ra) # 800022d2 <bread>
    800025f8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025fa:	40000613          	li	a2,1024
    800025fe:	4581                	li	a1,0
    80002600:	05850513          	addi	a0,a0,88
    80002604:	ffffe097          	auipc	ra,0xffffe
    80002608:	b74080e7          	jalr	-1164(ra) # 80000178 <memset>
  log_write(bp);
    8000260c:	854a                	mv	a0,s2
    8000260e:	00001097          	auipc	ra,0x1
    80002612:	078080e7          	jalr	120(ra) # 80003686 <log_write>
  brelse(bp);
    80002616:	854a                	mv	a0,s2
    80002618:	00000097          	auipc	ra,0x0
    8000261c:	dea080e7          	jalr	-534(ra) # 80002402 <brelse>
}
    80002620:	8526                	mv	a0,s1
    80002622:	60e6                	ld	ra,88(sp)
    80002624:	6446                	ld	s0,80(sp)
    80002626:	64a6                	ld	s1,72(sp)
    80002628:	6906                	ld	s2,64(sp)
    8000262a:	79e2                	ld	s3,56(sp)
    8000262c:	7a42                	ld	s4,48(sp)
    8000262e:	7aa2                	ld	s5,40(sp)
    80002630:	7b02                	ld	s6,32(sp)
    80002632:	6be2                	ld	s7,24(sp)
    80002634:	6c42                	ld	s8,16(sp)
    80002636:	6ca2                	ld	s9,8(sp)
    80002638:	6125                	addi	sp,sp,96
    8000263a:	8082                	ret
    brelse(bp);
    8000263c:	854a                	mv	a0,s2
    8000263e:	00000097          	auipc	ra,0x0
    80002642:	dc4080e7          	jalr	-572(ra) # 80002402 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002646:	015c87bb          	addw	a5,s9,s5
    8000264a:	00078a9b          	sext.w	s5,a5
    8000264e:	004b2703          	lw	a4,4(s6)
    80002652:	06eaf363          	bgeu	s5,a4,800026b8 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002656:	41fad79b          	sraiw	a5,s5,0x1f
    8000265a:	0137d79b          	srliw	a5,a5,0x13
    8000265e:	015787bb          	addw	a5,a5,s5
    80002662:	40d7d79b          	sraiw	a5,a5,0xd
    80002666:	01cb2583          	lw	a1,28(s6)
    8000266a:	9dbd                	addw	a1,a1,a5
    8000266c:	855e                	mv	a0,s7
    8000266e:	00000097          	auipc	ra,0x0
    80002672:	c64080e7          	jalr	-924(ra) # 800022d2 <bread>
    80002676:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002678:	004b2503          	lw	a0,4(s6)
    8000267c:	000a849b          	sext.w	s1,s5
    80002680:	8662                	mv	a2,s8
    80002682:	faa4fde3          	bgeu	s1,a0,8000263c <balloc+0xa8>
      m = 1 << (bi % 8);
    80002686:	41f6579b          	sraiw	a5,a2,0x1f
    8000268a:	01d7d69b          	srliw	a3,a5,0x1d
    8000268e:	00c6873b          	addw	a4,a3,a2
    80002692:	00777793          	andi	a5,a4,7
    80002696:	9f95                	subw	a5,a5,a3
    80002698:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000269c:	4037571b          	sraiw	a4,a4,0x3
    800026a0:	00e906b3          	add	a3,s2,a4
    800026a4:	0586c683          	lbu	a3,88(a3)
    800026a8:	00d7f5b3          	and	a1,a5,a3
    800026ac:	d195                	beqz	a1,800025d0 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ae:	2605                	addiw	a2,a2,1
    800026b0:	2485                	addiw	s1,s1,1
    800026b2:	fd4618e3          	bne	a2,s4,80002682 <balloc+0xee>
    800026b6:	b759                	j	8000263c <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800026b8:	00006517          	auipc	a0,0x6
    800026bc:	e1850513          	addi	a0,a0,-488 # 800084d0 <syscalls+0x100>
    800026c0:	00003097          	auipc	ra,0x3
    800026c4:	528080e7          	jalr	1320(ra) # 80005be8 <printf>
  return 0;
    800026c8:	4481                	li	s1,0
    800026ca:	bf99                	j	80002620 <balloc+0x8c>

00000000800026cc <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026cc:	7179                	addi	sp,sp,-48
    800026ce:	f406                	sd	ra,40(sp)
    800026d0:	f022                	sd	s0,32(sp)
    800026d2:	ec26                	sd	s1,24(sp)
    800026d4:	e84a                	sd	s2,16(sp)
    800026d6:	e44e                	sd	s3,8(sp)
    800026d8:	e052                	sd	s4,0(sp)
    800026da:	1800                	addi	s0,sp,48
    800026dc:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026de:	47ad                	li	a5,11
    800026e0:	02b7e763          	bltu	a5,a1,8000270e <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800026e4:	02059493          	slli	s1,a1,0x20
    800026e8:	9081                	srli	s1,s1,0x20
    800026ea:	048a                	slli	s1,s1,0x2
    800026ec:	94aa                	add	s1,s1,a0
    800026ee:	0504a903          	lw	s2,80(s1)
    800026f2:	06091e63          	bnez	s2,8000276e <bmap+0xa2>
      addr = balloc(ip->dev);
    800026f6:	4108                	lw	a0,0(a0)
    800026f8:	00000097          	auipc	ra,0x0
    800026fc:	e9c080e7          	jalr	-356(ra) # 80002594 <balloc>
    80002700:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002704:	06090563          	beqz	s2,8000276e <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002708:	0524a823          	sw	s2,80(s1)
    8000270c:	a08d                	j	8000276e <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000270e:	ff45849b          	addiw	s1,a1,-12
    80002712:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002716:	0ff00793          	li	a5,255
    8000271a:	08e7e563          	bltu	a5,a4,800027a4 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000271e:	08052903          	lw	s2,128(a0)
    80002722:	00091d63          	bnez	s2,8000273c <bmap+0x70>
      addr = balloc(ip->dev);
    80002726:	4108                	lw	a0,0(a0)
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	e6c080e7          	jalr	-404(ra) # 80002594 <balloc>
    80002730:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002734:	02090d63          	beqz	s2,8000276e <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002738:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000273c:	85ca                	mv	a1,s2
    8000273e:	0009a503          	lw	a0,0(s3)
    80002742:	00000097          	auipc	ra,0x0
    80002746:	b90080e7          	jalr	-1136(ra) # 800022d2 <bread>
    8000274a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000274c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002750:	02049593          	slli	a1,s1,0x20
    80002754:	9181                	srli	a1,a1,0x20
    80002756:	058a                	slli	a1,a1,0x2
    80002758:	00b784b3          	add	s1,a5,a1
    8000275c:	0004a903          	lw	s2,0(s1)
    80002760:	02090063          	beqz	s2,80002780 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002764:	8552                	mv	a0,s4
    80002766:	00000097          	auipc	ra,0x0
    8000276a:	c9c080e7          	jalr	-868(ra) # 80002402 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000276e:	854a                	mv	a0,s2
    80002770:	70a2                	ld	ra,40(sp)
    80002772:	7402                	ld	s0,32(sp)
    80002774:	64e2                	ld	s1,24(sp)
    80002776:	6942                	ld	s2,16(sp)
    80002778:	69a2                	ld	s3,8(sp)
    8000277a:	6a02                	ld	s4,0(sp)
    8000277c:	6145                	addi	sp,sp,48
    8000277e:	8082                	ret
      addr = balloc(ip->dev);
    80002780:	0009a503          	lw	a0,0(s3)
    80002784:	00000097          	auipc	ra,0x0
    80002788:	e10080e7          	jalr	-496(ra) # 80002594 <balloc>
    8000278c:	0005091b          	sext.w	s2,a0
      if(addr){
    80002790:	fc090ae3          	beqz	s2,80002764 <bmap+0x98>
        a[bn] = addr;
    80002794:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002798:	8552                	mv	a0,s4
    8000279a:	00001097          	auipc	ra,0x1
    8000279e:	eec080e7          	jalr	-276(ra) # 80003686 <log_write>
    800027a2:	b7c9                	j	80002764 <bmap+0x98>
  panic("bmap: out of range");
    800027a4:	00006517          	auipc	a0,0x6
    800027a8:	d4450513          	addi	a0,a0,-700 # 800084e8 <syscalls+0x118>
    800027ac:	00003097          	auipc	ra,0x3
    800027b0:	3f2080e7          	jalr	1010(ra) # 80005b9e <panic>

00000000800027b4 <iget>:
{
    800027b4:	7179                	addi	sp,sp,-48
    800027b6:	f406                	sd	ra,40(sp)
    800027b8:	f022                	sd	s0,32(sp)
    800027ba:	ec26                	sd	s1,24(sp)
    800027bc:	e84a                	sd	s2,16(sp)
    800027be:	e44e                	sd	s3,8(sp)
    800027c0:	e052                	sd	s4,0(sp)
    800027c2:	1800                	addi	s0,sp,48
    800027c4:	89aa                	mv	s3,a0
    800027c6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027c8:	00015517          	auipc	a0,0x15
    800027cc:	84050513          	addi	a0,a0,-1984 # 80017008 <itable>
    800027d0:	00004097          	auipc	ra,0x4
    800027d4:	90a080e7          	jalr	-1782(ra) # 800060da <acquire>
  empty = 0;
    800027d8:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027da:	00015497          	auipc	s1,0x15
    800027de:	84648493          	addi	s1,s1,-1978 # 80017020 <itable+0x18>
    800027e2:	00016697          	auipc	a3,0x16
    800027e6:	2ce68693          	addi	a3,a3,718 # 80018ab0 <log>
    800027ea:	a039                	j	800027f8 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027ec:	02090b63          	beqz	s2,80002822 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027f0:	08848493          	addi	s1,s1,136
    800027f4:	02d48a63          	beq	s1,a3,80002828 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027f8:	449c                	lw	a5,8(s1)
    800027fa:	fef059e3          	blez	a5,800027ec <iget+0x38>
    800027fe:	4098                	lw	a4,0(s1)
    80002800:	ff3716e3          	bne	a4,s3,800027ec <iget+0x38>
    80002804:	40d8                	lw	a4,4(s1)
    80002806:	ff4713e3          	bne	a4,s4,800027ec <iget+0x38>
      ip->ref++;
    8000280a:	2785                	addiw	a5,a5,1
    8000280c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000280e:	00014517          	auipc	a0,0x14
    80002812:	7fa50513          	addi	a0,a0,2042 # 80017008 <itable>
    80002816:	00004097          	auipc	ra,0x4
    8000281a:	978080e7          	jalr	-1672(ra) # 8000618e <release>
      return ip;
    8000281e:	8926                	mv	s2,s1
    80002820:	a03d                	j	8000284e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002822:	f7f9                	bnez	a5,800027f0 <iget+0x3c>
    80002824:	8926                	mv	s2,s1
    80002826:	b7e9                	j	800027f0 <iget+0x3c>
  if(empty == 0)
    80002828:	02090c63          	beqz	s2,80002860 <iget+0xac>
  ip->dev = dev;
    8000282c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002830:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002834:	4785                	li	a5,1
    80002836:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000283a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000283e:	00014517          	auipc	a0,0x14
    80002842:	7ca50513          	addi	a0,a0,1994 # 80017008 <itable>
    80002846:	00004097          	auipc	ra,0x4
    8000284a:	948080e7          	jalr	-1720(ra) # 8000618e <release>
}
    8000284e:	854a                	mv	a0,s2
    80002850:	70a2                	ld	ra,40(sp)
    80002852:	7402                	ld	s0,32(sp)
    80002854:	64e2                	ld	s1,24(sp)
    80002856:	6942                	ld	s2,16(sp)
    80002858:	69a2                	ld	s3,8(sp)
    8000285a:	6a02                	ld	s4,0(sp)
    8000285c:	6145                	addi	sp,sp,48
    8000285e:	8082                	ret
    panic("iget: no inodes");
    80002860:	00006517          	auipc	a0,0x6
    80002864:	ca050513          	addi	a0,a0,-864 # 80008500 <syscalls+0x130>
    80002868:	00003097          	auipc	ra,0x3
    8000286c:	336080e7          	jalr	822(ra) # 80005b9e <panic>

0000000080002870 <fsinit>:
fsinit(int dev) {
    80002870:	7179                	addi	sp,sp,-48
    80002872:	f406                	sd	ra,40(sp)
    80002874:	f022                	sd	s0,32(sp)
    80002876:	ec26                	sd	s1,24(sp)
    80002878:	e84a                	sd	s2,16(sp)
    8000287a:	e44e                	sd	s3,8(sp)
    8000287c:	1800                	addi	s0,sp,48
    8000287e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002880:	4585                	li	a1,1
    80002882:	00000097          	auipc	ra,0x0
    80002886:	a50080e7          	jalr	-1456(ra) # 800022d2 <bread>
    8000288a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000288c:	00014997          	auipc	s3,0x14
    80002890:	75c98993          	addi	s3,s3,1884 # 80016fe8 <sb>
    80002894:	02000613          	li	a2,32
    80002898:	05850593          	addi	a1,a0,88
    8000289c:	854e                	mv	a0,s3
    8000289e:	ffffe097          	auipc	ra,0xffffe
    800028a2:	936080e7          	jalr	-1738(ra) # 800001d4 <memmove>
  brelse(bp);
    800028a6:	8526                	mv	a0,s1
    800028a8:	00000097          	auipc	ra,0x0
    800028ac:	b5a080e7          	jalr	-1190(ra) # 80002402 <brelse>
  if(sb.magic != FSMAGIC)
    800028b0:	0009a703          	lw	a4,0(s3)
    800028b4:	102037b7          	lui	a5,0x10203
    800028b8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028bc:	02f71263          	bne	a4,a5,800028e0 <fsinit+0x70>
  initlog(dev, &sb);
    800028c0:	00014597          	auipc	a1,0x14
    800028c4:	72858593          	addi	a1,a1,1832 # 80016fe8 <sb>
    800028c8:	854a                	mv	a0,s2
    800028ca:	00001097          	auipc	ra,0x1
    800028ce:	b40080e7          	jalr	-1216(ra) # 8000340a <initlog>
}
    800028d2:	70a2                	ld	ra,40(sp)
    800028d4:	7402                	ld	s0,32(sp)
    800028d6:	64e2                	ld	s1,24(sp)
    800028d8:	6942                	ld	s2,16(sp)
    800028da:	69a2                	ld	s3,8(sp)
    800028dc:	6145                	addi	sp,sp,48
    800028de:	8082                	ret
    panic("invalid file system");
    800028e0:	00006517          	auipc	a0,0x6
    800028e4:	c3050513          	addi	a0,a0,-976 # 80008510 <syscalls+0x140>
    800028e8:	00003097          	auipc	ra,0x3
    800028ec:	2b6080e7          	jalr	694(ra) # 80005b9e <panic>

00000000800028f0 <iinit>:
{
    800028f0:	7179                	addi	sp,sp,-48
    800028f2:	f406                	sd	ra,40(sp)
    800028f4:	f022                	sd	s0,32(sp)
    800028f6:	ec26                	sd	s1,24(sp)
    800028f8:	e84a                	sd	s2,16(sp)
    800028fa:	e44e                	sd	s3,8(sp)
    800028fc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028fe:	00006597          	auipc	a1,0x6
    80002902:	c2a58593          	addi	a1,a1,-982 # 80008528 <syscalls+0x158>
    80002906:	00014517          	auipc	a0,0x14
    8000290a:	70250513          	addi	a0,a0,1794 # 80017008 <itable>
    8000290e:	00003097          	auipc	ra,0x3
    80002912:	73c080e7          	jalr	1852(ra) # 8000604a <initlock>
  for(i = 0; i < NINODE; i++) {
    80002916:	00014497          	auipc	s1,0x14
    8000291a:	71a48493          	addi	s1,s1,1818 # 80017030 <itable+0x28>
    8000291e:	00016997          	auipc	s3,0x16
    80002922:	1a298993          	addi	s3,s3,418 # 80018ac0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002926:	00006917          	auipc	s2,0x6
    8000292a:	c0a90913          	addi	s2,s2,-1014 # 80008530 <syscalls+0x160>
    8000292e:	85ca                	mv	a1,s2
    80002930:	8526                	mv	a0,s1
    80002932:	00001097          	auipc	ra,0x1
    80002936:	e3a080e7          	jalr	-454(ra) # 8000376c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000293a:	08848493          	addi	s1,s1,136
    8000293e:	ff3498e3          	bne	s1,s3,8000292e <iinit+0x3e>
}
    80002942:	70a2                	ld	ra,40(sp)
    80002944:	7402                	ld	s0,32(sp)
    80002946:	64e2                	ld	s1,24(sp)
    80002948:	6942                	ld	s2,16(sp)
    8000294a:	69a2                	ld	s3,8(sp)
    8000294c:	6145                	addi	sp,sp,48
    8000294e:	8082                	ret

0000000080002950 <ialloc>:
{
    80002950:	715d                	addi	sp,sp,-80
    80002952:	e486                	sd	ra,72(sp)
    80002954:	e0a2                	sd	s0,64(sp)
    80002956:	fc26                	sd	s1,56(sp)
    80002958:	f84a                	sd	s2,48(sp)
    8000295a:	f44e                	sd	s3,40(sp)
    8000295c:	f052                	sd	s4,32(sp)
    8000295e:	ec56                	sd	s5,24(sp)
    80002960:	e85a                	sd	s6,16(sp)
    80002962:	e45e                	sd	s7,8(sp)
    80002964:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002966:	00014717          	auipc	a4,0x14
    8000296a:	68e72703          	lw	a4,1678(a4) # 80016ff4 <sb+0xc>
    8000296e:	4785                	li	a5,1
    80002970:	04e7fa63          	bgeu	a5,a4,800029c4 <ialloc+0x74>
    80002974:	8aaa                	mv	s5,a0
    80002976:	8bae                	mv	s7,a1
    80002978:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000297a:	00014a17          	auipc	s4,0x14
    8000297e:	66ea0a13          	addi	s4,s4,1646 # 80016fe8 <sb>
    80002982:	00048b1b          	sext.w	s6,s1
    80002986:	0044d793          	srli	a5,s1,0x4
    8000298a:	018a2583          	lw	a1,24(s4)
    8000298e:	9dbd                	addw	a1,a1,a5
    80002990:	8556                	mv	a0,s5
    80002992:	00000097          	auipc	ra,0x0
    80002996:	940080e7          	jalr	-1728(ra) # 800022d2 <bread>
    8000299a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000299c:	05850993          	addi	s3,a0,88
    800029a0:	00f4f793          	andi	a5,s1,15
    800029a4:	079a                	slli	a5,a5,0x6
    800029a6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029a8:	00099783          	lh	a5,0(s3)
    800029ac:	c3a1                	beqz	a5,800029ec <ialloc+0x9c>
    brelse(bp);
    800029ae:	00000097          	auipc	ra,0x0
    800029b2:	a54080e7          	jalr	-1452(ra) # 80002402 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029b6:	0485                	addi	s1,s1,1
    800029b8:	00ca2703          	lw	a4,12(s4)
    800029bc:	0004879b          	sext.w	a5,s1
    800029c0:	fce7e1e3          	bltu	a5,a4,80002982 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800029c4:	00006517          	auipc	a0,0x6
    800029c8:	b7450513          	addi	a0,a0,-1164 # 80008538 <syscalls+0x168>
    800029cc:	00003097          	auipc	ra,0x3
    800029d0:	21c080e7          	jalr	540(ra) # 80005be8 <printf>
  return 0;
    800029d4:	4501                	li	a0,0
}
    800029d6:	60a6                	ld	ra,72(sp)
    800029d8:	6406                	ld	s0,64(sp)
    800029da:	74e2                	ld	s1,56(sp)
    800029dc:	7942                	ld	s2,48(sp)
    800029de:	79a2                	ld	s3,40(sp)
    800029e0:	7a02                	ld	s4,32(sp)
    800029e2:	6ae2                	ld	s5,24(sp)
    800029e4:	6b42                	ld	s6,16(sp)
    800029e6:	6ba2                	ld	s7,8(sp)
    800029e8:	6161                	addi	sp,sp,80
    800029ea:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029ec:	04000613          	li	a2,64
    800029f0:	4581                	li	a1,0
    800029f2:	854e                	mv	a0,s3
    800029f4:	ffffd097          	auipc	ra,0xffffd
    800029f8:	784080e7          	jalr	1924(ra) # 80000178 <memset>
      dip->type = type;
    800029fc:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a00:	854a                	mv	a0,s2
    80002a02:	00001097          	auipc	ra,0x1
    80002a06:	c84080e7          	jalr	-892(ra) # 80003686 <log_write>
      brelse(bp);
    80002a0a:	854a                	mv	a0,s2
    80002a0c:	00000097          	auipc	ra,0x0
    80002a10:	9f6080e7          	jalr	-1546(ra) # 80002402 <brelse>
      return iget(dev, inum);
    80002a14:	85da                	mv	a1,s6
    80002a16:	8556                	mv	a0,s5
    80002a18:	00000097          	auipc	ra,0x0
    80002a1c:	d9c080e7          	jalr	-612(ra) # 800027b4 <iget>
    80002a20:	bf5d                	j	800029d6 <ialloc+0x86>

0000000080002a22 <iupdate>:
{
    80002a22:	1101                	addi	sp,sp,-32
    80002a24:	ec06                	sd	ra,24(sp)
    80002a26:	e822                	sd	s0,16(sp)
    80002a28:	e426                	sd	s1,8(sp)
    80002a2a:	e04a                	sd	s2,0(sp)
    80002a2c:	1000                	addi	s0,sp,32
    80002a2e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a30:	415c                	lw	a5,4(a0)
    80002a32:	0047d79b          	srliw	a5,a5,0x4
    80002a36:	00014597          	auipc	a1,0x14
    80002a3a:	5ca5a583          	lw	a1,1482(a1) # 80017000 <sb+0x18>
    80002a3e:	9dbd                	addw	a1,a1,a5
    80002a40:	4108                	lw	a0,0(a0)
    80002a42:	00000097          	auipc	ra,0x0
    80002a46:	890080e7          	jalr	-1904(ra) # 800022d2 <bread>
    80002a4a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a4c:	05850793          	addi	a5,a0,88
    80002a50:	40c8                	lw	a0,4(s1)
    80002a52:	893d                	andi	a0,a0,15
    80002a54:	051a                	slli	a0,a0,0x6
    80002a56:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a58:	04449703          	lh	a4,68(s1)
    80002a5c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002a60:	04649703          	lh	a4,70(s1)
    80002a64:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002a68:	04849703          	lh	a4,72(s1)
    80002a6c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002a70:	04a49703          	lh	a4,74(s1)
    80002a74:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002a78:	44f8                	lw	a4,76(s1)
    80002a7a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a7c:	03400613          	li	a2,52
    80002a80:	05048593          	addi	a1,s1,80
    80002a84:	0531                	addi	a0,a0,12
    80002a86:	ffffd097          	auipc	ra,0xffffd
    80002a8a:	74e080e7          	jalr	1870(ra) # 800001d4 <memmove>
  log_write(bp);
    80002a8e:	854a                	mv	a0,s2
    80002a90:	00001097          	auipc	ra,0x1
    80002a94:	bf6080e7          	jalr	-1034(ra) # 80003686 <log_write>
  brelse(bp);
    80002a98:	854a                	mv	a0,s2
    80002a9a:	00000097          	auipc	ra,0x0
    80002a9e:	968080e7          	jalr	-1688(ra) # 80002402 <brelse>
}
    80002aa2:	60e2                	ld	ra,24(sp)
    80002aa4:	6442                	ld	s0,16(sp)
    80002aa6:	64a2                	ld	s1,8(sp)
    80002aa8:	6902                	ld	s2,0(sp)
    80002aaa:	6105                	addi	sp,sp,32
    80002aac:	8082                	ret

0000000080002aae <idup>:
{
    80002aae:	1101                	addi	sp,sp,-32
    80002ab0:	ec06                	sd	ra,24(sp)
    80002ab2:	e822                	sd	s0,16(sp)
    80002ab4:	e426                	sd	s1,8(sp)
    80002ab6:	1000                	addi	s0,sp,32
    80002ab8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002aba:	00014517          	auipc	a0,0x14
    80002abe:	54e50513          	addi	a0,a0,1358 # 80017008 <itable>
    80002ac2:	00003097          	auipc	ra,0x3
    80002ac6:	618080e7          	jalr	1560(ra) # 800060da <acquire>
  ip->ref++;
    80002aca:	449c                	lw	a5,8(s1)
    80002acc:	2785                	addiw	a5,a5,1
    80002ace:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ad0:	00014517          	auipc	a0,0x14
    80002ad4:	53850513          	addi	a0,a0,1336 # 80017008 <itable>
    80002ad8:	00003097          	auipc	ra,0x3
    80002adc:	6b6080e7          	jalr	1718(ra) # 8000618e <release>
}
    80002ae0:	8526                	mv	a0,s1
    80002ae2:	60e2                	ld	ra,24(sp)
    80002ae4:	6442                	ld	s0,16(sp)
    80002ae6:	64a2                	ld	s1,8(sp)
    80002ae8:	6105                	addi	sp,sp,32
    80002aea:	8082                	ret

0000000080002aec <ilock>:
{
    80002aec:	1101                	addi	sp,sp,-32
    80002aee:	ec06                	sd	ra,24(sp)
    80002af0:	e822                	sd	s0,16(sp)
    80002af2:	e426                	sd	s1,8(sp)
    80002af4:	e04a                	sd	s2,0(sp)
    80002af6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002af8:	c115                	beqz	a0,80002b1c <ilock+0x30>
    80002afa:	84aa                	mv	s1,a0
    80002afc:	451c                	lw	a5,8(a0)
    80002afe:	00f05f63          	blez	a5,80002b1c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b02:	0541                	addi	a0,a0,16
    80002b04:	00001097          	auipc	ra,0x1
    80002b08:	ca2080e7          	jalr	-862(ra) # 800037a6 <acquiresleep>
  if(ip->valid == 0){
    80002b0c:	40bc                	lw	a5,64(s1)
    80002b0e:	cf99                	beqz	a5,80002b2c <ilock+0x40>
}
    80002b10:	60e2                	ld	ra,24(sp)
    80002b12:	6442                	ld	s0,16(sp)
    80002b14:	64a2                	ld	s1,8(sp)
    80002b16:	6902                	ld	s2,0(sp)
    80002b18:	6105                	addi	sp,sp,32
    80002b1a:	8082                	ret
    panic("ilock");
    80002b1c:	00006517          	auipc	a0,0x6
    80002b20:	a3450513          	addi	a0,a0,-1484 # 80008550 <syscalls+0x180>
    80002b24:	00003097          	auipc	ra,0x3
    80002b28:	07a080e7          	jalr	122(ra) # 80005b9e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b2c:	40dc                	lw	a5,4(s1)
    80002b2e:	0047d79b          	srliw	a5,a5,0x4
    80002b32:	00014597          	auipc	a1,0x14
    80002b36:	4ce5a583          	lw	a1,1230(a1) # 80017000 <sb+0x18>
    80002b3a:	9dbd                	addw	a1,a1,a5
    80002b3c:	4088                	lw	a0,0(s1)
    80002b3e:	fffff097          	auipc	ra,0xfffff
    80002b42:	794080e7          	jalr	1940(ra) # 800022d2 <bread>
    80002b46:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b48:	05850593          	addi	a1,a0,88
    80002b4c:	40dc                	lw	a5,4(s1)
    80002b4e:	8bbd                	andi	a5,a5,15
    80002b50:	079a                	slli	a5,a5,0x6
    80002b52:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b54:	00059783          	lh	a5,0(a1)
    80002b58:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b5c:	00259783          	lh	a5,2(a1)
    80002b60:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b64:	00459783          	lh	a5,4(a1)
    80002b68:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b6c:	00659783          	lh	a5,6(a1)
    80002b70:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b74:	459c                	lw	a5,8(a1)
    80002b76:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b78:	03400613          	li	a2,52
    80002b7c:	05b1                	addi	a1,a1,12
    80002b7e:	05048513          	addi	a0,s1,80
    80002b82:	ffffd097          	auipc	ra,0xffffd
    80002b86:	652080e7          	jalr	1618(ra) # 800001d4 <memmove>
    brelse(bp);
    80002b8a:	854a                	mv	a0,s2
    80002b8c:	00000097          	auipc	ra,0x0
    80002b90:	876080e7          	jalr	-1930(ra) # 80002402 <brelse>
    ip->valid = 1;
    80002b94:	4785                	li	a5,1
    80002b96:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b98:	04449783          	lh	a5,68(s1)
    80002b9c:	fbb5                	bnez	a5,80002b10 <ilock+0x24>
      panic("ilock: no type");
    80002b9e:	00006517          	auipc	a0,0x6
    80002ba2:	9ba50513          	addi	a0,a0,-1606 # 80008558 <syscalls+0x188>
    80002ba6:	00003097          	auipc	ra,0x3
    80002baa:	ff8080e7          	jalr	-8(ra) # 80005b9e <panic>

0000000080002bae <iunlock>:
{
    80002bae:	1101                	addi	sp,sp,-32
    80002bb0:	ec06                	sd	ra,24(sp)
    80002bb2:	e822                	sd	s0,16(sp)
    80002bb4:	e426                	sd	s1,8(sp)
    80002bb6:	e04a                	sd	s2,0(sp)
    80002bb8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bba:	c905                	beqz	a0,80002bea <iunlock+0x3c>
    80002bbc:	84aa                	mv	s1,a0
    80002bbe:	01050913          	addi	s2,a0,16
    80002bc2:	854a                	mv	a0,s2
    80002bc4:	00001097          	auipc	ra,0x1
    80002bc8:	c7c080e7          	jalr	-900(ra) # 80003840 <holdingsleep>
    80002bcc:	cd19                	beqz	a0,80002bea <iunlock+0x3c>
    80002bce:	449c                	lw	a5,8(s1)
    80002bd0:	00f05d63          	blez	a5,80002bea <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bd4:	854a                	mv	a0,s2
    80002bd6:	00001097          	auipc	ra,0x1
    80002bda:	c26080e7          	jalr	-986(ra) # 800037fc <releasesleep>
}
    80002bde:	60e2                	ld	ra,24(sp)
    80002be0:	6442                	ld	s0,16(sp)
    80002be2:	64a2                	ld	s1,8(sp)
    80002be4:	6902                	ld	s2,0(sp)
    80002be6:	6105                	addi	sp,sp,32
    80002be8:	8082                	ret
    panic("iunlock");
    80002bea:	00006517          	auipc	a0,0x6
    80002bee:	97e50513          	addi	a0,a0,-1666 # 80008568 <syscalls+0x198>
    80002bf2:	00003097          	auipc	ra,0x3
    80002bf6:	fac080e7          	jalr	-84(ra) # 80005b9e <panic>

0000000080002bfa <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bfa:	7179                	addi	sp,sp,-48
    80002bfc:	f406                	sd	ra,40(sp)
    80002bfe:	f022                	sd	s0,32(sp)
    80002c00:	ec26                	sd	s1,24(sp)
    80002c02:	e84a                	sd	s2,16(sp)
    80002c04:	e44e                	sd	s3,8(sp)
    80002c06:	e052                	sd	s4,0(sp)
    80002c08:	1800                	addi	s0,sp,48
    80002c0a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c0c:	05050493          	addi	s1,a0,80
    80002c10:	08050913          	addi	s2,a0,128
    80002c14:	a021                	j	80002c1c <itrunc+0x22>
    80002c16:	0491                	addi	s1,s1,4
    80002c18:	01248d63          	beq	s1,s2,80002c32 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c1c:	408c                	lw	a1,0(s1)
    80002c1e:	dde5                	beqz	a1,80002c16 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c20:	0009a503          	lw	a0,0(s3)
    80002c24:	00000097          	auipc	ra,0x0
    80002c28:	8f4080e7          	jalr	-1804(ra) # 80002518 <bfree>
      ip->addrs[i] = 0;
    80002c2c:	0004a023          	sw	zero,0(s1)
    80002c30:	b7dd                	j	80002c16 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c32:	0809a583          	lw	a1,128(s3)
    80002c36:	e185                	bnez	a1,80002c56 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c38:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c3c:	854e                	mv	a0,s3
    80002c3e:	00000097          	auipc	ra,0x0
    80002c42:	de4080e7          	jalr	-540(ra) # 80002a22 <iupdate>
}
    80002c46:	70a2                	ld	ra,40(sp)
    80002c48:	7402                	ld	s0,32(sp)
    80002c4a:	64e2                	ld	s1,24(sp)
    80002c4c:	6942                	ld	s2,16(sp)
    80002c4e:	69a2                	ld	s3,8(sp)
    80002c50:	6a02                	ld	s4,0(sp)
    80002c52:	6145                	addi	sp,sp,48
    80002c54:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c56:	0009a503          	lw	a0,0(s3)
    80002c5a:	fffff097          	auipc	ra,0xfffff
    80002c5e:	678080e7          	jalr	1656(ra) # 800022d2 <bread>
    80002c62:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c64:	05850493          	addi	s1,a0,88
    80002c68:	45850913          	addi	s2,a0,1112
    80002c6c:	a021                	j	80002c74 <itrunc+0x7a>
    80002c6e:	0491                	addi	s1,s1,4
    80002c70:	01248b63          	beq	s1,s2,80002c86 <itrunc+0x8c>
      if(a[j])
    80002c74:	408c                	lw	a1,0(s1)
    80002c76:	dde5                	beqz	a1,80002c6e <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002c78:	0009a503          	lw	a0,0(s3)
    80002c7c:	00000097          	auipc	ra,0x0
    80002c80:	89c080e7          	jalr	-1892(ra) # 80002518 <bfree>
    80002c84:	b7ed                	j	80002c6e <itrunc+0x74>
    brelse(bp);
    80002c86:	8552                	mv	a0,s4
    80002c88:	fffff097          	auipc	ra,0xfffff
    80002c8c:	77a080e7          	jalr	1914(ra) # 80002402 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c90:	0809a583          	lw	a1,128(s3)
    80002c94:	0009a503          	lw	a0,0(s3)
    80002c98:	00000097          	auipc	ra,0x0
    80002c9c:	880080e7          	jalr	-1920(ra) # 80002518 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ca0:	0809a023          	sw	zero,128(s3)
    80002ca4:	bf51                	j	80002c38 <itrunc+0x3e>

0000000080002ca6 <iput>:
{
    80002ca6:	1101                	addi	sp,sp,-32
    80002ca8:	ec06                	sd	ra,24(sp)
    80002caa:	e822                	sd	s0,16(sp)
    80002cac:	e426                	sd	s1,8(sp)
    80002cae:	e04a                	sd	s2,0(sp)
    80002cb0:	1000                	addi	s0,sp,32
    80002cb2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cb4:	00014517          	auipc	a0,0x14
    80002cb8:	35450513          	addi	a0,a0,852 # 80017008 <itable>
    80002cbc:	00003097          	auipc	ra,0x3
    80002cc0:	41e080e7          	jalr	1054(ra) # 800060da <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cc4:	4498                	lw	a4,8(s1)
    80002cc6:	4785                	li	a5,1
    80002cc8:	02f70363          	beq	a4,a5,80002cee <iput+0x48>
  ip->ref--;
    80002ccc:	449c                	lw	a5,8(s1)
    80002cce:	37fd                	addiw	a5,a5,-1
    80002cd0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cd2:	00014517          	auipc	a0,0x14
    80002cd6:	33650513          	addi	a0,a0,822 # 80017008 <itable>
    80002cda:	00003097          	auipc	ra,0x3
    80002cde:	4b4080e7          	jalr	1204(ra) # 8000618e <release>
}
    80002ce2:	60e2                	ld	ra,24(sp)
    80002ce4:	6442                	ld	s0,16(sp)
    80002ce6:	64a2                	ld	s1,8(sp)
    80002ce8:	6902                	ld	s2,0(sp)
    80002cea:	6105                	addi	sp,sp,32
    80002cec:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cee:	40bc                	lw	a5,64(s1)
    80002cf0:	dff1                	beqz	a5,80002ccc <iput+0x26>
    80002cf2:	04a49783          	lh	a5,74(s1)
    80002cf6:	fbf9                	bnez	a5,80002ccc <iput+0x26>
    acquiresleep(&ip->lock);
    80002cf8:	01048913          	addi	s2,s1,16
    80002cfc:	854a                	mv	a0,s2
    80002cfe:	00001097          	auipc	ra,0x1
    80002d02:	aa8080e7          	jalr	-1368(ra) # 800037a6 <acquiresleep>
    release(&itable.lock);
    80002d06:	00014517          	auipc	a0,0x14
    80002d0a:	30250513          	addi	a0,a0,770 # 80017008 <itable>
    80002d0e:	00003097          	auipc	ra,0x3
    80002d12:	480080e7          	jalr	1152(ra) # 8000618e <release>
    itrunc(ip);
    80002d16:	8526                	mv	a0,s1
    80002d18:	00000097          	auipc	ra,0x0
    80002d1c:	ee2080e7          	jalr	-286(ra) # 80002bfa <itrunc>
    ip->type = 0;
    80002d20:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d24:	8526                	mv	a0,s1
    80002d26:	00000097          	auipc	ra,0x0
    80002d2a:	cfc080e7          	jalr	-772(ra) # 80002a22 <iupdate>
    ip->valid = 0;
    80002d2e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d32:	854a                	mv	a0,s2
    80002d34:	00001097          	auipc	ra,0x1
    80002d38:	ac8080e7          	jalr	-1336(ra) # 800037fc <releasesleep>
    acquire(&itable.lock);
    80002d3c:	00014517          	auipc	a0,0x14
    80002d40:	2cc50513          	addi	a0,a0,716 # 80017008 <itable>
    80002d44:	00003097          	auipc	ra,0x3
    80002d48:	396080e7          	jalr	918(ra) # 800060da <acquire>
    80002d4c:	b741                	j	80002ccc <iput+0x26>

0000000080002d4e <iunlockput>:
{
    80002d4e:	1101                	addi	sp,sp,-32
    80002d50:	ec06                	sd	ra,24(sp)
    80002d52:	e822                	sd	s0,16(sp)
    80002d54:	e426                	sd	s1,8(sp)
    80002d56:	1000                	addi	s0,sp,32
    80002d58:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d5a:	00000097          	auipc	ra,0x0
    80002d5e:	e54080e7          	jalr	-428(ra) # 80002bae <iunlock>
  iput(ip);
    80002d62:	8526                	mv	a0,s1
    80002d64:	00000097          	auipc	ra,0x0
    80002d68:	f42080e7          	jalr	-190(ra) # 80002ca6 <iput>
}
    80002d6c:	60e2                	ld	ra,24(sp)
    80002d6e:	6442                	ld	s0,16(sp)
    80002d70:	64a2                	ld	s1,8(sp)
    80002d72:	6105                	addi	sp,sp,32
    80002d74:	8082                	ret

0000000080002d76 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d76:	1141                	addi	sp,sp,-16
    80002d78:	e422                	sd	s0,8(sp)
    80002d7a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d7c:	411c                	lw	a5,0(a0)
    80002d7e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d80:	415c                	lw	a5,4(a0)
    80002d82:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d84:	04451783          	lh	a5,68(a0)
    80002d88:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d8c:	04a51783          	lh	a5,74(a0)
    80002d90:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d94:	04c56783          	lwu	a5,76(a0)
    80002d98:	e99c                	sd	a5,16(a1)
}
    80002d9a:	6422                	ld	s0,8(sp)
    80002d9c:	0141                	addi	sp,sp,16
    80002d9e:	8082                	ret

0000000080002da0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002da0:	457c                	lw	a5,76(a0)
    80002da2:	0ed7e963          	bltu	a5,a3,80002e94 <readi+0xf4>
{
    80002da6:	7159                	addi	sp,sp,-112
    80002da8:	f486                	sd	ra,104(sp)
    80002daa:	f0a2                	sd	s0,96(sp)
    80002dac:	eca6                	sd	s1,88(sp)
    80002dae:	e8ca                	sd	s2,80(sp)
    80002db0:	e4ce                	sd	s3,72(sp)
    80002db2:	e0d2                	sd	s4,64(sp)
    80002db4:	fc56                	sd	s5,56(sp)
    80002db6:	f85a                	sd	s6,48(sp)
    80002db8:	f45e                	sd	s7,40(sp)
    80002dba:	f062                	sd	s8,32(sp)
    80002dbc:	ec66                	sd	s9,24(sp)
    80002dbe:	e86a                	sd	s10,16(sp)
    80002dc0:	e46e                	sd	s11,8(sp)
    80002dc2:	1880                	addi	s0,sp,112
    80002dc4:	8b2a                	mv	s6,a0
    80002dc6:	8bae                	mv	s7,a1
    80002dc8:	8a32                	mv	s4,a2
    80002dca:	84b6                	mv	s1,a3
    80002dcc:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002dce:	9f35                	addw	a4,a4,a3
    return 0;
    80002dd0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dd2:	0ad76063          	bltu	a4,a3,80002e72 <readi+0xd2>
  if(off + n > ip->size)
    80002dd6:	00e7f463          	bgeu	a5,a4,80002dde <readi+0x3e>
    n = ip->size - off;
    80002dda:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dde:	0a0a8963          	beqz	s5,80002e90 <readi+0xf0>
    80002de2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002de4:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002de8:	5c7d                	li	s8,-1
    80002dea:	a82d                	j	80002e24 <readi+0x84>
    80002dec:	020d1d93          	slli	s11,s10,0x20
    80002df0:	020ddd93          	srli	s11,s11,0x20
    80002df4:	05890793          	addi	a5,s2,88
    80002df8:	86ee                	mv	a3,s11
    80002dfa:	963e                	add	a2,a2,a5
    80002dfc:	85d2                	mv	a1,s4
    80002dfe:	855e                	mv	a0,s7
    80002e00:	fffff097          	auipc	ra,0xfffff
    80002e04:	b0e080e7          	jalr	-1266(ra) # 8000190e <either_copyout>
    80002e08:	05850d63          	beq	a0,s8,80002e62 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e0c:	854a                	mv	a0,s2
    80002e0e:	fffff097          	auipc	ra,0xfffff
    80002e12:	5f4080e7          	jalr	1524(ra) # 80002402 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e16:	013d09bb          	addw	s3,s10,s3
    80002e1a:	009d04bb          	addw	s1,s10,s1
    80002e1e:	9a6e                	add	s4,s4,s11
    80002e20:	0559f763          	bgeu	s3,s5,80002e6e <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e24:	00a4d59b          	srliw	a1,s1,0xa
    80002e28:	855a                	mv	a0,s6
    80002e2a:	00000097          	auipc	ra,0x0
    80002e2e:	8a2080e7          	jalr	-1886(ra) # 800026cc <bmap>
    80002e32:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e36:	cd85                	beqz	a1,80002e6e <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e38:	000b2503          	lw	a0,0(s6)
    80002e3c:	fffff097          	auipc	ra,0xfffff
    80002e40:	496080e7          	jalr	1174(ra) # 800022d2 <bread>
    80002e44:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e46:	3ff4f613          	andi	a2,s1,1023
    80002e4a:	40cc87bb          	subw	a5,s9,a2
    80002e4e:	413a873b          	subw	a4,s5,s3
    80002e52:	8d3e                	mv	s10,a5
    80002e54:	2781                	sext.w	a5,a5
    80002e56:	0007069b          	sext.w	a3,a4
    80002e5a:	f8f6f9e3          	bgeu	a3,a5,80002dec <readi+0x4c>
    80002e5e:	8d3a                	mv	s10,a4
    80002e60:	b771                	j	80002dec <readi+0x4c>
      brelse(bp);
    80002e62:	854a                	mv	a0,s2
    80002e64:	fffff097          	auipc	ra,0xfffff
    80002e68:	59e080e7          	jalr	1438(ra) # 80002402 <brelse>
      tot = -1;
    80002e6c:	59fd                	li	s3,-1
  }
  return tot;
    80002e6e:	0009851b          	sext.w	a0,s3
}
    80002e72:	70a6                	ld	ra,104(sp)
    80002e74:	7406                	ld	s0,96(sp)
    80002e76:	64e6                	ld	s1,88(sp)
    80002e78:	6946                	ld	s2,80(sp)
    80002e7a:	69a6                	ld	s3,72(sp)
    80002e7c:	6a06                	ld	s4,64(sp)
    80002e7e:	7ae2                	ld	s5,56(sp)
    80002e80:	7b42                	ld	s6,48(sp)
    80002e82:	7ba2                	ld	s7,40(sp)
    80002e84:	7c02                	ld	s8,32(sp)
    80002e86:	6ce2                	ld	s9,24(sp)
    80002e88:	6d42                	ld	s10,16(sp)
    80002e8a:	6da2                	ld	s11,8(sp)
    80002e8c:	6165                	addi	sp,sp,112
    80002e8e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e90:	89d6                	mv	s3,s5
    80002e92:	bff1                	j	80002e6e <readi+0xce>
    return 0;
    80002e94:	4501                	li	a0,0
}
    80002e96:	8082                	ret

0000000080002e98 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e98:	457c                	lw	a5,76(a0)
    80002e9a:	10d7e863          	bltu	a5,a3,80002faa <writei+0x112>
{
    80002e9e:	7159                	addi	sp,sp,-112
    80002ea0:	f486                	sd	ra,104(sp)
    80002ea2:	f0a2                	sd	s0,96(sp)
    80002ea4:	eca6                	sd	s1,88(sp)
    80002ea6:	e8ca                	sd	s2,80(sp)
    80002ea8:	e4ce                	sd	s3,72(sp)
    80002eaa:	e0d2                	sd	s4,64(sp)
    80002eac:	fc56                	sd	s5,56(sp)
    80002eae:	f85a                	sd	s6,48(sp)
    80002eb0:	f45e                	sd	s7,40(sp)
    80002eb2:	f062                	sd	s8,32(sp)
    80002eb4:	ec66                	sd	s9,24(sp)
    80002eb6:	e86a                	sd	s10,16(sp)
    80002eb8:	e46e                	sd	s11,8(sp)
    80002eba:	1880                	addi	s0,sp,112
    80002ebc:	8aaa                	mv	s5,a0
    80002ebe:	8bae                	mv	s7,a1
    80002ec0:	8a32                	mv	s4,a2
    80002ec2:	8936                	mv	s2,a3
    80002ec4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ec6:	00e687bb          	addw	a5,a3,a4
    80002eca:	0ed7e263          	bltu	a5,a3,80002fae <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ece:	00043737          	lui	a4,0x43
    80002ed2:	0ef76063          	bltu	a4,a5,80002fb2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ed6:	0c0b0863          	beqz	s6,80002fa6 <writei+0x10e>
    80002eda:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002edc:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ee0:	5c7d                	li	s8,-1
    80002ee2:	a091                	j	80002f26 <writei+0x8e>
    80002ee4:	020d1d93          	slli	s11,s10,0x20
    80002ee8:	020ddd93          	srli	s11,s11,0x20
    80002eec:	05848793          	addi	a5,s1,88
    80002ef0:	86ee                	mv	a3,s11
    80002ef2:	8652                	mv	a2,s4
    80002ef4:	85de                	mv	a1,s7
    80002ef6:	953e                	add	a0,a0,a5
    80002ef8:	fffff097          	auipc	ra,0xfffff
    80002efc:	a6c080e7          	jalr	-1428(ra) # 80001964 <either_copyin>
    80002f00:	07850263          	beq	a0,s8,80002f64 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f04:	8526                	mv	a0,s1
    80002f06:	00000097          	auipc	ra,0x0
    80002f0a:	780080e7          	jalr	1920(ra) # 80003686 <log_write>
    brelse(bp);
    80002f0e:	8526                	mv	a0,s1
    80002f10:	fffff097          	auipc	ra,0xfffff
    80002f14:	4f2080e7          	jalr	1266(ra) # 80002402 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f18:	013d09bb          	addw	s3,s10,s3
    80002f1c:	012d093b          	addw	s2,s10,s2
    80002f20:	9a6e                	add	s4,s4,s11
    80002f22:	0569f663          	bgeu	s3,s6,80002f6e <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f26:	00a9559b          	srliw	a1,s2,0xa
    80002f2a:	8556                	mv	a0,s5
    80002f2c:	fffff097          	auipc	ra,0xfffff
    80002f30:	7a0080e7          	jalr	1952(ra) # 800026cc <bmap>
    80002f34:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f38:	c99d                	beqz	a1,80002f6e <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f3a:	000aa503          	lw	a0,0(s5)
    80002f3e:	fffff097          	auipc	ra,0xfffff
    80002f42:	394080e7          	jalr	916(ra) # 800022d2 <bread>
    80002f46:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f48:	3ff97513          	andi	a0,s2,1023
    80002f4c:	40ac87bb          	subw	a5,s9,a0
    80002f50:	413b073b          	subw	a4,s6,s3
    80002f54:	8d3e                	mv	s10,a5
    80002f56:	2781                	sext.w	a5,a5
    80002f58:	0007069b          	sext.w	a3,a4
    80002f5c:	f8f6f4e3          	bgeu	a3,a5,80002ee4 <writei+0x4c>
    80002f60:	8d3a                	mv	s10,a4
    80002f62:	b749                	j	80002ee4 <writei+0x4c>
      brelse(bp);
    80002f64:	8526                	mv	a0,s1
    80002f66:	fffff097          	auipc	ra,0xfffff
    80002f6a:	49c080e7          	jalr	1180(ra) # 80002402 <brelse>
  }

  if(off > ip->size)
    80002f6e:	04caa783          	lw	a5,76(s5)
    80002f72:	0127f463          	bgeu	a5,s2,80002f7a <writei+0xe2>
    ip->size = off;
    80002f76:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f7a:	8556                	mv	a0,s5
    80002f7c:	00000097          	auipc	ra,0x0
    80002f80:	aa6080e7          	jalr	-1370(ra) # 80002a22 <iupdate>

  return tot;
    80002f84:	0009851b          	sext.w	a0,s3
}
    80002f88:	70a6                	ld	ra,104(sp)
    80002f8a:	7406                	ld	s0,96(sp)
    80002f8c:	64e6                	ld	s1,88(sp)
    80002f8e:	6946                	ld	s2,80(sp)
    80002f90:	69a6                	ld	s3,72(sp)
    80002f92:	6a06                	ld	s4,64(sp)
    80002f94:	7ae2                	ld	s5,56(sp)
    80002f96:	7b42                	ld	s6,48(sp)
    80002f98:	7ba2                	ld	s7,40(sp)
    80002f9a:	7c02                	ld	s8,32(sp)
    80002f9c:	6ce2                	ld	s9,24(sp)
    80002f9e:	6d42                	ld	s10,16(sp)
    80002fa0:	6da2                	ld	s11,8(sp)
    80002fa2:	6165                	addi	sp,sp,112
    80002fa4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fa6:	89da                	mv	s3,s6
    80002fa8:	bfc9                	j	80002f7a <writei+0xe2>
    return -1;
    80002faa:	557d                	li	a0,-1
}
    80002fac:	8082                	ret
    return -1;
    80002fae:	557d                	li	a0,-1
    80002fb0:	bfe1                	j	80002f88 <writei+0xf0>
    return -1;
    80002fb2:	557d                	li	a0,-1
    80002fb4:	bfd1                	j	80002f88 <writei+0xf0>

0000000080002fb6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fb6:	1141                	addi	sp,sp,-16
    80002fb8:	e406                	sd	ra,8(sp)
    80002fba:	e022                	sd	s0,0(sp)
    80002fbc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fbe:	4639                	li	a2,14
    80002fc0:	ffffd097          	auipc	ra,0xffffd
    80002fc4:	288080e7          	jalr	648(ra) # 80000248 <strncmp>
}
    80002fc8:	60a2                	ld	ra,8(sp)
    80002fca:	6402                	ld	s0,0(sp)
    80002fcc:	0141                	addi	sp,sp,16
    80002fce:	8082                	ret

0000000080002fd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fd0:	7139                	addi	sp,sp,-64
    80002fd2:	fc06                	sd	ra,56(sp)
    80002fd4:	f822                	sd	s0,48(sp)
    80002fd6:	f426                	sd	s1,40(sp)
    80002fd8:	f04a                	sd	s2,32(sp)
    80002fda:	ec4e                	sd	s3,24(sp)
    80002fdc:	e852                	sd	s4,16(sp)
    80002fde:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fe0:	04451703          	lh	a4,68(a0)
    80002fe4:	4785                	li	a5,1
    80002fe6:	00f71a63          	bne	a4,a5,80002ffa <dirlookup+0x2a>
    80002fea:	892a                	mv	s2,a0
    80002fec:	89ae                	mv	s3,a1
    80002fee:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ff0:	457c                	lw	a5,76(a0)
    80002ff2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ff4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ff6:	e79d                	bnez	a5,80003024 <dirlookup+0x54>
    80002ff8:	a8a5                	j	80003070 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002ffa:	00005517          	auipc	a0,0x5
    80002ffe:	57650513          	addi	a0,a0,1398 # 80008570 <syscalls+0x1a0>
    80003002:	00003097          	auipc	ra,0x3
    80003006:	b9c080e7          	jalr	-1124(ra) # 80005b9e <panic>
      panic("dirlookup read");
    8000300a:	00005517          	auipc	a0,0x5
    8000300e:	57e50513          	addi	a0,a0,1406 # 80008588 <syscalls+0x1b8>
    80003012:	00003097          	auipc	ra,0x3
    80003016:	b8c080e7          	jalr	-1140(ra) # 80005b9e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000301a:	24c1                	addiw	s1,s1,16
    8000301c:	04c92783          	lw	a5,76(s2)
    80003020:	04f4f763          	bgeu	s1,a5,8000306e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003024:	4741                	li	a4,16
    80003026:	86a6                	mv	a3,s1
    80003028:	fc040613          	addi	a2,s0,-64
    8000302c:	4581                	li	a1,0
    8000302e:	854a                	mv	a0,s2
    80003030:	00000097          	auipc	ra,0x0
    80003034:	d70080e7          	jalr	-656(ra) # 80002da0 <readi>
    80003038:	47c1                	li	a5,16
    8000303a:	fcf518e3          	bne	a0,a5,8000300a <dirlookup+0x3a>
    if(de.inum == 0)
    8000303e:	fc045783          	lhu	a5,-64(s0)
    80003042:	dfe1                	beqz	a5,8000301a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003044:	fc240593          	addi	a1,s0,-62
    80003048:	854e                	mv	a0,s3
    8000304a:	00000097          	auipc	ra,0x0
    8000304e:	f6c080e7          	jalr	-148(ra) # 80002fb6 <namecmp>
    80003052:	f561                	bnez	a0,8000301a <dirlookup+0x4a>
      if(poff)
    80003054:	000a0463          	beqz	s4,8000305c <dirlookup+0x8c>
        *poff = off;
    80003058:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000305c:	fc045583          	lhu	a1,-64(s0)
    80003060:	00092503          	lw	a0,0(s2)
    80003064:	fffff097          	auipc	ra,0xfffff
    80003068:	750080e7          	jalr	1872(ra) # 800027b4 <iget>
    8000306c:	a011                	j	80003070 <dirlookup+0xa0>
  return 0;
    8000306e:	4501                	li	a0,0
}
    80003070:	70e2                	ld	ra,56(sp)
    80003072:	7442                	ld	s0,48(sp)
    80003074:	74a2                	ld	s1,40(sp)
    80003076:	7902                	ld	s2,32(sp)
    80003078:	69e2                	ld	s3,24(sp)
    8000307a:	6a42                	ld	s4,16(sp)
    8000307c:	6121                	addi	sp,sp,64
    8000307e:	8082                	ret

0000000080003080 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003080:	711d                	addi	sp,sp,-96
    80003082:	ec86                	sd	ra,88(sp)
    80003084:	e8a2                	sd	s0,80(sp)
    80003086:	e4a6                	sd	s1,72(sp)
    80003088:	e0ca                	sd	s2,64(sp)
    8000308a:	fc4e                	sd	s3,56(sp)
    8000308c:	f852                	sd	s4,48(sp)
    8000308e:	f456                	sd	s5,40(sp)
    80003090:	f05a                	sd	s6,32(sp)
    80003092:	ec5e                	sd	s7,24(sp)
    80003094:	e862                	sd	s8,16(sp)
    80003096:	e466                	sd	s9,8(sp)
    80003098:	1080                	addi	s0,sp,96
    8000309a:	84aa                	mv	s1,a0
    8000309c:	8aae                	mv	s5,a1
    8000309e:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030a0:	00054703          	lbu	a4,0(a0)
    800030a4:	02f00793          	li	a5,47
    800030a8:	02f70363          	beq	a4,a5,800030ce <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030ac:	ffffe097          	auipc	ra,0xffffe
    800030b0:	da6080e7          	jalr	-602(ra) # 80000e52 <myproc>
    800030b4:	15053503          	ld	a0,336(a0)
    800030b8:	00000097          	auipc	ra,0x0
    800030bc:	9f6080e7          	jalr	-1546(ra) # 80002aae <idup>
    800030c0:	89aa                	mv	s3,a0
  while(*path == '/')
    800030c2:	02f00913          	li	s2,47
  len = path - s;
    800030c6:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    800030c8:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030ca:	4b85                	li	s7,1
    800030cc:	a865                	j	80003184 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800030ce:	4585                	li	a1,1
    800030d0:	4505                	li	a0,1
    800030d2:	fffff097          	auipc	ra,0xfffff
    800030d6:	6e2080e7          	jalr	1762(ra) # 800027b4 <iget>
    800030da:	89aa                	mv	s3,a0
    800030dc:	b7dd                	j	800030c2 <namex+0x42>
      iunlockput(ip);
    800030de:	854e                	mv	a0,s3
    800030e0:	00000097          	auipc	ra,0x0
    800030e4:	c6e080e7          	jalr	-914(ra) # 80002d4e <iunlockput>
      return 0;
    800030e8:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030ea:	854e                	mv	a0,s3
    800030ec:	60e6                	ld	ra,88(sp)
    800030ee:	6446                	ld	s0,80(sp)
    800030f0:	64a6                	ld	s1,72(sp)
    800030f2:	6906                	ld	s2,64(sp)
    800030f4:	79e2                	ld	s3,56(sp)
    800030f6:	7a42                	ld	s4,48(sp)
    800030f8:	7aa2                	ld	s5,40(sp)
    800030fa:	7b02                	ld	s6,32(sp)
    800030fc:	6be2                	ld	s7,24(sp)
    800030fe:	6c42                	ld	s8,16(sp)
    80003100:	6ca2                	ld	s9,8(sp)
    80003102:	6125                	addi	sp,sp,96
    80003104:	8082                	ret
      iunlock(ip);
    80003106:	854e                	mv	a0,s3
    80003108:	00000097          	auipc	ra,0x0
    8000310c:	aa6080e7          	jalr	-1370(ra) # 80002bae <iunlock>
      return ip;
    80003110:	bfe9                	j	800030ea <namex+0x6a>
      iunlockput(ip);
    80003112:	854e                	mv	a0,s3
    80003114:	00000097          	auipc	ra,0x0
    80003118:	c3a080e7          	jalr	-966(ra) # 80002d4e <iunlockput>
      return 0;
    8000311c:	89e6                	mv	s3,s9
    8000311e:	b7f1                	j	800030ea <namex+0x6a>
  len = path - s;
    80003120:	40b48633          	sub	a2,s1,a1
    80003124:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003128:	099c5463          	bge	s8,s9,800031b0 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000312c:	4639                	li	a2,14
    8000312e:	8552                	mv	a0,s4
    80003130:	ffffd097          	auipc	ra,0xffffd
    80003134:	0a4080e7          	jalr	164(ra) # 800001d4 <memmove>
  while(*path == '/')
    80003138:	0004c783          	lbu	a5,0(s1)
    8000313c:	01279763          	bne	a5,s2,8000314a <namex+0xca>
    path++;
    80003140:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003142:	0004c783          	lbu	a5,0(s1)
    80003146:	ff278de3          	beq	a5,s2,80003140 <namex+0xc0>
    ilock(ip);
    8000314a:	854e                	mv	a0,s3
    8000314c:	00000097          	auipc	ra,0x0
    80003150:	9a0080e7          	jalr	-1632(ra) # 80002aec <ilock>
    if(ip->type != T_DIR){
    80003154:	04499783          	lh	a5,68(s3)
    80003158:	f97793e3          	bne	a5,s7,800030de <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000315c:	000a8563          	beqz	s5,80003166 <namex+0xe6>
    80003160:	0004c783          	lbu	a5,0(s1)
    80003164:	d3cd                	beqz	a5,80003106 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003166:	865a                	mv	a2,s6
    80003168:	85d2                	mv	a1,s4
    8000316a:	854e                	mv	a0,s3
    8000316c:	00000097          	auipc	ra,0x0
    80003170:	e64080e7          	jalr	-412(ra) # 80002fd0 <dirlookup>
    80003174:	8caa                	mv	s9,a0
    80003176:	dd51                	beqz	a0,80003112 <namex+0x92>
    iunlockput(ip);
    80003178:	854e                	mv	a0,s3
    8000317a:	00000097          	auipc	ra,0x0
    8000317e:	bd4080e7          	jalr	-1068(ra) # 80002d4e <iunlockput>
    ip = next;
    80003182:	89e6                	mv	s3,s9
  while(*path == '/')
    80003184:	0004c783          	lbu	a5,0(s1)
    80003188:	05279763          	bne	a5,s2,800031d6 <namex+0x156>
    path++;
    8000318c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000318e:	0004c783          	lbu	a5,0(s1)
    80003192:	ff278de3          	beq	a5,s2,8000318c <namex+0x10c>
  if(*path == 0)
    80003196:	c79d                	beqz	a5,800031c4 <namex+0x144>
    path++;
    80003198:	85a6                	mv	a1,s1
  len = path - s;
    8000319a:	8cda                	mv	s9,s6
    8000319c:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    8000319e:	01278963          	beq	a5,s2,800031b0 <namex+0x130>
    800031a2:	dfbd                	beqz	a5,80003120 <namex+0xa0>
    path++;
    800031a4:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800031a6:	0004c783          	lbu	a5,0(s1)
    800031aa:	ff279ce3          	bne	a5,s2,800031a2 <namex+0x122>
    800031ae:	bf8d                	j	80003120 <namex+0xa0>
    memmove(name, s, len);
    800031b0:	2601                	sext.w	a2,a2
    800031b2:	8552                	mv	a0,s4
    800031b4:	ffffd097          	auipc	ra,0xffffd
    800031b8:	020080e7          	jalr	32(ra) # 800001d4 <memmove>
    name[len] = 0;
    800031bc:	9cd2                	add	s9,s9,s4
    800031be:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800031c2:	bf9d                	j	80003138 <namex+0xb8>
  if(nameiparent){
    800031c4:	f20a83e3          	beqz	s5,800030ea <namex+0x6a>
    iput(ip);
    800031c8:	854e                	mv	a0,s3
    800031ca:	00000097          	auipc	ra,0x0
    800031ce:	adc080e7          	jalr	-1316(ra) # 80002ca6 <iput>
    return 0;
    800031d2:	4981                	li	s3,0
    800031d4:	bf19                	j	800030ea <namex+0x6a>
  if(*path == 0)
    800031d6:	d7fd                	beqz	a5,800031c4 <namex+0x144>
  while(*path != '/' && *path != 0)
    800031d8:	0004c783          	lbu	a5,0(s1)
    800031dc:	85a6                	mv	a1,s1
    800031de:	b7d1                	j	800031a2 <namex+0x122>

00000000800031e0 <dirlink>:
{
    800031e0:	7139                	addi	sp,sp,-64
    800031e2:	fc06                	sd	ra,56(sp)
    800031e4:	f822                	sd	s0,48(sp)
    800031e6:	f426                	sd	s1,40(sp)
    800031e8:	f04a                	sd	s2,32(sp)
    800031ea:	ec4e                	sd	s3,24(sp)
    800031ec:	e852                	sd	s4,16(sp)
    800031ee:	0080                	addi	s0,sp,64
    800031f0:	892a                	mv	s2,a0
    800031f2:	8a2e                	mv	s4,a1
    800031f4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031f6:	4601                	li	a2,0
    800031f8:	00000097          	auipc	ra,0x0
    800031fc:	dd8080e7          	jalr	-552(ra) # 80002fd0 <dirlookup>
    80003200:	e93d                	bnez	a0,80003276 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003202:	04c92483          	lw	s1,76(s2)
    80003206:	c49d                	beqz	s1,80003234 <dirlink+0x54>
    80003208:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000320a:	4741                	li	a4,16
    8000320c:	86a6                	mv	a3,s1
    8000320e:	fc040613          	addi	a2,s0,-64
    80003212:	4581                	li	a1,0
    80003214:	854a                	mv	a0,s2
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	b8a080e7          	jalr	-1142(ra) # 80002da0 <readi>
    8000321e:	47c1                	li	a5,16
    80003220:	06f51163          	bne	a0,a5,80003282 <dirlink+0xa2>
    if(de.inum == 0)
    80003224:	fc045783          	lhu	a5,-64(s0)
    80003228:	c791                	beqz	a5,80003234 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000322a:	24c1                	addiw	s1,s1,16
    8000322c:	04c92783          	lw	a5,76(s2)
    80003230:	fcf4ede3          	bltu	s1,a5,8000320a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003234:	4639                	li	a2,14
    80003236:	85d2                	mv	a1,s4
    80003238:	fc240513          	addi	a0,s0,-62
    8000323c:	ffffd097          	auipc	ra,0xffffd
    80003240:	048080e7          	jalr	72(ra) # 80000284 <strncpy>
  de.inum = inum;
    80003244:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003248:	4741                	li	a4,16
    8000324a:	86a6                	mv	a3,s1
    8000324c:	fc040613          	addi	a2,s0,-64
    80003250:	4581                	li	a1,0
    80003252:	854a                	mv	a0,s2
    80003254:	00000097          	auipc	ra,0x0
    80003258:	c44080e7          	jalr	-956(ra) # 80002e98 <writei>
    8000325c:	1541                	addi	a0,a0,-16
    8000325e:	00a03533          	snez	a0,a0
    80003262:	40a00533          	neg	a0,a0
}
    80003266:	70e2                	ld	ra,56(sp)
    80003268:	7442                	ld	s0,48(sp)
    8000326a:	74a2                	ld	s1,40(sp)
    8000326c:	7902                	ld	s2,32(sp)
    8000326e:	69e2                	ld	s3,24(sp)
    80003270:	6a42                	ld	s4,16(sp)
    80003272:	6121                	addi	sp,sp,64
    80003274:	8082                	ret
    iput(ip);
    80003276:	00000097          	auipc	ra,0x0
    8000327a:	a30080e7          	jalr	-1488(ra) # 80002ca6 <iput>
    return -1;
    8000327e:	557d                	li	a0,-1
    80003280:	b7dd                	j	80003266 <dirlink+0x86>
      panic("dirlink read");
    80003282:	00005517          	auipc	a0,0x5
    80003286:	31650513          	addi	a0,a0,790 # 80008598 <syscalls+0x1c8>
    8000328a:	00003097          	auipc	ra,0x3
    8000328e:	914080e7          	jalr	-1772(ra) # 80005b9e <panic>

0000000080003292 <namei>:

struct inode*
namei(char *path)
{
    80003292:	1101                	addi	sp,sp,-32
    80003294:	ec06                	sd	ra,24(sp)
    80003296:	e822                	sd	s0,16(sp)
    80003298:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000329a:	fe040613          	addi	a2,s0,-32
    8000329e:	4581                	li	a1,0
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	de0080e7          	jalr	-544(ra) # 80003080 <namex>
}
    800032a8:	60e2                	ld	ra,24(sp)
    800032aa:	6442                	ld	s0,16(sp)
    800032ac:	6105                	addi	sp,sp,32
    800032ae:	8082                	ret

00000000800032b0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032b0:	1141                	addi	sp,sp,-16
    800032b2:	e406                	sd	ra,8(sp)
    800032b4:	e022                	sd	s0,0(sp)
    800032b6:	0800                	addi	s0,sp,16
    800032b8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032ba:	4585                	li	a1,1
    800032bc:	00000097          	auipc	ra,0x0
    800032c0:	dc4080e7          	jalr	-572(ra) # 80003080 <namex>
}
    800032c4:	60a2                	ld	ra,8(sp)
    800032c6:	6402                	ld	s0,0(sp)
    800032c8:	0141                	addi	sp,sp,16
    800032ca:	8082                	ret

00000000800032cc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032cc:	1101                	addi	sp,sp,-32
    800032ce:	ec06                	sd	ra,24(sp)
    800032d0:	e822                	sd	s0,16(sp)
    800032d2:	e426                	sd	s1,8(sp)
    800032d4:	e04a                	sd	s2,0(sp)
    800032d6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032d8:	00015917          	auipc	s2,0x15
    800032dc:	7d890913          	addi	s2,s2,2008 # 80018ab0 <log>
    800032e0:	01892583          	lw	a1,24(s2)
    800032e4:	02892503          	lw	a0,40(s2)
    800032e8:	fffff097          	auipc	ra,0xfffff
    800032ec:	fea080e7          	jalr	-22(ra) # 800022d2 <bread>
    800032f0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032f2:	02c92683          	lw	a3,44(s2)
    800032f6:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032f8:	02d05763          	blez	a3,80003326 <write_head+0x5a>
    800032fc:	00015797          	auipc	a5,0x15
    80003300:	7e478793          	addi	a5,a5,2020 # 80018ae0 <log+0x30>
    80003304:	05c50713          	addi	a4,a0,92
    80003308:	36fd                	addiw	a3,a3,-1
    8000330a:	1682                	slli	a3,a3,0x20
    8000330c:	9281                	srli	a3,a3,0x20
    8000330e:	068a                	slli	a3,a3,0x2
    80003310:	00015617          	auipc	a2,0x15
    80003314:	7d460613          	addi	a2,a2,2004 # 80018ae4 <log+0x34>
    80003318:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000331a:	4390                	lw	a2,0(a5)
    8000331c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000331e:	0791                	addi	a5,a5,4
    80003320:	0711                	addi	a4,a4,4
    80003322:	fed79ce3          	bne	a5,a3,8000331a <write_head+0x4e>
  }
  bwrite(buf);
    80003326:	8526                	mv	a0,s1
    80003328:	fffff097          	auipc	ra,0xfffff
    8000332c:	09c080e7          	jalr	156(ra) # 800023c4 <bwrite>
  brelse(buf);
    80003330:	8526                	mv	a0,s1
    80003332:	fffff097          	auipc	ra,0xfffff
    80003336:	0d0080e7          	jalr	208(ra) # 80002402 <brelse>
}
    8000333a:	60e2                	ld	ra,24(sp)
    8000333c:	6442                	ld	s0,16(sp)
    8000333e:	64a2                	ld	s1,8(sp)
    80003340:	6902                	ld	s2,0(sp)
    80003342:	6105                	addi	sp,sp,32
    80003344:	8082                	ret

0000000080003346 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003346:	00015797          	auipc	a5,0x15
    8000334a:	7967a783          	lw	a5,1942(a5) # 80018adc <log+0x2c>
    8000334e:	0af05d63          	blez	a5,80003408 <install_trans+0xc2>
{
    80003352:	7139                	addi	sp,sp,-64
    80003354:	fc06                	sd	ra,56(sp)
    80003356:	f822                	sd	s0,48(sp)
    80003358:	f426                	sd	s1,40(sp)
    8000335a:	f04a                	sd	s2,32(sp)
    8000335c:	ec4e                	sd	s3,24(sp)
    8000335e:	e852                	sd	s4,16(sp)
    80003360:	e456                	sd	s5,8(sp)
    80003362:	e05a                	sd	s6,0(sp)
    80003364:	0080                	addi	s0,sp,64
    80003366:	8b2a                	mv	s6,a0
    80003368:	00015a97          	auipc	s5,0x15
    8000336c:	778a8a93          	addi	s5,s5,1912 # 80018ae0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003370:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003372:	00015997          	auipc	s3,0x15
    80003376:	73e98993          	addi	s3,s3,1854 # 80018ab0 <log>
    8000337a:	a00d                	j	8000339c <install_trans+0x56>
    brelse(lbuf);
    8000337c:	854a                	mv	a0,s2
    8000337e:	fffff097          	auipc	ra,0xfffff
    80003382:	084080e7          	jalr	132(ra) # 80002402 <brelse>
    brelse(dbuf);
    80003386:	8526                	mv	a0,s1
    80003388:	fffff097          	auipc	ra,0xfffff
    8000338c:	07a080e7          	jalr	122(ra) # 80002402 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003390:	2a05                	addiw	s4,s4,1
    80003392:	0a91                	addi	s5,s5,4
    80003394:	02c9a783          	lw	a5,44(s3)
    80003398:	04fa5e63          	bge	s4,a5,800033f4 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000339c:	0189a583          	lw	a1,24(s3)
    800033a0:	014585bb          	addw	a1,a1,s4
    800033a4:	2585                	addiw	a1,a1,1
    800033a6:	0289a503          	lw	a0,40(s3)
    800033aa:	fffff097          	auipc	ra,0xfffff
    800033ae:	f28080e7          	jalr	-216(ra) # 800022d2 <bread>
    800033b2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033b4:	000aa583          	lw	a1,0(s5)
    800033b8:	0289a503          	lw	a0,40(s3)
    800033bc:	fffff097          	auipc	ra,0xfffff
    800033c0:	f16080e7          	jalr	-234(ra) # 800022d2 <bread>
    800033c4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033c6:	40000613          	li	a2,1024
    800033ca:	05890593          	addi	a1,s2,88
    800033ce:	05850513          	addi	a0,a0,88
    800033d2:	ffffd097          	auipc	ra,0xffffd
    800033d6:	e02080e7          	jalr	-510(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033da:	8526                	mv	a0,s1
    800033dc:	fffff097          	auipc	ra,0xfffff
    800033e0:	fe8080e7          	jalr	-24(ra) # 800023c4 <bwrite>
    if(recovering == 0)
    800033e4:	f80b1ce3          	bnez	s6,8000337c <install_trans+0x36>
      bunpin(dbuf);
    800033e8:	8526                	mv	a0,s1
    800033ea:	fffff097          	auipc	ra,0xfffff
    800033ee:	0f2080e7          	jalr	242(ra) # 800024dc <bunpin>
    800033f2:	b769                	j	8000337c <install_trans+0x36>
}
    800033f4:	70e2                	ld	ra,56(sp)
    800033f6:	7442                	ld	s0,48(sp)
    800033f8:	74a2                	ld	s1,40(sp)
    800033fa:	7902                	ld	s2,32(sp)
    800033fc:	69e2                	ld	s3,24(sp)
    800033fe:	6a42                	ld	s4,16(sp)
    80003400:	6aa2                	ld	s5,8(sp)
    80003402:	6b02                	ld	s6,0(sp)
    80003404:	6121                	addi	sp,sp,64
    80003406:	8082                	ret
    80003408:	8082                	ret

000000008000340a <initlog>:
{
    8000340a:	7179                	addi	sp,sp,-48
    8000340c:	f406                	sd	ra,40(sp)
    8000340e:	f022                	sd	s0,32(sp)
    80003410:	ec26                	sd	s1,24(sp)
    80003412:	e84a                	sd	s2,16(sp)
    80003414:	e44e                	sd	s3,8(sp)
    80003416:	1800                	addi	s0,sp,48
    80003418:	892a                	mv	s2,a0
    8000341a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000341c:	00015497          	auipc	s1,0x15
    80003420:	69448493          	addi	s1,s1,1684 # 80018ab0 <log>
    80003424:	00005597          	auipc	a1,0x5
    80003428:	18458593          	addi	a1,a1,388 # 800085a8 <syscalls+0x1d8>
    8000342c:	8526                	mv	a0,s1
    8000342e:	00003097          	auipc	ra,0x3
    80003432:	c1c080e7          	jalr	-996(ra) # 8000604a <initlock>
  log.start = sb->logstart;
    80003436:	0149a583          	lw	a1,20(s3)
    8000343a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000343c:	0109a783          	lw	a5,16(s3)
    80003440:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003442:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003446:	854a                	mv	a0,s2
    80003448:	fffff097          	auipc	ra,0xfffff
    8000344c:	e8a080e7          	jalr	-374(ra) # 800022d2 <bread>
  log.lh.n = lh->n;
    80003450:	4d34                	lw	a3,88(a0)
    80003452:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003454:	02d05563          	blez	a3,8000347e <initlog+0x74>
    80003458:	05c50793          	addi	a5,a0,92
    8000345c:	00015717          	auipc	a4,0x15
    80003460:	68470713          	addi	a4,a4,1668 # 80018ae0 <log+0x30>
    80003464:	36fd                	addiw	a3,a3,-1
    80003466:	1682                	slli	a3,a3,0x20
    80003468:	9281                	srli	a3,a3,0x20
    8000346a:	068a                	slli	a3,a3,0x2
    8000346c:	06050613          	addi	a2,a0,96
    80003470:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003472:	4390                	lw	a2,0(a5)
    80003474:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003476:	0791                	addi	a5,a5,4
    80003478:	0711                	addi	a4,a4,4
    8000347a:	fed79ce3          	bne	a5,a3,80003472 <initlog+0x68>
  brelse(buf);
    8000347e:	fffff097          	auipc	ra,0xfffff
    80003482:	f84080e7          	jalr	-124(ra) # 80002402 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003486:	4505                	li	a0,1
    80003488:	00000097          	auipc	ra,0x0
    8000348c:	ebe080e7          	jalr	-322(ra) # 80003346 <install_trans>
  log.lh.n = 0;
    80003490:	00015797          	auipc	a5,0x15
    80003494:	6407a623          	sw	zero,1612(a5) # 80018adc <log+0x2c>
  write_head(); // clear the log
    80003498:	00000097          	auipc	ra,0x0
    8000349c:	e34080e7          	jalr	-460(ra) # 800032cc <write_head>
}
    800034a0:	70a2                	ld	ra,40(sp)
    800034a2:	7402                	ld	s0,32(sp)
    800034a4:	64e2                	ld	s1,24(sp)
    800034a6:	6942                	ld	s2,16(sp)
    800034a8:	69a2                	ld	s3,8(sp)
    800034aa:	6145                	addi	sp,sp,48
    800034ac:	8082                	ret

00000000800034ae <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034ae:	1101                	addi	sp,sp,-32
    800034b0:	ec06                	sd	ra,24(sp)
    800034b2:	e822                	sd	s0,16(sp)
    800034b4:	e426                	sd	s1,8(sp)
    800034b6:	e04a                	sd	s2,0(sp)
    800034b8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034ba:	00015517          	auipc	a0,0x15
    800034be:	5f650513          	addi	a0,a0,1526 # 80018ab0 <log>
    800034c2:	00003097          	auipc	ra,0x3
    800034c6:	c18080e7          	jalr	-1000(ra) # 800060da <acquire>
  while(1){
    if(log.committing){
    800034ca:	00015497          	auipc	s1,0x15
    800034ce:	5e648493          	addi	s1,s1,1510 # 80018ab0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034d2:	4979                	li	s2,30
    800034d4:	a039                	j	800034e2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034d6:	85a6                	mv	a1,s1
    800034d8:	8526                	mv	a0,s1
    800034da:	ffffe097          	auipc	ra,0xffffe
    800034de:	02c080e7          	jalr	44(ra) # 80001506 <sleep>
    if(log.committing){
    800034e2:	50dc                	lw	a5,36(s1)
    800034e4:	fbed                	bnez	a5,800034d6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034e6:	509c                	lw	a5,32(s1)
    800034e8:	0017871b          	addiw	a4,a5,1
    800034ec:	0007069b          	sext.w	a3,a4
    800034f0:	0027179b          	slliw	a5,a4,0x2
    800034f4:	9fb9                	addw	a5,a5,a4
    800034f6:	0017979b          	slliw	a5,a5,0x1
    800034fa:	54d8                	lw	a4,44(s1)
    800034fc:	9fb9                	addw	a5,a5,a4
    800034fe:	00f95963          	bge	s2,a5,80003510 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003502:	85a6                	mv	a1,s1
    80003504:	8526                	mv	a0,s1
    80003506:	ffffe097          	auipc	ra,0xffffe
    8000350a:	000080e7          	jalr	ra # 80001506 <sleep>
    8000350e:	bfd1                	j	800034e2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003510:	00015517          	auipc	a0,0x15
    80003514:	5a050513          	addi	a0,a0,1440 # 80018ab0 <log>
    80003518:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000351a:	00003097          	auipc	ra,0x3
    8000351e:	c74080e7          	jalr	-908(ra) # 8000618e <release>
      break;
    }
  }
}
    80003522:	60e2                	ld	ra,24(sp)
    80003524:	6442                	ld	s0,16(sp)
    80003526:	64a2                	ld	s1,8(sp)
    80003528:	6902                	ld	s2,0(sp)
    8000352a:	6105                	addi	sp,sp,32
    8000352c:	8082                	ret

000000008000352e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000352e:	7139                	addi	sp,sp,-64
    80003530:	fc06                	sd	ra,56(sp)
    80003532:	f822                	sd	s0,48(sp)
    80003534:	f426                	sd	s1,40(sp)
    80003536:	f04a                	sd	s2,32(sp)
    80003538:	ec4e                	sd	s3,24(sp)
    8000353a:	e852                	sd	s4,16(sp)
    8000353c:	e456                	sd	s5,8(sp)
    8000353e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003540:	00015497          	auipc	s1,0x15
    80003544:	57048493          	addi	s1,s1,1392 # 80018ab0 <log>
    80003548:	8526                	mv	a0,s1
    8000354a:	00003097          	auipc	ra,0x3
    8000354e:	b90080e7          	jalr	-1136(ra) # 800060da <acquire>
  log.outstanding -= 1;
    80003552:	509c                	lw	a5,32(s1)
    80003554:	37fd                	addiw	a5,a5,-1
    80003556:	0007891b          	sext.w	s2,a5
    8000355a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000355c:	50dc                	lw	a5,36(s1)
    8000355e:	e7b9                	bnez	a5,800035ac <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003560:	04091e63          	bnez	s2,800035bc <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003564:	00015497          	auipc	s1,0x15
    80003568:	54c48493          	addi	s1,s1,1356 # 80018ab0 <log>
    8000356c:	4785                	li	a5,1
    8000356e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003570:	8526                	mv	a0,s1
    80003572:	00003097          	auipc	ra,0x3
    80003576:	c1c080e7          	jalr	-996(ra) # 8000618e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000357a:	54dc                	lw	a5,44(s1)
    8000357c:	06f04763          	bgtz	a5,800035ea <end_op+0xbc>
    acquire(&log.lock);
    80003580:	00015497          	auipc	s1,0x15
    80003584:	53048493          	addi	s1,s1,1328 # 80018ab0 <log>
    80003588:	8526                	mv	a0,s1
    8000358a:	00003097          	auipc	ra,0x3
    8000358e:	b50080e7          	jalr	-1200(ra) # 800060da <acquire>
    log.committing = 0;
    80003592:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003596:	8526                	mv	a0,s1
    80003598:	ffffe097          	auipc	ra,0xffffe
    8000359c:	fd2080e7          	jalr	-46(ra) # 8000156a <wakeup>
    release(&log.lock);
    800035a0:	8526                	mv	a0,s1
    800035a2:	00003097          	auipc	ra,0x3
    800035a6:	bec080e7          	jalr	-1044(ra) # 8000618e <release>
}
    800035aa:	a03d                	j	800035d8 <end_op+0xaa>
    panic("log.committing");
    800035ac:	00005517          	auipc	a0,0x5
    800035b0:	00450513          	addi	a0,a0,4 # 800085b0 <syscalls+0x1e0>
    800035b4:	00002097          	auipc	ra,0x2
    800035b8:	5ea080e7          	jalr	1514(ra) # 80005b9e <panic>
    wakeup(&log);
    800035bc:	00015497          	auipc	s1,0x15
    800035c0:	4f448493          	addi	s1,s1,1268 # 80018ab0 <log>
    800035c4:	8526                	mv	a0,s1
    800035c6:	ffffe097          	auipc	ra,0xffffe
    800035ca:	fa4080e7          	jalr	-92(ra) # 8000156a <wakeup>
  release(&log.lock);
    800035ce:	8526                	mv	a0,s1
    800035d0:	00003097          	auipc	ra,0x3
    800035d4:	bbe080e7          	jalr	-1090(ra) # 8000618e <release>
}
    800035d8:	70e2                	ld	ra,56(sp)
    800035da:	7442                	ld	s0,48(sp)
    800035dc:	74a2                	ld	s1,40(sp)
    800035de:	7902                	ld	s2,32(sp)
    800035e0:	69e2                	ld	s3,24(sp)
    800035e2:	6a42                	ld	s4,16(sp)
    800035e4:	6aa2                	ld	s5,8(sp)
    800035e6:	6121                	addi	sp,sp,64
    800035e8:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ea:	00015a97          	auipc	s5,0x15
    800035ee:	4f6a8a93          	addi	s5,s5,1270 # 80018ae0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035f2:	00015a17          	auipc	s4,0x15
    800035f6:	4bea0a13          	addi	s4,s4,1214 # 80018ab0 <log>
    800035fa:	018a2583          	lw	a1,24(s4)
    800035fe:	012585bb          	addw	a1,a1,s2
    80003602:	2585                	addiw	a1,a1,1
    80003604:	028a2503          	lw	a0,40(s4)
    80003608:	fffff097          	auipc	ra,0xfffff
    8000360c:	cca080e7          	jalr	-822(ra) # 800022d2 <bread>
    80003610:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003612:	000aa583          	lw	a1,0(s5)
    80003616:	028a2503          	lw	a0,40(s4)
    8000361a:	fffff097          	auipc	ra,0xfffff
    8000361e:	cb8080e7          	jalr	-840(ra) # 800022d2 <bread>
    80003622:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003624:	40000613          	li	a2,1024
    80003628:	05850593          	addi	a1,a0,88
    8000362c:	05848513          	addi	a0,s1,88
    80003630:	ffffd097          	auipc	ra,0xffffd
    80003634:	ba4080e7          	jalr	-1116(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    80003638:	8526                	mv	a0,s1
    8000363a:	fffff097          	auipc	ra,0xfffff
    8000363e:	d8a080e7          	jalr	-630(ra) # 800023c4 <bwrite>
    brelse(from);
    80003642:	854e                	mv	a0,s3
    80003644:	fffff097          	auipc	ra,0xfffff
    80003648:	dbe080e7          	jalr	-578(ra) # 80002402 <brelse>
    brelse(to);
    8000364c:	8526                	mv	a0,s1
    8000364e:	fffff097          	auipc	ra,0xfffff
    80003652:	db4080e7          	jalr	-588(ra) # 80002402 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003656:	2905                	addiw	s2,s2,1
    80003658:	0a91                	addi	s5,s5,4
    8000365a:	02ca2783          	lw	a5,44(s4)
    8000365e:	f8f94ee3          	blt	s2,a5,800035fa <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003662:	00000097          	auipc	ra,0x0
    80003666:	c6a080e7          	jalr	-918(ra) # 800032cc <write_head>
    install_trans(0); // Now install writes to home locations
    8000366a:	4501                	li	a0,0
    8000366c:	00000097          	auipc	ra,0x0
    80003670:	cda080e7          	jalr	-806(ra) # 80003346 <install_trans>
    log.lh.n = 0;
    80003674:	00015797          	auipc	a5,0x15
    80003678:	4607a423          	sw	zero,1128(a5) # 80018adc <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000367c:	00000097          	auipc	ra,0x0
    80003680:	c50080e7          	jalr	-944(ra) # 800032cc <write_head>
    80003684:	bdf5                	j	80003580 <end_op+0x52>

0000000080003686 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003686:	1101                	addi	sp,sp,-32
    80003688:	ec06                	sd	ra,24(sp)
    8000368a:	e822                	sd	s0,16(sp)
    8000368c:	e426                	sd	s1,8(sp)
    8000368e:	e04a                	sd	s2,0(sp)
    80003690:	1000                	addi	s0,sp,32
    80003692:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003694:	00015917          	auipc	s2,0x15
    80003698:	41c90913          	addi	s2,s2,1052 # 80018ab0 <log>
    8000369c:	854a                	mv	a0,s2
    8000369e:	00003097          	auipc	ra,0x3
    800036a2:	a3c080e7          	jalr	-1476(ra) # 800060da <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036a6:	02c92603          	lw	a2,44(s2)
    800036aa:	47f5                	li	a5,29
    800036ac:	06c7c563          	blt	a5,a2,80003716 <log_write+0x90>
    800036b0:	00015797          	auipc	a5,0x15
    800036b4:	41c7a783          	lw	a5,1052(a5) # 80018acc <log+0x1c>
    800036b8:	37fd                	addiw	a5,a5,-1
    800036ba:	04f65e63          	bge	a2,a5,80003716 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036be:	00015797          	auipc	a5,0x15
    800036c2:	4127a783          	lw	a5,1042(a5) # 80018ad0 <log+0x20>
    800036c6:	06f05063          	blez	a5,80003726 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036ca:	4781                	li	a5,0
    800036cc:	06c05563          	blez	a2,80003736 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036d0:	44cc                	lw	a1,12(s1)
    800036d2:	00015717          	auipc	a4,0x15
    800036d6:	40e70713          	addi	a4,a4,1038 # 80018ae0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036da:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036dc:	4314                	lw	a3,0(a4)
    800036de:	04b68c63          	beq	a3,a1,80003736 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036e2:	2785                	addiw	a5,a5,1
    800036e4:	0711                	addi	a4,a4,4
    800036e6:	fef61be3          	bne	a2,a5,800036dc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036ea:	0621                	addi	a2,a2,8
    800036ec:	060a                	slli	a2,a2,0x2
    800036ee:	00015797          	auipc	a5,0x15
    800036f2:	3c278793          	addi	a5,a5,962 # 80018ab0 <log>
    800036f6:	963e                	add	a2,a2,a5
    800036f8:	44dc                	lw	a5,12(s1)
    800036fa:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036fc:	8526                	mv	a0,s1
    800036fe:	fffff097          	auipc	ra,0xfffff
    80003702:	da2080e7          	jalr	-606(ra) # 800024a0 <bpin>
    log.lh.n++;
    80003706:	00015717          	auipc	a4,0x15
    8000370a:	3aa70713          	addi	a4,a4,938 # 80018ab0 <log>
    8000370e:	575c                	lw	a5,44(a4)
    80003710:	2785                	addiw	a5,a5,1
    80003712:	d75c                	sw	a5,44(a4)
    80003714:	a835                	j	80003750 <log_write+0xca>
    panic("too big a transaction");
    80003716:	00005517          	auipc	a0,0x5
    8000371a:	eaa50513          	addi	a0,a0,-342 # 800085c0 <syscalls+0x1f0>
    8000371e:	00002097          	auipc	ra,0x2
    80003722:	480080e7          	jalr	1152(ra) # 80005b9e <panic>
    panic("log_write outside of trans");
    80003726:	00005517          	auipc	a0,0x5
    8000372a:	eb250513          	addi	a0,a0,-334 # 800085d8 <syscalls+0x208>
    8000372e:	00002097          	auipc	ra,0x2
    80003732:	470080e7          	jalr	1136(ra) # 80005b9e <panic>
  log.lh.block[i] = b->blockno;
    80003736:	00878713          	addi	a4,a5,8
    8000373a:	00271693          	slli	a3,a4,0x2
    8000373e:	00015717          	auipc	a4,0x15
    80003742:	37270713          	addi	a4,a4,882 # 80018ab0 <log>
    80003746:	9736                	add	a4,a4,a3
    80003748:	44d4                	lw	a3,12(s1)
    8000374a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000374c:	faf608e3          	beq	a2,a5,800036fc <log_write+0x76>
  }
  release(&log.lock);
    80003750:	00015517          	auipc	a0,0x15
    80003754:	36050513          	addi	a0,a0,864 # 80018ab0 <log>
    80003758:	00003097          	auipc	ra,0x3
    8000375c:	a36080e7          	jalr	-1482(ra) # 8000618e <release>
}
    80003760:	60e2                	ld	ra,24(sp)
    80003762:	6442                	ld	s0,16(sp)
    80003764:	64a2                	ld	s1,8(sp)
    80003766:	6902                	ld	s2,0(sp)
    80003768:	6105                	addi	sp,sp,32
    8000376a:	8082                	ret

000000008000376c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000376c:	1101                	addi	sp,sp,-32
    8000376e:	ec06                	sd	ra,24(sp)
    80003770:	e822                	sd	s0,16(sp)
    80003772:	e426                	sd	s1,8(sp)
    80003774:	e04a                	sd	s2,0(sp)
    80003776:	1000                	addi	s0,sp,32
    80003778:	84aa                	mv	s1,a0
    8000377a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000377c:	00005597          	auipc	a1,0x5
    80003780:	e7c58593          	addi	a1,a1,-388 # 800085f8 <syscalls+0x228>
    80003784:	0521                	addi	a0,a0,8
    80003786:	00003097          	auipc	ra,0x3
    8000378a:	8c4080e7          	jalr	-1852(ra) # 8000604a <initlock>
  lk->name = name;
    8000378e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003792:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003796:	0204a423          	sw	zero,40(s1)
}
    8000379a:	60e2                	ld	ra,24(sp)
    8000379c:	6442                	ld	s0,16(sp)
    8000379e:	64a2                	ld	s1,8(sp)
    800037a0:	6902                	ld	s2,0(sp)
    800037a2:	6105                	addi	sp,sp,32
    800037a4:	8082                	ret

00000000800037a6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037a6:	1101                	addi	sp,sp,-32
    800037a8:	ec06                	sd	ra,24(sp)
    800037aa:	e822                	sd	s0,16(sp)
    800037ac:	e426                	sd	s1,8(sp)
    800037ae:	e04a                	sd	s2,0(sp)
    800037b0:	1000                	addi	s0,sp,32
    800037b2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037b4:	00850913          	addi	s2,a0,8
    800037b8:	854a                	mv	a0,s2
    800037ba:	00003097          	auipc	ra,0x3
    800037be:	920080e7          	jalr	-1760(ra) # 800060da <acquire>
  while (lk->locked) {
    800037c2:	409c                	lw	a5,0(s1)
    800037c4:	cb89                	beqz	a5,800037d6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037c6:	85ca                	mv	a1,s2
    800037c8:	8526                	mv	a0,s1
    800037ca:	ffffe097          	auipc	ra,0xffffe
    800037ce:	d3c080e7          	jalr	-708(ra) # 80001506 <sleep>
  while (lk->locked) {
    800037d2:	409c                	lw	a5,0(s1)
    800037d4:	fbed                	bnez	a5,800037c6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037d6:	4785                	li	a5,1
    800037d8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037da:	ffffd097          	auipc	ra,0xffffd
    800037de:	678080e7          	jalr	1656(ra) # 80000e52 <myproc>
    800037e2:	591c                	lw	a5,48(a0)
    800037e4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037e6:	854a                	mv	a0,s2
    800037e8:	00003097          	auipc	ra,0x3
    800037ec:	9a6080e7          	jalr	-1626(ra) # 8000618e <release>
}
    800037f0:	60e2                	ld	ra,24(sp)
    800037f2:	6442                	ld	s0,16(sp)
    800037f4:	64a2                	ld	s1,8(sp)
    800037f6:	6902                	ld	s2,0(sp)
    800037f8:	6105                	addi	sp,sp,32
    800037fa:	8082                	ret

00000000800037fc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037fc:	1101                	addi	sp,sp,-32
    800037fe:	ec06                	sd	ra,24(sp)
    80003800:	e822                	sd	s0,16(sp)
    80003802:	e426                	sd	s1,8(sp)
    80003804:	e04a                	sd	s2,0(sp)
    80003806:	1000                	addi	s0,sp,32
    80003808:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000380a:	00850913          	addi	s2,a0,8
    8000380e:	854a                	mv	a0,s2
    80003810:	00003097          	auipc	ra,0x3
    80003814:	8ca080e7          	jalr	-1846(ra) # 800060da <acquire>
  lk->locked = 0;
    80003818:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000381c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003820:	8526                	mv	a0,s1
    80003822:	ffffe097          	auipc	ra,0xffffe
    80003826:	d48080e7          	jalr	-696(ra) # 8000156a <wakeup>
  release(&lk->lk);
    8000382a:	854a                	mv	a0,s2
    8000382c:	00003097          	auipc	ra,0x3
    80003830:	962080e7          	jalr	-1694(ra) # 8000618e <release>
}
    80003834:	60e2                	ld	ra,24(sp)
    80003836:	6442                	ld	s0,16(sp)
    80003838:	64a2                	ld	s1,8(sp)
    8000383a:	6902                	ld	s2,0(sp)
    8000383c:	6105                	addi	sp,sp,32
    8000383e:	8082                	ret

0000000080003840 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003840:	7179                	addi	sp,sp,-48
    80003842:	f406                	sd	ra,40(sp)
    80003844:	f022                	sd	s0,32(sp)
    80003846:	ec26                	sd	s1,24(sp)
    80003848:	e84a                	sd	s2,16(sp)
    8000384a:	e44e                	sd	s3,8(sp)
    8000384c:	1800                	addi	s0,sp,48
    8000384e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003850:	00850913          	addi	s2,a0,8
    80003854:	854a                	mv	a0,s2
    80003856:	00003097          	auipc	ra,0x3
    8000385a:	884080e7          	jalr	-1916(ra) # 800060da <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000385e:	409c                	lw	a5,0(s1)
    80003860:	ef99                	bnez	a5,8000387e <holdingsleep+0x3e>
    80003862:	4481                	li	s1,0
  release(&lk->lk);
    80003864:	854a                	mv	a0,s2
    80003866:	00003097          	auipc	ra,0x3
    8000386a:	928080e7          	jalr	-1752(ra) # 8000618e <release>
  return r;
}
    8000386e:	8526                	mv	a0,s1
    80003870:	70a2                	ld	ra,40(sp)
    80003872:	7402                	ld	s0,32(sp)
    80003874:	64e2                	ld	s1,24(sp)
    80003876:	6942                	ld	s2,16(sp)
    80003878:	69a2                	ld	s3,8(sp)
    8000387a:	6145                	addi	sp,sp,48
    8000387c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000387e:	0284a983          	lw	s3,40(s1)
    80003882:	ffffd097          	auipc	ra,0xffffd
    80003886:	5d0080e7          	jalr	1488(ra) # 80000e52 <myproc>
    8000388a:	5904                	lw	s1,48(a0)
    8000388c:	413484b3          	sub	s1,s1,s3
    80003890:	0014b493          	seqz	s1,s1
    80003894:	bfc1                	j	80003864 <holdingsleep+0x24>

0000000080003896 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003896:	1141                	addi	sp,sp,-16
    80003898:	e406                	sd	ra,8(sp)
    8000389a:	e022                	sd	s0,0(sp)
    8000389c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000389e:	00005597          	auipc	a1,0x5
    800038a2:	d6a58593          	addi	a1,a1,-662 # 80008608 <syscalls+0x238>
    800038a6:	00015517          	auipc	a0,0x15
    800038aa:	35250513          	addi	a0,a0,850 # 80018bf8 <ftable>
    800038ae:	00002097          	auipc	ra,0x2
    800038b2:	79c080e7          	jalr	1948(ra) # 8000604a <initlock>
}
    800038b6:	60a2                	ld	ra,8(sp)
    800038b8:	6402                	ld	s0,0(sp)
    800038ba:	0141                	addi	sp,sp,16
    800038bc:	8082                	ret

00000000800038be <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038be:	1101                	addi	sp,sp,-32
    800038c0:	ec06                	sd	ra,24(sp)
    800038c2:	e822                	sd	s0,16(sp)
    800038c4:	e426                	sd	s1,8(sp)
    800038c6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038c8:	00015517          	auipc	a0,0x15
    800038cc:	33050513          	addi	a0,a0,816 # 80018bf8 <ftable>
    800038d0:	00003097          	auipc	ra,0x3
    800038d4:	80a080e7          	jalr	-2038(ra) # 800060da <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038d8:	00015497          	auipc	s1,0x15
    800038dc:	33848493          	addi	s1,s1,824 # 80018c10 <ftable+0x18>
    800038e0:	00016717          	auipc	a4,0x16
    800038e4:	2d070713          	addi	a4,a4,720 # 80019bb0 <disk>
    if(f->ref == 0){
    800038e8:	40dc                	lw	a5,4(s1)
    800038ea:	cf99                	beqz	a5,80003908 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038ec:	02848493          	addi	s1,s1,40
    800038f0:	fee49ce3          	bne	s1,a4,800038e8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038f4:	00015517          	auipc	a0,0x15
    800038f8:	30450513          	addi	a0,a0,772 # 80018bf8 <ftable>
    800038fc:	00003097          	auipc	ra,0x3
    80003900:	892080e7          	jalr	-1902(ra) # 8000618e <release>
  return 0;
    80003904:	4481                	li	s1,0
    80003906:	a819                	j	8000391c <filealloc+0x5e>
      f->ref = 1;
    80003908:	4785                	li	a5,1
    8000390a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000390c:	00015517          	auipc	a0,0x15
    80003910:	2ec50513          	addi	a0,a0,748 # 80018bf8 <ftable>
    80003914:	00003097          	auipc	ra,0x3
    80003918:	87a080e7          	jalr	-1926(ra) # 8000618e <release>
}
    8000391c:	8526                	mv	a0,s1
    8000391e:	60e2                	ld	ra,24(sp)
    80003920:	6442                	ld	s0,16(sp)
    80003922:	64a2                	ld	s1,8(sp)
    80003924:	6105                	addi	sp,sp,32
    80003926:	8082                	ret

0000000080003928 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003928:	1101                	addi	sp,sp,-32
    8000392a:	ec06                	sd	ra,24(sp)
    8000392c:	e822                	sd	s0,16(sp)
    8000392e:	e426                	sd	s1,8(sp)
    80003930:	1000                	addi	s0,sp,32
    80003932:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003934:	00015517          	auipc	a0,0x15
    80003938:	2c450513          	addi	a0,a0,708 # 80018bf8 <ftable>
    8000393c:	00002097          	auipc	ra,0x2
    80003940:	79e080e7          	jalr	1950(ra) # 800060da <acquire>
  if(f->ref < 1)
    80003944:	40dc                	lw	a5,4(s1)
    80003946:	02f05263          	blez	a5,8000396a <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000394a:	2785                	addiw	a5,a5,1
    8000394c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000394e:	00015517          	auipc	a0,0x15
    80003952:	2aa50513          	addi	a0,a0,682 # 80018bf8 <ftable>
    80003956:	00003097          	auipc	ra,0x3
    8000395a:	838080e7          	jalr	-1992(ra) # 8000618e <release>
  return f;
}
    8000395e:	8526                	mv	a0,s1
    80003960:	60e2                	ld	ra,24(sp)
    80003962:	6442                	ld	s0,16(sp)
    80003964:	64a2                	ld	s1,8(sp)
    80003966:	6105                	addi	sp,sp,32
    80003968:	8082                	ret
    panic("filedup");
    8000396a:	00005517          	auipc	a0,0x5
    8000396e:	ca650513          	addi	a0,a0,-858 # 80008610 <syscalls+0x240>
    80003972:	00002097          	auipc	ra,0x2
    80003976:	22c080e7          	jalr	556(ra) # 80005b9e <panic>

000000008000397a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000397a:	7139                	addi	sp,sp,-64
    8000397c:	fc06                	sd	ra,56(sp)
    8000397e:	f822                	sd	s0,48(sp)
    80003980:	f426                	sd	s1,40(sp)
    80003982:	f04a                	sd	s2,32(sp)
    80003984:	ec4e                	sd	s3,24(sp)
    80003986:	e852                	sd	s4,16(sp)
    80003988:	e456                	sd	s5,8(sp)
    8000398a:	0080                	addi	s0,sp,64
    8000398c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000398e:	00015517          	auipc	a0,0x15
    80003992:	26a50513          	addi	a0,a0,618 # 80018bf8 <ftable>
    80003996:	00002097          	auipc	ra,0x2
    8000399a:	744080e7          	jalr	1860(ra) # 800060da <acquire>
  if(f->ref < 1)
    8000399e:	40dc                	lw	a5,4(s1)
    800039a0:	06f05163          	blez	a5,80003a02 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800039a4:	37fd                	addiw	a5,a5,-1
    800039a6:	0007871b          	sext.w	a4,a5
    800039aa:	c0dc                	sw	a5,4(s1)
    800039ac:	06e04363          	bgtz	a4,80003a12 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039b0:	0004a903          	lw	s2,0(s1)
    800039b4:	0094ca83          	lbu	s5,9(s1)
    800039b8:	0104ba03          	ld	s4,16(s1)
    800039bc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039c0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039c4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039c8:	00015517          	auipc	a0,0x15
    800039cc:	23050513          	addi	a0,a0,560 # 80018bf8 <ftable>
    800039d0:	00002097          	auipc	ra,0x2
    800039d4:	7be080e7          	jalr	1982(ra) # 8000618e <release>

  if(ff.type == FD_PIPE){
    800039d8:	4785                	li	a5,1
    800039da:	04f90d63          	beq	s2,a5,80003a34 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039de:	3979                	addiw	s2,s2,-2
    800039e0:	4785                	li	a5,1
    800039e2:	0527e063          	bltu	a5,s2,80003a22 <fileclose+0xa8>
    begin_op();
    800039e6:	00000097          	auipc	ra,0x0
    800039ea:	ac8080e7          	jalr	-1336(ra) # 800034ae <begin_op>
    iput(ff.ip);
    800039ee:	854e                	mv	a0,s3
    800039f0:	fffff097          	auipc	ra,0xfffff
    800039f4:	2b6080e7          	jalr	694(ra) # 80002ca6 <iput>
    end_op();
    800039f8:	00000097          	auipc	ra,0x0
    800039fc:	b36080e7          	jalr	-1226(ra) # 8000352e <end_op>
    80003a00:	a00d                	j	80003a22 <fileclose+0xa8>
    panic("fileclose");
    80003a02:	00005517          	auipc	a0,0x5
    80003a06:	c1650513          	addi	a0,a0,-1002 # 80008618 <syscalls+0x248>
    80003a0a:	00002097          	auipc	ra,0x2
    80003a0e:	194080e7          	jalr	404(ra) # 80005b9e <panic>
    release(&ftable.lock);
    80003a12:	00015517          	auipc	a0,0x15
    80003a16:	1e650513          	addi	a0,a0,486 # 80018bf8 <ftable>
    80003a1a:	00002097          	auipc	ra,0x2
    80003a1e:	774080e7          	jalr	1908(ra) # 8000618e <release>
  }
}
    80003a22:	70e2                	ld	ra,56(sp)
    80003a24:	7442                	ld	s0,48(sp)
    80003a26:	74a2                	ld	s1,40(sp)
    80003a28:	7902                	ld	s2,32(sp)
    80003a2a:	69e2                	ld	s3,24(sp)
    80003a2c:	6a42                	ld	s4,16(sp)
    80003a2e:	6aa2                	ld	s5,8(sp)
    80003a30:	6121                	addi	sp,sp,64
    80003a32:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a34:	85d6                	mv	a1,s5
    80003a36:	8552                	mv	a0,s4
    80003a38:	00000097          	auipc	ra,0x0
    80003a3c:	34c080e7          	jalr	844(ra) # 80003d84 <pipeclose>
    80003a40:	b7cd                	j	80003a22 <fileclose+0xa8>

0000000080003a42 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a42:	715d                	addi	sp,sp,-80
    80003a44:	e486                	sd	ra,72(sp)
    80003a46:	e0a2                	sd	s0,64(sp)
    80003a48:	fc26                	sd	s1,56(sp)
    80003a4a:	f84a                	sd	s2,48(sp)
    80003a4c:	f44e                	sd	s3,40(sp)
    80003a4e:	0880                	addi	s0,sp,80
    80003a50:	84aa                	mv	s1,a0
    80003a52:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a54:	ffffd097          	auipc	ra,0xffffd
    80003a58:	3fe080e7          	jalr	1022(ra) # 80000e52 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a5c:	409c                	lw	a5,0(s1)
    80003a5e:	37f9                	addiw	a5,a5,-2
    80003a60:	4705                	li	a4,1
    80003a62:	04f76763          	bltu	a4,a5,80003ab0 <filestat+0x6e>
    80003a66:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a68:	6c88                	ld	a0,24(s1)
    80003a6a:	fffff097          	auipc	ra,0xfffff
    80003a6e:	082080e7          	jalr	130(ra) # 80002aec <ilock>
    stati(f->ip, &st);
    80003a72:	fb840593          	addi	a1,s0,-72
    80003a76:	6c88                	ld	a0,24(s1)
    80003a78:	fffff097          	auipc	ra,0xfffff
    80003a7c:	2fe080e7          	jalr	766(ra) # 80002d76 <stati>
    iunlock(f->ip);
    80003a80:	6c88                	ld	a0,24(s1)
    80003a82:	fffff097          	auipc	ra,0xfffff
    80003a86:	12c080e7          	jalr	300(ra) # 80002bae <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a8a:	46e1                	li	a3,24
    80003a8c:	fb840613          	addi	a2,s0,-72
    80003a90:	85ce                	mv	a1,s3
    80003a92:	05093503          	ld	a0,80(s2)
    80003a96:	ffffd097          	auipc	ra,0xffffd
    80003a9a:	078080e7          	jalr	120(ra) # 80000b0e <copyout>
    80003a9e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003aa2:	60a6                	ld	ra,72(sp)
    80003aa4:	6406                	ld	s0,64(sp)
    80003aa6:	74e2                	ld	s1,56(sp)
    80003aa8:	7942                	ld	s2,48(sp)
    80003aaa:	79a2                	ld	s3,40(sp)
    80003aac:	6161                	addi	sp,sp,80
    80003aae:	8082                	ret
  return -1;
    80003ab0:	557d                	li	a0,-1
    80003ab2:	bfc5                	j	80003aa2 <filestat+0x60>

0000000080003ab4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ab4:	7179                	addi	sp,sp,-48
    80003ab6:	f406                	sd	ra,40(sp)
    80003ab8:	f022                	sd	s0,32(sp)
    80003aba:	ec26                	sd	s1,24(sp)
    80003abc:	e84a                	sd	s2,16(sp)
    80003abe:	e44e                	sd	s3,8(sp)
    80003ac0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ac2:	00854783          	lbu	a5,8(a0)
    80003ac6:	c3d5                	beqz	a5,80003b6a <fileread+0xb6>
    80003ac8:	84aa                	mv	s1,a0
    80003aca:	89ae                	mv	s3,a1
    80003acc:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ace:	411c                	lw	a5,0(a0)
    80003ad0:	4705                	li	a4,1
    80003ad2:	04e78963          	beq	a5,a4,80003b24 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ad6:	470d                	li	a4,3
    80003ad8:	04e78d63          	beq	a5,a4,80003b32 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003adc:	4709                	li	a4,2
    80003ade:	06e79e63          	bne	a5,a4,80003b5a <fileread+0xa6>
    ilock(f->ip);
    80003ae2:	6d08                	ld	a0,24(a0)
    80003ae4:	fffff097          	auipc	ra,0xfffff
    80003ae8:	008080e7          	jalr	8(ra) # 80002aec <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003aec:	874a                	mv	a4,s2
    80003aee:	5094                	lw	a3,32(s1)
    80003af0:	864e                	mv	a2,s3
    80003af2:	4585                	li	a1,1
    80003af4:	6c88                	ld	a0,24(s1)
    80003af6:	fffff097          	auipc	ra,0xfffff
    80003afa:	2aa080e7          	jalr	682(ra) # 80002da0 <readi>
    80003afe:	892a                	mv	s2,a0
    80003b00:	00a05563          	blez	a0,80003b0a <fileread+0x56>
      f->off += r;
    80003b04:	509c                	lw	a5,32(s1)
    80003b06:	9fa9                	addw	a5,a5,a0
    80003b08:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b0a:	6c88                	ld	a0,24(s1)
    80003b0c:	fffff097          	auipc	ra,0xfffff
    80003b10:	0a2080e7          	jalr	162(ra) # 80002bae <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b14:	854a                	mv	a0,s2
    80003b16:	70a2                	ld	ra,40(sp)
    80003b18:	7402                	ld	s0,32(sp)
    80003b1a:	64e2                	ld	s1,24(sp)
    80003b1c:	6942                	ld	s2,16(sp)
    80003b1e:	69a2                	ld	s3,8(sp)
    80003b20:	6145                	addi	sp,sp,48
    80003b22:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b24:	6908                	ld	a0,16(a0)
    80003b26:	00000097          	auipc	ra,0x0
    80003b2a:	3c6080e7          	jalr	966(ra) # 80003eec <piperead>
    80003b2e:	892a                	mv	s2,a0
    80003b30:	b7d5                	j	80003b14 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b32:	02451783          	lh	a5,36(a0)
    80003b36:	03079693          	slli	a3,a5,0x30
    80003b3a:	92c1                	srli	a3,a3,0x30
    80003b3c:	4725                	li	a4,9
    80003b3e:	02d76863          	bltu	a4,a3,80003b6e <fileread+0xba>
    80003b42:	0792                	slli	a5,a5,0x4
    80003b44:	00015717          	auipc	a4,0x15
    80003b48:	01470713          	addi	a4,a4,20 # 80018b58 <devsw>
    80003b4c:	97ba                	add	a5,a5,a4
    80003b4e:	639c                	ld	a5,0(a5)
    80003b50:	c38d                	beqz	a5,80003b72 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003b52:	4505                	li	a0,1
    80003b54:	9782                	jalr	a5
    80003b56:	892a                	mv	s2,a0
    80003b58:	bf75                	j	80003b14 <fileread+0x60>
    panic("fileread");
    80003b5a:	00005517          	auipc	a0,0x5
    80003b5e:	ace50513          	addi	a0,a0,-1330 # 80008628 <syscalls+0x258>
    80003b62:	00002097          	auipc	ra,0x2
    80003b66:	03c080e7          	jalr	60(ra) # 80005b9e <panic>
    return -1;
    80003b6a:	597d                	li	s2,-1
    80003b6c:	b765                	j	80003b14 <fileread+0x60>
      return -1;
    80003b6e:	597d                	li	s2,-1
    80003b70:	b755                	j	80003b14 <fileread+0x60>
    80003b72:	597d                	li	s2,-1
    80003b74:	b745                	j	80003b14 <fileread+0x60>

0000000080003b76 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003b76:	715d                	addi	sp,sp,-80
    80003b78:	e486                	sd	ra,72(sp)
    80003b7a:	e0a2                	sd	s0,64(sp)
    80003b7c:	fc26                	sd	s1,56(sp)
    80003b7e:	f84a                	sd	s2,48(sp)
    80003b80:	f44e                	sd	s3,40(sp)
    80003b82:	f052                	sd	s4,32(sp)
    80003b84:	ec56                	sd	s5,24(sp)
    80003b86:	e85a                	sd	s6,16(sp)
    80003b88:	e45e                	sd	s7,8(sp)
    80003b8a:	e062                	sd	s8,0(sp)
    80003b8c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b8e:	00954783          	lbu	a5,9(a0)
    80003b92:	10078663          	beqz	a5,80003c9e <filewrite+0x128>
    80003b96:	892a                	mv	s2,a0
    80003b98:	8aae                	mv	s5,a1
    80003b9a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b9c:	411c                	lw	a5,0(a0)
    80003b9e:	4705                	li	a4,1
    80003ba0:	02e78263          	beq	a5,a4,80003bc4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ba4:	470d                	li	a4,3
    80003ba6:	02e78663          	beq	a5,a4,80003bd2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003baa:	4709                	li	a4,2
    80003bac:	0ee79163          	bne	a5,a4,80003c8e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003bb0:	0ac05d63          	blez	a2,80003c6a <filewrite+0xf4>
    int i = 0;
    80003bb4:	4981                	li	s3,0
    80003bb6:	6b05                	lui	s6,0x1
    80003bb8:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003bbc:	6b85                	lui	s7,0x1
    80003bbe:	c00b8b9b          	addiw	s7,s7,-1024
    80003bc2:	a861                	j	80003c5a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003bc4:	6908                	ld	a0,16(a0)
    80003bc6:	00000097          	auipc	ra,0x0
    80003bca:	22e080e7          	jalr	558(ra) # 80003df4 <pipewrite>
    80003bce:	8a2a                	mv	s4,a0
    80003bd0:	a045                	j	80003c70 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bd2:	02451783          	lh	a5,36(a0)
    80003bd6:	03079693          	slli	a3,a5,0x30
    80003bda:	92c1                	srli	a3,a3,0x30
    80003bdc:	4725                	li	a4,9
    80003bde:	0cd76263          	bltu	a4,a3,80003ca2 <filewrite+0x12c>
    80003be2:	0792                	slli	a5,a5,0x4
    80003be4:	00015717          	auipc	a4,0x15
    80003be8:	f7470713          	addi	a4,a4,-140 # 80018b58 <devsw>
    80003bec:	97ba                	add	a5,a5,a4
    80003bee:	679c                	ld	a5,8(a5)
    80003bf0:	cbdd                	beqz	a5,80003ca6 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003bf2:	4505                	li	a0,1
    80003bf4:	9782                	jalr	a5
    80003bf6:	8a2a                	mv	s4,a0
    80003bf8:	a8a5                	j	80003c70 <filewrite+0xfa>
    80003bfa:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003bfe:	00000097          	auipc	ra,0x0
    80003c02:	8b0080e7          	jalr	-1872(ra) # 800034ae <begin_op>
      ilock(f->ip);
    80003c06:	01893503          	ld	a0,24(s2)
    80003c0a:	fffff097          	auipc	ra,0xfffff
    80003c0e:	ee2080e7          	jalr	-286(ra) # 80002aec <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c12:	8762                	mv	a4,s8
    80003c14:	02092683          	lw	a3,32(s2)
    80003c18:	01598633          	add	a2,s3,s5
    80003c1c:	4585                	li	a1,1
    80003c1e:	01893503          	ld	a0,24(s2)
    80003c22:	fffff097          	auipc	ra,0xfffff
    80003c26:	276080e7          	jalr	630(ra) # 80002e98 <writei>
    80003c2a:	84aa                	mv	s1,a0
    80003c2c:	00a05763          	blez	a0,80003c3a <filewrite+0xc4>
        f->off += r;
    80003c30:	02092783          	lw	a5,32(s2)
    80003c34:	9fa9                	addw	a5,a5,a0
    80003c36:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c3a:	01893503          	ld	a0,24(s2)
    80003c3e:	fffff097          	auipc	ra,0xfffff
    80003c42:	f70080e7          	jalr	-144(ra) # 80002bae <iunlock>
      end_op();
    80003c46:	00000097          	auipc	ra,0x0
    80003c4a:	8e8080e7          	jalr	-1816(ra) # 8000352e <end_op>

      if(r != n1){
    80003c4e:	009c1f63          	bne	s8,s1,80003c6c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003c52:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c56:	0149db63          	bge	s3,s4,80003c6c <filewrite+0xf6>
      int n1 = n - i;
    80003c5a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003c5e:	84be                	mv	s1,a5
    80003c60:	2781                	sext.w	a5,a5
    80003c62:	f8fb5ce3          	bge	s6,a5,80003bfa <filewrite+0x84>
    80003c66:	84de                	mv	s1,s7
    80003c68:	bf49                	j	80003bfa <filewrite+0x84>
    int i = 0;
    80003c6a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c6c:	013a1f63          	bne	s4,s3,80003c8a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c70:	8552                	mv	a0,s4
    80003c72:	60a6                	ld	ra,72(sp)
    80003c74:	6406                	ld	s0,64(sp)
    80003c76:	74e2                	ld	s1,56(sp)
    80003c78:	7942                	ld	s2,48(sp)
    80003c7a:	79a2                	ld	s3,40(sp)
    80003c7c:	7a02                	ld	s4,32(sp)
    80003c7e:	6ae2                	ld	s5,24(sp)
    80003c80:	6b42                	ld	s6,16(sp)
    80003c82:	6ba2                	ld	s7,8(sp)
    80003c84:	6c02                	ld	s8,0(sp)
    80003c86:	6161                	addi	sp,sp,80
    80003c88:	8082                	ret
    ret = (i == n ? n : -1);
    80003c8a:	5a7d                	li	s4,-1
    80003c8c:	b7d5                	j	80003c70 <filewrite+0xfa>
    panic("filewrite");
    80003c8e:	00005517          	auipc	a0,0x5
    80003c92:	9aa50513          	addi	a0,a0,-1622 # 80008638 <syscalls+0x268>
    80003c96:	00002097          	auipc	ra,0x2
    80003c9a:	f08080e7          	jalr	-248(ra) # 80005b9e <panic>
    return -1;
    80003c9e:	5a7d                	li	s4,-1
    80003ca0:	bfc1                	j	80003c70 <filewrite+0xfa>
      return -1;
    80003ca2:	5a7d                	li	s4,-1
    80003ca4:	b7f1                	j	80003c70 <filewrite+0xfa>
    80003ca6:	5a7d                	li	s4,-1
    80003ca8:	b7e1                	j	80003c70 <filewrite+0xfa>

0000000080003caa <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003caa:	7179                	addi	sp,sp,-48
    80003cac:	f406                	sd	ra,40(sp)
    80003cae:	f022                	sd	s0,32(sp)
    80003cb0:	ec26                	sd	s1,24(sp)
    80003cb2:	e84a                	sd	s2,16(sp)
    80003cb4:	e44e                	sd	s3,8(sp)
    80003cb6:	e052                	sd	s4,0(sp)
    80003cb8:	1800                	addi	s0,sp,48
    80003cba:	84aa                	mv	s1,a0
    80003cbc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003cbe:	0005b023          	sd	zero,0(a1)
    80003cc2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003cc6:	00000097          	auipc	ra,0x0
    80003cca:	bf8080e7          	jalr	-1032(ra) # 800038be <filealloc>
    80003cce:	e088                	sd	a0,0(s1)
    80003cd0:	c551                	beqz	a0,80003d5c <pipealloc+0xb2>
    80003cd2:	00000097          	auipc	ra,0x0
    80003cd6:	bec080e7          	jalr	-1044(ra) # 800038be <filealloc>
    80003cda:	00aa3023          	sd	a0,0(s4)
    80003cde:	c92d                	beqz	a0,80003d50 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ce0:	ffffc097          	auipc	ra,0xffffc
    80003ce4:	438080e7          	jalr	1080(ra) # 80000118 <kalloc>
    80003ce8:	892a                	mv	s2,a0
    80003cea:	c125                	beqz	a0,80003d4a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003cec:	4985                	li	s3,1
    80003cee:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003cf2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003cf6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003cfa:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003cfe:	00005597          	auipc	a1,0x5
    80003d02:	94a58593          	addi	a1,a1,-1718 # 80008648 <syscalls+0x278>
    80003d06:	00002097          	auipc	ra,0x2
    80003d0a:	344080e7          	jalr	836(ra) # 8000604a <initlock>
  (*f0)->type = FD_PIPE;
    80003d0e:	609c                	ld	a5,0(s1)
    80003d10:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d14:	609c                	ld	a5,0(s1)
    80003d16:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d1a:	609c                	ld	a5,0(s1)
    80003d1c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d20:	609c                	ld	a5,0(s1)
    80003d22:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d26:	000a3783          	ld	a5,0(s4)
    80003d2a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d2e:	000a3783          	ld	a5,0(s4)
    80003d32:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d36:	000a3783          	ld	a5,0(s4)
    80003d3a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d3e:	000a3783          	ld	a5,0(s4)
    80003d42:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d46:	4501                	li	a0,0
    80003d48:	a025                	j	80003d70 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d4a:	6088                	ld	a0,0(s1)
    80003d4c:	e501                	bnez	a0,80003d54 <pipealloc+0xaa>
    80003d4e:	a039                	j	80003d5c <pipealloc+0xb2>
    80003d50:	6088                	ld	a0,0(s1)
    80003d52:	c51d                	beqz	a0,80003d80 <pipealloc+0xd6>
    fileclose(*f0);
    80003d54:	00000097          	auipc	ra,0x0
    80003d58:	c26080e7          	jalr	-986(ra) # 8000397a <fileclose>
  if(*f1)
    80003d5c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d60:	557d                	li	a0,-1
  if(*f1)
    80003d62:	c799                	beqz	a5,80003d70 <pipealloc+0xc6>
    fileclose(*f1);
    80003d64:	853e                	mv	a0,a5
    80003d66:	00000097          	auipc	ra,0x0
    80003d6a:	c14080e7          	jalr	-1004(ra) # 8000397a <fileclose>
  return -1;
    80003d6e:	557d                	li	a0,-1
}
    80003d70:	70a2                	ld	ra,40(sp)
    80003d72:	7402                	ld	s0,32(sp)
    80003d74:	64e2                	ld	s1,24(sp)
    80003d76:	6942                	ld	s2,16(sp)
    80003d78:	69a2                	ld	s3,8(sp)
    80003d7a:	6a02                	ld	s4,0(sp)
    80003d7c:	6145                	addi	sp,sp,48
    80003d7e:	8082                	ret
  return -1;
    80003d80:	557d                	li	a0,-1
    80003d82:	b7fd                	j	80003d70 <pipealloc+0xc6>

0000000080003d84 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d84:	1101                	addi	sp,sp,-32
    80003d86:	ec06                	sd	ra,24(sp)
    80003d88:	e822                	sd	s0,16(sp)
    80003d8a:	e426                	sd	s1,8(sp)
    80003d8c:	e04a                	sd	s2,0(sp)
    80003d8e:	1000                	addi	s0,sp,32
    80003d90:	84aa                	mv	s1,a0
    80003d92:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d94:	00002097          	auipc	ra,0x2
    80003d98:	346080e7          	jalr	838(ra) # 800060da <acquire>
  if(writable){
    80003d9c:	02090d63          	beqz	s2,80003dd6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003da0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003da4:	21848513          	addi	a0,s1,536
    80003da8:	ffffd097          	auipc	ra,0xffffd
    80003dac:	7c2080e7          	jalr	1986(ra) # 8000156a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003db0:	2204b783          	ld	a5,544(s1)
    80003db4:	eb95                	bnez	a5,80003de8 <pipeclose+0x64>
    release(&pi->lock);
    80003db6:	8526                	mv	a0,s1
    80003db8:	00002097          	auipc	ra,0x2
    80003dbc:	3d6080e7          	jalr	982(ra) # 8000618e <release>
    kfree((char*)pi);
    80003dc0:	8526                	mv	a0,s1
    80003dc2:	ffffc097          	auipc	ra,0xffffc
    80003dc6:	25a080e7          	jalr	602(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003dca:	60e2                	ld	ra,24(sp)
    80003dcc:	6442                	ld	s0,16(sp)
    80003dce:	64a2                	ld	s1,8(sp)
    80003dd0:	6902                	ld	s2,0(sp)
    80003dd2:	6105                	addi	sp,sp,32
    80003dd4:	8082                	ret
    pi->readopen = 0;
    80003dd6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003dda:	21c48513          	addi	a0,s1,540
    80003dde:	ffffd097          	auipc	ra,0xffffd
    80003de2:	78c080e7          	jalr	1932(ra) # 8000156a <wakeup>
    80003de6:	b7e9                	j	80003db0 <pipeclose+0x2c>
    release(&pi->lock);
    80003de8:	8526                	mv	a0,s1
    80003dea:	00002097          	auipc	ra,0x2
    80003dee:	3a4080e7          	jalr	932(ra) # 8000618e <release>
}
    80003df2:	bfe1                	j	80003dca <pipeclose+0x46>

0000000080003df4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003df4:	711d                	addi	sp,sp,-96
    80003df6:	ec86                	sd	ra,88(sp)
    80003df8:	e8a2                	sd	s0,80(sp)
    80003dfa:	e4a6                	sd	s1,72(sp)
    80003dfc:	e0ca                	sd	s2,64(sp)
    80003dfe:	fc4e                	sd	s3,56(sp)
    80003e00:	f852                	sd	s4,48(sp)
    80003e02:	f456                	sd	s5,40(sp)
    80003e04:	f05a                	sd	s6,32(sp)
    80003e06:	ec5e                	sd	s7,24(sp)
    80003e08:	e862                	sd	s8,16(sp)
    80003e0a:	1080                	addi	s0,sp,96
    80003e0c:	84aa                	mv	s1,a0
    80003e0e:	8aae                	mv	s5,a1
    80003e10:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e12:	ffffd097          	auipc	ra,0xffffd
    80003e16:	040080e7          	jalr	64(ra) # 80000e52 <myproc>
    80003e1a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e1c:	8526                	mv	a0,s1
    80003e1e:	00002097          	auipc	ra,0x2
    80003e22:	2bc080e7          	jalr	700(ra) # 800060da <acquire>
  while(i < n){
    80003e26:	0b405663          	blez	s4,80003ed2 <pipewrite+0xde>
  int i = 0;
    80003e2a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e2c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e2e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e32:	21c48b93          	addi	s7,s1,540
    80003e36:	a089                	j	80003e78 <pipewrite+0x84>
      release(&pi->lock);
    80003e38:	8526                	mv	a0,s1
    80003e3a:	00002097          	auipc	ra,0x2
    80003e3e:	354080e7          	jalr	852(ra) # 8000618e <release>
      return -1;
    80003e42:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e44:	854a                	mv	a0,s2
    80003e46:	60e6                	ld	ra,88(sp)
    80003e48:	6446                	ld	s0,80(sp)
    80003e4a:	64a6                	ld	s1,72(sp)
    80003e4c:	6906                	ld	s2,64(sp)
    80003e4e:	79e2                	ld	s3,56(sp)
    80003e50:	7a42                	ld	s4,48(sp)
    80003e52:	7aa2                	ld	s5,40(sp)
    80003e54:	7b02                	ld	s6,32(sp)
    80003e56:	6be2                	ld	s7,24(sp)
    80003e58:	6c42                	ld	s8,16(sp)
    80003e5a:	6125                	addi	sp,sp,96
    80003e5c:	8082                	ret
      wakeup(&pi->nread);
    80003e5e:	8562                	mv	a0,s8
    80003e60:	ffffd097          	auipc	ra,0xffffd
    80003e64:	70a080e7          	jalr	1802(ra) # 8000156a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e68:	85a6                	mv	a1,s1
    80003e6a:	855e                	mv	a0,s7
    80003e6c:	ffffd097          	auipc	ra,0xffffd
    80003e70:	69a080e7          	jalr	1690(ra) # 80001506 <sleep>
  while(i < n){
    80003e74:	07495063          	bge	s2,s4,80003ed4 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003e78:	2204a783          	lw	a5,544(s1)
    80003e7c:	dfd5                	beqz	a5,80003e38 <pipewrite+0x44>
    80003e7e:	854e                	mv	a0,s3
    80003e80:	ffffe097          	auipc	ra,0xffffe
    80003e84:	92e080e7          	jalr	-1746(ra) # 800017ae <killed>
    80003e88:	f945                	bnez	a0,80003e38 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e8a:	2184a783          	lw	a5,536(s1)
    80003e8e:	21c4a703          	lw	a4,540(s1)
    80003e92:	2007879b          	addiw	a5,a5,512
    80003e96:	fcf704e3          	beq	a4,a5,80003e5e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e9a:	4685                	li	a3,1
    80003e9c:	01590633          	add	a2,s2,s5
    80003ea0:	faf40593          	addi	a1,s0,-81
    80003ea4:	0509b503          	ld	a0,80(s3)
    80003ea8:	ffffd097          	auipc	ra,0xffffd
    80003eac:	cf2080e7          	jalr	-782(ra) # 80000b9a <copyin>
    80003eb0:	03650263          	beq	a0,s6,80003ed4 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003eb4:	21c4a783          	lw	a5,540(s1)
    80003eb8:	0017871b          	addiw	a4,a5,1
    80003ebc:	20e4ae23          	sw	a4,540(s1)
    80003ec0:	1ff7f793          	andi	a5,a5,511
    80003ec4:	97a6                	add	a5,a5,s1
    80003ec6:	faf44703          	lbu	a4,-81(s0)
    80003eca:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ece:	2905                	addiw	s2,s2,1
    80003ed0:	b755                	j	80003e74 <pipewrite+0x80>
  int i = 0;
    80003ed2:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003ed4:	21848513          	addi	a0,s1,536
    80003ed8:	ffffd097          	auipc	ra,0xffffd
    80003edc:	692080e7          	jalr	1682(ra) # 8000156a <wakeup>
  release(&pi->lock);
    80003ee0:	8526                	mv	a0,s1
    80003ee2:	00002097          	auipc	ra,0x2
    80003ee6:	2ac080e7          	jalr	684(ra) # 8000618e <release>
  return i;
    80003eea:	bfa9                	j	80003e44 <pipewrite+0x50>

0000000080003eec <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003eec:	715d                	addi	sp,sp,-80
    80003eee:	e486                	sd	ra,72(sp)
    80003ef0:	e0a2                	sd	s0,64(sp)
    80003ef2:	fc26                	sd	s1,56(sp)
    80003ef4:	f84a                	sd	s2,48(sp)
    80003ef6:	f44e                	sd	s3,40(sp)
    80003ef8:	f052                	sd	s4,32(sp)
    80003efa:	ec56                	sd	s5,24(sp)
    80003efc:	e85a                	sd	s6,16(sp)
    80003efe:	0880                	addi	s0,sp,80
    80003f00:	84aa                	mv	s1,a0
    80003f02:	892e                	mv	s2,a1
    80003f04:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f06:	ffffd097          	auipc	ra,0xffffd
    80003f0a:	f4c080e7          	jalr	-180(ra) # 80000e52 <myproc>
    80003f0e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f10:	8526                	mv	a0,s1
    80003f12:	00002097          	auipc	ra,0x2
    80003f16:	1c8080e7          	jalr	456(ra) # 800060da <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f1a:	2184a703          	lw	a4,536(s1)
    80003f1e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f22:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f26:	02f71763          	bne	a4,a5,80003f54 <piperead+0x68>
    80003f2a:	2244a783          	lw	a5,548(s1)
    80003f2e:	c39d                	beqz	a5,80003f54 <piperead+0x68>
    if(killed(pr)){
    80003f30:	8552                	mv	a0,s4
    80003f32:	ffffe097          	auipc	ra,0xffffe
    80003f36:	87c080e7          	jalr	-1924(ra) # 800017ae <killed>
    80003f3a:	e941                	bnez	a0,80003fca <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f3c:	85a6                	mv	a1,s1
    80003f3e:	854e                	mv	a0,s3
    80003f40:	ffffd097          	auipc	ra,0xffffd
    80003f44:	5c6080e7          	jalr	1478(ra) # 80001506 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f48:	2184a703          	lw	a4,536(s1)
    80003f4c:	21c4a783          	lw	a5,540(s1)
    80003f50:	fcf70de3          	beq	a4,a5,80003f2a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f54:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f56:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f58:	05505363          	blez	s5,80003f9e <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003f5c:	2184a783          	lw	a5,536(s1)
    80003f60:	21c4a703          	lw	a4,540(s1)
    80003f64:	02f70d63          	beq	a4,a5,80003f9e <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f68:	0017871b          	addiw	a4,a5,1
    80003f6c:	20e4ac23          	sw	a4,536(s1)
    80003f70:	1ff7f793          	andi	a5,a5,511
    80003f74:	97a6                	add	a5,a5,s1
    80003f76:	0187c783          	lbu	a5,24(a5)
    80003f7a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f7e:	4685                	li	a3,1
    80003f80:	fbf40613          	addi	a2,s0,-65
    80003f84:	85ca                	mv	a1,s2
    80003f86:	050a3503          	ld	a0,80(s4)
    80003f8a:	ffffd097          	auipc	ra,0xffffd
    80003f8e:	b84080e7          	jalr	-1148(ra) # 80000b0e <copyout>
    80003f92:	01650663          	beq	a0,s6,80003f9e <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f96:	2985                	addiw	s3,s3,1
    80003f98:	0905                	addi	s2,s2,1
    80003f9a:	fd3a91e3          	bne	s5,s3,80003f5c <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f9e:	21c48513          	addi	a0,s1,540
    80003fa2:	ffffd097          	auipc	ra,0xffffd
    80003fa6:	5c8080e7          	jalr	1480(ra) # 8000156a <wakeup>
  release(&pi->lock);
    80003faa:	8526                	mv	a0,s1
    80003fac:	00002097          	auipc	ra,0x2
    80003fb0:	1e2080e7          	jalr	482(ra) # 8000618e <release>
  return i;
}
    80003fb4:	854e                	mv	a0,s3
    80003fb6:	60a6                	ld	ra,72(sp)
    80003fb8:	6406                	ld	s0,64(sp)
    80003fba:	74e2                	ld	s1,56(sp)
    80003fbc:	7942                	ld	s2,48(sp)
    80003fbe:	79a2                	ld	s3,40(sp)
    80003fc0:	7a02                	ld	s4,32(sp)
    80003fc2:	6ae2                	ld	s5,24(sp)
    80003fc4:	6b42                	ld	s6,16(sp)
    80003fc6:	6161                	addi	sp,sp,80
    80003fc8:	8082                	ret
      release(&pi->lock);
    80003fca:	8526                	mv	a0,s1
    80003fcc:	00002097          	auipc	ra,0x2
    80003fd0:	1c2080e7          	jalr	450(ra) # 8000618e <release>
      return -1;
    80003fd4:	59fd                	li	s3,-1
    80003fd6:	bff9                	j	80003fb4 <piperead+0xc8>

0000000080003fd8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003fd8:	1141                	addi	sp,sp,-16
    80003fda:	e422                	sd	s0,8(sp)
    80003fdc:	0800                	addi	s0,sp,16
    80003fde:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003fe0:	8905                	andi	a0,a0,1
    80003fe2:	c111                	beqz	a0,80003fe6 <flags2perm+0xe>
      perm = PTE_X;
    80003fe4:	4521                	li	a0,8
    if(flags & 0x2)
    80003fe6:	8b89                	andi	a5,a5,2
    80003fe8:	c399                	beqz	a5,80003fee <flags2perm+0x16>
      perm |= PTE_W;
    80003fea:	00456513          	ori	a0,a0,4
    return perm;
}
    80003fee:	6422                	ld	s0,8(sp)
    80003ff0:	0141                	addi	sp,sp,16
    80003ff2:	8082                	ret

0000000080003ff4 <exec>:

int
exec(char *path, char **argv)
{
    80003ff4:	de010113          	addi	sp,sp,-544
    80003ff8:	20113c23          	sd	ra,536(sp)
    80003ffc:	20813823          	sd	s0,528(sp)
    80004000:	20913423          	sd	s1,520(sp)
    80004004:	21213023          	sd	s2,512(sp)
    80004008:	ffce                	sd	s3,504(sp)
    8000400a:	fbd2                	sd	s4,496(sp)
    8000400c:	f7d6                	sd	s5,488(sp)
    8000400e:	f3da                	sd	s6,480(sp)
    80004010:	efde                	sd	s7,472(sp)
    80004012:	ebe2                	sd	s8,464(sp)
    80004014:	e7e6                	sd	s9,456(sp)
    80004016:	e3ea                	sd	s10,448(sp)
    80004018:	ff6e                	sd	s11,440(sp)
    8000401a:	1400                	addi	s0,sp,544
    8000401c:	892a                	mv	s2,a0
    8000401e:	dea43423          	sd	a0,-536(s0)
    80004022:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004026:	ffffd097          	auipc	ra,0xffffd
    8000402a:	e2c080e7          	jalr	-468(ra) # 80000e52 <myproc>
    8000402e:	84aa                	mv	s1,a0

  begin_op();
    80004030:	fffff097          	auipc	ra,0xfffff
    80004034:	47e080e7          	jalr	1150(ra) # 800034ae <begin_op>

  if((ip = namei(path)) == 0){
    80004038:	854a                	mv	a0,s2
    8000403a:	fffff097          	auipc	ra,0xfffff
    8000403e:	258080e7          	jalr	600(ra) # 80003292 <namei>
    80004042:	c93d                	beqz	a0,800040b8 <exec+0xc4>
    80004044:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004046:	fffff097          	auipc	ra,0xfffff
    8000404a:	aa6080e7          	jalr	-1370(ra) # 80002aec <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000404e:	04000713          	li	a4,64
    80004052:	4681                	li	a3,0
    80004054:	e5040613          	addi	a2,s0,-432
    80004058:	4581                	li	a1,0
    8000405a:	8556                	mv	a0,s5
    8000405c:	fffff097          	auipc	ra,0xfffff
    80004060:	d44080e7          	jalr	-700(ra) # 80002da0 <readi>
    80004064:	04000793          	li	a5,64
    80004068:	00f51a63          	bne	a0,a5,8000407c <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000406c:	e5042703          	lw	a4,-432(s0)
    80004070:	464c47b7          	lui	a5,0x464c4
    80004074:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004078:	04f70663          	beq	a4,a5,800040c4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000407c:	8556                	mv	a0,s5
    8000407e:	fffff097          	auipc	ra,0xfffff
    80004082:	cd0080e7          	jalr	-816(ra) # 80002d4e <iunlockput>
    end_op();
    80004086:	fffff097          	auipc	ra,0xfffff
    8000408a:	4a8080e7          	jalr	1192(ra) # 8000352e <end_op>
  }
  return -1;
    8000408e:	557d                	li	a0,-1
}
    80004090:	21813083          	ld	ra,536(sp)
    80004094:	21013403          	ld	s0,528(sp)
    80004098:	20813483          	ld	s1,520(sp)
    8000409c:	20013903          	ld	s2,512(sp)
    800040a0:	79fe                	ld	s3,504(sp)
    800040a2:	7a5e                	ld	s4,496(sp)
    800040a4:	7abe                	ld	s5,488(sp)
    800040a6:	7b1e                	ld	s6,480(sp)
    800040a8:	6bfe                	ld	s7,472(sp)
    800040aa:	6c5e                	ld	s8,464(sp)
    800040ac:	6cbe                	ld	s9,456(sp)
    800040ae:	6d1e                	ld	s10,448(sp)
    800040b0:	7dfa                	ld	s11,440(sp)
    800040b2:	22010113          	addi	sp,sp,544
    800040b6:	8082                	ret
    end_op();
    800040b8:	fffff097          	auipc	ra,0xfffff
    800040bc:	476080e7          	jalr	1142(ra) # 8000352e <end_op>
    return -1;
    800040c0:	557d                	li	a0,-1
    800040c2:	b7f9                	j	80004090 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800040c4:	8526                	mv	a0,s1
    800040c6:	ffffd097          	auipc	ra,0xffffd
    800040ca:	e50080e7          	jalr	-432(ra) # 80000f16 <proc_pagetable>
    800040ce:	8b2a                	mv	s6,a0
    800040d0:	d555                	beqz	a0,8000407c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040d2:	e7042783          	lw	a5,-400(s0)
    800040d6:	e8845703          	lhu	a4,-376(s0)
    800040da:	c735                	beqz	a4,80004146 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040dc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040de:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800040e2:	6a05                	lui	s4,0x1
    800040e4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800040e8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800040ec:	6d85                	lui	s11,0x1
    800040ee:	7d7d                	lui	s10,0xfffff
    800040f0:	a481                	j	80004330 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800040f2:	00004517          	auipc	a0,0x4
    800040f6:	55e50513          	addi	a0,a0,1374 # 80008650 <syscalls+0x280>
    800040fa:	00002097          	auipc	ra,0x2
    800040fe:	aa4080e7          	jalr	-1372(ra) # 80005b9e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004102:	874a                	mv	a4,s2
    80004104:	009c86bb          	addw	a3,s9,s1
    80004108:	4581                	li	a1,0
    8000410a:	8556                	mv	a0,s5
    8000410c:	fffff097          	auipc	ra,0xfffff
    80004110:	c94080e7          	jalr	-876(ra) # 80002da0 <readi>
    80004114:	2501                	sext.w	a0,a0
    80004116:	1aa91a63          	bne	s2,a0,800042ca <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    8000411a:	009d84bb          	addw	s1,s11,s1
    8000411e:	013d09bb          	addw	s3,s10,s3
    80004122:	1f74f763          	bgeu	s1,s7,80004310 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    80004126:	02049593          	slli	a1,s1,0x20
    8000412a:	9181                	srli	a1,a1,0x20
    8000412c:	95e2                	add	a1,a1,s8
    8000412e:	855a                	mv	a0,s6
    80004130:	ffffc097          	auipc	ra,0xffffc
    80004134:	3d2080e7          	jalr	978(ra) # 80000502 <walkaddr>
    80004138:	862a                	mv	a2,a0
    if(pa == 0)
    8000413a:	dd45                	beqz	a0,800040f2 <exec+0xfe>
      n = PGSIZE;
    8000413c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000413e:	fd49f2e3          	bgeu	s3,s4,80004102 <exec+0x10e>
      n = sz - i;
    80004142:	894e                	mv	s2,s3
    80004144:	bf7d                	j	80004102 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004146:	4901                	li	s2,0
  iunlockput(ip);
    80004148:	8556                	mv	a0,s5
    8000414a:	fffff097          	auipc	ra,0xfffff
    8000414e:	c04080e7          	jalr	-1020(ra) # 80002d4e <iunlockput>
  end_op();
    80004152:	fffff097          	auipc	ra,0xfffff
    80004156:	3dc080e7          	jalr	988(ra) # 8000352e <end_op>
  p = myproc();
    8000415a:	ffffd097          	auipc	ra,0xffffd
    8000415e:	cf8080e7          	jalr	-776(ra) # 80000e52 <myproc>
    80004162:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004164:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004168:	6785                	lui	a5,0x1
    8000416a:	17fd                	addi	a5,a5,-1
    8000416c:	993e                	add	s2,s2,a5
    8000416e:	77fd                	lui	a5,0xfffff
    80004170:	00f977b3          	and	a5,s2,a5
    80004174:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004178:	4691                	li	a3,4
    8000417a:	6609                	lui	a2,0x2
    8000417c:	963e                	add	a2,a2,a5
    8000417e:	85be                	mv	a1,a5
    80004180:	855a                	mv	a0,s6
    80004182:	ffffc097          	auipc	ra,0xffffc
    80004186:	734080e7          	jalr	1844(ra) # 800008b6 <uvmalloc>
    8000418a:	8c2a                	mv	s8,a0
  ip = 0;
    8000418c:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000418e:	12050e63          	beqz	a0,800042ca <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004192:	75f9                	lui	a1,0xffffe
    80004194:	95aa                	add	a1,a1,a0
    80004196:	855a                	mv	a0,s6
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	944080e7          	jalr	-1724(ra) # 80000adc <uvmclear>
  stackbase = sp - PGSIZE;
    800041a0:	7afd                	lui	s5,0xfffff
    800041a2:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800041a4:	df043783          	ld	a5,-528(s0)
    800041a8:	6388                	ld	a0,0(a5)
    800041aa:	c925                	beqz	a0,8000421a <exec+0x226>
    800041ac:	e9040993          	addi	s3,s0,-368
    800041b0:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800041b4:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800041b6:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800041b8:	ffffc097          	auipc	ra,0xffffc
    800041bc:	13c080e7          	jalr	316(ra) # 800002f4 <strlen>
    800041c0:	0015079b          	addiw	a5,a0,1
    800041c4:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800041c8:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800041cc:	13596663          	bltu	s2,s5,800042f8 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041d0:	df043d83          	ld	s11,-528(s0)
    800041d4:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800041d8:	8552                	mv	a0,s4
    800041da:	ffffc097          	auipc	ra,0xffffc
    800041de:	11a080e7          	jalr	282(ra) # 800002f4 <strlen>
    800041e2:	0015069b          	addiw	a3,a0,1
    800041e6:	8652                	mv	a2,s4
    800041e8:	85ca                	mv	a1,s2
    800041ea:	855a                	mv	a0,s6
    800041ec:	ffffd097          	auipc	ra,0xffffd
    800041f0:	922080e7          	jalr	-1758(ra) # 80000b0e <copyout>
    800041f4:	10054663          	bltz	a0,80004300 <exec+0x30c>
    ustack[argc] = sp;
    800041f8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800041fc:	0485                	addi	s1,s1,1
    800041fe:	008d8793          	addi	a5,s11,8
    80004202:	def43823          	sd	a5,-528(s0)
    80004206:	008db503          	ld	a0,8(s11)
    8000420a:	c911                	beqz	a0,8000421e <exec+0x22a>
    if(argc >= MAXARG)
    8000420c:	09a1                	addi	s3,s3,8
    8000420e:	fb3c95e3          	bne	s9,s3,800041b8 <exec+0x1c4>
  sz = sz1;
    80004212:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004216:	4a81                	li	s5,0
    80004218:	a84d                	j	800042ca <exec+0x2d6>
  sp = sz;
    8000421a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000421c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000421e:	00349793          	slli	a5,s1,0x3
    80004222:	f9040713          	addi	a4,s0,-112
    80004226:	97ba                	add	a5,a5,a4
    80004228:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdcfd0>
  sp -= (argc+1) * sizeof(uint64);
    8000422c:	00148693          	addi	a3,s1,1
    80004230:	068e                	slli	a3,a3,0x3
    80004232:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004236:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000423a:	01597663          	bgeu	s2,s5,80004246 <exec+0x252>
  sz = sz1;
    8000423e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004242:	4a81                	li	s5,0
    80004244:	a059                	j	800042ca <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004246:	e9040613          	addi	a2,s0,-368
    8000424a:	85ca                	mv	a1,s2
    8000424c:	855a                	mv	a0,s6
    8000424e:	ffffd097          	auipc	ra,0xffffd
    80004252:	8c0080e7          	jalr	-1856(ra) # 80000b0e <copyout>
    80004256:	0a054963          	bltz	a0,80004308 <exec+0x314>
  p->trapframe->a1 = sp;
    8000425a:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    8000425e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004262:	de843783          	ld	a5,-536(s0)
    80004266:	0007c703          	lbu	a4,0(a5)
    8000426a:	cf11                	beqz	a4,80004286 <exec+0x292>
    8000426c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000426e:	02f00693          	li	a3,47
    80004272:	a039                	j	80004280 <exec+0x28c>
      last = s+1;
    80004274:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004278:	0785                	addi	a5,a5,1
    8000427a:	fff7c703          	lbu	a4,-1(a5)
    8000427e:	c701                	beqz	a4,80004286 <exec+0x292>
    if(*s == '/')
    80004280:	fed71ce3          	bne	a4,a3,80004278 <exec+0x284>
    80004284:	bfc5                	j	80004274 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    80004286:	4641                	li	a2,16
    80004288:	de843583          	ld	a1,-536(s0)
    8000428c:	158b8513          	addi	a0,s7,344
    80004290:	ffffc097          	auipc	ra,0xffffc
    80004294:	032080e7          	jalr	50(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004298:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000429c:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800042a0:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800042a4:	058bb783          	ld	a5,88(s7)
    800042a8:	e6843703          	ld	a4,-408(s0)
    800042ac:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042ae:	058bb783          	ld	a5,88(s7)
    800042b2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800042b6:	85ea                	mv	a1,s10
    800042b8:	ffffd097          	auipc	ra,0xffffd
    800042bc:	cfa080e7          	jalr	-774(ra) # 80000fb2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800042c0:	0004851b          	sext.w	a0,s1
    800042c4:	b3f1                	j	80004090 <exec+0x9c>
    800042c6:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800042ca:	df843583          	ld	a1,-520(s0)
    800042ce:	855a                	mv	a0,s6
    800042d0:	ffffd097          	auipc	ra,0xffffd
    800042d4:	ce2080e7          	jalr	-798(ra) # 80000fb2 <proc_freepagetable>
  if(ip){
    800042d8:	da0a92e3          	bnez	s5,8000407c <exec+0x88>
  return -1;
    800042dc:	557d                	li	a0,-1
    800042de:	bb4d                	j	80004090 <exec+0x9c>
    800042e0:	df243c23          	sd	s2,-520(s0)
    800042e4:	b7dd                	j	800042ca <exec+0x2d6>
    800042e6:	df243c23          	sd	s2,-520(s0)
    800042ea:	b7c5                	j	800042ca <exec+0x2d6>
    800042ec:	df243c23          	sd	s2,-520(s0)
    800042f0:	bfe9                	j	800042ca <exec+0x2d6>
    800042f2:	df243c23          	sd	s2,-520(s0)
    800042f6:	bfd1                	j	800042ca <exec+0x2d6>
  sz = sz1;
    800042f8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042fc:	4a81                	li	s5,0
    800042fe:	b7f1                	j	800042ca <exec+0x2d6>
  sz = sz1;
    80004300:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004304:	4a81                	li	s5,0
    80004306:	b7d1                	j	800042ca <exec+0x2d6>
  sz = sz1;
    80004308:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000430c:	4a81                	li	s5,0
    8000430e:	bf75                	j	800042ca <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004310:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004314:	e0843783          	ld	a5,-504(s0)
    80004318:	0017869b          	addiw	a3,a5,1
    8000431c:	e0d43423          	sd	a3,-504(s0)
    80004320:	e0043783          	ld	a5,-512(s0)
    80004324:	0387879b          	addiw	a5,a5,56
    80004328:	e8845703          	lhu	a4,-376(s0)
    8000432c:	e0e6dee3          	bge	a3,a4,80004148 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004330:	2781                	sext.w	a5,a5
    80004332:	e0f43023          	sd	a5,-512(s0)
    80004336:	03800713          	li	a4,56
    8000433a:	86be                	mv	a3,a5
    8000433c:	e1840613          	addi	a2,s0,-488
    80004340:	4581                	li	a1,0
    80004342:	8556                	mv	a0,s5
    80004344:	fffff097          	auipc	ra,0xfffff
    80004348:	a5c080e7          	jalr	-1444(ra) # 80002da0 <readi>
    8000434c:	03800793          	li	a5,56
    80004350:	f6f51be3          	bne	a0,a5,800042c6 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    80004354:	e1842783          	lw	a5,-488(s0)
    80004358:	4705                	li	a4,1
    8000435a:	fae79de3          	bne	a5,a4,80004314 <exec+0x320>
    if(ph.memsz < ph.filesz)
    8000435e:	e4043483          	ld	s1,-448(s0)
    80004362:	e3843783          	ld	a5,-456(s0)
    80004366:	f6f4ede3          	bltu	s1,a5,800042e0 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000436a:	e2843783          	ld	a5,-472(s0)
    8000436e:	94be                	add	s1,s1,a5
    80004370:	f6f4ebe3          	bltu	s1,a5,800042e6 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    80004374:	de043703          	ld	a4,-544(s0)
    80004378:	8ff9                	and	a5,a5,a4
    8000437a:	fbad                	bnez	a5,800042ec <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000437c:	e1c42503          	lw	a0,-484(s0)
    80004380:	00000097          	auipc	ra,0x0
    80004384:	c58080e7          	jalr	-936(ra) # 80003fd8 <flags2perm>
    80004388:	86aa                	mv	a3,a0
    8000438a:	8626                	mv	a2,s1
    8000438c:	85ca                	mv	a1,s2
    8000438e:	855a                	mv	a0,s6
    80004390:	ffffc097          	auipc	ra,0xffffc
    80004394:	526080e7          	jalr	1318(ra) # 800008b6 <uvmalloc>
    80004398:	dea43c23          	sd	a0,-520(s0)
    8000439c:	d939                	beqz	a0,800042f2 <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000439e:	e2843c03          	ld	s8,-472(s0)
    800043a2:	e2042c83          	lw	s9,-480(s0)
    800043a6:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043aa:	f60b83e3          	beqz	s7,80004310 <exec+0x31c>
    800043ae:	89de                	mv	s3,s7
    800043b0:	4481                	li	s1,0
    800043b2:	bb95                	j	80004126 <exec+0x132>

00000000800043b4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043b4:	7179                	addi	sp,sp,-48
    800043b6:	f406                	sd	ra,40(sp)
    800043b8:	f022                	sd	s0,32(sp)
    800043ba:	ec26                	sd	s1,24(sp)
    800043bc:	e84a                	sd	s2,16(sp)
    800043be:	1800                	addi	s0,sp,48
    800043c0:	892e                	mv	s2,a1
    800043c2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800043c4:	fdc40593          	addi	a1,s0,-36
    800043c8:	ffffe097          	auipc	ra,0xffffe
    800043cc:	baa080e7          	jalr	-1110(ra) # 80001f72 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043d0:	fdc42703          	lw	a4,-36(s0)
    800043d4:	47bd                	li	a5,15
    800043d6:	02e7eb63          	bltu	a5,a4,8000440c <argfd+0x58>
    800043da:	ffffd097          	auipc	ra,0xffffd
    800043de:	a78080e7          	jalr	-1416(ra) # 80000e52 <myproc>
    800043e2:	fdc42703          	lw	a4,-36(s0)
    800043e6:	01a70793          	addi	a5,a4,26
    800043ea:	078e                	slli	a5,a5,0x3
    800043ec:	953e                	add	a0,a0,a5
    800043ee:	611c                	ld	a5,0(a0)
    800043f0:	c385                	beqz	a5,80004410 <argfd+0x5c>
    return -1;
  if(pfd)
    800043f2:	00090463          	beqz	s2,800043fa <argfd+0x46>
    *pfd = fd;
    800043f6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800043fa:	4501                	li	a0,0
  if(pf)
    800043fc:	c091                	beqz	s1,80004400 <argfd+0x4c>
    *pf = f;
    800043fe:	e09c                	sd	a5,0(s1)
}
    80004400:	70a2                	ld	ra,40(sp)
    80004402:	7402                	ld	s0,32(sp)
    80004404:	64e2                	ld	s1,24(sp)
    80004406:	6942                	ld	s2,16(sp)
    80004408:	6145                	addi	sp,sp,48
    8000440a:	8082                	ret
    return -1;
    8000440c:	557d                	li	a0,-1
    8000440e:	bfcd                	j	80004400 <argfd+0x4c>
    80004410:	557d                	li	a0,-1
    80004412:	b7fd                	j	80004400 <argfd+0x4c>

0000000080004414 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004414:	1101                	addi	sp,sp,-32
    80004416:	ec06                	sd	ra,24(sp)
    80004418:	e822                	sd	s0,16(sp)
    8000441a:	e426                	sd	s1,8(sp)
    8000441c:	1000                	addi	s0,sp,32
    8000441e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004420:	ffffd097          	auipc	ra,0xffffd
    80004424:	a32080e7          	jalr	-1486(ra) # 80000e52 <myproc>
    80004428:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000442a:	0d050793          	addi	a5,a0,208
    8000442e:	4501                	li	a0,0
    80004430:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004432:	6398                	ld	a4,0(a5)
    80004434:	cb19                	beqz	a4,8000444a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004436:	2505                	addiw	a0,a0,1
    80004438:	07a1                	addi	a5,a5,8
    8000443a:	fed51ce3          	bne	a0,a3,80004432 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000443e:	557d                	li	a0,-1
}
    80004440:	60e2                	ld	ra,24(sp)
    80004442:	6442                	ld	s0,16(sp)
    80004444:	64a2                	ld	s1,8(sp)
    80004446:	6105                	addi	sp,sp,32
    80004448:	8082                	ret
      p->ofile[fd] = f;
    8000444a:	01a50793          	addi	a5,a0,26
    8000444e:	078e                	slli	a5,a5,0x3
    80004450:	963e                	add	a2,a2,a5
    80004452:	e204                	sd	s1,0(a2)
      return fd;
    80004454:	b7f5                	j	80004440 <fdalloc+0x2c>

0000000080004456 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004456:	715d                	addi	sp,sp,-80
    80004458:	e486                	sd	ra,72(sp)
    8000445a:	e0a2                	sd	s0,64(sp)
    8000445c:	fc26                	sd	s1,56(sp)
    8000445e:	f84a                	sd	s2,48(sp)
    80004460:	f44e                	sd	s3,40(sp)
    80004462:	f052                	sd	s4,32(sp)
    80004464:	ec56                	sd	s5,24(sp)
    80004466:	e85a                	sd	s6,16(sp)
    80004468:	0880                	addi	s0,sp,80
    8000446a:	8b2e                	mv	s6,a1
    8000446c:	89b2                	mv	s3,a2
    8000446e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004470:	fb040593          	addi	a1,s0,-80
    80004474:	fffff097          	auipc	ra,0xfffff
    80004478:	e3c080e7          	jalr	-452(ra) # 800032b0 <nameiparent>
    8000447c:	84aa                	mv	s1,a0
    8000447e:	14050f63          	beqz	a0,800045dc <create+0x186>
    return 0;

  ilock(dp);
    80004482:	ffffe097          	auipc	ra,0xffffe
    80004486:	66a080e7          	jalr	1642(ra) # 80002aec <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000448a:	4601                	li	a2,0
    8000448c:	fb040593          	addi	a1,s0,-80
    80004490:	8526                	mv	a0,s1
    80004492:	fffff097          	auipc	ra,0xfffff
    80004496:	b3e080e7          	jalr	-1218(ra) # 80002fd0 <dirlookup>
    8000449a:	8aaa                	mv	s5,a0
    8000449c:	c931                	beqz	a0,800044f0 <create+0x9a>
    iunlockput(dp);
    8000449e:	8526                	mv	a0,s1
    800044a0:	fffff097          	auipc	ra,0xfffff
    800044a4:	8ae080e7          	jalr	-1874(ra) # 80002d4e <iunlockput>
    ilock(ip);
    800044a8:	8556                	mv	a0,s5
    800044aa:	ffffe097          	auipc	ra,0xffffe
    800044ae:	642080e7          	jalr	1602(ra) # 80002aec <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044b2:	000b059b          	sext.w	a1,s6
    800044b6:	4789                	li	a5,2
    800044b8:	02f59563          	bne	a1,a5,800044e2 <create+0x8c>
    800044bc:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd114>
    800044c0:	37f9                	addiw	a5,a5,-2
    800044c2:	17c2                	slli	a5,a5,0x30
    800044c4:	93c1                	srli	a5,a5,0x30
    800044c6:	4705                	li	a4,1
    800044c8:	00f76d63          	bltu	a4,a5,800044e2 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800044cc:	8556                	mv	a0,s5
    800044ce:	60a6                	ld	ra,72(sp)
    800044d0:	6406                	ld	s0,64(sp)
    800044d2:	74e2                	ld	s1,56(sp)
    800044d4:	7942                	ld	s2,48(sp)
    800044d6:	79a2                	ld	s3,40(sp)
    800044d8:	7a02                	ld	s4,32(sp)
    800044da:	6ae2                	ld	s5,24(sp)
    800044dc:	6b42                	ld	s6,16(sp)
    800044de:	6161                	addi	sp,sp,80
    800044e0:	8082                	ret
    iunlockput(ip);
    800044e2:	8556                	mv	a0,s5
    800044e4:	fffff097          	auipc	ra,0xfffff
    800044e8:	86a080e7          	jalr	-1942(ra) # 80002d4e <iunlockput>
    return 0;
    800044ec:	4a81                	li	s5,0
    800044ee:	bff9                	j	800044cc <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800044f0:	85da                	mv	a1,s6
    800044f2:	4088                	lw	a0,0(s1)
    800044f4:	ffffe097          	auipc	ra,0xffffe
    800044f8:	45c080e7          	jalr	1116(ra) # 80002950 <ialloc>
    800044fc:	8a2a                	mv	s4,a0
    800044fe:	c539                	beqz	a0,8000454c <create+0xf6>
  ilock(ip);
    80004500:	ffffe097          	auipc	ra,0xffffe
    80004504:	5ec080e7          	jalr	1516(ra) # 80002aec <ilock>
  ip->major = major;
    80004508:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000450c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004510:	4905                	li	s2,1
    80004512:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004516:	8552                	mv	a0,s4
    80004518:	ffffe097          	auipc	ra,0xffffe
    8000451c:	50a080e7          	jalr	1290(ra) # 80002a22 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004520:	000b059b          	sext.w	a1,s6
    80004524:	03258b63          	beq	a1,s2,8000455a <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80004528:	004a2603          	lw	a2,4(s4)
    8000452c:	fb040593          	addi	a1,s0,-80
    80004530:	8526                	mv	a0,s1
    80004532:	fffff097          	auipc	ra,0xfffff
    80004536:	cae080e7          	jalr	-850(ra) # 800031e0 <dirlink>
    8000453a:	06054f63          	bltz	a0,800045b8 <create+0x162>
  iunlockput(dp);
    8000453e:	8526                	mv	a0,s1
    80004540:	fffff097          	auipc	ra,0xfffff
    80004544:	80e080e7          	jalr	-2034(ra) # 80002d4e <iunlockput>
  return ip;
    80004548:	8ad2                	mv	s5,s4
    8000454a:	b749                	j	800044cc <create+0x76>
    iunlockput(dp);
    8000454c:	8526                	mv	a0,s1
    8000454e:	fffff097          	auipc	ra,0xfffff
    80004552:	800080e7          	jalr	-2048(ra) # 80002d4e <iunlockput>
    return 0;
    80004556:	8ad2                	mv	s5,s4
    80004558:	bf95                	j	800044cc <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000455a:	004a2603          	lw	a2,4(s4)
    8000455e:	00004597          	auipc	a1,0x4
    80004562:	11258593          	addi	a1,a1,274 # 80008670 <syscalls+0x2a0>
    80004566:	8552                	mv	a0,s4
    80004568:	fffff097          	auipc	ra,0xfffff
    8000456c:	c78080e7          	jalr	-904(ra) # 800031e0 <dirlink>
    80004570:	04054463          	bltz	a0,800045b8 <create+0x162>
    80004574:	40d0                	lw	a2,4(s1)
    80004576:	00004597          	auipc	a1,0x4
    8000457a:	10258593          	addi	a1,a1,258 # 80008678 <syscalls+0x2a8>
    8000457e:	8552                	mv	a0,s4
    80004580:	fffff097          	auipc	ra,0xfffff
    80004584:	c60080e7          	jalr	-928(ra) # 800031e0 <dirlink>
    80004588:	02054863          	bltz	a0,800045b8 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    8000458c:	004a2603          	lw	a2,4(s4)
    80004590:	fb040593          	addi	a1,s0,-80
    80004594:	8526                	mv	a0,s1
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	c4a080e7          	jalr	-950(ra) # 800031e0 <dirlink>
    8000459e:	00054d63          	bltz	a0,800045b8 <create+0x162>
    dp->nlink++;  // for ".."
    800045a2:	04a4d783          	lhu	a5,74(s1)
    800045a6:	2785                	addiw	a5,a5,1
    800045a8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045ac:	8526                	mv	a0,s1
    800045ae:	ffffe097          	auipc	ra,0xffffe
    800045b2:	474080e7          	jalr	1140(ra) # 80002a22 <iupdate>
    800045b6:	b761                	j	8000453e <create+0xe8>
  ip->nlink = 0;
    800045b8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800045bc:	8552                	mv	a0,s4
    800045be:	ffffe097          	auipc	ra,0xffffe
    800045c2:	464080e7          	jalr	1124(ra) # 80002a22 <iupdate>
  iunlockput(ip);
    800045c6:	8552                	mv	a0,s4
    800045c8:	ffffe097          	auipc	ra,0xffffe
    800045cc:	786080e7          	jalr	1926(ra) # 80002d4e <iunlockput>
  iunlockput(dp);
    800045d0:	8526                	mv	a0,s1
    800045d2:	ffffe097          	auipc	ra,0xffffe
    800045d6:	77c080e7          	jalr	1916(ra) # 80002d4e <iunlockput>
  return 0;
    800045da:	bdcd                	j	800044cc <create+0x76>
    return 0;
    800045dc:	8aaa                	mv	s5,a0
    800045de:	b5fd                	j	800044cc <create+0x76>

00000000800045e0 <sys_dup>:
{
    800045e0:	7179                	addi	sp,sp,-48
    800045e2:	f406                	sd	ra,40(sp)
    800045e4:	f022                	sd	s0,32(sp)
    800045e6:	ec26                	sd	s1,24(sp)
    800045e8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045ea:	fd840613          	addi	a2,s0,-40
    800045ee:	4581                	li	a1,0
    800045f0:	4501                	li	a0,0
    800045f2:	00000097          	auipc	ra,0x0
    800045f6:	dc2080e7          	jalr	-574(ra) # 800043b4 <argfd>
    return -1;
    800045fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045fc:	02054363          	bltz	a0,80004622 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004600:	fd843503          	ld	a0,-40(s0)
    80004604:	00000097          	auipc	ra,0x0
    80004608:	e10080e7          	jalr	-496(ra) # 80004414 <fdalloc>
    8000460c:	84aa                	mv	s1,a0
    return -1;
    8000460e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004610:	00054963          	bltz	a0,80004622 <sys_dup+0x42>
  filedup(f);
    80004614:	fd843503          	ld	a0,-40(s0)
    80004618:	fffff097          	auipc	ra,0xfffff
    8000461c:	310080e7          	jalr	784(ra) # 80003928 <filedup>
  return fd;
    80004620:	87a6                	mv	a5,s1
}
    80004622:	853e                	mv	a0,a5
    80004624:	70a2                	ld	ra,40(sp)
    80004626:	7402                	ld	s0,32(sp)
    80004628:	64e2                	ld	s1,24(sp)
    8000462a:	6145                	addi	sp,sp,48
    8000462c:	8082                	ret

000000008000462e <sys_read>:
{
    8000462e:	7179                	addi	sp,sp,-48
    80004630:	f406                	sd	ra,40(sp)
    80004632:	f022                	sd	s0,32(sp)
    80004634:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004636:	fd840593          	addi	a1,s0,-40
    8000463a:	4505                	li	a0,1
    8000463c:	ffffe097          	auipc	ra,0xffffe
    80004640:	956080e7          	jalr	-1706(ra) # 80001f92 <argaddr>
  argint(2, &n);
    80004644:	fe440593          	addi	a1,s0,-28
    80004648:	4509                	li	a0,2
    8000464a:	ffffe097          	auipc	ra,0xffffe
    8000464e:	928080e7          	jalr	-1752(ra) # 80001f72 <argint>
  if(argfd(0, 0, &f) < 0)
    80004652:	fe840613          	addi	a2,s0,-24
    80004656:	4581                	li	a1,0
    80004658:	4501                	li	a0,0
    8000465a:	00000097          	auipc	ra,0x0
    8000465e:	d5a080e7          	jalr	-678(ra) # 800043b4 <argfd>
    80004662:	87aa                	mv	a5,a0
    return -1;
    80004664:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004666:	0007cc63          	bltz	a5,8000467e <sys_read+0x50>
  return fileread(f, p, n);
    8000466a:	fe442603          	lw	a2,-28(s0)
    8000466e:	fd843583          	ld	a1,-40(s0)
    80004672:	fe843503          	ld	a0,-24(s0)
    80004676:	fffff097          	auipc	ra,0xfffff
    8000467a:	43e080e7          	jalr	1086(ra) # 80003ab4 <fileread>
}
    8000467e:	70a2                	ld	ra,40(sp)
    80004680:	7402                	ld	s0,32(sp)
    80004682:	6145                	addi	sp,sp,48
    80004684:	8082                	ret

0000000080004686 <sys_write>:
{
    80004686:	7179                	addi	sp,sp,-48
    80004688:	f406                	sd	ra,40(sp)
    8000468a:	f022                	sd	s0,32(sp)
    8000468c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000468e:	fd840593          	addi	a1,s0,-40
    80004692:	4505                	li	a0,1
    80004694:	ffffe097          	auipc	ra,0xffffe
    80004698:	8fe080e7          	jalr	-1794(ra) # 80001f92 <argaddr>
  argint(2, &n);
    8000469c:	fe440593          	addi	a1,s0,-28
    800046a0:	4509                	li	a0,2
    800046a2:	ffffe097          	auipc	ra,0xffffe
    800046a6:	8d0080e7          	jalr	-1840(ra) # 80001f72 <argint>
  if(argfd(0, 0, &f) < 0)
    800046aa:	fe840613          	addi	a2,s0,-24
    800046ae:	4581                	li	a1,0
    800046b0:	4501                	li	a0,0
    800046b2:	00000097          	auipc	ra,0x0
    800046b6:	d02080e7          	jalr	-766(ra) # 800043b4 <argfd>
    800046ba:	87aa                	mv	a5,a0
    return -1;
    800046bc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046be:	0007cc63          	bltz	a5,800046d6 <sys_write+0x50>
  return filewrite(f, p, n);
    800046c2:	fe442603          	lw	a2,-28(s0)
    800046c6:	fd843583          	ld	a1,-40(s0)
    800046ca:	fe843503          	ld	a0,-24(s0)
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	4a8080e7          	jalr	1192(ra) # 80003b76 <filewrite>
}
    800046d6:	70a2                	ld	ra,40(sp)
    800046d8:	7402                	ld	s0,32(sp)
    800046da:	6145                	addi	sp,sp,48
    800046dc:	8082                	ret

00000000800046de <sys_close>:
{
    800046de:	1101                	addi	sp,sp,-32
    800046e0:	ec06                	sd	ra,24(sp)
    800046e2:	e822                	sd	s0,16(sp)
    800046e4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046e6:	fe040613          	addi	a2,s0,-32
    800046ea:	fec40593          	addi	a1,s0,-20
    800046ee:	4501                	li	a0,0
    800046f0:	00000097          	auipc	ra,0x0
    800046f4:	cc4080e7          	jalr	-828(ra) # 800043b4 <argfd>
    return -1;
    800046f8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046fa:	02054463          	bltz	a0,80004722 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046fe:	ffffc097          	auipc	ra,0xffffc
    80004702:	754080e7          	jalr	1876(ra) # 80000e52 <myproc>
    80004706:	fec42783          	lw	a5,-20(s0)
    8000470a:	07e9                	addi	a5,a5,26
    8000470c:	078e                	slli	a5,a5,0x3
    8000470e:	97aa                	add	a5,a5,a0
    80004710:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004714:	fe043503          	ld	a0,-32(s0)
    80004718:	fffff097          	auipc	ra,0xfffff
    8000471c:	262080e7          	jalr	610(ra) # 8000397a <fileclose>
  return 0;
    80004720:	4781                	li	a5,0
}
    80004722:	853e                	mv	a0,a5
    80004724:	60e2                	ld	ra,24(sp)
    80004726:	6442                	ld	s0,16(sp)
    80004728:	6105                	addi	sp,sp,32
    8000472a:	8082                	ret

000000008000472c <sys_fstat>:
{
    8000472c:	1101                	addi	sp,sp,-32
    8000472e:	ec06                	sd	ra,24(sp)
    80004730:	e822                	sd	s0,16(sp)
    80004732:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004734:	fe040593          	addi	a1,s0,-32
    80004738:	4505                	li	a0,1
    8000473a:	ffffe097          	auipc	ra,0xffffe
    8000473e:	858080e7          	jalr	-1960(ra) # 80001f92 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004742:	fe840613          	addi	a2,s0,-24
    80004746:	4581                	li	a1,0
    80004748:	4501                	li	a0,0
    8000474a:	00000097          	auipc	ra,0x0
    8000474e:	c6a080e7          	jalr	-918(ra) # 800043b4 <argfd>
    80004752:	87aa                	mv	a5,a0
    return -1;
    80004754:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004756:	0007ca63          	bltz	a5,8000476a <sys_fstat+0x3e>
  return filestat(f, st);
    8000475a:	fe043583          	ld	a1,-32(s0)
    8000475e:	fe843503          	ld	a0,-24(s0)
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	2e0080e7          	jalr	736(ra) # 80003a42 <filestat>
}
    8000476a:	60e2                	ld	ra,24(sp)
    8000476c:	6442                	ld	s0,16(sp)
    8000476e:	6105                	addi	sp,sp,32
    80004770:	8082                	ret

0000000080004772 <sys_link>:
{
    80004772:	7169                	addi	sp,sp,-304
    80004774:	f606                	sd	ra,296(sp)
    80004776:	f222                	sd	s0,288(sp)
    80004778:	ee26                	sd	s1,280(sp)
    8000477a:	ea4a                	sd	s2,272(sp)
    8000477c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000477e:	08000613          	li	a2,128
    80004782:	ed040593          	addi	a1,s0,-304
    80004786:	4501                	li	a0,0
    80004788:	ffffe097          	auipc	ra,0xffffe
    8000478c:	82a080e7          	jalr	-2006(ra) # 80001fb2 <argstr>
    return -1;
    80004790:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004792:	10054e63          	bltz	a0,800048ae <sys_link+0x13c>
    80004796:	08000613          	li	a2,128
    8000479a:	f5040593          	addi	a1,s0,-176
    8000479e:	4505                	li	a0,1
    800047a0:	ffffe097          	auipc	ra,0xffffe
    800047a4:	812080e7          	jalr	-2030(ra) # 80001fb2 <argstr>
    return -1;
    800047a8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047aa:	10054263          	bltz	a0,800048ae <sys_link+0x13c>
  begin_op();
    800047ae:	fffff097          	auipc	ra,0xfffff
    800047b2:	d00080e7          	jalr	-768(ra) # 800034ae <begin_op>
  if((ip = namei(old)) == 0){
    800047b6:	ed040513          	addi	a0,s0,-304
    800047ba:	fffff097          	auipc	ra,0xfffff
    800047be:	ad8080e7          	jalr	-1320(ra) # 80003292 <namei>
    800047c2:	84aa                	mv	s1,a0
    800047c4:	c551                	beqz	a0,80004850 <sys_link+0xde>
  ilock(ip);
    800047c6:	ffffe097          	auipc	ra,0xffffe
    800047ca:	326080e7          	jalr	806(ra) # 80002aec <ilock>
  if(ip->type == T_DIR){
    800047ce:	04449703          	lh	a4,68(s1)
    800047d2:	4785                	li	a5,1
    800047d4:	08f70463          	beq	a4,a5,8000485c <sys_link+0xea>
  ip->nlink++;
    800047d8:	04a4d783          	lhu	a5,74(s1)
    800047dc:	2785                	addiw	a5,a5,1
    800047de:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047e2:	8526                	mv	a0,s1
    800047e4:	ffffe097          	auipc	ra,0xffffe
    800047e8:	23e080e7          	jalr	574(ra) # 80002a22 <iupdate>
  iunlock(ip);
    800047ec:	8526                	mv	a0,s1
    800047ee:	ffffe097          	auipc	ra,0xffffe
    800047f2:	3c0080e7          	jalr	960(ra) # 80002bae <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047f6:	fd040593          	addi	a1,s0,-48
    800047fa:	f5040513          	addi	a0,s0,-176
    800047fe:	fffff097          	auipc	ra,0xfffff
    80004802:	ab2080e7          	jalr	-1358(ra) # 800032b0 <nameiparent>
    80004806:	892a                	mv	s2,a0
    80004808:	c935                	beqz	a0,8000487c <sys_link+0x10a>
  ilock(dp);
    8000480a:	ffffe097          	auipc	ra,0xffffe
    8000480e:	2e2080e7          	jalr	738(ra) # 80002aec <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004812:	00092703          	lw	a4,0(s2)
    80004816:	409c                	lw	a5,0(s1)
    80004818:	04f71d63          	bne	a4,a5,80004872 <sys_link+0x100>
    8000481c:	40d0                	lw	a2,4(s1)
    8000481e:	fd040593          	addi	a1,s0,-48
    80004822:	854a                	mv	a0,s2
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	9bc080e7          	jalr	-1604(ra) # 800031e0 <dirlink>
    8000482c:	04054363          	bltz	a0,80004872 <sys_link+0x100>
  iunlockput(dp);
    80004830:	854a                	mv	a0,s2
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	51c080e7          	jalr	1308(ra) # 80002d4e <iunlockput>
  iput(ip);
    8000483a:	8526                	mv	a0,s1
    8000483c:	ffffe097          	auipc	ra,0xffffe
    80004840:	46a080e7          	jalr	1130(ra) # 80002ca6 <iput>
  end_op();
    80004844:	fffff097          	auipc	ra,0xfffff
    80004848:	cea080e7          	jalr	-790(ra) # 8000352e <end_op>
  return 0;
    8000484c:	4781                	li	a5,0
    8000484e:	a085                	j	800048ae <sys_link+0x13c>
    end_op();
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	cde080e7          	jalr	-802(ra) # 8000352e <end_op>
    return -1;
    80004858:	57fd                	li	a5,-1
    8000485a:	a891                	j	800048ae <sys_link+0x13c>
    iunlockput(ip);
    8000485c:	8526                	mv	a0,s1
    8000485e:	ffffe097          	auipc	ra,0xffffe
    80004862:	4f0080e7          	jalr	1264(ra) # 80002d4e <iunlockput>
    end_op();
    80004866:	fffff097          	auipc	ra,0xfffff
    8000486a:	cc8080e7          	jalr	-824(ra) # 8000352e <end_op>
    return -1;
    8000486e:	57fd                	li	a5,-1
    80004870:	a83d                	j	800048ae <sys_link+0x13c>
    iunlockput(dp);
    80004872:	854a                	mv	a0,s2
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	4da080e7          	jalr	1242(ra) # 80002d4e <iunlockput>
  ilock(ip);
    8000487c:	8526                	mv	a0,s1
    8000487e:	ffffe097          	auipc	ra,0xffffe
    80004882:	26e080e7          	jalr	622(ra) # 80002aec <ilock>
  ip->nlink--;
    80004886:	04a4d783          	lhu	a5,74(s1)
    8000488a:	37fd                	addiw	a5,a5,-1
    8000488c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004890:	8526                	mv	a0,s1
    80004892:	ffffe097          	auipc	ra,0xffffe
    80004896:	190080e7          	jalr	400(ra) # 80002a22 <iupdate>
  iunlockput(ip);
    8000489a:	8526                	mv	a0,s1
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	4b2080e7          	jalr	1202(ra) # 80002d4e <iunlockput>
  end_op();
    800048a4:	fffff097          	auipc	ra,0xfffff
    800048a8:	c8a080e7          	jalr	-886(ra) # 8000352e <end_op>
  return -1;
    800048ac:	57fd                	li	a5,-1
}
    800048ae:	853e                	mv	a0,a5
    800048b0:	70b2                	ld	ra,296(sp)
    800048b2:	7412                	ld	s0,288(sp)
    800048b4:	64f2                	ld	s1,280(sp)
    800048b6:	6952                	ld	s2,272(sp)
    800048b8:	6155                	addi	sp,sp,304
    800048ba:	8082                	ret

00000000800048bc <sys_unlink>:
{
    800048bc:	7151                	addi	sp,sp,-240
    800048be:	f586                	sd	ra,232(sp)
    800048c0:	f1a2                	sd	s0,224(sp)
    800048c2:	eda6                	sd	s1,216(sp)
    800048c4:	e9ca                	sd	s2,208(sp)
    800048c6:	e5ce                	sd	s3,200(sp)
    800048c8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048ca:	08000613          	li	a2,128
    800048ce:	f3040593          	addi	a1,s0,-208
    800048d2:	4501                	li	a0,0
    800048d4:	ffffd097          	auipc	ra,0xffffd
    800048d8:	6de080e7          	jalr	1758(ra) # 80001fb2 <argstr>
    800048dc:	18054163          	bltz	a0,80004a5e <sys_unlink+0x1a2>
  begin_op();
    800048e0:	fffff097          	auipc	ra,0xfffff
    800048e4:	bce080e7          	jalr	-1074(ra) # 800034ae <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048e8:	fb040593          	addi	a1,s0,-80
    800048ec:	f3040513          	addi	a0,s0,-208
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	9c0080e7          	jalr	-1600(ra) # 800032b0 <nameiparent>
    800048f8:	84aa                	mv	s1,a0
    800048fa:	c979                	beqz	a0,800049d0 <sys_unlink+0x114>
  ilock(dp);
    800048fc:	ffffe097          	auipc	ra,0xffffe
    80004900:	1f0080e7          	jalr	496(ra) # 80002aec <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004904:	00004597          	auipc	a1,0x4
    80004908:	d6c58593          	addi	a1,a1,-660 # 80008670 <syscalls+0x2a0>
    8000490c:	fb040513          	addi	a0,s0,-80
    80004910:	ffffe097          	auipc	ra,0xffffe
    80004914:	6a6080e7          	jalr	1702(ra) # 80002fb6 <namecmp>
    80004918:	14050a63          	beqz	a0,80004a6c <sys_unlink+0x1b0>
    8000491c:	00004597          	auipc	a1,0x4
    80004920:	d5c58593          	addi	a1,a1,-676 # 80008678 <syscalls+0x2a8>
    80004924:	fb040513          	addi	a0,s0,-80
    80004928:	ffffe097          	auipc	ra,0xffffe
    8000492c:	68e080e7          	jalr	1678(ra) # 80002fb6 <namecmp>
    80004930:	12050e63          	beqz	a0,80004a6c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004934:	f2c40613          	addi	a2,s0,-212
    80004938:	fb040593          	addi	a1,s0,-80
    8000493c:	8526                	mv	a0,s1
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	692080e7          	jalr	1682(ra) # 80002fd0 <dirlookup>
    80004946:	892a                	mv	s2,a0
    80004948:	12050263          	beqz	a0,80004a6c <sys_unlink+0x1b0>
  ilock(ip);
    8000494c:	ffffe097          	auipc	ra,0xffffe
    80004950:	1a0080e7          	jalr	416(ra) # 80002aec <ilock>
  if(ip->nlink < 1)
    80004954:	04a91783          	lh	a5,74(s2)
    80004958:	08f05263          	blez	a5,800049dc <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000495c:	04491703          	lh	a4,68(s2)
    80004960:	4785                	li	a5,1
    80004962:	08f70563          	beq	a4,a5,800049ec <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004966:	4641                	li	a2,16
    80004968:	4581                	li	a1,0
    8000496a:	fc040513          	addi	a0,s0,-64
    8000496e:	ffffc097          	auipc	ra,0xffffc
    80004972:	80a080e7          	jalr	-2038(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004976:	4741                	li	a4,16
    80004978:	f2c42683          	lw	a3,-212(s0)
    8000497c:	fc040613          	addi	a2,s0,-64
    80004980:	4581                	li	a1,0
    80004982:	8526                	mv	a0,s1
    80004984:	ffffe097          	auipc	ra,0xffffe
    80004988:	514080e7          	jalr	1300(ra) # 80002e98 <writei>
    8000498c:	47c1                	li	a5,16
    8000498e:	0af51563          	bne	a0,a5,80004a38 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004992:	04491703          	lh	a4,68(s2)
    80004996:	4785                	li	a5,1
    80004998:	0af70863          	beq	a4,a5,80004a48 <sys_unlink+0x18c>
  iunlockput(dp);
    8000499c:	8526                	mv	a0,s1
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	3b0080e7          	jalr	944(ra) # 80002d4e <iunlockput>
  ip->nlink--;
    800049a6:	04a95783          	lhu	a5,74(s2)
    800049aa:	37fd                	addiw	a5,a5,-1
    800049ac:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049b0:	854a                	mv	a0,s2
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	070080e7          	jalr	112(ra) # 80002a22 <iupdate>
  iunlockput(ip);
    800049ba:	854a                	mv	a0,s2
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	392080e7          	jalr	914(ra) # 80002d4e <iunlockput>
  end_op();
    800049c4:	fffff097          	auipc	ra,0xfffff
    800049c8:	b6a080e7          	jalr	-1174(ra) # 8000352e <end_op>
  return 0;
    800049cc:	4501                	li	a0,0
    800049ce:	a84d                	j	80004a80 <sys_unlink+0x1c4>
    end_op();
    800049d0:	fffff097          	auipc	ra,0xfffff
    800049d4:	b5e080e7          	jalr	-1186(ra) # 8000352e <end_op>
    return -1;
    800049d8:	557d                	li	a0,-1
    800049da:	a05d                	j	80004a80 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049dc:	00004517          	auipc	a0,0x4
    800049e0:	ca450513          	addi	a0,a0,-860 # 80008680 <syscalls+0x2b0>
    800049e4:	00001097          	auipc	ra,0x1
    800049e8:	1ba080e7          	jalr	442(ra) # 80005b9e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049ec:	04c92703          	lw	a4,76(s2)
    800049f0:	02000793          	li	a5,32
    800049f4:	f6e7f9e3          	bgeu	a5,a4,80004966 <sys_unlink+0xaa>
    800049f8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049fc:	4741                	li	a4,16
    800049fe:	86ce                	mv	a3,s3
    80004a00:	f1840613          	addi	a2,s0,-232
    80004a04:	4581                	li	a1,0
    80004a06:	854a                	mv	a0,s2
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	398080e7          	jalr	920(ra) # 80002da0 <readi>
    80004a10:	47c1                	li	a5,16
    80004a12:	00f51b63          	bne	a0,a5,80004a28 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a16:	f1845783          	lhu	a5,-232(s0)
    80004a1a:	e7a1                	bnez	a5,80004a62 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a1c:	29c1                	addiw	s3,s3,16
    80004a1e:	04c92783          	lw	a5,76(s2)
    80004a22:	fcf9ede3          	bltu	s3,a5,800049fc <sys_unlink+0x140>
    80004a26:	b781                	j	80004966 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a28:	00004517          	auipc	a0,0x4
    80004a2c:	c7050513          	addi	a0,a0,-912 # 80008698 <syscalls+0x2c8>
    80004a30:	00001097          	auipc	ra,0x1
    80004a34:	16e080e7          	jalr	366(ra) # 80005b9e <panic>
    panic("unlink: writei");
    80004a38:	00004517          	auipc	a0,0x4
    80004a3c:	c7850513          	addi	a0,a0,-904 # 800086b0 <syscalls+0x2e0>
    80004a40:	00001097          	auipc	ra,0x1
    80004a44:	15e080e7          	jalr	350(ra) # 80005b9e <panic>
    dp->nlink--;
    80004a48:	04a4d783          	lhu	a5,74(s1)
    80004a4c:	37fd                	addiw	a5,a5,-1
    80004a4e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a52:	8526                	mv	a0,s1
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	fce080e7          	jalr	-50(ra) # 80002a22 <iupdate>
    80004a5c:	b781                	j	8000499c <sys_unlink+0xe0>
    return -1;
    80004a5e:	557d                	li	a0,-1
    80004a60:	a005                	j	80004a80 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a62:	854a                	mv	a0,s2
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	2ea080e7          	jalr	746(ra) # 80002d4e <iunlockput>
  iunlockput(dp);
    80004a6c:	8526                	mv	a0,s1
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	2e0080e7          	jalr	736(ra) # 80002d4e <iunlockput>
  end_op();
    80004a76:	fffff097          	auipc	ra,0xfffff
    80004a7a:	ab8080e7          	jalr	-1352(ra) # 8000352e <end_op>
  return -1;
    80004a7e:	557d                	li	a0,-1
}
    80004a80:	70ae                	ld	ra,232(sp)
    80004a82:	740e                	ld	s0,224(sp)
    80004a84:	64ee                	ld	s1,216(sp)
    80004a86:	694e                	ld	s2,208(sp)
    80004a88:	69ae                	ld	s3,200(sp)
    80004a8a:	616d                	addi	sp,sp,240
    80004a8c:	8082                	ret

0000000080004a8e <sys_open>:

uint64
sys_open(void)
{
    80004a8e:	7131                	addi	sp,sp,-192
    80004a90:	fd06                	sd	ra,184(sp)
    80004a92:	f922                	sd	s0,176(sp)
    80004a94:	f526                	sd	s1,168(sp)
    80004a96:	f14a                	sd	s2,160(sp)
    80004a98:	ed4e                	sd	s3,152(sp)
    80004a9a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004a9c:	f4c40593          	addi	a1,s0,-180
    80004aa0:	4505                	li	a0,1
    80004aa2:	ffffd097          	auipc	ra,0xffffd
    80004aa6:	4d0080e7          	jalr	1232(ra) # 80001f72 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004aaa:	08000613          	li	a2,128
    80004aae:	f5040593          	addi	a1,s0,-176
    80004ab2:	4501                	li	a0,0
    80004ab4:	ffffd097          	auipc	ra,0xffffd
    80004ab8:	4fe080e7          	jalr	1278(ra) # 80001fb2 <argstr>
    80004abc:	87aa                	mv	a5,a0
    return -1;
    80004abe:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ac0:	0a07c963          	bltz	a5,80004b72 <sys_open+0xe4>

  begin_op();
    80004ac4:	fffff097          	auipc	ra,0xfffff
    80004ac8:	9ea080e7          	jalr	-1558(ra) # 800034ae <begin_op>

  if(omode & O_CREATE){
    80004acc:	f4c42783          	lw	a5,-180(s0)
    80004ad0:	2007f793          	andi	a5,a5,512
    80004ad4:	cfc5                	beqz	a5,80004b8c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ad6:	4681                	li	a3,0
    80004ad8:	4601                	li	a2,0
    80004ada:	4589                	li	a1,2
    80004adc:	f5040513          	addi	a0,s0,-176
    80004ae0:	00000097          	auipc	ra,0x0
    80004ae4:	976080e7          	jalr	-1674(ra) # 80004456 <create>
    80004ae8:	84aa                	mv	s1,a0
    if(ip == 0){
    80004aea:	c959                	beqz	a0,80004b80 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004aec:	04449703          	lh	a4,68(s1)
    80004af0:	478d                	li	a5,3
    80004af2:	00f71763          	bne	a4,a5,80004b00 <sys_open+0x72>
    80004af6:	0464d703          	lhu	a4,70(s1)
    80004afa:	47a5                	li	a5,9
    80004afc:	0ce7ed63          	bltu	a5,a4,80004bd6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b00:	fffff097          	auipc	ra,0xfffff
    80004b04:	dbe080e7          	jalr	-578(ra) # 800038be <filealloc>
    80004b08:	89aa                	mv	s3,a0
    80004b0a:	10050363          	beqz	a0,80004c10 <sys_open+0x182>
    80004b0e:	00000097          	auipc	ra,0x0
    80004b12:	906080e7          	jalr	-1786(ra) # 80004414 <fdalloc>
    80004b16:	892a                	mv	s2,a0
    80004b18:	0e054763          	bltz	a0,80004c06 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b1c:	04449703          	lh	a4,68(s1)
    80004b20:	478d                	li	a5,3
    80004b22:	0cf70563          	beq	a4,a5,80004bec <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b26:	4789                	li	a5,2
    80004b28:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b2c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b30:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b34:	f4c42783          	lw	a5,-180(s0)
    80004b38:	0017c713          	xori	a4,a5,1
    80004b3c:	8b05                	andi	a4,a4,1
    80004b3e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b42:	0037f713          	andi	a4,a5,3
    80004b46:	00e03733          	snez	a4,a4
    80004b4a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b4e:	4007f793          	andi	a5,a5,1024
    80004b52:	c791                	beqz	a5,80004b5e <sys_open+0xd0>
    80004b54:	04449703          	lh	a4,68(s1)
    80004b58:	4789                	li	a5,2
    80004b5a:	0af70063          	beq	a4,a5,80004bfa <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b5e:	8526                	mv	a0,s1
    80004b60:	ffffe097          	auipc	ra,0xffffe
    80004b64:	04e080e7          	jalr	78(ra) # 80002bae <iunlock>
  end_op();
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	9c6080e7          	jalr	-1594(ra) # 8000352e <end_op>

  return fd;
    80004b70:	854a                	mv	a0,s2
}
    80004b72:	70ea                	ld	ra,184(sp)
    80004b74:	744a                	ld	s0,176(sp)
    80004b76:	74aa                	ld	s1,168(sp)
    80004b78:	790a                	ld	s2,160(sp)
    80004b7a:	69ea                	ld	s3,152(sp)
    80004b7c:	6129                	addi	sp,sp,192
    80004b7e:	8082                	ret
      end_op();
    80004b80:	fffff097          	auipc	ra,0xfffff
    80004b84:	9ae080e7          	jalr	-1618(ra) # 8000352e <end_op>
      return -1;
    80004b88:	557d                	li	a0,-1
    80004b8a:	b7e5                	j	80004b72 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004b8c:	f5040513          	addi	a0,s0,-176
    80004b90:	ffffe097          	auipc	ra,0xffffe
    80004b94:	702080e7          	jalr	1794(ra) # 80003292 <namei>
    80004b98:	84aa                	mv	s1,a0
    80004b9a:	c905                	beqz	a0,80004bca <sys_open+0x13c>
    ilock(ip);
    80004b9c:	ffffe097          	auipc	ra,0xffffe
    80004ba0:	f50080e7          	jalr	-176(ra) # 80002aec <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ba4:	04449703          	lh	a4,68(s1)
    80004ba8:	4785                	li	a5,1
    80004baa:	f4f711e3          	bne	a4,a5,80004aec <sys_open+0x5e>
    80004bae:	f4c42783          	lw	a5,-180(s0)
    80004bb2:	d7b9                	beqz	a5,80004b00 <sys_open+0x72>
      iunlockput(ip);
    80004bb4:	8526                	mv	a0,s1
    80004bb6:	ffffe097          	auipc	ra,0xffffe
    80004bba:	198080e7          	jalr	408(ra) # 80002d4e <iunlockput>
      end_op();
    80004bbe:	fffff097          	auipc	ra,0xfffff
    80004bc2:	970080e7          	jalr	-1680(ra) # 8000352e <end_op>
      return -1;
    80004bc6:	557d                	li	a0,-1
    80004bc8:	b76d                	j	80004b72 <sys_open+0xe4>
      end_op();
    80004bca:	fffff097          	auipc	ra,0xfffff
    80004bce:	964080e7          	jalr	-1692(ra) # 8000352e <end_op>
      return -1;
    80004bd2:	557d                	li	a0,-1
    80004bd4:	bf79                	j	80004b72 <sys_open+0xe4>
    iunlockput(ip);
    80004bd6:	8526                	mv	a0,s1
    80004bd8:	ffffe097          	auipc	ra,0xffffe
    80004bdc:	176080e7          	jalr	374(ra) # 80002d4e <iunlockput>
    end_op();
    80004be0:	fffff097          	auipc	ra,0xfffff
    80004be4:	94e080e7          	jalr	-1714(ra) # 8000352e <end_op>
    return -1;
    80004be8:	557d                	li	a0,-1
    80004bea:	b761                	j	80004b72 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004bec:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004bf0:	04649783          	lh	a5,70(s1)
    80004bf4:	02f99223          	sh	a5,36(s3)
    80004bf8:	bf25                	j	80004b30 <sys_open+0xa2>
    itrunc(ip);
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	ffe080e7          	jalr	-2(ra) # 80002bfa <itrunc>
    80004c04:	bfa9                	j	80004b5e <sys_open+0xd0>
      fileclose(f);
    80004c06:	854e                	mv	a0,s3
    80004c08:	fffff097          	auipc	ra,0xfffff
    80004c0c:	d72080e7          	jalr	-654(ra) # 8000397a <fileclose>
    iunlockput(ip);
    80004c10:	8526                	mv	a0,s1
    80004c12:	ffffe097          	auipc	ra,0xffffe
    80004c16:	13c080e7          	jalr	316(ra) # 80002d4e <iunlockput>
    end_op();
    80004c1a:	fffff097          	auipc	ra,0xfffff
    80004c1e:	914080e7          	jalr	-1772(ra) # 8000352e <end_op>
    return -1;
    80004c22:	557d                	li	a0,-1
    80004c24:	b7b9                	j	80004b72 <sys_open+0xe4>

0000000080004c26 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c26:	7175                	addi	sp,sp,-144
    80004c28:	e506                	sd	ra,136(sp)
    80004c2a:	e122                	sd	s0,128(sp)
    80004c2c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c2e:	fffff097          	auipc	ra,0xfffff
    80004c32:	880080e7          	jalr	-1920(ra) # 800034ae <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c36:	08000613          	li	a2,128
    80004c3a:	f7040593          	addi	a1,s0,-144
    80004c3e:	4501                	li	a0,0
    80004c40:	ffffd097          	auipc	ra,0xffffd
    80004c44:	372080e7          	jalr	882(ra) # 80001fb2 <argstr>
    80004c48:	02054963          	bltz	a0,80004c7a <sys_mkdir+0x54>
    80004c4c:	4681                	li	a3,0
    80004c4e:	4601                	li	a2,0
    80004c50:	4585                	li	a1,1
    80004c52:	f7040513          	addi	a0,s0,-144
    80004c56:	00000097          	auipc	ra,0x0
    80004c5a:	800080e7          	jalr	-2048(ra) # 80004456 <create>
    80004c5e:	cd11                	beqz	a0,80004c7a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c60:	ffffe097          	auipc	ra,0xffffe
    80004c64:	0ee080e7          	jalr	238(ra) # 80002d4e <iunlockput>
  end_op();
    80004c68:	fffff097          	auipc	ra,0xfffff
    80004c6c:	8c6080e7          	jalr	-1850(ra) # 8000352e <end_op>
  return 0;
    80004c70:	4501                	li	a0,0
}
    80004c72:	60aa                	ld	ra,136(sp)
    80004c74:	640a                	ld	s0,128(sp)
    80004c76:	6149                	addi	sp,sp,144
    80004c78:	8082                	ret
    end_op();
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	8b4080e7          	jalr	-1868(ra) # 8000352e <end_op>
    return -1;
    80004c82:	557d                	li	a0,-1
    80004c84:	b7fd                	j	80004c72 <sys_mkdir+0x4c>

0000000080004c86 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c86:	7135                	addi	sp,sp,-160
    80004c88:	ed06                	sd	ra,152(sp)
    80004c8a:	e922                	sd	s0,144(sp)
    80004c8c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	820080e7          	jalr	-2016(ra) # 800034ae <begin_op>
  argint(1, &major);
    80004c96:	f6c40593          	addi	a1,s0,-148
    80004c9a:	4505                	li	a0,1
    80004c9c:	ffffd097          	auipc	ra,0xffffd
    80004ca0:	2d6080e7          	jalr	726(ra) # 80001f72 <argint>
  argint(2, &minor);
    80004ca4:	f6840593          	addi	a1,s0,-152
    80004ca8:	4509                	li	a0,2
    80004caa:	ffffd097          	auipc	ra,0xffffd
    80004cae:	2c8080e7          	jalr	712(ra) # 80001f72 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cb2:	08000613          	li	a2,128
    80004cb6:	f7040593          	addi	a1,s0,-144
    80004cba:	4501                	li	a0,0
    80004cbc:	ffffd097          	auipc	ra,0xffffd
    80004cc0:	2f6080e7          	jalr	758(ra) # 80001fb2 <argstr>
    80004cc4:	02054b63          	bltz	a0,80004cfa <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004cc8:	f6841683          	lh	a3,-152(s0)
    80004ccc:	f6c41603          	lh	a2,-148(s0)
    80004cd0:	458d                	li	a1,3
    80004cd2:	f7040513          	addi	a0,s0,-144
    80004cd6:	fffff097          	auipc	ra,0xfffff
    80004cda:	780080e7          	jalr	1920(ra) # 80004456 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cde:	cd11                	beqz	a0,80004cfa <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ce0:	ffffe097          	auipc	ra,0xffffe
    80004ce4:	06e080e7          	jalr	110(ra) # 80002d4e <iunlockput>
  end_op();
    80004ce8:	fffff097          	auipc	ra,0xfffff
    80004cec:	846080e7          	jalr	-1978(ra) # 8000352e <end_op>
  return 0;
    80004cf0:	4501                	li	a0,0
}
    80004cf2:	60ea                	ld	ra,152(sp)
    80004cf4:	644a                	ld	s0,144(sp)
    80004cf6:	610d                	addi	sp,sp,160
    80004cf8:	8082                	ret
    end_op();
    80004cfa:	fffff097          	auipc	ra,0xfffff
    80004cfe:	834080e7          	jalr	-1996(ra) # 8000352e <end_op>
    return -1;
    80004d02:	557d                	li	a0,-1
    80004d04:	b7fd                	j	80004cf2 <sys_mknod+0x6c>

0000000080004d06 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d06:	7135                	addi	sp,sp,-160
    80004d08:	ed06                	sd	ra,152(sp)
    80004d0a:	e922                	sd	s0,144(sp)
    80004d0c:	e526                	sd	s1,136(sp)
    80004d0e:	e14a                	sd	s2,128(sp)
    80004d10:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d12:	ffffc097          	auipc	ra,0xffffc
    80004d16:	140080e7          	jalr	320(ra) # 80000e52 <myproc>
    80004d1a:	892a                	mv	s2,a0
  
  begin_op();
    80004d1c:	ffffe097          	auipc	ra,0xffffe
    80004d20:	792080e7          	jalr	1938(ra) # 800034ae <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d24:	08000613          	li	a2,128
    80004d28:	f6040593          	addi	a1,s0,-160
    80004d2c:	4501                	li	a0,0
    80004d2e:	ffffd097          	auipc	ra,0xffffd
    80004d32:	284080e7          	jalr	644(ra) # 80001fb2 <argstr>
    80004d36:	04054b63          	bltz	a0,80004d8c <sys_chdir+0x86>
    80004d3a:	f6040513          	addi	a0,s0,-160
    80004d3e:	ffffe097          	auipc	ra,0xffffe
    80004d42:	554080e7          	jalr	1364(ra) # 80003292 <namei>
    80004d46:	84aa                	mv	s1,a0
    80004d48:	c131                	beqz	a0,80004d8c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d4a:	ffffe097          	auipc	ra,0xffffe
    80004d4e:	da2080e7          	jalr	-606(ra) # 80002aec <ilock>
  if(ip->type != T_DIR){
    80004d52:	04449703          	lh	a4,68(s1)
    80004d56:	4785                	li	a5,1
    80004d58:	04f71063          	bne	a4,a5,80004d98 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d5c:	8526                	mv	a0,s1
    80004d5e:	ffffe097          	auipc	ra,0xffffe
    80004d62:	e50080e7          	jalr	-432(ra) # 80002bae <iunlock>
  iput(p->cwd);
    80004d66:	15093503          	ld	a0,336(s2)
    80004d6a:	ffffe097          	auipc	ra,0xffffe
    80004d6e:	f3c080e7          	jalr	-196(ra) # 80002ca6 <iput>
  end_op();
    80004d72:	ffffe097          	auipc	ra,0xffffe
    80004d76:	7bc080e7          	jalr	1980(ra) # 8000352e <end_op>
  p->cwd = ip;
    80004d7a:	14993823          	sd	s1,336(s2)
  return 0;
    80004d7e:	4501                	li	a0,0
}
    80004d80:	60ea                	ld	ra,152(sp)
    80004d82:	644a                	ld	s0,144(sp)
    80004d84:	64aa                	ld	s1,136(sp)
    80004d86:	690a                	ld	s2,128(sp)
    80004d88:	610d                	addi	sp,sp,160
    80004d8a:	8082                	ret
    end_op();
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	7a2080e7          	jalr	1954(ra) # 8000352e <end_op>
    return -1;
    80004d94:	557d                	li	a0,-1
    80004d96:	b7ed                	j	80004d80 <sys_chdir+0x7a>
    iunlockput(ip);
    80004d98:	8526                	mv	a0,s1
    80004d9a:	ffffe097          	auipc	ra,0xffffe
    80004d9e:	fb4080e7          	jalr	-76(ra) # 80002d4e <iunlockput>
    end_op();
    80004da2:	ffffe097          	auipc	ra,0xffffe
    80004da6:	78c080e7          	jalr	1932(ra) # 8000352e <end_op>
    return -1;
    80004daa:	557d                	li	a0,-1
    80004dac:	bfd1                	j	80004d80 <sys_chdir+0x7a>

0000000080004dae <sys_exec>:

uint64
sys_exec(void)
{
    80004dae:	7145                	addi	sp,sp,-464
    80004db0:	e786                	sd	ra,456(sp)
    80004db2:	e3a2                	sd	s0,448(sp)
    80004db4:	ff26                	sd	s1,440(sp)
    80004db6:	fb4a                	sd	s2,432(sp)
    80004db8:	f74e                	sd	s3,424(sp)
    80004dba:	f352                	sd	s4,416(sp)
    80004dbc:	ef56                	sd	s5,408(sp)
    80004dbe:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004dc0:	e3840593          	addi	a1,s0,-456
    80004dc4:	4505                	li	a0,1
    80004dc6:	ffffd097          	auipc	ra,0xffffd
    80004dca:	1cc080e7          	jalr	460(ra) # 80001f92 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004dce:	08000613          	li	a2,128
    80004dd2:	f4040593          	addi	a1,s0,-192
    80004dd6:	4501                	li	a0,0
    80004dd8:	ffffd097          	auipc	ra,0xffffd
    80004ddc:	1da080e7          	jalr	474(ra) # 80001fb2 <argstr>
    80004de0:	87aa                	mv	a5,a0
    return -1;
    80004de2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004de4:	0c07c263          	bltz	a5,80004ea8 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004de8:	10000613          	li	a2,256
    80004dec:	4581                	li	a1,0
    80004dee:	e4040513          	addi	a0,s0,-448
    80004df2:	ffffb097          	auipc	ra,0xffffb
    80004df6:	386080e7          	jalr	902(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004dfa:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004dfe:	89a6                	mv	s3,s1
    80004e00:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e02:	02000a13          	li	s4,32
    80004e06:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e0a:	00391793          	slli	a5,s2,0x3
    80004e0e:	e3040593          	addi	a1,s0,-464
    80004e12:	e3843503          	ld	a0,-456(s0)
    80004e16:	953e                	add	a0,a0,a5
    80004e18:	ffffd097          	auipc	ra,0xffffd
    80004e1c:	0bc080e7          	jalr	188(ra) # 80001ed4 <fetchaddr>
    80004e20:	02054a63          	bltz	a0,80004e54 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004e24:	e3043783          	ld	a5,-464(s0)
    80004e28:	c3b9                	beqz	a5,80004e6e <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e2a:	ffffb097          	auipc	ra,0xffffb
    80004e2e:	2ee080e7          	jalr	750(ra) # 80000118 <kalloc>
    80004e32:	85aa                	mv	a1,a0
    80004e34:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e38:	cd11                	beqz	a0,80004e54 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e3a:	6605                	lui	a2,0x1
    80004e3c:	e3043503          	ld	a0,-464(s0)
    80004e40:	ffffd097          	auipc	ra,0xffffd
    80004e44:	0e6080e7          	jalr	230(ra) # 80001f26 <fetchstr>
    80004e48:	00054663          	bltz	a0,80004e54 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004e4c:	0905                	addi	s2,s2,1
    80004e4e:	09a1                	addi	s3,s3,8
    80004e50:	fb491be3          	bne	s2,s4,80004e06 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e54:	10048913          	addi	s2,s1,256
    80004e58:	6088                	ld	a0,0(s1)
    80004e5a:	c531                	beqz	a0,80004ea6 <sys_exec+0xf8>
    kfree(argv[i]);
    80004e5c:	ffffb097          	auipc	ra,0xffffb
    80004e60:	1c0080e7          	jalr	448(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e64:	04a1                	addi	s1,s1,8
    80004e66:	ff2499e3          	bne	s1,s2,80004e58 <sys_exec+0xaa>
  return -1;
    80004e6a:	557d                	li	a0,-1
    80004e6c:	a835                	j	80004ea8 <sys_exec+0xfa>
      argv[i] = 0;
    80004e6e:	0a8e                	slli	s5,s5,0x3
    80004e70:	fc040793          	addi	a5,s0,-64
    80004e74:	9abe                	add	s5,s5,a5
    80004e76:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004e7a:	e4040593          	addi	a1,s0,-448
    80004e7e:	f4040513          	addi	a0,s0,-192
    80004e82:	fffff097          	auipc	ra,0xfffff
    80004e86:	172080e7          	jalr	370(ra) # 80003ff4 <exec>
    80004e8a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e8c:	10048993          	addi	s3,s1,256
    80004e90:	6088                	ld	a0,0(s1)
    80004e92:	c901                	beqz	a0,80004ea2 <sys_exec+0xf4>
    kfree(argv[i]);
    80004e94:	ffffb097          	auipc	ra,0xffffb
    80004e98:	188080e7          	jalr	392(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e9c:	04a1                	addi	s1,s1,8
    80004e9e:	ff3499e3          	bne	s1,s3,80004e90 <sys_exec+0xe2>
  return ret;
    80004ea2:	854a                	mv	a0,s2
    80004ea4:	a011                	j	80004ea8 <sys_exec+0xfa>
  return -1;
    80004ea6:	557d                	li	a0,-1
}
    80004ea8:	60be                	ld	ra,456(sp)
    80004eaa:	641e                	ld	s0,448(sp)
    80004eac:	74fa                	ld	s1,440(sp)
    80004eae:	795a                	ld	s2,432(sp)
    80004eb0:	79ba                	ld	s3,424(sp)
    80004eb2:	7a1a                	ld	s4,416(sp)
    80004eb4:	6afa                	ld	s5,408(sp)
    80004eb6:	6179                	addi	sp,sp,464
    80004eb8:	8082                	ret

0000000080004eba <sys_pipe>:

uint64
sys_pipe(void)
{
    80004eba:	7139                	addi	sp,sp,-64
    80004ebc:	fc06                	sd	ra,56(sp)
    80004ebe:	f822                	sd	s0,48(sp)
    80004ec0:	f426                	sd	s1,40(sp)
    80004ec2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004ec4:	ffffc097          	auipc	ra,0xffffc
    80004ec8:	f8e080e7          	jalr	-114(ra) # 80000e52 <myproc>
    80004ecc:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004ece:	fd840593          	addi	a1,s0,-40
    80004ed2:	4501                	li	a0,0
    80004ed4:	ffffd097          	auipc	ra,0xffffd
    80004ed8:	0be080e7          	jalr	190(ra) # 80001f92 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004edc:	fc840593          	addi	a1,s0,-56
    80004ee0:	fd040513          	addi	a0,s0,-48
    80004ee4:	fffff097          	auipc	ra,0xfffff
    80004ee8:	dc6080e7          	jalr	-570(ra) # 80003caa <pipealloc>
    return -1;
    80004eec:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004eee:	0c054463          	bltz	a0,80004fb6 <sys_pipe+0xfc>
  fd0 = -1;
    80004ef2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004ef6:	fd043503          	ld	a0,-48(s0)
    80004efa:	fffff097          	auipc	ra,0xfffff
    80004efe:	51a080e7          	jalr	1306(ra) # 80004414 <fdalloc>
    80004f02:	fca42223          	sw	a0,-60(s0)
    80004f06:	08054b63          	bltz	a0,80004f9c <sys_pipe+0xe2>
    80004f0a:	fc843503          	ld	a0,-56(s0)
    80004f0e:	fffff097          	auipc	ra,0xfffff
    80004f12:	506080e7          	jalr	1286(ra) # 80004414 <fdalloc>
    80004f16:	fca42023          	sw	a0,-64(s0)
    80004f1a:	06054863          	bltz	a0,80004f8a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f1e:	4691                	li	a3,4
    80004f20:	fc440613          	addi	a2,s0,-60
    80004f24:	fd843583          	ld	a1,-40(s0)
    80004f28:	68a8                	ld	a0,80(s1)
    80004f2a:	ffffc097          	auipc	ra,0xffffc
    80004f2e:	be4080e7          	jalr	-1052(ra) # 80000b0e <copyout>
    80004f32:	02054063          	bltz	a0,80004f52 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f36:	4691                	li	a3,4
    80004f38:	fc040613          	addi	a2,s0,-64
    80004f3c:	fd843583          	ld	a1,-40(s0)
    80004f40:	0591                	addi	a1,a1,4
    80004f42:	68a8                	ld	a0,80(s1)
    80004f44:	ffffc097          	auipc	ra,0xffffc
    80004f48:	bca080e7          	jalr	-1078(ra) # 80000b0e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f4c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f4e:	06055463          	bgez	a0,80004fb6 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004f52:	fc442783          	lw	a5,-60(s0)
    80004f56:	07e9                	addi	a5,a5,26
    80004f58:	078e                	slli	a5,a5,0x3
    80004f5a:	97a6                	add	a5,a5,s1
    80004f5c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f60:	fc042503          	lw	a0,-64(s0)
    80004f64:	0569                	addi	a0,a0,26
    80004f66:	050e                	slli	a0,a0,0x3
    80004f68:	94aa                	add	s1,s1,a0
    80004f6a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f6e:	fd043503          	ld	a0,-48(s0)
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	a08080e7          	jalr	-1528(ra) # 8000397a <fileclose>
    fileclose(wf);
    80004f7a:	fc843503          	ld	a0,-56(s0)
    80004f7e:	fffff097          	auipc	ra,0xfffff
    80004f82:	9fc080e7          	jalr	-1540(ra) # 8000397a <fileclose>
    return -1;
    80004f86:	57fd                	li	a5,-1
    80004f88:	a03d                	j	80004fb6 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004f8a:	fc442783          	lw	a5,-60(s0)
    80004f8e:	0007c763          	bltz	a5,80004f9c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004f92:	07e9                	addi	a5,a5,26
    80004f94:	078e                	slli	a5,a5,0x3
    80004f96:	94be                	add	s1,s1,a5
    80004f98:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f9c:	fd043503          	ld	a0,-48(s0)
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	9da080e7          	jalr	-1574(ra) # 8000397a <fileclose>
    fileclose(wf);
    80004fa8:	fc843503          	ld	a0,-56(s0)
    80004fac:	fffff097          	auipc	ra,0xfffff
    80004fb0:	9ce080e7          	jalr	-1586(ra) # 8000397a <fileclose>
    return -1;
    80004fb4:	57fd                	li	a5,-1
}
    80004fb6:	853e                	mv	a0,a5
    80004fb8:	70e2                	ld	ra,56(sp)
    80004fba:	7442                	ld	s0,48(sp)
    80004fbc:	74a2                	ld	s1,40(sp)
    80004fbe:	6121                	addi	sp,sp,64
    80004fc0:	8082                	ret
	...

0000000080004fd0 <kernelvec>:
    80004fd0:	7111                	addi	sp,sp,-256
    80004fd2:	e006                	sd	ra,0(sp)
    80004fd4:	e40a                	sd	sp,8(sp)
    80004fd6:	e80e                	sd	gp,16(sp)
    80004fd8:	ec12                	sd	tp,24(sp)
    80004fda:	f016                	sd	t0,32(sp)
    80004fdc:	f41a                	sd	t1,40(sp)
    80004fde:	f81e                	sd	t2,48(sp)
    80004fe0:	fc22                	sd	s0,56(sp)
    80004fe2:	e0a6                	sd	s1,64(sp)
    80004fe4:	e4aa                	sd	a0,72(sp)
    80004fe6:	e8ae                	sd	a1,80(sp)
    80004fe8:	ecb2                	sd	a2,88(sp)
    80004fea:	f0b6                	sd	a3,96(sp)
    80004fec:	f4ba                	sd	a4,104(sp)
    80004fee:	f8be                	sd	a5,112(sp)
    80004ff0:	fcc2                	sd	a6,120(sp)
    80004ff2:	e146                	sd	a7,128(sp)
    80004ff4:	e54a                	sd	s2,136(sp)
    80004ff6:	e94e                	sd	s3,144(sp)
    80004ff8:	ed52                	sd	s4,152(sp)
    80004ffa:	f156                	sd	s5,160(sp)
    80004ffc:	f55a                	sd	s6,168(sp)
    80004ffe:	f95e                	sd	s7,176(sp)
    80005000:	fd62                	sd	s8,184(sp)
    80005002:	e1e6                	sd	s9,192(sp)
    80005004:	e5ea                	sd	s10,200(sp)
    80005006:	e9ee                	sd	s11,208(sp)
    80005008:	edf2                	sd	t3,216(sp)
    8000500a:	f1f6                	sd	t4,224(sp)
    8000500c:	f5fa                	sd	t5,232(sp)
    8000500e:	f9fe                	sd	t6,240(sp)
    80005010:	d91fc0ef          	jal	ra,80001da0 <kerneltrap>
    80005014:	6082                	ld	ra,0(sp)
    80005016:	6122                	ld	sp,8(sp)
    80005018:	61c2                	ld	gp,16(sp)
    8000501a:	7282                	ld	t0,32(sp)
    8000501c:	7322                	ld	t1,40(sp)
    8000501e:	73c2                	ld	t2,48(sp)
    80005020:	7462                	ld	s0,56(sp)
    80005022:	6486                	ld	s1,64(sp)
    80005024:	6526                	ld	a0,72(sp)
    80005026:	65c6                	ld	a1,80(sp)
    80005028:	6666                	ld	a2,88(sp)
    8000502a:	7686                	ld	a3,96(sp)
    8000502c:	7726                	ld	a4,104(sp)
    8000502e:	77c6                	ld	a5,112(sp)
    80005030:	7866                	ld	a6,120(sp)
    80005032:	688a                	ld	a7,128(sp)
    80005034:	692a                	ld	s2,136(sp)
    80005036:	69ca                	ld	s3,144(sp)
    80005038:	6a6a                	ld	s4,152(sp)
    8000503a:	7a8a                	ld	s5,160(sp)
    8000503c:	7b2a                	ld	s6,168(sp)
    8000503e:	7bca                	ld	s7,176(sp)
    80005040:	7c6a                	ld	s8,184(sp)
    80005042:	6c8e                	ld	s9,192(sp)
    80005044:	6d2e                	ld	s10,200(sp)
    80005046:	6dce                	ld	s11,208(sp)
    80005048:	6e6e                	ld	t3,216(sp)
    8000504a:	7e8e                	ld	t4,224(sp)
    8000504c:	7f2e                	ld	t5,232(sp)
    8000504e:	7fce                	ld	t6,240(sp)
    80005050:	6111                	addi	sp,sp,256
    80005052:	10200073          	sret
    80005056:	00000013          	nop
    8000505a:	00000013          	nop
    8000505e:	0001                	nop

0000000080005060 <timervec>:
    80005060:	34051573          	csrrw	a0,mscratch,a0
    80005064:	e10c                	sd	a1,0(a0)
    80005066:	e510                	sd	a2,8(a0)
    80005068:	e914                	sd	a3,16(a0)
    8000506a:	6d0c                	ld	a1,24(a0)
    8000506c:	7110                	ld	a2,32(a0)
    8000506e:	6194                	ld	a3,0(a1)
    80005070:	96b2                	add	a3,a3,a2
    80005072:	e194                	sd	a3,0(a1)
    80005074:	4589                	li	a1,2
    80005076:	14459073          	csrw	sip,a1
    8000507a:	6914                	ld	a3,16(a0)
    8000507c:	6510                	ld	a2,8(a0)
    8000507e:	610c                	ld	a1,0(a0)
    80005080:	34051573          	csrrw	a0,mscratch,a0
    80005084:	30200073          	mret
	...

000000008000508a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000508a:	1141                	addi	sp,sp,-16
    8000508c:	e422                	sd	s0,8(sp)
    8000508e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005090:	0c0007b7          	lui	a5,0xc000
    80005094:	4705                	li	a4,1
    80005096:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005098:	c3d8                	sw	a4,4(a5)
}
    8000509a:	6422                	ld	s0,8(sp)
    8000509c:	0141                	addi	sp,sp,16
    8000509e:	8082                	ret

00000000800050a0 <plicinithart>:

void
plicinithart(void)
{
    800050a0:	1141                	addi	sp,sp,-16
    800050a2:	e406                	sd	ra,8(sp)
    800050a4:	e022                	sd	s0,0(sp)
    800050a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050a8:	ffffc097          	auipc	ra,0xffffc
    800050ac:	d7e080e7          	jalr	-642(ra) # 80000e26 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050b0:	0085171b          	slliw	a4,a0,0x8
    800050b4:	0c0027b7          	lui	a5,0xc002
    800050b8:	97ba                	add	a5,a5,a4
    800050ba:	40200713          	li	a4,1026
    800050be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050c2:	00d5151b          	slliw	a0,a0,0xd
    800050c6:	0c2017b7          	lui	a5,0xc201
    800050ca:	953e                	add	a0,a0,a5
    800050cc:	00052023          	sw	zero,0(a0)
}
    800050d0:	60a2                	ld	ra,8(sp)
    800050d2:	6402                	ld	s0,0(sp)
    800050d4:	0141                	addi	sp,sp,16
    800050d6:	8082                	ret

00000000800050d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050d8:	1141                	addi	sp,sp,-16
    800050da:	e406                	sd	ra,8(sp)
    800050dc:	e022                	sd	s0,0(sp)
    800050de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050e0:	ffffc097          	auipc	ra,0xffffc
    800050e4:	d46080e7          	jalr	-698(ra) # 80000e26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050e8:	00d5179b          	slliw	a5,a0,0xd
    800050ec:	0c201537          	lui	a0,0xc201
    800050f0:	953e                	add	a0,a0,a5
  return irq;
}
    800050f2:	4148                	lw	a0,4(a0)
    800050f4:	60a2                	ld	ra,8(sp)
    800050f6:	6402                	ld	s0,0(sp)
    800050f8:	0141                	addi	sp,sp,16
    800050fa:	8082                	ret

00000000800050fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800050fc:	1101                	addi	sp,sp,-32
    800050fe:	ec06                	sd	ra,24(sp)
    80005100:	e822                	sd	s0,16(sp)
    80005102:	e426                	sd	s1,8(sp)
    80005104:	1000                	addi	s0,sp,32
    80005106:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005108:	ffffc097          	auipc	ra,0xffffc
    8000510c:	d1e080e7          	jalr	-738(ra) # 80000e26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005110:	00d5151b          	slliw	a0,a0,0xd
    80005114:	0c2017b7          	lui	a5,0xc201
    80005118:	97aa                	add	a5,a5,a0
    8000511a:	c3c4                	sw	s1,4(a5)
}
    8000511c:	60e2                	ld	ra,24(sp)
    8000511e:	6442                	ld	s0,16(sp)
    80005120:	64a2                	ld	s1,8(sp)
    80005122:	6105                	addi	sp,sp,32
    80005124:	8082                	ret

0000000080005126 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005126:	1141                	addi	sp,sp,-16
    80005128:	e406                	sd	ra,8(sp)
    8000512a:	e022                	sd	s0,0(sp)
    8000512c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000512e:	479d                	li	a5,7
    80005130:	04a7cc63          	blt	a5,a0,80005188 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005134:	00015797          	auipc	a5,0x15
    80005138:	a7c78793          	addi	a5,a5,-1412 # 80019bb0 <disk>
    8000513c:	97aa                	add	a5,a5,a0
    8000513e:	0187c783          	lbu	a5,24(a5)
    80005142:	ebb9                	bnez	a5,80005198 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005144:	00451613          	slli	a2,a0,0x4
    80005148:	00015797          	auipc	a5,0x15
    8000514c:	a6878793          	addi	a5,a5,-1432 # 80019bb0 <disk>
    80005150:	6394                	ld	a3,0(a5)
    80005152:	96b2                	add	a3,a3,a2
    80005154:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005158:	6398                	ld	a4,0(a5)
    8000515a:	9732                	add	a4,a4,a2
    8000515c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005160:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005164:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005168:	953e                	add	a0,a0,a5
    8000516a:	4785                	li	a5,1
    8000516c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005170:	00015517          	auipc	a0,0x15
    80005174:	a5850513          	addi	a0,a0,-1448 # 80019bc8 <disk+0x18>
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	3f2080e7          	jalr	1010(ra) # 8000156a <wakeup>
}
    80005180:	60a2                	ld	ra,8(sp)
    80005182:	6402                	ld	s0,0(sp)
    80005184:	0141                	addi	sp,sp,16
    80005186:	8082                	ret
    panic("free_desc 1");
    80005188:	00003517          	auipc	a0,0x3
    8000518c:	53850513          	addi	a0,a0,1336 # 800086c0 <syscalls+0x2f0>
    80005190:	00001097          	auipc	ra,0x1
    80005194:	a0e080e7          	jalr	-1522(ra) # 80005b9e <panic>
    panic("free_desc 2");
    80005198:	00003517          	auipc	a0,0x3
    8000519c:	53850513          	addi	a0,a0,1336 # 800086d0 <syscalls+0x300>
    800051a0:	00001097          	auipc	ra,0x1
    800051a4:	9fe080e7          	jalr	-1538(ra) # 80005b9e <panic>

00000000800051a8 <virtio_disk_init>:
{
    800051a8:	1101                	addi	sp,sp,-32
    800051aa:	ec06                	sd	ra,24(sp)
    800051ac:	e822                	sd	s0,16(sp)
    800051ae:	e426                	sd	s1,8(sp)
    800051b0:	e04a                	sd	s2,0(sp)
    800051b2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800051b4:	00003597          	auipc	a1,0x3
    800051b8:	52c58593          	addi	a1,a1,1324 # 800086e0 <syscalls+0x310>
    800051bc:	00015517          	auipc	a0,0x15
    800051c0:	b1c50513          	addi	a0,a0,-1252 # 80019cd8 <disk+0x128>
    800051c4:	00001097          	auipc	ra,0x1
    800051c8:	e86080e7          	jalr	-378(ra) # 8000604a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051cc:	100017b7          	lui	a5,0x10001
    800051d0:	4398                	lw	a4,0(a5)
    800051d2:	2701                	sext.w	a4,a4
    800051d4:	747277b7          	lui	a5,0x74727
    800051d8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051dc:	14f71c63          	bne	a4,a5,80005334 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051e0:	100017b7          	lui	a5,0x10001
    800051e4:	43dc                	lw	a5,4(a5)
    800051e6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051e8:	4709                	li	a4,2
    800051ea:	14e79563          	bne	a5,a4,80005334 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051ee:	100017b7          	lui	a5,0x10001
    800051f2:	479c                	lw	a5,8(a5)
    800051f4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051f6:	12e79f63          	bne	a5,a4,80005334 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051fa:	100017b7          	lui	a5,0x10001
    800051fe:	47d8                	lw	a4,12(a5)
    80005200:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005202:	554d47b7          	lui	a5,0x554d4
    80005206:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000520a:	12f71563          	bne	a4,a5,80005334 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000520e:	100017b7          	lui	a5,0x10001
    80005212:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005216:	4705                	li	a4,1
    80005218:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000521a:	470d                	li	a4,3
    8000521c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000521e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005220:	c7ffe737          	lui	a4,0xc7ffe
    80005224:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc82f>
    80005228:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000522a:	2701                	sext.w	a4,a4
    8000522c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000522e:	472d                	li	a4,11
    80005230:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005232:	5bbc                	lw	a5,112(a5)
    80005234:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005238:	8ba1                	andi	a5,a5,8
    8000523a:	10078563          	beqz	a5,80005344 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000523e:	100017b7          	lui	a5,0x10001
    80005242:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005246:	43fc                	lw	a5,68(a5)
    80005248:	2781                	sext.w	a5,a5
    8000524a:	10079563          	bnez	a5,80005354 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000524e:	100017b7          	lui	a5,0x10001
    80005252:	5bdc                	lw	a5,52(a5)
    80005254:	2781                	sext.w	a5,a5
  if(max == 0)
    80005256:	10078763          	beqz	a5,80005364 <virtio_disk_init+0x1bc>
  if(max < NUM)
    8000525a:	471d                	li	a4,7
    8000525c:	10f77c63          	bgeu	a4,a5,80005374 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80005260:	ffffb097          	auipc	ra,0xffffb
    80005264:	eb8080e7          	jalr	-328(ra) # 80000118 <kalloc>
    80005268:	00015497          	auipc	s1,0x15
    8000526c:	94848493          	addi	s1,s1,-1720 # 80019bb0 <disk>
    80005270:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005272:	ffffb097          	auipc	ra,0xffffb
    80005276:	ea6080e7          	jalr	-346(ra) # 80000118 <kalloc>
    8000527a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000527c:	ffffb097          	auipc	ra,0xffffb
    80005280:	e9c080e7          	jalr	-356(ra) # 80000118 <kalloc>
    80005284:	87aa                	mv	a5,a0
    80005286:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005288:	6088                	ld	a0,0(s1)
    8000528a:	cd6d                	beqz	a0,80005384 <virtio_disk_init+0x1dc>
    8000528c:	00015717          	auipc	a4,0x15
    80005290:	92c73703          	ld	a4,-1748(a4) # 80019bb8 <disk+0x8>
    80005294:	cb65                	beqz	a4,80005384 <virtio_disk_init+0x1dc>
    80005296:	c7fd                	beqz	a5,80005384 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80005298:	6605                	lui	a2,0x1
    8000529a:	4581                	li	a1,0
    8000529c:	ffffb097          	auipc	ra,0xffffb
    800052a0:	edc080e7          	jalr	-292(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    800052a4:	00015497          	auipc	s1,0x15
    800052a8:	90c48493          	addi	s1,s1,-1780 # 80019bb0 <disk>
    800052ac:	6605                	lui	a2,0x1
    800052ae:	4581                	li	a1,0
    800052b0:	6488                	ld	a0,8(s1)
    800052b2:	ffffb097          	auipc	ra,0xffffb
    800052b6:	ec6080e7          	jalr	-314(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    800052ba:	6605                	lui	a2,0x1
    800052bc:	4581                	li	a1,0
    800052be:	6888                	ld	a0,16(s1)
    800052c0:	ffffb097          	auipc	ra,0xffffb
    800052c4:	eb8080e7          	jalr	-328(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052c8:	100017b7          	lui	a5,0x10001
    800052cc:	4721                	li	a4,8
    800052ce:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800052d0:	4098                	lw	a4,0(s1)
    800052d2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800052d6:	40d8                	lw	a4,4(s1)
    800052d8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800052dc:	6498                	ld	a4,8(s1)
    800052de:	0007069b          	sext.w	a3,a4
    800052e2:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800052e6:	9701                	srai	a4,a4,0x20
    800052e8:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800052ec:	6898                	ld	a4,16(s1)
    800052ee:	0007069b          	sext.w	a3,a4
    800052f2:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800052f6:	9701                	srai	a4,a4,0x20
    800052f8:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800052fc:	4705                	li	a4,1
    800052fe:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005300:	00e48c23          	sb	a4,24(s1)
    80005304:	00e48ca3          	sb	a4,25(s1)
    80005308:	00e48d23          	sb	a4,26(s1)
    8000530c:	00e48da3          	sb	a4,27(s1)
    80005310:	00e48e23          	sb	a4,28(s1)
    80005314:	00e48ea3          	sb	a4,29(s1)
    80005318:	00e48f23          	sb	a4,30(s1)
    8000531c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005320:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005324:	0727a823          	sw	s2,112(a5)
}
    80005328:	60e2                	ld	ra,24(sp)
    8000532a:	6442                	ld	s0,16(sp)
    8000532c:	64a2                	ld	s1,8(sp)
    8000532e:	6902                	ld	s2,0(sp)
    80005330:	6105                	addi	sp,sp,32
    80005332:	8082                	ret
    panic("could not find virtio disk");
    80005334:	00003517          	auipc	a0,0x3
    80005338:	3bc50513          	addi	a0,a0,956 # 800086f0 <syscalls+0x320>
    8000533c:	00001097          	auipc	ra,0x1
    80005340:	862080e7          	jalr	-1950(ra) # 80005b9e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005344:	00003517          	auipc	a0,0x3
    80005348:	3cc50513          	addi	a0,a0,972 # 80008710 <syscalls+0x340>
    8000534c:	00001097          	auipc	ra,0x1
    80005350:	852080e7          	jalr	-1966(ra) # 80005b9e <panic>
    panic("virtio disk should not be ready");
    80005354:	00003517          	auipc	a0,0x3
    80005358:	3dc50513          	addi	a0,a0,988 # 80008730 <syscalls+0x360>
    8000535c:	00001097          	auipc	ra,0x1
    80005360:	842080e7          	jalr	-1982(ra) # 80005b9e <panic>
    panic("virtio disk has no queue 0");
    80005364:	00003517          	auipc	a0,0x3
    80005368:	3ec50513          	addi	a0,a0,1004 # 80008750 <syscalls+0x380>
    8000536c:	00001097          	auipc	ra,0x1
    80005370:	832080e7          	jalr	-1998(ra) # 80005b9e <panic>
    panic("virtio disk max queue too short");
    80005374:	00003517          	auipc	a0,0x3
    80005378:	3fc50513          	addi	a0,a0,1020 # 80008770 <syscalls+0x3a0>
    8000537c:	00001097          	auipc	ra,0x1
    80005380:	822080e7          	jalr	-2014(ra) # 80005b9e <panic>
    panic("virtio disk kalloc");
    80005384:	00003517          	auipc	a0,0x3
    80005388:	40c50513          	addi	a0,a0,1036 # 80008790 <syscalls+0x3c0>
    8000538c:	00001097          	auipc	ra,0x1
    80005390:	812080e7          	jalr	-2030(ra) # 80005b9e <panic>

0000000080005394 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005394:	7119                	addi	sp,sp,-128
    80005396:	fc86                	sd	ra,120(sp)
    80005398:	f8a2                	sd	s0,112(sp)
    8000539a:	f4a6                	sd	s1,104(sp)
    8000539c:	f0ca                	sd	s2,96(sp)
    8000539e:	ecce                	sd	s3,88(sp)
    800053a0:	e8d2                	sd	s4,80(sp)
    800053a2:	e4d6                	sd	s5,72(sp)
    800053a4:	e0da                	sd	s6,64(sp)
    800053a6:	fc5e                	sd	s7,56(sp)
    800053a8:	f862                	sd	s8,48(sp)
    800053aa:	f466                	sd	s9,40(sp)
    800053ac:	f06a                	sd	s10,32(sp)
    800053ae:	ec6e                	sd	s11,24(sp)
    800053b0:	0100                	addi	s0,sp,128
    800053b2:	8aaa                	mv	s5,a0
    800053b4:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053b6:	00c52d03          	lw	s10,12(a0)
    800053ba:	001d1d1b          	slliw	s10,s10,0x1
    800053be:	1d02                	slli	s10,s10,0x20
    800053c0:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800053c4:	00015517          	auipc	a0,0x15
    800053c8:	91450513          	addi	a0,a0,-1772 # 80019cd8 <disk+0x128>
    800053cc:	00001097          	auipc	ra,0x1
    800053d0:	d0e080e7          	jalr	-754(ra) # 800060da <acquire>
  for(int i = 0; i < 3; i++){
    800053d4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053d6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053d8:	00014b97          	auipc	s7,0x14
    800053dc:	7d8b8b93          	addi	s7,s7,2008 # 80019bb0 <disk>
  for(int i = 0; i < 3; i++){
    800053e0:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053e2:	00015c97          	auipc	s9,0x15
    800053e6:	8f6c8c93          	addi	s9,s9,-1802 # 80019cd8 <disk+0x128>
    800053ea:	a08d                	j	8000544c <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800053ec:	00fb8733          	add	a4,s7,a5
    800053f0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053f4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800053f6:	0207c563          	bltz	a5,80005420 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800053fa:	2905                	addiw	s2,s2,1
    800053fc:	0611                	addi	a2,a2,4
    800053fe:	05690c63          	beq	s2,s6,80005456 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005402:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005404:	00014717          	auipc	a4,0x14
    80005408:	7ac70713          	addi	a4,a4,1964 # 80019bb0 <disk>
    8000540c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000540e:	01874683          	lbu	a3,24(a4)
    80005412:	fee9                	bnez	a3,800053ec <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005414:	2785                	addiw	a5,a5,1
    80005416:	0705                	addi	a4,a4,1
    80005418:	fe979be3          	bne	a5,s1,8000540e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000541c:	57fd                	li	a5,-1
    8000541e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005420:	01205d63          	blez	s2,8000543a <virtio_disk_rw+0xa6>
    80005424:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005426:	000a2503          	lw	a0,0(s4)
    8000542a:	00000097          	auipc	ra,0x0
    8000542e:	cfc080e7          	jalr	-772(ra) # 80005126 <free_desc>
      for(int j = 0; j < i; j++)
    80005432:	2d85                	addiw	s11,s11,1
    80005434:	0a11                	addi	s4,s4,4
    80005436:	ffb918e3          	bne	s2,s11,80005426 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000543a:	85e6                	mv	a1,s9
    8000543c:	00014517          	auipc	a0,0x14
    80005440:	78c50513          	addi	a0,a0,1932 # 80019bc8 <disk+0x18>
    80005444:	ffffc097          	auipc	ra,0xffffc
    80005448:	0c2080e7          	jalr	194(ra) # 80001506 <sleep>
  for(int i = 0; i < 3; i++){
    8000544c:	f8040a13          	addi	s4,s0,-128
{
    80005450:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005452:	894e                	mv	s2,s3
    80005454:	b77d                	j	80005402 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005456:	f8042583          	lw	a1,-128(s0)
    8000545a:	00a58793          	addi	a5,a1,10
    8000545e:	0792                	slli	a5,a5,0x4

  if(write)
    80005460:	00014617          	auipc	a2,0x14
    80005464:	75060613          	addi	a2,a2,1872 # 80019bb0 <disk>
    80005468:	00f60733          	add	a4,a2,a5
    8000546c:	018036b3          	snez	a3,s8
    80005470:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005472:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005476:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000547a:	f6078693          	addi	a3,a5,-160
    8000547e:	6218                	ld	a4,0(a2)
    80005480:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005482:	00878513          	addi	a0,a5,8
    80005486:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005488:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000548a:	6208                	ld	a0,0(a2)
    8000548c:	96aa                	add	a3,a3,a0
    8000548e:	4741                	li	a4,16
    80005490:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005492:	4705                	li	a4,1
    80005494:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005498:	f8442703          	lw	a4,-124(s0)
    8000549c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054a0:	0712                	slli	a4,a4,0x4
    800054a2:	953a                	add	a0,a0,a4
    800054a4:	058a8693          	addi	a3,s5,88
    800054a8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800054aa:	6208                	ld	a0,0(a2)
    800054ac:	972a                	add	a4,a4,a0
    800054ae:	40000693          	li	a3,1024
    800054b2:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800054b4:	001c3c13          	seqz	s8,s8
    800054b8:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054ba:	001c6c13          	ori	s8,s8,1
    800054be:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800054c2:	f8842603          	lw	a2,-120(s0)
    800054c6:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054ca:	00014697          	auipc	a3,0x14
    800054ce:	6e668693          	addi	a3,a3,1766 # 80019bb0 <disk>
    800054d2:	00258713          	addi	a4,a1,2
    800054d6:	0712                	slli	a4,a4,0x4
    800054d8:	9736                	add	a4,a4,a3
    800054da:	587d                	li	a6,-1
    800054dc:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054e0:	0612                	slli	a2,a2,0x4
    800054e2:	9532                	add	a0,a0,a2
    800054e4:	f9078793          	addi	a5,a5,-112
    800054e8:	97b6                	add	a5,a5,a3
    800054ea:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    800054ec:	629c                	ld	a5,0(a3)
    800054ee:	97b2                	add	a5,a5,a2
    800054f0:	4605                	li	a2,1
    800054f2:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054f4:	4509                	li	a0,2
    800054f6:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    800054fa:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054fe:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005502:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005506:	6698                	ld	a4,8(a3)
    80005508:	00275783          	lhu	a5,2(a4)
    8000550c:	8b9d                	andi	a5,a5,7
    8000550e:	0786                	slli	a5,a5,0x1
    80005510:	97ba                	add	a5,a5,a4
    80005512:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005516:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000551a:	6698                	ld	a4,8(a3)
    8000551c:	00275783          	lhu	a5,2(a4)
    80005520:	2785                	addiw	a5,a5,1
    80005522:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005526:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000552a:	100017b7          	lui	a5,0x10001
    8000552e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005532:	004aa783          	lw	a5,4(s5)
    80005536:	02c79163          	bne	a5,a2,80005558 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000553a:	00014917          	auipc	s2,0x14
    8000553e:	79e90913          	addi	s2,s2,1950 # 80019cd8 <disk+0x128>
  while(b->disk == 1) {
    80005542:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005544:	85ca                	mv	a1,s2
    80005546:	8556                	mv	a0,s5
    80005548:	ffffc097          	auipc	ra,0xffffc
    8000554c:	fbe080e7          	jalr	-66(ra) # 80001506 <sleep>
  while(b->disk == 1) {
    80005550:	004aa783          	lw	a5,4(s5)
    80005554:	fe9788e3          	beq	a5,s1,80005544 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005558:	f8042903          	lw	s2,-128(s0)
    8000555c:	00290793          	addi	a5,s2,2
    80005560:	00479713          	slli	a4,a5,0x4
    80005564:	00014797          	auipc	a5,0x14
    80005568:	64c78793          	addi	a5,a5,1612 # 80019bb0 <disk>
    8000556c:	97ba                	add	a5,a5,a4
    8000556e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005572:	00014997          	auipc	s3,0x14
    80005576:	63e98993          	addi	s3,s3,1598 # 80019bb0 <disk>
    8000557a:	00491713          	slli	a4,s2,0x4
    8000557e:	0009b783          	ld	a5,0(s3)
    80005582:	97ba                	add	a5,a5,a4
    80005584:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005588:	854a                	mv	a0,s2
    8000558a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000558e:	00000097          	auipc	ra,0x0
    80005592:	b98080e7          	jalr	-1128(ra) # 80005126 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005596:	8885                	andi	s1,s1,1
    80005598:	f0ed                	bnez	s1,8000557a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000559a:	00014517          	auipc	a0,0x14
    8000559e:	73e50513          	addi	a0,a0,1854 # 80019cd8 <disk+0x128>
    800055a2:	00001097          	auipc	ra,0x1
    800055a6:	bec080e7          	jalr	-1044(ra) # 8000618e <release>
}
    800055aa:	70e6                	ld	ra,120(sp)
    800055ac:	7446                	ld	s0,112(sp)
    800055ae:	74a6                	ld	s1,104(sp)
    800055b0:	7906                	ld	s2,96(sp)
    800055b2:	69e6                	ld	s3,88(sp)
    800055b4:	6a46                	ld	s4,80(sp)
    800055b6:	6aa6                	ld	s5,72(sp)
    800055b8:	6b06                	ld	s6,64(sp)
    800055ba:	7be2                	ld	s7,56(sp)
    800055bc:	7c42                	ld	s8,48(sp)
    800055be:	7ca2                	ld	s9,40(sp)
    800055c0:	7d02                	ld	s10,32(sp)
    800055c2:	6de2                	ld	s11,24(sp)
    800055c4:	6109                	addi	sp,sp,128
    800055c6:	8082                	ret

00000000800055c8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800055c8:	1101                	addi	sp,sp,-32
    800055ca:	ec06                	sd	ra,24(sp)
    800055cc:	e822                	sd	s0,16(sp)
    800055ce:	e426                	sd	s1,8(sp)
    800055d0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800055d2:	00014497          	auipc	s1,0x14
    800055d6:	5de48493          	addi	s1,s1,1502 # 80019bb0 <disk>
    800055da:	00014517          	auipc	a0,0x14
    800055de:	6fe50513          	addi	a0,a0,1790 # 80019cd8 <disk+0x128>
    800055e2:	00001097          	auipc	ra,0x1
    800055e6:	af8080e7          	jalr	-1288(ra) # 800060da <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800055ea:	10001737          	lui	a4,0x10001
    800055ee:	533c                	lw	a5,96(a4)
    800055f0:	8b8d                	andi	a5,a5,3
    800055f2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800055f4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800055f8:	689c                	ld	a5,16(s1)
    800055fa:	0204d703          	lhu	a4,32(s1)
    800055fe:	0027d783          	lhu	a5,2(a5)
    80005602:	04f70863          	beq	a4,a5,80005652 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005606:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000560a:	6898                	ld	a4,16(s1)
    8000560c:	0204d783          	lhu	a5,32(s1)
    80005610:	8b9d                	andi	a5,a5,7
    80005612:	078e                	slli	a5,a5,0x3
    80005614:	97ba                	add	a5,a5,a4
    80005616:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005618:	00278713          	addi	a4,a5,2
    8000561c:	0712                	slli	a4,a4,0x4
    8000561e:	9726                	add	a4,a4,s1
    80005620:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005624:	e721                	bnez	a4,8000566c <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005626:	0789                	addi	a5,a5,2
    80005628:	0792                	slli	a5,a5,0x4
    8000562a:	97a6                	add	a5,a5,s1
    8000562c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000562e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005632:	ffffc097          	auipc	ra,0xffffc
    80005636:	f38080e7          	jalr	-200(ra) # 8000156a <wakeup>

    disk.used_idx += 1;
    8000563a:	0204d783          	lhu	a5,32(s1)
    8000563e:	2785                	addiw	a5,a5,1
    80005640:	17c2                	slli	a5,a5,0x30
    80005642:	93c1                	srli	a5,a5,0x30
    80005644:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005648:	6898                	ld	a4,16(s1)
    8000564a:	00275703          	lhu	a4,2(a4)
    8000564e:	faf71ce3          	bne	a4,a5,80005606 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005652:	00014517          	auipc	a0,0x14
    80005656:	68650513          	addi	a0,a0,1670 # 80019cd8 <disk+0x128>
    8000565a:	00001097          	auipc	ra,0x1
    8000565e:	b34080e7          	jalr	-1228(ra) # 8000618e <release>
}
    80005662:	60e2                	ld	ra,24(sp)
    80005664:	6442                	ld	s0,16(sp)
    80005666:	64a2                	ld	s1,8(sp)
    80005668:	6105                	addi	sp,sp,32
    8000566a:	8082                	ret
      panic("virtio_disk_intr status");
    8000566c:	00003517          	auipc	a0,0x3
    80005670:	13c50513          	addi	a0,a0,316 # 800087a8 <syscalls+0x3d8>
    80005674:	00000097          	auipc	ra,0x0
    80005678:	52a080e7          	jalr	1322(ra) # 80005b9e <panic>

000000008000567c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000567c:	1141                	addi	sp,sp,-16
    8000567e:	e422                	sd	s0,8(sp)
    80005680:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005682:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005686:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000568a:	0037979b          	slliw	a5,a5,0x3
    8000568e:	02004737          	lui	a4,0x2004
    80005692:	97ba                	add	a5,a5,a4
    80005694:	0200c737          	lui	a4,0x200c
    80005698:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000569c:	000f4637          	lui	a2,0xf4
    800056a0:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800056a4:	95b2                	add	a1,a1,a2
    800056a6:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800056a8:	00269713          	slli	a4,a3,0x2
    800056ac:	9736                	add	a4,a4,a3
    800056ae:	00371693          	slli	a3,a4,0x3
    800056b2:	00014717          	auipc	a4,0x14
    800056b6:	63e70713          	addi	a4,a4,1598 # 80019cf0 <timer_scratch>
    800056ba:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800056bc:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800056be:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800056c0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800056c4:	00000797          	auipc	a5,0x0
    800056c8:	99c78793          	addi	a5,a5,-1636 # 80005060 <timervec>
    800056cc:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056d0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800056d4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056d8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800056dc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800056e0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800056e4:	30479073          	csrw	mie,a5
}
    800056e8:	6422                	ld	s0,8(sp)
    800056ea:	0141                	addi	sp,sp,16
    800056ec:	8082                	ret

00000000800056ee <start>:
{
    800056ee:	1141                	addi	sp,sp,-16
    800056f0:	e406                	sd	ra,8(sp)
    800056f2:	e022                	sd	s0,0(sp)
    800056f4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056f6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800056fa:	7779                	lui	a4,0xffffe
    800056fc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc8cf>
    80005700:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005702:	6705                	lui	a4,0x1
    80005704:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005708:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000570a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000570e:	ffffb797          	auipc	a5,0xffffb
    80005712:	c1078793          	addi	a5,a5,-1008 # 8000031e <main>
    80005716:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000571a:	4781                	li	a5,0
    8000571c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005720:	67c1                	lui	a5,0x10
    80005722:	17fd                	addi	a5,a5,-1
    80005724:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005728:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000572c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005730:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005734:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005738:	57fd                	li	a5,-1
    8000573a:	83a9                	srli	a5,a5,0xa
    8000573c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005740:	47bd                	li	a5,15
    80005742:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005746:	00000097          	auipc	ra,0x0
    8000574a:	f36080e7          	jalr	-202(ra) # 8000567c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000574e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005752:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005754:	823e                	mv	tp,a5
  asm volatile("mret");
    80005756:	30200073          	mret
}
    8000575a:	60a2                	ld	ra,8(sp)
    8000575c:	6402                	ld	s0,0(sp)
    8000575e:	0141                	addi	sp,sp,16
    80005760:	8082                	ret

0000000080005762 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005762:	715d                	addi	sp,sp,-80
    80005764:	e486                	sd	ra,72(sp)
    80005766:	e0a2                	sd	s0,64(sp)
    80005768:	fc26                	sd	s1,56(sp)
    8000576a:	f84a                	sd	s2,48(sp)
    8000576c:	f44e                	sd	s3,40(sp)
    8000576e:	f052                	sd	s4,32(sp)
    80005770:	ec56                	sd	s5,24(sp)
    80005772:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005774:	04c05663          	blez	a2,800057c0 <consolewrite+0x5e>
    80005778:	8a2a                	mv	s4,a0
    8000577a:	84ae                	mv	s1,a1
    8000577c:	89b2                	mv	s3,a2
    8000577e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005780:	5afd                	li	s5,-1
    80005782:	4685                	li	a3,1
    80005784:	8626                	mv	a2,s1
    80005786:	85d2                	mv	a1,s4
    80005788:	fbf40513          	addi	a0,s0,-65
    8000578c:	ffffc097          	auipc	ra,0xffffc
    80005790:	1d8080e7          	jalr	472(ra) # 80001964 <either_copyin>
    80005794:	01550c63          	beq	a0,s5,800057ac <consolewrite+0x4a>
      break;
    uartputc(c);
    80005798:	fbf44503          	lbu	a0,-65(s0)
    8000579c:	00000097          	auipc	ra,0x0
    800057a0:	780080e7          	jalr	1920(ra) # 80005f1c <uartputc>
  for(i = 0; i < n; i++){
    800057a4:	2905                	addiw	s2,s2,1
    800057a6:	0485                	addi	s1,s1,1
    800057a8:	fd299de3          	bne	s3,s2,80005782 <consolewrite+0x20>
  }

  return i;
}
    800057ac:	854a                	mv	a0,s2
    800057ae:	60a6                	ld	ra,72(sp)
    800057b0:	6406                	ld	s0,64(sp)
    800057b2:	74e2                	ld	s1,56(sp)
    800057b4:	7942                	ld	s2,48(sp)
    800057b6:	79a2                	ld	s3,40(sp)
    800057b8:	7a02                	ld	s4,32(sp)
    800057ba:	6ae2                	ld	s5,24(sp)
    800057bc:	6161                	addi	sp,sp,80
    800057be:	8082                	ret
  for(i = 0; i < n; i++){
    800057c0:	4901                	li	s2,0
    800057c2:	b7ed                	j	800057ac <consolewrite+0x4a>

00000000800057c4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800057c4:	7159                	addi	sp,sp,-112
    800057c6:	f486                	sd	ra,104(sp)
    800057c8:	f0a2                	sd	s0,96(sp)
    800057ca:	eca6                	sd	s1,88(sp)
    800057cc:	e8ca                	sd	s2,80(sp)
    800057ce:	e4ce                	sd	s3,72(sp)
    800057d0:	e0d2                	sd	s4,64(sp)
    800057d2:	fc56                	sd	s5,56(sp)
    800057d4:	f85a                	sd	s6,48(sp)
    800057d6:	f45e                	sd	s7,40(sp)
    800057d8:	f062                	sd	s8,32(sp)
    800057da:	ec66                	sd	s9,24(sp)
    800057dc:	e86a                	sd	s10,16(sp)
    800057de:	1880                	addi	s0,sp,112
    800057e0:	8aaa                	mv	s5,a0
    800057e2:	8a2e                	mv	s4,a1
    800057e4:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800057e6:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800057ea:	0001c517          	auipc	a0,0x1c
    800057ee:	64650513          	addi	a0,a0,1606 # 80021e30 <cons>
    800057f2:	00001097          	auipc	ra,0x1
    800057f6:	8e8080e7          	jalr	-1816(ra) # 800060da <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800057fa:	0001c497          	auipc	s1,0x1c
    800057fe:	63648493          	addi	s1,s1,1590 # 80021e30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005802:	0001c917          	auipc	s2,0x1c
    80005806:	6c690913          	addi	s2,s2,1734 # 80021ec8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000580a:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000580c:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000580e:	4ca9                	li	s9,10
  while(n > 0){
    80005810:	07305b63          	blez	s3,80005886 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005814:	0984a783          	lw	a5,152(s1)
    80005818:	09c4a703          	lw	a4,156(s1)
    8000581c:	02f71763          	bne	a4,a5,8000584a <consoleread+0x86>
      if(killed(myproc())){
    80005820:	ffffb097          	auipc	ra,0xffffb
    80005824:	632080e7          	jalr	1586(ra) # 80000e52 <myproc>
    80005828:	ffffc097          	auipc	ra,0xffffc
    8000582c:	f86080e7          	jalr	-122(ra) # 800017ae <killed>
    80005830:	e535                	bnez	a0,8000589c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005832:	85a6                	mv	a1,s1
    80005834:	854a                	mv	a0,s2
    80005836:	ffffc097          	auipc	ra,0xffffc
    8000583a:	cd0080e7          	jalr	-816(ra) # 80001506 <sleep>
    while(cons.r == cons.w){
    8000583e:	0984a783          	lw	a5,152(s1)
    80005842:	09c4a703          	lw	a4,156(s1)
    80005846:	fcf70de3          	beq	a4,a5,80005820 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000584a:	0017871b          	addiw	a4,a5,1
    8000584e:	08e4ac23          	sw	a4,152(s1)
    80005852:	07f7f713          	andi	a4,a5,127
    80005856:	9726                	add	a4,a4,s1
    80005858:	01874703          	lbu	a4,24(a4)
    8000585c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005860:	077d0563          	beq	s10,s7,800058ca <consoleread+0x106>
    cbuf = c;
    80005864:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005868:	4685                	li	a3,1
    8000586a:	f9f40613          	addi	a2,s0,-97
    8000586e:	85d2                	mv	a1,s4
    80005870:	8556                	mv	a0,s5
    80005872:	ffffc097          	auipc	ra,0xffffc
    80005876:	09c080e7          	jalr	156(ra) # 8000190e <either_copyout>
    8000587a:	01850663          	beq	a0,s8,80005886 <consoleread+0xc2>
    dst++;
    8000587e:	0a05                	addi	s4,s4,1
    --n;
    80005880:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005882:	f99d17e3          	bne	s10,s9,80005810 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005886:	0001c517          	auipc	a0,0x1c
    8000588a:	5aa50513          	addi	a0,a0,1450 # 80021e30 <cons>
    8000588e:	00001097          	auipc	ra,0x1
    80005892:	900080e7          	jalr	-1792(ra) # 8000618e <release>

  return target - n;
    80005896:	413b053b          	subw	a0,s6,s3
    8000589a:	a811                	j	800058ae <consoleread+0xea>
        release(&cons.lock);
    8000589c:	0001c517          	auipc	a0,0x1c
    800058a0:	59450513          	addi	a0,a0,1428 # 80021e30 <cons>
    800058a4:	00001097          	auipc	ra,0x1
    800058a8:	8ea080e7          	jalr	-1814(ra) # 8000618e <release>
        return -1;
    800058ac:	557d                	li	a0,-1
}
    800058ae:	70a6                	ld	ra,104(sp)
    800058b0:	7406                	ld	s0,96(sp)
    800058b2:	64e6                	ld	s1,88(sp)
    800058b4:	6946                	ld	s2,80(sp)
    800058b6:	69a6                	ld	s3,72(sp)
    800058b8:	6a06                	ld	s4,64(sp)
    800058ba:	7ae2                	ld	s5,56(sp)
    800058bc:	7b42                	ld	s6,48(sp)
    800058be:	7ba2                	ld	s7,40(sp)
    800058c0:	7c02                	ld	s8,32(sp)
    800058c2:	6ce2                	ld	s9,24(sp)
    800058c4:	6d42                	ld	s10,16(sp)
    800058c6:	6165                	addi	sp,sp,112
    800058c8:	8082                	ret
      if(n < target){
    800058ca:	0009871b          	sext.w	a4,s3
    800058ce:	fb677ce3          	bgeu	a4,s6,80005886 <consoleread+0xc2>
        cons.r--;
    800058d2:	0001c717          	auipc	a4,0x1c
    800058d6:	5ef72b23          	sw	a5,1526(a4) # 80021ec8 <cons+0x98>
    800058da:	b775                	j	80005886 <consoleread+0xc2>

00000000800058dc <consputc>:
{
    800058dc:	1141                	addi	sp,sp,-16
    800058de:	e406                	sd	ra,8(sp)
    800058e0:	e022                	sd	s0,0(sp)
    800058e2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800058e4:	10000793          	li	a5,256
    800058e8:	00f50a63          	beq	a0,a5,800058fc <consputc+0x20>
    uartputc_sync(c);
    800058ec:	00000097          	auipc	ra,0x0
    800058f0:	55e080e7          	jalr	1374(ra) # 80005e4a <uartputc_sync>
}
    800058f4:	60a2                	ld	ra,8(sp)
    800058f6:	6402                	ld	s0,0(sp)
    800058f8:	0141                	addi	sp,sp,16
    800058fa:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800058fc:	4521                	li	a0,8
    800058fe:	00000097          	auipc	ra,0x0
    80005902:	54c080e7          	jalr	1356(ra) # 80005e4a <uartputc_sync>
    80005906:	02000513          	li	a0,32
    8000590a:	00000097          	auipc	ra,0x0
    8000590e:	540080e7          	jalr	1344(ra) # 80005e4a <uartputc_sync>
    80005912:	4521                	li	a0,8
    80005914:	00000097          	auipc	ra,0x0
    80005918:	536080e7          	jalr	1334(ra) # 80005e4a <uartputc_sync>
    8000591c:	bfe1                	j	800058f4 <consputc+0x18>

000000008000591e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000591e:	1101                	addi	sp,sp,-32
    80005920:	ec06                	sd	ra,24(sp)
    80005922:	e822                	sd	s0,16(sp)
    80005924:	e426                	sd	s1,8(sp)
    80005926:	e04a                	sd	s2,0(sp)
    80005928:	1000                	addi	s0,sp,32
    8000592a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000592c:	0001c517          	auipc	a0,0x1c
    80005930:	50450513          	addi	a0,a0,1284 # 80021e30 <cons>
    80005934:	00000097          	auipc	ra,0x0
    80005938:	7a6080e7          	jalr	1958(ra) # 800060da <acquire>

  switch(c){
    8000593c:	47d5                	li	a5,21
    8000593e:	0af48663          	beq	s1,a5,800059ea <consoleintr+0xcc>
    80005942:	0297ca63          	blt	a5,s1,80005976 <consoleintr+0x58>
    80005946:	47a1                	li	a5,8
    80005948:	0ef48763          	beq	s1,a5,80005a36 <consoleintr+0x118>
    8000594c:	47c1                	li	a5,16
    8000594e:	10f49a63          	bne	s1,a5,80005a62 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005952:	ffffc097          	auipc	ra,0xffffc
    80005956:	068080e7          	jalr	104(ra) # 800019ba <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000595a:	0001c517          	auipc	a0,0x1c
    8000595e:	4d650513          	addi	a0,a0,1238 # 80021e30 <cons>
    80005962:	00001097          	auipc	ra,0x1
    80005966:	82c080e7          	jalr	-2004(ra) # 8000618e <release>
}
    8000596a:	60e2                	ld	ra,24(sp)
    8000596c:	6442                	ld	s0,16(sp)
    8000596e:	64a2                	ld	s1,8(sp)
    80005970:	6902                	ld	s2,0(sp)
    80005972:	6105                	addi	sp,sp,32
    80005974:	8082                	ret
  switch(c){
    80005976:	07f00793          	li	a5,127
    8000597a:	0af48e63          	beq	s1,a5,80005a36 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000597e:	0001c717          	auipc	a4,0x1c
    80005982:	4b270713          	addi	a4,a4,1202 # 80021e30 <cons>
    80005986:	0a072783          	lw	a5,160(a4)
    8000598a:	09872703          	lw	a4,152(a4)
    8000598e:	9f99                	subw	a5,a5,a4
    80005990:	07f00713          	li	a4,127
    80005994:	fcf763e3          	bltu	a4,a5,8000595a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005998:	47b5                	li	a5,13
    8000599a:	0cf48763          	beq	s1,a5,80005a68 <consoleintr+0x14a>
      consputc(c);
    8000599e:	8526                	mv	a0,s1
    800059a0:	00000097          	auipc	ra,0x0
    800059a4:	f3c080e7          	jalr	-196(ra) # 800058dc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800059a8:	0001c797          	auipc	a5,0x1c
    800059ac:	48878793          	addi	a5,a5,1160 # 80021e30 <cons>
    800059b0:	0a07a683          	lw	a3,160(a5)
    800059b4:	0016871b          	addiw	a4,a3,1
    800059b8:	0007061b          	sext.w	a2,a4
    800059bc:	0ae7a023          	sw	a4,160(a5)
    800059c0:	07f6f693          	andi	a3,a3,127
    800059c4:	97b6                	add	a5,a5,a3
    800059c6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800059ca:	47a9                	li	a5,10
    800059cc:	0cf48563          	beq	s1,a5,80005a96 <consoleintr+0x178>
    800059d0:	4791                	li	a5,4
    800059d2:	0cf48263          	beq	s1,a5,80005a96 <consoleintr+0x178>
    800059d6:	0001c797          	auipc	a5,0x1c
    800059da:	4f27a783          	lw	a5,1266(a5) # 80021ec8 <cons+0x98>
    800059de:	9f1d                	subw	a4,a4,a5
    800059e0:	08000793          	li	a5,128
    800059e4:	f6f71be3          	bne	a4,a5,8000595a <consoleintr+0x3c>
    800059e8:	a07d                	j	80005a96 <consoleintr+0x178>
    while(cons.e != cons.w &&
    800059ea:	0001c717          	auipc	a4,0x1c
    800059ee:	44670713          	addi	a4,a4,1094 # 80021e30 <cons>
    800059f2:	0a072783          	lw	a5,160(a4)
    800059f6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800059fa:	0001c497          	auipc	s1,0x1c
    800059fe:	43648493          	addi	s1,s1,1078 # 80021e30 <cons>
    while(cons.e != cons.w &&
    80005a02:	4929                	li	s2,10
    80005a04:	f4f70be3          	beq	a4,a5,8000595a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a08:	37fd                	addiw	a5,a5,-1
    80005a0a:	07f7f713          	andi	a4,a5,127
    80005a0e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a10:	01874703          	lbu	a4,24(a4)
    80005a14:	f52703e3          	beq	a4,s2,8000595a <consoleintr+0x3c>
      cons.e--;
    80005a18:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a1c:	10000513          	li	a0,256
    80005a20:	00000097          	auipc	ra,0x0
    80005a24:	ebc080e7          	jalr	-324(ra) # 800058dc <consputc>
    while(cons.e != cons.w &&
    80005a28:	0a04a783          	lw	a5,160(s1)
    80005a2c:	09c4a703          	lw	a4,156(s1)
    80005a30:	fcf71ce3          	bne	a4,a5,80005a08 <consoleintr+0xea>
    80005a34:	b71d                	j	8000595a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a36:	0001c717          	auipc	a4,0x1c
    80005a3a:	3fa70713          	addi	a4,a4,1018 # 80021e30 <cons>
    80005a3e:	0a072783          	lw	a5,160(a4)
    80005a42:	09c72703          	lw	a4,156(a4)
    80005a46:	f0f70ae3          	beq	a4,a5,8000595a <consoleintr+0x3c>
      cons.e--;
    80005a4a:	37fd                	addiw	a5,a5,-1
    80005a4c:	0001c717          	auipc	a4,0x1c
    80005a50:	48f72223          	sw	a5,1156(a4) # 80021ed0 <cons+0xa0>
      consputc(BACKSPACE);
    80005a54:	10000513          	li	a0,256
    80005a58:	00000097          	auipc	ra,0x0
    80005a5c:	e84080e7          	jalr	-380(ra) # 800058dc <consputc>
    80005a60:	bded                	j	8000595a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a62:	ee048ce3          	beqz	s1,8000595a <consoleintr+0x3c>
    80005a66:	bf21                	j	8000597e <consoleintr+0x60>
      consputc(c);
    80005a68:	4529                	li	a0,10
    80005a6a:	00000097          	auipc	ra,0x0
    80005a6e:	e72080e7          	jalr	-398(ra) # 800058dc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a72:	0001c797          	auipc	a5,0x1c
    80005a76:	3be78793          	addi	a5,a5,958 # 80021e30 <cons>
    80005a7a:	0a07a703          	lw	a4,160(a5)
    80005a7e:	0017069b          	addiw	a3,a4,1
    80005a82:	0006861b          	sext.w	a2,a3
    80005a86:	0ad7a023          	sw	a3,160(a5)
    80005a8a:	07f77713          	andi	a4,a4,127
    80005a8e:	97ba                	add	a5,a5,a4
    80005a90:	4729                	li	a4,10
    80005a92:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a96:	0001c797          	auipc	a5,0x1c
    80005a9a:	42c7ab23          	sw	a2,1078(a5) # 80021ecc <cons+0x9c>
        wakeup(&cons.r);
    80005a9e:	0001c517          	auipc	a0,0x1c
    80005aa2:	42a50513          	addi	a0,a0,1066 # 80021ec8 <cons+0x98>
    80005aa6:	ffffc097          	auipc	ra,0xffffc
    80005aaa:	ac4080e7          	jalr	-1340(ra) # 8000156a <wakeup>
    80005aae:	b575                	j	8000595a <consoleintr+0x3c>

0000000080005ab0 <consoleinit>:

void
consoleinit(void)
{
    80005ab0:	1141                	addi	sp,sp,-16
    80005ab2:	e406                	sd	ra,8(sp)
    80005ab4:	e022                	sd	s0,0(sp)
    80005ab6:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ab8:	00003597          	auipc	a1,0x3
    80005abc:	d0858593          	addi	a1,a1,-760 # 800087c0 <syscalls+0x3f0>
    80005ac0:	0001c517          	auipc	a0,0x1c
    80005ac4:	37050513          	addi	a0,a0,880 # 80021e30 <cons>
    80005ac8:	00000097          	auipc	ra,0x0
    80005acc:	582080e7          	jalr	1410(ra) # 8000604a <initlock>

  uartinit();
    80005ad0:	00000097          	auipc	ra,0x0
    80005ad4:	32a080e7          	jalr	810(ra) # 80005dfa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ad8:	00013797          	auipc	a5,0x13
    80005adc:	08078793          	addi	a5,a5,128 # 80018b58 <devsw>
    80005ae0:	00000717          	auipc	a4,0x0
    80005ae4:	ce470713          	addi	a4,a4,-796 # 800057c4 <consoleread>
    80005ae8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005aea:	00000717          	auipc	a4,0x0
    80005aee:	c7870713          	addi	a4,a4,-904 # 80005762 <consolewrite>
    80005af2:	ef98                	sd	a4,24(a5)
}
    80005af4:	60a2                	ld	ra,8(sp)
    80005af6:	6402                	ld	s0,0(sp)
    80005af8:	0141                	addi	sp,sp,16
    80005afa:	8082                	ret

0000000080005afc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005afc:	7179                	addi	sp,sp,-48
    80005afe:	f406                	sd	ra,40(sp)
    80005b00:	f022                	sd	s0,32(sp)
    80005b02:	ec26                	sd	s1,24(sp)
    80005b04:	e84a                	sd	s2,16(sp)
    80005b06:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b08:	c219                	beqz	a2,80005b0e <printint+0x12>
    80005b0a:	08054663          	bltz	a0,80005b96 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005b0e:	2501                	sext.w	a0,a0
    80005b10:	4881                	li	a7,0
    80005b12:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b16:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b18:	2581                	sext.w	a1,a1
    80005b1a:	00003617          	auipc	a2,0x3
    80005b1e:	cd660613          	addi	a2,a2,-810 # 800087f0 <digits>
    80005b22:	883a                	mv	a6,a4
    80005b24:	2705                	addiw	a4,a4,1
    80005b26:	02b577bb          	remuw	a5,a0,a1
    80005b2a:	1782                	slli	a5,a5,0x20
    80005b2c:	9381                	srli	a5,a5,0x20
    80005b2e:	97b2                	add	a5,a5,a2
    80005b30:	0007c783          	lbu	a5,0(a5)
    80005b34:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b38:	0005079b          	sext.w	a5,a0
    80005b3c:	02b5553b          	divuw	a0,a0,a1
    80005b40:	0685                	addi	a3,a3,1
    80005b42:	feb7f0e3          	bgeu	a5,a1,80005b22 <printint+0x26>

  if(sign)
    80005b46:	00088b63          	beqz	a7,80005b5c <printint+0x60>
    buf[i++] = '-';
    80005b4a:	fe040793          	addi	a5,s0,-32
    80005b4e:	973e                	add	a4,a4,a5
    80005b50:	02d00793          	li	a5,45
    80005b54:	fef70823          	sb	a5,-16(a4)
    80005b58:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005b5c:	02e05763          	blez	a4,80005b8a <printint+0x8e>
    80005b60:	fd040793          	addi	a5,s0,-48
    80005b64:	00e784b3          	add	s1,a5,a4
    80005b68:	fff78913          	addi	s2,a5,-1
    80005b6c:	993a                	add	s2,s2,a4
    80005b6e:	377d                	addiw	a4,a4,-1
    80005b70:	1702                	slli	a4,a4,0x20
    80005b72:	9301                	srli	a4,a4,0x20
    80005b74:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b78:	fff4c503          	lbu	a0,-1(s1)
    80005b7c:	00000097          	auipc	ra,0x0
    80005b80:	d60080e7          	jalr	-672(ra) # 800058dc <consputc>
  while(--i >= 0)
    80005b84:	14fd                	addi	s1,s1,-1
    80005b86:	ff2499e3          	bne	s1,s2,80005b78 <printint+0x7c>
}
    80005b8a:	70a2                	ld	ra,40(sp)
    80005b8c:	7402                	ld	s0,32(sp)
    80005b8e:	64e2                	ld	s1,24(sp)
    80005b90:	6942                	ld	s2,16(sp)
    80005b92:	6145                	addi	sp,sp,48
    80005b94:	8082                	ret
    x = -xx;
    80005b96:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005b9a:	4885                	li	a7,1
    x = -xx;
    80005b9c:	bf9d                	j	80005b12 <printint+0x16>

0000000080005b9e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005b9e:	1101                	addi	sp,sp,-32
    80005ba0:	ec06                	sd	ra,24(sp)
    80005ba2:	e822                	sd	s0,16(sp)
    80005ba4:	e426                	sd	s1,8(sp)
    80005ba6:	1000                	addi	s0,sp,32
    80005ba8:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005baa:	0001c797          	auipc	a5,0x1c
    80005bae:	3407a323          	sw	zero,838(a5) # 80021ef0 <pr+0x18>
  printf("panic: ");
    80005bb2:	00003517          	auipc	a0,0x3
    80005bb6:	c1650513          	addi	a0,a0,-1002 # 800087c8 <syscalls+0x3f8>
    80005bba:	00000097          	auipc	ra,0x0
    80005bbe:	02e080e7          	jalr	46(ra) # 80005be8 <printf>
  printf(s);
    80005bc2:	8526                	mv	a0,s1
    80005bc4:	00000097          	auipc	ra,0x0
    80005bc8:	024080e7          	jalr	36(ra) # 80005be8 <printf>
  printf("\n");
    80005bcc:	00002517          	auipc	a0,0x2
    80005bd0:	47c50513          	addi	a0,a0,1148 # 80008048 <etext+0x48>
    80005bd4:	00000097          	auipc	ra,0x0
    80005bd8:	014080e7          	jalr	20(ra) # 80005be8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005bdc:	4785                	li	a5,1
    80005bde:	00003717          	auipc	a4,0x3
    80005be2:	ccf72723          	sw	a5,-818(a4) # 800088ac <panicked>
  for(;;)
    80005be6:	a001                	j	80005be6 <panic+0x48>

0000000080005be8 <printf>:
{
    80005be8:	7131                	addi	sp,sp,-192
    80005bea:	fc86                	sd	ra,120(sp)
    80005bec:	f8a2                	sd	s0,112(sp)
    80005bee:	f4a6                	sd	s1,104(sp)
    80005bf0:	f0ca                	sd	s2,96(sp)
    80005bf2:	ecce                	sd	s3,88(sp)
    80005bf4:	e8d2                	sd	s4,80(sp)
    80005bf6:	e4d6                	sd	s5,72(sp)
    80005bf8:	e0da                	sd	s6,64(sp)
    80005bfa:	fc5e                	sd	s7,56(sp)
    80005bfc:	f862                	sd	s8,48(sp)
    80005bfe:	f466                	sd	s9,40(sp)
    80005c00:	f06a                	sd	s10,32(sp)
    80005c02:	ec6e                	sd	s11,24(sp)
    80005c04:	0100                	addi	s0,sp,128
    80005c06:	8a2a                	mv	s4,a0
    80005c08:	e40c                	sd	a1,8(s0)
    80005c0a:	e810                	sd	a2,16(s0)
    80005c0c:	ec14                	sd	a3,24(s0)
    80005c0e:	f018                	sd	a4,32(s0)
    80005c10:	f41c                	sd	a5,40(s0)
    80005c12:	03043823          	sd	a6,48(s0)
    80005c16:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c1a:	0001cd97          	auipc	s11,0x1c
    80005c1e:	2d6dad83          	lw	s11,726(s11) # 80021ef0 <pr+0x18>
  if(locking)
    80005c22:	020d9b63          	bnez	s11,80005c58 <printf+0x70>
  if (fmt == 0)
    80005c26:	040a0263          	beqz	s4,80005c6a <printf+0x82>
  va_start(ap, fmt);
    80005c2a:	00840793          	addi	a5,s0,8
    80005c2e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c32:	000a4503          	lbu	a0,0(s4)
    80005c36:	14050f63          	beqz	a0,80005d94 <printf+0x1ac>
    80005c3a:	4981                	li	s3,0
    if(c != '%'){
    80005c3c:	02500a93          	li	s5,37
    switch(c){
    80005c40:	07000b93          	li	s7,112
  consputc('x');
    80005c44:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c46:	00003b17          	auipc	s6,0x3
    80005c4a:	baab0b13          	addi	s6,s6,-1110 # 800087f0 <digits>
    switch(c){
    80005c4e:	07300c93          	li	s9,115
    80005c52:	06400c13          	li	s8,100
    80005c56:	a82d                	j	80005c90 <printf+0xa8>
    acquire(&pr.lock);
    80005c58:	0001c517          	auipc	a0,0x1c
    80005c5c:	28050513          	addi	a0,a0,640 # 80021ed8 <pr>
    80005c60:	00000097          	auipc	ra,0x0
    80005c64:	47a080e7          	jalr	1146(ra) # 800060da <acquire>
    80005c68:	bf7d                	j	80005c26 <printf+0x3e>
    panic("null fmt");
    80005c6a:	00003517          	auipc	a0,0x3
    80005c6e:	b6e50513          	addi	a0,a0,-1170 # 800087d8 <syscalls+0x408>
    80005c72:	00000097          	auipc	ra,0x0
    80005c76:	f2c080e7          	jalr	-212(ra) # 80005b9e <panic>
      consputc(c);
    80005c7a:	00000097          	auipc	ra,0x0
    80005c7e:	c62080e7          	jalr	-926(ra) # 800058dc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c82:	2985                	addiw	s3,s3,1
    80005c84:	013a07b3          	add	a5,s4,s3
    80005c88:	0007c503          	lbu	a0,0(a5)
    80005c8c:	10050463          	beqz	a0,80005d94 <printf+0x1ac>
    if(c != '%'){
    80005c90:	ff5515e3          	bne	a0,s5,80005c7a <printf+0x92>
    c = fmt[++i] & 0xff;
    80005c94:	2985                	addiw	s3,s3,1
    80005c96:	013a07b3          	add	a5,s4,s3
    80005c9a:	0007c783          	lbu	a5,0(a5)
    80005c9e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005ca2:	cbed                	beqz	a5,80005d94 <printf+0x1ac>
    switch(c){
    80005ca4:	05778a63          	beq	a5,s7,80005cf8 <printf+0x110>
    80005ca8:	02fbf663          	bgeu	s7,a5,80005cd4 <printf+0xec>
    80005cac:	09978863          	beq	a5,s9,80005d3c <printf+0x154>
    80005cb0:	07800713          	li	a4,120
    80005cb4:	0ce79563          	bne	a5,a4,80005d7e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005cb8:	f8843783          	ld	a5,-120(s0)
    80005cbc:	00878713          	addi	a4,a5,8
    80005cc0:	f8e43423          	sd	a4,-120(s0)
    80005cc4:	4605                	li	a2,1
    80005cc6:	85ea                	mv	a1,s10
    80005cc8:	4388                	lw	a0,0(a5)
    80005cca:	00000097          	auipc	ra,0x0
    80005cce:	e32080e7          	jalr	-462(ra) # 80005afc <printint>
      break;
    80005cd2:	bf45                	j	80005c82 <printf+0x9a>
    switch(c){
    80005cd4:	09578f63          	beq	a5,s5,80005d72 <printf+0x18a>
    80005cd8:	0b879363          	bne	a5,s8,80005d7e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005cdc:	f8843783          	ld	a5,-120(s0)
    80005ce0:	00878713          	addi	a4,a5,8
    80005ce4:	f8e43423          	sd	a4,-120(s0)
    80005ce8:	4605                	li	a2,1
    80005cea:	45a9                	li	a1,10
    80005cec:	4388                	lw	a0,0(a5)
    80005cee:	00000097          	auipc	ra,0x0
    80005cf2:	e0e080e7          	jalr	-498(ra) # 80005afc <printint>
      break;
    80005cf6:	b771                	j	80005c82 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005cf8:	f8843783          	ld	a5,-120(s0)
    80005cfc:	00878713          	addi	a4,a5,8
    80005d00:	f8e43423          	sd	a4,-120(s0)
    80005d04:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005d08:	03000513          	li	a0,48
    80005d0c:	00000097          	auipc	ra,0x0
    80005d10:	bd0080e7          	jalr	-1072(ra) # 800058dc <consputc>
  consputc('x');
    80005d14:	07800513          	li	a0,120
    80005d18:	00000097          	auipc	ra,0x0
    80005d1c:	bc4080e7          	jalr	-1084(ra) # 800058dc <consputc>
    80005d20:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d22:	03c95793          	srli	a5,s2,0x3c
    80005d26:	97da                	add	a5,a5,s6
    80005d28:	0007c503          	lbu	a0,0(a5)
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	bb0080e7          	jalr	-1104(ra) # 800058dc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d34:	0912                	slli	s2,s2,0x4
    80005d36:	34fd                	addiw	s1,s1,-1
    80005d38:	f4ed                	bnez	s1,80005d22 <printf+0x13a>
    80005d3a:	b7a1                	j	80005c82 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d3c:	f8843783          	ld	a5,-120(s0)
    80005d40:	00878713          	addi	a4,a5,8
    80005d44:	f8e43423          	sd	a4,-120(s0)
    80005d48:	6384                	ld	s1,0(a5)
    80005d4a:	cc89                	beqz	s1,80005d64 <printf+0x17c>
      for(; *s; s++)
    80005d4c:	0004c503          	lbu	a0,0(s1)
    80005d50:	d90d                	beqz	a0,80005c82 <printf+0x9a>
        consputc(*s);
    80005d52:	00000097          	auipc	ra,0x0
    80005d56:	b8a080e7          	jalr	-1142(ra) # 800058dc <consputc>
      for(; *s; s++)
    80005d5a:	0485                	addi	s1,s1,1
    80005d5c:	0004c503          	lbu	a0,0(s1)
    80005d60:	f96d                	bnez	a0,80005d52 <printf+0x16a>
    80005d62:	b705                	j	80005c82 <printf+0x9a>
        s = "(null)";
    80005d64:	00003497          	auipc	s1,0x3
    80005d68:	a6c48493          	addi	s1,s1,-1428 # 800087d0 <syscalls+0x400>
      for(; *s; s++)
    80005d6c:	02800513          	li	a0,40
    80005d70:	b7cd                	j	80005d52 <printf+0x16a>
      consputc('%');
    80005d72:	8556                	mv	a0,s5
    80005d74:	00000097          	auipc	ra,0x0
    80005d78:	b68080e7          	jalr	-1176(ra) # 800058dc <consputc>
      break;
    80005d7c:	b719                	j	80005c82 <printf+0x9a>
      consputc('%');
    80005d7e:	8556                	mv	a0,s5
    80005d80:	00000097          	auipc	ra,0x0
    80005d84:	b5c080e7          	jalr	-1188(ra) # 800058dc <consputc>
      consputc(c);
    80005d88:	8526                	mv	a0,s1
    80005d8a:	00000097          	auipc	ra,0x0
    80005d8e:	b52080e7          	jalr	-1198(ra) # 800058dc <consputc>
      break;
    80005d92:	bdc5                	j	80005c82 <printf+0x9a>
  if(locking)
    80005d94:	020d9163          	bnez	s11,80005db6 <printf+0x1ce>
}
    80005d98:	70e6                	ld	ra,120(sp)
    80005d9a:	7446                	ld	s0,112(sp)
    80005d9c:	74a6                	ld	s1,104(sp)
    80005d9e:	7906                	ld	s2,96(sp)
    80005da0:	69e6                	ld	s3,88(sp)
    80005da2:	6a46                	ld	s4,80(sp)
    80005da4:	6aa6                	ld	s5,72(sp)
    80005da6:	6b06                	ld	s6,64(sp)
    80005da8:	7be2                	ld	s7,56(sp)
    80005daa:	7c42                	ld	s8,48(sp)
    80005dac:	7ca2                	ld	s9,40(sp)
    80005dae:	7d02                	ld	s10,32(sp)
    80005db0:	6de2                	ld	s11,24(sp)
    80005db2:	6129                	addi	sp,sp,192
    80005db4:	8082                	ret
    release(&pr.lock);
    80005db6:	0001c517          	auipc	a0,0x1c
    80005dba:	12250513          	addi	a0,a0,290 # 80021ed8 <pr>
    80005dbe:	00000097          	auipc	ra,0x0
    80005dc2:	3d0080e7          	jalr	976(ra) # 8000618e <release>
}
    80005dc6:	bfc9                	j	80005d98 <printf+0x1b0>

0000000080005dc8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005dc8:	1101                	addi	sp,sp,-32
    80005dca:	ec06                	sd	ra,24(sp)
    80005dcc:	e822                	sd	s0,16(sp)
    80005dce:	e426                	sd	s1,8(sp)
    80005dd0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005dd2:	0001c497          	auipc	s1,0x1c
    80005dd6:	10648493          	addi	s1,s1,262 # 80021ed8 <pr>
    80005dda:	00003597          	auipc	a1,0x3
    80005dde:	a0e58593          	addi	a1,a1,-1522 # 800087e8 <syscalls+0x418>
    80005de2:	8526                	mv	a0,s1
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	266080e7          	jalr	614(ra) # 8000604a <initlock>
  pr.locking = 1;
    80005dec:	4785                	li	a5,1
    80005dee:	cc9c                	sw	a5,24(s1)
}
    80005df0:	60e2                	ld	ra,24(sp)
    80005df2:	6442                	ld	s0,16(sp)
    80005df4:	64a2                	ld	s1,8(sp)
    80005df6:	6105                	addi	sp,sp,32
    80005df8:	8082                	ret

0000000080005dfa <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005dfa:	1141                	addi	sp,sp,-16
    80005dfc:	e406                	sd	ra,8(sp)
    80005dfe:	e022                	sd	s0,0(sp)
    80005e00:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e02:	100007b7          	lui	a5,0x10000
    80005e06:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e0a:	f8000713          	li	a4,-128
    80005e0e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e12:	470d                	li	a4,3
    80005e14:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e18:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e1c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e20:	469d                	li	a3,7
    80005e22:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e26:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e2a:	00003597          	auipc	a1,0x3
    80005e2e:	9de58593          	addi	a1,a1,-1570 # 80008808 <digits+0x18>
    80005e32:	0001c517          	auipc	a0,0x1c
    80005e36:	0c650513          	addi	a0,a0,198 # 80021ef8 <uart_tx_lock>
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	210080e7          	jalr	528(ra) # 8000604a <initlock>
}
    80005e42:	60a2                	ld	ra,8(sp)
    80005e44:	6402                	ld	s0,0(sp)
    80005e46:	0141                	addi	sp,sp,16
    80005e48:	8082                	ret

0000000080005e4a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e4a:	1101                	addi	sp,sp,-32
    80005e4c:	ec06                	sd	ra,24(sp)
    80005e4e:	e822                	sd	s0,16(sp)
    80005e50:	e426                	sd	s1,8(sp)
    80005e52:	1000                	addi	s0,sp,32
    80005e54:	84aa                	mv	s1,a0
  push_off();
    80005e56:	00000097          	auipc	ra,0x0
    80005e5a:	238080e7          	jalr	568(ra) # 8000608e <push_off>

  if(panicked){
    80005e5e:	00003797          	auipc	a5,0x3
    80005e62:	a4e7a783          	lw	a5,-1458(a5) # 800088ac <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e66:	10000737          	lui	a4,0x10000
  if(panicked){
    80005e6a:	c391                	beqz	a5,80005e6e <uartputc_sync+0x24>
    for(;;)
    80005e6c:	a001                	j	80005e6c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e6e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005e72:	0207f793          	andi	a5,a5,32
    80005e76:	dfe5                	beqz	a5,80005e6e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e78:	0ff4f513          	andi	a0,s1,255
    80005e7c:	100007b7          	lui	a5,0x10000
    80005e80:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	2aa080e7          	jalr	682(ra) # 8000612e <pop_off>
}
    80005e8c:	60e2                	ld	ra,24(sp)
    80005e8e:	6442                	ld	s0,16(sp)
    80005e90:	64a2                	ld	s1,8(sp)
    80005e92:	6105                	addi	sp,sp,32
    80005e94:	8082                	ret

0000000080005e96 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005e96:	00003797          	auipc	a5,0x3
    80005e9a:	a1a7b783          	ld	a5,-1510(a5) # 800088b0 <uart_tx_r>
    80005e9e:	00003717          	auipc	a4,0x3
    80005ea2:	a1a73703          	ld	a4,-1510(a4) # 800088b8 <uart_tx_w>
    80005ea6:	06f70a63          	beq	a4,a5,80005f1a <uartstart+0x84>
{
    80005eaa:	7139                	addi	sp,sp,-64
    80005eac:	fc06                	sd	ra,56(sp)
    80005eae:	f822                	sd	s0,48(sp)
    80005eb0:	f426                	sd	s1,40(sp)
    80005eb2:	f04a                	sd	s2,32(sp)
    80005eb4:	ec4e                	sd	s3,24(sp)
    80005eb6:	e852                	sd	s4,16(sp)
    80005eb8:	e456                	sd	s5,8(sp)
    80005eba:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ebc:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ec0:	0001ca17          	auipc	s4,0x1c
    80005ec4:	038a0a13          	addi	s4,s4,56 # 80021ef8 <uart_tx_lock>
    uart_tx_r += 1;
    80005ec8:	00003497          	auipc	s1,0x3
    80005ecc:	9e848493          	addi	s1,s1,-1560 # 800088b0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005ed0:	00003997          	auipc	s3,0x3
    80005ed4:	9e898993          	addi	s3,s3,-1560 # 800088b8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ed8:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005edc:	02077713          	andi	a4,a4,32
    80005ee0:	c705                	beqz	a4,80005f08 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ee2:	01f7f713          	andi	a4,a5,31
    80005ee6:	9752                	add	a4,a4,s4
    80005ee8:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005eec:	0785                	addi	a5,a5,1
    80005eee:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ef0:	8526                	mv	a0,s1
    80005ef2:	ffffb097          	auipc	ra,0xffffb
    80005ef6:	678080e7          	jalr	1656(ra) # 8000156a <wakeup>
    
    WriteReg(THR, c);
    80005efa:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005efe:	609c                	ld	a5,0(s1)
    80005f00:	0009b703          	ld	a4,0(s3)
    80005f04:	fcf71ae3          	bne	a4,a5,80005ed8 <uartstart+0x42>
  }
}
    80005f08:	70e2                	ld	ra,56(sp)
    80005f0a:	7442                	ld	s0,48(sp)
    80005f0c:	74a2                	ld	s1,40(sp)
    80005f0e:	7902                	ld	s2,32(sp)
    80005f10:	69e2                	ld	s3,24(sp)
    80005f12:	6a42                	ld	s4,16(sp)
    80005f14:	6aa2                	ld	s5,8(sp)
    80005f16:	6121                	addi	sp,sp,64
    80005f18:	8082                	ret
    80005f1a:	8082                	ret

0000000080005f1c <uartputc>:
{
    80005f1c:	7179                	addi	sp,sp,-48
    80005f1e:	f406                	sd	ra,40(sp)
    80005f20:	f022                	sd	s0,32(sp)
    80005f22:	ec26                	sd	s1,24(sp)
    80005f24:	e84a                	sd	s2,16(sp)
    80005f26:	e44e                	sd	s3,8(sp)
    80005f28:	e052                	sd	s4,0(sp)
    80005f2a:	1800                	addi	s0,sp,48
    80005f2c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005f2e:	0001c517          	auipc	a0,0x1c
    80005f32:	fca50513          	addi	a0,a0,-54 # 80021ef8 <uart_tx_lock>
    80005f36:	00000097          	auipc	ra,0x0
    80005f3a:	1a4080e7          	jalr	420(ra) # 800060da <acquire>
  if(panicked){
    80005f3e:	00003797          	auipc	a5,0x3
    80005f42:	96e7a783          	lw	a5,-1682(a5) # 800088ac <panicked>
    80005f46:	e7c9                	bnez	a5,80005fd0 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f48:	00003717          	auipc	a4,0x3
    80005f4c:	97073703          	ld	a4,-1680(a4) # 800088b8 <uart_tx_w>
    80005f50:	00003797          	auipc	a5,0x3
    80005f54:	9607b783          	ld	a5,-1696(a5) # 800088b0 <uart_tx_r>
    80005f58:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f5c:	0001c997          	auipc	s3,0x1c
    80005f60:	f9c98993          	addi	s3,s3,-100 # 80021ef8 <uart_tx_lock>
    80005f64:	00003497          	auipc	s1,0x3
    80005f68:	94c48493          	addi	s1,s1,-1716 # 800088b0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f6c:	00003917          	auipc	s2,0x3
    80005f70:	94c90913          	addi	s2,s2,-1716 # 800088b8 <uart_tx_w>
    80005f74:	00e79f63          	bne	a5,a4,80005f92 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f78:	85ce                	mv	a1,s3
    80005f7a:	8526                	mv	a0,s1
    80005f7c:	ffffb097          	auipc	ra,0xffffb
    80005f80:	58a080e7          	jalr	1418(ra) # 80001506 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f84:	00093703          	ld	a4,0(s2)
    80005f88:	609c                	ld	a5,0(s1)
    80005f8a:	02078793          	addi	a5,a5,32
    80005f8e:	fee785e3          	beq	a5,a4,80005f78 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005f92:	0001c497          	auipc	s1,0x1c
    80005f96:	f6648493          	addi	s1,s1,-154 # 80021ef8 <uart_tx_lock>
    80005f9a:	01f77793          	andi	a5,a4,31
    80005f9e:	97a6                	add	a5,a5,s1
    80005fa0:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005fa4:	0705                	addi	a4,a4,1
    80005fa6:	00003797          	auipc	a5,0x3
    80005faa:	90e7b923          	sd	a4,-1774(a5) # 800088b8 <uart_tx_w>
  uartstart();
    80005fae:	00000097          	auipc	ra,0x0
    80005fb2:	ee8080e7          	jalr	-280(ra) # 80005e96 <uartstart>
  release(&uart_tx_lock);
    80005fb6:	8526                	mv	a0,s1
    80005fb8:	00000097          	auipc	ra,0x0
    80005fbc:	1d6080e7          	jalr	470(ra) # 8000618e <release>
}
    80005fc0:	70a2                	ld	ra,40(sp)
    80005fc2:	7402                	ld	s0,32(sp)
    80005fc4:	64e2                	ld	s1,24(sp)
    80005fc6:	6942                	ld	s2,16(sp)
    80005fc8:	69a2                	ld	s3,8(sp)
    80005fca:	6a02                	ld	s4,0(sp)
    80005fcc:	6145                	addi	sp,sp,48
    80005fce:	8082                	ret
    for(;;)
    80005fd0:	a001                	j	80005fd0 <uartputc+0xb4>

0000000080005fd2 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005fd2:	1141                	addi	sp,sp,-16
    80005fd4:	e422                	sd	s0,8(sp)
    80005fd6:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005fd8:	100007b7          	lui	a5,0x10000
    80005fdc:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005fe0:	8b85                	andi	a5,a5,1
    80005fe2:	cb91                	beqz	a5,80005ff6 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005fe4:	100007b7          	lui	a5,0x10000
    80005fe8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80005fec:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80005ff0:	6422                	ld	s0,8(sp)
    80005ff2:	0141                	addi	sp,sp,16
    80005ff4:	8082                	ret
    return -1;
    80005ff6:	557d                	li	a0,-1
    80005ff8:	bfe5                	j	80005ff0 <uartgetc+0x1e>

0000000080005ffa <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005ffa:	1101                	addi	sp,sp,-32
    80005ffc:	ec06                	sd	ra,24(sp)
    80005ffe:	e822                	sd	s0,16(sp)
    80006000:	e426                	sd	s1,8(sp)
    80006002:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006004:	54fd                	li	s1,-1
    80006006:	a029                	j	80006010 <uartintr+0x16>
      break;
    consoleintr(c);
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	916080e7          	jalr	-1770(ra) # 8000591e <consoleintr>
    int c = uartgetc();
    80006010:	00000097          	auipc	ra,0x0
    80006014:	fc2080e7          	jalr	-62(ra) # 80005fd2 <uartgetc>
    if(c == -1)
    80006018:	fe9518e3          	bne	a0,s1,80006008 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000601c:	0001c497          	auipc	s1,0x1c
    80006020:	edc48493          	addi	s1,s1,-292 # 80021ef8 <uart_tx_lock>
    80006024:	8526                	mv	a0,s1
    80006026:	00000097          	auipc	ra,0x0
    8000602a:	0b4080e7          	jalr	180(ra) # 800060da <acquire>
  uartstart();
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	e68080e7          	jalr	-408(ra) # 80005e96 <uartstart>
  release(&uart_tx_lock);
    80006036:	8526                	mv	a0,s1
    80006038:	00000097          	auipc	ra,0x0
    8000603c:	156080e7          	jalr	342(ra) # 8000618e <release>
}
    80006040:	60e2                	ld	ra,24(sp)
    80006042:	6442                	ld	s0,16(sp)
    80006044:	64a2                	ld	s1,8(sp)
    80006046:	6105                	addi	sp,sp,32
    80006048:	8082                	ret

000000008000604a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000604a:	1141                	addi	sp,sp,-16
    8000604c:	e422                	sd	s0,8(sp)
    8000604e:	0800                	addi	s0,sp,16
  lk->name = name;
    80006050:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006052:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006056:	00053823          	sd	zero,16(a0)
}
    8000605a:	6422                	ld	s0,8(sp)
    8000605c:	0141                	addi	sp,sp,16
    8000605e:	8082                	ret

0000000080006060 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006060:	411c                	lw	a5,0(a0)
    80006062:	e399                	bnez	a5,80006068 <holding+0x8>
    80006064:	4501                	li	a0,0
  return r;
}
    80006066:	8082                	ret
{
    80006068:	1101                	addi	sp,sp,-32
    8000606a:	ec06                	sd	ra,24(sp)
    8000606c:	e822                	sd	s0,16(sp)
    8000606e:	e426                	sd	s1,8(sp)
    80006070:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006072:	6904                	ld	s1,16(a0)
    80006074:	ffffb097          	auipc	ra,0xffffb
    80006078:	dc2080e7          	jalr	-574(ra) # 80000e36 <mycpu>
    8000607c:	40a48533          	sub	a0,s1,a0
    80006080:	00153513          	seqz	a0,a0
}
    80006084:	60e2                	ld	ra,24(sp)
    80006086:	6442                	ld	s0,16(sp)
    80006088:	64a2                	ld	s1,8(sp)
    8000608a:	6105                	addi	sp,sp,32
    8000608c:	8082                	ret

000000008000608e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000608e:	1101                	addi	sp,sp,-32
    80006090:	ec06                	sd	ra,24(sp)
    80006092:	e822                	sd	s0,16(sp)
    80006094:	e426                	sd	s1,8(sp)
    80006096:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006098:	100024f3          	csrr	s1,sstatus
    8000609c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800060a0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800060a2:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800060a6:	ffffb097          	auipc	ra,0xffffb
    800060aa:	d90080e7          	jalr	-624(ra) # 80000e36 <mycpu>
    800060ae:	5d3c                	lw	a5,120(a0)
    800060b0:	cf89                	beqz	a5,800060ca <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800060b2:	ffffb097          	auipc	ra,0xffffb
    800060b6:	d84080e7          	jalr	-636(ra) # 80000e36 <mycpu>
    800060ba:	5d3c                	lw	a5,120(a0)
    800060bc:	2785                	addiw	a5,a5,1
    800060be:	dd3c                	sw	a5,120(a0)
}
    800060c0:	60e2                	ld	ra,24(sp)
    800060c2:	6442                	ld	s0,16(sp)
    800060c4:	64a2                	ld	s1,8(sp)
    800060c6:	6105                	addi	sp,sp,32
    800060c8:	8082                	ret
    mycpu()->intena = old;
    800060ca:	ffffb097          	auipc	ra,0xffffb
    800060ce:	d6c080e7          	jalr	-660(ra) # 80000e36 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800060d2:	8085                	srli	s1,s1,0x1
    800060d4:	8885                	andi	s1,s1,1
    800060d6:	dd64                	sw	s1,124(a0)
    800060d8:	bfe9                	j	800060b2 <push_off+0x24>

00000000800060da <acquire>:
{
    800060da:	1101                	addi	sp,sp,-32
    800060dc:	ec06                	sd	ra,24(sp)
    800060de:	e822                	sd	s0,16(sp)
    800060e0:	e426                	sd	s1,8(sp)
    800060e2:	1000                	addi	s0,sp,32
    800060e4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800060e6:	00000097          	auipc	ra,0x0
    800060ea:	fa8080e7          	jalr	-88(ra) # 8000608e <push_off>
  if(holding(lk))
    800060ee:	8526                	mv	a0,s1
    800060f0:	00000097          	auipc	ra,0x0
    800060f4:	f70080e7          	jalr	-144(ra) # 80006060 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060f8:	4705                	li	a4,1
  if(holding(lk))
    800060fa:	e115                	bnez	a0,8000611e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060fc:	87ba                	mv	a5,a4
    800060fe:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006102:	2781                	sext.w	a5,a5
    80006104:	ffe5                	bnez	a5,800060fc <acquire+0x22>
  __sync_synchronize();
    80006106:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000610a:	ffffb097          	auipc	ra,0xffffb
    8000610e:	d2c080e7          	jalr	-724(ra) # 80000e36 <mycpu>
    80006112:	e888                	sd	a0,16(s1)
}
    80006114:	60e2                	ld	ra,24(sp)
    80006116:	6442                	ld	s0,16(sp)
    80006118:	64a2                	ld	s1,8(sp)
    8000611a:	6105                	addi	sp,sp,32
    8000611c:	8082                	ret
    panic("acquire");
    8000611e:	00002517          	auipc	a0,0x2
    80006122:	6f250513          	addi	a0,a0,1778 # 80008810 <digits+0x20>
    80006126:	00000097          	auipc	ra,0x0
    8000612a:	a78080e7          	jalr	-1416(ra) # 80005b9e <panic>

000000008000612e <pop_off>:

void
pop_off(void)
{
    8000612e:	1141                	addi	sp,sp,-16
    80006130:	e406                	sd	ra,8(sp)
    80006132:	e022                	sd	s0,0(sp)
    80006134:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006136:	ffffb097          	auipc	ra,0xffffb
    8000613a:	d00080e7          	jalr	-768(ra) # 80000e36 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000613e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006142:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006144:	e78d                	bnez	a5,8000616e <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006146:	5d3c                	lw	a5,120(a0)
    80006148:	02f05b63          	blez	a5,8000617e <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000614c:	37fd                	addiw	a5,a5,-1
    8000614e:	0007871b          	sext.w	a4,a5
    80006152:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006154:	eb09                	bnez	a4,80006166 <pop_off+0x38>
    80006156:	5d7c                	lw	a5,124(a0)
    80006158:	c799                	beqz	a5,80006166 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000615a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000615e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006162:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006166:	60a2                	ld	ra,8(sp)
    80006168:	6402                	ld	s0,0(sp)
    8000616a:	0141                	addi	sp,sp,16
    8000616c:	8082                	ret
    panic("pop_off - interruptible");
    8000616e:	00002517          	auipc	a0,0x2
    80006172:	6aa50513          	addi	a0,a0,1706 # 80008818 <digits+0x28>
    80006176:	00000097          	auipc	ra,0x0
    8000617a:	a28080e7          	jalr	-1496(ra) # 80005b9e <panic>
    panic("pop_off");
    8000617e:	00002517          	auipc	a0,0x2
    80006182:	6b250513          	addi	a0,a0,1714 # 80008830 <digits+0x40>
    80006186:	00000097          	auipc	ra,0x0
    8000618a:	a18080e7          	jalr	-1512(ra) # 80005b9e <panic>

000000008000618e <release>:
{
    8000618e:	1101                	addi	sp,sp,-32
    80006190:	ec06                	sd	ra,24(sp)
    80006192:	e822                	sd	s0,16(sp)
    80006194:	e426                	sd	s1,8(sp)
    80006196:	1000                	addi	s0,sp,32
    80006198:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000619a:	00000097          	auipc	ra,0x0
    8000619e:	ec6080e7          	jalr	-314(ra) # 80006060 <holding>
    800061a2:	c115                	beqz	a0,800061c6 <release+0x38>
  lk->cpu = 0;
    800061a4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800061a8:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800061ac:	0f50000f          	fence	iorw,ow
    800061b0:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800061b4:	00000097          	auipc	ra,0x0
    800061b8:	f7a080e7          	jalr	-134(ra) # 8000612e <pop_off>
}
    800061bc:	60e2                	ld	ra,24(sp)
    800061be:	6442                	ld	s0,16(sp)
    800061c0:	64a2                	ld	s1,8(sp)
    800061c2:	6105                	addi	sp,sp,32
    800061c4:	8082                	ret
    panic("release");
    800061c6:	00002517          	auipc	a0,0x2
    800061ca:	67250513          	addi	a0,a0,1650 # 80008838 <digits+0x48>
    800061ce:	00000097          	auipc	ra,0x0
    800061d2:	9d0080e7          	jalr	-1584(ra) # 80005b9e <panic>
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
