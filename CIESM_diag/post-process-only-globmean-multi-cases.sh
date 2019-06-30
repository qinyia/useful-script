
############ modify start ###################

#casename=(PIcontrol_cesm_x86 PIcontrol_ciesm_x86)
#int_year=(1 1)
#end_year=(100 100)
#casename=(PIcontrol_ne30s05_v18)
#casename=(PIC_s05_acc_nochem_1)

#casename=(PIcontrol_ne30s05_v11 PIcontrol_ne30s05_v18 PIC_s05_acc_nochem_1 PIC_s05_acc_nochem_2)
#int_year=(200 119 26 1)
#end_year=(231 135 61 18) 
#end_year=(200 119 26 1)

#casename=(PIcontrol_ne30s05_v11 PIcontrol_ne30s05_v18 PIC_s05_acc_nochem_1 PIC_s05_acc_nochem_2 PIC_s05_acc_nochem_4)
#int_year=(232 136 62 19 201)
#end_year=(253 151 71 37 216)

#casename=(PIC_g16_acc_nochem_1)
#dirs=($dir2)
#int_year=78
#end_year=110

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

casename=(PIC_g16_4xCO2_rad_1 PIC_g16_4xCO2_1)
dirs=($dir2 $dir2)
int_year=(1 1)
end_year=(9 9)


############ modify end ###################

ncase=${#casename[@]}

for icase in `seq 0 $[$ncase-1]`
do
	echo ${casename[icase]}
	
	### Part 2: get global mean values for all variables
## modify start
#	int_year=101
#	end_year=119
	ann_mean=T
	stitch=F
## modify end

#	sh processing-glob-mean-all-vars-se2fv.sh ${casename[icase]} ${int_year[icase]} ${end_year[icase]} $ann_mean $stitch
	sh processing-glob-season-mean-all-vars-se2fv.sh ${casename[icase]} ${int_year[icase]} ${end_year[icase]} $ann_mean $stitch

done
