!
! code to call fortran from C
!
module vector_ops_wrap_mod

   use iso_c_binding, only: c_int, c_double
   use vector_ops, only: vector_operations

   implicit none

contains

   subroutine vector_ops_wrap(n, Avec, Bvec, Cross, dot) bind(c)

      integer(c_int), intent(in) :: n
      real(c_double), intent(in), dimension(0:n-1) :: Avec, Bvec
      real(c_double), intent(out) :: Cross(0:n-1), dot

      ! get dot product & cross product
      call vector_operations(n, Avec, Bvec, Cross, dot)

      return

   end subroutine vector_ops_wrap

end module vector_ops_wrap_mod

