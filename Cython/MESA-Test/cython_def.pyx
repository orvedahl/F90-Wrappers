#
# Cython file to call Fortran
#

import numpy
cimport numpy

# define the external subroutine interface. all should be pointers
# i.e. pass by reference (then dont need to mess with the 'value'
# keyword in the fortran source)
cdef extern:
    void call_MESA_EOS(int *n_vars, int *eos_input, double *eos_vars,
                       int *debug, int *eosfail)

    void initialize_MESA_eos()

    void finalize_MESA_eos()

##########################################################################
# Network routines
##########################################################################
# initialize the network
def setup_MESA_net():
    initialize_MESA_net()

# finalize the network
def shutdown_MESA_net():
    finalize_MESA_net()

# define the python "front end" to the external code
def network():
    pass
    return

##########################################################################
# EOS routines
##########################################################################
# initialize the EOS
def setup_MESA_eos():
    initialize_MESA_eos()

# finalize the EOS
def shutdown_MESA_eos():
    finalize_MESA_eos()

# define the python "front end" to the external code
def eos(int eos_input, numpy.ndarray[numpy.float64_t, ndim=1] eos_vars,
        int debug):

    cdef int n_vars, eosfail

    eosfail = 0
    n_vars = len(eos_vars)

    # pass everything by reference, i.e. use the '&'
    # vec[0] since it is an array and the pointer only needs the location
    # of the first element in memory (same thing for arr[0,0])
    call_MESA_EOS(&n_vars, &eos_input, &eos_vars[0], &debug, &eosfail)

    return

