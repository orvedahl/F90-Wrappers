module data_types

   implicit none

   ! double precision
   integer, parameter, public :: dp_t = selected_real_kind(15, 307)
   integer, parameter, public :: i8_t = selected_int_kind(15)

   ! single precision
   integer, parameter, public :: sp_t = selected_real_kind(6, 37)
   integer, parameter, public :: i4_t = selected_int_kind(9)

end module data_types

