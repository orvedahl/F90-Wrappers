!
! routines to setup the MESA EOS
!

subroutine setup_mesa_eos()

   ! MAESTRO
   use eos_utils, only: handle_eos, ih1_, ihe4_
   use mesa_utils,   only: network_species_index, mesa_dir,&
                           const_initialized, chem_initialized
   use errors, only: bl_error

   ! MESA
   use const_lib, only: const_init
   use eos_lib,   only: eos_init, alloc_eos_handle
   use chem_lib,  only: chem_init

   implicit none

   ! declare variables

   character(len=256) :: eos_file_prefix
   integer :: ierr=0
   logical, parameter :: use_cache = .true.

   ! get MESA data directory:
   if (mesa_dir == "") then
      call get_environment_variable(name="MESA_DIR", value=mesa_dir,&
                                    status=ierr)
      if (ierr /= 0) then
         call bl_error("ERROR: failed in get_environment_variable")
      endif
   endif

   if (.not. const_initialized) then
      call const_init(mesa_dir, ierr)
      if (ierr /= 0) then
         call bl_error("ERROR: failed in const_init")
      endif
      const_initialized = .true.
   endif

   if (.not. chem_initialized) then
      call chem_init('isotopes.data', ierr)
      if (ierr /= 0) then
         call bl_error("ERROR: failed in chem_init")
      endif
      chem_initialized = .true.
   endif

   eos_file_prefix = 'mesa'

   call eos_init(eos_file_prefix, '', '', '', use_cache, ierr)
   if (ierr /= 0) then
      call bl_error("ERROR: eos_init failed in set_eos_tables")
   endif

   handle_eos = alloc_eos_handle(ierr)
   if (ierr /= 0) then
      call bl_error("ERROR: failed to allocate eos handle")
   endif

   ! for metalicity
   ih1_ = network_species_index('h1')
   ihe4_ = network_species_index('he4')

   return

end subroutine setup_mesa_eos

