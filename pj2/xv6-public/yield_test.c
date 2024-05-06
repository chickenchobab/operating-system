#include "types.h"
#include "stat.h"
#include "user.h"
#define LOOP_NUM 100

int
main(int argc, char *argv[])
{
    int pid;

    pid = fork();
    if (pid < 0){
        printf(2, "Fork Failed!\n");
        exit();
    }
    else if (pid == 0) {
        for (int i = 0; i < LOOP_NUM; i ++){
            printf(1, "Child\n");
            yield();
        } 
    }
    else {
        for (int i = 0; i < LOOP_NUM; i ++){
            printf(1, "Parent\n");
            yield();
        }
        wait();   
    }
    exit();
}