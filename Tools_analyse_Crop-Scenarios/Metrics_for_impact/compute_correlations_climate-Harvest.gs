*
'sdfopen ENS_30y_tx_mm.nc'
'sdfopen ENS_30y_tn_mm.nc'
'sdfopen ENS_30y_sr_mm.nc'
'sdfopen ENS_30y_pp_mm.nc'
'sdfopen ENS_30y_ppc_mm.nc'
*'sdfopen Nao_mm_12mth_merged.nc_frame'

*xx=x1
*xx=x2
*xx=x3
*xx=x4

xxx=9
*xxx=10
*xxx=11
*xxx=12

*while (xxx<=12)
*xx=x2
*xx=x3
*xx=x4

'sdfopen harv_t1_x'xxx'.nc_frame'
*'sdfopen UTR/harv_t1_x'xxx'.nc_frame_utr'


'set gxout fwrite'
*'set fwrite mthly_corr_5vars-Harw.dat'
*'set fwrite mthly_corr_5vars-Harw_'xx'_date1_utr.dat'

*'set fwrite mthly_corr_6vars-Harw_'xx'_utr.dat'

*'set fwrite mthly_corr_6vars-Harw_x'xxx'_utr.dat'
'set fwrite mthly_corr_6vars-Harw_x'xxx'.dat'

'set t 1'
im=1
while(im<=12)
'd tcorr(d'im'.1(t+0),d1.7(t+0),t=1,t=30)'
'd tcorr(d'im'.2(t+0),d1.7(t+0),t=1,t=30)'
'd tcorr(d'im'.3(t+0),d1.7(t+0),t=1,t=30)'
'd tcorr(d'im'.4(t+0),d1.7(t+0),t=1,t=30)'
'd tcorr(d'im'.5(t+0),d1.7(t+0),t=1,t=30)'
'd tcorr(d'im'.6(t+0),d1.7(t+0),t=1,t=30)'
im=im+1
endwhile
*xxx=xxx+1
*endwhile
****************************************
