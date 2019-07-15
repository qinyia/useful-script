

begin

;casename=(/"PIC_g16_acc_nochem_1","F1850C5_4xCO2_1"/)
casename=(/getenv("casename1"),getenv("casename2")/)

do_runave = getenv("do_runave")
run_year = toint(getenv("run_year"))
plot_type = "pdf"

do_region_mean	= getenv("do_region_mean")
time_series_subregion = getenv("time_series_subregion")
season = getenv("season")
yrs_plt = toint(getenv("yr_start_plt"))
tag = getenv("tag")

;do_region_mean		= False
;time_series_subregion	= True

; year	= 231 135 61 18
colors	= (/"black","grey","blue","dodgerblue","cyan","red","purple"/)
;thicks = (/2,2,2,4,1/)

thicks = (/2,2,2,2,2,2,2/)

ncase						=dimsizes(casename)
nlat						= 96
nlon						= 144

staryear = (/toint(getenv("int_year1")),toint(getenv("int_year2"))/) ;"0001"
endyear = (/toint(getenv("end_year1")),toint(getenv("end_year2"))/) ;"0113";"0406";"0040"
nyear = endyear-staryear+1 ;113; 406 ; 40 ; 151

printVarSummary(staryear)
print(staryear)
print(endyear)


;	      		0     1      2       3        4         5        6        7        8        9         10       11	12       13       14       15      16        17         18         19
varsA		= (/"TREFHT","FLNT","FSNT","RESTOM","RESSURF","RESDIFF","CLDLOW","CLDHGH","CLDTOT","TGCLDLWP","PRECT","CDNUMC","FSNS", "FLNS", "LHFLX", "SHFLX","ICEFRAC","TGCLDIWP","ALBEDOC","ALBEDO"/)
varsA_units	= (/"degC", "W/m2", "W/m2", "W/m2", "W/m2", "W/m2", "fraction", "fraction", "fraction", "g/m2", "mm/day","","W/m2", "W/m2", "W/m2", "W/m2", "fraction","g/m2","dimensionless","dimensionless"/)

;use_idx		= (/0,6,7,8,9,10,11/)
;use_idx		= (/12,13,14,15,4,16/)
;use_idx		= (/0,1,2,3,4,5/)
use_idx		= (/0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19/)
vars		= varsA(use_idx)
vars_units	= varsA_units(use_idx)

if(do_region_mean.eq."True")then

do icase=0,ncase-1

vars_data					= new((/dimsizes(vars),nyear(icase),nlat,nlon/),float)
printVarSummary(vars_data)


fdir 						= "/GPFS/cess1/my-diag/"+casename(icase)+"/"
; --- Get list of files from staryear to endyear
yyyy						= ispan(staryear(icase),endyear(icase),1)
;all_files					= casename(icase)+"."+sprinti("%04d",yyyy)+".ann.mean.nc"
all_files					= casename(icase)+"."+sprinti("%04d",yyyy)+"."+season+".mean.nc"

;print(all_files)

if(casename(0).eq."PIcontrol_ne30s05_v22")then
fil 						= addfiles(fdir+"/tmp/"+all_files,"r") ; file paths
else
fil 						= addfiles(fdir+all_files,"r") ; file paths
end if

printVarSummary(fil)

do ivar=0,dimsizes(vars)-1

if(isfilevar(fil[0],vars(ivar)))then
	tmp					= fil[:]->$vars(ivar)$

	if(vars(ivar).eq."CLDLOW" .or. vars(ivar).eq."CLDHGH" .or. vars(ivar).eq."CLDTOT")then
		tmp				= tmp*1e2
	end if
	if(vars(ivar).eq."TGCLDLWP" .or. vars(ivar).eq."TGCLDIWP")then
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
		delete([/FSNT_tmp,FLNT_tmp,restom_tmp/])
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
		delete([/FSNS_tmp,FLNS_tmp,LHFLX_tmp,SHFLX_tmp,QFLX_tmp,\
			PRECC_tmp,PRECL_tmp,PRECSC_tmp,PRECSL_tmp,LHFLX_new,ressuf_tmp/])
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
		delete([/FSNT_tmp,FLNT_tmp,restom_tmp,FSNS_tmp,FLNS_tmp,LHFLX_tmp,SHFLX_tmp,QFLX_tmp,\
			PRECC_tmp,PRECL_tmp,PRECSC_tmp,PRECSL_tmp,LHFLX_new,ressuf_tmp,resdiff_tmp/])

	end if
	if(vars(ivar).eq."PRECT")then
		PRECC_tmp			= fil[:]->PRECC
		PRECL_tmp			= fil[:]->PRECL
		PRECT_tmp			= PRECC_tmp+PRECL_tmp
		tmp				= (/PRECT_tmp/)
		tmp				= tmp*8.64e7
		delete([/PRECC_tmp,PRECL_tmp,PRECT_tmp/])
	end if

	if(vars(ivar).eq."ALBEDOC")then
		fsntoac				= fil[:]->FSNTOAC
		tmp1				= fil[:]->SOLIN
		solin				= tmp1
		solin 				= mask(tmp1,tmp1.gt.0.0,True)
		tmp				= solin
		tmp				= (/(solin-fsntoac)/solin/)
		delete([/fsntoac,tmp1,solin/])
	end if

	if(vars(ivar).eq."ALBEDO")then
		fsntoa				= fil[:]->FSNTOA
		tmp1				= fil[:]->SOLIN
		solin				= tmp1
		solin 				= mask(tmp1,tmp1.gt.0.0,True)
		tmp				= solin
		tmp				= (/(solin-fsntoa)/solin/)
		delete([/fsntoa,tmp1,solin/])
	end if

end if
		
print(vars(ivar)+"	"+casename(icase))

printVarSummary(tmp)	; (time, lat, lon)
if(ivar.eq.0 )then
	printVarSummary(vars_data(ivar,:,:,:))
	printVarSummary(tmp)
	vars_data(ivar,:,:,:)			 	= tmp
else
	vars_data(ivar,:,:,:)			 	= (/tmp/)
end if

delete(tmp)

end do ; do ivar=

vars_data&lat@units = "degrees_north"
vars_data&lon@units = "degrees_east"

printVarSummary(vars_data) ; (nvar,nyear,nlat,nlon)

lat	= fil[0]->lat
lon	= fil[0]->lon
rad    = 4.0*atan(1.0)/180.0
clat   = cos(lat*rad)
clat!0	= "lat"
clat&lat	= lat
lat2d		= conform_dims((/nlat,nlon/),lat,0)
lat4d		= conform_dims(dimsizes(vars_data),lat,2)
lon2d		= conform_dims((/nlat,nlon/),lon,1)
lon4d		= conform_dims(dimsizes(vars_data),lon,3)


glb_mean	= wgt_areaave(vars_data,clat,1.0,1)
trp_mean	= wgt_areaave(vars_data(:,:,{-30:30},:),clat({-30:30}),1.0, 1)

tmp_high_SH	= where(lat4d.gt.-30,vars_data@_FillValue,vars_data)
tmp_high_NH	= where(lat4d.lt.30,vars_data@_FillValue,vars_data)
copy_VarCoords(vars_data,tmp_high_SH)
copy_VarCoords(vars_data,tmp_high_NH)
hig_mean_SH	= wgt_areaave(tmp_high_SH,clat,1.0, 0)
hig_mean_NH	= wgt_areaave(tmp_high_NH,clat,1.0, 0)
delete([/tmp_high_SH,tmp_high_NH/])


;suggested by Ming Zhao (80-90N, 90-270E)
tmp_Arctic	= where(lat4d.gt.80 .and. lat4d.lt.90 .and. lon4d.gt.90 .and. lon4d.lt.270, vars_data, vars_data@_FillValue)
copy_VarCoords(vars_data,tmp_Arctic)
printVarSummary(tmp_Arctic)

;wks 		= gsn_open_wks("pdf","test")
;plot		= gsn_csm_contour_map_ce(wks,tmp_Arctic(0,0,0,:,:),False)
;exit

Arctic_mean	= wgt_areaave(tmp_Arctic,clat,1.0,0)
printVarSummary(Arctic_mean)
printMinMax(Arctic_mean,True)
delete(tmp_Arctic)


glb_mean_ano	= glb_mean-conform(glb_mean,dim_avg(glb_mean),(/0/))
trp_mean_ano	= trp_mean-conform(trp_mean,dim_avg(trp_mean),(/0/))
hig_SH_mean_ano	= hig_mean_SH-conform(hig_mean_SH,dim_avg(hig_mean_SH),(/0/))
hig_NH_mean_ano	= hig_mean_NH-conform(hig_mean_NH,dim_avg(hig_mean_NH),(/0/))
Arctic_mean_ano	= Arctic_mean-conform(Arctic_mean,dim_avg(Arctic_mean),(/0/))

glb_mean_ano1 		= glb_mean_ano
trp_mean_ano1		= trp_mean_ano
hig_SH_mean_ano1	= hig_SH_mean_ano
hig_NH_mean_ano1	= hig_NH_mean_ano
Arctic_mean_ano1	= Arctic_mean_ano

do it=0,nyear(icase)-1
	glb_mean_ano1(:,it)		= glb_mean(:,it)-glb_mean(:,0)
	trp_mean_ano1(:,it)		= trp_mean(:,it)-trp_mean(:,0)
	hig_SH_mean_ano1(:,it)	= hig_mean_SH(:,it)-hig_mean_SH(:,0)
	hig_NH_mean_ano1(:,it)	= hig_mean_NH(:,it)-hig_mean_NH(:,0)
	Arctic_mean_ano1(:,it)	= Arctic_mean(:,it)-Arctic_mean(:,0)
end do ;do it=


data		= (/glb_mean,trp_mean,hig_mean_SH, hig_mean_NH,Arctic_mean/)
data_ano	= (/glb_mean_ano,trp_mean_ano,hig_SH_mean_ano, hig_NH_mean_ano,Arctic_mean_ano/)
data_ano1	= (/glb_mean_ano1,trp_mean_ano1,hig_SH_mean_ano1, hig_NH_mean_ano1,Arctic_mean_ano1/)

delete([/lat2d,lon2d,lat4d,lon4d,glb_mean,trp_mean,hig_mean_SH,hig_mean_NH,Arctic_mean,\
	 glb_mean_ano,trp_mean_ano,hig_SH_mean_ano, hig_NH_mean_ano,Arctic_mean_ano,\
	glb_mean_ano1,trp_mean_ano1,hig_SH_mean_ano1, hig_NH_mean_ano1,Arctic_mean_ano1/])

data!0		= "region"
data&region	= ispan(1,5,1)
data!1		= "var"
data&var	= ispan(1,dimsizes(vars),1)
if(icase.eq.0)then
	data!2		= "time"
	data&time	= ispan(1,nyear(icase),1)
else
	data!2		= "time"
	data&time	= ispan(endyear(0)+1,endyear(0)+endyear(icase),1)
end if

printVarSummary(data)
copy_VarCoords(data,data_ano)
copy_VarCoords(data,data_ano1)

data_rev	= data(time|:,var|:,region|:)
data_ano_rev	= data_ano(time|:,var|:,region|:)
data_ano1_rev	= data_ano1(time|:,var|:,region|:)

;print(time+"	"+data_rev(:,2,2)+"	"+data_ano1(:,2,2))
;exit



;print(data(0,0,:))

system("rm "+fdir+casename(icase)+"time-series-subregions-"+staryear(icase)+"-"+endyear(icase)+".nc")

outfile		= addfile(fdir+casename(icase)+"time-series-subregions-"+staryear(icase)+"-"+endyear(icase)+".nc","wc")

outfile->data_rev	= data_rev
outfile->data_ano_rev	= data_ano_rev
outfile->data_ano1_rev	= data_ano1_rev


delete([/vars_data,data,data_ano,data_ano1,outfile,yyyy,all_files,data_rev,data_ano_rev,data_ano1_rev/])

end do ; do icase=

delete(fil)

end if ; do_region_mean


cases	= (/"stitch-4xCO2-"+tag/)

final_year	= toint(getenv("final_year"))
;infile = addfile("/GPFS/cess1/my-diag/stitch-4xCO2-PI/stitch-4xCO2-PIA.0001-0286-ann.nc","r")
infile = addfile("/GPFS/cess1/my-diag/stitch-4xCO2-PI/stitch-4xCO2-"+tag+".0001-"+sprinti("%04d",final_year)+"-"+season+".nc","r")


data		= infile->data_rev

time		= infile->time

printVarSummary(data)

data_rev	= data(region|:,var|:,time|:)

data_ano	= data_rev-conform(data_rev,dim_avg(data_rev),(/0,1/))

data_ano1 		= data_ano

do it=0,dimsizes(time)-1
	data_ano1(:,:,it)		= data_rev(:,:,it)-data_rev(:,:,endyear(0)-1)
end do ;do it=

copy_VarCoords(data_rev,data_ano)
copy_VarCoords(data_rev,data_ano1)
printVarSummary(data_ano1)

;print(time+"	"+data_rev(2,2,:)+"	"+data_ano1(2,2,:))



; ----------------------------------------Plotting starts here ....

; =================================== time series of areaave
; ===========================================================
if(time_series_subregion.eq."True")then
do icase=0,dimsizes(cases)-1
if(do_runave.eq."True")then
	wks 					= gsn_open_wks(plot_type,"./figure/"+cases(icase)+"-time-series-subregions-"+vars(dimsizes(vars)-1)+"_runave_"+season)
else
	wks 					= gsn_open_wks(plot_type,"./figure/"+cases(icase)+"-time-series-subregions-"+vars(dimsizes(vars)-1)+"_"+season)
end if



plot					= new(dimsizes(vars),graphic)
plot_ano				= new(dimsizes(vars),graphic)
plot_ano1				= new(dimsizes(vars),graphic)


do ivar=0,dimsizes(vars)-1
;wks 					= gsn_open_wks(plot_type,"./figure/"+casename(icase)+"-time-series-of-"+vars(ivar))

res					= True
res@gsnDraw				= False
res@gsnFrame				= False

res@gsnXRefLine				= endyear(0)

res@gsnLeftString			= cases(icase)
res@gsnRightString			= vars(ivar)
	
res@xyLineThicknessF			= 1.0
res@xyLineColors			= (/"blue","lightpink2","lightskyblue","limegreen","red"/)
res@xyDashPatterns			= (/0, 0, 0, 0, 0/)


res@tiMainString				= "Mean"
if(do_runave.eq."True")then
plot(ivar)		= gsn_csm_xy(wks,time,runave(data(region|:,var|ivar,time|:),run_year,0),res)
else
plot(ivar)		= gsn_csm_xy(wks,time(yrs_plt:),data(region|:,var|ivar,time|yrs_plt:),res)
end if

res@tiMainString				= "Anomaly relative to All-time Mean"
if(do_runave.eq."True")then
plot_ano(ivar)					= gsn_csm_xy(wks,time,runave(data_ano(region|:,var|ivar,time|:),run_year,0),res)
else
plot_ano(ivar)					= gsn_csm_xy(wks,time(yrs_plt:),data_ano(region|:,var|ivar,time|yrs_plt:),res)
end if

res@tiMainString				= "Anomaly relative to 249nd year"
if(do_runave.eq."True")then
plot_ano1(ivar)					= gsn_csm_xy(wks,time,runave(data_ano1(region|:,var|ivar,time|:),run_year,0),res)
else
plot_ano1(ivar)					= gsn_csm_xy(wks,time(yrs_plt:),data_ano1(region|:,var|ivar,time|yrs_plt:),res)
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

end
