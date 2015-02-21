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

flags += -L$(MESA_DIR)/lib -lnet -leos -lrates -lchem -linterp_2d -linterp_1d -lnum -lcrlibm -lmtx -lconst -lutils -lmesaklu -lmesalapack -lmesablas -I$(MESA_DIR)/include

# order matters
objects = data_types.f90 errors.f90 mesa_utils.f90 eos/eos_utils.f90 eos/setup_mesa_eos.f90 eos/shutdown_mesa_eos.f90 network/net_utils.f90 eos/MESA_EOS.f90 network/setup_mesa_net.f90 network/shutdown_mesa_net.f90 network/call_mesa_net.f90 wrapper.f90

all: cython

cython: $(objects:.f90=.o)
	@echo
	python3 setup.py build_ext --inplace
	@echo
	@echo "---Success---"
	@echo

%.o: %.f90
	@echo
	@echo "Building $@ ..."
	$(f90_comp) $(flags) -c $<
#$(f90_comp) $(flags) -c $< -o $@

clean:
	-rm -f ./*.o ./*.mod
	-rm -f cython_def.c

realclean: clean
	-rm -f cython_wrapper.so
	-rm -rf build

