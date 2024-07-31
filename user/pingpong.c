#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"



int 
main(void)
{
  int p[2];
  pipe(p);
  char * temp = "1000";
  if(fork() == 0){
    /*a read on a pipe waits for either data to be written or for all file descriptors referring to the write end to be closed*/
    char * temp = "100";
    read(p[0],temp,1 );
    printf("%d: received ping\n",getpid());
    write(p[1], "test",1 );
    exit(0);
  }
  else{
    write(p[1],"test" ,1);
    read(p[0], temp, 1 );
    printf("%d: received pong\n",getpid());
    exit(0);  
  }


}
