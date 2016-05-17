function [entity,centroids,SRTM_info]=climada_srtm_entity(centroidsORcountryORshapes,check_plot)
% climada template
% MODULE:
%   elevation_models
% NAME:
%   climada_srtm_entity
% PURPOSE:
%   Starting grom SRTM digital elevation model (90m), construct a country
%   entity an the corresponding centroids, save both with standard names,
%   i.e. III_{country_name}_SRTM_{entity|centroids}, with III the 3-digit
%   iso code and country_name with no spaces, e.g. UnitedStates.
%
%   check using climada_entity_plot and climada_centroids_plot
%   please note that you need to run climada_EDS_calc with
%   force_re_encode=1 unless you re-generate the hazard with the controids
%   as generated here. Even better, run climada_assets_encode and save the
%   encoded entity (
% CALLING SEQUENCE:
%   entity=climada_srtm_entity(centroidsORcountryORshapes,check_plot)
% EXAMPLE:
%   entity=climada_srtm_entity('Tuvalu')
% INPUTS:
%   centroidsORcountryORshapes:  can be a country_name 'El Salvador', or
%       coordinates of the rectangle box to get topography within [lonmin lonmax latmin latmax]
%       or centroids (as e.g. from climada_centroids_load)
%       handed over to climada_srtm_get, see there
% OPTIONAL INPUT PARAMETERS:
%   check_plot: show a check plot, if =1, (default=0)
%       if negative, omit calculation of distance2coast_km (which easily
%           takes a few minutes)
% OUTPUTS:
%   entity: a climada entity structure, see climada_entity_read for format
%       description
%   centroids: a climada centroids structure, see climada_centroids_read
%   SRTM_info: just handed over from climada_srtm_get, see there
% MODIFICATION HISTORY:
% David N. Bresch, david.bresch@gmail.com, 20160514, initial (Rotterdam)
% David N. Bresch, david.bresch@gmail.com, 20160516, full compatibility with eg centroids_generate_hazard_sets
%-

entity=[];centroids=[];SRTM_info=[]; % init output

global climada_global
if ~climada_init_vars,return;end % init/import global variables

%%if climada_global.verbose_mode,fprintf('*** %s ***\n',mfilename);end % show routine name on stdout

% poor man's version to check arguments
% and to set default value where  appropriate
if ~exist('centroidsORcountryORshapes','var'),centroidsORcountryORshapes=[];end
if ~exist('check_plot','var'),check_plot=0;end

% locate the module's (or this code's) data folder (usually  afolder
% 'parallel' to the code folder, i.e. in the same level as code folder)
%module_data_dir=[fileparts(fileparts(mfilename('fullpath'))) filesep 'data'];

% PARAMETERS
%
% define all parameters here - no parameters to be defined in code below
%
% the spacing of the inner and denser regular grid to cover sea points (in degrees)
grid_spacing1=.01; % default=.01, hence approx 1km
grid_distance_km1=100; % the extent of the denser grid from coast in km
% the spacing of the outer and coarser regular grid to cover sea points (in degrees)
grid_spacing2=1; % default=1, hence approx 100km
%grid_spacing2=.05; % default=1, hence approx 100km
grid_distance_km2=1000; % the extent of the coarser grid from coast in km
%
% extension of the entity filename, III_{country_name}_SRTM_{entity|centroids}
entity_filename_ext='SRTM'; % default SRTM
%
% set the template entity (to read dummy damagefucntions from)
template_entity_filename=[climada_global.data_dir filesep 'entities' ...
    filesep 'entity_template' climada_global.spreadsheet_ext];
%

[SRTM,SRTM_info]=climada_srtm_get(centroidsORcountryORshapes,abs(check_plot));

% construct the entity
% --------------------

entity.assets.comment=[num2str(centroidsORcountryORshapes) ' created by ' mfilename];
entity.assets.filename=SRTM.filename;
n_elements=numel(SRTM.x);
entity.assets.elevation_m=reshape(SRTM.h,1,n_elements);
% keep only non-zero points (as we do not need 90m resolution on sea)
nonzero_pos=find(entity.assets.elevation_m>0);
entity.assets.elevation_m=double(entity.assets.elevation_m(nonzero_pos));
fprintf('%i (%2.1f%%) points above zero\n',length(entity.assets.elevation_m),...
    length(entity.assets.elevation_m)/n_elements*100);
entity.assets.lon        =reshape(SRTM.x,1,n_elements);
boundary_rect(1)=floor(min(entity.assets.lon));boundary_rect(2)=ceil(max(entity.assets.lon));
entity.assets.lon        =double(entity.assets.lon(nonzero_pos));
entity.assets.lat        =reshape(SRTM.y,1,n_elements);
boundary_rect(3)=floor(min(entity.assets.lat));boundary_rect(4)=ceil(max(entity.assets.lat));
entity.assets.lat        =double(entity.assets.lat(nonzero_pos));
entity.assets.Value      =entity.assets.elevation_m; % use elevation as Value to start with
entity.assets.Deductible =entity.assets.Value*0;
entity.assets.Cover      =entity.assets.Value;
entity.assets.DamageFunID=entity.assets.Deductible+1;
entity.assets.reference_year=climada_global.present_reference_year;
entity.assets.centroid_index=1:length(entity.assets.lon); % construct
[admin0_name,admin0_ISO3]=climada_country_name(centroidsORcountryORshapes);
entity.assets.admin0_name=admin0_name;
entity.assets.admin0_ISO3=admin0_ISO3;

if ~isfield(entity.assets,'distance2coast_km') && check_plot>=0 
    % it takes a bit of time to calculate
    % climada_distance2coast_km, but the windfield calcuklation is
    % much faster that way (see climada_tc_windfield)
    fprintf('adding distance2coast_km, does take time (a few minutes, but worth the effort)\n')
    entity.assets.distance2coast_km=double(climada_distance2coast_km(entity.assets.lon,entity.assets.lat));
end

% also construct centroids
% ------------------------

fprintf('adding inner regular grid (a few minutes, but worth the effort)\n')
% add a regular grid around (for nice plotting etc.)
% first, inner grid, denser
[lon1,lat1] = meshgrid(boundary_rect(1):grid_spacing1:boundary_rect(2),...
    boundary_rect(3):grid_spacing1:boundary_rect(4));
n_elements=numel(lon1);
lon1=reshape(lon1,1,n_elements);lat1=reshape(lat1,1,n_elements); % convert to vector
%[distance2coast_km,lon1,lat1]=climada_distance2coast_km(lon1,lat1,0,0,-grid_distance_km1);
[distance2coast_km,lon1,lat1]=climada_distance2coast_km(lon1,lat1);
grid_distance_pos=find(distance2coast_km>0 & distance2coast_km<=grid_distance_km1);
lon1=lon1(grid_distance_pos);
lat1=lat1(grid_distance_pos);
% second, outer grid, coarser
fprintf('adding outer regular grid (a few minutes, but worth the effort)\n')
[lon2,lat2] = meshgrid(boundary_rect(1):grid_spacing2:boundary_rect(2),...
    boundary_rect(3):grid_spacing2:boundary_rect(4));
n_elements=numel(lon2);
lon2=reshape(lon2,1,n_elements);lat2=reshape(lat2,1,n_elements); % convert to vector
%[distance2coast_km,lon2,lat2]=climada_distance2coast_km(lon2,lat2,0,0,-grid_distance_km2);
[distance2coast_km,lon2,lat2]=climada_distance2coast_km(lon2,lat2);
grid_distance_pos=find(distance2coast_km>0 & distance2coast_km<=grid_distance_km2);
lon=[lon1 lon2(grid_distance_pos)];
lat=[lat1 lat2(grid_distance_pos)];
% remove duplicates
[~,unique_pos]=unique(lon+lat*1i); % use complex notation to make lon/lat tuples unique
lon=lon(unique_pos);lat=lat(unique_pos);

centroids.lon=double([entity.assets.lon lon]); % append
centroids.lat=double([entity.assets.lat lat]); % append
centroids.elevation_m=[entity.assets.elevation_m double(lon*0)]; % append
centroids.centroid_ID=1:length(centroids.lon); % such that IDs in entity match
centroids.onLand=centroids.lon*0;
centroids.onLand(1:length(entity.assets.lon))=1; % SRTM>0 is on land
centroids.admin0_name=entity.assets.admin0_name;
centroids.admin0_ISO3=entity.assets.admin0_ISO3;
centroids.comment=entity.assets.comment;
if isfield(entity.assets,'distance2coast_km')
    fprintf('adding distance2coast_km, does take time (a few minutes, but worth the effort)\n')
    distance2coast_km=climada_distance2coast_km(lon,lat);
    centroids.distance2coast_km=[entity.assets.distance2coast_km double(distance2coast_km)]; % append
end

% add dummy damage functions
entity.damagefunctions= climada_damagefunctions_read(template_entity_filename);

% add dummy measures (to allow for testing only, likely not useful)
entity.measures       = climada_measures_read(template_entity_filename);

% add template discount rates
entity.discount       = climada_discount_read(template_entity_filename);

entity_save_file=[entity.assets.admin0_ISO3 '_' entity.assets.admin0_name '_' entity_filename_ext '_entity'];
entity_save_file=[climada_global.data_dir filesep 'entities' filesep entity_save_file];
% save entity as .mat file for fast access
fprintf('saving entity as %s ...',entity_save_file);
save(entity_save_file,'entity','-v7.3'); % -v7.3 due to (huge) size of the file
fprintf(' done\n');

centroids_save_file=[entity.assets.admin0_ISO3 '_' entity.assets.admin0_name '_' entity_filename_ext '_centroids'];
centroids_save_file=[climada_global.data_dir filesep 'centroids' filesep centroids_save_file];
fprintf('saving centroids as %s ...',centroids_save_file);
save(centroids_save_file,'centroids','-v7.3'); % -v7.3 due to (huge) size of the file
fprintf(' done\n');

end % climada_srtm_entity