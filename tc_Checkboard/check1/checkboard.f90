! ******************************************************************************
! This program is used to creat the 3D checkerboard model for the joint inversion 
! of gravity and surface wave dispersion data
! Author        :: Haopeng Chen from HUST
! Creatied time :: 2021.03.07 15:40
! ******************************************************************************
      program checkboard3d  ! 
	  IMPLICIT REAL*8 (A-H,P-Z)

	  open( 7,file='checkboard.in')	    ! input file name
	  open(100,file='gridfile.txt')	    ! output grid file

	  read(7,*) dgridv1,dgridv2         ! The velocity anomaly.
	  read(7,*) aa1,aa2,nlon            ! grids: lon1, lon2, nlon
	  read(7,*) bb1,bb2,nlat            ! grids: lat1,lat2,nlat
	  read(7,*) depth                   ! the depth of velocity structure
	  
	  !---
	  !   this formula is used to determine the average velocity at each depth
	  !---
	  v0=2.5+depth*0.02
	  
          !---
          !   we modified the output of the grid model. we output five point 
          !   in each grid. Modifed by Haopeng Chen, 20202.03.04
          !---
          dlon=(aa2-aa1)/nlon					 
	  dlat=(bb2-bb1)/nlat
	  
	  vhigh=v0+dgridv1
	  vlow=v0+dgridv2          
          vhighn=v0+0.6*dgridv1
          vlown=v0+0.6*dgridv2
          
          do i=1,nlat
		do j=1,nlon
		   if ((mod(i+j,2).eq.0))then
		      write(100,"(3F10.3)") aa1+(j-0.5)*dlon, bb1+(i-0.5)*dlat,vlow
		      write(100,"(3F10.3)") aa1+(j-0.75)*dlon, bb1+(i-0.75)*dlat,vlown	
		      write(100,"(3F10.3)") aa1+(j-0.75)*dlon, bb1+(i-0.25)*dlat,vlown	
		      write(100,"(3F10.3)") aa1+(j-0.25)*dlon, bb1+(i-0.75)*dlat,vlown	
		      write(100,"(3F10.3)") aa1+(j-0.25)*dlon, bb1+(i-0.25)*dlat,vlown			  
		   else
		      write(100,"(3F10.3)") aa1+(j-0.5)*dlon, bb1+(i-0.5)*dlat,vhigh
		      write(100,"(3F10.3)") aa1+(j-0.75)*dlon, bb1+(i-0.75)*dlat,vhighn	
		      write(100,"(3F10.3)") aa1+(j-0.75)*dlon, bb1+(i-0.25)*dlat,vhighn	
		      write(100,"(3F10.3)") aa1+(j-0.25)*dlon, bb1+(i-0.75)*dlat,vhighn	
		      write(100,"(3F10.3)") aa1+(j-0.25)*dlon, bb1+(i-0.25)*dlat,vhighn
		   endif
		enddo
	  enddo
	  !--------------------------------------------------------------------------
    end program
