
#!/bin/bash

### 
# merge three scripts (regrid, global mean, stitch) into one:
#post-process-only-regrid-multi-cases-param.sh ${casename[*]} ${dirs[@]} ${int_year[@]} ${end_year[@]}
#sh post-process-only-globmean-multi-cases-param.sh $casename $int_year $end_year
#sh post-process-only-stitch-multi-cases-param.sh $casename $int_year1 $end_year1 
###
# Author: Yi Qin
# create: 2019-06-27 22:16:05


#dir1=/GPFS/cess/liangys/ciesm_1.1.0/ciesm.run/
dir1=/GFPS8p/cess/liangys/ciesm_1.1.0/ciesm.run/
dir2=/home/export/online1/cess9/zhangcheng/ciesm_1.1.0/ciesm.run/
dir3=/home/export/online1/qhtest/swqh/dingnan/ZC/CIESM/ciesm.run/
dir4=/GPFS/cess/liangys/cesm/cesm.run/
dir5=/home/export/online1/qhtest/swqh/USER-TSINGHUA/dingnan/2017/cesm.run/

#casename=(F1850C5_4xCO2_1 PIC_g16_acc_nochem_1 PIC_g16_4xCO2_rad_1 B20TRC5_g16_acc_nochem_2)
#dirs=($dir2 $dir2 $dir2 $dir2)
#int_year=(1 407 10 1928)
#end_year=(37 569 40 2010)
#int_year1=(1 1 1 1850)
#end_year1=(37 569 40 2010)

#casename=(F1850C5_4xCO2_1 PIC_g16_4xCO2_rad_1)
#dirs=($dir2 $dir2)
#int_year=(1 10)
#end_year=(37 40)
#int_year1=(1 1)
#end_year1=(37 40)

casename=(B20TRC5_g16_acc_nochem_2)
dirs=($dir2)
int_year=(1928)
end_year=(1948)
int_year1=(1850)
end_year1=(2010)



#casename=(PIC_g16_4xCO2_no_macro)
#dirs=($dir1)
#int_year=(1)
#end_year=(7)
#int_year1=(1)
#end_year1=(7)


regrid=T
ann_mean=T
#############################################################

ncase=${#casename[@]}
echo $ncase

for icase in `seq 0 $[$ncase-1]`
do
	echo ${casename[icase]}

	if [ "$regrid" == "T" ]; then
		workdir=/GPFS/cess1/se2fv-regrid/scripts/
		src_dir=${dirs[icase]}/${casename[icase]}/run/
		echo $src_dir
		out_dir=/GPFS/cess1/se2fv-regrid/rgr_out/${casename[icase]}
		sh $workdir/002_ncremap_files_params.sh $workdir ${casename[icase]} $src_dir $out_dir ${int_year[icase]} ${end_year[icase]}
	fi

	if [ "$ann_mean" == "T" ]; then
		ann_mean=T
		stitch=F
		sh processing-glob-season-mean-all-vars-se2fv.sh ${casename[icase]} ${int_year[icase]} ${end_year[icase]} $ann_mean $stitch
	fi


stitch=T

	if [ "$stitch" == "T" ]; then
		ann_mean=F
		stitch=T
		sh processing-glob-season-mean-all-vars-se2fv.sh ${casename[icase]} ${int_year1[icase]} ${end_year1[icase]} $ann_mean $stitch
	fi

done
exit

# data regrid
#sh post-process-only-regrid-multi-cases-param.sh $casename $dirs $int_year $end_year
#sh post-process-only-regrid-multi-cases-param.sh "${casename[*]}" "${dirs[*]}" "${int_year[*]}" "${end_year[*]}"
#sh post-process-only-regrid-multi-cases-param.sh ${casename[*]} ${dirs[@]} ${int_year[@]} ${end_year[@]}


# global mean 
#sh post-process-only-globmean-multi-cases-param.sh $casename $int_year $end_year

# stich time series
#sh post-process-only-stitch-multi-cases-param.sh $casename $int_year1 $end_year1 
