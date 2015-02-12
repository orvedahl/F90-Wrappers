!
! code to call fortran from C
!
module mesa_eos_wrapper

   use iso_c_binding, only: c_int, c_double, c_bool

   implicit none

contains

   ! initialize the EOS
   subroutine initialize_MESA_eos() bind(c)

      call setup_mesa_eos()

      return

   end subroutine initialize_MESA_eos


   ! shutdown the EOS
   subroutine finalize_MESA_eos() bind(c)

      call shutdown_mesa_eos()

      return

   end subroutine finalize_MESA_eos


   ! call the EOS
   subroutine call_MESA_EOS(n_vars, eos_input, eos_vars, debug, eosfail) bind(c)

      ! input
      integer(kind=c_int), intent(in) :: n_vars, debug, eos_input
      real(kind=c_double), intent(inout) :: eos_vars(n_vars) ! state variables

      ! output
      integer(kind=c_int), intent(out) :: eosfail

      call MESA_EOS(n_vars, eos_input, eos_vars, debug, eosfail)

      return

   end subroutine call_MESA_eos

end module mesa_eos_wrapper

