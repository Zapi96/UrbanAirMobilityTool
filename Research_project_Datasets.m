clear all; close all; clc;
%%  DATASETS

load Data/Commutes/Data_Commutes_Maps3
load Data/Community Area/Data_Community_Area
load Results/Density/Results_Density_Distribution


dest_idx = 1:size(commutes.trip,1);
flight = func_flight_information(commutes,community_area,dest_idx);
flight = struct2table(flight);

commutes_initial_car = cellfun(@(x) commutes.trip(x,:),indx.initial_flight_car,'UniformOutput',false);
commutes_short_car   = cellfun(@(x) commutes.trip(x,:),indx.short_flight_car,'UniformOutput',false);
commutes_long_car    = cellfun(@(x) commutes.trip(x,:),indx.long_flight_car,'UniformOutput',false);

commutes_initial_transit = cellfun(@(x) commutes.trip(x,:),indx.initial_flight_transit,'UniformOutput',false);
commutes_short_transit   = cellfun(@(x) commutes.trip(x,:),indx.short_flight_transit,'UniformOutput',false);
commutes_long_transit    = cellfun(@(x) commutes.trip(x,:),indx.long_flight_transit,'UniformOutput',false);

ids = unique([flight.origin_UAMstops_id;flight.destination_UAMstops_id]);

columns = [ 19 20 21 14 15 8 9 10 3 4];
duration_car = commutes.trip.flight_car_trip(:,7);
duration_transit = commutes.trip.flight_transit_trip(:,7);
trips_data = flight(:,columns);
trips_data = addvars(trips_data,duration_car,'Before','origin_lat');
trips_data = addvars(trips_data,duration_transit,'Before','origin_lat');

for i = 1:size(indx,1)
 
    %   FINAL DATASET
    
    initial{i} = [commutes_hour.flight_car.data{i}(indx.initial_flight_car{i},:);commutes_hour.flight_transit.data{i}(indx.initial_flight_transit{i},:)];
    short{i}   = [commutes_hour.flight_car.data{i}(indx.short_flight_car{i},:);commutes_hour.flight_transit.data{i}(indx.short_flight_transit{i},:)];
    long{i}    = [commutes_hour.flight_car.data{i}(indx.long_flight_car{i},:);commutes_hour.flight_transit.data{i}(indx.long_flight_transit{i},:)];

end

DatasetsUAMstops.initial = [];
DatasetsUAMstops.short = [];
DatasetsUAMstops.long = [];
for i = 1:size(indx,1)
    DatasetsUAMstops.initial = [DatasetsUAMstops.initial;initial{i}];
    DatasetsUAMstops.short   = [DatasetsUAMstops.short;short{i}];
    DatasetsUAMstops.long    = [DatasetsUAMstops.long;long{i}];
end

save('Results/DatasetUAMstops','DatasetsUAMstops')


