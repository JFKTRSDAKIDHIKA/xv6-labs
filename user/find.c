#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

struct stat st;
struct dirent de;
char* fmtname(char *);


void recur_(char* path, char* target){
  int fd;
  char buf[512], *p;
  fd = open(path, O_RDONLY);
 // printf("fd : %d\n", fd);
  fstat(fd, &st);// we need to check the type of the file or directory.
//  printf("current dictory information-- \ndev: %d\nino: %d\ntype: %d\nnlink: %d\n size: %d\n", st.dev, st.ino, st.type, st.nlink, st.size);
  if(st.type == 2){
    // need to compare
 //   printf("fmtname(path) = %s, target = %s\n", fmtname(path), target);
    if(strcmp(fmtname(path), target) == 0) {
      printf("%s\n", path);
            }
    close(fd);
    return;
  }
  else if(st.type == 3){
     close(fd);
     return;
  }
  else{// find all the items in this dirctory
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum != 0 && strcmp(de.name , ".") && strcmp(de.name, "..")){// iterate throuth all the subitems.
       // printf("information of dirent :\ninum: %d\nname: %s\n", de.inum, de.name);
        //buffer to store the string parameter.
        strcpy(buf, path);
        p = buf + strlen(buf);//p pointing to the end of the buf, namely '\0'
        *p = '/';
        p = p + 1;
        memmove(p, de.name, DIRSIZ);
	//      p[DIRSIZ] = '\0';
//      printf("next path : %s\n", buf);
        recur_(buf, target);
    }
  }
}
   close(fd);
}

char*
fmtname(char *path) {
   // static char buf[DIRSIZ+1];
    char *p;

    // Find first character after last slash.
    for (p = path + strlen(path); p >= path && *p != '/'; p--)
        ;
    p++;

    // Return blank-padded name.
   // if (strlen(p) >= DIRSIZ)
        return p;
   // memmove(buf, p, strlen(p));
   // memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
   // return buf;
}




int
main(int argc,char*  argv[]){
recur_(argv[1], argv[2]);
exit(0);
}
