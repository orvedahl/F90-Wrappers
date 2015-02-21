!
! subroutine to shutdown eos and deallocate any variables associated with eos
!

subroutine shutdown_mesa_eos()

   ! MAESTRO
   use eos_utils, only: handle_eos

   ! MESA
   use eos_lib,   only: free_eos_handle, eos_shutdown

   implicit none

   call free_eos_handle(handle_eos)

   call eos_shutdown()

end subroutine shutdown_mesa_eos

