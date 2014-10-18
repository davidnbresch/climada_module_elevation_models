function ETOPO=etopo_get(etopo_coords)
% climada topography ETOPO bathymetry
% NAME:
%   etopo_get
% PURPOSE:
%   get a chunk of the global ETOPO elevation (and bathymetry) dataset.
%
%   Test it calling etopo_get without any argument (you should get an area
%   around Switzerland)
%
%   There are two datasets, ETOPO1 in high-res and ETOPO2 in mid-res. See
%   http://www.ngdc.noaa.gov/mgg/global/global.html and the readme files in
%   .../etopo/data. Since ETOPO1 is globally consistent, it?s use is highly
%   recommended (use ETOPO2 only if e.g. running in memory issues).
%
%   If there is no data file, means no file .../etopo/data/ETOPO1.nc,
%   proceed as follows:
%   1. Download the file
%      http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/netcdf/ETOPO1_Ice_g_gmt4.grd.gz
%   2. Move it to .../etopo/data/
%   3. Unzip it (it might do so automatically, e.g. on a Mac)
%   4. Rename it to ETOPO1.nc
%   5. Test it using etopo_get without any argument (you should get an area
%      around Switzerland)
%
% CALLING SEQUENCE:
%   ETOPO=etopo_get(etopo_coords)
% EXAMPLE:
%   ETOPO=etopo_get([4 14 43 53])
% INPUTS:
%   etopo_coords: the rectangle to get topography within
%       [lonmin lonmax latmin latmax]
%       if empty (or not provided): TEST mode, you should get an area
%       around Switzerland - and the elevation is plotted, too.
% OPTIONAL INPUT PARAMETERS:
% OUTPUTS:
%   ETOPO: a structure, with
%       x(i,j): the longitude coordinates
%       y(i,j): the latitude coordinates
%       h(i,j): the elevation [m, negative below sea level]
%       sourcefile: the source file (.../ETOPO1.nc)
% MODIFICATION HISTORY:
% David N. Bresch, david.bresch@gmail.com, 20140422
%-

ETOPO=[]; % init output

global climada_global
if ~climada_init_vars,return;end % init/import global variables

% poor man's version to check arguments
if ~exist('etopo_coords','var'),etopo_coords=[];end

% PARAMETERS
%
% The etopometry dataset (ETOPO1 high res, ETOPO2 mid res). Note that
% ETOPO2 is not as consistent as ETOPO1, hence ETOPO1 is highly recommended
% See the readme files in the folder the ETOPO data resides
%etopo_data_file=[climada_global.modules_dir filesep 'etopo' filesep 'data' filesep 'ETOPO2.nc'];
etopo_data_file=[climada_global.modules_dir filesep 'etopo' filesep 'data' filesep 'ETOPO1.nc'];
%
check_plot=0; % wheher a check plot (=1) or not (=0)

% TEST only (hard-wired area and check plot
if isempty(etopo_coords),etopo_coords=[4 14 43 53];check_plot=1;end

% open netCDF file and read etopo rectangle
% -----------------------------------------

if ~exist(etopo_data_file,'file')
    fprintf('ERROR: ETOPO data file not found: %s\n',etopo_data_file);
    return
else
    fprintf('reading ETOPO data from %s\n',etopo_data_file);
    %info=ncinfo(etopo_data_file); % easiest way to test for nc
end

% read the coords
x  = ncread(etopo_data_file,'x');
y  = ncread(etopo_data_file,'y');

% figure which subset of the etopometry to obtain
Lon1=etopo_coords(1); Lon2=etopo_coords(2);
Lat1=etopo_coords(3); Lat2=etopo_coords(4);

inds=1:numel(x); inds=inds(:);
if Lon1<0
    startx = floor(interp1(x,inds,Lon1)); % x(startx)
else
    startx = ceil(interp1(x,inds,Lon1)); % x(startx)
end
if Lon2<0
    endx   = ceil (interp1(x,inds,Lon2)); % x(endx)
else
    endx   = floor (interp1(x,inds,Lon2)); % x(endx)
end
inds=1:numel(y);
if Lat1>0
    starty = floor(interp1(y,inds,Lat1)); % y(starty)
else
    starty = ceil(interp1(y,inds,Lat1)); % y(starty)
end
if Lat2>0
    endy   = ceil (interp1(y,inds,Lat2)); % y(endy)
else
    endy   = floor (interp1(y,inds,Lat2)); % y(endy)
end

countx=endx-startx-1; % x(startx+countx)
county=endy-starty+1; % y(starty+county)

% z  = ncread(file,'z',[1 3000], [Inf Inf]); % the full dataset

% read the required subset of the global dataset
ETOPO.h = ncread(etopo_data_file,'z',[startx starty], [countx+1 county+1]);
ETOPO.h=ETOPO.h'; % transpose to fit meshgrid definition (see next line)

% create the grid
[ETOPO.x,ETOPO.y]=meshgrid(x(startx:startx+countx), y(starty:starty+county));

ETOPO.sourcefile=etopo_data_file;

if check_plot
    figure('Name','ETOPO','Color',[1 1 1]);
    pcolor(ETOPO.x,ETOPO.y,ETOPO.h)
    hold on
    shading interp
    colorbar;
    caxis;
    axis equal
    climada_plot_world_borders
    axis(etopo_coords);
end

% netcdf.close(etopo_data_file) % seems not be required

return
