#!/usr/bin/python3.8
import os

def printfun(numthreads, blocklist,itercount):
  for s in blocklist:
      for mode in ["forward","gradient"]:
        os.system("OMP_NUM_THREADS={}  taskset -c 0-{} numactl -i all ~/enzyme-sc22/LULESH-CPP/omp-single-{}.exe -s {} -i {} > omp-single_{}_{}_{}_{}.txt".format(numthreads, numthreads-1, mode, s, itercount, mode,numthreads, itercount, s))

itercount=100
#Strong scaling
for numthreads in [1,8,16,24,32,40,48,56,64]:
  printfun(numthreads, [96], itercount)

#Weak scaling
printfun(1, [24], itercount)
printfun(8, [48], itercount)
printfun(27, [72], itercount)
printfun(64, [96], itercount)
