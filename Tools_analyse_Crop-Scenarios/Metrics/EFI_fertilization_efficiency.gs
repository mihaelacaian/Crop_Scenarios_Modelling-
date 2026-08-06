
* use gr2 for lwid

*cd /run/media/mcaian/Storage2/Prepclim/DATA_BASIS_mai2022+Pap1/Saves_Res_chain1_rest_5modele_2024/NEW_for_pap/NC_o1/ENS8_Efficiency_fadd1761_pr2

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
*'draw string 3. 1.2  sowing date'
'set strsiz 0.23 0.23'
'set string 1 l 10 90'
*'draw string 0.5 3. Harvest [kg/ha]'

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
*'draw string 2.3 7.5 Hist'
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
*'draw string 2.3 7.2 RCP4.5'
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
*'draw string 2.3 6.9 RCP8.5'
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
**'printim pr_Efficiency_ferti.jpg white'
