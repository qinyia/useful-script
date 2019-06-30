

#casename=B1850C5_mic2mac2rad_c0_0.045
casename=B1850_2400_300y

#casedir=/home/lyl/WORK1/lyl_cesm1_2_1/archive/${casename}/ocn/hist/
casedir=/GPFS/cess/liangys/ciesm_1.0.5_300y/ciesm.run/${casename}/run/

echo $casedir

#workdir=/home/lyl/WORK4/qinyi/my-diag/${casename}/pop2/
workdir=/GPFS/cess1/my-diag/${casename}/pop2/

echo $workdir

if [ ! -d "$workdir" ]; then
mkdir $workdir
fi


int_year=1
end_year=100

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

ncra -O $casedir/$casename.pop.h.$year-??.nc $workdir/$casename.$year.ann.mean.nc

ncwa -O -m REGION_MASK -a nlon,nlat -w TAREA $workdir/${casename}.${year}.ann.mean.nc $workdir/${casename}.${year}.global.avg.ann.mean.nc
done  # i

ncrcat -O ${casename}.????.global.avg.ann.mean.nc ${casename}.${int_year_4d}-${end_year_4d}.global.avg.ann.mean.nc

#multiyear-mean
#ncra $workdir/$casename.????.global.avg.ann.mean.nc $casename.global.avg.all.mean.nc

echo "Well done!"
