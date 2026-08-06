#!/bin/sh
cdo='mycdo'
d00='myd00'
d0='myd0'

ddata='myddata'
###########################################################
var=TN
cm0=April
m0='04'
###########
cd ${d0}
d1=${d0}/${cm0}/${var}
\rm -f  ${d1}/*
mkdir -p ${d1}
#
cd ${d1}

$cdo selmon,${m0} ${ddata}/HISTORICAL/RO/Fundulea/${var}_hist_ENS_P1 \
    ${var}_hist_ENS_P1_${cm0}
$cdo selmon,${m0} ${ddata}/RCP4.5/RO/Fundulea/${var}_rcp4p5_ENS_P1 \
   ${var}_rcp45_ENS_P1_${cm0}
$cdo selmon,${m0} ${ddata}/RCP8.5/RO/Fundulea/${var}_rcp8p5_ENS_P1 \
   ${var}_rcp85_ENS_P1_${cm0}
$cdo selmon,${m0} ${ddata}/RCP4.5/RO/Fundulea/${var}_rcp4p5_ENS_P2 \
   ${var}_rcp45_ENS_P2_${cm0}
$cdo selmon,${m0} ${ddata}/RCP8.5/RO/Fundulea/${var}_rcp8p5_ENS_P2 \
   ${var}_rcp85_ENS_P2_${cm0}

cp ${var}_hist_ENS_P1_${cm0} ${var}_hist_ENS_P2_${cm0}
$cdo mergetime ${var}_hist_ENS_P1_${cm0} ${var}_rcp45_ENS_P1_${cm0} \
    ${var}_rcp45_ENS_P2_${cm0} merged_${var}_rcp45
$cdo mergetime ${var}_hist_ENS_P1_${cm0} ${var}_rcp85_ENS_P1_${cm0} \
    ${var}_rcp85_ENS_P2_${cm0} merged_${var}_rcp85
$cdo splitday merged_${var}_rcp45 merged_${var}_rcp45_dd
$cdo splitday merged_${var}_rcp85 merged_${var}_rcp85_dd

\rm l1 l2 l3
ls merg*nc > l1
for fa in $(cat l1) ; do $cdo -f nc copy ${fa} ${fa}2 ; done
for fa in $(cat l1) ; do $cdo sellonlatbox,26.2,26.7,44.2,44.7 ${fa}2 ${fa}_F ; done
ls *_F > l2
for fa in $(cat l2) ; do $cdo timmean ${fa} ${fa}_tm ; $cdo sub ${fa} ${fa}_tm anom_${fa} ; done
ls anom* > l3
for fa in $(cat l3) ; do rm a ; $cdo trend ${fa} a b_${fa} ; $cdo output b_${fa} > b_${fa}.txt ; done
cat \
  b_anom_merged_${var}_rcp45_dd05.nc_F.txt \
  b_anom_merged_${var}_rcp45_dd15.nc_F.txt \
  b_anom_merged_${var}_rcp45_dd25.nc_F.txt \
  b_anom_merged_${var}_rcp85_dd05.nc_F.txt \
  b_anom_merged_${var}_rcp85_dd15.nc_F.txt \
  b_anom_merged_${var}_rcp85_dd25.nc_F.txt > b_${var}_merged_45_3dec_85_3dec.txt
#########################################
