#include <stdio.h>
#include <pthread.h>

int shared_resource = 0;

#define NUM_ITERS 100
#define NUM_THREADS 100

int flag[NUM_THREADS];
int turn[NUM_THREADS];
int t;
int wait_condition(int i, int j);
void lock(int i);
void unlock(int i);

int wait_condition(int i, int j)
{
    if (turn[j] == turn[i]) 
        return j < i;
    return turn[j] < turn[i];
}

void lock(int i)
{   
    flag[i] = 0;
    turn[i] = ++ t;
    flag[i] = 0;
    for (int j = 0; j < NUM_THREADS; j ++){
        while(flag[j]);
        while(turn[j] && wait_condition(i, j));
    }
}

void unlock(int i)
{
    turn[i] = 0;
}

void* thread_func(void* arg) {
    int tid = *(int*)arg;
    
    lock(tid);
    
        for(int i = 0; i < NUM_ITERS; i++) {
            shared_resource++; 
            // printf("%d\n", shared_resource);
        }
    
    unlock(tid);
    
    pthread_exit(NULL);
}

int main() {
    int n = NUM_THREADS;
    pthread_t threads[n];
    int tids[n];
    
    for (int i = 0; i < n; i++) {
        tids[i] = i;
        pthread_create(&threads[i], NULL, thread_func, &tids[i]);
    }
    
    for (int i = 0; i < n; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("shared: %d\n", shared_resource);
    
    return 0;
}