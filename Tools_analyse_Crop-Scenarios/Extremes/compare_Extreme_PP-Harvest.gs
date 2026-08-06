
'open MARS_30y_pp+ppc_mm.ctl'
'open h12mh9.ctl'

'set parea 1 8 2 7'
'set t 1 30'

'set xlopts 1 8 0.18'
'set ylopts 1 8 0.18'

'set ccolor 1'
'set cthick 12'
'set grads off'
'd -d5.1+d4.1'

'set ccolor 3'
'set cthick 12'
'set grads off'
*'set string 1 c 12 0'
'set ylpos 0 r'
'd har.2'

'set strsiz 0.2'
'set string 1 l 12 c'
'draw string 1.3 6.8 r=0.415'
'printim pr_new_pp4-pp5_h12-h9.jpg white'
