function main(args)
  rc = gsfallow("on")
  if (args='')
    say 'Two arguments are required: the # of rows and # of columns'
    return
  else
    nrows = subwrd(args,1)
    ncols = subwrd(args,2)
  endif


*****************
norm=0
cdiff='mat-atn'
diro1=mydiro1
diro2=mydiro2

********
if(norm=0)
clenorm='diffs.'
endif
if(norm=1)
clenorm='normalised diffs (/ hist)'
endif
**************
model='ENS'
model1='ICHEC'
model2='CNRM'
model3='MPI'
model4='CNRCL'
model5='CNRRA'
model6='ICHRA'
model7='NCCHI'
model8='NCCRE'

******************
'open 'diro1'/o1_ally_hist_'model1'.ctl'
'open 'diro1'/o1_ally_hist_'model2'.ctl'
'open 'diro1'/o1_ally_hist_'model3'.ctl'
'open 'diro2'/o1_ally_hist_'model4'.ctl'
'open 'diro2'/o1_ally_hist_'model5'.ctl'
'open 'diro2'/o1_ally_hist_'model6'.ctl'
'open 'diro2'/o1_ally_hist_'model7'.ctl'
'open 'diro2'/o1_ally_hist_'model8'.ctl'

'open 'diro1'/o1_ally_rcp45_'model1'.ctl'
'open 'diro1'/o1_ally_rcp45_'model2'.ctl'
'open 'diro1'/o1_ally_rcp45_'model3'.ctl'
'open 'diro2'/o1_ally_rcp45_'model4'.ctl'
'open 'diro2'/o1_ally_rcp45_'model5'.ctl'
'open 'diro2'/o1_ally_rcp45_'model6'.ctl'
'open 'diro2'/o1_ally_rcp45_'model7'.ctl'
'open 'diro2'/o1_ally_rcp45_'model8'.ctl'
*
'open 'diro1'/o1_ally_rcp85_'model1'.ctl'
'open 'diro1'/o1_ally_rcp85_'model2'.ctl'
'open 'diro1'/o1_ally_rcp85_'model3'.ctl'
'open 'diro2'/o1_ally_rcp85_'model4'.ctl'
'open 'diro2'/o1_ally_rcp85_'model5'.ctl'
'open 'diro2'/o1_ally_rcp85_'model6'.ctl'
'open 'diro2'/o1_ally_rcp85_'model7'.ctl'
'open 'diro2'/o1_ally_rcp85_'model8'.ctl'
*******


ys=2021
ye=2050
ntx=ye-ys+1

fac=1.
x0c=2.1
x0c2=2.1

*if(yvar=4) ; x0c=4.7 ; x0c2=4.7 ; endif


* BLUE
'set rgb 17   0   0 255'
'set rgb 18   20 20 255'
'set rgb 19   40 40 255'
'set rgb 20   60 60 255'
'set rgb 21   80 80 255'
'set rgb 22  90  90 255'
'set rgb 23 110 110 255'
'set rgb 24 130 130 255'
'set rgb 25 150 150 255'
'set rgb 26 165 165 255'
'set rgb 27 185 185 255'
'set rgb 28 200 200 255'
'set rgb 29 220 220 255'
* These are the RED shades
*'set rgb 30 255 220 220'
'set rgb 30 255 215 215'
'set rgb 31 255 210 210'
'set rgb 32 255 200 200'
'set rgb 33 255 190 190'
'set rgb 34 255 180 180'
'set rgb 35 255 170 170'
'set rgb 36 255 160 160'
'set rgb 37 255 150 150'
'set rgb 38 255 140 140'
'set rgb 39 255 130 130'
'set rgb 40 255 120 120'
'set rgb 41 255 110 110'
'set rgb 42 255 100 100'
'set rgb 43 255  90 90 '
'set rgb 44 255  80 80 '
'set rgb 45 255  70  70'
'set rgb 46 255  60  60'
'set rgb 47 255  50 50'
'set rgb 48 255  40  40'
'set rgb 49 255  30 30 '
'set rgb 50 255   0   0'
***********************************8
panels(args)
  p = 1
  ptot = nrows * ncols
  'set mproj scaled'

*******************************************

* x=trat ; y=var
* t=years


*yvarx=12
yvarx=2
xtratx=12

p=0

yvar=1
'set y 'yvar
'set x 1 'xtratx
*****************
'set t 1 '
'define h1=ave(d.1,t=1,t='ntx')'
'define h2=ave(d.2,t=1,t='ntx')'
'define h3=ave(d.3,t=1,t='ntx')'
'define h4=ave(d.4,t=1,t='ntx')'
'define h5=ave(d.5,t=1,t='ntx')'
'define h6=ave(d.6,t=1,t='ntx')'
'define h7=ave(d.7,t=1,t='ntx')'
'define h8=ave(d.8,t=1,t='ntx')'
'define he1=(h1+h2+h3+h4+h5+h6+h7+h8)/8.'
*
'define r1=ave(d.9,t=1,t='ntx')'
'define r2=ave(d.10,t=1,t='ntx')'
'define r3=ave(d.11,t=1,t='ntx')'
'define r4=ave(d.12,t=1,t='ntx')'
'define r5=ave(d.13,t=1,t='ntx')'
'define r6=ave(d.14,t=1,t='ntx')'
'define r7=ave(d.15,t=1,t='ntx')'
'define r8=ave(d.16,t=1,t='ntx')'
'define re1=(r1+r2+r3+r4+r5+r6+r7+r8)/8.'
*
'define rr1=ave(d.17,t=1,t='ntx')'
'define rr2=ave(d.18,t=1,t='ntx')'
'define rr3=ave(d.19,t=1,t='ntx')'
'define rr4=ave(d.20,t=1,t='ntx')'
'define rr5=ave(d.21,t=1,t='ntx')'
'define rr6=ave(d.22,t=1,t='ntx')'
'define rr7=ave(d.23,t=1,t='ntx')'
'define rr8=ave(d.24,t=1,t='ntx')'
'define rre1=(rr1+rr2+rr3+rr4+rr5+rr6+rr7+rr8)/8.'
**************************


yvar=2
'set y 'yvar
'set x 1 'xtratx
*****************
'set t 1 '
'define g1=ave(d.1,t=1,t='ntx')'
'define g2=ave(d.2,t=1,t='ntx')'
'define g3=ave(d.3,t=1,t='ntx')'
'define g4=ave(d.4,t=1,t='ntx')'
'define g5=ave(d.5,t=1,t='ntx')'
'define g6=ave(d.6,t=1,t='ntx')'
'define g7=ave(d.7,t=1,t='ntx')'
'define g8=ave(d.8,t=1,t='ntx')'
'define he2=(g1+g2+g3+g4+g5+g6+g7+g8)/8.'
*
'define s1=ave(d.9,t=1,t='ntx')'
'define s2=ave(d.10,t=1,t='ntx')'
'define s3=ave(d.11,t=1,t='ntx')'
'define s4=ave(d.12,t=1,t='ntx')'
'define s5=ave(d.13,t=1,t='ntx')'
'define s6=ave(d.14,t=1,t='ntx')'
'define s7=ave(d.15,t=1,t='ntx')'
'define s8=ave(d.16,t=1,t='ntx')'
'define re2=(s1+s2+s3+s4+s5+s6+s7+s8)/8.'
*
'define ss1=ave(d.17,t=1,t='ntx')'
'define ss2=ave(d.18,t=1,t='ntx')'
'define ss3=ave(d.19,t=1,t='ntx')'
'define ss4=ave(d.20,t=1,t='ntx')'
'define ss5=ave(d.21,t=1,t='ntx')'
'define ss6=ave(d.22,t=1,t='ntx')'
'define ss7=ave(d.23,t=1,t='ntx')'
'define ss8=ave(d.24,t=1,t='ntx')'
'define rre2=(ss1+ss2+ss3+ss4+ss5+ss6+ss7+ss8)/8.'
**************************
**************************



*** title
tit='(Mat-Ant) [d]'
tity='number of days'
vr='30 80'
***vr='40 50'
*vr='35 55'

*********************************

'set parea 2. 6 2. 8'
'set ylopts 1 12 0.25'
'set xlopts 1 12 0.25 '
******************************8
ixs=1

while(ixs<=9) 
ixe=ixs+4-1
ixsm1=ixs-1
ixep1=ixe+1
'set x 'ixs' 'ixe


*


    p = 1
    _vpg.p
'set vrange 'vr

if(ixs=1)
cfert='fert_x0'
*'set xlabs  1 | 2 | 3 | 4  '
endif
if(ixs=5)
cfert='fert_x1'
*'set xlabs 5 | 6 | 7 | 8 '
endif
if(ixs=9)
cfert='fert_x2'
*'set xlabs 9 | 10 | 11 | 12 '
endif
'set xlabs 01.Apr| 15.Apr| 01.May| 15.May'

'set cstyle 1'
'set cmark 5'
'set digsize 0.12'
'set ccolor 1'
'set grads off'
*'set cthick 12'
'set lwid 13 9'
'set cthick 13'
'd (he2-he1)'
pull dummy
'set cthick 13'
*
'set grads off'
'set line 1 5 10'
'set cstyle 0'
'set cmark 5'
'set digsize 0.12'
'set ccolor 1 '
'set cthick 13'
'd (g1-h1)'
pull dummy
'set grads off'
'set line 1 5 10'
'set line 1 5 10'
'set cstyle 0'
'set cmark 5'
'set digsize 0.12'
'set ccolor 1 '
'd (g2-h2)'
pull dummy
'set grads off'
'set line 1 5 10'
'set line 1 5 10'
'set cstyle 0'
'set cmark 5'
'set digsize 0.12'
'set ccolor 1 '
'd (g3-h3)'
pull dummy

'set line 1 5 10'
'set line 1 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 1 '
'd (g4-h4)'
pull dummy
'set grads off'
'set line 1 5 10'
'set line 1 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 1 '
'd (g5-h5)'
pull dummy
'set grads off'
'set line 1 5 10'
'set line 1 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 1 '
'd (g6-h6)'
pull dummy
'set grads off'
'set line 1 5 10'
'set line 1 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 1 '
'd (g7-h7)'
pull dummy
'set grads off'
'set line 1 5 10'
'set line 1 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 1 '
'd (g8-h8)'
pull dummy
********************************
'set cstyle 1'
'set cmark 5'
'set digsize 0.12'
'set ccolor 4'
'set grads off'
'set cthick 13'
'd (re2-re1)'
pull dummy
'set ccolor 4'
'set grads off'
'set cthick 3'
'set cstyle 0'
'set cmark 5'
'set digsize 0.12'
*
'set grads off'
'set line 3 5 10'
'set line 3 5 10'
'set cstyle 0'
'set cmark 5'
'set digsize 0.12'
'set ccolor 4 '
'd (s1-r1)'
pull dummy
'set grads off'
'set line 3 5 10'
'set line 3 5 10'
'set cstyle 0'
'set cmark 5'
'set digsize 0.12'
'set ccolor 4 '
'd (s2-r2)'
pull dummy
'set grads off'
'set line 3 5 10'
'set line 3 5 10'
'set cstyle 0'
'set cmark 5'
'set digsize 0.12'
'set ccolor 4 '
'd (s3-r3)'
pull dummy
'set grads off'
'set line 3 5 10'
'set line 3 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 4 '
'd (s4-r4)'
pull dummy
'set grads off'
'set line 3 5 10'
'set line 3 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 4 '
'd (s5-r5)'
pull dummy
'set grads off'
'set line 3 5 10'
'set line 3 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 4 '
'd (s6-r6)'
pull dummy
'set grads off'
'set line 3 5 10'
'set line 3 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 4 '
'd (s7-r7)'
pull dummy
'set grads off'
'set line 3 5 10'
'set line 3 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 4 '
'd (s8-r8)'
pull dummy
************************************

'set cstyle 1'
'set cmark 5'
'set digsize 0.12'
'set ccolor 2'
'set grads off'
'set cthick 13'
'd (rre2-rre1)'
pull dummy
'set cthick 13'
'set cstyle 0'
'set cmark 5'
'set digsize 0.12'
'set ccolor 2'
*
'set grads off'
'set line 2 5 10'
'set line 2 5 10'
'set cstyle 0'
'set cmark 5'
'set digsize 0.12'
'set ccolor 2 '
'd (ss1-rr1)'
pull dummy
'set grads off'
'set line 2 5 10'
'set line 2 5 10'
'set cstyle 0'
'set cmark 5'
'set digsize 0.12'
'set ccolor 2 '
'd (ss2-rr2)'
pull dummy
'set line 2 5 10'
'set grads off'
'set line 2 5 10'
'set cstyle 0'
'set cmark 5'
'set digsize 0.12'
'set ccolor 2 '
'd (ss3-rr3)'
pull dummy

'set grads off'
'set line 2 5 10'
'set line 2 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 2 '
'd (ss4-rr4)'
pull dummy
'set grads off'
'set line 2 5 10'
'set line 2 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 2 '
'd (ss5-rr5)'
pull dummy
'set line 2 5 10'
'set grads off'
'set line 2 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 2 '
'd (ss6-rr6)'
'set cthick 13'
'set grads off'
'set line 2 5 10'
'set line 2 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 2 '
'd (ss7-rr7)'
pull dummy
'set grads off'
'set line 2 5 10'
'set line 2 5 10'
'set cstyle 0'
'set cmark 5'
'set ccolor 2 '
'd (ss8-rr8)'
pull dummy


*********************************
'set lwid 14 4'
'set string 1 l 14 0'
'set strsiz 0.25 0.25'
'draw string 3. 7.8 'tit
'set strsiz 0.23 0.22'
'set string 1 bl 12 0'
*'draw string 3.5 7.25 'cfert

'set strsiz 0.23 0.23'
'set string 1 l 10 0'
'draw string 3. 1.2  sowing date'
'set strsiz 0.23 0.23'
'set string 1 l 10 90'
'draw string 0.8 3. 'tity

'set strsiz 0.21 0.21'
'set string 1 l 12  0'
'draw string 'x0c' 7.1 Hist'
'set string 4 l 12 0'
'draw string 'x0c' 6.7 RCP4.5'
'set string 2 l 12 0'
'draw string 'x0c' 6.3 RCP8.5'
'set lwid 14 4'



**'printim PRINT_tm_ENS_8mod_REFACUTE_2024/DIFF/pr_'cdiff'_'cfert'_'allmod'.jpg white'
'printim PRINT_tm_ENS_8mod_REFACUTE_2025/pr_'cdiff'_'cfert'_allmod.png x1000 y800 white' 
pull dummy
c
'define dd=(re2-re1)-(he2-he1)' 
'define ddd=(rre2-rre1)-(he2-he1)' 

'set ylopts 1 12 0.25'
'set xlopts 1 12 0.25 '
if(ixs=1)
cfert='fert_x0'
*'set xlabs  1 | 2 | 3 | 4  '
endif
if(ixs=5)
cfert='fert_x1'
*'set xlabs 5 | 6 | 7 | 8 '
endif
if(ixs=9)
cfert='fert_x2'
*'set xlabs 9 | 10 | 11 | 12 '
endif
'set xlabs 01.Apr| 15.Apr| 01.May| 15.May'
*'set vrange -4 -1'
'set vrange -8 -1'
'set grads off'
'set line 3 5 10'
'set cstyle 1'
'set cmark 5'
'set digsize 0.12'
'set ccolor 4 '
'set cthick 13'
'd dd'
'set grads off'
'set line 2 5 10'
'set cstyle 1'
'set cmark 5'
'set digsize 0.12'
'set ccolor 2 '
'set cthick 13'
'd ddd'

'set strsiz 0.23 0.23'
'set string 1 l 10 0'
'draw string 3. 1.2  sowing date'
'set strsiz 0.23 0.23'
'set string 1 l 10 90'
'draw string 0.7 3. 'tity


'set lwid 14 4'
'set string 1 l 14 0'
'set strsiz 0.25 0.25'
'draw string 3. 7.8 'tit
'set strsiz 0.23 0.22'
'set string 1 bl 12 0'
*'draw string 3.5 7.25 'cfert

'set strsiz 0.21 0.21'
'set string 1 l 12  0'
*'draw string 'x0c' 7.1 Hist'
'set string 4 l 12 0'
'draw string 'x0c' 6.7 RCP4.5-Hist'
'set string 2 l 12 0'
'draw string 'x0c' 6.3 RCP8.5-Hist'
'set lwid 14 4'
 
'printim PRINT_tm_ENS_8mod_REFACUTE_2025/pr_'cdiff'_s-h_'cfert'_allmod.png x1000 y800 white'

pull dummy
c

*  
ixs=ixs+4
endwhile
*******************************8
icl=24
while(icl>=1)
'close 'icl
icl=icl-1
endwhile

****************************************
* This function evenly divides the real page into a given number of rows
* and columns then creates global variables that contain the 'set vpage'
* commands for each panel in the multi-panel plot.
*
* Usage: panels(rows cols)
*
* Written by JMA March 2001
*
function panels(args)

* Get arguments
  if (args='')
    say 'panels requires two arguments: the # of rows and # of columns'
    return
  else
    nrows = subwrd(args,1)
    ncols = subwrd(args,2)
  endif

* Get dimensions of the real page
  'query gxinfo'
  rec2  = sublin(result,2)
  xsize = subwrd(rec2,4)
  ysize = subwrd(rec2,6)

* Calculate coordinates of each vpage
  width  = xsize/ncols
  height = ysize/nrows
  row = 1
  col = 1
  panel = 1
  while (row <= nrows)
    yhi = ysize - (height * (row - 1))
    if (row = nrows)
      ylo = 0
    else
      ylo = yhi - height
    endif
    while (col <= ncols)
      xlo = width * (col - 1)
      xhi = xlo + width
      _vpg.panel = 'set vpage 'xlo'  'xhi'  'ylo'  'yhi
      panel = panel + 1
      col = col + 1

 endwhile
    col = 1
    row = row + 1
  endwhile
  return

* THE END *


*'quit'
