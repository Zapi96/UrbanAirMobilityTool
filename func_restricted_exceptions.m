function [mesh] = func_restricted_exceptions(mesh,coordinates)
%[mesh] = restricted_exceptions(mesh,coordinates)
%   This function creates a exception in the airspace for the zones of
%   approach and departure for UAMstops which are within an airspace
%   restricted area due to airports. Each row of coordinates_lat and
%   coordinates_lon is going to be a polygon

temp = [];
wgs84 = wgs84Ellipsoid('kilometer');

for i =1:size(coordinates,1)
%     [x_boundary,y_boundary] = geodetic2ecef(wgs84,coordinates{i}(:,1:2:end-1),coordinates{i}(:,2:2:end),0);
    latitude = coordinates{i}(:,1:2:end-1);
    longitude = coordinates{i}(:,2:2:end);
    temp = [temp; find(cellfun(@(x,y) sum(inpolygon(x,y,longitude,latitude))>0,num2cell(mesh.centroid_lon),num2cell(mesh.centroid_lat)))];
end
mesh.unrestricted = temp;
end

