#!/usr/bin/env python
#
# call cython code from within python
#
# R. Orvedahl 1-20-2015

import numpy
import cython_wrapper as wrapper

# setup values

# initialize EOS (i.e. call Fortran)

# convert to F-contiguous arrays
A = numpy.array(A, order='F')
B = numpy.array(B, order='F')

# call Fortran EOS
dot, cross = wrapper.vector_ops_f90(n, A, B)

print "\nFortran Results:"
print "\tdot prod  :", dot
print "\tcross prod:", cross
print "\nPython Results:"
print "\tdot prod  :", A[0]*B[0]+A[1]*B[1]+A[2]*B[2]
C = []
C.append(A[1]*B[2] - A[2]*B[1])
C.append(A[2]*B[0] - A[0]*B[2])
C.append(A[0]*B[1] - A[1]*B[0])
print "\tcross prod:", C
print

# close EOS


