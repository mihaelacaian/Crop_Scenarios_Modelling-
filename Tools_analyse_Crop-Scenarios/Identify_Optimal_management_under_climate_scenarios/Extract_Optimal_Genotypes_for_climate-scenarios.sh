#!/bin/sh
#####  1.  (preliminrary) output to binary (o1*dat files per crop parameter) (eof1) 
###### 2. Ordonate Harvest (or other pehnological parameter)  with Genotypes (eof2)
#
cat << eof2 > ordonate_along_Genotype.F90
             program read_loop_time_ch
             implicit none
              character*5 c1,c2,c4
              character*6 c3
              character*4 model,scen
              integer i,j,k
              integer npar,niterx
              integer ntrat,it,ntfin,var4ord,irg
              parameter(ntrat=12)
              parameter(npar=6,niterx=100000)
! ordonate after HARWT (variable 4)
              parameter(var4ord=4)
              integer year,unit0,unit,unitt0,unitt,nstepsx
               parameter(nstepsx=10)
              integer nsteps(npar), vmin(npar), vmax(npar), vfac(npar)
              integer valpar(npar,nstepsx)
              integer vval1(nstepsx),vval2(nstepsx),vval3(nstepsx)
              integer vval4(nstepsx),vval5(nstepsx),vval6(nstepsx)
              character*80 cfld
              character*80 cunits
              character*4 cyy, cline1

               integer ntreatx,nvarx,ivar
               parameter(nvarx=12,ntreatx=12)
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
 
                namelist /namkode /nsteps,vval1,vval2,vval3,vval4,vval5,vval6

                open(4,file='namel_kode_info')
                   read(4,namkode)
                   do i=1,nstepsx
                    valpar(1,i)=vval1(i)
                    valpar(2,i)=vval2(i)
                    valpar(3,i)=vval3(i)
                    valpar(4,i)=vval4(i)
                    valpar(5,i)=vval5(i)
                    valpar(6,i)=vval6(i)
                  enddo
                close(4)
                unit0=30
                unitt0=50
                
               open(66,file='Info_all_IDEOTYPE_miss',&
     &           form='formatted')

               open(71,file='o1_var1_Dap.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))
               open(72,file='o1_var2_Mat.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))
               open(73,file='o1_var3_Topwt.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))
               open(74,file='o1_var4_Harwt.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ntreatx+npar))

               open(84,file='o1_var4_Harwt_ORD.dat',access='direct',&
     & form='unformatted',recl=ibyte*(ntreatx+npar*ntreatx))
             open(94,file='o1_var4_Harwt_ORD+code.dat',access='direct',&
     & form='unformatted',recl=ibyte*(ntreatx+npar*ntreatx))


            print*,'NSTEPS=', (nsteps(i),i=1,nstepsx)
            print*,'valpar(1,i)=', (valpar(1,i),i=1,nstepsx)
            print*,'valpar(2,i)=', (valpar(2,i),i=1,nstepsx)
            print*,'valpar(3,i)=', (valpar(3,i),i=1,nstepsx)
            print*,'valpar(4,i)=', (valpar(4,i),i=1,nstepsx)
            print*,'valpar(5,i)=', (valpar(5,i),i=1,nstepsx)
            print*,'valpar(6,i)=', (valpar(6,i),i=1,nstepsx)
          

            do i=1,niterx
            read(66,*,end=100) cline1
            read(66,*,end=100) c1,year,c2,scen,c3,model,c4,&
     &        (ic0(par,i),par=1,npar)
                 read(66,*,END=100) cfld
                 read(66,*,END=100) cunits
              do j=1,ntreatx
                 read(66,*,end=100) ntr,ccrop,nexp,&
     &               (vout(i,j,ivar),ivar=1,nvarx)
                   if(ntr.eq.-9999) then
                    do ivar=1,nvarx
                      vout(i,j,ivar)=-99.
                    enddo
                   endif 
              enddo
            enddo
100         continue
              ntfin=i-1
              print*,'NTFIN=', ntfin


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
              enddo


! ordonarea per treatment 
         do j=1,ntreatx
!! re-initialisation:
         do i=1,ntfin
            a(i,j)=vout(i,j,var4ord)
            do par=1,npar
              ic(par,i)=ic0(par,i)
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


!!!!!!!!!!!!!! save ordered data for this treatment:
             do par=1,npar
             do i=1,ntfin
! save ic for this treatment
               ict(par,i,j)=ic(par,i)
               lrange=.false.
                do irg=1,nsteps(par)
!                if(ic(par,i).eq.valpar(par,irg)) rg(par,i,j)=irg*1.e+par 
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
              unit=unit0+j
              unitt=unitt0+j
              write(unit,*) 'TRATAMENT:', j
              do i=1,ntfin 
               write(unit,*) a(i,j),(float(ict(par,i,j)),par=1,npar)
               write(unitt,*) a(i,j),(float(rg(par,i,j)),par=1,npar)
              enddo
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
eof2
#####################################
cat << eof1 > postprocess_DSSATout_multi-Model_multi-Management.F90

!  post-processing multi management simulations output
!
             program read_loop_time_ch
             implicit none
              character*5 c1,c2,c4
              character*6 c3
              character*4 model,scen
              integer i,j,k,ipl, ifer,id, itr, ind,indd,indd2,nindd
              integer npar,nmemx, nplx, nplx4, nferx, ndtrx, ndtrxall, ntrx,ntsimx
              integer ntrat,it,ntfin, var4ord,irg
              parameter(ntrat=12, nplx=6, nferx=3, ndtrx=4, nplx4=nplx*4)
              parameter(ndtrxall=ndtrx*nplx, ntrx=ndtrx*nferx)
              integer npl(nplx), ntf(nplx), citr,cisim, cisim0
              integer dsim(nplx),tsim(nplx*ndtrx)
              integer ordd(4*nplx),ordmin(4*nplx),ordloc(4*nplx)
!  citr=interval  planting days between tratements in a same simulation
!  cisim=interval planting days between simulation 
              parameter(citr=5, cisim=3, cisim0=89)
! here, nmemx is the max number of Ens. Members
              parameter(npar=6,nmemx=200)
! ordonate after HARWT (variable 4)
              parameter(var4ord=4)
              integer year,unit0,unit,unitt0,unitt, un, unout,nstepsx
               parameter(nstepsx=10)
              integer nsteps(npar), vmin(npar), vmax(npar), vfac(npar)
              integer valpar(npar,nstepsx)
              integer vval1(nstepsx),vval2(nstepsx),vval3(nstepsx)
              integer vval4(nstepsx),vval5(nstepsx),vval6(nstepsx)
              character*80 cfld
              character*80 cunits
              character*4 cyy, cline1

               integer ntreatx,nvarx,ivar
               parameter(nvarx=12,ntreatx=12)
!               real vout(ntreatx,nvarx,nyxx)
!               real vout(nmemx,ntreatx,nvarx,nplx)
               real vout(nmemx,ndtrx,nferx,nvarx,nplx)
               real vout4d(nmemx,ndtrx*nplx,nferx,nvarx)
               integer ntr,nexp,mrec,ibyte
               integer nt, isk, nskip
               parameter(nskip=0)
               parameter(ibyte=4)
               character*2 ccrop
               logical lrange, lgenotype, lord

               integer iloop,ibase,par
               real ss,mm
               real a(nmemx,ntreatx)
               integer ic0(npar,nmemx),ic(npar,nmemx)
               integer ict(npar,nmemx,ntreatx),rg(npar,nmemx,ntreatx)
               integer step(npar,nmemx),cc
 
!                namelist /namkode /nsteps,vval1,vval2,vval3,vval4,vval5,vval6
! nplx=6 !
!order de la stanga la dreapta, de sus in jos (1 -- 24):
!  pl0 pl0+3 pl0+6 pl0+9 pl0+12 pl0+15 
!  +5   +5    +5 ...
!  +5   +5    +5 ...
!  +5   +5    +5 ...


                 indd=0
                 do ipl=1,nplx
                  do id=1,ndtrx
                   indd=indd+1
                   tsim(indd)=cisim0+citr*(id-1)+(ipl-1)*cisim
                  enddo
                 enddo
                 nindd=indd
                  if(nindd.ne.ndtrxall) then
                     print*,'Wrong length of ordd'
                     stop
                  endif

                 do i=1,nindd
                  ordd(i)=tsim(i)
                 enddo
                 i=0
 101             continue
                 i=i+1
                 ordmin(i)=minval(ordd)
                 ordloc(i)=minloc(ordd,1)
                 ordd(ordloc(i))=1000
                 if(i.lt.nindd) then
                   goto 101
                 endif
                 write(34,*) 'ordmin=', ordmin
                unit0=30
                unitt0=50
                
               open(60,file='Info_all_mem_pl89',&
     &           form='formatted')
               open(61,file='Info_all_mem_pl92',&
     &           form='formatted')
               open(62,file='Info_all_mem_pl95',&
     &           form='formatted')
               open(63,file='Info_all_mem_pl98',&
     &           form='formatted')
               open(64,file='Info_all_mem_pl101',&
     &           form='formatted')
               open(65,file='Info_all_mem_pl104',&
     &           form='formatted')

               open(71,file='o1_var1_Flo.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ndtrxall*nferx))
               open(72,file='o1_var2_Mat.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ndtrxall*nferx))
               open(73,file='o1_var3_Topwt.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ndtrxall*nferx))
               open(74,file='o1_var4_Harwt.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ndtrxall*nferx))
               open(75,file='o1_var5_Prec.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ndtrxall*nferx))
               open(76,file='o1_var6_IRR.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ndtrxall*nferx))
               open(77,file='o1_var7_CET.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ndtrxall*nferx))
               open(78,file='o1_var8_PESW.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ndtrxall*nferx))
               open(79,file='o1_var9_TNUP.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ndtrxall*nferx))
               open(80,file='o1_var10_TNLF.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ndtrxall*nferx))
               open(81,file='o1_var11_TSON.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ndtrxall*nferx))
               open(82,file='o1_var12_TSOC.dat',&
     &  access='direct',form='unformatted',recl=ibyte*(ndtrxall*nferx))



           un=59
           do ipl=1,nplx
            un=un+1
            do i=1,nmemx
! i: member; ipl: plday ( each 3 days ) ; j: treatment from 1 to 12  
            read(un,*,end=100) cline1
            read(un,*,end=100) c1,year,c2,scen,c3,model,c4,&
     &        (ic0(par,i),par=1,npar)
                 read(un,*,END=100) cfld
                 read(un,*,END=100) cunits
              do j=1,ntrx
                 ifer=((j-1)/ndtrx)+1
                 itr=j-(ifer-1)*ndtrx
                 indd2=(ipl-1)*ndtrx+itr
                 if(i.eq.51) then
                   write(33,*) 'ipl=', ipl, 'itr=', itr, 'INDD2=', indd2
                 endif

                 read(un,*,end=100) ntr,ccrop,nexp,&
     &               (vout4d(i,indd2,ifer,ivar),ivar=1,nvarx)
                   if(ntr.eq.-9999) then
                    do ivar=1,nvarx
                      vout4d(i,indd2,ifer,ivar)=-99.
                    enddo
                   endif
              enddo
! enddo i=1,nmemx
            enddo
100         continue
            ntf(ipl)=i-1

! enddo ipl
           enddo
!
           do ipl=1,nplx
             if(ntf(ipl).ne.ntf(1)) then
               print*,'This date has not all members !', ipl, ntf(ipl)
               stop
             else
               ntfin=ntf(1)
             endif
           enddo 
! ##############################################

              ivar=0
              do unout=71,82
               ivar=ivar+1
               mrec=0
               do i=1,nmemx
                mrec=mrec+1
! write succesively, all ifer in 1 record
! no of records = nmemx for any variable 
                write(unout,rec=mrec) &
     &      (vout4d(i,ordloc(ind),1,ivar),ind=1,nindd), &
     &      (vout4d(i,ordloc(ind),2,ivar),ind=1,nindd), &
     &      (vout4d(i,ordloc(ind),3,ivar),ind=1,nindd)  
!     &        (ic0(par,i),par=1,npar)
               enddo
              enddo

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
              stop
              end

eof1
#####################################
