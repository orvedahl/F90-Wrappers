!
! code to call fortran from C
!
module vector_norm_wrap_mod

   use iso_c_binding, only c_int, c_double
   use calc_vector_norm

   implicit none

contains

   subroutine vector_norm_wrap(n, vec, arr, axis, norm1, norm2) bind(c)

      integer(c_int), intent(in) :: n, axis
      real(c_double), intent(in) :: vec(n), arr(n,n)
      real(c_double), intent(out) :: norm1, norm2

      ! get vector norm of vector
      call vector_norm(n, vec, norm1)

      ! get vector norm of specific column of array
      call vector_norm(n, arr(:,axis), norm2)

      return

   end subroutine vector_norm_wrap

end module vector_norm_wrap_mod

