
#casename=(CMIP.slave)
#casename=(PIcontrol_ne30s05_v1)

casename=$1
int_year=$2
end_year=$3
ann_mean=$4
stitch=$5

ncase=${#casename[@]}

for icase in `seq 0 $[$ncase-1]`
do

casedir=/GPFS/cess1/se2fv-regrid/rgr_out/${casename[icase]}/

workdir=/GPFS/cess1/my-diag/${casename[icase]}/

if [ ! -d "$workdir" ]; then
mkdir $workdir
fi

int_year_4d=`printf %04d $int_year`
end_year_4d=`printf %04d $end_year`

echo $int_year_4d
echo $end_year_4d

cd $workdir

if [ "$ann_mean" == "T" ];then
for i in `seq $int_year $end_year`;
do
year=`printf %04d $i`
echo $year

# ann mean
ncra -O  $casedir/${casename[icase]}.cam.h0.${year}-??.nc $workdir/${casename[icase]}.${year}.ann.mean.nc

# global ann mean with gaussian weighting and ocean mask.
ncwa -O -a lon,lat -w gw $workdir/${casename[icase]}.${year}.ann.mean.nc $workdir/${casename[icase]}.${year}.glob.avg.ann.mean.nc

done  # i

fi # ann_mean

if [ "$stitch" == "T" ];then
all_file_list=''
for iyr0 in `seq $int_year $end_year`
do
        iyr0_4d=`printf %04d $iyr0`
        echo ${iyr0_4d}

        list_tmp=`ls $workdir/${casename[icase]}.${iyr0_4d}.glob.avg.ann.mean.nc`
        echo $list_tmp
        all_file_list="${all_file_list} ${list_tmp}"
done

file_list=${all_file_list}

echo `ls ${file_list}`

#ncrcat -O ${casename[icase]}.????.glob.avg.ann.mean.nc ${casename[icase]}.${int_year_4d}-${end_year_4d}.glob.avg.ann.mean.nc
ncrcat -O ${file_list} ${casename[icase]}.${int_year_4d}-${end_year_4d}.glob.avg.ann.mean.nc

fi # stitch

done # icase

echo "Well done!"
