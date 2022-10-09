#include <stdio.h>
#include <stdint.h>

#include "file.h"

#include <ff.h>

static void
c_new(mrbc_vm *vm, mrbc_value v[], int argc)
{
  FRESULT res;
  FILINFO fno;
  const TCHAR *path = (const TCHAR *)GET_STRING_ARG(1);

  mrbc_value _file = mrbc_instance_new(vm, v->cls, sizeof(FIL));
  FIL *fp = (FIL *)_file.instance->data;
  BYTE mode;
  const char *mode_str = GET_STRING_ARG(2);
  if (strcmp(mode_str, "r") == 0) {
    mode = FA_READ;
  } else if (strcmp(mode_str, "r+") == 0) {
    mode = FA_READ | FA_WRITE;
  } else if (strcmp(mode_str, "w") == 0) {
    mode = FA_CREATE_ALWAYS | FA_WRITE;
  } else if (strcmp(mode_str, "w+") == 0) {
    mode = FA_CREATE_ALWAYS | FA_WRITE | FA_READ;
  } else if (strcmp(mode_str, "a") == 0) {
    mode = FA_OPEN_APPEND | FA_WRITE;
  } else if (strcmp(mode_str, "a+") == 0) {
    mode = FA_OPEN_APPEND | FA_WRITE | FA_READ;
  } else if (strcmp(mode_str, "wx") == 0) {
    mode = FA_CREATE_NEW | FA_WRITE;
  } else if (strcmp(mode_str, "w+x") == 0) {
    mode = FA_CREATE_NEW | FA_WRITE | FA_READ;
  } else {
    // TODO raise
  }
  res = f_open(fp, path, mode);

  switch (res) {
    case FR_OK:
      SET_RETURN(_file);
      break;
    default:
      mrbc_raise(
        vm, MRBC_CLASS(RuntimeError),
        "Unhandled error happened @ f_open"
      );
  }
}

static void
c_gets(mrbc_vm *vm, mrbc_value v[], int argc)
{
  (v[0]).obj->ref_count++;
  (v[0]).obj->ref_count++;
  FIL *fp = (FIL *)v->instance->data;
  int len = GET_INT_ARG(1);
  TCHAR buff[len];
  if (f_gets(buff, len, fp)) {
    mrbc_value value = mrbc_string_new_cstr(vm, (const char *)buff);
    SET_RETURN(value);
  } else {
    SET_NIL_RETURN();
  }
}

static void
c_puts(mrbc_vm *vm, mrbc_value v[], int argc)
{
  (v[0]).obj->ref_count++;
  (v[0]).obj->ref_count++;
  FIL *fp = (FIL *)v->instance->data;
  if (f_puts((const TCHAR *)GET_STRING_ARG(1), fp) < 0) {
    // error
  } else {
    SET_NIL_RETURN();
  }
}

static void
c_write(mrbc_vm *vm, mrbc_value v[], int argc)
{
  (v[0]).obj->ref_count++;
  (v[0]).obj->ref_count++;
  FIL *fp = (FIL *)v->instance->data;
  const char *buff = GET_STRING_ARG(1);
  UINT btw = strlen(buff);
  UINT bw;
  FRESULT res;
  res = f_write(fp, (const void *)buff, btw, &bw);
  switch (res) {
    case FR_OK:
      SET_TRUE_RETURN();
      break;
    default:
      SET_NIL_RETURN();
      break;
    // error
  }
}

static void
c_close(mrbc_vm *vm, mrbc_value v[], int argc)
{
  FIL *fp = (FIL *)v->instance->data;
  FRESULT res;
  res = f_close(fp);
}

void
mrbc_init_class_FAT_File(void)
{
  mrbc_class *class_FAT = mrbc_define_class(0, "FAT", mrbc_class_object);
  mrbc_sym symid = mrbc_search_symid("File");
  mrbc_value *v = mrbc_get_class_const(class_FAT, symid);
  mrbc_class *class_FAT_File = v->cls;

  mrbc_define_method(0, class_FAT_File, "new", c_new);
  mrbc_define_method(0, class_FAT_File, "gets", c_gets);
  mrbc_define_method(0, class_FAT_File, "puts", c_puts);
  mrbc_define_method(0, class_FAT_File, "write", c_write);
  mrbc_define_method(0, class_FAT_File, "close", c_close);
}

