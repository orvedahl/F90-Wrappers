#!/usr/bin/env python
#
# module to hold various EOS quantities
#

# how are you calling the EOS (identical to fortran eos_utils.f90 values)
eos_input_rho_T    = 1   # inputs: density & temperature
eos_input_ptot_T   = 2   # inputs: total pressure & temp
eos_input_rho_e    = 3   # inputs: density & int. energy
eos_input_pgas_rho = 4   # inputs: gas pressure & density
eos_input_pgas_s   = 5   # inputs: gas pressure & entropy

# indices for accessing the state variables

# first 16 values are the same order as the eos_basic_results
# from MESA. these should be identical to the values in the fortran
# code eos_stuff.f90, except for the zero based index junk
i_lnPgas   = 0   # gas pressure (total pressure minus radiation pressure)
i_lnE      = 1   # internal energy per gram
i_lnS      = 2   # entropy per gram
i_grad_ad  = 3   # dlnT_dlnP at constant S
i_chiRho   = 4   # dlnP_dlnRho at constant T
i_chiT     = 5   # dlnP_dlnT at constant Rho
i_Cp       = 6   # dh_dT at constant P, specific heat at  const total pressure
                 # where h is enthalpy, h = E + P/Rho
i_Cv       = 7   # dE_dT at constant Rho, specific heat at constant volume
i_dE_dRho  = 8   # at constant T
i_dS_dT    = 9   # at constant Rho
i_dS_dRho  = 10  # at constant T
i_mu       = 11  # mean molecular weight per gas
                 # particle (ions + free electrons)
i_lnfree_e = 12  # free_e is total combined number per nucleon of
                 # free electrons & positrons
i_gamma1   = 13  # dlnP_dlnRho at constant S
i_gamma3   = 14  # gamma3 - 1 = dlnT_dlnRho at constant S
i_eta      = 15  # electron degeneracy parameter (eta > 1 for significant
                 # degeneracy) eta = (electron chemical potential)/(kT)
i_rho      = 16  # mass density
i_T        = 17  # temperature
i_Ptot     = 18  # total pressure = rad pres + gas pres
i_Prad     = 19  # radiation pressure

num_eos_values = 20 # total number of eos variables

