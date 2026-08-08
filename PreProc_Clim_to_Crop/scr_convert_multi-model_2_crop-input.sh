#!/bin/sh
dbase='EURO-CORDEX'
mreg=RCA4
creg=SMHI
list_exp='historical'
clexp=HIST
type='dd'
freq=24
loc='Fundulea'
box='26.50,26.6,44.45,44.5'
lon0=26.55
lat0=44.48
alt0=66.
slice00='1970-01-01,2005-12-31'
slice00_MOHC='1970-01-01,2005-12-31'
# allowed: (1800,2200) : for this bisect 100y correction is applied to IPSL
# slice 0 is redefined (some models are shorter range !!)

listvar='hurs pr tas tasmin tasmax'
resol='EUR-11'
listvar_input_DSSAT='tasmax tasmin pr hurs'
list_models='CNRM-CERFACS-CNRM-CM5 ICHEC-EC-EARTH IPSL-IPSL-CM5A-MR MOHC-HadGEM2-ES MPI-M-MPI-ESM-LR'

cdo=mycdo
##########################################################
# 2: Prel for: Input_DSSAT
######################################################

#all vars done & available
#cd ${moutxt}/Preproc
#############################
for exp in ${list_exp} ; do
for model in ${list_models} ; do
slice0=${slice00}
case ${model} in \
 MOHC-HadGEM2-ES) slice0=${slice00_MOHC} ;;
esac
csl01=`expr ${slice0} | cut -c1-4 `
csl02=`expr ${slice0} | cut -c12-15 `
cm01=`expr ${slice0} | cut -c6-7 `
cm02=`expr ${slice0} | cut -c17-18 `
cd01=`expr ${slice0} | cut -c9-10 `
cd02=`expr ${slice0} | cut -c20-21 `


case ${exp} in \
  historical) ys=${csl01}; ye=${csl02};;
  rcp45)      ys=${csl11}; ye=${csl12};;
  rcp85)      ys=${csl21}; ye=${csl22};;
  evaluation) ys=${csl01}; ye=${csl02};;
esac
echo "csl=" $csl01 $csl02

moutxtprep=${out00}/${exp}/Preproc/${model}
rez=${out00}/${exp}/Input_DSSAT/${model}
mkdir -p ${moutxtprep} ${rez}
\rm -rf ${moutxtprep}/* ${rez}/*

cd ${moutxtprep}


yy=${ys}
while [ ${yy} -le ${ye} ] ; do
\rm fa_*

##### no of days in the year yy  ########################
cm0yy=1
cm1yy=12
if [ ${yy} -eq ${ys} ] ; then
datsta_yy=`expr ${slice0} | cut -c1-10`
datend_yy=${yy}-12-31
cm0yy=${cm01}
elif [ ${yy} -eq ${ye} ] ; then
datsta_yy=${yy}-01-01
datend_yy=`expr ${slice0} | cut -c12-21`
cm1yy=${cm02}
else
datsta_yy=${yy}-01-01
datend_yy=${yy}-12-31
fi

start_ts_yy=$(date -d "${datsta_yy}" '+%s')
echo "dats: " ${start_ts_yy}
end_ts_yy=$(date -d "${datend_yy} +1 day" '+%s')
echo "date: " ${end_ts_yy}
ndayx_yy=$(( ( end_ts_yy - start_ts_yy + 1 )/(60*60*24) ))
echo "ndayx_YY=" ${ndayx_yy}

###  adjustments per model:
########## adjust ndayx for model with different calendar !!! #####
if [ "$model" = "IPSL-IPSL-CM5A-MR" ] && [ ${cm0yy} -le 2 ]  && [ ${cm1yy} -ge 2 ] ; then
echo "ADJUST ndayx: model=" ${model}
yyp4=`expr ${yy} \/ 4 `
rest=`expr ${yy} - ${yyp4} \* 4 `
if [ ${rest} -eq 0 ] ; then
ndayx_yy=`expr ${ndayx_yy} - 1 `
fi

if [ ${yy} -eq 2100 ] || [ ${yy} -eq 1900 ] ; then
if [ ${cm0yy} -le 2 ] && [ ${cm1yy} -ge 2 ] ; then
ndayx_yy=`expr ${ndayx_yy} + 1 `
echo "IPSL_CORR: ndayx_in_2100=" ${ndayx_yy}
fi
fi

echo "ndayx_yy_IPSL=" ${ndayx_yy}
fi
###########################
###########################
if [[ "$model" = "MOHC-HadGEM2-ES" ]] ; then
if [ $yy -eq $ys ] ; then
nmmo=`expr 12 - $cm01 `
ndmo=$cd01
ndayx_yy=`expr 30 \* $nmmo + 30 - ${ndmo} + 1 `
elif [ $yy -eq $ye ] ; then
nmmo=`expr $cm02 - 1 `
ndmo=$cd02
if [ ${ndmo} -eq 31 ] ; then
ndmo=30
echo "CORR 31 days for MOHC, Last year"
fi
#
ndayx_yy=`expr 30 \* $nmmo + ${ndmo} `
else
ndayx_yy=`expr 30 \* 12 `
fi
echo "YEAR=" ${yy} "ndayx_YY_MOHC=" ${ndayx_yy}
fi

#####################################################################
echo ${listvar_input_DSSAT1}

for var in ${listvar_input_DSSAT1} ; do
echo "VAR_DASST=" ${var}
case ${var} in \
  sw)      varo=srad;fadd=0.;fmul=1.;;
  tasmax)  varo=tmax;fadd=273.15;fmul=1.;;
  tasmin)  varo=tmin;fadd=273.15;fmul=1.;;
  pr)      varo=rain;fadd=0.;fmul=1.;;
  w10)     varo=wind;fadd=0.;fmul=1.;;
  par)     varo=par;fadd=0.;fmul=1.;;
  evap)    varo=evap;fadd=0.;fmul=1.;;
  hurs)    varo=rhum;fadd=0.;fmul=1.;;
  td)      varo=dewp;fadd=0.;fmul=1.;;
esac
out0=${out00}/${exp}/${var}/${loc}/${model}
moutxt=${out0}/TXT

fain=${moutxt}/merged_${var}_${exp}_${model}+${regmod}_${loc}_${yy}.txt

cp ${fain} fa_${varo}
echo "VAR=" ${var} "FAIN=" ${fain}
done

##################
\rm ${moutxt}/namelist_descr*.txt
cat << EOF > namelist_descr_${var}_${yy}.txt 
\$namexp
 exper='${exp}',
 clexper='${clexp}',
 ys=${yy},
 ye=${yy},
 ms=01,
 me=12,
 ds=01,
 de=31,
 ndx=${ndayx_yy}, 
 freq=${freq},
 loclon=${lon0},
 loclat=${lat0},
 locelev=${alt0}
/
EOF
cp namelist_descr_${var}_${yy}.txt namelist_descr.txt

#cd ${moutxt}
\rm a.out read_4_DSSAT.F90 

cat << eofoper > read_4_DSSAT_base.F90
       program read_4_DSSAT
       implicit none
       character(len=10) :: exper
       character(len=3) ::  var
       character(len=4) ::  clexper
       integer ::  ys,ye,ms,me,ds,de,freq,ndx,ndxx
       parameter(ndxx=100*366)
       integer m4,ie,is,ntx,it
       real loclon,loclat, locelev, locamp,locrefth, locwndht
       real undeff
       parameter(undeff=-99.)
       real rad(ndxx), tmax(ndxx), tmin(ndxx), prec(ndxx), td(ndxx)
       real wind(ndxx), par(ndxx),evap(ndxx),rh(ndxx)

       namelist /namexp / exper,clexper, var, ys,ye,ds,de,ms,me,ndx,&
     &                    freq,loclon,loclat,locelev
!
        rad(:)=undeff
        tmax(:)=undeff
        tmin(:)=undeff
        prec(:)=undeff
        td(:)=undeff
        wind(:)=undeff
        par(:)=undeff
        evap(:)=undeff
        rh(:)=undeff

         locelev=undeff
         locamp=undeff
         locrefth=undeff
         locwndht=undeff
! 
        open(65,file='fa_tmax',form='formatted') 
        open(66,file='fa_tmin',form='formatted') 
        open(67,file='fa_rain',form='formatted') 
        open(68,file='fa_dewp',form='formatted') 
        open(72,file='fa_rhum',form='formatted') 
        
        open(80,file='faout.txt',form='formatted') 

        open(4,file='namelist_descr.txt')
        read(nml=namexp,unit=4)
        print*,exper,clexper, var, ys,ye,ms,me,ds,de,&
     & ndx,freq,loclon,loclat
        
        m4=(ye-ys)/4 
        ie=ye-ye/4*4
        is=ys-ys/4*4
         if((ie.eq.0).and.(ie.eq.0) ) then
           m4=m4+1
         endif
         print*,'m4=', m4
         ntx=(ye-ys+1)*365*freq+m4*freq
         print*,'NTX=', ntx
!
         write(80,'(a31)') '*WEATHER DATA : Grid cell 00001'
         write(80,*) '@ INSI   LAT       LONG      ELEV      TAV&
      &       AMP'
         write(80,&
     & '(a4, 3x, f7.2, 3x,f7.2, 3x,f7.2, 3x,f7.2, 3x,f7.2, 3x,f7.2)') &
     &             clexper, loclat, loclon, locelev, locamp,&
     &   locrefth, locwndht
         write(80,*) &
     &  '@DATE  SRAD          TMAX             TMIN             RAIN&
     &             DEWP&
     &             WIND            PAR              EVAP&
     &             RHUM'

         do it=1,ndx
          read(65,*) tmax(it)
          read(66,*) tmin(it)
          read(67,*) prec(it)
          read(68,*) td(it)
          read(72,*) rh(it)
         enddo
         do it=1,ndx
         write(80,*) rad(it),tmax(it),tmin(it),prec(it),td(it),&
     &     wind(it),par(it),evap(it),rh(it) 
         enddo
         stop
         end


eofoper
cp read_4_DSSAT_base.F90 read_4_DSSAT.F90
#
if [[ "$model" = "CNRM-CERFACS-CNRM-CM5" ]] || [[ "$model" = "ICHEC-EC-EARTH IPSL-IPSL-CM5A-MR" ]] ; then
cp read_4_DSSAT.F90_CNRM  read_4_DSSAT.F90
else
cp read_4_DSSAT.F90_MPI  read_4_DSSAT.F90
fi

cp ${daux}/read_4_DSSAT.F90 read_4_DSSAT.F90

gfortran read_4_DSSAT.F90

./a.out

cp faout.txt ${rez}/${clexp}${yy}01.WTH
echo "done, year=" ${yy}
yy=`expr ${yy} + 1 `
done

echo "############  Done, Part2 - model= " ${model} "all exp #######"
echo "done, model=" ${model}
done
#########
echo "done, exp=" ${exp}
done
##########################################################################
##########################################################################
##########################################################################
