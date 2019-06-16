

datadir=/GPFS/cess/CESM_INPUT/aerosol-cmpi6/

#datafile=MACv2-SP_3Dfields_f09_g16_1850-2016.nc
#datafile=CMIP_1850_2014_volc_v2.nc
datafile=CMIP_DESS_radiation_volc_v3.nc

# extract 1850 year data
ncks -O -F -d time,1,12 $datadir/$datafile tmp-1850.nc

# change time dimension from 1850 to 1849
ncap2 -O -s 'date=date-10000' tmp-1850.nc tmp-1849.nc

# merge with raw data
#ncrcat tmp-1849.nc $datadir/$datafile ./CMIP_1849_2014_volc_v2.nc

ncrcat tmp-1849.nc $datadir/$datafile ./CMIP_DESS_radiation_1849_2014_volc_v3.nc
