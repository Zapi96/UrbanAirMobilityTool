function [airspace] = func_airspace_read(url)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
str = urlread(url);
value = jsondecode(str);

%%  RESULTS
%   Now we select the data that we need
%   We must extract the latitude and longitude of each area
wgs84 = wgs84Ellipsoid('kilometer');

airspace = value.features;
for i = 1:size(airspace,1)
    airspace(i).geometry  = airspace(i).geometry.rings;
    if size(airspace(i).geometry,1)>1
        for j = 1:size(airspace(i).geometry,1)
            airspace(i).latitude(j)  = {airspace(i).geometry{j,1}(:,2)};
            airspace(i).longitude(j) = {airspace(i).geometry{j,1}(:,1)};
            [airspace(i).x(j),airspace(i).y(j)] = geodetic2ecef(wgs84,airspace(i).x(j),airspace(i).y(j),0);
            airspace(i).pgon(j)      = {polyshape(airspace(i).latitude(j),airspace(i).longitude(j))};
            airspace(i).class(j) = airspace(i).attributes(j).CLASS;
            airspace(i).upper(j) = str2double(airspace(i).attributes(j).UPPER_VAL);
            airspace(i).lower(j) = str2double(airspace(i).attributes(j).LOWER_VAL);
        end
    else
        airspace(i).latitude  = airspace(i).geometry(:,:,2);
        airspace(i).longitude = airspace(i).geometry(:,:,1);
        [airspace(i).x,airspace(i).y] = geodetic2ecef(wgs84,airspace(i).latitude,airspace(i).longitude,0);
        airspace(i).pgon      = polyshape(airspace(i).x,airspace(i).y);
        airspace(i).class = airspace(i).attributes.CLASS;
        airspace(i).upper = str2double(airspace(i).attributes.UPPER_VAL);
        airspace(i).lower = str2double(airspace(i).attributes.LOWER_VAL);
    end
    
end
airspace = struct2table(airspace);
end

