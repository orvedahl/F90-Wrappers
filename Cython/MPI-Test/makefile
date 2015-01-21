#
# Makefile to compile Cython code
#

# Debugging flag
debug :=

# OpenMP/MPI flag
omp :=
mpi :=

# make verbose
verbose := t

# Fortran compiler (choices are "gfortran" or "intel" so far)
f90_comp := gfortran

ifdef debug
    flags = ${my_gfortran_debug} -fPIC
else
    flags = -O2 -fno-range-check -fPIC
endif

ifdef mpi
    libdir = /usr/lib64/openmpi/lib/
    libinc = /usr/lib64/openmpi/lib/
    flags += -L$(libdir) -lmpi -I$(libinc)
endif

ifdef omp
    flags += -fopenmp
endif

# order matters
objects = const_orig.f90 dot_prod_orig.f90 vectors_orig.f90 wrapper.f90
mods = constants.mod dot_prod_mod.mod vector_ops_wrap_mod.mod vector_ops.mod

all: cython

cython: $(objects:.f90=.o)
	@echo
	python setup.py build_ext --inplace
	@echo
	@echo "---Success---"
	@echo

%.o: %.f90
	@echo
	@echo "Building $@ ..."
	$(f90_comp) $(flags) -c $<
#$(f90_comp) $(flags) -c $< -o $@

clean:
	-rm -f $(mods)
	-rm -f $(objects:.f90=.o)
	-rm -f $(objects:.f90=.mod)

realclean: clean
	-rm -f cython_wrapper.so
	-rm -f cython_def.c
	-rm -rf build

