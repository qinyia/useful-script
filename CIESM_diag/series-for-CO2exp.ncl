

begin

casename = new((/1,2/),string)

casename(0,:)=(/\
           (/"PIC_g16_1pctCO2_1"/),\
;	   (/"PIC_g16_acc_nochem_1"/),\
;	   (/"PIC_g16_acc_nochem_2"/),\
;	   (/"B20TRC5_g16_acc_nochem_1"/),\
           (/"PIC_g16_4xCO2_1"/)\
	 /)
printVarSummary(casename)

dims	= dimsizes(casename)
print(dims)

startyear=(/\
	    1,\
;	    1,\
;	    101,\
;            1850,\
            1\
          /)
endyear=(/\
          113,\
;          237,\
;          217,\
;          1980,\
          40\
        /)
xlabelspacing=(/\
                10,\
;                30,\
;                20,\
;                20,\
;                20,\
                10\
              /)

; year	= 231 135 61 18
colors	= (/"black","grey","blue","dodgerblue","cyan","red","purple"/)
;thicks = (/2,2,2,4,1/)

thicks = (/2,2,2,2,2,2,2/)

ncase						= dims(0)
print(ncase)

do igroup=0,dims(1)-1
;do igroup=0,0

nyear = endyear(igroup)-startyear(igroup)+1
print(startyear(igroup)+"	"+endyear(igroup))
print(nyear)

;	      0     1      2       3        4         5        6        7        8        9         10       11
vars	= (/"TREFHT","FLNT","FSNT","RESTOM","RESSURF","RESDIFF","CLDLOW","CLDHGH","CLDTOT","TGCLDLWP","PRECT","CDNUMC","co2vmr"/)
;vars	= (/"TREFHT","FLNT","FSNT","RESTOM","RESSURF","RESDIFF","CLDLOW","CLDHGH","CLDTOT","TGCLDLWP","PRECT"/)

;vars	= (/"CLDLOW","CLDHGH","CLDTOT","TGCLDLWP"/)

vars_data					= new((/dimsizes(vars),ncase,nyear/),float)
printVarSummary(vars_data)

do ivar=0,dimsizes(vars)-1

do icase=0,ncase-1

fdir 						= "/GPFS/cess1/my-diag/"+casename(icase,igroup)+"/"

yearS=sprinti("%04d",startyear(igroup))
yearE=sprinti("%04d",endyear(igroup))

fnam 						= casename(icase,igroup)+"."+yearS+"-"+yearE+".glob.avg.ann.mean.nc"

fil 						= addfile(fdir+fnam,"r")
if(isfilevar(fil,vars(ivar)))then
	tmp					= tofloat(fil->$vars(ivar)$)
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
		
print(vars(ivar)+"	"+casename(icase,igroup))
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
xtime_label					= fspan(startyear(igroup),endyear(igroup),nyear)


; 2019-05-05 17:06:28
TS!1	= "time"
TS&time	= fspan(startyear(igroup),endyear(igroup),nyear)
printVarSummary(TS)

if(casename(0,igroup).eq."B20TRC5_g16_acc_nochem_1")then
TS_ano						= TS-dim_avg(TS(:,{1880:1909}))
printVarSummary(TS_ano)
end if


wks = gsn_open_wks("pdf","./figure/"+casename(dims(0)-1,igroup)+"-time-series-"+yearS+"-"+yearE)

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
res@xyExplicitLegendLabels 		= casename(:,igroup)
res@lgLabelFontHeightF			= 0.02
res@pmLegendHeightF			= 0.2
res@pmLegendWidthF			= 0.1
res@pmLegendOrthogonalPosF 		= 0.15

res@tmXBMode				= "Explicit"
res@tmXBValues				= xtime(::xlabelspacing(igroup))
res@tmXBLabels				= xtime_label(::xlabelspacing(igroup))

resd					= res

res@tiYAxisString			= vars(0)
plot(0)					= gsn_csm_xy(wks,xtime,TS,res)

if(casename(0,igroup).eq."B20TRC5_g16_acc_nochem_1")then
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
plot(2) 				= gsn_csm_xy(wks,xtime,RESTOM,res)
res@pmLegendDisplayMode                 = "Never"
res@xyDashPattern			= 16
plot2 					= gsn_csm_xy(wks,xtime,RESSURF,res)
overlay(plot(2),plot2)


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

gsn_panel(wks,plot,(/5,3/),resP)

delete([/vars_data,res,resP,wks,plot/])
delete([/TS,FLNT,FSNT,RESTOM,RESSURF,RESDIFF,time,xtime,xtime_label/])

end do ; do igroup=

end
