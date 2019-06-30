
############ modify start ###################
regrid=T

dir1=/GPFS/cess/liangys/ciesm_1.1.0/ciesm.run/
dir2=/home/export/online1/cess9/zhangcheng/ciesm_1.1.0/ciesm.run/
dir3=/home/export/online1/qhtest/swqh/dingnan/ZC/CIESM/ciesm.run/
dir4=/GPFS/cess/liangys/cesm/cesm.run/
dir5=/home/export/online1/qhtest/swqh/USER-TSINGHUA/dingnan/2017/cesm.run/

int_year=1979
end_year=1999

casename=(xjh_ne120FAg16_6mods_14400)
dirs=($dir5)

############ modify end ###################

ncase=${#casename[@]}

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
		
		sh $workdir/002_ncremap_files_params_ne120_monthly.sh $workdir ${casename[icase]} $src_dir $out_dir $int_year $end_year
	fi

done
