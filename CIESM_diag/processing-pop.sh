

#casename=B1850C5_mic2mac2rad_c0_0.045
casename=B1850_2400_300y

#casedir=/home/lyl/WORK1/lyl_cesm1_2_1/archive/${casename}/ocn/hist/
casedir=/GPFS/cess/liangys/ciesm_1.0.5_300y/ciesm.run/${casename}/run/

var=(TEMP)
nvar=${#var[@]}
echo $[$nvar-1]

echo $casedir

workdir=/home/lyl/WORK4/qinyi/my-diag/${casename}/pop2/
echo $workdir

if [ ! -d "$workdir" ]; then
mkdir $workdir
fi


int_year=1
end_year=49

int_year_4d=`printf %04d $int_year`
end_year_4d=`printf %04d $end_year`

echo $int_year
echo $end_year

cd $workdir


for i in `seq $int_year $end_year`;
do
echo $i
year=`printf %04d $i`
echo $year

for ivar in `seq 0 $[$nvar-1]`;
do 
echo $ivar

# extract TS, gw and OCNFRAC from model ouptut - annual mean
echo ${var[ivar]}

ncra -O -v ${var[ivar]},TAREA,REGION_MASK $casedir/$casename.pop.h.${year}-??.nc $workdir/${var[ivar]}.${year}.ann.mean.nc

ncwa -O -m REGION_MASK -a nlon,nlat -w TAREA -v ${var[ivar]} $workdir/${var[ivar]}.${year}.ann.mean.nc $workdir/${var[ivar]}.${year}.global.avg.ann.mean.nc
done  # ivar
done  # i

#multiyear-mean
ncra $workdir/TEMP.????.global.avg.ann.mean.nc TEMP.global.avg.all.mean.nc

######deal with observation data
###caution::: "ncwa" is employed to take spatial averages of data. NCOs recognize "_FillValue" but not "missing_value" as the attribute name for missing values. You can add a _FillValue attribute with "ncatted -O -h -a _FillValue,TEMP,o,attribute_type,9e26 in.nc out.nc" or rename all the missing_value attributes in a file to _FillValue with "ncrename -a missing_value,_FillValue in.nc out.nc".
###here, I use the second method!
ncrename -a missing_value,_FillValue PHC2_TEMP_gx1v6_ann_avg.nc PHC2_TEMP_gx1v6_ann_avg_fillvalue.nc
ncwa -O -m REGION_MASK -a X,Y -w TAREA -v TEMP PHC2_TEMP_gx1v6_ann_avg_fillvalue.nc PHC2.global.avg.all.mean.nc
# change dimension name from depth to z_t
ncrename -v depth,z_t -d depth,z_t PHC2.global.avg.all.mean.nc

# calculate difference b/t modeling result and observation
ncdiff TEMP.global.avg.all.mean.nc PHC2.global.avg.all.mean.nc model-obs.temp.nc

echo "Well done!"
