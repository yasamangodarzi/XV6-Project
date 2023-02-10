#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void
main(void) {
    int used_memory = used_mem();
    int free_memory = kfreemem_for_xv6();
    int system_memory = used_memory + free_memory;
    //print
    printf("free memory of xv6: %d\n", free_memory);
    printf("used memory of xv6: %d\n", used_memory);
    printf("system memory of xv6: %d\n", system_memory);
}