#default build suggestion of MPI + OPENMP with gcc on Livermore machines you might have to change the compiler name

ENZYME_PATH ?= /home/wmoses/git/Enzyme/enzyme/build13Fast/Enzyme/ClangEnzyme-13.so
CLANG_PATH ?= /mnt/sabrent/wmoses/llvm13/buildallfast/bin/
OPENMP_PATH ?= $(CLANG_PATH)/../projects/openmp/runtime/src
MPI_PATH ?= /usr/lib/x86_64-linux-gnu/openmpi/include
OPENMP_LIB ?= $(CLANG_PATH)/../lib/libomp.so

SHELL = /bin/sh
.SUFFIXES: .cc .o

LULESH_EXEC = lulesh2.0

MPI_INC = /opt/local/include/openmpi
MPI_LIB = /opt/local/lib

CXX = $(CLANG_PATH)/clang++ -DUSE_MPI=1

SOURCES2.0 = \
	lulesh.cc \
	lulesh-viz.cc \
	lulesh-util.cc \
	lulesh-init.cc
OBJECTS2.0 = $(SOURCES2.0:.cc=.o)

#Default build suggestions with OpenMP for g++
CXXFLAGS = -O3 -I. -Wall -I $(OPENMP_PATH) -I $(MPI_PATH) -fno-exceptions -fno-vectorize -fno-unroll-loops -mllvm -enzyme-print -Rpass=enzyme -fno-experimental-new-pass-manager -mllvm -enzyme-print-perf -mllvm -enzyme-loose-types -Xclang -load -Xclang $(ENZYME_PATH)
# CXXFLAGS = -flto=full -g -O3 -fopenmp -I. -Wall -I $(OPENMP_PATH) -I $(MPI_PATH)
LDFLAGS = -O3 -fopenmp -lmpi
# LDFLAGS = -O3 -fopenmp -lmpi -flto=full -fuse-ld=lld -Wl,--lto-legacy-pass-manager -Wl,-mllvm=-load=$(ENZYME_PATH) -Wl,-mllvm=-enzyme-print -Wl,-mllvm=-enzyme-loose-types -Wl,-mllvm=-enzyme-print-perf

#Below are reasonable default flags for a serial build
#CXXFLAGS = -g -O3 -I. -Wall
#LDFLAGS = -g -O3 

#common places you might find silo on the Livermore machines.
#SILO_INCDIR = /opt/local/include
#SILO_LIBDIR = /opt/local/lib
#SILO_INCDIR = ./silo/4.9/1.8.10.1/include
#SILO_LIBDIR = ./silo/4.9/1.8.10.1/lib

#If you do not have silo and visit you can get them at:
#silo:  https://wci.llnl.gov/codes/silo/downloads.html
#visit: https://wci.llnl.gov/codes/visit/download.html

#below is and example of how to make with silo, hdf5 to get vizulization by default all this is turned off.  All paths are Livermore specific.
#CXXFLAGS = -g -DVIZ_MESH -I${SILO_INCDIR} -Wall -Wno-pragmas
#LDFLAGS = -g -L${SILO_LIBDIR} -Wl,-rpath -Wl,${SILO_LIBDIR} -lsiloh5 -lhdf5

.cc.o: lulesh.h
	@echo "Building $<"
	$(CXX) -c $(CXXFLAGS) -o $@  $<

all: $(LULESH_EXEC)

$(LULESH_EXEC): $(OBJECTS2.0)
	@echo "Linking"
	$(CXX) $(OBJECTS2.0) $(LDFLAGS) -lm -o $@ $(OPENMP_LIB)

clean:
	/bin/rm -f *.o *~ $(OBJECTS) $(LULESH_EXEC)
	/bin/rm -rf *.dSYM

tar: clean
	cd .. ; tar cvf lulesh-2.0.tar LULESH-2.0 ; mv lulesh-2.0.tar LULESH-2.0

