#!/bin/bash

############ modify start ###################
regrid=T

casename=$1
dirs=$2
int_year=$3
end_year=$4

############ modify end ###################
OLD_IFS="$IFS" 
IFS=" " 
arr=($casename) 
IFS="$OLD_IFS" 
for s in ${arr[@]} 
do 
    echo "$s" 
done

ncase=${#casename[@]}
echo $ncase


for icase in `seq 0 $[$ncase-1]`
do
	echo ${casename[icase]}

	### Part 1: regrid from SE to FV grid for all monthly dataset
	if [ "$regrid" == "T" ];then
	
		workdir=/GPFS/cess1/se2fv-regrid/scripts/
## modify start
#		src_dir=/GPFS/cess/liangys/ciesm_1.1.0/ciesm.run/${casename[icase]}/run/
		src_dir=${dirs[icase]}/${casename[icase]}/run/
		echo $src_dir
## modify end
		out_dir=/GPFS/cess1/se2fv-regrid/rgr_out/${casename[icase]}
		
		sh $workdir/002_ncremap_files_params.sh $workdir ${casename[icase]} $src_dir $out_dir ${int_year[icase]} ${end_year[icase]}
	fi

done
