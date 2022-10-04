
#ifndef RAM_DISK_DEFINED
#define RAM_DISK_DEFINED

#ifdef __cplusplus
extern "C" {
#endif

int RAM_disk_initialize(void);
int RAM_disk_status(void);
int RAM_disk_read(BYTE *buff, LBA_t sector, UINT count);
int RAM_disk_write(const BYTE *buff, LBA_t sector, UINT count);
DRESULT RAM_disk_ioctl(BYTE cmd, int *buff);
DWORD get_fattime(void);

#ifdef __cplusplus
}
#endif

#endif /* RAM_DISK_DEFINED */
