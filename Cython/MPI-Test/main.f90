! Relaxation with MPI.  Here we solve a Poisson problem in 2-d.  We do
! domain decomposition in the x-direction.
!
! M. Zingale (2013-04-15)

program relax

  use parallel
  use relax_mpi_mod
  use bl_types

  implicit none

  integer :: nx = 512
  integer :: ny = 512
  integer :: ng = 1

  ! set the lo/hi boundary conditions in each coordinate direction
  real(kind=dp_t) :: bc_lo_x = 0.d0
  real(kind=dp_t) :: bc_hi_x = 0.d0
  real(kind=dp_t) :: bc_lo_y = 0.d0
  real(kind=dp_t) :: bc_hi_y = 0.d0

  ! domain info
  real(kind=dp_t) :: xmin = 0.0d0
  real(kind=dp_t) :: xmax = 1.0d0
  real(kind=dp_t) :: ymin = 0.0d0
  real(kind=dp_t) :: ymax = 1.0d0

  ! smoothing info
  integer :: nsmooth = 2500

  integer :: ierr

  ! initialize MPI
  call parallel_initialize()

  ! call relax code
  call relax_mpi(nx, ny, ng, bc_lo_x, bc_hi_x, bc_lo_y, bc_hi_y, &
                 xmin, xmax, ymin, ymax, nsmooth, MPI_COMM_WORLD)

  if (parallel_IOProcessor()) then
     print *,'dp_t',dp_t
     print *,'sp_t',sp_t
     print *,'ll_t',ll_t
     print *,'proc null',MPI_PROC_NULL
     print *,'doub prec',MPI_DOUBLE_PRECISION
     print *,'mpi sum', MPI_SUM
     print *,'time:',parallel_wtime()
     print *,'tick:',parallel_wtick()
  endif

  ! finalize MPI
  call parallel_finalize()

  ! write out data type information
  open(unit=16, file='datatypes.txt', action='readwrite', status='unknown')
  call bl_types_info(16)
  close(unit=16)

end program relax
