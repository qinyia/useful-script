

begin

casename=(/"B1850_2400_300y"/)

ncase=dimsizes(casename)

TS      = new((/dimsizes(casename),100/),float)
FLNT    = new((/dimsizes(casename),100/),float)
FSNT    = new((/dimsizes(casename),100/),float)
RESTOM  = new((/dimsizes(casename),100/),float)
RESSURF = new((/dimsizes(casename),100/),float)
RESDIFF = new((/dimsizes(casename),100/),float)

do icase=0,ncase-1

staryear="0001"
endyear="0100"

fdir = "/GPFS/cess1/my-diag/"+casename(icase)+"/"

fnam = casename+"."+staryear+"-"+endyear+".glob.avg.ann.mean.nc"

fil = addfile(fdir+fnam,"r")

TS_tmp       = fil->TS
FSNT_tmp     = fil->FSNT
FLNT_tmp     = fil->FLNT
FSNS_tmp     = fil->FSNS
FLNS_tmp     = fil->FLNS
LHFLX_tmp    = fil->LHFLX
SHFLX_tmp    = fil->SHFLX
 QFLX_tmp    = fil->QFLX
PRECC_tmp    = fil->PRECC
PRECL_tmp    = fil->PRECL
PRECSC_tmp   = fil->PRECSC
PRECSL_tmp   = fil->PRECSL

Lv = 2.501e6                   ; J/kg
Lf = 3.337e5                   ; J/kg
LHFLX_new = (/(Lv+Lf)*QFLX_tmp - Lf*1.e3*(PRECC_tmp+PRECL_tmp-PRECSC_tmp-PRECSL_tmp)/)

restom_tmp = FSNT_tmp-FLNT_tmp
ressuf_tmp = FSNS_tmp-FLNS_tmp-LHFLX_new-SHFLX_tmp

resdiff_tmp = restom_tmp-ressuf_tmp

TS(icase,:) = TS_tmp
FLNT(icase,:) = FLNT_tmp
FSNT(icase,:) = FSNT_tmp
RESTOM(icase,:) = restom_tmp
RESSURF(icase,:) = ressuf_tmp
RESDIFF(icase,:) = resdiff_tmp

end do

time = fil->time

xaxis = fspan(1,dimsizes(time),dimsizes(time))

;wks = gsn_open_wks("x11",casename+"-time-series-ann-"+staryear+"-"+endyear)
wks = gsn_open_wks("x11",casename+"-time-series-"+staryear+"-"+endyear)

plot = new(6,graphic)

res = True

res@gsnDraw = False
res@gsnFrame = False

res@pmLegendDisplayMode = "Always"
;res@pmLegendWidthF = 0.15
;res@pmLegendHeightF = 0.18
res@xyExplicitLegendLabels = casename

res@xyLineThicknessF = 3.0
;res@xyLineColors = (/"red","blue","green"/)
;res@xyMarkLineMode = "MarkLines"
res@xyMarkLineMode = "Lines"

res@xyMarkers = (/0,1,2/)
res@xyMarkerSizeF = 0.02

res@vpWidthF = 0.7
res@vpHeightF = 0.3

;res@trYMinF = 286.6
;res@trYMaxF = 287.4
res@tiYAxisString = "TS"
plot(1) = gsn_y(wks,TS,res)

res@trYMaxF = 245.
res@trYMinF = 230.

res@tiYAxisString = "FSNT&FLNT"

res@xyDashPattern = 1
plot(2) = gsn_y(wks,FSNT,res)

res@xyDashPattern = 4
plot1 = gsn_y(wks,FLNT,res)
overlay(plot(2),plot1)

delete(res@trYMaxF)
delete(res@trYMinF)


res@tiYAxisString = "RESTOM"
plot(3) = gsn_y(wks,RESTOM,res)
plot2 = gsn_y(wks,RESSURF,res)
overlay(plot(3),plot2)


res@tiYAxisString = "RESTOM - RESSURF-revised"
plot(4) = gsn_y(wks,RESDIFF,res)


res_def = True
res_def@xyLineThicknessF = 3.0

res1 =  res_def
res1@gsnMaximize = True
res1@tiYAxisString ="TS"
res1@xyLineColor = "red"
res1@tiYAxisFontColor = res1@xyLineColor

res2 =  res_def
res2@trYMinF = -2.0
res2@trYMaxF = 2.0
res2@tiYAxisString = "RES_TOM"
res2@xyLineColor = "blue"
res2@tiYAxisFontColor = res2@xyLineColor

res3 =  res_def
res3@trYMinF = -2.0
res3@trYMaxF = 2.0
res3@tiYAxisString = "RES_SUF-revised"
res3@xyLineColor = "green"
res3@tiYAxisFontColor = res3@xyLineColor

res3@amOrthogonalPosF = 0.75

;plot2 = gsn_csm_xy2(wks,xaxis,TS,restom,res1,res2)

;plot2 = gsn_csm_xy3(wks,xaxis,TS,RESTOM,RESDIFF,res1,res2,res3)

gsn_panel(wks,plot,(/3,2/),False)



end
