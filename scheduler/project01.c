#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{   
    int pid, gpid;

    pid = getpid();
    gpid = getgpid();

    printf(1, "My student id is 2021064720\n");
    printf(1, "My pid is %d\n", pid);
    printf(1, "My gpid is %d\n", gpid);
    exit();
}