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

src_dirs = eos network

ifdef python3
    what_python = python3
else
    what_python = python
endif

ifdef debug
    flags = ${my_gfortran_debug}
    debug_suf = .debug
else
    flags = -O2 -fno-range-check
endif

ifdef mpi
    libdir = /usr/lib64/openmpi/lib/
    libinc = /usr/lib64/openmpi/lib/
    flags += -L$(libdir) -lmpi -I$(libinc)
    mpi_suf = .mpi
endif

ifdef omp
    flags += -fopenmp
    omp_suf = .omp
endif

suf = $(f90_comp)$(debug_suf)$(omp_suf)$(mpi_suf)

exe = xmain.$(suf).exe

tname = t
tdir = $(tname)/$(suf)
odir = $(tdir)/o
mdir = $(tdir)/m

vpath_loc = $(foreach dir, $(src_dirs), $(dir))

#include $(GPack_files)

# order matters
sobjects = data_types.f90 errors.f90 mesa_utils.f90 eos/eos_utils.f90 eos/setup_mesa_eos.f90 eos/shutdown_mesa_eos.f90 network/net_utils.f90 eos/MESA_EOS.f90 network/setup_mesa_net.f90 network/shutdown_mesa_net.f90 network/call_mesa_net.f90 wrapper.f90 fortran_driver.f90

# strip the path from all the object files
f90objects = $(notdir $(sobjects:.f90=.o))

objects = $(addprefix $(odir)/, $(f90objects:.f90=.o))

vpath %.f90 . $(vpath_loc)

ifdef cython
all: cython_so $(exe)
else
all: $(exe)
endif

microphys = -leos -lnet -lrates -lchem
numerics = -linterp_2d -linterp_1d -lnum -lf2crlibm -lcrlibm -lmtx
utilities = -lconst -lutils
matrix = -lmesalapack -lmesablas
#matrix = -lmesaklu -lmesalapack -lmesablas
libs = $(microphys) $(numerics) $(utilities) $(matrix)

mesalibs = -L$(MESA_DIR)/lib $(libs)
mesaincs = -I$(MESA_DIR)/include

cython_so: $(objects:.f90=.o)
	@echo
	$(what_python) setup.py build_ext --inplace
	@echo
	@echo "---Success---"
	@echo

$(exe): $(objects)
	@echo
	@echo "Linking $@ ..."
	$(f90_comp) $(flags) $(mesalibs) $(mesaincs) -fPIC -J$(mdir) -I$(mdir) -o $(exe) $(objects)

$(odir)/%.o: %.f90
	@if [ ! -d $(odir) ]; then mkdir -p $(odir); fi
	@if [ ! -d $(mdir) ]; then mkdir -p $(mdir); fi
	@echo
	@echo "Building $< ..."
	$(f90_comp) $(flags) $(mesalibs) $(mesaincs) -fPIC -J$(mdir) -I$(mdir) -c $< -o $@

clean:
	-rm -f ./*.o $(odir)/*.o
	-rm -f ./*.mod $(mdir)/*.mod
	-rm -f ./*.$(suf).exe
	-rm -f cython_def.c

realclean: clean
	-rm -f cython_wrapper.so
	-rm -rf build
	-rm -rf $(tname)
	-rm -f ./*.exe

# debugging tool
print-%: ; @echo $* is $($*)

