clc; close all; clear all;

load Data\Data_Community_Area


%%  FAA API

% url = 'https://services6.arcgis.com/ssFJjBXIUyZDrSYZ/arcgis/rest/services/Class_Airspace/FeatureServer/0/query?where=1%3D1&outFields=UPPER_VAL,UPPER_UOM,LOWER_VAL,LOWER_UOM,CLASS,LEVEL_,OBJECTID&geometry=-91.796%2C41.294%2C-83.452%2C42.722&geometryType=esriGeometryEnvelope&inSR=4326&spatialRel=esriSpatialRelIntersects&outSR=4326&f=json';
url = "https://services6.arcgis.com/ssFJjBXIUyZDrSYZ/arcgis/rest/services/Class_Airspace/FeatureServer/0/query?outFields=*&where=UPPER(CITY)%20like%20'%25CHICAGO%25'&f=json";
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
save('Data/Airspace/Data_Airspace','airspace')


%%  REPRESENTATION
% load Data\Data_Community_Area
% load Data\Data_Boundaries_Areas
% classes = ['B','C','D','E'];
% blue   = [0, 0.4470, 0.7410];
% orange = [0.8500, 0.3250, 0.0980];
% yellow = [0.9290, 0.6940, 0.1250];
% purple = [0.4940, 0.1840, 0.5560];
% 
% color = [blue;orange;yellow;purple];
% close all
% boundaries_plot(community_area,[],2,[],1,[],'topographic');
% hold on
% cond1 = strcmp(airspace.class,'D');
% % cond2 = strcmp(airspace.class,'B');
% % cond = 1:size(airspace,1);
% selected_airspace = airspace(cond1,:);
% label = [];
% for i = 1:size(selected_airspace,1)
%     if ~isempty(selected_airspace.class{i})
%         selected_color = find(classes==selected_airspace.class{i});
% %         p(i) = plot(selected_airspace.pgon(i),'FaceColor',color(selected_color,:),'FaceAlpha',0.1);
%         p(i) = geoplot(selected_airspace.latitude{i},selected_airspace.longitude{i},'Color',color(selected_color,:),'Linewidth',2);
%         
%                     label = [label; selected_airspace.class{i}];
%     else
% %         p(i) = geoplot(selected_airspace.pgon(i),'FaceAlpha',0.1);
%         p(i) = geoplot(selected_airspace.latitude{i},selected_airspace.longitude{i},'Linewidth',2);
%         
%                     label = [label; selected_airspace.class{i}];
%     end
%     
%     hold on
%     
% end
% [label,ia] = unique(label);
% legend(p(ia),unique(label))