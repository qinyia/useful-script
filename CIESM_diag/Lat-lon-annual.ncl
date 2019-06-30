

begin

;casename2 = (/"PIC_g16_4xCO2_1"/)
;casename2=(/"PIC_g16_1pctCO2_1"/)
casename2=(/"F1850C5_4xCO2_1"/)

colors	= (/"black","grey","blue","dodgerblue","cyan","red","purple"/)

thicks = (/2,2,2,2,2,2,2/)


ncase						=dimsizes(casename2)

staryear = "0001"
endyear = "0037" 
;endyear="0113"
nyear = 37
;nyear = 113

;	      0     1      2       3        4         5        6        7        8        9         10       11
;vars	= (/"TREFHT","FLNT","FSNT","RESTOM","RESSURF","RESDIFF","CLDLOW","CLDHGH","CLDTOT","TGCLDLWP","PRECT","CDNUMC"/)
;vars	= (/"TREFHT","FLNT","FSNT","RESTOM","RESSURF","RESDIFF","CLDLOW","CLDHGH","CLDTOT","TGCLDLWP","PRECT"/)
vars	= (/"TREFHT","FLNT","FSNT","CLDLOW","CLDHGH","CLDTOT","TGCLDLWP","PRECT","CDNUMC"/)
vars_units	= (/"K","W/m2","W/m2","%","%","%","g/m2","mm/day","1E10/m^2"/)

;vars	= (/"CLDLOW","CLDHGH","CLDTOT","TGCLDLWP"/)
nlat	= 96
nlon	= 144

vars_data					= new((/dimsizes(vars),dimsizes(casename2),nyear,nlat,nlon/),float)
vars_data!0					= "var"
vars_data&var					= fspan(0,dimsizes(vars)-1,dimsizes(vars))
vars_data!1					= "case"
vars_data!2				 	= "time"

vars_data_diff					= vars_data


do ivar=0,dimsizes(vars)-1

do icase=0,ncase-1

;do iyear=0,nyear-1

;year	= sprinti("%0.4i",iyear+1)
;print(year)

fdir 						= "/GPFS/cess1/my-diag/"+casename2(icase)+"/"

;fils 						= systemfunc ("ls "+fdir+casename(icase)+".????.ann.mean.nc") ; file paths
;fils 						= systemfunc ("ls "+fdir+"/tmp/*.????.ann.mean.nc") ; file paths
fils 						= systemfunc ("ls "+fdir+"/*.????.ann.mean.nc") ; file paths

print(fils)
fil 						= addfiles(fils,"r")
ListSetType (fil, "cat")
delete(fils)

;fnam 						= casename2(icase)+"."+year+".ann.mean.nc"
;fil 						= addfile(fdir+fnam,"r")

if(isfilevar(fil[0],vars(ivar)))then
;	tmp					= fil->$vars(ivar)$(0,:,:)
	tmp					= fil[:]->$vars(ivar)$
	if(vars(ivar).eq."CLDLOW" .or. vars(ivar).eq."CLDHGH" .or. vars(ivar).eq."CLDTOT")then
		tmp				= tmp*1e2
	end if
	if(vars(ivar).eq."TGCLDLWP")then
		tmp			 	= tmp*1e3
	end if
	if(vars(ivar).eq."CDNUMC")then
		tmp				= tmp*1e-10
	end if
else
	if(vars(ivar).eq."PRECT")then
		PRECC_tmp			= fil[:]->PRECC(:,:,:)
		PRECL_tmp			= fil[:]->PRECL(:,:,:)
		PRECT_tmp			= PRECC_tmp+PRECL_tmp
		tmp				= PRECC_tmp
		tmp				= (/PRECT_tmp/)
		tmp				= tmp*8.64e7
	end if

end if
		
print(vars(ivar)+"	"+casename2(icase))
;vars_data(ivar,icase,iyear,:,:)			 	= tmp
vars_data(ivar,icase,:,:,:)			 	= tmp

delete(tmp)

;end do ; do iyear=

end do ; do icase=

end do ; do ivar=

printVarSummary(vars_data)

; ================== global mean; tropical mean ===============================
;                       Global, Tropical,SH,NH,Arctic(80-90N, 90-270E)
latS                = (/-90.,-30,-90,30,80/)
latE                = (/90.,30,-30,90,90/)
lonS                = (/0.,0,0,0,0,90/)
lonE                = (/360.,360,360,360,270/)
lat                 = vars_data&lat
clat                = tofloat(cos(0.01745329*lat))
clat!0              = "lat"
clat&lat            = vars_data&lat

vars_data_aave      = new((/dimsizes(latS),dimsizes(vars),dimsizes(casename2),nyear/),float)

do ilat=0,dimsizes(latS)-1
    vars_data_aave(ilat,:,:,:)             = wgt_areaave_Wrap(vars_data(:,:,:,{latS(ilat):latE(ilat)},{lonS(ilat):lonE(ilat)}),clat({latS(ilat):latE(ilat)}),1.0,1)

end do ; do ilat=

printVarSummary(vars_data_aave)

do ivar=0,dimsizes(vars)-1
print(vars(ivar)+"		Global			Tropics			midlatitude-SH			midlatitude-NH			Arctic(80-90N, 90-270E)")
print(vars(ivar)+"	"+vars_data_aave(0,ivar,:,:)+"		"+vars_data_aave(1,ivar,:,:)+"		"+vars_data_aave(2,ivar,:,:)+"		"+vars_data_aave(3,ivar,:,:)+"		"+vars_data_aave(4,ivar,:,:))
end do ; do ivar=

; ==================== Plotting ==================================================
;wks = gsn_open_wks("pdf","./figure/"+casename2(dimsizes(casename2)-1)+"-diff-to-v11-"+staryear+"-"+endyear)

plot = new((/dimsizes(vars),dimsizes(casename2),nyear/),graphic)
plotl	= new(dimsizes(vars),graphic)

resl			= True

resl@gsnDraw		= False
resl@gsnFrame		= False

resl@vpWidthF		= 0.7
resl@vpHeightF		= 0.4

resl@xyLineColors	= (/"black","red","blue","cyan"/)
resl@xyLineThicknessF	= 3.0
resl@xyDashPattern	= 0.

fontheight		= 0.03
resl@tiXAxisFontHeightF	= fontheight
resl@tiYAxisFontHeightF	= fontheight
resl@tmXBLabelFontHeightF	= fontheight
resl@tmYLLabelFontHeightF	= fontheight

do ivar=0,dimsizes(vars)-1

wks = gsn_open_wks("png","./figure/"+casename2(dimsizes(casename2)-1)+"-"+staryear+"-"+endyear+"-"+vars(ivar))


resl@tiYAxisString		= vars(ivar)

plotl(ivar)	= gsn_csm_y(wks,vars_data_aave(:,ivar,0,:),resl)

legends                         = (/"Global","Tropics","Midlat-SH","Midlat-NH"/)

lgres                           = True
lgres@DashIndex			= resl@xyDashPattern
lgres@lgLineColors		= resl@xyLineColors
lgres@lgLineThicknessF 		= resl@xyLineThicknessF

lgres@lgLabelFontHeightF        = 0.15
lgres@vpWidthF                  = 0.20
lgres@vpHeightF                 = 0.15
lgres@lgPerimOn                 = False

lbid1                           = gsn_create_legend(wks,dimsizes(legends),legends,lgres)

amres                           = True
amres@amJust			= "BottomLeft"
amres@amParallelPosF            = -0.50
amres@amOrthogonalPosF          = 0.50

annoid1                         = gsn_add_annotation(plotl(ivar),lbid1,amres)

end do ; do ivar=

gsn_panel(wks,plotl,(/dimsizes(vars)/3+1,3/),False)


res 					= True

res@gsnDraw 				= False
res@gsnFrame 				= False

res@cnFillOn				= True
res@cnLinesOn				= False
res@cnLineLabelsOn			= False

;res@tmYLLabelFontHeightF		= 0.03
;res@tmXBLabelFontHeightF		= 0.03

res@mpCenterLonF		 	= 180.

;res@cnLevelSelectionMode		= "ManualLevels"
;res@cnMinLevelValF			= -5.
;res@cnMaxLevelValF			= 5.
;res@cnLevelSpacingF			= 0.5

;do icase = 0,dimsizes(casename2)-1
do icase=0,0
do ivar=0,dimsizes(vars)-1
;do ivar=0,3
print(vars(ivar))

res@gsnLeftString			= vars(ivar)
res@gsnRightString			= vars_units(ivar)

do it=0,nyear-1
vars_data_diff(ivar,icase,it,:,:)	= (/vars_data(ivar,icase,it,:,:)-vars_data(ivar,icase,0,:,:)/)
end do ; do it=
copy_VarCoords(vars_data,vars_data_diff)


symMinMaxPlt (vars_data_diff(ivar,icase,:,:,:),20,False,res) 

do it=0,nyear-1
	res@gsnCenterString			= sprinti("%0.4i",it+1)

	plot(ivar,icase,it)		 	= gsn_csm_contour_map_ce(wks,vars_data_diff(ivar,icase,it,:,:),res)
draw(plot(ivar,icase,it))
frame(wks)
end do ; do it=


resP					= True
;resP@gsnPanelMainString		= casename
resP@gsnPanelYWhiteSpacePercent 	= 5.0
resP@gsnPanelXWhiteSpacePercent 	= 5.0

;gsn_panel(wks,ndtooned(plot(ivar,icase,:)),(/nyear/3+1,3/),resP)

system("convert -delay 50 ./figure/*.png -loop 0 ./figure/"+casename2(0)+"-animated_"+vars(ivar)+".gif")
system("rm -f ./figure/*png")

end do ; do ivar=
end do ; do icase=


end
