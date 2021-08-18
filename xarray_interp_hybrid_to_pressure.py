
# Aug 16, 2021: use interp_hybrid_to_pressure function from geocat to vertically interpolate hybrid level to pressure level. This function can work on SE grid data, but NCL vint2p cannot do this.

# reference of geocat: https://geocat-comp.readthedocs.io/en/latest/installation.html
# conda activate geocat

# Aug 17, 2021: left questions: time dimension is not 'unlimited'
# /home/lyl/WORK3/qinyi/data/LS4P_nudging/vert_regrid.py

import numpy as np
import xarray as xr
from geocat.comp import interp_hybrid_to_pressure
import os

outdir = "/home/lyl/WORK3/qinyi/data/LS4P_nudging/30levs/"

f1 = xr.open_dataset("FAMIPC5_ne30ne30_CIESM_LS4P_2003.01_200.cam.h0.2003-02.nc")
cld = f1['CLOUD']
lev1 = cld.coords['lev']
hyam1 = f1['hyam']
hybm1 = f1['hybm']

new_levels = lev1.values * 100. ## convert to Pascals

# =============================
days = range(1,30,1)

vars = ["U","V","T","Q"]

for iday,day in enumerate(days):

    day2d = "{:02d}".format(day)

    print("========================================================")
    print("We are processing day-"+day2d)
    print("========================================================")
    
    dics = {}
    attrs = {}

    fname = "interim_se_200304"+day2d+"00_200304"+day2d+"18_TQUV"
    f2 = xr.open_dataset(fname+".nc")
    varlist = f2.data_vars
    print(list(varlist))
    for svar in list(varlist):
        data = f2[svar]
        if svar not in vars+['hyam','hybm','hyai','hybi']:
            print(svar)
            dics[svar] = data
            attrs[svar] = data.attrs

    # additional copy hyam and hybm from f1 file
    dics['hyam'] = hyam1
    dics['hybm'] = hybm1
    attrs['hyam'] = hyam1.attrs
    attrs['hybm'] = hybm1.attrs


    for ivar,svar in enumerate(vars):
        print(svar)
        datain = f2[svar]
        hyam = f2.hyam
        hybm = f2.hybm
        ps = f2.PS
        p0 = 100000
        lev = f2.lev

        lat = f2.lat
        lon = f2.lon

        print(np.min(datain.values))
        print(np.max(datain.values))
        
        # Interpolate pressure coordinates form hybrid sigma coord
        data_int_tmp = interp_hybrid_to_pressure(datain,
                                  ps,
                                  hyam,
                                  hybm,
                                  p0=p0,
                                  new_levels=new_levels,
                                  method='log')

        # fill np.nan by the last non-missing values
        print(data_int_tmp)
        data_int = data_int_tmp.interpolate_na(dim="plev",method="linear", fill_value="extrapolate")

        nn = 1108
        print('lat=',lat[nn].values, 'lon=', lon[nn].values)
        print('new_levels=',new_levels/100)
        print('lev=',lev.values)
        print('data_int_tmp=',data_int_tmp[0,:,nn].values)
        print('data_int=',data_int[0,:,nn].values)
        print('datain=',datain[0,:,nn].values)

        print(np.nanmin(data_int.values))
        print(np.nanmax(data_int.values))


        dics[svar] = (["time","lev","ncol"],data_int.values)
        attrs[svar] = datain.attrs

        time = data_int.coords['time']
        ncols = data_int.coords['ncol']

    print(dics.keys())
    
    # --- define dataset
    ds = xr.Dataset(
         dics,
         coords={
             "time": time,
             "lev": lev1.values,
             "ncol": ncols.astype('i4'),
         },
     )


    # copy attribttes
    for svar in dics.keys():
        for attr in attrs[svar].keys():
            print(svar,attr)
            ds[svar].attrs[attr] = attrs[svar][attr]

    # =============================================
    encoding = {}
    for svar in ds.keys():
        if svar in vars:
            print('svar=',svar)
            encoding[svar] = {'_FillValue': 1e20,'zlib': True}

    print(ds)
    ds.to_netcdf(outdir+fname+"_30levs.nc", encoding=encoding)
#    os.system('ncdump -h '+outdir+fname+"_30levs.nc")
