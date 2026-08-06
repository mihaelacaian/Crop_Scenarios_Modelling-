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

model1=ICHEC
model2=CNRCE
model3=MPIRC
model4=CNRCL
model5=CNRRA
model6=ICHRA
model7=NCCHI
model8=NCCRE


xxx=1
while (xxx<=12)

fa1='./BIN2_correls/'model1'/mthly_'scen'_corr_5vars-Harw_tr'xxx'_Test_REV.ctl'
fa2='./BIN2_correls/'model2'/mthly_'scen'_corr_5vars-Harw_tr'xxx'_Test_REV.ctl'
fa3='./BIN2_correls/'model3'/mthly_'scen'_corr_5vars-Harw_tr'xxx'_Test_REV.ctl'
fa4='./BIN2_correls/'model4'/mthly_'scen'_corr_5vars-Harw_tr'xxx'_Test_REV.ctl'
fa5='./BIN2_correls/'model5'/mthly_'scen'_corr_5vars-Harw_tr'xxx'_Test_REV.ctl'
fa6='./BIN2_correls/'model6'/mthly_'scen'_corr_5vars-Harw_tr'xxx'_Test_REV.ctl'
fa7='./BIN2_correls/'model7'/mthly_'scen'_corr_5vars-Harw_tr'xxx'_Test_REV.ctl'
fa8='./BIN2_correls/'model8'/mthly_'scen'_corr_5vars-Harw_tr'xxx'_Test_REV.ctl'

'open 'fa1
'open 'fa2
'open 'fa3
'open 'fa4
'open 'fa5
'open 'fa6
'open 'fa7
'open 'fa8

'set gxout fwrite'
'set fwrite ./BIN2_correls/Correls_then_ENS/mthly_'scen'_corr_5vars-Harw_tr'xxx'_Test_REV.dat'

im=1
while(im<=12)
'set t 'im
'd (ctx.1+ctx.2+ctx.3+ctx.4+ctx.5+ctx.6+ctx.7+ctx.8)/8.)'
'd (ctn.1+ctn.2+ctn.3+ctn.4+ctn.5+ctn.6+ctn.7+ctn.8)/8.)'
'd (csr.1+csr.2+csr.3+csr.4+csr.5+csr.6+csr.7+csr.8)/8.)'
'd (cpp.1+cpp.2+cpp.3+cpp.4+cpp.5+cpp.6+cpp.7+cpp.8)/8.)'
'd (cppc.1+cppc.2+cppc.3+cppc.4+cppc.5+cppc.6+cppc.7+cppc.8)/8.)'
im=im+1
endwhile
'disable fwrite'

icl=8
while(icl>=1)
'close 'icl
icl=icl-1
endwhile

xxx=xxx+1
endwhile
***************************8
iscen=iscen+1
endwhile
****************************************
