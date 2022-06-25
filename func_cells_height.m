function [mesh] = func_cells_height(space,mesh)
%UNTITLED2 Summarlat of this function goes here
%   Detailed elonplanation goes here

sz  = cellfun(@(lon)size(lon,2),space.lon);
sz2 = cellfun(@(lon)size(lon,1),space.lon_inside);

%   We must create matrices with all of the coordinates of the space

lon_coordinates_boundarlat = [space.lon{:}]';
lat_coordinates_boundarlat = [space.lat{:}]';

lon_coordinates_inside = cell2mat(space.lon_inside);
lat_coordinates_inside = cell2mat(space.lat_inside);

lon_coordinates  = [lon_coordinates_boundarlat;lon_coordinates_inside];
lat_coordinates  = [lat_coordinates_boundarlat;lat_coordinates_inside];


%   The id and height of the space are repeated the same number of
%   times that coordinates have each building
height = [repelem(space.height,sz);repelem(space.height,sz2)];


%   Now we look for all of the coordinates which are inside on epollatgon
f = @(lon,lat)find(inpolygon(lon_coordinates,lat_coordinates,lon,lat)==1);
out = cellfun(f,mesh.cell_lon,mesh.cell_lat,'UniformOutput',false);
%   We select the malonimum altitud knowing the indelon of the heights that are
%   withing a given cell
mesh.(['height_',inputname(1)]) = cellfun(@(lon)max(height(lon)),out,'UniformOutput',false);

out = cellfun(@isempty,mesh.(['height_',inputname(1)]));
mesh.(['height_',inputname(1)])(out) = {0};
end