#
# Cython file to call Fortran
#

import numpy
cimport numpy

# define the external subroutine interface. all should be pointers
# i.e. pass by reference (then dont need to mess with the 'value'
# keyword in the fortran source)
cdef extern:
    void vector_ops_wrap(int *n, double *A, double *B, double *C, double *dot)

# define the python "front end" to the external code
def vector_ops_f90(int n, numpy.ndarray[numpy.float64_t, ndim=1] A,
                   numpy.ndarray[numpy.float64_t, ndim=1] B):

    cdef double dot

    # for proper memory management:
    #     declare output cross in python
    #     assign cython C = cross so we can pass &C
    #     because it barfs if you do &cross when cross was defined in python
    cross = numpy.empty((n), dtype=numpy.double)
    cdef numpy.ndarray[numpy.float64_t, ndim=1] C = numpy.empty((n))
    C = cross

    dot = 0.0

    # pass everything by reference, i.e. use the '&'
    # vec[0] since it is an array and the pointer only needs the location
    # of the first element in memory (same thing for arr[0,0])
    vector_ops_wrap(&n, &A[0], &B[0], &C[0], &dot)

    return dot, cross

