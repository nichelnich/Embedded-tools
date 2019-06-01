
#if DEFINE_EXECINFO
#include <execinfo.h>
{
  int i;
  void *addresses[64];
  char **test_symbols;
  int size = backtrace(addresses, 64);
  test_symbols = backtrace_symbols(addresses, size);
  for (i = 0; i < size; i++)
  {
    printf("========================:%s\n", test_symbols[i]);
  }
}
#endif

/*
uclibc  不支持<execinfo.h> :(

添加编译选项
CFLAGS+= -mapcs-frame
还要生成map文件比对地址
-Wl,-Map,device.map

通过
__builtin_return_address(0);  
__builtin_frame_address(0);
导出当前帧。
里面包含上一级栈帧逐级回溯。
*/

//code:

#define RECORD_FILE_SIZE 2048
extern unsigned long __etext;
extern unsigned long __executable_start;

void back_trace(void)
{

  // volatile int *i;
  volatile unsigned int *pfun;
  int m = 1;
  int *ret = __builtin_return_address(0);
  int *cstack0 = __builtin_frame_address(0);
  unsigned int ptextb = (int)(&__executable_start);
  unsigned int ptexte = (int)(&__etext);

  printf("EXE: 0x%x-0x%x\r\n", ptextb, ptexte);

#ifndef RESET_LOG_PRINT
  FILE *reset_record_fd;
  struct stat statf;

  printf("\r\nRESET\r\n");
  reset_record_fd = fopen("/var/config/reset_record.txt", "a+");
  fstat(fileno(reset_record_fd), &statf);
  // printf("filesize: %ld \r\n",statf.st_size);
  if (statf.st_size >= RECORD_FILE_SIZE)
  {
    fclose(reset_record_fd);
    reset_record_fd = fopen("/var/config/reset_record.txt", "w+");
  }
  //
#else
  syslog("RESET!\r\n");
#endif

#ifndef RESET_LOG_PRINT
  printf("return0 addr:%p\r\n", ret);
  fprintf(reset_record_fd, "\r\nreturn0 addr:%p\r\n", ret);
#else
  syslog("return0 addr:%p\r\n", ret);
#endif

  pfun = *(cstack0 - 3);

  do
  {
#ifndef RESET_LOG_PRINT
    printf("return%d addr:0x%x\r\n", m, *(pfun - 1));
    fprintf(reset_record_fd, "return%d addr:0x%x\r\n", m, *(pfun - 1));
#else
    syslog("return%d addr:0x%x\r\n", m, *(pfun - 1));
#endif

    pfun = *(pfun - 3);
    m++;
  } while ((ptextb < (*(pfun - 1))) && ((*(pfun - 1)) < ptexte));

#ifndef RESET_LOG_PRINT
  printf("return%d addr:0x%x\r\n", m, *(pfun - 1));
  fprintf(reset_record_fd, "return%d addr:0x%x\r\n", m, *(pfun - 1));
#else
  syslog("return%d addr:0x%x\r\n", m, *(pfun - 1));
#endif

#ifndef RESET_LOG_PRINT
  printf("stack0 addr:%p\r\n", cstack0);
  fprintf(reset_record_fd, "stack0 addr:%p\r\n", cstack0);
  fflush(reset_record_fd);
  fclose(reset_record_fd);
  //save
#else
  syslog("stack0 addr:%p\r\n", cstack0);
#endif

  /*
     #define STACK_DEEP 24
     for(i =cstack0-STACK_DEEP;i < cstack0+1; i++)
     {
        #ifndef  RESET_LOG_PRINT
             printf("stack [%p]:0x%x \r\n", i,*i);
           #else
             syslog("stack [%p]:0x%x \r\n", i,*i );
           #endif
     }  
     #undef STACK_DEEP
     */

  sleep(3);

  return;
}
