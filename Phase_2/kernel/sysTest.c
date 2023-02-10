#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/processes_info.h"

void printpinfo(int pid)
{
    struct processes_info pi;
    getprocessesinfo(&pi);
    int i;
    for (i = 0; i < NPROC; i++) {
        if(pi.pids[i] == pid) {
            printf("Number of tickets that PID %d has: %d\n", pid, pi.tickets[i]);
            printf("Number of ticks that PID %d has: %d\n", pid, pi.ticks[i]);
            break;
        }
    }
}

int
main(int argc, char *argv[])
{
    int pid1;
    settickets(900);
    pid1 = fork();
    if (pid1 == 0) {
        settickets(10);
        int pp1 = getpid();
        printf("Process started with PID %d\n\n", pp1);
        int i = 0;
        while(i<1326044832){
            i++;
        }
        printf("Process with PID %d finished!\n\n", pp1);
        printpinfo(pp1);
        exit(0);
    }
    else if (pid1 > 0) {
        settickets(20);
        int pp2 = getpid();
        printf("Process started with PID %d\n\n", pp2);
        int i = 0;
        while(i<1326044832){
            i++;
        }
        printf("Process with PID %d finished!\n\n", pp2);
        printpinfo(pp2);
        exit(0);
    }

    exit(0);
}