clc; close all; clear all;

%%  READ DATA

filename1  = 'Data Excel/il_od_main_JT00_2017.csv';
filename2  = 'Data Excel/Illinois.csv';
filename3  = 'Data/Community/community_areas.txt';
filename4  = 'Data/Counties/counties_complete.txt';
filename5  = 'Data Excel/2010 Tract to Community Area Equivalency File.csv';
filename6  = 'Data Excel/Population_by_2010_Census_Block.csv';
filename7  = 'Data Excel/CensusTractsTIGER2010.csv';
filename8  = 'Data Excel/CommAreas.csv';
filename9  = 'Data Excel/CTA_-_System_Information_-_List_of__L__Stops.csv';
filename10 = 'Data Excel/CensusBlockTIGER2010.csv';
filename11 = 'Data Excel/Income by Location.csv';

filename = {filename1, filename2, filename3, filename4, filename5, filename6, filename7,filename8,filename9, filename10,filename11};
[data,tracts,areas,blocks] = func_read_data(filename);

save('Data/Data','data')
save('Data/Boundaries/Data_Boundaries_Areas','areas')
save('Data/Boundaries/Data_Boundaries_Blocks','blocks')
save('Data/Boundaries/Data_Boundaries_Tracts','tracts')
clearvars filename1 filename2 filename3 filename4 filename5 filename6 
clearvars filename7 filename8 filename9 filename10 filename11 filename

%%  CALCULATION OF CENTROIDS
[blocks] = func_create_centroids(blocks);
[tracts] = func_create_centroids(tracts);
[areas]  = func_create_centroids(areas);

save('Data/Boundaries/Data_Boundaries_Areas','areas')
save('Data/Boundaries/Data_Boundaries_Blocks','blocks')
save('Data/Boundaries/Data_Boundaries_Tracts','tracts')

%%  COMMUNITY AREAS
%  POPULATION
[community_area,population] = func_community_area(blocks,tracts,areas,data);
clearvars tracts population
% save('Data/Community Area/Data_Population','population')

%  INCOME
county_selected = 31;
[community_area] = func_income(data,community_area,county_selected);

%  HELIPADS
[community_area] = func_helipads(community_area);

%  CLUSTERING
community_area = func_clustering(community_area);

%  STATIONS/UAMSTOPS
[community_area,line] = func_stations(data,areas,community_area);
community_area        = func_UAMstops(community_area);

% save('Data/Community/Data_Community_Area','community_area')
% save('Data/CTA/Data_Lines','line')
clearvars line  areas
%%  COMMUTES
counties_selected.name   = {'Lake';'McHenry';'Kane';'DuPage';'Will';'Cook'};
county_selected = 31;
commutes = func_commutes(counties_selected,data,county_selected,blocks,community_area);

% clearvars data counties_selected county_selected blocks
% save('Data/Commutes/Data_Commutes','commutes')

%  COMMUTES PROBABILITY
filename = 'Data Excel/Travel_trends';
[probability] = func_probability_read(filename);

save('Data/Probability/Data_Probability','probability')
clearvars filename probability

%  CONGESTION FOR CAR COMMUTES
filename = 'Data/Data_Congestion.txt';
[DataCongestion] = func_travel_congestion_read(filename);

save('Data/TomTom/Data_Congestion','DataCongestion')
clearvars filename DataCongestion

%%  MESH
%   AIRSPACE
url = "https://services6.arcgis.com/ssFJjBXIUyZDrSYZ/arcgis/rest/services/Class_Airspace/FeatureServer/0/query?outFields=*&where=UPPER(CITY)%20like%20'%25CHICAGO%25'&f=json";;
[airspace] = func_airspace_read(url);

save('Data/Airspace/Data_Airspace','airspace')
clearvars url

%   BUILDINGS CHICAGO (Takes a lot of time to calculate)
%   This function takes a lot of time to calculate. DO NOT RUN
files_number = 1:54;
folder       = 'Data/Buildings/OSM buildings/building';
[buildings] = func_buildings_read(files_number,folder);

save('Data/Buildings/Data_Buildings_Chicago','buildings')
clearvars folder files_number

%   AIRSPACE MESH
%   Vertices mesh coordinates 
north = 42.029179;
south = 41.634702;
east  = -87.512888;
west  = -87.952890;
%   Vector of vertices
mesh_coordinates = [north,south,east,west];
%   Size of the cells
size = 200; % m^2
%   Mesh creation
mesh = func_create_mesh(mesh_coordinates,size);
%   Conectivity between cells
mesh = func_cells_connectivity(mesh);
%   Distance to the neighbor cells
mesh = func_cells_neighbor_distance(mesh);
%   Heights in cells
mesh = func_cells_height(buildings,mesh);
%   Airspace existence in Chicago (intersection with curise altitude)
idx_airspace      = find(airspace.upper>1500 &... % Intersection 
                    airspace.lower<=1500 & ...
                    (strcmp(airspace.class,'B') | ...
                    strcmp(airspace.class,'C') | ...
                    strcmp(airspace.class,'D') ));
selected_airspace = airspace(idx_airspace,:);
selected_airspace.Properties.VariableNames([3,4]) = {'lat','lon'};

[mesh,selected_airspace] = func_cells_airspace(mesh,selected_airspace);
%   Cells restrictions due to height (airspace and building existence)
heights  = mesh.height_buildings;
heights  = cell2mat(heights);
heights2 = mesh.height_selected_airspace;
heights2 = cell2mat(heights2);

height_limit = 150; 
restricted   = find(heights>150);  % Cells with a height above the limit
restricted2  = find(heights2>150); % Cells with a height above the limit

mesh.restricted_buildings = restricted; %Save in mesh struct
mesh.restricted_airspace  = restricted2;
mesh.restricted           = [restricted;restricted2];
%   Mesh unrestricted cells due to exceptions:
coordinates = {[41.975425, -87.908030,41.981864, -87.906296,41.987605,...
    -87.818083,41.995325, -87.762479,41.972149, -87.761872,...
    41.981131, -87.818184,41.980483, -87.868439,41.975470, -87.888539];
    [41.849282, -87.720004,41.884513, -87.722911,41.885401, -87.683616,41.849044, -87.682256];
    [41.775620, -87.670189,41.782970, -87.670607,41.784578, -87.614605,41.776497, -87.614005];
    [41.782683, -87.743348,41.790457, -87.743659,41.807163, -87.727658,41.812392, -87.709264,41.813384, -87.633307,...
    41.799999, -87.633116,41.799448, -87.695377,41.796995, -87.715021,41.783010, -87.731554];
    [41.783010, -87.731554,41.809803, -87.676387,41.825426, -87.675431,41.842266, -87.644819,41.855025, -87.659073,...
    41.837471, -87.693573];
    [41.880695, -87.629694,41.883613, -87.629773,41.883598, -87.623616,41.882440, -87.623629,...
    41.882400, -87.627856,41.880699, -87.627878]};
mesh = func_restricted_exceptions(mesh,coordinates);

save('Data/Mesh/Data_Mesh','mesh')
save('Data/Airspace/Data_Selected_airspace','selected_airspace')
clearvars restricted restricted2 heights heights2 coordinates selected_airspace
clearvars north south east west idx_airspace

%%  FLIGHT
%   FLIGHT PATH BETWEEN UAMSTOPS (1 day to calculate)
flight_path = func_flight_path(mesh,community_area);

save('Data/Path/Data_Real_Flight_Path','flight_path')
clearvars mesh
%%
%   COMMUTES FLIGHT
dest_idex = 1:size(commutes.trip,1);
%   This function removes those trips which has the same origin and
%   destination UAM Stop from the commutes dataset and provides information
%   about each flight
[commutes_flight,idx] = func_flight_information(commutes,community_area,dest_idex,flight_path);
commutes.trip(idx,:) = [];

save('Data/Commutes/Data_Commutes3','commutes')
save('Data/Commutes/Data_Commutes_flight3','commutes_flight')
clearvars idx dest_idex 

%%  OTP
%   DATA
% load Data/Probability/Data_Probability
data.version = 3;

data.arrival_time     = '9:00';
data.radius_0         = 100; % Initial radius for the search
data.radius_increment = 50;  % Increment of the radius after one circle is done
data.radius_limit     = 1000; % Maximum radius
data.alpha_increment  = 30;  % Increment of the angle on each iteration
%   If we want to compute just some specific trips we can set the starting
%   commute an00d the last commute index:
data.start = 1;
data.ending = size(commutes_flight,1);
[commutes_maps,commutes_flight_maps] = func_OTP_commutes(commutes_flight,commutes,data);

save(['Results/OTP/Version', num2str(data.version),'/Results_Commutes_flight_maps'],'commutes_flight_maps')
save(['Results/OTP/Version', num2str(data.version),'/Results_Commutes_Maps'],...
        'commutes_maps')
clearvars data 
    
%%  DENSITY

version = 3;

load Data/Boundaries/Data_Boundaries_Areas
load Data/TomTom/Data_Congestion
load Data/Probability/Data_Probability
load(['Results/OTP/Version',num2str(version),'/Results_Commutes_Maps'])
load(['Results/OTP/Version',num2str(version),'/Results_Commutes_flight_maps'])

% 
% 
%   INITIALIZATION
%   First we must select the interval of arrival to be studied
duration = 1;                 % Width of the interval in hours
hour_day = 1:24;                 % Hour of arrival

%   For the effective cost we need the value of time and this is going to
%   be related to the hour income
cost.drive   = 0.575; % $/mile (Apoorv data)
cost.transit = 2.5; % $

%   Cost uber:
cost.initial = 5.73; % $/pax-mile
cost.short   = 1.86; % $/pax-mile
cost.long    = 0.44;  % $/pax-mile

ride_sharing = true;

[DatasetsUAMstops,DatasetsDrive,DatasetsTransit,effective_cost,selected_trips,removed_ride_sharing_car,removed_ride_sharing_transit] = func_density(commutes_maps,probability,duration,DataCongestion,cost,commutes_flight_maps,ride_sharing);
mkdir('Results/EffectiveCost',['Version',num2str(version)])
mkdir('Results/Density',['Version',num2str(version)])

save(['Results/EffectiveCost/','Version',num2str(version),'/Results_Effective_cost'],'effective_cost','selected_trips','removed_ride_sharing_car','removed_ride_sharing_transit')
save(['Results/Density/','Version',num2str(version),'/Results_Datasets'],'DatasetsUAMstops','DatasetsDrive','DatasetsTransit')




