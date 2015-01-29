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
   subroutine call_MESA_eos(nspec, &
                            x_in, den_row, temp_row, abar_row, zbar_row, &
                            etot_row, ptot_row, &
                            cv_row, cp_row, xne_row, xnp_row, etaele_row, &
                            pele_row, ppos_row, &
                            dpd_row, dpt_row, dpa_row, dpz_row, &
                            ded_row, det_row, dea_row, dez_row, &
                            gam1_row, cs_row, stot_row, &
                            dsd_row, dst_row, eosfail) bind(c)

      ! input
      integer(kind=c_int), intent(in) :: nspec
      real(kind=c_double), intent(in) :: x_in(nspec)  ! xmass used to find Z
      real(kind=c_double), intent(in) :: den_row, temp_row, abar_row, zbar_row

      ! output
      real(kind=c_double), intent(out) :: etot_row, ptot_row, cv_row, cp_row, &
                                 xne_row, xnp_row, etaele_row, &
                                 pele_row, ppos_row, dpd_row, dpt_row, &
                                 dpa_row, dpz_row, ded_row, det_row, &
                                 dea_row, dez_row, gam1_row, cs_row, &
                                 stot_row, dsd_row, dst_row
      logical(kind=c_bool), intent(out) :: eosfail

      call MESA_eos_from_MAESTRO( &
                       x_in, den_row, temp_row, abar_row, zbar_row, &
                       etot_row, ptot_row, &
                       cv_row, cp_row, xne_row, xnp_row, etaele_row, &
                       pele_row, ppos_row, &
                       dpd_row, dpt_row, dpa_row, dpz_row, &
                       ded_row, det_row, dea_row, dez_row, &
                       gam1_row, cs_row, stot_row, &
                       dsd_row, dst_row, eosfail)
      return

   end subroutine call_MESA_eos

end module mesa_eos_wrapper

