#!/usr/bin/python3.8
import os

def printfun(rank, blocklist,itercount):
  for s in blocklist:
      for mode in ["forward","gradient"]:
        os.system("mpirun -n {} taskset -c 0-{} numactl -i all ~/enzyme-sc22/LULESH-CPP/ser-mpi-{}.exe -s {} -i {} > ser-mpi_{}_{}_{}_{}.txt".format(rank,rank-1,mode,s,itercount,mode,rank,itercount,s))

itercount=100
printfun(1, [96],itercount)
printfun(8, [96],itercount)
printfun(27, [96],itercount)
printfun(64, [96],itercount)
