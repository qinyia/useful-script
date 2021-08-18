
# Note: must include the directory of netcdf and netcdff libraries. 

# ---- turn on "-fpe0" option [trigger error when NC file includes NaN.]
mpiifort -O2 -fp-model source -convert big_endian -assume byterecl -ftz -traceback -g -CU -check pointers -fpe0 -o out netcdf_read.F90 -I/home/share/cesm/software/esm-soft/include -L/home/share/cesm/software/esm-soft/lib -lnetcdff  -L/home/share/cesm/software/esm-soft/lib -lnetcdff -lnetcdf -lpnetcdf -lhdf5_hl -lhdf5 -ldl -lm -lz -lcurl

# ---- turn off "-fpe0" option [will not trigger error when NC file includes NaN.]
#mpiifort -O2 -fp-model source -convert big_endian -assume byterecl -ftz -traceback -g -CU -check pointers -o out netcdf_read.F90 -I/home/share/cesm/software/esm-soft/include -L/home/share/cesm/software/esm-soft/lib -lnetcdff  -L/home/share/cesm/software/esm-soft/lib -lnetcdff -lnetcdf -lpnetcdf -lhdf5_hl -lhdf5 -ldl -lm -lz -lcurl
