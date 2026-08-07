#!/bin/sh
#
#dateb=20170101
dateb=20200301
##############################################
box='26.45,26.55,44.45,44.55'   # Fundulea: 44.5; 26.5
loc=Fundulea
lcorunits_obs=.true. 
    # true=" datele Obs/Reana de intrare NU sunt corecate, facem aici la "call Reana" corectia Unitatilor SI inputul in RUN sunt unitati corectate"
lcorunits_for=.true.
    # true="  datele de intrare NU sunt corecate, facem aici in acest script corectia Unitatilor SI inputul in RUN sunt unitati corectate"
    # false=" datele de intrare NU sunt corecate si NU facem aici corectia, dar se face corectia in RUN (read*F90)
#
lgetf=.true.  # true=get data within thsis script; (.false. cand datele Forecast sunt deja aduse)
lgeto=.true.  # true=get data within thsis script; (.false. cand datele Obs/ Reanalysis sunt deja aduse)
irun=0 # all steps
##############################################
##############################################
#
#
# irun=3 # only run + plot (same $dateb, unless change directly in Run scripts )
# irun=4 # only plot (same $dateb)
######################################################################################
#varpl='var4_Harwt'
varpl="Harvest  Nutrients  Phenology  Soil_water"
####
dateb6=`expr ${dateb} | cut -c1-6 `
date_reana=$(date -d "$dateb -1 month" +%Y-%m-%d)
echo " ########## irun= " ${irun}
echo "date_base_forec=" ${dateb} " date_reana=" ${date_reana}

python=mypython
cdo=mycdo
##################################################
ys=` expr ${dateb} | cut -c1-4 `
mms=` expr ${dateb} | cut -c5-6 `
mmsval=$(expr ${mms} + 0)

echo "mmsval=" ${mmsval}
grib_filter=mygrib_filter
dd=mydd
dsc=mydsc
daux=mydaux
dplot=mydplot
dauxpl=mydauxpl
dscrea=mydscrea
dauxr=mydauxr

dscrun=mydscrun
dauxrun=${dscrun}/Auxil_RUN
###############################################

dout1="${dd}/Data/GRIB_Forecast+Reana/Forecast/Seas5/${ys}"
dout1rea="${dd}/Data/GRIB_Forecast+Reana/Reana/ERA5/${ys}/${loc}/Merged_${ys}"
mkdir -p ${dout1} ${dout1rea}

dbase1="${dout1}/Baza_${dateb6}"
mkdir -p ${dbase1}
ddate1="${dbase1}/Grib_filter"
ddate2="${dbase1}/Grib_filter/NC"
ddate3=${dbase1}/Grib_filter/NC/${loc}
ddate4=${dbase1}/Grib_filter/NC/${loc}/TXT

mkdir -p ${ddate1} ${ddate2} ${ddate3} ${ddate4}

#############
######################################################
#####################################################
#  0. find no of days in month: ndx ########################
#####################################################
#####################################################
cd ${dsc}
\rm -f ndx.txt
days_in_month() {
    local year=${ys}
    local month=${mms}
    date -d "$year-$month-01 + 1 month - 1 day" "+%d"
}

# 
days_in_month ${ys} ${mms} > ndx.txt
ndx=$(cat ndx.txt)
echo "ndx=" ${ndx}

#####################################################
#  1. Forecast data ########################
#  1.1 GET Forecast data ########################
#####################################################
#####################################################

cd ${dsc}
\rm -f scr_GET_Forecast_p1 namdat_sh
cat << EOF > namdat_sh
#!/bin/sh
datbase="${dateb}"
box=${box}
loc=${loc}
lcorunitsf=${lcorunits_for}
lcorunitso=${lcorunits_obs}
lgetf=${lgetf}
lgeto=${lgeto}
EOF
\rm -f namdat_py
cat << EOF > namdat_py
year = ${ys}
month = ${mmsval}
EOF
#

levtype=sfc
type=fc

if [ $irun -lt 3 ] ; then
echo " Go for Forecast & Reana in:  " ${dsc}


if [ "${lgetf}" = ".true." ] ; then
#\rm -f  ${dbase1}/*grib 


cat << eof3 > scr_GET_Forecast_base 

#datbase="20200301"
#box=26.45,26.55,44.45,44.55
#loc=Fundulea
#lcorunitsf=.true.
#lcorunitso=.true.
#lgetf=.true.
#lgeto=.true.

####################################################
dateb=${datbase}
dateb6=`expr ${dateb} | cut -c1-6 `

python='/home/mihaela/anaconda3/bin/python'
dd=/home/oper3/OPER/C3S/Prel_CRON/Module2_Adaptation/DSSAT_forecast
daux0=${dd}/Scripts_DSSAT_oper/Forecast/Seas5/Auxil
daux=${daux0}/py_Seas5
###########
ys=` expr ${dateb} | cut -c1-4 `
dout1="${dd}/Data/GRIB_Forecast+Reana/Forecast/Seas5/${ys}"
dbase1="${dout1}/Baza_${dateb6}"
mkdir -p ${dout1} ${dbase1}

#\rm -f output_*.grib
####################################################

cd ${dbase1}
echo "dbase1=" ${dbase1}

for var in tp ssrd mx2t24 mn2t24  ; do

ssb=scr_${var}_Base
#ssb=scr_${var}_param_dssat_base.py
ss=scr_${var}_param_dssat.py
\rm -f ss nam_var

cat << EOF > nam_var
cdat="${dateb}"
var="${var}"
EOF
cat nam_var ${daux}/${ssb} > ${ss}
$python ${ss} 1>o1_${var} 2>o2_${var} &
echo "sent querry " ${ss}
done
wait
echo "Done, get-grib daily foreacast seas5 "
######################################################
######################################################
eof3

cat namdat_sh scr_GET_Forecast_base > ${dsc}/scr_GET_Forecast_p1
chmod u+x scr_GET_Forecast_p1
./scr_GET_Forecast_p1 1>o3 2>o4 &
wait

#echo " Data:  Units: K; K; W*m-2*s sau J*m-2; [m].   txt Fundulea in: " ${ddate4}
#echo " convert J*m-2 to MJ*m-2-day : divide daily sum by 1.e+6 "

echo "output in " ${dbase1}

fi
#####################
#  1.2. GRiB to TXT ###
#####################


cd ${dbase1}
echo "dbase1=" ${dbase1}
#cp ${daux}/rule_sys5 .

for var in tp ssrd mx2t24 mn2t24  ; do

grib_filter ${daux}/rule_sys5 ${dbase1}/output_${var}_0-4mem.grib 
grib_filter ${daux}/rule_sys5 ${dbase1}/output_${var}_5-9mem.grib 
grib_filter ${daux}/rule_sys5 ${dbase1}/output_${var}_10-14mem.grib 
grib_filter ${daux}/rule_sys5 ${dbase1}/output_${var}_15-19mem.grib 
grib_filter ${daux}/rule_sys5 ${dbase1}/output_${var}_20-24mem.grib 
grib_filter ${daux}/rule_sys5 ${dbase1}/output_${var}_25-29mem.grib 
grib_filter ${daux}/rule_sys5 ${dbase1}/output_${var}_30-34mem.grib 
grib_filter ${daux}/rule_sys5 ${dbase1}/output_${var}_35-39mem.grib 
grib_filter ${daux}/rule_sys5 ${dbase1}/output_${var}_40-44mem.grib 
grib_filter ${daux}/rule_sys5 ${dbase1}/output_${var}_45-49mem.grib 
grib_filter ${daux}/rule_sys5 ${dbase1}/output_${var}_50mem.grib 

mv ${var}_* ${ddate1}

for mem in  mem0  mem1  mem2  mem3  mem4  mem5  mem6  mem7  mem8  mem9 mem10 mem11 mem12 mem13 mem14 mem15 mem16 mem17 mem18 mem19 mem20 mem21 mem22 mem23 mem24 mem25 mem26  mem27  mem28  mem29  mem30  mem31  mem32  mem33  mem34  mem35  mem36  mem37  mem38  mem39  mem40  mem41  mem42  mem43  mem44  mem45  mem46  mem47  mem48  mem49  mem50 ; do

cdo -R -f nc copy ${ddate1}/${var}_${levtype}_${type}_${dateb}_${mem}.grib \
         ${ddate2}/${var}_${levtype}_${type}_${dateb}_${mem}.nc2

####### lcorunits_for=.true. : make corrections for Units
if [ "${lcorunits_for}" = ".true." ] ; then
cdo sellonlatbox,${box} \
   ${ddate2}/${var}_${levtype}_${type}_${dateb}_${mem}.nc2 \
       ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc_cal
cdo shifttime,-1day  \
       ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc_cal \
       ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc2

\rm -f ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc_cal

#echo "make here corrections to units "
if [ "${var}" = "mx2t24" ] || [ "${var}" = "mn2t24" ] ; then
$cdo subc,273.15 ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc2 \
            ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc3
fi
if [ "${var}" = "ssrd" ] ; then
$cdo seltimestep,1 ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc2 \
            ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc2_step1
$cdo deltat ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc2 \
            ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc4
$cdo mergetime ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc2_step1 \
              ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc4 \
              ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc5
$cdo divc,1.e+6 ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc5 \
                ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc3
fi
if [ "${var}" = "tp" ] ; then
$cdo seltimestep,1 ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc2 \
                   ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc2_step1
$cdo deltat ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc2 \
            ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc4
$cdo mergetime ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc2_step1 \
           ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc4 \
           ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc5
$cdo mulc,1000. ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc5 \
             ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc6
$cdo setrtoc,-1000,0,0. ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc6 \
               ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc3
fi
\rm -f ${ddate3}/*nc4 ${ddate3}/*nc5 ${ddate3}/*nc6
#ls -l ${ddate3}/*nc4 ${ddate3}/*nc5 ${ddate3}/*nc6
#\rm -f ${ddate3}/*nc2


cdo output  ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc3 > \
            ${ddate4}/${var}_${levtype}_${type}_${dateb}_${mem}_F.txt

else
cdo output  ${ddate3}/${var}_${levtype}_${type}_${dateb}_${mem}_F.nc2 > \
            ${ddate4}/${var}_${levtype}_${type}_${dateb}_${mem}_F.txt
fi

done
done

echo "#########################################################"
echo " Done: Forecast,  output txt in: " ${ddate4}
echo " Units:      K; K; W*m-2*s sau J*m-2; [m] in " ${ddate4}
echo " To convert  J*m-2 to W*m-2 : divide by the number of seconds"
echo " To convert  K to C substract 273.15 "
################MUTARE DATE TXT PENTRU INPUT DSSAT #########################
## cleaning after post-proc .... ####################
#\rm -f ${dbase1}/*grib
#\rm -f ${ddate1}/*grib
################################################################################
#####################
#  2. Reanalysis for previous months: Get, Process, Merge
#####################
###############################################################################

echo " start Reanalysis"

if [ ${mmsval} -gt 1 ] ; then

cd ${dscrea}

\rm -f scr_Reana_p2 namdat_sh ${dscrea}/log*
cp ${dsc}/namdat_sh ${dscrea}/namdat_sh

cat << eof4 > scr_Reana_p2_FIN_base

# !/bin/sh
# datbase="20170601"
### se aduc renalaize din luna anterioara acesteia !
#
#box=26.45,26.55,44.45,44.55
#loc=Fundulea
#lcorunitsf=.true.
#lcorunitso=.true.
#lgetf=.false.
#lgeto=.true.

############################
############################

lcorunits_obs=${lcorunitso}
dateb=${datbase}

# for now, we assume the normal for ERA5: units need corrections
lcorunits_obs=.true.
#####################################
dateb6=`expr ${dateb} | cut -c1-6 `
dateb4=`expr ${dateb} | cut -c1-4 `
date_reana=$(date -d "$dateb -1 month" +%Y-%m-%d)
echo "date_reana=" ${date_reana}

python='/home/mihaela/anaconda3/bin/python'
cdo='/home/mihaela/utils/opt/cdo-install/cdo-1.9.3/src/cdo'
##################################################
yys=` expr ${dateb} | cut -c1-4 `
mms=` expr ${dateb} | cut -c5-6 `
mmsval=$(expr ${mms} + 0)
mmlast=$(expr ${mmsval} - 1)
mmlastm1=$(expr ${mmsval} - 2)
mmchar=$((10#$mms))

echo "mms=" ${mms} "mmsval=" ${mmsval} "mmlast=" ${mmlast} "mmlastm1=" ${mmlastm1} "mmchar=" ${mmchar}
#
if [ ${mmlast} -le 0 ] ; then
echo "no reanalysis needed for start before February !"
exit
else
cmmlast=`expr ${mmlast} + 100 | cut -c2-3 `
cmmlastchar=$((10#$cmmlast))
echo "cmmlast=" ${cmmlast}  "cmmlastchar=" ${cmmlastchar}
if [ ${mmlastm1} -le 0 ] ; then
echo "no last 2 months data needed for start before March !"
else
cmmlastm1=`expr ${mmlastm1} + 100 | cut -c2-3 `
cmmlastm1char=$((10#$cmmlastm1))
echo "cmmlastm1=" ${cmmlastm1} "cmmlastm1char=" $cmmlastm1char
fi
fi


grib_filter="/home/oper/utils/local/bin/grib_filter"
dd=/home/oper3/OPER/C3S/Prel_CRON/Module2_Adaptation/DSSAT_forecast
dsc=${dd}/Scripts_DSSAT_oper/Forecast/Seas5
dscrun=${dd}/Scripts_DSSAT_oper/RUN
dscrea=${dd}/Scripts_DSSAT_oper/Reana
dauxr=${dscrea}/Auxil_Reana
dauxrun=${dscrun}/Auxil_RUN
###############################################

doutr1="${dd}/Data/GRIB_Forecast+Reana/Reana/ERA5/${yys}/${loc}/Reana_${cmmlast}"
mkdir -p ${doutr1}
dout=${dd}/Data/GRIB_Forecast+Reana/Reana/ERA5/${yys}/${loc}/Merged_${yys}
dout_parts=${dd}/Data/GRIB_Forecast+Reana/Reana/ERA5/${yys}/${loc}/Merged_${yys}_Parts
mkdir -p ${dout} ${dout_parts}

#\rm -rf ${dscrea}/tmp_Prel_*
dbaser1=${dscrea}/tmp_Prel_${yys}_${cmmlast}
mkdir -p ${dbaser1}
ddater2=${dbaser1}/NC
mkdir -p ${ddater2}

ddater3="${doutr1}/${loc}/NC"
ddater4="${doutr1}/${loc}/TXT"
mkdir -p ${ddater3} ${ddater4} 


######################################################
#####################################################
#  0. find no of days in ini month: ndxm1, ndxall2mmlast ########################
#####################################################
#####################################################
cd ${dscrea}
## prepare namelist for RUN ##########
### Moved in the Main run, the Prel of input Seas5 forecast part
#\rm -f namdat_obs
#cat << EOF > namdat_obs
#lcorunitso=${lcorunits_obs}
#EOF

##########################################

ndxall2mmlast=0
ndxm1=0
ndxm2=0

datemthm2=${yys}${cmmlast}01
ndxall2m2=$(date -d "$datemthm2" +%j)
ndxallmm0=$(date -d "$dateb" +%j)
ndxall2mmlast=`expr ${ndxall2m2} - 1 `
ndxallmm0fin=`expr ${ndxallmm0} - 1 `

echo "Pana la data data anterioara acestei luni de Reanalize, procesasem $ndxall2mmlast zile."

days_in_month() {
    year=${yys}
    month=${cmmlast}
    date -d "$year-$month-01 + 1 month - 1 day" "+%d"
}
ndxm1=$(days_in_month)
echo "cmmlast=" ${cmmlast}  "ndxm1=" ${ndxm1}

if [ ${mmlast} -ge 2 ] ; then
days_in_month() {
    year=${yys}
    month=${cmmlastm1}
    date -d "$year-$month-01 + 1 month - 1 day" "+%d"
}
ndxm2=$(days_in_month)
echo "cmmlastm1=" ${cmmlastm1}  "ndxm2=" ${ndxm2}
fi

################################################################################
#####################
#  1. Reanalysis for previous months: Get, Process, Merge
#####################
###############################################################################
cd ${dscrea}

\rm -f ${dscrea}/namdat_py_lastm
cat << EOF > ${dscrea}/namdat_py_lastm
year = ${yys}
month = ${cmmlastchar}
EOF

if [ "${lgeto}" = ".true." ] ; then
#\rm -f ${dbaser1}/*grib
cat ${dscrea}/namdat_py_lastm ${dauxr}/ss_Reana_alldata_month_Base.py > \
          ${dbaser1}/scr_Reana_alldata_month.py

cd ${dbaser1}

echo " ############### in DIR=" ${dbaser1}
$python scr_Reana_alldata_month.py 1>o1 2>o2 &
wait
fi

cd ${dbaser1}
\rm -f list
ls out*${yys}${cmmlast}*grib > list
$cdo mergetime $(cat list) out_Reana_all_${yys}${cmmlast}.grib
$cdo -f nc copy out_Reana_all_${yys}${cmmlast}.grib ${ddater2}/out_Reana_all_${yys}${cmmlast}.nc
# need to have netcdf to have correct daymin, ..etc..
\rm -f out_Reana_all_${yys}${cmmlast}.grib


cd ${ddater2}
$cdo splitvar out_Reana_all_${yys}${cmmlast}.nc vv_

## for now:   lcorunits=.true. => make units corrections here

$cdo settime,12:00:00 -daymax  vv_var167.nc vv_var167_maxK.nc
$cdo subc,273.15 vv_var167_maxK.nc vv_var167_max.nc
$cdo settime,12:00:00 -daymin  vv_var167.nc vv_var167_minK.nc
$cdo subc,273.15 vv_var167_minK.nc vv_var167_min.nc
\rm -f vv_var167*K.nc


$cdo selhour,6,12,18,0 vv_var169.nc vv_var169.nc_sel
$cdo shifttime,-1h vv_var169.nc_sel vv_var169.nc_sel2
$cdo daysum vv_var169.nc_sel2 vv_var169.nc_sum
$cdo settime,12:00:00 -divc,1.e+6  vv_var169.nc_sum vv_var169_sum.nc
\rm -f vv_var169.nc_sel*

$cdo selhour,6,12,18,0 vv_var228.nc vv_var228.nc_sel
$cdo shifttime,-1h vv_var228.nc_sel vv_var228.nc_sel2
$cdo daysum vv_var228.nc_sel2 vv_var228.nc_sum1
$cdo settime,12:00:00 -mulc,1000. vv_var228.nc_sum1 vv_var228_sum.nc
\rm -f vv_var169.nc_sel* vv_var228.nc_sum1

echo " days in this reanalysis month (mmlast)=mms-1  :" ${ndxm1}

$cdo splitsel,$ndxm1     vv_var167_max.nc    ww167x_
mv ww167x_000000.nc  vv_var167_max_nday.nc
$cdo splitsel,$ndxm1     vv_var167_min.nc  ww167n_
mv ww167n_000000.nc  vv_var167_min_nday.nc
$cdo splitsel,$ndxm1     vv_var169_sum.nc  ww169_
mv ww169_000000.nc   vv_var169_sum_nday.nc
$cdo splitsel,$ndxm1     vv_var228_sum.nc  ww228_
mv ww228_000000.nc   vv_var228_sum_nday.nc
\rm -f ww*

$cdo sellonlatbox,${box} \
   ${ddater2}/vv_var167_max_nday.nc ${ddater3}/var167_max_${yys}${cmmlast}.nc_F
$cdo sellonlatbox,${box} \
   ${ddater2}/vv_var167_min_nday.nc ${ddater3}/var167_min_${yys}${cmmlast}.nc_F
$cdo sellonlatbox,${box} \
   ${ddater2}/vv_var169_sum_nday.nc ${ddater3}/var169_sum_${yys}${cmmlast}.nc_F
$cdo sellonlatbox,${box} \
   ${ddater2}/vv_var228_sum_nday.nc ${ddater3}/var228_sum_${yys}${cmmlast}.nc_F

ls -l ${ddater3}

$cdo output ${ddater3}/var167_max_${yys}${cmmlast}.nc_F > ${ddater4}/tmax_F_reana_${yys}${cmmlast}.txt
$cdo output ${ddater3}/var167_min_${yys}${cmmlast}.nc_F > ${ddater4}/tmin_F_reana_${yys}${cmmlast}.txt
$cdo output ${ddater3}/var169_sum_${yys}${cmmlast}.nc_F > ${ddater4}/ssrd_F_reana_${yys}${cmmlast}.txt
$cdo output ${ddater3}/var228_sum_${yys}${cmmlast}.nc_F > ${ddater4}/pr_F_reana_${yys}${cmmlast}.txt
#
#

echo " nrdays in the previously  merged reanalysis, before this mmlast, should be : " ${ndxall2mmlast}


################
\rm -f ${dout}/*txt
echo " add year data including month: " ${mmlast}

for varo in tmax tmin ssrd pr ; do
im=1
while [ ${im} -le ${mmlast} ] ; do
 cim=`expr ${im} + 100 | cut -c2-3 `
 doutrc=${dd}/Data/GRIB_Forecast+Reana/Reana/ERA5/${yys}/${loc}/Reana_${cim}/${loc}/TXT
 echo " data DIR=" ${doutrc}
 if [ ${im} -eq 1 ] ; then
   echo " creating January Reanalysis:"
   cp ${doutrc}/${varo}_F_reana_${yys}${cim}.txt  ${dout}/${varo}_obs_${yys}.txt
   echo " copiat Luna 1, IANUARIE"
   ls -l ${dout}/${varo}_obs_${yys}.txt
 else
   cat ${dout}/${varo}_obs_${yys}.txt \
       ${doutrc}/${varo}_F_reana_${yys}${cim}.txt > \
          ${dout}/${varo}
   \rm -f ${dout}/${varo}_obs_${yys}.txt
   mv ${dout}/${varo} ${dout}/${varo}_obs_${yys}.txt
 fi
im=`expr ${im} + 1 `
done

#ntimx=$(wc -l < ${dout}/${varo}_obs_${yys}.txt)
ntimx=$(wc -l < ${dout}/${varo}_obs_${yys}.txt)
echo "for var=" ${varo} "found dates number ntimx=" ${ntimx}
ntot=`expr ${ndxall2mmlast} + ${ndxm1} `
ntot1=${ndxallmm0fin}
echo " ntimx=" ${ntimx} "ntot=" ${ntot} "notot1=" ${ntot1}

if [ ${ntimx} -ne ${ntot} ] ||  [ ${ntimx} -ne ${ntot1} ] ; then
 echo " error in Obs/ Reana data file: not enough !"
exit
fi
#
echo "done, variable:" ${varo}
done
###############################################################
###############################################################

eof4

cat ${dscrea}/namdat_sh scr_Reana_p2_FIN_base > \
             ${dscrea}/scr_Reana_p2
chmod u+x scr_Reana_p2
./scr_Reana_p2 1>${dscrea}/log1_${dateb} 2>${dscrea}/log2_${dateb} &

wait
echo " Done: Reanalysis,  output txt in: " /home/oper3/OPER/C3S/Prel_CRON/Module2_Adaptation/DSSAT_forecast/Data/GRIB_Forecast+Reana/Reana/ERA5/${ys}/${loc}/Merged_${ys}
else
echo " Renalysis not needed for January base, empty files are needed for read*F90"
touch ${dout1rea}/pr_obs_${ys}.txt 
touch ${dout1rea}/ssrd_obs_${ys}.txt 
touch ${dout1rea}/tmax_obs_${ys}.txt 
touch ${dout1rea}/tmin_obs_${ys}.txt 
fi
echo "#########################################################"
#echo " Done: Reanalysis,  output txt in: " /home/oper3/OPER/C3S/Prel_CRON/Module2_Adaptation/DSSAT_forecast/Data/GRIB_Forecast+Reana/Reana/ERA5/${ys}/${loc}/Merged_${ys}
echo "#########################################################"
#  3.  RUN    ##############################################
###############################################################
# end if irun .lt. 3 
fi

if [ ${irun} -lt 4 ] ; then
echo " go for RUN in:  " ${dscrun}

cd ${dscrun}

# prepare namelist for RUN ##########
### create namddat_run needed for the dssat run

\rm -f ${dscrun}/scr_RUN ${dscrun}/namdat_run ${dscrun}/log*

cat << eof5 > scr_RUN_base

#datbase="20200301"
#box=26.45,26.55,44.45,44.55
#loc=Fundulea
#lcorunitsf=.true.
#lcorunitso=.true.
#lgetf=.true.
#lgeto=.true.

#
######################
######################
datebase=`expr ${datbase} | cut -c1-8 `
datebase6=`expr ${datebase} | cut -c1-6 `
datend=$(date -d "${datebase} + 6 months" +%Y%m%d)

echo "datebase=" ${datebase} "datebase6=" ${datebase6} "datend=" ${datend}

#
dwk=mydwk
dnamel=mydnamel
\rm vardat 
head -n 2 ${dnamel}/namdat_sh | tail -n 1 >  ${dwk}/vardat
datebasem=`expr $(cat ${dwk}/vardat) | cut -c10-17 `

echo "datbasem=" "${datebasem}"

if [ "${datebase}" != "${datebasem}" ] ; then
echo "####################################################"
echo " WARNING !! a mismatch in dates , check if Meteo data exist for base ${datebase} from previous Runs"
echo "####################################################"
#exit
fi
echo "datebase=" ${datebase}
echo "datend=" ${datend}

#
######## for oper: ######
yys=`expr ${datebase} | cut -c1-4 `
mm1=`expr ${datebase} | cut -c5-6 `
yy2=`expr ${datend} | cut -c1-4 `
mm2=`expr ${datend} | cut -c5-6 `
#
yearpl=${yys}
if [ ${mm1} -gt 9 ] ; then
# no sense see planting 04 this year, as harvest was  collected in september"
yy2=`expr ${yys} + 1 `
fi
#
yearpl=${yy2}
dateplant=${yearpl}0401
\rm -f 
#
#########################################################
y0dss=`expr ${dateplant} | cut -c1-4 `
dat0dss=${y0dss}0101
echo "DSSAT model starts: " ${dat0dss}
#
yys=`expr ${datebase} | cut -c1-4 `
#
############################################################
d0=myd0
dscr=${d0}/Scripts_DSSAT_oper
daux=${dwk}/Auxil_RUN
dauxpl=${dscr}/PLOT/Scripts/Auxil
dplot=${dscr}/PLOT/Scripts
\rm -f ${dplot}/nam_plant
cat << EOF > ${dplot}/nam_plant
dateplant=${dateplant}
EOF

datop=${d0}/Data/GRIB_Forecast+Reana/Forecast/Seas5/${yys}/Baza_${datebase6}/Grib_filter/NC/${loc}/TXT
dobs=${d0}/Data/GRIB_Forecast+Reana/Reana/ERA5/${yys}/Fundulea/Merged_${yys}
dclim=${d0}/Data/Clim
drun=${d0}/RUN/dssat-csm-os-4.8.0.15/Data
##############################################################

dt=${drun}/tmp_oper/Base_${datebase}
mkdir -p ${drun} ${dt}
mkdir -p ${drun} ${dt}
#rm -rf ${dt}
#
#dprint=${dscr}/PLOT/Rez_User_Plots/PRINT_${varpl}_base${datbase}
mkdir -p ${dplot}
#################### run  set-up
### meteo:
mems=0
#meme=2
meme=50

#########
nint=3
nrint=6
### dssat:
cexper='FCST'
model=SEAS5
cintday=5
ferdap=14
fermass=60
irdayn=0
irmass=0
period=1
# genotype:
ch1=1
ch2=1
ch3=1
ch4=1
ch5=1
ch6=1
plday1ref='091'
plday2ref='101'
plday3ref='120'
plday4ref='135'
# station: (Fundulea)
lon0=26.0
lat0=44.4
elev0=90.

iter='${ch0} ${ch1} ${ch2} ${ch3} ${ch4} ${ch5} ${ch6}'
kode=${ch0}${ch1}${ch2}${ch3}${ch4}${ch5}${ch6}

din=${datop}
#########################################################################
#########################################################################
#########################################################################

mmbase=`expr ${datebase} | cut -c5-6 `

inimeteo=$(date +'%s' -d ${datebase})
inidssat=$(date +'%s' -d ${dat0dss})
new=$(date +'%s' -d ${dateplant})
#echo $(( ($new - $inimeteo) / 86400 )) 
#ndypl=$(echo $(( ($new - $inimeteo) / 86400)) | bc )
ndypl=$(echo $(( ($new - ${inidssat} ) / 86400)) | bc )

mopl=`expr ${dateplant} | cut -c5-6 `
dypl=`expr ${dateplant} | cut -c7-8 `

echo "CORR_ndypl=" $ndypl
echo "mopl=" $mopl
echo "dypl=" $dypl


nn=1
ndyplact=${ndypl}
#\rm -f l_run_ndyplact
################################################################
###################### 0.1 LOOP planting dates ######

while [ ${nn} -le ${nrint} ] ; do 

cd ${dt}

echo "ndyplact=" $ndyplact "nn=" ${nn}

if [ ${nn} -eq 1 ] ; then
cat <<EOF > l_run_ndyplact
${ndyplact}
EOF
else
\rm l_tmp
echo "ndyplact_to_cat=" ${ndyplact}
cat <<EOF > l_tmp
${ndyplact}
EOF
#
cat l_run_ndyplact l_tmp > l_run_new
mv  l_run_new l_run_ndyplact
fi
##############

echo " treated DAY number=" $ndyplact

yy=`expr ${dateplant} | cut -c1-4 `
yy2=`expr ${dateplant} | cut -c3-4 `
mmpl=`expr ${dateplant} | cut -c5-6 `

echo "yys=" ${yys} "yy2_2digits=" ${yy2} "yy_4digits=" ${yy} "mmpl=" ${mmpl}

#
#############
dout=${drun}/Output_DSSAT_forec_NEW/${yy}/Base_${datebase}/plday_${ndyplact}
dsave=${drun}/Saves_initial_cond_WTH/Base_${datebase}
mkdir -p ${dsave} ${dout} ${dout}/FIFU_saves
#\rm -f ${dout}/*

echo "dout=" ${dout}
#############
cybase=${yys}
cyplant=${yy}
cmbase=${mmbase}
cmmpl=${mmpl}
cdbase='01'
freq=1 # number of forecast slices per day

faxtempl=${daux}/FIFU9901.MZX_templ_v2
fax=FIFU9901.MZX

######################### 0.2 LOOP Members ######
mem=${mems}
while [ ${mem} -le ${meme} ] ; do
echo "##########################"
echo "current_mem=" ${mem}
dt2=${dt}/mem_${mem}
\rm -rf ${dt2}
mkdir -p ${dt2}

cd ${dt2}
echo " in DIR: current_mem=" ${mem}
\rm  *.txt
ln -fs ${datop}/mn2t24_sfc_fc_${datebase}_mem${mem}_F.txt  tn_forec.txt
ln -fs ${datop}/mx2t24_sfc_fc_${datebase}_mem${mem}_F.txt  tx_forec.txt
ln -fs ${datop}/ssrd_sfc_fc_${datebase}_mem${mem}_F.txt    swrad_forec.txt
ln -fs ${datop}/tp_sfc_fc_${datebase}_mem${mem}_F.txt      precip_forec.txt
#
ln -fs ${dobs}/pr_obs_${yys}.txt       precip_obs.txt
ln -fs ${dobs}/ssrd_obs_${yys}.txt     swrad_obs.txt
ln -fs ${dobs}/tmin_obs_${yys}.txt     tn_obs.txt
ln -fs ${dobs}/tmax_obs_${yys}.txt     tx_obs.txt
#
ln -fs ${dclim}/pp.nc_ym_Rocada.txt  precip_climROC.txt
ln -fs ${dclim}/MARS_30y_pp_ym.txt   precip_clim.txt
ln -fs ${dclim}/MARS_30y_sr_ym.txt   swrad_clim.txt
ln -fs ${dclim}/MARS_30y_tn_ym.txt   tn_clim.txt
ln -fs ${dclim}/MARS_30y_tx_ym.txt   tx_clim.txt
#

#### DESCRIERE DATE: OBS/ CLIM/ FOREC
#
# datele de OBS trebuie sa inceapa mereu cu 1 Januarie, si merg cat ai date (dar sa fie toate inainte de prognoza )
# datele de FOREC trebuie sa inceapa cu data de 1 a lunii $cmbase
# datele de CLLIM sunt FIXE 
 
#####################
### 1. Make WTH file ##################
echo "sunt in dir=" ${PWD}

\rm read_for_forecast.F90
# DSSAT does not accept SWRad <1 !; does not accept tmax=tmin !
cp  interface_crop_seasonal-forecast_DSSAT.F90  read_for_forecast.F90

\rm -f namforec.txt
cat << EOF > namforec.txt
\$namexp
clexper='${cexper}',
loclon=${lon0},
loclat=${lat0},
locelev=${elev0},
mem=${mem},
ys=${cybase},
ms=${cmbase},
yp=${cyplant},
mp=${cmmpl},
freq=${freq},
loc='${loc}',
lcorunitsf=${lcorunitsf},
lcorunitso=${lcorunitso}
/
EOF

\rm ${dt2}/FCST.WTH 
\rm ${drun}/FCST${yy2}01.WTH
gfortran read_for_forecast.F90
./a.out
### salvare
cp FCST.WTH ${dsave}/FCST.WTH_base${mmbase}_mem${mem}
mv FCST.WTH ${drun}/FCST${yy2}01.WTH
echo "WTH file done in: " ${drun}

############################
##### 2. Make FIFU file in ${drun} #######################
############################
cd ${dt2}

\rm ${dt2}/fin_tmp*
\rm ${drun}/${fax}

plday1=${ndyplact}

plday2=`expr ${plday1} + ${cintday} `
plday3=`expr ${plday2} + ${cintday} `
plday4=`expr ${plday3} + ${cintday} `

plday1=`expr ${plday1} + 1000 | cut -c2-4 `
plday2=`expr ${plday2} + 1000 | cut -c2-4 `
plday3=`expr ${plday3} + 1000 | cut -c2-4 `
plday4=`expr ${plday4} + 1000 | cut -c2-4 `
echo "plday1=" ${plday1}
echo "plday2=" ${plday2}
echo "plday3=" ${plday3}
echo "plday4=" ${plday4}

############################
ferday=${ferdap}
fermass2=`expr ${fermass} \* 2 `
irday=` expr ${irdayn} + 1000 | cut -c2-4 `

##### a)  harvest date
/usr/bin/sed -e "1,\$s/1 95304/1 ${yy2}304/g" < ${faxtempl} > fin_tmp1
##### b)  irrigation date
# atentie la spatii !!!!
if [ ${irmass} -lt 10 ] ; then
/usr/bin/sed -e "1,\$s/1 95115   -99   -99/1 ${yy2}${irday}   -99     ${irmass}/g" <  fin_tmp1 > fin_tmp2
elif [ ${irmass} -lt 100 ] ; then
/usr/bin/sed -e "1,\$s/1 95115   -99   -99/1 ${yy2}${irday}   -99    ${irmass}/g" <  fin_tmp1 > fin_tmp2
else
/usr/bin/sed -e "1,\$s/1 95115   -99   -99/1 ${yy2}${irday}   -99   ${irmass}/g" <  fin_tmp1 > fin_tmp2
fi
##### c) planting date date
/usr/bin/sed -e "1,\$s/1 95${plday1ref}/1 ${yy2}${plday1}/g" <  fin_tmp2 > fin_tmp3
/usr/bin/sed -e "1,\$s/2 95${plday2ref}/2 ${yy2}${plday2}/g" <  fin_tmp3 > fin_tmp4
/usr/bin/sed -e "1,\$s/3 95${plday3ref}/3 ${yy2}${plday3}/g" <  fin_tmp4 > fin_tmp5
/usr/bin/sed -e "1,\$s/4 95${plday4ref}/4 ${yy2}${plday4}/g" <  fin_tmp5 > fin_tmp6
##### d) harvest last
/usr/bin/sed -e "1,\$s/95334/${yy2}334/g" <  fin_tmp6 > fin_tmp7
##### e) Wather file forecast
/usr/bin/sed -e "1,\$s/MARS/${cexper}/g" <  fin_tmp7 > fin_tmp8
## atentie la spatii !!!!
##### f) fertilisation mass
if [ ${fermass} -lt 10 ] ; then
#/usr/bin/sed -e "1,\$s/\ 23/\  ${fermass}/g" <  fin_tmp8 > fin_tmp9
/usr/bin/sed -e "1,\$s/FE005 AP003     5    23/FE005 AP003     5     ${fermass}/g" <  fin_tmp8 > fin_tmp9
elif [ ${fermass} -lt 100 ] ; then
/usr/bin/sed -e "1,\$s/FE005 AP003     5    23/FE005 AP003     5    ${fermass}/g" <  fin_tmp8 > fin_tmp9
else
/usr/bin/sed -e "1,\$s/FE005 AP003     5    23/FE005 AP003     5   ${fermass}/g" <  fin_tmp8 > fin_tmp9
fi
# atentie la spatii !!!!
if [ ${fermass2} -lt 10 ] ; then
/usr/bin/sed -e "1,\$s/FE005 AP003     5    46/FE005 AP003     5     ${fermass2}/g" <  fin_tmp9 > fin_tmp10
elif [ ${fermass2} -lt 100 ] ; then
/usr/bin/sed -e "1,\$s/FE005 AP003     5    46/FE005 AP003     5    ${fermass2}/g" <  fin_tmp9 > fin_tmp10
else
/usr/bin/sed -e "1,\$s/FE005 AP003     5    46/FE005 AP003     5   ${fermass2}/g" <  fin_tmp9 > fin_tmp10
fi

##### g) fertilisation day
if [ ${ferday} -lt 10 ] ; then
/usr/bin/sed -e "1,\$s/\ 14\ FE/\  ${ferday}\ FE/g" <  fin_tmp10 > fin_tmp11
elif [ ${ferday} -lt 100 ] ; then
/usr/bin/sed -e "1,\$s/\ 14\ FE/\ ${ferday}\ FE/g" <  fin_tmp10 > fin_tmp11
else
/usr/bin/sed -e "1,\$s/\ 14\ FE/${ferday}\ FE/g" <  fin_tmp10 > fin_tmp11
fi
##### start   date date
/usr/bin/sed -e "1,\$s/GE              1     1     S 95001/GE              ${period}     1     S ${yy2}001/g" <  fin_tmp11 > \
            ${drun}/${fax}

echo "FAX file done in:" ${drun}/${fax}
cp ${drun}/${fax} ${dsave}/${fax}_base${mmbase}_mem${mem}

############### 3. run DSSAT with ${cmd} command line
cmd='A '${fax}' NA'
cd ${drun}

#./dscm048_fin_teste_14apr2022 ${cmd}  1>o1_${datebase}_mem${mem} 2>o2
./dscm048_fin_teste_14apr2022 A FIFU9901.MZX NA   1>${dout}/o1_${datebase}_mem${mem}_tmp1 2>o2

############### 4. post-process Dssat results per planting days, per member
\rm ${dout}/inforun
cat << EOF > ${dout}/inforun
'  '
year; ${yy} scen: ${cexper} mem: ${mem} iter: ${ch0} ${ch1} ${ch2} ${ch3} ${ch4} ${ch5} ${ch6}
EOF
sed -e '/^$/d' < ${dout}/o1_${datebase}_mem${mem}_tmp1 > ${dout}/o1_${datebase}_mem${mem}_tmp2
cat    ${dout}/inforun    ${dout}/o1_${datebase}_mem${mem}_tmp2 > \
         ${dout}/o1_${datebase}_pl${ndyplact}_ci${cintday}_mem${mem}
#\rm ${dout}/o1_${datebase}_mem${mem}_tmp*
echo " Output in: " ${dout}/o1_${datebase}_pl${ndyplact}_ci${cintday}_mem${mem}

#####${crun}
echo "Done, member:" ${mem}
mem=`expr ${mem} + 1 ` 
echo "#####################################"
done 
######################################
echo "DONE, ndyplact=" ${ndyplact}
\rm -rf ${dout}/FIFU_saves/FIFU*
cp ${drun}/${fax} ${dout}/FIFU_saves/FIFU9901.MZX_base${datebase}_pl${ndyplact}

nn=`expr ${nn} + 1 ` 
ndyplact=`expr ${ndyplact} + ${nint} ` 
done
wait
echo "DONE all members, all planting dates, output in:" ${dout}

######################################
############  PLOT  ##########################
#cd ${dplot}

#\rm -f nam_f_base
#cat << EOF > nam_f_base
#  #!/bin/sh
#cdatbase=${datebase}
#cdatplant=${dateplant}
#varpl=${varpl}
#EOF

#\rm -f scr_Prep_plot_p1
#cat nam_f_base ${dauxpl}/scr_Prep_plot_p1_base > scr_Prep_plot_p1
#chmod u+x scr_Prep_plot_p1
#./scr_Prep_plot_p1

#echo "output Plots in: " ${dprint}
######################################
######################################

eof5

cp ${dsc}/namdat_sh ${dscrun}/namdat_run
cat ${dscrun}/namdat_run scr_RUN_base > ${dscrun}/scr_RUN
chmod u+x ${dscrun}/scr_RUN
./scr_RUN 1>${dscrun}/log1_${dateb} 2>${dscrun}/log2_${dateb} 
wait
echo " Done: RUN,  output in: " ${dd}/RUN/dssat-csm-os-4.8.0.15/Data/Output_DSSAT_forec_NEW/${ys}/Base_${dateb}/plday_
echo " Done: Plot,  output in: " ${ds}/Scripts_DSSAT_oper/PLOT/Rez_User_Plots/PRINT_all_base${dateb}
echo "#########################################################"
###############################################################
#  4.  Further (post-procs)  ##############################################

fi


cd ${dplot}
echo " go for plot in:  " ${dplot}

\rm -f nam_f_base
cat << EOF > nam_f_base
#!/bin/sh
datebase=${dateb}
varpl="${varpl}"
box='26.45,26.55,44.45,44.55'   # Fundulea: 44.5; 26.5
loc=Fundulea
EOF
#
# nam_plant:  dateplant=20260401
#
\rm -f scr_Prep_plot_p1
cat nam_f_base nam_plant ${dauxpl}/scr_Prep_plot_p1_base > scr_Prep_plot_p1
chmod u+x scr_Prep_plot_p1
./scr_Prep_plot_p1

#echo "output Plots in: " ${dprint}

###############################################################
