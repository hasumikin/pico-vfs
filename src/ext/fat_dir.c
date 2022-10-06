#include <stdint.h>

#include "fat_dir.h"

#include <ff.h>

static void
c_new(mrbc_vm *vm, mrbc_value v[], int argc)
{
  FRESULT res;
  FILINFO fno;
  const TCHAR *path = (const TCHAR *)GET_STRING_ARG(1);

  res = f_stat(path, &fno);
  switch (res) {
    case FR_OK:
      if ((fno.fattrib & AM_DIR) == 0) {
        mrbc_raise(
          vm, MRBC_CLASS(ArgumentError), // Errno::ENOTDIR in CRuby
          "Not a directory @ dir_initialize"
        );
        return;
      }
      break;
    case FR_INVALID_NAME:
      /* FIXME: pathname "/" becomes INVALID, why? */
      break;
    case FR_NO_PATH:
    case FR_NO_FILE:
      mrbc_raise(
        vm, MRBC_CLASS(ArgumentError), // Errno::ENOENT in CRuby
        "No such file or directory @ dir_initialize"
      );
      return;
    default:
      mrbc_raise(
        vm, MRBC_CLASS(RuntimeError),
        "Unhandled error happened @ f_stat"
      );
      return;
  }

  mrbc_value obj = mrbc_instance_new(vm, v->cls, sizeof(DIR));
  DIR *dp = (DIR *)obj.instance->data;
  res = f_opendir(dp, path);
  switch (res) {
    case FR_OK:
      SET_RETURN(obj);
      break;
    default:
      mrbc_raise(
        vm, MRBC_CLASS(RuntimeError),
        "Unhandled error happened @ f_opendir"
      );
  }
}

static void
c_close(struct VM *vm, mrbc_value v[], int argc)
{
  DIR *dp = (DIR *)v->instance->data;
  FRESULT res = f_closedir(dp);
  switch (res) {
    case FR_OK:
      SET_TRUE_RETURN();
      break;
    default:
      SET_FALSE_RETURN();
  }
}

static void
c_read(struct VM *vm, mrbc_value v[], int argc)
{
//  (v[0]).obj->ref_count++;
//  (v[0]).obj->ref_count++;
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
c_rewind(struct VM *vm, mrbc_value v[], int argc)
{
  DIR *dp = (DIR *)v->instance->data;
  f_rewinddir(dp);
}

void
mrbc_init_class_Dir(void)
{
  mrbc_class *FAT_class = mrbc_define_class(0, "FAT", mrbc_class_object);
  mrbc_sym symid = mrbc_search_symid("Dir");
  mrbc_value *v = mrbc_get_class_const(FAT_class, symid);
  mrbc_class *Dir_class = v->cls;

  mrbc_define_method(0, Dir_class, "new",    c_new);
  mrbc_define_method(0, Dir_class, "close",  c_close);
  mrbc_define_method(0, Dir_class, "read",   c_read);
  mrbc_define_method(0, Dir_class, "rewind", c_rewind);
}

