function [coordinates] = func_profile(origin,destination,distances_vector,mesh,community_area,cells)
%UNTITLED2 Summary of this function goes here
%   The distances_vector is composed by two componen6tes, the increment in
%   x and the increment in y.

wgs84 = wgs84Ellipsoid('meter');

distances_vector(:,distances_vector(1,:)==0&distances_vector(2,:)==0) = [];

UAMstops_id = [community_area(:).UAMstops_id];

UAMstops_lat = [community_area(:).UAMstops_lat];
UAMstops_lon = [community_area(:).UAMstops_lon];

UAMstop_origin = UAMstops_id(origin);
UAMstop_destination = UAMstops_id(destination);

origin      = [UAMstops_lat(origin);UAMstops_lon(origin)];
destination = [UAMstops_lat(destination);UAMstops_lon(destination)];

cells_numbers = cells{num2str(UAMstop_origin),num2str(UAMstop_destination)}{:};
latitude = mesh.centroid_lat(cells_numbers);
longitude = mesh.centroid_lon(cells_numbers);

points = [[latitude';longitude'],destination];

idx = 2;

distance1 = 0;
distance2 = distances_vector(1,idx);
h = 0;
coordinates = [origin;h];
h = distances_vector(2,1);
coordinates = [coordinates,[origin;h]];
for i =1:size(points,2)
    distance1 = distance1 + distance(coordinates(1,end),coordinates(2,end),points(1,i),points(2,i),wgs84);
    
    alpha = azimuth(coordinates(1,end),coordinates(2,end),points(1,i),points(2,i),wgs84);
    if distance1 < distance2
%         alpha = azimuth(coordinates(1,end),coordinates(2,end),points(1,i+1),points(2,i+1),wgs84);
        dist = distance(coordinates(1,end),coordinates(2,end),points(1,i),points(2,i),wgs84);
        [latout,lonout] = reckon(coordinates(1,end),coordinates(2,end),dist,alpha,wgs84);
        beta = atan(distances_vector(2,idx)/distances_vector(1,idx));
        h = h + tan(beta)*dist;
        coordinates = [coordinates,[latout;lonout;h]];
    else
        dist = distance(coordinates(1,end),coordinates(2,end),points(1,i),points(2,i),wgs84)-(distance1-distance2);
        [latout,lonout] = reckon(coordinates(1,end),coordinates(2,end),dist,alpha,wgs84);
        beta = atan(distances_vector(2,idx)/distances_vector(1,idx));
        if abs(beta) == pi/2
            h = h + distances_vector(2,idx);
        else
            h = h + tan(beta)*dist;
        end
        
        coordinates = [coordinates,[latout;lonout;h]];
        
       
        idx = idx + 1;

        alpha = azimuth(coordinates(1,end),coordinates(2,end),points(1,i),points(2,i),wgs84);
        dist = distance(coordinates(1,end),coordinates(2,end),points(1,i),points(2,i),wgs84);
        [latout,lonout] = reckon(coordinates(1,end),coordinates(2,end),dist,alpha,wgs84);
        beta = atan(distances_vector(2,idx)/distances_vector(1,idx));
        if abs(beta) == pi/2
            h = h + distances_vector(2,idx);
        else
            h = h + tan(beta)*dist;
        end
        coordinates = [coordinates,[latout;lonout;h]];
        
        distance2 = distance2 + distances_vector(1,idx);
        
        
    end
end

% h = distances_vector(2,end-1);
% coordinates = [coordinates,[destination;h]];
h = 0;
coordinates = [coordinates, [destination;h]];



end

