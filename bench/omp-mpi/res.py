#!/usr/bin/python3
import os

def printfun(rank, numthreads, blocklist,itercount,mode):
     for s in blocklist:
        os.system("echo -n {},{},{}, >> results.txt".format(rank,numthreads,s))
        os.system("grep  Elapsed omp-mpi{}_{}_{}_{}_{}.txt >> results.txt".format(mode,rank,numthreads, itercount, s))
     os.system("sed -i \"s/Elapsed time         =   //g\" results.txt")
     os.system("sed -i \"s/ (s)//g\" results.txt")

os.system("rm results.txt")
itercount=100
#Strong scaling
for mode in ["-forward","-gradient"]:
  printfun(1, 2, [48], itercount,mode)
  printfun(8, 2, [48], itercount,mode)
  printfun(27, 2, [48], itercount,mode)
