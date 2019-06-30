

begin

;casename=(/"CMIP.slave"/)
casename					=(/"PIcontrol_ne30s05_v1","PIcontrol_ne30s05_v3",\
						   "PIcontrol_ne30s05_v4","PIcontrol_ne30s05_v5"/)

;casename					=(/"PIcontrol_ne30s05_v1","PIcontrol_ne30s05_v3"/)

ncase						=dimsizes(casename)

staryear					="0001"
endyear						="0006"
nyear						=6

TS      					= new((/dimsizes(casename),nyear/),float)
FLNT    					= new((/dimsizes(casename),nyear/),float)
FSNT    					= new((/dimsizes(casename),nyear/),float)
RESTOM  					= new((/dimsizes(casename),nyear/),float)
RESSURF 					= new((/dimsizes(casename),nyear/),float)
RESDIFF 					= new((/dimsizes(casename),nyear/),float)
CLDLOW						= new((/dimsizes(casename),nyear/),float)
CLDHGH						= new((/dimsizes(casename),nyear/),float)
CLDTOT						= new((/dimsizes(casename),nyear/),float)
TGCLDLWP					= new((/dimsizes(casename),nyear/),float)


do icase=0,ncase-1

fdir 						= "/GPFS/cess1/my-diag/"+casename(icase)+"/"

fnam 						= casename(icase)+"."+staryear+"-"+endyear+".glob.avg.ann.mean.nc"

fil 						= addfile(fdir+fnam,"r")

TS_tmp       					= fil->TS
FSNT_tmp     					= fil->FSNT
FLNT_tmp     					= fil->FLNT
FSNS_tmp     					= fil->FSNS
FLNS_tmp     					= fil->FLNS
LHFLX_tmp    					= fil->LHFLX
SHFLX_tmp    					= fil->SHFLX
 QFLX_tmp    					= fil->QFLX
PRECC_tmp    					= fil->PRECC
PRECL_tmp    					= fil->PRECL
PRECSC_tmp   					= fil->PRECSC
PRECSL_tmp   					= fil->PRECSL
CLDLOW_tmp					= fil->CLDLOW
CLDHGH_tmp					= fil->CLDHGH
TGCLDLWP_tmp					= fil->TGCLDLWP
CLDTOT_tmp					= fil->CLDTOT

Lv 						= 2.501e6                   ; J/kg
Lf 						= 3.337e5                   ; J/kg
LHFLX_new 					= (/(Lv+Lf)*QFLX_tmp - Lf*1.e3*(PRECC_tmp+PRECL_tmp-PRECSC_tmp-PRECSL_tmp)/)

restom_tmp 					= FSNT_tmp-FLNT_tmp
ressuf_tmp 					= FSNS_tmp-FLNS_tmp-LHFLX_new-SHFLX_tmp

resdiff_tmp 					= restom_tmp-ressuf_tmp

printVarSummary(TS_tmp)
printVarSummary(TS)

TS(icase,:) 					= TS_tmp
FLNT(icase,:) 					= FLNT_tmp
FSNT(icase,:) 					= FSNT_tmp
RESTOM(icase,:) 				= restom_tmp
RESSURF(icase,:) 				= ressuf_tmp
RESDIFF(icase,:) 				= resdiff_tmp
CLDLOW(icase,:)					= CLDLOW_tmp
CLDHGH(icase,:)					= CLDHGH_tmp
TGCLDLWP(icase,:)				= TGCLDLWP_tmp
CLDTOT(icase,:)					= CLDTOT_tmp

end do

TGCLDLWP					= TGCLDLWP*1e3
CLDLOW						= CLDLOW*1e2
CLDHGH						= CLDHGH*1e2
CLDTOT						= CLDTOT*1e2


time 						= fil->time

xaxis 						= fspan(1,dimsizes(time),dimsizes(time))

wks = gsn_open_wks("pdf","./figure/"+"PIcntl_ne30s05"+"-time-series-"+staryear+"-"+endyear)

plot = new(8,graphic)

res 					= True

res@gsnDraw 				= False
res@gsnFrame 				= False

res@pmLegendDisplayMode 		= "Always"
;res@pmLegendWidthF 			= 0.15
;res@pmLegendHeightF 			= 0.18
res@xyExplicitLegendLabels 		= casename

res@tiYAxisFontHeightF			= 0.03
res@tmYLLabelFontHeightF		= 0.03
res@tmXBLabelFontHeightF		= 0.03

res@xyLineThicknessF 			= 1.5
res@xyLineColors 			= (/"red","blue","green","orange","purple"/)
;res@xyMarkLineMode 			= "MarkLines"
res@xyDashPattern			= 0.
;res@xyLineColor				= "black"
res@xyMarkLineMode 			= "Lines"

res@xyMarkers 				= (/0,1,2/)
res@xyMarkerSizeF 			= 0.02

res@vpWidthF 				= 0.7
res@vpHeightF 				= 0.3

res1 					= res
;res@trYMinF 				= 286.6
;res@trYMaxF 				= 287.4
res1@tiYAxisString 			= "TS"
plot(0) 				= gsn_y(wks,TS,res1)

res2 					= res
res2@trYMaxF 				= 250.
res2@trYMinF 				= 235.

res2@tiYAxisString 			= "FSNT&FLNT"
;res2@xyLineColor 			= "red"
plot(1) 				= gsn_y(wks,FSNT,res2)
;res2@xyLineColor 			= "blue"
res2@xyDashPattern 			= 4
plot1 					= gsn_y(wks,FLNT,res2)
overlay(plot(1),plot1)

res3 					= res
res3@tiYAxisString 			= "RESTOM"
;res3@xyLineColor 			= "red"
plot(2) 				= gsn_y(wks,RESTOM,res3)
;res3@xyLineColor 			= "blue"
res3@xyDashPattern			= 4
plot2 					= gsn_y(wks,RESSURF,res3)
overlay(plot(2),plot2)

res4 					= res
res4@tiYAxisString 			= "RESTOM - RESSURF"
plot(3) 				= gsn_y(wks,RESDIFF,res4)

res5					= res
res5@tiYAxisString			= "CLDLOW"
plot(4)					= gsn_y(wks,CLDLOW,res5)

res6					= res
res6@tiYAxisString			= "CLDHGH"
plot(5)					= gsn_y(wks,CLDHGH,res6)

res7					= res
res7@tiYAxisString			= "TGCLDLWP"
plot(6)					= gsn_y(wks,TGCLDLWP,res7)

res8					= res
res8@tiYAxisString			= "CLDTOT"
plot(7)					= gsn_y(wks,CLDTOT,res8)



resP					= True
;resP@gsnPanelMainString		= casename

gsn_panel(wks,plot,(/4,2/),resP)


end
