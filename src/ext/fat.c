#include <stdint.h>
#include <stdio.h>

#include "fat.h"

#include <ff.h>


static void
c__mount(struct VM *vm, mrbc_value v[], int argc)
{
  mrbc_value fatfs = mrbc_instance_new(vm, v->cls, sizeof(FATFS));
  FATFS *fs = (FATFS *)fatfs.instance->data;
  FRESULT res;
  res = f_mount(fs, (const TCHAR *)GET_STRING_ARG(1), 1);
  if (res == FR_OK) {
    SET_RETURN(fatfs);
  } else {
    char buff[100];
    sprintf(buff, "Mounting FAT volume failed (error code: %d)", res);
    mrbc_raise(vm, MRBC_CLASS(RuntimeError), buff);
  }
}

static void
c__unmount(struct VM *vm, mrbc_value v[], int argc)
{
  FRESULT res;
  res = f_mount(0, (const TCHAR *)GET_STRING_ARG(1), 0);
  if (res != FR_OK) {
    char buff[100];
    sprintf(buff, "Unmounting FAT volume failed (error code: %d)", res);
    mrbc_raise(vm, MRBC_CLASS(RuntimeError), buff);
  }
}

static void
c__chdir(struct VM *vm, mrbc_value v[], int argc)
{
  FRESULT res;
  res = f_chdir((const TCHAR *)GET_STRING_ARG(1));
}


static void
c__mkdir(struct VM *vm, mrbc_value v[], int argc)
{
  FRESULT res = f_mkdir((const TCHAR *)GET_STRING_ARG(1));
  switch (res) {
    case FR_OK:
      break;
    case FR_NO_PATH:
      mrbc_raise(
        vm, MRBC_CLASS(RuntimeError), // Errno::ENOENT
        "Not a directory @ dir_mkdir"
      );
      break;
    default:
      mrbc_raise(
        vm, MRBC_CLASS(RuntimeError),
        "Unhandled error happened @ dir_mkdir"
      );
      return;
  }
}

void
mrbc_init_class_FAT(void)
{
  mrbc_class *class_FAT = mrbc_define_class(0, "FAT", mrbc_class_object);
  mrbc_define_method(0, class_FAT, "_mount", c__mount);
  mrbc_define_method(0, class_FAT, "_unmount", c__unmount);
  mrbc_define_method(0, class_FAT, "_chdir", c__chdir);
  mrbc_define_method(0, class_FAT, "_mkdir", c__mkdir);
}
