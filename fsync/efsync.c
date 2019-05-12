#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <dirent.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

int test_upgrade_fsync(const char *file)
{
	int fd;
	int ret = -1;
    struct stat status;

	if (file) {
		fd = open(file, O_RDONLY);
		if (fd >= 0) {
            ret = fstat(fd, &status);
            if (ret != 0) {close(fd); return -1;}
            if (!(S_ISREG(status.st_mode) || S_ISDIR(status.st_mode))) {close(fd); return -1;}
			do {
				ret = fsync(fd);
			}
			while (EINTR == ret) ;

			close(fd);
			if(ret != 0) {
				printf("sync file error:%s\n", file);
			}
		}
	}
	return ret;
}

void listdir_fsync(const char *name)
{
	DIR *dir;
	struct dirent *entry;

	if (!(dir = opendir(name))) {
		return;
	}

	while ((entry = readdir(dir)) != NULL) {
		char path[1024];

		snprintf(path, sizeof(path), "%s/%s", name, entry->d_name);
		if (entry->d_type == DT_DIR) {
			if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
				continue;
			}

			listdir_fsync(path);
		} else {
			test_upgrade_fsync(path);
		}
	}
	test_upgrade_fsync(name);
	closedir(dir);
}

int main(int argc, char **argv)
{
	if(argc < 2) {
		return 0;
	}
	listdir_fsync(argv[1]);
	return 0;
}
