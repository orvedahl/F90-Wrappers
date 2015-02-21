!
! module to handle error printing and aborting
!
! R. Orvedahl 2-20-2015

module errors

   implicit none

contains

   !-----------------------------------------------------------------
   ! Throw error and abort
   !-----------------------------------------------------------------
   subroutine bl_error(str)

      character(len=*), intent(in), optional :: str
      character(len=10) :: msg
      character(len=128) :: output

      msg = "ERROR: "

      if (present(str)) then
         output = trim(msg)//trim(str)
      else
         output = trim(msg)
      endif

      write(*,*)
      write(*,*) trim(output)
      write(*,*)

      call abort()

      return

   end subroutine bl_error

   !-----------------------------------------------------------------
   ! Throw warning, do not abort
   !-----------------------------------------------------------------
   subroutine bl_warn(str)

      character(len=*), intent(in), optional :: str
      character(len=10) :: msg
      character(len=128) :: output

      msg = "WARNING: "

      if (present(str)) then
         output = trim(msg)//trim(str)
      else
         output = trim(msg)
      endif

      write(*,*)
      write(*,*) trim(output)
      write(*,*)

      return

   end subroutine bl_warn

   !-----------------------------------------------------------------
   ! Gracefully exit
   !-----------------------------------------------------------------
   subroutine abort(str)

      character(len=*), intent(in), optional :: str

      if (present(str)) then
         write(*,*)
         write(*,*) trim(str)
         write(*,*)
      endif

      stop

      return

   end subroutine abort

end module errors

