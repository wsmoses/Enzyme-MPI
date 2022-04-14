#!/usr/bin/python3.8
import os

def printfun(rank, numthreads, blocklist,itercount):
  for s in blocklist:
      for mode in ["forward","gradient"]:
        os.system("OMP_NUM_THREADS={}  mpirun -n {} taskset -c 0-{} numactl -i all ~/enzyme-sc22/LULESH-CPP/omp-mpi-{}.exe -s {} -i {} > omp-mpi-{}_{}_{}_{}_{}.txt".format(numthreads, rank, numthreads*rank-1,mode,s,itercount,mode,rank,numthreads,itercount,s))

itercount=100
printfun(1, 2, [48], itercount)
printfun(8, 2, [48], itercount)
printfun(27, 2, [48], itercount)
