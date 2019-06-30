
############ modify start ###################
regrid=T

#casename=(CMIP.slave)
#casename=(PIcontrol_ne30s05_v1 PIcontrol_ne30s05_v3 PIcontrol_ne30s05_v4 PIcontrol_ne30s05_v5)
#casename=(PIcontrol_ne30s05_v1 PIcontrol_ne30s05_v3 PIcontrol_ne30s05_v4)
#casename=(PIcontrol_ne30s05_v1 CMIP.pop2_cam_acc)
#casename=(PIcontrol_ne30s05_v1 PIcontrol_ne30s05_v3 PIcontrol_ne30s05_v4 CMIP.pop2_cam_acc)
casename=(PIcontrol_ne30s05_v3)

############ modify end ###################

ncase=${#casename[@]}

for icase in `seq 0 $[$ncase-1]`
do
	echo ${casename[icase]}

	### Part 1: regrid from SE to FV grid for all monthly dataset
	if [ "$regrid" == "T" ];then
	
		workdir=/GPFS/cess1/se2fv-regrid/scripts/
## modify start
#		src_dir=/home/export/online1/qhtest/swqh/dingnan/ZC/CIESM/ciesm.run/${casename[icase]}/run/
		src_dir=/GPFS/cess/liangys/ciesm_1.1.0/ciesm.run/${casename[icase]}/run/
## modify end
		out_dir=/GPFS/cess1/se2fv-regrid/rgr_out/${casename[icase]}
		
		sh $workdir/002_ncremap_files_params.sh $workdir ${casename[icase]} $src_dir $out_dir
	fi
	
	### Part 2: get global mean values for all variables
## modify start
	int_year=1
	end_year=11
	ann_mean=T
	stitch=T
## modify end

	sh processing-glob-mean-all-vars-se2fv.sh ${casename[icase]} $int_year $end_year $ann_mean $stitch

done
