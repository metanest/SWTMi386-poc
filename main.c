#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>
#include <stdlib.h>

void intp(void) __attribute__((noreturn));

int
main(void)
{
  intp();
}

void
my_hello(void)
{
  char msg[] = "hello\n";
  write(1, msg, sizeof(msg) - 1);
}

void
my_exit(void)
{
  char msg[] = "quit\n";
  write(1, msg, sizeof(msg) - 1);
  exit(0);
}
