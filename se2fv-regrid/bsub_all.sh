
job=002_ncremap_files
curdir=`pwd`

echo $curdir

\rm $job.log

#bsub -b -m 1 -p -q q_x86_cn_cess -J se2fv-regrid -n 1 -o $curdir/$job.log sh $curdir/$job.sh

bsub -b -m 1 -p -q q_x86_expr -J se2fv-regrid -n 1 -o $curdir/$job.log sh $curdir/$job.sh

