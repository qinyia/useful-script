

#datadir=/GPFS/cess/CESM_INPUT/aerosol-cmpi6/
datadir=/home/export/online1/cess/CESM_INPUT/cmip6-forcing/

#file1=MACv2-SP_3Dfields_f09_g16_1850-2016.nc
#file1=CMIP_1850_2014_volc_v2.nc
#file1=CMIP_DESS_radiation_volc_v3.nc

###file1=ghg_cmip6_2014_new.nc

#### extract 2014 year data
###ncks -O -F -d time,250 $datadir/$file1 tmp-2014.nc
###
#### change time dimension from 2014 to 2015
###ncap2 -O -s 'date=date+10000' tmp-2014.nc tmp-2015.nc
###ncap2 -O -s 'time=time+365' tmp-2015.nc tmp-2015.nc
###
#### merge with raw data
###ncrcat -O $datadir/$file1 tmp-2015.nc ./ghg_cmip6_2015_new.nc
###
###rm -f ./tmp-2014.nc
###rm -f ./tmp-2015.nc

file2=new_ozone_cmip6_hist.nc

ncks -O -F -d time,1981,1992 $datadir/$file2 tmp-2014.nc
ncap2 -O -s 'date=date+10000' tmp-2014.nc tmp-2015.nc
ncap2 -O -s 'time=time+365' tmp-2015.nc tmp-2015.nc
ncrcat -O $datadir/$file2 tmp-2015.nc ./new_ozone_cmip6_2015_hist.nc



