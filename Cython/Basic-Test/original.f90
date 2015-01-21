!
! subroutine to do vector norm
!

module calc_vector_norm

   implicit none

contains

   subroutine vector_norm(n, vec, norm)

      integer, intent(in) :: n
      double precision, intent(in) :: vec(n)
      double precision, intent(out) :: norm

      integer :: i

      norm = 0.0

      do i=1, n
         norm = norm + vec(i)*vec(i)
      enddo

      norm = dsqrt(norm)

      return

   end subroutine vector_norm

end module calc_vector_norm

