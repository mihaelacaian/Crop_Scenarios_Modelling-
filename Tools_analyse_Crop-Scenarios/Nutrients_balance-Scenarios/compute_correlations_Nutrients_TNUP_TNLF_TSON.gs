*
diro1=mydiro1
diro2=mydir02


model1='ICHEC'
model2='CNRM'
model3='MPI'

model4='CNRCL'
model5='CNRRA'
model6='ICHRA'
model7='NCCHI'
model8='NCCRE'

********
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
pull dummy
****************************************
iexp=1
while(iexp<=24)
'set gxout fwrite'
'set fwrite corr_FERTI_scen'iexp'.dat'
'set t 1'
'set y 1'
*** RUN    TRT FLO MAT TOPWT HARWT  RAIN  TIRR   CET  PESW  TNUP  TNLF   TSON TSOC
*9=TNUP
*10=TNLF
*11=TSON
ix=1
while(ix<=12)
'set x 'ix
'd tcorr(d.'iexp'(y=9),d.'iexp'(y=10),t=1,t=30)'
'd tcorr(d.'iexp'(y=9),d.'iexp'(y=11),t=1,t=30)'
'd tcorr(d.'iexp'(y=10),d.'iexp'(y=11),t=1,t=30)'
ix=ix+1
endwhile
'disable fwrite'
iexp=iexp+1
endwhile

