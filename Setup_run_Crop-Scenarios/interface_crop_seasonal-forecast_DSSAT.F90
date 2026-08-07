       program read_4_DSSAT
       implicit none
       character(len=4) ::  clexper
! freq is the Forecast frequency
! freqclim is tthe CLIM frequency
       integer :: y2,  ys,yp,ye,ms,mp,me,ds,de,freq,freqclim,ndx,ndxx,im
       integer :: n0, y2y,nyx,ndxxclim,nfoundobs
       parameter(nyx=3)
! daily clim data
       parameter(freqclim=1)
       parameter(ndxx=nyx*366)
       parameter(ndxxclim=freqclim*366)
       integer d4,d4yy,ie,ir4,ntx,ntxclim,it,it2,itd,idat29
       real loclon,loclat, locelev, locav, locamp,locrefth, locwndht
       integer ilocelev,ndjf,recffin
       real undeff
!       real radf2model
       parameter(undeff=-99.)
       real rad(ndxx), tmax(ndxx), tmin(ndxx), prec(ndxx), td(ndxx)
       real radf(ndxx), tmaxf(ndxx), tminf(ndxx), precf(ndxx)
       real radf2(ndxx), tmaxf2(ndxx), tminf2(ndxx), precf2(ndxx)
       real rado(ndxx), tmaxo(ndxx), tmino(ndxx), preco(ndxx)
       real radc(ndxxclim), tmaxc(ndxxclim), tminc(ndxxclim), precc(ndxxclim)
       real wind(ndxx), par(ndxx),evap(ndxx),rh(ndxx)
       real zdummy, zdummyrad, zdummyprec
       integer idat(ndxx)
       integer djant,dfeb, dfebt,dmart,daprt,dmayt,djunt
       integer djult,daugt,dsept,doctt,dnovt,ddect
       integer dobsstart, dobsend, dclstart, dclend, dforstart,dforstartin, dforend
       integer ntforec,ntf,itf,mem, skipforec
       logical lprecROC, lcorunitsf, lcorunitso
       character cly2*5, loc*30
       namelist /namexp / clexper,  ys,ms, yp, mp, mem, &
     &                    freq,loclon,loclat,locelev,loc, lcorunitsf, lcorunitso
!

        lprecROC=.true.
! if units conversion already done in the input files
!        lcorunitsf=.true. ; lcorunitso=.true.
! aici, lcorunitso=.true. mereu.

       locav=10.9
       locamp=26.
        n0=0
        rad(:)=undeff
        tmax(:)=undeff
        tmin(:)=undeff
        prec(:)=undeff
        td(:)=undeff
        wind(:)=undeff
        par(:)=undeff
        evap(:)=undeff
        rh(:)=undeff

         locelev=undeff
         locrefth=undeff
         locwndht=undeff
!
 
        open(64,file='swrad_forec.txt',form='formatted') 
        open(65,file='tx_forec.txt',form='formatted') 
        open(66,file='tn_forec.txt',form='formatted') 
        open(67,file='precip_forec.txt',form='formatted') 

! initializare obs (pre-forecast) + climatologica (post-forecast)
!        cdir='/home_DT4/anto/DSSAT_OPER_seasonal_forecast/Date/Date_obs/2023/Fundulea'
        open(54,file='swrad_obs.txt',form='formatted') 
        open(55,file='tx_obs.txt',form='formatted') 
        open(56,file='tn_obs.txt',form='formatted') 
        open(57,file='precip_obs.txt',form='formatted') 
        
        open(74,file='swrad_clim.txt',form='formatted') 
        open(75,file='tx_clim.txt',form='formatted') 
        open(76,file='tn_clim.txt',form='formatted') 
        if(lprecROC.eqv..true.) then
         open(77,file='precip_climROC.txt',form='formatted')
        else 
         open(77,file='precip_clim.txt',form='formatted') 
        endif
 
        open(80,file='FCST.WTH',form='formatted') 

        open(4,file='namforec.txt')
        read(4,nml=namexp)

        if(freq.ne.freqclim) then
            print*,'ERROR, freq_forec and freq_clim are not equal !', freq, ' ',freqclim
            stop
        endif

        d4yy=0
        d4=(yp)/4 
        ir4=yp-yp/4*4
        y2y=(yp-yp/100*100)
        y2=(yp-yp/100*100)*1000 
         if(ir4.eq.0) then
         d4yy=1
         endif
! #####################################################
          dobsstart=0
          dobsend=0
          if(ms.eq.2) dobsend=31
          if(ms.eq.3) dobsend=31+28+d4yy
          if(ms.eq.4) dobsend=31+28+d4yy+31
          if(ms.eq.5) dobsend=31+28+d4yy+31+30
          if(ms.eq.6) dobsend=31+28+d4yy+31+30+31
          if(ms.eq.7) dobsend=31+28+d4yy+31+30+31+30
          if(ms.eq.8) dobsend=31+28+d4yy+31+30+31+30+31
           if(ys.ne.yp) then
              dobsend=0
              skipforec=0
               if(ms.eq.12) skipforec=31
               if(ms.eq.11) skipforec=31+30
               if(ms.eq.10) skipforec=31+30+31
               if(ms.eq.9)  skipforec=31+30+31+30
               if(ms.le.8) then
                print*,'ys=', ys,'yp=',yp
                print*, ' case of  initial Month of forecast before August NOT treated !'
                print*, ' runs Need to start Janury'
                stop
               endif
           endif
           print*,'ys=', ys,'yp=',yp ,'skipforec=', skipforec, 'dobsend=', dobsend
          dobsend=dobsend*freq
         

          ntx=365*freq+d4yy*freq
          dclstart=1
          dclend=ntx
           print*,'ntx=',ntx, 'dclstart=', dclstart, 'dclend=', dclend
!
! forecast end is found in the file
!!!!!!!!!!!!!!!!!!!!!!!
          dforstart=dobsend+1
          dforstartin=skipforec+1
!
         print*,'DFORstart_record_in_output_file=', dforstart,&
     &      'DFORstartin_record_in_input_file=', dforstartin

! create vector idat for FIFU
         do it=1,ntx
          idat(it)=y2+it
!          print*,'y2=', y2, 'IDAT=', idat(it)
         enddo

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!! Pre-Prelucrari: a) forecast part !!!!!!!!!!!!!!!!!!!

         do it=1,dforstartin-1
          read(64,*,end=101) zdummyrad
          print*,'ZDummyrad=', zdummyrad
          read(65,*,end=101) zdummy
          read(66,*,end=101) zdummy
          read(67,*,end=101) zdummyprec
         enddo
!  count forecasts records ALL in the forecast file
!         do it=1,ndxx
!  count forecasts records to be input in run (not all that are in the forecast file)
         do it=dforstartin,ndxx
          it2=it-dforstartin+1
          read(64,*,end=101) radf(it2)
          read(65,*,end=101) tmaxf(it2)
          read(66,*,end=101) tminf(it2)
          write(33,*) 'it2=', it2,  tminf(it2)
          read(67,*,end=101) precf(it2)
         enddo
!101      ntf=it-1
101      ntf=it2-1
! ntf este nr de recorduri
         recffin=dforstartin+ntf-1
         print*,'forecast_slices_ntf=', ntf, 'from: ', dforstartin, 'to:',recffin 
!  after counting forecasts records: arrange units if case
! but for units conversion ,ALL data in forecasts file are converted, starting with the first one.
        if(lcorunitsf.eqv..false.) then
! datele intra NECORECTATE ca unitati, tb. corectate aici
         print*,' Change UNITS !'
!         radf2(1)=radf(1)*1.e-6
         radf2(1)=(radf(1)-zdummyrad)*1.e-6
!         precf2(1)=precf(1)*1000. 
         precf2(1)=(precf(1)-zdummyprec)*1000. 
              if(precf2(1).le.0.) precf2(1)=0.0000001
         tmaxf2(1)=tmaxf(1)-273.15
         tminf2(1)=tminf(1)-273.15
! in radf am stocat shiftate cu dforstartin
 
         do it=ntf,2,-1
! Joules to MJ (sw is daily accum. expr in (W/m**2)*s=J/m**2  )
           radf2(it)=(radf(it)-radf(it-1))*1.e-6
              if(radf2(it).le.0.) radf2(it)=0.1
!           radf2model=(radf(it)-radf(it-1))*1.e-6
! DSSAT does not accepts swrad<1.
!           radf2(it)=max(1.5,radf2model)
! corectat mai jos, inainte de scriere
! precipt from m to mm
           precf2(it)=(precf(it)-precf(it-1))*1000.
              if(precf2(it).le.0.) precf2(it)=0.0000001
           tmaxf2(it)=tmaxf(it)-273.15
           tminf2(it)=tminf(it)-273.15
          write(34,*) 'it=', it,  tminf(it)
! DSSAT does not accepts tmax=tmin !
!           if(tmaxf2(it).eq.tminf2(it)) tmaxf2(it)=tmaxf2(it)+1. 
! corectat mai jos, inainte de scriere
         enddo
        else
! NO units adjustment:  maintain main checking only:
         do it=1,ntf
          radf2(it)=radf(it)
          tmaxf2(it)=tmaxf(it)
          tminf2(it)=tminf(it)
          precf2(it)=precf(it)
           if(precf(it).le.0.) precf(it)=0.0000001
! DSSAT does not accepts tmax=tmin !
           if(tmaxf(it).eq.tminf(it)) tmaxf(it)=tmaxf(it)+1. 
! DSSAT does not accepts swrad<1.
           if(radf(it).le.0.) radf(it)=1.5
         enddo       
        endif
! test:
!          do it=1,ntf
!           write(20,*)  radf2(it)
!           write(21,*)  tmaxf2(it)
!          enddo

!!!! Pre-Prelucrari: b) OBS part !!!!!!!!!!!!!!!!!!!
! la OBS / ERA5 presupunem ca datele sunt corectate in scriptul de Preparare !!
         do it=1,dobsend
          read(54,*,end=102) rado(it)
!          print*,'RAD=', rado(it)
          read(55,*,end=102) tmaxo(it)
          read(56,*,end=102) tmino(it)
          read(57,*,end=102) preco(it)
         enddo
  
102    continue
         nfoundobs=it-1
         if(nfoundobs.lt.dobsend) then
             print*,'ERROR NOT enough OBS data: found, needed:', nfoundobs, dobsend
         endif
             print*, 'OBS data: found, required:', nfoundobs, dobsend
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         write(80,'(a31)') '*WEATHER DATA : Grid cell 00001'
         write(80,'(a22)') '                      '
!
         write(80,'(a5,6x,a3,8x,a4,4x,a4,2x,a3,5x,a3,3x,a5,3x,a5)') &
     &  '@INSI','LAT','LONG','ELEV','TAV','AMP'

         write(80,&
     &'(2x,a4,2x,f9.3,2x,f9.3,2x,i4,2x,f5.1,2x,f5.1,2x,f5.1,2x,f5.1)') &
     &             clexper, loclat, loclon, int(locelev), locav, locamp,&
     &   locrefth, locwndht

!           write(33,'(f5.1)') locav
!           print*,'locav=',locav

         write(80,'(a5,2x,a4,2x,a4,2x,a4,2x,a4)') &
     &  '@DATE', 'SRAD','TMAX', 'TMIN','RAIN'
  
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! default: fill in with Clim data as for a 366 days year : 
          read(74,*) radc
          read(75,*) tmaxc
          read(76,*) tminc
          if(lprecROC.eqv..true.) then
           do it=1,ndxxclim
            read(77,*) precc(it)
           enddo
          else
           read(77,*) precc
          endif
! shift back clim data for non-bisect years: if (d4yy.eq.0) then
          ndjf=31+28+d4yy
          if(d4yy.eq.0) then
           do it=1,ndjf
            rad(it)=radc(it)
            tmax(it)=tmaxc(it)
            tmin(it)=tminc(it)
            prec(it)=precc(it)
           enddo
! skip the 29 FEb that is present in Clim data only for bisect years  (shift + 1dy after)
           do it=ndjf+1,ntx
            rad(it)=radc(it+1)
            tmax(it)=tmaxc(it+1)
            tmin(it)=tminc(it+1)
            prec(it)=precc(it+1)
           enddo
          else
           do it=1,ntx
            rad(it)=radc(it)
            tmax(it)=tmaxc(it)
            tmin(it)=tminc(it)
            prec(it)=precc(it)
           enddo
          endif

! overwrite with Obs data:  
         do it=1,dobsend
           rad(it)=rado(it)
           tmax(it)=tmaxo(it)
           tmin(it)=tmino(it)
           prec(it)=preco(it)
         enddo
! overwrite with Forecast data:  
         do it=1,ntf
          itf=dforstart+it-1 
           rad(itf)=radf2(it)
           tmax(itf)=tmaxf2(it)
           tmin(itf)=tminf2(it)
           prec(itf)=precf2(it)
         enddo

100      continue
         print*,'it=', it,'ntf=', ntf, 'itf=', itf
         ntforec=it-1
         dforend=itf 
         print*,'ntforec=', ntforec, 'dforend=', dforend
!!!!! overall correction, including obs and clim !!!!!!!!!!!
         do it=1,ntx
           rad(it)=max(1.,rad(it))
           if(tmax(it).eq.tmin(it)) tmax(it)=tmax(it)+1. 
         enddo
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         itd=0
         do it=1,ntx
          itd=itd+1
         if(y2y.ge.10) then
         write(80,'(I5,1x,f5.1,1x,f5.1,1x,f5.1,1x,f5.1)') &
     &     idat(itd),rad(it),tmax(it),tmin(it),prec(it)
         else
         write(80,'(I1,I4,1x,f5.1,1x,f5.1,1x,f5.1,1x,f5.1)') &
     &     n0,idat(itd),rad(it),tmax(it),tmin(it),prec(it)

         endif 
         enddo
         stop
         end
