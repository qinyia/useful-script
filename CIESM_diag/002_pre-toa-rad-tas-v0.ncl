
begin

vars 		= (/"rsdt","rsut","rlut","rlutcs","rsutcs","tas"/)

fdir		= "/home/lyl/WORK4/qinyi/tmp-CMIP6-CESM2-data/data/"
file_append	= "_Amon_CESM2_abrupt-4xCO2_r1i1p1f1_gn_000101-015012.nc"


ftmp				= addfile(fdir+vars(0)+file_append,"r")
dSizes                          = getfiledimsizes(ftmp)
printVarSummary(dSizes)
print(dSizes) ; 192,2,288,1800

vars_Rad         		= new((/dimsizes(vars),dSizes(3),dSizes(0),dSizes(2)/),float)
vars_Rad!0			= "vars"
vars_Rad&vars			= fspan(0,dimsizes(vars)-1,dimsizes(vars))
printVarSummary(vars_Rad)

do ivar = 0,dimsizes(vars)-1
print(vars(ivar))
f1				= addfile(fdir+vars(ivar)+file_append,"r")
vars_Rad(ivar,:,:,:)		= f1->$vars(ivar)$
end do

; global mean calculation
lat_here                                = vars_Rad&lat
rad                                     = 4.0*atan(1.0)/180.
clat                                    = cos(lat_here*rad)
clat!0                                  = "lat"
clat&lat                                = lat_here

vars_Rad_aave				= wgt_areaave_Wrap(vars_Rad,clat,1.0,1)
printVarSummary(vars_Rad_aave)

; month to annual
vars_Rad_aave_annual			= month_to_annual(vars_Rad_aave(time|:,vars|:),1)
printVarSummary(vars_Rad_aave_annual)


; Starts TOA radiation.......
;vars 		= (/"rsdt","rsut","rlut","rlutcs","rsutcs"/)
; net TOA radiation flux
tmp					= vars_Rad_aave_annual
rnt					= tmp(:,0)-tmp(:,1)-tmp(:,2)
rnt!0					= "year"
rnt&year				= ispan(0,149,1)
rnt@long_name				= "TOA net flux"

; net TOA SW flux
rsnt					= rnt
rsnt				 	= tmp(:,0)-tmp(:,1)
rsnt@long_name				= "TOA net SW flux"

; net TOA SW flux
rlnt					= rnt
rlnt				 	= (/tmp(:,2)/)
rlnt@long_name				= "TOA net LW flux"

; shortwave cloud radiative forcing
swcf					= rnt
swcf					= tmp(:,4)-tmp(:,1)
swcf@long_name				= "SWCF"

; longwave cloud radiative forcing
lwcf					= rnt
lwcf					= tmp(:,3)-tmp(:,2)
lwcf@long_name				= "LWCF"

; surface air temperature
tas						= rnt
tas						= (/tmp(:,5)/)
tas@long_name			= "TAS"

vars_out				= (/rnt,swcf,lwcf,tas/)

outdir="/home/lyl/WORK4/qinyi/tmp-CMIP6-CESM2-data/mid-data/"
system("/bin/rm -f "+outdir+"time-value-TOA-radiation-tas-v0.nc")
ncdf = addfile(outdir+"time-value-TOA-radiation-tas-v0.nc" ,"c")

ncdf->rnt				= rnt
ncdf->rsnt				= rsnt
ncdf->rlnt				= (/rlnt/)
ncdf->tas				= (/tas/)

end
