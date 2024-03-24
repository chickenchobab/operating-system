#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

// Simple system call
int
myfunction(char *str)
{
    cprintf("%s\n", str);
    return 0xABCDABCD;
}

// Wrapper for myfunction
int
sys_myfunction(void)
{
    char *str;
    // Decode argument using argstr
    if (argstr(0, &str) < 0)
        return -1;
    return myfunction(str);
}

// Get grand parent process id
int getgpid()
{
    struct proc* culproc = myproc();

    struct proc* pproc = culproc -> parent;
    if (pproc == 0) return -1;
    struct proc* gpproc = pproc -> parent;
    if (gpproc == 0) return -1;

    return gpproc -> pid;
}

// Wrapper for getgpid
int sys_getgpid()
{
    int ret;
    if ((ret = getgpid()) < 0) exit();
    return ret;
}

