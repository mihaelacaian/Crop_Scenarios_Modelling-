              program read_SCEN_files
!
              integer ys,ye,nt,ibyte, nmodelx,nmodel
              integer ndx,iy,yy,id,i,ntfin
              parameter(ys=2021,ye=2050,nt=ye-ys+1,ndx=366,ibyte=4)
              parameter (nmodelx=8)
              character*4 cy(nt)
              character*5 cscen
              character*2 cscenin
              parameter(cscen='RCP45',cscenin='45')
!              parameter(cscen='RCP85',cscenin='85')
!cmc              character*17 cfain
              character*28 cfain
              character*80 cdummy
              integer ncod(nt,ndx), ncod2
              real sr(nt,ndx),tx(nt,ndx),tn(nt,ndx),pp(nt,ndx)
              character*5 cout(nmodelx)
! CNRCL  CNRCE  CNRRA  ICHEC  ICHRA  MPIRC  NCCHI  NCCRE
             
!!!!!!!!!!! doare primele 3 modele au nevoie de corectie in 2000 !!!!!!!

              data  cout / 'CNRCL' , 'CNRCE' , 'CNRRA' , 'ICHEC', &
     &     'ICHRA' , 'MPIRC' ,'NCCHI' , 'NCCRE'/ 
              data cy / &
     &  '2021','2022','2023','2024','2025','2026','2027','2028','2029',&
!bug     &  '2030','2031','2022','2033','2034','2035','2036','2037','2038',&
     &  '2030','2031','2032','2033','2034','2035','2036','2037','2038',&
     &  '2039','2040','2041','2042','2043','2044','2045','2046','2047',&
     &  '2048','2049','2050'/
        
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
               cfain='WTH_'//cscenin//'/'//cout(nmodel)//'/'//cscen//&
     &cy(iy)//'01.WTH'
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
               if(yy.eq.3000) then
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
           open(67,file='BIN1/'//cout(nmodel)//'/'//cscen//&
     &'_30y_sr_corr.dat',form='unformatted',&
     &  access='direct',recl=ndx*ibyte)
              print*,'output in',&
     &         'BIN1/'//cout(nmodel)//'/'//cscen//'_30y_sr_corr.dat'
           open(68,file='BIN1/'//cout(nmodel)//'/'//cscen//&
     &'_30y_tx_corr.dat',form='unformatted',&
     & access='direct',recl=ndx*ibyte)
           open(69,file='BIN1/'//cout(nmodel)//'/'//cscen//&
     &'_30y_tn_corr.dat',form='unformatted',&
     & access='direct',recl=ndx*ibyte)
           open(70,file='BIN1/'//cout(nmodel)//'/'//cscen//&
     &'_30y_pp_corr.dat',form='unformatted',&
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

            
