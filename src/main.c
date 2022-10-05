#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#include <mrubyc.h>
#include <alloc.h>
#include <picorbc.h>
#include <ff.h>

#include "ext/dir.h"

//#include "../build/mrb/vfs.c"
#include "../build/mrb/dir.c"
#include "../build/mrb/app.c"

#ifndef HEAP_SIZE
#define HEAP_SIZE (1024 * 64 - 1)
#endif

static uint8_t heap_pool[HEAP_SIZE];

bool
load_model(const uint8_t *mrb)
{
  mrbc_vm *vm = mrbc_vm_open(NULL);
  if( vm == 0 ) {
    console_printf("Error: Can't open VM.\n");
    return false;
  }
  if( mrbc_load_mrb(vm, mrb) != 0 ) {
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
  mrbc_init_class_Dir();
  load_model(dir);
  mrbc_create_task(app, 0);
  mrbc_run();
  return 0;
}

//FRESULT scan_files (
//  char* path        /* Start node to be scanned (***also used as work area***) */
//)
//{
//  FRESULT res;
//  DIR dir;
//  UINT i;
//  static FILINFO fno;
//
//  res = f_opendir(&dir, path);                       /* Open the directory */
//  if (res == FR_OK) {
//    for (;;) {
//      res = f_readdir(&dir, &fno);                   /* Read a directory item */
//      if (res != FR_OK || fno.fname[0] == 0) break;  /* Break on error or end of dir */
//      if (fno.fattrib & AM_DIR) {                    /* It is a directory */
//        i = strlen(path);
//        sprintf(&path[i], "/%s", fno.fname);
//        res = scan_files(path);                      /* Enter the directory */
//        if (res != FR_OK) break;
//        path[i] = 0;
//      } else {                                       /* It is a file. */
//        printf("%s/%s\n", path, fno.fname);
//      }
//    }
//    f_closedir(&dir);
//  }
//  return res;
//}
//int
//main(void)
//{
//  FATFS fs;
//  FRESULT res;
//  char buff[256];
//
//  res = f_mount(&fs, "", 0);
//  if (res == FR_OK) {
//    strcpy(buff, "/");
//    res = scan_files(buff);
//  }
//  return res;
//}
