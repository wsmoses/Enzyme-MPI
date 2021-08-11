#default build suggestion of MPI + OPENMP with gcc on Livermore machines you might have to change the compiler name

ENZYME_PATH ?= /home/ubuntu/Enzyme/enzyme/build/Enzyme/ClangEnzyme-14.so
CLANG_PATH ?= /home/ubuntu/llvm-project/build/bin

OPENMP_PATH ?= $(CLANG_PATH)/../projects/openmp/runtime/src
MPI_PATH ?= /usr/lib/x86_64-linux-gnu/openmpi/include
OPENMP_LIB ?= $(CLANG_PATH)/../lib/libomp.so

SHELL = /bin/sh
.SUFFIXES: .cc .o

MPI_INC = /opt/local/include/openmpi
MPI_LIB = /opt/local/lib

CXX = $(CLANG_PATH)/clang++

SOURCES2.0 = \
	lulesh.cc \
	lulesh-viz.cc \
	lulesh-util.cc \
	lulesh-init.cc
OBJECTS2.0 = $(SOURCES2.0:.cc=.o)

#Default build suggestions with OpenMP for g++
CXXFLAGS = -O3 -I. -Wall -I $(OPENMP_PATH) -I $(MPI_PATH) -fno-exceptions -fno-vectorize -fno-unroll-loops -mllvm -enzyme-print -Rpass=enzyme -fno-experimental-new-pass-manager -mllvm -enzyme-print-perf -mllvm -enzyme-loose-types -Xclang -load -Xclang $(ENZYME_PATH) -lmpi


all: ser-single-forward.exe omp-single-forward.exe ser-mpi-forward.exe omp-mpi-forward.exe ser-single-gradient.exe omp-single-gradient.exe ser-mpi-gradient.exe omp-mpi-gradient.exe

ser-single-forward.exe: $(SOURCES2.0)
	$(CXX) -DUSE_MPI=0 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1

omp-single-forward.exe: $(SOURCES2.0)
	$(CXX) -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1

ser-mpi-forward.exe: $(SOURCES2.0)
	$(CXX) -DUSE_MPI=1 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1

omp-mpi-forward.exe: $(SOURCES2.0)
	$(CXX) -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1

ser-single-gradient.exe: $(SOURCES2.0)
	$(CXX) -DUSE_MPI=0 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB)

omp-single-gradient.exe: $(SOURCES2.0)
	$(CXX) -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB)

ser-mpi-gradient.exe: $(SOURCES2.0)
	$(CXX) -DUSE_MPI=1 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB)

omp-mpi-gradient.exe: $(SOURCES2.0)
	$(CXX) -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB)

clean:
	/bin/rm -f *.o *~ *.exe
	/bin/rm -rf *.dSYM

