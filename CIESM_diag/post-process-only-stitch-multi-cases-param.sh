
############ modify start ###################

casename=$1
int_year=$2
end_year=$3

############ modify end ###################

ncase=${#casename[@]}

for icase in `seq 0 $[$ncase-1]`
do
	echo ${casename[icase]}
	### Part 2: get global mean values for all variables
## modify start
	ann_mean=F
	stitch=T
## modify end

#	sh processing-glob-mean-all-vars-se2fv.sh ${casename[icase]} ${int_year[icase]} ${end_year[icase]} $ann_mean $stitch
	sh processing-glob-season-mean-all-vars-se2fv.sh ${casename[icase]} ${int_year[icase]} ${end_year[icase]} $ann_mean $stitch

done
