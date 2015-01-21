!
! code to call fortran from C
!
module vector_norm_wrap_mod

   use iso_c_binding, only: c_int, c_double
   use calc_vector_norm, only: vector_norm

   implicit none

contains

   subroutine vector_norm_wrap(n, vec, arr, axis, norm_1, norm_2) bind(c)

      integer(c_int), intent(in) :: n, axis
      real(c_double), intent(in) :: vec(0:n-1), arr(0:n-1,0:n-1) ! C indices
      real(c_double), intent(out) :: norm_1, norm_2

      integer :: i,j
      double precision :: arr2(0:n-1,0:n-1)  ! square arr so dont have to
                                             ! take transpose with indices

      ! take transpose to play nice with C/Python indexing
      !arr2 = transpose(arr)
      arr2(:,:) = arr(:,:)

      write(*,*) "Fortran"
      do i=0,n-1
         do j=0,n-1
            write(*,'(f4.1,2x)',advance='no') arr2(i,j)
         enddo
         write(*,*)
      enddo

      ! get vector norm of vector
      call vector_norm(n, vec, norm_1)

      ! get vector norm of specific column of array
      call vector_norm(n, arr2(:,axis), norm_2)

      return

   end subroutine vector_norm_wrap

end module vector_norm_wrap_mod

