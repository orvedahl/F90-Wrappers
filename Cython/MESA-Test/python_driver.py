#!/usr/bin/env python
#
# call cython code from within python
#
# R. Orvedahl 1-20-2015

import numpy
import cython_wrapper as wrapper

# domain setup
dens_max = 1.e9
dens_min = 1.e6
temp_max = 1.e9
temp_min = 1.e6
metal_max = 0.1

# setup values
ih1 = 0            # index of hydrogen-1
ihe4 = 1           # index of helium-4
nspec = 10

xmass = numpy.empty((nspec))
for i in range ():
    xmass[i] = float(i)*metal_max/float(num_metals)

# convert to F-contiguous arrays
xmass = numpy.array(xmass, order='F')

# initialize EOS (i.e. call Fortran)
wrapper.init_EOS()

# call Fortran EOS
dot, cross = wrapper.eos(n, A, B)

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


