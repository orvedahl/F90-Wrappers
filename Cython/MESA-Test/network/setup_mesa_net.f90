!
! routine to initialize and setup the MESA net module
!

subroutine setup_mesa_net()

   use errors
   use net_utils,   only: net_iso, chem_id, which_rates, handle_net, &
                      num_reactions, solver_choice, decsol_choice, species
   use mesa_utils,  only: nspec, mesa_dir, short_spec_names, short_spec_mesa, &
                     chem_initialized, const_initialized, eos_initialized

   ! MESA:
   use const_lib,   only: const_init
   use chem_lib,    only: chem_init, chem_get_iso_id
   use chem_def,    only: chem_isos
   use net_def,     only: Net_General_Info
   use net_lib,     only: alloc_net_handle, net_init, net_start_def, &
                      read_net_file, net_finish_def, net_ptr, &
                      net_set_which_rates, num_chem_isos, net_setup_tables
   use mtx_lib,     only: decsol_option
   use num_lib,     only: solver_option
   use rates_lib,   only: rates_init
   use rates_def,   only: rates_reaction_id_max, reaction_Name
   use crlibm_lib,  only: crlibm_init

   implicit none

   type(Net_General_Info), pointer :: g
   integer :: ierr, i, j, unit_num=34, cid, which_rates_choice, &
              decsol_switch
   character(len=128) :: mesa_net_file, which_solver
   character(len=128) :: large_mtx_decsol, small_mtx_decsol
   character(len=5) :: cache_suffix

   1 format (14x,a)
   2 format (4x,a)
   3 format (19x,a)

   ! get MESA data directory:
   call get_environment_variable(name="MESA_DIR", value=mesa_dir, &
                                 status=ierr)
   if (ierr /= 0) then
      call bl_error("failed to get env var: MESA_DIR")
   endif

   mesa_net_file = "mesa_which_nuclei.list"

   ! convert short names to mesa format
   do i=1,nspec
      short_spec_mesa(i) = lower_case(short_spec_names(i))
   enddo

   ! use short names (mesa format) to create the net_file
   open(unit=unit_num, file=mesa_net_file, action='write', status='replace')

   ! add reactions and isos for all species in current net
   write(unit_num,2) 'add_isos_and_reactions('
   do i=1,nspec
      write(unit_num,1) trim(short_spec_mesa(i))
   enddo

   ! close parenthesis for add_isos_and_reactions
   write(unit_num,3) ')'

   close(unit_num)

   !-----------------------------------------------------------------
   ! Begin MESA Initialization:
   !-----------------------------------------------------------------
   call const_init(mesa_dir, ierr)
   if (ierr /= 0) then
      call bl_error("failed in const_init")
   endif
   const_initialized = .true.

   call crlibm_init()

   call chem_init('isotopes.data', ierr)
   if (ierr /= 0) then
      call bl_error("failed in chem_init")
   endif
   chem_initialized = .true.

   allocate(net_iso(num_chem_isos), chem_id(num_chem_isos))

   call rates_init('reactions.list', '', '', ierr)
   if (ierr /= 0) then
      call bl_error("failed in rates_init")
   endif

   ! setup map between MAESTRO and MESA
   chem_id(:) = -1
   net_iso(:) = -1

   ! map the isotope to the mesa chem id (chem_id)
   ! map the chem id to the isotope in the current net (net_iso)
   do i=1,nspec
      cid = chem_get_iso_id(trim(short_spec_mesa(i)))
      chem_id(i) = cid
      net_iso(i) = i
   enddo

   call net_init(ierr)
   if (ierr /= 0) then
      call bl_error("failed in net_init")
   endif

   handle_net = alloc_net_handle(ierr)
   if (ierr /= 0) then
      call bl_error("failed in alloc_net_handle")
   endif

   call net_start_def(handle_net, ierr)
   if (ierr /= 0) then
      call bl_error("failed in net_start_def")
   endif

   call read_net_file(mesa_net_file, handle_net, ierr)
   if (ierr /= 0) then
      call bl_error("failed in read_net_file: "//trim(mesa_net_file))
   endif

   call net_finish_def(handle_net, ierr)
   if (ierr /= 0) then
      call bl_error("failed in net_finish_def")
   endif

   call net_ptr(handle_net, g, ierr)
   if (ierr /= 0) then
      call bl_error("failed in net_ptr")
   endif

   species = g % num_isos
   num_reactions = g % num_reactions

   ! write a log file containing the species and reactions
   open(unit=25,file='species_and_reactions.log',action='write', &
              status='unknown')
   write(25,'(3x,a,1x,i4)')'Number of Species:',nspec
   write(25,'(3x,a)')'Species:'
   do i=1,nspec
      write(25,'(15x,a5)') short_spec_names(i)
   enddo
   write(25,*)
   write(25,'(3x,a,1x,i4)')'Number of Reactions:',g%num_reactions
   write(25,'(3x,a)')'Reactions:'
   do i=1, g % num_reactions
      j = g % reaction_id(i)
      if (j>0) then
         write(25,'(15x,a)') trim(reaction_Name(j))
      else
         write(25,'(3x,a,i3,a)') 'Reaction number ',i,&
                                       ' in g%num_reactions not found'
      endif
   enddo
   close(unit=25)

   ! Error trapping:
   if (species /= nspec) then
      print *,''
      print *,'ERROR: species /= nspec'
      print *,''
      print *,'species (MESA)  :',species
      print *,'nspec (MAESTRO) :',nspec
      print *,''
      print *,'i, MAESTRO, MESA:'
      print *,'---------------------------'
      do i=1,min(species,nspec)
         j=chem_id(i)
         print *,i,short_spec_names(i), chem_isos % name(j)
      enddo
      if (species > nspec) then
         do i=nspec+1,species
            j = chem_id(i)
            print *,i,'----',chem_isos % name(j)
         enddo
      else
         do i=species+1,nspec
            print *,i,short_spec_names(i),'----'
         enddo
      endif
      print *,'---------------------------'
      call bl_error("species /= nspec")
   endif

   which_rates_choice  = 2 ! rates_JR05_if_available = 2
                           ! rates_NACRE_if_available = 1

   allocate(which_rates(rates_reaction_id_max))
   which_rates(:) = which_rates_choice

   call net_set_which_rates(handle_net, which_rates, ierr)
   if (ierr /= 0) then
      call bl_error("failed in net_set_which_rates")
   endif

   cache_suffix = ''
   call net_setup_tables(handle_net, 'rate_tables', cache_suffix, ierr)
   if (ierr /= 0) then
      call bl_error("failed in net_setup_tables")
   endif

   ! initialize variables used in Do_One_Zone_Burn.f90:
   decsol_switch = 500 ! if current nspec <= switch, use small mtx decsol
                       ! else use large mtx decsol
   small_mtx_decsol = 'lapack'
   large_mtx_decsol = 'klu'

   if(nspec >= decsol_switch) then
      decsol_choice = decsol_option(large_mtx_decsol,ierr)
      if (ierr /= 0) then
         call bl_error("unknown large_mtx_decsol, "//trim(large_mtx_decsol))
      endif
   else
      decsol_choice = decsol_option(small_mtx_decsol,ierr)
      if (ierr /= 0) then
         call bl_error("unknown small_mtx_decsol, "//trim(small_mtx_decsol))
      endif
   endif

   ! this is used by net_1_zone_burn in Do_One_Zone_Burn.f90
   which_solver = 'rodas4_solver'
   solver_choice = solver_option(which_solver, ierr)
   if (ierr /= 0) then
      call bl_error("unknown which_solver, "//trim(which_solver))
   endif

   if (.not. eos_initialized) then
      call setup_mesa_eos()
   endif


   contains


   !-----------------------------------------------------------------
   ! Function to convert entire word to lower case
   !-----------------------------------------------------------------
   function lower_case(word) result(wordout)

      character(len=5) :: word
      character(len=5) :: wordout
      integer :: i, ic, nlen

      wordout = word

      nlen = len(wordout)

      do i=1,nlen
         ic = ichar(wordout(i:i))
         if (ic >= 65 .and. ic <= 90) wordout(i:i) = char(ic+32)
      enddo

      return

   end function lower_case

end subroutine setup_mesa_net


