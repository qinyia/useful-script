
############ modify start ###################

#casename=(PIcontrol_ne30s05_v11 PIcontrol_ne30s05_v18)
#casename=(PIcontrol_ne30s05_v18)
#casename=(PIC_s05_acc_nochem_1 PIcontrol_ne30s05_v11 PIcontrol_ne30s05_v18)
#casename=(PIC_s05_acc_nochem_2 PIcontrol_ne30s05_v11 PIcontrol_ne30s05_v18)
#casename=(PIC_s05_acc_nochem_1 PIC_s05_acc_nochem_2 PIcontrol_ne30s05_v11 PIcontrol_ne30s05_v18)

casename=(PIcontrol_ne30s05_v11 PIcontrol_ne30s05_v18 PIC_s05_acc_nochem_1 PIC_s05_acc_nochem_2)

int_year=(1 1 1 1)
end_year=(231 135 61 18) 

############ modify end ###################

ncase=${#casename[@]}

for icase in `seq 0 $[$ncase-1]`
do
	echo ${casename[icase]}
	
	### Part 2: get global mean values for all variables
## modify start
#	int_year=1
#	end_year=119
	ann_mean=F
	stitch=T
## modify end

	sh processing-glob-mean-all-vars-se2fv.sh ${casename[icase]} ${int_year[icase]} ${end_year[icase]} $ann_mean $stitch

done
