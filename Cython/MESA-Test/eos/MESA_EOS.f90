!
! routine to call MESA eos
!

subroutine MESA_EOS(n_vars, xmass, eos_input, eos_vars, debug, eosfail)

   use data_types
   use eos_utils
   use mesa_utils, only: nspec
   use net_utils,  only: chem_id, net_iso

   ! MESA
   use eos_lib,    only: eosDT_get, eosPT_get, eosDE_get
   use chem_lib,   only: basic_composition_info
   use eos_def,    only: num_eos_basic_results

   implicit none

   ! INPUT
   integer, intent(in) :: n_vars, eos_input, debug
   real(kind=dp_t), intent(in) :: xmass(nspec)
   real(kind=dp_t), intent(inout) :: eos_vars(n_vars)  ! state variables

   ! OUTPUT
   integer, intent(out) :: eosfail

   ! LOCAL
   integer :: ierr
   real(kind=dp_t) :: xh, xhe, abar, zbar, z2bar, ye, mass_correction, sumx
   real(kind=dp_t) :: rho, T, Z
   real(kind=dp_t), dimension(num_eos_basic_results) :: results, &
                             d_dlnRho_const_T, d_dlnT_const_Rho, &
                             d_dabar_const_TRho, d_dzbar_const_TRho

   ierr = 0
   eosfail = 0

   ! calculate abar/zbar, ye, etc.
   call basic_composition_info(nspec, chem_id, xmass, &
                               xh, xhe, abar, zbar, z2bar, ye, mass_correction, sumx)

   ! metalicity
   Z = 1.0d0 - xh - xhe

   !-----------------------------------------------------------------
   ! inputs are density & temperature
   !-----------------------------------------------------------------
   if (eos_input == eos_input_rho_T) then

      rho = eos_vars(i_rho)
      T = eos_vars(i_T)
      call eosDT_get(handle_eos, Z, xh, abar, zbar, nspec, chem_id, &
                     net_iso, xmass, rho, log10(rho), T, log10(T), &
                     results, d_dlnRho_const_T, d_dlnT_const_Rho, &
                     d_dabar_const_TRho, d_dzbar_const_TRho, ierr)

   !-----------------------------------------------------------------
   ! inputs are total pressure & temperature
   !-----------------------------------------------------------------
   elseif (eos_input == eos_input_ptot_T) then

   !-----------------------------------------------------------------
   ! inputs are density & internal energy
   !-----------------------------------------------------------------
   elseif (eos_input == eos_input_rho_e) then

   !-----------------------------------------------------------------
   ! inputs are gas pressure & density
   !-----------------------------------------------------------------
   elseif (eos_input == eos_input_pgas_rho) then

   !-----------------------------------------------------------------
   ! inputs are gas pressure & entropy
   !-----------------------------------------------------------------
   elseif (eos_input == eos_input_pgas_s) then

   !-----------------------------------------------------------------
   ! unknown inputs
   !-----------------------------------------------------------------
   else
      write(*,*)
      write(*,*) "ERROR: unknown eos_input type ",eos_input
      write(*,*)
      stop
   endif

   if (ierr /= 0) then
      eosfail = 1
      return
   endif

   ! unpack the results
   eos_vars(:) = results(:)

end subroutine MESA_EOS


