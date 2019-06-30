
# casename2 - casename1
# casename1 is the baseline.

casename1=$1
casename2=$2
int_year=$3
end_year=$4
difference=$5

ncase=${#casename2[@]}

for icase in `seq 0 $[$ncase-1]`
do

casedir1=/GPFS/cess1/se2fv-regrid/rgr_out/${casename1}/
casedir2=/GPFS/cess1/se2fv-regrid/rgr_out/${casename2[icase]}/

workdir1=/GPFS/cess1/my-diag/${casename1}/
workdir2=/GPFS/cess1/my-diag/${casename2[icase]}/


int_year_4d=`printf %04d $int_year`
end_year_4d=`printf %04d $end_year`

echo $int_year_4d
echo $end_year_4d

cd $workdir

if [ "$difference" == "T" ];then
for i in `seq $int_year $end_year`;
do 
year=`printf %04d $i`
echo $year

# difference between case2 and case1
ncdiff -O $workdir2/${casename2[icase]}.${year}.ann.mean.nc $workdir1/${casename1}.${year}.ann.mean.nc $workdir2/${casename2[icase]}-${casename1}.${year}.ann.mean.diff.nc

done # i

fi # difference

done # icase

echo "Well done!"
