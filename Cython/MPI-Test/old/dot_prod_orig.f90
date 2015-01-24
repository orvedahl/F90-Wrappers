!
! subroutine to do vector norm
!

module dot_prod_mod

   implicit none

contains

   subroutine calc_dot_product(n, A, B, dot)

      use constants

      integer, intent(in) :: n
      double precision, intent(in) :: A(n), B(n)
      double precision, intent(out) :: dot

      integer :: i

      dot = 0.0

      do i=1, n
         dot = dot + A(i)*B(i)
      enddo

      write(*,'(1x,a,f9.7)') "The value of pi is ",pi

      return

   end subroutine calc_dot_product

end module dot_prod_mod

