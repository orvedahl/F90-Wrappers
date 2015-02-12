!
! routine to call MESA eos
!

subroutine MESA_EOS(n_vars, eos_input, eos_vars, debug, eosfail)

   use eos_utils

   ! MESA
   use eos_lib, only: eosDT_get, eosPT_get, eosDE_get

   implicit none

   ! INPUT
   integer, intent(in) :: n_vars, eos_input, debug
   double precision, intent(inout) :: eos_vars(n_vars)  ! state variables

   ! OUTPUT
   integer, intent(out) :: eosfail

   ! LOCAL
   integer :: ierr

   ierr = 0
   eosfail = .false.

   ! calculate abar/zbar
   tnew = 0.0d0
   dnew = 0.0d0
   do i=1,nspec
      ymass = xmass(i)/aion(i)
      dnew  = dnew + ymass
      tnew  = tnew + zion(i)*ymass
   enddo

   abar = 1.0d0/dnew
   zbar = tnew*abar

   !-----------------------------------------------------------------
   ! inputs are density & temperature
   !-----------------------------------------------------------------
   if (eos_input == eos_input_rho_T) then

      call eosDT_get(handle_eos, Z, X, abar, zbar, species, chem_id,
                     net_iso, xmass, rho, log10rho, T, log10T, &
                     results, d_dlnRho_const_T, d_dlnT_const_Rho, &
                     d_dabar_const_RRho, d_dzbar_const_TRho, ierr)

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
      eosfail = .true.
      return
   endif

end subroutine MESA_eos_from_MAESTRO


