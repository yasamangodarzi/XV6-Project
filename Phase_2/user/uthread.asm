
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(struct context*, struct context*);
              
void 
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	d7278793          	addi	a5,a5,-654 # d78 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	d4f73d23          	sd	a5,-678(a4) # d68 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	d6f72023          	sw	a5,-672(a4) # 2d78 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void 
thread_schedule(void)
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  2e:	00001517          	auipc	a0,0x1
  32:	d3a53503          	ld	a0,-710(a0) # d68 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	07858593          	addi	a1,a1,120 # 2078 <__global_pointer$+0xb2f>
  3c:	95aa                	add	a1,a1,a0
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	00009817          	auipc	a6,0x9
  44:	f1880813          	addi	a6,a6,-232 # 8f58 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6689                	lui	a3,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	07868893          	addi	a7,a3,120 # 2078 <__global_pointer$+0xb2f>
  50:	a809                	j	62 <thread_schedule+0x3c>
    if(t->state == RUNNABLE) {
  52:	00d58733          	add	a4,a1,a3
  56:	4318                	lw	a4,0(a4)
  58:	02c70963          	beq	a4,a2,8a <thread_schedule+0x64>
    t = t + 1;
  5c:	95c6                	add	a1,a1,a7
  for(int i = 0; i < MAX_THREAD; i++){
  5e:	37fd                	addiw	a5,a5,-1
  60:	cb81                	beqz	a5,70 <thread_schedule+0x4a>
    if(t >= all_thread + MAX_THREAD)
  62:	ff05e8e3          	bltu	a1,a6,52 <thread_schedule+0x2c>
      t = all_thread;
  66:	00001597          	auipc	a1,0x1
  6a:	d1258593          	addi	a1,a1,-750 # d78 <all_thread>
  6e:	b7d5                	j	52 <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  70:	00001517          	auipc	a0,0x1
  74:	bc050513          	addi	a0,a0,-1088 # c30 <malloc+0xe4>
  78:	00001097          	auipc	ra,0x1
  7c:	a16080e7          	jalr	-1514(ra) # a8e <printf>
    exit(-1);
  80:	557d                	li	a0,-1
  82:	00000097          	auipc	ra,0x0
  86:	694080e7          	jalr	1684(ra) # 716 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  8a:	02b50263          	beq	a0,a1,ae <thread_schedule+0x88>
    next_thread->state = RUNNING;
  8e:	6789                	lui	a5,0x2
  90:	00f58733          	add	a4,a1,a5
  94:	4685                	li	a3,1
  96:	c314                	sw	a3,0(a4)
    t = current_thread;
    current_thread = next_thread;
  98:	00001717          	auipc	a4,0x1
  9c:	ccb73823          	sd	a1,-816(a4) # d68 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    thread_switch(&t->context,&current_thread->context);
  a0:	07a1                	addi	a5,a5,8
  a2:	95be                	add	a1,a1,a5
  a4:	953e                	add	a0,a0,a5
  a6:	00000097          	auipc	ra,0x0
  aa:	37e080e7          	jalr	894(ra) # 424 <thread_switch>
  } else
        next_thread = 0;
}
  ae:	60a2                	ld	ra,8(sp)
  b0:	6402                	ld	s0,0(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <thread_create>:

void 
thread_create(void (*func)())
{
  b6:	1101                	addi	sp,sp,-32
  b8:	ec06                	sd	ra,24(sp)
  ba:	e822                	sd	s0,16(sp)
  bc:	e426                	sd	s1,8(sp)
  be:	e04a                	sd	s2,0(sp)
  c0:	1000                	addi	s0,sp,32
  c2:	892a                	mv	s2,a0
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c4:	00001517          	auipc	a0,0x1
  c8:	cb450513          	addi	a0,a0,-844 # d78 <all_thread>
    if (t->state == FREE) break;
  cc:	6689                	lui	a3,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  ce:	07868593          	addi	a1,a3,120 # 2078 <__global_pointer$+0xb2f>
  d2:	00009617          	auipc	a2,0x9
  d6:	e8660613          	addi	a2,a2,-378 # 8f58 <base>
    if (t->state == FREE) break;
  da:	00d50733          	add	a4,a0,a3
  de:	4318                	lw	a4,0(a4)
  e0:	c701                	beqz	a4,e8 <thread_create+0x32>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  e2:	952e                	add	a0,a0,a1
  e4:	fec51be3          	bne	a0,a2,da <thread_create+0x24>
  }
  t->state = RUNNABLE;
  e8:	6709                	lui	a4,0x2
  ea:	00e504b3          	add	s1,a0,a4
  ee:	4689                	li	a3,2
  f0:	c094                	sw	a3,0(s1)
  // YOUR CODE HERE
  memset(&t->context, 0, sizeof t->context);
  f2:	0721                	addi	a4,a4,8
  f4:	07000613          	li	a2,112
  f8:	4581                	li	a1,0
  fa:	953a                	add	a0,a0,a4
  fc:	00000097          	auipc	ra,0x0
 100:	41e080e7          	jalr	1054(ra) # 51a <memset>
  t->context.ra = (uint64)func;
 104:	0124b423          	sd	s2,8(s1)
  t->context.sp = (uint64)(t->stack + STACK_SIZE);
 108:	e884                	sd	s1,16(s1)
}
 10a:	60e2                	ld	ra,24(sp)
 10c:	6442                	ld	s0,16(sp)
 10e:	64a2                	ld	s1,8(sp)
 110:	6902                	ld	s2,0(sp)
 112:	6105                	addi	sp,sp,32
 114:	8082                	ret

0000000000000116 <thread_yield>:

void 
thread_yield(void)
{
 116:	1141                	addi	sp,sp,-16
 118:	e406                	sd	ra,8(sp)
 11a:	e022                	sd	s0,0(sp)
 11c:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
 11e:	00001797          	auipc	a5,0x1
 122:	c4a7b783          	ld	a5,-950(a5) # d68 <current_thread>
 126:	6709                	lui	a4,0x2
 128:	97ba                	add	a5,a5,a4
 12a:	4709                	li	a4,2
 12c:	c398                	sw	a4,0(a5)
  thread_schedule();
 12e:	00000097          	auipc	ra,0x0
 132:	ef8080e7          	jalr	-264(ra) # 26 <thread_schedule>
}
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret

000000000000013e <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 13e:	7179                	addi	sp,sp,-48
 140:	f406                	sd	ra,40(sp)
 142:	f022                	sd	s0,32(sp)
 144:	ec26                	sd	s1,24(sp)
 146:	e84a                	sd	s2,16(sp)
 148:	e44e                	sd	s3,8(sp)
 14a:	e052                	sd	s4,0(sp)
 14c:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 14e:	00001517          	auipc	a0,0x1
 152:	b0a50513          	addi	a0,a0,-1270 # c58 <malloc+0x10c>
 156:	00001097          	auipc	ra,0x1
 15a:	938080e7          	jalr	-1736(ra) # a8e <printf>
  a_started = 1;
 15e:	4785                	li	a5,1
 160:	00001717          	auipc	a4,0x1
 164:	c0f72223          	sw	a5,-1020(a4) # d64 <a_started>
  while(b_started == 0 || c_started == 0)
 168:	00001497          	auipc	s1,0x1
 16c:	bf848493          	addi	s1,s1,-1032 # d60 <b_started>
 170:	00001917          	auipc	s2,0x1
 174:	bec90913          	addi	s2,s2,-1044 # d5c <c_started>
 178:	a029                	j	182 <thread_a+0x44>
    thread_yield();
 17a:	00000097          	auipc	ra,0x0
 17e:	f9c080e7          	jalr	-100(ra) # 116 <thread_yield>
  while(b_started == 0 || c_started == 0)
 182:	409c                	lw	a5,0(s1)
 184:	2781                	sext.w	a5,a5
 186:	dbf5                	beqz	a5,17a <thread_a+0x3c>
 188:	00092783          	lw	a5,0(s2)
 18c:	2781                	sext.w	a5,a5
 18e:	d7f5                	beqz	a5,17a <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 190:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 192:	00001a17          	auipc	s4,0x1
 196:	adea0a13          	addi	s4,s4,-1314 # c70 <malloc+0x124>
    a_n += 1;
 19a:	00001917          	auipc	s2,0x1
 19e:	bbe90913          	addi	s2,s2,-1090 # d58 <a_n>
  for (i = 0; i < 100; i++) {
 1a2:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 1a6:	85a6                	mv	a1,s1
 1a8:	8552                	mv	a0,s4
 1aa:	00001097          	auipc	ra,0x1
 1ae:	8e4080e7          	jalr	-1820(ra) # a8e <printf>
    a_n += 1;
 1b2:	00092783          	lw	a5,0(s2)
 1b6:	2785                	addiw	a5,a5,1
 1b8:	00f92023          	sw	a5,0(s2)
    thread_yield();
 1bc:	00000097          	auipc	ra,0x0
 1c0:	f5a080e7          	jalr	-166(ra) # 116 <thread_yield>
  for (i = 0; i < 100; i++) {
 1c4:	2485                	addiw	s1,s1,1
 1c6:	ff3490e3          	bne	s1,s3,1a6 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1ca:	00001597          	auipc	a1,0x1
 1ce:	b8e5a583          	lw	a1,-1138(a1) # d58 <a_n>
 1d2:	00001517          	auipc	a0,0x1
 1d6:	aae50513          	addi	a0,a0,-1362 # c80 <malloc+0x134>
 1da:	00001097          	auipc	ra,0x1
 1de:	8b4080e7          	jalr	-1868(ra) # a8e <printf>

  current_thread->state = FREE;
 1e2:	00001797          	auipc	a5,0x1
 1e6:	b867b783          	ld	a5,-1146(a5) # d68 <current_thread>
 1ea:	6709                	lui	a4,0x2
 1ec:	97ba                	add	a5,a5,a4
 1ee:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1f2:	00000097          	auipc	ra,0x0
 1f6:	e34080e7          	jalr	-460(ra) # 26 <thread_schedule>
}
 1fa:	70a2                	ld	ra,40(sp)
 1fc:	7402                	ld	s0,32(sp)
 1fe:	64e2                	ld	s1,24(sp)
 200:	6942                	ld	s2,16(sp)
 202:	69a2                	ld	s3,8(sp)
 204:	6a02                	ld	s4,0(sp)
 206:	6145                	addi	sp,sp,48
 208:	8082                	ret

000000000000020a <thread_b>:

void 
thread_b(void)
{
 20a:	7179                	addi	sp,sp,-48
 20c:	f406                	sd	ra,40(sp)
 20e:	f022                	sd	s0,32(sp)
 210:	ec26                	sd	s1,24(sp)
 212:	e84a                	sd	s2,16(sp)
 214:	e44e                	sd	s3,8(sp)
 216:	e052                	sd	s4,0(sp)
 218:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 21a:	00001517          	auipc	a0,0x1
 21e:	a8650513          	addi	a0,a0,-1402 # ca0 <malloc+0x154>
 222:	00001097          	auipc	ra,0x1
 226:	86c080e7          	jalr	-1940(ra) # a8e <printf>
  b_started = 1;
 22a:	4785                	li	a5,1
 22c:	00001717          	auipc	a4,0x1
 230:	b2f72a23          	sw	a5,-1228(a4) # d60 <b_started>
  while(a_started == 0 || c_started == 0)
 234:	00001497          	auipc	s1,0x1
 238:	b3048493          	addi	s1,s1,-1232 # d64 <a_started>
 23c:	00001917          	auipc	s2,0x1
 240:	b2090913          	addi	s2,s2,-1248 # d5c <c_started>
 244:	a029                	j	24e <thread_b+0x44>
    thread_yield();
 246:	00000097          	auipc	ra,0x0
 24a:	ed0080e7          	jalr	-304(ra) # 116 <thread_yield>
  while(a_started == 0 || c_started == 0)
 24e:	409c                	lw	a5,0(s1)
 250:	2781                	sext.w	a5,a5
 252:	dbf5                	beqz	a5,246 <thread_b+0x3c>
 254:	00092783          	lw	a5,0(s2)
 258:	2781                	sext.w	a5,a5
 25a:	d7f5                	beqz	a5,246 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 25c:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 25e:	00001a17          	auipc	s4,0x1
 262:	a5aa0a13          	addi	s4,s4,-1446 # cb8 <malloc+0x16c>
    b_n += 1;
 266:	00001917          	auipc	s2,0x1
 26a:	aee90913          	addi	s2,s2,-1298 # d54 <b_n>
  for (i = 0; i < 100; i++) {
 26e:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 272:	85a6                	mv	a1,s1
 274:	8552                	mv	a0,s4
 276:	00001097          	auipc	ra,0x1
 27a:	818080e7          	jalr	-2024(ra) # a8e <printf>
    b_n += 1;
 27e:	00092783          	lw	a5,0(s2)
 282:	2785                	addiw	a5,a5,1
 284:	00f92023          	sw	a5,0(s2)
    thread_yield();
 288:	00000097          	auipc	ra,0x0
 28c:	e8e080e7          	jalr	-370(ra) # 116 <thread_yield>
  for (i = 0; i < 100; i++) {
 290:	2485                	addiw	s1,s1,1
 292:	ff3490e3          	bne	s1,s3,272 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 296:	00001597          	auipc	a1,0x1
 29a:	abe5a583          	lw	a1,-1346(a1) # d54 <b_n>
 29e:	00001517          	auipc	a0,0x1
 2a2:	a2a50513          	addi	a0,a0,-1494 # cc8 <malloc+0x17c>
 2a6:	00000097          	auipc	ra,0x0
 2aa:	7e8080e7          	jalr	2024(ra) # a8e <printf>

  current_thread->state = FREE;
 2ae:	00001797          	auipc	a5,0x1
 2b2:	aba7b783          	ld	a5,-1350(a5) # d68 <current_thread>
 2b6:	6709                	lui	a4,0x2
 2b8:	97ba                	add	a5,a5,a4
 2ba:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 2be:	00000097          	auipc	ra,0x0
 2c2:	d68080e7          	jalr	-664(ra) # 26 <thread_schedule>
}
 2c6:	70a2                	ld	ra,40(sp)
 2c8:	7402                	ld	s0,32(sp)
 2ca:	64e2                	ld	s1,24(sp)
 2cc:	6942                	ld	s2,16(sp)
 2ce:	69a2                	ld	s3,8(sp)
 2d0:	6a02                	ld	s4,0(sp)
 2d2:	6145                	addi	sp,sp,48
 2d4:	8082                	ret

00000000000002d6 <thread_c>:

void 
thread_c(void)
{
 2d6:	7179                	addi	sp,sp,-48
 2d8:	f406                	sd	ra,40(sp)
 2da:	f022                	sd	s0,32(sp)
 2dc:	ec26                	sd	s1,24(sp)
 2de:	e84a                	sd	s2,16(sp)
 2e0:	e44e                	sd	s3,8(sp)
 2e2:	e052                	sd	s4,0(sp)
 2e4:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2e6:	00001517          	auipc	a0,0x1
 2ea:	a0250513          	addi	a0,a0,-1534 # ce8 <malloc+0x19c>
 2ee:	00000097          	auipc	ra,0x0
 2f2:	7a0080e7          	jalr	1952(ra) # a8e <printf>
  c_started = 1;
 2f6:	4785                	li	a5,1
 2f8:	00001717          	auipc	a4,0x1
 2fc:	a6f72223          	sw	a5,-1436(a4) # d5c <c_started>
  while(a_started == 0 || b_started == 0)
 300:	00001497          	auipc	s1,0x1
 304:	a6448493          	addi	s1,s1,-1436 # d64 <a_started>
 308:	00001917          	auipc	s2,0x1
 30c:	a5890913          	addi	s2,s2,-1448 # d60 <b_started>
 310:	a029                	j	31a <thread_c+0x44>
    thread_yield();
 312:	00000097          	auipc	ra,0x0
 316:	e04080e7          	jalr	-508(ra) # 116 <thread_yield>
  while(a_started == 0 || b_started == 0)
 31a:	409c                	lw	a5,0(s1)
 31c:	2781                	sext.w	a5,a5
 31e:	dbf5                	beqz	a5,312 <thread_c+0x3c>
 320:	00092783          	lw	a5,0(s2)
 324:	2781                	sext.w	a5,a5
 326:	d7f5                	beqz	a5,312 <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 328:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 32a:	00001a17          	auipc	s4,0x1
 32e:	9d6a0a13          	addi	s4,s4,-1578 # d00 <malloc+0x1b4>
    c_n += 1;
 332:	00001917          	auipc	s2,0x1
 336:	a1e90913          	addi	s2,s2,-1506 # d50 <c_n>
  for (i = 0; i < 100; i++) {
 33a:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 33e:	85a6                	mv	a1,s1
 340:	8552                	mv	a0,s4
 342:	00000097          	auipc	ra,0x0
 346:	74c080e7          	jalr	1868(ra) # a8e <printf>
    c_n += 1;
 34a:	00092783          	lw	a5,0(s2)
 34e:	2785                	addiw	a5,a5,1
 350:	00f92023          	sw	a5,0(s2)
    thread_yield();
 354:	00000097          	auipc	ra,0x0
 358:	dc2080e7          	jalr	-574(ra) # 116 <thread_yield>
  for (i = 0; i < 100; i++) {
 35c:	2485                	addiw	s1,s1,1
 35e:	ff3490e3          	bne	s1,s3,33e <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 362:	00001597          	auipc	a1,0x1
 366:	9ee5a583          	lw	a1,-1554(a1) # d50 <c_n>
 36a:	00001517          	auipc	a0,0x1
 36e:	9a650513          	addi	a0,a0,-1626 # d10 <malloc+0x1c4>
 372:	00000097          	auipc	ra,0x0
 376:	71c080e7          	jalr	1820(ra) # a8e <printf>

  current_thread->state = FREE;
 37a:	00001797          	auipc	a5,0x1
 37e:	9ee7b783          	ld	a5,-1554(a5) # d68 <current_thread>
 382:	6709                	lui	a4,0x2
 384:	97ba                	add	a5,a5,a4
 386:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 38a:	00000097          	auipc	ra,0x0
 38e:	c9c080e7          	jalr	-868(ra) # 26 <thread_schedule>
}
 392:	70a2                	ld	ra,40(sp)
 394:	7402                	ld	s0,32(sp)
 396:	64e2                	ld	s1,24(sp)
 398:	6942                	ld	s2,16(sp)
 39a:	69a2                	ld	s3,8(sp)
 39c:	6a02                	ld	s4,0(sp)
 39e:	6145                	addi	sp,sp,48
 3a0:	8082                	ret

00000000000003a2 <main>:

int 
main(int argc, char *argv[]) 
{
 3a2:	1141                	addi	sp,sp,-16
 3a4:	e406                	sd	ra,8(sp)
 3a6:	e022                	sd	s0,0(sp)
 3a8:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 3aa:	00001797          	auipc	a5,0x1
 3ae:	9a07a923          	sw	zero,-1614(a5) # d5c <c_started>
 3b2:	00001797          	auipc	a5,0x1
 3b6:	9a07a723          	sw	zero,-1618(a5) # d60 <b_started>
 3ba:	00001797          	auipc	a5,0x1
 3be:	9a07a523          	sw	zero,-1622(a5) # d64 <a_started>
  a_n = b_n = c_n = 0;
 3c2:	00001797          	auipc	a5,0x1
 3c6:	9807a723          	sw	zero,-1650(a5) # d50 <c_n>
 3ca:	00001797          	auipc	a5,0x1
 3ce:	9807a523          	sw	zero,-1654(a5) # d54 <b_n>
 3d2:	00001797          	auipc	a5,0x1
 3d6:	9807a323          	sw	zero,-1658(a5) # d58 <a_n>
  thread_init();
 3da:	00000097          	auipc	ra,0x0
 3de:	c26080e7          	jalr	-986(ra) # 0 <thread_init>
  thread_create(thread_a);
 3e2:	00000517          	auipc	a0,0x0
 3e6:	d5c50513          	addi	a0,a0,-676 # 13e <thread_a>
 3ea:	00000097          	auipc	ra,0x0
 3ee:	ccc080e7          	jalr	-820(ra) # b6 <thread_create>
  thread_create(thread_b);
 3f2:	00000517          	auipc	a0,0x0
 3f6:	e1850513          	addi	a0,a0,-488 # 20a <thread_b>
 3fa:	00000097          	auipc	ra,0x0
 3fe:	cbc080e7          	jalr	-836(ra) # b6 <thread_create>
  thread_create(thread_c);
 402:	00000517          	auipc	a0,0x0
 406:	ed450513          	addi	a0,a0,-300 # 2d6 <thread_c>
 40a:	00000097          	auipc	ra,0x0
 40e:	cac080e7          	jalr	-852(ra) # b6 <thread_create>
  thread_schedule();
 412:	00000097          	auipc	ra,0x0
 416:	c14080e7          	jalr	-1004(ra) # 26 <thread_schedule>
  exit(0);
 41a:	4501                	li	a0,0
 41c:	00000097          	auipc	ra,0x0
 420:	2fa080e7          	jalr	762(ra) # 716 <exit>

0000000000000424 <thread_switch>:
         */

	.globl thread_switch
thread_switch:
        /* YOUR CODE HERE */
        sd ra, 0(a0)
 424:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
 428:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
 42c:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
 42e:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
 430:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
 434:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
 438:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
 43c:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
 440:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
 444:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
 448:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
 44c:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
 450:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
 454:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
 458:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
 45c:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
 460:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
 462:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
 464:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
 468:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
 46c:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
 470:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
 474:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
 478:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
 47c:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
 480:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
 484:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
 488:	0685bd83          	ld	s11,104(a1)
	ret    /* return to ra */
 48c:	8082                	ret

000000000000048e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 48e:	1141                	addi	sp,sp,-16
 490:	e406                	sd	ra,8(sp)
 492:	e022                	sd	s0,0(sp)
 494:	0800                	addi	s0,sp,16
  extern int main();
  main();
 496:	00000097          	auipc	ra,0x0
 49a:	f0c080e7          	jalr	-244(ra) # 3a2 <main>
  exit(0);
 49e:	4501                	li	a0,0
 4a0:	00000097          	auipc	ra,0x0
 4a4:	276080e7          	jalr	630(ra) # 716 <exit>

00000000000004a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 4a8:	1141                	addi	sp,sp,-16
 4aa:	e422                	sd	s0,8(sp)
 4ac:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4ae:	87aa                	mv	a5,a0
 4b0:	0585                	addi	a1,a1,1
 4b2:	0785                	addi	a5,a5,1
 4b4:	fff5c703          	lbu	a4,-1(a1)
 4b8:	fee78fa3          	sb	a4,-1(a5)
 4bc:	fb75                	bnez	a4,4b0 <strcpy+0x8>
    ;
  return os;
}
 4be:	6422                	ld	s0,8(sp)
 4c0:	0141                	addi	sp,sp,16
 4c2:	8082                	ret

00000000000004c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4c4:	1141                	addi	sp,sp,-16
 4c6:	e422                	sd	s0,8(sp)
 4c8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4ca:	00054783          	lbu	a5,0(a0)
 4ce:	cb91                	beqz	a5,4e2 <strcmp+0x1e>
 4d0:	0005c703          	lbu	a4,0(a1)
 4d4:	00f71763          	bne	a4,a5,4e2 <strcmp+0x1e>
    p++, q++;
 4d8:	0505                	addi	a0,a0,1
 4da:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4dc:	00054783          	lbu	a5,0(a0)
 4e0:	fbe5                	bnez	a5,4d0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4e2:	0005c503          	lbu	a0,0(a1)
}
 4e6:	40a7853b          	subw	a0,a5,a0
 4ea:	6422                	ld	s0,8(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret

00000000000004f0 <strlen>:

uint
strlen(const char *s)
{
 4f0:	1141                	addi	sp,sp,-16
 4f2:	e422                	sd	s0,8(sp)
 4f4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4f6:	00054783          	lbu	a5,0(a0)
 4fa:	cf91                	beqz	a5,516 <strlen+0x26>
 4fc:	0505                	addi	a0,a0,1
 4fe:	87aa                	mv	a5,a0
 500:	4685                	li	a3,1
 502:	9e89                	subw	a3,a3,a0
 504:	00f6853b          	addw	a0,a3,a5
 508:	0785                	addi	a5,a5,1
 50a:	fff7c703          	lbu	a4,-1(a5)
 50e:	fb7d                	bnez	a4,504 <strlen+0x14>
    ;
  return n;
}
 510:	6422                	ld	s0,8(sp)
 512:	0141                	addi	sp,sp,16
 514:	8082                	ret
  for(n = 0; s[n]; n++)
 516:	4501                	li	a0,0
 518:	bfe5                	j	510 <strlen+0x20>

000000000000051a <memset>:

void*
memset(void *dst, int c, uint n)
{
 51a:	1141                	addi	sp,sp,-16
 51c:	e422                	sd	s0,8(sp)
 51e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 520:	ca19                	beqz	a2,536 <memset+0x1c>
 522:	87aa                	mv	a5,a0
 524:	1602                	slli	a2,a2,0x20
 526:	9201                	srli	a2,a2,0x20
 528:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 52c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 530:	0785                	addi	a5,a5,1
 532:	fee79de3          	bne	a5,a4,52c <memset+0x12>
  }
  return dst;
}
 536:	6422                	ld	s0,8(sp)
 538:	0141                	addi	sp,sp,16
 53a:	8082                	ret

000000000000053c <strchr>:

char*
strchr(const char *s, char c)
{
 53c:	1141                	addi	sp,sp,-16
 53e:	e422                	sd	s0,8(sp)
 540:	0800                	addi	s0,sp,16
  for(; *s; s++)
 542:	00054783          	lbu	a5,0(a0)
 546:	cb99                	beqz	a5,55c <strchr+0x20>
    if(*s == c)
 548:	00f58763          	beq	a1,a5,556 <strchr+0x1a>
  for(; *s; s++)
 54c:	0505                	addi	a0,a0,1
 54e:	00054783          	lbu	a5,0(a0)
 552:	fbfd                	bnez	a5,548 <strchr+0xc>
      return (char*)s;
  return 0;
 554:	4501                	li	a0,0
}
 556:	6422                	ld	s0,8(sp)
 558:	0141                	addi	sp,sp,16
 55a:	8082                	ret
  return 0;
 55c:	4501                	li	a0,0
 55e:	bfe5                	j	556 <strchr+0x1a>

0000000000000560 <gets>:

char*
gets(char *buf, int max)
{
 560:	711d                	addi	sp,sp,-96
 562:	ec86                	sd	ra,88(sp)
 564:	e8a2                	sd	s0,80(sp)
 566:	e4a6                	sd	s1,72(sp)
 568:	e0ca                	sd	s2,64(sp)
 56a:	fc4e                	sd	s3,56(sp)
 56c:	f852                	sd	s4,48(sp)
 56e:	f456                	sd	s5,40(sp)
 570:	f05a                	sd	s6,32(sp)
 572:	ec5e                	sd	s7,24(sp)
 574:	1080                	addi	s0,sp,96
 576:	8baa                	mv	s7,a0
 578:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 57a:	892a                	mv	s2,a0
 57c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 57e:	4aa9                	li	s5,10
 580:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 582:	89a6                	mv	s3,s1
 584:	2485                	addiw	s1,s1,1
 586:	0344d863          	bge	s1,s4,5b6 <gets+0x56>
    cc = read(0, &c, 1);
 58a:	4605                	li	a2,1
 58c:	faf40593          	addi	a1,s0,-81
 590:	4501                	li	a0,0
 592:	00000097          	auipc	ra,0x0
 596:	19c080e7          	jalr	412(ra) # 72e <read>
    if(cc < 1)
 59a:	00a05e63          	blez	a0,5b6 <gets+0x56>
    buf[i++] = c;
 59e:	faf44783          	lbu	a5,-81(s0)
 5a2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5a6:	01578763          	beq	a5,s5,5b4 <gets+0x54>
 5aa:	0905                	addi	s2,s2,1
 5ac:	fd679be3          	bne	a5,s6,582 <gets+0x22>
  for(i=0; i+1 < max; ){
 5b0:	89a6                	mv	s3,s1
 5b2:	a011                	j	5b6 <gets+0x56>
 5b4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5b6:	99de                	add	s3,s3,s7
 5b8:	00098023          	sb	zero,0(s3)
  return buf;
}
 5bc:	855e                	mv	a0,s7
 5be:	60e6                	ld	ra,88(sp)
 5c0:	6446                	ld	s0,80(sp)
 5c2:	64a6                	ld	s1,72(sp)
 5c4:	6906                	ld	s2,64(sp)
 5c6:	79e2                	ld	s3,56(sp)
 5c8:	7a42                	ld	s4,48(sp)
 5ca:	7aa2                	ld	s5,40(sp)
 5cc:	7b02                	ld	s6,32(sp)
 5ce:	6be2                	ld	s7,24(sp)
 5d0:	6125                	addi	sp,sp,96
 5d2:	8082                	ret

00000000000005d4 <stat>:

int
stat(const char *n, struct stat *st)
{
 5d4:	1101                	addi	sp,sp,-32
 5d6:	ec06                	sd	ra,24(sp)
 5d8:	e822                	sd	s0,16(sp)
 5da:	e426                	sd	s1,8(sp)
 5dc:	e04a                	sd	s2,0(sp)
 5de:	1000                	addi	s0,sp,32
 5e0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5e2:	4581                	li	a1,0
 5e4:	00000097          	auipc	ra,0x0
 5e8:	172080e7          	jalr	370(ra) # 756 <open>
  if(fd < 0)
 5ec:	02054563          	bltz	a0,616 <stat+0x42>
 5f0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5f2:	85ca                	mv	a1,s2
 5f4:	00000097          	auipc	ra,0x0
 5f8:	17a080e7          	jalr	378(ra) # 76e <fstat>
 5fc:	892a                	mv	s2,a0
  close(fd);
 5fe:	8526                	mv	a0,s1
 600:	00000097          	auipc	ra,0x0
 604:	13e080e7          	jalr	318(ra) # 73e <close>
  return r;
}
 608:	854a                	mv	a0,s2
 60a:	60e2                	ld	ra,24(sp)
 60c:	6442                	ld	s0,16(sp)
 60e:	64a2                	ld	s1,8(sp)
 610:	6902                	ld	s2,0(sp)
 612:	6105                	addi	sp,sp,32
 614:	8082                	ret
    return -1;
 616:	597d                	li	s2,-1
 618:	bfc5                	j	608 <stat+0x34>

000000000000061a <atoi>:

int
atoi(const char *s)
{
 61a:	1141                	addi	sp,sp,-16
 61c:	e422                	sd	s0,8(sp)
 61e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 620:	00054603          	lbu	a2,0(a0)
 624:	fd06079b          	addiw	a5,a2,-48
 628:	0ff7f793          	andi	a5,a5,255
 62c:	4725                	li	a4,9
 62e:	02f76963          	bltu	a4,a5,660 <atoi+0x46>
 632:	86aa                	mv	a3,a0
  n = 0;
 634:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 636:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 638:	0685                	addi	a3,a3,1
 63a:	0025179b          	slliw	a5,a0,0x2
 63e:	9fa9                	addw	a5,a5,a0
 640:	0017979b          	slliw	a5,a5,0x1
 644:	9fb1                	addw	a5,a5,a2
 646:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 64a:	0006c603          	lbu	a2,0(a3)
 64e:	fd06071b          	addiw	a4,a2,-48
 652:	0ff77713          	andi	a4,a4,255
 656:	fee5f1e3          	bgeu	a1,a4,638 <atoi+0x1e>
  return n;
}
 65a:	6422                	ld	s0,8(sp)
 65c:	0141                	addi	sp,sp,16
 65e:	8082                	ret
  n = 0;
 660:	4501                	li	a0,0
 662:	bfe5                	j	65a <atoi+0x40>

0000000000000664 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 664:	1141                	addi	sp,sp,-16
 666:	e422                	sd	s0,8(sp)
 668:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 66a:	02b57463          	bgeu	a0,a1,692 <memmove+0x2e>
    while(n-- > 0)
 66e:	00c05f63          	blez	a2,68c <memmove+0x28>
 672:	1602                	slli	a2,a2,0x20
 674:	9201                	srli	a2,a2,0x20
 676:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 67a:	872a                	mv	a4,a0
      *dst++ = *src++;
 67c:	0585                	addi	a1,a1,1
 67e:	0705                	addi	a4,a4,1
 680:	fff5c683          	lbu	a3,-1(a1)
 684:	fed70fa3          	sb	a3,-1(a4) # 1fff <__global_pointer$+0xab6>
    while(n-- > 0)
 688:	fee79ae3          	bne	a5,a4,67c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 68c:	6422                	ld	s0,8(sp)
 68e:	0141                	addi	sp,sp,16
 690:	8082                	ret
    dst += n;
 692:	00c50733          	add	a4,a0,a2
    src += n;
 696:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 698:	fec05ae3          	blez	a2,68c <memmove+0x28>
 69c:	fff6079b          	addiw	a5,a2,-1
 6a0:	1782                	slli	a5,a5,0x20
 6a2:	9381                	srli	a5,a5,0x20
 6a4:	fff7c793          	not	a5,a5
 6a8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6aa:	15fd                	addi	a1,a1,-1
 6ac:	177d                	addi	a4,a4,-1
 6ae:	0005c683          	lbu	a3,0(a1)
 6b2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6b6:	fee79ae3          	bne	a5,a4,6aa <memmove+0x46>
 6ba:	bfc9                	j	68c <memmove+0x28>

00000000000006bc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6bc:	1141                	addi	sp,sp,-16
 6be:	e422                	sd	s0,8(sp)
 6c0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6c2:	ca05                	beqz	a2,6f2 <memcmp+0x36>
 6c4:	fff6069b          	addiw	a3,a2,-1
 6c8:	1682                	slli	a3,a3,0x20
 6ca:	9281                	srli	a3,a3,0x20
 6cc:	0685                	addi	a3,a3,1
 6ce:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6d0:	00054783          	lbu	a5,0(a0)
 6d4:	0005c703          	lbu	a4,0(a1)
 6d8:	00e79863          	bne	a5,a4,6e8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6dc:	0505                	addi	a0,a0,1
    p2++;
 6de:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6e0:	fed518e3          	bne	a0,a3,6d0 <memcmp+0x14>
  }
  return 0;
 6e4:	4501                	li	a0,0
 6e6:	a019                	j	6ec <memcmp+0x30>
      return *p1 - *p2;
 6e8:	40e7853b          	subw	a0,a5,a4
}
 6ec:	6422                	ld	s0,8(sp)
 6ee:	0141                	addi	sp,sp,16
 6f0:	8082                	ret
  return 0;
 6f2:	4501                	li	a0,0
 6f4:	bfe5                	j	6ec <memcmp+0x30>

00000000000006f6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6f6:	1141                	addi	sp,sp,-16
 6f8:	e406                	sd	ra,8(sp)
 6fa:	e022                	sd	s0,0(sp)
 6fc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6fe:	00000097          	auipc	ra,0x0
 702:	f66080e7          	jalr	-154(ra) # 664 <memmove>
}
 706:	60a2                	ld	ra,8(sp)
 708:	6402                	ld	s0,0(sp)
 70a:	0141                	addi	sp,sp,16
 70c:	8082                	ret

000000000000070e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 70e:	4885                	li	a7,1
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <exit>:
.global exit
exit:
 li a7, SYS_exit
 716:	4889                	li	a7,2
 ecall
 718:	00000073          	ecall
 ret
 71c:	8082                	ret

000000000000071e <wait>:
.global wait
wait:
 li a7, SYS_wait
 71e:	488d                	li	a7,3
 ecall
 720:	00000073          	ecall
 ret
 724:	8082                	ret

0000000000000726 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 726:	4891                	li	a7,4
 ecall
 728:	00000073          	ecall
 ret
 72c:	8082                	ret

000000000000072e <read>:
.global read
read:
 li a7, SYS_read
 72e:	4895                	li	a7,5
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <write>:
.global write
write:
 li a7, SYS_write
 736:	48c1                	li	a7,16
 ecall
 738:	00000073          	ecall
 ret
 73c:	8082                	ret

000000000000073e <close>:
.global close
close:
 li a7, SYS_close
 73e:	48d5                	li	a7,21
 ecall
 740:	00000073          	ecall
 ret
 744:	8082                	ret

0000000000000746 <kill>:
.global kill
kill:
 li a7, SYS_kill
 746:	4899                	li	a7,6
 ecall
 748:	00000073          	ecall
 ret
 74c:	8082                	ret

000000000000074e <exec>:
.global exec
exec:
 li a7, SYS_exec
 74e:	489d                	li	a7,7
 ecall
 750:	00000073          	ecall
 ret
 754:	8082                	ret

0000000000000756 <open>:
.global open
open:
 li a7, SYS_open
 756:	48bd                	li	a7,15
 ecall
 758:	00000073          	ecall
 ret
 75c:	8082                	ret

000000000000075e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 75e:	48c5                	li	a7,17
 ecall
 760:	00000073          	ecall
 ret
 764:	8082                	ret

0000000000000766 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 766:	48c9                	li	a7,18
 ecall
 768:	00000073          	ecall
 ret
 76c:	8082                	ret

000000000000076e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 76e:	48a1                	li	a7,8
 ecall
 770:	00000073          	ecall
 ret
 774:	8082                	ret

0000000000000776 <link>:
.global link
link:
 li a7, SYS_link
 776:	48cd                	li	a7,19
 ecall
 778:	00000073          	ecall
 ret
 77c:	8082                	ret

000000000000077e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 77e:	48d1                	li	a7,20
 ecall
 780:	00000073          	ecall
 ret
 784:	8082                	ret

0000000000000786 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 786:	48a5                	li	a7,9
 ecall
 788:	00000073          	ecall
 ret
 78c:	8082                	ret

000000000000078e <dup>:
.global dup
dup:
 li a7, SYS_dup
 78e:	48a9                	li	a7,10
 ecall
 790:	00000073          	ecall
 ret
 794:	8082                	ret

0000000000000796 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 796:	48ad                	li	a7,11
 ecall
 798:	00000073          	ecall
 ret
 79c:	8082                	ret

000000000000079e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 79e:	48b1                	li	a7,12
 ecall
 7a0:	00000073          	ecall
 ret
 7a4:	8082                	ret

00000000000007a6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7a6:	48b5                	li	a7,13
 ecall
 7a8:	00000073          	ecall
 ret
 7ac:	8082                	ret

00000000000007ae <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7ae:	48b9                	li	a7,14
 ecall
 7b0:	00000073          	ecall
 ret
 7b4:	8082                	ret

00000000000007b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7b6:	1101                	addi	sp,sp,-32
 7b8:	ec06                	sd	ra,24(sp)
 7ba:	e822                	sd	s0,16(sp)
 7bc:	1000                	addi	s0,sp,32
 7be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7c2:	4605                	li	a2,1
 7c4:	fef40593          	addi	a1,s0,-17
 7c8:	00000097          	auipc	ra,0x0
 7cc:	f6e080e7          	jalr	-146(ra) # 736 <write>
}
 7d0:	60e2                	ld	ra,24(sp)
 7d2:	6442                	ld	s0,16(sp)
 7d4:	6105                	addi	sp,sp,32
 7d6:	8082                	ret

00000000000007d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7d8:	7139                	addi	sp,sp,-64
 7da:	fc06                	sd	ra,56(sp)
 7dc:	f822                	sd	s0,48(sp)
 7de:	f426                	sd	s1,40(sp)
 7e0:	f04a                	sd	s2,32(sp)
 7e2:	ec4e                	sd	s3,24(sp)
 7e4:	0080                	addi	s0,sp,64
 7e6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7e8:	c299                	beqz	a3,7ee <printint+0x16>
 7ea:	0805c863          	bltz	a1,87a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7ee:	2581                	sext.w	a1,a1
  neg = 0;
 7f0:	4881                	li	a7,0
 7f2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7f6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7f8:	2601                	sext.w	a2,a2
 7fa:	00000517          	auipc	a0,0x0
 7fe:	53e50513          	addi	a0,a0,1342 # d38 <digits>
 802:	883a                	mv	a6,a4
 804:	2705                	addiw	a4,a4,1
 806:	02c5f7bb          	remuw	a5,a1,a2
 80a:	1782                	slli	a5,a5,0x20
 80c:	9381                	srli	a5,a5,0x20
 80e:	97aa                	add	a5,a5,a0
 810:	0007c783          	lbu	a5,0(a5)
 814:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 818:	0005879b          	sext.w	a5,a1
 81c:	02c5d5bb          	divuw	a1,a1,a2
 820:	0685                	addi	a3,a3,1
 822:	fec7f0e3          	bgeu	a5,a2,802 <printint+0x2a>
  if(neg)
 826:	00088b63          	beqz	a7,83c <printint+0x64>
    buf[i++] = '-';
 82a:	fd040793          	addi	a5,s0,-48
 82e:	973e                	add	a4,a4,a5
 830:	02d00793          	li	a5,45
 834:	fef70823          	sb	a5,-16(a4)
 838:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 83c:	02e05863          	blez	a4,86c <printint+0x94>
 840:	fc040793          	addi	a5,s0,-64
 844:	00e78933          	add	s2,a5,a4
 848:	fff78993          	addi	s3,a5,-1
 84c:	99ba                	add	s3,s3,a4
 84e:	377d                	addiw	a4,a4,-1
 850:	1702                	slli	a4,a4,0x20
 852:	9301                	srli	a4,a4,0x20
 854:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 858:	fff94583          	lbu	a1,-1(s2)
 85c:	8526                	mv	a0,s1
 85e:	00000097          	auipc	ra,0x0
 862:	f58080e7          	jalr	-168(ra) # 7b6 <putc>
  while(--i >= 0)
 866:	197d                	addi	s2,s2,-1
 868:	ff3918e3          	bne	s2,s3,858 <printint+0x80>
}
 86c:	70e2                	ld	ra,56(sp)
 86e:	7442                	ld	s0,48(sp)
 870:	74a2                	ld	s1,40(sp)
 872:	7902                	ld	s2,32(sp)
 874:	69e2                	ld	s3,24(sp)
 876:	6121                	addi	sp,sp,64
 878:	8082                	ret
    x = -xx;
 87a:	40b005bb          	negw	a1,a1
    neg = 1;
 87e:	4885                	li	a7,1
    x = -xx;
 880:	bf8d                	j	7f2 <printint+0x1a>

0000000000000882 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 882:	7119                	addi	sp,sp,-128
 884:	fc86                	sd	ra,120(sp)
 886:	f8a2                	sd	s0,112(sp)
 888:	f4a6                	sd	s1,104(sp)
 88a:	f0ca                	sd	s2,96(sp)
 88c:	ecce                	sd	s3,88(sp)
 88e:	e8d2                	sd	s4,80(sp)
 890:	e4d6                	sd	s5,72(sp)
 892:	e0da                	sd	s6,64(sp)
 894:	fc5e                	sd	s7,56(sp)
 896:	f862                	sd	s8,48(sp)
 898:	f466                	sd	s9,40(sp)
 89a:	f06a                	sd	s10,32(sp)
 89c:	ec6e                	sd	s11,24(sp)
 89e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8a0:	0005c903          	lbu	s2,0(a1)
 8a4:	18090f63          	beqz	s2,a42 <vprintf+0x1c0>
 8a8:	8aaa                	mv	s5,a0
 8aa:	8b32                	mv	s6,a2
 8ac:	00158493          	addi	s1,a1,1
  state = 0;
 8b0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8b2:	02500a13          	li	s4,37
      if(c == 'd'){
 8b6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 8ba:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 8be:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 8c2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8c6:	00000b97          	auipc	s7,0x0
 8ca:	472b8b93          	addi	s7,s7,1138 # d38 <digits>
 8ce:	a839                	j	8ec <vprintf+0x6a>
        putc(fd, c);
 8d0:	85ca                	mv	a1,s2
 8d2:	8556                	mv	a0,s5
 8d4:	00000097          	auipc	ra,0x0
 8d8:	ee2080e7          	jalr	-286(ra) # 7b6 <putc>
 8dc:	a019                	j	8e2 <vprintf+0x60>
    } else if(state == '%'){
 8de:	01498f63          	beq	s3,s4,8fc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 8e2:	0485                	addi	s1,s1,1
 8e4:	fff4c903          	lbu	s2,-1(s1)
 8e8:	14090d63          	beqz	s2,a42 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 8ec:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8f0:	fe0997e3          	bnez	s3,8de <vprintf+0x5c>
      if(c == '%'){
 8f4:	fd479ee3          	bne	a5,s4,8d0 <vprintf+0x4e>
        state = '%';
 8f8:	89be                	mv	s3,a5
 8fa:	b7e5                	j	8e2 <vprintf+0x60>
      if(c == 'd'){
 8fc:	05878063          	beq	a5,s8,93c <vprintf+0xba>
      } else if(c == 'l') {
 900:	05978c63          	beq	a5,s9,958 <vprintf+0xd6>
      } else if(c == 'x') {
 904:	07a78863          	beq	a5,s10,974 <vprintf+0xf2>
      } else if(c == 'p') {
 908:	09b78463          	beq	a5,s11,990 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 90c:	07300713          	li	a4,115
 910:	0ce78663          	beq	a5,a4,9dc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 914:	06300713          	li	a4,99
 918:	0ee78e63          	beq	a5,a4,a14 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 91c:	11478863          	beq	a5,s4,a2c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 920:	85d2                	mv	a1,s4
 922:	8556                	mv	a0,s5
 924:	00000097          	auipc	ra,0x0
 928:	e92080e7          	jalr	-366(ra) # 7b6 <putc>
        putc(fd, c);
 92c:	85ca                	mv	a1,s2
 92e:	8556                	mv	a0,s5
 930:	00000097          	auipc	ra,0x0
 934:	e86080e7          	jalr	-378(ra) # 7b6 <putc>
      }
      state = 0;
 938:	4981                	li	s3,0
 93a:	b765                	j	8e2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 93c:	008b0913          	addi	s2,s6,8
 940:	4685                	li	a3,1
 942:	4629                	li	a2,10
 944:	000b2583          	lw	a1,0(s6)
 948:	8556                	mv	a0,s5
 94a:	00000097          	auipc	ra,0x0
 94e:	e8e080e7          	jalr	-370(ra) # 7d8 <printint>
 952:	8b4a                	mv	s6,s2
      state = 0;
 954:	4981                	li	s3,0
 956:	b771                	j	8e2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 958:	008b0913          	addi	s2,s6,8
 95c:	4681                	li	a3,0
 95e:	4629                	li	a2,10
 960:	000b2583          	lw	a1,0(s6)
 964:	8556                	mv	a0,s5
 966:	00000097          	auipc	ra,0x0
 96a:	e72080e7          	jalr	-398(ra) # 7d8 <printint>
 96e:	8b4a                	mv	s6,s2
      state = 0;
 970:	4981                	li	s3,0
 972:	bf85                	j	8e2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 974:	008b0913          	addi	s2,s6,8
 978:	4681                	li	a3,0
 97a:	4641                	li	a2,16
 97c:	000b2583          	lw	a1,0(s6)
 980:	8556                	mv	a0,s5
 982:	00000097          	auipc	ra,0x0
 986:	e56080e7          	jalr	-426(ra) # 7d8 <printint>
 98a:	8b4a                	mv	s6,s2
      state = 0;
 98c:	4981                	li	s3,0
 98e:	bf91                	j	8e2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 990:	008b0793          	addi	a5,s6,8
 994:	f8f43423          	sd	a5,-120(s0)
 998:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 99c:	03000593          	li	a1,48
 9a0:	8556                	mv	a0,s5
 9a2:	00000097          	auipc	ra,0x0
 9a6:	e14080e7          	jalr	-492(ra) # 7b6 <putc>
  putc(fd, 'x');
 9aa:	85ea                	mv	a1,s10
 9ac:	8556                	mv	a0,s5
 9ae:	00000097          	auipc	ra,0x0
 9b2:	e08080e7          	jalr	-504(ra) # 7b6 <putc>
 9b6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9b8:	03c9d793          	srli	a5,s3,0x3c
 9bc:	97de                	add	a5,a5,s7
 9be:	0007c583          	lbu	a1,0(a5)
 9c2:	8556                	mv	a0,s5
 9c4:	00000097          	auipc	ra,0x0
 9c8:	df2080e7          	jalr	-526(ra) # 7b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9cc:	0992                	slli	s3,s3,0x4
 9ce:	397d                	addiw	s2,s2,-1
 9d0:	fe0914e3          	bnez	s2,9b8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 9d4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9d8:	4981                	li	s3,0
 9da:	b721                	j	8e2 <vprintf+0x60>
        s = va_arg(ap, char*);
 9dc:	008b0993          	addi	s3,s6,8
 9e0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 9e4:	02090163          	beqz	s2,a06 <vprintf+0x184>
        while(*s != 0){
 9e8:	00094583          	lbu	a1,0(s2)
 9ec:	c9a1                	beqz	a1,a3c <vprintf+0x1ba>
          putc(fd, *s);
 9ee:	8556                	mv	a0,s5
 9f0:	00000097          	auipc	ra,0x0
 9f4:	dc6080e7          	jalr	-570(ra) # 7b6 <putc>
          s++;
 9f8:	0905                	addi	s2,s2,1
        while(*s != 0){
 9fa:	00094583          	lbu	a1,0(s2)
 9fe:	f9e5                	bnez	a1,9ee <vprintf+0x16c>
        s = va_arg(ap, char*);
 a00:	8b4e                	mv	s6,s3
      state = 0;
 a02:	4981                	li	s3,0
 a04:	bdf9                	j	8e2 <vprintf+0x60>
          s = "(null)";
 a06:	00000917          	auipc	s2,0x0
 a0a:	32a90913          	addi	s2,s2,810 # d30 <malloc+0x1e4>
        while(*s != 0){
 a0e:	02800593          	li	a1,40
 a12:	bff1                	j	9ee <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 a14:	008b0913          	addi	s2,s6,8
 a18:	000b4583          	lbu	a1,0(s6)
 a1c:	8556                	mv	a0,s5
 a1e:	00000097          	auipc	ra,0x0
 a22:	d98080e7          	jalr	-616(ra) # 7b6 <putc>
 a26:	8b4a                	mv	s6,s2
      state = 0;
 a28:	4981                	li	s3,0
 a2a:	bd65                	j	8e2 <vprintf+0x60>
        putc(fd, c);
 a2c:	85d2                	mv	a1,s4
 a2e:	8556                	mv	a0,s5
 a30:	00000097          	auipc	ra,0x0
 a34:	d86080e7          	jalr	-634(ra) # 7b6 <putc>
      state = 0;
 a38:	4981                	li	s3,0
 a3a:	b565                	j	8e2 <vprintf+0x60>
        s = va_arg(ap, char*);
 a3c:	8b4e                	mv	s6,s3
      state = 0;
 a3e:	4981                	li	s3,0
 a40:	b54d                	j	8e2 <vprintf+0x60>
    }
  }
}
 a42:	70e6                	ld	ra,120(sp)
 a44:	7446                	ld	s0,112(sp)
 a46:	74a6                	ld	s1,104(sp)
 a48:	7906                	ld	s2,96(sp)
 a4a:	69e6                	ld	s3,88(sp)
 a4c:	6a46                	ld	s4,80(sp)
 a4e:	6aa6                	ld	s5,72(sp)
 a50:	6b06                	ld	s6,64(sp)
 a52:	7be2                	ld	s7,56(sp)
 a54:	7c42                	ld	s8,48(sp)
 a56:	7ca2                	ld	s9,40(sp)
 a58:	7d02                	ld	s10,32(sp)
 a5a:	6de2                	ld	s11,24(sp)
 a5c:	6109                	addi	sp,sp,128
 a5e:	8082                	ret

0000000000000a60 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a60:	715d                	addi	sp,sp,-80
 a62:	ec06                	sd	ra,24(sp)
 a64:	e822                	sd	s0,16(sp)
 a66:	1000                	addi	s0,sp,32
 a68:	e010                	sd	a2,0(s0)
 a6a:	e414                	sd	a3,8(s0)
 a6c:	e818                	sd	a4,16(s0)
 a6e:	ec1c                	sd	a5,24(s0)
 a70:	03043023          	sd	a6,32(s0)
 a74:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a78:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a7c:	8622                	mv	a2,s0
 a7e:	00000097          	auipc	ra,0x0
 a82:	e04080e7          	jalr	-508(ra) # 882 <vprintf>
}
 a86:	60e2                	ld	ra,24(sp)
 a88:	6442                	ld	s0,16(sp)
 a8a:	6161                	addi	sp,sp,80
 a8c:	8082                	ret

0000000000000a8e <printf>:

void
printf(const char *fmt, ...)
{
 a8e:	711d                	addi	sp,sp,-96
 a90:	ec06                	sd	ra,24(sp)
 a92:	e822                	sd	s0,16(sp)
 a94:	1000                	addi	s0,sp,32
 a96:	e40c                	sd	a1,8(s0)
 a98:	e810                	sd	a2,16(s0)
 a9a:	ec14                	sd	a3,24(s0)
 a9c:	f018                	sd	a4,32(s0)
 a9e:	f41c                	sd	a5,40(s0)
 aa0:	03043823          	sd	a6,48(s0)
 aa4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 aa8:	00840613          	addi	a2,s0,8
 aac:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ab0:	85aa                	mv	a1,a0
 ab2:	4505                	li	a0,1
 ab4:	00000097          	auipc	ra,0x0
 ab8:	dce080e7          	jalr	-562(ra) # 882 <vprintf>
}
 abc:	60e2                	ld	ra,24(sp)
 abe:	6442                	ld	s0,16(sp)
 ac0:	6125                	addi	sp,sp,96
 ac2:	8082                	ret

0000000000000ac4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ac4:	1141                	addi	sp,sp,-16
 ac6:	e422                	sd	s0,8(sp)
 ac8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aca:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ace:	00000797          	auipc	a5,0x0
 ad2:	2a27b783          	ld	a5,674(a5) # d70 <freep>
 ad6:	a805                	j	b06 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ad8:	4618                	lw	a4,8(a2)
 ada:	9db9                	addw	a1,a1,a4
 adc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ae0:	6398                	ld	a4,0(a5)
 ae2:	6318                	ld	a4,0(a4)
 ae4:	fee53823          	sd	a4,-16(a0)
 ae8:	a091                	j	b2c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 aea:	ff852703          	lw	a4,-8(a0)
 aee:	9e39                	addw	a2,a2,a4
 af0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 af2:	ff053703          	ld	a4,-16(a0)
 af6:	e398                	sd	a4,0(a5)
 af8:	a099                	j	b3e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 afa:	6398                	ld	a4,0(a5)
 afc:	00e7e463          	bltu	a5,a4,b04 <free+0x40>
 b00:	00e6ea63          	bltu	a3,a4,b14 <free+0x50>
{
 b04:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b06:	fed7fae3          	bgeu	a5,a3,afa <free+0x36>
 b0a:	6398                	ld	a4,0(a5)
 b0c:	00e6e463          	bltu	a3,a4,b14 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b10:	fee7eae3          	bltu	a5,a4,b04 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 b14:	ff852583          	lw	a1,-8(a0)
 b18:	6390                	ld	a2,0(a5)
 b1a:	02059713          	slli	a4,a1,0x20
 b1e:	9301                	srli	a4,a4,0x20
 b20:	0712                	slli	a4,a4,0x4
 b22:	9736                	add	a4,a4,a3
 b24:	fae60ae3          	beq	a2,a4,ad8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 b28:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b2c:	4790                	lw	a2,8(a5)
 b2e:	02061713          	slli	a4,a2,0x20
 b32:	9301                	srli	a4,a4,0x20
 b34:	0712                	slli	a4,a4,0x4
 b36:	973e                	add	a4,a4,a5
 b38:	fae689e3          	beq	a3,a4,aea <free+0x26>
  } else
    p->s.ptr = bp;
 b3c:	e394                	sd	a3,0(a5)
  freep = p;
 b3e:	00000717          	auipc	a4,0x0
 b42:	22f73923          	sd	a5,562(a4) # d70 <freep>
}
 b46:	6422                	ld	s0,8(sp)
 b48:	0141                	addi	sp,sp,16
 b4a:	8082                	ret

0000000000000b4c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b4c:	7139                	addi	sp,sp,-64
 b4e:	fc06                	sd	ra,56(sp)
 b50:	f822                	sd	s0,48(sp)
 b52:	f426                	sd	s1,40(sp)
 b54:	f04a                	sd	s2,32(sp)
 b56:	ec4e                	sd	s3,24(sp)
 b58:	e852                	sd	s4,16(sp)
 b5a:	e456                	sd	s5,8(sp)
 b5c:	e05a                	sd	s6,0(sp)
 b5e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b60:	02051493          	slli	s1,a0,0x20
 b64:	9081                	srli	s1,s1,0x20
 b66:	04bd                	addi	s1,s1,15
 b68:	8091                	srli	s1,s1,0x4
 b6a:	0014899b          	addiw	s3,s1,1
 b6e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b70:	00000517          	auipc	a0,0x0
 b74:	20053503          	ld	a0,512(a0) # d70 <freep>
 b78:	c515                	beqz	a0,ba4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b7a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b7c:	4798                	lw	a4,8(a5)
 b7e:	02977f63          	bgeu	a4,s1,bbc <malloc+0x70>
 b82:	8a4e                	mv	s4,s3
 b84:	0009871b          	sext.w	a4,s3
 b88:	6685                	lui	a3,0x1
 b8a:	00d77363          	bgeu	a4,a3,b90 <malloc+0x44>
 b8e:	6a05                	lui	s4,0x1
 b90:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b94:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b98:	00000917          	auipc	s2,0x0
 b9c:	1d890913          	addi	s2,s2,472 # d70 <freep>
  if(p == (char*)-1)
 ba0:	5afd                	li	s5,-1
 ba2:	a88d                	j	c14 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 ba4:	00008797          	auipc	a5,0x8
 ba8:	3b478793          	addi	a5,a5,948 # 8f58 <base>
 bac:	00000717          	auipc	a4,0x0
 bb0:	1cf73223          	sd	a5,452(a4) # d70 <freep>
 bb4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bb6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bba:	b7e1                	j	b82 <malloc+0x36>
      if(p->s.size == nunits)
 bbc:	02e48b63          	beq	s1,a4,bf2 <malloc+0xa6>
        p->s.size -= nunits;
 bc0:	4137073b          	subw	a4,a4,s3
 bc4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bc6:	1702                	slli	a4,a4,0x20
 bc8:	9301                	srli	a4,a4,0x20
 bca:	0712                	slli	a4,a4,0x4
 bcc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bce:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bd2:	00000717          	auipc	a4,0x0
 bd6:	18a73f23          	sd	a0,414(a4) # d70 <freep>
      return (void*)(p + 1);
 bda:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bde:	70e2                	ld	ra,56(sp)
 be0:	7442                	ld	s0,48(sp)
 be2:	74a2                	ld	s1,40(sp)
 be4:	7902                	ld	s2,32(sp)
 be6:	69e2                	ld	s3,24(sp)
 be8:	6a42                	ld	s4,16(sp)
 bea:	6aa2                	ld	s5,8(sp)
 bec:	6b02                	ld	s6,0(sp)
 bee:	6121                	addi	sp,sp,64
 bf0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bf2:	6398                	ld	a4,0(a5)
 bf4:	e118                	sd	a4,0(a0)
 bf6:	bff1                	j	bd2 <malloc+0x86>
  hp->s.size = nu;
 bf8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bfc:	0541                	addi	a0,a0,16
 bfe:	00000097          	auipc	ra,0x0
 c02:	ec6080e7          	jalr	-314(ra) # ac4 <free>
  return freep;
 c06:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c0a:	d971                	beqz	a0,bde <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c0c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c0e:	4798                	lw	a4,8(a5)
 c10:	fa9776e3          	bgeu	a4,s1,bbc <malloc+0x70>
    if(p == freep)
 c14:	00093703          	ld	a4,0(s2)
 c18:	853e                	mv	a0,a5
 c1a:	fef719e3          	bne	a4,a5,c0c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 c1e:	8552                	mv	a0,s4
 c20:	00000097          	auipc	ra,0x0
 c24:	b7e080e7          	jalr	-1154(ra) # 79e <sbrk>
  if(p == (char*)-1)
 c28:	fd5518e3          	bne	a0,s5,bf8 <malloc+0xac>
        return 0;
 c2c:	4501                	li	a0,0
 c2e:	bf45                	j	bde <malloc+0x92>
