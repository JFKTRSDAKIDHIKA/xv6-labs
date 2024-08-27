//这些常量指定打开文件时的各种选项和模式
#define O_RDONLY  0x000
#define O_WRONLY  0x001
#define O_RDWR    0x002
#define O_CREATE  0x200
#define O_TRUNC   0x400
#define O_NOFOLLOW 0x800
/*
 * 当在 open 系统调用中使用 O_NOFOLLOW 标志时，
 * 如果路径（path）指向的是一个符号链接（symlink），
 * 则 open 调用不会跟随这个符号链接指向的目标文件，
 * 而是直接返回符号链接本身。
 */
