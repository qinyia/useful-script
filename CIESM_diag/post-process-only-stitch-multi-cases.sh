
############ modify start ###################

#casename=(PIcontrol_ne30s05_v11 PIcontrol_ne30s05_v18)
#casename=(PIcontrol_ne30s05_v18)
#casename=(PIC_s05_acc_nochem_1 PIcontrol_ne30s05_v11 PIcontrol_ne30s05_v18)
#casename=(PIC_s05_acc_nochem_2 PIcontrol_ne30s05_v11 PIcontrol_ne30s05_v18)
#casename=(PIC_s05_acc_nochem_1 PIC_s05_acc_nochem_2 PIcontrol_ne30s05_v11 PIcontrol_ne30s05_v18)

#casename=(B20TRC5_ne30s05_v1)
#int_year=1850
#end_year=1916

#casename=(PIC_g16_acc_nochem_1)
#dirs=($dir2)
#int_year=1
#end_year=110

#casename=(PIcontrol_cesm_x86 PIcontrol_ciesm_x86)
#int_year=(1 1)
#end_year=(100 100)

#casename=(PIC_g16_acc_nochem_1 PIC_g16_acc_nochem_2 B20TRC5_g16_acc_nochem_1 PIC_g16_4xCO2_1)
#int_year=(1 101 1850 101)
#end_year=(237 217 1980 264)

#casename=(PIC_g16_1pctCO2_1 PIC_g16_4xCO2_1)
#int_year=(1 1)
#end_year=(113 40)

#casename=(PIC_g16_acc_nochem_1 B20TRC5_g16_acc_nochem_1)
#int_year=(1 1850)
#end_year=(406 2012)

#casename=(PIC_g16_acc_nochem_1)
#int_year=(1)
#end_year=(569)


casename=(B20TRC5_g16_acc_nochem_1 B20TRC5_g16_acc_nochem_2)
int_year=(1850 1850)
end_year=(2010 2010)

#casename=(PIcontrol_ne30s05_v22)
#int_year=(700)
#end_year=(720)

#casename=(PIC_g16_4xCO2_rad_1 PIC_g16_4xCO2_1)
#int_year=(1 1)
#end_year=(9 9)


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

	sh processing-glob-ann-mean-all-vars-se2fv.sh ${casename[icase]} ${int_year[icase]} ${end_year[icase]} $ann_mean $stitch
#	sh processing-glob-season-mean-all-vars-se2fv.sh ${casename[icase]} ${int_year[icase]} ${end_year[icase]} $ann_mean $stitch

done
