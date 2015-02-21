module mesa_utils

   implicit none

   character(len=256), save :: mesa_dir = ''

   logical, save :: const_initialized = .false.
   logical, save :: chem_initialized = .false.

   integer, save :: nspec

   character(len=32), pointer, save :: spec_names(:)
   character(len=5), pointer, save :: short_spec_names(:), short_spec_mesa(:)

contains

   !-----------------------------------------------------------------
   ! return index of network species
   !-----------------------------------------------------------------
   function network_species_index(name)

      character(len=*) :: name
      integer :: network_species_index, n

      network_species_index = -1

      do n = 1, nspec
         if (name == spec_names(n) .or. &
             name == short_spec_names(n) .or. &
             name == short_spec_mesa(n)) then
            network_species_index = n
            exit
         endif
      enddo

      return

   end function network_species_index

end module mesa_utils

