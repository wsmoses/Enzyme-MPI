SHELL := bash
#default build suggestion of MPI + OPENMP with gcc on Livermore machines you might have to change the compiler name

# ENZYME_PATH ?= /home/ubuntu/Enzyme/enzyme/build/Enzyme/ClangEnzyme-14.so
# CLANG_PATH ?= /home/ubuntu/llvm-project/build/bin

# ENZYME_PATH ?= /home/wmoses/git/Enzyme/enzyme/build13D/Enzyme/ClangEnzyme-13.so
# CLANG_PATH ?= /mnt/sabrent/wmoses/llvm13/buildall/bin

ENZYME_PATH ?= /home/jhuckelheim/enzyme-sc22/Enzyme/enzyme/build/Enzyme/ClangEnzyme-15.so
CLANG_PATH ?= /home/jhuckelheim/enzyme-sc22/llvm-project/build/bin

#ENZYME_PATH ?= /home/ubuntu/Enzyme/enzyme/build/Enzyme/ClangEnzyme-14.so
#CLANG_PATH ?= /home/ubuntu/llvm-project/build/bin

OPENMP_PATH ?= $(CLANG_PATH)/../projects/openmp/runtime/src
MPI_PATH ?= /soft/libraries/mpi/openmpi/4.1.1/include
OPENMP_LIB ?= $(CLANG_PATH)/../lib/libomp.so

SHELL = /bin/sh
.SUFFIXES: .cc .o

MPI_INC = /soft/libraries/mpi/openmpi/4.1.1/include
MPI_LIB = /soft/libraries/mpi/openmpi/4.1.1/lib

CXX = $(CLANG_PATH)/clang++

SOURCES2.0 = \
	lulesh.cc \
	lulesh-viz.cc \
	lulesh-util.cc \
	lulesh-init.cc
OBJECTS2.0 = $(SOURCES2.0:.cc=.o)

#Default build suggestions with OpenMP for g++
CXXFLAGS = -O3 -I. -Wall -I $(OPENMP_PATH) -I $(MPI_PATH) -fno-exceptions -flegacy-pass-manager -mllvm -enzyme-loose-types -Xclang -load -Xclang $(ENZYME_PATH) -L$(MPI_LIB) -lmpi -mllvm -attributor-max-iterations=128 -mllvm -capture-tracking-max-uses-to-explore=256 -ffast-math -mllvm -memdep-block-scan-limit=70000 -mllvm -dse-memoryssa-walklimit=70000 -mllvm -enzyme-inline 
# -mllvm -enzyme-print -Rpass=enzyme
# enzyme-print-perf
# CXXFLAGS += -mllvm -debug-only=openmp-opt -mllvm -openmp-opt-print-module
# -mllvm -enzyme-attributor=0
# -mllvm -enzyme-print -mllvm -enzyme-print-type


all: ser-single-forward.exe omp-single-forward.exe ompM-single-forward.exe ser-mpi-forward.exe omp-mpi-forward.exe ompM-mpi-forward.exe ser-single-gradient.exe omp-single-gradient.exe ompM-single-gradient.exe ser-mpi-gradient.exe omp-mpi-gradient.exe ompM-mpi-gradient.exe ompOpt-single-forward.exe ompOpt-mpi-forward.exe ompOpt-single-gradient.exe ompOpt-mpi-gradient.exe ser-single-gradientnomat.exe

# all: omp-single-forward.exe omp-single-gradient.exe

simple.ll: simple.cpp
	$(CXX) simple.cpp $(CXXFLAGS) -S -emit-llvm -o $@ 

ser-single-forward.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=0 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ -DFORWARD=1

omp-single-forward.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1 -mllvm -enzyme-omp-opt=0

ompM-single-forward.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1 -mllvm -enzyme-omp-opt=0

ompOpt-single-forward.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1 -mllvm -enzyme-omp-opt=1

ser-mpi-forward.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=1 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ -DFORWARD=1

omp-mpi-forward.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1 -mllvm -enzyme-omp-opt=0

ompM-mpi-forward.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1 -mllvm -enzyme-omp-opt=0

ompOpt-mpi-forward.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1 -mllvm -enzyme-omp-opt=1

ser-single-gradient.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=0 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@

ser-single-gradientnomat.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=0 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ -mllvm -enzyme-rematerialize=0

omp-single-gradient.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -mllvm -enzyme-omp-opt=0

ompM-single-gradient.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -mllvm -enzyme-omp-opt=0

ompOpt-single-gradient.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -mllvm -enzyme-omp-opt=1

ser-mpi-gradient.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=1 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@

omp-mpi-gradient.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -mllvm -enzyme-omp-opt=0

ompM-mpi-gradient.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -mllvm -enzyme-omp-opt=0

ompOpt-mpi-gradient.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -mllvm -enzyme-omp-opt=1

############################# VERIFICATION
verify: verifySerial verifyOMP verifyMPI

verifySerial: ser-single-forward-verify.exe ser-single-gradient-verify.exe ser-single-gradientnomat-verify.exe 
	./ser-single-forward-verify.exe -s 10 -i 1 | grep checksum
	./ser-single-gradient-verify.exe -s 10 -i 1 | grep checksum
	./ser-single-gradientnomat-verify.exe -s 10 -i 1 | grep checksum

verifyOMP: omp-single-forward-verify.exe ompM-single-forward-verify.exe ompOpt-single-forward-verify.exe omp-single-gradient-verify.exe ompM-single-gradient-verify.exe ompOpt-single-gradient-verify.exe 
	./omp-single-forward-verify.exe -s 10 -i 1 | grep checksum
	./ompM-single-forward-verify.exe -s 10 -i 1 | grep checksum
	./omp-single-gradient-verify.exe -s 10 -i 1 | grep checksum
	./ompM-single-gradient-verify.exe -s 10 -i 1 | grep checksum
	./ompOpt-single-forward-verify.exe -s 10 -i 1 | grep checksum
	./ompOpt-single-gradient-verify.exe -s 10 -i 1 | grep checksum

verifyMPI: ser-mpi-forward-verify.exe omp-mpi-forward-verify.exe ompM-mpi-forward-verify.exe ompOpt-mpi-forward-verify.exe ser-mpi-gradient-verify.exe omp-mpi-gradient-verify.exe ompM-mpi-gradient-verify.exe ompOpt-mpi-gradient-verify.exe
	./ser-mpi-forward-verify.exe -s 10 -i 1 | grep checksum
	./omp-mpi-forward-verify.exe -s 10 -i 1 | grep checksum
	./ompM-mpi-forward-verify.exe -s 10 -i 1 | grep checksum
	./ser-mpi-gradient-verify.exe -s 10 -i 1 | grep checksum
	./omp-mpi-gradient-verify.exe -s 10 -i 1 | grep checksum
	./ompM-mpi-gradient-verify.exe -s 10 -i 1 | grep checksum
	./ompOpt-mpi-forward-verify.exe -s 10 -i 1 | grep checksum
	./ompOpt-mpi-gradient-verify.exe -s 10 -i 1 | grep checksum

#######

ser-single-forward-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=0 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ -DFORWARD=1 -DVERIFY=1

omp-single-forward-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1 -mllvm -enzyme-omp-opt=0 -DVERIFY=1

ompM-single-forward-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1 -mllvm -enzyme-omp-opt=0 -DVERIFY=1

ompOpt-single-forward-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1 -mllvm -enzyme-omp-opt=1 -DVERIFY=1

ser-mpi-forward-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=1 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ -DFORWARD=1 -DVERIFY=1

omp-mpi-forward-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1 -mllvm -enzyme-omp-opt=0 -DVERIFY=1

ompM-mpi-forward-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1 -mllvm -enzyme-omp-opt=0 -DVERIFY=1

ompOpt-mpi-forward-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -DFORWARD=1 -mllvm -enzyme-omp-opt=1 -DVERIFY=1

ser-single-gradient-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=0 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ -DVERIFY=1

ser-single-gradientnomat-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=0 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ -mllvm -enzyme-rematerialize=0 -DVERIFY=1

omp-single-gradient-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -mllvm -enzyme-omp-opt=0 -DVERIFY=1

ompM-single-gradient-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -mllvm -enzyme-omp-opt=0 -DVERIFY=1

ompOpt-single-gradient-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=0 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -mllvm -enzyme-omp-opt=1 -DVERIFY=1

ser-mpi-gradient-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=1 $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ -DVERIFY=1

omp-mpi-gradient-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=0 -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -mllvm -enzyme-omp-opt=0 -DVERIFY=1

ompM-mpi-gradient-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -mllvm -enzyme-omp-opt=0 -DVERIFY=1

ompOpt-mpi-gradient-verify.exe: $(SOURCES2.0)
	$(CXX) -DOMP_MERGE=1 -DUSE_MPI=1 -fopenmp $(SOURCES2.0) $(CXXFLAGS) -lm -o $@ $(OPENMP_LIB) -mllvm -enzyme-omp-opt=1 -DVERIFY=1


clean:
	/bin/rm -f *.o *~ *.exe
	/bin/rm -rf *.dSYM

