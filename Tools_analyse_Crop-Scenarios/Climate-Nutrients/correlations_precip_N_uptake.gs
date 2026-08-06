
*****  HIST, RCP45, RCP85 each opens corr for 8 models ****************

'set rgb 22 86 61 45'
'set rgb 21 106 81 65'
'set rgb 43 8 143 143'
*'set rgb 23 255 77 o'
'set rgb 23 255 77 0'
*255,77,0
'set lwid 13 9'
'set cthick 13'

isc=1
while(isc<=3)
*while(isc<=1)
if(isc=1)
clescen='HIST'
cclescen='Hist'
'open corr_PP_FERTI_scen1.ctl'
'open corr_PP_FERTI_scen2.ctl'
'open corr_PP_FERTI_scen3.ctl'
'open corr_PP_FERTI_scen4.ctl'
'open corr_PP_FERTI_scen5.ctl'
'open corr_PP_FERTI_scen6.ctl'
'open corr_PP_FERTI_scen7.ctl'
'open corr_PP_FERTI_scen8.ctl'
endif
if(isc=2)
clescen='RCP45'
cclescen='RCP4.5'
'open corr_PP_FERTI_scen9.ctl'
'open corr_PP_FERTI_scen10.ctl'
'open corr_PP_FERTI_scen11.ctl'
'open corr_PP_FERTI_scen12.ctl'
'open corr_PP_FERTI_scen13.ctl'
'open corr_PP_FERTI_scen14.ctl'
'open corr_PP_FERTI_scen15.ctl'
'open corr_PP_FERTI_scen16.ctl'
endif
if(isc=3)
clescen='RCP85'
cclescen='RCP8.5'
'open corr_PP_FERTI_scen17.ctl'
'open corr_PP_FERTI_scen18.ctl'
'open corr_PP_FERTI_scen19.ctl'
'open corr_PP_FERTI_scen20.ctl'
'open corr_PP_FERTI_scen21.ctl'
'open corr_PP_FERTI_scen22.ctl'
'open corr_PP_FERTI_scen23.ctl'
'open corr_PP_FERTI_scen24.ctl'
endif

ypl0=5.6
yypl0=ypl0-1.2

ipl=1
while(ipl<=3)
if(ipl=1)
cc=1
var=d5d9
cle='r(PP,TNUP)'
ypl=ypl0
fac=1.
endif
if(ipl=2)
cc=23
var=d5d10
cle='r(PP,TNLF)'
ypl=ypl0-0.8
fac=1.
endif
if(ipl=3)
cc=43
var=d5d11
cle='r(PP,TSON)'
ypl=ypl0-0.4
*fac=-1.
fac=1.
endif

'set parea 1.5 8.5 1.2 7.3'
'set parea 2. 8 2. 8'
'set xlopts 0 12 0.25'
'set ylopts 1 12 0.25'

'set xaxis 1 12 1'
'set vrange -1 1'


'set t 1 4'
'define cc1=('var'.1+'var'.2+'var'.3+'var'.4+'var'.5+'var'.6+'var'.7+'var'.8)*'fac'/8.'
'define cc11='var'.1*'fac
'define cc12='var'.2*'fac
'define cc13='var'.3*'fac
'define cc14='var'.4*'fac
'define cc15='var'.5*'fac
'define cc16='var'.6*'fac
'define cc17='var'.7*'fac
'define cc18='var'.8*'fac


'set t 1 12'
'set ccolor 'cc
'set grads off'
'set cstyle 1'
'set cthick 13'
'd 'cc1
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc11
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc12
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc13
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc14
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc15
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc16
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc17
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc18

'set t 5 8'
'define cc2=('var'.1+'var'.2+'var'.3+'var'.4+'var'.5+'var'.6+'var'.7+'var'.8)*'fac'/8.'
'define cc21='var'.1*'fac
'define cc22='var'.2*'fac
'define cc23='var'.3*'fac
'define cc24='var'.4*'fac
'define cc25='var'.5*'fac
'define cc26='var'.6*'fac
'define cc27='var'.7*'fac
'define cc28='var'.8*'fac
*
'set t 1 12'
'set ccolor 'cc
'set grads off'
'set cstyle 1'
'set cthick 13'
'd 'cc2
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc21
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc22
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc23
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc24
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc25
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc26
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc27
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc28
*******************************************
'set t 9 12'
'define cc3=('var'.1+'var'.2+'var'.3+'var'.4+'var'.5+'var'.6+'var'.7+'var'.8)*'fac'/8.'
'define cc31='var'.1*'fac
'define cc32='var'.2*'fac
'define cc33='var'.3*'fac
'define cc34='var'.4*'fac
'define cc35='var'.5*'fac
'define cc36='var'.6*'fac
'define cc37='var'.7*'fac
'define cc38='var'.8*'fac
*
'set t 1 12'
'set ccolor 'cc
'set grads off'
'set cstyle 1'
'set cthick 13'
'd 'cc3
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc31
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc32
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc33
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc34
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc35
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc36
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc37
'set cstyle 5'
'set cthick 4'
'set ccolor 'cc
'set grads off'
'd 'cc38
*******************************************
'set lwid 14 4'
'set strsiz 0.23 0.21'
'set string 1 l 14 0'
*'draw string 3.5 7.5 'tit
'set string 'cc' c 14 0'
'draw string 3.8 'ypl' 'cclescen' 'cle


'set strsiz 0.23 0.23'
'set string 1 l 10 0'
*'draw string 4. 0.65  sowing date'
'draw string 4. 0.25  sowing date'
'set strsiz 0.23 0.23'
'set string 1 l 10 90'
'draw string 0.6 4. correlations'
'set strsiz 0.23 0.25'
'set string 1 l 12  0'

'set strsiz 0.23 0.23'
'set string 1 l 12   60'
'set strsiz 0.25 0.23'
'set string 1 l 12  45'
*x0=1.6
*y0=0.9
*dx=0.535

x0=1.1
y0=1.
dx=0.55
nx=1
while(nx<=12)
if(nx=1) ; clab='01.Apr'; endif
if(nx=2) ; clab='15.Apr'; endif
if(nx=3) ; clab='01.May'; endif
if(nx=4) ; clab='15.May'; endif
if(nx=5) ; clab='01.Apr'; endif
if(nx=6) ; clab='15.Apr'; endif
if(nx=7) ; clab='01.May'; endif
if(nx=8) ; clab='15.May'; endif
if(nx=9) ; clab='01.Apr'; endif
if(nx=10) ; clab='15.Apr'; endif
if(nx=11) ; clab='01.May'; endif
if(nx=12) ; clab='15.May'; endif
'draw string 'x0' 'y0' 'clab
nx=nx+1
x0=x0+dx
endwhile

y1=0.72
'set string 1 c 12 0'
'draw string 2.85 'y1'  Fx0'
'draw string 5.05 'y1'  Fx1'
'draw string 7.3 'y1'  Fx2'

*'set strsiz 0.18 0.18'
*'set string 'cc' c 10 0'
*'draw string 3.5 'ypl' 'clescen' 'cle
*
*'set string 1 bl 12 0'
*'set cthick 13'
*'set strsiz 0.2 0.2'
*'draw string 4.5 0.35  treatment'
*
pull dummy
ipl=ipl+1
endwhile
*******
*'draw title  (PP,N)_ens: 'clescen', tcorr'
*'printim PRINT3/pr_tcorr_precip_N_'clescen'_FIN.png x1000 y800 white'
*************************************
ic=8
while(ic>=1)
'close 'ic
ic=ic-1
endwhile
pull dummy
c
isc=isc+1
endwhile
**********************************************
***************************************
**********************************************
