module net_utils

   implicit none

   integer, save :: handle_net

   integer, pointer, save :: chem_id(:), net_iso(:), which_rates(:)

   integer, save :: solver_choice, decsol_choice, species, num_reactions

end module net_utils

