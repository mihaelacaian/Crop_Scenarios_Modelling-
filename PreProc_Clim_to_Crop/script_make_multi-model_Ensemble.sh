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
# 1: Prel. for units, format_test
##########################################################
regmod=${creg}-${mreg}
echo "list_exp=" ${list_exp}
echo "list_models=" ${list_models}

case ${type} in \
  mm) namel=nam_extract_dayly;sdr=Monthly;;
  sd) namel=nam_extract_subday;sdr=Subdaily;;
  dd) namel=nam_extract_subday;sdr=Daily;;
esac

d0=myd0
out00=myout00
daux=mydaux
mkdir -p ${daux}

#######################################
for exp in ${list_exp} ; do

for model in ${list_models} ; do
slice0=${slice00}
case ${model} in \
 MOHC-HadGEM2-ES) slice0=${slice00_MOHC}
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

########## adjust ndayx for model with different calendar !!! #####
if [[ "$model" = "IPSL-IPSL-CM5A-MR" ]] ; then
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
if [[ "$model" = "MOHC-HadGEM2-ES" ]] ; then
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
#############################################
echo "ndayx=" ${ndayx}
#############################################

for var in ${listvar} ; do
out0=${out00}/${exp}/${var}/${loc}/${model}
#####\rm ${out0}/merg_${var}*
#mkdir -p ${out0}  

cd ${out0}
#####  remap same grid, extract sub-domain #############
#
echo "model=" ${model}
case ${model} in \
   'CNRM-CERFACS-CNRM-CM5') veri=r1i1p1;  vers=v1;;
   'ICHEC-EC-EARTH')       veri=r12i1p1; vers=v1;;
   'IPSL-IPSL-CM5A-MR')    veri=r1i1p1;  vers=v1;;
   'MOHC-HadGEM2-ES')      veri=r1i1p1;  vers=v1;;
   'MPI-M-MPI-ESM-LR')     veri=r1i1p1;  vers=v1a;;
esac
echo "veri=" ${veri} "vers=" ${vers}

out0=${out00}/${exp}/${var}/${loc}/${model}
d0=${d00}/${exp}/${var}
mkdir -p ${out0}

echo "exp=" ${exp}

d1=${d0}
d2=${d1}/REG
out1=${out0}
#\rm -rf ${d2} ${out1}
mkdir -p ${out1} ${d1} ${d2}

cd ${d1}
echo "PWD=" ${PWD}

\rm list_ped_${model}
ls ${var}_${resol}_${model}_${exp}_${veri}_${regmodel}_${vres}*nc > list_ped_${model}
for fa in $(cat list_ped_${model}) ; do
$cdo remapbil,${daux}/grid_Cordex.txt ${fa} ${d2}/${fa}_reg
$cdo sellonlatbox,${box} ${d2}/${fa}_reg ${out1}/${fa}_${loc}
\rm ${d2}/${fa}_reg
done

################

\rm list_reg merg*
ls ${var}*${resol}*${model}*${exp}*${regmod}*${loc} > list_reg
$cdo mergetime $(cat list_reg) merged_${var}_${exp}_${model}_${regmod}_${loc}.nc
$cdo -R -f nc copy merged_${var}_${exp}_${model}_${regmod}_${loc}.nc \
                merged_${var}_${exp}_${model}_${regmod}_${loc}.nc2
\rm merged_${var}_${exp}_${model}_${regmod}_${loc}.nc

$cdo setcalendar,standard merged_${var}_${exp}_${model}_${regmod}_${loc}.nc2 \
                          merged_${var}_${exp}_${model}_${regmod}_${loc}.nc
\rm merged_${var}_${exp}_${model}_${regmod}_${loc}.nc2
echo "done var=" ${var}
done
###########################
listvar1=${listvar}
listvar_input_DSSAT1=${listvar_input_DSSAT}

if [ -f ${out00}/${exp}/tas/${loc}/${model}/merged_tas_${exp}_${model}_${regmod}_${loc}.nc ] ; then
echo "found tas File !"
if [ -f ${out00}/${exp}/hurs/${loc}/${model}/merged_hurs_${exp}_${model}_${regmod}_${loc}.nc ]; then
echo "found hurs File !"
echo "files for td are here "
#Td = T - ((100 - RH)/5.)  (T in C deg)
\rm td_tmp* mer*_Cdeg
mkdir -p ${out00}/${exp}/td/${loc}/${model}
\rm ${out00}/${exp}/td/${loc}/${model}/merged_td_${exp}_${model}_${regmod}_${loc}.nc
$cdo  subc,273.15 ${out00}/${exp}/tas/${loc}/${model}/merged_tas_${exp}_${model}_${regmod}_${loc}.nc \
      ${out00}/${exp}/tas/${loc}/${model}/merged_tas_${exp}_${model}_${regmod}_${loc}.nc_Cdeg
$cdo  subc,100.  ${out00}/${exp}/hurs/${loc}/${model}/merged_hurs_${exp}_${model}_${regmod}_${loc}.nc \
          ${out00}/${exp}/hurs/${loc}/${model}/td_tmp1.nc
$cdo  divc,5.  ${out00}/${exp}/hurs/${loc}/${model}/td_tmp1.nc  \
               ${out00}/${exp}/hurs/${loc}/${model}/td_tmp2.nc
$cdo  add  ${out00}/${exp}/tas/${loc}/${model}/merged_tas_${exp}_${model}_${regmod}_${loc}.nc_Cdeg \
           ${out00}/${exp}/hurs/${loc}/${model}/td_tmp2.nc \
           ${out00}/${exp}/td/${loc}/${model}/merged_td_${exp}_${model}_${regmod}_${loc}.nc
\rm ${out00}/${exp}/hurs/${loc}/${model}/td_tmp*
\rm ${out00}/${exp}/tas/${loc}/${model}/merged_tas_${exp}_${model}_${regmod}_${loc}.nc_Cdeg
#
listvar1=${listvar}\ 'td'
listvar_input_DSSAT1=${listvar_input_DSSAT}\ 'td'
#
else  echo "WARNING: Not found file hurs"
fi
else  echo "WARNING: Not found file tas"
fi
echo "listvar1=" ${listvar1}
echo "listvar_input_DSSAT1=" ${listvar_input_DSSAT1}

###########################

for var in ${listvar1} ; do
out0=${out00}/${exp}/${var}/${loc}/${model}
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

fa=merged_${var}_${exp}_${model}_${regmod}_${loc}.nc

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
    ${moutxt}/merged_${var}_${exp}_${model}+${regmod}_${loc}_${yy}.txt
yy=`expr ${yy} + 1 `
done

echo "Done, var=" ${var}
done
###########################
echo "done model=" ${model}
done

echo "Done, exp=" ${exp}
done

echo "############  Done, Part1 - all models, all exp ######################"
######################################################
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
