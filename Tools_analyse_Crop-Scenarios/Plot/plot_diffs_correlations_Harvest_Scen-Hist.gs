********************************


model='ENS'

d00='myd00_'model
*****************
*
scen1=HIST
d0=d00

**********************************
ix=1
while (ix<=12)
*while (ix<=1)

is=2
while(is<=3)
if(is=2); scen=RCP45 ; endif
if(is=3); scen=RCP85 ; endif

'open 'd0'/mthly_'scen1'_corr_5vars-Harw_tr'ix'_Test_REV.ctl'
'open 'd0'/mthly_'scen'_corr_5vars-Harw_tr'ix'_Test_REV.ctl'

pull dummy
'set parea 1 5 1 7'
'set xlabs J| F| M| A| M| J| J| A| S| O |N'
*'set vrange -0.4 0.7 '
*vr='-0.4 0.7 '
'set xlopts 1 6 0.18'
'set ylopts 1 6 0.18'

*'set t 1 12'
'set t 1 11'

*********************************************
vr='-1. 0.7'
*'set vrange 'vr
'set xlopts 1 6 0.18'
'set ylopts 1 6 0.18'

* radiation_Harvest
'set grads off'
'set vrange 'vr
'set ccolor 1'
'set cthick 12'
'set ccolor 1'
'set cstyle 1'
*'d tloop(ave(csr2-csr1,t-1,t+1))'
'd csr.2-csr.1'
'set string 1 l 10 0'
'set strsiz 0.18 0.18'
'draw string 1.2 2.8 'scen'-'scen1',TR'ix
'draw string 1.4 2.5 r(H,sw)'

* Tx_Harvest
'set grads off'
'set vrange 'vr
'set ccolor 3'
'set cthick 12'
'set ccolor 3'
'set cstyle 1'
*'d tloop(ave(ctx2-ctx1,t-1,t+1))'
'd ctx.2-ctx.1'
'set string 3.5 l 10 0'
'set strsiz 0.18 0.18'
'draw string 1.4 2.2 r(H,tx)'

* Tn_Harvest
'set grads off'
'set vrange 'vr
'set ccolor 7'
'set cthick 12'
'set ccolor 7'
'set cstyle 1'
*'d tloop(ave(ctn2-ctn1,t-1,t+1))'
'd ctn.2-ctn.1'
'set string 7 l 10 0'
'set strsiz 0.18 0.18'
'draw string 1.4 1.9 r(H,tn)'

* Precip_Harvest
'set ccolor 2'
'set vrange 'vr
'set cstyle 1'
*'d tloop(ave(cpp2-cpp1,t-1,t+1))'
'd cpp.2-cpp.1'
'set string 2 l 10 0'
'set strsiz 0.18 0.18'
'draw string 1.4 1.6 r(H,pp)'

* Precip_accum_Harvest
'set grads off'
'set vrange 'vr
'set ccolor 14'
'set cthick 12'
'set cstyle 1'
*'d tloop(ave(cppc2-cppc1,t-1,t+1))'
'd cppc.2-cppc.1'
'set string 14 l 10 0'
'set strsiz 0.18 0.18'
'draw string 1.4 1.3 r(H,ppc)'

*'draw title correls(H_tr'ix',atm), diffs: (rcp45-H), ENS'
*'printim PRINT_correls/DIFFS_scen-h/pr_correls_'scen'-'scen1'_tr'ix'.jpg white'
pull dummy
c
*********************************************
'close 2'
'close 1'

****
is=is+1
endwhile
ix=ix+11
endwhile
*************************************
*************************************




