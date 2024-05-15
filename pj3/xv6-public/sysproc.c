#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  merge(myproc());
  if (myproc()->created)
    thread_exit(0);
  else
    exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int 
sys_thread_create(void)
{
  char *thread;
  char *start_routine;
  char *arg;

  if (argptr(0, &thread, sizeof(thread_t*)) < 0) 
    return -1;
  if (argptr(1, &start_routine, sizeof(void*(*)(void*))) < 0)
    return -1;
  if (argptr(2, &arg, sizeof(void*)) < 0) 
    return -1;
  return thread_create((thread_t*)thread, (void*(*)(void*))start_routine, (void*)arg);
}

int 
sys_thread_exit(void)
{
  char *retval;
  if (argptr(0, &retval, sizeof(void*)) < 0)
    return -1;
  thread_exit((void*)retval);
  return 0;
}

int
sys_thread_join(void)
{
  int thread;
  char *retval;
  if (argint(0, &thread) < 0)
    return -1;
  if (argptr(1, &retval, sizeof(void**)) < 0)
    return -1;
  return thread_join((thread_t)thread, (void**)retval);
}
