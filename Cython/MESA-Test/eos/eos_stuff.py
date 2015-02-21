#!/usr/bin/env python
#
# module to hold EOS quantities and routines
#
# R. Orvedahl 2-6-2015

import numpy
import cython_wrapper as wrapper

# how are you calling the EOS
eos_input_rho_T    = 1   # EOS inputs are density & temperature
eos_input_ptot_T   = 2   # EOS inputs are total pressure & temperature
eos_input_rho_e    = 3   # EOS inputs are density & internal energy
eos_input_pgas_rho = 4   # EOS inputs are gas pressure & density
eos_input_pgas_s   = 5   # EOS inputs are gas pressure & entropy

# indices for accessing the state variables
#      first 16 values are the same order as the eos_basic_results from MESA
i_lnPgas   = 0   # gas pressure (total pressure minus radiation pressure)
i_lnE      = 1   # internal energy per gram
i_lnS      = 2   # entropy per gram
i_grad_ad  = 3   # dlnT_dlnP at constant S
i_chiRho   = 4   # dlnP_dlnRho at constant T
i_chiT     = 5   # dlnP_dlnT at constant Rho
i_Cp       = 6   # dh_dT at constant P, specific heat at constant total pres
                 # where h is enthalpy, h = E + P/Rho
i_Cv       = 7   # dE_dT at constant Rho, specific heat at constant volume
i_dE_dRho  = 8   # at constant T
i_dS_dT    = 9   # at constant Rho
i_dS_dRho  = 10  # at constant T
i_mu       = 11  # mean molec weight per gas particle (ions + free electrons)
i_lnfree_e = 12  # free_e is total combined number per nucleon of free e^- & e^+
i_gamma1   = 13  # dlnP_dlnRho at constant S
i_gamma3   = 14  # gamma3 - 1 = dlnT_dlnRho at constant S
i_eta      = 15  # electron degeneracy parameter (eta > 1 for significant
                 # degeneracy) and eta = (electron chemical potential)/(kT)
i_rho      = 16  # mass density
i_T        = 17  # temperature
i_Ptot     = 18  # total pressure = radiation pressure + gas pressure
i_Prad     = 19  # radiation pressure

num_eos_values = 20

# class to hold a given EOS state include T, rho, P, ...
class eos_state():

    def __init__(self, rho, T)

        eos_vars = numpy.zeros((num_eos_values), dtype=numpy.float64)

        eos_vars[i_rho] = rho
        eos_vars[i_T] = T

        self.vars = eos_vars

    def call_eos(self, eos_input, debug=False):

        if (not debug):
            pass_debug = 0
        else:
            pass_debug = 1

        # call the eos
        wrapper.eos(eos_input, self.vars, pass_debug)

