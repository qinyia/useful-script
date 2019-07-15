

begin

casename = new((/1,2/),string)

casename(0,:)=(/\
	   (/"B20TRC5_g16_acc_nochem_1"/),\
	   (/"B20TRC5_g16_acc_nochem_2"/)\
	 /)
printVarSummary(casename)

dims	= dimsizes(casename)
print(dims)

startyear=(/1850,1850/)
endyear=(/2010,2010/)
xlabelspacing=(/30,20,20,20/)

; year	= 231 135 61 18
colors	= (/"black","grey","blue","dodgerblue","cyan","red","purple"/)
;thicks = (/2,2,2,4,1/)

thicks = (/2,2,2,2,2,2,2/)

ncase						= dims(0)
print(ncase)
ngroup						= dims(1)
print(ngroup)

;	      0     1      2       3        4         5        6        7        8        9         10       11
vars	= (/"TREFHT","FLNT","FSNT","RESTOM","RESSURF","RESDIFF","CLDLOW","CLDHGH","CLDTOT","TGCLDLWP","PRECT","CDNUMC"/)
;vars	= (/"TREFHT","FLNT","FSNT","RESTOM","RESSURF","RESDIFF","CLDLOW","CLDHGH","CLDTOT","TGCLDLWP","PRECT"/)

;vars	= (/"CLDLOW","CLDHGH","CLDTOT","TGCLDLWP"/)


do igroup=0,dims(1)-1

nyear = endyear(igroup)-startyear(igroup)+1
print(startyear(igroup)+"	"+endyear(igroup))
print(igroup+"	"+nyear)

if(igroup.eq.0)then
	vars_data					= new((/dimsizes(vars),ncase,ngroup,nyear/),float)
	printVarSummary(vars_data)
end if


do ivar=0,dimsizes(vars)-1

do icase=0,ncase-1

fdir 						= "/GPFS/cess1/my-diag/"+casename(icase,igroup)+"/"

yearS=sprinti("%04d",startyear(igroup))
yearE=sprinti("%04d",endyear(igroup))

fnam 						= casename(icase,igroup)+"."+yearS+"-"+yearE+".glob.avg.ann.mean.nc"

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
		
print(vars(ivar)+"	"+casename(icase,igroup))
vars_data(ivar,icase,igroup,:)			 	= (/tmp/)
delete(tmp)

end do ; do icase=

end do ; do ivar=

printVarSummary(vars_data)

;	      0     1      2       3        4         5        6        7        8        9
;vars	= (/"TS","FLNT","FSNT","RESTOM","RESSURF","RESDIFF","CLDLOW","CLDHGH","CLDTOT","TGCLDLWP"/)

TS						= vars_data(0,:,:,:) ;(nvar,ncase,ngroup,ntime)
FLNT					 	= vars_data(1,:,:,:)
FSNT						= vars_data(2,:,:,:)
RESTOM						= vars_data(3,:,:,:)
RESSURF						= vars_data(4,:,:,:)
RESDIFF						= vars_data(5,:,:,:)

time 						= fil->time

xtime 						= fspan(1,dimsizes(time),dimsizes(time))
xtime_label					= fspan(startyear(igroup),endyear(igroup),nyear)


; 2019-05-05 17:06:28
TS!2	= "time"
TS&time	= fspan(startyear(igroup),endyear(igroup),nyear)
printVarSummary(TS)
;alist		= [/TS/]

;write_table("B20TR_absolute_"+igroup+".txt", "w", alist, "%9.3f")


end do ; do igroup=

delete(vars_data)

alist		= [/TS(0,0,:),TS(0,1,:)/]

write_table("B20TR_absolute.txt", "w", alist, "%9.3f%9.3f")

end
