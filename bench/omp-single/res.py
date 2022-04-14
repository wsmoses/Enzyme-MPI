#!/usr/bin/python3.8
import os

def printfun(numthreads, blocklist,itercount,mode):
     for s in blocklist:
        os.system("echo -n {},{}, >> results.txt".format(numthreads,s))
        os.system("grep  Elapsed omp-single{}_{}_{}_{}.txt >> results.txt".format(mode,numthreads, itercount, s))
     os.system("sed -i \"s/Elapsed time         =   //g\" results.txt")
     os.system("sed -i \"s/ (s)//g\" results.txt")

os.system("rm results.txt")
itercount=100
#Strong scaling
for mode in ["_forward","_gradient"]:
  for numthreads in [1,8,16,24,32,40,48,56,64]:
    printfun(numthreads, [96], itercount,mode)

#Weak scaling
for mode in ["_forward","_gradient"]:
  printfun(1, [24], itercount,mode)
  printfun(8, [48], itercount,mode)
  printfun(27, [72], itercount,mode)
  printfun(64, [96], itercount,mode)
