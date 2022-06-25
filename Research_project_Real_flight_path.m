close all; clear all; clc;

%%  LOAD

load Data/Community Area/Data_Community_Area
load Data/Mesh/Data_Mesh

%%  GROUND PATH
wgs84 = wgs84Ellipsoid('kilometer');

UAMstops_id = [community_area(:).UAMstops_id];
UAMstops_lon  = [community_area(:).UAMstops_lon];
UAMstops_lat  = [community_area(:).UAMstops_lat];

restricted = mesh.restricted;
idx = ismember(restricted,mesh.unrestricted, 'rows');
c = 1:size(restricted, 1);
restricted(idx) = []; % is your answer

distance_value          = zeros(length(UAMstops_id));
distance_straight = zeros(length(UAMstops_id));

for i = 1:length(UAMstops_id)
    for j = 1:length(UAMstops_id)
        disp([i,j])
        if i == j
            distance_value(i,j)          = 0;
            distance_straight(i,j) = 0;
            cells{i,j}             = [0];
        else
            [cell1,distance1] = closest_waypoint(UAMstops_id(i),mesh,community_area);
            [cell2,distance2] = closest_waypoint(UAMstops_id(j),mesh,community_area);
            
            [cells{i,j},distance3] = dijkstra(mesh,cell1,cell2,restricted);
            
            distance_value(i,j) = distance3+distance1+distance2;
            
            UAMstop_idx = find(UAMstops_id == UAMstops_id(i));
            coordinates1 = [UAMstops_lon(UAMstop_idx);UAMstops_lat(UAMstop_idx)];
            
            UAMstop_idx = find(UAMstops_id == UAMstops_id(j));
            coordinates2 = [UAMstops_lon(UAMstop_idx);UAMstops_lat(UAMstop_idx)];
            
            distance_straight(i,j) = distance(coordinates1(2),coordinates1(1),coordinates2(2),coordinates2(1),wgs84);
        end
    end
end

save('Data/Path/Data_Real_Flight_Path','distance_value','distance_straight','cells')

distance_value = array2table(distance_value);
distance_straight = array2table(distance_straight);
cells    = array2table(cells);

rownames = cellfun(@(x) num2str(x),num2cell((UAMstops_id)),'UniformOutput',false);
distance_value.Properties.RowNames = rownames;
distance_value.Properties.VariableNames = rownames;

distance_straight.Properties.RowNames = rownames;
distance_straight.Properties.VariableNames = rownames;

cells.Properties.RowNames = rownames;
cells.Properties.VariableNames = rownames;

save('Data/Path/Data_Real_Flight_Path','distance_value','distance_straight','cells')

%%  FLIGHT PATH
load Data/Mesh/Data_Mesh

UAMstops_id = [community_area(:).UAMstops_id];
UAMstops_lat = [community_area(:).UAMstops_lat];
UAMstops_lon = [community_area(:).UAMstops_lon];

total_time         = zeros(length(UAMstops_id));
total_distance_air = zeros(length(UAMstops_id));

area.downtown = [41.913319, -87.671125;41.922200, -87.582652;
    41.850071, -87.581938;41.849353, -87.663303];

area.airport1 = [42.016113, -87.957212; 42.017732, -87.870131;
    41.938740, -87.855120;41.938451, -87.958665];

area.airport2 = [41.798417, -87.770343; 41.800171, -87.726216;
    41.775291, -87.725608;41.774038, -87.773185];
clearvars distance_vector total_time total_distance_air distance_ground_segments

for i = 1:length(UAMstops_id)
    for j = 1:length(UAMstops_id)
        if i == j
            total_time(i,j)               = 0;
            total_distance_air(i,j)       = 0;
            distance_vector{i,j}          = [0];
            distance_ground_segments{i,j} = 0;
        else
            origin      = i;
            destination = j;
            [total_time(i,j),total_distance_air(i,j),distance_vector{i,j},distance_ground_segments{i,j}] = mission_profile(origin,destination,area,distance_value{i,j},distance_straight{i,j},mesh,community_area,cells);
        end
    end
end

distance_vector = array2table(distance_vector);

total_time = total_time/60; % min

rownames = cellfun(@(x) num2str(x),num2cell((UAMstops_id)),'UniformOutput',false);
distance_vector.Properties.RowNames = rownames;
distance_vector.Properties.VariableNames = rownames;

save('Data/Path/Data_Real_Flight_Path','distance_value','distance_straight','cells','total_time','total_distance_air','distance_vector','distance_ground_segments')




