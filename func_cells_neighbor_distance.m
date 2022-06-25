function [mesh] = func_cells_neighbor_distance(mesh)
%function [mesh] = cell_neighbour_distance(mesh)
%   This function will calculate the distance to the centroid of the
%   neighbor cells
wgs84 = wgs84Ellipsoid('kilometer');

for i = 1:size(mesh.centroid_x,1)
    mesh.distance_ecef{i,1} = func_distance_centroid(mesh.centroid_x(i),mesh.centroid_y(i),...
        mesh.centroid_x(mesh.cell_neighbours{i}),mesh.centroid_y(mesh.cell_neighbours{i}));
    mesh.distance_geo{i,1} = distance(mesh.centroid_lat(i),mesh.centroid_lon(i),...
        mesh.centroid_lat(mesh.cell_neighbours{i}),mesh.centroid_lon(mesh.cell_neighbours{i}),wgs84);
end


end

