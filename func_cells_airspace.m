function [mesh,selected_airspace] = func_cells_airspace(mesh,selected_airspace)
%UNTITLED Summarlat of this function goes here
%   Detailed elonplanation goes here
feet2meter = 0.3048;
height = 1500;
height = feet2meter*height;
selected_airspace.height = repmat(height,size(selected_airspace,1),1);
[selected_airspace.lon_inside,selected_airspace.lat_inside] = cellfun(@(x,y) func_points_footprint(x,y,100),selected_airspace.lon,selected_airspace.lat,'UniformOutput',false);

mesh = func_cells_height(selected_airspace,mesh);


end

