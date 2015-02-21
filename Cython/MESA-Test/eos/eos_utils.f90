module eos_utils

   implicit none

   ! how are you calling the EOS
   integer, save :: eos_input_rho_T    = 1   ! inputs: density & temperature
   integer, save :: eos_input_ptot_T   = 2   ! inputs: total pressure & temp
   integer, save :: eos_input_rho_e    = 3   ! inputs: density & int. energy
   integer, save :: eos_input_pgas_rho = 4   ! inputs: gas pressure & density
   integer, save :: eos_input_pgas_s   = 5   ! inputs: gas pressure & entropy

   ! values that are passed between multiple routines
   integer, save :: handle_eos
   integer, save :: ih1_, ihe4_

   ! indices for accessing the state variables

   ! first 16 values are the same order as the eos_basic_results
   ! from MESA. these should be identical to the values in the python
   ! code eos_stuff.py
   integer, save :: i_lnPgas   = 0   ! gas pressure (total pressure minus
                                     ! radiation pressure)
   integer, save :: i_lnE      = 1   ! internal energy per gram
   integer, save :: i_lnS      = 2   ! entropy per gram
   integer, save :: i_grad_ad  = 3   ! dlnT_dlnP at constant S
   integer, save :: i_chiRho   = 4   ! dlnP_dlnRho at constant T
   integer, save :: i_chiT     = 5   ! dlnP_dlnT at constant Rho
   integer, save :: i_Cp       = 6   ! dh_dT at constant P, specific heat at
                                     ! constant total pressure
                                     ! where h is enthalpy, h = E + P/Rho
   integer, save :: i_Cv       = 7   ! dE_dT at constant Rho, specific heat
                                     ! at constant volume
   integer, save :: i_dE_dRho  = 8   ! at constant T
   integer, save :: i_dS_dT    = 9   ! at constant Rho
   integer, save :: i_dS_dRho  = 10  ! at constant T
   integer, save :: i_mu       = 11  ! mean molecular weight per gas particle
                                     ! (ions + free electrons)
   integer, save :: i_lnfree_e = 12  ! free_e is total combined number per 
                                     ! nucleon of free electrons & positrons
   integer, save :: i_gamma1   = 13  ! dlnP_dlnRho at constant S
   integer, save :: i_gamma3   = 14  ! gamma3 - 1 = dlnT_dlnRho at constant S
   integer, save :: i_eta      = 15  ! electron degeneracy parameter
                                     ! (eta > 1 for significant degeneracy)
                                     ! eta = (electron chemical potential)/(kT)
   integer, save :: i_rho      = 16  ! mass density
   integer, save :: i_T        = 17  ! temperature
   integer, save :: i_Ptot     = 18  ! total pressure = rad pres + gas pres
   integer, save :: i_Prad     = 19  ! radiation pressure

   integer, save :: num_eos_values = 20 ! total number of eos variables

end module eos_utils
