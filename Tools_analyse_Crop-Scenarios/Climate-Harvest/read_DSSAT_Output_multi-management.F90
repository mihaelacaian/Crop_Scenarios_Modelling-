               program read_output_dssat
               implicit none
               character*1 zdummy
               character*80 cfld
               character*80 cunits
               integer ntreatx,nvarx
               integer ys,ye,yxx
               parameter(nvarx=12,ntreatx=12, yxx=100)
               real vout(ntreatx,nvarx,yxx)
               integer i,j,ntr,nexp,mrec,ibyte
               integer it, nt, isk, nskip
               parameter(nskip=21)
               parameter(ibyte=4)
               character*2 ccrop
               character*20 cc

                
               open(66,file='o1_ally.txt',&
     &           form='formatted')
               open(67,file='o1_ally.dat',&
     &  access='direct',form='unformatted',recl=ibyte*ntreatx*nvarx)

                open(4,file='nam_info',form='formatted')
                   read(4,*) ys  
                   read(4,*) ye  
                close(4)
                nt=ye-ys+1
                 print*,'ys,ye,nt=', ys,ye,nt


                 do it=1,nt
                   print*,'read year=', ys+it-1

!                 do isk=1,nskip
!                    read(66,*) cc
!                 enddo
                 read(66,*) cfld
                 read(66,*) cunits
              do j=1,ntreatx
                 read(66,*) ntr,ccrop,nexp, (vout(j,i,it),i=1,nvarx)
                  if(vout(j,1,it).eq.-99) then
                    do i=1,nvarx
                      vout(j,i,it)=-99.
                    enddo
                   endif 
!                 if(it.eq.3) then
!                  print*,ntr,ccrop,nexp,(vout(j,i,it),i=1,nvarx)
!                 endif
              enddo
              print*,'Done, ntreat_fin=',j-1, 'year=', ys+it-1
! end years loop              
                 enddo

              mrec=0
              do it=1,nt
               mrec=mrec+1 
               write(67,rec=mrec) ((vout(j,i,it),j=1,ntreatx),i=1,nvarx)
              enddo

              stop
              end

!cc 
