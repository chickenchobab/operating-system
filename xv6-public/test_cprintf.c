#include "types.h"
#include "stat.h"
#include "user.h"
#define LOOP_NUM 100

int
main(int argc, char *argv[])
{   
    for (int i = 0; i < LOOP_NUM; i ++){
        printpinfo();
        yield();
    }
    exit();
}