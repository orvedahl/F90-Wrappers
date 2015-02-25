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
   integer, save :: i_lnPgas   = 1   ! gas pressure (total pressure minus
                                     ! radiation pressure)
   integer, save :: i_lnE      = 2   ! internal energy per gram
   integer, save :: i_lnS      = 3   ! entropy per gram
   integer, save :: i_grad_ad  = 4   ! dlnT_dlnP at constant S
   integer, save :: i_chiRho   = 5   ! dlnP_dlnRho at constant T
   integer, save :: i_chiT     = 6   ! dlnP_dlnT at constant Rho
   integer, save :: i_Cp       = 7   ! dh_dT at constant P, specific heat at
                                     ! constant total pressure
                                     ! where h is enthalpy, h = E + P/Rho
   integer, save :: i_Cv       = 8   ! dE_dT at constant Rho, specific heat
                                     ! at constant volume
   integer, save :: i_dE_dRho  = 9   ! at constant T
   integer, save :: i_dS_dT    = 10  ! at constant Rho
   integer, save :: i_dS_dRho  = 11  ! at constant T
   integer, save :: i_mu       = 12  ! mean molecular weight per gas particle
                                     ! (ions + free electrons)
   integer, save :: i_lnfree_e = 13  ! free_e is total combined number per 
                                     ! nucleon of free electrons & positrons
   integer, save :: i_gamma1   = 14  ! dlnP_dlnRho at constant S
   integer, save :: i_gamma3   = 15  ! gamma3 - 1 = dlnT_dlnRho at constant S
   integer, save :: i_eta      = 16  ! electron degeneracy parameter
                                     ! (eta > 1 for significant degeneracy)
                                     ! eta = (electron chemical potential)/(kT)
   integer, save :: i_rho      = 17  ! mass density
   integer, save :: i_T        = 18  ! temperature
   integer, save :: i_Ptot     = 19  ! total pressure = rad pres + gas pres
   integer, save :: i_Prad     = 20  ! radiation pressure

   integer, parameter :: num_eos_values = 20 ! total number of eos values

end module eos_utils
