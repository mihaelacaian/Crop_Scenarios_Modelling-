********************************

***********
imod=1
while(imod<=1)
if(imod=1)
model='ENS'
endif

d00='myd00'
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
ix=1
while (ix<=12)
*while (ix<=1)

'open 'd0'/mthly_'scen'_corr_5vars-Harw_tr'ix'_Test_REV.ctl'

say "file=" d0'/mthly_'scen'_corr_5vars-Harw_tr'ix'_Test_REV.ctl'
pull dummy

'set vrange -1.2 1.2'
'set xlopts 1 6 0.2'
'set ylopts 1 6 0.2'

*'set t 1 12'
'set t 1 11'
'set parea 1 8 4 7'

'set xlabs J| F| M| A| M| J| J| A| S| O |N'

'set grads off'
'set ccolor 1'
'set cthick 12'
'set cmark 0'
'd csr'
'set string 1 l 10 0'
'set strsiz 0.16 0.16'
'draw string 1.15 4.2 r(H,sw)'

'set grads off'
'set ccolor 3'
'set cthick 12'
'set cmark 0'
'd ctx'
'set string 3 l 10 0'
'set strsiz 0.16 0.16'
'draw string 1.15 4.45 r(H,tx)'

'set grads off'
'set ccolor 7'
'set cthick 12'
'set cmark 0'
'd ctn'
'set string 7 l 10 0'
'set strsiz 0.16 0.16'
'draw string 1.15 4.7 r(H,tn)'

'set grads off'
'set ccolor 2'
'set cthick 12'
'set cmark 0'
'd cpp'
'set string 2 l 10 0'
'set strsiz 0.16 0.16'
'draw string 2.25 4.2 r(H,pp)'

'set grads off'
'set ccolor 14'
'set cthick 12'
'set cmark 0'
'd cppc'
'set string 14 l 10 0'
'set strsiz 0.16 0.16'
'draw string 2.25 4.45 r(H,ppc)'

'set string 1 l 10 0'
'set strsiz 0.16 0.16'
'draw string 1.15 6.85 TR'ix', 'scen


*'draw title correls(H_tr'ix',atm)_then_ENS  'scen
'printim PRINT_FIN/pr_correls_H_tr'ix'-atm_'scen'_Correls_then_'model'.jpg white'
pull dummy
c
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




