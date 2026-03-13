 program scale
  !-------------
  !--This programs is to determine the max and min value of the data
  !-- Author: Haopeng Chen
  !-- Creatied time: 2013.06.21 15:46
  !-- Modified time: 2014.01.21 15:46
  !-- add the filelen subroutine
  !
  !-- Modified time 2019.01.24 11:30
  !-- Modification: we select the scale.sh in a small region
  !--
  !------------
  integer:: i,j,k
  integer:: num ! number of data
  real ::lat,lon,lat1,lat2,lon1,lon2
  real,allocatable::vel(:),vels1(:)
  open(11,file="vel.dat")
  open(12,file="scale.dat")
  
  ! determine the number of line of the file
  call filelen(11,num)
  allocate(vel(num))  
  allocate(vels1(num))
  
  !----
  !    You need to set the lat and lon of selected area
  !----
  lon1=110.0
  lon2=122.0
  lat1=8.0
  lat2=22.0
  
  n=0
  
  do i=1,num
    read(11,*) lon,lat,vel(i)    
    !---
    !    select the scale in a small area
    !---
    if((lon.ge.lon1).and.(lon.le.lon2).and.(lat.ge.lat1).and.(lat.le.lat2))then
       n=n+1
       vels1(n)=vel(i)
    endif
    
  enddo
  write(*,*) "min and max values of vel : "  
  write(*,'(2f10.3)') minval(vels1(1:n)), maxval(vels1(1:n))
  write(12,'(2f10.1)') minval(vels1(1:n))-0.05,maxval(vels1(1:n))+0.05

  deallocate(vel)
  deallocate(vels1)
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
