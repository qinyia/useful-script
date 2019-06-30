
datadir=/GPFS/cess1/se2fv-regrid/rgr_out/
#/GFPS8p/cess/liangys/ciesm_1.1.0/ciesm.run/

vars=(gw,FSNT,FLNT)

case=B20TRC5_ne30s05_v1

workdir=/GPFS/cess1/my-diag/$case

if [ ! -d "$workdir" ]; then
mkdir $workdir
fi

tmpdir=$datadir/$case/
cd $tmpdir
echo `ls *cam.h0*`

cd $workdir

# ncrcat all files
ncrcat -O -v $vars $tmpdir/*cam.h0* $case.month.ncrcat.nc

# get the TOM imbalance
ncap2 -O -s 'RESTOM=FSNT-FLNT' $case.month.ncrcat.nc $case.month.RESTOM.nc

cp $case.month.ncrcat.nc $case.diag.nc

ncks -A $case.month.RESTOM.nc $case.diag.nc

# get global mean 
ncwa -O -a lon,lat -w gw $case.diag.nc $case.diag.globmean.nc

