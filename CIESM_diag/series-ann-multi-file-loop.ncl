

begin

;casename = (/"PIcontrol_cesm_x86","PIcontrol_ciesm_x86"/)

;casename = (/"PIcontrol_cesm_x86","PIcontrol_ciesm_x86","PIcontrol_ne30s05_v1","PIcontrol_ne30s05_v3","PIcontrol_ne30s05_v4","CMIP.pop2_cam_acc","CMIP.slave"/)
;casename = (/"PIcontrol_cesm_x86","PIcontrol_ciesm_x86","PIcontrol_ne30s05_v1","PIcontrol_ne30s05_v3","PIcontrol_ne30s05_v4","PIcontrol_ne30s05_mq_v1"/)
;casename = (/"PIcontrol_cesm_x86","PIcontrol_ciesm_x86","PIcontrol_ne30s05_v1","PIcontrol_ne30s05_mq_v1","PIcontrol_ne30s05_v3_1.5cdnc"/)
;casename = (/"PIcontrol_cesm_x86","PIcontrol_ciesm_x86","PIcontrol_ne30s05_v3","PIcontrol_ne30s05_v3_nomq","PIcontrol_ne30s05_v4_nomq"/)
;casename = (/"PIcontrol_cesm_x86","PIcontrol_ciesm_x86","PIcontrol_ne30s05_v4_nomq","PIcontrol_ne30s05_v6"/)
;casename = (/"PIcontrol_cesm_x86","PIcontrol_ciesm_x86","PIcontrol_ne30s05_v4_nomq","zjs_B1850_ne30_6mods_5400"/)
;casename = (/"PIcontrol_ne30s05_v3_1.5cdnc","PIcontrol_ne30s05_v3_1.5cdnc_enso2"/)
;casename = (/"PIcontrol_ne30s05_v3_nomq","PIcontrol_ne30s05_v4_nomq","PIcontrol_ne30s05_v8","PIcontrol_ne30s05_v9","PIcontrol_ne30s05_v10"/)
;casename = (/"PIcontrol_ne30s05_v3_nomq","PIcontrol_ne30s05_v9"/)
;casename = (/"PIcontrol_ne30s05_v9","PIcontrol_ne30s05_v11","PIcontrol_ne30s05_v12","PIcontrol_ne30s05_v13","PIcontrol_ne30s05_v14"/)
;casename = (/"PIcontrol_ne30s05_v11","PIcontrol_ne30s05_v13"/)
;casename = (/"PIcontrol_ne30s05_v9","PIcontrol_ne30s05_v11","PIcontrol_ne30s05_v13"/)
;casename = (/"CMIP.pop2_cam_acc"/)
;casename = (/"PIcontrol_ne30s05_v11","PIcontrol_ne30s05_v15"/)
;casename = (/"PIcontrol_ne30s05_v11","PIcontrol_ne30s05_v15","PIcontrol_ne30s05_v16"/)
;casename = (/"PIcontrol_ne30s05_v16"/)
;casename = (/"PIcontrol_ne30s05_v11","PIcontrol_ne30s05_v15","PIcontrol_ne30s05_v16","PIcontrol_ne30s05_v17","PIcontrol_ne30s05_v18","PIcontrol_ne30s05_v19"/)
;casename = (/"PIcontrol_ne30s05_v18"/)
;casename = (/"PIcontrol_ne30s05_v11"/)
;casename = (/"PIcontrol_ne30s05_v11","PIcontrol_ne30s05_v18"/)
;casename=(/"PIcontrol_ne30s05_v11", "PIcontrol_ne30s05_v18","PIC_s05_acc_nochem_1"/)
;casename=(/"PIcontrol_ne30s05_v11", "PIcontrol_ne30s05_v18","PIC_s05_acc_nochem_2"/)
;casename=(/"PIcontrol_ne30s05_v11", "PIcontrol_ne30s05_v18","PIC_s05_acc_nochem_1","PIC_s05_acc_nochem_2"/)
;casename=(/"PIcontrol_ne30s05_v11", "PIcontrol_ne30s05_v22"/)
;casename=(/"B20TRC5_ne30s05_v1"/)
;casename=(/"PIC_g16_acc_nochem_1"/)
;casename=(/"PIcontrol_ne30s05_v22"/)
;casename=(/"PIC_g16_4xCO2_1","PIC_g16_4xCO2_rad_1"/)
;casename=(/"F1850C5_4xCO2_1"/)
;casename=(/"PIC_g16_4xCO2_no_macro"/)

casename=(/"B20TRC5_g16_acc_nochem_1","B20TRC5_g16_acc_nochem_2"/)

startyear=1850 ;700 ;1850
endyear=2010 ;720 ; 1927
xlabelspacing=50

colors	= (/"black","grey","blue","dodgerblue","cyan","red","purple"/)

;thicks = (/2,2,2,2,2,2,2/)
;thicks = (/1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5/)
thicks = (/1, 1, 1, 1, 1, 1, 1/)

ncase						= dimsizes(casename)
print(ncase)

nyear = endyear-startyear+1
print(nyear)

;	      0     1      2       3        4         5        6        7        8        9         10       11          12      13
vars	= (/"TREFHT","FLNT","FSNT","RESTOM","RESSURF","RESDIFF","CLDLOW","CLDHGH","CLDTOT","TGCLDLWP","PRECT","CDNUMC","FLNS","FSNS"/)
;vars	= (/"TREFHT","FLNT","FSNT","RESTOM","RESSURF","RESDIFF","CLDLOW","CLDHGH","CLDTOT","TGCLDLWP","PRECT"/)

;vars	= (/"CLDLOW","CLDHGH","CLDTOT","TGCLDLWP"/)

vars_data					= new((/dimsizes(vars),ncase,nyear/),float)
printVarSummary(vars_data)

do ivar=0,dimsizes(vars)-1

do icase=0,ncase-1

fdir 						= "/GPFS/cess1/my-diag/"+casename(icase)+"/"

yearS=sprinti("%04d",startyear)
yearE=sprinti("%04d",endyear)

fnam 						= casename(icase)+"."+yearS+"-"+yearE+".glob.avg.ann.mean.nc"

fil 						= addfile(fdir+fnam,"r")
if(isfilevar(fil,vars(ivar)))then
	tmp					= fil->$vars(ivar)$
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
		FSNT_tmp     			= fil->FSNT
		FLNT_tmp     			= fil->FLNT
		restom_tmp 			= FSNT_tmp-FLNT_tmp
		tmp			 	= (/restom_tmp/)
		delete([/FSNT_tmp,FLNT_tmp,restom_tmp/])
	end if
	if(vars(ivar).eq."RESSURF")then
		FSNS_tmp     			= fil->FSNS
		FLNS_tmp     			= fil->FLNS
		LHFLX_tmp    			= fil->LHFLX
		SHFLX_tmp    			= fil->SHFLX
		 QFLX_tmp    			= fil->QFLX
		PRECC_tmp    			= fil->PRECC
		PRECL_tmp    			= fil->PRECL
		PRECSC_tmp   			= fil->PRECSC
		PRECSL_tmp   			= fil->PRECSL
		Lv 				= 2.501e6                   ; J/kg
		Lf 				= 3.337e5                   ; J/kg
		LHFLX_new 			= (/(Lv+Lf)*QFLX_tmp - Lf*1.e3*(PRECC_tmp+PRECL_tmp-PRECSC_tmp-PRECSL_tmp)/)
		ressuf_tmp 			= FSNS_tmp-FLNS_tmp-LHFLX_new-SHFLX_tmp
		tmp				= (/ressuf_tmp/)
		delete([/FSNS_tmp,FLNS_tmp,LHFLX_tmp,SHFLX_tmp,QFLX_tmp,PRECC_tmp,PRECSC_tmp,PRECL_tmp,PRECSL_tmp,LHFLX_new,ressuf_tmp/])
	end if
	if(vars(ivar).eq."RESDIFF")then
		FSNT_tmp     			= fil->FSNT
		FLNT_tmp     			= fil->FLNT
		restom_tmp 			= FSNT_tmp-FLNT_tmp

		FSNS_tmp     			= fil->FSNS
		FLNS_tmp     			= fil->FLNS
		LHFLX_tmp    			= fil->LHFLX
		SHFLX_tmp    			= fil->SHFLX
		 QFLX_tmp    			= fil->QFLX
		PRECC_tmp    			= fil->PRECC
		PRECL_tmp    			= fil->PRECL
		PRECSC_tmp   			= fil->PRECSC
		PRECSL_tmp   			= fil->PRECSL
		Lv 				= 2.501e6                   ; J/kg
		Lf 				= 3.337e5                   ; J/kg
		LHFLX_new 			= (/(Lv+Lf)*QFLX_tmp - Lf*1.e3*(PRECC_tmp+PRECL_tmp-PRECSC_tmp-PRECSL_tmp)/)
		ressuf_tmp 			= FSNS_tmp-FLNS_tmp-LHFLX_new-SHFLX_tmp

		resdiff_tmp 			= restom_tmp-ressuf_tmp
		tmp				= (/resdiff_tmp/)
		delete([/FSNT_tmp,FLNT_tmp,restom_tmp,ressuf_tmp,FLNT_tmp,restom_tmp,FSNS_tmp,FLNS_tmp,LHFLX_tmp,SHFLX_tmp,QFLX_tmp,PRECC_tmp,PRECL_tmp,PRECSC_tmp,PRECSL_tmp,LHFLX_new,ressuf_tmp,resdiff_tmp/])
	end if
	if(vars(ivar).eq."PRECT")then
		PRECC_tmp			= fil->PRECC
		PRECL_tmp			= fil->PRECL
		PRECT_tmp			= PRECC_tmp+PRECL_tmp
		tmp				= (/PRECT_tmp/)
		tmp				= tmp*8.64e7
		delete([/PRECC_tmp,PRECL_tmp,PRECT_tmp/])
	end if

end if
		
print(vars(ivar)+"	"+casename(icase))
vars_data(ivar,icase,:)			 	= (/tmp/)
delete(tmp)

end do ; do icase=

end do ; do ivar=

printVarSummary(vars_data)

;	      0     1      2       3        4         5        6        7        8        9
;vars	= (/"TS","FLNT","FSNT","RESTOM","RESSURF","RESDIFF","CLDLOW","CLDHGH","CLDTOT","TGCLDLWP"/)

TS						= vars_data(0,:,:)
FLNT					 	= vars_data(1,:,:)
FSNT						= vars_data(2,:,:)
RESTOM						= vars_data(3,:,:)
RESSURF						= vars_data(4,:,:)
RESDIFF						= vars_data(5,:,:)

time 						= fil->time

xtime 						= fspan(1,dimsizes(time),dimsizes(time))
xtime_label					= fspan(startyear,endyear,nyear)


; 2019-05-05 17:06:28
TS!1	= "time"
TS&time	= fspan(startyear,endyear,nyear)
printVarSummary(TS)



if(casename(0).eq."B20TRC5_g16_acc_nochem_1")then
TS_ano 	= TS
do it=0,dimsizes(casename)-1
TS_ano(it,:)						= TS(it,:)-dim_avg(TS(it,{1880:1909}))
end do ; do it=
printVarSummary(TS_ano)
end if


wks = gsn_open_wks("pdf","./figure/"+casename(dimsizes(casename)-1)+"-time-series-"+yearS+"-"+yearE)

plot = new(dimsizes(vars),graphic)

res 					= True

res@gsnDraw 				= False
res@gsnFrame 				= False

res@tiYAxisFontHeightF			= 0.03
res@tmYLLabelFontHeightF		= 0.03
res@tmXBLabelFontHeightF		= 0.03

res@trXMinF				= 1.0

;res@xyLineThicknessF 			= 2.0
res@xyLineThicknesses			= thicks
res@xyLineColors 			= colors
;res@xyMarkLineMode 			= "MarkLines"
res@xyDashPattern			= 0.
res@xyMarkLineMode 			= "Lines"

;res@xyMarkers 				= (/0,1,2/)
;res@xyMarkerSizeF 			= 0.02

res@vpWidthF 				= 0.7
res@vpHeightF 				= 0.3

res@pmLegendDisplayMode 		= "Always"
res@xyExplicitLegendLabels 		= casename(:)
res@lgLabelFontHeightF			= 0.02
res@pmLegendHeightF			= 0.2
res@pmLegendWidthF			= 0.1
res@pmLegendOrthogonalPosF 		= 0.15

res@tmXBMode				= "Explicit"
res@tmXBValues				= xtime(::xlabelspacing)
res@tmXBLabels				= xtime_label(::xlabelspacing)

resd					= res

res@tiYAxisString			= vars(0)
plot(0)					= gsn_csm_xy(wks,xtime,TS,res)

if(casename(0).eq."B20TRC5_g16_acc_nochem_1")then
resd@tiYAxisString			= "TS anomaly"
resd@tiMainString			= "Global TAS anomaly (vs 1880-1909)"
plotd					= gsn_csm_xy(wks,xtime,TS_ano,resd)
draw(plotd)
frame(wks)
end if

res@trYMinF				= min((/FLNT,FSNT/)) ;230.
res@trYMaxF				= max((/FLNT,FSNT/)) ;246.
res@tiYAxisString			= "FLNT&FSNT"
plot(1)				 	= gsn_csm_xy(wks,xtime,FSNT,res)
res@pmLegendDisplayMode                 = "Never"
res@xyDashPattern 			= 16
plot1					= gsn_csm_xy(wks,xtime,FLNT,res)
overlay(plot(1),plot1)
delete(res@trYMinF)
delete(res@trYMaxF)


res@pmLegendDisplayMode                 = "Always"
res@tiYAxisString 			= "RESTOM"
res@xyDashPattern 			= 0
res@gsnLeftString			= "Min="+min(RESTOM)+", Max="+max(RESTOM)
plot(2) 				= gsn_csm_xy(wks,xtime,RESTOM,res)
res@pmLegendDisplayMode                 = "Never"
res@xyDashPattern			= 16
plot2 					= gsn_csm_xy(wks,xtime,RESSURF,res)
overlay(plot(2),plot2)
delete(res@gsnLeftString)


res@pmLegendDisplayMode                 = "Always"
res@xyDashPattern			= 0

do ivar=6,dimsizes(vars)-1
	if(vars(ivar).eq."CDNUMC")then
	res@tiYAxisString		= "CDNUMC (1e6/cm^2)"
	else
	res@tiYAxisString		= vars(ivar)
	end if
	plot(ivar-3)		 	= gsn_csm_xy(wks,xtime,vars_data(ivar,:,:),res)
end do


resP					= True
;resP@gsnPanelMainString		= casename
resP@gsnPanelYWhiteSpacePercent 	= 5.0
resP@gsnPanelXWhiteSpacePercent 	= 5.0

gsn_panel(wks,plot,(/4,dimsizes(vars)/4+1/),resP)

delete([/vars_data,res,resP,wks,plot/])
delete([/TS,FLNT,FSNT,RESTOM,RESSURF,RESDIFF,time,xtime,xtime_label/])


end
