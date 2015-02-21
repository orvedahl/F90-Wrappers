!
! routine to call the MESA net module
!

subroutine call_mesa_net(density, temperature, xmass, eps_nuc, dxdt, &
                         use_degeneracy)

   use data_types
   use net_utils,   only: handle_net, chem_id, num_reactions
   use mesa_utils,  only: nspec
   use eos_utils,   only: i_eta, i_T, i_rho, eos_input_rho_T, num_eos_values
   use errors

   ! MESA:
   use chem_lib,    only: basic_composition_info
   use net_lib,     only: net_get, net_work_size
   use chem_def,    only: num_categories
   use net_def,     only: Net_Info
   use rates_def,   only: extended_screening, std_reaction_Qs, &
                      std_reaction_neuQs

   implicit none

   real(kind=dp_t), intent(in) :: density, temperature, xmass(nspec)
   logical, intent(in) :: use_degeneracy
   real(kind=dp_t), intent(out) :: eps_nuc, dxdt(nspec)

   real(kind=dp_t) :: xh, xhe, abar, zbar, z2bar, ye, mass_correction, sumx

   logical :: just_dxdt = .true.

   real(kind=dp_t) :: eta, d_eta_dlnT, d_eta_dlnRho
   real(kind=dp_t), pointer :: rate_factors(:)
   real(kind=dp_t) :: weak_rate_factor
   logical :: reuse_rate_raw, reuse_rate_screened
   real(kind=dp_t) :: d_eps_nuc_dT, d_eps_nuc_dRho
   real(kind=dp_t) :: d_dxdt_dRho(nspec), d_dxdt_dT(nspec), d_eps_nuc_dx(nspec)
   real(kind=dp_t) :: d_dxdt_dx(nspec,nspec), eps_nuc_categories(num_categories)
   real(kind=dp_t) :: eps_neu_total, theta_e_for_graboske_et_al
   integer :: screening_mode, lwork, ierr
   real(kind=dp_t), pointer :: work(:)
   type(Net_Info), target :: netinfo_target
   type(Net_Info), pointer :: netinfo
   real(kind=dp_t) :: eos_vars(num_eos_values)
   logical :: eosfail

   netinfo => netinfo_target

   weak_rate_factor = 1.0d0
   screening_mode = extended_screening
   theta_e_for_graboske_et_al = 1.d0
   reuse_rate_screened = .false.
   reuse_rate_raw = .false.

   lwork = net_work_size(handle_net, ierr)
   if (ierr /= 0) then
      call bl_error("net_work_size failed")
   endif
   allocate(work(lwork), rate_factors(num_reactions))
   rate_factors(:) = 1.d0

   ! first get some basic composition info
   call basic_composition_info(nspec, chem_id, xmass, &
                       xh, xhe, abar, zbar, z2bar, ye, mass_correction, sumx)

   ! call eos to get electron degeneracy (eta)
   ! this is only used for prot(e-nu)neut and neut(e+nu)prot
   ! if your network doesn't include those, you can safely ignore eta
   if (.not. use_degeneracy) then
      eta = 0.d0
      d_eta_dlnT = 0.d0
      d_eta_dlnRho = 0.d0
   else
      eos_vars(i_T) = temperature
      eos_vars(i_rho) = density
      call MESA_EOS(num_eos_values, xmass, eos_input_rho_T, &
                    eos_vars, .false., eosfail)
      if (eosfail) call bl_error("MESA_EOS failed in network")
      eta = eos_vars(i_eta)
      d_eta_dlnT = 0.d0
      d_eta_dlnRho = 0.d0
   endif

   ! call net_get to return the RHS of the network
   call net_get(handle_net, just_dxdt, netinfo, nspec, num_reactions, &
            xmass, temperature, log10(temperature), density, log10(density), &
            abar, zbar, z2bar, ye, eta, d_eta_dlnT, d_eta_dlnRho, &
            rate_factors, weak_rate_factor, &
            std_reaction_Qs, std_reaction_neuQs, reuse_rate_raw, &
            reuse_rate_screened, &
            eps_nuc, d_eps_nuc_dRho, d_eps_nuc_dT, d_eps_nuc_dx, &
            dxdt, d_dxdt_dRho, d_dxdt_dT, d_dxdt_dx, &
            screening_mode, theta_e_for_graboske_et_al, &
            eps_nuc_categories, eps_neu_total, &
            lwork, work, ierr)

   deallocate(work, rate_factors)
   nullify(netinfo)

   return

end subroutine call_mesa_net


