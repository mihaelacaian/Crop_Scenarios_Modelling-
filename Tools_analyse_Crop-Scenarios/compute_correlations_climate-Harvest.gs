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

imod=1
while(imod<=8)
if(imod=1)
model=ICHEC
endif
if(imod=2)
model=CNRCE
endif
if(imod=3)
model=MPIRC
endif
if(imod=4)
model=CNRCL
endif
if(imod=5)
model=CNRRA
endif
if(imod=6)
model=ICHRA
endif
if(imod=7)
model=NCCHI
endif
if(imod=8)
model=NCCRE
endif


xxx=1

while (xxx<=12)

dHnc='mydir'

'sdfopen 'dHnc'/'model'/o1_ally_'scenh'_'model'_H_tr'xxx'.nc_frame'

say 'file=' dHnc'/'model'/o1_ally_'scenh'_'model'_H_tr'xxx'.nc_frame'

'open ./BIN2/'model'/'scen'_30y_tx_mm.ctl'
'open ./BIN2/'model'/'scen'_30y_tn_mm.ctl'
'open ./BIN2/'model'/'scen'_30y_sr_mm.ctl'
'open ./BIN2/'model'/'scen'_30y_pp_mm.ctl'
'open ./BIN2/'model'/'scen'_30y_ppc_mm.ctl'


***************************************** 
******* NOTE: ********************************** 
* setting missto -99. (the netcedf file has missvalues-1.E=20 !!!

***************************************** 

'set gxout fwrite'
'set fwrite ./BIN2_correls/'model'/mthly_'scen'_corr_5vars-Harw_tr'xxx'_Test_REV.dat'

'set t 1'
im=1
* im: 12 months
* d1.1=Harvest

while(im<=12)
'd tcorr(d'im'.2(t+0),d1.1(t+0),t=1,t=30)'
'd tcorr(d'im'.3(t+0),d1.1(t+0),t=1,t=30)'
'd tcorr(d'im'.4(t+0),d1.1(t+0),t=1,t=30)'
'd tcorr(d'im'.5(t+0),d1.1(t+0),t=1,t=30)'
'd tcorr(d'im'.6(t+0),d1.1(t+0),t=1,t=30)'
im=im+1
endwhile

'close 6'
'close 5'
'close 4'
'close 3'
'close 2'
'close 1'
'disable fwrite'
xxx=xxx+1
endwhile
imod=imod+1
endwhile
iscen=iscen+1
endwhile
****************************************
