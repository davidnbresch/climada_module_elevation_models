ETOPO1.nc was originally named ETOPO1_Ice_g_gmt4.grd and is the full high-res topography dataset (933.5 MB!) obtained directly from 
http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/netcdf/ETOPO1_Ice_g_gmt4.grd.gz

If there is no file ETOPO1.nc in this folder, download http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/netcdf/ETOPO1_Ice_g_gmt4.grd.gz and rename it (after unzipping, if necessary) to ETOPO1.nc




We’ve tried to use an approach with only subsets, readily available on http://maps.ngdc.noaa.gov/viewers/wcs-client/ but the netCDF files of these junks did not have any position information stored, hence could not be used. Hence we resorted to the full dataset. On the positive side, this means one only has to download this big data (zipped for download only 377 MB) only once and gets full global coverage. Downside is the mere fact that the date occupies almost 1GB…

Below a) the detailed description how the junk can be obtained and b) more info about ETOPO1.

a) etopo1.nc contains a junk of the global elevation (and bathymetry) data in high resolution. For global coverage in reasonable resolution see _etopo2_reademe.txt

NOTE: please manage your etopo1-.nc junks yourself, e.g. by naming them accordingly,
like etopo1_XXX.nc …

To get a junk, use http://maps.ngdc.noaa.gov/viewers/wcs-client/ 
1. Choose Layer: ETOPO1 (ice)
2. Select an area from the map (use the (i) to interactively select)
3. Choose output format: NetCDF
4. Download the data
and then move the generated file to ../data/topo/..

all found here: http://www.ngdc.noaa.gov/mgg/global/global.html


b) the content of http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/netcdf/readme_etopo1_netcdf.txt:

ETOPO1 was built using GMT 4.3.1 (http://gmt.soest.hawaii.edu/), development
version/CVS.

GMT 4.3.1 creates grids in netCDF COARDS-compliant format. This is the format 
of the "gmt4" version in this directory, and is recommended for GMT 4 users. 

Some older versions of GDAL (http://www.gdal.org/) do not properly read the
netcdf grids created by GMT 4 (grids are inverted south to north).  If you are
using an older version of GDAL and encounter this problem you can work around
the problem a couple different ways.  If you have a version of GMT installed,
you can reformat the netcdf grid to a depreciated netcdf file that older GDAL
will read correctly, you can do this with the following command:
$ grdreformat Etopo1_gmt4.grd Etopo1_gdal.grd=cf

Another option would be to obtain the geotiff version of ETOPO1, found at the
following address:
http://www.ngdc.noaa.gov/mgg/global/global.html

Newer versions of GDAL should correctly read the gmt4 netcdf grids.

Please contact me if you have problems with ETOPO1.

Barry W. Eakins
barry.eakins@noaa.gov

ETOPO1 1 Arc-Minute Global Relief Model
http://www.ngdc.noaa.gov/mgg/global/global.html

