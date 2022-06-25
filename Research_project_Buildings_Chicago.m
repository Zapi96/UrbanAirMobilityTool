clc; close all; clear all;

%%  CHICAGO BOUNDARY DATA
fileID = fopen('api_token_chicago.txt');
api_key = fscanf(fileID,'%c') ;
fclose(fileID);

url = ['http://data.cityofchicago.org/resource/qqq8-j68g.json?%24%24app_token=',api_key];

str = urlread(url);
value = jsondecode(str);

chicago.longitude = value.the_geom.coordinates{2,1}{1,1}(:,1);
chicago.latitude = value.the_geom.coordinates{2,1}{1,1}(:,2);

clearvars url str value api_key fileID ans

%%  BUILDINGS

files_number = 1:54;

buildings = [];
for i = 1:length(files_number)
    disp(i)
    out = buildings_read(['Data/Buildings/OSM buildings/building',num2str(files_number(i)),'.txt']);
    positions = cellfun(@(x)isfield(x,'geometry'),out.elements);
    out = out.elements(positions);
    positions = cellfun(@(x)inpolygon([x.geometry.lat]',[x.geometry.lon]',chicago.latitude,chicago.longitude),out,'UniformOutput',0);
    positions = cellfun(@(x)sum(x),positions) == cellfun(@(x)length(x),positions);
    buildings = [buildings ;out(positions)];
end

save('Data/Buildings/buildings_OSM','buildings')

clearvars out positions

fields = {'type','id','bounds','nodes'};

buildings = cellfun(@(x)rmfield(x,fields),buildings,'UniformOutput',false);

out_tags       = cellfun(@(x)find(isfield(x,'tags')),buildings,'un',0);
positions = ~cellfun(@isempty,out_tags);
buildings = buildings(positions);
clearvars out_tags positions

table.building_number(:,1) = 1:size(buildings,1);
table =struct2table(table);

out_building_id       = cellfun(@(x)find(isfield(x.tags,'chicago_building_id')),buildings,'un',0);
positions = ~cellfun(@isempty,out_building_id);
building_id = cellfun(@(x)x.tags.chicago_building_id,buildings(positions),'UniformOutput',false);
building_id = cellfun(@str2double,building_id);
table.building_id(positions) = building_id;
clearvars out_building_id building_id 

out_level = cellfun(@(x)(find(isfield(x.tags,'building_levels'))),buildings,'un',0);
positions_level = find(~cellfun(@isempty,out_level));
levels = cellfun(@(x)x.tags.building_levels,buildings(positions_level),'UniformOutput',false);
levels = cellfun(@str2double,levels);
table.levels(positions_level,1) = levels;
clearvars  levels 

out_level = cellfun(@(x)(find(isfield(x.tags,'roof_levels'))),buildings,'un',0);
positions_level2 = find(~cellfun(@isempty,out_level));
levels = cellfun(@(x)x.tags.roof_levels,buildings(positions_level2),'UniformOutput',false);
levels = cellfun(@str2double,levels);
[~,~,ib] = intersect(positions_level,positions_level2);
positions_level2(ib) = [];
levels(ib) = [];
table.levels(positions_level2) = levels;
clearvars  levels out_level positions_level positions_level2

out_height = cellfun(@(x)find(isfield(x.tags,'building_height')),buildings,'un',0);
positions_height = find(~cellfun(@isempty,out_height));
height = cellfun(@(x)x.tags.building_height,buildings(positions_height),'UniformOutput',false);
height = cellfun(@(x)regexp(x,'\d+(\.)?(\d+)?','Match'),height,'UniformOutput',false);
height = cellfun(@str2double,height);
table.height(positions_height) = height;
clearvars  height out_height

out_height2 = cellfun(@(x)find(isfield(x.tags,'height')),buildings,'un',0);
positions_height2 = find(~cellfun(@isempty,out_height2));
height2 = cellfun(@(x)x.tags.height,buildings(positions_height2),'UniformOutput',false);
height2 = cellfun(@(x)regexp(x,'\d+(\.)?(\d+)?','Match'),height2,'UniformOutput',false);
height2 = cellfun(@str2double,height2);
[~,~,ib] = intersect(positions_height,positions_height2);
positions_height2(ib) = [];
height2(ib) = [];
table.height(positions_height2) = height2;
clearvars  out_height2 height2 positions_height positions_height2 

table.lat = cellfun(@(x)[x.geometry.lat],buildings,'UniformOutput',false);
table.lon = cellfun(@(x)[x.geometry.lon],buildings,'UniformOutput',false);

save('Data/Buildings/table','table')

%%  HEIGHT FROM FLOORS

standard_height = 2.5;
out_height = find(table.height ==0);
table.height(out_height) = table.levels(out_height)*standard_height;

wgs84 = wgs84Ellipsoid('kilometer');

fun = @(x,y)geodetic2ecef(wgs84,x,y,0);
[table.x,table.y,table.z] = cellfun(fun, table.lat,table.lon,'UniformOutput',false);

[table.x_inside,table.y_inside] = cellfun(@(x,y) func_points_footprint(x,y,100),table.x,table.y,'UniformOutput',false);
[table.lon_inside,table.lat_inside] = cellfun(@(x,y) func_points_footprint(x,y,100),buildings.lon,buildings.lat,'UniformOutput',false);


save('Data/Buildings/table','table')

buildings = table;

save('Data/Buildings/Data_Buildings_Chicago','buildings')