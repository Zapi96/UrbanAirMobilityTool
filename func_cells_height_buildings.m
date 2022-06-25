function [mesh] = func_cells_height_buildings(buildings,mesh)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

sz  = cellfun(@(x)size(x,1),buildings.x);
sz2 = cellfun(@(x)size(x,1),buildings.x_inside);

%   We must create matrices with all of the coordinates of the buildings
x_coordinates  = [cell2mat(buildings.x);cell2mat(buildings.x_inside)];
y_coordinates  = [cell2mat(buildings.y); cell2mat(buildings.y_inside)];

%   The id and height of the buildings are repeated the same number of
%   times that coordinates have each building
height = [repelem(buildings.height,sz) repelem(buildings.height,sz2)];


%   Now we look for all of the coordinates which are inside on epolygon
f = @(x,y)find(inpolygon(x_coordinates,y_coordinates,x,y)==1);
out = cellfun(f,mesh.cell_x,mesh.cell_y,'UniformOutput',false);
%   We select the maximum altitud knowing the index of the heights that are
%   withing a given cell
mesh.height_buildings = cellfun(@(x)max(height(x)),out,'UniformOutput',false);

end

