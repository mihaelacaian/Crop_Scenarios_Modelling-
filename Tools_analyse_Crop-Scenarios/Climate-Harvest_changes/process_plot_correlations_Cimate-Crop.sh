#!/bin/sh
# analyse, plot differences in correlations climate-phenology between Climate-Scenarios and Historical
# analyse, plot  differences in correlations climate-phenology between various agro-managemenst, unde a given climate scenario

###########################
cat << eof1 > plot_diff_correlations_Climate-Harvest_for_Scen-Hist.gs

***********
imod=1
while(imod<=1)
if(imod=1)
model='ENS'
endif

d00='./BIN2_correls/Correls_then_'model
*****************
*
iscen=1
while(iscen<=3)

if(iscen=1)
scen=HIST
scenh=hist
iys=1976
iye=2005
endif
if(iscen=2)
scen=RCP45
scenh=rcp45
iys=2021
iye=2050
endif
if(iscen=3)
scen=RCP85
scenh=rcp85
iys=2021
iye=2050
endif

*d0=d00'/'model
d0=d00

**********************************
**********************************
ix=9
bgap=50
while (ix<=12)
ixm8=ix-8

if(ixm8=1) ; cs=1; endif
if(ixm8=2) ; cs=1; endif
if(ixm8=3) ; cs=1; endif
if(ixm8=4) ; cs=1; endif

bgap1=35
bgap2=50
bgap3=65
bgap4=80
bgap5=95
bgap6=20

**********************************
**********************************

'open 'd0'/mthly_'scen'_corr_5vars-Harw_tr'ix'_Test_REV.ctl'
'open 'd0'/mthly_'scen'_corr_5vars-Harw_tr'ixm8'_Test_REV.ctl'

pull dummy

'set parea 1 8 4 7'
'set xlabs J| F| M| A| M| J| J| A| S| O |N'

'set vrange -0.2 0.35 '
'set xlopts 1 6 0.18'
'set ylopts 1 6 0.18'
'set gxout bar'
'set bargap 'bgap
'set baropts outline'

'set t 1 12'
'set t 1 11'
'define cc=0.'


'set grads off'
'set ccolor 1'
'set cthick 4'
'set bargap 'bgap1
'set line 1 'cs' 12'
'set cstyle 'cs
'd (csr.1-csr.2);cc'
'set string 1 l 10 0'
'set strsiz 0.18 0.18'
'draw string 4.2 6.8 r(H,sw)'
'draw string 1.2 6.8 (Fx2-Fx0), 'scen
'draw string 1.2 6.5 date'ixm8

'set grads off'
'set ccolor 3'
'set cthick 4'
'set bargap 'bgap2
'set line 3 'cs' 12'
'set cstyle 'cs
'd (ctx.1-ctx.2);cc'
'set string 3 l 10 0'
'set strsiz 0.18 0.18'
'draw string 5.4 6.8 r(H,tx)'

'set grads off'
'set ccolor 7'
'set cthick 4'
'set bargap 'bgap3
'set line 7 'cs' 12'
'set cstyle 'cs
'd (ctn.1-ctn.2);cc'
'set string 7 l 10 0'
'set strsiz 0.18 0.18'
'draw string 6.7 6.8 r(H,tn)'


'set grads off'
'set ccolor 2'
'set cthick 4'
'set bargap 'bgap4
'set line 2 'cs' 12'
'set cstyle 'cs
'd (cpp.1-cpp.2);cc'
'set string 2 l 10 0'
'set strsiz 0.18 0.18'
'draw string 4.2 6.5 r(H,pp)'


'set grads off'
'set ccolor 14'
'set cthick 4'
'set bargap 'bgap5
'set line 14 'cs' 12'
'set cstyle 'cs
'd (cppc.1-cppc.2);cc'
'set string 14 l 10 0'
'set strsiz 0.18 0.18'
'draw string 5.4 6.5 r(H,ppc)'



'set gxout line'
'set grads off'
'set ccolor 1'
'set cthick 12'
'd smth9(csr.1-csr.2)'
*
'set gxout line'
'set grads off'
'set ccolor 3'
'set cthick 12'
'd smth9(ctx.1-ctx.2)'
*
'set gxout line'
'set grads off'
'set ccolor 7'
'set cthick 12'
'd smth9(ctn.1-ctn.2)'
*
'set gxout line'
'set grads off'
'set ccolor 2'
'set cthick 12'
'd smth9(cpp.1-cpp.2)'
*
*
'set gxout line'
'set grads off'
'set ccolor 14'
'set cthick 12'
'd smth9(cppc.1-cppc.2)'
*

*'draw title correls(H_tr'ix',atm)_then_ENS  'scen
'printim PRINT_FIN/DIFFS/H_tr'ix'-atm_'scen'_Correls_then_'model'.jpg white'
pull dummy
c
'close 2'
'close 1'
ix=ix+1
endwhile
*************************************
iscen=iscen+1
endwhile
*************************************
imod=imod+1
endwhile
*************************************
*************************************


eof1

##########################
cat << eof2 > plot_diff_correlations_Climate-Harvest_for_treatments.gs   

***********
imod=1
while(imod<=1)
if(imod=1)
model='ENS'
endif

d00='./BIN2_correls/Correls_then_'model
*****************
*
iscen=1
while(iscen<=3)

if(iscen=1)
scen=HIST
scenh=hist
iys=1976
iye=2005
endif
if(iscen=2)
scen=RCP45
scenh=rcp45
iys=2021
iye=2050
endif
if(iscen=3)
scen=RCP85
scenh=rcp85
iys=2021
iye=2050
endif

*d0=d00'/'model
d0=d00

**********************************
**********************************
ix=9
bgap=50
while (ix<=12)
ixm8=ix-8

if(ixm8=1) ; cs=1; endif
if(ixm8=2) ; cs=1; endif
if(ixm8=3) ; cs=1; endif
if(ixm8=4) ; cs=1; endif

bgap1=35
bgap2=50
bgap3=65
bgap4=80
bgap5=95
bgap6=20

**********************************
**********************************
'open 'd0'/mthly_'scen'_corr_5vars-Harw_tr'ix'_Test_REV.ctl'
'open 'd0'/mthly_'scen'_corr_5vars-Harw_tr'ixm8'_Test_REV.ctl'

pull dummy

'set parea 1 8 4 7'
'set xlabs J| F| M| A| M| J| J| A| S| O |N'

'set vrange -0.2 0.35 '
'set xlopts 1 6 0.18'
'set ylopts 1 6 0.18'
'set gxout bar'
'set bargap 'bgap
'set baropts outline'

'set t 1 12'
'set t 1 11'
'define cc=0.'


'set grads off'
'set ccolor 1'
'set cthick 4'
'set bargap 'bgap1
'set line 1 'cs' 12'
'set cstyle 'cs
'd (csr.1-csr.2);cc'
'set string 1 l 10 0'
'set strsiz 0.18 0.18'
'draw string 4.2 6.8 r(H,sw)'
'draw string 1.2 6.8 (Fx2-Fx0), 'scen
'draw string 1.2 6.5 date'ixm8

'set grads off'
'set ccolor 3'
'set cthick 4'
'set bargap 'bgap2
'set line 3 'cs' 12'
'set cstyle 'cs
'd (ctx.1-ctx.2);cc'
'set string 3 l 10 0'
'set strsiz 0.18 0.18'
'draw string 5.4 6.8 r(H,tx)'

'set grads off'
'set ccolor 7'
'set cthick 4'
'set bargap 'bgap3
'set line 7 'cs' 12'
'set cstyle 'cs
'd (ctn.1-ctn.2);cc'
'set string 7 l 10 0'
'set strsiz 0.18 0.18'
'draw string 6.7 6.8 r(H,tn)'


'set grads off'
'set ccolor 2'
'set cthick 4'
'set bargap 'bgap4
'set line 2 'cs' 12'
'set cstyle 'cs
'd (cpp.1-cpp.2);cc'
'set string 2 l 10 0'
'set strsiz 0.18 0.18'
'draw string 4.2 6.5 r(H,pp)'


'set grads off'
'set ccolor 14'
'set cthick 4'
'set bargap 'bgap5
'set line 14 'cs' 12'
'set cstyle 'cs
'd (cppc.1-cppc.2);cc'
'set string 14 l 10 0'
'set strsiz 0.18 0.18'
'draw string 5.4 6.5 r(H,ppc)'



'set gxout line'
'set grads off'
'set ccolor 1'
'set cthick 12'
'd smth9(csr.1-csr.2)'
*
'set gxout line'
'set grads off'
'set ccolor 3'
'set cthick 12'
'd smth9(ctx.1-ctx.2)'
*
'set gxout line'
'set grads off'
'set ccolor 7'
'set cthick 12'
'd smth9(ctn.1-ctn.2)'
*
'set gxout line'
'set grads off'
'set ccolor 2'
'set cthick 12'
'd smth9(cpp.1-cpp.2)'
*
*
'set gxout line'
'set grads off'
'set ccolor 14'
'set cthick 12'
'd smth9(cppc.1-cppc.2)'
*


*'draw title correls(H_tr'ix',atm)_then_ENS  'scen
'printim PRINT_FIN/DIFFS/H_tr'ix'-atm_'scen'_Correls_then_'model'.jpg white'
pull dummy
c
'close 2'
'close 1'
ix=ix+1
endwhile
*************************************
iscen=iscen+1
endwhile
*************************************
imod=imod+1
endwhile
*************************************
*************************************

eof2
#############################################
#############################################

