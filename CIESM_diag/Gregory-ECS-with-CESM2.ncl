

f1					= addfile("./CESM2-time-value-TOA-radiation-tas-v0.nc","r")
f2					= addfile("./CIESM-time-value-TOA-radiation-tas-v0.nc","r")

tas1					= f1->tas
rnt1					= f1->rnt

tas2					= f2->tas
rnt2					= f2->rnt

printVarSummary(rnt1)

tas1_ano				= tas1
tas1_fix				= tas1
tas1_fix				= (/tas1_ano(0)/)
tas1_ano				= (/tas1-tas1_fix/)
printVarSummary(tas1_ano)

tas2_ano				= tas2
tas2_fix				= tas2
tas2_fix				= (/tas2_ano(0)/)
tas2_ano				= (/tas2-tas2_fix/)
printVarSummary(tas2_ano)

print(rnt1+"		"+tas1_ano)
print(rnt2+"		"+tas2_ano)

;----- regression lines for ECS estimate
rc1   = regline (tas1_ano,rnt1)

yReg1 = rc1*tas1_ano + rc1@yintercept
print(rc1)
print(rc1@yintercept)

rc2  = regline (tas2_ano,rnt2)

yReg2 = rc2*tas2_ano + rc2@yintercept
print(rc2)
print(rc2@yintercept)

x_com	= fspan(0,12,121)
print(x_com)
y1_com	= rc1*x_com + rc1@yintercept
y2_com	= rc2*x_com + rc2@yintercept

print(y1_com+"			"+y2_com)


data		= (/y1_com, y2_com/)



wks					= gsn_open_wks("pdf","./figure/CESM2-and-CIESM-4xCO2-time-series-ECS")


res					= True
res@gsnFrame				= False
res@gsnDraw				= False

res@vpWidthF				= 0.7
res@vpHeightF				= 0.3

;res@tmXBMinorOn				= False
;res@tmYLMinorOn				= False
res@tmXTMinorOn				= False
res@tmYRMinorOn				= False


res@gsnXRefLine				= 40.

res@xyMarkLineModes     		= (/"Lines","Lines"/)  ; choose which have markers
res@xyLineColors			= (/"Red","Blue"/)
res@xyLineThicknessF			= 1.5
res@xyDashPatterns			= (/0,0/)

res@gsnLeftString		= ""
res@tiYAxisString		= "RESTOM (W/m~S~2~N~)"
res@tiXAxisString		= "dTS (K)"
res@trYMinF			= 0.
res@trYMaxF			= 10.

plot					= gsn_csm_xy(wks,x_com,data,res)

pmres				= True
pmres@gsMarkerColor		= "Red"
pmres@gsMarkerIndex		= 0

;dum1				= gsn_add_polymarker(wks,plot,tas1_ano,yReg1,pmres)
dum1				= gsn_add_polymarker(wks,plot,tas1_ano,rnt1,pmres)

pmres@gsMarkerColor		= "Blue"
pmres@gsMarkerIndex		= 0

dum2				= gsn_add_polymarker(wks,plot,tas2_ano,rnt2,pmres)

; --------- add legends

legends                         = (/"CESM2.0","CIESM"/)

lgres                          		= True
lgres@lgItemTypes			= res@xyMarkLineModes
lgres@lgLineThicknessF			= res@xyLineThicknessF
lgres@lgLineColors			= res@xyLineColors
lgres@lgMonoItemType			= False
lgres@lgDashIndexes			= res@xyDashPatterns

lgres@lgLabelFontHeightF        = 0.08
lgres@vpWidthF                  = 0.15
lgres@vpHeightF                 = 0.1
lgres@lgPerimOn                 = False

lbid1                           = gsn_create_legend(wks,dimsizes(legends),legends,lgres)

amres                           = True
amres@amJust			= "TopRight"
amres@amParallelPosF            = 0.5
amres@amOrthogonalPosF          = -0.5

annoid1                         = gsn_add_annotation(plot,lbid1,amres)

; add the regression equations to the plot 
txres				= True
txres@txFontHeightF		= 0.014
txres@txDirection		= "Across"

label				= (/"y1 = -0.64x + 6.68","y2 = -0.84x + 8.27"/)
color				= (/"red","blue"/)
text				= new(dimsizes(label),"graphic")


do i=0,dimsizes(label)-1
	txres@txFontColor	= color(i)
	text(i)			= gsn_add_text(wks,plot,label(i),10,4-i,txres)
end do ;do i=


resP				= True
resP@gsnPanelYWhiteSpacePercent  = 5.0
resP@gsnPanelXWhiteSpacePercent  = 5.0
resP@gsnPanelLeft		= 0.05
resP@gsnPanelRight		= 0.95

gsn_panel(wks,plot,(/1,1/),resP)


