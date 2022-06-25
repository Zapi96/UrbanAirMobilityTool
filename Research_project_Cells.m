clc; clear all;


%%  MESH
close all;

north = 42.029179;
south = 41.634702;
east =-87.512888;
west =  -87.952890;

mesh_coordinates = [north,south,east,west];

size1 = 200;

[mesh] = func_create_mesh(mesh_coordinates,size1);


mesh = func_cells_connectivity(mesh);
mesh = func_cells_neighbor_distance(mesh);

% load Data/Data_Community_Area
% boundaries_population_areas(community_area,[],'UAMstops',1:77,'Areas',[],[],2,'topographic')
% hold on
% for i = 1:size(mesh.cell_lat,1)
%     geoplot(mesh.cell_lat{i},mesh.cell_lon{i})
% end
% 
% boundaries_population_areas(community_area,[],'UAMstops',1:77,'Areas','ecef',[],2,[])
% hold on
% for i = 1:size(mesh.cell_lat,1)
%     plot(mesh.cell_x{i},mesh.cell_y{i})
% end
% clearvars community_area


% save('Data/Data_Mesh','mesh')

%%  HEIGHTS
load Data/Buildings/Data_Buildings_Chicago
mesh = func_cells_height(buildings,mesh);

% save('Data/Data_Mesh','mesh')

%%  AIRSPACE

load Data/Airspace/Data_Airspace

idx_airspace = find(airspace.upper>1500 & airspace.lower<=1500 & (strcmp(airspace.class,'B') | strcmp(airspace.class,'C') | strcmp(airspace.class,'D') ));
selected_airspace = airspace(idx_airspace,:);
selected_airspace.Properties.VariableNames([3,4]) = {'lat','lon'};

[mesh,selected_airspace] = func_cells_airspace(mesh,selected_airspace);

% save('Data/Data_Mesh','mesh')

%%  MESH RESTRICTED

heights = mesh.height_buildings;
heights = cell2mat(heights);
heights2 = mesh.height_selected_airspace;
heights2 = cell2mat(heights2);

restricted = find(heights>150);
restricted2 = find(heights2>150);

mesh.restricted_buildings = restricted;
mesh.restricted_airspace = restricted2;

mesh.restricted = [restricted;restricted2];

coordinates = {[41.975425, -87.908030,41.981864, -87.906296,41.987605, -87.818083,41.995325, -87.762479,41.972149, -87.761872,...
    41.981131, -87.818184,41.980483, -87.868439,41.975470, -87.888539];
    [41.849282, -87.720004,41.884513, -87.722911,41.885401, -87.683616,41.849044, -87.682256];
    [41.775620, -87.670189,41.782970, -87.670607,41.784578, -87.614605,41.776497, -87.614005];
    [41.782683, -87.743348,41.790457, -87.743659,41.807163, -87.727658,41.812392, -87.709264,41.813384, -87.633307,...
    41.799999, -87.633116,41.799448, -87.695377,41.796995, -87.715021,41.783010, -87.731554];
    [41.783010, -87.731554,41.809803, -87.676387,41.825426, -87.675431,41.842266, -87.644819,41.855025, -87.659073,...
    41.837471, -87.693573];
    [41.880695, -87.629694,41.883613, -87.629773,41.883598, -87.623616,41.882440, -87.623629,...
    41.882400, -87.627856,41.880699, -87.627878]};



[mesh] = func_restricted_exceptions(mesh,coordinates);


save('Data/Mesh/Data_Mesh','mesh')

%%  REPRESENTATION

% % load Data/Data_Mesh
% % load Data/Data_Community_Area
% 
% boundaries_plot(community_area,[],2,[],[],[],'topographic');
% hold on
% 
% for i = 1:size(mesh.cell_lat,1)
%     geoplot(mesh.cell_lat{i},mesh.cell_lon{i},'-k')
% end
        
