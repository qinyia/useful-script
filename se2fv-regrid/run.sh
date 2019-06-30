
workdir=/GPFS/cess1/se2fv-regrid/scripts/
casename=CMIP.slave

src_dir=/home/export/online1/qhtest/swqh/dingnan/ZC/CIESM/ciesm.run/${casename}/run/
out_dir=/GPFS/cess1/se2fv-regrid/rgr_out/${casename}

echo $src_dir
echo $out_dir

sh $workdir/002_ncremap_files_params.sh $workdir $casename $src_dir $out_dir
