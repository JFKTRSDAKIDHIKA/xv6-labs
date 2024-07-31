#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"



int 
main(int argc, char* argv[MAXARG]){
//  printf("fname: %s\n", argv[1]);
  for(int i = 2; i <= argc - 1; i++){
   // printf("parameter%d: %s\n", i - 1, argv[i]);
  }
  char buf[512];
  char * p = buf;
  int n = 0;
  int flag = 1;
  do{
      p = buf;
      n = 0;
  do{ 
      flag = read(0, p, 1);
     // printf("flag : %d\n", flag);
      if(buf[n] == '\n')
      {
              buf[n] = '\0';
	      break;
      }
   // printf("buff[%d] = %c\n", n, buf[n]);
    n++;
    p = p + 1;
  }while(flag == 1);
 if(flag != 0){
  // printf("buf: %s, size is: %d\n", buf, strlen(buf));
//  printf("argc: %d\n", argc);
 // printf("argv: %s %s %s\n",*( argv+1),*( argv+2),*( argv+3));
  char** new_argv = malloc((argc + 2) * sizeof(char*)); 
  for (int i = 0; i < argc - 1; i++) {
    new_argv[i] = argv[i + 1];
  }
  new_argv[argc-1] = buf;
  new_argv[argc] = 0; 
 // printf("new_argv:\n1: %s\n2: %s\n3: %s\n4: %s\n",*(new_argv),*(new_argv + 1),*(new_argv + 2),*(new_argv + 3));
   int  pid = fork();
   if(pid == 0){
   exec(argv[1], new_argv);
   }else{
   wait(0);
   }
 }
  
  }while(flag != 0);




  exit(0);
}
