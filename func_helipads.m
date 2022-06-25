function [community_area] = func_helipads(community_area)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

wgs84 = wgs84Ellipsoid('kilometer');

load Data/Boundaries/Data_Boundaries_Areas

helipads = readtable('Data Excel\Helipads.xlsx');
helipads = helipads(:,[2,13,24,26]);

helipads = helipads(strcmp(helipads.Type,'HELIPORT'),:);
helipads.Properties.VariableNames([3,4]) = {'Latitude','Longitude'};

for i = 1:size(helipads,1)
    if strcmp(helipads.Latitude{i}(end),'N')
        helipads.Latitude{i} = str2double(helipads.Latitude{i}(1:end-1))/3600;
    else 
        helipads.Latitude{i} = -str2double(helipads.Latitude{i}(1:end-1))/3600;
    end
    if strcmp(helipads.Longitude{i}(end),'E')
        helipads.Longitude{i} = str2double(helipads.Longitude{i}(1:end-1))/3600;
    else 
        helipads.Longitude{i} = -str2double(helipads.Longitude{i}(1:end-1))/3600;
    end
end    

helipads.Latitude = cell2mat(helipads.Latitude);
helipads.Longitude = cell2mat(helipads.Longitude);


[helipads.x,helipads.y,helipads.z] = geodetic2ecef(wgs84,helipads.Latitude,helipads.Longitude,0);


for i = 1:length(community_area)
    in_helipads = inpolygon(helipads.x,helipads.y,areas.x_vector{i},areas.y_vector{i});
    if sum(in_helipads)~=0
        community_area(i).helipads_x = helipads.x(in_helipads);
        community_area(i).helipads_y = helipads.y(in_helipads);
        community_area(i).helipads_z = helipads.z(in_helipads);
        community_area(i).helipads_lat = helipads.Latitude(in_helipads);
        community_area(i).helipads_lon = helipads.Longitude(in_helipads);
    end
  
end
end

