#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

void swap(struct proc **p1, struct proc **p2)
{
  struct proc *tmp;
  tmp = *p1;
  *p1 = *p2;
  *p2 = tmp;
}

// queue start

// A structure and variables of queue.
typedef struct {
  struct proc *heap[NPROC + 1];
  int size;
  int level;
  struct proc *front;
}queue;

queue mlfq[4];
queue moq;
int monopoly = 0;

// Initial setting of queues in userinit().
void qinit()
{
  for (int i = 0; i <= 3; i ++){
    mlfq[i].size = 0;
    mlfq[i].level = i;
  }
  moq.size = 0;
  moq.level = 99;
}


// Print the elements in a queue.
void qprint(queue *q)
{
  struct proc *p;
  cprintf("queue %d start\n", q->level);
  for (int i = 1; i <= q->size; i ++){
    p = q->heap[i];
    cprintf("pid = %d, name = %s, state = %d\n", p->pid, p->name, p->state);
  }
  cprintf("end\n\n");
}

void enqueue(queue *q, struct proc *p)
{
	int i;

  if (q->size == NPROC)
    return;

	q->size = q->size + 1;
	i = q->size;

  if(q->level == 3){
    while ((i != 1) && ((p->priority) > (q->heap[i / 2]->priority))){
      q->heap[i] = q->heap[i / 2];
      i /= 2;
    }
  }
  
	q->heap[i] = p;
  q->front = q->heap[1];
}

void heapify(queue *q, int i)
{
  int front = i;
  int left = i * 2;
  int right = i * 2 + 1;

  if (left <= q->size && q->heap[left]->priority > q->heap[front]->priority)
    front = left;
  if (right <= q->size && q->heap[right]->priority > q->heap[front]->priority)
    front = right;

  if (front != i){
    swap(&(q->heap[front]), &(q->heap[i]));
    heapify(q, front);
  }
}

void dequeue(queue *q)
{ 
  if (q->size == 0) 
    return;

  if (q->level == 3){
    q->heap[1] = q->heap[q->size];
    q->size = q->size - 1;
    heapify(q, 1);
  }
  else {
    q->size = q->size - 1;
    for (int i = 1; i <= q->size; i ++){
      q->heap[i] = q->heap[i + 1];
    }
  }
  
  q->front = q->heap[1];
}



// queue end

// proc.c

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);
static void yield1(void);
static void yield2(void);
static void unmonopolize1(void);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->level = -1;
  p->priority = 0;
  p->tq = 0;
  p->yielded = 0;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  qinit();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;
  p->level = 0;
  p->tq = 2 * p->level + 2;
  enqueue(&mlfq[0], p);

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;
  np->level = 0;
  np->tq = 2 * np->level + 2;
  enqueue(&mlfq[0], np);

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

// Finds a process to run
// The ptable lock must be held.
void
findproc(queue *q)
{
  struct proc *p;
  int cnt;
  
  cnt = q->size;

  while(q->size && cnt--){
    p = q->front;
    if (p->state == RUNNABLE && p->level == q->level && p->yielded == 0) 
      break;
    
    dequeue(q);

    if(p->level != q->level)
      continue;
    if(p->yielded){
      p->yielded = p->yielded - 1;
      continue;
    }

    if (p->state == SLEEPING)
        enqueue(q, p);
    else
        p->level = -1;
  }
}


//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();

  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over every queue looking for process to run.
    acquire(&ptable.lock);

    // Choose a process in moq.
    if(monopoly){
      findproc(&moq);

      if (moq.size){
        p = moq.front;
        if (p->state == RUNNABLE){
          schedule(p);
        }
      }
      if(!moq.size)
        unmonopolize1();
    }

    // Choose a process in mlfq.
    for(int qlv = 0; qlv <= 3; qlv ++){ 
      if (monopoly) break;
      findproc(&mlfq[qlv]);
      
      if (mlfq[qlv].size){
        p = mlfq[qlv].front;
        if (p->state == RUNNABLE){
          schedule(p);
          qlv = -1;
        }
      }
    }

    // One loop for scheduling finished.
    release(&ptable.lock);
  }
}

// Give chosen process CPU and take it back
// when process is done running.
void
schedule(struct proc *p)
{ 
  struct cpu *c = mycpu();
  // Switch to chosen process.  It is the process's job
  // to release ptable.lock and then reacquire it
  // before jumping back to us.
  c->proc = p;
  switchuvm(p);
  p->state = RUNNING;

  swtch(&(c->scheduler), p->context);
  switchkvm();

  // Process is done running for now.
  // It should have changed its p->state before coming back.
  c->proc = 0;
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the cpu moving into another queue.
// The ptable lock must be held.
static void
yield1(void)
{ 
  struct proc *p;
  int level;

  p = myproc();
  level = p->level;

  if (level == 0){
    if ((p->pid) % 2) p->level = 1;
    else p->level = 2;
    enqueue(&mlfq[p->level], p);
  }
  else if (level == 1 || level == 2){
    p->level = 3;
    enqueue(&mlfq[p->level], p);
  }
  else { 
    if (p->priority > 0)
      p->priority = p->priority - 1;
    heapify(&mlfq[level], 1);
  }

  p->tq = 2 * (p->level) + 2;
  p->state = RUNNABLE;

  sched();
}

// Give up the cpu staying in the queue.
// The ptable lock must be held.
static void
yield2(void)
{ 
  struct proc *p;
  p = myproc();

  p->state = RUNNABLE;
  p->yielded = p->yielded + 1;
  if (p->level == 99)
    enqueue(&moq, p);
  else
    enqueue(&mlfq[p->level], p);
  sched();
}

// Give up the CPU for one scheduling round.
// It is used for system call.
void
yield(void)
{ 
  struct proc *p;
  acquire(&ptable.lock);  //DOC: yieldlock
  p = myproc();
  if (p->level != 99 && p->tq == 0)
    yield1();
  else
    yield2();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;
  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

// Calculate time quantum of current process
// and decide whether to yield or not.
void proctimer()
{ 
  struct proc *p;

  acquire(&ptable.lock);
  p = myproc();

  if (p->level == 99){
    release(&ptable.lock);
    return;
  }
  else{
    p->tq = p->tq - 1;
    if(p->tq == 0)
      yield1();
  }
  release(&ptable.lock);
}

// Reset all processes.
void
prboost()
{ 
  struct proc *p;

  acquire(&ptable.lock);

  if (monopoly){
    release(&ptable.lock);
    return; 
  }

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->level == -1 || p->level == 99)
      continue;
    if(p->level){
      p->level = 0;
      p->priority = 0;
      enqueue(&mlfq[0], p);
    }
    p->tq = 2 * p->level + 2;
  }
  
  for (int qlv = 1; qlv <= 3; qlv ++){
    for (int idx = 1; idx <= mlfq[qlv].size; idx ++)
      mlfq[qlv].heap[idx] = 0;
    mlfq[qlv].size = 0;
  }

  release(&ptable.lock);
}

// Functions for system call used in mlfq_test.

int
getlev()
{ 
  int level;

  acquire(&ptable.lock);
  level = myproc()->level;
  release(&ptable.lock);

  return level;
}

int
setpriority(int pid, int priority)
{ 
  struct proc *p;

  if (priority < 0 || priority > 10) return -2;

  acquire(&ptable.lock);
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if (p->pid == pid) {
      p->priority = priority;

      if (p->level == 3){
        for(int i = 1; i <= mlfq[3].size; i ++){
          if(mlfq[3].heap[i] != p) continue;
          mlfq[3].heap[i] = 0;
          for (int j = i; j < mlfq[3].size; j ++){
            mlfq[3].heap[j] = mlfq[3].heap[j + 1];
          }
        }
        for(int cnt = 0; cnt <= p->yielded; cnt ++)
          enqueue(&mlfq[3], p);
      }

      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

int
setmonopoly(int pid, int password)
{ 
  struct proc *p;
  int studentid = 2021064720;

  acquire(&ptable.lock);

  if (pid == myproc()->pid){
    release(&ptable.lock);
    return -4;
  } 
  if (password != studentid){
    release(&ptable.lock);
    return -2;
  }
    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if (p->pid != pid) 
      continue;

    if (p->level == 99){
      release(&ptable.lock);
      return -3;
    }

    p->level = 99;
    p->priority = 0;
    enqueue(&moq, p);
    release(&ptable.lock);
    return moq.size;
  }

  release(&ptable.lock);
  return -1;
}

void
monopolize()
{
  struct proc* p;
  acquire(&ptable.lock);
  p = myproc();

  if(p->level == 99){
    release(&ptable.lock);
    return;
  }
  monopoly = 1;
  if(p->tq == 0) yield1();
  else yield2();
  
  release(&ptable.lock);
}


static void
unmonopolize1()
{ 
  monopoly = 0;

  acquire(&tickslock);
  ticks = 0;
  release(&tickslock);
}

void
unmonopolize()
{ 
  struct proc * p;
  acquire(&ptable.lock);

  p = myproc();

  if(p->level != 99){
    release(&ptable.lock);
    return;
  }
  unmonopolize1();
  yield2();
  release(&ptable.lock);
}