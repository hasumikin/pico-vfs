#include <stdio.h>
#include <string.h>

#include <mrubyc.h>
#include <picorbc.h>
#include <ff.h>

#include "../build/mrb/vfs.c"

#ifndef HEAP_SIZE
#define HEAP_SIZE (1024 * 64 - 1)
#endif

FRESULT scan_files (
  char* path        /* Start node to be scanned (***also used as work area***) */
)
{
  FRESULT res;
  DIR dir;
  UINT i;
  static FILINFO fno;

  res = f_opendir(&dir, path);                       /* Open the directory */
  if (res == FR_OK) {
    for (;;) {
      res = f_readdir(&dir, &fno);                   /* Read a directory item */
      if (res != FR_OK || fno.fname[0] == 0) break;  /* Break on error or end of dir */
      if (fno.fattrib & AM_DIR) {                    /* It is a directory */
        i = strlen(path);
        sprintf(&path[i], "/%s", fno.fname);
        res = scan_files(path);                      /* Enter the directory */
        if (res != FR_OK) break;
        path[i] = 0;
      } else {                                       /* It is a file. */
        printf("%s/%s\n", path, fno.fname);
      }
    }
    f_closedir(&dir);
  }
  return res;
}
int
main(void)
{
  FATFS fs;
  FRESULT res;
  char buff[256];

  res = f_mount(&fs, "", 0);
  if (res == FR_OK) {
    strcpy(buff, "/");
    res = scan_files(buff);
  }
  return res;
}
