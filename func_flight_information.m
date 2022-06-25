function [flight,idx_path0] = func_flight_information(commutes,community_area,dest_idx,flight_path)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
wgs84 = wgs84Ellipsoid('kilometer');

%   INITIALIZATION
flight.destination_x = commutes.trip.block_to_x_centroid(dest_idx);
flight.destination_y = commutes.trip.block_to_y_centroid(dest_idx);

flight.destination_lat = commutes.trip.block_to_lat_centroid(dest_idx);
flight.destination_lon = commutes.trip.block_to_lon_centroid(dest_idx);

ori_idx = dest_idx;

flight.origin_x = commutes.trip.block_from_x_centroid(ori_idx);
flight.origin_y = commutes.trip.block_from_y_centroid(ori_idx);

flight.origin_lat = commutes.trip.block_from_lat_centroid(ori_idx);
flight.origin_lon = commutes.trip.block_from_lon_centroid(ori_idx);

n = length(dest_idx);

path_value         = flight_path.distance_value; % km
path_straight      = flight_path.distance_straight; % km
path_time          = flight_path.total_time; % min
% path_time_straight = flight_path.time_straight;

clearvars commutes ori_idx dest_idx flight_path
%%  DESTINATION
% % elements = length(;
% n =length(commutes.trip.block_to);
% 
elements = n;
% % dest_idx = randsample(n,elements);
% dest_idx = 1:n;



flight.destination_UAMstops_lat  = [community_area.UAMstops_lat]';
flight.destination_UAMstops_lon  = [community_area.UAMstops_lon]';
flight.destination_UAMstops_h  = zeros(length(flight.destination_UAMstops_lat),1);
flight.destination_UAMstops_x  = [community_area.UAMstops_x]';
flight.destination_UAMstops_y  = [community_area.UAMstops_y]';
flight.destination_UAMstops_z  = [community_area.UAMstops_z]';
flight.destination_UAMstops_id = [community_area.UAMstops_id]';


%   SELECTION OF UAMstops
%   Rows: Destinations; Columns: UAMstops
% vector_x = minus(flight.destination_UAMstops_x',flight.destination_x);
% vector_y = minus(flight.destination_UAMstops_y',flight.destination_y);

for i = 1:length(flight.destination_UAMstops_lat)
    distance_destination(:,i) = distance(flight.destination_lat,flight.destination_lon,...
    flight.destination_UAMstops_lat(i),flight.destination_UAMstops_lon(i),wgs84);
end
distance_min = min(distance_destination,[],2);
for i = 1:elements
    [~,Locb(i,1)]     = ismember(distance_min(i),distance_destination(i,:));
end
clearvars distance_destination

%   Coordinates of selected stations
% [lat,lon,h] =  ecef2geodetic(wgs84,flight.destination_UAMstops_x(Locb),flight.destination_UAMstops_y(Locb),flight.destination_UAMstops_z(Locb));

%   The selected stops are saved in the flight matrix
flight.destination_UAMstops_lat = flight.destination_UAMstops_lat(Locb);
flight.destination_UAMstops_lon = flight.destination_UAMstops_lon(Locb);
flight.destination_UAMstops_h   = flight.destination_UAMstops_h(Locb);
flight.destination_UAMstops_x   = flight.destination_UAMstops_x(Locb);
flight.destination_UAMstops_y   = flight.destination_UAMstops_y(Locb);
flight.destination_UAMstops_z   = flight.destination_UAMstops_z(Locb);
flight.destination_UAMstops_id  = flight.destination_UAMstops_id(Locb);
%   The selected stops are also saved in the commutes matrix
% commutes.destination_UAMstops_lat = flight.destination_UAMstops_lat(Locb);
% commutes.destination_UAMstops_lon = flight.destination_UAMstops_lon(Locb);
% commutes.destination_UAMstops_h   = flight.destination_UAMstops_h(Locb);
% commutes.destination_UAMstops_x   = flight.destination_UAMstops_x(Locb);
% commutes.destination_UAMstops_y   = flight.destination_UAMstops_y(Locb);
% commutes.destination_UAMstops_z   = flight.destination_UAMstops_z(Locb);
% commutes.destination_UAMstops_id  = flight.destination_UAMstops_id(Locb);
% 
% clearvars flight
clearvars Locb
%%  ORIGIN



flight.origin_UAMstops_lat  = [community_area.UAMstops_lat]';
flight.origin_UAMstops_lon  = [community_area.UAMstops_lon]';
flight.origin_UAMstops_h  = zeros(length(flight.origin_UAMstops_lat),1);
flight.origin_UAMstops_x  = [community_area.UAMstops_x]';
flight.origin_UAMstops_y  = [community_area.UAMstops_y]';
flight.origin_UAMstops_z  = [community_area.UAMstops_z]';
flight.origin_UAMstops_id = [community_area.UAMstops_id]';


%   SELECTION OF UAMstops
%   Rows: origins; Columns: UAMstops
% vector_x = minus(flight.origin_UAMstops_x',flight.origin_x);
% vector_y = minus(flight.origin_UAMstops_y',flight.origin_y);

for i = 1:length(flight.origin_UAMstops_lat)
    distance_origin(:,i) = distance(flight.origin_lat,flight.origin_lon,...
    flight.origin_UAMstops_lat(i),flight.origin_UAMstops_lon(i),wgs84);
end
distance_min = min(distance_origin,[],2);
% distance     = sqrt(vector_x.^2+vector_y.^2);
% distance_min = min(distance,[],2);
for i = 1:elements
    [~,Locb(i,1)] = ismember(distance_min(i),distance_origin(i,:));
end
clearvars distance_origin  distance_min
% %   Coordinates of selected stations
% [lat,lon,h] =  ecef2geodetic(wgs84,flight.origin_UAMstops_x(Locb),flight.origin_UAMstops_y(Locb),flight.origin_UAMstops_z(Locb));
%   The selected stops are saved in the flight matrix
flight.origin_UAMstops_lat = flight.origin_UAMstops_lat(Locb);
flight.origin_UAMstops_lon = flight.origin_UAMstops_lon(Locb);
flight.origin_UAMstops_h   = flight.origin_UAMstops_h(Locb);
flight.origin_UAMstops_x   = flight.origin_UAMstops_x(Locb);
flight.origin_UAMstops_y   = flight.origin_UAMstops_y(Locb);
flight.origin_UAMstops_z   = flight.origin_UAMstops_z(Locb);
flight.origin_UAMstops_id  = flight.origin_UAMstops_id(Locb);
%   The selected stops are also saved in the commutes matrix
% commutes.origin_UAMstops_lat = flight.origin_UAMstops_lat(Locb);
% commutes.origin_UAMstops_lon = flight.origin_UAMstops_lon(Locb);
% commutes.origin_UAMstops_h   = flight.origin_UAMstops_h(Locb);
% commutes.origin_UAMstops_x   = flight.origin_UAMstops_x(Locb);
% commutes.origin_UAMstops_y   = flight.origin_UAMstops_y(Locb);
% commutes.origin_UAMstops_z   = flight.origin_UAMstops_z(Locb);
% commutes.origin_UAMstops_id  = flight.origin_UAMstops_id(Locb);
clearvars Locb
%%  FLIGHT PATH 

% flight_path = [flight.destination_UAMstops_x-flight.origin_UAMstops_x flight.destination_UAMstops_y-flight.origin_UAMstops_y];
UAMstops_id = [community_area(:).UAMstops_id];

[~,loc_origin]      = ismember(flight.origin_UAMstops_id,UAMstops_id);
[~,loc_destination] = ismember(flight.destination_UAMstops_id,UAMstops_id);


% miles2km             = 1.61;
flight.path_distance = zeros(length(loc_origin),1);
flight.path_distance_straight = zeros(length(loc_origin),1);

mph2km = 1.60934;
speed = 150*mph2km;
for i = 1:length(loc_origin)
    flight.path_distance(i)         = path_value{loc_origin(i),loc_destination(i)}; %km
    flight.path_distance_straight(i)= path_straight{loc_origin(i),loc_destination(i)};
    flight.path_time(i,1)     = path_time(loc_origin(i),loc_destination(i)); %km
    flight.path_time_straight(i,1)       = flight.path_distance_straight(i)/speed*60; % min
end

% speed_vehicle        = 150*miles2km; %mph



%%  REMOVE FLIGHT PATH WITH 0 DISTANCE
idx_path0 = flight.path_distance==0;
%   We must remove those coordinates which only use one UAMstops
flight.origin_UAMstops_lat(idx_path0) = [];
flight.origin_UAMstops_lon(idx_path0) = [];
flight.origin_UAMstops_h(idx_path0)   = [];
flight.origin_UAMstops_x(idx_path0)   = [];
flight.origin_UAMstops_y(idx_path0)   = [];
flight.origin_UAMstops_z(idx_path0)   = [];
flight.origin_UAMstops_id(idx_path0)   = [];


flight.destination_UAMstops_lat(idx_path0) = [];
flight.destination_UAMstops_lon(idx_path0) = [];
flight.destination_UAMstops_h(idx_path0)   = [];
flight.destination_UAMstops_x(idx_path0)   = [];
flight.destination_UAMstops_y(idx_path0)   = [];
flight.destination_UAMstops_z(idx_path0)   = [];
flight.destination_UAMstops_id(idx_path0)   = [];


flight.destination_x(idx_path0)   = [];
flight.destination_y(idx_path0)   = [];
flight.destination_lat(idx_path0) = [];
flight.destination_lon(idx_path0) = [];

flight.origin_x(idx_path0)   = [];
flight.origin_y(idx_path0)   = [];
flight.origin_lat(idx_path0) = [];
flight.origin_lon(idx_path0) = [];

flight.path_time(idx_path0)     = [];
flight.path_time_straight(idx_path0)     = [];

flight.path_distance(idx_path0) = [];
flight.path_distance_straight(idx_path0) = [];

flight.time2wait    = repmat(2,length(flight.path_time),1); %min
flight.time2warmup  = repmat(2,length(flight.path_time),1); %min
flight.time2board   = repmat(4,length(flight.path_time),1); %min
flight.time2deboard = repmat(4,length(flight.path_time),1); %min

flight.flight_path_time_total = flight.time2wait+flight.time2warmup+flight.time2board+flight.time2deboard+flight.path_time;
flight = struct2table(flight);


end