
############ modify start ###################
regrid=T

#dir1=/GPFS/cess/liangys/ciesm_1.1.0/ciesm.run/
dir1=/GFPS8p/cess/liangys/ciesm_1.1.0/ciesm.run/
dir2=/home/export/online1/cess9/zhangcheng/ciesm_1.1.0/ciesm.run/
dir3=/home/export/online1/qhtest/swqh/dingnan/ZC/CIESM/ciesm.run/
dir4=/GPFS/cess/liangys/cesm/cesm.run/
dir5=/home/export/online1/qhtest/swqh/USER-TSINGHUA/dingnan/2017/cesm.run/

#casename=(B20TRC5_ne30s05_v1)
#dirs=($dir1)
#int_year=1917
#end_year=1917

#casename=(PIC_g16_acc_nochem_1 B20TRC5_g16_acc_nochem_1)
#dirs=($dir2 $dir2)
#int_year=(238 1981)
#end_year=(406 2012)

#casename=(PIC_g16_1pctCO2_1 PIC_g16_4xCO2_1)
#dirs=($dir2 $dir2)
#int_year=(9 8)
#end_year=(113 40)

#casename=(B20TRC5_g16_acc_nochem_2)
#dirs=($dir2)
#int_year=(1850)
#end_year=(1927)

#casename=(PIcontrol_ne30s05_v22)
#dirs=($dir1)
#int_year=(716)
#end_year=(720)

#casename=(PIC_g16_4xCO2_400_start)
#dirs=($dir2)
#int_year=(1)
#end_year=(38)

casename=(PIC_g16_acc_nochem_1 PIC_g16_4xCO2_rad_1 B20TRC5_g16_acc_nochem_2 F1850C5_4xCO2_1)
dirs=($dir2 $dir2 $dir2 $dir2)
int_year=(407 10 1928 1)
end_year=(569 40 2010 37)


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
		
		sh $workdir/002_ncremap_files_params.sh $workdir ${casename[icase]} $src_dir $out_dir ${int_year[icase]} ${end_year[icase]}
	fi

done
