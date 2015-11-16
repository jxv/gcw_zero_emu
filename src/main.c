#include <unistd.h>
#include <linux/reboot.h>
#include <sys/reboot.h>

int main(int argc, char const **args) {
    reboot(LINUX_REBOOT_CMD_RESTART);
    return 0;
}
