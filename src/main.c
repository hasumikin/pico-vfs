#include <stdio.h>
#include <string.h>

#include <mrubyc.h>
#include <picorbc.h>
#include <ff.h>

#include "../build/mrb/vfs.c"

#ifndef HEAP_SIZE
#define HEAP_SIZE (1024 * 64 - 1)
#endif

int
main(void)
{
  printf("hello\n");
  return 0;
}
