#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main()
{ 
  int index = 0;
  int p[2];
  pipe(p);
  int numbers[34];
  int buffer[34];
  int newnums[34] = {0};
  for(int i = 2; i <= 35; i++){
    int index = i - 2;
    numbers[index] = i;
  }


if(fork() == 0){//child process1
  close(p[1]);
  read(p[0],buffer , 34*sizeof(int));
  close(p[0]);
  printf("prime %d\n",buffer[0]);
  index = 0;
  for(int i = 1; i <= 33; i++){
      if(buffer[i] % buffer[0] != 0 ){
        newnums[index] = buffer[i];
	index ++;
      }
    }
  int p[2];
  pipe(p);


    if(fork() == 0){//child process2
      close(p[1]);
      read(p[0],buffer , 34*sizeof(int));
      close(p[0]);
      printf("prime %d\n", buffer[0]);
      index = 0;
      for(int i = 1; i <= 33; i++){
	i = i - 1;
	newnums[i] = 0;
	i = i + 1;
        if(buffer[i] % buffer[0] != 0 ){
	  newnums[index] = buffer[i];
          index ++;
        } 
      }
      int p[2];
      pipe(p);


      if(fork() == 0){//child process3
        close(p[1]);
        read(p[0],buffer , 34*sizeof(int));
	close(p[0]);
        printf("prime %d\n", buffer[0]);
	index = 0;
        for(int i = 1; i <= 33; i++){
          i = i - 1;
          newnums[i] = 0;
          i = i + 1;
          if(buffer[i] % buffer[0] != 0 ){
            newnums[index] = buffer[i];
            index ++;
        }
      }
      int p[2];
      pipe(p);

        if(fork() == 0){//child process4
	   close(p[1]);
           read(p[0],buffer , 34*sizeof(int));
	   close(p[0]);
           printf("prime %d\n", buffer[0]);
           index = 0;
           for(int i = 1; i <= 33; i++){
             i = i - 1;
             newnums[i] = 0;
             i = i + 1;
             if(buffer[i] % buffer[0] != 0 ){
               newnums[index] = buffer[i];
               printf("prime %d\n", newnums[index]);
               index ++;
        }
	   }



	     exit(0);
	}else{//child process3
         close(p[0]);
         write(p[1], newnums,4 *  sizeof(newnums));
         close(p[1]);
	 wait(0);
         exit(0);
	
	}
      
     














      }else{//child process 2
         close(p[0]);
         write(p[1], newnums,4 *  sizeof(newnums));
         close(p[1]);
	 wait(0);
         exit(0);
      
      }



       
       
     }else{//child process 1
	 close(p[0]);
	 write(p[1], newnums,4 *  sizeof(newnums)); 
	 close(p[1]);
	 wait(0);
         exit(0);	
       } 


  
}else{//main process
  close(p[0]);
  write(p[1], numbers,4 *  sizeof(numbers));
  close(p[1]);
  wait(0);
  exit(0);

}
}
