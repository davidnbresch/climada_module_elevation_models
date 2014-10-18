climada_module_etopo
====================

ETOPO topography (worldwide, high-res)

In order to grant core climada access to additional modules, create a folder ‘modules’ in the core climada folder and copy/move any additional modules into climada/modules, without 
'climada_module_' in the filename. 

This module implements ETOPO, a global bathymetry (and topography) dataset . It’s a separate module, since topographic (and bathymetry) information can be used in various contexts – and since the dataset is quite large (ETOPO1 is 933 MB, ETOPO2 still 233 MB). 

The module does NOT contain the dataset, please proceed as follows:
1.	Download the file http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/netcdf/ETOPO1_Ice_g_gmt4.grd.gz
2.	Move it to .../etopo/data/
3.	Unzip it (it might do so automatically, e.g. on a Mac)
4.	Rename it to ETOPO1.nc
5.	Test it using etopo_get without any argument

In order to grant core climada access to additional modules, create a folder ‘modules’ in the core climada folder and copy/move any additional modules into climada/modules, without 'climada_module_' in the filename. 

E.g. if the addition module is named climada_module_MODULE_NAME, we should have
.../climada the core climada, with sub-folders as
.../climada/code
.../climada/data
.../climada/docs
and then
.../climada/modules/MODULE_NAME with contents such as 
.../climada/modules/MODULE_NAME/code
.../climada/modules/MODULE_NAME/data
.../climada/modules/MODULE_NAME/docs
this way, climada sources all modules' code upon startup

see climada/docs/climada_manual.pdf to get started

copyright (c) 2014, David N. Bresch, david.bresch@gmail.com all rights reserved.

