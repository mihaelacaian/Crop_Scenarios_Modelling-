#!/bin/sh
# compute_correlations_Climtate-Crop_in_scenarios (eof1)
# make binary correlations file (eof2)
# ensemble corelations (eof3)
###########################
cat << eof1 > compute_correlations_Climtate-Crop_in_scenarios.gs
 
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
eof1

##########################
cat << eof2 >  make binary correltion file.F90 

              program read_HIST_files
!
              integer ys,ye,nt,ibyte, nmodelx,nmodel
              integer ndx,iy,yy,id,i,ntfin
              parameter(ys=1976,ye=2005,nt=ye-ys+1,ndx=366,ibyte=4)
              parameter (nmodelx=8)
              character*4 cy(nt)
!cmc              character*17 cfain
              character*26 cfain
              character*80 cdummy
              integer ncod(nt,ndx), ncod2
              real sr(nt,ndx),tx(nt,ndx),tn(nt,ndx),pp(nt,ndx)
              character*5 cout(nmodelx)
! CNRCL  CNRCE  CNRRA  ICHEC  ICHRA  MPIRC  NCCHI  NCCRE
             

              data  cout / 'CNRCL' , 'CNRCE' , 'CNRRA' , 'ICHEC', &
     &     'ICHRA' , 'MPIRC' ,'NCCHI' , 'NCCRE'/ 
              data cy / &
     &  '1976','1977','1978','1979','1980','1981','1982','1983','1984',&
     &  '1985','1986','1987','1988','1989','1990','1991','1992','1993',&
     &  '1994','1995','1996','1997','1998','1999','2000','2001','2002',&
     &  '2003','2004','2005'/
        
             do nmodel=1,nmodelx
 
              do iy=1,nt
              do id=1,ndx
                  ncod(iy,id)=-99
                  sr(iy,id)=-99
                  tx(iy,id)=-99
                  tn(iy,id)=-99
                  pp(iy,id)=-99
              enddo 
              enddo 
               
              iy=0 
              do yy=ys,ye
              iy=iy+1 
               cfain='WTH_H/'//cout(nmodel)//'/HIST'//cy(iy)//'01.WTH'
!              cfain='WTH_H/ICHEC-EC-EARTH-SMHI-RCA4/HIST'//cy(iy)//'01.WTH'
              print*,'cfain=', cfain
              open(66,file=cfain,form='formatted')
              read(66,*) cdummy
                 print*,cdummy
              read(66,*) cdummy
                 print*,cdummy
              read(66,*) cdummy
                 print*,cdummy
              read(66,*) cdummy
                 print*,cdummy
              do i=1,ndx
               if(yy.eq.2000) then
                read(66,*,end=100) &
     &           ncod(iy,i), ncod2, sr(iy,i),tx(iy,i),tn(iy,i),pp(iy,i)
                 write(34,*)  yy,sr(iy,i),tx(iy,i),tn(iy,i),pp(iy,i)
               else
                read(66,*,end=100) &
     &           ncod(iy,i), sr(iy,i),tx(iy,i),tn(iy,i),pp(iy,i)
               endif
              enddo
  100         ntfin=i-1
              print*,'ntfin=', ntfin, 'year=',yy
              close(66)
              continue
              enddo
!              
           open(67,file='BIN1/'//cout(nmodel)//'/HIST_30y_sr_corr.dat',form='unformatted',&
     &  access='direct',recl=ndx*ibyte)
              print*,'output in', 'BIN1/'//cout(nmodel)//'/HIST_30y_sr_corr.dat'
           open(68,file='BIN1/'//cout(nmodel)//'/HIST_30y_tx_corr.dat',form='unformatted',&
     & access='direct',recl=ndx*ibyte)
           open(69,file='BIN1/'//cout(nmodel)//'/HIST_30y_tn_corr.dat',form='unformatted',&
     & access='direct',recl=ndx*ibyte)
           open(70,file='BIN1/'//cout(nmodel)//'/HIST_30y_pp_corr.dat',form='unformatted',&
     & access='direct',recl=ndx*ibyte)
              mrec=0
              do iy=1,nt
               mrec=mrec+1
               write(67,rec=mrec) (sr(iy,id),id=1,ndx)
               write(68,rec=mrec) (tx(iy,id),id=1,ndx)
               write(69,rec=mrec) (tn(iy,id),id=1,ndx)
               write(70,rec=mrec) (pp(iy,id),id=1,ndx)
              enddo
               print*,'mrec_fin=', mrec
!
              close(67)
              close(68)
              close(69)
              close(70)
!
              enddo
              stop
              end

            

eof2
#############################################

cat << eof3 >  ENS_correlations.gs

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
eof2
#########################
cat << eof2 >  make binary correls file 

              program read_HIST_files
!
              integer ys,ye,nt,ibyte, nmodelx,nmodel
              integer ndx,iy,yy,id,i,ntfin
              parameter(ys=1976,ye=2005,nt=ye-ys+1,ndx=366,ibyte=4)
              parameter (nmodelx=8)
              character*4 cy(nt)
!cmc              character*17 cfain
              character*26 cfain
              character*80 cdummy
              integer ncod(nt,ndx), ncod2
              real sr(nt,ndx),tx(nt,ndx),tn(nt,ndx),pp(nt,ndx)
              character*5 cout(nmodelx)
! CNRCL  CNRCE  CNRRA  ICHEC  ICHRA  MPIRC  NCCHI  NCCRE
             

              data  cout / 'CNRCL' , 'CNRCE' , 'CNRRA' , 'ICHEC', &
     &     'ICHRA' , 'MPIRC' ,'NCCHI' , 'NCCRE'/ 
              data cy / &
     &  '1976','1977','1978','1979','1980','1981','1982','1983','1984',&
     &  '1985','1986','1987','1988','1989','1990','1991','1992','1993',&
     &  '1994','1995','1996','1997','1998','1999','2000','2001','2002',&
     &  '2003','2004','2005'/
        
             do nmodel=1,nmodelx
 
              do iy=1,nt
              do id=1,ndx
                  ncod(iy,id)=-99
                  sr(iy,id)=-99
                  tx(iy,id)=-99
                  tn(iy,id)=-99
                  pp(iy,id)=-99
              enddo 
              enddo 
               
              iy=0 
              do yy=ys,ye
              iy=iy+1 
               cfain='WTH_H/'//cout(nmodel)//'/HIST'//cy(iy)//'01.WTH'
!              cfain='WTH_H/ICHEC-EC-EARTH-SMHI-RCA4/HIST'//cy(iy)//'01.WTH'
              print*,'cfain=', cfain
              open(66,file=cfain,form='formatted')
              read(66,*) cdummy
                 print*,cdummy
              read(66,*) cdummy
                 print*,cdummy
              read(66,*) cdummy
                 print*,cdummy
              read(66,*) cdummy
                 print*,cdummy
              do i=1,ndx
               if(yy.eq.2000) then
                read(66,*,end=100) &
     &           ncod(iy,i), ncod2, sr(iy,i),tx(iy,i),tn(iy,i),pp(iy,i)
                 write(34,*)  yy,sr(iy,i),tx(iy,i),tn(iy,i),pp(iy,i)
               else
                read(66,*,end=100) &
     &           ncod(iy,i), sr(iy,i),tx(iy,i),tn(iy,i),pp(iy,i)
               endif
              enddo
  100         ntfin=i-1
              print*,'ntfin=', ntfin, 'year=',yy
              close(66)
              continue
              enddo
!              
           open(67,file='BIN1/'//cout(nmodel)//'/HIST_30y_sr_corr.dat',form='unformatted',&
     &  access='direct',recl=ndx*ibyte)
              print*,'output in', 'BIN1/'//cout(nmodel)//'/HIST_30y_sr_corr.dat'
           open(68,file='BIN1/'//cout(nmodel)//'/HIST_30y_tx_corr.dat',form='unformatted',&
     & access='direct',recl=ndx*ibyte)
           open(69,file='BIN1/'//cout(nmodel)//'/HIST_30y_tn_corr.dat',form='unformatted',&
     & access='direct',recl=ndx*ibyte)
           open(70,file='BIN1/'//cout(nmodel)//'/HIST_30y_pp_corr.dat',form='unformatted',&
     & access='direct',recl=ndx*ibyte)
              mrec=0
              do iy=1,nt
               mrec=mrec+1
               write(67,rec=mrec) (sr(iy,id),id=1,ndx)
               write(68,rec=mrec) (tx(iy,id),id=1,ndx)
               write(69,rec=mrec) (tn(iy,id),id=1,ndx)
               write(70,rec=mrec) (pp(iy,id),id=1,ndx)
              enddo
               print*,'mrec_fin=', mrec
!
              close(67)
              close(68)
              close(69)
              close(70)
!
              enddo
              stop
              end

            

eof3
#############################################
#############################################
