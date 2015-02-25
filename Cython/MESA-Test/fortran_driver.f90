!
! main program to test the MESA interface
!
! R. Orvedahl 2-25-2015

program main

   use data_types
   use mesa_eos_wrapper
   use mesa_utils, only: nspec
   use eos_utils

   implicit none

   real(kind=dp_t) :: metalicity, density, temperature
   real(kind=dp_t), allocatable :: xmass(:)
   real(kind=dp_t) :: eos_vars(num_eos_values)
   integer :: eosfail

   eos_vars(:) = 0.0
   metalicity = 0.05

   nspec = 15
   allocate(xmass(nspec))

   xmass(:) = metalicity/real(nspec-2)
   xmass(1) = 0.75 - 0.5*metalicity
   xmass(2) = 0.25 - 0.5*metalicity

   density = 1.d6
   temperature = 1.d6

   ! initialize EOS
   call initialize_MESA_eos()

   ! initialize EOS state
   eos_vars(i_rho) = density
   eos_vars(i_T) = temperature

   ! call eos
   call call_MESA_EOS(num_eos_values, xmass, eos_input_rho_T, eos_vars, &
                      0, eosfail)

   ! report
   print *,''
   print *, 'Results'
   print *, '   inputs:'
   print *, '         rho: ', density
   print *, '          T : ', temperature
   print *, '       xmass: ', xmass
   print *, '  outputs:'
   print *, '          p : ', eos_vars(i_Ptot)
   print *, '          e : ', exp(eos_vars(i_lnE))
   print *, '          s : ', exp(eos_vars(i_lnS))
   print *,''

   deallocate(xmass)

end program main

