#include "types.h"
#include "stat.h"
#include "user.h"
#define LOOP_NUM 100

int
main(int argc, char *argv[])
{   
    printpinfo();
    for (int i = 0; i < LOOP_NUM; i ++){
        yield();
    }
    
    exit();
}