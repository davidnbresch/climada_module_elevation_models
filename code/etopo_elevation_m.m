function elevation_m=etopo_elevation_m(lon,lat,check_plot)
% climada elevation m etopo
% MODULE:
%   etopo
% NAME:
%   etopo_elevation_m
% PURPOSE:
%   obtain elevation in m (based on ETOPO)
%
%   See etopo_get for any further information about ETOPO. See
%   http://www.ngdc.noaa.gov/mgg/global/global.html and the readme files in
%   .../etopo/data. Since ETOPO1 is globally consistent, its use is highly
%   recommended (use ETOPO2 only if e.g. running in memory issues).
% CALLING SEQUENCE:
%   elevation_m=etopo_elevation_m(lon,lat,check_plot)
% EXAMPLE:
%   elevation_m=etopo_elevation_m(lon,lat)
% INPUTS:
%   lon: vector of longitues
%   lat: vector of latitudes
% OPTIONAL INPUT PARAMETERS:
%   check_plot: =1: show circle plot for check, only works for more than
%       one point
%       =0: no plot (default)
% OUTPUTS:
%   elevation_m: elevation in m for each lat/lon (ocean depth for below sea
%       level)
% MODIFICATION HISTORY:
% David N. Bresch, david.bresch@gmail.com, 20141226, initial
%-

elevation_m=[]; % init output

%%global climada_global
if ~climada_init_vars,return;end % init/import global variables

% poor man's version to check arguments
if ~exist('lon','var'),return;end
if ~exist('lat','var'),return;end
if ~exist('check_plot','var'),check_plot=0;end

% locate the module's data
%module_data_dir=[fileparts(fileparts(mfilename('fullpath'))) filesep 'data'];

% PARAMETERS

minlon=floor(min(lon));
maxlon=ceil(max(lon));
minlat=floor(min(lat));
maxlat=ceil(max(lat));

if minlon==maxlon,maxlon=maxlon+1;end
if minlat==maxlat,maxlat=maxlat+1;end

BATI=etopo_get([minlon maxlon minlat maxlat]);

if ~isempty(BATI)
    elevation_m=interp2(BATI.x,BATI.y,BATI.h,lon,lat);
    % no else and message, error messages from etopo_get already
end

if check_plot
   % climada_color_plot(elevation_m,lon,lat)
    climada_circle_plot(elevation_m,lon,lat)
end

end
