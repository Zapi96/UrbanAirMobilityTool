function [mesh] = func_create_mesh(mesh_coordinates,size1)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

wgs84 = wgs84Ellipsoid('kilometer');

north = mesh_coordinates(1);
south = mesh_coordinates(2);
east  = mesh_coordinates(3);
west  = mesh_coordinates(4);


latitude  = [north,north,south,south];
longitude = [east,west,east,west];

wgs84 = wgs84Ellipsoid('meter');

distancelon1 = distance(latitude(1),longitude(1),latitude(2),longitude(2),wgs84);
distancelon2 = distance(latitude(3),longitude(3),latitude(4),longitude(4),wgs84);
distancelat3 = distance(latitude(1),longitude(1),latitude(3),longitude(3),wgs84);
distancelat4 = distance(latitude(2),longitude(2),latitude(4),longitude(4),wgs84);

distancelon = max([distancelon1,distancelon2]);
distancelat = max([distancelat3,distancelat4]);

divisions_lon = ceil(distancelon/size1);
divisions_lat = ceil(distancelat/size1);

lon = linspace(min(longitude),max(longitude),divisions_lon+1);
lat = linspace(min(latitude),max(latitude),divisions_lat+1);
[mesh.lon,mesh.lat] = meshgrid(lon,lat);

for i = 1:size(mesh.lon,1)
    for j = 1:size(mesh.lon,2)
        [mesh.X(i,j),mesh.Y(i,j)] = geodetic2ecef(wgs84,mesh.lat(i,j),mesh.lon(i,j),0);
    end
end
mesh.X = mesh.X/10^3;
mesh.Y = mesh.Y/10^3;

cell = 0;
for i = 1:divisions_lon
    for j = 1:divisions_lat
        cell = cell+1;
        mesh.cell_x{cell,1} = [mesh.X(j,i)  mesh.X(j,i+1)  mesh.X(j+1,i+1) mesh.X(j+1,i) mesh.X(j,i)];
        mesh.cell_y{cell,1} = [mesh.Y(j,i)  mesh.Y(j,i+1)  mesh.Y(j+1,i+1) mesh.Y(j+1,i) mesh.Y(j,i)];
        mesh.pgon_ecef(cell,1)     = polyshape(mesh.cell_x{cell},mesh.cell_y{cell});
        [mesh.centroid_x(cell,1),mesh.centroid_y(cell,1)] = centroid(mesh.pgon_ecef(cell));
        mesh.cell_lon{cell,1} = [mesh.lon(j,i)  mesh.lon(j,i+1)  mesh.lon(j+1,i+1) mesh.lon(j+1,i) mesh.lon(j,i)];
        mesh.cell_lat{cell,1} = [mesh.lat(j,i)  mesh.lat(j,i+1)  mesh.lat(j+1,i+1) mesh.lat(j+1,i) mesh.lat(j,i)];
        mesh.pgon_geo(cell,1)     = polyshape(mesh.cell_lon{cell},mesh.cell_lat{cell});
        [mesh.centroid_lon(cell,1),mesh.centroid_lat(cell,1)] = centroid(mesh.pgon_geo(cell));
        
    end
end


end