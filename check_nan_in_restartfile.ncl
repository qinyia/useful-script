

datadir="/home/export/online1/cess9/zhangcheng/ciesm_1.1.0/ciesm.run/PIC_g16_4xCO2_1/run/"

case="PIC_g16_4xCO2_1"
time_stamp="0041-06-08-00000.nc"
component=(/"cam","pop","rtm","cice","clm2","cpl"/)

valid_types_isnan = (/"float","double"/)

do ic = 0,dimsizes(component)-1
	f = addfile(datadir+case+"."+component(ic)+".r."+time_stamp,"r")
	vNames = getfilevarnames (f)
	nNames = dimsizes (vNames)
	do n=0,nNames-1
		v = f->$vNames(n)$
		if(any(typeof(v).eq.valid_types_isnan)) then
			lg = any(isnan_ieee(v))
			print("component="+component(ic)+"	,"+vNames(n)+"=	,	lg="+lg)
			delete([/lg/])
		end if
		delete(v)
	end do ; do n=
delete([/f,vNames,nNames/])
end do ;do ic=
