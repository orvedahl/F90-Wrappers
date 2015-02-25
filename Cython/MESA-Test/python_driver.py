#!/usr/bin/env python
#
# call cython code from within python
#
# R. Orvedahl 2-25-2015

import numpy
import cython_wrapper as wrapper
import eos_utils

test_network = False

# thermodynamics setup
metalicity = 0.05
nspec = 15         # number of species to carry in the network

# setup indicies
ih1 = 0            # index of hydrogen-1
ihe4 = 1           # index of helium-4

# set mass fractions
xmass = numpy.empty((nspec))
xmass[:] = metalicity/float(nspec - 2) # all but H, He
xmass[ih1] = 0.75 - 0.5*metalicity
xmass[ihe4] = 0.25 - 0.5*metalicity

# convert to F-contiguous arrays
xmass = numpy.array(xmass, order='F')

# set density and temperature
density = 1.e6
temperature = 1.e6

# initialize EOS/network (i.e. call Fortran)
if (test_network):
    wrapper.setup_MESA_net() # network uses EOS, so its initialized with net
else:
    wrapper.setup_MESA_eos()

# setup an EOS state array
eos_vars = numpy.zeros((eos_utils.num_eos_values))
eos_vars[i_rho] = density
eos_vars[i_T] = temperature

# call Fortran EOS
wrapper.eos(eos_utils.eos_input_rho_T, xmass, eos_vars, 0)

print "\nResults:"
print "\tinput:"
print "\t\t rho : ",density
print "\t\t  T  : ",temperature
print "\t\txmass: ", xmass
print "\n\toutput:"
print "\t\t  p  : ", eos_vars[i_Ptot]
print "\t\t  e  : ", numpy.exp(eos_vars[i_lnE])
print "\t\t  s  : ", numpy.exp(eos_vars[i_lnS])

# close EOS/network
if (test_network):
    wrapper.shutdown_MESA_net() # network uses EOS, so its shutdown with net
else:
    wrapper.shutdown_MESA_eos()

