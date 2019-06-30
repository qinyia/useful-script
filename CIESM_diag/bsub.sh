

#job=post-process-only-globmean-multi-cases
#job=post-process-only-regrid-multi-cases
#job=post-process-only-regrid-ne120
#job=run_all_post_process
job=post-process-all3-scripts

curdir=`pwd`

echo $curdir

rm -f $curdir/$job.log

bsub -b -m 1 -p -q q_x86_cn_cess -J regrid -n 1 -o $curdir/$job.log sh $curdir/$job.sh
#bsub -b -m 1 -p -q q_x86_expr -J regrid -n 1 -o $curdir/$job.log sh $curdir/$job.sh

#bsub -b -m 1 -p -q q_x86_expr -J mydiag -n 1 -o $curdir/$job.log sh $curdir/$job.sh


