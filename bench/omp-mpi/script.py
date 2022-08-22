#!/usr/bin/python3
import os
import pathlib
scriptdir = pathlib.Path(__file__).parent.resolve()

def printfun(rank, numthreads, blocklist,itercount):
  for s in blocklist:
      for mode in ["forward","gradient"]:
        os.system("OMP_NUM_THREADS={}  mpirun -n {} taskset -c 0-{} numactl -i all ".format(numthreads, rank, numthreads*rank-1) + str(scriptdir) + "/../../omp-mpi-{}.exe -s {} -i {} > " .format(mode,s,itercount) + str(scriptdir) + "/omp-mpi-{}_{}_{}_{}_{}.txt".format(mode,rank,numthreads,itercount,s))

itercount=100
printfun(1, 2, [48], itercount)
printfun(8, 2, [48], itercount)
printfun(27, 2, [48], itercount)
