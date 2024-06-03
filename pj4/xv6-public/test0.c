#include "types.h"
#include "stat.h"
#include "user.h"

int 
main(int argc, char* argv[])
{
  printf(1, "[Test 0] default\n");

  int numfp = countfp();
  int numvp = countvp();
  int numpp = countpp();
  int numptp = countptp();
  // printf(1, "numfp: %d\n", numfp);
  // printf(1, "numvp: %d\n", numvp);
  // printf(1, "numpp: %d\n", numpp);
  // printf(1, "numptp: %d\n", numptp);

  sbrk(4096);

  int numfpa = countfp();
  int numvpa = countvp();
  int numppa = countpp();
  int numptpa = countptp();
  // printf(1, "numfpa: %d\n", numfpa);
  // printf(1, "numvpa: %d\n", numvpa);
  // printf(1, "numppa: %d\n", numppa);
  // printf(1, "numptpa: %d\n", numptpa);
  
  printf(1, "ptp: %d %d\n", numptp, numptpa);

  if((numvp == numpp) && (numvpa == numppa) && (numfp - numfpa == 1))
    printf(1, "[Test 0] pass\n\n");
  else
    printf(1, "[Test 0] fail\n\n");

  exit();
}

