

fname1			= "HadCRUT_absolute.txt"
fname2			= "B20TR_absolute.txt"

nyear			= 161
nsample			= 2

obs			= asciiread(fname1,(/169/),"float")
print(obs)


model			= asciiread(fname2,(/nyear,nsample/),"float")
printVarSummary(model)
print(model(:,0)+"	"+model(:,1))


data			= (/obs(:nyear-1),model(:,0),model(:,1)/)
data!1			= "time"
data&time		= fspan(0,nyear-1,nyear)+1850
printVarSummary(data)

data_diff		= data
do it=0,nyear-1
data_diff(:,it)		= data(:,it)-dim_avg(data(:,{1880:1909}))
end do ; do it=
print(data_diff(0,:)+"	"+data_diff(1,:))



wks			= gsn_open_wks("pdf","./figure/B20TRC5_TS_with_obs_"+nyear+"years")

res			= True
res@gsnFrame		= False
res@gsnDraw		= False

res@vpWidthF		= 0.7
res@vpHeightF		= 0.4

res@xyLineColors	= (/"grey","black","blue"/)
res@xyLineThicknessF	= 3.

res@xyDashPatterns	= (/0,0,0/)

res@trXMinF		= 1850

res@tiMainString	= "Global Sfc Air Temp"
plot			= gsn_csm_xy(wks,data&time,data,res)

res@tiMainString	= "Global Sfc Air Temp Ano (relative to 1880-1909)"
plot			= gsn_csm_xy(wks,data_diff&time,data_diff,res)


legends                         = (/"CRU4","CIESM1.1_ens1","CIESM1.1_ens2"/)

lgres                          	= True

lgres@lgLineColors	= res@xyLineColors
lgres@lgLineThicknessF = res@xyLineThicknessF
lgres@lgDashIndexes     = res@xyDashPatterns

lgres@lgLabelFontHeightF        = 0.08
lgres@vpWidthF                  = 0.15
lgres@vpHeightF                 = 0.1
lgres@lgPerimOn                 = True

lbid1                           = gsn_create_legend(wks,dimsizes(legends),legends,lgres)

amres                           = True
amres@amJust			= "BottomRight"
amres@amParallelPosF            = 0.5
amres@amOrthogonalPosF          = 0.5

annoid1                         = gsn_add_annotation(plot,lbid1,amres)

draw(plot)
frame(wks)
