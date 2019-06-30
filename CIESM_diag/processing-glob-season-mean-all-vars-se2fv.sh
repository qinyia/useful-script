
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
year1=`printf %04d $[$i+1]`
echo $year1

# ann mean
ncra -O  $casedir/${casename[icase]}.cam.h0.${year}-??.nc $workdir/${casename[icase]}.${year}.ann.mean.nc

# JJA 
echo "JJA starts"
ncra -O $casedir/${casename[icase]}.cam.h0.${year}-06.nc $casedir/${casename[icase]}.cam.h0.${year}-07.nc $casedir/${casename[icase]}.cam.h0.${year}-08.nc $workdir/${casename[icase]}.${year}.JJA.mean.nc

# DJF
echo $i
echo ${end_year}
if [ "$i" -lt "${end_year}" ]; then
	echo "DJF starts"
	ncra -O $casedir/${casename[icase]}.cam.h0.${year}-12.nc $casedir/${casename[icase]}.cam.h0.${year1}-01.nc $casedir/${casename[icase]}.cam.h0.${year1}-02.nc $workdir/${casename[icase]}.${year}.DJF.mean.nc
else # only use the last year for us
	ncra -O $casedir/${casename[icase]}.cam.h0.${year}-12.nc $workdir/${casename[icase]}.${year}.DJF.mean.nc
fi


# global ann mean with gaussian weighting and ocean mask.
ncwa -O -a lon,lat -w gw $workdir/${casename[icase]}.${year}.ann.mean.nc $workdir/${casename[icase]}.${year}.glob.avg.ann.mean.nc
ncwa -O -a lon,lat -w gw $workdir/${casename[icase]}.${year}.JJA.mean.nc $workdir/${casename[icase]}.${year}.glob.avg.JJA.mean.nc
ncwa -O -a lon,lat -w gw $workdir/${casename[icase]}.${year}.DJF.mean.nc $workdir/${casename[icase]}.${year}.glob.avg.DJF.mean.nc

done  # i

fi # ann_mean

if [ "$stitch" == "T" ];then
all_file_list_ann=''
all_file_list_JJA=''
all_file_list_DJF=''
for iyr0 in `seq $int_year $end_year`
do
        iyr0_4d=`printf %04d $iyr0`
        echo ${iyr0_4d}

        list_tmp_ann=`ls $workdir/${casename[icase]}.${iyr0_4d}.glob.avg.ann.mean.nc`
        list_tmp_JJA=`ls $workdir/${casename[icase]}.${iyr0_4d}.glob.avg.JJA.mean.nc`
        list_tmp_DJF=`ls $workdir/${casename[icase]}.${iyr0_4d}.glob.avg.DJF.mean.nc`
        echo $list_tmp
        all_file_list_ann="${all_file_list_ann} ${list_tmp_ann}"
        all_file_list_JJA="${all_file_list_JJA} ${list_tmp_JJA}"
        all_file_list_DJF="${all_file_list_DJF} ${list_tmp_DJF}"
done

file_list_ann=${all_file_list_ann}
file_list_JJA=${all_file_list_JJA}
file_list_DJF=${all_file_list_DJF}

echo `ls ${file_list_ann}`
echo `ls ${file_list_JJA}`
echo `ls ${file_list_DJF}`

#ncrcat -O ${casename[icase]}.????.glob.avg.ann.mean.nc ${casename[icase]}.${int_year_4d}-${end_year_4d}.glob.avg.ann.mean.nc
ncrcat -O ${file_list_ann} ${casename[icase]}.${int_year_4d}-${end_year_4d}.glob.avg.ann.mean.nc
ncrcat -O ${file_list_JJA} ${casename[icase]}.${int_year_4d}-${end_year_4d}.glob.avg.JJA.mean.nc
ncrcat -O ${file_list_DJF} ${casename[icase]}.${int_year_4d}-${end_year_4d}.glob.avg.DJF.mean.nc

fi # stitch

done # icase

echo "Well done!"
