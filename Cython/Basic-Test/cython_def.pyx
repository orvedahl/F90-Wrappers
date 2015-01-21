#
# Cython file to call Fortran
#

import numpy
cimport numpy

# define the external subroutine interface. all should be pointers
# i.e. pass by reference (then dont need to mess with the 'value'
# keyword in the fortran source)
cdef extern:
    void vector_norm_wrap(int *n, double *vec, double *array, int *axis,
                          double *norm1, double *norm2)

# define the python "front end" to the external code
# this is called in python as:
#	norm1, norm2 = vector_norm_f90(vec, arr, axis)
#def vector_norm_f90(double[::1] vec not None, double[:,::1] arr not None,
#                    int axis):
def vector_norm_f90(numpy.ndarray[numpy.float64_t, ndim=1] vec,
                    numpy.ndarray[numpy.float64_t, ndim=2] arr,
                    int axis):

    cdef double norm1, norm2
    cdef int n

    #print numpy.shape(arr), arr[-1,-1], arr[0,0]
    n = len(vec) # arr is assumed to be size (n,n)
    norm1 = 0.0
    norm2 = 0.0

    # pass everything by reference, i.e. use the '&'
    # vec[0] since it is an array and the pointer only needs the location
    # of the first element in memory (same thing for arr[0,0])
    vector_norm_wrap(&n, &vec[0], &arr[0,0], &axis, &norm1, &norm2)

    return norm1, norm2

