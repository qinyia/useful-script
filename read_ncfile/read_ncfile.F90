program main
use netcdf

integer, parameter :: Nudge_ncol = 48602
integer, parameter :: Nudge_nlev = 30

real                        :: Xanal(Nudge_ncol,Nudge_nlev)
real:: latval(Nudge_ncol)
real:: lonval(Nudge_ncol)

real                        :: tinfo
integer                         :: istat, varid, varid1, varid2

character(len=256) :: anal_file
character(len=1) :: vname
character(len=3) :: latname,lonname


anal_file = "./30levs/interim_se_2003040100_2003040118_TQUV_30levs.nc"
!anal_file = "./interim_se_2003040100_2003040118_TQUV.nc"
vname = "U"
latname = "lat"
lonname = "lon"

! ------- open file --------------------
istat=nf90_open(trim(anal_file),NF90_NOWRITE,ncid)
if(istat.ne.NF90_NOERR) then
       write(iulog,*)'NF90_OPEN: failed for file ',trim(anal_file)
       write(iulog,*) nf90_strerror(istat)
end if

! -------- read vname -----------------
istat = nf90_inq_varid(ncid,vname,varid)
if (istat .ne. NF90_NOERR) then
    write(iulog,*) nf90_strerror(istat)
end if

istat = nf90_get_var(ncid,varid,Xanal)
if (istat .ne. NF90_NOERR) then
    write(iulog,*) nf90_strerror(istat)
end if

! ------- read lat ---------------------
istat = nf90_inq_varid(ncid,latname,varid1)
istat = nf90_get_var(ncid,varid1,latval)

! ------ read lon ---------------------
istat = nf90_inq_varid(ncid,lonname,varid2)
istat = nf90_get_var(ncid,varid2,lonval)

! ----- print index where value is NaN -----------
do i = 1,Nudge_ncol
do j = 1,Nudge_nlev
    if (isnan(Xanal(i,j))) then
        print *, i, j, isnan(Xanal(i,j))
    end if
end do
end do

print *, Xanal(1677,:), latval(1677), lonval(1677)
print *, maxval(Xanal), minval(Xanal)

end program main
