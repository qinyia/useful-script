
############ modify start ###################
regrid=T

#dir1=/GPFS/cess/liangys/ciesm_1.1.0/ciesm.run/
dir1=/GFPS8p/cess/liangys/ciesm_1.1.0/ciesm.run/
dir2=/home/export/online1/cess9/zhangcheng/ciesm_1.1.0/ciesm.run/
dir3=/home/export/online1/qhtest/swqh/dingnan/ZC/CIESM/ciesm.run/
dir4=/GPFS/cess/liangys/cesm/cesm.run/
dir5=/home/export/online1/qhtest/swqh/USER-TSINGHUA/dingnan/2017/cesm.run/

int_year=101
end_year=119

#casename=(zjs_B1850_ne30_6mods_5400)
#dirs=($dir5)

casename=(PIcontrol_ne30s05_v18)
dirs=($dir1)

#casename=(PIC_s05_acc_nochem_2)
#dirs=($dir2)

#casename=(CMIP.pop2_cam_acc)
#dirs=($dir2)

#casename=(PIcontrol_ne30s05_v1 PIcontrol_ne30s05_v3 PIcontrol_ne30s05_v4 CMIP.pop2_cam_acc CMIP.slave)
#dirs=($dir1 $dir1 $dir1 $dir2 $dir3)

#casename=(PIcontrol_cesm_x86 PIcontrol_ciesm_x86)
#dirs=($dir4 $dir1)

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
		
		sh $workdir/002_ncremap_files_params.sh $workdir ${casename[icase]} $src_dir $out_dir $int_year $end_year
	fi

done
