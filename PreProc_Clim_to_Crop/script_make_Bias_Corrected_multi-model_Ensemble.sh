#!/bin/sh

dbase='EURO-CORDEX'
mreg=RCA4
creg=SMHI
exp00='Adjust'
exp01='Adjust_1989-2010'

################
#list_exp='rcp45'
list_exp='historical'
listvar_rcp45='pr tasmax tasmin'
listvar_input_DSSAT='pr tasmax tasmin'
List_BCmeth_pref='IPSL-CDFT21-WFDEI IPSL-CDFT22-WFDEI METNO-QMAP-MESAN'

################
################
type='dd'
#######################
# unit freq=days
#freq=24
freq=1
loc='Fundulea'
loc0='F'
box='26.50,26.6,44.45,44.5'
lon0=26.55
lat0=44.48
alt0=66.
slice00='1971-01-01,2100-12-31'
slice00_MOHC='1971-01-01,2098-12-30'
#pr_METNO-QMAP-MESAN-rcp45_1989-2010: 1970-01-01
# allowed: (1800,2200) : for this bisect 100y correction is applied to IPSL
# slice 0 is redefined (some models are shorter range !!)
resol='EUR-11'

######################
cdo=mycdo
daux=mydaux
##########################################################
# 1: Prel. for units, format_test
##########################################################
regmod=${creg}-${mreg}
echo "list_exp=" ${list_exp}

#########################################

case ${type} in \
  mm) namel=nam_extract_daythly;sdr=Monthly;;
  sd) namel=nam_extract_subday;sdr=Subdaily;;
  dd) namel=nam_extract_day;sdr=Daily;;
esac


out00=myout00
daux=mydaux
mkdir -p ${daux}

##### loops  ##################################
for exp in ${list_exp} ; do
case ${exp} in \
  rcp45) listvar=${listvar_rcp45};clexp=RCP4;;
  rcp85) listvar=${listvar_rcp85};clexp=RCP8;;
esac

for var in ${listvar} ; do
#######

case ${exp} in \
 rcp45)
case ${var} in \
pr) var1=prAdjust_1989-2010;
    list_BCmeth='IPSL-CDFT21-WFDEI-'${exp}'_1979-2005 IPSL-CDFT22-WFDEI-'${exp}'_1979-2005 METNO-QMAP-MESAN-'${exp}'_1989-2010';;
tas) var1=tasAdjust_1989-2010;
    list_BCmeth='IPSL-CDFT21-WFDEI_'${exp}' IPSL-CDFT22-WFDEI_'${exp}' METNO-QMAP-MESAN_'${exp}'';;
tasmax) var1=tasmaxAdjust_1989-2010;
    list_BCmeth='METNO-QMAP-MESAN_'${exp}'';;
tasmin) var1=tasminAdjust_1989-2010;
    list_BCmeth='METNO-QMAP-MESAN_'${exp}'';;
esac
echo "LIST_BCmethods=" ${list_BCmeth} ;;
 rcp85)
case ${var} in \
pr) var1=prAdjust_1989-2010;
    list_BCmeth='IPSL-CDFT21-WFDEI-'${exp}'_1979-2005 IPSL-CDFT22-WFDEI-'${exp}'_1979-2005';;
tas) var1=tasAdjust_1989-2010;
    list_BCmeth='IPSL-CDFT21-WFDEI_'${exp}' IPSL-CDFT22-WFDEI_'${exp}'';;
tasmax) echo "tasmax is BC corrected only in RCP45 !!";;
tasmin) echo "tasminax is BC corrected only in RCP45 !!";;
esac
echo "LIST_BCmethods=" ${list_BCmeth} ;;
esac


for bm in ${list_BCmeth} ; do
#######

case ${bm} in \
 IPSL-CDFT21-WFDEI-${exp}_1979-2005) list_models='CERFACS-CNRM-CM5_IPSL-CDFT21-WFDEI_'${exp}' ICHEC-EC-EARTH_IPSL-CDFT21-WFDEI_'${exp}' IPSL-CM5A_MR_IPSL-CDFT21-WFDEI_'${exp}' SMHI-MOHC-HadGEM2-ES_IPSL-CDFT21-WFDEI_'${exp}'';;
 IPSL-CDFT21-WFDEI_${exp}) list_models='CERFACS-CNRM-CM5_IPSL-CDFT21-WFDEI_'${exp}' ICHEC-EC-EARTH_IPSL-CDFT21-WFDEI_'${exp}' IPSL-CM5A_MR_IPSL-CDFT21-WFDEI_'${exp}' SMHI-MOHC-HadGEM2-ES_IPSL-CDFT21-WFDEI_'${exp}'';;
 IPSL-CDFT22-WFDEI-rcp45_1979-2005) list_models='SMHI-CNRM-CERFACS-CNRM-CM5_IPSL-CDFT22-WFDEI_rcp45 ICHEC-EC-EARTH_IPSL-CDFT22-WFDEI_rcp45 IPSL-CM5A-MR_IPSL-CDFT22-WFDEI_rcp45 SMHI-MOHC-HadGEM2_IPSL-CDFT22-WFDEI_rcp45 SMHI.MPI-M-MPI-ESM-LR_IPSL-CDFT22-WFDEI_rcp45';;
 IPSL-CDFT22-WFDEI-rcp85_1979-2005) list_models='CERFACS-CNRM-CM5_IPSL-CDFT22-WFDEI_rcp85 ICHEC-EC-EARTH_IPSL-CDFT22-WFDEI_rcp85 IPSL-CM5A_MR_IPSL-CDFT22-WFDEI_rcp85 SMHI-MOHC-HadGEM2-ES_IPSL-CDFT22-WFDEI_rcp85 SMHI.MPI-M-MPI-ESM-LR_IPSL-CDFT22-WFDEI_rcp85';;
IPSL-CDFT22-WFDEI_rcp45) list_models='SMHI-CNRM-CERFACS-CNRM-CM5_IPSL-CDFT22-WFDEI_rcp45 ICHEC-EC-EARTH_IPSL-CDFT22-WFDEI_rcp45 IPSL-CM5A-MR_IPSL-CDFT22-WFDEI_rcp45 SMHI-MOHC-HadGEM2_IPSL-CDFT22-WFDEI_rcp45 SMHI.MPI-M-MPI-ESM-LR_IPSL-CDFT22-WFDEI_rcp45';;
IPSL-CDFT22-WFDEI_rcp85) list_models='CERFACS-CNRM-CM5_IPSL-CDFT22-WFDEI_rcp85 ICHEC-EC-EARTH_IPSL-CDFT22-WFDEI_rcp85 IPSL-CM5A_MR_IPSL-CDFT22-WFDEI_rcp85 SMHI-MOHC-HadGEM2-ES_IPSL-CDFT22-WFDEI_rcp85 SMHI.MPI-M-MPI-ESM-LR_IPSL-CDFT22-WFDEI_rcp85';;
 METNO-QMAP-MESAN-${exp}_1989-2010) list_models='CERFACS-CNRM-CM5_METNO-QMAP-MESAN_'${exp}' ICHEC_EC-EARTH-METNO-QMAP-MESAN_'${exp}' IPSL-CM5A_MR-METNO-QMAP-MESAN_'${exp};;
 METNO-QMAP-MESAN_${exp}) list_models='CERFACS-CNRM-CM5_METNO-QMAP-MESAN_'${exp}' ICHEC_EC-EARTH-METNO-QMAP-MESAN_'${exp}' IPSL-CM5A_MR-METNO-QMAP-MESAN_'${exp};;
esac
echo "LIST_MODELS=" ${list_models}


#### exceptii: ##############
# Nota!: erori in decada 2001-2011: SMHI, SMHI-MOHC-HadGEM2-ES_IPSL-CDFT21-WFDEI_'${exp} bug in decade: 2002-2011, for precip !!

case ${bm} in IPSL-CDFT21-WFDEI-rcp45_1979-2005) case ${var} in pr) \
    list_models='CERFACS-CNRM-CM5_IPSL-CDFT21-WFDEI_rcp45 ICHEC-EC-EARTH_IPSL-CDFT21-WFDEI_rcp45 IPSL-CM5A_MR_IPSL-CDFT21-WFDEI_rcp45';;
esac;;
esac
#
# Nota!: IPSL-CDFT22-WFDEI-${exp}_1979-2005) error is file SMHI.MPI-M-MPI-ESM-LR_IPSL-CDFT22-WFDEI_rcp45, decade: 61-70 !!!!

case ${bm} in IPSL-CDFT22-WFDEI-rcp45_1979-2005) case ${var} in pr)  \
    list_models='SMHI-CNRM-CERFACS-CNRM-CM5_IPSL-CDFT22-WFDEI_rcp45 ICHEC-EC-EARTH_IPSL-CDFT22-WFDEI_rcp45 IPSL-CM5A-MR_IPSL-CDFT22-WFDEI_rcp45 SMHI-MOHC-HadGEM2_IPSL-CDFT22-WFDEI_rcp45';;
esac;;
esac

echo "##########################################"
echo " Method for BC:" ${bm}
echo "##########################################"
echo "LIST_MODELS=" ${list_models}
########### TEST: #################
for model in ${list_models} ; do
out0=${out00}/${exp00}/${exp01}/${exp}/${var1}/${loc}/${bm}/${model}

slice0=${slice00}
case ${model} in \
 SMHI-MOHC-HadGEM2-ES_IPSL-CDFT21-WFDEI_${exp}) slice0=${slice00_MOHC} ;;
 SMHI-MOHC-HadGEM2_IPSL-CDFT22-WFDEI_rcp45) slice0=${slice00_MOHC} ;;
 SMHI-MOHC-HadGEM2-ES_IPSL-CDFT22-WFDEI_rcp85) slice0=${slice00_MOHC} ;;
esac

echo "SLICE0=" ${slice0}
##### no of days ########################
datsta=`expr ${slice0} | cut -c1-10`
datend=`expr ${slice0} | cut -c12-21`

start_ts=$(date -d "${datsta}" '+%s')
end_ts=$(date -d "${datend} +1 day" '+%s')
ndayx=$(( ( end_ts - start_ts + 1 )/(60*60*24) ))
echo "start=" ${start_ts}
echo "end=" ${end_ts}
echo "ndayx=" ${ndayx}

csl01=`expr ${slice0} | cut -c1-4 `
csl02=`expr ${slice0} | cut -c12-15 `
cslout0=${csl01}-${csl02}
cm01=`expr ${slice0} | cut -c6-7 `
cm02=`expr ${slice0} | cut -c17-18 `
cd01=`expr ${slice0} | cut -c9-10 `
cd02=`expr ${slice0} | cut -c20-21 `

echo "csl01=" $csl01 "csl02=" $csl02
echo "cm01=" $cm01 "cm02=" $cm02 "cd01=" $cd01 "cd02=" $cd02

### precip, tmin, tmax: no of days in year: 
###############################################################33
###############################################################33
###############################################################33
#case ${model} in \
#rcp45/ pr /
#CERFACS-CNRM-CM5_IPSL-CDFT21-WFDEI_rcp45) 47482; 365; 366 
#ICHEC-EC-EARTH_IPSL-CDFT21-WFDEI_rcp45) 47482 ; 365; 366
#IPSL-CM5A_MR_IPSL-CDFT21-WFDEI_rcp45) 47450; 365 mereu (30, 31 dar 28, fara 29) 
#SMHI-MOHC-HadGEM2-ES_IPSL-CDFT21-WFDEI_rcp45) 42527 (2098/12/20) ; are 28, 29 dar 30 mereu (fara 31)
##  !!! NOTA: din cauza erorii in decada 01-10 SMHI-MOHC*T21*rcp45, la mergetime
##  se schimba tipul calendarului de la 360 la gregoria !!

#SMHI-CNRM-CERFACS-CNRM-CM5_IPSL-CDFT22-WFDEI_rcp45  365, 366 
#ICHEC-EC-EARTH_IPSL-CDFT22-WFDEI_rcp45    365; 366 
#IPSL-CM5A-MR_IPSL-CDFT22-WFDEI_rcp45  28 mereu; 30, 31 (fara 29)
#SMHI-MOHC-HadGEM2_IPSL-CDFT22-WFDEI_rcp45) ;  mereu 30 zile
#SMHI.MPI-M-MPI-ESM-LR_IPSL-CDFT22-WFDEI_rcp45) 365; 366

#CERFACS-CNRM-CM5_METNO-QMAP-MESAN_rcp45) 365; 366
#ICHEC_EC-EARTH-METNO-QMAP-MESAN_rcp45) 365; 366
#IPSL-CM5A_MR-METNO-QMAP-MESAN_rcp45) NU are 29 (are 30, 31, 28)

##############################################
#rcp45/ tasmax:
#CERFACS-CNRM-CM5_METNO-QMAP-MESAN_rcp45: 31,30,29,28
#IPSL-CM5A_MR-METNO-QMAP-MESAN_rcp45: 31, 30, 28 (fara 29)
#SMHI-MOHC-HadGEM2-ES-QMAP-MESAN_rcp45 (NOT DONE): 
#ICHEC_EC-EARTH-METNO-QMAP-MESAN_rcp45 31,30, 29,28

#rcp45/tasmin
#CERFACS-CNRM-CM5_METNO-QMAP-MESAN_rcp45) 31,30,29,28
#IPSL-CM5A_MR-METNO-QMAP-MESAN_rcp45 31,30,28 (fara 29)
#SMHI-MOHC-HadGEM2-ES-QMAP-MESAN_rcp45 30 only
#ICHEC_EC-EARTH-METNO-QMAP-MESAN_rcp45 (NOT DONE): 
###########################################################################
 
#rcp85/ pr /
#CERFACS-CNRM-CM5_IPSL-CDFT21-WFDEI_rcp85) 31, 30, 29, 28
#ICHEC-EC-EARTH_IPSL-CDFT21-WFDEI_rcp85) 31,30,29,28
#IPSL-CM5A_MR_IPSL-CDFT21-WFDEI_rcp85) 31, 30, 28 (fara 29)
#SMHI-MOHC-HadGEM2-ES_IPSL-CDFT21-WFDEI_rcp85) 30 only !

#CERFACS-CNRM-CM5_IPSL-CDFT22-WFDEI_rcp85) 31, 30, 29, 28
#ICHEC-EC-EARTH_IPSL-CDFT22-WFDEI_rcp85) 31, 30, 29, 28
#IPSL-CM5A_MR_IPSL-CDFT22-WFDEI_rcp85) 31, 30,28 (no 29)
#SMHI-MOHC-HadGEM2-ES_IPSL-CDFT22-WFDEI_rcp85) 30 only !
#SMHI.MPI-M-MPI-ESM-LR_IPSL-CDFT22-WFDEI_rcp85) 31,30,29,28
##########################################################################
##########################################################################
##########################################################################

########## adjust ndayx for model with different calendar !!! #####
mpref=`expr ${model} | cut -c1-14 `

#CERFACS-CNRM-C
#ICHEC-EC-EARTH
#SMHI-CNRM-CERF
#SMHI.MPI-M-MPI

echo "PREF_model=" ${mpref}
#
if [ ${mpref} = "CERFACS-CNRM-C" ]  ||  [ ${mpref} = "ICHEC-EC-EARTH" ] ||  [ ${mpref} = "ICHEC_EC-EARTH" ] || [ ${mpref} = "SMHI-CNRM-CERF" ] ; then
echo "ndays-Model=" ${ndayx}
elif  [ "${mpref}" = "IPSL-CM5A_MR_I" ] || [ "${mpref}" = "IPSL-CM5A-MR_I" ] || [ "${mpref}" = "IPSL-CM5A_MR-M" ] || [ "${mpref}" = "SMHI.MPI-M-MPI" ] ; then
#IPSL-CM5A_MR_I
echo "ADJUST ndayx: model=" ${model}
if [ "$cm01" = "01" ] &&  [ "$cm02" = "12" ] ; then

nr41=`expr ${csl02} - ${csl01} + 1 `
nr42=`expr ${nr41} \/ 4 `
rest=`expr ${nr41} - ${nr42} \* 4 `
echo "REST=" ${rest}

if [ ${rest} -eq 0 ] ; then
nr4=${nr42}
#
elif [ ${rest} -eq 1 ] ; then
lyy1=`expr ${csl02}`
restl1=`expr ${lyy1} - ${lyy1} \/ 4 \* 4 `
if [ ${restl1} -eq 0 ] ; then 
nr4=`expr ${nr42} + 1 `
fi
#
elif [ ${rest} -eq 2 ] ; then
lyy1=`expr ${csl02}`
restl1=`expr ${lyy1} - ${lyy1} \/ 4 \* 4 `
lyy2=`expr ${csl02} - 1`
restl2=`expr ${lyy2} - ${lyy2} \/ 4 \* 4 `
if [ ${restl1} -eq 0 ]  || [ ${restl2} -eq 0 ]  ; then 
nr4=`expr ${nr42} + 1 `
fi
#
elif [ ${rest} -eq 3 ] ; then
lyy1=`expr ${csl02}`
restl1=`expr ${lyy1} - ${lyy1} \/ 4 \* 4 `
echo "REST_l1=" ${restl1}
lyy2=`expr ${csl02} - 1 `
restl2=`expr ${lyy2} - ${lyy2} \/ 4 \* 4 `
echo "REST_l2=" ${restl2}
lyy3=`expr ${csl02} - 2 `
restl3=`expr ${lyy3} - ${lyy3} \/ 4 \* 4 `
echo "REST_l3=" ${restl3}
if [ ${restl1} -eq 0 ]  || [ ${restl2} -eq 0 ]  || [ ${restl3} -eq 0 ]  ; then 
nr4=`expr ${nr42} + 1 `
fi
#
fi
#
ndayx=`expr ${ndayx} - ${nr4} `
echo "nr4=" ${nr4}
echo "ndayx=" ${ndayx}

echo "IPSL: ndayx_before_2100=" ${ndayx}
if [ ${csl02} -ge 2100 ] && [ ${cm02} -gt 2 ] ; then
ndayx=`expr ${ndayx} + 1 `
echo "ndayx_after_2100=" ${ndayx}
fi
if [ ${csl01} -le 1900 ] && [ ${cm01} -le 2 ] ; then
ndayx=`expr ${ndayx} + 1 `
echo "ndayx_before_1900=" ${ndayx}
fi
############
r1=`expr $csl01 - $csl01 \/ 4 \* 4 `
echo "R1=" $r1
elif [ $cm01 -gt 2 ] &&  [ $r1 -eq 0 ] ; then
  ndayx=`expr ${ndayx} - 1 `
fi
 
# end if IPSL:
echo "ndayx_IPSL=" ${ndayx}

fi
###########################
#SMHI-MOHC-HadGEM2_IPSL-CDFT22-WFDEI_rcp45) ;  mereu 30 zile
#SMHI-MOHC-HadGEM2-ES-QMAP-MESAN_rcp45 (NOT DONE): 
#SMHI-MOHC-HadGEM2-ES-QMAP-MESAN_rcp45 30 only
#SMHI-MOHC-HadGEM2-ES_IPSL-CDFT21-WFDEI_rcp85) 30 only !
#if [[ "$model" = "MOHC-HadGEM2-ES" ]] ; then

if [ "$mpref" = "SMHI-MOHC-HadG" ] ; then
echo "ADJUST ndayx: model=" ${model} ${csl02} ${csl01}
nr41=`expr ${csl02} - ${csl01} + 1 `
ndayx0=`expr ${nr41} \* 12 \* 30 `
echo "ndayx0=" ${ndayx0}

if [ "$cm01" = "01" ] &&  [ "$cm02" = "12" ] && [ "$cd01" = "01" ] && [ "$cd02" = "31" ] ; then
ndayx=${ndayx0}
elif [ "$cm01" = "01" ] &&  [ "$cm02" = "12" ] ; then
echo " case: Not full months, MOHC: calc sh1, sh2"
shd2=`expr 30 - ${cd02} `
ndayx=`expr ${ndayx0} - ${shd2}`
shd1=`expr ${cd01} - 1 `
ndayx=`expr ${ndayx} - ${shd1} `
else
echo " case: Not full years (and poss.not full months), MOHC"
shm1=`expr  $cm01 - 1 `
shm2=`expr  12 - $cm02 `
ndayx=`expr ${ndayx0} - ${shm1} \* 30 - ${cd01} + 1 - ${shm2} \* 30 - 30 + ${cd02} `
fi
echo "ndayx_MOHC=" ${ndayx}
fi

################################################################
###########################

cd ${out0}

echo "d0=" ${PWD}
ls -l
ls ${var}*${resol}*${model}*${exp}*nc > list_ped_${model}
for fa in $(cat list_ped_${model}) ; do
$cdo remapbil,${daux}/grid_Cordex.txt ${fa} ${fa}_reg
$cdo sellonlatbox,${box} ${fa}_reg ${fa}_${loc}
done
 
##### remap same grid, extract sub-domain #################

######################
\rm list_reg merg*
#ls ${var}*${resol}*${model}*${exp}*${regmod}*${loc} > list_reg

# bm, model are found in d0 path name....

ls ${var}*${resol}*${exp}*${loc0} > list_reg
$cdo mergetime $(cat list_reg) merged_${var}_${exp}.nc
$cdo -R -f nc copy merged_${var}_${exp}.nc \
                merged_${var}_${exp}.nc2
$cdo seldate,${datsta},${datend} \
                merged_${var}_${exp}.nc2 \
                merged_${var}_${exp}.nc3
\rm merged_${var}_${exp}.nc2
\rm merged_${var}_${exp}.nc

$cdo setcalendar,standard merged_${var}_${exp}.nc3 \
                          merged_${var}_${exp}.nc
\rm merged_${var}_${exp}.nc3
#echo "done var=" ${var}
#done
###########################
### no RHUM => no TD for Adjust 
###########################

listvar1=${listvar}
echo "listvar1=" ${listvar1}

###########################

#for var in ${listvar1} ; do
#out0=${out00}/${exp}/${var}/${loc}/${model}
moutxt=${out0}/TXT
mkdir -p ${moutxt}
moutxtyy=${moutxt}/YY_tmp
rm -rf ${moutxtyy}
mkdir -p ${moutxtyy} 

fadd=0.
fmul=1.
case ${var} in \
  sw)      varo=srad;fadd=0.;fmul=1.;;
  tasmax)  varo=tmax;fadd=-273.15;fmul=1.;;
  tasmin)  varo=tmin;fadd=-273.15;fmul=1.;;
  pr)      varo=rain;fadd=0.;fmul=1.;;
  w10)     varo=wind;fadd=0.;fmul=1.;;
  par)     varo=par;fadd=0.;fmul=1.;;
  evap)    varo=evap;fadd=0.;fmul=1.;;
  hurs)    varo=rhum;fadd=0.;fmul=1.;;
  td)      varo=dewp;fadd=0.;fmul=1.;;
esac
echo "add:" ${fadd} "mul:" ${fmul}

fa=merged_${var}_${exp}.nc

$cdo addc,${fadd} ${out0}/${fa} ${out0}/${fa}_add
\rm ${out0}/${fa}
$cdo mulc,${fmul} ${out0}/${fa}_add \
                   ${out0}/${fa}
\rm ${out0}/${fa}_add

\rm ${moutxtyy}/yy_
$cdo splityear ${out0}/${fa} \
               ${moutxtyy}/yy_
yy=${csl01}
while [ ${yy} -le ${csl02} ] ; do
$cdo output ${moutxtyy}/yy_${yy}.nc > \
    ${moutxt}/merged_${var}_${exp}_${yy}.txt
yy=`expr ${yy} + 1 `
done

echo "Done, model=" ${model}
done
echo "Done, bm=" ${bm}
done

###########################
echo "Done, var=" ${var}
done

echo "Done, exp=" ${exp}
done

echo "############  Done, Part1 - all models, all exp ######################"
echo "############  START PART 2 ######################"

#######################################
#NEW
######################################################
# 2: Prel for: Input_DSSAT
######################################################

#list_models='CNRM-CERFACS-CNRM-CM5 ICHEC-EC-EARTH IPSL-IPSL-CM5A-MR MOHC-HadGEM2-ES MPI-M-MPI-ESM-LR'
#############################

for exp in ${list_exp} ; do
case ${exp} in \
rcp45) listvar=${listvar_rcp45};clexp='RCP4';;
rcp85) listvar=${listvar_rcp85};clexp='RCP8';;
esac
echo "LISTVAR=" ${listvar}

#List_BCmeth_pref='IPSL-CDFT21-WFDEI IPSL-CDFT22-WFDEI METNO-QMAP-MESAN'

for bm in ${List_BCmeth_pref} ; do
echo "##########################################"
echo " Method for BC:" ${bm}
echo "##########################################"

#######
case ${bm} in \
   IPSL-CDFT21-WFDEI) list_models='CERFACS-CNRM-CM5_IPSL-CDFT21-WFDEI_'${exp}' ICHEC-EC-EARTH_IPSL-CDFT21-WFDEI_'${exp}' IPSL-CM5A_MR_IPSL-CDFT21-WFDEI_'${exp}' SMHI-MOHC-HadGEM2-ES_IPSL-CDFT21-WFDEI_'${exp}'';;
   IPSL-CDFT22-WFDEI)  case ${exp} in \
        rcp45) list_models='SMHI-CNRM-CERFACS-CNRM-CM5_IPSL-CDFT22-WFDEI_rcp45 ICHEC-EC-EARTH_IPSL-CDFT22-WFDEI_rcp45 IPSL-CM5A-MR_IPSL-CDFT22-WFDEI_rcp45 SMHI-MOHC-HadGEM2_IPSL-CDFT22-WFDEI_rcp45 SMHI.MPI-M-MPI-ESM-LR_IPSL-CDFT22-WFDEI_rcp45';;
        rcp85) list_models='CERFACS-CNRM-CM5_IPSL-CDFT22-WFDEI_rcp85 ICHEC-EC-EARTH_IPSL-CDFT22-WFDEI_rcp85 IPSL-CM5A_MR_IPSL-CDFT22-WFDEI_rcp85 SMHI-MOHC-HadGEM2-ES_IPSL-CDFT22-WFDEI_rcp85 SMHI.MPI-M-MPI-ESM-LR_IPSL-CDFT22-WFDEI_rcp85';; esac;;
   METNO-QMAP-MESAN) list_models='CERFACS-CNRM-CM5_METNO-QMAP-MESAN_'${exp}' ICHEC_EC-EARTH-METNO-QMAP-MESAN_'${exp}' IPSL-CM5A_MR-METNO-QMAP-MESAN_'${exp};;
esac
echo "LIST_MODELS=" ${list_models}


## Nu am mai exclus cazurile de exceptie, deoarece NU va gasi fiserul (le-am exclus la partea netcf) si va lua "default"
###
#### exceptii: ##############
# Nota!: erori in decada 2001-2011: SMHI, SMHI-MOHC-HadGEM2-ES_IPSL-CDFT21-WFDEI_'${exp} bug in decade: 2002-2011, for precip !!
#case ${bm0} in IPSL-CDFT21-WFDEI-rcp45_1979-2005) case ${var} in pr) \
#    list_models='CERFACS-CNRM-CM5_IPSL-CDFT21-WFDEI_'${exp}' ICHEC-EC-EARTH_IPSL-CDFT21-WFDEI_'${exp}' IPSL-CM5A_MR_IPSL-CDFT21-WFDEI_'${exp}'';;
#esac;;
#esac
#
# Nota!: IPSL-CDFT22-WFDEI-${exp}_1979-2005) error is file SMHI.MPI-M-MPI-ESM-LR_IPSL-CDFT22-WFDEI_rcp45, decade: 61-70 !!!!
#
#case ${bm} in IPSL-CDFT22-WFDEI-rcp45_1979-2005) case ${var} in pr)  \
#    list_models='SMHI-CNRM-CERFACS-CNRM-CM5_IPSL-CDFT22-WFDEI_rcp45 ICHEC-EC-EARTH_IPSL-CDFT22-WFDEI_rcp45 IPSL-CM5A-MR_IPSL-CDFT22-WFDEI_rcp45 SMHI-MOHC-HadGEM2_IPSL-CDFT22-WFDEI_rcp45';;
#esac;;
#esac
#############################################################################################
#
########### TEST: #################
for model in ${list_models} ; do
echo "MODEL=" ${model}

cmod=`expr ${model} | cut -c1-12 `
echo "CMOD=" ${cmod}

#cat << EOF >> ${daux}/cmod.txt
#$cmod ${model}
#EOF

slice0=${slice00}
case ${model} in \
 SMHI-MOHC-HadGEM2-ES_IPSL-CDFT21-WFDEI_${exp}) slice0=${slice00_MOHC} ;;
 SMHI-MOHC-HadGEM2_IPSL-CDFT22-WFDEI_rcp45) slice0=${slice00_MOHC} ;;
 SMHI-MOHC-HadGEM2-ES_IPSL-CDFT22-WFDEI_rcp85) slice0=${slice00_MOHC} ;;
esac

echo "SLICE0=" ${slice0}

csl01=`expr ${slice0} | cut -c1-4 `
csl02=`expr ${slice0} | cut -c12-15 `
cm01=`expr ${slice0} | cut -c6-7 `
cm02=`expr ${slice0} | cut -c17-18 `
cd01=`expr ${slice0} | cut -c9-10 `
cd02=`expr ${slice0} | cut -c20-21 `

case ${exp} in \
  historical) ys=${csl01}; ye=${csl02};;
  rcp45)      ys=${csl01}; ye=${csl02};;
  rcp85)      ys=${csl01}; ye=${csl02};;
  evaluation) ys=${csl01}; ye=${csl02};;
esac
echo "csl=" $csl01 $csl02
#################### calendar per model 


mpref=`expr ${model} | cut -c1-14 `


yy=${ys}
while [ ${yy} -le ${ye} ] ; do

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

echo "MPREF_Year=" ${mpref}

#if  [ "$mpref" = "IPSL-CM5A_MR_I" ] || [ "$mpref" = "IPSL-CM5A_MR_M" ] || [ "$mpref" = 'SMHI.MPI-M-MPI' ] ; then
if  [ "${mpref}" = "IPSL-CM5A_MR_I" ] || [ "${mpref}" = "IPSL-CM5A-MR_I" ] || [ "${mpref}" = "IPSL-CM5A_MR-M" ] || [ "${mpref}" = "SMHI.MPI-M-MPI" ] ; then

 if [  ${cm0yy} -le 2 ]  && [ ${cm1yy} -ge 2 ] ; then
echo "ADJUST ndayx_YY: model=" ${model}
#if [ "$model" = "IPSL-IPSL-CM5A-MR" ] && [ ${cm0yy} -le 2 ]  && [ ${cm1yy} -ge 2 ] ; then
yyp4=`expr ${yy} \/ 4 `
rest=`expr ${yy} - ${yyp4} \* 4 `
    if [ ${rest} -eq 0 ] ; then
ndayx_yy=`expr ${ndayx_yy} - 1 `
    fi
  fi
## pt 2100 si 1900 s-a efectuat deja corectia, daca anul include luna Feb: tb. sa revenim la corectia facuta
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
#if [[ "$model" = "MOHC-HadGEM2-ES" ]] ; then
#if [ "$mpref" = "SMHI-MOHC-HadG" ] ; then
if [ "${mpref}" = "SMHI-MOHC-HadG" ] ; then
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
#echo "listvar_input_DSSAT1=" ${listvar_input_DSSAT1}

echo "pwd1=" ${PWD}
for vard in ${listvar_input_DSSAT} ; do
echo "VARD=" ${vard}

sufsl_bm=''
case ${bm} in \
  IPSL-CDFT21-WFDEI) sufsl_pr_bm='_1979-2005';;
  IPSL-CDFT22-WFDEI) sufsl_pr_bm='_1979-2005';;
  METNO-QMAP-MESAN)  sufsl_pr_bm='_1989-2010';;
esac
# consider experiment sufix (sufe_bm) and slice sufix (sufsl_bm) for bm:
case ${vard} in \
  sw)      varo=srad;fadd=0.;fmul=1.;sufe_bm='-'${exp};;
  tasmax)  varo=tmax;fadd=273.15;fmul=1.;var1=tasmaxAdjust_1989-2010;sufe_bm='_'${exp};;
  tasmin)  varo=tmin;fadd=273.15;fmul=1.;var1=tasminAdjust_1989-2010;sufe_bm='_'${exp};;
  pr)      varo=rain;fadd=0.;fmul=1.;var1=prAdjust_1989-2010;sufe_bm='-'${exp};sufsl_bm=${sufsl_pr_bm};;
  w10)     varo=wind;fadd=0.;fmul=1.;sufe_bm='-'${exp};;
  par)     varo=par;fadd=0.;fmul=1.;sufe_bm='-'${exp};;
  evap)    varo=evap;fadd=0.;fmul=1.;sufe_bm='-'${exp};;
  hurs)    varo=rhum;fadd=0.;fmul=1.;sufe_bm='-'${exp};;
  td)      varo=dewp;fadd=0.;fmul=1.;sufe_bm='-'${exp};;
esac

# bm este  in list_BCmeth_pref ; la fel va fi Outputul
moutxtprep=${out00}/${exp00}/${exp01}/${exp}/Preproc/NEW/${bm}/${model}
rez=${out00}/${exp00}/${exp01}/${exp}/Input_DSSAT/NEW/${bm}/${model}
mkdir -p ${moutxtprep} ${rez}
#\rm -rf ${moutxtprep}/* ${rez}/*

cd ${moutxtprep}
\rm fa_${varo}
################


outd=${out00}/${exp00}/${exp01}/${exp}/${var1}/${loc}/${bm}${sufe_bm}${sufsl_bm}/${model}
echo "outd=" ${outd}

moutxt=${outd}/TXT
echo "moutxt=" ${moutxt}
#ls -l ${moutxt}

fain=${moutxt}/merged_${vard}_${exp}_${yy}.txt
fain_def=${daux}/merged_default.txt

if [ -f ${fain} ] ; then
echo "FOUND file: " ${fain} 
ls -l ${fain}
echo "fa_=" fa_${varo}
cp ${fain} fa_${varo}
else
cp ${fain_def} fa_${varo}
fi

echo "done, VAR=" ${vard} "FAIN=" ${fain}
done
echo "pwd2=" ${PWD}
ls -l fa_*

##################
\rm ${moutxtprep}/namelist_descr*.txt
cat << EOF > namelist_descr_${yy}.txt 
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
cp namelist_descr_${yy}.txt namelist_descr.txt

\rm a.out read_pr_tasmax_tasmin_DSSAT_newFormat_1y_${cmod}.F90

ls -l ${daux}/read_pr_tasmax_tasmin_DSSAT_newFormat_1y_${cmod}.F90


cp ${daux}/read_pr_tasmax_tasmin_DSSAT_newFormat_1y_${cmod}.F90 read_Adjust_DSSAT.F90
echo "IN dir=" ${PWD}

gfortran read_Adjust_DSSAT.F90
./a.out

cp faout.txt ${rez}/${clexp}${yy}01.WTH
echo "done, year=" ${yy}
yy=`expr ${yy} + 1 `
done

##################################
echo "done, model=" ${model}
done
echo "done, bm=" ${bm}
done
echo "############  Done, Part2 - model= " ${model} "all exp #######"
#########
echo "done, exp=" ${exp}
done
##########################################################################
##########################################################################
##########################################################################
