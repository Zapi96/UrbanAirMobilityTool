m

%%  UAMstops coordinates
% clear all; clc;
%
% load Data/Data_Community_Area
idx = find(cellfun(@(x) ~isempty(x),{community_area.UAMstops_id}));
latitude = [community_area(idx).UAMstops_lat];
longitude = [community_area(idx).UAMstops_lon];
data_name = [repmat('UAMstop ',length(idx),1),num2str([community_area(idx).UAMstops_id]')];

for i= 1:length(latitude)
    name{i} = data_name(i,:);
    
end
S = geoshape(latitude,longitude);
S.Geometry = 'point';
filename = 'Maps/UAMstops.kml';

kmlwrite(filename,latitude,longitude,'Name',name)

% writematrix(UAMstops_coordinates,'UAMstops_coordinates.csv')

%% Airspace boundaries
clear all; clc;

load Data\Data_Airspace

idx_airspace = find(airspace.upper>1500 & airspace.lower<=1500 & (strcmp(airspace.class,'B') | strcmp(airspace.class,'C') | strcmp(airspace.class,'D') ));
selected_airspace = airspace(idx_airspace,:);

for i = 1:size(selected_airspace,1)
    S(i) = geoshape([selected_airspace.latitude{i}]',[selected_airspace.longitude{i}]');
    S.Geometry = 'polygon';
    name{i} = ['Airspace_',num2str(i),'_Class',selected_airspace.class{i}];
end
filename = ['Maps/Airspace.kml'];
colors = polcmap(length(S));

kmlwrite(filename,S,'Name',name,'FaceColor','r','EdgeColor','r','Alpha',0.5)

%%  BUILDINGS
clear all; clc;
load Data/Data_Buildings_Chicago

heights = buildings.height;

restricted = find(heights>150);

latitude = buildings.lat(restricted);
longitude = buildings.lon(restricted);
building_id =  buildings.building_id(restricted);

for i = 1:size(building_id,1)
    S(i) = geoshape(latitude{i},longitude{i});
    S.Geometry = 'polygon';
    name{i} = ['Building_',num2str(building_id(i))];
end
filename = 'Maps/Buildings.kml';
colors = polcmap(length(S));

kmlwrite(filename,S,'Name',name,'FaceColor','b','EdgeColor','b','Alpha',0.5)

%% FLIGHT PATH
% clear all
clearvars S latitude longitude name
% load Data/Data_Mesh
% load Data/Data_Real_Flight_Path
% load Data/Data_Community_Area

% cells_selected =[cells{10,20};cells{30,15}];
UAMstop_id  = [community_area(:).UAMstops_id];
UAMstop_lat = [community_area(:).UAMstops_lat];
UAMstop_lon = [community_area(:).UAMstops_lon];

i = find(UAMstop_id == 30171);
j = find(UAMstop_id == 30211);

count = 0;
% for i = 1:size(UAMstop_id,2)
%     for j = 1:size(UAMstop_id,2)
% 
%         if i ~= j
count = count +1;
latitude  = [UAMstop_lat(i); mesh.centroid_lat(cell2mat(cells{i,j})); UAMstop_lat(j)];
longitude = [UAMstop_lon(i); mesh.centroid_lon(cell2mat(cells{i,j})); UAMstop_lon(j)];
S(count) = geoshape(latitude,longitude);
S.Geometry = 'line';
name{count} = ['Path ',num2str(UAMstop_id(i)),'-',num2str(UAMstop_id(j))];
%         end
%     end
% end
filename = 'Maps/Path_30171_30211_2.kml';

kmlwrite(filename,S,'Name',name)

%%  MESH UNRESTRICTED
% clear all; clc;
% clearvars name
% load Data/Data_Mesh
clearvars latitude longitude name S


unrestricted = {[41.975425, -87.908030,41.981864, -87.906296,41.987605, -87.818083,41.995325, -87.762479,41.972149, -87.761872,...
    41.981131, -87.818184,41.980483, -87.868439,41.975470, -87.888539];
    [41.849282, -87.720004,41.884513, -87.722911,41.885401, -87.683616,41.849044, -87.682256];
    [41.775620, -87.670189,41.782970, -87.670607,41.784578, -87.614605,41.776497, -87.614005];
    [41.782683, -87.743348,41.790457, -87.743659,41.807163, -87.727658,41.812392, -87.709264,41.813384, -87.633307,...
    41.799999, -87.633116,41.799448, -87.695377,41.796995, -87.715021,41.783010, -87.731554];
    [41.783010, -87.731554,41.809803, -87.676387,41.825426, -87.675431,41.842266, -87.644819,41.855025, -87.659073,...
    41.837471, -87.693573];
    [41.880695, -87.629694,41.883613, -87.629773,41.883598, -87.623616,41.882440, -87.623629,...
    41.882400, -87.627856,41.880699, -87.627878]};


for i = 1:size(unrestricted,1)
    latitude  = unrestricted{i}(1:2:end-1);
    longitude = unrestricted{i}(2:2:end);
    S(i) = geoshape(latitude,longitude);
    S.Geometry = 'polygon';
end

filename = 'Maps/Unrestricted.kml';

kmlwrite(filename,S)

%%  MESH RESTRICTED BUILDINGS
% clear all; clc;
%
% load Data/Data_Mesh
clearvars S
clearvars name

restricted = mesh.restricted_buildings;
latitude  = mesh.cell_lat(restricted);
longitude = mesh.cell_lon(restricted);

for i = 1:size(latitude,1)
    S(i) = geoshape(latitude{i},longitude{i});
    
    name{i} = ['Cell',num2str(i)];
end
S.Geometry = 'polygon';
filename = 'Maps/Restricted_Cells_buildings.kml';

kmlwrite(filename,S,'Name',name,'FaceColor','b','EdgeColor','b','Alpha',0.5)

%%  MESH RESTRICTED FINAL BUILDINGS
% clear all; clc;
%
% load Data/Data_Mesh
clearvars S
clearvars name restricted

restricted = mesh.restricted_buildings;
idx = ismember(restricted,mesh.unrestricted, 'rows');
c = 1:size(restricted, 1);
restricted(idx) = [];

latitude  = mesh.cell_lat(restricted);
longitude = mesh.cell_lon(restricted);

for i = 1:size(latitude,1)
    S(i) = geoshape(latitude{i},longitude{i});
    S.Geometry = 'polygon';
    name{i} = ['Cell',num2str(i)];
end
filename = 'Maps/Restricted_Cells_buildings_unrestricted.kml';

kmlwrite(filename,S,'Name',name,'FaceColor','b','EdgeColor','b','Alpha',0.5)

%%  MESH RESTRICTED FINAL AIRSPACE
clear all; clc;

load Data/Data_Mesh
clearvars S
clearvars name restricted

restricted = mesh.restricted_airspace;
idx = ismember(restricted,mesh.unrestricted, 'rows');
c = 1:size(restricted, 1);
restricted(idx) = [];

latitude  = mesh.cell_lat(restricted);
longitude = mesh.cell_lon(restricted);

sz = length(restricted);
size = ceil(sz/1500);
sz = ceil(sz/size);

for i = 1:size
    if i == size
        interval{i} = (i-1)*sz+1:length(restricted);
    else
        interval{i} = (i-1)*sz+1:sz*i;
    end
    
end

for i = 1:length(interval)
    idx = interval{i};
    for j = 1:length(idx)
        S(j) = geoshape(latitude{idx(j)},longitude{idx(j)});
        
        name{j} = ['Cell',num2str(j)];
        
    end
    S.Geometry = 'polygon';
    filename = ['Maps/Restricted_Cells_airspace_unrestricted',num2str(i),'.kml'];
    kmlwrite(filename,S,'Name',name,'FaceColor','b','EdgeColor','b','Alpha',0.5)
    clearvars S name
end

%%  VERTEX coordinates
clear all; clc;
%
% load Data/Data_Community_Area
north = 42.029179;
south = 41.634702;
east =-87.512888;
west =  -87.952890;

latitude = [42.029179,42.029179,41.634702,41.634702];
longitude = [-87.512888,-87.952890,-87.512888,-87.952890];

wgs84 = wgs84Ellipsoid('kilometer');


S = geoshape(latitude,longitude);
S.Geometry = 'point';
filename = 'Maps/Vertex.kml';

kmlwrite(filename,latitude,longitude)

% writematrix(UAMstops_coordinates,'UAMstops_coordinates.csv')

%% MISSION PROFILE
% clear all; close all;
% %
% load Data/Community/Data_Community_Area
% load Data/Path/Data_Real_Flight_Path

UAMstops_id = [community_area(:).UAMstops_id];
count = 0;


for i = 1:length(UAMstops_id)
    for j = 1:length(UAMstops_id)
        if i ~= j
            count = count+1;
            coordinates = flight_path.distance_vector{i,j}{:};
            latitude = coordinates(1,:);
            longitude = coordinates(2,:);
            altitude = coordinates(3,:);
            name = ['Path ',num2str(UAMstops_id(i)),'-',num2str(UAMstops_id(j))];
            
            filename = ['Maps/Path 3D/Path3D_',num2str(count),'_',name,'.kml'];
            
            kmlwriteline(filename,latitude,longitude,altitude,'Name',name,'LineWidth',2,'Color','b','AltitudeMode','relativeToGround')
            
            winopen(filename)
            
        end
    end
end



% filename = ['Maps/Path3D.kml'];
% kmlwrite(filename,S,'Name',name,'LineWidth',2,'r','EdgeColor','r','AltitudeMode','relativeToGround')


%%  GLIDESLOPE
wgs84 = wgs84Ellipsoid('kilometer');

%   RWY 9R OHARE
name = 'Gliseslope_9R_ohare';
point1 = [41.983895, -87.917901];
point2 = [41.983875, -87.888979];
%   RWY 4R OHARE
name = 'Gliseslope_4R_ohare';
point1 = [41.951903, -87.901349];
point2 = [41.970594, -87.878590];
%   RWY 4R MIDWAY
name = 'Gliseslope_4R_midway';
point1 = [41.778756, -87.759913];
point2 = [41.792082, -87.742789];
%   RWY 13L MIDWAY
name = 'Gliseslope_13L_midway';
point1 = [41.792104, -87.757670];
point2 = [41.782706, -87.744440];


dist = 5.1; % NM
dist = dist*1.852; %km
az = azimuth(point1(1),point1(2),point2(1),point2(2),wgs84);
[latout,lonout] = reckon(point2(1),point2(2),dist,az,wgs84);
alt = 2300*0.305; %m

latitude = [point2(1),latout];
longitude = [point2(2),lonout];
altitude = [0,alt];

filename = ['Maps/Glideslope_',name,'.kml'];

kmlwriteline(filename,latitude,longitude,altitude,'Name',name,'LineWidth',2,'Color','g','AltitudeMode','relativeToGround')

winopen(filename)


