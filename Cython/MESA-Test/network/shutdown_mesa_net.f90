!
! routine to shutdown the MESA net 
!

subroutine shutdown_mesa_net()

   use net_utils, only: chem_id, net_iso, which_rates

   implicit none

   deallocate(chem_id, net_iso, which_rates)

end subroutine shutdown_mesa_net

