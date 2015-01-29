!
! routine to call MESA eos
!

subroutine MESA_eos_from_MAESTRO( &
                       x_in, den_row, temp_row, abar_row, zbar_row, &
                       etot_row, ptot_row, &
                       cv_row, cp_row, xne_row, xnp_row, etaele_row, &
                       pele_row, ppos_row, &
                       dpd_row, dpt_row, dpa_row, dpz_row, &
                       ded_row, det_row, dea_row, dez_row, &
                       gam1_row, cs_row, stot_row, &
                       dsd_row, dst_row, eosfail)

   ! MAESTRO
   use eos_utils, only: handle_eos, ih1_, ihe4_
   use network,   only: nspec

   ! MESA
   use eos_lib,   only: eos_get_helm_results
   use eos_def,   only: num_helm_results, h_cp, h_cv, &
                    h_etot, h_dea, h_ded, h_det, h_dez, &
                    h_ptot, h_dpa, h_dpd, h_dpt, h_dpz, &
                    h_stot, h_dsd, h_dst, &
                    h_pele, h_ppos, h_xne, h_xnp, &
                    h_etaele, h_gam1

   implicit none

   ! INPUT
   double precision, intent(in) :: x_in(nspec)  ! xmass used to find Z
   double precision, intent(in) :: den_row, temp_row, abar_row, zbar_row

   ! OUTPUT
   double precision, intent(out) :: etot_row, ptot_row, cv_row, cp_row, &
                                    xne_row, xnp_row, etaele_row, &
                                    pele_row, ppos_row, dpd_row, dpt_row, &
                                    dpa_row, dpz_row, ded_row, det_row, &
                                    dea_row, dez_row, gam1_row, cs_row, &
                                    stot_row, dsd_row, dst_row
   logical, intent(out) :: eosfail

   ! LOCAL
   integer :: ierr
   double precision :: Z, log10T, log10Rho, xh1, xhe4, abar, zbar
   double precision, dimension(num_helm_results) :: helm_res


   !----------------------------------------------------------------------
   !
   ! calculate metallicity
   !
   !----------------------------------------------------------------------

   if (ih1_ > 0) then
      xh1  = x_in(ih1_)
   else
      xh1 = 0.0d0
   endif

   if (ihe4_ > 0) then
      xhe4 = x_in(ihe4_)
   else
      xhe4 = 0.0d0
   endif

   Z = 1.0d0 - xh1 - xhe4

   ! MESA eos needs log10(T) and log10(density)
   log10T = log10(temp_row)
   log10Rho = log10(den_row)

   abar = abar_row
   zbar = zbar_row

   !----------------------------------------------------------------------
   !
   ! Call to MESA EOS
   !
   !----------------------------------------------------------------------

   eosfail = .false.

   ! direct call to HELM eos, does not require mass fractions
   call eos_get_helm_results(handle_eos, Z, xh1, abar, zbar, den_row, &
                             log10Rho, temp_row, log10T, helm_res, ierr)

   if (ierr /= 0) then
      eosfail = .true.
      return
   endif


   !----------------------------------------------------------------------
   !
   ! Convert MESA eos results
   !
   !----------------------------------------------------------------------

   ! internal E
   etot_row = helm_res(h_etot)

   ! total P
   ptot_row = helm_res(h_ptot)

   ! specific heats
   cv_row = helm_res(h_cv)
   cp_row = helm_res(h_cp)

   ! electron/positron densities and pressures, degeneracy parameter, 
   xne_row = helm_res(h_xne)
   xnp_row = helm_res(h_xnp)
   etaele_row = helm_res(h_etaele)
   pele_row = helm_res(h_pele)
   ppos_row = helm_res(h_ppos)

   ! dPdR
   dpd_row = helm_res(h_dpd)

   ! dPdT
   dpt_row = helm_res(h_dpt)

   ! dPd(abar)
   dpa_row = helm_res(h_dpa)

   ! dPd(zbar)
   dpz_row = helm_res(h_dpz)

   ! dEdR
   ded_row = helm_res(h_ded)

   ! dEdT
   det_row = helm_res(h_det)

   ! dEd(abar)
   dea_row = helm_res(h_dea)

   ! dEd(zbar)
   dez_row = helm_res(h_dez)

   ! gamma1
   gam1_row = helm_res(h_gam1)

   ! total S
   stot_row = helm_res(h_stot)

   ! dsdR
   dsd_row = helm_res(h_dsd)

   ! dsdT
   dst_row = helm_res(h_dst)


end subroutine MESA_eos_from_MAESTRO


