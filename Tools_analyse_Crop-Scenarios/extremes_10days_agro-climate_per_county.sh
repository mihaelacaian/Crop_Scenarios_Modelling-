#!/bin/sh
dwk=mydir
d00=mydir0
daux=myaux
gr2='/home/utils/grads-2.2.0/bin/grads'
####################################################

list_counties='Arg Bra Buc Buz Cal Cta Dam Dol Gal Giu Gor Ial Ilf Meh Olt Pra Tel Tul Val Vra'
for jud in ${list_jud} ; do

# extreme indicators:
for var in BEDD FD R10mm R20mm RR RR1 TR SDII ; do

d0=${d00}/${var}/UAT/${jud}/Transform_nc_decade
dout=${d0}/PRINT
\rm -rf ${dout}
mkdir -p ${dout}


case ${var} in \
   BEDD) cvar='bedd' ; vrange='0 250' ;;
   FD) cvar='fd';vrange='0 12' ;;
   R10mm)cvar='r10mm' ;vrange='-0.1 5' ;;
   R20mm) cvar='r20mm' ;vrange='-0.05 1.4' ;;
   RR) cvar='rr' ;vrange='0 85' ;;
   RR1) cvar='rr1' ;vrange='-1 12' ;; 
   TR) cvar='tr' ;vrange='-0.1 3' ;;
   SDII) cvar='sdii' ;vrange='0 20' ;;
esac

cd ${daux}
for ind in $(cat list_${jud}) ; do

for scen in rcp4p5 rcp8p5 ; do
for day in 05 15 25; do

for month in 01 02 03 04 05 06 07 08 09 10 11 12 ; do

\rm namuat
cat << EOF >> namuat
uind=${ind}
scen=${scen}
dd=${day}
mm=${month}
var=${var}
cvar=${cvar}
vr='${vrange}'
EOF

cd ${dwk}
cat << EOF > scr_plot_10days_agro_ind.gs 
*jud=Cal
*uind=103032
*mm=04
*
*facr=1.

dout='mydir'
while(ivar<=4)

if(ivar=1) ; var=SDII ;   cvar=SDII;   vr='2 12' ;  vr2=' 2 12' ; corr1='-0.001'; pp1='p>0.1';corr2='+0.011'; pp2='p=0.01'; endif
if(ivar=2) ; var=RR ;   cvar=RR;   vr='-0.5 70';  vr2='-10 100' ; corr1='-0.025'; pp1='p=0.3';corr2='+0.05'; pp2='p=0.06'; endif
if(ivar=3) ; var=R10mm; cvar=R10mm;vr='-0.1 2'; vr2='-3 6' ;corr1='-0.0004'; pp1='p=0.7';corr2='+0.002'; pp2='p=0.07'; endif
if(ivar=4) ; var=R20mm; cvar=R20mm;vr='-0.1 0.9'; vr2='-2 2' ; endif
*
d0='mydir/'var'/UAT/'jud'/Transform_nc_decade'
dtr=d0'/'Trends
**********************************
*
iscen=1
while(iscen<=2)
if(iscen=1) ; scen=rcp4p5 ; endif
if(iscen=2) ; scen=rcp8p5 ; endif

dd=5
while(dd<=25)
cdd=dd
if(dd<=9); cdd='0'dd ; endif

reset
*********************************************************
***refacut *****

'sdfopen 'd0'/ENS_'var'_'uind'_'hist'_'scen'_'mm'_'cdd'.nc'

pull dummy
'set grads off'
'set gxout contour'
'set csmooth on'
'set cmark 0'
'set parea 2. 8 2. 8'

'set xlopts 1 12 0.21'
'set ylopts 1 12 0.25'
'set lwid 13 6'
'set lwid 14 4'


'set t 1 90'
'define cc1=0.'
'define cc2=0.'
'set t 1 30'
'cc1='cvar
'set t 30 90'
'cc2='cvar


'set t 1 90'
'set vrange 'vr

'set xaxis 1981 2070 20'

'set cmark 0'
'set rgb 25 0 0 0 255'
'set ccolor 1'
'set cthick 13'
'd cc1'
pull dummy

'set cmark 0'
'set ccolor 2'
'set cthick 13'
'd cc2'
pull dummy

'sdfopen 'd0'/MAX_'var'_'uind'_'hist'_'scen'_'mm'_'cdd'.nc'
pull dummy
'sdfopen 'd0'/MIN_'var'_'uind'_'hist'_'scen'_'mm'_'cdd'.nc'
pull dummy
'sdfopen 'dtr'/trline_ENS_'var'_'uind'_'hist'_'scen'_'mm'_'cdd'.nc'
pull dummy

'set t 1 90'
*'set vrange 'vr
'set cmark 0'
'set ccolor 1'
'set cthick 13'
'd 'cvar'.4'
pull dummy

'set lwid 14 4'
'set strsiz 0.23 0.21'
'set string 1 l 14 0'
*'draw string 3.5 7.5 'tit
*'set string 'cc' c 14 0'
*'draw string 3.8 'ypl' 'clescen' 'cle

'set strsiz 0.23 0.23'
'set string 1 l 10 0'
'draw string 4.5 1.3  years'
'set strsiz 0.26 0.26'
'set string 1 l 10 90'
'draw string 0.65 3. precip. intensity '
'draw string 1. 2.5 [(mm/wet day) in dekade]'
'set strsiz 0.23 0.25'
'set string 1 l 12  0'

del=1
x1=4.5 
y1=4.5

x2=x1+del
y2=y1+del

'set lwid 14 3'

'set rgb 20 128 128 128 40'
'set gxout linefill'
'set lfcols 20 20'
'set vrange 'vr
'd 'cvar'.2*'facr';'cvar'.3*'facr

'set string 1 l 14 0'
'set strsiz 0.26 0.26'
if(iscen=1) ; corr=''; pp=''; endif
if(iscen=2)
if(dd<9);  'draw string 5.5 7.2  'corr1 ; 'draw string 2.3 7.7 april' ; 'draw string 5.5 6.8  'pp1 ; 'draw string 2.3 7.3 dekade1' ; endif
if(dd=25); 'draw string 5.5 7.2  'corr2 ; 'draw string 2.3 7.7 april';'draw string 5.5 6.8  'pp2 ; 'draw string 2.3 7.3 dekade3' ;endif
endif
pull dummy

pull dummy
*
'set lwid 14 3'
'set string 1 l 14 0'
'set strsiz 0.23 0.21'
'printim PRINT/pr_'var'_'scen'_'jud'_'mm'_'cdd'.png x1000 y800 white'
pull dummy
c
'close 4'
'close 3'
'close 2'
'close 1'
dd=dd+10
endwhile
iscen=iscen+1
endwhile
ivar=ivar+1
endwhile
*'quit'
EOF

#############
\rm ${d0}/script_grads_agro_ind_UAT
cat namuat ${dwk}/scr_plot_10days_agro_ind.gs  > ${d0}/script_grads_agro_ind_UAT

cd ${d0}
${gr2} -blc script_grads_agro_ind_UAT
mv pr.png ${dout}/plot_${var}_${ind}_hist_${scen}_${day}_${month}.png
echo "result-plot in:" ${dout}/plot_${var}_hist_${scen}_${day}_${ind}.png
echo "plot uat=" $ind
done
done
done
done
done
done
######################################################
