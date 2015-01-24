!
! subroutine to do vector norm
!

module vector_ops

   implicit none

contains

   subroutine vector_operations(n, A, B, C, dot)

      use dot_prod_mod

      integer, intent(in) :: n
      double precision, intent(in) :: A(n), B(n)
      double precision, intent(out) :: C(n), dot

      integer :: i

      call calc_dot_product(n, A, B, dot)

      if (n == 3) then
          call vector_cross(A, B, C)
      else
          write(*,*)
          write(*,*) "dimension was not 3, cant do cross product"
          write(*,*)
          C(:) = -6.0
      endif

      return

   end subroutine vector_operations

   ! cross product in 3 dimensions
   subroutine vector_cross(A, B, C)

      double precision, intent(in) :: A(0:2), B(0:2)
      double precision, intent(out) :: C(0:2)

      double precision :: eps(0:2,0:2,0:2)
      integer :: i,j,k

      ! generate the levi-cevita symbol
      eps(:,:,:) = 0.0
      eps(0,1,2) = 1.0
      eps(2,0,1) = 1.0
      eps(1,2,0) = 1.0
      eps(2,1,0) = -1.0
      eps(0,2,1) = -1.0
      eps(1,0,2) = -1.0

      do k=0,2
         do j=0,2
            do i=0,2
               C(i) = C(i) + eps(i,j,k)*A(j)*B(k)
            enddo
         enddo
      enddo

      return

   end subroutine vector_cross

end module vector_ops

