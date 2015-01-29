!
! routines to setup the MESA EOS
!

subroutine setup_mesa_eos()

   ! MAESTRO
   use eos_utils, only: handle_eos, data_dir, ih1_, ihe4_
   use network,   only: network_species_index
   use bl_error_module, only: bl_error

   ! MESA
   use const_lib, only: const_init
   use eos_lib,   only: eos_init, alloc_eos_handle
   use chem_lib,  only: chem_init

   implicit none

   ! declare variables

   character(len=256) :: eos_file_prefix, mesa_dir
   integer :: ierr=0
   logical, parameter :: use_cache = .true.

   ! get MESA data directory:
   call get_environment_variable(name="MESA_DIR", value=mesa_dir, status=ierr)
   if (ierr /= 0) then
      call bl_error("ERROR: failed in get_environment_variable")
   endif

   data_dir = trim(mesa_dir) // "/data"

   call const_init(mesa_dir, ierr)
   if (ierr /= 0) then
      call bl_error("ERROR: failed in const_init")
   endif

   call chem_init('isotopes.data', ierr)
   if (ierr /= 0) then
      call bl_error("ERROR: failed in chem_init")
   endif

   eos_file_prefix = 'mesa'

   call eos_init(eos_file_prefix, use_cache, ierr)
   if (ierr /= 0) then
      call bl_error("ERROR: eos_init failed in set_eos_tables")
   endif

   handle_eos = alloc_eos_handle(ierr)
   if (ierr /= 0) then
      call bl_error("ERROR: failed to allocate eos handle")
   endif

   ! for metalicity
   ih1_ = network_species_index('H1')
   ihe4_ = network_species_index('He4')

end subroutine setup_mesa_eos

