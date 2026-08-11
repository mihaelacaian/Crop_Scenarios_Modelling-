#!/bin/sh
d0=myd0/Date/Output_per_UAT_extreme_agroclim_ind
#############################
jud=Cal
ind=103032
mm='04'


for var in RR FD R10mm R20mm` ; do
d1=${d0}/${var}/UAT/${jud}/Transform_nc_decade
dtr=${d1}/Trends

mkdir -p ${dtr}

cd ${d1}
\rm listtr_${var}
ls ENS*${ind}*${mm}*.nc > listtr_${var}

for fa in $( cat listtr_${var} ) ; do
\rm a b
cdo trend ${fa} a b
cdo subtrend ${fa} a b ${fa}_utr
cdo sub ${fa} ${fa}_utr ${dtr}/trline_${fa}
\rm ${fa}_utr
done
echo "Done, var=" ${var}
done
#######################################


