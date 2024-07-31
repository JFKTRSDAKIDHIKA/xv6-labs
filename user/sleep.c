#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if(argc == 0)
	  exit(1);
  int t = atoi(argv[1]);
  if(sleep(t) < 0)
	exit(1);
  exit(0);  
}
