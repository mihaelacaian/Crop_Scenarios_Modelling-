#!/bin/sh
din=mydin
dinsave=mydinsave

d0=myd0
dwk=${d0}/work
dwkt=${d0}/work/tmp3
mkdir -p ${dwk} ${dwkt}
daux=mydaux
duser=${d0}/FORMS_USER_REQ

cd ${dwkt}
\rm list_fauser
ls ${din}/*txt > list_fauser
for fain in $(cat list_fauser) ; do
echo "#################################"
echo "Treating querry:" ${fain}
echo "#################################"

cat << eof1 > header.txt
#!/bin/sh
#

##################
if [ ${ferdap} -eq 0 ] ; then
fermass=0
fi
if [ ${irdayn} -eq 0 ] ; then
irmass=0
fi
## Info from Users:
#
#address=mihaela
#email=mihaela.caian@gmail.com
#today=20221029
#judet=Calarasi
#scen=rcp45
#tsl=2031-2040
#pldat=0104
#ferdap=49
#fermass=69
#irdayn=0
#irmass=0
#Flo=1
#Mat=1
#IDT=1
#out_txt=1
#comments=''      
#
eof1
#
#
cat << eof2 > scr_USER_fin_base
#
#
################### 0. Set-up ################################################
##############################################################################
############ sol: #####################
soltype=1xN_CORR_soil_NOferti+ini_water_MARS_OPER
csoltype=N1_noF+iniw
######### genotype:class parameters ###
clsensit='Genotype'
clexp=MZCER
vmod=048
sufix=CUL
cltest=PG
# initial Parameter Genotype change: #####
npar=6
nparm1=`expr ${npar} - 1 `
ch0=0
ch1=0
ch2=0
ch3=0
ch4=0
ch5=0

kode=576133
# 576133
lstep=' 5   7    6   1  3  3'
lmin='100  10  500 798  6 30'
lmax='500 260 1500 798 12 70'
lfac='  1   100    1   1  1  1'

if [ ${IDT} -ne 1 ] ; then
kode=111111
# 111111
lstep=' 1   1    1   1  1  1'
lmin='200  200  700 798  9 40'
lmax='200  200  700 798  9 40'
lfac='  1   100    1   1  1  1'
fi

nrintmax=20
nrparmax=20
###################

scen=${scen}
part=1
period=1
echo "scen=" ${scen}
###############

d000=myd000
d00=ntd00
d0=${d00}/dssat-csm-os-4.8.0.15/Data
daux=${d000}/../RUN/AUXIL

cd ${d0}

datain0scen=mydatain0scen

#################### TODO: soil FILE for the region ################
#################### TODO: WTH  FILE for the region ################
ysu=`expr ${tsl} | cut -c1-4`
yeu=`expr ${tsl} | cut -c6-9`

echo "ysu=" ${ysu}
echo "yeu=" ${yeu}

faxtempl=FIFU9901.MZX_work_${soltype}
fax=FIFU9901.MZX
################ models, scenarios: #######

for model in ICHEC-EC-EARTH-SMHI-RCA4 CNRM-CERFACS-CNRM-CM5-SMHI-RCA4 MPI-M-MPI-ESM-LR-SMHI-RCA4 ; do

case ${scen} in \
 Ctrl) clscen=MARS ;clscen4=MARS; datain0=${d0}/SAVES_WTHfiles_OPER_fin/SAVES_WTH/saves_Aug2022;
        if [ ${part} -eq 1 ] ; then
         yst=`expr ${ysu} - 50 + 5 `
         yen=`expr ${yeu} - 50 + 5 `
        fi;;
 historical) clscen=HIST ;clscen4=HIST;datain0=${datain0scen}/${scen}/${model};
        if [ ${part} -eq 1 ] ; then
         yst=`expr ${ysu} - 50 + 5 `
         yen=` expr ${yeu} - 50 + 5 `
        fi;;
 rcp45) clscen=RCP45 ;clscen4=RCP4;datain0=${datain0scen}/${scen}/${model};
        if [ ${part} -eq 1 ] ; then
         yst=${ysu}
         yen=${yeu}
        else 
         yst=2070
         yen=2099
        fi ;; 
 rcp85) clscen=RCP85 ;clscen4=RCP8;datain0=${datain0scen}/${scen}/${model};
        if [ ${part} -eq 1 ] ; then
         yst=${ysu}
         yen=${yeu}
        else 
         yst=2070
         yen=2099
        fi ;; 
esac
echo "datain0=" ${datain0}

dexp00=${d0}/OUTPUT_USER_REQ/LOOP_RES_${userid}
dexp0=${dexp00}/${scen}
exp0=${dexp0}/${model}
mkdir -p ${exp0}


cd ${d0}




mkdir -p old_tmp
mv ${clscen}*.WTH old_tmp
mv ${clscen4}*.WTH old_tmp

cp ${datain0}/${clscen}*.WTH .
cp ${daux}/SOIL.SOL_orig_${judet}  SOIL.SOL
cp ${daux}/SOIL.SOL_orig_${judet}  soil.sol

####################### 1., 2.:  the 2 loops: #########################
##############################################################

####  LOOP 1. YEAR  loop ####### (make FIFU9901.MZX file) #############
ys=${yst}
ye=${yen}

echo "ys=" ${ys}
echo "ye=" ${ye}

yy=${ys}

echo "YY=" ${yy}
echo "YYE=" ${ye}


yy2t=`expr ${yy} | cut -c 3-4 `
yy2=`expr ${yy2t} + 100 | cut -c 2-3 `
echo "YEAR=" ${yy2}

fawin=${clscen}${yy}01.WTH
fawinl=${clscen4}${yy2}01.WTH
mv ${fawin} ${fawinl}
echo "fawin=" ${fawin}

dout=${exp0}/YY_${yy}
\rm -r ${dout}
mkdir -p ${dout}

\rm fin_tmp* ${fax}

pld=` expr ${pldat} | cut -c1-2 ` 
plm=` expr ${pldat} | cut -c3-4 `
pld=`expr ${pld} + 100 | cut -c2-3 `
plm=`expr ${plm} + 100 | cut -c2-3 `
echo "pld=" ${pld} "plm=" ${plm}

if [ ${plm} -eq 2 ] ; then
plday1=`expr 31 + ${pld} `
elif [ ${plm} -eq 3 ] ; then
plday1=`expr 60 + ${pld} `
elif [ ${plm} -eq 4 ] ; then
plday1=`expr 90 + ${pld} `
elif [ ${plm} -eq 5 ] ; then 
plday1=`expr 120 + ${pld} `
fi
plday2='101'
plday3='120'
plday4='135'

plday1=`expr ${plday1} + 1000 | cut -c2-4 `
plday2=`expr ${plday2} + 1000 | cut -c2-4 `
plday3=`expr ${plday3} + 1000 | cut -c2-4 `
plday4=`expr ${plday4} + 1000 | cut -c2-4 `
echo "plday1=" ${plday1} 

########
ferday=${ferdap}
fermass2=`expr ${fermass} \* 2 `
irday=` expr ${irdayn} + 1000 | cut -c2-4 `

## harvest date
/usr/bin/sed -e "1,\$s/1 95304/1 ${yy2}304/g" < ${daux}/${faxtempl} > fin_tmp1
## irrigation date
#/usr/bin/sed -e "1,\$s/1 95115/1 ${yy2}115/g" <  fin_tmp1 > fin_tmp2
#/usr/bin/sed -e "1,\$s/1 95115/1 ${yy2}${irday}/g" <  fin_tmp1 > fin_tmp2
############### atentie la spatii !!!!
if [ ${irmass} -lt 10 ] ; then
/usr/bin/sed -e "1,\$s/1 95115   -99   -99/1 ${yy2}${irday}   -99     ${irmass}/g" <  fin_tmp1 > fin_tmp2
elif [ ${irmass} -lt 100 ] ; then
/usr/bin/sed -e "1,\$s/1 95115   -99   -99/1 ${yy2}${irday}   -99    ${irmass}/g" <  fin_tmp1 > fin_tmp2
else
/usr/bin/sed -e "1,\$s/1 95115   -99   -99/1 ${yy2}${irday}   -99   ${irmass}/g" <  fin_tmp1 > fin_tmp2
fi

## planting date date
/usr/bin/sed -e "1,\$s/1 95${plday1}/1 ${yy2}${plday1}/g" <  fin_tmp2 > fin_tmp3
/usr/bin/sed -e "1,\$s/2 95${plday2}/2 ${yy2}${plday2}/g" <  fin_tmp3 > fin_tmp4
/usr/bin/sed -e "1,\$s/3 95${plday3}/3 ${yy2}${plday3}/g" <  fin_tmp4 > fin_tmp5
/usr/bin/sed -e "1,\$s/4 95${plday4}/4 ${yy2}${plday4}/g" <  fin_tmp5 > fin_tmp6
# harvest last
/usr/bin/sed -e "1,\$s/95334/${yy2}334/g" <  fin_tmp6 > fin_tmp7
# Wather file scen
/usr/bin/sed -e "1,\$s/MARS/${clscen4}/g" <  fin_tmp7 > fin_tmp8
############### atentie la spatii !!!!
if [ ${fermass} -lt 10 ] ; then
/usr/bin/sed -e "1,\$s/\ 23/\  ${fermass}/g" <  fin_tmp8 > fin_tmp9
elif [ ${fermass} -lt 100 ] ; then
/usr/bin/sed -e "1,\$s/\ 23/\ ${fermass}/g" <  fin_tmp8 > fin_tmp9
else
/usr/bin/sed -e "1,\$s/\ 23/${fermass}/g" <  fin_tmp8 > fin_tmp9
fi

############### atentie la spatii !!!!
if [ ${fermass2} -lt 10 ] ; then
/usr/bin/sed -e "1,\$s/\ 46/\  ${fermass2}/g" <  fin_tmp9 > fin_tmp10
elif [ ${fermass2} -lt 100 ] ; then
/usr/bin/sed -e "1,\$s/\ 46/\ ${fermass2}/g" <  fin_tmp9 > fin_tmp10
else
/usr/bin/sed -e "1,\$s/\ 46/${fermass2}/g" <  fin_tmp9 > fin_tmp10
fi

if [ ${ferday} -lt 10 ] ; then
/usr/bin/sed -e "1,\$s/\ 14\ FE/\  ${ferday}\ FE/g" <  fin_tmp10 > fin_tmp11
elif [ ${ferday} -lt 100 ] ; then
/usr/bin/sed -e "1,\$s/\ 14\ FE/\ ${ferday}\ FE/g" <  fin_tmp10 > fin_tmp11
else
/usr/bin/sed -e "1,\$s/\ 14\ FE/${ferday}\ FE/g" <  fin_tmp10 > fin_tmp11
fi
## start   date date
/usr/bin/sed -e "1,\$s/GE              1     1     S 95001/GE              ${period}     1     S ${yy2}001/g" <  fin_tmp11 > ${fax}

echo done, planting day loop, pday=' ${plday}

echo "FAX file in" ${d0}/${fax}
##### +++ #################### add options: irmass; ferday; fermass; 
#fawinl=${clscen4}${yy2}01.WTH
###############################

####  LOOP 2. GENOTYPE loop (make MZCER.CUL file) #######

for cultype in  'PIO 3475*       '  ; do

echo "cultype=" ${cultype}

case ${cultype} in \
 'PIO 3541        ') ccul='I0029_PIO_3541';culvar='IB0029';;
 'PIO 3707        ') ccul='I0030_PIO_3707';culvar='IB0030';;
 'PIO 3475*       ') ccul='I0031_PIOs_3475';culvar='IB0031';;
 'PIO 3382*       ') ccul='I0032_PIOs_3382';culvar='IB0032';;
 'PIO 3780        ') ccul='I0033_PIO_3780';culvar='IB0033';;
 'PIO 3780*       ') ccul='I0034_PIOs_3780';culvar='IB0034';;
 'PIO 3165        ') ccul='I0066_PIO_3324';culvar='IB0066';;
 'PIO 3324        ') ccul='I0067_PIO_3324';culvar='IB0067';;
 'PIO 3475        ') ccul='I0068_PIO_3475';culvar='IB0068';;
 'PIO 3475 orig   ') ccul='I0068_PIOo_3475';culvar='IB0068';;
 'PIO 3790        ') ccul='I0069_PIO_3790';culvar='IB0069';;
esac

doutc=${dout}/${ccul}
mkdir -p ${doutc}

#echo "done dir=" ${doutc}

########## compute changes in P, G #############################
ipar=0
for nstep in ${lstep} ;  do
nstepm1=`expr ${nstep} - 1 `
eval nst[$ipar]=${nstep}
eval nrint[$ipar]=${nstepm1}
ipar=`expr ${ipar} + 1 `
done

ipar=0
for fac in ${lfac}  ;  do
eval ifac[$ipar]=${fac}
ipar=`expr ${ipar} + 1`
done

ipar=0
for valmin in ${lmin}  ;  do
eval vmin[$ipar]=${valmin}
ipar=`expr ${ipar} + 1`
done
n='*'
echo "vmin=" $( eval echo \${vmin[$n]})

ipar=0
for valmax in ${lmax} ;  do
eval vmax[$ipar]=${valmax}
ipar=`expr ${ipar} + 1`
done

ipar=0
while [ ${ipar} -le ${nparm1} ] ; do
echo "MAX, MIN="  ${vmax[$ipar]} ${vmin[$ipar]}
delt=`expr ${vmax[$ipar]} - ${vmin[$ipar]} `
echo "DELT=" ${delt}

if [ ${delt} -eq 0 ] ; then
del[$ipar]=0
incr[$ipar]=1
else
eval del[$ipar]=`expr $delt \/ ${nrint[$ipar]} `
eval incr[$ipar]=`expr ${del[$ipar]}`
fi
ipar=`expr ${ipar} + 1`
done

#echo "SUMMARY: " 
#n='*'
#eval echo \${vmin[$n]}
#eval echo \${vmax[$n]}
#eval echo \${del[$n]}
#eval echo \${nst[$n]}
#eval echo \${nrint[$n]}

####  loop over changes in P, G in MZCER.CUL ###########

declare -A valmat
num_rows=${nparmax}
num_columns=${nrintmax}

ipar=0
while [ ${ipar} -le ${nparm1} ] ; do
 is=0
  while [ ${is} -le ${nrint[${ipar}]} ] ; do
   vv=`expr ${vmin[${ipar}]} + ${is} \* ${del[${ipar}]} `
   eval valmat[${ipar},${is}]=${vv}
   is=`expr ${is} + 1 `
  done
ipar=`expr ${ipar} + 1 `
done


f2=" %9s"
for ((i=0;i<=${nparm1};i++)) do
    printf "$f2"  $i
    for ((j=0;j<=${nrint[i]};j++)) do
        printf "$f2 "    ${valmat[$i,$j]}
    done
done

##############################
echo "marges P0:" ${valmat[0,0]} ${valmat[0,${nrint[0]}]}
echo "marges P1:" ${valmat[1,0]} ${valmat[1,${nrint[1]}]}
echo "marges P2:" ${valmat[2,0]} ${valmat[2,${nrint[2]}]}
echo "marges P3:" ${valmat[3,0]} ${valmat[3,${nrint[3]}]}
echo "marges P4:" ${valmat[4,0]} ${valmat[4,${nrint[4]}]}
echo "marges P5:" ${valmat[5,0]} ${valmat[5,${nrint[5]}]}
echo "INCR=" ${incr[0]} ${incr[1]} ${incr[2]} ${incr[3]} ${incr[4]} ${incr[5]}



if [ ${IDT} -eq 1 ] ; then

#### P,G loop & runs: ############################
irun=0
for  ch0 in $(seq ${valmat[0,0]} ${incr[0]} ${valmat[0,${nrint[0]}]}  ) ; do
echo "del=" ${del[0]}
for  ch1 in $(seq ${valmat[1,0]} ${incr[1]} ${valmat[1,${nrint[1]}]}  ) ; do
echo "del=" ${del[1]}
for  ch2 in $(seq ${valmat[2,0]} ${incr[2]} ${valmat[2,${nrint[2]}]}  ) ; do
echo "del=" ${del[2]}
for  ch3 in $(seq ${valmat[3,0]} ${incr[3]} ${valmat[3,${nrint[3]}]}  ) ; do
echo "del=" ${del[3]}
for  ch4 in $(seq ${valmat[4,0]} ${incr[4]} ${valmat[4,${nrint[4]}]}  ) ; do
echo "del=" ${del[4]}
for  ch5 in $(seq ${valmat[5,0]} ${incr[5]} ${valmat[5,${nrint[5]}]}  ) ; do
echo "del=" ${del[5]}

irun=`expr ${irun} + 1 `

echo "IRUN=" ${irun}

echo "ITER=" ${ch0} ${ch1}  ${ch2} ${ch3} ${ch4} ${ch5}
echo "###############################################################################"

iter=${ch0}_${ch1}_${ch2}_${ch3}_${ch4}_${ch5}

doutc3=${doutc}/ch0_${ch0}/ch1_${ch1}/ch2_${ch2}/ch3_${ch3}/ch4_${ch4}/ch5_${ch5}
doutc4=${doutc}/Merged_ch_${kode}_${scen}_${model}
doutc4s=${doutc4}/Namelists_saves
mkdir -p ${doutc3} ${doutc4} ${doutc4s}
dwkt=${doutc3}/tmp
mkdir -p ${dwkt}

cd ${dwkt}
############

\rm fort.4

cat << EOF > ${dwkt}/fort.4
\$namexp
pn=${ch0},${ch1},${ch2},${ch3},${ch4},${ch5},4*0.
zfac=${ifac[0]},${ifac[1]},${ifac[2]},${ifac[3]},${ifac[4]},${ifac[5]},4*1.
cvar='${culvar}'
ctype='${cultype}'
npcult=${npar}
/
EOF

\rm read_${clexp}_local.F90 a.out input.txt
############
cat << eof2 > input.txt
*MAIZE CULTIVAR COEFFICIENTS: MZCER048 MODEL
!
! COEFF       DEFINITIONS
! ========    ===========
! VAR#        Identification code or number for a specific cultivar
! VAR-NAME    Name of cultivar
! EXPNO       Number of experiments used to estimate cultivar parameters
! ECO#        Ecotype code of this cultivar, points to the Ecotype in the
!             ECO file (currently not used).
! P1          Thermal time from seedling emergence to the end of the juvenile
!             phase (expressed in degree days above a base temperature of 8 deg.C)
!             during which the plant is not responsive to changes in
!             photoperiod.
! P2          Extent to which development (expressed as days) is delayed for
!             each hour increase in photoperiod above the longest photoperiod
!             at which development proceeds at a maximum rate (which is
!             considered to be 12.5 hours).
! P5          Thermal time from silking to physiological maturity (expressed
!             in degree days above a base temperature of 8 deg.C).
! G2          Maximum possible number of kernels per plant.
! G3          Kernel filling rate during the linear grain filling stage and
!             under optimum conditions (mg/day).
! PHINT       Phylochron interval; the interval in thermal time (degree days)
!             between successive leaf tip appearances.
!
! PIO         Pioneer
! AS          Asgrow (Monsanto)
! DK          Dekalb (Monsanto)
! LH          Holden (Monsanto)
! C/LOL       Land of Lakes
!
!             P/G/N:Phenology/Growth/Not used for calbration
!
@VAR#  VRNAME.......... EXPNO   ECO#    P1    P2    P5    G2    G3 PHINT
!Coeffient #                             1     2     3     4     5     6
!Calibration                             P     P     P     G     G     N

999991 MINIMA               . DFAULT   5.0 0.000 580.0 248.0  5.00 38.00
999992 MAXIMA               . DFAULT 450.0 2.000 999.0 990.0 16.50 75.00

PC0001 2500-2600 GDD        . IB0001 160.0 0.750 780.0 750.0  8.50 49.00
PC0002 2600-2650 GDD        . IB0001 185.0 0.750 850.0 800.0  8.50 49.00
PC0003 2650-2700 GDD        . IB0001 212.0 0.750 850.0 800.0  8.50 49.00
PC0004 2700-2750 GDD        . IB0001 240.0 0.750 850.0 800.0  8.50 49.00
PC0005 2750-2800 GDD        . IB0001 260.0 0.750 850.0 800.0  8.50 49.00

990001 LONG SEASON          . IB0001 320.0 0.520 940.0 620.0  6.00 38.90
990002 MEDIUM SEASON        . IB0001 200.0 0.300 800.0 700.0  8.50 38.90
990003 SHORT SEASON         . IB0001 110.0 0.300 680.0 820.4  6.60 38.90
990004 V.SHORT SEASON       . IB0001   5.0 0.300 680.0 820.4  6.60 38.90
IB0001 CORNL281             . IB0001 110.0 0.300 685.0 907.9  6.60 38.90
IB0002 CP170                . IB0001 120.0 0.000 685.0 907.9 10.00 38.90
IB0003 LG11                 . IB0001 125.0 0.000 685.0 907.9 10.00 38.90
IB0004 F7 X F2              . IB0001 125.0 0.000 685.0 907.9 10.00 38.90
IB0005 PIO 3995             . IB0001 130.0 0.300 685.0 907.9  8.60 38.90
IB0006 INRA                 . IB0001 135.0 0.000 685.0 907.9 10.00 38.90
IB0007 EDO                  . IB0001 135.0 0.300 685.0 907.9 10.40 38.90
IB0008 A654 X F2            . IB0001 135.0 0.000 685.0 907.9 10.00 38.90
IB0009 DEKALB XL71          . IB0001 140.0 0.300 685.0 907.9 10.50 38.90
IB0010 F478 X W705A         . IB0001 140.0 0.000 685.0 907.9 10.00 38.90
IB0011 DEKALBXL45           . IB0001 150.0 0.400 685.0 907.9 10.15 38.90
IB0012 PIO 3382             . IB0001 160.0 0.700 950.0 845.0  8.40 38.90  
IB0013 B59*OH43             . IB0001 162.0 0.800 685.0 862.4  6.90 38.90
IB0014 F16 X F19            . IB0001 165.0 0.000 685.0 907.9 10.00 38.90
IB0015 WASHINGTON           . IB0001 165.0 0.400 715.0 825.0 11.00 38.90
IB0016 B14XOH43             . IB0001 172.0 0.300 685.0 907.9  8.50 38.90
IB0017 R1*(N32*B14)         . IB0001 172.0 0.800 685.0 907.9 10.15 38.90
IB0018 B60*R71              . IB0001 172.0 0.800 685.0 781.4  7.70 38.90
IB0019 WF9*B37              . IB0001 172.0 0.800 685.0 907.9 10.15 38.90
IB0020 B59*C103             . IB0001 172.0 0.800 685.0 907.9 10.15 38.90
IB0021 Garst 8702           . IB0001 175.0 0.200 960.0 855.8  6.00 38.90
IB0022 B14*C103             . IB0001 180.0 0.500 685.0 907.9 10.15 38.90
IB0023 B14*C131A            . IB0001 180.0 0.500 685.0 907.9 10.15 38.90
IB0024 PIO 3720             . IB0001 180.0 0.800 685.0 907.9 10.00 38.90
IB0025 WASH/GRAIN-1         . IB0001 185.0 0.400 775.0 836.0 12.00 38.90
IB0026 A632 X W117          . IB0001 187.0 0.000 685.0 907.9 10.00 38.90
IB0027 Garst 8750           . IB0001 190.0 0.200 930.0 891.0  6.30 38.90
IB0028 TAINAN-11            . IB0001 200.0 0.800 670.0 803.0  6.80 38.90
IB0029 PIO 3541             . IB0001 200.0 0.300 800.0 770.0  8.50 38.90
IB0030 PIO 3707             . IB0001 200.0 0.700 800.0 649.0  6.30 38.90
IB0031 PIO 3475*            . IB0001 200.0 0.700 800.0 797.5  8.60 38.90
IB0032 PIO 3382*            . IB0001 200.0 0.700 800.0 715.0  8.50 38.90
IB0033 PIO 3780             . IB0001 200.0 0.760 685.0 660.0  9.60 38.90
IB0034 PIO 3780*            . IB0001 200.0 0.760 685.0 797.5  9.60 38.90
IB0035 McCurdy 84aa         . IB0001 265.0 0.300 920.0 920.0  8.00 43.00  
IB0036 C281                 . IB0001 202.0 0.300 685.0 907.9  5.80 38.90
IB0037 SWEET CORN           . IB0001 210.0 0.520 625.0 907.5 10.00 38.90
IB0038 Garst 8555           . IB0001 215.0 0.400 890.0 880.0  9.00 38.90
IB0039 PIO 3901             . IB0001 215.0 0.760 600.0 616.0  9.00 38.90
IB0040 B8*153R              . IB0001 218.0 0.300 760.0 632.5  8.80 38.90
IB0041 Garst 8808           . IB0001 220.0 0.400 780.0 858.0  8.50 38.90
IB0042 B73 X MO17           . IB0001 220.0 0.520 880.0 803.0 10.00 38.90
IB0043 PIO 511A             . IB0001 220.0 0.300 685.0 709.5 10.50 38.90
IB0044 W69A X F546          . IB0001 240.0 0.300 685.0 907.9 10.00 38.90
IB0045 A632 X VA26          . IB0001 240.0 0.300 685.0 907.9 10.00 38.90
IB0046 W64A X W117          . IB0001 245.0 0.000 685.0 907.9  8.00 38.90
IB0047 PIO 3147             . IB0001 255.0 0.760 685.0 917.4 10.00 38.90
IB0048 WF9*B37              . IB0001 260.0 0.800 710.0 907.9  6.50 38.90
IB0049 NEB 611              . IB0001 260.0 0.300 720.0 907.5  9.00 38.90
IB0050 PV82S                . IB0001 260.0 0.500 750.0 660.0  8.50 38.90
IB0051 PV76S                . IB0001 260.0 0.500 750.0 660.0  8.50 38.90
IB0052 PIO 3183             . IB0001 260.0 0.500 750.0 660.0  8.50 38.90
IB0053 CESDA-28             . IB0001 260.0 0.500 669.0 858.0  7.10 38.90
IB0054 B14*OH43             . IB0001 265.0 0.800 665.0 858.0  6.90 38.90
IB0055 MCCURDY 6714         . IB0001 265.0 0.300 825.0 907.9  9.80 38.90
IB0056 FM 6                 . IB0001 276.0 0.520 867.0 677.6 10.70 38.90
IB0057 TOCORON-3            . IB0001 276.0 0.520 867.0 660.0  8.12 38.90
IB0058 NC+59                . IB0001 280.0 0.300 750.0 907.5 10.00 38.90
IB0059 H6                   . IB0001 310.0 0.300 685.0 907.9 10.00 38.90
IB0060 H610(UH)             . IB0001 365.0 0.520 850.0 680.0  6.50 38.90  
IB0061 PB 8                 . IB0001 300.0 0.520 990.0 440.0  7.00 38.90
IB0062 B56*C131A            . IB0001 318.0 0.500 700.0 885.5  6.40 38.90
IB0063 PIO X 304C           . IB0001 365.0 0.520 920.0 780.0  5.70 38.90  
IB0064 H.OBREGON            . IB0001 360.0 0.800 685.0 907.9 10.15 38.90
IB0065 SUWAN-1              . IB0001 380.0 0.600 780.0 825.0  7.00 38.90
IB0066 PIO 3165             . IB0001 320.0 0.520 940.0 625.0  6.00 38.90
IB0067 PIO 3324             . IB0001 320.0 0.520 940.0 625.0  6.00 38.90
IB0068 PIO 3475             . IB0001 200.0 0.700 750.0 907.0  9.00 38.90  
IB0168 PIO 3475 orig        . IB0001 220.0 0.700 850.0 907.0  9.90 38.90
IB0069 PIO 3790             . IB0001 212.4 0.520 792.8 625.0  6.00 38.90
IB0070 CARGILL 111S         . IB0001 290.0 0.500 1035. 580.0  5.50 47.00  
IB0071 PIO 31G98            . IB0003 165.0 0.750 680.0 820.4  6.60 48.00  
IB0089 GL 582               . IB0001 200.0 0.700 750.0 750.0  8.60 38.90
IB0090 GL 482               . IB0001 240.0 0.700 990.0 907.0  8.80 38.90
IB0091 GL 450               . IB0001 200.0 0.700 850.0 700.0  7.00 38.90
IB0092 LAURENT 3733         . IB0001 200.0 0.700 680.0 725.0  9.00 38.90  
IB0093 GL 582 MOD KBS       . IB0001 180.0 0.700 750.0 750.0  8.60 38.90
IB0099 AGETI76              . IB0001 325.0 2.000 625.0 580.0  7.30 50.00
IB0100 PARTAP1              . IB0001 450.0 2.000 580.0 600.0 16.50 50.00

IB1051 AS 740               . IB0001 215.0 0.750 850.0 700.0  5.00 48.00
IB1052 DK 611               . IB0001 260.0 0.100 800.0 980.0  5.70 48.00    
IB1053 LH198XLH185          . IB0001 205.0 0.750 850.0 731.0  5.00 48.00
IB0154 PIO 3192             . IB0001 215.0 0.300 990.0 660.0  8.50 48.00   
IB0155 DEA                  . IB0001 165.0 0.100 476.0 442.0  5.35 40.00   

!Brazil cultivars:
IB0171 AG9010               . IB0001 196.0 0.500 758.0 830.0  5.10 40.00   
IB0172 DAS CO32             . IB0001 220.0 0.500 747.8 1100.  5.40 45.00   
IB0173 DKB 333B             . IB0001 250.0 0.500 842.0 920.0  4.80 45.00   
IB0174 EXCELER              . IB0001 210.0 0.500 770.0 1170.  5.80 45.00   

IB0185 JACKSON HYBRI        . IB0001 200.0 0.300 950.0 980.0  7.15 43.00  

IB1065 PIO 33Y09            . IB0001 245.0 0.500 905.0 780.0  6.00 48.00
IB1066 PIO 3489             . IB0001 225.0 0.600 895.0 875.0  8.80 48.00
IB1067 PIO 3394             . IB0001 240.0 0.500 900.0 820.0  8.50 48.00
IB1069 PIO 3563             . IB0001 216.0 0.600 830.0 860.0  8.80 48.00
IB1072 DEKALB 485           . IB0001 215.0 0.600 785.0 750.0  8.70 45.00
IB1068 DEKALB 521           . IB0001 215.0 0.400 795.0 890.0  8.00 48.00
IB1168 DEKALB 591           . IB0001 225.0 0.400 895.0 880.0  8.00 48.00

LL0499 C/LOL 499            . IB0001 182.0 0.500 650.0 750.0  8.70 46.00
LL0564 C/LOL 564            . IB0001 210.0 0.500 670.0 880.0 11.25 46.00
LL0581 C/LOL 581            . IB0001 200.0 0.500 668.0 850.0  8.80 45.00
LL0599 C/LOL 599            . IB0001 200.0 0.500 670.0 850.0  8.80 45.00
LL0542 C/LOL 542            . IB0001 185.0 0.500 700.0 835.0  8.70 46.00
LL0661 C/LOL 661            . IB0001 200.0 0.500 670.0 850.0  9.00 45.00
LL0674 C/LOL 674            . IB0001 200.0 0.500 670.0 800.0  8.90 45.00

ZA0001 Prisma (FAO 700)     . IB0001 280.0 0.400 850.0 750.0  6.80 38.90
ZA0002 Prisma GC Avg        . IB0001 280.0 0.300 789.0 700.0  6.05 48.00

IF0001 OBA SUPER 2          . IB0001 270.0 0.600 780.0 840.0  7.80 45.00
IF0002 EV8728-SR            . IB0001 265.0 0.600 800.0 900.0  7.20 45.00
IF0003 Mokwa 87TZPB-SR      . IB0001 305.0 0.600 765.0 810.0  8.00 45.00
IF0004 SPL (semi-prol)      . IB0001 270.0 0.600 740.0 920.0  7.40 41.00
IF0005 TZB-SR (open p)      . IB0001 290.0 0.600 775.0 990.0  6.80 45.00
IF0006 EV 8449-SR           . IB0001 385.0 0.600 860.0 700.0  8.00 50.00
IF0007 EV 8449-SRx          . IB0001 385.0 0.600 860.0 945.4  7.20 50.00
IF0008 AG-KADUNA            . IB0001 220.0 0.600 780.0 845.0  8.00 40.00
IF0009 OBA S2 Benin         . IB0001 170.0 0.600 760.0 800.0  8.00 50.00
IF0010 EV-8449_TG           . IB0001 260.0 0.600 630.0 900.0  9.00 45.00
IF0011 EV-8443_TG           . IB0001 300.0 0.600 850.0 850.0  8.80 45.00

AC0001 TOHONO O'odham       . IB0001 200.0 0.100 610.0 248.0  9.80 38.90 !Michael Pool, Austin Comm College

! Vietnam sequencing
VI0001 LVN 10               . IB0001 350.0 1.000 980.0 760.0  9.20 38.90

!Coefficients calibrated by Jones and Boote in Mali
IM0001 SOTUBAKA             . IB0001 300.0 0.520 930.0 500.0  6.00 38.90
IM0002 NIELENI              . IB0001 232.0 0.300 688.0 540.0  8.80 38.90
IM0003 APPOLO               . IB0001 216.0 0.300 530.0 455.0 11.00 38.90

!Coefficients calibrated by Dzotsi and Singh in Togo, 2002.
IF0018 TZE C0MP4C2          . IB0001 210.0 0.100 660.0 850.0  9.70 55.00
IF0019 TZESRW X GUA 314     . IB0001 170.0 0.100 660.0 780.0  8.00 55.00
IF0020 AB-11-TG             . IB0001 250.0 0.100 620.0 920.0  8.50 55.00
IF0021 TZEEY-SRBC5          . IB0001 130.0 0.100 600.0 850.0  8.00 55.00
IF0022 IKENNE               . IB0001 280.0 0.600 630.0 900.0  8.80 45.00

!Alagarswamy
IB0067 TEST                 . IB0001 130.0 0.500 720.0 380.0  7.50 75.00
KA0001 H625                 . IB0001 130.0 0.500 720.0 380.0  7.50 75.00
EM0001 H512                 . IB0001 130.0 0.500 720 0 550.0  7.50 75.00
KY0001 H622                 . IB0001 358.5 0.500 616.1 550.0  7.20 75.00
KY0002 H511                 . IB0001 317.6 0.500 530.4 550.0  7.50 75.00
KY0003 CCOMP                . IB0001 366.2 1.235 611.3 600.0  6.50 75.00
KY0004 MAKUCOMP             . IB0001 183.6 0.500 611.0 380.0 10.00 75.00
KY0005 H625                 . IB0001 341.1 0.500 612.0 700.0  8.50 75.00
KY0006 KCB                  . IB0001 125.0 0.500 500.3 450.0 10.50 75.00
KY0007 PWANI                . IB0001 182.4 0.500 616.0 720.0 10.50 75.00
KY0008 H613                 . IB0001 182.4 0.500 616.0 825.0 10.15 75.00
KY0009 CUZCO                . IB0001 182.4 0.500 616.0 380.0  7.50 75.00
KY0010 H512                 . IB0001 332.9 0.500 601.6 550.0  7.50 75.00
KY0011 H614                 . IB0001 396.9 0.500 623.6 825.0 10.15 75.00
KY0012 H5012                . IB0001 351.7 0.500 859.0 550.0  7.50 75.00
KY0013 H626                 . IB0001 458.0 0.500 429.0 450.0 10.50 75.00
KY0014 KATUMANICOMPI        . IB0001 238.6 0.500 654.0 450.0 10.50 75.00
KY0015 PH 1                 . IB0001 234.5 0.500 429.0 720.0 10.50 75.00
KY0016 HAC                  . IB0001 245.0 0.500 825.0 750.0 10.50 75.00 
KY0017 H612                 . IB0001 130.0 0.500 390.0 825.0 10.15 75.00
KY0018 KATUMANICOMP-II      . IB0001 125.0 0.500 660.0 450.0 10.50 75.00

!J.B.Naab data 2003-2006, re-calibrated by kjb 1/2/12
GH0010 OBATANPA             . IB0001 280.0 0.000 750.0 540.0  7.50 40.00

!Four Global Futures maize cultivars (3 life cycle by 2 "yield levels")
!Composite: same maturity as Garst 8808 and WH403), but G2 and G3 mid-way.
!Those cultivars seemed most realistic compared with 5 other cultivars calibrated
!in DSSAT, not too early (Pio3382 too early), not too late (Pio 304C is late),
!not too high in yield(McCurdy 84aa not realistic), DK611 strange, and
!Obatanpa is low yielding (fertility constraints, or OPV)
!Yield "trait" is 5% higher RUE, 5% higher G2, 5% higher G3

GF0001 Base Garst808-wh403  . IB0001 250.0 0.500 730.0 800.0  7.80 38.90
GF0101 Baseline 10%shorter  . IB0001 215.0 0.500 650.0 800.0  7.80 38.90
GF0201 Baseline 10%longer   . IB0001 285.0 0.500 810.0 800.0  7.80 38.90
GF0301 Yield norm cycle     . IB0004 250.0 0.500 730.0 840.0  8.19 38.90
GF0401 Yield 10%shorter     . IB0004 215.0 0.500 650.0 840.0  8.19 38.90
GF0501 Yield 10%longer      . IB0004 285.0 0.500 810.0 840.0  8.19 38.90

CYMA01 wh403                . IB0001 265.0 0.760 685.0 760.0  7.60 38.90   

! Added by Camilo Andrade from Embrapa Maize and Sorghum
EBSL06 BRS1030-SL2009       . IB0001 263.8 0.500 1034  700.0  5.20 44.22 !Single-cross hybrid from Embrapa
###############
cat << eof2 > input.txt

*MAIZE CULTIVAR COEFFICIENTS: MZCER048 MODEL
!
!The P1 values for the varieties used in experiments IBWA8301 and
!UFGA8201 were recalibrated to obtain a better fit for version 3
!of the model. After converting from 2.1 to 3.0 the varieties
!IB0035, IB0060, and IB0063 showed an earlier simulated flowering
!date. To correct this, the P1 values were recalibrated.
!The reason for this is that there was an error in PHASEI in
!version 2.1 that had TLNO=IFIX(CUMDTT/21.+6.) rather than
!TLNO=IFIX(SUMDTT/21.+6.); see p. 74 of Jones & Kiniry.
!-Walter Bowen, 22 DEC 1994.
!
!All G2 values were increased by a factor of 1.1 for Ritchie's
!change to RUE -Walter, 28 DEC 1994
!
! COEFF       DEFINITIONS
! ========    ===========
! VAR#        Identification code or number for a specific cultivar
! VAR-NAME    Name of cultivar
! EXPNO       Number of experiments used to estimate cultivar parameters
! ECO#        Ecotype code of this cultivar, points to the Ecotype in the
!             ECO file (currently not used).
! P1          Thermal time from seedling emergence to the end of the juvenile
!             phase (expressed in degree days above a base temperature of 8 deg.C)
!             during which the plant is not responsive to changes in
!             photoperiod.
! P2          Extent to which development (expressed as days) is delayed for
!             each hour increase in photoperiod above the longest photoperiod
!             at which development proceeds at a maximum rate (which is
!             considered to be 12.5 hours).
! P5          Thermal time from silking to physiological maturity (expressed
!             in degree days above a base temperature of 8 deg.C).
! G2          Maximum possible number of kernels per plant.
! G3          Kernel filling rate during the linear grain filling stage and
!             under optimum conditions (mg/day).
! PHINT       Phylochron interval; the interval in thermal time (degree days)
!             between successive leaf tip appearances.
!
! PIO         Pioneer
! AS          Asgrow (Monsanto)
! DK          Dekalb (Monsanto)
! LH          Holden (Monsanto)
! C/LOL       Land of Lakes
!
!             P/G/N:Phenology/Growth/Not used for calbration
!
@VAR#  VRNAME.......... EXPNO   ECO#    P1    P2    P5    G2    G3 PHINT
!Coeffient #                             1     2     3     4     5     6
!Calibration                             P     P     P     G     G     N

999991 MINIMA               . DFAULT   5.0 0.000 580.0 248.0  5.00 38.00
999992 MAXIMA               . DFAULT 450.0 2.000 999.0 990.0 16.50 75.00

PC0001 2500-2600 GDD        . IB0001 160.0 0.750 780.0 750.0  8.50 49.00
PC0002 2600-2650 GDD        . IB0001 185.0 0.750 850.0 800.0  8.50 49.00
PC0003 2650-2700 GDD        . IB0001 212.0 0.750 850.0 800.0  8.50 49.00
PC0004 2700-2750 GDD        . IB0001 240.0 0.750 850.0 800.0  8.50 49.00
PC0005 2750-2800 GDD        . IB0001 260.0 0.750 850.0 800.0  8.50 49.00

990001 LONG SEASON          . IB0001 320.0 0.520 940.0 620.0  6.00 38.90
990002 MEDIUM SEASON        . IB0001 200.0 0.300 800.0 700.0  8.50 38.90
990003 SHORT SEASON         . IB0001 110.0 0.300 680.0 820.4  6.60 38.90
990004 V.SHORT SEASON       . IB0001   5.0 0.300 680.0 820.4  6.60 38.90
IB0001 CORNL281             . IB0001 110.0 0.300 685.0 907.9  6.60 38.90
IB0002 CP170                . IB0001 120.0 0.000 685.0 907.9 10.00 38.90
IB0003 LG11                 . IB0001 125.0 0.000 685.0 907.9 10.00 38.90
IB0004 F7 X F2              . IB0001 125.0 0.000 685.0 907.9 10.00 38.90
IB0005 PIO 3995             . IB0001 130.0 0.300 685.0 907.9  8.60 38.90
IB0006 INRA                 . IB0001 135.0 0.000 685.0 907.9 10.00 38.90
IB0007 EDO                  . IB0001 135.0 0.300 685.0 907.9 10.40 38.90
IB0008 A654 X F2            . IB0001 135.0 0.000 685.0 907.9 10.00 38.90
IB0009 DEKALB XL71          . IB0001 140.0 0.300 685.0 907.9 10.50 38.90
IB0010 F478 X W705A         . IB0001 140.0 0.000 685.0 907.9 10.00 38.90
IB0011 DEKALBXL45           . IB0001 150.0 0.400 685.0 907.9 10.15 38.90
IB0012 PIO 3382             . IB0001 160.0 0.700 950.0 845.0  8.40 38.90  
IB0013 B59*OH43             . IB0001 162.0 0.800 685.0 862.4  6.90 38.90
IB0014 F16 X F19            . IB0001 165.0 0.000 685.0 907.9 10.00 38.90
IB0015 WASHINGTON           . IB0001 165.0 0.400 715.0 825.0 11.00 38.90
IB0016 B14XOH43             . IB0001 172.0 0.300 685.0 907.9  8.50 38.90
IB0017 R1*(N32*B14)         . IB0001 172.0 0.800 685.0 907.9 10.15 38.90
IB0018 B60*R71              . IB0001 172.0 0.800 685.0 781.4  7.70 38.90
IB0019 WF9*B37              . IB0001 172.0 0.800 685.0 907.9 10.15 38.90
IB0020 B59*C103             . IB0001 172.0 0.800 685.0 907.9 10.15 38.90
IB0021 Garst 8702           . IB0001 175.0 0.200 960.0 855.8  6.00 38.90
IB0022 B14*C103             . IB0001 180.0 0.500 685.0 907.9 10.15 38.90
IB0023 B14*C131A            . IB0001 180.0 0.500 685.0 907.9 10.15 38.90
IB0024 PIO 3720             . IB0001 180.0 0.800 685.0 907.9 10.00 38.90
IB0025 WASH/GRAIN-1         . IB0001 185.0 0.400 775.0 836.0 12.00 38.90
IB0026 A632 X W117          . IB0001 187.0 0.000 685.0 907.9 10.00 38.90
IB0027 Garst 8750           . IB0001 190.0 0.200 930.0 891.0  6.30 38.90
IB0028 TAINAN-11            . IB0001 200.0 0.800 670.0 803.0  6.80 38.90
IB0029 PIO 3541             . IB0001 200.0 0.300 800.0 770.0  8.50 38.90
IB0030 PIO 3707             . IB0001 200.0 0.700 800.0 649.0  6.30 38.90
IB0031 PIO 3475*            . IB0001 200.0 0.700 800.0 797.5  8.60 38.90
IB0032 PIO 3382*            . IB0001 200.0 0.700 800.0 715.0  8.50 38.90
IB0033 PIO 3780             . IB0001 200.0 0.760 685.0 660.0  9.60 38.90
IB0034 PIO 3780*            . IB0001 200.0 0.760 685.0 797.5  9.60 38.90
IB0035 McCurdy 84aa         . IB0001 265.0 0.300 920.0 920.0  8.00 43.00  
IB0036 C281                 . IB0001 202.0 0.300 685.0 907.9  5.80 38.90
IB0037 SWEET CORN           . IB0001 210.0 0.520 625.0 907.5 10.00 38.90
IB0038 Garst 8555           . IB0001 215.0 0.400 890.0 880.0  9.00 38.90
IB0039 PIO 3901             . IB0001 215.0 0.760 600.0 616.0  9.00 38.90
IB0040 B8*153R              . IB0001 218.0 0.300 760.0 632.5  8.80 38.90
IB0041 Garst 8808           . IB0001 220.0 0.400 780.0 858.0  8.50 38.90
IB0042 B73 X MO17           . IB0001 220.0 0.520 880.0 803.0 10.00 38.90
IB0043 PIO 511A             . IB0001 220.0 0.300 685.0 709.5 10.50 38.90
IB0044 W69A X F546          . IB0001 240.0 0.300 685.0 907.9 10.00 38.90
IB0045 A632 X VA26          . IB0001 240.0 0.300 685.0 907.9 10.00 38.90
IB0046 W64A X W117          . IB0001 245.0 0.000 685.0 907.9  8.00 38.90
IB0047 PIO 3147             . IB0001 255.0 0.760 685.0 917.4 10.00 38.90
IB0048 WF9*B37              . IB0001 260.0 0.800 710.0 907.9  6.50 38.90
IB0049 NEB 611              . IB0001 260.0 0.300 720.0 907.5  9.00 38.90
IB0050 PV82S                . IB0001 260.0 0.500 750.0 660.0  8.50 38.90
IB0051 PV76S                . IB0001 260.0 0.500 750.0 660.0  8.50 38.90
IB0052 PIO 3183             . IB0001 260.0 0.500 750.0 660.0  8.50 38.90
IB0053 CESDA-28             . IB0001 260.0 0.500 669.0 858.0  7.10 38.90
IB0054 B14*OH43             . IB0001 265.0 0.800 665.0 858.0  6.90 38.90
IB0055 MCCURDY 6714         . IB0001 265.0 0.300 825.0 907.9  9.80 38.90
IB0056 FM 6                 . IB0001 276.0 0.520 867.0 677.6 10.70 38.90
IB0057 TOCORON-3            . IB0001 276.0 0.520 867.0 660.0  8.12 38.90
IB0058 NC+59                . IB0001 280.0 0.300 750.0 907.5 10.00 38.90
IB0059 H6                   . IB0001 310.0 0.300 685.0 907.9 10.00 38.90
IB0060 H610(UH)             . IB0001 365.0 0.520 850.0 680.0  6.50 38.90  
IB0061 PB 8                 . IB0001 300.0 0.520 990.0 440.0  7.00 38.90
IB0062 B56*C131A            . IB0001 318.0 0.500 700.0 885.5  6.40 38.90
IB0063 PIO X 304C           . IB0001 365.0 0.520 920.0 780.0  5.70 38.90  
IB0064 H.OBREGON            . IB0001 360.0 0.800 685.0 907.9 10.15 38.90
IB0065 SUWAN-1              . IB0001 380.0 0.600 780.0 825.0  7.00 38.90
IB0066 PIO 3165             . IB0001 320.0 0.520 940.0 625.0  6.00 38.90
IB0067 PIO 3324             . IB0001 320.0 0.520 940.0 625.0  6.00 38.90
IB0068 PIO 3475             . IB0001 200.0 0.700 750.0 907.0  9.00 38.90  
IB0168 PIO 3475 orig        . IB0001 220.0 0.700 850.0 907.0  9.90 38.90
IB0069 PIO 3790             . IB0001 212.4 0.520 792.8 625.0  6.00 38.90
IB0070 CARGILL 111S         . IB0001 290.0 0.500 1035. 580.0  5.50 47.00  
IB0071 PIO 31G98            . IB0003 165.0 0.750 680.0 820.4  6.60 48.00  
IB0089 GL 582               . IB0001 200.0 0.700 750.0 750.0  8.60 38.90
IB0090 GL 482               . IB0001 240.0 0.700 990.0 907.0  8.80 38.90
IB0091 GL 450               . IB0001 200.0 0.700 850.0 700.0  7.00 38.90
IB0092 LAURENT 3733         . IB0001 200.0 0.700 680.0 725.0  9.00 38.90  
IB0093 GL 582 MOD KBS       . IB0001 180.0 0.700 750.0 750.0  8.60 38.90
IB0099 AGETI76              . IB0001 325.0 2.000 625.0 580.0  7.30 50.00
IB0100 PARTAP1              . IB0001 450.0 2.000 580.0 600.0 16.50 50.00

IB1051 AS 740               . IB0001 215.0 0.750 850.0 700.0  5.00 48.00
IB1052 DK 611               . IB0001 260.0 0.100 800.0 980.0  5.70 48.00    
IB1053 LH198XLH185          . IB0001 205.0 0.750 850.0 731.0  5.00 48.00
IB0154 PIO 3192             . IB0001 215.0 0.300 990.0 660.0  8.50 48.00   
IB0155 DEA                  . IB0001 165.0 0.100 476.0 442.0  5.35 40.00   

!Brazil cultivars:
IB0171 AG9010               . IB0001 196.0 0.500 758.0 830.0  5.10 40.00   
IB0172 DAS CO32             . IB0001 220.0 0.500 747.8 1100.  5.40 45.00   
IB0173 DKB 333B             . IB0001 250.0 0.500 842.0 920.0  4.80 45.00   
IB0174 EXCELER              . IB0001 210.0 0.500 770.0 1170.  5.80 45.00   

IB0185 JACKSON HYBRI        . IB0001 200.0 0.300 950.0 980.0  7.15 43.00  

IB1065 PIO 33Y09            . IB0001 245.0 0.500 905.0 780.0  6.00 48.00
IB1066 PIO 3489             . IB0001 225.0 0.600 895.0 875.0  8.80 48.00
IB1067 PIO 3394             . IB0001 240.0 0.500 900.0 820.0  8.50 48.00
IB1069 PIO 3563             . IB0001 216.0 0.600 830.0 860.0  8.80 48.00
IB1072 DEKALB 485           . IB0001 215.0 0.600 785.0 750.0  8.70 45.00
IB1068 DEKALB 521           . IB0001 215.0 0.400 795.0 890.0  8.00 48.00
IB1168 DEKALB 591           . IB0001 225.0 0.400 895.0 880.0  8.00 48.00

LL0499 C/LOL 499            . IB0001 182.0 0.500 650.0 750.0  8.70 46.00
LL0564 C/LOL 564            . IB0001 210.0 0.500 670.0 880.0 11.25 46.00
LL0581 C/LOL 581            . IB0001 200.0 0.500 668.0 850.0  8.80 45.00
LL0599 C/LOL 599            . IB0001 200.0 0.500 670.0 850.0  8.80 45.00
LL0542 C/LOL 542            . IB0001 185.0 0.500 700.0 835.0  8.70 46.00
LL0661 C/LOL 661            . IB0001 200.0 0.500 670.0 850.0  9.00 45.00
LL0674 C/LOL 674            . IB0001 200.0 0.500 670.0 800.0  8.90 45.00

ZA0001 Prisma (FAO 700)     . IB0001 280.0 0.400 850.0 750.0  6.80 38.90
ZA0002 Prisma GC Avg        . IB0001 280.0 0.300 789.0 700.0  6.05 48.00

IF0001 OBA SUPER 2          . IB0001 270.0 0.600 780.0 840.0  7.80 45.00
IF0002 EV8728-SR            . IB0001 265.0 0.600 800.0 900.0  7.20 45.00
IF0003 Mokwa 87TZPB-SR      . IB0001 305.0 0.600 765.0 810.0  8.00 45.00
IF0004 SPL (semi-prol)      . IB0001 270.0 0.600 740.0 920.0  7.40 41.00
IF0005 TZB-SR (open p)      . IB0001 290.0 0.600 775.0 990.0  6.80 45.00
IF0006 EV 8449-SR           . IB0001 385.0 0.600 860.0 700.0  8.00 50.00
IF0007 EV 8449-SRx          . IB0001 385.0 0.600 860.0 945.4  7.20 50.00
IF0008 AG-KADUNA            . IB0001 220.0 0.600 780.0 845.0  8.00 40.00
IF0009 OBA S2 Benin         . IB0001 170.0 0.600 760.0 800.0  8.00 50.00
IF0010 EV-8449_TG           . IB0001 260.0 0.600 630.0 900.0  9.00 45.00
IF0011 EV-8443_TG           . IB0001 300.0 0.600 850.0 850.0  8.80 45.00

AC0001 TOHONO O'odham       . IB0001 200.0 0.100 610.0 248.0  9.80 38.90 !Michael Pool, Austin Comm College

! Vietnam sequencing
VI0001 LVN 10               . IB0001 350.0 1.000 980.0 760.0  9.20 38.90

!Coefficients calibrated by Jones and Boote in Mali
IM0001 SOTUBAKA             . IB0001 300.0 0.520 930.0 500.0  6.00 38.90
IM0002 NIELENI              . IB0001 232.0 0.300 688.0 540.0  8.80 38.90
IM0003 APPOLO               . IB0001 216.0 0.300 530.0 455.0 11.00 38.90

!Coefficients calibrated by Dzotsi and Singh in Togo, 2002.
IF0018 TZE C0MP4C2          . IB0001 210.0 0.100 660.0 850.0  9.70 55.00
IF0019 TZESRW X GUA 314     . IB0001 170.0 0.100 660.0 780.0  8.00 55.00
IF0020 AB-11-TG             . IB0001 250.0 0.100 620.0 920.0  8.50 55.00
IF0021 TZEEY-SRBC5          . IB0001 130.0 0.100 600.0 850.0  8.00 55.00
IF0022 IKENNE               . IB0001 280.0 0.600 630.0 900.0  8.80 45.00

!Alagarswamy
IB0067 TEST                 . IB0001 130.0 0.500 720.0 380.0  7.50 75.00
KA0001 H625                 . IB0001 130.0 0.500 720.0 380.0  7.50 75.00
EM0001 H512                 . IB0001 130.0 0.500 720 0 550.0  7.50 75.00
KY0001 H622                 . IB0001 358.5 0.500 616.1 550.0  7.20 75.00
KY0002 H511                 . IB0001 317.6 0.500 530.4 550.0  7.50 75.00
KY0003 CCOMP                . IB0001 366.2 1.235 611.3 600.0  6.50 75.00
KY0004 MAKUCOMP             . IB0001 183.6 0.500 611.0 380.0 10.00 75.00
KY0005 H625                 . IB0001 341.1 0.500 612.0 700.0  8.50 75.00
KY0006 KCB                  . IB0001 125.0 0.500 500.3 450.0 10.50 75.00
KY0007 PWANI                . IB0001 182.4 0.500 616.0 720.0 10.50 75.00
KY0008 H613                 . IB0001 182.4 0.500 616.0 825.0 10.15 75.00
KY0009 CUZCO                . IB0001 182.4 0.500 616.0 380.0  7.50 75.00
KY0010 H512                 . IB0001 332.9 0.500 601.6 550.0  7.50 75.00
KY0011 H614                 . IB0001 396.9 0.500 623.6 825.0 10.15 75.00
KY0012 H5012                . IB0001 351.7 0.500 859.0 550.0  7.50 75.00
KY0013 H626                 . IB0001 458.0 0.500 429.0 450.0 10.50 75.00
KY0014 KATUMANICOMPI        . IB0001 238.6 0.500 654.0 450.0 10.50 75.00
KY0015 PH 1                 . IB0001 234.5 0.500 429.0 720.0 10.50 75.00
KY0016 HAC                  . IB0001 245.0 0.500 825.0 750.0 10.50 75.00 
KY0017 H612                 . IB0001 130.0 0.500 390.0 825.0 10.15 75.00
KY0018 KATUMANICOMP-II      . IB0001 125.0 0.500 660.0 450.0 10.50 75.00

!J.B.Naab data 2003-2006, re-calibrated by kjb 1/2/12
GH0010 OBATANPA             . IB0001 280.0 0.000 750.0 540.0  7.50 40.00

!Four Global Futures maize cultivars (3 life cycle by 2 "yield levels")
!Composite: same maturity as Garst 8808 and WH403), but G2 and G3 mid-way.
!Those cultivars seemed most realistic compared with 5 other cultivars calibrated
!in DSSAT, not too early (Pio3382 too early), not too late (Pio 304C is late),
!not too high in yield(McCurdy 84aa not realistic), DK611 strange, and
!Obatanpa is low yielding (fertility constraints, or OPV)
!Yield "trait" is 5% higher RUE, 5% higher G2, 5% higher G3

GF0001 Base Garst808-wh403  . IB0001 250.0 0.500 730.0 800.0  7.80 38.90
GF0101 Baseline 10%shorter  . IB0001 215.0 0.500 650.0 800.0  7.80 38.90
GF0201 Baseline 10%longer   . IB0001 285.0 0.500 810.0 800.0  7.80 38.90
GF0301 Yield norm cycle     . IB0004 250.0 0.500 730.0 840.0  8.19 38.90
GF0401 Yield 10%shorter     . IB0004 215.0 0.500 650.0 840.0  8.19 38.90
GF0501 Yield 10%longer      . IB0004 285.0 0.500 810.0 840.0  8.19 38.90

CYMA01 wh403                . IB0001 265.0 0.760 685.0 760.0  7.60 38.90   

! Added by Camilo Andrade from Embrapa Maize and Sorghum
EBSL06 BRS1030-SL2009       . IB0001 263.8 0.500 1034  700.0  5.20 44.22 !Single-cross hybrid from Embrapa

eof2
############
cp  interface_crop_genotype-perturb_experiments.F90  read_${clexp}_local.F90
gfortran read_${clexp}_local.F90
./a.out
\mv ${dwkt}/output.txt  ${d0}/${clexp}${vmod}.${sufix}


ls -l ${d0}/${clexp}${vmod}.${sufix}

cd ${d0}
#cp ${daux}/dscm048_fin_teste_14apr2022 dscm048_fin_teste_14apr2022

exeopt='A '${fax}' NA'

./dscm048_fin_teste_14apr2022 ${exeopt}  1>${doutc3}/o1_${yy} \
                     2>${doutc3}/o2

/usr/bin/sed -e "1,21d"  < ${doutc3}/o1_${yy} > ${doutc3}/o1_${yy}.txt


\rm ${doutc3}/inforun
cat << EOF > ${doutc3}/inforun
'  '
year; ${yy} scen: ${scen} model: ${model} iter: ${ch0} ${ch1} ${ch2} ${ch3} ${ch4} ${ch5} 
EOF

\rm ${doutc3}/Info
cat ${doutc3}/inforun ${doutc3}/o1_${yy}.txt > ${doutc3}/Info
if [ ${irun} -eq 1 ] ; then
cp ${doutc3}/Info ${doutc4}/Info_all_IDEOTYPE
echo "FIRST case !"
ls -l ${doutc4}/Info_all_IDEOTYPE
else 
cat ${doutc4}/Info_all_IDEOTYPE ${doutc3}/Info > ${doutc4}/Info_all_IDEOTYPE_tmp
mv ${doutc4}/Info_all_IDEOTYPE_tmp ${doutc4}/Info_all_IDEOTYPE


### remove Failures ..
sed -e '/^  Crop/d'<  ${doutc4}/Info_all_IDEOTYPE > ${doutc4}/Info_all_IDEOTYPE_miss1
sed -e '/^Crop/d'  < ${doutc4}/Info_all_IDEOTYPE_miss1 > ${doutc4}/Info_all_IDEOTYPE_miss2
#### remove the first empty line (was a "Crop failure..." )
sed -e '/^$/d' < ${doutc4}/Info_all_IDEOTYPE_miss2 > ${doutc4}/Info_all_IDEOTYPE_miss
###################
\rm   ${doutc4}/Info_all_IDEOTYPE_miss1
\rm   ${doutc4}/Info_all_IDEOTYPE_miss2
ls -l ${doutc4}/Info_all_IDEOTYPE_miss
fi

 
\rm *.OUT 
cp ${d0}/${clexp}${vmod}.${sufix} ${doutc4s}/${clexp}${vmod}.${sufix}_${cltest}_${iter}

  done
  done
  done
  done
  done
  done
echo "done: P,G loops and runs" 
#echo "#############################"

# end if [ ${IDT} -ne 1 ] ; then

else
echo "###################################### CASE kode= ${kode} ###################"

cp ${daux}/${clexp}${vmod}.${sufix}_base ${d0}/${clexp}${vmod}.${sufix}


ch0=1
ch1=1
ch2=1
ch3=1
ch4=1
ch5=1
irun=1
doutc3=${doutc}/ch0_${ch0}/ch1_${ch1}/ch2_${ch2}/ch3_${ch3}/ch4_${ch4}/ch5_${ch5}
doutc4=${doutc}/Merged_ch_${kode}_${scen}_${model}
doutc4s=${doutc4}/Namelists_saves
mkdir -p ${doutc3} ${doutc4} ${doutc4s}
dwkt=${doutc3}/tmp
mkdir -p ${dwkt}

cd ${d0}

exeopt='A '${fax}' NA'
./dscm048_fin_teste_14apr2022 ${exeopt}  1>${doutc3}/o1_${yy} \
                     2>${doutc3}/o2
/usr/bin/sed -e "1,21d"  < ${doutc3}/o1_${yy} > ${doutc3}/o1_${yy}.txt

\rm ${doutc3}/inforun
cat << EOF > ${doutc3}/inforun
'  '
year; ${yy} scen: ${scen} model: ${model} iter: ${ch0} ${ch1} ${ch2} ${ch3} ${ch4} ${ch5} 
EOF

\rm ${doutc3}/Info
cat ${doutc3}/inforun ${doutc3}/o1_${yy}.txt > ${doutc3}/Info

if [ ${irun} -eq 1 ] ; then
cp ${doutc3}/Info ${doutc4}/Info_all_IDEOTYPE
echo "FIRST case !"
ls -l ${doutc4}/Info_all_IDEOTYPE

### remove Failures ..
sed -e '/^  Crop/d'<  ${doutc4}/Info_all_IDEOTYPE > ${doutc4}/Info_all_IDEOTYPE_miss1
sed -e '/^Crop/d'  < ${doutc4}/Info_all_IDEOTYPE_miss1 > ${doutc4}/Info_all_IDEOTYPE_miss2
#### remove the first empty line (was a "Crop failure..." )
sed -e '/^$/d' < ${doutc4}/Info_all_IDEOTYPE_miss2 > ${doutc4}/Info_all_IDEOTYPE_miss
###################
\rm   ${doutc4}/Info_all_IDEOTYPE_miss1
\rm   ${doutc4}/Info_all_IDEOTYPE_miss2
ls -l ${doutc4}/Info_all_IDEOTYPE_miss

fi

 
\rm *.OUT 
cp ${d0}/${clexp}${vmod}.${sufix} ${doutc4s}/${clexp}${vmod}.${sufix}_${cltest}_${iter}

fi



######################################################
  done
echo "DONE, culture type=" ${ccul}
echo "###################"

######################################################################################

echo "Results in:" ${doutc4}

################################################################


cp ${d0}/${fax} ${dout}/${fax}_Y${yy}
echo "DONE, year loop=" ${yy}

\rm -rf ${doutc}/ch* 

echo "DONE, model=" ${model}
done

###############################################################################
DIR=/home/utils/mailsend-1.19/bin
DOM=xxx
TO=mihaela.caian@gmail.com
FIC1=${doutc4}/Info_all_IDEOTYPE_miss
#-----------------------------------
#########################################################################


eof2


\rm scr_USER_base_merged
cat ${daux}/header.txt ${fain} ${daux}/scr_USER_fin_base  > \
    scr_USER_base_merged

chmod u+x scr_USER_base_merged


./scr_USER_base_merged   1>o1_user  2>o2_user

done
######################################################
###############################################################################
###############################################################################
