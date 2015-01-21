#!/usr/bin/env python
#
# call cython code from within python
#
# R. Orvedahl 1-20-2015

import numpy
import cython_wrapper as wrapper

# setup values
n = 6
axis = 0
vec = numpy.ones((n))
arr = numpy.ones((n,n))

# call Fortran
norm1, norm2 = wrapper.vector_norm_f90(n, vec, arr, axis)

print "\nFortran Results:"
print "\tnorm of vec:", norm1
print "\tnorm of arr:", norm2

print "\nPython Results:"
print "\tnorm of vec:", numpy.linalg.norm(vec)
print "\tnorm of arr:", numpy.linalg.norm(arr, axis=axis)
print

