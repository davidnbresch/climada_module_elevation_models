climada_module_etopo
====================

ETOPO topography (worldwide, high-res)

This module implements ETOPO, a global bathymetry (and topography) dataset . It’s a separate module, since topographic (and bathymetry) information can be used in various contexts – and since the dataset is quite large (ETOPO1 is 933 MB, ETOPO2 still 233 MB). 

The module does NOT contain the dataset, please proceed as follows:
1.	Download the file http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/netcdf/ETOPO1_Ice_g_gmt4.grd.gz
2.	Move it to .../etopo/data/
3.	Unzip it (it might do so automatically, e.g. on a Mac)
4.	Rename it to ETOPO1.nc
5.	Test it using etopo_get without any argument

(c) david.bresch@gmail.com
