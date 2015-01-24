#
# Makefile to compile Cython code
#

# cython
cython :=

# Debugging flag
debug :=

# OpenMP/MPI flag
omp :=
mpi :=

# make verbose
verbose := t

# Fortran compiler (choices are "gfortran" or "intel" so far)
ifdef mpi
f90_comp := mpif90
else
f90_comp := gfortran
endif

ifdef debug
    flags = ${my_gfortran_debug} -fPIC
    debsuf = .debug
else
    flags = -O2 -fno-range-check -fPIC
    debsuf =
endif

ifdef mpi
    #libdir = /usr/lib64/openmpi/lib/
    #libinc = /usr/lib64/openmpi/lib/
    #flags += -L$(libdir) -lmpi -I$(libinc)
    mpisuf = .mpi
else
    mpisuf =
endif

ifdef omp
    flags += -fopenmp
endif

# order matters
sources = bl_types.f90 bl_IO.f90 sort_i.f90 vector_i.f90
ifdef mpi
sources += parallel.f90
else
sources += parallel_stubs.f90
endif
sources += relax-mpi.f90 main.f90

#mods = constants.mod dot_prod_mod.mod vector_ops_wrap_mod.mod vector_ops.mod

exe = xmain$(mpisuf)$(debsuf).exe

ifdef cython
all: python
else
all: $(exe)
endif

objects = $(sources:.f90=.o)

python: $(objects)
	@echo
	python setup.py build_ext --inplace
	@echo
	@echo "---Success---"
	@echo

$(exe): $(objects)
	@echo
	@echo "Building $@ ..."
	$(f90_comp) $(flags) -o $@ $(objects)
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
	-rm -f $(objects)
	-rm -f $(objects:.o=.mod)
	-rm -f ./*.o ./*.mod

realclean: clean
	-rm -f cython_wrapper.so
	-rm -f cython_def.c
	-rm -rf build
	-rm -f $(exe)
	-rm -f ./*.exe

