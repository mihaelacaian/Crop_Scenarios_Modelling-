!
          program write_cul_file
          implicit none
          character*80 c360
          character*1 c1
          character*6 VARNO,VARTY,ECONO, cvar
          character*16 VRNAME, ctype 
          integer i,ip, il,errnum,isec,isecx, modline
          parameter(isecx=100)
          integer ilstart(isecx)
          integer nparam, npcult
          parameter(nparam=10)
          real p(nparam), zfac(nparam), pn(nparam)

          namelist /namexp / pn,zfac, cvar,ctype, npcult
          read(4,namexp)


          do ip=1,nparam
           pn(ip)=pn(ip)/zfac(ip)
          enddo

! 
          open(66,file='input.txt', STATUS = 'OLD',IOSTAT=errnum)
          open(67,file='output.txt',form='formatted')

           isec=0
           modline=0 
           do i=1,isecx
            ilstart(i)=0
           enddo 

          if (errnum .NE. 0) then
           print*,'NO input file input.txt '
           stop
          endif
          il=0
  200     continue   
          read(66,'(a80)',err=70, end=70) c360
          il=il+1
          if (c360(1:1) .eq. ' ' .or. c360(1:1) .eq. '*' .or. &
     &       c360(1:1) .eq. '!'.or. c360(1:1) .eq. '@') then
            write(67,'(a80)') (c360)
            if(c360(1:1) .eq. '@') then
              isec=isec+1
              ilstart(isec)=il
            endif
            GO TO 200
          else

            read(c360,'(A6,1X,A16,5X,A1,1X,A6,1x,F5.1,1x,F5.3, &
     &           F6.1, F6.1 ,1X,F5.2,1x,F5.2)',IOSTAT=ERRNUM) &
     &            VARTY,VRNAME,c1,ECONO,(p(ip),ip=1,npcult)



           if( (VRNAME.eq.ctype).and.(VARTY.eq.cvar)) then
           do ip=1,npcult
            modline=il
            p(ip)=pn(ip)
           enddo
           endif


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!  write data  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
             if((p(3).lt.1000.).and.(p(4).lt.1000.) ) then
           write(67,'(A6,1X,A16,5X,A1,1X,A6,1x,F5.1,1x,F5.3, &
     &      1x, F5.1,1x, F5.1 ,1X,F5.2,1x,F5.2)',IOSTAT=ERRNUM) &
     &            VARTY,VRNAME,c1,ECONO,(p(ip),ip=1,npcult)
             elseif((p(3).lt.1000.).and.(p(4).ge.1000.) ) then
           write(68,*) 'case: p(4)>1000', 'line=', modline
           write(67,'(A6,1X,A16,5X,A1,1X,A6,1x,F5.1,1x,F5.3, &
     &      1x, F5.1, F6.0 ,1X,F5.2,1x,F5.2)',IOSTAT=ERRNUM) &
     &            VARTY,VRNAME,c1,ECONO,(p(ip),ip=1,npcult)
             elseif((p(3).ge.1000.).and.(p(4).lt.1000.) ) then
           write(67,'(A6,1X,A16,5X,A1,1X,A6,1x,F5.1,1x,F5.3, &
     &      F6.0,1x, F5.1 ,1X,F5.2,1x,F5.2)',IOSTAT=ERRNUM) &
     &            VARTY,VRNAME,c1,ECONO,(p(ip),ip=1,npcult)
           write(68,*) 'case: p(3)>1000', 'line=', modline
             elseif((p(3).ge.1000.).and.(p(4).ge.1000.) ) then
           write(67,'(A6,1X,A16,5X,A1,1X,A6,1x,F5.1,1x,F5.3, &
     &      F6.0, F6.0 ,1X,F5.2,1x,F5.2)',IOSTAT=ERRNUM) &
     &            VARTY,VRNAME,c1,ECONO,(p(ip),ip=1,npcult)
           write(68,*) 'case: p(3,4)>1000', 'line=', modline
              else
               print*,'This case was not treated ! REVIEW !!'
             stop
           endif

           endif
          goto 200
  70       continue

           stop
           end 
           

