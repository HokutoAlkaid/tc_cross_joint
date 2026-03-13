program scale
  !--This programs is to determine the max and min value of the data
  !-- Author: Haopeng Chen
  !-- Creatied time: 2013.06.21 15:46
  !-- Modified time: 2014.01.21 15:46
  !-- add the filelen subroutine
  integer:: i,j,k
  integer:: num ! number of data
  real ::la,lon
  real,allocatable::vel(:)
  open(11,file="file.txt")
  open(12,file="scale.txt")
  ! determine the number of line of the file
  call filelen(11,num)
  allocate(vel(num)) 
  
  do i=1,num
    read(11,*) lon,la,vel(i)
  enddo
  write(*,*) "min and max values : "
  write(*,'(2f10.2)') minval(vel),maxval(vel)
  write(12,'(2f10.2)') minval(vel)-0.02,maxval(vel)+0.02
  deallocate(vel)
end program

subroutine filelen(fileid,n)
 ! determine the number of line of the file
 ! written by Qingdong Wang, 2013.12.20
 implicit none
 integer*4::fileid,n
 rewind(fileid)
 n=0
 do
  read(fileid,*,end=20)
  n=n+1
 enddo
 20 rewind(fileid)
 return
end subroutine
