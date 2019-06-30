module load x86/Anaconda/3-5.2.0

workdir=`pwd`
#casename=PIcontrol_ne30s05_v1
casename=CMIP.slave

cd $workdir

# part 1: get the source and destination file
#ncks -v CLDLIQ PIcontrol_cesm_x86.cam.h0.0107-03.nc in.nc
#ncks -v CLDLIQ FC5_f19f19_mac3.cam.h0.0001-01.nc out.nc

# part 2: use NCL to get the weighting file: SE_NE30_to_FV_96x144.bilinear.nc
#ncl get_weight.ncl

# part 3: use ncremap to regrid from SE to FV 
# drc_in is the source file directory (SE grid)
# rgr is the destination file (FV grid)

mapfile=SE_NE30_to_FV_96x144.bilinear.nc

#src_dir=/home/export/online1/qhtest/swqh/dingnan/ZC/CIESM/ciesm.run/${casename}/run/
#src_dir=/GPFS/cess/liangys/ciesm_1.1.0/ciesm.run/${casename}/run/
src_dir=/home/export/online1/qhtest/swqh/dingnan/ZC/CIESM/ciesm.run/${casename}/run/

out_dir=../rgr_out/${casename}
echo $out_dir

if [ ! -d "$out_dir" ];then
	mkdir -p $out_dir
fi
echo $src_dir
echo $out_dir

# for all variables in input files
#ncremap -I $src_dir -m ${mapfile} -O $out_dir
ls $src_dir/*cam.h0.* | ncremap -m ${mapfile} -O $out_dir

# for sampling variables
#varlist=(CLDLOW,CLDTOT)
#ncremap -v ${varlist} -I ./drc_in -m ${mapfile} -O ./rgr
