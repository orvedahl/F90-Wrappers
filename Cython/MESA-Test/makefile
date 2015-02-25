#
# Makefile to compile Cython code
#

# Debugging flag
debug :=

# make cython stuff
cython :=

# which python
python3 := 

# OpenMP/MPI flag
omp :=
mpi :=

# make verbose
verbose := t

# Fortran compiler (choices are "gfortran" or "intel" so far)
f90_comp := gfortran

ifdef python3
    what_python = python3
else
    what_python = python
endif

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

flags += -L$(MESA_DIR)/lib -lnet -leos -lrates -lchem -linterp_2d -linterp_1d -lnum -lcrlibm -lmtx -lconst -lutils -lmesalapack -lmesablas -I$(MESA_DIR)/include
#flags += -L$(MESA_DIR)/lib -lnet -leos -lrates -lchem -linterp_2d -linterp_1d -lnum -lcrlibm -lmtx -lconst -lutils -lmesaklu -lmesalapack -lmesablas -I$(MESA_DIR)/include

# order matters
objects = data_types.f90 errors.f90 mesa_utils.f90 eos/eos_utils.f90 eos/setup_mesa_eos.f90 eos/shutdown_mesa_eos.f90 network/net_utils.f90 eos/MESA_EOS.f90 network/setup_mesa_net.f90 network/shutdown_mesa_net.f90 network/call_mesa_net.f90 wrapper.f90 fortran_driver.f90

# strip the path from all the object files
f90objects = $(notdir $(objects:.f90=.o))

ifdef cython
all: xmain.exe cython_so
else
all: xmain.exe
endif

cython_so: $(objects:.f90=.o)
	@echo
	$(what_python) setup.py build_ext --inplace
	@echo
	@echo "---Success---"
	@echo

xmain.exe: $(objects:.f90=.o)
	@echo
	@echo "Linking $@ ..."
	$(f90_comp) $(flags) -o $@ $(f90objects:.f90=.o)

%.o: %.f90
	@echo
	@echo "Building $@ ..."
	$(f90_comp) $(flags) -c $<

clean:
	-rm -f ./*.o ./*.mod
	-rm -f cython_def.c

realclean: clean
	-rm -f cython_wrapper.so
	-rm -rf build

# debugging tool
print-%: ; @echo $* is $($*)
