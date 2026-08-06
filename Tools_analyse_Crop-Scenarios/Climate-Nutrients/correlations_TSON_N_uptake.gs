d0='/run/media/mcaian/Storage2/Prepclim/DATA_BASIS_mai2022+Pap1/Saves_Res'
vnan=-99.
***************************************
isc=1
while(isc<=3)

if(isc=1)
ccsum=1
ypls=7.2
clescen='HIST'
'open 'd0'/corr_FERTI_SUM_scen1.ctl'
'open 'd0'/corr_FERTI_SUM_scen2.ctl'
'open 'd0'/corr_FERTI_SUM_scen3.ctl'
endif
if(isc=2)
ccsum=3
ypls=6.8
clescen='RCP45'
'open 'd0'/corr_FERTI_SUM_scen4.ctl'
'open 'd0'/corr_FERTI_SUM_scen5.ctl'
'open 'd0'/corr_FERTI_SUM_scen6.ctl'
endif
if(isc=3)
ccsum=2
ypls=6.4
clescen='RCP85'
'open 'd0'/corr_FERTI_SUM_scen7.ctl'
'open 'd0'/corr_FERTI_SUM_scen8.ctl'
'open 'd0'/corr_FERTI_SUM_scen9.ctl'
endif


ipl=1
while(ipl<=1)
if(ipl=1)
cc=1
var=d9pd10
cle='r(TNUP+TNLF,TSON)'
ypl=7.2
endif

'set string 1 bl 12 0'
'set cthick 12'
'set strsiz 0.2 0.2'
'draw string 2.5 0.2  treatment'
*'draw string 2.5 6.7 'tit

*'set parea 2. 5 1. 7'

******************************
'set xlopts 1 8 0.22'
'set ylopts 1 8 0.22'

'set t 1 12'
'set xaxis 1 12 1'
'set vrange -1 -0.3'
'define cc0='vnan
'define cc1=0.'
'define cc2=0.'
'define cc3=0.'
'set ccolor 'ccsum
'set grads off'
'd 'cc0
pull dummy
'set t 1 4'
'define cc1=('var'.1+'var'.2+'var'.3)/3.'
'set t 1 12'
'set ccolor 'ccsum
'set grads off'
'd 'cc1
**
pull dummy
'set t 5 8'
'define cc2=('var'.1+'var'.2+'var'.3)/3.'
'set t 1 12'
'set ccolor 'ccsum
'set grads off'
'd 'cc2
**
pull dummy
'set t 9 12'
'define cc3=('var'.1+'var'.2+'var'.3)/3.'
'set t 1 12'
'set ccolor 'ccsum
'set grads off'
'd 'cc3
**

'set strsiz 0.2 0.2'
'set string 'cc' c 10 0'
'draw string 8.0 'ypl' 'cle
pull dummy
ipl=ipl+1
endwhile
*******
*************************************
'close 3'
'close 2'
'close 1'
*pull dummy
*c
'set ccolor 'ccsum
'set strsiz 0.23 0.23'
'set string 'ccsum' c 10 0'
'draw string 4.0 'ypls' 'clescen
isc=isc+1
endwhile


*'draw title  Hist, RCP45, RCP85 (ENS), tcorr'
'printim PRINT/pr_tcorr_TNUP+TNLF_TSON_allsc.jpg white'
**********************************************
***************************************
**********************************************
