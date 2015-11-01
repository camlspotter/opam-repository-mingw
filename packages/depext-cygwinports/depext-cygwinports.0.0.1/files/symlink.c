#include <windows.h>
#include <process.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "config.h"

int
main(int argc, char **argv)
{
  char **new_argv;
  int i;
  const int nargc = argc == 0 ? (argc + 2) : (argc + 1);
  int code;

  new_argv = malloc(nargc * sizeof (char *) );
  if (new_argv == 0){
    fputs("out of memory\n",stderr);
    exit(2);
  }
  new_argv[0] = PKG_CONFIG;
  for ( i=1 ; i < argc ; ++i ){
    new_argv[i] = argv[i];
  }
  new_argv[nargc-1] = NULL;
  code = _spawnv(_P_WAIT, new_argv[0] , (const char **) new_argv );
  if (code == -1) {
    perror("Cannot exec pkg-config");
    exit(127);
  }
  exit(code);
}
