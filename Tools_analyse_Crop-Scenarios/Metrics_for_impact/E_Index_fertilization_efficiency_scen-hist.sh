#!/bin/sh

####### 1. compute & plot  efficiency: ENS8_prep_Heff_Fxx_rev.dat 

# scen=RCP85

cdo ensmean o1_ally_rcp85_CNRCL.ctl.nc o1_ally_rcp85_CNRM.nc o1_ally_rcp85_CNRRA.ctl.nc o1_ally_rcp85_ICHEC.nc o1_ally_rcp85_ICHRA.ctl.nc o1_ally_rcp85_MPI.nc o1_ally_rcp85_NCCHI.ctl.nc o1_ally_rcp85_NCCRE.ctl.nc ENS8_rcp85
cdo selindexbox,1,12,4,4 ENS8_rcp85 ENS8_rcp85_harvest
# BC operation:
cdo addc,1761 ENS8_rcp85_harvest ENS8_Percent_fadd1741_pr2/ENS8_Hist_rcp85_harvest_fadd
cdo timmean ENS8_rcp85_harvest_fadd ENS8_rcp85_harvest_fadd_tm

cat << eof2 > scr_compute_efficiency


suf1='prep_Heff'
suf2='rev.ctl'

'open ENS8_'suf1'_F0_'suf2
'open ENS8_'suf1'_Fx1_'suf2
'open ENS8_'suf1'_Fx2_'suf2
'set gxout fwrite'

'set fwrite ENS8_Eff_rev3.dat'
*******************
'set t 1 4'
'define ef1h=(eh.2-eh.1)/eh.1'
'define ef1r4=(er.2-er.1)/er.1'
'define ef1r8=(err.2-err.1)/err.1'

'define ef2h=(eh.3-eh.1)/eh.1'
'define ef2r4=(er.3-er.1)/er.1'
'define ef2r8=(err.3-err.1)/err.1'
*************************
it=1
while(it<=4)
'set t 'it

'set cstyle 1'
'set ccolor 1'
'd ef1h'
'set ccolor 3'
'd ef1r4'
'set ccolor 2'
'd ef1r8'

'set cstyle 5'
'set ccolor 1'
'd ef2h'
'set ccolor 3'
'd ef2r4'
'set ccolor 2'
'd ef2r8'


*'d (er.2-er.1)/er.1-(eh.2-eh.1)/eh.1'
*'d (err.2-err.1)/err.1-(eh.2-eh.1)/eh.1'
*'d (er.3-er.1)/err.1-(eh.3-eh.1)/eh.1'
*'d (err.3-err.1)/err.1-(eh.3-eh.1)/eh.1'
*
it=it+1
endwhile
*****************************
eof2
############2.plot and compare Efficiency for RCP85-Hist; RCP45-Hist
cat << eof3 > compute_compare_CH

'open ENS8_Eff_rev3.ctl'
'set t 1 4'
fac=100.
cs=2
'set vrange 0 50'
'set cthick 12'
'set lwid 13 7'
'set cthick 13'
'set parea 2 6 2 8'
'set xlopts 1 6 0.2'
'set ylopts 1 6 0.2'
'set strsiz 0.2 0.2'
'set xlabs 01.Apr| 15.Apr| 01.May| 15.May'

*
'set strsiz 0.2 0.2'
'set cstyle 1'
'set ccolor 1'
'set grads off'
'd ef1h*'fac
'set cstyle 'cs
'set ccolor 1'
'set grads off'
'd (ef2h-ef1h)*'fac

'set strsiz 0.2 0.2'
'set xlabs 01.Apr| 15.Apr| 01.May| 15.May'
'set strsiz 0.23 0.23'
'set string 1 l 10 0'
'set strsiz 0.23 0.23'
'set string 1 l 10 90'

'set lwid 14 4'
'set string 1 l 14 0'
'set strsiz 0.18 0.18'
'set line 1 1 12'
'draw line 2.6 7.8 3. 7.8 '
'set strsiz 0.23 0.23'
'draw string 3.2 7.8  E(Fx1)'
'set line 1 5 12'
'draw line 2.6 7.4 3. 7.4  '
'set string 1 l 14 0'
'set strsiz 0.23 0.23'
'draw string 3.2 7.4  E(Fx2)-E(Fx1)'

'set strsiz 0.21 0.21'
'set string 1 l 12  0'
'draw string 4.6 6.7 Hist'

*
'set cstyle 1'
'set ccolor 4'
'set grads off'
'd ef1r4*'fac
'set cstyle 'cs
'set ccolor 4'
'set grads off'
'd (ef2r4-ef1r4)*'fac
'set string 4 l 12 0'
'set strsiz 0.21 0.21'
'set string 4 l 12  0'
'draw string 4.6 6.35 RCP4.5'
*
'set cstyle 1'
'set ccolor 2'
'set grads off'
'd ef1r8*'fac
'set cstyle 'cs
'set ccolor 2'
'set grads off'
'd (ef2r8-ef1r8)*'fac
'set string 2 l 12 0'
'set strsiz 0.21 0.21'
'set string 2 l 12  0'
'draw string 4.6 6.0 RCP8.5'
*************
'set strsiz 0.23 0.23'
'set string 1 l 10 0'
'draw string 3. 1.35  sowing date'
'set strsiz 0.23 0.23'
'set string 1 l 10 90'
'draw string 1.1 3. Fert. efficiency [%]'

'printim pr_Efficiency_ferti_fin2.png x1000 y800 white'
eof3
##############################################3
##############################################3

