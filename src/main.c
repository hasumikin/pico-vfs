#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#include <mrubyc.h>
#include <alloc.h>
#include <picorbc.h>
#include <ff.h>

#include "ext/fat_dir.h"

#include "../build/mrb/vfs.c"
#include "../build/mrb/fat.c"
#include "../build/mrb/os_dir.c"
#include "../build/mrb/app.c"

#ifndef HEAP_SIZE
#define HEAP_SIZE (1024 * 200 - 1)
#endif

static uint8_t heap_pool[HEAP_SIZE];

bool
load_model(const uint8_t *mrb)
{
  mrbc_vm *vm = mrbc_vm_open(NULL);
  if (vm == 0) {
    console_printf("Error: Can't open VM.\n");
    return false;
  }
  if (mrbc_load_mrb(vm, mrb) != 0) {
    console_printf("Error: Illegal bytecode.\n");
    return false;
  }
  mrbc_vm_begin(vm);
  mrbc_vm_run(vm);
  mrbc_raw_free(vm);
  return true;
}

int
main(void)
{
  FATFS fs;
  f_mount(&fs, "", 0);

  mrbc_init(heap_pool, HEAP_SIZE);
  load_model(vfs);
  load_model(fat);
  load_model(os_dir);
  mrbc_init_class_Dir();
  mrbc_create_task(app, 0);
  mrbc_run();
  return 0;
}

