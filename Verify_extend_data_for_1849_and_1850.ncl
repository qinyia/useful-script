
f1		= addfile("./new_ozone_cmip6_2015_hist.nc","r")

O3		= f1->O3(1980:,15,:,:)

printVarSummary(O3)

O3_2014		= f1->O3(1980:1991,15,:,:)
O3_2015		= f1->O3(1992:,15,:,:)
printVarSummary(O3_2014)
printVarSummary(O3_2015)

diff		= O3_2015-O3_2014
printMinMax(diff,True)
print(diff)
