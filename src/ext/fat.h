#ifndef _FAT_H
#define _FAT_H

#include <mrubyc.h>

#include <ff.h>

#ifdef __cplusplus
extern "C" {
#endif

void mrbc_init_class_FAT(void);
void mrbc_raise_iff_f_error(mrbc_vm *vm, FRESULT res, const char *func);

#ifdef __cplusplus
}
#endif

#endif /* _FAT_H */


