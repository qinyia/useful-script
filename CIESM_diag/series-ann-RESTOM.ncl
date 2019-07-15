

begin

;casename = (/"PIcontrol_ne30s05_v18"/)
;casename = (/"PIcontrol_ne30s05_v11"/)
casename=(/"PIC_g16_4xCO2_1"/)
;casename = (/"PIcontrol_ne30s05_v11","PIcontrol_ne30s05_v18"/)
;casename=(/"PIcontrol_ne30s05_v11", "PIcontrol_ne30s05_v18","PIC_s05_acc_nochem_1"/)
;casename=(/"PIcontrol_ne30s05_v11", "PIcontrol_ne30s05_v18","PIC_s05_acc_nochem_2"/)
;casename=(/"PIcontrol_ne30s05_v11", "PIcontrol_ne30s05_v18","PIC_s05_acc_nochem_1","PIC_s05_acc_nochem_2"/)
;casename=(/"PIC_s05_acc_nochem_4"/)
;casename=(/"PIC_g16_acc_nochem_1"/)
;casename=(/"PIC_g16_1pctCO2_1"/)
;casename=(/"PIcontrol_ne30s05_v22"/)
;casename=(/"F1850C5_4xCO2_1"/)

do_runave = False

plot_type	= "pdf"

time_series_subregion	= True
spatial_distribution	= False

; year	= 231 135 61 18
colors	= (/"black","grey","blue","dodgerblue","cyan","red","purple"/)
;thicks = (/2,2,2,4,1/)

thicks = (/2,2,2,2,2,2,2/)

ncase						=dimsizes(casename)
nlat						= 96
nlon						= 144

staryear = "0001" ;"0001"
endyear = "0040" ;"0113";"0406";"0040"
nyear = 40 ;113; 406 ; 40 ; 151

;	      		0     1      2       3        4         5        6        7        8        9         10       11	12       13       14       15      16
varsA		= (/"TREFHT","FLNT","FSNT","RESTOM","RESSURF","RESDIFF","CLDLOW","CLDHGH","CLDTOT","TGCLDLWP","PRECT","CDNUMC","FSNS", "FLNS", "LHFLX", "SHFLX","ICEFRAC"/)
varsA_units	= (/"degC", "W/m2", "W/m2", "W/m2", "W/m2", "W/m2", "fraction", "fraction", "fraction", "g/m2", "mm/day","","W/m2", "W/m2", "W/m2", "W/m2", "fraction"/)

;use_idx		= (/0,6,7,8,9,10,11/)
;use_idx		= (/12,13,14,15,4,16/)
;use_idx		= (/0,1,2,3,4,5/)
use_idx		= (/0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16/)
vars		= varsA(use_idx)
vars_units	= varsA_units(use_idx)

vars_data					= new((/dimsizes(vars),dimsizes(casename),nyear,nlat,nlon/),float)
printVarSummary(vars_data)


do icase=0,ncase-1

fdir 						= "/GPFS/cess1/my-diag/"+casename(icase)+"/"
if(casename(0).eq."PIcontrol_ne30s05_v22")then
fils 						= systemfunc ("ls "+fdir+"/tmp/*.????.ann.mean.nc") ; file paths
else
fils 						= systemfunc ("ls "+fdir+casename(icase)+".????.ann.mean.nc") ; file paths
end if

print(fils)
fil 						= addfiles(fils,"r")
ListSetType (fil, "cat")
delete(fils)
printVarSummary(fil)

do ivar=0,dimsizes(vars)-1

if(isfilevar(fil[0],vars(ivar)))then
	tmp					= fil[:]->$vars(ivar)$

	if(vars(ivar).eq."CLDLOW" .or. vars(ivar).eq."CLDHGH" .or. vars(ivar).eq."CLDTOT")then
		tmp				= tmp*1e2
	end if
	if(vars(ivar).eq."TGCLDLWP")then
		tmp			 	= tmp*1e3
	end if
	if(vars(ivar).eq."TS" .or. vars(ivar).eq."TREFHT")then
		tmp				= tmp-273.15
	end if
	if(vars(ivar).eq."CDNUMC")then
		tmp				= tmp*1e-10
	end if
else
	if(vars(ivar).eq."RESTOM")then
		FSNT_tmp     			= fil[:]->FSNT
		FLNT_tmp     			= fil[:]->FLNT
		restom_tmp 			= FSNT_tmp-FLNT_tmp
		tmp			 	= (/restom_tmp/)
		copy_VarCoords(FSNT_tmp,tmp)
	end if
	if(vars(ivar).eq."RESSURF")then
		FSNS_tmp     			= fil[:]->FSNS
		FLNS_tmp     			= fil[:]->FLNS
		LHFLX_tmp    			= fil[:]->LHFLX
		SHFLX_tmp    			= fil[:]->SHFLX
		 QFLX_tmp    			= fil[:]->QFLX
		PRECC_tmp    			= fil[:]->PRECC
		PRECL_tmp    			= fil[:]->PRECL
		PRECSC_tmp   			= fil[:]->PRECSC
		PRECSL_tmp   			= fil[:]->PRECSL
		Lv 				= 2.501e6                   ; J/kg
		Lf 				= 3.337e5                   ; J/kg
		LHFLX_new 			= (/(Lv+Lf)*QFLX_tmp - Lf*1.e3*(PRECC_tmp+PRECL_tmp-PRECSC_tmp-PRECSL_tmp)/)
		ressuf_tmp 			= FSNS_tmp-FLNS_tmp-LHFLX_new-SHFLX_tmp
		tmp				= (/ressuf_tmp/)
	end if
	if(vars(ivar).eq."RESDIFF")then
		FSNT_tmp     			= fil[:]->FSNT
		FLNT_tmp     			= fil[:]->FLNT
		restom_tmp 			= FSNT_tmp-FLNT_tmp

		FSNS_tmp     			= fil[:]->FSNS
		FLNS_tmp     			= fil[:]->FLNS
		LHFLX_tmp    			= fil[:]->LHFLX
		SHFLX_tmp    			= fil[:]->SHFLX
		 QFLX_tmp    			= fil[:]->QFLX
		PRECC_tmp    			= fil[:]->PRECC
		PRECL_tmp    			= fil[:]->PRECL
		PRECSC_tmp   			= fil[:]->PRECSC
		PRECSL_tmp   			= fil[:]->PRECSL
		Lv 				= 2.501e6                   ; J/kg
		Lf 				= 3.337e5                   ; J/kg
		LHFLX_new 			= (/(Lv+Lf)*QFLX_tmp - Lf*1.e3*(PRECC_tmp+PRECL_tmp-PRECSC_tmp-PRECSL_tmp)/)
		ressuf_tmp 			= FSNS_tmp-FLNS_tmp-LHFLX_new-SHFLX_tmp

		resdiff_tmp 			= restom_tmp-ressuf_tmp
		tmp				= (/resdiff_tmp/)
	end if
	if(vars(ivar).eq."PRECT")then
		PRECC_tmp			= fil[:]->PRECC
		PRECL_tmp			= fil[:]->PRECL
		PRECT_tmp			= PRECC_tmp+PRECL_tmp
		tmp				= (/PRECT_tmp/)
		tmp				= tmp*8.64e7
	end if

end if
		
print(vars(ivar)+"	"+casename(icase))

printVarSummary(tmp)	; (time, lat, lon)
if(ivar.eq.0 .and. icase.eq.0)then
vars_data(ivar,icase,:,:,:)			 	= tmp
else
vars_data(ivar,icase,:,:,:)			 	= (/tmp/)
end if

delete(tmp)

end do ; do ivar=

end do ; do icase=

printVarSummary(vars_data)

lat	= fil[0]->lat
lon	= fil[0]->lon
rad    = 4.0*atan(1.0)/180.0
clat   = cos(lat*rad)
clat!0	= "lat"
clat&lat	= lat
lat2d		= conform_dims((/nlat,nlon/),lat,0)
lat5d		= conform_dims(dimsizes(vars_data),lat,3)
lon2d		= conform_dims((/nlat,nlon/),lon,1)
lon5d		= conform_dims(dimsizes(vars_data),lon,4)

printVarSummary(vars_data)
vars_data&lat@units = "degrees_north"
vars_data&lon@units = "degrees_east"


glb_mean	= wgt_areaave(vars_data,clat,1.0,1)
trp_mean	= wgt_areaave(vars_data(:,:,:,{-30:30},:),clat({-30:30}),1.0, 1)

tmp_high_SH	= where(lat5d.gt.-30,vars_data@_FillValue,vars_data)
tmp_high_NH	= where(lat5d.lt.30,vars_data@_FillValue,vars_data)
copy_VarCoords(vars_data,tmp_high_SH)
copy_VarCoords(vars_data,tmp_high_NH)
hig_mean_SH	= wgt_areaave(tmp_high_SH,clat,1.0, 0)
hig_mean_NH	= wgt_areaave(tmp_high_NH,clat,1.0, 0)
delete([/tmp_high_SH,tmp_high_NH/])

;suggested by Ming Zhao (80-90N, 90-270E)
tmp_Arctic	= where(lat5d.gt.80 .and. lat5d.lt.90 .and. lon5d.gt.90 .and. lon5d.lt.270, vars_data, vars_data@_FillValue)
copy_VarCoords(vars_data,tmp_Arctic)
printVarSummary(tmp_Arctic)

;wks 		= gsn_open_wks("pdf","test")
;plot		= gsn_csm_contour_map_ce(wks,tmp_Arctic(0,0,0,:,:),False)
;exit

Arctic_mean	= wgt_areaave(tmp_Arctic,clat,1.0,0)
printVarSummary(Arctic_mean)
printMinMax(Arctic_mean,True)
delete(tmp_Arctic)

glb_mean_ano	= glb_mean-conform(glb_mean,dim_avg(glb_mean),(/0,1/))
trp_mean_ano	= trp_mean-conform(trp_mean,dim_avg(trp_mean),(/0,1/))
hig_SH_mean_ano	= hig_mean_SH-conform(hig_mean_SH,dim_avg(hig_mean_SH),(/0,1/))
hig_NH_mean_ano	= hig_mean_NH-conform(hig_mean_NH,dim_avg(hig_mean_NH),(/0,1/))
Arctic_mean_ano	= Arctic_mean-conform(Arctic_mean,dim_avg(Arctic_mean),(/0,1/))

glb_mean_ano1 		= glb_mean_ano
trp_mean_ano1		= trp_mean_ano
hig_SH_mean_ano1	= hig_SH_mean_ano
hig_NH_mean_ano1	= hig_NH_mean_ano
Arctic_mean_ano1	= Arctic_mean_ano

do it=0,nyear-1
	glb_mean_ano1(:,:,it)		= glb_mean(:,:,it)-glb_mean(:,:,0)
	trp_mean_ano1(:,:,it)		= trp_mean(:,:,it)-trp_mean(:,:,0)
	hig_SH_mean_ano1(:,:,it)	= hig_mean_SH(:,:,it)-hig_mean_SH(:,:,0)
	hig_NH_mean_ano1(:,:,it)	= hig_mean_NH(:,:,it)-hig_mean_NH(:,:,0)
	Arctic_mean_ano1(:,:,it)	= Arctic_mean(:,:,it)-Arctic_mean(:,:,0)
end do ;do it=


data		= (/glb_mean,trp_mean,hig_mean_SH, hig_mean_NH,Arctic_mean/)
data_ano	= (/glb_mean_ano,trp_mean_ano,hig_SH_mean_ano, hig_NH_mean_ano,Arctic_mean_ano/)
data_ano1	= (/glb_mean_ano1,trp_mean_ano1,hig_SH_mean_ano1, hig_NH_mean_ano1,Arctic_mean_ano1/)

delete(fil)

; ----------------------------------------Plotting starts here ....

; =================================== time series of areaave
; ===========================================================
if(time_series_subregion)then
do icase=0,dimsizes(casename)-1
if(do_runave)then
	wks 					= gsn_open_wks(plot_type,"./figure/"+casename(icase)+"-time-series-subregions-"+vars(dimsizes(vars)-1)+"_runave")
else
	wks 					= gsn_open_wks(plot_type,"./figure/"+casename(icase)+"-time-series-subregions-"+vars(dimsizes(vars)-1))
end if



plot					= new(dimsizes(vars),graphic)
plot_ano				= new(dimsizes(vars),graphic)
plot_ano1				= new(dimsizes(vars),graphic)


do ivar=0,dimsizes(vars)-1
;wks 					= gsn_open_wks(plot_type,"./figure/"+casename(icase)+"-time-series-of-"+vars(ivar))

res					= True
res@gsnDraw				= False
res@gsnFrame				= False

res@gsnLeftString			= casename(icase)
res@gsnRightString			= vars(ivar)
	
res@xyLineThicknessF			= 1.0
res@xyLineColors			= (/"blue","lightpink2","lightskyblue","limegreen","red"/)
res@xyDashPatterns			= (/0, 0, 0, 0, 0/)


res@tiMainString				= "Mean"
if(do_runave)then
plot(ivar)					= gsn_csm_xy(wks,fspan(1,nyear,nyear),runave(data(:,ivar,icase,:),20,0),res)
else
plot(ivar)					= gsn_csm_xy(wks,fspan(1,nyear,nyear),data(:,ivar,icase,:),res)
end if

res@tiMainString				= "Anomaly relative to All-time Mean"
if(do_runave)then
plot_ano(ivar)					= gsn_csm_xy(wks,fspan(1,nyear,nyear),runave(data_ano(:,ivar,icase,:),20,0),res)
else
plot_ano(ivar)					= gsn_csm_xy(wks,fspan(1,nyear,nyear),data_ano(:,ivar,icase,:),res)
end if

res@tiMainString				= "Anomaly relative to the first year"
if(do_runave)then
plot_ano1(ivar)					= gsn_csm_xy(wks,fspan(1,nyear,nyear),runave(data_ano1(:,ivar,icase,:),20,0),res)
else
plot_ano1(ivar)					= gsn_csm_xy(wks,fspan(1,nyear,nyear),data_ano1(:,ivar,icase,:),res)
end if


;draw(plot)
;frame(wks)

end do ; do ivar=

legends                         = (/"Global","Tropics","High-SH","High-NH","Arctic(80-90N, 90-270E)"/)

lgres                           = True
lgres@DashIndexes		= res@xyDashPatterns
lgres@lgLineColors		= res@xyLineColors
lgres@lgLineThicknessF 		= res@xyLineThicknessF

lgres@lgLabelFontHeightF        = 0.15
lgres@vpWidthF                  = 0.20
lgres@vpHeightF                 = 0.15
lgres@lgPerimOn                 = False

lbid1                           = gsn_create_legend(wks,dimsizes(legends),legends,lgres)
lbid2                           = gsn_create_legend(wks,dimsizes(legends),legends,lgres)
lbid3                           = gsn_create_legend(wks,dimsizes(legends),legends,lgres)

amres                           = True
amres@amJust			= "TopRight"
amres@amParallelPosF            = 0.50
amres@amOrthogonalPosF          = -0.50

annoid1                         = gsn_add_annotation(plot_ano(0),lbid1,amres)
annoid2                         = gsn_add_annotation(plot(0),lbid2,amres)
annoid3                         = gsn_add_annotation(plot_ano1(0),lbid3,amres)

resP		= True
resP@gsnPanelYWhiteSpacePercent = 5.0
resP@gsnPanelXWhiteSpacePercent = 5.0


gsn_panel(wks,plot,(/4,dimsizes(use_idx)/4+1/),resP)
gsn_panel(wks,plot_ano,(/4,dimsizes(use_idx)/4+1/),resP)
gsn_panel(wks,plot_ano1,(/4,dimsizes(use_idx)/4+1/),resP)

end do ; do icase=

delete([/wks, res, plot, plot_ano, plot_ano1/])
exit

end if ; time_series_subregion

; ============================ spatial distribution with evolving time
; ===================================================================
if(spatial_distribution)then

do icase=0,dimsizes(casename)-1
do ivar=0,dimsizes(vars)-1
do iyear=0,nyear-1

print(iyear+1)

wks = gsn_open_wks(plot_type,"./figure/"+casename(icase)+"-time-series-spatial-of-"+vars(ivar)+"-"+sprinti("%0.4i",iyear+1))

res 					= True

res@cnFillOn				= True

res@tmXTOn				= False
res@tmYROn				= False
res@mpCenterLonF			= 180.

res@gsnLeftString			= vars(ivar)
res@gsnRightString			= vars_units(ivar)
tmp_high				= where(lat2d.gt.-30 .and. lat2d.lt.30,vars_data@_FillValue,vars_data(ivar,icase,iyear,:,:))
res@gsnCenterString			= "global mean= "+sprintf("%5.2f",wgt_areaave(vars_data(ivar,icase,iyear,:,:),clat,1.0, 1))+"~C~"+ \
					  "tropical mean= "+sprintf("%5.2f",wgt_areaave(vars_data(ivar,icase,iyear,{-30:30},:),clat({-30:30}),1.0, 1))+"~C~"+ \
				          "high-lat mean= "+sprintf("%5.2f",wgt_areaave(tmp_high,clat,1.0, 0))

res@tiMainString			= sprinti("%0.4i",iyear+1)+" year"

dmin					= min(vars_data(ivar,icase,:,:,:))
dmax					= max(vars_data(ivar,icase,:,:,:))
maxlev					= 18
mnmxint					= nice_mnmxintvl( dmin, dmax, maxlev, False)

res@cnLevelSelectionMode 		= "ManualLevels"
res@cnMinLevelValF       		= mnmxint(0)
res@cnMaxLevelValF       		= mnmxint(1)
res@cnLevelSpacingF      		= mnmxint(2)



plot			= gsn_csm_contour_map_ce(wks,vars_data(ivar,icase,iyear,:,:),res)

end do ; do iyear=
end do ; do ivar=
exit

end do ; do icase=

end if ; spatial_distribution 


end
