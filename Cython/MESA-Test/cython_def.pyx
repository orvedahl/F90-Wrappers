#
# Cython file to call Fortran
#

import numpy
cimport numpy

# define the external subroutine interface. all should be pointers
# i.e. pass by reference (then dont need to mess with the 'value'
# keyword in the fortran source)
cdef extern:
    void initialize_MESA_eos()
#    void finalize_MESA_eos()
    void call_MESA_EOS(int *n_vars, double *xmass, int *eos_input, 
                       double *eos_vars, int *debug, int *eosfail)

    void initialize_MESA_net()
    void finalize_MESA_net()
    void network_rhs_mesa(double *rho, double *T, double *xmass, 
                          int *degenerate, double *eps_nuc, double *dxdt)

##########################################################################
# Network routines
##########################################################################
# initialize the network
# since the network requires a few EOS routines, it is automagically
# initialized by the initialize_MESA_net routine
def setup_MESA_net():
    initialize_MESA_net()

# finalize the network
def shutdown_MESA_net():
    finalize_MESA_net()

# define the python "front end" to the external code
def rhs_mesa_network(double rho, double T,
             numpy.ndarray[numpy.float64_t, ndim=1] xmass, int degenerate):

    cdef int nspec
    cdef double eps_nuc

    nspec = len(xmass)
    eps_nuc = 0.0

    # for proper memory management:
    #     declare output dxdt in python
    #     assign cython dxdt_pass = dxdt wo we can pass &dxdt_pass
    #     because if barfs if you do &dxdt when dxdt is defined in python
    dxdt = numpy.empty((nspec), dtype=numpy.double)
    cdef numpy.ndarray[numpy.float64_t, ndim=1] dxdt_pass =numpy.empty((nspec))
    dxdt_pass = dxdt # dxdt_pass "points" to dxdt

    network_rhs_mesa(&rho, &T, &xmass[0], &degenerate, &eps_nuc, &dxdt_pass[0])

    return dxdt, eps_nuc

##########################################################################
# EOS routines
##########################################################################
# initialize the EOS, allows for using the EOS independent of the network
def setup_MESA_eos():
    initialize_MESA_eos()

# finalize the EOS
def shutdown_MESA_eos():
#    finalize_MESA_eos()
    pass

# define the python "front end" to the external code
def eos(int eos_input, numpy.ndarray[numpy.float64_t, ndim=1] xmass,
        numpy.ndarray[numpy.float64_t, ndim=1] eos_vars, int debug):

    cdef int n_vars, eosfail

    eosfail = 0
    n_vars = len(eos_vars)

    # pass everything by reference, i.e. use the '&'
    # vec[0] since it is an array and the pointer only needs the location
    # of the first element in memory (same thing for arr[0,0])
    call_MESA_EOS(&n_vars, &xmass[0], &eos_input, &eos_vars[0],
                  &debug, &eosfail)

    return

