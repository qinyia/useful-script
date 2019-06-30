
############ modify start ###################

#casename=(PIcontrol_ne30s05_v9 PIcontrol_ne30s05_v11 PIcontrol_ne30s05_v12)

casename1=(PIcontrol_ne30s05_v11)
casename2=(PIcontrol_ne30s05_v18)

############ modify end ###################

ncase=${#casename2[@]}

for icase in `seq 0 $[$ncase-1]`
do
	echo ${casename2[icase]}
	
## modify start
	int_year=1
	end_year=9
	difference=T
## modify end

	sh processing-difference.sh $casename1 ${casename2[icase]} $int_year $end_year $difference

done
