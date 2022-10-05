#include <stdint.h>

#include "dir.h"

#include <ff.h>

static void
c_Dir_new(mrbc_vm *vm, mrbc_value v[], int argc)
{
  mrbc_value obj = mrbc_instance_new(vm, v->cls, sizeof(DIR));
  DIR *dp = (DIR *)obj.instance->data;

  const TCHAR *path = (const TCHAR *)GET_STRING_ARG(1);
  FRESULT res = f_opendir(dp, path);
  switch (res) {
    case FR_OK:
      SET_RETURN(obj);
      break;
    case FR_NO_PATH:
      mrbc_raise(
        vm, MRBC_CLASS(ArgumentError), // Errno::ENOENT in CRuby
        "No such file or directory @ dir_initialize"
      );
      break;
    default:
      mrbc_raise(
        vm, MRBC_CLASS(RuntimeError),
        "Unhandled error happened @ dir_initialize"
      );
  }
}

static void
c_Dir_close(struct VM *vm, mrbc_value v[], int argc)
{
  DIR *dp = (DIR *)v->instance->data;
  FRESULT res = f_closedir(dp);
  switch (res) {
    case FR_OK:
      SET_NIL_RETURN();
      break;
    default:
      mrbc_raise(
        vm, MRBC_CLASS(RuntimeError),
        "Unhandled error happened @ dir_close"
      );
  }
}

static void
c_Dir__f_readdir(struct VM *vm, mrbc_value v[], int argc)
{
  DIR *dp = (DIR *)v->instance->data;
  FILINFO fno;
  FRESULT res = f_readdir(dp, &fno);
  if (res != FR_OK || fno.fname[0] == 0) {
    SET_NIL_RETURN();
    return;
  } else {
    mrbc_value value = mrbc_string_new_cstr(vm, fno.fname);
    SET_RETURN(value);
  }
}

static void
c_Dir__f_rewinddir(struct VM *vm, mrbc_value v[], int argc)
{
  DIR *dp = (DIR *)v->instance->data;
  f_rewinddir(dp);
}

void
mrbc_init_class_Dir(void)
{
  mrbc_class *Dir_class = mrbc_define_class(0, "Dir", mrbc_class_object);

  mrbc_define_method(0, Dir_class, "new",        c_Dir_new);
  mrbc_define_method(0, Dir_class, "close",      c_Dir_close);
  mrbc_define_method(0, Dir_class, "_f_readdir", c_Dir__f_readdir);
  mrbc_define_method(0, Dir_class, "_f_rewinddir", c_Dir__f_rewinddir);
}

