#!/usr/bin/env python
#
# call cython code from within python
#
# R. Orvedahl 1-20-2015

import numpy
import cython_wrapper as wrapper

# setup values
l=4; m=l; n=3
axis = 0
vec = 1.*(numpy.arange((l)) + 1)
arr = numpy.empty((l,m,n))

# convert to F-contiguous arrays
vec = numpy.array(vec, order='F')
arr = numpy.array(arr, order='F')

print "Python"
for k in range(n):
    print k
    for i in range(l):
        for j in range(m):
            arr[i,j,k] = 1.*i   # every column is the same
            print arr[i,j,k], " ",
        print

# call Fortran
array = arr[:,:,0]
array2 = arr[:,axis,0]*arr[:,axis,0]
norm1, norm2 = wrapper.vector_norm_f90(vec, array, axis)

print "\nFortran Results:"
print "\tnorm of vec:", norm1
print "\tnorm of arr:", norm2
print "\nPython Results:"
print "\tnorm of vec:", numpy.sqrt(sum(vec*vec))
print "\tnorm of arr:", numpy.sqrt(sum(array2))
print

