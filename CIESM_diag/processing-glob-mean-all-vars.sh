

#casename=(B1850_2400_300y)
#casename=(PIcontrol_cesm_x86)
casename=(PIcontrol_ciesm_x86)

ncase=${#casename[@]}
echo $ncase

for icase in `seq 0 $[$ncase-1]`
do
echo ${casename[icase]}

#casedir=/home/lyl/WORK1/lyl_cesm1_2_1/archive/${casename[icase]}/atm/hist/
#casedir=/GPFS/cess/liangys/ciesm_1.0.5_300y/ciesm.run/${casename[icase]}/run/

#casedir=/GPFS/cess/liangys/cesm/cesm.run/${casename[icase]}/run/
casedir=/GPFS/cess/liangys/ciesm_1.1.0/ciesm.run/${casename[icase]}/run/


echo $casedir

#workdir=/home/lyl/WORK4/qinyi/my-diag/${casename[icase]}/
workdir=/GPFS/cess1/my-diag/${casename[icase]}/
echo $workdir

if [ ! -d "$workdir" ]; then
mkdir $workdir
fi

int_year=1
end_year=100

if [ "${casename[icase]}" == "B1850_new_lin_100y" ]; then
end_year=31
fi
if [ "${casename[icase]}" == "B1850_new_canuto_100y" ]; then
end_year=44
fi
if [ "${casename[icase]}" == "B1850_new_canuto_lin_100y_2" ]; then
end_year=26
fi

echo ${end_year}

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

# ann mean
ncra -O  $casedir/${casename[icase]}.cam.h0.${year}-??.nc $workdir/${casename[icase]}.${year}.ann.mean.nc

# global ann mean with gaussian weighting and ocean mask.
ncwa -O -a lon,lat -w gw $workdir/${casename[icase]}.${year}.ann.mean.nc $workdir/${casename[icase]}.${year}.glob.avg.ann.mean.nc

done  # i


ncrcat -O ${casename[icase]}.????.glob.avg.ann.mean.nc ${casename[icase]}.${int_year_4d}-${end_year_4d}.glob.avg.ann.mean.nc

done # icase

echo "Well done!"
