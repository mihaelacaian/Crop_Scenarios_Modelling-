
! ordering Harvest for all managements scenarios and all genotypes simulated
! 
             program read_loop_time_ch
             implicit none
              character*5 c1,c2,c4
              character*6 c3
              character*4 model,scen
              integer i,j,k
              integer npar,niterx,ngeno,ino
              integer ntrat,it,ntfin,var4ord,irg
              parameter(ntrat=12)
!              parameter(npar=6,niterx=100000)
              parameter(npar=6,niterx=30)
! ordonate after HARWT (variable 4)
              parameter(var4ord=4)
              integer year,unit0,unit,unitt0,unitt,nstepsx
               parameter(nstepsx=10)
              integer nsteps(npar), vmin(npar), vmax(npar), vfac(npar)
              integer valpar(npar,nstepsx)
              integer vval1(nstepsx), vval2(nstepsx),vval3(nstepsx), &
     &            vval4(nstepsx), vval5(nstepsx),vval6(nstepsx)
              character*77 cfld
              character*3 cfld1, ccref
              character*1 cfld11,cfld12,cfld13
              character*80 cunits
              character*4 cyy, cline1

               integer ntreatx,nvarx,ivar
               parameter(nvarx=12,ntreatx=12)
!               real vout(ntreatx,nvarx,nyxx)
               real vout(niterx,ntreatx,nvarx)
               integer ntr,nexp,mrec,ibyte
               integer nt, isk, nskip
               parameter(nskip=0)
               parameter(ibyte=4)
               character*2 ccrop
               logical lrange

               integer iloop,ibase,par
               real ss,mm
               real a(niterx,ntreatx)
               integer ic0(npar,niterx),ic(npar,niterx)
               integer ict(npar,niterx,ntreatx),rg(npar,niterx,ntreatx)
               integer step(npar,niterx),cc
 

                cyy='1976'
                unit0=30
                unitt0=50
                ccref='RUN'
           
                
               open(66,file='Info_all_IDEOTYPE',&
     &           form='formatted')

               open(71,file='o1_var1_Flo.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))
               open(72,file='o1_var2_Mat.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))
               open(73,file='o1_var3_Topwt.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))
               open(74,file='o1_var4_Harwt.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))
               open(75,file='o1_var5_Prec.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))
!               open(76,file='o1_var6_TIRR.dat',&
!     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))
               open(77,file='o1_var7_CET.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))
               open(78,file='o1_var8_PESW.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))
               open(79,file='o1_var9_TNUP.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))
               open(80,file='o1_var10_TNLF.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))
               open(81,file='o1_var11_TSON.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))

               open(84,file='o1_var4_Harwt_ORD.dat',access='direct',&
     & form='unformatted',recl=ibyte*(ntreatx+npar*ntreatx))
             open(94,file='o1_var4_Harwt_ORD+code.dat',access='direct',&
     & form='unformatted',recl=ibyte*(ntreatx+npar*ntreatx))

                  do i=1,nstepsx
                   valpar(1,i)=1
                   valpar(2,i)=1
                   valpar(3,i)=1
                   valpar(4,i)=1
                   valpar(5,i)=1
                   valpar(6,i)=1
                  enddo

          
            ngeno=0
            ino=0
            do i=1,niterx
            read(66,*,end=100) cline1
 201        continue
            read(66,*,end=100) c1,year,c2,c3,c4,&
     &        (ic0(par,i),par=1,npar)
                 read(66,*,END=100) cfld
                 cfld1=cfld(1:3)
                  if(cfld1.ne.ccref) then
                     print*,'it_stop=', i, 'cfld1=', cfld1, 'ccref=', ccref
                     ino=ino+1
                     do j=1,ntreatx
                     do ivar=1,nvarx
                      vout(i,j,ivar)=-99.
                     enddo
                     enddo
                     goto 201
                  endif
                  ngeno=ngeno+1 
                 read(66,*,END=100) cunits
              do j=1,ntreatx
                 read(66,*,end=100) ntr,ccrop,nexp,&
     &               (vout(i,j,ivar),ivar=1,nvarx)
                   if(vout(i,j,1).eq.-99) then
                    do ivar=1,nvarx
                      vout(i,j,ivar)=-99.
                    enddo
                   endif 
              enddo
            enddo
            print*,'INO_fin=', ino
100         continue
              ntfin=i-1
              if(ngeno.eq.0) then
                ntfin=ino+1
                     do j=1,ntreatx
                     do ivar=1,nvarx
                      vout(ntfin,j,ivar)=-99.
                     enddo
                     enddo
              endif
              print*,'NT_fin=', ntfin


              mrec=0
              do i=1,ntfin
               mrec=mrec+1 
               write(71,rec=mrec) &
     &      (vout(i,j,1),j=1,ntreatx),(float(ic0(k,i)),k=1,npar)
               write(72,rec=mrec) &
     &      (vout(i,j,2),j=1,ntreatx),(float(ic0(k,i)),k=1,npar)
               write(73,rec=mrec) &
     &      (vout(i,j,3),j=1,ntreatx),(float(ic0(k,i)),k=1,npar)
               write(74,rec=mrec) &
     &      (vout(i,j,4),j=1,ntreatx),(float(ic0(k,i)),k=1,npar)
               write(75,rec=mrec) &
     &      (vout(i,j,5),j=1,ntreatx),(float(ic0(k,i)),k=1,npar)
               write(77,rec=mrec) &
     &      (vout(i,j,7),j=1,ntreatx),(float(ic0(k,i)),k=1,npar)
               write(78,rec=mrec) &
     &      (vout(i,j,8),j=1,ntreatx),(float(ic0(k,i)),k=1,npar)
               write(79,rec=mrec) &
     &      (vout(i,j,9),j=1,ntreatx),(float(ic0(k,i)),k=1,npar)
               write(80,rec=mrec) &
     &      (vout(i,j,10),j=1,ntreatx),(float(ic0(k,i)),k=1,npar)
               write(81,rec=mrec) &
     &      (vout(i,j,11),j=1,ntreatx),(float(ic0(k,i)),k=1,npar)
              enddo


! ordonarea per treatment 
         do j=1,ntreatx
!! re-initialisation:
         do i=1,ntfin
            a(i,j)=vout(i,j,var4ord)
            do par=1,npar
              ic(par,i)=ic0(par,i)
              nsteps(par)=1
            enddo
         enddo

            ibase=1
  150       continue
            mm=a(ibase,j)
            iloop=ibase
!
            do i=iloop+1,ntfin
             if(mm.le.a(i,j)) then
              ss=a(ibase,j)
              a(ibase,j)=a(i,j)
              a(i,j)=ss
              iloop=i
               do par=1,npar
                 cc=ic(par,ibase)
                 ic(par,ibase)=ic(par,i)
                 ic(par,i)=cc
               enddo
              mm=a(ibase,j)
             else
               goto 200
             endif
 200         continue
             enddo
           ibase=ibase+1
           if(ibase.lt.ntfin) then
             goto 150
           endif


!       data (valpar(6,i),i=1,nstepsx) /  30, 40, 50,0,0,0,0,0,0,0/
!!!!!!!!!!!!!! save ordered data for this treatment:
             print*,'save kode of ordering'
             do par=1,npar
             do i=1,ntfin
! save ic for this treatment
               ict(par,i,j)=ic(par,i)
               lrange=.false.
                do irg=1,nsteps(par)
                   print*,'irg=', irg
!                if(ic(par,i).eq.valpar(par,irg)) rg(par,i,j)=irg*1.e+par 
                   print*,'ic & valpar=', ic(par,i),valpar(par,irg)
                  if(ic(par,i).eq.valpar(par,irg)) rg(par,i,j)=irg
                  lrange=.true.
                enddo
                if(lrange.eqv..false.) then
                 print*,'ERROR in finding range!'
                 stop
                endif
             enddo 
             enddo 

!!!!!!!!!!!!!! (indicatorul ic nu depinde de tratament, e acealsi pt
!!!!!!!!!!!!!!!!!!!!!!cele 12 tratamente )
              do i=1,ntfin
               do par=1,npar
               ict(par,i,j)=ic(par,i)
               enddo
              enddo

! loop over treatment j
              enddo
!!!!!!!!!!!!

              mrec=0
              do i=1,ntfin
               mrec=mrec+1 
               write(84,rec=mrec) (a(i,j),j=1,ntreatx),&
     &          ((float(ict(k,i,j)),k=1,npar),j=1,ntreatx)
               write(94,rec=mrec) (a(i,j),j=1,ntreatx),&
     &          ((float(rg(k,i,j)),k=1,npar),j=1,ntreatx)
              enddo

              stop
              end
