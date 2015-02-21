!
! code to call fortran from C
!
module mesa_eos_wrapper

   use iso_c_binding, only: c_int, c_double, c_bool
   use mesa_utils,    only: nspec

   implicit none

contains

   !----------------------------------------------------------------------
   ! initialize the EOS
   !----------------------------------------------------------------------
   subroutine initialize_MESA_eos() bind(c)

      call setup_mesa_eos()
      return

   end subroutine initialize_MESA_eos

   !----------------------------------------------------------------------
   ! shutdown the EOS
   !----------------------------------------------------------------------
   subroutine finalize_MESA_eos() bind(c)

      call shutdown_mesa_eos()
      return

   end subroutine finalize_MESA_eos

   !----------------------------------------------------------------------
   ! call the EOS
   !----------------------------------------------------------------------
   subroutine call_MESA_EOS(n_vars, xmass, eos_input, eos_vars, &
                            debug, eosfail) bind(c)

      ! input
      integer(kind=c_int), intent(in) :: n_vars, debug, eos_input
      real(kind=c_double), intent(in) :: xmass(nspec)
      real(kind=c_double), intent(inout) :: eos_vars(n_vars) ! state variables

      ! output
      integer(kind=c_int), intent(out) :: eosfail

      call MESA_EOS(n_vars, xmass, eos_input, eos_vars, debug, eosfail)

      return

   end subroutine call_MESA_eos

   !----------------------------------------------------------------------
   ! initialize the network
   !----------------------------------------------------------------------
   subroutine initialize_MESA_net() bind(c)

      call setup_mesa_net()
      return

   end subroutine initialize_MESA_net

   !----------------------------------------------------------------------
   ! shutdown the network
   !----------------------------------------------------------------------
   subroutine finalize_MESA_net() bind(c)

      call shutdown_mesa_net()
      return

   end subroutine finalize_MESA_net

   !----------------------------------------------------------------------
   ! call the RHS of the MESA network
   !----------------------------------------------------------------------
   subroutine network_rhs_mesa(rho, T, xmass, degenerate, eps_nuc, dxdt) bind(c)

      real(kind=c_double), intent(in) :: rho, T
      real(kind=c_double), intent(in) :: xmass(nspec)
      integer(kind=c_int), intent(in) :: degenerate
      real(kind=c_double), intent(out) :: eps_nuc, dxdt(nspec)

      call call_mesa_net(rho, T, xmass, degenerate, eps_nuc, dxdt)

      return

   end subroutine network_rhs_mesa

end module mesa_eos_wrapper

