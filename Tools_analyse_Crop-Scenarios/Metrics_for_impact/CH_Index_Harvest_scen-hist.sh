#!/bin/sh
# 8 models
cdo ensmean o1_ally_rcp45_CNRCL.ctl.nc o1_ally_rcp45_CNRM.nc o1_ally_rcp45_CNRRA.ctl.nc o1_ally_rcp45_ICHEC.nc o1_ally_rcp45_ICHRA.ctl.nc o1_ally_rcp45_MPI.nc o1_ally_rcp45_NCCHI.ctl.nc o1_ally_rcp45_NCCRE.ctl.nc ENS8_rcp45
cdo selindexbox,1,12,4,4 ENS8_rcp45 ENS8_rcp45_harvest
# BC operation
cdo addc,1761 ENS8_rcp45_harvest ENS8_Percent_fadd1741_pr2/ENS8_Hist_rcp45_harvest_fadd
cdo sub ENS8_rcp45_harvest_fadd ENS8_Hist_harvest_fadd ENS8_r4-h_harvest_fadd
cdo div ENS8_r4-h_harvest_fadd ENS8_Hist_harvest_fadd ENS8_r4-h_harvest_fadd_div
cdo timmean ENS8_r4-h_harvest_fadd_div ENS8_r4-h_harvest_fadd_div_tm
####################
cat << eof2 > mmm_Fig1d.gs

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
marsmean=4280
modmean=2519
faddif=marsmean-modmean
cpr=pr2 
******************************
fadd=marsmean-modmean
********
if(norm=0)
clenorm='diffs.'
endif
if(norm=1)
clenorm='normalised diffs (/ hist)'
endif
**************
dir=mydir

say "dir=" dir
pull dummy

model=ENS
pref=ENS8
*suf='harvest_fadd_div_tm'
*fah=pref'_Hist_'suf
*fa4=pref'_r4-h_'suf
*fa8=pref'_r8-h_'suf
*'sdfopen 'dir'/'fah
*'sdfopen 'dir'/'fa4
*'sdfopen 'dir'/'fa8

fa0=ENS8_HmSpS_rev
prefo='ENS8_HmSpS'
suf0='rev.ctl'
'open 'dir'/'fa0'.ctl'
*******

ys=2021
ye=2050
ntx=ye-ys+1

*x0c=2.1
*x0c2=2.1
x0c=4.7
x0c2=4.7

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


'set y 1 '

'set x 1 '
'set xaxis 1 12'
*****************
tit=' H (s-h)/h %'
tit1=' H (rcp4.5-h)/h %'
tit2=' H (rcp8.5-h)/h %'
*'set vrange 0 15000'
*'set vrange -5000 5000'
zadd=fadd

*********************************
'set xaxis 1 12 1'
vr1=-15
vr2=-1
vr=' 'vr1' 'vr2' '
'set vrange 'vr
fac=-100.

*'set parea 2. 5 1. 7'
'set parea 2. 6 2. 8'
'set ylopts 1 12 0.25'
'set xlopts 0 6 0.2 '

'set cthick 12'
'set lwid 13 9'
'set cthick 13'
'set strsiz 0.2 0.2'
*'draw string 2.5 0.2  treatment'

'set t 1 12'
*******************************8
'set t 1 4 '
'set grads off'
'define h1=d4*'fac
'define h2=d8*'fac

'set t 1 12'
'set ccolor 4'
'set cthick 12'
'set lwid 13 9'
'set cthick 13'
'd h1'
'set grads off'
'set ccolor 2'
'set cthick 12'
'set lwid 13 9'
'set cthick 13'
'd h2'
**
pull dummy
'set t 5 8 '
'set grads off'
'define r1=d4*'fac
'define r2=d8*'fac

'set t 1 12'
'set ccolor 4'
'set cthick 12'
'set lwid 13 9'
'set cthick 13'
'd r1'
'set grads off'
'set ccolor 2'
'set cthick 12'
'set lwid 13 9'
'set cthick 13'
'd r2'
**
'set t 9 12 '
'set grads off'
'define rr1=d4*'fac
'define rr2=d8*'fac
'set t 1 12'
'set ccolor 4'
'set cthick 12'
'set lwid 13 9'
'set cthick 13'
'd rr1'
'set grads off'
'set ccolor 2'
'set cthick 12'
'set lwid 13 9'
'set cthick 13'
'd rr2'
**
'set string 1 bl 12 0'
*'draw string 2.5 0.2  treatment'
********************************
'set lwid 14 4'
'set strsiz 0.25 0.25'
'set string 1 l 14 0'
'draw string 2.7 7.8 'tit


x0f=2.2
x0f1=3.7
x0f2=5.1
y0f=2.3


'set strsiz 0.23 0.23'
'set string 1 l 10 0'
'draw string 'x0f' 'y0f' Fx0'
'draw string 'x0f1' 'y0f' Fx1'
'draw string 'x0f2' 'y0f' Fx2'
'draw string 3. 0.45  sowing date'
'set strsiz 0.23 0.23'
'set string 1 l 10 90'
'draw string 0.9 3. Harvest difference [%]'
'set strsiz 0.21 0.21'
'set string 1 l 12  0'

'draw string 'x0c' 6.85 Hist'
'set string 4 l 12 0'
'draw string 'x0c' 6.5 RCP4.5'
'set string 2 l 12 0'
'draw string 'x0c' 6.15 RCP8.5'
*'set strsiz 0.22 0.22'



'set strsiz 0.12 0.12'
'set string 1 l 12   60'
'set strsiz 0.25 0.23'
'set string 1 l 12  65'
*x0=1.6
*y0=0.9
*dx=0.535

x0=1.4
y0=0.7
dx=0.37
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

********************************
'set strsiz 0.18 0.18'
'set string 3 bl 12 0'
'set string 2 bl 12 0'
'printim PRINT_tm_ENS_8mod_REFACUTE_2025/pr_Hch_PERCENT_allF_'model'_FIN.png x1000 y800 white'
*pull dummy
*c
*******************************8
*************************************************

*******************
'close 1'
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

eof2
#############################3
#############################3
