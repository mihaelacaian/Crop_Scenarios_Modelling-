#!/bin/sh
#########  options: ######################################
####### se seteazea 3 param: test, setup, scen+anii ####
##########################################################
#setup='Res_Ctrl_MARS_3xN_CORR+soil_ferti'

test=Test_16Mai_Noprint
ctest=T_16Mai
setup='Res_period_1y'
scen='Ctrl_MARS'
ys=1976
ye=2005
#ye=1976

nplot1="1y_x-trat"
nplot2="1y_x-trat_2d"
nplot3="ally"

nplot=$nplot3
echo "NPLOT=" ${nplot}
gr=mygr
#################### end options ####################
d00=myd00
daux=${d00}/Auxil
ddata=${d00}/${test}/${setup}/Res_${scen}
dwk0=${d00}/PREL_res/${test}/${setup}/Res_${scen}
mkdir -p ${dwk0}
dwk=${dwk0}/Prel_plot
mkdir -p ${dwk}

#dout=${dwk}/Plot_${nplot}
dout=${dwk}
doutp=${dout}/PRINT
mkdir -p ${dout} ${doutp}

################################

cd ${dwk}
\rm o1_* *.exe *.dat

yy=${ys}
nn=0
while [ ${yy} -le ${ye} ] ; do
d0=${d0}/${yy}
dd=${d0}/${setup}/YY_${yy}
nn=`expr ${nn} + 1 `
cp ${ddata}/YY_${yy}/o1_${yy} o1_${yy}.txt
yy=`expr ${yy} + 1 `
done
############## plots per year
if [ ${nplot} == ${nplot3} ] ; then
echo "NPLOT3=" ${nplot}

\rm nam_info
cat << EOF > nam_info
${ys}
${ye}
EOF

nplot1="1y_x-trat"
nplot2="1y_x-trat_2d"
nplot3="ally"
###########################
cat << eof1 > read_dssat_1y_x-trat

               program read_output_dssat
               implicit none
               character*1 zdummy
               character*80 cfld
               character*80 cunits
               integer ntreatx,nvarx
               parameter(nvarx=12,ntreatx=12)
               real vout(ntreatx,nvarx)
               integer i,j,ntr,nexp,mrec,ibyte
               parameter(ibyte=4)
               character*2 ccrop
                
               open(66,file='o1_1y.txt',&
     &           form='formatted')
               open(67,file='o1_1y_x-trat.dat',&
     &           access='direct',form='unformatted',recl=ibyte*ntreatx)

                 read(66,*) cfld
                 read(66,*) cunits
              do j=1,ntreatx
                  read(66,*) ntr,ccrop,nexp, (vout(j,i),i=1,nvarx)
                  print*,ntr,ccrop,nexp,(vout(j,i),i=1,nvarx)
                  if(vout(j,1).eq.-99) then
                    do i=1,nvarx
                      vout(j,i)=-99.
                    enddo
                   endif
!
              enddo
              print*,'ntreat_fin=',j
              mrec=0
              do i=1,nvarx
               mrec=mrec+1 
               write(67,rec=mrec) (vout(j,i),j=1,ntreatx)
              enddo

              stop
              end
eof1
cat << eof2 > read_dssat_1y_x-trat_2d
               program read_output_dssat
               implicit none
               character*1 zdummy
               character*80 cfld
               character*80 cunits
               integer ntreatx,nvarx
               parameter(nvarx=12,ntreatx=12)
               real vout(ntreatx,nvarx)
               integer i,j,ntr,nexp,mrec,ibyte
               parameter(ibyte=4)
               character*2 ccrop
                
               open(66,file='o1_1y.txt',&
     &           form='formatted')
               open(67,file='o1_1y_x-trat.dat',&
     &           access='direct',form='unformatted',recl=ibyte*ntreatx)

                 read(66,*) cfld
                 read(66,*) cunits
              do j=1,ntreatx
                  read(66,*) ntr,ccrop,nexp, (vout(j,i),i=1,nvarx)
                  print*,ntr,ccrop,nexp,(vout(j,i),i=1,nvarx)
                  if(vout(j,1).eq.-99) then
                    do i=1,nvarx
                      vout(j,i)=-99.
                    enddo
                   endif
!
              enddo
              print*,'ntreat_fin=',j
              mrec=0
              do i=1,nvarx
               mrec=mrec+1 
               write(67,rec=mrec) (vout(j,i),j=1,ntreatx)
              enddo

              stop
              end
eof2
cat << eof3 > read_dssat_allyy
               program read_output_dssat
               implicit none
               character*1 zdummy
               character*80 cfld
               character*80 cunits
               integer ntreatx,nvarx
               integer ys,ye,yxx
               parameter(nvarx=12,ntreatx=12, yxx=100)
               real vout(ntreatx,nvarx,yxx)
               integer i,j,ntr,nexp,mrec,ibyte
               integer it, nt, isk, nskip
               parameter(nskip=21)
               parameter(ibyte=4)
               character*2 ccrop
               character*20 cc

                
               open(66,file='o1_ally.txt',&
     &           form='formatted')
               open(67,file='o1_ally.dat',&
     &  access='direct',form='unformatted',recl=ibyte*ntreatx*nvarx)

                open(4,file='nam_info',form='formatted')
                   read(4,*) ys  
                   read(4,*) ye  
                close(4)
                nt=ye-ys+1
                 print*,'ys,ye,nt=', ys,ye,nt


                 do it=1,nt
                   print*,'read year=', ys+it-1

!                 do isk=1,nskip
!                    read(66,*) cc
!                 enddo
                 read(66,*) cfld
                 read(66,*) cunits
              do j=1,ntreatx
                 read(66,*) ntr,ccrop,nexp, (vout(j,i,it),i=1,nvarx)
                  if(vout(j,1,it).eq.-99) then
                    do i=1,nvarx
                      vout(j,i,it)=-99.
                    enddo
                   endif 
              enddo
              print*,'Done, ntreat_fin=',j-1, 'year=', ys+it-1
! end years loop              
                 enddo

              mrec=0
              do it=1,nt
               mrec=mrec+1 
               write(67,rec=mrec) ((vout(j,i,it),j=1,ntreatx),i=1,nvarx)
              enddo

              stop
              end
eof3

cat << eof4 > order_after_sowing_date and fertilization
!  post-processing multi-management simulations output: order_after_sowing_date and fertilization
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
eof4
#######################
cp ${daux}/read_dssat_${nplot}.F90 ${dwk}
cp ${daux}/scr_plot_${nplot} ${dout}

\rm merged_o1.txt merg_tmp
cp o1_${ys}.txt merged_o1.txt
yy=`expr ${ys} + 1 `
while [ ${yy} -le ${ye} ] ; do
cat merged_o1.txt o1_${yy}.txt > merg_tmp
\rm merged_o1.txt
mv merg_tmp merged_o1.txt
yy=`expr ${yy} + 1 `
done
cp merged_o1.txt o1_${nplot}.txt

### remove Failures ..
sed -i '/^  Crop/d' o1_${nplot}.txt
sed -i '/^Crop/d' o1_${nplot}.txt

rm rr.exe o1_${nplot}.dat scr_plot_${nplot}
echo "prep comp. 3"
gfortran -o rr.exe read_dssat_${nplot}.F90 
./rr.exe

\rm *jpg
cp ${daux}/o1_${nplot}.ctl .

\rm namplot
cat << EOF > namplot
ys=${ys}
ye=${ye}
test=${ctest}
setup=${setup}
scen=${scen}
fac=1.
EOF

cat namplot ${daux}/scr_plot_${nplot} > scr_plot_${nplot}
${gr} -blc scr_plot_${nplot}
mv o1_${nplot}.dat ${dout}
mv *jpg ${doutp}
fi

##############################
if [ "${nplot}" == "${nplot1}" ] || [ "${nplot}" == "${nplot2}" ] ; then
echo "NPLOT=" ${nplot}
cp ${daux}/read_dssat_${nplot}.F90 ${dwk}

yy=${ys}
while [ ${yy} -le ${ye} ] ; do

cp o1_${yy}.txt o1_1y.txt 
echo "prep comp. 1 sau 2"

### remove Failures ..
sed -i '/^  Crop/d' o1_1y.txt
sed -i '/^Crop/d' o1_${nplot}.txt

#grep "\S" tt2 > o1_1y.txt 

rm rr.exe o1_${nplot}.dat scr_plot_${nplot}
gfortran -o rr.exe read_dssat_${nplot}.F90 
./rr.exe

\rm *jpg
cp ${daux}/o1_${nplot}.ctl .
cat << EOF > namplot
yy=${yy}
ys=${ys}
ye=${ye}
test=${ctest}
setup=${setup}
scen=${scen}
fac=1.
EOF
cat namplot ${daux}/scr_plot_${nplot} > scr_plot_${nplot}
${gr} -blc scr_plot_${nplot}
mv o1_${nplot}.dat ${dout}/o1_${nplot}_${yy}.dat
#mv *jpg ${doutp}
yy=`expr ${yy} + 1 `
done
fi
echo "NPLOT_FIN=" ${nplot}
#################################################################
#################################################################
