mod=ICHEC
*scen=rcp45
scen=rcp85
cscen=RCP85
*
'sdfopen o1_ally_'scen'_'mod'_H_tr9.nc_frame'
'sdfopen o1_ally_'scen'_'mod'_H_tr11.nc_frame'
'open 'cscen'_30y_pp_mm.ctl'

'set xaxis 2030 2040 5'
*'set xaxis 2030 2040 5'
x01=2.2
x02=4.
y0=1.8

x1=0.5
x11=0.8
y1=2.6
y11=4
*
x2=9.9
x21=9.6
y2=6.6
y21=6.9

'set parea 2 8 2.3 8'
*'set t 9 19'
'set t 10 20'

'set xlopts 1 10 0.23'
'set ylopts 1 10 0.23'
'set lwid 13 7'
'set lwid 14 3'

'set ccolor 2'
'set cthick 13'
'set grads off'
'd -d5.3+d4.3'
'define pp=-d5.3+d4.3'

'set ccolor 1'
'set cthick 13'
'set grads off'
*'set string 1 c 12 0'
'set ylpos 0 r'
'd d1.1-d1.2'
'define h=d1.1-d1.2'

'set strsiz 0.22'
'set string 1 l 14 0'
'draw string 2.15 7.7 r(2030-2040)=0.604'

'set strsiz 0.27 0.27'
'set cthick 8'
'set string 1 l 8 0'
'draw string 4.5 1.6 year'

'set strsiz 0.24 0.24'
'set cthick 8'
'set string 2 l 8 90'
'draw string 'x1' 'y1' precipitation difference'
'draw string 'x11' 'y1' April-May, RCP4.5, 'mod
'set strsiz 0.24 0.24'
'set cthick 8'
'set string 1 l 8 -90'
'draw string 'x2' 'y2' Harvest difference'
'draw string 'x21' 'y21'for sowing 01.Apr-15.May'


'printim pr_new_pp4-pp5_h9_h12_FIN2_'cscen'_'mod'_10y.png x1000 y800 white'
***************************************************
