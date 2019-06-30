
############ modify start ###################

#casename=(PIcontrol_cesm_x86 PIcontrol_ne30s05_v1 PIcontrol_ne30s05_v3 PIcontrol_ne30s05_v4 CMIP.pop2_cam_acc CMIP.slave)
#casename=(PIcontrol_cesm_x86 PIcontrol_ciesm_x86)
#casename=(PIcontrol_ne30s05_mq_v1)
#casename=(PIcontrol_ne30s05_v3_1.5cdnc)
#casename=(PIcontrol_ne30s05_v3_nomq)
#casename=(PIcontrol_ne30s05_v4_nomq)
#casename=(zjs_B1850_ne30_6mods_5400)
#casename=(PIcontrol_ne30s05_v6)
#casename=(PIcontrol_ne30s05_v3_1.5cdnc_enso2)
#casename=(PIcontrol_ne30s05_v9 PIcontrol_ne30s05_v11 PIcontrol_ne30s05_v12)
casename=(PIcontrol_ne30s05_v18)
#casename=(CMIP.pop2_cam_acc)
#casename=(PIC_s05_acc_nochem_1)
#casename=(PIC_s05_acc_nochem_2)

############ modify end ###################

ncase=${#casename[@]}

for icase in `seq 0 $[$ncase-1]`
do
	echo ${casename[icase]}
	
	### Part 2: get global mean values for all variables
## modify start
	int_year=101
	end_year=119
	ann_mean=T
	stitch=F
## modify end

	sh processing-glob-mean-all-vars-se2fv.sh ${casename[icase]} $int_year $end_year $ann_mean $stitch

done
