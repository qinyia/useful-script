

begin

casename="B1850C5_mic2mac2rad_c0_0.045"
staryear="0001"
endyear="0049"

fdir = "/home/lyl/WORK4/qinyi/my-diag/"+casename+"/pop2/"

fnam1 = "PHC2.global.avg.all.mean.nc"
fnam2 = "TEMP.global.avg.all.mean.nc"


fil1 = addfile(fdir+fnam1,"r")
fil2 = addfile(fdir+fnam2,"r")

temp1 = fil1->TEMP
temp2 = fil2->TEMP(0,:)

z_t = fil1->z_t

diff = temp2-temp1

zero_line = diff
zero_line = 0.0


temp1@_FillValue = 9.96921e+36
printVarSummary(temp1)
printVarSummary(temp2)

data = (/temp1,temp2/)

data1 = (/zero_line,diff/)




wks = gsn_open_wks("pdf",casename+"-pop2-temp-depth")

plot = new(2,graphic)

res = True

res@trYReverse = True
res@xyLineThicknessF = 3.0

res@tiYAxisString = "depth[m]"

res@tiXAxisString = "potential temp.[obs:solid; model:dash]"
plot(0) = gsn_xy(wks,data,z_t,res)

res@tiXAxisString = "potential temp. [model-obs]"
plot(1) = gsn_xy(wks,data1,z_t,res)

gsn_panel(wks,plot,(/2,1/),False)



end
