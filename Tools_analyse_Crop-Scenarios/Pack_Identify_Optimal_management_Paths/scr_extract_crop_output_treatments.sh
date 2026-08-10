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
cat << eof1 > read_dssat_1y_x-trat_2d

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
